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
	GetParam(); // ��ʼ����������
}

////flag �ж��Ƿ����store��formpanel
ShowNotAuditPicWindow = function (Store, currVendorRowId) {
	var ftpsrc = "http://" + gParam[5];
	PicWin = null;
	Store.on('load', function (st) {
		//��ʾ��һ��
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
					text: '����ת'
				}, {
					handler: function () {
						num = (num + 3) % 4;
						cus.getEl().dom.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation=' + num + ')';
					},
					text: '����ת'
				}, {
					text: '��һ��',
					handler: function () {
						next(-1)
					}
				}, {
					text: '��һ��',
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
			//��ȡͼƬ��ʵ�ʴ�С
			var image = new Image();
			image.src = ftpsrc + src;
			if(!Ext.isIE11){
				//IE8,9�������ͼƬ, IE11����Ҫ
				document.body.appendChild(image);
			}
			var height = 600; // /����Ĭ�ϸ߶�
			var width = image.width / (image.height / height); // /���ձ�����												// ��ֹ����
			cus.resizeTo(width, height);
		} else if (i < 0) {
			Msg.info("warning", "�Ѿ��ǵ�һ��!");
		} else if (i > 0) {
			Msg.info("warning", "�Ѿ������һ��!");
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
			emptyText: '��ѡ��Ҫ��ʾ������ͼƬ',
			listeners: {
				'dblclick': function (v, r) {
					var src = Store.getAt(r).get('picsrc');
					Ext.get("custom").dom.src = ftpsrc + src;
					//��ȡͼƬ��ʵ�ʴ�С
					var image = new Image();
					image.src = ftpsrc + src;
					document.body.appendChild(image); //����ͼƬ
					var height = 600; // /����Ĭ�ϸ߶�
					var width = image.width / (image.height / height); // /���ձ�������
					// ��ֹ����
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
					var arrpicr = v.getSelectedRecords(); // ����
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
			text: 'ɾ��ͼƬ',
			tooltip: 'ɾ��ѡ��ͼƬ',
			iconCls: 'page_delete',
			handler: function () {
				var arrpicr = picView.getSelectedRecords(); // ����
				if ((!arrpicr) || (arrpicr.length == 0)) {
					Msg.info("warning", '��ѡ��Ҫɾ����ͼƬ!');
					return;
				}
				var picr = arrpicr[0];
				FnDelete(picr);
				picView.refresh();
				initPic();

			}
		});
	var exitBt = new Ext.Toolbar.Button({
			text: '�ر�',
			iconCls: 'page_close',
			handler: function () {
				Ext.getCmp("fileTypeValue").setValue("");
				PicWin.close();
			}
		});
	var AuditAllPic = new Ext.Toolbar.Button({
			text: '���ͨ��',
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
			text: '��˲�ͨ��',
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
		var loadMask = ShowLoadMask(Ext.getBody(), "������...");
		Ext.Ajax.request({
			url: url,
			method: 'POST',
			params: {
				Vendor: tvendor,
				type: ttype
			},
			waitMsg: '������...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON
					.decode(result.responseText);
				if (jsonData.success == 'true') {
					// ˢ�½���
					Msg.info("success", "��˳ɹ���");
					Store.reload();
				} else {
					var ret = jsonData.info;
					Msg.info("error", "���ʧ��!");
				}
			},
			scope: this
		});
		loadMask.hide();
	}

	function RefuseRegInfo(tvendor, ttype) {
		var url = "dhcstm.apcvendoraction.csp?actiontype=RefuseRegInfo";
		var loadMask = ShowLoadMask(Ext.getBody(), "������...");
		Ext.Ajax.request({
			url: url,
			method: 'POST',
			params: {
				Vendor: tvendor,
				type: ttype
			},
			waitMsg: '������...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON
					.decode(result.responseText);
				var ret = jsonData.info;
				if (jsonData.success == 'true') {
					// ˢ�½���
					Msg.info("success", "�ܾ��ɹ���");
					Store.reload();
				} else {
					Msg.info("error", "�ܾ�ʧ��!" + ret);

				}
			},
			scope: this
		});
		loadMask.hide();
	}

	function FnDelete(picr) {
		var rowid = picr.get("rowid");
		var picsrc = picr.get("picsrc");
		var mask = ShowLoadMask(Ext.getBody(), "���������Ժ�...");
		Ext.Ajax.request({
			url: 'dhcstm.apcvendoraction.csp?actiontype=DeletePic&rowid=' + rowid + '&picsrc=' + picsrc,
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
					Store.remove(picr);
					return true;
				} else {
					Msg.info("error", "ɾ��ʧ��!");
					return false;
				}
			},
			scope: this
		});
	}
	var displayAllPic = new Ext.Toolbar.Button({
			text: 'ȫѡ��ʾ',
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
			text: '���ȫѡ',
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
			text: 'ͼƬ���¹鵵Ϊ',
			iconCls: 'page_save',
			handler: function () {
				var typeDesc = Ext.getCmp('fileTypeValue').getRawValue();
				var typeValue = Ext.getCmp('fileTypeValue').getValue();
				if (typeValue == '') {
					Msg.info("warning", '��ѡ�����¹鵵������!');
					Ext.getCmp('fileTypeValue').focus();
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
				var typeName = picr.get("type");

				if (typeDesc == typeName) {
					Msg.info('error', '�뵱ǰ������ͬ����ѡ���������ʣ�');
					Ext.getCmp('fileTypeValue').setValue('');
					Ext.getCmp('fileTypeValue').focus();
				} else {
					Ext.Ajax.request({
						url: "dhcstm.apcvendoraction.csp?actiontype=UpdatePicInfo&rowid=" + row + "&type=" + typeValue,
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info('success', 'ִ�гɹ�');
								Store.reload();
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

	var auditFlag = new Ext.form.Checkbox({
			boxLabel: '�����',
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
				data: [['comLic', '����ִ��'], ['taxLic', '˰��ִ��'], ['orgCode', '��������'], ['drugBusLic', 'ҩƷ��Ӫ���֤'],
					['insBusLic', '��е��Ӫ���֤'], ['insProLic', '��е�������֤'], ['legalComm', '����ί����'], ['saleServComm', '�ۺ�����ŵ��'],
					['agentAuth', '������Ȩ��'], ['qualityComm', '������ŵ��'], ['drugProLic', 'ҩƷ�������֤'], ['gspLic', 'GSP��֤'], ['insRegLic', '��еע��֤'],
					['inletRegLic', '����ע��ǼǱ�'], ['inletRLic', '����ע��֤'], ['drugRegLic', 'ҩƷע������'], ['vendorAgreement', '��Ӧ��Э��'], 
					['salesLic', 'ҵ��Ա��Ȩ��'], ['salsPhoto', 'ҵ��Ա��Ƭ'], ['salesID', 'ҵ��Ա���֤��ӡ��'], ['socialCreditComm', '���������']]
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
					fieldLabel: 'ѡ������:',
					columns: 5,
					items: [{
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
							boxLabel: 'ҩƷ��Ӫ���֤',
							name: 'drugBusLic',
							id: 'drugBusLic'
						}, {
							boxLabel: '��е��Ӫ���֤',
							name: 'insBusLic',
							id: 'insBusLic'
						}, {
							boxLabel: '��е�������֤',
							name: 'insProLic',
							id: 'insProLic'
						}, {
							boxLabel: '����ί����',
							name: 'legalComm',
							id: 'legalComm'
						}, {
							boxLabel: '�ۺ�����ŵ��',
							name: 'saleServComm',
							id: 'saleServComm'
						}, {
							boxLabel: '������ŵ��',
							name: 'qualityComm',
							id: 'qualityComm'
						}, {
							boxLabel: 'GSP��֤',
							name: 'gspLic',
							id: 'gspLic'
						}, {
							boxLabel: '��Ӧ��Э��',
							name: 'vendorAgreement',
							id: 'vendorAgreement'
						}, {
							boxLabel: 'ҵ��Ա��Ȩ��',
							name: 'salesLic',
							id: 'salesLic'
						}, {
							boxLabel: 'ҵ��Ա��Ƭ',
							name: 'salsPhoto',
							id: 'salsPhoto'
						}, {
							boxLabel: 'ҵ��Ա���֤��ӡ��',
							name: 'salesID',
							id: 'salesID'
						}, {
							boxLabel: '���������',
							name: 'socialCreditComm',
							id: 'socialCreditComm'
						}, {
							boxLabel: '������Ȩ��',
							name: 'agentAuth',
							id: 'agentAuth'
						}, {
							boxLabel: 'ҩƷ�������֤',
							name: 'drugProLic',
							id: 'drugProLic'
						}, {
							boxLabel: '��еע��֤',
							name: 'insRegLic',
							id: 'insRegLic'
						}, {
							boxLabel: '����ע��ǼǱ�',
							name: 'inletRegLic',
							id: 'inletRegLic'
						}, {
							boxLabel: '����ע��֤',
							name: 'inletRLic',
							id: 'inletRLic'
						}, {
							boxLabel: 'ҩƷע������',
							name: 'drugRegLic',
							id: 'drugRegLic'
						}, {
							boxLabel: 'ҵ��Ա��Ȩ��',
							name: 'salesLic',
							id: 'salesLic'
						}, {
							boxLabel: 'ҵ��Ա��Ƭ',
							name: 'salsPhoto',
							id: 'salsPhoto'
						}, {
							boxLabel: 'ҵ��Ա���֤��ӡ��',
							name: 'salesID',
							id: 'salesID'
						}, {
							boxLabel: '���������',
							name: 'socialCreditComm',
							id: 'socialCreditComm'
						}, {
							boxLabel: '��Ӧ��Э��',
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
			text: '���>>',
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
			text: '<<��ǰ',
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
				title: 'ͼƬ��Ϣ',
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
