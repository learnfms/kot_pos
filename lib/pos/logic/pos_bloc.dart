class POSBloc extends Bloc<POSEvent, POSState> {
  final POSRepository _repository;
  
  POSBloc(this._repository) : super(POSInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(POSLoading());
      try {
        final products = await _repository.getAllProducts();
        emit(POSLoaded(products));
      } catch (e) {
        emit(POSError(e.toString()));
      }
    });
  }
}

// States and Events would be defined here
