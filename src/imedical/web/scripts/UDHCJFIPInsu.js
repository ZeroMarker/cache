///UDHCJFIPInsu.js
var AdmReasonID,ReaNationCode,PaidFlag

//����ҽ�����˲�������;���� UDHCJFCASHIER.js
function DoNotInitPay()
{
   var InitPayflag=true
   if ((instype==t['HXEYPatType01'])||(instype==t['HXEYPatType02'])||(instype==t['HXEYPatType03'])||(instype==t['HXEYPatType04']))
   {   alert(t['HXEY01']);
	   return false;   }
   if ((instype==t['HXEYPatType05'])||(instype==t['HXEYPatType06'])||(instype==t['HXEYPatType07'])||(instype==t['HXEYPatType08'])||(instype==t['HXEYPatType09']))
   {   alert(t['HXEY01']);
	   return false;	}
   ///modify 2011-02-23 ���� pac_admreason.REA_NationalCode ���¼ƷѴ���ά����������ж�ҽ�������Ƿ�������;����
   GetAdmReaNationCode()
   if ((ReaNationCode!="0")&&(InsuPayFlag!="Y")){
      return false;
   }
   return InitPayflag    
}

/*
function PayBack()
{  //����dll
	if (instype==t['INSUType01']){
    var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLNBBFacade");  ///BasPatientBill
	}
	if (instype==t['INSUType02']){
    var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLNBAFacade");  ///BasPatientBill
	}
  	//֧����ʽ����
  	flag=DHCINSUBLL.PayBack(BillNo,"",Guser);
  	DHCINSUBLL=null;   //2006-10-13
	if (flag=="Cancle") 
	{flag=-1; return false ;}
	PayModeList=flag.split("|");
	if (eval(PayModeList[0])==0){flag=0	}
	else{flag=-1}
} 
*/
//����ͨ��ũ����ȡ������Ϣ UDHCJFCASHIER.js
function ybcardnoEnter(e) 
{
   var key = websys_getKey(e);
   var obj = websys_getSrcElement(e);
   var papstr=""
   if ((obj)&&(obj.value!="")&&(key==13)) {
      var cardnoobj=document.getElementById("ybcardno");
      var cardno=cardnoobj.value;		
      var myrtn=DHCACC_GetPAPMINo(cardno);
      var myary=myrtn.split("^");		
      if ((myary[0]=="-201")||( myary[0]=="0")){
         var myPAPMNo=myary[1];
         var obj=document.getElementById("RegistrationNo");
         obj.value=myPAPMNo;
         regnoobj.value=myPAPMNo;
         getpat();			
	   }else{
         cardnoobj.value="";
         alert(t['nbmzdhc01']);
      }
   }
}
//UDHCJFCASHIER.js
function getybcardno(){
	var papstr=""
	var PatientID,patidobj
	patidobj=document.getElementById("PatientID");
	PatientID=patidobj.value;
	var obj=document.getElementById("getcardno");
	if (obj) {var encmeth=obj.value} else {var encmeth=''};
	papstr=cspRunServerMethod(encmeth,'','',PatientID);
	if (papstr!=""){
	   var papstr1=papstr.split("^");
	   if (papstr1[0]!="0"){
		   var obj=document.getElementById("ybcardno");
		   obj.value=papstr1[1];
		   obj.readOnly=true
	   }
	}
}  
//ȡ������ʱ����ҽ����IPRevFootBack������ҽ������ UDHCJFCASHIER.js
function TransIPRevFootBack(Guser,BillNo,Adm)
{   
    GetAdmReaNationCode()
    ReturnValue=0
	if (ReaNationCode>0)
	{   var ReturnValue=InsuIPDivideCancle(0,Guser,BillNo,ReaNationCode,AdmReasonID,"");	
	}
        return ReturnValue	
}
//����ʱҽ��������,UDHCJFPAY.js
function Transybadd(Addobj,balanceobj,Updateobj,Deleteobj,Dischargeobj,Printobj,Abortobj,Guser,BillNo,Adm)
{   
	GetAdmReaNationCode()
	GetBillPaidFlag(BillNo)
    ReturnValue=0;
	if ((ReaNationCode>0)&&(PaidFlag!="P"))
	{   var ReturnValue=InsuIPDivide(0,Guser,BillNo,ReaNationCode,AdmReasonID,"");			
        if (ReturnValue<0){
           alert(t['INSUER02']);
           DHCWeb_DisBtn(Addobj)
           DHCWeb_DisBtn(balanceobj)
           DHCWeb_DisBtn(Updateobj)
           DHCWeb_DisBtn(Deleteobj)
           DHCWeb_DisBtn(Dischargeobj)
           DHCWeb_DisBtn(Printobj)
           DHCWeb_DisBtn(Abortobj)
          
         }
	}   
	return ReturnValue;
}
function GetAdmReaNationCode()
{ 	
	var AdmReaNationCode=tkMakeServerCall("web.UDHCJFPAY","GetBillReaNationCode",BillNo)
	var AdmReaNationCode=AdmReaNationCode.split("^")
	AdmReasonID=AdmReaNationCode[0]
	ReaNationCode=AdmReaNationCode[1]
}
function GetBillPaidFlag(BillNo)
{
	var PaidFlagObj=document.getElementById("GetPaidFlag");
	if (PaidFlagObj) {var encmeth=PaidFlagObj.value} else {var encmeth=''};
	PaidFlag=cspRunServerMethod(encmeth,BillNo);
	
}
//��û���շѽ���ǰ��ȡ��ҽ������
function TransIPInsuCancel()
{   //Guser,BillNo,Adm
    var PaidFlag=tkMakeServerCall("web.UDHCJFBaseCommon","GetBillPaidFlag",BillNo)
    if (PaidFlag=="N")
    {
	    alert("�˵�δ������Ѿ���ӡ��Ʊ,����ȡ��ҽ������")
	    return
    }
    GetAdmReaNationCode()
    ReturnValue=0
	if ((ReaNationCode>0)&(PaidFlag=="Y"))
	{   var ReturnValue=InsuIPDivideCancle(Guser,BillNo,ReaNationCode,AdmReasonID,"");	
	    if (ReturnValue==0)
	    {
		    alert("ȡ��ҽ������ɹ�.")
	    }
	}
	
    return ReturnValue	
}