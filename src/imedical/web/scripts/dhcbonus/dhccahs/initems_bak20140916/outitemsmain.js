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
			  fieldLabel:'名称',
			  store: outItemSetsDs,
			  valueField:'rowId',
			  displayField:'shortcut',
			  typeAhead:true,
			  pageSize:10,
			  minChars:1,
			  width:150,
			  listWidth:250,
			  triggerAction:'all',
			  emptyText:'选择接口项目套...',
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
	header: '接口顺序',
	dataIndex: 'order',
	width: 60,
	sortable: true
},
{
	header: '接口代码',
	dataIndex: 'itemCode',
	width: 80,
	sortable: true
},
{
	header: "接口名称",
	dataIndex: 'itemName',
	width: 150,
	sortable: true
},
{
	header: "接口备注",
	dataIndex: 'remark',
	width: 150,
	sortable: true
}
]);

var addButton = new Ext.Toolbar.Button({
		text: '添加接口',
    tooltip:'添加接口核算项目',        
    iconCls:'add',
		handler: function(){
			if(initemrowid==""){
				Ext.Msg.show({title:'注意',msg:'请选择接口项目!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				addOutFun(outItemsDs,outItemsGrid,outItemsPagingToolbar,initemrowid);
			}
		}
});

var editButton  = new Ext.Toolbar.Button({
		text:'修改接口',        
		tooltip:'修改接口核算项目',
		iconCls:'remove',        
		handler: function(){
			if(initemrowid==""){ 
				Ext.Msg.show({title:'注意',msg:'请选择接口项目!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				editOutFun(outItemsDs,outItemsGrid,outItemsPagingToolbar);
			}
		}
});

var delButton  = new Ext.Toolbar.Button({
		text:'删除接口',        
		tooltip:'删除接口核算项目',
		iconCls:'remove',       
		//disabled:true,      
		handler: function(){
			if(initemrowid==""){
				Ext.Msg.show({title:'注意',msg:'请选择接口项目!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				delOutFun(outItemsDs,outItemsGrid,outItemsPagingToolbar);
			}
		}
});

var outItemsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
	pageSize: 25,
	store: outItemsDs,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"
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
	//tbar: ['接口核算项目:',outItemSetSelecter,'-',addButton,'-',editButton,'-',delButton],
	tbar: [addButton,'-',editButton,'-',delButton],
	bbar: outItemsPagingToolbar
});

//outItemsDs.load({params:{start:0, limit:outItemsPagingToolbar.pageSize}});