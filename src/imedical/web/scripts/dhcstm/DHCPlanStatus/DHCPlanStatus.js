// 名称:采购审核级别维护
// 编写日期:2014-03-17


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
			name : 'MaxAmt',
			type : 'float'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		MaxAmt:''
	});
					
	DHCPlanStatusGridDs.add(NewRecord);
	DHCPlanStatusGrid.startEditing(DHCPlanStatusGridDs.getCount() - 1, 1);
}
var DHCPlanStatusGrid=""
//配置数据源
var DHCPlanStatusGridUrl = 'dhcstm.dhcplanstatusaction.csp';
var DHCPlanStatusGridProxy= new Ext.data.HttpProxy({url:DHCPlanStatusGridUrl+'?actiontype=query',method:'GET'});
var DHCPlanStatusGridDs = new Ext.data.Store({
	proxy:DHCPlanStatusGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'MaxAmt'}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//模型
var DHCPlanStatusGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"代码",
        dataIndex:'Code',
        width:150,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						DHCPlanStatusGrid.startEditing(DHCPlanStatusGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:"名称",
        dataIndex:'Desc',
        width:150,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						DHCPlanStatusGrid.startEditing(DHCPlanStatusGridDs.getCount() - 1, 3)
						//addNewRow();
					}
				}
			}
        })
    },{
	    header:"最大审核金额",
	    dataIndex:'MaxAmt',
	    width:150,
	    align:'right',
	    sortable:true,
	    decimalPrecision:4,
		editor: new Ext.form.NumberField({
			id:'MaxAmtField',
            //allowBlank:false,
            selectOnFocus:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						//MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 4);	
						addNewRow();		
					}
				}
			}
        })
	    }
]);

//初始化默认排序功能
DHCPlanStatusGridCm.defaultSortable = true;

var addDHCPlanStatus = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveDHCPlanStatus = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		save()
	}
});

function save(){
	if(DHCPlanStatusGrid.activeEditor != null){
			DHCPlanStatusGrid.activeEditor.completeEdit();
		} 
	//获取所有的新记录
	var mr=DHCPlanStatusGridDs.getModifiedRecords();
	var data="";
		for(var i=0;i<mr.length;i++){
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			if((code!="")&&(desc!="")){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+mr[i].data["MaxAmt"];
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
				url: DHCPlanStatusGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					Msg.info("error", "请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						DHCPlanStatusGridDs.load();
					}else{
						if(jsonData.info==-5){
							Msg.info("error", "代码重复!");
							}else if(jsonData.info==-6){
							Msg.info("error", "名称重复!");
							}else{
						          Msg.info("error", "保存失败!");
							     }
						DHCPlanStatusGridDs.load();
					}
				},
				scope: this
			});
		}	
	}
var deleteDHCPlanStatus = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		Delete()
	}
});	
function Delete(){
	var cell = DHCPlanStatusGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
			Msg.info("error", "请选择数据!");
			return false;
		}else{
			var record = DHCPlanStatusGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:DHCPlanStatusGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									Msg.info("error", "请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success", "删除成功!");
										DHCPlanStatusGridDs.load();
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
				DHCPlanStatusGridDs.remove(record);
				DHCPlanStatusGrid.getView().refresh();
			}
		}
	}		
//表格
DHCPlanStatusGrid = new Ext.grid.EditorGridPanel({
	store:DHCPlanStatusGridDs,
	cm:DHCPlanStatusGridCm,
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addDHCPlanStatus,'-',saveDHCPlanStatus],		//,'-',deleteDHCPlanStatus
	clicksToEdit:1
});

DHCPlanStatusGridDs.load()
//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'采购审核级别',
		activeTab:0,
		region:'center',
		items:[DHCPlanStatusGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面===============================================