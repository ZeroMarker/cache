
var itemGrid = new dhc.herp.Grid({
        title: 'ϵͳҵ��ά��',
        width: 400,
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.sysbusinessexe.csp',	  
		//tbar:delButton,
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'code',
            header: 'ϵͳ����',
			allowBlank: false,
			width:200,
            dataIndex: 'code'
        },{
            id:'name',
            header: 'ϵͳ����',
			allowBlank: false,
			width:200,
            dataIndex: 'name'
        }] 
});

    itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);
