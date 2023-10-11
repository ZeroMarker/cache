//creator����ΰ
//date:2013��9��6��10:55:41
var userAcctBookUrl = '../csp/herp.acct.useracctbookexe.csp';
//AcctBook����Դ���ڲ�ѯ
var AcctBookDs  = new Ext.data.Store({
    autoLoad:true,
    proxy:"",
    reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

AcctBookDs.on('beforeload', function(ds, o){
    ds.proxy=new Ext.data.HttpProxy({
    
        url:userAcctBookUrl+'?action=AcctBooklist',method:'POST'})
        });

var AcctBookField  = new Ext.form.ComboBox({
    id: 'AcctBookField',
    fieldLabel: '��λ����',
    width:200,
    listWidth : 200,
    //allowBlank: false,
    store: AcctBookDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText:'��ѡ��λ����...',
    name: 'AcctBookField',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
});
//AcctBook����Դ����grid��������
var gridAcctBookDs  = new Ext.data.Store({
    autoLoad:true,
    proxy:"",
    reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

gridAcctBookDs.on('beforeload', function(ds, o){
    ds.proxy=new Ext.data.HttpProxy({
    
        url:userAcctBookUrl+'?action=AcctBooklist',method:'POST'})
        });

var gridAcctBookField  = new Ext.form.ComboBox({
    id: 'gridAcctBookField',
    fieldLabel: '��λ����',
    width:200,
    listWidth : 200,
    //allowBlank: false,
    store: gridAcctBookDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText:'��ѡ��λ����...',
    name: 'gridAcctBookField',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
});
//����û�����Դ����grid����ʱ��ѯ�û�
var acctUserDs  = new Ext.data.Store({
    autoLoad:true,
    proxy:"",
    reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

acctUserDs.on('beforeload', function(ds, o){
    ds.proxy=new Ext.data.HttpProxy({
    
        url:userAcctBookUrl+'?action=acctUserlist',method:'POST'})
        });

var acctUserField  = new Ext.form.ComboBox({
    id: 'acctUserField',
    fieldLabel: '����û�',
    width:120,
    listWidth : 245,
    //allowBlank: false,
    store: acctUserDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText:'��ѡ�����û�...',
    name: 'acctUserField',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
});
//�û�����Դ�����ڲ�ѯʱ������
var maybeacctUserField = new Ext.form.TextField({
    id: 'maybeacctUserField',
    fieldLabel: '����û�',
    width:145,
    listWidth : 245,
    //valueField: 'rowid',
    //displayField: 'name',
    triggerAction: 'all',
    emptyText:'ģ����ѯ...',
    name: 'maybeacctUserField',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
});
var findButton = new Ext.Toolbar.Button({
    text: '��ѯ',
    tooltip:'��ѯ',        
    iconCls:'find',
    handler:function(){
    
    var AcctBook=AcctBookField.getValue();
    var acctUser=maybeacctUserField.getValue();
    
    itemGrid.load(({params:{start:InDeptSetsPagingToolbar.cursor, limit:25,AcctBook:AcctBook,acctUser:acctUser}}));
    
    }
});
//�Ƿ�ǰ����
var driectStore = new Ext.data.SimpleStore({
    fields:['key','keyValue'],
    data:[['0','��'],['1','��']]
});
var driectField = new Ext.form.ComboBox({
    id: 'driectField',
    fieldLabel: '�Ƿ�ǰ����',
    width:100,
    listWidth : 130,
    selectOnFocus: true,
    allowBlank: false,
    store: driectStore,
    //anchor: '90%',
    valueNotFoundText:'',
    displayField: 'keyValue',
    valueField: 'key',
    triggerAction: 'all',
    //emptyText:'ѡ���ڼ�����...',
    mode: 'local', //����ģʽ
    editable:true,
    pageSize: 10,
    minChars: 1,
    selectOnFocus:true,
    forceSelection:true
});

var queryPanel = new Ext.form.FormPanel({
		title: '����Ȩ��ά��',
		iconCls:'maintain',
		height: 70,
		width: 400,
		region: 'north',
		frame: true,
		labelWidth: 140,
		// labelAlign:'right',
		// autoHeight:true,
		defaults: {
			bodyStyle: 'padding:5px'
		},
		items: [{
            xtype : 'panel',
            layout : 'column',
            items : [{
            	xtype : 'displayfield',
            	value : '��λ����',
            	width : 60
            },AcctBookField,{
           		xtype : 'displayfield',
           		value : '',
           		style : 'padding-top:3px;',
           		width : 50
           	},{
           		xtype : 'displayfield',
           		value : '����û�',
           		width : 60
           	},maybeacctUserField,{
           		xtype : 'displayfield',
           		value : '',
           		style : 'padding-top:3px;',
           		width : 50
           	},findButton]
        }]
});

var itemGrid = new dhc.herp.Grid({      
        width: 400,
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.useracctbookexe.csp',    
        atLoad : true, // �Ƿ��Զ�ˢ��
        loadmask:true,
        fields: [{
            id:'rowid',
            header: 'ID',
            dataIndex: 'rowid', //acctdeptID
            edit:false,
            editable:false,
            hidden: true
        },{
            id:'AcctBookID',
            header: '<div style="text-align:center">��λ����</div>',
            allowBlank: false,
            width:200,
            dataIndex: 'AcctBookID',    
            type:gridAcctBookField  
        },{
            id:'acctUserID',
            header: '<div style="text-align:center">����û�ID</div>',
            allowBlank: true,
            width:120,
            dataIndex: 'acctUserID',
            hidden: true
        },{
            id:'acctUserName',
            header: '<div style="text-align:center">����û�</div>',
            allowBlank: false,
            width:120,
            dataIndex: 'acctUserName',
            type:acctUserField
        },{
            id:'isCurrAcct',
            header: '<div style="text-align:center">�Ƿ�ǰ����</div>',
            align:'center',
            allowBlank: true,
            width:110,
            editable:false,
            emptyText:'Ĭ��Ϊ��',
            dataIndex: 'isCurrAcct',
            type:driectField
        }] 
});
var InDeptSetsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
        pageSize: 25,
        store: itemGrid,
        displayInfo: true,
        displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
        emptyMsg: "û������"//,
        //buttons: ['-',InDeptSetsFilterItem,'-',InDeptSetsSearchBox]
});

    //itemGrid.hiddenButton(3);
    //itemGrid.hiddenButton(4);
    itemGrid.btnResetHide()     //�������ð�ť
    itemGrid.btnPrintHide()     //���ش�ӡ��ť
