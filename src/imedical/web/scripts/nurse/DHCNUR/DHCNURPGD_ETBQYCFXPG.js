var ret = "";
var checkret = "";
var comboret = "";
var arrgrid = new Array();
var pfid = "";
var lastid = "";
var PrePageid = "";
var NextPageid = "";
var currid = "";
var newflag = 0;
var saveflag = "";
var page = 1;

var IfMakePic = "" //是否生成图片
var WillUpload = "" //是否上传ftp
var prnmode = tkMakeServerCall("User.DHCNURMoudelLink", "getPrintCode", EmrCode) //根据界面模板获取打印模板
var prnmcodes = ""
if (prnmode != "") {
  var prnarr = prnmode.split('|')
  prnmcodes = prnarr[0];
  IfMakePic = prnarr[3]; //是否生成图片
  WillUpload = prnarr[4]; //是否上传ftp
}
if (prnmode == "") {
  alert("请关联界面模板和打印模板!");
}
var prncode = prnmcodes; //打印模板名称

var scoreArray1 = ["Item8",  "Item63", "Item70", "Item77", "Item84",  "Item20", "Item19","Item22","Item18"]; //最后四个为总分Item，日期Item，时间Item，签名Item
var scoreArray2 = ["Item9",  "Item64", "Item71", "Item78", "Item85",  "Item111","Item57","Item51","Item306"];
var scoreArray3 = ["Item10", "Item65", "Item72", "Item79", "Item86",  "Item112","Item58","Item52","Item307"];
var scoreArray4 = ["Item11", "Item66", "Item73", "Item80", "Item87",  "Item113","Item59","Item53","Item308"];
var scoreArray5 = ["Item12", "Item67", "Item74", "Item81", "Item88",  "Item114","Item60","Item54","Item309"];
var scoreArray6 = ["Item13", "Item68", "Item75", "Item82", "Item89",  "Item115","Item61","Item55","Item310"];
var scoreArray7 = ["Item14", "Item69", "Item76", "Item83", "Item90",  "Item116","Item62","Item56","Item311"];

function formatDate(value) {
  try {
    return value ? value.dateFormat('Y-m-d') : '';
  } catch (err) {
    return '';
  }
};

function getTime(){
  var date=new Date();
  var hour=date.getHours();
  if(hour<10){
    hour="0"+hour;
  }
  var minute=date.getMinutes();
  if(minute<10){
    minute="0"+minute;
  }
  return hour+":"+minute;
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


var getid = document.getElementById('GetId');
var id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);
if (id != "") {
  // var idstr=tkMakeServerCall("Nur.DHCMoudData", "GetXSEXWPFId",id);

  //pfid=idstr;
  //ycid=aa[1]; 
}
var code = "";

var ITypItm = ""; //后取数据字典型
function BodyLoadHandler() {

  var but = Ext.getCmp("butSave");
  but.on('click', Save);
  var but = Ext.getCmp("butPrint");
  but.on('click', butPrintFn);

  var patName = Ext.getCmp("Item1");
  patName.disable();

  var but = Ext.getCmp("ButPageUp");
  but.on('click', setprepagevalue);
  var but = Ext.getCmp("ButPageDown");
  but.on('click', setnextpagevalue);

  setvalue();
  if (userstr != "") {
    getuserha();
  }
  setzkinit(); //质控初始化
for (var i = 0; i < scoreArray1.length - 4; i++) {
    var domobj = Ext.getCmp(scoreArray1[i]);
    if (domobj) domobj.on('select', scoreAdd, this)
  }
  for (var i = 0; i < scoreArray2.length - 4; i++) {
    var domobj = Ext.getCmp(scoreArray2[i]);
    if (domobj) domobj.on('select', scoreAdd, this)
  }
  for (var i = 0; i < scoreArray3.length - 4; i++) {
    var domobj = Ext.getCmp(scoreArray3[i]);
    if (domobj) domobj.on('select', scoreAdd, this)
  }
  for (var i = 0; i < scoreArray4.length - 4; i++) {
    var domobj = Ext.getCmp(scoreArray4[i]);
    if (domobj) domobj.on('select', scoreAdd, this)
  }
  for (var i = 0; i < scoreArray5.length - 4; i++) {
    var domobj = Ext.getCmp(scoreArray5[i]);
    if (domobj) domobj.on('select', scoreAdd, this)
  }
  for (var i = 0; i < scoreArray6.length - 4; i++) {
    var domobj = Ext.getCmp(scoreArray6[i]);
    if (domobj) domobj.on('select', scoreAdd, this)
  }

  for (var i = 0; i < scoreArray7.length - 4; i++) {
    var domobj = Ext.getCmp(scoreArray7[i]);
    if (domobj) domobj.on('select', scoreAdd, this)
  }
}


function scoreAdd(field){
  var itmid=field.id;
  var score=0;
  if(scoreArray1.indexOf(itmid)!=-1){
    for(var i=0;i<scoreArray1.length- 4;i++){
      var domobj=Ext.getCmp(scoreArray1[i]);
      if(domobj.getValue()!="") score=score+parseInt(domobj.getValue());
    }
    Ext.getCmp(scoreArray1[scoreArray1.length- 4]).setValue(score);
    if(Ext.getCmp(scoreArray1[scoreArray1.length- 3]).value=="") Ext.getCmp(scoreArray1[scoreArray1.length- 3]).setValue(formatDate(new Date()));
    if(Ext.getCmp(scoreArray1[scoreArray1.length- 2]).value=="") Ext.getCmp(scoreArray1[scoreArray1.length- 2]).setValue(getTime());
    Ext.getCmp(scoreArray1[scoreArray1.length-1]).setValue(session['LOGON.USERNAME']);
  }
  else if(scoreArray2.indexOf(itmid)!=-1){
    for(var i=0;i<scoreArray2.length- 4;i++){
      var domobj=Ext.getCmp(scoreArray2[i]);
      if(domobj.getValue()!="") score=score+parseInt(domobj.getValue());
    }
    Ext.getCmp(scoreArray2[scoreArray2.length- 4]).setValue(score);
    if(Ext.getCmp(scoreArray2[scoreArray2.length- 3]).value=="") Ext.getCmp(scoreArray2[scoreArray2.length- 3]).setValue(formatDate(new Date()));
    if(Ext.getCmp(scoreArray2[scoreArray2.length- 2]).value=="") Ext.getCmp(scoreArray2[scoreArray2.length- 2]).setValue(getTime());
    Ext.getCmp(scoreArray2[scoreArray2.length-1]).setValue(session['LOGON.USERNAME']);
  }
  else if(scoreArray3.indexOf(itmid)!=-1){
    for(var i=0;i<scoreArray3.length- 4;i++){
      var domobj=Ext.getCmp(scoreArray3[i]);
      if(domobj.getValue()!="") score=score+parseInt(domobj.getValue());
    }
    Ext.getCmp(scoreArray3[scoreArray3.length- 4]).setValue(score);
    if(Ext.getCmp(scoreArray3[scoreArray3.length- 3]).value=="") Ext.getCmp(scoreArray3[scoreArray3.length- 3]).setValue(formatDate(new Date()));
    if(Ext.getCmp(scoreArray3[scoreArray3.length- 2]).value=="") Ext.getCmp(scoreArray3[scoreArray3.length- 2]).setValue(getTime());
    Ext.getCmp(scoreArray3[scoreArray3.length-1]).setValue(session['LOGON.USERNAME']);
  }
  else if(scoreArray4.indexOf(itmid)!=-1){
    for(var i=0;i<scoreArray4.length- 4;i++){
      var domobj=Ext.getCmp(scoreArray4[i]);
      if(domobj.getValue()!="") score=score+parseInt(domobj.getValue());
    }
    Ext.getCmp(scoreArray4[scoreArray4.length- 4]).setValue(score);
    if(Ext.getCmp(scoreArray4[scoreArray4.length- 3]).value=="") Ext.getCmp(scoreArray4[scoreArray4.length- 3]).setValue(formatDate(new Date()));
    if(Ext.getCmp(scoreArray4[scoreArray4.length- 2]).value=="") Ext.getCmp(scoreArray4[scoreArray4.length- 2]).setValue(getTime());
    Ext.getCmp(scoreArray4[scoreArray4.length-1]).setValue(session['LOGON.USERNAME']);
  }
  else if(scoreArray5.indexOf(itmid)!=-1){
    for(var i=0;i<scoreArray5.length- 4;i++){
      var domobj=Ext.getCmp(scoreArray5[i]);
      if(domobj.getValue()!="") score=score+parseInt(domobj.getValue());
    }
    Ext.getCmp(scoreArray5[scoreArray5.length- 4]).setValue(score);
    if(Ext.getCmp(scoreArray5[scoreArray5.length- 3]).value=="") Ext.getCmp(scoreArray5[scoreArray5.length- 3]).setValue(formatDate(new Date()));
    if(Ext.getCmp(scoreArray5[scoreArray5.length- 2]).value=="") Ext.getCmp(scoreArray5[scoreArray5.length- 2]).setValue(getTime());
    Ext.getCmp(scoreArray5[scoreArray5.length-1]).setValue(session['LOGON.USERNAME']);
  }
  else if(scoreArray6.indexOf(itmid)!=-1){
    for(var i=0;i<scoreArray6.length- 4;i++){
      var domobj=Ext.getCmp(scoreArray6[i]);
      if(domobj.getValue()!="") score=score+parseInt(domobj.getValue());
    }
    Ext.getCmp(scoreArray6[scoreArray6.length- 4]).setValue(score);
    if(Ext.getCmp(scoreArray6[scoreArray6.length- 3]).value=="") Ext.getCmp(scoreArray6[scoreArray6.length- 3]).setValue(formatDate(new Date()));
    if(Ext.getCmp(scoreArray6[scoreArray6.length- 2]).value=="") Ext.getCmp(scoreArray6[scoreArray6.length- 2]).setValue(getTime());
    Ext.getCmp(scoreArray6[scoreArray6.length-1]).setValue(session['LOGON.USERNAME']);
  }
  else if(scoreArray7.indexOf(itmid)!=-1){
    for(var i=0;i<scoreArray7.length- 4;i++){
      var domobj=Ext.getCmp(scoreArray7[i]);
      if(domobj.getValue()!="") score=score+parseInt(domobj.getValue());
    }
    Ext.getCmp(scoreArray7[scoreArray7.length- 4]).setValue(score);
    if(Ext.getCmp(scoreArray7[scoreArray7.length- 3]).value=="") Ext.getCmp(scoreArray7[scoreArray7.length- 3]).setValue(formatDate(new Date()));
    if(Ext.getCmp(scoreArray7[scoreArray7.length- 2]).value=="") Ext.getCmp(scoreArray7[scoreArray7.length- 2]).setValue(getTime());
    Ext.getCmp(scoreArray7[scoreArray7.length-1]).setValue(session['LOGON.USERNAME']);
  }
}

//生成图片
function MakePicture() {
  if (NurRecId == undefined) NurRecId = "";
  PrintCommPic.StartMakePic = "Y"; //图片
  PrintCommPic.WebUrl = WebIp + "/imedical/web/DWR.DoctorRound.cls";
  PrintCommPic.ItmName = prncode; //打印模板名称
  var parr = "@" + EpisodeID + "@" + EmrCode;
  PrintCommPic.MthArr = "web.DHCNurMouldDataComm:GetPrnValComm&parr:" + parr;
  PrintCommPic.PrintOut();
  PrintCommPic.NurRecId = NurRecId; //图片
  PrintCommPic.EmrCode = EmrCode; //图片
  PrintCommPic.EpisodeID = EpisodeID; //图片
  PrintCommPic.MakeTemp = "Y"; //图片
  PrintCommPic.filepath = WebIp + "/DHCMG/HLBLMakePictureSet.xml"; //图片
  PrintCommPic.MakePicture(); //图片
  //alert(page)

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
    //  alert(ret);

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
    //  alert(ret);

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
  lastid = tkMakeServerCall("Nur.DHCMoudData", "GetManyRecId", EmrCode, EpisodeID, "", "0");
  var pages = tkMakeServerCall("Nur.DHCMoudData", "GetManyRecPages", EmrCode, EpisodeID, lastid, "0");
  var pagesobj = Ext.getCmp("pages");
  pagesobj.setValue(pages);
  if (lastid != "") {
    id = lastid;
    currid = lastid;
  } else {
    id = "";
  }
  if (id != "") {
    var getVal = document.getElementById('getVal');
    var ret = cspRunServerMethod(getVal.value, id);
    //  alert(ret);
    var tm = ret.split('^')
      //alert(tm);
    sethashvalue(ha, tm);

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
        setcheckvalue1(key, ha.items(aa[0]));
      }
    }
  }

}

function setprepagevalue() {

  var ha = new Hashtable();
  var getid = document.getElementById('GetId');
  var id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);
  // alert(currid)
  if (currid != "") PrePageid = tkMakeServerCall("Nur.DHCMoudData", "GetManyRecId", EmrCode, EpisodeID, currid, "1");
  else PrePageid = tkMakeServerCall("Nur.DHCMoudData", "GetManyRecId", EmrCode, EpisodeID, currid, "0");

  /*
      {
    Ext.Msg.show({    
         title:'确认一下',    
         msg: '记录没保存，是否离开当前页？',    
         buttons:{"ok":"是     ","cancel":"  否"},
         fn:  function(btn, text){    
              if (btn == 'ok'){   
             PrePageid=tkMakeServerCall("Nur.DHCMoudData", "GetManyRecId",EmrCode,EpisodeID,currid,"0");
              
              }
                     else
              {   return;   }
              
          },    
         animEl: 'newbutton'   
         });    
    
  }
   */
  if (PrePageid != "") {
    id = PrePageid;
    currid = PrePageid;
    var pages = tkMakeServerCall("Nur.DHCMoudData", "GetManyRecPages", EmrCode, EpisodeID, PrePageid, "0");
    var pagesobj = Ext.getCmp("pages");
    pagesobj.setValue(pages);
  } else {
    alert("没有记录！");
    return;
  }

  if (id != "") {
    var getVal = document.getElementById('getVal');
    var ret = cspRunServerMethod(getVal.value, id);
    var tm = ret.split('^');

    //alert(currid+"^"+id+"^"+tm)
    sethashvalue(ha, tm);
  }

  var gform = Ext.getCmp("gform");
  gform.items.each(eachItem, this);

  for (var i = 0; i < ht.keys().length; i++) //for...in statement get all of Array's index
  {
    var key = ht.keys()[i];

    if (key.indexOf("_") == -1) {

      var flag = ifflag(key); //界面显示
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

function setnextpagevalue() {

  var ha = new Hashtable();
  var getid = document.getElementById('GetId');
  var id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);
  NextPageid = tkMakeServerCall("Nur.DHCMoudData", "GetManyRecId", EmrCode, EpisodeID, currid, "2");
  var pages = tkMakeServerCall("Nur.DHCMoudData", "GetManyRecPages", EmrCode, EpisodeID, NextPageid, "0");
  var pagesobj = Ext.getCmp("pages");
  pagesobj.setValue(pages);

  if (NextPageid != "") {
    id = NextPageid;
    currid = NextPageid;
  } else {
    Ext.Msg.show({
      title: '确认一下',
      msg: '没有记录，是否新建？',
      buttons: {
        "ok": "是",
        "cancel": "否"
      },
      fn: function(btn, text) {
        if (btn == 'ok') {
          id = "";
          page = parseInt(pages) + 1;
          setnewvalue();

        } else {
          //var pagesobj=Ext.getCmp("pages");
          //pagesobj.setValue(page);
          return;
        }

      },
      animEl: 'newbutton'
    });

    return;
  }
  //if(refreshflag =="0") id="";
  if (id != "") {
    var getVal = document.getElementById('getVal');
    var ret = cspRunServerMethod(getVal.value, id);
    var tm = ret.split('^');
    //alert(currid+"^"+id+"^"+tm)
    sethashvalue(ha, tm);
  } else {

    getPatInfo();
    return;
  }
  //存在下一页
  var gform = Ext.getCmp("gform");
  gform.items.each(eachItem, this);

  for (var i = 0; i < ht.keys().length; i++) //for...in statement get all of Array's index
  {
    var key = ht.keys()[i];

    if (key.indexOf("_") == -1) {

      var flag = ifflag(key); //界面显示
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

function setcurrvalue() {

  var ha = new Hashtable();
  var getid = document.getElementById('GetId');
  var id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);
  var pages = tkMakeServerCall("Nur.DHCMoudData", "GetManyRecPages", EmrCode, EpisodeID, currid, "0");
  var pagesobj = Ext.getCmp("pages");
  pagesobj.setValue(pages);

  if (currid != "") {
    id = currid;
    //currid=lastid;
  }

  if (id != "") {
    var getVal = document.getElementById('getVal');
    var ret = cspRunServerMethod(getVal.value, id);
    var tm = ret.split('^');
    //alert(id+"^"+tm)
    sethashvalue(ha, tm);
  }

  var gform = Ext.getCmp("gform");
  gform.items.each(eachItem, this);

  for (var i = 0; i < ht.keys().length; i++) //for...in statement get all of Array's index
  {
    var key = ht.keys()[i];

    if (key.indexOf("_") == -1) {

      var flag = ifflag(key); //界面显示
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

function setnewvalue() {

  var ha = new Hashtable();
  var getid = document.getElementById('GetId');
  var pagesobj = Ext.getCmp("pages");
  pagesobj.setValue(page);
  page = pagesobj.getValue();
  //var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
  id = tkMakeServerCall("Nur.DHCMoudData", "GetManyRecId", EmrCode, "", "", "");
  currid = "";
  if (id == "")
  {
    id = tkMakeServerCall("Nur.DHCMoudData", "SaveManRecBlankRec", EmrCode, session['LOGON.USERID']);
  }
  newflag = "1";
  if (id != "") {
    var getVal = document.getElementById('getVal');
    var ret = cspRunServerMethod(getVal.value, id);
    var tm = ret.split('^');

    //alert(currid+"^"+id+"^"+tm)
    sethashvalue(ha, tm);
  }

  var gform = Ext.getCmp("gform");
  gform.items.each(eachItem, this);

  for (var i = 0; i < ht.keys().length; i++) //for...in statement get all of Array's index
  {
    var key = ht.keys()[i];

    if (key.indexOf("_") == -1) {

      var flag = ifflag(key); //界面显示
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
  getPatInfo();
}

function getval(itm) {
  var tm = itm.split('!');
  //  alert(tm)
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
  var SaveRec = document.getElementById('Save');
  var gform = Ext.getCmp("gform");
  gform.items.each(eachItem1, this);
  if ((currid != "") && (newflag != "1")) {
    id = currid;
  } else if(newflag=="1"){

  } else {
    id = "";
  }
  if (id != "") {
    var Id = cspRunServerMethod(SaveRec.value, "^EmrUser|" + session['LOGON.USERID'] + "^EmrCode|" + EmrCode + "^" + ret + "^DetLocDr|" + session['LOGON.CTLOCID'] + "^EpisodeId|" + EpisodeID + "&" + checkret + "&" + comboret, id);
  } else {
    var Id = cspRunServerMethod(SaveRec.value, "^EmrUser|" + session['LOGON.USERID'] + "^EmrCode|" + EmrCode + "^" + ret + "^DetLocDr|" + session['LOGON.CTLOCID'] + "^EpisodeId|" + EpisodeID + "&" + checkret + "&" + comboret, "");

  }
  if (Id != "") {
    alert("保存成功！");
    if (id = "") saveflag = "0";
    currid = Id;
    setcurrvalue();
  } else {
    alert("保存失败");
    return
  }

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
    var diag = Ext.getCmp("Item7");
    diag.setValue(getValueByCode(tt[8]));
    var MedCareNo = Ext.getCmp("Item6");
    MedCareNo.setValue(getValueByCode(tt[9]));
  }
  var arr=tkMakeServerCall("web.DHCMGNurComm","getPatAdmInfo",EpisodeID);
	
    var zycs=arr.split("^");
	var Item2= Ext.getCmp("Item2");
    Item2.setValue(getValueByCode(zycs[0]));
	Item2.disable();
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
  //var getid = document.getElementById('GetId');
  //var id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);
  PrintCommPic.ItmName = prncode;
  PrintCommPic.MthArr = "Nur.DHCMoudData:getVal2&id:" + currid + "!";
  PrintCommPic.PrintOut();
}