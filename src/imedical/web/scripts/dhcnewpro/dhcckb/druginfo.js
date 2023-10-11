/**
  *hxy
  *2022-01-10
  *药品说明
 **/
/// 页面初始化函数
function initPageDefault(){
}

// 初始化页面数据取值
function initPageParams(drugId,drugCode,drugName,hisDrugCode,hisDrugName){
	/*runClassMethod("web.DHCERFormCat","GetDrugDetails",{"str": str},function(medrecObj){
			initPageView(medrecObj);	
	},'json',false)*/
	runClassMethod("web.DHCCKBService","QueryDrugInstrDetail",{drugId:drugId, drugCode:drugCode, drugName:drugName, hisDrugCode:hisDrugCode, hisDrugName:hisDrugName},function(medrecObj){
			if(medrecObj.code==1){
				$("#mainpage").show();
				initPageView(medrecObj.data);
			}else{
				$("#nodata").show();
			}
	},'json',false)
}

// 初始化页面数据
function initPageView(medrecObj){
	if (medrecObj){
		for(var key in medrecObj){
			if (document.getElementById(key) != null){
				document.getElementById(key).innerText = medrecObj[key].replace(/\r\n\r\n/g,"\r\n");
			}	
		}
		var GenerNameFormProp=medrecObj["GenerNameFormProp"];
		if(GenerNameFormProp==undefined)GenerNameFormProp=medrecObj["ProNameProp"];
		if(GenerNameFormProp==undefined)GenerNameFormProp="";
		document.getElementById("GenerNameFormPropIndex").innerText = GenerNameFormProp; //无通用名显示商品名
		var RuleIndic=medrecObj["RuleIndic"];
		if(RuleIndic==undefined)RuleIndic="";
		RuleIndic=RuleIndic.replace(/\r\n\r\n/g,"\r\n");
		//console.log(RuleIndic.replace(/\r\n\r\n/g,"\r\n"))
		document.getElementById("RuleIndicIndex").innerText = RuleIndic; //适应症
	}
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })