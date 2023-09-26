function FinishRecord(episodeID, userID) {
    var imageButtonView = new Ext.ux.ImageButton({
        imgPath: '../scripts/epr/Pics/病历浏览按钮.gif',
        imgWidth: 103,
        imgHeight: 22,
        tooltip: '病历浏览', //鼠标放上去的提示
        handler: function(btn) {
            viewPDFRecord(episodeID, userID);
        }
    });

	var clickTag = 0;
    var imageButtonYes = new Ext.ux.ImageButton({
        imgPath: '../scripts/epr/Pics/是按钮.gif',
        imgWidth: 53,
        imgHeight: 22,
        tooltip: '确定生成', //鼠标放上去的提示
        id: 'BtnImageButtonYes',
		listeners : {
			'click': function() {
				if (clickTag == 0)
				{
					clickTag = 1;
					//debugger;
					//Ext.getCmp('BtnImageButtonYes').disable();
					checkRecordAndConfirm(episodeID, userID, window);
				}
				setTimeout(function () { clicktag = 0 }, 5000); 
			}
        }
    });

    var imageButtonNo = new Ext.ux.ImageButton({
        imgPath: '../scripts/epr/Pics/否按钮.gif',
        imgWidth: 53,
        imgHeight: 22,
        tooltip: '关闭', //鼠标放上去的提示
 		listeners : {
			'click': function() {
				window.close();
			}
        }
    });

    var window = new Ext.Window({
        width: 373,
        height: 225,
        closable: false,
        resizable: false,
        draggable: false,
        modal: true,
        frame: false,
        border: 0,
        bodyStyle: "background-color:transparent;padding:0",
        layout: 'border',
        frame: false,
        items: [{
            region: "center",
            border: false,
            bodyStyle: "background-image:url('../scripts/epr/Pics/弹出框背景.gif');padding:0px 0px 0",
            layout: 'absolute',
            items: [{
                height: 22,
                items: imageButtonView,
                border: false,
                bodyStyle: "background-color:transparent;",
                x: 20,
                y: 170
            }, {
                height: 22,
                items: imageButtonYes,
                border: false,
                bodyStyle: "background-color:transparent;",
                x: 160,
                y: 170
            }, {
                height: 22,
                items: imageButtonNo,
                border: false,
                bodyStyle: "background-color:transparent;",
                x: 290,
                y: 170
			}]
		}]
	});
    
	window.show();
}

function checkRecordAndConfirm(episodeID, userID, window) {
	if (needCheckSign != "1") {
		confirmPDF(episodeID, userID, window);
		return;
	}
	var url = '../DHCEPRFS.web.eprajax.EPRRecordStatus.cls?EpisodeID=' + episodeID;
	var store = new Ext.data.JsonStore({
		url: url,
		fields: [
			{ name: 'OrderID', type: 'int' },
			{ name: 'PrintDocID' },
			{ name: 'EPRNum' },
			{ name: 'RecordName' },
			{ name: 'RecordTitle' },
			{ name: 'RecordStatus' },
			{ name: 'SignStatus' },
			{ name: 'HappenDate' },
			{ name: 'HappenTime' }
		]
	});

	store.on('loadexception', function(proxy, options, response, e) {
		alert(response.responseText);
		setDllVisibility("visible");
	});

	store.on('load', function() {
		if (store.getCount() > 0) {
			showUnvalidRecord(store, window);
		}
		else {
			confirmPDF(episodeID, userID, window);
		}
	});

	store.setDefaultSort('OrderID', 'asc');
	store.load();
}

function showUnvalidRecord(store, window) {
	setDllVisibility("hidden");

	var cm = new Ext.grid.ColumnModel([
		{ header: '顺序号', dataIndex: 'OrderID', width: 50, sortable: true, type: 'int' },
		{ header: '病历名称', dataIndex: 'RecordName', width: 120, sortable: true },
		{ header: '病历标题', dataIndex: 'RecordTitle', width: 125, sortable: true },
		{ header: '发生日期', dataIndex: 'HappenDate', width: 75, sortable: true },
		{ header: '发生时间', dataIndex: 'HappenTime', width: 75, sortable: true },
		{ header: '病历状态', dataIndex: 'RecordStatus', width: 95, sortable: true },
		{ header: '签名状态', dataIndex: 'SignStatus', width: 220, sortable: true, resizable: true }
	]);

	var grid = new Ext.grid.GridPanel({
		id: 'detailGrid',
		layout: 'fit',
		border: false,
		store: store,
		cm: cm,
		forceFit: true,
		autoScroll: true,
		frame: true,
		stripeRows: true,
		columnLines: true
	});

	var win = new Ext.Window({
		id: 'detailWin',
		layout: 'fit', 	//自动适应Window大小 
		title: '未签名病历列表 - 请将病历全部签名后再提交!',
		//broder: false,
		frame: true,
		width: 880,
		height: 650,
		shim: false,
		//closeAction:'hide',    
		animCollapse: false,
		constrainHeader: true,
		resizable: true,
		modal: true,
		raggable: true, //不可拖动
		items: [
			new Ext.Panel({
				id: 'detailPanel',
				layout: 'fit',
				border: false,
				items: grid
			})
		]
	});

	win.on('close', function() {
		window.close();
		setDllVisibility("visible");
	});

	win.show();
}

function confirmPDF(episodeID, userID, window) {
	Ext.Ajax.request({
		url: '../DHCEPRFS.web.eprajax.AdmMRStatusMgr.cls',
		params: { EpisodeID: episodeID, UserID: userID },
		success: function(response, options) {
			var ret = response.responseText;
			if (ret == 1) {
				alert("提交生成PDF成功！");
				Ext.getCmp('btnFinishRecord').disable();
				window.close();
				return true;
			} else {
				alert("提交生成PDF失败！");
				return false;
			}
		}
	})
}


function viewPDFRecord(episodeID, userID) {
	var viewPDFpara = { EpisodeID: episodeID };
	window.showModalDialog("epr.newfw.pdfbrowserecord.csp", viewPDFpara, "dialogHeight:900px;dialogLeft:50px;dialogTop:2px;dialogWidth:1024px;dialogHide:no;center:1");
}