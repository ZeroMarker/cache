
//////借方未核销金额明细
UnCheckAmtDebitFun = function(CheckItemName,checksubjId,startdate,enddate,CheckItemID,userdr){
	
    var DebitGrid = new dhc.herp.GridDebit({
        title: '借方',
        region: 'north',
        url: 'herp.acct.acctautodealcaceluncheckdebitexe.csp',	 
	    split : true,
		height:230,
		 edit:false, 
		//viewConfig : {forceFit : true},
        fields: [ //new Ext.grid.CheckboxSelectionModel({editable:false}),
   //  s jsonTitle="rowid^AmtDebit^AcctYear^AcctMonth^Summary^OrderID^VouchDate^VouchNo^CheckFund^CheckerName^CheckDate"
	   {   id:'rowid',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       },{
            id:'AmtDebit',
            header: '<div style="text-align:center">借方金额</div>',
			allowBlank: false,
			align: 'right',
			editable:false,
			width:140,
			update:true,
			type:'numberField',
            dataIndex: 'AmtDebit'
        },{
	        id:'AcctYear',
            header: '会计年度',
			//hidden:false,
			width:80,
			editable:false,
            dataIndex: 'AcctYear'
	    
        },{								
            id:'AcctMonth',
            header: '会计期间',
			width:80,
			hidden:false,
            dataIndex: 'AcctMonth'
        },{
            id:'Summary',
            header: '<div style="text-align:center">摘要</div>',
            align: 'left',
			width:220,
			hidden:false,
            dataIndex: 'Summary'
        },{
            id:'OrderID',
            header: '<div style="text-align:center">票据号</div>',
			width:100,
			editable:false,
            dataIndex: 'OrderID'
        },{
            id:'VouchDate',
            header: '凭证日期',
			width:100,
			hidden:false,
            dataIndex: 'VouchDate'
           
        },{
            id:'VouchNo',
            header: '凭证号',
			width:110,
			hidden:false,
            dataIndex: 'VouchNo'
        },{
            id:'CheckFund',
            header: '对账方式',
			width:80,
			hidden:true,
            dataIndex: 'CheckFund'
        },{
            id:'CheckerName',
            header: '对账人',
			width:100,
			hidden:true,
            dataIndex: 'CheckerName'
        },{
            id:'CheckDate',
            header: '对账日期',
			width:100,
			hidden:true,
            dataIndex: 'CheckDate'
        }]
	});


	    DebitGrid.load({
		    params:{
		    start:0,
		    limit:25,
		    startdate:startdate,
		    enddate:enddate,
		    checksubjId:checksubjId,
		    CheckItemID:CheckItemID,
			userdr:userdr
		   }
		
		
	    });
	

	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [DebitGrid]
			});
	var window = new Ext.Window({
		        title:CheckItemName+"-"+'借方未核销明细',
				layout : 'fit',
				plain : true,
				width : 900,
				height : 400,
				modal : true,
				buttonAlign : 'center',
				items : formPanel,
				buttons : [{text: '关闭',iconCls:'cancel',handler: function(){window.close();}}]

			});
	window.show();
}

//////贷方未核销金额明细

UnCheckAmtCreditFun = function(CheckItemName,checksubjId,startdate,enddate,CheckItemID,userdr){
	
    var CreditGrid = new dhc.herp.GridCredit({
        title: '贷方',                 	  
        url:'herp.acct.acctautodealcaceluncheckcreditexe.csp',
		region : 'center',
        height:230,		
        split : true,	
		edit:false, 
		//viewConfig : {forceFit : true},
       fields: [ //new Ext.grid.CheckboxSelectionModel({editable:false}),
       
        {   id:'rowid',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       },{
            id:'AmtCredit',
            header: '<div style="text-align:center">贷方金额</div>',
			allowBlank: false,
			align: 'right',
			editable:false,
			width:140,
			update:true,
			type:'numberField',
            dataIndex: 'AmtCredit'
        },{
	        id:'AcctYear',
            header: '会计年度',
			//hidden:false,
			width:80,
			editable:false,
            dataIndex: 'AcctYear'
	    
        },{								
            id:'AcctMonth',
            header: '会计期间',
			width:80,
			hidden:false,
            dataIndex: 'AcctMonth'
        },{
            id:'Summary',
            header: '<div style="text-align:center">摘要</div>',
            align: 'left',
			width:220,
			hidden:false,
            dataIndex: 'Summary'
        },{
            id:'OrderID',
            header: '<div style="text-align:center">票据号</div>',
			width:100,
			editable:false,
            dataIndex: 'OrderID'
        },{
            id:'VouchDate',
            header: '凭证日期',
			width:100,
			hidden:false,
            dataIndex: 'VouchDate'
           
        },{
            id:'VouchNo',
            header: '凭证号',
			width:110,
			hidden:false,
            dataIndex: 'VouchNo'
        },{
            id:'CheckFund',
            header: '对账方式',
			width:80,
			hidden:true,
            dataIndex: 'CheckFund'
        },{
            id:'CheckerName',
            header: '对账人',
			width:100,
			hidden:true,
            dataIndex: 'CheckerName'
        },{
            id:'CheckDate',
            header: '对账日期',
			width:100,
			hidden:true,
            dataIndex: 'CheckDate'
        }]
	});

		
		CreditGrid.load({
		    params:{
			    start:0,
			    limit:25,
				startdate:startdate,
				enddate:enddate,
				checksubjId:checksubjId,
				CheckItemID:CheckItemID,
				userdr:userdr
			   }
			
			
		  });

	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [CreditGrid]
			});
	var window = new Ext.Window({
				title:CheckItemName+"-"+'贷双方未核销明细',
				layout : 'fit',
				plain : true,
				width : 900,
				height : 400,
				modal : true,
				buttonAlign : 'center',
				items : formPanel,
				buttons : [{text: '关闭',iconCls:'cancel',handler: function(){window.close();}}]

			});
	window.show();
	
	
}

