// /����: Ч�ڱ�����ѯ
// /����: Ч�ڱ�����ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.13
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gIncId='';
	var gStrParam='';
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];

	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '����',
				id : 'PhaLoc',
				name : 'PhaLoc',
				groupId:gGroupId,
				anchor : '90%',
				stkGrpId : 'StkGrpType'
			});
	
	var DateTime = new Ext.ux.DateField({
				fieldLabel : '��ֹЧ��',
				id : 'DateTime',
				name : 'DateTime',
				anchor : '90%',
				
				width : 140,
				value : new Date()
			});
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,//��ʶ��������
			anchor : '90%',
			width : 140,
			LocId:gLocId,
			UserId:gUserId,
			childCombo : 'DHCStkCatGroup'
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

		var ZeroFlag = new Ext.form.Checkbox({
					fieldLabel : '����������',
					id : 'ZeroFlag',
					name : 'ZeroFlag',
					anchor : '90%',
					width : 100,
					height : 10,
					checked : false
				});

		var NotUseFlag = new Ext.form.Checkbox({
					fieldLabel : '�ų���������',
					id : 'NotUseFlag',
					name : 'NotUseFlag',
					anchor : '90%',
					width : 100,
					height : 10,
					checked : false
				});

		var ZeroMonth = new Ext.form.Checkbox({
					fieldLabel : '����',
					id : 'ZeroMonth',
					name : 'ZeroMonth',
					anchor : '90%',
					width :50,
					height : 10,
					labelStyle: 'background-color:Red;',

					checked : false
				});
		var OneMonth = new Ext.form.Checkbox({
			fieldLabel : '1��',
			id : 'OneMonth',
			name : 'OneMonth',
			anchor : '90%',
			width :50,
			height : 10,
			labelStyle: 'background-color:Blue;',
			checked : false
		});
		var TwoMonth = new Ext.form.Checkbox({
			fieldLabel : '2��',
			id : 'TwoMonth',
			name : 'TwoMonth',
			anchor : '90%',
			width :50,
			labelStyle: 'background-color:Yellow;',
			height : 10,
			checked : false
		});		
		var ThreeMonth = new Ext.form.Checkbox({
			fieldLabel : '3��',
			id : 'ThreeMonth',
			name : 'ThreeMonth',
			anchor : '90%',
			width :50,
			height : 10,
			labelStyle: 'background-color:Green;',
			checked : false
		});	
		var FourMonth = new Ext.form.Checkbox({
			fieldLabel : '4��',
			id : 'FourMonth',
			name : 'FourMonth',
			anchor : '90%',
			width :50,
			height : 10,
			labelStyle: 'background-color:Cyan;',
			checked : false
		});	
		var FiveMonth = new Ext.form.Checkbox({
			fieldLabel : '5��',
			id : 'FiveMonth',
			name : 'FiveMonth',
			anchor : '90%',
			width :50,
			height : 10,
			labelStyle: 'background-color:Orange;',
			checked : false
		});	
		var SixMonth = new Ext.form.Checkbox({
			fieldLabel : '6��',
			id : 'SixMonth',
			name : 'SixMonth',
			anchor : '90%',
			width :50,
			height : 10,
			labelStyle: 'background-color:Pink;',
			checked : false
		});	
		var SevenMonth = new Ext.form.Checkbox({
			fieldLabel : '7��',
			id : 'SevenMonth',
			name : 'SevenMonth',
			anchor : '90%',
			width :50,
			height : 10,
			labelStyle: 'background-color:Purple;',
			checked : false
		});	
		var EightMonth = new Ext.form.Checkbox({
			fieldLabel : '8��',
			id : 'EightMonth',
			name : 'EightMonth',
			anchor : '90%',
			width :50,
			height : 10,
			labelStyle: 'background-color:LightBlue;',
			checked : false
		});	
		var NineMonth = new Ext.form.Checkbox({
			fieldLabel : '9��',
			id : 'NineMonth',
			name : 'NineMonth',
			anchor : '90%',
			width :50,
			height : 10,
			labelStyle: 'background-color:LightSeaGreen;',
			checked : false
		});	
		var TenMonth = new Ext.form.Checkbox({
			fieldLabel : '10��',
			id : 'TenMonth',
			name : 'TenMonth',
			anchor : '90%',
			width :50,
			height : 10,
			labelStyle: 'background-color:Lime;',
			checked : false
		});	
		var ElevenMonth = new Ext.form.Checkbox({
			fieldLabel : '11��',
			id : 'ElevenMonth',
			name : 'ElevenMonth',
			anchor : '90%',
			width :50,
			height : 10,
			labelStyle: 'background-color:Olive;',
			checked : false
		});	
		var TwelveMonth = new Ext.form.Checkbox({
			fieldLabel : '12��',
			id : 'TwelveMonth',
			name : 'TwelveMonth',
			anchor : '90%',
			width :50,
			height : 10,
			labelStyle: 'background-color:MediumAquaMarine;',
			checked : false
		});	
		var Normal = new Ext.form.Checkbox({
			fieldLabel : '����',
			id : 'Normal',
			name : 'Normal',
			anchor : '90%',
			width :50,
			height : 10,
			checked : false
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
			var date = Ext.getCmp("DateTime").getValue().format(ARG_DATEFORMAT)
					.toString();
			if (date == null || date.length <= 0) {
				Msg.info("warning", "���ڲ���Ϊ�գ�");
				Ext.getCmp("DateTime").focus();
				return;
			}
	       StockQtyStore.removeAll();
			// ��ѡ����
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			var DHCStkCatGroup = Ext.getCmp("DHCStkCatGroup").getValue();
			var ZeroDrug = (Ext.getCmp("ZeroFlag").getValue()==true?'Y':'N');
			var UseFlag = (Ext.getCmp("NotUseFlag").getValue()==true?'Y':'N');
			var RestMon=null;
			
			if(Ext.getCmp("ZeroMonth").getValue()==true){
				if(RestMon==null){
					RestMon=0;
				}else{
					RestMon=RestMon+','+0;
				}
			}
			if(Ext.getCmp("OneMonth").getValue()==true){
				if(RestMon==null){
					RestMon=1;
				}else{
					RestMon=RestMon+','+1;
				}
			}
			if(Ext.getCmp("TwoMonth").getValue()==true){
				if(RestMon==null){
					RestMon=2;
				}else{
					RestMon=RestMon+','+2;
				}
			}
			if(Ext.getCmp("ThreeMonth").getValue()==true){
				if(RestMon==null){
					RestMon=3;
				}else{
					RestMon=RestMon+','+3;
				}
			}
			if(Ext.getCmp("FourMonth").getValue()==true){
				if(RestMon==null){
					RestMon=4;
				}else{
					RestMon=RestMon+','+4;
				}
			}
			if(Ext.getCmp("FiveMonth").getValue()==true){
				if(RestMon==null){
					RestMon=5;
				}else{
					RestMon=RestMon+','+5;
				}
			}
			if(Ext.getCmp("SixMonth").getValue()==true){
				if(RestMon==null){
					RestMon=6;
				}else{
					RestMon=RestMon+','+6;
				}
			}
			if(Ext.getCmp("SevenMonth").getValue()==true){
				if(RestMon==null){
					RestMon=7;
				}else{
					RestMon=RestMon+','+7;
				}
			}
			if(Ext.getCmp("EightMonth").getValue()==true){
				if(RestMon==null){
					RestMon=8;
				}else{
					RestMon=RestMon+','+8;
				}
			}
			if(Ext.getCmp("NineMonth").getValue()==true){
				if(RestMon==null){
					RestMon=9;
				}else{
					RestMon=RestMon+','+9;
				}
			}
			if(Ext.getCmp("TenMonth").getValue()==true){
				if(RestMon==null){
					RestMon=10;
				}else{
					RestMon=RestMon+','+10;
				}
			}
			if(Ext.getCmp("ElevenMonth").getValue()==true){
				if(RestMon==null){
					RestMon=11;
				}else{
					RestMon=RestMon+','+11;
				}
			}
			if(Ext.getCmp("TwelveMonth").getValue()==true){
				if(RestMon==null){
					RestMon=12;
				}else{
					RestMon=RestMon+','+12;
				}
			}
			if(Ext.getCmp("Normal").getValue()==true){
				if(RestMon==null){
					RestMon=13;
				}else{
					RestMon=RestMon+','+13;
				}
			}
			if(RestMon==null){Msg.info("warning", "��ѡ�񱨾�����ʱ��!");
				return;}
			gStrParam=phaLoc+"^"+date+"^"+RestMon+"^"+DHCStkCatGroup
			+"^"+UseFlag+"^"+StkGrpRowId;
			
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.setBaseParam('Params',gStrParam);
			StockQtyStore.load({params:{start:0,limit:pageSize}});

		}
				
		// ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
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
			Ext.getCmp("DHCStkCatGroup").setValue('');
			Ext.getCmp("StkGrpType").setValue('');
			Ext.getCmp("Normal").setValue(false);
			Ext.getCmp("ZeroFlag").setValue(false);
			Ext.getCmp("ZeroMonth").setValue(false);
			Ext.getCmp("NotUseFlag").setValue(false);
			Ext.getCmp("OneMonth").setValue(false);
			Ext.getCmp("TwoMonth").setValue(false);
			Ext.getCmp("ThreeMonth").setValue(false);
			Ext.getCmp("FourMonth").setValue(false);
			Ext.getCmp("FiveMonth").setValue(false);
			Ext.getCmp("SixMonth").setValue(false);
			Ext.getCmp("SevenMonth").setValue(false);
			Ext.getCmp("EightMonth").setValue(false);
			Ext.getCmp("NineMonth").setValue(false);
			Ext.getCmp("TenMonth").setValue(false);
			Ext.getCmp("ElevenMonth").setValue(false);
			Ext.getCmp("TwelveMonth").setValue(false);
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}

		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, sm, {
					header : "inci",
					dataIndex : 'inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '���ʴ���',
					dataIndex : 'code',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "��������",
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
					header : "����",
					dataIndex : 'manf',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "������",
					dataIndex : 'incscDesc',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : 'ע��֤��',
					dataIndex : 'RegCertNo',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "ע��֤Ч��",
					dataIndex : 'expDate',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "ʧЧ����",
					dataIndex : 'warnDays',
					width : 80,
					align : 'left',
					sortable : true
				}]);
		StockQtyCm.defaultSortable = true;

		// ����·��
		var DspPhaUrl = DictUrl
					+ 'regcertexpdateaction.csp?actiontype=jsRegCertOfExp&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["inci", "code", "desc","spec", "manf", "incscDesc",
				 "RegCertNo","expDate", "warnDays","month"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "inci",
					fields : fields
				});
		// ���ݼ�
		var StockQtyStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
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
					emptyMsg : "û������"
					
				});

		var StockQtyGrid = new Ext.ux.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : sm, //new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					bbar : StatuTabPagingToolbar,
					viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){ 
						var Month=record.get("month");
						Month=parseInt(Month);
						switch(Month){
							case 0:
								return 'classRed';
								break;
							case 1:
								return 'classBlue';
								break;	
							case 2:
								return 'classYellow';
								break;	
							case 3:
								return 'classGrassGreen';
								break;	
							case 4:
								return 'classCyan';
								break;
							case 5:
								return 'classOrange';
								break;
							case 6:
								return 'classPink';
								break;
							case 7:
								return 'classPurple';
								break;
							case 8:
								return 'classLightBlue';
								break;
							case 9:
								return 'classLightSeaGreen';
								break;
							case 10:
								return 'classLime';
								break;
							case 11:
								return 'classLightGoldenYellow';
								break;
							case 12:
								return 'classDeepSkyBlue';
								break;
							default:
								break;
						}            
                    }
            	}
		});
		
		var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			width : 300,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 1px 1px 5px;',
			tbar : [SearchBT, '-', RefreshBT],			   						
			items : [PhaLoc,DateTime,StkGrpType,DHCStkCatGroup,NotUseFlag,
				ZeroMonth,OneMonth,TwoMonth,ThreeMonth,FourMonth,FiveMonth,SixMonth,
				SevenMonth,EightMonth,NineMonth,TenMonth,ElevenMonth,TwelveMonth,Normal]
		});

		// 5.2.ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'west',
			                split: true,
                			width: 300,
                			minSize: 200,
                			maxSize: 350,
                			collapsible: true,
			                title: 'ע��֤Ч�ڱ���',
			                layout: 'fit', // specify layout manager for items
			                items: HisListTab       
			               
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