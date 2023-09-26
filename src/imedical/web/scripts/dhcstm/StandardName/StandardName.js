// 名称:物资标准名称维护
// 编写日期:2019-04-10

//=========================科室组类别=============================
var conditionCodeField = new Ext.form.TextField({
	id:'conditionCodeField',
	fieldLabel:'代码',
	allowBlank:true,
	emptyText:'代码...',
	anchor:'90%',
	selectOnFocus:true
});
	
var conditionDescField = new Ext.form.TextField({
	id:'conditionDescField',
	fieldLabel:'名称',
	allowBlank:true,
	emptyText:'名称...',
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
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:''
	});
					
	StandardNameGridDs.add(NewRecord);
	StandardNameGrid.startEditing(StandardNameGridDs.getCount() - 1, 1);
}


var StandardNameGrid="";
//配置数据源
var StandardNameGridUrl = 'dhcstm.standardnameaction.csp';
var StandardNameGridProxy= new Ext.data.HttpProxy({url:StandardNameGridUrl+'?actiontype=query',method:'POST'});
var StandardNameGridDs = new Ext.data.Store({
	proxy:StandardNameGridProxy,
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
var StandardNameGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"代码",
        dataIndex:'Code',
        width:180,
        align:'left',
		editor: new Ext.form.TextField({
			id:'codeField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						StandardNameGrid.startEditing(StandardNameGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:"名称",
        dataIndex:'Desc',
        width:300,
        align:'left',
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
StandardNameGridCm.defaultSortable = true;

var FindBT = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var conditionCode = Ext.getCmp('conditionCodeField').getValue();
		var conditionDesc = Ext.getCmp('conditionDescField').getValue();
		StandardNameGridDs.setBaseParam('conditionCode',conditionCode)
		StandardNameGridDs.setBaseParam('conditionDesc',conditionDesc)
		StandardNameGridDs.load({params:{start:0,limit:StandardNamePagingToolbar.pageSize}});
	}
});

var AddBT = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var SaveBT = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(StandardNameGrid.activeEditor!=null){
			StandardNameGrid.activeEditor.completeEdit();
		}
		//获取所有的新记录 
		var mr=StandardNameGridDs.getModifiedRecords();
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
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: StandardNameGridUrl+'?actiontype=save',
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
						StandardNameGridDs.reload();
					}else{
						var date=jsonData.info
						if(date==-5){
						Msg.info("error", "代码重复!");}
						else if(date==-6){
						Msg.info("error", "名称重复!" );}
						else{
						Msg.info("error", "保存失败！" );}
						StandardNameGridDs.reload();
					}
				},
				scope: this
			});
		}
    }
});


var DeleteBT = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = StandardNameGrid.getSelectionModel().getSelectedCell();
		alert(cell)
		if(cell==null){
			Msg.info("error", "请选择数据!");
			return false;
		}else{
			var record = StandardNameGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:StandardNameGridUrl+'?actiontype=delete&rowid='+RowId,
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
										StandardNameGridDs.load({params:{start:0,limit:StandardNamePagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:""}});
									}else{
										if(jsonData.info==-1){
											Msg.info("error", "配送商在物资定义里使用过，不能删除!");
										}else{
											Msg.info("error", "删除失败!");
										}
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

var formPanel = new Ext.form.FormPanel({
	title:'物资标准名称维护',
	labelwidth : 30,
	labelAlign : 'right',
	region:'north',
	height:150,
	frame : true,
	bodyStyle : 'padding:5px;',
    tbar:[FindBT,'-',AddBT,'-',SaveBT],	//,'-',DeleteBT
	items : [{
		items : [{
			xtype : 'fieldset',
			title : '查询条件',
			items : [{
				layout : 'column',
				items : [{
					columnWidth : .3,
					layout : 'form',
					items : [conditionCodeField]
				}, {
					columnWidth : .3,
					layout : 'form',
					items : [conditionDescField]
				}]
			}]
		}]
	}]
});

//分页工具栏
var StandardNamePagingToolbar = new Ext.PagingToolbar({
    store:StandardNameGridDs,
	pageSize:35,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录"
});

//表格
StandardNameGrid = new Ext.grid.EditorGridPanel({
	store:StandardNameGridDs,
	cm:StandardNameGridCm,
	trackMouseOver:true,
	region:'center',
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	bbar:StandardNamePagingToolbar,
	clicksToEdit:1
});

//=========================科室组类别=============================

//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,StandardNameGrid],
		renderTo:'mainPanel'
	});
	FindBT.handler();
});
//===========模块主页面===============================================