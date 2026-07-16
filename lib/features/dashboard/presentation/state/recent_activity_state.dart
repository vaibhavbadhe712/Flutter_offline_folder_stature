import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recent_activity_entity.dart';

part 'recent_activity_state.freezed.dart';

@freezed
class RecentActivityState with _$RecentActivityState {
  const factory RecentActivityState.initial() = _Initial;
  const factory RecentActivityState.loading() = _Loading;
  const factory RecentActivityState.loaded(List<RecentActivityEntity> activities) = _Loaded;
  const factory RecentActivityState.error(String message) = _Error;
}
