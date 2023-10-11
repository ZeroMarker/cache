//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-01-22
// ����:	   �������뵥
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var mradm = "";			/// �������ID
var CsType = "";        /// ��������
var Risk = "";          /// Σ��ֵ
var LgGroup = session['LOGON.GROUPDESC'];
/// ҳ���ʼ������
function initPageDefault(){

	InitPatEpisodeID();       /// ��ʼ�����ز��˾���ID
	GetPatBaseInfo();         /// ���˾�����Ϣ
	LoadPatientRecord();
	
	InitPageComponent(); 	  /// ��ʼ������ؼ����� hxy 2021-06-15
	InitPageDataGrid();       /// ��ʼ��������ʷ�б� hxy 2021-06-11 
}
function switchPatientEm(patid,admid,mradm)
{
	PatientID=patid;
	EpisodeID=admid;
	GetPatBaseInfo();         /// ���˾�����Ϣ
	LoadPatientRecord();
	InitPageComponent(); 	  /// ��ʼ������ؼ����� hxy 2021-06-15
	InitPageDataGrid();       /// ��ʼ��������ʷ�б� hxy 2021-06-11 
}
/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	hosNoPatOpenUrl = getParam("hosNoPatOpenUrl"); //hxy 2023-03-17 st
	hosNoPatOpenUrl?hosOpenPatList(hosNoPatOpenUrl):''; //ed
	
	PatientID = getParam("PatientID");   /// ����ID
	EpisodeID = getParam("EpisodeID");   /// ����ID
	mradm = getParam("mradm");          /// �������ID
	CsType = getParam("CsType");         /// ��������
	Risk = getParam("Risk");             /// Σ��ֵ
	ObsId=getParam("obsId");			 /// Ѫ��
	ObsDate=getParam("obsDate");		 /// Ѫ��ʱ��
	//HOSҽ��վ����MenuCode DHC.Consult.Manager.IPDoc ȡ�������� st
	if(EpisodeID==""){ 
		var frm = dhcsys_getmenuform();
		if (frm) {
			PatientID = frm.PatientID.value;
			EpisodeID = frm.EpisodeID.value;
			mradm = frm.mradm.value;
		}
	}//ed
//	if(EpisodeID==""){
//		$.messager.alert("��ʾ","����ѡ���ߵľ����¼��","warning");
//	}
	/// �����б���ʿ���ﲻ���������б�
	if((CsType!="Nur")&&(!PatientID&&!EpisodeID)&&(LocAdmType!="I")){
		openPatListWin();
	}
}
function openPatListWin(){
	if($('#winpatlist').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winpatlist" style="overflow:hidden"></div>');
	$('#winpatlist').window({
		iconCls:'icon-w-paper', //hxy 2023-02-24
		title:$g('�����б�'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		modal: true,
		width:1300,
		height:600
	});
	
	var link="dhcem.patlist.csp?";
	if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token����
		link += "&MWToken="+websys_getMWToken();
	}
	var cot = '<iframe scrolling="yes" width=100% height=99%  frameborder="0" src='+link+'></iframe>';
	$('#winpatlist').html(cot);
	$('#winpatlist').window('open');
}
function hidePatListWin(){
	$('#winpatlist').window('close');
}

/// ���˾�����Ϣ
function GetPatBaseInfo(){
	if(LocAdmType=="I"){
		$('#myLayout').layout('panel', 'north').panel('resize',{height:10});
		$('#myLayout').layout('resize');
		$("#PatPhoto").css("display","none");
	}else{
		$("#PatPhoto").css("display","inline");
	
	runClassMethod("web.DHCEMConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if ((jsonObject.PatSexCh == "��")||(jsonObject.PatSex == "Male")){
				$("#PatPhoto").attr("src","../images/man_lite.png"); //../scripts/dhcnewpro/images/boy.png //hxy 2023-01-04
			}else if ((jsonObject.PatSexCh == "Ů")||(jsonObject.PatSex == "Female")){
				$("#PatPhoto").attr("src","../images/woman_lite.png "); //../scripts/dhcnewpro/images/girl.png //hxy 2023-01-04
			}else{
				$("#PatPhoto").attr("src","../images/unman.png");
			}
		})
	},'json',false)

	}
}

/// �����鿴
function LoadPatientRecord(){
	
	/// Σ��ֵ��Ѫ�Ǵ��������������������Ҫȡ����е�ֵ
	if((Risk=="")&&(ObsId=="")){
		var frm = dhcsys_getmenuform();
		if (frm) {
			PatientID = frm.PatientID.value==""?PatientID:frm.PatientID.value;
			EpisodeID = frm.EpisodeID.value==""?EpisodeID:frm.EpisodeID.value;
			mradm = frm.mradm.value==""?mradm:frm.mradm.value;
		}
	}
	
	
	var EMRCSP="emr.bs.browse.csp"; //hxy 2021-05-10 st //emr.interface.browse.category.csp
	if((CsType=="Nur")&&(NurUseNurRec==1)){
		EMRCSP="nur.hisui.recordsBrowser.csp";
		$('#myLayout').layout('panel','center').panel('setTitle',$g('������'));
	} //ed
	var link =EMRCSP+"?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp&SinglePatient=1'+'&CsType='+CsType+'&categorydir=south'; //hxy 2021-02-09 ԭ��emr.interface.browse.category.csp //2021-03-19 �Ļ�ȥ�����Ҳ�������̫С����ʹ��ԭ���²��� emr.browse.manage.csp
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken();
	}
	$("#newWinFrame").attr("src",link);//2023-02-06 add CsType:Ϊ�˸�������һ����ʶ�������λ�����Ϣ
	
	var url = "dhcem.consultwrite.csp";
	if (CsType == "Nur"){
		url = "dhcem.consultnur.csp";
	}
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&seeCstType=2&Risk="+Risk+"&ObsId="+ObsId+"&ObsDate="+ObsDate;
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken();
	}
	$("#ConsultFrame").attr("src",link);
}

/// ��������
function InsQuote(resQuote, flag){

	frames[0].InsQuote(resQuote, flag); /// ������������
}

/// ��ʼ������ؼ�����
function InitPageComponent(){
		
	/// ��ʼ����
	$HUI.datebox("#CstStartDate").setValue(GetCurSystemDate(-1));
	
	/// ��������
	$HUI.datebox("#CstEndDate").setValue(GetCurSystemDate(0));
	
	/// ��ʿ���ﲻ��Ҫ
	if(CsType=="Nur"){
		$("#myLayout").layout('remove','west');
	}
}

/// ��ȡϵͳ��ǰ����
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

/// ҳ��DataGrid��ʼ����
function InitPageDataGrid(){
	///  ����columns
	var columns=[[
		{field:'PatLabel',width:218,formatter:setCellLabel,align:'center'} //hxy 2023-02-08 205->218
	]];
	
	///  ����datagrid
	var option = {
		fit:true,
		striped:false, //hxy 2023-02-08
		showHeader:false,
		rownumbers : false,
		singleSelect : true,
		toolbar:"#btn-toolbar",
        onClickRow:function(rowIndex, rowData){
	        CstID = rowData.CstID;           /// ����ID
	        CstItmID = rowData.CstItmID;     /// �����ӱ�ID
			var link = "dhcem.consultwrite.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&seeCstType=2"+"&CstID="+CstID+"&CstItmID="+CstItmID+"&IsMain=1";
			if ('undefined'!==typeof websys_getMWToken){
				link += "&MWToken="+websys_getMWToken();
			}
			$("#ConsultFrame").attr("src",link);
	    },
		onLoadSuccess:function(data){
			///  ���ط�ҳͼ��
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
		},
		rowStyler:function(index,rowData){   	       
	    }
	};
	
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue(); /// ��ʼ����
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();     /// ��������
	var params = CstStartDate +"^"+ CstEndDate+"^^^" + session['LOGON.USERID'] +"^"+ session['LOGON.CTLOCID'] +"^"+"R"+"^^^^"+EpisodeID; //11:�����
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsonGetConList&Params="+params;
	new ListComponent('PatList', columns, uniturl, option).Init();
	
	//  ����ˢ�°�ť
	$('#PatList').datagrid('getPager').pagination({ showRefresh: false}); 
	
	///  ���ط�ҳͼ��
    var panel = $("#PatList").datagrid('getPanel').panel('panel');  
    panel.find('.pagination-page-list').hide();
    panel.find('.pagination-info').hide()
}

/// �����б� ��Ƭ��ʽ
function setCellLabel(value, rowData, rowIndex){

	
	var FontColor = "green";
	var EmHtml="";    ///�Ӽ���ʾ�ڲ������ֺ�   
	if ((rowData.CsStatCode == $g("ȡ��"))||(rowData.CsStatCode == $g("�ܾ�"))){
		FontColor = "red";
	}
	if (rowData.CsEmFlag == $g("�Ӽ�")){
       EmHtml="<span style='color:red'>("+$g("��")+")</span>";
    }
	var ConsultType = rowData.CstTypeDesc.split("")[0];
	var CsCategory = rowData.CsCategory;
	var TypeColor="";
	if(CsCategory=="DOCA") ConsultType=$g("��");
	if(ConsultType==$g("��")){
		TypeColor="#ABD";	
	}else if(ConsultType==$g("��")) {
		TypeColor="#fbfb79";
	}else{
		TypeColor="#9de09d";
	}
	
	if (rowData.CsSurTime == "��ʱ"){
		rowData.CsSurTime = $g("��ʱ");
	}
	
	/// �������
	var CsLocDesc = rowData.CsCLoc;
	if (CsLocDesc != ""){
		CsLocDesc = CsLocDesc.length > 8?CsLocDesc.substr(0,8)+"...":CsLocDesc;
	}
	
	var htmlstr =  '<div class="celllabel" style="padding-right:8px"><h3 style="position:absolute;left:0;background-color:transparent;">'+ rowData.PatName;
	htmlstr = htmlstr +EmHtml+'</h3>'
	if(rowData.MulStr!=""){ //hxy 2021-01-25
		htmlstr = htmlstr +'<br>';
	}else{
	htmlstr = htmlstr +'<h3 style="position:relative;float:right;color:'+ FontColor +';background-color:transparent;"><span>'+ $g(rowData.CsStatCode) +'</span></h3><br>';
	}
	if($("button:contains('"+$g("�����б�")+"')").hasClass("btn-blue-select")){
		htmlstr = htmlstr +'<h4 style="position:absolute;left:0;background-color:transparent;color:green;">'+ rowData.CsRLoc +'</h4>';
		htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;color:green;">'+ rowData.CsRUser +'</h4><br>';
	}
	if(rowData.MulStr!=""){ //hxy 2021-01-25
		var MulStrArr=rowData.MulStr.split("##");
		for(var i=0; i<MulStrArr.length; i++){
			var MulStat=MulStrArr[i].split(",")[2];
			var MulColor = "green";
			if ((MulColor == $g("ȡ��"))||(MulColor == $g("�ܾ�"))){
				MulColor = "red";
			}
			if(MulStrArr[i].length<15){ //hxy 2021-03-15
			var MulHtml='<h3 style="float:right;position:relative;left:4px;color:'+ MulColor +';background-color:transparent;"><span>'+ MulStat +'&nbsp;</span></h3>';
			htmlstr = htmlstr + '<h4 style="position:absolute;left:0;background-color:transparent;">'+ MulStrArr[i].split(",")[0] +'</h4>'+MulHtml;
			htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;">'+ MulStrArr[i].split(",")[1] +'</h4><br>';
			}else if(MulStrArr[i].length>20){
				var MulHtml='<h3 style="float:right;position:relative;left:4px;color:'+ MulColor +';background-color:transparent;"><span>'+ MulStat +'&nbsp;</span></h3>';
				htmlstr = htmlstr + '<h4 style="position:absolute;left:0;background-color:transparent;">'+ MulStrArr[i].split(",")[0] +'</h4><br>';
				if(MulStat!="")htmlstr = htmlstr +MulHtml;
				htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;">'+ MulStrArr[i].split(",")[1] +'</h4><br>';
			}else{
				var MulHtml='<h3 style="float:right;position:relative;left:4px;color:'+ MulColor +';background-color:transparent;"><span>'+ MulStat +'&nbsp;</span></h3>';
				htmlstr = htmlstr + '<h4 style="position:absolute;left:0;background-color:transparent;">'+ MulStrArr[i].split(",")[0] +'</h4>';
				htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;">'+ MulStrArr[i].split(",")[1] +'</h4><br>';
				if(MulStat!="")htmlstr = htmlstr +MulHtml+'<br>';
			}
			
		}
	}else{
	htmlstr = htmlstr +'<h4 style="position:absolute;left:0;background-color:transparent;">'+ CsLocDesc +'</h4>';
	if((CsLocDesc.length+rowData.CsCUser.length)>16){
		htmlstr = htmlstr +'<br>'
	}
	htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;">'+ rowData.CsCUser +'</h4><br>';
	}
	htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">'+ rowData.CsRDate +" "+ rowData.CsRTime +'</h4>';
	htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;color:red;">'+ rowData.CsSurTime +'</h4><br>';
	htmlstr = htmlstr + '<span style=\"position: relative;top: -25px;left: 45px;border-radius: 3px; display: inline-block;width: 20px;height: 18px;line-height: 18px;background-color:'+TypeColor+'\" class="consult_type">'+$g(ConsultType)+'</span>';
	htmlstr = htmlstr + '<br>';
	htmlstr = htmlstr +'</div>';
	return htmlstr;
}

/// ��ѯ���뵥�б�
function QryCons(Load){
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue(); /// ��ʼ����
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();     /// ��������
    /// ���¼��ػ����б�
	var params = CstStartDate +"^"+ CstEndDate +"^^"+ session['LOGON.HOSPID'] +"^"+ session['LOGON.USERID'] +"^"+session['LOGON.CTLOCID']+"^"+ "R" +"^^^^"+EpisodeID;
	$("#PatList").datagrid("load",{"Params":params});
	if(Load=="1"){
		LoadConFrame(); //2021-07-05
	}
}

/// ���¼���
function LoadConFrame(){
	var link = "dhcem.consultwrite.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&seeCstType=2"; //+"&CstID="+CstID+"&CstItmID="+CstItmID+"&IsMain=1";
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken();
	}
	$("#ConsultFrame").attr("src",link);
}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
