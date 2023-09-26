/**
 * ����:	 ҩ������
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-15
 */
var PHA_UTIL = {
    GetDate: function () {},
    GetTime: function () {},
    Rand: function () {},
    /**
     * ��̬������Դ
     * @param {array} srcArr - ��Ҫ���ص���Դ�����·��
     * @callback callBack - �ص�
     */
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
    }
};
