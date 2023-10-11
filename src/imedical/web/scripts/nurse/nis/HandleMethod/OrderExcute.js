(function() {
  /**
   * @description 返回函数判断是否已经存取过同一天的执行记录
   * @returns  判断是否存取过同一天的执行记录的函数
   */
  function createIfOrderOfSameDateFunc() {
    var cacheDate = {};
    return function(sttDate, orderItemID) {
      var dateID = sttDate + "@" + orderItemID;
      if (cacheDate[dateID]) {
        return true;
      } else {
        cacheDate[dateID] = true;
      }
      return false;
    };
  }

  /**
   * @description 返回函数判断是否能打属于贴瓶签医嘱(iv.gtt,ivgtt化疗,iv.gtt(急诊),ivgtt小儿营养,入三升袋静点)
   * @returns  判断是否存属于贴瓶签医嘱 phcinDesc
   */
  function createIfInfusionLabelFunc() {
    const availableWays = [
      "iv.gtt",
      "ivgtt化疗",
      "iv.gtt(急诊)",
      "ivgtt小儿营养",
      "入三升袋静点"
    ];
    return function(order) {
      const orderUesWay = order.phcinDesc;
      if (orderUesWay !== "") {
        if (availableWays.indexOf(orderUesWay) > -1) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    };
  }

  /**
   * @description 返回函数判断是否能打属于注射贴/治疗贴医嘱,排除(iv.gtt,ivgtt化疗,iv.gtt(急诊),ivgtt小儿营养,入三升袋静点,po,喷吸,舌下含服)
   * @returns  判断是否存属于注射贴/治疗贴医嘱 phcinDesc
   */
  function createIfInfusionBarFunc() {
    const availableWays = [
      "iv.gtt",
      "ivgtt化疗",
      "iv.gtt(急诊)",
      "ivgtt小儿营养",
      "入三升袋静点",
      "po",
      "喷吸",
      "舌下含服"
    ];
    return function(order) {
      const orderUesWay = order.phcinDesc;
      if (orderUesWay !== "") {
        if (availableWays.indexOf(orderUesWay) < 0) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    };
  }

  /**
   * @description 返回函数判断频率是否全打,排除(Q1H,Q2H)
   * @returns  判断频率是否是要只打印一条 phcfrCode
   */
  function createIfAvailFregFunc() {
    const availableFregs = ["Q1H", "Q2H"];
    return function(order) {
      const phcfrCode = order.phcfrCode;
      if (phcfrCode !== "") {
        if (availableFregs.indexOf(phcfrCode) > -1) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    };
  }
  function filterByOrdProperty(ord, property, filter) {
    if (
      filter !== "" &&
      ord[property] &&
      filter.indexOf("^" + ord[property] + "^") !== -1
    ) {
      return true;
    } else {
      return false;
    }
  }
  function createSortHelpbject(filterByArcimItem, filterByOhcinDesc) {
    var data = [];
    data.sttDate = "1";

    function sortHelp() {
      this.dateArray = [];
      this.dateArray.push(data);
    }
    sortHelp.prototype.addExec = function(exec) {
      data.push(exec);
    };
    sortHelp.prototype.getIDData = function() {
      var execIDs = [];
      var execSeqIDs = [];
      var execLabNos = [];
      this.dateArray.sort(function(preData, nextData) {
        return parseInt(preData.sttDate, 10) - parseInt(nextData.sttDate, 10);
      });
      this.dateArray.forEach(function(data) {
        console.log(data);

        data.forEach(function(exec) {
          if (
            !filterByOrdProperty(exec, "cmArcim", filterByArcimItem) &&
            !filterByOrdProperty(exec, "cmOrdPhcin", filterByOhcinDesc)
          ) {
            execIDs.push(exec.ID);
            execSeqIDs.push(exec.ID);
            execLabNos.push(exec.labNo);
            if (exec.childs) {
              exec.childs.forEach(function(execChildID, index) {
                if (
                  !filterByOrdProperty(
                    exec.childsexecInfos[index],
                    "cmArcim",
                    filterByArcimItem
                  ) &&
                  !filterByOrdProperty(
                    exec.childsexecInfos[index],
                    "cmOrdPhcin",
                    filterByOhcinDesc
                  )
                ) {
                  execIDs.push(execChildID);
                  execSeqIDs.push(exec.ID);
                  execLabNos.push(exec.labNo);
                }
              });
            }
          }
        });
      });
      return {
        execIDs: execIDs,
        execSeqIDs: execSeqIDs,
        execLabNos: execLabNos
      };
    };
    return new sortHelp();
  }
  function createQuery(orders, check, printFlag, vueComponent) {
    /**
     * @description 取数据接口
     * @param {any} filteExecOfSameDate : 是否过滤同一天的执行记录
     * @param {any} searchOrderPrintFlag: 判断医嘱的打印标记,不传参数时默认查询执行记录的打印标记
     * @param {any} filtePrintedExec:     过滤已打印执行单的执行记录
     * @param {any} filteFlagExtend: 其他过滤标志(扩展)
     * @param {any} filteExecByOrderID: 选中的执行记录相同医嘱只传递一条执行记录
     * @param {any} filteByCategory:   根据医嘱类别判断(R:药品)
     * @param {any} filteInfusionLable: 根据用法过滤瓶签
     * @param {any} filteInfusionBar: 根据用法过滤注射贴/治疗贴
     * @param {any} filteByFreg: 根据频率过滤
     * @param {any} filteOrderSate: 根据过滤核实状态医嘱
     * @param {Array} filteOrderSate: 根据医嘱项过滤医嘱
     * @param {Array} filteOrderSate: 根据用法过滤医嘱
     * @returns  数据对象
     */
    return function queryDataNeedToBePrint(
      filteExecOfSameDate,
      searchOrderPrintFlag,
      filtePrintedExec,
      filteFlagExtend,
      filteExecByOrderID,
      filteByCategory,
      filteInfusionLable,
      filteInfusionBar,
      filteByFreg,
      filteOrderSate,
      filterDischarge,
      filterByArcimItem,
      filterByOhcinDesc,
      filteOrderSateException,
      filteOrderStt,
      moment
    ) {
      filteExecOfSameDate = filteExecOfSameDate || false;
      searchOrderPrintFlag = searchOrderPrintFlag || false;
      filtePrintedExec = filtePrintedExec || false;
      filteFlagExtend = filteFlagExtend || false;
      filteExecByOrderID = filteExecByOrderID || false;
      filteByCategory = filteByCategory || false;
      filteInfusionLable = filteInfusionLable || false;
      filteInfusionBar = filteInfusionBar || false;
      filteByFreg = filteByFreg || false;
      filteOrderSate = filteOrderSate || false;
      filterDischarge = filterDischarge || false;
      filteOrderStt = filteOrderStt || false;
      filterByArcimItem =
        filterByArcimItem !== "" ? "^" + filterByArcimItem + "^" : "";
      filterByOhcinDesc =
        filterByOhcinDesc !== "" ? "^" + filterByOhcinDesc + "^" : "";
      filteOrderSateException =
        filteOrderSateException !== ""
          ? "^" + filteOrderSateException + "^"
          : "";
      var episodeIDs = [];
      var orderIDs = [];
      var orderSeqIDs = [];
      var labNos = [];
      // var execIDs = [];
      // var execSeqIDs = [];
      var execIDsOfNoFilteringSameDate = [];
      var ordersNeedToBePrint = [];
      var ifOrderOfSameDateFunc = createIfOrderOfSameDateFunc();
      var sortHelp = createSortHelpbject(filterByArcimItem, filterByOhcinDesc);
      if (filteInfusionLable) {
        var ifInfusionLabelFunc = createIfInfusionLabelFunc();
      }
      if (filteInfusionBar) {
        var ifInfusionBarFunc = createIfInfusionBarFunc();
      }
      if (filteByFreg) {
        filteExecByOrderID = createIfAvailFregFunc();
      }
      orders.forEach(function(order) {
        //打勾就获取打勾的医嘱, 不打勾获取所有未置打印标记的医嘱
        if (
          (check && (order.check || order.indeterminate) && order.show) ||
          (printFlag !== "" &&
            searchOrderPrintFlag &&
            !check &&
            String(order.printFlag).indexOf(printFlag) === -1)
        ) {
          // 主医嘱-按医嘱项过滤打印
          // 主医嘱-按用法过滤打印
          if (
            filterByOrdProperty(order, "cmArcim", filterByArcimItem) ||
            filterByOrdProperty(order, "cmOrdPhcin", filterByOhcinDesc)
          ) {
            return;
          }
          var dischargePat =
            order.billStatus !== "B" && order.admVisitStatus === "D";
          if (!dischargePat || !filterDischarge) {
            if (printFlag === "P" && order.labNo === "") {
              /// 检验病历条码标本号为空时过滤
              return;
            }
            orderIDs.push(order.ID);
            orderSeqIDs.push(order.ID);
            labNos.push(order.labNo);
            if (episodeIDs.indexOf(order.episodeID) === -1) {
              episodeIDs.push(order.episodeID);
            }
            order.childs.forEach(function(orderChild) {
              if (
                !filterByOrdProperty(
                  orderChild,
                  "cmArcim",
                  filterByArcimItem
                ) &&
                !filterByOrdProperty(
                  orderChild,
                  "cmOrdPhcin",
                  filterByOhcinDesc
                )
              ) {
                // 子医嘱-按医嘱项过滤打印
                orderIDs.push(orderChild.ID);
                orderSeqIDs.push(order.ID);
                labNos.push(order.labNo);
              }
            });
            // 相同标本号的医嘱
            if (order.sameLabNoOrders && order.sameLabNoOrders.length !== 0) {
              order.sameLabNoOrders.forEach(function(sameLabNoOrder) {
                if (
                  !filterByOrdProperty(
                    sameLabNoOrder,
                    "cmArcim",
                    filterByArcimItem
                  ) &&
                  !filterByOrdProperty(
                    sameLabNoOrder,
                    "cmOrdPhcin",
                    filterByOhcinDesc
                  )
                ) {
                  orderIDs.push(sameLabNoOrder.ID);
                  orderSeqIDs.push(sameLabNoOrder.ID);
                  ordersNeedToBePrint.push(sameLabNoOrder);
                  labNos.push(sameLabNoOrder.labNo);
                }
              });
            }
            if (order.execInfos) {
              var execIndex = 0;
              order.execInfos.forEach(function(exec) {
                if (
                  (check &&
                    exec.check &&
                    ((filtePrintedExec &&
                      String(exec.printFlag).indexOf(printFlag) === -1) ||
                      !filtePrintedExec)) ||
                  (!check &&
                    !searchOrderPrintFlag &&
                    String(exec.printFlag).indexOf(printFlag) === -1)
                ) {
                  execIDsOfNoFilteringSameDate.push(exec.ID);
                  //相同标本号的医嘱
                  if (
                    order.sameLabNoOrders &&
                    order.sameLabNoOrders.length !== 0
                  ) {
                    order.sameLabNoOrders.forEach(function(sameLabNoOrder) {
                      if (sameLabNoOrder.execInfos) {
                        sameLabNoOrder.execInfos.forEach(function(exec) {
                          execIDsOfNoFilteringSameDate.push(exec.ID);
                        });
                      }
                    });
                  }
                  if (
                    (filteExecOfSameDate &&
                      !ifOrderOfSameDateFunc(exec.sttDate, order.ID)) ||
                    !filteExecOfSameDate
                  ) {
                    // sortHelp.addExec(exec);
                    if (
                      (filteFlagExtend && !(exec.filteFlagExtend === "JP")) ||
                      !filteFlagExtend
                    ) {
                      if (
                        (filteByCategory && exec.ordTyp === "R") ||
                        !filteByCategory
                      ) {
                        if (
                          (filteInfusionLable && ifInfusionLabelFunc(order)) ||
                          !filteInfusionLable
                        ) {
                          if (
                            (filteInfusionBar && ifInfusionBarFunc(order)) ||
                            !filteInfusionBar
                          ) {
                            if (
                              (filteOrderSate &&
                                (order.ordStatDesc ===
                                  vueComponent.$t("核实") ||
                                  filteOrderSateException.indexOf(
                                    "^" + exec.cmArcim + "^"
                                  ) !== -1)) ||
                              !filteOrderSate
                            ) {
                              if (
                                (filteOrderStt &&
                                  moment(new Date()) >
                                    moment(exec.sttDateTime)) ||
                                !filteOrderStt
                              ) {
                                if (typeof filteExecByOrderID === "function") {
                                  filteExecByOrderID = filteExecByOrderID(
                                    order
                                  );
                                }
                                if (
                                  (filteExecByOrderID && execIndex === 0) ||
                                  !filteExecByOrderID
                                ) {
                                  execIndex = execIndex + 1;
                                  sortHelp.addExec(exec);
                                  //相同标本号的医嘱
                                  if (
                                    order.sameLabNoOrders &&
                                    order.sameLabNoOrders.length !== 0
                                  ) {
                                    order.sameLabNoOrders.forEach(function(
                                      sameLabNoOrder
                                    ) {
                                      if (sameLabNoOrder.execInfos) {
                                        sameLabNoOrder.execInfos.forEach(
                                          function(exec) {
                                            sortHelp.addExec(exec);
                                          }
                                        );
                                      }
                                    });
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                  // }
                }
              });
            }
          }
        }
      });
      var execIDData = sortHelp.getIDData();
      var printDataObject = {
        //病人就诊号
        episodeIDs: episodeIDs,
        //打印时筛选出的医嘱ID
        orderIDs: orderIDs,
        //打印时筛选出的医嘱关联号ID
        orderSeqIDs: orderSeqIDs,
        //打印时筛选出的医嘱执行记录 ID
        execIDs: execIDData.execIDs,
        //打印时筛选出的医嘱执行记录关联号 ID
        execSeqIDs: execIDData.execSeqIDs,
        //打印输液卡等需要过滤同一天执行记录的执行单,打印只打印一条,但是过滤的同一天执行记录也需要置打印标记
        execIDsOfNoFilteringSameDate: execIDsOfNoFilteringSameDate,
        //打印时筛选出的医嘱关联的标本号 ID
        execLabNos: execIDData.execLabNos,
        //打印时筛选出的医嘱标本号
        labNos: labNos
      };
      return printDataObject;
    };
  }
  /**
   * @description 由OrderExcute.vue 调用,返回对应的处理函数
   * @param {any} buttonData 按钮
   * @param {any} vueComponent vue实例
   * @returns  点击按钮的对应处理函数
   */
  function handle(buttonData, vueComponent) {
    var data = vueComponent.orderList.data;
    var printFlag = buttonData.printFlag;
    var check = data.indeterminate || data.check;
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;
    if (!printFlag && !check) {
      return vueComponent.$t("请选择医嘱!");
    }
    var queryDataNeedToBePrint = createQuery(
      data.orders,
      check,
      printFlag,
      vueComponent
    );
    if (buttonData.jsFunction && this[buttonData.jsFunction]) {
      return this[buttonData.jsFunction](
        data.orders,
        check,
        printFlag,
        vueComponent,
        buttonData,
        queryDataNeedToBePrint
      );
    }
  }
  /**
   * @description 处理医嘱
   * @param {any} orders  医嘱对象数组
   * @param {any} check   有没有医嘱被选中
   * @param {any} printFlag 按钮设置信息里的打印标记
   * @param {any} vueComponent vue组件
   * @returns  需处理医嘱ID数组
   */
  function seeOrder(orders, check, printFlag, vueComponent) {
    var orderIDNeedToBeDispose = [];
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;
    orders.forEach(function(order) {
      if (order.check) {
        orderIDNeedToBeDispose.push(order.ID);
        if (order.sameLabNoOrders && order.sameLabNoOrders.length !== 0) {
          order.sameLabNoOrders.forEach(function(sameLabNoOrder) {
            orderIDNeedToBeDispose.push(sameLabNoOrder.ID);
          });
        }
      }
    });
    if (orderIDNeedToBeDispose.length === 0) {
      return vueComponent.$t("请选择需要处理的医嘱") + "!";
    }
    return {
      seeOrderList: orderIDNeedToBeDispose
    };
  }
  /**
   * @description 撤销处理医嘱
   * @returns  需撤销处理医嘱ID数组
   */
  function cancelSeeOrder(orders, check, printFlag, vueComponent) {
    var orderIDNeedToBeCancelDispose = [];
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;
    orders.forEach(function(order) {
      if (order.check) {
        orderIDNeedToBeCancelDispose.push(order.ID);
        if (order.sameLabNoOrders && order.sameLabNoOrders.length !== 0) {
          order.sameLabNoOrders.forEach(function(sameLabNoOrder) {
            orderIDNeedToBeCancelDispose.push(sameLabNoOrder.ID);
          });
        }
      }
    });
    if (orderIDNeedToBeCancelDispose.length === 0) {
      return vueComponent.$t("请选择需要处理的医嘱") + "!";
    }
    return {
      cancelSeeOrderList: orderIDNeedToBeCancelDispose
    };
  }

  /**
   * @description 执行医嘱、停止执行医嘱
   * @returns  需执行的执行记录ID数组与需停止执行的执行记录ID数组
   */
  function excuteOrder(orders, check, printFlag, vueComponent) {
    var execIDNeedToBeExcute = [];
    var execNotPrint = [];
    var execIDNotPrint = [];
    var execNeedToBeExcuteMap = {};
    var execIDNeedToBeDiscontinued = [];
    var execNeedToBeDiscontinuedMap = {};
    var doubleExec = [];
    var sheetCode = vueComponent.sheetCodeSelected;
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;
    var $notification = vueComponent.$notification;
    var skinOrdExecSequence = vueComponent.execConfig.skinOrdExecSequence;
    var needPrintSheetCode = ["JYD"];
    orders.forEach(function(order) {
      if ((order.check || order.indeterminate) && order.show) {
        order.execInfos.forEach(function(execInfo) {
          if (execInfo.check) {
            // debugger; //skinOrdExecSequence
            var disposeStatCode = execInfo.disposeStatCode;
            if (
              disposeStatCode === "Needless" ||
              disposeStatCode === "Immediate" ||
              disposeStatCode === "LongNew" ||
              disposeStatCode === "Temp" ||
              disposeStatCode === "LongUnnew" ||
              disposeStatCode === "SkinTestNorm" ||
              disposeStatCode === "SpecmentReject" ||
              disposeStatCode === "PreStopOrder" ||
              (disposeStatCode === "SkinTest" && skinOrdExecSequence == 0)
            ) {
              var printFlag = String(execInfo.printFlag);
              if (needPrintSheetCode.indexOf(sheetCode) > -1) {
                if (
                  printFlag.indexOf("P") > -1 ||
                  order.labOrdExecNeedPrintedFlag !== "Y"
                ) {
                  execIDNeedToBeExcute.push(execInfo.ID);
                  execNeedToBeExcuteMap[execInfo.ID] = order;
                  //相同标本号的医嘱
                  if (
                    order.sameLabNoOrders &&
                    order.sameLabNoOrders.length !== 0
                  ) {
                    order.sameLabNoOrders.forEach(function(sameLabNoOrder) {
                      if (sameLabNoOrder.execInfos) {
                        sameLabNoOrder.execInfos.forEach(function(
                          sameLabNoOrderExecInfo
                        ) {
                          if (sameLabNoOrder.doubleSign === "Y") {
                            doubleExec.push(sameLabNoOrderExecInfo.ID);
                          }
                          execIDNeedToBeExcute.push(sameLabNoOrderExecInfo.ID);
                          execNeedToBeExcuteMap[
                            sameLabNoOrderExecInfo.ID
                          ] = sameLabNoOrder;
                        });
                      }
                    });
                  }
                  //相同检查部位的执行记录
                  if (
                    execInfo.samePartExecInfos &&
                    execInfo.samePartExecInfos.length !== 0
                  ) {
                    execInfo.samePartExecInfos.forEach(function(samePartExec) {
                      execIDNeedToBeExcute.push(samePartExec.ID);
                      execNeedToBeExcuteMap[samePartExec.ID] = order;
                      if (order.doubleSign === "Y") {
                        doubleExec.push(samePartExec.ID);
                      }
                    });
                  }
                  if (order.doubleSign === "Y") {
                    doubleExec.push(execInfo.ID);
                  }
                } else {
                  if (execNotPrint.length < 10) {
                    if (execIDNotPrint.indexOf(order.ID) < 0) {
                      execIDNotPrint.push(order.ID);
                      execNotPrint.push(
                        order.arcimDesc + ":" + vueComponent.$t("未打印")
                      );
                    }
                  } else if (execNotPrint.length === 10) {
                    execNotPrint.push("......");
                  }
                }
              } else {
                execIDNeedToBeExcute.push(execInfo.ID);
                execNeedToBeExcuteMap[execInfo.ID] = order;
                //相同标本号的医嘱
                if (
                  order.sameLabNoOrders &&
                  order.sameLabNoOrders.length !== 0
                ) {
                  order.sameLabNoOrders.forEach(function(sameLabNoOrder) {
                    if (sameLabNoOrder.execInfos) {
                      sameLabNoOrder.execInfos.forEach(function(
                        sameLabNoOrderExecInfo
                      ) {
                        execIDNeedToBeExcute.push(sameLabNoOrderExecInfo.ID);
                        execNeedToBeExcuteMap[
                          sameLabNoOrderExecInfo.ID
                        ] = sameLabNoOrder;
                        if (sameLabNoOrder.doubleSign === "Y") {
                          doubleExec.push(sameLabNoOrderExecInfo.ID);
                        }
                      });
                    }
                  });
                }
                //相同检查部位的执行记录
                if (
                  execInfo.samePartExecInfos &&
                  execInfo.samePartExecInfos.length !== 0
                ) {
                  execInfo.samePartExecInfos.forEach(function(samePartExec) {
                    execIDNeedToBeExcute.push(samePartExec.ID);
                    execNeedToBeExcuteMap[samePartExec.ID] = order;
                    if (order.doubleSign === "Y") {
                      doubleExec.push(samePartExec.ID);
                    }
                  });
                }
                if (order.doubleSign === "Y") {
                  doubleExec.push(execInfo.ID);
                }
              }
            } else if (disposeStatCode === "Discontinue") {
              execIDNeedToBeDiscontinued.push(execInfo.ID);
              execNeedToBeDiscontinuedMap[execInfo.ID] = order;
              //相同标本号的医嘱
              if (order.sameLabNoOrders && order.sameLabNoOrders.length !== 0) {
                order.sameLabNoOrders.forEach(function(sameLabNoOrder) {
                  if (sameLabNoOrder.execInfos) {
                    sameLabNoOrder.execInfos.forEach(function(
                      sameLabNoOrderExecInfo
                    ) {
                      execIDNeedToBeDiscontinued.push(
                        sameLabNoOrderExecInfo.ID
                      );
                      execNeedToBeDiscontinuedMap[
                        sameLabNoOrderExecInfo.ID
                      ] = sameLabNoOrder;
                    });
                  }
                });
              }
              //相同检查部位的执行记录
              if (
                execInfo.samePartExecInfos &&
                execInfo.samePartExecInfos.length !== 0
              ) {
                execInfo.samePartExecInfos.forEach(function(samePartExec) {
                  execIDNeedToBeExcute.push(samePartExec.ID);
                  execNeedToBeExcuteMap[samePartExec.ID] = order;
                });
              }
            }
          } else {
            if (order.indeterminate && execInfo.examInfo) {
              if (execInfo.examInfo.examComm === "Y") {
                execIDNeedToBeExcute.push(execInfo.ID);
                execNeedToBeExcuteMap[execInfo.ID] = order;
              }
            }
          }
        });
      }
    });
    if (execNotPrint.length !== 0) {
      $notification.warning({
        message: vueComponent.$t("警告"),
        description: execNotPrint.join(" ")
      });
    }
    if (doubleExec.length === execIDNeedToBeExcute.length) {
      vueComponent.doubleSign = true;
    }
    if (
      execIDNeedToBeExcute.length === 0 &&
      execIDNeedToBeDiscontinued.length === 0
    ) {
      return vueComponent.$t("请选择符合要求的医嘱执行") + "!";
    }
    return {
      execOrderList: execIDNeedToBeExcute,
      execDisOrderList: execIDNeedToBeDiscontinued
    };
  }
  /**
   * @description 停止执行医嘱
   * @returns  需停止执行的执行记录ID数组
   */
  function stopExcuteOrder(orders, check, printFlag, vueComponent) {
    var execIDNeedToBeStop = [];
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;
    orders.forEach(function(order) {
      if (
        (order.check || order.indeterminate) &&
        order.oecprDesc.indexOf(vueComponent.$t("长期")) >= 0
      ) {
        order.execInfos.forEach(function(execInfo) {
          if (
            execInfo.check &&
            (execInfo.execStatusCode == "" || execInfo.execStatusCode == "C")
          ) {
            execIDNeedToBeStop.push(execInfo.ID);
          }
        });
      }
    });
    if (execIDNeedToBeStop.length === 0) {
      return vueComponent.$t("请选择需要停止执行的医嘱") + "!";
    }
    return {
      stopExecOrderList: execIDNeedToBeStop
    };
  }
  /**
   * @description 撤销执行医嘱
   * @returns  需撤销执行的执行记录ID数组
   */
  function cancelOrder(orders, check, printFlag, vueComponent) {
    var execIDNeedToBeCancel = [];
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;
    // var $t = vueComponent.$t;
    orders.forEach(function(order) {
      if (order.check || order.indeterminate) {
        order.execInfos.forEach(function(execInfo) {
          if (execInfo.check) {
            var disposeStatCode = execInfo.disposeStatCode;
            if (
              disposeStatCode === "Exec" ||
              disposeStatCode === "SpecmentReject" ||
              disposeStatCode === "RefuseDispDrug"
            ) {
              if (
                !(
                  execInfo.examInfo &&
                  execInfo.examInfo.examComm === "Y" &&
                  order.indeterminate
                )
              ) {
                //新检查申请按部位撤销判断
                execIDNeedToBeCancel.push(execInfo.ID);
              }
              //相同标本号的医嘱
              if (order.sameLabNoOrders && order.sameLabNoOrders.length !== 0) {
                order.sameLabNoOrders.forEach(function(sameLabNoOrder) {
                  if (sameLabNoOrder.execInfos) {
                    sameLabNoOrder.execInfos.forEach(function(
                      sameLabNoOrderExecInfo
                    ) {
                      execIDNeedToBeCancel.push(sameLabNoOrderExecInfo.ID);
                    });
                  }
                });
              }
              //相同检查部位的执行记录
              if (
                execInfo.samePartExecInfos &&
                execInfo.samePartExecInfos.length !== 0
              ) {
                execInfo.samePartExecInfos.forEach(function(samePartExec) {
                  if (
                    !(
                      samePartExec.examInfo &&
                      samePartExec.examInfo.examComm === "Y" &&
                      samePartExec.indeterminate
                    )
                  ) {
                    //新检查申请按部位撤销判断
                    execIDNeedToBeCancel.push(samePartExec.ID);
                  }
                });
              }
            }
          }
        });
      }
    });
    if (execIDNeedToBeCancel.length === 0) {
      return vueComponent.$t("请选择需要撤销执行的医嘱") + "!";
    }
    return {
      cancelExecOrderList: execIDNeedToBeCancel
    };
  }
  /**
   * @description 置皮试结果
   * @returns  需置皮试结果的执行记录ID
   */
  function setSkinTest(orders, check, printFlag, vueComponent) {
    // 执行和置皮试结果顺序 0:先执行后置皮试结果 1:置皮试结果同步执行
    var skinOrdExecSequence = vueComponent.execConfig.skinOrdExecSequence;
    var skinTestOrders = [];
    var doubleExec = [];
    var unExecutedOrds = [];
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;
    orders.forEach(function(order) {
      if (order.check || order.indeterminate) {
        var length = order.execInfos.length;
        for (var i = 0; i < length; i++) {
          var execInfo = order.execInfos[i];
          if (execInfo.check) {
            skinTestOrders.push(execInfo.ID);
            if (order.doubleSign === "Y") {
              doubleExec.push(execInfo.ID);
            }
            if (skinOrdExecSequence == 0 && execInfo.execStatusCode != "F") {
              unExecutedOrds.push(execInfo.ID);
            }
            break;
          }
        }
      }
    });
    if (skinTestOrders.length === 0) {
      return vueComponent.$t("请选择一条皮试医嘱置皮试结果") + "!";
    }
    if (skinTestOrders.length > 1) {
      return vueComponent.$t("请只选择一条皮试医嘱置皮试结果") + "!";
    }
    if (skinOrdExecSequence == 0 && unExecutedOrds.length > 0) {
      return vueComponent.$t("请先执行医嘱") + "!";
    }
    if (doubleExec.length === 1) {
      vueComponent.doubleSign = true;
    }
    return {
      skinTestOrder: skinTestOrders[0]
    };
  }
  /**
   * @description 关联预制条码的条码号
   */
  function setPlacerNo(
    updateOrder,
    vueComponent,
    _ref,
    orderItemData,
    inputPlaceNo
  ) {
    var ajax = _ref.ajax;
    var orderExcuteApi = _ref.orderExcuteApi;
    const placerNo = String(inputPlaceNo);
    // var $message = vueComponent.$message;
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;
    var order = orderItemData;
    // debugger;
    var labtrakNumberLength = tkMakeServerCall(
      "Nur.NIS.Service.OrderExcute.Print",
      "GetLabtrakNumberLength"
    );
    function matchSplacerNo(placerNo) {
      if (placerNo.length === Number(labtrakNumberLength)) {
        return true;
      } else {
        var errorInfo =
          vueComponent.$t("条码位数不对,应该为") +
          labtrakNumberLength +
          vueComponent.$t("位") +
          "!";
        vueComponent.msgContent = errorInfo;
        vueComponent.msgFlag = true;
        vueComponent.msgType = "error";
        // $message.error(errorInfo, 2);
        return false;
      }
    }
    if (labtrakNumberLength !== "") {
      if (!matchSplacerNo(placerNo, order)) {
        return;
      }
    }
    const userID = vueComponent.userID;
    const orderID = order.ID;
    const userDeptId = vueComponent.locID;
    const queryTypeCode = vueComponent.sheetCodeSelected;
    var updateSpacerThen = function(result) {
      if (String(result) === "0") {
        // $message.success(
        //   order.arcimDesc + vueComponent.$t("置采血时间成功") + "!"
        // );
        vueComponent.msgContent =
          order.arcimDesc + vueComponent.$t("置采血时间成功") + "!";
        vueComponent.msgFlag = true;
        vueComponent.msgType = "success";
        updateOrder();
      } else if (result !== undefined) {
        vueComponent.msgContent =
          order.arcimDesc + ":" + vueComponent.$t("置采血时间失败") + "!";
        vueComponent.msgFlag = true;
        vueComponent.msgType = "alert";
        // $message(
        //   order.arcimDesc + ":" + vueComponent.$t("置采血时间失败") + "!"
        // );
        updateOrder();
      }
    };
    var orderexecInfosID;
    if (vueComponent.orderShowMode) {
      orderexecInfosID = order.ID;
    } else {
      orderexecInfosID = order.execInfos[0].ID;
    }
    ajax(orderExcuteApi.setPlacerNo, userID, orderID, placerNo, "N", userDeptId)
      .then(function(ret) {
        if (String(ret) !== "0") {
          order.placerNo = "";
          vueComponent.msgContent = String(ret);
          vueComponent.msgFlag = true;
          vueComponent.msgType = "error";
          // $message.error(String(ret));
        } else {
          var labNo = order.labNo;
          var orders = vueComponent.orderList.data.orders;
          var focus = false;
          orders.forEach(function(orderObject) {
            if (labNo === orderObject.labNo) {
              orderObject.check = true;
              orderObject.placerNo = placerNo;
              orderObject.indeterminate = false;
              orderObject.execInfos.forEach(function(exec) {
                exec.check = true;
              });
            }
            if (
              labNo !== orderObject.labNo &&
              !focus &&
              orderObject.placerNo === ""
            ) {
              orderObject.focus = !orderObject.focus;
              focus = true;
            }
          });
          //非急查到这里结束
          if (order.emergency === "Y") {
            //急查需要立即对需要置备注的检验置上备注
            return order.containerInfo && order.containerInfo.requireNotes;
          }
          return false;
        }
      })
      .then(function(result) {
        if (result === true) {
          var ID = orderID.split("||")[0];
          vueComponent.$nextTick(function() {
            order.patient = vueComponent.orderIDMapPatient[ID];
            vueComponent.ordersOfOrderSetPlacerNotes = [order];
            vueComponent.funcOfOrderSetPlacerNotes = function() {
              return ajax(
                orderExcuteApi.updateSpacer,
                orderexecInfosID,
                userID
              ).then(updateSpacerThen);
            };
          });
        } else if (result === false) {
          //不需要置备注,立即置采血时间
          return ajax(
            orderExcuteApi.updateSpacer,
            orderexecInfosID,
            userID,
            userDeptId,
            queryTypeCode
          );
        }
      })
      .then(updateSpacerThen);
  }

  /**
   * @description 撤销条码关联
   * @returns 需撤销条码关联的执行记录ID数组
   */
  function clearPlacerNo(orders, check, printFlag, vueComponent) {
    var orderExecIDNeedToBeClear = [];
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;
    orders.forEach(function(order) {
      if (order.check && check) {
        order.execInfos.forEach(function(execInfo) {
          if (execInfo.check) {
            orderExecIDNeedToBeClear.push(execInfo.ID);
          }
        });
      }
    });
    if (orderExecIDNeedToBeClear.length === 0) {
      return vueComponent.$t("请选择需要撤销条码关联的医嘱") + "!";
    }

    return {
      clearPlacerNo: orderExecIDNeedToBeClear
    };
  }
  function splitArr(arr, num) {
    var newArr = [];
    for (var i = 0; i < arr.length; ) {
      newArr.push(arr.slice(i, (i += num)));
    }
    return newArr;
  }
  /**
   * @description 置打印标记
   */
  function setOrderPrintFlag(
    _ref,
    execNotFilterChunks,
    printFlag,
    info,
    updateOrder,
    vueComponent
  ) {
    var ajax = _ref.ajax;
    var axios = _ref.axios;
    var orderExcuteApi = _ref.orderExcuteApi;
    var savePrintFlagPromises = [];
    var userID = info.userID1 || info.loginUserID || "";
    var queryTypeCode = info.queryTypeCode || "";
    // var $message = vueComponent.$message;
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;

    var splitNotFilterChunks = splitArr(execNotFilterChunks, 20);
    var splitChunks = splitNotFilterChunks.map(function(item) {
      return item.join("^");
    });
    splitChunks.forEach(function(chunk) {
      savePrintFlagPromises.push(
        ajax(
          orderExcuteApi.setOrderPrintFlag,
          chunk,
          userID,
          queryTypeCode,
          printFlag
        )
      );
    });
    axios.all(savePrintFlagPromises).then(function(ret) {
      var result = ret.every(function(val) {
        return String(val) === "0";
      });
      if (result) {
        vueComponent.msgContent = vueComponent.$t("打印成功");
        vueComponent.msgFlag = true;
        vueComponent.msgType = "success";
      } else {
        vueComponent.msgContent = vueComponent.$t("打印成功，置标记失败");
        vueComponent.msgFlag = true;
        vueComponent.msgType = "error";
      }
      sessionStorage.setItem("printStatusCode", 0);
      vueComponent.spinning = false;
      updateOrder();
    });
  }
  /**
   * @description 置打印标记
   */
  function setExecPrintFlag(
    _ref,
    execNotFilterChunks,
    printFlag,
    info,
    updateOrder,
    vueComponent
  ) {
    var ajax = _ref.ajax;
    var axios = _ref.axios;
    var orderExcuteApi = _ref.orderExcuteApi;
    var savePrintFlagPromises = [];
    var userID = info.userID1 || info.loginUserID || "";
    var queryTypeCode = info.queryTypeCode || "";
    // var $message = vueComponent.$message;
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;

    var splitNotFilterChunks = splitArr(execNotFilterChunks, 20);
    var splitChunks = splitNotFilterChunks.map(function(item) {
      return item.join("^");
    });
    splitChunks.forEach(function(chunk) {
      savePrintFlagPromises.push(
        ajax(
          orderExcuteApi.setExecPrintFlag,
          chunk,
          userID,
          queryTypeCode,
          printFlag
        )
      );
    });
    axios.all(savePrintFlagPromises).then(function(ret) {
      var result = ret.every(function(val) {
        return String(val) === "0";
      });
      if (result) {
        vueComponent.msgContent = vueComponent.$t("打印成功");
        vueComponent.msgFlag = true;
        vueComponent.msgType = "success";
      } else {
        vueComponent.msgContent = vueComponent.$t("打印成功，置标记失败");
        vueComponent.msgFlag = true;
        vueComponent.msgType = "error";
      }
      sessionStorage.setItem("printStatusCode", 0);
      vueComponent.spinning = false;
      updateOrder();
    });
  }
  /**
   * @description 检验条码打印
   */
  function lisBarPrintComm(
    vueComponent,
    updateOrder,
    _ref,
    oeordIdGroup,
    printFlag,
    info,
    sheetID
  ) {
    // 置打印标记
    var timeStamp = new Date().getTime();
    var setPrintFlagList = oeordIdGroup.join("^").split("^");
    function getResultStatus() {
      if (printComm) {
        var nurPrtCommResult = window.getNurPrtCommResult();
        if (nurPrtCommResult.statusCode === 1) {
          setExecPrintFlag(
            _ref,
            setPrintFlagList,
            printFlag,
            info,
            updateOrder,
            vueComponent
          );
          printComm = false;
        } else if (nurPrtCommResult.statusCode === 2) {
          vueComponent.msgContent = vueComponent.$t(nurPrtCommResult.msg) + "!";
          vueComponent.msgFlag = true;
          vueComponent.msgType = "info";
          printComm = false;
          vueComponent.spinning = false;
          sessionStorage.setItem("printStatusCode", 0);
          updateOrder();
        } else if (nurPrtCommResult.statusCode < 0) {
          vueComponent.msgContent = vueComponent.$t(nurPrtCommResult.msg) + "!";
          vueComponent.msgFlag = true;
          vueComponent.msgType = "error";
          printComm = false;
          sessionStorage.setItem("printStatusCode", 0);
          updateOrder();
        } else {
          var timeNow = new Date().getTime();
          if (timeNow - timeStamp > 120000) {
            vueComponent.msgContent = vueComponent.$t("打印超时") + "!";
            vueComponent.msgFlag = true;
            vueComponent.msgType = "error";
            printComm = false;
            sessionStorage.setItem("printStatusCode", 0);
            updateOrder();
          }
        }
      } else {
        clearInterval(getResultTimer);
      }
    }
    if (window.NurPrtComm) {
      sessionStorage.setItem("printStatusCode", 1);
      var printComm = true;
      window.resetNurPrtCommResult();
      window.NurPrtComm(_ref, vueComponent.utils, sheetID, oeordIdGroup);
      var getResultTimer = setInterval(getResultStatus, 500);
    } else {
      vueComponent.msgContent =
        vueComponent.$t("没有维护相关单据打印函数") + "!";
      vueComponent.msgFlag = true;
      vueComponent.msgType = "error";
      return;
    }
  }
  /**
   * @description 检验条码打印合管
   */
  function lisBarPrintMerge(
    orders,
    check,
    printFlag,
    vueComponent,
    buttonData,
    queryDataNeedToBePrint
  ) {
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;
    var filterByArcimItem = vueComponent.prtConfig["Other"]
      ? vueComponent.prtConfig["Other"]["ARCIM"]
        ? vueComponent.prtConfig["Other"]["ARCIM"]
        : ""
      : "";
    var filterByOhcinDesc = vueComponent.prtConfig["Other"]
      ? vueComponent.prtConfig["Other"]["Instr"]
        ? vueComponent.prtConfig["Other"]["Instr"]
        : ""
      : "";
    var filteOrderSate =
      vueComponent.prtConfig["filteOrderSate"] === "Y" ? true : false;
    var filteOrderSateException =
      vueComponent.prtConfig["filteOrderSateException"];
    var filteOrderStt =
      vueComponent.prtConfig["filteOrderStt"] === "Y" ? true : false;
    var moment = vueComponent.moment;
    var printDateObject = queryDataNeedToBePrint(
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      filteOrderSate,
      vueComponent.execConfig.printSetting,
      filterByArcimItem,
      filterByOhcinDesc,
      filteOrderSateException,
      filteOrderStt,
      moment
    );
    var execIDList = printDateObject.execIDs;
    var labNoList = printDateObject.execLabNos;
    var orderIds = printDateObject.orderIDs;
    if (execIDList.length === 0) {
      return vueComponent.$t("未选择医嘱,或者选择的医嘱不满足打印条件") + "!";
    }
    // vueComponent.seqIDNeedToBePrint = labNoList;
    vueComponent.orderIds = orderIds;
    var sheetID = buttonData.formWorkId;
    if (sheetID === "") {
      return vueComponent.$t("获取打印模板失败") + "!";
    }
    return function(updateOrder, _ref, info, isNeedToDeal) {
      var ajax = _ref.ajax;
      var orderExcuteApi = _ref.orderExcuteApi;
      var oeordIdGroup;
      vueComponent.spinning = true;
      if (isNeedToDeal === "Y") {
        // 先处理再打印
        var userID = info.userID1 || "";
        var locID = info.locID || "";
        var oeoriIdStrNeedToDeal = info.oeoriIdStr;
        ajax(
          orderExcuteApi.seeOrdersAndGetPrint,
          oeoriIdStrNeedToDeal,
          userID,
          locID,
          labNoList.join("^")
        ).then(function(seeOrderRet) {
          // 处理医嘱失败
          if (String(seeOrderRet.success) !== "0") {
            vueComponent.msgContent = vueComponent.$t("处理失败") + "!";
            vueComponent.msgFlag = true;
            vueComponent.msgType = "error";
          } else {
            // 处理医嘱成功并打印
            oeordIdGroup = seeOrderRet.needPrintID;
            lisBarPrintComm(
              vueComponent,
              updateOrder,
              _ref,
              oeordIdGroup,
              printFlag,
              info,
              sheetID
            );
          }
        });
      } else {
        //打印
        var obj = {};
        for (var j = 0; j < labNoList.length; j++) {
          var singleLabNo = labNoList[j];
          if (obj[singleLabNo]) {
            obj[singleLabNo] = obj[singleLabNo] + "^" + execIDList[j];
          } else {
            obj[singleLabNo] = execIDList[j];
          }
        }
        oeordIdGroup = [];
        for (var k in obj) {
          if (obj[k] !== "") {
            oeordIdGroup.push(obj[k]);
          }
        }
        lisBarPrintComm(
          vueComponent,
          updateOrder,
          _ref,
          oeordIdGroup,
          printFlag,
          info,
          sheetID
        );
      }
    };
  }
  /**
   * @description 病理条码打印
   */
  function pathBarPrint(
    orders,
    check,
    printFlag,
    vueComponent,
    buttonData,
    queryDataNeedToBePrint
  ) {
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;
    var printDateObject = queryDataNeedToBePrint(
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      true,
      vueComponent.execConfig.printSetting,
      "",
      "",
      ""
    );
    // 所有医嘱执行记录ID
    var execIDList = printDateObject.execIDs;
    // 主医嘱执行记录ID
    var execSeqIDList = printDateObject.execSeqIDs;
    // 医嘱ID
    var orderIds = printDateObject.orderIDs;
    if (execIDList.length === 0) {
      return vueComponent.$t("未选择医嘱,或者选择的医嘱不满足打印条件") + "!";
    }
    return function(updateOrder, _ref, info) {
      // 病理条码打印调用医生站接口
      orderIds.forEach(function(orderId) {
        PrintBarCode(orderId, "");
      });
      setExecPrintFlag(
        _ref,
        unique(execSeqIDList),
        printFlag,
        info,
        updateOrder,
        vueComponent
      );
    };
  }
  /**
   * @description 确认费用
   * @returns  需确认费用医嘱ID数组
   */
  function confirmFee(orders, check, printFlag, vueComponent) {
    var orderIDNeedToConfirm = [];
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;
    orders.forEach(function(order) {
      if (order.check) {
        orderIDNeedToConfirm.push(order.ID);
        if (order.sameLabNoOrders && order.sameLabNoOrders.length !== 0) {
          order.sameLabNoOrders.forEach(function(sameLabNoOrder) {
            orderIDNeedToConfirm.push(sameLabNoOrder.ID);
          });
        }
      }
    });
    if (orderIDNeedToConfirm.length === 0) {
      return vueComponent.$t("请选择需要确认的医嘱") + "!";
    }
    return {
      confirmFeeList: orderIDNeedToConfirm
    };
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
   * @description 其他打印
   */
  function commonPrint(
    orders,
    check,
    printFlag,
    vueComponent,
    buttonData,
    queryDataNeedToBePrint
  ) {
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;
    var filterByArcimItem = vueComponent.prtConfig["Other"]
      ? vueComponent.prtConfig["Other"]["ARCIM"]
        ? vueComponent.prtConfig["Other"]["ARCIM"]
        : ""
      : "";
    var filterByOhcinDesc = vueComponent.prtConfig["Other"]
      ? vueComponent.prtConfig["Other"]["Instr"]
        ? vueComponent.prtConfig["Other"]["Instr"]
        : ""
      : "";
    var printDateObject = queryDataNeedToBePrint(
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      vueComponent.execConfig.printSetting,
      filterByArcimItem,
      filterByOhcinDesc,
      ""
    );
    var orderExecIDNeedToBePrint = printDateObject.execIDs;
    var seqIDNeedToBePrint = printDateObject.execSeqIDs;
    if (orderExecIDNeedToBePrint.length === 0) {
      return vueComponent.$t("未选择医嘱,或者选择的医嘱不满足打印条件") + "!";
    }
    if (
      buttonData.isSingleCheck === "Y" &&
      unique(seqIDNeedToBePrint).length > 1
    ) {
      return vueComponent.$t("请只选则一条医嘱打印设计") + "!";
    }
    var sheetID = buttonData.formWorkId;
    if (sheetID === "") {
      return vueComponent.$t("获取打印模板失败") + "!";
    }
    return function(updateOrder, _ref, info) {
      var oeordIdArr = [];
      var oeordIdArrIndex = -1;
      seqIDNeedToBePrint.reduce(function(lastSeqId, seqID, index) {
        if (seqID !== lastSeqId) {
          oeordIdArrIndex++;
          oeordIdArr[oeordIdArrIndex] = orderExecIDNeedToBePrint[index];
        } else {
          oeordIdArr[oeordIdArrIndex] += "^" + orderExecIDNeedToBePrint[index];
        }
        return seqID;
      }, "");
      var timeStamp = new Date().getTime();
      function getResultStatus() {
        if (printComm) {
          var nurPrtCommResult = window.getNurPrtCommResult();
          if (nurPrtCommResult.statusCode === 1) {
            setExecPrintFlag(
              _ref,
              unique(seqIDNeedToBePrint),
              printFlag,
              info,
              updateOrder,
              vueComponent
            );
            printComm = false;
          } else if (nurPrtCommResult.statusCode === 2) {
            vueComponent.msgContent =
              vueComponent.$t(nurPrtCommResult.msg) + "!";
            vueComponent.msgFlag = true;
            vueComponent.msgType = "info";
            printComm = false;
            vueComponent.spinning = false;
            sessionStorage.setItem("printStatusCode", 0);
            updateOrder();
          } else if (nurPrtCommResult.statusCode < 0) {
            vueComponent.msgContent =
              vueComponent.$t(nurPrtCommResult.msg) + "!";
            vueComponent.msgFlag = true;
            vueComponent.msgType = "error";
            printComm = false;
            vueComponent.spinning = false;
            sessionStorage.setItem("printStatusCode", 0);
            updateOrder();
          } else {
            var timeNow = new Date().getTime();
            if (timeNow - timeStamp > 120000) {
              vueComponent.msgContent = vueComponent.$t("打印超时") + "!";
              vueComponent.msgFlag = true;
              vueComponent.msgType = "error";
              printComm = false;
              vueComponent.spinning = false;
              sessionStorage.setItem("printStatusCode", 0);
              updateOrder();
            }
          }
        } else {
          clearInterval(getResultTimer);
        }
      }
      if (window.NurPrtComm) {
        sessionStorage.setItem("printStatusCode", 1);
        vueComponent.spinning = true;
        var printComm = true;
        window.resetNurPrtCommResult();
        window.NurPrtComm(_ref, vueComponent.utils, sheetID, oeordIdArr);
        var getResultTimer = setInterval(getResultStatus, 500);
      } else {
        // $message.error(vueComponent.$t("没有维护相关单据打印函数"));
        vueComponent.msgContent =
          vueComponent.$t("没有维护相关单据打印函数") + "!";
        vueComponent.msgFlag = true;
        vueComponent.msgType = "error";
        return;
      }
    };
  }
  /**
   * @description 执行单打印
   */
  function sheetPrint(
    orders,
    check,
    printFlag,
    vueComponent,
    buttonData,
    queryDataNeedToBePrint
  ) {
    var sheetCode = vueComponent.sheetCodeSelected;
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;
    var printDateObject = null;
    var filterByArcimItem = vueComponent.prtConfig["ZXD"]
      ? vueComponent.prtConfig["ZXD"]["ARCIM"]
        ? vueComponent.prtConfig["ZXD"]["ARCIM"]
        : ""
      : "";
    var filterByOhcinDesc = vueComponent.prtConfig["ZXD"]
      ? vueComponent.prtConfig["ZXD"]["Instr"]
        ? vueComponent.prtConfig["ZXD"]["Instr"]
        : ""
      : "";
    if (sheetCode !== "PSD") {
      printDateObject = queryDataNeedToBePrint(
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        vueComponent.execConfig.printSetting,
        filterByArcimItem,
        filterByOhcinDesc,
        ""
      );
    } else {
      printDateObject = queryDataNeedToBePrint(
        false,
        false,
        false,
        false,
        true,
        false,
        false,
        false,
        false,
        false,
        vueComponent.execConfig.printSetting,
        filterByArcimItem,
        filterByOhcinDesc,
        ""
      );
    }
    // 主子医嘱执行记录ID
    var execIDNeedToBePrint = printDateObject.execIDs;
    // 主医嘱执行记录ID
    var execSeqIDNeedToBePrint = printDateObject.execSeqIDs;
    // 条码号
    var labNoList = printDateObject.execLabNos;
    // 就诊号
    var episodeIDs = printDateObject.episodeIDs;
    if (execIDNeedToBePrint.length === 0) {
      return vueComponent.$t("未选择医嘱,或者选择的医嘱不满足打印条件") + "!";
    }
    var sheetID = buttonData.formWorkId;
    if (sheetID === "") {
      return vueComponent.$t("获取打印模板失败") + "!";
    }
    return function(updateOrder, _ref, info) {
      // 判断是否有需要合管的医嘱
      var isMergeLab = labNoList.every(function(item) {
        return item === "";
      });
      if (!isMergeLab) {
        var obj = {};
        labNoList.forEach(function(item, index) {
          if (item) {
            if (obj[item]) {
              execSeqIDNeedToBePrint.splice(index, 1, obj[item]);
            } else {
              obj[item] = execSeqIDNeedToBePrint[index];
            }
          }
        });
      }
      var userName = info.userName || "";
      var startDate =
        vueComponent.moment(info.searchInfo.startDate).format("YYYY-MM-DD") ||
        "";
      var endDate =
        vueComponent.moment(info.searchInfo.endDate).format("YYYY-MM-DD") || "";
      var startTime = info.searchInfo.startTime.format("HH:mm") || "";
      var endTime = info.searchInfo.endTime.format("HH:mm") || "";
      var searchRange =
        startDate.split("-")[1] +
        "-" +
        startDate.split("-")[2] +
        " " +
        startTime +
        "～" +
        endDate.split("-")[1] +
        "-" +
        endDate.split("-")[2] +
        " " +
        endTime;
      var timeStamp = new Date().getTime();
      function getResultStatus() {
        if (printComm) {
          var sheetPrintResult = window.getSheetPrintResult();
          if (sheetPrintResult.statusCode === 1) {
            setExecPrintFlag(
              _ref,
              unique(execSeqIDNeedToBePrint),
              printFlag,
              info,
              updateOrder,
              vueComponent
            );
            printComm = false;
          } else if (sheetPrintResult.statusCode === 2) {
            vueComponent.msgContent =
              vueComponent.$t(sheetPrintResult.msg) + "!";
            vueComponent.msgFlag = true;
            vueComponent.msgType = "info";
            printComm = false;
            vueComponent.spinning = false;
            sessionStorage.setItem("printStatusCode", 0);
            updateOrder();
          } else if (sheetPrintResult.statusCode < 0) {
            vueComponent.msgContent =
              vueComponent.$t(sheetPrintResult.msg) + "!";
            vueComponent.msgFlag = true;
            vueComponent.msgType = "error";
            printComm = false;
            vueComponent.spinning = false;
            sessionStorage.setItem("printStatusCode", 0);
            updateOrder();
          } else {
            var timeNow = new Date().getTime();
            if (timeNow - timeStamp > 120000) {
              vueComponent.msgContent = vueComponent.$t("打印超时") + "!";
              vueComponent.msgFlag = true;
              vueComponent.msgType = "error";
              printComm = false;
              vueComponent.spinning = false;
              sessionStorage.setItem("printStatusCode", 0);
              updateOrder();
            }
          }
        } else {
          clearInterval(getResultTimer);
        }
      }

      if (window.SheetPrint) {
        sessionStorage.setItem("printStatusCode", 1);
        vueComponent.spinning = true;
        var printComm = true;
        window.resetSheetPrintResult();
        window.SheetPrint(
          _ref,
          vueComponent.utils,
          execIDNeedToBePrint.join("^"),
          execSeqIDNeedToBePrint.join("^"),
          episodeIDs.join("^"),
          sheetID,
          userName,
          searchRange
        );
        var getResultTimer = setInterval(getResultStatus, 500);
      } else {
        // $message.error(vueComponent.$t("没有维护相关单据打印函数"));
        // window.printStatusCode = 0;
        vueComponent.msgContent =
          vueComponent.$t("没有维护相关单据打印函数") + "!";
        vueComponent.msgFlag = true;
        vueComponent.msgType = "error";
        return;
      }
    };
  }
  /**
   * @description 输液卡打印
   */
  function cardPrint(
    orders,
    check,
    printFlag,
    vueComponent,
    buttonData,
    queryDataNeedToBePrint
  ) {
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;
    var filterByArcimItem = vueComponent.prtConfig["SYK"]
      ? vueComponent.prtConfig["SYK"]["ARCIM"]
        ? vueComponent.prtConfig["SYK"]["ARCIM"]
        : ""
      : "";
    var filterByOhcinDesc = vueComponent.prtConfig["SYK"]
      ? vueComponent.prtConfig["SYK"]["Instr"]
        ? vueComponent.prtConfig["SYK"]["Instr"]
        : ""
      : "";
    var printDateObject = queryDataNeedToBePrint(
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      vueComponent.execConfig.printSetting,
      filterByArcimItem,
      filterByOhcinDesc,
      ""
    );
    // 主子医嘱执行记录ID
    var execIDNeedToBePrint = printDateObject.execIDs;
    // 主医嘱执行记录ID
    var execSeqIDNeedToBePrint = printDateObject.execSeqIDs;
    // 就诊号
    var episodeIDs = printDateObject.episodeIDs;
    if (execIDNeedToBePrint.length === 0) {
      return vueComponent.$t("未选择医嘱,或者选择的医嘱不满足打印条件") + "!";
    }
    var sheetID = buttonData.formWorkId;
    if (sheetID === "") {
      return vueComponent.$t("获取打印模板失败") + "!";
    }
    return function(updateOrder, _ref, info) {
      var userName = info.userName || "";
      var startDate =
        vueComponent.moment(info.searchInfo.startDate).format("YYYY-MM-DD") ||
        "";
      var endDate =
        vueComponent.moment(info.searchInfo.endDate).format("YYYY-MM-DD") || "";
      var startTime = info.searchInfo.startTime.format("HH:mm") || "";
      var endTime = info.searchInfo.endTime.format("HH:mm") || "";
      var searchRange =
        startDate.split("-")[1] +
        "-" +
        startDate.split("-")[2] +
        " " +
        startTime +
        "～" +
        endDate.split("-")[1] +
        "-" +
        endDate.split("-")[2] +
        " " +
        endTime;
      var timeStamp = new Date().getTime();
      function getResultStatus() {
        if (printComm) {
          var cardPrintReuslt = window.getCardPrintResult();
          if (cardPrintReuslt.statusCode === 1) {
            setExecPrintFlag(
              _ref,
              unique(execSeqIDNeedToBePrint),
              printFlag,
              info,
              updateOrder,
              vueComponent
            );
            printComm = false;
          } else if (cardPrintReuslt.statusCode === 2) {
            vueComponent.msgContent =
              vueComponent.$t(cardPrintReuslt.msg) + "!";
            vueComponent.msgFlag = true;
            vueComponent.msgType = "info";
            printComm = false;
            vueComponent.spinning = false;
            sessionStorage.setItem("printStatusCode", 0);
            updateOrder();
          } else if (cardPrintReuslt.statusCode < 0) {
            vueComponent.msgContent =
              vueComponent.$t(cardPrintReuslt.msg) + "!";
            vueComponent.msgFlag = true;
            vueComponent.msgType = "error";
            printComm = false;
            vueComponent.spinning = false;
            sessionStorage.setItem("printStatusCode", 0);
            updateOrder();
          } else {
            var timeNow = new Date().getTime();
            if (timeNow - timeStamp > 120000) {
              vueComponent.msgContent = vueComponent.$t("打印超时") + "!";
              vueComponent.msgFlag = true;
              vueComponent.msgType = "error";
              printComm = false;
              vueComponent.spinning = false;
              sessionStorage.setItem("printStatusCode", 0);
              updateOrder();
            }
          }
        } else {
          clearInterval(getResultTimer);
        }
      }
      if (window.CardPrint) {
        sessionStorage.setItem("printStatusCode", 1);
        vueComponent.spinning = true;
        var printComm = true;
        window.resetCardPrintResult();
        window.CardPrint(
          _ref,
          vueComponent.utils,
          execIDNeedToBePrint.join("^"),
          execSeqIDNeedToBePrint.join("^"),
          episodeIDs.join("^"),
          sheetID,
          userName,
          searchRange
        );
        var getResultTimer = setInterval(getResultStatus, 500);
      } else {
        vueComponent.msgContent =
          vueComponent.$t("没有维护相关单据打印函数") + "!";
        vueComponent.msgFlag = true;
        vueComponent.msgType = "error";
        return false;
      }
    };
  }
  function sheetPrintOrd(
    orders,
    check,
    printFlag,
    vueComponent,
    buttonData,
    queryDataNeedToBePrint
  ) {
    vueComponent.$i18n.setLocaleMessage(window.langcode, vueComponent.tranData);
    vueComponent.$i18n.locale = window.langcode;
    var filterByArcimItem = vueComponent.prtConfig["ZXD"]
      ? vueComponent.prtConfig["ZXD"]["ARCIM"]
        ? vueComponent.prtConfig["ZXD"]["ARCIM"]
        : ""
      : "";
    var filterByOhcinDesc = vueComponent.prtConfig["ZXD"]
      ? vueComponent.prtConfig["ZXD"]["Instr"]
        ? vueComponent.prtConfig["ZXD"]["Instr"]
        : ""
      : "";
    var printDateObject = queryDataNeedToBePrint(
      false,
      false,
      false,
      false,
      true,
      false,
      false,
      false,
      false,
      false,
      vueComponent.execConfig.printSetting,
      filterByArcimItem,
      filterByOhcinDesc,
      ""
    );
    // 主子医嘱-医嘱ID
    var orderIDs = printDateObject.orderIDs;
    // 主医嘱-医嘱ID
    var orderSeqIDs = printDateObject.orderSeqIDs;
    // 条码号
    var labNoList = printDateObject.labNos;
    // 就诊号
    var episodeIDs = printDateObject.episodeIDs;
    if (orderIDs.length === 0) {
      return vueComponent.$t("未选择医嘱,或者选择的医嘱不满足打印条件") + "!";
    }
    var sheetID = buttonData.formWorkId;
    if (sheetID === "") {
      return vueComponent.$t("获取打印模板失败") + "!";
    }
    return function(updateOrder, _ref, info) {
      // 判断是否有需要合管的医嘱
      var isMergeLab = labNoList.every(function(item) {
        return item === "";
      });
      if (!isMergeLab) {
        var obj = {};
        labNoList.forEach(function(item, index) {
          if (item) {
            if (obj[item]) {
              orderSeqIDs.splice(index, 1, obj[item]);
            } else {
              obj[item] = orderSeqIDs[index];
            }
          }
        });
      }
      var userName = info.userName || "";
      var startDate =
        vueComponent.moment(info.searchInfo.startDate).format("YYYY-MM-DD") ||
        "";
      var endDate =
        vueComponent.moment(info.searchInfo.endDate).format("YYYY-MM-DD") || "";
      var startTime = info.searchInfo.startTime.format("HH:mm") || "";
      var endTime = info.searchInfo.endTime.format("HH:mm") || "";
      var searchRange =
        startDate.split("-")[1] +
        "-" +
        startDate.split("-")[2] +
        " " +
        startTime +
        "～" +
        endDate.split("-")[1] +
        "-" +
        endDate.split("-")[2] +
        " " +
        endTime;
      var timeStamp = new Date().getTime();
      function getResultStatus() {
        if (printComm) {
          var sheetPrintResult = window.getSheetPrintResult();
          if (sheetPrintResult.statusCode === 1) {
            setOrderPrintFlag(
              _ref,
              unique(orderSeqIDs),
              printFlag,
              info,
              updateOrder,
              vueComponent
            );
            printComm = false;
          } else if (sheetPrintResult.statusCode === 2) {
            vueComponent.msgContent =
              vueComponent.$t(sheetPrintResult.msg) + "!";
            vueComponent.msgFlag = true;
            vueComponent.msgType = "info";
            printComm = false;
            vueComponent.spinning = false;
            sessionStorage.setItem("printStatusCode", 0);
            updateOrder();
          } else if (sheetPrintResult.statusCode < 0) {
            vueComponent.msgContent =
              vueComponent.$t(sheetPrintResult.msg) + "!";
            vueComponent.msgFlag = true;
            vueComponent.msgType = "error";
            printComm = false;
            vueComponent.spinning = false;
            sessionStorage.setItem("printStatusCode", 0);
            updateOrder();
          } else {
            var timeNow = new Date().getTime();
            if (timeNow - timeStamp > 120000) {
              vueComponent.msgContent = vueComponent.$t("打印超时") + "!";
              vueComponent.msgFlag = true;
              vueComponent.msgType = "error";
              printComm = false;
              vueComponent.spinning = false;
              sessionStorage.setItem("printStatusCode", 0);
              updateOrder();
            }
          }
        } else {
          clearInterval(getResultTimer);
        }
      }
      if (window.SheetPrint) {
        sessionStorage.setItem("printStatusCode", 1);
        vueComponent.spinning = true;
        var printComm = true;
        window.resetSheetPrintResult();
        window.SheetPrint(
          _ref,
          vueComponent.utils,
          orderIDs.join("^"),
          orderSeqIDs.join("^"),
          episodeIDs.join("^"),
          sheetID,
          userName,
          searchRange
        );
        var getResultTimer = setInterval(getResultStatus, 500);
      } else {
        vueComponent.msgContent =
          vueComponent.$t("没有维护相关单据打印函数") + "!";
        vueComponent.msgFlag = true;
        vueComponent.msgType = "error";
        return;
      }
    };
  }
  var OrderExcute = {
    handle: handle,
    setPlacerNo: setPlacerNo,
    clearPlacerNo: clearPlacerNo,
    seeOrder: seeOrder,
    cancelSeeOrder: cancelSeeOrder,
    excuteOrder: excuteOrder,
    cancelOrder: cancelOrder,
    setSkinTest: setSkinTest,
    lisBarPrintMerge: lisBarPrintMerge,
    pathBarPrint: pathBarPrint,
    sheetPrint: sheetPrint,
    sheetPrintOrd: sheetPrintOrd,
    confirmFee: confirmFee,
    commonPrint: commonPrint,
    cardPrint: cardPrint,
    stopExcuteOrder: stopExcuteOrder
  };
  window.OrderExcute = OrderExcute;
})();
