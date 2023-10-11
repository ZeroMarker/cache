(function() {
  /**
   * @description: 封装LODOP打印方法
   * @param  {} LODOP: LODOP打印实例化
   * @param  {Object} arg: 打印参数对象
   */
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
    // 打印线
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
    // 打印文字
    o.PRINT_TEXT = function() {
      if (this.strContent.trim() !== "") {
        LODOP.ADD_PRINT_TEXT(
          this.top,
          this.left,
          this.width,
          this.height,
          this.strContent
        );
        LODOP.SET_PRINT_STYLEA(0, "TextNeatRow", true); //允许标点溢出，且英文单词拆开。
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
  /**
   * @description: 表格内容打印
   * @param  {} LODOP
   * @param  {Object} instance: 元素内容
   * @param  {Object} printConfig: 打印基本设置
   * @param  {Number} coordinate: 原点x坐标
   */
  function Print_Table(LODOP, instance, printConfig, coordinate) {
    // 实例化
    var itemInstance;
    var contentTop = [];
    var sum = 0;
    // 计算整组数据的纵轴相对位置
    instance.contentTop.forEach(function(num) {
      sum += num;
      contentTop.push(sum);
    });
    instance.content.forEach(function(item, index) {
      item.forEach(function(inst) {
        if (Array.isArray(inst.text)) {
          // 数组类型
          inst.text.forEach(function(instText, textIndex) {
            if (inst.showExec) {
              // 按执行记录打印
              itemInstance = new PRINT_ITEM(LODOP, {
                top:
                  inst.top +
                  instance.top +
                  contentTop[index] +
                  (instance.contentTop[index + 1] / inst.text.length) *
                    textIndex,
                left: coordinate + instance.left + inst.left,
                width: inst.width,
                height: inst.rowHeight,
                strContent: instText,
                fontFamily: inst.fontFamily,
                fontSize: inst.fontSize,
                fontStyle: inst.fontStyle,
                fontWeight: item.fontWeight,
                align: inst.textAlign
              });
              itemInstance.PRINT_TEXT();
              if (
                inst.text.length > 1 &&
                textIndex !== 0 &&
                printConfig.printType === 2 &&
                inst.partCell === "Y"
              ) {
                // 按执行记录打印单元格内划线
                itemInstance = new PRINT_ITEM(LODOP, {
                  top:
                    instance.top +
                    contentTop[index] +
                    (instance.contentTop[index + 1] / inst.text.length) *
                      textIndex,
                  left: coordinate + instance.left + inst.tableLeft,
                  topDr:
                    instance.top +
                    contentTop[index] +
                    (instance.contentTop[index + 1] / inst.text.length) *
                      textIndex,
                  leftDr:
                    coordinate +
                    instance.left +
                    inst.tableLeft +
                    inst.tableWidth
                });
                itemInstance.PRINT_LINE();
              }
            } else {
              itemInstance = new PRINT_ITEM(LODOP, {
                top:
                  inst.top +
                  instance.top +
                  contentTop[index] +
                  instance.itemContentTop[index][textIndex],
                left: coordinate + instance.left + inst.left,
                width: inst.width,
                height: inst.rowHeight,
                strContent: instText,
                fontFamily: inst.fontFamily,
                fontSize: inst.fontSize,
                fontStyle: inst.fontStyle,
                fontWeight: item.fontWeight,
                align: inst.textAlign
              });
              itemInstance.PRINT_TEXT();
            }
          });
        } else if (
          inst.showExec &&
          inst.codeStr === "" &&
          typeof inst.text === "number" &&
          inst.text > 1 &&
          inst.partCell === "Y"
        ) {
          // 数字类型
          // 单元格内划线
          if (printConfig.printType === 2) {
            for (var i = 1; i <= inst.text; i++) {
              itemInstance = new PRINT_ITEM(LODOP, {
                top:
                  instance.top +
                  contentTop[index] +
                  (instance.contentTop[index + 1] / inst.text) * i,
                left: coordinate + instance.left + inst.tableLeft,
                topDr:
                  instance.top +
                  contentTop[index] +
                  (instance.contentTop[index + 1] / inst.text) * i,
                leftDr:
                  coordinate + instance.left + inst.tableLeft + inst.tableWidth
              });
              itemInstance.PRINT_LINE();
            }
          }
        }
      });
      // 循环横线
      if (index !== instance.content.length - 1) {
        item.forEach(function(inst) {
          if (!inst.mergeCell) {
            itemInstance = new PRINT_ITEM(LODOP, {
              top: instance.top + contentTop[index + 1],
              left: coordinate + instance.left + inst.tableLeft,
              topDr: instance.top + contentTop[index + 1],
              leftDr:
                coordinate + instance.left + inst.tableLeft + inst.tableWidth
            });
            itemInstance.PRINT_LINE();
          }
        });
      }
    });
    // 循环竖线
    instance.tableContent.forEach(function(item, index) {
      if (index !== 0) {
        itemInstance = new PRINT_ITEM(LODOP, {
          top: instance.top,
          left: coordinate + instance.left + item.left,
          topDr: instance.top + instance.height,
          leftDr: coordinate + instance.left + item.left
        });
        itemInstance.PRINT_LINE();
      }
    });
    // 左竖线
    itemInstance = new PRINT_ITEM(LODOP, {
      top: instance.top,
      left: coordinate + instance.left,
      topDr: instance.top + instance.height,
      leftDr: coordinate + instance.left
    });
    itemInstance.PRINT_LINE();
    // 右竖线
    itemInstance = new PRINT_ITEM(LODOP, {
      top: instance.top,
      left: coordinate + instance.left + instance.width,
      topDr: instance.top + instance.height,
      leftDr: coordinate + instance.left + instance.width
    });
    itemInstance.PRINT_LINE();
    // 下横线
    itemInstance = new PRINT_ITEM(LODOP, {
      top: instance.top + instance.height,
      left: coordinate + instance.left,
      topDr: instance.top + instance.height,
      leftDr: coordinate + instance.left + instance.width
    });
    itemInstance.PRINT_LINE();
  }
  /**
   * @description: 按元素类型打印内容
   * @param  {} LODOP
   * @param  {Object} instance: 元素内容
   * @param  {Object} printConfig: 打印基本设置
   * @param  {Number} coordinate: 原点x坐标
   */
  function Print_Content(LODOP, instance, printConfig, coordinate) {
    // 实例化
    var itemInstance;
    // 表格外文字
    if (
      instance.type === "HEADER" ||
      instance.type === "FOOTER" ||
      instance.type === "UPCONTENT" ||
      instance.type === "DOWNCONTENT"
    ) {
      instance.content.forEach(function(item) {
        itemInstance = new PRINT_ITEM(LODOP, {
          top: instance.top + item.top,
          left: coordinate + instance.left + item.left,
          width: item.width,
          height: instance.height,
          strContent: item.text,
          fontFamily: item.fontFamily,
          fontSize: item.fontSize,
          fontStyle: item.fontStyle,
          fontWeight: item.fontWeight,
          align: item.textAlign
        });
        itemInstance.PRINT_TEXT();
      });
    } else if (instance.type === "TABLEHEAD") {
      // 表头
      //
      // 表头划线-上横线
      itemInstance = new PRINT_ITEM(LODOP, {
        top: instance.top,
        left: coordinate + instance.left,
        topDr: instance.top,
        leftDr: coordinate + instance.left + instance.width
      });
      itemInstance.PRINT_LINE();
      // 表头划线-下横线
      itemInstance = new PRINT_ITEM(LODOP, {
        top: instance.top + instance.height,
        left: coordinate + instance.left,
        topDr: instance.top + instance.height,
        leftDr: coordinate + instance.left + instance.width
      });
      itemInstance.PRINT_LINE();
      // 表头划线-右竖线
      itemInstance = new PRINT_ITEM(LODOP, {
        top: instance.top,
        left: coordinate + instance.left + instance.width,
        topDr: instance.top + instance.height,
        leftDr: coordinate + instance.left + instance.width
      });
      itemInstance.PRINT_LINE();

      instance.content.forEach(function(item) {
        // 表头文字
        item.text.forEach(function(textItem) {
          itemInstance = new PRINT_ITEM(LODOP, {
            top: instance.top + item.top + textItem.top,
            left: coordinate + instance.left + item.left + textItem.left,
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
        // 表头划线
        itemInstance = new PRINT_ITEM(LODOP, {
          top: instance.top,
          left: coordinate + instance.left + item.left,
          topDr: instance.top + instance.height,
          leftDr: coordinate + instance.left + item.left
        });
        itemInstance.PRINT_LINE();
      });
    } else if (instance.type === "TABLEBODY") {
      Print_Table(LODOP, instance, printConfig, coordinate);
    }
  }
  /**
   * @description: 打印(双联)
   * @param  {} LODOP
   * @param  {Array} allPage: 打印内容，子项为单页打印内容
   * @param  {Object} printConfig: 打印基本设置
   * @param  {Array} coordinate: 原点x坐标
   */
  function PrintDuplex_Lodop(LODOP, allPage, printConfig, coordinate) {
    // 实例化
    allPage.forEach(function(singlePage, singleIndex) {
      singlePage.forEach(function(monoItem, monoIndex) {
        monoItem.forEach(function(item) {
          Print_Content(LODOP, item, printConfig, coordinate[monoIndex % 2]);
        });
      });
      if (allPage[singleIndex + 1]) {
        LODOP.NEWPAGE();
      }
    });
  }
  /**
   * @description: 打印(非双联)
   * @param  {} LODOP
   * @param  {Array} allPage: 打印内容，子项为单页打印内容
   * @param  {Object} printConfig: 打印基本设置
   */
  function Print_Lodop(LODOP, allPage, printConfig) {
    allPage.forEach(function(page, index) {
      page.forEach(function(item) {
        Print_Content(LODOP, item, printConfig, 0);
      });
      if (allPage[index + 1]) {
        LODOP.NEWPAGE();
      }
    });
  }
  /**
   * @description: 根据纸张高度按页划分打印内容
   * @param  {Array} sortList: 排序后医嘱ID、排序后执行记录ID
   * @param  {Object} patData: 患者信息
   * @param  {Object} orderData: 医嘱信息
   * @param  {Object} printConfig: 打印基本设置
   * @param  {Object} printPaper: 纸张配置
   * @param  {Object} printForm: 打印模板
   * @param  {Function} Section: 表格外文字对象的构造函数
   * @param  {Function} TableHead: 表头对象的构造函数
   * @param  {Function} TableBody: 表格对象的构造函数
   */
  function createAllPage(
    sortList,
    patData,
    orderData,
    printConfig,
    printPaper,
    printForm,
    Section,
    TableHead,
    TableBody
  ) {
    var allPage = [];
    allPage._newPage = true;
    allPage._firstPage = true;
    allPage._pageHeight = 0;
    allPage._pageNum = 0;
    allPage._curEpisodeID = "";
    allPage._curID = "";
    allPage._pageType = 0;
    var availableHeight;
    if (printPaper.type !== "C") {
      // 普通纸张
      availableHeight =
        printPaper.availableHeight -
        (printForm["HEADER"].sectionHeight +
          printForm["FOOTER"].sectionHeight +
          printForm["DOWNCONTENT"].sectionHeight);
    } else {
      availableHeight =
        printPaper.availableHeight - printForm["DOWNCONTENT"].sectionHeight;
    }
    var ID;
    var header;
    var upContent;
    var tableHead;
    var tableBody;
    var downContent;
    var episodeID;
    var lastPageItem;
    var additionHeight;
    var orderDataItem;
    var sttDateLogic;
    var curSttDateLogic;
    var no;
    sortList.forEach(function(item) {
      orderDataItem = orderData[item];
      episodeID = orderDataItem["episodeID"];
      ID = orderDataItem.ID;
      if (printConfig.dateFeed === "Y") {
        sttDateLogic = orderDataItem.execInfos[0].$sttDate;
      }
      if (allPage._newPage) {
        allPage._pageType = 1;
      } else {
        if (allPage._curEpisodeID !== episodeID) {
          // 不是同一个患者
          if (printConfig.singleFeed === "N") {
            if (
              printConfig.dateFeed === "Y" &&
              printConfig.isOrdType === "N" &&
              sttDateLogic !== curSttDateLogic
            ) {
              // 换页
              allPage._pageNum += 1;
              allPage._pageType = 1;
            } else {
              if (printConfig.printMode === "P") {
                // 按个人打印
                additionHeight =
                  allPage._pageHeight +
                  printForm["DOWNCONTENT"].sectionHeight +
                  printForm["UPCONTENT"].sectionHeight +
                  printForm["ORDERINFO"].sectionHeight +
                  printConfig.rowHeight * orderDataItem.rowNum;
              } else {
                // 按病区打印
                additionHeight =
                  allPage._pageHeight +
                  printConfig.rowHeight * orderDataItem.rowNum;
              }
              if (additionHeight <= availableHeight) {
                // 不换页
                allPage._pageType = 2;
              } else {
                // 换页
                allPage._pageNum += 1;
                allPage._pageType = 1;
              }
            }
          } else {
            // 单人换页
            allPage._pageNum += 1;
            allPage._pageType = 1;
          }
        } else {
          // 是同一个患者
          if (
            printConfig.dateFeed === "Y" &&
            printConfig.isOrdType === "N" &&
            sttDateLogic !== curSttDateLogic
          ) {
            // 换页
            allPage._pageNum += 1;
            allPage._pageType = 1;
          } else {
            if (printConfig.printType === 2 && allPage._curID === ID) {
              // 同一条医嘱，不同执行记录
              additionHeight = allPage._pageHeight + printConfig.rowHeight * 2;
            } else {
              // 非同一条医嘱
              additionHeight =
                allPage._pageHeight +
                printConfig.rowHeight * orderDataItem.rowNum;
            }
            if (additionHeight <= availableHeight) {
              // 不换页
              if (printConfig.printType === 2 && allPage._curID === ID) {
                // 合并执行记录
                allPage._pageType = 3;
              } else {
                // 合并表格
                allPage._pageType = 4;
              }
            } else {
              // 换页
              allPage._pageNum += 1;
              allPage._pageType = 1;
            }
          }
        }
      }
      if (allPage._pageType === 1) {
        allPage[allPage._pageNum] = [];
        allPage._pageHeight = 0;
        no = 1;
        // 页眉
        if (printPaper.type !== "C") {
          header = new Section(printForm["HEADER"], patData[episodeID]);
          allPage[allPage._pageNum].push(header);
          allPage._pageHeight = header.top + header.height;
        }
        // 表格上文字
        upContent = new Section(printForm["UPCONTENT"], patData[episodeID]);
        upContent.top += allPage._pageHeight;
        allPage[allPage._pageNum].push(upContent);
        // 表头
        tableHead = new TableHead(printForm["ORDERINFO"]);
        tableHead.top += upContent.top + upContent.height;
        allPage[allPage._pageNum].push(tableHead);
        // 医嘱信息
        tableBody = new TableBody(
          printForm["ORDERINFO"],
          orderDataItem,
          false,
          no
        );
        tableBody.top = tableHead.top + tableHead.height;
        allPage[allPage._pageNum].push(tableBody);
        allPage._newPage = false;
        allPage._curEpisodeID = episodeID;
        allPage._pageHeight = tableBody.top + tableBody.height;
        allPage._curID = ID;
        allPage._firstPage = false;
        no += 1;
      } else if (allPage._pageType === 2) {
        if (printConfig.printMode === "P") {
          // 上一个表格的表格下文字
          downContent = new Section(
            printForm["DOWNCONTENT"],
            patData[episodeID]
          );
          downContent.top += allPage._pageHeight;
          allPage[allPage._pageNum].push(downContent);
          // 表格上文字
          upContent = new Section(printForm["UPCONTENT"], patData[episodeID]);
          upContent.top += downContent.top + downContent.height;
          allPage[allPage._pageNum].push(upContent);
          // 表头
          tableHead = new TableHead(printForm["ORDERINFO"]);
          tableHead.top += upContent.top + upContent.height;
          allPage[allPage._pageNum].push(tableHead);
          allPage._pageHeight = tableHead.top + tableHead.height;
        }
        no = 1;
        tableBody = new TableBody(
          printForm["ORDERINFO"],
          orderDataItem,
          false,
          no
        );
        tableBody.top = allPage._pageHeight;
        allPage[allPage._pageNum].push(tableBody);
        allPage._newPage = false;
        allPage._curEpisodeID = episodeID;
        allPage._pageHeight = tableBody.top + tableBody.height;
        allPage._curID = ID;
        no += 1;
      } else if (allPage._pageType === 3) {
        tableBody = new TableBody(
          printForm["ORDERINFO"],
          orderDataItem,
          true,
          no
        );
        var curExecTimes = 0;
        lastPageItem =
          allPage[allPage._pageNum][allPage[allPage._pageNum].length - 1];
        tableBody.content[0].forEach(function(execItem, execIndex) {
          if (execItem.showExec) {
            if (execItem.codeStr === "") {
              lastPageItem.content[lastPageItem.content.length - 1][
                execIndex
              ].text += 1;
              curExecTimes =
                lastPageItem.content[lastPageItem.content.length - 1][execIndex]
                  .text;
            } else {
              curExecTimes =
                lastPageItem.content[lastPageItem.content.length - 1][execIndex]
                  .text.length;
              lastPageItem.content[lastPageItem.content.length - 1][
                execIndex
              ].text.push(execItem.text[0]);
            }
          }
        });

        if (
          (curExecTimes + 1) * 2 * printConfig.rowHeight >
          lastPageItem.contentTop.slice(-1)[0]
        ) {
          var contentTop = lastPageItem.contentTop.pop();
          lastPageItem.contentTop.push(contentTop + 2 * printConfig.rowHeight);
          lastPageItem.height += 2 * printConfig.rowHeight;
          allPage._pageHeight += 2 * printConfig.rowHeight;
        }
        allPage._curID = ID;
      } else if (allPage._pageType === 4) {
        tableBody = new TableBody(
          printForm["ORDERINFO"],
          orderDataItem,
          true,
          no
        );
        lastPageItem =
          allPage[allPage._pageNum][allPage[allPage._pageNum].length - 1];
        lastPageItem.content.push(tableBody.content[0]);
        lastPageItem.height += tableBody.height;
        lastPageItem.contentTop.push(
          orderDataItem.rowNum * printConfig.rowHeight
        );
        lastPageItem.itemContentTop.push(tableBody.itemContentTop[0]);
        allPage._pageHeight += printConfig.rowHeight * orderDataItem.rowNum;
        allPage._curID = ID;
        no += 1;
      }
      if (printConfig.dateFeed === "Y") {
        curSttDateLogic = orderDataItem.execInfos[0].$sttDate;
      }
    });
    // 页脚、表格下文字
    var footer;

    allPage.forEach(function(page, index) {
      downContent = new Section(printForm["DOWNCONTENT"], patData[episodeID]);
      downContent.top +=
        page[page.length - 1].top + page[page.length - 1].height;
      page.push(downContent);
      patData[episodeID].current = index + 1;
      patData[episodeID].total = allPage.length;
      if (printPaper.type !== "C") {
        // 普通纸张
        footer = new Section(printForm["FOOTER"], patData[episodeID]);
        footer.top =
          printPaper.availableHeight - printForm["FOOTER"].sectionHeight;
        page.push(footer);
      }
    });
    return allPage;
  }
  /**
   * @description: 按日期合并要求执行时间
   * @param  {Array} targetArr
   */
  function reduceItemByDay(targetArr) {
    var a = new Array();
    var s;
    var sttDatePrint;
    var arr = targetArr.concat();
    arr.push("");
    s = "";
    arr.reduce(function(total, curItem) {
      if (total) {
        if (curItem) {
          if (curItem["$sttDate"] === total["$sttDate"]) {
            s += " " + curItem["$sttTimePrint"];
          } else {
            a.push(s);
            s = "";
            sttDatePrint = curItem["$sttDatePrint"];
            s +=
              sttDatePrint +
              " " +
              (curItem["$sttTimePrint"] ? curItem["$sttTimePrint"] : "");
          }
        } else {
          a.push(s);
        }
      } else {
        sttDatePrint = curItem["$sttDatePrint"];
        s +=
          sttDatePrint +
          " " +
          (curItem["$sttTimePrint"] ? curItem["$sttTimePrint"] : "");
      }
      return curItem;
    }, "");
    return a;
  }
  /**
   * @description: 按执行记录格式初始化数据
   * @param  {Array} oeoreSeqIDs: 主医嘱-执行记录ID
   * @param  {Array} oeoreIDs: 主子医嘱-执行记录ID
   */
  function initDataByExec(oeoreSeqIDs, oeoreIDs) {
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
    return o;
  }
  /**
   * @description: 按医嘱格式初始化数据
   * @param  {Array} oeoriSeqIDs: 主医嘱-医嘱ID
   * @param  {Array} oeoriIDs: 主子医嘱-医嘱ID
   * @param  {Array} oeoreIDs: 主子医嘱-执行记录ID
   */
  function initDataByOrder(oeoriSeqIDs, oeoriIDs, oeoreIDs, isOrdType) {
    var o = {};
    oeoriSeqIDs.forEach(function(item, index) {
      if (o[item]) {
        if (
          o[item].childs.indexOf(oeoriIDs[index]) === -1 &&
          item !== oeoriIDs[index]
        ) {
          o[item].childs.push(oeoriIDs[index]);
        }
      } else {
        o[item] = { childs: [] };
        if (isOrdType !== "Y") {
          o[item].execInfos = [];
        }
      }
    });
    if (isOrdType !== "Y") {
      oeoreIDs.forEach(function(item) {
        for (var Id in o) {
          if (Id === getID(item)) {
            if (o[Id].execInfos.indexOf(item) === -1) {
              o[Id].execInfos.push(item);
            }
          }
        }
      });
    }
    return o;
  }
  /**
   * @description: 合并对象(Object.assign)
   * @param  {Object} targetObj: 目标对象
   * @param  {Object} sourceObj:  源对象
   */
  function objectAssign(targetObj, sourceObj) {
    for (var sourceKey in sourceObj) {
      // if (sourceObj[sourceKey]) {
      targetObj[sourceKey] = sourceObj[sourceKey];
      // }
    }
  }
  /**
   * @description: 初始化打印数据
   * @param  {Array} oeoriSeqIDs: 主医嘱-医嘱ID
   * @param  {Array} oeoreSeqIDs: 主医嘱-执行记录ID
   * @param  {Array} oeoriIDs: 主子医嘱-医嘱ID
   * @param  {Array} oeoreIDs: 主子医嘱-执行记录ID
   * @param  {Object} printType: 打印类型
   */
  function getOrders(
    oeoriSeqIDs,
    oeoreSeqIDs,
    oeoriIDs,
    oeoreIDs,
    printType,
    isOrdType,
    dateFeed
  ) {
    var o = {};
    if (isOrdType === "Y") {
      o = initDataByOrder(oeoriSeqIDs, oeoriIDs, oeoreIDs, "Y");
    } else {
      if (dateFeed === "Y") {
        o = initDataByExec(oeoreSeqIDs, oeoreIDs);
      } else {
        if (printType === 1) {
          o = initDataByOrder(oeoriSeqIDs, oeoriIDs, oeoreIDs, "N");
        } else {
          o = initDataByExec(oeoreSeqIDs, oeoreIDs);
        }
      }
    }

    return function(orderDataObj) {
      for (var id in o) {
        objectAssign(o[id], initOrderInfo(getID(id), orderDataObj));
        o[id].childs.forEach(function(childId, index) {
          var childInfoDetail = initOrderInfo(childId, orderDataObj);
          o[id].childs[index] = childInfoDetail;
        });
        if (o[id].execInfos) {
          o[id].execInfos.forEach(function(execInfoId, index) {
            var execInfoDetail = initOrderInfo(execInfoId, orderDataObj);
            o[id].execInfos[index] = execInfoDetail;
          });
        }
        if (printType === 1) {
          // 医嘱打印日期模式
          var dayNum = [];
          o[id].execInfos.forEach(function(item) {
            if (dayNum.indexOf(item["$sttDatePrint"]) === -1) {
              dayNum.push(item["$sttDatePrint"]);
            }
          });
          o[id].rowNum =
            o[id].childs.length + 1 >= dayNum.length * 2
              ? o[id].childs.length + 1
              : dayNum.length * 2;
        } else {
          // 执行记录拆开打印
          // 医嘱打印执行时间模式
          o[id].rowNum =
            o[id].childs.length + 1 > 2 ? o[id].childs.length + 1 : 2;
        }
      }

      return o;
    };
  }
  /**
   * @description: 初始化数据
   * @param  {String} id: 医嘱ID或执行记录ID
   * @param  {Array} orderDataObj: 全部医嘱数据
   */
  function initOrderInfo(id, orderDataObj) {
    var o = {};
    // 替换find兼容ie
    for (var i = 0; i < orderDataObj.length; i++) {
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
    return o;
  }
  /**
   * @description: 获取字符长度
   * @param  {String} text
   */
  function getChar(text) {
    var textLength = text.length;
    var char = 0;
    for (var i = 0; i < textLength; i++) {
      char += text.charCodeAt(i) > 255 ? 1 : 0.5;
    }
    return char;
  }
  /**
   * @description: 按字数截断字符串并返回数组
   * @param  {String} text: 字符串
   * @param  {Number} len: 字数(unicode>255的字数为1，其他为0.5)
   */
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
   * @param  {Number} wordNum: 单元格横向容纳文字数
   * @param  {Number} width: 单元格宽度
   * @param  {Number} height: 单元格高度
   */
  function getTableHeadLayout(text, fontSize, wordNum, width, height) {
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
   * @param {Array} arr			  	待分割数组
   * @param {Number} size			分割长度
   */
  function splitChunk(arr, size) {
    var retArr = [];
    for (var i = 0; i < arr.length; i = i + size) {
      retArr.push(arr.slice(i, i + size));
    }
    return retArr;
  }
  /**
   * @description vue中调用执行单打印入口
   * @param  {} _ref: 前后端交互对象
   * @param  {} utils: 工具类
   * @param  {String} oeoreIDStr: 主医嘱执行记录ID串
   * @param  {String} oeoreSeqIDStr: 主子医嘱执行记录ID 串
   * @param  {String} episodeIDStr: 就诊号字符串
   * @param  {String} sheetID: 模板ID
   * @param  {String} printUser: 打印人
   * @param  {String} printRange: 打印所选的时间范围(格式2022-05-20 00:00~2022-05-20 23:59)
   */
  function SheetPrint(
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
      ajax(orderExcuteApi.getSheetPrintSetting, sheetID).then(function(result) {
        resolve(result);
      });
    });
    // 获取打印格式配置
    var getPrintForm = new Promise(function(resolve) {
      ajax(orderExcuteApi.getSheetPrintForm, sheetID).then(function(result) {
        resolve(result);
      });
    });
    // 获取勾选打印的所有患者的数据
    var episodeIDChunks = splitChunk(episodeIDStr.split("^"), 5);
    var patData = {};
    var promiseArray = episodeIDChunks.map(function(chunk) {
      return ajax(
        orderExcuteApi.getSheetPrintData,
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
    // 获取所以执行记录的数据
    var oeoreIDs = oeoreIDStr.split("^");
    var oeoreIDIndex = oeoreIDs.map(function(oeoreID, index) {
      return index;
    });
    var orderPrintData = [];
    var oeoreIDChunks = utils.splitChunk([], 5, oeoreIDs, oeoreIDIndex);
    oeoreIDChunks.forEach(function(chunk) {
      var ajaxRequest = ajax(
        orderExcuteApi.getSheetPrintData,
        chunk[0].join("^"),
        sheetID,
        "ORDER"
      )
        .then(function(ret) {
          if (Array.isArray(ret)) {
            ret.forEach(function(retItem) {
              for (var key in retItem) {
                if (
                  String(key)
                    .toUpperCase()
                    .indexOf("ARCIMDESC") > -1
                ) {
                  //  后缀
                  if (retItem["$suffix"] !== "") {
                    retItem[key] = retItem[key] + " " + retItem["$suffix"];
                  }
                  // 前缀
                  if (retItem["$prefix"] !== "") {
                    retItem[key] = retItem["$prefix"] + " " + retItem[key];
                  }
                }
              }
            });
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
    // 并发所有请求
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
        // console.log(basicPrintSetting);
        // console.log(printForm);
        // console.log(patData);
        // console.log(orderPrintData);
        // 调用打印主程序方法
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
  /**
   * @description: 打印主程序方法入口、非vue调用打印方法入口
   * @param  {String} oeoreSeqIDStr: 主医嘱执行记录ID串
   * @param  {String} oeoreIDStr: 主子医嘱执行记录ID 串
   * @param  {Object} basicPrintSetting: 打印基本设置
   * @param  {Object} printForm: 打印模板
   * @param  {Object} patData: 患者数据
   * @param  {Array} orderPrintData: 执行记录数据
   */
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
    var oeoriIDs = oeoreIDs.map(function(item) {
      return getID(item);
    });
    // 主医嘱-医嘱ID
    var oeoriSeqIDs = oeoreSeqIDs.map(function(item) {
      return getID(item);
    });
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
    // 纸张宽度
    printPaper.width = parseInt(basicPrintSetting.paperWidth, 10) || 210;
    // 纸张高度
    printPaper.height = parseInt(basicPrintSetting.paperHeight, 10) || 297;
    // 纸张边距
    printPaper.margin = parseInt(basicPrintSetting.paperMargin, 10) || 6;
    // 纸张可用宽度
    printPaper.availableWidth =
      printPaper.width - parseInt(printPaper.margin, 10) * 2;
    // 纸张可用高度
    printPaper.availableHeight =
      printPaper.height - parseInt(printPaper.margin, 10) * 2;
    // 纸张类型(链式纸：C、其他纸张：N)
    printPaper.type = basicPrintSetting.paperType || "N";
    // console.log(printPaper);
    //
    // 获取需要自适应行高的医嘱名称、备注的“列编码、列宽、字号、可打印字数”
    var arcimDescCol = {};
    var notesCol = {};
    printForm["ORDERINFO"].sectionContent.forEach(function(item) {
      var itemCodeStr = String("-" + item.codeStr + "-").toUpperCase();
      if (itemCodeStr.indexOf("ARCIMDESC") > -1) {
        arcimDescCol.codeStr = item.codeStr;
        arcimDescCol.width = item.width;
        arcimDescCol.fontSize = item.fontSize;
        arcimDescCol.wordNum = item.wordNum;
      } else if (itemCodeStr.indexOf("NOTE") > -1) {
        notesCol.codeStr = item.codeStr;
        notesCol.width = item.width;
        notesCol.fontSize = item.fontSize;
        notesCol.wordNum = item.wordNum;
      }
    });
    var printConfig = {};
    // 打印模式(个人打印：P、病区打印：W)
    printConfig.printMode = basicPrintSetting.printMode || "P";
    // 打印方向(1：纵向打印、2：横向打印)
    printConfig.printDirection = basicPrintSetting.printDirection || 1;
    // 打印模式(1：按医嘱打印日期模式、2：按医嘱打印时间模式、3：按执行记录打印)
    printConfig.printType = parseInt(basicPrintSetting.printType) || 2;
    // 打印份数
    printConfig.printNumber = parseInt(basicPrintSetting.printNumber) || 1;
    // 双联打印(0：普通、1：双联不重复、2：双联重复)
    printConfig.printDuplex = parseInt(basicPrintSetting.printDuplex);
    // 单人换页(Y：启用单人换页、N：不启用)
    printConfig.singleFeed = basicPrintSetting.printSinglePageChange || "N";
    // 医嘱行高(默认值、避免行高未正确维护导致打印异常)
    printConfig.rowHeight = 4;
    // 是否是医嘱数据
    printConfig.isOrdType = basicPrintSetting.isOrdType || "N";
    // 是否是跨天换页(Y：启用跨天换页、N：不启用)
    printConfig.dateFeed = basicPrintSetting.dateFeed || "N";
    // console.log(printConfig);
    var sortType;
    if (printConfig.isOrdType === "Y") {
      // 打印医嘱
      sortType = "A";
    } else {
      if (printConfig.dateFeed === "Y") {
        if (printConfig.singleFeed === "Y") {
          // 打印执行记录-按日期、按人换页
          sortType = "E";
        } else {
          // 打印执行记录-只按日期换页
          sortType = "D";
        }
      } else {
        if (printConfig.printType === 3) {
          // 打印执行记录-不按日期换页
          // 按执行记录拆开打印，按要求执行时间排序
          sortType = "C";
        } else if (printConfig.printType === 2) {
          // 打印执行记录-不按日期换页
          // 执行记录打印(时间模式)按执行记录ID顺序循环
          sortType = "B";
        } else {
          // 打印执行记录-不按日期换页
          // 执行记录打印(日期模式)按医嘱ID顺序循环
          sortType = "A";
        }
      }
    }
    var sortList = [];
    if (sortType === "A") {
      // 返回按前端排序的医嘱ID数组
      sortList = unique(oeoriSeqIDs);
    } else if (sortType === "B") {
      sortList = unique(oeoreSeqIDs);
    } else {
      var sortObj = {};
      unique(oeoreSeqIDs).forEach(function(item) {
        var filterOrder = orderPrintData.find(function(orderItem) {
          return orderItem.ID === item;
        });
        var prop1;
        var prop2;
        if (sortType === "C") {
          prop1 = filterOrder["episodeID"];
          prop2 = filterOrder.execInfo["$sttDateTimeLogic"];
        } else if (sortType === "D") {
          prop1 = filterOrder.execInfo["$sttDate"];
          prop2 = filterOrder["episodeID"];
        } else if (sortType === "E") {
          prop1 = filterOrder["episodeID"];
          prop2 = filterOrder.execInfo["$sttDate"];
        }
        if (!sortObj[prop1]) {
          sortObj[prop1] = {};
        }
        if (!sortObj[prop1][prop2]) {
          sortObj[prop1][prop2] = [];
        }
        sortObj[prop1][prop2].push(item);
      });
      episodeIDStr.split("^").forEach(function(episodeID) {
        if (sortObj[episodeID]) {
          for (var propKey in sortObj[episodeID]) {
            sortList = sortList.concat(sortObj[episodeID][propKey]);
          }
        }
      });
    }
    console.log(sortList);
    // debugger;
    //
    // 处理医嘱数据
    // 按执行记录打印，返回key为执行记录ID的打印数据，行数为“子医嘱数+1”
    // 按医嘱打印时间模式，返回key为医嘱ID的打印数据，行数为“子医嘱数+1”
    // 按医嘱打印日期模式，返回key为医嘱ID的打印数据，行数为在“子医嘱数+1、执行天数”中取较大值
    var func = getOrders(
      oeoriSeqIDs,
      oeoreSeqIDs,
      oeoriIDs,
      oeoreIDs,
      printConfig.printType,
      printConfig.isOrdType,
      printConfig.dateFeed
    );
    var orderData = func(orderPrintData);
    console.log(orderData);
    // debugger;
    //
    // 处理医嘱、备注自适应行高
    var colNumDic = {};
    for (var key in orderData) {
      var itemOrderData = orderData[key];
      var arcimDescRowNum = 0;
      var notesRowNum = 0;
      var splitStrLen = 0;
      var itemContentTop = [0];
      var ID = orderData[key].ID;
      if (itemOrderData[arcimDescCol.codeStr]) {
        if (colNumDic[ID]) {
          if (colNumDic[ID].arcimDescRowNum) {
            arcimDescRowNum += colNumDic[ID].arcimDescRowNum;
          } else {
            splitStrLen = getSplitStr(
              itemOrderData[arcimDescCol.codeStr],
              arcimDescCol.wordNum
            ).length;
            arcimDescRowNum += splitStrLen;
            colNumDic[ID].arcimDescRowNum = splitStrLen;
          }
        } else {
          splitStrLen = getSplitStr(
            itemOrderData[arcimDescCol.codeStr],
            arcimDescCol.wordNum
          ).length;
          arcimDescRowNum += splitStrLen;
          colNumDic[ID] = {};
          colNumDic[ID].arcimDescRowNum = splitStrLen;
        }
        // 记录纵轴的相对位置
        itemContentTop.push(arcimDescRowNum * printConfig.rowHeight);
      }
      if (
        itemOrderData[notesCol.codeStr] &&
        itemOrderData[notesCol.codeStr] !== ""
      ) {
        if (colNumDic[ID]) {
          if (colNumDic[ID].notesRowNum) {
            notesRowNum = colNumDic[ID].notesRowNum;
          } else {
            splitStrLen = getSplitStr(
              itemOrderData[notesCol.codeStr],
              notesCol.wordNum
            ).length;
            notesRowNum = splitStrLen;
          }
        } else {
          splitStrLen = getSplitStr(
            itemOrderData[notesCol.codeStr],
            notesCol.wordNum
          ).length;
          notesRowNum = splitStrLen;
          colNumDic[ID] = {};
          colNumDic[ID].notesRowNum = splitStrLen;
        }
      }
      if (itemOrderData.childs && itemOrderData.childs.length > 0) {
        itemOrderData.childs.forEach(function(childItem) {
          var childID = childItem.ID;
          if (
            childItem[arcimDescCol.codeStr] &&
            childItem[arcimDescCol.codeStr] !== ""
          ) {
            if (colNumDic[childID]) {
              if (colNumDic[childID].arcimDescRowNum) {
                arcimDescRowNum += colNumDic[childID].arcimDescRowNum;
              } else {
                splitStrLen = getSplitStr(
                  childItem[arcimDescCol.codeStr],
                  arcimDescCol.wordNum
                ).length;
                arcimDescRowNum += splitStrLen;
                colNumDic[childID].arcimDescRowNum = splitStrLen;
              }
            } else {
              splitStrLen = getSplitStr(
                childItem[arcimDescCol.codeStr],
                arcimDescCol.wordNum
              ).length;
              arcimDescRowNum += splitStrLen;
              colNumDic[childID] = {};
              colNumDic[childID].arcimDescRowNum = splitStrLen;
            }
            // 记录纵轴的相对位置
            itemContentTop.push(arcimDescRowNum * printConfig.rowHeight);
          }
        });
      }
      // 计算行数
      arcimDescRowNum =
        arcimDescRowNum > notesRowNum ? arcimDescRowNum : notesRowNum;
      itemOrderData.rowNum =
        arcimDescRowNum > itemOrderData.rowNum
          ? arcimDescRowNum
          : itemOrderData.rowNum;
      // 记录纵轴的相对位置
      itemOrderData.itemContentTop = itemContentTop;
    }
    console.log(orderData);
    // debugger;
    //
    // 声明表格外文字对象的构造函数
    function Section(sectionObj, obj) {
      this.type = sectionObj.sectionType;
      this.height = sectionObj.sectionHeight;
      var a = [];
      var printText;
      sectionObj.sectionContent.forEach(function(item) {
        // 有绑定基础数据项目显示内容+基础数据
        if (item.codeStr) {
          // 页码特殊处理
          if (item.codeStr === "printPageNum") {
            printText =
              item.printContent +
              "第" +
              obj.current +
              "页/共" +
              obj.total +
              "页";
          } else {
            printText = item.printContent + obj[item.codeStr];
          }
        } else {
          // 未绑定基础数据项目只显示内容
          printText = item.printContent;
        }
        a.push({
          top: item.marginTop,
          left: item.pageLeft,
          width: item.width,
          height: item.height,
          fontSize: item.fontSize,
          fontFamily: item.fontFamily,
          fontStyle: item.fontStyle,
          textAlign: item.textAlign,
          fontWeight: item.fontWeight,
          text: printText
        });
      });
      this.content = a;
      this.top = 0;
      this.left = 0;
    }
    // 声明表头对象的构造函数
    function TableHead(sectionObj) {
      var a = [];
      var tableHeadLayout;
      var tableHeadHeight = 8;
      sectionObj.sectionContent.forEach(function(item) {
        // 默认表头行高，避免配置错误出现只有首列有行高的问题
        if (item.height !== 0) {
          tableHeadHeight = item.height;
        }
        // 表头内容自适应
        tableHeadLayout = getTableHeadLayout(
          item.printContent,
          item.fontSize,
          item.wordNum,
          item.width,
          tableHeadHeight
        );
        a.push({
          top: 0,
          left: item.pageLeft,
          width: item.width * 1.1,
          height: tableHeadHeight,
          fontSize: item.fontSize,
          fontFamily: item.fontFamily,
          fontStyle: item.fontStyle,
          textAlign: 1, // 自适应医嘱表头内容需左对齐
          fontWeight: item.fontWeight,
          text: tableHeadLayout
        });
      });
      this.type = "TABLEHEAD";
      this.height = sectionObj.sectionHeight;
      this.width = sectionObj.sectionWidth;
      this.content = a;
      this.top = 0;
      // 根据是否双签打印计算横轴位置
      this.left =
        printConfig.printDuplex === 0
          ? printPaper.availableWidth > sectionObj.sectionWidth
            ? (printPaper.availableWidth - sectionObj.sectionWidth) / 2
            : 0
          : 0;
    }
    // 声明表格对象的构造函数
    function TableBody(sectionObj, obj, mergeContent, no) {
      this.type = "TABLEBODY";
      var a = [];
      var tableContent = [];
      // 打印内容
      var printText = "";
      // 合并单元格划线标记
      var mergeCell;
      sectionObj.sectionContent.forEach(function(item) {
        mergeCell = false;
        // 判断绑定基础数据项目是否是执行记录类型
        if (item.execInfo === "Y") {
          if (item.codeStr === "") {
            // 未绑定基础数据项目则记录执行记录数量(printText为Number类型)
            printText = obj["execInfos"].length;
          } else if (item.codeStr === "sttDateTime") {
            // 特殊处理要求执行时间列
            if (printConfig.printType === 1) {
              // 医嘱打印时间模式
              // 返回按日期拼接当天时间的数组
              printText = reduceItemByDay(obj["execInfos"], item.codeStr);
            } else {
              // 医嘱打印日期模式、执行记录模式
              // 返回执行记录数据的数组
              printText = [];
              obj.execInfos.forEach(function(execInfoItem) {
                printText.push(execInfoItem[item.codeStr]);
              });
            }
          } else {
            // 返回执行记录数据的数组
            printText = [];
            obj.execInfos.forEach(function(execInfoItem) {
              printText.push(execInfoItem[item.codeStr]);
            });
          }
        } else {
          // 未绑定基础数据项目则记录执行记录数量
          if (item.mergeCell === "Y") {
            if (mergeContent) {
              // 后续单元格返回空
              printText = "";
            } else {
              // 第一个单元格正常返回数据
              // printText = [String(obj[item.codeStr])];
              if (item.codeStr === "printNo") {
                printText = [String(no)];
              } else {
                printText = [String(obj[item.codeStr])];
              }
            }
            mergeCell = true;
          } else {
            // 返回主医嘱数据的数组
            if (item.codeStr === "printNo") {
              printText = [String(no)];
            } else {
              printText = [String(obj[item.codeStr])];
            }

            // 判断是否显示子医嘱的数据
            if (
              obj["childs"].length > 0 &&
              item.multiply === "Y" &&
              item.codeStr !== "printNo"
            ) {
              // 医嘱数据的数组中插入子医嘱数据
              obj["childs"].forEach(function(childItem) {
                printText.push(String(childItem[item.codeStr]));
              });
            }
          }
        }
        // 表格列配置
        tableContent.push({
          codeStr: item.codeStr,
          left: item.pageLeft,
          width: item.width
        });
        a.push({
          codeStr: item.codeStr,
          mergeCell: mergeCell,
          partCell: item.partCell,
          tableLeft: item.pageLeft,
          tableWidth: item.width,
          top: 0.3,
          left: item.pageLeft + (parseInt(item.textAlign) === 1 ? 0.3 : 0), // 优化医嘱表格左对齐内容水平方向显示
          width: item.width + (parseInt(item.textAlign) === 1 ? 1 : 0),
          height: item.height,
          fontSize: item.fontSize,
          fontFamily: item.fontFamily,
          fontStyle: item.fontStyle,
          textAlign: item.textAlign,
          fontWeight: item.fontWeight,
          text: printText,
          rowHeight: printConfig.rowHeight * obj.rowNum,
          showExec: item.execInfo === "Y" ? true : false
        });
      });
      this.content = [a];
      this.tableContent = tableContent;
      this.height = printConfig.rowHeight * obj.rowNum;
      this.width = sectionObj.sectionWidth;
      // 根据是否双签打印计算横轴位置
      this.left =
        printConfig.printDuplex === 0
          ? printPaper.availableWidth > sectionObj.sectionWidth
            ? (printPaper.availableWidth - sectionObj.sectionWidth) / 2
            : 0
          : 0;
      // 记录单条数据的纵轴相对位置
      this.itemContentTop = [obj.itemContentTop];
      // 记录整组数据的纵轴相对位置
      this.contentTop = [0, printConfig.rowHeight * obj.rowNum];
    }
    var allPage = createAllPage(
      sortList,
      patData,
      orderData,
      printConfig,
      printPaper,
      printForm,
      Section,
      TableHead,
      TableBody
    );
    // console.log(allPage);
    //
    // 打印初始化

    LODOP.PRINT_INIT(basicPrintSetting.codeName);
    // 设置打印机
    if (basicPrintSetting.printView !== "Y" || PrtDevice !== "") {
      LODOP.SET_PRINTER_INDEX(PrtDeviceIndex);
    }
    // 计算纸张高度
    // var printPaperHeight = printPaper.height;
    // if (printPaper.type === "C") {
    //   printPaperHeight =
    //     allPage._pageHeight + parseInt(printPaper.margin, 10) * 3;
    //   if (printPaper.width > printPaperHeight) {
    //     printPaperHeight = printPaper.width;
    //   }
    // }
    // 双联打印
    var duplexPage = [];
    if (printConfig.printDuplex === 2) {
      // 双联重复打印
      duplexPage = allPage.map(function(item) {
        return [item, item];
      });
    } else if (printConfig.printDuplex === 1) {
      // 双联不重复打印
      duplexPage = splitChunk(allPage, 2);
    }
    // console.log(duplexPage);
    //
    // 设置打印纸张
    if (printConfig.printDirection === 2) {
      // 横向打印需要颠倒纸张的长宽
      LODOP.SET_PRINT_PAGESIZE(
        printConfig.printDirection,
        printPaper.height + "mm",
        printPaper.width + "mm",
        printPaper.name
      );
    } else {
      LODOP.SET_PRINT_PAGESIZE(
        printConfig.printDirection,
        printPaper.width + "mm",
        printPaper.height + "mm",
        printPaper.name
      );
    }

    //设置初始字体(单位：pt)
    LODOP.SET_PRINT_STYLE("FontSize", 10);
    if (printConfig.printDuplex === 0) {
      // 非双联打印
      Print_Lodop(LODOP, allPage, printConfig);
    } else {
      // 双联打印
      // 计算双联打印的左右原点x坐标
      var coordinate = [0, printPaper.availableWidth / 2];
      PrintDuplex_Lodop(LODOP, duplexPage, printConfig, coordinate);
    }

    printResult.statusCode = 3;
    printResult.msg = "调用LODOP打印";
    // 打印份数
    LODOP.SET_PRINT_COPIES(printConfig.printNumber);
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
        LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1); //横向打印预览时的正向显示
        LODOP.PREVIEW();
      } else {
        LODOP.PRINT();
      }
    } else {
      // IE
      if (basicPrintSetting.printView === "Y") {
        LODOP.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1);
        LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1); //横向打印预览时的正向显示
        LODOP.PREVIEW();

        printResult.statusCode = 1;
        printResult.msg = "成功";
      } else {
        if (LODOP.PRINT()) {
          printResult.statusCode = 1;
          printResult.msg = "成功";
        } else {
          printResult.statusCode = 0;
          printResult.msg = "失败";
        }
      }
    }
  }
  // 打印状态
  var printResult = {
    statusCode: 0
  };
  // 打印状态获取
  function getSheetPrintResult() {
    return printResult;
  }
  function resetSheetPrintResult() {
    printResult.statusCode = 0;
  }
  window.SheetPrintOutSide = main;
  window.SheetPrint = SheetPrint;
  window.getSheetPrintResult = getSheetPrintResult;
  window.resetSheetPrintResult = resetSheetPrintResult;
})();
