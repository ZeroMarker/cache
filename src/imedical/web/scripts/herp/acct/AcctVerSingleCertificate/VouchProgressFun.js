VouchProgressFun = function(VouchID){
	var userdr = session['LOGON.USERID'];
	 //alert("1");
	 var ProgressGrid = new dhc.herp.Gridvouchprogress({
        //title: 'ƾ֤������ϸ',
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
            header: '������',
			allowBlank: false,
			editable:false,
			width:80,
			update:true,
            dataIndex: 'Operator'
        },{
	        id:'OpDateTime',
            header: '����ʱ��',
			//hidden:false,
			width:90,
			editable:false,
            dataIndex: 'OpDateTime'
	    
        },{								
            id:'OpAct',
            header: '��������',
			width:90,
			hidden:false,
            dataIndex: 'OpAct'
        },{
            id:'OpResult',
            header: '������',
			width:90,
			hidden:false,
            dataIndex: 'OpResult'
        },{
            id:'OpDesc',
            header: '�������',
			width:140,
			editable:false,
            dataIndex: 'OpDesc'
        }]
	});

    //��ȡlistd�����Ĳ���
	    ProgressGrid.load({
		    params:{
		    start:0,
		    limit:25,
			VouchID:VouchID
		   }
		
		
	    });
	

	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [ProgressGrid]
			});
	
	//var tab1GroupMgr = new Ext.WindowGroup;  
    //ǰ�ô���
   //tab1GroupMgr.zseed=99999;  			
	var window = new Ext.Window({
		        title:'ƾ֤������ϸ',
				layout : 'fit',
				//plain : true,
				width : 800,
				height : 350,
				modal : true,
				//manager: tab1GroupMgr,
				//buttonAlign : 'center',
				items : formPanel,
				buttons : [{text: '�ر�',handler: function()
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