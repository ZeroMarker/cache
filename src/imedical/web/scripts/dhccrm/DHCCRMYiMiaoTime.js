Ext.onReady(function() {

	Ext.QuickTips.init();

	var sm = new Ext.grid.CheckboxSelectionModel();
	var mrbasecm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), sm, {
				header : "登记号",
				dataIndex : 'mRegno',
				sortable : true
			}, {
				header : "姓名",
				dataIndex : 'mrname'
			}, {
				header : "性别",
				dataIndex : 'mrgender',
				sortable : true
			}, {
				header : "年龄",
				dataIndex : 'mrage',
				sortable : true
			}, {
				header : "身份证号",
				dataIndex : 'mrcardid',
				width : 150
			}, {
				header : "联系电话",
				dataIndex : 'mrtel',
				width : 200
			}, {
				header : "联系地址",
				dataIndex : 'mraddress'
			}, {
				header : "下次注射日期",
				dataIndex : 'ymndate',
				editor : new Ext.form.DateField({
							format : 'Y-m-d'
						})
			}, {
				header : "下次疫苗",
				dataIndex : 'YMName'
			}, {
				header : "英文名称",
				dataIndex : 'YMNameEng'
			}, {
				header : "最后更新人",
				dataIndex : 'UpdateUser'
			}, {
				header : "最后更新日期",
				dataIndex : 'UpdateDate'
			}, {
				header : "发送状态",
				dataIndex : 'Status'
			}]);

	var mrbasestore = new Ext.data.Store({
				url : 'dhccrmyimiaotime1.csp?action=mrbaselist',
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : "rows"
						}, ['PapmiId', 'mRegno', 'mrname', 'mrgender', 'mrage',
								'mrcardid', 'mrtel', 'mraddress', 'ymndate',
								'YMName', 'ymid', 'UpdateUser', 'UpdateDate',
								'country', 'YMNameEng', 'ymtid', 'Status'])
			});

	var ColumnNum = new Ext.form.NumberField({
				fieldLabel : '显示行数',
				width : 40,
				id : 'ColumnNum'
			})
	var bbar = new Ext.PagingToolbar({
				pageSize : 100,
				store : mrbasestore
			});

	mrbasestore.load({
				params : {
					start : 0,
					limit : 20
				}
			});

	mrbasestore.on('beforeload', function() {
				var BDate = BeginDate.getValue();
				var EDate = EndDate.getValue();
				if (BDate != '') {
					BDate = BDate.format('Y-m-d').toString();
				}
				if (EDate != '') {
					EDate = EDate.format('Y-m-d').toString();
				}

				var PatName = Ext.getCmp('PatName').getValue();

				mrbasestore.proxy.conn.url = 'dhccrmyimiaotime1.csp?action=mrbaselist'
						+ "&BeginDate="
						+ BDate
						+ "&EndDate="
						+ EDate
						+ "&PatName=" + encodeURIComponent(PatName);

			});

	var PatName = new Ext.form.TextField({
				fieldLabel : '姓名',
				width : 150,
				id : 'PatName'
			})
	var PatNamePanel = new Ext.Panel({
				layout : 'form',
				columnWidth : 1 / 3,
				items : PatName,
				id : 'PatNamePanel',
				labelAlign : "right"
			})
	var BeginDate = new Ext.form.DateField({
				fieldLabel : '开始日期',
				width : 150,
				format : 'Y-m-d',
				id : 'BeginDate'
			})
	var BeginDatePanel = new Ext.Panel({
				layout : 'form',
				columnWidth : 1 / 3,
				items : BeginDate,
				id : 'BeginDatePanel',
				// width:120,
				labelAlign : "right"
			})
	var EndDate = new Ext.form.DateField({
				fieldLabel : '结束日期',
				width : 150,
				format : 'Y-m-d',
				id : 'EndDate'
			})
	var EndDatePanel = new Ext.Panel({
				layout : 'form',
				columnWidth : 1 / 3,
				id : 'EndDatePanel',
				items : EndDate,
				// width:120,
				labelAlign : "right"
			})

	var SMSTemplateC = new Ext.form.TextArea({

		fieldLabel : '中文短信模板',
		id : 'SMSTemplateC',
		name : 'SMSTemplateC',
		width : 250,
		value : tkMakeServerCall("web.DHCCRM.BirthdayRemind", "GetSMSTemplateC")
	})
	var SMSTemplateE = new Ext.form.TextArea({

		fieldLabel : '英文短信模板',
		id : 'SMSTemplateE',
		name : 'SMSTemplateE',
		width : 250,
		value : tkMakeServerCall("web.DHCCRM.BirthdayRemind", "GetSMSTemplateE")
	})
	var SMSTemplatePanelC = new Ext.Panel({

				layout : 'form',
				columnWidth : 1 / 2,
				id : 'SMSTemplatePanelC',
				items : SMSTemplateC,
				labelAlign : "right"

			})
	var SMSTemplatePanelE = new Ext.Panel({

				layout : 'form',
				columnWidth : 1 / 2,
				id : 'SMSTemplatePanelE',
				items : SMSTemplateE,
				labelAlign : "right"

			})
	var FindButton = new Ext.Button({
				text : '查询',
				iconCls : 'find',
				handler : Find_click
			})
	var Send_click = function() {
		alert('需要加载短信模块！');
		return

		var selectedRows = grid.getSelectionModel().getSelections();
		if (selectedRows.length == 0) {
			Ext.Msg.alert("提示", "请选择疫苗记录!");
			return;
		}
		for (i = 0; i < selectedRows.length; i++) {

			var ymtid = selectedRows[i].data.ymtid
			var RegNo = selectedRows[i].data.mRegno
			var tel = selectedRows[i].data.mrtel
			var country = selectedRows[i].data.country
			var mrname = selectedRows[i].data.mrname
			var YMName = ''
			var content = ''
			if (country == 1) {
				content = Ext.getCmp('SMSTemplateC').getValue()
				YMName = selectedRows[i].data.YMName
			} else {
				content = Ext.getCmp('SMSTemplateE').getValue()
				YMName = selectedRows[i].data.YMNameEng
			}
			content = content.replace('[Name]', mrname);
			content = content.replace('[YiMiao]', YMName);
			var urlcontent = encodeURIComponent(content)

			var str = ymtid + "^" + RegNo + "^" + tel + "^" + content + "^"
					+ urlcontent
			var ret = tkMakeServerCall("web.DHCCRM.CRMYiMiao", "SendYiMiaoSMS",
					str);

		}
		if (ret == 0) {
			alert('发送成功!');
			mrbasestore.load({
						params : {
							start : 0,
							limit : 20
						}
					})
		}
	}

	var SendButton = new Ext.Button({
				text : '发送短信',
				iconCls : 'upload',
				handler : Send_click
			})
	function Find_click() {

		mrbasestore.load({
					params : {
						start : 0,
						limit : 20
					}
				})
	}

	var FindButtonPanel = new Ext.Panel({
				layout : 'form',
				width : 100,
				id : 'FindButtonPanel',
				items : FindButton
			})
	var SendButtonPanel = new Ext.Panel({
				layout : 'form',
				width : 100,
				id : 'SendButtonPanel',
				items : SendButton
			})
	var DatePanel = new Ext.Panel({
				layout : 'column',
				defaults : {
					anchor : '90%'
				},
				items : [PatNamePanel, BeginDatePanel, EndDatePanel,
						SMSTemplatePanelC, SMSTemplatePanelE, FindButtonPanel,
						SendButtonPanel]
			})
	var queryinfo = new Ext.form.FormPanel({
				region : 'north',
				frame : true,
				height : 120,
				layout : 'form',
				items : [DatePanel]

			});

	var grid = new Ext.grid.EditorGridPanel({
				region : 'center',
				collapsible : true,
				viewConfig : {
					forceFit : true
				},
				store : mrbasestore,
				cm : mrbasecm,
				sm : sm,
				stripeRows : true,
				bbar : bbar
			});
	grid.on('rowclick', function(grid, rowIndex, event) {
				var record = grid.getStore().getAt(rowIndex);
				var PapmiId = record.get('PapmiId');
				var frm = parent.parent.parent.document.forms['fEPRMENU'];
				var frmEpisodeID = frm.EpisodeID;
				frmEpisodeID.value = 999999999;
				var frmPatientID = frm.PatientID;
				frmPatientID.value = PapmiId;

			});
	grid.on('afteredit', function(e) {

				var ymndate = '';
				if (typeof(e.record.get("ymndate")) == 'string') {
					ymndate = e.record.get("ymndate")
				} else {
					if (e.record.get("ymndate") != '')
						ymndate = e.record.get("ymndate").format('Y-m-d')
								.toString();
				}

				var ymid = e.record.get("ymid");

				var ret = tkMakeServerCall("web.DHCCRM.CRMYiMiao",
						"SaveYiMiaoByTime", ymid, ymndate);
				if (ret == 0)
					mrbasestore.load();

			});

	grid.on('celldblclick', function(grid, rowIndex, columnIndex, e) {
				if (columnIndex == 10) {
					var record = grid.getStore().getAt(rowIndex);
					var ymid = record.get('ymid');
					var comStore = new Ext.data.Store({
								url : 'dhccrmyimiaotime1.csp?action=comlist&ymid='
										+ ymid,
								reader : new Ext.data.JsonReader({
											totalProperty : "results",
											root : "rows"
										}, ['User', 'Date', 'NextDate'])
							});
					var comcm = new Ext.grid.ColumnModel([{

								header : '更新人',
								dataIndex : 'User'
							}, {

								header : '更新日期',
								dataIndex : 'Date'

							}, {

								header : '更新的下次日期',
								dataIndex : 'NextDate'

							}]);
					var comgrid = new Ext.grid.GridPanel({

								frame : true,
								viewConfig : {
									forceFit : true
								},
								store : comStore,
								cm : comcm

							});

					var addwindow = new Ext.Window({

								title : '更新记录',
								width : 800,
								height : 550,
								layout : 'fit',
								plain : true,
								modal : true,
								bodyStyle : 'padding:10px;',
								buttonAlign : 'center',
								items : [comgrid]
							});
					addwindow.show()
					comStore.load()
				}
			})

	var mrbasepanel = new Ext.Panel({
				region : 'center',
				title : '人员列表',
				layout : 'border',
				frame : true,
				items : [queryinfo, grid]
			});

	var mainPanel = new Ext.Viewport({
				layout : 'border',
				collapsible : true,
				items : [mrbasepanel]

			});

})
