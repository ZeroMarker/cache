// 名称:Grid设置管理
// 编写日期:2012-06-11
//=========================定义全局变量=================================
var StkSysAppId = "";
var AppCode = "";
var GridId = "";
var SaveMod = "";
var ModValue = "";
var CspName="";
var GroupId = session['LOGON.GROUPID'];
var UserId=session['LOGON.USERID'];
var SiteCode=session['LOGON.SITECODE']

//=========================定义全局变量=================================
//=========================应用系统设置=================================
var StkSysAppGrid="";
//配置数据源
var StkSysAppGridUrl = 'dhcst.stksysappaction.csp';
var StkSysAppGridProxy= new Ext.data.HttpProxy({url:StkSysAppGridUrl+'?actiontype=selectAll',method:'GET'});
var StkSysAppGridDs = new Ext.data.Store({
	proxy:StkSysAppGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'Type'}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//模型
var StkSysAppGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"代码",
        dataIndex:'Code',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"名称",
        dataIndex:'Desc',
        width:120,
        align:'left',
        sortable:true
    }
]);

//初始化默认排序功能
StkSysAppGridCm.defaultSortable = true;

//表格
StkSysAppGrid = new Ext.grid.GridPanel({
	store:StkSysAppGridDs,
	cm:StkSysAppGridCm,
	trackMouseOver:true,
	height:265,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true})  ,
	loadMask:true
});

StkSysAppGridDs.load();
//=========================应用系统设置=================================

//=========================应用系统属性设置=============================
var StkSysAppParameGrid="";
var StkDecimalDesc="";
//配置数据源
var StkSysAppParameGridUrl = 'dhcst.stksysgridsetaction.csp';
var StkSysAppParameGridProxy= new Ext.data.HttpProxy({url:StkSysAppParameGridUrl,method:'GET'});
var StkSysAppParameGridDs = new Ext.data.Store({
	proxy:StkSysAppParameGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'GridId'},
		{name:'SaveMod'},
		{name:'SaveValue'},
		{name:'CspName'},
		{name:'SaveValueID'},
	]),
    remoteSort:true
});

//模型
var StkSysAppParameGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
        header:"保存模式",
        dataIndex:'SaveMod',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"模式值",
        dataIndex:'SaveValue',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"Grid",
        dataIndex:'GridId',
        width:180,
        align:'left',
        sortable:true
    },{
        header:"菜单",
        dataIndex:'CspName',
        width:180,
        align:'left',
        sortable:true
    },{
        header:"模式值id",
        dataIndex:'SaveValueID',
        width:180,
        align:'left',
        hiden:true
    }
    
]);

//初始化默认排序功能
StkSysAppParameGridCm.defaultSortable = true;

//表格
StkSysAppParameGrid = new Ext.grid.EditorGridPanel({
	store:StkSysAppParameGridDs,
	cm:StkSysAppParameGridCm,
	trackMouseOver:true,
	height:265,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
	loadMask:true,
	clicksToEdit:1,
	deferRowRender:false
});

//=========================Grid设置=============================
var isHidden = new Ext.grid.CheckColumn({
	header:'是否隐藏',
	dataIndex:'hidden',
	width:75,
	sortable:true,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});

var isSortable = new Ext.grid.CheckColumn({
	header:'是否排序',
	dataIndex:'sortable',
	width:75,
	sortable:true,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});
var isEnterSortable = new Ext.grid.CheckColumn({
	header:'回车跳转',
	dataIndex:'entersort',
	width:75,
	sortable:true,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});
var dataTypeStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["any",'any'], ["String",'String'], ["Currency",'Currency'], ["Double",'Double'], ["Single",'Single'], ["Long",'Long'], ["Short",'Short'], ["Date",'Date'], ["Boolean",'Boolean']]
});

var dataTypeField = new Ext.form.ComboBox({
	id:'dataTypeField',
	fieldLabel:'数值类型',
	width:222,
	listWidth:222,
	allowBlank:true,
	store:dataTypeStore,
	value:'', // 默认值""
	valueField:'key',
	displayField:'keyValue',
	emptyText:'数值类型...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	mode:'local'
});

var alignStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["left",'left'], ["right",'right'], ["center",'center'], ["LeftTop",'LeftTop'], ["LeftCenter",'LeftCenter'], ["LeftBottom",'LeftBottom'], ["CenterTop",'CenterTop'], ["CenterCenter",'CenterCenter'], ["CenterBottom",'CenterBottom'], ["RightTop",'RightTop'], ["RightCenter",'RightCenter'], ["RightBottom",'RightBottom'], ["General",'General']]
});

var AlignField = new Ext.form.ComboBox({
	id:'AlignField',
	fieldLabel:'对其方式',
	width:222,
	listWidth:222,
	allowBlank:true,
	store:alignStore,
	value:'', // 默认值""
	valueField:'key',
	displayField:'keyValue',
	emptyText:'对其方式...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	mode:'local'
});

function addNewMXRow() {
	var mxRecord = Ext.data.Record.create([
		{
			name : 'rowid',
			type : 'string'
		},{
			name : 'id',
			type : 'int'
		},{
			name : 'name',
			type : 'string'
		}, {
			name : 'header',
			type : 'string'
		}, {
			name : 'width',
			type : 'int'
		}, {
			name : 'align',
			type : 'string'
		}, {
			name : 'format',
			type : 'string'
		}, {
			name : 'hidden',
			type : 'string'	//'boolean'
		}, {
			name : 'sortable',
			type : 'string'	//'boolean'
		}, {
			name : 'seqno',
			type : 'int'
		}, {
			name : 'datatype',
			type : 'string'
		}
	]);
					
	var MXRecord = new mxRecord({
		rowid:'',
		id:'',
		name:'',
		header:'',
		width:'',
		align:'',
		format:'',
		hidden:false,
		sortable:true,
		seqno:'',
		datatype:''
	});
		
	gridDs.add(MXRecord);
	grid.startEditing(gridDs.getCount() - 1, 1);
}

//配置数据源
var gridUrl = 'dhcst.stksysgridsetaction.csp';
var gridProxy= new Ext.data.HttpProxy({url:gridUrl,method:'GET'});
var gridDs = new Ext.data.Store({
	proxy:gridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
    	{name:'rowid'},
		{name:'id'},
		{name:'name'},
		{name:'header'},
		{name:'width'},
		{name:'align'},
		{name:'format'},
		{name:'hidden'},	//,type:'bool'
		{name:'sortable'},	//,type:'bool'
		{name:'seqno'},
		{name:'datatype'},
		{name:'entersort'}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//模型
var gridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header:'rowid',
		dataIndex:'rowid',
		hidden:true
	},{
        header:"列名",
        dataIndex:'name',
        width:130,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						grid.startEditing(gridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:"列显示名称",
        dataIndex:'header',
        width:130,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'valueField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						grid.startEditing(gridDs.getCount() - 1, 3);
					}
				}
			}
        })
    },{
        header:"列宽",
        dataIndex:'width',
        width:80,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'memoField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						grid.startEditing(gridDs.getCount() - 1, 4);
					}
				}
			}
        })
    },{
        header:"对齐方式",
        dataIndex:'align',
        width:130,
        align:'left',
        sortable:true,
		editor: new Ext.form.ComboBox({
			id:'alignField',
			width:200,
			listWidth:200,
			allowBlank:true,
			store:alignStore,
			value:'', // 默认值""
			valueField:'key',
			displayField:'keyValue',
			emptyText:'',
			triggerAction:'all',
			emptyText:'',
			minChars:1,
			pageSize:"",
			mode:'local',
			selectOnFocus:true,
			forceSelection:true,
			editable:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						grid.startEditing(gridDs.getCount() - 1, 5);
					}
				}
			}
        })
    },{
        header:"数字格式",
        dataIndex:'format',
        width:130,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'memoField',
            allowBlank:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						grid.startEditing(gridDs.getCount() - 1, 8);
					}
				}
			}
        })
    },isHidden,isSortable,isEnterSortable,{
        header:"序列号",
        dataIndex:'seqno',
        width:80,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'memoField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						grid.startEditing(gridDs.getCount() - 1, 9);
					}
				}
			}
        })
    },{
        header:"数据类型",
        dataIndex:'datatype',
        width:150,
        align:'left',
        sortable:true,
		editor: new Ext.form.ComboBox({
			id:'typeField',
			width:200,
			listWidth:200,
			allowBlank:true,
			store:dataTypeStore,
			value:'', // 默认值""
			valueField:'key',
			displayField:'keyValue',
			emptyText:'',
			triggerAction:'all',
			emptyText:'',
			minChars:1,
			pageSize:10,
			mode:'local',
			selectOnFocus:true,
			forceSelection:true,
			editable:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewMXRow();
					}
				}
			}
        })
    }
    
]);

//初始化默认排序功能
gridCm.defaultSortable = true;

var addGrid = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(StkSysAppId!=""){
			addNewMXRow();
		}else{
			Msg.info("error", "请选择应用系统或者保存模式!");
			return false;
		}
	}
});

var saveGrid = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
	width : 70,
	height : 30,
    iconCls:'page_save',
	handler:function(){
		if(grid.activeEditor != null){
			grid.activeEditor.completeEdit();
		} 
		//获取所有的新记录
		var mr=gridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var rowid=mr[i].data["rowid"];
			var id = mr[i].data["id"];
			var name = mr[i].data["name"];
			var header = mr[i].data["header"];
			var width = mr[i].data["width"];
			var align = mr[i].data["align"];
			var format = mr[i].data["format"];
			var hidden = mr[i].data["hidden"];	//(mr[i].data["hidden"]==true?'Y':'N')
			var sortable = mr[i].data["sortable"];	//(mr[i].data["sortable"]==true?'Y':'N');
			var seqno = mr[i].data["seqno"];
			var dataType = mr[i].data["datatype"];
			var entersort=mr[i].data["entersort"];
			if(name!=""){
				var dataRow = rowid+"^"+seqno+"^"+id+"^"+header+"^"+width+"^"+align+"^"+sortable+"^"+hidden+"^"+name+"^"+format+"^"+dataType+"^"+entersort;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}
		
		if(data!=""){
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: gridUrl+'?actiontype=Save',
				params:{ListData:data,AppName:AppCode,GridId:GridId,SaveMod:SaveMod,ModValue:ModValue,CspName:CspName},
				failure: function(result, request) {
					mask.hide();
					Msg.info("error", "请检查网络连接!");
				},
				success: function(result, request) {
					data="";
					var jsonData = Ext.util.JSON.decode( result.responseText );
					mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						gridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=Query&AppName='+AppCode+'&GridId='+GridId+'&SaveMod='+SaveMod+'&ModValue='+ModValue+'&CspName='+CspName,method:'GET'});
						gridDs.load();
					}else{
						Msg.info("error", "保存失败!");
					}
				},
				scope: this
			});
		}
    }
});

//表格
grid = new Ext.grid.EditorGridPanel({
	store:gridDs,
	cm:gridCm,
	trackMouseOver:true,
	height:370,
	plugins:[isHidden,isSortable,isEnterSortable],
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[saveGrid]	//addGrid,'-',  不再显示新建按钮
});
//=========================Grid设置=============================

//=============应用系统设置与保存模式二级联动===================
StkSysAppGrid.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = StkSysAppGridDs.data.items[rowIndex];
	StkSysAppId = selectedRow.data["RowId"];
	AppCode = selectedRow.data["Code"];
	StkSysAppParameGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=GetVsfgInfo&AppName='+AppCode,method:'GET'});
	
	StkSysAppParameGridDs.load({callback:function(record,options,success ){
		if(record.length>0){
			StkSysAppParameGrid.fireEvent('rowclick',this,0);
		} else {
			gridDs.removeAll(); //Huxt 2020-02-24
		}
	}});
	
	
});
//=============应用系统设置与保存模式二级联动===================

//=============保存模式与Grid设置二级联动===================
StkSysAppParameGrid.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = StkSysAppParameGridDs.data.items[rowIndex];
	GridId = selectedRow.data["GridId"];
	SaveMod = selectedRow.data["SaveMod"];
	ModValue = selectedRow.data["SaveValueID"];  //SaveValue
	CspName=selectedRow.data["CspName"];
	gridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=Query&AppName='+AppCode+'&GridId='+GridId+'&SaveMod='+SaveMod+'&ModValue='+ModValue+'&CspName='+CspName,method:'GET'});
	gridDs.load();
});

//删除某一保存模式下的grid设置
function DeleteGridSet(){
	var AppId="";
	var selectAppRow=StkSysAppGrid.getSelectionModel().getSelected();
	if(selectAppRow!=null){
		AppId=selectAppRow.get("RowId");
	}
	var selectedRow = StkSysAppParameGrid.getSelectionModel().getSelected();
	//var rowIndex=cell[0];
	if(selectedRow==null){
		Msg.info("warning","请选择要删除的数据!");
		return;
	}
	//var selectedRow=StkSysAppParameGrid.getStore().getAt(rowIndex);
	var myGridId =selectedRow.get("GridId");
	var mySaveMod = selectedRow.get("SaveMod"); 
	var myModValue = selectedRow.get("SaveValueID"); //selectedRow.get("SaveValue"); //Huxt 2020-03-02
	var myCspName=selectedRow.get("CspName");
	if(myGridId==null ||myGridId==""){
		Msg.info("warning","GridId不能为空!");
		return;
	}
	if(mySaveMod==null ||mySaveMod==""){
		Msg.info("warning","保存模式不能为空!");
		return;
	}
	if(myModValue==null ||myModValue==""){
		Msg.info("warning","模式值不能为空!");
		return;
	}
	if(myCspName==null ||myCspName==""){
		Msg.info("warning","菜单不能为空!");
		return;
	}
	var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
	Ext.Ajax.request({
		url:gridUrl+'?actiontype=Delete',
		method:'POST',
		params:{AppId:AppId,GridId:myGridId,SaveMod:mySaveMod,ModValue:myModValue,CspName:myCspName},
		success:function(response,opt){
			var jsonData=Ext.util.JSON.decode(response.responseText);
			 mask.hide();
			if(jsonData.success=='true'){
				Msg.info("success","删除成功!");
				StkSysAppParameGrid.getStore().remove(selectedRow);
				gridDs.removeAll();
				return;
			}else{
				Msg.info("error","删除失败:"+jsonData.info);
			}
		}
	})
}

var DeleteBT=new Ext.Toolbar.Button({
	id:'DeleteBT',
	text:'删除',
	iconCls:'page_delete',
	handler:function(){
		DeleteGridSet();
	}
});
//=============保存模式与Grid设置二级联动===================

//===========模块主页面=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var StkSysAppPanel = new Ext.Panel({
		deferredRender : true,
		title:'应用系统',
		activeTab: 0,
		region:'west',
		height:328,
		width:400,
		collapsible: true,
        split: true,
		minSize: 0,
        maxSize: 500,
        layout:'fit',
		items:[StkSysAppGrid]                                 
	});
	
	var StkSysAppParamePanel = new Ext.Panel({
		deferredRender : true,
		tbar:['<font color=blue>Grid设置</font>',DeleteBT],
		activeTab: 0,
		region:'center',
		height:328,
		width:1200,
		layout:'fit',
		items:[StkSysAppParameGrid]                                 
	});
	
	var gridPanel = new Ext.Panel({
		deferredRender : true,
		title:'列设置',
		activeTab: 0,
		region:'south',
		split:true,
		height:400,
		layout:'fit',
		items:[grid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[StkSysAppPanel,StkSysAppParamePanel,gridPanel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面=================================================