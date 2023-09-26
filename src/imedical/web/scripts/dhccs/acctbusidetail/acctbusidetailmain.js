var unitsDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctbusidetail', method:'GET'}),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
			'rowid',
			'acctSysBusiSectionDr',
			'acctSysBusiPhaseDr',
			'acctSysBusiTypeDr',
			'acctSysBusiTypeName',
			'acctYearDr',
			'acctYearName',
			'acctSubjDr',
			'acctSubjName',
			'summary',
			'caption',
			'direction',
			'isAutoCreate',
			'relayType',
			'isGroup',
			'moneyField',
			'whileSql',
			'isFund',
			'isPay'
		]),
    remoteSort: true
});

unitsDs.setDefaultSort('rowid', 'Desc');

var unitsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	//{
    //	header: '片段编号',
    //    dataIndex: 'acctSysBusiSectionDr',
    //    width: 60,
    //    align: 'left',
    //    sortable: true
    //},
	//{
    //    header: '阶段编号',
    //    dataIndex: 'acctSysBusiPhaseDr',
    //    width: 60,
    //    align: 'left',
    //    sortable: true
    //},
		{
    	header: '类别编号',
        dataIndex: 'acctSysBusiTypeName',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '会计年度',
        dataIndex: 'acctYearName',
        width: 60,
        align: 'right',
        sortable: true
    },
		{
    	header: '科目编码',
        dataIndex: 'acctSubjName',
        width: 150,
        align: 'left',
        sortable: true
    },
	{
        header: '摘要',
        dataIndex: 'summary',
        width: 100,
        align: 'left',
        sortable: true
    },
		{
    	header: '科目标题',
        dataIndex: 'caption',
        width: 150,
        align: 'left',
        sortable: true
    },
	{
        header: '借贷方向',
        dataIndex: 'direction',
        width: 60,
        align: 'left',
		renderer : function(v, p, record){
			//p.css += ' x-grid3-check-col-td'; 
			//return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			if(v=='0'){
				return '借方';
			}else{
				return '贷方';
			}
		},
        sortable: true
    }//,
	//{
    //	header: '是否自动',
    //    dataIndex: 'isAutoCreate',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //	header: '自动序号',
    //    dataIndex: 'relayType',
    //    width: 60,
    //    align: 'left',
    //    sortable: true
    //},
	//{
    //    header: '是否分组',
    //    dataIndex: 'isGroup',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //	header: '金额字段',
    //    dataIndex: 'moneyField',
    //    width: 60,
    //    align: 'left',
    //    sortable: true
    //},	
	//{
    //	header: '科目筛选条件',
    //    dataIndex: 'whileSql',
    //    width: 60,
    //    align: 'left',
    //    sortable: true
    //},		
	//{
    //	header: '是否基金',
    //    dataIndex: 'isFund',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //    header: '是否付款',
    //    dataIndex: 'isPay',
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
		title: '302自动生成凭证模板',
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