function ExcelHelper() {
  this.app = null;
  this.xlWork = null;
  this.xlSheet = null;
}

ExcelHelper.prototype = {
  constructor: ExcelHelper,
  init: function () {
    if (this.app == null) {
      this.app = new ActiveXObject("Excel.Application");
    }
  },
  open: function (fileName, sheetName) {
    if (this.app == null) {
      this.app = new ActiveXObject("Excel.Application");
    }
    this.xlWork = this.app.Workbooks.Open(fileName);
    this.xlSheet = this.xlWork.ActiveSheet;
    if (sheetName && sheetName != "") {
      this.xlSheet = this.xlWork.Worksheets(sheetName);
    }
  },
  clear: function () {
    this.app = null;
    this.xlWork = null;
    this.xlSheet = null;
  },
  quit: function () {
    this.xlWork.Close((savechanges = false));
    this.app.Quit();
    this.app = null;
    this.xlWork = null;
    this.xlSheet = null;
  },
  printPreview: function () {
    this.xlSheet.PrintPreview();
  },
  printOut: function () {
    this.xlSheet.PrintOut();
  },
  range: function (rangeStr) {
    var result = this.xlSheet.Range(rangeStr);
    return result;
  },
  visible: function (isVisible) {
    this.app.Visible = isVisible;
  },
  autoFit: function (rowStr) {
    this.xlSheet.Rows(rowStr).AutoFit();
  },
  setMinRowHeight: function (rowStr, minRowHeight) {
    var rowCount = this.xlSheet.Rows(rowStr).Count;
    var rowArray = rowStr.split(":");
    var startRow = parseInt(rowArray[0]),
      endRow = parseInt(rowArray[1]);
    for (var i = startRow; i <= endRow; i++) {
      var rowRange = i + ":" + i;
      var rowHeight = this.xlSheet.Rows(rowRange).RowHeight;
      if (rowHeight < minRowHeight) {
        this.xlSheet.Rows(rowRange).RowHeight = minRowHeight;
      }
    }
  },
  saveAs: function (fileName) {
    var fname = this.app.Application.GetSaveAsFilename(
      fileName,
      "Excel Spreadsheets (*.xls), *.xls"
    );
    this.xlWork.SaveAs(fname);
  },
};

function test() {
  console.log("test");
}
