/// Creator:      EH
/// CreatDate:    2022-03-17
/// Description:  

function NewPrintXmlMode(orderIDStr, printData, printFlag, template, callback) {
	if (!printData || !printData.length) return;
	var myPara = '', separator = String.fromCharCode(2), LODOP  =  getLodop();
	LODOP.PRINT_INIT('CST PRINT');
	DHCP_GetXMLConfig('InvPrintEncrypt', template);
	var printDataArray = typeof printData == 'string' ? printData.split('#') : printData;
	printDataArray.forEach(function(data, i) {
		var myPara = data.split('|').join(separator);
		DHC_CreateByXML(LODOP, myPara, '', [], 'PRINT-CST-NT');
		LODOP.NEWPAGE();
	});
	var printResult = LODOP.PRINT();
	if (printResult) SavePrintRecord(orderIDStr, printData, printFlag, template);
	else if (callback) callback();
}

function SavePrintRecord(orderIDStr, printData, printFlag, template, callback) {
	$cm({
		ClassName: 'Nur.HISUI.MNIS.Badge',
		MethodName: 'SaveEventLog',
		printFlag: printFlag,
		orderIDStr: orderIDStr,
		template: template,
		queryTypeCode: '',
		secretCode: '',
		locID: GetSessionProperty('LOGON.CTLOCID'),
		userID: GetSessionProperty('LOGON.USERID'),
		groupID: GetSessionProperty('LOGON.GROUPID'),
		clientIP: GetClientIPAddr(),
		computerName: GetClientComputerName(),
		dataType: 'text'
	}, function(result) {
		if (callback) callback();
	});
}

function GetSessionProperty(name) {
	return session && session[name] || '';
}

function GetClientIPAddr() {
	var ip = '';
	try {
		var oSetting = new ActiveXObject('rcbdyctl.Setting');
		ip = oSetting.GetIPAddress;
		oSetting = null;
		if (ip == '' && getClientIP) {
			var rtn = getClientIP();
			if (String(rtn).indexOf('^') > -1) {
				ip = rtn.split('^')[0];
			}
		}
	} catch (e) { }
	if (ip == '') {
		//window.status='本机IP:10.200.58.134,服务器IP:114.242.246.235';
		var st = window.status; // EH 2022-05-17
		if (st.indexOf('IP:') > -1) ip = st.split(',')[0].split('IP:')[1];
	}
	return ip;
}

function GetClientComputerName() {
	var computerName = '';
	try {
		var wshShell = new ActiveXObject('WScript.Shell');
		computerName = wshShell.ExpandEnvironmentStrings('%COMPUTERNAME%');
		wshShell = null;
	} catch (e) { }
	return computerName;
}

function LoadJavaScript(url, callback) {
	var script = document.createElement('script'),
	fn = callback || function() {};
	script.type = 'text/javascript';
	script.charset = 'gbk';
	if (script.readyState) {
		script.onreadystatechange = function() {
			if (script.readyState == 'loaded' || script.readyState == 'complete') {
				script.onreadystatechange = null;
				fn();
			}
		}
	} else {
		script.onload = fn;
	}
	script.src = url;
	document.getElementsByTagName('head')[0].appendChild(script);
}

function BeforeHospCombo(id, fn) {
	var hospID = $.m({
		ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
		MethodName: 'GetDefHospIdByTableName',
		tableName: 'CT_NUR_MNIS.MainModule',
		HospID: GetSessionProperty('LOGON.HOSPID'),
		date: ''
	}, false);
	LoadJavaScript('../scripts/hisui/websys.comm.js', function() {
		$('#' + id).parent().prev().before('<td><span class="r-label" style="color:red">医院</span></td><td><input id="_HospList" class="combo-text validatebox-text" autocomplete="off" style="width:210px;height:28px;line-height:28px" data-options="enterNullValueClear:false,panelMaxHeight:\'400px\'"></td>');
		GenHospComp('CT_NUR_MNIS.MainModule', '', { width: 210 });
		$('#_HospList').combogrid('options').onSelect = fn;
		$('#_HospList').combogrid('options').onLoadSuccess = fn;
	});
	return hospID;
}

function GetHospComboValue() {
	return $('#_HospList').length ? $('#_HospList').combogrid('getValue') : GetSessionProperty('LOGON.HOSPID');
}

if (!Array.prototype.find) {
	Array.prototype.find = function(fn, thisValue) {
		if (fn) {
			var thisArray = this;
			for (var i = 0; i < thisArray.length; i++) {
				var currentValue = thisArray[i]
				var find = thisValue ? fn.call(thisValue, currentValue, i, thisArray) : fn(currentValue, i, thisArray);
				if (find) return currentValue;
			}
		}
		return null;
	};
}
if (!Array.prototype.forEach) {
	Array.prototype.forEach = function forEach(callback, thisArg) {
		var T, k;
		if (this == null) {
			throw new TypeError("this is null or not defined");
		}
		var O = Object(this);
		var len = O.length >>> 0;
		if (typeof callback !== "function") {
			throw new TypeError(callback + " is not a function");
		}
		if (arguments.length > 1) {
			T = thisArg;
		}
		k = 0;
		while (k < len) {

			var kValue;
			if (k in O) {
				kValue = O[k];
				callback.call(T, kValue, k, O);
			}
			k++;
		}
	};
}

if (!Array.prototype.indexOf) {
	Array.prototype.indexOf = function(val) {
		for (var i = 0; i < this.length; i++) {
			if (this[i] == val) return i;
		}
		return -1;
	};
}
