// /����: ������ͳ������¼��
// /����:  ������ͳ������¼��
// /��д�ߣ�wangjiabin
// /��д����: 2014.02.27
Ext.onReady(function() {
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	var inciDr="";
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : '����...',
		groupId:gGroupId
	});
	
	var ToLoc = new Ext.ux.ComboBox({
		id:'ToLoc',
		fieldLabel:'���տ���',
		emptyText:'���տ���...',
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
		fieldLabel : '��ʼ����',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		
		value : firstDay
	});
	
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '��ֹ����',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		
		value : lastDay
	});
	
	var UserGrp = new Ext.ux.ComboBox({
		fieldLabel:'רҵ��',	
		id:'UserGrp',
		anchor : '90%',
		store:UserGroupStore,
		valueField:'RowId',
		displayField:'Description',
		params : {SubLoc : 'ToLoc'}
	});
	
	var UserList = new Ext.ux.ComboBox({
		fieldLabel:'������',	
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
			{boxLabel:'���Ź�֧ͳ��',name:'DispAllotFlag',id:'DispAllot',inputValue:1,checked:true},
			{boxLabel:'��֧��ϸ',name:'DispAllotFlag',id:'AllotDetail',inputValue:2},
			{boxLabel:'������ϸ&ҽ��ͳ��',name:'DispAllotFlag',id:'DispAndOeori',inputValue:3}
		]
	});
	
	var ClearBT = new Ext.Toolbar.Button({
			id : "ClearBT",
			text : '���',
			tooltip : '������',
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
		// ȷ����ť
		var OkBT = new Ext.Toolbar.Button({
					id : "OkBT",
					text : 'ͳ��',
					tooltip : '���ͳ��',
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
				Msg.info("warning","��ʼ���ڲ���Ϊ��!");
				return;
			}else{
				StartDate=StartDate.format(ARG_DATEFORMAT);
			}
			var EndDate=Ext.getCmp("DateTo").getValue();
			if(EndDate==""){
				Msg.info("warning","��ֹ���ڲ���Ϊ��!");
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
						title : '��ѯ����',
						items : [PhaLoc,DateFrom,DateTo,ToLoc,UserGrp,UserList]
					},{
						xtype : 'fieldset',
						title : '��������',
						items : [DispAllotFlag]
					}]
		});

		var reportPanel=new Ext.Panel({
			layout:'fit',
			html:'<iframe id="frameReport" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		})
		// ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [{
						region:'west',
						title:"���Ź�֧����",
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