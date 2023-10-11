webpackJsonp([17],{

/***/ 120:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _keys = __webpack_require__(18);

var _keys2 = _interopRequireDefault(_keys);

var _loc = __webpack_require__(277);

var _loc2 = _interopRequireDefault(_loc);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var state = {
  currentWard: null,
  locLinkWards: null

};

var getters = {};
(0, _keys2.default)(state).forEach(function (key) {
  getters[key] = getters[key] || function (state) {
    return state[key];
  };
});
var mutations = {
  updateCurrentWard: function updateCurrentWard(state, _ref) {
    var ward = _ref.ward;

    state.currentWard = ward;
  }
};

var actions = {
  getLocLinkWards: function getLocLinkWards(_ref2) {
    var commit = _ref2.commit;

    return _loc2.default.getLocLinkWards().then(function (wards) {
      if (wards[0]) {
        commit('updateCurrentWard', {
          ward: wards[0]
        });
      }
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

/***/ 277:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _runServerMethod = __webpack_require__(27);

var _session = __webpack_require__(26);

var _session2 = _interopRequireDefault(_session);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var className = 'Nur.CommonInterface.Loc';
var _getLocLinkWards = 'getLocLinkWards';
var getLocs = 'getLocs';
var getTransLocLinkWardsByAdm = "getTransLocLinkWardsByAdm";
exports.default = {
  className: className,
  getLocs: getLocs,
  getLocLinkWards: function getLocLinkWards() {
    var locID = _session2.default.USER.CTLOCID;
    var currWardID = _session2.default.USER.WARDID;
    return (0, _runServerMethod.runServerMethod)(className, _getLocLinkWards, locID, currWardID);
  },
  getLocLinkWardsExcept: function getLocLinkWardsExcept(episodeID) {
    var currWardID = _session2.default.USER.WARDID;
    return (0, _runServerMethod.runServerMethod)(className, getTransLocLinkWardsByAdm, episodeID, currWardID, "Y");
  }
};

/***/ })

});
//# sourceMappingURL=17.954385e51e3dee2ad884.js.map