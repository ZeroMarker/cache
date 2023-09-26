var unittypesUrl = 'dhc.ca.accperiodexe.csp';

var itemsE = new Array();                  
itemsE[0] = {                             
	xtype: 'textfield',                    
  labelName: '代码',                     
  allowBlank: false,                     
  emptyText: '核算区间代码...',          
  name: 'code',                          
  anchor: '90%'                          
};                                       
itemsE[1] = {                            
	xtype: 'textfield',                    
  labelName: '名称',                     
  allowBlank: false,     
  initSearchField: true,           //for SearchField     
  emptyText: '核算区间名称...',          
  name: 'name',                          
  anchor: '90%'                          
};                                                                                                                 
itemsE[2] = {                            
	xtype: 'checkbox',                     
	labelName: '有效',                     
	name:'active' ,                        
	ignoreAdd:true                         
};                                       

var unittypesDs = getDataStore(unittypesUrl,itemsE);//return Ext.data.Store
var unittypesCm = getColumnModel(itemsE);//return Ext.grid.ColumnModel

var unittypesPagingToolbar = new Ext.ux.wyyPagingToolbar({
			wyyDataStore : unittypesDs,
			wyyFilterSearchBox : new getFilterSearchBox(itemsE,unittypesUrl, unittypesDs )
		});


var addUnittypesButton = new Ext.ux.wyyAddBtn({
			wyyItemsArray : itemsE,
			wyyWinTitle:'添加核算区间信息',
			wyyUrl:unittypesUrl+'?action=add',
			wyyDataStore:unittypesDs
		});

var editUnittypesButton = new Ext.ux.wyyEditBtn({
			wyyItemsArray : itemsE,
			wyyWinTitle:'修改选定的核算区间',
			wyyUrl:unittypesUrl+'?action=edit',
			wyyDataStore:unittypesDs,
			wyyPageingToolbar:unittypesPagingToolbar
		});


var delUnittypesButton = new Ext.ux.wyyDelBtn ({
			wyyUrl:unittypesUrl+'?action=del',
			wyyDataStore : unittypesDs,
			wyyPageingToolbar : unittypesPagingToolbar
		});

var unittypesMain = new Ext.grid.GridPanel({// 表格
	title : '核算区间码表',
	store : unittypesDs,
	cm : unittypesCm,
	trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	loadMask : true,
	tbar : [addUnittypesButton, '-', editUnittypesButton, '-',
			delUnittypesButton],
	bbar : unittypesPagingToolbar
});

unittypesDs.load({
			params : {
				start : 0,
				limit : unittypesPagingToolbar.pageSize
			}
		});

unittypesMain.on('click',function(e){
		editUnittypesButton.wyyGridPanel = this;
		delUnittypesButton.wyyGridPanel = this;
	});