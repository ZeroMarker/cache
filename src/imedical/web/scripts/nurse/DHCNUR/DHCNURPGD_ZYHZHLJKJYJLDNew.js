var ret = "";
var checkret = "";
var comboret = "";
var radioret="";
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
//alert(ret);

	}
	if (item.xtype == "timefield") {
		//修改下拉框的请求地址    
		//debugger;
		ret = ret + item.id + "|" + item.getValue() + "^";
//alert(ret);
	}
	if (item.xtype == "combo") {
		//修改下拉框的请求地址    
		//debugger;
		comboret = comboret + item.id + "|" + item.getValue() + "!" + item.lastSelectionText + "^";
//alert(ret);
	}
	if (item.xtype=="radio") {  
   	    if (item.getValue()==true) radioret=radioret+item.id+"|"+item.boxLabel+"^";   
       // alert(radioret);
     } 
	if (item.xtype == "textfield") {
		//修改下拉框的请求地址    
		//debugger;
		ret = ret + item.id + "|" + item.getValue() + "^";
//alert(ret);
	}
	if (item.xtype == "textarea") {
		//修改下拉框的请求地址    
		ret = ret + item.id + "|" + item.getRawValue() + "^";
		//alert(ret);
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
	
	//InitEventZSK();
	// but.on('click',btclose);
	var but = Ext.getCmp("butSave");
	but.on('click', Save);
	var but = Ext.getCmp("butPrint");
	but.on('click', butPrintFn);
	but.hide();
	var but = Ext.getCmp("btnDelete");
	but.on('click', btnDeleteFn);
	//setVal2(ExamId);
	setvalue();
	if (userstr != "") {
		getuserha()
	}
	//setzkinit(); //质控初始化
	 autoDate("Item6", "Item4", "Item9");
	 autoDate("Item7", "Item5", "Item12");
	 autoDate("Item17", "Item15", "Item20");
	 autoDate("Item18", "Item16", "Item23");
	 autoDate("Item27", "Item25", "Item30");
     autoDate("Item28", "Item26", "Item33");
	 autoDate("Item37", "Item35", "Item40");
	 autoDate("Item38", "Item36", "Item43");
	 autoDate("Item47", "Item45", "Item50");
	 autoDate("Item48", "Item46", "Item53");
	 autoDate("Item57", "Item55", "Item60");
     autoDate("Item58", "Item56", "Item63");
	 autoDate("Item67", "Item65", "Item70");
	 autoDate("Item68", "Item66", "Item73");
	 autoDate("Item77", "Item75", "Item80");
	 autoDate("Item78", "Item76", "Item83");
	 autoDate("Item87", "Item85", "Item90");
     autoDate("Item88", "Item86", "Item93");
	 autoDate("Item97", "Item95", "Item100");
     autoDate("Item98", "Item96", "Item103");
	 autoDate("Item107", "Item105", "Item110");
     autoDate("Item108", "Item106","Item113");
	 autoDate("Item117", "Item115", "Item120");
     autoDate("Item118", "Item116", "Item123");
	 autoDate("Item127", "Item125", "Item130");
     autoDate("Item128", "Item126", "Item133");
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

function setvalue()
{
   //alert("cc");   
   /*var ha = new Hashtable();
   var getid=document.getElementById('GetId');
   var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
   //alert(id);

   //id=DHCMoudDataRowId; 
   //alert(id);   
   if (id != "") {
   	var getVal = document.getElementById('getVal');
   	var ret = cspRunServerMethod(getVal.value, id);
   	var tm = ret.split('^')
   // alert(tm);
		sethashvalue(ha, tm);
				
			}
			else {
				getPatInfo();
				return;
		
				}
			
	// debugger;
	 var gform=Ext.getCmp("gform");
   gform.items.each(eachItem, this);  
	 //  alert(a);
	 //alert(ht.keys())
	for (var i=0 ; i<ht.keys().length;i++)//for...in statement get all of Array's index
	{
		var key = ht.keys()[i];
		//alert(key)
		//restr += ht.items(key) + " " + ht.parent[key] + "<br/>";
		if (key.indexOf("_") == -1) 
		{
			//alert(key);
			var flag=ifflag(key );
			if (flag==true)
			{
				if (ha.contains(key)) setVal2(key ,ha.items(key));
				//debugger;
				continue;
			}
			var itm = Ext.getCmp(key);
			if (ha.contains(key)) 
			itm.setValue(getval(ha.items(key)));
			
	  }
	    else
	    {
			var aa=key.split('_');
			//alert(aa)
			if(ha.contains(aa[0]))
			{
			  setcheckvalue(key,ha.items(aa[0]));
			}
		}
    }*/
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
		// alert(ret);
		var tm = ret.split('^')
		  //alert(tm);
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

function Save()
{
 
  ret="";
  checkret="";
  comboret=""; 
  radioret="";

  var SaveRec=document.getElementById('Save'); 
  var getid=document.getElementById("GetId"); 
  //var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID); 
  //id=DHCMoudDataRowId;  
  //alert(id)
  var gform=Ext.getCmp("gform");
  gform.items.each(eachItem1, this);  
  //alert(EmrCode)
 //ret+"&"+checkret+"&"+comboret+"&"+radioret;
 // alert(checkret);
if (NurRecId==""){
 var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret+"&"+radioret,"");
 alert("已保存!");
}
else
{
  //alert(radioret); 
  var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret+"&"+radioret,NurRecId);
  if (Id!=="")
	{
        alert("已保存!");
    }
    else 
    {
        alert("保存失败!");
        return;
	  }  
 }
 if(window.opener){
	 window.opener.find();
  }
  if (window.opener) {
	  window.opener.parent.window.initMainTree();
  }
  window.close();
 
 //alert(NurRecId);

}
//生成图片
function MakePicture() {
	if (NurRecId == undefined) NurRecId = ""
	PrintCommPic.StartMakePic = "Y" //图片
	PrintCommPic.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
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
		//alert(ret);
		var tt = ret.split('^');
		var patName = Ext.getCmp("Item3");
		patName.setValue(getValueByCode(tt[4]));
		patName.disable();
		var patLoc = Ext.getCmp("Item1");
		patLoc.setValue(getValueByCode(tt[7]));
		patLoc.disable();
		var bedCode = Ext.getCmp("Item2");
		bedCode.setValue(getValueByCode(tt[5]));
		bedCode.disable();
		var age= Ext.getCmp("Item138");
		age.setValue(getValueByCode(tt[6]));
		var sex= Ext.getCmp("Item139");
		sex.setValue(getValueByCode(tt[3]));
		var MedCareNo = Ext.getCmp("Item140");
		MedCareNo.setValue(getValueByCode(tt[9]));
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
			PrintCommPic.RHeadCaption='dddd';
			PrintCommPic.LHeadCaption="3333333";
			PrintCommPic.SetConnectStr(CacheDB); 
			PrintCommPic.WebUrl=webIP+"/dthealth/web/DWR.DoctorRound.cls";
			PrintCommPic.ItmName = "DHCNURMouldPrn_HLJKJYJLDDY";
			var parr="@"+EpisodeID+"@DHCNURPGD_ZYHZHLJKJYJLD";
			PrintCommPic.MthArr="web.DHCNurMouldDataComm:GetPrnValComm&parr:"+parr;
			PrintCommPic.PrintOut();
}
function btnDeleteFn() {
	var getid=document.getElementById('GetId');
	var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID); 
	var flag = confirm("你确定要删除此条记录吗?");
		if (flag == true) {
			var ret =  tkMakeServerCall("Nur.DHCMoudData", "delete",id);
			window.location.reload();
		} else {
			return;
		}
	parent.window.initMainTree();
}

function autoDate(RadioItem,DateItem,NurseItem){
	//alert(RadioItem+"_1")
	Ext.getCmp(RadioItem+"_1").on('check',function(e){
			Ext.getCmp(DateItem).setValue(new Date().dateFormat('Y-m-d'));
			Ext.getCmp(NurseItem).setValue(session['LOGON.USERNAME']);
		});	
	Ext.getCmp(RadioItem+"_2").on('check',function(e){
			Ext.getCmp(DateItem).setValue(new Date().dateFormat('Y-m-d'));
			Ext.getCmp(NurseItem).setValue(session['LOGON.USERNAME']);
		});
}