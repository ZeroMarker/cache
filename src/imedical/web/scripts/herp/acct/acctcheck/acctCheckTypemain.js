var acctCheckTypeUrl = '../csp/herp.acct.acctchecktypeexe.csp';

var acctCheckTypeGrid = new dhc.herp.Grid({
        title : '������������ά��',
        loadMask: true,
		iconCls:'maintain',
        width: 400,
        region: 'center',
        url: 'herp.acct.acctchecktypeexe.csp',      
		    atLoad : true, // �Ƿ��Զ�ˢ��
        fields:[
        //new Ext.grid.CheckboxSelectionModel({editable:false}),//�����Ÿ�ѡ��
        {
            header: '<div style="text-align:center">ID</div>',
            id:'rowid',
            dataIndex: 'rowid',
			editable:false,
            hidden: true,
            print:false
        },{
            id:'typecode',
            header: '<div style="text-align:center">������</div>',
			allowBlank: false,
			editable:true,
			width:150,
            dataIndex: 'typecode'
        },{
            id:'typename',
            header: '<div style="text-align:center">�������</div>',
			allowBlank: false,
			editable:true,
			width:200,
            dataIndex: 'typename'
        }, {
            id:'chkname',
            header: '<div style="text-align:center">���</div>',
            //align:'center',
			allowBlank: false,
			width:150,
			editable:true,
            dataIndex: 'chkname'
            
        }, {
            id:'fromtable',
            header: '<div style="text-align:center">����Դ�����</div>',
            allowBlank: true,
            editable:false,//�ɱ༭
            hidden:true,
			width:100,
            dataIndex: 'fromtable'
          
        }],
        trackMouseOver: true,
		    stripeRows: true,
		    sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        //viewConfig : {
		 //    forceFit : true
		//   }
    });
    
	//acctCheckTypeGrid.addButton(delButton);
	//acctCheckTypeGrid.hiddenButton(2);
	acctCheckTypeGrid.hiddenButton(3);
	acctCheckTypeGrid.hiddenButton(4);



