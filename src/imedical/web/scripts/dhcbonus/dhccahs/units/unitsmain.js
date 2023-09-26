var unitsUrl = 'dhc.ca.unitsexe.csp';



//var unitTypeProxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=listunittypes'});
//var unitTypeProxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=listunittypes&searchField=shortcut&searchValue='+Ext.getCmp('unitTypeSelecter').getRawValue(), method:'GET'});
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
/*		
var assLocDs = new Ext.data.Store({
autoLoad: true,
proxy: "",
reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['Loc_Name','Loc_Rowid','Loc_Desc','Loc_Code'])
});
assLocDs.on('beforeload', function(ds, o){
ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhccacommtab.csp?action=loclist&recname='+Ext.getCmp('assLoc').getRawValue(),method:'GET'});
});
var assLoc = new Ext.form.ComboBox({
id: 'assLoc',
fieldLabel: '�е�����',
width:150,
listWidth : 260,
allowBlank: false,
store: assLocDs,
valueField: 'Loc_Code',
displayField: 'Loc_Desc',
triggerAction: 'all',
emptyText:'ѡ��е�����...',
pageSize: 10,
minChars: 1,
value:Ext.getCmp('assLocCode').getValue(),
selectOnFocus: true,
forceSelection: true
});
*/
//����ѡ��UnitType��ComboBox//fucking piece of shit
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
			  emptyText:'ѡ��...',
	      allowBlank: false,
			  name:'unitTypeSelecter',
			  selectOnFocus: true,
				forceSelection: true 
});

//unitTypeSelecter.on("beforequery",function(o){o.query = 'query';});

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
		unitsDs.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=list&unitTypeDr='+unitTypeDr});
		unitsDs.load({params:{start:0, limit:unitsPagingToolbar.pageSize}});
};

var unitsDs = new Ext.data.Store({
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
						'phone',
						'contact',
						'remark',
						'unitTypeDr',
						'active'
		]),
    // turn on remote sorting
    remoteSort: true
});

unitsDs.setDefaultSort('rowId', 'Desc');

var unitsCm = new Ext.grid.ColumnModel([
	 	new Ext.grid.RowNumberer(),
	 	{
    		header: '����',
        dataIndex: 'code',
        width: 60,
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
        header: "�绰",
        dataIndex: 'phone',
        width: 150,
        align: 'left',
        sortable: true
    },
    {
        header: "��ϵ��",
        dataIndex: 'contact',
        width: 150,
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

//StatuTabCm.defaultSortable = true;

var addUnitsButton = new Ext.Toolbar.Button({
		text: '���',
    tooltip:'����µ�λ��Ϣ',        
    iconCls:'add',
		handler: function(){
			if(unitTypeRowid==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��λ�������ӵ�λ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				addFun(unitsDs,unitsMain,unitsPagingToolbar,unitTypeRowid);
			}
		}
});

var editUnitsButton  = new Ext.Toolbar.Button({
		text:'�޸�',        
		tooltip:'�޸�ѡ���ĵ�λ��Ϣ',
		iconCls:'remove',        
		handler: function(){
			if(unitTypeRowid==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��λ������޸ĵ�λ��Ϣ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				editFun(unitsDs,unitsMain,unitsPagingToolbar);
			}
		}
});

var delUnitsButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ���ĵ�λ',
		iconCls: 'remove',
		disabled: true,
		handler: function(){delFun(unitsDs,unitsMain,unitsPagingToolbar);}
});

var unitsSearchField = 'name';

var unitsFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: true,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '��ַ',value: 'address',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '�绰',value: 'phone',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '��ϵ��',value: 'contact',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '��ע',value: 'remark',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ч',value: 'active',checked: false,group: 'UnitsFilter',checkHandler: onUnitsItemCheck })
		]}
});

function onUnitsItemCheck(item, checked)
{
		if(checked) {
				unitsSearchField = item.value;
				unitsFilterItem.setText(item.text + ':');
		}
};

var unitsSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
							unitsDs.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=list&unitTypeDr='+unitTypeRowid});
							unitsDs.load({params:{start:0, limit:unitsPagingToolbar.pageSize}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
						unitsDs.proxy = new Ext.data.HttpProxy({
						url: unitsUrl + '?action=list&unitTypeDr='+unitTypeRowid+'&searchField=' + unitsSearchField + '&searchValue=' + this.getValue()});
	        	unitsDs.load({params:{start:0, limit:unitsPagingToolbar.pageSize}});
	    	}
		}
});

var unitsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
    store: unitsDs,
    displayInfo: true,
    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
    emptyMsg: "û������",
		buttons: [unitsFilterItem,'-',unitsSearchBox]
});

var unitsMain = new Ext.grid.GridPanel({//���
		title: '��λ���',
		store: unitsDs,
		cm: unitsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: ['��λ���',unitTypeSelecter,'-',addUnitsButton,'-',editUnitsButton,'-',delUnitsButton],
		bbar: unitsPagingToolbar
});