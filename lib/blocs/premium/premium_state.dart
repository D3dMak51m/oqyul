part of 'premium_bloc.dart';

abstract class PremiumState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PremiumInitial extends PremiumState {}

class PremiumLoading extends PremiumState {}

class PremiumActive extends PremiumState {
  final DateTime expiryDate;

  PremiumActive({required this.expiryDate});

  @override
  List<Object?> get props => [expiryDate];
}

class PremiumInactive extends PremiumState {
  final int adsWatched;

  PremiumInactive({required this.adsWatched});

  @override
  List<Object?> get props => [adsWatched];
}

class PremiumAdsInProgress extends PremiumState {
  final int adsWatched;

  PremiumAdsInProgress({required this.adsWatched});

  @override
  List<Object?> get props => [adsWatched];
}

class PremiumError extends PremiumState {
  final String error;

  PremiumError({required this.error});

  @override
  List<Object?> get props => [error];
}
