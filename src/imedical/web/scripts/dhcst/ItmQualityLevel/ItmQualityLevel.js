// 名称:库存项质量层次管理
// 编写日期:2012-06-4

//=========================库存项质量层次=============================
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
					
	ItmQLGridDs.add(NewRecord);
	ItmQLGrid.startEditing(ItmQLGridDs.getCount() - 1, 1);
}
	
var ItmQLGrid="";
//配置数据源
var ItmQLGridUrl = 'dhcst.itmqualitylevelaction.csp';
var ItmQLGridProxy= new Ext.data.HttpProxy({url:ItmQLGridUrl+'?actiontype=query',method:'GET'});
var ItmQLGridDs = new Ext.data.Store({
	proxy:ItmQLGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'DateFrom',type:'date',dateFormat:App_StkDateFormat},
		{name:'DateTo',type:'date',dateFormat:App_StkDateFormat}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//模型
var ItmQLGridCm = new Ext.grid.ColumnModel([
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
						ItmQLGrid.startEditing(ItmQLGridDs.getCount() - 1, 2);
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
						ItmQLGrid.startEditing(ItmQLGridDs.getCount() - 1, 3);
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
		renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
		editor:new Ext.ux.DateField({
			id:'dateFromField',
            allowBlank:false,
			format:App_StkDateFormat,
			anchor:'90%',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						ItmQLGrid.startEditing(ItmQLGridDs.getCount() - 1, 4);
					}
				}
			}
        })
    },{
        header:"截止日期",
        dataIndex:'DateTo',
        width:180,
        align:'left',
		renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
        sortable:true,
		editor:new Ext.ux.DateField({
			id:'dateToField',
            allowBlank:false,
			format:App_StkDateFormat,
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
ItmQLGridCm.defaultSortable = true;
var addItmQL = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveItmQL = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//获取所有的新记录 
		var mr=ItmQLGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var rowId = mr[i].data["RowId"];
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			var dateFrom = mr[i].data["DateFrom"];
			var dateTo = mr[i].data["DateTo"];
			var dateFromB,dateToB;
			if((dateFrom!="")&&(dateFrom!=null)){
				dateFromB=dateFrom.format('Y-m-d');
				dateFrom = dateFrom.format(App_StkDateFormat);
			}
			if((dateTo!="")&&(dateTo!=null)){
				dateToB = dateTo.format('Y-m-d')
				dateTo = dateTo.format(App_StkDateFormat);
			}
			var rowNum = ItmQLGridDs.indexOf(mr[i])+1;
			if ((dateToB!="")&&(dateFromB!="")&&(dateToB<dateFromB)){
				Msg.info("warning", "第"+rowNum+"起始日期大于截止日期!");
				return;
			}
			if (code==""){
				Msg.info("warning", "第"+rowNum+"行代码为空!");
				return;
			}
			if (desc==""){
				Msg.info("warning", "第"+rowNum+"行名称为空!");
				return;
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
			Msg.info("warning", "没有修改或添加新数据!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: ItmQLGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", "请检查网络连接!");
					ItmQLGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						ItmQLGridDs.load();
					}else{
						if(jsonData.info==-1){
							Msg.info("warning", "代码重复!");
						}else if(jsonData.info==-2){
							Msg.info("warning", "名称重复!");
						}else{
							Msg.info("error", "保存失败!");
						}
					}
					ItmQLGridDs.commitChanges();
					ItmQLGridDs.reload();
				},
				scope: this
			});
		}
    }
});


var deleteItmQL = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = ItmQLGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "请选择数据!");
			return false;
		}else{
			var record = ItmQLGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:ItmQLGridUrl+'?actiontype=delete&rowid='+RowId,
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
										ItmQLGridDs.remove(record);
										ItmQLGrid.getView().refresh();
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
				ItmQLGridDs.remove(record);
				ItmQLGrid.getView().refresh();
			}
		}
    }
});

//表格
ItmQLGrid = new Ext.grid.EditorGridPanel({
	store:ItmQLGridDs,
	cm:ItmQLGridCm,
	trackMouseOver:true,
	region:'center',
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addItmQL,'-',saveItmQL,'-',deleteItmQL],
	clicksToEdit:1
});

ItmQLGridDs.load();
//=========================库存项质量层次=============================

//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'库存项质量层次',
		activeTab:0,
		region:'center',
		items:[ItmQLGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面===============================================