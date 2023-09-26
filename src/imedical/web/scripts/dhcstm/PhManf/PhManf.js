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
var PhManfGridUrl = 'dhcstm.phmanfaction.csp';
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
					name: 'SocialCreditCode'
				}, {
					name: 'SocialCreditExpDate'
				}, {
					name: 'DrugProductP'
				}, {
					name: 'DrugProductExp'
				}, {
					name: 'MatProductP'
				}, {
					name: 'MatProductExp'
				}, {
					name: 'ComLic'
				}, {
					name: 'ComLicDate'
				}, {
					name: 'Active'
				}, {
					name: 'BusinessRegNo'
				}, {
					name: 'BusinessRegExpDate'
				}, {
					name: 'OrgCode'
				}, {
					name: 'OrgCodeExpDate'
				}, {
					name: 'MatManLic'
				}, {
					name: 'MatManLicDate'
				}, {
					name: 'MANFProdEprsHygLic'
				}, {
					name: 'MANFProdEprsHygLicExpDate'
				}, {
					name: 'TaxRegNo'
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
				dataIndex: 'SocialCreditCode',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "���������Ч��",
				dataIndex: 'SocialCreditExpDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "ҩ���������",
				dataIndex: 'DrugProductP',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "ҩ�����������Ч��",
				dataIndex: 'DrugProductExp',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "��е�������",
				dataIndex: 'MatProductP',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "��е���������Ч��",
				dataIndex: 'MatProductExp',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "����ִ�����",
				dataIndex: 'ComLic',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "����ִ�������Ч��",
				dataIndex: 'ComLicDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "����ע���",
				dataIndex: 'BusinessRegNo',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "����ע��Ч��",
				dataIndex: 'BusinessRegExpDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "��֯��������",
				dataIndex: 'OrgCode',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "��֯��������Ч��",
				dataIndex: 'OrgCodeExpDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "˰��ǼǺ�",
				dataIndex: 'TaxRegNo',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "��е��Ӫ���֤",
				dataIndex: 'MatManLic',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "��е��Ӫ���֤Ч��",
				dataIndex: 'MatManLicDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "������ҵ�������֤",
				dataIndex: 'MANFProdEprsHygLic',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "������ҵ�������֤Ч��",
				dataIndex: 'MANFProdEprsHygLicExpDate',
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
						drugProductPermitField.focus();
					}
				}
			}
		});

	//ҩ���������
	var drugProductPermitField = new Ext.form.TextField({
			id: 'drugProductPermitField',
			fieldLabel: 'ҩ���������',
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('drugProductPermitField').getValue() == "") {
							Handler = function () {
								drugProductPermitField.focus();
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
							drugProductExpDate.focus();
						}
					}
				}
			}
		});

	//ҩ�����������Ч��
	var drugProductExpDate = new Ext.ux.DateField({
			id: 'drugProductExpDate',
			fieldLabel: '��Ч��',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('drugProductExpDate').getValue() == "") {
							Handler = function () {
								drugProductExpDate.focus();
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
							matProductPermitField.focus();
						}
					}
				}
			}
		});

	//��е�������
	var matProductPermitField = new Ext.form.TextField({
			id: 'matProductPermitField',
			fieldLabel: '��е�������',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('matProductPermitField').getValue() == "") {
							Handler = function () {
								matProductPermitField.focus();
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
							matProductExpDate.focus();
						}
					}
				}
			}
		});

	//��е���������Ч��
	var matProductExpDate = new Ext.ux.DateField({
			id: 'matProductExpDate',
			fieldLabel: '��Ч��',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('matProductExpDate').getValue() == "") {
							Handler = function () {
								matProductExpDate.focus();
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
							comLicField.focus();
						}
					}
				}
			}
		});

	//����ִ�����
	var comLicField = new Ext.form.TextField({
			id: 'comLicField',
			fieldLabel: '����ִ�����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('comLicField').getValue() == "") {
							Handler = function () {
								comLicField.focus();
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
							comLicExpDate.focus();
						}
					}
				}
			}
		});

	//����ִ�������Ч��
	var comLicExpDate = new Ext.ux.DateField({
			id: 'comLicExpDate',
			fieldLabel: '��Ч��',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('comLicExpDate').getValue() == "") {
							Handler = function () {
								comLicExpDate.focus();
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
							BusinessRegNoField.focus();

						}
					}
				}
			}
		});
	//����ע���
	var BusinessRegNoField = new Ext.form.TextField({
			id: 'BusinessRegNoField',
			fieldLabel: '����ע���',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('BusinessRegNoField').getValue() == "") {
							Handler = function () {
								BusinessRegNoField.focus();
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
							BusinessRegExpDate.focus();
						}
					}
				}
			}
		});

	//����ע��Ч��
	var BusinessRegExpDate = new Ext.ux.DateField({
			id: 'BusinessRegExpDate',
			fieldLabel: '��Ч��',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('BusinessRegExpDate').getValue() == "") {
							Handler = function () {
								BusinessRegExpDate.focus();
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
							OrgCodeField.focus();
						}
					}
				}
			}
		});
	//��֯��������
	var OrgCodeField = new Ext.form.TextField({
			id: 'OrgCodeField',
			fieldLabel: '��֯��������',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('OrgCodeField').getValue() == "") {
							Handler = function () {
								OrgCodeField.focus();
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
							OrgCodeExpDate.focus();
						}
					}
				}
			}
		});

	//��֯��������Ч��
	var OrgCodeExpDate = new Ext.ux.DateField({
			id: 'OrgCodeExpDate',
			fieldLabel: '��Ч��',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('BusinessRegExpDate').getValue() == "") {
							Handler = function () {
								OrgCodeExpDate.focus();
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
							TaxRegNoField.focus();
						}
					}
				}
			}
		});
	//˰��ǼǺ�
	var TaxRegNoField = new Ext.form.TextField({
			id: 'TaxRegNoField',
			fieldLabel: '˰��ǼǺ�',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('TaxRegNoField').getValue() == "") {
							Handler = function () {
								TaxRegNoField.focus();
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
							MatManLicField.focus();
						}
					}
				}
			}
		});
	//ҽ����е��Ӫ���֤
	var MatManLicField = new Ext.form.TextField({
			id: 'MatManLicField',
			fieldLabel: '��е��Ӫ���',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('MatManLicField').getValue() == "") {
							Handler = function () {
								MatManLicField.focus();
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
							MatManLicDate.focus();
						}
					}
				}
			}
		});

	//ҽ����е��Ӫ���֤Ч��
	var MatManLicDate = new Ext.ux.DateField({
			id: 'MatManLicDate',
			fieldLabel: '��Ч��',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('MatManLicDate').getValue() == "") {
							Handler = function () {
								MatManLicDate.focus();
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
							MANFProdEprsHygLic.focus();
						}
					}
				}
			}
		});
	//ҽ����е��Ӫ���֤
	var MANFProdEprsHygLic = new Ext.form.TextField({
			id: 'MANFProdEprsHygLic',
			fieldLabel: '������ҵ�������',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('MANFProdEprsHygLic').getValue() == "") {
							Handler = function () {
								MANFProdEprsHygLic.focus();
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
							MANFProdEprsHygLicExpDate.focus();
						}
					}
				}
			}
		});

	//ҽ����е��Ӫ���֤Ч��
	var MANFProdEprsHygLicExpDate = new Ext.ux.DateField({
			id: 'MANFProdEprsHygLicExpDate',
			fieldLabel: '��Ч��',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('MANFProdEprsHygLicExpDate').getValue() == "") {
							Handler = function () {
								MANFProdEprsHygLicExpDate.focus();
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

	var SocialCreditCode = new Ext.form.TextField({
			id: 'SocialCreditCode',
			fieldLabel: '���������',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//���������Ч��
	var SocialCreditExpDate = new Ext.ux.DateField({
			id: 'SocialCreditExpDate',
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
									items: [SocialCreditCode, SocialCreditExpDate, uploadButtonSocialCreditCode, uploadButtonSocialCreditCodeTP]
								}, {
									xtype: 'compositefield',
									items: [drugProductPermitField, drugProductExpDate, uploadButtonDrugProLic, uploadButtonDrugProLicTP]
								}, {
									xtype: 'compositefield',
									items: [matProductPermitField, matProductExpDate, uploadButtonInsProLic, uploadButtonInsProLicTP]
								}, {
									xtype: 'compositefield',
									items: [comLicField, comLicExpDate, uploadButtonComLic, uploadButtonComLicTP]
								}, {
									xtype: 'compositefield',
									items: [OrgCodeField, OrgCodeExpDate, uploadButtonOrgCode, uploadButtonOrgCodeTP]
								}, {
									xtype: 'compositefield',
									items: [MatManLicField, MatManLicDate, uploadButtonInsBusLic, uploadButtonInsBusLicTP]
								}, {
									xtype: 'compositefield',
									items: [MANFProdEprsHygLic, MANFProdEprsHygLicExpDate, uploadButtonMANFProdEprsHygLic, uploadButtonMANFProdEprsHygLicTP]
								}, {
									xtype: 'compositefield',
									items: [BusinessRegNoField, BusinessRegExpDate]
								}, {
									xtype: 'compositefield',
									items: [TaxRegNoField, uploadButtonTaxLic, uploadButtonTaxLicTP]
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
		var code = codeField.getValue();
		var name = nameField.getValue();
		var address = addressField.getValue();
		var phone = phoneField.getValue();
		var lastPhManfId = lastPhManfField.getValue();
		var drugProductPermit = drugProductPermitField.getValue();
		var drugProductExpDate = Ext.getCmp('drugProductExpDate').getValue();
		if (drugProductExpDate != '') {
			drugProductExpDate = drugProductExpDate.format(ARG_DATEFORMAT);
		}
		var matProductPermit = matProductPermitField.getValue();
		var matProductExpDate = Ext.getCmp('matProductExpDate').getValue();
		if (matProductExpDate != '') {
			matProductExpDate = matProductExpDate.format(ARG_DATEFORMAT);
		}
		var comLic = comLicField.getValue();
		var comLicExpDate = Ext.getCmp('comLicExpDate').getValue();
		if (comLicExpDate != '') {
			comLicExpDate = comLicExpDate.format(ARG_DATEFORMAT);
		}
		var BusinessRegNo = BusinessRegNoField.getValue();
		var BusinessRegExpDate = Ext.getCmp('BusinessRegExpDate').getValue();
		if (BusinessRegExpDate != '') {
			BusinessRegExpDate = BusinessRegExpDate.format(ARG_DATEFORMAT);
		}
		var OrgCode = OrgCodeField.getValue();
		var OrgCodeExpDate = Ext.getCmp('OrgCodeExpDate').getValue();
		if (OrgCodeExpDate != '') {
			OrgCodeExpDate = OrgCodeExpDate.format(ARG_DATEFORMAT);
		}
		var TaxRegNo = TaxRegNoField.getValue();
		var MatManLic = MatManLicField.getValue();
		var MatManLicDate = Ext.getCmp('MatManLicDate').getValue();
		if (MatManLicDate != '') {
			MatManLicDate = MatManLicDate.format(ARG_DATEFORMAT);
		}
		var MANFProdEprsHyg = MANFProdEprsHygLic.getValue();
		var MANFProdEprsHygLicExpDate = Ext.getCmp('MANFProdEprsHygLicExpDate').getValue();
		if (MANFProdEprsHygLicExpDate != '') {
			MANFProdEprsHygLicExpDate = MANFProdEprsHygLicExpDate.format(ARG_DATEFORMAT);
		}
		var active = (activeField.getValue() == true) ? 'Y' : 'N';
		var SocialCreditCode = Ext.getCmp('SocialCreditCode').getValue();
		var SocialCreditExpDate = Ext.getCmp('SocialCreditExpDate').getValue();
		if (SocialCreditExpDate != '') {
			SocialCreditExpDate = SocialCreditExpDate.format(ARG_DATEFORMAT);
		}
		if (code.trim() == "") {}

		if (name.trim() == "") {
			Msg.info('warning', "�������Ʋ���Ϊ��");
			return;
		}

		//ƴdata�ַ���
		var data = code + "^" + name + "^" + address + "^" + phone + "^" + lastPhManfId
			 + "^" + drugProductPermit + "^" + drugProductExpDate + "^" + matProductPermit + "^" + matProductExpDate + "^" + comLic
			 + "^" + comLicExpDate + "^" + active + "^" + BusinessRegNo + "^" + BusinessRegExpDate + "^" + OrgCode
			 + "^" + OrgCodeExpDate + "^" + TaxRegNo + "^" + MatManLic + "^" + MatManLicDate + "^" + MANFProdEprsHyg
			 + "^" + MANFProdEprsHygLicExpDate + "^" + SocialCreditCode + "^" + SocialCreditExpDate;
		var mask = ShowLoadMask(win.body, "���������Ժ�...");
		Ext.Ajax.request({
			url: PhManfGridUrl + '?actiontype=insert',
			params: {
				data: data
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

		var code = codeField.getValue();
		var name = nameField.getValue();
		var address = addressField.getValue();
		var phone = phoneField.getValue();
		var lastPhManfId = lastPhManfField.getValue();
		var drugProductPermit = drugProductPermitField.getValue();
		var drugProductExpDate = Ext.getCmp('drugProductExpDate').getValue();
		if (drugProductExpDate != '') {
			drugProductExpDate = drugProductExpDate.format(ARG_DATEFORMAT);
		}

		var matProductPermit = matProductPermitField.getValue();
		var matProductExpDate = Ext.getCmp('matProductExpDate').getValue();
		if (matProductExpDate != '') {
			matProductExpDate = matProductExpDate.format(ARG_DATEFORMAT);
		}
		var comLic = comLicField.getValue();
		var comLicExpDate = Ext.getCmp('comLicExpDate').getValue();
		if (comLicExpDate != '') {
			comLicExpDate = comLicExpDate.format(ARG_DATEFORMAT);
		}
		var BusinessRegNo = BusinessRegNoField.getValue();
		var BusinessRegExpDate = Ext.getCmp('BusinessRegExpDate').getValue();
		if (BusinessRegExpDate != '') {
			BusinessRegExpDate = BusinessRegExpDate.format(ARG_DATEFORMAT);
		}
		var OrgCode = OrgCodeField.getValue();
		var OrgCodeExpDate = Ext.getCmp('OrgCodeExpDate').getValue();
		if (OrgCodeExpDate != '') {
			OrgCodeExpDate = OrgCodeExpDate.format(ARG_DATEFORMAT);
		}
		var TaxRegNo = TaxRegNoField.getValue();
		var MatManLic = MatManLicField.getValue();
		var MatManLicDate = Ext.getCmp('MatManLicDate').getValue();
		if (MatManLicDate != '') {
			MatManLicDate = MatManLicDate.format(ARG_DATEFORMAT);
		}
		var MANFProdEprsHyg = MANFProdEprsHygLic.getValue();
		var MANFProdEprsHygLicExpDate = Ext.getCmp('MANFProdEprsHygLicExpDate').getValue();
		if (MANFProdEprsHygLicExpDate != '') {
			MANFProdEprsHygLicExpDate = MANFProdEprsHygLicExpDate.format(ARG_DATEFORMAT);
		}
		var active = (activeField.getValue() == true) ? 'Y' : 'N';
		var SocialCreditCode = Ext.getCmp('SocialCreditCode').getValue();
		var SocialCreditExpDate = Ext.getCmp('SocialCreditExpDate').getValue();
		if (SocialCreditExpDate != '') {
			SocialCreditExpDate = SocialCreditExpDate.format(ARG_DATEFORMAT);
		}
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
		var data = rowid + "^" + code + "^" + name + "^" + address + "^" + phone
			 + "^" + lastPhManfId + "^" + drugProductPermit + "^" + drugProductExpDate + "^" + matProductPermit + "^" + matProductExpDate
			 + "^" + comLic + "^" + comLicExpDate + "^" + active + "^" + BusinessRegNo + "^" + BusinessRegExpDate
			 + "^" + OrgCode + "^" + OrgCodeExpDate + "^" + TaxRegNo + "^" + MatManLic + "^" + MatManLicDate
			 + "^" + MANFProdEprsHyg + "^" + MANFProdEprsHygLicExpDate + "^" + SocialCreditCode + "^" + SocialCreditExpDate;

		var mask = ShowLoadMask(win.body, "���������Ժ�...");
		Ext.Ajax.request({
			url: PhManfGridUrl + '?actiontype=update',
			params: {
				data: data
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
					var arr = value.split("^");
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					Ext.getCmp('addressField').setValue(arr[2]);
					Ext.getCmp('phoneField').setValue(arr[3]);
					addComboData(lastPhManfField.getStore(), arr[5], arr[6]);
					Ext.getCmp('lastPhManfField').setValue(arr[5]);
					Ext.getCmp('drugProductPermitField').setValue(arr[7]);
					Ext.getCmp('drugProductExpDate').setValue(arr[8]);
					Ext.getCmp('matProductPermitField').setValue(arr[9]);
					Ext.getCmp('matProductExpDate').setValue(arr[10]);
					Ext.getCmp('comLicField').setValue(arr[11]);
					Ext.getCmp('comLicExpDate').setValue(arr[12]);
					Ext.getCmp('activeField').setValue((arr[13] == "Y") ? true : false);

					Ext.getCmp('BusinessRegNoField').setValue(arr[14]);
					Ext.getCmp('BusinessRegExpDate').setValue(arr[15]);
					Ext.getCmp('OrgCodeField').setValue(arr[16]);
					Ext.getCmp('OrgCodeExpDate').setValue(arr[17]);
					Ext.getCmp('TaxRegNoField').setValue(arr[18]);
					Ext.getCmp('MatManLicField').setValue(arr[19]);
					Ext.getCmp('MatManLicDate').setValue(arr[20]);
					Ext.getCmp('MANFProdEprsHygLic').setValue(arr[21]);
					Ext.getCmp('MANFProdEprsHygLicExpDate').setValue(arr[22]);
					Ext.getCmp('SocialCreditCode').setValue(arr[23]);
					Ext.getCmp('SocialCreditExpDate').setValue(arr[24]);
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
