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
var inciTakePicWindow;
var selectedPicType = '';
var selectedPicTypeDesc = '';
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

var Log_PicWin, xinci = "", xtype = "";
////flag 判断是否清空store和formpanel
ShowProductImageWindow = function (Store, inci, type) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	xinci = inci;
	xtype = type;
	//已存在的,直接加载
	if (Log_PicWin) {
		Log_PicWin.show();
		return;
	}

	var ftpsrc = "http://" + gParam[5];
	var sellist = "";

	var picTpl = new Ext.XTemplate(
			'<tpl for=".">',
			'<div style="padding:5px; height:260px; width:260px; float:left;" class="select_pic" >',
			'<img  class="pic" src="'
			 + ftpsrc
			 + '{picsrc}"style="height:250px; width:250px;"position: relative;>',
			'<p>{imgtype}</p>',
			'</div>', '</tpl>');

	var picView = new Ext.DataView({
			store: Store,
			tpl: picTpl,
			frame: true,
			singleSelect: true,
			trackOver: true,
			selectedClass: 'selected-pic',
			overClass: 'over-pic',
			itemSelector: 'div.select_pic',
			emptyText: '没有图片',
			listeners: {
				'dblclick': function (v, r) {
					var src = Store.getAt(r).get('picsrc');
					Ext.get("custom").dom.src = ftpsrc + src;
					// //获取图片的实际大小
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
								handles: 'all', // shorthand for 'n
								draggable: true
							});
					}
					var customEl = cus.getEl();
					customEl.on('dblclick', function () {
						cus.resizeTo(1, 1);
						flag = 0;
						PicWin.show();
					});
					var height = 600; // /设置默认高度
					var width = image.width / (image.height / height); // /按照比例缩放
					// 防止变形
					cus.resizeTo(width, height);
					customEl.setStyle('z-index','100');
					PicWin.hide();
				}

			}

		});
	var bUpdate = new Ext.Toolbar.Button({
			text: '添加图片',
			id: 'addPic',
			tooltip: '添加图片',
			iconCls: 'page_goto',
			disabled: true,
			handler: function () {
				if (selectedPicType == "") {
					Ext.getCmp('picType').focus();
					Msg.info('error', '请选择图片类型');
					return;
				} else {
					if (selectedPicType == 'productmaster') {
						if (masterPicFileExists(xinci) > 0) {
							Ext.getCmp("takePhoto").setDisabled(true);
							Ext.getCmp("addPic").setDisabled(true);
							Ext.getCmp('picType').setValue("");
							return;
						}
					}

				}
				addProductImage(selectedPicType, xinci);
			}
		});

	var bDelete = new Ext.Toolbar.Button({
			text: '删除选中图片',
			tooltip: '删除选中图片',
			iconCls: 'page_goto',
			handler: function () {
				var arrpicr = picView.getSelectedRecords() // 数组
					if ((!arrpicr) || (arrpicr.length == 0)) {
						Msg.info("warning", '请选择要删除的图片!');
						return;
					}
					var picr = arrpicr[0];
				var row = picr.get("rowid");
				var picsrc = picr.get("picsrc");
				FnDel(row, picsrc, picr);

			}
		});

	var bSetProductMaster = new Ext.Toolbar.Button({
			text: '设置为主图片',
			tooltip: '设置为主图片',
			iconCls: 'page_goto',
			handler: function () {
				var arrpicr = picView.getSelectedRecords() // 数组
					if ((!arrpicr) || (arrpicr.length == 0)) {
						Msg.info("warning", '请选择要设置的图片!');
						return;
					}
					var picr = arrpicr[0];
				var row = picr.get("rowid");
				var imgtype = picr.get("imgtype");
				if (imgtype == '主图片') {
					Msg.info('error', '已经是主图片');
					return;
				}

				setProductMaster(row);

			}
		});

	var bExit = new Ext.Toolbar.Button({
			text: '退出',
			tooltip: '退出',
			iconCls: 'page_goto',
			handler: function () {
				PicWin.hide();
			}
		});

	var bTakePhoto = new Ext.Toolbar.Button({
			text: '拍照',
			id: 'takePhoto',
			tooltip: '拍照',
			iconCls: 'page_goto',
			disabled: true,
			handler: function () {
				if (selectedPicType == "") {
					Ext.getCmp('picType').focus();
					Msg.info('error', '请选择图片类型');
					return;
				} else {
					if (selectedPicType == 'productmaster') {
						if (masterPicFileExists(xinci) > 0) {
							Ext.getCmp("takePhoto").setDisabled(true);
							Ext.getCmp("addPic").setDisabled(true);
							Ext.getCmp('picType').setValue("");
							return;
						}
					}
				}

				take_pic_inci(xinci, selectedPicType, selectedPicTypeDesc);
			}
		});

	var typeCb = new Ext.form.ComboBox({
			// fieldLabel:'图片类型',
			allowBlank: false,
			id: 'picType',
			mode: 'local',
			width: 120,
			triggerAction: 'all',
			editable: false,
			store: new Ext.data.ArrayStore({
				fields: [
					'typeCode',
					'typeDesc'
				],
				data: [['productmaster', '主图片'], ['product', '普通图片'], ['instruct', '说明书']]
			}),
			valueField: 'typeCode',
			displayField: 'typeDesc',
			listeners: {
				'select': function (c) {
					selectedPicType = c.getValue();
					selectedPicTypeDesc = c.getRawValue();
					if (selectedPicType == "") {
						Ext.getCmp("takePhoto").setDisabled(true);
						Ext.getCmp("addPic").setDisabled(true);
					} else {
						Ext.getCmp("takePhoto").setDisabled(false);
						Ext.getCmp("addPic").setDisabled(false);
					}
				}
			}
		})

	function take_pic_inci(inci, type, typeDesc) {
		if (inci == "") {
			return;
		}
		var AppName = 'DHCSTDRUGMAINTAINM';
		if ((!inciTakePicWindow) || (inciTakePicWindow.closed)) {
			var lnk = 'dhcstm.takepiccommon.csp';
			lnk = lnk + "?AppName=" + AppName;
			lnk = lnk + "&RowId=" + inci;
			lnk = lnk + "&typeCode=" + type;
			lnk = lnk + "&typeDesc=" + typeDesc;
			lnk = lnk + "&GroupId=" + session['LOGON.GROUPID'];
			lnk = lnk + "&LocId=" + session['LOGON.CTLOCID'];
			lnk = lnk + "&UserId=" + session['LOGON.USERID'];
			inciTakePicWindow = window.open(lnk, "take_photo", "height=600,width=800,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=yes");
		} else {
			inciTakePicWindow.SetType(AppName, inci, type, typeDesc, session['LOGON.GROUPID'], session['LOGON.CTLOCID'], session['LOGON.USERID']);
			inciTakePicWindow.focus();
		}
	}
	function addProductImage(type, inci) {
		var dialog = new Ext.ux.UploadDialog.Dialog({
				width: 600,
				height: 400,
				url: 'dhcstm.druginfomaintainaction.csp?actiontype=UploadImage&IncRowid=' + inci, ///全局rowid
				reset_on_hide: false,
				permitted_extensions: ['gif', 'jpeg', 'jpg', 'png', 'bmp'],
				allow_close_on_upload: true,
				upload_autostart: false,
				title: '上传物资图片',
				base_params: {
					'type': type
				},
				//post_var_name: 'file'
				listeners: {
					'uploadcomplete': function () {
						retrieve();
					}
				}
			})

			dialog.show();
	};

	var detailPanel = new Ext.form.FormPanel({
			region: 'center',
			autoScroll: true,
			tbar: ['->', {
					xtype: 'label',
					text: '请选择图片类型:'
				}, typeCb, '-', bUpdate, '-', bTakePhoto, '-', bDelete, '-', bSetProductMaster, '-', bExit],
			items: picView
		});

	var PicWin = new Ext.Window({
			title: '图片信息',
			width: gWinWidth,
			height: gWinHeight,
			closeAction: 'hide',
			layout: 'border',
			modal: true,
			listeners: {
				'show': function () {
					retrieve();
					Log_PicWin = PicWin;
				}
			},
			items: [detailPanel],
			inci: '',
			type: ''
		});

	PicWin.inci = inci;
	PicWin.type = type;
	PicWin.show();
	function retrieve() {
		Store.removeAll();
		Store.load({
			params: {
				'IncRowid': xinci,
				'type': xtype
			}
		});
	}

	function FnDel(rowid, picsrc, picr) {
		var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
		Ext.Ajax.request({
			url: 'dhcstm.druginfomaintainaction.csp?actiontype=DeleteProductImage&rowid=' + rowid + '&picsrc=' + picsrc,
			waitMsg: '删除中...',
			failure: function (result, request) {
				mask.hide();
				Msg.info("error", "请检查网络连接!");
				return false;
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Msg.info("success", "删除成功!");

					Store.remove(picr);
					picView.refresh();
					return true;

				} else {
					Msg.info("error", "删除失败!");
					return false;
				}
			},
			scope: this
		});
		return true;
	}
	function setProductMaster(rowid) {
		var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
		Ext.Ajax.request({
			url: 'dhcstm.druginfomaintainaction.csp?actiontype=setProductMaster&rowid=' + rowid,
			waitMsg: '修改中...',
			failure: function (result, request) {
				mask.hide();
				Msg.info("error", "请检查网络连接!");
				return false;
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Msg.info("success", jsonData.message);
					Store.reload();
					picView.refresh();
					return true;
				} else {
					Msg.info("error", jsonData.message);
					return false;
				}
			},
			scope: this
		});
		return true;
	}
	function masterPicFileExists(itm) {
		var cls = "web.DHCSTM.DrugInfoMaintain";
		var mtd = "GetProductMaster";
		var ss = tkMakeServerCall(cls, mtd, itm);
		if (ss != "") {
			var result = ss.split("^");
			if (result.length > 0) {
				var masterPicFile = result[0];
				if (masterPicFile != "") {
					Msg.info("error", "主图片已经存在!");
					return 1;
				}
			}

		}
		return 0
	}
}
