
var itemGrid = new dhc.herp.Grid({
        // title: 'ҵ��ϵͳά��',
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
            header: '<div style="text-align:center">ϵͳ����</div>',
			allowBlank: false,
			width:200,
            dataIndex: 'code'
        },{
            id:'name',
            header: '<div style="text-align:center">ϵͳ����</div>',
			allowBlank: false,
			width:200,
            dataIndex: 'name'
        }] 
});

    itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);
