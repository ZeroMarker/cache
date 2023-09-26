/// udhcOPRefund.AuditOrder.js

//关联医嘱此标志为"Y"时勾选主医嘱或子医嘱时相关联的医嘱必须同时勾选。
//              为"N"时勾主医嘱子医嘱必须勾选勾选子医嘱主医嘱和其他子医嘱可以不勾选
var m_LinkageFlag = "N";
var m_AppComFlag = ""; //退费审核模式：0->需要财务人员审批 1->需要在医嘱上审批 2->需要财务人员和医嘱上的双重审批 空--不需要审核退费

function BodyLoadHandler() {
	var obj = document.getElementById("tudhcOPRefund_AuditOrder");
	if (obj) {
		obj.onkeyup = WriteRetMoney;
	}
	var AllSelectObj = document.getElementById("AllSelect");
	if (AllSelectObj) {
		AllSelectObj.onclick = AllSelect_OnClick;
	}
	IntDoument();
	//document.onkeydown = DHCWeb_EStopSpaceKey;

}

function tRefundOrder_Click() {
	var eSrc = window.event.srcElement;
	if (eSrc.tagName == "IMG") {
		eSrc = window.event.srcElement.parentElement;
	}
	var eSrcAry = eSrc.id.split("z");
	var rowObj = getRow(eSrc);
	if (rowObj.tagName == 'TH') {
		return;
	}
	var row = rowObj.rowIndex;
	var sExcute = document.getElementById('TExcuteflagz' + row).value;
	var sSelect = document.getElementById('Tselectz' + row);
	var ExQty = document.getElementById('TOrderQtyz' + row).innerText;
	var ReturnQty = document.getElementById('TReturnQtyz' + row).innerText;
	if ((sExcute == "1") || ((ReturnQty < ExQty) && (ReturnQty != 0))) {
		sSelect.disabled = true;
	}
}

function IntDoument() {
	//2016-02-02 chenxi 门诊退费审核界面获取该发票退费审核方式
	var mainobj = parent.frames["udhcOPRefund_Auditing"];
	var ReceipID = "";
	var IDobj = mainobj.document.getElementById("ReceipID");
	if (IDobj) {
		ReceipID = IDobj.value;
	}
	if (ReceipID == " ") {
		ReceipID = "";
	}
	if (ReceipID == "") {
		return;
	}
	var AuditConfigStr = tkMakeServerCall("web.UDHCPRTOEAuthCommon", "GetAuthConfigForINV", ReceipID, "");
	if (AuditConfigStr != "") {
		var AuditConfigStr1 = AuditConfigStr.split("^");
		m_AppComFlag = AuditConfigStr1[0];
	}
	if ((m_AppComFlag == "2") || (m_AppComFlag == 2)) {
		var AllSelectObj = document.getElementById("AllSelect");
		if (AllSelectObj) {
			AllSelectObj.disabled = true;
		}
	}
	//check OEOrder is Enable or disable
	var tabOPList = document.getElementById('tudhcOPRefund_AuditOrder');
	var rows = tabOPList.rows.length;
	for (var row = 1; row < rows; row++) {
		var sAuditFlag = document.getElementById('AuditFlagz' + row).value;
		var sSelect = document.getElementById('Tselectz' + row);
		var ExQty = document.getElementById('TOrderQtyz' + row).innerText;
		var ReturnQty = document.getElementById('TReturnQtyz' + row).innerText;
		var ExecutFlagDesc = document.getElementById('ExecutFlagDescz' + row).innerText;
		var TDrugRetRequobj = document.getElementById('TDrugRetRequz' + row); ///申请退费数量
		var TCanReturnNum = document.getElementById('TCanReturnNumz' + row).innerText; /// 可申请数量
		var TOrderType = document.getElementById('TOrderTypez' + row).value;
		var Tinciflag = document.getElementById('Tinciflagz' + row).value;
		var Tphdi = document.getElementById('Tphdiz' + row).value;
		if (Tphdi == " ") {
			Tphdi = "";
		}
		var myobj = document.getElementById("AuditSelFlagz" + row);
		var myAuditSelFlag = DHCWebD_GetCellValue(myobj);
		myAuditSelFlag = parseInt(myAuditSelFlag);
		var TOrdStopStatus = document.getElementById('TOrdStopStatusz' + row).value;
		var UnAuditOrdItem = document.getElementById('UnAuditOrdItemz' + row).value;
		if ((sAuditFlag == "Y")) {
			if ((TOrdStopStatus != "D") && (UnAuditOrdItem != "Y")) {
				sSelect.disabled = true;     //灰色不能勾选
			}
			if ((TOrdStopStatus == "D") && ((m_AppComFlag == "2") || (m_AppComFlag == 2) || (m_AppComFlag == "1") || (m_AppComFlag == 1))) {
				sSelect.disabled = true;
			}
			//2016-02-05 chenxi 药品发药后申请退费, 有欠药或多次发药时在退费审核界面为多条记录
			//所以如这些记录中已发药且可申请数量有值时可以再次申请
			var drugSelectFlag = "N";
			drugSelectFlag = CheckdrugSelectFlag(row);
			if (drugSelectFlag == "Y") {
				if ((m_AppComFlag == "2") || (m_AppComFlag == 2) || (m_AppComFlag == "1") || (m_AppComFlag == 1)) {
					if (TOrderType != "R") {
						sSelect.disabled = false;
					}
				}
			}
		} else {
			sSelect.disabled = false;
		}
		if ((m_AppComFlag == "2") || (m_AppComFlag == 2) || (m_AppComFlag == "1") || (m_AppComFlag == 1)) {
			//if (TOrderType != "R"){
			if ((TOrdStopStatus != "D") && (UnAuditOrdItem != "Y")) {
				sSelect.disabled = true;    //灰色不能勾选
			}
			//}
			DHCWebD_SetListValueA(sSelect, myAuditSelFlag);

		}
		if (m_AppComFlag == "") {
			sSelect.disabled = false;     //不审核时可以勾选
		}
		//modify 2014-04-14 药品医嘱未发药不能修改申请退药数量
		var TOEORDExecQty = document.getElementById('TOEORDExecQtyz' + row).innerText;
		var TDrugRetRequobj = document.getElementById('TDrugRetRequz' + row);
		var TDrugRetReasonobj = document.getElementById('TDrugRetReasonz' + row);
		var TExcuteflag = document.getElementById('TExcuteflagz' + row).value;
		var TLinkOrder = document.getElementById('TLinkOrderz' + row).innerText;
		var TOweFlag = document.getElementById('TOweFlagz' + row).value;
		if ((TOEORDExecQty == "") || (TOEORDExecQty == " ")) {
			TOEORDExecQty = 0;
		}
		if (isNaN(TOEORDExecQty)) {
			TOEORDExecQty = 0;
		}
		var TCanReturnNum = document.getElementById('TCanReturnNumz' + row).innerText;
		if ((TCanReturnNum == "") || (TCanReturnNum == " ")) {
			TCanReturnNum = 0;
		}
		if (isNaN(TCanReturnNum)) {
			TCanReturnNum = 0;
		}
		if (TCanReturnNum == 0) {
			var Id = "TDrugRetRequz" + row;
			var cellobj = websys_getParentElement(TDrugRetRequobj);
			if (cellobj) {
				var objwidth = cellobj.style.width;
				var objheight = cellobj.style.height;
				var str = "<label id=\"" + Id + "\" name=\"" + Id + "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight + "\" value=\"\">";
				cellobj.innerHTML = str;
			}
		}
		if (TOrderType == "R") {
			if ((eval(TOEORDExecQty) == 0) && (TExcuteflag == 0)) {
				TDrugRetRequobj.disabled = true;
			} else {
				TDrugRetRequobj.disabled = false;
			}
			//modify 2014-06-10 取欠药标志和审核标志时将从ie界面取汉字改为取标志
			//if ((ExecutFlagDesc=="欠药")||(ExecutFlagDesc ==" ")||(ExecutFlagDesc == "已审核"))    //没发药是全退
			//if ((TOweFlag=="0")||(ExecutFlagDesc == " ")||(sAuditFlag == "Y")){          //没发药是全退
			if ((TOweFlag == "0") || (ExecutFlagDesc == " ") || (Tphdi == "")) {           //没发药是全退
				var Id = "TDrugRetRequz" + row;
				var cellobj = websys_getParentElement(TDrugRetRequobj);
				if (cellobj) {
					var objwidth = cellobj.style.width;
					var objheight = cellobj.style.height;
					var str = "<label id=\"" + Id + "\" name=\"" + Id + "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight + "\" value=\"\">";
					if (m_AppComFlag != "") {
						cellobj.innerHTML = str;
					} else {
						if (((TOweFlag == "0") || (TOweFlag == "0")) && (TOrderType == "R")) {
							cellobj.innerHTML = str;
						}
					}
				}
				StopconfigOweDrug(row, myAuditSelFlag);
			}
		} else {
			//modify 2014-04-18 增加判断非药品医嘱是否能部分退费
			var TOrderRowidObj = document.getElementById('TOrderRowidz' + row);
			var TOrderRowid = TOrderRowidObj.innerText;			
			var TMatDispGrant = DHCWeb_GetColumnData('TMatDispGrant', row); //+2017-08-28 ZhYW  物资走发放流程标志
			if (TOrderRowid != "") {
				var AllowFlag = tkMakeServerCall("web.DHCOPBillRefundRequestNew", "GetOrdAllowPartRequest", TOrderRowid);
				if (AllowFlag == "Y") {
					TDrugRetRequobj.disabled = false;
					if ((m_AppComFlag == "2") || (m_AppComFlag == 2) || (m_AppComFlag == "1") || (m_AppComFlag == 1)) {
						TDrugRetRequobj.innerText = TCanReturnNum;
					}
				} else {
					TDrugRetRequobj.disabled = true;
					if ((m_AppComFlag == "2") || (m_AppComFlag == 2) || (m_AppComFlag == "1") || (m_AppComFlag == 1)) {
						TDrugRetRequobj.innerText = TCanReturnNum;
					}
				}
				//Tinciflag:"N"走库存, "Y"不走库存
				if (Tinciflag == "N") {
					var Id = "TDrugRetRequz" + row;
					var cellobj = websys_getParentElement(TDrugRetRequobj);
					if (cellobj) {
						var objwidth = cellobj.style.width;
						var objheight = cellobj.style.height;
						var str = "<label id=\"" + Id + "\" name=\"" + Id + "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight + "\" value=\"\">";
						//cellobj.innerHTML = str;
					}
				}
				//
				//+2017-06-23 ZhYW  物资未发放不能部分退费
				if (TMatDispGrant == 'Y'){
					var matDistriFlag = tkMakeServerCall("web.DHCSTM.PCHCOLLSM", "CheckDispStaByOeori", TOrderRowid);   
		        	if (matDistriFlag == 0) {
			    		TDrugRetRequobj.disabled = true;
		      		}
				}
			}
		}
		if ((TOrdStopStatus == "D") && ((m_AppComFlag == "2") || (m_AppComFlag == 2) || (m_AppComFlag == "1") || (m_AppComFlag == 1))) {
			sSelect.disabled = true;
		}
	}
	CalCurRefund();
}

function CalCurRefund() {
	var ListObj = parent.frames["udhcOPRefund_AuditOrder"];
	var mainobj = parent.frames["udhcOPRefund_Auditing"];
	if ((mainobj) && (ListObj)) {
		var obj = mainobj.document.getElementById("RefundSum");
		var rtn = DHCWebD_CalListCol(ListObj, "RefSum", "Tselect");
		if (obj) {
			obj.value = rtn;
		}
	}
	return rtn;
}

function SelectRowHandler() {
	//能够继承table表的Click事件?
	SeqNoLink();        //add by wanghuicai 2009-10-9
	CalCurRefund();
}

function SeqNoLink() {
	var tabOPList = document.getElementById('tudhcOPRefund_AuditOrder');
	var rows = tabOPList.rows.length;
	var selectrow = DHCWeb_GetRowIdx(window);
	var clickMySeqNo = document.getElementById('TOrdSeqNoz' + selectrow).value;
	var InvPrtDr = document.getElementById('InvPrtDrz' + selectrow).innerText;
	var sSelect = document.getElementById('Tselectz' + selectrow);
	var flag = sSelect.checked;
	var flag1 = !flag;
	var clickMySeqNoArr = clickMySeqNo.split(".");
	var DrugIsOweFlag = CheckDrugIsOwe(selectrow);
	var ExecutFlagDesc = document.getElementById('ExecutFlagDescz' + selectrow).innerText;
	var PrescNo = document.getElementById('PrescNoz' + selectrow).innerText;      //处方号
	var TDrugRetRequObj = document.getElementById('TDrugRetRequz' + selectrow);
	var TDrugRetRequ = TDrugRetRequObj.value;
	if (TDrugRetRequ == " ") {
		TDrugRetRequ = "";
	}
	if (ExecutFlagDesc == "已审核") {
		alert("该医嘱已审核,无需再次审核");
		sSelect.checked = false;
	}
	if (ExecutFlagDesc == "已执行") {
		alert("该医嘱已被执行,请撤销执行后再退费");
		sSelect.checked = false;
		return;
	}
	var TExecutDesc = document.getElementById('TExecutDescz' + selectrow).innerText;
	if (ExecutFlagDesc == "已执行") {
		alert("该医嘱已被执行,请撤销执行后再退费")
		sSelect.checked = false;
		return;
	}

	var DrugRetALreadyNum = document.getElementById('TDrugRetALreadyz' + selectrow).innerText;
	if (DrugRetALreadyNum == " ") {
		DrugRetALreadyNum = "";
	}

	if ((DrugRetALreadyNum != "") && (DrugRetALreadyNum != 0) && (DrugRetALreadyNum != "0")) {
		if (flag == true) {
			alert("请先取消申请后再重新申请!!");
			sSelect.checked = false;
			TDrugRetRequObj.value = "";
			TDrugRetRequ = "";
			return;
		}
	}
	var CanReturnNum = document.getElementById('TCanReturnNumz' + selectrow).innerText;
	if ((CanReturnNum == "") || ((CanReturnNum == 0) && (DrugRetALreadyNum = 0)) || ((CanReturnNum == "0") && (DrugRetALreadyNum = "0")) || (CanReturnNum == " ")) {
		alert("没有可申请数量！！！");
		sSelect.checked = false;
		return;
	}
	var myQFOrder = new Array();
	var myQFOrdernum = new Array();
	var TMPmyQFOrder = "";    //欠费医嘱串
	var TOrderRowid = document.getElementById('TOrderRowidz' + selectrow).innerText;
	var TLinkOrder = document.getElementById('TLinkOrderz' + selectrow).innerText;
	if (TLinkOrder == " ") {
		TLinkOrder = "";
	}
	if (TOrderRowid == " ") {
		TOrderRowid = "";
	}
	var ExecutFlagDesc = document.getElementById('ExecutFlagDescz' + selectrow).innerText;
	//modify 2014-06-10 取欠药标志和审核标志时将从ie界面取汉字改为取标志
	var TOweFlag = document.getElementById('TOweFlagz' + selectrow).value;
	var OrderTypeObj = document.getElementById('TOrderTypez' + selectrow);
	var OrderType = OrderTypeObj.value;
	//2015-01-30 chenxi 欠药医嘱勾选去掉时如其对应的医嘱的发药是勾选的则不能退掉
	var CheckOweFlag = "Y";
	var otherCheckOweFlag = "Y";
	if (((TOweFlag == "0") || (TOweFlag == 0)) && (OrderType == "R") && (TLinkOrder != "") && (flag1 == true)) {
		CheckOweFlag = CheckDrugOwe(selectrow, flag1);
		otherCheckOweFlag = CheckDrugOwePresno(selectrow, flag1);
		if (CheckOweFlag == "N") {
			sSelect.checked = true;
			alert("该药品正常发药记录申请退药时,欠药医嘱必须同时申请退药");
			return;
		}
		if (otherCheckOweFlag == "N") {
			sSelect.checked = true;
			alert("同一处方的欠药记录必须同时申请退药,此处方中其他欠药医嘱有正常发药记录也申请了退药,所以不能去掉勾选");
			return;
		}
	}
	if (CheckOweFlag == "N") {
		return;
	}
	if ((TOweFlag == "0") || (ExecutFlagDesc == " ") || (ExecutFlagDesc == "已审核")) {
		var TOrderTypeObj = document.getElementById('TOrderTypez' + selectrow);
		var TOrderType = TOrderTypeObj.value;
		if ((flag) && (TOrderType != "R")) {
			if ((TDrugRetRequObj.value == "") || (TDrugRetRequObj.value == "undefined") || (TDrugRetRequObj.value == " ")) {
				TDrugRetRequObj.innerText = document.getElementById('TCanReturnNumz' + selectrow).innerText;
			}
		} else {
			TDrugRetRequObj.innerText = "";
		}
	} else {
		if ((ExecutFlagDesc != "已发药") || (ExecutFlagDesc != "已发药")) {
			if (flag) {
				TDrugRetRequObj.value = document.getElementById('TCanReturnNumz' + selectrow).innerText;
			} else {
				TDrugRetRequObj.value = "";
			}
		}
		if (ExecutFlagDesc = "已发药") {
			if (flag == false) {
				TDrugRetRequObj.value = "";
			}
		}
	}
	if (((TOweFlag == "0") || (TOweFlag == 0)) && (OrderType == "R")) {
		if (flag == true) {
			document.getElementById('TDrugRetRequz' + selectrow).innerText = document.getElementById('TCanReturnNumz' + selectrow).innerText;
		} else {
			document.getElementById('TDrugRetRequz' + selectrow).innerText = "";
		}
	}
	for (var row = 1; row < rows; row++) {
		//modify 2014-06-10 有欠药功能退费申请关联医嘱不能联动, 否则申请退药会有问题
		//关联医嘱一起勾上
		var tmpTLinkOrder = document.getElementById('TLinkOrderz' + row).innerText;
		var TMPOrderRowid = document.getElementById('TOrderRowidz' + row).innerText;
		var ExecutFlagDesc = document.getElementById('ExecutFlagDescz' + row).innerText;
		var TDrugRetRequObj = document.getElementById('TDrugRetRequz' + row);
		var tmpTOweFlag = document.getElementById('TOweFlagz' + row).value;
		var tmpExecutFlagDesc = document.getElementById('ExecutFlagDescz' + row).innerText;
		if (tmpTLinkOrder == " ") {
			tmpTLinkOrder = "";
		}
		var tmpOrderTypeObj = document.getElementById('TOrderTypez' + row);
		var tmpOrderType = tmpOrderTypeObj.value;
		if (m_LinkageFlag == "Y") {
			//两个子医嘱相关联
			if ((TLinkOrder != "") && (tmpTLinkOrder == TLinkOrder)) {
				var sSelectRow = document.getElementById('Tselectz' + row);
				sSelectRow.checked = flag;
				//modify 2014-06-10 取欠药标志和审核标志时将从ie界面取汉字改为取标志
				if ((tmpTOweFlag == "0") && (TOweFlag == "0")) {
					if (flag) {
						document.getElementById('TDrugRetRequz' + row).innerText = document.getElementById('TCanReturnNumz' + row).innerText;
					} else {
						document.getElementById('TDrugRetRequz' + row).innerText = "";
					}
				}
			}
			//子医嘱关联主医嘱
			if ((TLinkOrder != "") && (tmpTLinkOrder == "") && (TLinkOrder == TMPOrderRowid)) {
				var sSelectRow = document.getElementById('Tselectz' + row);
				sSelectRow.checked = flag;
				//modify 2014-06-10 取欠药标志和审核标志时将从ie界面取汉字改为取标志
				if ((tmpTOweFlag == "0") && (TOweFlag == "0")) {
					if (flag) {
						document.getElementById('TDrugRetRequz' + row).innerText = document.getElementById('TCanReturnNumz' + row).innerText;
					} else {
						document.getElementById('TDrugRetRequz' + row).innerText = "";
					}
				}
			}
			//主医嘱勾选子医嘱必须跟着勾选
			if ((TLinkOrder == "") && (tmpTLinkOrder == TOrderRowid)) {
				var sSelectRow = document.getElementById('Tselectz' + row);
				sSelectRow.checked = flag;
				//modify 2014-06-10 取欠药标志和审核标志时将从ie界面取汉字改为取标志
				if ((tmpTOweFlag == "0") && (TOweFlag == "0")) {
					if (flag) {
						document.getElementById('TDrugRetRequz' + row).innerText = document.getElementById('TCanReturnNumz' + row).innerText;
					} else {
						document.getElementById('TDrugRetRequz' + row).innerText = "";
					}
				}
			}
		} else {
			//主医嘱勾选子医嘱必须跟着勾选
			if ((TLinkOrder == "") && (tmpTLinkOrder == TOrderRowid) && ((ExecutFlagDesc != "已审核"))) {
				var sSelectRow = document.getElementById('Tselectz' + row);
				sSelectRow.checked = flag;
				//modify 2014-06-10 取欠药标志和审核标志时将从ie界面取汉字改为取标志
				if ((tmpTOweFlag == "0") && (TOweFlag == "0")) {
					if (flag) {
						document.getElementById('TDrugRetRequz' + row).innerText = document.getElementById('TCanReturnNumz' + row).innerText;
					} else {
						document.getElementById('TDrugRetRequz' + row).innerText = "";
					}
				}
			}
		}
		if ((tmpTLinkOrder != "") && ((tmpTLinkOrder == TOrderRowid) || ((tmpTLinkOrder == TLinkOrder) && (TLinkOrder != "")))) {
			if ((TOweFlag == "0") || (ExecutFlagDesc == " ") || (ExecutFlagDesc == "已审核")) {
				var TOrderTypeObj = document.getElementById('TOrderTypez' + row);
				var TOrderType = TOrderTypeObj.value;
				if ((flag) && (TOrderType != "R")) {
					if ((TDrugRetRequObj.value == "") || (TDrugRetRequObj.value == "undefined") || (TDrugRetRequObj.value == " ")) {
						TDrugRetRequObj.innerText = document.getElementById('TCanReturnNumz' + row).innerText;
					}
				} else {
					//TDrugRetRequObj.innerText = "";
				}
			}
		}
		if ((TLinkOrder != "") && (TLinkOrder == TMPOrderRowid)) {
			if ((TOweFlag == "0") || (ExecutFlagDesc == " ") || (ExecutFlagDesc == "已审核")) {
				var TOrderTypeObj = document.getElementById('TOrderTypez' + row);
				var TOrderType = TOrderTypeObj.value;
				if ((flag) && (TOrderType != "R")) {
					if ((TDrugRetRequObj.value == "") || (TDrugRetRequObj.value == "undefined") || (TDrugRetRequObj.value == " ")) {
						TDrugRetRequObj.innerText = document.getElementById('TCanReturnNumz' + row).innerText;
					}
				} else {
					//TDrugRetRequObj.innerText = "";
				}
			}
		}
		//2016-02-04 同一处方的欠药必须同时
		var tmpPrescNo = document.getElementById('PrescNoz' + row).innerText;
		var tmpTOweFlag = document.getElementById('TOweFlagz' + row).value;
		var tmpTCanReturnNum = document.getElementById('TCanReturnNumz' + row).innerText;
		if ((tmpTCanReturnNum == "") || (tmpTCanReturnNum == " ")) {
			tmpTCanReturnNum = 0;
		}
		var tmpTphdi = document.getElementById('Tphdiz' + row).value;
		if (tmpTphdi == " ") {
			tmpTphdi = "";
		}
		//if (((tmpTOweFlag == "0")||(tmpTOweFlag == 0)) && ((TOweFlag == "0") || (TOweFlag == 0)))
		if (((tmpTOweFlag == "0") || (tmpTOweFlag == 0)) && (DrugIsOweFlag == "Y")) {
			//欠药同处方不能分开退
			if ((PrescNo != "") && (tmpPrescNo == PrescNo) && (eval(tmpTCanReturnNum) != 0) && (tmpOrderType == "R") && (tmpTphdi != "")) {
				var sSelectRow = document.getElementById('Tselectz' + row);
				sSelectRow.checked = flag;
				if (flag) {
					document.getElementById('TDrugRetRequz' + row).innerText = document.getElementById('TCanReturnNumz' + row).innerText;
				} else {
					document.getElementById('TDrugRetRequz' + row).innerText = "";
				}
			}
		}
	}
	//Lid 2017-04-20 新版申请单医嘱，如果没有选择部位不能做退费审核
	var orderRowId = DHCWeb_GetColumnData("TOrderRowid",selectrow);
	var refundRepPart = DHCWeb_GetColumnData("RefundRepPart",selectrow);
	var isAppRepFlag = tkMakeServerCall("web.UDHCJFPRICE", "IsAppRepOrder", orderRowId);
	if((isAppRepFlag == "Y")&&(refundRepPart == "")){
		alert("申请单医嘱需必须先选择部位");
		DHCWeb_SetColumnData("Tselect", selectrow, false);
	}
}

function GetAuditInfo() {
	var myAuditing = parent.frames["udhcOPRefund_Auditing"].window;
	var DrugRetReasonDr = parent.frames["udhcOPRefund_Auditing"].document.getElementById("RefundReason").value;
	if (DrugRetReasonDr == " ") {
		DrugRetReasonDr = "";
	}
	if (DrugRetReasonDr == "0") {
		DrugRetReasonDr = "";
	}
	var StopOrderstr = "";
	var ToBillOrderstr = "";
	var myAuditAry = new Array();
	var myInvAry = new Array();
	var InvOEAry = new Array();
	var myIdx = 0;
	var mystr = "";
	var AllExecute = 1;
	var myUser = session['LOGON.USERID'];
	var objtbl = document.getElementById('tudhcOPRefund_AuditOrder');
	var Rows = objtbl.rows.length;
	for (var j = 1; j < Rows; j++) {
		var sExcute = document.getElementById('TExcuteflagz' + j).innerText;
		if (sExcute == 0) {
			AllExecute = 0;
		}
		var TSelect = document.getElementById("Tselectz" + j);
		var myObj = document.getElementById('TOrderRowidz' + j);
		var InvDr = document.getElementById('InvPrtDrz' + j).innerText;
		var sOrderRowid = DHCWebD_GetCellValue(myObj);
		var mySelFlag = DHCWebD_GetCellValue(TSelect);
		var TMatDispGrant = DHCWeb_GetColumnData('TMatDispGrant', j); //+2017-08-28 ZhYW  物资走发放流程标志
		//2016-02-03 chenxi 重新判断是否审核该医嘱
		var CheckFlag = false;
		if ((m_AppComFlag == "2") || (m_AppComFlag == 2) || (m_AppComFlag == "1") || (m_AppComFlag == 1)) {
			if (mySelFlag) {
				CheckFlag = true;
			} else {
				CheckFlag = false;
			}
		} else {
			if ((mySelFlag) && (!TSelect.disabled)) {
				CheckFlag = true;
			} else {
				CheckFlag = false;
			}
		}
		if (CheckFlag) {
			var myary = new Array();
			myary[0] = "";
			myary[3] = sOrderRowid;
			myary[4] = myUser;
			myary[5] = "";
			myary[7] = "";        //IOA_AuRefundQty
			myary[8] = "P";       //IOA_Flag
			//moidfy 2014-04-16 增加药品退药申请原因和退药申请数量
			var TDrugRetRequObj = document.getElementById('TDrugRetRequz' + j);
			var TDrugRetRequ = TDrugRetRequObj.value;
			if (TDrugRetRequ == "") {
				TDrugRetRequ = TDrugRetRequObj.innerText;
			}
			if ((TDrugRetRequ == "") || (TDrugRetRequ == " ")) {
				TDrugRetRequ = 0;
			}
			if (isNaN(TDrugRetRequ)) {
				TDrugRetRequ = 0;
			}
			var TOrderTypeObj = document.getElementById('TOrderTypez' + j);
			var TOrderType = TOrderTypeObj.value;
			var ExecutFlagDesc = document.getElementById('ExecutFlagDescz' + j).innerText;
			//if ((TDrugRetRequ == 0) && (TOrderType != "R")) {
			if ((TDrugRetRequ == 0) && (TOrderType != "R") && (TMatDispGrant == 'Y')) {    //2017-06-28 ZhYW
				var ordername = document.getElementById('TOrderz' + j).innerText;
				alert(ordername + "申请数量不能为0或空!");
				return "DrugReaNull";
			}
			//if ((TDrugRetRequ == 0) && (ExecutFlagDesc == "已发药")) {
			if ((TDrugRetRequ == 0) && ((ExecutFlagDesc == "已发药") || (ExecutFlagDesc == '已发放'))) {    //2017-06-28 ZhYW
				var ordername = document.getElementById('TOrderz' + j).innerText;
				alert(ordername + "申请数量不能为0或空!");
				return "DrugReaNull";
			}
			var TReturnQtyObj = document.getElementById('TReturnQtyz' + j);
			var TReturnQty = TReturnQtyObj.innerText;
			if (TReturnQty == " ") {
				TReturnQty = 0;
			}
			if (isNaN(TReturnQty)) {
				TReturnQty = 0;
			}
			var Tphdi = document.getElementById('Tphdiz' + j).value;
			var ExecutFlagDesc = document.getElementById('ExecutFlagDescz' + j).innerText;
			/*
			var TDrugRetReasonDrObj = document.getElementById('TDrugRetReasonDrz' + j);
			var TDrugRetReasonDr = TDrugRetReasonDrObj.value;
			if (TDrugRetReasonDr == " "){
				TDrugRetReasonDrObj = "";
			}
			*/
			var TOrderTypeObj = document.getElementById('TOrderTypez' + j);
			var TOrderType = TOrderTypeObj.value;
			//modify 2014-06-10 取欠药标志和审核标志时将从ie界面取汉字改为取标志
			var TOweFlag = document.getElementById('TOweFlagz' + j).value;
			if (TOrderType == "R") {
				//if(ExecutFlagDesc == "欠药")
				if (TOweFlag == "0") {
					TDrugRetRequ = document.getElementById('TDrugRetRequz' + j).innerText;
				}
				myary[9] = TDrugRetRequ;         //申请退药数量
				myary[10] = DrugRetReasonDr;     //申请退药原因
				myary[11] = Tphdi;               //药品子表id
				myary[12] = TOweFlag;            //欠药标志
				if ((TDrugRetRequ != "") && (DrugRetReasonDr == "") && (Tphdi != "")) {
					//alert("退药原因不能为空!!");
					//return "DrugReaNull";
				}
				if (((TReturnQty == "") || (TReturnQty == 0) || (TReturnQty == "0")) && (DrugRetReasonDr == "") && (Tphdi != "")) {
					//alert("退药原因不能为空!!");
					//return "DrugReaNull";
				}
			} else {
				myary[9] = TDrugRetRequ;
				myary[10] = "";
				myary[11] = "";
				myary[12] = "";
			}
			//Lid 2017-03-15 添加检查申请单退费部位
			var refundRepPart = DHCWeb_GetColumnData("RefundRepPart", j);
			myary[13] = refundRepPart;			
			var mystr = myary.join("^");
			//add  by zhl  090704  xiangya S
			if ((!myInvAry[InvDr]) && (myInvAry[InvDr] != 0)) {
				Auditid = myAuditAry.length;
				myAuditAry[Auditid] = new Array();
				myInvAry[InvDr] = Auditid;
			}
			index = myInvAry[InvDr];
			myAuditAry[index][myAuditAry[index].length] = InvDr + "##" + mystr;
			if (!InvOEAry[index]) {
				InvOEAry[index] = sOrderRowid;
			} else {
				if (InvOEAry[index].indexOf(sOrderRowid) == -1) {
					InvOEAry[index] = InvOEAry[index] + "^" + sOrderRowid;
				}
			}
		}
	}
	var myAuditInfo = "";
	for (i = 0; i < myAuditAry.length; i++) {
		for (j = 0; j < myAuditAry[i].length; j++) {
			DataStr = myAuditAry[i][j].split("##");
			if (j == 0) {
				if (myAuditInfo == "") {
					myAuditInfo = DataStr[0] + "@@" + DataStr[1];
				} else {
					myAuditInfo = myAuditInfo + String.fromCharCode(3) + DataStr[0] + "@@" + DataStr[1];
				}
			} else {
				myAuditInfo = myAuditInfo + String.fromCharCode(2) + DataStr[1];
			}
		}
		myAuditInfo = myAuditInfo + "@@" + InvOEAry[i];
	}
	//add  by zhl  090704  xiangya  E
	return myAuditInfo;
}

function DrugRetReasononchange(e) {
	var Row = GetEventRow(e);
	var TDrugRetReasonObj = websys_getSrcElement(e);
	var selIndex = TDrugRetReasonObj.selectedIndex;
	var DrugRetReasonRowid = "";
	if (selIndex != -1) {
		DrugRetReasonRowid = TDrugRetReasonObj.options[selIndex].value;
	}
	var tabOPList = document.getElementById('tudhcOPRefund_AuditOrder');
	var rows = tabOPList.rows.length;
	var selectrow = DHCWeb_GetRowIdx(window);
	var TDrugRetReasonDrobj = document.getElementById('TDrugRetReasonDrz' + selectrow);
	TDrugRetReasonDrobj.value = DrugRetReasonRowid;
}

function lookuphandler(me) {
	if (evtName == 'TDrugRetReason') {
		window.clearTimeout(evtTimer);
		evtTimer = '';
		evtName = '';
	}
	var arrId = me.id.split("z");
	var Row = arrId[arrId.length - 1];
	FocusRow = Row;
	var type = websys_getType(e);
	var key = websys_getKey(e);
	if ((type == 'click') || ((type == 'keydown') && (key == 13))) {
		var Myobj = document.getElementById('Myid');
		var CommentID = Myobj.value;
		var url = 'websys.lookup.csp';
		url += '?ID=ld"+CommentID+"iTDrugRetReason&CONTEXT=Kweb.DHCOPBillRefundRequestNew:FindDrugReturnRea&TLUDESC=' + '2aê?';
		url += "&TLUJSF=LookUpDrugReason";
		/*
		var obj = document.getElementById('GuserGroup');
		if (obj) {
			url += "&P1=" + websys_escape(obj.value);
		}
		var obj = document.getElementById('TPayMz'+Row);
		if (obj) {
			url += "&P2=" + websys_escape(obj.value);
		}
		*/
		websys_lu(url, 1, '');
		return websys_cancel();
	}
}

function LookUpDrugReason(value) {
	var tmp = value.split("^");
	document.getElementById('TDrugRetReasonz' + FocusRow).value = tmp[0];
	document.getElementById('TDrugRetReasonDrz' + FocusRow).value = tmp[1];
}

function GetEventRow(e) {
	var obj = websys_getSrcElement(e);
	var Id = obj.id;
	var arrId = Id.split("z");
	var Row = arrId[arrId.length - 1];
	var TDSrc = websys_getParentElement(obj);
	var TRSrc = websys_getParentElement(TDSrc);
	FocusRowIndex = TRSrc.rowIndex;
	return Row
}

function DrugRetRequNum() {
	var key = websys_getKey(e);
	if (key == 13) {
		var eSrc = window.event.srcElement;
		var ColName1 = eSrc.name.split("z");
		var selectrow = ColName1[1];
		var TOrderRowidObj = document.getElementById('TOrderRowidz' + selectrow);
		var TOrderRowid = TOrderRowidObj.innerText;
		if ((TOrderRowid == " ") || (TOrderRowid == "")) {
			alert("请选择要申请的医嘱!!");
			return;
		}
		var TselectSelRowObj = document.getElementById('Tselectz' + selectrow);
		var TDrugRetRequObj = document.getElementById('TDrugRetRequz' + selectrow);
		var DrugRetRequ = TDrugRetRequObj.value;
		if ((DrugRetRequ == "") || (DrugRetRequ == " ")) {
			TDrugRetRequObj.innerText = "";
			TselectSelRowObj.checked = false;
			websys_setfocus('TDrugRetRequ');
			alert("申请的退费数量不能为空!!");
			return;
		}
		if (isNaN(DrugRetRequ)) {
			TDrugRetRequObj.innerText = "";
			TselectSelRowObj.checked = false;
			websys_setfocus('TDrugRetRequ');
			alert("申请的退费数量必须为数字!!");
			return;
		}
		//是否为药品医嘱标志
		var SelRowObj = document.getElementById('TOrderTypez' + selectrow);
		var TOrderType = SelRowObj.value;
		//已退药数量
		var SelRowObj = document.getElementById('TReturnQtyz' + selectrow);
		var TReturnQty = SelRowObj.innerText;
		if ((TReturnQty == "") || (TReturnQty == " ")) {
			TReturnQty = 0;
		}
		if (isNaN(TReturnQty)) {
			TReturnQty = 0;
		}
		//已执行数量或已发药数量
		var SelRowObj = document.getElementById('TOEORDExecQtyz' + selectrow);
		var TOEORDExecQty = SelRowObj.innerText;
		if ((TOEORDExecQty == "") || (TOEORDExecQty == " ")) {
			TOEORDExecQty = 0;
		}
		if (isNaN(TOEORDExecQty)) {
			TOEORDExecQty = 0;
		}
		var SelRowObj = document.getElementById('TExcuteflagz' + selectrow);
		var TExcuteflag = SelRowObj.value;
		var SelRowObj = document.getElementById('TCanReturnNumz' + selectrow);
		var TCanReturnNum = SelRowObj.innerText;
		if ((TCanReturnNum == "") || (TCanReturnNum == " ")) {
			TCanReturnNum = 0;
		}
		if (isNaN(TCanReturnNum)) {
			TCanReturnNum = 0;
		}
		if (TOrderType == "R") {
			if ((eval(TOEORDExecQty) == 0) && (TExcuteflag == 1)) {
				//alert("发药数量不对请核实!!");
				//TDrugRetRequObj.innerText = "";
				//return;
			}
			if ((eval(TCanReturnNum) == 0)) {
				TselectSelRowObj.checked = false;
				alert("可退药数量为0不允许申请退药!!");
				TDrugRetRequObj.innerText = "";
				return;
			}
			//已申请退药数量
			var SelRowObj = document.getElementById('TDrugRetALreadyz' + selectrow);
			var TDrugRetALready = SelRowObj.innerText;
			if ((TDrugRetALready == "") || (TDrugRetALready == " ")) {
				TDrugRetALready = 0;
			}
			if (isNaN(TDrugRetALready)) {
				TDrugRetALready = 0
			}
			var SelRowObj = document.getElementById('TOrderQtyz' + selectrow);
			var TOrderQty = SelRowObj.innerText;
			if ((TOrderQty == "") || (TOrderQty == " ")) {
				TOrderQty = 0;
			}
			if (isNaN(TOrderQty)) {
				TOrderQty = 0;
			}
			var CanRetDurgNum = eval(TOrderQty) - eval(TDrugRetALready) - eval(TReturnQty)
			if ((eval(CanRetDurgNum)) < (eval(DrugRetRequ))) {
				alert("申请退费数量不能大于可申请退费数量!!");
				TDrugRetRequObj.innerText = ""
				TselectSelRowObj.checked = false;
				//websys_setfocus('TDrugRetRequ');
				return;
			}
		} else {
			if (TExcuteflag == 1) {
				alert("医嘱已执行不允许申请退费!!");
				return;
			} else {
				var AllowFlag = tkMakeServerCall("web.DHCOPBillRefundRequestNew", "GetOrdAllowPartRequest", TOrderRowid);
				if (AllowFlag != "Y") {
					alert("此医嘱不允许部分退费!!");
					return;
				}
				var SelRowObj = document.getElementById('TOrderQtyz' + selectrow);
				var TOrderQty = SelRowObj.innerText;
				if ((TOrderQty == "") || (TOrderQty == " ")) {
					TOrderQty = 0;
				}
				if (isNaN(TOrderQty)) {
					TOrderQty = 0;
				}
				var TCanReturnNum = eval(TOrderQty) - eval(TReturnQty);
				if ((eval(TCanReturnNum)) < (eval(DrugRetRequ))) {
					alert("申请退费数量不能大于可退数量");
					TDrugRetRequObj.innerText = "";
					TselectSelRowObj.checked = false;
					return;
				}
			}
		}
		//if ((eval(DrugRetRequ) != 0) && (TOrderType == "R"))
		if (eval(DrugRetRequ) != 0) {
			TselectSelRowObj.checked = true;
			//var obj = 'TDrugRetReasonz' + selectrow;
			//websys_setfocus(obj);
		}
	}
}

function DrugRetRequNum1(Me) {
	var eSrc = window.event.srcElement;
	var ColName1 = eSrc.name.split("z");
	var selectrow = ColName1[1];
	var TOrderRowidObj = document.getElementById('TOrderRowidz' + selectrow);
	var TOrderRowid = TOrderRowidObj.innerText;
	/*
	if ((TOrderRowid == " ") || (TOrderRowid=="")){
		alert("请选择要申请的医嘱!!");
		return;
	}
	*/
	var TselectSelRowObj = document.getElementById('Tselectz' + selectrow);
	var TDrugRetRequObj = document.getElementById('TDrugRetRequz' + selectrow);
	var DrugRetRequ = TDrugRetRequObj.value;
	if ((DrugRetRequ == "") || (DrugRetRequ == " ")) {
		TDrugRetRequObj.innerText = "";
		TselectSelRowObj.checked = false;
		var Selectflag = false;
		CanceOweLink(selectrow, Selectflag);
		websys_setfocus('TDrugRetRequ');
		alert("申请的退费数量不能为空!!");
		return;
	}
	if (isNaN(DrugRetRequ)) {
		TDrugRetRequObj.innerText = "";
		TselectSelRowObj.checked = false;
		var Selectflag = false;
		CanceOweLink(selectrow, Selectflag);
		websys_setfocus('TDrugRetRequ');
		alert("申请的退费数量必须为数字!!");
		return;
	}
	//是否为药品医嘱标志
	var SelRowObj = document.getElementById('TOrderTypez' + selectrow);
	var TOrderType = SelRowObj.value;
	//已退药数量
	var SelRowObj = document.getElementById('TReturnQtyz' + selectrow);
	var TReturnQty = SelRowObj.innerText;
	if ((TReturnQty == "") || (TReturnQty == " ")) {
		TReturnQty = 0;
	}
	if (isNaN(TReturnQty)) {
		TReturnQty = 0;
	}
	//已执行数量或已发药数量
	var SelRowObj = document.getElementById('TOEORDExecQtyz' + selectrow);
	var TOEORDExecQty = SelRowObj.innerText;
	if ((TOEORDExecQty == "") || (TOEORDExecQty == " ")) {
		TOEORDExecQty = 0;
	}
	if (isNaN(TOEORDExecQty)) {
		TOEORDExecQty = 0;
	}
	var SelRowObj = document.getElementById('TExcuteflagz' + selectrow);
	var TExcuteflag = SelRowObj.value;
	var SelRowObj = document.getElementById('TCanReturnNumz' + selectrow);
	var TCanReturnNum = SelRowObj.innerText;
	if ((TCanReturnNum == "") || (TCanReturnNum == " ")) {
		TCanReturnNum = 0;
	}
	if (isNaN(TCanReturnNum)) {
		TCanReturnNum = 0;
	}
	var TMatDispGrant = DHCWeb_GetColumnData('TMatDispGrant', selectrow); //+2017-08-28 ZhYW  物资走发放流程标志
	if (TOrderType == "R") {
		if ((eval(TOEORDExecQty) == 0) && (TExcuteflag == 1)) {
			/*
			alert("发药数量不对请核实!!");
			TDrugRetRequObj.innerText = "";
			return;
			*/
		}
		if ((eval(TCanReturnNum) == 0)) {
			TselectSelRowObj.checked = false;
			TDrugRetRequObj.innerText = "";
			var Selectflag = false;
			CanceOweLink(selectrow, Selectflag);
			return;
		}
		//已申请退药数量
		var SelRowObj = document.getElementById('TDrugRetALreadyz' + selectrow);
		var TDrugRetALready = SelRowObj.innerText;
		if ((TDrugRetALready == "") || (TDrugRetALready == " ")) {
			TDrugRetALready = 0;
		}
		if (isNaN(TDrugRetALready)) {
			TDrugRetALready = 0;
		}
		var SelRowObj = document.getElementById('TOrderQtyz' + selectrow);
		var TOrderQty = SelRowObj.innerText;
		if ((TOrderQty == "") || (TOrderQty == " ")) {
			TOrderQty = 0;
		}
		if (isNaN(TOrderQty)) {
			TOrderQty = 0;
		}
		var CanRetDurgNum = eval(TOrderQty) - eval(TDrugRetALready) - eval(TReturnQty);
		if ((eval(CanRetDurgNum)) < (eval(DrugRetRequ))) {
			alert("申请数量不能大于可申请数量!!");
			TDrugRetRequObj.innerText = "";
			TselectSelRowObj.checked = false;
			websys_setfocus('TDrugRetRequ');
			return;
		}
	} else {
		//+2017-06-23 ZhYW
		//if (TExcuteflag == 1) {
		if ((TMatDispGrant != 'Y') && (TExcuteflag == 1)){
			alert("该医嘱已被执行,请撤销执行后再退费!!");
			return;
		} else {
			var AllowFlag = tkMakeServerCall("web.DHCOPBillRefundRequestNew", "GetOrdAllowPartRequest", TOrderRowid);
			if (AllowFlag != "Y") {
				alert("该医嘱不允许部分退!!");
				return;
			}
			var SelRowObj = document.getElementById('TOrderQtyz' + selectrow);
			var TOrderQty = SelRowObj.innerText;
			if ((TOrderQty == "") || (TOrderQty == " ")) {
				TOrderQty = 0;
			}
			if (isNaN(TOrderQty)) {
				TOrderQty = 0;
			}
			var TCanReturnNum = eval(TOrderQty) - eval(TReturnQty);
			if ((eval(TCanReturnNum)) < (eval(DrugRetRequ))) {
				TDrugRetRequObj.innerText = "";
				TselectSelRowObj.checked = false;
				alert("申请数量不能大于医嘱数量");
				//websys_setfocus('TDrugRetRequ');
				return;
			}
		}
	}

	//if ((eval(DrugRetRequ) != 0) && (TOrderType == "R"))
	if (eval(DrugRetRequ) != 0) {
		TselectSelRowObj.checked = true;
		/*
		var obj = 'TDrugRetReasonz'+selectrow;
		websys_setfocus(obj);
		*/
	}
}

///LiangQiang
///写入数量后自动写入金额
function WriteRetMoney(e) {
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	var selindex = obj.id;
	var ss = selindex.split("z");
	var tabOPList = document.getElementById('tudhcOPRefund_AuditOrder');
	var rows = tabOPList.rows.length;
	var selectrow = DHCWeb_GetRowIdx(window);
	if (ss.length > 0) {
		if (ss[0] == "TDrugRetRequ") {
			var TselectSelRowObj = document.getElementById('Tselectz' + selectrow);
			var TOrdStopStatusObj = document.getElementById('TOrdStopStatusz' + selectrow);
			var TOrdStopStatus = TOrdStopStatusObj.value;
			if (TOrdStopStatus == " ") {
				TOrdStopStatus == "";
			}
			if (TOrdStopStatus != "D") {
				if ((m_AppComFlag == "2") || (m_AppComFlag == 2) || (m_AppComFlag == "1") || (m_AppComFlag == 1)) {
					alert("停医嘱后才能申请数量!!");
					TselectSelRowObj.checked = false;
					//2016-03-14 将欠药医嘱过滤
					var Selectflag = false;
					CanceOweLink(selectrow, Selectflag);
					return;
				}
			}
			var TOrderRowidObj = document.getElementById('TOrderRowidz' + selectrow);
			var TOrderRowid = TOrderRowidObj.innerText;
			var TDrugRetRequObj = document.getElementById('TDrugRetRequz' + selectrow);
			var DrugRetRequ = TDrugRetRequObj.value;
			var TMatDispGrant = DHCWeb_GetColumnData('TMatDispGrant', selectrow); //+2017-08-28 ZhYW  物资走发放流程标志
			if (!isPositiveNum(DrugRetRequ)) {
				alert("请输入整数!");
				if ((m_AppComFlag != "2") && (m_AppComFlag != 2) && (m_AppComFlag != "1") && (m_AppComFlag != 1) && (TOrdStopStatus != "D")) {
					TselectSelRowObj.checked = false;
					var Selectflag = false;
					CanceOweLink(selectrow, Selectflag);
				}
				//SelectRowHandler();
				return;
			}
			if ((DrugRetRequ == "") || (DrugRetRequ == " ")) {
				TDrugRetRequObj.innerText = "";
				if ((m_AppComFlag != "2") && (m_AppComFlag != 2) && (m_AppComFlag != "1") && (m_AppComFlag != 1) && (TOrdStopStatus != "D")) {
					TselectSelRowObj.checked = false;
					var Selectflag = false;
					CanceOweLink(selectrow, Selectflag);
				}
				websys_setfocus('TDrugRetRequ');
				TselectSelRowObj.checked = false;
				alert("输入有误!!");
				SelectRowHandler();
				return;
			}
			if (isNaN(DrugRetRequ)) {
				TDrugRetRequObj.innerText = "";
				if ((m_AppComFlag != "2") && (m_AppComFlag != 2) && (m_AppComFlag != "1") && (m_AppComFlag != 1) && (TOrdStopStatus != "D")) {
					TselectSelRowObj.checked = false;
					var Selectflag = false;
					CanceOweLink(selectrow, Selectflag);
				}
				websys_setfocus('TDrugRetRequ');
				TselectSelRowObj.checked = false;
				alert("输入有误!!");
				SelectRowHandler();
				return;
			}
			var SelRowObj = document.getElementById('TOrderTypez' + selectrow);
			var TOrderType = SelRowObj.value;
			var SelRowObj = document.getElementById('TReturnQtyz' + selectrow);
			var TReturnQty = SelRowObj.innerText;
			if ((TReturnQty == "") || (TReturnQty == " ")) {
				TReturnQty = 0;
			}
			if (isNaN(TReturnQty)) {
				TReturnQty = 0;
			}
			var SelRowObj = document.getElementById('TOEORDExecQtyz' + selectrow);
			var TOEORDExecQty = SelRowObj.innerText;
			if ((TOEORDExecQty == "") || (TOEORDExecQty == " ")) {
				TOEORDExecQty = 0;
			}
			if (isNaN(TOEORDExecQty)) {
				TOEORDExecQty = 0;
			}
			var SelRowObj = document.getElementById('TExcuteflagz' + selectrow);
			var TExcuteflag = SelRowObj.value;
			var SelRowObj = document.getElementById('TCanReturnNumz' + selectrow);
			var TCanReturnNum = SelRowObj.innerText;
			if ((TCanReturnNum == "") || (TCanReturnNum == " ")) {
				TCanReturnNum = 0;
			}
			if (isNaN(TCanReturnNum)) {
				TCanReturnNum = 0;
			}
			if (TOrderType == "R") {
				if ((eval(TOEORDExecQty) == 0) && (TExcuteflag == 1)) {
				}
				if ((eval(TCanReturnNum) == 0)) {
					TselectSelRowObj.checked = false;
					var Selectflag = false;
					CanceOweLink(selectrow, Selectflag);
					TDrugRetRequObj.innerText = "";
					return;
				}
				var SelRowObj = document.getElementById('TDrugRetALreadyz' + selectrow);
				var TDrugRetALready = SelRowObj.innerText;
				if ((TDrugRetALready == "") || (TDrugRetALready == " ")) {
					TDrugRetALready = 0;
				}
				if (isNaN(TDrugRetALready)) {
					TDrugRetALready = 0;
				}
				var SelRowObj = document.getElementById('TOrderQtyz' + selectrow);
				var TOrderQty = SelRowObj.innerText;
				if ((TOrderQty == "") || (TOrderQty == " ")) {
					TOrderQty = 0;
				}
				if (isNaN(TOrderQty)) {
					TOrderQty = 0;
				}
				var SelRowObj = document.getElementById('TCanReturnNumz' + selectrow);
				var TCanReturnNum = SelRowObj.innerText;
				if ((TCanReturnNum == "") || (TCanReturnNum == " ")) {
					TCanReturnNum = 0;
				}
				if (isNaN(TCanReturnNum)) {
					TCanReturnNum = 0;
				}
				//var CanRetDurgNum = eval(TOrderQty)-eval(TDrugRetALready)-eval(TReturnQty)-eval(TOEORDExecQty);
				if ((eval(TCanReturnNum)) < (eval(DrugRetRequ))) {
					alert("申请数量不能大于可申请数量!!");
					TDrugRetRequObj.innerText = "";
					if ((m_AppComFlag != "2") && (m_AppComFlag != 2) && (m_AppComFlag != "1") && (m_AppComFlag != 1) && (TOrdStopStatus != "D")) {
						TselectSelRowObj.checked = false;
						var Selectflag = false;
						CanceOweLink(selectrow, Selectflag);
					}
					websys_setfocus('TDrugRetRequ');
					SelectRowHandler();
					return;
				}
			} else {
				//+2017-06-23 ZhYW     
				//if (TExcuteflag == 1) {
				if ((TMatDispGrant != 'Y') && (TExcuteflag == 1)){
					alert("该医嘱已被执行,请撤销执行后再退费!!");
					return;
				} else {
					var AllowFlag = tkMakeServerCall("web.DHCOPBillRefundRequestNew", "GetOrdAllowPartRequest", TOrderRowid);
					if (AllowFlag != "Y") {
						alert("该医嘱不允许部分退!!");
						if ((m_AppComFlag != "2") && (m_AppComFlag != 2) && (m_AppComFlag != "1") && (m_AppComFlag != 1) && (TOrdStopStatus != "D")) {
							TselectSelRowObj.checked = false;
							var Selectflag = false;
							CanceOweLink(selectrow, Selectflag);
						}
						return;
					}
					var SelRowObj = document.getElementById('TOrderQtyz' + selectrow);
					var TOrderQty = SelRowObj.innerText;
					if ((TOrderQty == "") || (TOrderQty == " ")) {
						TOrderQty = 0;
					}
					if (isNaN(TOrderQty)) {
						TOrderQty = 0;
					}
					var SelRowObj = document.getElementById('TOEORDExecQtyz' + selectrow);
					var OEORDExecQty = SelRowObj.innerText;
					if ((OEORDExecQty == "") || (OEORDExecQty == " ")) {
						OEORDExecQty = 0;
					}
					if (isNaN(OEORDExecQty)) {
						OEORDExecQty = 0;
					}
					var SelRowObj = document.getElementById('TDrugRetALreadyz' + selectrow);
					var TDrugRetALready = SelRowObj.innerText;
					if ((TDrugRetALready == "") || (TDrugRetALready == " ")) {
						TDrugRetALready = 0;
					}
					if (isNaN(TDrugRetALready)) {
						TDrugRetALready = 0;
					}
					var TCanReturnNum = eval(TOrderQty) - eval(TReturnQty) - eval(OEORDExecQty) - eval(TDrugRetALready);
					if ((eval(TCanReturnNum)) < (eval(DrugRetRequ))) {
						TDrugRetRequObj.innerText = "";
						if ((m_AppComFlag != "2") && (m_AppComFlag != 2) && (m_AppComFlag != "1") && (m_AppComFlag != 1) && (TOrdStopStatus != "D")) {
							TselectSelRowObj.checked = false;
							var Selectflag = false;
							CanceOweLink(selectrow, Selectflag);
						}
						alert("申请数量不能大于可申请数量");
						SelectRowHandler();
						//websys_setfocus('TDrugRetRequ');
						return;
					}
				}
			}
			//if ((eval(DrugRetRequ) != 0)&&(TOrderType == "R"))
			if (eval(DrugRetRequ) != 0) {
				TselectSelRowObj.checked = true;
				/*
				var obj = 'TDrugRetReasonz' + selectrow;
				websys_setfocus(obj);
				*/
			}
			SelectRowHandler();
		}
	}
}

function checkreqqty() {
	var objtbl = document.getElementById('tudhcOPRefund_AuditOrder');
	var rows = objtbl.rows.length;
	for (var j = 1; j < rows; j++) {
		var TSelect = document.getElementById("Tselectz" + j);
		var orderid = document.getElementById('TOrderRowidz' + j).innerText;
		var ExecutFlagDesc = document.getElementById('ExecutFlagDescz' + j).innerText;
		var ordername = document.getElementById('TOrderz' + j).innerText;
		if ((TSelect.checked) && (!TSelect.disabled)) {
			if ((ExecutFlagDesc == "已发药")) {
				var oexeqty = document.getElementById('TOEORDExecQtyz' + j).innerText;
				if (ExecutFlagDesc == "已发药") {
					var reqty = document.getElementById('TDrugRetRequz' + j).value;
				} else {
					var reqty = document.getElementById('TDrugRetRequz' + j).innerText;
				}
				//modify 2014-06-04 多次发药时不能同时申请退药
				/*
				var reqty = 0;
				for (var i = 1; i < rows; i++) {					
					var tmpTSelect = document.getElementById("Tselectz"+i);
					if ((tmpTSelect.checked) && (!tmpTSelect.disabled)) {						
						var tmporderid = document.getElementById('TOrderRowidz' + i).value;
						if(orderid == tmporderid) {
							var tmpExecutFlagDesc = document.getElementById('ExecutFlagDescz' + i).innerText;
							if(tmpExecutFlagDesc == "已发药"){
								var tmpreqty = document.getElementById('TDrugRetRequz' + i).value;
							} else {
								var tmpreqty = document.getElementById('TDrugRetRequz' + i).innerText;
							}
							reqty = Number(reqty) + Number(tmpreqty);
						}
					}
				}
				*/
				//var qty = tkMakeServerCall("web.DHCOutPhDisp","getDspQty",orderid);
				var qty = document.getElementById('TCanReturnNumz' + j).innerText;
				if ((qty - oexeqty) < reqty) {
					alert(ordername + " 申请数量大于(可申请数量-执行数量)");
					return 1;
				}
			}
		}
	}
	return 0;
}

function AllSelect_OnClick() {
	var mycheck = DHCWebD_GetObjValue("AllSelect");
	SelectAll(mycheck);
}

/**
 * Creator: ZhYW
 * CreatDate: 2015-10-26
 * Description: 给列表复选框赋值
 */
function SelectAll(myCheck) {
	var tabOPList = document.getElementById('tudhcOPRefund_AuditOrder');
	var rows = tabOPList.rows.length;
	for (var i = 1; i < rows; i++) {
		var sSelect = document.getElementById('Tselectz' + i);
		if (!sSelect.disabled) {
			DHCWebD_SetListValueA(sSelect, myCheck);
			SeqNoLinkNEW(i);
			CalCurRefund();
		}
	}
}

function SeqNoLinkNEW(selectrow) {
	var tabOPList = document.getElementById('tudhcOPRefund_AuditOrder');
	var rows = tabOPList.rows.length;
	var clickMySeqNo = document.getElementById('TOrdSeqNoz' + selectrow).value;
	var InvPrtDr = document.getElementById('InvPrtDrz' + selectrow).innerText;
	var sSelect = document.getElementById('Tselectz' + selectrow);
	var flag = sSelect.checked;
	var clickMySeqNoArr = clickMySeqNo.split(".");
	var ExecutFlagDesc = document.getElementById('ExecutFlagDescz' + selectrow).innerText;
	var PrescNo = document.getElementById('PrescNoz' + selectrow).innerText; //处方号
	var OrderDesc = document.getElementById('TOrderz' + selectrow).innerText;
	if ((ExecutFlagDesc == "已执行")) {
		alert("医嘱" + OrderDesc + "已被执行,请撤销执行后再退费");
		sSelect.checked = false;
		return;
	}
	var TExecutDesc = document.getElementById('TExecutDescz' + selectrow).innerText;
	if ((TExecutDesc == "已执行")) {
		alert("医嘱" + OrderDesc + "已被执行,请撤销执行后再退费");
		sSelect.checked = false;
		return;
	}
	var CanReturnNum = document.getElementById('TCanReturnNumz' + selectrow).innerText;
	if ((CanReturnNum == "") || (CanReturnNum == 0) || (CanReturnNum == "0") || (CanReturnNum == " ")) {
		alert("医嘱" + OrderDesc + "没有可申请数量！！！");
		sSelect.checked = false;
		return;
	}
	var TDrugRetRequObj = document.getElementById('TDrugRetRequz' + selectrow);
	var TDrugRetRequ = TDrugRetRequObj.value;
	if (TDrugRetRequ == " ") {
		TDrugRetRequ = "";
	}
	var DrugRetALreadyNum = document.getElementById('TDrugRetALreadyz' + selectrow).innerText;
	if (DrugRetALreadyNum == " ") {
		DrugRetALreadyNum = "";
	}
	if ((DrugRetALreadyNum != "") && (DrugRetALreadyNum != 0) && (DrugRetALreadyNum != "0")) {
		if (flag == true) {
			alert("请先取消申请后再重新申请!!");
			sSelect.checked = false;
			TDrugRetRequObj.value = "";
			TDrugRetRequ = "";
			return;
		}
	}
	var myQFOrder = new Array();
	var myQFOrdernum = new Array();
	var TMPmyQFOrder = "";          //欠费医嘱串
	var TOrderRowid = document.getElementById('TOrderRowidz' + selectrow).innerText;
	var TLinkOrder = document.getElementById('TLinkOrderz' + selectrow).innerText;
	var TDrugRetRequObj = document.getElementById('TDrugRetRequz' + selectrow);
	var TDrugRetRequ = TDrugRetRequObj.value;
	var ExecutFlagDesc = document.getElementById('ExecutFlagDescz' + selectrow).innerText;
	//modify 2014-06-10 取欠药标志和审核标志时将从ie界面取汉字改为取标志
	var TOweFlag = document.getElementById('TOweFlagz' + selectrow).value;
	var TOrderTypeObj = document.getElementById('TOrderTypez' + selectrow);
	var TOrderType = TOrderTypeObj.value;
	//if ((ExecutFlagDesc == "欠药")||(ExecutFlagDesc == " ")||(ExecutFlagDesc == "已审核"))
	if ((TOweFlag == "0") || (ExecutFlagDesc == " ") || (ExecutFlagDesc == "已审核")) {
		if ((flag) && (TOrderType != "R")) {
			TDrugRetRequObj.innerText = document.getElementById('TCanReturnNumz' + selectrow).innerText;
		} else {
			TDrugRetRequObj.innerText = "";
		}
	} else {
		if ((ExecutFlagDesc != "已发药") || (ExecutFlagDesc != "已发药")) {
			if (flag) {
				TDrugRetRequObj.value = document.getElementById('TCanReturnNumz' + selectrow).innerText;
			} else {
				TDrugRetRequObj.value = "";
			}
		}
	}
}

/// 是否为正整数
function isPositiveNum(s) { 
	var re = /^[0-9]*[1-9][0-9]*$/;
	return re.test(s);
}

document.body.onkeydown = function (event) {
	var eve = document.all ? window.event : event;
	if (eve.keyCode == 13) {
		return false;
	}
}

//2015-01-30 chenxi 欠药医嘱勾选去掉时如其对应的医嘱的发药是勾选的则不能退掉
function CheckDrugOwe(selectrow, flag) {
	var checkFlag = "Y";
	var tabOPList = document.getElementById('tudhcOPRefund_AuditOrder');
	var rows = tabOPList.rows.length;
	if (rows < 2) {
		return "N";
	}
	var InvPrtDr = document.getElementById('InvPrtDrz' + selectrow).innerText;
	var sSelect = document.getElementById('Tselectz' + selectrow);
	var TOrderRowid = document.getElementById('TOrderRowidz' + selectrow).innerText;
	var TLinkOrder = document.getElementById('TLinkOrderz' + selectrow).innerText;
	if (TLinkOrder == " ") {
		TLinkOrder = "";
	}
	if (TOrderRowid == " ") {
		TOrderRowid = "";
	}
	var TOweFlag = document.getElementById('TOweFlagz' + selectrow).value;
	var OrderTypeObj = document.getElementById('TOrderTypez' + selectrow);
	var OrderType = OrderTypeObj.value;
	var CheckNum = 0;
	if (((TOweFlag == "0") || (TOweFlag == 0)) && (OrderType == "R") && (TLinkOrder != "")) {
		for (var row = 1; row < rows; row++) {
			var TMPOrderRowid = document.getElementById('TOrderRowidz' + row).innerText;
			var TMPOweFlag = document.getElementById('TOweFlagz' + row).value;
			var tmpsSelect = document.getElementById('Tselectz' + row);
			var tmpflag = tmpsSelect.checked;
			if (TMPOrderRowid == " ") {
				TMPOrderRowid = "";
			}
			if ((TMPOrderRowid == TLinkOrder) && (TMPOweFlag != "0") && (TMPOweFlag != 0) && (tmpflag == true) && (flag == true)) {
				CheckNum = eval(CheckNum) + 1;
			}
		}
	}
	if (eval(CheckNum) > 0) {
		checkFlag = "N";
	}
	return checkFlag;
}

//2015-01-30 chenxi 欠药医嘱勾选去掉时如其对应的医嘱的发药是勾选的则不能退掉
function CheckDrugOwePresno(selectrow, flag) {
	var otherCheckFlag = "Y";
	var tabOPList = document.getElementById('tudhcOPRefund_AuditOrder');
	var rows = tabOPList.rows.length;
	if (rows < 2) {
		return "N";
	}
	var InvPrtDr = document.getElementById('InvPrtDrz' + selectrow).innerText;
	var TOrder = document.getElementById('TOrderz' + selectrow).innerText;
	var sSelect = document.getElementById('Tselectz' + selectrow);
	var TOrderRowid = document.getElementById('TOrderRowidz' + selectrow).innerText;
	var TLinkOrder = document.getElementById('TLinkOrderz' + selectrow).innerText;
	var PrescNo = document.getElementById('PrescNoz' + selectrow).innerText;
	if (TLinkOrder == " ") {
		TLinkOrder = "";
	}
	if (TOrderRowid == " ") {
		TOrderRowid = "";
	}
	var TOweFlag = document.getElementById('TOweFlagz' + selectrow).value;
	var OrderTypeObj = document.getElementById('TOrderTypez' + selectrow);
	var OrderType = OrderTypeObj.value;
	var othersSelect = sSelect.checked;
	var othersSelect1 = !othersSelect;
	var otherCheckNum = 0;
	if (((TOweFlag == "0") || (TOweFlag == 0)) && (OrderType == "R") && (TLinkOrder != "") && (othersSelect1 == true)) {
		for (var row = 1; row < rows; row++) {
			var TMPOrderRowid = document.getElementById('TOrderRowidz' + row).innerText;
			var TMPTOrder = document.getElementById('TOrderz' + row).innerText;
			var TMPOweFlag = document.getElementById('TOweFlagz' + row).value;
			var tmpsSelect = document.getElementById('Tselectz' + row);
			var tmpPrescNo = document.getElementById('PrescNoz' + row).innerText;
			var tmpTLinkOrder = document.getElementById('TLinkOrderz' + row).innerText;
			var tmpOrdtype = document.getElementById('TOrderTypez' + row).value;
			if ((tmpPrescNo == PrescNo) && (tmpTLinkOrder != "") && (tmpOrdtype == "R") && ((TMPOweFlag == "0") || (TMPOweFlag == 0)) && (tmpTLinkOrder != TLinkOrder)) {
				var otherCheckFlag1 = CheckDrugOwe(row, othersSelect1);
				if (otherCheckFlag1 == "N") {
					otherCheckNum = eval(otherCheckNum) + 1;
				}
			}
		}
	}
	if (eval(otherCheckNum) > 0) {
		otherCheckFlag = "N";
	}
	
	return otherCheckFlag;
}

//2016-02-05 chenxi 药品发药后申请退费，有欠药或多次发药时在退费审核界面为多条记录
//所以如这些记录中已发药且可申请数量有值时可以再次申请
function CheckdrugSelectFlag(selectrow) {
	if ((selectrow == "") || (selectrow == " ")) {
		return "N";
	}
	var tabOPList = document.getElementById('tudhcOPRefund_AuditOrder');
	var rows = tabOPList.rows.length;
	if (rows < 2) {
		return "N";
	}
	var drugSelectFlag = "N";
	var sSelect = document.getElementById('Tselectz' + selectrow);
	var sAuditFlag = document.getElementById('AuditFlagz' + selectrow).value;
	var TCanReturnNum = document.getElementById('TCanReturnNumz' + selectrow).innerText; /// 可申请数量
	var TOrderType = document.getElementById('TOrderTypez' + selectrow).value;
	if ((TCanReturnNum == "") || (TCanReturnNum == " ")) {
		TCanReturnNum = 0;
	}
	if (isNaN(TCanReturnNum)) {
		TCanReturnNum = 0;
	}
	var TDrugRetALready = document.getElementById('TDrugRetALreadyz' + selectrow).innerText; /// 已申请数量
	if ((TDrugRetALready == "") || (TDrugRetALready == " ")) {
		TDrugRetALready = 0;
	}
	if (isNaN(TDrugRetALready)) {
		TDrugRetALready = 0;
	}
	var Tphdi = document.getElementById('Tphdiz' + selectrow).value;
	if (Tphdi == " ") {
		Tphdi = "";
	}
	//if ((TOrderType=="R") && (eval(TCanReturnNum) != 0) && (eval(TDrugRetALready) == 0) && (Tphdi != "")){
	if ((TOrderType == "R") && (eval(TCanReturnNum) != 0) && (Tphdi != "")) {
		drugSelectFlag = "Y";
	}
	return drugSelectFlag;
}

//2016-02-15 chenxi 停医嘱退费和先停医嘱后审核退费，药品发药后，如停医嘱且有欠药。则欠药记录的申请数量自动填上，
//该处方其他医嘱欠药记录也应同时勾上并填上申请数量
function StopconfigOweDrug(selectRow, selectFlag) {
	if ((selectRow == "") || (selectRow == " ")) {
		return;
	}
	if ((m_AppComFlag != "2") && (m_AppComFlag != 2) && (m_AppComFlag != "1") && (m_AppComFlag != 1)) {
		return;
	}
	var sAuditFlag = document.getElementById('AuditFlagz' + selectRow).value;
	var sSelect = document.getElementById('Tselectz' + selectRow);
	var ExQty = document.getElementById('TOrderQtyz' + selectRow).innerText;
	var ReturnQty = document.getElementById('TReturnQtyz' + selectRow).innerText;
	var ExecutFlagDesc = document.getElementById('ExecutFlagDescz' + selectRow).innerText;
	var TDrugRetRequobj = document.getElementById('TDrugRetRequz' + selectRow); ///申请退费数量
	var TCanReturnNum = document.getElementById('TCanReturnNumz' + selectRow).innerText; /// 可申请数量
	var TOrderType = document.getElementById('TOrderTypez' + selectRow).value;
	var Tinciflag = document.getElementById('Tinciflagz' + selectRow).value;
	var Tphdi = document.getElementById('Tphdiz' + selectRow).value;
	var TOweFlag = document.getElementById('TOweFlagz' + selectRow).value;
	var PrescNo = document.getElementById('PrescNoz' + selectRow).innerText; //处方号
	if (Tphdi == " ") {
		Tphdi = "";
	}
	if ((TCanReturnNum == "") || (TCanReturnNum == " ")) {
		TCanReturnNum = 0;
	}
	if (isNaN(TCanReturnNum)) {
		TCanReturnNum = 0;
	}
	if (((m_AppComFlag == "2") || (m_AppComFlag == 2) || (m_AppComFlag == "1") || (m_AppComFlag == 1)) && (Tphdi != "") && (TCanReturnNum != 0) && ((selectFlag == 1) || (selectFlag == "1"))) {
		if (((TOweFlag == "0") || (TOweFlag == 0)) && ((selectFlag == 1) || (selectFlag == "1"))) {
			TDrugRetRequobj.innerText = TCanReturnNum;
		}
	}
	var tabOPList = document.getElementById('tudhcOPRefund_AuditOrder');
	var rows = tabOPList.rows.length;
	for (var row = 1; row < rows; row++) {
		var tmpPrescNo = document.getElementById('PrescNoz' + row).innerText;
		var tmpSelect = document.getElementById('Tselectz' + row);
		var tmpTOweFlag = document.getElementById('TOweFlagz' + row).value;
		var tmpTCanReturnNum = document.getElementById('TCanReturnNumz' + row).innerText;
		var tmpTDrugRetRequobj = document.getElementById('TDrugRetRequz' + row);
		if ((tmpTCanReturnNum == "") || (tmpTCanReturnNum == " ")) {
			tmpTCanReturnNum = 0;
		}
		var tmpTphdi = document.getElementById('Tphdiz' + row).value;
		if (tmpTphdi == " ") {
			tmpTphdi = "";
		}
		var myobj = document.getElementById("AuditSelFlagz" + row);
		var tmpAuditSelFlag = DHCWebD_GetCellValue(myobj);
		tmpAuditSelFlag = parseInt(tmpAuditSelFlag);
		var tmpTOrderType = document.getElementById('TOrderTypez' + row).value;
		if ((tmpTOweFlag == "0") && (TOweFlag == "0") && ((selectFlag == 1) || (selectFlag == "1"))) {
			//tmpSelect.checked = true;
			//欠药同处方不能分开退
			if ((PrescNo != "") && (tmpPrescNo == PrescNo) && (tmpTCanReturnNum != 0) && (TOrderType == "R") && (tmpTphdi != "") && (tmpTOrderType == "R")) {
				DHCWebD_SetListValueA(tmpSelect, selectFlag);
				tmpSelect.disabled = true;
				var Id = "TDrugRetRequz" + row;
				var cellobj = websys_getParentElement(tmpTDrugRetRequobj);
				if (cellobj) {
					var objwidth = cellobj.style.width;
					var objheight = cellobj.style.height;
					var str = "<label id=\"" + Id + "\" name=\"" + Id + "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight + "\" value=\"\">";
					if (m_AppComFlag != "") {
						cellobj.innerHTML = str;
					} else {
						if (((tmpTOweFlag == "0") || (tmpTOweFlag == "0")) && (TOrderType == "R")) {
							cellobj.innerHTML = str;
						}
					}
				}
				document.getElementById('TDrugRetRequz' + row).innerText = document.getElementById('TCanReturnNumz' + row).innerText;
			}
		}
		
		//if (((TOweFlag="0")||(TOweFlag==0))&&(TOrderType=="R")&&(Tphdi!="")&&((selectFlag==0)||(selectFlag=="0"))){
		if (((TOweFlag = "0") || (TOweFlag == 0)) && (TOrderType == "R") && (Tphdi != "")) {
			if ((PrescNo != "") && (tmpPrescNo == PrescNo) && (TCanReturnNum != 0) && (tmpTOrderType == "R") && (tmpTphdi != "") && ((tmpTOweFlag == "0") && (tmpTOweFlag == 0)) && ((tmpAuditSelFlag == 1) || (tmpAuditSelFlag == "1"))) {
				sSelect.disabled = true;
				DHCWebD_SetListValueA(sSelect, tmpAuditSelFlag);
				var Id = "TDrugRetRequz" + selectRow;
				var cellobj = websys_getParentElement(TDrugRetRequobj);
				if (cellobj) {
					var objwidth = cellobj.style.width;
					var objheight = cellobj.style.height;
					var str = "<label id=\"" + Id + "\" name=\"" + Id + "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight + "\" value=\"\">";
					if (m_AppComFlag != "") {
						cellobj.innerHTML = str;
					} else {
						//if (((tmpTOweFlag=="0")||(tmpTOweFlag=="0"))&&(TOrderType=="R")){
						cellobj.innerHTML = str;
						//}
					}
				}
				document.getElementById('TDrugRetRequz' + selectRow).innerText = TCanReturnNum;
			}
		}
	}
}

//2015-02-17 chenxi 判断此医嘱是否有欠药记录
function CheckDrugIsOwe(selectrow) {
	var checkFlag = "N";
	var tabOPList = document.getElementById('tudhcOPRefund_AuditOrder');
	var rows = tabOPList.rows.length;
	if (rows < 2) {
		return "N";
	}
	var InvPrtDr = document.getElementById('InvPrtDrz' + selectrow).innerText;
	var sSelect = document.getElementById('Tselectz' + selectrow);
	var TOrderRowid = document.getElementById('TOrderRowidz' + selectrow).innerText;
	if (TOrderRowid == " ") {
		TOrderRowid = "";
	}
	if (TOrderRowid == "") {
		return "N";
	}
	var OrderTypeObj = document.getElementById('TOrderTypez' + selectrow);
	var OrderType = OrderTypeObj.value;
	if (OrderType != "R") {
		return "N";
	}
	var CheckNum = 0;
	for (var row = 1; row < rows; row++) {
		var TMPOrderRowid = document.getElementById('TOrderRowidz' + row).innerText;
		var TMPOweFlag = document.getElementById('TOweFlagz' + row).value;
		var tmpOrderTypeObj = document.getElementById('TOrderTypez' + row);
		var tmpOrderType = tmpOrderTypeObj.value;
		var tmpTLinkOrder = document.getElementById('TLinkOrderz' + row).innerText;
		if ((TOrderRowid == tmpTLinkOrder) && ((TMPOweFlag == "0") || (TMPOweFlag == 0))) {
			CheckNum = eval(CheckNum) + 1;
		}
	}
	if (eval(CheckNum) > 0) {
		checkFlag = "Y";
	}
	return checkFlag;
}

function CanceOweLink(selectrow, Selectflag) {
	var tabOPList = document.getElementById('tudhcOPRefund_AuditOrder');
	var rows = tabOPList.rows.length;
	var TOrderRowid = document.getElementById('TOrderRowidz' + selectrow).innerText;
	var TLinkOrder = document.getElementById('TLinkOrderz' + selectrow).innerText;
	if (TLinkOrder == " ") {
		TLinkOrder = "";
	}
	if (TOrderRowid == " ") {
		TOrderRowid = "";
	}
	var TOweFlag = document.getElementById('TOweFlagz' + selectrow).value;
	var OrderTypeObj = document.getElementById('TOrderTypez' + selectrow);
	var PrescNo = document.getElementById('PrescNoz' + selectrow).innerText;
	var DrugIsOweFlag = CheckDrugIsOwe(selectrow);
	var OrderType = OrderTypeObj.value;
	if (OrderType != "R") {
		return;
	}
	/*
	if ((TOweFlag != "0") && (TOweFlag != 0)){
		return;
	}
	*/
	for (var row = 1; row < rows; row++) {
		//modify 2014-06-10 有欠药功能退费申请关联医嘱不能联动，否则申请退药会有问题
		//关联医嘱一起勾上
		var tmpTLinkOrder = document.getElementById('TLinkOrderz' + row).innerText;
		var TMPOrderRowid = document.getElementById('TOrderRowidz' + row).innerText;
		var ExecutFlagDesc = document.getElementById('ExecutFlagDescz' + row).innerText;
		var TDrugRetRequObj = document.getElementById('TDrugRetRequz' + row);
		var tmpTOweFlag = document.getElementById('TOweFlagz' + row).value;
		var tmpExecutFlagDesc = document.getElementById('ExecutFlagDescz' + row).innerText;
		if (tmpTLinkOrder == " ") {
			tmpTLinkOrder = "";
		}
		var tmpOrderTypeObj = document.getElementById('TOrderTypez' + row);
		var tmpOrderType = tmpOrderTypeObj.value;
		//主医嘱勾选子医嘱必须跟着勾选
		if ((TLinkOrder == "") && (tmpTLinkOrder == TOrderRowid)) {
			var sSelectRow = document.getElementById('Tselectz' + row);
			sSelectRow.checked = Selectflag;
			//modify 2014-06-10 取欠药标志和审核标志时将从ie界面取汉字改为取标志
			if (tmpTOweFlag == "0") {
				if (Selectflag) {
					document.getElementById('TDrugRetRequz' + row).innerText = document.getElementById('TCanReturnNumz' + row).innerText
				} else {
					document.getElementById('TDrugRetRequz' + row).innerText = "";
				}
			}
		}
		if ((tmpTLinkOrder != "") && ((tmpTLinkOrder == TOrderRowid) || ((tmpTLinkOrder == TLinkOrder) && (TLinkOrder != "")))) {
			if ((TOweFlag == "0") || (ExecutFlagDesc == " ") || (ExecutFlagDesc == "已审核")) {
				var TOrderTypeObj = document.getElementById('TOrderTypez' + row);
				var TOrderType = TOrderTypeObj.value;
				if ((Selectflag) && (TOrderType != "R")) {
					if ((TDrugRetRequObj.value == "") || (TDrugRetRequObj.value == "undefined") || (TDrugRetRequObj.value == "")) {
						TDrugRetRequObj.innerText = document.getElementById('TCanReturnNumz' + row).innerText;
					}
				}
			}
		}
		if ((TLinkOrder != "") && (TLinkOrder == TMPOrderRowid)) {
			if ((TOweFlag == "0") || (ExecutFlagDesc == " ") || (ExecutFlagDesc == "已审核")) {
				var TOrderTypeObj = document.getElementById('TOrderTypez' + row);
				var TOrderType = TOrderTypeObj.value;
				if ((Selectflag) && (TOrderType != "R")) {
					if ((TDrugRetRequObj.value == "") || (TDrugRetRequObj.value == "undefined") || (TDrugRetRequObj.value == "")) {
						TDrugRetRequObj.innerText = document.getElementById('TCanReturnNumz' + row).innerText;
					}
				}
			}
		}
		//2016-02-04 同一处方的欠药必须同时
		var tmpPrescNo = document.getElementById('PrescNoz' + row).innerText;
		var tmpTOweFlag = document.getElementById('TOweFlagz' + row).value;
		var tmpTCanReturnNum = document.getElementById('TCanReturnNumz' + row).innerText;
		if ((tmpTCanReturnNum == "") || (tmpTCanReturnNum == " ")) {
			tmpTCanReturnNum = 0;
		}
		var tmpTphdi = document.getElementById('Tphdiz' + row).value;
		if (tmpTphdi == " ") {
			tmpTphdi = "";
		}
		if (((tmpTOweFlag == "0") || (tmpTOweFlag == 0)) && (DrugIsOweFlag == "Y")) {
			//欠药同处方不能分开退
			if ((PrescNo != "") && (tmpPrescNo == PrescNo) && (eval(tmpTCanReturnNum) != 0) && (tmpOrderType == "R") && (tmpTphdi != "")) {
				var sSelectRow = document.getElementById('Tselectz' + row);
				sSelectRow.checked = Selectflag;
				if (Selectflag) {
					document.getElementById('TDrugRetRequz' + row).innerText = document.getElementById('TCanReturnNumz' + row).innerText
				} else {
					document.getElementById('TDrugRetRequz' + row).innerText = "";
				}
			}
		}
	}
}

function OpenPartWinOnClick(oeitm, prtRowId, index) {
	var lnk = "dhcapp.repparttarwin.csp?oeori=" + oeitm;
	var rtn = window.showModalDialog(lnk, "", "dialogwidth:620px;dialogheight:400px;center:1");
	//var rtn = window.open(lnk, "", "scrollbars=no,resizable=no,top=100,status=yes,left=100,width=800,height=460");
	if (rtn) {
		var tmpAry = rtn.split("!!");
		var repPartIdStr = "";
		for (var i = 0; i < tmpAry.length; i++) {
			var tmp = tmpAry[i];
			var id = tmp.split("^")[0];
			var desc = tmp.split("^")[1];
			if (repPartIdStr == "") {
				repPartIdStr = id;
			} else {
				repPartIdStr = repPartIdStr + "!!" + id;
			}
		}
		DHCWeb_SetColumnData("RefundRepPart", index, repPartIdStr);
		if (repPartIdStr != "") {
			DHCWeb_SetColumnData("Tselect", index, true);
		} else {
			DHCWeb_SetColumnData("Tselect", index, false);
		}
	} else {
		DHCWeb_SetColumnData("RefundRepPart", index, "");
		DHCWeb_SetColumnData("Tselect", index, false);
	}
}

document.body.onload = BodyLoadHandler;
