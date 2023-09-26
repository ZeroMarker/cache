Ext.onReady(function() {

			Ext.QuickTips.init();

			var ymstore = new Ext.data.Store({

						url : 'dhccrmyimiaobase1.csp?actiontype=ymlist',

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
											name : 'ymcount'
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
											name : 'ymway'
										}, {
											name : 'ymactive'
										}])

					});
					
					
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
								view.mainBody.on('mousedown', this.onMouseDown,
										this);
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
							record.set(this.dataIndex,
									!record.data[this.dataIndex]);
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
			
			var checkColumn1 = new Ext.grid.CheckColumn({
						header : "激活",
						dataIndex : 'ymactive'
					});
					
			
			var ymcm = new Ext.grid.ColumnModel([{

						header : 'ymid',
						dataIndex : 'ymid'

					}, {

						header : '英文名',
						dataIndex : 'ymcode',
						editor : new Ext.form.TextField({
									allowBlank : false
								})
					}, {

						header : '中文名',
						dataIndex : 'ymdesc',
						editor : new Ext.form.TextField({
									allowBlank : false
								})

					}, {

						header : '针次',
						dataIndex : 'ymcount',
						editor : new Ext.form.NumberField({
									allowBlank : false
								})

					}, {

						header : '部位',
						dataIndex : 'ymsite',
						editor : new Ext.form.TextField({
									allowBlank : false
								})

					}, {

						header : '方式',
						dataIndex : 'ymway',
						editor : new Ext.form.TextField({
									allowBlank : false
						})

					}, {

						header : '剂量',
						dataIndex : 'ymdose',
						editor : new Ext.form.TextField({
									allowBlank : false
								})

					}, {

						header : '厂家',
						dataIndex : 'ymmf',
						editor : new Ext.form.TextField({
									allowBlank : false
								})

					}, {

						header : '批号',
						dataIndex : 'ymltno',
						editor : new Ext.form.TextField({
									allowBlank : false
								})

					}, {

						header : '备注',
						dataIndex : 'ymremark',
						editor : new Ext.form.TextField({

						})

					}, {

						header : '顺序',
						dataIndex : 'ymseq',
						editor : new Ext.form.NumberField({
									allowBlank : false
								})

					},checkColumn1]);

			function AddYiMiao() {

				var row = new Ext.data.Record({
							ymid : '',
							ymcode : '',
							ymdesc : '',
							ymcount : '',
							ymsite : '',
							ymdose : '',
							ymmf : '',
							ymltno : '',
							ymremark : '',
							ymway : '',
							ymseq : '99999'
						});
				ymgrid.stopEditing();
				ymstore.insert(0, row);
				ymgrid.startEditing(0, 0);

			}

			var ymtbar = new Ext.Toolbar({

						items : [{
									xtype : 'tbbutton',
									text : '新增一条记录',
									iconCls : 'add',
									id : 'addym',
									handler : AddYiMiao
								}]
					})
			var sm = new Ext.grid.CheckboxSelectionModel();
			var ymgrid = new Ext.grid.EditorGridPanel({

						region : 'center',
						plugins : checkColumn1,
						frame : true,
						viewConfig : {
							forceFit : true
						},
						store : ymstore,
						cm : ymcm,
						sm : sm,
						tbar : ymtbar

					});

			ymgrid.on('afteredit', function(e) {

						var ymid = e.record.get("ymid");
						var ymcode = e.record.get("ymcode");
						var ymdesc = e.record.get("ymdesc");
						var ymcount = e.record.get("ymcount");
						var ymsite = e.record.get("ymsite");
						var ymdose = e.record.get("ymdose");
						var ymmf = e.record.get("ymmf");
						var ymltno = e.record.get("ymltno");
						var ymremark = e.record.get("ymremark");
						var ymseq = e.record.get("ymseq");
						var ymway = e.record.get("ymway");
						var ymactive = e.record.get("ymactive");
						if (ymid) {
						} else
							ymid = '';
						var YMInstring = ymid + "^" + ymcode + "^" + ymdesc
								+ "^" + ymcount + "^" + ymsite + "^" + ymdose
								+ "^" + ymmf + "^" + ymltno + "^" + ymremark
								+ "^" + ymseq + "^" + ymway + "^" + ymactive
						
						var ret = tkMakeServerCall("web.DHCCRM.CRMYiMiao",
								"SaveYiMiaoBase", ymid, YMInstring);

						if (ret == 0)
							ymstore.load();

					});

			var main = new Ext.Viewport({

						layout : 'border',
						collapsible : true,
						items : ymgrid
					});
			ymstore.load();
		})