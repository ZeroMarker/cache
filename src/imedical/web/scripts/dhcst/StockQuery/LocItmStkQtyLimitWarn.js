// /����: ��汨��-��������
// /����:  ��汨��-��������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.14
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
	var gGroupId=session['LOGON.GROUPID'];
	var gUserId=session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	
	//ͳ�ƿ���
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '����',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId,
	        listeners : {
                'select' : function(e) {
					ReloadStkGrpType();
				}
			}
	});
	
		function ReloadStkGrpType(){
			var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
			StkGrpType.getStore().removeAll();
			StkGrpType.getStore().setBaseParam("locId",SelLocId)
			StkGrpType.getStore().setBaseParam("userId",UserId)
			StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
			StkGrpType.getStore().load();
		}	
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			anchor:'90%',
			width : 140,
			LocId:gLocId,
			UserId:gUserId,
			listeners:{
				change:function(field,newValue,oldValue){
					Ext.getCmp('DHCStkCatGroup').setValue('');
				}
			}
		}); 
		
		var DHCStkCatGroup = new Ext.ux.ComboBox({
					fieldLabel : '������',
					id : 'DHCStkCatGroup',
					name : 'DHCStkCatGroup',
					anchor : '90%',
					width : 140,
					store : StkCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{StkGrpId:'StkGrpType'}
				});

		var UseFlag = new Ext.form.Checkbox({
					fieldLabel : '������Ʒ��',
					id : 'UseFlag',
					name : 'UseFlag',
					anchor : '90%',
					width : 100,
					height : 10,
					checked : false
				});

		var StkBin = new Ext.ux.ComboBox({
					fieldLabel : '��λ��',
					id : 'StkBin',
					name : 'StkBin',
					anchor : '90%',
					width : 140,
					//store : StkBinStore,
					store : LocStkBinStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{LocId:'PhaLoc'},
					filterName:'Desc'
				});
		var LimitFlagStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['0', 'ȫ��'], ['1', '�������������'], ['2', '�������������']]
				});
		var LimitFlag = new Ext.form.ComboBox({
					fieldLabel : '����״̬',
					id : 'LimitFlag',
					name : 'LimitFlag',
					anchor:'90%',
					store : LimitFlagStore,
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
					valueNotFoundText : ''
				});
		Ext.getCmp("LimitFlag").setValue("0");

				
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
	
			// ��ѡ����
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			var DHCStkCatGroup = Ext.getCmp("DHCStkCatGroup").getValue();
			var UseFlag = (Ext.getCmp("UseFlag").getValue()==true?'Y':'N');
			var StkBin=Ext.getCmp("StkBin").getValue();
			var LimitFlag=Ext.getCmp("LimitFlag").getValue();
			gStrParam=phaLoc+"^"+StkGrpRowId+"^"+DHCStkCatGroup
			+"^"+StkBin+"^"+UseFlag+"^"+LimitFlag;
			
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize,Params:gStrParam},
				callback : function(o,response,success) { 
					if (success == false){  
						Ext.MessageBox.alert("��ѯ����",StockQtyStore.reader.jsonData.Error);  
					}
				}
			});

		}
		function StkStatColorRenderer(val,meta,record){	
			if(val=="��������"){
				meta.css='classRed';
			}else if(val=="��������"){
				meta.css='classGrassGreen';
			}
			return val;	
		}		
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

		/**
		 * ��շ���
		 */
		function clearData() {
			gStrParam='';
			SetLogInDept(PhaLoc.getStore(),'PhaLoc');
			Ext.getCmp("DHCStkCatGroup").setValue('');
			Ext.getCmp("UseFlag").setValue(false);
			Ext.getCmp("StkBin").setValue('');
			Ext.getCmp("LimitFlag").setValue(0);
			ReloadStkGrpType();
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
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
							var gStrParam=tmpParam.params.Params;  //�����Grid���ݲ�������һ��,yunhaibao20160419
							var gStrParamArr=gStrParam.split("^");
							var phaLoc=gStrParamArr[0];
							var StkGrpRowId=gStrParamArr[1];
							var DHCStkCatGroup=gStrParamArr[2];
							var StkBin=gStrParamArr[3];
							var UseFlag=gStrParamArr[4];
							var sort="",dir="";
							if (StockQtyStore.sortInfo){
								sort=StockQtyStore.sortInfo.field;
								dir=StockQtyStore.sortInfo.direction;
							}
							if (sort==undefined){sort=""}
							if (dir==undefined){dir=""}
							var LocDesc=Ext.getCmp("PhaLoc").getRawValue();		
							var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;					
							var fileName="DHCST_LocItmStkQtyLimitWarn.raq&qPar="+sort+"^"+dir
							+"&Loc="+phaLoc+"&SCG="+StkGrpRowId+"&INCSC="+DHCStkCatGroup+"&StkBin="+StkBin+"&IncludeNotUseFlag="+UseFlag+"&User="+session['LOGON.USERID']
							+"&LocDesc="+LocDesc+"&UserName="+session['LOGON.USERNAME']+"&HospDesc="+App_LogonHospDesc+"&RQDTFormat="+RQDTFormat;
							DHCCPM_RQPrint(fileName)
					}	
				}
			});
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
					header : '����״̬',
					dataIndex : 'stkStat',
					width : 75,
					align : 'center',
					sortable : true,
					renderer:StkStatColorRenderer
				}, {
					header : '����',
					dataIndex : 'code',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'desc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "���",
					dataIndex : 'spec',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "��λ",
					dataIndex : 'stkUom',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "�����",
					dataIndex : 'avaQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "�������",
					dataIndex : 'maxQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "�������",
					dataIndex : 'minQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "��׼���",
					dataIndex : 'repQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'manf',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : '������',
					dataIndex : 'incscDesc',
					width : 150,
					align : 'left',
					sortable : true
				}]);
		StockQtyCm.defaultSortable = true;

		// ����·��
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=jsLocItmStkQtyLimitWarn&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["incil", "inci", "code", "desc","spec", "manf", "maxQty", "minQty",
				"repQty", "avaQty", "incscDesc", "stkUom","stkStat"];
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
					remoteSort:true
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
					emptyMsg : "û������",
					doLoad:function(C){
						var B={},
						A=this.getParams();
						B[A.start]=C;
						B[A.limit]=this.pageSize;
						B[A.sort]='desc';
						B[A.dir]='ASC';
						
						B['Params']=gStrParam;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
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
					bbar : StatuTabPagingToolbar
					/*,
					viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){ 
						var StkQty=record.get("avaQty");
						var MaxQty=record.get("maxQty");
						var MinQty=record.get("minQty");
						if(parseFloat(StkQty)>MaxQty){
							return 'classRed';
						}else if(parseFloat(StkQty)<MinQty){
							return 'classGrassGreen';
						}					
                    }}*/
		});
		
	var HisListTab = new Ext.form.FormPanel({
			labelWidth : 60,
			region : 'north',
			title:"��汨��-��������",
			autoHeight : true,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			tbar : [SearchBT, '-', RefreshBT,'-',PrintBT,'-',SaveAsBT],		
		    items:[{
				layout : 'column',	
				title:'��ѯ����',	
				xtype: 'fieldset',
				defaults: { border:false},
				style:DHCSTFormStyle.FrmPaddingV,
				items : [{
							columnWidth:0.3,
							xtype: 'fieldset',
							items : [PhaLoc,StkBin]
						},{
							columnWidth:0.25,
							xtype: 'fieldset',
							items : [StkGrpType,DHCStkCatGroup]
						},{
							columnWidth:0.25,
							xtype: 'fieldset',
							labelWidth : 90,
							items : [UseFlag,LimitFlag]
						},{
							columnWidth:0.2,
							xtype: 'fieldset',
							labelWidth : 110,
							defaultType: 'textfield',
							defaults: {width: 80, border:false},    // Default config options for child items
							items : [{
								fieldLabel:'�������������',
								disabled:true,
								cls: 'my-background-Red'
							},{
								fieldLabel:'�������������',
								disabled:true,							
								cls: 'my-background-GrassGreen'
							}]
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
							height:DHCSTFormStyle.FrmHeight(2),
							items:HisListTab       			               
						}, {
			                region: 'center',
			                title: '��ϸ',			               
			                layout: 'fit', // specify layout manager for items
			                items: StockQtyGrid       			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
	
})