
var BudgProInquiryNEUrl = '../csp/herp.budg.budgproinquiryneexe.csp';

var UserID = session['LOGON.USERID'];


////Ԥ��������
//var BIDNameDs = new Ext.data.Store({
//	autoLoad:true,
//	proxy:"",
//	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['bitcode','name'])
//});
//
//BIDNameDs.on('beforeload', function(ds, o){
//	ds.proxy=new Ext.data.HttpProxy({
//	
//		url: BudgProAdditionalAuditDetailUrl+'?action=bidnamelist',method:'POST'})
//		});
//
//var BIDNameField = new Ext.form.ComboBox({
//	id: 'BIDNameField',
//	fieldLabel: 'Ԥ��������',
//	width:120,
//	listWidth : 245,
//	// allowBlank: false,
//	store: BIDNameDs,
//	valueField: 'bitcode',
//	displayField: 'name',
//	triggerAction: 'all',
//	emptyText:'Ԥ��������...',
//	name: 'BIDNameField',
//	minChars: 1,
//	pageSize: 10,
//	selectOnFocus:true,
//	columnWidth:.15,
//	forceSelection:'true',
//	editable:true
//});

////�����Ԥ��
//var bfplanvalueField = new Ext.form.NumberField({
//	id: 'bfplanvalueField',
//	//fieldLabel: '�����Ԥ��',
//	width:215,
//	listWidth : 215,
//	name: 'bfplanvalueField',
//	minChars: 1,
//	pageSize: 10,
//	selectOnFocus:true,
//	forceSelection:'true',
//	editable:true
//});

	
var itemNE = new dhc.herp.Gridwolf({
    title: '',
    region : 'west',
    width:300,
    layout:"fit",
	split : true,
	collapsible : true,
	containerScroll : true,
	xtype : 'grid',
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
//	viewConfig : {
//		forceFit : true
//	},		
	loadMask: true,
	atLoad: true,
	height : 250,
	trackMouseOver: true,
	stripeRows: true,

    atLoad : true, // �Ƿ��Զ�ˢ��
    url: 'herp.budg.budgproinquiryneexe.csp',
    
    tbar:[],
    fields: [
//       new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'bpitemcode',
        header: 'Ԥ�������',
        dataIndex: 'bpitemcode',
        width:100,
        update:true,
        allowBlank: true,
		editable:false
    },{ 
        id:'bidlevel',
        header: 'Ԥ�����',
        dataIndex: 'bidlevel',
        width:100,
        allowBlank: true,
		editable:false,
		hidden: true
    }, {
        id:'bidname',
        header: 'Ԥ��������',
        width:250,
        editable:false,
        allowBlank: true,
        dataIndex: 'bidname'
		
    }, {
        id:'bidislast',
        header: '�Ƿ�ĩ��',
        width:150,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'bidislast',
        hidden: true
		
    }, {
        id:'bpbudgvalue',
        header: 'Ԥ����',
        align:'right',
        width:120,
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'bpbudgvalue'
    }
	]
//	,
//	viewConfig : {
//		forceFit : true
//	}
});

//itemDetail.btnAddHide();  //�������Ӱ�ť
//itemDetail.btnSaveHide();  //���ر��水ť
//itemDetail.btnResetHide();  //�������ð�ť
//itemDetail.btnDeleteHide(); //����ɾ����ť
//itemDetail.btnPrintHide();  //���ش�ӡ��ť







