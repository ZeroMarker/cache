
var acctbookid= IsExistAcctBook();

//����ID�����б�� 
var unitDs = new Ext.data.Store({
    autoLoad:true,
    proxy:"",
    reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
unitDs.on('beforeload', function(ds, o){
    ds.proxy=new Ext.data.HttpProxy({
    url:'herp.acct.acctCurRateexe.csp'+'?action=caldept',method:'POST'});
});
var unitField = new Ext.form.ComboBox({
    id: 'unitField',
    fieldLabel: '����ID',
    width:200,
    listWidth : 300,
    allowBlank: true,
    store: unitDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText:'��ѡ�����ID...',
    name: 'unitField',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
});


//������/�ڼ�
var acctsubjField = new Ext.form.TextField({
    id: 'acctsubjField ',
    fieldLabel: '��ƿ�Ŀ',
    width:150,
    listWidth : 150,
    //allowBlank: false,
    //store: yearDs,
    //valueField: 'rowid',
    //displayField: 'name',
    triggerAction: 'all',
    emptyText:'ģ����ѯ...',
    name: 'acctsubjField ',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
});

//���ֲ�ѯ
var acctuserFieldDs = new Ext.data.Store({
    autoLoad:true,
    proxy:"",
    reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
acctuserFieldDs.on('beforeload', function(ds, o){
    ds.proxy=new Ext.data.HttpProxy({
    url:'herp.acct.acctCurRateexe.csp'+'?action=caldept',method:'POST'});
});
var acctuserField = new Ext.form.ComboBox({
    id: 'acctuserField',
    fieldLabel: '����ID',
    store: acctuserFieldDs,
    width:200,
    listWidth : 260,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText:'ģ����ѯ...',
    name: 'acctuserField',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
    
});



//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
    text: '��ѯ', 
        tooltip:'��ѯ',        
        iconCls:'find',
    handler:function(){
    
    var acctsubj=acctsubjField.getValue();
    
    var acctuser=acctuserField.getValue();
    
    itemGrid.load({
                params:{
                sortField:'',
                sortDir:'',
                start:0,
                limit:25,
                acctbookid:acctbookid,
                acctsubj:acctsubj,
                acctuser:acctuser
                }
            }); 
    
    //itemGrid.load(({params:{start:0,limit:25,acctsubj:acctsubj,acctuser:acctuser}}));
    
    }
});


//ֻ��������
var bibbrejectmoneyField = new Ext.form.TextField({
    id: 'bibbrejectmoneyField',
    //fieldLabel: 'Ԥ�������',
    width:215,
    regex : /^(-?\d+)(\.\d+)?$/,
    regexText : "ֻ����������",

    name: 'bibbrejectmoneyField',
    editable:true
});
//tbar:['������/�ڼ�:',acctsubjField,'-','����:',acctuserField,'-',findButton],
var queryPanel = new Ext.form.FormPanel({
		title: '���ֻ���ά��',
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
            	value : '������/�ڼ�',
				style:'padding:0px 10px;'
            	//width : 60
            },acctsubjField,{
           		xtype : 'displayfield',
           		value : '',
           		width : 50
           	},{
            	xtype : 'displayfield',
            	value : '����',
				style:'padding:0px 10px;'
            	//width : 60
            },acctuserField,{
           		xtype : 'displayfield',
           		value : '',
           		width : 50
           	},findButton]
        }]
});

var itemGrid = new dhc.herp.Grid({
    //title: '���ֻ��ʱ�',
    width: 400,
    //edit:false,                   //�Ƿ�ɱ༭
    //readerModel:'local',
    region: 'center',
    atLoad : true, // �Ƿ��Զ�ˢ��
    url: 'herp.acct.acctCurRateexe.csp',
    
   // tbar:['������/�ڼ�:',acctsubjField,'-','����:',acctuserField,'-',findButton],

    fields: [
//new Ext.grid.CheckboxSelectionModel({editable:false}),
    {   
        id:'acctCurRateID',
        header: '<div style="text-align:center">���ֻ���ID</div>',
        hidden: true,
        print:false,
        align: 'center',
        dataIndex: 'rowid'
 
    },{ 
        id:'acctbookid',
        header: '<div style="text-align:center">����ID</div>',
        hidden: true,
        print:false,
        align: 'center',
        dataIndex: 'bookid'
 
    },{
        id:'acctYear',
        header: '<div style="text-align:center">������</div>',
        dataIndex: 'acctYear',
        width:70,
        align: 'center',
        editable:true,
        allowBlank: false,
        hidden: false,
        type:bibbrejectmoneyField
    },{ 
        id:'acctMonth',
        header: '<div style="text-align:center">����·�</div>',
        dataIndex: 'acctMonth',
        width:70,
        align: 'center',
        editable:true,
        allowBlank: false,
        hidden: false,
        type:bibbrejectmoneyField
    }, {
        id:'acctCurID',
        header: '<div style="text-align:center">����</div>',
        //tip:true,
        allowBlank: false,
        //align: 'right',
        width:80,
        align: 'center',
        editable:true,
        dataIndex: 'acctCurID',
        type:unitField
    
    }, {
        id:'startRate',
        header: '<div style="text-align:center">�ڳ�����</div>',
        width:150,
        align: 'right',
        //align: 'center',
        allowBlank: true,
        editable:true,
        dataIndex: 'startRate',
        type:bibbrejectmoneyField
        
    }, {    
        id:'endRate',
        header: '<div style="text-align:center">��ĩ����</div>',
        width:150,
        align: 'right',
        //align: 'center',
        update:true,
        editable:true,
        allowBlank: true,
        dataIndex: 'endRate',
        type:bibbrejectmoneyField   
    },  {
        id:'averRate',
        header: '<div style="text-align:center">ƽ������</div>',
        width:150,
        align: 'right',
        //align: 'center',
        allowBlank: true,
        editable:false,
        dataIndex: 'averRate',
        type:bibbrejectmoneyField
        
    }]

});

    
 /* itemGrid.load({
        params:{
            start:0,
            limit:25,
            acctbookid:acctbookid
            }
            }); */ 

//itemGrid.btnAddHide();  //�������Ӱ�ť
itemGrid.btnResetHide();  //�������ð�ť
itemGrid.btnDeleteHide(); //����ɾ����ť
itemGrid.btnPrintHide();  //���ش�ӡ��ť



