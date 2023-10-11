$.extend($.fn.validatebox.defaults.rules, {
	MinLength: {
		validator: function (value, param) {
			var isok = value.length >= param[0];
			return isok;
		},
		message: $g('请至少输入 {0} 个字符.')
	},
	MaxLength: {
		validator: function (value, param) {
			return value.length <= param[0];
		},
		message: $g('最多只能输入 {0} 个字符.')
	},
	MaxValue: {
		validator: function (value, param) {
			return parseFloat(value) <= parseFloat(param[0]);
		},
		message: $g('最大值不能超过 {0}。')
	},
	MinValue: {
		validator: function (value, param) {
			return parseFloat(value) >= parseFloat(param[0]);
		},
		message: $g('不应该小于{0}。')
	},
	IDCard: {
		validator: function (value, param) {
			return IdentityCodeValid(value);
		},
		message: $g('请输入正确的身份证号码.')
	},
	mobile: {
		validator: function (value, param) {
			var phoneReg = /(^1[3|4|5|7|8]\d{9}$)|(^09\d{8}$)/;
			return phoneReg.test(value);
		},
		message: $g('请输入正确的手机号.')
	},
	DynamicTableTitle: {
	    validator: function (value, param) {
	        var Reg = /(\s|-)/;
	        return !Reg.test(value);
	    },
	    message: $g('不能包含空格和-.')
	},
	Tel: {
		validator: function (value, param) {
			var phoneReg = /(^09\d{8}$)/;
			return phoneReg.test(value);
		},
		message: $g('请输入正确的电话号码.')
	},
	TextNumber: {
		validator: function (value, param) {
			var phoneReg = /(^\d*$)/;
			return phoneReg.test(value);
		},
		message: $g('请输入数值型的文字')
	},
	Reg: {
		validator: function (value, param) {
			var text = param[0];
			var re = new RegExp(text);
			return re.test(value);
		},
		message: $g('请输入正确的信息')
	},
    /*签名(单签)对比，签名不能是同一个人*/
	SingleSignNoSame: {
	    validator: function (value, param) {
	        var id = param[0].id;
	        var fieldValue = GetValueByName(id);
	        if (!!fieldValue) {
	            return fieldValue.indexOf("CA"+value) == -1;
	        }
	        return true;
	    },
	    message: $g('签名不能是同一个人')
	},
	/*数值比较，大于等于指定元素的值*/
    NumGE: {
		validator: function (value, param) {
			var id = param[0];
			var fieldValue = GetValueByName(id);
			if (!!fieldValue) {
				return value >= parseFloat(fieldValue);
			}
			return false;
		},
		message: $g('请输入正确的信息。')
	},
	/*数值比较，大于指定元素的值*/
    NumG: {
		validator: function (value, param) {
			var id = param[0];
			var fieldValue = GetValueByName(id);
			if (!!fieldValue) {
				return value > parseFloat(fieldValue);
			}
			return false;
		},
		message: $g('请输入正确的信息。')
	},
	/*数值比较，小于等于指定元素的值*/
    NumLE: {
		validator: function (value, param) {
			var id = param[0];
			var fieldValue = GetValueByName(id);
			if (!!fieldValue) {
				return value <= parseFloat(fieldValue);
			}
			return false;
		},
		message: $g('请输入正确的信息。')
	},
	/*数值比较，小于指定元素的值*/
    NumL: {
		validator: function (value, param) {
			var id = param[0];
			var fieldValue = GetValueByName(id);
			if (!!fieldValue) {
				return value < parseFloat(fieldValue);
			}
			return false;
		},
		message: $g('请输入正确的信息。')
    },
    /*时间比较，大于等于指定元素的值*/
    TimeGE: {
        validator: function (value, param) {

            var id = param[0];
            var fieldValue = GetValueByName(id);
            if (!!fieldValue) {

                var today = new Date();

                var oDate1 = new Date(today.toDateString() + " " + fieldValue);
                var oDate2 = new Date(today.toDateString() + " " + value);

                return oDate2.getTime() >= oDate1.getTime();
            }

            return false;
        },
        message:$g( '请输入正确的信息。')
    },
    /*时间比较，大于指定元素的值*/
    TimeG: {
        validator: function (value, param) {
            var id = param[0];
            var fieldValue = GetValueByName(id);
            if (!!fieldValue) {

                var today = new Date();

                var oDate1 = new Date(today.toDateString() + " " + fieldValue);
                var oDate2 = new Date(today.toDateString() + " " + value);

                return oDate2.getTime() > oDate1.getTime();
            }

            return false;
        },
        message: $g('请输入正确的信息。')
    },
    /*时间比较，小于等于指定元素的值*/
    TimeLE: {
        validator: function (value, param) {
            var id = param[0];
            var fieldValue = GetValueByName(id);
            if (!!fieldValue) {

                var today = new Date();

                var oDate1 = new Date(today.toDateString() + " " + fieldValue);
                var oDate2 = new Date(today.toDateString() + " " + value);

                return oDate2.getTime() <= oDate1.getTime();
            }

            return false;
        },
        message: $g('请输入正确的信息。')
    },
    /*时间比较，小于指定元素的值*/
    TimeL: {
        validator: function (value, param) {
            var id = param[0];
            var fieldValue = GetValueByName(id);
            if (!!fieldValue) {

                var today = new Date();

                var oDate1 = new Date(today.toDateString() + " " + fieldValue);
                var oDate2 = new Date(today.toDateString() + " " + value);

                return oDate2.getTime() < oDate1.getTime();
            }

            return false;
        },
        message: $g('请输入正确的信息。')
    },
	/*错误下限*/
	ErrorMin: {
		validator: function (value, param) {
			return (value >= param[0]);
        },
		message: $g('小于{0}，错误值 。')
	},
	/*错误上限*/
	ErrorMax: {
	    validator: function (value, param) {
			return (value <= param[0]);
        },
		message: $g('大于{0}，错误值 。')
	},
    /*错误下限*/
	TextErrorMin: {
	    validator: function (value, param) {
	        var regPositivefloat = /^\d+(\.\d+)?$/;
	        var regNegativefloat = /^((-\d+(\.\d+)?)|(0+(\.0+)?))$/;
	        if (regPositivefloat.test(value) || regNegativefloat.test(value)) {
	            return (value >= param[0]);
	        }
	        else
	            return true;
	    },
	    message: $g('小于{0}，错误值 。')
	},
    /*错误上限*/
	TextErrorMax: {
	    validator: function (value, param) {
	        var regPositivefloat = /^\d+(\.\d+)?$/;
	        var regNegativefloat = /^((-\d+(\.\d+)?)|(0+(\.0+)?))$/;
	        if (regPositivefloat.test(value) || regNegativefloat.test(value)) {
	            return (value <= param[0]);
	        }
	        else
	            return true;
	    },
	    message: $g('大于{0}，错误值 。')
	},
    /*预警下限*/
	WarningMin: {
	    validator: function (value, param) {
	        return (value >= param[0]);
	    },
	    message: $g('小于{0}，预警值 。')
	},
    /*预警上限*/
	WarningMax: {
	    validator: function (value, param) {
	        return (value <= param[0]);
	    },
	    message: $g('大于{0}，预警值 。')
	},
    /*日期比较，大于等于指定元素的值*/
	DateGE: {
	    validator: function (value, param) {

	        var id = param[0];
	        var fieldValue = GetValueByName(id);
	        if (!!fieldValue) {

	            var d1 = $.fn.datebox.defaults.parser(fieldValue);
	            value = FormatDateByyyyyMMdd(value, $(this).attr("format"))
	            var d2 = $.fn.datebox.defaults.parser(value);
	            return d2 >= d1;
	        }

	        return false;
	    },
	    message: $g('请输入正确的信息。')
	},
    /*日期比较，大于指定元素的值*/
	DateG: {
	    validator: function (value, param) {
	        var id = param[0];
	        var fieldValue = GetValueByName(id);
	        if (!!fieldValue) {

	            var d1 = $.fn.datebox.defaults.parser(fieldValue);
	            value = FormatDateByyyyyMMdd(value, $(this).attr("format"))
	            var d2 = $.fn.datebox.defaults.parser(value);
	            return d2 > d1;
	        }

	        return false;
	    },
	    message: $g('请输入正确的信息。')
	},
    /*日期比较，小于等于指定元素的值*/
	DateLE: {
	    validator: function (value, param) {
	        var id = param[0];
	        var fieldValue = GetValueByName(id);
	        if (!!fieldValue) {

	            var d1 = $.fn.datebox.defaults.parser(fieldValue);
	            value = FormatDateByyyyyMMdd(value, $(this).attr("format"))
	            var d2 = $.fn.datebox.defaults.parser(value);
	            return d2 <= d1;
	        }

	        return false;
	    },
	    message: $g('请输入正确的信息。')
	},
    /*日期比较，小于指定元素的值*/
	DateL: {
	    validator: function (value, param) {
	        var id = param[0];
	        var fieldValue = GetValueByName(id);
	        if (!!fieldValue) {

	            var d1 = $.fn.datebox.defaults.parser(fieldValue);
	            value = FormatDateByyyyyMMdd(value, $(this).attr("format"))
	            var d2 = $.fn.datebox.defaults.parser(value);
	            return d2 < d1;
	        }

	        return false;
	    },
	    message: $g('请输入正确的信息。')
	},
    /*日期格式验证*/
	DateFormat: {
	    validator: function (value, param) {
	        var re = new RegExp("(" + param + ")");
	        var reYear = /\d{4,}/;;
	        if (param == "yyyy年MM月dd日")//yyyy年MM月dd日
	        {
	            re = /^\d{4}年\d{2}月\d{2}日$/;///^\d+$/
	        }
	        else if (param == "dd/MM/yyyy")//dd/MM/yyyy
	        {
	            re = /^\d{2}\/\d{2}\/\d{4}$/;
	        }
	        var res = re.test(value);
	        return res;
	    },
	    message: $g('日期格式不正确。')
	},
});
if ($.fn.timespinner) {
    $.fn.timespinner.defaults.missingMessage = $g('该输入项为必输项');
}
function IdentityCodeValid(code) {
	var city = {
		11: "北京",
		12: "天津",
		13: "河北",
		14: "山西",
		15: "内蒙古",
		21: "辽宁",
		22: "吉林",
		23: "黑龙江 ",
		31: "上海",
		32: "江苏",
		33: "浙江",
		34: "安徽",
		35: "福建",
		36: "江西",
		37: "山东",
		41: "河南",
		42: "湖北 ",
		43: "湖南",
		44: "广东",
		45: "广西",
		46: "海南",
		50: "重庆",
		51: "四川",
		52: "贵州",
		53: "云南",
		54: "西藏 ",
		61: "陕西",
		62: "甘肃",
		63: "青海",
		64: "宁夏",
		65: "新疆",
		71: "台湾",
		81: "香港",
		82: "澳门",
		91: "国外 "
	};
	var tip = "";
	var pass = true;

	if (!code || !/^\d{6}(18|19|20)?\d{2}(0[1-9]|1[012])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$/i.test(code)) {
	    tip = $g("身份证号格式错误");
		pass = false;
	} else if (!city[code.substr(0, 2)]) {
	    tip = $g("地址编码错误");
		pass = false;
	} else {
		//18位身份证需要验证最后一位校验位
		if (code.length == 18) {
			code = code.split('');
			//∑(ai×Wi)(mod 11)
			//加权因子
			var factor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
			//校验位
			var parity = [1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2];
			var sum = 0;
			var ai = 0;
			var wi = 0;
			for (var i = 0; i < 17; i++) {
				ai = code[i];
				wi = factor[i];
				sum += ai * wi;
			}
			var last = parity[sum % 11];
			if (parity[sum % 11] != code[17]) {
			    tip = $g("校验位错误");
				pass = false;
			}
		}
	}
	//  if (!pass) alert(tip);
	return pass;
}

/**
 * 数字预警值验证
 **/
function NumberWarningValidate(currentValue, warningMin, warningMax) {
    if (!!currentValue) {
        var warningText = '';
        if ((!!warningMin) && (!!warningMax)) {
            if ((currentValue < warningMin) || (currentValue > warningMax)) {
                warningText = $g('输入值为预警值，请参考正常值范围 【{0}~{1} 】。').format(warningMin, warningMax);
            }
        }
        else if ((!!warningMin) && (!warningMax)) {
            if (currentValue < warningMin) {
                warningText = $g('输入值为预警值，正常值应不小于 【{0}】').format(warningMin);
            }
        }
        else if ((!warningMin) && (!!warningMax)) {
            if (currentValue > warningMax) {
                warningText = $g('输入值为预警值，正常值应不大于 【{0}】').format(warningMax);
            }
        }
        if (!!warningText) {
			//console.log(warningText);
			//$.messager.alert(" ", warningText, "info");
			alert(warningText);
        }
    }

}
/**
 * 文本数字预警值验证
 **/
function TextNumberWarningValidate(currentValue, warningMin, warningMax) {
    if (!!currentValue) {

        var regPositivefloat = /^\d+(\.\d+)?$/;
        var regNegativefloat = /^((-\d+(\.\d+)?)|(0+(\.0+)?))$/;

        if (regPositivefloat.test(currentValue) || regNegativefloat.test(currentValue))
        {
            var warningText = '';
            if ((!!warningMin) && (!!warningMax)) {
                if ((currentValue < warningMin) || (currentValue > warningMax)) {
                    warningText = $g('输入值为预警值，请参考正常值范围 【{0}~{1} 】。').format(warningMin, warningMax);
                }
            }
            else if ((!!warningMin) && (!warningMax)) {
                if (currentValue < warningMin) {
                    warningText = $g('输入值为预警值，正常值应不小于 【{0}】').format(warningMin);
                }
            }
            else if ((!warningMin) && (!!warningMax)) {
                if (currentValue > warningMax) {
                    warningText = $g('输入值为预警值，正常值应不大于 【{0}】').format(warningMax);
                }
            }
            if (!!warningText) {
                //console.log(warningText);
                //$.messager.alert(" ", warningText, "info");
                alert(warningText);
            }
        }
    }

}

/**
 * 确保日期控件，1.格式为空时，用“YMD”进行格式校验 2.增加日期可选范围
 **/
$.extend($.fn.dateboxq.defaults, {
    validType: {
        datebox: "YMD",
        minMaxDate: [null, null]
    },
    minDate: "1900-01-01",
    maxDate: "3000-01-01"
});


