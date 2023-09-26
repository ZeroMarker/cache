/*����ĳЩ��Ŀ�Ĺ�����*/
var G_ChangeSaWin = null;
function changeSa(fn)
{
	var selRows=Ext.getCmp('mcsaItmListGrid').getSelectionModel().getSelections();
	if (selRows.length==0)
	{
		Msg.info('error','û��ѡ���κ�Ʒ��!');
		return;
	}
	if (G_ChangeSaWin){
		G_ChangeSaWin.show();
		return;
	}
	var manfQuery = new Ext.ux.ComboBox({
		fieldLabel : '����',
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
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
	
	var okButton=new Ext.Toolbar.Button({
		text:'ȷ��',
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
				Msg.info("warning","�����·�ѡ�񹩻�����");
				return;
			}
		
			fn(sa);
		}
	});
	var cancelButton=new Ext.Toolbar.Button({
		text:'ȡ��',
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
		title:'�������б�',
		region:'center',
		store:ds,
		bbar:saModifiedToolBar,
		view: new Ext.grid.GroupingView({
			forceFit: true,
			headersDisabled :true,
				hideGroupedColumn :true,
			// custom grouping text template to display the number of items per group
			groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "��" : "��"]})'
		}),
		cm:itmManfCertSAGridCm,
		sm: new Ext.grid.CheckboxSelectionModel({
			singleSelect:true
		})
	});
	
	var changeSaWin = new Ext.Window({
		id : 'changeSaWin',
		title:'ѡ�񹩻���',
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