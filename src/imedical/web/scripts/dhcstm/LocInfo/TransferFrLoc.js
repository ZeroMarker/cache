function setTransferFrLoc(loc,locDesc )
{
 
 var url="dhcstm.orgutil.csp?actiontype=TransferFrLoc&LocId="+loc;
 
 var frLocStore=new Ext.data.Store({
 	url:url,
 	autoLoad:true,
 	baseParams:{LocId:loc},
 	pruneModifiedRecords:true,
 	reader:new Ext.data.JsonReader(
 	{
 	   root:'rows',
		totalProperty:'results',
		id:'RowId'
 	},['RowId','frLocRowId','frLocDescription','DateFrom','DateTo','frLocDefault'])
  	
 }) ;
var frLocDefault = new Ext.grid.CheckColumn({
	header:'Ĭ�ϱ�־',
	dataIndex:'frLocDefault',
	width:60,
	sortable:true
});

 var cm=new Ext.grid.ColumnModel([{
 	header:'RowId',
 	dataIndex:'RowId',
 	align:'left',
 	width:100,
 	hidden:true
 },
{
 	header:'frLocRowId',
 	dataIndex:'frLocRowId',
 	align:'left',
 	width:100,
 	hidden:true
 },
 {
 	header:'��������',
 	dataIndex:'frLocDescription',
 	align:'left',
 	width:250,
 	 tooltip:'˫����ȥ��'
 },frLocDefault,
 {
 	header:'��ʼ����',
 	dataIndex:'DateFrom',
 	align:'left',
 	width:100,
 	hidden:true
 },
 {
 	header:'��ֹ����',
 	dataIndex:'DateTo',
 	align:'left',
 	width:100,
 	hidden:true
 }
 ]
 );
 
var savebt=new Ext.ux.Button({
	text:'����',
	iconCls : 'page_save',
	handler:function(){
		save();
	}
});

//����Ĭ�ϱ�־
function save(){
		var mr=frLocStore.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var rowId=mr[i].data["RowId"];
			var frLocdefault = mr[i].data["frLocDefault"];
			var dataStr = rowId+"^"+frLocdefault;
			if(data==""){
				data = dataStr;
			}else{
				data = data+xRowDelim()+dataStr;
			}
		}
		if(data!=""){
			Ext.Ajax.request({
				url: 'dhcstm.locinfoaction.csp?actiontype=Savedefat',
				params: {data:data},
				failure: function(result, request) {
					Msg.info("error", "������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						frLocStore.load();
					}else{
						Msg.info("error", "����ʧ��!");
					}
				},
				scope: this
			});
		}
	}

var closeWin=new Ext.Button({
	text:'�ر�',
	iconCls : 'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		window.close();
	}
});

var frLocGrid = new Ext.grid.GridPanel({
 id:'frLoc',
 title:'��ѡ...',
 //autoHeight:true,
 store:frLocStore,
 draggable:true,
 cm:cm,
 tbar : [savebt, closeWin],
 plugins:[frLocDefault],
 sm:new Ext.grid.RowSelectionModel({rowSelect:'single'}),
 loadMask:true,
 listeners:{
 	'rowdblclick':function(grid,ind){
 		var rec=grid.getSelectionModel().getSelected();
	 	var rowid=rec.get('RowId');
	 	//alert(rowid);
	 	if (rowid=='') return;
	 	Delete(rowid);		
 	}
 }
});

frLocGrid.getStore().load();

var LocFilter = new Ext.form.TextField({
    id:'LocFilter',
    fieldLabel:'����',
    allowBlank:true,
    emptyText:'����...',
    anchor:'90%',
    selectOnFocus:true
});

var FilterButton = new Ext.Toolbar.Button({
    text : '����',
    tooltip : '����',
    iconCls : 'page_gear',
    width : 70,
    height : 30,
    handler:function(){
    	var FilterDesc = Ext.getCmp("LocFilter").getValue();
		NotTransferLocConfigGrid.getStore().setBaseParam('FilterDesc',FilterDesc);
		NotTransferLocConfigGrid.getStore().load({params:{start:0,limit:PagingToolbar2.pageSize}});
    }
});

var cm2=new Ext.grid.ColumnModel([{
		header:'RowId',
		hidden:true,
		dataIndex:'RowId'
	},{
		header:'��������',
		dataIndex:'Description',
		width:260,
		tooltip:'˫����ѡ��'
	}
]);


var url2="dhcstm.orgutil.csp?actiontype=NotTransferFrLoc&LocId="+loc;
var store2 = new Ext.data.Store({
	url:url2,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	},['RowId',"Description"])
});

var PagingToolbar2 = new Ext.PagingToolbar({
    store:store2,
    pageSize:30,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}����һ�� {2} ��',
    emptyMsg:"û�м�¼"
});

var NotTransferLocConfigGrid = new Ext.grid.GridPanel({
	title:'��ѡ...',
	autoHeigth:true,
	store:store2,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	cm:cm2,
	bbar:PagingToolbar2,
	tbar:[LocFilter,FilterButton],
	listeners:{
		'rowdblclick':function(grid,ind){
			var rec=grid.getStore().getAt(ind);
			var selloc=rec.get('RowId');
			Add(loc,selloc);
		}
	}
});
NotTransferLocConfigGrid.getStore().load({params:{start:0,limit:PagingToolbar2.pageSize}});

function Add(loc,loc1){
	Ext.Ajax.request({
		url:'dhcstm.locinfoaction.csp?actiontype=addFrLoc&loc='+loc+"&frLoc="+loc1,
		success:function(){
			refresh();
			Msg.info('success','���ӳɹ�!');
		},
		failure:function(){
			Msg.info('error','����ʧ��!');
		}
	})
}

function Delete(rowid)
{
	Ext.Ajax.request({
		url:'dhcstm.locinfoaction.csp?actiontype=deleteFrLoc&rowid='+rowid,
		success:function(){
			refresh();
			Msg.info('success','ɾ���ɹ�!');
		},
		failure:function(){
			Msg.info('error','ɾ��ʧ��!');
		}	
	})
}

function refresh()
{
	frLocGrid.getStore().reload();
	NotTransferLocConfigGrid.getStore().reload();
}

var window=new Ext.Window({
	title:'ά����������'+"("+locDesc+")",
	width:680,
	height:500,
	layout:'border',
	modal:true,
	resizable:false,
	items:[{region:'west',width: 350,layout:'fit',items:frLocGrid},
		{region:'center',layout:'fit',items:NotTransferLocConfigGrid}]
})
 
window.show();
}
