/**
 * name:bonusunit author:liuyang Date:2011-1-19
 */

// ================ȥ���ַ����ո�==============================
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
// ============================================================
// ================����ColumnTree�������Ϣ====================
// ���νṹ������
var detailTreeLoader = new Ext.tree.TreeLoader({
			dataUrl : "../csp/dhc.bonus.bonusunitexe.csp?action=list",
			clearOnLoad : true,
			uiProviders : {
				'col' : Ext.tree.ColumnNodeUI
			}
		});

// ���νṹ�ĸ�
var detailTreeRoot = new Ext.tree.AsyncTreeNode({
			id : 'roo',
			text : '������㵥Ԫ����',
			value : '',
			expanded : false
		});

// ����ǰ�¼�
detailTreeLoader.on('beforeload', function(detailTreeLoader, node) {

			if (detailTreeRoot.value != "undefined") {
				var url = "../csp/dhc.bonus.bonusunitexe.csp?action=list";
				// alert(url)
				detailTreeLoader.dataUrl = url + "&parent=" + node.id;
			}
		});

// ����չ����ť
var colButton = new Ext.Toolbar.Button({
			text : 'ȫ������',
			tooltip : '���ȫ��չ����ر�',
			listeners : {
				click : {
					fn : detailReportControl
				}
			}
		});

// ���ͽṹ����
var detailReport = new Ext.tree.ColumnTree({
			id : 'detailReport',
			height : 690,
			width : 1100,
			rootVisible : true,
			autoScroll : true,
			title : '������㵥Ԫ����',
			columns : [{
						header : '������㵥Ԫ����',
						align : 'right',
						width : 250,
						dataIndex : 'nm'
					}, {
						header : '����Ԫ����',
						width : 100,
						dataIndex : 'cd'
					}, {
						header : '���ſ���',
						align : 'right',
						width : 110,
						dataIndex : 'mn'
					}, {
						header : '��Ԫ����',
						align : 'right',
						width : 100,
						dataIndex : 'ufn'
					}, {
						header : '�����������',
						align : 'right',
						width : 120,
						dataIndex : 'btn'
					}/*, {
						header : '��ְ����',
						align : 'right',
						width : 120,
						dataIndex : 'sd'
					}*/
					/*, {
						header : '�ϼ�����Ԫ',
						align : 'right',
						width : 120,
						dataIndex : 'sn'
					}*/, {
						header : 'ĩ����־',
						align : 'right',
						width : 80,
						dataIndex : 'ls',
						renderer : function(v, p, record) {
							p.css += ' x-grid3-check-col-td';
							return '<div class="x-grid3-check-col'
									+ (v == 1 ? '-on' : '') + ' x-grid3-cc-'
									+ this.id + '">&#160;</div>';
						}
					}, {
						header : '��Ԫ����',
						align : 'right',
						width : 110,
						dataIndex : 'lv'
					}],
			loader : detailTreeLoader,
			root : detailTreeRoot
		});
// this.add(this.tree);
var treeFilter = new Ext.tree.TreeFilter(detailReport, {
			clearBlank : true,
			autoClear : true
		});

// detailReport.expandAll();
var hiddenPkgs = [];
// this.matched = [];
var filterByName = function() {

	var text = this.filterFieldName.getValue();

	// ������������һ��������ʽ��'i'�������ִ�Сд
	var re = new RegExp(Ext.escapeRe(text), 'i');
	// ��Ҫ��ʾ�ϴ����ص��Ľڵ�
	Ext.each(hiddenPkgs, function(n) {
				n.ui.show();
			});

	// this.matched = [];
	// �����������ݲ����ڣ���ִ��clear()
	if (!text) {
		this.treeFilter.clear();
		return;
	}
	// detailReport.expandAll();
	// setTimeout(detailReport.expandAll(),5000)

	// �ҳ�����ƥ��Ľ��
	/*
	 * detailReport.root.cascade(function(n) { alert(n.attributes.text);
	 * if(re.test(n.attributes['fdcName'])){ this.matched.push(n); } },this);
	 */

	this.treeFilter.filterBy(function(n) {

				return !n.isLeaf() || re.test(n.text);
			});

	hiddenPkgs = [];
	detailReport.root.cascade(function(n) {
				// alert("aaaa")
				if (!n.isLeaf() && n.ui.ctNode.offsetHeight < 3
						&& !re.test(n.text)) {

					n.ui.hide();
					hiddenPkgs.push(n);
				}
				if (n.id != 'roo') {

					if (!n.isLeaf() && n.ui.ctNode.offsetHight >= 3
							&& hasChild(n, re) == false && !re.test(n.text)) {

						n.ui.hide();
						hiddenPkgs.push(n);
					}
				}
			});

	function hasChild(n, re) {
		var str = false;
		n.cascade(function(n1) {
					if (n1.isLeaf() && re.test(n1.attributes.text)) {
						str = true;
						return;
					}
				});
		return str;
	}



};

// ��ȡҪ�����Ľڵ�
var getNode = function() {
	return detailReport.getSelectionModel().getSelectedNode();
}
// ================���幤�����Լ���ӡ��޸ġ�ɾ����ť==========
// ��Ӱ�ť

var addButton = new Ext.Toolbar.Button({
			text : '���',
			tooltip : '���',
			iconCls : 'add',
			handler : function() {
				addFun(getNode());
			}
		});
// �޸İ�ť
var updateButton = new Ext.Toolbar.Button({
			text : '�޸�',
			tooltip : '�޸�',
			iconCls : 'option',
			handler : function() {
				updateFun(getNode());
			}
		});
// ɾ����ť
var delButton = new Ext.Toolbar.Button({
			text : 'ɾ��',
			tooltip : 'ɾ��',
			iconCls : 'add',
			handler : function() {
				delFun(getNode());
			}
		});
// ��ѯ��ť
this.filterBtn = new Ext.Button({
			text : '��ѯ',
			scope : this,
			iconCls : 'option',
			// icon:ctx+'/images/task/buttonicon/addtask.gif',
			handler : function(b, e) {
				detailReport.expandAll();
				setTimeout(filterByName, 5000);
			}
		});

var expandAllBtn = new Ext.Button({
			text : 'ȫ��չ��',
			scope : this,
			iconCls : 'option',
			// icon:ctx+'/images/task/buttonicon/addtask.gif',
			handler : function(b, e) {
				detailReport.expandAll();
			}
		});
this.filterFieldName = new Ext.form.TextField({
			name : 'fdcName'
		});

// ��ʼ����ť
var uploadButton = new Ext.Toolbar.Button({
			text : '������Ա��Ϣ',
			tooltip : '���µ������µĿ�����Ϣ��',
			iconCls : 'add',
			handler : function() {

				importExcel();

				return;

			}

		});

// ============================================================
// ������
var menubar = [expandAllBtn, '-', filterFieldName, '-', filterBtn, '-',
		addButton, '-', updateButton, '-', delButton];
// ============================================================

// ================�����ȡҪ�����ڵ�ĺ���====================

// ����չ������ִ�к���
function detailReportControl() {
	if (colButton.getText() == 'ȫ��չ��') {
		colButton.setText('ȫ������');
		detailReport.expandAll();
	} else {
		colButton.setText('ȫ��չ��');
		detailReport.collapseAll();
	}
};
// ============================================================

detailReport.on('render', function() {
			// alert('aa');
		});