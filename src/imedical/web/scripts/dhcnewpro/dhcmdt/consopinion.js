
//===========================================================================================
// ���ߣ�      yangyongtao
// ��д����:   2020-03-30
// ����:	   MDTר�һ������
//===========================================================================================
var ItmID=""
var CsStatCode=""
var UserID=""
var LocID=""
var CstID=""
var IsCASign=""
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
/// ҳ���ʼ������
function initPageDefault(){
  
  InitParam() 			//������Ϣ 
  CASginBut()  			//Caǩ����ť��ʾ
  InitCstNOpinion()  	//ר�����
    	
}

/// ��ʼ�����ز�����Ϣ 
function InitParam(){
	
  ItmID=$("#ItmID").val();
  IsOutDoc=(ItmID.indexOf("||")>0?"N":"Y");
  CsStatCode=$("#CsStatCode").val();
  UserID=$("#UserID").val();
  LocID=$("#LocID").val();
  CstID=$("#CstID").val();
  IsCaSign = getParam("IsCaSign"); 
  showDom();
}

function showDom(){
	IsCASigned=IsgetsignmdtSIGNID(ItmID)
	if(IsCASigned==1){
		$("#bt_sign").find(".l-btn-text").text("����ǩ��") 
	}
	if((IsCASigned==1)||(CONSDISRUL!="1")){
		$("#mdtOpinion").attr("disabled",true)
	}else{
		$("#mdtOpinion").attr("disabled",false)
	}
	if(CONSDISRUL!="1"){
		$("#bt_save").hide();
	}else{
		$("#bt_save").show();
	}
}


//Caǩ����ť��ʾ
function CASginBut(){
	if(IsCaSign){
		$("#bt_sign").show();
	}else{
		$("#bt_sign").hide();
    }
}

//��ȡÿ��ר���Լ����
function InitCstNOpinion(){
	
	  var mdtOpinion=getCstNOpinion(ItmID)
	  $("#mdtOpinion").val(mdtOpinion);  	/// �������
   /*
	runClassMethod("web.DHCMDTConsultQuery","getCstNOpinion",{"ItmID":ItmID},function(jsonString){
		if (jsonString != ""){
			$("#mdtOpinion").val($_TrsTxtToSymbol(jsonString));  	/// �������
		}
	},'',false)
	*/
}

/// ����
function mdtSave(){
	
	var mdtOpinion = $("#mdtOpinion").val();			///�������
	if (mdtOpinion.replace(/\s/g,'') == ""){
		$.messager.alert("��ʾ:","����д���������","warning");
		return;
	}

	mdtOpinion = $_TrsSymbolToTxt(mdtOpinion); /// �����������
	
	runClassMethod("web.DHCMDTConsult","UpdConItmOpion",{"ItmID": ItmID,"mdtOpinion": mdtOpinion,"IsOutDoc":IsOutDoc},function(jsonString){
		if (jsonString < 0){
			if(jsonString==-105){
				$.messager.alert("��ʾ:","��������ַ�����,�����������1500��","warning");
			}else{
				$.messager.alert("��ʾ:","����ʧ�ܣ�","warning");
			}
		}else{
			$.messager.alert("��ʾ:","����ɹ���","info");
			//commonParentCloseWin();
			window.parent.ReloadTable();
		}
			
	},'',false)	
	
}

/// ȡ��
function mdtCancel(){
	
	commonParentCloseWin();
}

/// ǩ��
function mdtSignCs(){
	
	var flag="OPI"
	if (ItmID == ""){
		$.messager.alert("��ʾ:","mdt����ר�Ҳ���Ϊ�գ�","warning");
		return;
	}
	
	var mdtOpinion=getCstNOpinion(ItmID)
	if (mdtOpinion == ""){
		$.messager.alert("��ʾ:","���ȱ���������,Ȼ��ǩ��������","warning");
		return;
	}
	
	//ר���Ƿ��Ѿ�ǩ������
	var IsCASign=IsgetsignmdtSIGNID(ItmID)
	if(IsCASign==1){
		$.messager.alert("��ʾ", "����ר���Ѿ�ǩ��,�����ظ�ǩ����","warning")	
	    return;
	}
	
	//InvDigSign(CstID,ItmID,flag); /// ��������ǩ��
	isTakeDigSignNew({"callback":mdtSignOk,"modelCode":"MDTCompSign"});
	return;
}

function mdtSignOk(){
	if(IsCA){
		///F:ǩ�� C:����ǩ��
		var execFlag = IsCASigned==1?"C":"F";
		InsDigitalSignNew(ItmID,LgUserID,execFlag,"MDT",""); ///��������ǩ����־
		///ˢ����ʾ
		showDom();
	}
}

/// ��ȡר�һ������
function getCstNOpinion(ItmID){
	
	var Opinion = ""; /// ר�һ������
	runClassMethod("web.DHCMDTConsultQuery","getCstNOpinion",{"ItmID":ItmID,"Type":CONSDISRUL,"IsOutDoc":IsOutDoc},function(jsonString){
		if (jsonString != ""){
			Opinion = jsonString;
		}
	},'',false)
	return Opinion
}

/// xww 2021-01-26 �޸����
function mdtEdit(){
	$("#mdtOpinion").attr("disabled",false)  
}

//ר���Ƿ��Ѿ�ǩ������
function IsgetsignmdtSIGNID(ItmID)
{  
    var IsCASign = "";
	runClassMethod("web.DHCMDTSignVerify","IsgetsignmdtSIGNID",{"mdtID":ItmID},function(jsonString){
		IsCASign = jsonString;     
	},'',false)
	return IsCASign;
	
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })