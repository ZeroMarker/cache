/**
*FileName:	dhcipbillchargecontrol.js
*Anchor:	Lid
*Date:	2015-01-13
*Description:	新版住院收费事件
*/

///需修改：
///1,insuChargeFlag 判断病人是否已经做了医保结算（医保组）
///2,getInsuChargeInfo 如果已经医保结算，医保组需提供已经医保结算的信息 需和js调用的医保信息格式一致
///3,
function loadDHCIPBillEvent(GlobalObj, SessionObj, Config) {
	document.onkeydown = function(e) {
		e = e || window.event;
		FrameEnterkeyCode(e);
	};
	//添加配置按钮事件时需注意：
	//1,对下拉菜单按钮事件id为menu-下拉按钮code-下拉列表code+id
	//2,右键菜单按钮事件id为code
	jQuery("body").delegate("#menu-BusinessHandle-BillDown", "click",  billClick);
	jQuery("body").delegate("#menu-BusinessHandle-ReBillDown", "click", rebillClick);
	jQuery("body").delegate("#menu-BusinessHandle-DelpayDown", "click", cancelPayClick);
	jQuery("body").delegate("#menu-BusinessHandle-ChargeDown", "click", chargeClick);
	jQuery("body").delegate("#menu-BusinessHandle-HalfBillDown", "click", halfBillClick);
	jQuery("body").delegate("#menu-BusinessHandle-CancelHalfDown", "click", delHarfBillClick);
	jQuery("body").delegate("#menu-BusinessHandle-CloseAcountDown", "click", closeAcountClick);
	jQuery("body").delegate("#menu-BusinessHandle-CancelCloseDown", "click", uncloseAcountClick);
	jQuery("body").delegate("#menu-BusinessHandle-AddDepositDown", "click", linkAddDeposit);
	jQuery("body").delegate("#menu-BusinessHandle-RefDepositDown", "click", linkRefDeposit);
	jQuery("body").delegate("#menu-BusinessHandle-RePtFPDown", "click", rePrintInvClick);
	jQuery("body").delegate("#menu-BusinessHandle-PtInvDown", "click", printFPClick);
	jQuery("body").delegate("#menu-BusinessHandle-RefInvDown", "click", abortClick);
	jQuery("body").delegate("#menu-BusinessSearch-PtBillDetDown", "click", linkBillDetail);
	//jQuery("body").delegate("#menu-BusinessSearch-SearchOrdFeeDown", "click", linkSearchOrdFee);  //医嘱费用查询 14.11.3
	jQuery("body").delegate("#menu-BusinessSearch-SearchOrdFeeDown", "click", linkAdmOrderFee);  //医嘱费用查询 14.11.3
	jQuery("body").delegate("#menu-BusinessSearch-SearchTarFeeDown", "click", linkSearchTarFee);  //收费项目查询  14.11.3
	jQuery("body").delegate("#menu-BusinessSearch-SearchDepDetDown", "click", linkSearchDepDet); //押金明细查询 14.11.3
	jQuery("body").delegate("#menu-BusinessSearch-PtLedgerDown", "click", printPtLedger);  //打印台账 14.11.3
	jQuery("body").delegate("#menu-BusinessHandle-HalfBillByOrdDown", "click", HalfChargeByOrd);  //按医嘱拆分账单  14.11.3	
	
	jQuery("body").delegate("#BillRighty", "click", billClick);
	jQuery("body").delegate("#ReBillRighty", "click", rebillClick);
	jQuery("body").delegate("#ChargeRighty", "click", chargeClick);
	jQuery("body").delegate("#DelpayRighty", "click", cancelPayClick);
	jQuery("body").delegate("#RePtFPRighty", "click", rePrintInvClick);
	jQuery("body").delegate("#PtInvRighty", "click", printFPClick);
	jQuery("body").delegate("#RefInvRighty", "click", abortClick);
	jQuery("body").delegate("#CloseAcountRighty", "click", closeAcountClick);
	jQuery("body").delegate("#CancelCloseRighty", "click", uncloseAcountClick);
	jQuery("body").delegate("#AddDepositRighty", "click", linkAddDeposit);
	jQuery("body").delegate("#RefDepositRighty", "click", linkRefDeposit);
	jQuery("body").delegate("#HalfBillRighty", "click", halfBillClick);
	jQuery("body").delegate("#CancelHarfRighty", "click", delHarfBillClick);
	jQuery("body").delegate("#PtBillDetRighty", "click", linkBillDetail);
	//jQuery("body").delegate("#SearchOrdFeeRighty", "click", linkSearchOrdFee);  //医嘱费用查询 14.11.3
	jQuery("body").delegate("#SearchOrdFeeRighty", "click", linkAdmOrderFee);  //医嘱费用查询 14.11.3
	jQuery("body").delegate("#SearchTarFeeRighty", "click", linkSearchTarFee); //收费项目查询  14.11.3
	jQuery("body").delegate("#SearchDepDetRighty", "click", linkSearchDepDet);  //押金明细查询 14.11.3
	jQuery("body").delegate("#PtLedgerRighty", "click", printPtLedger);  //打印台账 14.11.3
	jQuery("body").delegate("#HalfBillByOrdRighty", "click", HalfChargeByOrd);  //按医嘱拆分账单  14.11.3
	jQuery("body").delegate("#VoidInvNoRighty", "click", altVoidInvClick);       //跳号
	
	//工具菜单
	jQuery("#tool-btn-BillTool").off("click").on("click",  billClick);
	jQuery("#tool-btn-RebillTool").off("click").on("click",  rebillClick);
	jQuery("#tool-btn-HalfBillTool").off("click").on("click",  halfBillClick);
	jQuery("#tool-btn-CancelHalfTool").off("click").on("click",  delHarfBillClick);
	jQuery("#tool-btn-AddDepositTool").off("click").on("click",  linkAddDeposit);
	jQuery("#tool-btn-RefDepositTool").off("click").on("click",  linkRefDeposit);
	jQuery("#tool-btn-RePtFPTool").off("click").on("click",  rePrintInvClick);
	jQuery("#tool-btn-PtInvTool").off("click").on("click",  printFPClick);
	jQuery("#tool-btn-RefInvTool").off("click").on("click",  abortClick);
	jQuery("#tool-btn-otherSearch").off("click").on("click", searchClick);
	jQuery("#tool-btn-CloseAcountTool").off("click").on("click", closeAcountClick);
	jQuery("#tool-btn-CancelCloseTool").off("click").on("click", uncloseAcountClick);
	jQuery("#tool-btn-PtLedgerTool").off("click").on("click", printPtLedger);
	jQuery("#tool-btn-VoidInvNoTool").off("click").on("click", altVoidInvClick);    //跳号

	//jQuery("#tool-btn-SearchOrdFeeTool").off("click").on("click", linkSearchOrdFee);
	jQuery("#tool-btn-SearchOrdFeeTool").off("click").on("click", linkAdmOrderFee);
	jQuery("#tool-btn-PtBillDetTool").off("click").on("click", linkBillDetail);
	jQuery("#tool-btn-SearchTarFeeTool").off("click").on("click", linkSearchTarFee);
	jQuery("#tool-btn-SearchDepDetTool").off("click").on("click", linkSearchDepDet);

	jQuery("#billBtn").off("click").on("click", billClick);
	jQuery("#disChargeBtn").off("click").on("click", chargeClick);
	jQuery("#cancelChargeBtn").off("click").on("click", cancelPayClick);
	jQuery("#cancelInsuBtn").off("click").on("click", cancelInsuChargeClick);
	jQuery("#insuChargeBtn").off("click").on("click", insuChargeClick);
	jQuery("#insuPreChargeBtn").off("click").on("click", insuPreChargeClick);
	//jQuery("#btnPatBillDetail").off().on("click", linkBillDetail); //14.11.15
	//jQuery("#btnRePrint").off().on("click", rePrintInvClick); //14.11.15
}

/**
*快捷键
*/
function FrameEnterkeyCode(e)
{
	switch (e.keyCode){
		case 115: //F4
			linkBillDetail();
			break;
		case 118: //F7
			clearClick();
			break;
		case 119: //F8
			//findClick();
			break;
		case 120: //F9
			chargeClick();
			break;
		case 121: // F10
			if (jQuery('#tool-btn-AddDepositTool').is(':visible')) {
				linkAddDeposit();
			}
			break;
		case 117: //F6  和调试F12冲突
			if (jQuery('#tool-btn-RefDepositTool').is(':visible')) {
				linkRefDeposit();
			}
			break;
		case 112 : //F1
			setColumnVal();
			break;
	}	
}
/**
*账单
*/
function billClick() {
	if(GlobalObj.episodeId === "") {
		jQuery.messager.alert('账单','请选择病人');
		return false;
	} else {
		var rtn = tkMakeServerCall("web.UDHCJFORDCHK", "getmotheradm", GlobalObj.episodeId);
		if(rtn === "true") {
			jQuery.messager.alert('账单', '此病人为婴儿不允许做账单.');
			return false;
		}
		/*	膳食费用	
		var myrtn=tkMakeServerCall("web.DHCIPMealWorkLoad","toHisBillByAdm",GlobalObj.episodeId);
       if (myrtn!=="0"){
	  	   jQuery.messager.alert("错误", "导入膳食费用错误! 错误代码："+rtn);
	   	   return;
	    }else{
		    jQuery.messager.alert("膳食", "导入膳食费用成功!");
		}
		*/
		var computerName = getComputerName();
		var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "Bill", "", "", GlobalObj.episodeId, SessionObj.guser, GlobalObj.billId, computerName);
		if(rtn == 0) {
			clickBillFlag = GlobalObj.episodeId;
			jQuery.messager.alert('账单', '账单成功', "", function() {
				//更新病人结算数据
				updateFootData();
				//重新加载押金列表数据，防止交押金后不显示,但是会把收费员以前选择的押金给取消了
				//2015-3-18 hujunbin 如果勾掉了押金后再来账单 要先初始化全局变量，否则会出现押金显示金额和勾选金额不一致
				DepositSelectObj.loadFlag = false;
				DepositSelectObj.depositArray = [];
				initDepositData();
				onLoadSuccessPaym();
				setPaymListFocus();
				return true;
			});
		} else if(rtn == "AdmNull") {
			jQuery.messager.alert('账单', "就诊号不能为空.");
			return false;
		} else if(rtn == "PBNull") {
			jQuery.messager.alert('账单', '账单号为空,账单失败.');
			return false;
		} else if(rtn == "OrdNull") {
			jQuery.messager.alert('账单', '病人没有医嘱,不能账单.');
			return false;
		} else if(rtn == "2") {
			jQuery.messager.alert('账单', '同时存在两个未付账单,不允许做账单.');
			return false;
		} else {
			jQuery.messager.alert('账单', '账单失败.');
			return false;
		}
	}

	return true;
}

/**
*重新生成账单
*/
function rebillClick() {
	if(GlobalObj.billId == "") {
		jQuery.messager.alert("账单", "未选择账单，不允许重新生成账单!");
		return;
	}
	if(GlobalObj.episodeId == "") {
		jQuery.messager.alert('账单','请选择病人');
		return;
	} else {
		var insuUpFlag=getInsuUpFlag();
		if(insuUpFlag == 1){
			jQuery.messager.alert('提示','账单医保已上传,不允许重新生成账单!');
			return;
		}else if (insuUpFlag == 2){
			jQuery.messager.alert('提示','账单医保已结算,不允许重新生成账单!');
			return;			
		}
		var rebillnum = tkMakeServerCall("web.DHCIPBillCashier", "JudgeBabyDeposit", GlobalObj.episodeId);
		if(rebillnum != ""){
			jQuery.messager.alert('账单','婴儿有未结算押金,如需重新生成账单请退婴儿押金!');
			return;
		}
		var billNum = tkMakeServerCall("web.UDHCJFBaseCommon", "JudgeBillNum", GlobalObj.episodeId);
		if(billNum == 1) {
			_rebill();
		} else if (billNum >= 2) {
			jQuery.messager.confirm("确认", "病人有两个或多个未结算的账单,是否确认重新生成账单?", function(r) {
				if(r) {
					_rebill();
				} else {
					return;
				}
			});
		} else if (billNum == 0) {
			jQuery.messager.alert("账单",  "未结算账单数为0,请确认该条记录是否已结算.")
			return;
		} else {
			jQuery.messager.alert("账单",  "重新生成账单失败" + ",返回值：" + billNum);
			return;
		}
	}
	
	function _rebill() {
		var rtn = tkMakeServerCall("web.UDHCJFREBILL", "REBILL", "", "", GlobalObj.episodeId, GlobalObj.billId, SessionObj.guser);
		if(rtn == 0) {
			jQuery.messager.alert("账单", "重新生成账单成功.", "", function() {
				initPatListData();
			});
		} else if(rtn == "ExtItmErr") {
			jQuery.messager.alert("账单", "账单中执行记录有附加的收费项目,不能重新生成账单.");
			return;
		} else if(rtn == "BabyErr") {
			//jQuery.messager.alert("账单", "母婴账单合并,请选择母亲账单进行重新生成账单!");
			jQuery.messager.alert("账单", "请选择母亲账单进行重新生成账单!");
			return;
		} else {	
			jQuery.messager.alert("账单", "重新生成账单失败.");
			return;
		}
	}
}

/**
*结算
*/
function chargeClick() {
	//把支付方式列表所有的在编辑状态的单元格endEdit
	endEditAllPaym(); //14.11.17
	jQuery.messager.confirm("结算", "是否结算此病人?", function(r) {
		if(!r) {
			return false;
		}else {
			charge();
		}
	});
}

function charge() {
	//!!!!需要添加判断是否医保已结算
	//1,判断是否选择了账单
	if(GlobalObj.episodeId == "" || GlobalObj.billId == "") {
		jQuery.messager.alert("结算", "账单号为空,不允许结算");
		return;
	}
	var patlistData = jQuery("#tPatList").datagrid("getSelected");
	if(!patlistData) {
		jQuery.messager.alert("结算", "请选择一条记录");
		return;
	}
	//判断当前票号和界面是否一致
	var sameFlag = checkInvSame();
	if(!sameFlag) {
		jQuery.messager.alert("结算", "发票号和后台查询不一致，请刷新界面后再试.");
		return false;
	}
	//2,判断是否需要发票
	//这里用不用判断欠费结算，即如果在支付方式里有欠费的，是不是判断是否欠费打发票？need revise hu
	var qualifStatus = getQualifStatus();
	var hasInv = checkInv();
	if(!hasInv && qualifStatus == 0) {
		jQuery.messager.alert("结算", "您没有可用发票,不能结算.请先领发票.");
		return false;
	}
	//+2017-08-23 ZhYW 判断医保是否结算
	var insuChargeFlag = checkInsuCharge();
	if (insuChargeFlag) {
		jQuery.messager.alert("结算", "此就诊为医保就诊,请先做医保结算或先刷新界面.");
		return false;
	}
	//4,账单后的押金总额和押金列表的押金总额是否一致,不一致提示重新选择病人或重新账单
	var depositFlag = judgeDepositSum();
	if(!depositFlag) {
		jQuery.messager.alert("结算", "再次收退押金导致押金列表显示不完全,请再次账单.");
		return false;		
	}
	//5,判断是否婴儿结算
	var rtnstr = tkMakeServerCall("web.UDHCJFCOMMON", "CheckBabyAdmDisCharge", GlobalObj.episodeId);
	var rtn=rtnstr.split('^')[0];
	var AdmStatus=rtnstr.split("^")[1];
	if(rtn == -1) {
		jQuery.messager.confirm("结算", "有婴儿未结算,母亲是否确认结算?", function(r) {
			if(!r) {
				return false;
			} else {
				_linkPay();
			}
		});
	}else if(rtn == -2) {
		jQuery.messager.confirm("结算", "婴儿是"+AdmStatus+"状态,母亲是否确认结算?", function(r) {
			if(!r) {
				return false;
			} else {
				_linkPay();
			}
		});
	} else if(rtn == 0){
		_linkPay();
	} else {
		jQuery.messager.alert("rtn" + rtn);
	}
	
	function _linkPay() {
		//6,判断就诊状态
		if(patlistData.dischargestatus == "取消住院") {
			jQuery.messager.alert("结算", "病人已经取消住院.");
			return;
		}
		//7,判断账单状态 后台取
		var billBaseInfo = getBillBaseInfo();
		if(billBaseInfo == "") {
			jQuery.messager.alert("结算", "账单信息获取失败.");
			return;
		}
		var billBaseInfoArr = billBaseInfo.split("^");
		var refundFlag = billBaseInfoArr[16]; //红冲标志
		var billNationalCode = billBaseInfoArr[21];  //账单费别NationalCode
		var payedFlag = billBaseInfoArr[15]; //计费状态
		if(refundFlag == "B") {
			jQuery.messager.alert("结算", "此账单已经红冲,不允许结算.");
			return false;
		}
		if(payedFlag == "P") {
			jQuery.messager.alert("结算", "此账单已结算或已封帐.");
			return false;
		}
		//3,判断平衡金额
		var balance = GlobalObj.balance;
		if(balance != 0) {
			jQuery.messager.alert("结算", "平衡金额不为0,不能结算.");
			return false;
		}
		var admReasonDetStr = getAdmReason();
		var admReasonId = admReasonDetStr[0];
		var admReasonNationalCode = admReasonDetStr[1];
		//8,判断结算状态
		if ((patlistData.dischargestatus != "护士办理出院")&&(patlistData.dischargestatus != "结束费用调整")){
			var billNum = getBillNum();
			if (billNum > 1) {
				jQuery.messager.confirm("结算", "病人要做中途结算,是否进行结算？", function(r) {
					if(!r) {
						return false;
					} else {
						_charge();
						return false;
					}
				});
			}else {
				//8.1判断医保病人是否必须做最终结算
				if((admReasonNationalCode != "") && (admReasonNationalCode != 0) && (Config.dhcJfConfig.insuPayFlag == "N")) {
					jQuery.messager.alert("结算", "医保病人是" + patlistData.dischargestatus + "状态不能结算!");
					return false;
				}else if (patlistData.dischargestatus == '费用调整'){
					jQuery.messager.alert("结算", "患者正在进行费用调整,不允许结算");
					return false;
				}else {
					jQuery.messager.confirm("结算", "病人是" + patlistData.dischargestatus + "状态,是否进行结算？", function(r) {
						if(!r) {
							return false;
						} else {
							_charge();
							return false;
						}
					});				
				}
			}
		}else {
			//+2018-09-20 ZhYW 最终结算时验证自费患者是否取消医保登记
			var cancelFlag = checkInsuRegIsCancel();
			if (!cancelFlag) {
				jQuery.messager.alert("结算", "医保未取消登记,不允许结算");
				return false;
			}
			_charge();
		}
	}
	
	function _charge() {
		//10,判断账单数量,判断是否账单
		var billNum = getBillNum();
		if(billNum == 1) {
			var hasClickBill = checkBillClick();
			if(!hasClickBill) {
				jQuery.messager.alert("结算", "请先做账单.");
				return false;
			}
		}
		//根据出院状态判断走原来的还是走费用核查
		var visitStatus = tkMakeServerCall("web.DHCIPBillCashier", "GetAdmStatus", GlobalObj.episodeId);
		if(visitStatus != "D") {
			//9,判断收费是否有未记账的医嘱是否有计费数量与发药数量不一致的药品
			var hasNotBillOrd = _getNotBillOrd();
			if(hasNotBillOrd) {
				return false;
			}
		}else {
			//费用监测
			var checkFeeFlag = checkFee();
			if(!checkFeeFlag) {
				return false;
			}
		}
		
		//11,费用审核
		if(Config.dhcJfConfig.patFeeConfirmFlag == "Y") { //费用审核
			var rtn = tkMakeServerCall("web.UDHCJFBillDetailOrder", "GetCodingFlag", GlobalObj.episodeId, GlobalObj.billId);
			if(rtn != "Y") {
				jQuery.messager.alert("结算", "此病人费用还未审核通过,不允许结算.");
				return false;
			}
		}
		//12,增加结算标志 住院结算加锁 need revise hu ,这里报错,所以改成在csp里使用隐藏元素
		//var getBZClass = tkMakeServerCall("web.UDHCJFCASHIER", "SetPaybz", GlobalObj.episodeId, GlobalObj.billId);
		var getBZClassObj = document.getElementById("SetPaybzclass");
		if (getBZClassObj) {
			var encmeth = getBZClassObj.value;
		} else {
			var encmeth = '';
		}
		var getbzclassbz = cspRunServerMethod(encmeth, GlobalObj.episodeId, GlobalObj.billId);
		
		//13,获取应收应退金额 自付金额 选择的押金金额 医保卡号
		var amtToPay = 0;
		var patFee = jQuery("#patShareAmt").numberbox('getValue'); //自付费用
		var deposit = jQuery("#selDepAmt").numberbox('getValue');
		var patInsuFee = jQuery("#patInsuAmt").numberbox('getValue');
		patFee = parseFloat(patFee).toFixed(2);
		deposit = parseFloat(deposit).toFixed(2);
		patInsuFee = parseFloat(patInsuFee).toFixed(2);
		amtToPay = patFee - deposit - patInsuFee;  //need revise hu 是这样取值吗
		amtToPay = parseFloat(amtToPay).toFixed(2);
		/*
		var retVal = tkMakeServerCall("web.UDHCJFPAY", "UpdatePatFee", GlobalObj.billId);
		var retValArr = retVal.split("^");
		var error = retValArr[0];
		if((error != 0) & (error != 1)) {
			jQuery.messager.alert("结算", "更新费用表出错.");
			return;
		}
		if(error == 0) {
			patFee = retValArr[1];
			deposit = deposit;
			patFee = parseFloat(patFee).toFixed(2);
			amtToPay = patFee - deposit -patInsuFee;
			amtToPay = parseFloat(amtToPay).toFixed(2);
		}
		*/
		var ybCardNo = "";   //医保卡号
		//14,获取支付方式串 支付方式和 押金串 所选押金和 押金全选标志
		var depflag = 0;
		var paymStr = getPayModeList();
		paymStr = "&" + amtToPay + paymStr;
		var paymAll = getPaymAll();
		var tmpdep = getDepoistStr();
		//log(tmpdep + "tmpdep")
		var allDeposit = jQuery("#totleDeposit").numberbox('getValue');  //界面所有押金
		var checkedDepost = jQuery("#selDepAmt").numberbox('getValue'); //界面押金金额
		var calcheckedDepost = getCheckDepositSum(); //计算出来的已选押金
		var notCheckedDeposit = allDeposit - checkedDepost; //未选押金
		allDeposit = parseFloat(allDeposit).toFixed(2);
		checkedDepost = parseFloat(checkedDepost).toFixed(2);
		notCheckedDeposit = parseFloat(notCheckedDeposit).toFixed(2);
		calcheckedDepost = parseFloat(calcheckedDepost).toFixed(2); 
		//15,再次判断发票号
		var currentInvNo = jQuery("#currentInvId").val();
		if(currentInvNo == "" && qualifStatus == 0) {
			jQuery.messager.alert("结算", "没有可用的收据号.");
			return;
		}
		//16,再次判断平衡金额
		var balanceFlag = checkBalance();
		//log(balanceFlag)
		if(!balanceFlag) {
			jQuery.messager.alert("结算", "平衡金额不为0,不能结算.");
			return;
		}
		//17,获取计算机名
		var computerName = getComputerName();
		var msg = "病人的预交金总额和要结算的预交金总额不一致,未选择的金额为" + notCheckedDeposit + ",是否确认结算?"
		if(allDeposit == checkedDepost) {
			depflag = 1;
			var p1 = GlobalObj.billId + "&" + SessionObj.guser + "&" + SessionObj.ctLoc + "&" 
							+ tmpdep + "&" + depflag + "&" + amtToPay + "&" + GlobalObj.episodeId + "&" 
							+ computerName + "&" + patFee + "&" + checkedDepost + "&" + paymAll + "&" + calcheckedDepost;
			var p2 = paymStr;
			log("charge p1 : " + p1);
			log("charge p2 : " + p2);
			_pay(p1, p2);
			return;
		}else {
			jQuery.messager.confirm("结算", msg, function(r) {
				if(!r) {
					return;
				} else {
					//+"&"+tmpdep+"&"+depflag+"&"+pay+"&"+Adm+"&"+computerName+"&"+PatFee+"&"+depositsum+"&"+Sum
					var p1 = GlobalObj.billId + "&" + SessionObj.guser + "&" + SessionObj.ctLoc + "&" 
								+ tmpdep + "&" + depflag + "&" + amtToPay + "&" + GlobalObj.episodeId + "&" 
								+ computerName + "&" + patFee + "&" + checkedDepost + "&" + paymAll + "&" + calcheckedDepost;
					var p2 = paymStr;
					log("charge p1 : " + p1);
					log("charge p2 : " + p2);
					_pay(p1, p2);
					return;
				}
			});
		}
	}
	
	function _pay(p1, p2) {
		log("p1" + p1)
		log("p2" + p2);
		var rtn = tkMakeServerCall("web.UDHCJFPAY", "paybill0", "", "", p1, p2);
		if(rtn > 0) {
			//need revise hu ,这里原来还有一个赋值一个判断，不知道干什么用的
			jQuery.messager.alert("结算", "结算成功.", "", function() {
				//打印返回打印的id可行吗？
				var printPrtId = printClick();
				//add hujunbin 结算完成后跳转到结算历史
				setListDefVal("paid");
				initPatListData();
				//转账自动打开交押金的界面
				transferDeposit(printPrtId); 
			});
		} else {
			switch (rtn){
				case "B":
					jQuery.messager.alert("结算", "患者正在进行费用调整,不允许结算.");
					break;
				case -2:
					jQuery.messager.alert("结算", "帐单金额不符,请重新生成帐单.");
					break;
				case -3:
					jQuery.messager.alert("结算", "界面金额与实际账单金额不符,请重新刷新界面重新结算.");
					break;
				case -4:
					jQuery.messager.alert("结算", "要结算的预交金金额与实际的预交金金额不符.");
					break;
				case -5:
					jQuery.messager.alert("结算", "支付的金额与实际要支付的金额不一致,不能结算");
					break;
				case -6:
					jQuery.messager.alert("结算", "账单已经结算,不允许结算");
					break;
				case -1001:
					jQuery.messager.alert("结算", "收费员选择的押金与后台结算的押金不等");
					break;
				case -1002:
					jQuery.messager.alert("结算", "支付方式金额，账单金额，结算押金不平");
					break;
				default:
					jQuery.messager.alert("结算", "结算失败." + rtn);	
			}
			return ;
		}
		/*
		printClick();
		//转账自动打开交押金的界面
		transferDeposit(); 
		*/
	}
	//判断收费有未记账的医嘱有计费数量与发药数量不一致的药品如果有则不允许结算
	function _getNotBillOrd() {
		var rtn = tkMakeServerCall("web.DHCIPBillPayControl", "GetNotBillOrd",GlobalObj.episodeId, GlobalObj.billId);
		var notBillOrdArr = rtn.split("^");
		var mNotBill = notBillOrdArr[0].split(",");
		var mNotBillNum = mNotBill[0];
		var mNotBillInfo = mNotBill[1];
				
		var mDis = notBillOrdArr[1].split(",");
		var mDisNum = mDis[0];
		var mDisInfo = mDis[1];
		
		var notDisp = notBillOrdArr[2].split(",");
		var notDispNum = notDisp[0];
		var notDispInfo = notDisp[1];
		
		///2016-09-08 chenxi 增加判断中途结算帐单是否有负数帐单
		var mPBNegativ=notBillOrdArr[3].split(",");
		var mPBNegativnum=mPBNegativ[0];
		if ((mPBNegativnum=="")||(mPBNegativnum==" ")){mPBNegativnum=0;}
		if (isNaN(mPBNegativnum)){mPBNegativnum=0;}
		var mPBNegativInfo=mPBNegativ[1];
		
		if(mDisNum != 0) {
			jQuery.messager.alert("错误", "此病人有药品发药数量与计费数量不一致的医嘱,不允许结算." + "^" + mDisInfo);
			return true;
		}
		if(mNotBillNum != 0) {
			jQuery.messager.alert("错误", "此病人有需要计费的医嘱,不允许结算." + "^" + mNotBillInfo);
			return true;
		}
		if(notDispNum != 0) {
			jQuery.messager.alert("错误", "病人有药品需要发放的医嘱,不允许结算" + notDispInfo);
			return true;
		}
		if (eval(mPBNegativnum)!=0){
			jQuery.messager.alert("错误", "病人有负数的医嘱,不允许结算" + mPBNegativInfo);
			return true;		
		}
		//判断婴儿的
		var babyRtn = tkMakeServerCall("web.DHCIPBillPayControl", "GetBabyNotBillOrd", GlobalObj.episodeId, GlobalObj.billId);
		var babyNotBillOrdArr = babyRtn.split("^");
		var babyNotBill = babyNotBillOrdArr[0].split(",");
		var babyNotBillNum = babyNotBill[0];
		var babyNotBillInfo = babyNotBill[1];
		
		var babyDis = babyNotBillOrdArr[1].split(",");
		var babyDisNum = babyDis[0];
		var babyDisInfo = babyDis[1];
		
		var babyNotDisp = babyNotBillOrdArr[2].split(",");
		var babyNotDispNum = babyNotDisp[0];
		var babyNotDispInfo = babyNotDisp[1];
		if(babyDisNum != 0) {
			jQuery.messager.alert("错误", "此病人的婴儿有药品发药数量与计费数量不一致的医嘱,不允许结算." + "^" + babyDisInfo);
			return true;
		}
		if(babyNotBillNum != 0) {
			jQuery.messager.alert("错误", "此病人的婴儿有需要计费的医嘱,不允许结算." + "^" + babyNotBillInfo);
			return true;
		}
		if(babyNotDispNum != 0) {
			jQuery.messager.alert("错误", "病人的婴儿有药品需要发放的医嘱,不允许结算." + babyNotDispInfo);
			return true;
		}
		return false;
	}
}

/**
*取消结算
*/
function cancelPayClick() {
	if((GlobalObj.episodeId == "") || (GlobalObj.billId == "")) {
		jQuery.messager.alert("取消结算", "请选择账单");
		return;
	}
	//判断取消结算是否需要打印负票，如果打印判断是否有可用发票
	var qualifStatus = getQualifStatus();
	var hasInv = checkInv();
	if(!hasInv && qualifStatus == 0 && Config.dhcJfConfig.refFpPrtFlag == "Y") {
		jQuery.messager.alert("结算", "取消结算需打印负票,您没有可用发票,请先领发票.");
		return;
	}
	var acountFlag = tkMakeServerCall("web.DHCIPBillPBCloseAcount", "GetPaidCAcountFlag", GlobalObj.billId);
	if(acountFlag == "Y") {
		jQuery.messager.alert("取消结算", "此账单为封帐账单，不能取消结算.");
		return;
	}
	var billFlag = "";
	var billInfo = getBillBaseInfo();
	if(billInfo == "") {
		jQuery.messager.alert("取消结算", "账单信息获取失败.");
		return;
	}
	billFlag = billInfo.split("^")[15];

	jQuery.messager.confirm("取消结算", "确认要取消结算吗？", function(r) {
		if(!r) {
			return;
		} else {
			if((GlobalObj.episodeId == "") || (GlobalObj.billId == "")) {
				jQuery.messager.alert("取消结算", "请选择账单");
				return;
			}
			//这里是不是不用判断，而用后台判断？？？
			if(billFlag == "B") {
				jQuery.messager.alert("取消结算", "账单没有结算，不允许取消结算.");
				return;
			}
			var pbFlag = tkMakeServerCall("web.UDHCJFPBCANCELIP", "getpbflag", GlobalObj.billId);
			if(pbFlag == "Abort") {
				jQuery.messager.alert("取消结算", "该患者发票已作废，不能取消结算");
				return false;
			} else if(pbFlag == "QF") {
				jQuery.messager.alert("取消结算", "欠费患者，不能取消结算");
				return false;
			} else if(pbFlag == "PbNotPaid") {
				jQuery.messager.alert("取消结算", "该患者没有结算，不能取消结算");
				return false;
			} else if(pbFlag == "PbAlready") {
				jQuery.messager.alert("取消结算", "该患者没已经取消结算，不能再次取消");
				return false;
			} else if(pbFlag == "TransErr") {
				jQuery.messager.confirm("取消结算", "病人结算时转过预交金,是否确认取消结算,如果取消结算预交金会虚增.", function(c) {
					if(c) {
						jQuery.messager.alert("押金", "请退掉中途结算转过的预交金", "", function() {
							_cancelPay();
							return;
						});
						
					} else {
						return;
					}
				});
			} else if(pbFlag == "") {  //这里我加了个这个条件，表示可以取消结算，不知道可不可以？
				_cancelPay();
				return;
			}
			
			
		}
	});
	function _cancelPay() {
		//医保取消结算
		var rtn = revIPFootBack();
		if(rtn < 0) {
			jQuery.messager.alert("医保", "医保取消结算失败.")
			return;
		}
		//his取消结算
		//1,取消结算是否打印负票 dhcJfConfig.refFpPrtFlag
		//2,收款员未交帐取消结算是否按作废方式处理dhcJfConfig.refFpFlag
		var expStr=SessionObj.group+"^"+SessionObj.ctLoc+"^"+SessionObj.hospital+"^"; //wangjian 2018-10-15
		var invFlag = "";
		var rtn = tkMakeServerCall("web.UDHCJFPBCANCELIP", "DelPay", "", "", GlobalObj.episodeId, GlobalObj.billId, SessionObj.guser, Config.dhcJfConfig.refFpPrtFlag, Config.dhcJfConfig.refFpFlag,expStr);
		var str = rtn.split("^");
		var num = str[0];
		var oldBill = str[1];
		var newBill = str[2];
		var chprtRowId = str[3];
		var invFlag = str[4];
		var chprt = str[5];
		log("chprt : " + chprt)
		if((num == "null") && (invFlag == "Y")) {
			jQuery.messager.alert("取消结算", "没有可用的收据号.");
			return;
		}
		if(num == "abort") {
			jQuery.messager.alert("取消结算", "该患者的发票已经作废不能取消结算");
			return;
		}
		if(num == "QF") {
			jQuery.messager.alert("取消结算", "欠费患者，不能取消结算");
			return;
		}
		if(num == "CloseAcountErr") {
			jQuery.messager.alert("取消结算", "此账单已经封帐,不允许取消结算.");
			return;
		}
		if(num != 0) {
			jQuery.messager.alert("取消结算", "取消结算错误" + num);
			return;
		}
		if(num == 0) {
			jQuery.messager.alert("取消结算", "取消结算成功");
			//刷新列表
			initPatListData();
			if(chprt == "N") {
				return false;
			}
			//添加了一个是否有发票的条件 add hu 
			//var hasInv = checkInv(GlobalObj.episodeId, SessionObj.guser);
			var rowData = jQuery("#tPatList").datagrid("getSelected");
			log("config : " + Config.dhcJfConfig.refFpPrtFlag + ":::" + rowData.invno + ":::" + chprt)
			if(Config.dhcJfConfig.refFpPrtFlag == "Y" && rowData.invno != "" && chprt == "Y") {
				//log(chprtRowId);
				getXMLName();
				PrintFP(chprtRowId);
			}
		}
		//更新发票号
		checkInv();
	}
}

/**
*医保结算
*/
function insuChargeClick() {
	if(GlobalObj.billId == "") {
		jQuery.messager.alert("医保结算", "请选择病人.");
		return;
	}

	var rowData = jQuery("#tPatList").datagrid("getSelected");
	if(!rowData) {
		jQuery.messager.alert("医保结算", "请选择一条记录");
		return;
	}

	if(rowData.pbflag == "P") {
		jQuery.messager.alert("医保结算", "该病人记录已结算.");
		return;
	}
	/*
	if(rowData.dischargestatus != "最终结算") {
		jQuery.messager.alert("医保结算", "患者未做最终结算,不能医保结算.");
		return;	
	} */
	if ((rowData.dischargestatus != "护士办理出院")&&(rowData.dischargestatus != "结束费用调整")){
		var admReasonDetStr = getAdmReason();
		var admReasonId = admReasonDetStr[0];
		var admReasonNationalCode = admReasonDetStr[1];
		if(admReasonNationalCode != "" && admReasonNationalCode != 0 && Config.dhcJfConfig.insuPayFlag == "N") {
			jQuery.messager.alert("结算", "医保病人是"+rowData.dischargestatus+"状态不能结算!");
			return;
		}
	}
	//11,费用审核
	if(Config.dhcJfConfig.patFeeConfirmFlag == "Y") { //费用审核
		var rtn = tkMakeServerCall("web.UDHCJFBillDetailOrder", "GetCodingFlag", GlobalObj.episodeId, GlobalObj.billId);
		if(rtn != "Y") {
			jQuery.messager.alert("结算", "此病人费用还未审核通过,不允许结算.");
			return;
		}
	}
	if(clickBillFlag != GlobalObj.episodeId) {
		jQuery.messager.alert("医保结算", "请先做账单");
		return;
	}
	var admReasonDetStr = getAdmReason();
	var admReasonId = admReasonDetStr[0];
	var admReasonNationalCode = admReasonDetStr[1];
	if ((admReasonNationalCode > 0) && (rowData.pbflag != "P")) {
		var insuPmInfo = "0";
		var insuPmInfo = InsuIPDivide(0, SessionObj.guser, GlobalObj.billId, admReasonNationalCode, admReasonId, "");	
		var insuFlag = insuPmInfo.slice(0,1);
		if(insuFlag == 0) {
			jQuery.messager.alert("医保结算", "医保结算成功.", "", function() {
				//医保结算成功后插入医保支付方式
				addGridInsuInfo(insuPmInfo);
				disElement("insuChargeBtn");
				disElement("insuPreChargeBtn");
				ableElement("disChargeBtn", chargeClick);
			});
		}else {
			jQuery.messager.alert("医保结算", "医保结算失败.");
		}
	}else {
		jQuery.messager.alert("医保结算", "不是医保病人,不能医保结算.");
	}
}

/**
*医保预结算
*/
function insuPreChargeClick(){
	if(GlobalObj.billId == "") {
		jQuery.messager.alert("医保预结算", "请选择病人.");
		return;
	}
	if(GlobalObj.episodeId == "") {
		jQuery.messager.alert("医保预结算", "请选择病人.");
		return;
	}
	var rowData = jQuery("#tPatList").datagrid("getSelected");
	if(!rowData) {
		jQuery.messager.alert("医保预结算", "请选择一条记录.");
		return;
	}
	if(rowData.pbflag == "P") {
		jQuery.messager.alert("医保预结算", "该病人记录已结算.");
		return;
	}
	if(clickBillFlag != GlobalObj.episodeId) {
		jQuery.messager.alert("医保预结算", "请先做账单");
		return;
	}
	var num = getBillNum();
	num = parseInt(num);
	if(num > 1) {
		jQuery.messager.alert("医保预结算", "病人有两个未结算的账单,不允许医保预结算,请撤消中途结算.");
		return;
	}else if(num == 1) {
		var ReaInfo=tkMakeServerCall("web.UDHCJFORDCHK","GetAdmReaInfo",GlobalObj.episodeId)
		if (ReaInfo==""){return}
		var ReaInfo1=ReaInfo.split("^");
		var AdmReasonNationCode=ReaInfo1[1];
		var AdmReasonId=ReaInfo1[0];
		if ((AdmReasonNationCode!="")&&(AdmReasonNationCode!="0")){ 
			var Ret=InsuIPDividePre("0",SessionObj.guser, GlobalObj.billId, AdmReasonNationCode, AdmReasonId, "");
		}   
		else
		{
			alert("非医保病人不能医保预结算.")
		}	 
	} else if(num == 0) {
		jQuery.messager.alert("医保预结算", "病人没有账单，不能预结算.");
		return;
	} else {
		jQuery.messager.alert("医保预结算", "返回值：" + num);
		return;
	}
}

/**
*中途结算
*/
function halfBillClick() {
	var billId = GlobalObj.billId;
	var episodeId = GlobalObj.episodeId;
	if(billId == "") {
		jQuery.messager.alert("中途结算", "账单为空,不允许拆分账单.");
		return;
	}
	var insuUpFlag=getInsuUpFlag();
	if(insuUpFlag == 1){
		jQuery.messager.alert('提示','账单医保已上传,不允许中途结算!');
		return;
	}else if (insuUpFlag == 2){
		jQuery.messager.alert('提示','账单医保已结算,不允许中途结算!');
		return;			
	}
	var billInfo = getBillBaseInfo();
	if(billInfo == "") {
		jQuery.messager.alert("中途结算", "账单信息获取失败.");
		return;
	}
	var billFlag = billInfo.split("^")[15];
	if(billFlag == "P") {
		jQuery.messager.alert("中途结算", "此账单已经结算,不能拆分账单.");
		return;
	}
	//判断医保病人是否能够中途结算
	var canHarfForInsu = canHarfBillForInsu();
	if(!canHarfForInsu) {
		jQuery.messager.alert("中途结算", "该患者为医保患者,不能中途结算.");
		return;
	}
	var num = getBillNum();
	num = parseInt(num);
	if(num > 1) {
		jQuery.messager.alert("中途结算", "病人有多个未结账单,不允许拆分账单.");
		return;
	}else if(num == 1) {
		//中途结算窗口
		//判断是否有tab，没有的话创建，有的话打开
		initHalfBillTab();
	} else if(num == 0) {
		jQuery.messager.alert("中途结算", "病人没有未结账单.");
		return;
	} else {
		jQuery.messager.alert("中途结算", "返回值：" + num);
		return;
	}
}
/**
*取消中途结算
*/
function delHarfBillClick() {
	if(GlobalObj.billId == "") {
		jQuery.messager.alert("撤销中途结算", "请选择账单.");
		return;
	}
	jQuery.messager.confirm("撤销中途结算", "是否确认撤销中途结算?", function(r) {
		if(!r) {
			return;
		} else {
			var insuUpFlag=getInsuUpFlag();
			if(insuUpFlag == 1){
				jQuery.messager.alert('提示','账单医保已上传,不允许撤销中途结算!');
				return;
			}else if (insuUpFlag == 2){
				jQuery.messager.alert('提示','账单医保已结算,不允许撤销中途结算!');
				return;			
			}
			var num = tkMakeServerCall("web.UDHCJFIntBill", "DINBILL", GlobalObj.billId, SessionObj.guser);
			if(num == 0) {
				jQuery.messager.alert("撤销中途结算", "撤销中途结算成功.");
				initPatListData();
			}else if(num == -1) {
				jQuery.messager.alert("撤销中途结算", "原账单已结算或已封账,不能撤销.");
				return;
			}else if(num == -2) {
				jQuery.messager.alert("撤销中途结算", "请选择拆分账单进行取消中途结算.");
				return;
			}else if(num != 0) {
				jQuery.messager.alert("撤销中途结算", "撤销中途结算错误.");
				return;
			}
		}
	});
}

/**
*封帐
*/
function closeAcountClick() {
	var episodeId = GlobalObj.episodeId;
	var billId = GlobalObj.billId;
	episodeId = jQuery.trim(episodeId);
	billId = jQuery.trim(billId);
	if(episodeId == "" || billId == "") {
		jQuery.messager.alert("封帐", "请选择需封账的账单.");
		return;
	}
	var billBaseInfo = getBillBaseInfo();
	if(billBaseInfo == "") {
		jQuery.messager.alert("封帐", "获取账单信息失败.");
		return;
	}
	var AdmLastStatus = tkMakeServerCall("web.DHCBillInterface", "GetAdmLastStatus", episodeId);
	if(AdmLastStatus=="B"){
		jQuery.messager.alert("封帐", "患者正在进行费用调整,不允许封帐");
		return;
	}
	var billBaseInfoArr = billBaseInfo.split("^");
	var payedFlag = billBaseInfoArr[15];
	var refundFlag = billBaseInfoArr[16];
	if(refundFlag == "B") {
		jQuery.messager.alert("封帐", "此账单已经红冲,不允许封账.");
		return;
	}
	var num = getBillNum();
	if(num == 1) {
		var hasClickBill = checkBillClick();
		if(!hasClickBill) {
			jQuery.messager.alert("封帐", "请先做账单");
			return;
		}
	}

	var computerName = getComputerName();
	var rtn = tkMakeServerCall("web.DHCIPBillPBCloseAcount", "PaidPatientbill", episodeId, billId, SessionObj.guser, computerName);
	if(rtn == 0) {
		jQuery.messager.alert("封帐", "封帐成功.");
		initPatListData();
		return;
	} else {
		jQuery.messager.alert("封帐", "封帐失败,返回值 " + rtn);
		return;
	}
}

/**
*取消封帐
*/
function uncloseAcountClick() {
	var episodeId = GlobalObj.episodeId;
	var billId = GlobalObj.billId;
	episodeId = jQuery.trim(episodeId);
	billId = jQuery.trim(billId);
	if(episodeId == "" || billId == "") {
		jQuery.messager.alert("取消封帐", "请选择需封账的账单.");
		return;
	}
	var billBaseInfo = getBillBaseInfo();
	if(billBaseInfo == "") {
		jQuery.messager.alert("取消封帐", "获取账单信息失败.");
		return;
	}
	var billBaseInfoArr = billBaseInfo.split("^");
	var payedFlag = billBaseInfoArr[15];
	var refundFlag = billBaseInfoArr[16];
	if(refundFlag == "B") {
		jQuery.messager.alert("取消封帐", "此账单已经红冲,不允许取消封帐.");
		return;
	}
	var acountFlag = tkMakeServerCall("web.DHCIPBillPBCloseAcount", "GetPaidCAcountFlag", billId);
	if(acountFlag != "Y") {
		jQuery.messager.alert("取消封帐", "此账单不需取消封帐.");
		return;
	}

	var computerName = getComputerName();
	var rtn = tkMakeServerCall("web.DHCIPBillPBCloseAcount", "UnCloseAcount", episodeId, billId, SessionObj.guser, computerName);  
	if(rtn == "AdmNull") {
		jQuery.messager.alert("取消封帐", "请选择需取消封账的账单.");
		return;
	}else if(rtn == "ErrNull") {
		jQuery.messager.alert("取消封帐", "此账单不需取消封帐.");
		return;		
	}else if(rtn == "AlreadyPRT") {
		jQuery.messager.alert("取消封帐", "此账单已经结算不能取消封帐.");
		return;			
	}else if(rtn == 0) {
		jQuery.messager.alert("取消封帐", "取消封帐成功.");
		initPatListData();
		return;			
	}else if(rtn =="CofimOK"){
		jQuery.messager.alert("取消封帐", "已经审核,不能取消封账.");
		return;	
	}else {
		jQuery.messager.alert("取消封帐", "取消封帐失败, 返回值 " + rtn);
		return;	
	}
}

/**
*交押金
*/
function linkAddDeposit() {
	if(GlobalObj.episodeId == "") {
		jQuery.messager.alert("交押金", "请选择病人");
		return;
	}
	initAddDepositTab();
}

/**
*退押金
*/
function linkRefDeposit() {
	if(GlobalObj.episodeId == "") {
		jQuery.messager.alert("退押金", "请选择病人");
		return;
	}
	initRefDepositTab();
}

/**
*病人费用明细
*/
function linkBillDetail() {
	var billId = jQuery.trim(GlobalObj.billId);
	if(billId == "") {
		jQuery.messager.alert("费用清单", "请选择病人!!");
		return;
	}
	initBillDetailTab();
}

/**
*作废收据
*/
function abortClick() {
	//判断是否选择了账单
	if(GlobalObj.episodeId == "" || GlobalObj.billId == "") {
		jQuery.messager.alert("作废收据", "账单号为空,不允许作废收据");
		return;
	}
	//判断作废收据需不需要发票
	var qualifStatus = getQualifStatus();
	var hasInv = checkInv();
	if(!hasInv && qualifStatus == 0 && Config.dhcJfConfig.abortFpPrtFlag == "Y") {
		jQuery.messager.alert("作废收据", "您没有可用发票,不能结算.请先领发票.");
		return;
	}
	var rowData = jQuery("#tPatList").datagrid("getSelected");
	if(!rowData) {
		jQuery.messager.alert("打印收据", "请选择一条记录");
		return;
	}

	var thisInvNo = rowData.invno;
	var currentInvNo = jQuery("#currentInv").val();
	thisInvNo = jQuery.trim(thisInvNo);
	currentInvNo = jQuery.trim(currentInvNo);
	var currentInvStr = getCurrentInv();
	var currentInvArr = currentInvStr.split("^");
	currentInvNo = currentInvArr[0] + currentInvArr[1];
	var abortFlag = 0, currentFlag = 0;
	
	//判断是否有已经打印了发票
	if((thisInvNo == "") && (rowData.prtFlag != "S")) {
		jQuery.messager.alert("作废收据", "请确认已经打印收据.");
		return;
	}
	if(thisInvNo == "") {
		abortFlag = 1;
	}
	if(currentInvNo == "") {
		currentFlag = 1;
	}
	var p1 = thisInvNo + "^" + currentInvNo + "^" + GlobalObj.billId + "^" + SessionObj.guser;
	var abortNum = tkMakeServerCall("web.UDHCJFPAY", "Abort0", "", "", p1);
	if(abortNum == 1) {
		jQuery.messager.alert("作废收据", "收费员已经结算,不允许作废.");
		return;
	}else if(abortNum == 2) {
		jQuery.messager.alert("作废收据", "不是该收款员打印的发票不能作废.");
		return;
	}else if(abortNum == 3) {
		jQuery.messager.alert("作废收据", "该发票已经取消结算不能作废.");
		return;
	}else if(abortNum == 4) {
		jQuery.messager.alert("作废收据", "该发票已经取消结算不能作废.");
		return;
	}else if(abortNum == 0) {
		jQuery("#invoiceNO").val("");
		jQuery.messager.alert("作废收据", "作废成功.");
		if(Config.dhcJfConfig.abortFpPrtFlag == "Y" && Config.dhcJfConfig.prtFpMoreFlag == "N") {
			printClick();
		}
	}else {
		jQuery.messager.alert("作废收据", "作废失败,返回值" + abortNum);
		return;
	}
	initPatListData();
}

/**
*打印收据 14.11.21 
*原来直接调用printClick，现在加上控制条件
*/
function printFPClick() {
	//判断是否选择了账单
	if(GlobalObj.episodeId == "" || GlobalObj.billId == "") {
		jQuery.messager.alert("打印收据", "账单号为空,不允许打印收据");
		return;
	}
	//这里用不用判断欠费结算，即如果在支付方式里有欠费的，是不是判断是否欠费打发票？need revise hu
	var qualifStatus = getQualifStatus();
	var hasInv = checkInv();
	if(!hasInv && qualifStatus == 0) {
		jQuery.messager.alert("打印收据", "没您有可用发票,不能结算.请先领发票.");
		return;
	}
	var rowData = jQuery("#tPatList").datagrid("getSelected");
	if(!rowData) {
		jQuery.messager.alert("打印收据", "请选择一条记录");
		return;
	}
	if(rowData.dischargestatus == "取消住院") {
		jQuery.messager.alert("打印收据", "病人已经取消住院.");
		return;
	}
	//7,判断账单状态 后台取
	var billBaseInfo = getBillBaseInfo();
	if(billBaseInfo == "") {
		jQuery.messager.alert("打印收据", "账单信息获取失败.");
		return;
	}
	var billBaseInfoArr = billBaseInfo.split("^");
	var refundFlag = billBaseInfoArr[16]; //红冲标志
	var billNationalCode = billBaseInfoArr[21];  //账单费别NationalCode
	var payedFlag = billBaseInfoArr[15]; //计费状态
	if(refundFlag == "B") {
		jQuery.messager.alert("打印收据", "此账单已经红冲,不允许打印收据.");
		return;
	}
	var acountFlag = tkMakeServerCall("web.DHCIPBillPBCloseAcount", "GetPaidCAcountFlag", GlobalObj.billId);
	if(acountFlag == "Y") {
		jQuery.messager.alert("打印收据", "此账单已封帐.");
		return;
	}

	printClick();
	initPatListData();
}

/**
*打印
*/
function printClick() {
	var episodeId = GlobalObj.episodeId;
	var billId = GlobalObj.billId;
	var guser = SessionObj.guser;
	var prtMoreFlag = Config.dhcJfConfig.prtFpMoreFlag;
	var qfFpPrtFlag = Config.dhcJfConfig.qfFpPrtFlag;
	var myPrtMoreFlag = "N";
	var prtRowId = "";
	getXMLName();
	var qualifStatus = getQualifStatus();
	var qfCount = getQfNum();
	//这里我从后台取数据，原来是取的页面上的add hu
	var billBaseInfo = getBillBaseInfo();
	if(billBaseInfo == "") {
		jQuery.messager.alert("结算", "账单信息获取失败.");
		return;
	}
	var billBaseInfoArr = billBaseInfo.split("^");
	var pbDateFrom = billBaseInfoArr[22];
	var pbDateTo = billBaseInfoArr[23];
	var payedFlag = billBaseInfoArr[15];
	var billNationalCode = billBaseInfoArr[21];
	if(payedFlag != "P") {
		jQuery.messager.alert("结算打印", "此账单没有结算,不能打印发票.");
		return;
	}
	//判断当前发票号 need revise hu 在后台取
	var hasInv = checkInv();
	if(!hasInv && qualifStatus == 0) {
		jQuery.messager.alert("结算", "您没有可用发票,不能结算.请先领发票.");
		return;
	}
	var pbFlag = tkMakeServerCall("web.UDHCJFPAY", "pbflag", "", "", billId);
	if(pbFlag == "Y") {
		var rtn = tkMakeServerCall("web.UDHCJFPAY", "getinvprtzyrowid", "", "", billId);
		var rtnStr = rtn.split("^");
		if(rtnStr[1] != "Y") {
			jQuery.messager.alert("结算打印", "此账单已经打印发票或为欠费结算.");
			return;
		}else {
			var prtRowId = rtnStr[0];
			var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFInvprtzySub&Adm=' + episodeId + '&BillNo=' + billId + '&prtrowid=' + prtRowId;
			window.open(lnk, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=650,left=0,top=0')   
			return;
		}
	} else if(pbFlag == "N") {
		if(prtMoreFlag == "Y") {
			if(qfFpPrtFlag == "Y") {
				if(qfCount == 0) {
					/*
					jQuery.messager.confirm("结算打印", "是否打印单张发票?", function(r) {
						if(!r) {
							myPrtMoreFlag = "Y"
						} else {
							myPrtMoreFlag = "N";
						}
					});
					*/
					myPrtMoreFlag = "N";
				} else {
					myPrtMoreFlag = "N";
				}
			} else {
				myPrtMoreFlag = "N";
			}
		}
		var computerName = getComputerName();
		var currentInv = getCurrentInv();
		var invArr = currentInv.split("^");
		var currentInvTit = invArr[0];
		var currentInvNo = invArr[1];
		var currentInvId = jQuery("#currentInvId").val();
		//log(currentInv)
		//need revise hu
		
		var p1 = currentInvNo + "&" + currentInvTit + "^" + guser + "^" + billId + "^" + "正常" + "^" + currentInvId + "^" + "Y" + "^" + episodeId + "^" + myPrtMoreFlag + "^" + qfFpPrtFlag + "^" + qfCount + "^" + computerName + "^" + pbDateFrom + "^" + pbDateTo;
		var expStr = SessionObj.group + "^" + SessionObj.ctLoc + "^" + SessionObj.hospital + "^"; //wangjian 2018-10-15
		//log("p1 : " + p1);
		var rtn = tkMakeServerCall("web.UDHCJFPAY", "savetoinvprt0", "", "", p1, expStr);
		if(!rtn) {
			jQuery.messager.alert("结算打印", "此账单没有结算,不能打印发票.");
			return;
		}
		if(rtn == "INV") {
			jQuery.messager.alert("结算打印", "此发票号码已经使用.");
			return;
		}
		if(rtn == "InsuErr") {
			jQuery.messager.alert("结算打印", "保存医保数据错误.");
			return;
		}
		var rtnArr = rtn.split("^");
		if(rtnArr[4] != 0) {
			jQuery.messager.alert("结算打印", "保存发票失败." + rtnArr[4]);
			return;
		}
		var prtRowId = rtnArr[3];
		//设置新的发票号 
		if(rtnArr[0] == "") {
			var myInvNo = currentInvTit + currentInvNo;
			//如果有当前结算的发票号id时进行设置
			checkInv();
		} else {
			//设置发票号，设置当前发票号
			if(prtMoreFlag == "Y") {
				//如果有当前结算的发票号id时进行设置
				//jQuery("#invoiceNO").val("");
			}else if(prtMoreFlag == "N") {
				var myInvNo = currentInvTit + currentInvNo;
				//如果有当前结算的发票号id时进行设置
				checkInv();
			}
			if(qfFpPrtFlag == "N") {
				var qfCount = getQfNum();
				if(qfCount > 0) {
					//如果有当前结算的发票号id时进行设置
					//jQuery("#invoiceNO").val("");
				}
			}
			checkInv();

		}
		if(myPrtMoreFlag == "N") {
			if(rtnArr[5] > 0) {
				return;
			}
			if(qfFpPrtFlag == "N" && qfCount == 0) {
				
				if(billNationalCode != 1) {
					PrintFP(prtRowId + "#" + "");
				} else {
					//printFPINSU(prtRowId + "#" + "");
					PrintFP(prtRowId + "#" + "");
				}
			}
			if(qfFpPrtFlag == "Y") {
				if(billNationalCode != 1) {
					PrintFP(prtRowId + "#" + "");
				} else {
					//printFPINSU(prtRowId + "#" + "");
					PrintFP(prtRowId + "#" + "");
				}
			}
		}
		
		if((myPrtMoreFlag == "Y") && (prtRowId != "")) {
			var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFInvprtzySub&Adm=' + episodeId + '&BillNo=' + billId + '&prtrowid=' + prtRowId;
			window.open(lnk, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=650,left=0,top=0');
		}
	}  

	return prtRowId;

}


/**
*原号重新打印收据
*/
function rePrintInvClick() {
	var rowData = jQuery("#tPatList").datagrid("getSelected");
	if(!rowData) {
		jQuery.messager.alert("打印收据", "请选择一条记录");
		return;
	}

	var invNo = jQuery.trim(rowData.invno);
	if(invNo == "") {
		jQuery.messager.alert("补打发票", "未选择补打发票的信息或没有补打信息");
		return;
	} else {
		var rtn=tkMakeServerCall("web.UDHCJFPRINTINV", "GetInvflagByInvno", invNo, SessionObj.guser);
		var prtInvFlag=rtn.split("^")[0];
		var prtInvRowId=rtn.split("^")[1];
		var prtInsDR=rtn.split("^")[2];
		if(prtInvFlag != 1) {
			jQuery.messager.alert("补打发票", "此发票不能重打.");
			return;
		} else {
			jQuery.messager.confirm("补打发票", "确定要重打发票?", function(r) {
				if(!r) {
					return;
				}else {
					//need revise hu 原来这里传了个发票的费别，但是么有用到，现在用的是就诊费别
					getXMLName();
					PrintFP(prtInvRowId + "#" + "R"); //R为补打标志
				}
			});
		}
	}

}


/**
*按医嘱拆分账单
*/

function HalfChargeByOrd() {
	if(GlobalObj.billId == "") {
		jQuery.messager.alert("拆分账单", '此病人没有账单,不能拆分账单');
		return;
	}
	var billInfo = getBillBaseInfo();
	var billFlag = "";
	if(billInfo == "") {
		jQuery.messager.alert("拆分账单", "账单信息获取失败.");
		return;
	}
	billFlag = billInfo.split("^")[15];
	if(billFlag == "P") {
		jQuery.messager.alert("拆分账单", '此账单已经结算,不能拆分账单');
		return;
	}
	//判断医保病人是否能够中途结算
	var canHarfForInsu = canHarfBillForInsu();
	if(!canHarfForInsu) {
		jQuery.messager.alert("拆分账单", "该患者为医保患者,不能中途结算.");
		return;
	}
	var num = getBillNum();
	num = parseInt(num);
	if(num > 1) {
		jQuery.messager.alert("拆分账单", "病人有多个未结算账单不允许拆分账单.");
		return;	
	}

	//判断是否有tab，没有的话创建，有的话打开
	initHalfBillByOrdTab();
}


/**
*转账 自动打开交押金的界面
*/
function transferDeposit(prtRowId) {
	var transferFlag = getTransferFlag();
	if(!transferFlag) {
		return;
	}
	if(prtRowId != "") {
		var payAmt=tkMakeServerCall("web.UDHCJFBaseCommon", "GetTDepositByPaid", prtRowId);
		payAmt = 0 - payAmt;
		var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDeposit&Adm=' + GlobalObj.episodeId + '&deposittype=' + "住院押金" + '&payamt=' + payAmt + '&transferflag=Y';
		addOneTab("chargeTabs", "addDepositTab", "交押金", lnk);
	}
}

/**
*医嘱费用查询 14.11.3
*/
function linkSearchOrdFee() {
	if (GlobalObj.billId == "") {
		jQuery.messager.alert("医嘱费用", "账单号为空！");
		return;
	}
	//判断是否有tab，没有的话创建，有的话打开
	initOrdFeeTab();
}

function linkAdmOrderFee() {
	if (GlobalObj.episodeId == "") {
		jQuery.messager.alert("医嘱费用", "就诊为空，请选择就诊！");
		return;
	}
	//判断是否有tab，没有的话创建，有的话打开
	initOrdFeeTab();
}

/**
*收费项目查询 14.11.3
*/
function linkSearchTarFee() {
	if (GlobalObj.billId == "") {
		jQuery.messager.alert("收费项目", "账单号为空！");
		return;
	}
	//判断是否有tab，没有的话创建，有的话打开
	initTarFeeTab();
}

/**
*押金明细 14.11.3
*/
function linkSearchDepDet() {
	if (GlobalObj.episodeId == "") {
		jQuery.messager.alert("押金明细", "就诊为空！");
		return;
	}
	//判断是否有tab，没有的话创建，有的话打开
	initDepDetailTab();
}

/**
*打印台账 14.11.3
*/
function printPtLedger() {
	if (GlobalObj.billId == "") {
		jQuery.messager.alert("台账", "请选择打印台账的账单.");
		return;
	}
	//udhcjfdayprint.js里的PrintFootList
	var returnvalue = tkMakeServerCall("web.UDHCJFPRINTINV", "PrintReceipt", "PrintFootList", GlobalObj.billId); 
}
/**
*取消医保结算 没有收费结算前
*/
function cancelInsuChargeClick() {
	//调用医保接口 未完成
	var payedFlag = tkMakeServerCall("web.UDHCJFBaseCommon", "GetBillPaidFlag", GlobalObj.billId);
	if(payedFlag == "N") {
		jQuery.messager.alert("取消医保结算", "账单未结算或已经打印发票,不能取消医保结算.");
		return;
	}
	var admReasonDetStr = getAdmReason();
	var admReasonId = admReasonDetStr[0];
	var admReasonNationalCode = admReasonDetStr[1];
	
	var rtnVal = 0;
	if(admReasonNationalCode > 0 && payedFlag == "Y") {
		var rtnVal = InsuIPDivideCancle(0,SessionObj.guser, GlobalObj.billId, admReasonNationalCode, admReasonId, "");	
		if(rtnVal == 0) {
			jQuery.messager.alert("取消医保结算", "取消医保结算成功.");
			//删除医保支付方式
			delGridInsuInfo();
			//更新病人基本信息
			//initPatientBaseInfo();
		}
	}
	return rtnVal;
}

//账单成功后 不刷新界面只更新病人数据
function updateFootData() {
	//根据账单号,获取账单后的结算数据
	var CH2 = String.fromCharCode(2);
	var expStr = "";
	var payedFlag = "";
	var billInfo = getBillBaseInfo();
	if(billInfo == "") {
		return false;
	}
	var billFlag = billInfo.split("^")[15];
	if(billFlag === "B"){
		payedFlag = "B";
	}else{
		payedFlag="P";
	}
	//未结算记录修改数据
	if(payedFlag === "B") { 
		//押金$c(2)总金额^自付金额^折扣金额^记账金额
		//更新费用信息
		var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "GetPatFeeByBillNO", GlobalObj.billId, payedFlag, expStr);
		var tmpAry = rtn.split(CH2);
		var deposit = tmpAry[0];
		var patfeeInfo = tmpAry[1].split("^");
		var stAmt = tmpAry[2];
		var insuAmt = tmpAry[3];    //医保金额
		jQuery("#totleAmt").numberbox('setValue', patfeeInfo[0]);
		jQuery("#patShareAmt").numberbox('setValue', patfeeInfo[1]);
		jQuery("#disCountAmt").numberbox('setValue', patfeeInfo[2]);
		jQuery("#patPayorAmt").numberbox('setValue', patfeeInfo[3]);
		jQuery("#patStAmt").numberbox('setValue', stAmt);
		//更新押金金额
		var depInfo = getDepositInfo();
		var allDepAmt = depInfo.split("^")[0];
		var avaiDepAmt = depInfo.split("^")[1];
		jQuery("#totleDeposit").numberbox('setValue', allDepAmt);
		jQuery("#selDepAmt").numberbox('setValue', avaiDepAmt);
		//更新医保金额 need revise
		jQuery("#patInsuAmt").numberbox('setValue', insuAmt);
		//更新选中记录的数据
		//需更新押金、总金额、自付费用、（折扣费用） 
		var thisRowObj = jQuery('#tPatList').datagrid('getSelected');
		var rowIndex = jQuery("#tPatList").datagrid("getRowIndex", thisRowObj);
		if(thisRowObj != "") {
			jQuery("#tPatList").datagrid("updateRow", {
				index : rowIndex,
				row	: {
					deposit: deposit,
					totalamount: patfeeInfo[0],
					patientshare: patfeeInfo[1],
					discountamount: patfeeInfo[2],
					payorshare: patfeeInfo[3],
					ybfee: insuAmt
				}
			});
		}
	}
}

//取消结算医保取消调用
function revIPFootBack() {
	var admReasonDetStr = getAdmReason();
	var admReasonId = admReasonDetStr[0];
	var admReasonNationalCode = admReasonDetStr[1];
	var rtnVal = 0;
	if(admReasonNationalCode > 0) {
		rtnVal = InsuIPDivideCancle(0, SessionObj.guser, GlobalObj.billId, admReasonNationalCode, admReasonId, "");	
	}
	return rtnVal;
}

//判断医保病人是否能够中途结算 
//根据UDHCJFIPInsu.js
function canHarfBillForInsu() {
	//数组里添加不能中途结算的医保类型Desc
	var insuArr = new Array();
	insuArr.push("本地医保");
	//取就诊费别
	var rtn = tkMakeServerCall("web.DHCIPBillCashier", "getInsTypeInfo", GlobalObj.episodeId, "");
	var nationalCode = "", admReasonDesc = "";
	if(rtn != "") {
		var rtnArr = rtn.split("^");
		nationalCode = rtnArr[5];
		admReasonDesc = rtnArr[2];
	}
	if(jQuery.inArray(admReasonDesc, insuArr) != -1) {
		return false;
	}
	if(nationalCode != "" && nationalCode != " " && nationalCode != 0 && Config.dhcJfConfig.insuPayFlag == "N") {
		//alert("-"+nationalCode+"-")
		return false;
	}
	return true;
}

//获取支付方式串
function getPayModeList() {
	var paymStrs = "";
	var allPaymRow = jQuery("#tPaymList").datagrid("getRows");
	
	jQuery.each(allPaymRow, function(index, value) {
		var rowData = allPaymRow[index];
		var paymAmt = rowData['CTPMAmt'];
		var paymDr = rowData['CTPMRowID'];
		var paymCode = rowData['CTPMCode'];
		var paymBank = rowData['CTPMBank'];
		var paymBankSub = rowData['CTPMBankSub'];
		var paymCheck = rowData['CTPMCheckno'];
		var paymBankno = rowData['CTPMBankNo'];
		var pmck = rowData['pmck'];
		var transFlag = rowData['transFlag'];
		var paymAccount = rowData['CTPMAcount'];
		var paymUnit = rowData['CTPMUnit'];
		var ybFlag = rowData['ybFlag'];
		var paymDesc = rowData['CTPMDesc'];
		paymBankno = paymCheck;  //设置为支票号 need revise hu
		if((paymAmt !== "") && (paymAmt != null) && (paymAmt != undefined)) {
			paymAmt = parseFloat(paymAmt).toFixed(2);
			//need revise hu
			//支付方式ID^银行@子行^卡号支票号^PAYM_GovernNo^PAYM_AuthorCode^金额^PAYM_Branch
			var paymStr = paymDr + "^" + paymBank + "@" + paymBankSub + "^" + paymBankno + "^" + paymUnit + "^" + paymAccount + "^" + paymAmt + "^" + transFlag + "^" + ybFlag + "^" + paymDesc;

			paymStrs = paymStrs + "&" + paymStr;

		}
	})
	
	return paymStrs;
}

//获取欠费数量
function getQfNum() {
	var count = 0;
	var allRows = jQuery("#tPaymList").datagrid("getRows");  //所有行
	jQuery.each(allRows, function(index, value) {
		var rowData = allRows[index];
		if(rowData['CTPMCode'] == "QF" && rowData['CTPMAmt'] != "" && rowData['CTPMAmt'] != 0) {
			count = count + 1;
		}
	});
	
	return count;
}

//获取转账标志 need reverse
function getTransferFlag() {
	var flag = false;
	if(jQuery("#transferflag").length) {
		var transferflagChecked = jQuery("#transferflag").get(0).checked;
		if(transferflagChecked) {
			flag = true;
		}
	}
	return flag;
}

//判断平衡金额
function checkBalance() {
	var flag1 = 0, flag2 = 0;
	var balance = GlobalObj.balance;
	if(balance == 0 ) {
		flag1 = 1;
	} else {
		flag1 = 0;
	}
	//判断支付方式和收退金额
	var paymAll = getPaymAll();
	var patShareAmt = jQuery("#patShareAmt").numberbox('getValue');
	var deposit = jQuery("#selDepAmt").numberbox('getValue');
	patShareAmt = parseFloat(patShareAmt).toFixed(2);
	deposit = parseFloat(deposit).toFixed(2);
	var myBalance = patShareAmt - deposit - paymAll;
	myBalance = parseFloat(myBalance).toFixed(2);
	//log(myBalance + ":" + patShareAmt + ":" + deposit + ":" + paymAll)
	if(myBalance == 0) {
		flag2 = 1;
	}else {
		flag2 = 0;
	}
	//log(flag1 + "flag1")
	//log(flag2 + "flag2")
	if(flag1 = 1 && flag2 == 1) {
		return true;
	}else {
		return false;
	}
	
}

//判断是否在结算前账单后是否又交了押金
//根据押金列表的金额和后台进行判断，判断总金额和可使用金额
//并判断病人信息上的押金额
function judgeDepositSum() {
	var flag1 = 0, flag2 = 0;
	//后台获取押金总数和可用押金总数
	var rtn = getDepositInfo();
	var rtnArr = rtn.split("^");
	var actualAllDep = rtnArr[0];
	var actualAvaiDep = rtnArr[1];
	var thisAllDep = 0, thisAvaiDep = 0;
	if(jQuery("#tDepositList").length) {
		var allRow = jQuery("#tDepositList").datagrid("getRows");
		jQuery.each(allRow, function(index, value) {
			var rowData = allRow[index];
			var depAmt = rowData.TDepAmt;
			depAmt = parseFloat(depAmt);
			thisAllDep = thisAllDep + depAmt;
			if(rowData.TBillFlag == 1) {
				thisAvaiDep = thisAvaiDep + depAmt;
			}
		});
	}
	var pageAllDep = jQuery("#totleDeposit").numberbox('getValue');
	var pageAvaiDep = jQuery("#selDepAmt").numberbox('getValue');
	actualAllDep = parseFloat(actualAllDep).toFixed(2);  //后台总押金
	actualAvaiDep = parseFloat(actualAvaiDep).toFixed(2);  //后台可用押金
	thisAllDep = parseFloat(thisAllDep).toFixed(2);  //押金列表总押金
	thisAvaiDep = parseFloat(thisAvaiDep).toFixed(2);  //押金列表可用押金
	pageAllDep = parseFloat(pageAllDep).toFixed(2);  //界面押金总额
	pageAvaiDep = parseFloat(pageAvaiDep).toFixed(2);  //界面可用押金

	if(Config.dhcJfConfig.bankBackPayFlag == "Y") {
		if(actualAllDep == thisAllDep) {
			flag1 = 1;
		}
	}else {
		if(actualAvaiDep == thisAvaiDep) {
			flag1 = 1;
		}
	}
	
	if(actualAllDep == thisAllDep && actualAvaiDep == thisAvaiDep) {
		flag2 = 1;
	}
	if(flag1 == 1 && flag2 == 1) {
		return true;
	}else {
		return false;
	}
	return false;
}

//获取押金串
function getDepoistStr() {
	var depStr = "";
	if(DepositSelectObj.depositArray == null) {
		return depStr;
	}
	if(jQuery.isArray(DepositSelectObj.depositArray)) {
		depStr = DepositSelectObj.depositArray.join("^");
	}

	return "^" + depStr;
}

//判断当前票号和界面是否一致
function checkInvSame() {
	var sameFlag = true;
	var admReasonInfo = tkMakeServerCall("web.DHCIPBillCashier", "getInsTypeInfo", GlobalObj.episodeId, "");
	if(admReasonInfo == "") {
		return false;
	}
	var admReasonInfoArr = admReasonInfo.split("^");
	var admReason = admReasonInfoArr[1];  //instypeDesc
	var value = tkMakeServerCall("web.UDHCJFPAY", "getcurinvno1",SessionObj.guser, admReason);
	var valArr = value.split("^");
	//log(valArr)
	var currentID = "";
	if(valArr.length == 3) {
		currentID = valArr[1];
	}

	var myCurInvId = jQuery("#currentInvId").val();
	//log(currentID + ":" + myCurInvId)
	if(currentID != myCurInvId) {
		sameFlag = false;
	}

	return sameFlag;
}	


//判断是否有可用发票
function checkInv() {
	if(GlobalObj.episodeId != "") {
		//后台取就诊的费别信息 add hujunbin
		var admReasonInfo = tkMakeServerCall("web.DHCIPBillCashier", "getInsTypeInfo", GlobalObj.episodeId, "");
		if(admReasonInfo == "") {
			return false;
		}
		var admReasonInfoArr = admReasonInfo.split("^");
		var admReasonDesc = admReasonInfoArr[2];  //instypeDesc
		//判断有没有发票,后台方法用的是DESC
		var currentInv = tkMakeServerCall("web.UDHCJFPAY", "getcurinvno", "setCurrentInv", "", SessionObj.guser, admReasonDesc);
		if(currentInv == 1) {
			return true;
		} else {
			return false;
		}
	}else {
		var myRtn = tkMakeServerCall("web.UDHCJFPAY", "getcurinvno1", SessionObj.guser, "");
		setCurrentInvNoInstype(myRtn);
	}
}

//设置用户发票信息
function setCurrentInv(value) {
	var valArr = value.split("^");
	var currentNo = "", currentID = "";
	var currentFlag = "", currentTitle = "";
	if(valArr.length == 4) {
		currentNo = valArr[0];
		currentID = valArr[1];
		currentFlag = valArr[2];
		currentTitle = valArr[3];
	}
	//用[]分割了发票前缀和发票号
	var invNo = currentTitle + "[" + currentNo + "]";
	jQuery("#currentInvId").val(currentID);
	jQuery("#currentInv").val(invNo);
}

function setCurrentInvNoInstype(value) {
	var valArr = value.split("^");
	var currentNo = "", currentID = "";
	var currentTitle = "";
	if(valArr.length == 3) {
		currentNo = valArr[0];
		currentID = valArr[1];
		currentTitle = valArr[2];
	}
	//用[]分割了发票前缀和发票号
	var invNo = currentTitle + "[" + currentNo + "]";
	jQuery("#currentInvId").val(currentID);
	jQuery("#currentInv").val(invNo);
}

//获取发票头和发票号
function getCurrentInv() {
	var $currentInv = jQuery("#currentInv").val();
	if($currentInv == "") {
		return "" + "^" + "";
	} else {
		var invStr = $currentInv.split("[");
		var invTit = invStr[0];
		var invNoStr = invStr[1];
		var invNo = invNoStr.substring(0, invNoStr.length - 1);
		return invTit + "^" + invNo;
	}
}

//获取账单基本字段信息
function getBillBaseInfo() {
	var billBaseInfo = tkMakeServerCall("web.DHCIPBillCashier", "getBillBaseInfo", GlobalObj.billId);
	return billBaseInfo;
}


//获取就诊的账单数量
function getBillNum() {
	var num = tkMakeServerCall("web.UDHCJFPAY", "GetNotPayedNum", GlobalObj.episodeId);
	return num;
}

//获取全部押金和可用押金GetBillReaNationCode
function getDepositInfo() {
	var rtn = tkMakeServerCall("web.DHCIPBillCashier", "getDepositSum", GlobalObj.episodeId, GlobalObj.billId);
	return rtn;
}

// 获取就诊费别ID 和 NationalCode
// modify ZhYW 2018-05-02 改为取账单的费别
function getAdmReason() {
	if(GlobalObj.billId == "") {
		return "";
	}
	var rtn = tkMakeServerCall("web.UDHCJFPAY", "GetBillReaNationCode", GlobalObj.billId);
	var admReasonDetStr = rtn.split("^");
	return admReasonDetStr;
}

//获得第一行支付方式，没有取门诊配置
function getDefPaym() {
	var paymInfo = tkMakeServerCall("web.DHCIPBillCashier", "GetPaymDefSequence", SessionObj.group);
	var paymInfoArr = paymInfo.split("^");
	var paymDr = paymInfoArr[0];
	var paymDesc = paymInfoArr[1];
	return paymDr + "^" + paymDesc;
}

//取支付方式是否有必填项 1:必填 0无
function IsPaymRequired(id) {
	var flag = tkMakeServerCall("web.DHCIPBillCashier", "IsRequiredInfo", SessionObj.group, id);
	return flag;
}

//判断账单费别是否需要发票
function getQualifStatus() {
	var qualifStatus = tkMakeServerCall("web.UDHCJFBaseCommon","GetReaQualifStatus", GlobalObj.billId);
	return qualifStatus;
}

//判断医保是否已经结算
function checkInsuCharge() {
	var flag = false;
	var rtn = tkMakeServerCall("web.DHCIPBillCashier","IsDisableInsuChargeBtn", GlobalObj.billId);
	//alert("判断是否医保结算："+rtn);
	if(rtn == 0) {
		flag = true;     //医保未结算
	}else {
		flag = false;
	}
	return flag;
}

//获取医保结算信息
function getInsuChargeInfo() {
	var insuInfo = "";
	var insuFlag = checkInsuCharge();
	var admReasonDetStr = getAdmReason();
	var admReasonId = admReasonDetStr[0];
	var admReasonNationalCode = admReasonDetStr[1];
	var billFlag = "";
	var billInfo = getBillBaseInfo();
	if(billInfo != "") {
		billFlag = billInfo.split("^")[15];
	}
	//if ((admReasonNationalCode > 0) && (billFlag != "P") && (!insuFlag)) {
	if ((admReasonNationalCode > 0) && (!insuFlag)) {
		if((GlobalObj.billId)&&(GlobalObj.billId!="")){
			// 此接口需要确认医保是否可能存在重复结算，如果不会存在医保重复结算则可以使用,否则需要医保重新提供医保结算数据接口
			insuInfo = InsuIPDivide(0, SessionObj.guser, GlobalObj.billId, admReasonNationalCode, admReasonId, "");		
		}
	}
	return insuInfo;
}

//获取医保结算信息
//返回值:
// 	1:医保已上传明细
// 	2:医保已结算
// 	小于0:医保未结算未上传
function getInsuUpFlag(){
	var insuUpFlag = tkMakeServerCall("web.DHCIPBillCashier","JudgePBInsuUpFlag",GlobalObj.billId,"");
	return insuUpFlag;
}

//获取打印模板名称
function getXMLName(episodeId, billId) {
	var episodeId = GlobalObj.episodeId;
	var billId = GlobalObj.billId;
	if(episodeId == "" || billId == "") {
		return;
	}
	var admReasonDetStr = getAdmReason();
	var admReasonId = admReasonDetStr[0];
	var admReasonNationalCode = admReasonDetStr[1];
	var xmlName = tkMakeServerCall("web.UDHCJFBaseCommon", "GetInvXMLName", admReasonId);
	if(xmlName == "") {
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCJFIPReceipt");
	} else {
		DHCP_GetXMLConfig("InvPrintEncrypt", xmlName);
	}
}

//获取计算机名
function getComputerName() {
	//var WshNetwork = new ActiveXObject("WScript.NetWork");
	//var computerName=WshNetwork.ComputerName;
	var computerName = session['LOGON.USERNAME'];
	return computerName;
}

function altVoidInvClick() {
	var insType = "";
	var admReasonDetStr = getAdmReason();
	if(admReasonDetStr != ""){
		insType = admReasonDetStr[0];
	}
	var receiptType = "IP";
	var iHeight = 400;
	var iWidth = 620;
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;  //获得窗口的水平位置
    var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCBillSkipInvoice&CurrentInsType=" + insType + "&receiptType=" + receiptType;
   	websys_createWindow(lnk, '_blank', "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top="+iTop+",left="+iLeft+",width="+iWidth+",height="+iHeight);
}

/**
* ZhYW
* 判断自费结算时是否取消医保登记
* false: 未取消, true: 取消
*/
function checkInsuRegIsCancel() {
	var rtn = true;
	var admReasonAry = getAdmReason();
	var admReasonId = admReasonAry[0];
	var admNationalCode = admReasonAry[1];
	if (+admNationalCode > 0) {
		return rtn;      //医保患者退出
	}
	//判断是否拆分账单
	var splitFlag = tkMakeServerCall("web.UDHCJFPAY", "CheckBillIsSplitByAdm", GlobalObj.episodeId);
	if (splitFlag == "Y") {
		return rtn;
	}
	var insuAdmInfo = tkMakeServerCall("web.DHCINSUPort", "GetInsuAdmInfoByAdmDr", GlobalObj.episodeId);
	if (insuAdmInfo != "") {
		var myAry = insuAdmInfo.split("^");
		var valid = myAry[10];
		var myStr = "AO";
		if (myStr.search(valid) != -1) {
			rtn = false;
		}
	}
	return rtn;
}