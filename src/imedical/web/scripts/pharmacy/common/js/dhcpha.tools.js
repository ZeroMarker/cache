/**
 * creator:		yunhaibao
 * createdate:	2018-05-23
 * description:	ҩ��JS���ù���,��Ϊ�����ù���,����ԭ��
 */
var DHCPHA_TOOLS = ({
    // ����
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
    // ��ȡ����
    Today: function() {
        var dateObj = new Date();
        var retDate = "";
        retDate += dateObj.getFullYear() + "-";
        retDate += (dateObj.getMonth() + 1) + "-";
        retDate += dateObj.getDate();
        return retDate;
    }
});