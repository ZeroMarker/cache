var InfoPanel;
var singleMulCheckItems;
var singleMulTarItems;
var ch1 = String.fromCharCode(1);
var ch2 = String.fromCharCode(2);
returnValue="";
var SelARCIMRowArr=new Array();
//左侧树样式
var tree = new Ext.tree.TreePanel({
		id:'tree',
		width:270,
		region: 'west',
		border:false,
		animate:true,
		enableDD:true,
		containerScroll:true,
		split: true,
		autoScroll:true,
		collapsible: true,
		rootVisible: true,
	    title: RootNodeName+'选择',
	    autoScroll:true,
	    loader: new Ext.tree.TreeLoader({dataUrl:"dhcdocoeorderdata.csp?action=tree&Root="+RootNodeId}),
	    root: new Ext.tree.AsyncTreeNode({
	                  text: RootNodeName,
	                  id: RootNodeId,
	                value:'0',	
	                expanded:true
	    }),
	    listeners:{
	        "click":function(node,event){
				nodeclicked(node);
				//加载数据集
				grid.store.load({params:{PrentId:node.attributes.id}});
				//grid.store.load();
				//Ext.Msg.alert('Navigation Tree Click', 'You clicked: "' + node.attributes.id + '"');
			}
	    }
	});
//------------------------------------------------------------			
//表格列样式定义
var column = new Ext.grid.ColumnModel([
//new Ext.grid.RowNumberer(),
//new Ext.grid.CheckboxSelectionModel(),
{header: 'Rowid',dataIndex: 'code',width: 30,sortable: true,hidden:true},
{header:"选择",dataIndex:'addsid',renderer:changeCheck,width:7,sortable:false },
{header: "医嘱项",dataIndex: 'name',width: 60,sortable: true},
{header: 'Rowid1',dataIndex: 'code1',width: 30,sortable: true,hidden:true},
{header:"选择",dataIndex:'addsid1',renderer:changeCheck,width:7,sortable:false },
{header: "医嘱项",dataIndex: 'name1',width: 60,sortable: true},
{header: 'Rowid2',dataIndex: 'code2',width: 30,sortable: true,hidden:true},
{header:"选择",dataIndex:'addsid2',renderer:changeCheck,width:7,sortable:false },
{header: "医嘱项",dataIndex: 'name2',width: 60,sortable: true} ,
{header: "",dataIndex: 'parentName', width:60,sortable:true,hidden:true}	//wanghc 2011-11-30
]);
function changeCheck(value,cellmeta,record,rowIndex,columnIndex,store){
	if(cellmeta.value!="&#160;"){
		var Id="adds_checkbox_"+rowIndex+"_"+columnIndex;
		return "<input type='checkbox' name='adds_checkbox' onclick=oneclick(this) id="+Id+"></input>"; 
	}
}
function oneclick(Obj)
{
	var IsArcosFlag=0;
	var Temp=Obj.id.split("_");
	var SelRow=Temp[Temp.length-2];
	var SelCell=Temp[Temp.length-1];
	var SelrowHtmlObj = grid.getView().getRow(SelRow);
	var SelcellHtmlObj=grid.getView().getCell(SelRow,SelCell-1);			//隐藏rowid
  	var Rowid = SelcellHtmlObj.innerText;
  	var DesccellHtmlObj=grid.getView().getCell(SelRow,parseInt(SelCell)+1);	//desc字段值
  	var Desc=DesccellHtmlObj.innerText;
	if (Desc=="") return;
	var rowidArr =  Rowid.split(ch1);
	var labNo;
  	if(rowidArr.length>1) { labNo = rowidArr[1]; }
	Rowid = rowidArr[0];
	var AddsCheck = Obj.checked;
	if (AddsCheck == true) {
		SelARCIMRowArr[Rowid]=Obj
		//得到选择的对象的rowid
		Ext.Ajax.request({
			url:'dhcdocoeorderdata.csp',
			params:{action:'GetArcimStr',ParaRowid:Rowid} ,
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.ArcimStr!='') {
					IsArcosFlag=1;
					//alert(jsonData.ArcimStr)
					var TempArcos=jsonData.ArcimStr.split("^");
					for (var i=0;i<TempArcos.length;i++) {
						var ArcimRowid = TempArcos[i].split(ch2)[0];
						var ArcimDesc = TempArcos[i].split(ch2)[1];
						var record = new Object();
				        record.rowid = rowidArr.length>1 ? ArcimRowid+ch1+labNo : ArcimRowid ;
				        record.desc = ArcimDesc;
				        record.checkedRowid = Rowid;
				        var records = new Ext.data.Record(record);
						mulSelSotre.add(records);
					}
				}
				if (IsArcosFlag!=1) {
					var record = new Object();
			        record.rowid = rowidArr.length>1 ? Rowid+ch1+labNo : Rowid ;
			        record.desc = Desc;  
			        record.checkedRowid = Rowid;
			        var records = new Ext.data.Record(record); 
					mulSelSotre.add(records);
				}
				
			},
			scope: this
		}) ;
	}else{
		mulSelSotre.each(function(r){
			if(r.data['checkedRowid']==Rowid){ mulSelSotre.remove(r);mulTarSotre.removeAll(); }
		}); 
	}
}
function checkall()
{
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var str="";
	for (var i = 0; i < rowCount; i++) {
		/*
		var sel=store.getAt(i).get("select");
		if (sel==false)
		{	
			//grid.get('adds_checkbox_'+i).setValue(true);
			//Ext.getCmp('adds_checkbox_'+i).getSelectionModel().select(2);
		}
		*/
	}
}
 

/*  //分页工具栏
var pagetoolbar = new Ext.PagingToolbar({  
	pageSize: 25,
	store:store,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据",
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['id']=repdr;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});
*/
var store = new Ext.data.GroupingStore({	//wanghc 2011-11-30
	proxy:new Ext.data.HttpProxy({url:'dhcdocoeorderdata.csp?action=grid'}),
	groupField: 'parentName',
	reader:new Ext.data.JsonReader(
		{
		root: 'rows',
		totalProperty: 'results'
		//idProperty: 'id'
		},
		[
			{name:'code',type:'string'},
			{name:'select',type:'boolean'},
		  	{name:'name',type:'string'},
		  	{name:'code1',type:'string'},
			{name:'select1',type:'boolean'},
		  	{name:'name1',type:'string'},
		  	{name:'code2',type:'string'},
			{name:'select2',type:'boolean'},
		  	{name:'name2',type:'string'},
		  	{name:'parentName',type:'string'}
		]),
		remoteSort: true
	});
	
//加载数据集
store.load({params:{PrentId:""}});

var sm = new Ext.grid.CheckboxSelectionModel(); 

var grid = new Ext.grid.EditorGridPanel({//表格
	//title: '部门分层',
	//width:500,
	region: 'center',
	xtype: 'grid',
	store: store,
	cm: column,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	//viewConfig: {forceFit:true},
	clickToEdit:1,
	selModel:sm,
	view: new Ext.grid.GroupingView({	//wanghc 2011-11-30
		forceFit: true,
		groupTextTpl:'{text} ({[values.rs.length]} 行记录)'
	}) 
	//bbar:pagetoolbar
});

/*	//原想使用grid实现页面的已经选择项目的显示,不适合,现不用
var Selectedstore = new Ext.data.Store({
	proxy:new Ext.data.HttpProxy({url:'dhcdocoeorderdata.csp?action=Selectedgrid'}),
	reader:new Ext.data.JsonReader(
		{
		root: 'rows',
		totalProperty: 'results'
		//idProperty: 'id'
		},
		[
			{name:'code1',type:'string'},
			{name:'select1',type:'boolean'},
		  	{name:'name1',type:'string'},
		  	
		  	{name:'code2',type:'string'},
			{name:'select2',type:'boolean'},
		  	{name:'name2',type:'string'},
		  	
		  	{name:'code3',type:'string'},
			{name:'select3',type:'boolean'},
		  	{name:'name3',type:'string'}
		]),
		remoteSort: true
	});
	
//加载数据集
Selectedstore.load({params:{PrentId:""}});

var Selectcolumn = new Ext.grid.ColumnModel([
	{header: 'Rowid1',dataIndex: 'code1',width: 60,sortable: true,hidden:true},
	{header:"选择",dataIndex:'addsid1',renderer:changeCheck,width:40,sortable:false },
	{header: "医嘱项",dataIndex: 'name1',width: 100,sortable: true},
	
	{header: 'Rowid2',dataIndex: 'code2',width: 60,sortable: true,hidden:true},
	{header:"选择",dataIndex:'addsid2',renderer:changeCheck, width:40,sortable:false },
	{header: "医嘱项",dataIndex: 'name2',width: 100,sortable: true},
	
	{header: 'Rowid3',dataIndex: 'code3',width: 60,sortable: true,hidden:true},
	{header:"选择",	dataIndex:'addsid3', renderer:changeCheck, width:40, sortable:false },
	{header: "医嘱项",dataIndex: 'name3',width: 100,sortable: true}
]);
var Selectedgrid = new Ext.grid.EditorGridPanel({
	region: 'center',
	xtype: 'grid',
	store: Selectedstore,
	cm: Selectcolumn,
	trackMouseOver: true,
	stripeRows: true,
	width: 592,
	height: 100,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	clickToEdit:1,
	selModel:sm 
});
//处理checkbox的勾选事件
grid.getSelectionModel().on('rowselect', function(sm, rowIdx, r){ 
	//alert('勾选了checkbox后，获得选中行的name:'+grid.store.getAt(rowIdx).get('name')); 
}); 
//处理checkbox的取消勾选事件 
grid.getSelectionModel().on('rowdeselect', function(sm, rowIdx, r){ 
	//alert('取消勾选checkbox后，获得的record 中的name:'+grid.store.getAt(rowIdx).get('name')); 
});
*/
//----------------------------------------------------

function onClickReturnBtn(){
	returnValue="";
	self.close();
}
function onClickAddBtn(){
	var str="";
	var Count = mulSelSotre.getCount(); //记录数
	for(var i=0;i<Count;i++){
		var Recode=mulSelSotre.getAt(i);
		var Rowid=Recode.get("rowid");
		var Desc=Recode.get("desc");
		if (str=="") {
  			str=Rowid;
  		}else{
  			str=str+"^"+Rowid;
  		}
	}
	
	/*	原未使用multiselect前选择项目增加的方法
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount(); //列数
	var view = grid.getView();
	for(i=0;i<rowCount;i++){
//	  	for(j=0;j<colCount;j++){
//	    	var cell = view.getCell(i,j);
//	    	alert(rowHtmlObj.innerHTML);
//	    	alert(rowHtmlObj.innerText);
//	  	}
	  	var rowHtmlObj=view.getRow(i);
	  	var cellHtmlObj=view.getCell(i,0);	//隐藏rowid
	  	var Rowid=cellHtmlObj.innerText;
	  	var AddsObj=rowHtmlObj.document.getElementById("adds_checkbox_"+i+"_0");
	  	if (AddsObj) {
		  	if (AddsObj.checked==true) {
		  		if (str=="") {
		  			str=Rowid;
		  		}else{
		  			str=str+"^"+Rowid;
		  		}
		  	}
	  	}
	}
	**/	
	returnValue=str;
	self.close();
}

var mulSelSotre = new Ext.data.Store({
		id:"mulSelStore", 
		autoLoad : true,
		proxy : new Ext.data.HttpProxy({url:"dhcdocoeorderdata?active=mulSelArcimData"}),   
		reader: new Ext.data.JsonReader({   
			totalProperty:"totalCount",   
			root:"results"},   
			[   
			{name:"checkedRowid"},
			{name:"rowid"},   
			{name:"desc"}
			]   
		),
		listeners:{
			add:function(){
				var Count = mulSelSotre.getCount();
				var Recode=mulSelSotre.getAt(Count-1);
				var ArcimRowid=Recode.get("rowid");
				GetTarItems(ArcimRowid);
				GetItemMsg(ArcimRowid);
			}
		}  
	})

var mulTarSotre = new Ext.data.Store({
		id:"mulTarSotre", 
		autoLoad : true,
		proxy : new Ext.data.HttpProxy({url:"dhcdocoeorderdata?active=mulTarArcimData"}),   
		reader: new Ext.data.JsonReader({   
			totalProperty:"totalCount",
			root:"results"},   
			[   
			{name:"checkedRowid"},
			{name:"rowid"},   
			{name:"desc"}   
			]   
		)  
	});
function GetTarItems(ArcimRowid){
	//mulTarSotre.removeAll();
	Ext.Ajax.request({
		url:'dhcdocoeorderdata.csp',
		params:{action:'GetTarItems',ParaRowid:ArcimRowid} ,
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.TarItemsStr!='') {
				//alert(jsonData.TarItemsStr)
				mulTarSotre.removeAll();
				var TempTarItems=jsonData.TarItemsStr.split("^");
				for (var i=0;i<TempTarItems.length;i++) {
					var TarRowid = TempTarItems[i].split(ch2)[0];
					var TarDesc = TempTarItems[i].split(ch2)[1];
					var record = new Object();
			        record.rowid = TarRowid ;
			        record.desc = TarDesc;
			        record.checkedRowid = TarRowid;
			        var records = new Ext.data.Record(record); 
					mulTarSotre.add(records);
				}
			}
		},
		scope: this
	}) ;
}
function GetItemMsg(ArcimRowid){
	Ext.Ajax.request({
		url:'dhcdocoeorderdata.csp',
		params:{action:'GetItemMsg',ParaRowid:ArcimRowid} ,
		success: function(result, request) {
			Ext.getCmp("arcimAlert").setValue('');
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.ItemMsg!='') {
				Ext.getCmp("arcimAlert").setValue(jsonData.ItemMsg);
			}
		},
		scope: this
	}) ;
}
	
function initNorthContainer(){
		singleMulCheckItems	=[{
		    store: mulSelSotre,
			xtype: 'multiselect',
			fieldLabel: '已选择医嘱',
			name: 'mulSelArcim',
			id:'mulSelArcim',
			width: 200,
			height: 150,
			allowBlank:false,
			displayField:'desc',
	        valueField:'rowid',
	        /*
			tbar:[{
				text: '清空',
				handler: function(){
					InfoPanel.getForm().findField('mulSelArcim').reset();
				}
			}],*/
			ddReorder: true,
			listeners:{
				"click":function(obj,event){
					var Count = mulSelSotre.getCount(); //记录数
					if(Count==1) return 
					var ArcimRowid=this.getRawValue();
					GetTarItems(ArcimRowid);
					GetItemMsg(ArcimRowid);
				},
				dblclick:function(obj,event){
					//alert(this.getRawValue())
					var ArcimRowid1=this.getRawValue();
					var Count1 = mulSelSotre.getCount(); //记录数
					var SelIndex=this.view.getSelectedIndexes();
					var flag=confirm("是否取消增加此项目?");
					if (flag==false) return;
					this.view.store.removeAt(SelIndex);
					mulTarSotre.removeAll();
					//取消时,收费项目默认是最后一条选中项目的
					var Count = mulSelSotre.getCount(); //记录数
					if(Count==0){
						mulTarSotre.removeAll();
						Ext.getCmp("arcimAlert").setValue('');
					}else{
						var Recode=mulSelSotre.getAt(Count-1);
					    var ArcimRowid=Recode.get("rowid");
					    GetTarItems(ArcimRowid);
					    GetItemMsg(ArcimRowid);
					}
					if(SelARCIMRowArr[ArcimRowid1]){
						var Obj=new Object()
						Obj=SelARCIMRowArr[ArcimRowid1]
						Obj.checked=false;
					}
				}
			}
		}];
		singleMulTarItems =[{
		    store: mulTarSotre,
			xtype: 'multiselect',
			fieldLabel: '收费项目',
			name: 'mulTarArcim',
			id:'mulTarArcim',
			width: 200,
			height: 150,
			allowBlank:false,
			displayField:'desc',
	        valueField:'rowid',
			ddReorder: true
		}];
	var arciminput = new Ext.form.TextField({
		fieldLabel: '医嘱名',
		width:220,
		height:24,
		enableKeyEvents:true,
		id:'arciminput'
	});
	var arcimAlert = new Ext.form.TextArea({
		fieldLabel: '医嘱提示',
		id:'arcimAlert',
		width:220,
		height:80,
		autoHeight:true,
		readOnly:true,
		style:'color:blue;background:#999999'
	});
	formItems = [{
		columnWidth: .3,
		layout:'form',
		baseCls:'x-plain',
		items:[singleMulCheckItems]
	},{
		columnWidth: .3,
		layout:'form',
		baseCls:'x-plain',
		items:[singleMulTarItems]
	},{
		columnWidth: .3,
		layout:'form',
		baseCls:'x-plain',
		items:[arcimAlert,arciminput]		
	}];
	var singleFormBtn = [{
			text:'增加',
			name:'btnAdd',
			iconCls:'icon-add-custom',
			id:'btnAdd'
		},{
			text:'返回',
			name:'btnReturn',
			iconCls:'icon-undo-custom',
			id:'btnReturn'
			//disabled:true 
		}];
    InfoPanel = new Ext.form.FormPanel({
		title:"",
		region:"south",
		height:200,
		layout:'column',
		labelAlign:'right', 
		buttonAlign:'center',
		labelWidth:80,
		frame:true,
		defaults: {width:100},
		id:'paadmInfo',
		name:'paadmInfo',
		items:[formItems],
		buttons:singleFormBtn
	});
}
function onKeydownArciminput(t,e){
	if(e.getKey()!== 13) return ""
	var ItemzLookupGrid;
	var OrderName = t.getValue();
	var GroupID = session['LOGON.GROUPID']; // DHCC_GetElementData('GroupID');
	var catID = ""; //DHCC_GetElementData('catID');
	var subCatID = "" //DHCC_GetElementData('subCatID');
	var P5 = "L^SERVICE";
	var LogonDep = session['LOGON.CTLOCID']; //GetLogonLocByFlag();
	var OrderPriorRowid = "" ;//DHCC_GetElementData('OrderPriorRowid');
	var EpisodeID = "";
	var P9="",P10 = "";
	var OrdCatGrp = ""; // DHCC_GetElementData('OrdCatGrp');	
	if (ItemzLookupGrid&&ItemzLookupGrid.store) {
		ItemzLookupGrid.searchAndShow([OrderName,GroupID,catID,subCatID,P5,LogonDep,OrderPriorRowid,EpisodeID,P9,P10,session["LOGON.USERID"],OrdCatGrp]);
	}else {
		ItemzLookupGrid = new dhcc.icare.Lookup({
			lookupListComponetId: 1872,
			lookupPage: "dhcdocoeordermain",
			lookupName: "arciminput",
			listClassName: 'web.DHCDocOrderEntry',	
			listQueryName: 'LookUpItem',
			resizeColumn: true,
			listProperties: [OrderName,GroupID,catID,subCatID,P5,LogonDep,OrderPriorRowid,EpisodeID,P9,P10,session["LOGON.USERID"],OrdCatGrp], 
			listeners:{'selectRow': arciminputSelectRow}			
		});
	}
	return websys_cancel();
}
function arciminputSelectRow(str){
	var arr = str .split("^");
	var record = new Object();
    record.rowid = arr[1]; //rowid
    record.desc = arr[0];  
    record.checkedRowid = 0;	//没有选
    var records = new Ext.data.Record(record); 
	mulSelSotre.add(records);

	Ext.getCmp('arciminput').setValue("");
	Ext.getCmp('arciminput').focus(false,20);
}
function initListen(){
	
	if(Ext.getCmp('btnReturn')){
		Ext.getCmp('btnReturn').on('click',onClickReturnBtn) ;	//返回
	}
	if(Ext.getCmp('btnAdd')){
		Ext.getCmp('btnAdd').on('click',onClickAddBtn) ;		//增加
	}
	if(Ext.getCmp('arciminput')){		
		Ext.getCmp('arciminput').on('keypress',onKeydownArciminput) ;
	}
}

Ext.onReady(function(){
	Ext.QuickTips.init();                        //初始化所有Tips
	/*
	var tabpanel = new Ext.TabPanel({
   		activeTab: 0,
		region: 'center',
   		items:treepancel         //添加Tabs
 		});
 	*/
 		/*
	var mainPanel = new Ext.Viewport({
     	layout:'border',
     	items : tabpanel,
     	renderTo: 'mainPanel'
 	})*/
 	
 	initNorthContainer();
 	
 	//得到是否有维护权限的配置
 	var GroupID=session['LOGON.GROUPID'];
 	var TreeMaintain=cspRunServerMethod(GetConfigNode1Method,"TreeMaintain",GroupID);
 	//TreeMaintain = 0;
 	if (TreeMaintain==1) {
 		var treecfgpancel = new Ext.Panel({
	     	//title : RootNodeName+'选择',
	     	layout : 'border',
			region:'center',
	     	items : [treecfg,grid]                  //添加Tab面板
		});
	
		var viewport = new Ext.Viewport({
			layout:'border',
			items:[treecfgpancel]
		});
	}else {
		var treepancel = new Ext.Panel({
	     	title : RootNodeName+'选择',
	     	layout : 'border',
			region:'center',
	     	items : [tree,grid]                  //添加Tab面板
		});
	
	 	var viewport = new Ext.Viewport({
			layout:'border',
			items:[treepancel,InfoPanel]
		});
	}
	initListen();
	
});


var nodeclicked = function(node){
	if (!node.isLeaf()) return;
	
//自己写的一个table
/*
	var csm = new Ext.grid.CheckboxSelectionModel();
  	var cum = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		csm,
		{header:"收费医嘱项",dataIndex:"OeordFordail"},   
		
  	]);   
  var cumdata = [
		['农行卡']
		['测试']
		
  ];	
	var store = new Ext.data.Store({
		proxy:new Ext.data.MemoryProxy(cumdata),
		reader:new Ext.data.ArrayReader({},[
			{name:'OeordFordail'}
		])
	});
	store.load();
	var cumgrid = new Ext.grid.GridPanel({
		renderTo:'cumGrid',
		autoHeight:true,
		store:store,
		height:200,
        width: 550,
		colModel:cum,
		sm:csm
	});
	*/
	
    	
};
// 隐藏列函数
function HiddenMyColumn(vargrid, varColumnIndex) {
    if (varColumnIndex != "") {
        var cms = vargrid.getColumnModel(); // 获得网格的列模型
        var strarrayUserColumn = new Array();
        strarrayUserColumn = varColumnIndex.split(",");
        for (var i = 0; i < strarrayUserColumn.length; i++) {
            cms.setHidden(strarrayUserColumn[i], true);// 隐藏列模型
        }
    }
}



