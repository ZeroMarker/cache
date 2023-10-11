var AcctInitCompUrl = '../csp/herp.acct.acctinitcompcheckexe.csp';
var AcctCheckTypeID = ""
	var CompInitButton = new Ext.Toolbar.Button({
		text: '完成初始化',
		tooltip: '完成初始化',
		width: 90,
		iconCls: 'datainit',
		handler: function () {
			if (AcctCheckTypeID == "") {
				Ext.Msg.show({
					title: '错误',
					msg: '请选择辅助核算类型',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
				return;
			};
			var line = AcctCheckGrid.getStore().getCount();
			if (line == 0) {
				Ext.Msg.show({
					title: '提示',
					msg: '此核算项下无明细数据，无需初始化！',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.INFO
				});
				return;
			}
/*
			for (var i = 0; i < line; i++) {

				var AcctDiffer = tmpStore.getAt(i).get("AcctDiffer");
				var name = tmpStore.getAt(i).get("AcctSubjName");
				var type=tmpStore.getAt(i).get("type");
				//去掉千分符并且格式化为float类型
				var x = AcctDiffer.split(','); 
				//alert(x);
                var num= parseFloat(x.join("")); 
				//alert(num);
				//如果不为0则不能初始化
				if (parseFloat(num) != 0) {
					Ext.Msg.show({
						title: '错误',
						msg: '【'+name+'】'+type+'的余额不相等，请调整后执行此操作！',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.ERROR
					});
					return;
				}
			}*/
			Ext.MessageBox.confirm('提示', '确实要进行数据初始化吗?', handler);
			function handler(id) {
				if (id == 'yes') {
					// 添加进度条
					var progressBar = Ext.Msg.show({
							title: "数据初始化",
							msg: "'数据正在初始化中...",
							width: 300,
							wait: true,
							closable: true
						});
					Ext.Ajax.request({
						url: AcctInitCompUrl + '?action=AcctCheckInit&AcctCheckTypeID=' + AcctCheckTypeID + '&AcctBookID=' + AcctBookID,
						timeout: 10000, //10s

						failure: function (result, request) {
							Ext.Msg.show({
								title: '错误',
								msg: '请检查网络连接!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});
						},
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title: '注意',
									msg: '初始化完成!',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
								CompInitButton.disable();
							} else {
								Ext.Msg.show({
									title: '错误',
									msg: jsonData.info,
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.ERROR
								});
							}
						},
						scope: this
					}),
					AcctTypeTabDs.reload(); //刷新TabPanel
				}
			}
		}
	});

//////////////////	科室辅助账初始化校验
var jxUnitProxy;
var tmpStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: ''
		}),
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}),
		remoteSort: true
	});

/* var AcctCheckDs = new Ext.data.Store({
proxy : jxUnitProxy,
reader : new Ext.data.JsonReader({
root : 'rows',
totalProperty : 'results'
}, ['d1', 'd2', 'd3', 'd4', 'd5', 'd6']),
remoteSort : true
});  */
var jxUnitCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: '<div style="text-align:center">科目编码</div>',
				dataIndex: 'AcctSubjCode',
				width: 150,
				sortable: true
			}, {
				header: '<div style="text-align:center">科目名称</div>',
				dataIndex: 'AcctSubjName',
				width: 200
			}, {
				header: '<div style="text-align:center">借/贷</div>',
				dataIndex: 'Direction',
				width: 60,
				align: 'center'
			}, {
				header: '<div style="text-align:center">总账余额</div>',
				dataIndex: 'EndSum',
				width: 150,
				align: 'right'
			}, {
				header: '<div style="text-align:center">辅助帐余额</div>',
				dataIndex: 'AcctInitEndSum',
				width: 150,
				align: 'right'
			}, {
				header: '<div style="text-align:center">差额</div>',
				dataIndex: 'AcctDiffer',
				width: 150,
				align: 'right'
			}
		]);
		
PageSizePlugin = function() {
	PageSizePlugin.superclass.constructor.call(this, {
				store : new Ext.data.SimpleStore({
							fields : ['text', 'value'],
							data : [['10', 10], ['20', 20], ['30', 30],
									['50', 50], ['100', 100]]
						}),
				mode : 'local',
				id:'PageSizePluginm',
				displayField : 'text',
				valueField : 'value',
				editable : false,
				allowBlank : false,
				triggerAction : 'all',
				width : 40
			});
};

Ext.extend(PageSizePlugin, Ext.form.ComboBox, {
			init : function(paging) {
				paging.on('render', this.onInitView, this);
			},

			onInitView : function(paging) {
				paging.add('-', this, '-');
				this.setValue(paging.pageSize);
				this.on('select', this.onPageSizeChanged, paging);
			},

			onPageSizeChanged : function(combo) {
				this.pageSize = parseInt(combo.getValue());
				this.doLoad(0);
			}
		});	
var jxUnitPagingToolbar = new Ext.PagingToolbar({ // 分页工具栏
		pageSize: 25,
		store: tmpStore,
		displayInfo: true,
		plugins : new PageSizePlugin(),
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"
	});
var AcctCheckGrid = new Ext.grid.GridPanel({ // 表格
		title: '科室辅助账初始化校验',
		region: 'center',
		xtype: 'grid',
		//height : 300,
		//width : 1000,
		store: tmpStore,
		cm: jxUnitCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true
		}),
		loadMask: true,
		tbar: [CompInitButton],
		bbar: jxUnitPagingToolbar
	});
