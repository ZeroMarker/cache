/*  ----------------herpgrid组件使用说明---------------------
 * 作者：杨旭、赵立国
 * 日期：2011-2012
 * 	-----------------herpgrid方法说明------------------
 * 	
 	save() 			//保存grid中修改的数据，增加数据时调用action=add；修改数据时调用action=edit；
 	add()			//在grid上增加一行
 	del()			//删除一行数据，保存后数据删除，不保存数据不删除。

	
	新增加内容：
	1、增加了数据验证功能（必填项，数据不填不能保存，有具体提示）。
	2、增加orverrender属性，当overrender=true时，可以重写combox的renderer绑定方法。
	3、增加saveurl(url)方法,可以更具需要自定义url，保存提交数据，如：url='herp.budg.budgschemmainexe.csp?action=copysheme&rowid='+schmDr
	4、增加了删除标识，删除某行数据后增加标识，只有保存后提交数据并且更改数据库。
	5、增加查询按钮，却原来的页面自动加载（可以在扩展里重写）。
	6、增加了打印方法PrintExtgrid()//表格打印，详细参数见herpgridprint.js
	7、增加了打印设计方法printDesign()
	8、增加了按钮隐藏若干方法：
	 	hiddenButton() 	//隐藏第n个按钮
		btnAddHide() 	//隐藏增加按钮
		btnSaveHide() 	//隐藏保存按钮
		btnResetHide() 	//隐藏重置按钮
		btnDeleteHide() //隐藏删除按钮
		btnPrintHide() 	//隐藏打印按钮

	
 * 
 * PrintExtgrid(grid,title) //自定义表格打印：grid 要打印的表格；title：报表标题
 * 
 * 
 */



Ext.ns('Ext.ux.grid');

var LODOP
Ext.ux.grid.CheckColumn = function(config) {
	Ext.apply(this, config);
	if (!this.id) {
		this.id = Ext.id();
	}
	this.renderer = this.renderer.createDelegate(this);
};

Ext.ux.grid.CheckColumn.prototype = {
	init : function(grid) {
		this.grid = grid;
		this.grid.on('render', function() {
					var view = this.grid.getView();
					view.mainBody.on('mousedown', this.onMouseDown, this);
				}, this);
	},

	onMouseDown : function(e, t) {
		if (Ext.fly(t).hasClass(this.createId())) {
			e.stopEvent();
			var index = this.grid.getView().findRowIndex(t);
			var record = this.grid.store.getAt(index);
			record.set(this.dataIndex, !record.data[this.dataIndex]);
		}
	},

	renderer : function(v, p, record) {
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'
				+ (v == 'Y' || v == true ? '-on' : '') + ' x-grid3-cc-'
				+ this.id + '">&#160;</div>';
	},

	createId : function() {
		return 'x-grid3-cc-' + this.id;
	}
};

// register ptype
Ext.preg('checkcolumn', Ext.ux.grid.CheckColumn);

// backwards compat
Ext.grid.CheckColumn = Ext.ux.grid.CheckColumn;

Ext.ns("dhc.herp");

var checkColumn = new Ext.grid.CheckColumn({
			header : '有效标记',
			dataIndex : 'active',
			width : 55
		});

Ext.grid.Column.types = {
	gridcolumn : Ext.grid.Column,
	booleancolumn : Ext.grid.BooleanColumn,
	numbercolumn : Ext.grid.NumberColumn,
	datecolumn : Ext.grid.DateColumn,
	templatecolumn : Ext.grid.TemplateColumn,
	checkcolumn : Ext.ux.grid.CheckColumn
};

var colModel = new Ext.grid.ColumnModel({
			columns : [
			// { header: "codetest", id:"code", sortable: true}

			]
		});

dhc.herp.Grid = Ext.extend(Ext.grid.EditorGridPanel, {
	edit : true,
	trackMouseOver : true,
	stripeRows : true,
	cm : colModel,
	readerModel : 'remote', // store reader类型 默认为远程
	// sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
	urlParam : {},
	forms : [],
	pageSize : 25,
	dateFields : [],
	// atLoad : true, // 是否自动刷新
	clicksToEdit : 1, // 1：表格单击；2：表格双击
	initComponent : function() {
		this.createColumns();
		this.createStore();
		this.createBbar();
		this.createTbar();
		this.createSm();
		this.createPlugins();
		if (this.atLoad) {
			this.bbar.doRefresh();
		}
		dhc.herp.Grid.superclass.initComponent.call(this);
	},
	createPlugins : function() {
		var plugins = [];
		if (!Ext.isEmpty(this.plugins)) {
			var plugins = this.plugins;
		}
		//var summary = new Ext.ux.grid.GridSummary(); //声明
		plugins.push(checkColumn);
		plugins.push(dhc.herp.GridTip);
		//plugins.push(summary);
		this.plugins = plugins;
	},
	defaultfiles : {
		hidden : true,
		dataIndex : 'rowid',
		allowBlank : true,
		params : '',
		editable : true,
		tip : false,
		width : 80,
		align : 'left',
		sortable : true
	},
	//增加列(根据一行上的每一列进行数据类型的匹配,以便编辑的时候承接同一列的类型)
	createColumns : function() { 
		var tmpfiels = [];                                                	//定义数组
		var cols = [new Ext.grid.RowNumberer()];							//定义grid行号的数组；
		for (var i = 0; i < this.fields.length; i++) {						//判断有多少字段(也就是有多少列)
			var tmpObj = this.fields[i];									//获取每一列 ,所有列定义为this.fields[]数组
			
			//alert(i);
			// Ext.apply(tmpObj,this.fields[i])

			// columns模型-[0:名称,1:index,2:类型,3:是否可编辑,4:是否可为空] 下午继续这里
			// tmpObj = Ext.applyIf(tmpObj, this.defaultfiles);
			cols.push(tmpObj);  //将列一次扩展
			//alert(cols.push(tmpObj)+"=cols.push(tmpObj)")  
			
			// 组合fiels
			tmpfiels.push({
						name : tmpObj.dataIndex,
						tip : tmpObj.tip,
						header : tmpObj.header,
						width : tmpObj.width
					});
			// 如果为可编辑Grid
			if (this.edit) {
				//如果tmpObj类型是对象
				if (tmpObj.type instanceof Object) {   //测试tmpObj的类型是否属于对象
					// 列增加orverrender属性，true：可以重写renderer；false：调用herpgird的。
					if ((tmpObj.overrender == false)
							|| (typeof(tmpObj.overrender) == "undefined")) {
						if ("combo" === tmpObj.type.getXType()) {
							cols[i + 1].renderer = dhc.herp.ComboRender;
						}
					}
					cols[i + 1].editor = tmpObj.type;
					cols[i + 1].width = tmpObj.width;

				} else if (tmpObj.type == "dateField") {
					//	如果是日期类型的
					this.dateFields.push(tmpObj.dataIndex);
					cols[i + 1].renderer = function(v, p, r, i) {

						if (v instanceof Date) {

							return new Date(v).format("Y-m-d");
						} else {
							return v;

						}

					};

					cols[i + 1].editor = new Ext.form.DateField({
						fieldLabel : tmpObj.header,
						id : tmpObj.dataIndex,
						allowBlank : tmpObj.allowBlank,
						hidden : tmpObj.hidden,
						format : 'Y-m-d'
						//,
						//disabledDays : [0, 6],
						//disabledDaysText : 'Plants are not available on the weekends'
					});
				} else if (tmpObj.type == "combo") {
					// alert(tmpObj.header + "::" + tmpObj.width)
					var tmpParams = Ext.urlEncode(tmpObj.params);
					cols[i + 1].editor = new Ext.form.ComboBox({
								anchor : '99%',
								listWidth : 260,
								// width : 120,
								width : tmpObj.width,
								store : new Ext.data.Store({
											proxy : new Ext.data.HttpProxy({
														url : this.url
																+ '?action=listCombo&'
																+ tmpParams,
														method : 'GET'
													}),
											reader : new Ext.data.JsonReader({
														totalProperty : "results",
														root : 'rows'
													}, ['rowid', 'name'])
										}),
								valueField : 'rowid',
								displayField : 'name',
								fieldLabel : tmpObj.header,
								id : tmpObj.dataIndex,
								triggerAction : 'all',
								pageSize : 10,
								hidden : tmpObj.hidden,
								allowBlank : tmpObj.allowBlank,
								minChars : 1,
								selectOnFocus : true,
								forceSelection : true,
								load : function(param) {
									if (!Ext.isEmpty(param))
										this.getStore().baseParams = param.params;
									this.getStore().load({
												params : {
													start : 0,
													limit : this.pageSize
												}
											});
								}
							});
					// if (tmpObj.overrender == flse) {
					cols[i + 1].renderer = dhc.herp.ComboRender;
				} else if (tmpObj.type == "numberField") {

					cols[i + 1].xtype = 'numbercolumn';
					cols[i + 1].align = 'right';
					cols[i + 1].editor = new Ext.form.NumberField({
								fieldLabel : tmpObj.header,
								hidden : tmpObj.hidden,
								width : tmpObj.width,
								// anchor: '90%',
								id : tmpObj.dataIndex,
								allowBlank : tmpObj.allowBlank
							})
				} else if (tmpObj.type == "checkBox") {
					cols[i + 1] = checkColumn;
				} else {
					// alert(tmpObj.header+"::"+tmpObj.width)
					cols[i + 1].editor = new Ext.form.TextField({
								fieldLabel : tmpObj.header,
								width : tmpObj.width,
								// anchor: '90%',
								hidden : tmpObj.hidden,
								id : tmpObj.dataIndex,
								allowBlank : tmpObj.allowBlank
							})
				}
			}
			// 非可编辑Grid
			else {
				if (tmpObj.type == "dateField") {
					cols[i + 1].renderer = Ext.util.Format
							.dateRenderer('Y-m-d');
				}
			}
		}

		this.cm = new Ext.grid.ColumnModel(cols);

		this.fields = tmpfiels;
	},
	//数据存储  
	createStore : function() {
		// 本地
		if (this.readerModel == 'local') {
			this.store = new Ext.data.Store({
						proxy : new Ext.data.MemoryProxy(this.data),
						reader : new Ext.data.ArrayReader({
									fields : this.fields
								})
					});
		}
		// 远程
		else if (this.readerModel == 'remote') { 
			this.store = new Ext.data.Store({
						proxy : new Ext.data.HttpProxy({
									url : this.url + '?action=list&bookID='+acctbookid
								}),
						reader : new Ext.data.JsonReader({
									root : 'rows',
									totalProperty : 'results'
								}, this.fields),
						remoteSort : true
					});
		} else {
			alert("请填写Store类型!");
		}

	},
	createBbar : function() {
		this.bbar = new Ext.PagingToolbar({// 分页工具栏
			pageSize : this.pageSize,
			store : this.store,
			displayInfo : true,
			plugins : new dhc.herp.PageSizePlugin(),
			displayMsg : '当前显示{0} - {1}，共计{2}',
			emptyMsg : "没有数据"
		});
	},
	hiddenButton : function(index) {
		var tbar = this.getTopToolbar();
		var tbutton = tbar.get(index);

		tbutton.setVisible(tbutton.hidden);
	},
	//隐藏增加按钮
	btnAddHide : function() {
		
		var tbar = this.getTopToolbar();
		var tbutton = tbar.get('herpAddId');
		tbutton.hide();
		},
	//隐藏保存按钮
	btnSaveHide : function() {
		
		var tbar = this.getTopToolbar();
		var tbutton = tbar.get('herpSaveId');
		tbutton.hide();
		},
		//隐藏重置按钮
	btnResetHide : function() {
		var tbar = this.getTopToolbar();
		var tbutton = tbar.get('herpResetId');
		tbutton.hide();
		},
	//隐藏删除按钮
	btnDeleteHide : function() {
		
		var tbar = this.getTopToolbar();
		var tbutton = tbar.get('herpDeleteId');
		tbutton.hide();
		},
		//隐藏打印按钮
	btnPrintHide : function() {
		
		var tbar = this.getTopToolbar();
		var tbutton = tbar.get('herpPrintId');
		tbutton.hide();
		},
	addButton : function(btn) {
		var tbar = this.getTopToolbar();
		tbar.add(btn);
	},
	add : function() {
		var store = this.store;
		if (store.recordType) {
			var rec = new store.recordType({
						newRecord : true
					});
				//循环
			rec.fields.each(function(f) {
						
						if (f.defaultValue != null) {
							rec.data[f.name] = f.defaultValue;
						}
						
					});
			rec.commit();//执行生成表格
			store.add(rec);
			return rec;
		}
		return false;
	},
	del : function() {
		var tmpUrl = this.url;
		var tmpG = this;
		var records = this.getSelectionModel().getSelections();
		var len=records.length;
		if(len<1){
			Ext.Msg.show({
						title : '提示',
						msg : '请选择要删除的数据! ',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
						});
					return;
			
		}
		Ext.MessageBox.confirm('提示', '确定要删除选定的行吗', function(btn) {
			if (btn == 'yes') {
				Ext.each(records, function(record) {

							if (Ext.isEmpty(record.get("rowid"))) {
								// record.reject(true);
								tmpG.getStore().remove(record);
								// tmpG.store.modified.remove(record);
								return;
							}

							if (Ext.isEmpty(record.get("rowid"))) {
								tmpG.getStore().remove(record);
								return;
							}
							Ext.Ajax.request({
										url : tmpUrl + '?action=del&rowid='
												+ record.get("rowid"),
										waitMsg : '删除中...',
										failure : function(result, request) {
											Ext.Msg.show({
														title : '错误',
														msg : '请检查网络连接!',
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.ERROR
													});
										},
										success : function(result, request) {
											var jsonData = Ext.util.JSON
													.decode(result.responseText);
											if (jsonData.success == 'true') {
												Ext.MessageBox.alert('提示',
														'删除完成');
												tmpG.load({
															params : {
																start : 0,
																limit : tmpG.pageSize
															}
														});
											} else {
												var message = "SQLErr: "
														+ jsonData.info;
												Ext.Msg.show({
															title : '错误',
															msg : message,
															buttons : Ext.Msg.OK,
															icon : Ext.MessageBox.ERROR
														});
											}
										},
										scope : this
									});
						});
			}
		});
	},
	createTbar : function() {
		var buttons = [];
		if (!Ext.isEmpty(this.tbar))
			buttons.push(this.tbar);

		buttons.push([{
					text : '新增方案',
					tooltip : '增加一个新方案',
					id : 'herpAddId',
					 iconCls:'add',
					listeners : {
						click : {
							scope : this,
							fn : this.add,
							buffer : 200
						}
					}
				},'-',  {
					text : '保存方案',
					id : 'herpSaveId',
					tooltip : '保存所有更改',
					iconCls: 'save',
					scope : this,
					handler : this.save

				},'-', {
					text : '删除方案',
					id : 'herpDeleteId',
					iconCls:'remove',
					listeners : {
						click : {
							scope : this,
							fn : this.del,
							buffer : 200
						}
					}

				},  {
					text : '重置',
					id : 'herpResetId',
					tooltip : '撤销所有更改',
					iconCls:'reset',
					scope : this,
					handler : function() {
						this.store.rejectChanges();
					}
				},  {
					text : '打印',
					id : 'herpPrintId',
					iconCls:'print',
					tooltip : '表格打印',
					scope : this,
					handler : this.print

				}])
		this.tbar = buttons;
	},
	createSm : function() {

		this.sm = new Ext.grid.CheckboxSelectionModel({
			moveEditorOnEnter : true,
			// ------------------------------
			onEditorKey : function(field, e) {
				var k = e.getKey(), newCell, g = this.grid, last = g.lastEdit, ed = g.activeEditor, ae, last, r, c;
				var shift = e.shiftKey;

				if (k == e.TAB) {
					e.stopEvent();
					ed.completeEdit();

					if (shift) {
						newCell = g.walkCells(ed.row, ed.col - 1, -1,
								this.acceptsNav, this);
					} else {
						newCell = g.walkCells(ed.row, ed.col + 1, 1,
								this.acceptsNav, this);

					}
					if (ed.col == this.grid.fields.length
							&& ed.row == g.getStore().getCount() - 1) {
						g.add();
						newCell = g.walkCells(ed.row + 1, 1, 1,
								this.acceptsNav, this);
					}
				} else if (k == e.RIGHT) {
					e.stopEvent();
					ed.completeEdit();
					if (shift) {
						newCell = g.walkCells(ed.row, ed.col - 1, -1,
								this.acceptsNav, this);

					} else {
						newCell = g.walkCells(ed.row, ed.col + 1, 1,
								this.acceptsNav, this);
					}
					if (ed.col == this.grid.fields.length
							&& ed.row == g.getStore().getCount() - 1) {
						g.add();
						newCell = g.walkCells(ed.row + 1, 1, 1,
								this.acceptsNav, this);
					}
				} else if (k == e.LEFT) {
					e.stopEvent();
					ed.completeEdit();
					if (shift) {
						newCell = g.walkCells(ed.row, ed.col - 1, -1,
								this.acceptsNav, this);
					} else {
						newCell = g.walkCells(ed.row, ed.col - 1, 1,
								this.acceptsNav, this);
					}
				}
				if (newCell) {
					r = newCell[0];
					c = newCell[1];

					if (last.row != r) {
						this.selectRow(r); // *** highlight newly-selected cell
						// and update selection
					}

					if (g.isEditor && g.editing) { // *** handle tabbing while
						// editorgrid is in edit
						// mode
						ae = g.activeEditor;
						if (ae && ae.field.triggerBlur) {
							// *** if activeEditor is a TriggerField, explicitly
							// call its triggerBlur() method
							ae.field.triggerBlur();
						}
					}
					g.startEditing(r, c);
				}

			}
				// ------------------------------
		});
	},
	//数据保存
	save : function() {
		var forms = this.forms;
		var flag = Ext.each(forms, function(i) {
					if (i.getXType() === 'form') {
						return i.getForm().isValid();
					}
				});
		if (!flag && forms.length > 0) {
			alert(11);
			Ext.Msg.show({
						title : '错误',
						msg : '请将数据添加完整后再试!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return -1;
		}
		
		this.focus();
		
		var rowObj = this.getSelectionModel().getSelections();
        var desc=rowObj[0].get("desc");				
		var SubjCodeA=Ext.getCmp('AcctSubjCodeA').getRawValue();
		var SubjCodeB=Ext.getCmp('AcctSubjCodeB').getRawValue();
		var SubjLevel=Ext.getCmp('AcctSubjLevel').getRawValue();
		var year=Ext.getCmp('AcctYearField').getValue();
		var month1=Ext.getCmp('AcctMonthStrat').getValue();
		var month2=Ext.getCmp('AcctMonthEnd').getValue();
		var state=Ext.getCmp('StateField').getValue();
		var notlastsj=Ext.getCmp('NotIsLastField').getValue();
		var newdesc=SubjCodeA+';'+SubjCodeB+';'+SubjLevel+';'+year+';'+month1+';'+month2+';'+state+';'+notlastsj;
		var flag=false;
		if(newdesc===desc){
		flag=true;
		}
		
		var tmpDate = this.dateFields;
		var records = this.store.getModifiedRecords();
		var tmpStore = this.store;
		var topbar = this.getTopToolbar().items;
		var stro = "";
		Ext.each(topbar.items, function(i) {
					if (i.getXType() === 'combo') {
						stro += "&" + i.getId() + "=" + i.getValue();
					}
				})
		if (!records.length&&flag) {
			return;
		}
		
		var data = [];
		var p;
		var rtn = 0;
		if(records.length>0){
		Ext.each(records, function(r) {

			var o = {};
			var tmpstro = "&rowid=" + r.data['rowid'];
			var deleteFlag = r.data['delFlag'];// 删除标识，1：是该记录已经删除，0：未删除。

			// 数据完整性验证Beging
			for (var i = 0; i < this.fields.length; i++) {

				var indx = this.getColumnModel().getColumnId(i + 1)
				var tmobj = this.getColumnModel().getColumnById(indx)
				if (tmobj != null) {
					// 列增加update属性，true：该列数据没有变化也向后台提交数据，false：则不会强制提交数据
					var reValue = r.data[indx];
					if ((typeof(reValue) != "undefined") && (tmobj.update)) {
						tmpstro += "&" + indx + "=" + r.data[indx].toString();
					}

					if (tmobj.allowBlank == false) {
						var title = tmobj.header
						if ((r.data[indx].toString() == "")
								|| (parseInt(r.data[indx].toString()) == 0)) {

							var array1=title.split(">");
							var array2=array1[1].split("<");
							var titlenew=array2[0];
								
							var info = "[" + titlenew + "]列为必填项，不能为空或零！"
							Ext.Msg.show({
										title : '错误',
										msg : info,
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							rtn = -1;
							return -1;

						}
					}
				}

			}
			// 数据完整性验证END
			if (r.isValid()) {
				if (deleteFlag == "-1") {
					return;
				}

				for (var f in r.getChanges()) {

					o[f] = r.data[f];
					if (r.data[f] != null) {
						if (tmpDate.indexOf(f) >= 0) { // field.type=='date'
							if (r.data[f].toString() == "") {
								tmpstro += "&" + f + "=" + r.data[f].toString();
							} else {
								tmpstro += "&"
										+ f
										+ "="
										+ new Date(r.data[f]).format('Y-m-d')
												.toString();
							}
						} else if (f != null) {
							var chk = r.data[f];
							if (chk === true)
								chk = 'Y';
							else if (chk === false)
								chk = 'N';

							tmpstro += "&" + f + "=" + encodeURIComponent(chk);
						}
					}
				}
				// alert(tmpstro)
			} else {
				Ext.Msg.show({
							title : '错误',
							msg : '请将数据添加完整后再试!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			}

			var recordType;
			if (r.data.newRecord) {
				recordType = "add";
				
			} else {
				recordType = "edit";
				//alert(tmpstro);
				//var rowObj = SchemGrid.getSelectionModel().getSelections(); 
				//alert(descs); 
		        //var desc=rowObj[0].get("desc");
			}
			o[this.idName] = r.get(this.idName);
			data.push(o);
			var saveUrl = this.url + '?action=' + recordType + stro.toString()
					+ "&" + tmpstro.toString() + "&"
					+ Ext.urlEncode(this.urlParam)+"&descs="+encodeURIComponent(newdesc);
			// alert(saveUrl)
			p = {
				url : saveUrl,
				method : 'GET',
				waitMsg : '保存中...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {

						var message = "";
						message = recordType == 'add' ? '添加成功!' : '保存成功!'
						Ext.Msg.show({
									title : '注意',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
						tmpStore.commitChanges();
						if (jsonData.refresh == 'true') {
							tmpStore.load({
								params : {
									start : Ext
											.isEmpty(this.getTopToolbar().cursor)
											? 0
											: this.getTopToolbar().cursor,
									limit : this.pageSize
								}
							});
						}
					
					} else {
						if (jsonData.refresh == 'true') {
							tmpStore.load({
								params : {
									start : Ext
											.isEmpty(this.getTopToolbar().cursor)
											? 0
											: this.getTopToolbar().cursor,
									limit : this.pageSize
								}
							});
						}
						var message = "";
						message = "SQLErr: " + jsonData.info;
						if (jsonData.info == 'EmptyName')
							message = '输入的名称为空!';
						if (jsonData.info == 'EmptyOrder')
							message = '输入的序号为空!';
						if (jsonData.info == 'RepCode')
							message = '输入的编码已经存在!';
						if (jsonData.info == 'RepName')
							message = '输入的名称已经存在!';
						if (jsonData.info == 'RepOrder')
							message = '输入的序号已经存在!';
						if (jsonData.info == 'RecordExist')
							message = '输入的记录已经存在!';
						Ext.Msg.show({
									title : '错误',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						// this.store.rejectChanges(); 保存失败,不再跳出//
					}
				},
				scope : this
			};
			Ext.Ajax.request(p);
		}, this);
		}
		else{
		
		var saveUrl = this.url + '?action=edit'+'&rowid='+rowObj[0].get("rowid") +'&descs='+encodeURIComponent(newdesc);
			 // alert(saveUrl)
        var m = {
				url : saveUrl,
				method : 'GET',
				waitMsg : '保存中...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {

						var message = "保存成功";
						Ext.Msg.show({
									title : '注意',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
						tmpStore.commitChanges();
						if (jsonData.refresh == 'true') {
							tmpStore.load({
								params : {
									start : Ext
											.isEmpty(this.getTopToolbar().cursor)
											? 0
											: this.getTopToolbar().cursor,
									limit : this.pageSize
								}
							});
						}
					
					} else {
						if (jsonData.refresh == 'true') {
							tmpStore.load({
								params : {
									start : Ext
											.isEmpty(this.getTopToolbar().cursor)
											? 0
											: this.getTopToolbar().cursor,
									limit : this.pageSize
								}
							});
						}
						var message = "";
						message = "SQLErr: " + jsonData.info;
						if (jsonData.info == 'EmptyName')
							message = '输入的名称为空!';
						if (jsonData.info == 'EmptyOrder')
							message = '输入的序号为空!';
						if (jsonData.info == 'RepCode')
							message = '输入的编码已经存在!';
						if (jsonData.info == 'RepName')
							message = '输入的名称已经存在!';
						if (jsonData.info == 'RepOrder')
							message = '输入的序号已经存在!';
						if (jsonData.info == 'RecordExist')
							message = '输入的记录已经存在!';
						Ext.Msg.show({
									title : '错误',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						this.store.rejectChanges();
					}
				},
				scope : this
			};
			Ext.Ajax.request(m);
		}
		return rtn;
	},
	// 数据保存提交，自定义url参数，url格式：herp.budg.budgschemmainexe.csp?action=copysheme&rowid='+schmDr
	saveurl : function(Url) {
		var forms = this.forms;

		var data = [];
		var p;
		var rtn = 0
		var tmpStore = this.store;
		// Ext.each(records, function(r) {
		// 数据完整性验证Beging

		p = {
			url : Url,
			method : 'GET',
			waitMsg : '保存中...',
			failure : function(result, request) {
				Ext.Msg.show({
							title : '错误',
							msg : '请检查网络连接!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
			},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {

					var message = "";
					message = '操作成功!'
					Ext.Msg.show({
								title : '注意',
								msg : message,
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
					tmpStore.load({
								params : {
									start : Ext
											.isEmpty(this.getTopToolbar().cursor)
											? 0
											: this.getTopToolbar().cursor,
									limit : this.pageSize
								}
							});

				} else {
					if (jsonData.refresh == 'true') {
						tmpStore.load({
									params : {
										start : Ext.isEmpty(this
												.getTopToolbar().cursor)
												? 0
												: this.getTopToolbar().cursor,
										limit : this.pageSize
									}
								});
					}
					var message = "";
					message = "SQLErr: " + jsonData.info;
					if (jsonData.info == 'EmptyName')
						message = '输入的名称为空!';
					if (jsonData.info == 'EmptyOrder')
						message = '输入的序号为空!';
					if (jsonData.info == 'RepCode')
						message = '输入的编码已经存在!';
					if (jsonData.info == 'RepName')
						message = '输入的名称已经存在!';
					if (jsonData.info == 'RepOrder')
						message = '输入的序号已经存在!';
					if (jsonData.info == 'RecordExist')
						message = '输入的记录已经存在!';
					Ext.Msg.show({
								title : '错误',
								msg : message,
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					this.store.rejectChanges();
				}
			},
			scope : this
		};
		Ext.Ajax.request(p);
		// }, this);

	},
	print : function() {
		PrintExtgrid(this);
		LODOP.PREVIEW(); // 打印预览
		//LODOP.PRINT_SETUP(); //打印维护
		//LODOP.PRINT_DESIGN(); //打印设计

	},
	getForm : function() {
		return this.getFormPanel().getForm();
	},

	submitRecord : function() {
		var form = this.getForm();
		var values = form.getFieldValues();
		var topbar = this.getTopToolbar().items;
		var stro = "";
		Ext.each(topbar.items, function(i) {
					if (i.getXType() === 'combo') {
						stro += "&" + i.getId() + "=" + i.getValue();
					}
				})
		this.getStore().proxy = new Ext.data.HttpProxy({
					url : this.url + '?action=list' + stro
				});
		var data = [];
		for (var name in values) {
			data.push(values[name]);
		}
		this.getStore().load({
					params : {
						data : data.toString()
					}
				});
		this.hideWindow();
	},
	getFormPanel : function() {
		if (!this.gridForm) {
			this.gridForm = this.createForm();
		}
		return this.gridForm;
	},

	createForm : function() {

		var items = [];
		var cmObj = this.getColumnModel();
		for (var i = 1; i <= this.fields.length; i++) {
			if (Ext.isDefined(cmObj.getColumnById(i))) {
				var editorObj = cmObj.getColumnById(i).editor;

				if (!editorObj.hidden) {
					items.push(editorObj);
				}
			}
		}

		var form = new Ext.form.FormPanel({
					frame : true,
					defaultType : 'textfield',
					buttonAlign : 'center',
					labelAlign : 'right',
					labelWidth : 60,
					trackResetOnLoad : true,
					reader : new Ext.data.ArrayReader({
								fields : this.fields
							}),
					items : items,
					buttons : [{
								text : '提交',
								handler : this.submitRecord
										.createDelegate(this)
							}, {
								text : '重置',
								handler : function() {
									form.getForm().reset();
								}
							}]
				});
		return form;
	},
	showWindow : function() {
		this.getWindow().show();
	},

	hideWindow : function() {
		this.getWindow().hide();
	},

	getWindow : function() {
		if (!this.gridWindow) {
			this.gridWindow = this.createWindow();
		}
		return this.gridWindow;
	},

	createWindow : function() {
		var formPanel = this.getFormPanel();

		var win = new Ext.Window({
					width : 400,
					title : '查询',
					closeAction : 'hide',
					modal : true,
					items : [formPanel]
				});

		return win;
	},
	// var param= {params:{start:pagingTool.cursor,limit:pagingTool.pageSize}}
	load : function(param) {
		if (!Ext.isEmpty(param))
			this.getStore().baseParams = Ext.apply(this.urlParam, param.params)
		else
			this.getStore().baseParams = this.urlParam;
		this.getStore().load({
			params : {
				start : Ext.isEmpty(this.getTopToolbar().cursor) ? 0 : this
						.getTopToolbar().cursor,
				limit : this.pageSize
			}
		});
	},
	isSave : function() {
		return Ext.isEmpty(this.getStore().getModifiedRecords());

	},
	isNew : function() {
		var tmpRs = false;
		var tmpR = this.getSelectionModel().getSelected();
		if (tmpR.data.newRecord) {
			tmpRs = true;
		} else {
			tmpRs = false;
		}
		return tmpRs;

	},
	setUrlParam : function(param) {
		if (!Ext.isEmpty(param))
			this.urlParam = Ext.apply(this.urlParam, param);

	}

});

dhc.herp.GridTip = {
	init : function(g) {
		var message = "";
		g.on('beforeedit', beforeedit, this);
		function beforeedit(e) {
			var record = e.record;
			var tmpResult = "";
			var fields = record.fields;
			var jsonData = "";
			if (fields.get(e.field).tip) {
				for (var v = 0; v < fields.length; v++) {

					tmpResult = tmpResult + '&' + fields.get(v).name + '='
							+ record.get(fields.get(v).name);
				}
				Ext.Ajax.request({
							url : g.url + '?action=tip',
							// montod:"GET",
							failure : function(result, request) {
								Ext.Msg.show({
											title : '错误',
											msg : '请检查网络连接!',
											bufieldsons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							},
							success : function(result, request) {
								jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									message = jsonData.info;
									Ext.example.msg('查询成功<p/>', '{0}', message);
								} else {
									message = "SQLErecord: " + jsonData.info;
									Ext.example.msg('查询失败<p/>', '{0}', message);
								}
							},
							params : tmpResult,
							scope : this
						});
			}
		};
	}
};

dhc.herp.ComboRender = function(value) {

	var editor = this.editor;
	if (editor) {

		var myStore = editor.store;

		var rec = myStore.find(editor.valueField, value);
		if (rec >= 0) {
			return myStore.getAt(rec).get(editor.displayField);
		} else {
			return value;
		}

		// }
	}
	return value;
};

dhc.herp.PageSizePlugin = function() {
	dhc.herp.PageSizePlugin.superclass.constructor.call(this, {
				store : new Ext.data.SimpleStore({
							fields : ['text', 'value'],
							data : [['10', 10], ['20', 20], ['30', 30],
									['50', 50], ['100', 100]]
						}),
				mode : 'local',
				displayField : 'text',
				valueField : 'value',
				editable : false,
				allowBlank : false,
				triggerAction : 'all',
				width : 40
			});
};

Ext.extend(dhc.herp.PageSizePlugin, Ext.form.ComboBox, {
			init : function(paging) {
				paging.on('render', this.onInitView, this);
			},

			onInitView : function(paging) {
				paging.add('-', this, '-');
				this.setValue(paging.pageSize);
				this.on('select', this.onPageSizeChanged, paging);
			},

			onPageSizeChanged : function(combo) {  
				this.pageSize = parseInt(combo.getValue());
				this.doLoad(0);
			}
		});
/*
function CreatePrintPage(pgrid, stitle) {

	LODOP = getLodop(document.getElementById('LODOP'), document
					.getElementById('LODOP_EM'));

	// LODOP.PRINT_INITA(0, 0, 800, 1600, "herpgrid打印");
	stitle = "herpgrid表格打印"
	LODOP.PRINT_INIT("herp表格打印")
	LODOP.SET_PRINT_PAGESIZE(3, 0, 0, "A4")
	if (typeof(pgrid.title) == "undefined") {
		LODOP.ADD_PRINT_TEXT(25, 300, 355, 30, stitle);
	} else {
		LODOP.ADD_PRINT_TEXT(25, 300, 355, 30, pgrid.title);
	}

	AddText(pgrid);
	LODOP.ADD_PRINT_TEXT(3, 653, 135, 20, "第#页/共&页");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 2);
	LODOP.SET_PRINT_STYLEA(0, "Horient", 1);
	LODOP.ADD_PRINT_TEXT(3, 34, 196, 20, "DHCC-HERP");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);

	// LODOP.ADD_PRINT_TEXT(3, 34, 196, 20, "DHCC-HERP");
}
function AddText(pgrid) {

	LODOP.SET_PRINT_STYLEA(1, "FontSize", 16);
	LODOP.SET_PRINT_STYLEA(1, "Bold", 1);
	// 设置表格样式
	var strTableStyle = "<style type='text/css'>table{width:'100%';border-collapse: collapse;} table thead td b{font-size: 25px;} table tr td{font-size: 13px;} table tfoot td{font-size: 15px;}</style>";
	// 将数据拼成一个table
	var strTableStartHtml = "<table border='1' width='100%' bordercolor='#336699' cellpadding='0' cellspacing='0' align='center'>";
	var strTableEndHtml = "</table>";
	var strTableTheadHtml = "<thead style='height: 30px' bgcolor='#efefef'>";
	var strTableTrHtml = "";
	for (var i = 0; i < pgrid.getColumnModel().getColumnCount(true); i++) {
		var indx = pgrid.getColumnModel().getColumnId(i)
		var tmobj = pgrid.getColumnModel().getColumnById(indx)
		if (tmobj != null) {
			// 列增加是否打印print属性，true：打印，false：不打印
			if ((typeof(tmobj.print) == "undefined") || (tmobj.print == true)) {
				var td = "<td nowrap align='center' style=font-size: 15px><b>"
						+ pgrid.getColumnModel().getColumnHeader(i)
						+ "</b></td>";
				strTableTheadHtml += td;
			}
		}
	}

	strTableTheadHtml += "</thead>";
	var zjeTotal = 0;
	for (var i = 0; i < pgrid.getStore().getCount(); i++) {
		var td = "<tr style='height: 30px'>";
		for (var n = 0; n < pgrid.fields.length + 1; n++) {

			var indx = pgrid.getColumnModel().getColumnId(n)
			var tmobj = pgrid.getColumnModel().getColumnById(indx)

			if ((typeof(tmobj.print) == "undefined") || (tmobj.print == true)) {
				// alert(Ext.get(indx).dom.value)

				var reValue = pgrid.getStore().getAt(i).get(indx);
				if ((tmobj.type != null) && (typeof(tmobj.type) != "")) {

					if ("combo" === tmobj.type.getXType()) {
						var editor = tmobj.editor;
						var myStore = tmobj.editor.store;
						var rec = myStore.find(editor.valueField, reValue);
						if (rec >= 0) {
							reValue = myStore.getAt(rec)
									.get(editor.displayField);
						}
					}
				}
				if (typeof(reValue) == "undefined") {
					reValue = "";
				}
				td += "<td align='center'>" + reValue + "</td>";
			}
		}
		td += "</tr>";
		strTableTrHtml += td;
	}
	var strTableTfoot = "<tr style='height: 30px'><td align='center'><b>合计</b></td><td>&nbsp;</td><td>&nbsp;</td><td align='right'><b>"
			+ Ext.util.Format.number(zjeTotal, '0,0.00')
			+ "</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";
	var strPageFooter = ""; 

	LODOP.ADD_PRINT_HTM(50, 0, 800, 1000, strTableStyle);
	LODOP.ADD_PRINT_TABLE(75, 0, "100%", "85%", strTableStartHtml
					+ strTableTheadHtml + strTableTrHtml + strPageFooter
					+ strTableEndHtml);

};
*/
