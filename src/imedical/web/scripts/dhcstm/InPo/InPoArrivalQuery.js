// /����: ������ѯ
// /����: ������ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.10.08
Ext.onReady(function() {
	
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gUserId = session['LOGON.USERID'];	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//��ȡ����������ʼ������ STATR
	Ext.getUrlParam = function(param) {
		var params = Ext.urlDecode(location.search.substring(1));
		return param ? params[param] : params;
	};
	UsrFlag = Ext.getUrlParam('UsrFlag');
	
	//��������
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		width:120,
		groupId:gGroupId,
		emptyText : '��������...',
		stkGrpId : 'StkGrpType',
		childCombo : 'apcVendorField'
	});
	
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				
				width : 120,
				value : new Date().add(Date.DAY, - 7)
			});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '��ֹ����',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				
				width : 120,
				value : new Date()
			});
	
	var StkGrpType = new Ext.ux.StkGrpComboBox({
		id : 'StkGrpType',
		anchor : '90%',
		StkType : App_StkTypeCode,
		LocId : gLocId,
		UserId : gUserId,
		childCombo : 'DHCStkCatGroup'
	});
	
	var DHCStkCatGroup = new Ext.ux.ComboBox({
		fieldLabel : '������',
		id : 'DHCStkCatGroup',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId : 'StkGrpType'}
	});
	
	var NotImp = new Ext.form.Checkbox({
				fieldLabel : 'δ���',
				id : 'NotImp',
				name : 'NotImp',
				anchor : '90%',
				width : 120,
				checked : true
			});
	var PartlyImp = new Ext.form.Checkbox({
		fieldLabel : '�������',
		id : 'PartlyImp',
		name : 'PartlyImp',
		anchor : '90%',
		width : 120,
		checked : true
	});
		
	var AllImp = new Ext.form.Checkbox({
		fieldLabel : 'ȫ�����',
		id : 'AllImp',
		name : 'AllImp',
		anchor : '90%',
		width : 120,
		checked : true
	});
	if (UsrFlag==1){
		var apcVendorField = new Ext.ux.UsrVendorComboBox({
		fieldLabel : '��Ӧ��',
		id : 'apcVendorField',
		name : 'apcVendorField',
		anchor : '90%',
		userId :gUserId,
		emptyText : '��Ӧ��...'
		});
	}else{
		// ��Ӧ��
		var apcVendorField=new Ext.ux.VendorComboBox({
			id : 'apcVendorField',
			name : 'apcVendorField',
			anchor:'90%',
			params : {LocId : 'PhaLoc', ScgId : 'StkGrpType'}
		});
	}
	// �Ƿ���ƽ̨
	var SendSCIflagdata = [['ȫ��','0'],['�ѷ���','1'],['δ����','2']];
	var SendSCIflagStore = new Ext.data.SimpleStore({
		fields : ['SendSCIDesc','SendSCIId'],
		data :  SendSCIflagdata
	});
		
	var SendSCIFlag = new Ext.form.ComboBox({
	    fieldLabel : '�Ƿ���ƽ̨',
	    mode: 'local',
	    id : 'SendSCIFlag',
	    name : 'SendSCIFlag',
	    anchor : '90%',
	    emptyText : '',
	    store : SendSCIflagStore,
	    displayField : 'SendSCIDesc',
	    valueField : 'SendSCIId',
	    triggerAction :'all'/**/
	});
	Ext.getCmp("SendSCIFlag").setValue("0");	
	// ��ѯ������ť
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ����',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
				}
	});
	
	var SaveDetaliBT = new Ext.Toolbar.Button({
				id : "SaveDetaliBT",
				text : '��涩����ϸ��Ϣ',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					if(MasterGrid.getSelectionModel().getSelected ()==undefined||MasterGrid.getSelectionModel().getSelected ()==""){
				      Msg.info("warning","��ѡ�񶩵�!")
					  return;
					}
					var name =MasterGrid.getSelectionModel().getSelected ().get('PoNo')
					ExportAllToExcel(DetailGrid,name);
				}
	});
	var SaveMainBT = new Ext.Toolbar.Button({
				id : "SaveMainBT",
				text : '��涩����Ϣ',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					ExportAllToExcel(MasterGrid,new Date().format(ARG_DATEFORMAT));
				}
	});
	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
				text : '���',
				tooltip : '������',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					clearData();
				}
			});
			
	/**
	 * ��շ���
	 */
	function clearData() {
		SetLogInDept(Ext.getCmp("PhaLoc").getStore(),"PhaLoc");
		Ext.getCmp("apcVendorField").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 7));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("NotImp").setValue(true);
		Ext.getCmp("PartlyImp").setValue(true);
		Ext.getCmp("AllImp").setValue(true);     //���������Ӧ�ûָ�Ĭ��
		Ext.getCmp("StkGrpType").setValue("");
		Ext.getCmp("StkGrpType").getStore().load();
		Ext.getCmp("DHCStkCatGroup").setValue("");
		if(INPoInfoPanel.rendered){
			document.getElementById("frameINPoInfo").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		}
		if(LocInfoPanel.rendered){
			document.getElementById("frameLocInfo").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		}
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

    var SendInPoBT = new Ext.Toolbar.Button({
				id : "SendInPoBT",
				text : '���Ͷ�������ƽ̨',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					    var rowDataArr=MasterGrid.getSelectionModel().getSelections();
					    var rowcount=rowDataArr.length;
						if (Ext.isEmpty(rowDataArr)) {
							Msg.info("warning", "��ѡ����Ҫ���͵Ķ���!");
							return false;
						}
						var PoIdStr="";
						for (var i=0;i<rowcount;i++){
							var rowData=rowDataArr[i];
							var PoId = rowData.get("PoId");
							if (PoIdStr==""){
								PoIdStr=PoId;
							}else{
								PoIdStr=PoIdStr+"^"+PoId;
							}
						}
						if (PoIdStr=="") {
							Msg.info("warning", "��ѡ����Ҫ���͵Ķ���!");
							return false;
						}
						sendinpo(PoIdStr);
					
				}
	});
	function sendinpo(PoIdStr){
		 var url = DictUrl
                    + "inpoaction.csp?actiontype=sendinpo";
            var loadMask=ShowLoadMask(Ext.getBody(),"���Ͷ�����...");
            Ext.Ajax.request({
                        url : url,
                        method : 'POST',
                        params:{InPo:PoIdStr},
                        waitMsg : '������...',
                        success : function(result, request) {
                            var jsonData = Ext.util.JSON
                                    .decode(result.responseText);
                            var infoArr=jsonData.info.split("^");
                            var allcount=infoArr[0];
                            var failcount=infoArr[1];
                            var succount=allcount-failcount;
                            Msg.info("success","��"+allcount+ "����¼�����ͳɹ���"+succount);
                            Query();
                            
                        },
                        scope : this
                    });
            loadMask.hide();
	}
	/// ��������ƽ̨�Ķ�����ϸ
	var CancelInPoiBT = new Ext.Toolbar.Button({
				id : "CancelInPoiBT",
				text : '��������',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					    var rowDataArr=DetailGrid.getSelectionModel().getSelections();
					    var rowcount=rowDataArr.length;
						if (Ext.isEmpty(rowDataArr)) {
							Msg.info("warning", "��ѡ����Ҫ�����Ķ�����ϸ!");
							return false;
						}
						var PoIdiStr="";
						for (var i=0;i<rowcount;i++){
							var rowData=rowDataArr[i];
							var PoItmId = rowData.get("PoItmId");
							if (PoIdiStr==""){
								PoIdiStr=PoItmId;
							}else{
								PoIdiStr=PoIdiStr+"^"+PoItmId;
							}
						}
						if (PoIdiStr=="") {
							Msg.info("warning", "��ѡ����Ҫ�����Ķ�����ϸ!");
							return false;
						}
						cancelinpoi(2,PoIdiStr);
					
				}
	});
	function cancelinpoi(Type,PoIdiStr){
		 var cancelurl = DictUrl
                    + "inpoaction.csp?actiontype=cancelinpoi";
            var loadMask=ShowLoadMask(Ext.getBody(),"������...");
            Ext.Ajax.request({
                        url : cancelurl,
                        method : 'POST',
                        params:{Type:Type,InPo:PoIdiStr},
                        waitMsg : '������...',
                        success : function(result, request) {
                            var jsonData = Ext.util.JSON
                                    .decode(result.responseText);
                            if (jsonData.success == 'true') {
	                            Msg.info("success","�����ɹ���");
	                            Query();
                            }else{
	                            var retinfo=jsonData.info;
	                            Msg.info("success","����ʧ��:"+retinfo);
	                            Query();
	                        }
                            
                        },
                        scope : this
                    });
            loadMask.hide();
	}
	/// �ߵ�
	var UrgeInPoiBT = new Ext.Toolbar.Button({
				id : "UrgeInPoiBT",
				text : '�ߵ�',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					    var rowDataArr=DetailGrid.getSelectionModel().getSelections();
					    var rowcount=rowDataArr.length;
						if (Ext.isEmpty(rowDataArr)) {
							Msg.info("warning", "��ѡ����Ҫ�ߴ��ͻ��Ķ�����ϸ!");
							return false;
						}
						var PoItmStr="";
						for (var i=0;i<rowcount;i++){
							var rowData=rowDataArr[i];
							var PoItmId = rowData.get("PoItmId");
							if (PoItmStr==""){
								PoItmStr=PoItmId;
							}else{
								PoItmStr=PoItmStr+"^"+PoItmId;
							}
						}
						if (PoItmStr=="") {
							Msg.info("warning", "��ѡ����Ҫ�ߴ��ͻ��Ķ�����ϸ!");
							return false;
						}
						urgeinpoi(1,PoItmStr);
					
				}
	});
	function urgeinpoi(type,PoItmStr){
	 	var urgeurl = DictUrl
                    + "inpoaction.csp?actiontype=urgeinpoi";
            var loadMask=ShowLoadMask(Ext.getBody(),"������...");
            Ext.Ajax.request({
                        url : urgeurl,
                        method : 'GET',
                        params:{Type:type,InPo:PoItmStr},
                        waitMsg : '������...',
                        success : function(result, request) {
                            var jsonData = Ext.util.JSON
                                    .decode(result.responseText);
                            if (jsonData.success == 'true') {
	                            Msg.info("success","��Ϣ���ͳɹ���");
	                            //Query();
                            }else{
	                            var retinfo=jsonData.info;
	                            Msg.info("success","��Ϣ����ʧ��:"+retinfo);
	                            Query();
	                        }
                            
                        },
                        scope : this
                    });
            loadMask.hide();
	}

	// ��ʾ��������
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc =='' || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ�񶩹�����!");
			return;
		}
		var startDate = Ext.getCmp("StartDate").getValue();
		if(Ext.isEmpty(startDate)){
			Msg.info('warning', '��ʼ���ڲ���Ϊ��');
			return false;
		}
		startDate = startDate.format(ARG_DATEFORMAT);
		var endDate = Ext.getCmp("EndDate").getValue();
		if(Ext.isEmpty(endDate)){
			Msg.info('warning', '��ֹ���ڲ���Ϊ��');
			return false;
		}
		endDate = endDate.format(ARG_DATEFORMAT);
		var notimp = (Ext.getCmp("NotImp").getValue()==true?0:'');
		var partlyimp = (Ext.getCmp("PartlyImp").getValue()==true?1:'');
		var allimp = (Ext.getCmp("AllImp").getValue()==true?2:'');
		var Vendor = Ext.getCmp("apcVendorField").getValue();
		var Status=notimp+','+partlyimp+','+allimp;
		var Scg = Ext.getCmp('StkGrpType').getValue();
		var Incsc = Ext.getCmp('DHCStkCatGroup').getValue();
		var SendSCIFlag = Ext.getCmp('SendSCIFlag').getValue();
		//��ʼ����^��ֹ����^������^��Ӧ��id^����id^��ɱ�־^��˱�־^����״̬(δ��⣬������⣬ȫ�����)
		var ListParam=startDate+'^'+endDate+'^^'+Vendor+'^'+phaLoc+'^Y^Y^'+Status+'^^'
			+'^^'+userId+'^^N^'+Scg+'^'+Incsc+'^'+SendSCIFlag;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.removeAll();
		DetailGrid.store.removeAll();
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.load({params:{start:0, limit:Page}});
	}
	
	function renderPoStatus(value){
		var PoStatus='';
		if(value==0){
			PoStatus='δ���';
		}else if(value==1){
			PoStatus='�������';
		}else if(value==2){
			PoStatus='ȫ�����';
		}
		return PoStatus;
	}
	// ����·��
	var MasterUrl = DictUrl	+ 'inpoaction.csp?actiontype=Query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["PoId", "PoNo", "PoLoc", "Vendor","PoStatus", "PoDate","PurUserId","StkGrpId","VenId","Email","ReqLocDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoId",
				fields : fields
			});
	// ���ݼ�
	var MasterStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader,
		listeners : {
			load : function(store,records,options){
				if(records.length>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
				}
			}
		}
	});
	var nm = new Ext.grid.RowNumberer();
	var sm =new Ext.grid.CheckboxSelectionModel({});
	var MasterCm = new Ext.grid.ColumnModel([nm,sm, {
				header : "RowId",
				dataIndex : 'PoId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "������",
				dataIndex : 'PoNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'PoLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'ReqLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��Ӧ��",
				dataIndex : 'Vendor',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "����״̬",
				dataIndex : 'PoStatus',
				width : 90,
				align : 'left',
				sortable : true,
				renderer:renderPoStatus
			}, {
				header : "��������",
				dataIndex : 'PoDate',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "��Ӧ������",
				dataIndex : 'Email',
				width : 120,
				align : 'left',
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var MasterGrid = new Ext.ux.GridPanel({
				region:'west',
				collapsible: true,
				split: true,
				width: 400,
				minSize: 175,
				maxSize: 450,
				id : 'MasterGrid',
				title : '����',
				cm : MasterCm,
				sm : sm,
				store : MasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});

	// ��ӱ�񵥻����¼�
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		DetailPanel.fireEvent('tabchange',DetailPanel,DetailPanel.getActiveTab());
//		var PoId = r.get("PoId");
//		var Size=DetailPagingToolbar.pageSize;
//		DetailStore.setBaseParam('Parref',PoId);
//		DetailStore.removeAll();
//		DetailStore.load({params:{start:0,limit:Size}});
	});
	
	// ������ϸ
	// ����·��
	var DetailUrl =DictUrl+
		'inpoaction.csp?actiontype=QueryDetail';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
		url : DetailUrl,
		method : "POST"
	});
	// ָ���в���
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "NotImpQty", "Rp","PurQty","ImpQty",
		"Spec", "ImpQtyAudited", "SpecDesc","Cancleflag","DemandDate","PlatSentFlag"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "PoItmId",
		fields : fields
	});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	var DetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true
	});
		
	var nm = new Ext.grid.RowNumberer();
	var dsm =new Ext.grid.CheckboxSelectionModel({});
	var DetailCm = new Ext.grid.ColumnModel([nm,dsm, {
			header : "������ϸid",
			dataIndex : 'PoItmId',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : "����RowId",
			dataIndex : 'IncId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '���ʴ���',
			dataIndex : 'IncCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'IncDesc',
			width : 230,
			align : 'left',
			sortable : true
		}, {
			header : '���',
			dataIndex : 'Spec',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "��λ",
			dataIndex : 'PurUom',
			width : 40,
			align : 'left',
			sortable : true
		}, {
			header : "����",
			dataIndex : 'Rp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : "��������",
			dataIndex : 'PurQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "����Ƶ�����",
			dataIndex : 'ImpQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "δ��������",
			dataIndex : 'NotImpQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "����������",
			dataIndex : 'ImpQtyAudited',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "������",
			dataIndex : 'SpecDesc',
			width : 80,
			align : 'left'
		}, {
			header : "�Ƿ�������",
			dataIndex : 'Cancleflag',
			width : 80,
			align : 'left'
		}, {
			header : "Ҫ���ʹ�����",
			dataIndex : 'DemandDate',
			width : 80,
			align : 'left'
		}, {
			header : "�Ƿ���ƽ̨",
			dataIndex : 'PlatSentFlag',
			width : 80,
			align : 'left'
		}]);

	var DetailGrid = new Ext.ux.GridPanel({
		id : 'DetailGrid',
		title : '',
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		sm : dsm,///new Ext.grid.RowSelectionModel({singleSelect:true}),
		tbar:new Ext.Toolbar({items:[CancelInPoiBT,UrgeInPoiBT]}),
		bbar:[DetailPagingToolbar]
	});
				
	var HisListTab = new Ext.form.FormPanel({
		region : 'north',
		autoHeight : true,
		title : '�������������ѯ',
		labelWidth : 60,
		labelAlign : 'right',
		frame : true,
		tbar : [SearchBT, '-',  ClearBT,'-',SaveMainBT,'-',SaveDetaliBT,'-',SendInPoBT],
		bodyStyle : 'padding:10px 0px 0px 0px;',
		layout: 'fit',
		items : [{
			xtype : 'fieldset',
			title : '��ѯ��Ϣ',
			layout : 'column',
			autoHeight:true,
			defaults : {border : false},
			items : [{
				columnWidth: 0.25,
				xtype: 'fieldset',
				items: [PhaLoc,apcVendorField,StkGrpType]
			},{
				columnWidth: 0.25,
				xtype: 'fieldset',
				items: [StartDate,EndDate,DHCStkCatGroup]
			},{
				columnWidth: 0.2,
				xtype: 'fieldset',
				items: [AllImp,NotImp,PartlyImp]
			},{
				columnWidth: 0.3,
				xtype: 'fieldset',
				items: [SendSCIFlag]
			}]
		}]
	});
	
	var DetailGridPanel = new Ext.Panel({
		title : '������ϸ',
		id : 'DetailGridPanel',
		layout:'fit',
		items : DetailGrid
	});
	
	var INPoInfoPanel = new Ext.Panel({
		title : '������ϸ',
		id : 'INPoInfoPanel',
		layout:'fit',
		html:'<iframe id="frameINPoInfo" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	
	var LocInfoPanel = new Ext.Panel({
		title : '����������ϸ',
		id : 'LocInfoPanel',
		layout:'fit',
		html:'<iframe id="frameLocInfo" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	
	var DetailPanel = new Ext.TabPanel({
		region: 'center',
		activeTab : 0,
		deferredRender : true,
		items : [DetailGridPanel,INPoInfoPanel,LocInfoPanel],
		listeners : {
			tabchange : function(tabpanel,panel){
				var PoRec = MasterGrid.getSelectionModel().getSelected();
				if(Ext.isEmpty(PoRec)){
					return;
				}
				var PoId = PoRec.get('PoId');
				if(panel.id == 'DetailGridPanel'){
					var Size=DetailPagingToolbar.pageSize;
					DetailStore.setBaseParam('Parref',PoId);
					DetailStore.removeAll();
					DetailStore.load({params:{start:0,limit:Size}});
				}else if(panel.id == 'INPoInfoPanel'){
					var p_URL = PmRunQianUrl+'?reportName=DHCSTM_INPO_ReqInfo.raq'
						+"&Parref=" + PoId;
					var reportFrame=document.getElementById("frameINPoInfo");
					reportFrame.src=p_URL;
				}else if(panel.id == 'LocInfoPanel'){
					var p_URL = PmRunQianUrl+'?reportName=DHCSTM_INPO_ReqLocInfo.raq'
						+"&Parref=" + PoId;
					var reportFrame=document.getElementById("frameLocInfo");
					reportFrame.src=p_URL;
				}
			}
		}
	});

	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[HisListTab, MasterGrid,DetailPanel]
	});
	
	SearchBT.handler();
});