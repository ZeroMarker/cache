var bookID = IsExistAcctBook();
var userdr = session['LOGON.USERID']; //登录人ID
var DebitGrid = new dhc.herp.Grid({
		iconCls: 'list',
		title: '借方',
		region: 'center',
		url: 'herp.acct.acctmanualdealcacelexe.csp',
		atLoad: true, // 是否自动刷新
		//split : true,
		//viewConfig : {forceFit : true},
		fields: [new Ext.grid.CheckboxSelectionModel({
				editable: false
			}),
			//  s jsonTitle="rowid^AmtDebit^AcctYear^AcctMonth^Summary^OrderID^VouchDate^VouchNo^CheckFund^CheckerName^CheckDate"
			{
				id: 'rowid',
				header: 'ID',
				allowBlank: false,
				width: 100,
				editable: false,
				hidden: true,
				dataIndex: 'rowid'
			}, {
				id: 'AmtDebit',
				header: '<div style="text-align:center">借方金额</div>',
				allowBlank: false,
				align: 'right',
				editable: false,
				width: 150,
				update: true,
				type: 'numberField',
				dataIndex: 'AmtDebit'
			}, {
				id: 'AcctYear',
				header: '<div style="text-align:center">会计年度</div>',
				align: 'center',
				//hidden:false,
				width: 80,
				editable: false,
				dataIndex: 'AcctYear'

			}, {
				id: 'AcctMonth',
				header: '<div style="text-align:center">会计月份</div>',
				align: 'center',
				editable: false,
				width: 80,
				hidden: false,
				dataIndex: 'AcctMonth'
			}, {
				id: 'Summary',
				header: '<div style="text-align:center">摘要</div>',
				align: 'left',
				editable: false,
				width: 200,
				hidden: false,
				dataIndex: 'Summary'
			}, {
				id: 'OrderID',
				header: '<div style="text-align:center">票据号</div>',
				editable: false,
				width: 120,
				editable: false,
				dataIndex: 'OrderID'
			}, {
				id: 'VouchDate',
				header: '凭证日期',
				align: 'center',
				editable: false,
				width: 100,
				hidden: false,
				dataIndex: 'VouchDate'

			}, {
				id: 'VouchNo',
				header: '凭证号',
				align: 'center',
				editable: false,
				width: 100,
				hidden: false,
				dataIndex: 'VouchNo',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
				}

			}, {
				id: 'VouchState',
				header: '凭证状态',
				align: 'center',
				editable: false,
				width: 80,
				hidden: true,
				dataIndex: 'VouchState'
			}, {
				id: 'CheckFund',
				header: '对账方式',
				editable: false,
				align: 'center',
				width: 80,
				dataIndex: 'CheckFund'
			}, {
				id: 'CheckerName',
				header: '对账人',
				editable: false,
				align: 'center',
				width: 100,
				dataIndex: 'CheckerName'
			}, {
				id: 'CheckDate',
				header: '对账日期',
				align: 'center',
				editable: false,
				width: 100,
				dataIndex: 'CheckDate'
			}
		]
	});

DebitGrid.btnAddHide(); //隐藏增加按钮
DebitGrid.btnSaveHide(); //隐藏保存按钮
DebitGrid.btnDeleteHide(); //隐藏删除按钮
DebitGrid.btnResetHide(); //隐藏重置按钮
DebitGrid.btnPrintHide(); //隐藏打印按钮

//DebitGrid.getColumnModel().setHidden(4,true);  //动态隐藏列
// DebitGrid.getColumnModel().setColumnHeader(3,"供应商辅助核算"); //动态显示标题名称

//getElementsByClassName在IE兼容模式不能用
function ifClassName(){
	document.getElementsByClassName = function (classname) {
		var children = document.getElementsByTagName('div');
		var elements = new Array();
		for (var i = 0; i < children.length; i++) {
			var child = children[i];
			var classNames = child.className.split(' ');
			for (var j = 0; j < classNames.length; j++) {
				if (classNames[j].indexOf(classname) > -1) {
					elements.push(child);
					// break;
				}
			}
		}
		return elements;
	};
}


DebitGrid.store.on('load', function () {
	// console.log(document.getElementsByClassName('x-grid3-hd-inner x-grid3-hd-checker'))
	/* if (!document.getElementsByClassName) {
		var node = ifClassName('x-grid3-hd-inner x-grid3-hd-checker');
		console.log(node)
		node[0].className="x-grid3-hd-inner x-grid3-hd-checker";
		return;
	} */ 
	document.getElementsByClassName('x-grid3-hd-inner x-grid3-hd-checker')[0].className = "x-grid3-hd-inner x-grid3-hd-checker"; //.checked=false;

});

//凭证链接
DebitGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {

	if (columnIndex == '9') {
		//p_URL = 'acct.html?acctno=2';
		//document.getElementById("frameReport").src='acct.html';
		var records = DebitGrid.getSelectionModel().getSelections();
		var VouchNo = records[0].get("VouchNo");
		var VouchState = records[0].get("VouchState");
		var myPanel = new Ext.Panel({
				layout: 'fit',
				//scrolling="auto"
				html: '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userdr + '&acctstate=' + VouchState + '&bookID=' + bookID + '&SearchFlag=' + '1' + '" /></iframe>'
				// frame : true
			});

		var win = new Ext.Window({
				title: '凭证查看',
				width: 1093,
				height: 620,
				resizable: false,
				closable: true,
				draggable: true,
				resizable: false,
				layout: 'fit',
				modal: false,
				plain: true, // 表示为渲染window body的背景为透明的背景
				//bodyStyle : 'padding:5px;',
				items: [myPanel],
				buttonAlign: 'center',
				buttons: [{
						text: '关闭',
						type: 'button',
						handler: function () {
							win.close();
						}
					}
				]
			});
		win.show();
	}
});

var CreditGrid = new dhc.herp.GridMain({
		title: '贷方', //是否可编辑
		iconCls: 'list',
		readerModel: 'remote',
		// url: 'herp.acct.vouchtypeexe.csp',
		url: 'herp.acct.acctmanualdealcacelcreditexe.csp',
		atLoad: true, // 是否自动刷新
		loadmask: true,
		region: 'south',
		split: true,
		height: 250,

		//viewConfig : {forceFit : true},
		fields: [new Ext.grid.CheckboxSelectionModel({
				editable: false
			}), {
				id: 'rowid',
				header: 'ID',
				allowBlank: false,
				width: 100,
				editable: false,
				hidden: true,
				dataIndex: 'rowid'
			}, {
				id: 'AmtCredit',
				header: '<div style="text-align:center">贷方金额</div>',
				allowBlank: false,
				align: 'right',
				editable: false,
				width: 150,
				update: true,
				type: 'numberField',
				dataIndex: 'AmtCredit'
			}, {
				id: 'AcctYear',
				header: '<div style="text-align:center">会计年度</div>',
				align: 'center',
				editable: false,
				//hidden:false,
				width: 80,
				editable: false,
				dataIndex: 'AcctYear'

			}, {
				id: 'AcctMonth',
				header: '<div style="text-align:center">会计月份</div>',
				align: 'center',
				editable: false,
				width: 80,
				hidden: false,
				dataIndex: 'AcctMonth'
			}, {
				id: 'Summary',
				header: '<div style="text-align:center">摘要</div>',
				align: 'left',
				editable: false,
				width: 200,
				hidden: false,
				dataIndex: 'Summary'
			}, {
				id: 'OrderID',
				header: '<div style="text-align:center">票据号</div>',
				align: 'center',
				width: 120,
				editable: false,
				dataIndex: 'OrderID'
			}, {
				id: 'VouchDate',
				header: '凭证日期',
				align: 'center',
				editable: false,
				width: 100,
				hidden: false,
				dataIndex: 'VouchDate'

			}, {
				id: 'VouchNo',
				header: '凭证号',
				align: 'center',
				editable: false,
				width: 100,
				hidden: false,
				dataIndex: 'VouchNo',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
				}
			}, {
				id: 'VouchState',
				header: '凭证状态',
				editable: false,
				align: 'center',
				width: 80,
				hidden: true,
				dataIndex: 'VouchState'
			}, {
				id: 'CheckFund',
				editable: false,
				header: '对账方式',
				align: 'center',
				width: 80,
				dataIndex: 'CheckFund'
			}, {
				id: 'CheckerName',
				header: '对账人',
				editable: false,
				align: 'center',
				width: 100,
				dataIndex: 'CheckerName'
			}, {
				id: 'CheckDate',
				header: '对账日期',
				editable: false,
				align: 'center',
				width: 100,
				dataIndex: 'CheckDate'
			}
		]
	});
/*
CreditGrid.hiddenButton(1); 	//隐藏增加按钮
CreditGrid.hiddenButton(2); 	//隐藏保存按钮
CreditGrid.hiddenButton(3); //隐藏删除按钮
CreditGrid.hiddenButton(4) 	//隐藏重置按钮
CreditGrid.hiddenButton(5) 	//隐藏打印按钮 */

CreditGrid.store.on('load', function () {
	/* if (!document.getElementsByClassName) {
		var node = ifClassName('x-grid3-hd-inner x-grid3-hd-checker');
		node[1].className = "x-grid3-hd-inner x-grid3-hd-checker";
		return;
	} */
	document.getElementsByClassName('x-grid3-hd-inner x-grid3-hd-checker')[1].className = "x-grid3-hd-inner x-grid3-hd-checker";
});

//凭证链接
CreditGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {

	if (columnIndex == '9') {
		//p_URL = 'acct.html?acctno=2';
		//document.getElementById("frameReport").src='acct.html';
		var records = CreditGrid.getSelectionModel().getSelections();
		var VouchNo = records[0].get("VouchNo");
		var VouchState = records[0].get("VouchState");
		var myPanel = new Ext.Panel({
				layout: 'fit',
				//scrolling="auto"
				html: '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userdr + '&acctstate=' + VouchState + '&bookID=' + bookID + '&SearchFlag=' + '1' + '" /></iframe>'
				// frame : true
			});

		var win = new Ext.Window({
				title: '凭证查看',
				width: 1093,
				height: 620,
				resizable: false,
				closable: true,
				draggable: true,
				resizable: false,
				layout: 'fit',
				modal: false,
				plain: true, // 表示为渲染window body的背景为透明的背景
				//bodyStyle : 'padding:5px;',
				items: [myPanel],
				buttonAlign: 'center',
				buttons: [{
						text: '关闭',
						type: 'button',
						handler: function () {
							win.close();
						}
					}
				]
			});
		win.show();
	}
});
