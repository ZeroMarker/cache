/**公共js方法
 */
var PmRunQianUrl = "dhccpmrunqianreport.csp";   //润乾报表调用dhcstm.pmrunqianreport.csp 固定toolbar。dhccpmrunqianreport.csp，公司版本
var CommParObj=GetAppPropValue("DHCSTCOMMONM");
var App_MenuCspName=TRELOADPAGE;
var FormBlockJson={};
var FormMustInput=[];
var ButtonCountObj={};
var gWinWidth = $(window).width() * 0.9;	//默认弹出窗口的宽度高度,适应当前窗口的大小
var gWinHeight = $(window).height() * 0.9;
var gGridHeight = $(window).height() * 0.6;
var PrintMethod=1;  //普通单据打印方式 0-Lodop 1-RQ
var HVBarcodePrintMethod=0;  //高值条码打印方式 0-Lodop 1-XML(支持IE)
var StkGrpHospid="";
/**
 * 为string添加startWith方法
 * @param str
 * @returns
 */
String.prototype.startWith = function(str) {
	var regexp = eval("/^" + str + "/");
	return regexp.test(this);
};
/**
 * 为string添加leftPad方法
 * @param str
 * @returns
 */
leftPad = function (str,paddingChar,len) {
        if (str.length < len) { for (; str.length < len; str = paddingChar + str) { } }
        return str;
    };
 String.prototype.leftPad = function (paddingChar,len) { return leftPad(this, paddingChar,len); };

/**
 * 获取日期
 * 
 * @param expr
 *            表达式（可以是字符串（日期表达式）、数字（毫秒值）、或者Date）
 * @param delimiter
 *            （仅当expr为字符串时此参数生效）
 * @returns Date
 */
function getDate(expr, delimiter) {
	var result = null;
	if (null != expr) {
		if (typeof (expr) == "string") {
			var _delimiter = "-";
			if (delimiter) {
				_delimiter = delimiter;
			}
			var arr = expr.split(_delimiter);
			result = new Date(arr[0], (parseInt(arr[1], 10) - 1), arr[2]);
		} else if (expr instanceof Date) {
			result = expr;
		} else if (!isNaN(expr)) {
			result = new Date(expr);
		}
	}

	return result;
}

/**
 * 比较两个日期
 * 
 * @param date1
 *            表达式（可以是字符串（日期表达式）、数字（毫秒值）、或者Date）
 * @param date2
 *            表达式（可以是字符串（日期表达式）、数字（毫秒值）、或者Date）
 * @returns true: date1 > date2, false: date1 < date2, null:
 *          date1或date2不是一个有效的日期表达式
 */
function compareDate(date1, date2) {
	var result = null;

	var d1 = getDate(date1);
	var d2 = getDate(date2);

	if (d1 != null && d2 != null) {
		return d1.getTime() > d2.getTime();
	}
	return result;
}

/**
 * 日期相减，返回两个日期相差的天数，日期不分前后
 * 
 * @param date1
 *            可以是字符串（yyyy-mm-dd）、数字、或Date
 * @param date2
 *            可以是字符串（yyyy-mm-dd）、数字、或Date
 * @param delimiter
 *            日期的分隔符，默认为“-”
 * @returns 返回两个日期相差的天数
 */
function dateDiff(date1, date2, delimiter) {
	var result = null;

	var sRDate = getDate(date1, delimiter);
	var eRDate = getDate(date2, delimiter);

	if (null != sRDate && null != eRDate) {
		if (sRDate.getTime() > eRDate.getTime()) {
			result = (sRDate - eRDate) / (24 * 60 * 60 * 1000);
		} else {
			result = (eRDate - sRDate) / (24 * 60 * 60 * 1000);
		}
	}

	return result;
}

/**
 * 简单日期格式化
 * 
 * @param date
 *            日期
 * @param delimiter
 *            分隔符，可选，默认为“-”
 * @returns 返回形式如“yyyy-mm-dd”的格式
 */
function simpleDateFormat(date, delimiter) {
	var result = null;
	if (null != date) {
		var _delimiter = "-";
		if (delimiter) {
			_delimiter = delimiter;
		}
		var month = date.getMonth() + 1;
		return date.getFullYear() + _delimiter
				+ (month > 9 ? month : "0" + month) + _delimiter
				+ (date.getDate() > 9 ? date.getDate() : "0" + date.getDate());
	}

	return result;
}
/**
 * 获取标签定义在class上的属性值
 * 
 * @param obj
 *            对象（dom对象|jQuery对象|标签id）
 * @param propertyName
 * @returns
 */
function getClassProperty(obj, propertyName) {
	var result = "";
	if (obj) {
		var _obj;
		if ("string" == typeof (obj)) {
			_obj = document.getElementById(obj);
		} else if ("object" == typeof (obj)) {
			_obj = (obj instanceof jQuery) ? obj[0] : obj;
		}
		if (_obj && _obj.className) {
			var regex = eval("/\\[\\s*?" + propertyName
					+ "\\s*?=\\s*?([^\\]]*)\\s*?\\]/");// 动态正则表达式
			var matches = _obj.className.match(regex);
			if (matches) {
				result = matches[1];
			}
		}
	}
	return result;
}

/**
 * 在标签的class上自定义属性（class中添加表达式格式“[p=pvalue]”）
 * 
 * @param obj
 *            对象（dom对象|jQuery对象|标签id）
 * @param propertyName
 *            属性名
 * @param propertyValue
 *            属性值
 * @returns
 */
function setClassProperty(obj, propertyName, propertyValue) {
	var _obj;
	if (obj) {
		if ("string" == typeof (obj)) {
			_obj = jQuery("#" + obj);
		} else if ("object" == typeof (obj)) {
			_obj = (obj instanceof jQuery) ? obj : jQuery(obj);
		}
		if (_obj) {
			_obj.addClass("[" + propertyName + "=" + propertyValue + "]");
		}
	}
	return _obj;
}

/**
 * 获取jQuery包装过的dom对象
 * 
 * @param obj
 * @returns
 */
function getJqueryDomElement(obj) {
	var value = null;
	if (obj) {
		var type = typeof (obj);
		if ("string" == type) {
			var _obj = jQuery.trim(obj);
			if (_obj.indexOf("#") > -1 || _obj.indexOf(".") > -1
					&& /^\./i.test(_obj) || _obj.indexOf(":") > -1
					|| _obj.indexOf(" ") > -1 || _obj.indexOf("=") > -1
					|| _obj.indexOf("[") > -1) {// 简单判断是否是jQuery选择器
				value = jQuery(_obj);
			} else {
				_obj = _obj.replace(/\./g, '\\.');
				value = jQuery("#" + _obj);
			}
		} else if ("object" == type) {
			if (obj instanceof jQuery) {
				value = obj;
			} else {
				value = jQuery(obj);
			}
		} else if ("function" == type) {
			value = obj();
		}
	}
	return value;
}

/**
 * 获取dom元素值
 * 
 * @param obj
 *            dom元素的id | jQuery选择器 | dom对象 | jQuery对象
 * @returns 没有获取到值时返回null
 */
function getDomElementValue(obj) {
	var value = null;
	if (obj) {
		var type = typeof (obj);
		if ("string" == type) {
			var _obj = jQuery.trim(obj);
			if (_obj.indexOf("#") > -1 || _obj.indexOf(".") > -1
					|| _obj.indexOf(":") > -1 || _obj.indexOf(" ") > -1
					|| _obj.indexOf("=") > -1 || _obj.indexOf("[") > -1) {// 简单判断是否是jQuery选择器

				value = jQuery(_obj).val();
			} else {
				value = jQuery("#" + _obj).val();
			}
		} else if ("object" == type) {
			if (obj instanceof jQuery) {
				value = obj.val();
			} else {
				value = jQuery(obj).val();
			}
		} else if ("function" == type) {
			value = obj();
		}
	}
	return value;
}

/**
 * 获取日期整形字符串
 * 
 * @param date1
 *            日期对象或日期字符串（支持yyyy-mm-dd、yyyy/mm/dd、yyyymmdd）
 * @returns {Date}
 */
function getDateIntStr(date1) {
	var d1 = null;
	if (date1 instanceof Date) {
		var d1 = new Date();
		var month = date1.getMonth() + 1;
		var date = date1.getDate();
		d1 = "" + date1.getFullYear() + (month > 9 ? month : '0' + month)
				+ (date > 9 ? date : '0' + date);
	} else if ("string" == typeof (date1)) {
		if (/^\d{4}-\d{2}-\d{2}$/.test(date1)) {
			d1 = date1.replace(/-/g, "");
		} else if (/^\d{4}\/\d{2}\/\d{2}$/.test(date1)) {
			d1 = date1.replace(/\//g, "");
		} else if (/^\d{8}$/.test(date1)) {
			d1 = date1;
		}
	}
	return d1;
}

/**
 * 比较两个日期
 * 
 * @param date1
 * @param date2
 * @returns {Number} -2:传入了为null的参数，-1:date1 < date2，0:date1 = date2，1:date1 >
 *          date2
 */
function dateCompare(date1, date2) {
	var result = -2;
	if (date1 && date2) {
		var d1 = getDateIntStr(date1);
		var d2 = getDateIntStr(date2);
		if (null != d1 && null != d2) {
			var d1Int = parseInt(d1);
			var d2Int = parseInt(d2);

			if (d1Int > d2Int) {
				result = 1;
			} else if (d1Int == d2Int) {
				result = 0;
			} else {
				result = -1;
			}
		}
	}
	return result;
}
/**
 * 自适应iframe高度
 * 
 * @param iframe
 *            可以是：iframe元素的id | jQuery选择器 | dom对象 | jQuery对象
 */
function autoHeightIFrame(iframe) {
	var jqIFrame = getJqueryDomElement(iframe);

	if (jQuery.browser.chrome) {
		jqIFrame.height(jqIFrame.contents().find("body")[0].scrollHeight + 50);
	} else {
		jqIFrame.height(jqIFrame.contents().find("body")[0].clientHeight + 50);
	}
}
/**
 * 日期格式化
 * 
 * @see yyyy-MM-dd HH:mm:ss
 */
Date.prototype.format = function(mask) {
	var d = this;
	var zeroize = function(value, length) {
		if (!length)
			length = 2;
		value = String(value);
		for (var i = 0, zeros = ''; i < (length - value.length); i++) {
			zeros += '0';
		}
		return zeros + value;
	};
	return mask
			.replace(
					/"[^"]*"|'[^']*'|\b(?:d{1,4}|m{1,4}|yy(?:yy)?|([hHMstT])\1?|[lLZ])\b/g,
					function($0) {
						switch ($0) {
						case 'd':
							return d.getDate();
						case 'dd':
							return zeroize(d.getDate());
						case 'ddd':
							return [ 'Sun', 'Mon', 'Tue', 'Wed', 'Thr', 'Fri',
									'Sat' ][d.getDay()];
						case 'dddd':
							return [ 'Sunday', 'Monday', 'Tuesday',
									'Wednesday', 'Thursday', 'Friday',
									'Saturday' ][d.getDay()];
						case 'M':
							return d.getMonth() + 1;
						case 'MM':
							return zeroize(d.getMonth() + 1);
						case 'MMM':
							return [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
									'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' ][d
									.getMonth()];
						case 'MMMM':
							return [ 'January', 'February', 'March', 'April',
									'May', 'June', 'July', 'August',
									'September', 'October', 'November',
									'December' ][d.getMonth()];
						case 'yy':
							return String(d.getFullYear()).substr(2);
						case 'yyyy':
							return d.getFullYear();
						case 'h':
							return d.getHours() % 12 || 12;
						case 'hh':
							return zeroize(d.getHours() % 12 || 12);
						case 'H':
							return d.getHours();
						case 'HH':
							return zeroize(d.getHours());
						case 'm':
							return d.getMinutes();
						case 'mm':
							return zeroize(d.getMinutes());
						case 's':
							return d.getSeconds();
						case 'ss':
							return zeroize(d.getSeconds());
						case 'l':
							return zeroize(d.getMilliseconds(), 3);
						case 'L':
							var m = d.getMilliseconds();
							if (m > 99)
								m = Math.round(m / 10);
							return zeroize(m);
						case 'tt':
							return d.getHours() < 12 ? 'am' : 'pm';
						case 'TT':
							return d.getHours() < 12 ? 'AM' : 'PM';
						case 'Z':
							return d.toUTCString().match(/[A-Z]+$/);
						default:
							return $0.substr(1, $0.length - 2);
						}
					});
};
function toUtf8(str) {
	var out, i, len, c;
	out = "";
	len = str.length;
	for (i = 0; i < len; i++) {
		c = str.charCodeAt(i);
		if ((c >= 0x0001) && (c <= 0x007F)) {
			out += str.charAt(i);
		} else if (c > 0x07FF) {
			out += String.fromCharCode(0xE0 | ((c >> 12) & 0x0F));
			out += String.fromCharCode(0x80 | ((c >> 6) & 0x3F));
			out += String.fromCharCode(0x80 | ((c >> 0) & 0x3F));
		} else {
			out += String.fromCharCode(0xC0 | ((c >> 6) & 0x1F));
			out += String.fromCharCode(0x80 | ((c >> 0) & 0x3F));
		}
	}
	return out;
}

//是否为空("",null,undefined)
function isEmpty(strVal) {
	if (strVal == '' || strVal == null || strVal == undefined) {
		return true;
	} else {
		return false;
	}
}
function isNumber(v){
	return typeof v === 'number' && isFinite(v);
}

function ChangeEmptyToStr(value){
	if(isEmpty(value)){
		value = '';
	}
	return value;
}

/*
 * 深层copy(object)
 */
function DeepClone(source){
	const targetObj = source.constructor === Array ? [] : {};		// 判断复制的目标是数组还是对象
	for(var keys in source){
		if(source.hasOwnProperty(keys)){
			if(source[keys] && typeof source[keys] === 'object'){
				//如果值是对象，就递归一下
				targetObj[keys] = source[keys].constructor === Array ? [] : {};
				targetObj[keys] = DeepClone(source[keys]);
			}else{
				//如果不是，就直接赋值
				targetObj[keys] = source[keys];
			}
		}
	}
	return targetObj;
}

//显示隐藏遮罩层
function showMask(){
	$.busyLoadFull("show",{text: "处理中请稍后 ...", background: "rgba(51,153,255, 0.7)", animate: "slide" });
}
//隐藏遮罩层
function hideMask(){
	$.busyLoadFull("hide", { animate: "fade" });
}
/**combo Formatter
 * 用于Grid列  combo渲染
 * @param {} combo
 * @param {} valueField
 * @param {} textField
 * @return {}
 * ps: 因EasyUI-editor的处理方式, 界面formatter建议通过如下方式进行(...单选...):
 * 		1.editor-combo定义,data属性同步方法获取数据;
 * 		2.editor-combo的onSelect事件中,设置当前编辑行中对应textField的字段值
 */ 
function CommonFormatter(combo,valueField,textField,DataGrid){
	if(typeof textField == 'undefined'){
		//仅按RowId进行combo-fammatter
		return function(value,row,index){
			var FindIndex = -1;
			try{
				var ComboData = combo.options.data;
				for (var i = 0, Len = ComboData.length; i < Len; i++) {
					if (ComboData[i][combo.options.valueField] == value) {
						FindIndex = i;
						break;
					}
				}
			}catch(e){}
			return (FindIndex != -1)? combo.options.data[FindIndex][combo.options.textField] : '';
		}
	}else{
		return function(value,row,index){
			if(isEmpty(value)){
				return '';
			}

			var ComboData = combo.options.data;
			var ComboValueField = combo.options.valueField;
			var ComboTextField = combo.options.textField;
			if(!isEmpty(ComboData)){
				for (var i = 0, Len = ComboData.length; i < Len; i++){
					if (ComboData[i][ComboValueField] == value) {
						row[textField]=ComboData[i][ComboTextField];
						break;
					}
				}
			}
			//通过Row里的textField
			if(row[textField]) {
				return row[textField];
			}
			return value;
		}
	}
}

/*
 * 布尔类型Formatter: 统一使用"是","否"
 */
function BoolFormatter(value, row, index){
	var FormatValue = value;
	var ValueStr = isEmpty(value)? '' : (value + '');
	if((ValueStr == 'Y') || (ValueStr == '1')){
		FormatValue = '是';
	}else if((ValueStr == 'N') || (ValueStr == '0')){
		FormatValue = '否';
	}
	return FormatValue;
}
/**全局变量
*日期格式定义
* 获取系统日期格式配置
*    1 MM/DD/YYYY
*    3 YYYY-MM-DD
*    4 DD/MM/YYYY
*/    
var ARG_DATEFORMAT=tkMakeServerCall('websys.Conversions', 'DateFormat');
/**转换日期格式
 * fillblock 中使用
 */
function FormatDate(date){
	if(isEmpty(date))
	{
		return '';
	}
	var y,m,d
	var date=date.toString()
	///Y-m-d
	if((date.indexOf("-")!=-1)){
		y=date.split("-")[0];
		m=date.split("-")[1]-1;
		d=date.split("-")[2];
	}else if(ARG_DATEFORMAT==1){
		y=date.split("/")[2];
		m=date.split("/")[0]-1;
		d=date.split("/")[1];
	}else{
		y=date.split("/")[2];
		m=date.split("/")[1]-1;
		d=date.split("/")[0];
	}
	return new Date(y,m,d);
}

/**
 * 时间间隔计算
 * @param {时间对象} date
 * @param {要添加的时间间隔} interval
 * @param {要添加的时间间隔的个数} number
 * @return {新的时间对象}
 */
function DateAdd(date,interval,number){
	switch(interval){
	case "y": 
		date.setFullYear(date.getFullYear()+number);
		return date;
		break;
	case "q":
		date.setMonth(date.getMonth()+number*3);
		return date;
		break;
	case "m":
		date.setMonth(date.getMonth()+number);
		return date;
		break;
	case "w":
		date.setDate(date.getDate()+number*7);
		return date;
		break;
	case "d":
		date.setDate(date.getDate()+number);
		return date;
		break;
	case "h":
		date.setHours(date.getHours()+number);
		return date;
		break;
	case "m":
		date.setMinutes(date.getMinutes()+number);
		return date;
		break;
	case "s":
		date.setSeconds(date.getSeconds()+number);
		return date;
		break;
	default:
		date.setDate(d.getDate()+number);
		return date;
		break;
	}
}

DateFormatter = $.fn.datebox.defaults.formatter;

/**全局变量session
 * 
 */
var gGroupId = session['LOGON.GROUPID'];
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gHospId = session['LOGON.HOSPID'];
var gLocObj = {RowId: gLocId, Description: gLocDesc};	//缺省登录科室的object
var gSessionStr = gUserId +"^"+ gGroupId +"^"+ gLocId +"^"+ gHospId;
/**session对象
 */
var sessionObj={gUserId:session['LOGON.USERID'],gLocId:session['LOGON.CTLOCID'],gGroupId:session['LOGON.GROUPID'],gHospId:session['LOGON.HOSPID']}

/**添加session参数到参数对象
 * @param {} obj
 * @return {} 添加session的obj
 */
function addSessionParams(obj){
	var _options={}
	_options=jQuery.extend(true,_options,obj,sessionObj);
	return _options
}

/**
 * 获取当前模块的参数值(object格式), 参数值 = PropValueObj.参数名称
 * @param {} AppName
 * @param {} LocId
 * @return {} 参数值的object格式数据
 */
function GetAppPropValue(AppName, LocId){
	if(isEmpty(LocId)){
		var LocId = session['LOGON.CTLOCID'];
	}
	var LogUser= session['LOGON.USERID'];
	var LogGroup= session['LOGON.GROUPID'];
	var Param=LogGroup+"^"+LocId+"^"+LogUser;
	var PropValueObj = $.cm({
		ClassName:"web.DHCSTMHUI.Common.AppCommon",
		MethodName:"GetAppPropStr",
		AppName:AppName,
		Param:Param
	},false);
	return PropValueObj;
}

function AddComboData(Combo, Value, Text){
	var ComboData = Combo.combobox('getData');
	var ValueField = Combo.combobox('options').valueField, TextField = Combo.combobox('options').textField;
	var Len = ComboData.length;
	for(var i = 0; i < Len; i++){
		if(ComboData[i][ValueField] == Value){
			return;
		}
	}
	var DataObjStr = "{" + ValueField + ":'" + Value + "'," + TextField + ":'" + Text + "'}";
	var DataObj = eval("(" + DataObjStr + ")");
	ComboData[ComboData.length] = DataObj;
	Combo.combobox('loadData', ComboData);
}

/**
 * 改造成显示打印需调用的字符串
 * @param {String} str: 直接打印的润乾命令字符串
 * TranslateRQStr("{a.raq(a1=b1;a2=b2;a3=b3;a4=b4)}")
 */
function TranslateRQStr(str){
	var rqReg = /^\{.+\.raq\((.+\=.*)(;.+\=.*)*\)\}$/;
	if(!rqReg.test(str)){
		return;
	}
	str = str.substring(1,str.length-1);
	var raqNameIndex = str.indexOf(".raq(")+4;
	var raqName = str.substring(0,raqNameIndex);
	var parStr = str.substring(raqNameIndex+1,str.length-1)
	var newParStr = parStr.replace(/;/g,"&");
	var newStr = raqName+"&"+newParStr;
	return newStr;
}
/**
 * 公用单据打印记录(打印后调用)
 * @param {类型} Type
 * @param {主表rowid} Pointer
 * @param {自动打印标志} AutoFlag
 * @return {打印结果} 0:成功, <0:失败
 */
function Common_PrintLog(Type, Pointer, AutoFlag,PrintNum){
	PrintNum = typeof(PrintNum)=='undefined'? '1' : PrintNum;
	var Ret = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'BillPrintLog', Type, Pointer, AutoFlag, gUserId,PrintNum);
	if(Ret !== '0'){
		Msg.info('warning', '单据打印日志记录失败!');
	}
	return Ret;
}

/**
 * 获取打印模式:
 * 获取打印模式:
 * @param {科室rowid} LocId
 * @param {类组rowid} ScgId
 * @return {String}
 */
function GetPrintMode(LocId,ScgId){
	if(LocId==''){
		return '';
	}
	var PrintMode = $.m({
		ClassName: 'web.DHCSTMHUI.CTLOC',
		MethodName: 'GetModByLocScg',
		LocId: LocId,
		ScgId: ScgId
	},false);
	return PrintMode;
}

/**
 * 改造成显示打印需调用的字符串
 * @param {String} str: 直接打印的润乾命令字符串
 * TranslateRQStr("{a.raq(a1=b1;a2=b2;a3=b3;a4=b4)}")
 */
function TranslateRQStr(Str){
	var RaqReg = /^\{.+\.raq\((.+\=.*)(;.+\=.*)*\)\}$/;
	if(!RaqReg.test(Str)){
		$UI.msg('alert','润乾表达式错误, 请核实!', 'warning');
		return;
	}
	Str = Str.substring(1,Str.length-1);
	var RaqNameIndex = Str.indexOf(".raq(")+4;
	var RaqName = Str.substring(0,RaqNameIndex);
	var ParStr = Str.substring(RaqNameIndex+1,Str.length-1)
	var NewParStr = ParStr.replace(/;/g,"&");
	var NewStr = RaqName+"&"+NewParStr;
	return NewStr;
}

/**
 * 润乾预览打印
 * @param {} parameter(raq参数串, 窗口宽度, 窗口高度)
 */
function DHCSTM_DHCCPM_RQPrint(parameter) {
	var args = arguments.length
	//var width = gWinWidth;
	//var height= gWinHeight;
	var width = 600;
	var height = 500;
	var parm = ""
	if(args>=1){
		if (arguments[0]==""){
			$UI.msg('alert',"请输入报表名称和报表参数");
			return;
		}
		parm=arguments[0];
	}
	if(args>=2){
		if(arguments[1]!=""){
			width=arguments[1];
		}
	}
	if(args>=3){
		if(arguments[2]!=""){
			height=arguments[2];
		}
	}
	DHCCPM_RQPrint(parm,width,height)
}

 //返回取备注类型字段时，备注行之间的设定分隔符 ;
function xMemoDelim() 
{
	var realkey  = String.fromCharCode(3);  
	return ";"; //realkey;
}

//对后台返回的备注字段加以处理-即使用回车换行符 $c(13,10) 替换$c(3)
function handleMemo(memo,token) 
{
	var xx='';
	var ss=memo.split(token);
	for (var i=0;i<ss.length;i++)
	{
		if (xx=='') {xx=ss[i];}
		else{
			xx=xx+'\n'+ss[i];
		}
	}
	return xx;
}

function banBackSpace(e) {
	var ev=e||window.event;
	//获取event对象
	var obj=ev.target||ev.srcElement;
	//获取事件源
	var t=obj.type||obj.getAttribute('type');
	//获取事件源类型
	//获取作为判断条件的事件类型
	var vReadOnly=obj.readOnly;
	var vDisabled=obj.disabled;
	//处理undefined值情况
	vReadOnly=(vReadOnly==undefined)?false:vReadOnly;
	vDisabled=(vDisabled==undefined)?true:vDisabled;
	//当敲Backspace键时，事件源类型为密码或单行、多行文本的，
	//并且readOnly属性为true或disabled属性为true的，则退格键失效
	var flag1=ev.keyCode==8&&(t=="password"||t=="text"||t=="textarea")&&(vReadOnly==true||vDisabled==true);
	//当敲Backspace键时，事件源类型非密码或单行、多行文本的，则退格键失效
	var flag2=ev.keyCode==8&&t!="password"&&t!="text"&&t!="textarea";
	//判断
	if(flag2||flag1)return false;
}
//禁止退格键 作用于Firefox、Opera
document.onkeypress=banBackSpace;
//禁止退格键 作用于IE、Chrome
document.onkeydown=banBackSpace;

/*2018-7-4
 * xuchao
 * grid 导出
 * */
function ExportExcel(data,cm){
	//处理cm隐藏 checkbox
	var cmafter=[];
	for(var i=0; i<cm.length; i++){
		var obj = cm[i];
		if(obj.checkbox||obj.hidden){
			continue;
		}
		cmafter.push(obj);
	}
	var exceldata=[];
	var rowobj=[];
	var rowslen=data.length;
	
	var TableHtml = "<div><table id='ExportDataGrid'><tr>";
	//Excel第一行存放标题
	for (var n=0;n<cmafter.length;n++){
		var reTag = /<(?:.|\s)*?>/g;
		var HeaderTitle = cmafter[n].title.replace(reTag,"");
		rowobj.push(HeaderTitle);
		TableHtml += "<td style='vnd.ms-excel.numberformat:@'>" + HeaderTitle + "</td>";
	}
	exceldata.push(rowobj);
	TableHtml += '</tr>';
	
	for (var k=0;k<rowslen;k++){
		TableHtml += "<tr>";
		var Record=data[k];
		rowobj=[];
		for (var j=0;j<cmafter.length;j++){
			var colDataIndex=cmafter[j].field;
			var colRenderer = cmafter[j].formatter;
			var cellValue=Record[colDataIndex];
			if(!isEmpty(colRenderer)&&colRenderer.toString().replace(/\s/g,'')!="function(value){returnvalue;}"
			&& cmafter[j].checkbox!==true){
				var cellValue = cmafter[j].formatter(cellValue,Record,k);
			}
			//var regExpPattern=/^(-?\d*)(\.?\d*)$/;
			//if(cellValue!="" && regExpPattern.test(cellValue)){
				//rowobj.push("\'"+cellValue);
			//}else{
				rowobj.push(cellValue);
			//}
			TableHtml += "<td style='vnd.ms-excel.numberformat:@'>" + cellValue + "</td>";
		}
		TableHtml += "</tr>";
		exceldata.push(rowobj);
	}
	TableHtml += "</table></div>";
	$(document.body).append(TableHtml);
	
	//'ExportDataGrid'该id用于chrome等浏览器; exceldata用于IE11
	ExportUtil.toExcel('ExportDataGrid', exceldata, new Date().getTime()+"新导出文件.xls");
}
/**
 * 判断业务单据是否高值单
 * @param {主表rowid} Pointer
 * @param {类型} Type
 * @return {判断结果} Y:高值单, 否则:低值单
 */
function GetCertDocHVFlag(Pointer, Type){
	var Ret = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'GetCertDocHVFlag',Pointer, Type);
	return Ret;
}
/*cm 处理中调用 
 * 查找cm 中的 obj
 * 匹配 field
 */
var FindCmObj=function(_cm,field){
	var len=_cm.length
	for(var i=0;i<len;i++){
		if(_cm[i].field==field){
		 return _cm[i];
		};
	}
	return {};
}

/**
 * 菜单跳转后,href中可能传递一些变量
 * 此方法在清空过程后方调用
 * 改动location后界面会重新加载
 * 20200512 增加value变量值，变量使用后置为空
 */
function CheckLocationHref(value){
	var pathname = location.pathname;
	var search = location.search;
	var mainmenuflag = (pathname.indexOf('dhcstmhui.menu.csp') != -1 || pathname.indexOf('dhcstm.menu.csp') != -1)
		? true : false;
	var websysflag = pathname.indexOf('websys.csp') != -1? true : false;

	//dhcstmhui.menu.csp是侧菜单模式用到的
	//websys.csp是头菜单模式用到的
	//若为界面跳转的菜单,使用的是明文csp(诸如dhcstm.ingdrec.csp)

	if((!mainmenuflag && !websysflag) && (search!="")&&(value=="")){
		location.search = "";
	}
}

/**
 * 控制按钮是否可用
 * @param {} Obj: 比如 {'#SearchBT':true, '#SaveBT':false}
 */
function ChangeButtonEnable(Obj) {
	for(var Btn in Obj){
		var IsEnable = Obj[Btn] == true ? 'enable' : 'disable';
		$(Btn).linkbutton(IsEnable);
		if(isEmpty(ButtonCountObj[Btn])){
			ButtonCountObj[Btn]=1;
		}else{
			ButtonCountObj[Btn]=ButtonCountObj[Btn]+1;
		}
	}
}
/**
 * 重新命名列的field,追加
 */
function changefieldval(rowsData,columns)
{
	if((isEmpty(rowsData))||(isEmpty(columns))||(rowsData.length<=0)){
		return;
	}
	var arrData=[];
	for(var i=0; i<rowsData.length; i++){
		var row = rowsData[i];
		var tmprow=row;
		for (var col in columns[0]){
			if(!isEmpty(columns[0][col].alias)){
				var field=columns[0][col].field;
				var Alias=columns[0][col].alias;
				var AddRowObj={};
				AddRowObj[Alias]=row[field];
				tmprow=$.extend(tmprow,AddRowObj);
			}
		}
		arrData.unshift(tmprow);
	}
	return arrData;
}

/**
 * datagrid行染色方法
 * @param {gridObj} Grid
 * @param {行索引} RowIndex
 * @param {列名称,需具备唯一性} Field
 * @param {颜色} Color
 * @param {要染色的列名称} ColorField, 不设置时整行染色
 */
function SetGridBgColor(Grid, RowIndex, Field, Color, ColorField){
	var RowId = Grid.getRows()[RowIndex][Field];
	var Panel =  Grid.getPanel();
	var trs = Panel.find('div.datagrid-body tr');
	trs.each(function(i, tr){
		var td = $(this).children('td[field="' + Field + '"]');		// 取出行中
		var TextValue = td.children('div').text();				// 取出该列的值
		if(TextValue == RowId){
			if(!isEmpty(ColorField)){
				var ColorTd = $(this).children('td[field="'+ColorField+'"]');
				ColorTd.css({'background-color': Color});
			}else{
				$(tr).css({'background-color': Color});
			}
			return false;
		}
	});
}

/**
 * 修改datagrid行(格子)样式
 * @param {gridObj} Grid
 * @param {行索引} RowIndex
 * @param {列名称,需具备唯一性} Field
 * @param {要设置的列名称,为空时处理整行} ColorField
 * @param {样式名称,第一个字符为加号或者减号} OperateCss
 * 		比如 .ClassRed:{color:red;}, 这里入参OperateCss可以为+ClassRed或者-ClassRed
 */
function SetGridCss(Grid, RowIndex, Field, ColorField, OperateCss){
	var AddDelType = OperateCss.charAt(0);
	var Css = OperateCss;
	if(AddDelType == '+' || AddDelType == '-'){
		Css = OperateCss.substring(1, OperateCss.length);
	}else{
		AddDelType = '+';
	}
	var RowId = Grid.getRows()[RowIndex][Field];
	var Panel =  Grid.getPanel();
	var trs = Panel.find('div.datagrid-body tr');
	trs.each(function(i, tr){
		var td = $(this).children('td[field="' + Field + '"]');		// 取出行中
		var TextValue = td.children('div').text();				// 取出该列的值
		if(TextValue == RowId){
			if(!isEmpty(ColorField)){
				var ColorTd = $(this).children('td[field="'+ColorField+'"]');
				if(AddDelType == '+'){
					ColorTd.addClass(Css);
				}else{
					ColorTd.removeClass(Css);
				}
			}else{
				if(AddDelType == '+'){
					$(tr).addClass(Css);
				}else{
					$(tr).removeClass(Css);
				}
			}
			return false;
		}
	});
}

///XuChao
///20181120
///重新设置高度
///layout border  调整south或者north
function ResetHeight(){
	var c=$("body");
	var h=$(window).height()*0.4;
	var pn=$("body").layout('panel','north');
	var ps=$("body").layout('panel','south'); 
	var p="";
	var pnFlag=$("table:empty",pn);
	var psFlag=$("table:empty",ps);
	if(pn[0]&&pnFlag.length){p=pn;}
	else if(ps[0]&&psFlag.length){p=ps;}
	if(p==""){return;};
	var oldHeight=p.panel('panel').outerHeight(); //获得panel 的原高度
	p.panel('resize',{height:h}); //设置 panel 新高度
	var newHeight=p.panel('panel').outerHeight();
	c.layout('resize',{height:c.height()+newHeight-oldHeight});  //重新设置整个布局的高度
}
///文档加载完成后 调整
$(
	function(){
		ResetHeight();
	}
)

/**
 * 查询小数位数
 * FmtType - 参数名称
 */
function GetFmtNum(FmtType){
	var FmtDecLen = tkMakeServerCall("web.DHCSTMHUI.Util.DrugUtil", "DecLenByFmtType", FmtType, gHospId);
	return FmtDecLen;
}

/**
 * 补零
 * inputNum - 原数据
 * numLength - 数据长度
 */
function NumZeroPadding(inputNum, numLength) {
	if (inputNum == "") {
		return inputNum;
	}
	var inputNumLen = inputNum.length;
	if (inputNumLen > numLength) {
		Msg.info("warning", "输入错误!");
		return;
	}
	for (var i = 1; i <= numLength - inputNumLen; i++) {
		inputNum = "0" + inputNum;
	}
	return inputNum;
}
/**
 *类组参数医院ID
 */
function setStkGrpHospid(HospId) {
	StkGrpHospid=HospId;
}

/**
 * 主界面添加页签-公用方法
 * @param {标题} Title: 此字段简明扼要即可,方法中可根据csp后台获取
 * @param {url地址} URL
 */
function Common_AddTab(Title, URL){
	if(URL.indexOf('dhcstmhui.menu.csp') == -1){
		var CspName = URL.split('?')[0];
		if(!isEmpty(CspName)){
			var MenuArr = $.cm({
				ClassName: 'web.DHCSTMHUI.Common.UtilCommon',
				MethodName: 'GetMenuInfoByCsp',
				CspName: CspName
			}, false);
			var Caption = MenuArr['Caption'];
			if(!isEmpty(Caption)){
				Title = Caption;			//根据csp获取菜单名称
			}
		}
	}
	window.parent.addTab(Title, URL);
}
