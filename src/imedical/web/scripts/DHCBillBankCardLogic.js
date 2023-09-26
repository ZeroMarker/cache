///DHCBillBankCardLogic.js
///Lid
///2011-03-01
///银医卡处理业务-南宁医科大
///document.write("<object name='fsbankPos' classid='clsid:B6F86E69-059F-4466-9503-5AD35D1ACEF6' style='height:18pt;width:120;display:none' codebase='../addins/client/fsbankPos.CAB#version=1,0,0,1'></object>")
//分隔符
var PUBLIC_SEPARATOR={
	CH1:String.fromCharCode(2),
	CH2:String.fromCharCode(2),
	CH3:String.fromCharCode(3),
	CH4:String.fromCharCode(4)	
}
///收费调用
function BankCardPay(BankCardNO,ReloadFlag,YBConFlag,AdmSource,BankTradeType,PrtRowIDStr){
	var PrtInvAry=PrtRowIDStr.split("^");	
	var PrtRowIDAry=new Array();	//用于存放交易成功的发票Rowid
	for(var i=0;i<PrtInvAry.length;i++){
		var PrtRowID=PrtInvAry[i];
		var bool=false;
		do{
			var rtnValue=POSBankCardPay(BankCardNO,BankTradeType,PrtRowID);
			if(rtnValue=="0"){
				bool=true;
				PrtRowIDAry.push(PrtRowID);
			}else{
				bool=false;
				var truthBeTold = window.confirm(rtnValue+':银医卡交易失败,是否补交易?');
				if(!truthBeTold){
					break;	
				}
			}
		}while(!bool)	
	}
	var FailePrtRowIDAry=findAry(PrtInvAry,PrtRowIDAry);	//交易失败的发票Rowid
	var FaileFlag=false;
	for(var i=0;i<FailePrtRowIDAry.length;i++){
		var FailePrtRowID=FailePrtRowIDAry[i];
		if((YBConFlag=="1")&&(AdmSource>0)){
			//医保病人,收费处结算失败后按现金结算
			alert("银医卡结算失败后,按现金结算,请注意收取现金.");
			var myrtn=UpdateCARDToCASH(FailePrtRowID);
		}else{
			//1.科室,自助机卡消费失败后,删除HIS结算数据.
			//2.自费病人，删除HIS结算数据
			var myrtn=DHCWebOPYB_DeleteHISData(FailePrtRowID,"^"+session['LOGON.GROUPID']+"^");	
			FaileFlag=true;
		}
	}
	if(FaileFlag){
		return false;
	}
	return true;
}
///按现金结算
function UpdateCARDToCASH(PrtRowID){
	var myrtn=tkMakeServerCall("web.DHCBillBankLogic","UpdateCARDToCASH",PrtRowID);	
	return myrtn;
}
///集中打印发票表，按现金结算
function UpdateCARDToCASHAPI(APIRowID){
	var myrtn=tkMakeServerCall("web.DHCBillBankLogic","UpdateCARDToCASHAPI",APIRowID);	
	return myrtn;
}

///获取银行交易类型
function GetBankTradeType(PrtRowID){
	var BankTradeType=tkMakeServerCall("web.DHCBillBankLogic","CheckRefundTradeType",PrtRowID);
	return BankTradeType;
}
///POS消费
function POSBankCardPay(BankCardNO,BankTradeType,PrtRowID){
	var Guser=session['LOGON.USERID'];
    var ExpStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^^^";
	var PrtRowID=PrtRowID;
	var rtn=tkMakeServerCall("web.DHCBillBankLogic","CheckPayMByPrtRowID",PrtRowID,"");
	var CardPayFlag=rtn.split("^")[0];
	var PayModeDR=rtn.split("^")[1];
	if(CardPayFlag=="0")return 0;	//非银医卡支付,退出，CardPayFlag>0是银医卡支付
	///获取银医卡交易入参信息
	var rtn=tkMakeServerCall("web.DHCBillBankLogic","POSPayInput","OP", Guser, PrtRowID,"", BankCardNO,BankTradeType, ExpStr);
	var err=rtn.split(PUBLIC_SEPARATOR.CH2)[0];
	var HISTradeID=rtn.split(PUBLIC_SEPARATOR.CH2)[1];
	var BankInput=rtn.split(PUBLIC_SEPARATOR.CH2)[2];
	if(err!="0"){
		return -1001;	
	}
	///调用银医卡接口
	var BankData=CallDLLFun(CardPayFlag,BankInput);
	if(BankData==-1003){
		return -1003;	
	}
	///保存银医卡交易信息
	var rtn=tkMakeServerCall("web.DHCBillBankLogic","POSDataSave","OP", Guser, PrtRowID, "", BankCardNO, BankTradeType,HISTradeID,BankData, ExpStr);
	var rtnAry=rtn.split(PUBLIC_SEPARATOR.CH2);
	var err=rtnAry[0];
	var Rc=rtnAry[2];
	var RcDetail=rtnAry[3];
	if((err=="0")&&(Rc=="00")){
		alert(RcDetail);
		//return -1003;
		return 0	
	}
	if((err!="0")&&(Rc=="00")){
		alert("POS机交易成功,HIS更新交易记录失败.(请联系信息中心处理数据)");  //银行已成功,HIS也按成功处理,然后后台手工处理数据.
		return 0;	
	}
	if((err=="0")&&(Rc!="00")){
		alert("POS机交易失败:"+RcDetail);  //HIS更新记录成功,银行交易失败,按现金结算.
		return -1002;	
	}
	if((err!="0")&&(Rc!="00")){
		alert("POS机交易失败:"+RcDetail+",同时HIS更新交易记录失败.");  //HIS更新记录失败,银行交易失败,按现金结算.
		return -1004;	
	}
    return 0;
}
function BankCardRefund(InitPrtRowID,AbortPrtRowID,NewPrtRowID){
	var BankCardNO="";
	var Guser=session['LOGON.USERID'];
    var ExpStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^^^";
	///判断交易类型(S2:当日退费，S3:隔日退货)
	var BankTradeType=GetBankTradeType(InitPrtRowID);
	///判断退费模式
	var RefundMode=tkMakeServerCall("web.DHCBillBankLogic","CheckRefundMode",AbortPrtRowID,NewPrtRowID)
	var rtn=0
	if(RefundMode=="0"){
		//0:作废
		if(BankTradeType=="S2"){
			rtn=POSRefund(BankCardNO,InitPrtRowID,AbortPrtRowID,NewPrtRowID,BankTradeType,ExpStr);
			if(rtn!="0"){
				alert("POS机退费失败,请注意退现金.");
				rtn=UpdateCARDToCASH(AbortPrtRowID);
			}
		}
		if(BankTradeType=="S3"){
			alert("非当日退费,请注意退现金.");
			rtn=UpdateCARDToCASH(AbortPrtRowID);
		}
	}else if(RefundMode=="1"){
		//1:部分退费
		if(BankTradeType=="S2"){
			///先全退，再收费
			rtn1=POSRefund(BankCardNO,InitPrtRowID,AbortPrtRowID,NewPrtRowID,BankTradeType,ExpStr);
			if(rtn1!="0"){
				alert("POS机退费失败,请注意退现金.");
				rtn=UpdateCARDToCASH(AbortPrtRowID);
				rtn=UpdateCARDToCASH(NewPrtRowID);
			}
			rtn2=POSBankCardPay(BankCardNO,"S1",NewPrtRowID);
			if(rtn2!="0"){
				var CASHAmt=tkMakeServerCall("web.DHCBillBankLogic","GetOPInvBankCardAmt",NewPrtRowID);
				alert("POS机收费失败,请收取现金 "+CASHAmt+" 元.");
				rtn=UpdateCARDToCASH(NewPrtRowID);
			}
			
			
		}
		if(BankTradeType=="S3"){
			alert("非当日退费,请注意退现金.");
			rtn=UpdateCARDToCASH(AbortPrtRowID);
			rtn=UpdateCARDToCASH(NewPrtRowID);
		}
	}else{
		//2:作废重打
		var rtn=tkMakeServerCall("web.DHCBillBankLogic","BankRefundReplay",NewPrtRowID,AbortPrtRowID,ExpStr);
		if(rtn!="0"){
			alert("作废重打时,更新交易记录失败,请联系信息中心.");	
		}
	}
	return true;
}
///集中打印发票退银医卡
function BankCardAPIRefund(InitAPIRowID,NewAPIRowID){
	//根据集中打印发票RowID，获取对应的支付小条Rowid
	//InitAPIRowID：原发票RowID,NewAPIRowID：新发票RowID
	var PrtRowIDStr=tkMakeServerCall("web.udhcOPRefEdit1","GetPrtRowIDByAPIRowID",InitAPIRowID,NewAPIRowID);
	var tmp=PrtRowIDStr.split("^");
	var InitPrtRowID=tmp[0];
	var AbortPrtRowID=tmp[1];
	var NewPrtRowID=tmp[2];
	var AbortAPIRowID=tmp[3];
	var BankCardNO="";
	var Guser=session['LOGON.USERID'];
    var ExpStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^^^";
	///判断交易类型(S2:当日退费，S3:隔日退货)
	var BankTradeType=GetBankTradeType(InitPrtRowID);
	///判断退费模式
	var RefundMode=tkMakeServerCall("web.DHCBillBankLogic","CheckRefundMode",AbortPrtRowID,NewPrtRowID)
	var rtn=0
	if(RefundMode=="0"){
		//0:作废
		if(BankTradeType=="S2"){
			rtn=POSRefund(BankCardNO,InitPrtRowID,AbortPrtRowID,NewPrtRowID,BankTradeType,ExpStr);
			if(rtn!="0"){
				alert("POS机退费失败,请注意退现金.");
				rtn=UpdateCARDToCASH(AbortPrtRowID);
				//集中打印发票记录支付方式修改.
				rtn=UpdateCARDToCASHAPI(AbortAPIRowID);	
			}
		}
	}else if(RefundMode=="1"){
		//1:部分退费
		if(BankTradeType=="S2"){
			///先全退，再收费
			rtn1=POSRefund(BankCardNO,InitPrtRowID,AbortPrtRowID,NewPrtRowID,BankTradeType,ExpStr);
			if(rtn1!="0"){
				alert("POS机退费失败,请注意退现金.");
				rtn=UpdateCARDToCASH(AbortPrtRowID);
				rtn=UpdateCARDToCASH(NewPrtRowID);
				//集中打印发票记录支付方式修改.
				rtn=UpdateCARDToCASHAPI(AbortAPIRowID);
				rtn=UpdateCARDToCASHAPI(NewAPIRowID);	
			}
			rtn2=POSBankCardPay(BankCardNO,"S1",NewPrtRowID);
			if(rtn2!="0"){
				var CASHAmt=tkMakeServerCall("web.DHCBillBankLogic","GetOPInvBankCardAmt",NewPrtRowID);
				alert("POS机收费失败,请收取现金 "+CASHAmt+" 元.");
				rtn=UpdateCARDToCASH(NewPrtRowID);
				rtn=UpdateCARDToCASHAPI(NewAPIRowID);
			}
		}
	}
	return true;
}
///POS 退费/退货
function POSRefund(BankCardNO,InitPrtRowID,AbortPrtRowID,NewPrtRowID,BankTradeType,ExpStr){
	var Guser=session['LOGON.USERID'];
	var rtn=tkMakeServerCall("web.DHCBillBankLogic","CheckPayMByPrtRowID",InitPrtRowID,"");
	var CardPayFlag=rtn.split("^")[0];
	var PayModeDR=rtn.split("^")[1];
	if(CardPayFlag=="0")return 0;	//非银医卡支付,退出，CardPayFlag>0是银医卡支付,同时判断了如果是银医卡支付但是金额为0时，也不调用银行接口
	///获取银医卡交易入参信息
	var rtn=tkMakeServerCall("web.DHCBillBankLogic","POSPayInput","OP", Guser, "",AbortPrtRowID,BankCardNO,BankTradeType, ExpStr);
	var err=rtn.split(PUBLIC_SEPARATOR.CH2)[0];
	var HISTradeID=rtn.split(PUBLIC_SEPARATOR.CH2)[1];
	var BankInput=rtn.split(PUBLIC_SEPARATOR.CH2)[2];
	if(err!="0"){
		return -1001;	
	}
	///调用银医卡接口
	var BankData=CallDLLFun(CardPayFlag,BankInput);
	if(BankData==-1003){
		return -1003	
	}
	///保存银医卡交易信息
	var rtn=tkMakeServerCall("web.DHCBillBankLogic","POSDataSave","OP", Guser, "", AbortPrtRowID, BankCardNO, BankTradeType,HISTradeID,BankData, ExpStr);
	var rtnAry=rtn.split(PUBLIC_SEPARATOR.CH2);
	var err=rtnAry[0];
	var Rc=rtnAry[2];
	var RcDetail=rtnAry[3];
	if((err=="0")&&(Rc=="00")){
		alert(RcDetail);
		return 0	
	}
	if((err!="0")&&(Rc=="00")){
		alert("POS机交易成功,HIS更新交易记录失败.(请联系信息中心处理数据)");  //银行已成功,HIS也按成功处理,然后后台手工处理数据.
		return 0;	
	}
	if((err=="0")&&(Rc!="00")){
		alert("POS机交易失败:"+RcDetail);  //HIS更新记录成功,银行交易失败,按现金结算.
		return -1002;	
	}
	if((err!="0")&&(Rc!="00")){
		alert("POS机交易失败:"+RcDetail+",同时HIS更新交易记录失败.");  //HIS更新记录失败,银行交易失败,按现金结算.
		return -1004;	
	}
}
///Lid
///2011-11-18
///调用POS DLL
function CallDLLFun(CardPayFlag,BankInput){
	var BankData=-1003
	try {
	
		switch(CardPayFlag){
			case "1":
				//alert(BankInput);
				BankData=fsbankPos.unitPos(BankInput); ///"00|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22"
				//BankData=BankData+"|S2|4|5|6|1000000001|20151111|9|10|11|12|13|20111120|20111119|235959|17|0000000002222|CCB|20|建行|22"
				Log(BankInput,BankData);
				//alert(1+":"+BankData);
				break;
			default:	
		}	
		return BankData;
	}catch(e){
		return BankData;	
	}
	
}
///Lid
///2011-11-18
///POS 其他业务(签到，查余额，结算)
function POSOtherOperation(BankTradeType,PayModeDR){
	var Guser=session['LOGON.USERID'];
    var ExpStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^^^";
	var BankInput=tkMakeServerCall("web.DHCBillBankLogic","POSPayInput","", Guser, "","", "",BankTradeType, ExpStr);
	var CardPayFlag="1";	//此处写死
	var BankData=CallDLLFun(CardPayFlag,BankInput)
	var rtn=BankData.split("|");
	return rtn
}
///Lid
///查询两个数组中不同的元素，并放到新数组中，返回新的数组
function findAry(a,b){
	var c=new Array();
    a.sort();   
    b.sort();   
    var i=0;   
    var j=0;   
    while(i<a.length&&j<b.length){   
        if(a[i]<b[j]){   
            c.push(a[i]);   
            i++;   
        }else if(b[j]<a[i]){   
            c.push(b[j]);   
            j++;   
        }else {   
            i++;   
            j++;   
        }   
    }   
    while(i<a.length){   
        c.push(a[i]);   
        i++;   
    }   
    while(j<b.length){   
        c.push(b[j]);   
        j++;   
    }   
   // alert(c.join("^"));
   return c
}  
//读银医卡卡号
//Rtn:-1^Info  银医卡不能使用
//     1^Info  不需要使用银医卡
//     0^Info  可以使用的银医卡  Info为卡号
//
function ReadBankCardInfo(PayModeCode,Patient,CardElementName,CardObj){
	var YYKPayMode="CARDCPP";  //银医卡对应的支付方式代码
	if (PayModeCode!=YYKPayMode) return "1^支付方式不需要使用银医卡"
	var CardTypeInfo="",myCardTypeDR="",myAccID="";
	if (arguments.length>2){ //需要卡类型
		if (arguments.length==4){ //
			var CardTypeInfo=CardObj.getSelectedValue();
			if (CardTypeInfo!=""){
				var CardTypeArr=CardTypeInfo.split("^")
				myCardTypeDR=CardTypeArr[0];
			}
		}
		else if (arguments.length==3){ //普通combox
			var obj=document.getElementById(CardElementName);
			if (obj) CardTypeInfo=obj.options[obj.selectedIndex].value;
		}
		var myary=CardTypeInfo.split("^");
		var myCardTypeDR=myary[0];
		var myrtn=DHCACC_GetAccInfo(myCardTypeDR,CardTypeInfo);
	}else{ //不需要卡类型
		
	}
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效
			var PatientID=myary[4];
			if (PatientID!=Patient) return "-1^卡对应ID和需要结算的ID不同"
			var PatientNo=myary[5];
			var CardNo=myary[1]
			var myCardTypeDR=myary[8];
			var myAccID=myary[7];
			break;
		case "-200": //卡无效
			return "-1^卡无效";
			break;
		case "-201": //没有账户
			return "-1^卡没有对应的医院账户信息"
			//alert(t['21']);
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			if (PatientID!=Patient) return "-1^卡对应ID和需要结算的ID不同"
			var myCardTypeDR=myary[8];
			break;
		default:
			return "-1^没有取到银医卡信息"
	}
	//判断卡类型是否是银医卡卡类型
	var rtn=tkMakeServerCall("CardInterface.CardManager","IsBankCard",myCardTypeDR);
	if (rtn!=1) return "-1^对应卡类型不是银医卡"
	return "0^"+CardNo+"^"+myAccID;
}
///Lid
///2011-11-20
///JS生成客户端日志文件,记录POS机接口的入参，出参信息/
function Log(input,output){ 
	var GuserCode=session['LOGON.USERCODE'];
	var GuserName=session['LOGON.USERNAME'];
  	var date = new Date(); //日期对象
	var now = "";
	now = date.getFullYear()+"-"; //读英文就行了
	now = now + (date.getMonth()+1)+"-";//取月的时候取的是当前月-1如果想取当前月+1就可以了
	now = now + date.getDate()+" ";
	now = now + date.getHours()+":";
	now = now + date.getMinutes()+":";
	now = now + date.getSeconds()+"";
	var FileNameDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()
	var fso=new	ActiveXObject("Scripting.FileSystemObject");
	var LogFolder="C:\\POSTradeDataLogFolder";
	if(!fso.FolderExists(LogFolder)){
		fso.CreateFolder(LogFolder);     	
	}
    ts=fso.OpenTextFile(LogFolder+"\\"+FileNameDate+"POSLog.txt",8,true);
    ts.WriteLine("-------------------------------------------------------------------"); 
	ts.WriteLine("日期: "+now);
	ts.WriteLine("操作员: "+GuserName+"("+GuserCode+")"); 
	ts.WriteLine("入参:")
	ts.WriteLine(input);
	ts.WriteLine("出参:")
	ts.WriteLine(output);
    ts.WriteLine("-------------------------------------------------------------------");
	ts.Close();
}
