var JobTypeURL='herp.srm.jobtypeexe.csp';

var itemGrid = new dhc.herp.Grid({
        title: '��λ������Ϣά��',
        iconCls: 'list',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: JobTypeURL,	  
		    atLoad : true, // �Ƿ��Զ�ˢ��
		    loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      edit:false,
            hidden: true
        },{
            id:'Code',
            header: '��λ���ʱ���',
			      allowBlank: false,
			      width:100,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '��λ��������',
			      allowBlank: false,
			      width:100,
            dataIndex: 'Name'
        }] 
});

    itemGrid.hiddenButton(3);
    itemGrid.hiddenButton(4);
