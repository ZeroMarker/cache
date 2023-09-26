

//*name:自查明细
  //*author:黄凤杰
  //*Date:2015-5-18


sysdeptkindeditFun = function(submitStateName,rowid) {
//树形表格
/**
 * name:bonusunit author:liuyang Date:2011-1-19
 */

// ================去掉字符串空格==============================
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
// ============================================================
// ================定义ColumnTree的相关信息====================
// 树形结构导入器
var detailTreeLoader = new Ext.tree.TreeLoader({
			dataUrl : "../csp/dhc.pa.uirseaexe.csp?action=detailList",
			clearOnLoad : true,
			uiProviders : {
				'col' : Ext.tree.ColumnNodeUI
			}
		});

// 树形结构的根
var detailTreeRoot = new Ext.tree.AsyncTreeNode({
			id : '0',
			text : '合计',
			value : '',
			expanded : false
		});

// 加载前事件
detailTreeLoader.on('beforeload', function(detailTreeLoader, node) {

			if (detailTreeRoot.value != "undefined") {
				
				var start="0"
				var limit="100"
				
			
				
				var url = "../csp/dhc.pa.uirseaexe.csp?action=detailList";
				// alert(url)
				detailTreeLoader.dataUrl = url + "&submitStateName=" + encodeURIComponent

(submitStateName) + "&rowid=" + rowid+"&parent=" + node.id  ;
			}
		});

var detailReportTitle="科室自查"
// 树型结构定义
var detailReport = new Ext.tree.ColumnTree({
			id : 'detailReport',
			region: 'center',
			rootVisible :false,
			autoScroll : true,
			expandable:false,
            enableDD:true,
            animate:true,
            useArrows : true,
             
			title : detailReportTitle,
			sm:'sm',
			columns : [ {
						
						header : '自查项目',
						align : 'right',
						width :300,
						dataIndex : 'ufn'
					},/* {
				id:'Rowid',
				width:120,
			    editable:false,
				allowBlank:false,
				align:'left',
				dataIndex:'id',
				hidden:true	
			},*/{
						
						header : '填报内容',
						align : 'right',
						width : 100,
						dataIndex : 'mid'
						
					}, {
						
						header : '填报要求',
						align : 'right',
						width : 120,
						dataIndex : 'mn'
					}/*, {
						
						header:'附件',
						width:80,
					    editable:false,
						align:'left',
						dataIndex:'cd',				
						renderer : function(value, record,node,store){
								//alert(itemGrid1);
							var sf = record.attributes["leaf"]
							if (sf == true) {
							return '<span style="color:blue"><u>下载</u></span>';
							//return '<span style="color:gray;cursor:hand">审核</span>';
							}
							else{}
					    } 

				}*/],
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

	// 根据输入制作一个正则表达式，'i'代表不区分大小写
	var re = new RegExp(Ext.escapeRe(text), 'i');
	// 先要显示上次隐藏掉的节点
	Ext.each(hiddenPkgs, function(n) {
				n.ui.show();
			});

	if (!text) {
		this.treeFilter.clear();
		return;
	}

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
// 获取要操作的节点
var getNode = function() {
	return detailReport.getSelectionModel().getSelectedNode();
}
// 收缩展开动作执行函数
function detailReportControl() {
	if (colButton.getText() == '全部展开') {
		colButton.setText('全部收缩');
		detailReport.expandAll();
	} else {
		colButton.setText('全部展开');
		detailReport.collapseAll();
	}
};
this.filterFieldName = new Ext.form.TextField({
			name : 'fdcName'
		});

detailReport.on('render', function() {
			// alert('aa');
		});

/*detailReport.on('click',function(node, e){
	
	var sf = node.attributes["leaf"];				
		
	if (sf == true) {
	 
		 //上传记录ID
		var UDRDDr = node.attributes["Rowid"];				
		
		  //return '<span style="color:gray;cursor:hand">下载</span>';	
			                  
		downloadFun(UDRDDr,detailReport);
	}
	else{}
	
});*/
	 

var cancelButton = new Ext.Toolbar.Button({ text : '关闭'});
	// 定义取消按钮的响应函数
	cancelHandler = function(){ 
	  window.close();
	};
	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
	
	
	var winTitle="科室自查"
	var window = new Ext.Window({
				layout : 'border',
				title : winTitle,
				plain : true,
				width : 960,
				height : 600,
				modal : true,
				autoScroll : true,
				buttonAlign : 'center',
				items : [detailReport],			
				buttons : [cancelButton]
			});
	window.show();
	

}
