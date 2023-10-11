/// Creator:      pengjunfu
/// CreatDate:    2017-11-7
/// Description:  护士执行对医嘱和执行记录进行操作的相关函数

(function () {
	//定时器不断关闭加载动画,直到加载动画vue对象被释放
	function closeLoading(loadingInstance) {
		function close(loadingInstance) {
			if (loadingInstance) {
				loadingInstance.close();
				setTimeout(function () {
					close(loadingInstance)
				}, 500);
			}
		}
		setTimeout(function () {
			close(loadingInstance)
		}, 500);
	}
	/**
	 * @description 返回函数判断是否已经存取过同一天的执行记录
	 * @returns  判断是否存取过同一天的执行记录的函数
	 */
	function createIfOrderOfSameDateFunc() {
		var cacheDate = {};
		return function (sttDate, orderItemID) {
			var dateID = sttDate + '@' + orderItemID;
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
		var availableWays = ['iv.gtt', 'ivgtt化疗', 'iv.gtt(急诊)', 'ivgtt小儿营养', '入三升袋静点'];
		return function (order) {
			var orderUesWay = order.phcinDesc;
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
		var availableWays = ['iv.gtt', 'ivgtt化疗', 'iv.gtt(急诊)', 'ivgtt小儿营养', '入三升袋静点', 'po', '喷吸', '舌下含服'];
		return function (order) {
			var orderUesWay = order.phcinDesc;
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
		var availableFregs = ['Q1H', 'Q2H'];
		return function (order) {
			var phcfrCode = order.phcfrCode;
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

	function createSortHelpbject() {
		var data = [];
		data.sttDate = "1";

		function sortHelp() {
			this.dateArray = [];
			this.dateArray.push(data);
		}
		sortHelp.prototype.addExec = function (exec) {
			/*var sttDate = exec.sttDate;
			var data = this.dateArray.find(function (data) {
				return data.sttDate === sttDate;
			});
			if (!data) {
				data = [];
				data.sttDate = sttDate;
				this.dateArray.push(data);
			}*/
			data.push(exec);
		};
		sortHelp.prototype.getIDData = function () {
			var execIDs = [];
			var execSeqIDs = [];
			var execLabNos = [];
			this.dateArray.sort(function (preData, nextData) {
				return parseInt(preData.sttDate, 10) - parseInt(nextData.sttDate, 10);
			});
			this.dateArray.forEach(function (data) {
				data.forEach(function (exec) {
					execIDs.push(exec.ID);
					execSeqIDs.push(exec.ID);
					execLabNos.push(exec.labNo);
					if (exec.childs) {
						exec.childs.forEach(function (execChildID) {
							execIDs.push(execChildID);
							execSeqIDs.push(exec.ID);
							execLabNos.push(exec.labNo);
						});
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

	function createQuery(orders, check, printFlag) {

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
		 * @returns  数据对象
		 */
		return function queryDataNeedToBePrint(filteExecOfSameDate, searchOrderPrintFlag, filtePrintedExec, filteFlagExtend, filteExecByOrderID, filteByCategory, filteInfusionLable, filteInfusionBar, filteByFreg, filteOrderSate) {
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
			var orderIDs = [];
			var orderSeqIDs = [];
			var execIDs = [];
			var execSeqIDs = [];
			var execIDsOfNoFilteringSameDate = [];
			var ordersNeedToBePrint = [];
			var ifOrderOfSameDateFunc = createIfOrderOfSameDateFunc();
			var sortHelp = createSortHelpbject();

			if (filteInfusionLable) {
				var ifInfusionLabelFunc = createIfInfusionLabelFunc();
			}
			if (filteInfusionBar) {
				var ifInfusionBarFunc = createIfInfusionBarFunc();
			}
			if (filteByFreg) {
				var ifAvailFregFun = createIfAvailFregFunc();
				filteExecByOrderID = ifAvailFregFun(order);
			}
			orders.forEach(function (order) {
				//打勾就获取打勾的医嘱, 不打勾获取所有未置打印标记的医嘱
				if (
					(check && (order.check || order.indeterminate) && order.show) ||
					(printFlag !== '' && searchOrderPrintFlag && !check && order.printFlag.indexOf(printFlag) === -1)) {

					if ((printFlag === 'P') && (order.labNo === '')) {
						/// 检验病历条码标本号为空时过滤
						return;
					}
					orderIDs.push(order.ID);
					orderSeqIDs.push(order.ID);
					order.childs.forEach(function (orderChild) {
						orderIDs.push(orderChild.ID);
						orderSeqIDs.push(order.ID);
					});
					// 相同标本号的医嘱
					if (order.sameLabNoOrders && (order.sameLabNoOrders.length !== 0)) {
						order.sameLabNoOrders.forEach(function (sameLabNoOrder) {
							orderIDs.push(sameLabNoOrder.ID);
							orderSeqIDs.push(sameLabNoOrder.ID);
							ordersNeedToBePrint.push(sameLabNoOrder);
						});
					}
					if (order.execInfos) {
						var execIndex = 0;
						order.execInfos.forEach(function (exec) {
							if (
								(check && exec.check && (((filtePrintedExec && exec.printFlag.indexOf(printFlag) === -1)) || !filtePrintedExec)) ||
								(!check && !searchOrderPrintFlag && exec.printFlag.indexOf(printFlag) === -1)) {
								execIDsOfNoFilteringSameDate.push(exec.ID);
								//相同标本号的医嘱
								if (order.sameLabNoOrders && (order.sameLabNoOrders.length !== 0)) {
									order.sameLabNoOrders.forEach(function (sameLabNoOrder) {
										if (sameLabNoOrder.execInfos) {
											sameLabNoOrder.execInfos.forEach(function (exec) {
												execIDsOfNoFilteringSameDate.push(exec.ID);
											})
										}
									});
								}
								if ((filteExecOfSameDate && !ifOrderOfSameDateFunc(exec.sttDate, order.ID)) || !filteExecOfSameDate) {
									// sortHelp.addExec(exec);
									if ((filteFlagExtend && !(exec.filteFlagExtend === "JP")) || !filteFlagExtend) {
										if ((filteByCategory && exec.ordTyp === "R") || !filteByCategory) {
											if ((filteInfusionLable && ifInfusionLabelFunc(order)) || !filteInfusionLable) {
												if ((filteInfusionBar && ifInfusionBarFunc(order)) || !filteInfusionBar) {
													if ((filteOrderSate && order.ordStatDesc === "核实") || !filteOrderSate) {
														if ((filteExecByOrderID && execIndex === 0) || !filteExecByOrderID) {
															execIndex = execIndex + 1;
															sortHelp.addExec(exec);
															//相同标本号的医嘱
															if (order.sameLabNoOrders && (order.sameLabNoOrders.length !== 0)) {
																order.sameLabNoOrders.forEach(function (sameLabNoOrder) {
																	if (sameLabNoOrder.execInfos) {
																		sameLabNoOrder.execInfos.forEach(function (exec) {
																			sortHelp.addExec(exec);
																		})
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
						});
					}
				}
			});
			var execIDData = sortHelp.getIDData();
			var printDataObject = {
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
				execLabNos: execIDData.execLabNos

			};
			return printDataObject;
		}
	}
	/**
	 * @description 由OrderExcute.vue 调用,返回对应的处理函数
	 * @param {any} buttonData
	 * @param {any} vueComponent
	 * @returns  点击按钮的对应处理函数
	 */
	function handle(buttonData, vueComponent) {
		var data = vueComponent.orderList.data;
		var printFlag = buttonData.printFlag;
		var check = data.indeterminate || data.check;
		if (!printFlag && !check) {
			return '请选择医嘱!';
		}
		queryDataNeedToBePrint = createQuery(data.orders, check, printFlag);
		if (buttonData.jsFunction && this[buttonData.jsFunction]) {
			return this[buttonData.jsFunction](
				data.orders,
				check,
				printFlag,
				vueComponent,
				buttonData,
				queryDataNeedToBePrint);
		}
	}
	/**
	 * @description 获取可以处理的医嘱,并返回执行的闭包函数
	 * @param {any} orders
	 * @param {any} check
	 * @param {any} printFlag
	 * @param {any} vueComponent
	 * @returns  闭包函数,执行该函数可以处理医嘱
	 */
	function seeOrder(orders, check, printFlag, vueComponent) {
		var orderIDNeedToBeDispose = [];
		var $message = vueComponent.$message;
		orders.forEach(function (order) {
			if (order.check) {
				orderIDNeedToBeDispose.push(order.ID);
				if (order.sameLabNoOrders && (order.sameLabNoOrders.length !== 0)) {
					order.sameLabNoOrders.forEach(function (sameLabNoOrder) {
						orderIDNeedToBeDispose.push(sameLabNoOrder.ID);
					});
				}
			}
		});
		if (orderIDNeedToBeDispose.length === 0) {
			return '请选择需要处理的医嘱!';
		}
		return function (requestQuery, runServerMethod, info) {
			var type = info.type || 'F';
			var notes = info.notes || '';
			var date = info.date || '';
			var time = info.time || '';
			var userID = info.userID1 || '';
			var locID = info.locID || '';
			var errors = [];
			var seeOrderPromises = [];
			var chunks = vueComponent.utils.splitChunk([], 30, orderIDNeedToBeDispose);
			chunks.forEach(function (chunk) {
				seeOrderPromises.push(runServerMethod('SeeOrderChunks', chunk.join('^'), userID, type, notes, date, time, locID).then(
					function (result) {
						if (String(result.success) !== '0') {
							errors = errors.concat(result.errList);
						}
					}
				))
			});
			var axios = window.axios;
			var loadingInstance = vueComponent.$loading({
				text: "处理医嘱后台处理中..."
			});
			axios.all(seeOrderPromises).then(function () {
				closeLoading(loadingInstance);
				requestQuery();
				var errInfos = errors.map(function (err) {
					return err.errInfo;
				});
				if (errors.length !== 0) {
					$message({
						dangerouslyUseHTMLString: true,
						message: errInfos.join('<br/>'),
						showClose: true,
						type: 'error'
					});
				} else {
					$message.success('处理成功');
				}
			});
		};
	}
	/**
	 * @description 获取可以撤销处理的医嘱,并返回执行的闭包函数
	 * @param {any} orders
	 * @param {any} check
	 * @param {any} printFlag
	 * @param {any} vueComponent vue组件
	 * @returns  闭包函数,执行该函数可以撤销处理医嘱
	 */
	function cancelSeeOrder(orders, check, printFlag, vueComponent) {
		var orderIDNeedToBeCancelDispose = [];
		var $message = vueComponent.$message;
		orders.forEach(function (order) {
			if (order.check) {
				orderIDNeedToBeCancelDispose.push(order.ID);
				if (order.sameLabNoOrders && (order.sameLabNoOrders.length !== 0)) {
					order.sameLabNoOrders.forEach(function (sameLabNoOrder) {
						orderIDNeedToBeCancelDispose.push(sameLabNoOrder.ID);
					});
				}
			}
		});
		if (orderIDNeedToBeCancelDispose.length === 0) {
			return '请选择需要处理的医嘱!';
		}
		return function (requestQuery, runServerMethod, info) {
			var userID = info.userID1 || '';
			var locID = info.locID || '';
			var errors = [];
			var cancelSeeOrderPromises = [];
			var chunks = vueComponent.utils.splitChunk([], 30, orderIDNeedToBeCancelDispose);
			chunks.forEach(function (chunk) {
				cancelSeeOrderPromises.push(runServerMethod('cancelSeeOrderChunks', chunk.join('^'), userID, locID).then(
					function (result) {
						if (String(result.success) !== '0') {
							errors = errors.concat(result.errList);
						}
					}
				))
			});
			var axios = window.axios;
			var loadingInstance = vueComponent.$loading({
				text: "撤销处理后台执行中..."
			});
			axios.all(cancelSeeOrderPromises).then(function () {
				closeLoading(loadingInstance);
				requestQuery();
				var errInfos = errors.map(function (err) {
					return err.errInfo;
				});
				if (errors.length !== 0) {
					$message({
						dangerouslyUseHTMLString: true,
						message: errInfos.join('<br/>'),
						showClose: true,
						type: 'error'
					});
				} else {
					$message.success('撤销处理成功');
				}
			});
		};
	}

	/**
	 * @description 过滤执行记录,并返回执行执行记录的闭包函数
	 * @param {any} orders  医嘱对象数组
	 * @param {any} check   有没有医嘱被选中
	 * @param {any} printFlag 按钮设置信息里的打印标记
	 * @param {any} vueComponent vue组件
	 * @returns  闭包函数,执行该函数可以执行执行记录
	 */
	function excuteOrder(orders, check, printFlag, vueComponent) {
		var execIDNeedToBeExcute = [];
		var execNotPrint = [];
		var execIDNotPrint = [];
		var execNeedToBeExcuteMap = {};
		var execIDNeedToBeDiscontinued = [];
		var execNeedToBeDiscontinuedMap = {};
		var sheetCode = vueComponent.searchCondition.sheetCode;
		var $message = vueComponent.$message;
		var $notify = vueComponent.$notify;
		//var aaa = testCA();
		//debugger;
		// var needPrintSheetCode = ['CQSYD', 'CQHLD', 'CQZSD', 'cqkfyd', 'CQZLD', 'LSYZD'];
		var needPrintSheetCode = ['JYD'];
		orders.forEach(function (order) {
			if ((order.check || order.indeterminate) && order.show) {
				order.execInfos.forEach(function (execInfo) {
					if (execInfo.check) {
						var disposeStatCode = execInfo.disposeStatCode;
						if ((disposeStatCode === 'Needless') ||
							(disposeStatCode === 'Immediate') ||
							(disposeStatCode === 'LongNew') ||
							(disposeStatCode === 'Temp') ||
							(disposeStatCode === 'LongUnnew') ||
							(disposeStatCode === 'SkinTestNorm') ||
							(disposeStatCode === 'SpecmentReject')) {
							var printFlag = execInfo.printFlag;
							if (needPrintSheetCode.indexOf(sheetCode) > -1) {
								if (printFlag.indexOf('P') > -1) {
									execIDNeedToBeExcute.push(execInfo.ID);
									execNeedToBeExcuteMap[execInfo.ID] = order;
									//相同标本号的医嘱
									if (order.sameLabNoOrders && (order.sameLabNoOrders.length !== 0)) {
										order.sameLabNoOrders.forEach(function (sameLabNoOrder) {
											if (sameLabNoOrder.execInfos) {
												sameLabNoOrder.execInfos.forEach(function (sameLabNoOrderExecInfo) {
													execIDNeedToBeExcute.push(sameLabNoOrderExecInfo.ID);
													execNeedToBeExcuteMap[sameLabNoOrderExecInfo.ID] = sameLabNoOrder;
												})
											}
										});
									}
									//相同检查部位的执行记录
									if (execInfo.samePartExecInfos && (execInfo.samePartExecInfos.length !== 0)) {
										execInfo.samePartExecInfos.forEach(function (samePartExec) {
											execIDNeedToBeExcute.push(samePartExec.ID);
											execNeedToBeExcuteMap[samePartExec.ID] = order;
										})
									}
								} else {
									if (execNotPrint.length < 10) {
										if (execIDNotPrint.indexOf(order.ID) < 0) {
											execIDNotPrint.push(order.ID);
											execNotPrint.push(("<div>" + order.arcimDesc + ":未打印</div>"));
										}
									} else if (execNotPrint.length === 10) {
										execNotPrint.push(("<div>......</div>"));
									}
								}
							} else {
								execIDNeedToBeExcute.push(execInfo.ID);
								execNeedToBeExcuteMap[execInfo.ID] = order;
								//相同标本号的医嘱
								if (order.sameLabNoOrders && (order.sameLabNoOrders.length !== 0)) {
									order.sameLabNoOrders.forEach(function (sameLabNoOrder) {
										if (sameLabNoOrder.execInfos) {
											sameLabNoOrder.execInfos.forEach(function (sameLabNoOrderExecInfo) {
												execIDNeedToBeExcute.push(sameLabNoOrderExecInfo.ID);
												execNeedToBeExcuteMap[sameLabNoOrderExecInfo.ID] = sameLabNoOrder;
											})
										}
									});
								}
								//相同检查部位的执行记录
								if (execInfo.samePartExecInfos && (execInfo.samePartExecInfos.length !== 0)) {
									execInfo.samePartExecInfos.forEach(function (samePartExec) {
										execIDNeedToBeExcute.push(samePartExec.ID);
										execNeedToBeExcuteMap[samePartExec.ID] = order;
									})
								}
							}

						} else if (disposeStatCode === 'Discontinue') {
							execIDNeedToBeDiscontinued.push(execInfo.ID);
							execNeedToBeDiscontinuedMap[execInfo.ID] = order;
							//相同标本号的医嘱
							if (order.sameLabNoOrders && (order.sameLabNoOrders.length !== 0)) {
								order.sameLabNoOrders.forEach(function (sameLabNoOrder) {
									if (sameLabNoOrder.execInfos) {
										sameLabNoOrder.execInfos.forEach(function (sameLabNoOrderExecInfo) {
											execIDNeedToBeDiscontinued.push(sameLabNoOrderExecInfo.ID);
											execNeedToBeDiscontinuedMap[sameLabNoOrderExecInfo.ID] = sameLabNoOrder;
										})
									}
								});
							}
							//相同检查部位的执行记录
							if (execInfo.samePartExecInfos && (execInfo.samePartExecInfos.length !== 0)) {
								execInfo.samePartExecInfos.forEach(function (samePartExec) {
									execIDNeedToBeExcute.push(samePartExec.ID);
									execNeedToBeExcuteMap[samePartExec.ID] = order;
								})
							}
						}
					} else {
						if (order.indeterminate && execInfo.examInfo.examComm === 'Y') {
							execIDNeedToBeExcute.push(execInfo.ID);
							execNeedToBeExcuteMap[execInfo.ID] = order;
						}
					}
				})
			}
		});
		if (execNotPrint.length !== 0) {
			$notify({
				message: execNotPrint.join(' '),
				duration: 0,
				showClose: true,
				type: "warning",
				dangerouslyUseHTMLString: true
			});
		}
		if ((execIDNeedToBeExcute.length === 0) && (execIDNeedToBeDiscontinued.length === 0)) {
			return '请选择符合要求的医嘱执行!';
		}
		return function (requestQuery, runServerMethod, info) {
			var promises = [];
			var skinTestFlag = info.skinTestFlag || '';
			var execStatusCode = info.execStatusCode || 'F';
			var userID = info.userID1 || '';
			var locID = info.locID || '';
			var queryTypeCode = info.queryTypeCode || '';
			var date = info.date || '';
			var time = info.time || '';
			var changeReasonDr = info.changeReasonDr || '';
			var groupID = vueComponent.session.USER.GROUPID || '';
			var errors = [];
			var chunks = vueComponent.utils.splitChunk([], 30, execIDNeedToBeExcute);
			var execDiscontinuedChunks = vueComponent.utils.splitChunk([], 30, execIDNeedToBeDiscontinued);

			chunks.forEach(function (chunk) {
				promises.push(runServerMethod('UpdateOrdGroupChunks', skinTestFlag, chunk.join('^'), execStatusCode, userID, locID, queryTypeCode, date, time, changeReasonDr, groupID).then(
					function (result) {
						if (String(result.success) !== '0') {
							errors = errors.concat(result.errList);
						}
					}
				))
			});
			execDiscontinuedChunks.forEach(function (disconOrderChunk) {
				promises.push(runServerMethod('SetDisconOrderChunks', disconOrderChunk.join('^'), userID).then(
					function (result) {
						if (String(result.success) !== '0') {
							errors = errors.concat(result.errList);
						}
					}
				))
			});

			var axios = window.axios;
			var loadingInstance = vueComponent.$loading({
				text: "执行医嘱后台处理中..."
			});
			axios.all(promises).then(function () {
				closeLoading(loadingInstance);
				requestQuery();
				var errInfos = errors.map(function (err) {
					return err.errInfo;
				});
				if (errors.length !== 0) {
					$message({
						message: errInfos.join('<br/>'),
						duration: 8000,
						showClose: true,
						type: "error",
						dangerouslyUseHTMLString: true
					});
				} else {
					$message({
						showClose: true,
						message: '执行成功',
						type: 'success'
					});
				}
			});
		};
	}

	/**
	 * @description 过滤执行记录,并返回撤销执行记录的闭包函数
	 * @param {any} orders  医嘱对象数组
	 * @param {any} check   有没有医嘱被选中
	 * @param {any} printFlag 按钮设置信息里的打印标记
	 * @param {any} vueComponent vue组件
	 * @returns  撤销执行记录的闭包函数
	 */
	function cancelOrder(orders, check, printFlag, vueComponent) {
		var execIDNeedToBeCancel = [];
		var $message = vueComponent.$message;
		orders.forEach(function (order) {
			if (order.check || order.indeterminate) {
				order.execInfos.forEach(function (execInfo) {
					if (execInfo.check) {
						var disposeStatCode = execInfo.disposeStatCode;
						if (disposeStatCode === 'Exec' || disposeStatCode === 'SpecmentReject' || disposeStatCode === 'RefuseDispDrug') {
							if (!(execInfo.examInfo && execInfo.examInfo.examComm === 'Y' && order.indeterminate)) { //新检查申请按部位撤销判断
								execIDNeedToBeCancel.push(execInfo.ID);
							}
							//相同标本号的医嘱
							if (order.sameLabNoOrders && (order.sameLabNoOrders.length !== 0)) {
								order.sameLabNoOrders.forEach(function (sameLabNoOrder) {
									if (sameLabNoOrder.execInfos) {
										sameLabNoOrder.execInfos.forEach(function (sameLabNoOrderExecInfo) {
											execIDNeedToBeCancel.push(sameLabNoOrderExecInfo.ID);
										})
									}
								});
							}
							//相同检查部位的执行记录
							if (execInfo.samePartExecInfos && (execInfo.samePartExecInfos.length !== 0)) {
								execInfo.samePartExecInfos.forEach(function (samePartExec) {
									if (!(samePartExec.examInfo && samePartExec.examInfo.examComm === 'Y' && samePartExec.indeterminate)) { //新检查申请按部位撤销判断
										execIDNeedToBeCancel.push(samePartExec.ID);
									}
								})
							}
						}
					}
				})
			}
		});
		if (execIDNeedToBeCancel.length === 0) {
			return '请选择需要撤销执行的医嘱!';
		}
		return function (requestQuery, runServerMethod, info) {
			var promises = [];
			var skinTestFlag = info.skinTestFlag || '';
			var execStatusCode = info.execStatusCode || 'C';
			var userID = info.userID1 || '';
			var locID = info.locID || '';
			var queryTypeCode = info.queryTypeCode || '';
			var date = info.date || '';
			var time = info.time || '';
			var changeReasonDr = info.changeReasonDr || '';
			var groupID = vueComponent.session.USER.GROUPID || '';
			var errors = [];
			var chunks = vueComponent.utils.splitChunk([], 30, execIDNeedToBeCancel);

			chunks.forEach(function (chunk) {
				promises.push(runServerMethod('UpdateOrdGroupChunks', skinTestFlag, chunk.join('^'), execStatusCode, userID, locID, queryTypeCode, date, time, changeReasonDr, groupID).then(
					function (result) {
						if (String(result.success) !== '0') {
							errors = errors.concat(result.errList);
						}
					}
				))
			});
			var axios = window.axios;
			var loadingInstance = vueComponent.$loading({
				text: "撤销执行医嘱后台处理中..."
			});
			axios.all(promises).then(function () {
				closeLoading(loadingInstance);
				requestQuery();
				var errInfos = errors.map(function (err) {
					return err.errInfo;
				});
				if (errors.length !== 0) {
					$message({
						message: errInfos.join('<br/>'),
						duration: 8000,
						showClose: true,
						type: "error",
						dangerouslyUseHTMLString: true
					});
				} else {
					$message.success('撤销执行成功');
				}
			});
		};
	}
	/**
	 * @description 打印医嘱本
	 * @param {any} orders
	 * @param {any} check
	 * @param {any} printFlag
	 * @param {any} vueComponent
	 * @returns
	 */
	function orderPrint(orders, check, printFlag, vueComponent) {
		var orderIDNeedToBePrint = [];
		var seqIDNeedToBePrint = [];
		var $message = vueComponent.$message;
		var orderType = vueComponent.searchInfo.orderType;
		var $nextTick = vueComponent.$nextTick;
		orders.forEach(function (order) {
			//打勾就只打印打勾的医嘱, 不打勾则打印所有未打印过的医嘱
			if ((check && (order.check === check)) || (order.printFlag === "")) {
				orderIDNeedToBePrint.push(order.ID);
				seqIDNeedToBePrint.push(order.ID);
				order.childs.forEach(function (orderChild) {
					orderIDNeedToBePrint.push(orderChild.ID);
					seqIDNeedToBePrint.push(orderChild.ID);
				});
			}
		});
		if (orderIDNeedToBePrint.length === 0) {
			return '请选择需要打印的医嘱!';
		}
		return function (requestQuery, runServerMethod, info) {
			//打印
			var DHCCNursePrintComm = vueComponent.utils.getPrintDll();
			var ifPrintTitle = vueComponent.ifPrintTitle.toString();
			var startPage = 1;
			var webIP = vueComponent.session.USER.WEBIP;
			var hospitalID = vueComponent.session.USER.HOSPITALID;
			if (orderType === "L") {
				DHCCNursePrintComm.showNurseExcuteSheetPreviewNew(orderIDNeedToBePrint.join("^"), seqIDNeedToBePrint.join("^"), "WARD", "CQYZB", hospitalID, ifPrintTitle, startPage, webIP, true, 1, "NurseOrderYZB.xml");
			} else {
				DHCCNursePrintComm.showNurseExcuteSheetPreviewNew(orderIDNeedToBePrint.join("^"), seqIDNeedToBePrint.join("^"), "WARD", "LSYZB", hospitalID, ifPrintTitle, startPage, webIP, true, 1, "NurseOrderYZB.xml");
			}
			var loadingInstance = vueComponent.$loading({
				text: "后台处理中..."
			});
			if ((orderIDNeedToBePrint.length !== 0) && (DHCCNursePrintComm.saveFlag == 1)) {
				var axios = window.axios;
				runServerMethod("setPrintFlag", orderIDNeedToBePrint.join("^"), "V").then(function (ret) {
					setTimeout(loadingInstance.close(), 1000);
					requestQuery();
					if (String(ret) !== "0") {
						$message({
							message: ret,
							duration: 0,
							showClose: true,
							type: "error",
							dangerouslyUseHTMLString: true
						});
					}
				});
			}
		};
	}

	/**
	 * @author songchao
	 * @description 保存打印日志
	 * @param {*} runServerMethod
	 * @param {*} execIdChunks
	 * @param {*} execSeqIdChunks
	 * @param {*} queryTypeCode
	 * @param {*} printFlag
	 * @param {*} info
	 * @param {*} vueComponent
	 * @param {*} timeStamp
	 */
	function saveRecord(runServerMethod, execIdChunks, execSeqIdChunks, execNotFilterChunks, printFlag, info, vueComponent, timeStamp) {
		var axios = window.axios;;
		var locId = info.locID;
		var userID = info.userID1;
		var length = execIdChunks.length;
		var startDate = info.searchInfo.startDate;
		var startTime = info.searchInfo.startTime;
		var endDate = info.searchInfo.endDate;
		var endTime = info.searchInfo.endTime;
		var hospitalID = vueComponent.session.USER.HOSPITALID;
		var queryTypeCode = info.queryTypeCode || '';
		var promises = [];
		var clientIP = window.status; //vueComponent.utils.getComputerIp();
		var loadingInstance = vueComponent.$loading({
			text: "传递打印参数处理中..."
		});
		var $message = vueComponent.$message;
		var recordID = tkMakeServerCall("Nur.CommonInterface.OrderHandle", 'saveRecordMain', queryTypeCode, printFlag, locId, userID, startDate, startTime, endDate, endTime, timeStamp, clientIP);
		if (String(recordID) === '-1') {
			$message({
				message: "打印记录保存失败!",
				duration: 0,
				showClose: true,
				type: "error"
			});
			closeLoading(loadingInstance);
		} else {
			for (i = 0; i < length; i++) {
				var execIdChunk = execIdChunks[i];
				var execSeqIdChunk = execSeqIdChunks[i];
				var execNotFilterChunk = [];
				var retStatus = tkMakeServerCall("Nur.CommonInterface.OrderHandle", 'appendRecordStream', String(recordID), execIdChunk.join('^'), execSeqIdChunk.join('^'), execNotFilterChunk.join('^'));
				if (retStatus != 0) {
					$message({
						message: "打印参数保存失败:" + retStatus,
						duration: 0,
						showClose: true,
						type: "error"
					});
					closeLoading(loadingInstance);
					return false;
				}
			}
		}
		return true;
		/*return runServerMethod('saveRecordMain', queryTypeCode, printFlag, locId, userID, startDate, startTime, endDate, endTime, timeStamp, clientIP).then(function (result) {
			if (String(result) === '-1') {
				$message({
					message: "打印记录保存失败!",
					duration: 0,
					showClose: true,
					type: "error"
				});
				closeLoading(loadingInstance);
			} else {
				var savePrintRecordPromises = null;
				for (i = 0; i < length; i++) {
					var execIdChunk = execIdChunks[i];
					var execSeqIdChunk = execSeqIdChunks[i];
					var execNotFilterChunk = [];
					if (i == 0) {
						savePrintRecordPromises = (function (execIdChunk, execSeqIdChunk, execNotFilterChunk) {
							return runServerMethod('appendRecordStream', String(result), execIdChunk.join('^'), execSeqIdChunk.join('^'), execNotFilterChunk.join('^'));
						})(execIdChunk, execSeqIdChunk, execNotFilterChunk);
					} 
					else if (i == length-1) {
						savePrintRecordPromises = (function (execIdChunk, execSeqIdChunk, execNotFilterChunk) {
							return runServerMethod('appendRecordStream', String(result), execIdChunk.join('^'), execSeqIdChunk.join('^'), execNotFilterChunk.join('^'),"Y");
						})(execIdChunk, execSeqIdChunk, execNotFilterChunk);
					} 
					else {
						savePrintRecordPromises = savePrintRecordPromises.then((function (execIdChunk, execSeqIdChunk, execNotFilterChunk) {
							return function () {
								return runServerMethod('appendRecordStream', String(result), execIdChunk.join('^'), execSeqIdChunk.join('^'), execNotFilterChunk.join('^'));
							};
						})(execIdChunk, execSeqIdChunk, execNotFilterChunk));
					}
				}
				savePrintRecordPromises.then(function () {
					closeLoading(loadingInstance);
					// requestQuery();
				});
			}
			return String(result);
		});*/
	}

	/**
	 * @description 打印执行单(病区)
	 * @param {any} orders
	 * @param {any} check
	 * @param {any} printFlag
	 * @param {any} vueComponent
	 * @returns
	 */
	function orderExecPrintWard(orders, check, printFlag, vueComponent, buttonData, queryDataNeedToBePrint) {
		var $message = vueComponent.$message;
		var $nextTick = vueComponent.$nextTick;
		var searchCondition = vueComponent.searchCondition;
		var printDateObject = null;
		if (searchCondition.sheetCode !== "PSD") {
			printDateObject = queryDataNeedToBePrint(false, false, false);
		} else {
			printDateObject = queryDataNeedToBePrint(false, false, false, false, true);
		}
		var execIDNeedToBePrint = printDateObject.execIDs;
		var execSeqIDNeedToBePrint = printDateObject.execSeqIDs;
		var execIDsOfNoFilteringSameDate = printDateObject.execIDsOfNoFilteringSameDate;

		if (execIDNeedToBePrint.length === 0) {
			return '请选择需要打印的医嘱!';
		}
		return function (requestQuery, runServerMethod, info) {
			//打印
			var startPage = 1;
			var hospitalID = vueComponent.session.USER.HOSPITALID;
			var webIP = vueComponent.session.USER.WEBIP;
			var queryTypeCode = info.queryTypeCode || '';
			var userID = info.userID1 || '';
			var userName = info.userName || '';
			var oeordIDString = "";
			var seqIDString = "";
			var printType = "WARD";
			var startDate = info.searchInfo.startDate || '';
			var endDate = info.searchInfo.endDate || '';
			var startTime = info.searchInfo.startTime || '';
			var endTime = info.searchInfo.endTime || '';
			var searchRange = startDate + " " + startTime + "--" + endDate + " " + endTime;
			var chunks = vueComponent.utils.splitChunk([], 200, execIDNeedToBePrint);
			var execNotFilterChunks = vueComponent.utils.splitChunk([], 200, execIDsOfNoFilteringSameDate);
			var execSeqIdChunks = vueComponent.utils.splitChunk([], 200, execSeqIDNeedToBePrint);
			var timeStamp = new Date().getTime();
			var loadingInstance = null;
			/*saveRecord(runServerMethod, chunks, execSeqIdChunks, execNotFilterChunks, printFlag, info, vueComponent, timeStamp).then(function () {
				loadingInstance = vueComponent.$loading({
					text: "查询打印状态..."
				});
			});*/
			var ifSaveFinish = saveRecord(runServerMethod, chunks, execSeqIdChunks, chunks, printFlag, info, vueComponent, timeStamp);
			if (ifSaveFinish) {
				loadingInstance = vueComponent.$loading({
					text: "查询打印状态..."
				});
			}
			else {
				closeLoading(loadingInstance);
				$message({
					message: "打印超时!",
					duration: 0,
					showClose: true,
					type: "error"
				});
				return;
			}
			vueComponent.utils.showNurseExcuteSheetPreviewNew(userID, timeStamp, printType, queryTypeCode, webIP, true, 1, "NurseOrder.xml", userName, searchRange);

			var markStateTimer = setInterval(getRecordMarkStatus, 500);

			function getRecordMarkStatus() {
				runServerMethod("getRecordMarkStatus", userID, timeStamp).then(function (state) {
					if (String(state).replace(/(\r\n)|(\n)|(\s)/g, '') === "P") {
						window.clearInterval(markStateTimer);
						closeLoading(loadingInstance);
						setExecPrintFlag(execNotFilterChunks, printFlag, info, runServerMethod, timeStamp, vueComponent, requestQuery);
					}
					var timeNow = new Date().getTime();
					if (timeNow - timeStamp > 120000) {
						window.clearInterval(markStateTimer);
						closeLoading(loadingInstance);
						$message({
							message: "打印超时!",
							duration: 0,
							showClose: true,
							type: "error"
						});
					}

				});
			}
		};
	}
	/**
	 * @author songchao
	 * @description 置执行记录打印标志
	 */
	function setExecPrintFlag(execNotFilterChunks, printFlag, info, runServerMethod, timeStamp, vueComponent, requestQuery) {
		var axios = window.axios;
		var savePrintFlagPromises = [];
		var userID = info.userID1 || '';
		var queryTypeCode = info.queryTypeCode || '';
		var loadingInstance = vueComponent.$loading({
			text: "置打印标志中..."
		});
		execNotFilterChunks.forEach(function (chunk) {
			savePrintFlagPromises.push(runServerMethod(
				'setExecPrintFlag',
				chunk.join('^'),
				userID,
				queryTypeCode,
				printFlag))
		});
		axios.all(savePrintFlagPromises).then(function () {
			runServerMethod("updateRecordMarkStatus", userID, timeStamp, "F").then(function (state) {
				if (String(state) === '0') {
					closeLoading(loadingInstance);
					requestQuery();
				} else {
					$message({
						message: "置打印参数完成状态失败!",
						duration: 0,
						showClose: true,
						type: "error"
					});
				}
			});
		});
	}
	/**
	 * @description 打印执行单(个人)
	 * @param {any} orders
	 * @param {any} check
	 * @param {any} printFlag
	 * @param {any} vueComponent
	 * @returns
	 */
	function orderExecPrintPerson(orders, check, printFlag, vueComponent, buttonData, queryDataNeedToBePrint) {
		var $message = vueComponent.$message;
		var $nextTick = vueComponent.$nextTick;
		var searchCondition = vueComponent.searchCondition;
		var printDateObject = null;
		if (searchCondition.sheetCode !== "PSD") {
			printDateObject = queryDataNeedToBePrint(false, false, false);
		} else {
			printDateObject = queryDataNeedToBePrint(false, false, false, false, true);
		}
		var execIDNeedToBePrint = printDateObject.execIDs;
		var execSeqIDNeedToBePrint = printDateObject.execSeqIDs;
		var execIDsOfNoFilteringSameDate = printDateObject.execIDsOfNoFilteringSameDate;

		if (execIDNeedToBePrint.length === 0) {
			return '请选择需要打印的医嘱!';
		}
		return function (requestQuery, runServerMethod, info) {
			//打印
			var startPage = 1;
			var hospitalID = vueComponent.session.USER.HOSPITALID;
			var webIP = vueComponent.session.USER.WEBIP;
			var queryTypeCode = info.queryTypeCode || '';
			var userID = info.userID1 || '';
			var userName = info.userName || '';
			var oeordIDString = "";
			var seqIDString = "";
			var printType = "PAT";
			var chunks = vueComponent.utils.splitChunk([], 200, execIDNeedToBePrint);
			var execNotFilterChunks = vueComponent.utils.splitChunk([], 200, execIDsOfNoFilteringSameDate);
			var execSeqIdChunks = vueComponent.utils.splitChunk([], 200, execSeqIDNeedToBePrint);
			var timeStamp = new Date().getTime();
			var loadingInstance = null;
			var ifSaveFinish = saveRecord(runServerMethod, chunks, execSeqIdChunks, chunks, printFlag, info, vueComponent, timeStamp);
			/*.then(function () {
				loadingInstance = vueComponent.$loading({
					text: "查询打印状态..."
				});
			});*/
			if (ifSaveFinish) {
				loadingInstance = vueComponent.$loading({
					text: "查询打印状态..."
				});
			}
			else {
				closeLoading(loadingInstance);
				$message({
					message: "打印超时!",
					duration: 0,
					showClose: true,
					type: "error"
				});
				return;
			}
			vueComponent.utils.showNurseExcuteSheetPreviewNew(userID, timeStamp, printType, queryTypeCode, webIP, true, 1, "NurseOrder.xml", userName);

			var markStateTimer = setInterval(getRecordMarkStatus, 500);

			function getRecordMarkStatus() {
				runServerMethod("getRecordMarkStatus", userID, timeStamp).then(function (state) {
					if (String(state).replace(/(\r\n)|(\n)|(\s)/g, '') === "P") {
						window.clearInterval(markStateTimer);
						closeLoading(loadingInstance);
						setExecPrintFlag(execNotFilterChunks, printFlag, info, runServerMethod, timeStamp, vueComponent, requestQuery);
					}
					var timeNow = new Date().getTime();
					if (timeNow - timeStamp > 60000) {
						window.clearInterval(markStateTimer);
						closeLoading(loadingInstance);
						$message({
							message: "打印超时!",
							duration: 0,
							showClose: true,
							type: "error"
						});
					}

				});
			}
		};
	}

	/**
	 * @description 贴瓶签打印
	 * @param {any} orders
	 * @param {any} check
	 * @param {any} printFlag
	 * @param {any} vueComponent
	 * @returns
	 */
	function infusionLabelPrint(orders, check, printFlag, vueComponent, buttonData, queryDataNeedToBePrint) {
		var $message = vueComponent.$message;
		var printDateObject = queryDataNeedToBePrint(false, false, false);
		var orderExecIDNeedToBePrint = printDateObject.execIDs;
		var seqIDNeedToBePrint = printDateObject.execSeqIDs;
		var execIDsOfNoFilteringSameDate = printDateObject.execIDsOfNoFilteringSameDate;
		if (orderExecIDNeedToBePrint.length === 0) {
			return '未选择医嘱,或者选择的医嘱不满足打印条件!';
		}
		return function (requestQuery, runServerMethod, info) {
			//打印
			var webIP = vueComponent.session.USER.WEBIP;
			var hospitalID = vueComponent.session.USER.HOSPITALID;
			var queryTypeCode = info.queryTypeCode || '';
			var userID = info.userID1 || '';
			var userName = info.userName || '';
			var chunks = vueComponent.utils.splitChunk([], 200, orderExecIDNeedToBePrint);
			var execSeqIdChunks = vueComponent.utils.splitChunk([], 200, seqIDNeedToBePrint);
			var execNotFilterChunks = vueComponent.utils.splitChunk([], 200, execIDsOfNoFilteringSameDate);
			var timeStamp = new Date().getTime();
			var loadingInstance = null;
			/* saveRecord(runServerMethod, chunks, execSeqIdChunks, execNotFilterChunks, printFlag, info, vueComponent, timeStamp).then(function () {
				loadingInstance = vueComponent.$loading({
					text: "查询打印状态..."
				});
			});*/
			var ifSaveFinish = saveRecord(runServerMethod, chunks, execSeqIdChunks, chunks, printFlag, info, vueComponent, timeStamp);
			if (ifSaveFinish) {
				loadingInstance = vueComponent.$loading({
					text: "查询打印状态..."
				});
			}
			else {
				closeLoading(loadingInstance);
				$message({
					message: "打印超时!",
					duration: 0,
					showClose: true,
					type: "error"
				});
				return;
			}
			vueComponent.utils.showNurseExcuteSheetPreviewNew(userID, timeStamp, printFlag, queryTypeCode, webIP, true, 1, "NurseOrder.xml", userName);
			var markStateTimer = setInterval(getRecordMarkStatus, 500);

			function getRecordMarkStatus() {
				runServerMethod("getRecordMarkStatus", userID, timeStamp).then(function (state) {
					if (String(state).replace(/(\r\n)|(\n)|(\s)/g, '') === "P") {
						window.clearInterval(markStateTimer);
						closeLoading(loadingInstance);
						setExecPrintFlag(execNotFilterChunks, printFlag, info, runServerMethod, timeStamp, vueComponent, requestQuery);
					}
					var timeNow = new Date().getTime();
					if (timeNow - timeStamp > 60000) {
						window.clearInterval(markStateTimer);
						closeLoading(loadingInstance);
						$message({
							message: "打印超时!",
							duration: 0,
							showClose: true,
							type: "error"
						});
					}

				});
			}
		};
	}
	/**
	 * @description 输液卡打印
	 * @param {any} orders
	 * @param {any} check
	 * @param {any} printFlag
	 * @param {any} vueComponent
	 * @returns
	 */
	function infusionCardPrint(orders, check, printFlag, vueComponent, buttonData, queryDataNeedToBePrint) {
		var $message = vueComponent.$message;
		var printDateObject = queryDataNeedToBePrint(false);
		var orderExecIDNeedToBePrint = printDateObject.execIDs;
		var seqIDNeedToBePrint = printDateObject.execSeqIDs;
		var execIDsOfNoFilteringSameDate = printDateObject.execIDsOfNoFilteringSameDate;
		if (orderExecIDNeedToBePrint.length === 0) {
			return '请选择需要打印的医嘱!';
		}
		return function (requestQuery, runServerMethod, info) {
			//打印
			var webIP = vueComponent.session.USER.WEBIP;
			var hospitalID = vueComponent.session.USER.HOSPITALID;
			var queryTypeCode = info.queryTypeCode || '';
			var userID = info.userID1 || '';
			var userName = info.userName || '';
			var chunks = vueComponent.utils.splitChunk([], 20, orderExecIDNeedToBePrint);
			var execSeqIdChunks = vueComponent.utils.splitChunk([], 20, seqIDNeedToBePrint);
			var execNotFilterChunks = vueComponent.utils.splitChunk([], 20, execIDsOfNoFilteringSameDate);
			var timeStamp = new Date().getTime();
			var loadingInstance = null;
			/* saveRecord(runServerMethod, chunks, execSeqIdChunks, chunks, printFlag, info, vueComponent, timeStamp).then(function () {
				loadingInstance = vueComponent.$loading({
					text: "查询打印状态..."
				});
			});*/
			var ifSaveFinish = saveRecord(runServerMethod, chunks, execSeqIdChunks, chunks, printFlag, info, vueComponent, timeStamp);
			if (ifSaveFinish) {
				loadingInstance = vueComponent.$loading({
					text: "查询打印状态..."
				});
			}
			else {
				closeLoading(loadingInstance);
				$message({
					message: "打印超时!",
					duration: 0,
					showClose: true,
					type: "error"
				});
				return;
			}
			vueComponent.utils.showNurseExcuteSheetPreviewNew(userID, timeStamp, printFlag, queryTypeCode, webIP, true, 1, "NurseOrder.xml", userName);
			var markStateTimer = setInterval(getRecordMarkStatus, 500);

			function getRecordMarkStatus() {
				runServerMethod("getRecordMarkStatus", userID, timeStamp).then(function (state) {
					if (String(state).replace(/(\r\n)|(\n)|(\s)/g, '') === "P") {
						window.clearInterval(markStateTimer);
						closeLoading(loadingInstance);
						setExecPrintFlag(execNotFilterChunks, printFlag, info, runServerMethod, timeStamp, vueComponent, requestQuery);
					}
					var timeNow = new Date().getTime();
					if (timeNow - timeStamp > 60000) {
						window.clearInterval(markStateTimer);
						closeLoading(loadingInstance);
						$message({
							message: "打印超时!",
							duration: 0,
							showClose: true,
							type: "error"
						});
					}
				});
			}
		};
	}

	/**
	 * @description 执行并打印,并返回执行执行记录的闭包函数
	 * @param {any} orders  医嘱对象数组
	 * @param {any} check   有没有医嘱被选中
	 * @param {any} printFlag 按钮设置信息里的打印标记
	 * @param {any} vueComponent vue组件
	 * @returns  闭包函数,执行该函数可以执行执行记录
	 */
	function excuteOrderAndPrint(orders, check, printFlag, vueComponent, buttonData, queryDataNeedToBePrint) {
		var execIDNeedToBeExcute = [];
		var execNeedToBeExcuteMap = {};
		var $message = vueComponent.$message;
		var searchCondition = vueComponent.searchCondition;
		orders.forEach(function (order) {
			if (order.check || order.indeterminate) {
				order.execInfos.forEach(function (execInfo) {
					if (execInfo.check) {
						var disposeStatCode = execInfo.disposeStatCode;
						if ((disposeStatCode === 'Needless') ||
							(disposeStatCode === 'Immediate') ||
							(disposeStatCode === 'LongNew') ||
							(disposeStatCode === 'Temp') ||
							(disposeStatCode === 'LongUnnew') ||
							(disposeStatCode === 'SkinTestNorm')) {
							execIDNeedToBeExcute.push(execInfo.ID);
							execNeedToBeExcuteMap[execInfo.ID] = order;
						}
					}
				})
			}
		});
		if ((execIDNeedToBeExcute.length === 0) && (execIDNeedToBeDiscontinued.length === 0)) {
			return '请选择需要执行的医嘱!';
		}
		return function (requestQuery, runServerMethod, info) {
			var promises = [];
			var skinTestFlag = info.skinTestFlag || '';
			var execStatusCode = info.execStatusCode || 'F';
			var userID = info.userID1 || '';
			var locID = info.locID || '';
			var queryTypeCode = info.queryTypeCode || '';
			var date = info.date || '';
			var time = info.time || '';
			var changeReasonDr = info.changeReasonDr || '';
			var userName = vueComponent.session.USER.USERNAME;

			//打印
			//var DHCCNursePrintComm = vueComponent.utils.getPrintDll();
			var ifPrintTitle = vueComponent.ifPrintTitle.toString();
			var startPage = 1;
			var hospitalID = vueComponent.session.USER.HOSPITALID;
			var webIP = vueComponent.session.USER.WEBIP;
			// var queryTypeCode = info.queryTypeCode.toUpperCase() || '';
			var oeordIDString = "";
			var seqIDString = "";
			// if (queryTypeCode.indexOf("CQSYD") > -1) {
			oeordIDString = execIDNeedToBeExcute.join("^");
			seqIDString = execIDNeedToBeExcute.join("^");

			var errors = [];
			execIDNeedToBeExcute.forEach(function (ID) {
				promises.push(runServerMethod('UpdateOrdGroup', skinTestFlag, ID, execStatusCode, userID, locID, queryTypeCode, date, time, changeReasonDr).then(function (result) {
					if (String(result) !== '0') {
						errors.push("<div>" + execNeedToBeExcuteMap[ID].arcimDesc + ": " + result + "</div>");
					}
				}));
			});

			var axios = window.axios;
			var loadingInstance = vueComponent.$loading({
				text: "执行并打印后台处理中..."
			});
			axios.all(promises).then(function () {
				if (errors.length !== 0) {
					$message({
						message: errors.join(' '),
						duration: 0,
						showClose: true,
						type: "error",
						dangerouslyUseHTMLString: true
					});
				} else {
					$message.success('执行成功');
				}
			}).then(function () {
				try {
					/*if (searchCondition.excutedOrderFlag || searchCondition.printedOrderFlag) {
						var printDateObject = queryDataNeedToBePrint(false, false);
					} else {
						// 不勾上已执行和已打印时过滤已打印过的执行记录
						var printDateObject = queryDataNeedToBePrint(false, false, true);
					}*/
					if (searchCondition.excutedOrderFlag || searchCondition.printedOrderFlag) {
						if (searchCondition.sheetCode === 'cqkfyd') {
							var printDateObject = queryDataNeedToBePrint(false, false, false, false, true);
						} else if (searchCondition.sheetCode === 'CQZLD') {
							var printDateObject = queryDataNeedToBePrint(false, false, false, false, false, false, false, false, true);
						} else {
							var printDateObject = queryDataNeedToBePrint(false, false, false);
						}
					} else {
						// 不勾上已执行和已打印时过滤已打印过的执行记录
						if (searchCondition.sheetCode === 'cqkfyd') {
							var printDateObject = queryDataNeedToBePrint(false, false, true, false, true);
						} else if (searchCondition.sheetCode === 'CQZLD') {
							var printDateObject = queryDataNeedToBePrint(false, false, false, false, false, false, false, false, true);
						} else {
							var printDateObject = queryDataNeedToBePrint(false, false, true);
						}
					}
					var execIDNeedToBePrint = printDateObject.execIDs;
					if (execIDNeedToBePrint.length === 0) {
						closeLoading(loadingInstance);
						//setTimeout(loadingInstance.close(), 1000);
						requestQuery();
						return;
					}
					var execSeqIDNeedToBePrint = printDateObject.execSeqIDs;
					var orderIDNeedToBePrint = printDateObject.orderIDs;
					var orderSeqIDNeedToBePrint = printDateObject.orderSeqIDs;
					var execIDsOfNoFilteringSameDate = printDateObject.execIDsOfNoFilteringSameDate;
					///if (queryTypeCode != 'cqkfyd') {
					DHCCNursePrintComm.showNurseExcuteSheetPreviewNew(execIDNeedToBePrint.join("^"), execSeqIDNeedToBePrint.join("^"), "WARD", queryTypeCode, webIP, true, 1, "NurseOrder.xml", userName);
					///} else {
					//	DHCCNursePrintComm.showNurseExcuteSheetPreviewNew(orderIDNeedToBePrint.join("^"), orderSeqIDNeedToBePrint.join("^"), "WARD", queryTypeCode, webIP, true, 1, "NurseOrder.xml", userName);
					//}
				} catch (e) {
					closeLoading(loadingInstance);
					$message.error(e.message);
					return;
				}
				if (DHCCNursePrintComm.saveFlag == 1) {
					var savePrintFlagPromises = [];
					var chunks = vueComponent.utils.splitChunk([], 20, execIDNeedToBePrint);
					var execNotFilterChunks = vueComponent.utils.splitChunk([], 20, execIDNeedToBeExcute);
					var execSeqIdChunks = vueComponent.utils.splitChunk([], 20, execSeqIDNeedToBePrint);
					chunks.forEach(function (chunk) {
						savePrintFlagPromises.push(runServerMethod(
							'setExecPrintFlag',
							chunk.join('^'),
							userID,
							queryTypeCode,
							printFlag))
					});
					execNotFilterChunks.forEach(function (chunk) {
						savePrintFlagPromises.push(runServerMethod(
							'setExecPrintFlag',
							chunk.join('^'),
							userID,
							queryTypeCode,
							printFlag))
					});
					axios.all(savePrintFlagPromises).then(function () {
						// 勾上已执行和已打印时不保存打印日志
						closeLoading(loadingInstance);
						if (searchCondition.excutedOrderFlag || searchCondition.printedOrderFlag) {
							requestQuery();
						} else {
							saveRecord(runServerMethod, chunks, execSeqIdChunks, queryTypeCode, printFlag, info, vueComponent, requestQuery);
						}
						// loadingInstance.close();
						// requestQuery();
						/*if (String(ret) !== '0') {
						$message({
						message: ret,
						duration: 0,
						showClose: true,
						type: 'error',
						dangerouslyUseHTMLString: true
						});
						}*/
					});
				}
			});
		};
	}

	/**
	 * @description 检验条码打印
	 * @param {any} orders
	 * @param {any} check
	 * @param {any} printFlag
	 * @param {any} vueComponent
	 * @returns
	 */
	function lisBarPrint(orders, check, printFlag, vueComponent, buttonData, queryDataNeedToBePrint) {
		var $message = vueComponent.$message;
		var searchCondition = vueComponent.searchCondition;
		var printDateObject = queryDataNeedToBePrint(true, false, false, false, false, false, false, false, false, true);
		var orderExecIDNeedToBePrint = printDateObject.execIDs;
		var seqIDNeedToBePrint = printDateObject.execLabNos;
		var execIDsOfNoFilteringSameDate = printDateObject.execIDsOfNoFilteringSameDate;
		var userName = vueComponent.session.USER.USERNAME;
		if (orderExecIDNeedToBePrint.length === 0) {
			return '未选择医嘱,或者选择的医嘱不满足打印条件!';
		}
		return function (requestQuery, runServerMethod, info) {
			//打印
			var DHCCNursePrintComm = vueComponent.utils.getPrintDll();
			var webIP = vueComponent.session.USER.WEBIP;
			var hospitalID = vueComponent.session.USER.HOSPITALID;
			var queryTypeCode = info.queryTypeCode || '';
			var userID = info.userID1 || '';
			var chunks = vueComponent.utils.splitChunk([], 20, orderExecIDNeedToBePrint);
			var execSeqIdChunks = vueComponent.utils.splitChunk([], 20, seqIDNeedToBePrint);
			var execNotFilterChunks = vueComponent.utils.splitChunk([], 20, execIDsOfNoFilteringSameDate);
			var timeStamp = new Date().getTime();
			var loadingInstance = null;
			/*saveRecord(runServerMethod, chunks, execSeqIdChunks, chunks, printFlag, info, vueComponent, timeStamp).then(function () {
				loadingInstance = vueComponent.$loading({
					text: "查询打印状态..."
				});
			});*/
			var ifSaveFinish = saveRecord(runServerMethod, chunks, execSeqIdChunks, chunks, printFlag, info, vueComponent, timeStamp);
			if (ifSaveFinish) {
				loadingInstance = vueComponent.$loading({
					text: "查询打印状态..."
				});
			}
			else {
				closeLoading(loadingInstance);
				$message({
					message: "打印超时!",
					duration: 0,
					showClose: true,
					type: "error"
				});
				return;
			}
			if (queryTypeCode === 'JYD') {
				vueComponent.utils.showNurseExcuteSheetPreviewNew(userID, timeStamp, printFlag, queryTypeCode, webIP, true, 1, "NurseOrder.xml", userName);
			}
			else {
				vueComponent.utils.showNurseExcuteSheetPreviewNew(userID, timeStamp, printFlag, queryTypeCode, webIP, true, 1, "NurseOrderOP.xml", userName);
			}
			var markStateTimer = setInterval(getRecordMarkStatus, 500);

			function getRecordMarkStatus() {
				runServerMethod("getRecordMarkStatus", userID, timeStamp).then(function (state) {
					if (String(state).replace(/(\r\n)|(\n)|(\s)/g, '') === "P") {
						window.clearInterval(markStateTimer);
						closeLoading(loadingInstance);
						setExecPrintFlag(execNotFilterChunks, printFlag, info, runServerMethod, timeStamp, vueComponent, requestQuery);
					}
					var timeNow = new Date().getTime();
					if (timeNow - timeStamp > 60000) {
						window.clearInterval(markStateTimer);
						closeLoading(loadingInstance);
						$message({
							message: "打印超时!",
							duration: 0,
							showClose: true,
							type: "error"
						});
					}
				});
			}
		};
	}
	/**
	 * @description 输液注射条码打印(输液贴/注射贴)
	 * @param {any} orders
	 * @param {any} check
	 * @param {any} printFlag
	 * @param {any} vueComponent
	 * @returns
	 */
	function infusionBarPrint(orders, check, printFlag, vueComponent, buttonData, queryDataNeedToBePrint) {
		var $message = vueComponent.$message;
		var sheetCode = vueComponent.searchCondition.sheetCode;
		var printDateObject = queryDataNeedToBePrint(false, false, false, false, false, true, false, true);
		var orderExecIDNeedToBePrint = printDateObject.execIDs;
		var seqIDNeedToBePrint = printDateObject.execSeqIDs;
		var execIDsOfNoFilteringSameDate = printDateObject.execIDsOfNoFilteringSameDate;
		if (orderExecIDNeedToBePrint.length === 0) {
			return '未选择医嘱,或者选择的医嘱不满足打印条件!';
		}
		return function (requestQuery, runServerMethod, info) {
			//打印
			var DHCCNursePrintComm = vueComponent.utils.getPrintDll();
			var webIP = vueComponent.session.USER.WEBIP;
			var hospitalID = vueComponent.session.USER.HOSPITALID;
			var queryTypeCode = info.queryTypeCode || '';
			var userName = info.userName || '';

			DHCCNursePrintComm.showNurseExcuteSheetPreviewNew(
				orderExecIDNeedToBePrint.join("^"),
				seqIDNeedToBePrint.join("^"),
				printFlag,
				queryTypeCode,
				webIP,
				true,
				1,
				"NurseOrder.xml",
				userName);
			if (
				orderExecIDNeedToBePrint.length !== 0 &&
				DHCCNursePrintComm.saveFlag == 1) {
				var axios = window.axios;
				var savePrintFlagPromises = [];
				var chunks = vueComponent.utils.splitChunk([], 20, execIDsOfNoFilteringSameDate);
				var userID = info.userID1 || '';
				chunks.forEach(function (chunk) {
					savePrintFlagPromises.push(runServerMethod(
						'setExecPrintFlag',
						chunk.join('^'),
						userID,
						queryTypeCode,
						printFlag))

				});
				var loadingInstance = vueComponent.$loading({
					text: "注射治疗贴后台处理中..."
				});
				axios.all(savePrintFlagPromises).then(function () {
					closeLoading(loadingInstance);
					requestQuery();
					// if (String(ret) !== '0') {
					// 	$message({
					// 		message: ret,
					// 		duration: 0,
					// 		showClose: true,
					// 		type: 'error',
					// 		dangerouslyUseHTMLString: true
					// 	});
					// }
				});
			}
		};
	}
	/**
		 * @description 撤销条码关联
		 * @param {any} orders
		 * @param {any} check
		 * @param {any} printFlag
		 * @param {any} vueComponent
		 * @returns
		 */
	function clearPlacerNo(orders, check, printFlag, vueComponent) {
		var orderExecIDNeedToBeClear = [];
		var $message = vueComponent.$message;
		// var $nextTick = vueComponent.$nextTick;
		orders.forEach(function (order) {
			if (order.check && check) {
				order.execInfos.forEach(function (execInfo) {
					if (execInfo.check) {
						orderExecIDNeedToBeClear.push(execInfo.ID);
					}
				});
			}
		});
		if (orderExecIDNeedToBeClear.length === 0) {
			return '请选择需要撤销条码关联的医嘱!';
		}

		return function (requestQuery, runServerMethod, info) {
			var promises = [];
			var userID = info.userID1 || '';
			var errors = [];
			orderExecIDNeedToBeClear.forEach(function (ID) {
				promises.push(
					runServerMethod('setPlacerNo', userID, ID, '', 'Y').then(function (
						result
					) {
						if (String(result) !== '0') {
							errors.push(result);
						}
					})
				);
			});
			var loadingInstance = vueComponent.$loading({
				text: '撤销条码关联处理中...',
			});
			var axios = window.axios;
			axios.all(promises).then(function () {
				closeLoading(loadingInstance);
				requestQuery();
				if (errors.length !== 0) {
					$message({
						message: errors.join(' '),
						showClose: true,
						type: 'error'
					});
				} else {
					$message.success('撤销条码关联成功');
				}
			});
		};
	}
	/**
	 * @description 关联预制条码的条码号
	 * @param {any} requestQuery 刷新医嘱列表的函数
	 * @param {any} runServerMethod 调用后台的函数
	 * @param {any} orderItemVueComponent
	 * @param {any} orderExcuteComponent
	 * @returns
	 */
	function setPlacerNo(requestQuery, runServerMethod, orderItemVueComponent, orderExcuteComponent) {
		var placerNo = String(orderItemVueComponent.$refs["placerNoInput"][0].value);
		$message = orderExcuteComponent.$message;
		var order = orderItemVueComponent.order;
		window.runServerMethod = runServerMethod;

		function matchSplacerNo(placerNo, orderObject) {
			//南方医院规则
			if (orderObject.containerInfo && orderObject.containerInfo.startCode) {
				var startCode = placerNo.slice(0, 2);
				if (String(startCode) !== String(orderObject.containerInfo.startCode)) {
					$message({
						message: "容器标签不对,请选择" + orderObject.containerInfo.startCode + "开头,长度为" + orderObject.containerInfo.placerNoLength + "的容器!",
						type: 'error',
						duration: 2000
					});
					return false;
				}
			}
			if (placerNo.length > 9) {
				return true;
			} else {
				$message({
					message: "条码位数不对,至少为10位!",
					type: 'error',
					duration: 2000
				});
				return false;
			}
		}
		if (!matchSplacerNo(placerNo, order)) {
			return;
		}
		var userID = orderExcuteComponent.session.USER.USERID;
		var orderID = orderItemVueComponent.order.ID;
		var userDeptId = orderExcuteComponent.session.USER.CTLOCID;
		var queryTypeCode = orderExcuteComponent.searchInfo.sheetCode;
		var updateSpacerThen = function (result) {
			if (String(result) === "0") {
				$message.success(order.arcimDesc + "置采血时间成功!");
				requestQuery();
			} else if (result !== undefined) {
				$message({
					message: order.arcimDesc + " : 置采血时间失败!",
					type: 'error',
					duration: 1000
				});
				return false;
				
			}
		};

		runServerMethod("setPlacerNo", userID, orderID, placerNo).then(function (ret) {
			if (String(ret) !== "0") {
				order.placerNo = "";
				$message.error(String(ret));
				//requestQuery();
			} else {
				var labNo = order.labNo;
				var orders = orderExcuteComponent.orderList.data.orders;
				var focus = false;
				orders.forEach(function (orderObject) {
					if (labNo === orderObject.labNo) {
						orderObject.check = true;
						orderObject.placerNo = placerNo;
						orderObject.indeterminate = false;
						orderObject.execInfos.forEach(function (exec) {
							exec.check = true;
						});
					}
					if ((labNo !== orderObject.labNo) && (!focus) && (orderObject.placerNo === "")) {
						orderObject.focus = !orderObject.focus;
						focus = true;
					}
				});
				//非急查到这里结束
				// var sheetCode = orderExcuteComponent.searchInfo.sheetCode;
				if (order.emergency === "Y") {
					//急查需要立即对需要置备注的检验置上备注
					return order.containerInfo && order.containerInfo.requireNotes;
				}
				return false;
			}
		}).then(function (result) {
			//需要置备注
			if (result === true) {
				var ID = orderID.split("||")[0];
				orderExcuteComponent.ifShowOrderSetPlacerNotes = true;
				orderExcuteComponent.$nextTick(function () {
					orderItemVueComponent.order.patient = orderExcuteComponent.orderIDMapPatient[ID];
					orderExcuteComponent.ordersOfOrderSetPlacerNotes = [orderItemVueComponent.order];
					orderExcuteComponent.funcOfOrderSetPlacerNotes = function () {
						return runServerMethod("updateSpacer", order.execInfos[0].ID, userID).then(updateSpacerThen);
					};
				})
				orderExcuteComponent.patients.forEach(function (patient) {
					if (String(patient.orderID) === String(ID)) { }
				});
			} else if (result === false) {
				//不需要置备注,立即置采血时间
				return runServerMethod("updateSpacer", order.execInfos[0].ID, userID, userDeptId, queryTypeCode);
			}
		}).then(updateSpacerThen);
		/**********2017-07-25 加*/
		// var ret = tkMakeServerCall("Nur.NurseCarryDetail", "save", placerNo, userId) //
		// parent.frames["middle"].location.reload();
		// self.location.reload();
		/**************/
	}

	/**
	 * @description 皮试阴性
	 * @param {any} orders  医嘱对象数组
	 * @param {any} check   有没有医嘱被选中
	 * @param {any} printFlag 按钮设置信息里的打印标记
	 * @param {any} vueComponent vue组件
	 * @returns  闭包函数,执行该函数可以执行执行记录
	 */
	function skinTestNormal(orders, check, printFlag, vueComponent) {
		return updateSkinTestResult(orders, check, vueComponent, 'N');
	}
	/**
	 * @description 皮试阳性
	 * @param {any} orders  医嘱对象数组
	 * @param {any} check   有没有医嘱被选中
	 * @param {any} printFlag 按钮设置信息里的打印标记
	 * @param {any} vueComponent vue组件
	 * @returns  闭包函数,执行该函数可以执行执行记录
	 */
	function skinTestAllergy(orders, check, printFlag, vueComponent) {
		return updateSkinTestResult(orders, check, vueComponent, 'Y');
	}

	/**
	 * @description 带PPD置皮试结果
	 * @param {any} orders  医嘱对象数组
	 * @param {any} check   有没有医嘱被选中
	 * @param {any} printFlag 按钮设置信息里的打印标记
	 * @param {any} vueComponent vue组件
	 * @returns  闭包函数,执行该函数可以执行执行记录
	 */
	function setSkinTest(orders, check, printFlag, vueComponent) {
		return updateSkinTestResult(orders, check, vueComponent, '');
	}
	/**
	 * @description 带PPD置皮试结果
	 * @param {any} orders  医嘱对象数组
	 * @param {any} check   有没有医嘱被选中
	 * @param {any} printFlag 按钮设置信息里的打印标记
	 * @param {any} vueComponent vue组件
	 * @returns  闭包函数,执行该函数可以执行执行记录
	 */
	function savePPDResult(runServerMethod, userID, oeoriId, ppd, date, time, loadingInstance, requestQuery, vueComponent) {
		var $message = vueComponent.$message;
		var PPDResult = ppd.PPDResult;
		var RecUser = userID;
		var TestOeoriDr = oeoriId;
		var TestSkinSityOne = ppd.indurationWidth;
		var TestSkinSityTwo = ppd.indurationHeight;
		var TestSkinVclOne = ppd.blisterWidth;
		var TestSkinVclTwo = ppd.blisterHeight;
		var TestSkinSwoOne = ppd.redSwollenWidth;
		var TestSkinSwoTwo = ppd.redSwollenHeight;
		var TestSkinNecrosis = ppd.deadLymphatic[0] || '';
		var TestSkinInflam = ppd.deadLymphatic[1] || '';
		var TestSkinSing = ppd.blisterState;
		runServerMethod("savePPDResult", PPDResult, RecUser, date, time, TestOeoriDr, TestSkinSityOne, TestSkinSityTwo, TestSkinVclOne, TestSkinVclTwo, TestSkinSwoOne, TestSkinSwoTwo, TestSkinNecrosis, TestSkinInflam, TestSkinSing).then(function (ppdResult) {
			if (String(ppdResult) === "0") {
				closeLoading(loadingInstance);
				requestQuery();
				$message.success('保存PPD结果成功!');
			} else {
				closeLoading(loadingInstance);
				$message.error(String(ppdResult));
				requestQuery();
			}
		});
	}
	/**
	 * @description 置皮试结果
	 * @param {any} orders  医嘱对象数组
	 * @param {any} check   有没有医嘱被选中
	 * @param {any} vueComponent vue组件
	 * @param {any} flag  皮试结果
	 * @returns  闭包函数,执行该函数可以执行执行记录
	 */
	function updateSkinTestResult(orders, check, vueComponent, flag) {
		var skinTestOrders = [];
		var skinTestOrdersMap = {};
		var $message = vueComponent.$message;
		orders.forEach(function (order) {
			if (order.check || order.indeterminate) {
				var length = order.execInfos.length;
				for (i = 0; i < length; i++) {
					var execInfo = order.execInfos[i];
					if (execInfo.check) {
						skinTestOrders.push(execInfo.ID);
						skinTestOrdersMap[execInfo.ID] = order;
						break;
					}
				}
			}
		});
		if (skinTestOrders.length === 0) {
			return '请选择一条皮试医嘱置皮试结果!';
		}
		if (skinTestOrders.length > 1) {
			return '请只选择一条皮试医嘱置皮试结果!';
		}
		return function (requestQuery, runServerMethod, info) {
			var promises = [];
			var execStatusCode = 'F'; //info.execStatusCode ||
			var userID = info.userID1 || '';
			var locID = info.locID || '';
			var queryTypeCode = info.queryTypeCode || '';
			var skinDate = info.date || '';
			var skinTime = info.time || '';
			var skinNote = info.notes || '';
			var batch = info.number || '';
			var skinTestResult = info.skinTestResult || '';
			var changeReasonDr = info.changeReasonDr || '';
			var userID2 = info.userID2 || '';
			var ifPPDOrder = info.ifPPDOrder || '';
			var errors = [];
			var oeoriId = skinTestOrders[0];
			if (skinTestResult === '阴性') {
				flag = 'N';
			}
			if (skinTestResult === '阳性') {
				flag = 'Y';
			}
			/* if (skinTestOrdersMap[skinTestOrders[0]].abnorm === flag) {
				return '已经设置过相同皮试结果,无需重复设置!';
			} */
			var loadingInstance = vueComponent.$loading({
				text: "置皮试后台处理中..."
			});
			runServerMethod('setSkinTestResult', oeoriId, userID, flag, execStatusCode, locID, queryTypeCode, skinDate, skinTime, skinNote, changeReasonDr, batch, userID2).then(function (result) {
				if (String(result) !== '0') {
					closeLoading(loadingInstance);
					requestQuery();
					errors.push("<div>" + skinTestOrdersMap[oeoriId].arcimDesc + ": " + result + "</div>");
					$message.error(errors.join(' '));
				}
				else {
					if (ifPPDOrder) {
						savePPDResult(runServerMethod, userID, oeoriId, info.PPD, skinDate, skinTime, loadingInstance, requestQuery, vueComponent);
					} else {
						closeLoading(loadingInstance);
						requestQuery();
						$message.success('置皮试结果成功!');
					}
				}
			});
		};
	}
	/**
	 * @description 采样确认,南方医院用
	 * @param {any} orders
	 * @param {any} check
	 * @param {any} printFlag
	 * @param {any} vueComponent
	 * @param {any} buttonData 点击的按钮数据
	 * @returns
	 */
	function updateSpacer(orders, check, printFlag, vueComponent, buttonData) {
		var orderIDNeedToBeSpace = [];
		var oeordIDNeedToBeSpace = [];
		var orderNeedToNote = [];
		var $message = vueComponent.$message;
		var $nextTick = vueComponent.$nextTick;
		orders.forEach(function (order) {
			if (check && (order.check === check) && order.placerNo) {
				orderIDNeedToBeSpace.push(order.ID);
				if (order.execInfos.length === 1) {
					oeordIDNeedToBeSpace.push(order.execInfos[0].ID);
				} else {
					return '检验医嘱对应的执行记录大于1';
				}
				if (order.containerInfo && order.containerInfo.requireNotes) {
					order.patient = vueComponent.orderIDMapPatient[order.ID.split("||")[0]];
					orderNeedToNote.push(order);
				}
			}
		});
		if (orderIDNeedToBeSpace.length === 0) {
			return '请选择需要采样的医嘱!';
		}
		//打开置检验备注窗口
		vueComponent.ifShowOrderSetPlacerNotes = (orderNeedToNote.length !== 0);
		vueComponent.ordersOfOrderSetPlacerNotes = (orderNeedToNote.length !== 0) ? orderNeedToNote : [];

		if (buttonData.ifShowWindow) {
			//需要签名验证的时候返回置采血时间的函数
			return function (requestQuery, runServerMethod, info, loadingInstance) {
				var userID = info.userID || vueComponent.session.USER.USERID;
				var skinTestFlag = info.skinTestFlag || '';
				var execStatusCode = info.execStatusCode || 'F';
				var locID = info.locID || '';
				var queryTypeCode = info.queryTypeCode || '';
				var date = info.date || '';
				var time = info.time || '';
				var changeReasonDr = info.changeReasonDr || '';
				var updateSpacerThen = function (result) {
					loadingInstance.close();
					requestQuery();
					if (String(result) === "0") {
						$message.success("置采血时间成功!");
					} else {
						$message({
							message: " : 置采血时间失败!",
							type: 'error',
							duration: 1000
						});
					}
				};
				runServerMethod("updateSpacer", orderIDNeedToBeSpace.join("^"), userID, skinTestFlag, oeordIDNeedToBeSpace.join("^"), execStatusCode, locID, queryTypeCode, date, time, changeReasonDr).then(updateSpacerThen);
			};
		} else {
			var userID = vueComponent.session.USER.USERID;
			var skinTestFlag = info.skinTestFlag || '';
			var execStatusCode = info.execStatusCode || 'F';
			var locID = info.locID || '';
			var queryTypeCode = info.queryTypeCode || '';
			var date = info.date || '';
			var time = info.time || '';
			var changeReasonDr = info.changeReasonDr || '';
			vueComponent.funcOfOrderSetPlacerNotes = function () {
				var updateSpacerThen = function (result) {
					vueComponent.requestQuery();
					if (String(result) === "0") {
						$message.success("置采血时间成功!");
					} else {
						$message({
							message: " : 置采血时间失败!",
							type: 'error',
							duration: 1000
						});
					}
				};
				vueComponent.runServerMethod("updateSpacer", orderIDNeedToBeSpace.join("^"), userID, skinTestFlag, oeordIDNeedToBeSpace.join("^"), execStatusCode, locID, queryTypeCode, date, time, changeReasonDr).then(updateSpacerThen);
			};
			//不需要签名验证的时候返回空函数
			return function (requestQuery, runServerMethod, info, loadingInstance) {
				loadingInstance.close();
			};
		}

	}
	/**
	 * @description 检查dll更新状态
	 */
	function checkUpgrade() {
		var curUrl = window.location.href;
		var webIP = curUrl.split("imedical")[0];
		debugger;
		var checkUpgradeRet = DHCCNursePrintComm.CheckUpgrade(webIP);
		if (checkUpgradeRet == 0) {
			alert("插件升级成功,请重启浏览器!")
			return false;
		}
		else if (checkUpgradeRet == -1) {
			alert("插件升级失败,请联系工程师!")
			return false;
		}
		else if (checkUpgradeRet == 1) {
			return true;			
		}
		else {
			return false;
		}
	}
	/**
	 * @description 打印执行单(病区) dll方式
	 * @param {any} orders
	 * @param {any} check
	 * @param {any} printFlag
	 * @param {any} vueComponent
	 * @returns
	 */
	function orderExecPrintWardDLL(orders, check, printFlag, vueComponent, buttonData, queryDataNeedToBePrint) {
		var $message = vueComponent.$message;
		var $nextTick = vueComponent.$nextTick;
		var searchCondition = vueComponent.searchCondition;
		var printDateObject = null;
		if (searchCondition.sheetCode !== "PSD") {
			printDateObject = queryDataNeedToBePrint(false, false, false);
		} else {
			printDateObject = queryDataNeedToBePrint(false, false, false, false, true);
		}
		var execIDNeedToBePrint = printDateObject.execIDs;
		var execSeqIDNeedToBePrint = printDateObject.execSeqIDs;
		var execIDsOfNoFilteringSameDate = printDateObject.execIDsOfNoFilteringSameDate;

		if (execIDNeedToBePrint.length === 0) {
			return '请选择需要打印的医嘱!';
		}
		return function (requestQuery, runServerMethod, info) {
			//打印
			var startPage = 1;
			var hospitalID = vueComponent.session.USER.HOSPITALID;
			var webIP = vueComponent.session.USER.WEBIP;
			var queryTypeCode = info.queryTypeCode || '';
			var userID = info.userID1 || '';
			var userName = info.userName || '';
			var printType = "WARD";
			var startDate = info.searchInfo.startDate || '';
			var endDate = info.searchInfo.endDate || '';
			var startTime = info.searchInfo.startTime || '';
			var endTime = info.searchInfo.endTime || '';
			var searchRange = startDate + " " + startTime + "--" + endDate + " " + endTime;
			var loadingInstance = null;
			var locID = info.locID || '';
			var groupID = vueComponent.session.USER.GROUPID || '';
			if (checkUpgrade()) {
				DHCCNursePrintComm.showNurseExcuteSheetPreviewNew(execIDNeedToBePrint.join('^'), execSeqIDNeedToBePrint.join('^'), printType, queryTypeCode, webIP, true, 1, "NurseOrder.xml", userID, userName, searchRange, locID, groupID, printFlag);
				var ifSaveFinish = DHCCNursePrintComm.saveFlag;
				if (ifSaveFinish == 1) {
					closeLoading(loadingInstance);
					requestQuery();
				}
				else {
					closeLoading(loadingInstance);
					requestQuery();
					$message({
						message: "打印超时!",
						duration: 0,
						showClose: true,
						type: "error"
					});
					return;
				}
			}

		};
	}
	/**
	 * @description 打印执行单(个人) dll方式
	 * @param {any} orders
	 * @param {any} check
	 * @param {any} printFlag
	 * @param {any} vueComponent
	 * @returns
	 */
	function orderExecPrintPersonDLL(orders, check, printFlag, vueComponent, buttonData, queryDataNeedToBePrint) {
		var $message = vueComponent.$message;
		var $nextTick = vueComponent.$nextTick;
		var searchCondition = vueComponent.searchCondition;
		var printDateObject = null;
		if (searchCondition.sheetCode !== "PSD") {
			printDateObject = queryDataNeedToBePrint(false, false, false);
		} else {
			printDateObject = queryDataNeedToBePrint(false, false, false, false, true);
		}
		var execIDNeedToBePrint = printDateObject.execIDs;
		var execSeqIDNeedToBePrint = printDateObject.execSeqIDs;
		var execIDsOfNoFilteringSameDate = printDateObject.execIDsOfNoFilteringSameDate;

		if (execIDNeedToBePrint.length === 0) {
			return '请选择需要打印的医嘱!';
		}
		return function (requestQuery, runServerMethod, info) {
			//打印
			var startPage = 1;
			var hospitalID = vueComponent.session.USER.HOSPITALID;
			var webIP = vueComponent.session.USER.WEBIP;
			var queryTypeCode = info.queryTypeCode || '';
			var userID = info.userID1 || '';
			var userName = info.userName || '';
			var oeordIDString = "";
			var seqIDString = "";
			var printType = "PAT";
			var startDate = info.searchInfo.startDate || '';
			var endDate = info.searchInfo.endDate || '';
			var startTime = info.searchInfo.startTime || '';
			var endTime = info.searchInfo.endTime || '';
			var searchRange = startDate + " " + startTime + "--" + endDate + " " + endTime;			
			var loadingInstance = null;
			var locID = info.locID || '';
			var groupID = vueComponent.session.USER.GROUPID || '';
			if (checkUpgrade()) {
				DHCCNursePrintComm.showNurseExcuteSheetPreviewNew(execIDNeedToBePrint.join('^'), execSeqIDNeedToBePrint.join('^'), printType, queryTypeCode, webIP, true, 1, "NurseOrder.xml", userID, userName, searchRange, locID, groupID, printFlag);
				var ifSaveFinish = DHCCNursePrintComm.saveFlag;
				if (ifSaveFinish == 1) {
					closeLoading(loadingInstance);
					requestQuery();
				}
				else {
					closeLoading(loadingInstance);
					requestQuery();
					$message({
						message: "打印超时!",
						duration: 0,
						showClose: true,
						type: "error"
					});
					return;
				}
			}
		};
	}
	/**
	 * @description 贴瓶签打印 dll方式
	 * @param {any} orders
	 * @param {any} check
	 * @param {any} printFlag
	 * @param {any} vueComponent
	 * @returns
	 */
	function infusionLabelPrintDLL(orders, check, printFlag, vueComponent, buttonData, queryDataNeedToBePrint) {
		var $message = vueComponent.$message;
		var printDateObject = queryDataNeedToBePrint(false, false, false);
		var orderExecIDNeedToBePrint = printDateObject.execIDs;
		var seqIDNeedToBePrint = printDateObject.execSeqIDs;
		var execIDsOfNoFilteringSameDate = printDateObject.execIDsOfNoFilteringSameDate;
		if (orderExecIDNeedToBePrint.length === 0) {
			return '未选择医嘱,或者选择的医嘱不满足打印条件!';
		}
		return function (requestQuery, runServerMethod, info) {
			//打印
			var webIP = vueComponent.session.USER.WEBIP;
			var hospitalID = vueComponent.session.USER.HOSPITALID;
			var queryTypeCode = info.queryTypeCode || '';
			var userID = info.userID1 || '';
			var userName = info.userName || '';
			var loadingInstance = null;
			var printType = printFlag;
			var locID = info.locID || '';
			var groupID = vueComponent.session.USER.GROUPID || '';
			if (checkUpgrade()) {
				DHCCNursePrintComm.showNurseExcuteSheetPreviewNew(orderExecIDNeedToBePrint.join('^'), seqIDNeedToBePrint.join('^'), printType, queryTypeCode, webIP, true, 1, "NurseOrder.xml", userID, userName, "", locID, groupID, printFlag);
				var ifSaveFinish = DHCCNursePrintComm.saveFlag;
				if (ifSaveFinish == 1) {
					closeLoading(loadingInstance);
					requestQuery();
				}
				else {
					closeLoading(loadingInstance);
					requestQuery();
					$message({
						message: "打印超时!",
						duration: 0,
						showClose: true,
						type: "error"
					});
					return;
				}
			}
		};
	}
	/**
	 * @description 输液卡打印 dll方式
	 * @param {any} orders
	 * @param {any} check
	 * @param {any} printFlag
	 * @param {any} vueComponent
	 * @returns
	 */
	function infusionCardPrintDLL(orders, check, printFlag, vueComponent, buttonData, queryDataNeedToBePrint) {
		var $message = vueComponent.$message;
		var printDateObject = queryDataNeedToBePrint(false);
		var orderExecIDNeedToBePrint = printDateObject.execIDs;
		var seqIDNeedToBePrint = printDateObject.execSeqIDs;
		var execIDsOfNoFilteringSameDate = printDateObject.execIDsOfNoFilteringSameDate;
		if (orderExecIDNeedToBePrint.length === 0) {
			return '请选择需要打印的医嘱!';
		}
		return function (requestQuery, runServerMethod, info) {
			//打印
			var webIP = vueComponent.session.USER.WEBIP;
			var hospitalID = vueComponent.session.USER.HOSPITALID;
			var queryTypeCode = info.queryTypeCode || '';
			var userID = info.userID1 || '';
			var userName = info.userName || '';
			var timeStamp = new Date().getTime();
			var loadingInstance = null;
			var printType = printFlag;
			var locID = info.locID || '';
			var groupID = vueComponent.session.USER.GROUPID || '';
			if (checkUpgrade()) {
				DHCCNursePrintComm.showNurseExcuteSheetPreviewNew(orderExecIDNeedToBePrint.join('^'), seqIDNeedToBePrint.join('^'), printType, queryTypeCode, webIP, true, 1, "NurseOrder.xml", userID, userName, "", locID, groupID, printFlag);
				var ifSaveFinish = DHCCNursePrintComm.saveFlag;
				if (ifSaveFinish == 1) {
					closeLoading(loadingInstance);
					requestQuery();
				}
				else {
					closeLoading(loadingInstance);
					requestQuery();
					$message({
						message: "打印超时!",
						duration: 0,
						showClose: true,
						type: "error"
					});
					return;
				}
			}
		};
	}
	/**
	 * @description 检验条码打印 dll方式
	 * @param {any} orders
	 * @param {any} check
	 * @param {any} printFlag
	 * @param {any} vueComponent
	 * @returns
	 */
	function lisBarPrintDLL(orders, check, printFlag, vueComponent, buttonData, queryDataNeedToBePrint) {
		var $message = vueComponent.$message;
		var searchCondition = vueComponent.searchCondition;
		var printDateObject = queryDataNeedToBePrint(true, false, false, false, false, false, false, false, false, true);
		var orderExecIDNeedToBePrint = printDateObject.execIDs;
		var seqIDNeedToBePrint = printDateObject.execLabNos;
		var execIDsOfNoFilteringSameDate = printDateObject.execIDsOfNoFilteringSameDate;
		var userName = vueComponent.session.USER.USERNAME;
		if (orderExecIDNeedToBePrint.length === 0) {
			return '未选择医嘱,或者选择的医嘱不满足打印条件!';
		}
		return function (requestQuery, runServerMethod, info) {
			//打印
			var webIP = vueComponent.session.USER.WEBIP;
			var hospitalID = vueComponent.session.USER.HOSPITALID;
			var queryTypeCode = info.queryTypeCode || '';
			var userID = info.userID1 || '';
			var loadingInstance = null;
			var printType = printFlag;
			var locID = info.locID || '';
			var groupID = vueComponent.session.USER.GROUPID || '';
			if (checkUpgrade()) {
				DHCCNursePrintComm.showNurseExcuteSheetPreviewNew(orderExecIDNeedToBePrint.join('^'), seqIDNeedToBePrint.join('^'), printType, queryTypeCode, webIP, true, 1, "NurseOrder.xml", userID, userName, "", locID, groupID, printFlag);
				var ifSaveFinish = DHCCNursePrintComm.saveFlag;
				if (ifSaveFinish == 1) {
					closeLoading(loadingInstance);
					requestQuery();
				}
				else {
					closeLoading(loadingInstance);
					requestQuery();
					$message({
						message: "打印超时!",
						duration: 0,
						showClose: true,
						type: "error"
					});
					return;
				}
			}
		};
	}
	var OrderExcute = {
		handle: handle,
		seeOrder: seeOrder,
		excuteOrder: excuteOrder,
		cancelOrder: cancelOrder,
		cancelSeeOrder: cancelSeeOrder,
		orderPrint: orderPrint,
		orderExecPrintWard: orderExecPrintWard,
		orderExecPrintPerson: orderExecPrintPerson,
		setPlacerNo: setPlacerNo,
		updateSpacer: updateSpacer,
		skinTestAllergy: skinTestAllergy,
		skinTestNormal: skinTestNormal,
		excuteOrderAndPrint: excuteOrderAndPrint,
		infusionLabelPrint: infusionLabelPrint,
		infusionCardPrint: infusionCardPrint,
		lisBarPrint: lisBarPrint,
		infusionBarPrint: infusionBarPrint,
		setSkinTest: setSkinTest,
		clearPlacerNo: clearPlacerNo,
		orderExecPrintWardDLL: orderExecPrintWardDLL,
		orderExecPrintPersonDLL:orderExecPrintPersonDLL,
		infusionLabelPrintDLL:infusionLabelPrintDLL,
		infusionCardPrintDLL:infusionCardPrintDLL,
		lisBarPrintDLL:lisBarPrintDLL
	};
	window.OrderExcute = OrderExcute;
})()