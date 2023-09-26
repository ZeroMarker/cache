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
var DisplayAllPicFlag = false;
var MainTainFlag = true;
var image = new Image();

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
//flag 判断是否清空store和formpanel
ShowManfPicWindow = function (manf) {
	var ftpsrc = "http://" + gParam[5];
	var sellist = "";
	var currManfRowId = manf;
	var PicUrl = 'dhcstm.phmanfaction.csp?actiontype=GetManfPic';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
			url: PicUrl,
			method: "POST"
		});
	// 指定列参数
	var fields = ["rowid", "manfid", "manfName", "picsrc", "typeName"];
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

	var picTpl = new Ext.XTemplate(
			'<tpl for=".">',
			'<div style="padding:5px; height:260px; width:260px; float:left;" class="select_pic" >',
			'<img  class="pic" src="'
			 + ftpsrc
			 + '{picsrc}"style="height:250px; width:250px;"position: relative;>',
			'<p>{typeName}</p>',
			'</div>', '</tpl>');

	var picView = new Ext.DataView({
			store: PicStore,
			tpl: picTpl,
			frame: true,
			singleSelect: true,
			trackOver: true,
			selectedClass: 'selected-pic',
			overClass: 'over-pic',
			itemSelector: 'div.select_pic',
			emptyText: '请选择要显示的资质图片',
			listeners: {
				'dblclick': function (v, r) {
					var src = PicStore.getAt(r).get('picsrc');
					Ext.get("custom").dom.src = ftpsrc + src;
					image.src = ftpsrc + src;
					if(!Ext.isIE11){
						//IE8,9必须加载图片, IE11不需要
						document.body.appendChild(image);
					}
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
					var customEl = cus.getEl();
					customEl.on('dblclick', function () {
						cus.resizeTo(1, 1);
						flag = 0;
						PicWin.show();
					});
					var height = 600;
					var width = image.width / (image.height / height);
					cus.resizeTo(width, height);
					customEl.setStyle('z-index','100');
					PicWin.hide();
				}
			}
		});

	var bDelete = new Ext.Toolbar.Button({
			text: '删除选中图片',
			tooltip: '删除选中图片',
			iconCls: 'page_delete',
			handler: function () {
				var arrpicr = picView.getSelectedRecords() // 数组
					if ((!arrpicr) || arrpicr.length == 0) {
						Msg.info("warning", '请选择要删除的图片!');
						return;
					}
					var picr = arrpicr[0];
				var row = picr.get("rowid");
				var picsrc = picr.get("picsrc");
				FnDel(row, picsrc, picr, RefreshPic);
			}
		});

	var exitBt = new Ext.Toolbar.Button({
			text: '关闭',
			iconCls: 'page_close',
			handler: function () {
				PicWin.hide();
			}
		});

	var displayAllPic = new Ext.Toolbar.Button({
			text: '全部显示',
			iconCls: 'page_find',
			handler: function () {
				DisplayAllPicFlag = true;
				Ext.getCmp("comLic").setValue(true);
				Ext.getCmp("taxLic").setValue(true);
				Ext.getCmp("orgCode").setValue(true);
				Ext.getCmp("insProLic").setValue(true);
				Ext.getCmp("insBusLic").setValue(true);
				Ext.getCmp("drugProLic").setValue(true);
				Ext.getCmp("other").setValue(true);
				Ext.getCmp("socialCreditCode").setValue(true);
				PicStore.load({
					params: {
						'manf': PicWin.manf,
						'type': sellist
					}
				});
				PicStore.on('load', function () {
					DisplayAllPicFlag = false;
				});

			}
		});
	var displayAllPicNot = new Ext.Toolbar.Button({
			text: '清除全选',
			id: 'displayAllPicNot',
			iconCls: 'page_clearscreen',
			handler: function () {
				DisplayAllPicFlag = true;
				Ext.getCmp('comLic').setValue(false);
				Ext.getCmp('taxLic').setValue(false);
				Ext.getCmp('orgCode').setValue(false);
				Ext.getCmp('insBusLic').setValue(false);
				Ext.getCmp('insProLic').setValue(false);
				Ext.getCmp('drugProLic').setValue(false);
				Ext.getCmp('other').setValue(false);
				Ext.getCmp('socialCreditCode').setValue(false);
				picView.getStore().removeAll();
				sellist = "";
				picView.refresh();
				DisplayAllPicFlag = false;

			}
		});

	var maintain = new Ext.form.Checkbox({
			id: 'maintain',
			boxLabel: '保持查看选项',
			height: 25,
			checked: MainTainFlag,
			listeners: {
				'check': function (v) {
					MainTainFlag = v.getValue();
				}
			}
		});

	var fileTypeValuex = new Ext.form.ComboBox({
			id: 'fileTypeValuex',
			triggerAction: 'all',
			mode: 'local',
			editable: false,
			store: new Ext.data.ArrayStore({
				id: 0,
				fields: [
					'typeCode',
					'typeDesc'
				],
				data: [['socialCreditCode', '社会信用码'], ['comLic', '工商执照'], ['taxLic', '税务执照'], ['orgCode', '机构代码'], ['insBusLic', '器械经营许可证'],
					['insProLic', '器械生产许可证'], ['drugProLic', '药品生产许可证'], ['other', '其他']]
			}),
			width: 200,
			valueField: 'typeCode',
			displayField: 'typeDesc',
			listeners: {  
				select:function(combo, record, index){  
    				var typecode=record.get("typeCode");
    				Ext.getCmp('fileTypeValuex').setValue(typecode);
    				
				}
			} 
		});

	var fileBt = new Ext.Toolbar.Button({
			text: '图片重新归档为:',
			iconCls: 'page_save',
			handler: function () {
				var typeDesc = Ext.getCmp('fileTypeValuex').getRawValue();
				var typeValue = Ext.getCmp('fileTypeValuex').getValue();
				if (typeValue == '') {
					Msg.info("warning", '请选择重新归档的类型!');
					Ext.getCmp('fileTypeValuex').focus();
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
				var typeName = picr.get("typeName");
				if (typeDesc == typeName) {
					Msg.info('error', '与当前资质相同，请选择其他资质！');
					Ext.getCmp('fileTypeValuex').setValue('');
					Ext.getCmp('fileTypeValuex').focus();
				} else {
					Ext.Ajax.request({
						url: "dhcstm.phmanfaction.csp?actiontype=UpdateManfPic&rowid=" + row + "&type=" + typeValue,
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info('success', '执行成功');
								PicStore.reload();
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

	var formPanel = new Ext.form.FormPanel({
			region: 'north',
			height: 85,
			tbar: [displayAllPic, '-', displayAllPicNot, '-', maintain, '-', bDelete, '-', fileBt, fileTypeValuex, '-', exitBt],
			baseCls: "x-plain",
			items: [{
					xtype: 'checkboxgroup',
					id: 'mygroup',
					fieldLabel: '选择要显示的资质',
					columns: 5,
					items: [{
							boxLabel: '社会信用码',
							name: 'socialCreditCode',
							id: 'socialCreditCode'
						}, {
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
							boxLabel: '器械生产许可证',
							name: 'insProLic',
							id: 'insProLic'
						}, {
							boxLabel: '器械经营许可证',
							name: 'insBusLic',
							id: 'insBusLic'
						}, {
							boxLabel: '药品生产许可证',
							name: 'drugProLic',
							id: 'drugProLic'
						}, {
							boxLabel: '其他',
							name: 'other',
							id: 'other'
						}
					],
					listeners: {
						'change': function (_checkgroup, _arr) {
							sellist = ""
								for (var i = 0; i < _arr.length; i++) {
									if (sellist == "") {
										sellist = "'" + _arr[i].name + "'";
									} else {
										sellist = sellist + ",'" + _arr[i].name + "'";
									}
								}
								if (!DisplayAllPicFlag) {
									PicStore.load({
										params: {
											'manf': PicWin.manf,
											'type': sellist
										}
									});
								}
						}
					}
				}
			]

		});
	var detailPanel = new Ext.Panel({
			region: 'center',
			autoScroll: true,
			items: picView
		});

	if (!PicWin) {
		PicWin = new Ext.Window({
				title: '图片信息',
				id: 'manfPicWin',
				width: gWinWidth,
				height: gWinHeight,
				modal: true,
				closeAction: 'hide',
				maximizable: true,
				layout: 'border',
				manf: '',
				type: '',
				listeners: {
					'show': function () {
						retrieve();
					}
				},

				items: [formPanel, detailPanel]
			});
	}

	PicWin.manf = manf;
	PicWin.show();

	function retrieve() {
		displayAllPic.handler();
		//fileTypeValuex.clearValue();
		if (MainTainFlag) {
			PicStore.removeAll();
			PicStore.load({
				params: {
					'manf': PicWin.manf,
					'type': sellist
				}
			});
		} else {
			displayAllPicNot.handler();
		}
	}

	function RefreshPic(picr) {
		PicStore.remove(picr);
		picView.refresh();
	}

}

function addManfPic(manf, type) {
	if (manf == "") {
		Msg.info("warning", "请先保存厂商信息,再上传图片!");
		return;
	}
	var dialog = new Ext.ux.UploadDialog.Dialog({
			width: 600,
			height: 400,
			url: 'dhcstm.phmanfaction.csp?actiontype=UploadManfPic&manf=' + manf + "&type=" + type, ///全局rowid
			reset_on_hide: false,
			permitted_extensions: ['gif', 'jpeg', 'jpg', 'png', 'bmp'],
			allow_close_on_upload: true,
			upload_autostart: false,
			title: '上传厂家资料图片',
			base_params: {
				'type': type
			},
			listeners: {
				'uploadcomplete': function () {}
			}
		});
	dialog.show();
};

function FnDel(rowid, picsrc, picr, Ref) {
	var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
	Ext.Ajax.request({
		url: 'dhcstm.phmanfaction.csp?actiontype=DeleteManfPic&rowid=' + rowid + '&picsrc=' + picsrc,
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
				Ref(picr);

			} else {
				Msg.info("error", "删除失败!");
			}
		},
		scope: this
	});
}
