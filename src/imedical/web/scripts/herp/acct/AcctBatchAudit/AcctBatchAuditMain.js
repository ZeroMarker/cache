var userdr = session['LOGON.USERID'];

var bookID = IsExistAcctBook();

var StratagemTabUrl = '../csp/herp.acct.acctbatchauditexe.csp';

var MoidLogProxy = new Ext.data.HttpProxy({
		url: StratagemTabUrl + '?action=Vouchlist' + '&bookID=' + bookID,
		method: 'POST'
	});
var MoidLogDs = new Ext.data.Store({
		proxy: MoidLogProxy,
		//autoLoad:false,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, ['AcctVouchID', 'AcctYear', 'AcctMonth', 'VouchDate', 'VouchNo', 'VouchBillNum',
				'TotalAmtDebit', 'Operator', 'Auditor', 'Poster', 'VouchState',
				'VouchProgress', 'IsDestroy', 'IsCancel', 'VouchState1', 'Operator1', 'Auditor1', 'AcctYearMonth']),
		// turn on remote sorting
		remoteSort: true
	});
var MoidLogCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			new Ext.grid.CheckboxSelectionModel(), {
				id: 'AcctVouchID',
				header: '<div style="text-align:center">ID</div>',
				allowBlank: false,
				width: 100,
				editable: false,
				hidden: true,
				dataIndex: 'AcctVouchID'
			}, {
				id: 'AcctYear',
				header: '<div style="text-align:center">��</div>',
				width: 50,
				editable: false,
				align: 'center',
				dataIndex: 'AcctYear'
			}, {
				id: 'AcctMonth',
				header: '<div style="text-align:center">��</div>',
				width: 40,
				editable: false,
				align: 'center',
				dataIndex: 'AcctMonth'
			}, {
				id: 'VouchDate',
				header: '<div style="text-align:center">ƾ֤����</div>',
				width: 90,
				editable: false,
				align: 'center',
				dataIndex: 'VouchDate'
			}, {
				id: 'VouchNo',
				header: '<div style="text-align:center">ƾ֤��</div>',
				width: 110,
				editable: false,
				align: 'center',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>'
				},
				dataIndex: 'VouchNo'
			}, {
				id: 'VouchBillNum',
				header: '<div style="text-align:center">������</div>',
				width: 60,
				editable: false,
				align: 'center',
				dataIndex: 'VouchBillNum'
			}, {
				id: 'TotalAmtDebit',
				header: '<div style="text-align:center">�ܽ��</div>',
				width: 130,
				editable: false,
				align: 'right',
				dataIndex: 'TotalAmtDebit'
			}, {
				id: 'Operator',
				header: '<div style="text-align:center">�Ƶ���</div>',
				width: 100,
				editable: false,
				dataIndex: 'Operator'
			}, {
				id: 'Auditor',
				header: '<div style="text-align:center">�����</div>',
				width: 100,
				editable: false,
				dataIndex: 'Auditor'
			}, {
				id: 'Poster',
				header: '<div style="text-align:center">������</div>',
				width: 100,
				editable: false,
				dataIndex: 'Poster'
			}, {
				id: 'VouchState',
				header: '<div style="text-align:center">ƾ֤״̬</div>',
				width: 80,
				editable: false,
				dataIndex: 'VouchState'
			}, {
				id: 'VouchProgress',
				header: '<div style="text-align:center">ƾ֤�������</div>',
				width: 100,
				editable: false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>'
				},
				dataIndex: 'VouchProgress'

			}, {
				id: 'IsDestroy',
				header: '<div style="text-align:center">����ƾ֤</div>',
				width: 80,
				editable: false,
				dataIndex: 'IsDestroy'
			}, {
				id: 'IsCancel',
				header: '<div style="text-align:center">����ƾ֤</div>',
				width: 80,
				editable: false,
				dataIndex: 'IsCancel'
			}, {
				id: 'VouchState1',
				header: '<div style="text-align:center">ƾ֤״̬</div>',
				width: 80,
				editable: false,
				hidden: true,
				dataIndex: 'VouchState1'
			}, {
				id: 'Operator1',
				header: '<div style="text-align:center">������</div>',
				width: 100,
				editable: false,
				hidden: true,
				dataIndex: 'Operator1'
			}, {
				id: 'Auditor1',
				header: '<div style="text-align:center">�����</div>',
				width: 100,
				editable: false,
				hidden: true,
				dataIndex: 'Auditor1'
			}
			/* ,{
			id : ' ',
			header: '<div style="text-align:center">��ǰ����ڼ�</div>',
			width : 80,
			editable:false,
			hidden : true,
			dataIndex : 'AcctYearMonth'
			} */
		]);

var MoidLogPagTba = new Ext.PagingToolbar({
		store: MoidLogDs,
		pageSize: 25,
		displayInfo: true,
		plugins: new dhc.herp.PageSizePlugin(),
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û�м�¼"
	});

//��˰�ť
var auditButton = new Ext.Button({
		text: '���',
		tooltip: '���',
		width: 60,
		iconCls: 'audit',
		handler: function () {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			var checker = session['LOGON.USERCODE'];
			if (len < 1) {
				Ext.Msg.show({
					title: 'ע��',
					msg: '��ѡ����Ҫ��˵�����! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			}
			// ɸѡ���Լ������ύƾ֤
			var vouchIdArr = []; //��ŷ������������ƾ֤id
			var incomplatVouchCount = 0; //��ѡ�����������������
			for (var j = 0; j < len; j++) {
				if (rowObj[j].get("Operator1") != userdr && rowObj[j].get("VouchState1") == "11") {
					var vouchid = rowObj[j].get("AcctVouchID");
					if (vouchIdArr.indexOf(vouchid) == -1) {
						vouchIdArr.push(vouchid);
					}
				} else {
					incomplatVouchCount++;
				}
			}

			if (vouchIdArr.length == 0) {
				Ext.Msg.show({
					title: 'ע��',
					msg: '��ѡƾ֤�������ύ��ƾ֤! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.INFO
				});
				return;

			} else {
				//
				if (incomplatVouchCount) {
					Ext.MessageBox.confirm('��ʾ', '���������������ƾ֤�ѹ��ˣ�����Ĳ����� ', function (btn) {
						if (btn == 'yes') {
							auditFun(vouchIdArr);
						} else {
							return;
						}

					});
				} else {
					auditFun(vouchIdArr);
				}

			}
		}
	});

//����˰�ť
var cancleauditButton = new Ext.Button({
		text: '�����',
		tooltip: '�����',
		width: 60,
		iconCls: 'return_audit',
		handler: function () {
			//���岢��ʼ���ж���
			var rowObj = itemGrid.getSelectionModel().getSelections();
			//���岢��ʼ���ж��󳤶ȱ���
			var len = rowObj.length;
			var checker = session['LOGON.USERCODE'];
			var vouchidDs = [],incomplatVouchCount=0;	//��ѡ�����Ϸ������������
			if (len < 1) {
				Ext.Msg.show({
					title: 'ע��',
					msg: '��ѡ����Ҫ����˵�����! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			}
			for (var j = 0; j < len; j++) {
				if (rowObj[j].get("Auditor1") == userdr && rowObj[j].get("VouchState1") == "21" ){
					var vouchid = rowObj[j].get("AcctVouchID");
					if(vouchidDs.indexOf(vouchid == -1)) {
						vouchidDs.push(vouchid);
					}
				}else{
					incomplatVouchCount++;
				}
			}
			if (vouchidDs.length == 0) {
				Ext.Msg.show({
					title: 'ע��',
					msg: '��ѡ����������Լ���״̬Ϊ���ͨ����ƾ֤���з���˲���! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.INFO
				});
				return;
			} else {
				if(incomplatVouchCount){
					Ext.MessageBox.confirm('��ʾ', '�����Ϸ����������ƾ֤�ѹ��ˣ�����Ĳ����� ', function (btn) {
						if (btn == 'yes') {
							cancelAuditFun(vouchidDs);
						} else {
							return;
						}
					});
				}else{
					cancelAuditFun(vouchidDs);
				}				
			}
		}
	});

var itemGrid = new Ext.grid.EditorGridPanel({
		//title : 'ƾ֤��ʾ',
		region: 'center',
		pageSize: 25,
		store: MoidLogDs,
		cm: MoidLogCm,
		//atLoad : true,
		clicksToEdit: 1,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.CheckboxSelectionModel({
			singleSelect: false
		}),
		tbar: [auditButton, "-", cancleauditButton],
		bbar: MoidLogPagTba,
		loadMask: true
	});
/*
itemGrid.store.load({params:{start :  0,
limit : 25}});
 */
//MoidLogPagTba.on("change",function(o,p){
//MoidLogDs.reload();
//	});

itemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {
	//alert(columnIndex);
	var a = typenameCombo.getValue()
		if (a == 2) {
			var b = 14
		} else {
			var b = 13
		}
		if (columnIndex == '6') {
			//p_URL = 'acct.html?acctno=2';
			//document.getElementById("frameReport").src='acct.html';
			var records = itemGrid.getSelectionModel().getSelections();
			var VouchNo = records[0].get("VouchNo");
			var VouchState = records[0].get("VouchState1");
			var myPanel = new Ext.Panel({
					layout: 'fit',
					//scrolling="auto"
					html: '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userdr + '&acctstate=' + VouchState + '&bookID=' + bookID + '&SearchFlag=' + '1' + '" /></iframe>'
					//frame : true
				});
			var win = new Ext.Window({
					title: 'ƾ֤�鿴',
					width: 1093,
					height: 620,
					resizable: false,
					closable: true,
					draggable: true,
					resizable: false,
					layout: 'fit',
					modal: false,
					plain: true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
					//bodyStyle : 'padding:5px;',
					items: [myPanel],
					buttonAlign: 'center',
					buttons: [{
							text: '�ر�',
							type: 'button',
							handler: function () {
								win.close();
							}
						}
					]
				});
			win.show();
		}
		//ƾ֤�������
		if (columnIndex == b) {
			var records = itemGrid.getSelectionModel().getSelections();
			var VouchID = records[0].get("AcctVouchID");
			VouchProgressFun(VouchID);
		}
})
