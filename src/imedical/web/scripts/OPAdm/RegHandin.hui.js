var PageLogicObj={
	m_FootInfo:"",
	m_PrintInfo:"",
	m_PrintListInfo:"",
	m_PrintListInfo:""
}
$(function(){
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
})
function InitEvent(){
	$("#BFind").click(BFindClickHandle);
	$("#BFoot").click(BFootClickHandle);
	$("#BPrint").click(BPrintClickHandle);
}
function BFindClickHandle(){
	if ($("#BFind").hasClass('l-btn-disabled')){
		return false;
	}
	DisableBtn("BFind",true);
	DisableBtn("BPrint",true);  
	DisableBtn("BFoot",true);   
	PageLogicObj.m_FootInfo="";
	var rtn=tkMakeServerCall("web.UDHCJFOPHandinReg11","GetHandin",'SetHandsum','',session['LOGON.USERID']);
	if (rtn==0){
		DisableBtn("BPrint",false);  
		DisableBtn("BFoot",false);  
	}else{
		DisableBtn("BPrint",true);  
		DisableBtn("BFoot",true); 
	}
	DisableBtn("BFind",false);
}
function BFootClickHandle(){
	if ($("#BFoot").hasClass('l-btn-disabled')){
		return false;
	}
	BFindClickHandle();
	$.messager.confirm('确认对话框', '确定要结算吗?', function(r){
		if (r){
	    	$.cm({
				ClassName:"web.UDHCJFOPHandinReg11",
				MethodName:"Handin",
				sUser:session['LOGON.USERID'], FootInfo:PageLogicObj.m_FootInfo,
				dataType:"text"
			},function(rtn){
				var mytmpary=rtn.split("^");
				if (mytmpary[0]=="0") {
					$.messager.alert("提示","结算成功!","info",function(){
						DisableBtn("BPrint",false);  
						DisableBtn("BFoot",true);  
					});
				}else{
					if(mytmpary[1]==""){
						$.messager.alert("提示","结算失败,插入结算主表错误!");
					}else{
						$.messager.alert("提示","结算失败,更新票据流水表错误!");
					}
				}
			});
		}
	});
}
function BPrintClickHandle(){
	if ($("#BPrint").hasClass('l-btn-disabled')){
		return false;
	}
	var myPrtXMLName="UDHCRegHandinRpt"
    DHCP_GetXMLConfig("InvPrintEncrypt",myPrtXMLName);
	if (PageLogicObj.m_PrintInfo!=""){
		XMLPrint(PageLogicObj.m_PrintInfo,PageLogicObj.m_PrintListInfo);
	}
}
function XMLPrint(TxtInfo,ListInfo){
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}
function DisableBtn(id,disabled){
	if (disabled){
		$HUI.linkbutton("#"+id).disable();
	}else{
		$HUI.linkbutton("#"+id).enable();
	}
}
function PageHandle(){
	DisableBtn("BPrint",true);  
	DisableBtn("BFoot",true);
	//历史结算记录明细
	GetRegHandinHis();
}
function GetRegHandinHis(){
	if (ServerObj.RepID=="") return;
	DisableBtn("BFind",true);
	DisableBtn("BFoot",true);
	$.cm({
		ClassName:"web.UDHCJFOPHandinReg11",
		MethodName:"GetRegHandinHis",
		RepID:ServerObj.RepID,
		dataType:"text"
	},function(rtn){
		SetHandsum(rtn);
		DisableBtn("BPrint",false); 
	});
}
function SetHandsum(value){
	PageLogicObj.m_FootInfo=value;
	PageLogicObj.m_PrintInfo="",PageLogicObj.m_PrintListInfo="";
	if (value=="") return;
	var myMInfo=value.split("^");
	$("#StartDate").val(myMInfo[0]);
	$("#StartTime").val(myMInfo[1]);
	$("#EndDate").val(myMInfo[2]);
	$("#EndTime").val(myMInfo[3]);
	$("#AmtSum").val(myMInfo[4]);
	$("#CashAmt").val(myMInfo[5]);
	$("#OtherAmt").val(myMInfo[6]);
	$("#Pamt").val(myMInfo[7]);
	$("#Ramt").val(myMInfo[8]);
	$("#ReceiptsNum").val(myMInfo[9]);
	$("#RefundNum").val(myMInfo[10]);
	$("#ReceiptsField").val(myMInfo[11]);
	$("#FirstAdmTot").val(myMInfo[12]);
	$("#FurtherAdmTot").val(myMInfo[13]);
	$("#DrugAdmTot").val(myMInfo[14]);
	$("#AdmTot").val(myMInfo[15]);
	$("#RefundAdmTot").val(myMInfo[16]);
	$("#AdmAmtSum").val(myMInfo[17]);
	$("#RefundNo").val(myMInfo[20]);
	var c2=String.fromCharCode(2);
	var PrintInfo="UserName"+c2+session['LOGON.USERNAME'];
	PrintInfo=PrintInfo+"^"+"Today"+c2+myMInfo[18];
	PrintInfo=PrintInfo+"^"+"StartDate"+c2+myMInfo[0];
	PrintInfo=PrintInfo+"^"+"StartTime"+c2+myMInfo[1];
	PrintInfo=PrintInfo+"^"+"EndDate"+c2+myMInfo[2];
	PrintInfo=PrintInfo+"^"+"EndTime"+c2+myMInfo[3];
	PrintInfo=PrintInfo+"^"+"AmtSum"+c2+myMInfo[4];
	PrintInfo=PrintInfo+"^"+"CashAmt"+c2+myMInfo[5];
	PrintInfo=PrintInfo+"^"+"OtherAmt"+c2+myMInfo[6];
	PrintInfo=PrintInfo+"^"+"Pamt"+c2+myMInfo[7];
	PrintInfo=PrintInfo+"^"+"Ramt"+c2+myMInfo[8];
	PrintInfo=PrintInfo+"^"+"ReceiptsNum"+c2+myMInfo[9];
	PrintInfo=PrintInfo+"^"+"RefundNum"+c2+myMInfo[10];
	PrintInfo=PrintInfo+"^"+"ReceiptsField"+c2+myMInfo[11];
	PrintInfo=PrintInfo+"^"+"FirstAdmTot"+c2+myMInfo[12];
	PrintInfo=PrintInfo+"^"+"FurtherAdmTot"+c2+myMInfo[13];
	PrintInfo=PrintInfo+"^"+"DrugAdmTot"+c2+myMInfo[14];
	PrintInfo=PrintInfo+"^"+"AdmTot"+c2+myMInfo[15];
	PrintInfo=PrintInfo+"^"+"RefundAdmTot"+c2+myMInfo[16];
	PrintInfo=PrintInfo+"^"+"AdmAmtSum"+c2+myMInfo[17];
	var PrintListInfo="";
	if (myMInfo[20]!=""){
		var tmpDEl="^"
		var myInfo=myMInfo[20].split(",");
		var n=myInfo.length%3
		for (var i=0;i<myInfo.length;i++){
			if ((i%3)==0){
				tmpDEl=c2;
			}else{
				tmpDEl="^";
			}
			if (PrintListInfo==""){
				PrintListInfo=myInfo[i];
			}else{
				PrintListInfo=PrintListInfo+tmpDEl+myInfo[i];
			}
		}
		if (n!=0){
			n=3-n
			for (var m=0;m<n;m++){
				PrintListInfo=PrintListInfo+"^";
			}
		}	
	}
	PageLogicObj.m_PrintInfo=PrintInfo;
	PageLogicObj.m_PrintListInfo=PrintListInfo;
}
