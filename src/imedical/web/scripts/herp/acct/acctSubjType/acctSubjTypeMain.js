var acctSubjTypeMain = new dhc.herp.Grid({
        title: '会计科目类别',
        width: 400,
		iconCls:'maintain',
        //edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.acctsubjtypeexe.csp',	  
		//tbar:delButton,
		atLoad : true,// 是否自动刷新
		loadmask:true,
        fields: [{
            header: '<div style="text-align:center">科目科目类别主键</div>',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'code',
            header: '<div style="text-align:center">科目类别编码</div>',
			allowBlank: false,
			width:180,
			update:true,
            dataIndex: 'code'
        },{
            id:'name',
            header: '<div style="text-align:center">科目类别名称</div>',
			allowBlank: false,
			width:200,
			update:true,
            dataIndex: 'name'
        }] 
});
    acctSubjTypeMain.btnDeleteHide()     //隐藏删除按钮
    acctSubjTypeMain.btnResetHide()     //隐藏重置按钮
    acctSubjTypeMain.btnPrintHide()     //隐藏打印按钮