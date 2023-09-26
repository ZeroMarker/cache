var paramDatasUrl = 'dhc.ca.paramdatasexe.csp';
var paramDatasProxy = new Ext.data.HttpProxy({url: paramDatasUrl + '?action=list'});
var monthDr="";
var itemDr="";
function formatDate(value){
	return value?value.dateFormat('Y-m-d'):'';
};
var paramDatasDs = new Ext.data.Store({
		proxy: paramDatasProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowid',
			'intervalDr',
			'intervalName',
			'itemDr',
			'itemCode',
			'itemName',
			'servDeptDr',
			'servDeptCode',
			'servDeptName',
			'servedDeptDr',
			'servedDeptCode',
			'servedDeptName',
			'value',
			'inType',
			'inPersonDr',
			'inPersonName',
			'remark',
			{name:'inDate',type:'date',dateFormat:'Y-m-d'}
		]),
    // turn on remote sorting
    remoteSort: true
});

paramDatasDs.setDefaultSort('rowid', 'desc');

var paramDatasCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
    {
        header: '参数数值',
        dataIndex: 'value',
        width: 60,
        align: 'left',
        sortable: true
    },
    {
        header: '备注',
        dataIndex: 'remark',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
				header: '项目代码',
				dataIndex: 'itemCode',
				width: 100,
				align: 'left',
				sortable: true
		 },
 		{
				header: '项目名称',
				dataIndex: 'itemName',
				width: 120,
				align: 'left',
				sortable: true
		 },
    {
        header: '服务部门代码',
        dataIndex: 'servDeptCode',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: '服务部门名称',
        dataIndex: 'servDeptName',
        width: 120,
        align: 'left',
        sortable: true
    },
    {
        header: '被服务部门代码',
        dataIndex: 'servedDeptCode',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: '被服务部门名称',
        dataIndex: 'servedDeptName',
        width: 120,
        align: 'left',
        sortable: true
    },
	{
        header: '采集方式',
        dataIndex: 'inType',
        width: 70,
        align: 'left',
        sortable: true
    },
	{
        header: '采集人',
        dataIndex: 'inPersonName',
        width: 70,
        align: 'left',
        sortable: true
    },
	
	{
        header: '日期',
        dataIndex: 'inDate',
        width: 70,
				renderer:formatDate,
        align: 'left',
        sortable: true
    }
]);

var monthsDs = new Ext.data.Store({
	proxy: "",                                                           
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','desc','start','end','dataFinish'])
});
var months = new Ext.form.ComboBox({
	id: 'months',
	fieldLabel: '核算区间',
	anchor: '90%',
	listWidth : 260,
	allowBlank: false,
	store: monthsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'选择核算区间...',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
monthsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.paramdatasexe.csp?action=months&searchValue='+Ext.getCmp('months').getRawValue(),method:'POST'});
});	
months.on("select",function(cmb,rec,id ){
	monthDr=cmb.getValue();
	if((monthDr!="")&&(itemDr!="")){
		Ext.Ajax.request({
			url: 'dhc.ca.paramdatasexe.csp?action=checkMonth&monthDr='+monthDr,
			waitMsg:'保存中...',
			failure: function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success!='true') {
					addDataTypesButton.setDisabled(true);
					editDataTypesButton.setDisabled(true);
					delDataTypesButton.setDisabled(true);
				}else{
					addDataTypesButton.setDisabled(false);
					editDataTypesButton.setDisabled(false);
					delDataTypesButton.setDisabled(false);
				}
			},
			scope: this
		});    
		paramDatasDs.load({params:{start:0, limit:paramDatasPagingToolbar.pageSize, monthDr:monthDr, itemDr:itemDr}});
	}
});


	var itemsDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",                                                        
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','typeDr','typeName','typeShortCut','order','itemDr','itemCode','itemName','itemShortCut'])
	});

	itemsDs.on('beforeload',function(ds, o){           
		ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.vouchdatasexe.csp?action=items&searchField=itemShortCut&searchValue='+Ext.getCmp('items').getRawValue()+'&id=1', method:'POST'});
	});

	var items = new Ext.form.ComboBox({
		id:'items',
		fieldLabel:'项目',
		store: itemsDs,
		valueField:'rowid',
		displayField:'itemShortCut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		anchor: '90%',
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择项目...',
		allowBlank: false,
		name:'items',
		selectOnFocus: true,
		forceSelection: true 
	});
	
items.on("select",function(cmb,rec,id ){
	itemDr=cmb.getValue();
	if((monthDr!="")&&(itemDr!="")){
		Ext.Ajax.request({
			url: 'dhc.ca.paramdatasexe.csp?action=checkMonth&monthDr='+monthDr,
			waitMsg:'保存中...',
			failure: function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success!='true') {
					addDataTypesButton.setDisabled(true);
					editDataTypesButton.setDisabled(true);
					delDataTypesButton.setDisabled(true);
				}else{
					addDataTypesButton.setDisabled(false);
					editDataTypesButton.setDisabled(false);
					delDataTypesButton.setDisabled(false);
				}
			},
			scope: this
		});
		paramDatasDs.load({params:{start:0, limit:paramDatasPagingToolbar.pageSize, monthDr:monthDr, itemDr:itemDr}});
	}
});

var addDataTypesButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加参数数据表',        
		iconCls: 'add',
		handler: function(){addFun(paramDatasDs,paramDatasMain,paramDatasPagingToolbar);}
});

var editDataTypesButton  = new Ext.Toolbar.Button({
		text: '修改',        
		tooltip: '修改参数数据表',
		iconCls: 'remove',
		handler: function(){editFun(paramDatasDs,paramDatasMain,paramDatasPagingToolbar);}
});

var delDataTypesButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除参数数据表',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){delFun(paramDatasDs,paramDatasMain,paramDatasPagingToolbar);}
});


var paramDatasSearchField = 'value';

var paramDatasFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '参数数值',value: 'value',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '备注',value: 'remark',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '项目代码',value: 'itemCode',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '项目名称',value: 'itemName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '服务部门代码',value: 'servDeptCode',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '服务部门名称',value: 'servDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '被服务部门代码',value: 'servedDeptCode',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '被服务部门名称',value: 'servedDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '采集方式',value: 'inType',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '采集人',value: 'inPersonName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '日期',value: 'inDate',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck })
		]}
});

function onDataTypesItemCheck(item, checked)
{
		if(checked) {
				paramDatasSearchField = item.value;
				paramDatasFilterItem.setText(item.text + ':');
		}
};

var paramDatasSearchBox = new Ext.form.TwinTriggerField({//查找按钮
		width: 180,
		trigger1Class: 'x-form-clear-trigger',
		trigger2Class: 'x-form-search-trigger',
		emptyText:'搜索...',
		listeners: {
				specialkey: {fn:function(field, e) {
				var key = e.getKey();
	      	  if(e.ENTER === key) {this.onTrigger2Click();}}}
	    	},
		grid: this,
		onTrigger1Click: function() {
				if(this.getValue()) {
					this.setValue('');    
					paramDatasDs.proxy = new Ext.data.HttpProxy({url: paramDatasUrl + '?action=list'});
					paramDatasDs.load({params:{start:0, limit:paramDatasPagingToolbar.pageSize, monthDr:monthDr, itemDr:itemDr}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
				paramDatasDs.proxy = new Ext.data.HttpProxy({
				url: encodeURI(paramDatasUrl + '?action=list&searchField=' + paramDatasSearchField + '&searchValue=' + this.getValue())});
	        	paramDatasDs.load({params:{start:0, limit:paramDatasPagingToolbar.pageSize, monthDr:monthDr, itemDr:itemDr}});
	    	}
		}
});

var paramDatasPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: paramDatasDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',paramDatasFilterItem,'-',paramDatasSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['monthDr']=monthDr;
			B['itemDr']=itemDr;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
});

var paramDatasMain = new Ext.grid.GridPanel({//表格
		title: '参数数据表',
		store: paramDatasDs,
		cm: paramDatasCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: ['核算区间:',months,'-','项目:',items,'-',addDataTypesButton,'-',editDataTypesButton,'-',delDataTypesButton],
		bbar: paramDatasPagingToolbar
});