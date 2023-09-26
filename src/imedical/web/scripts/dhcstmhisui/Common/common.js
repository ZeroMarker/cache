/**����js����
 */
var PmRunQianUrl = "dhccpmrunqianreport.csp";   //��Ǭ�������dhcstm.pmrunqianreport.csp �̶�toolbar��dhccpmrunqianreport.csp����˾�汾
var CommParObj=GetAppPropValue("DHCSTCOMMONM");
var App_MenuCspName=TRELOADPAGE;
var FormBlockJson={};
var FormMustInput=[];
var ButtonCountObj={};
var gWinWidth = $(window).width() * 0.9;	//Ĭ�ϵ������ڵĿ�ȸ߶�,��Ӧ��ǰ���ڵĴ�С
var gWinHeight = $(window).height() * 0.9;
var gGridHeight = $(window).height() * 0.6;
var PrintMethod=1;  //��ͨ���ݴ�ӡ��ʽ 0-Lodop 1-RQ
var HVBarcodePrintMethod=0;  //��ֵ�����ӡ��ʽ 0-Lodop 1-XML(֧��IE)
var StkGrpHospid="";
/**
 * Ϊstring���startWith����
 * @param str
 * @returns
 */
String.prototype.startWith = function(str) {
	var regexp = eval("/^" + str + "/");
	return regexp.test(this);
};
/**
 * Ϊstring���leftPad����
 * @param str
 * @returns
 */
leftPad = function (str,paddingChar,len) {
        if (str.length < len) { for (; str.length < len; str = paddingChar + str) { } }
        return str;
    };
 String.prototype.leftPad = function (paddingChar,len) { return leftPad(this, paddingChar,len); };

/**
 * ��ȡ����
 * 
 * @param expr
 *            ���ʽ���������ַ��������ڱ��ʽ�������֣�����ֵ��������Date��
 * @param delimiter
 *            ������exprΪ�ַ���ʱ�˲�����Ч��
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
 * �Ƚ���������
 * 
 * @param date1
 *            ���ʽ���������ַ��������ڱ��ʽ�������֣�����ֵ��������Date��
 * @param date2
 *            ���ʽ���������ַ��������ڱ��ʽ�������֣�����ֵ��������Date��
 * @returns true: date1 > date2, false: date1 < date2, null:
 *          date1��date2����һ����Ч�����ڱ��ʽ
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
 * ����������������������������������ڲ���ǰ��
 * 
 * @param date1
 *            �������ַ�����yyyy-mm-dd�������֡���Date
 * @param date2
 *            �������ַ�����yyyy-mm-dd�������֡���Date
 * @param delimiter
 *            ���ڵķָ�����Ĭ��Ϊ��-��
 * @returns ��������������������
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
 * �����ڸ�ʽ��
 * 
 * @param date
 *            ����
 * @param delimiter
 *            �ָ�������ѡ��Ĭ��Ϊ��-��
 * @returns ������ʽ�硰yyyy-mm-dd���ĸ�ʽ
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
 * ��ȡ��ǩ������class�ϵ�����ֵ
 * 
 * @param obj
 *            ����dom����|jQuery����|��ǩid��
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
					+ "\\s*?=\\s*?([^\\]]*)\\s*?\\]/");// ��̬������ʽ
			var matches = _obj.className.match(regex);
			if (matches) {
				result = matches[1];
			}
		}
	}
	return result;
}

/**
 * �ڱ�ǩ��class���Զ������ԣ�class����ӱ��ʽ��ʽ��[p=pvalue]����
 * 
 * @param obj
 *            ����dom����|jQuery����|��ǩid��
 * @param propertyName
 *            ������
 * @param propertyValue
 *            ����ֵ
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
 * ��ȡjQuery��װ����dom����
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
					|| _obj.indexOf("[") > -1) {// ���ж��Ƿ���jQueryѡ����
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
 * ��ȡdomԪ��ֵ
 * 
 * @param obj
 *            domԪ�ص�id | jQueryѡ���� | dom���� | jQuery����
 * @returns û�л�ȡ��ֵʱ����null
 */
function getDomElementValue(obj) {
	var value = null;
	if (obj) {
		var type = typeof (obj);
		if ("string" == type) {
			var _obj = jQuery.trim(obj);
			if (_obj.indexOf("#") > -1 || _obj.indexOf(".") > -1
					|| _obj.indexOf(":") > -1 || _obj.indexOf(" ") > -1
					|| _obj.indexOf("=") > -1 || _obj.indexOf("[") > -1) {// ���ж��Ƿ���jQueryѡ����

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
 * ��ȡ���������ַ���
 * 
 * @param date1
 *            ���ڶ���������ַ�����֧��yyyy-mm-dd��yyyy/mm/dd��yyyymmdd��
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
 * �Ƚ���������
 * 
 * @param date1
 * @param date2
 * @returns {Number} -2:������Ϊnull�Ĳ�����-1:date1 < date2��0:date1 = date2��1:date1 >
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
 * ����Ӧiframe�߶�
 * 
 * @param iframe
 *            �����ǣ�iframeԪ�ص�id | jQueryѡ���� | dom���� | jQuery����
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
 * ���ڸ�ʽ��
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

//�Ƿ�Ϊ��("",null,undefined)
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
 * ���copy(object)
 */
function DeepClone(source){
	const targetObj = source.constructor === Array ? [] : {};		// �жϸ��Ƶ�Ŀ�������黹�Ƕ���
	for(var keys in source){
		if(source.hasOwnProperty(keys)){
			if(source[keys] && typeof source[keys] === 'object'){
				//���ֵ�Ƕ��󣬾͵ݹ�һ��
				targetObj[keys] = source[keys].constructor === Array ? [] : {};
				targetObj[keys] = DeepClone(source[keys]);
			}else{
				//������ǣ���ֱ�Ӹ�ֵ
				targetObj[keys] = source[keys];
			}
		}
	}
	return targetObj;
}

//��ʾ�������ֲ�
function showMask(){
	$.busyLoadFull("show",{text: "���������Ժ� ...", background: "rgba(51,153,255, 0.7)", animate: "slide" });
}
//�������ֲ�
function hideMask(){
	$.busyLoadFull("hide", { animate: "fade" });
}
/**combo Formatter
 * ����Grid��  combo��Ⱦ
 * @param {} combo
 * @param {} valueField
 * @param {} textField
 * @return {}
 * ps: ��EasyUI-editor�Ĵ���ʽ, ����formatter����ͨ�����·�ʽ����(...��ѡ...):
 * 		1.editor-combo����,data����ͬ��������ȡ����;
 * 		2.editor-combo��onSelect�¼���,���õ�ǰ�༭���ж�ӦtextField���ֶ�ֵ
 */ 
function CommonFormatter(combo,valueField,textField,DataGrid){
	if(typeof textField == 'undefined'){
		//����RowId����combo-fammatter
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
			//ͨ��Row���textField
			if(row[textField]) {
				return row[textField];
			}
			return value;
		}
	}
}

/*
 * ��������Formatter: ͳһʹ��"��","��"
 */
function BoolFormatter(value, row, index){
	var FormatValue = value;
	var ValueStr = isEmpty(value)? '' : (value + '');
	if((ValueStr == 'Y') || (ValueStr == '1')){
		FormatValue = '��';
	}else if((ValueStr == 'N') || (ValueStr == '0')){
		FormatValue = '��';
	}
	return FormatValue;
}
/**ȫ�ֱ���
*���ڸ�ʽ����
* ��ȡϵͳ���ڸ�ʽ����
*    1 MM/DD/YYYY
*    3 YYYY-MM-DD
*    4 DD/MM/YYYY
*/    
var ARG_DATEFORMAT=tkMakeServerCall('websys.Conversions', 'DateFormat');
/**ת�����ڸ�ʽ
 * fillblock ��ʹ��
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
 * ʱ��������
 * @param {ʱ�����} date
 * @param {Ҫ��ӵ�ʱ����} interval
 * @param {Ҫ��ӵ�ʱ�����ĸ���} number
 * @return {�µ�ʱ�����}
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

/**ȫ�ֱ���session
 * 
 */
var gGroupId = session['LOGON.GROUPID'];
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gHospId = session['LOGON.HOSPID'];
var gLocObj = {RowId: gLocId, Description: gLocDesc};	//ȱʡ��¼���ҵ�object
var gSessionStr = gUserId +"^"+ gGroupId +"^"+ gLocId +"^"+ gHospId;
/**session����
 */
var sessionObj={gUserId:session['LOGON.USERID'],gLocId:session['LOGON.CTLOCID'],gGroupId:session['LOGON.GROUPID'],gHospId:session['LOGON.HOSPID']}

/**���session��������������
 * @param {} obj
 * @return {} ���session��obj
 */
function addSessionParams(obj){
	var _options={}
	_options=jQuery.extend(true,_options,obj,sessionObj);
	return _options
}

/**
 * ��ȡ��ǰģ��Ĳ���ֵ(object��ʽ), ����ֵ = PropValueObj.��������
 * @param {} AppName
 * @param {} LocId
 * @return {} ����ֵ��object��ʽ����
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
 * �������ʾ��ӡ����õ��ַ���
 * @param {String} str: ֱ�Ӵ�ӡ����Ǭ�����ַ���
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
 * ���õ��ݴ�ӡ��¼(��ӡ�����)
 * @param {����} Type
 * @param {����rowid} Pointer
 * @param {�Զ���ӡ��־} AutoFlag
 * @return {��ӡ���} 0:�ɹ�, <0:ʧ��
 */
function Common_PrintLog(Type, Pointer, AutoFlag,PrintNum){
	PrintNum = typeof(PrintNum)=='undefined'? '1' : PrintNum;
	var Ret = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'BillPrintLog', Type, Pointer, AutoFlag, gUserId,PrintNum);
	if(Ret !== '0'){
		Msg.info('warning', '���ݴ�ӡ��־��¼ʧ��!');
	}
	return Ret;
}

/**
 * ��ȡ��ӡģʽ:
 * ��ȡ��ӡģʽ:
 * @param {����rowid} LocId
 * @param {����rowid} ScgId
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
 * �������ʾ��ӡ����õ��ַ���
 * @param {String} str: ֱ�Ӵ�ӡ����Ǭ�����ַ���
 * TranslateRQStr("{a.raq(a1=b1;a2=b2;a3=b3;a4=b4)}")
 */
function TranslateRQStr(Str){
	var RaqReg = /^\{.+\.raq\((.+\=.*)(;.+\=.*)*\)\}$/;
	if(!RaqReg.test(Str)){
		$UI.msg('alert','��Ǭ���ʽ����, ���ʵ!', 'warning');
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
 * ��ǬԤ����ӡ
 * @param {} parameter(raq������, ���ڿ��, ���ڸ߶�)
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
			$UI.msg('alert',"�����뱨�����ƺͱ������");
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

 //����ȡ��ע�����ֶ�ʱ����ע��֮����趨�ָ��� ;
function xMemoDelim() 
{
	var realkey  = String.fromCharCode(3);  
	return ";"; //realkey;
}

//�Ժ�̨���صı�ע�ֶμ��Դ���-��ʹ�ûس����з� $c(13,10) �滻$c(3)
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
	//��ȡevent����
	var obj=ev.target||ev.srcElement;
	//��ȡ�¼�Դ
	var t=obj.type||obj.getAttribute('type');
	//��ȡ�¼�Դ����
	//��ȡ��Ϊ�ж��������¼�����
	var vReadOnly=obj.readOnly;
	var vDisabled=obj.disabled;
	//����undefinedֵ���
	vReadOnly=(vReadOnly==undefined)?false:vReadOnly;
	vDisabled=(vDisabled==undefined)?true:vDisabled;
	//����Backspace��ʱ���¼�Դ����Ϊ������С������ı��ģ�
	//����readOnly����Ϊtrue��disabled����Ϊtrue�ģ����˸��ʧЧ
	var flag1=ev.keyCode==8&&(t=="password"||t=="text"||t=="textarea")&&(vReadOnly==true||vDisabled==true);
	//����Backspace��ʱ���¼�Դ���ͷ�������С������ı��ģ����˸��ʧЧ
	var flag2=ev.keyCode==8&&t!="password"&&t!="text"&&t!="textarea";
	//�ж�
	if(flag2||flag1)return false;
}
//��ֹ�˸�� ������Firefox��Opera
document.onkeypress=banBackSpace;
//��ֹ�˸�� ������IE��Chrome
document.onkeydown=banBackSpace;

/*2018-7-4
 * xuchao
 * grid ����
 * */
function ExportExcel(data,cm){
	//����cm���� checkbox
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
	//Excel��һ�д�ű���
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
	
	//'ExportDataGrid'��id����chrome�������; exceldata����IE11
	ExportUtil.toExcel('ExportDataGrid', exceldata, new Date().getTime()+"�µ����ļ�.xls");
}
/**
 * �ж�ҵ�񵥾��Ƿ��ֵ��
 * @param {����rowid} Pointer
 * @param {����} Type
 * @return {�жϽ��} Y:��ֵ��, ����:��ֵ��
 */
function GetCertDocHVFlag(Pointer, Type){
	var Ret = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'GetCertDocHVFlag',Pointer, Type);
	return Ret;
}
/*cm �����е��� 
 * ����cm �е� obj
 * ƥ�� field
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
 * �˵���ת��,href�п��ܴ���һЩ����
 * �˷�������չ��̺󷽵���
 * �Ķ�location���������¼���
 * 20200512 ����value����ֵ������ʹ�ú���Ϊ��
 */
function CheckLocationHref(value){
	var pathname = location.pathname;
	var search = location.search;
	var mainmenuflag = (pathname.indexOf('dhcstmhui.menu.csp') != -1 || pathname.indexOf('dhcstm.menu.csp') != -1)
		? true : false;
	var websysflag = pathname.indexOf('websys.csp') != -1? true : false;

	//dhcstmhui.menu.csp�ǲ�˵�ģʽ�õ���
	//websys.csp��ͷ�˵�ģʽ�õ���
	//��Ϊ������ת�Ĳ˵�,ʹ�õ�������csp(����dhcstm.ingdrec.csp)

	if((!mainmenuflag && !websysflag) && (search!="")&&(value=="")){
		location.search = "";
	}
}

/**
 * ���ư�ť�Ƿ����
 * @param {} Obj: ���� {'#SearchBT':true, '#SaveBT':false}
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
 * ���������е�field,׷��
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
 * datagrid��Ⱦɫ����
 * @param {gridObj} Grid
 * @param {������} RowIndex
 * @param {������,��߱�Ψһ��} Field
 * @param {��ɫ} Color
 * @param {ҪȾɫ��������} ColorField, ������ʱ����Ⱦɫ
 */
function SetGridBgColor(Grid, RowIndex, Field, Color, ColorField){
	var RowId = Grid.getRows()[RowIndex][Field];
	var Panel =  Grid.getPanel();
	var trs = Panel.find('div.datagrid-body tr');
	trs.each(function(i, tr){
		var td = $(this).children('td[field="' + Field + '"]');		// ȡ������
		var TextValue = td.children('div').text();				// ȡ�����е�ֵ
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
 * �޸�datagrid��(����)��ʽ
 * @param {gridObj} Grid
 * @param {������} RowIndex
 * @param {������,��߱�Ψһ��} Field
 * @param {Ҫ���õ�������,Ϊ��ʱ��������} ColorField
 * @param {��ʽ����,��һ���ַ�Ϊ�ӺŻ��߼���} OperateCss
 * 		���� .ClassRed:{color:red;}, �������OperateCss����Ϊ+ClassRed����-ClassRed
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
		var td = $(this).children('td[field="' + Field + '"]');		// ȡ������
		var TextValue = td.children('div').text();				// ȡ�����е�ֵ
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
///�������ø߶�
///layout border  ����south����north
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
	var oldHeight=p.panel('panel').outerHeight(); //���panel ��ԭ�߶�
	p.panel('resize',{height:h}); //���� panel �¸߶�
	var newHeight=p.panel('panel').outerHeight();
	c.layout('resize',{height:c.height()+newHeight-oldHeight});  //���������������ֵĸ߶�
}
///�ĵ�������ɺ� ����
$(
	function(){
		ResetHeight();
	}
)

/**
 * ��ѯС��λ��
 * FmtType - ��������
 */
function GetFmtNum(FmtType){
	var FmtDecLen = tkMakeServerCall("web.DHCSTMHUI.Util.DrugUtil", "DecLenByFmtType", FmtType, gHospId);
	return FmtDecLen;
}

/**
 * ����
 * inputNum - ԭ����
 * numLength - ���ݳ���
 */
function NumZeroPadding(inputNum, numLength) {
	if (inputNum == "") {
		return inputNum;
	}
	var inputNumLen = inputNum.length;
	if (inputNumLen > numLength) {
		Msg.info("warning", "�������!");
		return;
	}
	for (var i = 1; i <= numLength - inputNumLen; i++) {
		inputNum = "0" + inputNum;
	}
	return inputNum;
}
/**
 *�������ҽԺID
 */
function setStkGrpHospid(HospId) {
	StkGrpHospid=HospId;
}

/**
 * ���������ҳǩ-���÷���
 * @param {����} Title: ���ֶμ�����Ҫ����,�����пɸ���csp��̨��ȡ
 * @param {url��ַ} URL
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
				Title = Caption;			//����csp��ȡ�˵�����
			}
		}
	}
	window.parent.addTab(Title, URL);
}
