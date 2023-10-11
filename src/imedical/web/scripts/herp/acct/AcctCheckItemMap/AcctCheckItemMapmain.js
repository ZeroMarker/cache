var AcctCheckItem = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

AcctCheckItem.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctcheckitemmapexe.csp?action=AcctCheckItemList',
						method : 'POST'
					});
		});

var AcctCheckItemCombo = new Ext.form.ComboBox({
			fieldLabel : '���������Ŀ',
			store : AcctCheckItem,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
//SysBusiModuleCode
var SysBusiModule = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'name'])
});

SysBusiModule.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.acct.acctcheckitemmapexe.csp?action=SysBusiModuleList',
				method : 'POST'
			});
});

var SysBusiModuleCombo = new Ext.form.ComboBox({
	fieldLabel : 'ϵͳҵ��',
	store : SysBusiModule,
	displayField : 'name',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 100,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});
var itemGrid = new dhc.herp.Grid({
        title: '������Ŀ�ӿ�����ά��',
        width: 400,
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.acctcheckitemmapexe.csp',	  
		//tbar:delButton,
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'AcctCheckItemID',
            header: '���������',
			width:200,
            dataIndex: 'AcctCheckItemID',
            hidden: false,
            type:AcctCheckItemCombo
        },{
            id:'code',
            header: '��Ŀ����',
			allowBlank: false,
			width:200,
            dataIndex: 'code'
        },{
            id:'name',
            header: '��Ŀ����',
			allowBlank: false,
			width:200,
            dataIndex: 'name'
        },{
            id:'BusiModuleCode',
            header: 'ϵͳҵ��',
			width:200,
            dataIndex: 'BusiModuleCode',
            type:SysBusiModuleCombo,
            hidden: false
        }] 
});

    itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);
