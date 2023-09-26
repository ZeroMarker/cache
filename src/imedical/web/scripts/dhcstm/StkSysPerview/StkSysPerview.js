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
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		Type:''
	});
					
	OpTypeGridDs.add(NewRecord);
	OpTypeGrid.startEditing(OpTypeGridDs.getCount() - 1, 1);
}

var OpTypeStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["O",'出库'], ["I",'入库']]
});
	
var OpTypeGrid="";
//配置数据源
var OpTypeGridUrl = 'dhcstm.optypeaction.csp';
var OpTypeGridProxy= new Ext.data.HttpProxy({url:OpTypeGridUrl+'?actiontype=selectAll',method:'GET'});
var OpTypeGridDs = new Ext.data.Store({
	proxy:OpTypeGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'Type'}
	]),
    remoteSort:true
});



//模型
var OpTypeGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"代码",
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
						OpTypeGrid.startEditing(OpTypeGridDs.getCount() - 1, 3);
					}
				}
			}
        })
    },{
        header:"类别",
        dataIndex:'Type',
        width:200,
        align:'left',
        sortable:true,
		renderer:function(v, p, record){
			if(v=="O")
				return "出库";
			if(v=="I")
				return "入库";
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
    }
]);

//初始化默认排序功能
OpTypeGridCm.defaultSortable = true;

var addOpType = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveOpType = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
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
			//Ext.Msg.show({title:'错误',msg:'没有修改或添加新数据!'});
			//Ext.MsgTip.msg('消息标题', '消息内容',true);//默认5秒后自动隐藏
			Msg.info("error", "没有修改或添加新数据!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: OpTypeGridUrl+'?actiontype=save',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					//Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					Msg.info("error", "请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						//Ext.Msg.show({title:'注意',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						Msg.info("success", "保存成功!");
						OpTypeGridDs.load();
					}else{
						//Ext.Msg.show({title:'错误',msg:jsonData.info+" 保存失败",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						Msg.info("error", "保存失败!" +jsonData.info);
						OpTypeGridDs.load();
					}
				},
				scope: this
			});
		}
    }
});

var deleteOpType = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = OpTypeGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			//Ext.Msg.show({title:'提示',msg:'请选择数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			Msg.info("error", "请选择数据!");
			return false;
		}else{
			var record = OpTypeGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:OpTypeGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									 mask.hide();
									//Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									Msg.info("error", "请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										//Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										Msg.info("success", "删除成功!");
										OpTypeGridDs.load();
									}else{
										//Ext.Msg.show({title:'提示',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										Msg.info("error", "删除失败!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				//Ext.Msg.show({title:'提示',msg:'数据有错,没有RowId!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				Msg.info("error", "数据有错,没有RowId!");
			}
		}
    }
});

//表格
OpTypeGrid = new Ext.grid.EditorGridPanel({
	store:OpTypeGridDs,
	cm:OpTypeGridCm,
	trackMouseOver:true,
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
    tbar:[addOpType,'-',saveOpType,'-',deleteOpType]
});

OpTypeGridDs.load();
//=========================出入库类别=================================

//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var OpTypePanel = new Ext.Panel({
		title:'出入库维护',
		activeTab: 0,
		region:'center',
		items:[OpTypeGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout: 'border',
		items:[OpTypePanel],
		renderTo: 'mainPanel'
	});
});
//===========模块主页面===============================================