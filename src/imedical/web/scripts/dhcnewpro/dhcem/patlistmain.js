//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2017-11-24
// 描述:	   急诊病人列表
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var defaultCardTypeDr;  /// 默认卡类型
var m_CardNoLength = 0;
var m_CCMRowID = "" ;
var PatListType = "Per"; /// 病人列表
var PatArrFlag = "N";
var EmWardID = "";	     /// 抢救病区ID
var GlobleTypeCode="";
var PatType = "E"; var LgCtLocID=session['LOGON.CTLOCID']; var LgUserID=session['LOGON.USERID'];
var EmPatTypeArr = [{"value":"Loc","text":$g('本科病人')}, {"value":"Per","text":$g('本人病人')}, {"value":"Grp","text":$g('本组病人')},{"value":"Obs","text":$g('留观病人')}]; ///{"value":"A","text":'全部病人'}, 

/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化页面样式
	InitPageStyle();
	
	/// 初始化加载病人就诊ID
	InitPatEpisodeID();
	
	InitDateBox();
	
	/// 初始化加载病人列表
	InitPatList();
	
	InitPatInfoPanel();
	
	/// 复选框事件
	InitCheck();
	
	///默认查询一下
	QryEmPatList()
}

function InitCheck(){
	//$HUI.checkbox("#PatDisEpi").setDisable(true);	  //初始化默认为禁用状态
}

/// 初始化页面样式
function InitPageStyle(){

	if (navigator.userAgent.indexOf("Chrome") == "-1"){
		$("#pf-bd").css({"height":$(document).height() - 140});
	}else{
		$("#pf-bd").css({"height":$(document).height() - 155});
	}
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	DateFormat = "";
	runClassMethod("web.DHCEMInComUseMethod","GetParams",{Params:""},
		function (rtn){
			DateFormat = rtn;
		},"text",false
	)	
	
	//EpisodeID = getParam("EpisodeID");
}

/// 初始化病人基本信息
function InitPatInfoPanel(){
	
	$HUI.combobox("#KeptLoc",{
		url:LINK_CSP+"?ClassName=web.DHCEMDocMainOutPat&MethodName=jsonListWard&HospID="+session['LOGON.HOSPID'],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			$("#QytType").combobox("setValue","Obs");
			$HUI.checkbox("#PatEpiYes").setValue(true);
	        QryEmPatList();
	    }	
	})
	
	///就诊科室
	$HUI.combobox("#AdmLoc",{
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatLoc&HospID="+session['LOGON.HOSPID'],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			$("#QytType").combobox("setValue","Obs");
			$HUI.checkbox("#PatEpiYes").setValue(true);
	        QryEmPatList();
	    }	
	})	
	
	$HUI.combobox("#CheckLev",{
		data:[
			{"value":"1","text":$g("Ⅰ级")},//hxy 2020-02-21 原：1 2 3 4
			{"value":"2","text":$g("Ⅱ级")},
			{"value":"3","text":$g("Ⅲ级")},
			{"value":"4","text":$g("Ⅳa级")},
			{"value":"5","text":$g("Ⅳb级")} //ed
		],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       QryEmPatList();
	    }	
	})	
		
	
	/// 类型
	var option = {
		panelHeight:"auto",
		onSelect:function(option){
			if(option.value!="Obs"){
				$("#KeptLoc").combobox("setValue","");
				$("#AdmLoc").combobox("setValue","");
				$HUI.checkbox("#PatDisEpi").setValue(false);  ///只看离院
			}else{
				$HUI.checkbox("#PatEpiYes").setValue(true);	
			}
			LoadEmPatByLoc(option.value);
		}
	}
	new ListCombobox("QytType",'',EmPatTypeArr,option).init();
	$("#QytType").combobox("setValue","Per");
	
	/// 登记号/床号/姓名 回车事件
	$("#TmpCondition").bind('keypress',TmpCon_KeyPress);
	
	/// 卡号 回车事件
	$("#EmCardNo").bind('keypress',EmCardNo_KeyPress);

	$("#more").bind('click',MoreCondition);
}



/// 页面DataGrid初始定义已选列表
function InitPatList(){
	
	var frozenColumns=[[
		{field:'ItmXH',title:'序号',width:40,align:'center'}
		]];
	///  定义columns
	var columns=[[
		//{field:'ItmXH',title:'序号',width:40,align:'center'},
		//{field:'PAAdmBed',title:'床号',width:80},
		{field:'PAAdmPriority',title:'当前分级',width:70,align:'center',formatter:setCellPAAdmPriority},
		{field:'LocSeqNo',title:'顺序号',width:60,align:'center'},
		{field:'PatLevel',title:'初始分级',width:70,align:'center',formatter:setCellLevLabel},
		{field:'PatNo',title:'登记号',width:120},
		{field:'PatName',title:'姓名',width:100},
		{field:'PatSex',title:'性别',width:60,align:'center'},
		{field:'PatAge',title:'年龄',width:70,align:'center'},
		{field:'PCLvArea',title:'区域',width:60,align:'center',styler:setCellAreaLabel},
		{field:'PAAdmDepCodeDR',title:'就诊科室',width:120},
		{field:'PAAdmWard',title:'病区',width:120,align:'center'},					 //+
		{field:'PAAdmBed',title:'床号',width:80,align:'center'},                     //+
		{field:'Diagnosis',title:'诊断',width:190,align:'center'},
		{field:'PAAdmDate',title:'就诊日期',width:120,align:'center'},
		{field:'PAAdmTime',title:'就诊时间',width:120,align:'center'},				 //+
		{field:'WalkStatus',title:'状态',width:80,align:'center'},				     //+
		{field:'RegDoctor',title:'号别',width:120,align:'center'},
		{field:'BillType',title:'病人类型',width:80,align:'center'},
		{field:'PAAdmDocCodeDR',title:'医生',width:100,align:'center'},
		//{field:'LabPng',title:'检查检验',width:70,align:'center',formatter: setCellLabLabel},
		{field:'PatGreFlag',title:'绿色通道',width:70,align:'center',formatter:setCellGreenLabel},
		//{field:'PAAdmDate',title:'入科时间',width:150,align:'center',formatter:function(value, rowData, rowIndex){
		//	return rowData.PAAdmDate+"  "+rowData.PAAdmTime;
		//}},
		{field:'PCLvNurse',title:'分诊护士',width:100},
		{field:'EpisodeID',title:'EpisodeID',width:100,align:'center'},
		//{field:'ItmPng',title:'生命体征',width:100},
		//{field:'OrdPng',title:'医嘱',width:120},
		//{field:'StrTime',title:'滞留时间',width:120},
		//{field:'ItmUnObr',title:'图标菜单',width:80,
		//		formatter: function(value,row,index){
		//			return reservedToHtml(value);
		//		}},
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		headerCls:'panel-header-gray',
		toolbar:'#toolbar',
		rownumbers : false,
		singleSelect : true,
		pagination: true,
		frozenColumns:frozenColumns,
		onClickRow:function(rowIndex, rowData){
			
			setEprMenuForm(rowData.EpisodeID,rowData.PatientID,rowData.mradm,"");
	    },
		onLoadSuccess:function(data){
			
			///  设置分诊区域
            if (typeof data.EmPatLevTotal == "undefined"){return;}
        	$(".l-btn-text:contains('"+$g("红区")+"')").html($g("红区")+"(" + data.EmPatLevCnt1 +")");
        	$(".l-btn-text:contains('"+$g("橙区")+"')").html($g("橙区")+"(" + data.EmPatLevCnt2 +")"); //hxy 2020-02-21 st
			$(".l-btn-text:contains('"+$g("黄区")+"')").html($g("黄区")+"(" + data.EmPatLevCnt3 +")"); //原：EmPatLevCnt2
			$(".l-btn-text:contains('"+$g("绿区")+"')").html($g("绿区")+"(" + data.EmPatLevCnt4 +")"); //原：EmPatLevCnt3 ed
		},
		rowStyler:function(index,rowData){   

	    },
	    onDblClickRow: function (rowIndex, rowData) {
		    setEprMenuForm(rowData.EpisodeID,rowData.PatientID,rowData.mradm,"");
		    PageJumpControl();
			//双击选择行编辑
        }
	};
	/// 就诊类型
	var param = "^^^"+ PatType +"^^^^N^^^^^"+LgCtLocID +"^"+ LgUserID +"^^^^^"+ PatListType;
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMDocMainOutPat&MethodName=JSonQryEmMainPatList&params="+param;
	new ListComponent('PatList', columns, uniturl, option).Init(); 
}

/// 设置图标菜单
function reservedToHtml(str){
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}

/// 检验检查图标
function setCellLabLabel(value, rowData, rowIndex){
	
	var html = '<a href="javascript:void(0);" onclick="showLabWin(1,'+ rowData.PatientID +')"><img src="../scripts/dhcnewpro/images/em_exam.png"/></a>';
	html += '<a href="javascript:void(0);" onclick="showLabWin(2,'+ rowData.PatientID +')"><img src="../scripts/dhcnewpro/images/em_lab.png"/></a>';
	return html;	
}

/// 分级
function setCellLevLabel(value, rowData, rowIndex){
	var fontColor = "";
	/*if ((value == "1级")||(value == "2级")){ fontColor = "#F16E57";} //hxy 2020-02-21 st
	if (value == "3级"){ fontColor = "#FFB746";}
	if (value == "4级"){ fontColor = "#2AB66A";}*/
	if (value == "1级"){ fontColor = "#F16E57";}
	if (value == "2级"){ fontColor = "orange";}
	if (value == "3级"){ fontColor = "#FFB746";}
	if ((value == "4级")||(value == "5级")){ fontColor = "#2AB66A";} //ed
	return "<font color='" + fontColor + "'>"+setCell(value)+"</font>"; //hxy 2020-02-21
}

function setCellPAAdmPriority(value, rowData, rowIndex){
	var fontColor = "";
	/*if ((value == "1级")||(value == "2级")){ fontColor = "#F16E57";} //hxy 2020-02-21 st
	if (value == "3级"){ fontColor = "#FFB746";}
	if (value == "4级"){ fontColor = "#2AB66A";}*/
	if (value == "1级"){ fontColor = "#F16E57";}
	if (value == "2级"){ fontColor = "orange";}
	if (value == "3级"){ fontColor = "#FFB746";}
	if ((value == "4级")||(value == "5级")){ fontColor = "#2AB66A";} //ed
	return "<font color='" + fontColor + "'>"+setCell(value)+"</font>";	//hxy 2020-02-21
}

/// 绿色通道
/// zhouxin
/// 2018-07-18
function setCellGreenLabel(value, rowData, rowIndex){
	var fontColor = "";
	var html = '<a href="javascript:void(0);" onclick="showGreenRec('+rowData.EpisodeID+')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"/></a>';
	if (value == "是"){ html = '<a href="javascript:void(0);" onclick="showGreenRec('+rowData.EpisodeID+')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png"/></a>'; }
	return html;
	
}
function showGreenRec(adm){
	var option = {
		minimizable:false,
		iconCls:'icon-save',
		onClose:function(){QryEmPatList()}
	}
	new WindowUX("绿色通道","PatLabWin", 700, 420 , option).Init();
	
	var LinkUrl ='dhcem.green.rec.csp?EpisodeID='+adm;
	if ('undefined'!==typeof websys_getMWToken){
		LinkUrl += "&MWToken="+websys_getMWToken()
	}
	var content = '<iframe class="page-iframe" src="'+ LinkUrl +'" frameborder="no" border="no" height="98%" width="100%" scrolling="no"></iframe>';
	$("#PatLabWin").html(content);
	return;		
}

/// 去向
function setCellAreaLabel(value, row, index){
	if (value == $g("红区")){
		return 'background-color:#F16E57;color:white';
	}else if (value == $g("橙区")){ //hxy 2020-02-21 st
		return 'background-color:orange;color:white'; //ed
	}else if (value == $g("黄区")){
		return 'background-color:#FFB746;color:white';
	}else if (value == $g("绿区")){
		return 'background-color:#2AB66A;color:white';
	}else{
		return '';
	}
}

/// 获取病人信息
function GetEmRegPatInfo(){
	
	runClassMethod("web.DHCEMDocMainOutPat","GetEmRegPatInfo",{"EpisodeID": EpisodeID},function(jsonString){
		
		if (jsonString != null){
			var rowData = jsonString;
			InitPatInfoPanel(rowData);
		}
	},'json',false)
}

/// 呼叫
function CallPatient(){
	
	///调用叫号公司的webervice进行呼叫
	runClassMethod("web.DHCDocOutPatientList","SendCallInfo",{"UserId":LgUserID},function(jsonString){
		
		if (jsonString != null){
			var retArr = jsonString.split("^");
			if(retArr[0]=="0"){
				search("");  /// 查询病人列表
				return;
			}
		}
	},'',false)
}

/// 重复呼叫
function reCallPatient(){

	///调用叫号公司的webervice进行重复呼叫
	runClassMethod("web.DHCDocOutPatientList","SendReCallInfo",{"UserId":LgUserID},function(jsonString){
		
		if (jsonString != null){
			var retArr = jsonString.split("^");
		}
	},'',false)
}

/// 过号
function OutCallQueue(){
	
	//var rowData = $('#patTable').bootstrapTable('getAllSelections');
	if (SelectedRowData == ""){
		dhccBox.alert("请先选择要过号的病人后，重试！","register-one");
		return;
	}
	var AdmDate=SelectedRowData.PAAdmDate;
	if (CheckAdmDate(AdmDate)==false) {
		dhccBox.alert("请选择当日就诊病人！","register-one");
		return;
	}
	if(SelectedRowData.Called == ""){
		dhccBox.alert("没有呼叫的病人不能过号！","register-one");
		return;
	}

	var PatName=SelectedRowData.PatName;
	var Patient="登记号: "+SelectedRowData.PatNo+" 姓名: "+PatName;
	dhccBox.confirm("对话框",Patient + "是否需要过号?","my-modalone",function(res){
		if (res){
			var EpisodeID = SelectedRowData.EpisodeID; /// 就诊ID
			var DoctorId = SelectedRowData.RegDocDr;   /// 医生ID
			runClassMethod("web.DHCDocOutPatientList","SetSkipStatus",{"Adm":CardTypeID,"DocDr":DocDr},function(jsonString){
	
				if (jsonString != ""){
					dhccBox.alert("操作失败！失败原因:" + jsonString,"register-one");
				}
			},'',false)

			search(""); /// 重新查询病人列表	
		}
	})
}

/// 登记号/床号/姓名 回车事件
function TmpCon_KeyPress(e){

	if(e.keyCode == 13){
		var TmpCondition = $("#TmpCondition").val();
		if (!TmpCondition.replace(/[\d]/gi,"")&(TmpCondition != "")){
			///  登记号补0
			TmpCondition = GetWholePatNo(TmpCondition);
			$("#TmpCondition").val(TmpCondition);
		}
		QryEmPatList();
	}
}

/// 查询
function QryEmPatList(){
	/// 卡号
	var CardNo = $("#EmCardNo").val();
	var TmpCondition = $("#TmpCondition").val();
	/// 开始日期
	var StartDate = $HUI.datebox("#StartDate").getValue();
	/// 结束日期
	var EndDate = $HUI.datebox("#EndDate").getValue();
	var DisHosp = $HUI.checkbox("#PatDisEpi").getValue();
	DisHosp=DisHosp==true?"D":"AD";
	var PatEpi = $HUI.checkbox("#PatEpiYes").getValue();
	PatEpi=PatEpi==true?"Y":"N";
	
	PatListType = ($HUI.combobox("#QytType").getValue()==undefined?"":$HUI.combobox("#QytType").getValue());
	EmWardID = ($HUI.combobox("#KeptLoc").getValue()==undefined?"":$HUI.combobox("#KeptLoc").getValue());
	CheckLev = ($HUI.combobox("#CheckLev").getValue()==undefined?"":$HUI.combobox("#CheckLev").getValue());   //qqa 20180310 增加当前分级查询条件
	AdmLoc = ($HUI.combobox("#AdmLoc").getValue()==undefined?"":$HUI.combobox("#AdmLoc").getValue());  
	
	var params = "^^^"+ PatType +"^"+ CardNo +"^"+ StartDate +"^"+ EndDate +"^"+ PatEpi +"^^^^^"+LgCtLocID +"^"+ LgUserID +"^^"+ TmpCondition 
		+"^^"+GlobleTypeCode+"^"+ PatListType +"^"+ EmWardID+"^"+CheckLev+"^^"+DisHosp + "^"+ AdmLoc
	
	
	$("#PatList").datagrid("load",{"params":params}); 
}

/// 读卡 新
function ReadCard() {
	DHCACC_GetAccInfo7(ReadCardCallback);
}
/// 读卡
function ReadCardCallback(rtnValue){
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
		case '0':
			$('#EmCardNo').val(myAry[1]);
			patientId = myAry[4];
			break;
		case '-200':
			$.messager.alert("提示", "卡无效", "info", function() {
				$("#EmCardNo").focus();
			});
			break;
		case '-201':
			$('#EmCardNo').val(myAry[1]);
			patientId = myAry[4];
			break;
		default:
		}
	if (patientId != "") {
		QryEmPatList();   /// 查询
	}
}

function M1Card_InitPassWord(){
	
	try{
		var myobj=document.getElementById("ClsM1Card");
		if (myobj==null) return;
		var rtn=myobj.M1Card_Init();
    }catch(e){}
}

/// 加载病人列表
function LoadEmPatByCurType(TypeCode){
	
	/// 卡号
	var CardNo = $("#EmCardNo").val();
	var TmpCondition = $("#TmpCondition").val();
	var StayInWard = ""; var OutArrQue = ""; var OutRegQue = "";
	if (TypeCode == "E"){ StayInWard = "E"; }  /// 急诊留观
	if (TypeCode == "R"){ StayInWard = "R"; }  /// 抢救留观
	//var params = "^^^"+ PatType +"^^^^"+ OutArrQue +"^"+ OutRegQue +"^^^^"+LgCtLocID +"^"+ LgUserID +"^^"+ TmpCondition +"^"+ StayInWard;
	//$("#PatList").datagrid("load",{"params":params}); 
}

/// 病人去向
function TransPatToArea(Type){
	GlobleTypeCode = Type;
	QryEmPatList();
	GlobleTypeCode="" ;  //
	return;
}

///  卡号回车
function EmCardNo_KeyPress(e){

	if(e.keyCode == 13){
		var CardNo = $("#EmCardNo").val();
		if (CardNo == "") return;
		DHCACC_GetAccInfo("", CardNo, "", "", ReadCardCallback);
	}
}

/// 加载病人列表
function LoadEmPatByLoc(PatListType){
	
	PatListType = PatListType;
	QryEmPatList();  /// 查询病人列表
	
}

function EmRadio_KeyPress(event,value){

	//LoadEmPatByCurType(TypeCode)
}

var resetEprMenuForm = function(){
	setEprMenuForm("","","","");
}

var setEprMenuForm = function(adm,papmi,mradm,canGiveBirth){
	var frm = dhcsys_getmenuform();
	if((frm) &&(frm.EpisodeID.value != adm)){
		frm.EpisodeID.value = adm; 			//DHCDocMainView.EpisodeID;
		frm.PatientID.value = papmi; 		//DHCDocMainView.PatientID;
		frm.mradm.value = mradm; 				//DHCDocMainView.EpisodeID;
		if(frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
		if (frm.canGiveBirth) frm.canGiveBirth.value = canGiveBirth;
		if(frm.PPRowId) frm.PPRowId.value = "";
	}
}


function InitDateBox(){
	$HUI.datebox("#StartDate").setValue(formatDate(0));
	$HUI.datebox("#EndDate").setValue(formatDate(0));	
}

/// 更多查询条件
function MoreCondition(){

	if ($(".more-panel").is(":hidden")){
		$(".more-panel").css("display","block");
		$("#pf-bd").height($("#pf-bd").height()-32);
		$("#PatList").datagrid("resize",{height:$("#pf-bd").height()-32})
		$(".more i").removeClass("more-bk-down").addClass("more-bk-up");
	}else{
		$(".more-panel").css("display","");
		$("#pf-bd").height($("#pf-bd").height()+32);
		$("#PatList").datagrid("resize",{height:$("#pf-bd").height()+32});
		$(".more i").removeClass("more-bk-up").addClass("more-bk-down");
		$HUI.datebox("#StartDate").setValue("");
		$HUI.datebox("#EndDate").setValue("");
	}
}

/// 弹出检验检查窗体
function showLabWin(LabType, PatientID){
	/*
	var lnk =(LabType == "1"?"dhcem.seepatlis.csp":"dhcem.inspectrs.csp")+"?PatientID="+PatientID;
	var openCss = 'width='+(window.screen.availWidth)+',height='+(window.screen.availHeight-10)+ ', top=0, left=0, location=no,toolbar=no, menubar=no, scrollbars=no, resizable=no,status=no'
	window.open(lnk,'newwindow',openCss) 
	*/
	/// 调用医嘱项列表窗口
	var option = {
		iconCls:'icon-save'
	}
	var WinTitle = LabType == "1"?"检验":"检查";
	new WindowUX(WinTitle,"PatLabWin", $(document).width(), $(document).height()-20 , option).Init();
	
	var LinkUrl = (LabType == "1"?"dhcem.seepatlis.csp":"dhcem.inspectrs.csp")+"?PatientID="+PatientID;
	if ('undefined'!==typeof websys_getMWToken){
		LinkUrl += "&MWToken="+websys_getMWToken()
	}
	var content = '<iframe class="page-iframe" src="'+ LinkUrl +'" frameborder="no" border="no" height="100%" width="100%" scrolling="auto"></iframe>';
	$("#PatLabWin").html(content);	
	return;
}

///补0病人登记号
function GetWholePatNo(EmPatNo){

	///  判断登记号是否为空
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  登记号长度值
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('错误提示',"登记号输入错误！");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

}

/// 跳转到急诊医生界面
function PageJumpControl(){
	var LinkUrl ="websys.csp?a=a&homeTab=dhcem.patoverviews.csp&PersonBanner=dhcdoc.patinfo.banner.csp&PatientListPage=dhcem.patlist.csp&TMENU=57449&TPAGID=148500597";
	if ('undefined'!==typeof websys_getMWToken){
		LinkUrl += "&MWToken="+websys_getMWToken()
	}
    window.location = LinkUrl;
}

/// 已诊
function LoadPatArrYes(event,value){
	if (value){
		$("[name='EM']").each(function(){
			$HUI.checkbox("#"+this.id).setValue(false);
		})
	}else{
		if(!$HUI.checkbox("#PatEpiNo").getValue()){
			$HUI.checkbox("#PatEpiNo").setValue(true);
		}
	}
}
/// 已诊
function LoadPatArrNo(event,value){
	if (value){
		$("[name='EM']").each(function(){
			$HUI.checkbox("#"+this.id).setValue(false);
		})
	}else{
		if(!$HUI.checkbox("#PatEpiYes").getValue()){
			$HUI.checkbox("#PatEpiYes").setValue(true);
		}
	}
}

function ClickPatDisEpi(event,value){
	if(value){
		$("#QytType").combobox("setValue","Obs");
		$HUI.checkbox("#PatEpiYes").setValue(true);
		QryEmPatList();
	}
	return;
}

//hxy 2020-02-21
function setCell(value){
	if(value=="1级"){value=$g("Ⅰ级");}
	if(value=="2级"){value=$g("Ⅱ级");}
	if(value=="3级"){value=$g("Ⅲ级");}
	if(value=="4级"){value=$g("Ⅳa级");}
	if(value=="5级"){value=$g("Ⅳb级");}
	return value;
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
