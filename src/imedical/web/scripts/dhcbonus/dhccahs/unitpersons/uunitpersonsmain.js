var UnitPersonsUrl = 'dhc.ca.unitpersonsexe.csp';
var UnitPersonsProxy = new Ext.data.HttpProxy({url: UnitPersonsUrl + '?action=list'});
var type="";
function formatDate(value){
	//alert(value);
	return value?value.dateFormat('Y-m-d'):'';
};

var UnitPersonsDs = new Ext.data.Store({
	proxy: UnitPersonsProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid',
			'code',
			'name',
			'shortcut',
			'gender',
			'national',
			'birthPlace',
			'education',
			'title',
			'duty',
			'state',
			'preparation',
			'phone',
			'remark',
			{name:'birthday',type:'date',dateFormat:'Y-m-d'},
			{name:'start',type:'date',dateFormat:'Y-m-d'},
			{name:'stop',type:'date',dateFormat:'Y-m-d'},
			'unitDr',
			'unitName',
			'active'
		]),
    // turn on remote sorting
    remoteSort: true
});

UnitPersonsDs.setDefaultSort('rowid', 'DESC');

var UnitPersonsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '����',
        dataIndex: 'code',
        width: 60,
        align: 'left',
        sortable: true
    },
	{
        header: '����',
        dataIndex: 'name',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: '�Ա�',
        dataIndex: 'gender',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
		header: "��������",
		dataIndex: 'birthday',
		renderer:formatDate,
		align: 'left',
		width: 90,
		sortable: true
	},
	{
        header: '����',
        dataIndex: 'national',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: '����',
        dataIndex: 'birthPlace',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: 'ѧ��',
        dataIndex: 'education',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: 'ְ��',
        dataIndex: 'title',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: 'ְ��',
        dataIndex: 'duty',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: '״̬',
        dataIndex: 'state',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: '����',
        dataIndex: 'preparation',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: '�绰',
        dataIndex: 'phone',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: '��ע',
        dataIndex: 'remark',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
		header: "��ְ����",
		dataIndex: 'start',
		renderer:formatDate,
		align: 'left',
		width: 90,
		sortable: true
	},
	{
		header: "��ְ����",
		dataIndex: 'stop',
		renderer:formatDate,
		align: 'left',
		width: 90,
		sortable: true
	},
	{
        header: '��Ч��־',
        dataIndex: 'active',
        width: 60,
        sortable: true,
        renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    		}
    }
]);

var addUnitPersonsButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '����µĵ�λ��Ա',        
		iconCls: 'add',
		handler: function(){addFun(UnitPersonsDs,UnitPersonsMain,UnitPersonsPagingToolbar);}
});

var editUnitPersonsButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		tooltip: '�޸�ѡ���ĵ�λ��Ա',
		iconCls: 'remove',
		handler: function(){editFun(UnitPersonsDs,UnitPersonsMain,UnitPersonsPagingToolbar);}
});

var delUnitPersonsButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ���ĵ�λ��Ա',
		iconCls: 'remove',
		disabled: true,
		handler: function(){delFun(UnitPersonsDs,UnitPersonsMain,UnitPersonsPagingToolbar);}
});
var deptPersonsButton  = new Ext.Toolbar.Button({
		text: 'ά����Ա����',        
		tooltip: 'ά��ѡ����λ��Ա�Ĳ���',
		iconCls: 'remove',
		handler: function(){CommFindFun(UnitPersonsDs,UnitPersonsMain,UnitPersonsPagingToolbar);}
});
var personsFindButton  = new Ext.Toolbar.Button({
		text: '�鿴������Ա',        
		tooltip: '�鿴������Ա',
		iconCls: 'remove',
		handler: function(){personFindFun(UnitPersonsDs,UnitPersonsMain,UnitPersonsPagingToolbar);}
});
var personsButton  = new Ext.Toolbar.Button({
		text: '�鿴û�в��ŵ���Ա',        
		tooltip: '�鿴û�в��ŵ���Ա',
		iconCls: 'remove',
		handler: function(){
			var unitDr=units.getValue();
			if(unitDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��Ԫ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			type=0;
			UnitPersonsDs.load({params:{start:0, limit:UnitPersonsPagingToolbar.pageSize,id:units.getValue(),type:type}});
		}
});


		
var unitTypeDs = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
});
var unitType = new Ext.form.ComboBox({
	id: 'unitType',
	fieldLabel: '��Ԫ���',
	anchor: '90%',
	listWidth : 260,
	allowBlank: false,
	store: unitTypeDs,
	valueField: 'rowId',
	displayField: 'shortcut',
	triggerAction: 'all',
	emptyText:'ѡ��Ԫ���...',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
unitTypeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=unitType&searchValue='+Ext.getCmp('unitType').getRawValue(),method:'GET'});
});

var unitsDs = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
});
var units = new Ext.form.ComboBox({
	id: 'units',
	fieldLabel: '��Ԫ',
	anchor: '90%',
	listWidth : 260,
	allowBlank: false,
	store: unitsDs,
	valueField: 'rowId',
	displayField: 'shortcut',
	triggerAction: 'all',
	emptyText:'ѡ��Ԫ...',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

unitsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=units&searchValue='+Ext.getCmp('units').getRawValue()+'&id='+unitType.getValue(),method:'GET'});
});

var UnitPersonsSearchField = 'name';

var UnitPersonsFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: true,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '�Ա�',value: 'gender',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '��������',value: 'birthday',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'national',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'birthPlace',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: 'ѧ��',value: 'education',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: 'ְ��',value: 'title',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: 'ְ��',value: 'duty',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '״̬',value: 'state',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'preparation',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '�绰',value: 'phone',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '��ע',value: 'remark',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '��ְʱ��',value: 'startDate',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '��ְʱ��',value: 'endDate',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ч',value: 'active',checked: false,group: 'UnitPersonsFilter',checkHandler: onUnitPersonsItemCheck })
		]}
});

function onUnitPersonsItemCheck(item, checked)
{
		if(checked) {
				UnitPersonsSearchField = item.value;
				UnitPersonsFilterItem.setText(item.text + ':');
		}
};

var UnitPersonsSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				var unitDr=units.getValue();
				if(unitDr==""){
					Ext.Msg.show({title:'ע��',msg:'��ѡ��Ԫ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				this.setValue('');    
				UnitPersonsDs.proxy = new Ext.data.HttpProxy({url: UnitPersonsUrl + '?action=list'});
				UnitPersonsDs.load({params:{start:0, limit:UnitPersonsPagingToolbar.pageSize,id:unitDr,type:type}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				var unitDr=units.getValue();
				if(unitDr==""){
					Ext.Msg.show({title:'ע��',msg:'��ѡ��Ԫ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				UnitPersonsDs.proxy = new Ext.data.HttpProxy({
				url: UnitPersonsUrl + '?action=list&searchField=' + UnitPersonsSearchField + '&searchValue=' + this.getValue()});
				UnitPersonsDs.load({params:{start:0, limit:UnitPersonsPagingToolbar.pageSize,id:unitDr,type:type}});
	    	}
		}
});

var UnitPersonsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: UnitPersonsDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',UnitPersonsFilterItem,'-',UnitPersonsSearchBox],
		doLoad:function(C){
					var B={},
					A=this.paramNames;
					B[A.start]=C;
					B[A.limit]=this.pageSize;
					B['id']=units.getValue();
					B['type']=type;
					if(this.fireEvent("beforechange",this,B)!==false){
						this.store.load({params:B});
					}
				}
});

var UnitPersonsMain = new Ext.grid.GridPanel({//���
		title: '��λ��Ա',
		store: UnitPersonsDs,
		cm: UnitPersonsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: ['��Ԫ���:',unitType,'-','��Ԫ:',units,'-',deptPersonsButton,'-',personsFindButton,'-',personsButton],
		bbar: UnitPersonsPagingToolbar
});
unitType.on("select",function(cmb,rec,id ){
		units.setRawValue("");
		units.setValue("");
		unitsDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
		UnitPersonsDs.load({params:{start:0, limit:0,id:cmb.getValue(),searchValue:"",type:type}});
	
});
units.on("select",function(cmb,rec,id ){
		type="";
		UnitPersonsDs.load({params:{start:0, limit:UnitPersonsPagingToolbar.pageSize,id:cmb.getValue(),type:type}});
});
