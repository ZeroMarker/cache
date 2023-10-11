var ret = "";
var checkret = "";
var comboret = "";
var arrgrid = new Array();
var ycid = "";

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
	var but = Ext.getCmp("butPrint");
	but.on('click', butPrintFn);
	//var but = Ext.getCmp("butYC");
	//but.on('click', BradenPF);
	//var GetQueryData=document.getElementById('GetQueryData');

	//var Item2 = Ext.getCmp("Item54");
	//alert(session['LOGON.USERID']);
	//Item2.on('specialkey', cmbkey);
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
	var patName = Ext.getCmp("Item10");
	patName.disable();
	var patName = Ext.getCmp("Item11");
	patName.disable();
	var patName = Ext.getCmp("Item12");
	patName.disable();
	var patName = Ext.getCmp("Item13");
	patName.disable();

	

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
		Id = cspRunServerMethod(SaveRec.value, "^EmrUser|" + session['LOGON.USERID'] + "^EmrCode|" + EmrCode + "^" + ret + "^DetLocDr|" + session['LOGON.CTLOCID'] + "^EpisodeId|" + EpisodeID + "&" + checkret + "&" + comboret, Id);
		alert("已保存");
		if(IfMakePic=="Y"){
			MakePicture();
		}
		parent.window.initMainTree();

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
		
		var sex = Ext.getCmp("Item2");
		sex.setValue(getValueByCode(tt[3]));
		
		var age = Ext.getCmp("Item3");
		age.setValue(getValueByCode(tt[6]));
		var patLoc = Ext.getCmp("Item4");
		patLoc.setValue(getValueByCode(tt[7]));
		
		var bedCode = Ext.getCmp("Item10");
		bedCode.setValue(getValueByCode(tt[5]));
		
		var admdate = Ext.getCmp("Item12");
		admdate.setValue(getValueByCode(tt[14]));
		var admtime = Ext.getCmp("Item13");
		admtime.setValue(getValueByCode(tt[15]));
		var diag = Ext.getCmp("Item14");
		diag.setValue(getValueByCode(tt[8]));
		

	
		var MedCareNo = Ext.getCmp("Item11");
		MedCareNo.setValue(getValueByCode(tt[9]));
		
	}
	/*var FirstTransInBedTime = document.getElementById('GetFirstTransInBedTime');
	if (FirstTransInBedTime) {
		var dateInBedStr = cspRunServerMethod(FirstTransInBedTime.value, EpisodeID);
		var dateInBed = dateInBedStr.split("^");
		var beddate = Ext.getCmp("Item26");
		var bedtime = Ext.getCmp("Item27");
		beddate.setValue(dateInBed[0]);
		bedtime.setValue(dateInBed[1]);
	}*/
	var GetFirstData = document.getElementById('GetFirstData');
	if (GetFirstData) {
		var ret = cspRunServerMethod(GetFirstData.value, EpisodeID);
		if (ret != "") {
			//alert(ret)
			var TEMPVALUE = ret.split("^");
			//alert(TEMPVALUE);
			var Temperature = Ext.getCmp("Item17");
			if (Temperature)
				Temperature.setValue(TEMPVALUE[0]);
			var Pluse = Ext.getCmp("Item18");
			if (Pluse)
				Pluse.setValue(TEMPVALUE[1].split("/")[0]);
			var Breathe = Ext.getCmp("Item19");
			if (Breathe)
				Breathe.setValue(TEMPVALUE[2]);
			/*var Pressure = Ext.getCmp("Item33");
			if (Pressure)
				Pressure.setValue(TEMPVALUE[3].split("/")[0]);
			var Pressure = Ext.getCmp("Item34");
			if (Pressure)
				Pressure.setValue(TEMPVALUE[3].split("/")[1]);*/
			/*var Height = Ext.getCmp("Item41");
			if (Height)
				Height.setValue(TEMPVALUE[5]);*/
			var Weight = Ext.getCmp("Item20");
			if (Weight)
				Weight.setValue(TEMPVALUE[4]);
			/*var BMI = Ext.getCmp("Item57");
			if (BMI)
				BMI.setValue(TEMPVALUE[6]);*/
			
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
	PrintCommPicIP.ItmName = "DHCNURMouldPrn_KFBRSCHLJLD";
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