
// ================去掉字符串空格==============================
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
// ============================================================
// ================定义ColumnTree的相关信息====================
// 树形结构导入器
var detailTreeLoader = new Ext.tree.TreeLoader({
			dataUrl : "../csp/herp.budg.moneyprojectexe.csp?action=list",
			clearOnLoad : true,
			uiProviders : {
				'col' : Ext.tree.ColumnNodeUI
			}
		});

// 树形结构的根
var detailTreeRoot = new Ext.tree.AsyncTreeNode({
			id : 'roo',
			text : '现金流量项目表',
			value : '',
			expanded : false
		});

// 加载前事件
detailTreeLoader.on('beforeload', function(detailTreeLoader, node) {

			//alert(detailTreeRoot.value);
			//alert(node.Code);
			if (detailTreeRoot.value !== 'undefined') {
				var url = "../csp/herp.budg.moneyprojectexe.csp?action=list";
				//alert(url)
				detailTreeLoader.dataUrl = url + "&parent=" + node.id;
			}
		});

// 收缩展开按钮
var colButton = new Ext.Toolbar.Button({
			text : '全部收缩',
			tooltip : '点击全部展开或关闭',
			listeners : {
				click : {
					fn : itemGridControl
				}
			}
		});

var stateFieldStore = new Ext.data.SimpleStore({
						fields:['key','keyValue'],
						data:[['1','有效'],['2','无效']]
					});
					var stateField = new Ext.form.ComboBox({
						id: 'stateField',
						fieldLabel: '状态',
						width:120,
						allowBlank: false,
						store: stateFieldStore,
						anchor: '90%',
						displayField: 'keyValue',
						valueField: 'key',
						triggerAction: 'all',
						// emptyText:'选择模块名称...',
						mode: 'local', // 本地模式
						pageSize: 10,
						minChars: 15,
						selectOnFocus:true,
						forceSelection:true
					});	

// 树型结构定义
var itemGrid = new Ext.tree.ColumnTree({
			id : 'itemGrid',
			height : 690,
			width : 1100,
			rootVisible : true,
			autoScroll : true,
			title : '现金流量项目设置',	
			columns : [
		{
            header: '项目名称',
			width:220,
			align : 'right',
            dataIndex: 'Name'
        },{
            header: '拼音码',
			width:120,
            dataIndex: 'Mnemonics'
        },{
						
            header: '项目编码',
			width:150,
            dataIndex: 'Code'
        },{
            header: '状态',
			width:80,
            dataIndex: 'State'
        },{
            header: '层次',
			width:80,
            dataIndex: 'Level'
        },{
            header: '是否末级',
			width:80,
            dataIndex: 'IsLast'
        },{
            header: '类型',
			width:120,
            dataIndex: 'Style1'
        },{
            header: '上级编码',
			width:120,
            dataIndex: 'Superiorcode'
        },{
            header: '医疗单位',
			width:220,
			align : 'right',
            dataIndex: 'CompName'
        }],
			loader : detailTreeLoader,
			root : detailTreeRoot
		});
// this.add(this.tree);
var treeFilter = new Ext.tree.TreeFilter(itemGrid, {
			clearBlank : true,
			autoClear : true
		});



// 获取要操作的节点
var getNode = function() {
	return itemGrid.getSelectionModel().getSelectedNode();
};
// ================定义工具栏以及添加、修改、删除按钮==========
// 添加按钮

var addButton = new Ext.Toolbar.Button({
			text : '添加',
			tooltip : '添加',
			iconCls : 'add',
			handler : function() {
				addFun(getNode());
				
			}
		});
// 修改按钮
var updateButton = new Ext.Toolbar.Button({
			text : '修改',
			tooltip : '修改',
			iconCls : 'option',
			handler : function() {
				
				updateFun(getNode());
			}
		});
// 删除按钮
var delButton = new Ext.Toolbar.Button({
			text : '删除',
			tooltip : '删除',
			iconCls : 'add',
			handler : function() {
				delFun(getNode());
			}
		});
// 查询按钮
this.filterBtn = new Ext.Button({
			text : '查询',
			scope : this,
			iconCls : 'option',
			handler : function(b, e) {
				itemGrid.expandAll();
				setTimeout(filterByName, 5000);
			}
		});

var expandAllBtn = new Ext.Button({
			text : '全部展开',
			scope : this,
			iconCls : 'option',
			// icon:ctx+'/images/task/buttonicon/addtask.gif',
			handler : function(b, e) {
				itemGrid.expandAll();
			}
		});
this.filterFieldName = new Ext.form.TextField({
			name : 'fdcName'
		});



// ============================================================
// 工具栏
var menubar = [expandAllBtn, '-',
		addButton, '-', updateButton, '-', delButton];
// ============================================================

// ================定义获取要操作节点的函数====================

// 收缩展开动作执行函数
function itemGridControl() {
	if (colButton.getText() == '全部展开') {
		colButton.setText('全部收缩');
		itemGrid.expandAll();
	} else {
		colButton.setText('全部展开');
		itemGrid.collapseAll();
	}
}
// ============================================================

itemGrid.on('render', function() {
			// alert('aa');
		});