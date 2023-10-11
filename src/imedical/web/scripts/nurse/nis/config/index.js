/**
 * @description axios通用接口地址1023
 */
(function() {
  const src = "imedical";
  const config = {
    proxyTable: {
      ".csp": "/" + src + "/web/csp/",
      web: "/" + src + "/web/"
    },
    shiftPrintFlag: true,
    apiUrl: "nurse.restful.csp",
    apiDebugUrl: "./csp/Nur.Restful.cls",
    // 按医嘱打印或者按执行记录打印(true为按日期打印,false为按执行记录打印)
    printSheetType: false,
    // 是否打印预览(true为显示打印预览,false为直接打印)
    printView: false,
    dateformat: "YYYY-MM-DD" //配置初始化时间格式，格式1："DD/MM/YYYY",格式2："YYYY-MM-DD"
  };
  if ("undefined" !== typeof websys_getMWToken) {
    config.apiUrl += "?MWToken=" + websys_getMWToken();
  }
  window.config = config;
})();
