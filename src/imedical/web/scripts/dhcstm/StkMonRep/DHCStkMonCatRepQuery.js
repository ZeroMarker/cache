// /����: �±�ͳ�Ʊ���ƾ֤����
// /����: �±�ͳ�Ʊ���ƾ֤����
// /��д�ߣ�zhangdongmei
// /��д����: 2012.11.23
	
	//��ѡ��������ؼ�ʱ,�����޸Ĵ�ȫ�ֱ���
	var SCGTYPE = 'M';		//��������(��������M,��������O)
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var Url=DictUrl	+ 'stkmonaction.csp?';
	var today=new Date();
	var gIncid="";

	var PhaLoc = new Ext.ux.LocComboBox({
		id : 'PhaLoc',
		name : 'PhaLoc',
		fieldLabel : '����',
		listWidth : 200,
		groupId:gGroupId,
		stkGrpId : 'StkGrpType'
	});

	var StYear=new Ext.form.TextField({
		fieldLabel:'��ʼ���·�',
		id:'StYear',
		name:'StYear',
		anchor:'90%',
		width:80,
		value:today.getFullYear()
	});
	var StMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'StMonth',
		name:'StMonth',
		anchor:'90%',
		width:80,
		value:((today.getMonth()-10)<=0?1:(today.getMonth()-10))
	});
	
	var EdYear=new Ext.form.TextField({
		fieldLabel:'�������·�',
		id:'EdYear',
		name:'EdYear',
		anchor:'90%',
		width:80,
		value:today.getFullYear()
	});
	
	var EdMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'EdMonth',
		name:'EdMonth',
		anchor:'90%',
		width:80,
		value:(today.getMonth()+1)
	});
	
	var FinancialFlag = new Ext.form.Checkbox({
		fieldLabel :'��������',
		listeners : {
			check : function(checkbox, checked){
				SCGTYPE = checked ? 'O' : 'M';
				Ext.getCmp('IncStkCat').setValue('');
				Ext.getCmp('StkGrpType').setValue('');
				Ext.getCmp('StkGrpType').StkType = SCGTYPE;
				Ext.getCmp('StkGrpType').getStore().reload();
			}
		}
	})
	
	// ��������
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType : SCGTYPE,
		listWidth : 200,
		LocId:gLocId,
		UserId:gUserId,
		anchor:'90%',
		childCombo : 'IncStkCat'
	});
	
	var IncStkCat=new Ext.ux.ComboBox({
		id:'IncStkCat',
		name:'IncStkCat',
		store:StkCatStore,
		displayField:'Description',
		valueField:'RowId',
		emptyText:'������',
		params:{StkGrpId:'StkGrpType'}
	});
	var IncDesc=new Ext.form.TextField({
		id:'IncDesc',
		name:'IncDesc',
		emptyText:'��������',
		width:150,
		listeners:{
			'specialkey':function(field,e){
				if(e.getKey()==Ext.EventObject.ENTER){
					var stkgrp = Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderWindow(field.getValue(), stkgrp, App_StkTypeCode, "", "N", "0", "",getDrugList);
				}
			}
		}
	});
	
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		gIncId = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("IncDesc").setValue(inciDesc);
	}
	var Filter=new Ext.ux.Button({
		id:'filter',
		text:'ɸѡ',
		iconCls : 'page_find',
		anchor:'90%',
		handler:function(){
				MonRepFilter();
			}
	});
	//��������,������,�������Ƶı仯,  �����±���ϸ
	function MonRepFilter(){
		var panel=tabPanel.getActiveTab()
		if(panel.id=="ReportInIsStkCatRp"||panel.id=="ReportInIsStkScgRp"||panel.id=="ReportCatRp"||panel.id=="ReportScgRp"){
			gIncid=""
			Ext.getCmp("IncDesc").setValue("");
			Ext.getCmp("IncDesc").setDisabled(true)
			}
		else{
			Ext.getCmp("IncDesc").setDisabled(false)
		}
		
		var record=MainGrid.getSelectionModel().getSelected();
		if(record){
			var rowid=record.get("smRowid");
			var stkgrpid=Ext.getCmp("StkGrpType").getValue();
			var stkcatid=Ext.getCmp("IncStkCat").getValue();
			var incdesc=Ext.getCmp("IncDesc").getValue();
			var ParamStr =stkgrpid+"^"+stkcatid+"^"+incdesc+"^"+SCGTYPE;
			if(panel.id=="ReportInIsStkCatRp"){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_ReportInIsStkCatRp.raq'
					+"&sm="+rowid+"&ParamStr="+ParamStr+"&HospDesc="+App_LogonHospDesc;
				var reportFrame=document.getElementById("frameReportInIsStkCatRp");
				reportFrame.src=p_URL;
			}else if(panel.id=="ReportInIsStkScgRp"){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_ReportInIsStkScgRp.raq'
					+"&sm="+rowid+"&ParamStr="+ParamStr+"&HospDesc="+App_LogonHospDesc;
				var reportFrame=document.getElementById("frameReportInIsStkScgRp");
				reportFrame.src=p_URL;
				
			}else if(panel.id=="ReportCatRp"){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_ReportCatRp.raq'
					+"&sm="+rowid+"&ParamStr="+ParamStr+"&HospDesc="+App_LogonHospDesc;
				var reportFrame=document.getElementById("frameReportCatRp");
				reportFrame.src=p_URL;
				
			}else if(panel.id=="ReportScgRp"){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_ReportScgRp.raq'
					+"&sm="+rowid+"&ParamStr="+ParamStr+"&HospDesc="+App_LogonHospDesc;
				var reportFrame=document.getElementById("frameReportScgRp");
				reportFrame.src=p_URL;
				
			}else if(panel.id=="ReportRp"){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_ReportRp.raq'
					+"&sm="+rowid+"&ParamStr="+ParamStr+"&HospDesc="+App_LogonHospDesc;
				var reportFrame=document.getElementById("frameReportRp");
				reportFrame.src=p_URL;
				
			}else if(panel.id=="ReportLbRp"){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_ReportLbRp.raq'
					+"&sm="+rowid+"&ParamStr="+ParamStr+"&HospDesc="+App_LogonHospDesc;
				var reportFrame=document.getElementById("frameReportLbRp");
				reportFrame.src=p_URL;
				
			}
		}
	}
	 // �ύ
	var Submit = new Ext.ux.Button({
				id : "Submit",
				text : 'ƾ֤�����ύ',
				tooltip : '����ύ',
				iconCls : 'page_gear',
				handler : function() {  
					var gridSelected =Ext.getCmp("MainGrid"); 
					var rows=MainGrid.getSelectionModel().getSelections() ; 
					if(rows.length==0){
						Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�ύ���±���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}else 
					{
						var selectedRow = rows[0];
						var smRowid = selectedRow.get("smRowid");
						
						Ext.Ajax.request({
							url:DictUrl+'stkmonaction.csp?actiontype=Submit&smRowid='+smRowid+'&UserId='+gUserId,
							waitMsg:'������...',
							failure: function(result, request) {
								Msg.info("error", "������������!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", "�ύ�ɹ�!");
									Query();
								}else{
									if(jsonData.info==-1)
									{
										Msg.info('warning','��ǰ״̬�������ύ!');
									}
									else
									{
										Msg.info("error", "�ύʧ��!");
									}
								}
							},
							scope: this
						});
					}
				}
			});
	// ȡ���ύ
	var CancelSubmit = new Ext.ux.Button({
				id : "CancelSubmit",
				text : 'ȡ���ύ',
				tooltip : '���ȡ���ύ',
				iconCls : 'page_gear',
				handler : function() {  
					var gridSelected =Ext.getCmp("MainGrid"); 
					var rows=MainGrid.getSelectionModel().getSelections() ; 
					if(rows.length==0){
						Ext.Msg.show({title:'����',msg:'��ѡ��Ҫȡ���ύ���±���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}else 
					{
						var selectedRow = rows[0];
						var smRowid = selectedRow.get("smRowid");
						
						Ext.Ajax.request({
							url:DictUrl+'stkmonaction.csp?actiontype=CancelSubmit&smRowid='+smRowid+'&UserId='+gUserId,
							waitMsg:'������...',
							failure: function(result, request) {
								Msg.info("error", "������������!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", "ȡ���ɹ�!");
									Query();
								}else{
									if(jsonData.info==-1)
									{
										Msg.info('warning','��ǰ״̬������ȡ���ύ!');
									}
									else
									{
										Msg.info("error", "ȡ��ʧ��!");
									}
								}
							},
							scope: this
						});
					}
				}
			});
		// ��ѯ��ť
	var SearchBT = new Ext.ux.Button({
				id : "SearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ',
				iconCls : 'page_find',
				handler : function() {  
					Query();
				}
			});
	//��ѯ�±�
	function Query(){
		var stYear=Ext.getCmp('StYear').getValue();
		var stMonth=Ext.getCmp('StMonth').getValue();
		var stDate=stYear+'-'+stMonth+'-'+'01';
		var edYear=Ext.getCmp('EdYear').getValue();
		var edMonth=Ext.getCmp('EdMonth').getValue();
		var edDate=edYear+'-'+edMonth+'-'+'01';
		var Loc=Ext.getCmp('PhaLoc').getValue();
		MainStore.removeAll();
		MainStore.load({params:{LocId:Loc,StartDate:stDate,EndDate:edDate}});
	}
   
	
	var MainStore=new Ext.data.JsonStore({
		auroDestroy:true,
		url:Url+"actiontype=Query",
		sotreId:'MainStore',
		root:'rows',
		totalProperty:'results',
		idProperty:'smRowid',
		fields:['smRowid','locDesc','mon','frDate','frTime','toDate','toTime',
				'StkMonNo','AcctVoucherCode','AcctVoucherDate','AcctVoucherStatus','PdfFile']
	});
	
	var MainGrid=new Ext.ux.GridPanel({
		id:'MainGrid',
		title:'�±�',
		tbar : [Submit,CancelSubmit],
		region:'center',
		store:MainStore,
		cm:new Ext.grid.ColumnModel([{
			header:'Rowid',
			dataIndex:'smRowid',
			width:100,
			align:'left',
			hidden:true
		},{
			header:'����',
			dataIndex:'locDesc',
			width:120,
			align:'left',
			sortable:true
		},{
			header:'�·�',
			dataIndex:'mon',
			width:100,
			align:'left',
			sortable:true
		},{
			header:'�±���ʼ����',
			dataIndex:'frDate',
			width:100,
			align:'left',
			sortable:true,
			renderer:function(value,metaData,record,rowIndex,colIndex,store){
				var StDateTime=value+" "+record.get('frTime');
				return StDateTime;
			}
		},{
			header:'�±���ֹ����',
			dataIndex:'toDate',
			width:100,
			align:'left',
			sortable:true,
			renderer:function(value,metaData,record,rowIndex,colIndex,store){
				var EdDateTime=value+" "+record.get('toTime');
				return EdDateTime;
			}
		},{
				header:'�±���',
				dataIndex:'StkMonNo',
				width:140,
				align:'left',
				sortable:true
			},{
				header:'ƾ֤��',
				dataIndex:'AcctVoucherCode',
				width:120,
				align:'left',
				sortable:true
			},{
				header:'ƾ֤����',
				dataIndex:'AcctVoucherDate',
				width:100,
				align:'left',
				sortable:true
			},{
				header:'ƾ֤����״̬',
				dataIndex:'AcctVoucherStatus',
				width:80,
				align:'left',
				sortable:true
			},{
				header:'Pdf�ļ�����',
				dataIndex:'PdfFile',
				width:100,
				align:'left',
				sortable:true
			}]),
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		listeners : {
			rowcontextmenu : function(grid,rowindex,e){
			    e.preventDefault();
				grid.getSelectionModel().selectRow(rowindex);
				rightClick.showAt(e.getXY());
			}
		}
	})
	
	//�һ��¼�
	var rightClick = new Ext.menu.Menu({
		id:'rightClickCont',
		items: [{
		    id: 'mnuVoucherStatus',
			handler: VoucherStatusShow,
			text: 'ƾ֤��¼'
		}]
	});
    function VoucherStatusShow() {
		var gridSelected =Ext.getCmp("MainGrid"); 
		var rows=MainGrid.getSelectionModel().getSelections() ; 
		if(rows.length==0){
			Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�鿴���±���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}else {
			var selectedRow = rows[0];
			var smRowid = selectedRow.get("smRowid");
			VoucherStatusQuery(smRowid);
		}
	}
	
	var mainForm = new Ext.ux.FormPanel({
		title:'�±�ͳ�Ʊ���ƾ֤����',
		tbar : [SearchBT],
		region:'north',
		height:200,
		items:[PhaLoc,
				{
					xtype: 'compositefield',								
					items : [StYear,StMonth]
				},
				{
					xtype: 'compositefield',								
					items : [EdYear,EdMonth]
				},
			FinancialFlag]						
	});
	

	var tabPanel=new Ext.TabPanel({
		region:'center',
		activeTab:0,
		tbar:new Ext.Toolbar({items:[StkGrpType,IncStkCat,IncDesc,Filter]}),
		items:[{
			title:'�������(����/������)',
			id:'ReportInIsStkCatRp',
			html:'<iframe id="frameReportInIsStkCatRp" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		},{
			title:'�������(����/����)',
			id:'ReportInIsStkScgRp',
			html:'<iframe id="frameReportInIsStkScgRp" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		},{
			title:'�±�����(������)',
			id:'ReportCatRp',
			html:'<iframe id="frameReportCatRp" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		},{
			title:'�±�����(����)',
			id:'ReportScgRp',
			html:'<iframe id="frameReportScgRp" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		},{
			title:'�±���ϸ',
			id:'ReportRp',
			html:'<iframe id="frameReportRp" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		},{
			title:'�±�������ϸ',
			id:'ReportLbRp',
			html:'<iframe id="frameReportLbRp" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		}]
	})
	MainGrid.addListener('rowclick',function(grid,rowindex,e){
		MonRepFilter();
	});
	tabPanel.addListener('tabchange',function(tabpanel,panel){
		MonRepFilter();
	});
	var panel=new Ext.Panel({
		region:"west",
		width:300,
		layout:'border',
		items : [mainForm,MainGrid]
	});
	Ext.onReady(function() {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		var myPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [panel,tabPanel]
		});
		Query();
	});
