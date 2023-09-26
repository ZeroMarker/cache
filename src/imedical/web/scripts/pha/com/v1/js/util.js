/**
 * 名称:	 药房工具
 * 编写人:	 yunhaibao
 * 编写日期: 2019-03-15
 */
var PHA_UTIL = {
    GetDate: function () {},
    GetTime: function () {},
    Rand: function () {},
    /**
     * 动态加载资源
     * @param {array} srcArr - 需要加载的资源的相对路径
     * @callback callBack - 回调
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
     * 随机生成N位字母与数字
     * @param {number} num 生成的位数
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
     * 操作数组
     */
    Array: {
        /**
         * 判断某对象是否在数组内,注意顺序
         * @param {object[]} dataArr - 原数组对象数据
         * @param {object} dataObj - 需要验证重复的数据
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
         * 验证数组内数据是否存在重复,重复时返回需判断
         * @param {object[]} dataArr - 对象数组 [{},{}...]
         * @param {*} [arguments] 如果并列比较则传该参数['name','desc']格式,,或者为['name'],['desc']...
         * @returns {object} 相同数据的位置与键值 - 举例 {pos:原始位置,repeatPos:重复位置,keyArr:['name']}
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
                var iObj = dataArr[i]; // 单条数据了
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
                        var sameFlag = PHA_UTIL.Object.Equal(iObj, jObj, kArgsArr); // 判断单个对象,一旦重复就退出返回
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
     * 操作对象
     */
    Object: {
        /**
         * 判断对象是否相等
         * @param {object} origObj 原始对象
         * @param {object} newObj 要比较对象
         * @param {array} [chkKeyArr] 如果并列比较则传该参数['name','desc']格式
         * @returns {boolean}  true - 相同 , false - 不同
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
