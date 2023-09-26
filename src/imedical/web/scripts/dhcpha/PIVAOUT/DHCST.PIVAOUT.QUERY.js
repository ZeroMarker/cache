///配液综合查询界面JS
///Creator:LiangQiang
///CreatDate:2013-05-31
var unitsUrl = 'DHCST.PIVAOUT.SAVEURL.csp';
var waitMask; 
//弹出瓶签状态信息
function showWin(value) {
	OpenShowStatusWin(value, "");
} 
//弹出病人基本信息
function showPatInfoWin(value) {
	OpenShowPatInfoWin(value);
}
Ext.onReady(function() {
	Ext.QuickTips.init(); // 浮动信息提示
	Ext.Ajax.timeout = 900000; 
	//药房科室控件
	var phlocInfo = new Ext.data.Store({
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows',
			id: 'rowId'
		},
		['phlocdesc', 'rowId'])
	});
	phlocInfo.on('beforeload',
	function(ds, o) {
		var grpdr = session['LOGON.GROUPID'];
		ds.proxy = new Ext.data.HttpProxy({
			url: unitsUrl + '?action=GetStockPhlocDs&GrpDr=' + grpdr,
			method: 'GET'
		});
	});
	var PhaLocSelecter = new Ext.form.ComboBox({
		id: 'PhaLocSelecter',
		fieldLabel: '药房科室',
		store: phlocInfo,
		valueField: 'rowId',
		displayField: 'phlocdesc',
		width: 150,
		listWidth: 250,
		emptyText: '选择药房科室...',
		allowBlank: false,
		name: 'PhaLocSelecter',
		mode: 'local'
	});
	phlocInfo.on("load",
	function(store, record, opts) {
		setDefaultLoc();
	}); //刷新
	var RefreshButton = new Ext.Button({
		width: 70,
		id: "RefreshBtn",
		text: '查询',
		icon: "../scripts/dhcpha/img/find.gif",
		listeners: {
			"click": function() {
				FindOrdGrpDetail();
			}
		}
	}); 
	var OkButton = new Ext.Button({
		width: 65,
		id: "OkButton",
		text: '补打瓶签',
		tooltip: '补打瓶签',
		icon: "../scripts/dhcpha/img/printer.png",
		listeners: {
			"click": function() {
				PrintPIVALabel();
			}
		}
	}); 
	var PrtListButton = new Ext.Button({
		width: 65,
		id: "PrtListButton",
		text: '补打配药单',
		tooltip: '补打配药单',
		icon: "../scripts/dhcpha/img/printer.png",
		listeners: {
			"click": function() {
				PrintPIVAList();
			}
		}
	}); 
	var ReadBarButton = new Ext.Button({
		width: 65,
		id: "ReadBarBtn",
		text: '扫码',
		icon: "../scripts/dhcpha/img/menu.png",
		listeners: {
			"click": function() {
				OpenReadBarcodeWin("60");
			}
		}
	}) ///查询瓶签单号 
	var FindPrintNoButton = new Ext.Button({
		width: 3,
		id: " FindPrintNoBtn",
		text: '...',
		listeners: {
			"click": function() {
				sdate = Ext.getCmp("startdt").getRawValue().toString();
				edate = Ext.getCmp("enddt").getRawValue().toString();
				phlocdr = Ext.getCmp('PhaLocSelecter').getValue();
				var Input = sdate + "^" + edate + "^" + phlocdr + "^" + "";
				OpenFindNoWin(Input);
			}
		}
	}) ///瓶签单号
	var PrintNoField = new Ext.form.TextField({
		width: 130,
		id: "PrintNoTxt",
		fieldLabel: "瓶签单号",
		listeners: {
			specialkey: function(textfield, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {}
			}
		}
	}) ///医嘱明细数据table
	function selectbox(re, params, record, rowIndex) {
		return '<input type="checkbox" id="TSelectz' + rowIndex + '" name="TSelectz' + rowIndex + '"  value="' + re + '"  >';
	}
	function showUrl(value, cellmeta, record, rowIndex, colIndex, store) {
		return "<a href='javascript:showWin(\"" + record.get("pogid") + "\")'/>" + value + "</a>";
	}
	function showPatInfoUrl(value, cellmeta, record, rowIndex, colIndex, store) {
		return "<a href='javascript:showPatInfoWin(\"" + record.get("dsprowid") + "\")'/>" + value + "</a>";
	}
	var orddetailgridcm = new Ext.grid.ColumnModel({
		columns: [{
			header: '<input type="checkbox" id="TDSelectOrdItm" >',
			width: 40,
			menuDisabled: true,
			dataIndex: 'select',
			renderer: selectbox
		},
		{
			header: '登记号',
			dataIndex: 'patid',
			width: 90,
			renderer: showPatInfoUrl
		},
		{
			header: '姓名',
			dataIndex: 'patname',
			width: 60
		},
		{
			header: '用药日期',
			dataIndex: 'orddate',
			width: 80
		},
		{
			header: '处方号',
			dataIndex: 'prescno',
			width: 100,
			renderer: showUrl
		},
		{
			header: '药品名称',
			dataIndex: 'incidesc',
			width: 200
		},
		{
			header: '数量',
			dataIndex: 'qty',
			width: 40
		},
		{
			header: '单位',
			dataIndex: 'uomdesc',
			width: 60
		},
		{
			header: '剂量',
			dataIndex: 'dosage',
			width: 80
		},
		{
			header: '频次',
			dataIndex: 'freq',
			width: 60
		},
		{
			header: '规格',
			dataIndex: 'spec',
			width: 80
		},
		{
			header: '用法',
			dataIndex: 'instruc',
			width: 80
		},
		{
			header: '用药疗程',
			dataIndex: 'dura',
			width: 60
		},
		{
			header: '剂型',
			dataIndex: 'form',
			width: 80
		},
		{
			header: '医生',
			dataIndex: 'doctor',
			width: 60
		},
		{
			header: '医嘱备注',
			dataIndex: 'remark',
			width: 120
		},
		{
			header: 'selectflag',
			dataIndex: 'selectflag',
			hidden: true
		},
		{
			header: 'dsprowid',
			dataIndex: 'dsprowid',
			hidden: true
		},
		{
			header: 'pogid',
			dataIndex: 'pogid',
			hidden: true
		},
		{
			header: '当前状态',
			dataIndex: 'psname',
			width: 120
		},
		{
			header: '条码',
			dataIndex: 'barcode',
			width: 120
		}]
	});
	var orddetailgridds = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		},
		['select', 'patid', 'patname', 'orddate', 'prescno', 'incidesc', 'qty', 'uomdesc', 'dosage', 'freq', 'spec', 'instruc', 'dura', 'form', 'doctor', 'remark', 'selectflag', 'dsprowid', 'pogid', 'psname', 'barcode']),
		remoteSort: true
	});
	var orddetailgridcmPagingToolbar = new Ext.PagingToolbar({
		store: orddetailgridds,
		pageSize: 200,
		//显示右下角信息
		displayInfo: true,
		displayMsg: '当前记录 {0} -- {1} 条 共 {2} 条记录',
		prevText: "上一页",
		nextText: "下一页",
		refreshText: "刷新",
		lastText: "最后页",
		firstText: "第一页",
		beforePageText: "当前页",
		afterPageText: "共{0}页",
		emptyMsg: "没有数据"
	});
	var orddetailgrid = new Ext.grid.GridPanel({
		stripeRows: true,
		region: 'center',
		margins: '3 3 3 3',
		autoScroll: true,
		id: 'orddetailtbl',
		enableHdMenu: false,
		ds: orddetailgridds,
		cm: orddetailgridcm,
		enableColumnMove: false,
		bbar: orddetailgridcmPagingToolbar,
		//tbar:[OnlyReadBarChkbox,"-",BarcodeField,'-','扫码计数:',BarcodeNumField],
		trackMouseOver: 'true'
	});
	orddetailgrid.on('cellclick', OrddetailGridCellClick) 
	orddetailgrid.on('headerclick',
	function(grid, columnIndex, e) {
		if (columnIndex == 0) {
			selectAllRows();
		};
	}); //开始日期
	var stdatef = new Ext.form.DateField({
		width: 150,
		xtype: 'datefield',
		format: 'j/m/Y H:i:s',
		fieldLabel: '开始日期',
		name: 'startdt',
		id: 'startdt',
		invalidText: '无效日期格式,正确格式是:日/月/年,如:15/02/2011',
		value: GetPIVAStDate() + " " + "00:00:00",
		listeners: {
			select: function(m, d) {
				var newdate = d.format('j/m/Y') + " 00:00:00"
				m.setValue(newdate);
			}
		}
	}) 
	var enddatef = new Ext.form.DateField({
		width: 150,
		format: 'j/m/Y H:i:s',
		fieldLabel: '截止日期',
		name: 'enddt',
		id: 'enddt',
		invalidText: '无效日期格式,正确格式是:日/月/年,如:15/02/2011',
		value: GetPIVAEndDate() + " " + "23:59:59",
		listeners: {
			select: function(m, d) {
				var newdate = d.format('j/m/Y') + " 23:59:59"
				m.setValue(newdate);
			}
		}
	}) ///瓶签条码
	var BarcodeField = new Ext.form.TextField({
		width: 150,
		id: "BarcodeTxt",
		fieldLabel: "瓶签条码",
		listeners: {
			specialkey: function(textfield, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					FindOrdGrpDetail();
				}
			},
			afterrender: function(textfield, e) {
				Ext.getCmp('BarcodeTxt').focus(true, true);
			},
			render: function SetTip(textfield, e) {
				this.getEl().dom.setAttribute("ext:qtip", "扫码前确认将光标移动到这里!");
			}
		}
	}) //病人登记号查询工具
	var patientField = new Ext.form.TextField({
		width: 150,
		id: "patientTxt",
		fieldLabel: "登记号",
		listeners: {
			specialkey: function(textfield, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					FindOrdGrpDetail();
				}
			}
		}
	}) 
	var DatePanel = new Ext.Panel({
		title: '配液综合查询',
		frame: true,
		margins: '1 0 0 0',
		bbar: [RefreshButton, "-", OkButton, "-", PrtListButton],
		labelWidth: 80,
		region: 'center',
		items: [{
			layout: "column",
			items: [{
				labelAlign: 'right',
				columnWidth: .2,
				layout: "form",
				items: [PhaLocSelecter]
			},
			{
				labelAlign: 'right',
				columnWidth: .2,
				layout: "form",
				items: [stdatef]
			},
			{
				labelAlign: 'right',
				columnWidth: .18,
				layout: "form",
				items: [PrintNoField]
			},
			{
				columnWidth: .2,
				layout: "form",
				items: [FindPrintNoButton]
			}]
		},
		{
			layout: "column",
			items: [{
				labelAlign: 'right',
				columnWidth: .2,
				layout: "form",
				items: [patientField]
			},
			{
				labelAlign: 'right',
				columnWidth: .2,
				layout: "form",
				items: [enddatef]
			},
			{
				labelAlign: 'right',
				columnWidth: .2,
				layout: "form",
				items: [BarcodeField]
			}]
		
		}]
	})
	var centerform = new Ext.Panel({
		id: 'centerform',
		region: 'center',
		margins: '1 0 0 0',
		frame: false,
		layout: {
			type: 'vbox',
			align: 'stretch',
			pack: 'start'
		},
		items: [{
			flex: 2,
			layout: 'border',
			items: [DatePanel]
		},
		{
			flex: 8,
			layout: 'border',
			items: [orddetailgrid]
		}]
	});
	var port = new Ext.Viewport({
		layout: 'border',
		items: [centerform]
	}); ///////////////////////Event//////////////////
	//设置默认科室
	function setDefaultLoc() {
		if (phlocInfo.getTotalCount() > 0) {
			PhaLocSelecter.setValue(phlocInfo.getAt(0).data.rowId);
		}
	} //返回左边列表选择条件
	function GetListInput() {
		sdate = Ext.getCmp("startdt").getRawValue().toString();
		edate = Ext.getCmp("enddt").getRawValue().toString();
		phlocdr = Ext.getCmp('PhaLocSelecter').getValue();
		patid = Ext.getCmp('patientTxt').getValue();
		prtnostr = Ext.getCmp('PrintNoTxt').getValue();
		barcode = Ext.getCmp('BarcodeTxt').getValue();
		var listinputstr = sdate + "^" + edate + "^" + phlocdr + "^" + patid + "^" + prtnostr + "^" + barcode;
		return listinputstr
	}
	function FindOrdGrpDetail() {
		var RegNo = Ext.getCmp('patientTxt').getValue();
		var RegNo = GetWholePatID(RegNo);
		var sdate = Ext.getCmp("startdt").getRawValue().toString();
		var edate = Ext.getCmp("enddt").getRawValue().toString();
		var phlocdr = Ext.getCmp('PhaLocSelecter').getValue();
		if (sdate == "") {
			Ext.Msg.show({
				title: '注意',
				msg: '开始日期不能为空 !',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.INFO
			});
			return;
		}
		if (edate == "") {
			Ext.Msg.show({
				title: '注意',
				msg: '结束日期不能为空 !',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.INFO
			});
			return;
		}
		if (phlocdr == "") {
			Ext.Msg.show({
				title: '注意',
				msg: '科室不能为空 !',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.INFO
			});
			return;
		}
		var input = GetListInput();
		waitMask = new Ext.LoadMask(Ext.getBody(), {
			msg: "系统正在处理数据,请稍候..."
		});
		waitMask.show();
		ClearDocument();
		orddetailgridds.proxy = new Ext.data.HttpProxy({
			url: unitsUrl + '?action=PIVAOUTQUERY&RegNo=' + RegNo + "&Input=" + input
		});
		orddetailgridds.load({
			params: {
				start: 0,
				limit: orddetailgridcmPagingToolbar.pageSize
			},
			callback: function(r, options, success) {
				waitMask.hide();
				if (success == false) {
					Ext.Msg.show({
						title: '注意',
						msg: '查询失败 !',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				}
			}
		});
	} ///补0病人登记号
	function GetWholePatID(RegNo) {
		if (RegNo == "") {
			return RegNo;
		}
		var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetPatRegNoLen");
		var plen = RegNo.length;
		if (plen > patLen) {
			Ext.Msg.show({
				title: '错误',
				msg: '输入登记号错误!',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
			return;
		}
		for (i = 1; i <= patLen - plen; i++) {
			RegNo = "0" + RegNo;
		}
		Ext.getCmp('patientTxt').setValue(RegNo);
		return RegNo;
	} //列单击事件
	function OrddetailGridCellClick(grid, rowIndex, columnIndex, e) {
		if (columnIndex == 0) {
			var newmoeori = "";
			var record = orddetailgrid.getStore().getAt(rowIndex);
			var moeori = record.data.selectflag;
			var view = orddetailgrid.getView();
			var store = orddetailgrid.getStore();
			if (document.getElementById("TSelectz" + rowIndex).checked) {
				for (i = 0; i <= view.getRows().length - 1; i++) {
					if (document.getElementById("TSelectz" + i).checked) {   
					} else {
						var record = orddetailgrid.getStore().getAt(i);
						var newmoeori = record.data.selectflag;
						if (newmoeori == moeori) {
							document.getElementById("TSelectz" + i).checked = true;
						} else {
							if (i > rowIndex) break;
						}
					}
				}
			} else {
				for (i = 0; i <= view.getRows().length - 1; i++) {
					if (document.getElementById("TSelectz" + i).checked) {
						var record = orddetailgrid.getStore().getAt(i);
						var newmoeori = record.data.selectflag;
						if (newmoeori == moeori) {
							document.getElementById("TSelectz" + i).checked = false;
						} else {
							if (i > rowIndex) break;
						}
					} else {}
				}
			}
		}
	} //全选/全销事件
	function selectAllRows() {
		var cellselected = document.getElementById("TDSelectOrdItm").checked;
		var view = orddetailgrid.getView();
		var rows = view.getRows().length;
		if (rows == 0) return;
		for (i = 0; i <= rows - 1; i++) {
			if (cellselected) {
				document.getElementById("TSelectz" + i).checked = true;
			} else {
				document.getElementById("TSelectz" + i).checked = false;
			}
		}
	} //设置集点   
	function SetFocus() {
		Ext.getCmp('BarcodeTxt').focus(true, true);
	} //清除
	function ClearDocument() {
		orddetailgridds.removeAll();
		document.getElementById("TDSelectOrdItm").checked = false;
	} //补打瓶签处理 
	function PrintPIVALabel() {
		var view = orddetailgrid.getView();
		var rows = view.getRows().length - 1;
		if (rows == -1) return;
		var user = session['LOGON.USERID'];
		var m = 0;
		for (i = 0; i <= rows; i++) {
			var cellselected = document.getElementById("TSelectz" + i).checked
			if (! (cellselected)) continue;
			var record = orddetailgrid.getStore().getAt(i);
			var prescno = record.data.prescno;
			m = m + 1;
			if (prescno != "") {
				var pogid = record.data.pogid;
				PrintLabel(pogid);
			}
		}
		SetFocus();
	}
	function PrintLabel(pogid) {
		var Bar = new ActiveXObject("PIVAOutPrint.PIVALabel");
		if (!Bar) return;
		var pogstr = tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "GetPrintPog", pogid); 
		if (pogstr == "") {
			alert("取瓶签病人数据发生错误");
			return;
		}
		var pogistr = tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "GetPrintPogItm", pogid); 
		if (pogistr == "") {
			alert("取瓶签药品数据发生错误");
			return;
		}
		var stype = "";
		Bar.Device = "PIVA";
		Bar.PageWidth = 130;
		Bar.PageHeight = 160;
		Bar.HeadFontSize = 12;
		Bar.FontSize = 10;
		Bar.Title = "输液单";
		Bar.HeadType = stype;
		Bar.IfPrintBar = "true";
		Bar.BarFontSize = 25;
		Bar.BarTop = 60;
		Bar.BarLeftMarg = 5;
		Bar.PageSpaceItm = 2;
		Bar.ItmFontSize = 10;
		Bar.ItmCharNums = 30; //药名每行显示的字符数
		Bar.ItmOmit = "false"; //药品名称是否取舍只打印一行
		Bar.PageMainStr = pogstr; // 打印标签医嘱信息
		Bar.PageItmStr = pogistr; // 打印标签药品信息
		Bar.PageLeftMargine = 1;
		Bar.PageSpace = 1;
		Bar.BarWidth = 24;
		Bar.BarHeight = 8;
		Bar.PrintDPage();
		return true;
	} 
	//补打配药单
	function PrintPIVAList() {
		var startNo = 2;
		var view = orddetailgrid.getView();
		var rows = view.getRows().length - 1;
		if (rows == -1) return;
		var user = session['LOGON.USERID'];
		var m = 0;
		var h = 0
		for (i = 0; i <= rows; i++) {
			var cellselected = document.getElementById("TSelectz" + i).checked
			if (! (cellselected)) continue;
			var record = orddetailgrid.getStore().getAt(i);
			var prescno = record.data.prescno;
			m = m + 1;
			if (m == 1) {
				var prtpath = GetPrintPath();
				var Template = prtpath + "DHCST_PIVAOUT_PRTDETAIL.xls";
				var xlApp = new ActiveXObject("Excel.Application");
				var xlBook = xlApp.Workbooks.Add(Template);
				var xlsheet = xlBook.ActiveSheet;
				xlsheet.Cells(1, 1).Value = "配药清单";
				xlsheet.Cells(2, 1).Value = "" //
			}
			if (prescno != "") {
				var pogid = record.data.pogid;
				var pogistr = tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "GetPrintDetail", pogid); 
				var tmparr = pogistr.split("||");
				var cnt = tmparr.length;
				for (p = 0; p < cnt; p++) {
					h = h + 1;
					var tmparrdata = tmparr[p].split("^");
					var patno = tmparrdata[1];
					var patname = tmparrdata[0];
					var orddate = tmparrdata[2];
					var drugname = tmparrdata[3];
					var dosage = tmparrdata[4];
					var doctor = tmparrdata[5];
					var freq = tmparrdata[6];
					var prescno = tmparrdata[7];
					var qty = tmparrdata[8];
					if (p == 0) {
						mergcell(xlsheet, startNo + h, 1, 8);
					    xlsheet.Cells(startNo + h, 1).Value = "登记号:" + patno + " 姓名:" + patname + " 处方号:" + prescno + " 用药时间:" + orddate + " 医生:" + doctor;
						h = h + 1;
						xlsheet.Cells(startNo + h, 1).Value = "药品名称";
						xlsheet.Cells(startNo + h, 2).Value = "频次";
						xlsheet.Cells(startNo + h, 3).Value = "剂量";
						xlsheet.Cells(startNo + h, 4).Value = "数量";
						setBottomLine(xlsheet, startNo + h, 1, 8);
						h = h + 1;
					}
					xlsheet.Cells(startNo + h, 1).Value = drugname;
					xlsheet.Cells(startNo + h, 2).Value = freq;
					xlsheet.Cells(startNo + h, 3).Value = dosage;
					xlsheet.Cells(startNo + h, 4).Value = qty;
				}
				h = h + 1; //空两行进行下一组
			}
		}
		if (m > 0) {
			xlsheet.printout();
			SetNothing(xlApp, xlBook, xlsheet);
		}
		SetFocus();
	}
});
