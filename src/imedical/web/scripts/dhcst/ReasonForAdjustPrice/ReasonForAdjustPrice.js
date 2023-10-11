// 名称:调价原因管理
// 编写日期:2012-6-7

//=========================调价原因=============================	
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
					
	ReasonForAdjustPriceGridDs.add(NewRecord);
	ReasonForAdjustPriceGrid.startEditing(ReasonForAdjustPriceGridDs.getCount() - 1, 1);
}
	
var ReasonForAdjustPriceGrid="";
//配置数据源
var ReasonForAdjustPriceGridUrl = 'dhcst.reasonforadjustpriceaction.csp';
var ReasonForAdjustPriceGridProxy= new Ext.data.HttpProxy({url:ReasonForAdjustPriceGridUrl+'?actiontype=query',method:'GET'});
var ReasonForAdjustPriceGridDs = new Ext.data.Store({
	proxy:ReasonForAdjustPriceGridProxy,
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
var ReasonForAdjustPriceGridCm = new Ext.grid.ColumnModel([
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
						ReasonForAdjustPriceGrid.startEditing(ReasonForAdjustPriceGridDs.getCount() - 1, 2);
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
ReasonForAdjustPriceGridCm.defaultSortable = true;

var addReasonForAdjustPrice = new Ext.Toolbar.Button({
	text:$g('新建'),
    tooltip:$g('新建'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveReasonForAdjustPrice = new Ext.Toolbar.Button({
	text:$g('保存'),
    tooltip:$g('保存'),
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//获取所有的新记录 
		var mr=ReasonForAdjustPriceGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			var rowNum = ReasonForAdjustPriceGridDs.indexOf(mr[i])+1;
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
			var mask=ShowLoadMask(Ext.getBody(),$g("处理中请稍候..."));
			Ext.Ajax.request({
				url: ReasonForAdjustPriceGridUrl+'?actiontype=save',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", $g("请检查网络连接!"));
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", $g("保存成功!"));
						ReasonForAdjustPriceGridDs.load();
					}else{
						if(jsonData.info==-1){
							Msg.info("warning", $g("代码重复!"));
						}else if(jsonData.info==-2){
							Msg.info("warning", $g("名称重复!"));
						}else{
							Msg.info("error", $g("保存失败!"));
						}
						ReasonForAdjustPriceGridDs.load();
					}
				},
				scope: this
			});
		}
    }
});


var deleteReasonForAdjustPrice = new Ext.Toolbar.Button({
	text:$g('删除'),
    tooltip:$g('删除'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = ReasonForAdjustPriceGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", $g("请选择数据!"));
			return false;
		}else{
			var record = ReasonForAdjustPriceGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('提示'),$g('确定要删除选定的行?'),
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),$g("处理中请稍候..."));
							Ext.Ajax.request({
								url:ReasonForAdjustPriceGridUrl+'?actiontype=delete&rowid='+RowId,
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
										ReasonForAdjustPriceGridDs.remove(record);
										ReasonForAdjustPriceGrid.getView().refresh();
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
				ReasonForAdjustPriceGridDs.remove(record);
				ReasonForAdjustPriceGrid.getView().refresh();
			}
		}
    }
});

//表格
ReasonForAdjustPriceGrid = new Ext.grid.EditorGridPanel({
	store:ReasonForAdjustPriceGridDs,
	cm:ReasonForAdjustPriceGridCm,
	trackMouseOver:true,
	region:'center',
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addReasonForAdjustPrice,'-',saveReasonForAdjustPrice,'-',deleteReasonForAdjustPrice],
	clicksToEdit:1
});

ReasonForAdjustPriceGridDs.load();
//=========================调价原因=============================
var HospPanel = InitHospCombo('DHC_ReasonForAdjustPrice',function(combo, record, index){
	HospId = this.value; 
	ReasonForAdjustPriceGridDs.reload();
});
//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:$g('调价原因'),
		activeTab:0,
		region:'center',
		items:[ReasonForAdjustPriceGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[HospPanel,panel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面===============================================