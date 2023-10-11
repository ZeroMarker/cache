//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2020-12-17
// 描述:	   知识导入
//===========================================================================================

var ItemCode = "";			//药品id
var itemID = "";			//药品code  sufan 2021-01-04
var ItemDesc="";            //药品名称

/// 页面初始化函数
function initPageDefault(){
	
	/// 页面参数
	InitPageParams();
	
	/// 项目及目录
	InitItemCataLog();
	
	/// 页面事件
	InitPageEvent();
	
}

/// 页面参数
function InitPageParams(){
	itemID = getParam("itemId");
	ItemCode = getParam("itemCode");
	ItemCode =decodeURI(decodeURI(ItemCode))
}

/// 页面事件
function InitPageEvent(){
	
	$('.rule-local .rule-body-center').scroll( function() {
		$('.rule-body-west').scrollTop($(this).scrollTop());
		$('.rule-body-west').scrollLeft($(this).scrollLeft());
		$('.rule-body-east').scrollTop($(this).scrollTop());
		$('.rule-body-east').scrollLeft($(this).scrollLeft());
		$('.rule-import .rule-body-center').scrollTop($(this).scrollTop());
		$('.rule-import .rule-body-center').scrollLeft($(this).scrollLeft());
	});
	$('.rule-body-east').scroll( function() {
		$('.rule-body-west').scrollTop($(this).scrollTop());
		$('.rule-import .rule-body-center').scrollTop($(this).scrollTop());
		$('.rule-local .rule-body-center').scrollTop($(this).scrollTop());
	});	
	
	$('.p-n-item').on('click','.bt-messager-popover', function() {
    	InsertRuleCheckArea(this.id);  /// 规则核对区域
    	InsertRuleVerify(ItemDesc,this.id);     /// 导入规则核对区域
    	$('.bt-messager-popover').addClass(".success");
    });
}

/// 项目及目录
function InitItemCataLog(){
	runClassMethod("web.DHCCKBRuleUpdCompareToLibrary","JsGetItemCataLog",{"itemID":itemID},function(jsonObj){
		
		if (jsonObj != null){
			$(".label-desc").text(jsonObj.itemDesc);
			$(".label-manf").text(jsonObj.itemManf);
			$(".label-form").text(jsonObj.itemForm);
			ItemDesc=jsonObj.itemDesc;
			var htmlstr = "";
			for(var i=0; i<jsonObj.rows.length; i++){
				var colorClass = jsonObj.rows[i].isModFlag == "Y"?"error":"info";
				htmlstr = htmlstr + '<div id="'+ jsonObj.rows[i].ruleCataLogID +'" class="bt-messager-popover '+ colorClass +'">';
				htmlstr = htmlstr + ' 	<span class="content">'+ jsonObj.rows[i].ruleCataLog +'</span>';
				htmlstr = htmlstr + '</div>';
			}
			$(".p-n-item").html(htmlstr);
			InsertRuleCheckArea(jsonObj.rows[0].ruleCataLogID);  /// 加载规则
			InsertRuleVerify(ItemDesc,jsonObj.rows[0].ruleCataLogID);
		}
	},'json',false)
}

/// 规则核对区域
function InsertRuleCheckArea(mCataLogID){
	
	runClassMethod("web.DHCCKBRuleUpdCompareToLibrary","JsGetLocalRuleList",{"itemID":itemID, "itemCode":ItemCode,"mCataLogID":mCataLogID},function(jsonString){
		
		if (jsonString != null){
			InsertRuleArea(jsonString);
		}
	},'json',false)
}

/// 规则核对区域
function InsertRuleArea(jsonArr){
	var htmlxn = ""; var html = ""; 
	for(var i=0; i<jsonArr.length; i++){
		htmlxn = htmlxn + '<tr style="height:35px;">';
		htmlxn = htmlxn + ' 	<td class="key-label item-rank-width-20"><label>'+ jsonArr[i].ruleDesc +'</label></td>';
		htmlxn = htmlxn + '</tr>';
		
		html = html + '<tr style="height:35px;">';
		html = html + ' 	<td class="key-label item-rank-width-80"><label>'+ jsonArr[i].ruleCode +'</label></td>';
		html = html + '</tr>';
		
		var itemArr = jsonArr[i].rows;
		for(var j=0; j<itemArr.length; j++){
			
			htmlxn = htmlxn + '<tr style="height:35px;">';
			htmlxn = htmlxn + ' 	<td class="key-label"><label></label></td>';
			htmlxn = htmlxn + '</tr>';
			
			var LeftLen = itemArr[j].isRel == "Y"?((itemArr[j].Level-1)*30 + 10):(itemArr[j].Level*30 + 10);
			html = html + '<tr style="height:35px;">';
			html = html + ' 	<td class="key-label"><label style="margin-left:'+ LeftLen +'px;">'+ itemArr[j].Content +'</label></td>';
			html = html + '</tr>';	
			
		}
	}
	$(".rule-local .rule-body-west table").html(htmlxn);
	$(".rule-local .rule-body-center table").html(html);
}

/// 导入规则核对区域
function InsertRuleVerify(ItemDesc,mCataLogID){
	runClassMethod("web.DHCCKBRuleUpdCompareToLibrary","JsImportLocalRuleList",{"ItemDesc":ItemDesc,"mCataLogID":mCataLogID},function(jsonString){
		
		if (jsonString != null){
			InsertVerify(jsonString);
		}
	},'json',false)
}

/// 导入规则核对区域
function InsertVerify(jsonArr){
	var htmlxn = ""; var html = ""; var htmlOper = "";
	for(var i=0; i<jsonArr.length; i++){
		htmlxn = htmlxn + '<tr style="height:35px;">';
		htmlxn = htmlxn + ' 	<td class="key-label item-rank-width-20"><label>'+ jsonArr[i].ruleDesc +'</label></td>';
		htmlxn = htmlxn + '</tr>';
		
		html = html + '<tr style="height:35px;">';
		html = html + ' 	<td class="key-label item-rank-width-80"><label>'+ jsonArr[i].ruleCode +'</label></td>';
		html = html + '</tr>';
		
		htmlOper = htmlOper + '<tr style="height:35px;">';
		htmlOper = htmlOper + ' 	<td class="key-label item-rank-width-20" onclick="addRule(\''+jsonArr[i].ruleDesc+'\')"><label>添加</label></td>';
		htmlOper = htmlOper + '</tr>';
		
		var itemArr = jsonArr[i].rows;
		for(var j=0; j<itemArr.length; j++){
			
			htmlxn = htmlxn + '<tr style="height:35px;">';
			htmlxn = htmlxn + ' 	<td class="key-label"><label></label></td>';
			htmlxn = htmlxn + '</tr>';
			
			var LeftLen = itemArr[j].isRel == "Y"?((itemArr[j].Level-1)*30 + 10):(itemArr[j].Level*30 + 10);
			html = html + '<tr style="height:35px;">';
			html = html + ' 	<td class="key-label"><label style="margin-left:'+ LeftLen +'px;">'+ itemArr[j].Content +'</label></td>';
			html = html + '</tr>';	
			
			htmlOper = htmlOper + '<tr style="height:35px;">';
			htmlOper = htmlOper + ' 	<td class="key-label"><label></label></td>';
			htmlOper = htmlOper + '</tr>';
		}
	}
	$(".rule-import .rule-body-west table").html(htmlxn);
	$(".rule-import .rule-body-center table").html(html);
	$(".rule-body-east table").html(htmlOper);
	
}

//td点击事件
function addRule(ruleDesc){
	runClassMethod("web.DHCCKBRuleUpdCompareToLibrary","GetImportRuleByruleDesc",{"ItemDesc":ItemDesc,"ruleDesc":ruleDesc},function(jsonString){
		if(jsonString==""){
			
			$.messager.alert("提示", "导入成功!");
		    //window.parent.location.reload(true); 
		}else{
	       $.messager.alert("提示:","导入失败！","warning");
			return;
		}
	},'text',false)
}


/// 自动设置图片展示区分布
function onresize_handler(){

	var Width = document.body.offsetWidth;
	var Height = window.screen.availHeight;
	
	var mWidth = (Width - 30)/2;
	
	$(".rule-local").width(mWidth - 51);
	$(".rule-import").width(mWidth + 51);
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {
	
	/// 自动分布
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

function getParam(pname) {
    var params = location.search.substr(1);
    var ArrParam = params.split('&');
    if (ArrParam.length == 1) { 
        return params.split('=')[1];
    }
    else {
        //多个参数参数的情况
        for (var i = 0; i < ArrParam.length; i++) {
            if (ArrParam[i].split('=')[0] == pname) {
                return ArrParam[i].split('=')[1];
            }
        }
    }
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })