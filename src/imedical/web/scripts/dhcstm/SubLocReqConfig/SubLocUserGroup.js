// 名称:科室专业组
// 编写日期:2012-05-8
//=========================定义全局变量===============================
var SubLocUserGroupId = "";
//=========================定义全局变量===============================
//=========================专业组=====================================
var logonLoc=session['LOGON.CTLOCID'];  //登录科室
var gGroupId = session['LOGON.GROUPID'];
var SubLocUserGridUrl = 'dhcstm.sublocusergroupaction.csp';

var PhaLoc = new Ext.ux.ComboBox({
	id:'PhaLoc',
	fieldLabel:'科室',
	emptyText:'科室...',
	listWidth:200,
	store : LeadLocStore,
	valueParams : {groupId : gGroupId},
	filterName : 'locDesc',
	listeners : {
		select : function(index, scrollIntoView){
			SubLocUserGroupGridDs.load({params:{SubLoc:this.getValue()}});
		},
		change : function(combo, newValue, oldValue){
			if(newValue==""){
				SubLocUserGroupGridDs.removeAll();
				SubLocUserGridDs.removeAll();
				SubLocUserGroupId='';
			}
		}
	}
});

function addNewRow() {
	var col=GetColIndex(SubLocUserGroupGrid,"Code");
	var rowCount = SubLocUserGroupGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = SubLocUserGroupGridDs.data.items[rowCount - 1];
		var data = rowData.get("RowId");
		if (data == null || data.length <= 0) {
			SubLocUserGroupGrid.startEditing(rowCount-1, col);
			return;
		}
	}
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'Code',
			type : 'string'
		}, {
			name : 'Desc',
			type : 'string'
		},{
			name:'DateFrom',
			type:'date'
		},{
			name:'DateTo',
			type:'date'
		},{
			name:'subloc',
			type:'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		DateFrom:'',
		DateTo:'',
		subloc:''
	});
					
	SubLocUserGroupGridDs.add(NewRecord);
	SubLocUserGroupGrid.startEditing(SubLocUserGroupGridDs.getCount() - 1, col);
}

//配置数据源
var SubLocUserGroupGridUrl = 'dhcstm.sublocusergroupaction.csp';
var SubLocUserGroupGridProxy= new Ext.data.HttpProxy({url:SubLocUserGroupGridUrl+'?actiontype=getLocGroupList',method:'GET'});
var SubLocUserGroupGridDs = new Ext.data.Store({
	proxy:SubLocUserGroupGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows'
	}, [
		{name:'RowId'},
		{name:'Code',mapping:'grpCode'},
		{name:'Desc',mapping:'grpDesc'},
		{name:'DateFrom',mapping:'df',type:'date',dateFormat:DateFormat},
		{name:'DateTo',mapping:'dt',type:'date',dateFormat:DateFormat},
		{name:'subloc'}
	]),
	remoteSort:false,
	pruneModifiedRecords:true,
	listeners :　{
		beforeload : function(store, options){
			SubLocUserGridDs.removeAll();
		}
	}
});

//模型
var SubLocUserGroupGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
	 	header:'RowId',
	 	dataIndex:'RowId',
	 	hidden:true
	 },{
        header:"专业组代码",
        dataIndex:'Code',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var row=SubLocUserGroupGrid.getSelectionModel().getSelectedCell()[0];
						var col=GetColIndex(SubLocUserGroupGrid,"Desc");
						SubLocUserGroupGrid.startEditing(row, col);
					}
				}
			}
        })
    },{
        header:"专业组名称",
        dataIndex:'Desc',
        width:200,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewRow();
					}
				}
			}
        })
    },{
	    header:'生效起始日期',
	    dataIndex:'DateFrom',
	    //xtype:'datecolumn',
	    renderer : Ext.util.Format.dateRenderer(DateFormat),
	    editor: new Ext.ux.DateField({
	    	selectOnFocus : true
	    }),
	    width:100
    },{
	    header:'生效截止日期',
	    dataIndex:'DateTo',
	    //
	    renderer : Ext.util.Format.dateRenderer(DateFormat),
	    //xtype:'datecolumn',
	    editor: new Ext.ux.DateField({}),
	    width:100
	},{
	    header:'subloc',
	    dataIndex:'subloc',
	    hidden:true
    }
]);

var addSubLocUserGroup = new Ext.Toolbar.Button({
	text:'新建',
	tooltip:'新建',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		var PhaLoc = Ext.getCmp('PhaLoc').getValue();
		if(PhaLoc==''){
			Msg.info('warning','请选择需要维护专业组的科室!');
			return;
		}
		addNewRow();
	}
});

var saveSubLocUserGroup = new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(SubLocUserGroupGrid.activeEditor != null){
			SubLocUserGroupGrid.activeEditor.completeEdit();
		}
		//获取所有的新记录 
		var mr=SubLocUserGroupGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){ 
			var code=mr[i].data["Code"].trim();
			var desc=mr[i].data["Desc"].trim();
			var df=mr[i].data["DateFrom"];
			var dt=mr[i].data["DateTo"];
			if((df!=null)&&(df!='')&&(dt!=null)&&(dt!='')){
				if(df>dt){
					var rowIndex=SubLocUserGroupGridDs.indexOf(mr[i]);
					Msg.info("warning","第"+(rowIndex+1)+"行开始日期不能大于截止日期!");
					return;
				}
			}
			if ((df!=null)&&(df!='')){
				df=df.format(ARG_DATEFORMAT);
			}else{
				df="";
			}
			
			if ((dt!=null)&&(dt!='')){
				dt=dt.format(ARG_DATEFORMAT);
			}else{
				dt="";
			}
			
			var subloc=Ext.getCmp('PhaLoc').getValue();
			if(subloc==""){
				Msg.info("warning",'科室不可为空!');
				return false;
			}
			if(code!="" && desc!=""){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+df+"^"+dt+"^"+subloc;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}
		
		if(data==""){
			Msg.info("warning","没有修改或添加新数据!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: SubLocUserGroupGridUrl+'?actiontype=saveGroup',
				params: {data:data},
				failure: function(result, request) {
					mask.hide();
					Msg.info("error","请检查网络连接!");
					SubLocUserGroupGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						SubLocUserGroupGridDs.reload();
					}else{
						Msg.info("error","保存失败!"+jsonData.info);
						SubLocUserGroupGridDs.reload();
					}
					SubLocUserGroupGridDs.commitChanges();
				},
				scope: this
			});
		}
    }
});

var deleteSubLocUserGroup = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = SubLocUserGroupGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","请选择数据!");
			return false;
		}else{
			var rowIndex=cell[0];  //当前行号
			var record = SubLocUserGroupGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:SubLocUserGroupGridUrl+'?actiontype=deleteGroup',
								waitMsg:'删除中...',
								params:{RowId:RowId},
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error","请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success","删除成功!");
										SubLocUserGrid.store.removeAll();
										SubLocUserGrid.getView().refresh();
										SubLocUserGroupGridDs.reload();
									}else{
										Msg.info("error","删除失败!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				SubLocUserGroupGridDs.remove(record);
				SubLocUserGroupGrid.getView().refresh();
			}
		}
    }
});

//表格
var SubLocUserGroupGrid = new Ext.ux.EditorGridPanel({
	id : 'SubLocUserGroupGrid',
	store:SubLocUserGroupGridDs,
	cm:SubLocUserGroupGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:['科室:',PhaLoc,'-',addSubLocUserGroup,'-',saveSubLocUserGroup],		//隐藏删除按钮 ,'-',deleteSubLocUserGroup
	listeners:{
		'rowclick':function(grid,rowIndex,e){
			//单击专业组刷新专业组人员记录
			var selectedRow = SubLocUserGroupGridDs.data.items[rowIndex];
			SubLocUserGroupId = selectedRow.data["RowId"];
			SubLocUserGridDs.proxy = new Ext.data.HttpProxy({url:SubLocUserGridUrl+'?actiontype=getGroupUser',method:'GET'});
			SubLocUserGridDs.load({params:{SubLocUserGroupId:SubLocUserGroupId}});
		},
		'afteredit':function(e){
			if(e.field=="Code" || e.field=="Desc"){
				var findIndex=SubLocUserGroupGridDs.findExact(e.field,e.value,0);
				if(findIndex>=0 && findIndex!=e.row){
					Msg.info("warning","代码,名称不可重复!");
					e.record.set(e.field,e.originalValue);
				}
			}
		}
	}
});

//=========================专业组=====================================

function addNewSCRow() {
	var col=GetColIndex(SubLocUserGrid,"user");
	var rowCount = SubLocUserGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = SubLocUserGridDs.data.items[rowCount - 1];
		var data = rowData.get("user");
		if (data == null || data.length <= 0) {
			SubLocUserGrid.startEditing(rowCount-1, col);
			return;
		}
	}
	var scRecord = Ext.data.Record.create([
		{
			name : 'rowid',
			type : 'string'
		},{
			name : 'user',
			type : 'int'
		},{
			name : 'userName',
			type : 'string'
		},{
			name : 'DateFromX',
			type : 'date'
		},{
			name : 'DateToX',
			type : 'date'
		},{
			name : 'ReqFlag',
			type : 'string'
		}
	]);
					
	var NewSCRecord = new scRecord({
		rowid:'',
		user:'',
		userName:'',
		DateFromX:'',
		DateToX:'',
		ReqFlag:'Y'
	});
		
	SubLocUserGridDs.add(NewSCRecord);
	var col=GetColIndex(SubLocUserGrid,'user');
	SubLocUserGrid.startEditing(SubLocUserGridDs.getCount() - 1, col);
}

var UCG = new Ext.ux.ComboBox({
	fieldLabel : '名称',
	id : 'UCG',
	anchor : '90%',
	store : UStore,
	params : {locId:'PhaLoc'},
	filterName : 'name',
	listeners:{
		select:function(combo,record,index){
			var findIndex=SubLocUserGridDs.findExact('user',record.get('RowId'),0);
			var cell=SubLocUserGrid.getSelectionModel().getSelectedCell();
			if(findIndex>=0 && findIndex!=cell[0]){
				combo.setValue("");
				Msg.info("warning","该人员已存在!");
				return false;
			}
		}
	}
});

//配置数据源
var SubLocUserGridProxy= new Ext.data.HttpProxy({url:SubLocUserGridUrl,method:'GET'});
var SubLocUserGridDs = new Ext.data.Store({
	proxy:SubLocUserGridProxy,
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows',
		id:'rowid'
	}, [
		{name:'rowid'},
		{name:'user',mapping:'userRowId'},
		{name:'userName'},
		{name:'DateFromX',mapping:'dateFrom',type:'date',dateFormat:DateFormat},
		{name:'DateToX',mapping:'dateTo',type:'date',dateFormat:DateFormat},
		{name:"ReqFlag"}
	]),
	pruneModifiedRecords:true
});

var ReqFlag = new Ext.grid.CheckColumn({
	header:'专业组请领权限',
	dataIndex:'ReqFlag',
	width:100,
	sortable:true
});

//模型
var SubLocUserGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:'rowid',
		dataIndex:'rowid',
		hidden:true
	},{
		header:"科室人员",
		dataIndex:'user',
		width:300,
		align:'left',
		sortable:true,
		renderer:Ext.util.Format.comboRenderer2(UCG,"user","userName"),
		editor:new Ext.grid.GridEditor(UCG)
	},{
		header:'生效起始日期',
		dataIndex:'DateFromX',
		//xtype:'datecolumn',
		renderer : Ext.util.Format.dateRenderer(DateFormat),
		editor: new Ext.ux.DateField({
			selectOnFocus : true
		}),
		width:100 
	},{
		header:'生效截止日期',
		dataIndex:'DateToX',
		//
		renderer : Ext.util.Format.dateRenderer(DateFormat),
		//xtype:'datecolumn',
		editor: new Ext.ux.DateField({}),
		width:100
	}, ReqFlag
]);

//表格
SubLocUserGrid = new Ext.ux.EditorGridPanel({
	id : 'SubLocUserGrid',
	store:SubLocUserGridDs,
	cm:SubLocUserGridCm,
	trackMouseOver:true,
	clicksToEdit:1,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	plugins:ReqFlag,
	listeners:{
		beforeedit:function(e){
			if(e.field=="user" && e.record.get('rowid')!=""){
				e.cancel=true;
			}
		}
	}
});
//=========================专业组人员===================================

var addSubLocUser = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(SubLocUserGroupGridDs.getCount()>0 && SubLocUserGroupId!=""){
			addNewSCRow();
		}else{
			Msg.info("warning","请选择专业组!");
			return false;
		}
	}
});

var saveSubLocUser = new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(SubLocUserGrid.activeEditor != null){
			SubLocUserGrid.activeEditor.completeEdit();
		}
		//获取所有的新记录 
		var mr=SubLocUserGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			if(mr[i].data["user"].trim()!=""){
				var dateFrom=mr[i].data["DateFromX"];
				var dateTo=mr[i].data["DateToX"];
				if((dateFrom!=null)&&(dateFrom!="")&&(dateTo!=null)&&(dateTo!="")){
					if(dateFrom>dateTo){
						var rowIndex=SubLocUserGridDs.indexOf(mr[i])
						Msg.info("warning","第"+(rowIndex+1)+"行开始日期不能大于截止日期!");
						return;
					}
				}
				if ((dateFrom!=null)&&(dateFrom!='')){
					dateFrom=dateFrom.format(ARG_DATEFORMAT);
				}else{
					dateFrom="";
				}
				if ((dateTo!=null)&&(dateTo!='')){
					dateTo=dateTo.format(ARG_DATEFORMAT);
				}else{
					dateTo="";
				}
				var ReqFlag = mr[i].data["ReqFlag"];
				var dataRow = SubLocUserGroupId+"^"+mr[i].data["rowid"]+"^"+mr[i].data["user"]
					+"^"+dateFrom+"^"+dateTo+"^"+ReqFlag;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}

		if(data==""){
			Msg.info("error","没有修改或添加新数据!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: SubLocUserGridUrl+'?actiontype=saveGroupUser',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error","请检查网络连接!");
					SubLocUserGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success","添加成功!");
						SubLocUserGridDs.reload();
					}else{
						Msg.info("error",jsonData.info+" 添加失败!");
						
					}
					SubLocUserGridDs.commitChanges();
					SubLocUserGridDs.reload();
				},
				scope: this
			});
		}
	}
});

var deleteSubLocUser = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = SubLocUserGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","请选择数据!");
			return false;
		}else{
			var rowIndex=cell[0];
			var record = SubLocUserGrid.getStore().getAt(cell[0]);
			var RowId = record.get("rowid");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:SubLocUserGridUrl+'?actiontype=deleteGroupUser',
								params:{rowid:RowId},
								waitMsg:'删除中...',
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error","请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success","删除成功!");
										SubLocUserGridDs.reload();
										
									}else{
										Msg.info("error","删除失败!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				SubLocUserGridDs.remove(record);
				SubLocUserGrid.getView().refresh();
			}
		}
	}
});

//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var SubLocUserGroupPanel = new Ext.Panel({
		title:'科室专业组维护',
		activeTab: 0,
		region:'west',
		width:600,
		collapsible: true,
		split: true,
		minSize: 0,
		maxSize: 600,
		layout:'fit',
		items:[SubLocUserGroupGrid]                                 
	});
	
	var SubLocUserPanel = new Ext.Panel({
		title:'专业组人员',
		region:'center',
		tbar:[addSubLocUser,'-',saveSubLocUser,'-',deleteSubLocUser],
		layout:'fit',
		items:[SubLocUserGrid]                                 
	});

	var mainPanel = new Ext.ux.Viewport({
		layout: 'border',
		items:[SubLocUserGroupPanel,SubLocUserPanel],
		renderTo: 'mainPanel'
	});
	
	SetLogInDept(PhaLoc.getStore(),'PhaLoc');
	//加载缺省科室的专业组	ps:2018-04-08 因SetLogInDept内增加触发事件,这里不再重复
	//SubLocUserGroupGridDs.load({params:{SubLoc:Ext.getCmp('PhaLoc').getValue()}});
});
//===========模块主页面===============================================