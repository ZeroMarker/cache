//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-11-01
// ����:	   ���ӽ��ಡ��JS
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ����ID
var BsID = "";          /// ����ID
var Pid = "";           /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID //hxy 2020-06-02

/// ҳ���ʼ������
function initPageDefault(){
	
	InitParams();      /// ��ʼ������
	InitComponents();  /// ��ʼ���������

}

/// ��ʼ��ҳ�����
function InitParams(){
	
	BsID = getParam("BsID");   /// ����ID
	Pid = getParam("Pid");     /// ����ID 
}

/// ��ʼ���������
function InitComponents(){
	
	/// �ǼǺ�
	$("#PatNo").bind('keypress',PatNo_KeyPress);
}

/// �ǼǺ�
function PatNo_KeyPress(e){
	
	if(e.keyCode == 13){
		var PatNo = $("#PatNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  �ǼǺŲ�0
			var PatNo = GetWholePatNo(PatNo);
			$("#PatNo").val(PatNo);
			GetPatBaseInfo(PatNo);  /// ��ѯ
		}
	}
}

/// ȷ��
function sure(){
	
	var EpisodeID = $("#EpisodeID").text();     /// ����ID
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","����ѡ���ˣ�","warning");
		return;
	}
	
	var BedID = $("#BedID").text();            /// ����ID
	var mListData = EpisodeID +"^"+ BedID;
	runClassMethod("web.DHCEMBedSideShift","InsPatToShift",{ "BsID":BsID , "mListData":mListData, "Pid":Pid},function(jsonString){
		
		if (jsonString == -1){
			window.parent.$.messager.alert("��ʾ:","�ò����Ѿ��ڵ�ǰ�����¼�У��������ظ���ӣ�","warning");
			return;
		}
		if (jsonString < 0){
			window.parent.$.messager.alert("��ʾ:","���ʧ�ܣ�","warning");
		}else{
			window.parent.$.messager.alert("��ʾ:","��ӳɹ���","warning");
			 closewin(); /// �ر�
			 window.parent.refresh();
		}
	},'',false)
}

/// �ر�
function closewin(){
	
	commonParentCloseWin();
}

/// ���˾�����Ϣ
function GetPatBaseInfo(PatNo){

	runClassMethod("web.DHCEMBedSideShiftQuery","GetPatBaseInfo",{"PatientNo":PatNo,"LgHospID":LgHospID},function(jsonString){ //hxy 2020-06-02
		var jsonObject = jsonString;
		if (typeof jsonObject.ErrCode != "undefined"){
			$.messager.alert('������ʾ',jsonObject.ErrMsg +"�����ʵ�����ԣ�");
			return;	
		}
		if (JSON.stringify(jsonObject) != '{}'){
			$('.td-span-m').each(function(){
				$(this).html(jsonObject[this.id]);
			})
		}else{
			$.messager.alert('������ʾ',"������Ϣ�����ڻ��˷����۲��ˣ����ʵ�����ԣ�");
			return;	
		}
	},'json',false)
}

/// �Զ�����ҳ�沼��
function onresize_handler(){
	
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {

	
	/// �Զ�����ҳ�沼��
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })