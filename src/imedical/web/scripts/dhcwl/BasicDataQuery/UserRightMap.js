(function(){
	Ext.ns("dhcwl.BDQ.UserRightMap");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.BDQ.UserRightMap=function(pObj){
	var serviceUrl="dhcwl/basedataquery/dataqrycfg.csp";
	var outThis=this;
	var parentObj=pObj;
	var rptName="";
	var initAttrib;
	var inParam= new Object();
	var userToolPageSize=50;
	var masterGrid;
	
 	var rptCml = new Ext.grid.ColumnModel([
		{header:'报表名称',id:'rptName',dataIndex:'rptName',sortable:true, width: 100, sortable: true,menuDisabled : true},
		{header:'查询对象',id:'BaseObjName',dataIndex:'BaseObjName',sortable:true, width: 150, sortable: true,menuDisabled : true},
		{header:'作者',id:'userName',dataIndex:'userName',sortable:true, width: 150, sortable: true,menuDisabled : true},
		{header:'备注',id:'Remarks',dataIndex:'Remarks',sortable:true, width: 150, sortable: true,menuDisabled : true}
    ]);
    var rptStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:"dhcwl/basedataquery/qryuserright.csp?action=getURMapRpt"}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'BaseObjName'},
            	{name: 'rptName'},
				{name: 'userID'},
				{name: 'Remarks'},
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
		autoExpandColumn: 'Remarks',
		
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
					var rptName=grid.getStore().getAt(rowIndex).get("rptName");
					userStore.setBaseParam("rptName",rptName);
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
	
	

	var userCml = new Ext.grid.ColumnModel([
        {header:'ID',id:'userID',dataIndex:'userID',sortable:true, width: 150, sortable: true,menuDisabled : true},
		{header:'姓名',id:'userName',dataIndex:'userName',sortable:true, width: 100, sortable: true,menuDisabled : true},
		{header:'安全组',id:'userGrp',dataIndex:'userGrp',sortable:true, width: 150, sortable: true,menuDisabled : true}
    ]);
    var userStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:"dhcwl/basedataquery/qryuserright.csp?action=getURMapUserByRptName"}),
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

		var showUserDataObj=new dhcwl.BDQ.ShowUserData();
		var showUserDataWin=showUserDataObj.getUserDataWin();	
		showUserDataObj.onSelCallback=addUser;	
		var inParamObj=new Object();

		if (masterGrid==rptGrid) {
			inParamObj.masterGrid="rptGrid";
			var selRec=rptGrid.getSelectionModel().getSelected();
			var rptName=selRec.get("rptName");				
			inParamObj.rptName=rptName;
		}
		if (masterGrid==userGrid) inParamObj.masterGrid="userGrid";
		showUserDataObj.init(inParamObj);
		
		showUserDataObj.show();
	}
	
	function addUser(paramObj) {
		
		if (masterGrid==rptGrid) {
			var newUserID=paramObj.userID;			
			var selRec=rptGrid.getSelectionModel().getSelected();
			var newRptName=selRec.get("rptName");		

			dhcwl.mkpi.Util.ajaxExc("dhcwl/basedataquery/qryuserright.csp",
			{
				action:"addURUser",
				userID:newUserID,
				rptName:newRptName
			},function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok" ){
					//userStore.setBaseParam("rptName",newRptName);
					userStore.reload();
					//reloadStore(userGrid);
				}else{
					Ext.Msg.alert("操作失败",jsonData.MSG);
				}
			},this);
		}else if (masterGrid==userGrid) {
			var newUserID=paramObj.userID;			
			var selRec=rptGrid.getSelectionModel().getSelected();
			var newRptName="";		

			dhcwl.mkpi.Util.ajaxExc("dhcwl/basedataquery/qryuserright.csp",
			{
				action:"addURUser",
				userID:newUserID,
				rptName:newRptName
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
	}

	function OnAddRpt() {

		var showRptDataObj=new dhcwl.BDQ.ShowRptData();
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
			var newRptName=paramObj.rptName;	
			var selRec=userGrid.getSelectionModel().getSelected();
			var newUserID=selRec.get("userID");


			dhcwl.mkpi.Util.ajaxExc("dhcwl/basedataquery/qryuserright.csp",
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
		}else if (masterGrid==userGrid) {
			var newRptName=paramObj.rptName;	
			var selRec=userGrid.getSelectionModel().getSelected();
			var newUserID=selRec.get("userID");


			dhcwl.mkpi.Util.ajaxExc("dhcwl/basedataquery/qryuserright.csp",
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
			userStore.setBaseParam("action","getURMapUserByRptName");
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
					var rptName=selRec.get("rptName");	
					var selRec=userGrid.getSelectionModel().getSelected();
					var userID=selRec.get("userID");			
			
					dhcwl.mkpi.Util.ajaxExc("dhcwl/basedataquery/qryuserright.csp",
					{
						action:"delURUser",
						userID:userID,
						rptName:rptName
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
			
					dhcwl.mkpi.Util.ajaxExc("dhcwl/basedataquery/qryuserright.csp",
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
					var rptName=selRec.get("rptName");	
					var selRec=userGrid.getSelectionModel().getSelected();
					var userID=selRec.get("userID");			
			
					dhcwl.mkpi.Util.ajaxExc("dhcwl/basedataquery/qryuserright.csp",
					{
						action:"delURUser",
						userID:userID,
						rptName:rptName
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
	
	/*
	function reloadStore(grid,act){
		//store.
		var pageToolBar=grid.getBottomToolbar();
		if (!!pageToolBar) {
			var activePage=0;
			var cur=pageToolBar.cursor;
			var itemCnt=grid.getStore().getCount();
			
			if (act=="del") {
				itemCnt=itemCnt-1;
				var activePage = Math.ceil((pageToolBar.cursor+itemCnt) / pageToolBar.pageSize);	
			}
			
			//else if (act=="add") itemCnt=itemCnt-1;
			
			var activePage = Math.ceil((pageToolBar.cursor) / pageToolBar.pageSize);
			var start=activePage*pageToolBar.pageSize;
			grid.getStore().reload({params:{start:start,limit:pageToolBar.pageSize}});
		}else{
			grid.getStore().reload();
		}
	}
	*/
	this.getUserRightMapPanel=function() {
			return mapPanel;
	}
}

