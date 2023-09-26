var dataItemCorresUrl = 'dhc.ca.dataitemcorresexe.csp';

var dataTypeDr="";
var dataItemCorresProxy = new Ext.data.HttpProxy({url: dataItemCorresUrl + '?action=list'});

var unitTypeDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','order','code','name','shortcut','remark','active'])
});

unitTypeDs.on('beforeload',function(ds, o){
	ds.proxy = new Ext.data.HttpProxy({url:dataItemCorresUrl+'?action=listtype&searchField=shortcut&searchValue='+Ext.getCmp('unitTypeSelecter').getRawValue(), method:'GET'});
});

var unitTypeSelecter = new Ext.form.ComboBox({
	id:'unitTypeSelecter',
	fieldLabel:'����',
	store: unitTypeDs,
	valueField:'rowid',
	displayField:'shortcut',
	//typeAhead:true,
	pageSize:10,
	minChars:1,
	width:100,
	listWidth:260,
	triggerAction:'all',
	emptyText:'ѡ�����������...',
	allowBlank: false,
	name:'unitTypeSelecter',
	selectOnFocus: true,
	forceSelection: true 
});



function formatDate(value){
    return value ? value.dateFormat('Y-m-d') : '';
};
    
//�������Ӧ����Դ
var dataItemCorresDs = new Ext.data.Store({
		proxy: dataItemCorresProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowid',
			'typeDr',
			'typeName',
			'typeShortCut',
			'order',
			'itemDr',
			'itemCode',
			'itemName',
			'itemShortCut',
			'itemUnit'
		]),
    // turn on remote sorting
    remoteSort: true
});

dataItemCorresDs.setDefaultSort('Rowid', 'Desc');

var dataItemCorresCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
        header: "���",
        dataIndex: 'order',
        width: 50,
        align: 'left',
        sortable: true
    },
    {
        header: "���������",
        dataIndex: 'itemCode',
        width: 150,
        align: 'left',
        sortable: true
    },
	{
        header: "����������",
        dataIndex: 'itemName',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: "�����λ",
        dataIndex: 'itemUnit',
        width: 200,
        align: 'left',
        sortable: true
    }
	
]);

//StatuTabCm.defaultSortable = true;

var addLocButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip:'������������Ӧ��Ϣ',        
		iconCls:'add',
		handler: function(){
			if(dataTypeDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ�����������������������Ӧ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				addFun(dataItemCorresDs,dataItemCorresMain,dataItemCorresPagingToolbar,dataTypeDr);
			}
		}
});

var editLocButton  = new Ext.Toolbar.Button({
		text:'�޸����',        
		tooltip:'�޸�ѡ�����������Ӧ��Ϣ',
		iconCls:'remove',        
		handler: function(){
			if(dataTypeDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��������������޸��������Ӧ��Ϣ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				editFun(dataItemCorresDs,dataItemCorresMain,dataItemCorresPagingToolbar);
			}
		}
});

var delLocButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ�����������Ӧ',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			if(dataTypeDr==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ�������������ɾ���������Ӧ��Ϣ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				delFun(dataItemCorresDs,dataItemCorresMain,dataItemCorresPagingToolbar);
			}
		}
});

var dataItemCorresSearchField = 'itemName';
var searchField="";
var dataItemCorresFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '���',value: 'order',checked: false,group: 'LocFilter',checkHandler: onLocItemCheck }),
				new Ext.menu.CheckItem({ text: '����������',value: 'itemName',checked: true,group: 'LocFilter',checkHandler: onLocItemCheck }),
				new Ext.menu.CheckItem({ text: '�����Ԫ',value: 'itemUnit',checked: false,group: 'LocFilter',checkHandler: onLocItemCheck })
		]}
});

function onLocItemCheck(item, checked)
{
		if(checked) {
				dataItemCorresSearchField = item.value;
				dataItemCorresFilterItem.setText(item.text + ':');
		}
};

var dataItemCorresSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
					dataItemCorresDs.proxy = new Ext.data.HttpProxy({url: dataItemCorresUrl + '?action=list&searchField='+Ext.getCmp('unitTypeSelecter').getRawValue()});
					dataItemCorresDs.load({params:{start:0, limit:dataItemCorresPagingToolbar.pageSize, dataTypeDr:dataTypeDr}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
					dataItemCorresDs.proxy = new Ext.data.HttpProxy({
					url: dataItemCorresUrl + '?action=list&searchField=' + dataItemCorresSearchField + '&searchValue=' + this.getValue()});
					dataItemCorresDs.load({params:{start:0, limit:dataItemCorresPagingToolbar.pageSize, dataTypeDr:dataTypeDr}});
	    	}
		}
});

var dataItemCorresPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: dataItemCorresDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: [dataItemCorresFilterItem,'-',dataItemCorresSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['dataTypeDr']=dataTypeDr;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
});

var dataItemCorresMain = new Ext.grid.GridPanel({//���
		title: '�������Ӧ���',
		store: dataItemCorresDs,
		cm: dataItemCorresCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: ['���������',unitTypeSelecter,'-',addLocButton,'-',editLocButton,'-',delLocButton],
		bbar: dataItemCorresPagingToolbar
});
unitTypeSelecter.on("select",function(cmb,rec,id ){
	dataTypeDr=unitTypeSelecter.getValue();
	dataItemCorresDs.load({params:{start:0, limit:dataItemCorresPagingToolbar.pageSize, dataTypeDr:dataTypeDr}});
});