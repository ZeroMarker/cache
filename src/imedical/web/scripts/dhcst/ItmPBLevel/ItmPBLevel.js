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
var ItmPBLevelGridUrl = 'dhcst.itmpblevelaction.csp';
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
		{name:'DateFrom',type:'date',dateFormat:App_StkDateFormat},
		{name:'DateTo',type:'date',dateFormat:App_StkDateFormat}
	]),
    remoteSort:false
});

//模型
var ItmPBLevelGridCm = new Ext.grid.ColumnModel([
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
						ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount() - 1, 2);
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
						ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount() - 1, 3);
					}
				}
			}
        })
    },{
        header:$g("起始日期"),
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
						ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount() - 1, 4);
					}
				}
			}
        })
    },{
        header:$g("截止日期"),
        dataIndex:'DateTo',
        width:180,
        align:'left',
        sortable:true,
		renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
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
ItmPBLevelGridCm.defaultSortable = true;
var addItmPBLevel = new Ext.Toolbar.Button({
	text:$g('新建'),
    tooltip:$g('新建'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveItmPBLevel = new Ext.Toolbar.Button({
	text:$g('保存'),
    tooltip:$g('保存'),
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(HospId==""){
			Msg.info("warning",$g("请先选择医院!"));
			return false;
		}
		//获取所有的新记录 
		var mr=ItmPBLevelGridDs.getModifiedRecords();
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
			if(code==""){Msg.info("warning",$g("代码不能为空!"));return;}
			if(desc==""){Msg.info("warning",$g("名称不能为空!"));return;}
			if ((dateToB!="")&&(dateFromB!="")&&(dateToB<dateFromB)){
				Msg.info("warning", desc+$g(":起始日期大于截止日期!"));
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
			Msg.info("error", $g("没有修改或添加新数据!"));
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),$g("处理中请稍候..."));
			Ext.Ajax.request({
				url: ItmPBLevelGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", $g("请检查网络连接!"));
					ItmPBLevelGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", $g("保存成功!"));
						ItmPBLevelGridDs.load();
					}else{
						ItmPBLevelGridDs.load();
						if(jsonData.info==-1){
							Msg.info("error", $g("代码重复!"));
						}else if(jsonData.info==-2){
							Msg.info("error", $g("名称重复!"));
						}else{
							Msg.info("error", $g("保存失败!"));
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
	text:$g('删除'),
    tooltip:$g('删除'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		if(HospId==""){
			Msg.info("warning",$g("请先选择医院!"));
			return false;
		}
		var cell = ItmPBLevelGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", $g("请选择数据!"));
			return false;
		}else{
			var record = ItmPBLevelGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('提示'),$g('确定要删除选定的行?'),
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),$g("处理中请稍候..."));
							Ext.Ajax.request({
								url:ItmPBLevelGridUrl+'?actiontype=delete&rowid='+RowId,
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
										ItmPBLevelGridDs.load();
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
				Msg.info("error", $g("数据有错,没有RowId!"));
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
	tbar:[addItmPBLevel,'-',saveItmPBLevel,'-',deleteItmPBLevel],
	clicksToEdit:1
});

ItmPBLevelGridDs.load();

var HospPanel = InitHospCombo('DHC_ItmPBLevel',function(combo, record, index){
	HospId = this.value; 
	ItmPBLevelGridDs.reload();
});
//=========================招标级别维护=============================

//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		id:"panel",
		title:$g('招标级别'),
		activeTab:0,
		region:'center',
		layout:'fit',
		items:[ItmPBLevelGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[HospPanel,panel],
		renderTo:'mainPanel'
	});

});
//===========模块主页面=============================================