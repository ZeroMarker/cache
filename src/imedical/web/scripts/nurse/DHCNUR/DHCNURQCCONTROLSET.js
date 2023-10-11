var Width = document.body.clientWidth;
var Height = document.body.clientHeight;
//质控项目
var QcItm = new Ext.form.ComboBox({
	name : 'qcitm',
	id : 'qcitm',
	store : new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader : new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : 'results',
			fields : [{
				'name' : 'QualDesc',
				'mapping' : 'QualDesc'
			}, {
				'name' : 'rw',
				'mapping' : 'rw'
			}]
		}),
		baseParams : {
			className : 'web.DHCMgNurSysComm',
			methodName : 'GetQualCode',
			type : 'RecQuery'
		}
	}),
	tabIndex : '0',
	listWidth : '180',
	height : 18,
	width : 120,
	xtype : 'combo',
	displayField : 'QualDesc',
	valueField : 'rw',
	hideTrigger : false,
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 1000,
	typeAhead : true,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
});
//科室
var comboboxDep = new Ext.form.ComboBox({
	name : 'comboboxdep',
	id : 'comboboxdep',
	store : new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader : new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : 'results',
			fields : [{
				'name' : 'ctlocDesc',
				'mapping' : 'ctlocDesc'
			}, {
				'name' : 'CtLocDr',
				'mapping' : 'CtLocDr'
			}]
		}),
		baseParams : {
			className : 'web.DHCMgNurPerHRComm',
			methodName : 'SearchComboDep',
			type : 'Query'
		}
	}),
	tabIndex : '0',
	listWidth : '220',
	height : 18,
	width : 150,
	xtype : 'combo',
	displayField : 'ctlocDesc',
	valueField : 'CtLocDr',
	hideTrigger : false,
	queryParam : 'ward1',
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 10000,
	typeAhead : true,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
});
//模板名
var QcModelName = new Ext.form.ComboBox({
	name : 'qcmodelname',
	id : 'qcmodelname',
	store : new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader : new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : 'results',
			fields : [{
				'name' : 'modelname',
				'mapping' : 'modelname'
			}, {
				'name' : 'modelid',
				'mapping' : 'modelid'
			}]
		}),
		baseParams : {
			className : 'web.DHCMgNurQcRestruct',
			methodName : 'FindQcModel',
			type : 'RecQuery'
		}
	}),
	tabIndex : '0',
	listWidth : '180',
	height : 18,
	width : 120,
	xtype : 'combo',
	displayField : 'modelname',
	valueField : 'modelid',
	hideTrigger : false,
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 1000,
	typeAhead : false,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
});
var modelName = new Ext.form.TextField({
	id:'modelname',
	width:100	
});
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
function BodyLoadHandler()
{
	var mygrid1pl = Ext.getCmp('mygrid1pl');
	mygrid1pl.setWidth(Width/2);
	mygrid1pl.setHeight(Height/2);
	var mygrid2pl = Ext.getCmp('mygrid2pl');
	mygrid2pl.setPosition(0,Height/2);
	mygrid2pl.setWidth(Width/2);
	mygrid2pl.setHeight(Height/2);
	var mygrid3pl = Ext.getCmp('mygrid3pl');
	mygrid3pl.setPosition(Width/2,0);
	mygrid3pl.setHeight(Height);
	mygrid3pl.setWidth(Width/2);
	var mygrid1 = Ext.getCmp('mygrid1');
	mygrid1.getTopToolbar().hide();
	var mygrid2 = Ext.getCmp('mygrid2');
	mygrid2.getTopToolbar().hide();
	var mygrid3 = Ext.getCmp('mygrid3');
	mygrid3.getTopToolbar().hide();
	var tobar1 = new Ext.Toolbar({});
	if(secGrpFlag=="nurhead"||secGrpFlag=="znurhead"){
		tobar1.addItem('-','科室:',comboboxDep);
	}
	tobar1.addItem('-','模板名:',modelName);
	tobar1.addItem('-');
	tobar1.addButton({
		id:'addmodelbtn',
		text:'新建',
		handler:function(){
			addNewModel();	
		}	
	});
	tobar1.addItem('-');
	tobar1.addButton({
		id:'delmodelbtn',
		text:'删除二级项',
		handler:function(){delSecItm();}	
	});
	//tobar1.addItem('-','模板名:',QcModelName);
	mygrid1.getBottomToolbar().hide();
	setBottomTool(mygrid1,30);
	var tobar2 = new Ext.Toolbar({});
	tobar2.addItem('-','质控项目:',QcItm);
	tobar2.addItem('-','常用模板:',QcModelName);
	tobar2.addItem('-');
	tobar2.addButton({
		id:'addsecitmbtn',
		text:'关联二级项',
		handler:function(){
			qcLinkSecItms();
		}
	});
	var tobar3 = new Ext.Toolbar({});
	tobar3.addItem('-');
	tobar3.addButton({
		id:'linkthirdbtn',
		text:'关联三级项',
		handler:function(){linkThirdItms();}	
	})
	mygrid2.getBottomToolbar().hide();
	setBottomTool(mygrid2,30);
	mygrid3.getBottomToolbar().hide();
	setBottomTool(mygrid3,10000);
	tobar1.render(mygrid1.tbar);
	tobar2.render(mygrid2.tbar);
	tobar3.render(mygrid3.tbar);
	QcItm.on('select',getSecondItems);
	QcModelName.on('focus',function(){
		if((secGrpFlag=="nurhead"||secGrpFlag=="znurhead") && !comboboxDep.getValue()){
			Ext.Msg.alert('提示','请选择科室');
			QcModelName.setValue('');
			return;
		}
		QcModelName.store.on('beforeload',function(){
			if(secGrpFlag=="nurhead"){
				QcModelName.store.baseParams.typ = "W";
				QcModelName.store.baseParams.ward = comboboxDep.getValue();
			}else if(secGrpFlag=="hlb"){
				QcModelName.store.baseParams.typ = "H";
				QcModelName.store.baseParams.ward = "";
			}else if(secGrpFlag=="znurhead"){
				QcModelName.store.baseParams.typ = "Z";
				QcModelName.store.baseParams.ward = comboboxDep.getValue();
			}
		});
	});
	QcModelName.on('select',function(combo, record, index){
		mygrid1.store.on('beforeload',function(){
			mygrid1.store.baseParams.par = combo.getValue();
		})
		mygrid1.store.load({params:{start:0,limit:1000}});
	})
	mygrid2.store.on('beforeload',function(){
		 mygrid2.store.baseParams.par = QcItm.getValue();
	});
	mygrid3.store.on('beforeload',function(){
		mygrid3.store.baseParams.Moudtype="0";
		mygrid3.store.baseParams.Par=QcItm.getValue();	
	});
	
	comboboxDep.on('select',function(){
		QcModelName.setValue('');
		QcModelName.store.on('beforeload',function(){
			if(secGrpFlag=="nurhead"){
				QcModelName.store.baseParams.typ = "W";
				QcModelName.store.baseParams.ward = comboboxDep.getValue();
			}else if(secGrpFlag=="hlb"){
				QcModelName.store.baseParams.typ = "H";
				QcModelName.store.baseParams.ward = "";
			}else if(secGrpFlag=="znurhead"){
				QcModelName.store.baseParams.typ = "Z";
				QcModelName.store.baseParams.ward = comboboxDep.getValue();
			}
		});	
		QcModelName.store.load({params:{start:0,limit:1000}});
	})
	comboboxDep.store.on('beforeload',function(){
		var pward=comboboxDep.lastQuery;
		var nurseString=session['LOGON.USERID']+"^"+secGrpFlag+"^";
		comboboxDep.store.baseParams.typ=1;
		comboboxDep.store.baseParams.ward1=pward;        
		comboboxDep.store.baseParams.nurseid=nurseString;
	});
	var contextmenu=new Ext.menu.Menu({
		id:'theContextMenu',
 		items:[{
 			text:'三级项目',
   		handler:function(){
   			getThirdItems();
   		}
  	}]
	});
	mygrid1.on('rowcontextmenu',function(mygrid,rowIndex,e){
		if(rowIndex < 0){return;}
		e.preventDefault();
 		contextmenu.showAt(e.getXY());
	});
	mygrid1.on('rowclick',function(){mygrid3.store.load({params:{start:0,limit:1000}})});
}
function getThirdItems()
{
	var grid = Ext.getCmp('mygrid1');
	var rowObj = grid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		return;
	}
	var PRow = rowObj[0].get('PRow');
	var RowID = rowObj[0].get('RowID');
	createWin(PRow,RowID);
}
function createWin(PRow,RowID)
{
	var mypanel = createPal();
	var win=new Ext.Window({
 		title:'三级项目',
		id:'contentwin',
		x:20,y:20,
		width:680,
		height:Height-50,
		layout:'absolute',
		modal:true,
		resizable: false,
		items:[mypanel],
		buttons:[{
			id:'OkBtn',
			text:'确定',
			handler:function(){win.close();}	
		}]
 	});
	win.show();
	var grid = Ext.getCmp('contentgrid');
	grid.store.on('beforeload',function(){
		grid.store.baseParams.par = PRow;
		grid.store.baseParams.rw = RowID;
	});
	schThirdData();
}
function schThirdData()
{
	var grid = Ext.getCmp('contentgrid');
	grid.store.load({params:{start:0,limit:1000}});
}
function createPal()
{
	var table = createTbl();
	var panel = new Ext.Panel({
		id:'contentpal',
		region: 'center',
		margins:'3 3 3 0',
		activeTab: 0,
		x:-1,y:-8,
		border:false,
		height: Height-100,
		width: 680,
		tbar:[],
		items:[{
			items:[table]
		}]
	});
	return panel;
}
function createTbl()
{
	var colModelStr = new Array();
	var colData = new Array();
	colModelStr.push(new Ext.grid.RowNumberer());
	colModelStr.push({header:'描述',width:350,align:'left',sortable:false,dataIndex:'thirddesc'});	
	colData.push({'name':'thirddesc','mapping':'thirddesc'});
	colModelStr.push({header:'Fpar',width:50,align:'center',sortable:false,dataIndex:'Fpar'});	
	colData.push({'name':'Fpar','mapping':'Fpar'});
	colModelStr.push({header:'Spar',width:50,align:'center',sortable:false,dataIndex:'Spar'});	
	colData.push({'name':'Spar','mapping':'Spar'});
	colModelStr.push({header:'Thraw',width:50,align:'center',sortable:false,dataIndex:'Thraw'});	
	colData.push({'name':'Thraw','mapping':'Thraw'});
	colModelStr.push({header:'TMinLevel',width:50,align:'center',sortable:false,dataIndex:'TMinLevel'});	
	colData.push({'name':'TMinLevel','mapping':'TMinLevel'});
	var colModel = new Ext.grid.ColumnModel(colModelStr);
	var store = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
		reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
			fields:colData
		}),
		baseParams:{className:'web.DHCMgNurQcRestruct',methodName:'FindThirdQcItms',type:'RecQuery'}
	});
	var table = new Ext.grid.GridPanel({
		id:'contentgrid',
		x:5,y:0,
		height:Height-142,
		width:666,
		store:store,
		cm:colModel,
		tbar:['-',new Ext.Button({id:'delthirdBtn',text:'删除',handler:function(){delThirdData();}})]
	});
	return table;
}
function delThirdData()
{
	var grid = Ext.getCmp('contentgrid');
	var rowObj = grid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择要删除的记录！');
		return;
	}
	var Fpar = rowObj[0].get('Fpar');
	var Spar = rowObj[0].get('Spar');
	var Thraw = rowObj[0].get('Thraw');
	tkMakeServerCall('DHCMGNUR.MgNurQcModChildSub','delSunData',Fpar,Spar,Thraw);
	schThirdData();
}
function delSecItm()
{
	var mygrid = Ext.getCmp('mygrid1');
	var rowObj = mygrid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择要删除的行记录！');
		return;
	}
	var PRow = rowObj[0].get('PRow');
	var RowID = rowObj[0].get('RowID');
	if(PRow!=undefined && PRow!=null && RowID!=undefined && RowID!=null){
		tkMakeServerCall('DHCMGNUR.MgNurQcModelChild','delRecItm',PRow,RowID);
	}
	mygrid.store.load({params:{start:0,limit:1000}});
}
function linkThirdItms()
{
	var mygrid = Ext.getCmp('mygrid1');
	var rowObj = mygrid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择要关联的模板二级项');
		return;
	}
	var PRow = rowObj[0].get('PRow');
	var RowID = rowObj[0].get('RowID');
	var grid3 = Ext.getCmp('mygrid3');
	
	if(PRow != undefined && PRow != null && RowID != undefined && RowID != null){
		var gridRowObj = grid3.getSelectionModel().getSelections();
		var len = gridRowObj.length;
		if(len==0){
			Ext.Msg.alert('提示','请选择要关联的三级项目');
			return;
		}
		for(var i = 0;i < len;i++){
			var code = gridRowObj[i].get('ItemCode');
			var desc = gridRowObj[i].get('ItemDesc'); //描述
			var score = gridRowObj[i].get('ItemValue'); //分值
			var QcPar = gridRowObj[i].get('Par'); //质控项目par
			var QcRaw = gridRowObj[i].get('rw'); //质控项目rw
			var MinLevel = gridRowObj[i].get('MinLevel'); //
			var ItemLevel = gridRowObj[i].get('ItemLevel');
			if(MinLevel=="N") continue;
			var parr = "PRow|"+PRow+"^RowID|"+RowID+"^ItemCode|"+code+"^ItemDesc|"+desc+"^ItemLevel|"+ItemLevel+"^ItemValue|"+score+"^MinLevel|"+MinLevel+"^sunRowId|"+""+"^ChildPar|"+QcPar+"^ChildRw|"+QcRaw+"^QualItem|"+QcPar+"!"+QcRaw;
			var sunIsExist = tkMakeServerCall('DHCMGNUR.MgNurQcModChildSub','isExistRec',parr);
			if(sunIsExist==1) continue;
			tkMakeServerCall('DHCMGNUR.MgNurQcModChildSub','SaveSunItms',parr);
		}
		Ext.Msg.alert('提示','关联成功!');
	}
}
function qcLinkSecItms()
{
	var ward =Ext.getCmp('comboboxdep').getValue();
	if(secGrpFlag=="nurhead" && !ward){
		Ext.Msg.alert('提示','请选择科室!');
		return;
	}
	var grid = Ext.getCmp('mygrid2');
	var rowObj = grid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择要关联的二级项目！');
		return;
	}
	var modelName = Ext.getCmp('qcmodelname').getValue();
	if(!modelName){
		Ext.Msg.alert('提示','请选择模板！');
		return;
	}
	for(var i =0; i < rowObj.length;i++){
		var desc = rowObj[i].get('itemDesc');
		var par = rowObj[i].get('par');
		var rw = rowObj[i].get('raw');
		var parStr =  "modelName|"+modelName+"^ChildDesc|"+desc+"^ChildPar|"+par+"^ChildRw|"+rw+"^rowId|"+""+"^ChildMinLev|"+"N";
		var secIsExist=tkMakeServerCall('DHCMGNUR.MgNurQcModelChild','isExistRec',parStr);
		if(secIsExist==1) continue;
		tkMakeServerCall('DHCMGNUR.MgNurQcModelChild','SaveChildSub',parStr);
	}
	Ext.getCmp('mygrid1').store.load({params:{start:0,limit:1000}});
}
function addNewModel()
{
	var rw="";
	saveItems(rw);
}
function saveItems(rw)
{
	var ward = Ext.getCmp('comboboxdep').getValue();
	if(secGrpFlag=="nurhead" && !ward){
		Ext.Msg.alert('提示','科室不能为空！');
		return;
	}
	var modelName = Ext.getCmp('modelname').getValue();
	if(!modelName){
		Ext.Msg.alert('提示','请填写模板名称！');
		return;
	}
	var modeltype ="";
	if(secGrpFlag=="hlb"){
		modeltyp="H";
	}else if(secGrpFlag=="nurhead"){
		modeltyp="W";
	}else if(secGrpFlag=="znurhead"){
		modeltyp="Z";
	}else{
		return;
	}
	var parr = "ModelDep|"+ward+"^ModelName|"+modelName+"^ModelTyp|"+modeltyp+"^RecUser|"+session['LOGON.USERID']+"^Status|"+"Y"+"^rw|"+rw;
	var isExistRec = tkMakeServerCall('DHCMGNUR.MgNurQcModel','isExistRec',parr);
	if(isExistRec==1){
		Ext.Msg.alert('提示','此记录已经存在！');
		return;
	}
	tkMakeServerCall('DHCMGNUR.MgNurQcModel','Save',parr);
}
function getSecondItems(combo, record, index)
{
	var mygrid2 = Ext.getCmp('mygrid2');
	mygrid2.store.load({params:{start:0,limit:30}});
	var mygrid3 =Ext.getCmp('mygrid3');
	mygrid3.store.load({params:{start:0,limit:1000}});
}
function setBottomTool(grid,pageSize)
{
	var bbar1 = new Ext.PagingToolbar({
		pageSize:pageSize,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar1.render(grid.bbar);
}