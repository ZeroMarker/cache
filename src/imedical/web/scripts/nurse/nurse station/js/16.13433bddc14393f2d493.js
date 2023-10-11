webpackJsonp([16],{

/***/ 117:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _assign = __webpack_require__(135);

var _assign2 = _interopRequireDefault(_assign);

var _keys = __webpack_require__(18);

var _keys2 = _interopRequireDefault(_keys);

var _vue = __webpack_require__(29);

var _vue2 = _interopRequireDefault(_vue);

var _axios = __webpack_require__(33);

var _axios2 = _interopRequireDefault(_axios);

var _orderSheet = __webpack_require__(331);

var _orderSheet2 = _interopRequireDefault(_orderSheet);

var _nurseExcute = __webpack_require__(332);

var _nurseExcute2 = _interopRequireDefault(_nurseExcute);

var _session = __webpack_require__(26);

var _session2 = _interopRequireDefault(_session);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var state = {
  orderList: {
    columns: [],
    data: {}
  },
  buttons: [],
  sheetsCode: [],
  defaulSheetIndex: 0,
  defaultSheetCode: '',
  disposeStateInfo: {},
  selectedPatients: [],
  searchInfo: {
    startDate: new Date(),
    startTime: '00:00',
    endDate: new Date(),
    endTime: '00:00',
    doctorOrderFlag: true,
    excutedOrderFlag: false,
    printedOrderFlag: false,
    createOrderFlag: false,
    sheetCode: '',
    hospitalID: '',
    orderType: 'A',
    longOrderFlag: false,
    tempOrderFlag: false
  },
  requestQueryFlag: false,
  wardID: _session2.default.USER.WARDID
};
_orderSheet2.default.getDisposeStateInfo().then(function (info) {
  state.disposeStateInfo = info;
});
var getters = {};
(0, _keys2.default)(state).forEach(function (key) {
  getters[key] = getters[key] || function (state) {
    return state[key];
  };
});

var mutations = {
  requestQuery: function requestQuery(state) {
    state.requestQueryFlag = true;
  },
  finishQuery: function finishQuery(state) {
    state.requestQueryFlag = false;
  },
  updateSheetCloumns: function updateSheetCloumns(state, _ref) {
    var columns = _ref.columns;

    state.orderList = (0, _assign2.default)({}, state.orderList, {
      columns: columns,
      data: {}
    });
  },
  updateSheetButtons: function updateSheetButtons(state, _ref2) {
    var buttons = _ref2.buttons;

    state.buttons = buttons;
  },
  updateSheetData: function updateSheetData(state, _ref3) {
    var result = _ref3.result;

    var data = result;
    if (typeof result === 'string') {
      data = {
        orders: []
      };
    }
    state.sheetsCode.forEach(function (sheetCode) {
      sheetCode.badge = !!data[sheetCode.ID];
    });

    data.orders.forEach(function (order) {
      _vue2.default.set(order, 'check', false);
      _vue2.default.set(order, 'focus', false);
      _vue2.default.set(order, 'indeterminate', false);
      _vue2.default.set(order, 'show', true);
      if (order.execInfos) {
        var sttDates = [];
        var sttTimes = [];
        var exist = {};
        order.execInfos.forEach(function (execInfo) {
          _vue2.default.set(execInfo, 'check', false);
          if (!exist[execInfo.sttDate]) {
            sttDates.push(execInfo.sttDate);
            exist[execInfo.sttDate] = true;
          }
          if (!exist[execInfo.sttTime]) {
            sttTimes.push(execInfo.sttTime);
            exist[execInfo.sttTime] = true;
          }
        });
        sttTimes.sort(function (a, b) {
          return parseInt(a.split(':')[0], 10) - parseInt(b.split(':')[0], 10);
        });
        _vue2.default.set(order, 'sttDates', sttDates);
        _vue2.default.set(order, 'sttTimes', sttTimes);
      }
    });
    _vue2.default.set(data, 'indeterminate', false);
    _vue2.default.set(data, 'check', false);
    state.orderList = (0, _assign2.default)({}, state.orderList, {
      data: data
    });
  },
  updateSelectedPatients: function updateSelectedPatients(state, _ref4) {
    var selectedPatients = _ref4.selectedPatients;

    state.selectedPatients = selectedPatients;
  },
  updateSearchInfo: function updateSearchInfo(state, _ref5) {
    var key = _ref5.key,
        value = _ref5.value;

    state.searchInfo[key] = value;
  },
  updateSheetCode: function updateSheetCode(state, _ref6) {
    var sheetCode = _ref6.sheetCode,
        hospitalID = _ref6.hospitalID;

    state.searchInfo.sheetCode = sheetCode;
    state.searchInfo.hospitalID = hospitalID;
  },
  updateSheetsCode: function updateSheetsCode(state, _ref7) {
    var sheetsCode = _ref7.sheetsCode,
        defaulSheetIndex = _ref7.defaulSheetIndex;

    state.sheetsCode = sheetsCode;
    state.defaulSheetIndex = defaulSheetIndex;
  },
  updateOrderListCheckStatus: function updateOrderListCheckStatus(state, _ref8) {
    var indeterminate = _ref8.indeterminate,
        check = _ref8.check;

    if (indeterminate !== undefined) {
      state.orderList.data.indeterminate = indeterminate;
    }
    if (check !== undefined) {
      state.orderList.data.check = check;
    }
  },
  updateExecsCheckStatusByDisposeStatCode: function updateExecsCheckStatusByDisposeStatCode(state, _ref9) {
    var disposeStatCode = _ref9.disposeStatCode,
        index = _ref9.index,
        check = _ref9.check;

    var execs = state.orderList.data.orders[index].execInfos;
    if (execs) {
      execs.forEach(function (execInfo) {
        execInfo.check = disposeStatCode === execInfo.disposeStatCode ? check !== undefined ? check : !execInfo.check : execInfo.check;
      });
    }
  },
  updateExecsCheckStatusBySttDate: function updateExecsCheckStatusBySttDate(state, _ref10) {
    var sttDate = _ref10.sttDate,
        index = _ref10.index;

    var execs = state.orderList.data.orders[index].execInfos;
    if (execs) {
      execs.forEach(function (execInfo) {
        execInfo.check = sttDate === execInfo.sttDate ? !execInfo.check : execInfo.check;
      });
    }
  },
  updateExecsCheckStatusBySttTime: function updateExecsCheckStatusBySttTime(state, _ref11) {
    var sttTime = _ref11.sttTime,
        index = _ref11.index;

    var execs = state.orderList.data.orders[index].execInfos;
    if (execs) {
      execs.forEach(function (execInfo) {
        execInfo.check = sttTime === execInfo.sttTime ? !execInfo.check : execInfo.check;
      });
    }
  },
  updateExecsCheckStatus: function updateExecsCheckStatus(state, _ref12) {
    var index = _ref12.index,
        check = _ref12.check;

    var execs = state.orderList.data.orders[index].execInfos;
    if (execs) {
      execs.forEach(function (execInfo) {
        if (check !== undefined) {
          execInfo.check = check;
        }
      });
    }
  },
  updateExecCheckStatus: function updateExecCheckStatus(state, _ref13) {
    var index = _ref13.index,
        execIndex = _ref13.execIndex;

    var check = state.orderList.data.orders[index].execInfos[execIndex].check;
    state.orderList.data.orders[index].execInfos[execIndex].check = !check;
  },
  updateOrderCheckStatus: function updateOrderCheckStatus(state, _ref14) {
    var indeterminate = _ref14.indeterminate,
        check = _ref14.check,
        index = _ref14.index;

    if (indeterminate !== undefined) {
      state.orderList.data.orders[index].indeterminate = indeterminate;
    }
    if (check !== undefined) {
      state.orderList.data.orders[index].check = check;
    }
  },
  updateOrdersCheckStatus: function updateOrdersCheckStatus(state, _ref15) {
    var indeterminate = _ref15.indeterminate,
        check = _ref15.check;

    state.orderList.data.orders.forEach(function (order) {
      if (check !== undefined) {
        order.check = check;
      }
      if (indeterminate !== undefined) {
        order.indeterminate = indeterminate;
      }
      if (order.execInfos) {
        order.execInfos.forEach(function (execInfo) {
          if (check !== undefined) {
            execInfo.check = check;
          }
        });
      }
    });
  }
};
var initSearchDateTimeFunc = function initSearchDateTimeFunc(_ref16, _ref17) {
  var commit = _ref16.commit;
  var sheetCode = _ref17.sheetCode,
      hospitalID = _ref17.hospitalID;

  commit({
    type: 'updateSheetCode',
    sheetCode: sheetCode,
    hospitalID: hospitalID
  });
  return _orderSheet2.default.getSheetDateTime(sheetCode, hospitalID).then(function (dateTimeObject) {
    commit({
      type: 'updateSearchInfo',
      key: 'startDate',
      value: dateTimeObject.startDate
    });
    commit({
      type: 'updateSearchInfo',
      key: 'startTime',
      value: dateTimeObject.startTime
    });
    commit({
      type: 'updateSearchInfo',
      key: 'endDate',
      value: dateTimeObject.endDate
    });
    commit({
      type: 'updateSearchInfo',
      key: 'endTime',
      value: dateTimeObject.endTime
    });
  });
};
var initColumnsAndButtonsFunc = function initColumnsAndButtonsFunc(_ref18, _ref19) {
  var commit = _ref18.commit;
  var sheetCode = _ref19.sheetCode,
      hospitalID = _ref19.hospitalID,
      excutedOrderFlag = _ref19.excutedOrderFlag,
      printedOrderFlag = _ref19.printedOrderFlag;

  commit({
    type: 'updateSheetCode',
    sheetCode: sheetCode,
    hospitalID: hospitalID
  });
  var promises = [];
  promises.push(_orderSheet2.default.getSheetColumns(sheetCode, hospitalID).then(function (columns) {
    commit({
      type: 'updateSheetCloumns',
      columns: columns
    });
  }));
  promises.push(_orderSheet2.default.getSheetButtons(sheetCode, hospitalID, excutedOrderFlag, printedOrderFlag).then(function (buttons) {
    commit({
      type: 'updateSheetButtons',
      buttons: buttons
    });
  }));

  return _axios2.default.all(promises);
};
var actions = {
  initOrderExcuteState: function initOrderExcuteState(_ref20) {
    var commit = _ref20.commit,
        state = _ref20.state;

    var defaulSheetIndex = 0;
    var defaultSheetCode = '';
    var defaultHospitalID = '';
    var specifySheetCode = _session2.default.USER.SPECIFYSHEETCODE;
    _orderSheet2.default.getSheetsOfSSGroup().then(function (sheets) {
      var sheetsCode = sheets.map(function (sheet, index) {
        var code = sheet.code,
            desc = sheet.desc,
            hospitalID = sheet.hospitalID;

        if ((index === 0 || sheet.default) && !specifySheetCode || specifySheetCode && code === specifySheetCode) {
          defaulSheetIndex = index;
          defaultSheetCode = code;
          defaultHospitalID = hospitalID;
        }
        return {
          name: desc,
          ID: code,
          index: index,
          badge: false,
          hospitalID: hospitalID
        };
      });
      commit({
        type: 'updateSheetsCode',
        sheetsCode: sheetsCode,
        defaulSheetIndex: defaulSheetIndex
      });
    }).then(function () {
      var promises = [];
      promises.push(initColumnsAndButtonsFunc({ commit: commit }, {
        sheetCode: defaultSheetCode,
        hospitalID: defaultHospitalID,
        excutedOrderFlag: state.searchInfo.excutedOrderFlag,
        printedOrderFlag: state.searchInfo.printedOrderFlag
      }));
      promises.push(initSearchDateTimeFunc({ commit: commit }, {
        sheetCode: defaultSheetCode,
        hospitalID: defaultHospitalID
      }));
      _axios2.default.all(promises);
    });
  },
  initSearchDateTime: function initSearchDateTime(_ref21, _ref22) {
    var commit = _ref21.commit;
    var sheetCode = _ref22.sheetCode,
        hospitalID = _ref22.hospitalID;

    initSearchDateTimeFunc({ commit: commit }, { sheetCode: sheetCode, hospitalID: hospitalID }).then(function () {
      commit({
        type: 'requestQuery'
      });
    });
  },
  initColumnsAndButtons: function initColumnsAndButtons(_ref23, _ref24) {
    var commit = _ref23.commit,
        state = _ref23.state;
    var sheetCode = _ref24.sheetCode,
        hospitalID = _ref24.hospitalID;

    commit({
      type: 'requestQuery'
    });
    var excutedOrderFlag = state.searchInfo.excutedOrderFlag;
    var printedOrderFlag = state.searchInfo.printedOrderFlag;
    initColumnsAndButtonsFunc({ commit: commit }, { sheetCode: sheetCode, hospitalID: hospitalID, excutedOrderFlag: excutedOrderFlag, printedOrderFlag: printedOrderFlag });
  },
  getOrders: function getOrders(_ref25) {
    var commit = _ref25.commit,
        state = _ref25.state;
    var _state$searchInfo = state.searchInfo,
        sheetCode = _state$searchInfo.sheetCode,
        hospitalID = _state$searchInfo.hospitalID,
        startDate = _state$searchInfo.startDate,
        startTime = _state$searchInfo.startTime,
        endDate = _state$searchInfo.endDate,
        endTime = _state$searchInfo.endTime,
        doctorOrderFlag = _state$searchInfo.doctorOrderFlag,
        createOrderFlag = _state$searchInfo.createOrderFlag,
        excutedOrderFlag = _state$searchInfo.excutedOrderFlag,
        orderType = _state$searchInfo.orderType,
        printedOrderFlag = _state$searchInfo.printedOrderFlag,
        longOrderFlag = _state$searchInfo.longOrderFlag,
        tempOrderFlag = _state$searchInfo.tempOrderFlag;

    var groupID = _session2.default.USER.GROUPID;
    var locID = _session2.default.USER.CTLOCID;
    var wardID = _session2.default.USER.WARDID;
    _nurseExcute2.default.getOrders(state.selectedPatients.join('^'), sheetCode, hospitalID, groupID, startDate, startTime, endDate, endTime, wardID, locID, doctorOrderFlag, createOrderFlag, excutedOrderFlag, orderType, printedOrderFlag, longOrderFlag, tempOrderFlag).then(function (data) {
      commit({
        type: 'updateSheetData',
        result: data
      });
      commit({
        type: 'finishQuery'
      });
    }).then(function () {
      _orderSheet2.default.getSheetButtons(sheetCode, hospitalID, excutedOrderFlag, printedOrderFlag).then(function (buttons) {
        commit({
          type: 'updateSheetButtons',
          buttons: buttons
        });
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

/***/ 135:
/***/ (function(module, exports, __webpack_require__) {

module.exports = { "default": __webpack_require__(139), __esModule: true };

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

/***/ 331:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _session = __webpack_require__(26);

var _session2 = _interopRequireDefault(_session);

var _runServerMethod = __webpack_require__(27);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var className = 'Nur.CommonInterface.OrderSheet';
var _getSheetsOfSSGroup = 'getSheetsOfSSGroup';
var _getSheetColumns = 'getSheetColumns';
var _getSheetButtons = 'getSheetButtons';
var _getDisposeStateInfo = 'getDisposeStateInfo';
var _getSheetDateTime = 'getSheetDateTime';
var _getSheetDispStateInfo = 'getSheetDispStateInfo';
exports.default = {
  getSheetColumns: function getSheetColumns(sheetCode, hospitalID) {
    return (0, _runServerMethod.runServerMethod)(className, _getSheetColumns, sheetCode, hospitalID);
  },
  getSheetButtons: function getSheetButtons(sheetCode, hospitalID, excuteOrderFlag, printedOrderFlag) {
    return (0, _runServerMethod.runServerMethod)(className, _getSheetButtons, sheetCode, hospitalID, excuteOrderFlag, printedOrderFlag);
  },
  getSheetDateTime: function getSheetDateTime(sheetCode, hospitalID) {
    return (0, _runServerMethod.runServerMethod)(className, _getSheetDateTime, sheetCode, hospitalID);
  },
  getSheetsOfSSGroup: function getSheetsOfSSGroup() {
    return (0, _runServerMethod.runServerMethod)(className, _getSheetsOfSSGroup, _session2.default.USER.GROUPID, _session2.default.USER.CTLOCID);
  },
  getDisposeStateInfo: function getDisposeStateInfo() {
    return (0, _runServerMethod.runServerMethod)(className, _getDisposeStateInfo);
  },
  getSheetDispStateInfo: function getSheetDispStateInfo(sheetCode, hospitalID) {
    return (0, _runServerMethod.runServerMethod)(className, _getSheetDispStateInfo, sheetCode, hospitalID);
  }
};

/***/ }),

/***/ 332:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _runServerMethod = __webpack_require__(27);

var className = 'Nur.IP.NurseExcute';
var _getOrders = 'getOrders';
exports.default = {
  getOrders: function getOrders() {
    for (var _len = arguments.length, args = Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    return _runServerMethod.runServerMethod.apply(undefined, [className, _getOrders].concat(args));
  }
};

/***/ })

});
//# sourceMappingURL=16.13433bddc14393f2d493.js.map