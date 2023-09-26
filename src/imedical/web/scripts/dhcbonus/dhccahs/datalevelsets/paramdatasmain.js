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
        header: '������ֵ',
        dataIndex: 'value',
        width: 60,
        align: 'left',
        sortable: true
    },
    {
        header: '��ע',
        dataIndex: 'remark',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
				header: '��Ŀ����',
				dataIndex: 'itemCode',
				width: 100,
				align: 'left',
				sortable: true
		 },
 		{
				header: '��Ŀ����',
				dataIndex: 'itemName',
				width: 120,
				align: 'left',
				sortable: true
		 },
    {
        header: '�����Ŵ���',
        dataIndex: 'servDeptCode',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: '����������',
        dataIndex: 'servDeptName',
        width: 120,
        align: 'left',
        sortable: true
    },
    {
        header: '�������Ŵ���',
        dataIndex: 'servedDeptCode',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: '������������',
        dataIndex: 'servedDeptName',
        width: 120,
        align: 'left',
        sortable: true
    },
	{
        header: '�ɼ���ʽ',
        dataIndex: 'inType',
        width: 70,
        align: 'left',
        sortable: true
    },
	{
        header: '�ɼ���',
        dataIndex: 'inPersonName',
        width: 70,
        align: 'left',
        sortable: true
    },
	
	{
        header: '����',
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
	fieldLabel: '��������',
	anchor: '90%',
	listWidth : 260,
	allowBlank: false,
	store: monthsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'ѡ���������...',
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
			waitMsg:'������...',
			failure: function(result, request) {
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
		fieldLabel:'��Ŀ',
		store: itemsDs,
		valueField:'rowid',
		displayField:'itemShortCut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		anchor: '90%',
		listWidth:250,
		triggerAction:'all',
		emptyText:'ѡ����Ŀ...',
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
			waitMsg:'������...',
			failure: function(result, request) {
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
		text: '���',
		tooltip: '��Ӳ������ݱ�',        
		iconCls: 'add',
		handler: function(){addFun(paramDatasDs,paramDatasMain,paramDatasPagingToolbar);}
});

var editDataTypesButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		tooltip: '�޸Ĳ������ݱ�',
		iconCls: 'remove',
		handler: function(){editFun(paramDatasDs,paramDatasMain,paramDatasPagingToolbar);}
});

var delDataTypesButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ���������ݱ�',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){delFun(paramDatasDs,paramDatasMain,paramDatasPagingToolbar);}
});


var paramDatasSearchField = 'value';

var paramDatasFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '������ֵ',value: 'value',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��ע',value: 'remark',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '��Ŀ����',value: 'itemCode',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '��Ŀ����',value: 'itemName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�����Ŵ���',value: 'servDeptCode',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '����������',value: 'servDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�������Ŵ���',value: 'servedDeptCode',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '������������',value: 'servedDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�ɼ���ʽ',value: 'inType',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�ɼ���',value: 'inPersonName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'inDate',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck })
		]}
});

function onDataTypesItemCheck(item, checked)
{
		if(checked) {
				paramDatasSearchField = item.value;
				paramDatasFilterItem.setText(item.text + ':');
		}
};

var paramDatasSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
		width: 180,
		trigger1Class: 'x-form-clear-trigger',
		trigger2Class: 'x-form-search-trigger',
		emptyText:'����...',
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

var paramDatasPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: paramDatasDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
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

var paramDatasMain = new Ext.grid.GridPanel({//���
		title: '�������ݱ�',
		store: paramDatasDs,
		cm: paramDatasCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: ['��������:',months,'-','��Ŀ:',items,'-',addDataTypesButton,'-',editDataTypesButton,'-',delDataTypesButton],
		bbar: paramDatasPagingToolbar
});