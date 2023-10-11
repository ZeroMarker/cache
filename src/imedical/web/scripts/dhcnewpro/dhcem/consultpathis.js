//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-08-15
// 描述:	   个人会诊记录查询
//===========================================================================================

var CstID = "";         /// 会诊申请ID
var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var ItemTypeArr = [{"value":"N","text":$g('待审')}, {"value":"Y","text":$g('已审')}];;

/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化加载病人就诊ID
	InitPatEpisodeID();
	
	/// 初始化加载病人列表
	InitPatList();
	
	InitMethod();
	
	/// 初始化病人基本信息
	InitPatInfoPanel();
	
	IsOpenMoreScreen?InitMoreScreen():''; //2022-03-07 用户大会
}

function InitMethod(){
	$(window).resize(function () {
		$("#bmDetList").datagrid("resize");
	});	
}


/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");
	EpisodeID = getParam("EpisodeID");
	CsType = getParam("CsType");         /// 会诊类型
	IsOpenMoreScreen = isOpenMoreScreen();	///是否多屏幕 2022-03-07 用户大会
}

/// 初始化病人基本信息
function InitPatInfoPanel(){
	
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-30));
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// 请会诊科室
	$HUI.combobox("#CstRLoc",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	/// 会诊类型
	$HUI.combobox("#CstType",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstType&HospID=" + LgHospID +"&LgUserID="+LgUserID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	/// 审核状态
	$HUI.combobox("#AuditFlag",{
		url:'',
		data : ItemTypeArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	/// 登记号
	//$("#PatNo").bind('keypress',PatNo_KeyPress);
	
}

/// 页面DataGrid初始定义已选列表
function InitPatList(){
	
	///  定义columns
	var columns=[[
		{field:'CstID',title:'CstID',width:100,hidden:true},
		//{field:'PatNo',title:'登记号',width:100},
		{field:'PatName',title:'姓名',width:100},
		//{field:'PatSex',title:'性别',width:60,align:'center'},
		//{field:'PatAge',title:'年龄',width:60,align:'center'},
		{field:'PatLoc',title:'就诊科室',width:120},
		{field:'PatWard',title:'病区',width:120},
		{field:'PatBed',title:'床号',width:60,align:'center'}, 
		{field:'PatDiag',title:'诊断',width:140},
		{field:'CstType',title:'会诊类型',width:100,align:'center'},
		{field:'CstRLoc',title:'请会诊科室',width:120},
		{field:'CstRUser',title:'请会诊人',width:100,align:'center'},
		{field:'CstRTime',title:'申请时间',width:160,align:'center'},
		//{field:'CstTrePro',title:'简要病历',width:400},
		//{field:'CstPurpose',title:'会诊目的',width:400},
		{field:'CstUnit',title:'会诊医院',width:100},
		{field:'CstLocArr',title:'会诊科室',width:220},
		{field:'CstPrvArr',title:'会诊人',width:220},
		{field:'AccpTime',title:'接收时间',width:160,align:'center'},
		{field:'CompTime',title:'完成时间',width:160,align:'center'},
		{field:'CstStatus',title:'会诊状态',width:80,align:'center'},
		{field:'CstNPlace',title:'会诊地点',width:200},
		//{field:'PrintFlag',title:'打印',width:80,align:'center',hidden:true},
		//{field:'AuditFlag',title:'审核状态',width:80,align:'center'},
		{field:'EpisodeID',title:'EpisodeID',width:100,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		fit:true,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
			
			var rows = $("#bmDetList").datagrid('getRows');		   
			if (rows.length == 0){
				InsPageConsult({CstTrePro:"",CstPurpose:"",CsOpinion:""})
				return;
			}
			var rowData = $('#bmDetList').datagrid('getData').rows[0];
			$("#bmDetList").datagrid('selectRow',0)
			InsPageConsult(rowData);
			/*
			var rows = $("#bmDetList").datagrid('getRows');		   
			if (rows.length == 0) return;
			var rowData = $('#bmDetList').datagrid('getData').rows[0];
			var TmpCstID = rowData.CstID;
			var mergerows = 0;
			for (var i=1;i<rows.length;i++){
				mergerows = mergerows + 1;
				if (TmpCstID != rows[i].CstID){
				    MergeCells(i,mergerows);  /// 合并指定单元格
				    mergerows=0;
				    TmpCstID = rows[i].CstID;
				}
			}
			if(i == rows.length){
				mergerows = mergerows + 1;
				 MergeCells(i,mergerows);  /// 合并指定单元格
			}
			*/
		},
		onClickRow: function (rowIndex, rowData) {
			InsPageConsult(rowData);
        },
		onDblClickRow: function (rowIndex, rowData) {
			WriteMdt(rowData.EpisodeID, rowData.CstID);
        },
        rowStyler:function(rowIndex, rowData){
			if (rowData.AuditFlag == "已审"){
				return 'background-color:pink;';
			}
		}
	};
	/// 就诊类型
	var param = "^^^^" + PatientID +"^"+ EpisodeID;
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsGetPatHisCons&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 合并指定单元格
function MergeCells(i, mergerows){
	
	var Fields = ["PatNo","PatName","CstID","PatSex","PatAge","PatLoc","PatWard","PatBed","PatDiag","CstType","CstRLoc","CstRUser","CstRTime","CstTrePro","CstPurpose","CstUnit"];
	for (var m = 0; m < Fields.length; m++){
		$('#bmDetList').datagrid('mergeCells',{
	       index:(i - mergerows),
	       field:Fields[m],
	       rowspan:mergerows
	    });
	}
}

/// 查询
function QryPatList(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var RLocID = $HUI.combobox("#CstRLoc").getValue();     /// 请会诊科室
	if (typeof RLocID == "undefined") RLocID = "";
	var CstType = $HUI.combobox("#CstType").getValue();    /// 会诊类型
	if (typeof CstType == "undefined") CstType = "";
	
	var params = StartDate +"^"+ EndDate +"^"+ RLocID +"^"+ CstType +"^"+ PatientID +"^"+ EpisodeID;
	$("#bmDetList").datagrid("load",{"Params":params}); 
}

/// 填写MDT申请
function WriteMdt(EpisodeID, CstID){

	//var rowsData = $("#bmDetList").datagrid('getSelected'); //选中要删除的行
	//if (rowsData != null) {
		OpenMdtConsWin();
		var lnk="dhcem.consultwrite.csp?EpisodeID="+EpisodeID +"&CstID="+CstID;
		if ('undefined'!==typeof websys_getMWToken){
			lnk += "&MWToken="+websys_getMWToken();
		}
		$("#newWinFrame").attr("src",lnk);
		//$("#newWinFrame").attr("src","dhcem.consultjdf.csp");
		//$("#newWinFrame").attr("src","dhcem.consultjdf.csp?EpisodeID="+rowsData.EpisodeID +"&ConsID="+ rowsData.ConsID);
	//}else{
		//$.messager.alert('提示','请选择要填写申请的记录！','warning');
		//return;
	//}
}

/// 打印
function PrintCst(){
	
	var rowsData = $("#bmDetList").datagrid('getSelected'); //选中要删除的行
	var CsStatCode = rowsData.CstStatus;
	if(CsStatCode=="取消"){
		$.messager.alert("提示","申请单已经取消,不能打印！","warning");
		return;
	}
	
	if((CsStatCode=="发送")||(CsStatCode.indexOf("审核")!=-1)||(CsStatCode=="驳回")||(CsStatCode=="拒绝")||(CsStatCode=="接收")||(CsStatCode=="取消接收")||(CsStatCode=="到达")||(CsStatCode=="取消完成")){
		if(ConsNoCompCanPrt==1){
			$.messager.alert("提示","会诊未完成,不能打印！","warning");
			return;
		}
	}
	if(PrintModel==1){
		var lnk="dhcem.printconsone.csp?CstItmIDs="+rowsData.CstItmID;
		if ('undefined'!==typeof websys_getMWToken){
			lnk += "&MWToken="+websys_getMWToken();
		}
		window.open(lnk);
		InsCsMasPrintFlag();  /// 修改会诊打印标志
	}else{
		var prtRet = PrintCstNew(rowsData.CstItmID,LgHospID);
		if(prtRet){
			InsCsMasPrintFlag();  /// 修改会诊打印标志	
		}
	}
	return;
}

/// 会诊闭环
function CloseLoop(){
	
	var rowsData = $("#bmDetList").datagrid('getSelected'); //选中要删除的行
	var CsStatCode = rowsData.CstStatus;
	if(CsStatCode=="取消"){
		$.messager.alert("提示","申请单已经取消,不能打印！","warning");
		return;
	}
	
	var lnk = "dhc.orderview.csp?ord="+rowsData.Oeori+"&ordViewType=CST&ordViewBizId="+rowsData.CstItmID; //hxy 2022-07-22 无医嘱显示空白问题：少入参
	//var lnk = "dhc.orderview.csp?ord="+ rowsData.Oeori;
	
	if(rowsData.TypeCode=="NUR"){ //hxy 2022-09-29
		var lnk = "dhcem.consultnur.csp?CstID="+rowsData.CstID+"&CstItmID="+rowsData.CstItmID+"&seeCstType=1"
	}
	
	websys_showModal({
		url: lnk,
		height:640,
		width:1300, //hxy 2021-05-07 890->1280 引用弹窗不可关闭 //900->1300 患者信息遮盖
		iconCls:"icon-w-paper",
		title: $g('会诊明细'),
		closed: true,
		onClose:function(){}
	});	
}

/// 会诊记录
function InsPageConsult(jsonObj){
	
	$("#ConsTrePro").text($_TrsTxtToSymbol(jsonObj.CstTrePro));    /// 病情摘要
	$("#ConsPurpose").text($_TrsTxtToSymbol(jsonObj.CstPurpose));  /// 会诊目的
	$("#ConsOpinion").text($_TrsTxtToSymbol(jsonObj.CsOpinion));   /// 会诊意见
	
	if(IsOpenMoreScreen){
	LoadMoreScr(jsonObj); //2023-03-07 用户大会
	}
}

/// 获取系统当前日期
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

function InitMoreScreen(){
	
}

function LoadMoreScr(rowData){
	var Obj={
		CstID:rowData.CstID,
		seeCstType:1
	}
	
	websys_emit("onOpenConsMessage",Obj);
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
