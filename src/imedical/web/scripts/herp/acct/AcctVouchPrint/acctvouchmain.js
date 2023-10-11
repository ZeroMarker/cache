var userid = session['LOGON.USERID'];
var acctbookid = IsExistAcctBook();

/////////////////////凭证编号/////////////////////////
var  VouchNofield = new Ext.form.TextField({
            fieldLabel : '凭证编号',
            width :150,
            //style:'line-height: 20px;',
            // columnWidth : .142,
            selectOnFocus : true
        }); 
        
/////////////////////凭证摘要/////////////////////////
 var MakeDateField = new Ext.form.DateField({
            fieldLabel: '凭证日期',
            width:150,
            // allowBlank:false,
            // format:'Y-m-d',
            // columnWidth : .127,
            renderer : function(v, p, r, i) {           
            if (v instanceof Date) {
                return new Date(v).format(websys_DateFormat);
            } else {return v;}
            },
            selectOnFocus:'true'
        });
        
 var MakeDate2Field = new Ext.form.DateField({
            fieldLabel: '--',
            width:150,
            // allowBlank:false,
            // format:'Y-m-d',
            // columnWidth : .12,
            renderer : function(v, p, r, i) {           
            if (v instanceof Date) {
                return new Date(v).format(websys_DateFormat);
            } else {return v;}
            },
            selectOnFocus:'true'
        });
		
	//设置默认查询时间范围
	Ext.Ajax.request({
		url : 'herp.acct.acctvouchprintexe.csp?action=GetDate&userid='+userid,
		failure : function (result, request) {
			return;
		},
		success : function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				var respText=jsonData.info;
				// alert(respText)
				MakeDateField.setValue(respText.split('^')[0]);
				MakeDate2Field.setValue(respText.split('^')[1]);
			} 
			else return;
			
		},
		scope : this
	});
		
	
/////////////////////制单人员///////////////////////// 
 var Makerfield = new Ext.form.TextField({
            fieldLabel : '制单人员',
            width : 150,
            // columnWidth : .156,
            selectOnFocus : true
        }); 
        
/////////////////////审核人员/////////////////////////
 var Checkerfield = new Ext.form.TextField({
            fieldLabel : '审核人员',
            width : 150,
            // columnWidth : .175,
            selectOnFocus : true
        }); 

var StateStore = new Ext.data.SimpleStore({
            fields : ['key', 'keyValue'],
            data : [[0, '新增'],['05', '审核不通过'], ['11', '提交'], ['21', '审核通过'],['31', '记账'], ['41', '结账']]
        });

var StateField = new Ext.form.ComboBox({
		id : 'State',
		fieldLabel : '凭证状态',
		width : 150,
		// columnWidth : .14,
		listWidth : 220,
		selectOnFocus : true,
		allowBlank : true,
		store : StateStore,
		// anchor : '90%',
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		triggerAction : 'all',
		emptyText : '',
		mode : 'local', 
		editable : true,
		pageSize : 10,
		minChars : 10,
		selectOnFocus : true,
		forceSelection : true
	});

var printOwn = new Ext.Toolbar.Button({
		text : '套打',
		tooltip : '凭证套打',
		width:60,
		iconCls : 'print',
		handler : function () {
			Print();
		}
	});

	///查询按钮
var findButton = new Ext.Toolbar.Button({
		text : '查询',
		tooltip : '查询',
		width:80,
		iconCls : 'find',
		handler : function () {

			var vouchno = VouchNofield.getValue();
			var makestart = MakeDateField.getRawValue();
			var makeend = MakeDate2Field.getRawValue();
			var operator = Makerfield.getValue();
			var auditor = Checkerfield.getValue();
			var state = StateField.getValue();
			var data = vouchno + "^"  + "^" + makestart + "^" + makeend + "^" + operator + "^" + auditor + "^" + state + "^" + acctbookid;
			// alert(data)
			itemGrid.load({
				params : {
					start : 0,
					limit : 25,
					data : data
				}
			});
		}
	});


///打印
var printButton = new Ext.Toolbar.Button({
		id : 'printButton',
		text : '打印',
		iconCls : 'print',
		width:80,
		handler : function () {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			var selRowId = "";
			if (len < 1) {
				Ext.Msg.show({
					title : '注意',
					msg : '请选择需要打印的凭证！ ',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
				return;
			} else {
				Ext.MessageBox.confirm('提示', '您确定要打印所选择的凭证吗? ', function handler(id) {
					if (id == 'yes') {

						Ext.each(rowObj, function (record) {
							curRowId = record.get("rowid");
							if (selRowId==""){
								selRowId = curRowId;
							}
							else{
								selRowId +=","+curRowId;
							}
						});
						
						// alert("selRowId:"+selRowId)
						Ext.Ajax.request({
							url : 'herp.acct.acctvouchprintexe.csp?action=vouchPrint&VouchID=' + selRowId + '&userid=' + userid,
							waitMsg : '打印中...',
							failure : function (result, request) {
								Ext.Msg.show({
									title : '错误',
									msg : '请检查网络连接！ ',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
							},
							success : function (result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									str = jsonData.info;
									// alert(str)
									printDetail(str); //调打印函数
								} else {
									Ext.Msg.show({
										title : '错误',
										msg : '错误！ ',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
								}
							},
							scope : this
						});
					}
				});
			}
		}
	});




	
///查询面板
var queryPanel = new Ext.FormPanel({
		height : 80,
		region : 'north',
		frame : true,
		items : [{
				defaults : {
					labelAlign : 'right', //标签对齐方式
					labelSeparator : ' ', //分隔符
					labelWidth : 60,
					border : false,
					bodyStyle : 'padding:5px;'
				},
				width : 1200,
				layout : 'column',
				items : [{
						xtype : 'fieldset',
						// columnWidth:.2,
						width : 280,
						items : [VouchNofield, StateField]
					}, {
						xtype : 'fieldset',
						// columnWidth:.2,
						width : 280,
						items : [Makerfield, Checkerfield]
					}, {
						xtype : 'fieldset',
						// columnWidth:.25,
						width : 250,
						items : [
							MakeDateField, {
								layout : 'column',
								items : [{
										xtype : 'displayfield',
										width : 0
									}, findButton, {
										xtype : 'displayfield',
										width : 50
									}, printButton
								]
							}
						]
					}, {
						xtype : 'fieldset',
						// columnWidth:.2,
						labelSeparator : ' ',
						labelWidth : 20,
						items : [MakeDate2Field]
					}
					
				]

			}
		]

	});
//rowid^AcctYear^AcctMonth^VouchDate^VouchNo^VouchState^Operator^Auditor^Poster^IsDestroy

//翻页后，之前的多选信息保存
var temArr=new Array();

var itemGrid = new dhc.herp.Grid({
		title:'凭证显示列表',
		iconCls:'list',
		region : 'center',
		url : 'herp.acct.acctvouchprintexe.csp',
		atLoad : true, // 是否自动刷新
		viewConfig : {		//表格视图配置
				forceFit : true		//强制调整表格列宽以适用表格的整体宽度，防止出现水平滚动条
			},
		fields : [new Ext.grid.CheckboxSelectionModel({
				editable : false,
				// checkOnly:true,
				singleSelect:false,
				listeners :{
					rowselect:function(rowIndex, record){
						alert("grse")
						console.log(record.get("rowid"))
					},
					rowdeselect:function( rowIndex, record){
						console.log(record.data)
					}
				}
			}),{
				id : 'rowid',
				header : '凭证表ID',
				editable : false,
				width : 130,
				dataIndex : 'rowid',
				hidden : true
			}, {
				id : 'AcctYear',
				header : '年',
				editable : false,
				width : 80,
				align:'center',
				dataIndex : 'AcctYear'
			}, {
				id : 'AcctMonth',
				header : '月',
				editable : false,
				width : 60,
				align:'center',
				dataIndex : 'AcctMonth'

			}, {
				id : 'VouchDate',
				header : '制作日期',
				width : 120,
				editable : false,
				align:'center',
				dataIndex : 'VouchDate'

			},{
				id : 'VouchNo',
				header : '<div style="text-align:center;">凭证号</div>',
				editable : false,
				width : 120,
				renderer : function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var sf = record.data['IsDestroy']
						if (sf == "是") { //cursor:hand;backgroundColor:red
							return '<span style="color:blue;Text-Decoration:underline;cursor:hand;"><u>' + value + '</u></span>' + '<b> </b>'
							 + '<span style="color:red;cursor:hand;backgroundColor:white">冲</span>';
						} else {
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>' + value + '</u></span>';
						}
				},
				dataIndex : 'VouchNo'

			},{
				id : 'Operator',
				header : '制作人',
				align : 'center',
				width : 100,
				editable : false,
				dataIndex : 'Operator'

			}, {
				id : 'Auditor',
				header : '审核人',
				align : 'center',
				width : 100,
				editable : false,
				dataIndex : 'Auditor'

			}, {
				id : 'Poster',
				header : '记账人',
				align : 'center',
				width : 100,
				editable : false,
				dataIndex : 'Poster'
			}, {
				id : 'State',
				header : '凭证状态code',
				width : 100,
				align : 'center',
				hidden : true,
				dataIndex : 'State'
			},{
				id : 'VouchState',
				header : '凭证状态',
				width : 100,
				align : 'center',
				editable : false,
				dataIndex : 'VouchState'
			}, {
				id : 'IsDestroy',
				header : '冲销',
				width : 80,
				align : 'center',
				editable : false,
				renderer : function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var sf = record.data['IsDestroy']
						if (sf == "是") {
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:red;backgroundColor:white">' + value + '</span>';
						}
				},
				dataIndex : 'IsDestroy'
			}
		]

	});

itemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {

	if (columnIndex == '6') {
		var records = itemGrid.getSelectionModel().getSelections();
		var VouchNo = records[0].get("VouchNo");
		var VouchState = records[0].get("State");
		// alert(VouchNo+"^"+VouchState+"^"+userid+"^"+acctbookid)
		var myPanel = new Ext.Panel({
				layout : 'fit',
				html : '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno='+VouchNo+'&user='+userid+'&acctstate='+VouchState+'&bookID='+acctbookid+'&searchFlag='+1+'" /></iframe>'
 
			});
		var win = new Ext.Window({
				title : '凭证录入',
				width : 1093,
				height : 620,
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
						handler : function () {
							win.close();
						}
					}
				]
			});
		win.show();
	};

});

itemGrid.btnAddHide(); //隐藏增加按钮
itemGrid.btnSaveHide(); //隐藏保存按钮
itemGrid.btnResetHide(); //隐藏重置按钮
itemGrid.btnDeleteHide(); //隐藏删除按钮
itemGrid.btnPrintHide(); //隐藏打印按钮
