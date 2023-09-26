
var cus = null;
var PicWin = null;
var gParam = [];
var gNIParrefId;

NewItmPicWin = function(NIParrefId) {
	gNIParrefId = NIParrefId;
	
	var PicStore = new Ext.data.JsonStore({
		url : 'dhcstm.newitmaction.csp?actiontype=GetNIPic&RowId=' + gNIParrefId,
		root: 'rows',
		totalProperty: 'results',
		fields : ["rowid", "picsrc", "typeName"]
	});

	var ftpsrc = "http://" + gFtpParam[5];
	var picTpl = new Ext.XTemplate(
		'<tpl for=".">',
			'<div style="padding:5px; height:260px; width:260px; float:left;" class="select_pic" >',
				'<img class="pic" src="' + ftpsrc + '{picsrc}"style="height:250px; width:250px;"position: relative;>',
				'<p>{typeName}</p>',
			'</div>',
		'</tpl>'
	);

	var picView = new Ext.DataView({
		store: PicStore,
		tpl: picTpl,
		frame: true,
		singleSelect: true,
		trackOver: true,
		selectedClass: 'selected-pic',
		overClass: 'over-pic',
		itemSelector: 'div.select_pic',
//		emptyText: '请选择要显示的资质图片',
		listeners: {
			'dblclick': function (v, r) {
				var src = PicStore.getAt(r).get('picsrc');
				Ext.get("custom").dom.src = ftpsrc + src;
				var image = new Image();
				image.src = ftpsrc + src;
				document.body.appendChild(image);
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
					PicWin.show();
				});
				var height = 600;
				var width = image.width / (image.height / height);
				cus.resizeTo(width, height);
				PicWin.hide();
			}
		}
	});

	var bDelete = new Ext.Toolbar.Button({
			text: '删除选中图片',
			tooltip: '删除选中图片',
			iconCls: 'page_delete',
			handler: function () {
				var arrpicr = picView.getSelectedRecords();
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

	var displayAllPic = new Ext.Toolbar.Button({
			text: '刷新',
			iconCls: 'page_find',
			handler: function () {
				PicStore.load({
					params: {
						'RowId': gNIParrefId
					}
				});
			}
		});
	
	var formPanel = new Ext.form.FormPanel({
			region: 'north',
			height: 35,
			//tbar: [displayAllPic, '-', bDelete],
			baseCls: "x-plain"
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
			items: [formPanel, detailPanel],
			listeners: {
				'show': function () {
					displayAllPic.handler();
				}
			}
		});
	}
	PicWin.show();

	function RefreshPic(picr) {
		PicStore.remove(picr);
		picView.refresh();
	}
}

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
