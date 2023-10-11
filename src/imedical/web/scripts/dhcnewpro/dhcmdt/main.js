//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-04-16
// 描述:	   mdt会诊申请单
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var mradm = "";			/// 就诊诊断ID
var CsType = "";        /// 会诊类型
var LgGroup = session['LOGON.GROUPDESC'];
var LgHosp = session['LOGON.HOSPID'];
var LgLoc = session['LOGON.CTLOCID'];
var LgUser = session['LOGON.USERID'];
var Flag = "";
/// 页面初始化函数
function initPageDefault(){
	//isHasReqAbility();  ///判断是否有申请的权限
	initEpisode();      /// 初始化加载病人就诊ID
	getPatBaseInfo();   /// 病人就诊信息
	initFrameSrc();     /// 页面iframe资源
	initComponent(); 	/// 初始化界面控件内容
	LoadMoreScr();
}

/// 初始化页面组件
function initComponent(){
	
	/// 就诊列表
	var columns = [[
	        {field:'EpisodeID',hidden:true},
	        {field:'EpisodeType',title:'就诊类型',width:80,align:'center'},
			{field:'MedicareNo',title:'病案号',width:100,align:'center'},
			{field:'EpisodeDate',title:'就诊日期',width:90,align:'center'},
			{field:'EpisodeTime',title:'就诊时间',width:90,align:'center'},
			{field:'EpisodeDeptDesc',title:'就诊科室',width:120},
			{field:'Diagnosis',title:'诊断',width:120},
			{field:'MainDocName',title:'主管医生',width:80},
			{field:'EpisodeText',title:'描述',width:80,hidden:true}
	 	]];
	var option = {
		idField: 'EpisodeID',
	    textField: 'EpisodeText',
	    panelWidth:750,
		onClickRow: function (rowIndex, rowData) {
			if (EpisodeID != rowData.EpisodeID){
				/// 刷新病历iframe资源
				refreshEmrFrameSrc(rowData.PatientID, rowData.EpisodeID);
				EpisodeID = rowData.EpisodeID;
			}
        }
	}
	var url = 'dhcapp.broker.csp?ClassName=web.DHCMDTCom&MethodName=GetAdmList&EpisodeID='+ EpisodeID+"&MWToken="+websys_getMWToken();
	new ListComboGrid("mdtadm", columns, url, option).Init();

}

function isHasReqAbility(){
	var reqFlag="";
	$m({
		ClassName:"web.DHCMDTCom",
		MethodName:"ReqMdtConsAbility",
		Params:LgHosp+"^"+LgLoc+"^"+LgUser
	},function(txtData){
		reqFlag = txtData;
		if(reqFlag==0){
			$.messager.alert("提示","没有权限发送MDT申请！");
			$("#ConsultFrame").attr("src","");	
			$("#newWinFrame").attr("src","");
		}
	});
	return;
}

/// 初始化加载病人就诊ID
function initEpisode(){
	
	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	mradm = getParam("mradm ");          /// 就诊诊断ID
	CsType = getParam("CsType");         /// 会诊类型
	hosNoPatOpenUrl = getParam("hosNoPatOpenUrl"); //hxy 2023-03-17 st
	debugger
	hosNoPatOpenUrl?hosOpenPatList(hosNoPatOpenUrl):''; //ed

	//IsOpenMoreScreen = isOpenMoreScreen();	///是否多屏幕
	/// 就诊ID为空时，从框架取病人信息
	if (EpisodeID == ""){
		var frm = dhcsys_getmenuform();
		if (frm) {
			PatientID = frm.PatientID.value;
			EpisodeID = frm.EpisodeID.value;
			mradm = frm.mradm.value;
		}
	}
}

/// 病人就诊信息
function getPatBaseInfo(){
	if(!EpisodeID){
		return;
	}
	/*
	$.m({ClassName:"web.DHCDoc.OP.AjaxInterface",MethodName:"GetOPInfoBar",CONTEXT:"",EpisodeID:EpisodeID,PatientID:PatientID},function(html){
		if (html!=""){
			$("#PatInfoItem").html(reservedToHtml(html));
		}
	});
	
	return;
	*/
	
	runClassMethod("web.DHCMDTConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		///住院患者不需要显示信息条
		if(jsonObject.PatType=="I") {
			$(".pf-patimg").attr("style","display:none")
			$(".pf-patbase").css("display","none")
			$(".pf-tools").css({
				"left":"0px",
				"text-align":"left"
			})
		}
		$('.ui-span-m').each(function(){
			$(this).html(jsonObject[this.id]);
			
		$("#PatPhoto").attr("src","../images/"+jsonObject.imgName+".png");	
//			if (jsonObject.PatSexCH == "男"){
//				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
//			}else if (jsonObject.PatSexCH == "女"){
//				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
//			}else{
//				$("#PatPhoto").attr("src","../images/unman.png");
//			}
		})
		if(jsonObject.PatDiagDescAll!=""){ //hxy 2020-05-06 st
			$("#PatDiagDesc").tooltip({
				position:'bottom',
				trackMouse:true,
			    content:'<div style="padding:4px;padding-bottom:6px">' +
			                '<div>诊断：<br><div style="height:4px"></div>'+(jsonObject.PatDiagDescAll==undefined?"":jsonObject.PatDiagDescAll.replace(/,/g,"<br><div style='height:4px'></div>"))+'</div>' +
			            '</div>',
			    onShow: function(){	
			    }	
			})
		}//ed
		
	},'json',false)
}

/**
* @author wanghc
* @date 2012/5/18
* @param {String} str
* @return {HTMLString} html html片段
*/
function reservedToHtml(str){	
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}


/// 页面iframe资源
function initFrameSrc(){
	if(EpisodeID==""){
		var frm = dhcsys_getmenuform();
		if (frm) {
			PatientID = frm.PatientID.value;
			EpisodeID = frm.EpisodeID.value;
			mradm = frm.mradm.value;
		}
	}
	
	if(IsOpenMoreScreen=="0"){
		//var link ="emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp&SinglePatient=1'+"&MWToken="+websys_getMWToken();
		var link ="emr.bs.browse.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp'+"&MWToken="+websys_getMWToken()+"&categorydir=south"; //hxy 2021-05-24 放开注释
		$("#newWinFrame").attr("src",link);
	}
	
	var url = "dhcmdt.writemain.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&isValFlag="+ Flag+"&MWToken="+websys_getMWToken();
	$("#ConsultFrame").attr("src",link);
}

/// 引用内容
function InsQuote(resQuote, flag){

	frames[0].InsQuote(resQuote, flag); /// 插入引用内容
}

/// 页面iframe资源
function refreshEmrFrameSrc(PatientID, EpisodeID){
	
	//var link ="emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp'+"&MWToken="+websys_getMWToken(); //hxy 2021-05-24 放开注释
	var link ="emr.bs.browse.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp'+"&MWToken="+websys_getMWToken()+"&categorydir=south"; //hxy 2021-05-24 放开注释
	//var link ="emr.browse.manage.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID;
	$("#newWinFrame").attr("src",link);
}

/// 刷新 combogrid
function refreshComboGrid(EpisodeID){
	
	$('#mdtadm').combogrid('setValue', '');
	$("#mdtadm").combogrid('grid').datagrid("load",{"EpisodeID": EpisodeID});
	$('#mdtadm').combogrid('grid').datagrid('reload');
}



/// 病历查看:超融合
function LoadMoreScr(){
	if(!IsOpenMoreScreen) return;
	
	var frm = dhcsys_getmenuform();
	if (frm) {
		PatientID = frm.PatientID.value;
		EpisodeID = frm.EpisodeID.value;
		mradm = frm.mradm.value;
	}
	
	var Obj={
		PatientID:PatientID,
		EpisodeID:EpisodeID,
		Type:2,
		EpisodeLocID:session['LOGON.CTLOCID'],
		Action:"externalapp"
	}
	
	websys_emit("onMdtConsWriteOpen",Obj);
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })