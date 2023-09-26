/*
模块:处方点评
子模块:处方点评-点评相关配置-点评管制分类维护
 */
var unitsUrl = 'dhcpha.comment.addcontrol.save.csp';

Ext.onReady(function () {

	Ext.QuickTips.init(); // 浮动信息提示
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var ctrlgridcm = new Ext.grid.ColumnModel({

			columns : [
				{
					header : '描述',
					dataIndex : 'ctrldesc',
					width : 300
				}, {
					header : 'rowid',
					dataIndex : 'ctrlrowid',
					width : 40,
					hidden:true
				}

			]

		});

	var ctrlgridds = new Ext.data.Store({
			autoLoad : true,
			proxy : new Ext.data.HttpProxy({
				url : unitsUrl
				 + '?action=QueryCtrlDs',
				method : 'POST'
			}),
			reader : new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : 'results'
			}, [
					'ctrldesc',
					'ctrlrowid'

				]),

			remoteSort : true
		});

	var ctrlgrid = new Ext.grid.GridPanel({
			title : '已维护记录<双击删除>',
			id : 'ctrltbl',
			region : 'center',
			width : 250,
			autoScroll : true,
			enableHdMenu : false,
			ds : ctrlgridds,
			cm : ctrlgridcm,
			enableColumnMove : false,
			stripeRows : true,
			trackMouseOver : 'true'

		});

	////////管制分类Grid


	var poisongridcm = new Ext.grid.ColumnModel({

			columns : [
				{
					header : '描述',
					dataIndex : 'poisondesc',
					width : 300
				}, {
					header : 'rowid',
					dataIndex : 'poisonrowid',
					width : 40,
					hidden:true
				}

			]

		});

	var poisongridds = new Ext.data.Store({
			autoLoad : true,
			proxy : new Ext.data.HttpProxy({
				url : unitsUrl
				 + '?action=GetPHPoison',
				method : 'POST'
			}),
			reader : new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : 'results'
			}, [
					'poisondesc',
					'poisonrowid'

				]),

			remoteSort : true
		});

	var poisongrid = new Ext.grid.GridPanel({

			id : 'poisontbl',
			title : '抗菌药物级别维护<双击增加>',
			region : 'west',
			width : 350,
			autoScroll : true,
			enableHdMenu : false,
			ds : poisongridds,
			cm : poisongridcm,
			enableColumnMove : false,
			stripeRows : true,
			trackMouseOver : 'true'

		});

	///view

	var por = new Ext.Viewport({

			layout : 'border', // 使用border布局

			items : [poisongrid, ctrlgrid]

		});

	///-----------------------Events----------------------


	///双击grid添加
	poisongrid.on('rowdblclick', function (grid, rowIndex, e) {

		var selectedRow = poisongridds.data.items[rowIndex];
		var poisondesc = selectedRow.data["poisondesc"];
		var poisonrowid = selectedRow.data["poisonrowid"];
		InsertToCtrlGrid(poisonrowid);

	});

	///数据库交互
	function InsertToCtrlGrid(poisonrowid) {

		Ext.Ajax.request({

			url : unitsUrl + '?action=CtrlAdd&PoisonID=' + poisonrowid,

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
					QueryCtrlDs();
				}else if (jsonData.retvalue == -3){
					Ext.Msg.alert("提示", "该管制分类/该抗菌药物级别为空!");
				}else if (jsonData.retvalue == -4){
					Ext.Msg.alert("提示", "该管制分类/该抗菌药物级别已不存在!");
				}else if (jsonData.retvalue == -2){
					Ext.Msg.alert("提示", "该管制分类已维护/该抗菌药物级别已维护!");
				}else {
					Ext.Msg.alert("错误", "保存失败!返回值: " + jsonData.retinfo);
				}
			},

			scope : this
		});

	}

	///查找数据

	function QueryCtrlDs() {
		ctrlgridds.removeAll();

		ctrlgridds.proxy = new Ext.data.HttpProxy({
				url : unitsUrl + '?action=QueryCtrlDs'
			});

		ctrlgridds.load({

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

	ctrlgrid.on('rowdblclick', function (grid, rowIndex, e) {

		var selectedRow = poisongridds.data.items[rowIndex];
		var ctrldesc = selectedRow.data["ctrldesc"];
		var ctrlrowid = selectedRow.data["ctrlrowid"];
		DelCtrlClick(ctrlrowid);

	});

	///修改原因的事件

	function DelCtrlClick(ctrlrowid) {

		Ext.MessageBox.confirm('注意', '确认要删除吗 ? ', DelClickResult);

	}

	///删除确认动作
	function DelClickResult(btn) {
		if (btn == "no") {
			return;
		}

		var row = Ext.getCmp("ctrltbl").getSelectionModel().getSelections();
		var ctrlrowid = row[0].data.ctrlrowid; //ID


		///数据库交互删除

		Ext.Ajax.request({

			url : unitsUrl + '?action=CtrlDel&CtrlID=' + ctrlrowid,

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
					//Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					QueryCtrlDs();
				} else {
					Ext.Msg.alert("提示", "删除失败!返回值: " + jsonData.retinfo);

				}
			},

			scope : this
		});

	}

});
