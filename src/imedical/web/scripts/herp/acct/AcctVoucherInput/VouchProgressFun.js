VouchProgressFun = function(VouchID){
	 //alert("1");
	 var ProgressGrid = new dhc.herp.Gridvouchprogress({
        //title: 'ƾ֤������ϸ',
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


	    ProgressGrid.load({
		    params:{
		    start:0,
		    limit:25,
			rowid:VouchID
		   }
		
		
	    });
	

	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [ProgressGrid]
			});
	var window = new Ext.Window({
		        title:'ƾ֤������ϸ',
				layout : 'fit',
				plain : true,
				width : 800,
				height : 350,
				modal : true,
				buttonAlign : 'center',
				items : formPanel,
				buttons : [{text: '�ر�',handler: function(){window.close();}}]

			});
	window.show();

	
}