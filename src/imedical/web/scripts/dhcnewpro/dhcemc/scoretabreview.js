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
	ChcekLevInit();		 ///
}

/// ��ʼ�����ز��˾���ID
function InitPageParams(){
	
	EpisodeID = getParam("EpisodeID");  /// ����ID
	BusType = getParam("BusType");      /// ҵ������
	ID = getParam("ID");                /// ���ֱ�ID
	EditFlag = getParam("EditFlag");    /// �༭״̬
	CheckMasID = getParam("CheckMasID");/// PatCheckLev Bs:��Ϊ�ձ�ʶ�������ʹ��
	PatChkID = getParam("PatChkID");    /// ����ID
	RelListData = getParam("RelListData");
	RelListData?RelListData=JSON.parse(decodeURIComponent(RelListData)):"";
	console.log(RelListData);
	//RelListData = JSON.parse();   /// �������Ĭ��ֵ
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
	
	var mListData = getListData();
	var scoreVal = $("#count").text();
	if(typeof mListData!="string") return;
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
	
	if (ID == ""){
		InitBindValue();
		return;	
	} 
	
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

function InitBindValue(){
	runClassMethod("web.DHCEMCScoreTabMain","RelListJson",{"EpisodeID": EpisodeID,"PatChkID":PatChkID},function(jsonData){
		if (jsonData != null){
			var data = $.extend({},RelListData,jsonData);
			for(var key in data){
				if(!data[key]) continue;
				if(!$("input[data-reltype='"+key+"']").length) continue;
				var vaule = data[key];
				if(parseInt(vaule)==vaule){ ///����
					$("input[data-reltype='"+key+"']").each(function(){
						var number = $(this).next().text();
						vaule=parseInt(vaule);
						if(number.indexOf("-")!=-1){
							var min = parseInt(number.split("-")[0]);
							var max = parseInt(number.split("-")[1]);
							if(!(min>vaule)&&!(max<vaule)) $(this).attr("checked",true);
						}else if(number.indexOf("��")!=-1){
							number = parseInt(number.replace("��",""));
							if(!(number<vaule)) $(this).attr("checked",true);
						}else if(number.indexOf("��")!=-1){
							number = parseInt(number.replace("��",""));
							if(!(number>vaule)) $(this).attr("checked",true);
						}else if(number.indexOf("<")!=-1){
							number = parseInt(number.replace("<",""));
							if(number>vaule) $(this).attr("checked",true);
						}else if(number.indexOf(">")!=-1){
							number = parseInt(number.replace(">",""));
							if(parseInt(number)<vaule) $(this).attr("checked",true);
						}else{
							if(number==vaule) $(this).attr("checked",true);	
						}
					})
				}else{
					$("input[data-reltype='"+key+"']").each(function(){
						if($(this).next().text()==vaule) $(this).attr("checked",true);
					})
				}
			}
		}
	},'json',false)
}

function ChcekLevInit(){
	if(CheckMasID=="") return;
	var _SelectID="#"+CheckMasID;
	
	///����ȡ����ť�󶨵��¼�
	if(parent.top.frames[0]){
		var _parentWin = parent.top.frames[0];
		var _btnJqDom = parent.top.frames[0].$(_SelectID);
		
		window.TakClsWin = function(){
			_parentWin.websys_showModal("close");
		}
		window.TakScore = function(){
			var mListData = getListData();
			if(typeof mListData!="string") return;
			_btnJqDom.attr('data-value',mListData);
			if(mListData!=""){
				_btnJqDom.addClass("dhcc-btn-blue"); 	
				_parentWin.collBakInsAutoScore(CheckMasID,$("#count").text());
			}
			_parentWin.websys_showModal("close");
		}
		
		///��ʼ������
		var itmData = _btnJqDom.attr('data-value')||"";
		if(itmData!=""){
			itmData = itmData.split(del)[1];
			var itmArr = itmData.split("@");
			var allScore = 0;
			for(var i=0; i<itmArr.length; i++){
				var itmType= itmArr[i].split("^")[2];
				var itmKey = itmArr[i].split("^")[0];
				var itmScore = itmArr[i].split("^")[1];
				allScore+=parseInt(itmScore);
				if (( itmType== "radio")||(itmType.type == "checkbox")){
				    $("input[id='"+ itmKey +"']").attr("checked",'checked');
				}
			}
			$("#count").text(allScore); 
		}
	}
}

function getListData(){
	
	/// ��������Ϣ
	var scoreVal = $("#count").text();    /// ��ֵ
	var mListData = EpisodeID +"^"+ LgUserID +"^"+ BusType +"^"+ ScoreID +"^"+ scoreVal +"^"+ PatChkID;
	
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
	return mListData;
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