//// �˲���ѯ-��Ŀ����-��ҽ��ʽ

//var bookID=IsExistAcctBook();

//var bookID= InitAcctBook();
var bookID = IsExistAcctBook();
var acctbookid = bookID; //��ɾ
var userdr = session['LOGON.USERID']; //��¼��ID
//alert(userdr);
//=================================��ѯ���� FormPanel==========================//

var buttQuery = new Ext.Button({
		text: "��ѯ",
		width: 70,
		iconCls: 'find',
		handler: function () {
			//alert(bookID);

			////Schem   ������ѯ������grid
			var SchemGrid = new dhc.herp.Grid({
					title: '��ѯ����ά��',
					iconCls: 'maintain',
					region: 'center',
					url: 'herp.acct.subjectcurrencybalanceexe.csp',
					split: true,
					viewConfig: {
						forceFit: true
					},
					fields: [//new Ext.grid.CheckboxSelectionModel({editable:false}),
						//  s jsonTitle=rowid^bookid^code^name^desc
						{
							id: 'rowid',
							header: 'ID',
							width: 100,
							editable: false,
							hidden: true,
							dataIndex: 'rowid'
						}, {
							id: 'bookid',
							header: '<div style="text-align:center">����id</div>',
							align: 'right',
							editable: false,
							width: 140,
							hidden: true,
							dataIndex: 'bookid'
						}, {
							id: 'code',
							header: '<div style="text-align:center">�������</div>',
							width: 50,
							allowBlank: false,
							align: 'left',
							dataIndex: 'code'

						}, {
							id: 'name',
							header: '<div style="text-align:center">��������</div>',
							width: 140,
							allowBlank: false,
							align: 'left',
							dataIndex: 'name'
						}, {
							id: 'desc',
							header: '��������',
							width: 220,
							allowBlank: true,
							hidden: true,
							dataIndex: 'desc'
						}
					]
				});
			SchemGrid.load({
				params: {
					start: 0,
					limit: 10,
					bookID: bookID
				}
			});
			//SchemGrid.addButton('-');
			//SchemGrid.addButton('<div style="color:red">˵������Ŀ����-���ʽ�ķ��������ZB0203��ͷ��</div>');
			SchemGrid.btnResetHide() //�������ð�ť
			SchemGrid.btnPrintHide() //���ش�ӡ��ť

			//////////////��Ŀ�����ѯ����start///////////
			var SubjCodeDs02 = new Ext.data.Store({
					autoLoad: true,
					proxy: "",
					reader: new Ext.data.JsonReader({
						totalProperty: 'results',
						root: 'rows'
					}, ['subjId', 'subjCode', 'subjName', 'subjCodeNameAll'])
				});
			SubjCodeDs02.on('beforeload', function (ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
						url: '../csp/herp.acct.subjectcurrencybalanceexe.csp?action=GetAcctSubj03&bookID=' + bookID + '&str=' + Ext.getCmp('AcctSubjCodeStart02').getRawValue(),
						method: 'POST'
					});
			});

			var AcctSubjCodeStart02 = new Ext.form.ComboBox({
					id: 'AcctSubjCodeStart02',
					fieldLabel: '��ƿ�Ŀ��ʼ',
					labelSeparator:'',
					store: SubjCodeDs02,
					valueField: 'subjCode',
					displayField: 'subjCodeNameAll',
					typeAhead: true,
					width: 180,
					listWidth: 230,
					triggerAction: 'all',
					pageSize: 10,
					minChars: 1
				});

			var SubjCodeEndDs02 = new Ext.data.Store({
					autoLoad: true,
					proxy: "",
					reader: new Ext.data.JsonReader({
						totalProperty: 'results',
						root: 'rows'
					}, ['subjId', 'subjCode', 'subjName', 'subjCodeNameAll'])
				});
			SubjCodeEndDs02.on('beforeload', function (ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
						url: '../csp/herp.acct.subjectcurrencybalanceexe.csp?action=GetAcctSubj03&bookID=' + bookID + '&str=' + Ext.getCmp('AcctSubjCodeEnd02').getRawValue(),
						method: 'POST'
					});
			});
			var AcctSubjCodeEnd02 = new Ext.form.ComboBox({
					id: 'AcctSubjCodeEnd02',
					fieldLabel: '��ƿ�Ŀ����',
					labelSeparator:'',
					store: SubjCodeEndDs02,
					valueField: 'subjCode',
					displayField: 'subjCodeNameAll',
					width: 180,
					listWidth: 230,
					triggerAction: 'all',
					pageSize: 10,
					minChars: 1,
					selectOnFocus: true,
					forceSelection: 'true'
				});

			///////////////��Ŀ����///////////////////////

			var levelDs02 = new Ext.data.SimpleStore({
					fields: ['key', 'keyValue'],
					data: [['1', '1'], ['2', '2'], ['3', '3'], ['4', '4'],
						['5', '5'], ['6', '6'], ['7', '7'], ['8', '8']]
				});

			var SubjLevel02 = new Ext.form.ComboBox({
					id: 'SubjLevel02',
					fieldLabel: '��Ŀ����',
					labelSeparator:'',
					width: 180,
					listWidth: 100,
					store: levelDs02,
					valueNotFoundText: '',
					displayField: 'keyValue',
					valueField: 'key',
					mode: 'local', // ����ģʽ
					triggerAction: 'all',
					selectOnFocus: true,
					forceSelection: true
				});

			/////////������////////
			var YearDs02 = new Ext.data.Store({
					autoLoad: true,
					proxy: "",
					reader: new Ext.data.JsonReader({
						totalProperty: 'results',
						root: 'rows'
					}, ['year', 'yearh'])
				});
			YearDs02.on('beforeload', function (ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
						url: '../csp/herp.acct.subjectcurrencybalanceexe.csp?action=GetAcctYear&bookID=' + bookID + '&str=' + Ext.getCmp('AcctYear02').getRawValue(),
						method: 'POST'
					});
			});

			var AcctYear02 = new Ext.form.ComboBox({
					id: 'AcctYear02',
					fieldLabel: '������',
					labelSeparator:'',
					store: YearDs02,
					valueField: 'year',
					displayField: 'yearh',
					width: 180,
					listWidth: 220,
					triggerAction: 'all',
					pageSize: 10,
					minChars: 1,
					selectOnFocus: true,
					forceSelection: 'true'
				});

			/////////����·�////////
			var MonthDs02 = new Ext.data.SimpleStore({
					fields: ['key', 'keyValue'],
					data: [['01', '01��'], ['02', '02��'], ['03', '03��'], ['04', '04��'],
						['05', '05��'], ['06', '06��'], ['07', '07��'], ['08', '08��'],
						['09', '09��'], ['10', '10��'], ['11', '11��'], ['12', '12��']]
				});

			var AcctMonthStrat02 = new Ext.form.ComboBox({
					id: 'AcctMonthStrat02',
					fieldLabel: '��ʼ�·�',
					labelSeparator:'',
					width: 180,
					listWidth: 100,
					store: MonthDs02,
					valueNotFoundText: '',
					displayField: 'keyValue',
					valueField: 'key',
					mode: 'local', // ����ģʽ
					triggerAction: 'all',
					selectOnFocus: true,
					forceSelection: true
					//resizable:true
				});
			var AcctMonthEnd02 = new Ext.form.ComboBox({
					id: 'AcctMonthEnd02',
					fieldLabel: '�����·�',
					labelSeparator:'',
					width: 180,
					listWidth: 120,
					store: MonthDs02,
					valueNotFoundText: '',
					displayField: 'keyValue',
					valueField: 'key',
					mode: 'local', // ����ģʽ
					triggerAction: 'all',
					selectOnFocus: true,
					forceSelection: true
				});

			//----------------- ����δ����-----------------//
			var noaccount02 = new Ext.form.Checkbox({
					fieldLabel: '����δ����',
					labelSeparator:'',
					id: 'noaccount02',
					name: 'noaccount',
					style: 'border:0;background:none;margin-top:0px;',
					labelAlign: 'right'
				});

			//----------------- ���Ϊ0�ҷ�����Ϊ0-----------------//
			var nobalance02 = new Ext.form.Checkbox({
					fieldLabel: '���Ϊ0�ҷ�����Ϊ0����ʾ',
					labelSeparator:'',
					id: 'nobalance02',
					name: 'nobalance',
					style: 'border:0;background:none;margin-top:0px;',
					labelAlign: 'right'
				});

			//----------------- ��ʾĩ��-----------------//
			var lastLevel02 = new Ext.form.Checkbox({
					fieldLabel: 'ֻ��ʾĩ��',
					labelSeparator:'',
					id: 'lastLevel02',
					name: 'lastLevel',
					labelAlign: 'right',
					columnWidth: .5,
					style: 'border:0;background:none;margin-top:0px;',
					anchor: '90%'
				});

			//----------------- ��ʾ�ۼ�-----------------//
			var accumulative02 = new Ext.form.Checkbox({
					fieldLabel: '��ʾ�ۼ�',
					labelSeparator:'',
					id: 'accumulative02',
					name: 'accumulative',
					labelAlign: 'right',
					columnWidth: .5,
					style: 'border:0;background:none;margin-top:0px;',
					anchor: '90%'
				});
			//////////////��Ŀ�����ѯ����end///////////

			var frm = new Ext.form.FormPanel({

					labelAlign: 'right',
					title: '��ѯ����',
					iconCls:'find',
					width: 450,
					frame: true,
					region: 'east',
					labelWidth: 180,
					//buttonAlign: 'center',
					//closable: true, //������ԾͿ��Կ��ƹرո�from
					items: [{
							xtype: 'fieldset',
							items: [AcctSubjCodeStart02, AcctSubjCodeEnd02, SubjLevel02, AcctYear02, AcctMonthStrat02, AcctMonthEnd02, noaccount02, nobalance02, lastLevel02, accumulative02]
						}, {
							xtype: 'button',
							style: "margin-Left:45%;",
							//style:"margin:auto;",
							width: 55,
							iconCls: 'find',
							text: '��ѯ',
							handler: function () {
								FindQuery();
							}
						}
					]

				});
			//var CodeStr="";
			//var ConfigItems=[];
			SchemGrid.on('rowclick', function (grid, rowIndex, e) {

				//var object = SchemGrid.getSelectionModel().getSelections();
				//var code = object[0].get("code");

				var object = SchemGrid.getSelectionModel().getSelections();
				var id = object[0].get("rowid");
				if (id == "" || id == null || id == undefined) {
					SchemGrid.edit = true;
				} else {
					var code = object[0].get("code");
					var SchemDesc = object[0].get("desc");
					var arr = SchemDesc.split(";");
					//alert(SchemDesc);
					//alert(arr);
					AcctSubjCodeStart02.setValue(arr[0]);
					AcctSubjCodeEnd02.setValue(arr[1]);
					SubjLevel02.setValue(arr[2]);
					AcctYear02.setValue(arr[3]);
					AcctMonthStrat02.setValue(arr[4]);
					AcctMonthEnd02.setValue(arr[5]);
					//alert(arr[6]);
					if (arr[6] == 1) {
						noaccount02.setValue(true);
						// alert(noaccount);
					} else {
						noaccount02.setValue(false);
					}

					if (arr[7] == 1) {
						nobalance02.setValue(true);
					} else {
						nobalance02.setValue(false);
					}
					if (arr[8] == 1) {
						lastLevel02.setValue(true);
					} else {
						lastLevel02.setValue(false);
					}
					if (arr[9] == 1) {
						accumulative02.setValue(true);
					} else {
						accumulative02.setValue(false);
					}
				}

			});
			/*
			//�滻panel�е����
			function ChangeItems(code,TempItems){
			if(CodeStr!==""){
			for(var i=0;i<ConfigItems.length;i++){
			frm.remove(Ext.getCmp(CodeStr+'_Item'+i),false);
			Ext.getCmp(CodeStr+'_Item'+i).setVisible(false);
			}
			frm.doLayout();
			}
			CodeStr=code;
			ConfigItems=TempItems.slice();
			for(var j=0;j<ConfigItems.length;j++)
			frm.add(ConfigItems[j]);
			frm.doLayout();
			return;
			}
			 */
			//�ܰ�������panel����Ext.panel
			var fullForm = new Ext.Panel({
					//title: '��ѯ��������',
					closable: true,
					border: true,
					layout: 'border',
					items: [SchemGrid, frm]
				});

			/* formPanel = new Ext.Panel({
			baseCls : 'x-plain',
			//layout : 'fit',
			//labelWidth : 100,
			items : [SchemGrid]
			}); */
			var window = new Ext.Window({
					// title: '��ѯ��������',
					layout: 'fit',
					plain: true,
					width: 900,
					height: 500,
					modal: true,
					buttonAlign: 'center',
					items: fullForm,
					atLoad: true,
					buttons: [{
							text: '�ر�',
							iconCls:'cancel',
							handler: function () {
								window.close();
							}
						}
					]

				});

			window.show();

			function FindQuery() {

				var SubjCode1 = Ext.getCmp('AcctSubjCodeStart02').getRawValue();
				if (SubjCode1 != "") {
					var codename1 = SubjCode1.split(" ");
					var SubjCode1 = codename1[0];
				}
				var SubjCode2 = Ext.getCmp('AcctSubjCodeEnd02').getRawValue();
				if (SubjCode2 != "") {
					var codename2 = SubjCode2.split(" ");
					var SubjCode2 = codename2[0];
				}
				var level = Ext.getCmp('SubjLevel02').getValue();
				var year = Ext.getCmp('AcctYear02').getValue();
				var month1 = Ext.getCmp('AcctMonthStrat02').getValue();
				var month2 = Ext.getCmp('AcctMonthEnd02').getValue();
				var noaccount = Ext.getCmp('noaccount02').getValue();
				if (noaccount == true) {
					noaccount = 1;
				} else {
					noaccount = 0;
				}
				var nobalance = Ext.getCmp('nobalance02').getValue();
				if (nobalance == true) {
					nobalance = 1;
				} else {
					nobalance = 0;
				}
				var lastLevel = Ext.getCmp('lastLevel02').getValue();
				if (lastLevel == true) {
					lastLevel = 1;
				} else {
					lastLevel = 0;
				}
				var accumulative = Ext.getCmp('accumulative02').getValue();
				if (accumulative == true) {
					accumulative = 1;
				} else {
					accumulative = 0;
				}
				window.close();
				var reportFrame = document.getElementById("frameReport");
				var p_URL = "";
				//��ȡ����·��
				//userid_" "_ acctYear_" "_currentSub_" "_currentObj_" "_currentType_" "_isAcct
				p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.SubjectCurrencyBalance.raq&&subjstart=' + SubjCode1 + '&subjend=' + SubjCode2 +
					'&level=' + level + '&year=' + year + '&startMonth=' + month1 + '&endMonth=' + month2 +
					'&noaccount=' + noaccount + '&nobalance=' + nobalance + '&lastLevel=' + lastLevel + '&accumulative=' + accumulative + '&userdr=' + userdr;
				reportFrame.src = p_URL;
			}

		}
	});

formPanel = new Ext.form.FormPanel({
		id: 'formPanel',
		frame: true,
		//autoScroll : true,
		//layout : 'fit',
		items: [buttQuery]
	});
var reportPanel = new Ext.Panel({
		autoScroll: true,
		layout: 'fit',
		//autoScroll:false,
		html: '<iframe id="frameReport" height="100%" width="100%" frameborder="0" scrolling="auto" src="../scripts/herp/acct/images/logon_bg.jpg" />'

	});
