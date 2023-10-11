/**
 * @author Administrator
 */
var Width=document.body.clientWidth-3;
var Height=document.body.clientHeight-3;
var ret = "";
var checkret = "";
var comboret = "";
var arrgrid = new Array();
var curmenuid = "";
var gridRowId="";

var xls = new ActiveXObject("Excel.Application"); 
var NewBook="";
var DHCMGNURQUALVERSIONT101=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'Version','mapping':'Version'},{'name':'QualName','mapping':'QualName'},{'name':'CreatDate','mapping':'CreatDate'},{'name':'CreatTime','mapping':'CreatTime'},{'name':'rw','mapping':'rw'}]}),baseParams:{className:'web.DHCMgNurSysComm',methodName:'GetQualCodeVersion',type:'RecQuery'}});

var DHCMgNurQualSubListT101 = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : "../csp/dhc.nurse.ext.common.getdata.csp"
	}),
	reader : new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : 'results',
		fields : [{
			'name' : 'ItemCode',
			'mapping' : 'ItemCode'
		}, {
			'name' : 'ItemDesc',
			'mapping' : 'ItemDesc'
		}, {
			'name' : 'ItemValue',
			'mapping' : 'ItemValue'
		}, {
			'name' : 'ItemDedStand',
			'mapping' : 'ItemDedStand'
		}, {
			'name' : 'ItemLevel',
			'mapping' : 'ItemLevel'
		}, {
			'name' : 'Par',
			'mapping' : 'Par'
		}, {
			'name' : 'rw',
			'mapping' : 'rw'
		}]
	}),
	baseParams : {
		className : 'web.DHCMgNurSysComm',
		methodName : 'GetQualItemSub',
		type : 'RecQuery'
	}
});

function SizeChange(changewidth) {
	var fheight = document.body.offsetHeight;
	var fwidth = document.body.offsetWidth;
	var fm = Ext.getCmp('gform');
	fm.setHeight(fheight);
	fm.setWidth(fwidth + changewidth);
	setsize("mygridpl", "gform", "mygrid");
}
// var commould=CreateComboBoxQ("commould","MouldName","rw","模块","","150","web.DHCMgNurSysComm","GetMould.RecQuery","sid",0,0);
function BodyLoadHandler() {
	var gridPl = Ext.getCmp('mygridpl');
	gridPl.setWidth(Width);
	gridPl.setHeight(Height);
	var grid = Ext.getCmp('mygrid');
  grid.on("dblclick",QualSubWin);
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	tobar.hide();
	var tbar1 = new Ext.Toolbar();
	tbar1.addItem('-');
	tbar1.addButton({
		id:'additmbtn',
		text:'增加',
		handler:menunew,
		icon:'../images/uiimages/edit_add.png'
	});
	tbar1.addItem('-');
	tbar1.addButton({
		id:'edititmbtn',
		text:'编辑',
		handler:menumod,
		icon:'../images/uiimages/pencil.png'
	});
	
//	var but1 = Ext.getCmp("mygridbut1");
//	but1.on('click', menunew);
//	var but = Ext.getCmp("mygridbut2");
//	but.setText("编辑");
//	but.on('click', menumod);
	tbar1.addItem('-');
	tbar1.addButton({
		//className:'new-topic-button',
		text:'条目编辑',
		handler:QualSubWin,
		id:'mygridedit',
		icon:'../images/uiimages/RegNO.png'
	});
	tbar1.addItem('-');
	tbar1.addButton({
		text:'下载质控项目导入模板',
		handler:Load,
		id:'load',
		icon:'../images/uiimages/insureg.png'
	});
	tbar1.addItem('-', '<span style="color:red">质控项目导入需要选择固定模板</span>');
	tbar1.render(grid.tbar);
	tbar1.doLayout();
	//右键事件
	grid.addListener("rowcontextmenu",rightClickFn);
///	function rightClickFn(client,rowIndex,e)
//	{
////		var grid=Ext.getCmp('mygrid');
////		var rowObj=grid.getSelectionModel().getSelections();
////		if (rowObj.length == 0) 
////		{
////			alert("请选择一条记录！");
////			return;
////		}
////		var gridRowId=rowObj[0].get("rw");
////		alert(gridRowId)
//		e.preventDefault();
//		//alert(e.preventDefault())
//		//grid=client;
//		//CurrRowIndex=rowIndex;
//		//alert(e.getXY)
//		rightClick.showAt(e.getXY());
//	}
//	var rightClick=new Ext.menu.Menu({
//		id : 'rightClickCont',
//		items :[{
//			id : 'rMenu1',
//			text : '新增版本',
//			handler : addNewQual
//		},{
//			id : 'rMenu2',
//			text : '查看历史版本',
//			handler : schQual
//		},{	
//			id : 'dMenu1',
//			text : '导入数据',
//			handler : inputdata
//		}]
//	});
	//Ext.getCmp('mygrid').on('click',checkGridRecord);
	grid.getBottomToolbar().hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:25,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
	loadgrid();
	var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(grid.getColumnModel().getDataIndex(i) == 'rw'){
			grid.getColumnModel().setHidden(i,true);
		}
  }
}
function rightClickFn(client,rowIndex,e)
{
//		var grid=Ext.getCmp('mygrid');
//		var rowObj=grid.getSelectionModel().getSelections();
//		if (rowObj.length == 0) 
//		{
//			alert("请选择一条记录！");
//			return;
//		}
//		var gridRowId=rowObj[0].get("rw");
//		alert(gridRowId)
		e.preventDefault();
		rightClick.showAt(e.getXY());
}
	var rightClick=new Ext.menu.Menu({
		id : 'rightClickCont',
		items :[
//		{
//			id : 'rMenu1',
//			text : '新增版本',
//			handler : addNewQual
//		},{
//			id : 'rMenu2',
//			text : '查看历史版本',
//			handler : schQual
//		},
		{	
			id : 'dMenu1',
			text : '导入数据',
			icon:'../images/uiimages/blue_arrow.png',
			handler:inLoadData
		}]
	});

function inLoadData(){
	var grid=Ext.getCmp('mygrid');
	var rowObj=grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) 
	{
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var gridRowId=rowObj[0].get("rw");
	//alert(gridRowId)
	var fpFileUpload=new Ext.FormPanel({  
   id:'fpFileUpload',  
   frame:true,  
   fileUpload:true,
   items:[{
     xtype:'textfield',  
     allowBlank:false,  
     fieldLabel:'选择文件', 
     inputType:'file',  
     name:'fileName',
		 id:'fileName'
   }],  
   buttonAlign:'center',  
   buttons:[{  
     text:'上传', 
     icon:'../images/uiimages/moveup.png',	 
     handler:function(){
			var filePath=Ext.getCmp("fileName").getValue();
			var RealFilePath=""
			RealFilePath = filePath.replace(/\\/g, "\\\\");
			if(RealFilePath!=""){
				
				ReadExcel(RealFilePath,gridRowId);
				Ext.Msg.alert('提示',"导入完成！");
				winFielUpload.close();
				
			}else{
				Ext.Msg.alert('提示',"请选择文件！");
				return;
			}
		 }  
   },{  
     text:'取消',
     icon:'../images/uiimages/cancel.png',	 
     handler:function(){  
     	winFielUpload.close();  
		 } 
	 }]
	});
	var winFielUpload=new Ext.Window({
		id:'win',  
  	title:'文件上传',  
  	width:350,  
  	height:100,  
  	layout:'fit',  
  	autoDestory:true,  
  	modal:true,  
  	//closeAction:'hide',  
  	items:[fpFileUpload]  
 	});
 	winFielUpload.show(); 
}

function inputdata(){  
	//checkGridRecord();
	var grid=Ext.getCmp('mygrid');
	var rowObj=grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) 
	{
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var gridRowId=rowObj[0].get("rw");
	//alert(gridRowId)
	
  winFielUpload.show();  
}  
function loadgrid() {
	// var cmb=Ext.getCmp("commould");
	Ext.getCmp("mygrid").store.load({
		params : {
			start : 0,
			limit : 25
		}
	});
}
function addNewQual()
{
	var grid = Ext.getCmp('mygrid');
	var rowObj = grid.getSelectionModel().getSelections();
	var rowtype = rowObj[0].get("QualCat");
	//alert(rowtype);
	if(rowtype!="Quality")
	{
		Ext.Msg.alert('提示',"核查表不能增加新版本!");
		return;
	}
	Ext.Msg.confirm("提示","确认增加新版本？",function(btn){
		if(btn == "yes")
		{
			var rowid = rowObj[0].get("rw");
			var newParent=document.getElementById('NewPar');
			var newID=cspRunServerMethod(newParent.value,rowid);
			curmenuid = newID;
			var arr = new Array();
			var a = cspRunServerMethod(pdata1, "", "DHCMgNurQualSubList", "", "");
			arr = eval(a);
			var window = new Ext.Window({
				title : '菜单维护',
				id : "gform2",
				width : 700,
				height : 580,
				autoScroll : true,
				layout : 'absolute',
				// plain: true,
				// modal: true,
				// bodyStyle: 'padding:5px;',
				// /buttonAlign: 'center',
				items : arr
			});
			window.show();
			var but1 = Ext.getCmp("butSave");
			but1.on('click', itmAdd);
			var but = Ext.getCmp("butMod");
			but.on('click', itmMod);
			var but2 = Ext.getCmp("butClear");
			but2.on('click', clearscreen);
			var grid = Ext.getCmp('mygrid2');
			grid.on('dblclick', griddblclick);
    	var stdata=Ext.getCmp("mygrid2").store;
    	Ext.getCmp("mygrid2").store.removeAll();
			stdata.on(
				"beforeLoad",function(){stdata.baseParams.Par=curmenuid;}
	 		)
			Ext.getCmp("mygrid2").store.load({
				params : {
					start : 0,
					limit : 25,
					Par : newID
				}
			});
		}
		loadgrid();
	})
}
function schQual()
{
	var grid = Ext.getCmp('mygrid');
	var rowObj = grid.getSelectionModel().getSelections();
	var rowtype = rowObj[0].get("QualCat");
	if(rowtype!="Quality")
	{
		Ext.Msg.alert('提示',"核查表不能查看版本!");
		return;
	}
	//curmenuid = newID;
			var arr = new Array();
			var rowqual=rowObj[0].get("QualCode");
			var a = cspRunServerMethod(pdata1, "", "DHCMGNURQUALVERSION", "", "");
			arr = eval(a);
			var window = new Ext.Window({
				title : '版本明细',
				id : "gform3",
				width : 700,
				height : 580,
				autoScroll : true,
				layout : 'absolute',
				// plain: true,
				 modal: true,
				// bodyStyle: 'padding:5px;',
				// /buttonAlign: 'center',
				items : arr
			});
			window.show();
			Ext.getCmp("mygrid3but1").hide();
			Ext.getCmp("mygrid3but2").hide();
			Ext.getCmp("mygrid3pl").setSize(670,550)
			Ext.getCmp("mygrid3").setTitle(" ");
			/*
			Ext.getCmp("mygrid3").on(
				"beforeLoad",function(){stdata.baseParams.Par=rowqual;}
	 		)*/
			Ext.getCmp("mygrid3").store.load({
				params : {
					start : 0,
					limit : 25,
					Par : rowqual
					}
				});
				//双击事件
				var grid3=Ext.getCmp("mygrid3");
				grid3.on("dblclick",QualSubWinNew);
}
function menunew() {
	curmenuid = "";
	menuWin("");
}
function menumod() {

	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}

	var menuid = rowObj[0].get("rw");
	menuWin(menuid);

}
function QualSubWin() 
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var menuid = rowObj[0].get("rw");
	curmenuid = menuid;
	var arr = new Array();
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCMgNurQualSubList", "", "");
	arr = eval(a);
	var window = new Ext.Window({
		title : '条目维护',
		id : "gform2",
		width : 700,
		height : 580,
		//autoScroll : true,
		layout : 'absolute',
		modal: true,
		items : arr,
		modal:true,
		resizable:false
	});
	window.show();
	var grid = Ext.getCmp('mygrid2');
	var gridPl = Ext.getCmp('mygrid2pl');
	var but1 = Ext.getCmp('butSave');
	but1.setIcon('../images/uiimages/edit_add.png');
	but1.on('click',itmAdd);
	var but = Ext.getCmp("butMod");
	but.setIcon('../images/uiimages/pencil.png');
	but.on('click', itmMod);
	var but2 = Ext.getCmp("butClear");
	but2.setIcon('../images/uiimages/clearscreen.png');
	but2.on('click', clearscreen);
	grid.getTopToolbar().hide();
	gridPl.setWidth(685);
	gridPl.setHeight(466);
	grid.on('dblclick', griddblclick);
  var stdata=Ext.getCmp("mygrid2").store;
  Ext.getCmp("mygrid2").store.removeAll();
	stdata.on("beforeload",function(){stdata.baseParams.Par=curmenuid;})
	grid.getBottomToolbar().hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:25,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
	grid.store.load({
		params : {start : 0,limit : 25,Par : curmenuid}
	});
	var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(grid.getColumnModel().getDataIndex(i) == 'rw'){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i) == 'ItemLevel'){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i) == 'Par'){
			grid.getColumnModel().setHidden(i,true);
		}
  }
}
function QualSubWinNew() 
{
	var grid = Ext.getCmp("mygrid3");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var menuid = rowObj[0].get("rw");
	curmenuid = menuid;
	var arr = new Array();
	// alert(curmenuid);
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCMgNurQualSubList", "", "");
	// alert(a);
	arr = eval(a);
	var window = new Ext.Window({
		title : '质控条目',
		id : "gform2",
		width : 700,
		height : 580,
		autoScroll : true,
		layout : 'absolute',
		// plain: true,
		 modal: true,
		// bodyStyle: 'padding:5px;',
		// /buttonAlign: 'center',
		items : arr
	});
	window.show();
	var but1 = Ext.getCmp("butSave");
	but1.hide();
	var but = Ext.getCmp("butMod");
	but.hide();
	var but2 = Ext.getCmp("butClear");
	but2.hide();
	var grid = Ext.getCmp('mygrid2');
	grid.on('dblclick', griddblclick);
  var stdata=Ext.getCmp("mygrid2").store;
  Ext.getCmp("mygrid2").store.removeAll();
	stdata.on("beforeLoad",function(){stdata.baseParams.Par=curmenuid;})
	Ext.getCmp("mygrid2").store.load({
		params:{
			start:0,
			limit:25,
			Par:curmenuid
		}
	});
}
var CurrSelItm = "";
function SaveItm()
{
  ret = "";
	checkret = "";
	comboret = "";
	var Save = document.getElementById('Save');
	var gform = Ext.getCmp("gform2");
	gform.items.each(eachItem, this);
	// var rw=cspRunServerMethod(getemrcodeid.value,code,NurRecId);
	// var parr=ret+"&"+checkret+"&"+comboret;
	//alert(ret + "^" + checkret + "^" + comboret);
	var parr = "rw|" + CurrSelItm + "^Par|" + curmenuid + "^" + ret + "^"
			+ checkret + "^" + comboret;
	// alert(parr);
	// id=cspRunServerMethod(SaveExam.value,"id|"+ret+"^CTLocDr|"+session['LOGON.CTLOCID']+"^"+checkret+"^"+comboret);
	// //+"^UserDr|"+session['LOGON.USERID']
	var row = cspRunServerMethod(Save.value, parr);
	// win.close();
	Ext.getCmp("mygrid2").store.load({
		params:{
			start:0,
			limit:25,
			Par:curmenuid
		}
	});
	return;
}
function itmAdd()
{
   	CurrSelItm="";
   	var itemCode=Ext.getCmp('ItemCode').getValue();
	if(!itemCode){
		Ext.Msg.alert('提示','序号不能空');
		return;
	}
	var itemLevel=Ext.getCmp('ItemLevel').getValue();
	if(!itemLevel){
		Ext.Msg.alert('提示','关联号不能！');
		return;
	}
	var itemDesc=Ext.getCmp('ItemDesc').getValue();
	if(!itemDesc){
		Ext.Msg.alert('提示','条目不能为空！');
		return;
	}
	var itemDedStand=Ext.getCmp('ItemDedStand').getValue();
	if(!itemDedStand){
		/* Ext.Msg.alert('提示','扣分原因不能为空！');
		return; */
	}
   	SaveItm();
}
function checkItemVal()
{
	var itemCode=Ext.getCmp('ItemCode').getValue();
	if(!itemCode){
		Ext.Msg.alert('提示','序号不能空');
		return;
	}
	var itemLevel=Ext.getCmp('ItemLevel').getValue();
	if(!itemLevel){
		Ext.Msg.alert('提示','关联号不能！');
		return;
	}
	var itemDesc=Ext.getCmp('ItemDesc').getValue();
	if(!itemDesc){
		Ext.Msg.alert('提示','条目不能为空！');
		return;
	}
	var itemDedStand=Ext.getCmp('ItemDedStand').getValue();
	if(!itemDedStand){
		Ext.Msg.alert('提示','扣分原因不能为空！');
		return;
	}
}
function itmMod() 
{
	if (CurrSelItm=="") return;
	var itemCode=Ext.getCmp('ItemCode').getValue();
	if(!itemCode){
		Ext.Msg.alert('提示','序号不能空');
		return;
	}
	var itemLevel=Ext.getCmp('ItemLevel').getValue();
	if(!itemLevel){
		Ext.Msg.alert('提示','关联号不能！');
		return;
	}
	var itemDesc=Ext.getCmp('ItemDesc').getValue();
	if(!itemDesc){
		Ext.Msg.alert('提示','条目不能为空！');
		return;
	}
	var itemDedStand=Ext.getCmp('ItemDedStand').getValue();
	if(!itemDedStand){
		/* Ext.Msg.alert('提示','扣分原因不能为空！');
		return; */
	}
	SaveItm();
}
function clearscreen() {
  Ext.getCmp("ItemDesc").setValue("");
  Ext.getCmp("ItemCode").setValue("");
  Ext.getCmp("ItemLevel").setValue("");
  Ext.getCmp("ItemDedStand").setValue("");
  Ext.getCmp("ItemValue").setValue("");
  setbutstatus(0);
}
function setbutstatus(flag)
{
  var but1 = Ext.getCmp("butSave");
	var but = Ext.getCmp("butMod");
	var but2 = Ext.getCmp("butClear");
	if (flag==0)
	{
    but.disable();
    but1.enable();
	}else{
	 but1.disable();
	 but.enable();
	}
}
function griddblclick()
{
	var grid=Ext.getCmp("mygrid2");
  var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var list = [];
	if (rowObj.length == 0) {
		return;
	}
	CurrSelItm=rowObj[0].get('rw');
    setbutstatus(1);
	for(var r=0;r<len;r++) {
		list.push(rowObj[r].data);
	}
	for (var i = 0; i < list.length; i++) {
		var obj = list[i];
		for (var p in obj) {
			var itm= Ext.getCmp(p);
			if (itm!=undefined) itm.setValue(obj[p]);
		}
	}
}
function menuWin(menuid) {

	var arr = new Array();
	curmenuid = menuid;
	// alert(curmenuid);
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCMGNurQualGui", "", "");
	// alert(a);
	arr = eval(a);
	var window = new Ext.Window({
		title : '菜单维护',
		id : "gform2",
		width : 450,
		height : 400,
		x:100,y:100,
		autoScroll : true,
		layout : 'absolute',
		items : arr,
		modal:true,
		resizable:false,
		buttons : [{
			text : '保存',
			icon:'../images/uiimages/filesave.png',
			handler : function() {
				Save(window, menuid);
			}
		}, {
			text : '关闭',
			icon:'../images/uiimages/cancel.png',
			handler : function() {
				window.close();
			}
		}]
	});
	window.show();
	setvalue(menuid);
}
function SaveGrid() {
	var grid = Ext.getCmp("mygrid1");
	var store = grid.store;
	var rowCount = store.getCount(); // 记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	for (var r = 0; r < len; r++) {
		list.push(rowObj[r].data);
	}
	var SaveQt = document.getElementById('SaveSub');
	var rw = "";
	for (var i = 0; i < list.length; i++) {
		var obj = list[i];
		var str = "";
		var CareDate = "";
		var CareTime = "";
		for (var p in obj) {
			var aa = formatDate(obj[p]);
			if (p == "")
				continue;
			// str = str + p + "|" + obj[p] + '^';
			if (aa == "") {
				str = str + p + "|" + obj[p] + '^';
			} else {
				str = str + p + "|" + aa + '^';
			}
			rw = obj["rw"];

		}
		if (str != "") {
			if (rw == undefined)
				str = str + "Par|" + curmenuid;
			var a = cspRunServerMethod(SaveQt.value, str);
			if (a != 0) {
				alert(a);
				// return;
			}
		}
	}
	Ext.getCmp('mygrid1').store.load({
		params:{
			start:0,
			limit:25,
			Par:curmenuid
		}
	});
}
function setvalue(menid) {

	var ha = new Hashtable();
	var getval = document.getElementById('getVal');
	var ret = cspRunServerMethod(getval.value, menid);
	var tm = ret.split('^')
	sethashvalue(ha, tm);
	var gform = Ext.getCmp("gform2");
	gform.items.each(eachItem, this);
	for (var i = 0; i < ht.keys().length; i++){
		var key = ht.keys()[i];
		// restr += ht.items(key) + " " + ht.parent[key] + "<br/>";
		if (key.indexOf("_") == -1) {
			var itm = Ext.getCmp(key);
			if (ha.contains(key))
				if (itm.xtype == "combo") {
					comboload(itm, ha.items(key));
				} else {
					itm.setValue(ha.items(key));
				}
		} else {
			var aa = key.split('_');
			if (ha.contains(aa[0])) {
				setcheckvalue(key, ha.items(aa[0]));
			}
		}
	}
}
function comboload(itm, str) {
	var aa = str.split('!');
	var par = itm.id;
	// alert(aa.length);
	if (aa.length < 2) {
		itm.setValue(str);
		return;
	}
	if (str != "") {
		itm.getStore().load({
			params : {
				start : 0,
				limit : 25,
				locdes : aa[0]
			},
			callback : function() {
				itm.setValue(aa[1])
			}
		});
	}
}
function Save(win, menuid) {
	ret = "";
	checkret = "";
	comboret = "";
	var Save = document.getElementById('Save2');
	var QualCode=Ext.getCmp('QualCode').getValue();
	if(!QualCode){Ext.Msg.alert('提示','代码不能为空！');return;}
	var QualDesc=Ext.getCmp('QualDesc').getValue();
	if(!QualDesc){Ext.Msg.alert('提示','名称不能为空！');return;}
	var QualCat=Ext.getCmp('QualCat').getValue();
	if(!QualCat){Ext.Msg.alert('提示','请选择所属类别！');return;}
	var QualCheckOBJ=Ext.getCmp('QualCheckOBJ').getValue();
	if(!QualCheckOBJ){Ext.Msg.alert('提示','请选择检查对象！');return;}
	var gform = Ext.getCmp("gform2");
	gform.items.each(eachItem, this);
	// alert(NurRecId);
	// var rw=cspRunServerMethod(getemrcodeid.value,code,NurRecId);
	// var parr=ret+"&"+checkret+"&"+comboret;
	// alert(ret+"^"+checkret+"^"+comboret);
	var parr = "rw|" + menuid + "^" + ret + "^" + checkret + "^" + comboret;
	// id=cspRunServerMethod(SaveExam.value,"id|"+ret+"^CTLocDr|"+session['LOGON.CTLOCID']+"^"+checkret+"^"+comboret);
	// //+"^UserDr|"+session['LOGON.USERID']
	menuid = cspRunServerMethod(Save.value, parr);
	curmenuid = menuid;
	win.close();
	loadgrid();
	return;
}

function setgrid1() {
	/*
	 * var grid = Ext.getCmp("mygrid"); var
	 * GetQueryData=document.getElementById('GetQueryData'); arrgrid=new
	 * Array(); var a = cspRunServerMethod(GetQueryData.value,
	 * "web.DHCNurHDCodeComm:HDMode", "","AddRec");
	 * grid.store.loadData(arrgrid);
	 */
	var mygrid = Ext.getCmp("mygrid1");
	// var parr = getParameters()
	// alert(parr);
	// debugger;
	mygrid.store.load({
		params : {
			start : 0,
			limit : 25
		}
	});
}
function setgrid() {
	/*
	 * var grid = Ext.getCmp("mygrid"); var
	 * GetQueryData=document.getElementById('GetQueryData'); arrgrid=new
	 * Array(); var a = cspRunServerMethod(GetQueryData.value,
	 * "web.DHCNurHDCodeComm:HDMode", "","AddRec");
	 * grid.store.loadData(arrgrid);
	 */
	var mygrid = Ext.getCmp("mygrid");
	// var parr = getParameters()
	// alert(parr);
	// debugger;
	mygrid.store.load({
		params : {
			start : 0,
			limit : 25
		}
	});
}
function additm() {
	var grid = Ext.getCmp('mygrid1');
	var Plant = Ext.data.Record.create([]);
			// the "name" below matches the tag name to read, except "availDate"
			// which is mapped to the tag "availability"
	var count = grid.store.getCount();
	var r = new Plant();
	grid.store.commitChanges();
	grid.store.insert(count, r);
	return;
}

function typdelete() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len == 0) {
		Ext.Msg.alert('提示', "请先选择一行!");
		return;
	};
	var QtDelete = document.getElementById('QtDelete');
	if (QtDelete) {
		var id = rowObj[0].get("rw");
		var ee = cspRunServerMethod(QtDelete.value, id);
		if (ee != "0") {
			alert(ee);
			return;
		}
	}
	setgrid();
};
function ReadExcel(RealFilePath,gridRowId)
{
	/*
//判断浏览器类型2
var isIE = (document.all) ? true : false;
var isIE7 = isIE && (navigator.userAgent.indexOf('MSIE 7.0') != -1);
var isIE8 = isIE && (navigator.userAgent.indexOf('MSIE 8.0') != -1);
var isIE6 = isIE && (navigator.userAgent.indexOf('MSIE 6.0') != -1);
var file = Ext.getCmp("fileupload1");
//var file = document.getElementById("fileupload1");
if (isIE7 || isIE8) {
file.select();
//获取欲上传的文件路径
var path = document.selection.createRange().text;
document.selection.empty(); 
}
var filepath = document.getElementById("fileupload1").value;
if(isIE6)
{
path = filepath;
}*/
	try{
     var filePath= RealFilePath    //"E:\\book.xls"//document.all.upfile.value;
     var oXL = new ActiveXObject("Excel.application"); 
     var oWB = oXL.Workbooks.open(filePath);
     oWB.worksheets(1).select(); 
     var oSheet = oWB.ActiveSheet;
      for(var i=2;i<100;i++)
      {
	   		var ret = "";
	   		var ItemDedStand="";
	   		if((oSheet.Cells(i,1).value =="null")||(oSheet.Cells(i,2).value =="null")||(oSheet.Cells(i,1).value ==undefined)||(oSheet.Cells(i,2).value ==undefined)) continue;
	   		if(oSheet.Cells(i,5).value==undefined){ItemDedStand="";}
	   		else(ItemDedStand=oSheet.Cells(i,5).value)
	   		ret="ItemDesc|"+oSheet.Cells(i,3).value+
		  	 "^ItemValue|"+oSheet.Cells(i,4).value+
		   	 "^ItemCode|"+oSheet.Cells(i,1).value+
		 	 	 "^ItemDedStand|"+ItemDedStand+
		     "^ItemLevel|"+oSheet.Cells(i,2).value+"^";
	   		InputDataItm(ret,gridRowId)
      }
	}catch(e){
		alert(e.message)
	}
	//  Ext.getCmp("mygrid2").store.load({
	//			params : {
	//				start : 0,
	//				limit : 50,
	//				Par : curmenuid
	//			}
	//		});
   oXL.Quit();
   CollectGarbage();
}
function InputDataItm(ret,gridRowId)
{
	checkret = "";
	comboret = "";
	var Save = document.getElementById('Save');
	//var gform = Ext.getCmp("gform2");
	//gform.items.each(eachItem, this);
	var parr = "rw|"+CurrSelItm+"^Par|"+gridRowId+"^"+ret+"^"+checkret+"^"+comboret;
	//alert(parr)
	var row = cspRunServerMethod(Save.value, parr);
}
function Load(){
	window.location.href="/dhcmg/质控项目导入模板/质控项目导入模板.xlsx";
}
