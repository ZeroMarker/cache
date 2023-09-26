// 名称:账簿分类维护
// 编写日期:2013-05-16	
//Creater:wangguohua
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
					
	BookCatGridDs.add(NewRecord);
	BookCatGrid.startEditing(BookCatGridDs.getCount() - 1, 1);
}

var BookCatGrid="";
//配置数据源
var BookCatGridUrl = 'dhcstm.bookcataction.csp';
var BookCatGridProxy= new Ext.data.HttpProxy({url:BookCatGridUrl+'?actiontype=query',method:'GET'});
var BookCatGridDs = new Ext.data.Store({
	proxy:BookCatGridProxy,
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
//Grid列模型
var BookCatGridCm = new Ext.grid.ColumnModel([
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
						 BookCatGrid.startEditing(BookCatGridDs.getCount() - 1, 2);
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
    }
]);

//初始化默认排序功能
BookCatGridCm.defaultSortable = true;

//新建
var addBookCat = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

//保存
var saveBookCat = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//获取所有的新记录 
		var mr=BookCatGridDs.getModifiedRecords();
		var data="";
		var rowDelim=xRowDelim();
		for(var i=0;i<mr.length;i++){
		
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			if((code!="")&&(desc!="")){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc;
				if(data==""){
					data = dataRow;
				}else{
					data = data + rowDelim + dataRow;
				}
			}
			
		}

		if(data==""){
			Msg.info("error", "没有修改或添加新数据!");
			return false;
		}else{
			Ext.Ajax.request({
				url: BookCatGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					Msg.info("error", "请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						BookCatGridDs.load();
					}else{
						var date=jsonData.info
						if(date==-5){
						Msg.info("error", "代码重复!");}
						else if(date==-6){
						Msg.info("error", "名称重复!" );}
						else{
						Msg.info("error", "保存失败!");
						}
						BookCatGridDs.load();
					}
				},
				scope: this
			});
		}
    }
});

//删除
var deleteBookCat = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = BookCatGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "请选择数据!");
			return false;
		}else{
			var record = BookCatGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:BookCatGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									Msg.info("error", "请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success", "删除成功!");
										BookCatGridDs.load();
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
				Msg.info("error", "数据有错,没有RowId!");
			}
		}
    }
});

//表格定义
BookCatGrid = new Ext.grid.EditorGridPanel({
	store:BookCatGridDs,
	cm:BookCatGridCm,
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addBookCat,'-',saveBookCat],	//,'-',deleteBookCat
	clicksToEdit:1
});

BookCatGridDs.load();

//模块主页面
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'账簿分类维护',
		activeTab:0,
		region:'center',
		items:[BookCatGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
});