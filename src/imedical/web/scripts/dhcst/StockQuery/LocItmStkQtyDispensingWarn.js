// /����: ��汨��-��������
// /����:  ��汨��-��������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.15
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.Ajax.timeout = 900000;
	var gStrParam='';
	var gGroupId=session['LOGON.GROUPID'];
		//ͳ�ƿ���
		var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '����',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId
		});

		var NotUseFlag = new Ext.form.Checkbox({
					boxLabel : '����������Ʒ��',
					id : 'NotUseFlag',
					name : 'NotUseFlag',
					//anchor : '90%',
					//width : 50,
					//height : 10,
					//boxLabel:'����������Ʒ��',
					checked : false
				});

			// ��ʼ����
		var StartDate = new Ext.ux.DateField({
					fieldLabel : '��ʼ����',
					id : 'StartDate',
					name : 'StartDate',
					width : 120,
					//hideLabel:true,
					value : new Date().add(Date.DAY, - 30)
				});
		// ��ֹ����
		var EndDate = new Ext.ux.DateField({
					fieldLabel : '��������',
					id : 'EndDate',
					name : 'EndDate',
					width : 120,
					value : new Date()
				});
		//��ҩ����
		var UseDays=new Ext.form.NumberField({
					id : 'UseDays',
					name : 'UseDays',
					anchor : '90%',
					fieldLabel:'��ҩ����',
					value:30
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
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
			var UseDays = Ext.getCmp("UseDays").getValue();
			if (startDate == undefined || startDate.length <= 0) {
				Msg.info("warning", "��ѡ��ʼ����!");
				return;
			}
			if (endDate == undefined || endDate.length <= 0) {
				Msg.info("warning", "��ѡ���ֹ����!");
				return;
			}
			if (UseDays == undefined || UseDays.length <= 0) {
				Msg.info("warning", "����д��ҩ����!");
				return;
			}
			// ��ѡ����
			var NotUseFlag = (Ext.getCmp("NotUseFlag").getValue()==true?'Y':'N');
			
			gStrParam=phaLoc+"^"+startDate+"^"+endDate
			+"^"+UseDays+"^"+NotUseFlag;
			
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.setBaseParam("Params",gStrParam);
			StockQtyStore.removeAll();
			StockQtyStore.load({params:{start:0,limit:pageSize,sort:''},
			callback : function(o,response,success) { 
					if (success == false){  
						Ext.MessageBox.alert("��ѯ����",StockQtyStore.reader.jsonData.Error);  
					}
				}
			});

		}
		// ��水ť
		var SaveAsBT = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '���ΪExcel',
					iconCls : 'page_export',
					width : 70,
					height : 30,
					handler : function() {
						ExportAllToExcel(StockQtyGrid);
					}
				});		
		// ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
					text : '����',
					tooltip : '�������',
					iconCls : 'page_clearscreen',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});
		var PrintBT = new Ext.Toolbar.Button({
				id : "PrintBT",
				text : '��ӡ',
				width : 70,
				height : 30,
				iconCls : 'page_print',
				handler : function() {
					var rowCount=StockQtyStore.getCount();
					if (rowCount ==0) {
						Msg.info("warning", "�޿��ô�ӡ����!");
						return;
					}
					var tmpParam = StockQtyStore.lastOptions; 
					if (tmpParam && tmpParam.params) {
							var gStrParam=StockQtyStore.baseParams.Params;  //�����Grid���ݲ�������һ��,yunhaibao20160419
							var gStrParamArr=gStrParam.split("^");
							var phaLoc=gStrParamArr[0];
							var startDate=gStrParamArr[1];
							var endDate=gStrParamArr[2];
							var UseDays=gStrParamArr[3];
							var NotUseFlag=gStrParamArr[4];
							var sort="",dir="";
							if (StockQtyStore.sortInfo){
								sort=StockQtyStore.sortInfo.field;
								dir=StockQtyStore.sortInfo.direction;
							}
							if (sort==undefined){sort=""}
							if (dir==undefined){dir=""}
							var LocDesc=Ext.getCmp("PhaLoc").getRawValue();		
							var RQDTFormat=App_StkRQDateFormat //+" "+App_StkRQTimeFormat;					
							var fileName="DHCST_LocItmStkQtyDispensingWarn.raq&qPar="  //+sort+"^"+dir
							+"&Loc="+phaLoc+"&StartDate="+startDate+"&EndDate="+endDate+"&StkSupportDays="+UseDays+"&IncludeNotUseFlag="+NotUseFlag+"&User="+session['LOGON.USERID']
							+"&LocDesc="+LocDesc+"&UserName="+session['LOGON.USERNAME']+"&HospDesc="+App_LogonHospDesc+"&RQDTFormat="+RQDTFormat;
							DHCCPM_RQPrint(fileName)
					}	
				}
			});

		/**
		 * ��շ���
		 */
		function clearData() {
			gStrParam='';
			SetLogInDept(PhaLoc.getStore(),'PhaLoc');
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
			Ext.getCmp("EndDate").setValue(new Date());
			Ext.getCmp("NotUseFlag").setValue(false);
			Ext.getCmp("UseDays").setValue(30);			
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}

		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, {
					header : "incil",
					dataIndex : 'incil',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '����',
					dataIndex : 'code',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'desc',
					width : 225,
					align : 'left',
					sortable : true
				}, {
					header : "���",
					dataIndex : 'spec',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "��λ",
					dataIndex : 'stkUom',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "���ÿ��",
					dataIndex : 'avaQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'oneDspQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "������",
					dataIndex : 'reqQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'manf',
					width : 175,
					align : 'left',
					sortable : true
				}]);
		StockQtyCm.defaultSortable = true;

		// ����·��
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=jsLocItmStkQtyDispensingWarn&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["incil", "inci", "code", "desc","spec", "manf", 
				"reqQty", "avaQty", "oneDspQty", "stkUom"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "incil",
					fields : fields
				});
		// ���ݼ�
		var StockQtyStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					remoteSort:true,
					baseParams:{
						Params:''
					}
				});

		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : StockQtyStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
					emptyMsg : "No results to display",
					prevText : "��һҳ",
					nextText : "��һҳ",
					refreshText : "ˢ��",
					lastText : "���ҳ",
					firstText : "��һҳ",
					beforePageText : "��ǰҳ",
					afterPageText : "��{0}ҳ",
					emptyMsg : "û������"//,
					//doLoad:function(C){
					//	var B={},
					//	A=this.getParams();
					//	B[A.start]=C;
						//B[A.limit]=this.pageSize;
					//	B[A.sort]='desc';
						//B[A.dir]='ASC';
						
						//B['Params']=gStrParam;
						//if(this.fireEvent("beforechange",this,B)!==false){
							//this.store.load({params:B});
						//}
					//}
				});

		var StockQtyGrid = new Ext.grid.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					bbar : StatuTabPagingToolbar,
					viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){ 
						var StkQty=record.get("avaQty");
						var MaxQty=record.get("maxQty");
						var MinQty=record.get("minQty");
						if(parseFloat(StkQty)>MaxQty){
							return 'classRed';
						}else if(parseFloat(StkQty)<MinQty){
							return 'classGrassGreen';
						}					
                    }
            	}
		});
		
	var HisListTab = new Ext.form.FormPanel({
			labelWidth : 60,
			region : 'north',
			title:"��汨��-��������",
			autoHeight:true,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			tbar : [SearchBT, '-', RefreshBT,'-',PrintBT,'-',SaveAsBT],				
			items:[{
				layout : 'column',
				defaults: { border:false},	
				title:'��ѯ����',
				style:DHCSTFormStyle.FrmPaddingV,
				xtype: 'fieldset',
				items:[{
					columnWidth:0.25,
					xtype: 'fieldset',
					labelWidth : 40,									
					items : [PhaLoc]
				  },{
					columnWidth:0.2,
					xtype: 'fieldset',									
					items : [StartDate]
				  },{
					columnWidth:0.2,
					xtype: 'fieldset',									
					items : [EndDate]
				  },{
					columnWidth:0.15,
					xtype: 'fieldset',									
					items : [UseDays]
				  },{
					columnWidth:0.15,
					xtype: 'fieldset',
					labelWidth : 10,									
					items : [NotUseFlag]
				  }]	
			}]
		});

		// 5.2.ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [ 						
						{	
							region: 'north',		               
			                layout: 'fit', // specify layout manager for items
							height:DHCSTFormStyle.FrmHeight(1),
							items:HisListTab       			               
						}       
			               
			            , {
			                region: 'center',
			                title: '��ϸ',			               
			                layout: 'fit', // specify layout manager for items
			                items: StockQtyGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
	
})