(function () {
  /**
   * @description: 封装LODOP打印方法
   * @param  {} LODOP: LODOP打印实例化
   * @param  {object} arg: 打印参数对象
   */
  function PRINT_ITEM(LODOP, arg) {
    var o = new Object();
    o.top = (Number(arg.top).toFixed(4) || 0) + "mm";
    o.left = (Number(arg.left).toFixed(4) || 0) + "mm";
    o.width =
      arg.width === "100%"
        ? "100%"
        : (Number(arg.width).toFixed(4) || 0) + "mm";
    o.height = (Number(arg.height).toFixed(4) || 0) + "mm";
    o.topDr = (Number(arg.topDr).toFixed(4) || 0) + "mm";
    o.leftDr = (Number(arg.leftDr).toFixed(4) || 0) + "mm";
    o.intLineStyle = arg.intLineStyle || 0;
    o.intLineWidth = arg.intLineWidth || 1;
    o.strContent = arg.strContent;
    o.align = arg.align || 0;
    o.fontFamily = arg.fontFamily || "黑体";
    o.fontSize = arg.fontSize || 10;
    o.fontStyle = arg.fontStyle || "";
    // 打印矩形
    o.PRINT_RECT = function () {
      LODOP.ADD_PRINT_RECT(
        this.top,
        this.left,
        this.width,
        this.height,
        this.intLineStyle,
        this.intLineWidth
      );
    };
    // 打印线
    o.PRINT_LINE = function () {
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
    o.PRINT_TEXT = function () {
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
        LODOP.SET_PRINT_STYLEA(0, "LineSpacing", -1);
        // LODOP.SET_PRINT_STYLEA(0, "LetterSpacing", -1);
        if (this.fontStyle === "Bold") {
          LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
        } else {
          LODOP.SET_PRINT_STYLEA(0, "Bold", 0);
        }
        if (this.align === 1) {
          LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
        } else {
          LODOP.SET_PRINT_STYLEA(0, "Alignment", 1);
        }
      }
    };
    return o;
  }
  function Print_Table(LODOP, instance) {
    // 实例化
    var itemInstance;
    if (instance.type === "tableHead") {
      itemInstance = new PRINT_ITEM(LODOP, {
        top: instance.top,
        left: instance.left,
        width: instance.width,
        height: instance.height,
      });
      itemInstance.PRINT_RECT();
      instance.content.forEach(function (item) {
        item.text.forEach(function (textItem) {
          itemInstance = new PRINT_ITEM(LODOP, {
            top: instance.top + item.y + textItem.top,
            left: instance.left + item.x + textItem.left,
            width: item.width * 1.1,
            height: instance.height,
            strContent: textItem.text,
            fontFamily: item.fontFamily,
            fontSize: item.fontSize,
            fontStyle: item.fontStyle,
            align: 0,
          });
          itemInstance.PRINT_TEXT();
        });
        if (item.x !== 0) {
          itemInstance = new PRINT_ITEM(LODOP, {
            top: instance.top,
            left: instance.left + item.x,
            topDr: instance.top + instance.height,
            leftDr: instance.left + item.x,
          });
          itemInstance.PRINT_LINE();
        }
      });
    } else if (instance.type === "tableBody") {
      var offsettop = 0.5;
      var offsetLeft = 0;
      var contentTop = [];
      var sum = 0;
      var arcimDescWidth = 0;
      instance.contentTop.forEach(function (num) {
        sum += num;
        contentTop.push(sum);
      });
      var alignStyle = 0;
      instance.content.forEach(function (item, index) {
        item.forEach(function (inst) {
          // 居中显示设置
          if (
            inst.code !== "arcimDescInfo" &&
            inst.code !== "notes" &&
            inst.code !== "sttDateTime"
          ) {
            alignStyle = 1;
          } else {
            alignStyle = 0;
          }
          // 左缩进设置
          if (inst.code === "arcimDescInfo" || inst.code === "sttDateTime") {
            offsetLeft = 1;
            arcimDescWidth = 2;
          } else {
            offsetLeft = 0;
            arcimDescWidth = 0;
          }
          if (typeof inst.text === "string") {
            if (inst.code === "notes") {
              itemInstance = new PRINT_ITEM(LODOP, {
                top: offsettop + instance.top + contentTop[index],
                left: offsetLeft + instance.left + inst.x,
                width: arcimDescWidth + inst.width,
                height: instance.contentTop[index + 1],
                strContent: inst.text,
                fontFamily: inst.fontFamily,
                fontSize: inst.fontSize,
                fontStyle: inst.fontStyle,
                align: alignStyle,
              });
              itemInstance.PRINT_TEXT();
            } else {
              itemInstance = new PRINT_ITEM(LODOP, {
                top:
                  offsettop +
                  instance.top +
                  contentTop[index] +
                  index * inst.rowHeight,
                left: offsetLeft + instance.left + inst.x,
                width: arcimDescWidth + inst.width,
                height: inst.rowHeight,
                strContent: inst.text,
                fontFamily: inst.fontFamily,
                fontSize: inst.fontSize,
                fontStyle: inst.fontStyle,
                align: alignStyle,
              });
              itemInstance.PRINT_TEXT();
            }
          } else if (Array.isArray(inst.text)) {
            inst.text.forEach(function (instText, textIndex) {
              if (inst.showExec) {
                itemInstance = new PRINT_ITEM(LODOP, {
                  top:
                    offsettop +
                    instance.top +
                    contentTop[index] +
                    (instance.contentTop[index + 1] / inst.text.length) *
                      textIndex,
                  left: offsetLeft + instance.left + inst.x,
                  width: arcimDescWidth + inst.width,
                  height: inst.rowHeight,
                  strContent: instText,
                  fontFamily: inst.fontFamily,
                  fontSize: inst.fontSize,
                  fontStyle: inst.fontStyle,
                  align: alignStyle,
                });
                itemInstance.PRINT_TEXT();
                if (
                  inst.code === "sttDateTime" &&
                  inst.text.length > 1 &&
                  textIndex !== 0 &&
                  !window.config.printSheetType
                ) {
                  itemInstance = new PRINT_ITEM(LODOP, {
                    top:
                      instance.top +
                      contentTop[index] +
                      (instance.contentTop[index + 1] / inst.text.length) *
                        textIndex,
                    left: instance.left + inst.x,
                    topDr:
                      instance.top +
                      contentTop[index] +
                      (instance.contentTop[index + 1] / inst.text.length) *
                        textIndex,
                    leftDr: instance.left + inst.x + inst.width,
                  });
                  itemInstance.PRINT_LINE();
                }
              } else {
                itemInstance = new PRINT_ITEM(LODOP, {
                  top:
                    offsettop +
                    instance.top +
                    contentTop[index] +
                    instance.itemContentTop[index][textIndex],
                  left: offsetLeft + instance.left + inst.x,
                  width: arcimDescWidth + inst.width,
                  height: inst.rowHeight,
                  strContent: instText,
                  fontFamily: inst.fontFamily,
                  fontSize: inst.fontSize,
                  fontStyle: inst.fontStyle,
                  align: alignStyle,
                });
                itemInstance.PRINT_TEXT();
              }
            });
          } else if (typeof inst.text === "number" && inst.text > 1) {
            if (inst.showExec) {
              if (!window.config.printSheetType) {
                for (var i = 1; i <= inst.text; i++) {
                  itemInstance = new PRINT_ITEM(LODOP, {
                    top:
                      instance.top +
                      contentTop[index] +
                      (instance.contentTop[index + 1] / inst.text) * i,
                    left: instance.left + inst.x,
                    topDr:
                      instance.top +
                      contentTop[index] +
                      (instance.contentTop[index + 1] / inst.text) * i,
                    leftDr: instance.left + inst.x + inst.width,
                  });
                  itemInstance.PRINT_LINE();
                }
              }
            } else {
              for (var j = 1; j <= inst.text; j++) {
                itemInstance = new PRINT_ITEM(LODOP, {
                  top: instance.top + contentTop[index] + j * inst.rowHeight,
                  left: instance.left + inst.x,
                  topDr: instance.top + contentTop[index] + j * inst.rowHeight,
                  leftDr: instance.left + inst.x + inst.width,
                });
                itemInstance.PRINT_LINE();
              }
            }
          }
        });
        if (index !== instance.content.length - 1) {
          item.forEach(function (inst) {
            if (!inst.merge) {
              itemInstance = new PRINT_ITEM(LODOP, {
                top: instance.top + contentTop[index + 1],
                left: instance.left + inst.x,
                topDr: instance.top + contentTop[index + 1],
                leftDr: instance.left + inst.x + inst.width,
              });
              itemInstance.PRINT_LINE();
            }
          });
        }
      });
      // 竖线
      instance.tableContent.forEach(function (item) {
        if (item.x !== 0) {
          itemInstance = new PRINT_ITEM(LODOP, {
            top: instance.top,
            left: instance.left + item.x,
            topDr: instance.top + instance.height,
            leftDr: instance.left + item.x,
          });
          itemInstance.PRINT_LINE();
        }
      });
      // 左竖线
      itemInstance = new PRINT_ITEM(LODOP, {
        top: instance.top,
        left: instance.left,
        topDr: instance.top + instance.height,
        leftDr: instance.left,
      });
      itemInstance.PRINT_LINE();
      // 右竖线
      itemInstance = new PRINT_ITEM(LODOP, {
        top: instance.top,
        left: instance.left + instance.width,
        topDr: instance.top + instance.height,
        leftDr: instance.left + instance.width,
      });
      itemInstance.PRINT_LINE();
      // 下横线
      itemInstance = new PRINT_ITEM(LODOP, {
        top: instance.top + instance.height,
        left: instance.left,
        topDr: instance.top + instance.height,
        leftDr: instance.left + instance.width,
      });
      itemInstance.PRINT_LINE();
    }
  }

  function Print_Content(LODOP, instance) {
    // 实例化
    var itemInstance;
    if (instance.printType === "TEXT") {
      instance.content.forEach(function (item) {
        itemInstance = new PRINT_ITEM(LODOP, {
          top: instance.top + item.y,
          left: instance.left + item.x,
          width: item.width,
          height: instance.height,
          strContent: item.text,
          fontFamily: item.fontFamily,
          fontSize: item.fontSize,
          fontStyle: item.fontStyle,
        });
        itemInstance.PRINT_TEXT();
      });
    } else if (instance.printType === "TABLE") {
      Print_Table(LODOP, instance);
    }
  }
  function Print_Lodop(LODOP, allPage) {
    // 实例化
    allPage.forEach(function (page, index) {
      page.forEach(function (item) {
        Print_Content(LODOP, item);
      });
      if (allPage[index + 1]) {
        LODOP.NEWPAGE();
      }
    });
  }
  function createAllPageWARD(
    patOrderId,
    orderData,
    paperSize,
    TitleInfoObj,
    HeadInfoObj,
    TableHeadObj,
    TableBodyObj,
    FooterObj,
    pageNumSize,
    tableSize
  ) {
    var allPage = [];
    var titleInfo = new TitleInfoObj();
    var headInfo;
    var tableHead = new TableHeadObj();
    var tableBody;
    var footer = new FooterObj();
    var paperAvailableHeight =
      paperSize.availableHeight -
      (footer.height + footer.top + pageNumSize.height);
    var pageNum = 0;
    var currentPgaeHeight = 0;
    var newPage = true;
    var episodeId = "";
    var rowHeight = tableSize.dataRowHeight;
    patOrderId.forEach(function (patOrder) {
      if (newPage) {
        // 新建
        allPage[pageNum] = [];
        // 抬头
        allPage[pageNum].push(titleInfo);
        // 表格上文字
        headInfo = new HeadInfoObj(orderData[patOrder].episodeId);
        headInfo.top += titleInfo.height + titleInfo.top;
        allPage[pageNum].push(headInfo);
        // 表头
        tableHead = new TableHeadObj();
        tableHead.top = headInfo.top + headInfo.height;
        allPage[pageNum].push(tableHead);
        // 医嘱信息表格
        tableBody = new TableBodyObj(
          orderData[patOrder],
          orderData[patOrder].rowNum,
          false
        );
        tableBody.top = tableHead.top + tableHead.height;
        allPage[pageNum].push(tableBody);
        // 记录当前高度
        currentPgaeHeight += tableBody.top + tableBody.height;
        // 记录当前患者就诊号
        episodeId = orderData[patOrder].episodeId;
        newPage = false;
      } else {
        // 接着打印
        // 判断是否是同一个患者
        if (episodeId !== orderData[patOrder].episodeId) {
          // 不是同一个患者
          if (
            currentPgaeHeight + rowHeight * orderData[patOrder].rowNum <=
            paperAvailableHeight
          ) {
            // 不换页
            // 医嘱信息表格
            tableBody = new TableBodyObj(
              orderData[patOrder],
              orderData[patOrder].rowNum,
              false
            );
            tableBody.top = currentPgaeHeight;
            allPage[pageNum].push(tableBody);
            currentPgaeHeight = tableBody.top + tableBody.height;
            episodeId = orderData[patOrder].episodeId;
            newPage = false;
          } else {
            // 换页
            newPage = false;
            pageNum += 1;
            currentPgaeHeight = 0;
            episodeId = "";
            headInfo = new HeadInfoObj(orderData[patOrder].episodeId);
            allPage[pageNum] = [];
            // 抬头
            allPage[pageNum].push(titleInfo);
            // 表格上文字
            headInfo.top += titleInfo.height + titleInfo.top;
            allPage[pageNum].push(headInfo);
            // 表头
            tableHead = new TableHeadObj();
            tableHead.top = headInfo.top + headInfo.height;
            allPage[pageNum].push(tableHead);
            // 医嘱信息表格
            tableBody = new TableBodyObj(
              orderData[patOrder],
              orderData[patOrder].rowNum,
              false
            );
            tableBody.top = tableHead.top + tableHead.height;
            allPage[pageNum].push(tableBody);
            // 记录当前高度
            currentPgaeHeight += tableBody.top + tableBody.height;
            // 记录当前患者就诊号
            episodeId = orderData[patOrder].episodeId;
          }
        } else {
          // 是同一个患者
          if (
            currentPgaeHeight + rowHeight * orderData[patOrder].rowNum <=
            paperAvailableHeight
          ) {
            // 不换页
            // 医嘱信息表格
            tableBody = new TableBodyObj(
              orderData[patOrder],
              orderData[patOrder].rowNum,
              true
            );

            allPage[pageNum][allPage[pageNum].length - 1].content.push(
              tableBody.content[0]
            );
            allPage[pageNum][allPage[pageNum].length - 1].height +=
              tableBody.height;

            allPage[pageNum][allPage[pageNum].length - 1].contentTop.push(
              orderData[patOrder].rowNum * rowHeight
            );
            allPage[pageNum][allPage[pageNum].length - 1].itemContentTop.push(
              tableBody.itemContentTop[0]
            );
            currentPgaeHeight += rowHeight * orderData[patOrder].rowNum;
          } else {
            // 换页
            // 创建新页面
            newPage = false;
            pageNum += 1;
            currentPgaeHeight = 0;
            episodeId = "";
            headInfo = new HeadInfoObj(orderData[patOrder].episodeId);
            allPage[pageNum] = [];
            // 抬头
            allPage[pageNum].push(titleInfo);
            // 表格上文字
            headInfo.top += titleInfo.height + titleInfo.top;
            allPage[pageNum].push(headInfo);
            // 表头
            tableHead = new TableHeadObj();
            tableHead.top = headInfo.top + headInfo.height;
            allPage[pageNum].push(tableHead);
            // 医嘱信息表格
            tableBody = new TableBodyObj(
              orderData[patOrder],
              orderData[patOrder].rowNum,
              false
            );
            tableBody.top = tableHead.top + tableHead.height;
            allPage[pageNum].push(tableBody);
            // 记录当前高度
            currentPgaeHeight += tableBody.top + tableBody.height;
            // 记录当前患者就诊号
            episodeId = orderData[patOrder].episodeId;
          }
        }
      }
    });
    return allPage;
  }
  function createAllPagePAT(
    patOrderId,
    orderData,
    paperSize,
    TitleInfoObj,
    HeadInfoObj,
    TableHeadObj,
    TableBodyObj,
    FooterObj,
    pageNumSize,
    tableSize
  ) {
    var allPage = [];
    var titleInfo;
    var headInfo;
    var tableHead = new TableHeadObj();
    var tableBody;
    var footer = new FooterObj();
    var paperAvailableHeight =
      paperSize.availableHeight -
      (footer.height + footer.top + pageNumSize.height);
    var pageNum = 0;
    var currentPgaeHeight = 0;
    var newPage = true;
    var episodeId = "";
    var rowHeight = tableSize.dataRowHeight;
    patOrderId.forEach(function (patOrder) {
      if (newPage) {
        // 新建
        allPage[pageNum] = [];
        // 抬头
        titleInfo = new TitleInfoObj();
        allPage[pageNum].push(titleInfo);
        // 表格上文字
        headInfo = new HeadInfoObj(orderData[patOrder].episodeId);
        headInfo.top += titleInfo.height + titleInfo.top;
        allPage[pageNum].push(headInfo);
        // 表头
        tableHead = new TableHeadObj();
        tableHead.top = headInfo.top + headInfo.height;
        allPage[pageNum].push(tableHead);
        // 医嘱信息表格
        tableBody = new TableBodyObj(
          orderData[patOrder],
          orderData[patOrder].rowNum,
          false
        );
        tableBody.top = tableHead.top + tableHead.height;
        allPage[pageNum].push(tableBody);
        // 记录当前高度
        currentPgaeHeight += tableBody.top + tableBody.height;
        // 记录当前患者就诊号
        episodeId = orderData[patOrder].episodeId;
        newPage = false;
      } else {
        // 接着打印
        // 判断是否是同一个患者
        if (episodeId !== orderData[patOrder].episodeId) {
          // 不是同一个患者
          titleInfo = new TitleInfoObj();
          headInfo = new HeadInfoObj(orderData[patOrder].episodeId);
          footer = new FooterObj();
          // 计算是否换页
          if (
            currentPgaeHeight +
              titleInfo.height +
              titleInfo.top +
              headInfo.height +
              headInfo.top +
              rowHeight * (orderData[patOrder].rowNum + 1) +
              footer.top +
              footer.height <=
            paperAvailableHeight
          ) {
            // 不换页
            // 插入上一个表格的表格下文字
            footer.top += currentPgaeHeight;
            allPage[pageNum].push(footer);
            // 抬头
            titleInfo.top = footer.top + footer.height;
            allPage[pageNum].push(titleInfo);
            // 表格上文字
            headInfo.top += titleInfo.height + titleInfo.top;
            allPage[pageNum].push(headInfo);
            // 表头
            tableHead = new TableHeadObj();
            tableHead.top = headInfo.top + headInfo.height;
            allPage[pageNum].push(tableHead);
            // 医嘱信息表格
            tableBody = new TableBodyObj(
              orderData[patOrder],
              orderData[patOrder].rowNum,
              false
            );
            tableBody.top = tableHead.top + tableHead.height;
            allPage[pageNum].push(tableBody);
            // 记录当前高度
            currentPgaeHeight = tableBody.top + tableBody.height;
            // 记录当前患者就诊号
            episodeId = orderData[patOrder].episodeId;
            newPage = false;
          } else {
            // 换页
            newPage = false;
            pageNum += 1;
            currentPgaeHeight = 0;
            episodeId = "";
            allPage[pageNum] = [];
            // 抬头
            titleInfo = new TitleInfoObj();
            allPage[pageNum].push(titleInfo);
            // 表格上文字
            headInfo = new HeadInfoObj(orderData[patOrder].episodeId);
            headInfo.top += titleInfo.height + titleInfo.top;
            allPage[pageNum].push(headInfo);
            // 表头
            tableHead = new TableHeadObj();
            tableHead.top = headInfo.top + headInfo.height;
            allPage[pageNum].push(tableHead);
            // 医嘱信息表格
            tableBody = new TableBodyObj(
              orderData[patOrder],
              orderData[patOrder].rowNum,
              false
            );
            tableBody.top = tableHead.top + tableHead.height;
            allPage[pageNum].push(tableBody);
            // 记录当前高度
            currentPgaeHeight += tableBody.top + tableBody.height;
            // 记录当前患者就诊号
            episodeId = orderData[patOrder].episodeId;
          }
        } else {
          // 是同一个患者
          if (
            currentPgaeHeight + rowHeight * orderData[patOrder].rowNum <=
            paperAvailableHeight
          ) {
            // 不换页
            // 医嘱信息表格
            tableBody = new TableBodyObj(
              orderData[patOrder],
              orderData[patOrder].rowNum,
              true
            );
            allPage[pageNum][allPage[pageNum].length - 1].content.push(
              tableBody.content[0]
            );
            allPage[pageNum][allPage[pageNum].length - 1].height +=
              tableBody.height;
            allPage[pageNum][allPage[pageNum].length - 1].contentTop.push(
              orderData[patOrder].rowNum * rowHeight
            );
            allPage[pageNum][allPage[pageNum].length - 1].itemContentTop.push(
              tableBody.itemContentTop[0]
            );
            // 记录当前高度
            currentPgaeHeight += rowHeight * orderData[patOrder].rowNum;
          } else {
            // 换页
            // 创建新页面
            newPage = false;
            pageNum += 1;
            currentPgaeHeight = 0;
            episodeId = "";
            allPage[pageNum] = [];
            // 抬头
            titleInfo = new TitleInfoObj();
            allPage[pageNum].push(titleInfo);
            // 表格上文字
            headInfo = new HeadInfoObj(orderData[patOrder].episodeId);
            headInfo.top += titleInfo.height + titleInfo.top;
            allPage[pageNum].push(headInfo);
            // 表头
            tableHead = new TableHeadObj();
            tableHead.top = headInfo.top + headInfo.height;
            allPage[pageNum].push(tableHead);
            // 医嘱信息表格
            tableBody = new TableBodyObj(
              orderData[patOrder],
              orderData[patOrder].rowNum,
              false
            );
            tableBody.top = tableHead.top + tableHead.height;
            allPage[pageNum].push(tableBody);
            // 记录当前高度
            currentPgaeHeight += tableBody.top + tableBody.height;
            // 记录当前患者就诊号
            episodeId = orderData[patOrder].episodeId;
          }
        }
      }
    });
    return allPage;
  }
  /**
   * @description: 按日期打印时处理要求执行时间显示格式
   * @param  {Array} targetArr: 目标数组
   * @param  {String} attribute: 属性值
   */
  function reduceItemByDay(targetArr, attribute) {
    var a = new Array();
    var s;
    var doseArr;
    var sttDatePrint;
    var arr = targetArr.concat();
    var o = new Object();
    arr.push("");
    if (attribute === "sttDateTime") {
      s = "";
      arr.reduce(function (total, curItem) {
        if (total) {
          if (curItem) {
            if (
              curItem["sttDate"].split(" ")[0] ===
              total["sttDate"].split(" ")[0]
            ) {
              s += " " + curItem["sttTimePrint"];
            } else {
              a.push(s);
              s = "";
              sttDatePrint = curItem["sttDatePrint"];
              s +=
                sttDatePrint +
                " " +
                (curItem["sttTimePrint"] ? curItem["sttTimePrint"] : "");
            }
          } else {
            a.push(s);
          }
        } else {
          sttDatePrint = curItem["sttDatePrint"];
          s +=
            sttDatePrint +
            " " +
            (curItem["sttTimePrint"] ? curItem["sttTimePrint"] : "");
        }
        return curItem;
      }, "");
    } else {
      targetArr.forEach(function (item) {
        if (o[item["sttDate"].split(" ")[0]]) {
          o[item["sttDate"].split(" ")[0]].push(item[attribute]);
        } else {
          o[item["sttDate"].split(" ")[0]] = [];
          o[item["sttDate"].split(" ")[0]].push(item[attribute]);
        }
      });
      for (var sttDateItem in o) {
        if (equal(o[sttDateItem])) {
          a.push(o[sttDateItem][0]);
        } else {
          doseArr = o[sttDateItem].map(function (item) {
            return item.split(" ")[0];
          });
          s = "(" + doseArr.join("-") + ")" + o[sttDateItem][0].split(" ")[1];
          a.push(s);
          doseArr = null;
        }
      }
    }
    return a;
  }
  /**
   * @description: 通过执行记录ID或医嘱ID获取患者数据
   * @param  {String} IDStr: 医嘱ID或执行记录ID
   * @param  {Object} obj: 全部医嘱信息
   * @returns: 返回患者数据对象
   */
  function getOrder(IDStr, obj) {
    var filterOrder;
    try {
      if (IDStr.split("||").length === 3) {
        filterOrder = obj.find(function (item) {
          return item.oeoriId === IDStr;
        });
      } else if (IDStr.split("||").length === 2) {
        filterOrder = obj.find(function (item) {
          return getID(item.oeoriId) === IDStr;
        });
      }
    } catch (e) {
      alert("患者信息错误", e);
    }
    return filterOrder;
  }
  /**
   * @description: 数组去重
   * @param  {Array} arr: 数据
   */
  function unique(arr) {
    if (Array.isArray(arr)) {
      var array = [];
      for (var i = 0; i < arr.length; i++) {
        if (!array.includes(arr[i])) {
          array.push(arr[i]);
        }
      }
    } else {
      alert("传参应为数组");
    }
    return array;
  }
  /**
   * @description: 判断数组中每个元素是否相等
   * @param  {Array} arr: 数据
   */
  function equal(arr) {
    return !arr.some(function (value) {
      return value !== arr[0];
    });
  }
  /**
   * @description: 初始化医嘱(子医嘱及执行记录)
   * @param  {Array} patOrderId: 主医嘱ID
   * @param  {Array} orderId: 全部医嘱ID
   * @param  {Array} oeoriId: 全部执行记录ID
   * @returns: 返回以主医嘱ID为key的对象,对象的child属性为子医嘱ID,对象的execInfos属性为主执行记录ID
   */
  function initOrders(patOrderId, orderId, oeoriId) {
    var o = new Object();
    patOrderId.forEach(function (item) {
      o[item] = { child: [], execInfos: [], childExecInfos: [] };
    });
    orderId.forEach(function (item, index) {
      for (var Id in o) {
        if (Id === patOrderId[index] && Id !== orderId[index]) {
          if (o[Id].child.indexOf(orderId[index]) === -1) {
            o[Id].child.push(orderId[index]);
          }
        }
      }
    });
    oeoriId.forEach(function (item) {
      for (var Id in o) {
        if (Id === getID(item)) {
          if (o[Id].execInfos.indexOf(item) === -1) {
            o[Id].execInfos.push(item);
          }
        }
        o[Id].child.forEach(function (childItem, childItemIndex) {
          if (childItem === getID(item)) {
            if (o[Id].childExecInfos[childItemIndex]) {
              o[Id].childExecInfos[childItemIndex].push(item);
            } else {
              o[Id].childExecInfos[childItemIndex] = [];
              o[Id].childExecInfos[childItemIndex].push(item);
            }
          }
        });
      }
    });

    return o;
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
   * @description: 初始化医嘱信息
   * @param  {String} ID: 医嘱ID或执行记录ID
   * @param  {Object} obj: 全部医嘱信息
   * @param  {Array} infoItem: 所需信息code值
   */
  function initOrderInfo(IDStr, obj, infoItem) {
    var orderInfo = getOrder(IDStr, obj);
    var o = new Object();
    if (IDStr.split("||").length === 3) {
      if (orderInfo.sttDate) {
        o.sttDate = orderInfo.sttDate;
      }
      if (orderInfo.sttDateTime) {
        o.sttDateTime = orderInfo.sttDateTime;
      }
      if (orderInfo.sttDatePrint) {
        o.sttDatePrint = orderInfo.sttDatePrint;
      }
      if (orderInfo.sttTimePrint) {
        o.sttTimePrint = orderInfo.sttTimePrint;
      }
      if (orderInfo.doseQtyUnit) {
        o.doseQtyUnit = orderInfo.doseQtyUnit;
      }
      if (orderInfo.dosage) {
        o.dosage = orderInfo.dosage;
      }
    } else if (IDStr.split("||").length === 2) {
      o = {
        ID: IDStr,
        episodeId: orderInfo.episodeId,
      };
      if (orderInfo) {
        infoItem.forEach(function (item) {
          o[item] = orderInfo[item];
        });
      }
    } else {
      console.log("传入ID格式不正确");
    }
    return o;
  }
  /**
   * @description: 处理医嘱数据
   * @param  {Array} patOrderId: 主医嘱ID
   * @param  {Array} orderId: 全部医嘱ID
   * @param  {Array} oeoriId: 全部执行记录ID
   */
  function getOrders(patOrderId, orderId, oeoriId) {
    var o = initOrders(patOrderId, orderId, oeoriId);
    // debugger;
    return function (obj, infoItem, printSheetType) {
      for (var Id in o) {
        Object.assign(o[Id], initOrderInfo(Id, obj, infoItem));
        o[Id].child.forEach(function (childId, index) {
          var childInfoDetail = initOrderInfo(childId, obj, infoItem);
          o[Id].child[index] = childInfoDetail;
        });
        o[Id].execInfos.forEach(function (execInfoId, index) {
          var execInfoDetail = initOrderInfo(execInfoId, obj, infoItem, "exec");
          o[Id].execInfos[index] = execInfoDetail;
        });
        o[Id].childExecInfos.forEach(function (execInfoId, index) {
          execInfoId.forEach(function (execInfoIdItem, execInfoIdItemIndex) {
            var childExecInfoDetail = initOrderInfo(
              execInfoIdItem,
              obj,
              infoItem,
              ""
            );
            o[Id].childExecInfos[index][execInfoIdItemIndex] =
              childExecInfoDetail;
          });
        });
        // 计算每组医嘱所占行数
        var dayNum = [];
        o[Id].execInfos.forEach(function (item) {
          if (dayNum.indexOf(item["sttDatePrint"]) === -1) {
            dayNum.push(item["sttDatePrint"]);
          }
        });
        if (printSheetType) {
          o[Id].rowNum =
            o[Id].child.length + 1 >= dayNum.length * 2
              ? o[Id].child.length + 1
              : dayNum.length * 2;
        } else {
          o[Id].rowNum =
            o[Id].child.length + 1 >= o[Id].execInfos.length * 2
              ? o[Id].child.length + 1
              : o[Id].execInfos.length * 2;
        }
      }
      return o;
    };
  }
  /**
   * @description: 计算指定宽度可容纳文字数
   * @param  {Number} width: 宽度
   * @param  {Number} fontSize: 字号
   */
  function getNumbyWidth(width, fontSize) {
    let num = width / (0.3527 * fontSize);
    let intege = parseInt(num);
    let decimal = num - intege > 0.5 ? 0.5 : 0;
    return intege + decimal;
  }
  /**
   * @description: 按指定宽度分割文字
   * @param  {String} text: 文本
   * @param  {Number} len: 横向可容纳文字数
   */
  function getSplitStr(text, len) {
    var connectStr = String.fromCharCode(13);
    let strLength = text.split("").length;
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
          str = str + connectStr + splitStr;
        }
      }
    }
    return str.split(connectStr);
  }
  /**
   * @description: 获取字数
   * @param  {String} text: 文本
   */
  function getChar(text) {
    var strLength = 0;
    text.split("").forEach(function (val) {
      strLength += val.charCodeAt(0) > 255 ? 1 : 0.5;
    });
    return strLength;
  }
  /**
   * @description: 获取居中文本位置
   * @param  {Number} width: 宽度
   * @param  {Number} fontSize: 字号
   * @param  {String} text: 文本
   */
  function getRowCenterTextPosition(width, fontSize, text) {
    var textNum = getChar(text);
    var textWidth = textNum * (0.3527 * fontSize);
    var o = {
      y: 0,
      x: width > textWidth ? (width - textWidth) / 2 : 0,
      text: text,
    };
    return o;
  }
  /**
   * @description: 获取表头居中文字位置
   * @param  {Number} width: 单元格宽度
   * @param  {Number} height: 单元格高度
   * @param  {Number} fontSize: 字号
   * @param  {String} text: 文本
   */
  function getTableHeadTextPosition(width, height, fontSize, text) {
    // 计算横向可容纳文字数
    var textNumBywidth = getNumbyWidth(width, fontSize);
    var connectStr = String.fromCharCode(13);
    // 按宽度分割文字
    var splitStr = getSplitStr(text, textNumBywidth, connectStr);
    // 磅转为mm后计算行高
    var lineHeight = fontSize * 0.3527 * splitStr.length;
    var a = [];
    splitStr.forEach(function (item, index) {
      a.push({
        top: index * fontSize * 0.3527 + (height - lineHeight) / 2,
        left: (width - getChar(item) * fontSize * 0.3527) / 2,
        text: item,
      });
    });
    return a;
  }
  /**
   * @description: 获取表格内文字换行
   * @param  {Number} width: 宽度
   * @param  {Number} fontSize: 字号
   * @param  {String} text: 文本
   */
  function getSpecialLineFeed(width, fontSize, text) {
    // 计算横向可容纳文字数
    var textNumBywidth = getNumbyWidth(width, fontSize);
    var connectStr = String.fromCharCode(13);
    // 按宽度分割文字
    var splitStr = getSplitStr(text, textNumBywidth, connectStr);
    return splitStr.length;
  }
  /**
   * @description 把数组按照size分割成多维数组
   * @param {any} arr			  	待分割数组
   * @param {any} size			分割长度
   */
  function splitChunk(arr, size) {
    var retArr = [];
    for (var i = 0; i < arr.length; i = i + size) {
      retArr.push(arr.slice(i, i + size));
    }
    return retArr;
  }
  // 打印状态变量
  var printResult = {
    state: -2,
  };
  /**
   * @description: 打印主程序
   * @param  {} _ref: vue中前后端交互实例
   * @param  {} utils: vue中工具函数
   * @param  {} oeoriIdStr: 所有主医嘱执行记录ID
   * @param  {} seqNoStr: 所有医嘱执行记录ID
   * @param  {} printType: 打印类型
   * @param  {} queryTypeCode: 医嘱项
   * @param  {} userID: 用户ID
   * @param  {} userName: 用户名称
   * @param  {} searchRange: 查询时间范围
   * @param  {} locID: 科室ID
   * @param  {} groupID: 安全组ID
   * @param  {} printFlag: 打印标记
   */
  function NurseSheetPrint(
    oeoriIdStr,
    seqNoStr,
    printType,
    queryTypeCode,
    userID,
    userName,
    searchRange,
    locID,
    groupID,
    printFlag
  ) {
    printResult.state = -2;
    var nurseSheetName;
    switch (printType) {
      case "WARD":
        nurseSheetName = "NurseSheetWard"; // 病区打印
        break;
      case "PAT":
        nurseSheetName = "NurseSheetPat"; // 患者打印
        break;
    }

    // 获取医院名称
    var getHospital = new Promise(function (resolve) {
      $m(
        {
          ClassName: "Nur.NIS.Service.OrderExcute.SheetNew",
          MethodName: "GetHospital",
          orderItemIdStr: oeoriIdStr.split("^")[0],
        },
        function (result) {
          resolve(result);
        }
      );
    });
    // 获取单据名称
    var getSheetName = new Promise(function (resolve) {
      $m(
        {
          ClassName: "Nur.NIS.Service.OrderExcute.SheetNew",
          MethodName: "GetSheetName",
          queryCode: queryTypeCode,
        },
        function (result) {
          resolve(result);
        }
      );
    });
    // 获取表头
    var getTableHead = new Promise(function (resolve) {
      $m(
        {
          ClassName: "Nur.NIS.Service.OrderExcute.SheetNew",
          MethodName: "GetQueryTitle",
          queryCode: queryTypeCode,
          orderItemIdStr: oeoriIdStr.split("^")[0],
        },
        function (result) {
          resolve(result);
        }
      );
    });
    // 获取所有需要打印的执行记录:orderNeedPrint
    var Chunks = splitChunk(oeoriIdStr.split("^"), 20);
    var ajaxConcurrency = function (chunk) {
      return new Promise(function (resolve) {
        $cm(
          {
            ClassName: "Nur.NIS.Service.OrderExcute.SheetNew",
            MethodName: "GetPrintOrderInfoJSON",
            orderIdStr: chunk.join("^"),
            queryCode: queryTypeCode,
            type: "",
          },
          function (result) {
            resolve(result);
          }
        );
      });
    };
    Promise.all(
      Chunks.map(function (item) {
        return ajaxConcurrency(item);
      })
    ).then(function (orderPromiseResult) {
      Promise.all([getHospital, getSheetName, getTableHead]).then(function (
        promiseResult
      ) {
        console.log(orderPromiseResult);
        console.log(promiseResult);
        var orderNeedPrint = [];
        orderPromiseResult.forEach(function (promiseResultItem) {
          promiseResultItem.forEach(function (ret) {
            var infoGroup = ret.trim().split("^");
            var infoDetail;
            var orderNeedPrintItem = {};
            for (var i = 0; i < infoGroup.length; i++) {
              infoDetail = infoGroup[i].split("@");
              if (infoDetail.length >= 2) {
                var value = infoDetail[1];
                if (
                  infoDetail[0] === "oeoriId" &&
                  infoDetail[1].indexOf("-") > -1
                ) {
                  value = infoDetail[1].replace(/-/g, "||");
                }
                orderNeedPrintItem[infoDetail[0]] = value;
              }
            }
            orderNeedPrint.push(orderNeedPrintItem);
          });
        });
        // console.log(orderNeedPrint);
        debugger;
        //
        //
        //
        var seqNo = seqNoStr.split("^");
        var oeoriId = oeoriIdStr.split("^");
        var patOrderId = seqNo.map(function (item) {
          return getID(item);
        });
        var orderId = oeoriId.map(function (item) {
          return getID(item);
        });
        // 获取数据：纸张尺寸
        var paperSize = window.formSheet.paperSize;
        // 实例化
        var LODOP = getLodop();
        // 设置打印机
        var PrtDevice = window.formSheet[nurseSheetName].config.printerName;
        var PrtDeviceIndex = -1; //设置默认打印机
        if (PrtDevice !== "") {
          PrtDevice = PrtDevice.toUpperCase();
          for (var j = 0; j < LODOP.GET_PRINTER_COUNT(); j++) {
            if (
              LODOP.GET_PRINTER_NAME(j).toUpperCase().indexOf(PrtDevice) > -1
            ) {
              PrtDeviceIndex = j;
              break;
            }
          }
        }
        // 获取打印机纸张尺寸
        // var PrtDevicePaperLength = LODOP.GET_PRINTER_NAME(
        //   PrtDeviceIndex + ":PaperLength"
        // );
        // var PrtDevicePaperWidth = LODOP.GET_PRINTER_NAME(
        //   PrtDeviceIndex + ":PaperWidth"
        // );
        // if (String(PrtDevicePaperLength) !== "0") {
        //   paperSize.height = parseInt(PrtDevicePaperLength, 10) / 10;
        // }
        // if (String(PrtDevicePaperWidth) !== "0") {
        //   paperSize.width = parseInt(PrtDevicePaperWidth, 10) / 10;
        // }
        // 纸张可用宽度
        paperSize.availableWidth =
          paperSize.width - parseInt(paperSize.padding, 10) * 2;
        // 纸张可用高度
        paperSize.availableHeight =
          paperSize.height - parseInt(paperSize.padding, 10) * 2;
        // 表格下文字
        var footerSize = window.formSheet.sheetFooterSize;
        // 抬头
        var titleSize = window.formSheet.sheetTitleSize;
        // 页脚页码
        var pageNum = window.formSheet.sheetPageNum;
        // 表格上文字
        var headInfo = window.formSheet[nurseSheetName].headInfo;
        // 表格尺寸
        var tableSize = window.formSheet[nurseSheetName].table;
        // 打印方式
        var printSheetType = window.config.printSheetType;
        // 需要打印的信息key值
        var infoItem = [];
        // 表头
        var tableInfo = promiseResult[2].trim().split("^");
        var tableInfoDetail = [];
        var tableHead = [];
        var tableHeadWidth = 0;
        var arcimDescColWidth = 0;
        var notesColWidth = 0;
        for (var i = 0; i < tableInfo.length; i++) {
          tableInfoDetail = tableInfo[i].split("|");
          if (tableInfoDetail.length > 1) {
            var code = tableInfoDetail[2].replace(/\s+/, "");
            tableHead.push({
              text: tableInfoDetail[0],
              width: parseFloat(tableInfoDetail[1]),
              code: code,
            });
            if (code !== "") {
              infoItem.push(code);
            }
            if (code === "arcimDescInfo") {
              // 医嘱列宽
              arcimDescColWidth = parseFloat(tableInfoDetail[1]);
            } else if (code === "notes") {
              // 备注列宽
              notesColWidth = parseFloat(tableInfoDetail[1]);
            }
            tableHeadWidth += parseFloat(tableInfoDetail[1]);
          }
        }
        // printSheetType:true 按执行记录打印日期模式
        if (printSheetType) {
          if (infoItem.indexOf("sttDate") === -1) {
            infoItem.push("sttDate");
          }
          infoItem.push("sttDatePrint");
          infoItem.push("sttTimePrint");
        }
        // 行高
        var rowHeight = tableSize.dataRowHeight;
        // 处理医嘱数据
        var orders = getOrders(patOrderId, orderId, oeoriId);
        var orderData = orders(orderNeedPrint, infoItem, printSheetType);
        for (var itemKey in orderData) {
          var itemOrderData = orderData[itemKey];
          var arcimDescRowNum = 0;
          var notesRowNum = 0;
          var itemContentTop = [0];
          if (
            itemOrderData.arcimDescInfo &&
            itemOrderData.arcimDescInfo !== ""
          ) {
            arcimDescRowNum += getSpecialLineFeed(
              arcimDescColWidth,
              tableSize.fontSize,
              itemOrderData.arcimDescInfo
            );
            itemContentTop.push(arcimDescRowNum * rowHeight);
          }
          if (itemOrderData.notes && itemOrderData.notes !== "") {
            notesRowNum = getSpecialLineFeed(
              notesColWidth,
              tableSize.fontSize,
              itemOrderData.notes
            );
          }
          if (itemOrderData.child && itemOrderData.child.length > 0) {
            itemOrderData.child.forEach(function (childItem) {
              if (childItem.arcimDescInfo && childItem.arcimDescInfo !== "") {
                arcimDescRowNum += getSpecialLineFeed(
                  arcimDescColWidth,
                  tableSize.fontSize,
                  childItem.arcimDescInfo
                );
                itemContentTop.push(arcimDescRowNum * rowHeight);
              }
            });
          }
          arcimDescRowNum =
            arcimDescRowNum > notesRowNum ? arcimDescRowNum : notesRowNum;
          itemOrderData.rowNum =
            arcimDescRowNum > itemOrderData.rowNum
              ? arcimDescRowNum
              : itemOrderData.rowNum;
          itemOrderData.itemContentTop = itemContentTop;
          if (itemOrderData.newRowNum === 1) {
            itemOrderData.newRowNum = 2;
          }
        }
        // 抬头
        function TitleInfo() {
          var titleText =
            promiseResult[0].trim() + " " + promiseResult[1].trim();
          var textPosition = getRowCenterTextPosition(
            titleSize.width,
            titleSize.fontSize,
            titleText
          );
          var a = [
            {
              x: textPosition.x,
              y: textPosition.y,
              width: titleSize.width,
              fontSize: titleSize.fontSize,
              fontFamily: titleSize.fontFamily,
              fontStyle: titleSize.fontStyle,
              text: textPosition.text,
            },
          ];
          this.content = a;
          this.height = titleSize.height;
          this.width = titleSize.width;
          this.left = titleSize.left;
          this.top = titleSize.top;
          this.printType = "TEXT";
        }
        // 表格上文字
        function HeadInfo(episodeId) {
          var orderInfo = orderNeedPrint.find(function (item) {
            return item.episodeId === episodeId;
          });
          var a = [];
          var printText;
          headInfo.content.forEach(function (item) {
            if (item.code === "userName") {
              printText = item.text + userName;
            } else if (item.code === "searchRange") {
              printText = item.text + searchRange;
            } else {
              printText = item.text + orderInfo[item.code];
            }
            a.push({
              y: item.y,
              x: item.x,
              width: item.width,
              fontSize: item.fontSize,
              fontFamily: item.fontFamily,
              fontStyle: item.fontStyle,
              text: printText,
            });
          });
          this.content = a;
          this.height = headInfo.height;
          this.width = headInfo.width;
          this.left = headInfo.left;
          this.top = headInfo.top;
          this.printType = "TEXT";
        }
        // 表头
        function TableHead() {
          var a = [];
          var positionX = 0;
          tableHead.forEach(function (item) {
            var textPosition = getTableHeadTextPosition(
              item.width,
              tableSize.headRowHeight,
              tableSize.fontSize,
              item.text
            );
            a.push({
              x: positionX,
              y: 0,
              fontSize: tableSize.fontSize,
              fontFamily: tableSize.fontFamily,
              fontStyle: tableSize.fontStyle,
              width: item.width,
              text: textPosition,
            });
            positionX += item.width;
          });
          this.content = a;
          this.height = tableSize.headRowHeight;
          this.width = tableHeadWidth;
          this.printType = "TABLE";
          this.left =
            paperSize.availableWidth > tableHeadWidth
              ? (paperSize.availableWidth - tableHeadWidth) / 2
              : 0;
          this.type = "tableHead";
        }
        // 医嘱信息表格
        function TableBody(obj, num, mergeContent) {
          var a = [];
          var tableContent = [];
          var tableHeadX = 0;
          var printText = "";
          var mergeTable;
          var showExec = false;
          tableHead.forEach(function (item) {
            mergeTable = false;
            if (item.code === "") {
              printText = obj["execInfos"].length;
              showExec = true;
            } else if (
              item.code === "patName" ||
              item.code === "bedCode" ||
              item.code === "age"
            ) {
              if (mergeContent) {
                printText = "";
              } else {
                printText = obj[item.code];
              }
              mergeTable = true;
            } else if (item.code === "sttDateTime") {
              if (printSheetType) {
                printText = reduceItemByDay(obj["execInfos"], item.code);
              } else {
                printText = obj["execInfos"].map(function (item) {
                  return item.sttDateTime;
                });
              }
              showExec = true;
            } else {
              printText = [obj[item.code]];
              if (
                obj["child"].length > 0 &&
                item.code !== "phcinDesc" &&
                item.code !== "phcfrCode"
              ) {
                obj["child"].forEach(function (childItem) {
                  printText.push(childItem[item.code]);
                });
              }
            }
            tableContent.push({
              code: item.code,
              merge: mergeTable,
              x: tableHeadX,
              width: item.width,
            });
            a.push({
              code: item.code,
              merge: mergeTable,
              x: tableHeadX,
              fontSize: tableSize.fontSize,
              fontFamily: tableSize.fontFamily,
              fontStyle: tableSize.fontStyle,
              width: item.width,
              text: printText,
              textNum: "",
              rowHeight: rowHeight * num,
              showExec: showExec,
            });
            tableHeadX += item.width;
          });
          this.content = [a];
          this.tableContent = tableContent;
          this.height = rowHeight * num;
          this.width = tableHeadWidth;
          this.printType = "TABLE";
          this.left =
            paperSize.availableWidth > tableHeadWidth
              ? (paperSize.availableWidth - tableHeadWidth) / 2
              : 0;
          this.type = "tableBody";
          this.itemContentTop = [obj.itemContentTop];
          this.contentTop = [0, rowHeight * num];
        }
        // 表格下文字
        function Footer() {
          var a = [];
          var printText;
          footerSize.content.forEach(function (item) {
            if (item.code === "title") {
              printText = item.text;
            } else if (item.code === "userName") {
              printText = item.text + userName;
            } else {
              printText = item.text + orderNeedPrint[0][item.code];
            }
            a.push({
              x: item.x,
              y: item.y,
              width: item.width,
              fontSize: item.fontSize,
              fontFamily: item.fontFamily,
              fontStyle: item.fontStyle,
              text: printText,
            });
          });
          this.content = a;
          this.height = footerSize.height;
          this.width = footerSize.width;
          this.left = footerSize.left;
          this.top = footerSize.top;
          this.printType = "TEXT";
        }
        // 页脚页码
        function PageNum(current, total) {
          var pageNumText = "第" + current + "页/共" + total + "页";
          var textPosition = getRowCenterTextPosition(
            pageNum.width,
            pageNum.fontSize,
            pageNumText
          );
          var a = [
            {
              x: textPosition.x,
              y: textPosition.y,
              width: pageNum.width,
              fontSize: pageNum.fontSize,
              fontFamily: pageNum.fontFamily,
              fontStyle: pageNum.fontStyle,
              text: textPosition.text,
            },
          ];
          this.content = a;
          this.height = pageNum.height;
          this.width = pageNum.width;
          this.left = pageNum.left;
          this.top = paperSize.availableHeight - pageNum.height;
          this.printType = "TEXT";
        }
        var allPage;
        if (printType === "PAT") {
          // 按患者打印
          allPage = createAllPagePAT(
            unique(patOrderId),
            orderData,
            paperSize,
            TitleInfo,
            HeadInfo,
            TableHead,
            TableBody,
            Footer,
            pageNum,
            tableSize
          );
        } else {
          // 按病区打印
          allPage = createAllPageWARD(
            unique(patOrderId),
            orderData,
            paperSize,
            TitleInfo,
            HeadInfo,
            TableHead,
            TableBody,
            Footer,
            pageNum,
            tableSize
          );
        }
        var footerObj;
        var pageNumObj;
        if (printType === "PAT") {
          // 按患者打印
          allPage.forEach(function (page, index) {
            // 插入每页最后一个表格的表格下文字
            footerObj = new Footer();
            footerObj.top +=
              page[page.length - 1].top + page[page.length - 1].height;
            page.push(footerObj);
            // 插入页脚页码
            pageNumObj = new PageNum(index + 1, allPage.length);
            page.push(pageNumObj);
          });
        } else {
          // 按病区打印 插入表格下文字
          allPage.forEach(function (page, index) {
            // 插入每页的表格下文字
            pageNumObj = new PageNum(index + 1, allPage.length);
            page.push(pageNumObj);
          });
        }
        printResult.state = -3;
        // 打印
        // 初始化
        LODOP.PRINT_INIT(nurseSheetName);
        // 设置打印机
        LODOP.SET_PRINTER_INDEX(PrtDeviceIndex);
        // 设置打印纸张
        LODOP.SET_PRINT_PAGESIZE(
          1,
          paperSize.width + "mm",
          paperSize.height + "mm",
          paperSize.name
        );
        // 设置初始字体(单位：pt)
        LODOP.SET_PRINT_STYLE("FontSize", 10);
        // 创建打印内容
        Print_Lodop(LODOP, allPage);
        printResult.state = -1;
        if (LODOP.CVERSION) {
          // cLodop使用回调函数获取打印结果
          CLODOP.On_Return = function (TaskID, Value) {
            if (Value) {
              printResult.state = 1;
            } else {
              printResult.state = 0;
            }
          };
          if (window.config.printView) {
            // 打印预览
            LODOP.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1);
            LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1); //横向时的正向显示
            LODOP.PREVIEW();
          } else {
            // 直接打印
            LODOP.PRINT();
          }
        } else {
          // IE
          if (window.config.printView) {
            // 打印预览
            LODOP.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1);
            LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1); //横向时的正向显示
            LODOP.PREVIEW();
            printResult.state = 1;
          } else {
            // 直接打印
            if (LODOP.PRINT()) {
              printResult.state = 1;
            } else {
              printResult.state = 0;
            }
          }
        }
      });
    });
  }
  function returnSheetPrintResult() {
    return printResult;
  }
  window.NurseSheetPrint = NurseSheetPrint;
  window.returnSheetPrintResult = returnSheetPrintResult;
})();
