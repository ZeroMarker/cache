/*
模块:		药房公共
子模块:		药房公共-处方预览
Creator:	hulihua
CreateDate:	2019-01-12
dhcpha.common.prescpreview.js
*/
$(function(){
	var PrePrescParamStrArr=PrePrescParamStr.split("^");
	var preAdmType=PrePrescParamStrArr[0]||"";
	var prescNo=PrePrescParamStrArr[1]||"";
	var cyFlag=PrePrescParamStrArr[2]||"";
	var useFlag=PrePrescParamStrArr[3]||"";
	var prtType=PrePrescPrtType||"";
	var prtData="{}";
	//门诊和住院数据分开以便以后可扩展性更强
	if(preAdmType=="DHCINPHA"){
		prtData=tkMakeServerCall("web.DHCINPHA.Common.Print","PrescPrintData",prescNo,"底方",prtType,useFlag);
	}else{
		prtData=tkMakeServerCall("PHA.OP.COM.Print","PrescPrintData",prescNo,"底方",prtType,useFlag);
	}
	if (prtData=="{}"){
		return;
	}
	$("#divPreReport").html("");
	var prtJson=JSON.parse(prtData);
	var newPrtJson={}
	$.extend(newPrtJson,prtJson);
	// 非草药
	if (cyFlag!="Y"){
		var prescHtml=DHCSTXMLPrint_Preview.JsonToHtml(newPrtJson);
		var templetCode=prtJson.Templet;
		if (templetCode.indexOf("Ver")<0){
			var PreViewHeight="550px";
		}else{
			var PreViewHeight="720px";
		}
		var prescTitle=prtJson.Para.PrescTitle;
		var divLayOut = document.getElementById("divPreLayout");
		var newdiv = document.createElement("div");
		newdiv.id="divPreReport1";
		newdiv.style.position="relative";
		newdiv.style.height=PreViewHeight;		
		if(prescTitle.indexOf("毒麻")>"-1"){
			newdiv.style.background="#F5A89A";
	    }else if(prescTitle.indexOf("儿科")>"-1"){
			newdiv.style.background="#90EE90";
	    }else if(prescTitle.indexOf("急诊")>"-1"){
			newdiv.style.background="#FFFF96";
	    }
		divLayOut.appendChild(newdiv);
		$("#divPreReport1").html(prescHtml);
	}else{
		// 草药处方签高度以及每页list行数
		var templetCode=prtJson.Templet;
		if (templetCode.indexOf("Ver")<0){
			var PreViewHeight="550px";
			var cyListLimit=12;
		}else{
			var PreViewHeight="720px";
			var cyListLimit=16;
		}
		var prescTitle=prtJson.Para.PrescTitle;
		var prtList=prtJson.List;
		var prtListLen=prtList.length;
		// 处理分页
		newPrtJson.List=[];
		var pageInt=parseInt(prtListLen/cyListLimit);
		var pageRem=prtListLen%cyListLimit;
		if (pageRem>0){
			pageInt++;
		}
		for (var pageI=0;pageI<pageInt;pageI++){
			// 取List
			var newPrtList=[];
			var start=pageI*cyListLimit;
			var end=start+cyListLimit;
			newPrtList=prtList.slice(start,end);
			newPrtJson.List=newPrtList;
			var prescHtml=DHCSTXMLPrint_Preview.JsonToHtml(newPrtJson);
			var divLayOut = document.getElementById("divPreLayout");
			var newdiv = document.createElement("div");
			newdiv.id="divPreReport"+pageI;
			newdiv.style.position="relative";
			newdiv.style.height=PreViewHeight;		
			if(prescTitle.indexOf("毒麻")>"-1"){
				newdiv.style.background="#F5A89A";
		    }else if(prescTitle.indexOf("儿科")>"-1"){
				newdiv.style.background="#90EE90";
		    }else if(prescTitle.indexOf("急诊")>"-1"){
				newdiv.style.background="#FFFF96";
		    }
			divLayOut.appendChild(newdiv);
			$("#divPreReport"+pageI).html(prescHtml);	
		}
	}
});
