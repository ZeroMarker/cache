var userdr = session['LOGON.USERID']; //登录人ID
var acctbookid = GetAcctBookID();
var acctbookid = IsExistAcctBook();

//获得当前系统登录用户的信息说明
var userID = session['LOGON.USERID'];
var userCode = session['LOGON.USERCODE'];
var userName = session['LOGON.USERNAME'];

var projUrl = 'herp.acct.acctcashiersignexe.csp';

//*****************查询条件开始*********************//

//***定义会计年月控件***//
var startDate = new Ext.form.DateField({
		id: 'startDate',
		format: 'Y-m',
		width: 200,
		emptyText: '',
		value: new Date(),
		plugins: 'monthPickerPlugin'
	});

//***获取凭证类别***//
var VouchTypeDs = new Ext.data.Store({
		autoLoad: true,
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['rowid', 'name'])
	});
VouchTypeDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=GetVouchTypeName&str' + encodeURIComponent(Ext.getCmp('VouchTypeName').getRawValue()),
			method: 'POST'
		});
});
var VouchTypeName = new Ext.form.ComboBox({
		id: 'VouchTypeName',
		fieldLabel: '凭证类型',
		width: 214,
		listwidth: 220,
		allowBlank: 'false',
		store: VouchTypeDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '请选择凭证类型',
		name: 'VouchTypeName',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

//***获取签字状态***//
var IsCheckState = new Ext.form.RadioGroup({
		fieldLabel: '签字状态',
		width: 220,
		defaults: {
			style: "margin:0;padding:0 0.25em;width:auto;overflow:visible;border:0;background:none;"
		},
		items: [{
				id: 'all',
				boxLabel: '全部',
				inputValue: '',
				name: 'IsCheck1'
			}, {
				id: 'checked',
				boxLabel: '已签字',
				inputValue: '1',
				name: 'IsCheck1'
			}, {
				id: 'unchecked',
				boxLabel: '未签字',
				inputValue: '0',
				name: 'IsCheck1',
				checked: true
			}
		]/*,
		listeners:{
		beforerender:function(){
		var radioLabel=document.getElementsByClassName('x-form-cb-label');
		//position:absolute;
		// radioLabel.marginLeft=20px;
		radioLabel.style.top=-3px;
		// document.getElementsByClassName('x-form-cb-label').marginLeft=20px;
		}
		}*/
	});

//***凭证号起始值***//
var StartVouchNo = new Ext.form.TextField({
		fieldLabel: '凭证号',
		allowBlank: true,
		align: 'right',
		width: 100
	});
//***凭证号结束值***//
var EndVouchNo = new Ext.form.TextField({
		fieldLabel: '结束凭证号',
		allowBlank: true,
		width: 100,
		align: 'right'
		// maxLength:50
	});

//***会计科目***//
var SubjNameDs = new Ext.data.Store({
		autoLoad: true,
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['rowid', 'code', 'name', 'spell'])
	});
SubjNameDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=GetCashSubjName&str=' + encodeURIComponent(Ext.getCmp('SubjName').getRawValue()) + '&acctbookid=' + acctbookid,
			method: 'POST'
		});
});
var SubjName = new Ext.form.ComboBox({
		id: 'SubjName',
		fieldLabel: '会计科目',
		width: 200,
		listWidth: 220,
		allowBlank: true,
		store: SubjNameDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '请选择会计科目',
		name: 'SubjName',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

//当前登录人
/*var CurruserField = new Ext.form.Checkbox({
		id: 'CurruserField',
		fieldLabel: '当前登录人',
		allowBlank: false,
		style: 'border:0;background:none;margin-top:0px;'
	});*/

//********--查询条件结束--*********//

//***查询函数***//
function dosearch() {
	var SubjID = SubjName.getValue();
	//if(SubjID!=""){
	var startTime = startDate.getValue();
	if (startTime !== "") {
		startTime = startTime.format('Y-m');
	}
	var VouchTypeID = VouchTypeName.getValue();
	var IsSign = IsCheckState.getValue().inputValue;
	var StartNum = StartVouchNo.getValue();
	var EndNum = EndVouchNo.getValue();

	//var Curruser = (CurruserField.getValue() == true) ? '1' : '0';
	//console.log(Ext.getCmp("PageSizePlugin"));
        var limits=Ext.getCmp("PageSizePlugin").getValue();
			 //alert(limits);
	         if(!limits){limits=25};
	itemGrid.load({
		params: {
			sortField: '',
			sortDir: '',
			start: 0,
			limit: limits,
			startDate: startTime, //会计期间
			VouchTypeID: VouchTypeID, //凭证类型ID
			IsSign: IsSign, //签字状态
			StartVouchNo: StartNum, //起始凭证号
			EndVouchNo: EndNum,
			SubjID: SubjID,
			acctbookid: acctbookid, //会计科目
			//Curruser: Curruser,
			userdr: userdr
		}
	});
	//}else if(SubjID==""){
	//  Ext.Msg.show({title:'提示',msg:'会计科目项为空 请您重新进行选择!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	//  return;
	//  }
};

//**定义查询按钮**//
var QueryButton = new Ext.Toolbar.Button({
		text: '查询	',
		tooltips: '查询功能',
		width: 65,
		iconCls: 'find',
		handler: function () {
			dosearch();
		}
	});

//**定义批量审批**//
var BatchSign = new Ext.Toolbar.Button({
		text: '批量签字',
		tooltip: '批量签字',
		width: 80,
		iconCls: 'cashiersign',
		handler: function () {
			batchsign();
			return;
		}
	});

//**定义批量取消**//
var SignCancel = new Ext.Toolbar.Button({
		text: '取消签字',
		tooltip: '取消签字',
		width: 80,
		iconCls: 'cancel_sign',
		handler: function () {
			cancelsign();
			return;
		}
	});

//****查询面板--查询条件*****//
var queryPanel = new Ext.FormPanel({
		region: 'north',
		height:85,
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px;'
		},
		items: [{
				columnWidth: 1,
				xtype: 'panel',
				layout: 'column',
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '会计期间',
						style: 'line-height: 20px;',
						width: 65
					}, startDate, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '凭证类型',
						style: 'line-height: 20px;',
						width: 65
					}, VouchTypeName, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '签字状态',
						style: 'line-height: 20px;',
						width: 65
					}, IsCheckState]
			}, {
				columnWidth: 1,
				xtype: 'panel',
				layout: 'column',
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '会计科目',
						style: 'line-height: 20px;',
						width: 65
					}, SubjName, {
						xtype: 'displayfield',
						value: '',
						width: 45
					}, {
						xtype: 'displayfield',
						value: '凭证号',
						style: 'line-height: 20px;',
						width: 50
					}, StartVouchNo, {
						xtype: 'displayfield',
						value: '',
						width: 1
					}, {
						xtype: 'displayfield',
						value: '--'
						//width: 10
					}, {
						xtype: 'displayfield',
						value: '',
						width: 1
					}, EndVouchNo, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}/*, {
						xtype: 'displayfield',
						value: '当前出纳执行:',
						style: 'margin-bottom:3px;line-height: 20px;',
						width: 90
					}, CurruserField*/, {
						xtype: 'displayfield',
						value: '',
						width: 40
					}, QueryButton
				]
			}
		]
	});

//***itemGrid表格***//
var itemGrid = new dhc.herp.Grid({
		width: 400,
		region: 'center',
		url: projUrl,
		//atLoad:true,
		fields: [
			new Ext.grid.CheckboxSelectionModel({
				editable: false
			}), {
				id: 'rowid',
				header: 'ID',
				dataIndex: 'rowid',
				hidden: true
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
				id: 'VouchNo',
				header: '<div style="text-align:center">凭证号</div>',
				width: 100,
				editable: false,
				renderer: function (value, cellmeta, records, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>';
				},
				align: 'center',
				dataIndex: 'VouchNo'
			}, {
				id: 'MakeBillDate',
				header: '<div style="text-align:center">制单时间</div>',
				width: 100,
				editable: false,
				align: 'center',
				dataIndex: 'MakeBillDate'
			}, {
				id: 'Summary',
				header: '<div style="text-align:center">摘要</div>',
				width: 150,
				editable: false,
				align: 'left',
				dataIndex: 'Summary'
			}, {
				id: 'CheqTypeName',
				header: '<div style="text-align:center">票据类型</div>',
				width: 80,
				editable: false,
				align: 'center',
				dataIndex: 'CheqTypeName'
			}, {
				id: 'CheqNo',
				header: '<div style="text-align:center">票据号</div>',
				width: 150,
				editable: false,
				//align:'left',
				dataIndex: 'CheqNo'
			}, {
				id: 'OccurDate',
				header: '<div style="text-align:center">发生时间</div>',
				width: 100,
				editable: false,
				align: 'center',
				dataIndex: 'OccurDate'
			}, {
				id: 'AmtDebit',
				header: '<div style="text-align:center">借方金额</div>',
				width: 150,
				editable: false,
				align: 'right',
				dataIndex: 'AmtDebit'
			}, {
				id: 'AmtCredit',
				header: '<div style="text-align:center">贷方金额</div>',
				width: 150,
				editable: false,
				align: 'right',
				dataIndex: 'AmtCredit'
			}, {
				id: 'IsCheck',
				header: '<div style="text-align:center">出纳签字状态</div>',
				width: 110,
				editable: false,
				align: 'center',
				dataIndex: 'IsCheck',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var sf = record.data['IsCheck']
						// if (sf == "已签字") {return '<span style="cursor:hand">'+value+'</span>';}
						if (sf == "未签字") {
							return '<span style="color:blue;">' + value + '</span>';
						} else {
							return value;
						}
				}

			}, {
				id: 'CheckerID',
				header: '<div style="text-align:center">签字人id</div>',
				width: 80,
				hidden: true,
				editable: false,
				align: 'center',
				dataIndex: 'CheckerID'
			}, {
				id: 'CheckerName',
				header: '<div style="text-align:center">签字人</div>',
				width: 100,
				editable: false,
				align: 'center',
				dataIndex: 'CheckerName'
			}, {
				id: 'CheckDate',
				header: '<div style="text-align:center">签字日期</div>',
				width: 100,
				editable: false,
				align: 'center',
				dataIndex: 'CheckDate'
			}, {
				id: 'VouchState1',
				header: '<div style="text-align:center">凭证状态code</div>',
				width: 80,
				editable: false,
				hidden: true,
				align: 'center',
				dataIndex: 'VouchState1'
			}, {
				id: 'VouchState',
				header: '<div style="text-align:center">凭证状态</div>',
				width: 80,
				editable: false,
				// hidden:true,
				align: 'center',
				dataIndex: 'VouchState'
			}, {
				id: 'VouchProgress',
				header: '凭证处理过程',
				width: 100,
				editable: false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>';
				},
				dataIndex: 'VouchProgress'
			}
		]

	});

itemGrid.btnResetHide(); //隐藏重置按钮
itemGrid.btnPrintHide(); //隐藏打印按钮
itemGrid.btnAddHide(); //隐藏按钮
itemGrid.btnSaveHide(); //隐藏按钮
itemGrid.btnDeleteHide();

itemGrid.addButton(BatchSign);
itemGrid.addButton('-');
itemGrid.addButton(SignCancel);
itemGrid.addButton('-');
itemGrid.addButton('<span style="color:red;cursor:hand">' + "&nbsp;&nbsp;&nbsp;提示:请仔细核对每张凭证的多个记录后，再进行签字处理！" + '</span>');
//itemGrid.load({params:{start:0,limit:25,userdr:userdr}});

itemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {

	if (columnIndex == '5') {
		//p_URL = 'acct.html?acctno=2';
		//document.getElementById("frameReport").src='acct.html';
		var records = itemGrid.getSelectionModel().getSelections();
		var VouchNo = records[0].get("VouchNo");
		var VouchState = records[0].get("VouchState1");
		var searchFlag = 4;
		var myPanel = new Ext.Panel({
				layout: 'fit',
				//scrolling="auto"
				html: '<iframe id="frameReport" style="zoom:100%;margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userdr + '&acctstate=' + VouchState + '&bookID=' + acctbookid + '&searchFlag=' + searchFlag + '" /></iframe>'
				//frame : true
			});

		var win = new Ext.Window({
				title: '凭证查看',
				width: 1093,
				height: 620,
				resizable: true,
				closable: true,
				draggable: true,
				resizable: false,
				author: '50%',
				layout: 'fit',
				modal: false,
				plain: true, // 表示为渲染window body的背景为透明的背景
				// bodyStyle : 'padding:-500px;',
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
	} //凭证处理过程链接
	if (columnIndex == '19') {
		var records = itemGrid.getSelectionModel().getSelections();
		var VouchID = records[0].get("rowid");
		VouchProgressFun(VouchID);
	}

})

function GetYearMonth() {
	Ext.Ajax.request({
		url: 'herp.acct.acctbatchauditexe.csp?action=GetYearMonth' + '&bookID=' + acctbookid,
		failure: function (result, request) {
			Ext.Msg.show({
				title: '错误',
				msg: '请检查网络连接!',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			//alert(jsonData.success );
			if (jsonData.success == 'false') {
				//alert("dddd="+jsonData.info)
				var date = jsonData.info + "-01"
					startDate.setValue(date);
			}
		},
		scope: this
	});
}
GetYearMonth();
