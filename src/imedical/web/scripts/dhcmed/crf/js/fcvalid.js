




Valid = {
    Require: /.+/,
    Email: /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/,
    Phone: /^((\(\d{2,3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$/,
    Mobile: /^((\(\d{2,3}\))|(\d{3}\-))?13\d{9}$/,
    Url: /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/,
    IdCard: "this.IsIdCard(value)",
    Currency: /^\d+(\.\d+)?$/,
    Number: /^\d+$/,
    Zip: /^[1-9]\d{5}$/,
    QQ: /^[1-9]\d{4,8}$/,
    Integer: /^[-\+]?\d+$/,
    Double: /^[-\+]?\d+(\.\d+)?$/,
    English: /^[A-Za-z]+$/,
    Chinese: /^[\u0391-\uFFE5]+$/,
    Username: /^[a-z]\w{3,}$/i,
    UnSafe: /^(([A-Z]*|[a-z]*|\d*|[-_\~!@#\$%\^&\*\.\(\)\[\]\{\}<>\?\\\/\'\"]*)|.{0,5})$|\s/,
    IsSafe: function (str) { return !this.UnSafe.test(str); },
    SafeString: "this.IsSafe(value)",
    Filter: "this.DoFilter(value, getAttribute('accept'))",
    Limit: "this.limit(value.length,getAttribute('min'),  getAttribute('max'))",
    LimitB: "this.limit(this.LenB(value), getAttribute('min'), getAttribute('max'))",
    Date: "this.IsDate(value, getAttribute('min'), getAttribute('format'))",
    Repeat: "value == document.getElementsByName(getAttribute('to'))[0].value",
    Range: "getAttribute('min') < (value|0) && (value|0) < getAttribute('max')",
    Compare: "this.compare(value,getAttribute('operator'),getAttribute('to'))",
    Custom: "this.Exec(value, getAttribute('regexp'))",
    Group: "this.MustChecked(getAttribute('name'), getAttribute('min'), getAttribute('max'))",
    ErrorItem: [document.forms[0]],
    ErrorMessage: ["以下原因导致提交失败：\t\t\t\t"],
    getAttribute: function (name) { return eval("this." + name); },
    _choose: function (obj, typeNo, _dataType, i) {
        with (obj) {
            switch (_dataType) {
                case "IdCard":
                case "Date":
                case "Repeat":
                case "Range":
                case "Compare":
                case "Custom":
                case "Group":
                case "Limit":
                case "LimitB":
                case "SafeString":
                case "Filter":
                    if (!eval(this[_dataType])) {
                        return _ret(obj, typeNo);
                    }
                    break;
                default:
                    if (!this[_dataType].test(value)) {
                        return _ret(obj, typeNo);
                    }
                    break;
            }
        }
        if (typeNo == 1) return true;
        if (typeNo == 2) return "";

        function _ret(obj, typeNo) {
            with (obj) {
                if (typeNo == 1) return false;
                if (typeNo == 2) return getAttribute("msg");
                if (typeNo == 3) this.AddError(i, getAttribute("msg"));
            }
        }
    },
    checkValue: function (_dataType, value) {
        this.value = value;
        return this._choose(this, 1, _dataType);
    },
    checkObj: function (obj) {
        var o = obj || event.srcElement;
        var _dataType = o.getAttribute("dataType");
        return this._choose(o, 2, _dataType);
    },
    Validate: function (theForm, mode) {
        var obj = theForm || event.srcElement;
        var count = obj.elements.length;
        this.ErrorMessage.length = 1;
        this.ErrorItem.length = 1;
        this.ErrorItem[0] = obj;
        for (var i = 0; i < count; i++) {
            with (obj.elements[i]) {
                var _dataType = getAttribute("dataType");
                if (typeof (_dataType) == "object" || typeof (this[_dataType]) == "undefined") continue;
                this.ClearState(obj.elements[i]);
                if (getAttribute("require") == "false" && value == "") continue;
            }
            this._choose(obj.elements[i], 3, _dataType, i);
        }
        if (this.ErrorMessage.length > 1) {
            mode = mode || 1;
            var errCount = this.ErrorItem.length;
            switch (mode) {
                case 2:
                    for (var i = 1; i < errCount; i++)
                        this.ErrorItem[i].style.color = "red";
                case 1:
                    alert(this.ErrorMessage.join("\n"));
                    this.ErrorItem[1].focus();
                    break;
                case 3:
                    for (var i = 1; i < errCount; i++) {
                        try {
                            var span = document.createElement("SPAN");
                            span.id = "__ErrorMessagePanel";
                            span.style.color = "red";
                            this.ErrorItem[i].parentNode.appendChild(span);
                            span.innerHTML = this.ErrorMessage[i].replace(/\d+:/, "*");
                        }
                        catch (e) { alert(e.description); }
                    }
                    this.ErrorItem[1].focus();
                    break;
                default:
                    alert(this.ErrorMessage.join("\n"));
                    break;
            }
            return false;
        }
        return true;
    },
    limit: function (len, min, max) {
        min = min || 0;
        max = max || Number.MAX_VALUE;
        return min <= len && len <= max;
    },
    LenB: function (str) {
        return str.replace(/[^\x00-\xff]/g, "**").length;
    },
    ClearState: function (elem) {
        with (elem) {
            if (style.color == "red")
                style.color = "";
            var lastNode = parentNode.childNodes[parentNode.childNodes.length - 1];
            if (lastNode.id == "__ErrorMessagePanel")
                parentNode.removeChild(lastNode);
        }
    },
    AddError: function (index, str) {
        this.ErrorItem[this.ErrorItem.length] = this.ErrorItem[0].elements[index];
        this.ErrorMessage[this.ErrorMessage.length] = this.ErrorMessage.length + ":" + str;
    },
    Exec: function (op, reg) {
        return new RegExp(reg, "g").test(op);
    },
    compare: function (op1, operator, op2) {
        switch (operator) {
            case "NotEqual":
                return (op1 != op2);
            case "GreaterThan":
                return (op1 > op2);
            case "GreaterThanEqual":
                return (op1 >= op2);
            case "LessThan":
                return (op1 < op2);
            case "LessThanEqual":
                return (op1 <= op2);
            default:
                return (op1 == op2);
        }
    },
    MustChecked: function (name, min, max) {
        var groups = document.getElementsByName(name);
        var hasChecked = 0;
        min = min || 1;
        max = max || groups.length;
        for (var i = groups.length - 1; i >= 0; i--)
            if (groups[i].checked) hasChecked++;
        return min <= hasChecked && hasChecked <= max;
    },
    DoFilter: function (input, filter) {
        return new RegExp("^.+\.(?=EXT)(EXT)$".replace(/EXT/g, filter.split(/\s*,\s*/).join("|")), "gi").test(input);
    },
    IsIdCard: function (number) {
        var date, Ai;
        var verify = "10x98765432";
        var Wi = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
        var area = ['', '', '', '', '', '', '', '', '', '', '', 'bj', 'bj', 'bj', 'bj', 'bj', '', '', '', '', '', 'bj', 'bj', 'bj', '', '', '', '', '', '', '', 'bj', 'bj', 'bj', 'bj', 'bj', 'bj', 'bj', '', '', '', 'bj', 'bj', 'bj', 'bj', 'bj', 'bj', '', '', '', 'bj', 'bj', 'bj', 'bj', 'bj', '', '', '', '', '', '', 'bj', 'bj', 'bj', 'bj', 'bj', '', '', '', '', '', 'bj', '', '', '', '', '', '', '', '', '', 'bj', 'bj', '', '', '', '', '', '', '', '', 'bj'];
        var re = number.match(/^(\d{2})\d{4}(((\d{2})(\d{2})(\d{2})(\d{3}))|((\d{4})(\d{2})(\d{2})(\d{3}[x\d])))$/i);
        if (re == null) return false;
        if (re[1] >= area.length || area[re[1]] == "") return false;
        if (re[2].length == 12) {
            Ai = number.substr(0, 17);
            date = [re[9], re[10], re[11]].join("-");
        }
        else {
            Ai = number.substr(0, 6) + "19" + number.substr(6);
            date = ["19" + re[4], re[5], re[6]].join("-");
        }
        if (!this.IsDate(date, "ymd")) return false;
        var sum = 0;
        for (var i = 0; i <= 16; i++) {
            sum += Ai.charAt(i) * Wi[i];
        }
        Ai += verify.charAt(sum % 11);
        return (number.length == 15 || number.length == 18 && number == Ai);
    },
    IsDate: function (op, formatString) {
        formatString = formatString || "ymd";
        var m, year, month, day;
        switch (formatString) {
            case "ymd":
                m = op.match(new RegExp("^((\\d{4})|(\\d{2}))([-./])(\\d{1,2})\\4(\\d{1,2})$"));
                if (m == null) return false;
                day = m[6];
                month = m[5] * 1;
                year = (m[2].length == 4) ? m[2] : GetFullYear(parseInt(m[3], 10));
                break;
            case "dmy":
                m = op.match(new RegExp("^(\\d{1,2})([-./])(\\d{1,2})\\2((\\d{4})|(\\d{2}))$"));
                if (m == null) return false;
                day = m[1];
                month = m[3] * 1;
                year = (m[5].length == 4) ? m[5] : GetFullYear(parseInt(m[6], 10));
                break;
            default:
                break;
        }
        if (!parseInt(month)) return false;
        month = month == 0 ? 12 : month;
        var date = new Date(year, month - 1, day);
        return (typeof (date) == "object" && year == date.getFullYear() && month == (date.getMonth() + 1) && day == date.getDate());
        function GetFullYear(y) { return ((y < 30 ? "20" : "19") + y) | 0; }
    }
}
function IsNum(sNum) {
    sNum = new Eapi.Str().trim(sNum + "");
    var s1 = parseFloat(sNum);
    if (isNaN(s1)) return false;
    if (s1 + "" != sNum) return false;
    return true;
}
function IsInt(sNum) {
    sNum = new Eapi.Str().trim(sNum + "");
    var s1 = parseInt(sNum);
    if (isNaN(s1)) return false;
    if (s1 + "" != sNum) return false;
    if (s1 > 2147483647) return false
    return true;
}

function IsIdcard(sId) {
    var aCity = { 11: "北京", 12: "天津", 13: "河北", 14: "山西", 15: "内蒙古", 21: "辽宁", 22: "吉林", 23: "黑龙江", 31: "上海", 32: "江苏", 33: "浙江", 34: "安徽", 35: "福建", 36: "江西", 37: "山东", 41: "河南", 42: "湖北", 43: "湖南", 44: "广东", 45: "广西", 46: "海南", 50: "重庆", 51: "四川", 52: "贵州", 53: "云南", 54: "西藏", 61: "陕西", 62: "甘肃", 63: "青海", 64: "宁夏", 65: "新疆", 71: "台湾", 81: "香港", 82: "澳门", 91: "国外" };
    if (!/^\d{15}(\d{2}(\d|x))?$/i.test(sId)) {
        return false;
    }
    if (aCity[parseInt(sId.substr(0, 2))] == null) {
        return false;
    }
    if (sId.length == 15) {
        sBirthday = "19" + sId.substr(6, 2) + "-" + Number(sId.substr(8, 2)) + "-" + Number(sId.substr(10, 2));
    }
    else {
        sBirthday = sId.substr(6, 4) + "-" + Number(sId.substr(10, 2)) + "-" + Number(sId.substr(12, 2));
    }
    var d = new Date(sBirthday.replace(/-/g, "/"))
    if (sBirthday != (d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate())) {
        return false;
    }
    if (sId.length == 18) {
        var iSum = 0
        sId = sId.replace(/x$/i, "a");
        for (var i = 17; i >= 0; i--) {
            iSum += (Math.pow(2, i) % 11) * parseInt(sId.charAt(17 - i), 11)
        }
        if (iSum % 11 != 1) {
            return false;
        }
    }
    return true;
}


function IsPostcode(str) {
    var reg = /^\d{6}$/;
    return reg.test(str);
}


function IsPhone(str) {
    var reg = /^(([0\+]\d{2,3}-)?(0\d{2,3})-)?(\d{7,8})(-(\d{3,}))?(,(([0\+]\d{2,3}-)?(0\d{2,3})-)?(\d{7,8})(-(\d{3,}))?)*$/;

    return reg.test(str);
}


function IsMobile(str) {
    var reg = /(^0?[1][3|5][0-9]{9}(,0?[1][3|5][0-9]{9})*$)/;
    return reg.test(str);
}

function IsDataSetFieldRepeat(ods, fieldName) {
    var l = ods.oDom.documentElement.childNodes.length - 1;
    var col = ods.FieldNameToNo(fieldName);
    var value1 = ods.Field(fieldName).Value;
    var bRepeat = false;
    for (var i = 0; i < l; i++) {
        if (value1 == ods.oDom.documentElement.childNodes(i).childNodes(col).text && i != ods.RecNo) {
            bRepeat = true;
            break;
        }
    }
    return bRepeat;
}


function $valid(checkType, alertMsg, objEvent) {
    var oEvent = objEvent;
    if (typeof (objEvent) == "undefined") oEvent = event;
    if (typeof alertMsg == "undefined") alertMsg = "";
    var eType = oEvent.type;
    var checkObj = oEvent.srcElement;
    var strvalue = checkObj.value;
    if (eType == "Valid") strvalue = oEvent.FieldValue;
    var strChinese = alertMsg;
    if (IsSpace(strChinese)) {
        if (eType == "Valid") {
            strChinese = oEvent.DisplayLabel;
        } else {
            strChinese = checkObj.china;
        }
    }
    if (typeof strChinese == "undefined") strChinese = "";
    if (typeof strvalue == "undefined") strvalue = "";
    var reg;
    var ret = true;
    var strMsg = "";
    if (strvalue.length > 0) {
        switch (checkType) {
            case "整数":
                ret = IsInt(strvalue);
                break;
            case "小数":
                ret = IsNum(strvalue);
                break;
            case "日期":
                ret = Valid.checkValue("Date", strvalue);
                break;
            case "QQ":
                ret = Valid.checkValue("QQ", strvalue);
                break;
            case "身份证号":
                ret = IsIdcard(strvalue);
                break;
            case "Email":
                ret = Valid.checkValue("Email", strvalue);
                break;
            case "电话号码":
                ret = IsPhone(strvalue);
                break;
            case "手机":
                ret = IsMobile(strvalue);
                break;
            case "邮政编号":
                ret = IsPostcode(strvalue);
                break;
            case "正数":
                ret = IsFloat(strvalue);
                break;
            case "正整数":
                reg = /^\+?[0-9]*[1-9][0-9]*$/;
                ret = reg.test(strvalue);
                break;
            case "负数":
                reg = /^-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$/;
                ret = reg.test(strvalue);
                break;
            case "负整数":
                reg = /^-[0-9]*[1-9][0-9]*$/;
                ret = reg.test(strvalue);
                break;
            case "零或正数":
                reg = /^\+?\d+(\.\d+)?$/;
                ret = reg.test(strvalue);
                break;
            case "零或负数":
                reg = /^((-\d+(\.\d+)?)|(0+(\.0+)?))$/;
                ret = reg.test(strvalue);
                break;
            case "零或正整数":
                reg = /^\+?[0-9]*[0-9][0-9]*$/;
                ret = reg.test(strvalue);
                break;
            case "零或负整数":
                reg = /^([0?]$)|(-[0-9]*[0-9][0-9]*$)/;
                ret = reg.test(strvalue);
                break;
            case "字母、数字或_":
                strMsg = "只能是字母、数字或_。";
                reg = /[^_|a-z|A-Z|0-9]/;
                ret = !reg.test(strvalue);
                break;
            case "不含汉字":
                strMsg = "不能含有汉字。";
                reg = /[\u4e00-\u9fa5]/;
                ret = !reg.test(strvalue);
                break;
            case "不含双引号":
                strMsg = "不能含有双引号。";
                reg = /[\"]/;
                ret = !reg.test(strvalue);
                break;
            case "不含单引号":
                strMsg = "不能含有单引号。";
                reg = /[\']/;
                ret = !reg.test(strvalue);
                break;
            case "不能为空":
                strMsg = "不能为空。";
                reg = /^\s*$/;
                ret = !reg.test(strvalue);
                break;
            case "字段值不重复":
                if (eType == "Valid") {
                    var oDs = oEvent.DataSet;
                    if (IsSpace(oDs) == false) {
                        ret = IsDataSetFieldRepeat(oDs, oEvent.FieldName);
                        strMsg = "字段值不能重复。";
                    }
                }
                break;
        }
    }
    if (!ret) {
        if (strChinese == checkType)
            strChinese = "";
        if (typeof (objEvent) == "undefined" && eType != "Valid") {
            var obj = new Object();
            obj.srcElement = oEvent.srcElement;
            obj.type = oEvent.type;
            obj.checkType = checkType;
            obj.alertMsg = alertMsg;
            fcpubdata.arrValidObj[fcpubdata.arrValidObj.length] = obj;
        }
        if (strMsg == "") strMsg = "不是合法的" + checkType + "。";
        throw (new Error(-1, strChinese + strMsg));
    }
}



function validAllForm() {
    for (var i = fcpubdata.arrValidObj.length - 1; i >= 0; i--) {
        var obj = fcpubdata.arrValidObj[i];
        try {
            $valid(obj.checkType, obj.alertMsg, obj);
        } catch (e) {
            return e.description;
        }
        Array.removeAt(fcpubdata.arrValidObj, i);
    }
    return "";
}
function validDsGrid(dsGrid) {

    if (dsGrid.isNeedValid == "yes") {
        var cols = dsGrid.FieldCount;
        try {
            new Eapi.DataSet().actionChangeData(dsGrid, function (row) {
                for (var i = 0; i < cols; i++) {
                    var sErr = dsGrid.dataValid(dsGrid.Field(i), row.childNodes(i).text, 5);
                    if (sErr != "") throw new Error(sErr);
                }
            });
        } catch (e) {
            return e.description;
        }
        dsGrid.isNeedValid = "no";
    }
    return "";
}