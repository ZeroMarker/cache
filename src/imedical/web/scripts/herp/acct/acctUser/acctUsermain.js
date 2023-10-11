
var itemGrid = new dhc.herp.Grid({
        title: '����û�ά��',
        width: 400,
        readerModel:'remote',
        region: 'center',
        url:'herp.acct.acctUserexe.csp',	  
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
	        id:'rowid',
            header: '����û�ID',
            width:150,
            edit:false,
           	hidden:true,
            print:false,
            dataIndex:'rowid'
        },{
            id:'UserCode',
            header: '�û�����',
            type:'numberField',
            format:'0',
			allowBlank: false,
			width:200,
			print:true,
            dataIndex: 'UserCode'
        },{								
            id:'UserName',
            header: '�û�����',
            allowBlank: false,
			width:200,
			print:true,
            dataIndex: 'UserName'
        },{
            id:'isValid',
            header: '�Ƿ���Ч',
			width:100,
			print:true,
            dataIndex: 'isValid'
        }] 
});

itemGrid.hiddenButton(3);
itemGrid.hiddenButton(4);