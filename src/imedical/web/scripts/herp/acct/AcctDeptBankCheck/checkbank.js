
 bookID=IsExistAcctBook();

var Detail = new dhc.herp.Gridhss({
        title: '���ж��˵���ѯ�б�',
		iconCls:'list',
        readerModel:'remote',
        region: 'center',
        url: '../csp/herp.acct.acctcheckbankexe.csp',	  
        split : true,
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [
         new Ext.grid.CheckboxSelectionModel({sm:'sm',editable:false}),
       
        {id:'rowid',
           	header: '<div style="text-align:center">ID</div>',
            allowBlank: false,
            width:40,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       },{
            id:'bankname',
           	header: '<div style="text-align:center">���п�Ŀ</div>',
			allowBlank: false,
			//hidden:false,
			editable:false,
			width:150,
			update:true,
            dataIndex: 'bankname'
        },{
	        id:'occurtime',
           header: '<div style="text-align:center">ҵ��ʱ��</div>',
           align:'center',
			//hidden:false,
			width:90,
			editable:false,
            dataIndex: 'occurtime',
            //type:"dateField" ,   
            altFormats:'Y-m-d'
	    
        },{								
            id:'cheqtypename',
            header: '<div style="text-align:center">���㷽ʽ</div>',
            align:'center',
            editable:false,
			width:80,
			hidden:false,
            dataIndex: 'cheqtypename'
        },{
            id:'cheqno',
           	header: '<div style="text-align:center">Ʊ�ݺ�</div>', 
            editable:false,
            //align: 'right',
			width:180,
			hidden:false,
            dataIndex: 'cheqno'
        },{
            id:'summary',
            header: '<div style="text-align:center">ժҪ</div>', 
            editable:false,
			width:300,
			hidden:false,
            dataIndex: 'summary'
        },{
            id:'amtdebit',
            header: '<div style="text-align:center">�跽���</div>',  
            editable:false,
            align: 'right',
            type:'numberField',
			width:150,
			hidden:false,
            dataIndex: 'amtdebit'
           
        },{
            id:'amtcredit',
            header: '<div style="text-align:center">�������</div>',
            editable:false,
            align: 'right',
            type:'numberField',
			width:150,
			hidden:false,
            dataIndex: 'amtcredit'
        },{
            id:'CheckFund',
            header: '<div style="text-align:center">���˷�ʽ</div>',
            align:'center',
            editable:false,
			width:90,
			hidden:false,
            dataIndex: 'CheckFund'
        },{
            id:'checkperson',
            header: '<div style="text-align:center">������</div>',
            align:'center',
            editable:false,
			width:90,
			hidden:false,
            dataIndex: 'checkperson'
        },{
            id:'checkdate',
            header: '<div style="text-align:center">��������</div>',
            align:'center',
            editable:false,
			width:100,
			hidden:false,
            dataIndex: 'checkdate'
        },{
		    id:'ischecked',
            header: '<div style="text-align:center">����״̬</div>',
            align:'center',
            editable:false,
			width:90,
			hidden:false,
            dataIndex: 'ischecked'
		}] 
});

        Detail.btnAddHide(); 	//�������Ӱ�ť
		Detail.btnSaveHide(); 	//���ر��水ť
		Detail.btnDeleteHide(); //����ɾ����ť
