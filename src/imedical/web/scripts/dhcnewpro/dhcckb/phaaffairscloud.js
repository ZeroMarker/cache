/**
  *hxy
  *2022-01-10
  *药品说明
 **/
/// 页面初始化函数
function initPageDefault(){
}

// 初始化页面数据取值
function initPageParams(drugId,drugCode,drugName,hisDrugCode,hisDrugDesc){
	/*runClassMethod("web.DHCERFormCat","GetDrugDetails",{"str": str},function(medrecObj){
			initPageView(medrecObj);	
	},'json',false)*/
	runClassMethod("web.DHCCKBService","QueryDrugInstrDetail",{drugId:drugId, drugCode:drugCode, drugName:drugName, hisDrugCode:hisDrugCode, hisDrugName:hisDrugName},function(medrecObj){
			initPageView(medrecObj.data);	
	},'json',false)
}

// 初始化页面数据
function initPageView(medrecObj){
	if (medrecObj){
		for(var key in medrecObj){
			if (document.getElementById(key) != null){
				document.getElementById(key).innerText = medrecObj[key];
			}	
		}
		//alert(medrecObj["RuleIndic"])
		document.getElementById("RuleIndicIndex").innerText = medrecObj["RuleIndic"]
	}
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })