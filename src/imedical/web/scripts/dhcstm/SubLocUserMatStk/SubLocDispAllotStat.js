// /名称: 入库汇总统计条件录入
// /描述:  入库汇总统计条件录入
// /编写者：wangjiabin
// /编写日期: 2014.02.27
Ext.onReady(function() {
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	var inciDr="";
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : '科室...',
		groupId:gGroupId
	});
	
	var ToLoc = new Ext.ux.ComboBox({
		id:'ToLoc',
		fieldLabel:'接收科室',
		emptyText:'接收科室...',
		triggerAction : 'all',
		store : LeadLocStore,
		valueParams : {groupId : gGroupId},
		filterName : 'locDesc',
		childCombo : ['UserList', 'UserGrp']
	});
	//SetLogInDept(ToLoc.getStore(),'ToLoc');
	
	var lastMon = new Date().add(Date.MONTH,-1);
	var firstDay = lastMon.getFirstDateOfMonth();
	var lastDay = lastMon.getLastDateOfMonth();
	
	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '开始日期',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		
		value : firstDay
	});
	
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '截止日期',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		
		value : lastDay
	});
	
	var UserGrp = new Ext.ux.ComboBox({
		fieldLabel:'专业组',	
		id:'UserGrp',
		anchor : '90%',
		store:UserGroupStore,
		valueField:'RowId',
		displayField:'Description',
		params : {SubLoc : 'ToLoc'}
	});
	
	var UserList = new Ext.ux.ComboBox({
		fieldLabel:'领用人',	
		id:'UserList',
		anchor : '90%',
		store:UStore,
		valueField:'RowId',
		displayField:'Description',
		params : {locId : 'ToLoc'}
	});
	
	var DispAllotFlag = new Ext.form.RadioGroup({
		id:'DispAllotFlag',
		columns:1,
		itemCls: 'x-check-group-alt',
		items:[
			{boxLabel:'发放公支统计',name:'DispAllotFlag',id:'DispAllot',inputValue:1,checked:true},
			{boxLabel:'公支明细',name:'DispAllotFlag',id:'AllotDetail',inputValue:2},
			{boxLabel:'个人明细&医嘱统计',name:'DispAllotFlag',id:'DispAndOeori',inputValue:3}
		]
	});
	
	var ClearBT = new Ext.Toolbar.Button({
			id : "ClearBT",
			text : '清空',
			tooltip : '点击清空',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				Ext.getCmp('HisListTab').getForm().items.each(function(f){ 
					f.setValue("");
				});
				
				SetLogInDept(PhaLoc.getStore(),'PhaLoc');
				//SetLogInDept(ToLoc.getStore(),'ToLoc');
				Ext.getCmp("DateFrom").setValue(new Date().add(Date.DAY,-30));
				Ext.getCmp("DateTo").setValue(new Date());
				
				document.getElementById("frameReport").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
			}
		});
		// 确定按钮
		var OkBT = new Ext.Toolbar.Button({
					id : "OkBT",
					text : '统计',
					tooltip : '点击统计',
					width : 70,
					iconCls : 'page_find',
					height : 30,
					handler : function() {
						ShowReport();
					}
				}); 

		function ShowReport(){   
			var StartDate=Ext.getCmp("DateFrom").getValue();
			if(StartDate==""){
				Msg.info("warning","起始日期不可为空!");
				return;
			}else{
				StartDate=StartDate.format(ARG_DATEFORMAT);
			}
			var EndDate=Ext.getCmp("DateTo").getValue();
			if(EndDate==""){
				Msg.info("warning","截止日期不可为空!");
				return;
			}else{
				EndDate=EndDate.format(ARG_DATEFORMAT);
			}
			var LocId=Ext.getCmp("PhaLoc").getValue();
			var LUG=Ext.getCmp("UserGrp").getValue();
			var User=Ext.getCmp("UserList").getValue();
			var ToLoc = Ext.getCmp("ToLoc").getValue();
			var DispAllotFlag = Ext.getCmp('DispAllotFlag').getValue().getGroupValue();
			var reportFrame=document.getElementById("frameReport");
			if(DispAllotFlag == 1){
				var p_URL = PmRunQianUrl+'?reportName=DHCSTM_SubLocDispAllotStat.raq'
					+'&SD='+StartDate +'&ED='+EndDate+'&SubLoc='+LocId+'&LUG='+LUG+'&User='+User
					+'&ToLoc='+ToLoc;
			}else if(DispAllotFlag == 2){
				var p_URL = PmRunQianUrl+'?reportName=DHCSTM_SubLocAllotDetail.raq'
					+'&SD='+StartDate +'&ED='+EndDate+'&SubLoc='+LocId+'&LUG='+LUG+'&User='+User
					+'&ToLoc='+ToLoc;
			}else if(DispAllotFlag == 3){
				var p_URL = PmRunQianUrl+'?reportName=DHCSTM_SubLocDispAndOeori.raq'
					+'&SD='+StartDate +'&ED='+EndDate+'&SubLoc='+LocId+'&User='+User
					+'&ToLoc='+ToLoc;
			}else{
				var p_URL = PmRunQianUrl+'?reportName=DHCSTM_SubLocDispAllotStat.raq'
					+'&SD='+StartDate +'&ED='+EndDate+'&SubLoc='+LocId+'&LUG='+LUG+'&User='+User
					+'&ToLoc='+ToLoc;
			}
			reportFrame.src=p_URL;
		}
		
		var HisListTab = new Ext.form.FormPanel({
			id : 'HisListTab',
			labelWidth : 60,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:5px;',
			tbar : [OkBT,'-',ClearBT],
			items : [{
						xtype : 'fieldset',
						title : '查询条件',
						items : [PhaLoc,DateFrom,DateTo,ToLoc,UserGrp,UserList]
					},{
						xtype : 'fieldset',
						title : '报表类型',
						items : [DispAllotFlag]
					}]
		});

		var reportPanel=new Ext.Panel({
			layout:'fit',
			html:'<iframe id="frameReport" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		})
		// 页面布局
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [{
						region:'west',
						title:"发放公支汇总",
						width:300,
						split:true,
						collapsible:true,
						minSize:250,
						maxSize:350,
						layout:'fit',
						items:HisListTab
					},{
						region:'center',
						layout:'fit',
						items:reportPanel
					}]
				});

});