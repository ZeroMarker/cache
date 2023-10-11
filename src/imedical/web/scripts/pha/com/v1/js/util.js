/**
 * ����:	 ҩ������
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-15
 * scripts/pha/com/v1/js/util.js
 */
var PHA_UTIL = {
    /**
     * ��ȡϵͳ����
     * @param {String} dateVal - dateValȡֵ������: t,t+n,t-n,s,l (t-��ǰ����; n-����; s-���µ�һ��; l-�������һ��)
     */
    SysDate: function (dateVal) {
        dateVal = dateVal || 't';
        try {
            return tkMakeServerCall('PHA.COM.Util', 'GetDateValue', dateVal);
        } catch (e) {
            return e;
        }
    },
    /**
     * ��ȡϵͳʱ��
     * @param {String} timeValȡֵ������:t,t+n,t-n,s,l (t-��ǰʱ��; n-����; s-���쿪ʼʱ��; l-�����ֹʱ��)
     * @param {String} showDate�Ƿ���ʾ���� (Y/N)
     */
    SysTime: function (timeVal, showDate) {
        timeVal = timeVal || 't';
        showDate = showDate || 'N';
        try {
            return tkMakeServerCall('PHA.COM.Util', 'GetTimeValue', timeVal, showDate);
        } catch (e) {
            return e;
        }
    },
    /**
     * ��ȡ�ͻ�������
     */
    GetDate: function (dateVal) {
        var dateVal = (dateVal || '').trim().toUpperCase();
        if (dateVal.substr(0,1) === 'T' && dateVal.indexOf('+') < 0 && dateVal.indexOf('-') < 0){
            dateVal = 'T' + '+' + dateVal.split('T')[1]
        }
        var _fn = {
            getDate: function (d) {
                return d.getFullYear();
            },
            getMon: function (d) {
                return (d.getMonth() + 1).toString().length < 2 ? '0' + (d.getMonth() + 1) : d.getMonth() + 1;
            },
            getDay: function (d) {
                return d.getDate().toString().length < 2 ? '0' + d.getDate() : d.getDate();
            }
        };
        var _format = function (_year, _month, _day) {
            if (typeof dtformat !== 'undefined') {
                if (dtseparator === '/') {
                    return [_day, _month, _year].join('/');
                }
            }
            return [_year, _month, _day].join('-');
        };
        var myDate = new Date();
        var year = _fn.getDate(myDate);
        var month = _fn.getMon(myDate);
        var day = _fn.getDay(myDate);
        if (dateVal == 'S') {
            return _format(year, month, '01');
        }
        if (dateVal == 'L') {
            return _format(year, month, this.GetLastDay(year, month));
        }
        if (dateVal.indexOf('+') >= 0) {
            var newDate = new Date(myDate.getTime() + 24 * 60 * 60 * 1000 * dateVal.split('+')[1]);
            return _format(_fn.getDate(newDate), _fn.getMon(newDate), _fn.getDay(newDate));
        }
        if (dateVal.indexOf('-') >= 0) {
            var newDate = new Date(myDate.getTime() - 24 * 60 * 60 * 1000 * dateVal.split('-')[1]);
            return _format(_fn.getDate(newDate), _fn.getMon(newDate), _fn.getDay(newDate));
        }
        return _format(year, month, day);
    },
    /**
     * ��ȡ�ͻ���ʱ��
     */
    GetTime: function (timeVal, showDate) {
        var _fn = {
            getTime: function (seconds) {
                var hours = Math.floor(seconds / 3600);
                hours = hours.toString().length == 1 ? '0' + hours : hours;
                var minutes = Math.floor((seconds % 3600) / 60);
                minutes = minutes.toString().length == 1 ? '0' + minutes : minutes;
                var rSeconds = (seconds % 3600) % 60;
                rSeconds = rSeconds.toString().length == 1 ? '0' + rSeconds : rSeconds;
                return hours + ':' + minutes + ':' + rSeconds;
            },
            addZero: function (v) {
                return v.toString().length < 2 ? '0' + v : v;
            }
        };
        var timeVal = (timeVal || '').trim().toUpperCase();
        var myDate = new Date();
        var hours = myDate.getHours(); // (0-23)
        var minutes = myDate.getMinutes(); // (0-59)
        var seconds = myDate.getSeconds(); // (0-59)
        var curTime = _fn.addZero(hours) + ':' + _fn.addZero(minutes) + ':' + _fn.addZero(seconds);
        if (timeVal == '' || timeVal == 'T') {
            return showDate == 'Y' ? this.GetDate('t') + ' ' + curTime : curTime;
        }
        if (timeVal == 'S') {
            return showDate == 'Y' ? this.GetDate('t') + ' ' + '00:00:00' : '00:00:00';
        }
        if (timeVal == 'L') {
            return showDate == 'Y' ? this.GetDate('t') + ' ' + '23:59:59' : '23:59:59';
        }
        var addDays = 0;
        seconds = hours * 60 * 60 + minutes * 60 + seconds;
        var remainSeconds = seconds;
        // ��������
        if (timeVal.indexOf('+') >= 0) {
            var newSeconds = seconds + parseInt(timeVal.split('+')[1]);
            var remainSeconds = newSeconds;
            if (newSeconds > 86399) {
                addDays = Math.floor(newSeconds / 86400);
                remainSeconds = newSeconds % 86400;
            }
            return showDate == 'Y' ? this.GetDate('t+' + addDays) + ' ' + _fn.getTime(remainSeconds) : _fn.getTime(remainSeconds);
        }
        // ��������
        if (timeVal.indexOf('-') >= 0) {
            var newSeconds = seconds + parseInt(timeVal.split('-')[1]);
            var remainSeconds = newSeconds;
            if (newSeconds > 86399) {
                addDays = Math.floor(newSeconds / 86400);
                remainSeconds = newSeconds % 86400;
            }
            return showDate == 'Y' ? this.GetDate('t-' + addDays) + ' ' + _fn.getTime(remainSeconds) : _fn.getTime(remainSeconds);
        }
        return showDate == 'Y' ? this.GetDate('t') + ' ' + curTime : curTime;
    },
    GetDay: function () {
        var day = new Date().getDay();
        if (day == 1) {
            return '����һ';
        } else if (day == 2) {
            return '���ڶ�';
        } else if (day == 3) {
            return '������';
        } else if (day == 4) {
            return '������';
        } else if (day == 5) {
            return '������';
        } else if (day == 6) {
            return '������';
        } else {
            return '������';
        }
    },
    GetLastDay: function (year, month) {
        var new_year = year;
        var new_month = month++;
        if (month > 12) {
            new_month -= 12;
            new_year++;
        }
        var new_date = new Date(new_year, new_month, 1);
        return new Date(new_date.getTime() - 1000 * 60 * 60 * 24).getDate();
    },
    Rand: function () {},

    // ��̬����JS���Ѵ��ڲ������
    LoadJS: function (srcArr, callBack) {
        var loadCnt = srcArr.length;
        var loadI = 0;
        Create();

        function Create() {
            if (loadI >= loadCnt) {
                callBack(loadI);
                return;
            }
            var src = srcArr[loadI];
            if (IsExist(src) == true) {
                loadI++;
                Create();
            } else {
                var head = document.getElementsByTagName('head')[0];
                var script = document.createElement('script');
                script.type = 'text/javascript';
                script.src = src;
                head.appendChild(script);
                script.onload = function () {
                    loadI++;
                    Create();
                };
            }
        }

        function IsExist(src) {
            var scriptArr = document.getElementsByTagName('script');
            for (var i = 0; i < scriptArr.length; i++) {
                if (scriptArr[i].src.indexOf(src.replace('../', '')) >= 0) {
                    return true;
                }
            }
            return false;
        }
    },

    /**
     * �������Nλ��ĸ������
     * @param {number} num ���ɵ�λ��
     */
    RandomStr: function (num) {
        var randomArr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];
        var randomLen = randomArr.length;
        var retStr = '';
        for (var i = 0; i < num; i++) {
            retStr += randomArr[Math.floor(Math.random() * randomLen)];
        }
        return retStr;
    },
    /**
     * ��������
     */
    Array: {
        /**
         * �ж�ĳ�����Ƿ���������,ע��˳��
         * @param {object[]} dataArr - ԭ�����������
         * @param {object} dataObj - ��Ҫ��֤�ظ�������
         */
        IsObjExist: function (dataArr, dataObj) {
            var dataArrStr = JSON.stringify(dataArr);
            var dataObjStr = JSON.stringify(dataObj);
            if (dataArrStr.indexOf(dataObjStr) >= 0) {
                return true;
            }
            return false;
        },
        /**
         * ��֤�����������Ƿ�����ظ�,�ظ�ʱ�������ж�
         * @param {object[]} dataArr - �������� [{},{}...]
         * @param {*} [arguments] ������бȽ��򴫸ò���['name','desc']��ʽ,,����Ϊ['name'],['desc']...
         * @returns {object} ��ͬ���ݵ�λ�����ֵ - ���� {pos:ԭʼλ��,repeatPos:�ظ�λ��,keyArr:['name']}
         */
        GetRepeat: function (dataArr) {
            var argsLen = arguments.length;
            var dataArrLen = dataArr.length;
            var breakFlag = false;
            var retJson = {};
            for (var i = 0; i < dataArrLen; i++) {
                if (breakFlag === true) {
                    break;
                }
                var iObj = dataArr[i]; // ����������
                if (i === dataArrLen - 1) {
                    break;
                }
                for (var j = i + 1; j < dataArrLen; j++) {
                    if (breakFlag === true) {
                        break;
                    }
                    var jObj = dataArr[j];
                    for (var k = 1; k < argsLen; k++) {
                        var kArgsArr = arguments[k];
                        var sameFlag = PHA_UTIL.Object.Equal(iObj, jObj, kArgsArr); // �жϵ�������,һ���ظ����˳�����
                        if (sameFlag === true) {
                            retJson = {
                                pos: i,
                                repeatPos: j,
                                keyArr: kArgsArr
                            };
                            breakFlag = true;
                            break;
                        }
                    }
                }
            }
            return retJson;
        }
    },
    /**
     * ��������
     */
    Object: {
        /**
         * �ж϶����Ƿ����
         * @param {object} origObj ԭʼ����
         * @param {object} newObj Ҫ�Ƚ϶���
         * @param {array} [chkKeyArr] ������бȽ��򴫸ò���['name','desc']��ʽ
         * @returns {boolean}  true - ��ͬ , false - ��ͬ
         */
        Equal: function (origObj, newObj, chkKeyArr) {
            var sameFlag = true;
            if (Array.isArray(chkKeyArr)) {
                for (var i = 0; i < chkKeyArr.length; i++) {
                    var chkKey = chkKeyArr[i];
                    if (origObj[chkKey] != newObj[chkKey]) {
                        sameFlag = false;
                        break;
                    }
                }
            } else {
                var origOwn = Object.getOwnPropertyNames(origObj);
                var newOwn = Object.getOwnPropertyNames(newObj);
                var longerOwn = origOwn.length > newOwn.length ? origOwn : newOwn;
                for (var j = 0; j < longerOwn.length; j++) {
                    var jKey = longerOwn[j];
                    if (origObj[jKey] != newObj[jKey]) {
                        sameFlag = false;
                    }
                }
            }
            return sameFlag;
        }
    },
    /**
     * ȫ��
     */
    FullScreen: function () {
        // IE: ����frame�Ĵ�����Ϊtrue����
        window.top.document.getElementsByName('TRAK_main')[0].setAttribute('allowfullscreen', true);
        window.frameElement.setAttribute('allowfullscreen', true);
        var element = document.querySelector('body');
        ['requestFullscreen', 'mozRequestFullScreen', 'webkitRequestFullscreen', 'msRequestFullscreen'].every(function (value) {
            if (element[value]) {
                element[value]();
                return false;
            }
            return true;
        });
    },
    /**
     * �˳�ȫ��
     */
    ExitFull: function () {
        ['exitFullscreen', 'mozExitFullscreen', 'webkitExitFullscreen', 'msExitFullscreen'].every(function (value) {
            if (document[value]) {
                document[value]();
                return false;
            }
            return true;
        });
    },
    /**
     * ��ʽ��Ϊjs��׼����, ����ǰ̨�Ƚ�
     * @param {*} date 
     * @returns 2022-06-16T16:00:00.000Z
     * @example PHA_UTIL.FmtDate2Standard('2022-06-17') => 2022-06-16T16:00:00.000Z
     */
    FmtDate2Standard: function(date) {
        var y, m, d;
        var date = date.toString();
        if (date.indexOf('-') != -1) {
            y = date.split('-')[0];
            m = date.split('-')[1] - 1;
            d = date.split('-')[2];
        } else if (date.indexOf('/') != -1) {
            y = date.split('/')[2];
            m = date.split('/')[1] - 1;
            d = date.split('/')[0];
        } else {
            var y = date.substring(0, 4);
            var m = date.substring(4, 6) - 1;
            var d = date.substring(6, 8);
        }
        return new Date(y, m, d);
    },

    /**
     * �Ƚ�����,
     * @param {*} date1     ԭ����
     * @param {*} operation ����� >|< , ��֧��С�ڵ���, ����ʱ��ȡ���ж�
     * @param {*} date2     �Ƚ�����
     * @returns true|false
     * @example PHA_UTIL.CompareDate('2022-01-01', '>', '2022-03-03')
     */
    CompareDate: function(date1, operation, date2) {
        var result = null;
        if (!operation) {
            return result; 
        }
       
        var d1 = PHA_UTIL.FmtDate2Standard(date1);
        var d2 = PHA_UTIL.FmtDate2Standard(date2);
        if (d1 != null && d2 != null) {
            switch (operation) {
                case '>':
                    return d1.getTime() > d2.getTime();
                case '<':
                    return d1.getTime() < d2.getTime();
                case '=':
                    return d1.getTime() == d2.getTime();
                default:
                    break;
            }
        }
        return result;
    }
};

/**
 * �����Ƿ���Array֮��
 * @param {*} dataArr
 * @param {*} pObj
 * @return �ظ���λ��
 */
PHA_UTIL.Array.IsFieldsInArray = function (dataArr, fieldsObj, exclueIndex) {
    for (var i = 0, length = dataArr.length; i < length; i++) {
        if (exclueIndex !== undefined) {
            if (exclueIndex === i) {
                continue;
            }
        }
        var dataObj = dataArr[i];
        var flag = true;
        for (var field in fieldsObj) {
            if (fieldsObj[field] !== dataObj[field]) {
                flag = false;
                break;
            }
        }
        if (flag === true) {
            return i;
        }
    }
    return '';
};

