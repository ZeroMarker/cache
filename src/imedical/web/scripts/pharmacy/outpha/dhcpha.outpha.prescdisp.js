/*
 *ģ��:����ҩ��
 *��ģ��:����ҩ��-����Ԥ��ֱ�ӷ�ҩ
 *createdate:2016-10-31
 *creator:yunhaibao
 */
DHCPHA_CONSTANT.DEFAULT.PHLOC = "";
DHCPHA_CONSTANT.DEFAULT.PHUSER = "";
DHCPHA_CONSTANT.DEFAULT.PHPYUSER = "";
DHCPHA_CONSTANT.DEFAULT.PHWINDOW = "";
DHCPHA_CONSTANT.DEFAULT.CYFLAG = "";
DHCPHA_CONSTANT.VAR.TIMER = "";
DHCPHA_CONSTANT.VAR.TIMERSTEP = 1 * 1000;
DHCPHA_CONSTANT.VAR.OUTPHAWAY = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetWayIdByCode", "OA")
var Com_CardPayFlag = tkMakeServerCall("PHA.FACE.IN.Com", "GetCardPayFlag", DHCPHA_CONSTANT.SESSION.GROUP_ROWID,DHCPHA_CONSTANT.SESSION.GHOSP_ROWID);
var PrintType=""
var FocusFlag="";
var PartPiedDispFlag=""
var readCardFlag=0;
var tipNum=0;
var ChkUnFyThisLocFlag="";
var OnlyDispByPatNoFlag = "";
var curPatNo = "";
if (websys_isIE) {  //�����ѵ�������֤����ie���������
	document.write("<script type='text/javascript' src='../scripts/dhcbill/plugin/bluebird/bluebird.min.js'></script>");
}
$(function () {
	CheckPermission();
	var ctloc = DHCPHA_CONSTANT.DEFAULT.LOC.text;
	$("#currentctloc").text(ctloc)
	/* ��ʼ����� start*/
		var daterangeoptions={
		singleDatePicker:true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
	var tmpstartdate = FormatDateT("t-2")
	$("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
	$("#date-start").data('daterangepicker').setEndDate(tmpstartdate);

	InitGridWin();
	InitFYWin();
	InitGridDisp();
	InitBasicLoc();
	InitSpecial();
	InitFYSTAFF();
	InitGirdWAITFY();
	InitConfig();	//��ʼ������
	/* ��Ԫ���¼� start*/
	//�ǼǺŻس��¼�
	$('#txt-patno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txt-patno").val());
			if (patno != "") {
				var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				if(newpatno==""){return;}
				QueryGridDisp();
			}
		}
	});
	//���Żس��¼�
	$('#txt-cardno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var cardno = $.trim($("#txt-cardno").val());
			if (cardno != "") {
				BtnReadCardHandler();
				readCardFlag=1;
			}
		}
	});
	//�������лس��¼�
	$("input[type=text]").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			return false;
		}
	})
	/* ��Ԫ���¼� end*/


	/* �󶨰�ť�¼� start*/
	$("#a-refresh").on("click", QueryGridWaitFY)
	$("#btn-find").on("click", QueryGridDisp);
	$("#btn-clear").on("click", ClearConditions);
	$("#btn-change").on("click", function () {
		$("#modal-windowinfo").modal('show');
	});
	$("#btn-fy").on("click", function(){
		CACert("PHAOPExecuteFY",ExecuteFY);
	});
	$("#btn-reffy").on("click", ExecuteRefuseFY);
	$("#btn-cancelreffy").on("click", CancelRefuseFY);
	$("#btn-allfy").on("click", function(){
		CACert("PHAOPExecuteAllFY",ExecuteAllFY);
	}); 
	$('#btn-print').bind("click", PrintHandler);
	$('#btn-printlabel').on("click", RePrintLabelHandler);
	$("#btn-win-sure").on("click", FYWindowConfirm);
	$("#btn-cardpay").on("click", function(){
		if(Com_CardPayFlag!="Y") {return}  //��ֹ��ݼ�
		CardBillClick();
	})

	$("#btn-redir-return").on("click", function () {
		var lnk = "dhcpha/dhcpha.outpha.return.csp";
		websys_createWindow(lnk, $g("��ҩ"), "width=95%,height=75%")
		//window.open(lnk,"_target","width="+(window.screen.availWidth-50)+",height="+(window.screen.availHeight-100)+ ",left=0,top=0,menubar=no,status=yes,toolbar=no,resizable=yes") ;
	});
	$("#btn-readcard").on("click", BtnReadCardHandler); //����
	/* �󶨰�ť�¼� end*/
	InitBodyStyle();
	//DHCPHA_CONSTANT.VAR.TIMER = setInterval("QueryGridWaitFY();", DHCPHA_CONSTANT.VAR.TIMERSTEP);
	$("#modal-windowinfo").on('shown.bs.modal', function () {
		$('input[type=checkbox][name=dhcphaswitch]').bootstrapSwitch({
			onText: $g("����"),
			offText: $g("����"),
			onColor: "success",
			offColor: "default",
			size: "small",
			onSwitchChange: function (event, state) {
				var ret = ChangeWinStat(state);
				if (ret == false) {
					$(this).bootstrapSwitch('state', !state, true);
				}
			}
		})
		$("#grid-window").setGridWidth($("#modal-windowinfo .div_content").width())
		$("#grid-window").HideJqGridScroll({
			hideType: "X"
		})
	})
	$("#modal-windowinfo").on('hidden.bs.modal', function () {
		Setfocus();
	})
	if(Com_CardPayFlag!="Y"){
		$("#btn-cardpay").attr("style","display:none;");
	}
	HotKeyInit("PrescDisp","grid-disp");
	Setfocus();
})

//��ʼ����ҩtable
function InitGridDisp() {
	var columns = [{
			header:$g("��ҩ״̬"),
			index: 'TPhDispStat',
			name: 'TPhDispStat',
			width: 65,
			cellattr: addPhDispStatCellAttr
		},
		{
			header:$g("����"),
			index: 'TPatName',
			name: 'TPatName',
			width: 100
		},
		{
			header:$g("�ǼǺ�"),
			index: 'TPmiNo',
			name: 'TPmiNo',
			width: 100
		},
		{
			header:$g("�շ�����"),
			index: 'TPrtDate',
			name: 'TPrtDate',
			width: 150
		},
		{
			header:$g("��ҩ"),
			index: 'TPrintFlag',
			name: 'TPrintFlag',
			width: 40,
			hidden: true
		},
		{
			header:$g("��ҩ"),
			index: 'TFyFlag',
			name: 'TFyFlag',
			width: 40,
			hidden: true
		},
		{
			header:$g("������"),
			index: 'TPrescNo',
			name: 'TPrescNo',
			width: 110
		},
		{
			header:$g("�������"),
			index: 'TPrescMoney',
			name: 'TPrescMoney',
			width: 70,
			align: 'right'
		},
		{
			header:$g("����"),
			index: 'TJS',
			name: 'TJS',
			width: 40,
			hidden: true
		},
		{
			header:$g("�ѱ�"),
			index: 'TPrescType',
			name: 'TPrescType',
			width: 70
		},
		{
			header:$g("����"),
			index: 'TWinDesc',
			name: 'TWinDesc',
			width: 60
		},
		{
			header:$g("���"),
			index: 'TMR',
			name: 'TMR',
			width: 200
		},
		{
			header:$g("�Ա�"),
			index: 'TPatSex',
			name: 'TPatSex',
			width: 40
		},
		{
			header:$g("����"),
			index: 'TPatAge',
			name: 'TPatAge',
			width: 40
		},
		{
			header:$g("����"),
			index: 'TPatLoc',
			name: 'TPatLoc',
			width: 100
		},
		{
			header:$g("Э������"),
			index: 'TOrdGroup',
			name: 'TOrdGroup',
			width: 60,
			hidden: true
		},
		{
			header:$g("���տ���"),
			index: 'TRecLocdesc',
			name: 'TRecLocdesc',
			width: 100
		},
		{
			header:$g("���״̬"),
			index: 'TDocSS',
			name: 'TDocSS',
			width: 70
		},
		{
			header:$g("������ҩ"),
			index: 'TPassCheck',
			name: 'TPassCheck',
			width: 70,
			hidden: true
		},
		{
			header: 'TAdm',
			index: 'TAdm',
			name: 'TAdm',
			width: 60,
			hidden: true
		},
		{
			header: 'TPatID',
			index: 'TPatID',
			name: 'TPatID',
			width: 60,
			hidden: true
		},
		{
			header: 'TPatLoc',
			index: 'TPatLoc',
			name: 'TPatLoc',
			width: 60,
			hidden: true
		},
		{
			header: 'TJYType',
			index: 'TJYType',
			name: 'TJYType',
			width: 60,
			hidden: true
		},
		{
			header: 'TCallCode',
			index: 'TCallCode',
			name: 'TCallCode',
			width: 60,
			hidden: true
		},
		{
			header: 'TPatAdd',
			index: 'TPatAdd',
			name: 'TPatAdd',
			width: 60,
			hidden: true
		},
		{
			header: 'TPrescTitle',
			index: 'TPrescTitle',
			name: 'TPrescTitle',
			width: 60,
			hidden: true
		},
		{
			header: 'TUseLocdr',
			index: 'TUseLocdr',
			name: 'TUseLocdr',
			width: 60,
			hidden: true
		},
		{
			header: 'Tphd',
			index: 'Tphd',
			name: 'Tphd',
			width: 60,
			hidden: true
		},
		{
			header: 'TPid',
			index: 'TPid',
			name: 'TPid',
			width: 60,
			hidden: true
		},
		{
			header:$g("�����ܼ�"),
			index: 'TEncryptLevel',
			name: 'TEncryptLevel',
			width: 70,
			hidden: true
		},
		{
			header:$g("���˼���"),
			index: 'TPatLevel',
			name: 'TPatLevel',
			width: 70,
			hidden: true
		}
	];
	var jqOptions = {
		datatype: 'local',
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryDispList&style=jqGrid', //��ѯ��̨	
		height: DhcphaJqGridHeight(2, 3) * 0.5,
		shrinkToFit: false,
		pager: "#jqGridPager", //��ҳ�ؼ���id  
		onSelectRow: function (id, status) {
			QueryGridDispSub();
			var selrowdata = $(this).jqGrid('getRowData', id);
			var prescNo = selrowdata.TPrescNo;
			InitErpMenu(prescNo);
		},
		loadComplete: function () {
			var grid_records = $(this).getGridParam('records');
			if (grid_records == 0) {
				$("#ifrm-presc").attr("src", "");
			} else {
				$(this).jqGrid('setSelection', 1);
			}
			
			var chkdisp=""
			if ($("#chk-disp").is(':checked')) {
				chkdisp = "1";
			}
			if(chkdisp!=1){
				var fyrowdata = $("#grid-disp").jqGrid('getRowData');
				var fygridrows = fyrowdata.length;
				if (fygridrows <= 0) {
					return;
				}
				for (var rowi = 1; rowi <= fygridrows; rowi++) {
					var selrowdata=$("#grid-disp").jqGrid('getRowData', rowi)
					var prescno = selrowdata.TPrescNo;
					if(readCardFlag==1){
						SendOPInfoToMachine("105",prescno,"")
					}

				}
			}
		}
	};
	$("#grid-disp").dhcphaJqGrid(jqOptions);
}

//�к���Ϣ����
function SendMessToVoice(rowIndex) {

	if ((rowIndex == null) || (rowIndex == "")) {
		dhcphaMsgBox.alert($g("û��ѡ������,���ܽк�!"));
		return;
	}
	var selrowdata = $("#grid-waitfy").jqGrid('getRowData', rowIndex);
	var patno = selrowdata.tbpatid;
	var patname = selrowdata.tbname;
	var window = DHCPHA_CONSTANT.DEFAULT.PHWINDOW;
	var serverip = ClientIPAddress;
	var FYUserID = DHCPHA_CONSTANT.DEFAULT.PHUSER;
	var phwQuId=selrowdata.phwQuId;
	if(phwQuId!=""){
		var state="Call"
		var retInfo=tkMakeServerCall("PHA.OP.Queue.OperTab", "UpdQueueState",phwQuId,state); 
	}
	SendOPInfoToMachine("103^107","",patno)			// �к�����	�к�����	

	var SendVoiceRet = tkMakeServerCall("PHA.FACE.IN.Com", "SendMessToVoice", patno, patname, serverip, window, FYUserID)
	QueryGridWaitFY();
}
function PassQueueNo(rowIndex,state){
	if ((rowIndex == null) || (rowIndex == "")) {
		dhcphaMsgBox.alert($g("û��ѡ������,�������!"));
		return;
	}
	var selrowdata = $("#grid-waitfy").jqGrid('getRowData', rowIndex);
	var phwQuId=selrowdata.phwQuId;
	if(phwQuId==""){
		dhcphaMsgBox.alert($g("û�б����Ŷ�,�������!"));
		return;
	}
	var state="Skip"
	var retInfo=tkMakeServerCall("PHA.OP.Queue.OperTab", "UpdQueueState",phwQuId,state); 
	QueryGridWaitFY();
		
}
function CallPatForMat(cellvalue, options, rowObject) {
	//return "<a href='#' onclick='SendMessToVoice(\"" + options.rowId + "\")'><i class='fa fa-bullhorn'></i></a>";
	return "<a onclick='SendMessToVoice(\"" + options.rowId + "\")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/big/ring.png' border=0/></a>"
		+"<a style='margin-left:10px' onclick='PassQueueNo(\"" + options.rowId + "\")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/big/skip_no.png' border=0/></a>";
}
//��ʼ������ҩtable
function InitGirdWAITFY() {
	var columns = [{
			header: ("�к�"),
			index: 'tSendVoice',
			name: 'tSendVoice',
			width: 80,
			cellattr: addtSendVoiceCellAttr,
			formatter: CallPatForMat
		},{
			header:$g("����"),
			index: 'tbname',
			name: 'tbname',
			width: 100
		},
		{
			header:$g("�ǼǺ�"),
			index: 'tbpatid',
			name: 'tbpatid',
			width: 100
		},
		{
			header: ("�ŶӺ�"),
			index: 'queueNo',
			name: 'queueNo',
			width: 100
		},
		{
			header: ("�к�״̬"),
			index: 'callFlag',
			name: 'callFlag',
			width: 100,
			hidden: true
		},
		{
			header: ("�к�id"),
			index: 'phwQuId',
			name: 'phwQuId',
			width: 100,
			hidden: true
		},
		{
			header:$g("�����ܼ�"),
			index: 'TEncryptLevel',
			name: 'TEncryptLevel',
			width: 100,
			hidden: true
		},
		{
			header:$g("���˼���"),
			index: 'TPatLevel',
			name: 'TPatLevel',
			width: 100,
			hidden: true
		},
		{
			header: 'TWarnLevel',
			index: 'TWarnLevel',
			name: 'TWarnLevel',
			width: 100,
			hidden: true
		}
	];
	var jqOptions = {
		datatype: 'local',
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryNeedFYList&style=jqGrid',
		height: DhcphaJqGridHeight(2, 3) * 0.5,
		shrinkToFit: false,
		onSelectRow: function (id, status) {
			var selrowdata = $(this).jqGrid('getRowData', id);
			var patno = selrowdata.tbpatid;
			$("#txt-patno").val(patno);
			QueryGridDisp();
		},
		gridComplete: function () {
			var ids = $("#grid-waitfy").jqGrid("getDataIDs");
			var rowDatas = $("#grid-waitfy").jqGrid("getRowData");
			for (var i = 0; i < rowDatas.length; i++) {
				var rowData = rowDatas[i];
				var warnLevel = rowData.TWarnLevel;
				if ((warnLevel.indexOf($g("��")) >= 0) || (warnLevel.indexOf($g("��")) >= 0)) {
					$("#grid-waitfy" + " #" + ids[i] + " td").css({
						color: '#FF6356',
						'font-weight': 'bold'
					});
				}
			}
			return true;
		}
	};
	$("#grid-waitfy").dhcphaJqGrid(jqOptions);
}
//��ѯ����ҩtable
function QueryGridWaitFY() {
	var stdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var params = DHCPHA_CONSTANT.DEFAULT.PHLOC + "^" + DHCPHA_CONSTANT.DEFAULT.PHWINDOW + "^" + 1 + "^" + stdate + "^" + enddate;
	$("#grid-waitfy").setGridParam({
		datatype: 'json',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");
	if ((DHCPHA_CONSTANT.DEFAULT.PHLOC != "") && (DHCPHA_CONSTANT.DEFAULT.PHWINDOW != "")) {
		clearTimeout(DHCPHA_CONSTANT.VAR.TIMER);
	}
}

//��ʼ����������
function InitBasicLoc() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
			'?action=GetBasicLocList&style=select2',
		placeholder: $g("��������"),
		minimumResultsForSearch: Infinity

	}
	$("#sel-basicloc").dhcphaSelect(selectoption)
	$('#sel-basicloc').on('select2:select', function (event) {
		//alert(event)
	});
}
//��ʼ��������
function InitSpecial() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
			'?action=GetEMLocList&style=select2',
		placeholder: $g("���ۿ���"),
		minimumResultsForSearch: Infinity
	}
	$("#sel-special").dhcphaSelect(selectoption)
	$('#sel-special').on('select2:select', function (event) {
		//alert(event)
	});
}
//��ѯ��ҩ�б�
function QueryGridDisp() {
	curPatNo = "";
	ClearErpMenu();
	ChkUnFyOtherLoc();
	var stdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var chkdisp = "";
	if ($("#chk-disp").is(':checked')) {
		chkdisp = "1";
	}
	var patno = $("#txt-patno").val();
	var GPhl = DHCPHA_CONSTANT.DEFAULT.PHLOC;
	var GPhw = DHCPHA_CONSTANT.DEFAULT.PHWINDOW; //������ҩ���ڵ�ID
	var CPatName = "";
	var basicloc = $("#sel-basicloc").val();
	if (basicloc == null) {
		basicloc = "";
	}
	var emloc = $("#sel-special").val();
	if (emloc == null) {
		emloc = "";
	}
	if((OnlyDispByPatNoFlag =="Y")&&(patno=="")&&(basicloc=="")&&(emloc=="")&&(chkdisp!="1")){
		dhcphaMsgBox.alert($g("���������ҩ����/���ۿ���/������Ϣ���ѯ!"));
		return;
	 }
	 curPatNo = patno;
	var params = stdate + "^" + enddate + "^" + GPhl + "^" + GPhw + "^" + patno + "^" + CPatName + "^" + chkdisp + "^" + emloc + "^" + basicloc;
	$("#grid-disp").setGridParam({
		datatype: 'json',
		postData: {
			'params': params
		},
		page:1
	}).trigger("reloadGrid");
	$("#ifrm-presc").attr("src", "");
	readCardFlag=0;
	Setfocus();
}
//��ѯ��ҩ��ϸ
function QueryGridDispSub() {
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	var prescNo = selrowdata.TPrescNo;
	var cyflag = DHCPHA_CONSTANT.DEFAULT.CYFLAG;
	var dispFlag = selrowdata.TFyFlag;
	var phartype = "OP";		// ��������
	var zfFlag = "�׷�"
	if (dispFlag !== "OK"){
		var useFlag = "3" 		// δ��ҩ
	}
	else {
		var useFlag = "4"		// �ѷ�ҩ
	}
	
	PHA_PRESC.PREVIEW({
		prescNo: prescNo,			
		preAdmType: phartype,
		zfFlag: zfFlag,
		prtType: 'DISPPREVIEW',
		useFlag: useFlag,
		iframeID: 'ifrm-presc',
		cyFlag: cyflag
	});
	

	//$("#ifrm-presc").attr("src", ChangeCspPathToAll("dhcpha/dhcpha.common.prescpreview.csp") + "?paramsstr=" + paramsstr + "&PrtType=DISPPREVIEW");
	
}
// ִ�з�ҩ
function ExecuteFY() {
	if (DhcphaGridIsEmpty("#grid-disp") == true) {
		return;
	}
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert($g("û��ѡ������,���ܷ�ҩ!"));
		return;
	}
	var basicloc = $("#sel-basicloc").val();
	if (basicloc == null) {
		basicloc = "";
	}
	if (basicloc != "") {
		dhcphaMsgBox.alert($g("��ѡ��ļ�¼Ϊ����ҩ,��ʹ��ȫ���������ɲ�����!"))
		return;
	}
	ChkUnFyThisLocFlag="0"
	//DispensingMonitor(selectid);
	CheckPayment(selectid);
	var nextSelectid=parseInt(selectid)+1
	var rowDatas = $("#grid-disp").jqGrid("getRowData");
	if(nextSelectid<=rowDatas.length)
	{
    	$("#grid-disp").setSelection(nextSelectid);
    }
	if (ChkUnFyThisLocFlag=="1") ChkUnFyThisLoc(1);
	//ChkUnFyOtherLoc();
	QueryGridWaitFY();
	Setfocus();
}

//ִ��ȫ��
function ExecuteAllFY() {
	var fyrowdata = $("#grid-disp").jqGrid('getRowData');
	var fygridrows = fyrowdata.length;
	if (fygridrows <= 0) {
		dhcphaMsgBox.alert($g("û������!"));
		return;
	}
	// ȫ��ǰ�򵥼���������
	var retFlag = ChkDataBeforeALLFY()
	if(retFlag==false){
		dhcphaMsgBox.alert($g("��ǰ���������У����ѷ����ݣ������²�ѯ�����ԣ�"), "error");
		return;
	}
	//���Ż���ҩƷ,��������ҩ�����嵥
	var firstrowdata = $("#grid-disp").jqGrid("getRowData", 1);
	var uselocdr = firstrowdata.TUseLocdr;
	if (uselocdr == undefined) {
		uselocdr = "";
	}
	
	if (uselocdr != "") {
		dhcphaMsgBox.confirm($g("ȷ��ȫ����?ϵͳ��ȫ�����Ų�ѯ�������д������������ɲ�����!"), ConfirmDispBasic);
	} else {
		if ((IsOnlyOnePatno() == false)){
			if (OnlyDispByPatNoFlag = 'Y') {
				dhcphaMsgBox.alert($g("������ߴ���������ʹ��ȫ��!"), "warn");	
				return;
			}
			var warntitle = $g("���ڶ�����ߵĴ���ȷ��ȫ����?ϵͳ��ȫ�����Ų�ѯ�������д���!")
		}else {
			var warntitle = $g("ȷ��ȫ����?ϵͳ��ȫ�����Ų�ѯ�������д���!")
		}
		dhcphaMsgBox.confirm($g(warntitle), ConfirmDispAll);
	}
	Setfocus();
}

function ConfirmDispBasic(result) {
	if (result == true) {
		var firstrowdata = $("#grid-disp").jqGrid("getRowData", 1);
		var pid = firstrowdata.TPid;
		var RetInfo = tkMakeServerCall("PHA.OP.Supply.OperTab", "SaveSupData", pid, DHCPHA_CONSTANT.DEFAULT.PHUSER, DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHPYUSER, DHCPHA_CONSTANT.DEFAULT.PHWINDOW);
		var retarr = RetInfo.split("^");
		var retval = retarr[0];
		var retmessage = retarr[1];
		if (retval > 0) {
			PrintSupp(retval)
			QueryGridDisp();
		} else {
			dhcphaMsgBox.alert($g("����ҩƷ��ҩʧ��,�������:") + retmessage, "error");
		}
	}
}

function ConfirmDispAll(result) {
	if (result == true) {
		var fyrowdata = $("#grid-disp").jqGrid('getRowData');
		var fygridrows = fyrowdata.length;
		tipNum=0;
		for (var rowi = 1; rowi <= fygridrows; rowi++) {
			//DispensingMonitor(rowi);
			CheckPayment(rowi);
			if(tipNum>0){return}
		}
		ChkUnFyThisLoc(fygridrows);
		QueryGridWaitFY();
	}
}

/* ����շ���� */
function CheckPayment(rowid){
	var selectrow = $("#grid-disp").jqGrid('getRowData', rowid);
	var prescNo = selectrow.TPrescNo;
	/* ��ȡ�����е�δ����ҽ����Ϣ */
	var unPaidInfo = GetUnPaidOrder(prescNo)
		/* ����δ����ʱ�Ƿ�����ҩ */
	if (unPaidInfo !== ""){
		if (PartPiedDispFlag == "Y") {
			dhcphaMsgBox.confirm(prescNo + $g("�д���δ���ѵ�ҽ����ϸ!ҽ������Ϊ:") + "<br/>" + unPaidInfo + "<br/>" + $g("���[ȷ��]��������ҩ�����[ȡ��]��������ҩ������"), function (r) {
				if (r == true) {
					DispensingMonitor(rowid);
				} else {
					return;
				}
			});
		}
		else {
			dhcphaMsgBox.alert(prescNo + $g("�д���δ���ѵ�ҽ����ϸ,��ֹ��ҩ!ҽ������Ϊ:") + "<br/>" + unPaidInfo);
			return;
		}
	}
	else{
		DispensingMonitor(rowid);	
	}
		
}

function DispensingMonitor(rowid) {
	var selrowdata = $("#grid-disp").jqGrid('getRowData', rowid);
	var prescno = selrowdata.TPrescNo;
	var fyflag = selrowdata.TFyFlag;
	var patname = selrowdata.TPatName;
	var warnmsgtitle = $g("��������:") + patname + "<br/>" + $g("������:") + prescno + "<br/>"
	if (fyflag == "OK") {
		dhcphaMsgBox.alert(warnmsgtitle + $g("�ü�¼�Ѿ���ҩ!"));
		return;
	}
	var checkprescadt = GetOrdAuditResultByPresc(prescno)
	if (checkprescadt == "") {
		dhcphaMsgBox.alert(warnmsgtitle + $g("�������!"));
		return;
	} else if (checkprescadt == "N") {
		dhcphaMsgBox.alert(warnmsgtitle + $g("��˲�ͨ��,������ҩ!"));
		return;
	} else if (checkprescadt == "S") {
		if (!confirm(warnmsgtitle + $g("�ô���ҽ�����ύ����")+"\n"+$g("���'ȷ��'��ͬ�����߼�����ҩ�����'ȡ��'��������ҩ������"))) {
			return;
		}
	}
	var checkprescref = GetOrdRefResultByPresc(prescno)
	if (checkprescref == "N") {
		dhcphaMsgBox.alert(warnmsgtitle + $g("�ô����ѱ��ܾ�,��ֹ��ҩ!"));
		return;
	} else if (checkprescref == "A") {
		dhcphaMsgBox.alert(warnmsgtitle + $g("�ô����ѱ��ܾ�,��ֹ��ҩ!"));
		return;
	} else if (checkprescref == "S") {
		dhcphaMsgBox.confirm(warnmsgtitle + $g("�ô���ҽ�����ύ����")+"<br/>"+$g("���[ȷ��]��ͬ�����߼�����ҩ�����[ȡ��]��������ҩ������"), function (r) {
			if (r == true) {
				var cancelrefuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "CancelRefuse", DHCPHA_CONSTANT.SESSION.GUSER_ROWID, prescno, "OR"); //���ߺ�ҩӦ�ȳ����ܾ�
				ExecuteDisp(rowid, prescno);
			} else {
				return;
			}
		});
	} else {
		ExecuteDisp(rowid, prescno);
	}

}

function ExecuteDisp(rowid, prescno) {
	var RetInfo = tkMakeServerCall("PHA.OP.DirDisp.OperTab", "SaveDispData", DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHWINDOW, DHCPHA_CONSTANT.DEFAULT.PHPYUSER, DHCPHA_CONSTANT.DEFAULT.PHUSER, prescno);
	var retarr = RetInfo.split("^");
	var retval = retarr[0];
	var retmessage = retarr[1];
	if (retval > 0) {
		var bgcolor = $(".dhcpha-record-disped").css("background-color");
		var cssprop = {
			background: bgcolor,
			color: 'black'
		};
		$("#grid-disp").setCell(rowid, 'TFyFlag', 'OK');
		$("#grid-disp").setCell(rowid, 'Tphd', retval);
		$("#grid-disp").setCell(rowid, 'TPhDispStat', $g("�ѷ�ҩ"), cssprop);
		AfterExecPrint(prescno,PrintType,retval);
		SendOPInfoToMachine("104^108^110",prescno,"");			//104��ҩ��� 108��ҩʱ���� 110���ͻ�(����״̬)
		ChkUnFyThisLocFlag="1"
	} else {
		dhcphaMsgBox.alert($g(retmessage));
		tipNum=tipNum+1;
		return;
	}
}

// ִ�оܾ���ҩ
function ExecuteRefuseFY() {
	if (DhcphaGridIsEmpty("#grid-disp") == true) {
		return;
	}
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert($g("û��ѡ������,���ܾܾ���ҩ!"));
		return;
	}
	var fyflag = selrowdata.TFyFlag;
	if (fyflag == "OK") {
		dhcphaMsgBox.alert($g("�����ѷ�ҩ�����ܾܾ�!"));
		return;
	}
	var prescno = selrowdata.TPrescNo;
	if (prescno == "") {
		dhcphaMsgBox.alert($g("��ѡ��Ҫ�ܾ��Ĵ���"));
		return;
	}
	var checkprescref = GetOrdRefResultByPresc(prescno); //LiangQiang 2014-12-22  �����ܾ�
	if (checkprescref == "N") {
		dhcphaMsgBox.alert($g("�ô����ѱ��ܾ�,�����ظ�����!"));
		return;
	} else if (checkprescref == "A") {
		dhcphaMsgBox.alert($g("�ô����ѱ��ܾ�,�����ظ�����!"));
		return;
	}
	var checkprescadt = GetOrdAuditResultByPresc(prescno);
	if (checkprescadt == "") {
		dhcphaMsgBox.alert($g("�ô���δ���,��ֹ����!"));
		return;
	} else if (checkprescadt != "Y") {
		dhcphaMsgBox.alert($g("�ô������δͨ��,��ֹ����!"));
		return;
	}

	var waycode=DHCPHA_CONSTANT.VAR.OUTPHAWAY;
	ShowPHAPRASelReason({
		wayId:waycode,
		oeori:"",
		prescNo:prescno,
		selType:"PRESCNO"
	},SaveCommontResultEX,{prescno:prescno});
}

function SaveCommontResultEX(reasonStr,origOpts){
	if (reasonStr==""){
		return "";
	}
    var retarr = reasonStr.split("@");
    var ret = "N";
    var reasondr = retarr[0];
    var advicetxt = retarr[2];
    var factxt = retarr[1];
    var phnote = retarr[3];
    var input = ret + "^" + DHCPHA_CONSTANT.SESSION.GUSER_ROWID + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + DHCPHA_CONSTANT.SESSION.GROUP_ROWID + "^" + origOpts.prescno + "^OR" //orditm;	
    var refuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "SaveOPAuditResult", reasondr, input);
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');

	if (refuseret == 0) {
		var newdata = {
			TDocSS: $g("�ܾ���ҩ")
		};
		$("#grid-disp").jqGrid('setRowData', selectid, newdata);
		if (top && top.HideExecMsgWin) {
			top.HideExecMsgWin();
		}
	} else {
		dhcphaMsgBox.alert($g("�ܾ�ʧ��!�������:") + refuseret)
		return;
	}

}
// �����ܾ���ҩ
function CancelRefuseFY() {
	if (DhcphaGridIsEmpty("#grid-disp") == true) {
		return;
	}
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert($g("û��ѡ������,���ܳ����ܾ���ҩ!"));
		return;
	}
	var fyflag = selrowdata.TFyFlag;
	var prescno = selrowdata.TPrescNo;
	if (fyflag == "OK") {
		dhcphaMsgBox.alert($g("�ü�¼�Ѿ���ҩ!"));
		return;
	}
	if (prescno == "") {
		dhcphaMsgBox.alert($g("��ѡ��Ҫ�����ܾ��Ĵ���"));
		return;
	}
	var checkprescref = GetOrdRefResultByPresc(prescno); //LiangQiang 2014-12-22  �����ܾ�
	if ((checkprescref != "N") && (checkprescref != "A")) {
		if (checkprescref == "S") {
			dhcphaMsgBox.alert($g("�ô���ҽ�����ύ����,����Ҫ����!"))
			return;
		} else {
			dhcphaMsgBox.alert($g("�ô���δ���ܾ�,���ܳ�������!"))
			return;
		}
	}
	var cancelrefuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "CancelRefuse", DHCPHA_CONSTANT.SESSION.GUSER_ROWID, prescno, "OR");
	if (cancelrefuseret == "0") {
		var PrescResult = GetPrescResult(prescno);
		var newdata = {
			TDocSS: PrescResult
		};
		$("#grid-disp").jqGrid('setRowData', selectid, newdata);
		dhcphaMsgBox.alert($g("�����ɹ�!"), "success");
	} else if (cancelrefuseret == "-2") {
		dhcphaMsgBox.alert($g("�ô���δ���ܾ�,���ܳ�������!"));
	} else if (retval == "-3") {
		dhcphaMsgBox.alert($g("�ô����ѳ���,�����ٴγ���!"));
	}
}
//��ȡ�����ܾ���� 
function GetOrdRefResultByPresc(prescno) {
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdRefResultByPresc", prescno);
	return ref;
}
//��ȡ������˽�� 
function GetOrdAuditResultByPresc(prescno) {
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdAuditResultByPresc", prescno);
	return ref;
}
//��ȡ�ܾ���ҩ�ʹ�����˽�� 
function GetPrescResult(prescno) {
	var ref = tkMakeServerCall("web.DHCOUTPHA.Common.CommonDisp", "GetPrescAuditFlag", prescno);
	return ref;
}
//��ȡ������δ����ҽ����ϸ
function GetUnPaidOrder(prescno) {
	var ref = tkMakeServerCall("PHA.OP.COM.Method", "GetUnPaidInfo", prescno);
	return ref;
}
//��ȡ��������δ��ҩ��¼,��������ҩʱ
function ChkUnFyOtherLoc() {
	var LocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var GroupId = DHCPHA_CONSTANT.SESSION.GROUP_ROWID;
	var UserId = DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
	var ChkOtherLocUnFyRet = tkMakeServerCall("PHA.OP.COM.Method","GetSingleProp",GroupId,LocId,UserId,"ChkUnDispOtherLoc")
	if (ChkOtherLocUnFyRet!="Y") return;
	
	var startdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var patno = $("#txt-patno").val();
	if ((patno == "") || (patno == null)) {
		return;
	}
	var ret = tkMakeServerCall("PHA.OP.COM.Method", "ChkUnFyOtherLoc", startdate, enddate, patno, DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHWINDOW,1)
	if (ret == -1) {
		//alert("����Ϊ��,�����")
	} else if (ret == -2) {
		dhcphaMsgBox.alert($g("û�ҵ��ǼǺ�Ϊ") + patno + $g("�Ĳ���"));
		return;

	} else if ((ret != "") && (ret != null)) {
		//dhcphaMsgBox.message(ret);
		dhcphaMsgBox.alert(ret);
	}
}
//�ش��ǩ
function RePrintLabelHandler() {
	if (DhcphaGridIsEmpty("#grid-disp") == true) {
		return;
	}
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert($g("û��ѡ������,�޷���ӡ!"));
		return;
	}
	var prescno = selrowdata.TPrescNo;
	OUTPHA_PRINTCOM.Label(prescno);
}

//��ӡ
function PrintHandler() {
	if (DhcphaGridIsEmpty("#grid-disp") == true) {
		return;
	}
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert($g("û��ѡ������,�޷���ӡ!"));
		return;
	}
	var phdrow = selrowdata.Tphd;
	var prescno = selrowdata.TPrescNo;
	//AfterExecPrint(prescno,PrintType,phdrow,"")
	//����
	OUTPHA_PRINTCOM.Presc(prescno, $g("����"), "");
}

//���
function ClearConditions() {
	$("#txt-patno").val("");
	$("#txt-cardno").val("");
	$('#chk-disp').iCheck('uncheck');
	$("#grid-disp").clearJqGrid();
	$("#ifrm-presc").attr("src", "");
	$("#sel-basicloc").empty();
	$("#sel-special").empty();
	var tmpstartdate = FormatDateT("t-2")
	$("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
	$("#date-start").data('daterangepicker').setEndDate(tmpstartdate);
	$("#date-end").data('daterangepicker').setStartDate(new Date());
	$("#date-end").data('daterangepicker').setEndDate(new Date());
	QueryGridWaitFY();
	ClearErpMenu();
	return
	if ($("#col-right").is(":hidden") == false) {
		$("#col-right").hide();
		$("#col-left").removeClass("col-lg-9 col-md-9 col-sm-9")
	} else {
		$("#col-right").show()
		$("#col-left").addClass("col-lg-9 col-md-9 col-sm-9")
	}
	$("#grid-disp").setGridWidth("")
	$("#grid-dispdetail").setGridWidth("")
	$("#grid-waitfy").setGridWidth("")
}

//��ʼ����ҩ����table
function InitGridWin() {
	var columns = [{
			header:$g("ҩ������"),
			index: 'phwWinDesc',
			name: 'phwWinDesc'
		},
		{
			header:$g("����״̬"),
			index: 'phwWinStat',
			name: 'phwWinStat',
			formatter: statusFormatter,
			title: false
		},
		{
			header: 'phwid',
			index: 'phwid',
			name: 'phwid',
			width: 20,
			hidden: true
		},
		{
			header: 'phwpid',
			index: 'phwpid',
			name: 'phwpid',
			width: 20,
			hidden: true
		}
	];
	var jqOptions = {
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryDispWinList&gLocId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + '',
		height: '100%',
		autowidth: true,
		loadComplete: function () {

		}
	};
	$("#grid-window").dhcphaJqGrid(jqOptions);
}

function statusFormatter(cellvalue, options, rowdata) {
	if (cellvalue == "����") {
		return '<input name="dhcphaswitch" type="checkbox" checked> '
	} else {
		return '<input name="dhcphaswitch" type="checkbox" unchecked> '
	}
}

function ChangeWinStat(state) {
	var wintd = $(event.target).closest("td");
	var rowid = $(wintd).closest("tr.jqgrow").attr("id");
	var selrowdata = $("#grid-window").jqGrid('getRowData', rowid);
	var phwpid = selrowdata.phwpid;
	var phwid= selrowdata.phwid
	var phwWinStat = state;
	var winstat = "";
	if (phwWinStat == true) {
		phwWinStat = "1";
	} else {
		phwWinStat = "0";
	}
	var paramStr=DHCPHA_CONSTANT.SESSION.GROUP_ROWID+"^"+DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID+"^"+DHCPHA_CONSTANT.SESSION.GUSER_ROWID+"^"+DHCPHA_CONSTANT.SESSION.GHOSP_ROWID;
	var modifyret = tkMakeServerCall("PHA.OP.CfDispWin.OperTab", "UpdWinDoFlag", phwid, phwWinStat,paramStr);
	if (modifyret == 0) {
		return true;
	} else if (modifyret == -11) {
		dhcphaMsgBox.alert($g("��ȷ������һ������Ϊ����״̬!"));
		return false;
	} else {
		dhcphaMsgBox.alert($g("�޸Ĵ���״̬ʧ��,�������:") + modifyret, "error");
		return false;
	}
}

//��ҩ����ȷ��
function FYWindowConfirm() {
	var pyusr = DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var fywindata = $("#sel-window").select2("data")[0];
	var fystaffdata = $("#sel-staff").select2("data")[0];
	if (fywindata == undefined) {
		dhcphaMsgBox.alert($g("��ҩ���ڲ���Ϊ��!"));
		return false;
	}
	if (fystaffdata == undefined) {
		dhcphaMsgBox.alert($g("��ҩ�˲���Ϊ��!"));
		return false;
	}
	var fywin = fywindata.id;
	var fywindesc = fywindata.text;
	var fystaff = fystaffdata.id;
	var fystaffdesc = fystaffdata.text;
	$('#modal-windowinfo').modal('hide');
	$("#currentwin").text("");
	$("#currentwin").text(fywindesc);
	DHCPHA_CONSTANT.DEFAULT.PHWINDOW = fywin;
	$("#currentpyuser").text("");
	$("#currentpyuser").text(fystaffdesc);
	DHCPHA_CONSTANT.DEFAULT.PHPYUSER = fystaff;
	var phcookieinfo = fywin + "^" + fywindesc + "^" + fystaff + "^" + fystaffdesc;
	removeCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^disp");
	setCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^disp", phcookieinfo);
	ClearConditions();
	return false;
}

//Ȩ����֤
function CheckPermission() {
	$.ajax({
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=CheckPermission' +
			'&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID +
			'&gUserId=' + DHCPHA_CONSTANT.SESSION.GUSER_ROWID +
			'&gLocId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		type: 'post',
		success: function (data) {
			var retjson = eval("(" + data + ")");
			var retdata = retjson[0];
			var permissionmsg = "",
				permissioninfo = "";
			if (retdata.phloc == "") {
				permissionmsg = $g("ҩ������")+":" + DHCPHA_CONSTANT.DEFAULT.LOC.text;
				permissioninfo = $g("��δ������ҩ���������õ���ԱȨ��ҳǩ��ά��!")
			} else {
				permissionmsg = $g("����")+":" + DHCPHA_CONSTANT.SESSION.GUSER_CODE + "����"+$g("����")+":" + DHCPHA_CONSTANT.SESSION.GUSER_NAME;
				if (retdata.phuser == "") {
					permissioninfo = $g("��δ������ҩ���������õ���ԱȨ��ҳǩ��ά��!")
				} else if (retdata.phnouse == "Y") {
					permissioninfo = $g("����ҩ���������õ���ԱȨ��ҳǩ��������Ϊ��Ч!")
				} else if (retdata.phfy != "Y") {
					permissioninfo = $g("����ҩ���������õ���ԱȨ��ҳǩ��δ���÷�ҩȨ��!")
				}
			}
			if (permissioninfo != "") {
				$('#modal-dhcpha-permission').modal({
					backdrop: 'static',
					keyboard: false
				}); //���ɫ���򲻹ر�
				$('#modal-dhcpha-permission').on('show.bs.modal', function () {
					$("#lb-permission").text(permissionmsg)
					$("#lb-permissioninfo").text(permissioninfo)

				})
				$("#modal-dhcpha-permission").modal('show');
			} else {
				DHCPHA_CONSTANT.DEFAULT.PHLOC = retdata.phloc;
				DHCPHA_CONSTANT.DEFAULT.PHUSER = retdata.phuser;
				DHCPHA_CONSTANT.DEFAULT.CYFLAG = retdata.phcy;
				var getphcookie = getCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^disp");
				if (getphcookie != "") {
					$("#currentwin").text(getphcookie.split("^")[1]);
					DHCPHA_CONSTANT.DEFAULT.PHWINDOW = getphcookie.split("^")[0];
					$("#currentpyuser").text(getphcookie.split("^")[3]);
					DHCPHA_CONSTANT.DEFAULT.PHPYUSER = getphcookie.split("^")[2];
					QueryGridWaitFY();
				} else {
					$("#modal-windowinfo").modal('show');
				}
				$('#modal-windowinfo').on('show.bs.modal', function () {
					$("#sel-window ").empty();
					$("#sel-staff ").empty();
				})
			}
			if (DHCPHA_CONSTANT.DEFAULT.CYFLAG == "Y") {
				$("#grid-disp").setGridParam().showCol("TJS");
				$("#grid-disp").setGridParam().showCol("TOrdGroup");
			}
			
		},
		error: function () {}
	})
}
//��ʼ����ҩ����
function InitFYWin() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
			"?action=GetFYWinList&style=select2&gLocId=" +
			DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		minimumResultsForSearch: Infinity
	}
	$("#sel-window").dhcphaSelect(selectoption)
}
//��ʼ����ҩ��Ա
function InitFYSTAFF() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
			"?action=GetPYUserList&style=select2" + '&gLocId=' +
			DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + '&gUserId=' +
			DHCPHA_CONSTANT.SESSION.GUSER_ROWID + "&flag=PY",
		minimumResultsForSearch: Infinity
	}
	$("#sel-staff").dhcphaSelect(selectoption)
}

function InitBodyStyle() {

	$("#grid-waitfy").setGridWidth("");
	var height1 = $("[class='container-fluid dhcpha-condition-container']").height();
	var height3 = parseFloat($("[class='panel div_content']").css('margin-top'));
	var height4 = parseFloat($("[class='panel div_content']").css('margin-bottom'));
	var height5 = parseFloat($("[class='panel-heading']").height());
	var tableheight = $(window).height() - height1 * 2 - height3 - height4 - height5 - 11;
	$("#ifrm-presc").height(tableheight);
	var dbLayoutWidth = $("[class='panel div_content']").width();
	var dbLayoutCss = {
		width: dbLayoutWidth,
		height: tableheight
	};
	$("#dbLayout").css(dbLayoutCss);
	$("#divReport").css(dbLayoutCss);
}
function addtSendVoiceCellAttr(rowId, val, rawObject, cm, rdata) {
	var callFlag=rawObject.callFlag
	if (callFlag =="0") {
		return "class=dhcpha-record-call";
	}else if (callFlag == "3") {
		return "class=dhcpha-record-skip";
	}else if (callFlag == "5") {
		return "class=dhcpha-record-unqueue";
	}else {
		return "";
	}
}
function addPhDispStatCellAttr(rowId, val, rawObject, cm, rdata) {
	if (val == $g("����ҩ")) {
		return "class=dhcpha-record-pyed";
	} else if (val == $g("�Ѵ�ӡ")) {
		return "class=dhcpha-record-printed";
	} else if (val == $g("�ѷ�ҩ")) {
		return "class=dhcpha-record-disped";
	} else {
		return "";
	}
}

function addPhDispItmStatCellAttr(rowId, val, rawObject, cm, rdata) {
	if (val == $g("��治��")) {
		return "class=dhcpha-record-nostock";
	} else if ((val.indexOf($g("����")) > 0) || (val.indexOf($g("ֹͣ")) > 0)) {
		return "class=dhcpha-record-ordstop";
	} else {
		return "";
	}
}
//����
function BtnReadCardHandler() {
	var readcardoptions = {
		CardTypeId: "txt-cardtype",
		CardNoId: "txt-cardno",
		PatNoId: "txt-patno"
	}
	DhcphaReadCardCommon(readcardoptions, ReadCardReturn)
}
//�������ز���
function ReadCardReturn() {
	QueryGridDisp();
}
function InitConfig(){
	var CongigStr= tkMakeServerCall("PHA.OP.COM.Method", "GetParamProp", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID)
	if(CongigStr!=""){
		var arr=CongigStr.split("^");
		if(arr.length>=14){
			PrintType=arr[10];
			FocusFlag=arr[12];
			PartPiedDispFlag=arr[13];
			OnlyDispByPatNoFlag = arr[15];
		}
	}
}

//������
function CardBillClick(){	
	var readcardoptions = {
		CardTypeId: "txt-cardtype",
		CardNoId: "txt-cardno",
		PatNoId: "txt-patno"
	}
	DhcphaReadCardCommon(readcardoptions, CardPay)
}
function CardPay(){
	
	var startdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var carpayoptions = {
		CardTypeId: "txt-cardtype",
		CardNoId: "txt-cardno",
		PatNoId: "txt-patno",
		StDate:startdate,
		EndDate:enddate
	}	
	DhcCardPayCommon(carpayoptions,QueryGridDisp);	
}
function SendOPInfoToMachine(faceCode,prescNo,patNo)
{
	if(prescNo==undefined){
		prescNo=""
	}
	if(patNo==undefined){patNo="";}
	var paramStr = {
        faceCode:faceCode,
        prescNo: prescNo,
        patNo:patNo
    };
    DoOPInterfaceCom(paramStr)
}
function Setfocus()
{
	$("#txt-patno").val("");
	$("#txt-cardno").val("");

	if(FocusFlag==1){
		$('#txt-cardno').focus();
	}
	else{
		$('#txt-patno').focus();
	}
}
function ChkUnFyThisLoc(dspPrescNum)
{
	var PatNo=curPatNo
	var LocId=DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
    var GroupId=DHCPHA_CONSTANT.SESSION.GROUP_ROWID;
    var UserId=DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
	var ChkUnFyRet=tkMakeServerCall("PHA.OP.COM.Method","GetSingleProp",GroupId,LocId,UserId,"ChkUnDispPrescNum")
	if (ChkUnFyRet!="Y") return;
   
	var fyrowdata = $("#grid-disp").jqGrid('getRowData');
	var fygridrows = fyrowdata.length;	 
	if(dspPrescNum!=1){
	   var successNum=0;
	   for (var rowi = 1; rowi <= fygridrows; rowi++) {
		   rowdata = fyrowdata[rowi-1]
		   var okFlag = rowdata.TFyFlag;		 
		   if(okFlag == "OK")successNum = successNum + 1
	   }
	   dspPrescNum = successNum;
   }
    var GPhl=DHCPHA_CONSTANT.DEFAULT.PHLOC;
	var GPhw = DHCPHA_CONSTANT.DEFAULT.PHWINDOW;
	var StDate = $("#date-start").val();
	var EndDate = $("#date-end").val();
    
	if (PatNo!=""){
		var unDspNum=tkMakeServerCall("PHA.OP.COM.Method","ChkUnFyThisLoc",StDate,EndDate,PatNo,GPhl)
		var otherLocRet=tkMakeServerCall("PHA.OP.COM.Method","ChkUnFyOtherLoc",StDate,EndDate,PatNo,GPhl,GPhw, "1")
		if (unDspNum<0) unDspNum=0
		if (unDspNum>=0) { 
			var prescNum = parseInt(unDspNum) + dspPrescNum;
			var alertMsg=$g("�û��߱��ξ��ﹲ�ɷѴ�����������")+prescNum+"<br>"+$g("�˴η�ҩ��������")+dspPrescNum+"</br>"+$g("������������")+unDspNum
			if (otherLocRet!="") alertMsg=alertMsg +"</br>"+otherLocRet
			dhcphaMsgBox.alert(alertMsg)
		}
		else  if (otherLocRet!="") {
			dhcphaMsgBox.alert(otherLocRet)
		}
	}else  {
	   dhcphaMsgBox.alert($g("�˴η�ҩ��������")+dspPrescNum)
	}
}
// add by zhaoxinlong  2022.05.16 
function IsOnlyOnePatno()
{
   var firstrowdata = $("#grid-disp").jqGrid('getRowData', 1);
   var firstpatno = firstrowdata.patNo;
   var fyrowdata = $("#grid-disp").jqGrid('getRowData');
   var fygridrows = fyrowdata.length;
   for (var rowi = 1; rowi <= fygridrows; rowi++) {
	   var rowdata = $("#grid-disp").jqGrid('getRowData', rowi);
	   var patno = rowdata.patNo;
	   if (patno != firstpatno){
		   return false;
	   }	
   }
   return true;
}

function ChkDataBeforeALLFY(){
	var $grid = $("#grid-disp")
	var fyrowdata = $grid.jqGrid('getRowData');
    var fygridrows = fyrowdata.length;
	for (var rowi = 1; rowi <= fygridrows; rowi++) {
		var rowdata = $grid.jqGrid('getRowData', rowi);
		var okFlag = rowdata.TFyFlag;		 
		if(okFlag == "OK"){
			return false;
		}
   	}
	return true;
}
