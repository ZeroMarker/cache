// 名称:招标级别维护管理
// 编写日期:2012-06-4

//=========================招标级别维护=============================
function addNewRow() {
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
		}, {
			name : 'DateFrom',
			type : 'string'
		}, {
			name : 'DateTo',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		DateFrom:'',
		DateTo:''
	});
					
	ItmPBLevelGridDs.add(NewRecord);
	ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount() - 1, 1);
}
	
var ItmPBLevelGrid="";
//配置数据源
var ItmPBLevelGridUrl = 'dhcstm.itmpblevelaction.csp';
var ItmPBLevelGridProxy= new Ext.data.HttpProxy({url:ItmPBLevelGridUrl+'?actiontype=query',method:'GET'});
var ItmPBLevelGridDs = new Ext.data.Store({
	proxy:ItmPBLevelGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'DateFrom',type:'date',dateFormat:DateFormat},
		{name:'DateTo',type:'date',dateFormat:DateFormat}
	]),
    remoteSort:false
});

//模型
var ItmPBLevelGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"代码",
        dataIndex:'Code',
        width:180,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:"名称",
        dataIndex:'Desc',
        width:300,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount() - 1, 3);
					}
				}
			}
        })
    },{
        header:"起始日期",
        dataIndex:'DateFrom',
        width:180,
        align:'left',
        sortable:true,
		renderer:Ext.util.Format.dateRenderer(DateFormat),
		editor:new Ext.ux.DateField({
			id:'dateFromField',
            allowBlank:false,
			anchor:'90%',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount() - 1, 4);
					}
				}
			}
        })
    },{
        header:"截止日期",
        dataIndex:'DateTo',
        width:180,
        align:'left',
        sortable:true,
		renderer:Ext.util.Format.dateRenderer(DateFormat),
		editor:new Ext.ux.DateField({
			id:'dateToField',
            allowBlank:false,
			anchor:'90%',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewRow();
					}
				}
			}
        })
    }
]);

//初始化默认排序功能
ItmPBLevelGridCm.defaultSortable = true;
var addItmPBLevel = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		// 判断是否已经有添加行
		var rowCount=ItmPBLevelGrid.getStore().getCount();
		if(rowCount>0){
			var rowData=ItmPBLevelGridDs.data.items[rowCount-1];
			var data=rowData.get("RowId");
			if(data==null || data.length<=0){
				Msg.info("Warning","已经存在新建行!");
				ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount()-1,1);
				return ;
				}
			}
		addNewRow();
	}
});

var saveItmPBLevel = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//获取所有的新记录 
		var mr=ItmPBLevelGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var rowId = mr[i].data["RowId"];
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			var dateFrom = mr[i].data["DateFrom"];
			var dateTo = mr[i].data["DateTo"];
			if((dateFrom!="")&&(dateFrom!=null)){
				dateFrom = dateFrom.format(ARG_DATEFORMAT);
			}
			if((dateTo!="")&&(dateTo!=null)){
				dateTo = dateTo.format(ARG_DATEFORMAT);
			}
			if((code!="")&&(desc!="")){
				var dataRow = rowId+"^"+code+"^"+desc+"^"+dateFrom+"^"+dateTo;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}
		
		if(data==""){
			Msg.info("error", "没有修改或添加新数据!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: ItmPBLevelGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", "请检查网络连接!");
					ItmPBLevelGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						ItmPBLevelGridDs.load();
					}else{
						ItmPBLevelGridDs.load();
						if(jsonData.info==-1){
							Msg.info("error", "代码重复!");
						}else if(jsonData.info==-2){
							Msg.info("error", "名称重复!");
						}else{
							Msg.info("error", "保存失败!");
						}
					}
					ItmPBLevelGridDs.commitChanges();
				},
				scope: this
			});
		}
    }
});


var deleteItmPBLevel = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = ItmPBLevelGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "请选择数据!");
			return false;
		}else{
			var record = ItmPBLevelGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:ItmPBLevelGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error", "请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", "删除成功!");
										ItmPBLevelGridDs.load();
									}else{
										Msg.info("error", "删除失败!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("error", "数据有错,没有RowId!");
			}
		}
    }
});

//表格
ItmPBLevelGrid = new Ext.grid.EditorGridPanel({
	store:ItmPBLevelGridDs,
	cm:ItmPBLevelGridCm,
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addItmPBLevel,'-',saveItmPBLevel],	//,'-',deleteItmPBLevel
	clicksToEdit:1
});

ItmPBLevelGridDs.load();
//=========================招标级别维护=============================

//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'招标级别',
		activeTab:0,
		region:'center',
		layout:'fit',
		items:[ItmPBLevelGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面=============================================