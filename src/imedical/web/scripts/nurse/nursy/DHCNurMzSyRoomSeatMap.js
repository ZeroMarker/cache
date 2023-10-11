/**
 * @author Qse
 */
//document.write("<object ID='PrtBarcode' CLASSID='CLSID:55458D02-B281-4E68-9795-18FEDD54AD39' CODEBASE='../addins/client/OPInfusionPrint.CAB#version=1,0,0,16'>");
//document.write("</object>");

document.write("<script language='javascript' src='../scripts/nurse/DHCNUR/DHCNurPrintClickOnce.js'></script>");

var flag = "1";
var selectflag = "0";
var datatest = new Array();
var seatdata = new Array();
var cardtypedata = new Array();
var tool = [{
	id: "save"
}, {
	id: "help",
	handler: function() {
		aa(Ext.get("p1"))
	}
}, {
	id: "close"
}];
var loc = session['LOGON.CTLOCID'];
cspRunServerMethod(GetSeatCode, loc, "add");

function add(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10) {
	if (a9 == "") {
		//a8 = 'background-image:url(../images/bg_menu_a.jpg)';
		a8="";
	}
	datatest.push({
		id: a1,
		title: a2,
		header: false,
		width: parseInt(a3),
		height: parseInt(a4),
		bodyStyle: a8,
		frame: false,
		x: a5,
		y: a6,
		html: a9,
		tools: [{
			id: "close",
			qtip: "释放座位",
			handler: function() {
				ClearSeat1(Ext.get(a1))
			}
		}],
		padding: '15px'
	});
}

function setsize(gpl, fgm, grd) {
	var gfrm = Ext.getCmp(fgm);
	var fheight = gfrm.getHeight();
	var fwidth = gfrm.getWidth();
	var fm = Ext.getCmp(grd);
	var pl = Ext.getCmp(gpl);
	pl.setHeight(fheight);
	pl.setWidth(fwidth);
}
var arr1 = [{
	id: 'grid1pl',
	name: 'grid1pl',
	tabIndex: '0',
	x: 0,
	y: 0,
	autoScroll: true,
	height: 180,
	width: 531,
	xtype: 'panel',
	layout: 'absolute',
	border: false,
	items: datatest
}];
var form1 = new Ext.form.FormPanel({
	height: 200,
	width: 800,
	id: 'g1form',
	layout: 'absolute',
	items: arr1
});
Ext.onReady(function() {
	Ext.QuickTips.init();
	new Ext.Viewport({
		title: "容器组件",
		layout: 'absolute',
		autoScroll: true,
		resizable: false,
		items: form1 //datatest
	});
	var fheight = document.body.offsetHeight;
	var fwidth = document.body.offsetWidth;
	form1.setHeight(fheight);
	form1.setWidth(fwidth);
	Ext.getCmp('grid1pl').setHeight(fheight);
	Ext.getCmp('grid1pl').setWidth(fwidth);
	//setsize('grid1pl', 'g1form', null);
	flag = "0";
	//Ext.get("p1").addListener("click",aa(Ext.get("p1")),this);  
	var task = new Ext.util.DelayedTask();
	//Ext.get("p1").addListener("click",aa(Ext.get("p1")),this);  
	for (i = 0; i < datatest.length; i++) {
		dd = datatest[i].id;
		obj = Ext.get(dd);
		Ext.get(datatest[i].id).addListener("click", function() {
			//mouseevent(obj);
			task.delay(200, SetSeat, this, [this]);
			//SetSeat(this);
		});
		/*Ext.get(datatest[i].id).addListener("dblclick", function() {
			//mouseevent(obj);
			task.delay(200, jumpNurseExcute, this, [this]);
			//jumpNurseExcute(this);
		});*/
		Ext.get(datatest[i].id).addListener("contextmenu", rightClickFn);
		Ext.get(datatest[i].id).addListener("contextmenu",function(){
		var retStr=cspRunServerMethod(GetPatBySeatID,loc,this.id);
		if (retStr!=""){
		var ret=retStr.split("^");
		Adm=ret[0];
		}
   })
	}
})

var rightMenu = new Ext.menu.Menu({ 
             id:'rightclickCount', 
             items:[{ 
		      //id:'rMenu1', 
		      text:'护士执行', 
		      handler:jumpNurseExcute
			  
         }]
       })
function rightClickFn(client, e) {
	client.stopEvent();
	rightMenu.showAt(client.getXY());
}

// Ext.onReady(function() {
// 	Ext.QuickTips.init();
// 	new Ext.Viewport({
// 		title: "容器组件",
// 		layout: 'absolute',
// 		autoScroll: true,
// 		resizable: false,
// 		items: datatest
// 	});
// 	flag = "0";
// 	var task = new Ext.util.DelayedTask();
// 	//Ext.get("p1").addListener("click",aa(Ext.get("p1")),this);  
// 	for (i = 0; i < datatest.length; i++) {
// 		dd = datatest[i].id;
// 		obj = Ext.get(dd);
// 		Ext.get(datatest[i].id).addListener("click", function() {
// 			//mouseevent(obj);
// 			task.delay(200, SetSeat, this, [this]);
// 			//SetSeat(this);
// 		});
// 		Ext.get(datatest[i].id).addListener("dblclick", function() {
// 			//mouseevent(obj);
// 			task.delay(200, jumpNurseExcute, this, [this]);
// 			//jumpNurseExcute(this);
// 		});
// 	}
// })

setTimeout("beginrefresh()", 600000); //1000=1秒
function beginrefresh() {
	window.location.reload();
}
function mouseevent(e)
{
	//e.bodyStyle='backgroundColor:red;';
	//e.style.backgroundColor='#FFFF00';
	//e.applyStyles('backgroundColor:red;');
	//e.doLayout(); 
}  
//清空
function ClearSeat1(seat)
{ // alert(ClearSeat);
	cspRunServerMethod(ClearSeat,loc,seat.id,"Y",session['LOGON.USERID']);
	window.location.reload();
	//seat.bodyStyle='background-image:url(../images/bg_menu_a.jpg)';
	//seat.html="";
}
function jumpNurseExcute() {
	if (Adm == "") return;
	window.location.href="dhcnuropexecnew.csp?EpisodeID="+Adm+"&admType=OE&seatFlag=1&flowFlag=0";
}
function jumpNurseExcute0814(vv) {
	if (selectflag != 0) return;
	var curregno = "",
		currEpisodeId = "";
	var retStr = cspRunServerMethod(GetPatBySeatID, loc, vv.id);
	if (retStr != "") {
		var ret = retStr.split("^");
		if (ret.length > 1) {
			currEpisodeId = ret[0];
			curregno = ret[4];
			window.location.href="dhcnuropexecnew.csp?EpisodeID="+currEpisodeId;
		}
	}
}

function SetSeat(vv) {
	if (selectflag != 0)
		return;
	var seatdesc = "",
	curpatname = "",
	curcardtype = "",
	curcardno = "",
	curregno = "",
	patAdmDateTime = "";
	var retStr = cspRunServerMethod(GetPatBySeatID, loc, vv.id);
	if (retStr != "") {
		var ret = retStr.split("^");
		if (ret.length > 1) {
			curpatname = ret[1];
			curcardno = ret[2];
			seatdesc = ret[3];
			curregno = ret[4];
			EncryptLevel = ret[5];
			PatLevel = ret[6];
			patAdmDateTime = ret[7];
			var frm = parent.document.forms['fEPRMENU'];
			if(!frm){
				frm=opener.parent.parent.parent.document.forms['fEPRMENU'];
			}
			if(frm){
				frm.EpisodeID.value= ret[0];
			}
			
		}
	}
	
	seatdata = new Array();
	cspRunServerMethod(GetSeatList, loc, 'addseat');
	var storeseat = new Ext.data.JsonStore({
			data: seatdata,
			fields: ['changeseat', 'changeseatdes']
		});
	var changeseat = new Ext.form.ComboBox({
			id: 'changeseatsys',
			hiddenName: 'changeseat1',
			store: storeseat,
			width: 100,
			fieldLabel: '换座',
			valueField: 'changeseat',
			displayField: 'changeseatdes',
			allowBlank: true,
			autoSelect:true,
			forceSelection:true,
			selectOnFocus:true,
			mode: 'local',
			anchor: '83%'
		});
	var SeatFlag = new Ext.form.Checkbox({
			id: 'SeatPatFlag',
			boxLabel: '占座',
			checked: false,
			width: 10,
			fieldLabel: '是否占座',
			listeners: {
				check: function () {}
			}
		});
	///卡类型
	cardtypedata = new Array();
	//cspRunServerMethod(GetSeatList, loc, 'addcardtype');
	tkMakeServerCall("web.UDHCOPOtherLB", "ReadCardTypeDefineListBroker", 'addcardtype')
	var cardstore = new Ext.data.JsonStore({
			data: cardtypedata,
			fields: ['cardtypeid', 'cardtypedesc','carddefault','cardinfo']			
		});
	var cardtype = new Ext.form.ComboBox({
			id: 'cardtypes',
			hiddenName: 'cardtypes1',
			store: cardstore,
			width: 100,
			triggerAction: 'all', //很重要
			forceSelection: true,
			fieldLabel: '卡类型',
			valueField: 'cardtypeid',
			displayField: 'cardtypedesc',
			allowBlank: true,
			anchor: '83%',
			mode:'local'
			//value: cardstore.reader.jsonData[0].cardtypeid
		});
	var win = new Ext.Window({
			title: seatdesc,
			width: 355,
			height: 280,
			modal: true,
			resizable: false,
			bodyStyle: "padding:5px 5px 0",
			items: [{
					xtype: 'fieldset',
					title: '个人信息',
					collapsible: false,
					autoHeight: true,
					width: 330,
					defaults: {
						width: 150
					},
					defaultType: 'textfield',
					closeAction: 'hide',
					items: [
						cardtype, {
							fieldLabel: '卡号',
							name: 'CardNo',
							id: 'CardNo',
							value: curcardno
						}, {
							fieldLabel: '登记号',
							name: 'RegNo',
							id: 'RegNo',
							value: curregno
						}, {
							fieldLabel: '姓名',
							name: 'patname',
							id: 'patname',
							value: curpatname
						}, {
							fieldLabel: '来诊时间',
							name: 'patAdmDateTime',
							id: 'patAdmDateTime',
							value: patAdmDateTime
						}, changeseat]

					// {
					//       fieldLabel: '病人密级',
					//       name: 'EncryptLevel',
					//       id: 'EncryptLevel',
					//       value: EncryptLevel
					// },{
					//       fieldLabel: '病人级别',
					//       name: 'PatLevel',
					//       id: 'PatLevel',
					//       value: PatLevel
					// }
				}
			],
			buttonAlign: 'center',
			buttons: [{
					id:'readCardBtn',
					text: '读卡',
					icon: '../images/uiimages/readcard.png',
					iconCls:'no-repeat',
					handler: function () {
						ReadInsuCardInfo(vv.id, win, this)
					}
				}, {
					id:'arrageSeatBtn',
					text: '安排',
					icon: '../images/uiimages/lgsdz.png',
					iconCls:'no-repeat',
					handler: function () {
						arrangePat(vv.id, win, this)
					}
				}, {
					id:'cancelSeatBtn',
					text: '取消安排',
					iconCls:'no-repeat',
					icon: '../images/uiimages/cancel.png',
					handler: function () {
						ClearSeat1(vv)
					}
				}, {
					id:'printSeatNoBtn',
					text: '打印座位号',
					iconCls:'no-repeat',
					icon: '../images/uiimages/print.png',
					handler: function () {
						printSeatNo(vv.id, win, this)
					}
				}
			],
			maximizable: false
		});
	win.on('close', function () {
		selectflag = "0";
	}, this);
	win.show();
	var objcard = Ext.getCmp('cardtypes');
	objcard.focus();
	objcard.on('focus',function(){
		objcard.setValue(0);
		for(i=0;i<cardtypedata.length;i++){
			if(cardtypedata[i].carddefault=="Y"){
				objcard.setValue(cardtypedata[i].cardtypeid);
				break;
			}
		}		
	});
	//objcard.store.load()
	
	selectflag = "1";
	Ext.get("CardNo").on('keypress', function (e) {
		// 监听回车按键
		//getpatinfo(e,vv.id,win,this);
		if (e.getKey() == e.ENTER) {
			var CardTypeValue = Ext.getCmp("cardtypes").getValue();
			var isRegNoAsCardNo = tkMakeServerCall("web.DHCNurSyComm", "IsRegNoAsCardNo", CardTypeValue);
			if (isRegNoAsCardNo == "N") {
				var CardNovalue = document.getElementById("CardNo").value;
				if (CardNovalue.length < 12) {
					for (i = CardNovalue.length; i < 12; i++) {

						CardNovalue = "0" + CardNovalue
					}

				}
				document.getElementById("CardNo").value = CardNovalue
			} else {
				var CardNovalue = document.getElementById("CardNo").value;
				if (CardNovalue.length < 10) {
					for (i = CardNovalue.length; i < 10; i++) {

						CardNovalue = "0" + CardNovalue
					}

				}
				document.getElementById("CardNo").value = CardNovalue
			}
		}
		getpatinfo(e, vv.id, win, this);
	});
	var t = setInterval(function () {
			var el = document.getElementById('CardNo');
			if (el) {
				el.focus();
				clearInterval(t);
			}
		}, 20);
	Ext.get("RegNo").on('keypress', function (e) {
		// 监听回车按键
		getpatinfobyregno(e, vv.id, win, this);
	});
	Ext.get("changeseatsys").on('keydown', function (e) {
		if (e.getKey() == e.ENTER) {
			arrangePat(vv.id, win, this);
		}
	});

}
function printSeatNo_xml(id,win,curregno) {
	var objCardNo = document.getElementById('CardNo');
	var CardNo = objCardNo.value;
	var objRegNo = document.getElementById('RegNo');
	var RegNo = objRegNo.value;
	if (CardNo != "") {
		adm = cspRunServerMethod(GetCurrAdm, CardNo, "");
	} else {
		if (RegNo != "") adm = cspRunServerMethod(GetCurrAdm, "", RegNo);
	}
		//if (curregno != "") adm = cspRunServerMethod(GetCurrAdm, "", curregno);
		var AdmInfo = adm.split("^");
		//alert(AdmInfo[0]);
		//alert(CardNo+"--"+RegNo);
	//DHCCNursePrintComm.
	showNurseExcuteSheetPreview(AdmInfo[0], "OnePage", "O", "", session['WebIP'], "false", 1, "NurseOrderOP.xml");
}
function arrangePat(id, win, obj) {
	var oldId=id; //记录原来的座位ID
	var objCardNo = document.getElementById('CardNo');
	var CardNo = objCardNo.value;
	var objRegNo = document.getElementById('RegNo');
	var RegNo = objRegNo.value;
	if ((CardNo == "") && (RegNo == "")) {
		alert("请读卡或输入登记号")
		return;
		arrangeFreePat(id, win, obj);
		return;
	}
	if ((objCardNo) && (objCardNo.value.length == '28')) {
		var MagCardNo = objCardNo.value; //保留28位卡号
		var InfoStr = ReadINSUCard(MagCardNo);
		var InfoStrarr = InfoStr.split("|");
		if (InfoStrarr[0]) {
			var flag = InfoStrarr[0];
			var InsuCardType = InfoStrarr[1];
			var MedicareNumber = Trim(InfoStrarr[2]); //卡号
			var PatName = InfoStrarr[3];
			if (flag == '0') {
				if (objCardNo) objCardNo.value = MedicareNumber;
				CardNo = MedicareNumber;
				var objPatName = document.getElementById('patname');
				if (objPatName) objPatName.value = PatName;
			} else {
				Ext.MessageBox.alert('注意', '读卡失败,请检查卡!');
				return;
			}
		}
	}
	var adm = "";
	if (RegNo!="") adm =tkMakeServerCall("User.DHCNurSyPatRec","QueryPat",RegNo)
	if (adm==""){
		if (CardNo != "") {
			adm = cspRunServerMethod(GetCurrAdm, CardNo, "",session['LOGON.HOSPID'],session['LOGON.CTLOCID']);
		} else {
			if (RegNo != "") adm = cspRunServerMethod(GetCurrAdm, "", RegNo,session['LOGON.HOSPID'],session['LOGON.CTLOCID']);
		}
	}
	if (adm == "") {
		Ext.MessageBox.alert('注意', '病人没有就诊记录!');
		return;
	} else {
		var curAdm = "";
		var AdmInfo = adm.split("^");
		if (AdmInfo.length > 2) {
			curAdm = AdmInfo[0];
			var objPatName = document.getElementById("patname");
			if (objPatName) objPatName.value = AdmInfo[2];
			CardNo=AdmInfo[3];
		}
		var seatId = Ext.get("changeseat1").dom.value;
		if (seatId != "") id = seatId
		var parr = "^" + loc + "^" + CardNo + "^" + curAdm + "^" + id + "^" + session['LOGON.USERID'] + "^Y";
		var patStr = cspRunServerMethod(GetPatBySeatID, loc, id);
		var patArr = patStr.split("^");
		if (patArr[4] != "" && patArr[4] != null) {
			alert("座位已经有人!");
			return;
		}
		cspRunServerMethod(UpdateSeatFlag, id, "Y");
		cspRunServerMethod(SavePat, parr);
		if(oldId!=id)
			{
				///如果是换座清空之前座位上的信息。
				cspRunServerMethod(ClearSeat,loc,oldId,"Y",session['LOGON.USERID']);
			}
		//printSeatNo(id,win,obj);
		win.close();
		selectflag = "0";
		window.location.reload();
		//var eeee=Ext.get(id);
		//eeee.dolayout;
	}
}

function arrangePat0419(id,win,obj)
{   
	   var objCardNo=document.getElementById('CardNo');
	   var CardNo=objCardNo.value;
		 var objRegNo=document.getElementById('RegNo');
	   var RegNo=objRegNo.value;   
	   if ((CardNo=="")&&(RegNo=="")){
				arrangeFreePat(id,win,obj);
				return;
	   	}
		 if ((objCardNo)&&(objCardNo.value.length=='28')){
			var MagCardNo=objCardNo.value;      //保留28位卡号
		  var InfoStr=ReadINSUCard(MagCardNo);
  		var InfoStrarr=InfoStr.split("|");
  		if (InfoStrarr[0]){
  			var flag=InfoStrarr[0];
  			var InsuCardType=InfoStrarr[1];    
  			var MedicareNumber=Trim(InfoStrarr[2]);   //卡号
  			var PatName=InfoStrarr[3];
  			if (flag=='0'){
					if(objCardNo) objCardNo.value=MedicareNumber;
					CardNo=MedicareNumber;
					var objPatName=document.getElementById('patname');
					if(objPatName) objPatName.value=PatName;
				}else{
  				Ext.MessageBox.alert('注意', '读卡失败,请检查卡!');
  				return;
  			}
			}
		 }
	   var adm=cspRunServerMethod(GetCurrAdm,CardNo,"");
	   if (adm==""){
	   	Ext.MessageBox.alert('注意', '病人没有就诊记录!');
	   	return ;
	   }
	   else {
	   		var curAdm="";
	   		var AdmInfo=adm.split("^");
	   		if (AdmInfo.length>2){
	   			curAdm=AdmInfo[0];
	   			var objPatName=document.getElementById("patname");
					if(objPatName) objPatName.value=AdmInfo[2];
				}
				var seatId=Ext.get("changeseat1").dom.value;
				if (seatId!="") id=seatId
	   		var parr="^"+loc+"^"+CardNo+"^"+curAdm+"^"+id+"@"+AdmInfo[2]+"^"+session['LOGON.USERID']+"^Y";
	   		//alert(parr);
			cspRunServerMethod(UpdateSeatFlag,id,"Y");
	   		cspRunServerMethod(SavePat,parr);
	   		//printSeatNo(id,win,obj);
	   		win.close();
	   		selectflag="0";
	   		window.location.reload()   ;
	  } 
}

function arrangeFreePat(id, win, obj) {
	cspRunServerMethod(UpdateSeatFlag, id, "N");
	win.close();
	selectflag = "0";
	window.location.reload();
}

function getpatinfo(e, id, win, obj) {
	if (e.getKey() == e.ENTER && obj.getValue().length > 0) {
		var CardNo = obj.getValue();
		var objCardNo = document.getElementById('CardNo');
		if ((objCardNo) && (objCardNo.value.length == '28')) {
			var MagCardNo = objCardNo.value; //保留28位卡号
			var InfoStr = ReadINSUCard(MagCardNo);
			var InfoStrarr = InfoStr.split("|");
			if (InfoStrarr[0]) {
				var flag = InfoStrarr[0];
				var InsuCardType = InfoStrarr[1];
				var MedicareNumber = Trim(InfoStrarr[2]); //卡号
				var PatName = InfoStrarr[3];
				if (flag == '0') {
					if (objCardNo) objCardNo.value = MedicareNumber;
					CardNo = MedicareNumber;
					var objPatName = document.getElementById('patname');
					if (objPatName) objPatName.value = PatName;
				} else {
					Ext.MessageBox.alert('注意', '读卡失败,请检查卡!');
					return;
				}
			}
		 }
	   var adm=cspRunServerMethod(GetCurrAdm,CardNo,"",session['LOGON.HOSPID'],session['LOGON.CTLOCID']);
	   if (adm==""){
	   	Ext.MessageBox.alert('注意', '病人没有就诊记录!');
	   	return ;
	   }
	   else {
	   		var curAdm="";
	   		var AdmInfo=adm.split("^");
	   		if (AdmInfo.length>2){
	   			curAdm=AdmInfo[0];
	   			var objPatName=document.getElementById("patname");
					if(objPatName) objPatName.value=AdmInfo[2];
				}
	   		var parr="^"+loc+"^"+CardNo+"^"+curAdm+"^"+id+"^"+session['LOGON.USERID']+"^Y";
			var patStr=cspRunServerMethod(GetPatBySeatID,loc,id);
            var patArr=patStr.split("^") ;
            if(patArr[4]!=""&&patArr[4]!=null){
               alert("座位已经有人!");
		       return;
            }
			cspRunServerMethod(UpdateSeatFlag,id,"Y");
	   		cspRunServerMethod(SavePat,parr);
	   		//printSeatNo(id,win,obj);
	   		win.close();
	   		selectflag="0";
	   		window.location.reload()   ;
	  }
	}  
}
function getpatinfobyregno(e,id,win,obj)
{  
	if (e.getKey() == e.ENTER &&obj.getValue().length > 0) {   
	   var RegNo=obj.getValue();
	   var adm=cspRunServerMethod(GetCurrAdm,"",RegNo,session['LOGON.HOSPID'],session['LOGON.CTLOCID']);
	   if (adm==""){
	   	Ext.MessageBox.alert('注意', '病人没有就诊记录!');
	   	return ;
	   }
	   else {
	   		var curAdm="",CardNo="";
	   		var AdmInfo=adm.split("^");
	   		if (AdmInfo.length>2){
	   			curAdm=AdmInfo[0];
	   			var objPatName=document.getElementById("patname");
					if(objPatName) objPatName.value=AdmInfo[2];
				  var objRegNo=document.getElementById("RegNo");
					if(objRegNo) objRegNo.value=AdmInfo[1];
					CardNo=AdmInfo[3];
				}
	   		var parr="^"+loc+"^"+CardNo+"^"+curAdm+"^"+id+"^"+session['LOGON.USERID']+"^Y";
			var patStr=cspRunServerMethod(GetPatBySeatID,loc,id);
            var patArr=patStr.split("^") ;
            if(patArr[4]!=""&&patArr[4]!=null){
               alert("座位已经有人!");
		       return;
            }
			cspRunServerMethod(UpdateSeatFlag,id,"Y");
	   		cspRunServerMethod(SavePat,parr);
	   		//printSeatNo(id,win,obj);
	   		win.close();
	   		selectflag="0";
	   		window.location.reload()   ;
	  }
	}  
}
//window.location.reload()
function printSeatNo_ActiveXObject(id,win,obj)
{
    var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter;
    var path,fileName;
    path=cspRunServerMethod(GetPath);
    //fileName=path + "SYSeatNo.xls";
    var seatdesc="",curpatname="",curregno;
		var objPatName=document.getElementById("patname");
		if (objPatName) curpatname=objPatName.value;
		var objRegNo=document.getElementById("RegNo");
		if(objRegNo) curregno=objRegNo.value;
		if (win) seatdesc=win.title;
    //xlsExcel = new ActiveXObject("Excel.Application");
    //xlsBook = xlsExcel.Workbooks.Add(fileName);
    //xlsSheet = xlsBook.ActiveSheet;
    //xlsTop=1;xlsLeft=1;
	//xlsSheet.cells(1,2)=seatdesc;
    //xlsSheet.cells(2,2)=curpatname;
    //xlsSheet.cells(5,2)=seatdesc;
    //xlsSheet.cells(6,2)=curpatname;
	//xlsSheet.PrintOut
    //xlsSheet = null;
    //xlsBook.Close(savechanges=false)
    //xlsBook = null;
    //xlsExcel.Quit();
    //xlsExcel = null;
	var obj=new ActiveXObject("OPInfusionPrint.PrtBarcode");
	obj.PrinterName="waidai";
	obj.SetPrint();
	obj.PrintWirst(curregno+String.fromCharCode(10),curpatname,"","","","",seatdesc)
}
function printSeatNo(id,win,obj)
{
    var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter;
    var path,fileName;
    path=cspRunServerMethod(GetPath);
	    fileName=path + "SYSeatNo.xls";
	    var seatdesc="",curpatname="";
			var objPatName=document.getElementById("patname");
			if (objPatName) curpatname=objPatName.value;
			if (win) seatdesc=win.title;
	    xlsExcel = new ActiveXObject("Excel.Application");
	    try {
		    xlsBook = xlsExcel.Workbooks.Add(fileName);
		    xlsSheet = xlsBook.ActiveSheet;
		    xlsTop=1;xlsLeft=1;
				xlsSheet.cells(1,2)=seatdesc;
		    xlsSheet.cells(2,2)=curpatname;
		    xlsSheet.cells(5,2)=seatdesc;
		    xlsSheet.cells(6,2)=curpatname;
			  xlsSheet.PrintOut
		    xlsSheet = null;
		    xlsBook.Close(savechanges=false)
		    xlsBook = null;
		    xlsExcel.Quit();
		    xlsExcel = null;
		  }catch(e){
		  	Ext.MessageBox.alert('注意', '没有找到打印模板!');
				xlsExcel.Quit();
		    xlsExcel = null;
		  }
}
var m_SelectCardTypeDR="";
function ReadInsuCardInfo(id, win, obj) {
	var cardtypeid = Ext.getCmp('cardtypes').value;	
	console.log(Ext.getCmp('cardtypes').getPosition());
	var rowid=0
	for(i=0;cardtypedata.length;i++){
		if(cardtypedata[i].cardtypeid==cardtypeid){
			rowid=i;
			break
		}
	}
	var myoptval=cardtypedata[rowid].cardinfo;//DHCWeb_GetListBoxValue("CardTypeDefine");
	var CardTypeRowId=myoptval.split("^")[0];//combo_CardType.getSelectedValue();
	//通过读卡按钮时调用函数需要这个
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
	//var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	var leftmon=myary[3];
	//var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR);
	//var myary = myrtn.split("^");
	//var rtn = myary[0];
	//var leftmon = myary[3];
	var RegNoObj = document.getElementById('RegNo');
	switch (rtn) {
	case "0": //卡有效
		var obj = document.getElementById("RegNo");
		if (obj)
			obj.value = myary[5];
		var obj = document.getElementById("CardNo");
		if (obj){
			if( myary[1]!="undefined"){
				obj.value = myary[1];
			}else{
				Ext.MessageBox.alert('注意', '卡无效!');
				break;
			}			
		}
			
		arrangePat(id, win, obj);
		//printSeatNo(id,win,obj);
		break;
	case "-200": //卡无效
		Ext.MessageBox.alert('注意', '卡无效!');
		break;
	case "-201": //卡有效,账户无效
		var obj = document.getElementById("RegNo");
		if (obj)
			obj.value = myary[5];
		arrangePat(id, win, obj);
		//printSeatNo(id,win,obj);
		break;
	default:
	}
}

function ReadInsuCardInfoShangHai(id,win,obj){
	var InfoStr="";
	var flag="";
  var InsuCardType="";
	var MedicareNumber="";
	var PatName="";
  InfoStr=ReadINSUCard();
  var InfoStrarr=InfoStr.split("|");
  if (InfoStrarr[0]){
  	flag=InfoStrarr[0];
  	InsuCardType=InfoStrarr[1];    
  	MedicareNumber=Trim(InfoStrarr[2]);   //卡号
  	PatName=InfoStrarr[3];
  	if (flag=='0'){
			var objCardNo=document.getElementById('CardNo');
			if(objCardNo) objCardNo.value=MedicareNumber;
			var objPatName=document.getElementById('patname');
			if(objPatName) objPatName.value=PatName;		
  		var adm=cspRunServerMethod(GetCurrAdm,MedicareNumber,"");
	   	if (adm==""){
	   		Ext.MessageBox.alert('注意', '病人没有就诊记录!');
	   		return ;
	   	}
	   	else{
	   		var curAdm="",curPatName="";
	   		var AdmInfo=adm.split("^");
	   		if (AdmInfo.length>2){
	   			curAdm=AdmInfo[0];
	   			var objPatName=document.getElementById('patname');
					if(objPatName) objPatName.value=PatName;
					curPatName=AdmInfo[2];
				}
  			var parr="^"+loc+"^"+MedicareNumber+"^"+curAdm+"^"+id+"^"+session['LOGON.USERID']+"^Y";
  			cspRunServerMethod(UpdateSeatFlag,id,"Y");
			cspRunServerMethod(SavePat,parr);
	   		//printSeatNo(id,win,obj);
	   		win.close();
	   		selectflag="0";
	   		window.location.reload();
	   }
  	}else{
  		Ext.MessageBox.alert('注意', '读卡失败,请检查卡!');
  		return;
  	}
  }
}
function ReadINSUCard(CardNo)
{
    var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_SH");  
    var rtn=DHCINSUBLL.ReadCard(1,CardNo);
    return rtn;
}
function Trim(str)
{
	return str; //str.replace(/[\t\n\r ]/g, "");
}
function addseat(a1,a2)
{
	seatdata.push({
		changeseat: a1,
		changeseatdes: a2
	});
}

function addcardtype(a1,a2,a3,a4)
{
	cardtypedata.push({
		cardtypeid: a3.split("^")[0],
		cardtypedesc: a2,
		carddefault:a3.split("^")[8],
		cardinfo:a3
	});
}
