
var itemGrid = new dhc.herp.Grid({
        // title: '业务系统维护',
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
            header: '<div style="text-align:center">系统编码</div>',
			allowBlank: false,
			width:200,
            dataIndex: 'code'
        },{
            id:'name',
            header: '<div style="text-align:center">系统名称</div>',
			allowBlank: false,
			width:200,
            dataIndex: 'name'
        }] 
});

    itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);
