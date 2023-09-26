// /����: ���䵥���
// /��д�ߣ�wangjiabin
// /��д����: 2014.02.22
var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	// ����
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '����',
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				emptyText : '����...',
				groupId:session['LOGON.GROUPID'],
				stkGrpId : 'StkGrpType'
			});

		var uGroupList=new Ext.data.Store({		 
			url:"dhcstm.sublocusergroupaction.csp?actiontype=FilterLocGroupList",
			reader:new Ext.data.JsonReader({
				totalProperty:'results',
				root:"rows",
				idProperty:'RowId'
			},['RowId','Description']),
			baseParams:{'SubLoc':Ext.getCmp('PhaLoc').getValue()}
		});
		//רҵ��
		var UserGrp = new Ext.ux.ComboBox({
			fieldLabel : 'רҵ��',
			id : 'UserGrp',
			name : 'UserGrp',
			store : uGroupList,
			valueField:'RowId',
			displayField:'Description',
			params:{SubLoc:'PhaLoc'}
		});
			
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				
				anchor : '90%',
				value : new Date().add(Date.DAY, -30)
			});

	// ��������
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '��������',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				
				value : new Date()
			});
	//����
	var StkGrpType = new Ext.ux.StkGrpComboBox({ 
				id : 'StkGrpType',
				name : 'StkGrpType',
				StkType:App_StkTypeCode,
				anchor : '90%',
				LocId:gLocId,
				UserId:gUserId
			});
	
	var AuditFlag = new Ext.form.Checkbox({
				hiddenLabel : true,
				boxLabel : '�����',
				id : 'AuditFlag',
				name : 'AuditFlag',
				anchor : '90%',
				checked : false,
				listeners : {
					check : function(chk,checked){
						Ext.getCmp("DateFlag").setDisabled(!checked);
						if(!checked){
							Ext.getCmp("DateFlag").setValue(false);
						}
					}
				}
			});

	var DateFlag = new Ext.form.Checkbox({
				hiddenLabel : true,
				boxLabel : '���������ͳ��',
				id : 'DateFlag',
				anchor : '90%',
				disabled : true
			});
			
	// ������ť
	var SearchBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '�����ѯ���䵥��Ϣ',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					searchDurgData();
				}
			});

	function searchDurgData() {
		var StartDate = Ext.getCmp("StartDate").getValue();
		if((StartDate!="")&&(StartDate!=null)){
			StartDate=StartDate.format(ARG_DATEFORMAT);
		}
		var EndDate = Ext.getCmp("EndDate").getValue();
		if((EndDate!="")&&(EndDate!=null)){
			EndDate=EndDate.format(ARG_DATEFORMAT);
		}
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();
		var UserGrp = Ext.getCmp("UserGrp").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", "��ѡ�����!");
			return;
		}
		
		if(StartDate==""||EndDate==""){
			Msg.info("warning", "��ѡ��ʼ���ںͽ�ֹ����!");
			return;
		}
		var Comp="Y";
		var Audit=Ext.getCmp("AuditFlag").getValue()==true?"Y":"N";
		var StkGrpId=Ext.getCmp("StkGrpType").getValue();
		var DateFlag=Ext.getCmp("DateFlag").getValue()?"Y":"N";
		var ListParam=StartDate+'^'+EndDate+'^'+PhaLoc+'^'+UserGrp+'^'+Comp+'^'+Audit+"^"+StkGrpId+"^"+DateFlag;
		var Page=MasterToolbar.pageSize;
		MasterStore.setBaseParam('StrParam',ListParam)
		MasterStore.removeAll();
		DetailStore.removeAll();
		ScaleStore.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options, success){
				if(!success){
     				Msg.info("error", "��ѯ������鿴��־!");
     			}else{
     				if(r.length>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
     				}
     			}
			}
		});
	}
	
	// ���ȷ�ϰ�ť
	var AuditBT = new Ext.Toolbar.Button({
				id:'AuditBT',
				text : '���ͨ��',
				tooltip : '������ͨ��',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					var SelRecords=MasterGrid.getSelectionModel().getSelections();
					if (SelRecords==null) {
						Msg.info("warning", "��ѡ����Ҫ��˵ķ��䵥!");
						return;
					}
					Ext.each(SelRecords,function(item){
						Audit(item);
					});
				}
			});
		
	function Audit(rowData) {
		var AuditFlag = rowData.get("AuditFlag");
		if (AuditFlag == "Y") {
			Msg.info("warning", "���䵥�����!");
			return;
		}
		var slga = rowData.get("slga");
		var loadMask=ShowLoadMask(document.body,"�����...");
		
		var url = DictUrl
				+ "sublocgrpallotaction.csp?actiontype=Audit&slga="
				+ slga + "&userId=" + gUserId;
		Ext.Ajax.request({
				url : url,
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					loadMask.hide();
					if(jsonData.success == 'true') {
						Msg.info("success", "���ͨ���ɹ�!");
						MasterStore.removeAll();
						DetailStore.removeAll();
						ScaleStore.removeAll();
						MasterStore.reload();
					}else{
						var Ret=jsonData.info;
						if(Ret==-101){
							Msg.info("error", "���䵥������!");
						}else if(Ret==-100){
							Msg.info("error", "����ʧ��!");
						}else if(Ret==-102){
							Msg.info("error", "���䵥��δ��ɣ��������!");
						}else if(Ret==-103){
							Msg.info("error", "����Ȩ�ز���ȫ��Ϊ��!");
						}else{
							Msg.info("error", "���ʧ��:"+Ret);
						}
					}
				},
				scope : this
			});
		}
	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
				id : 'ClearBT',
				text : '���',
				tooltip : '������',
				iconCls : 'page_clearscreen',
				height:30,
				width:70,
				handler : function() {
					clearData();
				}
			});

	function clearData() {
		SetLogInDept(Ext.getCmp("PhaLoc").getStore(),"PhaLoc");
		Ext.getCmp("UserGrp").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, -30));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("StkGrpType").getStore().load();
		Ext.getCmp("AuditFlag").setValue(false);
		MasterStore.removeAll();
		DetailStore.removeAll();
	}
	
	var HisListTab = new Ext.ux.FormPanel({
		title : '���䵥���',
		id : "HisListTab",
		tbar : [SearchBT, '-', ClearBT, '-', AuditBT],
		items : [{
			xtype : 'fieldset',
			title : '��ѯ����',
			layout : 'column',	
			style : 'padding:5px 0px 0px 5px',
			defaults : {border:false,columnWidth: 0.25,xtype:'fieldset'},
			items:[{
				items: [PhaLoc,UserGrp]
			},{
				items: [StartDate,EndDate]
			},{
				items: [StkGrpType]
			},{
				items: [AuditFlag,DateFlag]
			}]
		}]
	});
			
	// ����·��
	var MasterUrl = DictUrl + 'sublocgrpallotaction.csp?actiontype=query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});

	// ָ���в���
	var fields = ["slga","slgaNo","LocId","LocDesc","LUGId","LUGDesc","CreateDate","CreateTime","UserName","CompFlag",
				"DataStr","AuditFlag","AuditDate","AuditTime","AuditUserName","ScgDesc","AllotMon"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "slga",
				fields : fields
			});
	// ���ݼ�
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				baseParams:{
					Sort:'',
					Dir:''
				}
			});
			
	var MasterSm = new Ext.grid.CheckboxSelectionModel({
		singleSelect : false,
		checkOnly : true,
		listeners:{
			'rowselect':function(sm,rowIndex,r){
				var slga = MasterStore.getAt(rowIndex).get("slga");
				var pagesize=DetailToolbar.pageSize;
				DetailStore.setBaseParam('slga',slga);
				DetailStore.removeAll();
				DetailStore.load({params:{start:0,limit:pagesize}});
				ScaleStore.removeAll();
				ScaleStore.load({params:{start:0,limit:999,sort:'',dir:'',slga:slga,ExcludeZero:1}});
			}
		}
	});
			
	var nm = new Ext.grid.RowNumberer();
	var MasterCm = new Ext.grid.ColumnModel([nm,MasterSm,
			{
				header : "slga",
				dataIndex : 'slga',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '���䵥��',
				dataIndex : 'slgaNo',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : '����',
				dataIndex : 'LocDesc',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "רҵ��",
				dataIndex : 'LUGDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : '���䵥�·�',
				dataIndex : 'AllotMon',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�Ƶ�����",
				dataIndex : 'CreateDate',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "�Ƶ�ʱ��",
				dataIndex : 'CreateTime',
				width : 70,
				align : 'left',
				hidden : true,
				sortable : true
			}, {
				header : "��ɱ�־",
				dataIndex : 'CompFlag',
				width : 60,
				align : 'center',
				hidden : true,
				sortable : true,
				renderer:function(v, p, record){
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
			}, {
				header : "��˱�־",
				dataIndex : 'AuditFlag',
				width : 60,
				align : 'center',
				sortable : true,
				renderer:function(v, p, record){
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
			}, {
				header : "�������",
				dataIndex : 'AuditDate',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "���ʱ��",
				dataIndex : 'CreateTime',
				width : 70,
				align : 'left',
				hidden : true,
				sortable : false
			}, {
				header : "�����",
				dataIndex : 'AuditUserName',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'ScgDesc',
				width : 80,
				align : 'left',
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	
	var MasterToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var MasterGrid = new Ext.ux.GridPanel({
		id : 'MasterGrid',
		region: 'west',
		title: '���䵥',
		width : 800,
		cm : MasterCm,
		sm : MasterSm,
		store : MasterStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:MasterToolbar
	});

	// ����·��
	var DetailInfoUrl = DictUrl
					+ 'sublocgrpallotaction.csp?actiontype=queryItem';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["slgai","inci","inciCode","inciDesc","qty","uom","uomDesc","rpAmt","spAmt","Abbrev","Brand","Model","Spec"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "slgai",
				fields : fields
			});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([
				nm,{
					header : "�����id",
					dataIndex : 'inci',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '���ʴ���',
					dataIndex : 'inciCode',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'inciDesc',
					width : 200,
					align : 'left',
					sortable : true
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
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "�ͺ�",
					dataIndex : 'Model',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : '���۽��',
					dataIndex : 'rpAmt',
					width : 100,
					align : 'right',
					sortable : false
				}, {
					header : '�ۼ۽��',
					dataIndex : 'spAmt',
					width : 100,
					align : 'right',
					sortable : false
				}
			]);
	DetailCm.defaultSortable = true;
	
	var DetailToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
	
	var DetailGrid = new Ext.ux.GridPanel({
		id : 'DetailGrid',
		region: 'south',
		split: true,
		collapsible: true,
		title: '���䵥��ϸ',
		height : gGridHeight,
		cm : DetailCm,
		sm : new Ext.grid.RowSelectionModel({
			singleSelect : true
		}),
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:DetailToolbar
	});

		var nmScale = new Ext.grid.RowNumberer();
		var ScaleCm = new Ext.grid.ColumnModel([
				nmScale, {
					header : "��Աid",
					dataIndex : 'UserId',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "��Ա",
					dataIndex : 'UserName',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "����Ȩ��",
					dataIndex : 'ScaleValue',
					width : 140,
					align : 'right',
					sortable : true
				},{
					header : "������(����)",
					dataIndex : 'ScaleRpAmt',
					width : 100,
					align : 'right',
					sortable : true
				},{
					header : "������(�ۼ�)",
					dataIndex : 'ScaleSpAmt',
					width : 100,
					align : 'right',
					sortable : true
				}
		]);
		ScaleCm.defaultSortable = false;
		
		var ScaleStore = new Ext.data.JsonStore({
			autoDestroy: true,
			url : DictUrl + 'sublocgrpallotaction.csp?actiontype=queryScale',
			fields : ["UserId","UserName","ScaleValue","ScaleRpAmt","ScaleSpAmt"],
			root:'rows'
		});
		
		var ScaleGrid = new Ext.ux.GridPanel({
			id : 'ScaleGrid',
			region: 'center',
			title: '����Ȩ��',
			cm : ScaleCm,
			store : ScaleStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.CheckboxSelectionModel(),
			loadMask : true,
			clicksToEdit : 1
		});			
			
		// ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab,MasterGrid,ScaleGrid,DetailGrid]
		});

})