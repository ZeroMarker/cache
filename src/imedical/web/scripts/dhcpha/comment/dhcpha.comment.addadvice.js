/*
模块:处方点评
子模块:处方点评-点评相关配置-不合格药师建议维护
 */
var unitsUrl = 'dhcpha.comment.addadvice.save.csp';
Ext.onReady(function () {
	Ext.QuickTips.init(); // 浮动信息提示
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var AdviceAddButton = new Ext.Button({
		width : 65,
		id : "AdviceAddBtn",
		text : '增加',
		iconCls:"page_add",
		listeners : {
			"click" : function () {
				AdviceAddClick();
			}
		}
	})

	var AdviceUpdButton = new Ext.Button({
		width : 65,
		id : "AdviceUpdBtn",
		text : '修改',
		iconCls:"page_modify",
		listeners : {
			"click" : function () {

				AdviceUpdClick();

			}
		}

	})

	var AdviceDelButton = new Ext.Button({
		width : 65,
		id : "AdviceDelBtn",
		text : '删除',
		iconCls:"page_delete",
		listeners : {
			"click" : function () {

				AdviceDelClick();

			}
		}

	})

	var AdviceDescField = new Ext.form.TextField({

		width : 400,
		id : "AdviceDescTxt",

		fieldLabel : ""
	})

	var Advicegridcm = new Ext.grid.ColumnModel({

		columns : [
			{
				header : '描述',
				dataIndex : 'advdesc',
				width : 430
			}, {
				header : 'rowid',
				dataIndex : 'advrowid',
				width : 40,
				hidden:true
			}

		]

	});

	var Advicegridds = new Ext.data.Store({
			autoLoad : true,
			proxy : new Ext.data.HttpProxy({
				url : unitsUrl
				 + '?action=QueryAdviceDs',
				method : 'POST'
			}),
			reader : new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : 'results'
			}, [
					'advdesc',
					'advrowid'

				]),

			remoteSort : true
		});

	var Advicegrid = new Ext.grid.GridPanel({

			id : 'Advicetbl',
			title : '不合格药师建议维护',
			region : 'center',
			width : 650,
			autoScroll : true,
			enableHdMenu : false,
			ds : Advicegridds,
			cm : Advicegridcm,
			enableColumnMove : false,
			stripeRows : true,
			tbar : ['描述', AdviceDescField, AdviceAddButton, '-', AdviceUpdButton],
			trackMouseOver : 'true'
		});

	Advicegrid.on('rowclick', function (grid, rowIndex, e) {
		var selectedRow = Advicegridds.data.items[rowIndex];
		var advdesc = selectedRow.data["advdesc"];
		Ext.getCmp("AdviceDescTxt").setValue(advdesc);
	});

	///view

	var por = new Ext.Viewport({
			layout : 'border', // 使用border布局
			items : [Advicegrid]
		});
	///-----------------------Events----------------------


	///增加

	function AdviceAddClick() {

		var advdesc = Ext.getCmp("AdviceDescTxt").getValue();

		if (advdesc == "") {
			Ext.Msg.show({
				title : '提示',
				msg : '请先录入描述!',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.INFO
			});
			return;
		}

		///数据库交互

		Ext.Ajax.request({

			url : unitsUrl + '?action=AdviceAdd&AdviceDesc=' + advdesc,

			waitMsg : '删除中...',
			failure : function (result, request) {
				Ext.Msg.show({
					title : '错误',
					msg : '请检查网络连接!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			},
			success : function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.retvalue == 0) {
					Ext.Msg.show({
						title : '提示',
						msg : '保存成功!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
					QueryAdviceDs();
				} else {
					if (jsonData.retvalue == "-99") {
						Ext.Msg.alert("提示", "需要保存的药师建议与系统中已存在的描述重复，不能保存，请修改!");
					} else {
						Ext.Msg.alert("提示", "保存失败!返回值: " + jsonData.retinfo);
					}

				}
			},

			scope : this
		});

	}

	///查找数据

	function QueryAdviceDs() {
		Advicegridds.removeAll();

		Advicegridds.proxy = new Ext.data.HttpProxy({
				url : unitsUrl + '?action=QueryAdviceDs'
			});

		Advicegridds.load({

			callback : function (r, options, success) {

				if (success == false) {
					Ext.Msg.show({
						title : '注意',
						msg : '查询失败 !',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
				}
			}

		});

	}

	///修改事件

	function AdviceUpdClick() {

		var row = Ext.getCmp("Advicetbl").getSelectionModel().getSelections();

		if (row.length == 0) {

			Ext.Msg.show({
				title : '提示',
				msg : '未选中记录!',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.INFO
			});
			return;
		}

		var advrowid = row[0].data.advrowid; //原因ID
		var advdesc = Ext.getCmp("AdviceDescTxt").getValue(); //描述


		if (advdesc == "") {
			Ext.Msg.show({
				title : '提示',
				msg : '请先录入描述!',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.INFO
			});
			return;
		}

		///数据库交互

		Ext.Ajax.request({

			url : unitsUrl + '?action=AdviceUpd&AdviceDesc=' + advdesc + '&AdviceID=' + advrowid,

			waitMsg : '删除中...',
			failure : function (result, request) {
				Ext.Msg.show({
					title : '错误',
					msg : '请检查网络连接!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			},
			success : function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.retvalue == 0) {
					Ext.Msg.show({
						title : '提示',
						msg : '保存成功!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
					QueryAdviceDs();
				}else if (jsonData.retvalue == -99){
					Ext.Msg.alert("提示", "修改后名称已存在!");
				}else{
					Ext.Msg.alert("提示", "保存失败!返回值: " + jsonData.retinfo);
				}
			},

			scope : this
		});

	}

	///修改原因的事件

	function AdviceDelClick() {

		var row = Ext.getCmp("Advicetbl").getSelectionModel().getSelections();

		if (row.length == 0) {

			Ext.Msg.show({
				title : '提示',
				msg : '未选中记录!',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.INFO
			});
			return;
		}

		Ext.MessageBox.confirm('注意', '确认要删除吗 ? ', DelClickResult);

	}

	///删除确认动作
	function DelClickResult(btn) {
		if (btn == "no") {
			return;
		}

		var row = Ext.getCmp("Advicetbl").getSelectionModel().getSelections();
		var advrowid = row[0].data.advrowid; //原因ID

		///数据库交互删除

		Ext.Ajax.request({

			url : unitsUrl + '?action=AdviceDel&AdviceID=' + advrowid,

			waitMsg : '删除中...',
			failure : function (result, request) {
				Ext.Msg.show({
					title : '错误',
					msg : '请检查网络连接!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			},
			success : function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.retvalue == 0) {
					Ext.Msg.show({
						title : '提示',
						msg : '删除成功!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
					QueryAdviceDs();
				} else {
					Ext.Msg.alert("提示", "删除失败!返回值: " + jsonData.retinfo);

				}
			},

			scope : this
		});

	}

});