///DHCBillCheckDaily.js
function BodyLoadHandler() 
{
   var obj=document.getElementById("BtnCheck");
   if (obj) obj.onclick=Check_click;	   
}
function Check_click()
{
   var StDateobj=document.getElementById("StDate");
   var StDate=StDateobj.value;
   var EndDateobj=document.getElementById("EndDate");
   var EndDate=EndDateobj.value; 
   var CheckDescobj=document.getElementById("CheckDesc");
   var CheckDesc=CheckDescobj.value;
   var CheckFunctionobj=document.getElementById("CheckFunction");
   var CheckFunction=CheckFunctionobj.value;
   if ((CheckDesc=="")||(CheckDesc==" ")){
      alert("��ѡ��˲����Ŀ!!");
      CheckFunction="";
      return;
   }
   if ((CheckFunction=="")||(CheckFunction==" ")){
      alert("��ѡ��˲����Ŀ!!");
      CheckFunction="";
      return;   
   } 
   if ((CheckFunction=="GetRebillNum")&&((StDate=="")||(StDate==" "))){
      alert("�˲�Ŀ�ʼ���ڲ���Ϊ��");
      CheckFunction="";
      return;   
   }  
   if ((CheckFunction=="GetRebillNum")&&((EndDate=="")||(EndDate==" "))){
      alert("�˲�Ľ������ڲ���Ϊ��");
      CheckFunction="";
      return;   
   }
   var CheckDateNumobj=document.getElementById('CheckDateNum');	 
   if (CheckDateNumobj) {var encmeth=CheckDateNumobj.value}else {var encmeth=''};
   var DateNumStr=cspRunServerMethod(encmeth,StDate,EndDate);
   if (CheckFunction=="GetRebillNum"){ 
      if ((DateNumStr=="")||(DateNumStr==" ")){
	     alert("��ȡ������Ϣʧ��!!");
	     return;
	  }
	  var DateNumStr1=DateNumStr.split("^"); 
	  var DateNum=DateNumStr1[0];
	  if ((DateNum=="")||(DateNum==" ")){
	     alert("��ȡ������Ϣʧ��!!");
	     return;   
	  }
	  if (isNaN(DateNum)){
	     alert("��ȡ������Ϣʧ��!!");
	     return;   
	  }
	  if (eval(DateNum)>30){
	     alert("�˲����ڲ��ܴ���30��");
	     return; 
	  }
	  if (eval(DateNum)<0){
	     alert("�˲����ڲ���С�ڽ���");
	     return; 
	  }
   }
   if (CheckFunction=="GetCollectPriceDs"){ 
      if ((DateNumStr=="")||(DateNumStr==" ")){
	     alert("��ȡ������Ϣʧ��!!");
	     return;
	  }
	  var DateNumStr1=DateNumStr.split("^"); 
	  var DateNum=DateNumStr1[0];
	  if ((DateNum=="")||(DateNum==" ")){
	     alert("��ȡ������Ϣʧ��!!");
	     return;   
	  }
	  if (isNaN(DateNum)){
	     alert("��ȡ������Ϣʧ��!!");
	     return;   
	  }
	  if (eval(DateNum)>20){
	     alert("�˲����ڲ��ܴ���20��");
	     return; 
	  }
	  if (eval(DateNum)<2){
	     ///alert("Ϊʹ����׼ȷ��˲�2��ǰ������");
	     ///return; 
	  }
   }
   if ((CheckFunction=="CheckLinkData")||(CheckFunction=="CheckPriceData")||(CheckFunction=="GetOEExecNull")||(CheckFunction=="GetItmPriceDs")){
      var RetCode=tkMakeServerCall("web.DHCIPBillCheckDaily",CheckFunction);
      if (RetCode!=""){
         alert("������");
      }        
   }
   if ((CheckFunction=="GetItmPriceDsHosp")){
      var RetCode=tkMakeServerCall("web.DHCIPBillCheckDaily",CheckFunction);
      if (RetCode!=""){
         alert("������");
      } 
   }
   if ((CheckFunction=="GetRebillNum")){
      var RetCode=tkMakeServerCall("web.DHCIPBillCheckDaily",CheckFunction,StDate,EndDate);
      if (RetCode!=""){
         alert("������");
      } 
   }
   var DrugFlag=""
   if (CheckFunction=="GetCollectPriceDs"){
      DrugFlag="Old";
      var RetCode=tkMakeServerCall("web.DHCIPBillCheckDaily",CheckFunction,StDate,EndDate,DrugFlag); 
      if (RetCode!=""){
         alert("������");
      }  
   }
   if (CheckFunction=="GetCollectPriceDsNew"){
      DrugFlag="New";
      CheckFunction1="GetCollectPriceDs"
      var RetCode=tkMakeServerCall("web.DHCIPBillCheckDaily",CheckFunction1,StDate,EndDate,DrugFlag);  
      if (RetCode!=""){
         alert("������");
      } 
   }
      	
}
function LookUpFunction(Value)
{
   var obj=document.getElementById('CheckFunction');
   var tem=Value.split("^");
   obj.value=tem[1];
}
document.body.onload = BodyLoadHandler;