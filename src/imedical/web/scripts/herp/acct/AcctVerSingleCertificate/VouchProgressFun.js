VouchProgressFun = function(VouchID){
	var userdr = session['LOGON.USERID'];
	 //alert("1");
	 var ProgressGrid = new dhc.herp.Gridvouchprogress({
        //title: '凭证处理明细',
        region: 'center',
        url: 'herp.acct.acctversinglecertifexe.csp',	 
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

    //获取listd方法的参数
	    ProgressGrid.load({
		    params:{
		    start:0,
		    limit:25,
			VouchID:VouchID
		   }
		
		
	    });
	

	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [ProgressGrid]
			});
	
	//var tab1GroupMgr = new Ext.WindowGroup;  
    //前置窗口
   //tab1GroupMgr.zseed=99999;  			
	var window = new Ext.Window({
		        title:'凭证处理明细',
				layout : 'fit',
				//plain : true,
				width : 800,
				height : 350,
				modal : true,
				//manager: tab1GroupMgr,
				//buttonAlign : 'center',
				items : formPanel,
				buttons : [{text: '关闭',handler: function()
					{
					window.close();
					//p_URL = 'acct.html?acctno='+VouchID+'&user='+userdr;
                    //var reportFrame=document.getElementById("frameReport");
                    //reportFrame.src=p_URL;
					}
				}]

			});		
	window.show();
	// window.showModelessDialog();
	
}