var unitsDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctsysbusitype', method:'GET'}),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
			'rowid',
			'acctSysModeDr',
			'acctSysModeName',
			'typeCode',
			'typeName',
			'whileSql',
			'isPhase',
			'isInstall'
		]),
    remoteSort: true
});

unitsDs.setDefaultSort('rowid', 'Desc');

var unitsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
    	header: '模块编码',
        dataIndex: 'acctSysModeName',
        width: 200,
        align: 'left',
        sortable: true
    },
	{
        header: '类型编号',
        dataIndex: 'typeCode',
        width: 100,
        align: 'right',
        sortable: true
    },
	{
    	header: '类型名称',
        dataIndex: 'typeName',
        width: 200,
        align: 'left',
        sortable: true
    },
	{
    	header: '查询条件',
        dataIndex: 'whileSql',
        width: 200,
        align: 'left',
        sortable: true
    },
	{
    	header: '是否分阶段',
        dataIndex: 'isPhase',
        width: 60,
        align: 'left',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
        sortable: true
    },
	{
        header: "是否安装",
        dataIndex: 'isInstall',
        width: 60,
        align: 'left',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
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
		title: '302系统业务类型',
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