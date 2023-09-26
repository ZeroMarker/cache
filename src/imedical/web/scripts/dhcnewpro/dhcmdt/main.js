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
/// ҳ���ʼ������
function initPageDefault(){
	//isHasReqAbility();  ///�ж��Ƿ��������Ȩ��
	initEpisode();      /// ��ʼ�����ز��˾���ID
	getPatBaseInfo();   /// ���˾�����Ϣ
	initFrameSrc();     /// ҳ��iframe��Դ
	initComponent(); 	/// ��ʼ������ؼ�����
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
	
	runClassMethod("web.DHCMDTConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;

		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "��"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else if (jsonObject.PatSex == "Ů"){
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
			                '<div>��ϣ�<br><div style="height:4px"></div>'+(jsonObject.PatDiagDescAll==undefined?"":jsonObject.PatDiagDescAll.replace(/,/g,"<br><div style='height:4px'></div>"))+'</div>' +
			            '</div>',
			    onShow: function(){	
			    }	
			})
		}//ed
		
	},'json',false)
}

/// ҳ��iframe��Դ
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

/// ��������
function InsQuote(resQuote, flag){

	frames[0].InsQuote(resQuote, flag); /// ������������
}

/// ҳ��iframe��Դ
function refreshEmrFrameSrc(PatientID, EpisodeID){
	
	var link ="emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp';
	$("#newWinFrame").attr("src",link);
}

/// ˢ�� combogrid
function refreshComboGrid(EpisodeID){
	
	$('#mdtadm').combogrid('setValue', '');
	$("#mdtadm").combogrid('grid').datagrid("load",{"EpisodeID": EpisodeID});
	$('#mdtadm').combogrid('grid').datagrid('reload');
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })