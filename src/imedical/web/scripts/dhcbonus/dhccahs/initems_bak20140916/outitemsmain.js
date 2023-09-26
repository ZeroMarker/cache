var outItemsUrl = 'dhc.ca.initemsexe.csp';
/////////////////////
/*
var outItemSetsDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])	
});

outItemSetsDs.on(
	'beforeload',
	function(ds, o){
		ds.proxy = new Ext.data.HttpProxy({url:outItemsUrl+'?action=listoutItemSets', method:'GET'});
	}
);

var outItemSetSelecter = new Ext.form.ComboBox({
				id:'outItemSetSelecter',
			  fieldLabel:'����',
			  store: outItemSetsDs,
			  valueField:'rowId',
			  displayField:'shortcut',
			  typeAhead:true,
			  pageSize:10,
			  minChars:1,
			  width:150,
			  listWidth:250,
			  triggerAction:'all',
			  emptyText:'ѡ��ӿ���Ŀ��...',
	      allowBlank: false,
			  //name:'outItemSetSelecter',
			  selectOnFocus: true,
				forceSelection: true 
});

outItemSetSelecter.on(
	"select",
	function(cmb,rec,id ){
		searchFun(cmb.getValue());
	}
);

var outItemSetId='';

function searchFun(dr)
{
		outItemSetId=dr;
		outItemsDs.proxy = new Ext.data.HttpProxy({url: outItemsUrl + '?action=list&outItemSetsDr='+dr});
		outItemsDs.load({params:{start:0, limit:outItemsPagingToolbar.pageSize}});
};*/
//////////////////////////
var dddddd='1||5'
outItemsDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url: outItemsUrl + '?action=listout&inItemDr='+dddddd}),
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	},
	[
		'rowId',
		'order',
		'parRef',
		'remark',
		'itemDr',
		'itemName',
		'itemCode'
	]),
	remoteSort: true
});

var outItemCm = new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
	header: '�ӿ�˳��',
	dataIndex: 'order',
	width: 60,
	sortable: true
},
{
	header: '�ӿڴ���',
	dataIndex: 'itemCode',
	width: 80,
	sortable: true
},
{
	header: "�ӿ�����",
	dataIndex: 'itemName',
	width: 150,
	sortable: true
},
{
	header: "�ӿڱ�ע",
	dataIndex: 'remark',
	width: 150,
	sortable: true
}
]);

var addButton = new Ext.Toolbar.Button({
		text: '��ӽӿ�',
    tooltip:'��ӽӿں�����Ŀ',        
    iconCls:'add',
		handler: function(){
			if(initemrowid==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��ӿ���Ŀ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				addOutFun(outItemsDs,outItemsGrid,outItemsPagingToolbar,initemrowid);
			}
		}
});

var editButton  = new Ext.Toolbar.Button({
		text:'�޸Ľӿ�',        
		tooltip:'�޸Ľӿں�����Ŀ',
		iconCls:'remove',        
		handler: function(){
			if(initemrowid==""){ 
				Ext.Msg.show({title:'ע��',msg:'��ѡ��ӿ���Ŀ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				editOutFun(outItemsDs,outItemsGrid,outItemsPagingToolbar);
			}
		}
});

var delButton  = new Ext.Toolbar.Button({
		text:'ɾ���ӿ�',        
		tooltip:'ɾ���ӿں�����Ŀ',
		iconCls:'remove',       
		//disabled:true,      
		handler: function(){
			if(initemrowid==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��ӿ���Ŀ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				delOutFun(outItemsDs,outItemsGrid,outItemsPagingToolbar);
			}
		}
});

var outItemsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
	pageSize: 25,
	store: outItemsDs,
	displayInfo: true,
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������"
});

var outItemsGrid = new Ext.grid.GridPanel({
	region: 'center',
	xtype: 'grid',
	store: outItemsDs,
	cm: outItemCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	//tbar: ['�ӿں�����Ŀ:',outItemSetSelecter,'-',addButton,'-',editButton,'-',delButton],
	tbar: [addButton,'-',editButton,'-',delButton],
	bbar: outItemsPagingToolbar
});

//outItemsDs.load({params:{start:0, limit:outItemsPagingToolbar.pageSize}});