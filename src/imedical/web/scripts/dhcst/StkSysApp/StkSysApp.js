// 名称:应用系统管理
// 编写日期:2012-05-10

//=========================应用系统管理=================================
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
			name : 'Type',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		Type:'B'
	});
					
	StkSysAppGridDs.add(NewRecord);
	StkSysAppGrid.startEditing(StkSysAppGridDs.getCount() - 1, 1);
}

var StkSysAppStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["B",'业务'], ["Q",'查询'], ["S",'统计'], ["M",'维护']]
});
	
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
	pruneModifiedRecords:true,
    remoteSort:false
});



//模型
var StkSysAppGridCm = new Ext.grid.ColumnModel([
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
						var cell=StkSysAppGrid.getSelectionModel().getSelectedCell();
						StkSysAppGrid.startEditing(cell[0], 2);
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
						var cell=StkSysAppGrid.getSelectionModel().getSelectedCell();
						StkSysAppGrid.startEditing(cell[0], 3);
					}
				}
			}
        })
    },{
        header:"模块类别",
        dataIndex:'Type',
        width:200,
        align:'left',
        sortable:true,
		renderer:function(v, p, record){
			if(v=="B")
				return "业务";
			if(v=="Q")
				return "查询";
			if(v=="S")
				return "统计";
			if(v=="M")
				return "维护";
		},
		editor: new Ext.form.ComboBox({
			id:'StkSysAppField',
			width:216,
			listWidth:216,
			allowBlank:true,
			store:StkSysAppStore,
			value:'B', // 默认值"业务"
			valueField:'key',
			displayField:'keyValue',
			emptyText:'',
			triggerAction:'all',
			emptyText:'',
			minChars:1,
			pageSize:200,
			mode:'local',
			selectOnFocus:true,
			forceSelection:true,
			editable:true,
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
StkSysAppGridCm.defaultSortable = true;

var addStkSysApp = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveStkSysApp = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//获取所有的新记录 
		if(StkSysAppGrid.activeEditor != null){
			StkSysAppGrid.activeEditor.completeEdit();
		} 
		var mr=StkSysAppGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			if((code!="")&&(desc!="")){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+mr[i].data["Type"].trim();
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
				url: StkSysAppGridUrl+'?actiontype=save',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", "请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						StkSysAppGridDs.load();
					}else{
						if(jsonData.info==-1){
							Msg.info("error", "代码重复!");
						}else if(jsonData.info==-2){
							Msg.info("error", "名称重复!");
						}else{
							Msg.info("error", "保存失败!" +jsonData.info);
						}
					}
				},
				scope: this
			});
		}
    }
});

var deleteStkSysApp = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = StkSysAppGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "请选择数据!");
			return false;
		}else{
			var record = StkSysAppGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:StkSysAppGridUrl+'?actiontype=delete&rowid='+RowId,
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
										StkSysAppGridDs.load();
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
StkSysAppGrid = new Ext.grid.EditorGridPanel({
	store:StkSysAppGridDs,
	cm:StkSysAppGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
    tbar:[addStkSysApp,'-',saveStkSysApp,'-',deleteStkSysApp],
	clicksToEdit:1
});

StkSysAppGridDs.load();
//=========================应用系统管理=================================

//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var StkSysAppPanel = new Ext.Panel({
		title:'应用系统管理',
		activeTab: 0,
		region:'center',
		layout:'fit',
		items:[StkSysAppGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items:[StkSysAppPanel],
		renderTo: 'mainPanel'
	});
});
//===========模块主页面===============================================