var userid,bookid,vouchNO;
var projUrl = 'herp.acct.acctexpenditurectrlexe.csp';
var vNO=document.getElementById("vouchNO").innerHTML;
if(vNO==""){
	userid = session['LOGON.USERID'];
	bookid = IsExistAcctBook();
}else{
	bookid=document.getElementById("AcctBookID").innerHTML;
	userid=document.getElementById("userid").innerHTML;
	vouchNO=vNO+"#"+bookid;	
}
// alert(userid+" "+vouchNO)


var codeFeild = new Ext.form.TextField({
		fieldLabel : '报销单号',
		id : 'codeFeild',
		name : 'codeFeild',
		width : 120,
		emptyText : '报销单号...'
	});
	
var sDateField = new Ext.form.DateField({
		fieldLabel : '报销日期',
		width:110,
		// format : 'Y-m-d',
		emptyText : '开始时间...',
		renderer : function (v, p, r, i) {
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {
				return v;
			}
		}
	});
var eDateField = new Ext.form.DateField({
		fieldLabel : '-',
		width:110,
		// format : 'Y-m-d',
		emptyText : '结束时间...',
		renderer : function (v, p, r, i) {
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {
				return v;
			}
		}
	});

var cVouchDateField = new Ext.form.DateField({
		fieldLabel : '凭证日期',
		width:120,
		// format : 'Y-m-d',
		value : new Date(),
		renderer : function (v, p, r, i) {
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {
				return v;
			}
		}
	});	
var dataStateComb = new Ext.form.ComboBox({
		fieldLabel : '单据状态',
		width : 80,
		listWidth : 80,
		store : new Ext.data.ArrayStore({
			fields : ['code', 'name'],
			data : [['1', '已记账'], ['0', '未记账']]
		}),
		displayField : 'name',
		valueField : 'code',
		typeAhead : true,
		mode : 'local',
		forceSelection : true,
		triggerAction : 'all',
		selectOnFocus : 'true'
	});
	
	//////科室名称
var deptDs = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
			totalProperty : "results",
			root : 'rows'
		}, ['rowid', 'name'])
	});

deptDs.on('beforeload', function (ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
			url : projUrl + '?action=departList',
			method : 'POST'

		});
});

var deptCombo = new Ext.form.ComboBox({
		fieldLabel : '科室名称',
		store : deptDs,
		displayField : 'name',
		valueField : 'rowid',
		typeAhead : true,
		forceSelection : true,
		triggerAction : 'all',
		emptyText : '',
		width : 180,
		listWidth : 255,
		pageSize : 10,
		minChars : 1,
		selectOnFocus : true
	});

//////查询按钮
var findButton = new Ext.Toolbar.Button({
		text : '查询',
		tooltip : '查询',
		width:55,
		iconCls : 'find',
		handler : function () {

			var dept = deptCombo.getValue();
			var dataState = dataStateComb.getValue();
			var code = codeFeild.getValue();
			var selectedRow = itemGrid.getSelectionModel().getSelections();
			var length = selectedRow.length;
			if (sDateField.getValue() == "") {
				var sdate = ""
			} else {
				var sdate = sDateField.getRawValue();
			}
			if (eDateField.getValue() == "") {
				var edate = ""
			} else {
				var edate = eDateField.getRawValue();
			}

			/* if (sdate == ""){
				Ext.Msg.show({
					title : '注意',
					msg : '请先您选择开始日期！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});

				return;
			} 
			if(edate==""){
				Ext.Msg.show({
					title : '注意',
					msg : '请您选择结束日期！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});

				return;
			}*/

			var BillNo = ""
			if (length > 0) {
				for (var i = 0; i < length; ++i) {
					BillNo += "'" + selectedRow[i].data['billcode'] + "'" + ",";
				}
			}
			if ((BillNo != "") || (BillNo == null)) {
				code = code + "^" + BillNo;
			}
			//alert(code)

			itemGrid.load({
				params : {
					start : 0,
					limit : 25,
					code : code,
					sDate : sdate,
					eDate : edate,
					DataState : dataState,
					dept : dept

				}
			});
		}
	});

//////////////////// 凭证生成按钮 //////////////////////
var CreateVouchWin;
var VouchDatePanel=new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 90,
		labelAlign:'right',
		lineHeight:20,
		items:cVouchDateField
	});

	var VouchButton = new Ext.Toolbar.Button({
			id: 'VouchButton',
			text: '&nbsp;生成凭证',
			width: 80,
			tooltip: '生成凭证',
			iconCls: 'createvouch',
			handler: function () {
				// console.log("click")
				var selectedRow = itemGrid.getSelectionModel().getSelections();
				var length = selectedRow.length;
				if (length < 1) {
					Ext.Msg.show({
						title: '注意',
						msg: '请选择您需要生成凭证的数据！ ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.WARNING
					});
					return;
				}
				Ext.MessageBox.confirm('提示', '所选记录确信要生成凭证吗？ ',
				function callback(id) {
				if (id == "yes") {

					// console.log("yes");
					// alert("yes");
					var BillNo = "";
					for (var i = 0; i < length; ++i) {
						var DataStatus = selectedRow[i].data['checkstate'];
						if (DataStatus == "已记账")
							continue; //过滤已经做过账的数据
						BillNo += "'" + selectedRow[i].data['billcode'] + "',";
					}
					// alert(length+"&"+BillNo+"&"+cVouchDate)
					if (BillNo == "") {
						Ext.Msg.show({
							title: '注意',
							msg: '请选择未记账的数据！ ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.WARNING
						});
						return;
					}
					if (!CreateVouchWin) {
						// console.log("click");
						CreateVouchWin = new Ext.Window({
								title: "生成凭证的日期",
								height: 200,
								width: 300,
								bodyStyle: 'padding:30px 10px 0 5px;',
								buttonAlign: 'center',
								items: VouchDatePanel,
								closeAction: 'hide', //关闭按钮隐藏
								buttons: [{
										text: "确定",
										handler: function () {
											var cVouchDate = cVouchDateField.getRawValue();
											// 取到生成日期后，关闭日期选择窗口
											if (cVouchDate)
												CreateVouchWin.hide(); //关闭窗口，调hide方法，防止再打开窗口是报错
											else {
												Ext.Msg.show({
													title: '注意',
													msg: '请选择凭证的生成日期！ ',
													buttons: Ext.Msg.OK,
													icon: Ext.MessageBox.WARNING
												});
												return;
											}

											
												Ext.Ajax.request({
													url: projUrl + '?action=createVouch&userid=' + userid + '&BillNo=' + BillNo + '&AcctBookID=' + bookid + '&cVouchDate=' + cVouchDate,
													method: 'POST',
													success: function (result, request) {
														var jsonData = Ext.util.JSON.decode(result.responseText);
														if (jsonData.success == 'true') {

															Ext.Msg.show({
																title: '提示',
																msg: '生成凭证成功！ ',
																buttons: Ext.Msg.OK,
																icon: Ext.MessageBox.INFO

															});
															//刷新后停留在当前页
															var tbarnum = itemGrid.getBottomToolbar();
															tbarnum.doLoad(tbarnum.cursor);

															// itemGrid.load({
															// params : {
															// start : 0,
															// limit : 25,
															// VouchNO : vouchNO
															// }
															// });
														} else {
															var err = "生成凭证失败！";
															if (jsonData.info == "DeptTypeError")
																err = err + "会计科室对照页面没有维护所选报销科室对应的预算项。 "
																	if (jsonData.info == "AcctSubjError")
																		err = err + "报销科室所在的预算项在凭证模板配置界面没有维护。 "
																			if (jsonData.info == "AcctFinally")
																				err = "所选记录已做账！ "
																					Ext.Msg.show({
																						title: '提示',
																						msg: err,
																						buttons: Ext.Msg.OK,
																						icon: Ext.MessageBox.ERROR

																					});

														}

													},
													failure: function (result, request) {

														Ext.Msg.show({
															title: '错误',
															msg: '生成凭证失败,请检查网络连接！ ',
															buttons: Ext.Msg.OK,
															icon: Ext.MessageBox.ERROR
														});
														return;
													}
												});
											

									}
								}, {
									text: "取消",
									handler: function () {
										CreateVouchWin.hide();
									}
								}
							]
						});
					}
					
					CreateVouchWin.show();
				} else
						return;
				});
				

			}
		});

	//查询面板
 var querypanel=new Ext.FormPanel({
	 title:"预算支出控制",
	 iconCls:'createvouch',
	height : 73,
    region : 'north',
    frame : true,
	defaults: {
		width:1200,
		bodyStyle:'padding:5px;'
	},
	items:[{	
		xtype: 'panel',
		layout:'column',
		items:[
		{
			xtype: 'displayfield',
			style:'padding:0 5px',
			value:'报销单号'
			//width:65
		},codeFeild,{
			xtype: 'displayfield',
			width:20
		},
		{
			xtype: 'displayfield',
			style:'padding:0 5px',
			value:'科室名称'
			//width:65
		},deptCombo,{
			xtype: 'displayfield',
			width:20
		},
		{
			xtype: 'displayfield',
			style:'padding:0 5px',
			value:'报销日期'
			//width:65
		},sDateField,{
			xtype: 'displayfield',
			style:'padding:0 5px',
			value:'--'
			//width:15
		},eDateField,{
			xtype: 'displayfield',
			width:20
		},
		{
			xtype: 'displayfield',
			style:'padding:0 5px',
			value:'单据状态'
			//width:65
		},dataStateComb,{
			xtype: 'displayfield',
			width:20
		},findButton,{
			xtype: 'displayfield',
			width:20
		},VouchButton
		]}/* ,{
		xtype: 'panel',
		layout:'column',
		items:[{
			xtype: 'displayfield',
			style:'margin-left:20px;',
			value:'凭证日期',
			width:60
		},cVouchDateField,{
			xtype: 'displayfield',
			width:80
		},VouchButton
		]
		
	}*/
	]
});


var itemGrid = new dhc.herp.Grid({
		// title : '费用报销凭证管理',
		region : 'center',
		url : 'herp.acct.acctexpenditurectrlexe.csp',
		fields : [
			new Ext.grid.CheckboxSelectionModel({
				editable : false
			}), {
				header : '申请表ID',
				dataIndex : 'rowid',
				hidden : true
			}, {
				id : 'checkyearmonth',
				header : '核算年月',
				width : 70,
				editable : false,
				dataIndex : 'checkyearmonth'
			}, {
				id : 'billcode',
				header : '报销单号',
				editable : false,
				width : 110,
				renderer : function (value, cellmeta, record, rowIndex, columnIndex, store) {
					//backgroundColor:red
					return '<span style="color:blue;cursor:hand;"><u>' + value + '</u></span>';
				},
				dataIndex : 'billcode'

			}, {
				id : 'deprdr',
				header : '报销科室ID',
				editable : false,
				width : 100,
				dataIndex : 'deprdr',
				hidden : true
			}, {
				id : 'dcode',
				header : '报销科室code',
				editable : false,
				width : 100,
				dataIndex : 'dcode',
				hidden : true 
			}, {
				id : 'dname',
				header : '报销科室',
				editable : false,
				width : 100,
				dataIndex : 'dname',
				hidden : false
			}, {
				id : 'applyer',
				header : '报销人员',
				editable : false,
				width : 80,
				dataIndex : 'applyer'

			}, {
				id : 'actpay',
				header : '报销金额',
				width : 120,
				editable : false,
				align : 'right',
				dataIndex : 'actpay'

			}, {
				id : 'applydate',
				header : '报销时间',
				width : 125,
				align : 'center',
				editable : false,
				dataIndex : 'applydate'

			}, {
				id : 'audeprdr',
				header : '归口科室ID',
				editable : false,
				width : 100,
				dataIndex : 'audeprdr',
				hidden : true
			}, {
				id : 'audname',
				header : '归口科室',
				editable : false,
				width : 100,
				dataIndex : 'audname',
				hidden : true
			}, {
				id : 'applydecl',
				header : '报销说明',
				editable : false,
				width : 150,
				// hidden:true,
				dataIndex : 'applydecl'
			}, {
				id : 'checkstate',
				header : '单据状态',
				width : 80,
				align : 'center',
				editable : false,
				dataIndex : 'checkstate'

			}, {
				id : 'vouchno',
				header : '凭证号',
				editable : false,
				align : 'left',
				width : 100,
				renderer : function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;"><u>' + value + '</u></span>';
				},
				dataIndex : 'vouchno'
			}, {
				id : 'bookid',
				header : '账套ID',
				width : 80,
				align : 'center',
				editable : false,
				hidden:true,
				dataIndex : 'bookid'

			}, {
				id : 'acctuser',
				header : '记账人',
				editable : false,
				width : 80,
				dataIndex : 'acctuser'
			}, {
				id : 'acctdate',
				header : '记账日期',
				editable : false,
				align : 'center',
				width : 100,
				dataIndex : 'acctdate'
			}
		]
	});

itemGrid.btnAddHide(); //隐藏增加按钮
itemGrid.btnSaveHide(); //隐藏保存按钮
itemGrid.btnResetHide(); //隐藏重置按钮
itemGrid.btnDeleteHide(); //隐藏删除按钮
itemGrid.btnPrintHide(); //隐藏打印按钮

if(vNO){
	//查询面板
 var querypanel=new Ext.FormPanel({
		height : 80,
		region : 'north',
		frame : true,
		items:[{
			xtype:'displayfield',
			value:'预算支出控制记账明细表',
			style:'text-align:center;font-size:16px;height:40px;vertical-align:middle; line-height:40px;font-weight:bold'
		},{
			xtype:'displayfield',
			value:'凭证单号：'+vNO,
			style:'text-align:left'
		}]
		
	});
	itemGrid.load({
		params:{
			start:0,
			limit:25,
			VouchNO:vouchNO
		}
	});

	
}

// 单击单据状态 单击gird的单元格事件
itemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {
	var VouchState=11;
	var records = itemGrid.getSelectionModel().getSelections();   
	var BillCode=records[0].get("billcode"),
		BookID=records[0].get("bookid"),
		VouchNo = records[0].get("vouchno");

	//单击报销单号单元格
	if (columnIndex == 4&&BillCode) {
		
		EditFun(itemGrid);
	}
	//凭证号链接
	if(columnIndex==15&&VouchNo) {
			var myPanel = new Ext.Panel({
			layout : 'fit',
			html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno='+VouchNo+'&user='+userid+'&acctstate='+VouchState+'&bookID='+BookID+'&SearchFlag=3" /></iframe>'
			});
			var win = new Ext.Window({
						title : '凭证录入',
						width :1093,
						height :620,
						resizable : false,
						closable : true,
						draggable : true,
						resizable : false,
						layout : 'fit',
						modal : false,
						plain : true, // 表示为渲染window body的背景为透明的背景
						//bodyStyle : 'padding:5px;',
						items : [myPanel],
						buttonAlign : 'center',
						buttons : [{
								text : '关闭',
								type : 'button',
								handler : function() {
									win .close();
									}
								}]
					});
					win.show();
	}

});