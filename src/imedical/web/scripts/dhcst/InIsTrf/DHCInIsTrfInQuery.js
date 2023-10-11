// /����: ת����ⵥ�ݲ�ѯ		
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.24
// /2013-07-17 ����ת�Ƴ����ѯ�޸�
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
    var gGroupId=session['LOGON.GROUPID'];
    var gLocId=session['LOGON.CTLOCID'];
    var gInciRowId="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gParamNew = PHA_COM.ParamProp("DHCSTTRANSFER")
	var PoisonDoubleSignFlag = gParamNew.InPoisonDoubleSign == "Y" ? false : true;
	ChartInfoAddFun();
	// ��¼����Ĭ��ֵ
	SetLogInDept(PhaDeptStore, "RequestPhaLoc");
	//ȡ��������
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ��������������
	}
	function ChartInfoAddFun() {
		// ������
		var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : $g('���ղ���'),
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : $g('���ղ���...'),
					groupId:gGroupId
					
		});
		
		// ��������
		var SupplyPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : $g('��������'),
					id : 'SupplyPhaLoc',
					name : 'SupplyPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : $g('��������...'),
					defaultLoc:{}
				});


		// ��ʼ����
		var StartDate = new Ext.ux.DateField({
					fieldLabel : $g('��ʼ����'),
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					width : 120,
					value : DefaultStDate()
				});
		// ��ֹ����
		var EndDate = new Ext.ux.DateField({
					fieldLabel : $g('��ֹ����'),
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					width : 120,
					value : DefaultEdDate()
				});
				
		// ����һ
	var PMZJYFlag = new Ext.form.Checkbox({
		fieldLabel : $g('����һ'),
		id : 'PMZJYFlag',
		name : 'PMZJYFlag',
		anchor : '90%',
		width : 150,
		checked : false,
		disabled:false,
		hidden:PoisonDoubleSignFlag
		
	});
	

		var StatusStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['10', $g('δ���')], ['11', $g('�����')],['20', $g('������˲�ͨ��')],['21', $g('�������ͨ��')],['30', $g('�ܾ�����')],['31', $g('�ѽ���')],['32', $g('���ֽ���')],['40', $g('��ת����')]]
		});
		
		var Status = new Ext.form.ComboBox({
			fieldLabel : $g('ת�Ƶ�״̬'),
			id : 'Status',
			name : 'Status',
			anchor:'90%',
			width : 100,
			store : StatusStore,
			triggerAction : 'all',
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			editable : true,
			valueNotFoundText : ''
		});
		
		// ҩƷ����
		var StkGrpType=new Ext.ux.StkGrpComboBox({   //StkGrpType.store.reload();
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			LocId:gLocId,
			UserId:userId,
			anchor:'90%',
			width : 200
		}); 
		// ҩƷ����
		var InciDesc = new Ext.form.TextField({
			fieldLabel : $g('ҩƷ����'),
			id : 'InciDesc',
			name : 'InciDesc',
			anchor : '90%',
			width : 150,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(), stktype);
					}
				}
			}
		});

			/**
		 * ����ҩƷ���岢���ؽ��
		 */
		function GetPhaOrderInfo(item, stktype) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
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
			var InciDesc=record.get("InciDesc");
			Ext.getCmp("InciDesc").setValue(InciDesc);
			gInciRowId=inciDr;
		}
		
		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
					text : $g('��ѯ'),
					tooltip : $g('�����ѯ'),
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
						Query();
					}
				});
		/**
		 * ��ѯ����
		 */
		function Query() {
			var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
			if (requestphaLoc == null || requestphaLoc.length <= 0) {
				Msg.info("warning", $g("��ѡ��������!"));
				return;
			}
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
			var statue =  Ext.getCmp("Status").getValue();
			var stkgrpid=Ext.getCmp("StkGrpType").getValue();
			var inci=gInciRowId;
			if(Ext.getCmp("InciDesc").getValue()==""){
				inci="";
			}
			var MZJYFlag = Ext.getCmp("PMZJYFlag").getValue()  ? 'Y' : 'N';
		
			var ListParam = [startDate,endDate,supplyphaLoc,requestphaLoc,"",statue,"","",stkgrpid,inci,"",MZJYFlag].join("^")
			//var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^^'+statue+'^^^'+stkgrpid+"^"+inci;
			var Page=GridPagingToolbar.pageSize;
			MasterStore.setBaseParam('ParamStr',ListParam);
			MasterStore.load({params:{start:0, limit:Page}});
			DetailGrid.store.removeAll();
			MasterStore.removeAll();
			MasterStore.on('load',function(){
				if (MasterStore.getCount()>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
				}
	        });
		}

		// ��հ�ť
		var ClearBT = new Ext.Toolbar.Button({
					text : $g('����'),
					tooltip : $g('�������'),
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
			SetLogInDept(PhaDeptStore, "RequestPhaLoc");
			
			Ext.getCmp("SupplyPhaLoc").setValue("");
			Ext.getCmp("Status").setValue("");
			//Ext.getCmp("StkGrpType").setValue("");
			StkGrpType.store.reload();
			Ext.getCmp("InciDesc").setValue("");
			Ext.getCmp("StartDate").setValue(DefaultStDate());
			Ext.getCmp("EndDate").setValue(DefaultEdDate());
			Ext.getCmp("PMZJYFlag").setValue(false);
			MasterGrid.store.removeAll();
			MasterGrid.getView().refresh();
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
		}
		
		// ��ӡ��ť
		var PrintBT = new Ext.Toolbar.Button({
					text : $g('��ӡ'),
					tooltip : $g('�����ӡ'),
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
						var rowData=MasterGrid.getSelectionModel().getSelected();
						if (rowData ==null) {
							Msg.info("warning", $g("��ѡ����Ҫ��ӡ��ת�Ƶ�!"));
							return;
						}
						var init = rowData.get("init");
						PrintInIsTrf(init,gParam[8]);
					}
				});
				
				
					// ����һ���1
		var MZJYAudit1 = new Ext.Toolbar.Button({
					id:'MZJYAudit1',
					text : $g('�龫���1'),
					tooltip : $g('������'),
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					hidden:PoisonDoubleSignFlag,
					handler : function() {
						MZJYDoubleSign("InMZJY1")
					}
				});
		// ����һ���2
		var MZJYAudit2 = new Ext.Toolbar.Button({
					id:'MZJYAudit2',
					text : $g('�龫���2'),
					tooltip : $g('������'),
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					hidden:PoisonDoubleSignFlag,
					handler : function() {
						MZJYDoubleSign("InMZJY2");
					}
				});
		// ����һҩƷ˫ǩ
		function MZJYDoubleSign(Status){
			var rowData=MasterGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", $g("��ѡ��һ��ת�Ƶ�!"));
				return;
			}
			var init = rowData.get("init");
			var Table = "User.DHCInIsTrf"
			var Ret = tkMakeServerCall("web.DHCST.DHCINIsTrf","SaveStatus",Table,init,Status,userId,"","Y","31")
			var RetArr = Ret.split("^")
			if(RetArr[0]>0){
				Msg.info("success", $g("��˳ɹ�!"));
				Query();
				return;
			}
			else{
				Msg.info("warning", $g("���ʧ��:") + RetArr[1]);
				return;
			}
		}

			
		/* �����ð�ť */
		var GridColSetBT = new Ext.Toolbar.Button({
			text:$g('������'),
			tooltip:$g('������'),
			iconCls:'page_gear',
			handler:function(){
				GridSelectWin.show();
			}
		});

		// ȷ����ť
		var returnColSetBT = new Ext.Toolbar.Button({
			text : $g('ȷ��'),
			tooltip : $g('���ȷ��'),
			iconCls : 'page_goto',
			handler : function() {
				var selectradio = Ext.getCmp('GridSelectModel').getValue();
				if(selectradio){
					var selectModel =selectradio.inputValue;	
					if (selectModel=='1') {
						GridColSet(MasterGrid,"DHCSTTRANSFER");						
					}
					else {
						GridColSet(DetailGrid,"DHCSTTRANSFER");   							
					}						
				}
				GridSelectWin.hide();
			}
		});

		// ȡ����ť
		var cancelColSetBT = new Ext.Toolbar.Button({
				text : $g('ȡ��'),
				tooltip : $g('���ȡ��'),
				iconCls : 'page_delete',
				handler : function() {
					GridSelectWin.hide();
				}
			});

		//ѡ��ť
		var GridSelectWin=new Ext.Window({
			title:$g('ѡ��'),
			width : 210,
			height : 110,
			labelWidth:100,
			closeAction:'hide' ,
			plain:true,
			modal:true,
			items:[{
				xtype:'radiogroup',
				id:'GridSelectModel',
				anchor: '95%',
				columns: 2,
				style: 'padding:10px 10px 10px 10px;',
				items : [{
						checked: true,				             
							boxLabel: $g('���ⵥ'),
							id: 'GridSelectModel1',
							name:'GridSelectModel',
							inputValue: '1' 							
						},{
						checked: false,				             
							boxLabel: $g('���ⵥ��ϸ'),
							id: 'GridSelectModel2',
							name:'GridSelectModel',
							inputValue: '2' 							
						}]
					}],
			
			buttons:[returnColSetBT,cancelColSetBT]
		})



		
		// ����·��
		var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=Query';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd","tt", "comp", "userName",
		"status","RpAmt","SpAmt","MarginAmt","Remark","StatusCode","inAckDate","inAckTime","inAckUser","InMZJYAudit1","InMZJYAudit2"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "init",
					fields : fields
				});
		// ���ݼ�
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		var nm = new Ext.grid.RowNumberer();
		var MasterCm = new Ext.grid.ColumnModel([nm, {
					header : "RowId",
					dataIndex : 'init',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g("ת�Ƶ���"),
					dataIndex : 'initNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g('���󵥺�'),
					dataIndex : 'reqNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("������"),
					dataIndex : 'toLocDesc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("��������"),
					dataIndex : 'frLocDesc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("ת������"),
					dataIndex : 'dd',
					width : 90,
					align : 'center',
					sortable : true
				}, {
					header : $g("����״̬"),
					dataIndex : 'StatusCode',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("�Ƶ���"),
					dataIndex : 'userName',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g("���ȷ������"),
					dataIndex : 'inAckDate',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g("���ȷ��ʱ��"),
					dataIndex : 'inAckTime',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g("���ȷ����"),
					dataIndex : 'inAckUser',
					width : 70,
					align : 'left',
					sortable : true
				}, {
					header : $g("���۽��"),
					dataIndex : 'RpAmt',
					width : 80,
					align : 'right',					
					sortable : true,
					renderer:FormatGridRpAmount
				}, {
					header : $g("�ۼ۽��"),
					dataIndex : 'SpAmt',
					width : 80,
					align : 'right',					
					sortable : true,
					renderer:FormatGridSpAmount
				}, {
					header : $g("�������"),
					dataIndex : 'MarginAmt',
					width : 80,
					align : 'right',					
					sortable : true,
					renderer:FormatGridRpAmount
				}, {
					header : $g("��ע"),
					dataIndex : 'Remark',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("�龫���1"),
					dataIndex : 'InMZJYAudit1',
					width : 90,
					align : 'left',
					sortable : true,
					hidden:PoisonDoubleSignFlag
				}, {
					header : $g("�龫���2"),
					dataIndex : 'InMZJYAudit2',
					width : 90,
					align : 'left',
					sortable : true,
					hidden:PoisonDoubleSignFlag
				}]);
		MasterCm.defaultSortable = true;
		var GridPagingToolbar = new Ext.PagingToolbar({
			store:MasterStore,
			pageSize:PageSize,
			displayInfo:true,
			displayMsg:$g('�� {0} ���� {1}��, һ�� {2} ��'),
			emptyMsg:$g("û�м�¼")
		});
		var MasterGrid = new Ext.grid.GridPanel({
					title : '',
					height : 170,
					cm : MasterCm,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					store : MasterStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					bbar:GridPagingToolbar
				});

		// ��ӱ�񵥻����¼�
		MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var InIt = MasterStore.getAt(rowIndex).get("init");
			var status =  Ext.getCmp("Status").getValue();
			DetailStore.setBaseParam('Parref',InIt+"^"+status)
			DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc'}});
		});

		// ת����ϸ
		// ����·��
		var DetailUrl =  DictUrl
					+ 'dhcinistrfaction.csp?actiontype=QueryDetail';;;
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["initi", "inrqi", "inci","inciCode",
				"inciDesc", "inclb", "batexp", "manf","manfName",
				 "qty", "uom", "sp","status","remark",
				"reqQty", "inclbQty", "reqLocStkQty", "reqstkbin",
				"pp", "spec", "gene", "formDesc","newSp",
				"spAmt", "rp","rpAmt", "ConFac", "BUomId", 
				"inclbDirtyQty", "inclbAvaQty","TrUomDesc","InsuCode","InsuDesc"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "initi",
					fields : fields
				});
		// ���ݼ�
		var DetailStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, {
					header : $g("ת��ϸ��RowId"),
					dataIndex : 'initi',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g("ҩƷId"),
					dataIndex : 'inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g('ҩƷ����'),
					dataIndex : 'inciCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g('ҩƷ����'),
					dataIndex : 'inciDesc',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : $g("����Id"),
					dataIndex : 'inclb',
					width : 180,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g("����/Ч��"),
					dataIndex : 'batexp',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("������ҵ"),
					dataIndex : 'manfName',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : $g("���ο��"),
					dataIndex : 'inclbQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("ת������"),
					dataIndex : 'qty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("ת�Ƶ�λ"),
					dataIndex : 'TrUomDesc',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("����"),
					dataIndex : 'rp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("�ۼ�"),
					dataIndex : 'sp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("��������"),
					dataIndex : 'reqQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("��λ��"),
					dataIndex : 'reqstkbin',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("���󷽿��"),
					dataIndex : 'reqLocStkQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : $g("ռ������"),
					dataIndex : 'inclbDirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("��������"),
					dataIndex : 'inclbAvaQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("�����ۼ�"),
					dataIndex : 'newSp',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("���"),
					dataIndex : 'spec',
					width : 100,
					align : 'left',
					sortable : true
				},{
					header : $g("����ͨ����"),
					dataIndex : 'gene',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("����"),
					dataIndex : 'formDesc',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("�ۼ۽��"),
					dataIndex : 'spAmt',
					width : 100,
					align : 'right',					
					sortable : true,
					renderer:FormatGridSpAmount
				}, {
					header : $g("���۽��"),
					dataIndex : 'rpAmt',
					width : 100,
					align : 'right',					
					sortable : true,
					renderer:FormatGridRpAmount
				}, {
					header : $g("����ҽ������"),
					dataIndex : 'InsuCode',
					width : 100,
					align : 'right',					
					sortable : true,
				}, {
					header : $g("����ҽ������"),
					dataIndex : 'InsuDesc',
					width : 100,
					align : 'right',					
					sortable : true,
				}]);
       var GridDetailPagingToolbar = new Ext.PagingToolbar({
			store:DetailStore,
			pageSize:PageSize,
			displayInfo:true,
			displayMsg:$g('�� {0} ���� {1}��, һ�� {2} ��'),
			emptyMsg:$g("û�м�¼")
		});
		var DetailGrid = new Ext.grid.GridPanel({
					title : '',
					height : 200,
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					bbar:GridDetailPagingToolbar,
					loadMask : true
				});

		var HisListTab = new Ext.form.FormPanel({
			labelWidth : 60,
			labelAlign : 'right',
			title:$g("ת������ѯ"),
			frame : true,
			autoHeight:true,
			//autoScroll : true,
			tbar : [SearchBT, '-', ClearBT, '-', PrintBT,'-',GridColSetBT,'-',MZJYAudit1,'-',MZJYAudit2],
			items:[{
				xtype:'fieldset',
				layout:'column',
				defaults:{border:false},
				title:$g('��ѯ����'),
				style:DHCSTFormStyle.FrmPaddingV,
				items : [{ 				
					columnWidth: 0.2,
					xtype:'fieldset',
	            	items: [RequestPhaLoc,SupplyPhaLoc]
					
				},{ 				
					columnWidth: 0.15,
					xtype:'fieldset',	            	
					items: [StartDate,EndDate]
					
				},{ 				
					columnWidth: 0.23,
					xtype:'fieldset',
	            	items: [StkGrpType,InciDesc]
					
				},{ 				
					columnWidth: 0.23,
					xtype:'fieldset',
					labelWidth:80,
	            	items: [Status,PMZJYFlag]
					
				}]
			}]
		});

		// ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'north',
			                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }, {
			                region: 'center',
			                title: $g('���ⵥ'),			               
			                layout: 'fit', // specify layout manager for items
			                items: MasterGrid       
			               
			            }, {
			                region: 'south',
			                split: true,
                			height: 250,
                			minSize: 200,
                			maxSize: 350,
                			collapsible: true,
			                title: $g('���ⵥ��ϸ'),
			                layout: 'fit', // specify layout manager for items
			                items: DetailGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
		RefreshGridColSet(MasterGrid,"DHCSTTRANSFER");   
		RefreshGridColSet(DetailGrid,"DHCSTTRANSFER"); 
	}

})
