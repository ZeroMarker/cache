var userid,bookid,vouchNO;
var projUrl = 'herp.acct.acctexpenditurectrlexe.csp';
var vNO=document.getElementById("vouchNO").innerHTML;
if(vNO==""){
	userid = session['LOGON.USERID'];
	bookid = IsExistAcctBook();
}else{
	bookid=document.getElementById("AcctBookID").innerHTML;
	userid=document.getElementById("userid").innerHTML;
	vouchNO=vNO+"#"+bookid;	
}
// alert(userid+" "+vouchNO)


var codeFeild = new Ext.form.TextField({
		fieldLabel : '��������',
		id : 'codeFeild',
		name : 'codeFeild',
		width : 120,
		emptyText : '��������...'
	});
	
var sDateField = new Ext.form.DateField({
		fieldLabel : '��������',
		width:110,
		// format : 'Y-m-d',
		emptyText : '��ʼʱ��...',
		renderer : function (v, p, r, i) {
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {
				return v;
			}
		}
	});
var eDateField = new Ext.form.DateField({
		fieldLabel : '-',
		width:110,
		// format : 'Y-m-d',
		emptyText : '����ʱ��...',
		renderer : function (v, p, r, i) {
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {
				return v;
			}
		}
	});

var cVouchDateField = new Ext.form.DateField({
		fieldLabel : 'ƾ֤����',
		width:120,
		// format : 'Y-m-d',
		value : new Date(),
		renderer : function (v, p, r, i) {
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {
				return v;
			}
		}
	});	
var dataStateComb = new Ext.form.ComboBox({
		fieldLabel : '����״̬',
		width : 80,
		listWidth : 80,
		store : new Ext.data.ArrayStore({
			fields : ['code', 'name'],
			data : [['1', '�Ѽ���'], ['0', 'δ����']]
		}),
		displayField : 'name',
		valueField : 'code',
		typeAhead : true,
		mode : 'local',
		forceSelection : true,
		triggerAction : 'all',
		selectOnFocus : 'true'
	});
	
	//////��������
var deptDs = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
			totalProperty : "results",
			root : 'rows'
		}, ['rowid', 'name'])
	});

deptDs.on('beforeload', function (ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
			url : projUrl + '?action=departList',
			method : 'POST'

		});
});

var deptCombo = new Ext.form.ComboBox({
		fieldLabel : '��������',
		store : deptDs,
		displayField : 'name',
		valueField : 'rowid',
		typeAhead : true,
		forceSelection : true,
		triggerAction : 'all',
		emptyText : '',
		width : 180,
		listWidth : 255,
		pageSize : 10,
		minChars : 1,
		selectOnFocus : true
	});

//////��ѯ��ť
var findButton = new Ext.Toolbar.Button({
		text : '��ѯ',
		tooltip : '��ѯ',
		width:55,
		iconCls : 'find',
		handler : function () {

			var dept = deptCombo.getValue();
			var dataState = dataStateComb.getValue();
			var code = codeFeild.getValue();
			var selectedRow = itemGrid.getSelectionModel().getSelections();
			var length = selectedRow.length;
			if (sDateField.getValue() == "") {
				var sdate = ""
			} else {
				var sdate = sDateField.getRawValue();
			}
			if (eDateField.getValue() == "") {
				var edate = ""
			} else {
				var edate = eDateField.getRawValue();
			}

			/* if (sdate == ""){
				Ext.Msg.show({
					title : 'ע��',
					msg : '������ѡ��ʼ���ڣ�',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});

				return;
			} 
			if(edate==""){
				Ext.Msg.show({
					title : 'ע��',
					msg : '����ѡ��������ڣ�',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});

				return;
			}*/

			var BillNo = ""
			if (length > 0) {
				for (var i = 0; i < length; ++i) {
					BillNo += "'" + selectedRow[i].data['billcode'] + "'" + ",";
				}
			}
			if ((BillNo != "") || (BillNo == null)) {
				code = code + "^" + BillNo;
			}
			//alert(code)

			itemGrid.load({
				params : {
					start : 0,
					limit : 25,
					code : code,
					sDate : sdate,
					eDate : edate,
					DataState : dataState,
					dept : dept

				}
			});
		}
	});

//////////////////// ƾ֤���ɰ�ť //////////////////////
var CreateVouchWin;
var VouchDatePanel=new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 90,
		labelAlign:'right',
		lineHeight:20,
		items:cVouchDateField
	});

	var VouchButton = new Ext.Toolbar.Button({
			id: 'VouchButton',
			text: '&nbsp;����ƾ֤',
			width: 80,
			tooltip: '����ƾ֤',
			iconCls: 'createvouch',
			handler: function () {
				// console.log("click")
				var selectedRow = itemGrid.getSelectionModel().getSelections();
				var length = selectedRow.length;
				if (length < 1) {
					Ext.Msg.show({
						title: 'ע��',
						msg: '��ѡ������Ҫ����ƾ֤�����ݣ� ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.WARNING
					});
					return;
				}
				Ext.MessageBox.confirm('��ʾ', '��ѡ��¼ȷ��Ҫ����ƾ֤�� ',
				function callback(id) {
				if (id == "yes") {

					// console.log("yes");
					// alert("yes");
					var BillNo = "";
					for (var i = 0; i < length; ++i) {
						var DataStatus = selectedRow[i].data['checkstate'];
						if (DataStatus == "�Ѽ���")
							continue; //�����Ѿ������˵�����
						BillNo += "'" + selectedRow[i].data['billcode'] + "',";
					}
					// alert(length+"&"+BillNo+"&"+cVouchDate)
					if (BillNo == "") {
						Ext.Msg.show({
							title: 'ע��',
							msg: '��ѡ��δ���˵����ݣ� ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.WARNING
						});
						return;
					}
					if (!CreateVouchWin) {
						// console.log("click");
						CreateVouchWin = new Ext.Window({
								title: "����ƾ֤������",
								height: 200,
								width: 300,
								bodyStyle: 'padding:30px 10px 0 5px;',
								buttonAlign: 'center',
								items: VouchDatePanel,
								closeAction: 'hide', //�رհ�ť����
								buttons: [{
										text: "ȷ��",
										handler: function () {
											var cVouchDate = cVouchDateField.getRawValue();
											// ȡ���������ں󣬹ر�����ѡ�񴰿�
											if (cVouchDate)
												CreateVouchWin.hide(); //�رմ��ڣ���hide��������ֹ�ٴ򿪴����Ǳ���
											else {
												Ext.Msg.show({
													title: 'ע��',
													msg: '��ѡ��ƾ֤���������ڣ� ',
													buttons: Ext.Msg.OK,
													icon: Ext.MessageBox.WARNING
												});
												return;
											}

											
												Ext.Ajax.request({
													url: projUrl + '?action=createVouch&userid=' + userid + '&BillNo=' + BillNo + '&AcctBookID=' + bookid + '&cVouchDate=' + cVouchDate,
													method: 'POST',
													success: function (result, request) {
														var jsonData = Ext.util.JSON.decode(result.responseText);
														if (jsonData.success == 'true') {

															Ext.Msg.show({
																title: '��ʾ',
																msg: '����ƾ֤�ɹ��� ',
																buttons: Ext.Msg.OK,
																icon: Ext.MessageBox.INFO

															});
															//ˢ�º�ͣ���ڵ�ǰҳ
															var tbarnum = itemGrid.getBottomToolbar();
															tbarnum.doLoad(tbarnum.cursor);

															// itemGrid.load({
															// params : {
															// start : 0,
															// limit : 25,
															// VouchNO : vouchNO
															// }
															// });
														} else {
															var err = "����ƾ֤ʧ�ܣ�";
															if (jsonData.info == "DeptTypeError")
																err = err + "��ƿ��Ҷ���ҳ��û��ά����ѡ�������Ҷ�Ӧ��Ԥ��� "
																	if (jsonData.info == "AcctSubjError")
																		err = err + "�����������ڵ�Ԥ������ƾ֤ģ�����ý���û��ά���� "
																			if (jsonData.info == "AcctFinally")
																				err = "��ѡ��¼�����ˣ� "
																					Ext.Msg.show({
																						title: '��ʾ',
																						msg: err,
																						buttons: Ext.Msg.OK,
																						icon: Ext.MessageBox.ERROR

																					});

														}

													},
													failure: function (result, request) {

														Ext.Msg.show({
															title: '����',
															msg: '����ƾ֤ʧ��,�����������ӣ� ',
															buttons: Ext.Msg.OK,
															icon: Ext.MessageBox.ERROR
														});
														return;
													}
												});
											

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
				} else
						return;
				});
				

			}
		});

	//��ѯ���
 var querypanel=new Ext.FormPanel({
	 title:"Ԥ��֧������",
	 iconCls:'createvouch',
	height : 73,
    region : 'north',
    frame : true,
	defaults: {
		width:1200,
		bodyStyle:'padding:5px;'
	},
	items:[{	
		xtype: 'panel',
		layout:'column',
		items:[
		{
			xtype: 'displayfield',
			style:'padding:0 5px',
			value:'��������'
			//width:65
		},codeFeild,{
			xtype: 'displayfield',
			width:20
		},
		{
			xtype: 'displayfield',
			style:'padding:0 5px',
			value:'��������'
			//width:65
		},deptCombo,{
			xtype: 'displayfield',
			width:20
		},
		{
			xtype: 'displayfield',
			style:'padding:0 5px',
			value:'��������'
			//width:65
		},sDateField,{
			xtype: 'displayfield',
			style:'padding:0 5px',
			value:'--'
			//width:15
		},eDateField,{
			xtype: 'displayfield',
			width:20
		},
		{
			xtype: 'displayfield',
			style:'padding:0 5px',
			value:'����״̬'
			//width:65
		},dataStateComb,{
			xtype: 'displayfield',
			width:20
		},findButton,{
			xtype: 'displayfield',
			width:20
		},VouchButton
		]}/* ,{
		xtype: 'panel',
		layout:'column',
		items:[{
			xtype: 'displayfield',
			style:'margin-left:20px;',
			value:'ƾ֤����',
			width:60
		},cVouchDateField,{
			xtype: 'displayfield',
			width:80
		},VouchButton
		]
		
	}*/
	]
});


var itemGrid = new dhc.herp.Grid({
		// title : '���ñ���ƾ֤����',
		region : 'center',
		url : 'herp.acct.acctexpenditurectrlexe.csp',
		fields : [
			new Ext.grid.CheckboxSelectionModel({
				editable : false
			}), {
				header : '�����ID',
				dataIndex : 'rowid',
				hidden : true
			}, {
				id : 'checkyearmonth',
				header : '��������',
				width : 70,
				editable : false,
				dataIndex : 'checkyearmonth'
			}, {
				id : 'billcode',
				header : '��������',
				editable : false,
				width : 110,
				renderer : function (value, cellmeta, record, rowIndex, columnIndex, store) {
					//backgroundColor:red
					return '<span style="color:blue;cursor:hand;"><u>' + value + '</u></span>';
				},
				dataIndex : 'billcode'

			}, {
				id : 'deprdr',
				header : '��������ID',
				editable : false,
				width : 100,
				dataIndex : 'deprdr',
				hidden : true
			}, {
				id : 'dcode',
				header : '��������code',
				editable : false,
				width : 100,
				dataIndex : 'dcode',
				hidden : true 
			}, {
				id : 'dname',
				header : '��������',
				editable : false,
				width : 100,
				dataIndex : 'dname',
				hidden : false
			}, {
				id : 'applyer',
				header : '������Ա',
				editable : false,
				width : 80,
				dataIndex : 'applyer'

			}, {
				id : 'actpay',
				header : '�������',
				width : 120,
				editable : false,
				align : 'right',
				dataIndex : 'actpay'

			}, {
				id : 'applydate',
				header : '����ʱ��',
				width : 125,
				align : 'center',
				editable : false,
				dataIndex : 'applydate'

			}, {
				id : 'audeprdr',
				header : '��ڿ���ID',
				editable : false,
				width : 100,
				dataIndex : 'audeprdr',
				hidden : true
			}, {
				id : 'audname',
				header : '��ڿ���',
				editable : false,
				width : 100,
				dataIndex : 'audname',
				hidden : true
			}, {
				id : 'applydecl',
				header : '����˵��',
				editable : false,
				width : 150,
				// hidden:true,
				dataIndex : 'applydecl'
			}, {
				id : 'checkstate',
				header : '����״̬',
				width : 80,
				align : 'center',
				editable : false,
				dataIndex : 'checkstate'

			}, {
				id : 'vouchno',
				header : 'ƾ֤��',
				editable : false,
				align : 'left',
				width : 100,
				renderer : function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;"><u>' + value + '</u></span>';
				},
				dataIndex : 'vouchno'
			}, {
				id : 'bookid',
				header : '����ID',
				width : 80,
				align : 'center',
				editable : false,
				hidden:true,
				dataIndex : 'bookid'

			}, {
				id : 'acctuser',
				header : '������',
				editable : false,
				width : 80,
				dataIndex : 'acctuser'
			}, {
				id : 'acctdate',
				header : '��������',
				editable : false,
				align : 'center',
				width : 100,
				dataIndex : 'acctdate'
			}
		]
	});

itemGrid.btnAddHide(); //�������Ӱ�ť
itemGrid.btnSaveHide(); //���ر��水ť
itemGrid.btnResetHide(); //�������ð�ť
itemGrid.btnDeleteHide(); //����ɾ����ť
itemGrid.btnPrintHide(); //���ش�ӡ��ť

if(vNO){
	//��ѯ���
 var querypanel=new Ext.FormPanel({
		height : 80,
		region : 'north',
		frame : true,
		items:[{
			xtype:'displayfield',
			value:'Ԥ��֧�����Ƽ�����ϸ��',
			style:'text-align:center;font-size:16px;height:40px;vertical-align:middle; line-height:40px;font-weight:bold'
		},{
			xtype:'displayfield',
			value:'ƾ֤���ţ�'+vNO,
			style:'text-align:left'
		}]
		
	});
	itemGrid.load({
		params:{
			start:0,
			limit:25,
			VouchNO:vouchNO
		}
	});

	
}

// ��������״̬ ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {
	var VouchState=11;
	var records = itemGrid.getSelectionModel().getSelections();   
	var BillCode=records[0].get("billcode"),
		BookID=records[0].get("bookid"),
		VouchNo = records[0].get("vouchno");

	//�����������ŵ�Ԫ��
	if (columnIndex == 4&&BillCode) {
		
		EditFun(itemGrid);
	}
	//ƾ֤������
	if(columnIndex==15&&VouchNo) {
			var myPanel = new Ext.Panel({
			layout : 'fit',
			html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno='+VouchNo+'&user='+userid+'&acctstate='+VouchState+'&bookID='+BookID+'&SearchFlag=3" /></iframe>'
			});
			var win = new Ext.Window({
						title : 'ƾ֤¼��',
						width :1093,
						height :620,
						resizable : false,
						closable : true,
						draggable : true,
						resizable : false,
						layout : 'fit',
						modal : false,
						plain : true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
						//bodyStyle : 'padding:5px;',
						items : [myPanel],
						buttonAlign : 'center',
						buttons : [{
								text : '�ر�',
								type : 'button',
								handler : function() {
									win .close();
									}
								}]
					});
					win.show();
	}

});