// /����: ���䵥��ѯ����
// /��д�ߣ�wangjiabin
// /��д����: 2014.02.20
var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
function GrpAllotFind(Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	// ��ⲿ��
	var PhaLocFind = new Ext.ux.LocComboBox({
				fieldLabel : '����',
				id : 'PhaLocFind',
				name : 'PhaLocFind',
				anchor : '90%',
				emptyText : '����...',
				groupId:session['LOGON.GROUPID'],
				stkGrpId : 'FindStkGrpType',
				childCombo : 'UserGrpFind'
			});

		var FindGroupList=new Ext.data.Store({		 
			url:"dhcstm.sublocusergroupaction.csp?actiontype=FilterLocGroupList",
			reader:new Ext.data.JsonReader({
				totalProperty:'results',
				root:"rows",
				idProperty:'RowId'
			},['RowId','Description']),
			baseParams:{'SubLoc':Ext.getCmp('PhaLocFind').getValue()}
		});
		//רҵ��
		var UserGrpFind = new Ext.ux.ComboBox({
			fieldLabel : 'רҵ��',
			id : 'UserGrpFind',
			name : 'UserGrpFind',
			store : FindGroupList,
			valueField:'RowId',
			displayField:'Description',
			params:{SubLoc:'PhaLocFind'}
		});
			
	// ��ʼ����
	var StartDateFind = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDateFind',
				name : 'StartDateFind',
				anchor : '90%',
				
				anchor : '90%',
				value : new Date().add(Date.DAY, -30)
			});

	// ��������
	var EndDateFind = new Ext.ux.DateField({
				fieldLabel : '��������',
				id : 'EndDateFind',
				name : 'EndDateFind',
				anchor : '90%',
				
				value : new Date()
			});
	//����
	var FindStkGrpType = new Ext.ux.StkGrpComboBox({ 
				id : 'FindStkGrpType',
				name : 'FindStkGrpType',
				StkType:App_StkTypeCode,
				anchor : '90%',
				LocId:gLocId,
				UserId:gUserId
			});
	
	var FindForm = new Ext.ux.FormPanel({
				id : "FindForm",
				labelWidth: 60,
				items : [{
					layout: 'column',
					xtype:'fieldset',
					title:'��ѯ����',
					style:'padding:5px 0px 0px 0px',
					defaults: {border:false},
					items:[{
						columnWidth: 0.33,
						xtype: 'fieldset',
						defaultType: 'textfield',
						items: [PhaLocFind,UserGrpFind]
					},{
						columnWidth: 0.33,
						xtype: 'fieldset',
						items: [StartDateFind,EndDateFind]
					},{
						columnWidth: 0.33,
						xtype: 'fieldset',
						items: [FindStkGrpType]
					}]
				}]
			});

	// ������ť
	var FindSearchBT = new Ext.Toolbar.Button({
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
		var StartDate = Ext.getCmp("StartDateFind").getValue();
		if((StartDate!="")&&(StartDate!=null)){
			StartDate=StartDate.format(ARG_DATEFORMAT);
		}
		var EndDate = Ext.getCmp("EndDateFind").getValue();
		if((EndDate!="")&&(EndDate!=null)){
			EndDate=EndDate.format(ARG_DATEFORMAT);
		}
		var PhaLoc = Ext.getCmp("PhaLocFind").getValue();
		var UserGrp = Ext.getCmp("UserGrpFind").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", "��ѡ����ⲿ��!");
			return;
		}
		
		if(StartDate==""||EndDate==""){
			Msg.info("warning", "��ѡ��ʼ���ںͽ�ֹ����!");
			return;
		}
		var Comp="",Audit="N";
		var StkGrpId=Ext.getCmp("FindStkGrpType").getValue();
		var ListParam=StartDate+'^'+EndDate+'^'+PhaLoc+'^'+UserGrp+'^'+Comp+'^'+Audit+"^"+StkGrpId;
		var Page=FindMasterToolbar.pageSize;
		FindMasterStore.setBaseParam('StrParam',ListParam)
		FindMasterStore.removeAll();
		FindDetailGrid.store.removeAll();
		FindMasterStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options, success){
				if(!success){
     				Msg.info("error", "��ѯ������鿴��־!");
     			}else{
     				if(r.length>0){
	     				FindMasterGrid.getSelectionModel().selectFirstRow();
	     				FindMasterGrid.getView().focusRow(0);
     				}
     			}
			}
		});
	}

	// ѡȡ��ť
	var FindreturnBT = new Ext.Toolbar.Button({
				text : 'ѡȡ',
				tooltip : '���ѡȡ',
				iconCls : 'page_goto',
				height:30,
				width:70,
				handler : function() {
					returnData();
				}
			});

	// ��հ�ť
	var FindClearBT = new Ext.Toolbar.Button({
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
		Ext.getCmp("PhaLocFind").setValue("");
		SetLogInDept(PhaLocFind.getStore(),"PhaLocFind");
		Ext.getCmp("UserGrpFind").setValue("");
		Ext.getCmp("StartDateFind").setValue(new Date().add(Date.DAY, -30));
		Ext.getCmp("EndDateFind").setValue(new Date());
		Ext.getCmp("FindStkGrpType").getStore().load();
		FindMasterGrid.store.removeAll();
		FindDetailGrid.store.removeAll();
	}

	// 3�رհ�ť
	var FindCloseBT = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '�رս���',
				iconCls : 'page_delete',
				height:30,
				width:70,
				handler : function() {
					window.close();
				}
			});

	// ����·��
	var FindMasterUrl = DictUrl + 'sublocgrpallotaction.csp?actiontype=query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : FindMasterUrl,
				method : "POST"
			});

	// ָ���в���
	var fields = ["slga","slgaNo","LocId","LocDesc","LUGId","LUGDesc","CreateDate","CreateTime","UserName","CompFlag",
				"DataStr","AuditFlag","AuditDate","AuditTime","AuditUserName","ScgDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "IngrId",
				fields : fields
			});
	// ���ݼ�
	var FindMasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				baseParams:{
					Sort:'',
					Dir:''
				}
			});
	var nm = new Ext.grid.RowNumberer();
	var FindMasterCm = new Ext.grid.ColumnModel([nm, {
				header : "slga",
				dataIndex : 'slga',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '���䵥��',
				dataIndex : 'slgaNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : '����',
				dataIndex : 'LocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "רҵ��",
				dataIndex : 'LUGDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "�Ƶ�����",
				dataIndex : 'CreateDate',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "�Ƶ�ʱ��",
				dataIndex : 'CreateTime',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "��ɱ�־",
				dataIndex : 'CompFlag',
				width : 80,
				align : 'center',
				sortable : true,
				renderer:function(v, p, record){
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
			}, {
				header : "����",
				dataIndex : 'ScgDesc',
				width : 80,
				align : 'left',
				sortable : true
			}]);
	FindMasterCm.defaultSortable = true;
	
	var FindMasterToolbar = new Ext.PagingToolbar({
		store:FindMasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
	var FindMasterGrid = new Ext.grid.GridPanel({
				region: 'west',
				title: '���䵥',
				collapsible: true,
				split: true,
				width: 225,
				minSize: 175,
				maxSize: 400,
				margins: '0 5 0 0',
				id : 'FindMasterGrid',
				cm : FindMasterCm,
				sm : new Ext.grid.RowSelectionModel({
					singleSelect : true,
					listeners:{
						'rowselect':function(sm,rowIndex,r){
							var slga = FindMasterStore.getAt(rowIndex).get("slga");
							var pagesize=FindDetailToolbar.pageSize;
							GrDetailInfoStore.setBaseParam('slga',slga);
							GrDetailInfoStore.removeAll();
							GrDetailInfoStore.load({params:{start:0,limit:pagesize}});
						}
					}
				}),
				store : FindMasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:FindMasterToolbar
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
	var GrDetailInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var FindDetailCm = new Ext.grid.ColumnModel([
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
	FindDetailCm.defaultSortable = true;
	
	var FindDetailToolbar = new Ext.PagingToolbar({
		store:GrDetailInfoStore,
		pageSize:PageSize,
		displayInfo:true
	});
	
	var FindDetailGrid = new Ext.grid.GridPanel({
				region: 'center',
				title: '���䵥��ϸ',
				cm : FindDetailCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : GrDetailInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:FindDetailToolbar
			});

	// ˫���¼�
	FindMasterGrid.on('rowdblclick', function() {
				returnData();
			});

	
	var window = new Ext.Window({
				modal : true,
				title : '���䵥��ѯ',
				width : gWinWidth,
				height : gWinHeight,
				layout : 'border',
				items : [FindForm, FindMasterGrid, FindDetailGrid],
				tbar : [FindSearchBT, '-', FindreturnBT, '-', FindClearBT, '-', FindCloseBT]
			});
	window.show();

	function returnData() {
		var selectRows = FindMasterGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning","��ѡ��Ҫ���صķ��䵥��Ϣ!");
		} else {
			var slga = selectRows[0].get("slga");
			Fn(slga);
			window.close();
		}
	}
}