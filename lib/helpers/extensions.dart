import 'package:family_budget/gen/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'enums.dart';

extension StringExtension on DateTime {
  String get formatTransactionDate {
    String dateFormat = DateFormat("dd.MM.yyyy", "ru").format(this);
    dateFormat = dateFormat.substring(0, 6) + dateFormat.substring(8, 10);
    return dateFormat;
  }

  String get formatDate {
    String dateFormat = DateFormat("dd MMMM yyyy", 'ru').format(this);
    return dateFormat;
  }

  String get formatColumnDate {
    String dateFormat = DateFormat("dd.MM\nyyyy", 'ru').format(this);
    return dateFormat;
  }

  String get formatNumberDate {
    String dateFormat = DateFormat("dd.MM.yyyy", 'ru').format(this);
    return dateFormat;
  }

  String get formatShortDate {
    String dateFormat = DateFormat("dd.MM", 'ru').format(this);
    return dateFormat;
  }

  String get formatDateNameDay {
    String dateFormat = DateFormat("EEEE, dd MMMM", 'ru').format(this);
    return dateFormat;
  }

  String get getMonth {
    String dateFormat = DateFormat("MMMM", 'ru').format(this);
    return dateFormat;
  }

  String get formatDateNumber {
    String dateFormat = DateFormat("dd.MM.yyyy").format(this);
    return dateFormat;
  }

  String get sendFormat =>
      '$year.${month.toString().padLeft(2, '0')}.${day.toString().padLeft(2, '0')}';

  String get getTime {
    String dateFormat = DateFormat("HH:mm", 'ru_RU').format(this);
    return dateFormat;
  }

  String get getTimer {
    String dateFormat = DateFormat("HH:mm:ss", 'ru_RU').format(this);
    return dateFormat;
  }

  String get sendDate {
    String dateFormat = DateFormat("dd.MM.yyyy").format(this);
    return dateFormat;
  }

  DateTime timeToDate(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}

extension DateTimeExtension on String {
  DateTime get formatDateToDate {
    DateFormat dateFormat = DateFormat("dd.MM.yyyy");
    DateTime date = dateFormat.parse(this);
    return date;
  }

  DateTime get formatDate2 {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");
    return dateFormat.parse(this);
  }

  DateTime get formatTimeDate {
    DateFormat dateFormat = DateFormat("HH:mm dd.MM.yyyy");
    return dateFormat.parse(this);
  }
}

extension ListExtension<T> on List<T> {
  List<T> separateBy<S extends T>(S separator) {
    final separatedListLength = 2 * length - 1;
    final separatedList =
        List<T?>.filled(separatedListLength, null, growable: true);
    for (var i = 0; i < separatedListLength; i++) {
      final int itemIndex = i ~/ 2;
      if (i.isEven) {
        separatedList[i] = this[itemIndex];
      } else {
        separatedList[i] = separator;
      }
    }
    return separatedList.cast<T>();
  }

  List<T> separateAndWrapBy<S extends T>(S separator) {
    final separated = separateBy(separator);
    return separated.wrapBy(separator);
  }

  List<T> wrapBy<S extends T>(S separator) {
    return [
      separator,
      ...this,
      separator,
    ];
  }
}

extension CurrencyExtension on Currency {
  String get displayName {
    switch (this) {
      case Currency.aed:
        return t.currency.aed;
      case Currency.afn:
        return t.currency.afn;
      case Currency.all:
        return t.currency.all;
      case Currency.amd:
        return t.currency.amd;
      case Currency.ang:
        return t.currency.ang;
      case Currency.aoa:
        return t.currency.aoa;
      case Currency.ars:
        return t.currency.ars;
      case Currency.aud:
        return t.currency.aud;
      case Currency.awg:
        return t.currency.awg;
      case Currency.azn:
        return t.currency.azn;
      case Currency.bam:
        return t.currency.bam;
      case Currency.bbd:
        return t.currency.bbd;
      case Currency.bch:
        return t.currency.bch;
      case Currency.bdt:
        return t.currency.bdt;
      case Currency.bgn:
        return t.currency.bgn;
      case Currency.bhd:
        return t.currency.bhd;
      case Currency.bif:
        return t.currency.bif;
      case Currency.bmd:
        return t.currency.bmd;
      case Currency.bnd:
        return t.currency.bnd;
      case Currency.bob:
        return t.currency.bob;
      case Currency.brl:
        return t.currency.brl;
      case Currency.bsd:
        return t.currency.bsd;
      case Currency.btc:
        return t.currency.btc;
      case Currency.btg:
        return t.currency.btg;
      case Currency.bwp:
        return t.currency.bwp;
      case Currency.bzd:
        return t.currency.bzd;
      case Currency.cad:
        return t.currency.cad;
      case Currency.cdf:
        return t.currency.cdf;
      case Currency.chf:
        return t.currency.chf;
      case Currency.clp:
        return t.currency.clp;
      case Currency.cnh:
        return t.currency.cnh;
      case Currency.cny:
        return t.currency.cny;
      case Currency.cop:
        return t.currency.cop;
      case Currency.crc:
        return t.currency.crc;
      case Currency.cuc:
        return t.currency.cuc;
      case Currency.cup:
        return t.currency.cup;
      case Currency.cve:
        return t.currency.cve;
      case Currency.czk:
        return t.currency.czk;
      case Currency.djf:
        return t.currency.djf;
      case Currency.dkk:
        return t.currency.dkk;
      case Currency.dop:
        return t.currency.dop;
      case Currency.dzd:
        return t.currency.dzd;
      case Currency.egp:
        return t.currency.egp;
      case Currency.etb:
        return t.currency.etb;
      case Currency.eth:
        return t.currency.eth;
      case Currency.eur:
        return t.currency.eur;
      case Currency.fjd:
        return t.currency.fjd;
      case Currency.gbp:
        return t.currency.gbp;
      case Currency.gel:
        return t.currency.gel;
      case Currency.ghs:
        return t.currency.ghs;
      case Currency.gip:
        return t.currency.gip;
      case Currency.gmd:
        return t.currency.gmd;
      case Currency.gnf:
        return t.currency.gnf;
      case Currency.gtq:
        return t.currency.gtq;
      case Currency.gyd:
        return t.currency.gyd;
      case Currency.hkd:
        return t.currency.hkd;
      case Currency.hnl:
        return t.currency.hnl;
      case Currency.hrk:
        return t.currency.hrk;
      case Currency.htg:
        return t.currency.htg;
      case Currency.huf:
        return t.currency.huf;
      case Currency.idr:
        return t.currency.idr;
      case Currency.ils:
        return t.currency.ils;
      case Currency.inr:
        return t.currency.inr;
      case Currency.iqd:
        return t.currency.iqd;
      case Currency.irr:
        return t.currency.irr;
      case Currency.isk:
        return t.currency.isk;
      case Currency.jmd:
        return t.currency.jmd;
      case Currency.jod:
        return t.currency.jod;
      case Currency.jpy:
        return t.currency.jpy;
      case Currency.kes:
        return t.currency.kes;
      case Currency.kgs:
        return t.currency.kgs;
      case Currency.khr:
        return t.currency.khr;
      case Currency.kmf:
        return t.currency.kmf;
      case Currency.krw:
        return t.currency.krw;
      case Currency.kwd:
        return t.currency.kwd;
      case Currency.kyd:
        return t.currency.kyd;
      case Currency.kzt:
        return t.currency.kzt;
      case Currency.lak:
        return t.currency.lak;
      case Currency.lbp:
        return t.currency.lbp;
      case Currency.lkr:
        return t.currency.lkr;
      case Currency.lrd:
        return t.currency.lrd;
      case Currency.lsl:
        return t.currency.lsl;
      case Currency.ltc:
        return t.currency.ltc;
      case Currency.lyd:
        return t.currency.lyd;
      case Currency.mad:
        return t.currency.mad;
      case Currency.mdl:
        return t.currency.mdl;
      case Currency.mkd:
        return t.currency.mkd;
      case Currency.mmk:
        return t.currency.mmk;
      case Currency.mop:
        return t.currency.mop;
      case Currency.mur:
        return t.currency.mur;
      case Currency.mvr:
        return t.currency.mvr;
      case Currency.mwk:
        return t.currency.mwk;
      case Currency.mxn:
        return t.currency.mxn;
      case Currency.myr:
        return t.currency.myr;
      case Currency.mzn:
        return t.currency.mzn;
      case Currency.nad:
        return t.currency.nad;
      case Currency.ngn:
        return t.currency.ngn;
      case Currency.nio:
        return t.currency.nio;
      case Currency.nok:
        return t.currency.nok;
      case Currency.npr:
        return t.currency.npr;
      case Currency.nzd:
        return t.currency.nzd;
      case Currency.omr:
        return t.currency.omr;
      case Currency.pab:
        return t.currency.pab;
      case Currency.pen:
        return t.currency.pen;
      case Currency.pgk:
        return t.currency.pgk;
      case Currency.php:
        return t.currency.php;
      case Currency.pkr:
        return t.currency.pkr;
      case Currency.pln:
        return t.currency.pln;
      case Currency.pyg:
        return t.currency.pyg;
      case Currency.qar:
        return t.currency.qar;
      case Currency.ron:
        return t.currency.ron;
      case Currency.rsd:
        return t.currency.rsd;
      case Currency.rub:
        return t.currency.rub;
      case Currency.rwf:
        return t.currency.rwf;
      case Currency.sar:
        return t.currency.sar;
      case Currency.sbd:
        return t.currency.sbd;
      case Currency.scr:
        return t.currency.scr;
      case Currency.sdg:
        return t.currency.sdg;
      case Currency.sek:
        return t.currency.sek;
      case Currency.sgd:
        return t.currency.sgd;
      case Currency.sll:
        return t.currency.sll;
      case Currency.sos:
        return t.currency.sos;
      case Currency.srd:
        return t.currency.srd;
      case Currency.svc:
        return t.currency.svc;
      case Currency.szl:
        return t.currency.szl;
      case Currency.thb:
        return t.currency.thb;
      case Currency.tjs:
        return t.currency.tjs;
      case Currency.tmt:
        return t.currency.tmt;
      case Currency.tnd:
        return t.currency.tnd;
      case Currency.top:
        return t.currency.top;
      case Currency.trY:
        return t.currency.trY;
      case Currency.ttd:
        return t.currency.ttd;
      case Currency.twd:
        return t.currency.twd;
      case Currency.tzs:
        return t.currency.tzs;
      case Currency.uah:
        return t.currency.uah;
      case Currency.ugx:
        return t.currency.ugx;
      case Currency.usd:
        return t.currency.usd;
      case Currency.uyu:
        return t.currency.uyu;
      case Currency.uzs:
        return t.currency.uzs;
      case Currency.vnd:
        return t.currency.vnd;
      case Currency.xag:
        return t.currency.xag;
      case Currency.xau:
        return t.currency.xau;
      case Currency.xcd:
        return t.currency.xcd;
      case Currency.yer:
        return t.currency.yer;
      case Currency.zar:
        return t.currency.zar;
      case Currency.zmw:
        return t.currency.zmw;
    }
  }
}
