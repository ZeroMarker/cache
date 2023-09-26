// 名称:多级类组
// 编写日期:2013-05-18
//=========================定义全局变量===============================
var StkCatGroupId = "";
//=========================多级类组=====================================
var IncScStkGrpStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.sstkcatgroupaction.csp?actiontype=Select&start=0&limit=999',
		method:'POST'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['sDesc', 'sRowId'])
});
IncScStkGrpStore.load();

var SCG = new Ext.form.ComboBox({
	fieldLabel : '名称',
	id : 'SCG',
	name : 'SCG',
	anchor : '90%',
	width : 120,
	store : IncScStkGrpStore,
	valueField : 'sRowId',
	displayField : 'sDesc',
	valueNotFoundText : ''
});	

SCG.on('beforequery',function(e){
	this.store.removeAll();
	var Other=Ext.getCmp('OtherFlag').getValue()==true?"O":"M";
	this.store.setBaseParam("Desc",this.getRawValue());
	this.store.setBaseParam("Type",Other);
	this.store.load();
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
		},{
			name : 'sRowId',
			type : 'int'
		}, {
			name : 'sCode',
			type : 'string'
		}, {
			name : 'sDesc',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		sRowId:'',
		sCode:'',
		sDesc:''
	});
					
	StkCatGroupGridDs.add(NewRecord);
	StkCatGroupGrid.startEditing(StkCatGroupGridDs.getCount() - 1, 1);
}


//Grid列模型
var StkCatGroupGridCm = new Ext.grid.ColumnModel([
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
						var col=GetColIndex(StkCatGroupGrid,'Desc');
						StkCatGroupGrid.startEditing(StkCatGroupGridDs.getCount() - 1, col);
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
    },{
        header:"上级类组",
        dataIndex:'sRowId',
        width:300,
        align:'left',
        sortable:true,
		renderer : Ext.util.Format.comboRenderer2(SCG,"sRowId","sDesc"),
		editor : new Ext.grid.GridEditor(SCG)
    }
]);

//初始化默认排序功能
StkCatGroupGridCm.defaultSortable = true;
var addStkCatGroup = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveStkCatGroup = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(StkCatGroupGrid.activeEditor != null){
			StkCatGroupGrid.activeEditor.completeEdit();
		}
		//获取所有的新记录 
		var mr=StkCatGroupGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var rowid=mr[i].data["RowId"].trim();
			var code=mr[i].data["Code"].trim();
			var desc=mr[i].data["Desc"].trim();
			var sRowid= mr[i].data["sRowId"].trim();
			var type=Ext.getCmp('OtherFlag').getValue()==true?"O":"M";
			if (rowid != "" && rowid == sRowid){
				Msg.info("warning","名称不能与顶级类组相同");
				return false;
			}else{
				if(code!="" && desc!=""){
					var dataRow = rowid+"^"+code+"^"+desc+"^"+sRowid+"^"+type;
					if(data==""){
						data = dataRow;
					}else{
						data = data+xRowDelim()+dataRow;
					}
				}
			}
		}
		if(data==""){
			Msg.info("warning","没有修改或添加新数据!");
			return false;
		}else{
			Ext.Ajax.request({
				url: StkCatGroupGridUrl+'?actiontype=save',
				params : {data:data},
				failure: function(result, request) {
					Msg.info("error","请检查网络连接!");
					StkCatGroupGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");			
						StkCatGroupGridDs.load();
					}else{
						Msg.info("error","记录重复"+jsonData.info);
						StkCatGroupGridDs.load();
					}
					StkCatGroupGridDs.commitChanges();
				},
				scope: this
			});
		}
    }
});

var deleteStkCatGroup = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = StkCatGroupGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","请选择数据!");
			return false;
		}else{
			var record = StkCatGroupGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:StkCatGroupGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									Msg.info("error","请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success","删除成功!");
										StkCatGroupGridDs.load();
									}else{
										Msg.info("error","删除失败!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("warning","数据有误,没有RowId!");
			}
		}
    }
});	
var StkCatGroupGrid="";
//配置数据源
var StkCatGroupGridUrl = 'dhcstm.sstkcatgroupaction.csp';
var StkCatGroupGridProxy= new Ext.data.HttpProxy({url:StkCatGroupGridUrl+'?actiontype=selectAll',method:'POST'});
var StkCatGroupGridDs = new Ext.data.Store({
	proxy:StkCatGroupGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'sRowId'},
		{name:'sCode'},
		{name:'sDesc'}
	]),
    remoteSort:false
});
//表格
var StkCatGroupGrid = new Ext.ux.EditorGridPanel({
	id : 'StkCatGroupGrid',
	store:StkCatGroupGridDs,
	cm:StkCatGroupGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1
});

var SearchBT = new Ext.Toolbar.Button({
		id : "SearchBT",
		text : '查询',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			var Other=Ext.getCmp('OtherFlag').getValue()==true?"O":"M";
			StkCatGroupGridDs.setBaseParam('Type',Other);
			StkCatGroupGridDs.load({
				params: {
					start: 0,
					limit: 999
				}
			});
		}
	});
var OtherFlag = new Ext.form.Checkbox({
		boxLabel : '财务类组',
		id : 'OtherFlag',
		name : 'OtherFlag',
		anchor : '90%',
		checked : false,
		listeners:{
			check:function(chk,bool){
				SearchBT.handler();
			}
		}
	});
//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var StkCatGroupPanel = new Ext.Panel({
		title:'多级类组维护',
		activeTab: 0,
		region:'center',
		tbar:[SearchBT,'-',addStkCatGroup,'-',saveStkCatGroup,'-',OtherFlag],	//,'-',deleteStkCatGroup
		layout:'fit',
		items:[StkCatGroupGrid]                                 
	});

	var mainPanel = new Ext.ux.Viewport({
		layout: 'border',
		items:[StkCatGroupPanel],
		renderTo: 'mainPanel'
	});
	SearchBT.handler();
});
//===========模块主页面===============================================