var unitsDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listdhcacccre', method:'GET'}),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowid',
			'creCode',
			'creDesc',
			'creDataSource',
            'crePatType',
			'creDate',
			'creTime',
			'creActiveFlag',
            'creStartDate',
			'creEndDate',
			'crePrePrtFlag',
			'creIncluAbort',
            'creModeCode',
			'creBusiType',
			'creNote1',
			'creNote2',
			'creNote3'
		]),
    remoteSort: true
});

unitsDs.setDefaultSort('rowid', 'Desc');

var unitsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
    	header: '凭证代码',
        dataIndex: 'creCode',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "凭证名称",
        dataIndex: 'creDesc',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: '业务类型',
        dataIndex: 'creDataSource',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "数据分类",
        dataIndex: 'crePatType',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: '日期',
        dataIndex: 'creDate',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "时间",
        dataIndex: 'creTime',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: '有效标志',
        dataIndex: 'creActiveFlag',
        width: 80,
        align: 'left',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
        sortable: true
    },
	{
        header: "开始使用日期",
        dataIndex: 'creStartDate',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: '结束使用日期',
        dataIndex: 'creEndDate',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "重打票据处理",
        dataIndex: 'crePrePrtFlag',
        width: 80,
        align: 'left',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
        sortable: true
    },
	{
    	header: '是否包含作废',
        dataIndex: 'creIncluAbort',
        width: 80,
        align: 'left',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
        sortable: true
    }
	/*	,
	{
        header: "creModeCode",
        dataIndex: 'creModeCode',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: 'creBusiType',
        dataIndex: 'creBusiType',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "creNote1",
        dataIndex: 'creNote1',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: 'creNote2',
        dataIndex: 'creNote2',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "creNote3",
        dataIndex: 'creNote3',
        width: 80,
        align: 'left',
        sortable: true
    }
	//{
    //    header: "自动生成凭证",
    //    dataIndex: 'isAutoVouch',
    //    width: 80,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //}
	*/
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
		title: '凭证模版主表',
		store: unitsDs,
		cm: unitsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: [addUnitsButton,'-',editUnitsButton,'-',delUnitsButton],
		bbar: unitsPagingToolbar
	});

unitsDs.load();