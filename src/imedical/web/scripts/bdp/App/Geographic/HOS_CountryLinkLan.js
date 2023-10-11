/**----------------------------------���ҹ�������--------------------------------------**/	
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var CouLinkLan_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.HOSCountryLinkLan&pClassQuery=GetList";
	var CouLinkLan_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.HOSCountryLinkLan&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.HOSCountryLinkLan";	
	var CouLinkLan_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HOSCountryLinkLan&pClassMethod=DeleteData";
	var CouLinkLan_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HOSCountryLinkLan&pClassMethod=OpenDataExt";
	var BindingLanTp = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSLanguage&pClassQuery=GetDataForCmb1";
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	var pagesize1=Ext.BDP.FunLib.PageSize.Pop;

	// ɾ������  
	var CouLinkLanbtnDel = new Ext.Toolbar.Button({
		text : 'ɾ��',
		tooltip : 'ɾ��',
		iconCls : 'icon-delete',
		id : 'CouLinkLanbtnDel',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('CouLinkLanbtnDel'),
		handler : function() {
			if (gridCouLinkLan.selModel.hasSelection()) {
				Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ����ѡ��������?', function(btn) {
					if (btn == 'yes') {
						// Ext.MessageBox.wait('����ɾ����,���Ժ�...', '��ʾ');
						var gsm = gridCouLinkLan.getSelectionModel();
						var rows = gsm.getSelections();
						Ext.Ajax.request({
							url : CouLinkLan_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('ID')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '��ʾ',
											msg : '����ɾ���ɹ���',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(gridCouLinkLan,pagesize);	
											}
										});
									} 
									else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>������Ϣ:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '��ʾ',
													msg : '����ɾ��ʧ�ܣ�' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								} else {
									Ext.Msg.show({
												title : '��ʾ',
												msg : '�첽ͨѶʧ��,�����������ӣ�',
												icon : Ext.Msg.ERROR,
												buttons : Ext.Msg.OK
											});
								}
							}
						}, this);
					}
				}, this);
			} else {
				Ext.Msg.show({
							title : '��ʾ',
							msg : '��ѡ����Ҫɾ�����У�',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});
		
	// �����޸ĵ�Form 
	var CouLinkLanWinForm = new Ext.FormPanel({
			id : 'CouLinkLan-form-save',
			URL : CouLinkLan_SAVE_ACTION_URL,
			baseCls : 'x-plain',// form͸��,����ʾ���
			labelAlign : 'right',
			labelWidth : 75,
			split : true,
			frame : true,
			waitMsgTarget : true,
			reader : new Ext.data.JsonReader({
						root : 'list'
					}, [{
								name : 'ID',
								mapping : 'ID'
							},{
								name : 'CLLLANCode',
								mapping : 'CLLLANCode'
							}, {
								name : 'CLLActivity',
								mapping : 'CLLActivity'
							}, {
								name : 'CLLIsDefault',
								mapping : 'CLLIsDefault'
							}, {
								name : 'CLLStartDate',
								mapping : 'CLLStartDate'
							}, 
							{
								name : 'CLLEndDate',
								mapping : 'CLLEndDate'
							},
							{
								name : 'CLLPYCode',
								mapping : 'CLLPYCode'
							},
							{
								name : 'CLLWBCode',
								mapping : 'CLLWBCode'
							},
							{
								name : 'CLLMark',
								mapping : 'CLLMark'
							},
							]),
			defaults : {
				anchor : '90%',
				bosrder : false
			},
			items : [{
						id : 'ID',
						xtype : 'textfield',
						fieldLabel : 'RowId',
						name : 'ID',
						hideLabel : 'True',
						hidden : true
					},{
						xtype : 'bdpcombo',
						fieldLabel: "<span style='color:red;'>*</span>����",
						id:'CLLLANCodeF',
						blankText: '����Ϊ��',
						allowBlank : false,
						name: 'CLLLANCode',
						hiddenName:'CLLLANCode',//������id��ͬ
						loadByIdParam : 'rowid',
						forceSelection: true,
						//triggerAction : 'all',
						selectOnFocus:false,
						queryParam : 'desc', //chneying
						//hidden : true,
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('CLLLANCode'),
						style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CLLLANCode')),
						mode:'remote',
						pageSize:Ext.BDP.FunLib.PageSize.Combo,
						listWidth:250,
						valueField:'CTLANRowId',
						displayField:'CTLANDesc',
						store:new Ext.data.JsonStore({
						url:BindingLanTp,
						root: 'data',
						totalProperty: 'total',
						autoLoad: true,
						idProperty: 'CTLANRowId',
						fields:['CTLANRowId','CTLANDesc']
							
						}),
					},
					{
						xtype:'checkbox',
						fieldLabel: '�Ƿ���Ч',
				        name: 'CLLActivity',
				        id: 'CLLActivity',
				        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CLLActivity'),
				        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CLLActivity')),
				        //dataIndex:'CTCPTRotaryFlag',
				        checked:true,  //chenying
				        inputValue : true?'Y':'N'
					},
					{
						xtype:'checkbox',
						fieldLabel: '�Ƿ�Ĭ��',
				        name: 'CLLIsDefault',
				        id: 'CLLIsDefault',
				        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CLLIsDefault'),
				        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CLLIsDefault')),
				        //dataIndex:'CTCPTRotaryFlag',
				        checked:true,  //chenying
				        inputValue : true?'Y':'N'
					},{
						xtype : 'datefield',
						fieldLabel : '<span style="color:red;">*</span>��ʼ����',
						name : 'CLLStartDate',
						format : BDPDateFormat,
						id:'CLLStartDate',
						allowBlank:false,
						//disabled : Ext.BDP.FunLib.Component.DisableFlag('date1'),
						style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CLLStartDate')),
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('CLLStartDate'),
						enableKeyEvents : true,
						listeners : {
						   'keyup' : function(field, e){
								Ext.BDP.FunLib.Component.GetCurrentDate(field, e  );							
								}
						}
						                                    //-------------ʹ���Զ����vtype��֤
					},{
						xtype : 'datefield',
						fieldLabel : '��������',
						name : 'CLLEndDate',
						format : BDPDateFormat,
						id:'CLLEndDate',
						//disabled : Ext.BDP.FunLib.Component.DisableFlag('date1'),
						style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CLLEndDate')),
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('CLLEndDate'),
						enableKeyEvents : true,
						listeners : {
						   'keyup' : function(field, e){
								Ext.BDP.FunLib.Component.GetCurrentDate(field, e  );							
								}
						}
						                                    
					},{
						fieldLabel: "ƴ����",
						hiddenName:'CLLPYCode',
						dataIndex:'CLLPYCode',
						id:'CLLPYCode',
						xtype: "textfield",
						//labelSeparator: "��",
						labelAlign: "left",
						msgTarget: "side",
						autoFitErrors: false,
						},{
						fieldLabel: "�����",
						hiddenName:'CLLWBCode',
						dataIndex:'CLLWBCode',
						id:'CLLWBCode',
						xtype: "textfield",
						//labelSeparator: "��",
						labelAlign: "left",
						msgTarget: "side",
						autoFitErrors: false,
						},{
						fieldLabel: "��ע",
						hiddenName:'CLLMark',
						dataIndex:'CLLMark',
						id:'CLLMark',
						labelWidth: 80,
						width: 150,
						xtype: "textfield",
						//labelSeparator: "��",
						labelAlign: "left",
						msgTarget: "side",
						autoFitErrors: false,
						}]
		});
		
		
	var height=Math.min(Ext.getBody().getViewSize().height-30,830)	
	//�����޸�ʱ�����Ĵ���
	var CouLinkLanwin = new Ext.Window({
		title : '',
		width : 280,
		height : 300,
		layout : 'fit',
		closeAction : 'hide',
		plain : true,// true�����屳��͸��
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : CouLinkLanWinForm,
		buttons : [{
			text : '����',
			id : 'CouLinkLan_savebtn',
			iconCls : 'icon-save',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('CouLinkLan_savebtn'),
			handler : function() {
				if(CouLinkLanWinForm.getForm().isValid()==false){
					 Ext.Msg.alert('��ʾ','<font color = "red">������֤ʧ�ܣ�<br/>�����������ݸ�ʽ�Ƿ�����');
					 return;
				}
				var startDate = Ext.getCmp("CLLStartDate").getValue();
			   	var endDate = Ext.getCmp("CLLEndDate").getValue();
			   	if (startDate != "" && endDate != "") {
        			if (startDate > endDate) {
	        			///alert(123)
        				Ext.Msg.show({
        					title : '��ʾ',
							msg : '��ʼ���ڲ��ܴ��ڽ������ڣ�',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
          			 	return;
      				}
      				
			   	}
				// -------���----------
				if (CouLinkLanwin.title == "���") {
					CouLinkLanWinForm.form.submit({
						url : CouLinkLan_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '��ʾ',
						waitMsg : '�����ύ�������Ժ�...',
						method : 'POST',
						params : {
								'CLLCountryCode' : Ext.getCmp("Hidden_CTCountryId").getValue() //�ڴ򿪵�ʱ��,�Ѹ�ֵ
							},
						success : function(form, action){
							if (action.result.success == 'true'){
								CouLinkLanwin.hide();
								var myrowid = action.result.id;
								//alert(myrowid)
								Ext.Msg.show({
											title : '��ʾ',
											msg : '��ӳɹ���',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = gridCouLinkLan.getBottomToolbar().cursor;
												gridCouLinkLan.getStore().baseParams = {	
													cllcoudr : Ext.getCmp("Hidden_CTCountryId").getValue()
												};
												gridCouLinkLan.getStore().load({
															params : {
																start : 0,
																limit : pagesize1,
																rowid:myrowid
															}
														});
											}
										});
							} 
							else {
								var errorMsg = '';
								if (action.result.errorinfo){
									errorMsg = '<br/>������Ϣ:'+ action.result.errorinfo
								}
								Ext.Msg.show({
											title : '��ʾ',
											msg : '���ʧ�ܣ�' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}
						},
						failure : function(form, action) {
							Ext.Msg.alert('��ʾ', '���ʧ�ܣ�');
						}
					})
				}
				// ---------�޸�-------
				else {
					Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ�޸ĸ���������?', function(btn) {
						if (btn == 'yes') {
							CouLinkLanWinForm.form.submit({
								url : CouLinkLan_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '�����ύ�������Ժ�...',
								waitTitle : '��ʾ',
								method : 'POST',
								params : {
										'CLLCountryCode' : Ext.getCmp("Hidden_CTCountryId").getValue() //�ڴ򿪵�ʱ��,�Ѹ�ֵ
									},
								success : function(form, action) {
									if (action.result.success == 'true') {
										CouLinkLanwin.hide();
										var myrowid = "rowid="+action.result.id;
										Ext.Msg.show({
											title : '��ʾ',
											msg : '�޸ĳɹ���',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												gridCouLinkLan.getStore().baseParams={  //���gridCouLinkLan���ܷ�ҳ������,�ͷ�ҳ�����ú���ʾ�հ׵����� 13-9-23
												cllcoudr : Ext.getCmp("Hidden_CTCountryId").getValue()
						
													};
													gridCouLinkLan.getStore().load({
														params : {
																start : 0,
																limit : pagesize1,
																rowid :myrowid
														}
													});
																}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>������Ϣ:'
													+ action.result.errorinfo
										}
										Ext.Msg.show({
													title : '��ʾ',
													msg : '�޸�ʧ�ܣ�' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}

								},
								failure : function(form, action) {
									Ext.Msg.alert('��ʾ', '�޸�ʧ�ܣ�');
								}
							})
						}
					}, this);
					// WinForm.getForm().reset();
				}
			}
		}, {
			text : '�ر�',
			iconCls : 'icon-close',
			handler : function() {
				CouLinkLanwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				CouLinkLanWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
	
	//���Ӱ�ť
	var CouLinkLanbtnAdd = new Ext.Toolbar.Button({
		text : '���',
		tooltip : '���',
		iconCls : 'icon-add',
		id : 'CouLinkLanbtnAdd',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('CouLinkLanbtnAdd'),
		handler : function() {
			CouLinkLanwin.setTitle('���');
			CouLinkLanwin.setIconClass('icon-add');
			CouLinkLanwin.show();
			CouLinkLanWinForm.getForm().reset();
		},
		scope : this
	});
	
	// �޸İ�ť
	var CouLinkLanbtnEdit = new Ext.Toolbar.Button({
				text : '�޸�',
				tooltip : '�޸�',
				iconCls : 'icon-update',
				id : 'CouLinkLanbtnUpdate',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CouLinkLanbtnUpdate'),
				handler : function() {
					if (gridCouLinkLan.selModel.hasSelection()) {
						CouLinkLanwin.setTitle('�޸�');
						CouLinkLanwin.setIconClass('icon-update');
						CouLinkLanwin.show();
						loadCouLinkLanFormData(gridCouLinkLan);
					} else {
						Ext.Msg.show({
									title : '��ʾ',
									msg : '��ѡ����Ҫ�޸ĵ��У�',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});
			
	// ��ɾ�Ĺ�����
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [CouLinkLanbtnAdd, '-', CouLinkLanbtnEdit, '-', CouLinkLanbtnDel, ]
			
		})
		
	//����������
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '����',
				handler : function() {
					gridCouLinkLan.getStore().baseParams={				
							clllandr: Ext.getCmp("CLLlan").getValue(),
							cllcoudr: Ext.getCmp("Hidden_CTCountryId").getValue()					
					};
					gridCouLinkLan.getStore().load({
						params : {
							start : 0,
							limit : pagesize
						}
					});
				}

			});

				
	// ˢ�¹�����
	var CouLinkLanbtnRefresh = new Ext.Button({
		id : 'CouLinkLanbtnRefresh',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('CouLinkLanbtnRefresh'),
		tooltip : '����',
		iconCls : 'icon-refresh',
		text : '����',
		handler : function() {
			Ext.getCmp("CLLlan").reset();
			gridCouLinkLan.getStore().baseParams={  //���gridCouLinkLan���ܷ�ҳ������,�ͷ�ҳ�����ú���ʾ�հ׵����� 13-9-23 
						cllcoudr : Ext.getCmp("Hidden_CTCountryId").getValue()
						
			};
			gridCouLinkLan.getStore().load({
				params : {
						start : 0,
						limit : pagesize1
				}
			});
		}
});
	//���Լ���������
	var CLLlansearch = new Ext.BDP.Component.form.ComboBox({
				width:100,
				loadByIdParam : 'rowid',
				fieldLabel: '����',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CLLlan'),
				id:'CLLlan',
				//triggerAction:'all',//query
				forceSelection: true,
				selectOnFocus:false,
				mode:'remote',
				pageSize:Ext.BDP.FunLib.PageSize.Combo,
				listWidth:250,
				valueField:'CTLANRowId',
				displayField:'CTLANDesc',
				store:new Ext.data.JsonStore({
					url:BindingLanTp,
					root: 'data',
					totalProperty: 'total',
					idProperty: 'CTLANRowId',
					fields:['CTLANRowId','CTLANDesc']
				}),
				
			});
	//������������һ��
	var CouLinkLantbbutton = new Ext.Toolbar({
		id:'CouLinkLantbbutton',
		enableOverflow : true,
		items : [/*'����', {
							xtype : 'textfield',
							id : 'TextCLLMark',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCLLMark'),
							emptyText:'���뱸ע..'
						}*/'����',CLLlansearch,'-',btnSearch,'-',CouLinkLanbtnRefresh,  //chenying
				{  
					xtype : 'textfield',
					hidden:true,
					id:'Hidden_CTCountryId'
				}],
				listeners : {
					render : function() {
					tbbutton.render(gridCouLinkLan.tbar) // tbar.render(panel.bbar)���Ч���ڵײ�
					}
				}
	});


	var CouLinkLands = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : CouLinkLan_QUERY_ACTION_URL
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
								name : 'ID',   //RowId
								mapping : 'ID',
								type : 'string'
							}, 
							{
								name : 'CLLCountryCode', //����
								mapping : 'CLLCountryCode',
								type : 'string'
							},
							{
								name : 'CLLLANCode',  //����
								mapping : 'CLLLANCode',
								type : 'string'
							},
							{
								name : 'CLLActivity', //�Ƿ���Ч
								mapping : 'CLLActivity',
								type : 'string'
							},
							{
								name : 'CLLIsDefault', //�Ƿ�Ĭ��
								mapping : 'CLLIsDefault',
								type : 'string'
							},
							{
								name : 'CLLStartDate', //��ʼ����
								mapping : 'CLLStartDate',
								type : 'string'
							},{
								name : 'CLLEndDate', //��������
								mapping : 'CLLEndDate',
								type : 'string'
							},{
								name : 'CLLPYCode',  //ƴ����
								mapping : 'CLLPYCode',
								type : 'string'
							},{
								name : 'CLLWBCode',  //�����
								mapping : 'CLLWBCode',
								type : 'string'
							},{
								name : 'CLLMark',  //��ע
								mapping : 'CLLMark',
								type : 'string'
							}
								
				   			])

		});
		// ��������
	CouLinkLands.load({
				params : {
					start : 0,
					limit : pagesize1
				},
				callback : function(records, options, success) {
				}
			});
			
		// ��ҳ������
	var CouLinkLanpaging = new Ext.PagingToolbar({
				pageSize : pagesize1,
				store : CouLinkLands,
				displayInfo : true,
				displayMsg : '��ʾ�� {0} ���� {1} ����¼, һ�� {2} ��',
				emptyMsg : "û�м�¼",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pagesize1 = this.pageSize;
				         }
		        }
			});
			
	// ����Grid
	var CouLinkLansm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	var gridCouLinkLan = new Ext.grid.GridPanel({
		id : 'gridCouLinkLan',
		region : 'center',
		width : 560,
		height : 370,
		closable : true,
		store : CouLinkLands,
		trackMouseOver : true,
		columns : [CouLinkLansm, {
					header : 'RowId',
					width : 70,
					sortable : true,
					dataIndex : 'ID',
					hidden : true
				},{
					header : '����',
					width : 80,
					sortable : true,
					dataIndex : 'CLLLANCode'
				},{
					header : '�Ƿ���Ч',
					width : 80,
					sortable : true,
					renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon, 
					dataIndex : 'CLLActivity'
				},{
					header : '�Ƿ�Ĭ��',
					width : 80,
					sortable : true,
					renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon, 
					dataIndex : 'CLLIsDefault'
				},{
					header : '��ʼ����',
					width : 80,
					sortable : true,
					dataIndex : 'CLLStartDate'
				},{
					header : '��������',
					width : 80,
					sortable : true,
					dataIndex : 'CLLEndDate'
				},{
					header : '��ע',
					width : 80,
					sortable : true,
					dataIndex : 'CLLMark'
				},{
					header : 'ƴ����',
					width : 80,
					sortable : true,
					dataIndex : 'CLLPYCode'
				},{
					header : '�����',
					width : 80,
					sortable : true,
					dataIndex : 'CLLWBCode'
				}],
		stripeRows : true,
		loadMask : {
			msg : '���ݼ�����,���Ժ�...'
		},
		// config options for stateful behavior
		stateful : true,
		viewConfig : {
			forceFit : true
		},
		bbar : CouLinkLanpaging,
		tbar : CouLinkLantbbutton,
		stateId : 'gridCouLinkLan'
	});
	Ext.BDP.FunLib.ShowUserHabit(gridCouLinkLan,Ext.BDP.FunLib.SortTableName); 
	
	
	var loadCouLinkLanFormData = function(gridCouLinkLan) {
		var _record = gridCouLinkLan.getSelectionModel().getSelected();
		//alert(_record)
		if (!_record) {
			// Ext.Msg.alert('�޸�','��ѡ��Ҫ�޸ĵ�һ�');
		} else {
			CouLinkLanWinForm.form.load({
						url : CouLinkLan_OPEN_ACTION_URL + '&id='+ _record.get('ID'),
						// waitMsg : '������������...',
						success : function(form, action) {
							// Ext.Msg.alert('�༭','����ɹ���');
						},
						failure : function(form, action) {
							Ext.Msg.alert('�༭', '����ʧ�ܣ�');
						}
					});
		}
	};
	
	gridCouLinkLan.on("rowdblclick", function(grid, rowIndex, e) {
		CouLinkLanwin.setTitle('�޸�');
		CouLinkLanwin.setIconClass('icon-update');
		CouLinkLanwin.show();
		loadCouLinkLanFormData(gridCouLinkLan);
	});
	
	var CouLinkLanwindow = new Ext.Window({
		title : '',
		width : 590,
		height : 420,
		plain : true,// true�����屳��͸��
		modal : true,
		frame : true,// win����ȫ����Ӱ,��Ϊfalse��ֻ�б߿�����Ӱ
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',// �رմ��ں�ִ����������
		items : gridCouLinkLan
	});
	
	var width=Math.min(Ext.getBody().getViewSize().width-30,830)	
    function getCouLinkLanPanel(){
        var winCouLinkLan = new Ext.Window({
                title:'',
                width:width, //chenying
                height:500,
                layout:'fit',
                plain:true,//true�����屳��͸��
                modal:true,
                frame:true,
                //autoScroll: true,
                collapsible:true,
                hideCollapseTool:true,
                titleCollapse: true,
                bodyStyle:'padding:3px',
                buttonAlign:'center',
                closeAction:'hide',
                labelWidth:55,
                items: gridCouLinkLan,
                listeners:{
                    "show":function(){
                    },
                    "hide":function(){
                    },
                    "close":function(){
                    }
                }
            });
        //gridResource.getStore().load({params:{start:0, limit:12,RESCode:ctcode}})	
          return winCouLinkLan;
    }