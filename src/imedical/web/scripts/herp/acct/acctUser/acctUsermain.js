
var itemGrid = new dhc.herp.Grid({
        title: '会计用户维护',
        width: 400,
        readerModel:'remote',
        region: 'center',
        url:'herp.acct.acctUserexe.csp',	  
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
	        id:'rowid',
            header: '会计用户ID',
            width:150,
            edit:false,
           	hidden:true,
            print:false,
            dataIndex:'rowid'
        },{
            id:'UserCode',
            header: '用户编码',
            type:'numberField',
            format:'0',
			allowBlank: false,
			width:200,
			print:true,
            dataIndex: 'UserCode'
        },{								
            id:'UserName',
            header: '用户名称',
            allowBlank: false,
			width:200,
			print:true,
            dataIndex: 'UserName'
        },{
            id:'isValid',
            header: '是否有效',
			width:100,
			print:true,
            dataIndex: 'isValid'
        }] 
});

itemGrid.hiddenButton(3);
itemGrid.hiddenButton(4);