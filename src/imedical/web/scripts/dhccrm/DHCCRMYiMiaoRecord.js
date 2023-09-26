Ext.onReady(function() {

	Ext.QuickTips.init();

	var khstore = new Ext.data.Store({

				url : 'dhccrmyimiaorecord1.csp?actiontype=list&patientID='
						+ patientID,

				reader : new Ext.data.JsonReader({

							totalProperty : 'results',
							root : 'rows',
							id : 'RegNo'

						}, [{
									name : 'RegNo'
								}, {
									name : 'Name'
								}, {
									name : 'Sex'
								}, {
									name : 'Birth'
								}, {
									name : 'Age'
								}, {
									name : 'hometel'
								}, {
									name : 'worktel'
								}, {
									name : 'MobPhone'
								}])

			});
	var ymstore = new Ext.data.Store({

				url : 'dhccrmyimiaorecord1.csp?actiontype=ymlist&patientID='
						+ patientID,
				reader : new Ext.data.JsonReader({

							totalProperty : 'results',
							root : 'rows',
							id : 'ymid'

						}, [{
									name : 'ymid'
								}, {
									name : 'ymcode'
								}, {
									name : 'ymdesc'
								}, {
									name : 'ymnum'
								}, {
									name : 'ymsite'
								}, {
									name : 'ymdose'
								}, {
									name : 'ymmf'
								}, {
									name : 'ymltno'
								}, {
									name : 'ymremark'
								}, {
									name : 'ymseq'
								}, {
									name : 'ymgdate'
								}, {
									name : 'ymisgiven'
								}, {
									name : 'ymuser'
								}, {
									name : 'ymndate'
								}, {
									name : 'ymbid'
								}, {
									name : 'shuser'
								}, {
									name : 'ymstatus'
								}, {
									name : 'ZhiXing'
								}, {
									name : 'ShenHe'
								}, {
									name : 'ymway'
								}, {
									name : 'ymguser'
								}])

			});
	var khcm = new Ext.grid.ColumnModel([{

				header : $g('登记号'),
				dataIndex : 'RegNo'
			}, {
				header : $g('姓名'),
				dataIndex : 'Name'
			}, {
				header : $g('性别'),
				dataIndex : 'Sex'
			}, {
				header : $g('出生日期'),
				dataIndex : 'Birth'
			}, {
				header : $g('年龄'),
				dataIndex : 'Age'
			}, {
				header : $g('家庭电话'),
				dataIndex : 'hometel'
			}, {
				header : $g('工作电话'),
				dataIndex : 'worktel'
			}, {
				header : $g('移动电话'),
				dataIndex : 'MobPhone'
			}]);
	var fuICDstore = new Ext.data.Store({
				url : 'dhccrmsetplan1.csp?action=fuICDlist',
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : "rows"
						}, ['RowID', 'Name'])
			})

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

	var SiteStore = new Ext.data.Store({
				url : 'dhccrmyimiaorecord1.csp?actiontype=sitelist',
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : "rows"
						}, ['id', 'site'])
			})

	SiteStore.on('beforeload', function() {

		var record = Ext.getCmp('ymgrid').getSelectionModel().getSelected();
		var bid = record.get('ymbid');
		
		SiteStore.proxy.conn.url = 'dhccrmyimiaorecord1.csp?actiontype=sitelist'
				+ '&bid=' + bid;
	});

	var checkColumn = new Ext.grid.CheckColumn({
				header : $g("外院接种"),
				dataIndex : 'ymisgiven'
			});
	var checkColumn1 = new Ext.grid.CheckColumn({
				header : $g("执行"),
				dataIndex : 'ZhiXing'
			});
	var checkColumn2 = new Ext.grid.CheckColumn({
				header : $g("审核"),
				dataIndex : 'ShenHe'
			});
	var sm = new Ext.grid.CheckboxSelectionModel();
	var ymcm = new Ext.grid.ColumnModel([{
				header : 'ymid',
				dataIndex : 'ymid',
				hidden : true
			}, {
				header : 'ymbid',
				dataIndex : 'ymbid',
				hidden : true
			}, {
				header : $g('英文名'),
				dataIndex : 'ymcode'
			}, {
				header : $g('中文名'),
				dataIndex : 'ymdesc',
				width : 200
			}, {
				header : $g('针次'),
				dataIndex : 'ymnum',
				editor : new Ext.form.NumberField({})
			}, {
				header : $g('备注'),
				dataIndex : 'ymremark',
				editor : new Ext.form.TextField({})
			}, checkColumn, {
				header : $g('签字'),
				dataIndex : 'ymguser'
			}, {
				header : $g('接种日期'),
				dataIndex : 'ymgdate',
				// renderer : Ext.util.Format.dateRenderer('Y-m-d'),
				editor : new Ext.form.DateField({
							format : 'Y-m-d'
						})
			}, {
				header : $g('部位'),
				dataIndex : 'ymsite',
				editor : new Ext.form.ComboBox({
							id : 'sitecombo',
							store : SiteStore,
							valueField : 'id',
							displayField : 'site',
							triggerAction : 'all',
							listeners : {
								"focus" : function(combo, store, index) {
											SiteStore.load();
								}
							}

						})
			}, {
				header : $g('方式'),
				dataIndex : 'ymway',
				editor : new Ext.form.TextField({})
			}, {
				header : $g('剂量'),
				dataIndex : 'ymdose',
				editor : new Ext.form.TextField({})
			}, {
				header : $g('厂家'),
				dataIndex : 'ymmf',
				editor : new Ext.form.TextField({})
			}, {
				header : $g('批号'),
				dataIndex : 'ymltno',
				editor : new Ext.form.TextField({})
			}, {
				header : $g('下次日期'),
				dataIndex : 'ymndate',
				// renderer : Ext.util.Format.dateRenderer('Y-m-d'),
				editor : new Ext.form.DateField({
							format : 'Y-m-d'
						})
			}, checkColumn1, {
				header : $g('执行签字'),
				dataIndex : 'ymuser'
			}, checkColumn2, {
				header : $g('审核签字'),
				dataIndex : 'shuser'
			}, {
				header : $g('顺序'),
				dataIndex : 'ymseq',
				editor : new Ext.form.NumberField({
							allowBlank : false
						})
			}]);

	function InsertYiMiao() {
		var ret = tkMakeServerCall("web.DHCCRM.CRMYiMiao", "InsertYiMiao",
				patientID);

		if (ret == 0)
			ymstore.load({
						params : {
							start : 0,
							limit : ymbbar.pageSize
						}
					});
		else {
			alert(ret)
		}
	}
	function InsertYiMiaoBC() {
		var ret = tkMakeServerCall("web.DHCCRM.CRMYiMiao", "InsertYiMiaoBC",
				patientID);

		if (ret == 0)
		{
			var start = ymbbar.cursor;
			ymstore.load({
						params : {
							start : start,
							limit : ymbbar.pageSize
						}
					});
		}
		else {
			alert(ret)
		}
	}
	var ymtbar = new Ext.Toolbar({

				items : [{
							xtype : 'tbbutton',
							text : $g('新增一条记录'),
							id : 'addicd',
							iconCls : 'add',
							handler : AddYiMiao
						}, {
							xtype : 'tbbutton',
							text : $g('初始化'),
							id : 'insertym',
							iconCls : 'reset',
							handler : InsertYiMiao
						}, {
							xtype : 'tbbutton',
							text : $g('补充疫苗'),
							id : 'insertymbc',
							iconCls : 'update',
							handler : InsertYiMiaoBC
						}]
			})
	var khgrid = new Ext.grid.GridPanel({

				region : 'north',
				height : 70,
				frame : true,
				viewConfig : {
					forceFit : true
				},
				store : khstore,
				cm : khcm

			});

	var ymbbar = new Ext.PagingToolbar({
				displayInfo : true,
				displayMsg : '当前显示{0} - {1},共计{2}',
				emptyMsg : "没有数据",
				pageSize : 25,
				store : ymstore
			});

	var ymgrid = new Ext.grid.EditorGridPanel({
				id : 'ymgrid',
				sm : sm,
				region : 'center',
				frame : true,
				plugins : [checkColumn, checkColumn1, checkColumn2],
				viewConfig : {
					forceFit : true
				},
				store : ymstore,
				cm : ymcm,
				tbar : ymtbar,
				bbar : ymbbar

			});
	function AddYiMiao() {
		var record = Ext.getCmp('ymgrid').getSelectionModel().getSelected();
		var rowIndex = ymgrid.store.indexOf(ymgrid.getSelectionModel()
				.getSelected());
		if (rowIndex < 0)
			alert("请先初始化数据或点击需要增加数据的行!")
		var row = new Ext.data.Record({
					ymid : '',
					ymbid : record.get('ymbid'),
					ymcode : record.get('ymcode'),
					ymdesc : record.get('ymdesc'),
					ymnum : parseInt(record.get('ymnum')) + 1,
					ymgdate : '',
					ymisgiven : '',
					ymsite : record.get('ymsite'),
					ymdose : record.get('ymdose'),
					ymmf : record.get('ymmf'),
					ymltno : record.get('ymltno'),
					ymndate : '',
					ymuser : '',
					ymway : record.get('ymway'),
					ymremark : record.get('ymremark'),
					ymseq : parseInt(record.get('ymseq')) + 1
				});
		ymgrid.stopEditing();
		ymstore.insert(rowIndex + 1, row);
		ymgrid.startEditing(0, 0);

	}
	function getNowFormatDate() {
		var date = new Date();
		var seperator1 = "-";
		var seperator2 = ":";
		var year = date.getFullYear();
		var month = date.getMonth() + 1;
		var strDate = date.getDate();
		if (month >= 1 && month <= 9) {
			month = "0" + month;
		}
		if (strDate >= 0 && strDate <= 9) {
			strDate = "0" + strDate;
		}
		var currentdate = year + seperator1 + month + seperator1 + strDate;
		return currentdate;
	}
	ymstore.on('load', function(s, records) {
		var mydate = getNowFormatDate();
		var girdcount = 0;
		s.each(function(r) {
			var ymgdate = '';
			if (typeof(r.get("ymgdate")) == 'string') {
				ymgdate = r.get("ymgdate")
			} else {
				if (r.get("ymgdate") != '')
					ymgdate = e.record.get("ymgdate").format('Y-m-d')
							.toString();
			}
			if (r.get("ymbid") % 2 == 1)
				ymgrid.getView().getRow(girdcount).style.backgroundColor = '#BBFFBB';
			if (ymgdate == mydate) {
				ymgrid.getView().getRow(girdcount).style.backgroundColor = '#FFFF00';
			}

			girdcount = girdcount + 1;
		});
	})
	ymgrid.on('afteredit', function(e) {

				var ymid = e.record.get("ymid");
				var ymbid = e.record.get("ymbid");
				var ymcode = e.record.get("ymcode");
				var ymdesc = e.record.get("ymdesc");
				var ymnum = e.record.get("ymnum");
				var ymsite = e.record.get("ymsite");
				var ymdose = e.record.get("ymdose");
				var ymmf = e.record.get("ymmf");
				var ymltno = e.record.get("ymltno");
				var ymremark = e.record.get("ymremark");
				var ymseq = e.record.get("ymseq");
				var ymgdate = '';
				if (typeof(e.record.get("ymgdate")) == 'string') {
					ymgdate = e.record.get("ymgdate")
				} else {
					if (e.record.get("ymgdate") != '')
						ymgdate = e.record.get("ymgdate").format('Y-m-d')
								.toString();
				}

				var ymndate = '';
				if (typeof(e.record.get("ymndate")) == 'string') {
					ymndate = e.record.get("ymndate")
				} else {
					if (e.record.get("ymndate") != '')
						ymndate = e.record.get("ymndate").format('Y-m-d')
								.toString();
				}
				var ymisgiven = e.record.get("ymisgiven");
				var ymseq = e.record.get("ymseq");
				var ZhiXing = e.record.get("ZhiXing");
				
				var ShenHe = e.record.get("ShenHe");
				var ymway = e.record.get("ymway");
				
				if((ShenHe)&&(!ZhiXing)){

					var start = ymbbar.cursor;
					ymstore.load({
							params : {
								start : start,
								limit : ymbbar.pageSize
							}
						});
					return
				}
				
				
				
				if (ymid) {
				} else
					ymid = '';
				
				var oldret = tkMakeServerCall("web.DHCCRM.CRMYiMiao",
						"GetOldInfo", ymid);
				var oldstatus=oldret.split('^')[2]
				var oldzxuser=oldret.split('^')[0]
				if((oldstatus=='S')&&(ShenHe)){

					var start = ymbbar.cursor;
					ymstore.load({
							params : {
								start : start,
								limit : ymbbar.pageSize
							}
						});
					return
				}
				if((oldstatus=='E')&&(ZhiXing)&&(!ShenHe)&&(oldzxuser!=session['LOGON.USERID'])){

					var start = ymbbar.cursor;
					ymstore.load({
							params : {
								start : start,
								limit : ymbbar.pageSize
							}
						});
					return
				}
				
				var YMInstring = ymid + "^" + ymbid + "^" + ymcode + "^"
						+ ymdesc + "^" + ymnum + "^" + ymgdate + "^"
						+ ymisgiven + "^" + ymsite + "^" + ymdose + "^" + ymmf
						+ "^" + ymltno + "^" + ymremark + "^" + ymndate + "^"
						+ patientID + "^" + ymseq + "^" + ZhiXing + "^"
						+ ShenHe + "^" + ymway
				
				var ret = tkMakeServerCall("web.DHCCRM.CRMYiMiao",
						"SaveYiMiao", ymid, YMInstring);

				if (ret == 0)
					var start = ymbbar.cursor;
				ymstore.load({
							params : {
								start : start,
								limit : ymbbar.pageSize
							}
						});

			});

	var main = new Ext.Viewport({

				layout : 'border',
				collapsible : true,
				items : [khgrid, ymgrid]
			});
	khstore.load();
	ymstore.load({
				params : {
					start : 0,
					limit : ymbbar.pageSize
				}
			});
})