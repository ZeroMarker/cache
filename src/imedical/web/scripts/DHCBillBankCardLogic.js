///DHCBillBankCardLogic.js
///Lid
///2011-03-01
///��ҽ������ҵ��-����ҽ�ƴ�
///document.write("<object name='fsbankPos' classid='clsid:B6F86E69-059F-4466-9503-5AD35D1ACEF6' style='height:18pt;width:120;display:none' codebase='../addins/client/fsbankPos.CAB#version=1,0,0,1'></object>")
//�ָ���
var PUBLIC_SEPARATOR={
	CH1:String.fromCharCode(2),
	CH2:String.fromCharCode(2),
	CH3:String.fromCharCode(3),
	CH4:String.fromCharCode(4)	
}
///�շѵ���
function BankCardPay(BankCardNO,ReloadFlag,YBConFlag,AdmSource,BankTradeType,PrtRowIDStr){
	var PrtInvAry=PrtRowIDStr.split("^");	
	var PrtRowIDAry=new Array();	//���ڴ�Ž��׳ɹ��ķ�ƱRowid
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
				var truthBeTold = window.confirm(rtnValue+':��ҽ������ʧ��,�Ƿ񲹽���?');
				if(!truthBeTold){
					break;	
				}
			}
		}while(!bool)	
	}
	var FailePrtRowIDAry=findAry(PrtInvAry,PrtRowIDAry);	//����ʧ�ܵķ�ƱRowid
	var FaileFlag=false;
	for(var i=0;i<FailePrtRowIDAry.length;i++){
		var FailePrtRowID=FailePrtRowIDAry[i];
		if((YBConFlag=="1")&&(AdmSource>0)){
			//ҽ������,�շѴ�����ʧ�ܺ��ֽ����
			alert("��ҽ������ʧ�ܺ�,���ֽ����,��ע����ȡ�ֽ�.");
			var myrtn=UpdateCARDToCASH(FailePrtRowID);
		}else{
			//1.����,������������ʧ�ܺ�,ɾ��HIS��������.
			//2.�ԷѲ��ˣ�ɾ��HIS��������
			var myrtn=DHCWebOPYB_DeleteHISData(FailePrtRowID,"^"+session['LOGON.GROUPID']+"^");	
			FaileFlag=true;
		}
	}
	if(FaileFlag){
		return false;
	}
	return true;
}
///���ֽ����
function UpdateCARDToCASH(PrtRowID){
	var myrtn=tkMakeServerCall("web.DHCBillBankLogic","UpdateCARDToCASH",PrtRowID);	
	return myrtn;
}
///���д�ӡ��Ʊ�����ֽ����
function UpdateCARDToCASHAPI(APIRowID){
	var myrtn=tkMakeServerCall("web.DHCBillBankLogic","UpdateCARDToCASHAPI",APIRowID);	
	return myrtn;
}

///��ȡ���н�������
function GetBankTradeType(PrtRowID){
	var BankTradeType=tkMakeServerCall("web.DHCBillBankLogic","CheckRefundTradeType",PrtRowID);
	return BankTradeType;
}
///POS����
function POSBankCardPay(BankCardNO,BankTradeType,PrtRowID){
	var Guser=session['LOGON.USERID'];
    var ExpStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^^^";
	var PrtRowID=PrtRowID;
	var rtn=tkMakeServerCall("web.DHCBillBankLogic","CheckPayMByPrtRowID",PrtRowID,"");
	var CardPayFlag=rtn.split("^")[0];
	var PayModeDR=rtn.split("^")[1];
	if(CardPayFlag=="0")return 0;	//����ҽ��֧��,�˳���CardPayFlag>0����ҽ��֧��
	///��ȡ��ҽ�����������Ϣ
	var rtn=tkMakeServerCall("web.DHCBillBankLogic","POSPayInput","OP", Guser, PrtRowID,"", BankCardNO,BankTradeType, ExpStr);
	var err=rtn.split(PUBLIC_SEPARATOR.CH2)[0];
	var HISTradeID=rtn.split(PUBLIC_SEPARATOR.CH2)[1];
	var BankInput=rtn.split(PUBLIC_SEPARATOR.CH2)[2];
	if(err!="0"){
		return -1001;	
	}
	///������ҽ���ӿ�
	var BankData=CallDLLFun(CardPayFlag,BankInput);
	if(BankData==-1003){
		return -1003;	
	}
	///������ҽ��������Ϣ
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
		alert("POS�����׳ɹ�,HIS���½��׼�¼ʧ��.(����ϵ��Ϣ���Ĵ�������)");  //�����ѳɹ�,HISҲ���ɹ�����,Ȼ���̨�ֹ���������.
		return 0;	
	}
	if((err=="0")&&(Rc!="00")){
		alert("POS������ʧ��:"+RcDetail);  //HIS���¼�¼�ɹ�,���н���ʧ��,���ֽ����.
		return -1002;	
	}
	if((err!="0")&&(Rc!="00")){
		alert("POS������ʧ��:"+RcDetail+",ͬʱHIS���½��׼�¼ʧ��.");  //HIS���¼�¼ʧ��,���н���ʧ��,���ֽ����.
		return -1004;	
	}
    return 0;
}
function BankCardRefund(InitPrtRowID,AbortPrtRowID,NewPrtRowID){
	var BankCardNO="";
	var Guser=session['LOGON.USERID'];
    var ExpStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^^^";
	///�жϽ�������(S2:�����˷ѣ�S3:�����˻�)
	var BankTradeType=GetBankTradeType(InitPrtRowID);
	///�ж��˷�ģʽ
	var RefundMode=tkMakeServerCall("web.DHCBillBankLogic","CheckRefundMode",AbortPrtRowID,NewPrtRowID)
	var rtn=0
	if(RefundMode=="0"){
		//0:����
		if(BankTradeType=="S2"){
			rtn=POSRefund(BankCardNO,InitPrtRowID,AbortPrtRowID,NewPrtRowID,BankTradeType,ExpStr);
			if(rtn!="0"){
				alert("POS���˷�ʧ��,��ע�����ֽ�.");
				rtn=UpdateCARDToCASH(AbortPrtRowID);
			}
		}
		if(BankTradeType=="S3"){
			alert("�ǵ����˷�,��ע�����ֽ�.");
			rtn=UpdateCARDToCASH(AbortPrtRowID);
		}
	}else if(RefundMode=="1"){
		//1:�����˷�
		if(BankTradeType=="S2"){
			///��ȫ�ˣ����շ�
			rtn1=POSRefund(BankCardNO,InitPrtRowID,AbortPrtRowID,NewPrtRowID,BankTradeType,ExpStr);
			if(rtn1!="0"){
				alert("POS���˷�ʧ��,��ע�����ֽ�.");
				rtn=UpdateCARDToCASH(AbortPrtRowID);
				rtn=UpdateCARDToCASH(NewPrtRowID);
			}
			rtn2=POSBankCardPay(BankCardNO,"S1",NewPrtRowID);
			if(rtn2!="0"){
				var CASHAmt=tkMakeServerCall("web.DHCBillBankLogic","GetOPInvBankCardAmt",NewPrtRowID);
				alert("POS���շ�ʧ��,����ȡ�ֽ� "+CASHAmt+" Ԫ.");
				rtn=UpdateCARDToCASH(NewPrtRowID);
			}
			
			
		}
		if(BankTradeType=="S3"){
			alert("�ǵ����˷�,��ע�����ֽ�.");
			rtn=UpdateCARDToCASH(AbortPrtRowID);
			rtn=UpdateCARDToCASH(NewPrtRowID);
		}
	}else{
		//2:�����ش�
		var rtn=tkMakeServerCall("web.DHCBillBankLogic","BankRefundReplay",NewPrtRowID,AbortPrtRowID,ExpStr);
		if(rtn!="0"){
			alert("�����ش�ʱ,���½��׼�¼ʧ��,����ϵ��Ϣ����.");	
		}
	}
	return true;
}
///���д�ӡ��Ʊ����ҽ��
function BankCardAPIRefund(InitAPIRowID,NewAPIRowID){
	//���ݼ��д�ӡ��ƱRowID����ȡ��Ӧ��֧��С��Rowid
	//InitAPIRowID��ԭ��ƱRowID,NewAPIRowID���·�ƱRowID
	var PrtRowIDStr=tkMakeServerCall("web.udhcOPRefEdit1","GetPrtRowIDByAPIRowID",InitAPIRowID,NewAPIRowID);
	var tmp=PrtRowIDStr.split("^");
	var InitPrtRowID=tmp[0];
	var AbortPrtRowID=tmp[1];
	var NewPrtRowID=tmp[2];
	var AbortAPIRowID=tmp[3];
	var BankCardNO="";
	var Guser=session['LOGON.USERID'];
    var ExpStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^^^";
	///�жϽ�������(S2:�����˷ѣ�S3:�����˻�)
	var BankTradeType=GetBankTradeType(InitPrtRowID);
	///�ж��˷�ģʽ
	var RefundMode=tkMakeServerCall("web.DHCBillBankLogic","CheckRefundMode",AbortPrtRowID,NewPrtRowID)
	var rtn=0
	if(RefundMode=="0"){
		//0:����
		if(BankTradeType=="S2"){
			rtn=POSRefund(BankCardNO,InitPrtRowID,AbortPrtRowID,NewPrtRowID,BankTradeType,ExpStr);
			if(rtn!="0"){
				alert("POS���˷�ʧ��,��ע�����ֽ�.");
				rtn=UpdateCARDToCASH(AbortPrtRowID);
				//���д�ӡ��Ʊ��¼֧����ʽ�޸�.
				rtn=UpdateCARDToCASHAPI(AbortAPIRowID);	
			}
		}
	}else if(RefundMode=="1"){
		//1:�����˷�
		if(BankTradeType=="S2"){
			///��ȫ�ˣ����շ�
			rtn1=POSRefund(BankCardNO,InitPrtRowID,AbortPrtRowID,NewPrtRowID,BankTradeType,ExpStr);
			if(rtn1!="0"){
				alert("POS���˷�ʧ��,��ע�����ֽ�.");
				rtn=UpdateCARDToCASH(AbortPrtRowID);
				rtn=UpdateCARDToCASH(NewPrtRowID);
				//���д�ӡ��Ʊ��¼֧����ʽ�޸�.
				rtn=UpdateCARDToCASHAPI(AbortAPIRowID);
				rtn=UpdateCARDToCASHAPI(NewAPIRowID);	
			}
			rtn2=POSBankCardPay(BankCardNO,"S1",NewPrtRowID);
			if(rtn2!="0"){
				var CASHAmt=tkMakeServerCall("web.DHCBillBankLogic","GetOPInvBankCardAmt",NewPrtRowID);
				alert("POS���շ�ʧ��,����ȡ�ֽ� "+CASHAmt+" Ԫ.");
				rtn=UpdateCARDToCASH(NewPrtRowID);
				rtn=UpdateCARDToCASHAPI(NewAPIRowID);
			}
		}
	}
	return true;
}
///POS �˷�/�˻�
function POSRefund(BankCardNO,InitPrtRowID,AbortPrtRowID,NewPrtRowID,BankTradeType,ExpStr){
	var Guser=session['LOGON.USERID'];
	var rtn=tkMakeServerCall("web.DHCBillBankLogic","CheckPayMByPrtRowID",InitPrtRowID,"");
	var CardPayFlag=rtn.split("^")[0];
	var PayModeDR=rtn.split("^")[1];
	if(CardPayFlag=="0")return 0;	//����ҽ��֧��,�˳���CardPayFlag>0����ҽ��֧��,ͬʱ�ж����������ҽ��֧�����ǽ��Ϊ0ʱ��Ҳ���������нӿ�
	///��ȡ��ҽ�����������Ϣ
	var rtn=tkMakeServerCall("web.DHCBillBankLogic","POSPayInput","OP", Guser, "",AbortPrtRowID,BankCardNO,BankTradeType, ExpStr);
	var err=rtn.split(PUBLIC_SEPARATOR.CH2)[0];
	var HISTradeID=rtn.split(PUBLIC_SEPARATOR.CH2)[1];
	var BankInput=rtn.split(PUBLIC_SEPARATOR.CH2)[2];
	if(err!="0"){
		return -1001;	
	}
	///������ҽ���ӿ�
	var BankData=CallDLLFun(CardPayFlag,BankInput);
	if(BankData==-1003){
		return -1003	
	}
	///������ҽ��������Ϣ
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
		alert("POS�����׳ɹ�,HIS���½��׼�¼ʧ��.(����ϵ��Ϣ���Ĵ�������)");  //�����ѳɹ�,HISҲ���ɹ�����,Ȼ���̨�ֹ���������.
		return 0;	
	}
	if((err=="0")&&(Rc!="00")){
		alert("POS������ʧ��:"+RcDetail);  //HIS���¼�¼�ɹ�,���н���ʧ��,���ֽ����.
		return -1002;	
	}
	if((err!="0")&&(Rc!="00")){
		alert("POS������ʧ��:"+RcDetail+",ͬʱHIS���½��׼�¼ʧ��.");  //HIS���¼�¼ʧ��,���н���ʧ��,���ֽ����.
		return -1004;	
	}
}
///Lid
///2011-11-18
///����POS DLL
function CallDLLFun(CardPayFlag,BankInput){
	var BankData=-1003
	try {
	
		switch(CardPayFlag){
			case "1":
				//alert(BankInput);
				BankData=fsbankPos.unitPos(BankInput); ///"00|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22"
				//BankData=BankData+"|S2|4|5|6|1000000001|20151111|9|10|11|12|13|20111120|20111119|235959|17|0000000002222|CCB|20|����|22"
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
///POS ����ҵ��(ǩ������������)
function POSOtherOperation(BankTradeType,PayModeDR){
	var Guser=session['LOGON.USERID'];
    var ExpStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^^^";
	var BankInput=tkMakeServerCall("web.DHCBillBankLogic","POSPayInput","", Guser, "","", "",BankTradeType, ExpStr);
	var CardPayFlag="1";	//�˴�д��
	var BankData=CallDLLFun(CardPayFlag,BankInput)
	var rtn=BankData.split("|");
	return rtn
}
///Lid
///��ѯ���������в�ͬ��Ԫ�أ����ŵ��������У������µ�����
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
//����ҽ������
//Rtn:-1^Info  ��ҽ������ʹ��
//     1^Info  ����Ҫʹ����ҽ��
//     0^Info  ����ʹ�õ���ҽ��  InfoΪ����
//
function ReadBankCardInfo(PayModeCode,Patient,CardElementName,CardObj){
	var YYKPayMode="CARDCPP";  //��ҽ����Ӧ��֧����ʽ����
	if (PayModeCode!=YYKPayMode) return "1^֧����ʽ����Ҫʹ����ҽ��"
	var CardTypeInfo="",myCardTypeDR="",myAccID="";
	if (arguments.length>2){ //��Ҫ������
		if (arguments.length==4){ //
			var CardTypeInfo=CardObj.getSelectedValue();
			if (CardTypeInfo!=""){
				var CardTypeArr=CardTypeInfo.split("^")
				myCardTypeDR=CardTypeArr[0];
			}
		}
		else if (arguments.length==3){ //��ͨcombox
			var obj=document.getElementById(CardElementName);
			if (obj) CardTypeInfo=obj.options[obj.selectedIndex].value;
		}
		var myary=CardTypeInfo.split("^");
		var myCardTypeDR=myary[0];
		var myrtn=DHCACC_GetAccInfo(myCardTypeDR,CardTypeInfo);
	}else{ //����Ҫ������
		
	}
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": //����Ч
			var PatientID=myary[4];
			if (PatientID!=Patient) return "-1^����ӦID����Ҫ�����ID��ͬ"
			var PatientNo=myary[5];
			var CardNo=myary[1]
			var myCardTypeDR=myary[8];
			var myAccID=myary[7];
			break;
		case "-200": //����Ч
			return "-1^����Ч";
			break;
		case "-201": //û���˻�
			return "-1^��û�ж�Ӧ��ҽԺ�˻���Ϣ"
			//alert(t['21']);
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			if (PatientID!=Patient) return "-1^����ӦID����Ҫ�����ID��ͬ"
			var myCardTypeDR=myary[8];
			break;
		default:
			return "-1^û��ȡ����ҽ����Ϣ"
	}
	//�жϿ������Ƿ�����ҽ��������
	var rtn=tkMakeServerCall("CardInterface.CardManager","IsBankCard",myCardTypeDR);
	if (rtn!=1) return "-1^��Ӧ�����Ͳ�����ҽ��"
	return "0^"+CardNo+"^"+myAccID;
}
///Lid
///2011-11-20
///JS���ɿͻ�����־�ļ�,��¼POS���ӿڵ���Σ�������Ϣ/
function Log(input,output){ 
	var GuserCode=session['LOGON.USERCODE'];
	var GuserName=session['LOGON.USERNAME'];
  	var date = new Date(); //���ڶ���
	var now = "";
	now = date.getFullYear()+"-"; //��Ӣ�ľ�����
	now = now + (date.getMonth()+1)+"-";//ȡ�µ�ʱ��ȡ���ǵ�ǰ��-1�����ȡ��ǰ��+1�Ϳ�����
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
	ts.WriteLine("����: "+now);
	ts.WriteLine("����Ա: "+GuserName+"("+GuserCode+")"); 
	ts.WriteLine("���:")
	ts.WriteLine(input);
	ts.WriteLine("����:")
	ts.WriteLine(output);
    ts.WriteLine("-------------------------------------------------------------------");
	ts.Close();
}
