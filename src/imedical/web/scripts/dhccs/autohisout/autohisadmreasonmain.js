autohisadmreasonFun = function(tmpDate) {

	var myTB = new Ext.Toolbar({
			height:24,
			items:[
				'收费时间: ',
				tmpDate //from csp
			]
		});

	Ext.Ajax.request({
		url:'dhc.cs.autohisoutexe.csp?action=OPIncomeByAdmreasonHead&tmpDate='+tmpDate+'&inOut=DHCOPB0022',
		waitMsg:'...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			var cmItems = []; 
			var cmConfig = {}; 
			cmItems.push(new Ext.grid.RowNumberer()); 
			//cmItems.push(new Ext.grid.CheckboxSelectionModel()); 
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
				proxy:new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=OPIncomeByAdmreasonJson&tmpDate='+tmpDate+'&inOut=DHCOPB0022', method:'GET'}),
				reader:new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, tmpDataMapping),
				remoteSort: true
			});
			aMain.reconfigure(tmpStore,tmpColumnModel);
			tmpStore.load();
		},
		scope: this
	});

	var initCM = new Ext.grid.ColumnModel([
			{header : '病人类型',dataIndex:'',width : 100,sortable : true}
		]);

	var aMain = new Ext.grid.EditorGridPanel({
			store: new Ext.data.Store(), 
			cm: initCM,
			region:'center',
			clicksToEdit:'auto',
			trackMouseOver: true,
			stripeRows: true,
			//sm:new Ext.grid.CheckboxSelectionModel(),
			loadMask: true,
			tbar: myTB
		});
	
	var aWin = new Ext.Window({
			title:'病人类型明细',
			width:1050,
			height:600,  
			minWidth:1050,
			minHeight:600,
			layout:'border',
			plain:true,
			modal:true,
			items: [aMain]
		});
		
    aWin.show();
};