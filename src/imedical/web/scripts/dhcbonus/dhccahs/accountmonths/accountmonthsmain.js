var AccountMonthsUrl = 'dhc.ca.accountmonthsexe.csp';
var AccountMonthsProxy = new Ext.data.HttpProxy({url: AccountMonthsUrl + '?action=list'});

function formatDate(value){
	//alert(value);
	return value?value.dateFormat('Y-m-d'):'';
};

var AccountMonthsDs = new Ext.data.Store({
	proxy: AccountMonthsProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid',
			'code',
			'name',
			'desc',
			{name:'start',type:'date',dateFormat:'Y-m-d'},
			{name:'end',type:'date',dateFormat:'Y-m-d'},
			'dataFinish',
			'treatFinish',
			'tieOff',
			'remark',
			////wyy
			{name:'acc',defaultValue:'<font color=blue>�༭����</font>'},
			{name:'accadd',defaultValue:'<font color=blue>ѡ���·�</font>'}
			////
		]),
    // turn on remote sorting
    remoteSort: true
});

AccountMonthsDs.setDefaultSort('rowid', 'DESC');

var AccountMonthsCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '����',
			dataIndex: 'code',
			width: 60,
			align: 'left',
			sortable: true
		},
		{
			header: '����',
			dataIndex: 'name',
			width: 200,
			align: 'left',
			sortable: true
		},
		{
			header: "��ʼ����",
			dataIndex: 'start',
			renderer:formatDate,
			align: 'left',
			width: 90,
			sortable: true
		},
		{
			header: "��ֹ����",
			dataIndex: 'end',
			renderer:formatDate,
			align: 'left',
			width: 90,
			sortable: true
		},
		{
			header: '�����־',
			dataIndex: 'dataFinish',
			width: 60,
			sortable: true,
			renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td'; 
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
		},
		{
			header: '�ɱ���־',
			dataIndex: 'treatFinish',
			width: 60,
			sortable: true,
			renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td'; 
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
		},
		{
			header: "������־",
			dataIndex: 'tieOff',
			width: 60,
			sortable: true,
			renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td'; 
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
		},
		{
			header: '��ע',
			dataIndex: 'remark',
			width: 60,
			align: 'left',
			sortable: true
		},
		////wyy
		{
			header: '�������',
			dataIndex: 'acc',
			width: 60,
			align: 'left'
		}/*zjw 20160808,
		{
			header: '���䵼��',
			hidden:true,
			dataIndex: 'accadd',
			width: 60,
			align: 'left'
		}*/
		////
	]);

var addAccountMonthsButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '����µĺ�����',        
		iconCls: 'add',
		handler: function(){addFun(AccountMonthsDs,AccountMonthsMain,AccountMonthsPagingToolbar);}
});

var editAccountMonthsButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		tooltip: '�޸�ѡ���ĺ�����',
		iconCls: 'remove',
		handler: function(){editFun(AccountMonthsDs,AccountMonthsMain,AccountMonthsPagingToolbar);}
});

var delAccountMonthsButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ���ĺ�����',
		iconCls: 'remove',
		disabled: true,
		handler: function(){delFun(AccountMonthsDs,AccountMonthsMain,AccountMonthsPagingToolbar);}
});

var AccountMonthsSearchField = 'Name';

var AccountMonthsFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'AccountMonthsFilter',checkHandler: onAccountMonthsItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: true,group: 'AccountMonthsFilter',checkHandler: onAccountMonthsItemCheck }),
				//new Ext.menu.CheckItem({ text: '��ʼ����',value: 'start',checked: false,group: 'AccountMonthsFilter',checkHandler: onAccountMonthsItemCheck }),
				//new Ext.menu.CheckItem({ text: '��������',value: 'end',checked: false,group: 'AccountMonthsFilter',checkHandler: onAccountMonthsItemCheck }),
				new Ext.menu.CheckItem({ text: '��ע',value: 'remark',checked: false,group: 'AccountMonthsFilter',checkHandler: onAccountMonthsItemCheck })
		]}
});

function onAccountMonthsItemCheck(item, checked)
{
		if(checked) {
				AccountMonthsSearchField = item.value;
				AccountMonthsFilterItem.setText(item.text + ':');
		}
};

var AccountMonthsSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				AccountMonthsDs.proxy = new Ext.data.HttpProxy({url: AccountMonthsUrl + '?action=list'});
				AccountMonthsDs.load({params:{start:0, limit:AccountMonthsPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				AccountMonthsDs.proxy = new Ext.data.HttpProxy({
				url: AccountMonthsUrl + '?action=list&searchField=' + AccountMonthsSearchField + '&searchValue=' + this.getValue()});
				AccountMonthsDs.load({params:{start:0, limit:AccountMonthsPagingToolbar.pageSize}});
	    	}
		}
});

var AccountMonthsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: AccountMonthsDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',AccountMonthsFilterItem,'-',AccountMonthsSearchBox]
});

var AccountMonthsMain = new Ext.grid.GridPanel({//���
		title: '������ά��',
		store: AccountMonthsDs,
		cm: AccountMonthsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: [addAccountMonthsButton,'-',editAccountMonthsButton,'-'],
		bbar: AccountMonthsPagingToolbar
});

////wyy
AccountMonthsMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
});
////

AccountMonthsDs.load({params:{start:0, limit:AccountMonthsPagingToolbar.pageSize}});