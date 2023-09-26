var KPILvelUrl = 'dhc.pa.kpilevelexe.csp';
var KPILvelProxy = new Ext.data.HttpProxy({url:KPILvelUrl+'?action=list'});


var KPILvelDs = new Ext.data.Store({
	proxy: KPILvelProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid',
			'KpiDr',
			'KPIName',
			'levelDr',
			'LevelName',
			'levelScore'
 
		]),
    remoteSort: true
});

KPILvelDs.setDefaultSort('rowid', 'DESC');


var addKPILvelButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '����µĶ���',
		iconCls: 'add',
		handler: function(){addKPILvelFun(KPILvelDs,KPILvelMain,KPILvelPagingToolbar);}
});

var editKPILvelButton  = new Ext.Toolbar.Button({
		text: '�޸�',
		tooltip: '�޸�ѡ���Ķ���',
		iconCls: 'remove',
		handler: function(){editKPILvelFun(KPILvelDs,KPILvelMain,KPILvelPagingToolbar);}
});
var delButton  = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'remove',
	handler: function(){
		var rowObj = KPILvelMain.getSelectionModel().getSelections();;
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ���Ļ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:KPILvelUrl+'?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									KPILvelDs.load({params:{start:0, limit:KPILvelPagingToolbar.pageSize}});
								}else{
									var message="ɾ������";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					}
				}
			)
		}
	}
});
var KPILvelCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: 'ָ������',
			dataIndex: 'KPIName',
			width: 200,
			align: 'left',
			sortable: true
		},
		{
			header: '�ȼ�����',
			dataIndex: 'LevelName',
			width: 200,
			align: 'left',
			sortable: true
		},
		{
			header: '����',
			dataIndex: 'levelScore',
			width: 100,
			align: 'left',
			sortable: true
		}
	]);
	
var KPILvelSearchField = 'Name';

var KPILvelFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '�ȼ�����',value: 'KPIName',checked: false,group: 'KPILvelFilter',checkHandler: onKPILvelItemCheck }),
				new Ext.menu.CheckItem({ text: 'ָ������',value: 'LevelName',checked: false,group: 'KPILvelFilter',checkHandler: onKPILvelItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'levelScore',checked: false,group: 'KPILvelFilter',checkHandler: onKPILvelItemCheck })
		]}
});

function onKPILvelItemCheck(item, checked)
{
		if(checked) {
				KPILvelSearchField = item.value;
				KPILvelFilterItem.setText(item.text + ':');
		}
};

var KPILvelSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				KPILvelDs.proxy = new Ext.data.HttpProxy({url: KPILvelUrl + '?action=list'});
				KPILvelDs.load({params:{start:0, limit:KPILvelPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				KPILvelDs.proxy = new Ext.data.HttpProxy({
				url: KPILvelUrl + '?action=list&searchField=' + KPILvelSearchField + '&searchValue=' + this.getValue()});
				KPILvelDs.load({params:{start:0, limit:KPILvelPagingToolbar.pageSize}});
	    	}
		}
});
KPILvelDs.each(function(record){
    alert(record.get('tieOff'));

});
var KPILvelPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: KPILvelDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',KPILvelFilterItem,'-',KPILvelSearchBox]
});

var KPILvelMain = new Ext.grid.EditorGridPanel({//���
		title: '�ȼ���ָ�����',
		store: KPILvelDs,
		cm: KPILvelCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		//clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addKPILvelButton,'-',delButton],
		bbar: KPILvelPagingToolbar
});


KPILvelMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
});


KPILvelDs.load({params:{start:0, limit:KPILvelPagingToolbar.pageSize}});
