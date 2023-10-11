webpackJsonp([13],{

/***/ 122:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _keys = __webpack_require__(18);

var _keys2 = _interopRequireDefault(_keys);

var _session = __webpack_require__(26);

var _session2 = _interopRequireDefault(_session);

var _temperature = __webpack_require__(162);

var _temperature2 = _interopRequireDefault(_temperature);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var state = {
  tempConfig: {},
  wardID: _session2.default.USER.WARDID
};
var getters = {};
(0, _keys2.default)(state).forEach(function (key) {
  getters[key] = getters[key] || function (state) {
    return state[key];
  };
});

var mutations = {
  updateTempConfig: function updateTempConfig(state, _ref) {
    var config = _ref.config;

    state.tempConfig = config;
  }
};

var actions = {
  getTempConfig: function getTempConfig(_ref2) {
    var commit = _ref2.commit,
        babyFlag = _ref2.babyFlag;

    _temperature2.default.getTempConfig(_session2.default.USER.CTLOCID, babyFlag).then(function (config) {
      return commit({
        type: 'updateTempConfig',
        config: config
      });
    });
  }
};
exports.default = {
  state: state,
  getters: getters,
  mutations: mutations,
  actions: actions
};

/***/ }),

/***/ 127:
/***/ (function(module, exports) {

exports.f = {}.propertyIsEnumerable;


/***/ }),

/***/ 128:
/***/ (function(module, exports) {

exports.f = Object.getOwnPropertySymbols;


/***/ }),

/***/ 129:
/***/ (function(module, exports, __webpack_require__) {

exports.f = __webpack_require__(1);


/***/ }),

/***/ 130:
/***/ (function(module, exports, __webpack_require__) {

var global = __webpack_require__(0);
var core = __webpack_require__(2);
var LIBRARY = __webpack_require__(19);
var wksExt = __webpack_require__(129);
var defineProperty = __webpack_require__(9).f;
module.exports = function (name) {
  var $Symbol = core.Symbol || (core.Symbol = LIBRARY ? {} : global.Symbol || {});
  if (name.charAt(0) != '_' && !(name in $Symbol)) defineProperty($Symbol, name, { value: wksExt.f(name) });
};


/***/ }),

/***/ 131:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


exports.__esModule = true;

var _iterator = __webpack_require__(144);

var _iterator2 = _interopRequireDefault(_iterator);

var _symbol = __webpack_require__(146);

var _symbol2 = _interopRequireDefault(_symbol);

var _typeof = typeof _symbol2.default === "function" && typeof _iterator2.default === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof _symbol2.default === "function" && obj.constructor === _symbol2.default && obj !== _symbol2.default.prototype ? "symbol" : typeof obj; };

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

exports.default = typeof _symbol2.default === "function" && _typeof(_iterator2.default) === "symbol" ? function (obj) {
  return typeof obj === "undefined" ? "undefined" : _typeof(obj);
} : function (obj) {
  return obj && typeof _symbol2.default === "function" && obj.constructor === _symbol2.default && obj !== _symbol2.default.prototype ? "symbol" : typeof obj === "undefined" ? "undefined" : _typeof(obj);
};

/***/ }),

/***/ 132:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _typeof2 = __webpack_require__(131);

var _typeof3 = _interopRequireDefault(_typeof2);

var _vue = __webpack_require__(29);

var _vue2 = _interopRequireDefault(_vue);

var _session = __webpack_require__(26);

var _session2 = _interopRequireDefault(_session);

var _systemConfig = __webpack_require__(59);

var _systemConfig2 = _interopRequireDefault(_systemConfig);

var _util = __webpack_require__(156);

var _pinyinUtil = __webpack_require__(134);

var _pinyinUtil2 = _interopRequireDefault(_pinyinUtil);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var utils = {
  formatDate: function formatDate(date) {
    if (date && (typeof date === 'undefined' ? 'undefined' : (0, _typeof3.default)(date)) === 'object') {
      var day = date.getDate();
      if (day < 10) {
        day = '0' + day;
      }
      var monthIndex = date.getMonth() + 1;
      if (monthIndex < 10) {
        monthIndex = '0' + monthIndex;
      }
      var year = date.getFullYear();
      return year + '-' + monthIndex + '-' + day;
    } else if (date && typeof date === 'string') {
      var reg = /((^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(10|12|0?[13578])([-\/\._])(3[01]|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(11|0?[469])([-\/\._])(30|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(0?2)([-\/\._])(2[0-8]|1[0-9]|0?[1-9])$)|(^([2468][048]00)([-\/\._])(0?2)([-\/\._])(29)$)|(^([3579][26]00)([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][0][48])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][0][48])([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][2468][048])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][2468][048])([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][13579][26])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][13579][26])([-\/\._])(0?2)([-\/\._])(29)$))/gi;
      if (reg.test(date)) {
        return date;
      } else {
        var regDDMMYYY = /(0[1-9]|[12][0-9]|3[01])[/](0[1-9]|1[012])[/](19|20)[0-9]{2}/gi;
        if (regDDMMYYY.test(date)) {
          var yyyy = date.split('/')[2];
          var MM = date.split('/')[1];
          var dd = date.split('/')[0];
          date = yyyy + '-' + MM + '-' + dd;
          if (reg.test(date)) {
            return date;
          }
        }
      }
    }
    return '';
  },
  formatTime: function formatTime(time) {
    if (time && (typeof time === 'undefined' ? 'undefined' : (0, _typeof3.default)(time)) === 'object') {
      var hours = time.getHours();
      if (hours < 10) {
        hours = '0' + hours;
      }
      var minute = time.getMinutes();
      if (minute < 10) {
        minute = '0' + minute;
      }
      var second = time.getSeconds();
      if (second < 10) {
        second = '0' + second;
      }
      return hours + ':' + minute + ':' + second;
    } else if (time && typeof time === 'string') {
      var reg = /^(20|21|22|23|[0-1]\d):[0-5]\d$/;
      if (reg.test(time)) {
        return time;
      }
    }
    return '';
  },
  compareDate: function compareDate(d1, d2) {
    if ((typeof d1 === 'undefined' ? 'undefined' : (0, _typeof3.default)(d1)) !== 'object') {
      d1 = new Date(d1);
      d1.setHours(0);
      d1.setMinutes(0);
      d1.setSeconds(0);
    }
    if ((typeof d2 === 'undefined' ? 'undefined' : (0, _typeof3.default)(d2)) !== 'object') {
      d2 = new Date(d2);
      d2.setHours(0);
      d2.setMinutes(0);
      d2.setSeconds(0);
    }
    return new Date(d1) > new Date(d2);
  },
  getCurrentDateTime: function getCurrentDateTime(timeFormat) {
    timeFormat = timeFormat || "2";
    return _systemConfig2.default.getCurrentDateTime(timeFormat).then(function (dateTime) {
      return dateTime;
    });
  },
  getDevImagePath: function getDevImagePath() {
    if (_vue2.default.config.devtools) {
      return './images/uiimages/';
    } else {
      return '../images/uiimages/';
    }
  },
  completeRegNo: function completeRegNo(regNo) {
    return _systemConfig2.default.getRegNoNum().then(function (regNoNum) {
      if (regNo.length < regNoNum) {
        for (var i = regNoNum - regNo.length - 1; i >= 0; i--) {
          regNo = "0" + regNo;
        }
      }
      return regNo;
    });
  },

  getPrintDll: function getPrintDll() {
    var printDLL = document.getElementById('DHCCNursePrintComm');

    return printDLL;
  },

  checkUrl: function checkUrl(urlString) {
    if (urlString != "") {
      var reg = /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?/;
      if (!reg.test(urlString)) {
        return 1;
      }
      return 0;
    }
  },

  compareByProperty: function compareByProperty(propName) {
    return function (obj1, obj2) {
      var val1 = obj1[propName];
      var val2 = obj2[propName];
      if (typeof val1 !== 'undefined' && typeof val2 !== 'undefined') {
        if (val2 < val1) {
          return 1;
        } else if (val2 > val1) {
          return -1;
        }
      }
      return 0;
    };
  },

  compareByTwoProperty: function compareByTwoProperty(propName1, propName2) {
    return function (obj1, obj2) {
      var val1 = String(obj1[propName1]);
      var val2 = String(obj2[propName1]);
      var val21 = obj1[propName2];
      var val22 = obj2[propName2];
      if (typeof val1 !== 'undefined' && typeof val2 !== 'undefined' && typeof val21 !== 'undefined' && typeof val22 !== 'undefined') {
        if (_pinyinUtil2.default.getFirstLetter(val2) < _pinyinUtil2.default.getFirstLetter(val1)) {
          return 1;
        } else if (_pinyinUtil2.default.getFirstLetter(val2) === _pinyinUtil2.default.getFirstLetter(val1)) {
          if (val21 > val22) {
            return 1;
          } else {
            return -1;
          }
        } else {
          return -1;
        }
      }
      return 0;
    };
  },

  compareByString: function compareByString(str1, str2) {
    if (typeof str1 === "string") {

      str1.charCodeAt();
    }
    return 0;
  },

  openWin: function openWin(url) {
    var a = document.createElement("a");
    a.setAttribute("href", url);
    a.setAttribute("target", "_blank");
    a.setAttribute("id", "camnpr");
    if (!document.getElementById("camnpr")) {
      document.body.appendChild(a);
    }
    a.click();
    document.body.removeChild(a);
  },

  showNurseExcuteSheetPreviewNew: function showNurseExcuteSheetPreviewNew(userID, timeStamp, type, queryCode, webIp, savePrintHistory, printNum, xmlName, userName, searchRange) {
    var ServerIP = webIp;
    searchRange = searchRange || "";
    if (typeof ServerNameSpace != 'undefined') {
      ServerIP = "http://" + ServerNameSpace.split(":")[1].split("[")[0];
    }
    var locId = _session2.default.USER.CTLOCID;
    var groupId = _session2.default.USER.GROUPID;
    var link = "";
    link = webIp + "/DHCMG/NurseExcute/DHCCNursePrintComm.application?method=showNurseExcuteSheetPreviewNew&userID=" + userID + "&timeStamp=" + timeStamp + "&type=" + type + "&queryCode=" + queryCode + "&webIp=" + ServerIP + "&savePrintHistory=" + savePrintHistory + "&printNum=" + printNum + "&xmlName=" + xmlName + "&userName=" + userName + "&searchRange=" + searchRange + "&locId=" + locId + "&groupId=" + groupId;

    window.open(link, '', 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
  },

  showNurseExcuteSheetPreview: function showNurseExcuteSheetPreview(orderItemIdStr, seqNoStr, type, queryCode, webIp, savePrintHistory, printNum, xmlName) {
    var ServerIP = webIp;
    if (typeof ServerNameSpace != 'undefined') {
      ServerIP = "http://" + ServerNameSpace.split(":")[1].split("[")[0];
    }
    var link = "";
    link = webIp + "/DHCMG/NurseExcute/DHCCNursePrintComm.application?method=showNurseExcuteSheetPreview&orderItemIdStr=" + orderItemIdStr + "&seqNoStr=" + seqNoStr + "&type=" + type + "&queryCode=" + queryCode + "&webIp=" + ServerIP + "&savePrintHistory=" + savePrintHistory + "&printNum=" + printNum + "&xmlName=" + xmlName;

    window.open(link, '', 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
  },

  showOtherSingleSheet: function showOtherSingleSheet(orderItemIdStr, seqNoStr, webIp, xmlName) {
    var ServerIP = webIp;
    if (typeof ServerNameSpace != 'undefined') {
      ServerIP = "http://" + ServerNameSpace.split(":")[1].split("[")[0];
    }
    var link = "";
    link = webIp + "/DHCMG/NurseExcute/DHCCNursePrintComm.application?method=showOtherSingleSheet&orderItemIdStr=" + orderItemIdStr + "&seqNoStr=" + seqNoStr + "&webIp=" + webIp + "&xmlName=" + xmlName;

    window.open(link, '', 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
  },

  showSJD: function showSJD(orderItemIdStr, seqNoStr, webIp, xmlName) {
    var ServerIP = webIp;
    if (typeof ServerNameSpace != 'undefined') {
      ServerIP = "http://" + ServerNameSpace.split(":")[1].split("[")[0];
    }
    var link = "";
    link = webIp + "/DHCMG/NurseExcute/DHCCNursePrintComm.application?method=showSJD&orderItemIdStr=" + orderItemIdStr + "&seqNoStr=" + seqNoStr + "&webIp=" + ServerIP + "&xmlName=" + xmlName;
    if (parent.parent.frames["TRAK_main"]) {
      parent.parent.frames["TRAK_main"].location = link;
    } else {
      window.open(link, "", 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
    }
  },

  makeTempPic: function makeTempPic(episodeID, flag, webIp) {
    var ServerIP = webIp;
    if (typeof ServerNameSpace != 'undefined') {
      ServerIP = "http://" + ServerNameSpace.split(":")[1].split("[")[0];
    }
    var webservice = ServerIP + "/imedical/web/Nur.TemperatureInterface.cls";
    var FilePath = ServerIP + "/dhcmg/temperature/temperatureChart.xml";
    var link = webIp + "/dhcmg/temperature/Temperature.application?method=MakeTempPic&EpisodeID=" + episodeID + "&webservice=" + webservice + "&FilePath=" + FilePath + "&flag=" + flag + "";
    window.open(link, "", 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
  },

  printByElementID: function printByElementID(id) {
    var newWindow = window.open("打印窗口", "_blank");
    var docStr = document.getElementById(id).innerHTML;
    newWindow.document.write(docStr);
    newWindow.document.close();
    newWindow.print();
    newWindow.close();
  },

  getComputerIp: function getComputerIp() {
    var ipAddr = "";
    var locator = new ActiveXObject("WbemScripting.SWbemLocator");
    var service = locator.ConnectServer(".");
    var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration");
    var e = new Enumerator(properties);
    var p = e.item();
    for (; !e.atEnd(); e.moveNext()) {
      var p = e.item();

      ipAddr = p.IPAddress(0);
      if (ipAddr) break;
    }
    return ipAddr;
  },

  getComputerName: function getComputerName() {
    var regedit = new RegEdit();
    var computerName = regedit.regRead("HKEY_CURRENT_USER\\Volatile Environment\\ViewClient_Machine_Name");
    if (computerName != "" && computerName != null) {
      return computerName;
    }
    var computerName;
    try {
      var WshNetwork = new ActiveXObject("WScript.Network");
      computerName = WshNetwork.ComputerName;
      WshNetwork = null;
    } catch (e) {
      computerName = "";
    }
    return computerName;
  },

  runqianPrint: function runqianPrint(parameter, width, height) {
    var args = arguments.length;
    var parm = "";
    if (args >= 1) {
      if (arguments[0] == "") {
        alert("请输入报表名称和报表参数");
        return;
      }
      parm = arguments[0];
    }
    if (args >= 2) {
      if (arguments[1] != "") {
        width = arguments[1];
      }
    }
    if (args >= 3) {
      if (arguments[2] != "") {
        height = arguments[2];
      }
    }
    var url = "dhccpmrunqianreportprint.csp?reportName=" + parm;
    window.open(url, 1, 'width=' + width + ',height=' + height + ',top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
  },

  createJS: function createJS(name, callBack) {
    var object = window[name];

    if (!object) {
      var script = document.createElement('script');
      script.setAttribute('type', 'text/javascript');
      if (_vue2.default.config.devtools) {
        script.setAttribute('src', 'images/' + name + '.js');
      } else {
        script.setAttribute('src', '../scripts/nurse/nurse station/' + name + '.js');
      }
      script.onload = function () {
        callBack(window[name]);
      };
      document.body.appendChild(script);
    } else {
      callBack(window[name]);
    }
  },
  creatDomObjectNode: function creatDomObjectNode(classid, id, style, ifVIEWASTEXT) {
    var object = document.createElement('OBJECT');
    object.setAttribute('classid', classid);
    object.setAttribute('id', id);
    object.setAttribute('style', style);
    if (ifVIEWASTEXT) {
      var VIEWASTEXT = document.createAttribute("VIEWASTEXT");
      object.setAttributeNode(VIEWASTEXT);
    }
    document.body.appendChild(object);
  },
  splitChunk: function splitChunk(chunks, size) {
    for (var _len = arguments.length, argus = Array(_len > 2 ? _len - 2 : 0), _key = 2; _key < _len; _key++) {
      argus[_key - 2] = arguments[_key];
    }

    if (argus[0].length !== 0) {
      chunks.push(argus.length > 1 ? argus.map(function (array) {
        return array.splice(0, size);
      }) : argus[0].splice(0, size));
      return this.splitChunk.apply(this, [chunks, size].concat(argus));
    }
    return chunks;
  }
};

exports.default = utils;

/***/ }),

/***/ 134:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
	value: true
});

var _typeof2 = __webpack_require__(131);

var _typeof3 = _interopRequireDefault(_typeof2);

var _pinyin_dict_firstletter = __webpack_require__(154);

var _pinyin_dict_firstletter2 = _interopRequireDefault(_pinyin_dict_firstletter);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var dict = {};
var pinyinUtil = {
	parseDict: function parseDict() {
		if (_pinyin_dict_firstletter2.default) {
			dict.firstletter = _pinyin_dict_firstletter2.default;
		}

		if (window.pinyin_dict_notone) {
			dict.notone = {};
			dict.py2hz = pinyin_dict_notone;
			for (var i in pinyin_dict_notone) {
				var temp = pinyin_dict_notone[i];
				for (var j = 0, len = temp.length; j < len; j++) {
					dict.notone[temp[j]] = i;
				}
			}
		}
	},

	getPinyin: function getPinyin(chinese, splitter, withtone, polyphone) {
		if (!chinese || /^ +$/g.test(chinese)) return '';
		splitter = splitter == undefined ? ' ' : splitter;
		withtone = withtone == undefined ? true : withtone;
		polyphone = polyphone == undefined ? false : polyphone;
		var result = [];
		if (dict.withtone) {
				for (var i = 0, len = chinese.length; i < len; i++) {
					var pinyin = dict.withtone[chinese[i]];
					if (pinyin) {
						if (!polyphone) pinyin = pinyin.replace(/ .*$/g, '');
						if (!withtone) pinyin = this.removeTone(pinyin);
					}
					result.push(pinyin || chinese[i]);
				}
			} else if (dict.notone) {
				if (withtone) console.warn('pinyin_dict_notone 字典文件不支持声调！');
				if (polyphone) console.warn('pinyin_dict_notone 字典文件不支持多音字！');
				for (var i = 0, len = chinese.length; i < len; i++) {
					var temp = chinese.charAt(i);
					result.push(dict.notone[temp] || temp);
				}
			} else {
			throw '抱歉，未找到合适的拼音字典文件！';
		}
		if (!polyphone) return result.join(splitter);else {
			if (window.pinyin_dict_polyphone) return parsePolyphone(chinese, result, splitter, withtone);else return handlePolyphone(result, ' ', splitter);
		}
	},

	getFirstLetter: function getFirstLetter(str, polyphone) {
		polyphone = polyphone == undefined ? false : polyphone;
		if (!str || /^ +$/g.test(str)) return '';
		if (dict.firstletter) {
				var result = [];
				for (var i = 0; i < str.length; i++) {
					var unicode = str.charCodeAt(i);
					var ch = str.charAt(i);
					if (unicode >= 19968 && unicode <= 40869) {
						ch = dict.firstletter.all.charAt(unicode - 19968);
						if (polyphone) ch = dict.firstletter.polyphone[unicode] || ch;
					}
					result.push(ch);
				}
				if (!polyphone) return result.join('');else return handlePolyphone(result, '', '');
			} else {
			var py = this.getPinyin(str, ' ', false, polyphone);
			py = py instanceof Array ? py : [py];
			var result = [];
			for (var i = 0; i < py.length; i++) {
				result.push(py[i].replace(/(^| )(\w)\w*/g, function (m, $1, $2) {
					return $2.toUpperCase();
				}));
			}
			if (!polyphone) return result[0];else return simpleUnique(result);
		}
	}
};

function simpleUnique(array) {
	var result = [];
	var hash = {};
	for (var i = 0; i < array.length; i++) {
		var key = (0, _typeof3.default)(array[i]) + array[i];
		if (!hash[key]) {
			result.push(array[i]);
			hash[key] = true;
		}
	}
	return result;
}

pinyinUtil.parseDict();
pinyinUtil.dict = dict;
exports.default = pinyinUtil;

/***/ }),

/***/ 135:
/***/ (function(module, exports, __webpack_require__) {

module.exports = { "default": __webpack_require__(139), __esModule: true };

/***/ }),

/***/ 136:
/***/ (function(module, exports, __webpack_require__) {

// 19.1.2.7 / 15.2.3.4 Object.getOwnPropertyNames(O)
var $keys = __webpack_require__(56);
var hiddenKeys = __webpack_require__(35).concat('length', 'prototype');

exports.f = Object.getOwnPropertyNames || function getOwnPropertyNames(O) {
  return $keys(O, hiddenKeys);
};


/***/ }),

/***/ 138:
/***/ (function(module, exports, __webpack_require__) {

var META = __webpack_require__(31)('meta');
var isObject = __webpack_require__(6);
var has = __webpack_require__(10);
var setDesc = __webpack_require__(9).f;
var id = 0;
var isExtensible = Object.isExtensible || function () {
  return true;
};
var FREEZE = !__webpack_require__(16)(function () {
  return isExtensible(Object.preventExtensions({}));
});
var setMeta = function (it) {
  setDesc(it, META, { value: {
    i: 'O' + ++id, // object ID
    w: {}          // weak collections IDs
  } });
};
var fastKey = function (it, create) {
  // return primitive with prefix
  if (!isObject(it)) return typeof it == 'symbol' ? it : (typeof it == 'string' ? 'S' : 'P') + it;
  if (!has(it, META)) {
    // can't set metadata to uncaught frozen object
    if (!isExtensible(it)) return 'F';
    // not necessary to add metadata
    if (!create) return 'E';
    // add missing metadata
    setMeta(it);
  // return object ID
  } return it[META].i;
};
var getWeak = function (it, create) {
  if (!has(it, META)) {
    // can't set metadata to uncaught frozen object
    if (!isExtensible(it)) return true;
    // not necessary to add metadata
    if (!create) return false;
    // add missing metadata
    setMeta(it);
  // return hash weak collections IDs
  } return it[META].w;
};
// add metadata on freeze-family methods calling
var onFreeze = function (it) {
  if (FREEZE && meta.NEED && isExtensible(it) && !has(it, META)) setMeta(it);
  return it;
};
var meta = module.exports = {
  KEY: META,
  NEED: false,
  fastKey: fastKey,
  getWeak: getWeak,
  onFreeze: onFreeze
};


/***/ }),

/***/ 139:
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(140);
module.exports = __webpack_require__(2).Object.assign;


/***/ }),

/***/ 140:
/***/ (function(module, exports, __webpack_require__) {

// 19.1.3.1 Object.assign(target, source)
var $export = __webpack_require__(5);

$export($export.S + $export.F, 'Object', { assign: __webpack_require__(141) });


/***/ }),

/***/ 141:
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// 19.1.2.1 Object.assign(target, source, ...)
var getKeys = __webpack_require__(28);
var gOPS = __webpack_require__(128);
var pIE = __webpack_require__(127);
var toObject = __webpack_require__(32);
var IObject = __webpack_require__(53);
var $assign = Object.assign;

// should work with symbols and should have deterministic property order (V8 bug)
module.exports = !$assign || __webpack_require__(16)(function () {
  var A = {};
  var B = {};
  // eslint-disable-next-line no-undef
  var S = Symbol();
  var K = 'abcdefghijklmnopqrst';
  A[S] = 7;
  K.split('').forEach(function (k) { B[k] = k; });
  return $assign({}, A)[S] != 7 || Object.keys($assign({}, B)).join('') != K;
}) ? function assign(target, source) { // eslint-disable-line no-unused-vars
  var T = toObject(target);
  var aLen = arguments.length;
  var index = 1;
  var getSymbols = gOPS.f;
  var isEnum = pIE.f;
  while (aLen > index) {
    var S = IObject(arguments[index++]);
    var keys = getSymbols ? getKeys(S).concat(getSymbols(S)) : getKeys(S);
    var length = keys.length;
    var j = 0;
    var key;
    while (length > j) if (isEnum.call(S, key = keys[j++])) T[key] = S[key];
  } return T;
} : $assign;


/***/ }),

/***/ 142:
/***/ (function(module, exports, __webpack_require__) {

// 7.2.2 IsArray(argument)
var cof = __webpack_require__(11);
module.exports = Array.isArray || function isArray(arg) {
  return cof(arg) == 'Array';
};


/***/ }),

/***/ 144:
/***/ (function(module, exports, __webpack_require__) {

module.exports = { "default": __webpack_require__(145), __esModule: true };

/***/ }),

/***/ 145:
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(50);
__webpack_require__(51);
module.exports = __webpack_require__(129).f('iterator');


/***/ }),

/***/ 146:
/***/ (function(module, exports, __webpack_require__) {

module.exports = { "default": __webpack_require__(147), __esModule: true };

/***/ }),

/***/ 147:
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(148);
__webpack_require__(52);
__webpack_require__(152);
__webpack_require__(153);
module.exports = __webpack_require__(2).Symbol;


/***/ }),

/***/ 148:
/***/ (function(module, exports, __webpack_require__) {

"use strict";

// ECMAScript 6 symbols shim
var global = __webpack_require__(0);
var has = __webpack_require__(10);
var DESCRIPTORS = __webpack_require__(7);
var $export = __webpack_require__(5);
var redefine = __webpack_require__(58);
var META = __webpack_require__(138).KEY;
var $fails = __webpack_require__(16);
var shared = __webpack_require__(34);
var setToStringTag = __webpack_require__(20);
var uid = __webpack_require__(31);
var wks = __webpack_require__(1);
var wksExt = __webpack_require__(129);
var wksDefine = __webpack_require__(130);
var enumKeys = __webpack_require__(149);
var isArray = __webpack_require__(142);
var anObject = __webpack_require__(3);
var isObject = __webpack_require__(6);
var toIObject = __webpack_require__(17);
var toPrimitive = __webpack_require__(49);
var createDesc = __webpack_require__(30);
var _create = __webpack_require__(54);
var gOPNExt = __webpack_require__(150);
var $GOPD = __webpack_require__(151);
var $DP = __webpack_require__(9);
var $keys = __webpack_require__(28);
var gOPD = $GOPD.f;
var dP = $DP.f;
var gOPN = gOPNExt.f;
var $Symbol = global.Symbol;
var $JSON = global.JSON;
var _stringify = $JSON && $JSON.stringify;
var PROTOTYPE = 'prototype';
var HIDDEN = wks('_hidden');
var TO_PRIMITIVE = wks('toPrimitive');
var isEnum = {}.propertyIsEnumerable;
var SymbolRegistry = shared('symbol-registry');
var AllSymbols = shared('symbols');
var OPSymbols = shared('op-symbols');
var ObjectProto = Object[PROTOTYPE];
var USE_NATIVE = typeof $Symbol == 'function';
var QObject = global.QObject;
// Don't use setters in Qt Script, https://github.com/zloirock/core-js/issues/173
var setter = !QObject || !QObject[PROTOTYPE] || !QObject[PROTOTYPE].findChild;

// fallback for old Android, https://code.google.com/p/v8/issues/detail?id=687
var setSymbolDesc = DESCRIPTORS && $fails(function () {
  return _create(dP({}, 'a', {
    get: function () { return dP(this, 'a', { value: 7 }).a; }
  })).a != 7;
}) ? function (it, key, D) {
  var protoDesc = gOPD(ObjectProto, key);
  if (protoDesc) delete ObjectProto[key];
  dP(it, key, D);
  if (protoDesc && it !== ObjectProto) dP(ObjectProto, key, protoDesc);
} : dP;

var wrap = function (tag) {
  var sym = AllSymbols[tag] = _create($Symbol[PROTOTYPE]);
  sym._k = tag;
  return sym;
};

var isSymbol = USE_NATIVE && typeof $Symbol.iterator == 'symbol' ? function (it) {
  return typeof it == 'symbol';
} : function (it) {
  return it instanceof $Symbol;
};

var $defineProperty = function defineProperty(it, key, D) {
  if (it === ObjectProto) $defineProperty(OPSymbols, key, D);
  anObject(it);
  key = toPrimitive(key, true);
  anObject(D);
  if (has(AllSymbols, key)) {
    if (!D.enumerable) {
      if (!has(it, HIDDEN)) dP(it, HIDDEN, createDesc(1, {}));
      it[HIDDEN][key] = true;
    } else {
      if (has(it, HIDDEN) && it[HIDDEN][key]) it[HIDDEN][key] = false;
      D = _create(D, { enumerable: createDesc(0, false) });
    } return setSymbolDesc(it, key, D);
  } return dP(it, key, D);
};
var $defineProperties = function defineProperties(it, P) {
  anObject(it);
  var keys = enumKeys(P = toIObject(P));
  var i = 0;
  var l = keys.length;
  var key;
  while (l > i) $defineProperty(it, key = keys[i++], P[key]);
  return it;
};
var $create = function create(it, P) {
  return P === undefined ? _create(it) : $defineProperties(_create(it), P);
};
var $propertyIsEnumerable = function propertyIsEnumerable(key) {
  var E = isEnum.call(this, key = toPrimitive(key, true));
  if (this === ObjectProto && has(AllSymbols, key) && !has(OPSymbols, key)) return false;
  return E || !has(this, key) || !has(AllSymbols, key) || has(this, HIDDEN) && this[HIDDEN][key] ? E : true;
};
var $getOwnPropertyDescriptor = function getOwnPropertyDescriptor(it, key) {
  it = toIObject(it);
  key = toPrimitive(key, true);
  if (it === ObjectProto && has(AllSymbols, key) && !has(OPSymbols, key)) return;
  var D = gOPD(it, key);
  if (D && has(AllSymbols, key) && !(has(it, HIDDEN) && it[HIDDEN][key])) D.enumerable = true;
  return D;
};
var $getOwnPropertyNames = function getOwnPropertyNames(it) {
  var names = gOPN(toIObject(it));
  var result = [];
  var i = 0;
  var key;
  while (names.length > i) {
    if (!has(AllSymbols, key = names[i++]) && key != HIDDEN && key != META) result.push(key);
  } return result;
};
var $getOwnPropertySymbols = function getOwnPropertySymbols(it) {
  var IS_OP = it === ObjectProto;
  var names = gOPN(IS_OP ? OPSymbols : toIObject(it));
  var result = [];
  var i = 0;
  var key;
  while (names.length > i) {
    if (has(AllSymbols, key = names[i++]) && (IS_OP ? has(ObjectProto, key) : true)) result.push(AllSymbols[key]);
  } return result;
};

// 19.4.1.1 Symbol([description])
if (!USE_NATIVE) {
  $Symbol = function Symbol() {
    if (this instanceof $Symbol) throw TypeError('Symbol is not a constructor!');
    var tag = uid(arguments.length > 0 ? arguments[0] : undefined);
    var $set = function (value) {
      if (this === ObjectProto) $set.call(OPSymbols, value);
      if (has(this, HIDDEN) && has(this[HIDDEN], tag)) this[HIDDEN][tag] = false;
      setSymbolDesc(this, tag, createDesc(1, value));
    };
    if (DESCRIPTORS && setter) setSymbolDesc(ObjectProto, tag, { configurable: true, set: $set });
    return wrap(tag);
  };
  redefine($Symbol[PROTOTYPE], 'toString', function toString() {
    return this._k;
  });

  $GOPD.f = $getOwnPropertyDescriptor;
  $DP.f = $defineProperty;
  __webpack_require__(136).f = gOPNExt.f = $getOwnPropertyNames;
  __webpack_require__(127).f = $propertyIsEnumerable;
  __webpack_require__(128).f = $getOwnPropertySymbols;

  if (DESCRIPTORS && !__webpack_require__(19)) {
    redefine(ObjectProto, 'propertyIsEnumerable', $propertyIsEnumerable, true);
  }

  wksExt.f = function (name) {
    return wrap(wks(name));
  };
}

$export($export.G + $export.W + $export.F * !USE_NATIVE, { Symbol: $Symbol });

for (var es6Symbols = (
  // 19.4.2.2, 19.4.2.3, 19.4.2.4, 19.4.2.6, 19.4.2.8, 19.4.2.9, 19.4.2.10, 19.4.2.11, 19.4.2.12, 19.4.2.13, 19.4.2.14
  'hasInstance,isConcatSpreadable,iterator,match,replace,search,species,split,toPrimitive,toStringTag,unscopables'
).split(','), j = 0; es6Symbols.length > j;)wks(es6Symbols[j++]);

for (var wellKnownSymbols = $keys(wks.store), k = 0; wellKnownSymbols.length > k;) wksDefine(wellKnownSymbols[k++]);

$export($export.S + $export.F * !USE_NATIVE, 'Symbol', {
  // 19.4.2.1 Symbol.for(key)
  'for': function (key) {
    return has(SymbolRegistry, key += '')
      ? SymbolRegistry[key]
      : SymbolRegistry[key] = $Symbol(key);
  },
  // 19.4.2.5 Symbol.keyFor(sym)
  keyFor: function keyFor(sym) {
    if (!isSymbol(sym)) throw TypeError(sym + ' is not a symbol!');
    for (var key in SymbolRegistry) if (SymbolRegistry[key] === sym) return key;
  },
  useSetter: function () { setter = true; },
  useSimple: function () { setter = false; }
});

$export($export.S + $export.F * !USE_NATIVE, 'Object', {
  // 19.1.2.2 Object.create(O [, Properties])
  create: $create,
  // 19.1.2.4 Object.defineProperty(O, P, Attributes)
  defineProperty: $defineProperty,
  // 19.1.2.3 Object.defineProperties(O, Properties)
  defineProperties: $defineProperties,
  // 19.1.2.6 Object.getOwnPropertyDescriptor(O, P)
  getOwnPropertyDescriptor: $getOwnPropertyDescriptor,
  // 19.1.2.7 Object.getOwnPropertyNames(O)
  getOwnPropertyNames: $getOwnPropertyNames,
  // 19.1.2.8 Object.getOwnPropertySymbols(O)
  getOwnPropertySymbols: $getOwnPropertySymbols
});

// 24.3.2 JSON.stringify(value [, replacer [, space]])
$JSON && $export($export.S + $export.F * (!USE_NATIVE || $fails(function () {
  var S = $Symbol();
  // MS Edge converts symbol values to JSON as {}
  // WebKit converts symbol values to JSON as null
  // V8 throws on boxed symbols
  return _stringify([S]) != '[null]' || _stringify({ a: S }) != '{}' || _stringify(Object(S)) != '{}';
})), 'JSON', {
  stringify: function stringify(it) {
    var args = [it];
    var i = 1;
    var replacer, $replacer;
    while (arguments.length > i) args.push(arguments[i++]);
    $replacer = replacer = args[1];
    if (!isObject(replacer) && it === undefined || isSymbol(it)) return; // IE8 returns string on undefined
    if (!isArray(replacer)) replacer = function (key, value) {
      if (typeof $replacer == 'function') value = $replacer.call(this, key, value);
      if (!isSymbol(value)) return value;
    };
    args[1] = replacer;
    return _stringify.apply($JSON, args);
  }
});

// 19.4.3.4 Symbol.prototype[@@toPrimitive](hint)
$Symbol[PROTOTYPE][TO_PRIMITIVE] || __webpack_require__(4)($Symbol[PROTOTYPE], TO_PRIMITIVE, $Symbol[PROTOTYPE].valueOf);
// 19.4.3.5 Symbol.prototype[@@toStringTag]
setToStringTag($Symbol, 'Symbol');
// 20.2.1.9 Math[@@toStringTag]
setToStringTag(Math, 'Math', true);
// 24.3.3 JSON[@@toStringTag]
setToStringTag(global.JSON, 'JSON', true);


/***/ }),

/***/ 149:
/***/ (function(module, exports, __webpack_require__) {

// all enumerable object keys, includes symbols
var getKeys = __webpack_require__(28);
var gOPS = __webpack_require__(128);
var pIE = __webpack_require__(127);
module.exports = function (it) {
  var result = getKeys(it);
  var getSymbols = gOPS.f;
  if (getSymbols) {
    var symbols = getSymbols(it);
    var isEnum = pIE.f;
    var i = 0;
    var key;
    while (symbols.length > i) if (isEnum.call(it, key = symbols[i++])) result.push(key);
  } return result;
};


/***/ }),

/***/ 150:
/***/ (function(module, exports, __webpack_require__) {

// fallback for IE11 buggy Object.getOwnPropertyNames with iframe and window
var toIObject = __webpack_require__(17);
var gOPN = __webpack_require__(136).f;
var toString = {}.toString;

var windowNames = typeof window == 'object' && window && Object.getOwnPropertyNames
  ? Object.getOwnPropertyNames(window) : [];

var getWindowNames = function (it) {
  try {
    return gOPN(it);
  } catch (e) {
    return windowNames.slice();
  }
};

module.exports.f = function getOwnPropertyNames(it) {
  return windowNames && toString.call(it) == '[object Window]' ? getWindowNames(it) : gOPN(toIObject(it));
};


/***/ }),

/***/ 151:
/***/ (function(module, exports, __webpack_require__) {

var pIE = __webpack_require__(127);
var createDesc = __webpack_require__(30);
var toIObject = __webpack_require__(17);
var toPrimitive = __webpack_require__(49);
var has = __webpack_require__(10);
var IE8_DOM_DEFINE = __webpack_require__(57);
var gOPD = Object.getOwnPropertyDescriptor;

exports.f = __webpack_require__(7) ? gOPD : function getOwnPropertyDescriptor(O, P) {
  O = toIObject(O);
  P = toPrimitive(P, true);
  if (IE8_DOM_DEFINE) try {
    return gOPD(O, P);
  } catch (e) { /* empty */ }
  if (has(O, P)) return createDesc(!pIE.f.call(O, P), O[P]);
};


/***/ }),

/***/ 152:
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(130)('asyncIterator');


/***/ }),

/***/ 153:
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(130)('observable');


/***/ }),

/***/ 154:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var pinyin_dict_firstletter = {};

pinyin_dict_firstletter.all = "YDYQSXMWZSSXJBYMGCCZQPSSQBYCDSCDQLDYLYBSSJGYZZJJFKCCLZDHWDWZJLJPFYYNWJJTMYHZWZHFLZPPQHGSCYYYNJQYXXGJHHSDSJNKKTMOMLCRXYPSNQSECCQZGGLLYJLMYZZSECYKYYHQWJSSGGYXYZYJWWKDJHYCHMYXJTLXJYQBYXZLDWRDJRWYSRLDZJPCBZJJBRCFTLECZSTZFXXZHTRQHYBDLYCZSSYMMRFMYQZPWWJJYFCRWFDFZQPYDDWYXKYJAWJFFXYPSFTZYHHYZYSWCJYXSCLCXXWZZXNBGNNXBXLZSZSBSGPYSYZDHMDZBQBZCWDZZYYTZHBTSYYBZGNTNXQYWQSKBPHHLXGYBFMJEBJHHGQTJCYSXSTKZHLYCKGLYSMZXYALMELDCCXGZYRJXSDLTYZCQKCNNJWHJTZZCQLJSTSTBNXBTYXCEQXGKWJYFLZQLYHYXSPSFXLMPBYSXXXYDJCZYLLLSJXFHJXPJBTFFYABYXBHZZBJYZLWLCZGGBTSSMDTJZXPTHYQTGLJSCQFZKJZJQNLZWLSLHDZBWJNCJZYZSQQYCQYRZCJJWYBRTWPYFTWEXCSKDZCTBZHYZZYYJXZCFFZZMJYXXSDZZOTTBZLQWFCKSZSXFYRLNYJMBDTHJXSQQCCSBXYYTSYFBXDZTGBCNSLCYZZPSAZYZZSCJCSHZQYDXLBPJLLMQXTYDZXSQJTZPXLCGLQTZWJBHCTSYJSFXYEJJTLBGXSXJMYJQQPFZASYJNTYDJXKJCDJSZCBARTDCLYJQMWNQNCLLLKBYBZZSYHQQLTWLCCXTXLLZNTYLNEWYZYXCZXXGRKRMTCNDNJTSYYSSDQDGHSDBJGHRWRQLYBGLXHLGTGXBQJDZPYJSJYJCTMRNYMGRZJCZGJMZMGXMPRYXKJNYMSGMZJYMKMFXMLDTGFBHCJHKYLPFMDXLQJJSMTQGZSJLQDLDGJYCALCMZCSDJLLNXDJFFFFJCZFMZFFPFKHKGDPSXKTACJDHHZDDCRRCFQYJKQCCWJDXHWJLYLLZGCFCQDSMLZPBJJPLSBCJGGDCKKDEZSQCCKJGCGKDJTJDLZYCXKLQSCGJCLTFPCQCZGWPJDQYZJJBYJHSJDZWGFSJGZKQCCZLLPSPKJGQJHZZLJPLGJGJJTHJJYJZCZMLZLYQBGJWMLJKXZDZNJQSYZMLJLLJKYWXMKJLHSKJGBMCLYYMKXJQLBMLLKMDXXKWYXYSLMLPSJQQJQXYXFJTJDXMXXLLCXQBSYJBGWYMBGGBCYXPJYGPEPFGDJGBHBNSQJYZJKJKHXQFGQZKFHYGKHDKLLSDJQXPQYKYBNQSXQNSZSWHBSXWHXWBZZXDMNSJBSBKBBZKLYLXGWXDRWYQZMYWSJQLCJXXJXKJEQXSCYETLZHLYYYSDZPAQYZCMTLSHTZCFYZYXYLJSDCJQAGYSLCQLYYYSHMRQQKLDXZSCSSSYDYCJYSFSJBFRSSZQSBXXPXJYSDRCKGJLGDKZJZBDKTCSYQPYHSTCLDJDHMXMCGXYZHJDDTMHLTXZXYLYMOHYJCLTYFBQQXPFBDFHHTKSQHZYYWCNXXCRWHOWGYJLEGWDQCWGFJYCSNTMYTOLBYGWQWESJPWNMLRYDZSZTXYQPZGCWXHNGPYXSHMYQJXZTDPPBFYHZHTJYFDZWKGKZBLDNTSXHQEEGZZYLZMMZYJZGXZXKHKSTXNXXWYLYAPSTHXDWHZYMPXAGKYDXBHNHXKDPJNMYHYLPMGOCSLNZHKXXLPZZLBMLSFBHHGYGYYGGBHSCYAQTYWLXTZQCEZYDQDQMMHTKLLSZHLSJZWFYHQSWSCWLQAZYNYTLSXTHAZNKZZSZZLAXXZWWCTGQQTDDYZTCCHYQZFLXPSLZYGPZSZNGLNDQTBDLXGTCTAJDKYWNSYZLJHHZZCWNYYZYWMHYCHHYXHJKZWSXHZYXLYSKQYSPSLYZWMYPPKBYGLKZHTYXAXQSYSHXASMCHKDSCRSWJPWXSGZJLWWSCHSJHSQNHCSEGNDAQTBAALZZMSSTDQJCJKTSCJAXPLGGXHHGXXZCXPDMMHLDGTYBYSJMXHMRCPXXJZCKZXSHMLQXXTTHXWZFKHCCZDYTCJYXQHLXDHYPJQXYLSYYDZOZJNYXQEZYSQYAYXWYPDGXDDXSPPYZNDLTWRHXYDXZZJHTCXMCZLHPYYYYMHZLLHNXMYLLLMDCPPXHMXDKYCYRDLTXJCHHZZXZLCCLYLNZSHZJZZLNNRLWHYQSNJHXYNTTTKYJPYCHHYEGKCTTWLGQRLGGTGTYGYHPYHYLQYQGCWYQKPYYYTTTTLHYHLLTYTTSPLKYZXGZWGPYDSSZZDQXSKCQNMJJZZBXYQMJRTFFBTKHZKBXLJJKDXJTLBWFZPPTKQTZTGPDGNTPJYFALQMKGXBDCLZFHZCLLLLADPMXDJHLCCLGYHDZFGYDDGCYYFGYDXKSSEBDHYKDKDKHNAXXYBPBYYHXZQGAFFQYJXDMLJCSQZLLPCHBSXGJYNDYBYQSPZWJLZKSDDTACTBXZDYZYPJZQSJNKKTKNJDJGYYPGTLFYQKASDNTCYHBLWDZHBBYDWJRYGKZYHEYYFJMSDTYFZJJHGCXPLXHLDWXXJKYTCYKSSSMTWCTTQZLPBSZDZWZXGZAGYKTYWXLHLSPBCLLOQMMZSSLCMBJCSZZKYDCZJGQQDSMCYTZQQLWZQZXSSFPTTFQMDDZDSHDTDWFHTDYZJYQJQKYPBDJYYXTLJHDRQXXXHAYDHRJLKLYTWHLLRLLRCXYLBWSRSZZSYMKZZHHKYHXKSMDSYDYCJPBZBSQLFCXXXNXKXWYWSDZYQOGGQMMYHCDZTTFJYYBGSTTTYBYKJDHKYXBELHTYPJQNFXFDYKZHQKZBYJTZBXHFDXKDASWTAWAJLDYJSFHBLDNNTNQJTJNCHXFJSRFWHZFMDRYJYJWZPDJKZYJYMPCYZNYNXFBYTFYFWYGDBNZZZDNYTXZEMMQBSQEHXFZMBMFLZZSRXYMJGSXWZJSPRYDJSJGXHJJGLJJYNZZJXHGXKYMLPYYYCXYTWQZSWHWLYRJLPXSLSXMFSWWKLCTNXNYNPSJSZHDZEPTXMYYWXYYSYWLXJQZQXZDCLEEELMCPJPCLWBXSQHFWWTFFJTNQJHJQDXHWLBYZNFJLALKYYJLDXHHYCSTYYWNRJYXYWTRMDRQHWQCMFJDYZMHMYYXJWMYZQZXTLMRSPWWCHAQBXYGZYPXYYRRCLMPYMGKSJSZYSRMYJSNXTPLNBAPPYPYLXYYZKYNLDZYJZCZNNLMZHHARQMPGWQTZMXXMLLHGDZXYHXKYXYCJMFFYYHJFSBSSQLXXNDYCANNMTCJCYPRRNYTYQNYYMBMSXNDLYLYSLJRLXYSXQMLLYZLZJJJKYZZCSFBZXXMSTBJGNXYZHLXNMCWSCYZYFZLXBRNNNYLBNRTGZQYSATSWRYHYJZMZDHZGZDWYBSSCSKXSYHYTXXGCQGXZZSHYXJSCRHMKKBXCZJYJYMKQHZJFNBHMQHYSNJNZYBKNQMCLGQHWLZNZSWXKHLJHYYBQLBFCDSXDLDSPFZPSKJYZWZXZDDXJSMMEGJSCSSMGCLXXKYYYLNYPWWWGYDKZJGGGZGGSYCKNJWNJPCXBJJTQTJWDSSPJXZXNZXUMELPXFSXTLLXCLJXJJLJZXCTPSWXLYDHLYQRWHSYCSQYYBYAYWJJJQFWQCQQCJQGXALDBZZYJGKGXPLTZYFXJLTPADKYQHPMATLCPDCKBMTXYBHKLENXDLEEGQDYMSAWHZMLJTWYGXLYQZLJEEYYBQQFFNLYXRDSCTGJGXYYNKLLYQKCCTLHJLQMKKZGCYYGLLLJDZGYDHZWXPYSJBZKDZGYZZHYWYFQYTYZSZYEZZLYMHJJHTSMQWYZLKYYWZCSRKQYTLTDXWCTYJKLWSQZWBDCQYNCJSRSZJLKCDCDTLZZZACQQZZDDXYPLXZBQJYLZLLLQDDZQJYJYJZYXNYYYNYJXKXDAZWYRDLJYYYRJLXLLDYXJCYWYWNQCCLDDNYYYNYCKCZHXXCCLGZQJGKWPPCQQJYSBZZXYJSQPXJPZBSBDSFNSFPZXHDWZTDWPPTFLZZBZDMYYPQJRSDZSQZSQXBDGCPZSWDWCSQZGMDHZXMWWFYBPDGPHTMJTHZSMMBGZMBZJCFZWFZBBZMQCFMBDMCJXLGPNJBBXGYHYYJGPTZGZMQBQTCGYXJXLWZKYDPDYMGCFTPFXYZTZXDZXTGKMTYBBCLBJASKYTSSQYYMSZXFJEWLXLLSZBQJJJAKLYLXLYCCTSXMCWFKKKBSXLLLLJYXTYLTJYYTDPJHNHNNKBYQNFQYYZBYYESSESSGDYHFHWTCJBSDZZTFDMXHCNJZYMQWSRYJDZJQPDQBBSTJGGFBKJBXTGQHNGWJXJGDLLTHZHHYYYYYYSXWTYYYCCBDBPYPZYCCZYJPZYWCBDLFWZCWJDXXHYHLHWZZXJTCZLCDPXUJCZZZLYXJJTXPHFXWPYWXZPTDZZBDZCYHJHMLXBQXSBYLRDTGJRRCTTTHYTCZWMXFYTWWZCWJWXJYWCSKYBZSCCTZQNHXNWXXKHKFHTSWOCCJYBCMPZZYKBNNZPBZHHZDLSYDDYTYFJPXYNGFXBYQXCBHXCPSXTYZDMKYSNXSXLHKMZXLYHDHKWHXXSSKQYHHCJYXGLHZXCSNHEKDTGZXQYPKDHEXTYKCNYMYYYPKQYYYKXZLTHJQTBYQHXBMYHSQCKWWYLLHCYYLNNEQXQWMCFBDCCMLJGGXDQKTLXKGNQCDGZJWYJJLYHHQTTTNWCHMXCXWHWSZJYDJCCDBQCDGDNYXZTHCQRXCBHZTQCBXWGQWYYBXHMBYMYQTYEXMQKYAQYRGYZSLFYKKQHYSSQYSHJGJCNXKZYCXSBXYXHYYLSTYCXQTHYSMGSCPMMGCCCCCMTZTASMGQZJHKLOSQYLSWTMXSYQKDZLJQQYPLSYCZTCQQPBBQJZCLPKHQZYYXXDTDDTSJCXFFLLCHQXMJLWCJCXTSPYCXNDTJSHJWXDQQJSKXYAMYLSJHMLALYKXCYYDMNMDQMXMCZNNCYBZKKYFLMCHCMLHXRCJJHSYLNMTJZGZGYWJXSRXCWJGJQHQZDQJDCJJZKJKGDZQGJJYJYLXZXXCDQHHHEYTMHLFSBDJSYYSHFYSTCZQLPBDRFRZTZYKYWHSZYQKWDQZRKMSYNBCRXQBJYFAZPZZEDZCJYWBCJWHYJBQSZYWRYSZPTDKZPFPBNZTKLQYHBBZPNPPTYZZYBQNYDCPJMMCYCQMCYFZZDCMNLFPBPLNGQJTBTTNJZPZBBZNJKLJQYLNBZQHKSJZNGGQSZZKYXSHPZSNBCGZKDDZQANZHJKDRTLZLSWJLJZLYWTJNDJZJHXYAYNCBGTZCSSQMNJPJYTYSWXZFKWJQTKHTZPLBHSNJZSYZBWZZZZLSYLSBJHDWWQPSLMMFBJDWAQYZTCJTBNNWZXQXCDSLQGDSDPDZHJTQQPSWLYYJZLGYXYZLCTCBJTKTYCZJTQKBSJLGMGZDMCSGPYNJZYQYYKNXRPWSZXMTNCSZZYXYBYHYZAXYWQCJTLLCKJJTJHGDXDXYQYZZBYWDLWQCGLZGJGQRQZCZSSBCRPCSKYDZNXJSQGXSSJMYDNSTZTPBDLTKZWXQWQTZEXNQCZGWEZKSSBYBRTSSSLCCGBPSZQSZLCCGLLLZXHZQTHCZMQGYZQZNMCOCSZJMMZSQPJYGQLJYJPPLDXRGZYXCCSXHSHGTZNLZWZKJCXTCFCJXLBMQBCZZWPQDNHXLJCTHYZLGYLNLSZZPCXDSCQQHJQKSXZPBAJYEMSMJTZDXLCJYRYYNWJBNGZZTMJXLTBSLYRZPYLSSCNXPHLLHYLLQQZQLXYMRSYCXZLMMCZLTZSDWTJJLLNZGGQXPFSKYGYGHBFZPDKMWGHCXMSGDXJMCJZDYCABXJDLNBCDQYGSKYDQTXDJJYXMSZQAZDZFSLQXYJSJZYLBTXXWXQQZBJZUFBBLYLWDSLJHXJYZJWTDJCZFQZQZZDZSXZZQLZCDZFJHYSPYMPQZMLPPLFFXJJNZZYLSJEYQZFPFZKSYWJJJHRDJZZXTXXGLGHYDXCSKYSWMMZCWYBAZBJKSHFHJCXMHFQHYXXYZFTSJYZFXYXPZLCHMZMBXHZZSXYFYMNCWDABAZLXKTCSHHXKXJJZJSTHYGXSXYYHHHJWXKZXSSBZZWHHHCWTZZZPJXSNXQQJGZYZYWLLCWXZFXXYXYHXMKYYSWSQMNLNAYCYSPMJKHWCQHYLAJJMZXHMMCNZHBHXCLXTJPLTXYJHDYYLTTXFSZHYXXSJBJYAYRSMXYPLCKDUYHLXRLNLLSTYZYYQYGYHHSCCSMZCTZQXKYQFPYYRPFFLKQUNTSZLLZMWWTCQQYZWTLLMLMPWMBZSSTZRBPDDTLQJJBXZCSRZQQYGWCSXFWZLXCCRSZDZMCYGGDZQSGTJSWLJMYMMZYHFBJDGYXCCPSHXNZCSBSJYJGJMPPWAFFYFNXHYZXZYLREMZGZCYZSSZDLLJCSQFNXZKPTXZGXJJGFMYYYSNBTYLBNLHPFZDCYFBMGQRRSSSZXYSGTZRNYDZZCDGPJAFJFZKNZBLCZSZPSGCYCJSZLMLRSZBZZLDLSLLYSXSQZQLYXZLSKKBRXBRBZCYCXZZZEEYFGKLZLYYHGZSGZLFJHGTGWKRAAJYZKZQTSSHJJXDCYZUYJLZYRZDQQHGJZXSSZBYKJPBFRTJXLLFQWJHYLQTYMBLPZDXTZYGBDHZZRBGXHWNJTJXLKSCFSMWLSDQYSJTXKZSCFWJLBXFTZLLJZLLQBLSQMQQCGCZFPBPHZCZJLPYYGGDTGWDCFCZQYYYQYSSCLXZSKLZZZGFFCQNWGLHQYZJJCZLQZZYJPJZZBPDCCMHJGXDQDGDLZQMFGPSYTSDYFWWDJZJYSXYYCZCYHZWPBYKXRYLYBHKJKSFXTZJMMCKHLLTNYYMSYXYZPYJQYCSYCWMTJJKQYRHLLQXPSGTLYYCLJSCPXJYZFNMLRGJJTYZBXYZMSJYJHHFZQMSYXRSZCWTLRTQZSSTKXGQKGSPTGCZNJSJCQCXHMXGGZTQYDJKZDLBZSXJLHYQGGGTHQSZPYHJHHGYYGKGGCWJZZYLCZLXQSFTGZSLLLMLJSKCTBLLZZSZMMNYTPZSXQHJCJYQXYZXZQZCPSHKZZYSXCDFGMWQRLLQXRFZTLYSTCTMJCXJJXHJNXTNRZTZFQYHQGLLGCXSZSJDJLJCYDSJTLNYXHSZXCGJZYQPYLFHDJSBPCCZHJJJQZJQDYBSSLLCMYTTMQTBHJQNNYGKYRQYQMZGCJKPDCGMYZHQLLSLLCLMHOLZGDYYFZSLJCQZLYLZQJESHNYLLJXGJXLYSYYYXNBZLJSSZCQQCJYLLZLTJYLLZLLBNYLGQCHXYYXOXCXQKYJXXXYKLXSXXYQXCYKQXQCSGYXXYQXYGYTQOHXHXPYXXXULCYEYCHZZCBWQBBWJQZSCSZSSLZYLKDESJZWMYMCYTSDSXXSCJPQQSQYLYYZYCMDJDZYWCBTJSYDJKCYDDJLBDJJSODZYSYXQQYXDHHGQQYQHDYXWGMMMAJDYBBBPPBCMUUPLJZSMTXERXJMHQNUTPJDCBSSMSSSTKJTSSMMTRCPLZSZMLQDSDMJMQPNQDXCFYNBFSDQXYXHYAYKQYDDLQYYYSSZBYDSLNTFQTZQPZMCHDHCZCWFDXTMYQSPHQYYXSRGJCWTJTZZQMGWJJTJHTQJBBHWZPXXHYQFXXQYWYYHYSCDYDHHQMNMTMWCPBSZPPZZGLMZFOLLCFWHMMSJZTTDHZZYFFYTZZGZYSKYJXQYJZQBHMBZZLYGHGFMSHPZFZSNCLPBQSNJXZSLXXFPMTYJYGBXLLDLXPZJYZJYHHZCYWHJYLSJEXFSZZYWXKZJLUYDTMLYMQJPWXYHXSKTQJEZRPXXZHHMHWQPWQLYJJQJJZSZCPHJLCHHNXJLQWZJHBMZYXBDHHYPZLHLHLGFWLCHYYTLHJXCJMSCPXSTKPNHQXSRTYXXTESYJCTLSSLSTDLLLWWYHDHRJZSFGXTSYCZYNYHTDHWJSLHTZDQDJZXXQHGYLTZPHCSQFCLNJTCLZPFSTPDYNYLGMJLLYCQHYSSHCHYLHQYQTMZYPBYWRFQYKQSYSLZDQJMPXYYSSRHZJNYWTQDFZBWWTWWRXCWHGYHXMKMYYYQMSMZHNGCEPMLQQMTCWCTMMPXJPJJHFXYYZSXZHTYBMSTSYJTTQQQYYLHYNPYQZLCYZHZWSMYLKFJXLWGXYPJYTYSYXYMZCKTTWLKSMZSYLMPWLZWXWQZSSAQSYXYRHSSNTSRAPXCPWCMGDXHXZDZYFJHGZTTSBJHGYZSZYSMYCLLLXBTYXHBBZJKSSDMALXHYCFYGMQYPJYCQXJLLLJGSLZGQLYCJCCZOTYXMTMTTLLWTGPXYMZMKLPSZZZXHKQYSXCTYJZYHXSHYXZKXLZWPSQPYHJWPJPWXQQYLXSDHMRSLZZYZWTTCYXYSZZSHBSCCSTPLWSSCJCHNLCGCHSSPHYLHFHHXJSXYLLNYLSZDHZXYLSXLWZYKCLDYAXZCMDDYSPJTQJZLNWQPSSSWCTSTSZLBLNXSMNYYMJQBQHRZWTYYDCHQLXKPZWBGQYBKFCMZWPZLLYYLSZYDWHXPSBCMLJBSCGBHXLQHYRLJXYSWXWXZSLDFHLSLYNJLZYFLYJYCDRJLFSYZFSLLCQYQFGJYHYXZLYLMSTDJCYHBZLLNWLXXYGYYHSMGDHXXHHLZZJZXCZZZCYQZFNGWPYLCPKPYYPMCLQKDGXZGGWQBDXZZKZFBXXLZXJTPJPTTBYTSZZDWSLCHZHSLTYXHQLHYXXXYYZYSWTXZKHLXZXZPYHGCHKCFSYHUTJRLXFJXPTZTWHPLYXFCRHXSHXKYXXYHZQDXQWULHYHMJTBFLKHTXCWHJFWJCFPQRYQXCYYYQYGRPYWSGSUNGWCHKZDXYFLXXHJJBYZWTSXXNCYJJYMSWZJQRMHXZWFQSYLZJZGBHYNSLBGTTCSYBYXXWXYHXYYXNSQYXMQYWRGYQLXBBZLJSYLPSYTJZYHYZAWLRORJMKSCZJXXXYXCHDYXRYXXJDTSQFXLYLTSFFYXLMTYJMJUYYYXLTZCSXQZQHZXLYYXZHDNBRXXXJCTYHLBRLMBRLLAXKYLLLJLYXXLYCRYLCJTGJCMTLZLLCYZZPZPCYAWHJJFYBDYYZSMPCKZDQYQPBPCJPDCYZMDPBCYYDYCNNPLMTMLRMFMMGWYZBSJGYGSMZQQQZTXMKQWGXLLPJGZBQCDJJJFPKJKCXBLJMSWMDTQJXLDLPPBXCWRCQFBFQJCZAHZGMYKPHYYHZYKNDKZMBPJYXPXYHLFPNYYGXJDBKXNXHJMZJXSTRSTLDXSKZYSYBZXJLXYSLBZYSLHXJPFXPQNBYLLJQKYGZMCYZZYMCCSLCLHZFWFWYXZMWSXTYNXJHPYYMCYSPMHYSMYDYSHQYZCHMJJMZCAAGCFJBBHPLYZYLXXSDJGXDHKXXTXXNBHRMLYJSLTXMRHNLXQJXYZLLYSWQGDLBJHDCGJYQYCMHWFMJYBMBYJYJWYMDPWHXQLDYGPDFXXBCGJSPCKRSSYZJMSLBZZJFLJJJLGXZGYXYXLSZQYXBEXYXHGCXBPLDYHWETTWWCJMBTXCHXYQXLLXFLYXLLJLSSFWDPZSMYJCLMWYTCZPCHQEKCQBWLCQYDPLQPPQZQFJQDJHYMMCXTXDRMJWRHXCJZYLQXDYYNHYYHRSLSRSYWWZJYMTLTLLGTQCJZYABTCKZCJYCCQLJZQXALMZYHYWLWDXZXQDLLQSHGPJFJLJHJABCQZDJGTKHSSTCYJLPSWZLXZXRWGLDLZRLZXTGSLLLLZLYXXWGDZYGBDPHZPBRLWSXQBPFDWOFMWHLYPCBJCCLDMBZPBZZLCYQXLDOMZBLZWPDWYYGDSTTHCSQSCCRSSSYSLFYBFNTYJSZDFNDPDHDZZMBBLSLCMYFFGTJJQWFTMTPJWFNLBZCMMJTGBDZLQLPYFHYYMJYLSDCHDZJWJCCTLJCLDTLJJCPDDSQDSSZYBNDBJLGGJZXSXNLYCYBJXQYCBYLZCFZPPGKCXZDZFZTJJFJSJXZBNZYJQTTYJYHTYCZHYMDJXTTMPXSPLZCDWSLSHXYPZGTFMLCJTYCBPMGDKWYCYZCDSZZYHFLYCTYGWHKJYYLSJCXGYWJCBLLCSNDDBTZBSCLYZCZZSSQDLLMQYYHFSLQLLXFTYHABXGWNYWYYPLLSDLDLLBJCYXJZMLHLJDXYYQYTDLLLBUGBFDFBBQJZZMDPJHGCLGMJJPGAEHHBWCQXAXHHHZCHXYPHJAXHLPHJPGPZJQCQZGJJZZUZDMQYYBZZPHYHYBWHAZYJHYKFGDPFQSDLZMLJXKXGALXZDAGLMDGXMWZQYXXDXXPFDMMSSYMPFMDMMKXKSYZYSHDZKXSYSMMZZZMSYDNZZCZXFPLSTMZDNMXCKJMZTYYMZMZZMSXHHDCZJEMXXKLJSTLWLSQLYJZLLZJSSDPPMHNLZJCZYHMXXHGZCJMDHXTKGRMXFWMCGMWKDTKSXQMMMFZZYDKMSCLCMPCGMHSPXQPZDSSLCXKYXTWLWJYAHZJGZQMCSNXYYMMPMLKJXMHLMLQMXCTKZMJQYSZJSYSZHSYJZJCDAJZYBSDQJZGWZQQXFKDMSDJLFWEHKZQKJPEYPZYSZCDWYJFFMZZYLTTDZZEFMZLBNPPLPLPEPSZALLTYLKCKQZKGENQLWAGYXYDPXLHSXQQWQCQXQCLHYXXMLYCCWLYMQYSKGCHLCJNSZKPYZKCQZQLJPDMDZHLASXLBYDWQLWDNBQCRYDDZTJYBKBWSZDXDTNPJDTCTQDFXQQMGNXECLTTBKPWSLCTYQLPWYZZKLPYGZCQQPLLKCCYLPQMZCZQCLJSLQZDJXLDDHPZQDLJJXZQDXYZQKZLJCYQDYJPPYPQYKJYRMPCBYMCXKLLZLLFQPYLLLMBSGLCYSSLRSYSQTMXYXZQZFDZUYSYZTFFMZZSMZQHZSSCCMLYXWTPZGXZJGZGSJSGKDDHTQGGZLLBJDZLCBCHYXYZHZFYWXYZYMSDBZZYJGTSMTFXQYXQSTDGSLNXDLRYZZLRYYLXQHTXSRTZNGZXBNQQZFMYKMZJBZYMKBPNLYZPBLMCNQYZZZSJZHJCTZKHYZZJRDYZHNPXGLFZTLKGJTCTSSYLLGZRZBBQZZKLPKLCZYSSUYXBJFPNJZZXCDWXZYJXZZDJJKGGRSRJKMSMZJLSJYWQSKYHQJSXPJZZZLSNSHRNYPZTWCHKLPSRZLZXYJQXQKYSJYCZTLQZYBBYBWZPQDWWYZCYTJCJXCKCWDKKZXSGKDZXWWYYJQYYTCYTDLLXWKCZKKLCCLZCQQDZLQLCSFQCHQHSFSMQZZLNBJJZBSJHTSZDYSJQJPDLZCDCWJKJZZLPYCGMZWDJJBSJQZSYZYHHXJPBJYDSSXDZNCGLQMBTSFSBPDZDLZNFGFJGFSMPXJQLMBLGQCYYXBQKDJJQYRFKZTJDHCZKLBSDZCFJTPLLJGXHYXZCSSZZXSTJYGKGCKGYOQXJPLZPBPGTGYJZGHZQZZLBJLSQFZGKQQJZGYCZBZQTLDXRJXBSXXPZXHYZYCLWDXJJHXMFDZPFZHQHQMQGKSLYHTYCGFRZGNQXCLPDLBZCSCZQLLJBLHBZCYPZZPPDYMZZSGYHCKCPZJGSLJLNSCDSLDLXBMSTLDDFJMKDJDHZLZXLSZQPQPGJLLYBDSZGQLBZLSLKYYHZTTNTJYQTZZPSZQZTLLJTYYLLQLLQYZQLBDZLSLYYZYMDFSZSNHLXZNCZQZPBWSKRFBSYZMTHBLGJPMCZZLSTLXSHTCSYZLZBLFEQHLXFLCJLYLJQCBZLZJHHSSTBRMHXZHJZCLXFNBGXGTQJCZTMSFZKJMSSNXLJKBHSJXNTNLZDNTLMSJXGZJYJCZXYJYJWRWWQNZTNFJSZPZSHZJFYRDJSFSZJZBJFZQZZHZLXFYSBZQLZSGYFTZDCSZXZJBQMSZKJRHYJZCKMJKHCHGTXKXQGLXPXFXTRTYLXJXHDTSJXHJZJXZWZLCQSBTXWXGXTXXHXFTSDKFJHZYJFJXRZSDLLLTQSQQZQWZXSYQTWGWBZCGZLLYZBCLMQQTZHZXZXLJFRMYZFLXYSQXXJKXRMQDZDMMYYBSQBHGZMWFWXGMXLZPYYTGZYCCDXYZXYWGSYJYZNBHPZJSQSYXSXRTFYZGRHZTXSZZTHCBFCLSYXZLZQMZLMPLMXZJXSFLBYZMYQHXJSXRXSQZZZSSLYFRCZJRCRXHHZXQYDYHXSJJHZCXZBTYNSYSXJBQLPXZQPYMLXZKYXLXCJLCYSXXZZLXDLLLJJYHZXGYJWKJRWYHCPSGNRZLFZWFZZNSXGXFLZSXZZZBFCSYJDBRJKRDHHGXJLJJTGXJXXSTJTJXLYXQFCSGSWMSBCTLQZZWLZZKXJMLTMJYHSDDBXGZHDLBMYJFRZFSGCLYJBPMLYSMSXLSZJQQHJZFXGFQFQBPXZGYYQXGZTCQWYLTLGWSGWHRLFSFGZJMGMGBGTJFSYZZGZYZAFLSSPMLPFLCWBJZCLJJMZLPJJLYMQDMYYYFBGYGYZMLYZDXQYXRQQQHSYYYQXYLJTYXFSFSLLGNQCYHYCWFHCCCFXPYLYPLLZYXXXXXKQHHXSHJZCFZSCZJXCPZWHHHHHAPYLQALPQAFYHXDYLUKMZQGGGDDESRNNZLTZGCHYPPYSQJJHCLLJTOLNJPZLJLHYMHEYDYDSQYCDDHGZUNDZCLZYZLLZNTNYZGSLHSLPJJBDGWXPCDUTJCKLKCLWKLLCASSTKZZDNQNTTLYYZSSYSSZZRYLJQKCQDHHCRXRZYDGRGCWCGZQFFFPPJFZYNAKRGYWYQPQXXFKJTSZZXSWZDDFBBXTBGTZKZNPZZPZXZPJSZBMQHKCYXYLDKLJNYPKYGHGDZJXXEAHPNZKZTZCMXCXMMJXNKSZQNMNLWBWWXJKYHCPSTMCSQTZJYXTPCTPDTNNPGLLLZSJLSPBLPLQHDTNJNLYYRSZFFJFQWDPHZDWMRZCCLODAXNSSNYZRESTYJWJYJDBCFXNMWTTBYLWSTSZGYBLJPXGLBOCLHPCBJLTMXZLJYLZXCLTPNCLCKXTPZJSWCYXSFYSZDKNTLBYJCYJLLSTGQCBXRYZXBXKLYLHZLQZLNZCXWJZLJZJNCJHXMNZZGJZZXTZJXYCYYCXXJYYXJJXSSSJSTSSTTPPGQTCSXWZDCSYFPTFBFHFBBLZJCLZZDBXGCXLQPXKFZFLSYLTUWBMQJHSZBMDDBCYSCCLDXYCDDQLYJJWMQLLCSGLJJSYFPYYCCYLTJANTJJPWYCMMGQYYSXDXQMZHSZXPFTWWZQSWQRFKJLZJQQYFBRXJHHFWJJZYQAZMYFRHCYYBYQWLPEXCCZSTYRLTTDMQLYKMBBGMYYJPRKZNPBSXYXBHYZDJDNGHPMFSGMWFZMFQMMBCMZZCJJLCNUXYQLMLRYGQZCYXZLWJGCJCGGMCJNFYZZJHYCPRRCMTZQZXHFQGTJXCCJEAQCRJYHPLQLSZDJRBCQHQDYRHYLYXJSYMHZYDWLDFRYHBPYDTSSCNWBXGLPZMLZZTQSSCPJMXXYCSJYTYCGHYCJWYRXXLFEMWJNMKLLSWTXHYYYNCMMCWJDQDJZGLLJWJRKHPZGGFLCCSCZMCBLTBHBQJXQDSPDJZZGKGLFQYWBZYZJLTSTDHQHCTCBCHFLQMPWDSHYYTQWCNZZJTLBYMBPDYYYXSQKXWYYFLXXNCWCXYPMAELYKKJMZZZBRXYYQJFLJPFHHHYTZZXSGQQMHSPGDZQWBWPJHZJDYSCQWZKTXXSQLZYYMYSDZGRXCKKUJLWPYSYSCSYZLRMLQSYLJXBCXTLWDQZPCYCYKPPPNSXFYZJJRCEMHSZMSXLXGLRWGCSTLRSXBZGBZGZTCPLUJLSLYLYMTXMTZPALZXPXJTJWTCYYZLBLXBZLQMYLXPGHDSLSSDMXMBDZZSXWHAMLCZCPJMCNHJYSNSYGCHSKQMZZQDLLKABLWJXSFMOCDXJRRLYQZKJMYBYQLYHETFJZFRFKSRYXFJTWDSXXSYSQJYSLYXWJHSNLXYYXHBHAWHHJZXWMYLJCSSLKYDZTXBZSYFDXGXZJKHSXXYBSSXDPYNZWRPTQZCZENYGCXQFJYKJBZMLJCMQQXUOXSLYXXLYLLJDZBTYMHPFSTTQQWLHOKYBLZZALZXQLHZWRRQHLSTMYPYXJJXMQSJFNBXYXYJXXYQYLTHYLQYFMLKLJTMLLHSZWKZHLJMLHLJKLJSTLQXYLMBHHLNLZXQJHXCFXXLHYHJJGBYZZKBXSCQDJQDSUJZYYHZHHMGSXCSYMXFEBCQWWRBPYYJQTYZCYQYQQZYHMWFFHGZFRJFCDPXNTQYZPDYKHJLFRZXPPXZDBBGZQSTLGDGYLCQMLCHHMFYWLZYXKJLYPQHSYWMQQGQZMLZJNSQXJQSYJYCBEHSXFSZPXZWFLLBCYYJDYTDTHWZSFJMQQYJLMQXXLLDTTKHHYBFPWTYYSQQWNQWLGWDEBZWCMYGCULKJXTMXMYJSXHYBRWFYMWFRXYQMXYSZTZZTFYKMLDHQDXWYYNLCRYJBLPSXCXYWLSPRRJWXHQYPHTYDNXHHMMYWYTZCSQMTSSCCDALWZTCPQPYJLLQZYJSWXMZZMMYLMXCLMXCZMXMZSQTZPPQQBLPGXQZHFLJJHYTJSRXWZXSCCDLXTYJDCQJXSLQYCLZXLZZXMXQRJMHRHZJBHMFLJLMLCLQNLDXZLLLPYPSYJYSXCQQDCMQJZZXHNPNXZMEKMXHYKYQLXSXTXJYYHWDCWDZHQYYBGYBCYSCFGPSJNZDYZZJZXRZRQJJYMCANYRJTLDPPYZBSTJKXXZYPFDWFGZZRPYMTNGXZQBYXNBUFNQKRJQZMJEGRZGYCLKXZDSKKNSXKCLJSPJYYZLQQJYBZSSQLLLKJXTBKTYLCCDDBLSPPFYLGYDTZJYQGGKQTTFZXBDKTYYHYBBFYTYYBCLPDYTGDHRYRNJSPTCSNYJQHKLLLZSLYDXXWBCJQSPXBPJZJCJDZFFXXBRMLAZHCSNDLBJDSZBLPRZTSWSBXBCLLXXLZDJZSJPYLYXXYFTFFFBHJJXGBYXJPMMMPSSJZJMTLYZJXSWXTYLEDQPJMYGQZJGDJLQJWJQLLSJGJGYGMSCLJJXDTYGJQJQJCJZCJGDZZSXQGSJGGCXHQXSNQLZZBXHSGZXCXYLJXYXYYDFQQJHJFXDHCTXJYRXYSQTJXYEFYYSSYYJXNCYZXFXMSYSZXYYSCHSHXZZZGZZZGFJDLTYLNPZGYJYZYYQZPBXQBDZTZCZYXXYHHSQXSHDHGQHJHGYWSZTMZMLHYXGEBTYLZKQWYTJZRCLEKYSTDBCYKQQSAYXCJXWWGSBHJYZYDHCSJKQCXSWXFLTYNYZPZCCZJQTZWJQDZZZQZLJJXLSBHPYXXPSXSHHEZTXFPTLQYZZXHYTXNCFZYYHXGNXMYWXTZSJPTHHGYMXMXQZXTSBCZYJYXXTYYZYPCQLMMSZMJZZLLZXGXZAAJZYXJMZXWDXZSXZDZXLEYJJZQBHZWZZZQTZPSXZTDSXJJJZNYAZPHXYYSRNQDTHZHYYKYJHDZXZLSWCLYBZYECWCYCRYLCXNHZYDZYDYJDFRJJHTRSQTXYXJRJHOJYNXELXSFSFJZGHPZSXZSZDZCQZBYYKLSGSJHCZSHDGQGXYZGXCHXZJWYQWGYHKSSEQZZNDZFKWYSSTCLZSTSYMCDHJXXYWEYXCZAYDMPXMDSXYBSQMJMZJMTZQLPJYQZCGQHXJHHLXXHLHDLDJQCLDWBSXFZZYYSCHTYTYYBHECXHYKGJPXHHYZJFXHWHBDZFYZBCAPNPGNYDMSXHMMMMAMYNBYJTMPXYYMCTHJBZYFCGTYHWPHFTWZZEZSBZEGPFMTSKFTYCMHFLLHGPZJXZJGZJYXZSBBQSCZZLZCCSTPGXMJSFTCCZJZDJXCYBZLFCJSYZFGSZLYBCWZZBYZDZYPSWYJZXZBDSYUXLZZBZFYGCZXBZHZFTPBGZGEJBSTGKDMFHYZZJHZLLZZGJQZLSFDJSSCBZGPDLFZFZSZYZYZSYGCXSNXXCHCZXTZZLJFZGQSQYXZJQDCCZTQCDXZJYQJQCHXZTDLGSCXZSYQJQTZWLQDQZTQCHQQJZYEZZZPBWKDJFCJPZTYPQYQTTYNLMBDKTJZPQZQZZFPZSBNJLGYJDXJDZZKZGQKXDLPZJTCJDQBXDJQJSTCKNXBXZMSLYJCQMTJQWWCJQNJNLLLHJCWQTBZQYDZCZPZZDZYDDCYZZZCCJTTJFZDPRRTZTJDCQTQZDTJNPLZBCLLCTZSXKJZQZPZLBZRBTJDCXFCZDBCCJJLTQQPLDCGZDBBZJCQDCJWYNLLZYZCCDWLLXWZLXRXNTQQCZXKQLSGDFQTDDGLRLAJJTKUYMKQLLTZYTDYYCZGJWYXDXFRSKSTQTENQMRKQZHHQKDLDAZFKYPBGGPZREBZZYKZZSPEGJXGYKQZZZSLYSYYYZWFQZYLZZLZHWCHKYPQGNPGBLPLRRJYXCCSYYHSFZFYBZYYTGZXYLXCZWXXZJZBLFFLGSKHYJZEYJHLPLLLLCZGXDRZELRHGKLZZYHZLYQSZZJZQLJZFLNBHGWLCZCFJYSPYXZLZLXGCCPZBLLCYBBBBUBBCBPCRNNZCZYRBFSRLDCGQYYQXYGMQZWTZYTYJXYFWTEHZZJYWLCCNTZYJJZDEDPZDZTSYQJHDYMBJNYJZLXTSSTPHNDJXXBYXQTZQDDTJTDYYTGWSCSZQFLSHLGLBCZPHDLYZJYCKWTYTYLBNYTSDSYCCTYSZYYEBHEXHQDTWNYGYCLXTSZYSTQMYGZAZCCSZZDSLZCLZRQXYYELJSBYMXSXZTEMBBLLYYLLYTDQYSHYMRQWKFKBFXNXSBYCHXBWJYHTQBPBSBWDZYLKGZSKYHXQZJXHXJXGNLJKZLYYCDXLFYFGHLJGJYBXQLYBXQPQGZTZPLNCYPXDJYQYDYMRBESJYYHKXXSTMXRCZZYWXYQYBMCLLYZHQYZWQXDBXBZWZMSLPDMYSKFMZKLZCYQYCZLQXFZZYDQZPZYGYJYZMZXDZFYFYTTQTZHGSPCZMLCCYTZXJCYTJMKSLPZHYSNZLLYTPZCTZZCKTXDHXXTQCYFKSMQCCYYAZHTJPCYLZLYJBJXTPNYLJYYNRXSYLMMNXJSMYBCSYSYLZYLXJJQYLDZLPQBFZZBLFNDXQKCZFYWHGQMRDSXYCYTXNQQJZYYPFZXDYZFPRXEJDGYQBXRCNFYYQPGHYJDYZXGRHTKYLNWDZNTSMPKLBTHBPYSZBZTJZSZZJTYYXZPHSSZZBZCZPTQFZMYFLYPYBBJQXZMXXDJMTSYSKKBJZXHJCKLPSMKYJZCXTMLJYXRZZQSLXXQPYZXMKYXXXJCLJPRMYYGADYSKQLSNDHYZKQXZYZTCGHZTLMLWZYBWSYCTBHJHJFCWZTXWYTKZLXQSHLYJZJXTMPLPYCGLTBZZTLZJCYJGDTCLKLPLLQPJMZPAPXYZLKKTKDZCZZBNZDYDYQZJYJGMCTXLTGXSZLMLHBGLKFWNWZHDXUHLFMKYSLGXDTWWFRJEJZTZHYDXYKSHWFZCQSHKTMQQHTZHYMJDJSKHXZJZBZZXYMPAGQMSTPXLSKLZYNWRTSQLSZBPSPSGZWYHTLKSSSWHZZLYYTNXJGMJSZSUFWNLSOZTXGXLSAMMLBWLDSZYLAKQCQCTMYCFJBSLXCLZZCLXXKSBZQCLHJPSQPLSXXCKSLNHPSFQQYTXYJZLQLDXZQJZDYYDJNZPTUZDSKJFSLJHYLZSQZLBTXYDGTQFDBYAZXDZHZJNHHQBYKNXJJQCZMLLJZKSPLDYCLBBLXKLELXJLBQYCXJXGCNLCQPLZLZYJTZLJGYZDZPLTQCSXFDMNYCXGBTJDCZNBGBQYQJWGKFHTNPYQZQGBKPBBYZMTJDYTBLSQMPSXTBNPDXKLEMYYCJYNZCTLDYKZZXDDXHQSHDGMZSJYCCTAYRZLPYLTLKXSLZCGGEXCLFXLKJRTLQJAQZNCMBYDKKCXGLCZJZXJHPTDJJMZQYKQSECQZDSHHADMLZFMMZBGNTJNNLGBYJBRBTMLBYJDZXLCJLPLDLPCQDHLXZLYCBLCXZZJADJLNZMMSSSMYBHBSQKBHRSXXJMXSDZNZPXLGBRHWGGFCXGMSKLLTSJYYCQLTSKYWYYHYWXBXQYWPYWYKQLSQPTNTKHQCWDQKTWPXXHCPTHTWUMSSYHBWCRWXHJMKMZNGWTMLKFGHKJYLSYYCXWHYECLQHKQHTTQKHFZLDXQWYZYYDESBPKYRZPJFYYZJCEQDZZDLATZBBFJLLCXDLMJSSXEGYGSJQXCWBXSSZPDYZCXDNYXPPZYDLYJCZPLTXLSXYZYRXCYYYDYLWWNZSAHJSYQYHGYWWAXTJZDAXYSRLTDPSSYYFNEJDXYZHLXLLLZQZSJNYQYQQXYJGHZGZCYJCHZLYCDSHWSHJZYJXCLLNXZJJYYXNFXMWFPYLCYLLABWDDHWDXJMCXZTZPMLQZHSFHZYNZTLLDYWLSLXHYMMYLMBWWKYXYADTXYLLDJPYBPWUXJMWMLLSAFDLLYFLBHHHBQQLTZJCQJLDJTFFKMMMBYTHYGDCQRDDWRQJXNBYSNWZDBYYTBJHPYBYTTJXAAHGQDQTMYSTQXKBTZPKJLZRBEQQSSMJJBDJOTGTBXPGBKTLHQXJJJCTHXQDWJLWRFWQGWSHCKRYSWGFTGYGBXSDWDWRFHWYTJJXXXJYZYSLPYYYPAYXHYDQKXSHXYXGSKQHYWFDDDPPLCJLQQEEWXKSYYKDYPLTJTHKJLTCYYHHJTTPLTZZCDLTHQKZXQYSTEEYWYYZYXXYYSTTJKLLPZMCYHQGXYHSRMBXPLLNQYDQHXSXXWGDQBSHYLLPJJJTHYJKYPPTHYYKTYEZYENMDSHLCRPQFDGFXZPSFTLJXXJBSWYYSKSFLXLPPLBBBLBSFXFYZBSJSSYLPBBFFFFSSCJDSTZSXZRYYSYFFSYZYZBJTBCTSBSDHRTJJBYTCXYJEYLXCBNEBJDSYXYKGSJZBXBYTFZWGENYHHTHZHHXFWGCSTBGXKLSXYWMTMBYXJSTZSCDYQRCYTWXZFHMYMCXLZNSDJTTTXRYCFYJSBSDYERXJLJXBBDEYNJGHXGCKGSCYMBLXJMSZNSKGXFBNBPTHFJAAFXYXFPXMYPQDTZCXZZPXRSYWZDLYBBKTYQPQJPZYPZJZNJPZJLZZFYSBTTSLMPTZRTDXQSJEHBZYLZDHLJSQMLHTXTJECXSLZZSPKTLZKQQYFSYGYWPCPQFHQHYTQXZKRSGTTSQCZLPTXCDYYZXSQZSLXLZMYCPCQBZYXHBSXLZDLTCDXTYLZJYYZPZYZLTXJSJXHLPMYTXCQRBLZSSFJZZTNJYTXMYJHLHPPLCYXQJQQKZZSCPZKSWALQSBLCCZJSXGWWWYGYKTJBBZTDKHXHKGTGPBKQYSLPXPJCKBMLLXDZSTBKLGGQKQLSBKKTFXRMDKBFTPZFRTBBRFERQGXYJPZSSTLBZTPSZQZSJDHLJQLZBPMSMMSXLQQNHKNBLRDDNXXDHDDJCYYGYLXGZLXSYGMQQGKHBPMXYXLYTQWLWGCPBMQXCYZYDRJBHTDJYHQSHTMJSBYPLWHLZFFNYPMHXXHPLTBQPFBJWQDBYGPNZTPFZJGSDDTQSHZEAWZZYLLTYYBWJKXXGHLFKXDJTMSZSQYNZGGSWQSPHTLSSKMCLZXYSZQZXNCJDQGZDLFNYKLJCJLLZLMZZNHYDSSHTHZZLZZBBHQZWWYCRZHLYQQJBEYFXXXWHSRXWQHWPSLMSSKZTTYGYQQWRSLALHMJTQJSMXQBJJZJXZYZKXBYQXBJXSHZTSFJLXMXZXFGHKZSZGGYLCLSARJYHSLLLMZXELGLXYDJYTLFBHBPNLYZFBBHPTGJKWETZHKJJXZXXGLLJLSTGSHJJYQLQZFKCGNNDJSSZFDBCTWWSEQFHQJBSAQTGYPQLBXBMMYWXGSLZHGLZGQYFLZBYFZJFRYSFMBYZHQGFWZSYFYJJPHZBYYZFFWODGRLMFTWLBZGYCQXCDJYGZYYYYTYTYDWEGAZYHXJLZYYHLRMGRXXZCLHNELJJTJTPWJYBJJBXJJTJTEEKHWSLJPLPSFYZPQQBDLQJJTYYQLYZKDKSQJYYQZLDQTGJQYZJSUCMRYQTHTEJMFCTYHYPKMHYZWJDQFHYYXWSHCTXRLJHQXHCCYYYJLTKTTYTMXGTCJTZAYYOCZLYLBSZYWJYTSJYHBYSHFJLYGJXXTMZYYLTXXYPZLXYJZYZYYPNHMYMDYYLBLHLSYYQQLLNJJYMSOYQBZGDLYXYLCQYXTSZEGXHZGLHWBLJHEYXTWQMAKBPQCGYSHHEGQCMWYYWLJYJHYYZLLJJYLHZYHMGSLJLJXCJJYCLYCJPCPZJZJMMYLCQLNQLJQJSXYJMLSZLJQLYCMMHCFMMFPQQMFYLQMCFFQMMMMHMZNFHHJGTTHHKHSLNCHHYQDXTMMQDCYZYXYQMYQYLTDCYYYZAZZCYMZYDLZFFFMMYCQZWZZMABTBYZTDMNZZGGDFTYPCGQYTTSSFFWFDTZQSSYSTWXJHXYTSXXYLBYQHWWKXHZXWZNNZZJZJJQJCCCHYYXBZXZCYZTLLCQXYNJYCYYCYNZZQYYYEWYCZDCJYCCHYJLBTZYYCQWMPWPYMLGKDLDLGKQQBGYCHJXY";

pinyin_dict_firstletter.polyPhone = { "19969": "DZ", "19975": "WM", "19988": "QJ", "20048": "YL", "20056": "SC", "20060": "NM", "20094": "QG", "20127": "QJ", "20167": "QC", "20193": "YG", "20250": "KH", "20256": "ZC", "20282": "SC", "20285": "QJG", "20291": "TD", "20314": "YD", "20340": "NE", "20375": "TD", "20389": "YJ", "20391": "CZ", "20415": "PB", "20446": "YS", "20447": "SQ", "20608": "KG", "20854": "QJ", "20504": "TC", "20857": "ZC", "20911": "PF", "20985": "AW", "21032": "PB", "21048": "XQ", "21049": "SC", "21089": "YS", "21119": "JC", "21242": "SB", "21273": "SC", "21305": "YP", "21306": "QO", "21330": "ZC", "21333": "SDC", "21345": "QK", "21378": "CA", "21397": "SC", "21414": "XS", "21442": "SC", "21477": "JG", "21480": "TD", "21484": "ZS", "21494": "YX", "21505": "YX", "21512": "HG", "21523": "XH", "21537": "PB", "21542": "PF", "21549": "KH", "21571": "E", "21574": "DA", "21588": "TD", "21589": "O", "21618": "ZC", "21621": "KHA", "21632": "ZJ", "21654": "KG", "21679": "LKG", "21683": "KH", "21710": "A", "21719": "YH", "21734": "WOE", "21769": "A", "21780": "WN", "21804": "XH", "21834": "A", "21899": "ZD", "21903": "RN", "21908": "WO", "21939": "ZC", "21956": "SA", "21964": "YA", "21970": "TD", "22003": "A", "22031": "JG", "22040": "XS", "22060": "ZC", "22066": "ZC", "22079": "MH", "22129": "XJ", "22179": "XA", "22237": "NJ", "22244": "TD", "22280": "JQ", "22300": "YH", "22313": "XW", "22331": "YQ", "22343": "YJ", "22351": "PH", "22395": "DC", "22412": "TD", "22484": "PB", "22500": "PB", "22534": "ZD", "22549": "DH", "22561": "PB", "22612": "TD", "22771": "KQ", "22831": "HB", "22841": "JG", "22855": "QJ", "22865": "XQ", "23013": "ML", "23081": "WM", "23487": "SX", "23558": "QJ", "23561": "YW", "23586": "YW", "23614": "YW", "23615": "SN", "23631": "PB", "23646": "ZS", "23663": "ZT", "23673": "YG", "23762": "TD", "23769": "ZS", "23780": "QJ", "23884": "QK", "24055": "XH", "24113": "DC", "24162": "ZC", "24191": "GA", "24273": "QJ", "24324": "NL", "24377": "TD", "24378": "QJ", "24439": "PF", "24554": "ZS", "24683": "TD", "24694": "WE", "24733": "LK", "24925": "TN", "25094": "ZG", "25100": "XQ", "25103": "XH", "25153": "PB", "25170": "PB", "25179": "KG", "25203": "PB", "25240": "ZS", "25282": "FB", "25303": "NA", "25324": "KG", "25341": "ZY", "25373": "WZ", "25375": "XJ", "25384": "A", "25457": "A", "25528": "SD", "25530": "SC", "25552": "TD", "25774": "ZC", "25874": "ZC", "26044": "YW", "26080": "WM", "26292": "PB", "26333": "PB", "26355": "ZY", "26366": "CZ", "26397": "ZC", "26399": "QJ", "26415": "ZS", "26451": "SB", "26526": "ZC", "26552": "JG", "26561": "TD", "26588": "JG", "26597": "CZ", "26629": "ZS", "26638": "YL", "26646": "XQ", "26653": "KG", "26657": "XJ", "26727": "HG", "26894": "ZC", "26937": "ZS", "26946": "ZC", "26999": "KJ", "27099": "KJ", "27449": "YQ", "27481": "XS", "27542": "ZS", "27663": "ZS", "27748": "TS", "27784": "SC", "27788": "ZD", "27795": "TD", "27812": "O", "27850": "PB", "27852": "MB", "27895": "SL", "27898": "PL", "27973": "QJ", "27981": "KH", "27986": "HX", "27994": "XJ", "28044": "YC", "28065": "WG", "28177": "SM", "28267": "QJ", "28291": "KH", "28337": "ZQ", "28463": "TL", "28548": "DC", "28601": "TD", "28689": "PB", "28805": "JG", "28820": "QG", "28846": "PB", "28952": "TD", "28975": "ZC", "29100": "A", "29325": "QJ", "29575": "SL", "29602": "FB", "30010": "TD", "30044": "CX", "30058": "PF", "30091": "YSP", "30111": "YN", "30229": "XJ", "30427": "SC", "30465": "SX", "30631": "YQ", "30655": "QJ", "30684": "QJG", "30707": "SD", "30729": "XH", "30796": "LG", "30917": "PB", "31074": "NM", "31085": "JZ", "31109": "SC", "31181": "ZC", "31192": "MLB", "31293": "JQ", "31400": "YX", "31584": "YJ", "31896": "ZN", "31909": "ZY", "31995": "XJ", "32321": "PF", "32327": "ZY", "32418": "HG", "32420": "XQ", "32421": "HG", "32438": "LG", "32473": "GJ", "32488": "TD", "32521": "QJ", "32527": "PB", "32562": "ZSQ", "32564": "JZ", "32735": "ZD", "32793": "PB", "33071": "PF", "33098": "XL", "33100": "YA", "33152": "PB", "33261": "CX", "33324": "BP", "33333": "TD", "33406": "YA", "33426": "WM", "33432": "PB", "33445": "JG", "33486": "ZN", "33493": "TS", "33507": "QJ", "33540": "QJ", "33544": "ZC", "33564": "XQ", "33617": "YT", "33632": "QJ", "33636": "XH", "33637": "YX", "33694": "WG", "33705": "PF", "33728": "YW", "33882": "SR", "34067": "WM", "34074": "YW", "34121": "QJ", "34255": "ZC", "34259": "XL", "34425": "JH", "34430": "XH", "34485": "KH", "34503": "YS", "34532": "HG", "34552": "XS", "34558": "YE", "34593": "ZL", "34660": "YQ", "34892": "XH", "34928": "SC", "34999": "QJ", "35048": "PB", "35059": "SC", "35098": "ZC", "35203": "TQ", "35265": "JX", "35299": "JX", "35782": "SZ", "35828": "YS", "35830": "E", "35843": "TD", "35895": "YG", "35977": "MH", "36158": "JG", "36228": "QJ", "36426": "XQ", "36466": "DC", "36710": "JC", "36711": "ZYG", "36767": "PB", "36866": "SK", "36951": "YW", "37034": "YX", "37063": "XH", "37218": "ZC", "37325": "ZC", "38063": "PB", "38079": "TD", "38085": "QY", "38107": "DC", "38116": "TD", "38123": "YD", "38224": "HG", "38241": "XTC", "38271": "ZC", "38415": "YE", "38426": "KH", "38461": "YD", "38463": "AE", "38466": "PB", "38477": "XJ", "38518": "YT", "38551": "WK", "38585": "ZC", "38704": "XS", "38739": "LJ", "38761": "GJ", "38808": "SQ", "39048": "JG", "39049": "XJ", "39052": "HG", "39076": "CZ", "39271": "XT", "39534": "TD", "39552": "TD", "39584": "PB", "39647": "SB", "39730": "LG", "39748": "TPB", "40109": "ZQ", "40479": "ND", "40516": "HG", "40536": "HG", "40583": "QJ", "40765": "YQ", "40784": "QJ", "40840": "YK", "40863": "QJG" };
exports.default = pinyin_dict_firstletter;

/***/ }),

/***/ 156:
/***/ (function(module, exports, __webpack_require__) {

/* WEBPACK VAR INJECTION */(function(global, process) {// Copyright Joyent, Inc. and other Node contributors.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.

var formatRegExp = /%[sdj%]/g;
exports.format = function(f) {
  if (!isString(f)) {
    var objects = [];
    for (var i = 0; i < arguments.length; i++) {
      objects.push(inspect(arguments[i]));
    }
    return objects.join(' ');
  }

  var i = 1;
  var args = arguments;
  var len = args.length;
  var str = String(f).replace(formatRegExp, function(x) {
    if (x === '%%') return '%';
    if (i >= len) return x;
    switch (x) {
      case '%s': return String(args[i++]);
      case '%d': return Number(args[i++]);
      case '%j':
        try {
          return JSON.stringify(args[i++]);
        } catch (_) {
          return '[Circular]';
        }
      default:
        return x;
    }
  });
  for (var x = args[i]; i < len; x = args[++i]) {
    if (isNull(x) || !isObject(x)) {
      str += ' ' + x;
    } else {
      str += ' ' + inspect(x);
    }
  }
  return str;
};


// Mark that a method should not be used.
// Returns a modified function which warns once by default.
// If --no-deprecation is set, then it is a no-op.
exports.deprecate = function(fn, msg) {
  // Allow for deprecating things in the process of starting up.
  if (isUndefined(global.process)) {
    return function() {
      return exports.deprecate(fn, msg).apply(this, arguments);
    };
  }

  if (process.noDeprecation === true) {
    return fn;
  }

  var warned = false;
  function deprecated() {
    if (!warned) {
      if (process.throwDeprecation) {
        throw new Error(msg);
      } else if (process.traceDeprecation) {
        console.trace(msg);
      } else {
        console.error(msg);
      }
      warned = true;
    }
    return fn.apply(this, arguments);
  }

  return deprecated;
};


var debugs = {};
var debugEnviron;
exports.debuglog = function(set) {
  if (isUndefined(debugEnviron))
    debugEnviron = Object({"NODE_ENV":"production"}).NODE_DEBUG || '';
  set = set.toUpperCase();
  if (!debugs[set]) {
    if (new RegExp('\\b' + set + '\\b', 'i').test(debugEnviron)) {
      var pid = process.pid;
      debugs[set] = function() {
        var msg = exports.format.apply(exports, arguments);
        console.error('%s %d: %s', set, pid, msg);
      };
    } else {
      debugs[set] = function() {};
    }
  }
  return debugs[set];
};


/**
 * Echos the value of a value. Trys to print the value out
 * in the best way possible given the different types.
 *
 * @param {Object} obj The object to print out.
 * @param {Object} opts Optional options object that alters the output.
 */
/* legacy: obj, showHidden, depth, colors*/
function inspect(obj, opts) {
  // default options
  var ctx = {
    seen: [],
    stylize: stylizeNoColor
  };
  // legacy...
  if (arguments.length >= 3) ctx.depth = arguments[2];
  if (arguments.length >= 4) ctx.colors = arguments[3];
  if (isBoolean(opts)) {
    // legacy...
    ctx.showHidden = opts;
  } else if (opts) {
    // got an "options" object
    exports._extend(ctx, opts);
  }
  // set default options
  if (isUndefined(ctx.showHidden)) ctx.showHidden = false;
  if (isUndefined(ctx.depth)) ctx.depth = 2;
  if (isUndefined(ctx.colors)) ctx.colors = false;
  if (isUndefined(ctx.customInspect)) ctx.customInspect = true;
  if (ctx.colors) ctx.stylize = stylizeWithColor;
  return formatValue(ctx, obj, ctx.depth);
}
exports.inspect = inspect;


// http://en.wikipedia.org/wiki/ANSI_escape_code#graphics
inspect.colors = {
  'bold' : [1, 22],
  'italic' : [3, 23],
  'underline' : [4, 24],
  'inverse' : [7, 27],
  'white' : [37, 39],
  'grey' : [90, 39],
  'black' : [30, 39],
  'blue' : [34, 39],
  'cyan' : [36, 39],
  'green' : [32, 39],
  'magenta' : [35, 39],
  'red' : [31, 39],
  'yellow' : [33, 39]
};

// Don't use 'blue' not visible on cmd.exe
inspect.styles = {
  'special': 'cyan',
  'number': 'yellow',
  'boolean': 'yellow',
  'undefined': 'grey',
  'null': 'bold',
  'string': 'green',
  'date': 'magenta',
  // "name": intentionally not styling
  'regexp': 'red'
};


function stylizeWithColor(str, styleType) {
  var style = inspect.styles[styleType];

  if (style) {
    return '\u001b[' + inspect.colors[style][0] + 'm' + str +
           '\u001b[' + inspect.colors[style][1] + 'm';
  } else {
    return str;
  }
}


function stylizeNoColor(str, styleType) {
  return str;
}


function arrayToHash(array) {
  var hash = {};

  array.forEach(function(val, idx) {
    hash[val] = true;
  });

  return hash;
}


function formatValue(ctx, value, recurseTimes) {
  // Provide a hook for user-specified inspect functions.
  // Check that value is an object with an inspect function on it
  if (ctx.customInspect &&
      value &&
      isFunction(value.inspect) &&
      // Filter out the util module, it's inspect function is special
      value.inspect !== exports.inspect &&
      // Also filter out any prototype objects using the circular check.
      !(value.constructor && value.constructor.prototype === value)) {
    var ret = value.inspect(recurseTimes, ctx);
    if (!isString(ret)) {
      ret = formatValue(ctx, ret, recurseTimes);
    }
    return ret;
  }

  // Primitive types cannot have properties
  var primitive = formatPrimitive(ctx, value);
  if (primitive) {
    return primitive;
  }

  // Look up the keys of the object.
  var keys = Object.keys(value);
  var visibleKeys = arrayToHash(keys);

  if (ctx.showHidden) {
    keys = Object.getOwnPropertyNames(value);
  }

  // IE doesn't make error fields non-enumerable
  // http://msdn.microsoft.com/en-us/library/ie/dww52sbt(v=vs.94).aspx
  if (isError(value)
      && (keys.indexOf('message') >= 0 || keys.indexOf('description') >= 0)) {
    return formatError(value);
  }

  // Some type of object without properties can be shortcutted.
  if (keys.length === 0) {
    if (isFunction(value)) {
      var name = value.name ? ': ' + value.name : '';
      return ctx.stylize('[Function' + name + ']', 'special');
    }
    if (isRegExp(value)) {
      return ctx.stylize(RegExp.prototype.toString.call(value), 'regexp');
    }
    if (isDate(value)) {
      return ctx.stylize(Date.prototype.toString.call(value), 'date');
    }
    if (isError(value)) {
      return formatError(value);
    }
  }

  var base = '', array = false, braces = ['{', '}'];

  // Make Array say that they are Array
  if (isArray(value)) {
    array = true;
    braces = ['[', ']'];
  }

  // Make functions say that they are functions
  if (isFunction(value)) {
    var n = value.name ? ': ' + value.name : '';
    base = ' [Function' + n + ']';
  }

  // Make RegExps say that they are RegExps
  if (isRegExp(value)) {
    base = ' ' + RegExp.prototype.toString.call(value);
  }

  // Make dates with properties first say the date
  if (isDate(value)) {
    base = ' ' + Date.prototype.toUTCString.call(value);
  }

  // Make error with message first say the error
  if (isError(value)) {
    base = ' ' + formatError(value);
  }

  if (keys.length === 0 && (!array || value.length == 0)) {
    return braces[0] + base + braces[1];
  }

  if (recurseTimes < 0) {
    if (isRegExp(value)) {
      return ctx.stylize(RegExp.prototype.toString.call(value), 'regexp');
    } else {
      return ctx.stylize('[Object]', 'special');
    }
  }

  ctx.seen.push(value);

  var output;
  if (array) {
    output = formatArray(ctx, value, recurseTimes, visibleKeys, keys);
  } else {
    output = keys.map(function(key) {
      return formatProperty(ctx, value, recurseTimes, visibleKeys, key, array);
    });
  }

  ctx.seen.pop();

  return reduceToSingleString(output, base, braces);
}


function formatPrimitive(ctx, value) {
  if (isUndefined(value))
    return ctx.stylize('undefined', 'undefined');
  if (isString(value)) {
    var simple = '\'' + JSON.stringify(value).replace(/^"|"$/g, '')
                                             .replace(/'/g, "\\'")
                                             .replace(/\\"/g, '"') + '\'';
    return ctx.stylize(simple, 'string');
  }
  if (isNumber(value))
    return ctx.stylize('' + value, 'number');
  if (isBoolean(value))
    return ctx.stylize('' + value, 'boolean');
  // For some reason typeof null is "object", so special case here.
  if (isNull(value))
    return ctx.stylize('null', 'null');
}


function formatError(value) {
  return '[' + Error.prototype.toString.call(value) + ']';
}


function formatArray(ctx, value, recurseTimes, visibleKeys, keys) {
  var output = [];
  for (var i = 0, l = value.length; i < l; ++i) {
    if (hasOwnProperty(value, String(i))) {
      output.push(formatProperty(ctx, value, recurseTimes, visibleKeys,
          String(i), true));
    } else {
      output.push('');
    }
  }
  keys.forEach(function(key) {
    if (!key.match(/^\d+$/)) {
      output.push(formatProperty(ctx, value, recurseTimes, visibleKeys,
          key, true));
    }
  });
  return output;
}


function formatProperty(ctx, value, recurseTimes, visibleKeys, key, array) {
  var name, str, desc;
  desc = Object.getOwnPropertyDescriptor(value, key) || { value: value[key] };
  if (desc.get) {
    if (desc.set) {
      str = ctx.stylize('[Getter/Setter]', 'special');
    } else {
      str = ctx.stylize('[Getter]', 'special');
    }
  } else {
    if (desc.set) {
      str = ctx.stylize('[Setter]', 'special');
    }
  }
  if (!hasOwnProperty(visibleKeys, key)) {
    name = '[' + key + ']';
  }
  if (!str) {
    if (ctx.seen.indexOf(desc.value) < 0) {
      if (isNull(recurseTimes)) {
        str = formatValue(ctx, desc.value, null);
      } else {
        str = formatValue(ctx, desc.value, recurseTimes - 1);
      }
      if (str.indexOf('\n') > -1) {
        if (array) {
          str = str.split('\n').map(function(line) {
            return '  ' + line;
          }).join('\n').substr(2);
        } else {
          str = '\n' + str.split('\n').map(function(line) {
            return '   ' + line;
          }).join('\n');
        }
      }
    } else {
      str = ctx.stylize('[Circular]', 'special');
    }
  }
  if (isUndefined(name)) {
    if (array && key.match(/^\d+$/)) {
      return str;
    }
    name = JSON.stringify('' + key);
    if (name.match(/^"([a-zA-Z_][a-zA-Z_0-9]*)"$/)) {
      name = name.substr(1, name.length - 2);
      name = ctx.stylize(name, 'name');
    } else {
      name = name.replace(/'/g, "\\'")
                 .replace(/\\"/g, '"')
                 .replace(/(^"|"$)/g, "'");
      name = ctx.stylize(name, 'string');
    }
  }

  return name + ': ' + str;
}


function reduceToSingleString(output, base, braces) {
  var numLinesEst = 0;
  var length = output.reduce(function(prev, cur) {
    numLinesEst++;
    if (cur.indexOf('\n') >= 0) numLinesEst++;
    return prev + cur.replace(/\u001b\[\d\d?m/g, '').length + 1;
  }, 0);

  if (length > 60) {
    return braces[0] +
           (base === '' ? '' : base + '\n ') +
           ' ' +
           output.join(',\n  ') +
           ' ' +
           braces[1];
  }

  return braces[0] + base + ' ' + output.join(', ') + ' ' + braces[1];
}


// NOTE: These type checking functions intentionally don't use `instanceof`
// because it is fragile and can be easily faked with `Object.create()`.
function isArray(ar) {
  return Array.isArray(ar);
}
exports.isArray = isArray;

function isBoolean(arg) {
  return typeof arg === 'boolean';
}
exports.isBoolean = isBoolean;

function isNull(arg) {
  return arg === null;
}
exports.isNull = isNull;

function isNullOrUndefined(arg) {
  return arg == null;
}
exports.isNullOrUndefined = isNullOrUndefined;

function isNumber(arg) {
  return typeof arg === 'number';
}
exports.isNumber = isNumber;

function isString(arg) {
  return typeof arg === 'string';
}
exports.isString = isString;

function isSymbol(arg) {
  return typeof arg === 'symbol';
}
exports.isSymbol = isSymbol;

function isUndefined(arg) {
  return arg === void 0;
}
exports.isUndefined = isUndefined;

function isRegExp(re) {
  return isObject(re) && objectToString(re) === '[object RegExp]';
}
exports.isRegExp = isRegExp;

function isObject(arg) {
  return typeof arg === 'object' && arg !== null;
}
exports.isObject = isObject;

function isDate(d) {
  return isObject(d) && objectToString(d) === '[object Date]';
}
exports.isDate = isDate;

function isError(e) {
  return isObject(e) &&
      (objectToString(e) === '[object Error]' || e instanceof Error);
}
exports.isError = isError;

function isFunction(arg) {
  return typeof arg === 'function';
}
exports.isFunction = isFunction;

function isPrimitive(arg) {
  return arg === null ||
         typeof arg === 'boolean' ||
         typeof arg === 'number' ||
         typeof arg === 'string' ||
         typeof arg === 'symbol' ||  // ES6 symbol
         typeof arg === 'undefined';
}
exports.isPrimitive = isPrimitive;

exports.isBuffer = __webpack_require__(159);

function objectToString(o) {
  return Object.prototype.toString.call(o);
}


function pad(n) {
  return n < 10 ? '0' + n.toString(10) : n.toString(10);
}


var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep',
              'Oct', 'Nov', 'Dec'];

// 26 Feb 16:19:34
function timestamp() {
  var d = new Date();
  var time = [pad(d.getHours()),
              pad(d.getMinutes()),
              pad(d.getSeconds())].join(':');
  return [d.getDate(), months[d.getMonth()], time].join(' ');
}


// log is just a thin wrapper to console.log that prepends a timestamp
exports.log = function() {
  console.log('%s - %s', timestamp(), exports.format.apply(exports, arguments));
};


/**
 * Inherit the prototype methods from one constructor into another.
 *
 * The Function.prototype.inherits from lang.js rewritten as a standalone
 * function (not on Function.prototype). NOTE: If this file is to be loaded
 * during bootstrapping this function needs to be rewritten using some native
 * functions as prototype setup using normal JavaScript does not work as
 * expected during bootstrapping (see mirror.js in r114903).
 *
 * @param {function} ctor Constructor function which needs to inherit the
 *     prototype.
 * @param {function} superCtor Constructor function to inherit prototype from.
 */
exports.inherits = __webpack_require__(160);

exports._extend = function(origin, add) {
  // Don't do anything if add isn't an object
  if (!add || !isObject(add)) return origin;

  var keys = Object.keys(add);
  var i = keys.length;
  while (i--) {
    origin[keys[i]] = add[keys[i]];
  }
  return origin;
};

function hasOwnProperty(obj, prop) {
  return Object.prototype.hasOwnProperty.call(obj, prop);
}

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(157), __webpack_require__(158)))

/***/ }),

/***/ 157:
/***/ (function(module, exports) {

var g;

// This works in non-strict mode
g = (function() {
	return this;
})();

try {
	// This works if eval is allowed (see CSP)
	g = g || Function("return this")() || (1,eval)("this");
} catch(e) {
	// This works if the window reference is available
	if(typeof window === "object")
		g = window;
}

// g can still be undefined, but nothing to do about it...
// We return undefined, instead of nothing here, so it's
// easier to handle this case. if(!global) { ...}

module.exports = g;


/***/ }),

/***/ 158:
/***/ (function(module, exports) {

// shim for using process in browser
var process = module.exports = {};

// cached from whatever global is present so that test runners that stub it
// don't break things.  But we need to wrap it in a try catch in case it is
// wrapped in strict mode code which doesn't define any globals.  It's inside a
// function because try/catches deoptimize in certain engines.

var cachedSetTimeout;
var cachedClearTimeout;

function defaultSetTimout() {
    throw new Error('setTimeout has not been defined');
}
function defaultClearTimeout () {
    throw new Error('clearTimeout has not been defined');
}
(function () {
    try {
        if (typeof setTimeout === 'function') {
            cachedSetTimeout = setTimeout;
        } else {
            cachedSetTimeout = defaultSetTimout;
        }
    } catch (e) {
        cachedSetTimeout = defaultSetTimout;
    }
    try {
        if (typeof clearTimeout === 'function') {
            cachedClearTimeout = clearTimeout;
        } else {
            cachedClearTimeout = defaultClearTimeout;
        }
    } catch (e) {
        cachedClearTimeout = defaultClearTimeout;
    }
} ())
function runTimeout(fun) {
    if (cachedSetTimeout === setTimeout) {
        //normal enviroments in sane situations
        return setTimeout(fun, 0);
    }
    // if setTimeout wasn't available but was latter defined
    if ((cachedSetTimeout === defaultSetTimout || !cachedSetTimeout) && setTimeout) {
        cachedSetTimeout = setTimeout;
        return setTimeout(fun, 0);
    }
    try {
        // when when somebody has screwed with setTimeout but no I.E. maddness
        return cachedSetTimeout(fun, 0);
    } catch(e){
        try {
            // When we are in I.E. but the script has been evaled so I.E. doesn't trust the global object when called normally
            return cachedSetTimeout.call(null, fun, 0);
        } catch(e){
            // same as above but when it's a version of I.E. that must have the global object for 'this', hopfully our context correct otherwise it will throw a global error
            return cachedSetTimeout.call(this, fun, 0);
        }
    }


}
function runClearTimeout(marker) {
    if (cachedClearTimeout === clearTimeout) {
        //normal enviroments in sane situations
        return clearTimeout(marker);
    }
    // if clearTimeout wasn't available but was latter defined
    if ((cachedClearTimeout === defaultClearTimeout || !cachedClearTimeout) && clearTimeout) {
        cachedClearTimeout = clearTimeout;
        return clearTimeout(marker);
    }
    try {
        // when when somebody has screwed with setTimeout but no I.E. maddness
        return cachedClearTimeout(marker);
    } catch (e){
        try {
            // When we are in I.E. but the script has been evaled so I.E. doesn't  trust the global object when called normally
            return cachedClearTimeout.call(null, marker);
        } catch (e){
            // same as above but when it's a version of I.E. that must have the global object for 'this', hopfully our context correct otherwise it will throw a global error.
            // Some versions of I.E. have different rules for clearTimeout vs setTimeout
            return cachedClearTimeout.call(this, marker);
        }
    }



}
var queue = [];
var draining = false;
var currentQueue;
var queueIndex = -1;

function cleanUpNextTick() {
    if (!draining || !currentQueue) {
        return;
    }
    draining = false;
    if (currentQueue.length) {
        queue = currentQueue.concat(queue);
    } else {
        queueIndex = -1;
    }
    if (queue.length) {
        drainQueue();
    }
}

function drainQueue() {
    if (draining) {
        return;
    }
    var timeout = runTimeout(cleanUpNextTick);
    draining = true;

    var len = queue.length;
    while(len) {
        currentQueue = queue;
        queue = [];
        while (++queueIndex < len) {
            if (currentQueue) {
                currentQueue[queueIndex].run();
            }
        }
        queueIndex = -1;
        len = queue.length;
    }
    currentQueue = null;
    draining = false;
    runClearTimeout(timeout);
}

process.nextTick = function (fun) {
    var args = new Array(arguments.length - 1);
    if (arguments.length > 1) {
        for (var i = 1; i < arguments.length; i++) {
            args[i - 1] = arguments[i];
        }
    }
    queue.push(new Item(fun, args));
    if (queue.length === 1 && !draining) {
        runTimeout(drainQueue);
    }
};

// v8 likes predictible objects
function Item(fun, array) {
    this.fun = fun;
    this.array = array;
}
Item.prototype.run = function () {
    this.fun.apply(null, this.array);
};
process.title = 'browser';
process.browser = true;
process.env = {};
process.argv = [];
process.version = ''; // empty string to avoid regexp issues
process.versions = {};

function noop() {}

process.on = noop;
process.addListener = noop;
process.once = noop;
process.off = noop;
process.removeListener = noop;
process.removeAllListeners = noop;
process.emit = noop;
process.prependListener = noop;
process.prependOnceListener = noop;

process.listeners = function (name) { return [] }

process.binding = function (name) {
    throw new Error('process.binding is not supported');
};

process.cwd = function () { return '/' };
process.chdir = function (dir) {
    throw new Error('process.chdir is not supported');
};
process.umask = function() { return 0; };


/***/ }),

/***/ 159:
/***/ (function(module, exports) {

module.exports = function isBuffer(arg) {
  return arg && typeof arg === 'object'
    && typeof arg.copy === 'function'
    && typeof arg.fill === 'function'
    && typeof arg.readUInt8 === 'function';
}

/***/ }),

/***/ 160:
/***/ (function(module, exports) {

if (typeof Object.create === 'function') {
  // implementation from standard node.js 'util' module
  module.exports = function inherits(ctor, superCtor) {
    ctor.super_ = superCtor
    ctor.prototype = Object.create(superCtor.prototype, {
      constructor: {
        value: ctor,
        enumerable: false,
        writable: true,
        configurable: true
      }
    });
  };
} else {
  // old school shim for old browsers
  module.exports = function inherits(ctor, superCtor) {
    ctor.super_ = superCtor
    var TempCtor = function () {}
    TempCtor.prototype = superCtor.prototype
    ctor.prototype = new TempCtor()
    ctor.prototype.constructor = ctor
  }
}


/***/ }),

/***/ 162:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _assign = __webpack_require__(135);

var _assign2 = _interopRequireDefault(_assign);

var _keys = __webpack_require__(18);

var _keys2 = _interopRequireDefault(_keys);

var _axios = __webpack_require__(33);

var _axios2 = _interopRequireDefault(_axios);

var _runServerMethod = __webpack_require__(27);

var _session = __webpack_require__(26);

var _session2 = _interopRequireDefault(_session);

var _utils = __webpack_require__(132);

var _utils2 = _interopRequireDefault(_utils);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var className = 'Nur.CommonInterface.Temperature';
var findEventType = 'findEventType';
var findEvent = 'findEvent';
var findItem = 'findItem';
var findTime = 'findTime';
var getAllTempConfig = 'getAllTempConfig';
var getDayTimes = 'getDayTimes';
var _getTempDataByDay = 'getTempDataByDay';
var _getTempDataByTime = 'getTempDataByTime';
var _getPatientsTempDataByTime = 'getPatientsTempDataByTime';
var getTempDataByDateArea = 'getTempDataByDateArea';
var _getSplitCharDecimal = 'getSplitCharDecimal';
var _saveObsDataByDay = 'saveObsDataByDay';
var _saveObsDataByTime = 'saveObsDataByTime';
var _saveObsData = 'saveObsData';
var _insertEvent = 'insertEvent';
var _deleteEvent = 'deleteEvent';
var _updateEvent = 'updateEvent';
var _ifTimeCanInput = 'ifTimeCanInput';

exports.default = {
  className: className,
  findEventType: findEventType,
  findEvent: findEvent,
  findItem: findItem,
  findTime: findTime,
  getTempConfig: function getTempConfig(locID, babyFlag) {
    var promises = [];
    var times = void 0;
    var tempConfig = void 0;
    var splitChar = void 0;
    var getTimesPromis = (0, _runServerMethod.runServerMethod)(className, getDayTimes).then(function (result) {
      times = result;
    });
    var getMeasureItemsPromis = (0, _runServerMethod.runServerMethod)(className, getAllTempConfig, locID, babyFlag).then(function (result) {
      tempConfig = result;
    });
    var getSplitCharDecimalPromis = (0, _runServerMethod.runServerMethod)(className, _getSplitCharDecimal).then(function (result) {
      (0, _keys2.default)(result).forEach(function (key) {
        result[key] = String.fromCharCode(result[key]);
      });
      splitChar = result;
    });
    promises.push(getTimesPromis);
    promises.push(getMeasureItemsPromis);
    promises.push(getSplitCharDecimalPromis);
    return _axios2.default.all(promises).then(function () {
      var singleConfig = {
        times: times,
        measureItems: tempConfig.SingleConfig,
        splitChar: splitChar
      };
      var mutiplyConfig = {
        times: times,
        measureItems: tempConfig.MutiplyConfig,
        singleConfig: singleConfig,
        splitChar: splitChar
      };
      return {
        singleConfig: singleConfig,
        mutiplyConfig: mutiplyConfig
      };
    });
  },
  getTempDataByDay: function getTempDataByDay(episodeID, date) {
    return (0, _runServerMethod.runServerMethod)(className, _getTempDataByDay, episodeID, date);
  },
  saveObsDataByDay: function saveObsDataByDay(episodeID, valueString, date) {
    return (0, _runServerMethod.runServerMethod)(className, _saveObsDataByDay, episodeID, valueString, _session2.default.USER.USERID, date, _session2.default.USER.CTLOCID);
  },
  getTempDataByTime: function getTempDataByTime(episodeID, date, time) {
    return (0, _runServerMethod.runServerMethod)(className, _getTempDataByTime, episodeID, date, time);
  },
  getPatientTempDataByDateArea: function getPatientTempDataByDateArea(episodeID, startDate, endDate) {
    return (0, _runServerMethod.runServerMethod)(className, getTempDataByDateArea, episodeID, startDate, endDate);
  },
  getPatientsTempDataByTime: function getPatientsTempDataByTime(episodeIDArray, date, time) {
    var dayData = {};
    var promises = [];
    var promiseFactory = function promiseFactory(chunk) {
      return (0, _runServerMethod.runServerMethod)(className, _getPatientsTempDataByTime, chunk.join('^'), date, time).then(function (data) {
        if (typeof data !== 'string') {
          (0, _assign2.default)(dayData, data);
        }
      });
    };
    var chunks = _utils2.default.splitChunk([], 50, episodeIDArray);
    chunks.forEach(function (chunk) {
      promises.push(promiseFactory(chunk));
    });
    return _axios2.default.all(promises).then(function () {
      return dayData;
    });
  },
  saveObsDataByTime: function saveObsDataByTime(valueString, date, time) {
    return (0, _runServerMethod.runServerMethod)(className, _saveObsDataByTime, valueString, _session2.default.USER.USERID, date, time, _session2.default.USER.CTLOCID);
  },
  saveObsData: function saveObsData(episodeID, valueString) {
    return (0, _runServerMethod.runServerMethod)(className, _saveObsData, episodeID, valueString, _session2.default.USER.USERID, _session2.default.USER.CTLOCID);
  },
  insertEvent: function insertEvent(episodeID, date, time, typeID) {
    return (0, _runServerMethod.runServerMethod)(className, _insertEvent, episodeID, date, time, typeID, _session2.default.USER.USERID);
  },
  updateEvent: function updateEvent(ID, date, time, typeID) {
    return (0, _runServerMethod.runServerMethod)(className, _updateEvent, ID, date, time, typeID, _session2.default.USER.USERID);
  },
  deleteEvent: function deleteEvent(ID) {
    return (0, _runServerMethod.runServerMethod)(className, _deleteEvent, ID, _session2.default.USER.USERID);
  },
  getSplitCharDecimal: function getSplitCharDecimal() {
    return (0, _runServerMethod.runServerMethod)(className, _getSplitCharDecimal);
  },
  ifTimeCanInput: function ifTimeCanInput(EpisodeIDs, SearchDate, SearchTime, WardID) {
    return (0, _runServerMethod.runServerMethod)(className, _ifTimeCanInput, EpisodeIDs, SearchDate, SearchTime, WardID);
  }
};

/***/ })

});
//# sourceMappingURL=13.cda3a56d73fc590956d4.js.map