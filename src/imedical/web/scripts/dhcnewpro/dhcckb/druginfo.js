/**
  *hxy
  *2022-01-10
  *ҩƷ˵��
 **/
/// ҳ���ʼ������
function initPageDefault(){
}

// ��ʼ��ҳ������ȡֵ
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

// ��ʼ��ҳ������
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
		document.getElementById("GenerNameFormPropIndex").innerText = GenerNameFormProp; //��ͨ������ʾ��Ʒ��
		var RuleIndic=medrecObj["RuleIndic"];
		if(RuleIndic==undefined)RuleIndic="";
		RuleIndic=RuleIndic.replace(/\r\n\r\n/g,"\r\n");
		//console.log(RuleIndic.replace(/\r\n\r\n/g,"\r\n"))
		document.getElementById("RuleIndicIndex").innerText = RuleIndic; //��Ӧ֢
	}
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })