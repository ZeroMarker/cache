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
			  fieldLabel:'名称',
			  store: inItemSetsDs,
			  valueField:'rowId',
			  displayField:'shortcut',
			  typeAhead:true,
			  pageSize:10,
			  minChars:1,
			  width:120,
			  listWidth:250,
			  triggerAction:'all',
			  emptyText:'选择接口项目套...',
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
	header: '顺序',
	dataIndex: 'order',
	width: 20,
	sortable: true
},
{
	header: '代码',
	dataIndex: 'itemCode',
	width: 50,
	sortable: true
},
{
	header: "名称",
	dataIndex: 'itemName',
	width: 100,
	sortable: true
}
]);

var addButton = new Ext.Toolbar.Button({
		text: '添加',
    tooltip:'添加核算项目',        
    iconCls:'add',
		handler: function(){
			if(inItemSetId==""){
				Ext.Msg.show({title:'注意',msg:'请选择接口项目套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				addFun(inItemsDs,inItemsGrid,inItemsPagingToolbar,inItemSetId);
			}
		}
});

var remainButton = new Ext.Toolbar.Button({
		text: '查看剩余',
    tooltip:'查看剩余核算项目',        
    iconCls:'add',
		handler: function(){
			if(inItemSetId==""){
				Ext.Msg.show({title:'注意',msg:'请选择接口项目套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				remainFun(inItemsDs,inItemsGrid,inItemsPagingToolbar,inItemSetId);
			}
		}
});

var editButton  = new Ext.Toolbar.Button({
		text:'修改',        
		tooltip:'修改核算项目',
		iconCls:'remove',        
		handler: function(){
			if(inItemSetId==""){
				Ext.Msg.show({title:'注意',msg:'请选择接口项目套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				editFun(inItemsDs,inItemsGrid,inItemsPagingToolbar);
			}
		}
});

var delButton  = new Ext.Toolbar.Button({
		text:'删除',        
		tooltip:'删除核算项目',
		iconCls:'remove',    
		//disabled:true,     
		handler: function(){
			if(inItemSetId==""){
				Ext.Msg.show({title:'注意',msg:'请选择接口项目套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
			else
			{
				delFun(inItemsDs,inItemsGrid,inItemsPagingToolbar);
			}
		}
});

var unittypesSearchField = 'itemName';

var unittypesFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '顺序',value: 'order',checked: false,group: 'UnittypesFilter',checkHandler: onUnittypesItemCheck }),
				new Ext.menu.CheckItem({ text: '代码',value: 'itemCode',checked: false,group: 'UnittypesFilter',checkHandler: onUnittypesItemCheck }),
				new Ext.menu.CheckItem({ text: '名称',value: 'itemName',checked: true,group: 'UnittypesFilter',checkHandler: onUnittypesItemCheck })
		]}
});

function onUnittypesItemCheck(item, checked)
{
		if(checked) {
				unittypesSearchField = item.value;
				unittypesFilterItem.setText(item.text + ':');
		}
};

var unittypesSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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

var inItemsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
	pageSize: 25,
	store: inItemsDs,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"
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
	tbar: ['接口项目套:',inItemSetSelecter,'-',remainButton],
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