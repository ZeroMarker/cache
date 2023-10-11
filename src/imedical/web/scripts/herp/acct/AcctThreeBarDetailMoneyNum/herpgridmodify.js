/*  ----------------herpgrid���ʹ��˵��---------------------
 * ���ߣ�����������
 * ���ڣ�2011-2012
 * 	-----------------herpgrid����˵��------------------
 * 	
 	save() 			//����grid���޸ĵ����ݣ���������ʱ����action=add���޸�����ʱ����action=edit��
 	add()			//��grid������һ��
 	del()			//ɾ��һ�����ݣ����������ɾ�������������ݲ�ɾ����

	
	���������ݣ�
	1��������������֤���ܣ���������ݲ���ܱ��棬�о�����ʾ����
	2������orverrender���ԣ���overrender=trueʱ��������дcombox��renderer�󶨷�����
	3������saveurl(url)����,���Ը�����Ҫ�Զ���url�������ύ���ݣ��磺url='herp.budg.budgschemmainexe.csp?action=copysheme&rowid='+schmDr
	4��������ɾ����ʶ��ɾ��ĳ�����ݺ����ӱ�ʶ��ֻ�б�����ύ���ݲ��Ҹ������ݿ⡣
	5�����Ӳ�ѯ��ť��ȴԭ����ҳ���Զ����أ���������չ����д����
	6�������˴�ӡ����PrintExtgrid()//����ӡ����ϸ������herpgridprint.js
	7�������˴�ӡ��Ʒ���printDesign()
	8�������˰�ť�������ɷ�����
	 	hiddenButton() 	//���ص�n����ť
		btnAddHide() 	//�������Ӱ�ť
		btnSaveHide() 	//���ر��水ť
		btnResetHide() 	//�������ð�ť
		btnDeleteHide() //����ɾ����ť
		btnPrintHide() 	//���ش�ӡ��ť

	
 * 
 * PrintExtgrid(grid,title) //�Զ������ӡ��grid Ҫ��ӡ�ı��title���������
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
			header : '��Ч���',
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
	readerModel : 'remote', // store reader���� Ĭ��ΪԶ��
	// sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
	urlParam : {},
	forms : [],
	pageSize : 25,
	dateFields : [],
	// atLoad : true, // �Ƿ��Զ�ˢ��
	clicksToEdit : 1, // 1����񵥻���2�����˫��
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
		//var summary = new Ext.ux.grid.GridSummary(); //����
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
	//������(����һ���ϵ�ÿһ�н����������͵�ƥ��,�Ա�༭��ʱ��н�ͬһ�е�����)
	createColumns : function() { 
		var tmpfiels = [];                                                	//��������
		var cols = [new Ext.grid.RowNumberer()];							//����grid�кŵ����飻
		for (var i = 0; i < this.fields.length; i++) {						//�ж��ж����ֶ�(Ҳ�����ж�����)
			var tmpObj = this.fields[i];									//��ȡÿһ�� ,�����ж���Ϊthis.fields[]����
			
			//alert(i);
			// Ext.apply(tmpObj,this.fields[i])

			// columnsģ��-[0:����,1:index,2:����,3:�Ƿ�ɱ༭,4:�Ƿ��Ϊ��] �����������
			// tmpObj = Ext.applyIf(tmpObj, this.defaultfiles);
			cols.push(tmpObj);  //����һ����չ
			//alert(cols.push(tmpObj)+"=cols.push(tmpObj)")  
			
			// ���fiels
			tmpfiels.push({
						name : tmpObj.dataIndex,
						tip : tmpObj.tip,
						header : tmpObj.header,
						width : tmpObj.width
					});
			// ���Ϊ�ɱ༭Grid
			if (this.edit) {
				//���tmpObj�����Ƕ���
				if (tmpObj.type instanceof Object) {   //����tmpObj�������Ƿ����ڶ���
					// ������orverrender���ԣ�true��������дrenderer��false������herpgird�ġ�
					if ((tmpObj.overrender == false)
							|| (typeof(tmpObj.overrender) == "undefined")) {
						if ("combo" === tmpObj.type.getXType()) {
							cols[i + 1].renderer = dhc.herp.ComboRender;
						}
					}
					cols[i + 1].editor = tmpObj.type;
					cols[i + 1].width = tmpObj.width;

				} else if (tmpObj.type == "dateField") {
					//	������������͵�
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
			// �ǿɱ༭Grid
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
	//���ݴ洢  
	createStore : function() {
		// ����
		if (this.readerModel == 'local') {
			this.store = new Ext.data.Store({
						proxy : new Ext.data.MemoryProxy(this.data),
						reader : new Ext.data.ArrayReader({
									fields : this.fields
								})
					});
		}
		// Զ��
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
			alert("����дStore����!");
		}

	},
	createBbar : function() {
		this.bbar = new Ext.PagingToolbar({// ��ҳ������
			pageSize : this.pageSize,
			store : this.store,
			displayInfo : true,
			plugins : new dhc.herp.PageSizePlugin(),
			displayMsg : '��ǰ��ʾ{0} - {1}������{2}',
			emptyMsg : "û������"
		});
	},
	hiddenButton : function(index) {
		var tbar = this.getTopToolbar();
		var tbutton = tbar.get(index);

		tbutton.setVisible(tbutton.hidden);
	},
	//�������Ӱ�ť
	btnAddHide : function() {
		
		var tbar = this.getTopToolbar();
		var tbutton = tbar.get('herpAddId');
		tbutton.hide();
		},
	//���ر��水ť
	btnSaveHide : function() {
		
		var tbar = this.getTopToolbar();
		var tbutton = tbar.get('herpSaveId');
		tbutton.hide();
		},
		//�������ð�ť
	btnResetHide : function() {
		var tbar = this.getTopToolbar();
		var tbutton = tbar.get('herpResetId');
		tbutton.hide();
		},
	//����ɾ����ť
	btnDeleteHide : function() {
		
		var tbar = this.getTopToolbar();
		var tbutton = tbar.get('herpDeleteId');
		tbutton.hide();
		},
		//���ش�ӡ��ť
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
				//ѭ��
			rec.fields.each(function(f) {
						
						if (f.defaultValue != null) {
							rec.data[f.name] = f.defaultValue;
						}
						
					});
			rec.commit();//ִ�����ɱ��
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
						title : '��ʾ',
						msg : '��ѡ��Ҫɾ��������! ',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
						});
					return;
			
		}
		Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ��������', function(btn) {
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
										waitMsg : 'ɾ����...',
										failure : function(result, request) {
											Ext.Msg.show({
														title : '����',
														msg : '������������!',
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.ERROR
													});
										},
										success : function(result, request) {
											var jsonData = Ext.util.JSON
													.decode(result.responseText);
											if (jsonData.success == 'true') {
												Ext.MessageBox.alert('��ʾ',
														'ɾ�����');
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
															title : '����',
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
					text : '��������',
					tooltip : '����һ���·���',
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
					text : '���淽��',
					id : 'herpSaveId',
					tooltip : '�������и���',
					iconCls: 'save',
					scope : this,
					handler : this.save

				},'-', {
					text : 'ɾ������',
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
					text : '����',
					id : 'herpResetId',
					tooltip : '�������и���',
					iconCls:'reset',
					scope : this,
					handler : function() {
						this.store.rejectChanges();
					}
				},  {
					text : '��ӡ',
					id : 'herpPrintId',
					iconCls:'print',
					tooltip : '����ӡ',
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
	//���ݱ���
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
						title : '����',
						msg : '�뽫�����������������!',
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
			var deleteFlag = r.data['delFlag'];// ɾ����ʶ��1���Ǹü�¼�Ѿ�ɾ����0��δɾ����

			// ������������֤Beging
			for (var i = 0; i < this.fields.length; i++) {

				var indx = this.getColumnModel().getColumnId(i + 1)
				var tmobj = this.getColumnModel().getColumnById(indx)
				if (tmobj != null) {
					// ������update���ԣ�true����������û�б仯Ҳ���̨�ύ���ݣ�false���򲻻�ǿ���ύ����
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
								
							var info = "[" + titlenew + "]��Ϊ���������Ϊ�ջ��㣡"
							Ext.Msg.show({
										title : '����',
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
			// ������������֤END
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
							title : '����',
							msg : '�뽫�����������������!',
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
				waitMsg : '������...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {

						var message = "";
						message = recordType == 'add' ? '��ӳɹ�!' : '����ɹ�!'
						Ext.Msg.show({
									title : 'ע��',
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
							message = '���������Ϊ��!';
						if (jsonData.info == 'EmptyOrder')
							message = '��������Ϊ��!';
						if (jsonData.info == 'RepCode')
							message = '����ı����Ѿ�����!';
						if (jsonData.info == 'RepName')
							message = '����������Ѿ�����!';
						if (jsonData.info == 'RepOrder')
							message = '���������Ѿ�����!';
						if (jsonData.info == 'RecordExist')
							message = '����ļ�¼�Ѿ�����!';
						Ext.Msg.show({
									title : '����',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						// this.store.rejectChanges(); ����ʧ��,��������//
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
				waitMsg : '������...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {

						var message = "����ɹ�";
						Ext.Msg.show({
									title : 'ע��',
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
							message = '���������Ϊ��!';
						if (jsonData.info == 'EmptyOrder')
							message = '��������Ϊ��!';
						if (jsonData.info == 'RepCode')
							message = '����ı����Ѿ�����!';
						if (jsonData.info == 'RepName')
							message = '����������Ѿ�����!';
						if (jsonData.info == 'RepOrder')
							message = '���������Ѿ�����!';
						if (jsonData.info == 'RecordExist')
							message = '����ļ�¼�Ѿ�����!';
						Ext.Msg.show({
									title : '����',
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
	// ���ݱ����ύ���Զ���url������url��ʽ��herp.budg.budgschemmainexe.csp?action=copysheme&rowid='+schmDr
	saveurl : function(Url) {
		var forms = this.forms;

		var data = [];
		var p;
		var rtn = 0
		var tmpStore = this.store;
		// Ext.each(records, function(r) {
		// ������������֤Beging

		p = {
			url : Url,
			method : 'GET',
			waitMsg : '������...',
			failure : function(result, request) {
				Ext.Msg.show({
							title : '����',
							msg : '������������!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
			},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {

					var message = "";
					message = '�����ɹ�!'
					Ext.Msg.show({
								title : 'ע��',
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
						message = '���������Ϊ��!';
					if (jsonData.info == 'EmptyOrder')
						message = '��������Ϊ��!';
					if (jsonData.info == 'RepCode')
						message = '����ı����Ѿ�����!';
					if (jsonData.info == 'RepName')
						message = '����������Ѿ�����!';
					if (jsonData.info == 'RepOrder')
						message = '���������Ѿ�����!';
					if (jsonData.info == 'RecordExist')
						message = '����ļ�¼�Ѿ�����!';
					Ext.Msg.show({
								title : '����',
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
		LODOP.PREVIEW(); // ��ӡԤ��
		//LODOP.PRINT_SETUP(); //��ӡά��
		//LODOP.PRINT_DESIGN(); //��ӡ���

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
								text : '�ύ',
								handler : this.submitRecord
										.createDelegate(this)
							}, {
								text : '����',
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
					title : '��ѯ',
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
											title : '����',
											msg : '������������!',
											bufieldsons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							},
							success : function(result, request) {
								jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									message = jsonData.info;
									Ext.example.msg('��ѯ�ɹ�<p/>', '{0}', message);
								} else {
									message = "SQLErecord: " + jsonData.info;
									Ext.example.msg('��ѯʧ��<p/>', '{0}', message);
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

	// LODOP.PRINT_INITA(0, 0, 800, 1600, "herpgrid��ӡ");
	stitle = "herpgrid����ӡ"
	LODOP.PRINT_INIT("herp����ӡ")
	LODOP.SET_PRINT_PAGESIZE(3, 0, 0, "A4")
	if (typeof(pgrid.title) == "undefined") {
		LODOP.ADD_PRINT_TEXT(25, 300, 355, 30, stitle);
	} else {
		LODOP.ADD_PRINT_TEXT(25, 300, 355, 30, pgrid.title);
	}

	AddText(pgrid);
	LODOP.ADD_PRINT_TEXT(3, 653, 135, 20, "��#ҳ/��&ҳ");
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
	// ���ñ����ʽ
	var strTableStyle = "<style type='text/css'>table{width:'100%';border-collapse: collapse;} table thead td b{font-size: 25px;} table tr td{font-size: 13px;} table tfoot td{font-size: 15px;}</style>";
	// ������ƴ��һ��table
	var strTableStartHtml = "<table border='1' width='100%' bordercolor='#336699' cellpadding='0' cellspacing='0' align='center'>";
	var strTableEndHtml = "</table>";
	var strTableTheadHtml = "<thead style='height: 30px' bgcolor='#efefef'>";
	var strTableTrHtml = "";
	for (var i = 0; i < pgrid.getColumnModel().getColumnCount(true); i++) {
		var indx = pgrid.getColumnModel().getColumnId(i)
		var tmobj = pgrid.getColumnModel().getColumnById(indx)
		if (tmobj != null) {
			// �������Ƿ��ӡprint���ԣ�true����ӡ��false������ӡ
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
	var strTableTfoot = "<tr style='height: 30px'><td align='center'><b>�ϼ�</b></td><td>&nbsp;</td><td>&nbsp;</td><td align='right'><b>"
			+ Ext.util.Format.number(zjeTotal, '0,0.00')
			+ "</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";
	var strPageFooter = ""; 

	LODOP.ADD_PRINT_HTM(50, 0, 800, 1000, strTableStyle);
	LODOP.ADD_PRINT_TABLE(75, 0, "100%", "85%", strTableStartHtml
					+ strTableTheadHtml + strTableTrHtml + strPageFooter
					+ strTableEndHtml);

};
*/
