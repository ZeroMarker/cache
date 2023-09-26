var GROUPID=session['LOGON.GROUPID']
var iSeldRow=0
var TDivDr="",TDHCJFFlag="",TPaadm="",TBillNO="",TAdmReason="",THisType="",TDivFlag=""
//var repidsub="";
function BodyLoadHandler() { 
	///websys_setfocus2("RegNO")   ///为啥用不了？？？？
	var obj=document.getElementById("RegNO")
	if(obj){
		obj.focus();		
		obj.onkeydown=Reg_onkeydown;			
	}
	var obj=document.getElementById("PrtNO")
	if(obj){
		obj.onkeydown=Text_onkeydown;		
	}
	var obj=document.getElementById("PrtInv")
	if(obj){
		obj.onkeydown=Text_onkeydown;
	}
	var obj=document.getElementById("InsuNO")
	if(obj){obj.onkeydown=Text_onkeydown}
	
	var obj=document.getElementById("TradeNO");
	if(obj){
		obj.onkeydown=Text_onkeydown;
	}
	var obj=document.getElementById("DivideStrike")
	if (obj){
		obj.onclick=DivideStrike_onclick
			
	}
	

    // DingSH 2015-12-17
    var obj=document.getElementById("DiviStrikeForInsu")
	if (obj){
		obj.onclick=DiviStrikeForInsu_onclick
			
	}
	// DingSH 2015-12-17
    var obj=document.getElementById("DiviStrikeForHis")
	if (obj){
		obj.onclick=DiviStrikeForHis_onclick
			
	}
	var obj=document.getElementById("ReadCard")
	if (obj){
		obj.onclick=ReadCard_onclick
	}
	var obj=document.getElementById("AdmInfo")
	if(obj){
		obj.size=1
		obj.multiple=false
	}
	var obj=document.getElementById("InsuDllType")
	if (obj){
		var GetStr
		var QueStr=tkMakeServerCall("web.INSUDicDataCom","QueryDicData","DLLType","")
		if(QueStr.split("^")[0]==0){
			alert("医保字典DLLType接口类型未维护");
			return
		}
		obj.size=1
		obj.multiple=false
		for(var i=0;i<QueStr.split("^")[0];i++){
			GetStr=tkMakeServerCall("web.INSUDicDataCom","GetDicData",QueStr.split("^")[1],i+1)
			obj.options[i]=new Option(GetStr.split("^")[3],GetStr.split("^")[2]);	
			
		}
		var n=obj.length
		for (var i =0;i<n;i++){
			var Typeobj=document.getElementById("InsuDllTypeSave");
			if(obj.options[i].value==Typeobj.value){
				obj.options[i].selected=true
			}
		}
	}

	
	var obj=document.getElementById("RegCancel")
	if(obj){obj.onclick=RegCancel_click}
	
	document.getElementById("HisType").value="O"  //给默认值：门诊
	
	var expobj=document.getElementById("ExpStr")
	if(expobj){
		var expsaveobj=document.getElementById("ExpStrSave")
		if(expsaveobj){expobj.value=expsaveobj.value;}
		//StrikeFlag^安全组Dr^InsuNo^CardType^YLLB^DicCode^DicDesc^总金额！Money^MoneyType
		if(""==expobj.value){expobj.value="^"+GROUPID+"^^^^^^!0^"}
	}
	
	var obj=document.getElementById("BillDr") 
	if(obj){obj.style.display="none";}
	var obj=document.getElementById("cBillDr")
	if(obj){obj.style.display="none";}
	GetAdmInfoNew();
}
function ReadCard_onclick(){
	var InsuType=document.getElementById("InsuDllType").value
	var CardStr=InsuReadCard("0",session['LOGON.USERID'],"","",InsuType).toString() //3003313901
	if(CardStr.split("|").length<2){
		return;
	}
	CardStr=CardStr.split("|")[1]
	var InsuNO=CardStr.split("^")[0]    //根据返回的读卡信息，取出医保号id0000;根据insu_divide中Id0000的存储内容
	var InsuCardNO=CardStr.split("^")[1]
	document.getElementById("InsuNO").value=InsuNO
	document.getElementById("InsuCardNO").value=InsuCardNO
	//var obj=document.getElementById("InsuNO")
	//if(obj){alert(obj.value)}
	var obj=document.getElementById("DivQuery");
	if (obj) {
		DivQuery_click();
		//GetAdmInfo();
		GetAdmInfoNew();
	}	
	
}
function Reg_onkeydown(){
	var obj=document.getElementById("RegNO")
	if (obj){
		if (window.event.keyCode==13){
			/*
			var PapmiNoLength=10-obj.value.length;     //登记号补零 ,根据项目修改规定长度，这里为8  	
			if (obj){
				for (var i=0;i<PapmiNoLength;i++){
					obj.value="0"+obj.value;			
				}			
			}
			*/
			var tmpregno=tkMakeServerCall("web.UDHCJFBaseCommon","regnocon",obj.value)	//Zhan 20160725,登记号补全
			if(tmpregno.length>7){obj.value=tmpregno}
			var obj=document.getElementById("DivQuery");
			if (obj) {DivQuery_click();
			//GetAdmInfo() 
			GetAdmInfoNew();
			}
		}
	}
}
function Text_onkeydown(){
		if (window.event.keyCode==13){
			var obj=document.getElementById("DivQuery");
		    if (obj) {
			    DivQuery_click();
		    	//GetAdmInfo();
		    	GetAdmInfoNew();
		     }
	
		}
}

function GetAdmInfo(){
	return;
	var AdmInfo=tkMakeServerCall("web.DHCINSUDivQue","GetAdmInfoEx")
	if(AdmInfo!=""){
		var obj=document.getElementById("AdmInfo")
		if(obj){
			obj.size=1
			obj.multiple=false
			for(var i=1;i<(AdmInfo.split("!").length-1);i++){
				obj.options[i-1]=new Option(AdmInfo.split("!")[i],AdmInfo.split("!")[i].split("^")[0]+"^"+AdmInfo.split("!")[i].split("^")[3])
				}		
			}		
	}
		
}
function GetAdmInfoNew(){
	var AdmInfo=tkMakeServerCall("web.DHCINSUDivQue","GetAdmInfoEx",repidsub)
	if(AdmInfo!=""){
		var obj=document.getElementById("AdmInfo")
		if(obj){
			obj.size=1
			obj.multiple=false
			for(var i=0;i<AdmInfo.split("!").length;i++){
				obj.options[i]=new Option(AdmInfo.split("!")[i],AdmInfo.split("!")[i].split("^")[0]+"^"+AdmInfo.split("!")[i].split("^")[3])
				}		
			}		
	}
		
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tInsuOPDivideQuery');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (iSeldRow==selectrow){TDivDr="",iSeldRow=0;return}
	iSeldRow=selectrow;
	var SelRowObj
	SelRowObj=document.getElementById('TDivDrz'+selectrow);
	if (SelRowObj){TDivDr=SelRowObj.innerText}
	else{TDivDr=""}
	
	SelRowObj=document.getElementById('TPaadmz'+selectrow);
	if (SelRowObj){TPaadm=SelRowObj.innerText}
	else{TPaadm=""}
	
	SelRowObj=document.getElementById('TPrtNOz'+selectrow);
	if (SelRowObj){TPrtNO=SelRowObj.innerText}
	else{TPrtNO=""}
	
	SelRowObj=document.getElementById('TBillNOz'+selectrow);
	if (SelRowObj){TBillNO=SelRowObj.innerText}
	else{TBillNO=""}
	
	SelRowObj=document.getElementById('TDHCJFFlagz'+selectrow);
	if (SelRowObj){TDHCJFFlag=SelRowObj.innerText}
	else{TDHCJFFlag=""}
	
	SelRowObj=document.getElementById('THisTypez'+selectrow);
	if (SelRowObj){THisType=SelRowObj.innerText}
	else{THisType=""}
	
	SelRowObj=document.getElementById('TAdmReasonz'+selectrow);
	if (SelRowObj){TAdmReason=SelRowObj.innerText}
	else{TAdmReason=""}
	
	SelRowObj=document.getElementById('TDivFlagz'+selectrow);
	if (SelRowObj){TDivFlag=SelRowObj.innerText}
	else{TDivFlag=""}
}
function DivideStrike_onclick(){
	
	 var insutype="";
     insutype=document.getElementById("InsuDllType").value;
     if(""==insutype){alert("请选择医保类型");return;}
     TAdmReason=tkMakeServerCall("web.INSUDicDataCom","GetDicBybillAndInd","AdmReasonDrToDLLType",insutype,3);
    
	//alert(TAdmReason)
	if (TDivDr==""){
		alert("未选中任何记录")
		return		
	}

	if (TDHCJFFlag=="N"||TDHCJFFlag=="P"){
		alert("此记录在His中已正常结算，请在His端发起退费")
		return	
	}
	if("正常"!=TDivFlag){alert("此记录非正常结算状态");return;}
    var obj=document.getElementById("ExpStr") //扩展串
    if(obj){ExpStr=obj.value;}
	//Port
	if (THisType=="住院"){
		if (TBillNO==""){
			alert("此住院结算记录，未记录帐单号,无法退费")
			return 
		}
		var Flag=InsuIPDivideCancle("0",session['LOGON.USERID'],TBillNO,"",TAdmReason,ExpStr)
		if (Flag!=0){
			alert("医保退费失败")}
		else{alert("医保退费成功")}
	}
	else{
		//alert(ExpStr)			//Handle,UserId,DivRowid,AdmSource,AdmReasonId,ExpString,CPPFlag
		var Flag=InsuOPDivideStrike("0",session['LOGON.USERID'],TDivDr,"",TAdmReason,ExpStr,"")	//参数如有变化，后补
		if (Flag!=0){
			alert("医保退费失败")}
		else{alert("医保退费成功")}
	}
}
function RegCancel_click(){
	var obj=document.getElementById("AdmInfo")
	if(obj.value==""){
		alert("请选择登记信息！");
		return;
	}
	var AdmInfoDr=obj.value.split("^")[0]
	var AdmReasonId=obj.value.split("^")[1]
	if(AdmInfoDr.indexOf("owid")>0){alert("请选择登记信息！");return;}
	var Flag=InsuOPRegStrike("0",session['LOGON.USERID'],AdmInfoDr,"",AdmReasonId,"")	
	if(Flag==-1){alert("医保退号失败");return}
	alert("医保退号成功")
	
	}

//只撤销医保结算 DingSH 2015-12-17

function DiviStrikeForInsu_onclick(){

    var djlsh0="",ExpStr="";
	if (TDHCJFFlag=="N"||TDHCJFFlag=="P"){
		alert("此记录在His中已正常结算，请在His端发起退费")
		return	
	}
	var obj=document.getElementById("TradeNO")
    if(obj.value==""){alert("请录入结算流水号");return} else{djlsh0=obj.value;}
    var insutype="";
    insutype=document.getElementById("InsuDllType").value;
    //注意 每个项目取消时入参各不同，请在ExpStr进行拼串
    var obj=document.getElementById("ExpStr") //扩展串
    if(obj){ExpStr=obj.value;}
    if(""==insutype){alert("请选择医保类型");return;}
    TAdmReason=tkMakeServerCall("web.INSUDicDataCom","GetDicBybillAndInd","AdmReasonDrToDLLType",insutype,3);
    var CPPFlag=""
   var Flag=InsuOPDivideCancleForInsu("0",session['LOGON.USERID'],djlsh0,"",TAdmReason,ExpStr,CPPFlag) //-门诊暂无次函数，DHCINSUPort.js
	if (Flag!=0){
			    alert("医保中心退费失败")}
		else{alert("医保中心退费成功")}
   
	
}

//只撤销HIS结算 DingSH 2015-12-17
function DiviStrikeForHis_onclick(){
	
	if(""==insutype){alert("请选择医保类型");return;}
    TAdmReason=tkMakeServerCall("web.INSUDicDataCom","GetDicBybillAndInd","AdmReasonDrToDLLType",insutype,3);
    
	if (TDivDr==""){
		alert("未选中任何记录")
		return		
	}

   var InvNo ="" ;
	if (TDHCJFFlag=="N"||TDHCJFFlag=="P"){
		alert("此记录在His中已正常结算，请在His端发起退费")
		return	
	}
	
	//var obj=document.getElementById("PrtInv")
	//if(obj.value==""){alert("请录入发票号Inv");return} else{InvNo=obj.value;}
	
    //注意 每个项目取消时入参各不同，请在ExpStr进行拼串
    var obj=document.getElementById("ExpStr") //扩展串
    if(obj){ExpStr=obj.value;}
   var CPPFlag=""
   var Flag=InsuOPDivideCancleForHis("0",session['LOGON.USERID'],TDivDr,"",TAdmReason,ExpStr,CPPFlag) //-门诊暂无次函数，DHCINSUPort.js
	if (Flag!=0){
			    alert("医保本地退费失败")}
		else{alert("医保本地退费成功")}
   

}

document.body.onload = BodyLoadHandler;