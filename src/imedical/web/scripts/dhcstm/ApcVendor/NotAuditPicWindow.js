/**
 * 名称: 图片展示窗口
 *
 * 描述: 编写者：xuchao 编写日期: 2014.5.22
 *
 * @param {}
 *            store 中包含的字段 rowid 删除时对应的rowid picsrc 图片的路径
 *
 * @param {}
 *            Fndelete 调用界面方法句柄，删除数据库中图片信息
 */
var cus = null;
var PicWin = null;
var gParam = [];
var DisplayAllTypes = false;
var num = 0;
var sellist = "";

function GetParam() {

	var userId = session['LOGON.USERID'];
	var groupId = session['LOGON.GROUPID'];
	var locId = session['LOGON.CTLOCID'];
	var url = 'dhcstm.ftpcommon.csp?actiontype=GetParamProp&GroupId=' + groupId
		 + '&LocId=' + locId + '&UserId=' + userId;
	var response = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(response);
	if (jsonData.success == 'true') {
		var info = jsonData.info;
		if (info != null || info != '') {
			gParam = info.split('^');
		}
	}
	return;
}

if (gParam.length < 1) {
	GetParam(); // 初始化参数配置
}

////flag 判断是否清空store和formpanel
ShowNotAuditPicWindow = function (Store, currVendorRowId) {
	var ftpsrc = "http://" + gParam[5];
	PicWin = null;
	Store.on('load', function (st) {
		//显示第一个
		if (st.getCount() > 0) {
			picView.select(0);
		} else {
			initPic();
		}
	});
	if (PicWin) {
		PicWin.show();
		return;
	}
	var picTpl = new Ext.XTemplate(
			'<tpl for=".">',
			'<div style="padding:5px; height:110px; width:100px; float:left;" class="select_pic" >',
			'<tpl if="this.isPDF(picsrc)==0"><img  class="pic" src="'
			 + ftpsrc
			 + '{picsrc}"style="height:100px; width:100px;"position: relative;></tpl>',
			 '<tpl if="this.isPDF(picsrc)==1"><img  class="pic" src="'
			+ '../scripts/dhcstm/ExtUX/pdfjs/pdf.jpg'
			+ '"style="height:100px; width:100px;"position: relative;></tpl>',	
			'<p>{type}</p>',
			'</div>', '</tpl>',{
			isPDF: function (picsrc) {
			 	if(picsrc.indexOf(".pdf")==-1){
			 		return 0;
			 	}else{
		         	return 1;
			 	}
		     }
			});

	var picTpl2 = new Ext.XTemplate(
			'<tpl for=".">',
			'<img  class="pic" src="'
			 + ftpsrc
			 + '{picsrc}"style="height:150px; width:160px;"position: relative;>',
			'<p>{type}</p>',
			'</tpl>');

	var customEl = Ext.get("custom");
	customEl.on('dblclick', function () {
		cus.resizeTo(1, 1);
		num = 0;
		cus.getEl().dom.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation=' + num + ')';
		flag = 0;
		PicWin.show();
	});
	customEl.on('contextmenu', function (e, t, o) {
		e.preventDefault();
		rightClick.showAt(e.getXY());

	});
	var rightClick = new Ext.menu.Menu({
			id: 'rightClick',
			items: [{
					handler: function () {
						num = (num + 1) % 4;
						cus.getEl().dom.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation=' + num + ')';
					},
					text: '右旋转'
				}, {
					handler: function () {
						num = (num + 3) % 4;
						cus.getEl().dom.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation=' + num + ')';
					},
					text: '左旋转'
				}, {
					text: '上一张',
					handler: function () {
						next(-1)
					}
				}, {
					text: '下一张',
					handler: function () {
						next(1)

					}
				}

			]
		});
	function next(i) {
		var selArr = picView.getSelectedIndexes();
		var count = picView.getStore().getCount();
		if ((i < 0 && selArr[0] > 0) || (i > 0 && selArr[0] < count - 1)) {
			picView.select(selArr[0] + i, false);
			var src = picView.getStore().getAt(selArr[0] + i).get('picsrc');
			Ext.get("custom").dom.src = ftpsrc + src;
			//获取图片的实际大小
			var image = new Image();
			image.src = ftpsrc + src;
			if(!Ext.isIE11){
				//IE8,9必须加载图片, IE11不需要
				document.body.appendChild(image);
			}
			var height = 600; // /设置默认高度
			var width = image.width / (image.height / height); // /按照比例缩												// 防止变形
			cus.resizeTo(width, height);
		} else if (i < 0) {
			Msg.info("warning", "已经是第一张!");
		} else if (i > 0) {
			Msg.info("warning", "已经是最后一张!");
		}
	}
	var picView = new Ext.DataView({
			store: Store,
			tpl: picTpl,
			frame: true,
			singleSelect: true,
			autoScroll: true,
			trackOver: true,
			selectedClass: 'selected-pic',
			overClass: 'over-pic',
			itemSelector: 'div.select_pic',
			emptyText: '请选择要显示的资质图片',
			listeners: {
				'dblclick': function (v, r) {
					var src = Store.getAt(r).get('picsrc');
					Ext.get("custom").dom.src = ftpsrc + src;
					//获取图片的实际大小
					var image = new Image();
					image.src = ftpsrc + src;
					document.body.appendChild(image); //加载图片
					var height = 600; // /设置默认高度
					var width = image.width / (image.height / height); // /按照比例缩放
					// 防止变形
					if (!cus) {
						cus = new Ext.Resizable("custom", {
								wrap: true,
								pinned: true,
								preserveRatio: true,
								dynamic: true,
								handles: 'all',
								draggable: true
							});
					}
					cus.resizeTo(width, height);
					PicWin.hide();
				},
				'selectionchange': function (v, arrpicr) {
					var arrpicr = v.getSelectedRecords(); // 数组
					if (arrpicr.length < 1)
						return;
					var picr = arrpicr[0];
					var picsrc = picr.get("picsrc");
					var x = document.getElementById('pic');
					if(picsrc.indexOf(".pdf")==-1){
						x.src = ftpsrc + picsrc;
					}else{
						x.src=ftpsrc+"pdfjs/web/viewer.html?file="+ftpsrc + picsrc;
					}
				}
			}
		});
	var bDelete = new Ext.Toolbar.Button({
			text: '删除图片',
			tooltip: '删除选中图片',
			iconCls: 'page_delete',
			handler: function () {
				var arrpicr = picView.getSelectedRecords(); // 数组
				if ((!arrpicr) || (arrpicr.length == 0)) {
					Msg.info("warning", '请选择要删除的图片!');
					return;
				}
				var picr = arrpicr[0];
				FnDelete(picr);
				picView.refresh();
				initPic();

			}
		});
	var exitBt = new Ext.Toolbar.Button({
			text: '关闭',
			iconCls: 'page_close',
			handler: function () {
				Ext.getCmp("fileTypeValue").setValue("");
				PicWin.close();
			}
		});
	var AuditAllPic = new Ext.Toolbar.Button({
			text: '审核通过',
			iconCls: 'page_gear',
			handler: function () {
				var type = "";
				var obj = Ext.getCmp('mygroup');
				for (var i = 0; i < obj.items.length; i++) {

					if (obj.items.itemAt(i).checked) {
						if (type == "") {
							type = obj.items.itemAt(i).name;
						} else {
							type = type + "," + obj.items.itemAt(i).name;
						}
					}
				}
				AuditInfo(currVendorRowId, type);
			}
		});
	var RefuseAllPic = new Ext.Toolbar.Button({
			text: '审核不通过',
			iconCls: 'page_delete',
			handler: function () {
				var type = "";
				var obj = Ext.getCmp('mygroup');
				for (var i = 0; i < obj.items.length; i++) {
					if (obj.items.itemAt(i).checked) {
						if (type == "") {
							type = obj.items.itemAt(i).name;
						} else {
							type = type + "," + obj.items.itemAt(i).name;
						}
					}
				}
				RefuseRegInfo(currVendorRowId, type);
			}
		});
	function AuditInfo(tvendor, ttype) {
		var url = "dhcstm.apcvendoraction.csp?actiontype=AuditRegInfo";
		var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
		Ext.Ajax.request({
			url: url,
			method: 'POST',
			params: {
				Vendor: tvendor,
				type: ttype
			},
			waitMsg: '处理中...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON
					.decode(result.responseText);
				if (jsonData.success == 'true') {
					// 刷新界面
					Msg.info("success", "审核成功！");
					Store.reload();
				} else {
					var ret = jsonData.info;
					Msg.info("error", "审核失败!");
				}
			},
			scope: this
		});
		loadMask.hide();
	}

	function RefuseRegInfo(tvendor, ttype) {
		var url = "dhcstm.apcvendoraction.csp?actiontype=RefuseRegInfo";
		var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
		Ext.Ajax.request({
			url: url,
			method: 'POST',
			params: {
				Vendor: tvendor,
				type: ttype
			},
			waitMsg: '处理中...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON
					.decode(result.responseText);
				var ret = jsonData.info;
				if (jsonData.success == 'true') {
					// 刷新界面
					Msg.info("success", "拒绝成功！");
					Store.reload();
				} else {
					Msg.info("error", "拒绝失败!" + ret);

				}
			},
			scope: this
		});
		loadMask.hide();
	}

	function FnDelete(picr) {
		var rowid = picr.get("rowid");
		var picsrc = picr.get("picsrc");
		var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
		Ext.Ajax.request({
			url: 'dhcstm.apcvendoraction.csp?actiontype=DeletePic&rowid=' + rowid + '&picsrc=' + picsrc,
			waitMsg: '删除中...',
			failure: function (result, request) {
				mask.hide();
				Msg.info("error", "请检查网络连接!");
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Msg.info("success", "删除成功!");
					Store.remove(picr);
					return true;
				} else {
					Msg.info("error", "删除失败!");
					return false;
				}
			},
			scope: this
		});
	}
	var displayAllPic = new Ext.Toolbar.Button({
			text: '全选显示',
			iconCls: 'page_find',
			handler: function () {
				DisplayAllTypes = true;
				Ext.getCmp('mygroup').setValue({
					'comLic': true,
					'taxLic': true,
					'orgCode': true,
					'drugBusLic': true,
					'insBusLic': true,
					'insProLic': true,
					'legalComm': true,
					'saleServComm': true,
					'agentAuth': true,
					'qualityComm': true,
					'drugProLic': true,
					'gspLic': true,
					'insRegLic': true,
					'inletRegLic': true,
					'inletRLic': true,
					'drugRegLic': true,
					'salesLic': true,
					'vendorAgreement': true,
					'salsPhoto': true,
					'salesID': true,
					'socialCreditComm': true
				});
				var auditflag = (Ext.getCmp("auditFlag").getValue() == true ? 'Y' : 'N');
				Store.load({
					params: {
						'rowid': currVendorRowId,
						'type': sellist,
						'auditflag': auditflag
					}
				});
				Store.on('load', function () {
					DisplayAllTypes = false;
				});
				return;
			}
		});

	var displayAllPicNot = new Ext.Toolbar.Button({
			text: '清除全选',
			iconCls: 'page_clearscreen',
			handler: function () {
				DisplayAllTypes = true;
				Ext.getCmp('mygroup').setValue({
					'comLic': false,
					'taxLic': false,
					'orgCode': false,
					'drugBusLic': false,
					'insBusLic': false,
					'insProLic': false,
					'legalComm': false,
					'saleServComm': false,
					'agentAuth': false,
					'qualityComm': false,
					'drugProLic': false,
					'gspLic': false,
					'insRegLic': false,
					'inletRegLic': false,
					'inletRLic': false,
					'drugRegLic': false,
					'salesLic': false,
					'vendorAgreement': false,
					'salsPhoto': false,
					'salesID': false,
					'socialCreditComm': false
				});
				picView.getStore().removeAll();
				picView.refresh();
				DisplayAllTypes = false;
				initPic();
			}
		});

	var fileBt = new Ext.Toolbar.Button({
			text: '图片重新归档为',
			iconCls: 'page_save',
			handler: function () {
				var typeDesc = Ext.getCmp('fileTypeValue').getRawValue();
				var typeValue = Ext.getCmp('fileTypeValue').getValue();
				if (typeValue == '') {
					Msg.info("warning", '请选择重新归档的类型!');
					Ext.getCmp('fileTypeValue').focus();
					return;
				}
				var arrpicr = picView.getSelectedRecords(); // 数组
				if ((!arrpicr) || (arrpicr.length == 0)) {
					Msg.info("warning", '请选择图片!');
					return;
				}
				var picr = arrpicr[0];
				var row = picr.get("rowid");
				var picsrc = picr.get("picsrc");
				var typeName = picr.get("type");

				if (typeDesc == typeName) {
					Msg.info('error', '与当前资质相同，请选择其他资质！');
					Ext.getCmp('fileTypeValue').setValue('');
					Ext.getCmp('fileTypeValue').focus();
				} else {
					Ext.Ajax.request({
						url: "dhcstm.apcvendoraction.csp?actiontype=UpdatePicInfo&rowid=" + row + "&type=" + typeValue,
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info('success', '执行成功');
								Store.reload();
							} else {
								Msg.info('error', '执行失败');
							}
						},
						failure: function () {
							Msg.info('error', '执行失败');
						}
					})
				}
			}
		});

	var auditFlag = new Ext.form.Checkbox({
			boxLabel: '已审核',
			id: 'auditFlag',
			name: 'auditFlag',
			height: 25,
			checked: false
		});

	var fileCom = new Ext.form.ComboBox({
			id: 'fileTypeValue',
			triggerAction: 'all',
			mode: 'local',
			editable: false,
			store: new Ext.data.ArrayStore({
				id: 0,
				fields: [
					'typeCode',
					'typeDesc'
				],
				data: [['comLic', '工商执照'], ['taxLic', '税务执照'], ['orgCode', '机构代码'], ['drugBusLic', '药品经营许可证'],
					['insBusLic', '器械经营许可证'], ['insProLic', '器械生产许可证'], ['legalComm', '法人委托书'], ['saleServComm', '售后服务承诺书'],
					['agentAuth', '代理授权书'], ['qualityComm', '质量承诺书'], ['drugProLic', '药品生产许可证'], ['gspLic', 'GSP认证'], ['insRegLic', '器械注册证'],
					['inletRegLic', '进口注册登记表'], ['inletRLic', '进口注册证'], ['drugRegLic', '药品注册批件'], ['vendorAgreement', '供应商协议'], 
					['salesLic', '业务员授权书'], ['salsPhoto', '业务员照片'], ['salesID', '业务员身份证复印件'], ['socialCreditComm', '社会信用码']]
			}),
			width: 200,
			valueField: 'typeCode',
			displayField: 'typeDesc'
		});

	var formPanel = new Ext.form.FormPanel({
			region: 'north',
			height: 160,
			baseCls: "x-plain",
			tbar: [displayAllPic, '-', displayAllPicNot, '-', auditFlag, '-', fileBt, fileCom, '-', AuditAllPic, '-', RefuseAllPic, '-', bDelete, '-', exitBt],
			items: [{
					xtype: 'checkboxgroup',
					id: 'mygroup',
					fieldLabel: '选择资质:',
					columns: 5,
					items: [{
							boxLabel: '工商执照',
							name: 'comLic',
							id: 'comLic'
						}, {
							boxLabel: '税务执照',
							name: 'taxLic',
							id: 'taxLic'
						}, {
							boxLabel: '机构代码',
							name: 'orgCode',
							id: 'orgCode'
						}, {
							boxLabel: '药品经营许可证',
							name: 'drugBusLic',
							id: 'drugBusLic'
						}, {
							boxLabel: '器械经营许可证',
							name: 'insBusLic',
							id: 'insBusLic'
						}, {
							boxLabel: '器械生产许可证',
							name: 'insProLic',
							id: 'insProLic'
						}, {
							boxLabel: '法人委托书',
							name: 'legalComm',
							id: 'legalComm'
						}, {
							boxLabel: '售后服务承诺书',
							name: 'saleServComm',
							id: 'saleServComm'
						}, {
							boxLabel: '质量承诺书',
							name: 'qualityComm',
							id: 'qualityComm'
						}, {
							boxLabel: 'GSP认证',
							name: 'gspLic',
							id: 'gspLic'
						}, {
							boxLabel: '供应商协议',
							name: 'vendorAgreement',
							id: 'vendorAgreement'
						}, {
							boxLabel: '业务员授权书',
							name: 'salesLic',
							id: 'salesLic'
						}, {
							boxLabel: '业务员照片',
							name: 'salsPhoto',
							id: 'salsPhoto'
						}, {
							boxLabel: '业务员身份证复印件',
							name: 'salesID',
							id: 'salesID'
						}, {
							boxLabel: '社会信用码',
							name: 'socialCreditComm',
							id: 'socialCreditComm'
						}, {
							boxLabel: '代理授权书',
							name: 'agentAuth',
							id: 'agentAuth'
						}, {
							boxLabel: '药品生产许可证',
							name: 'drugProLic',
							id: 'drugProLic'
						}, {
							boxLabel: '器械注册证',
							name: 'insRegLic',
							id: 'insRegLic'
						}, {
							boxLabel: '进口注册登记表',
							name: 'inletRegLic',
							id: 'inletRegLic'
						}, {
							boxLabel: '进口注册证',
							name: 'inletRLic',
							id: 'inletRLic'
						}, {
							boxLabel: '药品注册批件',
							name: 'drugRegLic',
							id: 'drugRegLic'
						}, {
							boxLabel: '业务员授权书',
							name: 'salesLic',
							id: 'salesLic'
						}, {
							boxLabel: '业务员照片',
							name: 'salsPhoto',
							id: 'salsPhoto'
						}, {
							boxLabel: '业务员身份证复印件',
							name: 'salesID',
							id: 'salesID'
						}, {
							boxLabel: '社会信用码',
							name: 'socialCreditComm',
							id: 'socialCreditComm'
						}, {
							boxLabel: '供应商协议',
							name: 'vendorAgreement',
							id: 'vendorAgreement'
						}
					
					],
					listeners: {
						'change': function (_checkgroup, _arr) {
							sellist = "";
							for (var i = 0; i < _arr.length; i++) {
								if (sellist == "") {
									sellist = "'" + _arr[i].name + "'"
								} else {
									sellist = sellist + ",'" + _arr[i].name + "'"
								}
							}
							if (!DisplayAllTypes) {
								var auditflag = (Ext.getCmp("auditFlag").getValue() == true ? 'Y' : 'N');
								Store.load({
									params: {
										'rowid': currVendorRowId,
										'type': sellist,
										'auditflag': auditflag
									}
								});
							}
						}
					}
				}
			]
		});

	var nextB = new Ext.Toolbar.Button({
			text: '向后>>',
			handler: function () {
				var selArr = picView.getSelectedIndexes();

				if (selArr.length > 0) {
					picView.select(selArr[0] + 1, false);
					var d = detailPanel.body.dom;
					var cnt = picView.getStore().getCount();
					if (cnt > 0) {
						var x = (d.scrollHeight / cnt) * (selArr[0] + 1);
						if (d) {
							d.scrollTop = x;
						}
					}
				} else {
					picView.select(0);
					if (d) {
						d.scrollTop = 0;
					}
				}
			}
		});

	var priorB = new Ext.Toolbar.Button({
			text: '<<向前',
			handler: function () {
				var selArr = picView.getSelectedIndexes();

				if (selArr.length > 0) {
					picView.select(selArr[0] - 1, false);
					var d = detailPanel.body.dom;
					var cnt = picView.getStore().getCount();
					if (cnt > 0) {
						var x = (d.scrollHeight / cnt) * (selArr[0] - 1);
						if (d) {
							d.scrollTop = x;
						}
					}
				} else {
					picView.select(0);
					if (d) {
						d.scrollBottom = 0;
					}
				}
			}
		});

	var detailPanel = new Ext.Panel({
			region: 'west',
			minWidth: 150,
			width: 150,
			autoScroll: true,
			split: true,
			collapsible: true,
			items: picView,
			bbar: new Ext.Toolbar({
				items: ['->', priorB, '-', nextB]
			})
		});

	var detailPanelOne = new Ext.Panel({
			region: 'center',
			split: true,
			html: '<iframe id="pic" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'

		});

	if (!PicWin) {
		PicWin = new Ext.Window({
				title: '图片信息',
				width: gWinWidth,
				height: gWinHeight,
				maximizable: true,
				modal: true,
				closeAction: 'close',
				layout: 'border',
				listeners: {
					'show': function () {
						Store.removeAll();
						Ext.getCmp("fileTypeValue").setValue("");
						Ext.getCmp("auditFlag").setValue("");
						Store.load({
							params: {
								'rowid': currVendorRowId,
								'type': sellist
							}
						});
						displayAllPic.handler();
					}
				},
				items: [formPanel, detailPanel, detailPanelOne]
			});
	}
	PicWin.show();
	function initPic() {
		var x = document.getElementById('pic');
		x.src = "../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
	}
}
