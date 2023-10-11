VouchProgressFun = function(VouchID){
	 //alert("1");
	 var ProgressGrid = new dhc.herp.Gridvouchprogress({
        //title: '凭证处理明细',
        region: 'center',
        url: 'herp.acct.acctvouchexe.csp',	 
		viewConfig : {forceFit : true},
        fields: [ 
	    {    id:'AcctVouchOpLogID',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'AcctVouchOpLogID'
        },{
            id:'Operator',
            header: '处理人',
			allowBlank: false,
			editable:false,
			width:80,
			update:true,
            dataIndex: 'Operator'
        },{
	        id:'OpDateTime',
            header: '处理时间',
			//hidden:false,
			width:90,
			editable:false,
            dataIndex: 'OpDateTime'
	    
        },{								
            id:'OpAct',
            header: '工作任务',
			width:90,
			hidden:false,
            dataIndex: 'OpAct'
        },{
            id:'OpResult',
            header: '处理结果',
			width:90,
			hidden:false,
            dataIndex: 'OpResult'
        },{
            id:'OpDesc',
            header: '处理意见',
			width:140,
			editable:false,
            dataIndex: 'OpDesc'
        }]
	});


	    ProgressGrid.load({
		    params:{
		    start:0,
		    limit:25,
			rowid:VouchID
		   }
		
		
	    });
	

	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [ProgressGrid]
			});
	var window = new Ext.Window({
		        title:'凭证处理明细',
				layout : 'fit',
				plain : true,
				width : 800,
				height : 350,
				modal : true,
				buttonAlign : 'center',
				items : formPanel,
				buttons : [{text: '关闭',handler: function(){window.close();}}]

			});
	window.show();

	
}