/**
  *hxy
  *2022-01-10
  *ҩƷ˵��
 **/
/// ҳ���ʼ������
function initPageDefault(){
}

// ��ʼ��ҳ������ȡֵ
function initPageParams(drugId,drugCode,drugName,hisDrugCode,hisDrugDesc){
	/*runClassMethod("web.DHCERFormCat","GetDrugDetails",{"str": str},function(medrecObj){
			initPageView(medrecObj);	
	},'json',false)*/
	runClassMethod("web.DHCCKBService","QueryDrugInstrDetail",{drugId:drugId, drugCode:drugCode, drugName:drugName, hisDrugCode:hisDrugCode, hisDrugName:hisDrugName},function(medrecObj){
			initPageView(medrecObj.data);	
	},'json',false)
}

// ��ʼ��ҳ������
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

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })