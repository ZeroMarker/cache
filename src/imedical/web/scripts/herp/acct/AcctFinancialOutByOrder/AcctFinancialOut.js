/**
������  
cyw
 */

//��ȡ��Ļ�ֱ���
var screenHeight = Ext.getBody().getHeight();
//alert(screenHeight);
var gridHeight = screenHeight - 71 - 20
	//(2*gridHeight)/5,

	//���������жϲ�ѯ�����ʾ����
	//���ƾ֤�Ų����ڣ���ʾ�����Ĳ�ѯ��壬��������ڣ�����ʾ
var projUrl = "herp.acct.acctfinancialoutByOrderexe.csp";
var acctbookid = "";
var userid = "";
var vouchNO = "";
var Vno = document.getElementById("vouchNO").innerHTML;
if (document.getElementById("vouchNO").innerHTML != "") {
	acctbookid = document.getElementById("AcctBookID").innerHTML;
	userid = document.getElementById("userid").innerHTML;
	vouchNO = document.getElementById("vouchNO").innerHTML + "#" + acctbookid;
}

if (vouchNO == "") {
	acctbookid = IsExistAcctBook();
	userid = session['LOGON.USERID'];

}
//alert(vouchNO);
//����
var YearMonth = new Ext.form.DateField({
		id: 'YearMonth',
		fieldLabel: '����',
		name: 'YearMonth',
		format: 'Y-m-d',
		editable: true,
		//allowBlank : false,
		emptyText: '��ѡ������...',
		// value:new Date(),
		width: 120
	});

//ҵ�񵥺�

var OrderNO = new Ext.form.TextField({
		id: 'OrderNO',
		fieldLabel: 'ҵ�񵥺�',
		labelAlign: 'left',
		labelWidth: 40,
		width: 120,
		name: 'OrderNO',
		triggerAction: 'all',
		forceSelection: 'true',
		editable: true,
		selectOnFocus: true

	});
	
	
	//ҵ��ϵͳ
var SystemDS = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [['Drug', 'ҩƷ����ϵͳ'],['Dura', '���ʹ���ϵͳ'] /*['Equi', '�̶��ʲ�ϵͳ']*/]
	});

//����������  ����״̬
var System = new Ext.form.ComboBox({
		id: 'System',
		fieldLabel: '����״̬',
		width: 150,
		listWidth: 150,
		store: SystemDS,
		valueNotFoundText: '',
		displayField: 'keyValue',
		valueField: 'key',
		mode: 'local', // ����ģʽ
		triggerAction: 'all',
		value: 'Drug',
		selectOnFocus: true,
		forceSelection: true,
		editable: true
		//allowBlank:true
	});
	
///ҵ������
var SumlTypeDS= new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [['TK', '����'],['CS', '�˿�'],['ZY','ҩƷת��']]
	});

//����������  ����״̬
var SumlTypecol = new Ext.form.ComboBox({
		id: 'SumlTypecol',
		fieldLabel: '����״̬',
		width: 150,
		listWidth: 150,
		store: SumlTypeDS,
		valueNotFoundText: '',
		displayField: 'keyValue',
		valueField: 'key',
		mode: 'local', // ����ģʽ
		triggerAction: 'all',
		value: 'TK',
		selectOnFocus: true,
		forceSelection: true,
		editable: true
		//allowBlank:true
	});
//����״̬
var orderStatusDS = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [['', 'ȫ��'],['0', 'δ����'], ['2', '����']]
	});

//����������  ����״̬
var orderStatus = new Ext.form.ComboBox({
		id: 'orderStatus',
		fieldLabel: '����״̬',
		width: 120,
		listWidth: 100,
		store: orderStatusDS,
		valueNotFoundText: '',
		displayField: 'keyValue',
		valueField: 'key',
		mode: 'local', // ����ģʽ
		triggerAction: 'all',
		emptyText: 'ȫ��',
		value: '',
		selectOnFocus: true,
		forceSelection: true,
		editable: true
		//allowBlank:true
	});

var findButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'find',
		width: 55,
		handler: function () {
			find();
		}
	});

//ƾ֤����
var vouchDate = new Ext.form.DateField({
		id: 'vouchDate',
		fieldLabel: 'ƾ֤����',
		name: 'vouchDate',
		format: 'Y-m-d',
		editable: true,
		value: new Date(),
		allowBlank: false,
		emptyText: '��ѡ������...',
		width: 120
		// plugins: 'monthPickerPlugin'
	});

var createVouch = new Ext.Toolbar.Button({
		text: '&nbsp;����ƾ֤',
		width: 80,
		tooltip: '����ƾ֤',
		iconCls: 'createvouch',
		handler: function () {

			createVouch();

		}

	});

var  AuditButton= new Ext.Toolbar.Button({
		text: '���',
		width: 55,
		tooltip: '���',
		iconCls: 'audit',
		handler: function () {
			Audit();
		}
	});

function Audit(){
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var len = selectedRow.length;
	var rowid = "";
	var Drowid = "";
	// alert(len);
	if (len == 0) {
		Ext.Msg.show({
			title: '��ʾ',
			msg: '��ѡ����Ҫ���ƾ֤�����ݣ� ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	}

	for (var i = 0; i < len; i++) {
		var DmainID = selectedRow[i].data['rowid'];
		var AcctVoucherStatus = selectedRow[i].data['FRStatus'];		
		if(AcctVoucherStatus=="δ����"){
		if (Drowid == "") {
			Drowid = DmainID
		} else {
			Drowid = Drowid + "," + DmainID
		}	
     }
	};
	//alert(Drowid);
	
	if(!Drowid){
		Ext.Msg.show({
			title: '��ʾ',
			msg: '��ѡ������ݲ�������������� ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	}
	Ext.Ajax.request({
		url: projUrl + '?action=Audit&rowid=' + Drowid + '&AcctBookID=' + acctbookid + "&userid=" + userid,
		method: 'POST',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Ext.Msg.show({
					title: '��ʾ',
					msg: '��˳ɹ��� ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.INFO
				});
				var tbarnum = itemGrid.getBottomToolbar();
				tbarnum.doLoad(tbarnum.cursor);
			} else if (jsonData.success == 'false') {
			Ext.Msg.show({
					title: '��ʾ',
					msg: '���ʧ�ܣ� ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});				
			}
		},
		failure:function(result, request){
				Ext.Msg.show({
					title: '��ʾ',
					msg: '���ʧ�ܣ� ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});				
		}
	});	
};
if (vouchNO == "") {
	//��ѯ���
	var queryPanel = new Ext.FormPanel({
			title: '����ƾ֤',
			iconCls: 'createvouch',
			height: 71,
			region: 'north',
			frame: true,
			//split : true,
			//collapsible : true,
			defaults: {
				bodyStyle: 'padding:2px'
			},
			items: [{
					columnWidth: 1,
					xtype: 'panel',
					layout: "column",
					width: 1500,
					items: [{
							xtype: 'displayfield',
							value: 'ҵ��ϵͳ',
							style: 'padding:2px 5px'
							//width: 60

						},System,{
							xtype: 'displayfield',
							value: '',
							width: 15

						},{
							xtype: 'displayfield',
							value: 'ҵ������',
							style: 'padding:2px 5px'
							//width: 60

						},SumlTypecol,{
							xtype: 'displayfield',
							value: '',
							width: 15
						},{
							xtype: 'displayfield',
							value: '����',
							style: 'padding:2px 5px'
							//width: 60

						}, YearMonth, {
							xtype: 'displayfield',
							value: '',
							width: 15
						}, {
							xtype: 'displayfield',
							value: 'ҵ�񵥺�',
							style: 'padding:2px 5px'
							//width: 60
						}, OrderNO, {
							xtype: 'displayfield',
							value: '',
							width: 15
						}, {
							xtype: 'displayfield',
							value: '����״̬',
							style: 'padding:2px 5px'
							//width: 60
						}, orderStatus, {
							xtype: 'displayfield',
							value: '',
							width: 15
						}, findButton, {
							xtype: 'displayfield',
							value: '',
							width: 15
						}, createVouch
					]
				}
				/* ,{
				columnWidth:1,
				xtype: 'panel',
				layout:"column",
				width:1200,
				items:[{
				xtype:'displayfield',
				value:'',
				width:20
				},{
				xtype:'displayfield',

				value:'ƾ֤����:',
				//style:'line-height: 20px;',
				width:60,
				id:'vDate'
				},vouchDate,{
				xtype:'displayfield',
				value:'',
				width:100
				},createVouch ]
				} */
			]

		});

} else if (vouchNO != "") {

	var queryPanel = new Ext.FormPanel({
			//title:'�ʲ��۾���ϸ',
			region: 'north',
			frame: true,
			// split : true,
			//collapsible : true,
			//  defaults: {bodyStyle:'padding:2px'},
			//html:'<div style="text-align:center;font-size:20px;height:70px;vertical-align:middle; line-height:70px;font-weight:bold">�ʲ��۾�ҵ����ϸ��</div>',
			height: 80,

			items: [{
					xtype: 'displayfield',
					value: '�̶��ʲ���������ϸ��',
					style: 'text-align:center;font-size:16px;height:40px;vertical-align:middle; line-height:40px;font-weight:bold'
					//width:60
				}, {
					xtype: 'displayfield',
					value: 'ƾ֤���ţ�' + Vno,
					style: 'text-align:left'
				}
			]

		});

}

var itemGrid = new dhc.herp.Grid({
		iconCls: 'list',
		region: 'center',
		title: '��������',
		url: projUrl,
		fields: [
			new Ext.grid.CheckboxSelectionModel({
				editable: false
			}), {
				id: 'rowid',
				header: '<div style="text-align:center">ID</div>',
				width: 50,
				editable: false,
				align: 'left',
				allowBlank: false,
				hidden: true,
				dataIndex: 'rowid'
			}, {
				id: 'BookID',
				header: '<div style="text-align:center">BookID</div>',
				width: 50,
				editable: false,
				align: 'left',
				allowBlank: false,
				hidden: true,
				dataIndex: 'BookID'
			}, {
				id: 'systemCode',
				header: '<div style="text-align:center">ҵ��ϵͳ����</div>',
				width: 150,
				align: 'center',
				hidden:true,
				editable: false,
				allowBlank: true,
				dataIndex: 'systemCode'
			},{
				id: 'system',
				header: '<div style="text-align:center">ҵ��ϵͳ</div>',
				width: 150,
				align: 'center',
				editable: false,
				allowBlank: true,
				dataIndex: 'system'
			}, {
				id: 'OrderNO',
				header: '<div style="text-align:center">ҵ�񵥺�</div>',
				width: 150,
				align: 'center',
				editable: false,
				allowBlank: true,
				dataIndex: 'OrderNO'
			}, {
				id: 'SumlType',
				header: '<div style="text-align:center">ҵ������</div>',
				width: 80,
				align: 'center',
				editable: false,
				allowBlank: true,
				dataIndex: 'SumlType'
			}, {
				id: 'OpDate',
				header: '<div style="text-align:center">����</div>',
				width: 90,
				align: 'center',
				editable: false,
				allowBlank: true,
				dataIndex: 'OpDate'
			}, {
				id: 'DeparmentName',
				header: '<div style="text-align:center">�������</div>',
				width: 90,
				align: 'center',
				editable: false,
				allowBlank: true,
				// hidden:true,
				dataIndex: 'DeparmentName'
			}, {
				id: 'Status',
				header: '<div style="text-align:center">����״̬</div>',
				width: 120,
				align: 'center',
				editable: false,
				allowBlank: true,
				// hidden:true,
				dataIndex: 'Status'
			}, {
				id: 'AcctVouchStatus',
				header: '<div style="text-align:center">����״̬</div>',
				width: 80,
				align: 'center',
				editable: false,
				allowBlank: true,
				dataIndex: 'AcctVouchStatus'
			}, {
				id: 'UserName',
				header: '<div style="text-align:center">������</div>',
				width: 120,
				// align:'left',
				align: 'center',
				editable: false,
				allowBlank: true,
				dataIndex: 'UserName'
			}, {
				id: 'AcctVouchDate',
				header: '<div style="text-align:center">��������</div>',
				width: 120,
				align: 'center',
				editable: false,
				allowBlank: true,
				dataIndex: 'AcctVouchDate'
			}, {
				id: 'VouchNO',
				header: '<div style="text-align:center">ƾ֤��</div>',
				width: 150,
				align: 'center',
				editable: false,
				// allowBlank : true,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>'
				},
				dataIndex: 'VouchNO'
			}, {
				id: 'VouchID',
				header: '<div style="text-align:center">VouchID</div>',
				width: 150,
				align: 'center',
				editable: false,
				hidden:true,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>'
				},
				dataIndex: 'VouchID'
			}
		],
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true
		}),
		split: true,
		collapsible: true,
		containerScroll: true,
		xtype: 'grid',
		stripeRows: true,
		loadMask: true,
		height: (2 * gridHeight) / 5,
		trackMouseOver: true
	});

itemGrid.btnAddHide();
itemGrid.btnSaveHide();
itemGrid.btnResetHide();
itemGrid.btnDeleteHide();
itemGrid.btnPrintHide();
if (vouchNO != "") {
	itemGrid.load(({
			params: {
				start: 0,
				limit: 25,
				VouchNO: vouchNO
			}
		}));
}
itemGrid.on('rowclick', function (grid, rowIndex, e) {
	var MainRowid = '';
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	MainRowid = selectedRow[0].data['rowid'];
	//alert(MainRowid);
	itemGridf.load({
		params: {
			start: 0,
			limit: 25,
			MainRowid: MainRowid
		}
	});
});

var find = function () {
	var Month = YearMonth.getValue();
	if (Month != "") {
		Month = Month.format('Y-m-d');
	}
	// alert(Month);
	var OrderNOs = OrderNO.getValue();
	var Status = orderStatus.getValue();
	var Systemval = System.getValue();
 
    if(Systemval==""){
		
		Ext.Msg.show({
			title: '��ʾ',
			msg: '��ѡ��ҵ��ϵͳ�� ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
		
	};
	var SumlType=SumlTypecol.getValue();
	//alert(SumlType);
	    if(SumlType==""){
		
		Ext.Msg.show({
			title: '��ʾ',
			msg: '��ѡ��ҵ�����ͣ� ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
		
	};
	
	
	itemGrid.load({
		params: {
			sortField: '',
			sortDir: '',
			start: 0,
			limit: 25,
			System:Systemval,
			YearMonth: Month,
			OrderNO: OrderNOs,
			orderStatus: Status,
			SumlType:SumlType,
			VouchNO: vouchNO
		}
	});

	itemGridf.load({
		params: {
			start: 0,
			limit: 25,
			MainRowid: ""
		}
	});
};

// ����ƾ֤���ڵ�panel
var VouchDatePanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 90,
		labelAlign: 'right',
		lineHeight: 20,
		items: vouchDate
	});
// ����ƾ֤����
var CreateVouchWin;
var CreateStart = function (VouchDate) {

var selected = itemGrid.getSelectionModel().getSelections();
	var leng = selected.length;
	var FinancialReviewDR = "";
	// alert(len);
	if (leng != 1) {
		Ext.Msg.show({
			title: '��ʾ',
			msg: '��ѡ��һ�����ݣ� ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	};

	for (var i = 0; i < leng; i++) {
		var main = selected[i].data['rowid'];
		//var vouchNO=selectedRow[i].data['Poster'];
		var state = selected[i].data['AcctVouchStatus'];
		if (FinancialReviewDR == "") {
			FinancialReviewDR = main
		} else {
			FinancialReviewDR = FinancialReviewDR + "^" + main
		}
	}
	Ext.Ajax.request({
		url: '../csp/herp.acct.acctfinancialoutByOrderexe.csp?action=CreateVouch&rowid=' + FinancialReviewDR + '&vouchdate=' + VouchDate + '&AcctBookID=' + acctbookid + "&userid=" + userid,
		method: 'POST',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Ext.Msg.show({
					title: '��ʾ',
					msg: '����ƾ֤�ɹ� ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.INFO

				});
				//alert(vouchNO);
				itemGrid.load(({
						params: {
							start: 0,
							limit: 25,
							VouchNO: ""
						}
					}));
			} else if (jsonData.success == 'false') {
				var information = jsonData.info;

				if (information == "EmptyRecData") {
					Ext.Msg.show({
						title: '��ʾ',
						msg: 'ƾ֤��Ϣ������! ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO

					});
				} else if (information == "Emptydetail") {
					Ext.Msg.show({
						title: '��ʾ',
						width: 350,
						msg: 'ƾ֤��ϸ��Ϣ������,��˲�[��ƹ�Ӧ�̶���]�Լ�[ƾ֤ģ������]�Ƿ�ά���˵�ǰ���׵���Ϣ�� ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO

					});

				}else {
				Ext.Msg.show({
					title: '��ʾ',
					msg: 'ƾ֤����ʧ�ܣ� ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.INFO

				});

			}


			} else {
				Ext.Msg.show({
					title: '��ʾ',
					msg: 'ƾ֤����ʧ�ܣ� ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.INFO

				});

			}

		},
		failure: function (result, request) {

			Ext.Msg.show({
				title: '����',
				msg: '����ƾ֤ʧ��,������������! ',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
		}
	});

}

var createVouch = function () {
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var len = selectedRow.length;
	var rowid = "";
	if (len != 1) {
		Ext.Msg.show({
			title: '��ʾ',
			msg: '��ѡ��һ�����ݣ� ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	};
	for (var i = 0; i < len; i++) {
		var mainID = selectedRow[i].data['rowid'];
		//var vouchNO=selectedRow[i].data['Poster'];
		var state = selectedRow[i].data['AcctVouchStatus'];
		if (rowid == "") {
			rowid = mainID
		} else {
			rowid = rowid + "^" + mainID
		}
		//alert(vouchNO+"hh")
		//alert(rowid+" "+mainID+" "+i);
		/* if (state == "����") {
			Ext.Msg.show({
				title: '��ʾ',
				msg: '��ѡ���������Ѿ�����ƾ֤������,�����ظ����ɣ� ',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.WARNING

			});
			return;
		} */
		//alert(state);
		if (state != "δ����") {
			Ext.Msg.show({
				title: '��ʾ',
				msg: '��ѡ���������Ѽ��˵�����,��������ƾ֤�� ',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.WARNING

			});
			return;
		}
	}
	Ext.Ajax.request({
		url: 'herp.acct.acctfinancialoutByOrderexe.csp?action=ifNotConfigured&rowid=' + rowid + '&AcctBookID=' + acctbookid + "&userid=" + userid,
		method: 'POST',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ����ƾ֤�� ', function (btn) {

					if (btn == 'yes') {
						if (!CreateVouchWin) {
							CreateVouchWin = new Ext.Window({
									title: "����ƾ֤������",
									height: 200,
									width: 300,
									bodyStyle: 'padding:30px 10px 0 5px;',
									buttonAlign: 'center',
									closeAction: 'hide',
									items: VouchDatePanel,
									buttons: [{
											text: "ȷ��",
											handler: function () {

												var VouchDate = vouchDate.getValue();
												if (VouchDate == "") {
													Ext.Msg.show({
														title: '��ʾ',
														msg: 'ƾ֤���ڲ���Ϊ�գ� ',
														buttons: Ext.Msg.OK,
														icon: Ext.MessageBox.WARNING
													});
													return;
												} else {
													VouchDate = VouchDate.format('Y-m-d');
													CreateVouchWin.hide();
												}
                                                  CreateStart(VouchDate);
											}
										}, {
											text: "ȡ��",
											handler: function () {
												CreateVouchWin.hide();
											}
										}
									]
								});
						}
						CreateVouchWin.show();
					}
				});
			} else if (jsonData.success == 'false') {
				var information = jsonData.info;
				//alert(information);
				if (information == "NoSubj") {
					Ext.Msg.show({
						title: '��ʾ',
						msg: '��ƿ�Ŀ������,��ȷ����ƿ�Ŀ�������ԣ� ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO

					});

				} else if (information.split("*")[0] == "NoLoc") {
					var Loc = information.split("*")[1]
						Ext.Msg.show({
							title: '��ʾ',
							width: 300,
							msg: '����ƾ֤ʧ�ܣ�δ�ҵ�[<span style="color:blue">' + Loc + '</span><br/>]��Ӧ�Ŀ������,',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.INFO

						});

				} else if (information.split("*")[0] == "NoDept") {
					var Dept = information.split("*")[1]
						var deptname = information.split("*")[2]
						Ext.Msg.show({
							title: '��ʾ',
							width: 500,
							msg: '����ƾ֤ʧ�ܣ�δ�ҵ�[<br/><span style="color:blue">' + Dept + '</span><br/>],����"ƾ֤ģ������"�������ά���� ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.INFO

						});

				}

			} else {
				Ext.Msg.show({
					title: '��ʾ',
					msg: 'ƾ֤����ʧ�ܣ� ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.INFO

				});

			}

		},
		failure: function (result, request) {

			Ext.Msg.show({
				title: '����',
				msg: '����ƾ֤ʧ��,������������! ',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
		}
	});

}

itemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {

	if (columnIndex == '14') {
		//p_URL = 'acct.html?acctno=2';
		//document.getElementById("frameReport").src='acct.html';
		var records = itemGrid.getSelectionModel().getSelections();
		var VouchNo = records[0].get("VouchNO");
		var AcctBookID = records[0].get("BookID");
		var vouchID=records[0].get("VouchID");
		//alert(AcctBookID);
		var VouchState = '11';
		if (VouchNo != "") {
			var myPanel = new Ext.Panel({
					layout: 'fit',
					//scrolling="auto"
					html: '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo +'&AcctVouchIDPa='+vouchID+ '&user=' + userid + '&acctstate=' + VouchState + '&bookID=' + AcctBookID + '&SearchFlag=' + '2' + '" /></iframe>'
					//frame : true
				});
			var win = new Ext.Window({
					title: 'ƾ֤�鿴',
					width: 1090,
					height: 600,
					resizable: false,
					closable: true,
					draggable: true,
					resizable: false,
					layout: 'fit',
					modal: false,
					plain: true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
					//bodyStyle : 'padding:5px;',
					items: [myPanel],
					maximizable :true, 
					buttonAlign: 'center',
					buttons: [{
							text: '�ر�',
							iconCls:'cancel',
							type: 'button',
							handler: function () {
								win.close();
							}
						}
					]
				});
			win.show();
		}
	} 
});
