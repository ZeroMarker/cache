// /����: ������ε��۵�
// /����: ������ε��۵�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.02.10
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
       var HospId=session['LOGON.HOSPID'];
	var LocId=session['LOGON.CTLOCID'];
	var GroupId=session['LOGON.GROUPID'];
	//var LoginLocId = session['LOGON.COMMUNITYROWID'];   //DTHealth��Ҫ��һ��
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		var InciDr = new Ext.form.TextField({
					fieldLabel : 'ҩƷRowId',
					id : 'InciDr',
					name : 'InciDr',
					anchor : '90%',
					width : 140,
					valueNotFoundText : ''
				});

		var ItmDesc = new Ext.form.TextField({
					fieldLabel : 'ҩƷ����',
					id : 'ItmDesc',
					name : 'ItmDesc',
					anchor:'90%',
					width : 140,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								GetPhaOrderInfo(field.getValue(),
													'');
							}
						}
					}
				});

		// ���۵���
		var AspBatNo = new Ext.form.TextField({
					fieldLabel : '���۵���',
					id : 'AspBatNo',
					name : 'AspBatNo',
					anchor:'90%',
					width : 100
				});

		// ��ʼ����
		var StartDate = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				anchor:'90%',
				width : 120,
				value : new Date().add(Date.DAY,-1)
			});

		// ��������
		var EndDate= new Ext.ux.DateField({
				fieldLabel : '��������',
				id : 'EndDate',
				name : 'EndDate',
				anchor:'90%',
				width : 120,
				value : new Date()
			});

		var TypeStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['N', 'δ���'], ['A', '�����δ��Ч']]
					//['Yes', '����Ч']
				});
		var Type = new Ext.form.ComboBox({
					fieldLabel : '���۵�״̬',
					id : 'Type',
					name : 'Type',
					width : 100,
					anchor:'90%',
					store : TypeStore,
					triggerAction : 'all',
					mode : 'local',
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					editable : false,
					valueNotFoundText : '',
					listeners:{      
                      	'select':function(e){
                                if (e.value=="N")
                                {
	                             	AuditBT.setDisabled(false)  
	                             	CancelAuditBT.setDisabled(true) 
	                            }
                                else if (e.value=="A")
                                {
	                                AuditBT.setDisabled(true)  
	                             	CancelAuditBT.setDisabled(false) 
	                            }
                         
                      	}
					}
				});
		Ext.getCmp("Type").setValue("N");
		
		ReasonForAdjSpStore.load();
		var AdjSpReason = new Ext.form.ComboBox({
					fieldLabel : '����ԭ��',
					id : 'AdjSpReason',
					name : 'AdjSpReason',
					anchor:'90%',
					width : 100,
					store : ReasonForAdjSpStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : false,
					triggerAction : 'all',
					emptyText : '����ԭ��...',
					selectOnFocus : true,
					forceSelection : true,
					listWidth : 150,
					minChars : 1,
					valueNotFoundText : ''
				});
		
		// ��ѯδ��˵��۵���ť
		var SearchBT = new Ext.Toolbar.Button({
					id : "SearchBT",
					text : '��ѯ',
					tooltip : '�����ѯ',
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
						getAspDetail();
					}
				});

		// ��հ�ť
		var ClearBT = new Ext.Toolbar.Button({
					id : "ClearBT",
					text : '����',
					tooltip : '�������',
					width : 70,
					height : 30,
					iconCls : 'page_refresh',
					handler : function() {
						clearData();
					}
				});
		/**
		 * ��շ���
		 */
		function clearData() {
			Ext.getCmp("InciDr").setValue("");
			Ext.getCmp("AspBatNo").setValue("");
			Ext.getCmp("ItmDesc").setValue("");
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-1).format(App_StkDateFormat));
			Ext.getCmp("EndDate").setValue(new Date().format(App_StkDateFormat));

			//Ext.getCmp("SupplyPhaLoc").setDisabled(0);

			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			// �����ť�Ƿ����
			//changeButtonEnable("1^1^1^1^1^0^0^0");
		}

		// ��˰�ť
		var AuditBT = new Ext.Toolbar.Button({
					id : "AuditBT",
					text : '���',
					tooltip : '������',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						
						// ��˵��۵�
						auditOrder();
						// �����ť�Ƿ����
						//changeButtonEnable("0^0^1^1^1^1^1^1");
					}
				});

		/**
		 * ��˵��۵�
		 */
		function auditOrder() {
			//���ѡ����
			var sm = DetailGrid.getSelectionModel();
			var store = DetailGrid.getStore();
			var rowCount = DetailGrid.getStore().getCount();
			var StrAspId="";
			for (var i = 0; i < rowCount; i++) {				
				//ѭ��ÿ��ѡ�������
				if(sm.isSelected(i)){
					var record = store.getAt(i);
					var detailId = record.get('AspBatId');	
					if (record.get('Status')=="�����")
					{
						Msg.info("warning","��ǰΪ�����״̬!");
						return
					}
					if(StrAspId==""){
						StrAspId=detailId;
					}
					else{
						StrAspId=StrAspId+"^"+detailId;
					}
				}
			}
			if(StrAspId==""){
				Msg.info("warning","δ��ѡ��Ҫ��˵ļ�¼!");
				return;
			}		
			var mask=ShowLoadMask(Ext.getBody(),"������...");
			//�ύ���ݿ�ִ�����
			Ext.Ajax.request({
				url : DictUrl+'inadjpriceactionbatch.csp?actiontype=AuditAspBat'
				+'&StrAspId='+StrAspId+'&AuditUser='+userId+"&Params="+GroupId+"^"+LocId,
				method : 'POST',
				success : function(response) {
					var jsonData = Ext.util.JSON.decode(response.responseText);
					mask.hide();
					if(jsonData.info==0){
						Msg.info("success", "��˳ɹ���");
					}
					else if(jsonData.info==-1){
						Msg.info("warning", "���󣺴�������˻�����Ч�ĵ��ۼ�¼!");
						return;
					}else if(jsonData.info==-2){
						Msg.info("warning", "���󣺼ƻ���Ч���ڲ���Ϊ��!");
						return;
					}else if(jsonData.info==-3){
						Msg.info("warning", "���󣺴����Ѿ����ڵ��۵�!");
						return;
					}else if(jsonData.info==-4){
						Msg.info("error", "���󣺸��µ��۵�״̬ʧ��!");
						return;
					}else if(jsonData.info==-5){
						Msg.info("error", "���󣺵��۵���Чʧ��!");
						return;
					}else{
						Msg.info("error", "����:"+jsonData.info);
						return;
					}
					
					getAspDetail();
				},
				failure : function(response){
					Msg.info("error", "��˷�������"+response.responseText);					
					return;
				}
			});		
		}
		
		// ȡ����˰�ť
		var CancelAuditBT = new Ext.Toolbar.Button({
					id : "CancelAuditBT",
					text : 'ȡ�����',
					tooltip : '���ȡ�����',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						cancelAuditOrder();
					}
				});
		
		function cancelAuditOrder(){
			//���ѡ����
			var sm = DetailGrid.getSelectionModel();
			var store = DetailGrid.getStore();
			var rowCount = DetailGrid.getStore().getCount();
			var StrAspId="";
			for (var i = 0; i < rowCount; i++) {				
				//ѭ��ÿ��ѡ�������
				if(sm.isSelected(i)){
					var record = store.getAt(i);
					var detailId = record.get('AspBatId');
					if (record.get('Status')=="δ���")
					{
						Msg.info("warning","��ǰΪδ���״̬!");
						return
					}	
					if(StrAspId==""){
						StrAspId=detailId;
					}
					else{
						StrAspId=StrAspId+"^"+detailId;
					}
				}
			}
			if(StrAspId==""){
				Msg.info("warning","δ��ѡ��Ҫȡ����˵ļ�¼!");
				return;
			}		
			var mask=ShowLoadMask(Ext.getBody(),"������...");
			//�ύ���ݿ�ִ�����
			Ext.Ajax.request({
				url : DictUrl+'inadjpriceactionbatch.csp?actiontype=CancelAuditAPB'
				+'&StrAspId='+StrAspId+'&CancelUser='+userId,
				method : 'POST',
				success : function(response) {
					var jsonData = Ext.util.JSON.decode(response.responseText);
					mask.hide();
					if(jsonData.info==0){
						Msg.info("success", "ȡ����˳ɹ���");
					}
					else if(jsonData.info==-1){
						Msg.info("warning", "���󣺴��ڲ������״̬�ĵ��ۼ�¼!");
						return;
					}else if(jsonData.info==-2){
						Msg.info("error", "���󣺸��µ��۵�״̬ʧ��!");
						return;
					}else{
						Msg.info("error", "����:"+jsonData.info);
						return;
					}
					getAspDetail();
				},
				failure : function(response){
					Msg.info("error", "ȡ����˷�������"+response.responseText);					
					return;
				}
			});
		}
				
		// ������ϸ
		// ����·��
		var DetailUrl =DictUrl+ 'inadjpriceactionbatch.csp?actiontype=QueryAspBatInfo';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
						
		// ָ���в���
		var fields = ["AspBatId","AspBatNo","BatExp","Incib","StkCatDesc", "InciId", "InciCode","InciDesc", 
				 "AspUomDesc","PriorSpUom", "ResultSpUom", "DiffSpUom",
				"PriorRpUom", "ResultRpUom", "DiffRpUom", "AdjDate","Status","ExecuteDate",
				"PreExecuteDate", "AdjReasonId", "AdjReason","Remark",  "AdjUserName","MarkType", "PriceFileNo", "MaxSp"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "AspId",
					fields : fields
				});
		// ���ݼ�
		var DetailStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					baseParams:{
						StartDate:'',
						EndDate:'',
						Others:''
					}
				});
		var detailSM = new Ext.grid.CheckboxSelectionModel();
		//ע��ѡ������¼�
		/*
		detailSM.on('selectionchange',function(thisSM){
				var selRows=thisSM.getCount();
				if(selRows<=0){
					deleteBT.disable();
				}else{
					deleteBT.enable();
				}
		});
		*/
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, detailSM,{
					header : "AspBatId",
					dataIndex : 'AspBatId',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "���۵���",
					dataIndex : 'AspBatNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "Incib",
					dataIndex : 'Incib',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "״̬",
					dataIndex : 'Status',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "������",
					dataIndex : 'StkCatDesc',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : 'ҩƷ����',
					dataIndex : 'InciCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : 'ҩƷ����',
					dataIndex : 'InciDesc',
					width : 230,
					align : 'left',
					sortable : true
				}, {
				       header : "����/Ч��",
				       dataIndex : 'BatExp',
				       width : 150,
				       align : 'left',
				       sortable : true
			       }, {
					header : "���۵�λ",
					dataIndex : 'AspUomDesc',
					width : 60,
					align : 'left',
					sortable : true
				}, {
					header : "��ǰ�ۼ�",
					dataIndex : 'PriorSpUom',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : "�����ۼ�",
					dataIndex : 'ResultSpUom',
					width : 80,
					align : 'right',
					sortable : true		
				}, {
					header : "���(�ۼ�)",
					dataIndex : 'DiffSpUom',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : "��ǰ����",
					dataIndex : 'PriorRpUom',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : "�������",
					dataIndex : 'ResultRpUom',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : "���(����)",
					dataIndex : 'DiffRpUom',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : "�Ƶ�����",
					dataIndex : 'AdjDate',
					width : 80,
					align : 'left',
					sortable : true				
				}, {
					header : "�ƻ���Ч����",
					dataIndex : 'PreExecuteDate',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "ʵ����Ч����",
					dataIndex : 'ExecuteDate',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "����ԭ��",
					dataIndex : 'AdjReasonId',
					width : 100,
					align : 'left',					
					sortable : true,
					renderer : Ext.util.Format.comboRenderer(AdjSpReason)
				}, {
					header : "������",
					dataIndex : 'AdjUserName',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'MarkType',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "����ļ���",
					dataIndex : 'PriceFileNo',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "����ۼ�",
					dataIndex : 'MaxSp',
					width : 90,
					align : 'right',
					sortable : true
				}]);

		var DetailPageToolBar=new Ext.PagingToolbar({
			store:DetailStore,
			pageSize:PageSize,
			displayInfo:true,
			displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg:'û�м�¼',
			firstText:'��һҳ',
			lastText:'���һҳ',
			nextText:'��һҳ',
			prevText:'��һҳ'		
		});
		DetailPageToolBar.addListener('beforechange',function(ptbar,params){
			var selrows=DetailGrid.getSelectionModel().getCount();
			if(selrows>0){
				Msg.info("warning","��ǰҳѡ����Ҫ��˵ļ�¼��������˺��ٷ�ҳ��");
				return false;
			}
		})
		var DetailGrid = new Ext.grid.GridPanel({
					id : 'DetailGrid',
					region : 'center',
					title : '���۵���ϸ(����)',
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					sm :detailSM,
					bbar:DetailPageToolBar
				});

		/**
		 * ����ҩƷ���岢���ؽ��
		 */
		function GetPhaOrderInfo(item, group) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
						getDrugList);
			}
		}

		/**
		 * ���ط���
		*/
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var inciDr = record.get("InciDr");
			var inciCode=record.get("InciCode");
			var inciDesc=record.get("InciDesc");
			;
			Ext.getCmp("ItmDesc").setValue(inciDesc);
			Ext.getCmp('InciDr').setValue(inciDr);			
			;			
		}
		
	
		// �任����ɫ
		function changeBgColor(row, color) {
			DetailGrid.getView().getRow(row).style.backgroundColor = color;
		}

		// �����ť�Ƿ����
		function changeButtonEnable(str) {
			var list = str.split("^");
			for (var i = 0; i < list.length; i++) {
				if (list[i] == "1") {
					list[i] = false;
				} else {
					list[i] = true;
				}
			}
			/*
			SearchInItBT.setDisabled(list[0]);
			SearchRqNoBT.setDisabled(list[1]);
			ClearBT.setDisabled(list[2]);
			AddBT.setDisabled(list[3]);
			SaveBT.setDisabled(list[4]);
			DeleteBT.setDisabled(list[5]);
			DeleteDrugBT.setDisabled(list[6]);
			CheckBT.setDisabled(list[7]);
			*/
		}

		// ��ʾ���۵�����
		function getAspDetail() {
			var InciDesc=Ext.getCmp("ItmDesc").getValue();
			var InciRowid="";
			if(InciDesc!=null & InciDesc!="" & InciDesc.length >0){
				InciRowid=Ext.getCmp("InciDr").getValue();
			}			
			var AspNo=Ext.getCmp("AspBatNo").getValue();
			var StartDate=Ext.getCmp("StartDate").getValue();
			var EndDate=Ext.getCmp("EndDate").getValue();
			var Status=Ext.getCmp("Type").getValue();
			var Others=AspNo+"^"+Status+"^"+InciRowid+"^"
			if (StartDate == null || StartDate.length <= 0 ) {
				Msg.info("warning", "��ʼ���ڲ���Ϊ�գ�");
				Ext.getCmp("StartDate").focus();
				return;
			}
			else{
				StartDate=StartDate.format(App_StkDateFormat);
			}
			if (EndDate == null || EndDate.length <= 0 ) {
				Msg.info("warning", "��ֹ���ڲ���Ϊ�գ�");
				Ext.getCmp("EndDate").focus();
				return;
			}
			else{
				EndDate=EndDate.format(App_StkDateFormat);
			}
			
			DetailStore.setBaseParam("StartDate",StartDate);
			DetailStore.setBaseParam("EndDate",EndDate);
			DetailStore.setBaseParam("Others",Others);
			var pagesize=DetailPageToolBar.pageSize;
			DetailStore.removeAll();
			DetailStore.load({params:{start:0,limit:pagesize}});
	
			// �����ť�Ƿ����
			//changeButtonEnable("0^0^1^1^1^1^1^1");
		}
		
		var HisListTab = new Ext.form.FormPanel({
			labelWidth : 80,
			labelAlign : 'right',
			autoHeight:true,
			frame : true,
			title:'���۵����(����)',
			tbar : [SearchBT, '-', ClearBT, '-',  AuditBT, '-', CancelAuditBT],
			items : [{					
					xtype : 'fieldset',
					title : '��ѯ����',
					style: 'padding-top:5px;padding-bottom:5px',
					defaults:{border:false},
					layout : 'column',									
					items : [{
						columnWidth : .25,
						xtype : 'fieldset',
						items : [StartDate,EndDate]
					},{
						columnWidth : .3,
						xtype : 'fieldset',
						items : [AspBatNo,ItmDesc]
					},{
						columnWidth : .25,
						xtype : 'fieldset',
						items : [Type]
					}]								
			}]
					
		});

		// ҳǩ
		var panel = new Ext.Panel({
					activeTab : 0,
					height : 160,
					region : 'north',
					layout:'fit',
					items : [HisListTab]
				});

		// ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [panel, DetailGrid],
					renderTo : 'mainPanel'
				});
				
		getAspDetail();    //ҳ����غ���ʾδ��˵���

})