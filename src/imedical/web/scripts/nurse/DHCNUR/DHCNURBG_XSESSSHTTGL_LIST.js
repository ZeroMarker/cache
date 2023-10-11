var ret = "";
var checkret = "";
var comboret = "";
var ht = new Hashtable();
var arrgrid = new Array();
var linkCode = "DHCNURPGD_XSESSSHTTGL";
var prncode="DHCNURMouldPrn_XSESSSHRTTGL";

function butPrintFn() {
  PrintComm.WebUrl = WebIp + "/imedical/web/DWR.DoctorRound.cls";
  PrintComm.ItmName = prncode
  var subId=tkMakeServerCall("Nur.DHCMoudData","getMoudId",EpisodeID,linkCode);
  var recId=tkMakeServerCall("Nur.DHCMoudData","getLinkSubId",subId,EpisodeID,linkCode);     
  PrintComm.PgdAdm=EpisodeID;
  PrintComm.PrintRecId=recId;  
 //alert(recId)
  PrintComm.MthArr= "Nur.DHCMoudDataSub:getVal1&parr:" + recId + "!flag:";
  PrintComm.xuflag = 0;
  
  PrintComm.PrintOut();
  PrintComm.PreView=1;

}
function butPrintFnXu() {
  var printInfo=tkMakeServerCall("Nur.DHCNurMultiPgdPrint","GetPageInfo",EpisodeID,prncode);
  if(printInfo=="0^0") 
  {
	  butPrintFn();  //没有打印记录调用全部打印
	  return;
  } 
  var subId=tkMakeServerCall("Nur.DHCMoudData","getMoudId",EpisodeID,linkCode);
  var recId=tkMakeServerCall("Nur.DHCMoudData","getLinkSubId",subId,EpisodeID,linkCode); 
  var ifCan=tkMakeServerCall("Nur.DHCNurMultiPgdPrint","IfCanXuPrint",EpisodeID,prncode,recId);
  if(ifCan!=""){
	  alert(ifCan)
	  return;
  }
  
  PrintComm.WebUrl = WebIp + "/imedical/web/DWR.DoctorRound.cls";
  PrintComm.ItmName = prncode;
  PrintComm.PgdAdm=EpisodeID; 
  var printRecId=tkMakeServerCall("Nur.DHCNurMultiPgdPrint","getPrintRecId",recId,EpisodeID,prncode);//续打转化Id,打印过的转化成none
  PrintComm.PrintRecId=recId;
  PrintComm.MthArr= "Nur.DHCMoudDataSub:getVal1&parr:" + printRecId + "!flag:";
  PrintComm.xuflag = 1;
  PrintComm.PrintOut();
  PrintComm.PreView=1;
}
function gethead() {
	var GetHead = document.getElementById('GetHead');
	var ret = cspRunServerMethod(GetHead.value, EpisodeID);
	return ret;
	//debugger;
}
function BodyLoadHandler() {

	setsize("mygridpl", "gform", "mygrid");
	var grid = Ext.getCmp('mygrid');
	//alert(1);
	//grid.on('dblclick', griddblclick);
	var but1 = Ext.getCmp("mygridbut1");
	but1.on('click', newrec);
	var but = Ext.getCmp("mygridbut2");
	but.setText("修改");
	but.on('click', modrec);

	grid.on('rowdblclick', modrec);
	grid = Ext.getCmp('mygrid');
	//debugger;
	//grid.setTitle(gethead());
	var mydate = new Date();
	var tobar = grid.getTopToolbar();

	tobar.addButton({
		className: 'new-topic-button',
		text: "查询",
		handler: find,
		id: 'mygridSch'
	});
	tobar.addButton({
		className: 'new-topic-button',
		text: "打印",
		icon: '../images/uiimages/print.png',
		handler: butPrintFn,
		id: 'mygridPrint'
	});
	tobar.addButton({
		className: 'new-topic-button',
		text: "续打",
		icon: '../images/uiimages/print.png',
		handler: butPrintFnXu,
		id: 'mygridPrintXu'
	});
	tobar.addItem("-", {
		xtype: 'checkbox',
		id: 'IfCancelRec',
		checked: false,
		boxLabel: '显示作废记录'
	});
	grid.addListener('rowcontextmenu', rightClickFn);

	//tobar.addButton({
	//className: 'new-topic-button',
	//text: "删除",
	//handler: delete,
	//id: 'mygridSch1'
	//});	
	var bbar = grid.getBottomToolbar();
	bbar.hide();
	//上半部分
	// var bbar2 = new Ext.PagingToolbar({
	// 	pageSize: 20,
	// 	store: grid.store,
	// 	displayInfo: true,
	// 	displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
	// 	emptyMsg: "没有记录"
	// });
	// bbar2.render(grid.bbar);  //病情变化部分
	find();
}

function rightClickFn(client, rowIndex, e) {
	e.preventDefault();
	grid = client;
	CurrRowIndex = rowIndex;
	rightClick.showAt(e.getXY());
}
var rightClick = new Ext.menu.Menu({
	id: 'rightClickCont',
	items: [{
		id: 'rMenu7',
		text: '作废',
		handler: CancelRecord
	}, {
		id: 'rMenu8',
		text: '撤销作废',
		handler: Cancelzf
	}]
});
function CancelRecord() {
	var objCancelRecord = document.getElementById('CancelRecord');
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		alert("请先选择一条护理记录!");
		return;
	} else {
		var flag = confirm("你确定要作废此条记录吗!")
		if (flag) {
			var par = objRow[0].get("rw");
			var rw = objRow[0].get("chl");
			//alert(par+","+rw+","+session['LOGON.USERID']+","+session['LOGON.GROUPDESC']);
			if (objCancelRecord) {
				var a = cspRunServerMethod(objCancelRecord.value, par, rw, session['LOGON.USERID'], session['LOGON.GROUPDESC']);
				if (a != 0) {
					alert(a);
					return;
				} else {
					find();
				}
			}
		}
	}
}
function Cancelzf() {
	var objCancelRecord = document.getElementById('Cancelzf');
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		alert("请先选择一条护理记录!");
		return;
	} else {
		var flag = confirm("你确定要撤销作废记录吗!")
		if (flag) {
			var par = objRow[0].get("rw");
			var rw = objRow[0].get("chl");
			//alert(par+","+rw+","+session['LOGON.USERID']+","+session['LOGON.GROUPDESC']);
			if (objCancelRecord) {
				var a = cspRunServerMethod(objCancelRecord.value, par, rw, session['LOGON.USERID'], session['LOGON.GROUPDESC']);
				if (a != 0) {
					alert(a);
					return;
				} else {
					find();
				}
			}
		}
	}
}
function find_Bak() {
	var mygrid1 = Ext.getCmp("mygrid");
	var IfCancelRec = Ext.getCmp("IfCancelRec").getValue();
	var parr = linkCode + "^" + EpisodeID + "^IfCancelRec^" + IfCancelRec;
	mygrid1.store.on(
		"beforeLoad", function () {
			//alert(MID)	
			mygrid1.store.baseParams.parr = parr;
		});
	mygrid1.store.load({
		params: {
			start: 0,
			limit: 20
		}
	});
}
function find() {
	//var StDate = Ext.getCmp("mygridstdate");
	//var Enddate = Ext.getCmp("mygridenddate");
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var IfCancelRec = Ext.getCmp("IfCancelRec").getValue();
	var parr = linkCode + "^" + EpisodeID + "^IfCancelRec^" + IfCancelRec;
	//var parr ="DHCNurPFB^"+EpisodeID;
	arrgrid = new Array();
	//alert(EpisodeID);
	//alert(parr);
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurMouldDataComm:MoudData", "parr$" + parr, "AddRec");
	//alert(a);
	mygrid.store.loadData(arrgrid);

}
function AddRec(str) {
	//var a=new Object(eval(str));
	//alert(str);
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}

function newrec() {
	// var CurrAdm=selections[rowIndex].get("Adm");

	//if (DtId=="")return;
	//var getcurExamId=document.getElementById('getcurExamId');
	//var ExamId=cspRunServerMethod(getcurExamId.value,SpId);
	// alert(ExamId);
	var lnk = "dhcnuremrcomm.csp?" + "&EmrCode=" + linkCode + "&EpisodeID=" + EpisodeID + "&NurRecId=";;
	window.open(lnk, "htm", 'toolbar=no,location=no,directories=no,resizable=yes,top=50,width=820,height=650');



}
function reloadtree() {
	window.parent.reloadtree();
}
function modrec() {
	var mygrid = Ext.getCmp("mygrid");
	var rowObj = mygrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1) {
		alert("请选择需要修改的数据!")
		return;
	} else {
		id = rowObj[0].get("rw") + "||" + rowObj[0].get("chl");
	}
	if (id){
		var lnk = "dhcnuremrcomm.csp?" + "&EmrCode=" + linkCode + "&EpisodeID=" + EpisodeID + "&NurRecId=" + id;
		window.open(lnk, "htm", 'toolbar=no,location=no,directories=no,resizable=yes,top=50,width=820,height=650');
	}		
}

