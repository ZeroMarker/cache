var subjNameMain = new dhc.herp.Grid({
        title: '��ƿ�Ŀ����',
		iconCls:'find',
        width: 400,
        edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.syssubjnatureexe.csp',	  
		//tbar:delButton,
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
            header: '��Ŀ������ϵID',
            dataIndex: 'rowid',
			edit:false,
			editable:false,
            hidden: true
        },{
            id:'code',
            header: '��Ŀ���ʱ���',
			allowBlank: false,
			width:150,
			update:true,
			editable:false,
            dataIndex: 'code'
        },{
            id:'name',
            header: '��Ŀ��������',
			allowBlank: false,
			width:180,
			update:true,
			editable:false,
            dataIndex: 'name'
        },{
            id:'note',
            header: '��ע',
			allowBlank: true,
			align:'center',
			width:260,
			update:true,
			editable:false,
            dataIndex: 'note'
        }] 
});
	//var peg = new PrintExtgrid(this);
	subjNameMain.hiddenButton(0);
	subjNameMain.hiddenButton(1);
	subjNameMain.hiddenButton(2);	
    subjNameMain.hiddenButton(3);
	subjNameMain.hiddenButton(4);
	
