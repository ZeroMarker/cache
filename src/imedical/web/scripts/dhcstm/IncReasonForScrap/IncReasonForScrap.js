// 名称:报损原因管理
// 编写日期:2014-01-11

//=========================报损原因=============================	
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
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:''
	});
					
	IncReasonForScrapGridDs.add(NewRecord);
	IncReasonForScrapGrid.startEditing(IncReasonForScrapGridDs.getCount() - 1, 1);
}
	
var IncReasonForScrapGrid="";
//配置数据源
var IncReasonForScrapGridUrl = 'dhcstm.increasonforscrapaction.csp';
var IncReasonForScrapGridProxy= new Ext.data.HttpProxy({url:IncReasonForScrapGridUrl+'?actiontype=query',method:'GET'});
var IncReasonForScrapGridDs = new Ext.data.Store({
	proxy:IncReasonForScrapGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//模型
var IncReasonForScrapGridCm = new Ext.grid.ColumnModel([
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
						IncReasonForScrapGrid.startEditing(IncReasonForScrapGridDs.getCount() - 1, 2);
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
						addNewRow();
					}
				}
			}
        })
    }
]);

//初始化默认排序功能
IncReasonForScrapGridCm.defaultSortable = true;

var addIncReasonForScrap = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveIncReasonForScrap = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(IncReasonForScrapGrid.activeEditor != null){
			IncReasonForScrapGrid.activeEditor.completeEdit();
		} 
		//获取所有的新记录
		var mr=IncReasonForScrapGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			if((code!="")&&(desc!="")){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc;
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
			Ext.Ajax.request({
				url: IncReasonForScrapGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					Msg.info("error", "请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						IncReasonForScrapGridDs.load();
					}else{
						if(jsonData.info==-2){
							Msg.info("error", "代码重复!");
							}else if(jsonData.info==-3){
							Msg.info("error", "名称重复!");
							}else{
						          Msg.info("error", "保存失败!");
							     }
						IncReasonForScrapGridDs.load();
					}
				},
				scope: this
			});
		}
    }
});


var deleteIncReasonForScrap = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = IncReasonForScrapGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "请选择数据!");
			return false;
		}else{
			var record = IncReasonForScrapGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:IncReasonForScrapGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									Msg.info("error", "请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success", "删除成功!");
										IncReasonForScrapGridDs.load();
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
				IncReasonForScrapGridDs.remove(record);
				IncReasonForScrapGrid.getView().refresh();
			}
		}
    }
});

//表格
IncReasonForScrapGrid = new Ext.grid.EditorGridPanel({
	store:IncReasonForScrapGridDs,
	cm:IncReasonForScrapGridCm,
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addIncReasonForScrap,'-',saveIncReasonForScrap],		//,'-',deleteIncReasonForScrap
	clicksToEdit:1
});

IncReasonForScrapGridDs.load();
//=========================报损原因=============================

//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'报损原因',
		activeTab:0,
		region:'center',
		layout:'fit',
		items:[IncReasonForScrapGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面===============================================