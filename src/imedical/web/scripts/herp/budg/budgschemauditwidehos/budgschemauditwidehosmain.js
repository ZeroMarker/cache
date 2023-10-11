/**
*��˰�ťȨ��˵��
*1.��ť���ã�
*	�����Ȩ�ޡ���ǰ������ǵ�¼��
*2.����������
**/
var BudgSchemAuditWideHosUrl = '../csp/herp.budg.budgschemauditwidehosexe.csp';
var UserID = session['LOGON.USERID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
//������
var yearDs  = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});

yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url: commonboxUrl+'?action=year',method:'POST'});
		});

var yearField  = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '������',
	width:100,
	listWidth : 100,
	//allowBlank: false,
	store: yearDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


//�Ƿ��ǵ�ǰ����
var basriscurstepStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['0','��'],['1','��']]
});
var bsarchkresultStoreField = new Ext.form.ComboBox({
	id: 'basriscurstepStoreField',
	fieldLabel: '�Ƿ��ǵ�ǰ����',
	width:120,
	listWidth : 215,
	selectOnFocus: true,
	allowBlank: false,
	store: basriscurstepStore,
	anchor: '90%',
	// value:'key', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	// emptyText:'ѡ��ģ������...',
	mode: 'local', // ����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 15,
	selectOnFocus:true,
	forceSelection:true
});

//����״̬
var bsachkstateStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['1','�½�'],['2','�ύ'],['3','ͨ��'],['4','���']]
});
var bsachkstateStoreField = new Ext.form.ComboBox({
	id: 'bsachkstateStoreField',
	fieldLabel: '����״̬',
	width:120,
	listWidth : 215,
	selectOnFocus: true,
	allowBlank: false,
	store: bsachkstateStore,
	anchor: '90%',
	// value:'key', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	// emptyText:'ѡ��ģ������...',
	mode: 'local', // ����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 15,
	selectOnFocus:true,
	forceSelection:true
});

//���״̬
var ChkstateStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['1','�ȴ�����'],['2','ͬ��'],['3','��ͬ��']]
});
var ChkstateField = new Ext.form.ComboBox({
	id: 'Chkstate',
	fieldLabel: '���״̬',
	width:120,
	listWidth : 215,
	selectOnFocus: true,
	allowBlank: false,
	store: ChkstateStore,
	anchor: '90%',
	// value:'key', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	// emptyText:'ѡ��ģ������...',
	mode: 'local', // ����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 15,
	selectOnFocus:true,
	forceSelection:true
});
var searchButton = new Ext.Toolbar.Button({
	text: '��ѯ',
    tooltip:'��ѯ',        
    iconCls:'add',
	handler:function(){
	
	var Year=yearField.getValue();

	itemMain.load(({params:{start:0, limit:25,Year:Year,UserID:UserID}}));
	
	}
});

var itemMain = new dhc.herp.Grid({
    title: 'ȫԺ���Ԥ�����',
    //width: 400,
    region : 'north',
    atLoad : true, // �Ƿ��Զ�ˢ��
    url: 'herp.budg.budgschemauditwidehosexe.csp',
    minSize : 350,
	maxSize : 450,
	height:225,
	
	tbar:['������:',yearField,'-',searchButton],
	
    fields: [
    new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{ 
        id : 'CompName',
        header : 'ҽ�Ƶ�λ',
        width : 90,
        editable : false,
         hidden: true,
        dataIndex : 'CompName'

    },{
        id:'bsmyear',
        header: '���',
        dataIndex: 'bsmyear',
        width:80,
        update:true,
        allowBlank: true,
		editable:false,
		hidden: false
    },{
        id:'bsmcode',
        header: '�������',
        dataIndex: 'bsmcode',
        width:120,
        update:true,
        allowBlank: true,
		editable:false,
		hidden: false
    },{ 
        id:'bsmname',
        header: '��������',
        dataIndex: 'bsmname',
        width:250,
        allowBlank: true,
		editable:false,
		hidden: false
    }, {
        id:'bsmorderby',
        header: '����˳��', 
        width:100,
		//tip:true,
		//allowBlank: false,
        editable:false,
        allowBlank: true,
        dataIndex: 'bsmorderby'
		
    }, {
        id:'bidname',
        header: '�����ӦԤ����',
        width:150,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'bidname'	
		
    }, {
        id:'bmsuupschemdr',
        header: 'ǰ�÷���',
        width:100,
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'bmsuupschemdr',
        renderer : function(v, p, r) {
		return '<span style="color:blue;cursor:hand"><u>��ѯ</u></span>';									
        }
	
    }, {
        id:'bsachkstate',
        header: '����״̬',
        width:100,
		//tip:true,
		allowBlank: true,
		editable:false,
		css:'color:blue;',
		type:bsachkstateStoreField,
        dataIndex: 'bsachkstate'
		
    },{
    	id:'bsachkstep',
        header: '���Ʋ���',
        width:100,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bsachkstep'
    },{
    	id:'bcfmchkflowname',
        header: '������',
        width:100,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bcfmchkflowname'
    },{
    	id:'bsmfile',
        header: '˵���ļ�',
        width:100,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bsmfile'
    },{
    	id:'bsarstepno',
        header: '����˳���',
        width:100,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bsarstepno',
        hidden: true
        
    },{
    	id:'basriscurstep',
        header: '�Ƿ�Ϊ��ǰ����',
        width:110,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'basriscurstep',
        type:bsarchkresultStoreField
        	
    },{
    	id:'StepNO',
        header: '������������',
        width:110,   
	    editable:false,
	    update:true,
        dataIndex: 'StepNO',
        hidden:true
        	
    },{
    	id:'schemAuditDR',
        header: '������ڱ�ID',
        width:110,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    hidden: true,
        dataIndex: 'schemAuditDR'
        	
    },{
    	id:'Chkstate',
        header: '��������״̬',
        width:110,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    hidden: true,
        dataIndex: 'Chkstate',
        type:ChkstateField
        	
    }],
	
	split : true,
	collapsible : true,
	//containerScroll : true,
	xtype : 'grid',
	sm : new Ext.grid.RowSelectionModel({singleSelect : true}),
	loadMask : true,
//	viewConfig : {forceFit : true},
	
	height:230,
	trackMouseOver: true,
	stripeRows: true

});
itemMain.load(({params:{start:0, limit:25, UserID:UserID}}));

itemMain.btnAddHide();  //�������Ӱ�ť
itemMain.btnSaveHide();  //���ر��水ť
itemMain.btnResetHide();  //�������ð�ť
itemMain.btnDeleteHide(); //����ɾ����ť
itemMain.btnPrintHide();  //���ش�ӡ��ť



itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	var bsmDr='';
	var bsmName='';
	var stepno='';
	var chkstep='';
    //alert(rowIndex);
	var selectedRow = itemMain.getSelectionModel().getSelections();
	bsmDr=selectedRow[0].data['bsmcode'];
	bsmName=selectedRow[0].data['bsmname'];
	stepno=selectedRow[0].data['bsarstepno'];
	chkstep=selectedRow[0].data['bsachkstep'];
	
	var BITname=BITnameField.getValue();
	var BIDlevel=BIDlevelField.getValue();
	var BSDCode=bsdcodeField.getValue();
	var year=selectedRow[0].data['bsmyear'];
	//alert(stepno);
	itemDetail.load({params:{start:0, limit:12,Year:year,Code:bsmDr,BITName:BITname,BIDLevel:BIDlevel,BSDCode:BSDCode,Year:year}});
				
});


//����gird�ĵ�Ԫ���¼�
itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//alert(columnIndex);
	if (columnIndex == 9) {
		
		var records = itemMain.getSelectionModel().getSelections();
		var childid = records[0].get("rowid");
		//alert(childid);

		// ά������ҳ��
		ChildFun(childid);
		//connectFun(offshootID);
		
	}
	if (columnIndex == 10) {
		var records = itemMain.getSelectionModel().getSelections();
		var schemAuditDR = records[0].get("schemAuditDR");
		var schemDr =  records[0].get("rowid");
		schemastatefun(schemAuditDR,UserID,schemDr);
		
		}
});
itemMain.on('rowclick', function() {	
	var selectedRow = itemMain.getSelectionModel().getSelections();
	var iscurstep=selectedRow[0].data['basriscurstep'];
	var bsarstepno=selectedRow[0].data['bsarstepno'];  //����˳���
	var StepNO=selectedRow[0].data['StepNO'];
	var bsachkstep=selectedRow[0].data['bsachkstep'];

		if(bsachkstep==99){
		 checkButton.disable();
		 saveButton.disable();
		 }
		else if((bsarstepno=StepNO)&&(iscurstep=='1')) {
		checkButton.enable();
		saveButton.enable();
		}
		else {
		 checkButton.disable();
		 saveButton.disable();
		 }
	}
)


