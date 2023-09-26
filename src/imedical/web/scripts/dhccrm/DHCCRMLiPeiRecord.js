Ext.onReady(function() {

	Ext.QuickTips.init();
	var sm = new Ext.grid.CheckboxSelectionModel({
				handleMouseDown : Ext.emptyFn
			});
	var PatStore = new Ext.data.Store({
				url : 'dhccrmlipeirecord1.csp?actiontype=patlist',
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : "rows",
							id : 'PAADM'
						}, ['PAADM', 'PatNo', 'Name', 'AdmDate', 'Doc',
								'Insuer', 'InvAmount', 'Diagnosis', 'PAPMI'])
			})

	var lpstore = new Ext.data.Store({

				url : 'dhccrmlipeirecord1.csp?actiontype=lplist',

				reader : new Ext.data.JsonReader({

							totalProperty : 'results',
							root : 'rows',
							id : 'lprowid'
						}, [{
									name : 'lprowid'
								}, {
									name : 'LPPatNo'
								}, {
									name : 'LPPatName'
								}, {
									name : 'LPPAADM'
								}, {
									name : 'LPADMDate'
								}, {
									name : 'LPDiagnosis'
								}, {
									name : 'LPInvAmount'
								}, {
									name : 'LPDocName'
								}, {
									name : 'LPInsurer'
								}, {
									name : 'LPDedAmount'
								}, {
									name : 'LPCoAmount'
								}, {
									name : 'LPNCAmount'
								}, {
									name : 'LPUserName'
								}, {
									name : 'LPDate'
								}, {
									name : 'LPFactDedAmount'
								}, {
									name : 'LPDedUserName'
								}, {
									name : 'LPDedDate'
								}, {
									name : 'LPFactCoAmount'
								}, {
									name : 'LPCoUserName'
								}, {
									name : 'LPCoDate'
								}, {
									name : 'LPFactNCAmount'
								}, {
									name : 'LPNCUserName'
								}, {
									name : 'LPNCDate'
								}, {
									name : 'LPRemark'
								}, {
									name : 'LPPatAmount'
								}, {
									name : 'LPPatFactAmout'
								}, {
									name : 'LPFactUserName'
								}, {
									name : 'LPFactDate'
								}, {
									name : 'LPEqual'
								}, {
									name : 'LPEqualUserName'
								}, {
									name : 'LPEqualDate'
								}])

			});
	var patcm = new Ext.grid.ColumnModel([{

				header : 'PAADM',
				dataIndex : 'PAADM'
			}, {

				header : 'PAPMI',
				dataIndex : 'PAPMI'
			}, {

				header : '登记号',
				dataIndex : 'PatNo'
			}, {

				header : '姓名',
				dataIndex : 'Name'

			}, {

				header : '就诊日期',
				dataIndex : 'AdmDate'

			}, {

				header : '诊断',
				dataIndex : 'Diagnosis'

			}, {

				header : '医生',
				dataIndex : 'Doc'

			}, {

				header : '保险公司',
				dataIndex : 'Insuer'

			}, {

				header : '账单金额',
				dataIndex : 'InvAmount'

			}]);
	Ext.grid.CheckColumn = function(config) {
		Ext.apply(this, config);
		if (!this.id) {
			this.id = Ext.id();
		}
		this.renderer = this.renderer.createDelegate(this);
	};

	Ext.grid.CheckColumn.prototype = {
		init : function(grid) {
			this.grid = grid;
			this.grid.on('render', function() {
						var view = this.grid.getView();
						view.mainBody.on('mousedown', this.onMouseDown, this);
					}, this);
		},
		onMouseDown : function(e, t) {
			if (t.className
					&& t.className.indexOf('x-grid3-cc-' + this.id) != -1) {
				e.stopEvent();
				var index = this.grid.getView().findRowIndex(t);
				var cindex = this.grid.getView().findCellIndex(t);
				var record = this.grid.store.getAt(index);
				var field = this.grid.colModel.getDataIndex(cindex);
				var e = {
					grid : this.grid,
					record : record,
					field : field,
					originalValue : record.data[this.dataIndex],
					value : !record.data[this.dataIndex],
					row : index,
					column : cindex,
					cancel : false
				};
				if (this.grid.fireEvent("validateedit", e) !== false
						&& !e.cancel) {
					delete e.cancel;
					record.set(this.dataIndex, !record.data[this.dataIndex]);
					this.grid.fireEvent("afteredit", e);
				}
			}
		},
		renderer : function(v, p, record) {
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col' + (v ? '-on' : '')
					+ ' x-grid3-cc-' + this.id + '"> </div>';
		}
	};
	var checkColumn = new Ext.grid.CheckColumn({
				header : $g("平账"),
				dataIndex : 'LPEqual'
			});
	var lpcm = new Ext.grid.ColumnModel([{

				header : 'lprowid',
				dataIndex : 'lprowid',
				hidden : true
			}, {

				header : '登记号',
				dataIndex : 'LPPatNo'
			}, {

				header : '姓名',
				dataIndex : 'LPPatName'

			}, {

				header : 'LPPAADM',
				dataIndex : 'LPPAADM',
				hidden : true

			}, {

				header : '就诊日期',
				dataIndex : 'LPADMDate'

			}, {

				header : '诊断',
				dataIndex : 'LPDiagnosis'

			}, {

				header : '医生',
				dataIndex : 'LPDocName'

			}, {

				header : '保险公司',
				dataIndex : 'LPInsurer'

			}, {

				header : '账单金额',
				dataIndex : 'LPInvAmount'

			}, {

				header : '病人应付',
				dataIndex : 'LPPatAmount',
				editor : new Ext.form.NumberField()

			}, {

				header : '创建人',
				dataIndex : 'LPUserName'

			}, {

				header : '创建日期',
				dataIndex : 'LPDate'

			}, {

				header : '病人实付',
				dataIndex : 'LPPatFactAmout',
				editor : new Ext.form.NumberField()

			}, {

				header : '更新人',
				dataIndex : 'LPFactUserName'

			}, {

				header : '更新日期',
				dataIndex : 'LPFactDate'

			}, checkColumn, {

				header : '平账人',
				dataIndex : 'LPEqualUserName'

			}, {

				header : '平账日期',
				dataIndex : 'LPEqualDate'

			}, {

				header : '备注',
				dataIndex : 'LPRemark',
				editor : new Ext.form.TextArea()
			}]);

	var sm = new Ext.grid.CheckboxSelectionModel();

	var invform = new Ext.grid.GridPanel({

				region : 'center',
				frame : true,
				viewConfig : {
					forceFit : true
				},
				store : PatStore,
				cm : patcm,
				sm : sm

			});
	var queryinfo = new Ext.form.FormPanel({
		region : 'north',
		frame : true,
		height : 220,
		layout : 'form',
		autoHeight : true,
		items : [{
			xtype : 'textfield',
			fieldLabel : '登记号',
			columnWidth : 1 / 2,
			id : 'patno',
			name : 'patno',
			listeners : {
				'specialkey' : function(obj, e) {
					if (e.getKey() == e.ENTER) {
						PatStore.proxy.conn.url = 'dhccrmlipeirecord1.csp?actiontype=patlist&patno='
								+ Ext.getCmp('patno').getValue();
						PatStore.load({});
					}
					var count = PatStore.getCount()
					Ext.getCmp('patno').focus(true, true);
				}
			}

		}]

	});
	findPatList = function() {

		lpstore.load({
					params : {
						start : 0,
						limit : lpbbar.pageSize
					}
				});
	};
	var lpform = new Ext.form.FormPanel({
		region : 'north',
		height : 90,
		frame : true,
		labelWidth : 100,
		layout : 'column',
		items : [{
					columnWidth : 1 / 4,
					layout : 'form',
					items : [{
								fieldLabel : '登记号',
								id : 'papmino',
								xtype : 'textfield',
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											findPatList();
										}
									}
								}
							}]
				}, {
					columnWidth : 1 / 4,
					layout : 'form',
					items : [{
								fieldLabel : '创建人',
								id : 'lpuser',
								xtype : 'textfield',
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											findPatList();
										}
									}
								}
							}]
				}, {
					columnWidth : 1 / 4,
					layout : 'form',
					items : [{
								fieldLabel : '保险公司',
								id : 'lpinsuer',
								xtype : 'textfield',
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											findPatList();
										}
									}
								}
							}]
				}, {
					columnWidth : 1 / 4,
					layout : 'form',
					items : [{
								fieldLabel : '医生',
								id : 'doctor',
								xtype : 'textfield',
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											findPatList();
										}
									}
								}
							}]
				}, {
					columnWidth : 1 / 4,
					layout : 'form',
					items : [{
								fieldLabel : '就诊开始日期',
								width : 125,
								id : 'patstartdate',
								xtype : 'datefield'
							}]
				}, {
					columnWidth : 1 / 4,
					layout : 'form',
					items : [{
								fieldLabel : '就诊结束日期',
								width : 125,
								id : 'patenddate',
								xtype : 'datefield'
							}]
				}, {

					columnWidth : 1 / 4,
					layout : 'form',
					xtype : 'checkbox',
					boxLabel : '有欠款',
					id : 'HadAmount',
					name : 'HadAmount'
				}, {

					columnWidth : 1 / 16,
					layout : 'form',
					xtype : 'tbbutton',
					text : '查询',
					handler : findPatList
				}]

	});
	var window = new Ext.Window({

				title : '账单信息',
				width : 1200,
				height : 550,
				layout : 'border',
				plain : true,
				modal : true,
				closeAction : 'hide',
				bodyStyle : 'padding:10px;',
				buttonAlign : 'center',
				items : [queryinfo, invform]
			});

	function AddLiPei() {

		window.show();

	}
	window.on('show', function(e) {

				Ext.getCmp('patno').focus(true, true);

			})
	var lptbar = new Ext.Toolbar({

				items : [{
							xtype : 'tbbutton',
							text : '新增一条记录',
							id : 'addlp',
							handler : AddLiPei
						}]
			})
	var lpbbar = new Ext.PagingToolbar({
				displayInfo : true,
				displayMsg : '当前显示{0} - {1},共计{2}',
				emptyMsg : "没有数据",
				pageSize : 25,
				store : lpstore
			});
	var lpgrid = new Ext.grid.EditorGridPanel({

				region : 'center',
				frame : true,
				viewConfig : {
					forceFit : true
				},
				plugins : [checkColumn],
				store : lpstore,
				cm : lpcm,
				sm : sm,
				tbar : lptbar,
				stripeRows : true,
				bbar : lpbbar
			});

	lpstore.on('beforeload', function() {
				var papmino = Ext.getCmp('papmino').getValue();
				var lpuser = Ext.getCmp('lpuser').getValue();
				var lpinsuer = Ext.getCmp('lpinsuer').getValue();
				var doctor = Ext.getCmp('doctor').getValue();
				var HadAmount = Ext.getCmp('HadAmount').getValue();

				var patstartdate = '';
				if (Ext.getCmp('patstartdate').getValue() != '') {
					patstartdate = Ext.getCmp('patstartdate').getValue()
							.format('Y-m-d').toString();
				}
				var patenddate = '';
				if (Ext.getCmp('patenddate').getValue() != '') {
					patenddate = Ext.getCmp('patenddate').getValue()
							.format('Y-m-d').toString();
				}

				lpstore.proxy.conn.url = 'dhccrmlipeirecord1.csp?actiontype=lplist'
						+ '&papmino='
						+ papmino
						+ '&lpuser='
						+ lpuser
						+ '&lpinsuer='
						+ lpinsuer
						+ '&doctor='
						+ doctor
						+ '&HadAmount='
						+ HadAmount
						+ '&StartDate='
						+ patstartdate + '&EndDate=' + patenddate;

			});
	lpgrid.on('afteredit', function(e) {

				var lprowid = e.record.get("lprowid");
				var LPPatAmount = e.record.get("LPPatAmount");
				var LPPatFactAmout = e.record.get("LPPatFactAmout");
				var LPRemark = e.record.get("LPRemark");
				var LPEqual = e.record.get("LPEqual");
				var LPInstring = lprowid + "^" + LPPatAmount + "^"
						+ LPPatFactAmout + "^" + LPRemark + "^" + LPEqual;

				var ret = tkMakeServerCall("web.DHCCRM.CRMLiPei", "SaveLiPei",
						LPInstring);

				if (ret == 0) {
					var start = lpbbar.cursor;
					lpstore.load({

								params : {
									start : start,
									limit : lpbbar.pageSize
								}
							});
				}

			});
	invform.on('rowdblclick', function(grid, rowIndex, e) {

				var record = grid.getStore().getAt(rowIndex);
				var paadm = record.get('PAADM')
				var papmi = record.get('PAPMI')
				var ret = tkMakeServerCall("web.DHCCRM.CRMLiPei",
						"InsertNewRecord", paadm, papmi)
				if (ret == 0) {
					window.hide();
					lpstore.load({
								params : {
									start : 0,
									limit : lpbbar.pageSize
								}
							});
				}
			})
	lpgrid.on('celldblclick', function(grid, rowIndex, columnIndex, e) {

				if (columnIndex == 1) {
					var record = grid.getStore().getAt(rowIndex);
					var lprowid = record.get('lprowid')
					var lppatno = record.get('LPPatNo')

					var Template = "";
					var obj = document.getElementById("File")
					if (obj) {
						obj.click();
						Template = obj.value;
						obj.outerHTML = obj.outerHTML; // 清空选择文件名称
					}
					if (Template == "")
						return false;
					var extend = Template.substring(Template.lastIndexOf(".")
							+ 1);
					var filename = Template.substring(Template
									.lastIndexOf("\\")
									+ 1, Template.lastIndexOf("."));
					var FTPArr = PhotoFtpInfo.split("^");

					PEImgPhoto.FileName = Template; // 保存图片的名称包括后缀

					PEImgPhoto.DBFlag = "0" // 是否保存到数据库 0 1
					PEImgPhoto.FTPFlag = "1" // 是否保存到FTP 0 1
					PEImgPhoto.AppName = "DHCCRMLiPei/LP" + lprowid + "No"
							+ lppatno + "/";// ftp目录
					PEImgPhoto.FTPString = FTPArr[0] + "^" + FTPArr[1] + "^"
							+ FTPArr[2] + "^" + FTPArr[3] // FTP服务器

					PEImgPhoto.PatientID = filename// PAADM表的ID

					PEImgPhoto.SaveFile(extend) // 对于已经存在图片保存到数据库同时上传FTP的标志有效
					alert("上传成功!")
				}
				if (columnIndex == 2) {

				}
			})
	lpstore.on('load', function(s, records) {

		var girdcount = 0;
		s.each(function(r) {
			lpgrid.getView().getCell(girdcount, 1).style.backgroundColor = '#A6A6D2';
			lpgrid.getView().getCell(girdcount, 9).style.backgroundColor = '#FF8000';
			lpgrid.getView().getCell(girdcount, 12).style.backgroundColor = '#FF8000';
			girdcount = girdcount + 1;
		});
	})
	var main = new Ext.Viewport({
				layout : 'border',
				collapsible : true,
				items : [lpform, lpgrid]
			});
	lpstore.load({
				params : {
					start : 0,
					limit : lpbbar.pageSize
				}
			});
})