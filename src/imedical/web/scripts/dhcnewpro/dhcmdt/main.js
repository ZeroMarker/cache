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
/// 页面初始化函数
function initPageDefault(){
	//isHasReqAbility();  ///判断是否有申请的权限
	initEpisode();      /// 初始化加载病人就诊ID
	getPatBaseInfo();   /// 病人就诊信息
	initFrameSrc();     /// 页面iframe资源
	initComponent(); 	/// 初始化界面控件内容
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
			}
        }
	}
	var url = 'dhcapp.broker.csp?ClassName=web.DHCMDTCom&MethodName=GetAdmList&EpisodeID='+ EpisodeID;
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
	
	runClassMethod("web.DHCMDTConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;

		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "男"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else if (jsonObject.PatSex == "女"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}else{
				$("#PatPhoto").attr("src","../images/unman.png");
			}
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

/// 页面iframe资源
function initFrameSrc(){
	
	var frm = dhcsys_getmenuform();
	if (frm) {
		PatientID = frm.PatientID.value;
		EpisodeID = frm.EpisodeID.value;
		mradm = frm.mradm.value;
	}
	
	var link ="emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp';
	$("#newWinFrame").attr("src",link);
	
	var url = "dhcmdt.write.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	$("#ConsultFrame").attr("src",link);
}

/// 引用内容
function InsQuote(resQuote, flag){

	frames[0].InsQuote(resQuote, flag); /// 插入引用内容
}

/// 页面iframe资源
function refreshEmrFrameSrc(PatientID, EpisodeID){
	
	var link ="emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp';
	$("#newWinFrame").attr("src",link);
}

/// 刷新 combogrid
function refreshComboGrid(EpisodeID){
	
	$('#mdtadm').combogrid('setValue', '');
	$("#mdtadm").combogrid('grid').datagrid("load",{"EpisodeID": EpisodeID});
	$('#mdtadm').combogrid('grid').datagrid('reload');
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })