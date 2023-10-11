var userdr = session['LOGON.USERID'];

var bookID = IsExistAcctBook();

var StratagemTabUrl = '../csp/herp.acct.acctbatchauditexe.csp';

var MoidLogProxy = new Ext.data.HttpProxy({
		url: StratagemTabUrl + '?action=Vouchlist' + '&bookID=' + bookID,
		method: 'POST'
	});
var MoidLogDs = new Ext.data.Store({
		proxy: MoidLogProxy,
		//autoLoad:false,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, ['AcctVouchID', 'AcctYear', 'AcctMonth', 'VouchDate', 'VouchNo', 'VouchBillNum',
				'TotalAmtDebit', 'Operator', 'Auditor', 'Poster', 'VouchState',
				'VouchProgress', 'IsDestroy', 'IsCancel', 'VouchState1', 'Operator1', 'Auditor1', 'AcctYearMonth']),
		// turn on remote sorting
		remoteSort: true
	});
var MoidLogCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			new Ext.grid.CheckboxSelectionModel(), {
				id: 'AcctVouchID',
				header: '<div style="text-align:center">ID</div>',
				allowBlank: false,
				width: 100,
				editable: false,
				hidden: true,
				dataIndex: 'AcctVouchID'
			}, {
				id: 'AcctYear',
				header: '<div style="text-align:center">年</div>',
				width: 50,
				editable: false,
				align: 'center',
				dataIndex: 'AcctYear'
			}, {
				id: 'AcctMonth',
				header: '<div style="text-align:center">月</div>',
				width: 40,
				editable: false,
				align: 'center',
				dataIndex: 'AcctMonth'
			}, {
				id: 'VouchDate',
				header: '<div style="text-align:center">凭证日期</div>',
				width: 90,
				editable: false,
				align: 'center',
				dataIndex: 'VouchDate'
			}, {
				id: 'VouchNo',
				header: '<div style="text-align:center">凭证号</div>',
				width: 110,
				editable: false,
				align: 'center',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>'
				},
				dataIndex: 'VouchNo'
			}, {
				id: 'VouchBillNum',
				header: '<div style="text-align:center">附件数</div>',
				width: 60,
				editable: false,
				align: 'center',
				dataIndex: 'VouchBillNum'
			}, {
				id: 'TotalAmtDebit',
				header: '<div style="text-align:center">总金额</div>',
				width: 130,
				editable: false,
				align: 'right',
				dataIndex: 'TotalAmtDebit'
			}, {
				id: 'Operator',
				header: '<div style="text-align:center">制单人</div>',
				width: 100,
				editable: false,
				dataIndex: 'Operator'
			}, {
				id: 'Auditor',
				header: '<div style="text-align:center">审核人</div>',
				width: 100,
				editable: false,
				dataIndex: 'Auditor'
			}, {
				id: 'Poster',
				header: '<div style="text-align:center">记账人</div>',
				width: 100,
				editable: false,
				dataIndex: 'Poster'
			}, {
				id: 'VouchState',
				header: '<div style="text-align:center">凭证状态</div>',
				width: 80,
				editable: false,
				dataIndex: 'VouchState'
			}, {
				id: 'VouchProgress',
				header: '<div style="text-align:center">凭证处理过程</div>',
				width: 100,
				editable: false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>'
				},
				dataIndex: 'VouchProgress'

			}, {
				id: 'IsDestroy',
				header: '<div style="text-align:center">冲销凭证</div>',
				width: 80,
				editable: false,
				dataIndex: 'IsDestroy'
			}, {
				id: 'IsCancel',
				header: '<div style="text-align:center">作废凭证</div>',
				width: 80,
				editable: false,
				dataIndex: 'IsCancel'
			}, {
				id: 'VouchState1',
				header: '<div style="text-align:center">凭证状态</div>',
				width: 80,
				editable: false,
				hidden: true,
				dataIndex: 'VouchState1'
			}, {
				id: 'Operator1',
				header: '<div style="text-align:center">编制人</div>',
				width: 100,
				editable: false,
				hidden: true,
				dataIndex: 'Operator1'
			}, {
				id: 'Auditor1',
				header: '<div style="text-align:center">审核人</div>',
				width: 100,
				editable: false,
				hidden: true,
				dataIndex: 'Auditor1'
			}
			/* ,{
			id : ' ',
			header: '<div style="text-align:center">当前会计期间</div>',
			width : 80,
			editable:false,
			hidden : true,
			dataIndex : 'AcctYearMonth'
			} */
		]);

var MoidLogPagTba = new Ext.PagingToolbar({
		store: MoidLogDs,
		pageSize: 25,
		displayInfo: true,
		plugins: new dhc.herp.PageSizePlugin(),
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有记录"
	});

//审核按钮
var auditButton = new Ext.Button({
		text: '审核',
		tooltip: '审核',
		width: 60,
		iconCls: 'audit',
		handler: function () {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			var checker = session['LOGON.USERCODE'];
			if (len < 1) {
				Ext.Msg.show({
					title: '注意',
					msg: '请选择需要审核的数据! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			}
			// 筛选非自己的已提交凭证
			var vouchIdArr = []; //存放符合审核条件的凭证id
			var incomplatVouchCount = 0; //所选不符合审核条件计数
			for (var j = 0; j < len; j++) {
				if (rowObj[j].get("Operator1") != userdr && rowObj[j].get("VouchState1") == "11") {
					var vouchid = rowObj[j].get("AcctVouchID");
					if (vouchIdArr.indexOf(vouchid) == -1) {
						vouchIdArr.push(vouchid);
					}
				} else {
					incomplatVouchCount++;
				}
			}

			if (vouchIdArr.length == 0) {
				Ext.Msg.show({
					title: '注意',
					msg: '所选凭证不是已提交的凭证! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.INFO
				});
				return;

			} else {
				//
				if (incomplatVouchCount) {
					Ext.MessageBox.confirm('提示', '不符合审核条件的凭证已过滤，请放心操作！ ', function (btn) {
						if (btn == 'yes') {
							auditFun(vouchIdArr);
						} else {
							return;
						}

					});
				} else {
					auditFun(vouchIdArr);
				}

			}
		}
	});

//反审核按钮
var cancleauditButton = new Ext.Button({
		text: '反审核',
		tooltip: '反审核',
		width: 60,
		iconCls: 'return_audit',
		handler: function () {
			//定义并初始化行对象
			var rowObj = itemGrid.getSelectionModel().getSelections();
			//定义并初始化行对象长度变量
			var len = rowObj.length;
			var checker = session['LOGON.USERCODE'];
			var vouchidDs = [],incomplatVouchCount=0;	//所选不符合反审核条件计数
			if (len < 1) {
				Ext.Msg.show({
					title: '注意',
					msg: '请选择需要反审核的数据! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			}
			for (var j = 0; j < len; j++) {
				if (rowObj[j].get("Auditor1") == userdr && rowObj[j].get("VouchState1") == "21" ){
					var vouchid = rowObj[j].get("AcctVouchID");
					if(vouchidDs.indexOf(vouchid == -1)) {
						vouchidDs.push(vouchid);
					}
				}else{
					incomplatVouchCount++;
				}
			}
			if (vouchidDs.length == 0) {
				Ext.Msg.show({
					title: '注意',
					msg: '请选择审核人是自己，状态为审核通过的凭证进行反审核操作! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.INFO
				});
				return;
			} else {
				if(incomplatVouchCount){
					Ext.MessageBox.confirm('提示', '不符合反审核条件的凭证已过滤，请放心操作！ ', function (btn) {
						if (btn == 'yes') {
							cancelAuditFun(vouchidDs);
						} else {
							return;
						}
					});
				}else{
					cancelAuditFun(vouchidDs);
				}				
			}
		}
	});

var itemGrid = new Ext.grid.EditorGridPanel({
		//title : '凭证显示',
		region: 'center',
		pageSize: 25,
		store: MoidLogDs,
		cm: MoidLogCm,
		//atLoad : true,
		clicksToEdit: 1,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.CheckboxSelectionModel({
			singleSelect: false
		}),
		tbar: [auditButton, "-", cancleauditButton],
		bbar: MoidLogPagTba,
		loadMask: true
	});
/*
itemGrid.store.load({params:{start :  0,
limit : 25}});
 */
//MoidLogPagTba.on("change",function(o,p){
//MoidLogDs.reload();
//	});

itemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {
	//alert(columnIndex);
	var a = typenameCombo.getValue()
		if (a == 2) {
			var b = 14
		} else {
			var b = 13
		}
		if (columnIndex == '6') {
			//p_URL = 'acct.html?acctno=2';
			//document.getElementById("frameReport").src='acct.html';
			var records = itemGrid.getSelectionModel().getSelections();
			var VouchNo = records[0].get("VouchNo");
			var VouchState = records[0].get("VouchState1");
			var myPanel = new Ext.Panel({
					layout: 'fit',
					//scrolling="auto"
					html: '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userdr + '&acctstate=' + VouchState + '&bookID=' + bookID + '&SearchFlag=' + '1' + '" /></iframe>'
					//frame : true
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
		//凭证处理过程
		if (columnIndex == b) {
			var records = itemGrid.getSelectionModel().getSelections();
			var VouchID = records[0].get("AcctVouchID");
			VouchProgressFun(VouchID);
		}
})
