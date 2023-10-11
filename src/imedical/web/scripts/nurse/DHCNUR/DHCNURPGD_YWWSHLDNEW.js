
var ret = "";
var checkret = "";
var comboret = "";
var radioret = "";
var subid = "";
var arrgrid = new Array();

//----总分
//说明:数组可以自由增加
var ScoreItem = new Array();    //总分元素    计算总分的元素
var ValueItem = new Array();    //总分显示     总分显示的元素
var NameItem = new Array();     //总分签名    总分签名的元素
var DateItem = new Array();     //签名日期      总分日期的元素
var TimeItem = new Array();
//var partArray = ["Item11", "Item12", "Item13", "Item15", "Item16", "Item17"];
//var partScoreArray = ["Item18", "Item19", "Item20", "Item21", "Item22", "Item23"];
//ScoreItem[0] = "^Item18^Item19^Item20^Item21^Item22^Item23^";
//ValueItem[0] = "Item24";
//NameItem[0] = "Item35";
//DateItem[0] = "Item8";
//TimeItem[0] = "Item9";
var prncode = "DHCNURMouldPrn_WUWSHLDNEW";

function formatDate(value) {
  try {
    return value ? value.dateFormat('Y-m-d') : '';
  }
  catch (err) {
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
    // item.on('check',checksj);
  }
  if (item.xtype == "radio") {
    //修改下拉框的请求地址    
    //debugger;
    if (item.checked == true) radioret = radioret + item.id + "|" + item.boxLabel + "^";
    // item.on('check',checksj);
  }

  if (item.items && item.items.getCount() > 0) {
    item.items.each(eachItem1, this);
  }
}
function eachItem11(item, index, length) {
  if (item.xtype == "checkbox") {
    item.on('check', function (obj, ischecked) { checksj(obj) });

  }

  if (item.items && item.items.getCount() > 0) {

    item.items.each(eachItem11, this);
  }

}
function eachItemcheck(item, index, length) {
  if (item.xtype == "checkbox") {
    if (item.id.indexOf("_") != -1) {
      var aa = item.id.split("_");
      var bb = checkItem.split("_");
      if (aa[0] == bb[0]) {
        //alert(item.id+"|"+checkItem);
        if (item.id != checkItem) {
          checkret = checkret + item.id + "^";
          //checkflag="true";
        }
      }

    }
  }

  if (item.items && item.items.getCount() > 0) {

    item.items.each(eachItemcheck, this);
  }
}
var checkItem = "";
var checkflag = "true";
function checksj(item) {
  if (checkflag == "false") return;
  checkret = "";
  checkItem = item.id;
  if (item.check = true) {
    var gform = Ext.getCmp("gform");
    gform.items.each(eachItemcheck, this);
    checkflag = "false";
    var aa = checkret.split("^");
    for (var i = 0; i < aa.length; i++) {
      if (aa[i] == "") continue;
      var ch = Ext.getCmp(aa[i]);
      ch.setValue(false);
    }
    checkflag = "true";
  }
  //totelmouth();
}
function totelmouth() {
  ret = "";
  sum = "";
  checkret = "";
  comboret = "";
  var gform = Ext.getCmp("gform");
  gform.items.each(eachItem1, this);
  var a1 = checkret.split('^');
  var arrayObj = new Array();
  var array1 = new Array();
  for (i = 0; i < a1.length - 1; i++) {
    var a2 = a1[i].split('_');
    var a3 = a2[1];
    var a7 = a2[0];
    var a4 = a3.split('|');
    var a5 = parseFloat(a4[0]);
    arrayObj[i] = a5;
    sum += a5 + "," + a7 + "^";
  }
  var getzf = document.getElementById('getzf');
  ret = cspRunServerMethod(getzf.value, sum);
  a = ret.split('^');
  zongf = a[0];
  fenj = a[1];
  var zf = Ext.getCmp("Item24");
  zf.setValue(getValueByCode(zongf));
  var fj = Ext.getCmp("Item8");
  fj.setValue(getValueByCode(fenj));
  var getuser = document.getElementById('getuser');
  var user = cspRunServerMethod(getuser.value, session['LOGON.USERID']);
  var tt5 = user.split('^');
  var qianm = Ext.getCmp("Item35");
  qianm.setValue(getValueByCode(tt5[0]));



}
var ITypItm = ""; //后取数据字典型
function BodyLoadHandler() {
  var but = Ext.getCmp("butSave");
  but.on('click', Save);
  var but = Ext.getCmp("butPrint");
  but.on('click', butPrintFn);
  but.hide();
  var gform = Ext.getCmp("gform");
  gform.items.each(eachItem11, this);
  // var butChk1 = Ext.getCmp("Item1")
  // butChk1.on("check", sjj)

  //initEvents();    //加载总分功能

  setvalue();
  var tmpItm = Ext.getCmp("Item1")
  tmpItm.disable();
  var tmpItm = Ext.getCmp("Item2")
  tmpItm.disable();
  var tmpItm = Ext.getCmp("Item3")
  tmpItm.disable();
  var tmpItm = Ext.getCmp("Item4")
  tmpItm.disable();
  var tmpItm = Ext.getCmp("Item5")
  tmpItm.disable();
  var tmpItm = Ext.getCmp("Item6")
  tmpItm.disable();
  var tmpItm = Ext.getCmp("Item7")
  tmpItm.disable();
  
  // var firstScore=Ext.getCmp("Item96_1")
  // firstScore.focus();
  //计算各项radio分数
					 /* calScore("Item11", "Item18");
					  calScore("Item12", "Item19");
					  calScore("Item13", "Item20");
					  calScore("Item15", "Item21");
					  calScore("Item16", "Item22");
					  calScore("Item17", "Item23");*/
  /*begin*****南方医院的搞特殊处理方法*********************/
	var selFlag=0;
	var date=new Date();
	for(var i=13;i<48;i++){
		if ((i==17)||(i==27)||(i>29&&i<=33)||(i==35)||(i==37)||(i==38)||(i==43)||(i==44)||(i==48)) {
			continue;
		}
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
	}
	for(var i=53;i<57;i++){
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
	}
	
	
	
	//SMutualExclusion(64,67,selFlag,date);
	//SMutualExclusion(68,70,selFlag,date);
	
	/*end*******南方医院的搞特殊处理方法*********************/
}
function sjj() { }
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
  person.push(
    {
      desc: a,
      id: b
    }
  );
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
  person.push(
    {
      desc: a,
      id: b
    }
  );
}


function AddRec(str) {
  //var a=new Object(eval(str));
  var obj = eval('(' + str + ')');
  arrgrid.push(obj);
  //debugger;
}
function setvalue() {
  //alert(NurRecId);
  if (NurRecId != "") {
    subid=NurRecId;
    //alert(ExamId);
    var ha = new Hashtable();
    // var getid=document.getElementById('GetId');
    // var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
    //EpisodeID_"^"_NurRecId;
    //alert(NurRecId);
    if (NurRecId != "") {
      var getVal = document.getElementById('getVal');
      var ret = cspRunServerMethod(getVal.value, NurRecId);
      var tm = ret.split('^')
      sethashvalue(ha, tm);
      getPatInfo();
    }
    else {
      getPatInfo();
      return;
    }
    var gform = Ext.getCmp("gform");
    gform.items.each(eachItem, this);

    for (var i = 0; i < ht.keys().length; i++)//for...in statement get all of Array's index
    {
      var key = ht.keys()[i];
      //restr += ht.items(key) + " " + ht.parent[key] + "<br/>";
      if (key.indexOf("_") == -1) {

        var flag = ifflag(key);
        if (flag == true) {
          if (ha.contains(key)) setVal2(key, ha.items(key));
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
  }
  else {
    getPatInfo();
  }
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
function ifsave() {
}
var flag9 = "";
function Save() {
  ///by lmm  增加年份保存
  var recDate = Ext.getCmp("Item8")    //括号item数值要改成评估日期的item数值
  var recYear="";
  if(recDate.getValue()!=""){
  recYear=formatDate(recDate.getValue()).split("-")[0]
  }
  var recYearObj = Ext.getCmp("Item57")  //新加的评估年份Item 元素不要超过345
  recYearObj.setValue(recYear);
  ///end
  ret = "";
  checkret = "";
  comboret = "";
  radioret = "";
  var SaveRec = document.getElementById('Save');
  var gform = Ext.getCmp("gform");
  gform.items.each(eachItem1, this);
  //alert(EmrCode)
  // alert(EpisodeID);
  ret + "&" + checkret + "&" + comboret;
  //alert(checkret);
  //alert(ret);
  // alert(comboret);
  var stid = NurRecId;
  if (NurRecId != "") {
    var Id = cspRunServerMethod(SaveRec.value, "^EmrUser|" + session['LOGON.USERID'] + "^EmrCode|" + EmrCode + "^" + ret + "^DetLocDr|" + session['LOGON.CTLOCID'] + "^EpisodeId|" + EpisodeID + "&" + checkret + "&" + comboret + "&" + radioret, NurRecId);
    currid = Id.split("||")[0];
  }
  else {
    var Id = cspRunServerMethod(SaveRec.value, "^EmrUser|" + session['LOGON.USERID'] + "^EmrCode|" + EmrCode + "^" + ret + "^DetLocDr|" + session['LOGON.CTLOCID'] + "^EpisodeId|" + EpisodeID + "&" + checkret + "&" + comboret + "&" + radioret, "");
    if (Id != "") {
      NurRecId = Id;
      subid=Id;
    }
  }
  // if (stid == "") {
  //   window.opener.reloadtree();
  // }
  // var flag9 = 1;
  // if (Id != "") {
  //   checkprn();
  //   tt = ret.split('^');
  //   tx = tt[1].split(';');
  //   ty = tt[0];
  //   rq = tt[2];
  //   var flag = confirm("保存成功! 您要打印吗？")
  //   if (flag) {
  //     //alert(rq);
  //     if (!rq != "") { alert("未填写\“日期”\""); }
  //     if (ty != "") {
  //       alert("未置\“评分时间\”");
  //     }
  //     if (tx[0] != "") {
  //       alert("以下项未评分：\“" + tx + "\”");
  //     }
  //     if ((!tx[0] != "") && (!ty != "") && (rq != "")) {
  //       //Save();
  //       PrintComm.RHeadCaption = 'dddd';
  //       PrintComm.SetConnectStr(CacheDB);
  //       PrintComm.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
  //       PrintComm.ItmName = "DHCNURMouldPFBPrn";
  //       var subid = NurRecId
  //       var tt3 = subid.split('||')
  //       var subid = tt3[0] + "_" + tt3[1]
  //       //alert(subid)
  //       PrintComm.MthArr = "Nur.DHCMoudDataSub:getVal1&parr:" + subid + "!flag:";
  //       PrintComm.PrintOut();
  //       window.close();  //关闭子窗口  
  //       window.opener.find();
  //     }
  //   }
  //   else {
  //     if (!rq != "") {
  //       alert("未填写\“日期”\"");
  //       return;
  //     }
  //     if (ty != "") {
  //       alert("未置\“评分时间\”");
  //       return;
  //     }
  //     if (tx[0] != "") {
  //       alert("以下项未评分：\“" + tx + "\”");
  //       return;
  //     }
  //     window.close();  //关闭子窗口  
  //     window.opener.find();
  //   }
  // }
  alert("保存成功");
  window.opener.find();
  window.close();
  window.opener.parent.window.initMainTree();	
}

function getPatInfo() {
  var PatInfo = document.getElementById('PatInfo');
  if (PatInfo) {
    var ret = cspRunServerMethod(PatInfo.value, EpisodeID);
	
    //alert(ret);
    var tt = ret.split('^');
    var patName = Ext.getCmp("Item1");
    patName.setValue(getValueByCode(tt[4]));
    var sex = Ext.getCmp("Item2");
    sex.setValue(getValueByCode(tt[3]));
    //var  regno= Ext.getCmp("Item5");
    //regno.setValue(getValueByCode(tt[0]));
    var age = Ext.getCmp("Item3");
    age.setValue(getValueByCode(tt[6]));
    var patLoc = Ext.getCmp("Item4");
	//alert(getValueByCode(tt[1]));
    patLoc.setValue(getValueByCode(tt[7]));
    var bedCode = Ext.getCmp("Item5");
    bedCode.setValue(getValueByCode(tt[5]));
    var MedCareNo = Ext.getCmp("Item6");
    MedCareNo.setValue(getValueByCode(tt[9]));
    var diag = Ext.getCmp("Item7");
    diag.setValue(getValueByCode(tt[8]));
	var signature = Ext.getCmp("Item48");
    signature.setValue(getValueByCode(session['LOGON.USERNAME']));
    //var admdate = Ext.getCmp("Item9");
    //admdate.setValue(getValueByCode(tt[10]));
    //var admtime = Ext.getCmp("Item10");
    //admtime.setValue(getValueByCode(tt[11]));

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
function butPrintFn_bak() {
  checkprn();
  tt = ret.split('^');
  tx = tt[1].split(';');
  ty = tt[0];
  rq = tt[2];
  //alert(rq);
  if (!rq != "") { alert("未填写\“日期”\""); }
  if (ty != "") {
    alert("未置\“评分时间\”");
  }
  if (tx[0] != "") {
    alert("以下项未评分：\“" + tx + "\”");
  }
  if ((!tx[0] != "") && (!ty != "") && (rq != "")) {
    //Save();
    PrintComm.RHeadCaption = 'dddd';
    PrintComm.LHeadCaption = "3333333";
    PrintComm.SetConnectStr(CacheDB);
    PrintComm.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
    PrintComm.ItmName = "DHCNURMouldPFBPrn";
    //var parr="@"+EpisodeID+"@DHCNurPFB";
    //alert(parr);var mth1="Nur.DHCMoudData:getVal&parr:"+parr+"!";
    var ch1 = NurRecId.split("||")[0];
    var ch2 = NurRecId.split("||")[1];
    var subid = ch1 + "_" + ch2;
    PrintComm.MthArr = "Nur.DHCMoudDataSub:getVal1&parr:" + subid + "!flag:";
    PrintComm.PrintOut();
  }
}
function checkprn() {
  ret = "";
  sum = "";
  checkret = "";
  comboret = "";
  var gform = Ext.getCmp("gform");
  gform.items.each(eachItem1, this);
  var a1 = checkret.split('^');
  var a2 = ret.split('^');
  var a3 = a2[0].split('|');
  //alert(a3);
  var arrayObj = new Array();
  for (i = 0; i < a1.length - 1; i++) {
    var a2 = a1[i].split('_');
    var a7 = a2[0];
    sum += a7 + "^";
  }
  sum = sum + "*" + a3;
  var checkprn = document.getElementById('checkprn');
  ret = cspRunServerMethod(checkprn.value, sum);
  //alert(ret);
  return ret;
}
//计算分数
function calScore(partItem, scoreItem) {
  var partScore = 0;
  var scoreItem = Ext.getCmp(scoreItem)
  var partGroup = Ext.getCmp(partItem).items.items;
  switch(partItem)
  {
		  case 'Item11':
			partGroup.forEach(function (item, index, array) {
			  item.on("check", function (field, checked) {
				if (checked == true) {
				  if (field.boxLabel == "自然睁眼 4") {
					partScore = 4;
				  } else if (field.boxLabel == "语言命令睁眼 3") {
					partScore = 3;
				  } else if (field.boxLabel == "疼痛刺激睁眼 2") {
					partScore = 2;
				  } else {
					partScore = 1;
				  }
				  scoreItem.setValue(partScore);
				  scoreItem.focus();
				  return;
				}
			  });
			});
			break;
		 case "Item12":
			partGroup.forEach(function (item, index, array) {
			  item.on("check", function (field, checked) {
				if (checked == true) {
				  if (field.boxLabel == "定向力好 5") {
					partScore = 5;
				  } else if (field.boxLabel == "语言含糊 4") {
					partScore = 4;
				  } else if (field.boxLabel == "无意义语言 3") {
					partScore = 3;
				  } else if (field.boxLabel == "无意义声音 2") {
					partScore = 2;
				  }
				  else {
					partScore = 1;
				  }
				  scoreItem.setValue(partScore);
				  scoreItem.focus();
				  return;
				}
			  });
			});
			break;
		case "Item13":
			partGroup.forEach(function (item, index, array) {
			  item.on("check", function (field, checked) {
				if (checked == true) {
				  if (field.boxLabel == "遵嘱动作 6") {
					partScore = 6;
				  } else if (field.boxLabel == "疼痛定位 5") {
					partScore = 5;
				  } else if (field.boxLabel == "逃避疼痛 4") {
					partScore = 4;
				  } else if (field.boxLabel == "疼痛刺激屈曲 3") {
					partScore = 3;
				  }else if (field.boxLabel == "疼痛刺激伸直 2") {
					partScore = 2;
				  }
				  else {
					partScore = 1;
				  }
				  scoreItem.setValue(partScore);
				  scoreItem.focus();
				  return;
				}
			  });
			});
			break;
		case "Item15":
			partGroup.forEach(function (item, index, array) {
			  item.on("check", function (field, checked) {
				if (checked == true) {
				  if (field.boxLabel == "自动睁眼 4") {
					partScore = 4;
				  } else if (field.boxLabel == "呼之睁眼 3") {
					partScore = 3;
				  } else if (field.boxLabel == "刺痛睁眼 2") {
					partScore = 2;
				  } else {
					partScore = 1;
				  }
				  scoreItem.setValue(partScore);
				  scoreItem.focus();
				  return;
				}
			  });
			});	
			break;
		case "Item16":
			partGroup.forEach(function (item, index, array) {
			  item.on("check", function (field, checked) {
				if (checked == true) {
				  if (field.boxLabel == "回答正确 5") {
					partScore = 5;
				  } else if (field.boxLabel == "回答错误 4") {
					partScore = 4;
				  } else if (field.boxLabel == "答非所问 3") {
					partScore = 3;
				  } else if (field.boxLabel == "只能发音 2") {
					partScore = 2;
				  }
				  else {
					partScore = 1;
				  }
				  scoreItem.setValue(partScore);
				  scoreItem.focus();
				  return;
				}
			  });
			});
			break;
		case "Item17":
			partGroup.forEach(function (item, index, array) {
			  item.on("check", function (field, checked) {
				if (checked == true) {
				  if (field.boxLabel == "按嘱动作 6") {
					partScore = 6;
				  } else if (field.boxLabel == "刺痛定位 5") {
					partScore = 5;
				  } else if (field.boxLabel == "刺痛躲避 4") {
					partScore = 4;
				  } else if (field.boxLabel == "刺痛屈肢 3") {
					partScore = 3;
				  }else if (field.boxLabel == "不能伸肢 2") {
					partScore = 2;
				  }
				  else {
					partScore = 1;
				  }
				  scoreItem.setValue(partScore);
				  scoreItem.focus();
				  return;
				}
			  });
			});
			break;
  }
  
}
function butPrintFn() {
  PrintCommMultiPGD.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
  PrintCommMultiPGD.ItmName = prncode
  var subId=tkMakeServerCall("Nur.DHCMoudData","getMoudId",EpisodeID,linkCode);
  var recId=tkMakeServerCall("Nur.DHCMoudData","getLinkSubId",subId,EpisodeID,linkCode);     
  PrintCommMultiPGD.PgdAdm=EpisodeID;
  PrintCommMultiPGD.PrintRecId=recId;  
 
  PrintCommMultiPGD.MthArr= "Nur.DHCMoudDataSub:getVal1&parr:" + recId + "!flag:";
  PrintCommMultiPGD.xuflag = 0;
  
  PrintCommMultiPGD.PrintOut();
  PrintCommMultiPGD.PreView=1;

}

//S控件单选方法
function SMutualExclusion(start,end,selFlag,date){
	for(var i=start;i<end+1;i++){
			if(Ext.getCmp('Item'+i)){

				Ext.getCmp('Item'+i).on('focus',function(e){
					for(var y=start;y<end+1;y++){
						var array=new Array();
						array[y]='Item'+y;
						console.log(array[y]);
						Ext.getCmp(array[y]).setValue('');
						Ext.getCmp(array[y]).blur();
						
					}
					var itm=Ext.getCmp(e.id)
						itm.setValue('√');
						itm.blur();
						if(selFlag==0){
							Ext.getCmp('Item10').setValue(date.dateFormat('Y-m-d'));
							Ext.getCmp('Item11').setValue(date.dateFormat('H:i'));
							selFlag=1;
						}
			});
		}
	
	}
}