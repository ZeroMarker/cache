// 外部调用打印
function nurFormPrint(sheetId, oeoreId, type) {
  var apiObj = {
    sheet: {
      func: "SheetPrintOutSide",
      className: "Nur.NIS.Service.OrderExcute.SheetPrint"
    },
    card: {
      func: "CardPrintOutSide",
      className: "Nur.NIS.Service.OrderExcute.CardPrint"
    }
  };
  var printFunc = window[apiObj[type].func];
  // 获取打印函数入参
  var retParr = $m({
      ClassName: "Nur.NIS.Service.OrderExcute.PrintInfo",
      MethodName: "getPrintViewPara",
      parr: oeoreId
    },false);
  // 就诊号id串
  var admIdStr = retParr.split("@")[0];
  // 主医嘱id串
  var seqIdStr = retParr.split("@")[1];
  if (sheetId) {
    // 获取打印设置
    $cm({
        ClassName: apiObj[type].className,
        MethodName: "GetBasicPrintSetting",
        sheetID: sheetId
      },function(printSetting) {
        // 获取打印格式配置
        $cm({
            ClassName: apiObj[type].className,
            MethodName: "GetPrintForm",
            sheetID: sheetId
          },function(printForm) {
            // 获取患者基本信息打印数据
            var patData = {};
            $cm({
                ClassName: apiObj[type].className,
                MethodName: "GetAllPrintData",
                parrStr: admIdStr,
                sheetID: sheetId,
                type: "PAT"
              },function(ret) {
                ret.forEach(function(patInfoObj) {
                  patInfoObj["printUser"] = "";
                  patInfoObj["printRange"] = "";
                  patData[patInfoObj["episodeID"]] = patInfoObj;
                });
                $cm({
                    ClassName: apiObj[type].className,
                    MethodName: "GetAllPrintData",
                    parrStr: oeoreId,
                    sheetID: sheetId,
                    type: "ORDER"
                  },function(orderPrintData) {
                    printFunc(seqIdStr,oeoreId,printSetting,printForm,patData,orderPrintData);
                  });
              });
          });
      });
  }
}