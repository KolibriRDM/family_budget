/// Generated file. Do not edit.
///
/// Original: assets/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 524 (262 per locale)
///
/// Built on 2026-05-22 at 09:51 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.ru;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.ru) // set locale
/// - Locale locale = AppLocale.ru.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.ru) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	ru(languageCode: 'ru', build: Translations.build),
	en(languageCode: 'en', build: _StringsEn.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ru>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	late final _StringsAuthRu auth = _StringsAuthRu._(_root);
	late final _StringsProfileRu profile = _StringsProfileRu._(_root);
	late final _StringsDiagramRu diagram = _StringsDiagramRu._(_root);
	late final _StringsCalculatorRu calculator = _StringsCalculatorRu._(_root);
	late final _StringsSettingsRu settings = _StringsSettingsRu._(_root);
	late final _StringsReceiptScanRu receiptScan = _StringsReceiptScanRu._(_root);
	late final _StringsCategoriesRu categories = _StringsCategoriesRu._(_root);
	late final _StringsApiRu api = _StringsApiRu._(_root);
	late final _StringsCurrencyRu currency = _StringsCurrencyRu._(_root);
	late final _StringsGeneralRu general = _StringsGeneralRu._(_root);
}

// Path: auth
class _StringsAuthRu {
	_StringsAuthRu._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get authTitle => 'Авторизация';
	String get welcome => 'Добро пожаловать в ваш личный помощник финансов! Контролируйте свой бюджет и ваши расходы!';
	String get signInBtn => 'Войти';
	String get registerBtn => 'Зарегистрироваться';
	String get signInTitle => 'Вход';
	String get registerTitle => 'Регистрация';
	String get startBalance => 'Начальный баланс';
	String get currency => 'Валюта';
	String get continueBtn => 'Продолжить';
	String get changeAllFieldsErr => 'Заполните все поля!';
	String get passwordsEqualsErr => 'Пароли не совпадают!';
	String get login => 'Логин';
	String get loginBusy => 'Данный логин занят';
	String get password => 'Пароль';
	String get verifyPassword => 'Подтвердите пароль';
	String get loginOrPassNotValidErr => 'Неправильный логин или пароль';
}

// Path: profile
class _StringsProfileRu {
	_StringsProfileRu._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get profile => 'Профиль';
	String get addExpensesBtn => 'Добавить расходы';
	String get addIncomesBtn => 'Добавить доходы';
	String get incomes => 'Доходы';
	String get balance => 'Баланс';
	String get noIncomes => 'Доходов пока не было';
	String get deleteBtn => 'Удалить';
	String get changeBtn => 'Изменить';
	String get deletingIncome => 'Удаление дохода';
	String get youSureDeleteExpense => 'Вы точно хотите удалить доход от ';
	String get enterParameters => 'Выберите категорию, укажите сумму и дату!';
	String get deletingCategory => 'Удаление категории';
	String get youSureDeleteCategory => 'Вы точно хотите удалить категорию';
	String get addIncomeTitle => 'Добавить доход';
	String get changeIncomeTitle => 'Изменить доход';
	String get enterAmount => 'Укажите сумму';
	String get enterCategory => 'Выберите категорию';
	String get enterDate => 'Выбрать дату';
	String get newBtn => 'Новый';
	String get addBtn => 'Добавить';
	String get addExpenseTitle => 'Добавить расход';
	String get changeExpenseTitle => 'Изменить расход';
	String get enterColor => 'Выберите цвет';
	String get saveBtn => 'Сохранить';
	String get enterTitle => 'Заполните название!';
	String get enterTitleHint => 'Введите название';
	String get newCategory => 'Новая категория';
	String get whatsWrong => 'Что-то пошло не так';
	String get addIncomeErr => 'Ошибка создания дохода';
	String get addExpenseErr => 'Ошибка создания расхода';
	String get updateErr => 'Ошибка обновления дохода';
	String get deleteErr => 'Ошибка удаления дохода';
}

// Path: diagram
class _StringsDiagramRu {
	_StringsDiagramRu._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get diagram => 'Диаграмма';
	String get januaryShort => 'янв';
	String get februaryShort => 'фев';
	String get marchShort => 'мар';
	String get aprilShort => 'апр';
	String get mayShort => 'май';
	String get juneShort => 'июн';
	String get julyShort => 'июл';
	String get augustShort => 'авг';
	String get septemberShort => 'сен';
	String get octoberShort => 'окт';
	String get novemberShort => 'ноя';
	String get decemberShort => 'дек';
	String get statistics => 'Статистика расходов';
	String get lastTransactions => 'Последние транзакции';
	String get daysBtn => 'Дни';
	String get weeksBtn => 'Недели';
	String get monthsBtn => 'Месяцы';
	String get noTransactions => 'Нет транзакций';
	String get confirmText => 'ВЫБРАТЬ';
	String get cancelText => 'ОТМЕНА';
	String get saveText => 'СОХРАНИТЬ';
	String get fieldStartHintText => 'Начальная дата';
	String get fieldEndHintText => 'Конечная дата';
	String get analytics => 'Детальная аналитика расходов';
	String get allExpenses => 'Общие расходы:';
	String get categoryExpenses => 'Расходы по категориям:';
	String get noDataExpenses => 'Нет данных о расходах';
	String get transactions => 'Транзакций';
	String get listExpenses => 'Список расходов';
	String get noExpenses => 'Расходов пока не было';
	String get deletingExpense => 'Удаление расхода';
	String get youSureDeleteExpense => 'Вы точно хотите удалить расход от ';
	String get deleteBtn => 'Удалить';
	String get changeBtn => 'Изменить';
	String get analiseExpenses => 'Анализ расходов';
	String get dayBtn => 'День';
	String get weekBtn => 'Неделя';
	String get periodBtn => 'Период';
}

// Path: calculator
class _StringsCalculatorRu {
	_StringsCalculatorRu._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get calculator => 'Калькулятор';
	String get search => 'Поиск';
	String get calculateBtn => 'Посчитать';
}

// Path: settings
class _StringsSettingsRu {
	_StringsSettingsRu._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get settings => 'Настройки';
	String get notification => 'Уведомления';
	String get language => 'Язык';
	String get russian => 'Русский';
	String get english => 'English';
}

// Path: receiptScan
class _StringsReceiptScanRu {
	_StringsReceiptScanRu._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Сканирование чека';
	String get cameraHint => 'Сфотографируйте чек целиком без бликов или выберите фото для теста.';
	String get processing => 'Распознаём чек...';
	String get scanCamera => 'Сканировать камерой';
	String get choosePhoto => 'Выбрать фото чека';
	String get processError => 'Не удалось обработать чек. Попробуйте другой снимок.';
	String get qrTemporaryFailed => 'QR-код временно не удалось считать, использован текстовый разбор.';
	String get qrNotRead => 'QR-код чека не считался, использован только текстовый разбор.';
	String get qrItemsNotLoaded => 'Позиции по QR не загрузились, использован резервный текстовый разбор.';
}

// Path: categories
class _StringsCategoriesRu {
	_StringsCategoriesRu._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get loadErr => 'Ошибка загрузки категорий:';
	String get addErr => 'Ошибка добавления категории:';
	String get deleteErr => 'Ошибка удаления категории:';
	String get unknown => 'Неизвестная';
}

// Path: api
class _StringsApiRu {
	_StringsApiRu._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get refreshNotFound => 'Refresh-токен не найден';
	String get accessNotFound => 'Access-токен не найден после обновления';
	String get unknownErr => 'Произошла неизвестная ошибка, повторите попытку позже.';
	String get invalidRequest => 'Неверный запрос';
	String get conflict => 'Произошел конфликт';
	String get internetConnectionErr => 'Интернет-соединение не обнаружено, попробуйте еще раз.';
	String get timeoutErr => 'Время ожидания соединения истекло, попробуйте еще раз.';
}

// Path: currency
class _StringsCurrencyRu {
	_StringsCurrencyRu._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get aed => 'Дирхам Объединённых Арабских Эмиратов';
	String get afn => 'Афганский афгани';
	String get all => 'Албанский лек';
	String get amd => 'Армянский драм';
	String get ang => 'Нидерландский антильский гульден';
	String get aoa => 'Ангольская кванза';
	String get ars => 'Аргентинское песо';
	String get aud => 'Австралийский доллар';
	String get awg => 'Арубанский флорин';
	String get azn => 'Азербайджанский манат';
	String get bam => 'Конвертируемая марка Боснии и Герцеговины';
	String get bbd => 'Барбадосский доллар';
	String get bch => 'Биткоин Кэш';
	String get bdt => 'Бангладешская така';
	String get bgn => 'Болгарский лев';
	String get bhd => 'Бахрейнский динар';
	String get bif => 'Бурундийский франк';
	String get bmd => 'Бермудский доллар';
	String get bnd => 'Брунейский доллар';
	String get bob => 'Боливийский боливиано';
	String get brl => 'Бразильский реал';
	String get bsd => 'Багамский доллар';
	String get btc => 'Биткоин';
	String get btg => 'Биткоин Голд';
	String get bwp => 'Ботсванская пула';
	String get bzd => 'Белизский доллар';
	String get cad => 'Канадский доллар';
	String get cdf => 'Конголезский франк';
	String get chf => 'Швейцарский франк';
	String get clp => 'Чилийское песо';
	String get cnh => 'Китайский юань (Офшор)';
	String get cny => 'Китайский юань';
	String get cop => 'Колумбийское песо';
	String get crc => 'Коста-риканский колон';
	String get cuc => 'Кубинский конвертируемый песо';
	String get cup => 'Кубинское песо';
	String get cve => 'Эскудо Кабо-Верде';
	String get czk => 'Чешская крона';
	String get djf => 'Джибутийский франк';
	String get dkk => 'Датская крона';
	String get dop => 'Доминиканское песо';
	String get dzd => 'Алжирский динар';
	String get egp => 'Египетский фунт';
	String get etb => 'Эфиопский быр';
	String get eth => 'Эфириум';
	String get eur => 'Евро';
	String get fjd => 'Фиджийский доллар';
	String get gbp => 'Британский фунт стерлингов';
	String get gel => 'Грузинский лари';
	String get ghs => 'Ганский седи';
	String get gip => 'Гибралтарский фунт';
	String get gmd => 'Гамбийский даласи';
	String get gnf => 'Гвинейский франк';
	String get gtq => 'Гватемальский кетсаль';
	String get gyd => 'Гайанский доллар';
	String get hkd => 'Гонконгский доллар';
	String get hnl => 'Гондурасская лемпира';
	String get hrk => 'Хорватская куна';
	String get htg => 'Гаитянский гурд';
	String get huf => 'Венгерский форинт';
	String get idr => 'Индонезийская рупия';
	String get ils => 'Израильский новый шекель';
	String get inr => 'Индийская рупия';
	String get iqd => 'Иракский динар';
	String get irr => 'Иранский риал';
	String get isk => 'Исландская крона';
	String get jmd => 'Ямайский доллар';
	String get jod => 'Иорданский динар';
	String get jpy => 'Японская йена';
	String get kes => 'Кенийский шиллинг';
	String get kgs => 'Киргизский сом';
	String get khr => 'Камбоджийский риель';
	String get kmf => 'Франк Коморских Островов';
	String get krw => 'Южнокорейский вон';
	String get kwd => 'Кувейтский динар';
	String get kyd => 'Доллар Каймановых островов';
	String get kzt => 'Казахстанский тенге';
	String get lak => 'Лаосский кип';
	String get lbp => 'Ливанский фунт';
	String get lkr => 'Шри-Ланкийская рупия';
	String get lrd => 'Либерийский доллар';
	String get lsl => 'Лоти Лесото';
	String get ltc => 'Лайткоин';
	String get lyd => 'Ливийский динар';
	String get mad => 'Марокканский дирхам';
	String get mdl => 'Молдавский лей';
	String get mkd => 'Македонский денар';
	String get mmk => 'Мьянманский кьят';
	String get mop => 'Макао патака';
	String get mur => 'Маврикийская рупия';
	String get mvr => 'Мальдивская руфия';
	String get mwk => 'Малавийская квача';
	String get mxn => 'Мексиканское песо';
	String get myr => 'Малайзийский ринггит';
	String get mzn => 'Мозамбикский метикал';
	String get nad => 'Намибийский доллар';
	String get ngn => 'Нигерийская найра';
	String get nio => 'Никарагуанская кордоба';
	String get nok => 'Норвежская крона';
	String get npr => 'Непальская рупия';
	String get nzd => 'Новозеландский доллар';
	String get omr => 'Оманский риал';
	String get pab => 'Панамский бальбоа';
	String get pen => 'Перуанский новый соль';
	String get pgk => 'Кина Папуа - Новой Гвинеи';
	String get php => 'Филиппинское песо';
	String get pkr => 'Пакистанская рупия';
	String get pln => 'Польский злотый';
	String get pyg => 'Парагвайский гуарани';
	String get qar => 'Катарский риал';
	String get ron => 'Румынский лей';
	String get rsd => 'Сербский динар';
	String get rub => 'Российский рубль';
	String get rwf => 'Руандийский франк';
	String get sar => 'Саудовский риал';
	String get sbd => 'Доллар Соломоновых Островів';
	String get scr => 'Сейшельская рупия';
	String get sdg => 'Суданский фунт';
	String get sek => 'Шведская крона';
	String get sgd => 'Сингапурский доллар';
	String get sll => 'Леоне Сьерра-Леоне';
	String get sos => 'Сомалийский шиллинг';
	String get srd => 'Суринамский доллар';
	String get svc => 'Сальвадорский колон';
	String get szl => 'Свазилендский лилангени';
	String get thb => 'Тайский бат';
	String get tjs => 'Таджикский сомони';
	String get tmt => 'Туркменский манат';
	String get tnd => 'Тунисский динар';
	String get top => 'Тонганская паанга';
	String get trY => 'Турецкая лира';
	String get ttd => 'Доллар Тринидада и Тобаго';
	String get twd => 'Новый тайваньский доллар';
	String get tzs => 'Танзанийский шиллинг';
	String get uah => 'Украинская гривна';
	String get ugx => 'Угандийский шиллинг';
	String get usd => 'Доллар Соединённых Штатов';
	String get uyu => 'Уругвайское песо';
	String get uzs => 'Узбекский сум';
	String get vnd => 'Вьетнамский донг';
	String get xag => 'Серебро (тройская унция)';
	String get xau => 'Золото (тройская унция)';
	String get xcd => 'Восточно-карибский доллар';
	String get yer => 'Йеменский риал';
	String get zar => 'Южноафриканский рэнд';
	String get zmw => 'Замбийская квача';
}

// Path: general
class _StringsGeneralRu {
	_StringsGeneralRu._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get cancelBtn => 'Отмена';
}

// Path: <root>
class _StringsEn implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsEn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	@override late final _StringsEn _root = this; // ignore: unused_field

	// Translations
	@override late final _StringsAuthEn auth = _StringsAuthEn._(_root);
	@override late final _StringsProfileEn profile = _StringsProfileEn._(_root);
	@override late final _StringsDiagramEn diagram = _StringsDiagramEn._(_root);
	@override late final _StringsCalculatorEn calculator = _StringsCalculatorEn._(_root);
	@override late final _StringsSettingsEn settings = _StringsSettingsEn._(_root);
	@override late final _StringsReceiptScanEn receiptScan = _StringsReceiptScanEn._(_root);
	@override late final _StringsCategoriesEn categories = _StringsCategoriesEn._(_root);
	@override late final _StringsApiEn api = _StringsApiEn._(_root);
	@override late final _StringsCurrencyEn currency = _StringsCurrencyEn._(_root);
	@override late final _StringsGeneralEn general = _StringsGeneralEn._(_root);
}

// Path: auth
class _StringsAuthEn implements _StringsAuthRu {
	_StringsAuthEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get authTitle => 'Authorization';
	@override String get welcome => 'Welcome to your personal finance assistant! Control your budget and expenses!';
	@override String get signInBtn => 'Sign In';
	@override String get registerBtn => 'Register';
	@override String get signInTitle => 'Login';
	@override String get registerTitle => 'Registration';
	@override String get startBalance => 'Initial Balance';
	@override String get currency => 'Currency';
	@override String get continueBtn => 'Continue';
	@override String get changeAllFieldsErr => 'Fill in all fields!';
	@override String get passwordsEqualsErr => 'Passwords do not match!';
	@override String get login => 'Login';
	@override String get loginBusy => 'This login is already taken';
	@override String get password => 'Password';
	@override String get verifyPassword => 'Confirm Password';
	@override String get loginOrPassNotValidErr => 'Incorrect login or password';
}

// Path: profile
class _StringsProfileEn implements _StringsProfileRu {
	_StringsProfileEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get profile => 'Profile';
	@override String get addExpensesBtn => 'Add Expenses';
	@override String get addIncomesBtn => 'Add Income';
	@override String get incomes => 'Income';
	@override String get balance => 'Balance';
	@override String get noIncomes => 'No income yet';
	@override String get deleteBtn => 'Delete';
	@override String get changeBtn => 'Edit';
	@override String get deletingIncome => 'Deleting Income';
	@override String get youSureDeleteExpense => 'Are you sure you want to delete income from ';
	@override String get enterParameters => 'Select a category, specify the amount and date!';
	@override String get deletingCategory => 'Deleting Category';
	@override String get youSureDeleteCategory => 'Are you sure you want to delete the category';
	@override String get addIncomeTitle => 'Add Income';
	@override String get changeIncomeTitle => 'Edit Income';
	@override String get enterAmount => 'Specify Amount';
	@override String get enterCategory => 'Select Category';
	@override String get enterDate => 'Select Date';
	@override String get newBtn => 'New';
	@override String get addBtn => 'Add';
	@override String get addExpenseTitle => 'Add Expense';
	@override String get changeExpenseTitle => 'Edit Expense';
	@override String get enterColor => 'Select Color';
	@override String get saveBtn => 'Save';
	@override String get enterTitle => 'Enter Title!';
	@override String get enterTitleHint => 'Enter title';
	@override String get newCategory => 'New Category';
	@override String get whatsWrong => 'Something went wrong';
	@override String get addIncomeErr => 'Income Creation Error';
	@override String get addExpenseErr => 'Expense Creation Error';
	@override String get updateErr => 'Income update error';
	@override String get deleteErr => 'Error deleting income';
}

// Path: diagram
class _StringsDiagramEn implements _StringsDiagramRu {
	_StringsDiagramEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get diagram => 'Diagram';
	@override String get januaryShort => 'jan';
	@override String get februaryShort => 'feb';
	@override String get marchShort => 'mar';
	@override String get aprilShort => 'apr';
	@override String get mayShort => 'may';
	@override String get juneShort => 'jun';
	@override String get julyShort => 'jul';
	@override String get augustShort => 'aug';
	@override String get septemberShort => 'sep';
	@override String get octoberShort => 'oct';
	@override String get novemberShort => 'nov';
	@override String get decemberShort => 'dec';
	@override String get statistics => 'Expense Statistics';
	@override String get lastTransactions => 'Recent Transactions';
	@override String get daysBtn => 'Days';
	@override String get weeksBtn => 'Weeks';
	@override String get monthsBtn => 'Months';
	@override String get noTransactions => 'No transactions';
	@override String get confirmText => 'SELECT';
	@override String get cancelText => 'CANCEL';
	@override String get saveText => 'SAVE';
	@override String get fieldStartHintText => 'Start Date';
	@override String get fieldEndHintText => 'End Date';
	@override String get analytics => 'Detailed Expense Analytics';
	@override String get allExpenses => 'Total Expenses:';
	@override String get categoryExpenses => 'Expenses by Categories:';
	@override String get noDataExpenses => 'No expense data';
	@override String get transactions => 'Transactions';
	@override String get listExpenses => 'Expense List';
	@override String get noExpenses => 'No expenses yet';
	@override String get deletingExpense => 'Deleting Expense';
	@override String get youSureDeleteExpense => 'Are you sure you want to delete expense from ';
	@override String get deleteBtn => 'Delete';
	@override String get changeBtn => 'Edit';
	@override String get analiseExpenses => 'Expense Analysis';
	@override String get dayBtn => 'Day';
	@override String get weekBtn => 'Week';
	@override String get periodBtn => 'Period';
}

// Path: calculator
class _StringsCalculatorEn implements _StringsCalculatorRu {
	_StringsCalculatorEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get calculator => 'Calculator';
	@override String get search => 'Search';
	@override String get calculateBtn => 'Calculate';
}

// Path: settings
class _StringsSettingsEn implements _StringsSettingsRu {
	_StringsSettingsEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Settings';
	@override String get notification => 'Notifications';
	@override String get language => 'Language';
	@override String get russian => 'Russian';
	@override String get english => 'English';
}

// Path: receiptScan
class _StringsReceiptScanEn implements _StringsReceiptScanRu {
	_StringsReceiptScanEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Receipt scanning';
	@override String get cameraHint => 'Take a full photo of the receipt without glare or choose a photo for testing.';
	@override String get processing => 'Recognizing receipt...';
	@override String get scanCamera => 'Scan with camera';
	@override String get choosePhoto => 'Choose receipt photo';
	@override String get processError => 'Could not process the receipt. Try another photo.';
	@override String get qrTemporaryFailed => 'The QR code could not be read temporarily, text parsing was used.';
	@override String get qrNotRead => 'The receipt QR code was not read, only text parsing was used.';
	@override String get qrItemsNotLoaded => 'Items were not loaded via QR, fallback text parsing was used.';
}

// Path: categories
class _StringsCategoriesEn implements _StringsCategoriesRu {
	_StringsCategoriesEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get loadErr => 'Error loading categories:';
	@override String get addErr => 'Error adding category:';
	@override String get deleteErr => 'Error deleting category:';
	@override String get unknown => 'Unknown';
}

// Path: api
class _StringsApiEn implements _StringsApiRu {
	_StringsApiEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get refreshNotFound => 'Refresh token not found';
	@override String get accessNotFound => 'Access token not found after refresh';
	@override String get unknownErr => 'An unknown error occurred, please try again later.';
	@override String get invalidRequest => 'Invalid request';
	@override String get conflict => 'A conflict occurred';
	@override String get internetConnectionErr => 'No internet connection detected, please try again.';
	@override String get timeoutErr => 'Connection timeout, please try again.';
}

// Path: currency
class _StringsCurrencyEn implements _StringsCurrencyRu {
	_StringsCurrencyEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get aed => 'United Arab Emirates Dirham';
	@override String get afn => 'Afghan Afghani';
	@override String get all => 'Albanian Lek';
	@override String get amd => 'Armenian Dram';
	@override String get ang => 'Netherlands Antillean Guilder';
	@override String get aoa => 'Angolan Kwanza';
	@override String get ars => 'Argentine Peso';
	@override String get aud => 'Australian Dollar';
	@override String get awg => 'Aruban Florin';
	@override String get azn => 'Azerbaijani Manat';
	@override String get bam => 'Bosnia-Herzegovina Convertible Mark';
	@override String get bbd => 'Barbadian Dollar';
	@override String get bch => 'Bitcoin Cash';
	@override String get bdt => 'Bangladeshi Taka';
	@override String get bgn => 'Bulgarian Lev';
	@override String get bhd => 'Bahraini Dinar';
	@override String get bif => 'Burundian Franc';
	@override String get bmd => 'Bermudan Dollar';
	@override String get bnd => 'Brunei Dollar';
	@override String get bob => 'Bolivian Boliviano';
	@override String get brl => 'Brazilian Real';
	@override String get bsd => 'Bahamian Dollar';
	@override String get btc => 'Bitcoin';
	@override String get btg => 'Bitcoin Gold';
	@override String get bwp => 'Botswanan Pula';
	@override String get bzd => 'Belize Dollar';
	@override String get cad => 'Canadian Dollar';
	@override String get cdf => 'Congolese Franc';
	@override String get chf => 'Swiss Franc';
	@override String get clp => 'Chilean Peso';
	@override String get cnh => 'Chinese Yuan (Offshore)';
	@override String get cny => 'Chinese Yuan';
	@override String get cop => 'Colombian Peso';
	@override String get crc => 'Costa Rican Colón';
	@override String get cuc => 'Cuban Convertible Peso';
	@override String get cup => 'Cuban Peso';
	@override String get cve => 'Cape Verdean Escudo';
	@override String get czk => 'Czech Koruna';
	@override String get djf => 'Djiboutian Franc';
	@override String get dkk => 'Danish Krone';
	@override String get dop => 'Dominican Peso';
	@override String get dzd => 'Algerian Dinar';
	@override String get egp => 'Egyptian Pound';
	@override String get etb => 'Ethiopian Birr';
	@override String get eth => 'Ethereum';
	@override String get eur => 'Euro';
	@override String get fjd => 'Fijian Dollar';
	@override String get gbp => 'British Pound Sterling';
	@override String get gel => 'Georgian Lari';
	@override String get ghs => 'Ghanaian Cedi';
	@override String get gip => 'Gibraltar Pound';
	@override String get gmd => 'Gambian Dalasi';
	@override String get gnf => 'Guinean Franc';
	@override String get gtq => 'Guatemalan Quetzal';
	@override String get gyd => 'Guyanaese Dollar';
	@override String get hkd => 'Hong Kong Dollar';
	@override String get hnl => 'Honduran Lempira';
	@override String get hrk => 'Croatian Kuna';
	@override String get htg => 'Haitian Gourde';
	@override String get huf => 'Hungarian Forint';
	@override String get idr => 'Indonesian Rupiah';
	@override String get ils => 'Israeli New Shekel';
	@override String get inr => 'Indian Rupee';
	@override String get iqd => 'Iraqi Dinar';
	@override String get irr => 'Iranian Rial';
	@override String get isk => 'Icelandic Króna';
	@override String get jmd => 'Jamaican Dollar';
	@override String get jod => 'Jordanian Dinar';
	@override String get jpy => 'Japanese Yen';
	@override String get kes => 'Kenyan Shilling';
	@override String get kgs => 'Kyrgystani Som';
	@override String get khr => 'Cambodian Riel';
	@override String get kmf => 'Comorian Franc';
	@override String get krw => 'South Korean Won';
	@override String get kwd => 'Kuwaiti Dinar';
	@override String get kyd => 'Cayman Islands Dollar';
	@override String get kzt => 'Kazakhstani Tenge';
	@override String get lak => 'Laotian Kip';
	@override String get lbp => 'Lebanese Pound';
	@override String get lkr => 'Sri Lankan Rupee';
	@override String get lrd => 'Liberian Dollar';
	@override String get lsl => 'Lesotho Loti';
	@override String get ltc => 'Litecoin';
	@override String get lyd => 'Libyan Dinar';
	@override String get mad => 'Moroccan Dirham';
	@override String get mdl => 'Moldovan Leu';
	@override String get mkd => 'Macedonian Denar';
	@override String get mmk => 'Myanma Kyat';
	@override String get mop => 'Macanese Pataca';
	@override String get mur => 'Mauritian Rupee';
	@override String get mvr => 'Maldivian Rufiyaa';
	@override String get mwk => 'Malawian Kwacha';
	@override String get mxn => 'Mexican Peso';
	@override String get myr => 'Malaysian Ringgit';
	@override String get mzn => 'Mozambican Metical';
	@override String get nad => 'Namibian Dollar';
	@override String get ngn => 'Nigerian Naira';
	@override String get nio => 'Nicaraguan Córdoba';
	@override String get nok => 'Norwegian Krone';
	@override String get npr => 'Nepalese Rupee';
	@override String get nzd => 'New Zealand Dollar';
	@override String get omr => 'Omani Rial';
	@override String get pab => 'Panamanian Balboa';
	@override String get pen => 'Peruvian Nuevo Sol';
	@override String get pgk => 'Papua New Guinean Kina';
	@override String get php => 'Philippine Peso';
	@override String get pkr => 'Pakistani Rupee';
	@override String get pln => 'Polish Zloty';
	@override String get pyg => 'Paraguayan Guarani';
	@override String get qar => 'Qatari Rial';
	@override String get ron => 'Romanian Leu';
	@override String get rsd => 'Serbian Dinar';
	@override String get rub => 'Russian Ruble';
	@override String get rwf => 'Rwandan Franc';
	@override String get sar => 'Saudi Riyal';
	@override String get sbd => 'Solomon Islands Dollar';
	@override String get scr => 'Seychellois Rupee';
	@override String get sdg => 'Sudanese Pound';
	@override String get sek => 'Swedish Krona';
	@override String get sgd => 'Singapore Dollar';
	@override String get sll => 'Sierra Leonean Leone';
	@override String get sos => 'Somali Shilling';
	@override String get srd => 'Surinamese Dollar';
	@override String get svc => 'Salvadoran Colón';
	@override String get szl => 'Swazi Lilangeni';
	@override String get thb => 'Thai Baht';
	@override String get tjs => 'Tajikistani Somoni';
	@override String get tmt => 'Turkmenistani Manat';
	@override String get tnd => 'Tunisian Dinar';
	@override String get top => 'Tongan Paʻanga';
	@override String get trY => 'Turkish Lira';
	@override String get ttd => 'Trinidad and Tobago Dollar';
	@override String get twd => 'New Taiwan Dollar';
	@override String get tzs => 'Tanzanian Shilling';
	@override String get uah => 'Ukrainian Hryvnia';
	@override String get ugx => 'Ugandan Shilling';
	@override String get usd => 'United States Dollar';
	@override String get uyu => 'Uruguayan Peso';
	@override String get uzs => 'Uzbekistani Som';
	@override String get vnd => 'Vietnamese Dong';
	@override String get xag => 'Silver (troy ounce)';
	@override String get xau => 'Gold (troy ounce)';
	@override String get xcd => 'East Caribbean Dollar';
	@override String get yer => 'Yemeni Rial';
	@override String get zar => 'South African Rand';
	@override String get zmw => 'Zambian Kwacha';
}

// Path: general
class _StringsGeneralEn implements _StringsGeneralRu {
	_StringsGeneralEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get cancelBtn => 'Cancel';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'auth.authTitle': return 'Авторизация';
			case 'auth.welcome': return 'Добро пожаловать в ваш личный помощник финансов! Контролируйте свой бюджет и ваши расходы!';
			case 'auth.signInBtn': return 'Войти';
			case 'auth.registerBtn': return 'Зарегистрироваться';
			case 'auth.signInTitle': return 'Вход';
			case 'auth.registerTitle': return 'Регистрация';
			case 'auth.startBalance': return 'Начальный баланс';
			case 'auth.currency': return 'Валюта';
			case 'auth.continueBtn': return 'Продолжить';
			case 'auth.changeAllFieldsErr': return 'Заполните все поля!';
			case 'auth.passwordsEqualsErr': return 'Пароли не совпадают!';
			case 'auth.login': return 'Логин';
			case 'auth.loginBusy': return 'Данный логин занят';
			case 'auth.password': return 'Пароль';
			case 'auth.verifyPassword': return 'Подтвердите пароль';
			case 'auth.loginOrPassNotValidErr': return 'Неправильный логин или пароль';
			case 'profile.profile': return 'Профиль';
			case 'profile.addExpensesBtn': return 'Добавить расходы';
			case 'profile.addIncomesBtn': return 'Добавить доходы';
			case 'profile.incomes': return 'Доходы';
			case 'profile.balance': return 'Баланс';
			case 'profile.noIncomes': return 'Доходов пока не было';
			case 'profile.deleteBtn': return 'Удалить';
			case 'profile.changeBtn': return 'Изменить';
			case 'profile.deletingIncome': return 'Удаление дохода';
			case 'profile.youSureDeleteExpense': return 'Вы точно хотите удалить доход от ';
			case 'profile.enterParameters': return 'Выберите категорию, укажите сумму и дату!';
			case 'profile.deletingCategory': return 'Удаление категории';
			case 'profile.youSureDeleteCategory': return 'Вы точно хотите удалить категорию';
			case 'profile.addIncomeTitle': return 'Добавить доход';
			case 'profile.changeIncomeTitle': return 'Изменить доход';
			case 'profile.enterAmount': return 'Укажите сумму';
			case 'profile.enterCategory': return 'Выберите категорию';
			case 'profile.enterDate': return 'Выбрать дату';
			case 'profile.newBtn': return 'Новый';
			case 'profile.addBtn': return 'Добавить';
			case 'profile.addExpenseTitle': return 'Добавить расход';
			case 'profile.changeExpenseTitle': return 'Изменить расход';
			case 'profile.enterColor': return 'Выберите цвет';
			case 'profile.saveBtn': return 'Сохранить';
			case 'profile.enterTitle': return 'Заполните название!';
			case 'profile.enterTitleHint': return 'Введите название';
			case 'profile.newCategory': return 'Новая категория';
			case 'profile.whatsWrong': return 'Что-то пошло не так';
			case 'profile.addIncomeErr': return 'Ошибка создания дохода';
			case 'profile.addExpenseErr': return 'Ошибка создания расхода';
			case 'profile.updateErr': return 'Ошибка обновления дохода';
			case 'profile.deleteErr': return 'Ошибка удаления дохода';
			case 'diagram.diagram': return 'Диаграмма';
			case 'diagram.januaryShort': return 'янв';
			case 'diagram.februaryShort': return 'фев';
			case 'diagram.marchShort': return 'мар';
			case 'diagram.aprilShort': return 'апр';
			case 'diagram.mayShort': return 'май';
			case 'diagram.juneShort': return 'июн';
			case 'diagram.julyShort': return 'июл';
			case 'diagram.augustShort': return 'авг';
			case 'diagram.septemberShort': return 'сен';
			case 'diagram.octoberShort': return 'окт';
			case 'diagram.novemberShort': return 'ноя';
			case 'diagram.decemberShort': return 'дек';
			case 'diagram.statistics': return 'Статистика расходов';
			case 'diagram.lastTransactions': return 'Последние транзакции';
			case 'diagram.daysBtn': return 'Дни';
			case 'diagram.weeksBtn': return 'Недели';
			case 'diagram.monthsBtn': return 'Месяцы';
			case 'diagram.noTransactions': return 'Нет транзакций';
			case 'diagram.confirmText': return 'ВЫБРАТЬ';
			case 'diagram.cancelText': return 'ОТМЕНА';
			case 'diagram.saveText': return 'СОХРАНИТЬ';
			case 'diagram.fieldStartHintText': return 'Начальная дата';
			case 'diagram.fieldEndHintText': return 'Конечная дата';
			case 'diagram.analytics': return 'Детальная аналитика расходов';
			case 'diagram.allExpenses': return 'Общие расходы:';
			case 'diagram.categoryExpenses': return 'Расходы по категориям:';
			case 'diagram.noDataExpenses': return 'Нет данных о расходах';
			case 'diagram.transactions': return 'Транзакций';
			case 'diagram.listExpenses': return 'Список расходов';
			case 'diagram.noExpenses': return 'Расходов пока не было';
			case 'diagram.deletingExpense': return 'Удаление расхода';
			case 'diagram.youSureDeleteExpense': return 'Вы точно хотите удалить расход от ';
			case 'diagram.deleteBtn': return 'Удалить';
			case 'diagram.changeBtn': return 'Изменить';
			case 'diagram.analiseExpenses': return 'Анализ расходов';
			case 'diagram.dayBtn': return 'День';
			case 'diagram.weekBtn': return 'Неделя';
			case 'diagram.periodBtn': return 'Период';
			case 'calculator.calculator': return 'Калькулятор';
			case 'calculator.search': return 'Поиск';
			case 'calculator.calculateBtn': return 'Посчитать';
			case 'settings.settings': return 'Настройки';
			case 'settings.notification': return 'Уведомления';
			case 'settings.language': return 'Язык';
			case 'settings.russian': return 'Русский';
			case 'settings.english': return 'English';
			case 'receiptScan.title': return 'Сканирование чека';
			case 'receiptScan.cameraHint': return 'Сфотографируйте чек целиком без бликов или выберите фото для теста.';
			case 'receiptScan.processing': return 'Распознаём чек...';
			case 'receiptScan.scanCamera': return 'Сканировать камерой';
			case 'receiptScan.choosePhoto': return 'Выбрать фото чека';
			case 'receiptScan.processError': return 'Не удалось обработать чек. Попробуйте другой снимок.';
			case 'receiptScan.qrTemporaryFailed': return 'QR-код временно не удалось считать, использован текстовый разбор.';
			case 'receiptScan.qrNotRead': return 'QR-код чека не считался, использован только текстовый разбор.';
			case 'receiptScan.qrItemsNotLoaded': return 'Позиции по QR не загрузились, использован резервный текстовый разбор.';
			case 'categories.loadErr': return 'Ошибка загрузки категорий:';
			case 'categories.addErr': return 'Ошибка добавления категории:';
			case 'categories.deleteErr': return 'Ошибка удаления категории:';
			case 'categories.unknown': return 'Неизвестная';
			case 'api.refreshNotFound': return 'Refresh-токен не найден';
			case 'api.accessNotFound': return 'Access-токен не найден после обновления';
			case 'api.unknownErr': return 'Произошла неизвестная ошибка, повторите попытку позже.';
			case 'api.invalidRequest': return 'Неверный запрос';
			case 'api.conflict': return 'Произошел конфликт';
			case 'api.internetConnectionErr': return 'Интернет-соединение не обнаружено, попробуйте еще раз.';
			case 'api.timeoutErr': return 'Время ожидания соединения истекло, попробуйте еще раз.';
			case 'currency.aed': return 'Дирхам Объединённых Арабских Эмиратов';
			case 'currency.afn': return 'Афганский афгани';
			case 'currency.all': return 'Албанский лек';
			case 'currency.amd': return 'Армянский драм';
			case 'currency.ang': return 'Нидерландский антильский гульден';
			case 'currency.aoa': return 'Ангольская кванза';
			case 'currency.ars': return 'Аргентинское песо';
			case 'currency.aud': return 'Австралийский доллар';
			case 'currency.awg': return 'Арубанский флорин';
			case 'currency.azn': return 'Азербайджанский манат';
			case 'currency.bam': return 'Конвертируемая марка Боснии и Герцеговины';
			case 'currency.bbd': return 'Барбадосский доллар';
			case 'currency.bch': return 'Биткоин Кэш';
			case 'currency.bdt': return 'Бангладешская така';
			case 'currency.bgn': return 'Болгарский лев';
			case 'currency.bhd': return 'Бахрейнский динар';
			case 'currency.bif': return 'Бурундийский франк';
			case 'currency.bmd': return 'Бермудский доллар';
			case 'currency.bnd': return 'Брунейский доллар';
			case 'currency.bob': return 'Боливийский боливиано';
			case 'currency.brl': return 'Бразильский реал';
			case 'currency.bsd': return 'Багамский доллар';
			case 'currency.btc': return 'Биткоин';
			case 'currency.btg': return 'Биткоин Голд';
			case 'currency.bwp': return 'Ботсванская пула';
			case 'currency.bzd': return 'Белизский доллар';
			case 'currency.cad': return 'Канадский доллар';
			case 'currency.cdf': return 'Конголезский франк';
			case 'currency.chf': return 'Швейцарский франк';
			case 'currency.clp': return 'Чилийское песо';
			case 'currency.cnh': return 'Китайский юань (Офшор)';
			case 'currency.cny': return 'Китайский юань';
			case 'currency.cop': return 'Колумбийское песо';
			case 'currency.crc': return 'Коста-риканский колон';
			case 'currency.cuc': return 'Кубинский конвертируемый песо';
			case 'currency.cup': return 'Кубинское песо';
			case 'currency.cve': return 'Эскудо Кабо-Верде';
			case 'currency.czk': return 'Чешская крона';
			case 'currency.djf': return 'Джибутийский франк';
			case 'currency.dkk': return 'Датская крона';
			case 'currency.dop': return 'Доминиканское песо';
			case 'currency.dzd': return 'Алжирский динар';
			case 'currency.egp': return 'Египетский фунт';
			case 'currency.etb': return 'Эфиопский быр';
			case 'currency.eth': return 'Эфириум';
			case 'currency.eur': return 'Евро';
			case 'currency.fjd': return 'Фиджийский доллар';
			case 'currency.gbp': return 'Британский фунт стерлингов';
			case 'currency.gel': return 'Грузинский лари';
			case 'currency.ghs': return 'Ганский седи';
			case 'currency.gip': return 'Гибралтарский фунт';
			case 'currency.gmd': return 'Гамбийский даласи';
			case 'currency.gnf': return 'Гвинейский франк';
			case 'currency.gtq': return 'Гватемальский кетсаль';
			case 'currency.gyd': return 'Гайанский доллар';
			case 'currency.hkd': return 'Гонконгский доллар';
			case 'currency.hnl': return 'Гондурасская лемпира';
			case 'currency.hrk': return 'Хорватская куна';
			case 'currency.htg': return 'Гаитянский гурд';
			case 'currency.huf': return 'Венгерский форинт';
			case 'currency.idr': return 'Индонезийская рупия';
			case 'currency.ils': return 'Израильский новый шекель';
			case 'currency.inr': return 'Индийская рупия';
			case 'currency.iqd': return 'Иракский динар';
			case 'currency.irr': return 'Иранский риал';
			case 'currency.isk': return 'Исландская крона';
			case 'currency.jmd': return 'Ямайский доллар';
			case 'currency.jod': return 'Иорданский динар';
			case 'currency.jpy': return 'Японская йена';
			case 'currency.kes': return 'Кенийский шиллинг';
			case 'currency.kgs': return 'Киргизский сом';
			case 'currency.khr': return 'Камбоджийский риель';
			case 'currency.kmf': return 'Франк Коморских Островов';
			case 'currency.krw': return 'Южнокорейский вон';
			case 'currency.kwd': return 'Кувейтский динар';
			case 'currency.kyd': return 'Доллар Каймановых островов';
			case 'currency.kzt': return 'Казахстанский тенге';
			case 'currency.lak': return 'Лаосский кип';
			case 'currency.lbp': return 'Ливанский фунт';
			case 'currency.lkr': return 'Шри-Ланкийская рупия';
			case 'currency.lrd': return 'Либерийский доллар';
			case 'currency.lsl': return 'Лоти Лесото';
			case 'currency.ltc': return 'Лайткоин';
			case 'currency.lyd': return 'Ливийский динар';
			case 'currency.mad': return 'Марокканский дирхам';
			case 'currency.mdl': return 'Молдавский лей';
			case 'currency.mkd': return 'Македонский денар';
			case 'currency.mmk': return 'Мьянманский кьят';
			case 'currency.mop': return 'Макао патака';
			case 'currency.mur': return 'Маврикийская рупия';
			case 'currency.mvr': return 'Мальдивская руфия';
			case 'currency.mwk': return 'Малавийская квача';
			case 'currency.mxn': return 'Мексиканское песо';
			case 'currency.myr': return 'Малайзийский ринггит';
			case 'currency.mzn': return 'Мозамбикский метикал';
			case 'currency.nad': return 'Намибийский доллар';
			case 'currency.ngn': return 'Нигерийская найра';
			case 'currency.nio': return 'Никарагуанская кордоба';
			case 'currency.nok': return 'Норвежская крона';
			case 'currency.npr': return 'Непальская рупия';
			case 'currency.nzd': return 'Новозеландский доллар';
			case 'currency.omr': return 'Оманский риал';
			case 'currency.pab': return 'Панамский бальбоа';
			case 'currency.pen': return 'Перуанский новый соль';
			case 'currency.pgk': return 'Кина Папуа - Новой Гвинеи';
			case 'currency.php': return 'Филиппинское песо';
			case 'currency.pkr': return 'Пакистанская рупия';
			case 'currency.pln': return 'Польский злотый';
			case 'currency.pyg': return 'Парагвайский гуарани';
			case 'currency.qar': return 'Катарский риал';
			case 'currency.ron': return 'Румынский лей';
			case 'currency.rsd': return 'Сербский динар';
			case 'currency.rub': return 'Российский рубль';
			case 'currency.rwf': return 'Руандийский франк';
			case 'currency.sar': return 'Саудовский риал';
			case 'currency.sbd': return 'Доллар Соломоновых Островів';
			case 'currency.scr': return 'Сейшельская рупия';
			case 'currency.sdg': return 'Суданский фунт';
			case 'currency.sek': return 'Шведская крона';
			case 'currency.sgd': return 'Сингапурский доллар';
			case 'currency.sll': return 'Леоне Сьерра-Леоне';
			case 'currency.sos': return 'Сомалийский шиллинг';
			case 'currency.srd': return 'Суринамский доллар';
			case 'currency.svc': return 'Сальвадорский колон';
			case 'currency.szl': return 'Свазилендский лилангени';
			case 'currency.thb': return 'Тайский бат';
			case 'currency.tjs': return 'Таджикский сомони';
			case 'currency.tmt': return 'Туркменский манат';
			case 'currency.tnd': return 'Тунисский динар';
			case 'currency.top': return 'Тонганская паанга';
			case 'currency.trY': return 'Турецкая лира';
			case 'currency.ttd': return 'Доллар Тринидада и Тобаго';
			case 'currency.twd': return 'Новый тайваньский доллар';
			case 'currency.tzs': return 'Танзанийский шиллинг';
			case 'currency.uah': return 'Украинская гривна';
			case 'currency.ugx': return 'Угандийский шиллинг';
			case 'currency.usd': return 'Доллар Соединённых Штатов';
			case 'currency.uyu': return 'Уругвайское песо';
			case 'currency.uzs': return 'Узбекский сум';
			case 'currency.vnd': return 'Вьетнамский донг';
			case 'currency.xag': return 'Серебро (тройская унция)';
			case 'currency.xau': return 'Золото (тройская унция)';
			case 'currency.xcd': return 'Восточно-карибский доллар';
			case 'currency.yer': return 'Йеменский риал';
			case 'currency.zar': return 'Южноафриканский рэнд';
			case 'currency.zmw': return 'Замбийская квача';
			case 'general.cancelBtn': return 'Отмена';
			default: return null;
		}
	}
}

extension on _StringsEn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'auth.authTitle': return 'Authorization';
			case 'auth.welcome': return 'Welcome to your personal finance assistant! Control your budget and expenses!';
			case 'auth.signInBtn': return 'Sign In';
			case 'auth.registerBtn': return 'Register';
			case 'auth.signInTitle': return 'Login';
			case 'auth.registerTitle': return 'Registration';
			case 'auth.startBalance': return 'Initial Balance';
			case 'auth.currency': return 'Currency';
			case 'auth.continueBtn': return 'Continue';
			case 'auth.changeAllFieldsErr': return 'Fill in all fields!';
			case 'auth.passwordsEqualsErr': return 'Passwords do not match!';
			case 'auth.login': return 'Login';
			case 'auth.loginBusy': return 'This login is already taken';
			case 'auth.password': return 'Password';
			case 'auth.verifyPassword': return 'Confirm Password';
			case 'auth.loginOrPassNotValidErr': return 'Incorrect login or password';
			case 'profile.profile': return 'Profile';
			case 'profile.addExpensesBtn': return 'Add Expenses';
			case 'profile.addIncomesBtn': return 'Add Income';
			case 'profile.incomes': return 'Income';
			case 'profile.balance': return 'Balance';
			case 'profile.noIncomes': return 'No income yet';
			case 'profile.deleteBtn': return 'Delete';
			case 'profile.changeBtn': return 'Edit';
			case 'profile.deletingIncome': return 'Deleting Income';
			case 'profile.youSureDeleteExpense': return 'Are you sure you want to delete income from ';
			case 'profile.enterParameters': return 'Select a category, specify the amount and date!';
			case 'profile.deletingCategory': return 'Deleting Category';
			case 'profile.youSureDeleteCategory': return 'Are you sure you want to delete the category';
			case 'profile.addIncomeTitle': return 'Add Income';
			case 'profile.changeIncomeTitle': return 'Edit Income';
			case 'profile.enterAmount': return 'Specify Amount';
			case 'profile.enterCategory': return 'Select Category';
			case 'profile.enterDate': return 'Select Date';
			case 'profile.newBtn': return 'New';
			case 'profile.addBtn': return 'Add';
			case 'profile.addExpenseTitle': return 'Add Expense';
			case 'profile.changeExpenseTitle': return 'Edit Expense';
			case 'profile.enterColor': return 'Select Color';
			case 'profile.saveBtn': return 'Save';
			case 'profile.enterTitle': return 'Enter Title!';
			case 'profile.enterTitleHint': return 'Enter title';
			case 'profile.newCategory': return 'New Category';
			case 'profile.whatsWrong': return 'Something went wrong';
			case 'profile.addIncomeErr': return 'Income Creation Error';
			case 'profile.addExpenseErr': return 'Expense Creation Error';
			case 'profile.updateErr': return 'Income update error';
			case 'profile.deleteErr': return 'Error deleting income';
			case 'diagram.diagram': return 'Diagram';
			case 'diagram.januaryShort': return 'jan';
			case 'diagram.februaryShort': return 'feb';
			case 'diagram.marchShort': return 'mar';
			case 'diagram.aprilShort': return 'apr';
			case 'diagram.mayShort': return 'may';
			case 'diagram.juneShort': return 'jun';
			case 'diagram.julyShort': return 'jul';
			case 'diagram.augustShort': return 'aug';
			case 'diagram.septemberShort': return 'sep';
			case 'diagram.octoberShort': return 'oct';
			case 'diagram.novemberShort': return 'nov';
			case 'diagram.decemberShort': return 'dec';
			case 'diagram.statistics': return 'Expense Statistics';
			case 'diagram.lastTransactions': return 'Recent Transactions';
			case 'diagram.daysBtn': return 'Days';
			case 'diagram.weeksBtn': return 'Weeks';
			case 'diagram.monthsBtn': return 'Months';
			case 'diagram.noTransactions': return 'No transactions';
			case 'diagram.confirmText': return 'SELECT';
			case 'diagram.cancelText': return 'CANCEL';
			case 'diagram.saveText': return 'SAVE';
			case 'diagram.fieldStartHintText': return 'Start Date';
			case 'diagram.fieldEndHintText': return 'End Date';
			case 'diagram.analytics': return 'Detailed Expense Analytics';
			case 'diagram.allExpenses': return 'Total Expenses:';
			case 'diagram.categoryExpenses': return 'Expenses by Categories:';
			case 'diagram.noDataExpenses': return 'No expense data';
			case 'diagram.transactions': return 'Transactions';
			case 'diagram.listExpenses': return 'Expense List';
			case 'diagram.noExpenses': return 'No expenses yet';
			case 'diagram.deletingExpense': return 'Deleting Expense';
			case 'diagram.youSureDeleteExpense': return 'Are you sure you want to delete expense from ';
			case 'diagram.deleteBtn': return 'Delete';
			case 'diagram.changeBtn': return 'Edit';
			case 'diagram.analiseExpenses': return 'Expense Analysis';
			case 'diagram.dayBtn': return 'Day';
			case 'diagram.weekBtn': return 'Week';
			case 'diagram.periodBtn': return 'Period';
			case 'calculator.calculator': return 'Calculator';
			case 'calculator.search': return 'Search';
			case 'calculator.calculateBtn': return 'Calculate';
			case 'settings.settings': return 'Settings';
			case 'settings.notification': return 'Notifications';
			case 'settings.language': return 'Language';
			case 'settings.russian': return 'Russian';
			case 'settings.english': return 'English';
			case 'receiptScan.title': return 'Receipt scanning';
			case 'receiptScan.cameraHint': return 'Take a full photo of the receipt without glare or choose a photo for testing.';
			case 'receiptScan.processing': return 'Recognizing receipt...';
			case 'receiptScan.scanCamera': return 'Scan with camera';
			case 'receiptScan.choosePhoto': return 'Choose receipt photo';
			case 'receiptScan.processError': return 'Could not process the receipt. Try another photo.';
			case 'receiptScan.qrTemporaryFailed': return 'The QR code could not be read temporarily, text parsing was used.';
			case 'receiptScan.qrNotRead': return 'The receipt QR code was not read, only text parsing was used.';
			case 'receiptScan.qrItemsNotLoaded': return 'Items were not loaded via QR, fallback text parsing was used.';
			case 'categories.loadErr': return 'Error loading categories:';
			case 'categories.addErr': return 'Error adding category:';
			case 'categories.deleteErr': return 'Error deleting category:';
			case 'categories.unknown': return 'Unknown';
			case 'api.refreshNotFound': return 'Refresh token not found';
			case 'api.accessNotFound': return 'Access token not found after refresh';
			case 'api.unknownErr': return 'An unknown error occurred, please try again later.';
			case 'api.invalidRequest': return 'Invalid request';
			case 'api.conflict': return 'A conflict occurred';
			case 'api.internetConnectionErr': return 'No internet connection detected, please try again.';
			case 'api.timeoutErr': return 'Connection timeout, please try again.';
			case 'currency.aed': return 'United Arab Emirates Dirham';
			case 'currency.afn': return 'Afghan Afghani';
			case 'currency.all': return 'Albanian Lek';
			case 'currency.amd': return 'Armenian Dram';
			case 'currency.ang': return 'Netherlands Antillean Guilder';
			case 'currency.aoa': return 'Angolan Kwanza';
			case 'currency.ars': return 'Argentine Peso';
			case 'currency.aud': return 'Australian Dollar';
			case 'currency.awg': return 'Aruban Florin';
			case 'currency.azn': return 'Azerbaijani Manat';
			case 'currency.bam': return 'Bosnia-Herzegovina Convertible Mark';
			case 'currency.bbd': return 'Barbadian Dollar';
			case 'currency.bch': return 'Bitcoin Cash';
			case 'currency.bdt': return 'Bangladeshi Taka';
			case 'currency.bgn': return 'Bulgarian Lev';
			case 'currency.bhd': return 'Bahraini Dinar';
			case 'currency.bif': return 'Burundian Franc';
			case 'currency.bmd': return 'Bermudan Dollar';
			case 'currency.bnd': return 'Brunei Dollar';
			case 'currency.bob': return 'Bolivian Boliviano';
			case 'currency.brl': return 'Brazilian Real';
			case 'currency.bsd': return 'Bahamian Dollar';
			case 'currency.btc': return 'Bitcoin';
			case 'currency.btg': return 'Bitcoin Gold';
			case 'currency.bwp': return 'Botswanan Pula';
			case 'currency.bzd': return 'Belize Dollar';
			case 'currency.cad': return 'Canadian Dollar';
			case 'currency.cdf': return 'Congolese Franc';
			case 'currency.chf': return 'Swiss Franc';
			case 'currency.clp': return 'Chilean Peso';
			case 'currency.cnh': return 'Chinese Yuan (Offshore)';
			case 'currency.cny': return 'Chinese Yuan';
			case 'currency.cop': return 'Colombian Peso';
			case 'currency.crc': return 'Costa Rican Colón';
			case 'currency.cuc': return 'Cuban Convertible Peso';
			case 'currency.cup': return 'Cuban Peso';
			case 'currency.cve': return 'Cape Verdean Escudo';
			case 'currency.czk': return 'Czech Koruna';
			case 'currency.djf': return 'Djiboutian Franc';
			case 'currency.dkk': return 'Danish Krone';
			case 'currency.dop': return 'Dominican Peso';
			case 'currency.dzd': return 'Algerian Dinar';
			case 'currency.egp': return 'Egyptian Pound';
			case 'currency.etb': return 'Ethiopian Birr';
			case 'currency.eth': return 'Ethereum';
			case 'currency.eur': return 'Euro';
			case 'currency.fjd': return 'Fijian Dollar';
			case 'currency.gbp': return 'British Pound Sterling';
			case 'currency.gel': return 'Georgian Lari';
			case 'currency.ghs': return 'Ghanaian Cedi';
			case 'currency.gip': return 'Gibraltar Pound';
			case 'currency.gmd': return 'Gambian Dalasi';
			case 'currency.gnf': return 'Guinean Franc';
			case 'currency.gtq': return 'Guatemalan Quetzal';
			case 'currency.gyd': return 'Guyanaese Dollar';
			case 'currency.hkd': return 'Hong Kong Dollar';
			case 'currency.hnl': return 'Honduran Lempira';
			case 'currency.hrk': return 'Croatian Kuna';
			case 'currency.htg': return 'Haitian Gourde';
			case 'currency.huf': return 'Hungarian Forint';
			case 'currency.idr': return 'Indonesian Rupiah';
			case 'currency.ils': return 'Israeli New Shekel';
			case 'currency.inr': return 'Indian Rupee';
			case 'currency.iqd': return 'Iraqi Dinar';
			case 'currency.irr': return 'Iranian Rial';
			case 'currency.isk': return 'Icelandic Króna';
			case 'currency.jmd': return 'Jamaican Dollar';
			case 'currency.jod': return 'Jordanian Dinar';
			case 'currency.jpy': return 'Japanese Yen';
			case 'currency.kes': return 'Kenyan Shilling';
			case 'currency.kgs': return 'Kyrgystani Som';
			case 'currency.khr': return 'Cambodian Riel';
			case 'currency.kmf': return 'Comorian Franc';
			case 'currency.krw': return 'South Korean Won';
			case 'currency.kwd': return 'Kuwaiti Dinar';
			case 'currency.kyd': return 'Cayman Islands Dollar';
			case 'currency.kzt': return 'Kazakhstani Tenge';
			case 'currency.lak': return 'Laotian Kip';
			case 'currency.lbp': return 'Lebanese Pound';
			case 'currency.lkr': return 'Sri Lankan Rupee';
			case 'currency.lrd': return 'Liberian Dollar';
			case 'currency.lsl': return 'Lesotho Loti';
			case 'currency.ltc': return 'Litecoin';
			case 'currency.lyd': return 'Libyan Dinar';
			case 'currency.mad': return 'Moroccan Dirham';
			case 'currency.mdl': return 'Moldovan Leu';
			case 'currency.mkd': return 'Macedonian Denar';
			case 'currency.mmk': return 'Myanma Kyat';
			case 'currency.mop': return 'Macanese Pataca';
			case 'currency.mur': return 'Mauritian Rupee';
			case 'currency.mvr': return 'Maldivian Rufiyaa';
			case 'currency.mwk': return 'Malawian Kwacha';
			case 'currency.mxn': return 'Mexican Peso';
			case 'currency.myr': return 'Malaysian Ringgit';
			case 'currency.mzn': return 'Mozambican Metical';
			case 'currency.nad': return 'Namibian Dollar';
			case 'currency.ngn': return 'Nigerian Naira';
			case 'currency.nio': return 'Nicaraguan Córdoba';
			case 'currency.nok': return 'Norwegian Krone';
			case 'currency.npr': return 'Nepalese Rupee';
			case 'currency.nzd': return 'New Zealand Dollar';
			case 'currency.omr': return 'Omani Rial';
			case 'currency.pab': return 'Panamanian Balboa';
			case 'currency.pen': return 'Peruvian Nuevo Sol';
			case 'currency.pgk': return 'Papua New Guinean Kina';
			case 'currency.php': return 'Philippine Peso';
			case 'currency.pkr': return 'Pakistani Rupee';
			case 'currency.pln': return 'Polish Zloty';
			case 'currency.pyg': return 'Paraguayan Guarani';
			case 'currency.qar': return 'Qatari Rial';
			case 'currency.ron': return 'Romanian Leu';
			case 'currency.rsd': return 'Serbian Dinar';
			case 'currency.rub': return 'Russian Ruble';
			case 'currency.rwf': return 'Rwandan Franc';
			case 'currency.sar': return 'Saudi Riyal';
			case 'currency.sbd': return 'Solomon Islands Dollar';
			case 'currency.scr': return 'Seychellois Rupee';
			case 'currency.sdg': return 'Sudanese Pound';
			case 'currency.sek': return 'Swedish Krona';
			case 'currency.sgd': return 'Singapore Dollar';
			case 'currency.sll': return 'Sierra Leonean Leone';
			case 'currency.sos': return 'Somali Shilling';
			case 'currency.srd': return 'Surinamese Dollar';
			case 'currency.svc': return 'Salvadoran Colón';
			case 'currency.szl': return 'Swazi Lilangeni';
			case 'currency.thb': return 'Thai Baht';
			case 'currency.tjs': return 'Tajikistani Somoni';
			case 'currency.tmt': return 'Turkmenistani Manat';
			case 'currency.tnd': return 'Tunisian Dinar';
			case 'currency.top': return 'Tongan Paʻanga';
			case 'currency.trY': return 'Turkish Lira';
			case 'currency.ttd': return 'Trinidad and Tobago Dollar';
			case 'currency.twd': return 'New Taiwan Dollar';
			case 'currency.tzs': return 'Tanzanian Shilling';
			case 'currency.uah': return 'Ukrainian Hryvnia';
			case 'currency.ugx': return 'Ugandan Shilling';
			case 'currency.usd': return 'United States Dollar';
			case 'currency.uyu': return 'Uruguayan Peso';
			case 'currency.uzs': return 'Uzbekistani Som';
			case 'currency.vnd': return 'Vietnamese Dong';
			case 'currency.xag': return 'Silver (troy ounce)';
			case 'currency.xau': return 'Gold (troy ounce)';
			case 'currency.xcd': return 'East Caribbean Dollar';
			case 'currency.yer': return 'Yemeni Rial';
			case 'currency.zar': return 'South African Rand';
			case 'currency.zmw': return 'Zambian Kwacha';
			case 'general.cancelBtn': return 'Cancel';
			default: return null;
		}
	}
}
