var unitTypeDs = new Ext.data.Store({
		autoLoad: true,
		proxy: new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listdhcacccre', method:'GET'}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'},['creCode','rowid'])	
});

//unitTypeDs.on(
//	'beforeload',
//	function(ds, o){
//		ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=listunittypes&searchField=shortcut&searchValue='+Ext.getCmp('unitTypeSelecter').getRawValue(), method:'GET'});
//	}
//);

var unitTypeSelecter = new Ext.form.ComboBox({
		id:'unitTypeSelecter',
		fieldLabel:'名称',
		store: unitTypeDs,
		valueField:'rowid',
		displayField:'creCode',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		width:150,
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择...',
		allowBlank: false,
		name:'unitTypeSelecter',
		selectOnFocus: true,
		forceSelection: true 
});

unitTypeSelecter.on(
	"select",
	function(cmb,rec,id ){
		searchFun(cmb.getValue());
	}
);

var unitTypeRowid = "";

function searchFun(unitTypeDr)
{
		unitTypeRowid = unitTypeDr;
		unitsDs.proxy = new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listdhcacccresub&creSubParRef='+unitTypeRowid});
		unitsDs.load();
};

var unitsDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listdhcacccresub&creSubParRef='+unitTypeRowid, method:'GET'}),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
		
			'rowid',
			'creSubParRef',
			'creSubDesc',
			'creSubDataSource',
			'creSubPatType',
			'creSubAccItem',
			'creSubadmreason',
			'creSubpaymode',
			'creSubcat',
			'creSubLoc',
			'creSubFlag1',
			'creSubFlag2',
			'creSubFlag3',
			'creSubFlag4',
			'creSubFlag5',
			'creSubPrePrtFlag',
			'creSubIncluAbort',
			'creSubDFContains',
			'creSubJFContains'

		]),
    remoteSort: true
});

unitsDs.setDefaultSort('rowid', 'Desc');

var unitsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
    	header: '名称',
        dataIndex: 'creSubDesc',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "业务类型",
        dataIndex: 'creSubDataSource',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: '数据分类',
        dataIndex: 'creSubPatType',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "会计分类",
        dataIndex: 'creSubAccItem',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: '病人类型',
        dataIndex: 'creSubadmreason',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "支付方式",
        dataIndex: 'creSubpaymode',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: '收费项目',
        dataIndex: 'creSubcat',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "病人在院科室",
        dataIndex: 'creSubLoc',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
    	header: '备用1',
        dataIndex: 'creSubFlag1',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "备用2",
        dataIndex: 'creSubFlag2',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
    	header: '备用3',
        dataIndex: 'creSubFlag3',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "备用4",
        dataIndex: 'creSubFlag4',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
    	header: '备用5',
        dataIndex: 'creSubFlag5',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "包含重打",
        dataIndex: 'creSubPrePrtFlag',
        width: 80,
        align: 'left',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
        sortable: true
    },
	{
    	header: '包含作废',
        dataIndex: 'creSubIncluAbort',
        width: 80,
        align: 'left',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
        sortable: true
    },
	{
        header: "贷方",
        dataIndex: 'creSubDFContains',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "借方",
        dataIndex: 'creSubJFContains',
        width: 80,
        align: 'left',
        sortable: true
    }
]);

var addUnitsButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip:'添加新单位信息',        
		iconCls:'add',
		handler: function(){
			if(unitTypeRowid==""){
				Ext.Msg.show({title:'注意',msg:'请先选择DHCAccCre!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}else{
				addFun(unitsDs,unitsMain,unitsPagingToolbar,unitTypeRowid);
			}
		}
	});

var editUnitsButton  = new Ext.Toolbar.Button({
		text:'修改',        
		tooltip:'修改选定的单位信息',
		iconCls:'remove',        
		handler: function(){
			if(unitTypeRowid==""){
				Ext.Msg.show({title:'注意',msg:'请先选择DHCAccCre!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}else{
				editFun(unitsDs,unitsMain,unitsPagingToolbar,unitTypeRowid);
			}
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
		title: '凭证模版子表',
		store: unitsDs,
		cm: unitsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: ['DHCAccCre:',unitTypeSelecter,'-',addUnitsButton,'-',editUnitsButton,'-',delUnitsButton],
		bbar: unitsPagingToolbar
	});

unitsDs.load();