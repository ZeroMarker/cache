/**
 * FileName: dhcinsu/insuerxulmain.js
 * Anchor: 
 * Date: 2022-06-21
 * Description: 电子处方管理
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
	// HIS卡类型
	initCardType();
	//卡号回车查询事件
	$("#HISCardNo").keydown(function (e) {
		cardNoKeydown(e);
	});
	
	$("#HISCardType").combobox('disable',true);
	//clear();
});

/**
* 初始化卡类型
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

// 加载就诊列表
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
		$.messager.alert("提示", "卡无效", "info", function () {
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
				$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
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
 * 刷新患者信息条
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
			$(".PatInfoItem").html("获取患者信息失败，请检查【患者信息展示】配置。");
		}
	});
}

/**
* 获取就诊费别信息
*/
function getAdmReasonInfo(episodeId) {
	return $.m({ClassName: "web.UDHCJFPAY", MethodName: "GetAdmReaNationCode", EpisodeID: episodeId}, false);
}

//获取医保就诊信息函数
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
	       $.messager.alert('提示','没有在His找到医保登记(挂号)信息','info');
	     }
		if (rtn.split("!")[0] != "1") {
			$.messager.alert('提示','没有在His找到医保登记(挂号)信息','info');
		} else {
			var myAry = rtn.split("!")[1].split("^");
			GV.INSUADMID =  myAry[0]
			//setValueById("InsuActiveFlag", actDesc);           //医保登记状态
			setValueById("PatNo", myAry[2]);               //医保号
			setValueById("INSUCardNo", myAry[3]);               //医保卡号
			//setValueById("NewCardNo", myAry[3]);            //新医保卡号
			//setValueById("OldCardNo", myAry[39]);           //旧医保卡号
			//InsuType=myAry[18];			
			//setValueById("InsuType",myAry[18])
			//InitYLLBCmb(myAry[14]);                          //医疗类别
		    //InitBCFSCmb();                                  //治疗方式
		    //InitZLFSCmb();                                   //补偿方式
			setValueById("rylb", myAry[4]);          //人员类别
			//$("#InsuInDiagDesc").combogrid("grid").datagrid("loadData", {
			//	total: 1,
			//	rows: [{"Code": myAry[26], "Desc": myAry[27]}]
			//});
			//$("#InsuInDiagDesc").combogrid("setValue", myAry[26]); 
			//setValueById("rylb", myAry[4]);          //人员类别  //医保诊断
			
			//setValueById("insuTreatType", myAry[36]);        //待遇类别
			//setValueById("insuAdmSeriNo", myAry[10]);        //医保就诊号
			//setValueById("xzlx",myAry[37])                   //险种类型
	        //setValueById("dylb",myAry[36])                   //待遇类别
	        //setValueById("AdmDate",myAry[12])                //入院日期
	        //setValueById("AdmTime",myAry[13])                //入院时间
            //setValueById("InsuAdmSeriNo",myAry[10])          //医保就诊号
            setValueById("States",myAry[8])              //医保统筹区
			//setValueById("ZLFS", myAry[38]);               //治疗方式
			//setValueById("BCFS", myAry[39]);               //补偿方式
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
		columns: [[{field: 'admNo', title: "就诊号", width: 100},
					{field: 'admStatus', title: '就诊类型', width: 80},
					{field: 'admDate', title: '就诊日期', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.admTime;
							}
					}
					},
					{field: 'admDept', title: '就诊科室', width: 100},
					{field: 'admWard', title: '就诊病区', width: 120},
					{field: 'admBed', title: '床号', width: 60},

					{field: 'admId', title: '就诊ID', width: 80},
					{field: 'patName', title: '姓名', width: 80,hidden:true},
					{field: 'PaSex', title: '性别', width: 80,hidden:true},
					{field: 'PAPMIHealthFundNo', title: '医保手册号', width: 80,hidden:true}
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
		 	//setValueById('name',row.patName); //姓名
		 	//setValueById('Sex',row.PaSex); //性别		
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

	//登记号回车查询事件
	$('#PatNo').keydown(function (e) {
		patientNoKeyDown(e);
	});
	
	$HUI.combobox('#UpFlag', {
		panelHeight: 'auto',
		data: [{
				value: 'N',
				text: '未上传',
				'selected':true
			}, {
				value: 'Y',
				text: '已上传'
			},{
				value: "",
				text: '全部'
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
				text: '请选择',
				'selected':true
			}{
				value: '1',
				text: '入院日期',
			}, {
				value: '2',
				text: '出院日期'
			}, ,{
				value: '3',
				text: '结算日期',
				'selected':true
			}, {
				value: '4',
				text: '上传日期',				
			}
		],
		valueField: 'value',
		textField: 'text'
	});
	
	$HUI.combobox('#UpFlag', {
		panelHeight: 'auto',
		data: [{
				value: '1',
				text: '未上传',
				'selected':true
			}, {
				value: '2',
				text: '已上传'
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
	
	// 医保类型	upt 20220701
	init_INSUType();
	 
	$('#SDate, #EDate').datebox('setValue', getDefStDate(0));
	$("#btn-up").click(BUpClickHandle);
	$("#btn-del").click(BDelClickHandle);	
	$("#btn-insu-readCarad").click(BReadCardClickHandle);	
	$("#btn-print").click(PrintClickHandle);
	
	
}


/*
 * 医保类型 和医保类型有关的 下拉框需要在这重新加载
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
					$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
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
					title: '姓名',
					field: 'PatName',
					align: 'left',
					width: 100
				}, {
					title: '登记号',
					field: 'PatRegNo',
					align: 'left',
					width: 100
				},{
					title: '就诊日期',
					field: 'AdmDate',
					align: 'left',
					width: 100
				},  {
					title: '就诊科室',
					field: 'AdmLocDeptDesc',
					align: 'left',
					width: 180
				}, {
					title: '处方号',
					field: 'PrescNo',
					align: 'left',
					width: 120,
					formatter: function(value,row,index){
						var btnstr="<a style='color:blue' onclick=\"HisPrescNoDetail(\'"+value+'\')\">'+value+'</a>';
				      	return btnstr ;
				     } 
				}, {
					title: '开单医生姓名',
					field: 'ResDocName',
					align: 'left',
					width: 100
				}, {
					title: '诊断名称',
					field: 'DiagDesc',
					align: 'left',
					width: 180
				}, {
					title: '上传标志',
					field: 'UpFlag',
					align: 'left',
					width: 80
				}, {
					title: '医保处方编号',
					field: 'hirxno',
					align: 'left',
					width: 230
				}, {
					title: '处方审核结果查询',
					field: 'AuditResult',
					align: 'left',
					width: 130,
					formatter: function(value,row,index){
						if (row.hirxno!="") {
							var btnstr="<a style='color:blue' onclick=\"AuditResult(\'"+row.hirxno+'\')\">'+'结果查询'+'</a>';
							return btnstr ;
						}
				     } 
				}, {
					title: '处方购药结果查询',
					field: 'BuyResult',
					align: 'left',
					width: 130,
					formatter: function(value,row,index){
						if (row.hirxno!="") {
							var btnstr="<a style='color:blue' onclick=\"BuyResult(\'"+row.hirxno+'\')\">'+'结果查询'+'</a>';
				      		return btnstr ;
						}
				    }
				}, {
					title: '就诊Dr',
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
			///上传接口
			var UPFlag=myRows[i].UpFlag
			if (UPFlag=="Y"){alert("已上传不允许重复上传");return}
			//alert("xuyao写上传接口")
			var InputInfo=getValueById('InsuType')+"^"+"7101"+"^"+GV.HOSPID+"^"+GV.USERID+"^"+0+"^"+102+"^"+1+"^"+myRows[i].EpisodeID+"^"+""+"^"+""+"^"+""+"^"+myRows[i].PrescNo
			var RtnStr=tkMakeServerCall("INSU.OFFBIZ.BL.BIZ00A","InsuERXUL",InputInfo,"STR","JSON");
			var RtnFlag=RtnStr.split("^")[0];
			if (RtnFlag=="0"){alert("上传成功")}
			else{alert("上传失败"+RtnStr)}
			//增加返回值判断 以及保存方法待定
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
			//alert("xuyao写上传接口")
			var InputInfo=getValueById('InsuType')+"^"+"7104"+"^"+GV.HOSPID+"^"+GV.USERID+"^"+0+"^"+102+"^"+1+"^"+myRows[i].EpisodeID+"^"+""+"^"+""+"^"+""+"^"+myRows[i].PrescNo+"^"+myRows[i].hirxno
			var RtnStr=tkMakeServerCall("INSU.OFFBIZ.BL.BIZ00A","InsuERXCancel",InputInfo,"STR","JSON");
			var RtnFlag=RtnStr.split("^")[0]
			if (RtnFlag=="0"){alert("撤销成功")}
			else{alert("撤销失败"+RtnStr)}
		}		
	}
		loadChargeDtlList();
}

///度医保卡 并且获取his登记号
function BReadCardClickHandle()
{
	var Guser=GV.USERID
	var Type=getValueById('InsuType')+"^"
	var ret=InsuReadCard(0,Guser,"","",Type);
	if ((ret == "-1") || (ret == "")) {	
		return;
	}
	var InsuCardNo=ret.split("^")[1];
	
	//	20220226 国家医保读电子凭证返回解析身份证 Start
	var InsuInfoArr=ret.split("|")[1]
	if (InsuInfoArr.split("^")[28]=="01"){
		myCardNo=ret.split("^")[7];
		m_SelectCardTypeDR="22"   //电子凭证
	}
	if (InsuInfoArr.split("^")[28]=="03"){
		myCardNo=ret.split("^")[1];
		m_SelectCardTypeDR="1"   // 医保卡
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
		title: '处方明细',
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
		title: '处方审核结果查询',
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
		title: '处方购药结果查询',
		iconCls: 'icon-w-list',
		height:750,
		width:800
	});	
}
