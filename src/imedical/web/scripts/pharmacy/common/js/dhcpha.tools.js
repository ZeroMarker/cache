/**
 * creator:		yunhaibao
 * createdate:	2018-05-23
 * description:	药房JS常用工具,仅为计算用工具,尽量原生
 */
var DHCPHA_TOOLS = ({
    // 补零
    PadZero: function(_no, _len) {
        var _noLen = _no.length;
        if (_noLen > _len) {
            return _no;
        }
        var _needLen = _len - _noLen;
        for (var i = 1; i <= _needLen; i++) {
            _no = "0" + _no;
        }
        return _no
    },
    // 获取日期
    Today: function() {
        var dateObj = new Date();
        var retDate = "";
        retDate += dateObj.getFullYear() + "-";
        retDate += (dateObj.getMonth() + 1) + "-";
        retDate += dateObj.getDate();
        return retDate;
    }
});