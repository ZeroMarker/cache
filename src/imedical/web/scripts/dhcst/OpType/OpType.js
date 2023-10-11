// 名称:出入库类别管理
// 编写日期:2012-05-10

//=========================出入库类别=================================
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
		}, {
			name : 'Default',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		Type:'',
		Default:''
	});
					
	OpTypeGridDs.add(NewRecord);
	OpTypeGrid.startEditing(OpTypeGridDs.getCount() - 1, 1);
}

var OpTypeStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["O",$g('出库')], ["I",$g('入库')]]
});
	
var OpTypeGrid="";
//配置数据源
var OpTypeGridUrl = 'dhcst.optypeaction.csp';
var OpTypeGridProxy= new Ext.data.HttpProxy({url:OpTypeGridUrl+'?actiontype=selectAll',method:'GET'});
var OpTypeGridDs = new Ext.data.Store({
	proxy:OpTypeGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'Type'},
		{name:'Default'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
});

var DefaultField = new Ext.grid.CheckColumn({
	header:$g('是否默认'),
	dataIndex:'Default',
	width:100,
	sortable:true
});

//模型
var OpTypeGridCm = new Ext.grid.ColumnModel([
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
						OpTypeGrid.startEditing(OpTypeGridDs.getCount() - 1, 2);
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
						OpTypeGrid.startEditing(OpTypeGridDs.getCount() - 1, 3);
					}
				}
			}
        })
    },{
        header:$g("类别"),
        dataIndex:'Type',
        width:200,
        align:'left',
        sortable:true,
		renderer:function(v, p, record){
			if(v=="O")
				return $g("出库");
			if(v=="I")
				return $g("入库");
		},
		editor: new Ext.form.ComboBox({
			id:'opTypeField',
			width:216,
			listWidth:216,
			allowBlank:true,
			store:OpTypeStore,
			value:'O', // 默认值"出库"
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
    },DefaultField
]);

//初始化默认排序功能
OpTypeGridCm.defaultSortable = true;

var addOpType = new Ext.Toolbar.Button({
	text:$g('新建'),
    tooltip:$g('新建'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveOpType = new Ext.Toolbar.Button({
	text:$g('保存'),
    tooltip:$g('保存'),
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//获取所有的新记录 
		var mr=OpTypeGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			var type = mr[i].data["Type"].trim();
			var defaultflag=mr[i].data["Default"];
			var rowNum = OpTypeGridDs.indexOf(mr[i])+1;
			if (code==""){
				Msg.info("warning", $g("第")+rowNum+$g("行代码为空!"));
				return;
			}
			if (desc==""){
				Msg.info("warning", $g("第")+rowNum+$g("行名称为空!"));
				return;
			}
			if (type==""){
				Msg.info("warning", $g("第")+rowNum+$g("行类别为空!"));
				return;
			}	
			if((code!="")&&(desc!="")&&(type!="")){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+type+"^"+defaultflag;
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
				url: OpTypeGridUrl+'?actiontype=save',
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
						OpTypeGridDs.load();
					}else{
						Msg.info("error", $g("保存失败!") +jsonData.info);
						OpTypeGridDs.load();
					}
				},
				scope: this
			});
		}
    }
});

var deleteOpType = new Ext.Toolbar.Button({
	text:$g('删除'),
    tooltip:$g('删除'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = OpTypeGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning", $g("请选择数据!"));
			return false;
		}else{
			var record = OpTypeGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('提示'),$g('确定要删除选定的行?'),
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),$g("处理中请稍候..."));
							Ext.Ajax.request({
								url:OpTypeGridUrl+'?actiontype=delete&rowid='+RowId,
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
										OpTypeGridDs.remove(record);
										OpTypeGrid.getView().refresh();
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
				OpTypeGridDs.remove(record);
				OpTypeGrid.getView().refresh();
			}
		}
    }
});

//表格
OpTypeGrid = new Ext.grid.EditorGridPanel({
	store:OpTypeGridDs,
	cm:OpTypeGridCm,
	trackMouseOver:true,
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	plugins:[DefaultField],
    tbar:[addOpType,'-',saveOpType,'-',deleteOpType],
	clicksToEdit:1
});

OpTypeGridDs.load();

var HospPanel = InitHospCombo('DHC_OperateType',function(combo, record, index){
	HospId = this.value; 
	OpTypeGridDs.reload();
});

//=========================出入库类别=================================

//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var OpTypePanel = new Ext.Panel({
		title:$g('出入库维护'),
		activeTab: 0,
		region:'center',
		items:[OpTypeGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items:[HospPanel, OpTypePanel],
		renderTo: 'mainPanel'
	});
});
//===========模块主页面===============================================