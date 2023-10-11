///yaojining
var txtEdit,
	txtPacs;
var FOUCSPOSTION = 0;         //表单最后一个编辑文本的光标位置
var ZSKROW;                  //要编辑的行号
var ZSKCULUMN;               //要编辑的列号
var DATAINDEX;
var insrtCurrentId = "";
var selectedText = "";
var rightClick;
var Loc = session['LOGON.CTLOCID'];
var lisGirdStore = new Ext.data.JsonStore({ data: [], fields: ['OrdItemName', 'OEOrdItemID', 'TSResultAnomaly'] });
var lisMenuStore = new Ext.data.JsonStore({ data: [], fields: ['OrdItemName', 'AuthDate', 'AuthTime', 'OEOrdItemID'] });;
var lisRetDetStore = new Ext.data.JsonStore({ data: [], fields: ['Name', 'Sync', 'Result', 'Unit', 'Flag', 'Ranges', 'Comment', 'Method', 'Code'] });
var pacsRetStore = new Ext.data.JsonStore({ data: [], fields: ['ARCIMDesc', 'OrdDate', 'OrdTime', 'DateEx', 'TimeEx', 'CPTEx', 'ArcimDR', 'ORW'] });
var DHCPatOrdListT103 = new Ext.data.JsonStore({
	data: [],
	fields: ['OrdDate', 'OrdTime', 'ARCIMDesc', 'PriorDes', 'Meth', 'PHFreq', 'Dose', 'DoseUnit', 'OrdStat', 'Doctor', 'Oew', 'OrdSub', 'Sel', 'SeqNo']
});
var DHCNURBG_AdmDiagnoseT101 = new Ext.data.JsonStore({ data: [], fields: ['DigaType', 'DigaICDDesc', 'DigaNoteDesc', 'DigaStatus', 'DigaDoc', 'DigaDate', 'DigaTime'] });
var rFlag="0";  //药品标记 by lmm

//关闭浏览器解锁护理病历的锁 yjn
var userAgent = navigator.userAgent;
var isIE = userAgent.indexOf('compatible') > -1 && userAgent.indexOf('MSIE') > -1;
var isIE11 = userAgent.indexOf('rv:11.0') > -1;
if (isIE11) {
	window.onbeforeunload = function() {
		//离开或者关闭浏览器的同时解锁护理病历单据
		tkMakeServerCall("Nur.DHCNurseEmrLock","delEmrLock",EpisodeID,session['LOGON.CTLOCID'],session['LOGON.USERID'],EmrCode,'',session['LOGON.GROUPID']);
	}
}

//知识库

function LinkKnow() {
	closeWin();
	var locDesc = tkMakeServerCall("web.DHCNURZSKOnPage", "GetLocDesc", Loc);
	//创建数据源[数组数据源]
	var dataStr = iniLocData();
	dataStr = eval(dataStr);
	var selLocStore = new Ext.data.ArrayStore({
		fields: ['id', 'desc'],
		data: dataStr
	});
	//创建Combobox
	var selLoc = new Ext.form.ComboBox({
		id: 'selLoc',
		store: selLocStore,
		width: 290,
		fieldLabel: '科室',
		valueField: 'id',
		value: locDesc,
		displayField: 'desc',
		allowBlank: true,
		mode: 'local',
		triggerAction: 'all',
		margin: '0 20 0 1'
	});
	//Combobox获取值
	selLoc.on('select', function () {
		Loc = selLoc.getValue();
		clearTree();
		iniTree(Loc);
	});
	//左边知识树
	var treePanel = new Ext.Panel({
		id: 'treePanel',
		width: 295,
		height: 470,
		items: [selLoc, {
			id: 'tree',
			title: '',
			html: '<div id="zsktreenew2"></div>'
		}]
	});
	//创建文本框
	txtEdit = new Ext.form.TextArea({
		id: 'txtEdit',
		width: 500,
		height: 600,
		style: 'fontSize:20px'
	});
	//右边编辑框
	var editPanel = new Ext.Panel({
		id: 'editPanel',
		x: 300,
		y: 0,
		width: 500,
		height: 420,
		border: 1,
		emptyText: '双击左边项目带到此处...',
		items: [txtEdit]
	});
	//确定按钮
	var butOk = new Ext.Button({
		id: 'butOk',
		text: '引用',
		x: 500,
		y: 430,
		width: 80,
		height: 30,
		border: 2,
		handler: insertTxt
	});
	//清空按钮
	var butClear = new Ext.Button({
		id: 'butClear',
		text: '清屏',
		x: 600,
		y: 430,
		width: 80,
		height: 30,
		border: 2,
		handler: clearTxt
	});
	//清空按钮
	var butClose = new Ext.Button({
		id: 'butClose',
		text: '关闭',
		x: 700,
		y: 430,
		width: 80,
		height: 30,
		border: 2,
		handler: closeWin
	});
	//主弹窗
	var winKnow = new Ext.Window({
		id: 'winKnow',
		title: '护理病历知识库',
		x: 80,//200,
		y: 100,  //200,
		width: 800,
		height: 500, //600,
		layout: 'absolute',
		autoScroll: true,
		items: [treePanel, editPanel, butOk, butClear, butClose]
	});
	winKnow.show();
	iniTree(Loc);

	var txtAre = document.getElementById('txtEdit');
	if (txtAre) {
		txtAre.addEventListener("mouseup", function (e) {
			selectedText = "";
			if (typeof document.selection != "undefined") {
				selectedText = document.selection.createRange().text;
			} else {
				selectedText = txtAre.value.substr(txtAre.selectionStart, txtAre.selectionEnd - txtAre.selectionStart);
				getRangeData();
			}
		});
	}
}
//检验结果
function LinkLis() {
	closeWin();
	var myLisOrdgrid = new Ext.grid.GridPanel({
		id: 'LisGridList',
		name: 'LisGridList',
		title: "检验结果",
		loadMask: true,
		clicksToEdit: 1,
		stripeRows: true,
		height: 420,
		width: 231,
		store: lisGirdStore,
		autoScroll: false,
		colModel: new Ext.grid.ColumnModel({
			columns: [{
				header: '医嘱项',
				dataIndex: 'OrdItemName',
				width: 231,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({
					readOnly: false
				}))
			}, {
				header: 'OeordID',
				dataIndex: 'OEOrdItemID',
				width: 100,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({
					readOnly: false
				}))
			}, {
				header: 'TSResultAnomaly',
				dataIndex: 'TSResultAnomaly',
				width: 120,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({
					readOnly: false
				}))
			}],
			rows: [],
			defaultSortable: false
		}),
		enableColumnMove: false,
		viewConfig: {
			forceFit: false
		},
		plugins: [new Ext.ux.plugins.GroupHeaderGrid()],
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: false
		}),
		bbar: new Ext.PagingToolbar({
			store: [],
			displayInfo: true,
			pageSize: 10
		})
	});
	myLisOrdgrid.getBottomToolbar().hide();
	myLisOrdgrid.title = "";
	//myLisOrdgrid.hideHeaders = "true";  //隐藏表头 
	myLisOrdgrid.addListener('rowclick', searchRessultDetailValue_Lis);  //单击行
	var pnWest = new Ext.Panel({
		id: 'pnWest',
		title: '检验项',
		x: 0,
		y: 33,
		split: true,//显示分隔条  
		items: [myLisOrdgrid]
	});
	var LisOrdDetailGrid = new Ext.grid.GridPanel({
		region: 'center',
		id: 'LisGridDetail',
		name: 'LisGridDetail',
		title: '检验结果明细',
		loadMask: true,
		clicksToEdit: 1,
		stripeRows: true,
		height: 420,
		width: 545,
		store: lisRetDetStore,
		colModel: new Ext.grid.ColumnModel({
			columns: [{
				header: '项目名称',
				dataIndex: 'Name',
				width: 179,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({
					readOnly: false
				}))
			}, {
				header: '缩写',
				dataIndex: 'Sync',
				width: 60,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({
					readOnly: false
				}))
			}, {
				header: '结果',
				dataIndex: 'Result',
				width: 56,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({
					readOnly: false
				}))
			}, {
				header: '单位',
				dataIndex: 'Unit',
				width: 51,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({
					readOnly: false
				}))
			}, {
				header: '异常',
				dataIndex: 'Flag',
				width: 47,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({
					readOnly: false
				}))
			}, {
				header: '参考范围',
				dataIndex: 'Ranges',
				width: 77,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({ readOnly: false }))
			}, {
				header: '结果说明',
				dataIndex: 'Comment',
				width: 75,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({ readOnly: false }))
			}, {
				header: '检查方法',
				dataIndex: 'Method',
				width: 75,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({ readOnly: false }))
			}, {
				header: 'Code',
				dataIndex: 'Code',
				width: 39,
				hidden:true,
				sortable: true
			}],
			rows: [],
			defaultSortable: false
		}),
		plugins: [new Ext.ux.plugins.GroupHeaderGrid()],
		sm: new Ext.grid.RowSelectionModel({ singleSelect: false }),
		bbar: new Ext.PagingToolbar({ store: lisRetDetStore, displayInfo: true, pageSize: 10 })
	});
	LisOrdDetailGrid.getBottomToolbar().hide();
	//LisOrdDetailGrid.getTopToolbar().hide();
	LisOrdDetailGrid.title = "";
	//LisOrdDetailGrid.view=new Ext.ux.grid.LockingGridView();
	LisOrdDetailGrid.view.syncHeights = true;  //确保行之间的高度同步
	LisOrdDetailGrid.addListener('rowdblclick', LisRowDoubleClick);
	var pnEast = new Ext.Panel({
		id: 'pnEast',
		title: '检验结果',
		x: 233,
		y: 33,
		//width:567,
		//width: '100%',
		split: true,//显示分隔条  
		items: [LisOrdDetailGrid]

	});
	var winLisDet = new Ext.Window({
		id: 'winLisDet',
		title: '检验结果',
		x: 80,
		y: 100,
		width: 800,
		height: 510,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame: true,
		items: [{
			xtype: 'label',
			text: '开始日期：',
			x: 5,
			y: 5,
			width: 90
		}, {
			xtype: 'datefield',
			id: 'LisStartDate',
			format: 'Y-m-d',
			x: 95,
			y: 5,
			width: 130
		}, {
			xtype: 'label',
			text: '结束日期：',
			x: 240,
			y: 5,
			width: 90
		}, {
			xtype: 'datefield',
			id: 'LisEndDate',
			format: 'Y-m-d',
			x: 330,
			y: 5,
			width: 130
		}, {
			xtype: 'button',
			id: 'searchBut',
			text: '查找',
			x: 470,
			y: 5,
			width: 80,
			handler: SearchRes_Lis
		}, {
			xtype: 'button',
			id: 'butClose',
			text: '关闭',
			x: 570,
			y: 5,
			width: 80,
			handler: closeWin
		},
			pnWest,
			pnEast
		]
	});
	winLisDet.show();
	getLisSearchDate();
	SearchRes_Lis();
	//insrtCurrentId = "";
	// var grid1 = Ext.getCmp('mygrid');
	// if (grid1 != null) {
	// 	grid1.on('beforeedit', beforeEditLinkFn);
	// }
}

//检查结果
function LinkPacs() {
	closeWin();
	var pacsGrid = new Ext.grid.GridPanel({
		id: 'pacsGrid',
		name: 'pacsGrid',
		title: '检查项目',
		loadMask: true,
		clicksToEdit: 1,
		stripeRows: true,
		layout: 'absolute',
		y: 33,
		height: 440,
		width: 300,
		autoScroll: true,
		tbar: [{
			id: 'PacsOrdgridbut1',
			text: '新建'
		}, {
			id: 'PacsOrdgridbut2',
			text: '修改'
		}],
		store: pacsRetStore,
		colModel: new Ext.grid.ColumnModel({
			columns: [{
				header: '检查项',
				dataIndex: 'ARCIMDesc',
				width: 180,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({
					readOnly: false
				}))
			}, {
				header: '日期',
				dataIndex: 'OrdDate',
				width: 90,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({ readOnly: false }))
			}, {
				header: '时间',
				dataIndex: 'OrdTime',
				width: 80,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({ readOnly: false }))
			}, {
				header: '执行日期',
				dataIndex: 'DateEx',
				width: 90,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({ readOnly: false }))
			}, {
				header: '执行时间',
				dataIndex: 'TimeEx',
				width: 80,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({ readOnly: false }))
			}, {
				header: '执行人',
				dataIndex: 'CPTEx',
				width: 80,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({ readOnly: false }))
			}, {
				header: 'ArcimDR',
				dataIndex: 'ArcimDR',
				width: 80,
				hidden:true,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({ readOnly: false }))
			}, {
				header: 'OrwID',
				dataIndex: 'ORW',
				width: 110,
				hidden:true,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({ readOnly: false }))
			}],
			rows: [],
			defaultSortable: false
		}),
		enableColumnMove: false,
		viewConfig: { forceFit: false },
		plugins: [new Ext.ux.plugins.GroupHeaderGrid()],
		sm: new Ext.grid.RowSelectionModel({ singleSelect: false }),
		bbar: new Ext.PagingToolbar({
			//store: DHCNURBG_zhishikujianchaT122, 
			displayInfo: true,
			pageSize: 10
		})
	});
	pacsGrid.getBottomToolbar().hide();
	pacsGrid.title = "";
	var butin = Ext.getCmp('PacsOrdgridbut1');
	butin.text = "查找"
	butin.hide();
	var InserPasc = Ext.getCmp('PacsOrdgridbut2');
	InserPasc.text = "写入病历";
	InserPasc.hide();
	///添加双击事件
	pacsGrid.addListener('rowdblclick', PascRowDoubleClick);
	//创建文本框
	txtPacs = new Ext.form.TextArea({
		id: 'txtPacs',
		width: 500,
		height: 425,
		style: 'fontSize:20px'
	});
	//右边编辑框
	var pnPacsEdit = new Ext.Panel({
		id: 'pnPacsEdit',
		x: 300,
		y: 45,
		border: 1,
		emptyText: '双击左边项目带到此处...',
		items: [txtPacs]
	});
	var winPacsDet = new Ext.Window({
		id: 'winPacsDet',
		title: '检查结果',
		x: 80,
		y: 100,
		width: 800,
		height: 510,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame: true,
		items: [{
			xtype: 'label',
			text: '开始日期：',
			x: 5,
			y: 5,
			width: 90
		}, {
			xtype: 'datefield',
			id: 'pacsStDate',
			format: 'Y-m-d',
			x: 95,
			y: 5,
			width: 130,
			value: new Date()
		}, {
			xtype: 'label',
			text: '结束日期：',
			x: 240,
			y: 5,
			width: 90
		}, {
			xtype: 'datefield',
			id: 'pacsEndDate',
			format: 'Y-m-d',
			x: 330,
			y: 5,
			width: 130,
			value: new Date()
		}, {
			xtype: 'button',
			id: 'butSearchPacs',
			text: '查找',
			x: 470,
			y: 5,
			width: 80,
			handler: initPascValue
		}, {
			xtype: 'button',
			id: 'butInsertPacs',
			text: '引用',
			x: 570,
			y: 5,
			width: 80,
			handler: insertTxt
		}, {
			xtype: 'button',
			id: 'butClosePacs',
			text: '清屏',
			x: 670,
			y: 5,
			width: 80,
			handler: clearTxt
		}, pacsGrid, pnPacsEdit]
	});
	winPacsDet.show();
	var txtAre = document.getElementById('txtPacs');
	if (txtAre) {
		txtAre.addEventListener("mouseup", function (e) {
			selectedText = "";
			if (typeof document.selection != "undefined") {
				selectedText = document.selection.createRange().text;
			} else {
				selectedText = txtAre.value.substr(txtAre.selectionStart, txtAre.selectionEnd - txtAre.selectionStart);
				getRangeData();
			}
		});
	}
}

//创建树
function iniTree(Loc) {
	Ext.QuickTips.init();
	var ZSKTree = Ext.tree;
	var zsktreeLoader = new ZSKTree.TreeLoader({ dataUrl: "../web.DHCNURZSKOnPage.cls?&Loc=" + Loc + "&ActionType=0" });
	var zsktree = new ZSKTree.TreePanel({
		el: 'zsktreenew2',
		id: 'knTree',
		height: 440,
		border: false,
		rootVisible: false,
		autoScroll: true,
		animate: true,
		containerScroll: true,
		lines: true,
		loader: zsktreeLoader
	});
	var rootStr = tkMakeServerCall("web.DHCNURZSKOnPage", "GetLocDesc", Loc);
	var moudleNums = tkMakeServerCall("web.DHCNURZSKOnPage", "GetMoudleNums", Loc);
	var ZSKrootNode = new ZSKTree.AsyncTreeNode({
		text: rootStr,
		nodeType: 'async',
		draggable: 'true',
		id: "ZSKroot"
	});
	zsktree.setRootNode(ZSKrootNode);
	if (moudleNums == 1) {
		ZSKrootNode.expand(true); //只有一个模板的时候展开树
	}
	if (moudleNums != 0) {
		zsktree.render();
		zsktree.doLayout();
	}
	//增加右键点击事件
	//zsktree.on('contextmenu', rightClickZSK);
	//双击事件
	zsktree.on('dblclick', DblClick_Insert);
}
function iniLocData() {
	var dataStr = tkMakeServerCall("web.DHCNURZSKOnPage", "GetListAllLoc");
	return dataStr;
}
//初始化tree
function clearTree() {
	var ss = Ext.getCmp('knTree');
	ss.beforeDestroy();
}
//插入右边编辑框
function DblClick_Insert(e) {
	var zsktxt = tkMakeServerCall("web.DHCNURZSKOnPage", "GetKnowledge", e.id);
	txtEdit.setValue(zsktxt);
}
//清空
function clearTxt() {
	var txtAre = Ext.getCmp('txtEdit');
	if (txtAre) {
		txtAre.setValue("");
	}
	var txtAre = Ext.getCmp('txtPacs');
	if (txtAre) {
		txtAre.setValue("");
	}

}
//插入记录知识库/检查结果
function insertTxt() {
	var zsktxt = "无内容";
	if (selectedText != "") {
		zsktxt = selectedText;
	} else {
		if (Ext.getCmp('txtEdit')) {
			zsktxt = txtEdit.getValue();
		}
		if (Ext.getCmp('txtPacs')) {
			zsktxt = txtPacs.getValue();
		}
	}
	if (insrtCurrentId != "") {
		var insertObj = Ext.getCmp(insrtCurrentId);
		//弹窗位置显示在外层 add by yjn
		if(window.frames[0]){
			insertObj = window.frames[0].Ext.getCmp(insrtCurrentId);
		}
		var itemValue = insertObj.getValue();
		var itemValueStrat = "";
		var itemValueEnd = "";
		if (itemValue != "") {
			itemValueStrat = itemValue.substring(0, FOUCSPOSTION);
			itemValueEnd = itemValue.substring(FOUCSPOSTION);
		}
		insertObj.setValue(itemValueStrat + zsktxt + itemValueEnd);
	}
	else {
		var grid1 = Ext.getCmp('mygrid');
		var objRow = grid1.getSelectionModel().getSelections();
		if (objRow.length == 0) { alert("请先选择一条护理记录!"); return; }
		var itemValue = objRow[0].get(DATAINDEX);
		if (itemValue != null) {
			var itemValueStrat = itemValue.substring(0, FOUCSPOSTION);
			var itemValueEnd = itemValue.substring(FOUCSPOSTION);
			//alert(EmrCode)
			if (EmrCode == "DHCNURXH_YBHLJLD") DATAINDEX = "CaseMeasure";   // by lmm 20171222
			objRow[0].set(DATAINDEX, (itemValueStrat + zsktxt + itemValueEnd));
		}
		else {
			if (EmrCode == "DHCNURXH_YBHLJLD") DATAINDEX = "CaseMeasure"; // by lmm 20171222
			objRow[0].set(DATAINDEX, zsktxt);
		}
	}
	FOUCSPOSTION = FOUCSPOSTION + zsktxt.length; //光标位置增加插入的字符串的长度
	selectedText = "";  //初始化高亮文本
	closeWin();
}
//获取需插入的项目
function rightEditFn(grid, rowIndex, colIndex, e) {
	alert(rowIndex);
}
//获取需插入的项目
function beforeEditLinkFn(e) {
	//DATAINDEX = e.field; //全局变量
	ZSKROW = e.row;
	ZSKCULUMN = e.column;
	var grid1 = Ext.getCmp('mygrid');
	var textarea1 = grid1.getColumnModel().getCellEditor(ZSKCULUMN, ZSKROW);
	var id = textarea1.id;
	var textarea2 = document.getElementById(id);
	var textarea = Ext.getCmp(textarea1.field.id);
	textarea.on('blur', getRangeData);
}
function beforeEditPgLinkFn(e) {
	FOUCSPOSTION = 0;
	insrtCurrentId = e.id;
	var el = document.getElementById(insrtCurrentId);
	var textarea = Ext.getCmp(insrtCurrentId);
	if (textarea.getValue() == "") { return; } //空值的按钮不用获取FOUCSPOSTION
	if (el.selectionStart) {
		FOUCSPOSTION = el.selectionStart;
		return el.selectionStart;
	} else if (document.selection) {
		try {
			el.focus();
		}
		catch (ex) {
			return;
		}
		var workRange = document.selection.createRange();
		el.select();
		var allRange = document.selection.createRange();
		if (allRange.text.length == 0) { return }      //因为上面程序el.focus(); 失焦的事件程序走到这里就不走了。
		workRange.setEndPoint("StartToStart", allRange);
		FOUCSPOSTION = workRange.text.length;
		workRange.collapse(false);
		workRange.select();
	}
	// var grid1 = Ext.getCmp('mygrid');
	// var textarea1 = grid1.getColumnModel().getCellEditor(ZSKCULUMN, ZSKROW);
	// var id = textarea1.id;
	// var textarea2 = document.getElementById(id);
	// var textarea = Ext.getCmp(textarea1.field.id);
	// textarea.on('blur', getRangeData);
}
//获取光标位置
//IE11能用,Ie8未测
function getRangeData() {
	FOUCSPOSTION = 0;
	var grid1 = Ext.getCmp('mygrid');
	var el;
	if (grid1 == null) {
		id = insrtCurrentId;
		var el = document.getElementById(id);
		var textarea = Ext.getCmp(id);
		if (textarea.getValue() == "") { return; } //空值的按钮不用获取FOUCSPOSTION
	} else {
		var textarea1 = grid1.getColumnModel().getCellEditor(ZSKCULUMN, ZSKROW);
		var id = textarea1.id;
		var textarea2 = document.getElementById(id);
		el = document.getElementById(textarea2.lastChild.id);
		var textarea = Ext.getCmp(textarea2.lastChild.id);
		if (textarea.getValue() == "") { return; } //空值的按钮不用获取FOUCSPOSTION
	}
	if (el.selectionStart) {
		FOUCSPOSTION = el.selectionStart;
		return el.selectionStart;
	} else if (document.selection) {
		try {
			el.focus();
		}
		catch (ex) {
			return;
		}
		var workRange = document.selection.createRange();
		el.select();
		var allRange = document.selection.createRange();
		if (allRange.text.length == 0) { return }      //因为上面程序el.focus(); 失焦的事件程序走到这里就不走了。
		workRange.setEndPoint("StartToStart", allRange);
		FOUCSPOSTION = workRange.text.length;
		workRange.collapse(false);
		workRange.select();
	}
}
///双击检验结果明细记录，插入检查结果
function LisRowDoubleClick(lisgrid, rowindex, e) {
	var Synctxt = lisgrid.getStore().getAt(rowindex).get("Name");
	//var Synctxt = lisgrid.getStore().getAt(rowindex).get("Sync");
	var Resulttxt = lisgrid.getStore().getAt(rowindex).get("Result");
	var Unit = lisgrid.getStore().getAt(rowindex).get("Unit");
	//var zsktxt = "," + Synctxt + ":" + Resulttxt + " " + Unit;
	var zsktxt = Synctxt + ":" + Resulttxt + " " + Unit;
	if (zsktxt == "") {
		//alert("检查结果未出！");
		return;
	}
	InserTextComm(zsktxt);
	closeWin();
}
///检索日期
function getLisSearchDate() {
	var dateStr = tkMakeServerCall("web.DHCNURZSKOnPage", "GetDateByAdm", EpisodeID);
	var dateArr = dateStr.split("^");
	Ext.getCmp("LisStartDate").setValue(dateArr[0]);
	Ext.getCmp("LisEndDate").setValue(dateArr[1]);
}
function SearchRes_Lis() {
	//getLisSearchDate();
	initRessultListValue_Lis()
	//setTimeout("initRessultListValue_Lis()", 1000);
}
function initRessultListValue_Lis() {
	condata = new Array();
	var StDate = Ext.getCmp("LisStartDate").value;
	var Enddate = Ext.getCmp("LisEndDate").value;
	var ordgrid = Ext.getCmp("LisGridList");
	var parr = EpisodeID + "##^^^^#" + StDate + "#" + Enddate;
	try {
		var a = cspRunServerMethod(GetQueryDataZSK, "web.DHCNURZSKOnPage:QueryOrderList", "parr$" + parr, "addLisResList");
	}
	catch (e) {

		alert("web.DHCNURZSKOnPage:QueryOrderListLis(" + parr + ")错误！" + e.message);

	}
	ordgrid.store.loadData(condata);
	//setLisListColor(ordgrid);
}
function addLisResList(a, b, c) {
	condata.push({
		OEOrdItemID: a,
		OrdItemName: b,
		TSResultAnomaly: c
	});
}
function searchRessultDetailValue_Lis() {
	initRessultDetailValue_Lis();
	//setTimeout("initRessultDetailValue_Lis()",1000);
}
function initRessultDetailValue_Lis() {
	condata = new Array();
	var ordgrid = Ext.getCmp("LisGridDetail");
	var ListOrdgrid = Ext.getCmp("LisGridList");
	var parr = ListOrdgrid.getSelectionModel().getSelections()[0].get("OEOrdItemID");
	if (parr == "") {
		return;
	}
	try {
		var a = cspRunServerMethod(GetQueryDataZSK, "LabService.TSResult:GetResultByOrderId", "parr$" + parr, "addLisResDetail");
	}
	catch (e) {
		alert("LabService.TSResult:GetResultByOrderId(" + parr + ")错误！" + e.message);

	}
	ordgrid.store.loadData(condata);
}
function addLisResDetail(a, b, c, d, e, f, g, h, i) {
	condata.push({
		Code: a,
		Name: b,
		Sync: c,
		Result: d,
		Flag: e,
		Unit: f,
		Ranges: g,
		Comment: h,
		Method: i

	});
}

//初始化检查数据
function initPascValue() {
	//setTimeout("Search_Pacs()", 1000);
	Search_Pacs();
}
///查找检查项目
function Search_Pacs() {
	condata = new Array();
	var StDate = Ext.getCmp("pacsStDate").value;
	var Enddate = Ext.getCmp("pacsEndDate").value;
	var pacsGrid = Ext.getCmp("pacsGrid");
	var parr = EpisodeID + "^" + StDate + "^" + Enddate + "^";
	var a = cspRunServerMethod(GetQueryDataZSK, "web.DHCNurknowInterface:GetOrdRadia", "parr$" + parr, "addPacs");
	pacsGrid.store.loadData(condata);
	//setPascColor(pacsGrid);
}
function addPacs(a, b, c, d, e, f, g, h) {
	//OrdDate,OrdTime,ARCIMDesc,ORW,DateEx,TimeEx ,CPTEx,ArcimDR
	condata.push({
		ARCIMDesc: c,
		OrdDate: a,
		OrdTime: b,
		DateEx: e,
		TimeEx: f,
		CPTEx: g,
		ArcimDR: h,
		ORW: d
	});
}
///双击检查记录，插入检查结果
function PascRowDoubleClick(pascgrid, rowindex, e) {
	var orwID = pascgrid.getStore().getAt(rowindex).get("ORW")
	var zsktxt = tkMakeServerCall("web.DHCRisWorkBenchDoEx", "GetEKGRptInfo", orwID);
	if (zsktxt == "") {
		alert("检查结果未出！")
		return;
	}
	var txtPacs = Ext.getCmp("txtPacs");
	txtPacs.setValue(zsktxt);
}

//公用插入数据
//Input:zsktxt:插入的数据
function InserTextComm(zsktxt) {
	//alert(insrtCurrentId);
	if (insrtCurrentId != "") {
		var insertObj = Ext.getCmp(insrtCurrentId);
		//弹窗位置显示在外层 add by yjn
		if(window.frames[0]){
			insertObj = window.frames[0].Ext.getCmp(insrtCurrentId);
		}
		var itemValue = insertObj.getValue();
		var itemValueStrat = "";
		var itemValueEnd = "";
		if (itemValue != "") {
			itemValueStrat = itemValue.substring(0, FOUCSPOSTION);
			itemValueEnd = itemValue.substring(FOUCSPOSTION);
		}
		insertObj.setValue(itemValueStrat + zsktxt + itemValueEnd);
	}
	else {
		var grid1 = Ext.getCmp('mygrid');
		var objRow = grid1.getSelectionModel().getSelections();
		if (objRow.length == 0) { alert("请先选择一条护理记录!"); return; }
		var itemValue = grid1.getSelectionModel().getSelections()[0].get(DATAINDEX);
		if (itemValue != null) {
			var itemValueStrat = itemValue.substring(0, FOUCSPOSTION);
			var itemValueEnd = itemValue.substring(FOUCSPOSTION);
			grid1.getSelectionModel().getSelections()[0].set(DATAINDEX, (itemValueStrat + zsktxt + itemValueEnd));
		}
		else {
			grid1.getSelectionModel().getSelections()[0].set(DATAINDEX, zsktxt);
		}
	}
	FOUCSPOSTION = FOUCSPOSTION + zsktxt.length; //光标位置增加插入的字符串的长度
}

/// by lmm 非药品医嘱查询
function LinkNROrder() {
	rFlag="0";
	LinkOrder();
}
/// by lmm 药品医嘱查询
function LinkROrder() {
	rFlag="1";
	LinkOrder();
}
//增加
function AddModel()
{
	//var selectModel = new Ext.grid.CheckboxSelectionModel({});
		var cloumnModel = new Ext.grid.ColumnModel([
		 
			{header: "种类",width:90,dataIndex:"Type",editor:new Ext.form.Field()},
			{header: "量 ml",width:60,dataIndex:"Quantity",editor:new Ext.form.Field()},
		]);
		var window =createEidtPanelWin1({
			winID:"ModelWin",
			gridID:"AddType",
			cm:cloumnModel,
			fields:["Type","Quantity"],
			className:"web.DHCNurQMPage",
			methodName:"getMenuNurseJson",
			forceFit:true,
			idField:"menuID"
		});
		window.show();
	
}

/**
*公共方法
*Note:创建窗口
*/
function createEidtPanelWin1(obj)
{
	if(Ext.getCmp(obj.winID))
	{
		Ext.getCmp(obj.winID).close();
	}
	
	var planGrid = new Ext.grid.EditorGridPanel({
		id:obj.gridID,
		layout:"fit",
		sm:new Ext.grid.RowSelectionModel({}),
		cm:obj.cm,
		clicksToEdit:1,
		viewConfig:{forceFit:obj.forceFit},
		store:new Ext.data.JsonStore({
			fields:obj.fields,
			root:"rowData",
			autoLoad:true
		})
		
	});
	var window = new Ext.Window({
		id:obj.winID,
		layout:"fit",
		items:[planGrid],
		width:800,
		height:400,
		x: 100,
		y: 140,
		buttons:[
			new Ext.Button({
				text:"新增",
				handler:function(){
					insertNewRecord(obj.fields,obj.gridID);
				}
			}),
			new Ext.Button({
				text:"保存",
				handler:function(){
				saveDefines(obj.gridID);
				}
			}),
			/*new Ext.Button({
				text:"删除",
				handler:function(){
				//deleteSelected(obj.gridID,obj.idField)
				}
			}),*/
			new Ext.Button({
				text:"取消",
				handler:function (){
					window.close();
				}
			})
		],
		listeners:{close:function(){
			//Ext.getCmp("sheetButtons").getStore().removeAll();
			//Ext.getCmp("sheetColumn").getStore().removeAll();
			//Ext.getCmp("sheetButtons").getStore().load();
			//Ext.getCmp("sheetColumn").getStore().load();
		}}
	})
	return window;
}
/**
*公共方法
*Note:增加记录
*/
function insertNewRecord(fields,gridID)
{
	var store = Ext.getCmp(gridID).getStore();
	var recObj = "{"
	for(var i=0;i<fields.length;i++)
	{
		if(recObj!="{") recObj=recObj+","
		recObj=recObj+fields[i]+":''";
	}
	recObj=recObj+"}"
	recObj=eval("("+recObj+")");
	var newRecord = new Ext.data.Record(recObj);
	var count =store.getCount()
	store.insert(count,newRecord);
	Ext.getCmp(gridID).startEditing( count, 0 ) ;
}
/**
*公共方法
*Note:保存设置
*/
function saveDefines(gridID)
{
	Ext.getCmp(gridID).stopEditing(false);
	var saveStr=""
	var store = Ext.getCmp(gridID).getStore(); 
	var count = store.getCount();
	//alert(count)
	var TypeStr=""
	var QuantityStr=""
	for(var index = 0;index<count;index++)
	{
		var rowRecord = store.getAt(index);
		var modefiedFlag=false;
		var dataStr="";
		TypeStr=TypeStr+"^"+rowRecord.data["Type"];
		QuantityStr=QuantityStr+"^"+rowRecord.data["Quantity"];
	}
	TypeStr=TypeStr.substring(1,TypeStr.length);
		QuantityStr=QuantityStr.substring(1,QuantityStr.length);
	/*if(QuantityStr.split("^")){
		alert(QuantityStr.split("^").length);
	}*/
	//alert(TypeStr);
	//alert(QuantityStr);
	if(TypeStr!=""||QuantityStr!="")
	{
			if(window.frames[0]){
		//window.frames[0].Ext.getCmp("Item7").setValue(des);
			//if(rFlag=="0")InserTextComm(des);
			if(EmrCode="DHCNURBG_CHHLJLD"){window.frames[0].Ext.getCmp("Item6").setValue(TypeStr);}
			else{window.frames[0].Ext.getCmp("Item7").setValue(TypeStr);}
			}
			if(window.frames[0]){
				if(EmrCode="DHCNURBG_CHHLJLD"){window.frames[0].Ext.getCmp("Item7").setValue(QuantityStr);}
				else{window.frames[0].Ext.getCmp("Item8").setValue(QuantityStr);}
			}
		//var ret = tkMakeServerCall("Nur.DHCNurQMEmrMenu","Save",saveStr);
		//Ext.MessageBox.alert("<提示>",ret==""?"保存成功！":ret);
		//alert(saveStr);
		closeWin();
	}
	
	//Ext.getCmp(gridID).getStore().load();
}
//引用医嘱
function LinkOrder() {
	closeWin();
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCPatOrdList", EpisodeID, "");
	arr = eval(a);
	var windOrder = new Ext.Window({
		title: '医嘱',
		id: 'winOrder',
		x: 100,
		y: 100,
		width: 680,
		height: 500,
		autoScroll: true,
		layout: 'absolute',
		items: arr
	});
	var mydate = new Date();
	var grid1 = Ext.getCmp("ordgrid");
	tobar = grid1.getTopToolbar();
	tobar.addItem({
		xtype: 'datefield',
		format: 'Y-m-d',
		id: 'ordgridstdate',
		value: new Date()
	}, {
			xtype: 'datefield',
			format: 'Y-m-d',
			id: 'ordgridenddate',
			value: new Date()
		}, "-", "优先级", {
			xtype: 'combo',
			store: new Ext.data.SimpleStore({
				fields: ['valueInOut', 'descpInOut'],
				data: [
					['T', '临时医嘱'],
					['L', '长期医嘱']
				]
			}),
			id: 'Prior',
			fieldLabel: '优先级',
			loadingText: '正在加载...',
			displayField: 'descpInOut', //隐藏的数据
			valueField: 'valueInOut', //显示的数据
			mode: 'local', //读取本地数据(remote表示远程数据)
			triggerAction: 'all',
			editable: true, //是否可以编辑,同时此属性也支持输入搜索功能
			width: 100
		});
	tobar.addButton({
		className: 'new-topic-button',
		text: "查询",
		handler:SchOrdNew,
		id: 'ordgridSch'
	});
	var len = grid1.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if((grid1.getColumnModel().getDataIndex(i) == 'Oew')||(grid1.getColumnModel().getDataIndex(i) == 'OrdSub')||(grid1.getColumnModel().getDataIndex(i) == 'SeqNo')){
			grid1.getColumnModel().setHidden(i,true);
		}
  }
	var bbar = grid1.getBottomToolbar ();
	bbar.hide();
	var butin = Ext.getCmp('ordgridbut2');
	butin.hide();
	var butin = Ext.getCmp('ordgridbut1');
	butin.text = "确定";
	//debugger;
	butin.on('click', SureInNew);
	var butschord = Ext.getCmp('ordgridSch');
	butschord.on('click', SchOrdNew);
	var prior = Ext.getCmp("Prior");
	prior.on('select', SchOrdNew);
	windOrder.show();
	SchOrdNew();
	grid1.on('dblclick', SureInNew);
}

function SchOrdNew() {
	condata = new Array();
	var adm = EpisodeID;
	var StDate = Ext.getCmp("ordgridstdate");
	var Enddate = Ext.getCmp("ordgridenddate");
	var prior = Ext.getCmp("Prior");
	var GetQueryData = document.getElementById('GetQueryDataOrd');
	//var GetQueryData = document.getElementById('GetQueryData');
	var ordgrid = Ext.getCmp("ordgrid");
	var parr = adm + "^" + StDate.value + "^" + Enddate.value + "^" + prior.getValue()+"^"+rFlag;;
	//alert(GetQueryData);
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNUREMR:GetPatOrd", "parr$" + parr, "addOrd");
	//grid.width=document.body.offsetWidth;
	ordgrid.store.loadData(condata);
}
var condata = new Array();
//'OrdDate', 'OrdTime', 'ARCIMDesc', 'PriorDes', 'Meth', 'PHFreq', 'Dose', 'DoseUnit', 'OrdStat', 'Doctor', 'Oew', 'OrdSub', 'SeqNo'
function addOrd(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o) { //OrdDate,OrdTime,ARCIMDesc,PriorDes,Meth,PHFreq,Dose,PhQtyOrd,OrdStat,Doctor,Oew,OrdSub,Sel,SeqNo
	condata.push({
		OrdDate: a,
		OrdTime: b,
		ARCIMDesc: c,
		PriorDes: d,
		Meth: e,
		PHFreq: f,
		Dose: g,
		DoseUnit: h,
		PhQtyOrd: i,
		OrdStat: j,
		Doctor: k,
		Oew: l,
		OrdSub: m,
		Sel:n,
		SeqNo: o
	});
}

function SureInNew() {
	var grid = Ext.getCmp('ordgrid');
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	/*var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount(); //列数
	var view = grid.getView();*/
	var num = 0;
	var selModel = grid.getSelectionModel();

	if (selModel.hasSelection()) {
		// Ext.Msg.confirm("警告", "确定要删除吗？", function(button) {   
		var selections = selModel.getSelections();
		//var rowIndex = grid.store.indexOf(grid.getSelectionModel().getSelected());
		//grid.getSelectionModel().selectRow(rowIndex);
		//debugger;
		var caredate, caretime;
		Ext.each(selections, function (item) {
			var des = item.data.ARCIMDesc;
			des = des.replace("_____", "");
			//var ml=item.data.Dose;

			//换算成ml
			var oeoriId = item.data.Oew;
			var oeoriSub = item.data.OrdSub;
			var mlStr = tkMakeServerCall("web.DHCSTPCHCOLLPRN", "getDoseQtyML", oeoriId, oeoriSub);
			var ml = mlStr.split('^')[0];

			var unit = item.data.DoseUnit;
			//des=des+" "+ml+unit;
			des = des + " " + item.data.Dose + unit;
			//if ((unit!="ml")&&(unit!="ML")) ml=0;
			var seqno = item.data.SeqNo;
			var rowIndex = grid.store.indexOf(item);
			var Meth = item.data.Meth;
			//var des=Meth;
			for (var i = rowIndex - 1; i >= 0; i--) {
				var subdes = store.getAt(i).data.ARCIMDesc;
				subdes = subdes.replace("_____", "");
				var subml = store.getAt(i).data.Dose;

				//换算成ml
				var oeoriId = store.getAt(i).data.Oew;
				var oeoriSub = store.getAt(i).data.OrdSub;
				var submlStr = tkMakeServerCall("web.DHCSTPCHCOLLPRN", "getDoseQtyML", oeoriId, oeoriSub);
				var subml = submlStr.split('^')[0];

				var subunit = store.getAt(i).data.DoseUnit;
				if (subunit != "ml") subml = "";
				var subseqno = store.getAt(i).data.SeqNo;
				if (subseqno == seqno) {
					des = subdes + " " + store.getAt(i).data.Dose + subunit + "," + des;
					//des=Meth
					//ml=eval(ml)+eval(subml);
					if ((ml == "") && (subml != "")) {
						ml = 0;
					} else if ((ml != "") && (subml == "")) {
						subml = 0;
					} else if ((ml == "") && (subml == "")) {
						ml = 0;
						subml = 0;
					} else { }
					ml = eval(ml) + eval(subml);
				}
				else {
					break;
				}
			}
			//alert(store.getCount());
			for (var i = rowIndex + 1; i < store.getCount(); i++) {
				var subdes = store.getAt(i).data.ARCIMDesc;
				subdes = subdes.replace("_____", "");
				//var subml=store.getAt(i).data.Dose;
				//alert(subml);

				//换算成ml
				var oeoriId = store.getAt(i).data.Oew;
				var oeoriSub = store.getAt(i).data.OrdSub;
				var submlStr = tkMakeServerCall("web.DHCSTPCHCOLLPRN", "getDoseQtyML", oeoriId, oeoriSub);
				var subml = submlStr.split('^')[0];

				var subunit = store.getAt(i).data.DoseUnit;
				//alert(subunit);
				if ((subunit != "ml") && (subunit != "ML")) subml = "";
				var subseqno = store.getAt(i).data.SeqNo;
				if (subseqno == seqno) {
					des = des + "," + subdes + " " + store.getAt(i).data.Dose + subunit;
					//des=Meth
					//ml=eval(ml)+eval(subml);
					if ((ml == "") && (subml != "")) {
						ml = 0;
					} else if ((ml != "") && (subml == "")) {
						subml = 0;
					} else if ((ml == "") && (subml == "")) {
						ml = 0;
						subml = 0;
					} else { }
					ml = eval(ml) + eval(subml);
				}
				else {
					break;
				}
			}
			//alert(num);
			// alert(des+"，"+ml);
			// if (num == 0) {

			// } else {
			// 	Ext.getCmp("Item7").setValue(des);
			// 	Ext.getCmp("Item8").setValue(ml);
			// }
			if(window.frames[0]){
				//window.frames[0].Ext.getCmp("Item7").setValue(des);
				if(rFlag=="0")InserTextComm(des);
				else if((EmrCode="DHCNURBG_CHHLJLD")&&(rFlag!="0")){  window.frames[0].Ext.getCmp("Item6").setValue(des);}
				else  window.frames[0].Ext.getCmp("Item7").setValue(des);
			}
			if(window.frames[0]){
				if(EmrCode="DHCNURBG_CHHLJLD"){window.frames[0].Ext.getCmp("Item7").setValue(ml);}
				else{window.frames[0].Ext.getCmp("Item8").setValue(ml);}
			}
			//Ext.getCmp("Item7").setValue(des);
			//Ext.getCmp("Item8").setValue(ml);
			num++;
		});
	}
	closeWin();
}

//引用诊断
function LinkDiag() {
	closeWin();
	var DiagnoseGrid = new Ext.grid.GridPanel({
		id: 'DiagnoseGrid',
		name: 'DiagnoseGrid',
		title: '全部诊断',
		loadMask: true,
		clicksToEdit: 1,
		stripeRows: true,
		height: 420,
		width: 780,
		tbar: [{
			id: 'DiagnoseGridbut1',
			text: '新建'
		}, {
			id: 'DiagnoseGridbut2',
			text: '修改'
		}],
		store: DHCNURBG_AdmDiagnoseT101,
		colModel: new Ext.grid.ColumnModel({
			columns: [{
				header: '类型',
				dataIndex: 'DigaType',
				width: 71,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({
					readOnly: false
				}))
			}, {
				header: 'ICD描述',
				dataIndex: 'DigaICDDesc',
				width: 176,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({ readOnly: false }))
			}, {
				header: '注释',
				dataIndex: 'DigaNoteDesc',
				width: 83,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({ readOnly: false }))
			}, {
				header: '状态',
				dataIndex: 'DigaStatus',
				width: 38,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({ readOnly: false }))
			}, {
				header: '下诊断医生',
				dataIndex: 'DigaDoc',
				width: 79,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({ readOnly: false }))
			}, {
				header: '日期',
				dataIndex: 'DigaDate',
				width: 71,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({ readOnly: false }))
			}, {
				header: '时间',
				dataIndex: 'DigaTime',
				width: 47,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({ readOnly: false }))
			}],
			rows: [],
			defaultSortable: false
		}), enableColumnMove: false,
		viewConfig: { forceFit: false },
		plugins: [new Ext.ux.plugins.GroupHeaderGrid()],
		sm: new Ext.grid.RowSelectionModel({ singleSelect: false }),
		bbar: new Ext.PagingToolbar({ store: DHCNURBG_AdmDiagnoseT101, displayInfo: true, pageSize: 10 })
	});
	// DiagnoseGrid.hideHeaders="true";  //隐藏表头 
	DiagnoseGrid.getBottomToolbar().hide();
	DiagnoseGrid.getTopToolbar().hide();
	DiagnoseGrid.title = ""
	DiagnoseGrid.addListener('rowdblclick', InsertDiagnose);  //单击行
	var pnCenter = new Ext.Panel({
		id: 'digacenter',
		title: '所有诊断',
		x: 0,
		y: 0,
		split: true,//显示分隔条  
		region: 'center',
		items: [DiagnoseGrid]
	});
	var winDiag = new Ext.Window({
		title: '所有诊断',
		id: 'winDiag',
		x: 80,
		y: 100,
		width: 800,
		height: 500,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame: true,
		items: [
			pnCenter
		]
	});
	winDiag.show();
	initDiganose();
}
function initDiganose() {
	condata = new Array();
	try {
		var a = cspRunServerMethod(GetQueryDataZSK, "web.DHCNURZSKOnPage:GetPatDiga", "Adm$" + EpisodeID, "addDiagnose");
	}
	catch (e) {
		alert("web.DHCNURZSKOnPage:GetPatDiga(" + GetPatDiga + ")错误！" + e.message);
	}
	var DiagnoseGrid = Ext.getCmp("DiagnoseGrid");
	DiagnoseGrid.store.loadData(condata);
}
function addDiagnose(a, b, c, d, e, f, g) {
	condata.push({
		DigaType: a,
		DigaICDDesc: b,
		DigaNoteDesc: c,
		DigaStatus: d,
		DigaDoc: e,
		DigaDate: f,
		DigaTime: g
	});
}
//插入诊断信息
function InsertDiagnose(Diagnosegrid, rowindex, e) {
	var DigaICDDesc = Diagnosegrid.getStore().getAt(rowindex).get("DigaICDDesc");
	var DigaNoteDesc = Diagnosegrid.getStore().getAt(rowindex).get("DigaNoteDesc");
	var DigaStatus = Diagnosegrid.getStore().getAt(rowindex).get("DigaStatus");
	var zsktxt = DigaICDDesc + " " + DigaNoteDesc + " " + DigaStatus;
	InserTextComm(zsktxt);
	closeWin();
}

function closeWin() {
	var window = Ext.getCmp('winKnow');
	if (window) {
		window.close();
	}
	var window = Ext.getCmp('winLisDet');
	if (window) {
		window.close();
	}
	var window = Ext.getCmp('winPacsDet');
	if (window) {
		window.close();
	}
	var window = Ext.getCmp('winOrder');
	if (window) {
		window.close();
	}
	var window = Ext.getCmp('winDiag');
	if (window) {
		window.close();
	}
	var window = Ext.getCmp('ModelWin');
	if (window) {
		window.close();
	}
}
function preventDefault(event) {
	if (document.all) {
		window.event.returnValue = false;
	} else {
		event.preventDefault();
	}
}
function tabToEnter(specialInput) {
    var all = Ext.query('input[type!=hidden]'); // 查找所有非隱藏元素
    Ext.each(all, function(o, i, all) { // 遍曆並添加enter的監聽
		if (o.id != specialInput) {
			Ext.get(o).addKeyMap({
				key : 13,
				fn : function() {
					try {
						all[i + 1].focus()
					} catch (e) {
						event.keyCode = 9
					}
					if (all[i + 1]
							&& /button|reset|submit/.test(all[i + 1].type))
						all[i + 1].click(); // 如果點擊則觸發click事件

					return true;
				}
			})
		}
	});
    Ext.getBody().focus(); // 使頁面獲取焦點，否則下面設定默認焦點的功能不靈驗

    try {
        var el;
        if (typeof eval(xFocus) == 'object') { // 如果傳入的是id或dom節點
            el = Ext.getDom(xFocus).tagName == 'input'
                    ? Ext.getDom(xFocus)
                    : Ext.get(xFocus).first('input', true); // 找到input框
        } else {
            el = all[xFocus || 0]; // 通過索引號找
        }
        el.focus();
    } catch (e) {
    }
}

//统计次数
//input :体温、脉搏、血压、血糖
function countNum(temperature, pulse, pressure, sugar,Spo2) {
	if (Ext.getCmp('winCount')) {
		Ext.getCmp('winCount').close();
	}
	var countTemp = 0;
	var countPulse = 0;
	var countPressure = 0;
	var countSugar = 0;
	var countSpo2 = 0;
	var htmlStrStart="<ul>";
	var htmlStrEnd="</ul>";
	for (var i=0; i < grid.store.data.length; i++) {
		var itmValTemp="";
		var itmValPulse="";
		var itmValPressure="";
		var itmValSugar="";
		var itmValSpo2="";
		var data = grid.store.getAt(i).data;
		if (temperature!="") {
			itmValTemp = data[temperature];  //体温
		}
		if (pulse!="") {
			itmValPulse = data[pulse];    //脉搏
		}
		if (pressure!="") {
			itmValPressure = data[pressure];    //血压
		}
		if (sugar!="") {
			itmValSugar = data[sugar];    //血糖
		}
		if (Spo2!="") {
			itmValSpo2 = data[Spo2];    //Spo2
		}
		if ((typeof(itmValTemp)!='undefined')&&(itmValTemp != '')) {
			countTemp ++;
		}
		if ((typeof(itmValPulse)!='undefined')&&(itmValPulse != '')) {
			countPulse ++;
		}
		if ((typeof(itmValPressure)!='undefined')&&(itmValPressure != '')) {
			countPressure ++;
		}
		if ((typeof(itmValSugar)!='undefined')&&(itmValSugar != '')) {
			countSugar ++;
		}
		if ((typeof(itmValSpo2)!='undefined')&&(itmValSpo2 != '')) {
			countSpo2 ++;
		}
	}
	htmlStr = htmlStrStart;
	if (temperature!="") {
		htmlStr = htmlStr + "<li style='margin-top:5px;'><span>体温填写：</span><span style='color:red;font-weight:bold;'> " + countTemp + "</span><span>  次</span></li>";
	}
	if (pulse!="") {
		htmlStr = htmlStr + "<li style='margin-top:5px;'><span>脉搏填写：</span><span style='color:red;font-weight:bold;'> " + countPulse + "</span><span>  次</span></li>";
	}
	if (pressure!="") {
		htmlStr = htmlStr + "<li style='margin-top:5px;'><span>血压填写：</span><span style='color:red;font-weight:bold;'> " + countPressure + "</span><span>  次</span></li>";
	}
	if (sugar!="") {
		htmlStr = htmlStr + "<li style='margin-top:5px;'><span>血糖填写：</span><span style='color:red;font-weight:bold;'> " + countSugar + "</span><span>  次</span></li>";
	}
	if (Spo2!="") {
		htmlStr = htmlStr + "<li style='margin-top:5px;'><span>血氧填写：</span><span style='color:red;font-weight:bold;'> " + countSpo2 + "</span><span>  次</span></li>";
	}
	htmlStr = htmlStr + htmlStrEnd;
	var pannelCount = new Ext.Panel({
		header: false,
		width: '100%',
		height: 140,
		html: htmlStr
	});
	var winCount = new Ext.Window({
		id: 'winCount',
		title: '统计次数',
		x: 230,
		y: 200,
		height: 140,
		width: 220,
		items:[pannelCount]
	});
	winCount.show();
}

//统计次数
//input :体温、脉搏、血压、血糖
function countNumInTbar(temperature, pulse, pressure, sugar, Spo2) {
	if (Ext.getCmp('winCount')) {
		Ext.getCmp('winCount').close();
	}
	var countTemp = 0;
	var countPulse = 0;
	var countPressure = 0;
	var countSugar = 0;
	var countSpo2 = 0;
	var htmlStrStart="<p style='padding:0px;'>录入次数总计：   ";
	var htmlStrEnd="</p>";
	for (var i=0; i < grid.store.data.length; i++) {
		var itmValTemp="";
		var itmValPulse="";
		var itmValPressure="";
		var itmValSugar="";
		var itmValSpo2="";
		var data = grid.store.getAt(i).data;
		if (temperature!="") {
			itmValTemp = data[temperature];  //体温
		}
		if (pulse!="") {
			itmValPulse = data[pulse];    //脉搏
		}
		if (pressure!="") {
			itmValPressure = data[pressure];    //血压
		}
		if (sugar!="") {
			itmValSugar = data[sugar];    //血糖
		}
		if (Spo2!="") {
			itmValSpo2 = data[Spo2];    //Spo2
		}
		if ((typeof(itmValTemp)!='undefined')&&(itmValTemp != '')) {
			countTemp ++;
		}
		if ((typeof(itmValPulse)!='undefined')&&(itmValPulse != '')) {
			countPulse ++;
		}
		if ((typeof(itmValPressure)!='undefined')&&(itmValPressure != '')) {
			countPressure ++;
		}
		if ((typeof(itmValSugar)!='undefined')&&(itmValSugar != '')) {
			countSugar ++;
		}
		if ((typeof(itmValSpo2)!='undefined')&&(itmValSpo2 != '')) {
			countSpo2 ++;
		}
	}
	htmlStr = htmlStrStart;
	if (temperature!="") {
		htmlStr = htmlStr + "<span>体温</span><span style='color:red;font-weight:bold;font-size:18px;';> " + countTemp + "</span><span>  次；</span>&nbsp;&nbsp;&nbsp;";
	}
	if (pulse!="") {
		htmlStr = htmlStr + "<span>脉搏</span><span style='color:red;font-weight:bold;font-size:18px;';'> " + countPulse + "</span><span>  次；</span>&nbsp;&nbsp;&nbsp;";
	}
	if (pressure!="") {
		htmlStr = htmlStr + "<span>血压</span><span style='color:red;font-weight:bold;font-size:18px;';'> " + countPressure + "</span><span>  次；</span>&nbsp;&nbsp;&nbsp;";
	}
	if (sugar!="") {
		htmlStr = htmlStr + "<span>血糖</span><span style='color:red;font-weight:bold;font-size:18px;';'> " + countSugar + "</span><span>  次；</span>&nbsp;&nbsp;&nbsp;";
	}
	if (Spo2!="") {
		htmlStr = htmlStr + "<span>血氧</span><span style='color:red;font-weight:bold;font-size:18px;';'> " + countSpo2 + "</span><span>  次；</span>&nbsp;&nbsp;&nbsp;";
	}
	htmlStr = htmlStr + htmlStrEnd;
	var countText=Ext.getCmp("countText");
	if (countText!=null) {
		countText.el.dom.innerHTML = htmlStr;
	}
}

function judgeIfLocked() {
	//判断是否已经打开。
	var ifLocked=tkMakeServerCall("Nur.DHCNurseEmrLock","judgeEmrLock",EpisodeID,session['LOGON.CTLOCID'],session['LOGON.USERID'],EmrCode,session['LOGON.GROUPID']);
	var UserType=tkMakeServerCall("web.DHCNurseRecordComm","GetUserType",session['LOGON.USERID']);
	if ((ifLocked!="")&&(UserType == "NURSE")) {
		//Ext.getCmp("butSave").hide();
		var gform = Ext.getCmp("gform");
		if (gform != null) {
			gform.items.each(function (item, index, length) {
				if (item.getEl() != null) {
					item.setDisabled(true);
				}
			});	
		}
		alert(ifLocked);
	}
}

Ext.onReady(function () {
	var grid1 = Ext.getCmp('mygrid');
	var gform = Ext.getCmp("gform");
	var inputForm = Ext.getCmp("inputForm");  //输入frame区域
	if (false) {
		rightClick = new Ext.menu.Menu({
			id: 'rightClickCont',
			items: [{
				text: '知识库',
				handler: LinkKnow
			}, {
				text: '检验结果',
				handler: LinkLis
			}, {
				text: '检查结果',
				handler: LinkPacs
			}, {
				id: 'rMenu1',
				text: '医嘱',
				handler: OrdSch
				//handler:opentam2
			}
				//,  {
				//    id:'rMenu2',
				//    text : '病情措施及处理',
				//    handler:Measure
				// }
				, {
				id: 'rMenu3',
				text: '病情措施及处理', //新调用
				handler: MeasureNew
			}, {
				id: 'rMenu2',
				text: '补打设置',
				handler: SetXu
			}, {
				id: 'rMenu6',
				text: '修改关联科室床号',
				handler: ChangLocBed
			},
			/* {
				id:'rMenu4',
				text : '插入出入液量小结',
				handler:InOutNod
			},  {
				id:'rMenu5',
				text : '插入24小时出入液量',
				handler:InOutSum
			},  {
				id:'rMenu6',
				text : '修改关联诊断',
				handler:UpdateRelDiagnos
			},  */
			{
				id: 'rMenu7',
				text: '删除',
				handler: CancelRecord
			}]
		});
		grid1.on('beforeedit', beforeEditLinkFn);
		grid1.on('cellcontextmenu', function (grid, rowIndex, cellIndex, e) {
			e.preventDefault();
			grid.getSelectionModel().selectRow(rowIndex);
			DATAINDEX = grid.getColumnModel().getDataIndex(cellIndex);
			grid.startEditing(rowIndex, cellIndex);
			rightClick.showAt(e.getXY());
		});
	} else if (gform != null) {
		//控制权限
		var UserType=tkMakeServerCall("web.DHCNurseRecordComm","GetUserType",session['LOGON.USERID']);
		if (UserType != "NURSE") {
			var objButAdd=Ext.getCmp("mygridbut1");
			if (objButAdd) {
				objButAdd.hide();
			}
			var objButEdit=Ext.getCmp("mygridbut2");
			if (objButEdit) {
				objButEdit.hide();
			}
			var objButSaveAll=Ext.getCmp("saveall");
			if (objButSaveAll) {
				objButSaveAll.hide();
			}
			var objButSave=Ext.getCmp("butSave");
			if (objButSave) {
				objButSave.hide();
			}
		}
		//引用右键菜单  add by yjn
		var rightClickPgMenu = new Ext.menu.Menu({
			id: 'rightClickCont',
			items: [{
				text: '知识库',
				handler: LinkKnow
			}
			/*
			, {
				text: '检验结果',
				handler: LinkLis
			}, {
				text: '检查结果',
				handler: LinkPacs
			}
			*/
			]
		});
		gform.items.each(function (item, index, length) {
			if (item.getEl() != null) {
				//item.on('beforeedit', beforeEditPgLinkFn);
				if ((item.xtype == "textfield") || (item.xtype == "textarea")) {
					item.on('blur', beforeEditPgLinkFn);
					item.getEl().on('contextmenu', function (e, t) {
						//禁用浏览器的右键相应事件 
						e.preventDefault();
						//e.stopEvent();
						rightClickPgMenu.showAt(e.getXY());
					});
				}
			}
		});
	} else if (inputForm != null) {
		//引用右键菜单  add by yjn
		/*
		var rightClickPgMenu = new Ext.menu.Menu({
			id: 'rightClickCont',
			items: [{
				text: '知识库',
				handler: LinkKnow
			}, {
				text: '检验结果',
				handler: LinkLis
			}, {
				text: '检查结果',
				handler: LinkPacs
			}, {
				text: '引用医嘱',
				handler: LinkOrder
				// handler:function(){
				// 	window.parent.OrdSchNew();
				// }
			}, {
				text: '引用诊断',
				handler: LinkDiag
			}]
		});
		inputForm.items.each(function (item, index, length) {
			if (item.getEl() != null) {
				//item.on('beforeedit', beforeEditPgLinkFn);
				if ((item.xtype == "textfield") || (item.xtype == "textarea")) {
					item.on('blur', beforeEditPgLinkFn);
					item.getEl().on('contextmenu', function (e, t) {
						//禁用浏览器的右键相应事件 
						e.preventDefault();
						//e.stopEvent();
						rightClickPgMenu.showAt(e.getXY());
					});
				}
			}
		});
		*/
	} else { }

	//LinkKnow();   //链接知识库
	//LinkLis();  //链接结果
	//LinkPacs();  //链接检查结果
});