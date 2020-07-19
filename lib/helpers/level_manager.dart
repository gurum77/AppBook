import 'package:appbook/data/static_data.dart';
import 'dart:math';

class LevelManager {
  // https://docs.google.com/spreadsheets/d/1NNl7ZKBP4A7cypmPCZDTwsfF0dad_aZIFJvKlc9DU3g/edit#gid=677066334
  // factor	0.2
  // 레벨	경험치
  // 1	25
  // 2	100
  // 3	225
  // 4	400
  // 5	625
  // 6	900
  // 7	1225
  // 8	1600
  // 9	2025
  // 10	2500
  static double factor = 0.2;

  // 현재 exp를 계산해서 리턴
  static int getExp() {
    int exp = 0;
    if (StaticData.userData.like != null && StaticData.env.envExp.like != null)
      exp += (StaticData.userData.like * StaticData.env.envExp.like);

    if (StaticData.userData.unlike != null &&
        StaticData.env.envExp.unlike != null)
      exp += (StaticData.userData.unlike * StaticData.env.envExp.unlike);

    if (StaticData.userData.reply != null &&
        StaticData.env.envExp.reply != null)
      exp += (StaticData.userData.reply * StaticData.env.envExp.reply);

    return exp;
  }

  // 현재 레벨을 계산해서 리턴
  static int getLevel() {
    int exp = getExp();
    double dlevel = sqrt(exp) * factor;
    int level = dlevel.round();
    if (exp > calcExpForNextLevel(level)) level++;

    return level;
  }

  // 다음 레벨을 위한 경험치
  static int calcExpForNextLevel(int level) {
    return (pow(level / factor, 2)).toInt();
  }

// 다음 레벨까지 남은 경험치 비율
  static double calcRemainExpRateForNextLevel() {
    // 현재 레벨까지 필요한 경험치
    int expForCurLevel = calcExpForNextLevel(getLevel() - 1);

    // 다음 레벨까지 필요한 경험치
    int expForNextLevel = calcExpForNextLevel(getLevel());

    // 현재 경험치
    int exp = getExp();

    return (exp - expForCurLevel) / (expForNextLevel - expForCurLevel);
  }
}
