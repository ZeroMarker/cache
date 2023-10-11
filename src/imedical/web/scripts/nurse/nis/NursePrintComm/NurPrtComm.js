(function() {
  /**
   * @description: 封装LODOP打印方法
   * @param  {} LODOP: LODOP打印实例化
   * @param  {} type: 打印类型
   * @param  {} arg: 打印参数对象
   */
  function PRINT_ITEM(LODOP, type, arg) {
    var o = new Object();
    o.top = (Number(arg.top).toFixed(4) || 0) + "mm";
    o.left = (Number(arg.left).toFixed(4) || 0) + "mm";
    o.width = (Number(arg.width).toFixed(4) || 50) + "mm";
    o.height = (Number(arg.height).toFixed(4) || 50) + "mm";
    o.strContent = arg.strContent;
    o.angle = arg.angle || 0;
    switch (type) {
      case "text":
        o.fontFamily = arg.fontFamily || "黑体";
        o.fontSize = arg.fontSize || 10;
        o.fontStyle = arg.fontStyle || 0;
        o.fontWeight = arg.fontWeight || 0;
        o.align = arg.align || 1;
        o.PRINT_INSTANCE = function() {
          if (String(this.strContent).trim() !== "") {
            LODOP.ADD_PRINT_TEXT(
              this.top,
              this.left,
              this.width,
              this.height,
              this.strContent
            );
            LODOP.SET_PRINT_STYLEA(0, "TextNeatRow", true);
            LODOP.SET_PRINT_STYLEA(0, "FontName", this.fontFamily);
            LODOP.SET_PRINT_STYLEA(0, "FontSize", this.fontSize);
            LODOP.SET_PRINT_STYLEA(0, "LineSpacing", -2);
            LODOP.SET_PRINT_STYLEA(0, "LetterSpacing", -1);
            LODOP.SET_PRINT_STYLEA(0, "Italic", this.fontStyle);
            LODOP.SET_PRINT_STYLEA(0, "Alignment", this.align);
            LODOP.SET_PRINT_STYLEA(0, "Bold", this.fontWeight);
            LODOP.SET_PRINT_STYLEA(0, "Angle", this.angle);
          }
        };
        break;
      case "line":
        o.intLineStyle = arg.intLineStyle || 0;
        o.intLineWidth = arg.intLineWidth || 1;
        o.topDr = (Number(arg.topDr).toFixed(4) || 0) + "mm";
        o.leftDr = (Number(arg.leftDr).toFixed(4) || 0) + "mm";
        o.PRINT_INSTANCE = function() {
          LODOP.ADD_PRINT_LINE(
            this.top,
            this.left,
            this.topDr,
            this.leftDr,
            this.intLineStyle,
            this.intLineWidth
          );
        };
        break;
      case "QRCode":
        o.qrVersion = arg.qrVersion;
        o.PRINT_INSTANCE = function() {
          LODOP.ADD_PRINT_BARCODE(
            this.top,
            this.left,
            this.width,
            this.height,
            "QRCode",
            this.strContent
          );
          if (this.qrVersion !== "Auto") {
            LODOP.SET_PRINT_STYLEA(0, "QRCodeVersion", this.qrVersion);
          }
        };
        break;
      case "BarCode":
        o.codeType = arg.codeType;
        o.showText = arg.showText;
        o.PRINT_INSTANCE = function() {
          LODOP.ADD_PRINT_BARCODE(
            this.top,
            this.left,
            this.width,
            this.height,
            this.codeType,
            this.strContent
          );
          LODOP.SET_PRINT_STYLEA(0, "ShowBarText", this.showText);
          LODOP.SET_PRINT_STYLEA(0, "Angle", this.angle);
        };
        break;
      case "pic":
        o.PRINT_INSTANCE = function() {
          LODOP.ADD_PRINT_IMAGE(
            this.top,
            this.left,
            this.width,
            this.height,
            "<img border='0' src='" + this.strContent + "' />"
          );
        };
        break;
    }
    return o;
  }
  function Print_Lodop(LODOP, allPage) {
    allPage.forEach(function(singlePage, singlePageIndex) {
      singlePage.forEach(function(section) {
        Print_Content(LODOP, section);
      });
      if (allPage[singlePageIndex + 1]) {
        LODOP.NEWPAGE();
      }
    });
  }
  function Print_Content(LODOP, section) {
    var itemInstance;
    section.content.forEach(function(item) {
      itemInstance = new PRINT_ITEM(LODOP, item.type, item);
      itemInstance.PRINT_INSTANCE();
    });
  }
  function createAllPage(paraData, listData, coordinate, sectionFactory) {
    var a = [];
    var section;
    var originPoint = coordinate.length;
    var index = 0;
    if (listData.length > 0) {
      listData.forEach(function(item, index) {
        if (paraData[item.ID].$printNum) {
          for (var i = 0; i < paraData[item.ID].$printNum; i++) {
            section = new sectionFactory(
              paraData[item.ID],
              item,
              coordinate[index % originPoint].x,
              coordinate[index % originPoint].y
            );
            a.push(section);
            index += 1;
          }
        }
      });
    } else {
      paraData.forEach(function(item) {
        if (item.$printNum) {
          for (var i = 0; i < item.$printNum; i++) {
            section = new sectionFactory(
              item,
              [],
              coordinate[index % originPoint].x,
              coordinate[index % originPoint].y
            );
            a.push(section);
            index += 1;
          }
        }
      });
    }

    return splitChunk(a, originPoint);
  }
  /**
   * @description: 获取字数
   * @param  {String} text: 文本
   */
  function getChar(text) {
    var strLength = 0;
    text.split("").forEach(function(val) {
      strLength += val.charCodeAt(0) > 255 ? 1 : 0.5;
    });
    return strLength;
  }
  function getSum(arr) {
    var s = 0;
    for (var i = arr.length - 1; i >= 0; i--) {
      s += arr[i];
    }
    return s;
  }
  function getTextWidth(text, fontSize) {
    var textNum = getChar(text) + 1.5;
    return textNum * 0.3527 * fontSize;
  }
  function getTextHeight(text, fontSize) {
    return 0.3527 * fontSize * 1.5;
  }
  function getListLinage(text, fontSize, width) {
    var wordNum = getWordNumByWidth(width, fontSize);
    var strLength = text.length;
    var listLinage = 1;
    var lineIndex = 0;
    if (strLength <= wordNum) {
      listLinage = 1;
    } else {
      for (var i = 0; i < strLength; i++) {
        var splitStr = text.slice(i, i + 1);
        var charCodeflag = splitStr.charCodeAt(0) > 255 ? 1 : 0.5;
        if (lineIndex + charCodeflag <= wordNum) {
          lineIndex = lineIndex + charCodeflag;
        } else {
          lineIndex = charCodeflag;
          listLinage += 1;
        }
      }
    }
    return listLinage;
  }
  function getWordNumByWidth(width, fontSize) {
    var wordNum = width / (0.3527 * fontSize);
    var intege = Math.floor(wordNum);
    var decimal = wordNum - intege;
    return intege + (decimal > 0.5 ? 0.5 : 0);
  }
  /**
   * @description 把数组按照size分割成多维数组
   * @param {Array} arr: 待分割数组
   * @param {Number} size: 分割长度
   */
  function splitChunk(arr, size) {
    var retArr = [];
    for (var i = 0; i < arr.length; i = i + size) {
      retArr.push(arr.slice(i, i + size));
    }
    return retArr;
  }
  function main(formwork, inpara, inlist) {
    // LODOP实例化
    var LODOP = getLodop();
    // 获取打印机
    var PrtDevice = formwork.printDeviceName;
    var PrtDeviceIndex = -1; //设置默认打印机
    if (PrtDevice !== "") {
      PrtDevice = PrtDevice.toUpperCase();
      for (var j = 0; j < LODOP.GET_PRINTER_COUNT(); j++) {
        if (
          LODOP.GET_PRINTER_NAME(j)
            .toUpperCase()
            .indexOf(PrtDevice) > -1
        ) {
          PrtDeviceIndex = j;
          break;
        }
      }
    }
    // 获取列表项行数
    var listRows = formwork.listData.listRows;
    // 文本项数据处理，数组的每一项为每一组医嘱瓶贴的文本项内容
    var paraData = [];
    inpara.split(String.fromCharCode(4)).forEach(function(chunk) {
      var obj = {};
      chunk.split(String.fromCharCode(3)).forEach(function(item) {
        var detail = item.split(String.fromCharCode(2));
        obj[detail[0]] = detail[1];
      });
      paraData.push(obj);
    });
    // 列表项数据处理
    var listData = [];
    if (
      inlist !== "" &&
      formwork.listData &&
      Array.isArray(formwork.listData.content) &&
      formwork.listData.content.length > 0
    ) {
      inlist.split(String.fromCharCode(4)).forEach(function(chunk, index) {
        var obj = {};
        obj.ID = index;
        var cur = 1;
        // 根据列表项配置行数、子医嘱+主医嘱数 判断一组医嘱瓶贴是否需要分多页打印
        // 如分页打印，则多页列表项ID相同，对应同一文本项index
        var sum = Math.ceil(chunk.split("^").length / listRows);
        chunk.split("^").forEach(function(lump) {
          lump.split(String.fromCharCode(3)).forEach(function(item) {
            var detail = item.split(String.fromCharCode(2));
            if (obj[detail[0]]) {
              if (obj[detail[0]].length === listRows) {
                listData.push(obj);
                obj = {};
                obj.ID = index;
                // 需要分页打印的列表项，插入分页标识
                if (!obj.delimiter && sum > 1) {
                  cur += 1;
                  obj.delimiter = cur + "-" + sum;
                }
                obj[detail[0]] = [detail[1]];
              } else {
                obj[detail[0]].push(detail[1]);
              }
            } else {
              // 需要分页打印的列表项，插入分页标识
              if (!obj.delimiter && sum > 1) {
                obj.delimiter = cur + "-" + sum;
              }
              obj[detail[0]] = [detail[1]];
            }
          });
        });
        listData.push(obj);
      });
    }
    // console.log(paraData);
    // console.log(listData);
    // debugger;
    function SectionInpara(paraItem, listItem, originPointX, originPointY) {
      var paraContent = [];
      var printText;
      formwork.txtData.forEach(function(item) {
        printText =
          item.codeStr !== ""
            ? item.codeStr === "delimiter"
              ? listItem[item.codeStr]
                ? listItem[item.codeStr]
                : ""
              : paraItem[item.codeStr]
            : item.defaultValue;
        paraContent.push({
		  top: originPointY + Number(item.positionY),
          left: originPointX + Number(item.positionX),
          topDr: originPointY + (Number(item.endY) || 0),
          leftDr: originPointX + (Number(item.endX) || 0),
          width:
            item.width === ""
              ? getTextWidth(printText, item.fontSize)
              : item.width,
          height:
            item.height === ""
              ? getTextHeight(printText, item.fontSize)
              : item.height,
          fontSize: item.fontSize,
          fontFamily: item.fontFamily,
          fontWeight: item.fontWeight,
          strContent: printText,
          qrVersion: item.qrVersion || "Auto",
          codeType: item.codeType || "",
          angle: item.angle || 0,
          showText: item.showText === undefined ? 1 : item.showText,
          type: item.type
        });
      });
      var listLinageDic = {};
      Object.keys(listItem).forEach(function(key) {
        if (key !== "ID" && key !== "delimiter" && listItem[key]) {
          for (var i = 0; i < listItem[key].length; i++) {
            var itemFormwork = formwork.listData.content.find(function(item) {
              return item.codeStr === key;
            });
            if (itemFormwork) {
              var listLinage = getListLinage(
                listItem[key][i],
                itemFormwork.fontSize,
                itemFormwork.width
              );
              if (listLinageDic[i]) {
                listLinageDic[i] =
                  listLinage > listLinageDic[i] ? listLinage : listLinageDic[i];
              } else {
                listLinageDic[i] = listLinage;
              }
            }
          }
        }
      });
      var listPositionY = [0];
      for (var listIndex in listLinageDic) {
        var currentLinage = listPositionY[listPositionY.length - 1];
        listPositionY.push(listLinageDic[listIndex] + currentLinage);
      }
      Object.keys(listItem).forEach(function(key) {
        if (key !== "ID" && key !== "delimiter" && listItem[key]) {
          for (var i = 0; i < listItem[key].length; i++) {
            var itemFormwork = formwork.listData.content.find(function(item) {
              return item.codeStr === key;
            });
            // var listLinage = getListLinage(
            //   listItem[key][i],
            //   itemFormwork.fontSize,
            //   itemFormwork.width
            // );
            // var currentLinage = getSum(listPositionY);
            // listPositionY.push(listLinage + currentLinage);
            if (itemFormwork) {
              paraContent.push({
                top:
                  originPointY +
                  itemFormwork.positionY +
                  listPositionY[i] * itemFormwork.height,
                left: originPointX + itemFormwork.positionX,
                width: itemFormwork.width,
                height: listPositionY[i + 1] * itemFormwork.height,
                fontSize: itemFormwork.fontSize,
                fontFamily: itemFormwork.fontFamily,
                fontWeight: itemFormwork.fontWeight,
                strContent: listItem[key][i],
                qrVersion: itemFormwork.qrVersion || "Auto",
                codeType: itemFormwork.codeType || "",
                angle: itemFormwork.angle || 0,
                showText: !itemFormwork.showText ? 1 : itemFormwork.showText,
                type: itemFormwork.type
              });
            }
          }
        }
      });
      this.content = paraContent;
      this.$printNum = paraItem["$printNum"]
        ? parseInt(paraItem["$printNum"])
        : 1;
      this.height = formwork.tempHeight;
      this.width = formwork.tempWidth;
    }
    var allPage = createAllPage(
      paraData,
      listData,
      formwork.coordinate,
      SectionInpara
    );
    // console.log(allPage);
    // debugger;
    // 初始化
    LODOP.PRINT_INIT(formwork.codeName);
    // 设置打印机
    LODOP.SET_PRINTER_INDEX(PrtDeviceIndex);
    // 设置打印纸张
    if (formwork.printDirection === 2) {
      LODOP.SET_PRINT_PAGESIZE(
        formwork.printDirection,
        formwork.paperHeight + "mm",
        formwork.paperWidth + "mm",
        formwork.paperName
      );
    } else {
      LODOP.SET_PRINT_PAGESIZE(
        formwork.printDirection,
        formwork.paperWidth + "mm",
        formwork.paperHeight + "mm",
        formwork.paperName
      );
    }

    LODOP.SET_PRINT_STYLE("FontSize", 10);
    Print_Lodop(LODOP, allPage);
    if (LODOP.CVERSION) {
      // 打印的回调返回值
      CLODOP.On_Return = function(TaskID, Value) {
        if (Number(Value) || formwork.printView === 2) {
          printResult.msg = "成功";
          printResult.statusCode = 1;
        } else {
          if (formwork.printView === 1) {
            // 预览不置打印标记
            printResult.statusCode = 2;
            printResult.msg = "预览未打印";
          } else {
            printResult.msg = "失败";
            printResult.statusCode = 0;
          }
        }
      };
      if (formwork.printView === 1) {
        LODOP.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1);
        LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1); //横向打印预览时的正向显示
        LODOP.PREVIEW();
      } else if (formwork.printView === 2) {
        LODOP.PRINT_DESIGN();
      } else {
        LODOP.PRINT();
      }
    } else {
      // IE
      if (formwork.printView === 1) {
        LODOP.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1);
        LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1); //横向打印预览时的正向显示
        LODOP.PREVIEW();

        printResult.statusCode = 1;
        printResult.msg = "成功";
      } else if (formwork.printView === 2) {
        LODOP.PRINT_DESIGN();
        printResult.statusCode = 1;
        printResult.msg = "成功";
      } else {
        if (LODOP.PRINT()) {
          printResult.msg = "成功";
          printResult.statusCode = 1;
        } else {
          printResult.msg = "失败";
          printResult.statusCode = 0;
        }
      }
    }
  }
  function NurPrtComm(_ref, utils, sheetID, parrStr) {
    var ajax = _ref.ajax;
    var orderExcuteApi = _ref.orderExcuteApi;
    var axios = _ref.axios;
    ajax(orderExcuteApi.getFormWork, sheetID).then(function(formwork) {
      // 每5组医嘱并发请求
      var chunks = splitChunk(parrStr, 5);
      var paraDataArr = [];
      var listDataArr = [];
      var promiseArray = chunks.map(function(chunk, index) {
        return ajax(orderExcuteApi.getPrintData, sheetID, chunk.join("@"))
          .then(function(paraDataResult) {
            paraDataArr[index] = paraDataResult.replace(/[\r\n]/g, "");
            return ajax(
              orderExcuteApi.getPrintData,
              sheetID,
              chunk.join("@"),
              "list"
            );
          })
          .then(function(listDataResult) {
            listDataArr[index] = listDataResult.replace(/[\r\n]/g, "");
          });
      });
      axios.all(promiseArray).then(function() {
        if (formwork.printView === "Y") {
          // 预览打印，合并为一个打印任务（Lodop暂不支持多个任务的预览）
          main(
            formwork,
            paraDataArr.join(String.fromCharCode(4)),
            listDataArr.join(String.fromCharCode(4))
          );
        } else {
          // 直接打印，每5组医嘱拆分为一个打印任务
          paraDataArr.forEach(function(paraData, index) {
            main(formwork, paraData, listDataArr[index]);
          });
        }
      });
    });
  }
  // 打印状态
  var printResult = {
    statusCode: 0
  };
  // 打印状态获取
  function getNurPrtCommResult() {
    return printResult;
  }
  function resetNurPrtCommResult() {
    printResult.statusCode = 0;
  }
  window.NurPrtCommOutSide = main;
  window.NurPrtComm = NurPrtComm;
  window.getNurPrtCommResult = getNurPrtCommResult;
  window.resetNurPrtCommResult = resetNurPrtCommResult;
})();
