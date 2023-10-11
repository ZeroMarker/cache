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
var partArray = ["Item96", "Item97", "Item98", "Item99", "Item100", "Item101", "Item102", "Item103", "Item104", "Item105"];
var partScoreArray = ["Item27", "Item28", "Item29", "Item30", "Item31", "Item32", "Item33"];
ScoreItem[0] = "^Item27^Item28^Item29^Item30^Item31^Item32^Item33^";
ValueItem[0] = "Item19";
NameItem[0] = "Item20";
DateItem[0] = "Item6";
//TimeItem[0] = "Item91";
var prncode = "DHCNURMouldPrn_ZYHZYYSC";  //DHCNURMouldPrn_barthel2

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
  /*if (item.xtype == "checkbox") {
    //修改下拉框的请求地址    
    //debugger;
    if (item.checked == true) checkret = checkret + item.id + "|" + item.boxLabel + "^";
    // item.on('check',checksj);
  }*/
  if (item.xtype=="checkbox") {   
            //修改下拉框的请求地址    
				//debugger;
        if (item.checked==true) {
			checkret=checkret+item.id+"|"+item.boxLabel+"|"+item.boxLabel+"^";
		}
		else {checkret=checkret+item.id+"|"+"|"+item.boxLabel+""+"^";}
       item.on('check',scoregroup,this) 
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
function scoregroup (obj)
{ sum=0; 
 	var gform = Ext.getCmp("gform");
  gform.items.each(eachItem1,this); 
   //alert(checkret);
  var a1=checkret.split('^');
  var arrayobj=new Array();
  sum=0;
  var subSumItem12=0;
  var subSumItem13=0;
  var subSumItem14=0;
  var subSumItem15=0;
  var subSumItem16=0;
  var subSumItem17=0;
  var subSumItem18=0;
  for(i=0;i<a1.length-1;i++)
  {
   var a2=a1[i].split('|');
   var a3=a2[1]; 
   var curitem=a2[0];
   var a7=0;
   // alert(a3);   
   if (a3.indexOf("分")!="-1")
   {
     var a4=a3.split('分)');
     var a5=a4[0];
     var a6=a5.charAt(a5.length-1);
     a7=parseInt(a6[0]);   
	
   } 
   sum=sum+a7; 
   if(curitem.indexOf("Item12")!="-1"){
	   subSumItem12=subSumItem12+a7;
	    Ext.getCmp("Item27").setValue(subSumItem12)
   }
   if(curitem.indexOf("Item13")!="-1"){
	   subSumItem13=subSumItem13+a7;
	    Ext.getCmp("Item28").setValue(subSumItem13)
   }
   if(curitem.indexOf("Item14")!="-1"){
	   subSumItem14=subSumItem14+a7;
	    Ext.getCmp("Item29").setValue(subSumItem14)
   }
   if(curitem.indexOf("Item15")!="-1"){
	   subSumItem15=subSumItem15+a7;
	    Ext.getCmp("Item30").setValue(subSumItem15)
   }
   if(curitem.indexOf("Item16")!="-1"){
	   subSumItem16=subSumItem16+a7;
	    Ext.getCmp("Item31").setValue(subSumItem16)
   }
    if(curitem.indexOf("Item17")!="-1"){
	   subSumItem17=subSumItem17+a7;
	    Ext.getCmp("Item32").setValue(subSumItem17)
   }
    if(curitem.indexOf("Item18")!="-1"){
	   subSumItem18=subSumItem18+a7;
	    Ext.getCmp("Item33").setValue(subSumItem18)
   }
  } 

 
  //if (Item39value!="")
  //{
  //  sum=sum+parseInt(scoreFormat2(Item39value)); 
  //}
  //alert(Item39value); 
  //sum=sum+parseInt(scoreFormat2(Item39value)); 	
 // alert(RadioScore) 
  var sumscore = Ext.getCmp("Item19"); 
	CheckScore=sum;
	sumscore.setValue(sum);  
	checkret=""   
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
/*function checksj(item) {
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
  var zf = Ext.getCmp("Item12");
  zf.setValue(getValueByCode(zongf));
  var fj = Ext.getCmp("Item13");
  fj.setValue(getValueByCode(fenj));
  var getuser = document.getElementById('getuser');
  var user = cspRunServerMethod(getuser.value, session['LOGON.USERID']);
  var tt5 = user.split('^');
  var qianm = Ext.getCmp("Item14");
  qianm.setValue(getValueByCode(tt5[0]));



}*/
var ITypItm = "Item51"; //后取数据字典型
function BodyLoadHandler() {
	var Item12=Ext.getCmp("Item12"); 
    Item12.items.each(eachItem1,this); 
	var Item13=Ext.getCmp("Item13"); 
    Item13.items.each(eachItem1,this); 
	var Item14=Ext.getCmp("Item14"); 
    Item14.items.each(eachItem1,this); 
	var Item15=Ext.getCmp("Item15"); 
    Item15.items.each(eachItem1,this); 
	var Item16=Ext.getCmp("Item16"); 
    Item16.items.each(eachItem1,this); 
	var Item17=Ext.getCmp("Item17"); 
    Item17.items.each(eachItem1,this); 
	var Item18=Ext.getCmp("Item18"); 
    Item18.items.each(eachItem1,this); 
  var but = Ext.getCmp("butSave");
  but.on('click', Save);
  var but = Ext.getCmp("butPrint");
  but.on('click', butPrintFn);
  but.hide();
  var gform = Ext.getCmp("gform");
  gform.items.each(eachItem1, this);
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
  var tmpItm = Ext.getCmp("Item5")
  tmpItm.disable();
  var tmpItm = Ext.getCmp("Item6")
  //tmpItm.disable();
  // var firstScore=Ext.getCmp("Item96_1")
  // firstScore.focus();
  //计算各项radio分数
  calScore("Item92", "Item81");
  calScore("Item93", "Item82");
  calScore("Item94", "Item83");
  calScore("Item95", "Item84");
  calScore("Item96", "Item85");
  calScore("Item97", "Item86");
  calScore("Item98", "Item87");
  calScore("Item99", "Item88");
  calScore("Item100", "Item89");
  calScore("Item101", "Item90");
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
	//by lmm  增加年份保存
	var recDate = Ext.getCmp("Item6")    //评估日期Item
	var recYear="";
	if(recDate.getValue()!=""){
		recYear=formatDate(recDate.getValue()).split("-")[0]
	}
	var recYearObj = Ext.getCmp("Item39")  //新家的评估年份Item 元素不要超过345
	recYearObj.setValue(recYear);
	//end
	//alert(recYear)
  ret = "";
  checkret = "";
  comboret = "";
  radioret = "";
   //var SaveTime = document.getElementById('EmrTime');
   //var Time=new Date();
   //SaveTime.value=Time;
  //alert(Time);
  var SaveRec = document.getElementById('Save');
  var gform = Ext.getCmp("gform");
  gform.items.each(eachItem1, this);
  ret + "&" + checkret + "&" + comboret;
  //alert( ret + "&" + checkret + "&" + comboret)
  /*var arr = new Array("Item81","Item82","Item83","Item84","Item85","Item86","Item87","Item88","Item89","Item90");
  var count = 0;
  for(var i=0; i<arr.length; i++)
  {
	  var curitem=Ext.getCmp(arr[i]);
	  if ((curitem.value===0)||(curitem.value!=""))
	  {
		  count++;
	  }
  }
  if (count<arr.length)  
  {
	  alert("请确保所有评分项已填写");
	  return;
  }*/
  //alert(ret)
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
  window.opener.parent.window.initMainTree();
  window.close();
}

function getPatInfo() {
  var PatInfo = document.getElementById('PatInfo');
  if (PatInfo) {
    var ret = cspRunServerMethod(PatInfo.value, EpisodeID);
    //alert(ret);
    var tt = ret.split('^');
    var patName = Ext.getCmp("Item2");
    patName.setValue(getValueByCode(tt[4]));
    //var sex = Ext.getCmp("Item2");
    //sex.setValue(getValueByCode(tt[3]));
    //var  regno= Ext.getCmp("Item5");
    //regno.setValue(getValueByCode(tt[0]));
    var age = Ext.getCmp("Item3");
    age.setValue(getValueByCode(tt[6]));
    //var patLoc = Ext.getCmp("Item4");
    //patLoc.setValue(getValueByCode(tt[7]));
    var bedCode = Ext.getCmp("Item1");
    bedCode.setValue(getValueByCode(tt[5]));
    var MedCareNo = Ext.getCmp("Item5");
    MedCareNo.setValue(getValueByCode(tt[9]));
    var diag = Ext.getCmp("Item4");
    diag.setValue(getValueByCode(tt[8]));
	var selectDate=Ext.getCmp('Item6')
	selectDate.setValue(diffDate(new Date(), 0))
	var nurseSing=Ext.getCmp('Item20')
	nurseSing.setValue(session['LOGON.USERNAME'])
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
	case "Item12":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel == "完全独立") {
            partScore = 10;
          } else if (field.boxLabel == "需部分帮助") {
            partScore = 5;
          } else {
            partScore = 0;
          }
          scoreItem.setValue(partScore);
          scoreItem.focus();
          return;
        }
		});
		});
		break;
	case "Item93":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel == "完全独立") {
            partScore = 5;
          } else {
            partScore = 0;
          }
          scoreItem.setValue(partScore);
          scoreItem.focus();
          return;
        }
		});
		});
		break;
		case "Item94":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel == "完全独立") {
            partScore = 5;
          } else {
            partScore = 0;
          }
          scoreItem.setValue(partScore);
          scoreItem.focus();
          return;
        }
		});
		});
		break;
		case "Item95":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel == "完全独立") {
            partScore = 10;
          } else if (field.boxLabel == "需部分帮助") {
            partScore = 5;
          } else {
            partScore = 0;
          }
          scoreItem.setValue(partScore);
          scoreItem.focus();
          return;
        }
		});
		});
		break;
		case "Item96":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel == "完全独立") {
            partScore = 10;
          } else if (field.boxLabel == "需部分帮助") {
            partScore = 5;
          } else {
            partScore = 0;
          }
          scoreItem.setValue(partScore);
          scoreItem.focus();
          return;
        }
		});
		});
		break;
		case "Item97":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel == "完全独立") {
            partScore = 10;
          } else if (field.boxLabel == "需部分帮助") {
            partScore = 5;
          } else {
            partScore = 0;
          }
          scoreItem.setValue(partScore);
          scoreItem.focus();
          return;
        }
		});
		});
		break;
		case "Item98":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel == "完全独立") {
            partScore = 10;
          } else if (field.boxLabel == "需部分帮助") {
            partScore = 5;
          } else {
            partScore = 0;
          }
          scoreItem.setValue(partScore);
          scoreItem.focus();
          return;
        }
		});
		});
		break;
		case "Item100":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel == "完全独立") {
            partScore = 15;
          } else if (field.boxLabel == "需部分帮助") {
            partScore = 10;
          } else if (field.boxLabel == "需极大帮助") {
            partScore = 5;
          } else {
            partScore = 0;
          }
          scoreItem.setValue(partScore);
          scoreItem.focus();
          return;
        }
		});
		});
		break;
		case "Item101":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel == "完全独立") {
            partScore = 15;
          } else if (field.boxLabel == "需部分帮助") {
            partScore = 10;
          } else if (field.boxLabel == "需极大帮助") {
            partScore = 5;
          } else {
            partScore = 0;
          }
          scoreItem.setValue(partScore);
          scoreItem.focus();
          return;
        }
		});
		});
		break;
		case "Item99":
		partGroup.forEach(function (item, index, array) {
		item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel == "完全独立") {
            partScore = 10;
          } else if (field.boxLabel == "需部分帮助") {
            partScore = 5;
          } else {
            partScore = 0;
          }
          scoreItem.setValue(partScore);
          scoreItem.focus();
          return;
        }
		});
		});
		break;
  }
  

  /*if ((partItem == "Item104") || (partItem == "Item105")) {
    partGroup.forEach(function (item, index, array) {
      item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel == "完全独立") {
            partScore = 15;
          } else if (field.boxLabel == "需部分帮助") {
            partScore = 10;
          } else if (field.boxLabel == "需极大帮助") {
            partScore = 5;
          } else {
            partScore = 0;
          }
          scoreItem.setValue(partScore);
          scoreItem.focus();
          return;
        }
      });
    });
  } else {
    partGroup.forEach(function (item, index, array) {
      item.on("check", function (field, checked) {
        if (checked == true) {
          if (field.boxLabel == "完全独立") {
            partScore = 15;
          } else if (field.boxLabel == "需部分帮助") {
            partScore = 10;
          } else if (field.boxLabel == "需极大帮助") {
            partScore = 5;
          } else {
            partScore = 0;
          }
          scoreItem.setValue(partScore);
          scoreItem.focus();
          return;
        }
      });
    });
  }*/
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

