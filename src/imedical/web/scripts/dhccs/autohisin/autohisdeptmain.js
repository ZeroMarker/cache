OPReportCatDetailByLocFun = function(bdate, sdate) {
	
	Ext.Ajax.request({
		url:'dhc.cs.autohisoutexe.csp?action=IPReportCatDetailByLocHead&stDate='+bdate+'&endDate='+sdate,
		waitMsg:'...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			var cmItems = []; 
			var cmConfig = {}; 
			cmItems.push(new Ext.grid.RowNumberer()); 
			var jsonHeadNum = jsonData.results; 
			var jsonHeadList = jsonData.rows; 
			var tmpDataMapping = [];
			for(var i=0;i<jsonHeadList.length;i++){ 
				cmConfig = {header : jsonHeadList[i].title,dataIndex : jsonHeadList[i].name,width : 75,sortable : true,align:'right'};
				cmItems.push(cmConfig); 
				tmpDataMapping.push(jsonHeadList[i].name);  
			}
			var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
			var tmpStore = new Ext.data.Store({
				proxy:new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=IPReportCatDetailByLocJson&stDate='+bdate+'&endDate='+sdate, method:'GET'}),
				reader:new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, tmpDataMapping),
				remoteSort: true
			});
			
			autohisdeptMain.reconfigure(tmpStore,tmpColumnModel);
			tmpStore.load();
		},
		scope: this
	});
	
	var myTB = new Ext.Toolbar({
			height:24,
			items:[
				'�շ�ʱ��: ',
				bdate,
				' �� ',
				sdate
			]
		});
		
	var initCM = new Ext.grid.ColumnModel([
		{header : '����',dataIndex:'����',width : 100,sortable : true},
		{header : '��ʱƾ֤��',dataIndex:'��ʱƾ֤��',width : 100,sortable : true},
		{header : 'ƾ֤���',dataIndex:'ƾ֤���',width : 100,sortable : true}
	]);
	
	var autohisdeptMain = new Ext.grid.GridPanel({
			//title: '�����һ���',
			store: new Ext.data.Store(),
			cm: initCM,
			trackMouseOver: true,
			region:'center',//�����
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar: myTB
	});

	var aWin = new Ext.Window({
			title:'�����Ҳ�ѯ',
			width:1050,
			height:600,  
			minWidth:1050,
			minHeight:600,
			layout:'border',
			plain:true,
			modal:true,
			items: [autohisdeptMain]
		});

	aWin.show();
	
};