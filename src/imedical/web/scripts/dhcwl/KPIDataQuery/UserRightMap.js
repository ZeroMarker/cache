(function(){
	Ext.ns("dhcwl.KDQ.UserRightMap");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.KDQ.UserRightMap=function(pObj){
	var serviceUrl="dhcwl/kpidataquery/userrightmap.csp";
	var outThis=this;
	var parentObj=pObj;
	var rptName="";
	var initAttrib;
	var inParam= new Object();
	var userToolPageSize=50;
	var masterGrid;
	
 	var rptCml = new Ext.grid.ColumnModel({
		    defaults: {
                width: 100,
                sortable: false
            },
			columns: [
				{header:'报表编码',dataIndex:'rptCode'},
				{header:'报表描述',id:'descript',dataIndex:'descript',width: 150},
				{header:'作者',dataIndex:'userName',width: 150}
				]
	});
    var rptStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+"?action=getURMapRpt"}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'rptCode'},
            	{name: 'descript'},
				{name: 'userID'},
				{name: 'userName'}
			]
    	})
    });

    var rptGrid = new Ext.grid.GridPanel({
        height:480,
		title:'报表配置——主',
		//layout:'fit',
        store: rptStore,
        cm: rptCml,
		autoExpandColumn: 'descript',
		
		tbar:new Ext.Toolbar({
			layout: 'hbox',
			items : [		
			{
				disabled: true,
				id: 'addRptBtn',
				text: '增加报表',
				icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/add.gif'	,
				handler:OnAddRpt
			},{
				disabled: true,
				id: 'delRptBtn',
				text: '删除报表',
				icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/delete.gif'	,
				handler:OnDelRpt
			},{
				text: '主-从角色交换',
				icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/application_go.png'	,
				handler:OnExchange			
		}]}),	
		
		bbar: new Ext.PagingToolbar({
			pageSize:50,
			store:rptStore,
			displayInfo:true,
			displayMsg:'{0}~{1}条,共 {2} 条',
			emptyMsg:'sorry,data not found!'
		}),		
		listeners:{
			'rowclick':function(grid, rowIndex, e ){
				if (masterGrid==rptGrid){
					var rptCode=grid.getStore().getAt(rowIndex).get("rptCode");
					userStore.setBaseParam("rptCode",rptCode);
					userStore.reload({params:{start:0,limit:userToolPageSize}});
				}				
			}
		}
		
    });
	
	masterGrid=rptGrid;
	rptStore.load({params:{start:0,limit:50}});
	
	rptGrid.getSelectionModel().on('selectionchange', function(sm){
        	//userGrid.addUserBtn.setDisabled(sm.getCount() < 1);
			if (masterGrid==rptGrid) {
				Ext.getCmp("addUserBtn").setDisabled(sm.getCount() < 1);
			}
			if (masterGrid==userGrid) {
				Ext.getCmp("delRptBtn").setDisabled(sm.getCount() < 1);
			}			
			
    	});	
	
 	var rptCml = new Ext.grid.ColumnModel({
		    defaults: {
                width: 100,
                sortable: false
            },
			columns: [
				{header:'报表编码',dataIndex:'rptCode'},
				{header:'报表描述',id:'descript',dataIndex:'descript',width: 150},
				{header:'作者',dataIndex:'userName',width: 150}
				]
	});	

	var userCml = new Ext.grid.ColumnModel({
		defaults:{
			sortable: false
		},
		columns:[
			{header:'ID',dataIndex:'userID', width: 150},
			{header:'姓名',dataIndex:'userName', width: 100},
			{header:'安全组',id:'userGrp',dataIndex:'userGrp', width: 150}
			]
		
	});
    var userStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+"?action=getURMapUserByRptCode"}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'userName'},
            	{name: 'userGrp'},
				{name: 'userID'}
			]
    	})
    });


    var userGrid = new Ext.grid.GridPanel({
        height:480,
		title:'用户配置——从',
		//layout:'fit',
        store: userStore,
        cm: userCml,
		autoExpandColumn: 'userGrp',
		tbar:new Ext.Toolbar({
			layout: 'hbox',
			items : [		
			{
				id: 'addUserBtn',
				text: '增加用户',
				icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/add.gif'	,
				disabled: true,
				handler:OnAddUser
			},{
				id: 'delUserBtn',
				text: '删除用户',
				icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/delete.gif'	,
				disabled: true,
				handler:OnDelUser
		}]}),	
		bbar: new Ext.PagingToolbar({
			pageSize:userToolPageSize,
			store:userStore,
			displayInfo:true,
			displayMsg:'{0}~{1}条,共 {2} 条',
			emptyMsg:'sorry,data not found!'
		}),		
		listeners:{
			'rowclick':function(grid, rowIndex, e ){
				if (masterGrid==userGrid){
					var userID=grid.getStore().getAt(rowIndex).get("userID");
					rptStore.setBaseParam("userID",userID);
					rptStore.reload({params:{start:0,limit:userToolPageSize}});		
				}				
			}
		}
    });

	userGrid.getSelectionModel().on('selectionchange', function(sm){
			if (masterGrid==rptGrid) {
				Ext.getCmp("delUserBtn").setDisabled(sm.getCount() < 1);
			}
			if (masterGrid==userGrid) {
				Ext.getCmp("addRptBtn").setDisabled(sm.getCount() < 1);
				Ext.getCmp("delUserBtn").setDisabled(sm.getCount() < 1);
			}

    	});		
		
	var mapPanel = new Ext.Panel({
		closable:true,
		title:'配置用户权限',
		layout: {
			type:'hbox',
			//padding:'0',
			align:'stretch'
		},
		items: [
		{
			flex:5,
			layout:'fit',
			items:rptGrid
		},{
			//padding:'10',
			flex:5,
			layout:'fit',
			items:userGrid
		}]
	});	
	
	function OnAddUser() {

		var showUserDataObj=new dhcwl.KDQ.ShowUserData();
		var showUserDataWin=showUserDataObj.getUserDataWin();	
		showUserDataObj.onSelCallback=addUser;	
		var inParamObj=new Object();

		if (masterGrid==rptGrid) {
			inParamObj.masterGrid="rptGrid";
			var selRec=rptGrid.getSelectionModel().getSelected();
			var rptCode=selRec.get("rptCode");				
			inParamObj.rptCode=rptCode;
		}
		if (masterGrid==userGrid) inParamObj.masterGrid="userGrid";
		showUserDataObj.init(inParamObj);
		
		showUserDataObj.show();
	}
	
	function addUser(paramObj) {
		var newRptCode="";
		if (masterGrid==rptGrid) {
			var selRec=rptGrid.getSelectionModel().getSelected();
			newRptCode=selRec.get("rptCode");	
		}
		
		var newUserID=paramObj.userID;			
		var selRec=rptGrid.getSelectionModel().getSelected();
				
		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:"addURUser",
			userID:newUserID,
			rptCode:newRptCode
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok" ){
				userStore.reload();
			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);
	
	}

	function OnAddRpt() {

		var showRptDataObj=new dhcwl.KDQ.ShowRptData();
		var showRptDataWin=showRptDataObj.getRptDataWin();	
		showRptDataObj.onSelCallback=addRpt;
		//左边是用户，右边是报表的情况
		var selRec=userGrid.getSelectionModel().getSelected();
		inParam.curUserID=selRec.get("userID");
		inParam.masterGrid=masterGrid;
		showRptDataObj.init(inParam);
		//showRptDataWin.show();
		showRptDataObj.show();
	}
	
	function addRpt(paramObj) {
		if (masterGrid==userGrid) {
			var rptCode=paramObj.rptCode;	
			var selRec=userGrid.getSelectionModel().getSelected();
			var newUserID=selRec.get("userID");


			dhcwl.mkpi.Util.ajaxExc(serviceUrl,
			{
				action:"addURRpt",
				userID:newUserID,
				rptCode:rptCode
			},function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok" ){
					rptStore.setBaseParam("userID",newUserID);
					//rptStore.setBaseParam("searchObj","rpt");
					rptStore.reload();
				}else{
					Ext.Msg.alert("操作失败",jsonData.MSG);
				}
			},this);	
		}else if (masterGrid==userGrid) {
			/*
			var newRptName=paramObj.rptName;	
			var selRec=userGrid.getSelectionModel().getSelected();
			var newUserID=selRec.get("userID");


			dhcwl.mkpi.Util.ajaxExc(serviceUrl,
			{
				action:"addURRpt",
				userID:newUserID,
				rptName:newRptName
			},function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok" ){
					rptStore.setBaseParam("userID",newUserID);
					//rptStore.setBaseParam("searchObj","rpt");
					rptStore.reload();
				}else{
					Ext.Msg.alert("操作失败",jsonData.MSG);
				}
			},this);	
			*/
		}		
	}
	
	function OnExchange() {
		var item1=mapPanel.get(0).get(0);
		var item2=mapPanel.get(1).get(0);
		mapPanel.get(0).removeAll(false);
		mapPanel.get(1).removeAll(false);
		mapPanel.get(0).add(item2);
		mapPanel.get(1).add(item1);
		mapPanel.get(0).doLayout();
		mapPanel.get(1).doLayout();
		
		if(mapPanel.get(0).get(0)==rptGrid) {
			mapPanel.get(0).get(0).setTitle("报表配置——主");
			mapPanel.get(1).get(0).setTitle("用户配置——从");
			rptStore.setBaseParam("isMaster",1);
			rptStore.setBaseParam("action","getURMapRpt");
			rptStore.load({params:{start:0,limit:50}});
			userStore.setBaseParam("action","getURMapUserByRptCode");
			userStore.removeAll();
			masterGrid=rptGrid;
			Ext.getCmp("delRptBtn").setDisabled(true);
			Ext.getCmp("addRptBtn").setDisabled(true);
		}else if (mapPanel.get(0).get(0)==userGrid) {
			mapPanel.get(0).get(0).setTitle("用户配置——主");
			mapPanel.get(1).get(0).setTitle("报表配置——从");
			userStore.load({params:{start:0,limit:50}});
			userStore.setBaseParam("isMaster",1);
			userStore.setBaseParam("action","getURMapUser");
			userStore.load({params:{start:0,limit:50}});
			rptStore.setBaseParam("action","getURMapRptByUserID");
			rptStore.removeAll();
			masterGrid=userGrid;	
			Ext.getCmp("delUserBtn").setDisabled(true);
			Ext.getCmp("addUserBtn").setDisabled(false);			
			
		}
	}
	
	function init() {
		
		
	}
	
	function OnDelUser() {
		
		if (masterGrid==rptGrid) {
			Ext.MessageBox.confirm('提示框','确定要删除用户吗？',function(btn){
				if(btn=='yes'){
					
					var selRec=rptGrid.getSelectionModel().getSelected();
					var rptCode=selRec.get("rptCode");	
					var selRec=userGrid.getSelectionModel().getSelected();
					var userID=selRec.get("userID");			
			
					dhcwl.mkpi.Util.ajaxExc(serviceUrl,
					{
						action:"delURUser",
						userID:userID,
						rptCode:rptCode
					},function(jsonData){
						if(jsonData.success==true && jsonData.tip=="ok" ){
							//userStore.setBaseParam("rptName",newRptName);
							userStore.reload();
							//reloadStore(userGrid);
						}else{
							Ext.Msg.alert("操作失败",jsonData.MSG);
						}
					},this);				
				}
			});
		}else if (masterGrid==userGrid) {
			Ext.MessageBox.confirm('提示框','确定要删除用户吗？',function(btn){
				if(btn=='yes'){
					
					var selRec=userGrid.getSelectionModel().getSelected();
					var userID=selRec.get("userID");			
			
					dhcwl.mkpi.Util.ajaxExc(serviceUrl,
					{
						action:"delURUser",
						userID:userID
					},function(jsonData){
						if(jsonData.success==true && jsonData.tip=="ok" ){
							//userStore.setBaseParam("rptName",newRptName);
							userStore.reload();
							//reloadStore(userGrid);
							rptStore.removeAll();
						}else{
							Ext.Msg.alert("操作失败",jsonData.MSG);
						}
					},this);				
				}
			});
		}
	}

	function OnDelRpt() {
		if (masterGrid==userGrid) {
			Ext.MessageBox.confirm('提示框','确定要删除报表吗？',function(btn){
				if(btn=='yes'){
					
					var selRec=rptGrid.getSelectionModel().getSelected();
					var rptCode=selRec.get("rptCode");	
					var selRec=userGrid.getSelectionModel().getSelected();
					var userID=selRec.get("userID");			
			
					dhcwl.mkpi.Util.ajaxExc(serviceUrl,
					{
						action:"delURUser",
						userID:userID,
						rptCode:rptCode
					},function(jsonData){
						if(jsonData.success==true && jsonData.tip=="ok" ){
							//userStore.setBaseParam("rptName",newRptName);
							rptStore.reload();
							//reloadStore(userGrid);
						}else{
							Ext.Msg.alert("操作失败",jsonData.MSG);
						}
					},this);				
				}
			});
		}		
		
	}	
	

	this.getUserRightMapPanel=function() {
			return mapPanel;
	}
}

