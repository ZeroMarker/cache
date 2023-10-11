
var itemGrid = new dhc.herp.Gridother({
        title: '单位对账单',
        readerModel:'remote',
        region: 'south',
		height:280,
		split : true,  
        url:'../csp/herp.acct.acctcheckexe.csp',	
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [
        new Ext.grid.CheckboxSelectionModel({sm:'sm',editable:false}),
        {id:'rowid',
           	header: '<div style="text-align:center">ID</div>',
            allowBlank: false,
            width:40,
            editable:false,
           // hidden:true,
            dataIndex: 'rowid'
       },{
            id:'bankname',
           	header: '<div style="text-align:center">银行科目</div>',
			allowBlank: false,
			//hidden:false,
			editable:false,
			width:180,
			update:true,
            dataIndex: 'bankname'
          
        },{
	        id:'occurtime',
            header: '<div style="text-align:center">业务时间</div>',
			//hidden:false,
			width:100,
			editable:false,
            dataIndex: 'occurtime',
            altFormats:'Y-m-d'  
        },{							
            id:'cheqtypename',
            header: '<div style="text-align:center">结算方式</div>',
			width:80,
			hidden:false,
            dataIndex: 'cheqtypename'
        },{
            id:'cheqno', 
            header: '<div style="text-align:center">票据号</div>',   
            align: 'right',
			width:120,
			hidden:false,
            dataIndex: 'cheqno'
        },{
             id:'summary',
            header: '<div style="text-align:center">摘要</div>', 
            editable:false,
			width:260,
			hidden:false,
            dataIndex: 'summary'
        },{
            id:'amtdebit',
             header: '<div style="text-align:center">借方金额</div>',      
            editable:false,
            align: 'right',
            type:'numberField',
			width:140,
			hidden:false,
            dataIndex: 'amtdebit'
         
        },{
            id:'amtcredit',
             header: '<div style="text-align:center">贷方金额</div>',
            editable:false,
            align: 'right',
            type:'numberField',
			width:140,
			hidden:false,
            dataIndex: 'amtcredit'
        },{
            id:'vouchno',
             header: '<div style="text-align:center">凭证号</div>',   
            editable:false,
            align: 'right',
			width:120,
			hidden:false,
            dataIndex: 'vouchno'
        },{
            id:'checkdate',
             header: '<div style="text-align:center">对账日期</div>',
            editable:false,
			width:100,
			hidden:false,
            dataIndex: 'checkdate'
        }] 
});
itemGrid.btnAddHide(); 	//隐藏增加按钮
	itemGrid.btnSaveHide(); 	//隐藏保存按钮
	itemGrid.btnDeleteHide(); //隐藏删除按钮