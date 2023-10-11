//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2022-10-12
// 描述:	   急诊交班本指标项
//===========================================================================================

var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID

/// 页面初始化函数
function initPageDefault(){
	
//	/// 初始化病人基本信息
//	InitPatInfoPanel();
	
	/// 初始化Table列表
	InitWorkLoadItem();
}

/// 加载Table列表
function InitWorkLoadItem(){
	
	/// 初始化检查方法区域
	//$("#itemList").html('<tr style="height:0;"><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	// 获取显示数据
	runClassMethod("web.DHCEMTriageDailyWordLoad","JsGetTriColumns",{"mCode":"WWL", "HospID":session['LOGON.HOSPID']},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitCheckItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// 检查方法列表
function InitCheckItemRegion(itemArr){	

	/// 项目
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td align="right" class="tb_td_bk">'+ itemArr[j-1].title +'</td><td class="tb_td_val"><span data-type="val" id="'+ itemArr[j-1].field +'"></span></td>');
		if (j % 4 == 0){
			itemhtmlstr = itemhtmlstr + '<tr class="tr">' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 4 != 0){
		var fixhtml = "";
		var remainder = (j-1) % 4;
		if (remainder == 3){fixhtml = "<td></td><td></td>"}
		if (remainder == 2){fixhtml = "<td></td><td></td><td></td><td></td>"}
		if (remainder == 1){fixhtml = "<td></td><td></td><td></td><td></td><td></td><td></td>"}
		itemhtmlstr = itemhtmlstr + '<tr class="tr">' + itemhtmlArr.join("") + fixhtml + '</tr>';
		itemhtmlArr = [];
	}
	$("#itemList").append(itemhtmlstr)
	$.parser.parse($('#itemList'));  /// 重新解析
	
	InitWorkLoad();
}

/// 加载Table列表
function InitWorkLoad(){
	
	// 获取显示数据
	runClassMethod("web.DHCEMTriageDailyWordLoad","JsGetTriWorkLoad",{"Params":session['LOGON.HOSPID']+"^WWL"},function(jsonString){

		if (jsonString != ""){
			var jsonObj = jsonString;
			GetTriWorkInfo(jsonObj)
		}
	},'json',false)
}

/// 提取交班信息
function GetTriWorkInfo(jsonObj){
	
	/// 填写日期
	$("#WrDate").text(jsonObj.CrBusDate);
	/// 班次
	$("#Schedule").text(jsonObj.Schedule);
	/// 病区
	$("#CrLoc").text(jsonObj.CrLoc);
	/// 填报人
	$("#LgUser").text(jsonObj.CreateUser);
	$("span[data-type='val']").each(function(){
		$(this).text(jsonObj[this.id]||"");
	})
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
