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
var subid="";
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

var ItemListener1 = ["Item22", "Item29", "Item36", "Item43", "Item50","Item57",  "Item8", "Item15", "Item295"]; //最后三个为日期Item，时间Item，责任护士Item
var ItemListener2 = ["Item23", "Item30", "Item37", "Item44", "Item51","Item58",  "Item9", "Item16", "Item296"];
var ItemListener3 = ["Item24", "Item31", "Item38", "Item45", "Item52", "Item59", "Item10", "Item17", "Item297"];
var ItemListener4 = ["Item25", "Item32", "Item39", "Item46", "Item53", "Item60", "Item11", "Item18", "Item298"];   
var ItemListener5 = ["Item26", "Item33", "Item40", "Item47", "Item54", "Item61", "Item12", "Item19", "Item299"]; 
var ItemListener6 = ["Item27", "Item34", "Item41", "Item48", "Item55", "Item62", "Item13", "Item20", "Item300"];
var ItemListener7 = ["Item28", "Item35", "Item42", "Item49", "Item56", "Item63", "Item14", "Item21", "Item301"]; 

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
  if (but) but.on('click', setprepagevalue);
  var but = Ext.getCmp("ButPageDown");
  if (but) but.on('click', setnextpagevalue);

  setvalue();
  if (userstr != "") {
    getuserha();
  }
  setzkinit(); //质控初始化
   
   for (var i = 0; i < ItemListener1.length - 3; i++) {
		var domobj = Ext.getCmp(ItemListener1[i]);
		if (domobj) domobj.on('select', itmHandler, this);
	}

	for (var i = 0; i < ItemListener2.length - 3; i++) {
		var domobj = Ext.getCmp(ItemListener2[i]);
		if (domobj) domobj.on('select', itmHandler, this);
	}

	for (var i = 0; i < ItemListener3.length - 3; i++) {
		var domobj = Ext.getCmp(ItemListener3[i]);
		if (domobj) domobj.on('select', itmHandler, this);
	}

	for (var i = 0; i < ItemListener4.length - 3; i++) {
		var domobj = Ext.getCmp(ItemListener4[i]);
		if (domobj) domobj.on('select', itmHandler, this);
	}
	for (var i = 0; i < ItemListener5.length - 3; i++) {
		var domobj = Ext.getCmp(ItemListener5[i]);
		if (domobj) domobj.on('select', itmHandler, this);
	}

	for (var i = 0; i < ItemListener6.length - 3; i++) {
		var domobj = Ext.getCmp(ItemListener6[i]);
		if (domobj) domobj.on('select', itmHandler, this);
	}
	for (var i = 0; i < ItemListener7.length - 3; i++) {
		var domobj = Ext.getCmp(ItemListener7[i]);
		if (domobj) domobj.on('select', itmHandler, this);
	}


	/*begin*****南方医院的搞特殊处理方法*********************/
	var selFlag=0;
	var date=new Date();
	for(var i=16;i<46;i++){
		if ((i>21)&&(i<25)) {
			continue;
		}
		if(Ext.getCmp('Item'+i)){
			Ext.getCmp('Item'+i).on('focus',function(e){
				var itm=Ext.getCmp(e.id);
				if(itm.value==''){
					itm.setValue('√');
					itm.blur();
					var dateValue=Ext.getCmp('Item8').getValue();
					var timeValue=Ext.getCmp('Item9').getValue();
					if ((dateValue!="")&&(timeValue!="")){
						selFlag=1;
					}
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
	/*end*******南方医院的搞特殊处理方法*********************/
}

function itmHandler(field) {
	var itmValue = field.value;
	var itmid = field.id;
	//alert(itmid);

	if (ItemListener1.indexOf(itmid) != -1) {
		//alert(11);
		if (Ext.getCmp(ItemListener1[ItemListener1.length - 3]).value == "") Ext.getCmp(ItemListener1[ItemListener1.length - 3]).setValue(formatDate(new Date()));
		if(Ext.getCmp(ItemListener1[ItemListener1.length-2]).value=="") Ext.getCmp(ItemListener1[ItemListener1.length-2]).setValue(getTime());
		Ext.getCmp(ItemListener1[ItemListener1.length - 1]).setValue(session['LOGON.USERNAME']);
	}

	else if (ItemListener2.indexOf(itmid) != -1) {
		if (Ext.getCmp(ItemListener2[ItemListener2.length - 3]).value == "") Ext.getCmp(ItemListener2[ItemListener2.length - 3]).setValue(formatDate(new Date()));
		if(Ext.getCmp(ItemListener2[ItemListener2.length-2]).value=="") Ext.getCmp(ItemListener2[ItemListener2.length-2]).setValue(getTime());
		Ext.getCmp(ItemListener2[ItemListener2.length - 1]).setValue(session['LOGON.USERNAME']);
	}

	else if (ItemListener3.indexOf(itmid) != -1) {
		if (Ext.getCmp(ItemListener3[ItemListener3.length - 3]).value == "") Ext.getCmp(ItemListener3[ItemListener3.length - 3]).setValue(formatDate(new Date()));
		if(Ext.getCmp(ItemListener3[ItemListener3.length-2]).value=="") Ext.getCmp(ItemListener3[ItemListener3.length-2]).setValue(getTime());
		Ext.getCmp(ItemListener3[ItemListener3.length - 1]).setValue(session['LOGON.USERNAME']);
	}

	else if (ItemListener4.indexOf(itmid) != -1) {
		if (Ext.getCmp(ItemListener4[ItemListener4.length - 3]).value == "") Ext.getCmp(ItemListener4[ItemListener4.length - 3]).setValue(formatDate(new Date()));
		if(Ext.getCmp(ItemListener4[ItemListener4.length-2]).value=="") Ext.getCmp(ItemListener4[ItemListener4.length-2]).setValue(getTime());
		Ext.getCmp(ItemListener4[ItemListener4.length - 1]).setValue(session['LOGON.USERNAME']);
	}
	else if (ItemListener5.indexOf(itmid) != -1) {
		if (Ext.getCmp(ItemListener5[ItemListener5.length - 3]).value == "") Ext.getCmp(ItemListener5[ItemListener5.length - 3]).setValue(formatDate(new Date()));
		if(Ext.getCmp(ItemListener5[ItemListener5.length-2]).value=="") Ext.getCmp(ItemListener5[ItemListener5.length-2]).setValue(getTime());
		Ext.getCmp(ItemListener5[ItemListener5.length - 1]).setValue(session['LOGON.USERNAME']);
	} 
	else if (ItemListener6.indexOf(itmid) != -1) {
		if (Ext.getCmp(ItemListener6[ItemListener6.length - 3]).value == "") Ext.getCmp(ItemListener6[ItemListener6.length - 3]).setValue(formatDate(new Date()));
		if(Ext.getCmp(ItemListener6[ItemListener6.length-2]).value=="") Ext.getCmp(ItemListener6[ItemListener6.length-2]).setValue(getTime());
		Ext.getCmp(ItemListener6[ItemListener6.length - 1]).setValue(session['LOGON.USERNAME']);
	}
	else if (ItemListener7.indexOf(itmid) != -1) {
		if (Ext.getCmp(ItemListener7[ItemListener7.length - 3]).value == "") Ext.getCmp(ItemListener7[ItemListener7.length - 3]).setValue(formatDate(new Date()));
		if(Ext.getCmp(ItemListener7[ItemListener7.length-2]).value=="") Ext.getCmp(ItemListener7[ItemListener7.length-2]).setValue(getTime());
		Ext.getCmp(ItemListener7[ItemListener7.length - 1]).setValue(session['LOGON.USERNAME']);
	}
}   
//生成图片
function MakePicture() {
  if (NurRecId == undefined) NurRecId = "";
  PrintCommPic.StartMakePic = "Y"; //图片
  PrintCommPic.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
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
function setvalueold() {
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
	//by lmm  增加年份保存
	var recDate = Ext.getCmp("Item8")    //评估日期Item
	var recYear="";
	if(recDate.getValue()!=""){
		recYear=formatDate(recDate.getValue()).split("-")[0]
	}
	var recYearObj = Ext.getCmp("Item50")  //新家的评估年份Item 元素不要超过345
	recYearObj.setValue(recYear);
	//end
  ret = "";
  checkret = "";
  comboret = "";
  radioret = "";
  var SaveRec = document.getElementById('Save');
  var gform = Ext.getCmp("gform");
  gform.items.each(eachItem1, this);
  ret + "&" + checkret + "&" + comboret;
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
  //alert(EpisodeID+"@"+Id)
  alert("保存成功");
  window.opener.find();
  window.close();
  window.opener.parent.window.initMainTree();
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
	sex.disable();
    var age = Ext.getCmp("Item3");
    age.setValue(getValueByCode(tt[6]));
    var patLoc = Ext.getCmp("Item4");
    patLoc.setValue(getValueByCode(tt[7]));
    var bedCode = Ext.getCmp("Item5");
    bedCode.setValue(getValueByCode(tt[5]));
    //var admdate = Ext.getCmp("Item7");
    //admdate.setValue(getValueByCode(tt[14]));
    var diag = Ext.getCmp("Item7");
    diag.setValue(getValueByCode(tt[8]));
    var MedCareNo = Ext.getCmp("Item6");
    MedCareNo.setValue(getValueByCode(tt[9]));
	var Nurse = Ext.getCmp("Item48");
    Nurse.setValue(session['LOGON.USERNAME']);
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

function butPrintFn1() {
  PrintCommPic.RHeadCaption = 'dddd';
  PrintCommPic.LHeadCaption = "3333333";
  PrintCommPic.SetConnectStr(CacheDB);
  PrintCommPic.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
  PrintCommPic.ItmName = prncode; //打印模板关联字段
  var parr = "@" + EpisodeID + "@EmrCode"; //界面模板关联字段
  PrintCommPic.MthArr = "web.DHCNurMouldDataComm:GetPrnValComm&parr:" + parr;
  PrintCommPic.PrintOut();
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
function butPrintFnOld() {
  PrintCommPic.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
  //var getid = document.getElementById('GetId');
  //var id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);
  PrintCommPic.ItmName = prncode;
  PrintCommPic.MthArr = "Nur.DHCMoudData:getVal2&id:" + currid + "!";
  PrintCommPic.PrintOut();
}