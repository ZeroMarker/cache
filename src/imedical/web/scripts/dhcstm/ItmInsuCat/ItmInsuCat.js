// 名称:医保类别管理
// 编写日期:2012-06-4

//=========================医保类别=============================
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
			name : 'SelfPayRate',
			type : 'double'
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
		SelfPayRate:'',
		DateFrom:'',
		DateTo:''
	});
					
	ItmInsuCatGridDs.add(NewRecord);
	ItmInsuCatGrid.startEditing(ItmInsuCatGridDs.getCount() - 1, 1);
}
	
var ItmInsuCatGrid="";
//配置数据源
var ItmInsuCatGridUrl = 'dhcstm.itminsucataction.csp';
var ItmInsuCatGridProxy= new Ext.data.HttpProxy({url:ItmInsuCatGridUrl+'?actiontype=query',method:'GET'});
var ItmInsuCatGridDs = new Ext.data.Store({
	proxy:ItmInsuCatGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'SelfPayRate'},
		{name:'DateFrom',type:'date',dateFormat:DateFormat},
		{name:'DateTo',type:'date',dateFormat:DateFormat}
	]),
    remoteSort:false
});

//模型
var ItmInsuCatGridCm = new Ext.grid.ColumnModel([
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
						ItmInsuCatGrid.startEditing(ItmInsuCatGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:"名称",
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
						ItmInsuCatGrid.startEditing(ItmInsuCatGridDs.getCount() - 1, 3);
					}
				}
			}
        })
    },{
        header:"自付率",
        dataIndex:'SelfPayRate',
        width:200,
        align:'left',
        sortable:true,
		editor: new Ext.form.NumberField({
			id:'selfField',
            allowBlank:false,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						ItmInsuCatGrid.startEditing(ItmInsuCatGridDs.getCount() - 1, 4);
					}
				}
			}
        })
    },{
        header:"起始日期",
        dataIndex:'DateFrom',
        width:200,
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
						ItmInsuCatGrid.startEditing(ItmInsuCatGridDs.getCount() - 1, 5);
					}
				}
			}
        })
    },{
        header:"截止日期",
        dataIndex:'DateTo',
        width:200,
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
ItmInsuCatGridCm.defaultSortable = true;
var addItmInsuCat = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		// 判断是否已经有添加行
		var rowCount=ItmInsuCatGrid.getStore().getCount();
		if(rowCount>0){
		 var rowData=ItmInsuCatGridDs.data.items[rowCount-1]
			var data=rowData.get("RowId");
			if(data==null || data.length<=0){
				Msg.info("warning","已存在新建行!");
				ItmInsuCatGrid.startEditing(ItmInsuCatGridDs.getCount()-1,1)
				return;
				
				}
			
			}
		
		addNewRow();
	}
});

var saveItmInsuCat = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//获取所有的新记录 
		var mr=ItmInsuCatGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var rowId = mr[i].data["RowId"];
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			var self = mr[i].data["SelfPayRate"];
			var dateFrom = mr[i].data["DateFrom"];
			var dateTo = mr[i].data["DateTo"];
			if((dateFrom!="")&&(dateFrom!=null)){
				dateFrom = dateFrom.format(ARG_DATEFORMAT);
			}
			if((dateTo!="")&&(dateTo!=null)){
				dateTo = dateTo.format(ARG_DATEFORMAT);
			}
			if((code!="")&&(desc!="")){
				var dataRow = rowId+"^"+code+"^"+desc+"^"+self+"^"+dateFrom+"^"+dateTo;
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
				url: ItmInsuCatGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", "请检查网络连接!");
					ItmInsuCatGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						ItmInsuCatGridDs.load();
					}else{
						if(jsonData.info==-1){
							Msg.info("error", "代码重复!");
						}else if(jsonData.info==-2){
							Msg.info("error", "名称重复!");
						}else{
							Msg.info("error", "保存失败!");
						}
						ItmInsuCatGridDs.load();
					}
					ItmInsuCatGridDs.commitChanges();
				},
				scope: this
			});
		}
    }
});


var deleteItmInsuCat = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = ItmInsuCatGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "请选择数据!");
			return false;
		}else{
			var record = ItmInsuCatGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:ItmInsuCatGridUrl+'?actiontype=delete&rowid='+RowId,
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
										ItmInsuCatGridDs.load();
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
ItmInsuCatGrid = new Ext.grid.EditorGridPanel({
	store:ItmInsuCatGridDs,
	cm:ItmInsuCatGridCm,
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	//tbar:[addItmInsuCat,'-',saveItmInsuCat,'-',deleteItmInsuCat],
	clicksToEdit:1
});

ItmInsuCatGridDs.load();
//=========================医保类别=============================

//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'医保类别',
		activeTab:0,
		region:'center',
		tbar:[addItmInsuCat,'-',saveItmInsuCat],	//,'-',deleteItmInsuCat
		items:[ItmInsuCatGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面===============================================