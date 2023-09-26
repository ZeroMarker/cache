// ����:��Ӧ��ά��
// ��д����:2012-05-14

//=========================��Ӧ�����=============================
var currVendorRowId = '';
var win;
var conditionCodeField = new Ext.form.TextField({
		id: 'conditionCodeField',
		fieldLabel: '��Ӧ�̴���',
		allowBlank: true,
		listWidth: 180,
		anchor: '90%',
		selectOnFocus: true,
		listeners: {
			'specialkey': function (t, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					findAPCVendor.handler();
				}
			}
		}
	});

var conditionNameField = new Ext.form.TextField({
		id: 'conditionNameField',
		fieldLabel: '��Ӧ������',
		allowBlank: true,
		listWidth: 150,
		anchor: '90%',
		selectOnFocus: true,
		listeners: {
			'specialkey': function (t, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					findAPCVendor.handler();
				}
			}
		}
	});

var conditionStateStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [["A", 'ʹ��'], ["S", 'ͣ��'], ["", 'ȫ��']]
	});

var conditionStateField = new Ext.form.ComboBox({
		id: 'conditionStateField',
		fieldLabel: 'ʹ��״̬',
		anchor: '90%',
		listWidth: 230,
		allowBlank: true,
		store: conditionStateStore,
		value: '', // Ĭ��ֵ"ȫ����ѯ"
		valueField: 'key',
		displayField: 'keyValue',
		triggerAction: 'all',
		emptyText: '',
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true,
		editable: true,
		mode: 'local'
	});

var includeRcVendor = new Ext.form.Checkbox({
		id: 'includeRc',
		boxLabel: '�м���',
		anchor: '97%'
	});
//����
var conditioncategoryField = new Ext.ux.ComboBox({
		id: 'conditioncategoryField',
		fieldLabel: '����',
		anchor: '90%',
		allowBlank: true,
		store: GetVendorCatStore,
		valueField: 'RowId',
		displayField: 'Description',
		triggerAction: 'all',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: true,
		editable: true
	});

//��������Դ
var APCVendorGridUrl = 'dhcstm.apcvendoraction.csp';
var APCVendorGridProxy = new Ext.data.HttpProxy({
		url: APCVendorGridUrl + '?actiontype=query',
		method: 'POST'
	});
var APCVendorGridDs = new Ext.data.Store({
		proxy: APCVendorGridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results',
			pageSize: 35
		}, [{
					name: 'RowId'
				}, {
					name: 'Code'
				}, {
					name: 'Name'
				}, {
					name: 'Tel'
				}, {
					name: 'Category'
				}, {
					name: 'CategoryId'
				}, {
					name: 'CtrlAcct'
				}, {
					name: 'CrAvail'
				}, {
					name: 'LstPoDate'
				}, {
					name: 'Fax'
				}, {
					name: 'President'
				}, {
					name: 'PresidentId'
				}, {
					name: 'PresidentTel'
				}, {
					name: 'Status'
				}, {
					name: 'rcFlag'
				}, {
					name: 'LstBsDate'
				},'AccountPeriod'
			]),
		remoteSort: false
	});

//ģ��
var sm=new Ext.grid.CheckboxSelectionModel({});
var APCVendorGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),sm, {
				header: "����",
				dataIndex: 'Code',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'Name',
				width: 300,
				align: 'left',
				sortable: true
			}, {
				header: "�绰",
				dataIndex: 'Tel',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "����",
				dataIndex: 'Category',
				width: 100,
				align: 'left',
				sortable: false
			}, {
				header: "�˻�",
				dataIndex: 'CtrlAcct',
				width: 200,
				align: 'left',
				sortable: false
			}, {
				header: "ע���ʽ�",
				dataIndex: 'CrAvail',
				width: 150,
				align: 'left',
				sortable: false
			}, {
				header: "��ͬ����",
				dataIndex: 'LstPoDate',
				width: 150,
				align: 'left',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'Fax',
				width: 200,
				align: 'left',
				sortable: false
			}, {
				header: "����",
				dataIndex: 'President',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "�������֤",
				dataIndex: 'PresidentId',
				width: 130,
				align: 'left',
				sortable: true
			}, {
				header: "������ϵ�绰",
				dataIndex: 'PresidentTel',
				width: 150,
				align: 'left',
				sortable: true
			}, {
				header: "ʹ�ñ�־",
				dataIndex: 'Status',
				width: 80,
				align: 'left',
				sortable: false,
				renderer: function (v, p, record) {
					if (v == "A")
						return "ʹ��";
					if (v == "S")
						return "ͣ��";
				}
			}, {
				header: "�м���",
				dataIndex: 'rcFlag',
				width: 80,
				align: 'center',
				sortable: true,
				renderer: function (v, p, record) {
					if (v == "Y") {
						return "��";
					} else {
						return "";
					}
				}
			}, {
				header: "���ҵ������",
				dataIndex: 'LstBsDate',
				width: 150,
				align: 'left',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'AccountPeriod',
				width: 100,
				align: 'left',
				sortable: false
			}
		]);

//��ʼ��Ĭ��������
APCVendorGridCm.defaultSortable = true;

var findAPCVendor = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			Query();
		}
	});

var addAPCVendor = new Ext.Toolbar.Button({
		text: '�½�',
		tooltip: '�½�',
		iconCls: 'page_add',
		width: 70,
		height: 30,
		handler: function () {
			currVendorRowId = "";
			CreateEditWin();
		}
	});

var findNotAuditpicAPCVendor = new Ext.Toolbar.Button({
		text: '����ͼƬ',
		tooltip: '�鿴����ͼƬ',
		iconCls: 'page_edit',
		width: 70,
		height: 30,
		handler: function () {
			var rowObj = APCVendorGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len < 1) {
				Msg.info("warning", "��ѡ��Ӧ��!");
				return false;
			} else {
				currVendorRowId = rowObj[0].get('RowId');
				var PicUrl = 'dhcstm.apcvendoraction.csp?actiontype=GetNotAuditPic';
				// ͨ��AJAX��ʽ���ú�̨����
				var proxy = new Ext.data.HttpProxy({
						url: PicUrl,
						method: "POST"
					});
				// ָ���в���
				var fields = ["rowid", "venid", "vendesc", "picsrc", "type"];
				// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
				var reader = new Ext.data.JsonReader({
						root: 'rows',
						totalProperty: "results",
						id: "rowid",
						fields: fields
					});
				// ���ݼ�
				var PicStore = new Ext.data.Store({
						proxy: proxy,
						reader: reader
					});

				ShowNotAuditPicWindow(PicStore, currVendorRowId)

			}
		}
	});

// ������ť
var ExportAllToExcelBT = new Ext.Toolbar.Button({
		text: '�������',
		tooltip: '�������',
		width: 70,
		height: 30,
		iconCls: 'page_refresh',
		handler: function () {
			ExportAllToExcel(APCVendorGrid);
		}
	});

var editAPCVendor = new Ext.Toolbar.Button({
		text: '�༭',
		tooltip: '�༭',
		iconCls: 'page_edit',
		width: 70,
		height: 30,
		handler: function () {
			var rowObj = APCVendorGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len < 1) {
				Msg.info("warning", "��ѡ��Ӧ��!");
				return false;
			} else {
				var rowid = rowObj[0].get('RowId');
				currVendorRowId = rowid;
				CreateEditWin();
				//������ʾ
			}
		}
	});
var SendVendorBT = new Ext.Toolbar.Button({
			id : "SendVendorBT",
			text : '���͹�Ӧ����Ϣ��ƽ̨',
			width : 70,
			height : 30,
			iconCls : 'page_gear',
			handler : function() {
				    var rowDataArr=APCVendorGrid.getSelectionModel().getSelections();
					if (Ext.isEmpty(rowDataArr)) {
						Msg.info("warning", "��ѡ����Ҫ���͵Ĺ�Ӧ����Ϣ!");
						return;
					}
					var VendorStr="";
					for (var i=0;i<rowDataArr.length;i++){
						var rowData=rowDataArr[i];
						var VenRowId = rowData.get("RowId");
						if (VendorStr==""){
							VendorStr=VenRowId;
						}else{
							VendorStr=VendorStr+"^"+VenRowId;
						}
					}
					if (Ext.isEmpty(VendorStr)) {
						Msg.info("warning", "��ѡ����Ҫ���͵Ĺ�Ӧ����Ϣ!");
						return;
					}
					SendVendor(VendorStr);
			}
});
function SendVendor(VendorStr){
	 var url = APCVendorGridUrl+"?actiontype=SendVendor";
        var loadMask=ShowLoadMask(Ext.getBody(),"������Ϣ��...");
        Ext.Ajax.request({
                    url : url,
                    method : 'POST',
                    params:{VendorStr:VendorStr},
                    waitMsg : '������...',
                    success : function(result, request) {
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                            Msg.info("success", "���ͳɹ�!");
                            Query();
                        } else {
                            var ret=jsonData.info;
                            Msg.info("error", jsonData.info);
                            Query();
                        }
                    },
                    scope : this
                });
        loadMask.hide();
}
var formPanel = new Ext.ux.FormPanel({
		title: '��Ӧ��ά��',
		tbar: [findAPCVendor, '-', addAPCVendor, '-', editAPCVendor, '-', findNotAuditpicAPCVendor, '-', SendVendorBT],
		items: [{
				xtype: 'fieldset',
				title: '��ѯ����',
				layout: 'column',
				style: 'padding:5px 0px 0px 5px',
				defaults: {
					border: false,
					xtype: 'fieldset'
				},
				items: [{
						columnWidth: .2,
						items: [conditionCodeField]
					}, {
						columnWidth: .2,
						items: [conditionNameField]
					}, {
						columnWidth: .2,
						items: [conditionStateField]
					}, {
						columnWidth: .2,
						items: [conditioncategoryField]
					}, {
						columnWidth: .2,
						items: [includeRcVendor]
					}
				]
			}
		]

	});

//��ҳ������
var APCVendorPagingToolbar = new Ext.PagingToolbar({
		store: APCVendorGridDs,
		pageSize: PageSize,
		displayInfo: true,
		displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg: "û�м�¼"

	});

//���
APCVendorGrid = new Ext.ux.EditorGridPanel({
		id: 'APCVendorGrid',
		store: APCVendorGridDs,
		cm: APCVendorGridCm,
		title: '��Ӧ����ϸ',
		region: 'center',
		height: 690,
		sm: sm,
		loadMask: true,
		bbar: APCVendorPagingToolbar,
		listeners: {
			'rowdblclick': function () {
				editAPCVendor.handler();
			}
		}
	});
function Query(){
	var conditionCode = Ext.getCmp('conditionCodeField').getValue();
	var conditionName = Ext.getCmp('conditionNameField').getValue();
	var conditionState = Ext.getCmp('conditionStateField').getValue();
	var conditioncategoryField = Ext.getCmp('conditioncategoryField').getValue();
	var rcFlag = Ext.getCmp('includeRc').getValue(); //�Ƿ�����м������
	if (rcFlag == true) {
		rcFlag = "Y";
	} else {
		rcFlag = "N";
	}
	var others = rcFlag + "^" + conditioncategoryField; //�Ժ����ӵĲ�ѯ����������others��
	APCVendorGridDs.setBaseParam('conditionCode', conditionCode);
	APCVendorGridDs.setBaseParam('conditionName', conditionName);
	APCVendorGridDs.setBaseParam('conditionState', conditionState);
	APCVendorGridDs.setBaseParam('others', others);
	APCVendorGridDs.load({
		params: {
			start: 0,
			limit: APCVendorPagingToolbar.pageSize
		}
	});
}

//=========================��Ӧ�����=============================

//===========ģ����ҳ��===========================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [formPanel, APCVendorGrid],
			renderTo: 'mainPanel'
		});

	Query();
});

//===========ģ����ҳ��===========================================
