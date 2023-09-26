//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-08-20
// ����:	   ���ֱ�չʾҳ��JS
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var BusType = "";       /// ҵ������
var ID = "";            /// ���ֱ�ID
var EditFlag = "";      /// �༭״̬
var IsPopFlag = "";     /// ����ģʽ
var del = String.fromCharCode(2);

/// ҳ���ʼ������
function initPageDefault(){
	
	InitPageParams();    /// ��ʼ�����ز��˾���ID
	InitBlButton();      /// ҳ��Button���¼�
	LoadPageScore();     /// ����ҳ����������
}

/// ��ʼ�����ز��˾���ID
function InitPageParams(){
	
	EpisodeID = getParam("EpisodeID"); /// ����ID
	BusType = getParam("BusType");     /// ҵ������
	ID = getParam("ID");               /// ���ֱ�ID
	EditFlag = getParam("EditFlag");   /// �༭״̬
}

/// ҳ�� Button ���¼�
function InitBlButton(){
	
	$(".tabform").on("click","input[name^='grp']",TakCalScore)
	
	if (EditFlag == 0){
		$("#sure").hide();    /// ȷ��
		$("#cancel").hide();  /// ȡ��
		$("input[name^='grp']").attr("disabled",'disabled');
	}
	if (EditFlag == 1){
		$("#sure").show();    /// ȷ��
		$("#cancel").show();  /// ȡ��
	}
	if (EditFlag == 2){
		$("#sure").show();    /// ȷ��
		$("#cancel").hide();  /// ȡ��
	}
}

/// ��������
function TakCalScore(){
	
	var id = this.id;
	/// table����checkbox��ѡ
	if ($(this).closest("table").length != 0){
		var index = $(this).closest("tr").index();
		var checkboxs = $(this).closest("tr").find("input[name^='grp']");
		for(var i=0; i<checkboxs.length; i++){
			if (checkboxs[i].id != id){
				$(checkboxs[i]).prop('checked', false);
			}
		}
	}else{
		var checkboxs = $("input[name='"+ this.name+"']");
		for(var i=0; i<checkboxs.length; i++){
			if (checkboxs[i].id != id){
				$(checkboxs[i]).prop('checked', false);
			}
		}
	}

	var Score = 0;
	$("input[name^='grp']:checked").each(function(){
		if (this.value != ""){
			Score = Score + parseInt(this.value);
		}
	})
	$("#count").text(Score);
}

/// �رյ�������
function TakClsWin(){

	window.parent.commonCloseWin();  /// ���ز���
}

/// ���ֱ�Ԥ��
function TakScore(){
	
	/// ��������Ϣ
	var scoreVal = $("#count").text();    /// ��ֵ
	var mListData = EpisodeID +"^"+ LgUserID +"^"+ BusType +"^"+ ScoreID +"^"+ scoreVal;
	
	/// ���ֱ�����
	var itemArr = [];
	var items = $("input[name^='grp']:checked");
	for (var i=0; i<items.length; i++){
		itemArr.push(items[i].id +"^"+ items[i].value +"^"+ items[i].type);
	}
	
	if (itemArr.length == 0){
		$.messager.alert("��ʾ:","δѡ���κ���������ܱ��棡","warning");
		return;
	}
	
	var mListData = mListData + del + itemArr.join("@");
	runClassMethod("web.DHCEMCScore","Insert",{"ID": ID, "mListData":mListData},function(jsonString){
		
		if (jsonString < 0){
			$.messager.alert("��ʾ:","���ֱ���ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			ID = jsonString;
			if (IsPopFlag == 1) TakClsWin();  /// �رյ�������
			window.parent.InvScoreCallBack(ScoreCode, scoreVal); /// ���ֻص�����
		}
	},'',false)
}

/// ����ҳ����������
function LoadPageScore(){
	
	if (ID == "") return;
	
	runClassMethod("web.DHCEMCScoreQuery","JsGetFormScore",{"ID": ID},function(jsonString){
		if (jsonString != null){
			$("#count").text(jsonString.Score);    /// ��ֵ
			var itemArr = jsonString.items;
			for(var i=0; i<itemArr.length; i++){
				if ((itemArr[i].type == "radio")||(itemArr[i].type == "checkbox")){
				    $("input[id='"+ itemArr[i].key +"']").attr("checked",'checked');
				}
			}
			
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