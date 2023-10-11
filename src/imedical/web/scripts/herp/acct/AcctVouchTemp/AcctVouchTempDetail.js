
var userdr = session['LOGON.USERID'];
var EnglishName = new Ext.form.TextField({
	allowBlank : false,	
	anchor: '95%',
	selectOnFocus:'true'
             
});

///*************************����ʽ�����********************************///
		
//��ȡ�ƿ�Ŀ����ʶ
			var deptDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
			});
			
			
			deptDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:'herp.acct.acctsubjvindicmainexe.csp'+'?action=GetSubjType&str='+encodeURIComponent(Ext.getCmp('dCodeField').getRawValue

()),method:'POST'});
			});
			
			var dCodeField = new Ext.form.ComboBox({
				id: 'dCodeField',
				fieldLabel: '��Ŀ����ʶ',
				width:180,
				listWidth : 300,
				allowBlank: false,
				store: deptDs,
				valueField: 'code',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'ѡ��...',
				name: 'dCodeField',
				minChars: 1,
				pageSize: 10,
				anchor: '95%',
				selectOnFocus:true,
				forceSelection:'true',
				editable:true
			});



//��Ŀ����
var BSMnameDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

BSMnameDs.on('beforeload', function(ds, o){
  
	 var year =yearCombo.getValue();

          if(!year) 
          {
         	Ext.Msg.show({title:'ע��',msg:'����ѡ����ȣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
         	return;
          }
});


var adjustnumber = new Ext.form.ComboBox({
	id: 'adjustnumber',
	fieldLabel: '�������',
	width:120,
	listWidth : 245,
	// allowBlank: false,
	store: BSMnameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'����ѡ�����....',
	name: 'adjustnumber',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.15,
	forceSelection:'true',
	editable:true
});



// ��Ŀ����///////////////////////////////////
var smYearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

smYearDs.on('beforeload', function(ds, o) {
                     
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.vouctempivinitem.csp?action=Getcode',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '���',
			store : smYearDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '���...',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
                       listeners:{
                       select:{
                       fn:function(combo,record,index) { 
                    BSMnameDs.removeAll();     
				
                  BSMnameDs.proxy= new Ext.data.HttpProxy({url:'herp.acct.vouctempivinitem.csp?action=Getname&&accsubjID='+combo.value+'&start=0'+'&limit=10',method:'POST'});      
                  BSMnameDs.load({params:{start:0,limit:10}});   

                  
            }
             }
         }
,
			selectOnFocus : true
		});



var itemDetail = new dhc.herp.Gridwolf({
    title: 'ƾ֤��ʱ��ϸ��',
    region : 'center',
    layout:"fit",
    split : true,
    collapsible : true,
    xtype : 'grid',
    trackMouseOver : true,
    stripeRows : true,
    loadMask : true,
    atLoad: true,
    height : 250,
    trackMouseOver: true,
    stripeRows: true,
    atLoad : true, // �Ƿ��Զ�ˢ��
    edit:false,
    url: 'herp.acct.vouchtempdetail.csp',
    
    fields: [
    {
        id:'rowid',
        header: 'ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'SubjCode',
        header: '��ƿ�Ŀ����',
        dataIndex: 'SubjCode',
        width:100,
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'SubjName',
        header: ' ��ƿ�Ŀ����',
        dataIndex: 'SubjName',
        width:130,
        allowBlank: true,
	editable:true,
	hidden: false
    },{ 
        id:'VouchPage',
        header: ' ƾ֤ҳ��',
        dataIndex: 'VouchPage',
        align:'right',
        width:60,
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'VouchRow',
        header: 'ƾ֤�к�',
        dataIndex: 'VouchRow',
        align:'right',
        width:60,
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'Summary',
        header: 'ժҪ',
        dataIndex: 'Summary',
        width:100,
        allowBlank: true,
	editable:true,
	hidden: false
     //   type:yearCombo
    },{
        id:'AmtDebit',
        header: '�跽���',
        dataIndex: 'AmtDebit',
        width:100,
        align:'right',
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'AmtCredit',
        header: '�������',
        dataIndex: 'AmtCredit',
        width:100,
        align:'right',
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'NumDebit',
        header: '�跽����',
        dataIndex: 'NumDebit',
        width:70,
        align:'right',
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'NumCredit',
        header: '��������',
        dataIndex: 'NumCredit',
        width:70,
        align:'right',
        allowBlank: true,
	editable:true,
	hidden: false
    },{ 
        id:'IsCheck',
        header: '�Ƿ�������',
        dataIndex: 'IsCheck',
        //align:'right',
        width:90,
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'SubDept',
        header: '�������ź���',
        dataIndex: 'SubDept',
        width:140,
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'SubSupplier',
        //header: '��Ӧ�̺���',
        header: 'ҵ��������',
        dataIndex: 'SubSupplier',
        width:100,
        allowBlank: true,
	editable:true,
	hidden: false
    },{ 
        id:'ZjlxID',
        header: '�ʽ�����',
        dataIndex: 'ZjlxID',
        //align:'right',
        width:90,
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'SubPerson',
        header: '������������',
        dataIndex: 'SubPerson',
        width:100,
        align:'right',
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubClient',
        header: '�ͻ���������',
        dataIndex: 'SubClient',
        width:100,
        align:'right',
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubProject',
        header: '��Ŀ����',
        dataIndex: 'SubProject',
        width:100,
        align:'right',
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubDefine1',
        header: '�Զ������1',
        dataIndex: 'SubDefine1',
        width:85,
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubDefine2',
        header: '�Զ������2',
        dataIndex: 'SubDefine2',
        width:85,
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubDefine3',
        header: '�Զ������3',
        dataIndex: 'SubDefine3',
        width:85,
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubDefine4',
        header: '�Զ������4',
        dataIndex: 'SubDefine4',
        width:85,
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubDefine5',
        header: '�Զ������5',
        dataIndex: 'SubDefine5',
        width:85,
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubDefine6',
        header: '�Զ������6',
        dataIndex: 'SubDefine6',
        width:85,
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubDefine7',
        header: '�Զ������7',
        dataIndex: 'SubDefine7',
        width:85,
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubDefine8',
        header: '�Զ������8',
        dataIndex: 'SubDefine8',
        width:85,
        allowBlank: true,
	editable:false,
	hidden: true
    },{
        id:'SubDefine9',
        header: '�Զ������9',
        dataIndex: 'SubDefine9',
        width:85,
        allowBlank: true,
	editable:false,
	hidden: true
    },{
        id:'SubDefine10',
        header: '�Զ������10',
        dataIndex: 'SubDefine10',
        width:85,
        allowBlank: true,
	editable:false,
	hidden: true
    }]
	

});

//itemDetail.btnPrintHide();  //���ش�ӡ��ť
///itemDetail.btnResetHide();  //�������ð�ť
itemDetail.btnAddHide();    //�������Ӱ�ť
itemDetail.btnSaveHide();   //���ر��水ť
itemDetail.btnDeleteHide(); //����ɾ����ť























