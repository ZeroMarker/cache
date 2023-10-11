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

  setvalue();
  if (userstr != "") {
    getuserha();
  }
  setzkinit(); //质控初始化
}
var insrtCurrentId = "" //全局变量
function InitEventZSK() {
  var arrLength = arr.length;
  var zskObj;
  for (var i = 0; i < arrLength; ++i) {
    if ((arr[i].xtype == "textfield") || (arr[i].xtype == "textarea")) //文本框S及大文本框G
    {
      zskObj = Ext.getCmp(arr[i].id);
      zskObj.on('focus', GetItemId);
    }
  }
}

function GetItemId() {
  insrtCurrentId = this.id;
}

var dateArray = ["Item8&Item288", "Item9&Item289", "Item10&Item290", "Item11&Item291", "Item12&Item292", "Item13&Item293", "Item14&Item294"];

function SaveToTemp(field) {
  var objid = field.id;
  var index = objid.substring(objid.length - 1, objid.length);
  //alert(index);
  var str = dateArray[index - 1].split("&");
  var dateobj = Ext.getCmp(str[0]);
  var scoreobj = Ext.getCmp(str[1]);
  if (scoreobj.getValue() == "") {
    Ext.MessageBox.alert("提示", "请先填写分数");
    return;
  }
  if (dateobj.value == "") {
    Ext.MessageBox.alert("提示", "请先选择评估日期");
    return;
  }
  var wind = new Ext.Window({
    title: '保存至体温单',
    width: 200,
    height: 150,
    autoScroll: true,
    layout: 'absolute',
    items: [{
      name: 'B102',
      id: 'B102',
      tabIndex: '0',
      x: 19,
      y: 22,
      height: 16,
      width: 57,
      xtype: 'label',
      text: '时间点：'
    }, {
      name: 'TimePoint',
      id: 'TimePoint',
      tabIndex: '0',
      x: 75,
      y: 19,
      height: 20,
      width: 100,
      triggerAction: 'all',
      xtype: 'combo',
      store: new Ext.data.JsonStore({
        data: [{
          desc: '02:00',
          id: '02:00'
        }, {
          desc: '06:00',
          id: '06:00'
        }, {
          desc: '10:00',
          id: '10:00'
        }, {
          desc: '14:00',
          id: '14:00'
        }, {
          desc: '18:00',
          id: '18:00'
        }, {
          desc: '22:00',
          id: '22:00'
        }],
        fields: ['desc', 'id']
      }),
      displayField: 'desc',
      valueField: 'id',
      allowBlank: true,
      mode: 'local',
      value: ''
    }],
    buttons: [{
      text: '保存',
      handler: function() {
        var TimePoint = Ext.getCmp('TimePoint');
        if (TimePoint.value == "") {
          Ext.MessageBox.alert("提示", "请先选择时间点");
          return;
        }
        //alert(dateobj.value+"^"+scoreobj.getValue()+"^"+TimePoint.getValue());
        var temparr = "CareDate|" + dateobj.value + "^CareTime|" + TimePoint.getValue() + "^" + "Item35|" + scoreobj.getValue() + "^";
        //alert(temparr);
        var a = tkMakeServerCall("web.DHCThreeNew", "Save", EpisodeID, temparr, session['LOGON.USERID'], "", "", dateobj.value, TimePoint.getValue());
        //alert(a);
        wind.close();
      }
    }, {
      text: '取消',
      handler: function() {
        wind.close();
      }
    }]
  });
  wind.show();
}

function addPicture(filename, labelobj) {
  var src = WebIp + filename; //要加的图片路径
  var pictureBody = {

    xtype: 'box', //或者xtype: 'component',  

    width: 100, //图片宽度  

    height: 100, //图片高度 

    id: labelobj.id,

    x: 1,

    y: 1,

    autoEl: {

      tag: 'img', //指定为img标签  

      src: src //指定url路径  
    }
  }
  var gform = Ext.getCmp("gform");
  pictureBody.x = labelobj.x; //标签名
  pictureBody.y = labelobj.y; //标签名
  pictureBody.width = labelobj.width; //标签名
  pictureBody.height = labelobj.height; //标签名
  gform.remove("label"); //标签名
  gform.add(pictureBody);
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
      //getPatInfo();
    }
    else {
      //getPatInfo();
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
function setvalueOld() {
  //alert(ExamId);
  var ha = new Hashtable();
  var getid = document.getElementById('GetId');
  var id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);
  lastid = tkMakeServerCall("Nur.DHCMoudData", "GetManyRecId", EmrCode, EpisodeID, "", "0");
  var pages = tkMakeServerCall("Nur.DHCMoudData", "GetManyRecPages", EmrCode, EpisodeID, lastid, "0");
  var pagesobj = Ext.getCmp("pages");
  if (pagesobj) pagesobj.setValue(pages);
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
    if (pagesobj) pagesobj.setValue(pages);
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
  if (pagesobj) pagesobj.setValue(pages);

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
  if (pagesobj) pagesobj.setValue(pages);

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
  if (pagesobj) {
    pagesobj.setValue(page);
    page = pagesobj.getValue();
  }
  //var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
  id = tkMakeServerCall("Nur.DHCMoudData", "GetManyRecId", EmrCode, "", "", "");
  currid = "";
  if (id == "") {
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
  radioret = "";
  var SaveRec = document.getElementById('Save');
  var gform = Ext.getCmp("gform");
  gform.items.each(eachItem1, this);
  ret + "&" + checkret + "&" + comboret;
  var stid = NurRecId;
  if (NurRecId != "") {
    var Id = cspRunServerMethod(SaveRec.value, "^EmrUser|" + session['LOGON.USERID'] + "^EmrCode|" + EmrCode + "^" + ret + "^DetLocDr|" + session['LOGON.CTLOCID'] + "^EpisodeId|" + EpisodeID + "&" + checkret + "&" + comboret + "&" + radioret, NurRecId);
    currid = Id.split("||")[0];
	  
  }
  else {
    var Id = cspRunServerMethod(SaveRec.value, "^EmrUser|" + session['LOGON.USERID'] + "^EmrCode|" + EmrCode + "^" + ret + "^DetLocDr|" + session['LOGON.CTLOCID'] + "^EpisodeId|" + EpisodeID + "&" + checkret + "&" + comboret + "&" + radioret, "");
    var a=tkMakeServerCall("Nur.DHCNURSEMRKCLASSMETHOD","AutoFMJLD",Id); 
	if(a!="")
	{
		alert("分娩记录单同步成功！");
	}
	if (Id != "") {
      NurRecId = Id;
      subid=Id;
    }
  }
	//var a=tkMakeServerCall("Nur.DHCMoudData","AutoFMJLD",Id);
  //alert(Id);
   
  alert("保存成功");
    if(window.opener){
	 window.opener.find();
  }
  if (window.opener) {
	  window.opener.parent.window.initMainTree();
  }
  window.close();
}
function SaveOld() {
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
  } else if (newflag == "1") {

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

function getPatInfoOld() {
  //return ;
  var PatInfo = document.getElementById('PatInfo');
  if (PatInfo) {
    var ret = cspRunServerMethod(PatInfo.value, EpisodeID);
    var tt = ret.split('^');
	//alert(tt);
    var patName = Ext.getCmp("Item1");
    patName.setValue(getValueByCode(tt[4]));
    patName.disable();
    var sex = Ext.getCmp("Item2");
    sex.setValue(getValueByCode(tt[3]));
    var age = Ext.getCmp("Item3");
    age.setValue(getValueByCode(tt[6]));
    var patLoc = Ext.getCmp("Item6");
    patLoc.setValue(getValueByCode(tt[1]));
    var bedCode = Ext.getCmp("Item36");
    bedCode.setValue(getValueByCode(tt[5]));
    //var admdate = Ext.getCmp("Item7");
    //admdate.setValue(getValueByCode(tt[14]));
    var diag = Ext.getCmp("Item5");
    diag.setValue(getValueByCode(tt[8]));
    var MedCareNo = Ext.getCmp("Item4");
    MedCareNo.setValue(getValueByCode(tt[0]));
	var MedCareNo = Ext.getCmp("Item37");
    MedCareNo.setValue(getValueByCode(tt[9]));
  }
}
/*function getPatInfo() {
	//return ;
	var PatInfo = document.getElementById('PatInfo');
	if (PatInfo) {
		var ret = cspRunServerMethod(PatInfo.value, EpisodeID);
		//alert(ret);
		var tt = ret.split('^');
		var patName = Ext.getCmp("Item1");
		patName.setValue(getValueByCode(tt[4]));
		patName.disable();
		var patLoc = Ext.getCmp("Item4");
		patLoc.setValue(getValueByCode(tt[7]));
		var bedCode = Ext.getCmp("Item5");
		bedCode.setValue(getValueByCode(tt[5]));
		var MedCareNo = Ext.getCmp("Item6");
		MedCareNo.setValue(getValueByCode(tt[9]));
		var sex = Ext.getCmp("Item34");
		sex.setValue(getValueByCode(tt[3]));
		var age = Ext.getCmp("Item35");
		age.setValue(getValueByCode(tt[6]));
	}
}*/
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
		
		var patLoc = Ext.getCmp("Item2");
		patLoc.setValue(getValueByCode(tt[7]));
		var bedCode = Ext.getCmp("Item3");
		bedCode.setValue(getValueByCode(tt[5]));
		var MedCareNo = Ext.getCmp("Item4");
		MedCareNo.setValue(getValueByCode(tt[9]));
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

function butPrintFn1() {
  PrintCommPic.RHeadCaption = 'dddd';
  PrintCommPic.LHeadCaption = "3333333";
  PrintCommPic.SetConnectStr(CacheDB);
  PrintCommPic.WebUrl = WebIp + "/imedical/web/DWR.DoctorRound.cls";
  PrintCommPic.ItmName = prncode; //打印模板关联字段
  var parr = "@" + EpisodeID + "@EmrCode"; //界面模板关联字段
  PrintCommPic.MthArr = "web.DHCNurMouldDataComm:GetPrnValComm&parr:" + parr;
  PrintCommPic.PrintOut();
}

function butPrintFn() {
  PrintCommPic.WebUrl = WebIp + "/imedical/web/DWR.DoctorRound.cls";
  //var getid = document.getElementById('GetId');
  //var id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);
  PrintCommPic.ItmName = prncode;
  PrintCommPic.MthArr = "Nur.DHCMoudData:getVal2&id:" + NurRecId + "!";
  PrintCommPic.PrintOut();
}