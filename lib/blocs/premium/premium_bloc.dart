import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oqyul/repositories/premium_repository.dart';
part 'premium_event.dart';
part 'premium_state.dart';

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  final PremiumRepository premiumRepository;

  PremiumBloc({required this.premiumRepository}) : super(PremiumInitial()) {
    on<PremiumCheckStatus>(_onCheckStatus);
    on<PremiumWatchAd>(_onWatchAd);
    on<PremiumActivate>(_onActivate);
    on<PremiumExpire>(_onExpire);
    on<PremiumExtend>(_onExtend);
  }

  void _onCheckStatus(PremiumCheckStatus event, Emitter<PremiumState> emit) async {
    emit(PremiumLoading());
    final status = await premiumRepository.getPremiumStatus();
    if (status.isExpired) {
      emit(PremiumInactive(adsWatched: status.adsWatched));
    } else {
      emit(PremiumActive(expiryDate: status.expiryDate!));
    }
  }

  void _onWatchAd(PremiumWatchAd event, Emitter<PremiumState> emit) async {
    if (state is PremiumActive) {
      await premiumRepository.extendPremiumByHours(3);
      final status = await premiumRepository.getPremiumStatus();
      emit(PremiumActive(expiryDate: status.expiryDate!));
    } else {
      emit(PremiumLoading());
      final adsWatched = await premiumRepository.incrementAdsWatched();
      if (adsWatched >= 6) {
        add(PremiumActivate());
      } else {
        emit(PremiumAdsInProgress(adsWatched: adsWatched));
      }
    }
  }


  void _onActivate(PremiumActivate event, Emitter<PremiumState> emit) async {
    emit(PremiumLoading());
    await premiumRepository.activatePremium();
    final status = await premiumRepository.getPremiumStatus();
    emit(PremiumActive(expiryDate: status.expiryDate!));
  }

  void _onExpire(PremiumExpire event, Emitter<PremiumState> emit) async {
    await premiumRepository.expirePremium();
    emit(PremiumInactive(adsWatched: 0));
  }

  void _onExtend(PremiumExtend event, Emitter<PremiumState> emit) async {
    if (state is PremiumActive) {
      await premiumRepository.extendPremiumByHours(3);
      final status = await premiumRepository.getPremiumStatus();
      emit(PremiumActive(expiryDate: status.expiryDate!));
    } else {
    }
  }
}
