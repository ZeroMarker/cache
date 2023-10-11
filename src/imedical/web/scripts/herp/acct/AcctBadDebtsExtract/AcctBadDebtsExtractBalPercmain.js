/***************************/
/*****creator:yanglf
/*****description:������ȡ
/***************************/

//---------��----------//

var userid = session['LOGON.USERID'];
var AcctBookID = GetAcctBookID();
var ExtBadDebtsBalMetUrl = '../csp/herp.acct.acctbaddebtsextractexe.csp';

/**************��**************/

//****ȡ��ǰ����ڼ�****/
var CurYearMonth = new Ext.form.DisplayField({
		id: 'CurYearMonth',
		columnWidth: 0.08

	});
//****ȡӦ�տ����****/
var EndSumField = new Ext.form.DisplayField({
		id: 'EndSumField',
		columnWidth: 0.15
	});

var endsums = 0, perc = 0; //����ȡ���
var yearmonth;
var year, month, flag, ext_btn_final;
//��ѯ��ǰ�ڼ�
Ext.Ajax.request({
	url: ExtBadDebtsBalMetUrl + '?action=GetCurYearMonth&UserID=' + userid,
	method: 'GET',
	success: function (result, request) {
		var respText = Ext.util.JSON.decode(result.responseText);
		YearMonth = respText.info;
		strs = YearMonth.split('^');
		year = strs[0],
		month = strs[1];
		yearmonth = year + '-' + month;
		CurYearMonth.setValue(yearmonth);
		zlCurYearMonth.setValue(yearmonth); //���䷨����ڼ�
		// oplogstr = year + "��" + month + "�»�����ȡ";
		//ȡӦ�տ����Ͷ��
		Ext.Ajax.request({
			url: ExtBadDebtsBalMetUrl + '?action=GetEndSum&UserID=' + userid + '&YearMonth=' + yearmonth,
			method: 'GET',
			success: function (result, request) {
				var respText = Ext.util.JSON.decode(result.responseText);
				str = respText.info;
				endsums = str.split('^')[0]; //Ӧ�տ�����ܺ�
				perc = str.split('^')[1]; //����ȡ����
				// alert(endsums)
				if(!endsums) endsums=0;
				EndSumField.setValue(Ext.util.Format.number(endsums, '0,000.00'));
			},
			failure: function (result, request) {
				return;
			}
		});
		//end

		//�ж��Ƿ��ڼ仵������ȡ
		var oplogstr = year + "��" + month + "�»�����ȡ";
		// alert(oplogstr);
		// console.log(oplogstr)
		Ext.Ajax.request({
			url: ExtBadDebtsBalMetUrl + '?action=IfRepVouch&UserID=' + userid + '&oplogstr=' + encodeURI(oplogstr),
			method: 'GET',
			success: function (result, request) {
				var respText = Ext.util.JSON.decode(result.responseText);
				flag = respText.info;
				if(flag == (year + "��" + month + "�»�����ȡ")) GenVouchBtn.disable();
				// alert(str);
				/* if(flag==1){
				Ext.Msg.show({
				title:'��ʾ',
				msg:year+'��'+month+'�»�����ȡƾ֤�����ɣ����������ɣ� ',
				icon:Ext.Msg.INFO,
				buttons:Ext.MessageBox.OK
				});
				return;
				}else{
				scpzcr();
				} */
			},
			failure: function (result, request) {
				return;
			}
		});
	},
	failure: function (result, request) {
		return;
	}

});

//*****������ȡ��ť*****/
var ExtBadButton = new Ext.Button({
		text: '������ȡ',
		iconCls: 'dataabstract',
		cls: 'x-btn-text-icon ',
		columnWidth: .08,
		handler: function () {
			//Ӧ�տ����Ϊ�㣬������к�������
			// alert(endsums+"^"+!endsums)
			if (endsums == 0) {
				Ext.Msg.show({
					title: 'ע��',
					msg: 'Ӧ�տ����Ϊ�㣬������л�����ȡ�� ',
					icon: Ext.Msg.INFO,
					buttons: Ext.Msg.OK
				});
				// ExtBadButton.disable();
				GenVouchBtn.disable();
				return;
			}
			//���ڼ�ƾ֤���ɺ�ֻ���в�ѯ
			// alert(flag)
			if (flag == (year + "��" + month + "�»�����ȡ")) {
				pzGrid.store.load({
					params: {
						YearMonth: yearmonth,
						UserID: userid
					}
				});
				GenVouchBtn.disable();
				return;
			}
			//����ƾ֤��ϸ
			/* var ym = CurYearMonth.getValue();
			year = ym.split('-')[0],
			month = ym.split('-')[1]; */
			Ext.Msg.confirm('��ʾ', '��ȷ��Ҫ��' + year + '��' + month + '�½��л�����ȡ�� ', callback);
			function callback(id) {
				if (id == 'yes') {

					pzGrid.store.removeAll(); //���ҳ������
					Ext.Msg.show({
						title: 'ע��',
						width: 400,
						msg: '������ȡ����Ϊ��' + Math.round(perc * 100) + '%��<br>��ȡ���Ϊ��' + Ext.util.Format.number(endsums, '0,000.00') + '��' +Math.round(perc * 100) + '%=' + Ext.util.Format.number(endsums * perc, '0,000.00'),
						icon: Ext.Msg.INFO,
						buttons: Ext.MessageBox.OK
					});

					pzGrid.store.load({
						params: {
							YearMonth: yearmonth,
							UserID: userid
						}
					});
					//��ִ�л�����ȡ����
					// flag=year + "��" + month + "�»�����ȡ";
					ext_btn_final="��ȡ�������";
				}
			}

		}
	});

//******��ʱƾ֤����ƾ֤��ť**********/
function scpzcr() {
	// alert("ƾ֤����");
	Ext.Msg.confirm('��ʾ', '��ȷ��Ҫ����' + year + '��' + month + '�µĻ���ƾ֤�� ', callback);
	function callback(id) {
		if (id == 'yes') {
			Ext.Ajax.request({
				url: ExtBadDebtsBalMetUrl + '?action=Add&UserID=' + userid + '&YearMonth=' + yearmonth,
				method: 'GET',
				success: function (result, request) {
					var respText = Ext.util.JSON.decode(result.responseText);
					str = respText.info;
					// alert(str);
					if (str == "") {
						Ext.Msg.show({
							title: '��ʾ',
							msg: '����ƾ֤�ɹ��� ',
							icon: Ext.Msg.INFO,
							buttons: Ext.MessageBox.OK
						});
						pzGrid.store.load({
							params: {
								YearMonth: yearmonth,
								UserID: userid
							}
						});
						GenVouchBtn.disable();	//������ɺ�ť������
						flag=year + "��" + month + "�»�����ȡ";
						return;
					} else {
						Ext.Msg.show({
							title: '����',
							msg: '����ƾ֤ʱ���� ',
							icon: Ext.Msg.ERROR,
							buttons: Ext.MessageBox.OK
						});
						return;
					}
				},
				failure: function (result, request) {
					return;
				}
			});
		}
	}
}

var GenVouchBtn = new Ext.Button({
		text: '&nbsp;����ƾ֤',
		width: 80,
		tooltip: '����ƾ֤',
		iconCls: 'createvouch',
		handler: function () {
			// alert(pzGrid.getStore().getAt(0).get('VouchNo'))
			// if(flag!==2){
			// if (flag != year + "��" + month + "�»�����ȡ") {
			if(ext_btn_final!="��ȡ�������"){
				Ext.Msg.show({
					title: '����',
					msg: '���Ƚ��л�����ȡ������ ',
					icon: Ext.Msg.ERROR,
					buttons: Ext.MessageBox.OK
				});
				return;
			} else {
				scpzcr();
			}

		}

	});

//*****�����*****/
var yePanel = new Ext.Panel({
		region: 'north',
		height: 70,
		frame: true,
		defaults: {
			bodyStyle: 'padding:0 0 0 10;line-height:20px;'

		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				columnWidth: 1,
				items: [{
						xtype: 'displayfield',
						value: '��ǰ����ڼ�:',
						columnWidth: .09
					}, CurYearMonth]
			}, {
				xtype: 'panel',
				layout: 'column',
				columnWidth: 1,
				items: [{
						xtype: 'displayfield',
						value: '��������ȡ��ʽΪ"��"����ǰӦ�տ����Ϊ:',
						columnWidth: .28
					}, EndSumField, ExtBadButton]
			}
		]

	});

//*********��ʱƾ֤����Դ*********//
var VouchDsproxy = new Ext.data.HttpProxy({
		method: 'POST',
		url: ExtBadDebtsBalMetUrl + '?action=TempBadDebtsVouch'

	});
var VouchDs = new Ext.data.Store({
		proxy: VouchDsproxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, ['VouchNo', 'AcctSubjCode', 'AcctSubjName', 'Summary', 'AmtDebit', 'AmtCredit']),
		remoteSort: true
	});
// console.log(VouchDs)
//*********��Ӻϼ�********//
/*function gridsum(grid){
var AmtDebitSum=0,AmtCreditSum=0;	//��������ϼ�
grid.store.each(function(record){
// alert(record.data.AmtDebit+"^"+Number(record.data.AmtDebit))
AmtDebitSum+=Number(record.data.AmtDebit);
AmtCreditSum+=Number(record.data.AmtCredit);
});
var newdata=new Ext.data.Record({
Summary:'�ϼƣ�',
AmtDebit:AmtDebitSum,
AmtCredit:AmtCreditSum
});
// grid.store.insert(0,newdata);	//��ӵ���һ��
grid.store.insert(grid.store.getCount(),newdata);	//��ӵ����һ��
}*/

//**********������**********//
var columnData = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(), {
			header: '<div style="text-align:center">ƾ֤��</div>',
			width: 100,
			dataIndex: 'VouchNo',
			sortable: true,
			align: 'left',
			renderer: function (v) {
				if (v) {
					return "<span style='color:blue;cursor:hand;'><u>" + v + "</u></span>";
				}
			}
		}, {
			header: '<div style="text-align:center">��Ŀ����</div>',
			width: 150,
			dataIndex: 'AcctSubjCode',
			// sortable : true,
			align: 'left'
		}, {
			header: '<div style="text-align:center">��Ŀ����</div>',
			dataIndex: 'AcctSubjName',
			width: 180,
			align: 'left'
		}, {
			header: '<div style="text-align:center">ժҪ</div>',
			dataIndex: 'Summary',
			width: 240,
			// align : 'left',
			renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
				// alert(value);
				if (value == "�ϼ�:") {
					return '<div style="text-align:right;">' + value + '</div>';
				} else {
					return value;
				}

			}
		}, {
			header: '<div style="text-align:center">�跽���</div>',
			dataIndex: 'AmtDebit',
			width: 200,
			align: 'right',
			renderer: function (value) {
				return Ext.util.Format.number(value, '0,000.00');
			}
		}, {
			header: '<div style="text-align:center">�������</div>',
			dataIndex: 'AmtCredit',
			width: 200,
			align: 'right',
			renderer: function (value) {
				return Ext.util.Format.number(value, '0,000.00');
			}
		}
	]);

//**********����ƾ֤��ʾ**********//
var pzGrid = new Ext.grid.GridPanel({
		// atLoad:true,
		region: 'south',
		height: 510,
		autoScroll: true,
		store: VouchDs,
		pageSize: 25,
		trackMouseOver: true, //�������������
		stripeRows: true,
		tbar: [GenVouchBtn],
		cm: columnData /* ,
		bbar : new Ext.PagingToolbar({
		store :VouchDs,
		pageSize : 25,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}����',
		emptyMsg: "û������"
		}) */
	});

pzGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {

	if (columnIndex == '1') {
		//p_URL = 'acct.html?acctno=2';
		//document.getElementById("frameReport").src='acct.html';
		var records = pzGrid.getSelectionModel().getSelections();
		var VouchNo = records[0].get("VouchNo");
		// var VouchState = records[0].get("VouchState1");
		if(!VouchNo) return;
		var myPanel = new Ext.Panel({
				layout: 'fit',
				//scrolling="auto"
				html: '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userid + '&acctstate=11&bookID=' + AcctBookID + '&SearchFlag=1" /></iframe>'
				// frame : true
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
	};

});
