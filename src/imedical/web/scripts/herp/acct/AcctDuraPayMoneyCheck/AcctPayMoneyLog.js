var LogMain = new dhc.herp.Griddetail({
	    title: '��Ӧ�̸��������ϸ ',
	    region: 'center',
	    atLoad:true,
	    url:'herp.acct.acctPayMoneyCheckLogexe.csp' ,
	    fields: [{

	        id:'rowid',
	        header: '��Ӧ�̸��������ϸ',
	        allowBlank: false,
	        width:100,
	        editable:false,
	        dataIndex: 'rowid',
	        hidden:true
	   },{
	        id:'CheckDay',
	        header: '�������',
	        allowBlank: false,
	        width:130,
	        editable:false,
	        dataIndex: 'CheckDay'

	   }, {
	        id:'CheckPerson',
	        header: '�����',
	        allowBlank: false,
	        width:90,
	        editable:false,
	        dataIndex: 'CheckPerson'

	   }, {
	        id:'CheckName',
	        header: '���״̬',
	        allowBlank: false,
	        width:90,
	        editable:false,
	        dataIndex: 'CheckName'

	   },  {
	        id:'CheckResult',
	        header: '��˽��',
	        allowBlank: false,
	        width:90,
	        editable:false,
	        dataIndex: 'CheckResult'

	   }, {
	        id:'CheckDesc',
	        header: '�������',
	        allowBlank: false,
	        width:190,
	        editable:false,
	        dataIndex: 'CheckDesc'

	   }]

	});
	
	LogMain.btnAddHide();  //���ر��水ť
	LogMain.btnDeleteHide(); //�������ð�ť
	LogMain.btnSaveHide();  //���ر��水ť
	LogMain.btnResetHide();  //�������ð�ť
	LogMain.btnPrintHide();  //���ش�ӡ��ť