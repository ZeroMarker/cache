///��Һ�ۺϲ�ѯ����JS
///Creator:LiangQiang
///CreatDate:2013-05-31
var unitsUrl = 'DHCST.PIVAOUT.SAVEURL.csp';
var waitMask; 
//����ƿǩ״̬��Ϣ
function showWin(value) {
	OpenShowStatusWin(value, "");
} 
//�������˻�����Ϣ
function showPatInfoWin(value) {
	OpenShowPatInfoWin(value);
}
Ext.onReady(function() {
	Ext.QuickTips.init(); // ������Ϣ��ʾ
	Ext.Ajax.timeout = 900000; 
	//ҩ�����ҿؼ�
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
		fieldLabel: 'ҩ������',
		store: phlocInfo,
		valueField: 'rowId',
		displayField: 'phlocdesc',
		width: 150,
		listWidth: 250,
		emptyText: 'ѡ��ҩ������...',
		allowBlank: false,
		name: 'PhaLocSelecter',
		mode: 'local'
	});
	phlocInfo.on("load",
	function(store, record, opts) {
		setDefaultLoc();
	}); //ˢ��
	var RefreshButton = new Ext.Button({
		width: 70,
		id: "RefreshBtn",
		text: '��ѯ',
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
		text: '����ƿǩ',
		tooltip: '����ƿǩ',
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
		text: '������ҩ��',
		tooltip: '������ҩ��',
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
		text: 'ɨ��',
		icon: "../scripts/dhcpha/img/menu.png",
		listeners: {
			"click": function() {
				OpenReadBarcodeWin("60");
			}
		}
	}) ///��ѯƿǩ���� 
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
	}) ///ƿǩ����
	var PrintNoField = new Ext.form.TextField({
		width: 130,
		id: "PrintNoTxt",
		fieldLabel: "ƿǩ����",
		listeners: {
			specialkey: function(textfield, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {}
			}
		}
	}) ///ҽ����ϸ����table
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
			header: '�ǼǺ�',
			dataIndex: 'patid',
			width: 90,
			renderer: showPatInfoUrl
		},
		{
			header: '����',
			dataIndex: 'patname',
			width: 60
		},
		{
			header: '��ҩ����',
			dataIndex: 'orddate',
			width: 80
		},
		{
			header: '������',
			dataIndex: 'prescno',
			width: 100,
			renderer: showUrl
		},
		{
			header: 'ҩƷ����',
			dataIndex: 'incidesc',
			width: 200
		},
		{
			header: '����',
			dataIndex: 'qty',
			width: 40
		},
		{
			header: '��λ',
			dataIndex: 'uomdesc',
			width: 60
		},
		{
			header: '����',
			dataIndex: 'dosage',
			width: 80
		},
		{
			header: 'Ƶ��',
			dataIndex: 'freq',
			width: 60
		},
		{
			header: '���',
			dataIndex: 'spec',
			width: 80
		},
		{
			header: '�÷�',
			dataIndex: 'instruc',
			width: 80
		},
		{
			header: '��ҩ�Ƴ�',
			dataIndex: 'dura',
			width: 60
		},
		{
			header: '����',
			dataIndex: 'form',
			width: 80
		},
		{
			header: 'ҽ��',
			dataIndex: 'doctor',
			width: 60
		},
		{
			header: 'ҽ����ע',
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
			header: '��ǰ״̬',
			dataIndex: 'psname',
			width: 120
		},
		{
			header: '����',
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
		//��ʾ���½���Ϣ
		displayInfo: true,
		displayMsg: '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
		prevText: "��һҳ",
		nextText: "��һҳ",
		refreshText: "ˢ��",
		lastText: "���ҳ",
		firstText: "��һҳ",
		beforePageText: "��ǰҳ",
		afterPageText: "��{0}ҳ",
		emptyMsg: "û������"
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
		//tbar:[OnlyReadBarChkbox,"-",BarcodeField,'-','ɨ�����:',BarcodeNumField],
		trackMouseOver: 'true'
	});
	orddetailgrid.on('cellclick', OrddetailGridCellClick) 
	orddetailgrid.on('headerclick',
	function(grid, columnIndex, e) {
		if (columnIndex == 0) {
			selectAllRows();
		};
	}); //��ʼ����
	var stdatef = new Ext.form.DateField({
		width: 150,
		xtype: 'datefield',
		format: 'j/m/Y H:i:s',
		fieldLabel: '��ʼ����',
		name: 'startdt',
		id: 'startdt',
		invalidText: '��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
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
		fieldLabel: '��ֹ����',
		name: 'enddt',
		id: 'enddt',
		invalidText: '��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
		value: GetPIVAEndDate() + " " + "23:59:59",
		listeners: {
			select: function(m, d) {
				var newdate = d.format('j/m/Y') + " 23:59:59"
				m.setValue(newdate);
			}
		}
	}) ///ƿǩ����
	var BarcodeField = new Ext.form.TextField({
		width: 150,
		id: "BarcodeTxt",
		fieldLabel: "ƿǩ����",
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
				this.getEl().dom.setAttribute("ext:qtip", "ɨ��ǰȷ�Ͻ�����ƶ�������!");
			}
		}
	}) //���˵ǼǺŲ�ѯ����
	var patientField = new Ext.form.TextField({
		width: 150,
		id: "patientTxt",
		fieldLabel: "�ǼǺ�",
		listeners: {
			specialkey: function(textfield, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					FindOrdGrpDetail();
				}
			}
		}
	}) 
	var DatePanel = new Ext.Panel({
		title: '��Һ�ۺϲ�ѯ',
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
	//����Ĭ�Ͽ���
	function setDefaultLoc() {
		if (phlocInfo.getTotalCount() > 0) {
			PhaLocSelecter.setValue(phlocInfo.getAt(0).data.rowId);
		}
	} //��������б�ѡ������
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
				title: 'ע��',
				msg: '��ʼ���ڲ���Ϊ�� !',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.INFO
			});
			return;
		}
		if (edate == "") {
			Ext.Msg.show({
				title: 'ע��',
				msg: '�������ڲ���Ϊ�� !',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.INFO
			});
			return;
		}
		if (phlocdr == "") {
			Ext.Msg.show({
				title: 'ע��',
				msg: '���Ҳ���Ϊ�� !',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.INFO
			});
			return;
		}
		var input = GetListInput();
		waitMask = new Ext.LoadMask(Ext.getBody(), {
			msg: "ϵͳ���ڴ�������,���Ժ�..."
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
						title: 'ע��',
						msg: '��ѯʧ�� !',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				}
			}
		});
	} ///��0���˵ǼǺ�
	function GetWholePatID(RegNo) {
		if (RegNo == "") {
			return RegNo;
		}
		var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetPatRegNoLen");
		var plen = RegNo.length;
		if (plen > patLen) {
			Ext.Msg.show({
				title: '����',
				msg: '����ǼǺŴ���!',
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
	} //�е����¼�
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
	} //ȫѡ/ȫ���¼�
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
	} //���ü���   
	function SetFocus() {
		Ext.getCmp('BarcodeTxt').focus(true, true);
	} //���
	function ClearDocument() {
		orddetailgridds.removeAll();
		document.getElementById("TDSelectOrdItm").checked = false;
	} //����ƿǩ���� 
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
			alert("ȡƿǩ�������ݷ�������");
			return;
		}
		var pogistr = tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "GetPrintPogItm", pogid); 
		if (pogistr == "") {
			alert("ȡƿǩҩƷ���ݷ�������");
			return;
		}
		var stype = "";
		Bar.Device = "PIVA";
		Bar.PageWidth = 130;
		Bar.PageHeight = 160;
		Bar.HeadFontSize = 12;
		Bar.FontSize = 10;
		Bar.Title = "��Һ��";
		Bar.HeadType = stype;
		Bar.IfPrintBar = "true";
		Bar.BarFontSize = 25;
		Bar.BarTop = 60;
		Bar.BarLeftMarg = 5;
		Bar.PageSpaceItm = 2;
		Bar.ItmFontSize = 10;
		Bar.ItmCharNums = 30; //ҩ��ÿ����ʾ���ַ���
		Bar.ItmOmit = "false"; //ҩƷ�����Ƿ�ȡ��ֻ��ӡһ��
		Bar.PageMainStr = pogstr; // ��ӡ��ǩҽ����Ϣ
		Bar.PageItmStr = pogistr; // ��ӡ��ǩҩƷ��Ϣ
		Bar.PageLeftMargine = 1;
		Bar.PageSpace = 1;
		Bar.BarWidth = 24;
		Bar.BarHeight = 8;
		Bar.PrintDPage();
		return true;
	} 
	//������ҩ��
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
				xlsheet.Cells(1, 1).Value = "��ҩ�嵥";
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
					    xlsheet.Cells(startNo + h, 1).Value = "�ǼǺ�:" + patno + " ����:" + patname + " ������:" + prescno + " ��ҩʱ��:" + orddate + " ҽ��:" + doctor;
						h = h + 1;
						xlsheet.Cells(startNo + h, 1).Value = "ҩƷ����";
						xlsheet.Cells(startNo + h, 2).Value = "Ƶ��";
						xlsheet.Cells(startNo + h, 3).Value = "����";
						xlsheet.Cells(startNo + h, 4).Value = "����";
						setBottomLine(xlsheet, startNo + h, 1, 8);
						h = h + 1;
					}
					xlsheet.Cells(startNo + h, 1).Value = drugname;
					xlsheet.Cells(startNo + h, 2).Value = freq;
					xlsheet.Cells(startNo + h, 3).Value = dosage;
					xlsheet.Cells(startNo + h, 4).Value = qty;
				}
				h = h + 1; //�����н�����һ��
			}
		}
		if (m > 0) {
			xlsheet.printout();
			SetNothing(xlApp, xlBook, xlsheet);
		}
		SetFocus();
	}
});
