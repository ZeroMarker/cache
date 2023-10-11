//// 账簿查询-科目余额表-数量金额式

//var bookID=IsExistAcctBook();

//var bookID= InitAcctBook();
var bookID = IsExistAcctBook();
var acctbookid = bookID; //勿删
var userdr = session['LOGON.USERID']; //登录人ID
//alert(userdr);
//=================================查询条件 FormPanel==========================//

var buttQuery = new Ext.Button({
		text: "查询",
		iconCls: 'find',
		width: 70,
		handler: function () { 
			//alert(bookID);

			////Schem	简历查询方案的grid
			var SchemGrid = new dhc.herp.Grid({
					title: '查询方案维护',
					iconCls:'maintain',
					region: 'center',
					url: 'herp.acct.subjectamountbalanceexe.csp',
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
							header: '<div style="text-align:center">账套id</div>',
							align: 'right',
							editable: false,
							width: 140,
							hidden: true,
							dataIndex: 'bookid'
						}, {
							id: 'code',
							header: '<div style="text-align:center">方案编号</div>',
							width: 50,
							align: 'left',
							allowBlank: false,
							dataIndex: 'code'

						}, {
							id: 'name',
							header: '<div style="text-align:center">方案名称</div>',
							width: 140,
							align: 'left',
							allowBlank: false,
							dataIndex: 'name'
						}, {
							id: 'desc',
							header: '方案描述',
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
			//SchemGrid.addButton('<div style="color:red">说明：科目余额表-数量金额式的方案编号以ZB0202开头。</div>');
			SchemGrid.btnResetHide() //隐藏重置按钮
			SchemGrid.btnPrintHide() //隐藏打印按钮
		
			//////////////科目余额表查询条件start///////////
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
						url: '../csp/herp.acct.subjectamountbalanceexe.csp?action=GetAcctSubj02&bookID=' + bookID + '&str=' + Ext.getCmp('AcctSubjCodeStart02').getRawValue(),
						method: 'POST'
					});
			});

			var AcctSubjCodeStart02 = new Ext.form.ComboBox({
					id: 'AcctSubjCodeStart02',
					fieldLabel: '会计科目起始',
					labelSeparator:'',
					store: SubjCodeDs02,
					valueField: 'subjCode',
					displayField: 'subjCodeNameAll',
					typeAhead: true,
					width: 180,
					listWidth: 270,
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
						url: '../csp/herp.acct.subjectamountbalanceexe.csp?action=GetAcctSubj02&bookID=' + bookID + '&str=' + Ext.getCmp('AcctSubjCodeEnd02').getRawValue(),
						method: 'POST'
					});
			});
			var AcctSubjCodeEnd02 = new Ext.form.ComboBox({
					id: 'AcctSubjCodeEnd02',
					fieldLabel: '会计科目结束',
					labelSeparator:'',
					store: SubjCodeEndDs02,
					valueField: 'subjCode',
					displayField: 'subjCodeNameAll',
					width: 180,
					listWidth: 270,
					triggerAction: 'all',
					pageSize: 10,
					minChars: 1,
					selectOnFocus: true,
					forceSelection: 'true'
				});

			///////////////科目级次///////////////////////

			var levelDs02 = new Ext.data.SimpleStore({
					fields: ['key', 'keyValue'],
					data: [['1', '1'], ['2', '2'], ['3', '3'], ['4', '4'],
						['5', '5'], ['6', '6'], ['7', '7'], ['8', '8']]
				});

			var SubjLevel02 = new Ext.form.ComboBox({
					id: 'SubjLevel02',
					fieldLabel: '科目级次',
					labelSeparator:'',
					width: 180,
					listWidth: 100,
					store: levelDs02,
					valueNotFoundText: '',
					displayField: 'keyValue',
					valueField: 'key',
					mode: 'local', // 本地模式
					triggerAction: 'all',
					selectOnFocus: true,
					forceSelection: true
				});

			/////////会计年度////////
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
						url: '../csp/herp.acct.subjectamountbalanceexe.csp?action=GetAcctYear&bookID=' + bookID + '&str=' + Ext.getCmp('AcctYear02').getRawValue(),
						method: 'POST'
					});
			});

			var AcctYear02 = new Ext.form.ComboBox({
					id: 'AcctYear02',
					fieldLabel: '会计年度',
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

			/////////会计月份////////
			var MonthDs02 = new Ext.data.SimpleStore({
					fields: ['key', 'keyValue'],
					data: [['01', '01月'], ['02', '02月'], ['03', '03月'], ['04', '04月'],
						['05', '05月'], ['06', '06月'], ['07', '07月'], ['08', '08月'],
						['09', '09月'], ['10', '10月'], ['11', '11月'], ['12', '12月']]
				});

			var AcctMonthStrat02 = new Ext.form.ComboBox({
					id: 'AcctMonthStrat02',
					fieldLabel: '开始月份',
					labelSeparator:'',
					width: 180,
					listWidth: 100,
					store: MonthDs02,
					valueNotFoundText: '',
					displayField: 'keyValue',
					valueField: 'key',
					mode: 'local', // 本地模式
					triggerAction: 'all',
					selectOnFocus: true,
					forceSelection: true
					//resizable:true
				});
			var AcctMonthEnd02 = new Ext.form.ComboBox({
					id: 'AcctMonthEnd02',
					fieldLabel: '结束月份',
					labelSeparator:'',
					width: 180,
					listWidth: 120,
					store: MonthDs02,
					valueNotFoundText: '',
					displayField: 'keyValue',
					valueField: 'key',
					mode: 'local', // 本地模式
					triggerAction: 'all',
					selectOnFocus: true,
					forceSelection: true
				});

			/*
			//----------------- 包含未记账-----------------//
			var VouchStateField = new Ext.form.Checkbox({
			fieldLabel : '包含未记账',
			id : 'VouchStateField',
			name : 'noaccount',
			labelAlign:'right'
			});

			//----------------- 余额为0且发生额为0-----------------//
			var EndSumFlagField = new Ext.form.Checkbox({
			fieldLabel : '余额为0且发生额为0',
			id : 'EndSumFlagField',
			name : 'nobalance',
			labelAlign:'right'
			});
			 */

			//------------包含未记账复选框-------------//
			var VouchStateField = new Ext.form.Checkbox({
					id: "VouchStateField",
					fieldLabel: '包含未记账',
					labelSeparator:'',
					inputValue: 1,
					style: 'border:0;background:none;margin-top:0px;',
					checked: false
				});

			//------------余额为零且发生额为零不显示复选框-------------//
			var EndSumFlagField = new Ext.form.Checkbox({
					id: "EndSumFlagField",
					fieldLabel: '余额为0且发生额为0不显示',
					labelSeparator:'',
					Alignment: 0,
					inputValue: 1,
					style: 'border:0;background:none;margin-top:0px;',
					checked: false
				});

			//----------------- 显示末级-----------------//
			var lastLevel02 = new Ext.form.Checkbox({
					fieldLabel: '只显示末级',
					id: 'lastLevel02',
					name: 'lastLevel',
					labelAlign: 'right',
					labelSeparator:'',
					columnWidth: .5,
					style: 'border:0;background:none;margin-top:0px;',
					anchor: '90%'
				});

			//----------------- 显示累计-----------------//
			var accumulative02 = new Ext.form.Checkbox({
					fieldLabel: '显示累计',
					id: 'accumulative02',
					name: 'accumulative',
					labelAlign: 'right',
					labelSeparator:'',
					columnWidth: .5,
					style: 'border:0;background:none;margin-top:0px;',
					anchor: '90%'
				});
			//////////////科目余额表查询条件end///////////

			var frm = new Ext.form.FormPanel({

					title: '查询条件',
					iconCls:'find',
					width: 450,
					// height:500,
					frame: true,
					region: 'east',
					labelWidth: 180,
					labelAlign: 'right',
					labelSeparator:'',
					//buttonAlign: 'center',
					//closable: true, //这个属性就可以控制关闭该from
					items: [{
							xtype: 'fieldset',
							items: [AcctSubjCodeStart02, AcctSubjCodeEnd02, SubjLevel02, AcctYear02, AcctMonthStrat02, AcctMonthEnd02, VouchStateField, EndSumFlagField, lastLevel02, accumulative02]
						}, {
							xtype: 'button',
							style: "margin-Left:45%;",
							width: 55,
							iconCls: 'find',
							text: '查询',
							handler: function () {
								FindQuery();
							}
						}
					]

				});

			SchemGrid.on('rowclick', function (grid, rowIndex, e) {

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

					/*
					if(arr[6]==1){
					noaccount02.setValue(true);
					// alert(noaccount);
					}else{
					noaccount02.setValue(false);
					}

					if(arr[7]==1){
					nobalance02.setValue(true);
					}else{
					nobalance02.setValue(false);
					}
					 */
					//包含为记账
					if (arr[6] == 1) {
						VouchStateField.setValue(1);
					} else {
						VouchStateField.setValue(0);
					}
					//余额为0且发生额为0
					if (arr[7] == 1) {
						EndSumFlagField.setValue(1);
					} else {
						EndSumFlagField.setValue(0);
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

			//替换panel中的组件
			function ChangeItems(code, TempItems) {
				if (CodeStr !== "") {
					for (var i = 0; i < ConfigItems.length; i++) {
						frm.remove(Ext.getCmp(CodeStr + '_Item' + i), false);
						Ext.getCmp(CodeStr + '_Item' + i).setVisible(false);
					}
					frm.doLayout();
				}
				CodeStr = code;
				ConfigItems = TempItems.slice();
				for (var j = 0; j < ConfigItems.length; j++)
					frm.add(ConfigItems[j]);
				frm.doLayout();
				return;
			}
			//能包含其他panel的是Ext.panel
			var fullForm = new Ext.Panel({
					//title: '查询方案管理',
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
					// title: '查询方案管理',
					layout: 'fit',
					plain: true,
					width: 900,
					height: 500,
					modal: true,
					buttonAlign: 'center',
					items: fullForm,
					buttons: [{
							text: '关闭',
							iconCls:'cancel',
							handler: function () {
								window.close();
							}
						}
					]

				});
			window.show();

			function FindQuery(code) {
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
				/*var noaccount=Ext.getCmp('noaccount02').getValue();//包含为记账
				if(noaccount==true){
				noaccount=1;
				}else{
				noaccount=0;
				}
				var nobalance=Ext.getCmp('nobalance02').getValue();//余额为0且发生额为0
				if(nobalance==true){
				nobalance=1;
				}else{
				nobalance=0;
				}*/
				var VouchState = VouchStateField.getValue();
				if (VouchState == "")
					VouchState = 0;
				else
					VouchState = 1;
				var EndSumFlag = EndSumFlagField.getValue();
				if (EndSumFlag == "")
					EndSumFlag = 0;
				else
					EndSumFlag = 1;
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
				//获取报表路径

				//userid_" "_ acctYear_" "_currentSub_" "_currentObj_" "_currentType_" "_isAcct
				/*p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.SubjectAmountBalance.raq&&subjstart='+SubjCode1+'&subjend='+SubjCode2+
				'&level='+level+'&year='+year+'&startMonth='+month1+'&endMonth='+month2+
				'&noaccount='+noaccount+'&nobalance='+nobalance+'&lastLevel='+lastLevel+'&accumulative='+accumulative+'&userdr='+userdr;
				 */
				p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.SubjectAmountBalance.raq&&AcctSubjCode1=' + SubjCode1 + '&AcctSubjCode2=' + SubjCode2 +
					'&SubjLevel=' + level + '&Year=' + year + '&startMonth=' + month1 + '&endMonth=' + month2 +
					'&VouchState=' + VouchState + '&EndSumFlag=' + EndSumFlag + '&lastLevel=' + lastLevel +
					'&accumulative=' + accumulative + '&userdr=' + userdr;

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
