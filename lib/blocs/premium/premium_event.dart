part of 'premium_bloc.dart';

abstract class PremiumEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PremiumCheckStatus extends PremiumEvent {}

class PremiumWatchAd extends PremiumEvent {}

class PremiumActivate extends PremiumEvent {}

class PremiumExpire extends PremiumEvent {}

class PremiumExtend extends PremiumEvent {}
