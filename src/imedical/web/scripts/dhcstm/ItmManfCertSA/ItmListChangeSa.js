/*更换某些项目的供货链*/
var G_ChangeSaWin = null;
function changeSa(fn)
{
	var selRows=Ext.getCmp('mcsaItmListGrid').getSelectionModel().getSelections();
	if (selRows.length==0)
	{
		Msg.info('error','没有选择任何品种!');
		return;
	}
	if (G_ChangeSaWin){
		G_ChangeSaWin.show();
		return;
	}
	var manfQuery = new Ext.ux.ComboBox({
		fieldLabel : '厂商',
		id : 'manfQuery',
		name : 'manfQuery',
		 // labelStyle: 'font-weight:bold;',
		anchor:'95%',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName',
		listeners:{
			'select':function(b){
				var manf=b.getValue();
				Ext.getCmp('saModifiedGrid').getStore().load({params:{'manf':manf,start:0,limit:saModifiedToolBar.pageSize}});
			}
		}	
	});
	
	var ds=new Ext.data.GroupingStore({
		url:'dhcstm.itmmanfcertsaaction.csp?actiontype=querySAByManf',
		sortInfo:{field: 'manf', direction: 'ASC'},
		 groupOnSort: true,
		groupField:'manf',
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results'
		},[
			{name:'RowId'}, 
			{name:'manf'},
			{name:'certNo'},
			{name:'certNoExpDate'},
			{name:'vendor1'},
			{name:'vendor1ExpDate'},
			{name:'vendor2'},
			{name:'vendor2ExpDate'},
			{name:'vendor3'},
			{name:'vendor3ExpDate'},
			{name:'active'}
		])
	});
	var saModifiedToolBar = new Ext.PagingToolbar({
		store:ds,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	
	var okButton=new Ext.Toolbar.Button({
		text:'确定',
		height: 30,
		width : 70,
		iconCls : 'page_save',
		handler:function()
		{
			var sm=Ext.getCmp('saModifiedGrid').getSelectionModel();
			var rec=sm.getSelected();
			if (rec){
				var sa=rec.get('RowId');}
			else
			{
				Msg.info("warning","请在下方选择供货链！");
				return;
			}
		
			fn(sa);
		}
	});
	var cancelButton=new Ext.Toolbar.Button({
		text:'取消',
		height: 30,
		width : 70,
		iconCls : 'page_delete',
		handler:function()
		{
			Ext.getCmp('changeSaWin').hide();
		}
	});
		
	var saModifiedGrid = new Ext.grid.GridPanel({
		id:'saModifiedGrid',
		title:'供货链列表',
		region:'center',
		store:ds,
		bbar:saModifiedToolBar,
		view: new Ext.grid.GroupingView({
			forceFit: true,
			headersDisabled :true,
				hideGroupedColumn :true,
			// custom grouping text template to display the number of items per group
			groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "条" : "条"]})'
		}),
		cm:itmManfCertSAGridCm,
		sm: new Ext.grid.CheckboxSelectionModel({
			singleSelect:true
		})
	});
	
	var changeSaWin = new Ext.Window({
		id : 'changeSaWin',
		title:'选择供货链',
		closeAction : 'hide',
		plain:true,
		tbar:[okButton,'-',cancelButton],
		id:'changeSaWin',
		modal:true,
		width:800,
		height:500,
		layout:'border',
		items:[
			{height:40,xtype:'form',frame:true,region:'north',labelAlign:'right',items:[manfQuery]},
			saModifiedGrid
		],
		listeners : {
			show : function(win){
				G_ChangeSaWin = win;
			}
		}
	});
	
	changeSaWin.show();
}