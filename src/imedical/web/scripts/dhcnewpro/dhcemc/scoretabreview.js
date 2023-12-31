//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-08-20
// 描述:	   评分表展示页面JS
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var BusType = "";       /// 业务类型
var ID = "";            /// 评分表ID
var EditFlag = "";      /// 编辑状态
var IsPopFlag = "";     /// 操作模式
var del = String.fromCharCode(2);

/// 页面初始化函数
function initPageDefault(){
	
	InitPageParams();    /// 初始化加载病人就诊ID
	InitBlButton();      /// 页面Button绑定事件
	LoadPageScore();     /// 加载页面评分内容
	ChcekLevInit();		 ///
}

/// 初始化加载病人就诊ID
function InitPageParams(){
	
	EpisodeID = getParam("EpisodeID");  /// 就诊ID
	BusType = getParam("BusType");      /// 业务类型
	ID = getParam("ID");                /// 评分表ID
	EditFlag = getParam("EditFlag");    /// 编辑状态
	CheckMasID = getParam("CheckMasID");/// PatCheckLev Bs:不为空标识分诊界面使用
	PatChkID = getParam("PatChkID");    /// 分诊ID
	RelListData = getParam("RelListData");
	RelListData?RelListData=JSON.parse(decodeURIComponent(RelListData)):"";
	console.log(RelListData);
	//RelListData = JSON.parse();   /// 界面带入默认值
}

/// 页面 Button 绑定事件
function InitBlButton(){
	
	$(".tabform").on("click","input[name^='grp']",TakCalScore)
	
	if (EditFlag == 0){
		$("#sure").hide();    /// 确认
		$("#cancel").hide();  /// 取消
		$("input[name^='grp']").attr("disabled",'disabled');
	}
	if (EditFlag == 1){
		$("#sure").show();    /// 确认
		$("#cancel").show();  /// 取消
	}
	if (EditFlag == 2){
		$("#sure").show();    /// 确认
		$("#cancel").hide();  /// 取消
	}
}

/// 计算评分
function TakCalScore(){
	
	var id = this.id;
	/// table表中checkbox勾选
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

/// 关闭弹出窗口
function TakClsWin(){

	window.parent.commonCloseWin();  /// 返回参数
}

/// 评分表预览
function TakScore(){
	
	var mListData = getListData();
	var scoreVal = $("#count").text();
	if(typeof mListData!="string") return;
	runClassMethod("web.DHCEMCScore","Insert",{"ID": ID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","评分保存失败，失败原因:"+jsonString,"warning");
		}else{
			ID = jsonString;
			if (IsPopFlag == 1) TakClsWin();  /// 关闭弹出窗口
			window.parent.InvScoreCallBack(ScoreCode, scoreVal); /// 评分回调函数
		}
	},'',false)
}

/// 加载页面评分内容
function LoadPageScore(){
	
	if (ID == ""){
		InitBindValue();
		return;	
	} 
	
	runClassMethod("web.DHCEMCScoreQuery","JsGetFormScore",{"ID": ID},function(jsonString){
		if (jsonString != null){
			$("#count").text(jsonString.Score);    /// 分值
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
				if(parseInt(vaule)==vaule){ ///数字
					$("input[data-reltype='"+key+"']").each(function(){
						var number = $(this).next().text();
						vaule=parseInt(vaule);
						if(number.indexOf("-")!=-1){
							var min = parseInt(number.split("-")[0]);
							var max = parseInt(number.split("-")[1]);
							if(!(min>vaule)&&!(max<vaule)) $(this).attr("checked",true);
						}else if(number.indexOf("≤")!=-1){
							number = parseInt(number.replace("≤",""));
							if(!(number<vaule)) $(this).attr("checked",true);
						}else if(number.indexOf("≥")!=-1){
							number = parseInt(number.replace("≥",""));
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
	
	///更改取消按钮绑定的事件
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
		
		///初始化数据
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
	
	/// 评分主信息
	var scoreVal = $("#count").text();    /// 分值
	var mListData = EpisodeID +"^"+ LgUserID +"^"+ BusType +"^"+ ScoreID +"^"+ scoreVal +"^"+ PatChkID;
	
	/// 评分表单详情
	var itemArr = [];
	var items = $("input[name^='grp']:checked");
	for (var i=0; i<items.length; i++){
		itemArr.push(items[i].id +"^"+ items[i].value +"^"+ items[i].type);
	}
	
	if (itemArr.length == 0){
		$.messager.alert("提示:","未选择任何评分项，不能保存！","warning");
		return;
	}
	
	var mListData = mListData + del + itemArr.join("@");	
	return mListData;
}

/// 自动设置页面布局
function onresize_handler(){

}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {

	
	/// 自动设置页面布局
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })