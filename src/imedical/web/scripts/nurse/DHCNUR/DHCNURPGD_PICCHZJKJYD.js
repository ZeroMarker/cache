﻿
var ret = "";
var checkret = "";
var comboret = "";
var arrgrid = new Array();



function formatDate(value) {
	try {
		return value ? value.dateFormat('Y-m-d') : '';
	} catch (err) {
		return '';
	}
};

function eachItem1(item, index, length) {
	if (item.xtype == "datefield") {
		//修改下拉框的请求地址    
		ret = ret + item.id + "|" + formatDate(item.getValue()) + "^";


	}
	if (item.xtype == "timefield") {
		//修改下拉框的请求地址    
		//debugger;
		ret = ret + item.id + "|" + item.getValue() + "^";

	}
	if (item.xtype == "combo") {
		//修改下拉框的请求地址    
		//debugger;
		comboret = comboret + item.id + "|" + item.getValue() + "!" + item.lastSelectionText + "^";

	}
	if (item.xtype == "textfield") {
		//修改下拉框的请求地址    
		//debugger;
		ret = ret + item.id + "|" + item.getValue() + "^";

	}
	if (item.xtype == "textarea") {
		//修改下拉框的请求地址    
		ret = ret + item.id + "|" + item.getRawValue() + "^";

	}
	if (item.xtype == "checkbox") {
		//修改下拉框的请求地址    
		//debugger;
		if (item.checked == true) checkret = checkret + item.id + "|" + item.boxLabel + "^";

	}

	if (item.items && item.items.getCount() > 0) {
		item.items.each(eachItem1, this);
	}
}
var insrtCurrentId = "" //全局变量
function InitEventZSK() {
	var arrLength = arr.length;
	var zskObj;
	for (var i = 0; i < arrLength; ++i) {
		if ((arr[i].xtype == "textfield") || (arr[i].xtype == "textarea")) {
			zskObj = Ext.getCmp(arr[i].id);
			zskObj.on('focus', GetItemId);
		}
	}
}

function GetItemId() {
	insrtCurrentId = this.id;
}

var ITypItm = ""; //后取数据字典型
function BodyLoadHandler() {
	InitEventZSK();
	// but.on('click',btclose);
	var but = Ext.getCmp("butSave");
	but.on('click', Save);
	var but = Ext.getCmp("butPrint");
	but.on('click', butPrintFn);
	//setVal2(ExamId);
	setvalue()
	if (userstr != "") {
		getuserha()
	}
	setzkinit() //质控初始化
		//alert(SpId);
	var patName = Ext.getCmp("Item1");
	patName.disable();
}

function setVal2(itm, val) {
	if (val == "") return;
	var tt = val.split('!');
	//alert(tt);
	var cm = Ext.getCmp(itm);
	person = new Array();
	addperson(tt[1], tt[0]);
	cm.store.loadData(person);
	cm.setValue(tt[0]);

}

function cmbkey(field, e) {
	if (e.getKey() == Ext.EventObject.ENTER) {
		var pp = field.lastQuery;
		getlistdata(pp, field);
		//	alert(ret);

	}
}
var person = new Array();

function getlistdata(p, cmb) {
	var GetPerson = document.getElementById('GetPerson');
	//debugger;
	var ret = cspRunServerMethod(GetPerson.value, p);
	if (ret != "") {
		var aa = ret.split('^');
		for (i = 0; i < aa.length; i++) {
			if (aa[i] == "") continue;
			var it = aa[i].split('|');
			addperson(it[1], it[0]);
		}
		//debugger;
		cmb.store.loadData(person);
	}
}

function addperson(a, b) {
	person.push({
		desc: a,
		id: b
	});
}


function btclose() {
	window.close();
}

function cmbkey(field, e) {
	if (e.getKey() == Ext.EventObject.ENTER) {
		var pp = field.lastQuery;
		getlistdata(pp, field);
		//	alert(ret);

	}
}
var person = new Array();

function getlistdata(p, cmb) {
	var GetPerson = document.getElementById('GetPerson');
	//debugger;
	var ret = cspRunServerMethod(GetPerson.value, p);
	if (ret != "") {
		var aa = ret.split('^');
		for (i = 0; i < aa.length; i++) {
			if (aa[i] == "") continue;
			var it = aa[i].split('|');
			addperson(it[1], it[0]);
		}
		//debugger;
		cmb.store.loadData(person);
	}
}

function addperson(a, b) {
	person.push({
		desc: a,
		id: b
	});
}


function AddRec(str) {
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}

function setvalue() {
	//alert(ExamId);
	var ha = new Hashtable();
	var getid = document.getElementById('GetId');
	var id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);
	// alert(id);
	if (id != "") {
		var getVal = document.getElementById('getVal');
		var ret = cspRunServerMethod(getVal.value, id);
		//	alert(ret);
		var tm = ret.split('^')
			//alert(tm);
		sethashvalue(ha, tm);
		//getPatInfo();
	} else {
		//alert("dd");
		getPatInfo();
		return;
		//var PatInfo = document.getElementById('PatInfo');
		//if (PatInfo) {
		//alert(12);
		//var ret = cspRunServerMethod(PatInfo.value, EpisodeID, EmrCode);
		//var tm = ret.split('^')
		//sethashvalue(ha, tm)
	}

	// debugger;



	var gform = Ext.getCmp("gform");
	gform.items.each(eachItem, this);
	//  alert(a);
	for (var i = 0; i < ht.keys().length; i++) //for...in statement get all of Array's index
	{
		var key = ht.keys()[i];
		//restr += ht.items(key) + " " + ht.parent[key] + "<br/>";
		if (key.indexOf("_") == -1) {
			//alert(key);
			var flag = ifflag(key);
			if (flag == true) {
				if (ha.contains(key)) setVal2(key, ha.items(key));
				//debugger;
				continue;
			}
			var itm = Ext.getCmp(key);
			if (ha.contains(key))
				itm.setValue(getval(ha.items(key)));

		} else {
			var aa = key.split('_');
			if (ha.contains(aa[0])) {
				setcheckvalue(key, ha.items(aa[0]));
			}
		}
	}
	//getPatInfo();
}

function getval(itm) {
	var tm = itm.split('!');
	//	alert(tm)
	return tm[0];
}

function ifflag(itm) { //alert(tm);
	var tm = ITypItm.split('|');
	//alert(tm);
	var flag = false;
	for (var i = 0; i < tm.length; i++) {
		if (itm == tm[i]) {
			flag = true;
		}
	}
	return flag;
}

function Save() {
	ret = "";
	checkret = "";
	comboret = "";
	var getid = document.getElementById('GetId');
	var Id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);
	// alert(Id);
	var SaveRec = document.getElementById('Save');
	var gform = Ext.getCmp("gform");
	gform.items.each(eachItem1, this);
	var flag = Savezk(); //质控
	if (flag == 1) {
		alert("红色区域不能为空")
		return
	}
	if (flag == 2) {
		// alert("红色区域不能为空")
		return
	}
	//alert(EmrCode)
	//alert(ret+"&"+checkret+"&"+comboret);
	// alert(checkret);
	//alert(ret);
	//alert(comboret);
	Id = cspRunServerMethod(SaveRec.value, "^EmrUser|" + session['LOGON.USERID'] + "^EmrCode|" + EmrCode + "^" + ret + "^DetLocDr|" + session['LOGON.CTLOCID'] + "^EpisodeId|" + EpisodeID + "&" + checkret + "&" + comboret, Id);
	//alert(Id);
	alert("已保存");
	//MakePicture();
    parent.window.initMainTree();
	//alert(NurRecId);

}
//生成图片
function MakePicture() {
	if (NurRecId == undefined) NurRecId = ""
	PrintCommPicIP.StartMakePic = "Y" //图片
	PrintCommPicIP.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
	PrintCommPicIP.ItmName = "DHCNURMouldPrn_SCHLJL"; //打印模板名称
	var parr = "@" + EpisodeID + "@" + EmrCode;
	PrintCommPicIP.MthArr = "web.DHCNurMouldDataComm:GetPrnValComm&parr:" + parr;
	PrintCommPicIP.PrintOut();
	PrintCommPicIP.NurRecId = NurRecId //图片
	PrintCommPicIP.EmrCode = EmrCode //图片
	PrintCommPicIP.EpisodeID = EpisodeID //图片
	PrintCommPicIP.MakeTemp = "Y"; //图片
	PrintCommPicIP.filepath = WebIp + "/DHCMG/HLBLMakePictureSet.xml" //图片
	PrintCommPicIP.MakePicture(); //图片
	//alert(page)

}

function getPatInfo() {
	//return ;
	var PatInfo = document.getElementById('PatInfo');
	if (PatInfo) {
		var ret = cspRunServerMethod(PatInfo.value, EpisodeID);
		//alert(ret);
		var tt = ret.split('^');
		var patName = Ext.getCmp("Item1");
		patName.setValue(getValueByCode(tt[4]));
		patName.disable();
		var MedCareNo = Ext.getCmp("Item4");
		MedCareNo.setValue(getValueByCode(tt[9]));
		var ret2 = tkMakeServerCall("web.DHCMGNurComm","getPatAdmInfo", EpisodeID);
		var ci = Ext.getCmp("Item2");
		var a=ret2.split('^')
		ci.setValue(a[0]);
	}
}

function getValueByCode(tempStr) {
	var retStr = tempStr;
	var strArr = tempStr.split("|");
	if (strArr.length > 1) {
		retStr = strArr[1];
	}
	return retStr;
}

function butPrintFn() {
	PrintCommPic.WebUrl = WebIp + "/imedical/web/DWR.DoctorRound.cls";
	var getid = document.getElementById('GetId');
	var id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);
	PrintCommPic.ItmName = "DHCNURMouldPrn_PICCHZJKJYD";
	PrintCommPic.MthArr = "Nur.DHCMoudData:getVal2&id:" + id + "!";
	PrintCommPic.PrintOut();
}