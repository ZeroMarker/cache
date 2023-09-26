/**

 * ����: ͼƬչʾ����
 *
 * ����: ��д�ߣ�xuchao ��д����: 2014.5.22
 *
 * @param {}
 *            store �а������ֶ� rowid ɾ��ʱ��Ӧ��rowid picsrc ͼƬ��·��
 *
 * @param {}
 *            Fndelete ���ý��淽�������ɾ�����ݿ���ͼƬ��Ϣ
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
	GetParam(); // ��ʼ����������
}

var Log_PicWin, xinci = "", xtype = "";
////flag �ж��Ƿ����store��formpanel
ShowProductImageWindow = function (Store, inci, type) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	xinci = inci;
	xtype = type;
	//�Ѵ��ڵ�,ֱ�Ӽ���
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
			emptyText: 'û��ͼƬ',
			listeners: {
				'dblclick': function (v, r) {
					var src = Store.getAt(r).get('picsrc');
					Ext.get("custom").dom.src = ftpsrc + src;
					// //��ȡͼƬ��ʵ�ʴ�С
					image.src = ftpsrc + src;
					if(!Ext.isIE11){
						//IE8,9�������ͼƬ, IE11����Ҫ
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
					var height = 600; // /����Ĭ�ϸ߶�
					var width = image.width / (image.height / height); // /���ձ�������
					// ��ֹ����
					cus.resizeTo(width, height);
					customEl.setStyle('z-index','100');
					PicWin.hide();
				}

			}

		});
	var bUpdate = new Ext.Toolbar.Button({
			text: '���ͼƬ',
			id: 'addPic',
			tooltip: '���ͼƬ',
			iconCls: 'page_goto',
			disabled: true,
			handler: function () {
				if (selectedPicType == "") {
					Ext.getCmp('picType').focus();
					Msg.info('error', '��ѡ��ͼƬ����');
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
			text: 'ɾ��ѡ��ͼƬ',
			tooltip: 'ɾ��ѡ��ͼƬ',
			iconCls: 'page_goto',
			handler: function () {
				var arrpicr = picView.getSelectedRecords() // ����
					if ((!arrpicr) || (arrpicr.length == 0)) {
						Msg.info("warning", '��ѡ��Ҫɾ����ͼƬ!');
						return;
					}
					var picr = arrpicr[0];
				var row = picr.get("rowid");
				var picsrc = picr.get("picsrc");
				FnDel(row, picsrc, picr);

			}
		});

	var bSetProductMaster = new Ext.Toolbar.Button({
			text: '����Ϊ��ͼƬ',
			tooltip: '����Ϊ��ͼƬ',
			iconCls: 'page_goto',
			handler: function () {
				var arrpicr = picView.getSelectedRecords() // ����
					if ((!arrpicr) || (arrpicr.length == 0)) {
						Msg.info("warning", '��ѡ��Ҫ���õ�ͼƬ!');
						return;
					}
					var picr = arrpicr[0];
				var row = picr.get("rowid");
				var imgtype = picr.get("imgtype");
				if (imgtype == '��ͼƬ') {
					Msg.info('error', '�Ѿ�����ͼƬ');
					return;
				}

				setProductMaster(row);

			}
		});

	var bExit = new Ext.Toolbar.Button({
			text: '�˳�',
			tooltip: '�˳�',
			iconCls: 'page_goto',
			handler: function () {
				PicWin.hide();
			}
		});

	var bTakePhoto = new Ext.Toolbar.Button({
			text: '����',
			id: 'takePhoto',
			tooltip: '����',
			iconCls: 'page_goto',
			disabled: true,
			handler: function () {
				if (selectedPicType == "") {
					Ext.getCmp('picType').focus();
					Msg.info('error', '��ѡ��ͼƬ����');
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
			// fieldLabel:'ͼƬ����',
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
				data: [['productmaster', '��ͼƬ'], ['product', '��ͨͼƬ'], ['instruct', '˵����']]
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
				url: 'dhcstm.druginfomaintainaction.csp?actiontype=UploadImage&IncRowid=' + inci, ///ȫ��rowid
				reset_on_hide: false,
				permitted_extensions: ['gif', 'jpeg', 'jpg', 'png', 'bmp'],
				allow_close_on_upload: true,
				upload_autostart: false,
				title: '�ϴ�����ͼƬ',
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
					text: '��ѡ��ͼƬ����:'
				}, typeCb, '-', bUpdate, '-', bTakePhoto, '-', bDelete, '-', bSetProductMaster, '-', bExit],
			items: picView
		});

	var PicWin = new Ext.Window({
			title: 'ͼƬ��Ϣ',
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
		var mask = ShowLoadMask(Ext.getBody(), "���������Ժ�...");
		Ext.Ajax.request({
			url: 'dhcstm.druginfomaintainaction.csp?actiontype=DeleteProductImage&rowid=' + rowid + '&picsrc=' + picsrc,
			waitMsg: 'ɾ����...',
			failure: function (result, request) {
				mask.hide();
				Msg.info("error", "������������!");
				return false;
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Msg.info("success", "ɾ���ɹ�!");

					Store.remove(picr);
					picView.refresh();
					return true;

				} else {
					Msg.info("error", "ɾ��ʧ��!");
					return false;
				}
			},
			scope: this
		});
		return true;
	}
	function setProductMaster(rowid) {
		var mask = ShowLoadMask(Ext.getBody(), "���������Ժ�...");
		Ext.Ajax.request({
			url: 'dhcstm.druginfomaintainaction.csp?actiontype=setProductMaster&rowid=' + rowid,
			waitMsg: '�޸���...',
			failure: function (result, request) {
				mask.hide();
				Msg.info("error", "������������!");
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
					Msg.info("error", "��ͼƬ�Ѿ�����!");
					return 1;
				}
			}

		}
		return 0
	}
}
