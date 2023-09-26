var personUrl = '../csp/dhc.qm.checkpointmakeexe.csp';
var personProxy;

//外部指标
var personDs = new Ext.data.Store({
	proxy: personProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'name',
	    'no',
	    'singleno'
	]),
	remoteSort: true
});

personDs.setDefaultSort('rowid', 'name');
var personCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: 'ID',
		dataIndex: 'rowid',
		//width: 20,
		align: 'left',
		sortable: true,
		hidden: true
	},{
		header: "检查点名称",
		dataIndex: 'name',
		//width: 100,
		align: 'left',
		sortable: true
	},{
		header: "顺序号",
		dataIndex: 'no',
		//width:30,
		align: 'left',
		sortable: true
	},{
		header: "单项否决",
		dataIndex: 'singleno',
		//width:50,
		align: 'left',
		sortable: true
	}
]);

//添加按钮	
var addButton = new Ext.Toolbar.Button({
		text: '添加检查点',
		//tooltip: '添加',
		iconCls: 'add',
		handler: function(){addSchemFun(personDs,personGrid);
		}
});
	
//删除按钮
var delButton = new Ext.Toolbar.Button({
	text: '删除',
    //tooltip:'删除',        
    iconCls:'remove',
	handler:function(){

		//var selectedRow = itemGridDs.data.items[rowIndex];
		
		var rowObj = personGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'../csp/dhc.qm.checkpointmakeexe.csp?action=checkdel&rowid='+rowObj[0].get("rowid"),
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									personDs.load({params:{start:0,limit:25,sort:"rowid",dir:"asc"}});
								}else{
									Ext.Msg.show({title:'提示',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
							},
							scope: this
						});
					}
				}
			)
		}
	}
});

	var personPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize:25,
		store:personDs,
		displayInfo:true,
		displayMsg:'当前显示{0} - {1}，共计{2}',
		emptyMsg:"没有数据"
	});
	/*var personPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: personDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"//,

});*/
	var personGrid = new Ext.grid.GridPanel({//表格
		
		region: 'center',
		xtype: 'grid',
		//width:'45%',
		store: personDs,
		cm: personCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [addButton,'-',delButton],
		bbar: personPagingToolbar
	});
	
//刷新页面
//	personGrid.load({params:{start:0,limit:25}});