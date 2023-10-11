/**
 * @description 工具类js --pengjunfu
 *
 */
/* eslint-disable */
// import Vue from 'vue';
// import session from '../../../../SVN/23huli/标准库/8.3.0p/临床/vue源码/nurse-vue/src/store/api/session';
// import systemApi from '../../../../SVN/23huli/标准库/8.3.0p/临床/vue源码/nurse-vue/src/store/api/systemConfig';
// import pinyinUtil from '../../../../SVN/23huli/标准库/8.3.0p/临床/vue源码/nurse-vue/src/comm/pinyinUtil'

var utils = {
  //   formatDate: function (date) {
  //     if (date && typeof date === 'object') {
  //       let day = date.getDate();
  //       if (day < 10) {
  //         day = `0${day}`;
  //       }
  //       let monthIndex = date.getMonth() + 1;
  //       if (monthIndex < 10) {
  //         monthIndex = `0${monthIndex}`;
  //       }
  //       const year = date.getFullYear();
  //       return `${year}-${monthIndex}-${day}`;
  //     } else if (date && typeof date === 'string') {
  //       const reg = /((^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(10|12|0?[13578])([-\/\._])(3[01]|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(11|0?[469])([-\/\._])(30|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(0?2)([-\/\._])(2[0-8]|1[0-9]|0?[1-9])$)|(^([2468][048]00)([-\/\._])(0?2)([-\/\._])(29)$)|(^([3579][26]00)([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][0][48])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][0][48])([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][2468][048])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][2468][048])([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][13579][26])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][13579][26])([-\/\._])(0?2)([-\/\._])(29)$))/gi;
  //       if (reg.test(date)) {
  //         return date;
  //       }
  //       else {
  //         const regDDMMYYY = /(0[1-9]|[12][0-9]|3[01])[/](0[1-9]|1[012])[/](19|20)[0-9]{2}/gi;
  //         if (regDDMMYYY.test(date)) {
  //           const yyyy = date.split('/')[2];
  //           const MM = date.split('/')[1];
  //           const dd = date.split('/')[0];
  //           date = `${yyyy}-${MM}-${dd}`;
  //           if (reg.test(date)) {
  //             return date;
  //           }
  //         }
  //       }
  //     }
  //     return '';
  //   },
  //   formatTime: function (time) {
  //     if (time && typeof time === 'object') {
  //       let hours = time.getHours();
  //       if (hours < 10) {
  //         hours = `0${hours}`;
  //       }
  //       let minute = time.getMinutes();
  //       if (minute < 10) {
  //         minute = `0${minute}`;
  //       }
  //       let second = time.getSeconds();
  //       if (second < 10) {
  //         second = `0${second}`;
  //       }
  //       return `${hours}:${minute}:${second}`;
  //     } else if (time && typeof time === 'string') {
  //       const reg = /^(20|21|22|23|[0-1]\d):[0-5]\d$/;
  //       if (reg.test(time)) {
  //         return time;
  //       }
  //     }
  //     return '';
  //   },
  //   compareDate: function (d1, d2) {
  //     if (typeof d1 !== 'object') {
  //       d1 = new Date(d1);
  //       d1.setHours(0);
  //       d1.setMinutes(0);
  //       d1.setSeconds(0);
  //     }
  //     if (typeof d2 !== 'object') {
  //       d2 = new Date(d2);
  //       d2.setHours(0);
  //       d2.setMinutes(0);
  //       d2.setSeconds(0);
  //     }
  //     return new Date(d1) > new Date(d2);
  //   },
  //   getCurrentDateTime: function (timeFormat) {
  //     timeFormat = timeFormat || "2";
  //     return systemApi.getCurrentDateTime(timeFormat).then(dateTime => dateTime);
  //   },
  //   getDevImagePath: function () {
  //     if (Vue.config.devtools) {
  //       return './images/uiimages/';
  //     } else {
  //       return '../images/uiimages/';
  //     }
  //   },
  //   completeRegNo(regNo) {
  //     return systemApi.getRegNoNum().then(regNoNum => {
  //       if (regNo.length < regNoNum) {
  //         for (let i = (regNoNum - regNo.length - 1); i >= 0; i--) {
  //           regNo = "0" + regNo;
  //         }
  //       }
  //       return regNo;
  //     });
  //   },

  //   getPrintDll: function () {
  //     let printDLL = document.getElementById('DHCCNursePrintComm');
  //     return printDLL;
  //   },
  //   /**
  //     * @author songchao
  //     * @description 验证字符串是否为正确的URL
  //     * @returns 0:正确 1:不是URL
  //     */
  //   checkUrl: function (urlString) {
  //     if (urlString != "") {
  //       var reg = /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?/;
  //       if (!reg.test(urlString)) {
  //         return 1;
  //       }
  //       return 0;
  //     }
  //   },
  //   /**
  //    * @author songchao
  //    * @description 对象属性比较函数(用于数组.sort)
  //    * @param propName 属性名
  //    */
  //   compareByProperty: function (propName) {
  //     return function (obj1, obj2) {
  //       const val1 = obj1[propName];
  //       const val2 = obj2[propName];
  //       if ((typeof val1 !== 'undefined') && (typeof val2 !== 'undefined')) {
  //         if (val2 < val1) {
  //           return 1;
  //         } else if (val2 > val1) {
  //           return -1;
  //         }
  //       }
  //       return 0;
  //     }
  //   },
  //   /**
  //    * @author songchao
  //    * @description 对象属性比较函数(用于数组.sort)
  //    * @param propName1 属性名1 (优先按照属性1排序)
  //    * @param propName1 属性名2
  //    */
  //   compareByTwoProperty: function (propName1, propName2) {
  //     return function (obj1, obj2) {
  //       const val1 = String(obj1[propName1]);
  //       const val2 = String(obj2[propName1]);
  //       const val21 = obj1[propName2];
  //       const val22 = obj2[propName2];
  //       if ((typeof val1 !== 'undefined') && (typeof val2 !== 'undefined') && (typeof val21 !== 'undefined') && (typeof val22 !== 'undefined')) {
  //         if (pinyinUtil.getFirstLetter(val2) < pinyinUtil.getFirstLetter(val1)) {
  //           return 1;
  //         } else if ((pinyinUtil.getFirstLetter(val2) === pinyinUtil.getFirstLetter(val1))) {
  //           if ((val21 > val22)) {
  //             return 1;
  //           } else {
  //             return -1;
  //           }
  //         }
  //         else {
  //           return -1;
  //         }
  //       }
  //       return 0;
  //     }
  //   },
  //   /**
  //   * @author songchao
  //   * @description 对象属性比较函数(用于数组.sort)
  //   * @param propName1 属性名1 (优先按照属性1排序)
  //   * @param propName1 属性名2
  //   */
  //   compareByString: function (str1, str2) {
  //     if (typeof str1 === "string") {

  //       str1.charCodeAt()
  //     }
  //     return 0;
  //   },
  //   /**
  //   * @author songchao
  //   * @description ClickOnce方式打印执行单
  //   */
  //   openWin: function (url) {
  //     var a = document.createElement("a"); //创建a对象
  //     a.setAttribute("href", url);
  //     a.setAttribute("target", "_blank");
  //     a.setAttribute("id", "camnpr");
  //     if (!document.getElementById("camnpr")) {
  //       document.body.appendChild(a);
  //     }
  //     a.click(); //执行当前对象
  //     document.body.removeChild(a);
  //   },
  //   /**
  //    * @author songchao
  //    * @description ClickOnce方式打印执行单
  //    * @description 通过存打印参数到数据库进行传参
  //    */
  //   showNurseExcuteSheetPreviewNew: function (userID, timeStamp, type, queryCode, webIp, savePrintHistory, printNum, xmlName, userName, searchRange) {
  //     var ServerIP = webIp
  //     searchRange = searchRange || "";
  //     if (typeof ServerNameSpace != 'undefined') {
  //       ServerIP = "http://" + ServerNameSpace.split(":")[1].split("[")[0];
  //     }
  //     var locId = session.USER.CTLOCID;
  //     var groupId = session.USER.GROUPID;
  //     var link = ""
  //     link = webIp + "/DHCMG/NurseExcute/DHCCNursePrintComm.application?method=showNurseExcuteSheetPreviewNew&userID=" + userID + "&timeStamp=" + timeStamp
  //       + "&type=" + type + "&queryCode=" + queryCode + "&webIp=" + ServerIP + "&savePrintHistory=" + savePrintHistory
  //       + "&printNum=" + printNum + "&xmlName=" + xmlName + "&userName=" + userName + "&searchRange=" + searchRange
  //       + "&locId=" + locId + "&groupId=" + groupId;
  //     /* global window */
  //     window.open(link, '', 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
  //   },
  //   /**
  //   * @author songchao
  //   * @description ClickOnce方式打印执行单
  //   */
  //   showNurseExcuteSheetPreview: function (orderItemIdStr, seqNoStr, type, queryCode, webIp, savePrintHistory, printNum, xmlName) {
  //     // var webIp = runServerMethod("Nur.DHCMGNurseSet", "getSet").split("^")[1];
  //     var ServerIP = webIp
  //     if (typeof ServerNameSpace != 'undefined') {
  //       ServerIP = "http://" + ServerNameSpace.split(":")[1].split("[")[0];
  //     }
  //     var link = ""
  //     link = webIp + "/DHCMG/NurseExcute/DHCCNursePrintComm.application?method=showNurseExcuteSheetPreview&orderItemIdStr=" + orderItemIdStr
  //       + "&seqNoStr=" + seqNoStr + "&type=" + type + "&queryCode=" + queryCode + "&webIp=" + ServerIP
  //       + "&savePrintHistory=" + savePrintHistory + "&printNum=" + printNum + "&xmlName=" + xmlName;
  //     /* global window */
  //     window.open(link, '', 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
  //   },
  //   /**
  //    * @author songchao
  //    * @description ClickOnce方式打印床头卡等单据
  //    */
  //   showOtherSingleSheet: function (orderItemIdStr, seqNoStr, webIp, xmlName) {
  //     var ServerIP = webIp
  //     if (typeof ServerNameSpace != 'undefined') {
  //       ServerIP = "http://" + ServerNameSpace.split(":")[1].split("[")[0];
  //     }
  //     var link = ""
  //     link = webIp + "/DHCMG/NurseExcute/DHCCNursePrintComm.application?method=showOtherSingleSheet&orderItemIdStr=" + orderItemIdStr
  //       + "&seqNoStr=" + seqNoStr + "&webIp=" + webIp + "&xmlName=" + xmlName;
  //     /* global window */
  //     window.open(link, '', 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
  //   },

  //   /**
  //    * @author songchao
  //    * @description ClickOnce方式打印送检单
  //    */
  //   showSJD: function (orderItemIdStr, seqNoStr, webIp, xmlName) {
  //     // var webIp = runServerMethod("Nur.DHCMGNurseSet", "getSet").split("^")[1];
  //     var ServerIP = webIp
  //     if (typeof ServerNameSpace != 'undefined') {
  //       ServerIP = "http://" + ServerNameSpace.split(":")[1].split("[")[0];
  //     }
  //     var link = ""
  //     link = webIp + "/DHCMG/NurseExcute/DHCCNursePrintComm.application?method=showSJD&orderItemIdStr=" + orderItemIdStr
  //       + "&seqNoStr=" + seqNoStr + "&webIp=" + ServerIP + "&xmlName=" + xmlName;
  //     if (parent.parent.frames["TRAK_main"]) {
  //       parent.parent.frames["TRAK_main"].location = link;
  //     } else {
  //       window.open(link, "", 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
  //     }
  //   },

  //   /**
  //    * @author songchao
  //    * @description 体温单生成图片
  //    * @param episodeID 就诊号
  //    * @param flag 成人标志
  //    * @augments
  //    */
  makeTempPic: function(episodeID, flag, webIp) {
    var ServerIP = webIp;
    if (typeof ServerNameSpace != "undefined") {
      ServerIP = "http://" + ServerNameSpace.split(":")[1].split("[")[0];
    }
    var webservice = ServerIP + "/imedical/web/Nur.TemperatureInterface.cls";
    var FilePath = ServerIP + "/dhcmg/temperature/temperatureChart.xml";
    var link =
      webIp +
      "/dhcmg/temperature/Temperature.application?method=MakeTempPic&EpisodeID=" +
      episodeID +
      "&webservice=" +
      webservice +
      "&FilePath=" +
      FilePath +
      "&flag=" +
      flag +
      "";
    window.open(
      link,
      "",
      "height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no"
    );
  },
  //   /**
  //    * @author songchao
  //    * @description 根据元素id,打印网页指定内容
  //    * @augments
  //    */
  //   printByElementID: function (id) {
  //     var newWindow = window.open("打印窗口", "_blank");
  //     var docStr = document.getElementById(id).innerHTML;
  //     newWindow.document.write(docStr);
  //     newWindow.document.close();
  //     newWindow.print();
  //     newWindow.close();
  //   },
  //   /**
  //     * @author songchao
  //     * @description 获取客户端IP
  //     * @augments
  //     */
  //   getComputerIp: function () {
  //     var ipAddr = "";
  //     var locator = new ActiveXObject("WbemScripting.SWbemLocator");
  //     var service = locator.ConnectServer("."); //连接本机服务器
  //     var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration");  //查询使用SQL标准
  //     var e = new Enumerator(properties);
  //     var p = e.item();
  //     for (; !e.atEnd(); e.moveNext()) {
  //       var p = e.item();
  //       //document.write("IP:" + p.IPAddress(0) + " ");//IP地址为数组类型,子网俺码及默认网关亦同
  //       ipAddr = p.IPAddress(0);
  //       if (ipAddr) break;
  //     }
  //     return ipAddr;
  //   },
  //   /**
  //    * @author songchao
  //    * @description 获取客户端名称
  //    * @augments
  //    */
  //   getComputerName: function () {
  //     var regedit = new RegEdit();
  //     var computerName = regedit.regRead("HKEY_CURRENT_USER\\Volatile Environment\\ViewClient_Machine_Name");
  //     if ((computerName != "") && (computerName != null)) {
  //       return computerName
  //     }
  //     var computerName;
  //     try {
  //       var WshNetwork = new ActiveXObject("WScript.Network");
  //       computerName = WshNetwork.ComputerName;
  //       WshNetwork = null;
  //     }
  //     catch (e) {
  //       computerName = "";
  //     }
  //     return computerName;
  //   },
  //   /**
  //    * @author songchao
  //    * @description 润乾打印
  //    * @augments 报表名称.raq&arg1=width&arg2=height
  //    */
  //   runqianPrint: function (parameter, width, height) {
  //     //use window.open so we can close this window, without closing everything
  //     //format reportname(reportarg1=value;reportarg2=value)
  //     var args = arguments.length
  //     var parm = ""
  //     if (args >= 1) {
  //       if (arguments[0] == "") {
  //         alert("请输入报表名称和报表参数");
  //         return;
  //       }
  //       parm = arguments[0];
  //     }
  //     if (args >= 2) {
  //       if (arguments[1] != "") {
  //         width = arguments[1];
  //       }
  //     }
  //     if (args >= 3) {
  //       if (arguments[2] != "") {
  //         height = arguments[2];
  //       }
  //     }
  //     var url = "dhccpmrunqianreportprint.csp?reportName=" + parm;
  //     window.open(url, 1, `width=${width},height=${height},top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes`);
  //   },

  createJS: function(name, callBack) {
    const object = window[name];
    // this.importJS();
    if (!object) {
      const script = document.createElement("script");
      script.setAttribute("type", "text/javascript");
      if (process.env.VUE_APP_MOCK === "true") {
      } else {
        script.setAttribute(
          "src",
          '../scripts/nurse/nis/HandleMethod/'+name+'.js'
        );
      }
      // if (Vue.config.devtools) {
      //   script.setAttribute("src", `images/${name}.js`);
      // } else {
      //   script.setAttribute("src", `../scripts/nurse/nurse station/${name}.js`);
      // }
      script.onload = function() {
        callBack(window[name]);
      };
      document.body.appendChild(script);
    } else {
      callBack(window[name]);
    }
  },
  //   creatDomObjectNode(classid, id, style, ifVIEWASTEXT) {
  //     const object = document.createElement('OBJECT');
  //     object.setAttribute('classid', classid);
  //     object.setAttribute('id', id);
  //     object.setAttribute('style', style);
  //     if (ifVIEWASTEXT) {
  //       const VIEWASTEXT = document.createAttribute("VIEWASTEXT");
  //       object.setAttributeNode(VIEWASTEXT);
  //     }
  //     document.body.appendChild(object);
  //   },
  /**
   * @description 把多个数组按照size分割成多维数组
   * @param {any} chunks 空数组 []
   * @param {any} size 分割大小 例如2
   * @param {any} argus 要分割的数组  例如   [1,2,3,4],[2,4,6,8]
   * @returns  [
   *              [[1,2],[2,4]],
   *              [[3,4],[6,8]]
   *            ]
   */
  splitChunk: function(chunks, size) {
    var argus=[]
    for (var k = 0; k < arguments[2].length; k=k+size) {
      var tmp=[]
      for (var i = 2; i < arguments.length; i++) {
        tmp.push(arguments[i].slice(k, k+size))
      }
      argus.push(tmp)
    }
    return argus
  }
};

// export default utils;
