//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-11-01
// ����:	   ���౾����JS
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var mradm = "";         /// ID
var bsItemID = "";      /// �����ӱ�ID
var Pid = "";           /// ����ID
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID

/// ҳ���ʼ������
function initPageDefault(){

	InitParams();      /// ��ʼ������
	InitComponents();  /// ��ʼ���������
	InitCkEditor();    /// ��ʼ������༭��
	LoadPatBsContent();/// ���ز��˽�������
}

/// ��ʼ��ҳ�����
function InitParams(){
	
	BsID = getParam("BsID");           /// ����ID
	bsItemID = getParam("bsItemID");   /// �����ӱ�ID
	EpisodeID = getParam("EpisodeID"); /// ����ID
	Pid = getParam("Pid");   /// ���̺�
}

/// ��ʼ���������
function InitComponents(){
	

}

/// ��ʼ������༭��
function InitCkEditor(){
	
	ckEditor=CKEDITOR.replace( 'bs_suggest' ,{
			height:100,
			toolbar:[
			['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
			['TextColor','BGColor'],
			['FontSize'],  /// 'Format','Font',
			['HorizontalRule','SpecialChar','-','Outdent','Indent'],
			['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],['Maximize']
			],	
			resize_enabled:false, //ȥ���ײ���ǩ�ؼ�
			removePlugins:'elementspath'
	});
}

/// ���ز��˽�������
function LoadPatBsContent(){
	
	runClassMethod("web.DHCEMBedSideShiftQuery","JsBsSchContent",{"BsID":BsID, "EpisodeID":EpisodeID, "Pid":Pid},function(jsonString){
		
		if (jsonString != null){
			InsBsPanel(jsonString);
		}
	},'json',false)
}

/// ����ҳ�潻������
function InsBsPanel(itemObj){
	
	EpisodeID = itemObj.EpisodeID;         /// ����ID
	PatientID =  itemObj.PatientID;        /// ����ID
	mradm =  itemObj.mradm;                /// ����ID
	$("#bs_patname").val(itemObj.PatName); /// ����
	$("#bs_patsex").val(itemObj.PatSex);   /// �Ա�
	$("#bs_bedno").val(itemObj.PatBed);    /// ����
	$("#bs_patage").val(itemObj.PatAge);   /// ����
	$("#bs_patno").val(itemObj.PatNo);     /// �ǼǺ�
	$("#bs_chklev").val(itemObj.Priority); /// ����
	$("#bs_type").val(itemObj.Type);       /// ����
	$("#bs_diag").val(itemObj.PatDiag);    /// ���
	$("#bs_ObsTime").val(itemObj.ObsTime); /// ����ʱ��
	
	$("#bs_background").html(itemObj.Background);  /// ����
	$("#bs_assessment").html(itemObj.Assessment);  /// ����
	
	/// �༭��ֵ
	CKEDITOR.instances.bs_suggest.setData(itemObj.Suggest); /// ����
	
	SwitchButton(itemObj.SwitchFlag);  /// ������Ŀ�л���ť����
}

/// ��һ��
function prev_click(){
	
	switchPat(-1);  /// �л�������д����
}

/// ��һ��
function next_click(){
	
	switchPat(1);  /// �л�������д����
}

/// �������
function docemr_click(){
	openPatEmr(PatientID, EpisodeID, mradm);
}

/// ������
function nuremr_click(){
	$.messager.alert("��ʾ","���ṩ���ӣ�","info");
}

/// ����:�޷����ݹȸ������
function quote_click(){
	
	var Link="dhcem.patemrque.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID;
	window.parent.commonShowWin({
		url: Link,
		title: "����",
		width: 1280,
		height: 600
	})
//	var result = window.open(url,"_blank",'dialogWidth:'+ (window.screen.availWidth - 200) +'px;DialogHeight='+ (window.screen.availHeight - 200) +'px;center=1'); 
//	return;	
}

///���ûص�����
function InsQuote(innertTexts, flag){
	var bs_suggest = ckEditor.getData();  /// ���� �༭��ȡֵ
	/// �༭��ֵ
	CKEDITOR.instances.bs_suggest.setData(bs_suggest  +"\r\n"+ innertTexts); /// ����
	return;
}

/// ģ��
function temp_click(){
	
	
}

/// ����
function save_click(){
	
	var bs_background = $("#bs_background").val();  /// ����
	var bs_assessmen = $("#bs_assessment").val();   /// ����
	var bs_suggest = ckEditor.getData();  /// ���� �༭��ȡֵ
	if ((trim(bs_assessmen) == "")&(trim(bs_suggest) == "")){
		$.messager.alert("��ʾ:","�����ͽ��鲻��ͬʱΪ�գ�","warning");
		return;
	}
	var mListData = bs_background +"^"+ bs_assessmen +"^"+ bs_suggest +"^"+ EpisodeID;
	
	runClassMethod("web.DHCEMBedSideShift","saveBsItem",{"BsID": BsID, "BsItmID": bsItemID, "mListData": mListData},function(jsonString){
		
		if (jsonString < 0){
			$.messager.alert("��ʾ","����ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			bsItemID = jsonString;
			$.messager.alert("��ʾ","����ɹ���","info");
			LoadPatBsContent(); /// ���¼�������
			window.parent.parent.refresh();
		}
	},'',false)	
}

/// �л�������д����
function switchPat(direc){
	
	runClassMethod("web.DHCEMBedSideShiftQuery","JsBsSwitchPat",{"BsID": BsID, "EpisodeID":EpisodeID, "Pid":Pid, "direc":direc},function(jsonObj){
		
		if (jsonObj != null){
			bsItemID = jsonObj.bsItemID;    /// �����ӱ�ID
			EpisodeID = jsonObj.EpisodeID;  /// ����ID
			LoadPatBsContent();             /// ���¼�������
			window.parent.frames[0].refresh(EpisodeID);
		}
	},'json',false)
}

/// �л�������д����
function switchPatOLD(direc){
	
	runClassMethod("web.DHCEMBedSideShiftQuery","JsBsSwitchPat",{"bsItemID":bsItemID, "direc":direc},function(jsonObj){
		
		if (jsonObj != null){
			bsItemID = jsonObj.bsItemID;  /// �����ӱ�ID
			LoadPatBsContent();           /// ���¼�������
			window.parent.frames[0].refresh(EpisodeID);
		}
	},'json',false)
}

/// ������Ŀ�л���ť����
function SwitchButton(BTFlag){
	
	if (BTFlag == -1){
		$("#bt_prev").linkbutton('disable');  /// ��һ����ť
		$("#bt_next").linkbutton('disable');  /// ��һ����ť
	}
	if (BTFlag == 0){
		$("#bt_prev").linkbutton('enable');   /// ��һ����ť
		$("#bt_next").linkbutton('enable');   /// ��һ����ť
	}
	if (BTFlag == 1){
		$("#bt_prev").linkbutton('disable');  /// ��һ����ť
		$("#bt_next").linkbutton('enable');   /// ��һ����ť
	}
	if (BTFlag == 2){
		$("#bt_prev").linkbutton('enable');   /// ��һ����ť
		$("#bt_next").linkbutton('disable');  /// ��һ����ť
	}
}
/// �����鿴
function openPatEmr(PatientID, EpisodeID, mradm){
	
	if (EpisodeID == ""){
		$.messager.alert("��ʾ","����ѡ���ˣ�","warning");
		return;
	}
	/// �ɰ没��
	/// window.open("emr.record.browse.patient.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
	
	/// �°没��
	var link = "websys.chartbook.hisui.csp?&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookID=70&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
	window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
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