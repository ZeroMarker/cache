var SchemUrl = 'dhc.pa.schemexe.csp';
var SchemProxy = new Ext.data.HttpProxy({url: SchemUrl+'?action=list'});
var KPIIndexUrl = 'dhc.pa.kpiindexexe.csp';
var KPIIndexProxy = new Ext.data.HttpProxy({url: KPIIndexUrl+'?action=kpi&start=0&limit=25'});

var SchemDs = new Ext.data.Store({
	proxy: SchemProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','parRef','code','name','shortcut','appSysDr','frequency','KPIDr','KPIName','desc','level','appSys','quency', 'computeTypeDr','computeTypeName','upschemDr','upschemName','schemFlag','schemType'
 
		]),
    remoteSort: true
});

SchemDs.setDefaultSort('rowid', 'DESC');


var KPIIndexDs = new Ext.data.Store({
	proxy:KPIIndexProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','name'
 
		]),
    remoteSort: true
});
KPIIndexDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:KPIIndexUrl+'?action=kpi&&start=0&limit=25'});
});

var SchemCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '�������',
			dataIndex: 'code',
			width: 60,
			align: 'left',
			sortable: true
		},
		{
			header: '��������',
			dataIndex: 'name',
			width: 150,
			align: 'left',
			sortable: true
		},
		{
        header: "����Ƶ��",
        dataIndex: 'frequency',
        width: 60,
        align: 'left',
        sortable: true
		},
		{
        header: "���ָ��",
        dataIndex: 'KPIName',
        width: 150,
        align: 'left',
        sortable: true
		}
		,
		{
        header: "�ϼ�����",
        dataIndex: 'upschemName',
        width: 350,
        align: 'left',
        sortable: true
		}
		,
		{
        header: "����ʽ",
        dataIndex: 'computeTypeName',
        width: 100,
        align: 'left',
        sortable: true
		}
		,
		{
        header: "��������",
        dataIndex: 'schemFlag',
        width: 60,
        align: 'left',
        sortable: true
		}
		
		
		
	]);
	
var SchemSearchField = 'name';

var SchemFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: false,group: 'SchemFilter',checkHandler: onSchemItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'SchemFilter',checkHandler: onSchemItemCheck })
		]}
});

function onSchemItemCheck(item, checked)
{
		if(checked) {
				SchemSearchField = item.value;
				SchemFilterItem.setText(item.text + ':');
		}
}

var SchemSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
		width: 100,
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
				SchemDs.proxy = new Ext.data.HttpProxy({url: SchemUrl + '?action=list'});
				SchemDs.load({params:{start:0, limit:SchemPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				SchemDs.proxy = new Ext.data.HttpProxy({
				url: SchemUrl + '?action=list&searchField=' + SchemSearchField + '&searchValue=' + encodeURIComponent(this.getValue())});
				SchemDs.load({params:{start:0, limit:SchemPagingToolbar.pageSize}});
	    	}
		}
});
SchemDs.each(function(record){
    alert(record.get('tieOff'));

});
var SchemPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize:25,
		store: SchemDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0}-{1},����{2}',
		emptyMsg: "û������",
		buttons: [SchemFilterItem,'-',SchemSearchBox]
});

var addAdjustButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '����µķ���',
		iconCls: 'add',
		handler: function(){addSchemFun(SchemDs,SchemGrid,SchemPagingToolbar);
		}
});

var copyButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '���Ʒ�����׼��',
		iconCls: 'add',
		handler: function(){copySchemFun(SchemDs,SchemGrid,SchemPagingToolbar);
		}
});

var editAdjustButton = new Ext.Toolbar.Button({
		text: '�޸�',
		tooltip: '�޸�ѡ��ķ���',
		iconCls: 'add',
		handler: function(){editSchemFun(SchemDs,SchemGrid,SchemPagingToolbar);
		}
});

var delAdjustButton = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��ѡ��ķ���',
		iconCls: 'remove',
		handler: function(){delSchemFun(SchemDs,SchemGrid,SchemPagingToolbar);
		}
});

var SchemGrid = new Ext.grid.EditorGridPanel({//���
		title: '��Ч�����趨',
		store: SchemDs,
		xtype: 'grid',
		cm: SchemCm,
		trackMouseOver: true,
		region: 'west',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		width:650,
		//clicksToEdit: 2,
		stripeRows: true, 
        tbar:[addAdjustButton,/*editAdjustButton,*/delAdjustButton,'-',copyButton],		
		bbar: SchemPagingToolbar
});


SchemGrid.on('cellclick',function(grid,rowIndex,columnIndex,e){
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
});

SchemGrid.on(
	"rowclick",
	function(grid,rowIndex,e ){
		var rowObj = grid.getSelectionModel().getSelections();
		initemrowid = rowObj[0].get("rowid");
        var url='dhc.pa.schemexe.csp?action=findkpi&schem='+initemrowid;
		detailTreeLoader.dataUrl=url+"&parent=0";	
		
		Ext.getCmp('detailReport').getNodeById("roo").reload();
		/* outItemsDs.proxy = new Ext.data.HttpProxy({url:'dhc.pa.schemexe.csp?action=findkpi&schem='+initemrowid});
		outItemsDs.load({params:{start:0, limit:inItemsPagingToolbar.pageSize}}); */
	});
SchemDs.load({params:{start:0, limit:SchemPagingToolbar.pageSize}});
