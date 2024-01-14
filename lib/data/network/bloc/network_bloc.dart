import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(NetworkInitial()) {
    on<NetworkNotify>(_notifyStatus);
  }

  void _notifyStatus(NetworkNotify event, emit) async {
    // var connectivityResult = await (Connectivity().checkConnectivity());

    // if(connectivityResult != ConnectivityResult.none){
    //   emit(NetworkSuccess());
    // }else{
    //   emit(NetworkFailure());
    // }
    // Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   if (result == ConnectivityResult.none) {
    //     emit(NetworkFailure());
    //   } else {
    //     emit(NetworkSuccess());
    //   }
    // });
  }
}
