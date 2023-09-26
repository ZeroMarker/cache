var unitsDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctsubjmap', method:'GET'}),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
			'rowid',
			'acctModDr', 
			'acctModName', 
			'acctSubjDr', 
			'acctSubjName', 
			//'typeCode', 
			'locDr', 
			'locName', 
			'docType'
		]),
    remoteSort: true
});

unitsDs.setDefaultSort('rowid', 'Desc');

var unitsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
    	header: '子系统编码',
        dataIndex: 'acctModName',
        width: 200,
        align: 'left',
        sortable: true
    },
	{
        header: '科目编码',
        dataIndex: 'acctSubjName',
        width: 200,
        align: 'left',
        sortable: true
    },
		{
    	header: '库存类别',
        dataIndex: 'docType',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '科室',
        dataIndex: 'locName',
        width: 200,
        align: 'left',
        sortable: true
    }//,
	//
    //	header: '编码',
    //   dataIndex: 'typeCode',
    //   width: 100,
    //   align: 'left',
    //   sortable: true
    //
]);

var addUnitsButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip:'添加新单位信息',        
		iconCls:'add',
		handler: function(){
			addFun(unitsDs,unitsMain,unitsPagingToolbar);
		}
	});

var editUnitsButton  = new Ext.Toolbar.Button({
		text:'修改',        
		tooltip:'修改选定的单位信息',
		iconCls:'remove',        
		handler: function(){
			editFun(unitsDs,unitsMain,unitsPagingToolbar);
		}
	});

var delUnitsButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的单位',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			delFun(unitsDs,unitsMain,unitsPagingToolbar);
		}
	});

var unitsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: unitsDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"
	});

var unitsMain = new Ext.grid.GridPanel({//表格
		title: '301类别科目对应主表',
		store: unitsDs,
		cm: unitsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: [addUnitsButton,'-',editUnitsButton,'-',delUnitsButton]//,
		//bbar: unitsPagingToolbar
	});

unitsDs.load();