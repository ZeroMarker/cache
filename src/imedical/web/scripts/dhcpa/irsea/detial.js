

//*name:�Բ���ϸ
  //*author:�Ʒ��
  //*Date:2015-5-18


sysdeptkindeditFun = function(submitStateName,rowid) {
//���α��
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
			dataUrl : "../csp/dhc.pa.uirseaexe.csp?action=detailList",
			clearOnLoad : true,
			uiProviders : {
				'col' : Ext.tree.ColumnNodeUI
			}
		});

// ���νṹ�ĸ�
var detailTreeRoot = new Ext.tree.AsyncTreeNode({
			id : '0',
			text : '�ϼ�',
			value : '',
			expanded : false
		});

// ����ǰ�¼�
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

var detailReportTitle="�����Բ�"
// ���ͽṹ����
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
						
						header : '�Բ���Ŀ',
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
						
						header : '�����',
						align : 'right',
						width : 100,
						dataIndex : 'mid'
						
					}, {
						
						header : '�Ҫ��',
						align : 'right',
						width : 120,
						dataIndex : 'mn'
					}/*, {
						
						header:'����',
						width:80,
					    editable:false,
						align:'left',
						dataIndex:'cd',				
						renderer : function(value, record,node,store){
								//alert(itemGrid1);
							var sf = record.attributes["leaf"]
							if (sf == true) {
							return '<span style="color:blue"><u>����</u></span>';
							//return '<span style="color:gray;cursor:hand">���</span>';
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

	// ������������һ��������ʽ��'i'�������ִ�Сд
	var re = new RegExp(Ext.escapeRe(text), 'i');
	// ��Ҫ��ʾ�ϴ����ص��Ľڵ�
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
// ��ȡҪ�����Ľڵ�
var getNode = function() {
	return detailReport.getSelectionModel().getSelectedNode();
}
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
this.filterFieldName = new Ext.form.TextField({
			name : 'fdcName'
		});

detailReport.on('render', function() {
			// alert('aa');
		});

/*detailReport.on('click',function(node, e){
	
	var sf = node.attributes["leaf"];				
		
	if (sf == true) {
	 
		 //�ϴ���¼ID
		var UDRDDr = node.attributes["Rowid"];				
		
		  //return '<span style="color:gray;cursor:hand">����</span>';	
			                  
		downloadFun(UDRDDr,detailReport);
	}
	else{}
	
});*/
	 

var cancelButton = new Ext.Toolbar.Button({ text : '�ر�'});
	// ����ȡ����ť����Ӧ����
	cancelHandler = function(){ 
	  window.close();
	};
	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
	
	
	
	var winTitle="�����Բ�"
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
