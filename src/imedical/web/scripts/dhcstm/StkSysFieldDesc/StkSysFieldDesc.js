// 名称:表字段描述
// 编写日期:2015-02-07

var actionUrl = DictUrl+"stkfielddescaction.csp"

var SearchBT = new Ext.Toolbar.Button({
	id:"SearchBT",
	text : '查询',
	tooltip : '点击查询',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		StkSysFieldDescGrid.load();
	}
});

var addBT = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveBT = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		save();
    }
});
var TableName = new Ext.form.TextField({
	id:'TableName',
	fieldLabel:'表名',
	allowBlank:true,
	emptyText:'表名...',
	anchor:'90%',
	selectOnFocus:true
});
	
var FieldName = new Ext.form.TextField({
	id:'FieldName',
	fieldLabel:'字段名',
	allowBlank:true,
	emptyText:'字段名...',
	anchor:'90%',
	selectOnFocus:true
});

//模型
var StkSysFieldDescGridCm = [
	{
		header : "ssfRowid",
		dataIndex : 'ssfRowid',
		width : 80,
		hidden : true
	},{
        header:"表名",
        dataIndex:'tableName',
        width:180,
        align:'left',
		editor: new Ext.form.TextField({
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						StkSysFieldDescGrid.startEditing(StkSysFieldDescGrid.getCount() - 1, 3);
					}
				}
			}
        })
    },{
        header:"字段名",
        dataIndex:'fieldName',
        width:300,
        align:'left',
		editor: new Ext.form.TextField({
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (field.getValue()!="" && e.getKey() == Ext.EventObject.ENTER) {
						var FieldName=field.getValue();
						var row=StkSysFieldDescGrid.getSelectionModel().getSelectedCell()[0];
						var findfieldName=StkSysFieldDescGrid.getStore().findExact('fieldName',FieldName,0);
						if(findfieldName>=0 && findfieldName!=row){
							Msg.info("warning","字段名"+FieldName+"已存在,不可重复录入!");
							field.setValue("");
							field.focus();
							return;
						}
						StkSysFieldDescGrid.startEditing(StkSysFieldDescGrid.getCount() - 1, 4);
					}
				}
			}
        })
	},{
        header:"序列号",
        dataIndex:'colNumber',
        width:300,
        align:'left',
		editor: new Ext.form.TextField({
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						StkSysFieldDescGrid.startEditing(StkSysFieldDescGrid.getCount() - 1, 5);
					}
				}
			}
        })
	},{
        header:"字段描述",
        dataIndex:'fieldDesc',
        width:300,
        align:'left',
		editor: new Ext.form.TextField({
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
];

//初始化默认排序功能
StkSysFieldDescGridCm.defaultSortable = true;

StkSysFieldDescGrid = new Ext.dhcstm.EditorGridPanel({
	editable : false,
	region:'center',
	id : 'StkSysFieldDescGrid',
	contentColumns : StkSysFieldDescGridCm,
	actionUrl : actionUrl,
	queryAction : "query",
	paramsFn : GetParams,
	selectFirst : false,
	idProperty : "ssfRowid",
	checkProperty : "tableName"
});

function GetParams(){
	var TableName = Ext.getCmp("TableName").getValue();
	var FieldName = Ext.getCmp("FieldName").getValue();
	var ListParam = TableName+'^'+FieldName;
	return {"ListData":ListParam};
}

function addNewRow(){
	var record = Ext.data.Record.create([
		{
			name : 'ssfRowid',
			type : 'int'
		}, {
			name : 'tableName',
			type : 'string'
		}, {
			name : 'fieldName',
			type : 'string'
		}, {
			name : 'colNumber',
			type : 'int'
		}, {
			name : 'fieldDesc',
			type : 'string'
		}
	]);
	var NewRecord = new record({
		ssfRowid:'',
		tableName:'',
		fieldName:'',
		colNumber:'',
		fieldDesc:''
	});
	StkSysFieldDescGrid.add(NewRecord);
	StkSysFieldDescGrid.startEditing(StkSysFieldDescGrid.getCount() - 1, 2);
}

function save(){
	if(StkSysFieldDescGrid.activeEditor!=null){
		StkSysFieldDescGrid.activeEditor.completeEdit();
	}
	var mr=StkSysFieldDescGrid.getModifiedRecords();
	var Data="";
	for(var i=0;i<mr.length;i++){
		var tableName = mr[i].data["tableName"].trim();
		var fieldName = mr[i].data["fieldName"].trim();
		var colNumber = mr[i].data["colNumber"].trim();
		var fieldDesc = mr[i].data["fieldDesc"].trim();
		if((tableName!="")&&(fieldName!="")&&(colNumber!="")&&(fieldDesc!="")){
			var dataRow = mr[i].data["ssfRowid"]+"^"+tableName+"^"+fieldName+"^"+colNumber+"^"+fieldDesc;
			if(Data==""){
				Data = dataRow;
			}else{
				Data = Data+xRowDelim()+dataRow;
			}
		}
	}
	if(Data==""){
		Msg.info("error", "没有修改或添加新数据!");
		return false;
	}else{
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url: actionUrl+'?actiontype=save',
			params: {Data:Data},
			failure: function(result, request) {
				mask.hide();
				Msg.info("error", "请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success", "保存成功！");
					StkSysFieldDescGrid.reload();
				}else{
					var date=jsonData.info;
					if(date==-3){
						Msg.info("error", "更新失败！");
					}else if(date==-4){
						Msg.info("error", "插入失败！" );
					}else{
						Msg.info("error", "保存失败！"+date );
					}
					StkSysFieldDescGrid.reload();
				}
			},
			scope: this
		});
	}
}

var formPanel = new Ext.form.FormPanel({
	title:'表字段描述维护',
	labelwidth : 30,
	labelAlign : 'right',
	region:'north',
	height:140,
	frame : true,
	bodyStyle : 'padding:5px;',
    tbar:[SearchBT,'-',addBT,'-',saveBT],
	items : [{
		items : [{
			xtype : 'fieldset',
			title : '查询条件',
			items : [{
				layout : 'column',
				items : [{
					columnWidth : 0.3,
					layout : 'form',
					items : [TableName]
				}, {
					columnWidth : 0.3,
					layout : 'form',
					items : [FieldName]
				}]
			}]
		}]
	}]
});

//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,StkSysFieldDescGrid],
		renderTo:'mainPanel'
	});
	StkSysFieldDescGrid.load();
});
//===========模块主页面===============================================