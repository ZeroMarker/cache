//����	dhcpecashier.hisui.js
//����	�շ�	
//����	2019.04.26
//������  yupeng
var CardFee = 0;
var payedInfo = "";	///����֧����Ϣ
var CardFlag = "N";
var rowCount = 0;
var roundingfee = 0;
var MainName = "";
var CardKEY = 0;
$(function () {
	LoadCard();

	InitCashierTableGrid();
    
	 //�ϲ���˼�¼
     $("#BMerge").click(function() { 
		BMerge_click(); 
     });


	$("#Find").click(function () {
		Find_click();

	});
	$("#CardNo").change(function () {
		CardNoOnChange();
	});

	$("#CardNo").keydown(function (e) {

		if (e.keyCode == 13) {
			CardNoOnChange();
		}

	});

	var obj = document.getElementById('ReadCard');
	if (obj) obj.onclick = ReadCardClickHandler;

	$('#BBilled').linkbutton('disable');
	$("#BBilled").click(function () {
		BBilled_click();
	});

	var obj = document.getElementById("RegNo");
	if (obj) {
		obj.onkeydown = RegNo_KeyDown;
	}
	var obj = document.getElementById("Name");
	if (obj) {
		obj.onkeydown = Name_KeyDown;
	}
	$("#BPrintDetail").click(function () {
		PrintInvByPreAudit();
	});
	$("#BAddRound").click(function () {
		BAddRound_Click();
	});
	$("#BDeleteRoundItem").click(function () {
		BDeleteRoundItem_Click();
	});





	var obj = document.getElementById("No");
	if (obj) {
		obj.onkeydown = No_KeyDown;
	}

	$("#AmountToPay").blur(function () {
		Amount_Change();
	});

	InitBillInfo();

	$("#MultiSelect").checkbox({


		onCheckChange: function (e, value) {

			if (value) {
				$("#CashierTable").datagrid({ singleSelect: false });
			}
			else {
				$("#CashierTable").datagrid({ singleSelect: true });
			}

			Find_click();

		}
	});

	$("#PayMode").combogrid({
		onSelect: function () {
			PayMode_change();
		}
	});

	$("#PayMode").combogrid("setValue", defaultpaymode);

	var invno = getValueById("CurNo");

	var Amount = getValueById("Amount");
	if (("" != invno)) {
		$('#BBilled').linkbutton('enable');

	}

	//�����Ѱ�ť�һ�����
	intiRoundingFee();
	window.onload = function () {
		if (TransGIADM) {

			$.messager.alert("��ʾ", "��˶��շ���Ϣ��", "info", function () {

				$("#PreAuditPayTable").datagrid('load', { ClassName: "web.DHCPE.PreAudit", QueryName: "SerchPreAudit", ADMType: TransADMType, CRMADM: "", GIADM: TransGIADM, AppType: "Fee" });
				$("#FeeListTable").datagrid('load', { ClassName: "web.DHCPE.ItemFeeList", QueryName: "FindItemFeeList", PreAudits: "",CSPName:"dhcpecashier.hisui.csp"});

				setValueById("ADMType", TransADMType);

				setValueById("GIADM", TransGIADM);

				var counter = getValueById("Counter");
				if (counter == "") counter = 0;

				for (i = 0; i <= counter; i++) {
					$("#PayModeTR" + i).remove();

				}
				$("#AmountToPay").focus();
				setValueById("Counter", 0);
				setValueById("AmountToPay", "");
				setValueById("No", "");
				setValueById("Remark", "");
				setValueById("InvName", "");
				setValueById("TaxpayerNum", "");
				setValueById("Rounding", "");
				setValueById("RoundRemark", "");
				setValueById("Change", 0);
				setValueById("Amount", "");
				//SetInvNo();


			})


				;

		}
	}

})


//���úϲ�
function BMerge_click(){

	var PreAuditStr=GetSelectedIds();  //��ȡ���ϲ�����˼�¼�Ĵ�
	if(PreAuditStr.split(",").length<2){
		 $.messager.alert("��ʾ", "�����շѼ�¼����ϲ�����ѡ����ϲ��ķ��ü�¼!", "info");
         return false;
	}
	
	var strrowid = "" //���˽���adm��
	var rows = $("#CashierTable").datagrid("getChecked");//��ȡ�������飬��������
	for (var i = 0; i < rows.length; i++) {

		if (strrowid == "") {
			strrowid = rows[i].TRowId;
		} else {
			strrowid = strrowid + "," + rows[i].TRowId;
		}
	}

	var admtype = getValueById("ADMType");
	
	var ret=tkMakeServerCall("web.DHCPE.ItemFeeList","MergeAudit",PreAuditStr);
	if(ret=="0"){
		 $.messager.popover({msg: '�ϲ����ü�¼�ɹ���',type:'success',timeout: 1000});	
	}else{
		$.messager.alert("��ʾ",ret,"info");
	}
	//alert(strrowid)
    $('#PreAuditPayTable').datagrid('load', {
			ClassName:"web.DHCPE.PreAudit",
			QueryName:"SerchPreAudit",
			ADMType:admtype,
			CRMADM:"",
			GIADM:strrowid,
			AppType: "Fee"
		
		});
}
	


function RegNo_KeyDown() {
	if (event.keyCode == 13) {
		var CTLocID = session['LOGON.CTLOCID'];
		var RegNo = getValueById("RegNo");
		RegNo = RegNoMask(RegNo, LocID);
		setValueById("RegNo", RegNo);
		$("#CardNo").val("");
		var SelValue = $HUI.combobox("#CardType").getValue();
		var myary = SelValue.split("^");
		var myCardTypeDR = myary[0];
		var CardNo = tkMakeServerCall("web.DHCPE.PreIBIUpdate", "GetRelate", RegNo,"R",LocID);
		$("#CardNo").val(CardNo);
		Find_click();	
		

	}
}

function CardNo_Change() {
	var myCardNo = $("#CardNo").val();

	if (myCardNo == "") {
		$.messager.alert("��ʾ", "����Ϊ��", "info");
		return;
	}
	var myrtn = DHCACC_GetAccInfo("", myCardNo, "", "", CardTypeKeydownHandler);
	return false;

}
function CardNoMask(CardNo) {
	if (CardNo == "") return CardNo;
	var CardNo = tkMakeServerCall("web.DHCPE.DHCPECommon", "CardNoMask", CardNo);
	return CardNo;
}
function RegNoMask(RegNo) {
	if (RegNo == "") return RegNo;
	var RegNo = tkMakeServerCall("web.DHCPE.DHCPECommon", "RegNoMask", RegNo);
	return RegNo;
}
function Name_KeyDown() {
	if (event.keyCode == 13) {
		Find_click();

	}
}

//ɾ��������
function BDeleteRoundItem_Click() {
	DeleteRoundFee();
}

function DeleteRoundFee() {
	var IDs = GetSelectedIds();
	if (IDs == "") return false;

	var flag = tkMakeServerCall("web.DHCPE.CashierEx", "IsExistRoundFee", IDs)
	if (flag == "0") {
		$.messager.alert("��ʾ", "û�д�����,����ɾ��!", "info");
		return false;
	}

	var ret = tkMakeServerCall("web.DHCPE.CashierEx", "DeleteRoundFee", IDs)
	if (ret == "") {
		$.messager.alert("��ʾ", "�������!", "info");
		var admtype = getValueById("ADMType")
		var iadm = getValueById("GIADM")
		var strrowid = "" //���˽���adm��
		var rows = $("#CashierTable").datagrid("getChecked");//��ȡ�������飬��������
		for (var i = 0; i < rows.length; i++) {

			if (strrowid == "") {
				strrowid = rows[i].TRowId;
			} else {
				strrowid = strrowid + "," + rows[i].TRowId;
			}
		}
		if (TransGIADM) strrowid = TransGIADM;
		$("#PreAuditPayTable").datagrid('load', { ClassName: "web.DHCPE.PreAudit", QueryName: "SerchPreAudit", ADMType: admtype, CRMADM: "", GIADM: strrowid, AppType: "Fee" });
		setValueById("Rounding", "")
		return true
	}
	$.messager.alert("��ʾ", ret, "info");

}

//����������
function BAddRound_Click() {
	InsertRoundFee();
}

function CheckRoundFee() {
	roundingfee = 0;
	roundingfee = $("#Rounding").val();
	if ("" == roundingfee) roundingfee = 0;
	if (minroundingfee == "") minroundingfee = 0;
	if ((roundingitem == "") && (roundingfee != 0)) {
		$.messager.alert("��ʾ", "û�����ô�������Ŀ", "info");
		return "";
	}
	return "";
}

function InsertRoundFee() {

	var userId = session['LOGON.USERID'];
	var locId = session['LOGON.CTLOCID'];
	var peAdmType = getValueById("ADMType");
	var peAdmId = getValueById("GIADM");
	var preoradd = "PRE"
	if ("" == peAdmId) {
		$.messager.alert("��ʾ", "����ѡ��Ҫ�����Ļ���!", "info");
		return;
	}

	var err = CheckRoundFee();

	if ("" != err) {
		$.messager.alert("��ʾ", err, "info");
		return;
	}
	if (0 == roundingfee) {
		$.messager.alert("��ʾ", "�����������!", "info");
		return;
	}

	var PAuditRowid = "";
	var selectrow = $("#PreAuditPayTable").datagrid("getChecked");//��ȡ�������飬��������

	for (var i = 0; i < selectrow.length; i++) {

		PAuditRowid = selectrow[i].TRowId


	}

	var peAdmId = tkMakeServerCall("web.DHCPE.Cashier", "GetPreIAdmID", peAdmType, peAdmId, PAuditRowid)

	if ("" == peAdmId) {
		$.messager.alert("��ʾ", "����ѡ��Ҫ�����Ļ���!", "info");
		return;
	}
	if ("I" == peAdmType) preoradd = "ADD"
	peAdmType = "PERSON";

	flag = tkMakeServerCall("web.DHCPE.PreItemList", "IsExistItem", peAdmId, peAdmType, roundingitem, "", locId)

	if ("1" == flag) {
		if (!(confirm("�Ѿ����ڴ�����?�Ƿ�������?"))) { return false; }
	}

	var RoundType = $HUI.combobox("#RoundType").getValue();

	var RoundRemark = getValueById('RoundRemark');

	var roundingitemStr = roundingitem + "&" + roundingfee + "&" + RoundType + "&" + RoundRemark;
	//alert(peAdmId+"^"+peAdmType+"^"+preoradd+"^"+roundingitemStr+"^"+userId)
	flag = tkMakeServerCall("web.DHCPE.PreItemList", "IInsertItem", peAdmId, peAdmType, preoradd, roundingitemStr, "", userId)

	if (flag == "Notice") {
		$.messager.alert("��ʾ", "�����,��ȡ�����!", "info");

		return false;
	}
	if (flag != "") {
		$.messager.alert("��ʾ", "����ʧ��!" + flag, "info");
		return false;
	}

	var admtype = getValueById("ADMType")
	var iadm = getValueById("GIADM")
	var strrowid = "" //���˽���adm��
	var rows = $("#CashierTable").datagrid("getChecked");//��ȡ�������飬��������
	for (var i = 0; i < rows.length; i++) {

		if (strrowid == "") {
			strrowid = rows[i].TRowId;
		} else {
			strrowid = strrowid + "," + rows[i].TRowId;
		}
	}
	if (TransGIADM) strrowid = TransGIADM;
	$("#PreAuditPayTable").datagrid('load', { ClassName: "web.DHCPE.PreAudit", QueryName: "SerchPreAudit", ADMType: admtype, CRMADM: "", GIADM: strrowid, AppType: "Fee" });
	setValueById("Rounding", "")

}

function PayMode_change() {

	setValueById("Remark", "")
	setValueById("No", "")
	if ($("#PayMode").combogrid('grid').datagrid('getSelected').Code == "TJYJJ") {
		var yjjamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetAPAmountByIADM", getValueById("ADMType"), getValueById("GIADM"));
		setValueById("Remark", yjjamount)
	}
}


function Amount_Change() {
	SetChange(0);
}

function No_KeyDown() {
	if (event.keyCode == 13) {
		if ($("#PayMode").combogrid('grid').datagrid('getSelected').Code == "TJDJK") {
			var Flag = tkMakeServerCall("web.DHCPE.AdvancePayment", "IsExsistCardByCardNo", getValueById("No"));
			if (Flag == "0") {
				$.messager.alert("��ʾ", "��������Ч����", "info");
				return false;
			}
			var PassWordFlag = tkMakeServerCall("web.DHCPE.AdvancePayment", "GetPassWordFlag", session['LOGON.CTLOCID']);
			if (PassWordFlag == "1") {
				var passWord = tkMakeServerCall("web.DHCPE.AdvancePayment", "GetCardPassWord", getValueById("No"));
				$.messager.prompt("��ʾ", "����������:", function (r) {
					if (r) {
						if (r == passWord) {
							$.messager.popover({ msg: "��֤�ɹ�", type: 'info' });
							CardKEY = 1;
							var djkamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetDJAmount", getValueById("No"), session['LOGON.CTLOCID']);
							var ret = djkamount.split("^");
							if (ret[0] == 0) {
								setValueById("Remark", ret[1])
							} else {
								$.messager.alert("��ʾ", ret[1], "info")
								return false;
							}
							//setValueById("Remark",djkamount)
						} else {
							$.messager.alert("��ʾ", "�������", "info");
							//$.messager.popover({ msg: "�������", type: 'info' });
							return false;
						}
					} else {
						if (r != undefined) {
							$.messager.popover({ msg: '��������Ч���룡', type: 'info' });
							return false;
						}
					}
				});
			}
			else {
				CardKEY = 1;
				var djkamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetDJAmount", getValueById("No"), session['LOGON.CTLOCID']);
				var ret = djkamount.split("^");
				if (ret[0] == 0) {
					setValueById("Remark", ret[1])
				} else {
					$.messager.alert("��ʾ", ret[1], "info")
					return false;
				}
				//setValueById("Remark",djkamount)
			}


		}
	}


}

function Amount_KeyDown() {
	if (event.keyCode == 13) {
		Amount_Change(0);

	}
}

function CheckData() {
	return SetChange(1);
}

function GetListFlag(admtype) {
	if (admtype != "I") return 0;

	return ListFlag;
}


function PrintInvByPreAudit() {
	var LocID = session['LOGON.CTLOCID'];
	var IDs = GetSelectedIds();

	if (IDs == "") {
		$.messager.alert("��ʾ", "δѡ���շѼ�¼���������ɣ�", "info")
		return false;
	}
	var ListInfo = tkMakeServerCall("web.DHCPE.CashierEx", "GetListInfo", IDs, "", LocID)

	var TxtInfo = tkMakeServerCall("web.DHCPE.CashierEx", "GetTextInfo", IDs,LocID)

	PrintDetail(TxtInfo, ListInfo);
}

function GetCardInfo(payedInfo) {
	var Balance = "";
	var CardNo = "";
	var CardInfo = "";
	var Delim = String.fromCharCode(2);
	var PayedArr = payedInfo.split("#");
	var PayModeStr = PayedArr[0];
	var PayModeArr = PayModeStr.split("^");
	var Len = PayModeArr.length;
	for (i = 0; i < Len; i++) {
		var PayModeNod = PayModeArr[i];
		var PayModeNodArr = PayModeNod.split(",");
		var PayModeDR = PayModeNodArr[0];
		var ExpStr = PayModeNodArr[2];
		if (PayModeDR == 21) {

			var Balance = tkMakeServerCall("web.DHCPE.AdvancePayment.GetAPAmount", "GetAPAmount", PayModeDR, ExpStr)

			var CardNo = ExpStr;

			if (CardInfo == "") {
				CardInfo = CardNo + "^" + Balance;
			} else {
				CardInfo = CardInfo + Delim + CardNo + "^" + Balance;
			}
		}
	}

	return CardInfo;
}
/*
function BBilled_click() {
	
	
	var checkflag=$("#MultiSelect").checkbox("getValue");
	if(checkflag)
	{
	
	$.messager.confirm("ȷ��", "��������Ϊ��"+MainName+"��ȷ��Ҫ���б��ν�����?", function(r) {
		if (r) {
			cashier();
		} else {
			return false;
		}
	});
	}
	
	else
	{
		$.messager.confirm("ȷ��", "ȷ��Ҫ���б��ν�����?", function(r) {
		if (r) {
			cashier();
		} else {
			return false;
		}
		});
		
	}
}
*/
function BBilled_click() {


	var rows = $("#PreAuditPayTable").datagrid("getChecked");//��ȡ�������飬��������
	if (rows.length == 0) {
		$.messager.alert("��ʾ", "û��Ҫ��������ݣ�", "info");
		return;

	}

	var checkflag = $("#MultiSelect").checkbox("getValue");
	if (checkflag) {

		$.messager.confirm("ȷ��", "��������Ϊ��" + MainName + "��ȷ��Ҫ���б��ν�����?", function (r) {
			if (r) {
				cashier();
			} else {
				return false;
			}
		});
	}

	else {
		//��������ID�ж��������Ƿ���δ�Ǽǵ���Ա
		//var flag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","IsExsistPre",getValueById("GIADM"),getValueById("ADMType"))

		//�������ID�ж��������Ƿ���δ�Ǽǵ���Ա
		var flag = tkMakeServerCall("web.DHCPE.DHCPEIAdm", "IsExsistPreNew", ids);
		if (flag == "1") {
			$.messager.confirm("ȷ��", "��������δ�Ǽǵ���Ա���ܽ��㣬�Ƿ��Զ��Ǽǣ�", function (r) {
				if (r) {
					var ret = tkMakeServerCall("web.DHCPE.DHCPEIAdm", "UpdateGIADMInfo", ids);
					if (ret == "0") {
						$.messager.alert("��ʾ", "�Ǽǳɹ���", "success")
						return false;
					}

				} else {
					return false;
				}
			});


		} else {
			$.messager.confirm("ȷ��", "ȷ��Ҫ���б��ν�����?", function (r) {
				if (r) {


					cashier();
				} else {
					return false;
				}
			});

		}
	}

}

/**
 * �������
 * @return   
 * @Author   wangguoying
 * @DateTime 2020-02-14
 */
function cashier() {
	ybkFlag = 0; //ҽ�������
	var ret = CheckData();
	if (ret.toString() != "") {
		return false;
	}
	if (payedInfo == "") return;
	var HospitalID = session['LOGON.HOSPID'];
	var userId = session['LOGON.USERID'];
	var locId = session['LOGON.CTLOCID'];
	var invNo = getValueById("CurNo");
	var invNo = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetInvnoNotZM", invNo)
	var invId = getValueById("InvID");
	var peAdmType = getValueById("ADMType");
	var peAdmId = getValueById("GIADM");

	var strrowid = "" //���˽���adm��
	var rows = $("#CashierTable").datagrid("getChecked");//��ȡ�������飬��������
	for (var i = 0; i < rows.length; i++) {

		if (strrowid == "") {
			strrowid = rows[i].TRowId;
		} else {
			strrowid = strrowid + "," + rows[i].TRowId;
		}
	}



	var RemainAccount = "NotCPPFlag";
	var amount;
	var CurrRegNo = ""
	var CardAccID = "";
	var myCardTypeValue = "";
	if (CardFlag == "Y") {
		var obj = document.getElementById("CurRegNo"); //�õ���ǰ��������Ա��Ӧ�ĵǼǺ�
		if (obj) CurrRegNo = obj.value;
		if (CurtRegNo != "") { CurrRegNo = CurtRegNo; }

		myCardTypeValue = getValueById("CardType")
		var m_SelectCardTypeDR = "";
		if (myCardTypeValue != "") m_SelectCardTypeDR = myCardTypeValue.split("^")[0];
		if ((myCardTypeValue.split("^")[16] == "Handle")) {
			var obj = document.getElementById('CardNo');
			var iCardNo = obj.value;

			var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, iCardNo, "");

		} else {
			var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardTypeValue);
		}
		var Ret = myrtn.split("^");
		if (Ret[0] != "0") {
			$.messager.alert("��ʾ", "�ʻ�����ȷ!", "info")
			return false;
		}
		var flag = Ret[0];
		CardAccID = Ret[7];
		var ReturnStr = tkMakeServerCall("web.DHCPE.DHCPEPAY", "CheckAccount", CardAccID, CurrRegNo);
		if (ReturnStr == "1") {
			$.messager.alert("��ʾ", "���ñ��˿��˻���������!", "info");
			return false;
		}
		var BalanceStr = tkMakeServerCall("web.DHCPE.DHCPEPAY", "GetBalance", CardAccID, CardFee);
		var Balance = BalanceStr.split("^")[0]
		var ReturnStr = BalanceStr.split("^")[1]
		if (parseFloat(Balance) < parseFloat(CardFee)) {
			$.messager.alert("��ʾ", "������" + ReturnStr, "info");
			return;
		}
		var RemainAccount = ReturnStr;
		var obj = document.getElementById("CardID");
		if (obj) {
			obj.value = CardAccID
		}
	}

	amount = getValueById("Amount");
	var listFlag = GetListFlag(peAdmType);
	payedInfo = payedInfo + "#" + CardAccID;
	var payedLength = payedInfo.split("^").length;
	var paymodeDescStr = "";
	var paymodeDesc = ""
	for (i = 0; i < payedLength; i++) {
		var paymodeID = payedInfo.split("^")[i].split(",")[0];
		if (paymodeID != "") {
			var paymodeDesc = tkMakeServerCall("web.DHCPE.Cashier", "GetPayModeDesc", paymodeID);
		}
		if (paymodeDescStr == "") {
			var paymodeDescStr = paymodeDesc;
		} else {
			var paymodeDescStr = paymodeDescStr + "^" + paymodeDesc;
		}

	}

	if (paymodeDescStr.indexOf("���Ԥ����") >= 0) {

		if ((paymodeDescStr.indexOf("�ֽ�") >= 0) || (paymodeDescStr.indexOf("֧Ʊ") >= 0) || (paymodeDescStr.indexOf("���п�") >= 0)) {
			$.messager.alert("��ʾ", "���Ԥ��������������ʽ���֧��!", "info");
			return false;
		}
	}
	if (paymodeDescStr.indexOf("������") >= 0) {

		if ((paymodeDescStr.indexOf("�ֽ�") >= 0) || (paymodeDescStr.indexOf("֧Ʊ") >= 0) || (paymodeDescStr.indexOf("���п�") >= 0)) {
			$.messager.alert("��ʾ", "�����𿨲�����������ʽ���֧��!", "info");
			return false;
		}
	}

	if ((paymodeDescStr.indexOf("���Ԥ����") >= 0) || (paymodeDescStr.indexOf("������") >= 0)) {
		if ($("#Remark").val() == "") {
			$.messager.alert("��ʾ", "�����뿨�ź�س�", "info");
			return false;
		} else {
			var RemainAccount = $("#Remark").val().split("��")[1];
		}
		//var RemainAccount=$("#Remark").val().split("��")[1];

	}


	var InsuObj = $("#InsuPay").checkbox('getValue');
	var InsuFlag = "N";
	if (InsuObj) {
		InsuFlag = "Y"
		if (payedLength > 1) {
			$.messager.alert("��ʾ", "ҽ������,ֻ��ʹ��һ��֧����ʽ!", "info");
			return;
		}
	}
	var InvName = "";
	InvName = getValueById("InvName")
	var invNo = invNo + "^" + InvName

	var OldCardInfo = GetCardInfo(payedInfo);

	var NoPrintInv = "0";
	var obj = $("#NoPrintInv").checkbox('getValue');
	if (obj) NoPrintInv = "1";
	invNo = invNo + "^" + NoPrintInv;
	var AdmReason = "",
		AdmSorce = "";
	if (InsuFlag == "Y") {
		AdmReason = getValueById("AdmReason");
		if (AdmReason == "") {
			$.messager.alert("��ʾ", "��ѡ���շѶ�Ӧ�ķѱ�!", "info");
			return false;
		}
		AdmSorce = getValueById("YLLB");
	}
	invNo = invNo + "^" + AdmReason;
	var TaxpayerNum = "";
	var obj = document.getElementById("TaxpayerNum");
	if (obj) TaxpayerNum = obj.value;
	var invNo = invNo + "^" + TaxpayerNum + "^" + AdmSorce;


	//Ԥ����
	ret = tkMakeServerCall("web.DHCPE.Cashier", "Cashier", '', '', ids, "", amount, payedInfo, userId, locId, invNo, invId, peAdmType, peAdmId, listFlag, "1", HospitalID, strrowid);
	tmp = ret.split("^");
	var InsuID = ""; //ҽ������ID
	if (tmp[0] == "") {
		if (InsuFlag == "Y") {
			//var insuRtn = insurancePay(tmp[2], amount, userId, AdmSorce, AdmReason) //DHCPEPayService.js
			var insuRtn = $PEPay.insurancePay(tmp[2], RemainAccount, userId, AdmSorce, AdmReason) //DHCPEPayService.js
			if (insuRtn.ResultCode != "0") {
				$.messager.alert("��ʾ", insuRtn.ResultMsg, "info");
				return false;
			} else if (insuRtn.ExpStr != "") {
				InsuID = insuRtn.ExpStr.split("^")[0];
				amount = parseFloat(insuRtn.ExpStr.split("^")[1]); //ȡ��ҽ���������Էѽ��
			}
		}

		$PEPay.Param = {
			Invprt: tmp[2],  	//��ƱID
			UserId: userId,  	//�շ�ԱID
			InsuID: InsuID,  	//ҽ��ID
			AdmSorce: AdmSorce,   //ҽ�����
			AdmReason: AdmReason,   //�ѱ�
			InvNoStr: invNo,  		//��Ʊ��^��Ʊ����^����Ʊ^�ѱ�^��˰��ʶ���
			PayedInfo: payedInfo,
			PeAdmType: peAdmType,
			PeAdmId: peAdmId,
			Amount: amount,
			CardAccID: CardAccID,
			MPeAdmId: strrowid,
		};

		//���õ�����֧��  һ��Ҫ��ҽ���ٵ�����
		$PEPay.extPay(cashier_callback);

	} else {
		$.messager.alert("��ʾ", "����ʧ��Err:" + ret, "info"); //Ԥ����ʧ��
		return false;
	}

}


/**
 * [֧���ص�����]
 * @param    {[type]}    pePayParam [{
 *                                  Invprt: tmp[2],  	//��ƱID
 *									UserId: userId,  	//�շ�ԱID
 *									InsuID: InsuID,  	//ҽ��ID
 *									AdmSorce: AdmSorce,   //ҽ�����
 *									AdmReason: AdmReason,   //�ѱ�
 *									InvNoStr: invno,  		//��Ʊ��^��Ʊ����^����Ʊ^�ѱ�^��˰��ʶ���
 *									PayedInfo: payedInfo,
 *									PeAdmType: peAdmType,
 *									PeAdmId: peAdmId,
 *									Amount: amount
 *                                  }]
 * @param    {[object]}    extRtn     [{
 *	                                   ResultCode: "0",
 *                                     ResultMsg: "",
 *	                                   ETPRowID: "",
 *	                                   PEBarCodePayStr: "",
 *	                                   ExpStr: ""
 * 	                                  }]
 * @Author   wangguoying
 * @DateTime 2020-12-16
 */
function cashier_callback(pePayParam, extRtn) {
	var ETPRowID = "";   //�ƷѶ���ID
	var PEBarCodePayStr = "";	//������ɨ�븶��
	if (extRtn.ResultCode != "0") {
		$.messager.alert("��ʾ", extRtn.ResultMsg, "info");
		return false;
	} else {
		ETPRowID = extRtn.ETPRowID;
		PEBarCodePayStr = extRtn.PEBarCodePayStr;
	}
	var listFlag = GetListFlag(pePayParam.PeAdmType);
	//�����Ľ���
	var ret = tkMakeServerCall("web.DHCPE.Cashier", "RealCashier", pePayParam.Invprt, pePayParam.UserId, pePayParam.InvNoStr, session['LOGON.CTLOCID'],"",ETPRowID);
	tmp = ret.split("^");
	if (tmp[0] == "") {
		
		//���»��������׼�¼
		if (PEBarCodePayStr != "") {
			var relate = tkMakeServerCall("web.DHCPE.CashierEx", "SetRelationPEBarCode", pePayParam.Invprt, PEBarCodePayStr);
		}
		var payedInfo = pePayParam.PayedInfo;
		var CardInfo = GetCardInfo(payedInfo);
		if (tmp[1] != "") {
			if (payedInfo.split(",")[0] == "1") {
				RunSingPaidAmt();
			}
			if (pePayParam.CardAccID != "") {
				var Balance = tkMakeServerCall("web.DHCPE.DHCPEPAY", "getCardAmount", pePayParam.CardAccID);
				$.messager.alert("��ʾ", "�����:" + Balance, "info");
			}
			var InvListFlag = listFlag;
			if (tmp[3] == 1) InvListFlag = 0;
			$.messager.alert("��ʾ", "����ɹ�!", "info");

			var Counter = $("#Counter").val()
			for (var i = 1; i <= Counter; i++) {
				$("#AmountToPay" + i).val("");
				$("#No" + i).val("");
				$("#Remark" + i).val("");
				$("#PayModeTR" + i).remove();
			}
			$("#No").val("");
			$("#Remark").val("");

			setValueById("AmountToPay", "");
			setValueById("Change", 0);

			if(TransGIADM){
	           $("#PreAuditPayTable").datagrid('load', {
				ClassName: "web.DHCPE.PreAudit",
				QueryName: "SerchPreAudit",
				ADMType: TransADMType,
				CRMADM: "",
				GIADM: TransGIADM,
				AppType: "Fee"
			});
			
           }else{

				$("#PreAuditPayTable").datagrid('load', {
					ClassName: "web.DHCPE.PreAudit",
					QueryName: "SerchPreAudit",
					ADMType: pePayParam.PeAdmType,
					CRMADM: "",
					GIADM: pePayParam.MPeAdmId,
					AppType: "Fee"
				});
           }

			intiRoundingFee();
			SetInvNo();
            if(tmp[1]!="") {
            	//����ɹ�������ƽ̨�ջ����շ�״̬
            	var rtnUpdateSystem=tkMakeServerCall("web.DHCPE.Service.DHCPEOutInterface", "UpdatePTPayInfo", tmp[1], session['LOGON.CTLOCID'])
				var rtnUpdateSystemOne=rtnUpdateSystem.split("^");
				if(rtnUpdateSystemOne[0]=="-1"){
					$.messager.alert("��ʾ", rtnUpdateSystemOne[1], "info")
				
				}
			}

			PrintBill(tmp[1], InvListFlag);
			if (tmp[3] == 1) {
				PrintInvDetail(tmp[2], 1);
			}

		} else {
			$.messager.alert("��ʾ", "֧���ɹ�!", "info");
			if(tmp[2]!=""){
 				//����ɹ�������ƽ̨�ջ����շ�״̬
            	var rtnUpdateSystem=tkMakeServerCall("web.DHCPE.Service.DHCPEOutInterface", "UpdatePTPayInfo", tmp[2], session['LOGON.CTLOCID'])
				var rtnUpdateSystemOne=rtnUpdateSystem.split("^");
				if(rtnUpdateSystemOne[0]=="-1"){
					$.messager.alert("��ʾ", rtnUpdateSystemOne[1], "info")
				}
			}
			$("#AmountToPay").val("");
			$("#Change").val(0);

			$("#PreAuditPayTable").datagrid('load', {
				ClassName: "web.DHCPE.PreAudit",
				QueryName: "SerchPreAudit",
				ADMType: pePayParam.PeAdmType,
				CRMADM: "",
				GIADM: pePayParam.PeAdmId,
				AppType: "Fee"
			});
			intiRoundingFee();
				var Counter = $("#Counter").val();
			
			for (var i = 1; i <= Counter; i++) {
				
				if ($("#PayMode"+ i).combogrid('grid').datagrid('getSelected').Code == "TJDJK") {
					if (CardKEY == 0) {
						return false;
					}
					var djkamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetDJAmount", $("#No" + i).val(), session['LOGON.CTLOCID']);
					var ret = djkamount.split("^");
					if (ret[0] == 0) {
						$("#Remark" + i).val(ret[1]);
					} else {
						$.messager.alert("��ʾ", ret[1], "info")
						return false;
					}
				

				}
				if ($("#PayMode"+ i).combogrid('grid').datagrid('getSelected').Code == "TJYJJ") {
					var yjjamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetAPAmountByIADM",  $("#ADMType").val(), $("#GIADM").val());
					$("#Remark" + i).val(yjjamount);
				}
				$("#AmountToPay" + i).val("");
			
			}
			
			
			if ($("#PayMode").combogrid('grid').datagrid('getSelected').Code == "TJDJK") {
				if (CardKEY == 0) {
					return false;
				}
				var djkamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetDJAmount", $("#No").val(), session['LOGON.CTLOCID']);
				var ret = djkamount.split("^");
				if (ret[0] == 0) {
					setValueById("Remark", ret[1])
				} else {
					$.messager.alert("��ʾ", ret[1], "info")
					return false;
				}
				

			}
			if ($("#PayMode").combogrid('grid').datagrid('getSelected').Code == "TJYJJ") {
				var yjjamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetAPAmountByIADM", $("#ADMType").val(), $("#GIADM").val());
				setValueById("Remark", yjjamount)
			}

            $("#AmountToPay").val("");

			PrintInvDetail(tmp[2], 1);
		}


		var DateTime = tkMakeServerCall("web.DHCPE.Cashier", "GetDateTimeStr");

		var Delim = String.fromCharCode(2);
		if (CardInfo != "") {
			var OldOneArr = OldCardInfo.split(Delim);
			var OneArr = CardInfo.split(Delim);
			var CardLength = OneArr.length;
			for (var i = 0; i < CardLength; i++) {
				var OneCardInfo = OneArr[i];
				var OldOneCardInfo = OldOneArr[i];
				var CardInfoArr = OneCardInfo.split("^");
				var OldCardInfoArr = OldOneCardInfo.split("^");
				var CardNo = CardInfoArr[0];
				var Cost = OldCardInfoArr[1] - CardInfoArr[1];
				Cost = Cost.toFixed(2);
				var TxtInfo = "CardNo" + Delim + CardNo;
				TxtInfo = TxtInfo + "^" + "Cost" + Delim + Cost;
				TxtInfo = TxtInfo + "^" + "CurrentBalance" + Delim + CardInfoArr[1];;
				TxtInfo = TxtInfo + "^" + "DateTime" + Delim + DateTime;
				PrintBalance(TxtInfo);
			}


		}


		var PreInvPrtInfo = tmp[1] + "$" + payedInfo + "$" + pePayParam.Amount;
		var lnk = location.href;
		var index = lnk.indexOf("&PreInvPrtInfo=");
		if (index > -1) {
			tmp = lnk.substring(index, lnk.length);
			lnk = lnk.substring(0, index);
		}
		lnk = lnk + "&PreInvPrtInfo=" + PreInvPrtInfo;
	} else { //�����Ľ���ʧ��
		$.messager.alert("��ʾ", "����ʧ��Err:" + ret, "info");
		return false;
	}
}


// ��ӡ���֧�������
function PrintBalance(TxtInfo) {
	DHCP_GetXMLConfig("InvPrintEncrypt", "PEINVPRTBalance");
	//var myobj=document.getElementById("ClsBillPrint");
	var Delim = String.fromCharCode(2);
	var TxtInfoHosp = TxtInfo + "^" + "BottomRemark" + Delim + "(�ֿ��˴��)";
	//DHCP_PrintFun(myobj,TxtInfoHosp,"");
	DHC_PrintByLodop(getLodop(), TxtInfoHosp, "", "", "");
	var TxtInfoPat = TxtInfo + "^" + "BottomRemark" + Delim + "(�̻����)";
	//DHCP_PrintFun(myobj,TxtInfoPat,"");
	DHC_PrintByLodop(getLodop(), TxtInfoPat, "", "", "");
}

function PrintBill(invid, listFlag) {

	var UserID = session['LOGON.USERID'];

	DHCP_GetXMLConfig("InvPrintEncrypt", "PEInvPrint");

	var peAdmType = getValueById("ADMType");

	var TxtInfo = tkMakeServerCall("web.DHCPE.Cashier", "GetInvoiceInfo", peAdmType, invid,"INV",UserID)

	var ListInfo = tkMakeServerCall("web.DHCPE.Cashier", "GetInvoiceListInfo", peAdmType, invid, listFlag)

	DHC_PrintByLodop(getLodop(), TxtInfo, ListInfo, "", "");
	//var myobj=document.getElementById("ClsBillPrint");

	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}

function PrintInvDetail(invid, listFlag) {

	var UserID = session['LOGON.USERID'];

	var peAdmType = getValueById("ADMType");

	var TxtInfo = tkMakeServerCall("web.DHCPE.Cashier", "GetInvoiceInfo", peAdmType, invid, "List",UserID)

	var ListInfo = tkMakeServerCall("web.DHCPE.Cashier", "GetInvoiceListInfo", peAdmType, invid, listFlag, "1")

	PrintDetail(TxtInfo, ListInfo);

}

function PrintDetail(TxtInfo, ListInfo) {
	DHCP_GetXMLConfig("InvPrintEncrypt", "PEINVPRTLIST");
	//DHC_PrintByLodop(getLodop(), TxtInfo, ListInfo, "", "{printListByText:true}");
	var otherCfg={	
		printListByText:true,
		tdnowrap:true, 
	}	  
    DHC_PrintByLodop(getLodop(),TxtInfo, ListInfo,"","",otherCfg);
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);

}

function SetNextPayModeValue() {
	var Src = window.event.srcElement;
	var CurID = Src.id;

	var Sort = Src.id.split("AmountToPay")[1];
	if (Sort == "") {
		Sort = 1;
	} else {
		Sort = getValueById("Counter");
	}
	var NextID = "AmountToPay" + Sort;
	var obj = document.getElementById("Amount");
	var TotalAmt = obj.value;
	var Amt = 0
	for (var i = 0; i < Sort; i++) {
		if (i == 0) {
			var ExpStr = "";
		} else {
			var ExpStr = i;
		}
		var obj = document.getElementById("AmountToPay" + ExpStr);
		if (obj) {
			Amt = (+Amt) + (+obj.value);
		}

	}
	var obj = document.getElementById(NextID);

	var objpluse = (+TotalAmt).toFixed(2) - (+Amt).toFixed(2);
	objpluse = objpluse.toFixed(2);

	if (obj) obj.value = objpluse

}
///��������
///ischeck:  0,����ϼ�-Ӧ���ϼ� �ó����㲢��Change��ֵ
///			 1,��֤�Ƿ� ����ϼ�-Ӧ���ϼ�=����,��Ĭ��֧����ʽ֧���Ľ���������
function SetChange(ischeck) {
	SetNextPayModeValue();

	var amount, i, obj, suffix;
	var paymode, payamount, no;
	var paymodeids, tmppaymode, hasSpecialPayMode;
	payedInfo = "";
	paymodeids = "";
	hasSpecialPayMode = 0;
	amount = getValueById("Amount");
	CashierMin = CashierMin;

	remainfee = 0;
	var i;
	var cashierfee = 0;
	var changefee = 0;
	var totalAmount = 0;
	var amount = getValueById("Amount");
	if ((amount == "") || (amount < 0)) {
		//$.messager.alert("��ʾ","û��Ҫ���������!","info");
		return false;
	}

	var counter = getValueById("Counter");
	if (counter == "") counter = 0
	if (counter == "0") {
		var AmountValue = getValueById("AmountToPay");

		if (AmountValue == "") {
			var AmountValue = getValueById("Amount");

			setValueById("AmountToPay", AmountValue);
		}
	}
	counter = parseInt(counter);

	CardFlag = "N"
	CardFee = 0

	for (i = 0; i <= counter; i++) {

		if (i == 0) { suffix = ""; }
		else { suffix = i; }

		obj = document.getElementById("PayMode" + suffix)
		if (obj) {
			paymode = $("#PayMode" + suffix).combogrid("getValue");
			if (($("#PayMode" + suffix).combogrid("getValue") == undefined) || ($("#PayMode" + suffix).combogrid("getValue") == "")) { var paymode = ""; }
			if (paymode == "") {

				return false;
			}



			var AmountValue = $("#AmountToPay").val();

			if (AmountValue == "") {

				var amount = getValueById("Amount");

				$("#AmountToPay").val(amount);
			}

			tmppaymode = "," + paymode + ",";

			payamount = $("#AmountToPay" + suffix).val();

			paymodecode = $("#PayMode" + suffix).combogrid('grid').datagrid('getSelected').Code;

			if (paymodeids.indexOf(tmppaymode) > -1) {
				$.messager.alert("��ʾ", "ͬһ��֧����ʽֻ����һ��!", "info");
				return false;
			}
			else {
				if (paymodeids == "") paymodeids = ",";
				paymodeids = paymodeids + paymode + ",";
			}


			if (specialpaymodes.indexOf(tmppaymode) > -1) {
				hasSpecialPayMode = 1;
			}

			payamount = $("#AmountToPay" + suffix).val();

			no = $("#No" + suffix).val();

			if (paymode == "") {
				websys_setfocus("PayMode" + suffix)
				$.messager.alert("��ʾ", "��ѡ��֧����ʽ!", "info");
				return false;
			}
			if (getValueById("PayMode" + suffix) == "") {
				websys_setfocus("PayMode" + suffix)
				$.messager.alert("��ʾ", "��ѡ��֧����ʽ!", "info");
				return false;
			}
			if ((payamount == "") || (isNaN(payamount) == true)) {
				//websys_setfocus("AmountToPay"+suffix)

				setValueById("Change", 0);
				$.messager.alert("��ʾ", "��������ȷ��֧�����!", "info");
				return false;
			}
			if (paymodecode == "CPP") {
				CardFlag = "Y"
				CardFee = payamount
			}

			if (parseFloat(payamount) < 0) {
				//websys_setfocus("AmountToPay"+suffix)
				setValueById("Change", 0);
				$.messager.alert("��ʾ", "��������ȷ��֧�����!", "info");
				return false;
			}

			if (defaultpaymode == paymode) {
				cashierfee = parseFloat(payamount);
				totalAmount = totalAmount + parseFloat(payamount);
				var DefaultPaymodeDesc = tkMakeServerCall("web.DHCPE.Cashier", "GetPayModeDesc", defaultpaymode);

				if (DefaultPaymodeDesc == "֧Ʊ") { cashierfee = cashierfee + "," + no }
				if(amount=="0"){
					if (""!=payedInfo) payedInfo=payedInfo+"^";
						payedInfo=payedInfo+paymode+","+payamount+","+no;
				}


			}
			else {
				if ("" != payedInfo) payedInfo = payedInfo + "^";
				totalAmount = totalAmount + parseFloat(payamount);
				payedInfo = payedInfo + paymode + "," + payamount + "," + no;
			}
		}
	}
	if (parseFloat(totalAmount) == "") changefee = parseFloat(cashierfee) + parseFloat(totalAmount) - parseFloat(amount);
	changefee = changefee.toFixed(2);


	sswrAmount = getValueById("sswrAmount");

	if (paymode == "1") {
		changefee = parseFloat(totalAmount) - parseFloat(amount);
	}
	else {

		changefee = parseFloat(totalAmount) - parseFloat(amount);
	}

	changefee = changefee.toFixed(2);

	setValueById("Change", changefee);


	if (1 == ischeck) {
		if (parseFloat(changefee) < 0) {
			var Insurance = getValueById("GetInsurance");
			if (Insurance == "") {
				$.messager.alert("��ʾ", "����!", "info");
				return false;
			}
			else {
				if (Insurance != "Y") {
					if (!confirm("ʣ����" + (-changefee) + "ʹ�ñ���֧��?")) {

						$.messager.alert("��ʾ", "����!", "info");
						return false;
					}
					else {
						Insurance = "Y"
						if (parseFloat(cashierfee) > 0) {
							if ("" != payedInfo) payedInfo = payedInfo + "^";
							payedInfo = payedInfo + defaultpaymode + "," + cashierfee + ",";
						}
					}
				}
				else {
					if (parseFloat(cashierfee) > 0) {
						if ("" != payedInfo) payedInfo = payedInfo + "^";
						payedInfo = payedInfo + defaultpaymode + "," + cashierfee + ",";
					}
				}
			}

		}
		else if (parseFloat(changefee) > 0) {
			if (parseFloat(cashierfee) > 0) {
				if (parseFloat(cashierfee) <= parseFloat(changefee)) {

					$.messager.alert("��ʾ", "��������ȷ��֧�����!", "info");
					return false;
				}
				cashierfee = parseFloat(cashierfee) - parseFloat(changefee);
				if ("" != payedInfo) payedInfo = payedInfo + "^";
				payedInfo = payedInfo + defaultpaymode + "," + cashierfee + ",";
			}
			else {
				if (hasSpecialPayMode == 1) {
					/*
					var href="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPayMode&PayAmount="+changefee+"&CashierInfo="+defaultpaymode+"^"+CashierMin;
					var ret=showModalDialog(href,'','',"dialogHeight:200px;dialogWidth:300px;center:yes;help:no;resizable:no;status:no;")
					if (!ret||""==ret)
					{
						payedInfo=""; 
						return "";
					}
					if (""!=payedInfo) payedInfo=payedInfo+"^";
					payedInfo=payedInfo+ret;
					*/
				}
				else {
					$.messager.alert("��ʾ", "��֧����ʽ��������!", "info");

					return false;
				}
			}
		}
		else {
			if (parseFloat(cashierfee) > 0) {
				if ("" != payedInfo) payedInfo = payedInfo + "^";
				payedInfo = payedInfo + defaultpaymode + "," + cashierfee + ",";
			}
		}

		return "";
	}
}



function InitBillInfo() {
	obj = document.getElementById("CurNo");
	if (obj) obj.readOnly = true;

	obj = document.getElementById("Amount");
	if (obj) obj.readOnly = true;
	obj = document.getElementById("Change");
	if (obj) obj.readOnly = true;
	obj = document.getElementById("sswrAmount");
	if (obj) obj.readOnly = true;

	SetInvNo();
}
function SetInvNo() {
	var userId = session['LOGON.USERID'];
	var LocID = session['LOGON.CTLOCID'];


	//ret=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",userId);
	ret = tkMakeServerCall("web.DHCPE.DHCPEPAY", "getcurinvno", userId, "N", LocID);

	var No = ""
	var invNo = ret.split("^");
	if ((invNo[0] == "") || (invNo[1] == "")) {
		$.messager.alert("��ʾ", "û��������ȷ�ķ�Ʊ��", "info");
	}
	else {
		if (invNo[2] != "") { var No = invNo[2] + "" + invNo[0]; }
		else { var No = invNo[0]; }
	}

	$("#CurNo").val(No);
	$("#InvID").val(invNo[1]);

}
function AddPayMode() {
	//Amount_Change();
	var counter = getValueById("Counter");
	if (counter == "") counter = 0;
	counter = parseInt(counter) + 1;

	var HISUIStyleCode=tkMakeServerCall("websys.StandardTypeItem","GetIdFromCodeOrDescription","websys","HISUIDefVersion"); //�ж���"�Ų�"����"����"�汾��
   	
	if(HISUIStyleCode=='blue'){
		AddPayModeHtml = "<tr id='PayModeTR" + counter + "'><td><div><select class='hisui-combogrid' type='text' Id='PayMode" + counter + "' name='PayMode" + counter + "' style='width:110px;' editable='false'></select></div></td>"
		+
		"<td><div><input class='hisui-numberbox textbox' data-options='precision:2' Id='AmountToPay" + counter + "' style='width:93px;'/></div></td>"
		+
		"<td><div><input class='hisui-validatebox textbox' Id='No" + counter + "' style='width:100px;'/></div></td>"
		+
		"<td><div><input class='hisui-validatebox textbox' Id='Remark" + counter + "' style='width:100px;'/></div></td>"
		+
		"<td><a href='#' onclick='DelPayMode(" + counter + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0 /></a></td>"
		+
		"</tr>"
	}else{
		AddPayModeHtml = "<tr id='PayModeTR" + counter + "'><td><div><select class='hisui-combogrid' type='text' Id='PayMode" + counter + "' name='PayMode" + counter + "' style='width:110px;' editable='false'></select></div></td>"
		+
		"<td><div><input class='hisui-numberbox textbox' data-options='precision:2' Id='AmountToPay" + counter + "' style='width:93px;'/></div></td>"
		+
		"<td><div><input class='hisui-validatebox textbox' Id='No" + counter + "' style='width:100px;'/></div></td>"
		+
		"<td><div><input class='hisui-validatebox textbox' Id='Remark" + counter + "' style='width:100px;'/></div></td>"
		+
		"<td>&nbsp;<span style='cursor:pointer;' class='icon-cancel'  onclick='DelPayMode(" + counter + ")'></span></td>"
		+
		"</tr>"
	}

	$("#PayModeTable").append(AddPayModeHtml);
	setValueById("Counter", counter);


	$("#No" + counter).keypress(function (e) {
		if (e.which == 13) {
			if ($("#PayMode" + counter).combogrid('grid').datagrid('getSelected').Code == "TJDJK") {
			var Flag = tkMakeServerCall("web.DHCPE.AdvancePayment", "IsExsistCardByCardNo", getValueById("No" + counter));
			if (Flag == "0") {
				$.messager.alert("��ʾ", "��������Ч����", "info");
				return false;
			}
			var PassWordFlag = tkMakeServerCall("web.DHCPE.AdvancePayment", "GetPassWordFlag", session['LOGON.CTLOCID']);
			if (PassWordFlag == "1") {
				var passWord = tkMakeServerCall("web.DHCPE.AdvancePayment", "GetCardPassWord", getValueById("No" + counter));
				$.messager.prompt("��ʾ", "����������:", function (r) {
					if (r) {
						if (r == passWord) {
							$.messager.popover({ msg: "��֤�ɹ�", type: 'info' });
							CardKEY = 1;
							var djkamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetDJAmount", getValueById("No" + counter), session['LOGON.CTLOCID']);
							var ret = djkamount.split("^");
							if (ret[0] == 0) {
								setValueById("Remark"+ counter, ret[1])
							} else {
								$.messager.alert("��ʾ", ret[1], "info")
								return false;
							}
							
						} else {
							$.messager.alert("��ʾ", "�������", "info");
							return false;
						}
					} else {
						if (r != undefined) {
							$.messager.popover({ msg: '��������Ч���룡', type: 'info' });
							return false;
						}
					}
				});
			}
			else {
				CardKEY = 1;
				var djkamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetDJAmount", getValueById("No" + counter), session['LOGON.CTLOCID']);
				var ret = djkamount.split("^");
				if (ret[0] == 0) {
					setValueById("Remark"+ counter, ret[1])
				} else {
					$.messager.alert("��ʾ", ret[1], "info")
					return false;
				}
			}
				
		   }
		}
	});


	$("#AmountToPay" + counter).blur(function () {
		Amount_Change();
	});


	$HUI.combogrid("#PayMode" + counter, {
		panelWidth: 130,
		url: $URL + "?ClassName=web.DHCPE.Cashier&QueryName=GetCashierMode&LocID=" + session['LOGON.CTLOCID'],
		mode: 'remote',
		delay: 200,
		idField: 'Hidden',
		textField: 'Description',
		onSelect: function (rowIndex, rowData) {
			if (hasExistPayMode("PayMode" + counter, rowData.Code)) {
				$("#PayMode" + counter).combogrid("setValue", "");
				$.messager.alert("��ʾ", "��" + rowData.Description + "���Ѵ��ڣ�", "info");
				return;
			}
			if (rowData.Code == "TJYJJ") {
				var yjjamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetAPAmountByIADM", getValueById("ADMType"), getValueById("GIADM"));

				setValueById("Remark" + counter, yjjamount)

			} else {
				setValueById("Remark" + counter, "")
				setValueById("No" + counter, "")

			}


		},
		columns: [[
			{ field: 'Hidden', hidden: true },
			{ field: 'Code', title: '����', width: 80, hidden: true },
			{ field: 'Description', title: '����', width: 110 }
		]]
	});


}

/**
 * [��ǰ֧����ʽ�Ƿ��Ѵ���]
 * @param    {[string]}    elementId   [��ǰԪ��ID]
 * @param    {[string]}    payModeCode [֧����ʽ����]
 * @return   {Boolean}           
 * @Author   wangguoying
 * @DateTime 2020-01-17
 */
function hasExistPayMode(elementId, payModeCode) {
	var paymodeCodes = ",";
	var counter = getValueById("Counter");
	if (counter == "") counter = 0
	if (counter == "0") {
		return false;
	}
	counter = parseInt(counter);
	for (i = 0; i <= counter; i++) {
		if (i == 0) {
			suffix = "";
		}
		else {
			suffix = i;
		}
		if (("PayMode" + suffix) == elementId) continue;
		obj = document.getElementById("PayMode" + suffix)
		if (obj) {
			paymode = $("#PayMode" + suffix).combogrid("getValue");
			if (($("#PayMode" + suffix).combogrid("getValue") == undefined) || ($("#PayMode" + suffix).combogrid("getValue") == "")) { var paymode = ""; }
			if (paymode == "") {
				continue;
			}
			paymodecode = $("#PayMode" + suffix).combogrid('grid').datagrid('getSelected').Code;
			paymodeCodes = paymodeCodes + paymodecode + ",";
		}
	}
	if (paymodeCodes.indexOf("," + payModeCode + ",") > -1) return true;
	return false;
}
function DelPayMode(rowIndex) {
	$("#PayModeTR" + rowIndex).remove();
	SetChange(0);

}

function LoadCard() {
	var HospID = session['LOGON.HOSPID']
	$.m({
		ClassName: "web.UDHCOPOtherLB",
		MethodName: "ReadCardTypeDefineListBroker",
		JSFunName: "GetCardTypeToHUIJson",
		ListName: "",
		SessionStr: "^^^^" + HospID
	}, function (val) {

		var ComboJson = JSON.parse(val);

		$HUI.combobox('#CardType', {
			data: ComboJson,
			valueField: 'id',
			textField: 'text',
			onSelect: function (record) {
				CardTypeKeydownHandler();
			}
		});
		CardTypeKeydownHandler();
	});


}
function DisableBtn(id, disabled) {
	if (disabled) {
		$HUI.linkbutton("#" + id).disable();
	} else {
		$HUI.linkbutton("#" + id).enable();
	}
}

function CardTypeKeydownHandler() {
	var SelValue = $HUI.combobox("#CardType").getValue();
	if (SelValue == "") { return; }
	var myary = SelValue.split("^");
	var myCardTypeDR = myary[0];
	if (myCardTypeDR == "") { return; }

	if (myary[16] == "Handle") {
		;
		$("#CardNo").attr("disabled", false);
		DisableBtn("ReadCard", true);
		$("#CardNo").focus();
	} else {
		$("#CardNo").attr("disabled", true);
		DisableBtn("ReadCard", false);
		$("#ReadCard").focus();
		$("#CardNo").val("");

		m_CCMRowID = GetCardEqRowIdA();
		var myobj = document.getElementById("CardNo");

		if (myobj) { myobj.readOnly = false; }
		var obj = document.getElementById("ReadCard");
		if (obj) {
			obj.disabled = false;
		}
		DHCWeb_setfocus("ReadCard");
	}
}
function GetCardEqRowIdA() {
	var CardEqRowId = "";
	var CardTypeValue = $HUI.combobox("#CardType").getValue();

	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^")
		CardEqRowId = CardTypeArr[14];
	}
	return CardEqRowId;
}
function GetCardTypeRowId() {
	var CardTypeRowId = "";
	var CardTypeValue = $HUI.combobox("#CardType").getValue();
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^")
		CardTypeRowId = CardTypeArr[0];
	}
	return CardTypeRowId;
}
function GetCardNoLength() {
	var CardNoLength = "";
	var CardTypeValue = $HUI.combobox("#CardType").getValue();
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardNoLength = CardTypeArr[17];
	}
	return CardNoLength;
}

function FormatCardNo() {
	var CardNo = DHCC_GetElementData("CardNo");
	if (CardNo != '') {
		var CardNoLength = GetCardNoLength();
		if ((CardNo.length < CardNoLength) && (CardNoLength != 0)) {
			for (var i = (CardNoLength - CardNo.length - 1); i >= 0; i--) {
				CardNo = "0" + CardNo;
			}
		}
	}
	return CardNo;
}


function ReadCardClickHandler() {
	var SelValue = $HUI.combobox("#CardType").getValue();
	if (SelValue == "") { return; }
	var myary = SelValue.split("^");
	var myCardTypeDR = myary[0];
	if (myCardTypeDR == "") { return; }

	var myary = SelValue.split("^");
	var myEquipDR = myary[14];

	var rtn = DHCACC_GetAccInfoHISUI(myCardTypeDR, myEquipDR);



	var ReturnArr = rtn.split("^");

	if (ReturnArr[0] == "-200") {
		var cardvalue = rtn.split("^")[1];
		return false;
	}
	$('#RegNo').val(ReturnArr[5]);
	if (PreCashier != 1) {
		RegNoOnChange();
	}
	$('#CardNo').val(ReturnArr[1]);



}
function DHCACC_GetAccInfoHISUI(CardTypeDR, EquipDR) {

	//var myrtn =DHCACC_ReadMagCard(EquipDR);

	var myrtn = DHCACC_ReadMagCard(EquipDR, "R", "23");

	var rtn = 0;
	var myLeftM = 0;
	var myAccRowID = "";
	var myPAPMI = "";
	var myPAPMNo = ""
	var myCardNo = "";
	var myCheckNo = "";
	var myGetCardTypeDR = "";
	var mySCTTip = "";
	var myary = myrtn.split("^");
	var encmeth = "";
	if (myary[0] == 0) {
		rtn = myary[0];
		myCardNo = myary[1];
		myCheckNo = myary[2];

		var myExpStr = "" + String.fromCharCode(2) + CardTypeDR;
		var myrtn = tkMakeServerCall("web.UDHCAccManageCLSIF", "getaccinfofromcardno", myCardNo, myCheckNo, myExpStr);

		var myary = myrtn.split("^");
		if (myary[0] == 0) {
			rtn = myary[0];


			var myAccRowID = myary[1];
			var myLeftM = myary[3];
			var myPAPMI = myary[7];
			var myPAPMNo = myary[8];
			var myAccType = myary[10];
			var myAccGrpLeftM = myary[17]
			if (myary.length > 12) {
				myGetCardTypeDR = myary[12];
			}
			if (myary.length > 13) {
				mySCTTip = myary[13];
			}
		}

	} else {
		rtn = myary[0];

	}
	return rtn + "^" + myCardNo + "^" + myCheckNo + "^" + myLeftM + "^" + myPAPMI + "^" + myPAPMNo + "^" + myAccType + "^" + myAccRowID + "^" + myGetCardTypeDR + "^" + mySCTTip + "^" + myAccGrpLeftM;
}


function Find_click() {
	var CTLocID = session['LOGON.CTLOCID'];
	var RegNoLength = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetRegNoLength", CTLocID);
	var iRegNo = $("#RegNo").val();
	if (iRegNo.length < RegNoLength && iRegNo.length > 0) {
		iRegNo = tkMakeServerCall("web.DHCPE.DHCPECommon", "RegNoMask", iRegNo, CTLocID);
		$("#RegNo").val(iRegNo);
	}

	$("#CashierTable").datagrid('load', { ClassName: "web.DHCPE.DHCPEIAdm", QueryName: "CashierForHISUI", PAPMINo: iRegNo, IADMName: getValueById("Name"), AuditDateBegin: getValueById("StartDate"), AuditDateEnd: getValueById("EndDate"), LocID: CTLocID });
	$("#PreAuditPayTable").datagrid('load', { ClassName: "web.DHCPE.PreAudit", QueryName: "SerchPreAudit", ADMType: "", CRMADM: "", GIADM: "", AppType: "Fee" });
	$("#FeeListTable").datagrid('load', { ClassName: "web.DHCPE.ItemFeeList", QueryName: "FindItemFeeList", PreAudits: "",CSPName:"dhcpecashier.hisui.csp" });
	setValueById("ADMType", "");
	setValueById("GIADM", "");
	setValueById("CurRegNo", "");


	var counter = getValueById("Counter");
	if (counter == "") counter = 0;

	for (i = 0; i <= counter; i++) {
		$("#PayModeTR" + i).remove();

	}
	setValueById("Counter", 0);

	setValueById("AmountToPay", "");
	setValueById("No", "");
	setValueById("Remark", "");
	setValueById("InvName", "");
	setValueById("TaxpayerNum", "");
	setValueById("Rounding", "");
	setValueById("RoundRemark", "");
	setValueById("Change", 0);
	setValueById("Amount", "");
	SetInvNo();
	intiRoundingFee();
	if ($("#PayMode").combogrid('grid').datagrid('getSelected').Code == "TJYJJ") {
		var yjjamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetAPAmountByIADM", getValueById("ADMType"), getValueById("GIADM"));

		setValueById("Remark", yjjamount)

	}

}





function SplitItem(rowid) {
	
	var ADMType = $("#ADMType").val();
	var GIADM = $("#GIADM").val();
	if (ADMType == "I") { var SplitType="item";}
	if (ADMType == "G") { var SplitType="person";}
    var lnk = "dhcpesplitaudit.hiui.csp?AuditID=" + rowid + "&SplitType=" +SplitType+ "&ADMType=" + ADMType + "&GIADM=" + GIADM;
    
    $HUI.window("#SplitWin", {
        title: "�շѼ�¼���",
        iconCls: "icon-w-edit",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 1400,
        height: 700,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });
    
    //websys_lu(lnk,false,'width=1400,height=600,hisui=true,title=�շѼ�¼���'); //�޷��������������������ʾ��������
}


function GetSelectedIds() {


	var ids = ""
	var selectrow = $("#PreAuditPayTable").datagrid("getChecked");//��ȡ�������飬��������

	for (var i = 0; i < selectrow.length; i++) {
		if (ids == "") {
			ids = selectrow[i].TRowId
		} else {
			ids = ids + "," + selectrow[i].TRowId
		}

	}


	return ids;
}


function CardNoOnChange() {

	CardNoChangeAppHISUI("RegNo", "CardNo", "RegNoOnChange()", "Clear_click()", "0");

}
function CardNoChangeAppHISUI(RegNoElement, CardElement, AppFunction, AppFunctionClear, ClearFlag) {

	var obj;
	var CardNo = "", SelectCardTypeRowID = "";
	obj = document.getElementById(CardElement);
	if (obj) CardNo = obj.value;
	if (CardNo == "") return;
	if (ClearFlag == "1") eval(AppFunctionClear);
	obj.value = CardNo;

	var SelValue = $HUI.combobox("#CardType").getValue();
	if (SelValue == "") { return; }
	var myary = SelValue.split("^");
	var myCardTypeDR = myary[0];
	if (myCardTypeDR == "") { return; }
	SelectCardTypeRowID = myCardTypeDR;

	CardNo = CardNo + "$" + SelectCardTypeRowID;

	RegNo = tkMakeServerCall("web.DHCPE.PreIBIUpdate", "GetRelate", CardNo, "C");
	if (RegNo == "") {
		$("#RegNo").val("");
		return;

	}
	obj = document.getElementById(RegNoElement);
	if (obj) {
		obj.value = RegNo;
		eval(AppFunction);
	}
}



function RegNoOnChange() {

	if (PreCashier != 1) {
		Find_click();
	}
	/*
	var CardNo=getValueById("CardNo")
	CardNo=RegNoMask(CardNo)
	setValueById("CardNo",CardNo)
	*/
	var LocID = session['LOGON.CTLOCID'];
	var CardNo = $("#CardNo").val();
	var SelValue = $HUI.combobox("#CardType").getValue();
	var myary = SelValue.split("^");
	var myCardTypeDR = myary[0];
	var CardNo = tkMakeServerCall("web.DHCPE.CT.HISUICommon", "CardNoMaskNew", CardNo, myCardTypeDR, LocID);
	$("#CardNo").val(CardNo);

}

function Clear_click() {

}

function Calculate() {

	var amount;

	ids = "";
	amount = 0;


	ids = GetSelectedIds();
	try {
		if (ids != "") amount = tkMakeServerCall("web.DHCPE.Cashier", "GetAuditsAmount", '', '', ids);
	}
	catch (e) { alert(e.message); }
	return amount;
}

/*

function intiRoundingFee(){
		var peAdmType=$("#ADMType").val();
		if(peAdmType=="") {var peAdmType=TransADMType;}
			var peAdmId=getValueById("GIADM");
		if(peAdmId==""){var peAdmId=TransGIADM;}


		var roundfeemode=tkMakeServerCall("web.DHCPE.Cashier","GetRoundingFeeMode",session['LOGON.USERID']) 
		if ((roundfeemode==0)||((roundfeemode==1)&&(peAdmType!="I"))||((roundfeemode==2)&&(peAdmType=="I")))
			{ 
				$("#BAddRound").linkbutton('disable');
				$("#BDeleteRoundItem").linkbutton('disable'); 
					
			}else{
				$("#BAddRound").linkbutton('enable');
				$("#BDeleteRoundItem").linkbutton('enable');
					
		}

		var flag=tkMakeServerCall("web.DHCPE.Cashier","IsFinishBilled",peAdmId,peAdmType) 
		
		if (flag=="1"){ 
				$("#BAddRound").linkbutton('disable');
				$("#BDeleteRoundItem").linkbutton('disable'); 
					
			}else{
				$("#BAddRound").linkbutton('enable');
				$("#BDeleteRoundItem").linkbutton('enable');
					
		}
		

				
}
*/
function intiRoundingFee() {
	var peAdmType = $("#ADMType").val();
	if (peAdmType == "") { var peAdmType = TransADMType; }
	var peAdmId = getValueById("GIADM");
	if (peAdmId == "") { var peAdmId = TransGIADM; }

	var UserDR = session['LOGON.USERID'];
	var LocID = session['LOGON.CTLOCID'];
	var roundfeemode = 0
	var OPflag = tkMakeServerCall("web.DHCPE.CT.ChargeLimit", "GetOPChargeLimitInfo", UserDR, LocID);
	var OPflagOne = OPflag.split("^");
	var roundfeemode = OPflagOne[2];

	//alert(roundfeemode+"^"+peAdmType)
	var flag = tkMakeServerCall("web.DHCPE.Cashier", "IsFinishBilled", peAdmId, peAdmType)
	if ((roundfeemode == 0) || ((roundfeemode == 1) && (peAdmType != "I")) || ((roundfeemode == 2) && (peAdmType == "I"))) {

		$("#BAddRound").linkbutton('disable');
		$("#BDeleteRoundItem").linkbutton('disable');

	} else {
		$("#BAddRound").linkbutton('enable');
		$("#BDeleteRoundItem").linkbutton('enable');
		if (flag == "1") {
			$("#BAddRound").linkbutton('disable');
			$("#BDeleteRoundItem").linkbutton('disable');

		} else {
			$("#BAddRound").linkbutton('enable');
			$("#BDeleteRoundItem").linkbutton('enable');

		}

	}

}


function InitCashierTableGrid() {

	$HUI.datagrid("#CashierTable", {
		url: $URL,
		fit: true,
		border: false,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: true,
		rownumbers: true,
		singleSelect: true,
		checkOnSelect: true,
		selectOnCheck: true,
		pageSize: 20,
		pageList: [20, 100, 200],
		toolbar: [],
		queryParams: {
			ClassName: "web.DHCPE.DHCPEIAdm",
			QueryName: "CashierForHISUI",
			PAPMINo: getValueById("RegNo"),
			IADMName: getValueById("Name"),
			AuditDateBegin: getValueById("StartDate"),
			AuditDateEnd: getValueById("EndDate"),
			LocID: session['LOGON.CTLOCID']
		},
		columns: [[
			{ field: 'PreADM', hidden: true},
			{ field: 'TRowId', checkbox: true },
			{ field: 'TNewHPNo', title: '����', width: '120' },
			{ field: 'TPapmiNo', title: '�ǼǺ�', width: '120' },
			{ field: 'TName', title: '����', width: '120' },
			{ field: 'TRegDate', title: '����(�Ǽ�)����' },
			{ field: 'TStatus', title: '״̬' },
			{ field: 'TAsCharged', title: '��ͬ�շ�' },
			{ field: 'TGAdmDesc', title: '��������', width: '150' },
			{ field: 'TTeamDesc', title: '��������', width: '100' },
			{ field: 'TConfirmStatus', title: '��Ҫȷ�ϼ���' },
			{ field: 'TUpdatePreAudit', title: '����',width: '60',align: 'center',  
				formatter: function (value, row, index) {
					
					return "<span style='cursor:pointer;' class='icon-paper' title='' onclick='UpdatePreAudit(\"" + row.PreADM +","+row.TAdmType+"\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
					//return "<span style='cursor:pointer;padding:0 10px 0px 30px' class='icon-paper' title='����' onclick='UpdatePreAudit(\"" + row.PreADM +","+row.TAdmType+"\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
					
				}
			},
			{ field: 'TAdmType', hidden: true },
			{ field: 'TPGBIID', hidden: true }
		]],


		onCheck: function (rowIndex, rowData) {

			var strrowid = "", strtype = ""
			var rows = $("#CashierTable").datagrid("getChecked");//��ȡ�������飬��������
			for (var i = 0; i < rows.length; i++) {

				if (strrowid == "") {
					strtype = rows[i].TAdmType;
					strrowid = rows[i].TRowId;
					setValueById("CurRegNo", rows[i].TPapmiNo);
					setValueById("GIADM", rows[i].TRowId);
					MainName = rows[i].TName;
				} else {
					strrowid = strrowid + "," + rows[i].TRowId;
					strtype = strtype + "," + rows[i].TAdmType;
				}



			}

			if ((strtype.indexOf("G") != -1) && (strtype.indexOf("I") != -1)) {
				$.messager.alert("��ʾ", "���˺����岻��һ����㣡", "info");
				$("#CashierTable").datagrid('unselectRow', rowIndex);


			}
			else {
				$("#PreAuditPayTable").datagrid('load', { ClassName: "web.DHCPE.PreAudit", QueryName: "SerchPreAudit", ADMType: rowData.TAdmType, CRMADM: "", GIADM: strrowid, AppType: "Fee" });

				$("#FeeListTable").datagrid('load', { ClassName: "web.DHCPE.ItemFeeList", QueryName: "FindItemFeeList", PreAudits: "" ,CSPName:"dhcpecashier.hisui.csp"});

				setValueById("ADMType", rowData.TAdmType);



				var counter = getValueById("Counter");
				if (counter == "") counter = 0;

				for (i = 0; i <= counter; i++) {
					$("#PayModeTR" + i).remove();

				}

				$("#AmountToPay").focus();
				setValueById("Counter", 0);
				setValueById("AmountToPay", "");
				setValueById("No", "");
				setValueById("Remark", "");
				setValueById("InvName", "");
				setValueById("TaxpayerNum", "");

				//��ȡ���������Ϣά���������˰��ʶ��� 
				var value=tkMakeServerCall("web.DHCPE.PreGBaseInfo","GetPreGBaseInfo", rowData.TPGBIID)
				var Data=value.split("^");
				 $("#TaxpayerNum").val(Data[16]);

				setValueById("Rounding", "");
				setValueById("RoundRemark", "");
				setValueById("Change", 0);
				setValueById("Amount", "");
				SetInvNo();
				intiRoundingFee();
				if ($("#PayMode").combogrid('grid').datagrid('getSelected').Code == "TJYJJ") {
					var yjjamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetAPAmountByIADM", getValueById("ADMType"), getValueById("GIADM"));

					setValueById("Remark", yjjamount)

				}
			}
		},

		onUncheck: function (rowIndex, rowData) {

			var strrowid = ""
			var rows = $("#CashierTable").datagrid("getChecked");//��ȡ�������飬��������
			for (var i = 0; i < rows.length; i++) {

				if (strrowid == "") {
					strrowid = rows[i].TRowId;
					setValueById("CurRegNo", rows[i].TPapmiNo);
					setValueById("GIADM", rows[i].TRowId);
					setValueById("ADMType", rows[i].TAdmType);
					MainName = rows[i].TName;
				} else {
					strrowid = strrowid + "," + rows[i].TRowId;
				}
				var RealType = rows[i].TAdmType;


			}

			$("#PreAuditPayTable").datagrid('load', { ClassName: "web.DHCPE.PreAudit", QueryName: "SerchPreAudit", ADMType: RealType, CRMADM: "", GIADM: strrowid, AppType: "Fee" });

			if (strrowid == "") {
				$("#FeeListTable").datagrid('load', { ClassName: "web.DHCPE.ItemFeeList", QueryName: "FindItemFeeList", PreAudits: "",CSPName:"dhcpecashier.hisui.csp" });

				setValueById("ADMType", "");

				setValueById("GIADM", "");

				var counter = getValueById("Counter");
				if (counter == "") counter = 0;

				for (i = 0; i <= counter; i++) {
					$("#PayModeTR" + i).remove();

				}
				setValueById("Counter", 0);

				setValueById("AmountToPay", "");
				setValueById("No", "");
				setValueById("Remark", "");
				setValueById("InvName", "");
				setValueById("TaxpayerNum", "");
				setValueById("Rounding", "");
				setValueById("RoundRemark", "");
				setValueById("Change", 0);
				setValueById("Amount", "");
				SetInvNo();
				intiRoundingFee();
				if ($("#PayMode").combogrid('grid').datagrid('getSelected').Code == "TJYJJ") {
					var yjjamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetAPAmountByIADM", getValueById("ADMType"), getValueById("GIADM"));

					setValueById("Remark", yjjamount)

				}
			}

		},
		onDblClickRow: function (rowIndex, rowData) {
			var checkflag = $("#MultiSelect").checkbox("getValue");
			if (checkflag) {
				setValueById("GIADM", rowData.TRowId);
				setValueById("CurRegNo", rowData.TPapmiNo);
				MainName = rowData.TName;
				$.messager.alert("��ʾ", "������������Ϊ��" + rowData.TName, "info");
			}
		},

		onLoadSuccess: function (rowData) {


			$('#CashierTable').datagrid('clearSelections'); //һ��Ҫ������һ�䣬Ҫ��Ȼdatagrid���ס֮ǰ��ѡ��
			$("#CashierTable").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
		}

	});

	$HUI.datagrid("#PreAuditPayTable", {
		url: $URL,
		toolbar:[],
		rownumbers: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 100, 200],
		queryParams: {
			ClassName: "web.DHCPE.PreAudit",
			QueryName: "SerchPreAudit",
			ADMType: "",
			CRMADM: "",
			GIADM: "",
			AppType: ""
		},
		onCheck: function (rowIndex, rowData) {



			if (rowData.TChargedStatus == "���շ�") {
				//����datagrid��ĳ�в��ܱ�ѡ��
				$('#PreAuditPayTable').datagrid('unselectRow', rowIndex);
			}


			var amount = Calculate();

			var sswrAmount = parseFloat(amount).toFixed(1);


			setValueById("Amount", amount);

			setValueById("sswrAmount", sswrAmount);



			var ids = GetSelectedIds();

			$("#FeeListTable").datagrid('load', { ClassName: "web.DHCPE.ItemFeeList", QueryName: "FindItemFeeList", PreAudits: ids,CSPName:"dhcpecashier.hisui.csp" });



		},
		onUncheck: function (rowIndex, rowData) {

			var amount = Calculate();

			var sswrAmount = parseFloat(amount).toFixed(1);


			setValueById("Amount", amount);

			setValueById("sswrAmount", sswrAmount);


			var strrowid = ""
			var rows = $("#PreAuditPayTable").datagrid("getChecked");//��ȡ�������飬��������
			for (var i = 0; i < rows.length; i++) {

				if (strrowid == "") {
					strrowid = rows[i].TRowId;
				} else {
					strrowid = strrowid + "," + rows[i].TRowId;
				}



			}


			$("#FeeListTable").datagrid('load', { ClassName: "web.DHCPE.ItemFeeList", QueryName: "FindItemFeeList", PreAudits: strrowid,CSPName:"dhcpecashier.hisui.csp" });




		},

		//������Ϻ��ȡ���е�checkbox����
		onLoadSuccess: function (rowData) {


			$('#PreAuditPayTable').datagrid('clearSelections'); //һ��Ҫ������һ�䣬Ҫ��Ȼdatagrid���ס֮ǰ��ѡ��
			$("#PreAuditPayTable").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
			var objtbl = $("#PreAuditPayTable").datagrid('getRows');
			if (rowData) {

				//����datagrid����            
				$.each(rowData.rows, function (index) {

					if (objtbl[index].TChargedStatus == "���շ�") {
						$("#PreAuditPayTable.datagrid-row[datagrid-row-index=" + index + "] input[type='checkbox']").attr('disabled', 'disabled');
						$('#PreAuditPayTable').datagrid('unselectRow', index);
					} else {

						$('#PreAuditPayTable').datagrid('checkRow', index);

					}
				});


			}
			$("#AmountToPay").focus();
			setValueById("AmountToPay", "");
		},
		columns: [[
			{ field: 'TDiscountedAmount', checkbox: true },
			{ field: 'TRowId', hidden: true },
			{ field: 'TRebate', title: '�ۿ���', width: '90' },
			{ field: 'TAccountAmount', title: 'Ӧ�ս��', align: 'right', width: '90' },
			{ field: 'TFactAmount', title: '���ս��', align: 'right', width: '90' },
			{ field: 'TAuditedStatus', title: '���״̬', width: '90' },
			{ field: 'TChargedStatus', title: '�շ�״̬' },
			{ field: 'TPrivilegeMode', title: '�Ż���ʽ' },
				{field:'TNoDiscount',width:100,title:'��Ŀ������',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{ field: 'TType', title: '����' },
			{
				field: 'TSplit', title: '���', align: 'center',
				formatter: function (value, row, index) {
					return "<span style='cursor:pointer;' class='icon-transfer' title='' onclick='SplitItem("+row.TRowId+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
					/*
					return "<a href='#' onclick='SplitItem(\"" + row.TRowId + "\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/transfer.png' border=0/>\
					</a>";
					*/
				}
			},
			{ field: 'TRemark', title: '��ע', width: '120' },
			{ field: 'TTeamName', title: '��������', width: '180' }
		]]

	});


	$HUI.datagrid("#FeeListTable", {
		url: $URL,
		fit: true,
		border: false,
		striped: true,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 100, 200],
		displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������" 
		singleSelect: true,
		selectOnCheck: true,
		toolbar: [],
		queryParams: {
			ClassName: "web.DHCPE.ItemFeeList",
			QueryName: "FindItemFeeList",
			PreAudits: "",
			CSPName:"dhcpecashier.hisui.csp"
		},
		columns: [[

			{ field: 'FactAmount', title: '���ս��', align: 'right' },
			{ field: 'ItemName', title: '��Ŀ����' },
			{ field: 'FeeTypeDesc', title: '���' },
			{ field: 'OrdStatusDesc', title: 'ִ��״̬' },
			{ field: 'PatName', title: '����' }
		]],
		onSelect: function (rowIndex, rowData) {

		}
	});


   //֧����ʽ
	var PayModeObj = $HUI.combogrid("#PayMode", {
		panelWidth: 130,
		url: $URL + "?ClassName=web.DHCPE.Cashier&QueryName=GetCashierMode&LocID=" + session['LOGON.CTLOCID'],
		mode: 'remote',
		delay: 200,
		idField: 'Hidden',
		textField: 'Description',
		onSelect: function (rowIndex, rowData) {
			if (rowData.Code == "TJYJJ") {
				var yjjamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetAPAmountByIADM", getValueById("ADMType"), getValueById("GIADM"));
				setValueById("Remark", yjjamount)
			}
		},
		columns: [[
			{ field: 'Hidden', hidden: true },
			{ field: 'Code', title: '����', width: 80, hidden: true },
			{ field: 'Description', title: '����', width: 110 }
		]]
	});

	
    //��������
	var RoundTypeObj = $HUI.combobox("#RoundType", {
		valueField: 'id', 
		textField: 'text', 
		selectOnNavigation: false, 
		panelHeight: "auto",
		editable: false,
		data: [
			{ id: '1', text: $g('���'), "selected": true }, 
			{ id: '2', text: $g('��Ժ���ɷ�') }, 
			{ id: '3', text: $g('���ײͲ���') }, 
			{ id: '4', text: $g('����') }
		]
	});

   //�ѱ�
	var AdmReasonObj = $HUI.combobox("#AdmReason", {
		url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=OutAdmReason&ResultSetType=array&LocID=" + session['LOGON.CTLOCID'],
		valueField: 'id',
		textField: 'desc',
		onSelect: function (record) {
			$('#YLLB').combobox('setValue', "");
			$('#YLLB').combobox('reload');

		}
	});

  //ҽ������
	var YLLBObj = $HUI.combobox("#YLLB", {
		url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=OutYLLB&ResultSetType=array",
		valueField: 'id',
		textField: 'desc',
		mode: 'remote',
		onBeforeLoad: function (param) {

			var AdmReason = $("#AdmReason").combobox("getValue");
			param.AdmReason = AdmReason;
			param.HospID = session['LOGON.HOSPID'];
		}
	});

}

//����
function UpdatePreAudit(Str)
{

	var StrOne=Str.split(",");
	var ID=StrOne[0];
	var ADMType=StrOne[1];
	
	var lnk="dhcpepreauditlist.hiui.csp?CRMADM="+ID+"&ADMType="+ADMType+"&GIADM="+"&RowID=";
	
	//websys_lu(lnk,false,'top=90,left=100,iconCls=icon-w-edit,width=1400,height=750,hisui=true,title=����') //�޷��������������������ʾ��������
	
	$HUI.window("#FeeSplitWin", {
        title: "����",
        iconCls: "icon-w-edit",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 1400,
        height: 750,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });

	return true;
}