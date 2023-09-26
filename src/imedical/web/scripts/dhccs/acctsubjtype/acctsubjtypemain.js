var unitsDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctsubjtype', method:'GET'}),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowid',
			'compCode',
			'copyCode',
			'note',
			'subjTypeCode',
			'subjTypeName'
		]),
    remoteSort: true
});

unitsDs.setDefaultSort('rowid', 'Desc');

var unitsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
    	header: '单位编码',
        dataIndex: 'compCode',
        width: 100,
        align: 'right',
        sortable: true
    },
	{
        header: "账套编码",
        dataIndex: 'copyCode',
        width: 100,
        align: 'right',
        sortable: true
    },
    {
        header: "说明",
        dataIndex: 'note',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: "科目类别编码",
        dataIndex: 'subjTypeCode',
        width: 100,
        align: 'right',
        sortable: true
    },
    {
        header: "科目类别名称",
        dataIndex: 'subjTypeName',
        width: 100,
        align: 'left',
        sortable: true
    }
]);

var addUnitsButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip:'添加新单位信息',        
		iconCls:'add',
		handler: function(){
			addFun(unitsDs,unitsMain);
		}
	});

var editUnitsButton  = new Ext.Toolbar.Button({
		text:'修改',        
		tooltip:'修改选定的单位信息',
		iconCls:'remove',        
		handler: function(){
			editFun(unitsDs,unitsMain);
		}
	});

var delUnitsButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的单位',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			delFun(unitsDs,unitsMain);
		}
	});

//var unitsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
//		pageSize: 25,
//		store: unitsDs,
//		displayInfo: true,
//		displayMsg: '当前显示{0} - {1}，共计{2}',
//		emptyMsg: "没有数据"
//	});

var unitsMain = new Ext.grid.GridPanel({//表格
		title: '101科目类别-NS',
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