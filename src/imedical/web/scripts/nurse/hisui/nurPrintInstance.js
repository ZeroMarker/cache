// �ⲿ���ô�ӡ
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
  // ��ȡ��ӡ�������
  var retParr = $m({
      ClassName: "Nur.NIS.Service.OrderExcute.PrintInfo",
      MethodName: "getPrintViewPara",
      parr: oeoreId
    },false);
  // �����id��
  var admIdStr = retParr.split("@")[0];
  // ��ҽ��id��
  var seqIdStr = retParr.split("@")[1];
  if (sheetId) {
    // ��ȡ��ӡ����
    $cm({
        ClassName: apiObj[type].className,
        MethodName: "GetBasicPrintSetting",
        sheetID: sheetId
      },function(printSetting) {
        // ��ȡ��ӡ��ʽ����
        $cm({
            ClassName: apiObj[type].className,
            MethodName: "GetPrintForm",
            sheetID: sheetId
          },function(printForm) {
            // ��ȡ���߻�����Ϣ��ӡ����
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