///DHCAppPrintCom  
///打印CT,超声，核磁，胃镜，心电通用js,供界面调用
///Input:         检查报告申请表DHC_AppReport id串串，以^分隔（from report.js）
///Creator：      huaxiaoying
///CreatDate：    2016-04-20
function print_OLD(arItemIdList){
	
	//var arItemIdList="9";
	//alert(arItemIdList)
	var repIDArray=arItemIdList.split("^");
	for (var i=0;i<repIDArray.length;i++)
	{
		var repID=repIDArray[i];
		runClassMethod(
   			"web.DHCAPPPrintCom",
   			 "getData",
   			 {   //'RepID':22,
	   			 'RepID':repID
	   		 },function(data){
		   		 
		   		 var reptype=data.PACatDesc
		   		 if(reptype.indexOf("CT") != "-1"){
		   		 
			   		 printCT(data);
			   	 }else if(reptype.indexOf("CS") != "-1"){
			   	 
				   	 printCS(data);
				 }else if(reptype.indexOf("HC") != "-1"){
					 
					 printHC(data);
				 }else if(reptype.indexOf("WJ") != "-1"){
						 
					 printWJ(data);
				 }else if(reptype.indexOf("XD") != "-1"){
							 
					 printXD(data);
				 }else{
			     	
			     	 printNT(data);     /// 其他常规申请模板 bianshuai 2016-08-23
			     }
		   		 
		   		 
		   		             },"json")
	}
	      
}     
 ///CT				
function printCT(data){
  
   
		   		 	   DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_CT"); 
		   		 	   //var MyPara="";	
					   var MyPara="RegNo"+String.fromCharCode(2)+data.RegNo;
					   MyPara=MyPara+"^Name"+String.fromCharCode(2)+data.Name;
					   MyPara=MyPara+"^Age"+String.fromCharCode(2)+data.Age;
					   MyPara=MyPara+"^MedicareNo"+String.fromCharCode(2)+data.MedicareNo;
					   MyPara=MyPara+"^InLoc"+String.fromCharCode(2)+data.InLoc;
					   MyPara=MyPara+"^Sex"+String.fromCharCode(2)+data.Sex;
					   MyPara=MyPara+"^InsuranceNo"+String.fromCharCode(2)+data.InsuranceNo;
					   MyPara=MyPara+"^PatientNowValue1"+String.fromCharCode(2)+data.PatientNowValue1;
					   MyPara=MyPara+"^PatientNowValue2"+String.fromCharCode(2)+data.PatientNowValue2;
					   MyPara=MyPara+"^PatientNowValue3"+String.fromCharCode(2)+data.PatientNowValue3;
					   MyPara=MyPara+"^MainDiagoseValue1"+String.fromCharCode(2)+data.MainDiagoseValue1;
					   MyPara=MyPara+"^MainDiagoseValue2"+String.fromCharCode(2)+data.MainDiagoseValue2;
					   MyPara=MyPara+"^PurposeValue1"+String.fromCharCode(2)+data.PurposeValue1;
					   MyPara=MyPara+"^PurposeValue2"+String.fromCharCode(2)+data.PurposeValue2;
					   MyPara=MyPara+"^PurposeValue3"+String.fromCharCode(2)+data.PurposeValue3;
					   MyPara=MyPara+"^IsGao"+String.fromCharCode(2)+data.IsGao;
					   MyPara=MyPara+"^IsXin"+String.fromCharCode(2)+data.IsXin;
					   MyPara=MyPara+"^IsTang"+String.fromCharCode(2)+data.IsTang;
					   MyPara=MyPara+"^IsShen"+String.fromCharCode(2)+data.IsShen;
					   MyPara=MyPara+"^IsGan"+String.fromCharCode(2)+data.IsGan;
					   MyPara=MyPara+"^IsDian"+String.fromCharCode(2)+data.IsDian;
					   MyPara=MyPara+"^IsOther"+String.fromCharCode(2)+data.IsOther;
					   MyPara=MyPara+"^RecLoc"+String.fromCharCode(2)+data.RecLoc;
					   MyPara=MyPara+"^LocAddress"+String.fromCharCode(2)+data.LocAddr;
					   MyPara=MyPara+"^HopeDate"+String.fromCharCode(2)+data.HopeDate;
					   MyPara=MyPara+"^AppDoc"+String.fromCharCode(2)+data.AppDoc;
    		           //alert(MyPara)
					   var myobj=document.getElementById("ClsBillPrint");
					   DHCP_PrintFun(myobj,MyPara,"");
		   		   
		   	
}
///超声
function printCS(data){	   		 
   
		   		      
		   		 	   DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_CS"); 
		   		 	   //var MyPara="";	
					   var MyPara="RegNo"+String.fromCharCode(2)+data.RegNo;
					   MyPara=MyPara+"^Name"+String.fromCharCode(2)+data.Name;
					   MyPara=MyPara+"^Age"+String.fromCharCode(2)+data.Age;
					   MyPara=MyPara+"^MedicareNo"+String.fromCharCode(2)+data.MedicareNo;
					   MyPara=MyPara+"^InLoc"+String.fromCharCode(2)+data.InLoc;
					   MyPara=MyPara+"^Sex"+String.fromCharCode(2)+data.Sex;
					   MyPara=MyPara+"^InsuranceNo"+String.fromCharCode(2)+data.InsuranceNo;
					   //MyPara=MyPara+"^PatientNow"+String.fromCharCode(2)+data.PatientNowValue1;
					   MyPara=MyPara+"^PatientNowValue1"+String.fromCharCode(2)+data.PatientNowValue1;
					   MyPara=MyPara+"^PatientNowValue2"+String.fromCharCode(2)+data.PatientNowValue2;
					   MyPara=MyPara+"^MainDiagoseValue1"+String.fromCharCode(2)+data.MainDiagoseValue1;
					   MyPara=MyPara+"^MainDiagoseValue2"+String.fromCharCode(2)+data.MainDiagoseValue2;
					   MyPara=MyPara+"^PurposeValue1"+String.fromCharCode(2)+data.PurposeValue1;
					   MyPara=MyPara+"^PurposeValue2"+String.fromCharCode(2)+data.PurposeValue2;
					   MyPara=MyPara+"^IsShen"+String.fromCharCode(2)+data.IsShen;
					   MyPara=MyPara+"^IsTang"+String.fromCharCode(2)+data.IsTang;
					   MyPara=MyPara+"^IsGan"+String.fromCharCode(2)+data.IsGan;
					   MyPara=MyPara+"^IsShou"+String.fromCharCode(2)+data.IsShou;
					   MyPara=MyPara+"^IsZhong"+String.fromCharCode(2)+data.IsZhong;
					   MyPara=MyPara+"^IsOther"+String.fromCharCode(2)+data.IsOther;
					   MyPara=MyPara+"^HBsAg"+String.fromCharCode(2)+data.HBsAg;
					   MyPara=MyPara+"^HCV"+String.fromCharCode(2)+data.HCV;
					   MyPara=MyPara+"^HIV"+String.fromCharCode(2)+data.HIV;
					   MyPara=MyPara+"^IsMei"+String.fromCharCode(2)+data.IsMei;
					   //MyPara=MyPara+"^Content_11"+String.fromCharCode(2)+data.Content_11;
					   MyPara=MyPara+"^RecLoc"+String.fromCharCode(2)+data.RecLoc;
					   MyPara=MyPara+"^LocAddress"+String.fromCharCode(2)+data.LocAddr;
					   MyPara=MyPara+"^HopeDate"+String.fromCharCode(2)+data.HopeDate;
					   MyPara=MyPara+"^AppDoc"+String.fromCharCode(2)+data.AppDoc;
				
					   var myobj=document.getElementById("ClsBillPrint");
					   DHCP_PrintFun(myobj,MyPara,"");
		   		   
}
///	核磁
function printHC(data){
	
		   		 	   DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_HC"); 
		   		 	   //var MyPara="";	
					   var MyPara="RegNo"+String.fromCharCode(2)+data.RegNo;
					   MyPara=MyPara+"^Name"+String.fromCharCode(2)+data.Name;
					   MyPara=MyPara+"^Age"+String.fromCharCode(2)+data.Age;
					   MyPara=MyPara+"^MedicareNo"+String.fromCharCode(2)+data.MedicareNo;
					   MyPara=MyPara+"^InLoc"+String.fromCharCode(2)+data.InLoc;
					   MyPara=MyPara+"^Sex"+String.fromCharCode(2)+data.Sex;
					   MyPara=MyPara+"^InsuranceNo"+String.fromCharCode(2)+data.InsuranceNo;
					   MyPara=MyPara+"^PatientNowValue1"+String.fromCharCode(2)+data.PatientNowValue1;
					   MyPara=MyPara+"^PatientNowValue2"+String.fromCharCode(2)+data.PatientNowValue2;
					   MyPara=MyPara+"^PatientNowValue3"+String.fromCharCode(2)+data.PatientNowValue3;
					   //MyPara=MyPara+"^PatientNowValue4"+String.fromCharCode(2)+PatientNowValue4;
					   MyPara=MyPara+"^MainDiagoseValue1"+String.fromCharCode(2)+data.MainDiagoseValue1;
					   MyPara=MyPara+"^MainDiagoseValue2"+String.fromCharCode(2)+data.MainDiagoseValue2;
					   MyPara=MyPara+"^PurposeValue1"+String.fromCharCode(2)+data.PurposeValue1;
					   MyPara=MyPara+"^PurposeValue2"+String.fromCharCode(2)+data.PurposeValue2;
					   MyPara=MyPara+"^IsGao"+String.fromCharCode(2)+data.IsGao;
					   MyPara=MyPara+"^IsXin"+String.fromCharCode(2)+data.IsXin;
					   MyPara=MyPara+"^IsTang"+String.fromCharCode(2)+data.IsTang;
					   MyPara=MyPara+"^IsShen"+String.fromCharCode(2)+data.IsShen;
					   MyPara=MyPara+"^IsGan"+String.fromCharCode(2)+data.IsGan;
					   MyPara=MyPara+"^IsOther"+String.fromCharCode(2)+data.IsOther;
					   MyPara=MyPara+"^Content_6"+String.fromCharCode(2)+data.IsOther1;
					   MyPara=MyPara+"^Content_7"+String.fromCharCode(2)+data.IsOther2;
					   MyPara=MyPara+"^Content_8"+String.fromCharCode(2)+data.IsOther3;
					   MyPara=MyPara+"^RecLoc"+String.fromCharCode(2)+data.RecLoc;
					   MyPara=MyPara+"^LocAddress"+String.fromCharCode(2)+data.LocAddr;
					   MyPara=MyPara+"^HopeDate"+String.fromCharCode(2)+data.HopeDate;
					   MyPara=MyPara+"^AppDoc"+String.fromCharCode(2)+data.AppDoc;
    				   
					   var myobj=document.getElementById("ClsBillPrint");
					   DHCP_PrintFun(myobj,MyPara,"");
		   		 
}
///	胃镜	
function printWJ(data){
 
		   		 	   DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_WJ"); 
		   		 	   //var MyPara="";	
					   var MyPara="RegNo"+String.fromCharCode(2)+data.RegNo;
					   MyPara=MyPara+"^Name"+String.fromCharCode(2)+data.Name;
					   MyPara=MyPara+"^Age"+String.fromCharCode(2)+data.Age;
					   MyPara=MyPara+"^MedicareNo"+String.fromCharCode(2)+data.MedicareNo;
					   MyPara=MyPara+"^InLoc"+String.fromCharCode(2)+data.InLoc;
					   MyPara=MyPara+"^Sex"+String.fromCharCode(2)+data.Sex;
					   MyPara=MyPara+"^InsuranceNo"+String.fromCharCode(2)+data.InsuranceNo;
					   MyPara=MyPara+"^PatientNowValue1"+String.fromCharCode(2)+data.PatientNowValue1;
					   MyPara=MyPara+"^PatientNowValue2"+String.fromCharCode(2)+data.PatientNowValue2;
					   MyPara=MyPara+"^PatientNowValue3"+String.fromCharCode(2)+data.PatientNowValue3;
					   //MyPara=MyPara+"^PatientNowValue4"+String.fromCharCode(2)+data.PatientNowValue4;
					   MyPara=MyPara+"^MainDiagoseValue1"+String.fromCharCode(2)+data.MainDiagoseValue1;
					   MyPara=MyPara+"^MainDiagoseValue2"+String.fromCharCode(2)+data.MainDiagoseValue2;
					   MyPara=MyPara+"^PurposeValue1"+String.fromCharCode(2)+data.PurposeValue1;
					   MyPara=MyPara+"^PurposeValue2"+String.fromCharCode(2)+data.PurposeValue2;
					   MyPara=MyPara+"^IsXin"+String.fromCharCode(2)+data.IsXin;
					   MyPara=MyPara+"^IsGao"+String.fromCharCode(2)+data.IsGao;
					   MyPara=MyPara+"^IsShen"+String.fromCharCode(2)+data.IsShen;
					   MyPara=MyPara+"^IsTang"+String.fromCharCode(2)+data.IsTang;
					   MyPara=MyPara+"^Content_5"+String.fromCharCode(2)+data.IsXiaoG;
					   MyPara=MyPara+"^Content_6"+String.fromCharCode(2)+data.IsXiaoC;
					   MyPara=MyPara+"^Content_7"+String.fromCharCode(2)+data.IsXiaoCX;
					   MyPara=MyPara+"^IsOther"+String.fromCharCode(2)+data.IsOther;
					   MyPara=MyPara+"^PLT"+String.fromCharCode(2)+data.PLT;
					   MyPara=MyPara+"^PTA"+String.fromCharCode(2)+data.PTA;
					   MyPara=MyPara+"^HBsAgY"+String.fromCharCode(2)+data.HBsAgY;
					   MyPara=MyPara+"^HCVY"+String.fromCharCode(2)+data.HCVY;
					   MyPara=MyPara+"^HIVY"+String.fromCharCode(2)+data.HIVY;
					   MyPara=MyPara+"^IsMeiY"+String.fromCharCode(2)+data.IsMeiY;
					   //MyPara=MyPara+"^Content_15"+String.fromCharCode(2)+data.Content_15;
					   MyPara=MyPara+"^IsShiD"+String.fromCharCode(2)+data.IsShiD;
					   MyPara=MyPara+"^IsXiR"+String.fromCharCode(2)+data.IsXiR;
					   //MyPara=MyPara+"^Content_18"+String.fromCharCode(2)+data.Content_18;
					   MyPara=MyPara+"^RecLoc"+String.fromCharCode(2)+data.RecLoc;
					   MyPara=MyPara+"^LocAddress"+String.fromCharCode(2)+data.LocAddr;
					   MyPara=MyPara+"^HopeDate"+String.fromCharCode(2)+data.HopeDate;
					   MyPara=MyPara+"^AppDoc"+String.fromCharCode(2)+data.AppDoc;
    				 
					   var myobj=document.getElementById("ClsBillPrint");
					   DHCP_PrintFun(myobj,MyPara,"");
		   		   
		   		 	
}
///心电
function printXD(data){		   		 
		   		      
		   		 	   DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_XD"); 
		   		 	   	
					   var MyPara="RegNo"+String.fromCharCode(2)+data.RegNo;
					   MyPara=MyPara+"^Name"+String.fromCharCode(2)+data.Name;
					   MyPara=MyPara+"^Age"+String.fromCharCode(2)+data.Age;
					   MyPara=MyPara+"^MedicareNo"+String.fromCharCode(2)+data.MedicareNo;
					   MyPara=MyPara+"^InLoc"+String.fromCharCode(2)+data.InLoc;
					   MyPara=MyPara+"^Sex"+String.fromCharCode(2)+data.Sex;
					   MyPara=MyPara+"^InsuranceNo"+String.fromCharCode(2)+data.InsuranceNo;
					   MyPara=MyPara+"^PatientNowValue1"+String.fromCharCode(2)+data.PatientNowValue1;
					   MyPara=MyPara+"^PatientNowValue2"+String.fromCharCode(2)+data.PatientNowValue2;
					   MyPara=MyPara+"^PatientNowValue3"+String.fromCharCode(2)+data.PatientNowValue3;
					   //MyPara=MyPara+"^PatientNowValue4"+String.fromCharCode(2)+data.PatientNowValue4;
					   MyPara=MyPara+"^MainDiagoseValue1"+String.fromCharCode(2)+data.MainDiagoseValue1;
					   MyPara=MyPara+"^MainDiagoseValue2"+String.fromCharCode(2)+data.MainDiagoseValue2;
					   MyPara=MyPara+"^PurposeValue1"+String.fromCharCode(2)+data.PurposeValue1;
					   MyPara=MyPara+"^PurposeValue2"+String.fromCharCode(2)+data.PurposeValue2;
					   MyPara=MyPara+"^IsYDH"+String.fromCharCode(2)+data.IsYDH;
					   MyPara=MyPara+"^IsJL"+String.fromCharCode(2)+data.IsJL;
					   MyPara=MyPara+"^Content_3"+String.fromCharCode(2)+data.HBsAgY;
					   MyPara=MyPara+"^Content_4"+String.fromCharCode(2)+data.HCVY;
					   MyPara=MyPara+"^Content_5"+String.fromCharCode(2)+data.HIVY;
					   MyPara=MyPara+"^Content_6"+String.fromCharCode(2)+data.IsMeiY;
					   MyPara=MyPara+"^Content_7"+String.fromCharCode(2)+data.IsOther; 
					   MyPara=MyPara+"^RecLoc"+String.fromCharCode(2)+data.RecLoc;
					   MyPara=MyPara+"^LocAddress"+String.fromCharCode(2)+data.LocAddr;
					   MyPara=MyPara+"^HopeDate"+String.fromCharCode(2)+data.HopeDate;
					   MyPara=MyPara+"^AppDoc"+String.fromCharCode(2)+data.AppDoc;
    				   
					   var myobj=document.getElementById("ClsBillPrint");
					   DHCP_PrintFun(myobj,MyPara,"");
		   			
}

///常规
function printNT(data){		   		 
		   		      
		   		 	   DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_NT"); 
		   		 	   	
					   var MyPara="RegNo"+String.fromCharCode(2)+data.RegNo;
					   MyPara=MyPara+"^ReqTitle"+String.fromCharCode(2)+data.ItmCatDesc+"检查申请单";

					   MyPara=MyPara+"^Name"+String.fromCharCode(2)+data.Name;
					   MyPara=MyPara+"^Age"+String.fromCharCode(2)+data.Age;
					   MyPara=MyPara+"^MedicareNo"+String.fromCharCode(2)+data.MedicareNo;
					   MyPara=MyPara+"^InLoc"+String.fromCharCode(2)+data.InLoc;
					   MyPara=MyPara+"^Sex"+String.fromCharCode(2)+data.Sex;
					   MyPara=MyPara+"^InsuranceNo"+String.fromCharCode(2)+data.InsuranceNo;
					   MyPara=MyPara+"^PatientNowValue1"+String.fromCharCode(2)+data.PatientNowValue1;
					   MyPara=MyPara+"^PatientNowValue2"+String.fromCharCode(2)+data.PatientNowValue2;
					   MyPara=MyPara+"^PatientNowValue3"+String.fromCharCode(2)+data.PatientNowValue3;
					   //MyPara=MyPara+"^PatientNowValue4"+String.fromCharCode(2)+data.PatientNowValue4;
					   MyPara=MyPara+"^MainDiagoseValue1"+String.fromCharCode(2)+data.MainDiagoseValue1;
					   MyPara=MyPara+"^MainDiagoseValue2"+String.fromCharCode(2)+data.MainDiagoseValue2;
					   MyPara=MyPara+"^PurposeValue1"+String.fromCharCode(2)+data.PurposeValue1;
					   MyPara=MyPara+"^PurposeValue2"+String.fromCharCode(2)+data.PurposeValue2;
					   MyPara=MyPara+"^IsYDH"+String.fromCharCode(2)+data.IsYDH;
					   MyPara=MyPara+"^IsJL"+String.fromCharCode(2)+data.IsJL;
					   MyPara=MyPara+"^Content_3"+String.fromCharCode(2)+data.HBsAgY;
					   MyPara=MyPara+"^Content_4"+String.fromCharCode(2)+data.HCVY;
					   MyPara=MyPara+"^Content_5"+String.fromCharCode(2)+data.HIVY;
					   MyPara=MyPara+"^Content_6"+String.fromCharCode(2)+data.IsMeiY;
					   MyPara=MyPara+"^Content_7"+String.fromCharCode(2)+data.IsOther; 
					   MyPara=MyPara+"^RecLoc"+String.fromCharCode(2)+data.RecLoc;
					   MyPara=MyPara+"^LocAddress"+String.fromCharCode(2)+data.LocAddr;
					   MyPara=MyPara+"^HopeDate"+String.fromCharCode(2)+data.HopeDate;
					   MyPara=MyPara+"^AppDoc"+String.fromCharCode(2)+data.AppDoc;
    				   
					   var myobj=document.getElementById("ClsBillPrint");
					   DHCP_PrintFun(myobj,MyPara,"");
		   			
}

///  打印调用统一模板
function printCom(arReqID){
	
	/// 取系统自动打印状态
	if (GetAutoPrintFlag("Exa") != "1") return;

	var arReqArr=arReqID.split("^");
	for (var i=0;i<arReqArr.length;i++){
		ExaReqPrint(arReqArr[i],"");
	}
}

///  打印调用统一模板
function printReq(arReqID){

	var arReqArr=arReqID.split("^");
	for (var i=0;i<arReqArr.length;i++){
		ExaReqPrint(arReqArr[i],"");
	}
}
///检验告知单打印
function printReqLab(arReqID){
	var arReqArr=arReqID.split("^");
	for (var i=0;i<arReqArr.length;i++){
		runClassMethod("web.DHCAPPPrintCom","GetExaLabPrintData",{"ExaReqID":arReqArr[i]},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("提示:","打印异常！");
		}else{
			UpdRepPrtInfo(arReqArr[i]);
			//////
			var respData=eval('(' + jsonString+ ')');
			if($.type(respData) === "array"){
				for(var j=0,len=respData.length;j<len;++j){
					var options={
						"ReadyJson":respData[j]["data"]
					};
				    //若后台返回的xml模板名不为空,则根据返回模板展示
					if ((respData[j]["templateId"]!="")&&(respData[j]["templateId"]!=undefined)){
						options["templateId"]=respData[j]["templateId"];
					}else if ((respData[j]["PrintTemp"]!="")&&(respData[j]["PrintTemp"]!=undefined)){
						var JsontempId=$.cm({
							ClassName:"web.DHCDocPrescript",
							MethodName:"GetXMLTemplateId",
							dataType:"text",
							XMLTemplateName:respData[j]["PrintTemp"]
						},false);
						options["templateId"]=JsontempId;
					}
					opdoc.print.common.print(options);
				}
			}else{
				var options={
					"ReadyJson":respData
				};
				opdoc.print.common.print(options);
			}
			/*
			var ExaReqObj = jsonString;
			var JsonArry=jsonString.split("!^^!")
			for(var jsonnum=0;jsonnum<JsonArry.length;jsonnum++){
				var PrintArry=JsonArry[jsonnum].split("!!!")
				var ExaReqObj=PrintArry[0];
				var ExaReqObj=eval('(' + ExaReqObj + ')');
				var MyList=PrintArry[1];
				Print_Xml_NewList(ExaReqObj,MyList);
			}
			*/
		}
	},'text',false)
	}
}

///  打印调用统一模板 检查/病理
///  bianshuai 2018-03-26
function Commonprint(mListData){
	/// 取系统自动打印状态
	//if (GetAutoPrintFlag() != 1) return;
	/*var PrintSet=$.m({
	    ClassName:"DHCDoc.DHCApp.BasicConfig",
	    MethodName:"GetConfigNode",
	    Node:"PrintSet"
	},false);*/
	var LgParam=session['LOGON.HOSPID'] +"^"+ session['LOGON.CTLOCID'] +"^"+ session['LOGON.USERID'] +"^"+ session['LOGON.GROUPID'];
	var PrintSet=$.m({
	    ClassName:"DHCDoc.DHCApp.BasicConfig",
	    MethodName:"GetAppPrtSetConfig",
	    AdmType:"",
	    Type:"Pis",
	    LgParam:LgParam
	},false);
	runClassMethod("web.DHCAPPPrintCom","GetJsonReqPrtObj",{"mListData": mListData},function(jsonObj){
		if (jsonObj == null){
			$.messager.alert("提示:","打印异常！");
		}else{
			for (var i=0;i<jsonObj.length;i++){
				if (jsonObj[i].Type == "P"){
					if (PrintSet!="noprint") {
						/// 打印病理申请单
						PrintPis_REQ(jsonObj[i].ID);
					}
				}else if (jsonObj[i].Type == "E") {
					var AutoPrintFlag=GetAutoPrintFlag("Exa");
					if(AutoPrintFlag==1){
						/// 打印检查申请单
						ExaReqPrint(jsonObj[i].ID,"");
					}
				}else if (jsonObj[i].Type == "L") {
					var AutoPrintFlag=GetAutoPrintFlag("Lab");
					if(AutoPrintFlag==1){
						/// 打印检验申请单
						printReqLab(jsonObj[i].ID);
					}
				}
			}
		}
	},'json',false)
}

/// 检查申请单打印
function ExaReqPrint(ExaReqID,ExaReqNo){

	runClassMethod("web.DHCAPPPrintCom","GetExaReqPrintData",{"ExaReqID":ExaReqID, "ExaReqNo":ExaReqNo},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("提示:","打印异常！");
		}else{
			if (!$.isEmptyObject(jsonString)) {
				UpdRepPrtInfo(ExaReqID);
				var ExaReqObj = jsonString;
				Print_Xml_New(ExaReqObj);
			}
		}
	},'json',false)
}

///常规
function Print_Xml(ExaReqObj){		   		 
		   		      
	// DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_NT");
	if (ExaReqObj.PrintTemp == ""){
		ExaReqObj.PrintTemp = "DHCAPP_NT";
	} 
	DHCP_GetXMLConfig("InvPrintEncrypt",ExaReqObj.PrintTemp);
	
	var LabelName = ["","","","",""];   /// 初始化空数组
	var PatSymInfo = ExaReqObj.PatSymInfo;
	var len = 0; j = 0; k = 0;
	for (var i=0; i<PatSymInfo.length; i++) {      //bianshuai  截取药名
		var c = PatSymInfo.charCodeAt(i);   
		//单字节加1    
		if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {   
			len++;   
		}else{   
			len+=2;   
		}

		if(((len%86 == 0)||(len%86 == 1))&(len != 1)){
			
			if ((i - k) < 2) continue;
			LabelName[j] = PatSymInfo.substr(k, i-k);  /// 截取字符串
			if (j == 4){
				LabelName[j] = LabelName[j] + "...";   /// 最后一个字符串后面加...
				break;
			}
			j = j + 1;
			k = i;
		}
		if ((i == PatSymInfo.length - 1)&(k != i)){
			LabelName[j] = PatSymInfo.substr(k, (i-k)+1);
		}
	}
	var NoteList=ExaReqObj.NoteList
	var Note=NoteList.split("$")
	var str=" "+" "+" "+" "+" "+" "+" "+" "+" "+" "+" ";
	var list=""
	for (var i=0;i<Note.length;i++)
	{
		var ListData=Note[i];
		if (i>0)
		{
			ListData=str+" "+ListData;
		}
		if (list=="")
		{
			list=ListData;
			}
			else {
					list=list+"$"+ListData;
				}
				
	}
	while(list.indexOf('$') >= 0)
	{
		list = list.replace('$','\n');
	}
	var MyPara="RegNo"+String.fromCharCode(2)+ExaReqObj.PatNo;
	MyPara=MyPara+"^hopName"+String.fromCharCode(2)+ExaReqObj.ExaReqTitle;
	MyPara=MyPara+"^ExaReqTitle"+String.fromCharCode(2)+"检查申请单"+ExaReqObj.PrintFlag;
	MyPara=MyPara+"^EmgFlag"+String.fromCharCode(2)+ExaReqObj.arEmgFlag;
	MyPara=MyPara+"^PatNo"+String.fromCharCode(2)+"*"+ExaReqObj.PatNo+"*";
	MyPara=MyPara+"^Name"+String.fromCharCode(2)+ExaReqObj.PatName;
	MyPara=MyPara+"^Age"+String.fromCharCode(2)+ExaReqObj.PatAge;
	MyPara=MyPara+"^MedicareNo"+String.fromCharCode(2)+ExaReqObj.MedicareNo;
	MyPara=MyPara+"^InLoc"+String.fromCharCode(2)+ExaReqObj.PatLoc;
	MyPara=MyPara+"^Sex"+String.fromCharCode(2)+ExaReqObj.PatSex;
	MyPara=MyPara+"^InsuranceNo"+String.fromCharCode(2)+ExaReqObj.InsuranceNo;
	MyPara=MyPara+"^PatientNowValue1"+String.fromCharCode(2)+LabelName[0];
	MyPara=MyPara+"^PatientNowValue2"+String.fromCharCode(2)+LabelName[1];
	MyPara=MyPara+"^PatientNowValue3"+String.fromCharCode(2)+LabelName[2];
	MyPara=MyPara+"^PatientNowValue4"+String.fromCharCode(2)+LabelName[3];
	MyPara=MyPara+"^PatientNowValue5"+String.fromCharCode(2)+LabelName[4];
	MyPara=MyPara+"^MainDiagoseValue1"+String.fromCharCode(2)+ExaReqObj.PatDiagDesc1;
	MyPara=MyPara+"^MainDiagoseValue2"+String.fromCharCode(2)+ExaReqObj.PatDiagDesc2;
	MyPara=MyPara+"^PurposeValue1"+String.fromCharCode(2)+ExaReqObj.arItemDesc1;
	MyPara=MyPara+"^PurposeValue2"+String.fromCharCode(2)+ExaReqObj.arItemDesc2; 
	MyPara=MyPara+"^RecLoc"+String.fromCharCode(2)+ExaReqObj.arRepExLoc;
	MyPara=MyPara+"^LocAddress"+String.fromCharCode(2)+ExaReqObj.arRepExLocAdrr;
	MyPara=MyPara+"^HopeDate"+String.fromCharCode(2)+ExaReqObj.arReqTime;
	MyPara=MyPara+"^AppDoc"+String.fromCharCode(2)+ExaReqObj.arUserCode;
	MyPara=MyPara+"^CardNo"+String.fromCharCode(2)+ExaReqObj.CardNo;
	MyPara=MyPara+"^PatCardMoney"+String.fromCharCode(2)+ExaReqObj.PatCardMoney;
	MyPara=MyPara+"^ExaReqNoCost"+String.fromCharCode(2)+ExaReqObj.ExaReqNoCost;
	MyPara=MyPara+"^OthOptList"+String.fromCharCode(2)+ExaReqObj.OthOptList;
	MyPara=MyPara+"^Type"+String.fromCharCode(2)+ExaReqObj.Type;   ///sufan  2017-03-15 add 
	MyPara=MyPara+"^SSDesc"+String.fromCharCode(2)+ExaReqObj.SSDesc;
	MyPara=MyPara+"^AdmBed"+String.fromCharCode(2)+ExaReqObj.AdmBed;
	MyPara=MyPara+"^NoteList"+String.fromCharCode(2)+list;
	MyPara=MyPara+"^InsuCardNo"+String.fromCharCode(2)+ExaReqObj.InsuCardNo;
	MyPara=MyPara+"^InsuNo"+String.fromCharCode(2)+ExaReqObj.InsuNo;
	MyPara=MyPara+"^PrintFlag"+String.fromCharCode(2)+ExaReqObj.PrintFlag;	///sufan 2018-02-05add 
	MyPara=MyPara+"^PreInFlag"+String.fromCharCode(2)+ExaReqObj.PreInFlag;	///bianshaui 2018-07-23
	MyPara=MyPara+"^GreenFlag"+String.fromCharCode(2)+ExaReqObj.GreenFlag;	///sufan 2018-10-22
	MyPara=MyPara+"^Location"+String.fromCharCode(2)+ExaReqObj.arRepExLocAdrr+"  "+ExaReqObj.arRepExLoc +"  "+"刷卡检查";

	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,MyPara,"");
		   			
}

/// 取系统自动打印状态 AutoPrint
function GetAutoPrintFlag(Type){
	
	var PrintFlag = "";
	if (typeof GlobalObj != "undefined"){
		EpisodeID = GlobalObj.EpisodeID
	}
	var LgParam = session['LOGON.HOSPID'] +"^"+ session['LOGON.CTLOCID'] +"^"+ session['LOGON.USERID'] +"^"+ session['LOGON.GROUPID'];
	runClassMethod("web.DHCAPPExaReportQuery","GetAutoPrintFlag",{"EpisodeID":EpisodeID, "LgParam":LgParam,"Type":Type},function(jsonString){
		
		if (jsonString != null){
			PrintFlag = jsonString;
		}
	},'',false)
	return PrintFlag;
}
///sufan 2018-02-05 打印完更新打印人，打印日期，打印时间
function UpdRepPrtInfo(ExaReqID)
{
	var Printuser = session['LOGON.USERID']   ///打印人
//	runClassMethod("web.DHCAPPExaReport","UpdNurPrtInfo",{"ExaReqID":ExaReqID, "PrtUserID":Printuser},function(data){
//		
//	},'',false)
//  增加修改医嘱打印标志 2018-12-13 bianshuai
	runClassMethod("web.DHCAPPExaReport","InsExaRepPrtFlag",{"ExaReqID":ExaReqID, "PrtUserID":Printuser},function(data){},'',false)
}

///常规
function Print_Xml_New(ExaReqObj){		   		 
		   		      
	DHCP_GetXMLConfig("InvPrintEncrypt",ExaReqObj.PrintTemp);
	
	var MyPara = "" + String.fromCharCode(2);
	for (Element in ExaReqObj){
		MyPara=MyPara +"^"+ Element + String.fromCharCode(2) + ExaReqObj[Element];
	}
	
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,MyPara,"");
	DHC_PrintByLodop(getLodop(),MyPara,"","","");	   			
}
function Print_Xml_NewList(ExaReqObj,ListObj){		   		 
		   		      
	DHCP_GetXMLConfig("InvPrintEncrypt",ExaReqObj.PrintTemp);
	
	var MyPara = "" + String.fromCharCode(2);
	for (Element in ExaReqObj){
		MyPara=MyPara +"^"+ Element + String.fromCharCode(2) + ExaReqObj[Element];
	}
	
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,MyPara,ListObj);
		   			
}
