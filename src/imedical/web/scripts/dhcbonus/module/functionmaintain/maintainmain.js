//var username = session['LOGON.USERCODE'];

var projUrl = 'dhc.bonus.module.FUNCmaintainexe.csp';

// ///////////////////������ʶ
var funcodeText = new Ext.form.TextField({
	width : 120,
	listWidth : 240,
	pageSize : 10,
	minChars : 1,
	selectOnFocus : true
});

// ///////////////////��������
var funnameText = new Ext.form.TextField({
	width : 120,
	listWidth : 240,
	pageSize : 10,
	minChars : 1,
	selectOnFocus : true
});

/////////////////// ��ѯ��ť //////////////////
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'option',
	handler: function(){
	    var FunName  = funnameText.getValue();
	    var FunCode = funcodeText.getValue();
		itemGrid.load({params:{start:0,limit:25,FunName:FunName,FunCode:FunCode}});
		
	}
});

var itemGrid = new dhc.herp.Grid({
        title: '������ά��',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.FUNCmaintainexe.csp',	  
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      edit:false,
            hidden: true
        },{
            id:'funcode',
            header: '������ʶ',
			allowBlank: true,
			width:120,
            dataIndex: 'funcode'
        },{
            id:'funname',
            header: '��������',
			allowBlank: true,
			width:80,
            dataIndex: 'funname'
        },{
            id:'fundesc',
            header: '��������',
			allowBlank: true,
			width:120,
            dataIndex: 'fundesc'
        },{
            id:'funclass',
            header: '����M��',
			allowBlank: true,
			width:120,
            dataIndex: 'funclass'
        },{
            id:'paradesc',
            header: '����˵��',
			allowBlank: true,
			width:120,
            dataIndex: 'paradesc'
        },{
            id:'creattdate',
            header: '��������',
			allowBlank: true,
			editable:false,
			width:120,
            dataIndex: 'creattdate'
        }],
        
       tbar:['��������',funnameText,'-','������ʶ',funcodeText,'-',findButton]
        
});
  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnPrintHide() ;	//���ش�ӡ��ť
/*itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//�������ð�ť
  itemGrid.btnSaveHide(); 	//�������ð�ť
  itemGrid.load({params:{start:0, limit:12, userdr:username}});
*/
   
   
    

