var inItemsUrl = 'dhc.ca.initemsexe.csp';

var inItemSetsDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])	
});

inItemSetsDs.on(
	'beforeload',
	function(ds, o){
		ds.proxy = new Ext.data.HttpProxy({url:inItemsUrl+'?action=listInItemSets', method:'GET'});
	}
);

var inItemSetSelecter = new Ext.form.ComboBox({
				id:'inItemSetSelecter',
			  fieldLabel:'����',
			  store: inItemSetsDs,
			  valueField:'rowId',
			  displayField:'shortcut',
			  typeAhead:true,
			  pageSize:10,
			  minChars:1,
			  width:120,
			  listWidth:250,
			  triggerAction:'all',
			  emptyText:'ѡ��ӿ���Ŀ��...',
	      allowBlank: false,
			  //name:'inItemSetSelecter',
			  selectOnFocus: true,
				forceSelection: true 
});

inItemSetSelecter.on(
	"select",
	function(cmb,rec,id ){
		searchFun(cmb.getValue());
		outItemsDs.load({params:{start:0, limit:0}});
	}
);

var inItemSetId='';

function searchFun(dr)
{
		inItemSetId=dr;
		inItemsDs.proxy = new Ext.data.HttpProxy({url: inItemsUrl + '?action=list&inItemSetsDr='+dr});
		inItemsDs.load({params:{start:0, limit:inItemsPagingToolbar.pageSize}});
};

var inItemsDs = new Ext.data.Store({
	proxy: '',
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	},
	[
		'rowId',
		'order',
		'parRef',
		'itemDr',
		'itemName',
		'itemCode'
	]),
	remoteSort: true
});

inItemsDs.setDefaultSort('id', 'Desc');
var deptLevelSetsCm = new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
	header: '˳��',
	dataIndex: 'order',
	width: 20,
	sortable: true
},
{
	header: '����',
	dataIndex: 'itemCode',
	width: 50,
	sortable: true
},
{
	header: "����",
	dataIndex: 'itemName',
	width: 100,
	sortable: true
}
]);

var addButton = new Ext.Toolbar.Button({
		text: '���',
    tooltip:'��Ӻ�����Ŀ',        
    iconCls:'add',
		handler: function(){
			if(inItemSetId==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��ӿ���Ŀ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				addFun(inItemsDs,inItemsGrid,inItemsPagingToolbar,inItemSetId);
			}
		}
});

var remainButton = new Ext.Toolbar.Button({
		text: '�鿴ʣ��',
    tooltip:'�鿴ʣ�������Ŀ',        
    iconCls:'add',
		handler: function(){
			if(inItemSetId==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��ӿ���Ŀ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				remainFun(inItemsDs,inItemsGrid,inItemsPagingToolbar,inItemSetId);
			}
		}
});

var editButton  = new Ext.Toolbar.Button({
		text:'�޸�',        
		tooltip:'�޸ĺ�����Ŀ',
		iconCls:'remove',        
		handler: function(){
			if(inItemSetId==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��ӿ���Ŀ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				editFun(inItemsDs,inItemsGrid,inItemsPagingToolbar);
			}
		}
});

var delButton  = new Ext.Toolbar.Button({
		text:'ɾ��',        
		tooltip:'ɾ��������Ŀ',
		iconCls:'remove',    
		//disabled:true,     
		handler: function(){
			if(inItemSetId==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��ӿ���Ŀ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				delFun(inItemsDs,inItemsGrid,inItemsPagingToolbar);
			}
		}
});

var unittypesSearchField = 'itemName';

var unittypesFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '˳��',value: 'order',checked: false,group: 'UnittypesFilter',checkHandler: onUnittypesItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'itemCode',checked: false,group: 'UnittypesFilter',checkHandler: onUnittypesItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'itemName',checked: true,group: 'UnittypesFilter',checkHandler: onUnittypesItemCheck })
		]}
});

function onUnittypesItemCheck(item, checked)
{
		if(checked) {
				unittypesSearchField = item.value;
				unittypesFilterItem.setText(item.text + ':');
		}
};

var unittypesSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
							inItemsDs.proxy = new Ext.data.HttpProxy({url: inItemsUrl + '?action=list&inItemSetsDr='+inItemSetId});
							inItemsDs.load({params:{start:0, limit:inItemsPagingToolbar.pageSize}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
						inItemsDs.proxy = new Ext.data.HttpProxy({
						url: inItemsUrl + '?action=list&searchField=' + unittypesSearchField + '&searchValue=' + this.getValue()+'&inItemSetsDr='+inItemSetId});
	        	inItemsDs.load({params:{start:0, limit:inItemsPagingToolbar.pageSize}});
	    	}
		}
});

var twobbar=new Ext.Toolbar({   
     items:[unittypesFilterItem,'-',unittypesSearchBox]
});   

var inItemsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
	pageSize: 25,
	store: inItemsDs,
	displayInfo: true,
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������"
	//buttons: ['-',unittypesFilterItem,'-',unittypesSearchBox]
});

var inItemsGrid = new Ext.grid.GridPanel({
	region: 'west',
	xtype: 'grid',
	width:470,
	store: inItemsDs,
	cm: deptLevelSetsCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar: ['�ӿ���Ŀ��:',inItemSetSelecter,'-',remainButton],
	bbar: inItemsPagingToolbar,
	listeners:{   
               'render': function(){   
                    twobbar.render(this.bbar);
                }   
            }   
});

inItemsGrid.on(
	"rowclick",
	function(grid,rowIndex,e ){
		var rowObj = grid.getSelections();
		initemrowid = rowObj[0].get("rowId");		
		outItemsDs.proxy = new Ext.data.HttpProxy({url: outItemsUrl + '?action=listout&inItemDr='+initemrowid});
		outItemsDs.load({params:{start:0, limit:inItemsPagingToolbar.pageSize}});
	}
);