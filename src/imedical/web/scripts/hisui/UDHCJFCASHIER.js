/// UDHCJFCASHIER.js

var Adm = "";
var BillNo = "";
var papnoobj;
var billnoobj;
var depositobj, totalamountobj, amttopayobj;
var discretamtobj;
var patzynoobj;
var SelectedRow = "-1";
var Tinvno, billstatus;

$(function(){
	init_Layout();
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initCardType();
	DHCP_GetXMLConfig("InvPrintEncrypt", "DHCJFIPReceipt");
	billnoobj = document.getElementById('BillNo');
	depositobj = document.getElementById('Deposit');
	totalamountobj = document.getElementById('Totalamount');
	amttopayobj = document.getElementById('Amounttopay');
	discretamtobj = document.getElementById('Discretamt');

	patzynoobj = document.getElementById("patmedicare");
	if (patzynoobj) {
		patzynoobj.onkeydown = getpat;
	}
	//insert by 2008.05.05 增加读卡功能
	var readcard = document.getElementById('readcard');
	if (readcard) {
		readcard.onclick = readHFMagCardClick;
	}
	var obj = document.getElementById('opcardno');
	if (obj) {
		obj.onkeydown = cardNoKeydown;
	}
	var reprtFPbtn = document.getElementById('RePrintFP');
	if (reprtFPbtn) {
		reprtFPbtn.onclick = ReprintFP;
	}

	papnoobj = document.getElementById('Regno');
	if (papnoobj) {
		papnoobj.onkeydown = getpat;
	}
	
	var adddepositobj = document.getElementById('AddDeposit');
	if (adddepositobj) {
		adddepositobj.onclick = LinkAddDeposit;
	}

	var refunddepobj = document.getElementById('RefundDeposit');
	if (refunddepobj) {
		refunddepobj.onclick = LinkRefundDeposit;
	}

	var printdetailobj = document.getElementById('Printdetail');
	if (printdetailobj) {
		printdetailobj.onclick = LinkBillDetail;
	}
	
	var clearobj = document.getElementById('Clear');
	if (clearobj) {
		clearobj.onclick = clearClick;
	}
	
	$("#Deposit").prop("readOnly", true);
	$("#Totalamount").prop("readOnly", true);
	$("#Amounttopay").prop("readOnly", true);
	$("#Discretamt").prop("readOnly", true);
	$("#decease").prop("readOnly", true);
	
	$HUI.combobox("#CurrentFlag", {
		panelHeight: 'auto',
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{id: 'billed', text:'未结算'},
			  {id: 'paid', text: '结算历史'},
			  {id: 'disch', text: '最终结算', selected: true},
			  {id: 'tobill', text: '新入院'}]
	});
	
	$HUI.combobox("#Loc", {
		url: $URL + '?ClassName=web.UDHCJFCASHIER&QueryName=FindDept&ResultSetType=array',
		mode: 'remote',
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = session['LOGON.HOSPID'];
		},
		onChange:function(newValue, oldValue) {
			setValueById("locid", (newValue || ""));
		}
	});

	$HUI.combobox("#Type", {
		url: $URL + '?ClassName=web.UDHCJFCASHIER&QueryName=FindAdmReason&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.hospId = session['LOGON.HOSPID'];
		},
		onChange:function(newValue, oldValue) {
			setValueById("typeid", (newValue || ""));
		}
	});

	focusById('Regno');
});

function getpat(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getPatInfo();
	}
}

function clearClick() {
	$(":text:not(.pagination-num)").val("");
	$(".combobox-f:not(#OPCardType)").combobox("setValue", "");
	$("#OPCardType").combobox("reload");
	$('#Find').click();
	getenddate();
	$("#CurrentFlag").combobox("select", 'disch');
}

function getenddate() {
	var encmeth = getValueById('getenddate');
	if (cspRunServerMethod(encmeth, 'setdate_val', '', '') == '1') {}
}

function setdate_val(value) {
	setValueById('EndDate', value);
}

function getdeposit(Adm) {
	var encmeth = getValueById('getdeposit');
	return cspRunServerMethod(encmeth, Adm);
}

function SelectRowHandler(index, rowData) {
	var selectrow = index;
	if (selectrow < 0){
		return;
	}
	if (selectrow != SelectedRow) {
		//+2015-3-23 hujunbin 将就诊ID和账单ID传到头菜单
		var episodeObj = document.getElementById('Tadmz' + selectrow);
		var billObj = document.getElementById('Tbillrowidz' + selectrow);
		var frm = parent.parent.document.forms['fEPRMENU'];
		if (typeof(frm) != "undefined") {
			var frmEpisodeID = frm.EpisodeID;
			var frmBillID = frm.BillRowIds;
			if (billObj){
				frmBillID.value =rowData.Tbillrowid;
			}
			if (episodeObj){
				frmEpisodeID.value =rowData.Tadm;
			}
		}
		Adm = rowData.Tadm;
		setValueById('Adm', Adm);
		setValueById('EpisodeID', Adm);
		var tabRegno=$('.datagrid-row-selected').find('td[field=Tregno]')[0].innerText;
		var regno = tabRegno;
		if (regno) {
			setValueById('Regno',tabRegno);
		}
		setValueById('PatientID', rowData.TPatientID);
		billstatus = rowData.Tbillstatus;
		depositobj.value = getdeposit(Adm);
		if (discretamtobj.value == "")
			discretamtobj.value = "0.00";
		if (billstatus == "已计费") {
			totalamountobj.value = "0.00";
			amttopayobj.value = "0.00";
		} else {
			totalamountobj.value = rowData.Tpatientshare;
			var tmpamt = totalamountobj.value - depositobj.value - discretamtobj.value;
			amttopayobj.value = tmpamt.toFixed(2);
		}
		if (amttopayobj.value < 0) {
			amttopayobj.style.color = "red";
		} else {
			amttopayobj.style.color = "black";
		}
		BillNo = rowData.Tbillrowid;
		if (BillNo) {
			billnoobj.value = BillNo;
		} else {
			billnoobj.value = "";
			BillNo = "";
		}
		Tinvno = rowData.Tinvno;
		if (!Tinvno){
			Tinvno = "";
		}
		setValueById('patinvno',Tinvno);
		papnoobj.value = tabRegno;
		setValueById('Name',rowData.Tname);
		setValueById('billtype',rowData.Tbilltype);
		setValueById('decease',rowData.Tdischargestatus);
		//setValueById('Loc', rowData.Tloc);
		patzynoobj.value = rowData.Tpatzyno;
		setValueById('patmedicare',rowData.Tpatzyno);
		//+2018-01-15 ZhYW 
		var deceaseObj = websys_$("decease");
		if (decease != t['23']) {
			deceaseObj.style.color = "red";
		} else {
			deceaseObj.style.color = "black";
		}
		//
		SelectedRow = selectrow;
	} else {
		papnoobj.value = "";
		setValueById('Name', '');
		setValueById('Adm', '');
		billnoobj.value = "";
		depositobj.value = "";
		totalamountobj.value = "";
		amttopayobj.value = "";
		discretamtobj.value = "";
		SelectedRow = "-1";
		Adm = "";
		BillNo = "";
		Tinvno = "";
		billstatus = "";
		setValueById('EpisodeID', '');
		setValueById('PatientID', '');
		setValueById('patmedicare', '');
		patzynoobj.value = "";
		setValueById("decease", "");
		$('#tUDHCJFCASHIER').datagrid('unselectAll');
	}
}

function LinkBillDetail() {
	if ((BillNo == "") || (BillNo == " ")) {
		DHCWeb_HISUIalert("请选择患者");
		return;
	}
	var url = "dhcbill.ipbill.billdtl.csp?&EpisodeID=" + Adm + "&BillRowId=" + BillNo;
	websys_showModal({
		url: url,
		iconCls: 'icon-w-find',
		title: '费用明细查询',
		width: '85%',
		height: '85%'
	})
}

function LinkAddDeposit() {
	if (Adm == "") {
		DHCWeb_HISUIalert(t['03']);
		return;
	}
	var url = "dhcbill.ipbill.deposit.pay.if.csp?EpisodeID=" + Adm;
	websys_showModal({
		url: url,
		title: "交押金",
		iconCls: "icon-w-paid",
		width: "85%",
		height: "85%"
	});
}

function LinkRefundDeposit() {
	if (Adm == "") {
		DHCWeb_HISUIalert(t['03']);
		return;
	}
	//+2018-07-11 ZhYW 
	var rtn = tkMakeServerCall("web.DHCBillPreIPAdmTrans", "CheckRefDeposit", Adm);
	if (+rtn == 1) {
		DHCWeb_HISUIalert('该患者的预住院医嘱存在有效医嘱,不能退押金.');
		return;
	}else if (+rtn == 2) {
		DHCWeb_HISUIalert('该患者由预住院转入门诊的费用未结清,不能退押金.');
		return;
	};
	var url = "dhcbill.ipbill.deposit.refund.if.csp?EpisodeID=" + Adm;
	websys_showModal({
		url: url,
		title: "退押金",
		iconCls: "icon-w-paid",
		width: "85%",
		height: "85%"
	});
}

function getPatInfo() {
	if ((papnoobj.value != "") || (patzynoobj.value != "")) {
		var expStr = session['LOGON.GROUPID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.HOSPID'];
		$.m({
			ClassName: "web.UDHCJFCASHIER",
			MethodName: "GetPatInfo",
			patientNo: papnoobj.value, 
			medicareNo: patzynoobj.value,
			expStr: expStr
		}, function(rtn) {
			if (!rtn) {
				$.messager.popover({msg: "没有此患者信息", type: "info"});
				return;
			}
			var myAry = rtn.split("^");
			papnoobj.value = myAry[0];
			nameobj.value = myAry[1];
			setValueById('Name', myAry[1]);
			setValueById('Adm', myAry[2]);
			Adm = myAry[2];
			setValueById('EpisodeID', myAry[2]);
			patzynoobj.value = myAry[6];
			setValueById("decease", myAry[7]);
			if (myAry[7] != t['23']) {
				document.getElementById("decease").style.color = "red";
			} else {
				document.getElementById("decease").style.color = "black";
			}
			setValueById("PatientID", myAry[14]);
			$('#Find').click();
		});
	}
}

///补打发票
function ReprintFP() {
	var Guser = session['LOGON.USERID'];
	DHCP_GetXMLConfig("InvPrintEncrypt", "DHCJFIPReceipt");
	if ((!Tinvno) || (Tinvno == " ")) {
		DHCWeb_HISUIalert("未选择补打发票的信息或没有补打信息");
		return;
	} else {
		var invrtn = tkMakeServerCall("web.UDHCJFPRINTINV", "GetInvflagByInvno", Tinvno, Guser);
		var prtinvflag = invrtn.split("^")[0];
		var prtinvrowid = invrtn.split("^")[1];
		var InvReasonDR = invrtn.split("^")[2];
		GetXMLName(InvReasonDR);
		if (prtinvflag != 1) {
			DHCWeb_HISUIalert("此发票不能重打");
			return;
		} else {
			$.messager.confirm('提示', '确定要重打发票？',function(r) {
				if (r) {
					var invrtn = tkMakeServerCall("web.UDHCJFPRINTINV", "GetInvflagByInvno", Tinvno, Guser);
					var prtinvflag = invrtn.split("^")[0];
					var prtinvrowid = invrtn.split("^")[1];
					var InvReasonDR = invrtn.split("^")[2];
					var prtinvrowid = prtinvrowid + "#" + "R";  //增加补打标志
					inpatInvPrint(prtinvrowid);
				}
			});
		}
	}
}

function GetXMLName(InvReasonDR) {
	if ((Adm == "") || (BillNo == "")) {
		return;
	}
	if ((Tinvno == "") || (Tinvno == " ")) {
		return;
	}
	GetAdmReaNationCodeByAdm(Adm);
	var XMLName = tkMakeServerCall("web.UDHCJFBaseCommon", "GetInvXMLName", AdmReasonId);
	if (XMLName == "") {
		DHCP_GetXMLConfig("InvPrintEncrypt", "DHCJFIPReceipt");
	} else {
		DHCP_GetXMLConfig("InvPrintEncrypt", XMLName);
	}
}

function GetAdmReaNationCodeByAdm(Adm) {
	var encmeth = getValueById('GetAdmReaNationCode');
	var GetAdmReasonStr = cspRunServerMethod(encmeth, Adm);
	var GetAdmReasonStrDetail = GetAdmReasonStr.split("^");
	AdmReasonId = GetAdmReasonStrDetail[0];
	AdmReasonNationCode = GetAdmReasonStrDetail[1];
}

//hujunbin 选择头菜单
function selectTabBar(preId, newId) {
	if (window.parent) {
		var PreBarObj = window.parent.document.getElementById(preId);
		var menuBarObj = window.parent.document.getElementById(newId);
		if (menuBarObj) {
			var href = menuBarObj.getAttribute("jshref");
			var target = menuBarObj.getAttribute("target");
			var blankOpt = menuBarObj.getAttribute("blankOpt");
			if (href == "#") {
				event.preventDefault();
				event.stopPropagation();
				return false;
			}
			if (menuBarObj) {
				PreBarObj.getAttribute("style")["border-color"] = "";
				PreBarObj.getAttribute("style")["color"] = "";
				PreBarObj.getAttribute("style")["background"] = "";
			}
			if (menuBarObj) {
				//menuBarObj.getAttribute("style")["border-color"] = "#b7d2ff";
				//menuBarObj.getAttribute("style")["color"] = "#ffffff";
				//menuBarObj.getAttribute("style")["background"] = "#1369c0";
			}
			window.location.href = href;
		}
	}
}

function init_Layout(){
	// 布局
	$('td.i-tableborder>table').css("border-spacing", "0px 8px");
	$('.first-col').parent().parent().parent().css('margin-top', '1px');
	$('#PageContent').find('.panel-body-noheader').css('margin-top', '2px');
	$('#cStDate').parent().parent().css('width','72px');
	//固定列头
	$('#tUDHCJFCASHIER').datagrid({
		fitColumns:false,
		autoRowHeight:false,
		frozenColumns:[[
			{
				field:'Tregno',
				title:'登记号',
			}, {
				field:'Tname',
				title:'姓名',
			},
		]],
		onLoadSuccess:function(data){
			$('.datagrid-sort-icon').text(''); // 金额列 文字和金额右对齐
			$('.datagrid-view2').find('td[field=Tregno]').hide();
			$('.datagrid-view2').find('td[field=Tname]').hide();
		}
	});
	
	setValueById("EndDate", getDefStDate(0));
	$('#locator').hide();
	$('#foo').hide();
}

/**
* 初始化卡类型
*/
function initCardType() {
	$HUI.combobox("#OPCardType", {
		panelHeight: 'auto',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array',
		editable: false,
		valueField: 'value',
		textField: 'caption',
		onChange: function (newValue, oldValue) {
			initReadCard(newValue);
		}
	});
}

/**
 * 初始化卡类型时卡号和读卡按钮的变化
 * @method initReadCard
 * @param {String} cardType
 * @author ZhYW
 */
function initReadCard(cardType) {
	try {
		var cardTypeAry = cardType.split("^");
		var readCardMode = cardTypeAry[16];
		if (readCardMode == "Handle") {
			disableById("readcard");
			$("#opcardno").attr("readOnly", false);
		} else {
			enableById("readcard");
			setValueById("opcardno", "");
			$("#opcardno").attr("readOnly", true);
		}
	} catch (e) {
	}
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	try {
		var cardType = getValueById("OPCardType");
		var cardTypeDR = cardType.split("^")[0];
		var myRtn = "";
		if (cardTypeDR == "") {
			myRtn = DHCACC_GetAccInfo();
		} else {
			myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
		}
		var myAry = myRtn.toString().split("^");
		var rtn = myAry[0];
		switch (rtn) {
		case "0":
			setValueById("opcardno", myAry[1]);
			setValueById("Regno", myAry[5]);
			getPatInfo();
			break;
		case "-200":
			$.messager.alert("提示", "读卡失败,卡无效", "info", function() {
				focusById("readcard");
			});
			break;
		case "-201":
			setValueById("opcardno", myAry[1]);
			setValueById("Regno", myAry[5]);
			getPatInfo();
			break;
		default:
		}
	} catch (e) {
	}
}

/**
* 卡号回车事件
*/
function cardNoKeydown(e) {
	try {
		var key = websys_getKey(e);
		if (key == 13) {
			var cardNo = getValueById("opcardno");
			if (!cardNo) {
				return;
			}
			var cardType = getValueById("OPCardType");
			cardNo = formatCardNo(cardType, cardNo);
			var cardTypeAry = cardType.split("^");
			var cardTypeDR = cardTypeAry[0];
			var myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, "", "PatInfo");
			var myAry = myRtn.toString().split("^");
			var rtn = myAry[0];
			switch (rtn) {
			case "0":
				setValueById("opcardno", myAry[1]);
				setValueById("Regno", myAry[5]);
				getPatInfo();
				break;
			case "-200":
				setTimeout(function () {
					$.messager.alert("提示", "卡无效", "info", function() {
						focusById("opcardno");
					});
				}, 10);
				break;
			case '-201':
				setValueById("opcardno", myAry[1]);
				setValueById("Regno", myAry[5]);
				getPatInfo();
				break;
			default:
			}
		}
	} catch (e) {
	}
}