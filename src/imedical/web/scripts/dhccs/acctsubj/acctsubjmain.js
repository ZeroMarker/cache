var unitsDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctsubj', method:'GET'}),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
			'rowid',
			'acctYearDr', 
			'acctYearName', 
			'acctSubjTypeDr', 
			'acctSubjTypeName', 
			'acctSubjCode', 
			'aCCTSubjName', 
			'aCCTSubjNameAll', 
			'superSubj', 
			'superSubjName',
			'subjLevel', 
			'isLast', 
			'direction', 
			'isCash', 
			'isNum', 
			'isFc', 
			'isCheck', 
			'checkType1', 
			'checkType2', 
			'checkType3', 
			'checkType4', 
			'checkType5', 
			'checkType6', 
			'checkType7', 
			'checkType8', 
			'define', 
			'spell', 
			'isStop', 
			'isCbcs', 
			'isZero', 
			'subjDefine', 
			'isBudge'
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
        header: '科目类别',
        dataIndex: 'acctSubjTypeName',
        width: 100,
        align: 'left',
        sortable: true
    },
		{
    	header: '科目编码',
        dataIndex: 'acctSubjCode',
        width: 100,
        align: 'right',
        sortable: true
    },
	{
        header: '会计科目名称',
        dataIndex: 'aCCTSubjName',
        width: 150,
        align: 'left',
        sortable: true
    },
		{
    	header: '科目全称',
        dataIndex: 'aCCTSubjNameAll',
        width: 150,
        align: 'left',
        sortable: true
    },
	{
        header: '上级编码',
        dataIndex: 'superSubjName',
        width: 100,
        align: 'left',
        sortable: true
    },
		{
    	header: '科目级别',
        dataIndex: 'subjLevel',
        width: 100,
        align: 'right',
        sortable: true
    },
	//{
    //    header: '末级',
    //    dataIndex: 'isLast',
    //    width: 40,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//	{
    //	header: '余额方向',
    //    dataIndex: 'direction',
    //    width: 40,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //    header: '现金',
    //    dataIndex: 'isCash',
    //    width: 40,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//	{
    //	header: '数量辅助',
    //    dataIndex: 'isNum',
    //    width: 40,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //    header: '核算外币',
    //    dataIndex: 'isFc',
    //    width: 40,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//	{
    //	header: '核算',
    //    dataIndex: 'isCheck',
    //    width: 40,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //    header: '零差率',
    //    dataIndex: 'isZero',
    //    width: 40,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //    header: '辅助核算类1',
    //    dataIndex: 'checkType1',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	//	{
    //	header: '辅助核算类2',
    //    dataIndex: 'checkType2',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	//{
    //    header: '辅助核算类3',
    //    dataIndex: 'checkType3',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	//	{
    //	header: '辅助核算类4',
    //    dataIndex: 'checkType4',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	//{
    //    header: '辅助核算类5',
    //    dataIndex: 'checkType5',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	//	{
    //    header: '辅助核算类6',
    //    dataIndex: 'checkType6',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	//	{
    //	header: '辅助核算类7',
    //    dataIndex: 'checkType7',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	//{
    //    header: '辅助核算类8',
    //    dataIndex: 'checkType8',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	{
    	header: '自定义码',
        dataIndex: 'define',
        width: 100,
        align: 'right',
        sortable: true
    },
	{
        header: '拼音码',
        dataIndex: 'spell',
        width: 100,
        align: 'left',
        sortable: true
    }//,
	//{
    //	header: '停用',
    //    dataIndex: 'isStop',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //    header: '成本相关',
    //    dataIndex: 'isCbcs',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //	header: '科目定义',
    //    dataIndex: 'subjDefine',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	//{
    //	header: '预算控制',
    //    dataIndex: 'isBudge',
    //    width: 100,
    //    align: 'left',
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
		title: '101会计科目字典',
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