var acctSubjTypeMain = new dhc.herp.Grid({
        title: '��ƿ�Ŀ���',
        width: 400,
		iconCls:'maintain',
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.acctsubjtypeexe.csp',	  
		//tbar:delButton,
		atLoad : true,// �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
            header: '<div style="text-align:center">��Ŀ��Ŀ�������</div>',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'code',
            header: '<div style="text-align:center">��Ŀ������</div>',
			allowBlank: false,
			width:180,
			update:true,
            dataIndex: 'code'
        },{
            id:'name',
            header: '<div style="text-align:center">��Ŀ�������</div>',
			allowBlank: false,
			width:200,
			update:true,
            dataIndex: 'name'
        }] 
});
    acctSubjTypeMain.btnDeleteHide()     //����ɾ����ť
    acctSubjTypeMain.btnResetHide()     //�������ð�ť
    acctSubjTypeMain.btnPrintHide()     //���ش�ӡ��ť