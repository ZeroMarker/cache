var unitsDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctyearperiod', method:'GET'}),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
			'rowid', 
			'acctYearDr', 
			'acctYearName',
			'acctMonth',
			'beginDate',
			'endDate',
			'cashFlag',
			'fixFlag',
			'matFlag',
			'medFlag',
			'drugStoreFlag',
			'wageFlag',
			'accFlag',
			'budgFlag',
			'perfFlag',
			'costFlag',
			'matCheckDate',
			'fixCheckDate',
			'isDepreciation'
		]),
    remoteSort: true
});

unitsDs.setDefaultSort('rowid', 'Desc');

var unitsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
    	header: '会计年度',
        dataIndex: 'acctYearName',
        width: 100,
        align: 'right',
        sortable: true
    },
	{
        header: "会计期间",
        dataIndex: 'acctMonth',
        width: 100,
        align: 'right',
        sortable: true
    },
    {
        header: "开始日期",
        dataIndex: 'beginDate',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: "结束日期",
        dataIndex: 'endDate',
        width: 100,
        align: 'left',
        sortable: true
    }//,
    //{
    //    header: "现金银行结账",
    //    dataIndex: 'cashFlag',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
    //{
    //    header: "固定资产结账",
    //    dataIndex: 'fixFlag',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //    header: "物资结账",
    //    dataIndex: 'matFlag',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
    //{
    //    header: "药库结账",
    //    dataIndex: 'medFlag',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
    //{
    //    header: "药房结账",
    //    dataIndex: 'drugStoreFlag',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
    //{
    //    header: "工资结账",
    //    dataIndex: 'wageFlag',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
    //{
    //    header: "账务结账",
    //    dataIndex: 'accFlag',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //    header: "预算结账",
    //    dataIndex: 'budgFlag',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
    //{
    //    header: "绩效结账",
    //    dataIndex: 'perfFlag',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
    //{
    //    header: "成本结账",
    //    dataIndex: 'costFlag',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
    //{
    //    header: "物资结账日期",
    //    dataIndex: 'matCheckDate',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
    //{
    //    header: "固定资产日期",
    //    dataIndex: 'fixCheckDate',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
    //{
    //    header: "是否计提",
    //    dataIndex: 'isDepreciation',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //}
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
		title: '101会计期间表',
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