// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "language": "English",
  "nextStep": "Next Step",
  "chooseALanguage": "Select a language",
  "chooseLanguageMessage": "Please select the language used in the app",
  "nickName": "Nick Name",
  "changeName": "change name",
  "appSettings": "App settings",
  "changeInterface": "change interface",
  "changeMode": "change mode",
  "changeLanguage": "change language",
  "home": "Home",
  "setting": "Setting",
  "contactUs": "Contact Us",
  "signOut": "Sign Out"
};
static const Map<String,dynamic> ja = {
  "language": "Japanese",
  "nextStep": "次のステップ",
  "chooseALanguage": "言語を選択する",
  "chooseLanguageMessage": "アプリで使用する言語を選択してください",
  "nickName": "ニックネーム",
  "changeName": "名前を変更",
  "appSettings": "アプリの設定",
  "changeInterface": "インターフェースの変更",
  "changeMode": "モード変更",
  "changeLanguage": "言語を変更",
  "home": "ホーム",
  "setting": "設定",
  "contactUs": "お問い合わせ",
  "signOut": "サインアウト"
};
static const Map<String,dynamic> zh_Hans = {
  "language": "zh",
  "nextStep": "下一步",
  "chooseALanguage": "选择语言",
  "chooseLanguageMessage": "请选择用于应用中的语言",
  "nickName": "昵称",
  "changeName": "更改名称",
  "appSettings": "应用设置",
  "changeInterface": "改变界面",
  "changeMode": "改变模式",
  "changeLanguage": "更改语言",
  "home": "主页",
  "setting": "设定",
  "contactUs": "联系我们",
  "signOut": "登出"
};
static const Map<String,dynamic> zh_Hant = {
  "language": "zh",
  "nextStep": "下一步",
  "chooseALanguage": "選擇語言",
  "chooseLanguageMessage": "請選擇用於應用中的語言",
  "nickName": "暱稱",
  "changeName": "更改名稱",
  "appSettings": "應用設置",
  "changeInterface": "改變界面",
  "changeMode": "改變模式",
  "changeLanguage": "更改語言",
  "home": "主頁",
  "setting": "設定",
  "contactUs": "聯繫我們",
  "signOut": "登出"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "ja": ja, "zh_Hans": zh_Hans, "zh_Hant": zh_Hant};
}
