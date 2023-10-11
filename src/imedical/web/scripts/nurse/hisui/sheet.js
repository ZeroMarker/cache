/*
 * @Description: 护士执行执行单打印设置
 */
(function() {
  var paperSize = {
    name: "A4",
    width: 210,
    height: 297,
    padding: 5
  };
  var sheetTitleSize = {
    top: 8,
    left: 0,
    width: paperSize.width,
    height: 10,
    fontSize: 13,
    fontFamily: "宋体",
    fontStyle: "Bold"
  };
  var sheetFooterSize = {
    top: 1,
    left: 0,
    width: paperSize.width,
    height: 5,
    fontSize: 20,
    content: [
      {
        code: "userName",
        text: "打印人:",
        x: 110,
        y: 0,
        width: 50,
        fontSize: 12,
        fontFamily: "黑体",
        fontStyle: "Bold"
      },
      {
        code: "currentDateTime",
        text: "打印时间:",
        x: 150,
        y: 0,
        width: 50,
        fontSize: 12,
        fontFamily: "黑体",
        fontStyle: "Bold"
      }
    ]
  };
  var sheetPageNum = {
    top: 0,
    left: 0,
    width: paperSize.width,
    height: 5,
    fontSize: 10,
    fontFamily: "黑体",
    fontStyle: "Bold"
  };
  var NurseSheetPat = {
    config: {
      printerName: ""
    },
    headInfo: {
      top: 5,
      left: 0,
      width: "",
      height: 5,
      fontSize: 20, //px
      fontFamily: "黑体",
      fontStyle: "Bold",
      content: [
        {
          code: "patInfoStr",
          text: "病人信息:",
          x: 0,
          y: 0,
          width: 100,
          fontSize: 8,
          fontFamily: "黑体",
          fontStyle: "Bold"
        },
        {
          code: "regNo",
          text: "登记号:",
          x: 45,
          y: 0,
          width: 40,
          fontSize: 8,
          fontFamily: "黑体",
          fontStyle: "Bold"
        },
        {
          code: "wardDesc",
          text: "病区:",
          x: 75,
          y: 0,
          width: 50,
          fontSize: 8,
          fontFamily: "黑体",
          fontStyle: "Bold"
        },
        {
          code: "medCareNo",
          text: "病案号:",
          x: 112,
          y: 0,
          width: 50,
          fontSize: 8,
          fontFamily: "黑体",
          fontStyle: "Bold"
        },
        {
          code: "searchRange",
          text: "打印范围:",
          x: 140,
          y: 0,
          width: 80,
          fontSize: 8,
          fontFamily: "黑体",
          fontStyle: "Bold"
        }
      ]
    },
    table: {
      dataRowHeight: 4.5,
      headRowHeight: 9,
      fontSize: 10,
      fontFamily: "宋体",
      fontStyle: ""
    }
  };
  var NurseSheetWard = {
    config: {
      printerName: ""
    },
    headInfo: {
      top: 5,
      left: 0,
      width: "",
      height: 5,
      fontSize: 20, //px
      fontFamily: "黑体",
      fontStyle: "Bold",
      content: [
        {
          code: "wardDesc",
          text: "病区:",
          x: 0,
          y: 0,
          width: 100,
          fontSize: 10,
          fontFamily: "黑体",
          fontStyle: "Bold"
        },
        {
          code: "searchRange",
          text: "打印范围:",
          x: 45,
          y: 0,
          width: 130,
          fontSize: 10,
          fontFamily: "黑体",
          fontStyle: "Bold"
        },
        {
          code: "userName",
          text: "打印人:",
          x: 115,
          y: 0,
          width: 50,
          fontSize: 10,
          fontFamily: "黑体",
          fontStyle: "Bold"
        },
        {
          code: "currentDateTime",
          text: "打印时间:",
          x: 150,
          y: 0,
          width: 80,
          fontSize: 10,
          fontFamily: "黑体",
          fontStyle: "Bold"
        }
      ]
    },
    table: {
      dataRowHeight: 4.5,
      headRowHeight: 9,
      fontSize: 10,
      fontFamily: "宋体",
      fontStyle: ""
    }
  };
  var formSheet = {
    paperSize: paperSize,
    sheetTitleSize: sheetTitleSize,
    sheetFooterSize: sheetFooterSize,
    NurseSheetPat: NurseSheetPat,
    NurseSheetWard: NurseSheetWard,
    sheetPageNum: sheetPageNum
  };
  window.formSheet = formSheet;
})();
