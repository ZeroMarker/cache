// /����: ��������ͳ��
// /����: ҽ������ͳ�Ʒ��Ÿ��Լ�������Ϣ(�����˻�)
// /��д�ߣ�	wangjiabin
// /��д����:2013-12-23
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gIncId='';
	var gStrParam='';	//����չ����ϸʱ�Ĳ���
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	
	ChartInfoAddFun();

	function ChartInfoAddFun() {
		var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '����',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor : '90%',
			groupId:gGroupId,
			stkGrpId : 'StkGrpType'
		});

		var StartDate = new Ext.ux.DateField({
			fieldLabel : '��ʼ����',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			
			value : new Date().add(Date.DAY,-30)
		});
		
		var EndDate = new Ext.ux.DateField({
			fieldLabel : '��ֹ����',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			
			value : new Date()
		});
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			anchor : '90%',
			LocId:gLocId,
			UserId:gUserId,
			childCombo : 'DHCStkCatGroup'
		});
		
		var DHCStkCatGroup = new Ext.ux.ComboBox({
			fieldLabel : '������',
			id : 'DHCStkCatGroup',
			name : 'DHCStkCatGroup',
			store : StkCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{StkGrpId:'StkGrpType'}
		});

		var InciDesc = new Ext.form.TextField({
			fieldLabel : '��������',
			id : 'InciDesc',
			name : 'InciDesc',
			anchor : '90%',
			listeners : {
				specialkey : function(field, e) {
					var keyCode=e.getKey();
					if ( keyCode== Ext.EventObject.ENTER) {
						var stkgrp=Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(),stkgrp);
					}
				}
			}
		});

		/**
		 * �������ʴ��岢���ؽ��
		 */
		function GetPhaOrderInfo(item, stkgrp) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, "", "N", "0", "",getDrugList);
			}
		}
		
		/**
		 * ���ط���
		 */
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			gIncId = record.get("InciDr");
			var inciCode=record.get("InciCode");
			var inciDesc=record.get("InciDesc");
			Ext.getCmp("InciDesc").setValue(inciDesc);
		}
		
		var ChargeFlag = new Ext.form.RadioGroup({
			id: 'ChargeFlag',
			columns: 3,
			anchor : '90%',
			items:[
				{boxLabel:'ȫ��',name:'ChargeFlag',id:'ChargeFlag_All',inputValue:'',checked:true},
				{boxLabel:'�շ�',name:'ChargeFlag',id:'ChargeFlag_Yes',inputValue:'Y'},
				{boxLabel:'���շ�',name:'ChargeFlag',id:'ChargeFlag_No',inputValue:'N'}
			]
		});
		
		var IncludeRet = new Ext.form.Checkbox({
			fieldLabel : '�����˻�',
			id : 'IncludeRet',
			name : 'IncludeRet',
			anchor : '90%',
			checked : true
		});
		
		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '�����ѯ',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				searchData();
			}
		});

		/**
		 * ��ѯ����
		 */
		function searchData() {
			// ��ѡ����
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "���Ҳ���Ϊ�գ�");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var LeadLoc = tkMakeServerCall("web.DHCSTM.Common.UtilCommon","GetLeadLoc",phaLoc);
			if (Ext.isEmpty(LeadLoc)) {
				Msg.info("warning", "֧����Ҳ���Ϊ�գ�");
				return;
			}
			var StartDate = Ext.getCmp("StartDate").getValue();
			if(StartDate==""){
				Msg.info("warning","��ʼ���ڲ���Ϊ��!");
				Ext.getCmp("StartDate").focus();
				return;
			}else{
				StartDate = StartDate.format(ARG_DATEFORMAT).toString();
			}
			var EndDate = Ext.getCmp("EndDate").getValue();
			if(EndDate==""){
				Msg.info("warning","��ֹ���ڲ���Ϊ��!");
				Ext.getCmp("EndDate").focus();
				return;
			}else{
				EndDate = EndDate.format(ARG_DATEFORMAT).toString();
			}
			if(StartDate>EndDate){
				Msg.info("warning","��ʼ���ڴ��ڽ�ֹ����!");
				return;
			}
			
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			
//			if (StkGrpRowId == null || StkGrpRowId.length <= 0) {
//				Msg.info("warning", "���鲻��Ϊ�գ�");
//				Ext.getCmp("StkGrpType").focus();
//				return;
//			}
			
			var DHCStkCatGroup = Ext.getCmp("DHCStkCatGroup").getValue();
			var InciDesc=Ext.getCmp("InciDesc").getValue();
			if(InciDesc==null || InciDesc==""){
				gIncId="";
			}
			var IncludeRet=Ext.getCmp("IncludeRet").getValue()?1:0;
			var LUG="";		//רҵ��
			var ToLoc = phaLoc;		//���տ���
			var ChargeFlag = Ext.getCmp('ChargeFlag').getValue().getGroupValue();
			//sd^ed^�����˻ر�־(0:������,1:����)^loc^userID^������^inci^scg^stkcat
			var strParam = StartDate+"^"+EndDate+"^"+IncludeRet+"^"+LeadLoc+"^"+gUserId
						+"^"+LUG+"^"+gIncId+"^"+StkGrpRowId+"^"+DHCStkCatGroup+"^"+ToLoc
						+"^"+ChargeFlag;
			
			MasterStore.removeAll();
			DetailGrid.store.removeAll();
			MasterStore.setBaseParam("strPar",strParam);
			
			MasterStore.load({
				params:{start:0,limit:999},
				callback:function(r,options,success){
					if(!success){
						Msg.info("error","��ѯ����, ��鿴��־!");
					}else if(r.length>0){
						gStrParam = StartDate+"^"+EndDate+"^"+LeadLoc+"^"+LUG+"^"+gUserId
							+"^^^"+IncludeRet+"^"+ToLoc;
						MasterGrid.getSelectionModel().selectFirstRow();
						MasterGrid.getView().focusRow(0);
					}
				}
			});
		}
				
		// ��հ�ť
		var ClearBT = new Ext.Toolbar.Button({
			text : '���',
			tooltip : '������',
			iconCls : 'page_clearscreen',
			width : 70,
			height : 30,
			handler : function() {
				clearData();
			}
		});

		/**
		 * ��շ���
		 */
		function clearData() {
			gStrParam='';
			SetLogInDept(PhaLoc.getStore(),"PhaLoc");
			Ext.getCmp("StkGrpType").getStore().load();
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-30));
			Ext.getCmp("EndDate").setValue(new Date());
			Ext.getCmp("InciDesc").setValue('');
			Ext.getCmp("DHCStkCatGroup").setValue('');
			gIncId="";
			Ext.getCmp("IncludeRet").setValue(true);
			MasterGrid.store.removeAll();
			//MasterGrid.store.baseParams="";
			//MasterGrid.getBottomToolbar().updateInfo();
			DetailGrid.store.removeAll();
			DetailGrid.store.baseParams="";
			DetailGrid.getBottomToolbar().updateInfo();
		}

		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners:{
				rowselect : function(sm, rowIndex, r) {
					DetailStore.removeAll();
					var inci = MasterStore.getAt(rowIndex).get("inci");
					if(inci==null || inci==""){return;}
					var tmpArr = gStrParam.split("^");
					tmpArr[6] = inci;
					gStrParam = tmpArr.join("^");
					DetailStore.setBaseParam('strPar',gStrParam);
					var pageSize=DetailPagingBar.pageSize;
					DetailStore.load({
						params:{start:0,limit:pageSize},
						callback:function(r,options,success){
							if(!success){
								Msg.info("error","��ϸ��ѯ����, ��鿴��־!");
							}
						}
					});
				}
			}
		});
		var MasterCm = new Ext.grid.ColumnModel([nm,{
					header : "���id",
					dataIndex : 'inci',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '���ʴ���',
					dataIndex : 'InciCode',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : "��������",
					dataIndex : 'InciDesc',
					width : 200,
					align : 'left',
					sortable : false
				}, {
					header : "���",
					dataIndex : 'Abbrev',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : "���",
					dataIndex : 'Spec',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : 'Ʒ��',
					dataIndex : 'Brand',
					width : 80,
					align : 'left',
					sortable : false
				}, {
					header : "�ͺ�",
					dataIndex : 'Model',
					width : 120,
					align : 'left',
					sortable : false
				}, {
					header : '���۽��',
					dataIndex : 'RpAmt',
					width : 100,
					align : 'right',
					sortable : false
				}, {
					header : '��������',
					dataIndex : 'QtyUom',
					width : 120,
					align : 'left',
					sortable : false
				}, {
					header : '�շѱ��',
					dataIndex : 'ChargeFlag',
					xtype : 'checkcolumn',
					width : 80,
					align : 'center'
				}
		]);
		MasterCm.defaultSortable = true;

		// ����·��
		var MasterUrl = DictUrl
					+ 'sublocmatstataction.csp?actiontype=INDispStat';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["inci","InciCode","InciDesc","Abbrev","Spec","Model","Brand","QtyUom","RpAmt","ChargeFlag"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "inci",
					fields : fields
				});
		// ���ݼ�
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					baseParams : {
						ExcludeAlloted : "",
						IncludeAllot : 1
					}
				});

		var MasterGrid = new Ext.ux.GridPanel({
			title: '����(�˻�)����ͳ��',
					id:'MasterGrid',
					region : 'center',
					cm : MasterCm,
					store : MasterStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : sm,
					loadMask : true
				});
				
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, {
					header : "ҵ������",
					dataIndex : 'trType',
					width : 60,
					align : 'left',
					sortable : true,
					renderer:function(v){
						if(v=="C"){
							return "����";
						}else if(v=="L"){
							return "�˻�";
						}else{
							return v;
						}
					}
				}, {
					header : "���ʴ���",
					dataIndex : 'inciCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'inciDesc',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "����~Ч��",
					dataIndex : 'batInfo',
					width : 140,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'manf',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'qty',
					width : 50,
					align : 'right',
					sortable : true
				}, {
					header : "��λ",
					dataIndex : 'uomDesc',
					width : 60,
					align : 'left',
					sortable : true
				}, {
					header : "����(��װ��λ)",
					dataIndex : 'rp',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "���۽��",
					dataIndex : 'rpAmt',
					width : 80,
					align : 'right',
					sortable : true
				},{
					header : "���ŵ���",
					dataIndex : 'indsNo',
					width : 140,
					align : 'left',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'dispDate',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "����ʱ��",
					dataIndex : 'dispTime',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "���쵥��",
					dataIndex : 'dsrqNo',
					width : 140,
					align : 'left',
					sortable : true
				}
			]);
		DetailCm.defaultSortable = false;
		
		// ����·��
		var DetailUrl = DictUrl
					+ 'sublocmatstataction.csp?actiontype=LocUserMatStat';
		// ͨ��AJAX��ʽ���ú�̨����
		var DetailProxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// ָ���в���
		var fieldsDetail = ["trType","inciCode","inciDesc","spec","manf","batInfo",
				{name:"qty",convert:Negative},
				"uomDesc","rp",
				{name:"rpAmt",convert:Negative},
				"dispDate","dispTime","receiver","indsNo","dsrqNo","dsrqDate"
			];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var DetailReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Inclb",
					fields : fieldsDetail
				});
		// ���ݼ�
		var DetailStore = new Ext.data.Store({
					proxy : DetailProxy,
					reader : DetailReader
				});

		var DetailPagingBar = new Ext.PagingToolbar({
					store : DetailStore,
					pageSize : PageSize,
					displayInfo : true
				});
		var DetailGrid = new Ext.ux.GridPanel({
					title : '����(�˻�)��ϸ',
					id : 'DetailGrid',
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					bbar : DetailPagingBar
				});
		
		function Negative(v,rec){
			return -parseFloat(v);
		}
		
		var HisListTab = new Ext.form.FormPanel({
			title: '��������ͳ��',
			width : 300,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 0px 0px 0px;',
			tbar : [SearchBT, '-', ClearBT],
			items : [{
						title:'��ѡ����',
						xtype:'fieldset',
						style:'padding:10px 0px 0px 0px',
						items:[PhaLoc,StartDate,EndDate]
					},
					StkGrpType,
					DHCStkCatGroup,
					InciDesc,
					ChargeFlag,
					IncludeRet
			]
		});

		// ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [{
							region: 'west',
							split: true,
							width: 300,
							minSize: 200,
							maxSize: 350,
							collapsible: true,
							layout: 'fit',
							items: HisListTab
						}, {
							region: 'center',
							layout:'border',
							items:[{
								region:'center',
								layout: 'fit',
								items: MasterGrid
							},{
								region:'south',
								split:true,
								height:200,
								minSize:100,
								maxSize:300,
								layout:'fit',
								items:DetailGrid
							}]
						}
					],
					renderTo : 'mainPanel'
				});
	}
})