var DHCNURBG_PUBLSUBT101=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'Item1','mapping':'Item1'},{'name':'Item2','mapping':'Item2'},{'name':'Item3','mapping':'Item3'},{'name':'Item4','mapping':'Item4'},{'name':'Item5','mapping':'Item5'},{'name':'Item6','mapping':'Item6'},{'name':'Item7','mapping':'Item7'},{'name':'Item8','mapping':'Item8'},{'name':'Item9','mapping':'Item9'},{'name':'Par','mapping':'Par'},{'name':'rw','mapping':'rw'}]}),baseParams:{className:'Nur.DHCNurTerminologySetSub',methodName:'GetPublItemSub',type:'RecQuery'}});
var Width=document.body.clientWidth-3;
var Height=document.body.clientHeight-3;
var ret = "";
var checkret = "";
var comboret = "";
var arrgrid = new Array();
var curmenuid = "";
var gridRowId="";

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
	tbar1.addItem('-');
	tbar1.addButton({
		//className:'new-topic-button',
		text:'子集编辑',
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
	tbar1.addItem('-', '<span style="color:red">共享项目导入需要选择固定模板</span>');
	tbar1.render(grid.tbar);
	tbar1.doLayout();
	grid.getBottomToolbar().hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:25,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
	//右键事件
	grid.addListener("rowcontextmenu",rightClickFn);
	loadgrid();

	
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
		},
		{	
			id : 'eMenu1',
			text : '导出数据',
			icon:'../images/uiimages/blue_arrow.png',
			handler:Export
		}]
	});
function Export()
{
	var xls = new ActiveXObject ("Excel.Application");
	
	xls.visible =true;  //设置excel为可见
	var xlBook = xls.Workbooks.Add;
	var xlSheet = xlBook.Worksheets(1);
	
	xlSheet.Cells(1,1).Value ="章节约束";
	xlSheet.Cells(1,2).Value ="章节描述";
	xlSheet.Cells(1,3).Value ="条目约束";
	xlSheet.Cells(1,4).Value ="条目描述";
	xlSheet.Cells(1,5).Value ="字段约束";
	xlSheet.Cells(1,6).Value ="字段名称";
	xlSheet.Cells(1,7).Value ="数据元标识符";
	xlSheet.Cells(1,8).Value ="数据来源";
	xlSheet.Cells(1,9).Value ="备注";
	xlSheet.Cells(1,10).Value ="关联号";
	
	arrgrid = new Array();
	var tmpStore=new Ext.data.JsonStore({
		fields:['zjys','zjms','tmys','tmms','zdys','zdmc','sjybsf','sjly','bz','LinkCode'],
		data:[],
		idIndex: 0
	});
	var mygrid = Ext.getCmp("mygrid");
	var objRow=mygrid.getSelectionModel().getSelections();
	var rw=objRow[0].get('rw');
	var parr=rw;
	//alert(parr);
	var GetQueryData=document.getElementById('GetQueryData');
	var a=cspRunServerMethod(GetQueryData.value,"Nur.DHCNurTerminologySetSub:getShareSource","parr$"+parr,"AddRec");
	tmpStore.loadData(arrgrid);
	var storeLen=tmpStore.getCount();
	
	for(i=1;i<=storeLen;i++){
		for(j=0;j<=tmpStore.fields.length-1;j++){
			xlSheet.Cells(i+1,j+1).value="'"+tmpStore.getAt(i-1).get(tmpStore.fields.items[j].name)
		}
	}
	xlSheet.Columns.AutoFit;
	xls.ActiveWindow.Zoom = 1000;
	xls.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 
	xls=null;
	xlBook=null; 
	xlSheet=null;
}
function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}
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
function ReadExcel(RealFilePath,gridRowId)
{
	
	try{
    var filePath= RealFilePath    //"E:\\book.xls"//document.all.upfile.value;
    var oXL = new ActiveXObject("Excel.application"); 
    var oWB = oXL.Workbooks.open(filePath);
    oWB.worksheets(1).select(); 
    var oSheet = oWB.ActiveSheet;
	var fontzjys="";
	var fontzjms="";
	var fonttmys="";
	var fonttmms="";
    for(var i=2;i<100;i++)
    {
		if((oSheet.Cells(i,6).value !="null")&&(oSheet.Cells(i,6).value !=undefined))
		{
			var zjys=oSheet.Cells(i,1).value;
			var zjms=oSheet.Cells(i,2).value;
			var tmys=oSheet.Cells(i,3).value;
			var tmms=oSheet.Cells(i,4).value;
			var zdys=oSheet.Cells(i,5).value;
			var zdmc=oSheet.Cells(i,6).value;
			var sjybsf=oSheet.Cells(i,7).value;
			var sjly=oSheet.Cells(i,8).value;
			var bz=oSheet.Cells(i,9).value;
			var glh=oSheet.Cells(i,10).value;
			if((oSheet.Cells(i,1).value =="null")||(oSheet.Cells(i,1).value ==undefined))
			{
				var zjys=fontzjys;
			}
			if((oSheet.Cells(i,2).value =="null")||(oSheet.Cells(i,2).value ==undefined))
			{
				var zjms=fontzjms;
			}
			if((oSheet.Cells(i,3).value =="null")||(oSheet.Cells(i,3).value ==undefined))
			{
				var tmys=fonttmys;
			}
			if((oSheet.Cells(i,4).value =="null")||(oSheet.Cells(i,4).value ==undefined))
			{
				var tmms=fonttmms;
			}
			if((oSheet.Cells(i,7).value =="null")||(oSheet.Cells(i,7).value ==undefined))
			{
				var sjybsf="";
			}
			if((oSheet.Cells(i,8).value =="null")||(oSheet.Cells(i,8).value ==undefined))
			{
				var sjly="";
			}
			if((oSheet.Cells(i,9).value =="null")||(oSheet.Cells(i,9).value ==undefined))
			{
				var bz="";
			}
			if((oSheet.Cells(i,10).value =="null")||(oSheet.Cells(i,10).value ==undefined))
			{
				var glh="";
			}
			//alert("Item1|"+zjys+"^"+"Item2|"+zjms+"^"+"Item3|"+tmys+"^"+"Item4|"+tmms+"^"+"Item5|"+zdys+"^"+"Item6|"+zdmc+"^"+"Item7|"+sjybsf+"^"+"Item8|"+sjly+"^"+"Item9|"+bz);
			
			var ret=tkMakeServerCall("Nur.DHCNurTerminologySetSub","import","Par|"+gridRowId+"^"+"Item1|"+zjys+"^"+"Item2|"+zjms+"^"+"Item3|"+tmys+"^"+"Item4|"+tmms+"^"+"Item5|"+zdys+"^"+"Item6|"+zdmc+"^"+"Item7|"+sjybsf+"^"+"Item8|"+sjly+"^"+"Item9|"+bz+"^"+"LinkCode|"+glh)
			if (ret!=1) alert(ret);
			var fontzjys=zjys;
			var fontzjms=zjms;
			var fonttmys=tmys;
			var fonttmms=tmms;
			
		}
		  /*
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
	   		InputDataItm(ret,gridRowId)*/
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
	var a = cspRunServerMethod(pdata1, "", "DHCNURBG_PUBLSUB", "", "");
	arr = eval(a);
	var window = new Ext.Window({
		title : '子集维护',
		id : "gform2",
		width : 900,
		height : 780,
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
	gridPl.setHeight(460);
	grid.on('dblclick', griddblclick);
  var stdata=Ext.getCmp("mygrid2").store;
  Ext.getCmp("mygrid2").store.removeAll();
	stdata.on("beforeload",function(){stdata.baseParams.Par=curmenuid;})
	//grid.getBottomToolbar().hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:25,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
	grid.store.load({
		params : {start : 0,limit : 10,Par : curmenuid}
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
var CurrSelItm = "";
function SaveItm()
{
  ret = "";
	checkret = "";
	comboret = "";
	var Save = document.getElementById('Save');
	var gform = Ext.getCmp("gform2");
	gform.items.each(eachItem, this);
	
	var parr = "rw|" + CurrSelItm + "^Par|" + curmenuid + "^" + ret + "^"
			+ checkret + "^" + comboret;

	var row = cspRunServerMethod(Save.value, parr);

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
   	var Item1=Ext.getCmp('Item1').getValue();
	if(!Item1){
		Ext.Msg.alert('提示','章节约束不能为空');
		return;
	}
	var Item2=Ext.getCmp('Item2').getValue();
	if(!Item2){
		Ext.Msg.alert('提示','章节描述不能为空！');
		return;
	}
	var Item3=Ext.getCmp('Item3').getValue();
	if(!Item3){
		Ext.Msg.alert('提示','条目约束不能为空！');
		return;
	}
	var Item4=Ext.getCmp('Item4').getValue();
	if(!Item4){
		 Ext.Msg.alert('提示','条目描述不能为空！');
		return; 
	}
	var Item5=Ext.getCmp('Item5').getValue();
	if(!Item5){
		 Ext.Msg.alert('提示','字段约束不能为空！');
		return; 
	}
	var Item6=Ext.getCmp('Item6').getValue();
	if(!Item6){
		 Ext.Msg.alert('提示','字段名称不能为空！');
		return; 
	}
   	SaveItm();
}
function itmMod() 
{
	if (CurrSelItm=="") return;
	var Item1=Ext.getCmp('Item1').getValue();
	if(!Item1){
		Ext.Msg.alert('提示','章节约束不能为空');
		return;
	}
	var Item2=Ext.getCmp('Item2').getValue();
	if(!Item2){
		Ext.Msg.alert('提示','章节描述不能为空！');
		return;
	}
	var Item3=Ext.getCmp('Item3').getValue();
	if(!Item3){
		Ext.Msg.alert('提示','条目约束不能为空！');
		return;
	}
	var Item4=Ext.getCmp('Item4').getValue();
	if(!Item4){
		 Ext.Msg.alert('提示','条目描述不能为空！');
		return; 
	}
	var Item5=Ext.getCmp('Item5').getValue();
	if(!Item5){
		 Ext.Msg.alert('提示','字段约束不能为空！');
		return; 
	}
	var Item6=Ext.getCmp('Item6').getValue();
	if(!Item6){
		 Ext.Msg.alert('提示','字段名称不能为空！');
		return; 
	}
	SaveItm();
}
function clearscreen() {
  Ext.getCmp("Item1").setValue("");
  Ext.getCmp("Item2").setValue("");
  Ext.getCmp("Item3").setValue("");
  Ext.getCmp("Item4").setValue("");
  Ext.getCmp("Item5").setValue("");
  Ext.getCmp("Item6").setValue("");
  Ext.getCmp("Item7").setValue("");
  Ext.getCmp("Item8").setValue("");
  Ext.getCmp("Item9").setValue("");
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
function menunew()
{
	curmenuid = "";
	menuWin("");
}
function menuWin(menuid) {

	var arr = new Array();
	curmenuid = menuid;
	// alert(curmenuid);
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCNURBG_HLBLPublMake", "", "");
	// alert(a);
	arr = eval(a);
	var window = new Ext.Window({
		title : '共享项目维护',
		id : "gform2",
		width : 600,
		height : 250,
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
function Save(win, menuid) {
	ret = "";
	checkret = "";
	comboret = "";
	var Save = document.getElementById('Save2');
	var PublCode=Ext.getCmp('PublCode').getValue();
	if(!PublCode){Ext.Msg.alert('提示','代码不能为空！');return;}
	var PublDesc=Ext.getCmp('PublDesc').getValue();
	if(!PublDesc){Ext.Msg.alert('提示','名称不能为空！');return;}
	
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
function loadgrid() {
	
	Ext.getCmp("mygrid").store.load({
		params : {
			start : 0,
			limit : 25
		}
	});
}
function menumod()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}

	var menuid = rowObj[0].get("rw");
	menuWin(menuid);
}

function Load()
{
}
