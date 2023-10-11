
var itemGrid = new dhc.herp.Grid({
        title: '系统业务维护',
        width: 400,
        //edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.sysbusinessexe.csp',	  
		//tbar:delButton,
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'code',
            header: '系统编码',
			allowBlank: false,
			width:200,
            dataIndex: 'code'
        },{
            id:'name',
            header: '系统名称',
			allowBlank: false,
			width:200,
            dataIndex: 'name'
        }] 
});

    itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);
