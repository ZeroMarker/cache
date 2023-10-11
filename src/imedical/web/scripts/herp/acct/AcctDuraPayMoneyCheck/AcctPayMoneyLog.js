var LogMain = new dhc.herp.Griddetail({
	    title: '供应商付款审核明细 ',
	    region: 'center',
	    atLoad:true,
	    url:'herp.acct.acctPayMoneyCheckLogexe.csp' ,
	    fields: [{

	        id:'rowid',
	        header: '供应商付款审核明细',
	        allowBlank: false,
	        width:100,
	        editable:false,
	        dataIndex: 'rowid',
	        hidden:true
	   },{
	        id:'CheckDay',
	        header: '审核日期',
	        allowBlank: false,
	        width:130,
	        editable:false,
	        dataIndex: 'CheckDay'

	   }, {
	        id:'CheckPerson',
	        header: '审核人',
	        allowBlank: false,
	        width:90,
	        editable:false,
	        dataIndex: 'CheckPerson'

	   }, {
	        id:'CheckName',
	        header: '审核状态',
	        allowBlank: false,
	        width:90,
	        editable:false,
	        dataIndex: 'CheckName'

	   },  {
	        id:'CheckResult',
	        header: '审核结果',
	        allowBlank: false,
	        width:90,
	        editable:false,
	        dataIndex: 'CheckResult'

	   }, {
	        id:'CheckDesc',
	        header: '审核理由',
	        allowBlank: false,
	        width:190,
	        editable:false,
	        dataIndex: 'CheckDesc'

	   }]

	});
	
	LogMain.btnAddHide();  //隐藏保存按钮
	LogMain.btnDeleteHide(); //隐藏重置按钮
	LogMain.btnSaveHide();  //隐藏保存按钮
	LogMain.btnResetHide();  //隐藏重置按钮
	LogMain.btnPrintHide();  //隐藏打印按钮