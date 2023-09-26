
/// 页面初始化函数
function initPageDefault(){
	
	var arExaReqID = getParam("arExaReqID");
	var arExaReqNo = getParam("arExaReqNo");
	runClassMethod("web.DHCAPPExaReportQuery","GetExaReqHtmlContent",{"arReqID":arExaReqID,"arExaReqNo":arExaReqNo},function(jsonString){

		if (jsonString != null){
			showHtml(jsonString);
		}
	},'json',false)
}

/// 生成申请单html
function showHtml(ExaRepObj){
	
	var arExaReqCode = "";
	if (ExaRepObj.arExaReqCode.indexOf("CT") != "-1"){
		arExaReqCode = "CT";
	}
	if (ExaRepObj.arExaReqCode.indexOf("CS") != "-1"){
		arExaReqCode = "超声";
	}
	if (ExaRepObj.arExaReqCode.indexOf("HC") != "-1"){
		arExaReqCode = "核磁";
	}
	if (ExaRepObj.arExaReqCode.indexOf("WJ") != "-1"){
		arExaReqCode = "胃镜";
	}
	if (ExaRepObj.arExaReqCode.indexOf("XD") != "-1"){
		arExaReqCode = "心电";
	}
	var htmlstr = "";
	htmlstr = htmlstr +"<div style='margin:0 auto; width:950px; height:640px; font-family: "+"黑体"+";font-size: 16px;'>"
	htmlstr = htmlstr +"<div style='width:100%; text-align:center; '>"
	htmlstr = htmlstr +"<h2 style='padding: 0; margin: 0; line-height: 25px; '>河南省人民医院</h2>"
	htmlstr = htmlstr +"<h1 style='padding: 0; margin: 0; line-height: 25px; font-weight: bold; font-size: 30px; font-weight: bold;'>"+arExaReqCode+"&nbsp;检查申请单</h1>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='width:100%;'>"
	htmlstr = htmlstr +"<div style='margin:8px 5px;'>"
	htmlstr = htmlstr +"<span style='width:20%; margin:0px 10px; display:inline-block;'>登&nbsp;记&nbsp;号：<span style='padding-left:10px;'>"+ExaRepObj.PatNo+"</span></span>"
	htmlstr = htmlstr +"<span style='width:20%; margin:0px 45px; display:inline-block;'> 姓&nbsp;&nbsp;名：<span style='padding-left:10px;'>"+ExaRepObj.PatName+"</span></span>"
	htmlstr = htmlstr +"<span style='width:20%; margin:0px 10px; display:inline-block;'>年&nbsp;&nbsp;龄：<span style='padding-left:10px;'>"+ExaRepObj.PatAge+"</span></span>"
	htmlstr = htmlstr +"<span style='width:20%; margin:0px 10px; display:inline-block;'>病&nbsp;&nbsp;历&nbsp;&nbsp;号：<span style='padding-left:10px;'></span></span>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='margin:8px 5px;'>"
	htmlstr = htmlstr +"<span style='width:20%; margin:0px 10px; display:inline-block;'>就诊科室：<span style='padding-left:10px;'>"+ExaRepObj.PatLoc+"</span></span>"
	htmlstr = htmlstr +"<span style='width:20%; margin:0px 45px; display:inline-block;'>性&nbsp;&nbsp;别：<span style='padding-left:10px;'>"+ExaRepObj.PatSex+"</span></span>"
	htmlstr = htmlstr +"<span style='width:20%; margin:0px 10px; display:inline-block;'>医保手册号：<span style='padding-left:10px;'></span></span>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='width:100%; border:1px solid #000;'>"
	htmlstr = htmlstr +"<div style='margin:8px 5px;'>"
	htmlstr = htmlstr +"<div>"
	htmlstr = htmlstr +"<span style='padding-left:20px;'>主诉、临床症状、体征及实验室检查：</span>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='height:65px;padding-left:40px;'>"
	if (ExaRepObj.arExaReqSym != ""){
		ExaRepObj.arExaReqSym = ExaRepObj.arExaReqSym+"、"
	}
	if (ExaRepObj.arHisDesc != ""){
		ExaRepObj.arHisDesc = ExaRepObj.arHisDesc+"、"
	}
	htmlstr = htmlstr +"<p style='margin-top:5px;'>"+ExaRepObj.arExaReqSym+ExaRepObj.arHisDesc+ExaRepObj.arSigDesc+"</p>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='margin:8px 5px;'>"
	htmlstr = htmlstr +"<div>"
	htmlstr = htmlstr +"<span style='padding-left:20px;'>临床诊断：</span>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='height:30px;padding-left:40px;'>"
	htmlstr = htmlstr +"<p style='margin-top:5px;'>"+ExaRepObj.PatDiag+"</p>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='margin:8px 5px;'>"
	htmlstr = htmlstr +"<div>"
	htmlstr = htmlstr +"<span style='padding-left:20px;'>检查项目：</span>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='height:40px;padding-left:40px;'>"
	htmlstr = htmlstr +"<p>"+ExaRepObj.itemdesc+"</p>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='margin:8px 5px;'>"
	htmlstr = htmlstr +"<div>"
	htmlstr = htmlstr +"<span style='padding-left:20px;'>特殊病史、检查异常：</span>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='height:60px;padding-left:40px;'>"
	
	var OptListData = ExaRepObj.OptListData;
	if (OptListData !="" ){
		var OptArr = OptListData.split("#");
		for (var n=0; n<OptArr.length; n++){
			if (n%4 == 0){
				htmlstr = htmlstr +"<div style='padding-top:5px;padding-bottom:5px;'>";
			}
			htmlstr = htmlstr +"<span style='margin-left:60px;'>"+ OptArr[n] +"</span>";
			if (((n != 0)&((n+1)%4 == 0))||(n == (OptArr.length-1))){
				htmlstr = htmlstr +"</div>";
			}
		}
	}

	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"</div>"
	/*
	htmlstr = htmlstr +"<div style='width:100%; height:25px; padding-top:15px; border:1px solid #000; '>"
	htmlstr = htmlstr +"<span style='width:30%;padding-left:20px;margin:0px 10px; display:inline-block;'>上机技师：<span style='padding-left:10px;'></span></span>"
	htmlstr = htmlstr +"<span style='width:30%;margin:0px 10px; display:inline-block;'>上机医师：<span style='padding-left:10px;'></span></span>"
	htmlstr = htmlstr +"<span style='width:20%;margin:0px 10px; display:inline-block;'>检查时间：<span style='padding-left:10px;'></span></span>"
	htmlstr = htmlstr +"</div>"
	*/
	htmlstr = htmlstr +"<div style='margin:8px 5px;'>"
	htmlstr = htmlstr +"<span style='padding-left:8px;width:30%; margin:0px 10px; display:inline-block;'>接收科室：<span style='padding-left:10px;'>"+ExaRepObj.arRepExLoc+"</span></span>"
	htmlstr = htmlstr +"<span style='width:30%; margin:0px 10px; display:inline-block;'>申请时间：<span style='padding-left:10px;'>"+ExaRepObj.arReqTime+"</span></span>"
	htmlstr = htmlstr +"<span style='width:20%; margin:0px 10px; display:inline-block;'>申请医生：<span style='padding-left:10px;'>"+ExaRepObj.arUserCode+"</span></span>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='margin-top:0px; padding-left:20px; font-family: "+"黑体"+";font-size: 16px;'>"
	
	if (ExaRepObj.arExaReqCode.indexOf("CT") != "-1"){
		htmlstr = htmlstr +"<div><span>各位患者请注意：</span></div>";
		htmlstr = htmlstr +"<div><span>1.腹部CT检查需禁食4小时，盆腔CT检查需充盈膀胱。</span></div>";
		htmlstr = htmlstr +"<div><span>2.增强检查前除空腹外，还需做碘过敏试验，签署知情同意书。</span></div>";
		htmlstr = htmlstr +"<div><span>3.检查时请携带病历及X线片(平片及造影)、超声、既往CT等检查结果。</span></div>";
	}
	
	if (ExaRepObj.arExaReqCode.indexOf("WJ") != "-1"){
		htmlstr = htmlstr +"<div><span>各位患者请注意：</span></div>";
		htmlstr = htmlstr +"<div><span>1.检查前12小时内禁食有形食物，可饮无色液体(水或饮料)。</span></div>";
		htmlstr = htmlstr +"<div><span>2.检查前半小时内勿饮水。</span></div>";
	}
		
	if (ExaRepObj.arExaReqCode.indexOf("HC") != "-1"){
		htmlstr = htmlstr +"<div><span>各位患者请注意：</span></div>";
		htmlstr = htmlstr +"<div><span>1.头颈部检查的患者请于检查前一天洗头，不要使用任何护发用品。腹部检查者(肝、胆、胰、脾及泌尿系脏器)检查前禁食4小时。</span></div>";
		htmlstr = htmlstr +"<div><span>2.检查时请携带病历及X线片(平片及造影)、超声、CT等检查结果。</span></div>";
		htmlstr = htmlstr +"<div><span>3.患者须向工作人员说明有无手术史，有无金属或磁性物质植入体内，包括宫内节育器、义齿、电子耳等，有无药物过敏史。</span></div>";
		htmlstr = htmlstr +"<div><span>4.检查时不要穿戴有金属物质的内衣裤，除去体表金属饰物，如项链、耳环、手表、戒指等，除去脸上化妆品及义齿、义眼、眼镜等。</span></div>";
	}
		
	if (ExaRepObj.arExaReqCode.indexOf("CS") != "-1"){
		htmlstr = htmlstr +"<div><span>各位患者请注意：</span></div>";
		htmlstr = htmlstr +"<div><span>1.肝脏、胆囊、胆道系统、胰腺、门静脉血流检测等超声检查时，需空腹(8-12小时)。</span></div>";
		htmlstr = htmlstr +"<div><span>2.妇科(子宫及附件)疾患、早孕、前置胎盘、膀胱等经腹超声检查时，需要充盈膀胱。</span></div>";
		htmlstr = htmlstr +"<div><span>3.做过胆系造影、钡剂检查、增强CT检查的患者，需3天后空腹才能做超声检查。若胃镜和超声同一天检查，需先做超声后做胃镜。</span></div>";
		htmlstr = htmlstr +"<div><span>4.检查时请携带病历及X线片(平片及造影)、既往超声等检查结果。</span></div>";
	}
	
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"</div>";

	$("body").html(htmlstr);
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })