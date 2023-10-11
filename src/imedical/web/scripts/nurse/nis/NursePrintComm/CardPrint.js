(function() {
  function PRINT_ITEM(LODOP, arg) {
    var o = new Object();
    o.top = (Number(arg.top).toFixed(4) || 0) + "mm";
    o.left = (Number(arg.left).toFixed(4) || 0) + "mm";
    o.width = arg.width === "100%" ? "100%" : (Number(arg.width) || 0) + "mm";
    o.height = (Number(arg.height).toFixed(4) || 0) + "mm";
    o.topDr = (Number(arg.topDr).toFixed(4) || 0) + "mm";
    o.leftDr = (Number(arg.leftDr).toFixed(4) || 0) + "mm";
    o.intLineStyle = arg.intLineStyle || 0;
    o.intLineWidth = arg.intLineWidth || 1;
    o.strContent = arg.strContent;
    o.align = arg.align || 1;
    o.fontFamily = arg.fontFamily || "黑体";
    o.fontSize = arg.fontSize || 10;
    o.fontStyle = arg.fontStyle || 0;
    o.fontWeight = arg.fontWeight || 0;
    o.PRINT_LINE = function() {
      LODOP.ADD_PRINT_LINE(
        this.top,
        this.left,
        this.topDr,
        this.leftDr,
        this.intLineStyle,
        this.intLineWidth
      );
    };
    o.PRINT_TEXT = function() {
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
      }
    };
    return o;
  }
  function Print_Table(LODOP, instance) {
    var itemInstance;
    instance.content.forEach(function(item) {
      if (Array.isArray(item.text)) {
        if (item.showExec) {
          item.text.forEach(function(itemText, textIndex) {
            itemInstance = new PRINT_ITEM(LODOP, {
              top:
                instance.y +
                item.y +
                (textIndex * (instance.rowNum * instance.rowHeight)) /
                  item.text.length,
              left: instance.x + item.x,
              width: item.width,
              height: instance.rowHeight,
              strContent: itemText,
              fontFamily: item.fontFamily,
              fontSize: item.fontSize,
              fontStyle: item.fontStyle,
              fontWeight: item.fontWeight,
              align: item.textAlign
            });
            itemInstance.PRINT_TEXT();
            itemInstance = new PRINT_ITEM(LODOP, {
              top:
                instance.y +
                ((textIndex + 1) * (instance.rowNum * instance.rowHeight)) /
                  item.text.length,
              left: instance.x + item.x,
              topDr:
                instance.y +
                ((textIndex + 1) * (instance.rowNum * instance.rowHeight)) /
                  item.text.length,
              leftDr: instance.x + item.x + item.width
            });
            itemInstance.PRINT_LINE();
          });
        } else {
          item.text.forEach(function(itemText, textIndex) {
            itemInstance = new PRINT_ITEM(LODOP, {
              top: instance.y + item.y + textIndex * instance.rowHeight,
              left: instance.x + item.x,
              width: item.width,
              height: instance.rowHeight,
              strContent: itemText,
              fontFamily: item.fontFamily,
              fontSize: item.fontSize,
              fontStyle: item.fontStyle,
              fontWeight: item.fontWeight,
              align: item.textAlign
            });
            itemInstance.PRINT_TEXT();
          });
        }
      } else if (typeof item.text === "number" && item.text > 1) {
        for (var i = 1; i <= item.text; i++) {
          itemInstance = new PRINT_ITEM(LODOP, {
            top:
              instance.y +
              ((instance.rowHeight * instance.rowNum) / item.text) * i,
            left: instance.x + item.x,
            topDr:
              instance.y +
              ((instance.rowHeight * instance.rowNum) / item.text) * i,
            leftDr: instance.x + item.x + item.width
          });
          itemInstance.PRINT_LINE();
        }
      }
    });
    itemInstance = new PRINT_ITEM(LODOP, {
      top: instance.y + instance.rowHeight * instance.rowNum,
      left: instance.x,
      topDr: instance.y + instance.rowHeight * instance.rowNum,
      leftDr: instance.x + instance.width
    });
    itemInstance.PRINT_LINE();
  }
  function Print_Content(LODOP, card, originPoint, lineFormFactory) {
    var lineForm = new lineFormFactory(originPoint.x, originPoint.y);
    var itemInstance;
    lineForm.line.forEach(function(item) {
      itemInstance = new PRINT_ITEM(LODOP, {
        top: originPoint.y + item.startY,
        left: originPoint.x + item.startX,
        topDr: originPoint.y + item.endY,
        leftDr: originPoint.x + item.endX
      });
      itemInstance.PRINT_LINE();
    });
    card.forEach(function(cardItem) {
      if (cardItem.printType === "TEXT") {
        cardItem.content.forEach(function(item) {
          if (Array.isArray(item.text)) {
            item.text.forEach(function(textItem) {
              itemInstance = new PRINT_ITEM(LODOP, {
                top: item.y + textItem.top,
                left: item.x + textItem.left,
                width: item.width,
                height: item.height,
                strContent: textItem.text,
                fontFamily: item.fontFamily,
                fontSize: item.fontSize,
                fontStyle: item.fontStyle,
                fontWeight: item.fontWeight,
                align: item.textAlign
              });
              itemInstance.PRINT_TEXT();
            });
          } else {
            itemInstance = new PRINT_ITEM(LODOP, {
              top: item.y,
              left: item.x,
              width: item.width,
              height: item.height,
              strContent: item.text,
              fontFamily: item.fontFamily,
              fontSize: item.fontSize,
              fontStyle: item.fontStyle,
              fontWeight: item.fontWeight,
              align: item.textAlign
            });
            itemInstance.PRINT_TEXT();
          }
        });
      } else if (cardItem.printType === "TABLE") {
        Print_Table(LODOP, cardItem);
      } else if (cardItem.printType === "LINE") {
        for (var i = cardItem.stratNum; i < cardItem.lineNum; i++) {
          itemInstance = new PRINT_ITEM(LODOP, {
            top: cardItem.y + i * cardItem.rowHeight,
            left: cardItem.x,
            topDr: cardItem.y + i * cardItem.rowHeight,
            leftDr: cardItem.x + cardItem.width
          });
          itemInstance.PRINT_LINE();
        }
      }
    });
  }
  function Print_Lodop(LODOP, allPage, coordinate, lineFormFactory) {
    allPage.forEach(function(singlePage, singlePageIndex) {
      singlePage.forEach(function(singleCard, index) {
        Print_Content(LODOP, singleCard, coordinate[index], lineFormFactory);
      });
      if (allPage[singlePageIndex + 1]) {
        LODOP.NEWPAGE();
      }
    });
  }
  /**
   * @description: 返回需要打印的数据的多维数组
   * @param  {Array} sortList: 主医嘱-医嘱ID
   * @param  {Object} orderData: 医嘱数据
   * @param  {Array} coordinate: 每个输液卡原点坐标
   * @param  {Object} printForm: 打印格式
   * @param  {Function} cardInfoFactory:
   * @param  {Function} orderInfoFactory
   * @param  {Function} splitLineFactory
   */
  function createAllPage(
    sortList,
    orderData,
    coordinate,
    printForm,
    cardInfoFactory,
    orderInfoFactory,
    splitLineFactory
  ) {
    var allCard = [];
    // var newCard = true;
    var episodeID = "";
    var cardNum = 0;
    var originPoint = coordinate.length;
    var cardInfo;
    var orderInfo;
    var currentLineNum = 0;
    var orderDataItem;
    var rowHeight = printForm["ORDERINFO"].height;
    var lineNum = printForm["ORDERINFO"].rowNum - 1;
    var splitLine;
    var curID;
    var sttDateLogic;
    var curSttDateLogic;
    allCard._pageType = 0;
    sortList.forEach(function(id, index) {
      orderDataItem = orderData[id];
      sttDateLogic = orderDataItem.execInfos[0].$sttDateLogic;
      // if (index === 0) {
      //   allCard._pageType = 1;
      // } else {
      if (episodeID !== orderDataItem.episodeID) {
        // 不是同一个病人换页
        if (index !== 0) {
          cardNum += 1;
          currentLineNum = 0;
          episodeID = "";
        }
        allCard._pageType = 1;
      } else {
        // 是同一个病人
        if (sttDateLogic !== curSttDateLogic) {
          cardNum += 1;
          currentLineNum = 0;
          episodeID = "";
          allCard._pageType = 1;
        } else {
          if (curID === orderData[id].ID) {
            // 同一条医嘱的执行记录
            var lastPageItem = allCard[cardNum][allCard[cardNum].length - 1];
            if (lastPageItem.execRowNum + 1 > lastPageItem.orderRowNum) {
              if (currentLineNum + 1 <= lineNum) {
                // 不换页
                lastPageItem.rowNum += 1;
                currentLineNum += 1;
                allCard[cardNum][1].stratNum += 1;
                allCard._pageType = 3;
              } else {
                // 换页
                cardNum += 1;
                currentLineNum = 0;
                episodeID = "";
                allCard._pageType = 1;
              }
            } else {
              // 执行记录合并到上一条医嘱
              allCard._pageType = 3;
            }
          } else {
            // 非同一条医嘱
            if (currentLineNum + orderData[id].rowNum <= lineNum) {
              allCard._pageType = 4;
            } else {
              cardNum += 1;
              currentLineNum = 0;
              episodeID = "";
              allCard._pageType = 1;
            }
          }
        }
      }
      // }
      if (allCard._pageType === 1) {
        allCard[cardNum] = [];
        cardInfo = new cardInfoFactory(
          orderDataItem.episodeID,
          coordinate[cardNum % originPoint].x,
          coordinate[cardNum % originPoint].y,
          orderDataItem
        );
        allCard[cardNum].push(cardInfo);
        splitLine = new splitLineFactory(
          coordinate[cardNum % originPoint].x,
          coordinate[cardNum % originPoint].y
        );
        allCard[cardNum].push(splitLine);
        orderInfo = new orderInfoFactory(
          orderDataItem,
          orderDataItem.rowNum,
          orderDataItem.orderRowNum,
          orderDataItem.execRowNum,
          coordinate[cardNum % originPoint].x,
          coordinate[cardNum % originPoint].y
        );
        allCard[cardNum][1].stratNum += orderData[id].rowNum;
        allCard[cardNum].push(orderInfo);
        currentLineNum += orderData[id].rowNum;
        episodeID = orderDataItem.episodeID;
        curID = orderDataItem.ID;
        curSttDateLogic = orderDataItem.execInfos[0].$sttDateLogic;
      } else if (allCard._pageType === 3) {
        // 不换页
        orderInfo = new orderInfoFactory(
          orderDataItem,
          orderDataItem.rowNum,
          orderDataItem.orderRowNum,
          orderDataItem.execRowNum,
          coordinate[cardNum % originPoint].x,
          coordinate[cardNum % originPoint].y
        );
        lastPageItem.execRowNum += 1;
        orderInfo.content.forEach(function(execItem, execIndex) {
          if (execItem.showExec) {
            if (execItem.codeStr === "") {
              lastPageItem.content[execIndex].text += 1;
            } else {
              lastPageItem.content[execIndex].text.push(execItem.text[0]);
            }
          }
        });
      } else if (allCard._pageType === 4) {
        orderInfo = new orderInfoFactory(
          orderDataItem,
          orderDataItem.rowNum,
          orderDataItem.orderRowNum,
          orderDataItem.execRowNum,
          coordinate[cardNum % originPoint].x,
          coordinate[cardNum % originPoint].y
        );
        allCard[cardNum][1].stratNum += orderData[id].rowNum;
        orderInfo.y += rowHeight * currentLineNum;
        allCard[cardNum].push(orderInfo);
        currentLineNum += orderData[id].rowNum;
        episodeID = orderDataItem.episodeID;
        curID = orderDataItem.ID;
        curSttDateLogic = orderDataItem.execInfos[0].$sttDateLogic;
      }
    });
    return splitChunk(allCard, originPoint);
  }
  /**
   * @description: 返回医嘱信息对象或执行记录信息对象
   * @param  {String} id: 医嘱ID或执行记录ID
   * @param  {Object} orderDataObj: 医嘱数据
   */
  function initOrderInfo(id, orderDataObj) {
    var o = {};
    // 替换find兼容ie
    for (var i = 0; i < orderDataObj.length; i++) {
      if (orderDataObj[i].ID) {
        var item = orderDataObj[i];
        if (id.split("||").length === 3 && item.ID === id) {
          // 执行记录
          o = item.execInfo;
          break;
        } else if (id.split("||").length === 2 && getID(item.ID) === id) {
          // 医嘱
          for (var key in item) {
            if (typeof item[key] !== "object") {
              o[key] = item[key];
            }
          }
          o.ID = getID(item.ID);
          break;
        }
      }
    }
    return o;
  }
  function objectAssign(targetObj, sourceObj) {
    for (var sourceKey in sourceObj) {
      // if (sourceObj[sourceKey]) {
      targetObj[sourceKey] = sourceObj[sourceKey];
      // }
    }
  }
  /**
   * @description: 创建以主医嘱-医嘱ID为key的对象
   * childs属性为子医嘱-医嘱ID的数组
   * execInfos属性为主医嘱-执行记录ID的数组
   * @param  {Array} oeoriSeqIDs: 主医嘱-医嘱ID
   * @param  {Array} oeoriIDs: 主子医嘱-医嘱ID
   * @param  {Array} oeoreIDs: 主子医嘱-执行记录ID
   */
  function getOrders(oeoreSeqIDs, oeoreIDs) {
    var o = {};
    oeoreSeqIDs.forEach(function(item, index) {
      var oeoreSeqID = getID(item);
      if (o[item]) {
        var childsOeoriID = getID(oeoreIDs[index]);
        if (
          o[item].childs.indexOf(childsOeoriID) === -1 &&
          childsOeoriID !== oeoreSeqID
        ) {
          o[item].childs.push(childsOeoriID);
        }
      } else {
        o[item] = { childs: [], execInfos: [item] };
      }
    });
    return function(orderDataObj) {
      for (var id in o) {
        objectAssign(o[id], initOrderInfo(getID(id), orderDataObj));
        o[id].childs.forEach(function(childId, index) {
          var childInfoDetail = initOrderInfo(childId, orderDataObj);
          o[id].childs[index] = childInfoDetail;
        });
        o[id].execInfos.forEach(function(execInfoId, index) {
          var execInfoDetail = initOrderInfo(execInfoId, orderDataObj);
          o[id].execInfos[index] = execInfoDetail;
        });
        o[id].orderRowNum = o[id].childs.length + 1;
        o[id].execRowNum = o[id].execInfos.length;
        // 计算每组医嘱所占行数
        o[id].rowNum =
          o[id].childs.length + 1 >= o[id].execInfos.length
            ? o[id].childs.length + 1
            : o[id].execInfos.length;
      }
      return o;
    };
  }
  /**
   * @description: 获取字数
   * @param  {String} text: 文本
   */
  function getChar(text) {
    var char = 0;
    text.split("").forEach(function(val) {
      char += val.charCodeAt(0) > 255 ? 1 : 0.5;
    });
    return char;
  }
  function getSplitStr(text, len) {
    var delimiter = String.fromCharCode(13);
    let strLength = text.length;
    let lineIndex = 0;
    let str = "";
    if (strLength <= len) {
      str = text;
    } else {
      for (let i = 0; i < strLength; i++) {
        let splitStr = text.slice(i, i + 1);
        let charCodeflag = splitStr.charCodeAt(0) > 255 ? 1 : 0.5;
        if (lineIndex + charCodeflag <= len) {
          lineIndex = lineIndex + charCodeflag;
          str = str + splitStr;
        } else {
          lineIndex = charCodeflag;
          str = str + delimiter + splitStr;
        }
      }
    }
    return str.split(delimiter);
  }
  /**
   * @description: 计算表头文字格式
   * @param  {String} text: 文字
   * @param  {Number} fontSize: 字号
   * @param  {Number} wordNum: 横向可容纳文字数
   * @param  {Number} width: 单元格宽度
   * @param  {Number} height: 单元格高度
   */
  function getTableHeadLayout(text, fontSize, wordNum, width, height) {
    // console.log(text, fontSize, wordNum, width, height);
    var a = [];
    // 按单元格宽度分割文字
    var splitStrList = getSplitStr(text, wordNum);
    // 磅转为mm后计算行高
    var lineHeight = fontSize * 0.3527 * splitStrList.length;
    splitStrList.forEach(function(item, index) {
      a.push({
        top: index * fontSize * 0.3527 + (height - lineHeight) / 2,
        left: (width - getChar(item) * fontSize * 0.3527) / 2,
        text: item
      });
    });
    return a;
  }
  /**
   * @description: 数组去重
   * @param  {Array} arr: 数据
   */
  function unique(arr) {
    var array = [];
    for (var i = 0; i < arr.length; i++) {
      if (array.indexOf(arr[i]) === -1) {
        array.push(arr[i]);
      }
    }
    return array;
  }
  /**
   * @description: 获取医嘱ID
   * @param  {String} IDStr: 执行记录ID
   */
  function getID(IDStr) {
    var oeordId = IDStr.split("||")[0];
    var oeordSub = IDStr.split("||")[1];
    return oeordId + "||" + oeordSub;
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
  function CardPrint(
    _ref,
    utils,
    oeoreIDStr,
    oeoreSeqIDStr,
    episodeIDStr,
    sheetID,
    printUser,
    printRange
  ) {
    var ajax = _ref.ajax;
    var axios = _ref.axios;
    var orderExcuteApi = _ref.orderExcuteApi;
    // 获取打印配置
    var getBasicPrintSetting = new Promise(function(resolve) {
      ajax(orderExcuteApi.getCardPrintSetting, sheetID).then(function(result) {
        resolve(result);
      });
    });
    // 获取打印格式配置
    var getPrintForm = new Promise(function(resolve) {
      ajax(orderExcuteApi.getCardPrintForm, sheetID).then(function(result) {
        resolve(result);
      });
    });
    // 获取勾选打印的所有患者的数据
    var episodeIDChunks = splitChunk(episodeIDStr.split("^"), 5);
    var patData = {};
    var promiseArray = episodeIDChunks.map(function(chunk) {
      return ajax(
        orderExcuteApi.getCardPrintData,
        chunk.join("^"),
        sheetID,
        "PAT"
      )
        .then(function(ret) {
          ret.forEach(function(patInfoObj) {
            patInfoObj["printUser"] = printUser;
            patInfoObj["printRange"] = printRange;
            patData[patInfoObj["episodeID"]] = patInfoObj;
          });
        })
        .catch(function(err) {
          printResult.statusCode = -3;
          printResult.msg = "获取患者信息失败" + " " + err;
        });
    });
    // 主子医嘱-执行记录ID
    var oeoreIDs = oeoreIDStr.split("^");
    var oeoreIDIndex = oeoreIDs.map(function(oeoreID, index) {
      return index;
    });
    var orderPrintData = [];
    var oeoreIDChunks = utils.splitChunk([], 5, oeoreIDs, oeoreIDIndex);
    oeoreIDChunks.forEach(function(chunk) {
      var ajaxRequest = ajax(
        orderExcuteApi.getCardPrintData,
        chunk[0].join("^"),
        sheetID,
        "ORDER"
      )
        .then(function(ret) {
          if (Array.isArray(ret)) {
            orderPrintData = orderPrintData.concat(ret);
          } else {
            printResult.statusCode = -4;
            printResult.msg = "获取医嘱信息失败";
          }
        })
        .catch(function(err) {
          printResult.statusCode = -4;
          printResult.msg = "获取医嘱信息失败" + " " + err;
        });
      promiseArray.push(ajaxRequest);
    });
    axios.all(promiseArray).then(function() {
      Promise.all([getBasicPrintSetting, getPrintForm]).then(function(
        promiseResult
      ) {
        var basicPrintSetting = promiseResult[0];
        if (typeof basicPrintSetting !== "object") {
          printResult.statusCode = -1;
          printResult.msg = "获取打印配置失败";
        }
        var printForm = promiseResult[1];
        if (typeof printForm !== "object") {
          printResult.statusCode = -2;
          printResult.msg = "获取打印格式失败";
        }
        main(
          episodeIDStr,
          oeoreSeqIDStr,
          oeoreIDStr,
          basicPrintSetting,
          printForm,
          patData,
          orderPrintData
        );
      });
    });
  }
  function main(
    episodeIDStr,
    oeoreSeqIDStr,
    oeoreIDStr,
    basicPrintSetting,
    printForm,
    patData,
    orderPrintData
  ) {
    // 主医嘱-执行记录ID
    var oeoreSeqIDs = oeoreSeqIDStr.split("^");
    // 主子医嘱-执行记录ID
    var oeoreIDs = oeoreIDStr.split("^");
    // 主子医嘱-医嘱ID
    // var oeoriIDs = oeoreIDs.map(function(item) {
    //   return getID(item);
    // });
    // 主医嘱-医嘱ID
    // var oeoriSeqIDs = oeoreSeqIDs.map(function(item) {
    //   return getID(item);
    // });
    // LODOP实例化
    var LODOP = getLodop();
    // 获取打印机
    var PrtDevice = basicPrintSetting.printDeviceName;
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
    var printPaper = {};
    // 纸张名称
    printPaper.name = basicPrintSetting.paperName;
    // 纸张名称
    printPaper.name = basicPrintSetting.paperName;
    // 纸张宽度
    printPaper.width = parseInt(basicPrintSetting.paperWidth, 10) || 210;
    // 纸张高度
    printPaper.height = parseInt(basicPrintSetting.paperHeight, 10) || 297;
    // 纸张边距
    printPaper.margin = parseInt(basicPrintSetting.paperMargin, 10) || 0;
    // 纸张可用宽度
    printPaper.availableWidth =
      printPaper.width - parseInt(printPaper.margin, 10) * 2;
    // 纸张可用高度
    printPaper.availableHeight =
      printPaper.height - parseInt(printPaper.margin, 10) * 2;
    // 每个输液卡原点坐标
    var coordinate = basicPrintSetting.coordinate;
    // 处理医嘱数据
    var func = getOrders(oeoreSeqIDs, oeoreIDs);
    var orderData = func(orderPrintData);
    console.log(orderData);
    debugger;
    var sortList = [];
    var sortObj = {};
    unique(oeoreSeqIDs).forEach(function(item) {
      var filterOrder = orderPrintData.find(function(orderItem) {
        return orderItem.ID === item;
      });
      var episodeID = filterOrder["episodeID"];
      var sttDateLogic = filterOrder.execInfo["$sttDateLogic"];
      if (!sortObj[episodeID]) {
        sortObj[episodeID] = {};
      }
      if (!sortObj[episodeID][sttDateLogic]) {
        sortObj[episodeID][sttDateLogic] = [];
      }
      sortObj[episodeID][sttDateLogic].push(item);
    });
    episodeIDStr.split("^").forEach(function(episodeID) {
      if (sortObj[episodeID]) {
        for (var propKey in sortObj[episodeID]) {
          sortList = sortList.concat(sortObj[episodeID][propKey]);
        }
      }
    });
    // for (var episodeIDKey in sortObj) {
    //   for (var dateLogicKey in sortObj[episodeIDKey]) {
    //     sortList = sortList.concat(sortObj[episodeIDKey][dateLogicKey]);
    //   }
    // }
    console.log(sortList);
    debugger;
    // 输液卡划线
    function LineForm() {
      var a = printForm.horizenLine.concat(printForm.verticalLine);
      this.line = a;
    }
    // 除医嘱外打印数据
    function CardInfo(episodeID, originPointX, originPointY, orderData) {
      var a = [];
      var printText;
      for (var key in printForm.contentForm) {
        if (parseInt(key) !== printForm["ORDERINFO"].ID) {
          if (Array.isArray(printForm.contentForm[key])) {
            printForm.contentForm[key].forEach(function(item) {
              if (item.codeStr === "printSttDate") {
                printText = orderData.execInfos[0]["printSttDate"];
              } else {
                printText =
                  item.printContent +
                  (item.codeStr === "" ? "" : patData[episodeID][item.codeStr]);
              }

              a.push({
                x: originPointX + item.marginLeft,
                y: originPointY + item.marginTop,
                width: item.width,
                height: item.height,
                fontSize: item.fontSize,
                fontFamily: item.fontFamily,
                fontStyle: item.fontStyle,
                fontWeight: item.fontWeight,
                textAlign: item.textAlign,
                text: printText
              });
            });
          }
        } else {
          if (Array.isArray(printForm.contentForm[key])) {
            // 表头
            var tableHeadLayout;
            printForm.contentForm[key].forEach(function(item) {
              tableHeadLayout = getTableHeadLayout(
                item.printContent,
                item.fontSize,
                item.wordNum,
                item.width,
                item.height
              );
              a.push({
                x: originPointX + item.marginLeft,
                y: originPointY + item.marginTop,
                width: item.width * 1.1,
                height: item.height,
                fontSize: item.fontSize,
                fontFamily: item.fontFamily,
                fontStyle: item.fontStyle,
                fontWeight: item.fontWeight,
                textAlign: 1, // 医嘱表头内容左对齐
                text: tableHeadLayout
              });
            });
          }
        }
      }
      this.printType = "TEXT";
      this.top = originPointY;
      this.left = originPointX;
      this.content = a;
    }
    // 医嘱打印数据
    function OrderForm(
      obj,
      num,
      orderNum,
      execNum,
      originPointX,
      originPointY
    ) {
      var a = [];
      var printText;
      printForm.contentForm[printForm["ORDERINFO"].ID].forEach(function(item) {
        if (item.codeStr === "") {
          printText = obj["execInfos"].length;
        } else {
          if (item.execInfo === "Y") {
            printText = obj["execInfos"].map(function(execInfosItem) {
              return execInfosItem[item.codeStr];
            });
          } else {
            printText = [obj[item.codeStr]];
            if (obj["childs"].length > 0 && item.multiply === "Y") {
              obj["childs"].forEach(function(childItem) {
                printText.push(childItem[item.codeStr]);
              });
            }
          }
        }
        a.push({
          codeStr: item.codeStr,
          y: 0.3, // 优化医嘱表格内容垂直方向显示
          x: item.marginLeft + (parseInt(item.textAlign) === 1 ? 0.3 : 0), // 优化医嘱表格左对齐内容水平方向显示
          width: item.width,
          fontSize: item.fontSize,
          fontFamily: item.fontFamily,
          fontStyle: item.fontStyle,
          fontWeight: item.fontWeight,
          textAlign: item.textAlign,
          text: printText,
          showExec: item.execInfo === "Y" ? true : false
        });
      });
      this.content = a;
      this.width = printForm.contentWidth;
      this.orderRowNum = orderNum;
      this.execRowNum = execNum;
      this.rowNum = num;
      this.rowHeight = printForm["ORDERINFO"].height;
      this.x = originPointX;
      this.y =
        originPointY +
        printForm["ORDERINFO"].top +
        printForm["ORDERINFO"].height;
      this.printType = "TABLE";
    }
    // 医嘱表格空余划线（横线）
    function SplitLine(originPointX, originPointY) {
      this.rowHeight = printForm["ORDERINFO"].height;
      this.x = originPointX;
      this.y =
        originPointY +
        printForm["ORDERINFO"].top +
        printForm["ORDERINFO"].height;
      this.stratNum = 1;
      this.lineNum = printForm["ORDERINFO"].rowNum - 1;
      this.width = printForm.contentWidth;
      this.printType = "LINE";
    }
    // 将需要打印的数据按格式处理为多维数组
    var allPage = createAllPage(
      sortList,
      orderData,
      coordinate,
      printForm,
      CardInfo,
      OrderForm,
      SplitLine
    );
    console.log(allPage);
    debugger;
    // 打印
    // 初始化
    LODOP.PRINT_INIT(basicPrintSetting.codeName);
    // 设置打印机
    LODOP.SET_PRINTER_INDEX(PrtDeviceIndex);
    // 设置打印纸张
    LODOP.SET_PRINT_PAGESIZE(
      1,
      printPaper.width + "mm",
      printPaper.height + "mm",
      printPaper.name
    );
    //设置初始字体(单位：pt)
    LODOP.SET_PRINT_STYLE("FontSize", 10);
    Print_Lodop(LODOP, allPage, coordinate, LineForm);
    printResult.statusCode = 3;
    printResult.msg = "调用LODOP打印";
    if (LODOP.CVERSION) {
      CLODOP.On_Return = function(TaskID, Value) {
        if (Number(Value)) {
          printResult.statusCode = 1;
          printResult.msg = "成功";
        } else {
          if (basicPrintSetting.printView === "Y") {
            // 预览不置打印标记
            printResult.statusCode = 2;
            printResult.msg = "预览未打印";
          } else {
            printResult.statusCode = 0;
            printResult.msg = "失败";
          }
        }
      };
      if (basicPrintSetting.printView === "Y") {
        LODOP.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1);
        LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1); //横向时的正向显示
        LODOP.PREVIEW();
      } else {
        LODOP.PRINT();
        // LODOP.PRINT_DESIGN();
      }
    } else {
      // IE
      if (basicPrintSetting.printView === "Y") {
        LODOP.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1);
        LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1); //横向时的正向显示
        LODOP.PREVIEW();
        printResult.statusCode = 1;
        printResult.msg = "打印成功";
      } else {
        if (LODOP.PRINT()) {
          printResult.statusCode = 1;
          printResult.msg = "打印成功";
        } else {
          printResult.statusCode = 0;
          printResult.msg = "打印失败";
        }
      }
    }
  }
  var printResult = {
    statusCode: 0
  };
  function getCardPrintResult() {
    return printResult;
  }
  function resetCardPrintResult() {
    printResult.statusCode = 0;
  }
  window.CardPrintOutSide = main;
  window.CardPrint = CardPrint;
  window.getCardPrintResult = getCardPrintResult;
  window.resetCardPrintResult = resetCardPrintResult;
})();
