// 名称:库存项不可用原因管理
// 编写日期:2012-06-4

//=========================库存项不可用原因=============================
function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'Desc',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Desc:''
	});
					
	ItmNotUseReasonGridDs.add(NewRecord);
	ItmNotUseReasonGrid.startEditing(ItmNotUseReasonGridDs.getCount() - 1, 1);
}
	
var ItmNotUseReasonGrid="";
//配置数据源
var ItmNotUseReasonGridUrl = 'dhcst.itmnotusereasonaction.csp';
var ItmNotUseReasonGridProxy= new Ext.data.HttpProxy({url:ItmNotUseReasonGridUrl+'?actiontype=query',method:'GET'});
var ItmNotUseReasonGridDs = new Ext.data.Store({
	proxy:ItmNotUseReasonGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Desc'}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//模型
var ItmNotUseReasonGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:$g("名称"),
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
ItmNotUseReasonGridCm.defaultSortable = true;
var addItmNotUseReason = new Ext.Toolbar.Button({
	text:$g('新建'),
    tooltip:$g('新建'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveItmNotUseReason = new Ext.Toolbar.Button({
	text:$g('保存'),
    tooltip:$g('保存'),
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//获取所有的新记录 
		var mr=ItmNotUseReasonGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var rowId = mr[i].data["RowId"];
			var desc = mr[i].data["Desc"].trim();
			var rowNum = ItmNotUseReasonGridDs.indexOf(mr[i])+1;
			if (desc==""){
				Msg.info("warning", $g("第")+rowNum+$g("行名称为空!"));
				return;
			}
			if(desc!=""){
				var dataRow = rowId+"^"+desc;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}

		if(data==""){
			Msg.info("warning", $g("没有修改或添加新数据!"));
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),$g("处理中请稍候..."));
			Ext.Ajax.request({
				url: ItmNotUseReasonGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", $g("请检查网络连接!"));
					ItmNotUseReasonGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success",$g( "保存成功!"));
					}else{
						if(jsonData.info==-2){
							Msg.info("warning", $g("名称重复!"));
						}else{
							Msg.info("warning", $g("保存失败!"));
						}
					}
					ItmNotUseReasonGridDs.commitChanges();
					ItmNotUseReasonGridDs.load();
				},
				scope: this
			});
		}
    }
});


var deleteItmNotUseReason = new Ext.Toolbar.Button({
	text:$g('删除'),
    tooltip:$g('删除'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = ItmNotUseReasonGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning", $g("请选择数据!"));
			return false;
		}else{
			var record = ItmNotUseReasonGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('提示'),$g('确定要删除选定的行?'),
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),$g("处理中请稍候..."));
							Ext.Ajax.request({
								url:ItmNotUseReasonGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:$g('删除中...'),
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error", $g("请检查网络连接!"));
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", $g("删除成功!"));
										ItmNotUseReasonGridDs.remove(record);
										ItmNotUseReasonGrid.getView().refresh();
									}else{
										Msg.info("error", $g("删除失败!"));
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				ItmNotUseReasonGridDs.remove(record);
				ItmNotUseReasonGrid.getView().refresh();
			}
		}
    }
});

//表格
ItmNotUseReasonGrid = new Ext.grid.EditorGridPanel({
	store:ItmNotUseReasonGridDs,
	cm:ItmNotUseReasonGridCm,
	trackMouseOver:true,
	region:'center',
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addItmNotUseReason,'-',saveItmNotUseReason,'-',deleteItmNotUseReason],
	clicksToEdit:1
});

ItmNotUseReasonGridDs.load();

var HospPanel = InitHospCombo('DHC_ItmNotUseReason',function(combo, record, index){
	HospId = this.value; 
	ItmNotUseReasonGridDs.reload();
});

//=========================库存项不可用原因=============================

//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:$g('库存项不可用原因'),
		activeTab:0,
		region:'center',
		items:[ItmNotUseReasonGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[HospPanel, panel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面=============================================