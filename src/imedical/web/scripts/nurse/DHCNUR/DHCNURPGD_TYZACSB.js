var ret = "";
var checkret = "";
var comboret = "";
var arrgrid = new Array();
var ycid = "";

var UserType = "";
UserType =  tkMakeServerCall("web.DHCNurseRecordComm", "GetUserType",session['LOGON.USERID']);
//----总分
//说明:数组可以自由增加
var ScoreItem = new Array();    //总分元素    计算总分的元素
var ValueItem = new Array();    //总分显示     总分显示的元素
var NameItem = new Array();     //总分签名    总分签名的元素
var DateItem = new Array();     //签名日期      总分日期的元素
var TimeItem = new Array();
var partArray = ["Item41", "Item42", "Item43", "Item44", "Item45", "Item46", "Item47", "Item48,Item49,Item50"];
var partScoreArray = ["Item20", "Item21", "Item22", "Item23", "Item24", "Item25", "Item26", "Item27","Item28","Item29"];
ScoreItem[0] = "^Item20^Item21^Item22^Item23^Item24^Item25^Item26^Item27^Item28^Item29^^";
ValueItem[0] = "Item30";
NameItem[0] = "Item39";
DateItem[0] = "Item8";
TimeItem[0] = "Item9";
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
	 initEvents();    //加载总分功能
	//var GetQueryData=document.getElementById('GetQueryData');
	//var aa=new Date();
	//var PLGDate = Ext.getCmp("Item7");
	//PLGDate.setValue(formatDate(aa));
	//var PLGTime=Ext.getCmp("Item8");
	//PLGTime.setValue(getTime());
	getPatInfo();
	setvalue();
	 //计算各项radio分数
  calScore("Item41", "Item20");
  calScore("Item42", "Item21");
  calScore("Item43", "Item22");
  calScore("Item44", "Item23");
  calScore("Item45", "Item24");
  calScore("Item46", "Item25");
  calScore("Item47", "Item26");
  calScore("Item48", "Item27");
   calScore("Item49", "Item28");
  calScore("Item50", "Item29");
 /*begin*****南方医院的搞特殊处理方法*********************/
	var selFlag=0;
	var date=new Date();
	if(selFlag==0){
						Ext.getCmp('Item8').setValue(date.dateFormat('Y-m-d'));
						Ext.getCmp('Item9').setValue(date.dateFormat('H:i'));
						selFlag=1;
					}
	/*for(var i=16;i<24;i++){
		if(Ext.getCmp('Item'+i)){
			Ext.getCmp('Item'+i).on('focus',function(e){
				var itm=Ext.getCmp(e.id);
				if(itm.value==''){
					itm.setValue('√');
					itm.blur();
					if(selFlag==0){
						Ext.getCmp('Item8').setValue(date.dateFormat('Y-m-d'));
						Ext.getCmp('Item9').setValue(date.dateFormat('H:i'));
						selFlag=1;
					}
				}else{
					itm.setValue('');
					itm.blur();
				}
			});
		}
	}*/
}
//计算分数
function calScore(partItem, scoreItem) {
  var partScore = 0;
  var scoreItem = Ext.getCmp(scoreItem)
  var partGroup = Ext.getCmp(partItem).items.items;
    partGroup.forEach(function (item, index, array) {
      item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel == "没有") {
            partScore = 0;
          } else if (field.boxLabel == "轻度") {
            partScore = 1;
          } else if (field.boxLabel == "中度") {
            partScore = 2;
          }else if (field.boxLabel == "重度") {
            partScore = 3;
          } else {
            partScore = 4;
          }
          scoreItem.setValue(partScore);
          scoreItem.focus();
          return;
        }
      });
    });
   
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
	//var BMI=Ext.getCmp("Item57").getValue();

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
	PrintCommPic.StartMakePic = "Y" //图片
	PrintCommPic.WebUrl = WebIp + "/imedical/web/DWR.DoctorRound.cls";
	PrintCommPic.ItmName = "DHCNURMouldPrn_SCHLJL"; //打印模板名称
	var parr = "@" + EpisodeID + "@" + EmrCode;
	PrintCommPic.MthArr = "web.DHCNurMouldDataComm:GetPrnValComm&parr:" + parr;
	PrintCommPic.PrintOut();
	PrintCommPic.NurRecId = NurRecId //图片
	PrintCommPic.EmrCode = EmrCode //图片
	PrintCommPic.EpisodeID = EpisodeID //图片
	PrintCommPic.MakeTemp = "Y"; //图片
	PrintCommPic.filepath = WebIp + "/DHCMG/HLBLMakePictureSet.xml" //图片
	PrintCommPic.MakePicture(); //图片
	//alert(page)

}

function getPatInfo() {
	//return ;
	var PatInfo = document.getElementById('PatInfo');
	if (PatInfo) {
		var ret = cspRunServerMethod(PatInfo.value, EpisodeID);
		// alert(ret);
		var tt = ret.split('^');
		var patloc = Ext.getCmp("Item1");
		patloc.setValue(getValueByCode(tt[1]));
		patloc.disable();
		var patName = Ext.getCmp("Item3");
		patName.setValue(getValueByCode(tt[4]));
		patName.disable();
		var bedCode = Ext.getCmp("Item2");
		bedCode.setValue(getValueByCode(tt[5]));
		bedCode.disable();
		var patsex = Ext.getCmp("Item4");
		patsex.setValue(getValueByCode(tt[3]));
		patsex.disable();
		var patage = Ext.getCmp("Item5");
		patage.setValue(getValueByCode(tt[6]));
		patage.disable();
		var diag = Ext.getCmp("Item6");
		diag.setValue(getValueByCode(tt[8]));
		diag.disable();
		var MedCareNo = Ext.getCmp("Item7");
		MedCareNo.setValue(getValueByCode(tt[9]));
		MedCareNo.disable();
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
	PrintCommPic.WebUrl = WebIp + "/imedical/web/DWR.DoctorRound.cls";
	var getid = document.getElementById('GetId');
	var id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);
	PrintCommPic.ItmName = "DHCNURMouldPrn_SCHLJL";
	PrintCommPic.MthArr = "Nur.DHCMoudData:getVal2&id:" + id + "!";
	//alert(PrintCommPic.MthArr);
	PrintCommPic.PrintOut();
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