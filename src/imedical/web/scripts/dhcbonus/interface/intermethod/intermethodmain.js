var InterLocUrl = 'dhc.bonus.intermethodexe.csp';
var InterLocSetTabUrl = 'dhc.bonus.interlocsetexe.csp';
var InterLocProxy = new Ext.data.HttpProxy({
			url : InterLocUrl + '?action=list'
		});
// dhc.bonus.intermethodexe.csp?action=getScheme
var interLocSetDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

interLocSetDs.on('beforeload', function(ds, o) {
	var str=locSetTypeField.getValue();
	
	if (str=="")  str='-1'
		
		ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.interlocsetexe.csp?action=list&searchField=typeID&searchValue='+str,
						method : 'POST'
					})
	
		});
//&searchField=typeID&searchValue=
var interLocSetField = new Ext.form.ComboBox({
			id : 'interLocSetField',
			fieldLabel : '�ӿ���',
			width : 180,
			listWidth : 200,
			allowBlank : false,
			store : interLocSetDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			// name: 'interLocSetField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
var locSetType = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '����ָ��ӿ�'], ['2', '�������ݽӿ�'], ['3', '֧�����ݽӿ�'], ['4', '���������ݽӿ�']]
		});

var locSetTypeField = new Ext.form.ComboBox({
			id : 'locSetTypeField',
			fieldLabel : '�ӿ������',
			width : 150,
			listWidth : 200,
			selectOnFocus : true,
			allowBlank : false,
			store : locSetType,
			anchor : '90%',
			value : '', // Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//locSetType.on('beforeload', function(ds, o) {
locSetTypeField.on("select", function(cmb, rec, id) {
	
	 				interLocSetDs.load({
							params : {
								searchField : 'typeID',
								searchValue : Ext.getCmp('locSetTypeField')
										.getValue(),
								start : 0,
								limit : 10
							}
						});
		});
//&searchField=typeID&searchValue=		
var InterMethodDs = new Ext.data.Store({
			proxy : InterLocProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'LocSetrowid', 'LocSetname', 'methodDesc',
							'methodName', 'ReturnType', 'ReturnTypeName',
							'ReturnName', 'Order', 'active'

					]),
			// turn on remote sorting
			remoteSort : true
		});

InterMethodDs.setDefaultSort('order', 'ASC');

var addInterLocButton = new Ext.Toolbar.Button({
			text : '���',
			tooltip : '����½ӿڷ���',
			iconCls : 'add',
			handler : function() {
				addInterLocFun(InterMethodDs, InterMethodMain,
						InterLocPagingToolbar);
			}
		});

var editButton = new Ext.Toolbar.Button({
			text : 'ɾ��',
			tooltip : '����ѡ����ڼ�ɾ��',
			iconCls : 'remove',
			handler : function() {
				delFun(InterMethodDs, InterMethodMain, InterLocPagingToolbar);
			}
		});

var editInterLocButton = new Ext.Toolbar.Button({
			text : '�޸�',
			disable : false,
			tooltip : '�޸�ѡ���Ľӿڵ�Ԫ',
			iconCls : 'add',
			handler : function() {
				editInterLocFun(InterMethodDs, InterMethodMain,
						InterLocPagingToolbar);
			}
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
					view.mainBody.on('mousedown', this.onMouseDown, this);
				}, this);
	},

	onMouseDown : function(e, t) {
		if (t.className && t.className.indexOf('x-grid3-cc-' + this.id) != -1) {
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
			if (this.grid.fireEvent("validateedit", e) !== false && !e.cancel) {
				delete e.cancel;
				record.set(this.dataIndex, !record.data[this.dataIndex]);
				this.grid.fireEvent("afteredit", e);
			}
		}
	},

	renderer : function(v, p, record) {
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col' + (v ? '-on' : '')
				+ ' x-grid3-cc-' + this.id + '">&#160;</div>';
	}
};

var InterMethodCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : '�ӿ���',
			dataIndex : 'LocSetname',
			width : 110,
			align : 'left',
			hidden : true,
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'Order',
			width : 60,
			align : 'left',
			sortable : true

		}, {
			header : '��������',
			dataIndex : 'methodDesc',
			width : 120,
			align : 'left',
			sortable : true

		}, {
			header : '��������',
			dataIndex : 'methodName',
			width : 350,
			align : 'left',
			sortable : true

		}, {
			header : '����ֵ����',
			dataIndex : 'ReturnType',
			width : 60,
			align : 'left',
			hidden : true,
			sortable : true

		}, {
			header : '����ֵ����',
			dataIndex : 'ReturnTypeName',
			width : 70,
			align : 'left',
			hidden : true,
			sortable : true

		}, {
			header : '��ע˵��',
			dataIndex : 'ReturnName',
			width : 120,
			align : 'left',
			
			sortable : true

		}, {
			header : '�Ƿ���Ч',
			dataIndex : 'active',
			width : 65,
			align : 'left',
			sortable : true,
			renderer : function(v, p, record) {
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'
						+ (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id
						+ '">&#160;</div>';
			}

		}]);

var InterLocPagingToolbar = new Ext.PagingToolbar({// ��ҳ������
	pageSize : 25,
	store : InterMethodDs,
	displayInfo : true,
	displayMsg : '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg : "û������"
		// buttons : ['-', InterLocFilterItem, '-', InterLocSearchBox]
});

var InterMethodMain = new Ext.grid.GridPanel({// ���
	title : '�ӿڷ���ά��',
	store : InterMethodDs,
	height : 560,

	cm : InterMethodCm,
	trackMouseOver : true,
	region : 'center',
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	loadMask : true,
	frame : false,

	clicksToEdit : 2,
	stripeRows : true,
	tbar : ['-', addInterLocButton, '-', editInterLocButton, '-', editButton],
	bbar : InterLocPagingToolbar
});

// �����ӿڷ���ʱ��ʾ�ӿڲ���
InterMethodMain.on('rowclick', function(grid, rowIndex, e) {

			var selectedRow = InterMethodDs.data.items[rowIndex];

			methodRowId = selectedRow.data["rowid"];

			InterMethodParamDs.proxy = new Ext.data.HttpProxy({
						url : InterLocUrl + '?action=paramlist&rowid='
								+ methodRowId,
						method : 'POST'
					});
			InterMethodParamDs.load({
						params : {
							start : 0,
							limit : InterLocPagingToolbar.pageSize
						}
					});

		});

interLocSetField.on('select', function(cmb, rec, id) {
			InterMethodDs.proxy = new Ext.data.HttpProxy({
						url : InterLocUrl + '?action=list&interLocSetDr='
								+ interLocSetField.getValue(),
						method : 'POST'
					});
			InterMethodDs.load({
						params : {
							start : 0,
							limit : InterLocPagingToolbar.pageSize
						}
					});
		});

InterMethodDs.load({
			params : {
				start : 0,
				limit : InterLocPagingToolbar.pageSize
			}
		});
