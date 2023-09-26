var unitsUrl = 'dhc.ca.unitsexe.csp';
var unitDeptsUrl = 'dhc.ca.unitdeptsexe.csp';

var unitTypeDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])	
});

unitTypeDs.on(
	'beforeload',
	function(ds, o){
		ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=listunittypes&searchField=shortcut&searchValue='+Ext.getCmp('unitTypeSelecter').getRawValue(), method:'GET'});
	}
);

var unitTypeSelecter = new Ext.form.ComboBox({
				id:'unitTypeSelecter',
			  fieldLabel:'����',
			  store: unitTypeDs,
			  valueField:'rowId',
			  displayField:'shortcut',
			  typeAhead:true,
			  pageSize:10,
			  minChars:1,
			  width:150,
			  listWidth:250,
			  triggerAction:'all',
			  emptyText:'ѡ��λ���...',
	      allowBlank: false,
			  name:'unitTypeSelecter',
			  selectOnFocus: true,
				forceSelection: true 
});

var unitTypeRowid = "";


var unitDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])	
});
var unitTypeDr="";

var unitRowid = "";

unitTypeSelecter.on(
	"select",
	function(cmb,rec,id ){
		//unitSelecter.reset();
		unitSelecter.setRawValue('');
    unitSelecter.setValue('');
    unitRowid = "";
		unitDeptsDs.proxy = new Ext.data.HttpProxy({url: unitDeptsUrl + '?action=listAll'});
		unitDeptsDs.load({params:{start:0, limit:0}});
		unitTypeDr = cmb.getValue();
		unitTypeRowid = unitTypeDr;
		unitDs.proxy = new Ext.data.HttpProxy({url: unitDeptsUrl + '?action=listunits&searchField=shortcut&unitTypeDr='+unitTypeDr+'&searchValue='+Ext.getCmp('unitSelecter').getRawValue()});
		//alert(unitTypeDr);
		unitDs.load({params:{start:0, limit:9}});
	}
);

unitDs.on(
	'beforeload',
	function(ds, o){
		ds.proxy = new Ext.data.HttpProxy({url: unitDeptsUrl + '?action=listunits&searchField=shortcut&unitTypeDr='+unitTypeDr+'&searchValue='+Ext.getCmp('unitSelecter').getRawValue()});
	}
);

var unitSelecter = new Ext.form.ComboBox({
				id:'unitSelecter',
			  fieldLabel:'����',
			  store: unitDs,
			  valueField:'rowId',
			  displayField:'shortcut',
			  typeAhead:true,
			  pageSize:10,
			  minChars:1,
			  width:150,
			  listWidth:250,
			  triggerAction:'all',
			  emptyText:'ѡ��λ...',
	      allowBlank: false,
			  name:'unitSelecter',
			  selectOnFocus: true,
				forceSelection: true 
});


unitSelecter.on(
	"select",
	function(cmb,rec,id ){
		searchFun(cmb.getValue());
	}
);




function searchFun(unitDr)
{
		unitRowid = unitDr;
		unitDeptsDs.proxy = new Ext.data.HttpProxy({url: unitDeptsUrl + '?action=listAll&unitDr='+unitDr});
		unitDeptsDs.load({params:{start:0, limit:unitDeptsPagingToolbar.pageSize}});
};

var unitDeptsDs = new Ext.data.Store({
		proxy: "",
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowId',
						'code',
						'name',
						'shortcut',
						'address',
						'remark',
						{name:'startTime',type:'date',dateFormat:'Y-m-d'},
						{name:'stop',type:'date',dateFormat:'Y-m-d'},
						'unitDr',
						'propertyDr',
						'active'
		]),
    // turn on remote sorting
    remoteSort: true
});

unitDeptsDs.setDefaultSort('rowId', 'Desc');

function formatDate(value){
    return value ? value.dateFormat('Y-m-d') : '';
};

var unitDeptsCm = new Ext.grid.ColumnModel([
	 	new Ext.grid.RowNumberer(),
	 	{
    		header: '����',
        dataIndex: 'code',
        width: 120,
        align: 'left',
        sortable: true
    },
	 	{
        header: "����",
        dataIndex: 'name',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "��ַ",
        dataIndex: 'address',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "��ע",
        dataIndex: 'remark',
        width: 200,
        align: 'left',
        sortable: true
    },
        {
        header: "����ʱ��",
        dataIndex: 'startTime',
        width: 80,
        align: 'left',
        sortable: true,
        renderer: formatDate
    },
    {
        header: "ͣ��ʱ��",
        dataIndex: 'stop',
        width: 80,
        align: 'left',
        sortable: true,
        renderer: formatDate
    },
    {
        header: "��Ч",
        dataIndex: 'active',
        width: 50,
        sortable: true,
        renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    	}
    }
]);

//������������
var _Excel = new Herp.Excel(
    {
	 url:ServletURL,
     sql:'SELECT UnitDepts_code as ���Ҵ��� ,UnitDepts_name as ��������,UnitDepts_remark as ��ע,UnitDepts_start as ����ʱ��,UnitDepts_stop as ͣ��ʱ��,UnitDepts_active as ��Ч��,UnitDepts_unitDr->Units_name as ҽԺ FROM dhc_ca_cache_data.UnitDepts WHERE UnitDepts_unitDr=?  ORDER BY UnitDepts_code ',
     fileName:"ҽԺ����"     
    });
 
var exportButton = {
    text: '����ҽԺ����',
    tooltip: '��������',
    iconCls: 'remove',
    handler: function() { _Excel.download(unitRowid); }
};


//StatuTabCm.defaultSortable = true;

var addUnitDeptsButton = new Ext.Toolbar.Button({
		text: '���',
    tooltip:'����µ�λ������Ϣ',        
    iconCls:'add',
		handler: function(){
			if(unitRowid==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��λ����ӵ�λ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				addFun(unitDeptsDs,unitDeptsMain,unitDeptsPagingToolbar,unitRowid);
			}
		}
});

var editUnitDeptsButton  = new Ext.Toolbar.Button({
		text:'�޸�',        
		tooltip:'�޸�ѡ���ĵ�λ������Ϣ',
		iconCls:'remove',        
		handler: function(){
			if(unitRowid==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��λ���޸ĵ�λ������Ϣ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				editFun(unitDeptsDs,unitDeptsMain,unitDeptsPagingToolbar);
			}
		}
});

var delUnitDeptsButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ���ĵ�λ����',
		iconCls: 'remove',
		disabled: true,
		handler: function(){delFun(unitDeptsDs,unitDeptsMain,unitDeptsPagingToolbar);}
});

var unitDeptsSearchField = 'name';

var unitDeptsFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: true,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '��ַ',value: 'address',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '��ע',value: 'remark',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				//new Ext.menu.CheckItem({ text: '��ʼʱ��',value: 'startTime',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				//new Ext.menu.CheckItem({ text: 'ֹͣʱ��',value: 'stop',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ч',value: 'active',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck })
		]}
});

function onUnitsItemCheck(item, checked)
{
		if(checked) {
				unitDeptsSearchField = item.value;
				unitDeptsFilterItem.setText(item.text + ':');
		}
};

var unitDeptsSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
							unitDeptsDs.proxy = new Ext.data.HttpProxy({url: unitDeptsUrl + '?action=listAll&unitDr='+unitRowid});
							unitDeptsDs.load({params:{start:0, limit:unitDeptsPagingToolbar.pageSize}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
						unitDeptsDs.proxy = new Ext.data.HttpProxy({
						url: unitDeptsUrl + '?action=listAll&unitDr='+unitRowid+'&searchField=' + unitDeptsSearchField + '&searchValue=' + this.getValue()});
	        	unitDeptsDs.load({params:{start:0, limit:unitDeptsPagingToolbar.pageSize}});
	    	}
		}
});

var unitDeptsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
    store: unitDeptsDs,
    displayInfo: true,
    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
    emptyMsg: "û������",
		buttons: [unitDeptsFilterItem,'-',unitDeptsSearchBox]
});

var unitDeptsMain = new Ext.grid.GridPanel({//���
		title: '��λ�������',
		store: unitDeptsDs,
		cm: unitDeptsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: ['��λ���',unitTypeSelecter,'-','��λ��',unitSelecter,'-',addUnitDeptsButton,'-',editUnitDeptsButton,'-',delUnitDeptsButton,'-',exportButton],
		bbar: unitDeptsPagingToolbar
});