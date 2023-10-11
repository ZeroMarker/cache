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
var partArray = ["Item32", "Item33", "Item34", "Item35", "Item36", "Item37","Item38"];
var partScoreArray = ["Item44", "Item45", "Item46", "Item47", "Item48", "Item49","Item50"];
ScoreItem[0] = "^Item44^Item45^Item46^Item47^Item48^Item49^Item50^";
ValueItem[0] = "Item42";
NameItem[0] = "Item43";
DateItem[0] = "Item8";
TimeItem[0] = "Item26";
var prncode = "DHCNURMouldPrn_ETYCFXPGLB";

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
  totelmouth();
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
  var zf = Ext.getCmp("Item42");
  zf.setValue(getValueByCode(zongf));
  var fj = Ext.getCmp("Item8");
  fj.setValue(getValueByCode(fenj));
  var getuser = document.getElementById('getuser');
  var user = cspRunServerMethod(getuser.value, session['LOGON.USERID']);
  var tt5 = user.split('^');
  var qianm = Ext.getCmp("Item43");
  qianm.setValue(getValueByCode(tt5[0]));



}
var ITypItm = "Item51"; //后取数据字典型
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

  initEvents();    //加载总分功能

  setvalue();
  var tmpItm = Ext.getCmp("Item1")
  tmpItm.disable();
  var tmpItm = Ext.getCmp("Item2")
  tmpItm.disable();
  var tmpItm = Ext.getCmp("Item3")
  tmpItm.disable();
  var tmpItm = Ext.getCmp("Item4")
  tmpItm.disable();
  var tmpItm = Ext.getCmp("Item10")
  tmpItm.disable();
  var tmpItm = Ext.getCmp("Item11")
  tmpItm.disable();
  var tmpItm = Ext.getCmp("Item12")
  tmpItm.disable();
	//var tmpItm = Ext.getCmp("Item43")
  //tmpItm.disable();
  // var firstScore=Ext.getCmp("Item96_1")
  // firstScore.focus();
  //计算各项radio分数
  calScore("Item32", "Item44");
  calScore("Item33", "Item45");
  calScore("Item34", "Item46");
  calScore("Item35", "Item47");
  calScore("Item36", "Item48");
  calScore("Item37", "Item49");
  calScore("Item38", "Item50");
  // var diag = tkMakeServerCall("web.DHCMRDiagnosNew","GetPatListDiagnose",EpisodeID);
  // var DiagGroup = Ext.getCmp("Item8").items.items
    // if(diag){
	  // DiagGroup[0].setValue(true);
	// }else{
	  // DiagGroup[1].setValue(true);
	// }
	  
  // var fall = tkMakeServerCall("web.DHCADVINTERFACE","GetIfNurFallFlag",EpisodeID);
  // var fallGroup = Ext.getCmp("Item7").items.items
  // if(fall==1){
	  // fallGroup[0].setValue(true);
  // }else{
	  // fallGroup[1].setValue(true);
	// }
  
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
  var recYearObj = Ext.getCmp("Item51")  //新加的评估年份Item 元素不要超过345
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
}

function getPatInfo() {
  var PatInfo = document.getElementById('PatInfo');
  if (PatInfo) {
    var ret = cspRunServerMethod(PatInfo.value, EpisodeID);
    //alert(ret);
    var tt = ret.split('^');
    var patName = Ext.getCmp("Item1");
    patName.setValue(getValueByCode(tt[4]));
    var sex = Ext.getCmp("Item3");
    sex.setValue(getValueByCode(tt[3]));
    var  regno= Ext.getCmp("Item12");
    regno.setValue(getValueByCode(tt[0]));
    var age = Ext.getCmp("Item2");
    age.setValue(getValueByCode(tt[6]));
    var patLoc = Ext.getCmp("Item4");
    patLoc.setValue(getValueByCode(tt[7]));
    var bedCode = Ext.getCmp("Item10");
    bedCode.setValue(getValueByCode(tt[5]));
    var MedCareNo = Ext.getCmp("Item11");
    MedCareNo.setValue(getValueByCode(tt[9]));
    //	var diag = Ext.getCmp("Item13");
    //	diag.setValue(getValueByCode(tt[8]));
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
	case "Item32":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel =="1分:完全不能移动") {
            partScore = 1;
          } else if (field.boxLabel =="2分:非常受限") {
            partScore = 2;
          } else if (field.boxLabel =="3分:轻微受限") {
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
		break;
	case "Item33":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel =="1分：卧床") {
            partScore = 1;
          } else if (field.boxLabel =="2分：坐椅子") {
            partScore = 2;
          } else if (field.boxLabel =="3分：偶然步行") {
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
		break;
	case "Item34":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel =="1分：完全受限") {
            partScore = 1;
          } else if (field.boxLabel =="2分：大部分受限") {
            partScore = 2;
          } else if (field.boxLabel =="3分：轻度受限") {
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
		break;
	case "Item35":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel =="1分：持续潮湿") {
            partScore = 1;
          } else if (field.boxLabel =="2分：常常潮湿") {
            partScore = 2;
          } else if (field.boxLabel =="3分：偶尔潮湿") {
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
		break;
	case "Item36":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
           if (field.boxLabel =="1分：明显存在问题") {
            partScore = 1;
          } else if (field.boxLabel =="2分：存在问题") {
            partScore = 2;
          } else if (field.boxLabel =="3分：潜在问题") {
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
		break;
	case "Item37":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel =="1分：非常差") {
            partScore = 1;
          } else if (field.boxLabel =="2分：可能不足") {
            partScore = 2;
          } else if (field.boxLabel =="3分：充足") {
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
		break;
	case "Item38":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel =="1分：极度不足") {
            partScore = 1;
          } else if (field.boxLabel =="2分：不足") {
            partScore = 2;
          } else if (field.boxLabel =="3分：正常") {
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
		break;
  }
}
function butPrintFn() {
  PrintCommMultiPGD.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
  //var getid = document.getElementById('GetId');
  //var id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);
  PrintCommMultiPGD.ItmName = prncode;

  var recId=tkMakeServerCall("Nur.DHCMoudData","getLinkSubId",subid,EpisodeID,EmrCode);
	PrintCommMultiPGD.MthArr= "Nur.DHCMoudDataSub:getVal1&parr:" + recId + "!flag:";
  //alert()
  //PrintCommPic.MthArr = "Nur.DHCMoudData:getVal2&id:" + currid + "!";
  //PrintCommMultiPGD.MthArr = tmpMthArr;
  PrintCommMultiPGD.PrintOut();
}

