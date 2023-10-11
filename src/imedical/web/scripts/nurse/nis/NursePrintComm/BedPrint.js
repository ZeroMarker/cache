/*
 * @Description: 调用xml模板使用lodop打印床头卡及腕带
 */
(function() {
  // 床位图打印通用接口(停用)
  // function BedCommonPrint(episodeID, formwork, className, methodName) {
  //   var inpara = tkMakeServerCall(className, methodName, episodeID);
  //   var LODOP = getLodop();
  //   DHCP_GetXMLConfig("InvPrintEncrypt", formwork);
  //   DHC_PrintByLodop(LODOP, inpara, "", [], "");
  // }
  // 计费组调用
  function OutSidePrint(episodeID, type) {
    var hospId = session["LOGON.HOSPID"];
    var printSet = tkMakeServerCall(
      "Nur.NIS.Service.OrderExcute.Print",
      "GetBedPrintSetting",
      hospId,
      type
    );
    var printFormworkID = printSet.split(String.fromCharCode(12))[0];
    if (printFormworkID) {
      $cm(
        {
          ClassName: "Nur.NIS.Service.OrderExcute.XMLPrint",
          MethodName: "GetFormwork",
          sheetID: printFormworkID
        },
        function(formwork) {
          console.dir(formwork);
          $m(
            {
              ClassName: "Nur.NIS.Service.OrderExcute.XMLPrint",
              MethodName: "GetPrintData",
              sheetID: printFormworkID,
              parr: episodeID,
              type: "para"
            },
            function(paraData) {
              console.dir(paraData);
              $m(
                {
                  ClassName: "Nur.NIS.Service.OrderExcute.XMLPrint",
                  MethodName: "GetPrintData",
                  sheetID: printFormworkID,
                  parr: episodeID,
                  type: "list"
                },
                function(listData) {
                  window.NurPrtCommOutSide(formwork, paraData, listData);
                }
              );
            }
          );
        }
      );
    }
  }
  function CommonPrint(ajax, orderExcuteApi, episodeID, sheetID) {
    var formwork;
    var paraData;
    ajax(orderExcuteApi.getFormWork, sheetID)
      .then(function(formworkResult) {
        if (Number(formworkResult.tempID) !== Number(sheetID)) {
          throw new Error("模板错误");
        }
        formwork = formworkResult;
        return ajax(orderExcuteApi.getPrintData, sheetID, episodeID);
      })
      .then(function(paraDataResult) {
        paraData = paraDataResult.replace(/[\r\n]/g, "");
        return ajax(orderExcuteApi.getPrintData, sheetID, episodeID, "list");
      })
      .then(function(listDataResult) {
        var listData = listDataResult.replace(/[\r\n]/g, "");
        if ((paraData === listData) === "") {
          throw new Error("打印数据错误");
        }
        window.NurPrtCommOutSide(formwork, paraData, listData);
      })
      .catch(function(error) {
        alert(error.message);
      });
  }
  window.CommonPrint = CommonPrint;
  window.OutSidePrint = OutSidePrint;
})();
