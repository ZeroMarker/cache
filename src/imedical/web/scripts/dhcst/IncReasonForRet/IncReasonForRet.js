// 名称:退货原因管理
// 编写日期:2012-05-22

//=========================退货原因=============================	
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
					
	IncReasonForRetGridDs.add(NewRecord);
	IncReasonForRetGrid.startEditing(IncReasonForRetGridDs.getCount() - 1, 1);
}
	
var IncReasonForRetGrid="";
//配置数据源
var IncReasonForRetGridUrl = 'dhcst.increasonforretaction.csp';
var IncReasonForRetGridProxy= new Ext.data.HttpProxy({url:IncReasonForRetGridUrl+'?actiontype=query',method:'GET'});
var IncReasonForRetGridDs = new Ext.data.Store({
	proxy:IncReasonForRetGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//模型
var IncReasonForRetGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:$g("代码"),
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
						IncReasonForRetGrid.startEditing(IncReasonForRetGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
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
IncReasonForRetGridCm.defaultSortable = true;

var addIncReasonForRet = new Ext.Toolbar.Button({
	text:$g('新建'),
    tooltip:$g('新建'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveIncReasonForRet = new Ext.Toolbar.Button({
	text:$g('保存'),
    tooltip:$g('保存'),
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//获取所有的新记录 
		var mr=IncReasonForRetGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			var rowNum = IncReasonForRetGridDs.indexOf(mr[i])+1;
			if (code==""){
				Msg.info("warning", $g("第")+rowNum+$g("行代码为空!"));
				return;
			}
			if (desc==""){
				Msg.info("warning", $g("第")+rowNum+$g("行名称为空!"));
				return;
			}
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
			Msg.info("warning", $g("没有修改或添加新数据!"));
			return false;
		}else{
			Ext.Ajax.request({
				url: IncReasonForRetGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					Msg.info("error", $g("请检查网络连接!"));
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", $g("保存成功!"));
						IncReasonForRetGridDs.load();
					}else{
						Msg.info("warning", jsonData.info);
						IncReasonForRetGridDs.load();
					}
				},
				scope: this
			});
		}
    }
});


var deleteIncReasonForRet = new Ext.Toolbar.Button({
	text:$g('删除'),
    tooltip:$g('删除'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = IncReasonForRetGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning", $g("请选择数据!"));
			return false;
		}else{
			var record = IncReasonForRetGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('提示'),$g('确定要删除选定的行?'),
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:IncReasonForRetGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:$g('删除中...'),
								failure: function(result, request) {
									Msg.info("error", $g("请检查网络连接!"));
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success", $g("删除成功!"));
										IncReasonForRetGridDs.remove(record);
										IncReasonForRetGrid.getView().refresh();
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
				IncReasonForRetGridDs.remove(record);
				IncReasonForRetGrid.getView().refresh();
			}
		}
    }
});

//表格
IncReasonForRetGrid = new Ext.grid.EditorGridPanel({
	store:IncReasonForRetGridDs,
	cm:IncReasonForRetGridCm,
	trackMouseOver:true,
	region:'center',
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addIncReasonForRet,'-',saveIncReasonForRet,'-',deleteIncReasonForRet],
	clicksToEdit:1
});

IncReasonForRetGridDs.load();

var HospPanel = InitHospCombo('INC_ReasonForReturn',function(combo, record, index){
	HospId = this.value; 
	IncReasonForRetGridDs.reload();
});

//=========================退货原因=============================


//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:$g('退货原因'),
		activeTab:0,
		region:'center',
		items:[IncReasonForRetGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[HospPanel,panel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面===============================================