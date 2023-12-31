/**
 * 临床产品通用对象
 * @author chenchangqing 20170809
 */
var dhccl = {
  /**
   * 临床产品通用CSP名称对象
   */
  csp: {
    /**
     * dhccl.dataservice.csp
     */
    dataService: "dhccl.dataservice.csp",
    /**
     * dhccl.dataquery.csp
     */
    dataQuery: "dhccl.dataquery.csp",
    /**
     * dhccl.methodservice.csp
     */
    methodService: "dhccl.methodservice.csp",
    /**
     * dhccl.datalistservice.csp
     */
    dataListService: "dhccl.datalistservice.csp",
    /**
     * dhccl.dataqueries.csp
     */
    dataQueries: "dhccl.dataqueries.csp",
  },
  /**
   * 临床产品通用业务类名称对象
   */
  bll: {
    /**
     * DHCCL.BLL.DataService
     */
    dataService: "CIS.AN.COM.DataService",
    /**
     * DHCCL.BLL.Admission
     */
    admission: "CIS.AN.BL.Admission",
  },
  /**
   * 临床产品通用方法名称对象
   */
  methods: {
    /**
     * DelData
     */
    delData: "DelData",

    /**
     * DelDatas
     */
    delDatas: "DelDatas",
  },

  /**
   * 获取数据通用函数
   * @param {string} url - 请求的页面
   * @param {object} param - 请求的参数
   * @param {string} dataType - 返回的数据类型
   * @param {boolean} async - 是否异步请求
   * @param {function} callback - 回调函数
   * @returns {Array} 数据数组
   * @author chenchangqing 20170809
   */
  getDatas: function (url, param, dataType, async, callback) {
    var result = null;
    if (async === undefined) {
      async = false;
    }
    $.ajax({
      url: url,
      async: async,
      data: param,
      type: "post",
      dataType: dataType,
      success: function (data) {
        result = data;
        if (dataType === "text") {
          result = $.trim(result);
        }
        if (callback) {
          callback(data);
        }
      },
    });
    return result;
  },

  /**
   * 保存数据通用函数
   * @param {string} url - 请求的地址
   * @param {object} param - 请求参数
   * @returns {string} 保存结果，成功返回"S^"，失败返回"E^失败原因"
   * @author chenchangqing 20170809
   */
  saveDatas: function (url, param, successfn) {
    var result = null;
    $.ajax({
      url: url,
      async: false,
      data: param,
      type: "post",
      success: function (data) {
        result = $.trim(data);
        if (successfn) {
          successfn(result);
        }
      },
    });
    return result;
  },

  /**
   * 删除数据通用函数
   * @param {string} className - 实体类名称
   * @param {string} rowId - 需删除数据的ID
   * @returns {string} 删除结果，成功返回"S^"，失败返回"E^失败原因"。
   * @author chenchangqing 20170809
   */
  removeData: function (className, rowId) {
    var result = null;
    $.ajax({
      url: ANCSP.MethodService,
      async: false,
      data: {
        ClassName: CLCLS.BLL.DataService,
        MethodName: dhccl.methods.delData,
        Arg1: className,
        Arg2: rowId,
        ArgCnt: 2,
      },
      type: "post",
      success: function (data) {
        result = $.trim(data);
      },
    });
    return result;
  },

  /**
   * 批量删除数据通用函数
   * @param {string} paraStr - 需删除数据的类名和RowId拼成的字符串
   * @returns {string} 删除结果，成功返回"S^"，失败返回"E^失败原因"。
   * @author chenchangqing 20180108
   */
  removeDatas: function (paraStr) {
    var result = null;
    $.ajax({
      url: ANCSP.MethodService,
      async: false,
      data: {
        ClassName: CLCLS.BLL.DataService,
        MethodName: dhccl.methods.delDatas,
        Arg1: paraStr,
        ArgCnt: 1,
      },
      type: "post",
      success: function (data) {
        result = $.trim(data);
      },
    });
    return result;
  },

  /**
   * 运行cache类方法
   * @param {string} className - 类名称
   * @param {string} methodName - 类方法名称
   * @param {string} args - 参数，不固定个数
   * @author chenchangqing 20190425
   * @returns 结果对象 {result:提示信息,success:是否成功}
   */
  runServerMethod: function () {
    var result = null;
    if (arguments.length < 2) return result;
    var className = arguments[0];
    var methodName = arguments[1];
    var params = [];
    for (var i = 2; i < arguments.length; i++) {
      if (params.length > 0) params.push(splitchar.comma);
      params.push('"' + arguments[i] + '"');
    }
    
    $.ajax({
      url: ANCSP.MethodService,
      async: false,
      data: {
        ClassName: className,
        MethodName: methodName,
        Params: params.join(""),
      },
      type: "post",
      success: function (data) {
        result = $.trim(data);
      },
    });
    var resultObj = null;
    if (typeof result === "string") {
      try {
        resultObj = JSON.parse(result);
      } catch (error) {
        resultObj = this.resultToJson(result);
      }
    }
    return resultObj;
  },

  /**
   * 运行cache类方法，返回字符串
   */
  runServerMethodNormal: function () {
    var result = null;
    if (arguments.length < 2) return result;
    var className = arguments[0];
    var methodName = arguments[1];
    var params = [];
    for (var i = 2; i < arguments.length; i++) {
      if (params.length > 0) params.push(splitchar.comma);
      params.push('"' + arguments[i] + '"');
    }
    var aa=websys_getMWToken()
    $.ajax({
      url: ANCSP.MethodService,
      async: false,
      data: {
        ClassName: className,
        MethodName: methodName,
        Params: params.join(""),
      },
      type: "post",
      success: function (data) {
        result = $.trim(data);
      },
    });
    return result;
  },

  /**
   * 异步方式运行cache类方法
   */
  runServerMethodAsync: function () {
    var result = null;
    if (arguments.length < 2) return result;
    var className = arguments[0];
    var methodName = arguments[1];
    var params = [];
    for (var i = 2; i < arguments.length; i++) {
      if (params.length > 0) params.push(splitchar.comma);
      params.push('"' + arguments[i] + '"');
    }
    $.ajax({
      url: ANCSP.MethodService,
      async: true,
      data: {
        ClassName: className,
        MethodName: methodName,
        Params: params.join(""),
      },
      type: "post",
      success: function (data) {
        result = $.trim(data);
      },
    });
    var resultObj = null;
    if (typeof result === "string") {
      try {
        resultObj = JSON.parse(result);
      } catch (error) {
        resultObj = this.resultToJson(result);
      }
    }
    return resultObj;
  },

  /**
   * 将结果字符串转为json对象
   * @param {string} result 结果字符串
   */
  resultToJson: function (result) {
    var retArr = result.split(splitchar.arrow);
    if (retArr.length === 1) {
      return { result: result };
    }
    return { success: retArr[0] === "S", result: retArr[1] };
  },

  /**
   * 获取查询参数的值
   * @param {string} name - 参数名称
   * @returns {string} 查询参数的值
   * @author chenchangqing 20170809
   */
  getQueryString: function (name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
  },

  /**
   * 将对象数组格式化为字符串
   * @param {Array} dataObjects - 对象数组
   * @returns {string} 格式化后的字符串
   * @author chenchangqing 20170809
   */
  formatObjects: function (dataObjects) {
    var result = "",
      objSplitChar = splitchar.two;
    if (dataObjects.length && dataObjects.length > 0) {
      for (var i = 0; i < dataObjects.length; i++) {
        var dataObjectStr = this.formatObject(dataObjects[i]);
        if (result != "") {
          result += objSplitChar;
        }
        result += dataObjectStr;
      }
    } else {
      result = this.formatObject(dataObjects);
    }

    return result;
  },

  /**
   * 将对象格式化为字符串
   * @param {object} dataObject - 需要格式化的对象
   * @returns {string} 格式化后的字符串
   * @author chenchangqing 20170809
   */
  formatObject: function (dataObject) {
    var result = "",
      propertySplitChar = splitchar.one,
      valueSplitChar = splitchar.zero;
    if (dataObject) {
      for (var property in dataObject) {
        var propertyStr = property + valueSplitChar + dataObject[property];
        if (result != "") {
          result += propertySplitChar;
        }
        result += propertyStr;
      }
    }
    return result;
  },

  /**
   * 显示消息
   * @param {string} result - 返回的结果
   * @param {string} operation - 操作类型
   * @param {string} successMsg - 用户自定义的成功消息
   * @param {string} errorMsg - 用户自定义的失败消息
   * @param {function} successfn - 返回成功的回调函数
   * @param {function} errorfn - 返回失败的回调函数
   * @author chenchangqing 20170810
   */
  showMessage: function (
    result,
    operation,
    successMsg,
    errorMsg,
    successfn,
    errorfn
  ) {
    var message = operation;
    var dataResult = $.trim(result);
    if (dataResult.indexOf("S^") === 0) {
      if (successMsg && successMsg != "") {
        message = successMsg;
      } else {
        message = operation + "数据成功！";
      }
      $.messager.alert("提示", message, "info", successfn);
    } else {
      if (errorMsg && errorMsg != "") {
        message = errorMsg;
      } else {
        message = operation + "数据失败！" + dataResult;
      }
      $.messager.alert("提示", message, "error", errorfn);
    }
  },

  /**
   * 判断DataGrid是否有选择行(适合单选的情况)
   * @param {object} datagrid - datagrid的jquery对象
   * @param {boolean} showPrompt - 没有选择行时，是否显示提示
   * @param {string} msg - 提示信息
   * @returns {boolean} 有选择行返回true，否则返回false
   * @author chenchangqing 20170810
   */
  hasRowSelected: function (datagrid, showPrompt, msg) {
    var result = false;
    if (datagrid) {
      var selectedRow = datagrid.datagrid("getSelected");
      if (selectedRow) {
        result = true;
      } else {
        result = false;
      }
    }
    if (!result && showPrompt) {
      var message = msg ? msg : "请先选择一行再进行操作！";
      $.messager.alert("提示", message, "warning");
    }
    return result;
  },

  /**
   * 判断DataGrid是否有选择行(适合单选的情况)
   * @param {object} datagrid - datagrid的jquery对象
   * @param {boolean} showPrompt - 没有选择行时，是否显示提示
   * @param {string} msg - 提示信息
   * @returns {boolean} 有选择行返回true，否则返回false
   * @author chenchangqing 20170810
   */
  hasRowsSelected: function (datagrid, showPrompt, msg) {
    var result = false;
    if (datagrid) {
      var selectedRows = datagrid.datagrid("getSelections");
      if (selectedRows && selectedRows.length > 0) {
        result = true;
      } else {
        result = false;
      }
    }
    if (!result && showPrompt) {
      var message = msg ? msg : "请先选择一行再进行操作！";
      $.messager.alert("提示", message, "warning");
    }
    return result;
  },

  /**
   * 将字符串转换为Date对象
   * @param {string} dateTimeStr - 日期时间字符串
   * @returns {Date} Date对象
   * @author chenchangqing 20170830
   */
  toDateTime: function (dateTimeStr) {
    if (typeof dateTimeStr === "string") {
      return new Date(dateTimeStr.replace(/-/g, "/"));
    } else if (typeof dateTimeStr === "object") {
      return dateTimeStr;
    }
    return new Date();
  },

  /**
   * 获取对象数组排序比较函数
   * @param {string} propertyName - 比较属性名称
   * @returns {function} 对象比较函数
   * @author chenchangqing 20170902
   */
  compareInstance: function (propertyName) {
    return function (object1, object2) {
      var value1 = object1[propertyName];
      var value2 = object2[propertyName];
      if (value1 < value2) {
        return -1;
      } else if (value1 > value2) {
        return 1;
      } else {
        return 0;
      }
    };
  },

  /**
   * 生成GUID
   * @returns {string} 生成的GUID字符串
   * @author chenchangqing 20171129
   */
  guid: function () {
    var guid = "";
    for (var i = 1; i <= 32; i++) {
      var n = Math.floor(Math.random() * 16.0).toString(16);
      guid += n;
      if (i == 8 || i == 12 || i == 16 || i == 20) guid += "-";
    }
    return guid;
  },

  /**
   * 对数组按字段分组
   * @param {Array} arr 要分组的数组
   * @param {String} groupField 分组字段
   * @returns 分组后的数组
   */
  group: function (arr, groupField) {
    if (!arr || !arr.length || arr.length <= 0) return null;
    if (!groupField) return null;
    var map = {},
      dest = [];
    for (var i = 0; i < arr.length; i++) {
      var ai = arr[i];
      if (!map[ai[groupField]]) {
        dest.push({
          id: ai[groupField], // 分组字段值
          data: [ai], // 分组数据数值
        });
        map[ai[groupField]] = ai;
      } else {
        for (var j = 0; j < dest.length; j++) {
          var dj = dest[j];
          if (dj.id == ai[groupField]) {
            dj.data.push(ai);
            break;
          }
        }
      }
    }

    return dest;
  },

  /**
   * 将显示序号转换成26个字母序号
   * @param {number} displayIndex - 显示顺序
   * @author chenchangqing 20180111
   */
  indexToColumn: function (displayIndex) {
    displayIndex--;
    var column = "";
    do {
      if (column.length > 0) {
        displayIndex--;
      }
      column =
        String.fromCharCode((displayIndex % 26) + "A".charCodeAt()) + column;
      displayIndex = ((displayIndex - (displayIndex % 26)) / 26).toFixed();
    } while (displayIndex > 0);
    return column;
  },

  /**
   * 获取Jquery控件的值
   * @param {object} jqueryObj - jquery对象
   * @param {string} className - jquery控件的类名
   * @author chenchangqing 20180526
   */
  getControlValue: function (jqueryObj) {
    var ret = "",
      opts = null;
    if (jqueryObj.hasClass(Controls.ComboBox)) {
      opts = jqueryObj.combobox("options");
      if (opts.multiple === true) {
        var valueArr = jqueryObj.combobox("getValues");
        ret = valueArr.toString();
      } else {
        ret = jqueryObj.combobox("getValue");
      }
    } else if (jqueryObj.hasClass(Controls.CheckBox)) {
      var checkValue = jqueryObj.checkbox("getValue");
      ret = checkValue ? jqueryObj.checkbox("options").label : "";
    } else if (jqueryObj.hasClass(Controls.DateBox)) {
      ret = jqueryObj.datebox("getValue");
    } else if (jqueryObj.hasClass(Controls.ValidateBox)) {
      ret = jqueryObj.val();
    } else if (jqueryObj.hasClass(Controls.NumberBox)) {
      ret = jqueryObj.numberbox("getValue");
    } else if (jqueryObj.hasClass(Controls.TimeSpinner)) {
      ret = jqueryObj.timespinner("getValue");
    } else {
      ret = jqueryObj.val();
    }

    return ret;
  },

  setControlValue: function (jqueryObj, dataValue) {
    if (jqueryObj.hasClass(Controls.ComboBox)) {
      jqueryObj.combobox("setValue", dataValue);
    } else if (jqueryObj.hasClass(Controls.CheckBox)) {
      jqueryObj.checkbox(
        "setValue",
        jqueryObj.checkbox("options").label == dataValue
      );
    } else if (jqueryObj.hasClass(Controls.DateBox)) {
      jqueryObj.datebox("setValue", dataValue);
    } else if (jqueryObj.hasClass(Controls.ValidateBox)) {
      jqueryObj.val(dataValue);
    } else if (jqueryObj.hasClass(Controls.NumberBox)) {
      jqueryObj.numberbox("setValue", dataValue);
    } else if (jqueryObj.hasClass(Controls.TimeSpinner)) {
      jqueryObj.timespinner("setValue", dataValue);
    } else {
      jqueryObj.val(dataValue);
    }
  },

  disableEditControls: function (ignoreSelector) {
    $("." + Controls.ValidateBox).attr("disabled", true);
    $("." + Controls.DateBox).datebox("disable");
    $("." + Controls.DateTimeBox).datetimebox("disable");
    $("." + Controls.TimeSpinner).timespinner("disable");
    $("." + Controls.CheckBox).checkbox("disable");
    $("." + Controls.LinkButton).linkbutton("disable");
    $("." + Controls.NumberBox).numberbox("disable");
    $("." + Controls.SearchBox).searchbox("disable");
    $("." + Controls.Combo).combo("disable");
    $("." + Controls.ComboBox).combobox("disable");
    // $("#" + Controls.SwitchBox).switchbox("disable");
    $("#" + Controls.FileBox).filebox("disable");
    $("#" + Controls.Radio).radio("disable");

    this.setControlsAbleStatus(ignoreSelector, "enable");
  },

  disableSelectedControls: function (selector) {
    this.setControlsAbleStatus(selector, "disable");
  },

  setControlsAbleStatus: function (selector, ableStatus) {
    $(selector).each(function (index, el) {
      if ($(this).hasClass(Controls.ValidateBox)) {
        $(this).attr("disabled", ableStatus === "disable");
      } else if ($(this).hasClass(Controls.DateBox)) {
        $(this).datebox(ableStatus);
      } else if ($(this).hasClass(Controls.DateTimeBox)) {
        $(this).datetimebox(ableStatus);
      } else if ($(this).hasClass(Controls.TimeSpinner)) {
        $(this).timespinner(ableStatus);
      } else if ($(this).hasClass(Controls.CheckBox)) {
        $(this).checkbox(ableStatus);
      } else if ($(this).hasClass(Controls.LinkButton)) {
        $(this).linkbutton(ableStatus);
      } else if ($(this).hasClass(Controls.NumberBox)) {
        $(this).numberbox(ableStatus);
      } else if ($(this).hasClass(Controls.SearchBox)) {
        $(this).searchbox(ableStatus);
      } else if ($(this).hasClass(Controls.Combo)) {
        $(this).combo(ableStatus);
      } else if ($(this).hasClass(Controls.SwitchBox)) {
        $(this).switchbox(ableStatus);
      } else if ($(this).hasClass(Controls.ComboBox)) {
        $(this).combobox(ableStatus);
      } else if ($(this).hasClass(Controls.FileBox)) {
        $(this).filebox(ableStatus);
      } else if ($(this).hasClass(Controls.Radio)) {
        $(this).radio(ableStatus);
      }
    });
  },

  getCharCount: function (text) {
    if (!text || text === "") return 0;
    var alphabetReg = /\w|\s|\d|[\-,\+]/g;
    var matchCount = text.match(alphabetReg);
    var ret = text.length - matchCount / 2;
    return ret;
  },

  getFontSize: function (text, lineWidth) {
    var charCount = this.getCharCount(text);
    var ret = 14;
    if (charCount > 0 && !isNaN(lineWidth)) {
      ret = parseInt(lineWidth / charCount);
    }
    if (ret > 14) ret = 14;
    return ret;
  },

  /**
   * 结束表格的编辑状态
   * @param {String}} boxSelector 选择器
   */
  endEditDataBox: function (boxSelector) {
    var dg = $("#" + boxSelector);
    var rows = dg.datagrid("getRows");
    if (rows && rows.length > 0) {
      for (var i = 0; i < rows.length; i++) {
        dg.datagrid("endEdit", i);
      }
    }
  },

  /**
   * 转换日期控件的显示格式
   */
  parseDateFormat: function () {
    var validParams = "YMD";
    if (session.DateFormat === "j/n/Y") {
      validParams = "DMY";
    }
    $(".hisui-datebox").datebox({
      // required:true,
      formatter: function (date) {
        var dateFormat = session.DateFormat;
        var y = date.getFullYear();
        var m = date.getMonth() + 1;
        var d = date.getDate();
        if (dateFormat == "j/n/Y") {
          d = d < 10 ? "0" + d : d;
          m = m < 10 ? "0" + m : m;
          var ssss = d + "/" + m + "/" + y;
          return ssss;
        } else
          return (
            y + "-" + (m < 10 ? "0" + m : m) + "-" + (d < 10 ? "0" + d : d)
          );
      },
      parser: function (s) {
        if (!s) return new Date();
        if (s.indexOf("/") >= 0) {
          var ss = s.split("/");
          var y = parseInt(ss[2], 10);
          var m = parseInt(ss[1], 10);
          var d = parseInt(ss[0], 10);
        } else {
          var ss = s.split("-");
          var y = parseInt(ss[0], 10);
          var m = parseInt(ss[1], 10);
          var d = parseInt(ss[2], 10);
        }
        if (!isNaN(y) && !isNaN(m) && !isNaN(d)) {
          return new Date(y, m - 1, d);
        } else {
          return new Date();
        }
      },
      validParams: validParams,
    });
  },

  /**
   * 转换日期控件的显示格式
   */
  parseDateTimeFormat: function () {
    var validParams = "YMD";
    if (session.DateFormat === "j/n/Y") {
      validParams = "DMY";
    }
    $(".hisui-datetimebox").datetimebox({
      formatter: function (date) {
        var curYear = new Date().getFullYear();
        var dateFormat = session.DateFormat;
        var y = date.getFullYear();
        var m = date.getMonth() + 1;
        var d = date.getDate();
        var h = date.getHours();
        var min = date.getMinutes();
        var sec = date.getSeconds();
        h = h < 10 ? "0" + h : h;
        min = min < 10 ? "0" + min : min;
        sec = sec < 10 ? "0" + sec : sec;
        if (dateFormat == "j/n/Y") {
          m = m < 10 ? "0" + m : m;
          d = d < 10 ? "0" + d : d;
          var ssss = d + "/" + m + "/" + y + " " + h + ":" + min + ":" + sec;
          return ssss;
        } else
          return (
            y +
            "-" +
            (m < 10 ? "0" + m : m) +
            "-" +
            (d < 10 ? "0" + d : d) +
            " " +
            h +
            ":" +
            min +
            ":" +
            sec
          );
      },
      parser: function (s) {
        if (!s) return new Date();
        if (s.indexOf("/") >= 0) {
          var str = s.split(" ");
          var MyDateStr = str[0];
          var MyTimeStr = str[1];
          var MyDate = MyDateStr.split("/");
          var y = parseInt(MyDate[2], 10);
          var m = parseInt(MyDate[1], 10);
          var d = parseInt(MyDate[0], 10);
          var MyTime = MyTimeStr.split(":");
          var h = parseInt(MyTime[0], 10);
          var min = parseInt(MyTime[1], 10);
          var sec = parseInt(MyTime[2], 10);
        } else {
          var str = s.split(" ");
          var MyDateStr = str[0];
          var MyTimeStr = str[1];
          var MyDate = MyDateStr.split("-");
          var y = parseInt(MyDate[0], 10);
          var m = parseInt(MyDate[1], 10);
          var d = parseInt(MyDate[2], 10);
          var MyTime = MyTimeStr.split(":");
          var h = parseInt(MyTime[0], 10);
          var min = parseInt(MyTime[1], 10);
          var sec = parseInt(MyTime[2], 10);
        }
        if (!isNaN(y) && !isNaN(m) && !isNaN(d)) {
          return new Date(y, m - 1, d, h, min, sec);
        } else {
          return new Date();
        }
      },
      validParams: validParams,
    });
  },

  alertMessage: function (msg) {
    $.messager.alert("提示", msg, "info");
  },

  setHeaderParam: function (operSchedule) {
    var EpisodeID = operSchedule.EpisodeID;
    var PatientID = operSchedule.PatientID;
    var mradm = operSchedule.MRAdmID || "";
    var AnaesthesiaID = operSchedule.ExtAnaestID || "";

    var win = top.frames["eprmenu"];
    var frm;
    if (win) frm = win.document.forms["fEPRMENU"];
    else frm = dhcsys_getmenuform();

    if (frm) {
      frm.EpisodeID.value = EpisodeID;
      frm.PatientID.value = PatientID;
      frm.mradm.value = mradm;
      if (frm.AnaesthesiaID) frm.AnaesthesiaID.value = AnaesthesiaID;
    }
  },

  showModalDialog: function (url, width, height, callback) {
    if (window.showModalDialog) {
      if (callback) {
        var rlt = showModalDialog(
          url,
          "",
          "resizable:no;scroll:no;status:no;center:yes;help:no;dialogWidth:" +
            width +
            " px;dialogHeight:" +
            height +
            " px"
        );
        if (rlt) return callback(rlt);
        else {
          callback(window.returnValue);
        }
      } else
        showModalDialog(
          url,
          "",
          "resizable:no;scroll:no;status:no;center:yes;help:no;dialogWidth:" +
            width +
            " px;dialogHeight:" +
            height +
            " px"
        );
    } else {
      if (callback) window.showModalDialogCallback = callback;
      var top = (window.screen.availHeight - 30 - height) / 2; //获得窗口的垂直位置;
      var left = (window.screen.availWidth - 10 - width) / 2; //获得窗口的水平位置;
      var winOption =
        "top=" +
        top +
        ",left=" +
        left +
        ",height=" +
        height +
        ",width=" +
        width +
        ",resizable=no,scrollbars=no,status=no,toolbar=no,location=no,directories=no,menubar=no,help=no";
      window.open(url, window, winOption);
    }
  },

  getExplorerVersion: function () {
    var explorer = window.navigator.userAgent,
      compare = function (s) {
        return explorer.indexOf(s) >= 0;
      },
      ie11 = (function () {
        return "ActiveXObject" in window;
      })();
    if (compare("MSIE") || ie11) {
      return "IE" + IEVersion();
    } else if (compare("Edge") && !ie11) {
      return "Edge";
    } else if (compare("Firefox") && !ie11) {
      return "Firefox";
    } else if (compare("Chrome") && !ie11) {
      return "Chrome";
    } else if (compare("Opera") && !ie11) {
      return "Opera";
    } else if (compare("Safari") && !ie11) {
      return "Safari";
    }

    function IEVersion() {
      // 取得浏览器的userAgent字符串
      var userAgent = navigator.userAgent;
      // 判断是否为小于IE11的浏览器
      var isLessIE11 =
        userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1;
      // 判断是否为IE的Edge浏览器
      var isEdge = userAgent.indexOf("Edge") > -1 && !isLessIE11;
      // 判断是否为IE11浏览器
      var isIE11 =
        userAgent.indexOf("Trident") > -1 && userAgent.indexOf("rv:11.0") > -1;
      if (isLessIE11) {
        var IEReg = new RegExp("MSIE (\\d+\\.\\d+);");
        // 正则表达式匹配浏览器的userAgent字符串中MSIE后的数字部分，，这一步不可省略！！！
        IEReg.test(userAgent);
        // 取正则表达式中第一个小括号里匹配到的值
        var IEVersionNum = parseFloat(RegExp["$1"]);
        if (IEVersionNum === 7) {
          // IE7
          return 7;
        } else if (IEVersionNum === 8) {
          // IE8
          return 8;
        } else if (IEVersionNum === 9) {
          // IE9
          return 9;
        } else if (IEVersionNum === 10) {
          // IE10
          return 10;
        } else {
          // IE版本<7
          return 6;
        }
      } else if (isEdge) {
        // edge
        return "edge";
      } else if (isIE11) {
        // IE11
        return 11;
      } else {
        // 不是ie浏览器
        return -1;
      }
    }
  },
};

/**
 * 手术麻醉信息系统通用对象
 * @author chenchangqing 20170809
 */
var dhcan = {
  /**
   * 手术麻醉业务类名称对象
   */
  bll: {
    /**
     * DHCAN.BLL.DataQuery
     */
    dataQuery: "DHCAN.BLL.DataQuery",
    /**
     * DHCAN.BLL.OperSchedule
     */
    operSchedule: "DHCAN.BLL.OperSchedule",
    /**
     * DHCAN.BLL.OperationList
     */
    operationList: "DHCAN.BLL.OperationList",
    /**
     * DHCAN.BLL.OperApplication
     */
    operApplication: "DHCAN.BLL.OperApplication",
    /**
     * DHCAN.BLL.OperArrange
     */
    operArrange: "DHCAN.BLL.OperArrange",
    /**
     * DHCAN.BLL.DataConfiguration
     */
    dataConfiguration: "DHCAN.BLL.DataConfiguration",
    /**
     * DHCAN.BLL.Operation
     */
    operation: "DHCAN.BLL.Operation",
    /**
     * DHCAN.BLL.DeptSchedule
     */
    deptSchedule: "DHCAN.BLL.DeptSchedule",
    /**
     * DHCAN.BLL.RecordPara
     */
    recordPara: "DHCAN.BLL.RecordPara",
    /**
     * DHCAN.BLL.AnaestRecord
     */
    anaestRecord: "DHCAN.BLL.AnaestRecord",
  },
  /**
   * 手术麻醉实体类名称对象
   */
  cls: {
    /**
     * DHCAN.OperSchedule
     */
    operSchedule: "DHCAN.OperSchedule",
    /**
     * DHCAN.OperationList
     */
    operationList: "DHCAN.OperationList",
    /**
     * DHCAN.DataConfiguration
     */
    dataConfiguration: "DHCAN.DataConfiguration",
    /**
     * DHCAN.SurgicalProcedure
     */
    surgicalProcedure: "DHCAN.SurgicalProcedure",
    /**
     * DHCAN.VitalSign
     */
    vitalSign: "DHCAN.VitalSign",
    /**
     * DHCAN.DrugItem
     */
    drugItem: "DHCAN.DrugItem",
    /**
     * DHCAN.EventDetailItem
     */
    eventDetail: "DHCAN.EventDetailItem",

    /**
     * DHCAN.EventItem
     */
    eventItem: "DHCAN.EventItem",
    /**
     * DHCAN.DeptSchedule
     */
    deptSchedule: "DHCAN.DeptSchedule",
    /**
     * DHCAN.ActionPermission
     */
    actionPermission: "DHCAN.ActionPermission",
    /**
     * DHCAN.RecordPara
     */
    recordPara: "DHCAN.RecordPara",
    /**
     * DHCAN.RecordParaItem
     */
    recordParaItem: "DHCAN.RecordParaItem",
    /**
     * DHCAN.TimeLine
     */
    timeLine: "DHCAN.TimeLine",
  },
  /**
   * 手术麻醉手术状态代码对象
   */
  status: {
    /**
     * 申请
     */
    application: "Application",
    /**
     * 审核
     */
    audit: "Audit",
    /**
     * 安排
     */
    arrange: "Arrange",
    /**
     * 取消
     */
    cancel: "Cancel",
    /**
     * 拒绝
     */
    decline: "Decline",
    /**
     * 撤消
     */
    revoke: "Revoke",
    /**
     * 术中
     */
    roomIn: "RoomIn",
    /**
     * 术毕
     */
    roomOut: "RoomOut",
    /**
     * 入室
     */
    areaIn: "AreaIn",
    /**
     * 离室
     */
    areaOut: "AreaOut",
    /**
     * 恢复
     */
    pacuIn: "PACUIn",
  },
  /**
   * 创建表单
   * @param {string} opsId
   * @param {moduleId} moduleId
   * @returns {object<Module.RecordSheet>}
   */
  createRecordSheet: function (opsId, moduleId) {
    var result = null;
    if (opsId && moduleId) {
      dhccl.saveDatas(ANCSP.DataService, {
        ClassName: ANCLS.Model.RecordSheet,
        OperSchedule: opsId,
        DataModule: moduleId,
        CreateUser: session.UserID,
        UpdateUser: session.UserID,
      });

      var data = dhccl.getDatas(
        ANCSP.DataQuery,
        {
          ClassName: ANCLS.BLL.DataQueries,
          QueryName: "FindRecordSheet",
          Arg1: opsId,
          Arg2: moduleId,
          ArgCnt: 2,
        },
        "json"
      );

      if (data.length > 1) result = data;
      else if (data.length == 1) result = data[0];
      else {
        $.messager.alert("严重错误！", "创建表单记录失败！", "icon-error");
      }
    }

    return result;
  },
};

/**
 * 常量
 */
var constant = {
  /**
   * 日期格式 yyyy-MM-dd
   */
  dateFormat: "yyyy-MM-dd",
  /**
   * 时间格式 HH:mm
   */
  timeFormat: "HH:mm",
  /**
   * 日期时间格式 yyyy-MM-dd HH:mm
   */
  dateTimeFormat: "yyyy-MM-dd HH:mm",
  /**
   * 时间戳格式 yyyy-MM-dd HH:mm:ss
   */
  timeStampFormat: "yyyy-MM-dd HH:mm:ss",
  /**
   * 成功标志
   */
  successFlag: "S^",
  /**
   * 失败标志
   */
  errorFlag: "E^",
  /**
   * 空字符串
   */
  empty: "",
};

// 处理IE下按退格键，页面直接返回前页的问题
function banBackSpace(e) {
  var event = e || window.event;
  var obj =
    event.relatedTarget ||
    event.srcElement ||
    event.target ||
    eval.currentTarget;
  if (event.keyCode == 8) {
    var tagName = obj.nodeName;
    if (tagName != "INPUT" && tagName != "TEXTAREA") {
      return stopIt(event);
    }
    var tagType = obj.type.toUpperCase();
    if (
      tagName == "INPUT" &&
      tagType != "TEXT" &&
      tagType != "TEXTAREA" &&
      tagType != "PASSWORD"
    ) {
      return stopIt(event);
    }

    if (
      (tagName == "INPUT" || tagName == "TEXTAREA") &&
      (obj.readOnly || obj.disabled)
    ) {
      return stopIt(event);
    }
  }
}

function stopIt(event) {
  if (event.preventDefault) event.preventDefault();
  if (event.returnValue) event.returnValue = false;
  return false;
}

//阻止BackSpace界面回退
document.onkeydown = banBackSpace;
document.onkeypress = banBackSpace;

/// jQuery扩展函数
(function ($) {
  /**
   * 表单转json对象
   */
  $.fn.serializeJson = function () {
    var serializeObj = {};
    $(this.serializeArray()).each(function () {
      serializeObj[this.name] = $.trim(this.value);
    });
    return serializeObj;
  };

  $.fn.datebox.defaults.formatter = function (date) {
    var y = date.getFullYear();
    var m = date.getMonth() + 1;
    var d = date.getDate();
    return y + "-" + (m < 10 ? "0" : "") + m + "-" + (d < 10 ? "0" : "") + d;
  };

  $.fn.datebox.defaults.parser = function (s) {
    return new Date().tryParse(s);
  };

  if (!$.fn.searchbox.methods.getText) {
    $.extend($.fn.searchbox.methods, {
      getText: function (jq) {
        var target = jq[0];
        var options = $(target).searchbox("options");
        var inputRect = $(target).siblings(".searchbox");
        var text = $(inputRect).find("input").val();
        if (text === options.prompt) {
          return "";
        } else {
          return text;
        }
      },
    });
  }
})(jQuery);
/*
$g=function(item){
	if (transArray.hasOwnProperty(item))
	return transArray[item];
	else return item;
	
	var ret=$cm({
		ClassName:"CIS.AN.COM.Html",
		MethodName:"Get",
		item:item,
		dataType:"text"
	},false);
	return ret;
};*/
// 扩展hisui-datagrid方法
$.extend($.fn.datagrid.methods, {
  // 按上下方向处理
  keyCtr: function (jq) {
    return jq.each(function () {
      var grid = $(this);
      grid
        .datagrid("getPanel")
        .panel("panel")
        .attr("tabindex", 1)
        .bind("keydown", function (e) {
          switch (e.keyCode) {
            case 38: // up
              var selected = grid.datagrid("getSelected");
              if (selected) {
                var index = grid.datagrid("getRowIndex", selected);
                grid.datagrid("selectRow", index - 1);
              } else {
                var rows = grid.datagrid("getRows");
                grid.datagrid("selectRow", rows.length - 1);
              }
              break;
            case 40: // down
              var selected = grid.datagrid("getSelected");
              if (selected) {
                var index = grid.datagrid("getRowIndex", selected);
                grid.datagrid("selectRow", index + 1);
              } else {
                grid.datagrid("selectRow", 0);
              }
              break;
          }
        });
    });
  },

  /**
   * 获取表格的列选项数组
   * @param {object} jq JQuery对象
   */
  getColumnOptList: function (jq) {
    var _this = jq[0];
    var columnFields = $(_this).datagrid("getColumnFields");
    var columnDatas = [];
    for (var i = 0; i < columnFields.length; i++) {
      const columnField = columnFields[i];
      var columnOpts = $(_this).datagrid("getColumnOption", columnField);
      columnDatas.push(columnOpts);
    }

    return columnDatas;
  },

  /**
   * 启用表格设置功能，启用后会在分页栏显示表格设置的图标
   * @param {object} jq JQuery对象
   * @param {object} params 参数
   */
  enableGridSetting: function (jq, params) {
    return jq.each(function () {
      var _this = this;
      var pager = $(this).datagrid("getPager");
      if (params == undefined) params = {};
      var columnOptList = $(this).datagrid("getColumnOptList");
      var datacolumnList = [];
      for (var i = 0; i < columnOptList.length; i++) {
        const columnOpt = columnOptList[i];
        datacolumnList.push({
          Field: columnOpt.field || "",
          Title: columnOpt.title || "",
          Width: columnOpt.width || "",
          Hidden: columnOpt.hidden || "",
          Frozen: false,
          Sortable: columnOpt.sortable || "",
          Order: columnOpt.order || "",
          Align: columnOpt.align || "",
          HAlign: columnOpt.halign || "",
          SeqNo: 10000 + i,
          Styler: "",
          Sorter: "",
          Formatter: "",
          // Editor:(columnOpt.editor?JSON.stringify(columnOpt.editor):"")
          Editor: "",
        });
      }
      pager.pagination({
        buttons: [
          {
            iconCls: "icon-show-set",
            plain: true,
            handler: function () {
              if (params.clickHandler) {
                params.clickHandler(datacolumnList);
              }
            },
          },
        ],
      });
    });
  },
});
//20210723
var AIS = {
  Action: function (dataParam, dataType) {
    var result = null;
    $.ajax({
      url: "../CIS.AN.BL.Request.cls",
      async: false,
      data: dataParam,
      type: "post",
      dataType: dataType || "text",
      success: function (data) {
        if (data instanceof Object || data instanceof Array) {
          result = data;
        } else {
          result = $.trim(data);
        }
      },
    });
    return result;
  },
};
