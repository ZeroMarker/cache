// 名称:科室组管理
// 编写日期:2012-05-23

//=========================科室组类别=============================
var conditionCodeField = new Ext.form.TextField({
	id:'conditionCodeField',
	fieldLabel:$g('代码'),
	allowBlank:true,
	width:180,
	listWidth:180,
	emptyText:$g('代码...'),
	anchor:'90%',
	selectOnFocus:true
});
	
var conditionDescField = new Ext.form.TextField({
	id:'conditionDescField',
	fieldLabel:$g('名称'),
	allowBlank:true,
	width:150,
	listWidth:150,
	emptyText:$g('名称...'),
	anchor:'90%',
	selectOnFocus:true
});
	
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
		Type:'G'
	});
					
	StkLocGrpGridDs.add(NewRecord);
	StkLocGrpGrid.startEditing(StkLocGrpGridDs.getCount() - 1, 1);
}


var StkLocGrpGrid="";
//配置数据源
var StkLocGrpGridUrl = 'dhcst.StkLocGrpaction.csp';
var StkLocGrpGridProxy= new Ext.data.HttpProxy({url:StkLocGrpGridUrl+'?actiontype=query',method:'POST'});
var StkLocGrpGridDs = new Ext.data.Store({
	proxy:StkLocGrpGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'Type'}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//模型
var StkLocGrpGridCm = new Ext.grid.ColumnModel([
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
						StkLocGrpGrid.startEditing(StkLocGrpGridDs.getCount() - 1, 2);
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
StkLocGrpGridCm.defaultSortable = true;

var findStkLocGrp = new Ext.Toolbar.Button({
	text:$g('查询'),
    tooltip:$g('查询'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
			Query();
	}
});

var addStkLocGrp = new Ext.Toolbar.Button({
	text:$g('新建'),
    tooltip:$g('新建'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveStkLocGrp = new Ext.Toolbar.Button({
	text:$g('保存'),
    tooltip:$g('保存'),
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//获取所有的新记录 
		var mr=StkLocGrpGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			var rowNum = StkLocGrpGridDs.indexOf(mr[i])+1;
			if (code==""){
				Msg.info("warning", $g("第")+rowNum+$g("行代码为空!"));
				return;
			}
			if (desc==""){
				Msg.info("warning", $g("第")+rowNum+$g("行名称为空!"));
				return;
			}
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
			Msg.info("warning", $g("没有修改或添加新数据!"));
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),$g("处理中请稍候..."));
			Ext.Ajax.request({
				url: StkLocGrpGridUrl+'?actiontype=save',
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
						Query();
					}else{
						var date=jsonData.info
						if(date==-5){
							Msg.info("warning", $g("代码重复!"));}
						else if(date==-6){
							Msg.info("warning", $g("名称重复!" ));}
						else {
							Msg.info("error", $g("保存失败！" ));
						}
						//Query();
					}
				},
				scope: this
			});
		}
    }
});


var deleteStkLocGrp = new Ext.Toolbar.Button({
	text:$g('删除'),
    tooltip:$g('删除'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = StkLocGrpGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", $g("请选择数据!"));
			return false;
		}else{
			var record = StkLocGrpGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('提示'),$g('确定要删除选定的行?'),
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),$g("处理中请稍候..."));
							Ext.Ajax.request({
								url:StkLocGrpGridUrl+'?actiontype=delete&rowid='+RowId,
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
										StkLocGrpGridDs.remove(record);
										StkLocGrpGrid.getView().refresh();
										StkLocGrpGridDs.reload();
									}else{
										if(jsonData.info==-2){
											Msg.info("warning", $g("科室组已在科室扩充信息中使用，不能删除!"));
										}else{
											Msg.info("error", $g("删除失败!"));
										}
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				StkLocGrpGridDs.remove(record);
				StkLocGrpGrid.getView().refresh();
			}
		}
    }
});

var formPanel = new Ext.form.FormPanel({
	labelWidth : 60,
	autoScroll:true,
	labelAlign : 'right',
	frame : true,
	autoHeight:true,
	//bodyStyle : 'padding:5px;',
    tbar:[findStkLocGrp,'-',addStkLocGrp,'-',saveStkLocGrp,'-',deleteStkLocGrp],
	items : [{
		xtype : 'fieldset',
		title : $g('查询条件'),
		style:DHCSTFormStyle.FrmPaddingV,
			layout : 'column',
			items : [{
				columnWidth : .33,
				xtype : 'fieldset',
				border:false,
				items : [conditionCodeField]
			}, {
				columnWidth : .33,
				xtype : 'fieldset',
				border:false,
				items : [conditionDescField]
			}]
		}]
});

//分页工具栏
var StkLocGrpPagingToolbar = new Ext.PagingToolbar({
    store:StkLocGrpGridDs,
	pageSize:35,
    displayInfo:true,
    displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
    emptyMsg:$g("没有记录"),
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='RowId';
		B[A.dir]='desc';
		B['conditionCode']=Ext.getCmp('conditionCodeField').getValue();
		B['conditionDesc']=Ext.getCmp('conditionDescField').getValue();
		B['conditionType']=conditionType;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
StkLocGrpGrid = new Ext.grid.EditorGridPanel({
	store:StkLocGrpGridDs,
	cm:StkLocGrpGridCm,
	trackMouseOver:true,
	region:'center',
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	bbar:StkLocGrpPagingToolbar,
	clicksToEdit:1,
	layout:'fit'
});
function Query()
{
		var conditionCode = Ext.getCmp('conditionCodeField').getValue();
		var conditionDesc = Ext.getCmp('conditionDescField').getValue();
		var conditionType = "G";
		StkLocGrpGridDs.load({params:{start:0,limit:StkLocGrpPagingToolbar.pageSize,sort:'RowId',dir:'asc',conditionCode:conditionCode,conditionDesc:conditionDesc,conditionType:conditionType}});
}

var HospPanel = InitHospCombo('DHC_StkLocGroup',function(combo, record, index){
	HospId = this.value; 
	Ext.getCmp('conditionCodeField').setValue('');
	Ext.getCmp('conditionDescField').setValue('');
	Query();
});
//=========================科室组类别=============================

//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		id:"panel",
		title:$g('科室组定义'),
		layout:'fit',
		activeTab:0,
		region:'north',
		height:DHCSTFormStyle.FrmHeight(1),
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		fit:true,
		//items:[HospPanel,panel,StkLocGrpGrid],
		items:[
			{
				region:'north',
				height:'50px',
				items:[HospPanel,panel]
			},StkLocGrpGrid
		],
		renderTo:'mainPanel'
	});
});
Query();
//===========模块主页面===============================================