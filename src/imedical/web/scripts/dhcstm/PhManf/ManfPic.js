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
	GetParam(); // ��ʼ����������
}
//flag �ж��Ƿ����store��formpanel
ShowManfPicWindow = function (manf) {
	var ftpsrc = "http://" + gParam[5];
	var sellist = "";
	var currManfRowId = manf;
	var PicUrl = 'dhcstm.phmanfaction.csp?actiontype=GetManfPic';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
			url: PicUrl,
			method: "POST"
		});
	// ָ���в���
	var fields = ["rowid", "manfid", "manfName", "picsrc", "typeName"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: "results",
			id: "rowid",
			fields: fields
		});
	// ���ݼ�
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
			emptyText: '��ѡ��Ҫ��ʾ������ͼƬ',
			listeners: {
				'dblclick': function (v, r) {
					var src = PicStore.getAt(r).get('picsrc');
					Ext.get("custom").dom.src = ftpsrc + src;
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
			text: 'ɾ��ѡ��ͼƬ',
			tooltip: 'ɾ��ѡ��ͼƬ',
			iconCls: 'page_delete',
			handler: function () {
				var arrpicr = picView.getSelectedRecords() // ����
					if ((!arrpicr) || arrpicr.length == 0) {
						Msg.info("warning", '��ѡ��Ҫɾ����ͼƬ!');
						return;
					}
					var picr = arrpicr[0];
				var row = picr.get("rowid");
				var picsrc = picr.get("picsrc");
				FnDel(row, picsrc, picr, RefreshPic);
			}
		});

	var exitBt = new Ext.Toolbar.Button({
			text: '�ر�',
			iconCls: 'page_close',
			handler: function () {
				PicWin.hide();
			}
		});

	var displayAllPic = new Ext.Toolbar.Button({
			text: 'ȫ����ʾ',
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
			text: '���ȫѡ',
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
			boxLabel: '���ֲ鿴ѡ��',
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
				data: [['socialCreditCode', '���������'], ['comLic', '����ִ��'], ['taxLic', '˰��ִ��'], ['orgCode', '��������'], ['insBusLic', '��е��Ӫ���֤'],
					['insProLic', '��е�������֤'], ['drugProLic', 'ҩƷ�������֤'], ['other', '����']]
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
			text: 'ͼƬ���¹鵵Ϊ:',
			iconCls: 'page_save',
			handler: function () {
				var typeDesc = Ext.getCmp('fileTypeValuex').getRawValue();
				var typeValue = Ext.getCmp('fileTypeValuex').getValue();
				if (typeValue == '') {
					Msg.info("warning", '��ѡ�����¹鵵������!');
					Ext.getCmp('fileTypeValuex').focus();
					return;
				}
				var arrpicr = picView.getSelectedRecords(); // ����
				if ((!arrpicr) || (arrpicr.length == 0)) {
					Msg.info("warning", '��ѡ��ͼƬ!');
					return;
				}
				var picr = arrpicr[0];
				var row = picr.get("rowid");
				var picsrc = picr.get("picsrc");
				var typeName = picr.get("typeName");
				if (typeDesc == typeName) {
					Msg.info('error', '�뵱ǰ������ͬ����ѡ���������ʣ�');
					Ext.getCmp('fileTypeValuex').setValue('');
					Ext.getCmp('fileTypeValuex').focus();
				} else {
					Ext.Ajax.request({
						url: "dhcstm.phmanfaction.csp?actiontype=UpdateManfPic&rowid=" + row + "&type=" + typeValue,
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info('success', 'ִ�гɹ�');
								PicStore.reload();
							} else {
								Msg.info('error', 'ִ��ʧ��');
							}
						},
						failure: function () {
							Msg.info('error', 'ִ��ʧ��');
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
					fieldLabel: 'ѡ��Ҫ��ʾ������',
					columns: 5,
					items: [{
							boxLabel: '���������',
							name: 'socialCreditCode',
							id: 'socialCreditCode'
						}, {
							boxLabel: '����ִ��',
							name: 'comLic',
							id: 'comLic'
						}, {
							boxLabel: '˰��ִ��',
							name: 'taxLic',
							id: 'taxLic'
						}, {
							boxLabel: '��������',
							name: 'orgCode',
							id: 'orgCode'
						}, {
							boxLabel: '��е�������֤',
							name: 'insProLic',
							id: 'insProLic'
						}, {
							boxLabel: '��е��Ӫ���֤',
							name: 'insBusLic',
							id: 'insBusLic'
						}, {
							boxLabel: 'ҩƷ�������֤',
							name: 'drugProLic',
							id: 'drugProLic'
						}, {
							boxLabel: '����',
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
				title: 'ͼƬ��Ϣ',
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
		Msg.info("warning", "���ȱ��泧����Ϣ,���ϴ�ͼƬ!");
		return;
	}
	var dialog = new Ext.ux.UploadDialog.Dialog({
			width: 600,
			height: 400,
			url: 'dhcstm.phmanfaction.csp?actiontype=UploadManfPic&manf=' + manf + "&type=" + type, ///ȫ��rowid
			reset_on_hide: false,
			permitted_extensions: ['gif', 'jpeg', 'jpg', 'png', 'bmp'],
			allow_close_on_upload: true,
			upload_autostart: false,
			title: '�ϴ���������ͼƬ',
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
	var mask = ShowLoadMask(Ext.getBody(), "���������Ժ�...");
	Ext.Ajax.request({
		url: 'dhcstm.phmanfaction.csp?actiontype=DeleteManfPic&rowid=' + rowid + '&picsrc=' + picsrc,
		waitMsg: 'ɾ����...',
		failure: function (result, request) {
			mask.hide();
			Msg.info("error", "������������!");
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			mask.hide();
			if (jsonData.success == 'true') {
				Msg.info("success", "ɾ���ɹ�!");
				Ref(picr);

			} else {
				Msg.info("error", "ɾ��ʧ��!");
			}
		},
		scope: this
	});
}
