//������������Դ
var unitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
unitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.acct.acctdeptexe.csp'+'?action=CalAcctBook&str='+encodeURIComponent(Ext.getCmp('unitField').getRawValue()),method:'POST'});
});
var unitField = new Ext.form.ComboBox({
	id: 'unitField',
	fieldLabel: '��������',
	width:200,
	listWidth : 300,
	allowBlank: false,
	store: unitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ����������...',
	name: 'unitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
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
	emptyText:'ѡ���ڼ�����...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
});
var itemGrid = new dhc.herp.Grid({
        title: '���㲿��ά��',
        width: 400,
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.acctdeptexe.csp',	  
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
	        id:'rowid',
            header: 'ID',
            dataIndex: 'rowid', //acctdeptID
			edit:false,
            hidden: true
        },{
            id:'AcctBookID',
            header: '��������',
			calunit:true,
			allowBlank: false,
			width:90,
            dataIndex: 'AcctBookID',
			type:unitField
        },{
            id:'deptCode',
            header: '���ű��',
			allowBlank: false,
			width:80,
            dataIndex: 'deptCode'
        },{
            id:'deptName',
            header: '��������',
			allowBlank: false,
			width:90,
            dataIndex: 'deptName'
        },{
            id:'isValid',
            header: '�Ƿ���Ч',
			allowBlank:true,
			width:80,
			print:true,
            dataIndex: 'isValid',
            type:driectField
        }] 
});

   // itemGrid.hiddenButton(3);
	//itemGrid.hiddenButton(4);

