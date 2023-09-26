var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];
var URL = 'dhcstm.datainputaction.csp';
var impWindow = null;

Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var ImportExcel = new Ext.Button({
			id: 'ImportExcel',
			text: '����Excel',
			height: 30,
			width: 70,
			iconCls: 'page_excel',
			handler: function () {
				if (impWindow) {
					impWindow.ShowOpen();
				} else {
					impWindow = new ActiveXObject("MSComDlg.CommonDialog");
					impWindow.Filter = "Excel(*.xls;*xlsx)|*.xls;*.xlsx";
					impWindow.FilterIndex = 1;
					impWindow.MaxFileSize = 32767;
					impWindow.ShowOpen();
				}
				var fileName = impWindow.FileName;
				if (fileName == '') {
					Msg.info('error', '��ѡ��Excel�ļ�!');
					return;
				}
				var ActiveTabId = talPanel.getActiveTab().id;
				switch (ActiveTabId) {
				case 'CodeGrid':
					ReadFromExcel(CodeGrid, fileName);
					break;
				case 'ArcCodeGrid':
					ReadFromExcel(ArcCodeGrid, fileName);
					break;
				case 'VendorGrid':
					ReadFromExcel(VendorGrid, fileName);
					break;
				case 'ManfGrid':
					ReadFromExcel(ManfGrid, fileName);
					break;
				case 'StkBinGrid':
					ReadFromExcel(StkBinGrid, fileName);
					break;
				case 'AdjPriceGrid':
					ReadFromExcel(AdjPriceGrid, fileName);
					break;
				case 'StockRecGrid':
					ReadFromExcel(StockRecGrid, fileName);
					break;
				case 'ItmManfCertGrid':
					ReadFromExcel(ItmManfCertGrid, fileName);
					break;
				case 'ItmRefuserreGrid':
					ReadFromExcel(ItmRefuserreGrid, fileName);
					break;
				case 'ErrorGrid':
					ReadFromExcel(ErrorGrid, fileName);
					break;
				default:
					break;
				}
				impWindow = null;
			}
		});

	function ReadFromExcel(grid, fileName) {
		try {
			var xlsApp = new ActiveXObject("Excel.Application");
		} catch (e) {
			Msg.info("warning", "���밲װexcel��ͬʱ���������ִ��ActiveX�ؼ�");
			return false;
		}
		var xlsBook = xlsApp.Workbooks.Add(fileName);
		var xlsSheet = xlsBook.Worksheets(1); //ps: ʹ�õ�һ��sheet
		try {
			ReadInfoFromExcel(grid, xlsApp, xlsBook, xlsSheet);
		} catch (e) {
			Msg.info('error', '��ȡExcelʧ��:' + e);
		}
		xlsApp.Quit();
		xlsApp = null;
		xlsBook = null;
		xlsSheet = null;
		return; //û��returnʱ,EXCEL.exe���̽�������,why?
	}

	function ReadInfoFromExcel(grid, xlsApp, xlsBook, xlsSheet) {
		var store = grid.getStore(), Record = store.recordType, fields = Record.prototype.fields;
		var rowsLen = xlsSheet.UsedRange.Rows.Count;
		var StartRow = 1; //��2�п�ʼ
		var cols = grid.getColumnModel().getColumnsBy(function (c) {
				return !c.hidden && c.dataIndex != '';
			});
		for (var i = StartRow; i < rowsLen; i++) {
			var rowData = {};
			for (var j = 0, colsLen = cols.length; j < colsLen; j++) {
				//excel��index��1��ʼ
				var CellContent = xlsSheet.Cells((i + 1), (j + 1)).value;
				//excelʱ�����͵����⴦��
				var ColDataIndex = cols[j].dataIndex;
				var fld = fields.item(ColDataIndex);
				if (!Ext.isEmpty(CellContent) && fld.dateFormat) {
					CellContent = new Date(CellContent);
				} else if (!Ext.isEmpty(CellContent) && typeof(CellContent) == 'date' && !fld.dateFormat) {
					CellContent = new Date(CellContent).format('Y-n-j');
				}
				if (Ext.isEmpty(CellContent)) {
					CellContent = fld.defaultValue || '';
				}
				var ColDataIndex = cols[j].dataIndex;
				rowData[ColDataIndex] = CellContent;
			}
			var newRec = new Record(rowData);
			store.add(newRec);
		}
	}
	var ExportExcel = new Ext.Button({
			id: 'ExportExcel',
			text: '����Excelģ��',
			height: 30,
			width: 70,
			iconCls: 'page_unloadyun',
			handler: function () {
				window.open("../scripts/dhcstm/DataInput/Excelģ��.rar", "_blank");
			}
		});

	var talPanel = new Ext.TabPanel({
			activeTab: 0,
			deferredRender: true,
			tbar: [ExportExcel, '-', ImportExcel, '-', '<font color=blue>�ر�����: ����ʱ����һ�б�ͷ!</font>'],
			items: [CodeGrid, ArcCodeGrid, VendorGrid, ManfGrid, StkBinGrid, AdjPriceGrid, StockRecGrid, ItmManfCertGrid,ItmRefuserreGrid, ErrorGrid]
		});

	var mainPanel = new Ext.ux.Viewport({
			layout: 'fit',
			items: [talPanel]
		});
});
