//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-04-16
// ����:	   mdt�������뵥
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var mradm = "";			/// �������ID
var CsType = "";        /// ��������
var LgGroup = session['LOGON.GROUPDESC'];
var LgHosp = session['LOGON.HOSPID'];
var LgLoc = session['LOGON.CTLOCID'];
var LgUser = session['LOGON.USERID'];
var Flag = "";
/// ҳ���ʼ������
function initPageDefault(){
	//isHasReqAbility();  ///�ж��Ƿ��������Ȩ��
	initEpisode();      /// ��ʼ�����ز��˾���ID
	getPatBaseInfo();   /// ���˾�����Ϣ
	initFrameSrc();     /// ҳ��iframe��Դ
	initComponent(); 	/// ��ʼ������ؼ�����
	LoadMoreScr();
}

/// ��ʼ��ҳ�����
function initComponent(){
	
	/// �����б�
	var columns = [[
	        {field:'EpisodeID',hidden:true},
	        {field:'EpisodeType',title:'��������',width:80,align:'center'},
			{field:'MedicareNo',title:'������',width:100,align:'center'},
			{field:'EpisodeDate',title:'��������',width:90,align:'center'},
			{field:'EpisodeTime',title:'����ʱ��',width:90,align:'center'},
			{field:'EpisodeDeptDesc',title:'�������',width:120},
			{field:'Diagnosis',title:'���',width:120},
			{field:'MainDocName',title:'����ҽ��',width:80},
			{field:'EpisodeText',title:'����',width:80,hidden:true}
	 	]];
	var option = {
		idField: 'EpisodeID',
	    textField: 'EpisodeText',
	    panelWidth:750,
		onClickRow: function (rowIndex, rowData) {
			if (EpisodeID != rowData.EpisodeID){
				/// ˢ�²���iframe��Դ
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
			$.messager.alert("��ʾ","û��Ȩ�޷���MDT���룡");
			$("#ConsultFrame").attr("src","");	
			$("#newWinFrame").attr("src","");
		}
	});
	return;
}

/// ��ʼ�����ز��˾���ID
function initEpisode(){
	
	PatientID = getParam("PatientID");   /// ����ID
	EpisodeID = getParam("EpisodeID");   /// ����ID
	mradm = getParam("mradm ");          /// �������ID
	CsType = getParam("CsType");         /// ��������
	hosNoPatOpenUrl = getParam("hosNoPatOpenUrl"); //hxy 2023-03-17 st
	debugger
	hosNoPatOpenUrl?hosOpenPatList(hosNoPatOpenUrl):''; //ed

	//IsOpenMoreScreen = isOpenMoreScreen();	///�Ƿ����Ļ
	/// ����IDΪ��ʱ���ӿ��ȡ������Ϣ
	if (EpisodeID == ""){
		var frm = dhcsys_getmenuform();
		if (frm) {
			PatientID = frm.PatientID.value;
			EpisodeID = frm.EpisodeID.value;
			mradm = frm.mradm.value;
		}
	}
}

/// ���˾�����Ϣ
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
		///סԺ���߲���Ҫ��ʾ��Ϣ��
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
//			if (jsonObject.PatSexCH == "��"){
//				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
//			}else if (jsonObject.PatSexCH == "Ů"){
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
			                '<div>��ϣ�<br><div style="height:4px"></div>'+(jsonObject.PatDiagDescAll==undefined?"":jsonObject.PatDiagDescAll.replace(/,/g,"<br><div style='height:4px'></div>"))+'</div>' +
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
* @return {HTMLString} html htmlƬ��
*/
function reservedToHtml(str){	
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}


/// ҳ��iframe��Դ
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
		var link ="emr.bs.browse.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp'+"&MWToken="+websys_getMWToken()+"&categorydir=south"; //hxy 2021-05-24 �ſ�ע��
		$("#newWinFrame").attr("src",link);
	}
	
	var url = "dhcmdt.writemain.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&isValFlag="+ Flag+"&MWToken="+websys_getMWToken();
	$("#ConsultFrame").attr("src",link);
}

/// ��������
function InsQuote(resQuote, flag){

	frames[0].InsQuote(resQuote, flag); /// ������������
}

/// ҳ��iframe��Դ
function refreshEmrFrameSrc(PatientID, EpisodeID){
	
	//var link ="emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp'+"&MWToken="+websys_getMWToken(); //hxy 2021-05-24 �ſ�ע��
	var link ="emr.bs.browse.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp'+"&MWToken="+websys_getMWToken()+"&categorydir=south"; //hxy 2021-05-24 �ſ�ע��
	//var link ="emr.browse.manage.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID;
	$("#newWinFrame").attr("src",link);
}

/// ˢ�� combogrid
function refreshComboGrid(EpisodeID){
	
	$('#mdtadm').combogrid('setValue', '');
	$("#mdtadm").combogrid('grid').datagrid("load",{"EpisodeID": EpisodeID});
	$('#mdtadm').combogrid('grid').datagrid('reload');
}



/// �����鿴:���ں�
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

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })