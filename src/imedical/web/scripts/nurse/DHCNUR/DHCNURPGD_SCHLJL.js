var ret = "";
var checkret = "";
var comboret = "";
var arrgrid = new Array();
var ycid = "";

var UserType = "";
UserType =  tkMakeServerCall("web.DHCNurseRecordComm", "GetUserType",session['LOGON.USERID']);

function formatDate(value) {
	try {
		return value ? value.dateFormat('Y-m-d') : '';
	} catch (err) {
		return '';
	}
};

function getTime() {
	var date = new Date();
	var hour = date.getHours();
	if (hour < 10) {
		hour = "0" + hour;
	}
	var minute = date.getMinutes();
	if (minute < 10) {
		minute = "0" + minute;
	}
	return hour + ":" + minute;
}

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
	/*
	if (item.xtype == "checkbox") {
		//修改下拉框的请求地址
		//debugger;
		if (item.checked == true)
			checkret = checkret + item.id + "|" + item.boxLabel + "^";

	}
	*/
	if (item.xtype == "checkbox") {
    //修改下拉框的请求地址    
    //debugger;
		if (item.checked == true) {
		  checkret = checkret + item.id + "|" + item.boxLabel + "|" + item.boxLabel + "^";
		} else {
		  checkret = checkret + item.id + "|" + "|" + item.boxLabel + "" + "^";
		}
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
	//var but=Ext.getCmp("butClose");
	InitEventZSK();
	// but.on('click',btclose);
	var but = Ext.getCmp("butSave");
	but.on('click', Save);
	if(UserType=="DOCTOR"){
		but.hide();
	}
	var but = Ext.getCmp("butPrint");
	but.on('click', butPrintFn);
	var but = Ext.getCmp("butYC");
	but.on('click', BradenPF);
	var but = Ext.getCmp("butLink");
	but.on('click', getPatInfo);
	
	//var GetQueryData=document.getElementById('GetQueryData');

	var Item2 = Ext.getCmp("Item54");
	//alert(session['LOGON.USERID']);
	Item2.on('specialkey', cmbkey);
	//ITypItm="Item2";
	//setVal2(ExamId);
	setvalue()
	if (userstr != "") {
		getuserha()
	}
	setzkinit() //质控初始化
	//alert(SpId);
	var patName = Ext.getCmp("Item1");
	patName.disable();
	var patName = Ext.getCmp("Item2");
	patName.disable();
	var patName = Ext.getCmp("Item3");
	patName.disable();
	var patName = Ext.getCmp("Item4");
	patName.disable();
	var patName = Ext.getCmp("Item5");
	patName.disable();
	var patName = Ext.getCmp("Item6");
	patName.disable();
	var patName = Ext.getCmp("Item10");
	patName.disable();
	var patName = Ext.getCmp("Item11");
	patName.disable();
	var patName = Ext.getCmp("Item12");
	patName.disable();
	var patName = Ext.getCmp("Item13");
	patName.disable();
	var patName = Ext.getCmp("Item18");
	patName.disable();
	var patName = Ext.getCmp("Item19");
	patName.disable();
	var patName = Ext.getCmp("Item20");
	patName.disable();
	var patName = Ext.getCmp("Item21");
	patName.disable();
	var patName = Ext.getCmp("Item22");
	patName.disable();
	var patName = Ext.getCmp("Item24");
	patName.disable();
	var patName = Ext.getCmp("Item25");
	patName.disable();
	var patName = Ext.getCmp("Item26");
	patName.disable();
	var patName = Ext.getCmp("Item27");
	patName.disable();
	//var patName = Ext.getCmp("Item29");
	//patName.disable();
	//年龄小于三岁 脉搏呼吸血压变灰色   by add pyh
	var pulseObj=Ext.getCmp("Item31");
	var breathObj=Ext.getCmp("Item32");
	var sysPreObj=Ext.getCmp("Item33");
	var diaPreObj=Ext.getCmp("Item34");
	var ageObj = Ext.getCmp("Item11");
	var age=ageObj.getValue();
	if (age.indexOf("岁")!=-1){
		age=parseInt(age);
		if(age<3){	
		pulseObj.disable();
		breathObj.disable();
		sysPreObj.disable();
		diaPreObj.disable();	
		}	
	}else{
		pulseObj.disable();
		breathObj.disable();
		sysPreObj.disable();
		diaPreObj.disable();
	}
	
	//身高体重不可用 add by yjn
	var height=Ext.getCmp("Item41");
	//height.disable();
	var weight=Ext.getCmp("Item42");
	//weight.disable();
	/*
	var temp=Ext.getCmp("Item30");
	temp.disable();
	var pulse=Ext.getCmp("Item31");
	pulse.disable();
	var breath=Ext.getCmp("Item32");
	breath.disable();
	var sysPre=Ext.getCmp("Item33");
	sysPre.disable();
	var diaPre=Ext.getCmp("Item34");
	diaPre.disable();
	var bmi=Ext.getCmp("Item57");
	bmi.disable();*/
 
	var src = WebIp + "/dhcmg/TTDLB.gif" //要加的图片路径
	var pictureBody = {

		xtype: 'box', //或者xtype: 'component',

		width: 100, //图片宽度

		height: 100, //图片高度

		id: "Pictrue",

		x: 1,

		y: 1,

		autoEl: {

			tag: 'img', //指定为img标签

			src: src //指定url路径
		}
	}
	var gform = Ext.getCmp("gform");
	pictureBody.x = Ext.getCmp("_Label159").x; //标签名
	pictureBody.y = Ext.getCmp("_Label159").y; //标签名
	pictureBody.width = Ext.getCmp("_Label159").width; //标签名
	pictureBody.height = Ext.getCmp("_Label159").height; //标签名
	gform.remove("_Label159"); //标签名
	gform.add(pictureBody);
	var RecDate = Ext.getCmp('Item54');
	var RecTime = Ext.getCmp('Item55');
	var RecUser = Ext.getCmp('Item56');
	if (RecDate.getValue() == "") {
		RecDate.setValue(formatDate(new Date()));
	}
	if (RecTime.getValue() == "") {
		RecTime.setValue(getTime());
	}
	if (RecUser.getValue() == "") {
		RecUser.setValue(session['LOGON.USERNAME']);
	}
	
	//双击输入内容框可以显示下拉框内容，不需要点击下拉按钮 其他单据通用  add by yjn
	for(var k=1;k<200;k++){
		var itm=Ext.getCmp("Item"+k.toString());
		if ((itm==null)||(itm=="undefined")) continue;
		var xtype=itm.getXType();
		if(xtype!="combo") continue;
		itm.on('focus',function(e){
			e.expand();  
			this.doQuery(this.allQuery, true);
		});
	}
	inputReason();
}

function BradenPF() {
	//var lnk = "dhcnuremrcomm.csp?" + "&EmrCode=DHCNURPGD_BDY5SYCFXPGHLD&EpisodeID=" + EpisodeID; //"&DtId="+DtId+"&ExamId="+ExamIds
	//window.open(lnk,"htm",',top=10,left=360,toolbar=no,location=no,directories=no,resizable=yes,width=1000,height=700');
	//var result = window.showModalDialog(lnk, window, "dialogWidth:1500px;dialogHeight:1250px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");
	//getBradenPF();
	var rw = tkMakeServerCall("Nur.DHCMoudData", "judgeFirstBraden", EpisodeID, "DHCNURPGD_BDY5SYCFXPGHLD");
	if (rw==-1){
		var lnk = "dhcnuremrcomm.csp?" + "&EmrCode=DHCNURPGD_BDY5SYCFXPGHLD&EpisodeID=" + EpisodeID
		var result = window.showModalDialog(lnk,window,"dialogWidth:1500px;dialogHeight:1250px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");
		getBradenPF();
	}
	else {
		var lnk = "dhcnuremrcomm.csp?" + "&EmrCode=DHCNURPGD_BDY5SYCFXPGHLD&EpisodeID=" + EpisodeID  + "&NurRecId=" + rw; //"&DtId="+DtId+"&ExamId="+ExamIds
		//window.open(lnk,"htm",',top=10,left=360,toolbar=no,location=no,directories=no,resizable=yes,width=1000,height=700');
		var result = window.showModalDialog(lnk,window,"dialogWidth:1500px;dialogHeight:1250px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");
		getBradenPF();
	}
}

function getBradenPF() {
	var val = tkMakeServerCall("Nur.DHCMoudData", "getBradenFirstScore", EpisodeID, "DHCNURPGD_BDY5SYCFXPGHLD", "Item29");
	if (val != "") {
		Ext.getCmp("Item49").setValue(val);
		var level = Ext.getCmp("Item48");
		if ((val >= 15) && (val <= 17)) {
			level.setValue("轻度");
		} else if ((val >= 13) && (val <= 14)) {
			level.setValue("中度");
		} else if (val < 13) {
			level.setValue("重度");
		} else {
			level.setValue("无");
		}
	}
}

function setVal2(itm, val) {
	if (itm == "Item54")
		return;
	if (val == "")
		return;
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
			if (aa[i] == "")
				continue;
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
			if (aa[i] == "")
				continue;
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
	//alert(id);
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
				if (ha.contains(key))
					setVal2(key, ha.items(key));
				//debugger;
				continue;
			}
			var itm = Ext.getCmp(key);
			if (ha.contains(key))
				itm.setValue(getval(ha.items(key)));

		} else {
			var aa = key.split('_');
			if (ha.contains(aa[0])) {
				setcheckvalue1(key, ha.items(aa[0]));
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
	var retPre = ifPressNormal();
	if (retPre == 1) {
		alert("收缩压应大于舒张压！");
		return;
	}

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

	//大于等于65岁的患者，自动生成Morse跌倒危机评估量表 add by yjn 20171206
	var idMorse = "";
	var patAge = Ext.getCmp('Item11').getValue();
	patAge = parseInt(patAge.split("岁")[0]);
	if (patAge > 64) {
		var ifSaveRet = tkMakeServerCall("Nur.DHCNurMyInterface", "GetIfSavedModel", "DHCNURPGD_MDDWXPGLB",EpisodeID);
		if (ifSaveRet == "0") {
			var PatInfo = document.getElementById('PatInfo');
			var myRet = cspRunServerMethod(PatInfo.value, EpisodeID);
			var tt = myRet.split('^');
			var dateMorse = Ext.getCmp("Item54").getRawValue();
			var nurName = Ext.getCmp("Item56").getValue();
			var morseRet = "^EmrUser|" + session['LOGON.USERID'] + "^EmrCode|DHCNURPGD_MDDWXPGLB^Item7|" + dateMorse + "^Item8|^Item9|^Item10|^Item11|^Item12|^Item61|^Item1|" + getValueByCode(tt[4]) + "^Item2|" + getValueByCode(tt[1]) + "^Item3|" + getValueByCode(tt[3]) + "^Item4|" + getValueByCode(tt[6]) + "^Item5|" + getValueByCode(tt[5]) + "^Item6|" + getValueByCode(tt[9]) + "^Item49|^Item50|^Item51|^Item52|^Item53|^Item54|^Item55|" + nurName + "^Item56|^Item57|^Item58|^Item59|^Item60|^pages|0^^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&&Item13|0 !0 ^Item14|!^Item15|!^Item16|!^Item17|!^Item18|!^Item19|0 !0 ^Item20|!^Item21|!^Item22|!^Item23|!^Item24|!^Item25|15!15^Item26|!^Item27|!^Item28|!^Item29|!^Item30|!^Item31|0 !0 ^Item32|!^Item33|!^Item34|!^Item35|!^Item36|!^Item37|0 !0 ^Item38|!^Item39|!^Item40|!^Item41|!^Item42|!^Item43|0 !0 ^Item44|!^Item45|!^Item46|!^Item47|!^Item48|!^"
			idMorse = cspRunServerMethod(SaveRec.value, morseRet, "");
		}
	}
	//首次护理记录单中BMI的值不属于正常值（BMI<18.5或者>24.9）时，自定链接营养表单
	var idNurtri="";
	var BMI=Ext.getCmp("Item57").getValue();
	if ((BMI<18.5)||(BMI>24.9)) {
		var ifSaveRet = tkMakeServerCall("Nur.DHCNurMyInterface", "GetIfSavedModel", "DHCNURPGD_YYHLDFYN",EpisodeID);
		if (ifSaveRet == "0") {
			var PatInfo = document.getElementById('PatInfo');
			var myRet = cspRunServerMethod(PatInfo.value, EpisodeID);
			var tt = myRet.split('^');
			var dateNurtri = Ext.getCmp("Item54").getRawValue();
			var timeNurtri=Ext.getCmp("Item55").getValue();
			var nurName = Ext.getCmp("Item56").getValue();
			var nurRet = "^EmrUser|"+ session['LOGON.USERID'] +"^EmrCode|DHCNURPGD_YYHLDFYN^Item8|"+getValueByCode(tt[1])+"^Item9|"+getValueByCode(tt[5])+"^Item10|"+getValueByCode(tt[9])+"^Item11|"+getValueByCode(tt[8])+"^Item12|"+ dateNurtri +"^Item13|"+timeNurtri+"^Item14|^Item15|^Item16|^Item17|^Item18|^Item19|^Item38|"+nurName+"^Item1|^Item2|^Item3|^Item4|^Item5|"+getValueByCode(tt[4])+"^Item6|"+getValueByCode(tt[3])+"^Item7|"+getValueByCode(tt[6])+"^Item193|^Item194|^Item195|^Item196|^Item197|^Item198|^Item199|^Item200|^Item201|^Item202|^Item203|^Item204|^Item205|^Item206|^Item207|^Item208|^Item209|^Item210|^pages|0^^DetLocDr|500^EpisodeId|"+EpisodeID+"&&Item48|!^Item49|!^Item50|!^Item51|!^Item52|!^Item53|!^Item54|!^Item55|!^Item56|!^Item57|!^Item58|!^Item59|!^Item60|!^Item61|!^Item62|!^Item63|!^Item64|!^Item65|!^Item66|!^Item67|!^Item68|!^Item69|!^Item70|!^Item71|!^Item72|!^Item73|!^Item74|!^Item75|!^Item76|!^Item77|!^Item78|!^Item79|!^Item80|!^Item81|!^Item82|!^Item83|!^Item84|!^Item85|!^Item86|!^Item87|!^Item88|!^Item89|!^Item90|!^Item91|!^Item92|!^Item93|!^Item94|!^Item95|!^Item96|!^Item97|!^Item98|!^Item99|!^Item100|!^Item101|!^Item102|!^Item103|!^Item104|!^Item105|!^Item106|!^Item107|!^Item108|!^Item109|!^Item110|!^Item111|2!2^Item112|!^Item113|!^Item114|!^Item115|!^Item116|!^Item117|!^Item118|!^Item119|!^Item120|!^Item121|!^Item122|!^Item123|!^Item124|!^Item125|!^Item126|!^Item127|!^Item128|!^Item129|!^Item130|!^Item131|!^Item132|!^Item133|!^Item134|!^Item135|!^Item136|!^Item137|!^Item138|!^Item139|!^Item140|!^Item141|!^Item142|!^Item143|!^Item144|!^Item145|!^Item146|!^Item147|!^Item148|!^Item149|!^Item150|!^Item151|!^Item152|!^Item153|!^Item154|!^Item155|!^Item156|!^Item157|!^Item158|!^Item159|!^Item160|!^Item161|!^Item162|!^Item163|!^Item164|!^Item165|!^Item166|!^Item167|!^Item168|!^Item169|!^Item170|!^Item171|!^Item172|!^Item173|!^Item174|!^Item175|!^Item176|!^Item177|!^Item178|!^Item179|!^Item180|!^Item181|!^Item182|!^Item183|!^Item184|!^Item185|!^Item186|!^Item187|!^Item188|!^Item189|!^Item190|!^Item191|!^";
			
			//var nurRet = "^EmrUser|"+ session['LOGON.USERID'] +"^EmrCode|DHCNURPGD_YYHLDFYN^Item8|"+ dateNurtri +"^Item9|^Item10|^Item11|^Item12|^Item13|^Item14|"+timeNurtri+"^Item15|^Item16|^Item17|^Item18|^Item19|^Item1|刘浩^Item2|男^Item3|29岁^Item4|消化内科一区病房^Item5|12^Item6|000116^Item7|腹膜透析管移位^Item193|"+nurName+"^Item194|^Item195|^Item196|^Item197|^Item198|^Item199|^Item200|^Item201|^Item202|^Item203|^Item204|^Item205|^Item206|^Item207|^Item208|^Item209|^Item210|^pages|0^^DetLocDr|500^EpisodeId|2194016&&Item48|!^Item49|!^Item50|!^Item51|!^Item52|!^Item53|!^Item54|!^Item55|!^Item56|!^Item57|!^Item58|!^Item59|!^Item60|!^Item61|!^Item62|!^Item63|!^Item64|!^Item65|!^Item66|!^Item67|!^Item68|!^Item69|!^Item70|!^Item71|!^Item72|!^Item73|!^Item74|!^Item75|!^Item76|!^Item77|!^Item78|!^Item79|!^Item80|!^Item81|!^Item82|!^Item83|!^Item84|!^Item85|!^Item86|!^Item87|!^Item88|!^Item89|!^Item90|!^Item91|!^Item92|!^Item93|!^Item94|!^Item95|!^Item96|!^Item97|!^Item98|!^Item99|!^Item100|!^Item101|!^Item102|!^Item103|!^Item104|!^Item105|!^Item106|!^Item107|!^Item108|!^Item109|!^Item110|!^Item111|2!2^Item112|!^Item113|!^Item114|!^Item115|!^Item116|!^Item117|!^Item118|!^Item119|!^Item120|!^Item121|!^Item122|!^Item123|!^Item124|!^Item125|!^Item126|!^Item127|!^Item128|!^Item129|!^Item130|!^Item131|!^Item132|!^Item133|!^Item134|!^Item135|!^Item136|!^Item137|!^Item138|!^Item139|!^Item140|!^Item141|!^Item142|!^Item143|!^Item144|!^Item145|!^Item146|!^Item147|!^Item148|!^Item149|!^Item150|!^Item151|!^Item152|!^Item153|!^Item154|!^Item155|!^Item156|!^Item157|!^Item158|!^Item159|!^Item160|!^Item161|!^Item162|!^Item163|!^Item164|!^Item165|!^Item166|!^Item167|!^Item168|!^Item169|!^Item170|!^Item171|!^Item172|!^Item173|!^Item174|!^Item175|!^Item176|!^Item177|!^Item178|!^Item179|!^Item180|!^Item181|!^Item182|!^Item183|!^Item184|!^Item185|!^Item186|!^Item187|!^Item188|!^Item189|!^Item190|!^Item191|!^";
			debugger;
			idNurtri =tkMakeServerCall("Nur.DHCMoudDataSub","Save",nurRet,"");//idNurtri = cspRunServerMethod(SaveRec.value, nurRet, "");
		}
	}
	if (idMorse != "") {
		alert("年龄超过64岁，已为病人新建一张Morse跌倒危机评估量表！");
	} 
	if (idNurtri != "") {
		alert("BMI指数介于18.5与24.9之外，已为病人新建一张营养护理单！");
	} 
	
	//alert("已保存！");	

	if(isNaN(Id)){
		alert(Id);
	}else{
		alert("已保存！");	
	}
	parent.window.initMainTree();
	//alert("已保存");
	//MakePicture();
	//alert(NurRecId);
}
//生成图片
function MakePicture() {
	if (NurRecId == undefined)
		NurRecId = ""
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
		var patName = Ext.getCmp("Item10");
		patName.setValue(getValueByCode(tt[4]));
		patName.disable();
		var sex = Ext.getCmp("Item5");
		sex.setValue(getValueByCode(tt[3]));
		var regno = Ext.getCmp("Item18");
		regno.setValue(getValueByCode(tt[0]));
		var age = Ext.getCmp("Item11");
		age.setValue(getValueByCode(tt[6]));
		var patLoc = Ext.getCmp("Item2");
		patLoc.setValue(getValueByCode(tt[7]));
		var patLoc = Ext.getCmp("Item12");
		patLoc.setValue(getValueByCode(tt[7]));
		var bedCode = Ext.getCmp("Item13");
		bedCode.setValue(getValueByCode(tt[5]));
		var bedCode = Ext.getCmp("Item3");
		bedCode.setValue(getValueByCode(tt[5]));
		var diag = Ext.getCmp("Item29");
		diag.setValue(getValueByCode(tt[8]));

		//var TEL= Ext.getCmp("Item9");
		//TEL.setValue(getValueByCode(tt[10]));
		var admdate = Ext.getCmp("Item24");
		admdate.setValue(getValueByCode(tt[14]));
		var admtime = Ext.getCmp("Item25");
		admtime.setValue(getValueByCode(tt[15]));
		var Nation = Ext.getCmp("Item20"); //民族
		Nation.setValue(getValueByCode(tt[18]));
		//	var admreason = Ext.getCmp("Item11"); //费用支付
		//admreason.setValue(getValueByCode(tt[19]));
		var paersonLX = Ext.getCmp("Item22"); //联系人姓名
		paersonLX.setValue(getValueByCode(tt[10]));
		//var Item18 = Ext.getCmp("Item7"); //职业
		//Item18.setValue(getValueByCode(tt[21]));
		//var paersonLX = Ext.getCmp("Item22"); //与患者关系
		//paersonLX.setValue(getValueByCode(tt[22]));
		var MaritalDesc = Ext.getCmp("Item6"); //婚姻
		MaritalDesc.setValue(getValueByCode(tt[23]));

		var BirthCityDesc = Ext.getCmp("Item21"); //籍贯
		BirthCityDesc.setValue(getValueByCode(tt[29]));

		var MedCareNo = Ext.getCmp("Item19");
		MedCareNo.setValue(getValueByCode(tt[9]));
		var MedCareNo = Ext.getCmp("Item4");
		MedCareNo.setValue(getValueByCode(tt[9])); //
	}
	var FirstTransInBedTime = document.getElementById('GetFirstTransInBedTime');
	if (FirstTransInBedTime) {
		var dateInBedStr = cspRunServerMethod(FirstTransInBedTime.value, EpisodeID);
		var dateInBed = dateInBedStr.split("^");
		var beddate = Ext.getCmp("Item26");
		var bedtime = Ext.getCmp("Item27");
		beddate.setValue(dateInBed[0]);
		bedtime.setValue(dateInBed[1]);
	}
	var GetFirstData = document.getElementById('GetFirstData');
	if (GetFirstData) {
		var ret = cspRunServerMethod(GetFirstData.value, EpisodeID);
		if (ret != "") {
			//alert(ret)
			var TEMPVALUE = ret.split("^");
			//alert(TEMPVALUE);
			var Temperature = Ext.getCmp("Item30");
			if (Temperature)
				Temperature.setValue(TEMPVALUE[0]);
			var Pluse = Ext.getCmp("Item31");
			if (Pluse)
				Pluse.setValue(TEMPVALUE[1].split("/")[0]);
			var Breathe = Ext.getCmp("Item32");
			if (Breathe)
				Breathe.setValue(TEMPVALUE[2]);
			var Pressure = Ext.getCmp("Item33");
			if (Pressure)
				Pressure.setValue(TEMPVALUE[3].split("/")[0]);
			var Pressure = Ext.getCmp("Item34");
			if (Pressure)
				Pressure.setValue(TEMPVALUE[3].split("/")[1]);
			var Height = Ext.getCmp("Item41");
			if (Height)
				Height.setValue(TEMPVALUE[5]);
			var Weight = Ext.getCmp("Item42");
			if (Weight)
				Weight.setValue(TEMPVALUE[4]);
			var BMI = Ext.getCmp("Item57");
			if (BMI)
				BMI.setValue(TEMPVALUE[6]);
			
		}
	
	
	}
	
}

function getValueByCode(tempStr) {
	var retStr = tempStr;
	var strArr = tempStr.split("@");
	if (strArr.length > 1) {
		retStr = strArr[1];
	}
	return retStr;
}

function butPrintFn() {
	PrintCommPicIP.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
	var getid = document.getElementById('GetId');
	var id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);
	PrintCommPicIP.ItmName = "DHCNURMouldPrn_SCHLJL";
	PrintCommPicIP.MthArr = "Nur.DHCMoudData:getVal2&id:" + id + "!";
	//alert(PrintCommPicIP.MthArr);
	PrintCommPicIP.PrintOut();
}

///判断血压值
function ifPressNormal() {
	var retPre = 0;
	var lPre = Ext.getCmp("Item33").getValue();
	var hPre = Ext.getCmp("Item34").getValue();
	if (parseInt(lPre) < parseInt(hPre)) {
		//alert("收缩压应大于舒张压！");
		retPre = 1;
	}
	return retPre;
}

//首次护理记录单中需要填补充内容的，自动弹框让护士输入原因等内容。  add by yjn 20171208
function inputReason(){
	var languReason=Ext.getCmp('Item59');
	var labelLangu=Ext.getCmp('_Label172');
	var itm36=Ext.getCmp('Item36');
	if((itm36.value.indexOf("含糊")<0)){
		languReason.hide();
		if(labelLangu!=null){
			labelLangu.hide();
		}
	}else{
		labelLangu.hide();
	}
	itm36.on('select',function(combo, record, index){
		if(itm36.value.indexOf("含糊")>-1){
			languReason.show();
			if(languReason.value==""){
				labelLangu.show();
				document.getElementById('_Label172').innerHTML="<span style='color:red'>（请描述原因！）</span>";
				//document.getElementById('_Label170').style.color ='red';
			}	
		}else{
			languReason.hide();
			labelLangu.hide();
		}
	});
	
}