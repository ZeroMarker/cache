// ����:����ά��
// ��д����:2012-05-10

var ManfTakePicWindow;
var conditionCodeField = new Ext.form.TextField({
		id: 'conditionCodeField',
		fieldLabel: '����',
		allowBlank: true,
		anchor: '90%',
		selectOnFocus: true,
		listeners: {
			'specialkey': function (t, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					findPhManf.handler();
				}
			}
		}
	});

var conditionNameField = new Ext.form.TextField({
		id: 'conditionNameField',
		fieldLabel: '����',
		allowBlank: true,
		anchor: '90%',
		selectOnFocus: true,
		listeners: {
			'specialkey': function (t, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					findPhManf.handler();
				}
			}
		}
	});

var ActiveData=[['ȫ��',''],['����','Y'],['δ����','N']];
	var ActiveStore = new Ext.data.SimpleStore({
		fields: ['Activedesc', 'Activeid'],
		data : ActiveData
	});
var conditionactiveField = new Ext.form.ComboBox({
	store: ActiveStore,
	displayField:'Activedesc',
	mode: 'local', 
	anchor : '90%',
	emptyText:'',
	id:'conditionactiveField',
	fieldLabel : '�Ƿ񼤻�',
	triggerAction:'all',
	valueField : 'Activeid'
});
Ext.getCmp("conditionactiveField").setValue("");
	
var PhManfGrid = "";
//��������Դ
var PhManfGridUrl = 'dhcstm.phmanfnewaction.csp';
var PhManfGridProxy = new Ext.data.HttpProxy({
		url: PhManfGridUrl + '?actiontype=query',
		method: 'POST'
	});
var PhManfGridDs = new Ext.data.Store({
		proxy: PhManfGridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [{
					name: 'RowId'
				}, {
					name: 'Code'
				}, {
					name: 'Name'
				}, {
					name: 'Address'
				}, {
					name: 'Tel'
				}, {
					name: 'AddManfId'
				}, {
					name: 'ParManfId'
				}, {
					name: 'ParManf'
				}, {
					name: 'socialCreditCodeText'
				}, {
					name: 'socialCreditCodeDateTo'
				}, {
					name: 'drugProPermitText'
				}, {
					name: 'drugProPermitDateTo'
				}, {
					name: 'insProLicText'
				}, {
					name: 'insProLicDateTo'
				}, {
					name: 'comLicText'
				}, {
					name: 'comLicDateTo'
				}, {
					name: 'Active'
				}, {
					name: 'businessRegNoText'
				}, {
					name: 'businessRegNoDateTo'
				}, {
					name: 'orgCodeText'
				}, {
					name: 'orgCodeDateTo'
				}, {
					name: 'insBusLicText'
				}, {
					name: 'insBusLicDateTo'
				}, {
					name: 'prodEprsHygLicText'
				}, {
					name: 'prodEprsHygLicDateTo'
				}, {
					name: 'taxLicText'
				}
			]),
		remoteSort: false
	});

//ģ��
var PhManfGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "����",
				dataIndex: 'Code',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'Name',
				width: 200,
				align: 'left',
				sortable: true
			}, {
				header: "��ַ",
				dataIndex: 'Address',
				width: 200,
				align: 'left',
				sortable: false
			}, {
				header: "�绰",
				dataIndex: 'Tel',
				width: 100,
				align: 'left',
				sortable: false
			}, {
				header: "�ϼ�����",
				dataIndex: 'ParManf',
				width: 150,
				align: 'left',
				sortable: false
			}, {
				header: "���������",
				dataIndex: 'socialCreditCodeText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "���������Ч��",
				dataIndex: 'socialCreditCodeDateTo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "ҩ���������",
				dataIndex: 'drugProPermitText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "ҩ�����������Ч��",
				dataIndex: 'drugProPermitDateTo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "��е�������",
				dataIndex: 'insProLicText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "��е���������Ч��",
				dataIndex: 'insProLicDateTo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "����ִ�����",
				dataIndex: 'comLicText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "����ִ�������Ч��",
				dataIndex: 'comLicDateTo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "����ע���",
				dataIndex: 'businessRegNoText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "����ע��Ч��",
				dataIndex: 'businessRegNoDateTo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "��֯��������",
				dataIndex: 'orgCodeText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "��֯��������Ч��",
				dataIndex: 'orgCodeDateTo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "˰��ǼǺ�",
				dataIndex: 'taxLicText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "��е��Ӫ���֤",
				dataIndex: 'insBusLicText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "��е��Ӫ���֤Ч��",
				dataIndex: 'insBusLicDateTo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "������ҵ�������֤",
				dataIndex: 'prodEprsHygLicText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "������ҵ�������֤Ч��",
				dataIndex: 'prodEprsHygLicDateTo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "�����ʶ",
				dataIndex: 'Active',
				width: 80,
				align: 'left',
				sortable: true,
				renderer: function (v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col' + (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
				}
			}
		]);

//��ʼ��Ĭ��������
PhManfGridCm.defaultSortable = true;

var findPhManf = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			var conditionCode = Ext.getCmp('conditionCodeField').getValue();
			var conditionName = Ext.getCmp('conditionNameField').getValue();
			var activeFlag=Ext.getCmp('conditionactiveField').getValue();
			PhManfGridDs.setBaseParam('sort', 'RowId');
			PhManfGridDs.setBaseParam('dir', 'desc');
			PhManfGridDs.setBaseParam('conditionCode', conditionCode);
			PhManfGridDs.setBaseParam('conditionName', conditionName);
			PhManfGridDs.setBaseParam('activeFlag', activeFlag);
			PhManfGridDs.load({
				params: {
					start: 0,
					limit: PhManfPagingToolbar.pageSize
				},
				callback: function (r, options, success) {
					if (success == false) {
						Msg.info("error", "��ѯ������鿴��־!");
					}
				}
			});
		}
	});

//���̱༭����
//zdm,2013-03-06
function CreateEditWin(rowid) {

	//���̴���
	var codeField = new Ext.form.TextField({
			id: 'codeField',
			fieldLabel: '<font color=red>���̴���</font>',
			allowBlank: false,
			maxLength: 12,
			emptyText: '�½�ʱΪ��,���Զ�����...',
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('codeField').getValue() == "") {
							Handler = function () {
								codeField.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: '���̴��벻��Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							nameField.focus();
						}
					}
				}
			}
		});

	//��������
	var nameField = new Ext.form.TextField({
			id: 'nameField',
			fieldLabel: '<font color=red>��������</font>',
			allowBlank: false,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('nameField').getValue() == "") {
							Handler = function () {
								nameField.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: '�������Ʋ���Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							addressField.focus();
						}
					}
				}
			}
		});

	//���̵�ַ
	var addressField = new Ext.form.TextField({
			id: 'addressField',
			fieldLabel: '���̵�ַ',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						phoneField.focus();
					}
				}
			}
		});

	//���̵绰
	var phoneField = new Ext.form.TextField({
			id: 'phoneField',
			fieldLabel: '���̵绰',
			allowBlank: true,
			anchor: '90%',
			regex: /^[^\u4e00-\u9fa5]{0,}$/,
			regexText: '����ȷ�ĵ绰����',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						lastPhManfField.focus();
					}
				}
			}
		});

	//�ϼ�����
	var lastPhManfField = new Ext.ux.ComboBox({
			id: 'lastPhManfField',
			fieldLabel: '�ϼ�����',
			anchor: '90%',
			allowBlank: true,
			store: PhManufacturerStore,
			filterName: 'PHMNFName',
			editable: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						drugProPermitText.focus();
					}
				}
			}
		});

	//ҩ���������
	var drugProPermitText = new Ext.form.TextField({
			id: 'drugProPermitText',
			fieldLabel: 'ҩ���������',
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('drugProPermitText').getValue() == "") {
							Handler = function () {
								drugProPermitText.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: 'ҩ��������ɲ���Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							drugProPermitDateTo.focus();
						}
					}
				}
			}
		});

	//ҩ�����������Ч��
	var drugProPermitDateTo = new Ext.ux.DateField({
			id: 'drugProPermitDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('drugProPermitDateTo').getValue() == "") {
							Handler = function () {
								drugProPermitDateTo.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: 'ҩ�����������Ч�ڲ���Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							insProLicText.focus();
						}
					}
				}
			}
		});

	//��е�������
	var insProLicText = new Ext.form.TextField({
			id: 'insProLicText',
			fieldLabel: '��е�������',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('insProLicText').getValue() == "") {
							Handler = function () {
								insProLicText.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: '��е������ɲ���Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							insProLicDateTo.focus();
						}
					}
				}
			}
		});

	//��е���������Ч��
	var insProLicDateTo = new Ext.ux.DateField({
			id: 'insProLicDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('insProLicDateTo').getValue() == "") {
							Handler = function () {
								insProLicDateTo.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: '��е���������Ч�ڲ���Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							comLicText.focus();
						}
					}
				}
			}
		});

	//����ִ�����
	var comLicText = new Ext.form.TextField({
			id: 'comLicText',
			fieldLabel: '����ִ�����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('comLicText').getValue() == "") {
							Handler = function () {
								comLicText.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: '����ִ����ɲ���Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							comLicDateTo.focus();
						}
					}
				}
			}
		});

	//����ִ�������Ч��
	var comLicDateTo = new Ext.ux.DateField({
			id: 'comLicDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('comLicDateTo').getValue() == "") {
							Handler = function () {
								comLicDateTo.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: '����ִ�������Ч�ڲ���Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							businessRegNoText.focus();

						}
					}
				}
			}
		});
	//����ע���
	var businessRegNoText = new Ext.form.TextField({
			id: 'businessRegNoText',
			fieldLabel: '����ע���',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('businessRegNoText').getValue() == "") {
							Handler = function () {
								businessRegNoText.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: '����ע��Ų���Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							businessRegNoDateTo.focus();
						}
					}
				}
			}
		});

	//����ע��Ч��
	var businessRegNoDateTo = new Ext.ux.DateField({
			id: 'businessRegNoDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('businessRegNoDateTo').getValue() == "") {
							Handler = function () {
								businessRegNoDateTo.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: '����ע��Ч�ڲ���Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							orgCodeText.focus();
						}
					}
				}
			}
		});
	//��֯��������
	var orgCodeText = new Ext.form.TextField({
			id: 'orgCodeText',
			fieldLabel: '��֯��������',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('orgCodeText').getValue() == "") {
							Handler = function () {
								orgCodeText.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: '��֯�������벻��Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							orgCodeDateTo.focus();
						}
					}
				}
			}
		});

	//��֯��������Ч��
	var orgCodeDateTo = new Ext.ux.DateField({
			id: 'orgCodeDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('orgCodeDateTo').getValue() == "") {
							Handler = function () {
								orgCodeDateTo.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: '��֯��������Ч�ڲ���Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							taxLicText.focus();
						}
					}
				}
			}
		});
	//˰��ǼǺ�
	var taxLicText = new Ext.form.TextField({
			id: 'taxLicText',
			fieldLabel: '˰��ǼǺ�',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('taxLicText').getValue() == "") {
							Handler = function () {
								taxLicText.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: '˰��ǼǺŲ���Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							insBusLicText.focus();
						}
					}
				}
			}
		});
	//ҽ����е��Ӫ���֤
	var insBusLicText = new Ext.form.TextField({
			id: 'insBusLicText',
			fieldLabel: '��е��Ӫ���',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('insBusLicText').getValue() == "") {
							Handler = function () {
								insBusLicText.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: 'ҽ����е��Ӫ���֤����Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							insBusLicDateTo.focus();
						}
					}
				}
			}
		});

	//ҽ����е��Ӫ���֤Ч��
	var insBusLicDateTo = new Ext.ux.DateField({
			id: 'insBusLicDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('insBusLicDateTo').getValue() == "") {
							Handler = function () {
								insBusLicDateTo.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: 'ҽ����е��Ӫ���֤Ч�ڲ���Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							prodEprsHygLicText.focus();
						}
					}
				}
			}
		});
	//ҽ����е��Ӫ���֤
	var prodEprsHygLicText = new Ext.form.TextField({
			id: 'prodEprsHygLicText',
			fieldLabel: '������ҵ�������',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('prodEprsHygLicText').getValue() == "") {
							Handler = function () {
								prodEprsHygLicText.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: '������ҵ�������֤����Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							prodEprsHygLicDateTo.focus();
						}
					}
				}
			}
		});

	//ҽ����е��Ӫ���֤Ч��
	var prodEprsHygLicDateTo = new Ext.ux.DateField({
			id: 'prodEprsHygLicDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('prodEprsHygLicDateTo').getValue() == "") {
							Handler = function () {
								prodEprsHygLicDateTo.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: '������ҵ�������֤Ч�ڲ���Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							activeField.focus();
							activeField.setValue(true);
						}
					}
				}
			}
		});
	//����
	var activeField = new Ext.form.Checkbox({
			id: 'activeField',
			fieldLabel: '����',
			boxLabel: '����',
			hideLabel: true,
			allowBlank: false,
			checked: true, //Ĭ����"����"״̬
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						editButton.focus();
					}
				}
			}
		});

	//����ִ��
	var uploadButtonComLic = new Ext.Button({
			text: '�ϴ�',
			anchor: '10%',
			handler: function () {
				var type = "comLic";
				addManfPic(rowid, type);
			}
		});
	var uploadButtonComLicTP = new Ext.Button({
			text: '����',
			anchor: '10%',
			handler: function () {
				take_pic("comLic", "����ִ��");
			}
		});
	///˰��ִ��
	var uploadButtonTaxLic = new Ext.Button({
			text: '�ϴ�',
			handler: function () {
				var type = "taxLic";
				addManfPic(rowid, type);
			}
		});
	var uploadButtonTaxLicTP = new Ext.Button({
			text: '����',
			anchor: '10%',
			handler: function () {
				take_pic("taxLic", "˰��ִ��");
			}
		});

	//��������
	var uploadButtonOrgCode = new Ext.Button({
			text: '�ϴ�',
			handler: function () {
				var type = "orgCode";
				addManfPic(rowid, type);
			}
		});
	var uploadButtonOrgCodeTP = new Ext.Button({
			text: '����',
			anchor: '10%',
			handler: function () {
				take_pic("orgCode", "��������");
			}
		});
	//��е�������
	var uploadButtonInsProLic = new Ext.Button({
			text: '�ϴ�',
			handler: function () {
				var type = "insProLic";
				addManfPic(rowid, type);
			}
		});
	var uploadButtonInsProLicTP = new Ext.Button({
			text: '����',
			anchor: '10%',
			handler: function () {
				take_pic("insProLic", "��е�������֤");
			}
		});
	//��е��Ӫ���֤
	var uploadButtonInsBusLic = new Ext.Button({
			text: '�ϴ�',
			handler: function () {
				var type = "insBusLic";
				addManfPic(rowid, type);
			}
		});
	var uploadButtonInsBusLicTP = new Ext.Button({
			text: '����',
			anchor: '10%',
			handler: function () {
				take_pic("insBusLic", "��е��Ӫ���֤");
			}
		});
	//ҩƷ�������֤
	var uploadButtonDrugProLic = new Ext.Button({
			text: '�ϴ�',
			handler: function () {
				var type = "drugProLic";
				addManfPic(rowid, type);
			}
		});
	var uploadButtonDrugProLicTP = new Ext.Button({
			text: '����',
			anchor: '10%',
			handler: function () {
				take_pic("drugProLic", "ҩƷ�������֤");
			}
		});
	//������ҵ�������֤
	var uploadButtonMANFProdEprsHygLic = new Ext.Button({
			text: '�ϴ�',
			handler: function () {
				var type = "drugProLic";
				addManfPic(rowid, type);
			}
		});
	var uploadButtonMANFProdEprsHygLicTP = new Ext.Button({
			text: '����',
			anchor: '10%',
			handler: function () {
				take_pic("drugProLic", "������ҵ�������֤");
			}
		});

	var socialCreditCodeText = new Ext.form.TextField({
			id: 'socialCreditCodeText',
			fieldLabel: '���������',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//���������Ч��
	var socialCreditCodeDateTo = new Ext.ux.DateField({
			id: 'socialCreditCodeDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true
		});
	
	var uploadButtonSocialCreditCode = new Ext.Button({
			text: '�ϴ�',
			handler: function () {
				var type = "socialCreditCode";
				addManfPic(rowid, type);
			}
		});
	var uploadButtonSocialCreditCodeTP = new Ext.Button({
			text: '����',
			anchor: '10%',
			handler: function () {
				take_pic("socialCreditCode", "���������");
			}
		});
		
	//��ʼ�����
	editForm = new Ext.form.FormPanel({
			autoScroll: true,
			frame: true,
			labelWidth: 60,
			labelAlign: 'right',
			items: [{
					xtype: 'fieldset',
					title: '������Ϣ',
					autoHeight: true,
					items: [{
							layout: 'column',
							items: [{
									layout: 'form',
									columnWidth: .5,
									items: [codeField, phoneField]
								}, {
									layout: 'form',
									columnWidth: .5,
									items: [nameField, lastPhManfField]
								}
							]
						}, {
							layout: 'column',
							items: [{
									layout: 'form',
									columnWidth: .85,
									items: [addressField]
								}, {
									layout: 'form',
									columnWidth: .15,
									items: [activeField]
								}
							]
						}
					]
				}, {
					xtype: 'fieldset',
					title: '������Ϣ',
					autoHeight: true,
					items: [{
							layout: 'form',
							labelWidth: 170,
							items: [{
									xtype: 'compositefield',
									items: [socialCreditCodeText, socialCreditCodeDateTo, uploadButtonSocialCreditCode, uploadButtonSocialCreditCodeTP]
								}, {
									xtype: 'compositefield',
									items: [drugProPermitText, drugProPermitDateTo, uploadButtonDrugProLic, uploadButtonDrugProLicTP]
								}, {
									xtype: 'compositefield',
									items: [insProLicText, insProLicDateTo, uploadButtonInsProLic, uploadButtonInsProLicTP]
								}, {
									xtype: 'compositefield',
									items: [comLicText, comLicDateTo, uploadButtonComLic, uploadButtonComLicTP]
								}, {
									xtype: 'compositefield',
									items: [orgCodeText, orgCodeDateTo, uploadButtonOrgCode, uploadButtonOrgCodeTP]
								}, {
									xtype: 'compositefield',
									items: [insBusLicText, insBusLicDateTo, uploadButtonInsBusLic, uploadButtonInsBusLicTP]
								}, {
									xtype: 'compositefield',
									items: [prodEprsHygLicText, prodEprsHygLicDateTo, uploadButtonMANFProdEprsHygLic, uploadButtonMANFProdEprsHygLicTP]
								}, {
									xtype: 'compositefield',
									items: [businessRegNoText, businessRegNoDateTo]
								}, {
									xtype: 'compositefield',
									items: [taxLicText, uploadButtonTaxLic, uploadButtonTaxLicTP]
								}
							]
						}
					]
				}
			]
		});

	//��ʼ����Ӱ�ť
	editButton = new Ext.Toolbar.Button({
			text: '����',
			iconCls: 'page_save',
			handler: function () {
				if (rowid == "") {
					addHandler();
				} else {
					editHandler();
				}
			}
		});
	//��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({
			text: '�ر�',
			iconCls: 'page_close'
		});

	//����ȡ����ť����Ӧ����
	cancelHandler = function () {
		win.close();
	};

	//���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
	//��ʼ������
	var win = new Ext.Window({
			title: '����ά��',
			width: 600,
			height: gWinHeight,
			layout: 'fit',
			plain: true,
			modal: true,
			bodyStyle: 'padding:5px;',
			buttonAlign: 'center',
			items: editForm,
			resizable: false,
			buttons: [
				editButton,
				cancelButton
			],
			listeners: {
				'show': function (thisWin) {
					if (rowid != "") {
						Select(rowid);
					}
				}
			}
		});

	win.show();
	//����
	var addHandler = function () {
		/*
		���̻�����Ϣ
		*/
		var code = codeField.getValue();
		var name = nameField.getValue();
		var address = addressField.getValue();
		var phone = phoneField.getValue();
		var lastPhManfId = lastPhManfField.getValue();
		var active = (activeField.getValue() == true) ? 'Y' : 'N';
		
		/*������Ϣ
			�ϸ�������˳��
			ÿ��������ɴ�˳����������^������Ч��^���ʷ�֤����^���ʷ�֤����^Ч�ڳ��ڱ�־^���ڱ�־^��������
		*/
		// ҩƷ�������֤
		var drugProPermitText = Ext.getCmp('drugProPermitText').getValue();
		var drugProPermitDateTo = Ext.getCmp('drugProPermitDateTo').getValue();
		if ((drugProPermitDateTo != "") && (drugProPermitDateTo != null)) {
			drugProPermitDateTo = drugProPermitDateTo.format(ARG_DATEFORMAT);
		}
		var drugProPermitType="drugProPermit";
		var drugProPermitStr=drugProPermitType+"^"+drugProPermitText+"^"+drugProPermitDateTo;
		
		// ��е�������֤
		var insProLicText = Ext.getCmp('insProLicText').getValue();
		var insProLicDateTo = Ext.getCmp('insProLicDateTo').getValue();
		if ((insProLicDateTo != "") && (insProLicDateTo != null)) {
			insProLicDateTo = insProLicDateTo.format(ARG_DATEFORMAT);
		}
		var insProLicType="insProLic";
		var insProLicStr=insProLicType+"^"+insProLicText+"^"+insProLicDateTo;
		
		// ����ִ��
		var comLicText = Ext.getCmp('comLicText').getValue();
		var comLicDateTo = Ext.getCmp('comLicDateTo').getValue();
		if ((comLicDateTo != "") && (comLicDateTo != null)) {
			comLicDateTo = comLicDateTo.format(ARG_DATEFORMAT);
		}
		var comLicType="comLic";
		var comLicStr=comLicType+"^"+comLicText+"^"+comLicDateTo;
		
		// ����ע���
		var businessRegNoText = Ext.getCmp('businessRegNoText').getValue();
		var businessRegNoDateTo = Ext.getCmp('businessRegNoDateTo').getValue();
		if ((businessRegNoDateTo != "") && (businessRegNoDateTo != null)) {
			businessRegNoDateTo = businessRegNoDateTo.format(ARG_DATEFORMAT);
		}
		var businessRegNoType="businessRegNo";
		var businessRegNoStr=businessRegNoType+"^"+businessRegNoText+"^"+businessRegNoDateTo;
		
		// ��������
		var orgCodeText = Ext.getCmp('orgCodeText').getValue();
		var orgCodeDateTo = Ext.getCmp('orgCodeDateTo').getValue();
		if ((orgCodeDateTo != "") && (orgCodeDateTo != null)) {
			orgCodeDateTo = orgCodeDateTo.format(ARG_DATEFORMAT);
		}
		var orgCodeType="orgCode";
		var orgCodeStr=orgCodeType+"^"+orgCodeText+"^"+orgCodeDateTo;
		
		// ˰��Ǽ�֤
		var taxLicText = Ext.getCmp('taxLicText').getValue();
		var taxLicType="taxLic";
		var taxLicStr=taxLicType+"^"+taxLicText;
		
		// ��е��Ӫ���֤
		var insBusLicText = Ext.getCmp('insBusLicText').getValue();
		var insBusLicDateTo = Ext.getCmp('insBusLicDateTo').getValue();
		if ((insBusLicDateTo != "") && (insBusLicDateTo != null)) {
			insBusLicDateTo = insBusLicDateTo.format(ARG_DATEFORMAT);
		}
		var insBusLicType="insBusLic";
		var insBusLicStr=insBusLicType+"^"+insBusLicText+"^"+insBusLicDateTo;
		
		// ������ҵ�������֤
		var prodEprsHygLicText = Ext.getCmp('prodEprsHygLicText').getValue();
		var prodEprsHygLicDateTo = Ext.getCmp('prodEprsHygLicDateTo').getValue();
		if ((prodEprsHygLicDateTo != "") && (prodEprsHygLicDateTo != null)) {
			prodEprsHygLicDateTo = prodEprsHygLicDateTo.format(ARG_DATEFORMAT);
		}
		var prodEprsHygLicType="prodEprsHygLic";
		var prodEprsHygLicStr=prodEprsHygLicType+"^"+prodEprsHygLicText+"^"+prodEprsHygLicDateTo;
		
		// ���������
		var socialCreditCodeText = Ext.getCmp('socialCreditCodeText').getValue();
		var socialCreditCodeDateTo = Ext.getCmp('socialCreditCodeDateTo').getValue();
		if ((socialCreditCodeDateTo != "") && (socialCreditCodeDateTo != null)) {
			socialCreditCodeDateTo = socialCreditCodeDateTo.format(ARG_DATEFORMAT);
		}
		var socialCreditCodeType="socialCreditCode";
		var socialCreditCodeStr=socialCreditCodeType+"^"+socialCreditCodeText+"^"+socialCreditCodeDateTo;
		
		if (code.trim() == "") {}

		if (name.trim() == "") {
			Msg.info('warning', "�������Ʋ���Ϊ��");
			return;
		}

		//ƴdata�ַ���
		var Basicdata = code + "^" + name + "^" + address + "^" + phone + "^" + lastPhManfId+ "^" + active;
		var QualityData = drugProPermitStr+"&"+insProLicStr+"&"+comLicStr+"&"+businessRegNoStr+"&"+orgCodeStr
			+"&"+taxLicStr+"&"+insBusLicStr+"&"+prodEprsHygLicStr+"&"+socialCreditCodeStr;
		var mask = ShowLoadMask(win.body, "���������Ժ�...");
		Ext.Ajax.request({
			url: PhManfGridUrl + '?actiontype=insert',
			params: {
				data: Basicdata,
				QualityData :QualityData
			},
			method: 'post',
			waitMsg: '�½���...',
			failure: function (result, request) {
				mask.hide();
				Msg.info("error", "������������!");
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					var newRowid = jsonData.info;
					Msg.info("success", "����ɹ�!");
					win.close();
					findPhManf.handler();
				} else {
					if (jsonData.info == -1) {
						Msg.info("error", "�����ظ�!");
					} else if (jsonData.info == -11) {
						Msg.info("error", "�����ظ�!");
					} else {
						Msg.info("error", "����ʧ��!");
					}
				}
			},
			scope: this
		});
	};

	//�޸�
	var editHandler = function () {
		/*
		���̻�����Ϣ
		*/
		var code = codeField.getValue();
		var name = nameField.getValue();
		var address = addressField.getValue();
		var phone = phoneField.getValue();
		var lastPhManfId = lastPhManfField.getValue();
		var active = (activeField.getValue() == true) ? 'Y' : 'N';
		
		/*������Ϣ
			�ϸ�������˳��
			ÿ��������ɴ�˳����������^������Ч��^���ʷ�֤����^���ʷ�֤����^Ч�ڳ��ڱ�־^���ڱ�־^��������
		*/
		// ҩƷ�������֤
		var drugProPermitText = Ext.getCmp('drugProPermitText').getValue();
		var drugProPermitDateTo = Ext.getCmp('drugProPermitDateTo').getValue();
		if ((drugProPermitDateTo != "") && (drugProPermitDateTo != null)) {
			drugProPermitDateTo = drugProPermitDateTo.format(ARG_DATEFORMAT);
		}
		var drugProPermitType="drugProPermit";
		var drugProPermitStr=drugProPermitType+"^"+drugProPermitText+"^"+drugProPermitDateTo;
		
		// ��е�������֤
		var insProLicText = Ext.getCmp('insProLicText').getValue();
		var insProLicDateTo = Ext.getCmp('insProLicDateTo').getValue();
		if ((insProLicDateTo != "") && (insProLicDateTo != null)) {
			insProLicDateTo = insProLicDateTo.format(ARG_DATEFORMAT);
		}
		var insProLicType="insProLic";
		var insProLicStr=insProLicType+"^"+insProLicText+"^"+insProLicDateTo;
		
		// ����ִ��
		var comLicText = Ext.getCmp('comLicText').getValue();
		var comLicDateTo = Ext.getCmp('comLicDateTo').getValue();
		if ((comLicDateTo != "") && (comLicDateTo != null)) {
			comLicDateTo = comLicDateTo.format(ARG_DATEFORMAT);
		}
		var comLicType="comLic";
		var comLicStr=comLicType+"^"+comLicText+"^"+comLicDateTo;
		
		// ����ע���
		var businessRegNoText = Ext.getCmp('businessRegNoText').getValue();
		var businessRegNoDateTo = Ext.getCmp('businessRegNoDateTo').getValue();
		if ((businessRegNoDateTo != "") && (businessRegNoDateTo != null)) {
			businessRegNoDateTo = businessRegNoDateTo.format(ARG_DATEFORMAT);
		}
		var businessRegNoType="businessRegNo";
		var businessRegNoStr=businessRegNoType+"^"+businessRegNoText+"^"+businessRegNoDateTo;
		
		// ��������
		var orgCodeText = Ext.getCmp('orgCodeText').getValue();
		var orgCodeDateTo = Ext.getCmp('orgCodeDateTo').getValue();
		if ((orgCodeDateTo != "") && (orgCodeDateTo != null)) {
			orgCodeDateTo = orgCodeDateTo.format(ARG_DATEFORMAT);
		}
		var orgCodeType="orgCode";
		var orgCodeStr=orgCodeType+"^"+orgCodeText+"^"+orgCodeDateTo;
		
		// ˰��Ǽ�֤
		var taxLicText = Ext.getCmp('taxLicText').getValue();
		var taxLicType="taxLic";
		var taxLicStr=taxLicType+"^"+taxLicText;		
		
		// ��е��Ӫ���֤
		var insBusLicText = Ext.getCmp('insBusLicText').getValue();
		var insBusLicDateTo = Ext.getCmp('insBusLicDateTo').getValue();
		if ((insBusLicDateTo != "") && (insBusLicDateTo != null)) {
			insBusLicDateTo = insBusLicDateTo.format(ARG_DATEFORMAT);
		}
		var insBusLicType="insBusLic";
		var insBusLicStr=insBusLicType+"^"+insBusLicText+"^"+insBusLicDateTo;
		
		//������ҵ�������֤
		var prodEprsHygLicText = Ext.getCmp('prodEprsHygLicText').getValue();
		var prodEprsHygLicDateTo = Ext.getCmp('prodEprsHygLicDateTo').getValue();
		if ((prodEprsHygLicDateTo != "") && (prodEprsHygLicDateTo != null)) {
			prodEprsHygLicDateTo = prodEprsHygLicDateTo.format(ARG_DATEFORMAT);
		}
		var prodEprsHygLicType="prodEprsHygLic";
		var prodEprsHygLicStr=prodEprsHygLicType+"^"+prodEprsHygLicText+"^"+prodEprsHygLicDateTo;
		
		// ���������
		var socialCreditCodeText = Ext.getCmp('socialCreditCodeText').getValue();
		var socialCreditCodeDateTo = Ext.getCmp('socialCreditCodeDateTo').getValue();
		if ((socialCreditCodeDateTo != "") && (socialCreditCodeDateTo != null)) {
			socialCreditCodeDateTo = socialCreditCodeDateTo.format(ARG_DATEFORMAT);
		}
		var socialCreditCodeType="socialCreditCode";
		var socialCreditCodeStr=socialCreditCodeType+"^"+socialCreditCodeText+"^"+socialCreditCodeDateTo;
		
		
		if (code.trim() == "") {
			Ext.Msg.show({
				title: '��ʾ',
				msg: '���̴���Ϊ��',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.INFO
			});
			return;
		}

		if (name.trim() == "") {
			Ext.Msg.show({
				title: '��ʾ',
				msg: '��������Ϊ��',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.INFO
			});
			return;
		}
		//ƴdata�ַ���
		var Basicdata = rowid + "^" + code + "^" + name + "^" + address + "^" + phone + "^" + lastPhManfId+ "^" + active;
		var QualityData = drugProPermitStr+"&"+insProLicStr+"&"+comLicStr+"&"+businessRegNoStr+"&"+orgCodeStr
			+"&"+taxLicStr+"&"+insBusLicStr+"&"+prodEprsHygLicStr+"&"+socialCreditCodeStr;
		var mask = ShowLoadMask(win.body, "���������Ժ�...");
		Ext.Ajax.request({
			url: PhManfGridUrl + '?actiontype=update',
			params: {
				data: Basicdata,
				QualityData:QualityData
			},
			waitMsg: '������...',
			failure: function (result, request) {
				mask.hide();
				Msg.info("error", "������������!");
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Msg.info("success", "���³ɹ�!");
					win.close();
					PhManfGridDs.reload();
				} else {
					if (jsonData.info == -1) {
						Msg.info("error", "�����ظ�!");
					}
					if (jsonData.info == -11) {
						Msg.info("error", "�����ظ�!");
					} else {
						Msg.info('error', '����ʧ��:' + jsonData.info);
					}
				}
			},
			scope: this
		});
	};

	function Select(rowid) {
		Ext.Ajax.request({
			url: PhManfGridUrl + '?actiontype=queryByRowId&rowid=' + rowid,
			failure: function (result, request) {
				Msg.info("error", "������������!");
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					//��ѯ�ɹ�,��ֵ���ؼ�
					var value = jsonData.info;
					var AllArr=value.split("&");
					var arr = AllArr[0].split("^");
					var QualityStr = AllArr[1];
					
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					Ext.getCmp('addressField').setValue(arr[2]);
					Ext.getCmp('phoneField').setValue(arr[3]);
					addComboData(lastPhManfField.getStore(), arr[5], arr[6]);
					Ext.getCmp('lastPhManfField').setValue(arr[5]);
					Ext.getCmp('activeField').setValue((arr[7] == "Y") ? true : false);
					
					var QualityArr=QualityStr.split("#");
					var QualityArrLen=QualityArr.length;
					for (var i=0;i<QualityArrLen;i++)
					{
						var tmpQualityStr = QualityArr[i];
						var tmpQualityArr = tmpQualityStr.split("^");
						var CertType = tmpQualityArr[0];
						var CertText = tmpQualityArr[1];
						var CertIssuedDept = tmpQualityArr[2];
						var CertIssuedDate = tmpQualityArr[3];
						var CertDateTo = tmpQualityArr[4];
						var CertBlankedFlag = tmpQualityArr[5];
						var CertDelayFlag = tmpQualityArr[6];
						var CertDelayDateTo = tmpQualityArr[7];
						if (Ext.isEmpty(Ext.getCmp(CertType+'Text'))){continue;}
						Ext.getCmp(CertType+'Text').setValue(CertText);
						if (Ext.isEmpty(Ext.getCmp(CertType+'DateTo'))){continue;}
						Ext.getCmp(CertType+'DateTo').setValue(CertDateTo);
						if (Ext.isEmpty(Ext.getCmp(CertType+'IssuedDept'))){continue;}
						Ext.getCmp(CertType+'IssuedDept').setValue(CertIssuedDept);
						if (Ext.isEmpty(Ext.getCmp(CertType+'IssuedDate'))){continue;}
						Ext.getCmp(CertType+'IssuedDate').setValue(CertIssuedDate);
						if (Ext.isEmpty(Ext.getCmp(CertType+'BlankedFlag'))){continue;}
						Ext.getCmp(CertType+'BlankedFlag').setValue(CertBlankedFlag);
						if (Ext.isEmpty(Ext.getCmp(CertType+'DelayFlag'))){continue;}
						Ext.getCmp(CertType+'DelayFlag').setValue(CertDelayFlag);
						if (Ext.isEmpty(Ext.getCmp(CertType+'DelayDateTo'))){continue;}
						Ext.getCmp(CertType+'DelayDateTo').setValue(CertDelayDateTo);
					}
					
				} else {
					Msg.info("error", "��ѯʧ��!" + newRowid);
				}
			},
			scope: this
		});
	}

	function take_pic(typeCode, typeDesc) {
		if (rowid == "") {
			Msg.info("warning", "���ȱ��泧����Ϣ,������!");
			return;
		}
		var AppName = 'DHCSTPHMANFM';
		if ((!ManfTakePicWindow) || (ManfTakePicWindow.closed)) {
			var lnk = 'dhcstm.takepiccommon.csp';
			lnk = lnk + "?AppName=" + AppName;
			lnk = lnk + "&RowId=" + rowid;
			lnk = lnk + "&typeCode=" + typeCode;
			lnk = lnk + "&typeDesc=" + typeDesc;
			lnk = lnk + "&GroupId=" + session['LOGON.GROUPID'];
			lnk = lnk + "&LocId=" + session['LOGON.CTLOCID'];
			lnk = lnk + "&UserId=" + session['LOGON.USERID'];
			ManfTakePicWindow = window.open(lnk, "take_photo_manf", "height=600,width=800,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=yes");
		} else {
			ManfTakePicWindow.setType(AppName, rowid, typeCode, typeDesc, session['LOGON.GROUPID'], session['LOGON.CTLOCID'], session['LOGON.USERID']);
			ManfTakePicWindow.focus();
		}
	}

}

var addPhManf = new Ext.Toolbar.Button({
		text: '�½�',
		tooltip: '�½�',
		iconCls: 'page_add',
		width: 70,
		height: 30,
		handler: function () {
			//������ʾ
			CreateEditWin("");
		}
	});

var editPhManf = new Ext.Toolbar.Button({
		text: '�༭',
		tooltip: '�༭',
		id: 'EditManfBt',
		iconCls: 'page_edit',
		width: 70,
		height: 30,
		handler: function () {
			var rowObj = PhManfGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len < 1) {
				Msg.info("error", "��ѡ������!");
				return false;
			} else {
				CreateEditWin(rowObj[0].get("RowId"));
			}
		}
	});

var editPicPhManf = new Ext.Toolbar.Button({
		text: '����ͼƬ',
		tooltip: '�鿴����ͼƬ',
		id: 'EditManfPicBt',
		iconCls: 'page_gear',
		width: 70,
		height: 30,
		handler: function () {
			var rowObj = PhManfGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len < 1) {
				Msg.info("error", "��ѡ������!");
				return false;
			} else {
				var manf = rowObj[0].get("RowId");
				ShowManfPicWindow(manf);
			}
		}
	});

var formPanel = new Ext.ux.FormPanel({
		title: '����ά��',
		tbar: [findPhManf, '-', addPhManf, '-', editPhManf, '-', editPicPhManf],
		items: [{
				xtype: 'fieldset',
				title: '��ѯ����',
				layout: 'column',
				style: 'padding:5px 0px 0px 5px',
				defaults: {
					border: false,
					columnWidth: .33,
					xtype: 'fieldset'
				},
				items: [{
						items: [conditionCodeField]
					}, {
						items: [conditionNameField]
					}, {
						items: [conditionactiveField]
					}
				]
			}
		]
	});

//��ҳ������
var PhManfPagingToolbar = new Ext.PagingToolbar({
		store: PhManfGridDs,
		pageSize: 30,
		displayInfo: true
	});

//���
PhManfGrid = new Ext.ux.EditorGridPanel({
                id :'PhManfGrid',
		store: PhManfGridDs,
		title: '������ϸ',
		cm: PhManfGridCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: false
		}),
		loadMask: true,
		bbar: PhManfPagingToolbar,
		listeners: {
			'rowdblclick': function () {
				Ext.getCmp('EditManfBt').handler();
			}
		}
	});

Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [formPanel, PhManfGrid],
			renderTo: 'mainPanel'
		});
	findPhManf.handler();
});
