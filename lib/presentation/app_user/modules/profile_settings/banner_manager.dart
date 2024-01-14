import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ot_registration/app/constants/gaps.dart';
import 'package:ot_registration/app/helper/widgets/shimmer_card.dart';
import 'package:ot_registration/data/network/utils/references.dart';
import 'package:ot_registration/helper/utils/toast.dart';

class BannerManagementPage extends StatefulWidget {
  const BannerManagementPage({super.key});

  @override
  State<BannerManagementPage> createState() => _BannerManagementPageState();
}

class _BannerManagementPageState extends State<BannerManagementPage> {
  bool loading = true;
  List<String> banners = [];
  final repo = FirebaseReferences();

  @override
  void initState() {
    super.initState();
    fetchBanners();
  }

  void showLoading() {
    if (loading)
      return;
    else {
      setState(() {
        loading = true;
      });
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Loading'),
        content: Text('Please wait...'),
      ),
    );
  }

  void cancelLoading() {
    if (!loading) return;
    Navigator.pop(context);
    setState(() {
      loading = false;
    });
  }

  Future fetchBanners() async {
    var result = await repo.bannerDoc.get();
    var bannerConfig = result.data() as Map;
    banners = (bannerConfig['banners'] as List).cast<String>();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Banner Management'),
      ),
      body: loading
          ? ShimmerCard()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 4,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('Banner ${index + 1}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                bool? canDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Delete Banner'),
                                    content: Text(
                                        'Are you sure you want to delete this banner?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: Text('Yes'),
                                      ),
                                    ],
                                  ),
                                );
                                if (canDelete != null && canDelete) {
                                  showLoading();
                                  Navigator.pop(context, true);
                                  try {
                                    await FirebaseStorage.instance
                                        .refFromURL(banners[index])
                                        .delete();
                                  } catch (e) {
                                    if (kDebugMode) {
                                      print(e);
                                    }
                                  }
                                  banners.removeAt(index);
                                  syncBanners();
                                }
                              },
                            ),
                          ),
                          Image.network(
                            banners[index],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: banners.length,
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: pickImage,
        label: Row(
          children: [
            Icon(Icons.add),
            gapW8,
            Text('Add Banner'),
          ],
        ),
      ),
    );
  }

  Future syncBanners() async {
    showLoading();
    await repo.bannerDoc.set({'banners': banners});
    cancelLoading();
  }

  Future pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        cropStyle: CropStyle.rectangle,
        aspectRatioPresets: [
          // CropAspectRatioPreset.square,
          // CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset.ratio7x5,
          // CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
          // CropAspectRatioPreset.original,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );
      if (croppedFile != null) {
        // upload file to firebase storage
        showLoading();
        var ref = FirebaseReferences.bannerStorage()
            .child(DateTime.now().millisecondsSinceEpoch.toString());

        banners.add(await (await ref.putFile(File(croppedFile.path)))
            .ref
            .getDownloadURL());

        await syncBanners();
      }
    } catch (e, s) {
      if (kDebugMode) {
        print('$e $s');
      }
      showToast(
        context,
        message: e.toString(),
        success: true,
      );
    }
  }
}
