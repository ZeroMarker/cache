// 名称:供应商维护
// 编写日期:2012-05-14

//=========================供应商类别=============================
var currVendorRowId = '';
var win;
var conditionCodeField = new Ext.form.TextField({
		id: 'conditionCodeField',
		fieldLabel: '供应商代码',
		allowBlank: true,
		listWidth: 180,
		anchor: '90%',
		selectOnFocus: true,
		listeners: {
			'specialkey': function (t, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					findAPCVendor.handler();
				}
			}
		}
	});

var conditionNameField = new Ext.form.TextField({
		id: 'conditionNameField',
		fieldLabel: '供应商名称',
		allowBlank: true,
		listWidth: 150,
		anchor: '90%',
		selectOnFocus: true,
		listeners: {
			'specialkey': function (t, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					findAPCVendor.handler();
				}
			}
		}
	});

var conditionStateStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [["A", '使用'], ["S", '停用'], ["", '全部']]
	});

var conditionStateField = new Ext.form.ComboBox({
		id: 'conditionStateField',
		fieldLabel: '使用状态',
		anchor: '90%',
		listWidth: 230,
		allowBlank: true,
		store: conditionStateStore,
		value: '', // 默认值"全部查询"
		valueField: 'key',
		displayField: 'keyValue',
		triggerAction: 'all',
		emptyText: '',
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true,
		editable: true,
		mode: 'local'
	});

var includeRcVendor = new Ext.form.Checkbox({
		id: 'includeRc',
		boxLabel: '中间商',
		anchor: '97%'
	});
//分类
var conditioncategoryField = new Ext.ux.ComboBox({
		id: 'conditioncategoryField',
		fieldLabel: '分类',
		anchor: '90%',
		allowBlank: true,
		store: GetVendorCatStore,
		valueField: 'RowId',
		displayField: 'Description',
		triggerAction: 'all',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: true,
		editable: true
	});

//配置数据源
var APCVendorGridUrl = 'dhcstm.apcvendoraction.csp';
var APCVendorGridProxy = new Ext.data.HttpProxy({
		url: APCVendorGridUrl + '?actiontype=query',
		method: 'POST'
	});
var APCVendorGridDs = new Ext.data.Store({
		proxy: APCVendorGridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results',
			pageSize: 35
		}, [{
					name: 'RowId'
				}, {
					name: 'Code'
				}, {
					name: 'Name'
				}, {
					name: 'Tel'
				}, {
					name: 'Category'
				}, {
					name: 'CategoryId'
				}, {
					name: 'CtrlAcct'
				}, {
					name: 'CrAvail'
				}, {
					name: 'LstPoDate'
				}, {
					name: 'Fax'
				}, {
					name: 'President'
				}, {
					name: 'PresidentId'
				}, {
					name: 'PresidentTel'
				}, {
					name: 'Status'
				}, {
					name: 'rcFlag'
				}, {
					name: 'LstBsDate'
				},'AccountPeriod'
			]),
		remoteSort: false
	});

//模型
var sm=new Ext.grid.CheckboxSelectionModel({});
var APCVendorGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),sm, {
				header: "代码",
				dataIndex: 'Code',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "名称",
				dataIndex: 'Name',
				width: 300,
				align: 'left',
				sortable: true
			}, {
				header: "电话",
				dataIndex: 'Tel',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "分类",
				dataIndex: 'Category',
				width: 100,
				align: 'left',
				sortable: false
			}, {
				header: "账户",
				dataIndex: 'CtrlAcct',
				width: 200,
				align: 'left',
				sortable: false
			}, {
				header: "注册资金",
				dataIndex: 'CrAvail',
				width: 150,
				align: 'left',
				sortable: false
			}, {
				header: "合同日期",
				dataIndex: 'LstPoDate',
				width: 150,
				align: 'left',
				sortable: true
			}, {
				header: "传真",
				dataIndex: 'Fax',
				width: 200,
				align: 'left',
				sortable: false
			}, {
				header: "法人",
				dataIndex: 'President',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "法人身份证",
				dataIndex: 'PresidentId',
				width: 130,
				align: 'left',
				sortable: true
			}, {
				header: "法人联系电话",
				dataIndex: 'PresidentTel',
				width: 150,
				align: 'left',
				sortable: true
			}, {
				header: "使用标志",
				dataIndex: 'Status',
				width: 80,
				align: 'left',
				sortable: false,
				renderer: function (v, p, record) {
					if (v == "A")
						return "使用";
					if (v == "S")
						return "停用";
				}
			}, {
				header: "中间商",
				dataIndex: 'rcFlag',
				width: 80,
				align: 'center',
				sortable: true,
				renderer: function (v, p, record) {
					if (v == "Y") {
						return "是";
					} else {
						return "";
					}
				}
			}, {
				header: "最后业务日期",
				dataIndex: 'LstBsDate',
				width: 150,
				align: 'left',
				sortable: true
			}, {
				header: "账期",
				dataIndex: 'AccountPeriod',
				width: 100,
				align: 'left',
				sortable: false
			}
		]);

//初始化默认排序功能
APCVendorGridCm.defaultSortable = true;

var findAPCVendor = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			Query();
		}
	});

var addAPCVendor = new Ext.Toolbar.Button({
		text: '新建',
		tooltip: '新建',
		iconCls: 'page_add',
		width: 70,
		height: 30,
		handler: function () {
			currVendorRowId = "";
			CreateEditWin();
		}
	});

var findNotAuditpicAPCVendor = new Ext.Toolbar.Button({
		text: '资质图片',
		tooltip: '查看资质图片',
		iconCls: 'page_edit',
		width: 70,
		height: 30,
		handler: function () {
			var rowObj = APCVendorGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len < 1) {
				Msg.info("warning", "请选择供应商!");
				return false;
			} else {
				currVendorRowId = rowObj[0].get('RowId');
				var PicUrl = 'dhcstm.apcvendoraction.csp?actiontype=GetNotAuditPic';
				// 通过AJAX方式调用后台数据
				var proxy = new Ext.data.HttpProxy({
						url: PicUrl,
						method: "POST"
					});
				// 指定列参数
				var fields = ["rowid", "venid", "vendesc", "picsrc", "type"];
				// 支持分页显示的读取方式
				var reader = new Ext.data.JsonReader({
						root: 'rows',
						totalProperty: "results",
						id: "rowid",
						fields: fields
					});
				// 数据集
				var PicStore = new Ext.data.Store({
						proxy: proxy,
						reader: reader
					});

				ShowNotAuditPicWindow(PicStore, currVendorRowId)

			}
		}
	});

// 导出按钮
var ExportAllToExcelBT = new Ext.Toolbar.Button({
		text: '整体另存',
		tooltip: '整体另存',
		width: 70,
		height: 30,
		iconCls: 'page_refresh',
		handler: function () {
			ExportAllToExcel(APCVendorGrid);
		}
	});

var editAPCVendor = new Ext.Toolbar.Button({
		text: '编辑',
		tooltip: '编辑',
		iconCls: 'page_edit',
		width: 70,
		height: 30,
		handler: function () {
			var rowObj = APCVendorGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len < 1) {
				Msg.info("warning", "请选择供应商!");
				return false;
			} else {
				var rowid = rowObj[0].get('RowId');
				currVendorRowId = rowid;
				CreateEditWin();
				//窗口显示
			}
		}
	});
var SendVendorBT = new Ext.Toolbar.Button({
			id : "SendVendorBT",
			text : '发送供应商信息到平台',
			width : 70,
			height : 30,
			iconCls : 'page_gear',
			handler : function() {
				    var rowDataArr=APCVendorGrid.getSelectionModel().getSelections();
					if (Ext.isEmpty(rowDataArr)) {
						Msg.info("warning", "请选择需要发送的供应商信息!");
						return;
					}
					var VendorStr="";
					for (var i=0;i<rowDataArr.length;i++){
						var rowData=rowDataArr[i];
						var VenRowId = rowData.get("RowId");
						if (VendorStr==""){
							VendorStr=VenRowId;
						}else{
							VendorStr=VendorStr+"^"+VenRowId;
						}
					}
					if (Ext.isEmpty(VendorStr)) {
						Msg.info("warning", "请选择需要发送的供应商信息!");
						return;
					}
					SendVendor(VendorStr);
			}
});
function SendVendor(VendorStr){
	 var url = APCVendorGridUrl+"?actiontype=SendVendor";
        var loadMask=ShowLoadMask(Ext.getBody(),"发送信息中...");
        Ext.Ajax.request({
                    url : url,
                    method : 'POST',
                    params:{VendorStr:VendorStr},
                    waitMsg : '处理中...',
                    success : function(result, request) {
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                            Msg.info("success", "发送成功!");
                            Query();
                        } else {
                            var ret=jsonData.info;
                            Msg.info("error", jsonData.info);
                            Query();
                        }
                    },
                    scope : this
                });
        loadMask.hide();
}
var formPanel = new Ext.ux.FormPanel({
		title: '供应商维护',
		tbar: [findAPCVendor, '-', addAPCVendor, '-', editAPCVendor, '-', findNotAuditpicAPCVendor, '-', SendVendorBT],
		items: [{
				xtype: 'fieldset',
				title: '查询条件',
				layout: 'column',
				style: 'padding:5px 0px 0px 5px',
				defaults: {
					border: false,
					xtype: 'fieldset'
				},
				items: [{
						columnWidth: .2,
						items: [conditionCodeField]
					}, {
						columnWidth: .2,
						items: [conditionNameField]
					}, {
						columnWidth: .2,
						items: [conditionStateField]
					}, {
						columnWidth: .2,
						items: [conditioncategoryField]
					}, {
						columnWidth: .2,
						items: [includeRcVendor]
					}
				]
			}
		]

	});

//分页工具栏
var APCVendorPagingToolbar = new Ext.PagingToolbar({
		store: APCVendorGridDs,
		pageSize: PageSize,
		displayInfo: true,
		displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg: "没有记录"

	});

//表格
APCVendorGrid = new Ext.ux.EditorGridPanel({
		id: 'APCVendorGrid',
		store: APCVendorGridDs,
		cm: APCVendorGridCm,
		title: '供应商明细',
		region: 'center',
		height: 690,
		sm: sm,
		loadMask: true,
		bbar: APCVendorPagingToolbar,
		listeners: {
			'rowdblclick': function () {
				editAPCVendor.handler();
			}
		}
	});
function Query(){
	var conditionCode = Ext.getCmp('conditionCodeField').getValue();
	var conditionName = Ext.getCmp('conditionNameField').getValue();
	var conditionState = Ext.getCmp('conditionStateField').getValue();
	var conditioncategoryField = Ext.getCmp('conditioncategoryField').getValue();
	var rcFlag = Ext.getCmp('includeRc').getValue(); //是否包含中间代理商
	if (rcFlag == true) {
		rcFlag = "Y";
	} else {
		rcFlag = "N";
	}
	var others = rcFlag + "^" + conditioncategoryField; //以后增加的查询条件都放在others中
	APCVendorGridDs.setBaseParam('conditionCode', conditionCode);
	APCVendorGridDs.setBaseParam('conditionName', conditionName);
	APCVendorGridDs.setBaseParam('conditionState', conditionState);
	APCVendorGridDs.setBaseParam('others', others);
	APCVendorGridDs.load({
		params: {
			start: 0,
			limit: APCVendorPagingToolbar.pageSize
		}
	});
}

//=========================供应商类别=============================

//===========模块主页面===========================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [formPanel, APCVendorGrid],
			renderTo: 'mainPanel'
		});

	Query();
});

//===========模块主页面===========================================
