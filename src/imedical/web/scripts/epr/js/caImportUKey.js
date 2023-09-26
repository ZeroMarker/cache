Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	var userData = "";
	var lstUsers = GetUserList();
	var arrUsers = lstUsers.split('&&&');
	// debugger;
	for (var i = 0; i < arrUsers.length; i++) {
		var user = arrUsers[i];
		if (user != "") {
			var keyName = user.split('||')[0];
			var uniqueID = user.split('||')[1];
			if (i > 0) {
				userData += ",";
			}
			userData += "['" + keyName + "','" + uniqueID + "']";
		}
	}
	var key = new Ext.data.Record.create([{
				name : 'keyName',
				type : 'string',
				mapping : 0
			}, {
				name : 'uniqueID',
				type : 'string',
				mapping : 1
			}]);
	var keyProxy = new Ext.data.MemoryProxy(eval("[" + userData + "]"));
	var keyReader = new Ext.data.ArrayReader({}, key);
	var keyStore = new Ext.data.Store({
				proxy : keyProxy,
				reader : keyReader,
				autoLoad : true
			});
	var caAuditForm = new Ext.form.FormPanel({
				id : 'frmCAAudit',
				name : 'frmCAAudit',
				frame : true,
				labelWidth : 65,
				textAlign : 'right',
				labelAlign : 'right',
				buttonAlign : 'right',
				defaultType : 'textfield',
				bodyStyle : 'padding: 0 0 0 0',
				height : 115,
				items : [{
							id : 'cbxKey',
							name : 'cbxKey',
							xtype : 'combo',
							fieldLabel : '选择证书',
							width : 140,
							mode : 'local',
							triggerAction : 'all',
							hiddenName : 'txtKeyName',
							store : keyStore,
							displayField : 'keyName',
							valueField : 'uniqueID',
							readOnly : true,
							allowBlank : false,
							emptyText : '请选择证书!',
							blankText : '请选择证书!'
						}, {
							id : 'txtUsrName',
							name : 'txtUsrName',
							xtype : 'textfield',
							width : 140,
							fieldLabel : '用户名',
							allowBlank : false,
							blankText : '请输入用户名!'
						}],
				bbar : [{
							text : '更新',
							minWidth : 72,
							handler : function() {
								var key = Ext.getCmp("cbxKey").value;
								if (typeof(key) == "undefined")
									return;
								var usrName = Ext.getCmp("txtUsrName")
										.getValue();
								if (trim(usrName) == "")
									return;
								registKey(key, usrName);
							}
						}, '-', {
							text : '停用',
							minWidth : 72,
							handler : function() {
								var usrName = Ext.getCmp("txtUsrName")
										.getValue();
								if (trim(usrName) == "")
									return;
								disuse(usrName);
							}
						}, '-', {
							text : '设置CA服务',
							id : 'btnSetCA',
							name : 'btnSetCA',
							minWidth : 140,
							handler : function() {
								setCA();
							}
						}]
			});

	function setCA() {
		Ext.getCmp('caCommit').disable();
		Ext.Ajax.request({
					url : '../web.eprajax.logs.ImportUKey.cls?action=SetCA',
					timeout : parent.parent.timedOut,
					async : true,
					success : function(response, opts) {
						var obj = response.responseText;
						if ("1" == obj) {
							Ext.getCmp('btnSetCA').setText("关闭CA服务");
						} else if ("0" == obj) {
							Ext.getCmp('btnSetCA').setText("开启CA服务");
						} else {
							alert("操作失败");
						}
						Ext.getCmp('caCommit').enable();
					},
					failure : function(response, opts) {
						var obj = "操作失败,错误代码:" + response.status + ","
								+ "错误信息:" + response.statusText;
						alert(obj);
						Ext.getCmp('caCommit').enable();
					}
				});
	}

	function doSearch(url) {
		Ext.getCmp('resultGrid').getEl().mask('数据重新加载中，请稍等');
		var s = Ext.getCmp('resultGrid').getStore();
		if (!s.proxy) {
			s.proxy = new Ext.data.HttpProxy({
						url : url
					});
		} else {
			s.proxy.conn.url = url;
		}
		s.load({
					params : {
						start : 0,
						limit : queryPageSize
					}
				});
		s.on('load', function(store, record) {
					Ext.get('resultGrid').unmask();
				});
		s.on('loadexception', function(proxy, options, response, e) {
					Ext.get('resultGrid').unmask();
				});
	}
	var rowNumber = new Ext.grid.RowNumberer({
				width : 30,
				sortable : false
			});
	var cm = new Ext.grid.ColumnModel({
				columns : [rowNumber,

				{
							header : "科室",
							dataIndex : "CTLOC",
							width : 100
						},

						{
							header : "用户名",
							dataIndex : "usrName",
							width : 100
						},

						{
							header : "用户姓名",
							dataIndex : "Name",
							width : 100
						},

						{
							header : "是否已经关联",
							dataIndex : "isUsed",
							width : 100
						}],
				defaults : {
					sortable : false,
					fixed : true,
					resizable : false
				}
			});
	var resultStore = new Ext.data.JsonStore({
				autoLoad : false,
				root : 'data',
				totalProperty : 'TotalCount',
				fields : ["CTLOC", "usrName", "Name", "isUsed"]
			});
	var queryPageSize = 100;
	var resultGrid = new Ext.grid.GridPanel({
		id : 'resultGrid',
		region : 'center',
		frame : true,
		border : 'false',
		autoScroll : true,
		bodyStyle : 'width:99%',
		autoWidth : true,
		height : 200,
		store : resultStore,
		cm : cm,
		stripeRows : true,
		viewConfig : {
			forceFit : false
		},
		singleSelect : true,
		loadMask : {
			msg : '数据正在加载中……'
		},
		tbar : ['科室编号', {
					id : 'ctlocid',
					xtype : 'textfield',
					emptyText : '科室编号',
					blankText : '请输入科室编号!',
					width : 120
				}, '关联状态', {
					id : 'cbxStatus',
					name : 'cbxStatus',
					xtype : 'combo',
					editable : false,
					width : 120,
					displayField : 'name',
					valueField : 'id',
					typeAhead : true,
					mode : 'local',
					triggerAction : 'all',
					selectOnFocus : true,
					resizable : false,
					allowBlank : false,
					forceSelection : true,
					store : new Ext.data.SimpleStore({
								fields : ["id", "name"],
								data : eval("[['0','全部'],['1','已关联'],['2','未关联']]")
							})
				}, '-', {
					id : 'btnSearchCTLOC',
					text : '查找',
					cls : 'x-btn-text-icon',
					icon : '../scripts/epr/Pics/btnSearch.gif',
					pressed : false,
					handler : function() {
						var ctlocid = Ext.getCmp('ctlocid').getValue();
						var isUsed = Ext.getCmp('cbxStatus').getValue();
						if (ctlocid == "")
							return;
						var url = '../web.eprajax.logs.ImportUKey.cls?action=GetUsrSignInfo'
								+ '&ctlocid='
								+ ctlocid
								+ '&isUsed='
								+ isUsed
								+ '&getType=ctlocid';
						doSearch(url);
					}
				}, '-', ' ', '-', '用户名', {
					id : 'usrID',
					xtype : 'textfield',
					width : 120,
					emptyText : '用户名'
				}, '-', {
					id : 'btnSearchUsr',
					text : '查找',
					cls : 'x-btn-text-icon',
					icon : '../scripts/epr/Pics/btnSearch.gif',
					pressed : false,
					handler : function() {
						var usrName = Ext.getCmp('usrID').getValue();
						if (usrName == "")
							return;
						var url = '../web.eprajax.logs.ImportUKey.cls?action=GetUsrSignInfo'
								+ '&usrName=' + usrName + '&getType=usrName';
						doSearch(url);
					}
				}, '-', ' ', '-', '选择证书', {
					id : 'cbxCertKey',
					name : 'cbxCertKey',
					xtype : 'combo',
					fieldLabel : '选择证书',
					width : 140,
					mode : 'local',
					triggerAction : 'all',
					hiddenName : 'txtKeyName',
					store : keyStore,
					displayField : 'keyName',
					valueField : 'uniqueID',
					readOnly : true,
					allowBlank : false,
					emptyText : '请选择证书!',
					blankText : '请选择证书!'
				}, '-', {
					id : 'btnSearchCert',
					text : '查找',
					cls : 'x-btn-text-icon',
					icon : '../scripts/epr/Pics/btnSearch.gif',
					pressed : false,
					handler : function() {

						var key = Ext.getCmp("cbxCertKey").value;
						if (typeof(key) == "undefined")
							return;
						var cert = GetSignCert(key);
						var usrCertCode = GetUniqueID(cert);
						var url = '../web.eprajax.logs.ImportUKey.cls?action=GetUsrSignInfo'
								+ '&usrCertCode='
								+ usrCertCode
								+ '&getType=usrCertCode';
						doSearch(url);
					}
				}, '-'],
		bbar : new Ext.PagingToolbar({
					id : "pagingToolbar",
					store : resultStore,
					pageSize : queryPageSize,
					displayInfo : true,
					displayMsg : '第 {0} 条到 {1} 条, 一共 {2} 条',
					beforePageText : '页码',
					afterPageText : '总页数 {0}',
					firstText : '首页',
					prevText : '上一页',
					nextText : '下一页',
					lastText : '末页',
					refreshText : '刷新',
					emptyMsg : "没有记录"
				}),
		listeners : {
			rowclick : function(grid, row) {
				var record = grid.getStore().getAt(row);
				var data = record.get("usrName");
				Ext.getCmp('txtUsrName').setValue(data);
			}
		}
	});
	var portal = new Ext.Viewport({
				id : 'caCommit',
				layout : 'border',
				shim : false,
				frame : true,
				animCollapse : false,
				constrainHeader : true,
				collapsible : true,
				margins : '0 0 0 0',
				border : false,
				items : [{
							title : '证书关联',
							region : 'north',
							height : 140,
							margins : '5 5 5 5',
							items : caAuditForm
						}, {
							title : '状态查询',
							region : 'center',
							margins : '5 5 5 5',
							layout : 'border',
							items : resultGrid
						}]
			});
	// 停用
	function disuse(usrName) {
		Ext.getCmp('caCommit').disable();
		// var usrName = Ext.getCmp("txtUsrName").getValue();
		var params = new Array();
		params["action"] = "Disuse";
		params["userName"] = usrName;
		Ext.Ajax.request({
					url : '../web.eprajax.logs.ImportUKey.cls',
					timeout : parent.parent.timedOut,
					async : true,
					/*
					 * params : { userName : usrName, isDisuse : "Disuse" },
					 */
					params : params,
					success : function(response, opts) {
						var obj = response.responseText;
						if ("success" == obj) {
							refreshStatus(0);
							alert("停用成功");
						} else {
							alert("操作失败!错误原因:" + obj);
						}
						Ext.getCmp('caCommit').enable();
					},
					failure : function(response, opts) {
						var obj = "操作失败,错误代码:" + response.status + ","
								+ "错误信息:" + response.statusText;
						alert(obj);
						Ext.getCmp('caCommit').enable();
					}
				});
	}

	function registKey(key, usrName) {
		Ext.getCmp('caCommit').disable();
		var params = getUsrSignatureInfo(key);
		if ("" == params["UsrCertCode"]) {
			alert("用户证书标识不能为空！");
			return;
		}
		params["userName"] = usrName;
		Ext.Ajax.request({
					url : '../web.eprajax.logs.ImportUKey.cls',
					timeout : parent.parent.timedOut,
					async : true,
					params : params,
					success : function(response, opts) {
						var obj = response.responseText;
						if ("success" == obj) {
							refreshStatus(1)
							alert("关联成功");
						} else {
							alert("操作失败!错误原因:" + obj);
						}
						Ext.getCmp('caCommit').enable();
					},
					failure : function(response, opts) {
						var obj = "操作失败,错误代码:" + response.status + ","
								+ "错误信息:" + response.statusText;
						alert(obj);
						Ext.getCmp('caCommit').enable();
					}
				});
	}
	
	Ext.getCmp('cbxStatus').setValue(0);
	
	function refreshStatus(flag) {
		var count = Ext.getCmp('resultGrid').getStore().getCount();
		for (var i = 0; i < count; i++) {
			var rec = Ext.getCmp('resultGrid').getStore().getAt(i);
			if (rec.get("usrName") == Ext.getCmp('txtUsrName').getValue()) {
				if (0 == flag)
					rec.set("isUsed", "未关联");
				else
					rec.set("isUsed", "已关联");
				return;
			}
		}
	}

	// 删除左右两端的空格
	function trim(str) {
		return str.replace(/(^\s*)|(\s*$)/g, "");
	}

	if ("Y" == CAService) {
		Ext.getCmp("btnSetCA").setText("关闭CA服务");
	} else {
		Ext.getCmp("btnSetCA").setText("开启CA服务");
	}

});