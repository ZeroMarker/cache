/**
 * FileName: dhcinsu/insuerxulmain.js
 * Anchor: 
 * Date: 2022-06-21
 * Description: ���Ӵ�������
 */
var DateFlag=0
/*var PUBLIC_CONSTANT = {
	SESSION: {
		GUSER_ROWID: session['LOGON.USERID'],
		CTLOC_ROWID: session['LOGON.CTLOCID'],
		GROUP_ROWID: session['LOGON.GROUPID'],
		HOSP_ROWID: session['LOGON.HOSPID']
	}
}*/
var GV = {
	USERID: session['LOGON.USERID'],
	CTLOCID: session['LOGON.CTLOCID'],
	GROUPID: session['LOGON.GROUPID'],
	HOSPID: session['LOGON.HOSPID'],
	EpisodeID: "",
	ADMID: ""
}

$(document).ready(function () {
		
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initChargeDtlList();
	initAdmList()
	// HIS������
	initCardType();
	//���Żس���ѯ�¼�
	$("#HISCardNo").keydown(function (e) {
		cardNoKeydown(e);
	});
	
	$("#HISCardType").combobox('disable',true);
	//clear();
});

/**
* ��ʼ��������
*/
function initCardType() {
	$HUI.combobox("#HISCardType", {
		url: $URL + "?ClassName=web.INSUReport&QueryName=QCardTypeDefineList&ResultSetType=array",
		editable: false,
		valueField: "myTypeID",
		textField: "caption",
		onChange: function (newValue, oldValue) {
		},
		onLoadSuccess:function(){
			setValueById('HISCardType','');	
		}
	});
}

// ���ؾ����б�
function loadAdmList(myPapmiId) {
	$('#AdmList').combobox('clear');
	
	var queryParams = {
		ClassName: "web.INSUReport",
		QueryName: "FindAdmList",
		type: "GET",
		papmi: myPapmiId,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		HisType:""
	}
	loadComboGridStore("AdmList", queryParams);
}

function magCardCallback(rtnValue) {
	loadAdmList('');
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("HISCardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("PatNo", myAry[5]);
		setValueById("HISCardType", myAry[8]);
		getPatInfo();
		break;
	case "-200":
		$.messager.alert("��ʾ", "����Ч", "info", function () {
			//focusById("HISCardNo");
		});
		break;
	case "-201":
		setValueById("HISCardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("PatNo", myAry[5]);
		setValueById("HISCardType", myAry[8]);
		getPatInfo();
		break;
	default:
	}
	if (patientId != "") {
		var admStr = "";
		loadAdmList(patientId);
		refreshBar(patientId, '');
	}
}

function getPatInfo() {
	var patientNo = getValueById("patientNo");
	if (patientNo) {
		var expStr = "";
		$.m({
			ClassName: "web.DHCOPCashierIF",
			MethodName: "GetPAPMIByNo",
			PAPMINo: patientNo,
			ExpStr: expStr
		}, function(papmi) {
			if (!papmi) {
				$.messager.popover({msg: "�ǼǺŴ�������������", type: "info"});
				return;
				//focusById("patientNo");
			}
			var admStr = "";
			setPatientInfo(papmi);
			loadAdmList(papmi);
			refreshBar(papmi,'');
		});
	}
}

/**
 * ˢ�»�����Ϣ��
 */
function refreshBar(papmi, adm) {
	//loadAdmList(papmi);
	$.m({
		ClassName: "web.DHCDoc.OP.AjaxInterface",
		MethodName: "GetOPInfoBar",
		CONTEXT: "",
		EpisodeID: adm,
		PatientID: papmi
	}, function (html) {
		if (html != "") {
			$(".PatInfoItem").html(reservedToHtml(html));
		} else {
			$(".PatInfoItem").html("��ȡ������Ϣʧ�ܣ����顾������Ϣչʾ�����á�");
		}
	});
}

/**
* ��ȡ����ѱ���Ϣ
*/
function getAdmReasonInfo(episodeId) {
	return $.m({ClassName: "web.UDHCJFPAY", MethodName: "GetAdmReaNationCode", EpisodeID: episodeId}, false);
}

//��ȡҽ��������Ϣ����
function GetInsuAdmInfo()
{
	$.m({
		ClassName: "web.DHCINSUIPReg",
		MethodName: "GetInfoByAdm",
		type: "GET",
		itmjs: "",
		itmjsex: "",
		Paadm: GV.ADMID
	}, function (rtn) {
          if (typeof rtn != "string")
         {
	       $.messager.alert('��ʾ','û����His�ҵ�ҽ���Ǽ�(�Һ�)��Ϣ','info');
	     }
		if (rtn.split("!")[0] != "1") {
			$.messager.alert('��ʾ','û����His�ҵ�ҽ���Ǽ�(�Һ�)��Ϣ','info');
		} else {
			var myAry = rtn.split("!")[1].split("^");
			GV.INSUADMID =  myAry[0]
			//setValueById("InsuActiveFlag", actDesc);           //ҽ���Ǽ�״̬
			setValueById("PatNo", myAry[2]);               //ҽ����
			setValueById("INSUCardNo", myAry[3]);               //ҽ������
			//setValueById("NewCardNo", myAry[3]);            //��ҽ������
			//setValueById("OldCardNo", myAry[39]);           //��ҽ������
			//InsuType=myAry[18];			
			//setValueById("InsuType",myAry[18])
			//InitYLLBCmb(myAry[14]);                          //ҽ�����
		    //InitBCFSCmb();                                  //���Ʒ�ʽ
		    //InitZLFSCmb();                                   //������ʽ
			setValueById("rylb", myAry[4]);          //��Ա���
			//$("#InsuInDiagDesc").combogrid("grid").datagrid("loadData", {
			//	total: 1,
			//	rows: [{"Code": myAry[26], "Desc": myAry[27]}]
			//});
			//$("#InsuInDiagDesc").combogrid("setValue", myAry[26]); 
			//setValueById("rylb", myAry[4]);          //��Ա���  //ҽ�����
			
			//setValueById("insuTreatType", myAry[36]);        //�������
			//setValueById("insuAdmSeriNo", myAry[10]);        //ҽ�������
			//setValueById("xzlx",myAry[37])                   //��������
	        //setValueById("dylb",myAry[36])                   //�������
	        //setValueById("AdmDate",myAry[12])                //��Ժ����
	        //setValueById("AdmTime",myAry[13])                //��Ժʱ��
            //setValueById("InsuAdmSeriNo",myAry[10])          //ҽ�������
            setValueById("States",myAry[8])              //ҽ��ͳ����
			//setValueById("ZLFS", myAry[38]);               //���Ʒ�ʽ
			//setValueById("BCFS", myAry[39]);               //������ʽ
		}
	});
	
}

function reservedToHtml(str) {
	var replacements = {
		"&lt;": "<",
		"&#60;": "<",
		"&gt;": ">",
		"&#62;": ">",
		"&quot;": "\"",
		"&#34;": "\"",
		"&apos;": "'",
		"&#39;": "'",
		"&amp;": "&",
		"&#38;": "&"
	};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g, function (v) {
		return replacements[v];
	});
}

function initAdmList() {
	$HUI.combogrid("#AdmList", {
		panelWidth: 560,
		panelHeight: 200,
		striped: true,
		fitColumns: false,
		editable: false,
		pagination: true,
		pageSize: 100,
		pageList: [100],
		method: 'GET',
		idField: 'admId',
		textField: 'admNo',
		columns: [[{field: 'admNo', title: "�����", width: 100},
					{field: 'admStatus', title: '��������', width: 80},
					{field: 'admDate', title: '��������', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.admTime;
							}
					}
					},
					{field: 'admDept', title: '�������', width: 100},
					{field: 'admWard', title: '���ﲡ��', width: 120},
					{field: 'admBed', title: '����', width: 60},

					{field: 'admId', title: '����ID', width: 80},
					{field: 'patName', title: '����', width: 80,hidden:true},
					{field: 'PaSex', title: '�Ա�', width: 80,hidden:true},
					{field: 'PAPMIHealthFundNo', title: 'ҽ���ֲ��', width: 80,hidden:true}
			]],
		onLoadSuccess: function (data) {

		},
		onLoadError:function(e){
		},
		onSelect: function (index, row) {
			GV.ADMID = row.admId;
			refreshBar('',row.admId);
			var admReaStr = getAdmReasonInfo(row.admId);
			var admReaAry = admReaStr.split("^");
			var admReaId = admReaAry[0];
			var INSUType = GetInsuTypeCode(admReaId);
			$("#InsuType").combobox('select', INSUType);
			loadChargeDtlList();
			//GetInsuAdmInfo();
		 	//setValueById('name',row.patName); //����
		 	//setValueById('Sex',row.PaSex); //�Ա�		
		}
	});
}

function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		//clear();
		var cardNo = getValueById("HISCardNo");
		if (!cardNo) {
			return;
		}
		DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
	}
}

function initQueryMenu() {
	$('#SDate, #EDate').datebox();
	
	$HUI.linkbutton('#btn-find', {
		onClick: function () {
			loadChargeDtlList();
		}
	});

	//�ǼǺŻس���ѯ�¼�
	$('#PatNo').keydown(function (e) {
		patientNoKeyDown(e);
	});
	
	$HUI.combobox('#UpFlag', {
		panelHeight: 'auto',
		data: [{
				value: 'N',
				text: 'δ�ϴ�',
				'selected':true
			}, {
				value: 'Y',
				text: '���ϴ�'
			},{
				value: "",
				text: 'ȫ��'
			}
		],
		valueField: 'value',
		textField: 'text'
	});
	
	/*
	$HUI.combobox('#DateFlag', {
		panelHeight: 'auto',
		data: [{
				value: '0',
				text: '��ѡ��',
				'selected':true
			}{
				value: '1',
				text: '��Ժ����',
			}, {
				value: '2',
				text: '��Ժ����'
			}, ,{
				value: '3',
				text: '��������',
				'selected':true
			}, {
				value: '4',
				text: '�ϴ�����',				
			}
		],
		valueField: 'value',
		textField: 'text'
	});
	
	$HUI.combobox('#UpFlag', {
		panelHeight: 'auto',
		data: [{
				value: '1',
				text: 'δ�ϴ�',
				'selected':true
			}, {
				value: '2',
				text: '���ϴ�'
			}
		],
		valueField: 'value',
		textField: 'text'
	});
	*/
	
	/*$HUI.combobox('#InsuType', {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCINSUEprUl&QueryName=ReadInsuType&ResultSetType=array',
		valueField: 'INDID_DicCode',
		textField: 'INDID_DicDesc',
		defaultFilter: 4,
		editable:false,
		value:'00A'
	});*/
	
	// ҽ������	upt 20220701
	init_INSUType();
	 
	$('#SDate, #EDate').datebox('setValue', getDefStDate(0));
	$("#btn-up").click(BUpClickHandle);
	$("#btn-del").click(BDelClickHandle);	
	$("#btn-insu-readCarad").click(BReadCardClickHandle);	
	$("#btn-print").click(PrintClickHandle);
	
	
}


/*
 * ҽ������ ��ҽ�������йص� ��������Ҫ�������¼���
 */
function init_INSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPID
	}
	INSULoadDicData('InsuType','DLLType',Options); 	
}
function patientNoKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: 'web.UDHCJFBaseCommon',
			MethodName: 'regnocon',
			PAPMINo: $(e.target).val()
		}, function (PatNo) {
			$(e.target).val(PatNo);
			var expStr = "";
			$.m({
				ClassName: "web.DHCOPCashierIF",
				MethodName: "GetPAPMIByNo",
				PAPMINo: PatNo,
				ExpStr: expStr
			}, function(papmi) {
				if (!papmi) {
					$.messager.popover({msg: "�ǼǺŴ�������������", type: "info"});
					return;
				}
				loadAdmList(papmi);
			});
			loadChargeDtlList();
		});
	}
}

function initChargeDtlList() {
	$HUI.datagrid('#mainDtlList', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		autoRowHeight: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		frozenColumns: [[{
					title: 'ck',
					field: 'ck',
					checkbox: true
				}
			]],
		columns: [[{
					title: '����',
					field: 'PatName',
					align: 'left',
					width: 100
				}, {
					title: '�ǼǺ�',
					field: 'PatRegNo',
					align: 'left',
					width: 100
				},{
					title: '��������',
					field: 'AdmDate',
					align: 'left',
					width: 100
				},  {
					title: '�������',
					field: 'AdmLocDeptDesc',
					align: 'left',
					width: 180
				}, {
					title: '������',
					field: 'PrescNo',
					align: 'left',
					width: 120,
					formatter: function(value,row,index){
						var btnstr="<a style='color:blue' onclick=\"HisPrescNoDetail(\'"+value+'\')\">'+value+'</a>';
				      	return btnstr ;
				     } 
				}, {
					title: '����ҽ������',
					field: 'ResDocName',
					align: 'left',
					width: 100
				}, {
					title: '�������',
					field: 'DiagDesc',
					align: 'left',
					width: 180
				}, {
					title: '�ϴ���־',
					field: 'UpFlag',
					align: 'left',
					width: 80
				}, {
					title: 'ҽ���������',
					field: 'hirxno',
					align: 'left',
					width: 230
				}, {
					title: '������˽����ѯ',
					field: 'AuditResult',
					align: 'left',
					width: 130,
					formatter: function(value,row,index){
						if (row.hirxno!="") {
							var btnstr="<a style='color:blue' onclick=\"AuditResult(\'"+row.hirxno+'\')\">'+'�����ѯ'+'</a>';
							return btnstr ;
						}
				     } 
				}, {
					title: '������ҩ�����ѯ',
					field: 'BuyResult',
					align: 'left',
					width: 130,
					formatter: function(value,row,index){
						if (row.hirxno!="") {
							var btnstr="<a style='color:blue' onclick=\"BuyResult(\'"+row.hirxno+'\')\">'+'�����ѯ'+'</a>';
				      		return btnstr ;
						}
				    }
				}, {
					title: '����Dr',
					field: 'EpisodeID',
					align: 'left',
					width: 100
				}	
			]],
			onLoadSuccess: function(){
				$(".easyui-tooltip").tooltip({
					onShow: function () {
						$(this).tooltip('tip').css({
							borderColor: '#000'
						});
					}
				});
			}
		
	});
}

function loadChargeDtlList() {
	var stDate = $('#SDate').datebox('getValue');
	var endDate = $('#EDate').datebox('getValue');
	var queryParams = {
		ClassName: 'web.INSUELECRXUPLD',
		QueryName: 'GetPrescNoInfo',
		SttDate: stDate,
		EndDate: endDate,
		RegNo: $('#PatNo').val(),
		EpisodeID: GV.ADMID,
		UpFlag: $('#UpFlag').combobox('getValue') || ''
	};
	loadDataGridStore('mainDtlList', queryParams);
}

function BUpClickHandle()
{
	var myRows = $("#mainDtlList").datagrid('getRows');
	var outstr="",Flag="", n=1;
	for(var i=0;i<myRows.length;i++){
		if($("#mainDtlList").parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(i).is(':checked')) Flag=1;
		else Flag=0;
		if (Flag==1){
			///�ϴ��ӿ�
			var UPFlag=myRows[i].UpFlag
			if (UPFlag=="Y"){alert("���ϴ��������ظ��ϴ�");return}
			//alert("xuyaoд�ϴ��ӿ�")
			var InputInfo=getValueById('InsuType')+"^"+"7101"+"^"+GV.HOSPID+"^"+GV.USERID+"^"+0+"^"+102+"^"+1+"^"+myRows[i].EpisodeID+"^"+""+"^"+""+"^"+""+"^"+myRows[i].PrescNo
			var RtnStr=tkMakeServerCall("INSU.OFFBIZ.BL.BIZ00A","InsuERXUL",InputInfo,"STR","JSON");
			var RtnFlag=RtnStr.split("^")[0];
			if (RtnFlag=="0"){alert("�ϴ��ɹ�")}
			else{alert("�ϴ�ʧ��"+RtnStr)}
			//���ӷ���ֵ�ж� �Լ����淽������
		}				
	}	
	loadChargeDtlList();
}

function BDelClickHandle()
{
	var myRows = $("#mainDtlList").datagrid('getRows');
	var outstr="",Flag="", n=1;
	for(var i=0;i<myRows.length;i++){
		if($("#mainDtlList").parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(i).is(':checked')) Flag=1;
		else Flag=0;
		if (Flag==1){
			//alert("xuyaoд�ϴ��ӿ�")
			var InputInfo=getValueById('InsuType')+"^"+"7104"+"^"+GV.HOSPID+"^"+GV.USERID+"^"+0+"^"+102+"^"+1+"^"+myRows[i].EpisodeID+"^"+""+"^"+""+"^"+""+"^"+myRows[i].PrescNo+"^"+myRows[i].hirxno
			var RtnStr=tkMakeServerCall("INSU.OFFBIZ.BL.BIZ00A","InsuERXCancel",InputInfo,"STR","JSON");
			var RtnFlag=RtnStr.split("^")[0]
			if (RtnFlag=="0"){alert("�����ɹ�")}
			else{alert("����ʧ��"+RtnStr)}
		}		
	}
		loadChargeDtlList();
}

///��ҽ���� ���һ�ȡhis�ǼǺ�
function BReadCardClickHandle()
{
	var Guser=GV.USERID
	var Type=getValueById('InsuType')+"^"
	var ret=InsuReadCard(0,Guser,"","",Type);
	if ((ret == "-1") || (ret == "")) {	
		return;
	}
	var InsuCardNo=ret.split("^")[1];
	
	//	20220226 ����ҽ��������ƾ֤���ؽ������֤ Start
	var InsuInfoArr=ret.split("|")[1]
	if (InsuInfoArr.split("^")[28]=="01"){
		myCardNo=ret.split("^")[7];
		m_SelectCardTypeDR="22"   //����ƾ֤
	}
	if (InsuInfoArr.split("^")[28]=="03"){
		myCardNo=ret.split("^")[1];
		m_SelectCardTypeDR="1"   // ҽ����
	}
	mySecurityNo=""
	var myExpStr=""+String.fromCharCode(2)+m_SelectCardTypeDR+String.fromCharCode(2) + "PatInfo";;	
	var myrtn=tkMakeServerCall("web.UDHCAccManageCLSIF","getaccinfofromcardno",myCardNo,mySecurityNo,myExpStr)
	if (myrtn.split("^").length>8)
	{$('#PatNo').val(myrtn.split("^")[8])}
	loadChargeDtlList();
	
}
function PrintClickHandle()
{
	var myRows = $("#mainDtlList").datagrid('getRows');
	var outstr="",Flag="", n=1;
	for(var i=0;i<myRows.length;i++){
		var PrescNo=myRows[i].PrescNo
		var EpisodeID=myRows[i].EpisodeID
	    var lnk="dhcdoc.viewpresclist.csp?PrescNoStr="+PrescNo+"&PrescNoMain="+PrescNo+"&EpisodeID="+EpisodeID;
	    window.open(lnk,"_target","height=600,width=900,menubar=no,status=yes,toolbar=no,resizable=yes") ;
	    return;
	}	
}

function HisPrescNoDetail(PrescNo)
{
	websys_showModal({
		url: 'insuerxulmainhisdetail.csp?PrescNo='+PrescNo+"&InsuType="+getValueById('InsuType')+"&HospDr="+GV.HOSPID,
		title: '������ϸ',
		iconCls: 'icon-w-list',
		height:700,
		width:1400
	});	
}

function AuditResult(hirxno)
{
	var InterType="7102"
	websys_showModal({
		url: "insuerxulmainybdetail.csp?InterType="+InterType+"&hirxno="+hirxno+"&InsuType="+getValueById('InsuType')+"&HospDr="+GV.HOSPID,
		title: '������˽����ѯ',
		iconCls: 'icon-w-list',
		height:750,
		width:800
	});	
}

function BuyResult(hirxno)
{
	var InterType="7103"
	websys_showModal({
		url: "insuerxulmainybdetail.csp?InterType="+InterType+"&hirxno="+hirxno+"&InsuType="+getValueById('InsuType')+"&HospDr="+GV.HOSPID,
		title: '������ҩ�����ѯ',
		iconCls: 'icon-w-list',
		height:750,
		width:800
	});	
}
