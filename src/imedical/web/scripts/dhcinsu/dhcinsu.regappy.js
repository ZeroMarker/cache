/*
 * FileName: dhcinsu.regappy.js
 * Creator: 靳帅1010 
 * Date: 2022-12-9
 * Description: 医保住院申请
 */
var GV = {
	HospDr: session['LOGON.HOSPID'],
	USERID: session['LOGON.USERID'],
	Rq: INSUGetRequest(),
	AdmDr: "",                        //病人就诊ID
	Ward: "",                         //住院病区 
	reg: "",                          //登记号
	ipreg: "",                        //住院号
	loc: "",                          //科室
	ApprReaId: "",                    //费别
	ApprReaIdCode: "",                //费别代码
	Flag: "",                         //申请状态
}
//入口函数
$(function () {

	//1 初始化界面
	SetPageLayout();
	//2 初始化元素事件   
	SetElementEvent();
	//3 加载病人信息            
	InitPatInfo();
	//4 查询审批信息
	QueryAppyInfo();

});
//初始化界面
function SetPageLayout() {
	//初始化申请类型
	InitAppyType();
	//初始化审批记录datagrid
	InitAppDetailsdg();
}
//初始化申请类型
function InitAppyType() {
	var defaultOptions = {
		editable: 'Y',
		hospDr: GV.HospDr,
		defaultFlag: 'Y'
	}
	INSULoadDicData("AppyType", 'app_type00A', defaultOptions);
}
//初始化审批记录datagrid
function InitAppDetailsdg() {
	$('#AppDetailsdg').datagrid({
		fit: true,
		iconCls: 'icon-save',
		rownumbers: true,
		border: false,
		singleSelect: true,
		fitColumns: false,
		pagination: true,
		autoRowHeight: false,
		columns: [[
			{ field: 'RegID', title: 'Rowid', width: 60, hidden: true, fixed: true },
			{ field: 'ADMDR', title: 'ADMDR', width: 60, hidden: true, fixed: true },
			{ field: 'Regno', title: 'Regno', width: 60, hidden: true, fixed: true },
			{ field: 'ApprStas', title: '操作类型', width: 80, fixed: true },
			{ field: 'ApprStasCode', title: '操作类型代码', width: 80, hidden: true, fixed: true },
			{ field: 'OptUser', title: '操作员', width: 60, fixed: true },                                   //审批角色
			{ field: 'ApprRoleCode', title: '操作员代码', width: 80, hidden: true, fixed: true },
			{ field: 'AppyDate', title: '操作时间', width: 170, fixed: true },                                //申请时间或ApprDate
			{ field: 'Memo', title: '备注', width: 95, fixed: true },
			{ field: 'AppType', title: '申请/审批类型', width: 100, fixed: true },
			{ field: 'AppTypeCode', title: '申请/审批类型代码', width: 100, hidden: true, fixed: true },
			{ field: 'ApprReaId', title: '修改前费别', width: 90, fixed: true },
			{ field: 'ChkedReaId', title: '修改后费别', width: 90, fixed: true },
			{ field: 'MedType', title: '医疗类别', width: 80, fixed: true },
			{ field: 'MatnType', title: '生育类别', width: 80, fixed: true },
			{ field: 'BirCtrlType', title: '计划生育手术类别', width: 130, fixed: true },
			{ field: 'AppyReasondesc', title: '病种审批理由', width: 150, fixed: true },
		]],
	});
}
//初始化元素事件
function SetElementEvent() {
	$("#btn-Apply").click(Apply);           //申请事件
	$("#btn-ViewCases").click(ViewCases);   //病历查看事件
	$("#btn-ViewApprData").click(ViewApprData); //审批资料事件
}
//初始化病人信息 
function InitPatInfo() {
	GV.AdmDr = GV.Rq["AdmDr"]                                                     //获取传入AdmDr
	if (GV.AdmDr == "") {
		$.messager.alert("温馨提示", '就诊号为空!', 'info');
		return;
	}
	rtn = tkMakeServerCall("web.DHCINSURegAppr", "GetPatientInfo", GV.AdmDr);             //获取病人信息 
	if (rtn == "") {
		$.messager.alert("温馨提示", '未获取到人员信息!', 'info');
		return;
	}
	aData = rtn.split("^");
	GV.Ward = aData[9];
	GV.reg = aData[0];
	GV.ipreg = aData[8];
	GV.loc = aData[7];
	GV.ApprReaId = aData[6];
	GV.ApprReaIdCode = aData[12]
	document.getElementById("name").innerHTML = aData[3];                   //姓名
	document.getElementById("sex").innerHTML = aData[5];                    //性别
	document.getElementById("age").innerHTML = aData[4];                    //年龄     
	document.getElementById("reg").innerHTML = aData[0];                    //登记号
	document.getElementById("loc").innerHTML = aData[7];                    //科室
	document.getElementById("ipreg").innerHTML = aData[8];                  //住院号
	document.getElementById("ApprReaId").innerHTML = aData[6];              //当前费别
	document.getElementById("Ifreg").innerHTML = aData[1];                  //是否登记
	document.getElementById("IfAcct").innerHTML = aData[2];                 //是否结算
	if (aData[5] == "女") {                                                 //显示男女图标  unman_lite.png
	}
	else if (aData[5] == "男") {
		man.removeAttribute('hidden');
		woman.setAttribute('hidden', 'hidden');
	}
	else {
		unman.removeAttribute('hidden');
		woman.setAttribute('hidden', 'hidden');
	}
	//极简模式图标
	if (parent.window.HISUIStyleCode == "lite") {
		$("#woman").css({ "background": "url(../images/woman_lite.png) no-repeat", "background-size": "cover", "width": "30px", "height": "30px", "border-radius": "25px" });
		$("#man").css({ "background": "url(../images/man_lite.png) no-repeat", "background-size": "cover", "width": "30px", "height": "30px", "border-radius": "25px" });
		$("#unman").css({ "background": "url(../images/unman_lite.png) no-repeat", "background-size": "cover", "width": "30px", "height": "30px", "border-radius": "25px" });
	}
	GV.Flag = aData[10];
	SetbackgroundColor(GV.Flag);                                              //设置不同状态的背景色 
	//$('#ApprStas').triggerbox('disable') 
	disableById("ApprStas");
}
//设置不同状态的背景色
function SetbackgroundColor(Flag) {
	if (Flag == "") {                                                     //Flag为空未申请
		setValueById('ApprStas', "未申请");
	}
	else if (Flag == "1") {                                               //Flag为1审批通过  
		setValueById('ApprStas', "审批通过");
		document.getElementById('ApprStas').style.backgroundColor = "#EFFFEB";
		$("#ApprStas").css({ color: "#13AE37" });
		$("#ApprStas").css('border', '1px solid #A8E59A');
	}
	else if (Flag == "2") {                                                 //Flag为2审批拒绝
		setValueById('ApprStas', "审批拒绝");
		document.getElementById('ApprStas').style.backgroundColor = "#FFE9E9";
		$("#ApprStas").css({ color: "#EE0F0F" });
		$("#ApprStas").css('border', '1px solid #FFA4A4');
	}
	else if (Flag == "3") {
		setValueById('ApprStas', "待审批");
		document.getElementById('ApprStas').style.backgroundColor = "#FFF1E3";
		$("#ApprStas").css({ color: "#DF7000" });
		$("#ApprStas").css('border', '1px solid #FF9933');
	}
	else if (Flag == "0") {
		setValueById('ApprStas', "提交状态");
		document.getElementById('ApprStas').style.backgroundColor = "#EFF9FF";
		$("#ApprStas").css({ color: "#339EFF" });
		$("#ApprStas").css('border', '1px solid #9CD0FF');

	}
}
//申请事件
function Apply() {
	var ApplyStr = ""
	if (getValueById("AppyType") == "") {
		$.messager.alert("温馨提示", '申请类型不能为空!', 'info');
		return;
	}
	//当审批状态为"0" 提交状态，或为"1"审批通过时，不能进行申请
	if (GV.Flag == "0" || GV.Flag == "1") {
		$.messager.alert("温馨提示", '当前存在提交状态或者审批通过记录,不能申请!', 'info');
		return;
	}
	ApplyStr = "^" + GV.AdmDr + "^" + GV.reg + "^" + GV.ipreg + "^" + getValueById("AppyType") + "^" + "" + "^" +
		GV.loc + "^" + GV.Ward + "^" + GV.ApprReaIdCode + "^" + "" + "^" + "" + "^"
		+ "" + "^" + "" + "^" + "" + "^" + getValueById("Memo") + "^" +
		"1" + "^" + "0" + "^" + "" + "^" + "" + "^" + "" + "^" + "" + "^" + "" + "^" + GV.USERID + "^" + GV.HospDr;
	$m({
		ClassName: "web.DHCINSURegAppr",
		MethodName: "Apply",
		InString: ApplyStr
	}, function (txtData) {
		if (txtData > 0) {
			$.messager.popover({
				msg: '申请成功',
				type: 'success'
			});
			GV.Flag = "1";
			QueryAppyInfo();
			setValueById('ApprStas', "提交状态");
			document.getElementById('ApprStas').style.backgroundColor = "#EFF9FF";
			$("#ApprStas").css({ color: "#339EFF" });
			$("#ApprStas").css('border', '1px solid #9CD0FF');
		}
		else {
			$.messager.popover({
				msg: '申请失败',
				type: 'error'
			});
		}

	});
}
//查询医保住院审批
function QueryAppyInfo() {
	var QueryParam = {
		ClassName: "web.DHCINSURegAppr",
		QueryName: 'GetRegAppyInfo',
		AdmDr: GV.AdmDr,
		Hosptal: GV.HospDr
	}
	loadDataGridStore('AppDetailsdg', QueryParam);
}
//查看审批资料事件
function ViewApprData() {

	var selected = $('#AppDetailsdg').datagrid('getSelected');
	//当没选择记录或者选中的不是审批通过时提醒
	if (!selected || selected.ApprStasCode != "1") {
		$.messager.alert("温馨提示", "请选择一条审批通过记录!", 'info');
		return;
	}
	var AppType = selected.AppTypeCode;                              //申请类型1 病种   2 生育  3其他
	var RefuseDr = selected.RegID;                                   // 所属数据Dr  登记审批表id
	var OpenMode = "1";			                                     // 打开模式 0 可以上传  1 仅查看
	var fileMaxSize = "";			                                 //文件最大大小          单位M (默认为2)
	var FileExtStrs = "";			                                 //文件格式后缀字符串  "txt,png,jpg,..."(默认为图片)
	var ProoFileMaxNum = "";		                                 //最大保存文件个数    (默认为5) 
	OpenUploadFileWindow(AppType, RefuseDr, OpenMode, fileMaxSize, FileExtStrs, ProoFileMaxNum);

}
//病历查看事件
function ViewCases() {
	var url = "websys.csp?a=a&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&LayoutType=2&TMENU=50753&TPAGID=18454199&ChartBookID=70&SwitchSysPat=N&PatientID=" + "" + "&EpisodeID=" + GV.AdmDr + "&mradm=&WardID="
	websys_showModal({
		url: url,
		title: "病历查看",
		modal: true,
		top: "105px",
		left: "148px",
		minimizable: true,
		maximizable: true,
		iconCls: "icon-w-edit",
		onClose: function () {
		}
	});
}
