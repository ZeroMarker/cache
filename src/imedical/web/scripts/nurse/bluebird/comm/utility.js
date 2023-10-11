/// EH 2014-04-23
var loadDataArray = [];
var parameterObject = {};

function CreateStore(className, methodName) {
	var store = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: '../csp/dhc.nurse.ext.common.getdataold.csp'
		}),
		reader: new Ext.data.JsonReader(eval('(' + tkMakeServerCall('Nur.QueryBroker', 'GenerateMetaData', className, methodName) + ')')),
		baseParams: {
			className: className,
			methodName: methodName,
			type: 'QueryW'
		}
	});
	return store;
}

function AddLoadData(a, b) {
	var data = [];
	data[0] = a;
	data[1] = b;
	loadDataArray[loadDataArray.length] = data;
}

function CreateStoreSimple(displayField, valueField, className, methodName, queryParam) {
	loadDataArray = [];
	var ret = tkMakeServerCall(className, methodName, queryParam, 'AddLoadData');
	var store = new Ext.data.SimpleStore({
		fields: [displayField, valueField],
		data: loadDataArray
	});
	return store;
}

function CreateComboBoxSimple(id, displayField, valueField, width, className, methodName, queryParam) {
	var combox = new Ext.form.ComboBox({
		id: id,
		store: CreateStoreSimple(displayField, valueField, className, methodName, queryParam),
		valueField: valueField,
		displayField: displayField,
		typeAhead: true,
		mode: 'local',
		triggerAction: 'all',
		selectOnFocus: false,
		width: width
	});
	return combox;
}

function CreateComboBox(id, displayField, valueField, width, className, methodName, queryParam) {
	var combox = new Ext.form.ComboBox({
		store: CreateStore(className, methodName),
		displayField: displayField,
		valueField: valueField,
		id: id,
		value: '',
		width: width,
		hideTrigger: true,
		queryParam: queryParam,
		forceSelection: true,
		triggerAction: 'all',
		minChars: 0,
		pageSize: 10,
		typeAhead: false,
		typeAheadDelay: 1000,
		loadingText: 'Searching...'
	});
	combox.on('expand', function(comboBox) {
		comboBox.list.setWidth('auto');
		comboBox.innerList.setWidth('auto');
	}, this, {
		single: true
	});
	return combox;
}

function CreateTree(patientTree) {
	var loader = new Ext.tree.TreeLoader({
		dataUrl: '../csp/dhc.nurse.ext.common.getdataold.csp?className=Nur.QueryBroker&methodName=GetTree&type=Method&ctlocDr=' + session['LOGON.CTLOCID'] + '&adm=' + EpisodeID
	});
	var root = new Ext.tree.AsyncTreeNode({
		checked: false,
		text: '全病区',
		iconCls: 'all'
	});
	var tree = new Ext.tree.TreePanel({
		root: root,
		id: 'patientTree',
		rootVisible: true,
		height: 100,
		width: 200,
		containerScroll: true,
		autoScroll: true,
		loader: loader
	})
	return tree;
}

Ext.Button.prototype.Ajax = {
	url: '../csp/dhc.nurse.ext.common.getdataold.csp',
	validity: false,
	success: function(response, options) {
		var rtn = response.responseText;
		if (rtn) {
			var defaultSuc = '操作成功!';
			var defaultFai = '操作失败!';
			var rtn1 = rtn.split('^');
			rtn1[0] = rtn1[0].replace(/\r\n/g, '');
			if (!rtn1[1]) {
				if (rtn1[0] == '0') {
					rtn1[1] = defaultSuc;
				}
			}
			var msg1 = rtn1[1] ? rtn1[1] : defaultFai;
			if (isNaN(rtn1[0])) {
				msg1 = '执行操作过程中发生了以下错误：\n' + rtn;
			}
			if ((msg1 == defaultSuc) || (msg1 == defaultFai)) {
				Ext.Msg.show({
					title: '提示',
					msg: msg1,
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
			} else {
				alert(msg1)
			}
			return (rtn1[0] == '0');
		}
		return false;
	},
	failure: function(response, options) {
		Ext.Msg.show({
			title: '提示',
			msg: '操作失败!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return false;
	},
	request: function(params, callback) {
		var obj = {};
		obj.url = this.url;
		var that = this;
		obj.success = function(response, options) {
			that.validity = that.success(response, options);
			((callback) && (that.validity == true)) ? callback(response, options) : '';
		};
		obj.failure = function(response, options) {
			that.validity = that.failure(response, options);
		};
		obj.params = {
			type: 'MethodW'
		};
		Ext.apply(obj.params, params || {});
		Ext.Ajax.request(obj);
	}
};

function CreateTitle(id, value, type) {
	if (id == '') {
		return '';
	}
	var cursor = 'pointer';
	if (type != 'button') {
		type = 'label';
		ursor = 'auto';
	}
	var title = '<input type=\'' + type + '\' id=\'' + id + 'Title\' onclick=\'\' onmousedown=\'function() { this.blur(); }\' oncontextmenu=\'function() { return false; }\' style=\'{ border:0 none; background:transparent; position:absolute; padding:0; cursor:' + cursor + '; margin:0 0 0 3px; width:auto; -moz-outline:0 none; outline:0 none; font:bold 13px tahoma,arial,verdana,sans-serif; color:#15428b; height:14px !important; overflow:hidden; }\' value=\'' + value + '\' />';
	return title;
}

function CreateModel(headerStr, columnStr, widthStr, typeStr) {
	var headerArray = headerStr.split('^');
	var columnArray = columnStr.split('^');
	var widthArray = widthStr.split('^');
	var typeArray = typeStr.split('^');
	var cms = [];
	for (var i = 0; i < headerArray.length; i++) {
		var header = {
			header: headerArray[i],
			dataIndex: columnArray[i],
			width: widthArray[i],
			hidden: (typeArray[i].toUpperCase() == 'HIDDEN')
		};
		cms[cms.length] = header;
	}
	var columnModel = {
		cms: cms
	};
	return columnModel;
} 

function CreateGrid(className, methodName, columnModel, id, title, width, height, pageSize) {
	var colModel = new Ext.grid.ColumnModel({
		columns: columnModel.cms || [],
		defaults: {
			sortable: false,
			menuDisabled: true
		}
	});
	var selModel = new Ext.grid.RowSelectionModel({
		singleSelect: false
	});
	var store = CreateStore(className, methodName);
	Ext.apply(store, {
		autoLoad: false
	});
	store.on('loadexception', function(a, b, c) {
		var re = c.responseText;
		alert('加载页面过程中发生了以下错误：\n' + re);
		return;
	});
	var bbar = new Ext.PagingToolbar({
		store: store,
		pageSize: pageSize || 20,
		displayInfo: true,
		displayMsg: 'Displaying {0} - {1} of {2}',
		emptyMsg: 'No data to display',
		beforePageText: 'Page',
		afterPageText: 'of {0}',
		firstText: 'First Page',
		prevText: 'Previous Page',
		nextText: 'Next Page',
		refreshText: 'Refresh'
	});
	var loadMask = {
		msg: '<font size=-1><b>' + 'Now loading data, please wait...' + '</b></font>'
	};
	var panel = new Ext.grid.GridPanel({
		store: store,
		id: id,
		title: title,
		width: width,
		height: height,
		colModel: colModel,
		pageSize: pageSize || 20,
		viewConfig: {
			forceFit: false
		},
		loadMask: loadMask,
		tbar: [],
		bbar: bbar,
		selModel: selModel,
		cmHandler: function(cms) {
			var colModel = cms;
			if (colModel.columns) {
				cms = colModel.columns;
			}
			var num = cms.length;
			var selection = 'selection';
			for (var i = 0; i < num; i++) {
				var cmi = cms[i].dataIndex;
				cms[i].width = cms[i].width * .7;
				if (cmi == '') { continue; }
				if (cmi.indexOf(selection) > -1) {
					cms[i].fixed = true;
					var id = this.id + 'chb' + '_';
					cms[i].header = '<input type=\'checkbox\' id=\'' + id + 'a' + '\' onclick=\'' + '' + '\' />';
					var that = this;
					cms[i]['renderer'] = function(val, meta, rec, row, col, store) {
						var id = that.id + 'chb' + '_';
						return '<input type=\'checkbox\' id=\'' + id + row + '\' onclick=\'' + ''+ '\' />';
					};
				}
			}
			if (colModel.columns) {
				colModel.columns = cms;
				cms = colModel;
			}
			return cms;
		}
	});
	Ext.applyIf(panel, {
		loading: false,
		rcValue: {},
		rcColor: {},
		getColumnIndex: function(field) {
			var colModel = this.colModel;
			if (colModel.columns) {
				cms = colModel.columns;
			}
			var num = cms.length;
			for (var i = 0; i < num; i++) {
				if (cms[i].dataIndex == field) {
					return i;
				}
			}
			return -1;
		},
		renderColor: function(field, value, target, color) {
			var colModel = this.colModel;
			if (colModel.columns) {
				cms = colModel.columns;
			}
			var v0 = field + '_' + target;
			var v1 = this.rcValue[v0];
			var v3 = this.rcColor[v0];
			var rendered = true;
			if ((!v1) || (!v3)) {
				rendered = false;
				v1 = [];
				v3 = [];
			}
			if ((v1.indexOf(value) > -1) && (v3.indexOf(color) > -1)) {
				return;
			}
			var length = v1.length;
			v1[length] = value;
			v3[length] = color;
			this.rcValue[v0] = v1;
			this.rcColor[v0] = v3;
			if (rendered) {
				return;
			}
			var fi = this.getColumnIndex(field);
			var ti = this.getColumnIndex(target);
			if (fi < 0) {
				return;
			} else if (ti > -1) {
				var that = this;
				cms[ti]['renderer'] = function(val, meta, rec, row, col, store) {
					if (that.rcValue[v0]) {
						var thatval = '';
						var length = that.rcValue[v0].length;
						for (var i = 0; i < length; i++) {
							if (rec.json[field].indexOf(that.rcValue[v0][i]) > -1 ) {
								thatval += '<td width=\'20px\'><input type=\'text\' disabled=\'disabled\' id=\'' + v0 + i + '\' text=\'\' style=\'background:' + that.rcColor[v0][i] + ';\''+ ' /></td>';
							}
						}
						if (thatval) {
							thatval = '<table><tr>' + thatval + '</tr></table>';
							return thatval;
						}
					}
					return val;
				}
			}
			if (colModel.columns) {
				colModel.columns = cms;
				cms = colModel;
			}
			this.colModel = cms;
		}
	});
	Ext.applyIf(panel, {
		initializeLoading: function(){
			var that = this;
			this.colModel = this.cmHandler(this.colModel);
			this.store.on('load', function(store, rec, option) {
				that.loading = false;
				var id = that.id + 'chb' + '_';
				var obj = document.getElementById(id + 'a');
				if (obj) {
					obj.checked = false;
					obj.onclick = function() {
						try {
							Select_Row(that.id, 'a');
						} catch(e){
						}
					};
				}
				store.each(function(r, i) {
					obj = document.getElementById(id + i);
					if (obj) {
						obj.checked = false;
						obj.onclick = function(o) {
							try {
								Select_Row(that.id, i);
							} catch(e){
							}
						}
					}
				});
			});
			this.store.on('beforeload', function(store, option) {
				if (that.loading == true) {
					return false;
				} else {
					that.loading = true;
				}
				return true;
			});	
		}
	});
	panel.initializeLoading();
	return panel;
}

function getToday(plus) {
	(plus == undefined) ? (plus = 0) : '';
	var today = tkMakeServerCall('Nur.Utility', 'getToday', plus);
	return today;
}

function getTime(plus) {
	(plus == undefined) ? (plus = 0) : '';
	var now = tkMakeServerCall('Nur.Utility', 'getTime', plus);
	if (now == '') {
		now = '00:00';
	}
	return now;
}

function ReloadData(panel, otherParams) {
	parameterObject[panel.id] = otherParams;
	Ext.apply(panel.store.baseParams, otherParams);
	panel.store.load();
}
