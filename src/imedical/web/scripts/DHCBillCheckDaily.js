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
      alert("请选择核查的项目!!");
      CheckFunction="";
      return;
   }
   if ((CheckFunction=="")||(CheckFunction==" ")){
      alert("请选择核查的项目!!");
      CheckFunction="";
      return;   
   } 
   if ((CheckFunction=="GetRebillNum")&&((StDate=="")||(StDate==" "))){
      alert("核查的开始日期不能为空");
      CheckFunction="";
      return;   
   }  
   if ((CheckFunction=="GetRebillNum")&&((EndDate=="")||(EndDate==" "))){
      alert("核查的结束日期不能为空");
      CheckFunction="";
      return;   
   }
   var CheckDateNumobj=document.getElementById('CheckDateNum');	 
   if (CheckDateNumobj) {var encmeth=CheckDateNumobj.value}else {var encmeth=''};
   var DateNumStr=cspRunServerMethod(encmeth,StDate,EndDate);
   if (CheckFunction=="GetRebillNum"){ 
      if ((DateNumStr=="")||(DateNumStr==" ")){
	     alert("获取日期信息失败!!");
	     return;
	  }
	  var DateNumStr1=DateNumStr.split("^"); 
	  var DateNum=DateNumStr1[0];
	  if ((DateNum=="")||(DateNum==" ")){
	     alert("获取日期信息失败!!");
	     return;   
	  }
	  if (isNaN(DateNum)){
	     alert("获取日期信息失败!!");
	     return;   
	  }
	  if (eval(DateNum)>30){
	     alert("核查日期不能大于30天");
	     return; 
	  }
	  if (eval(DateNum)<0){
	     alert("核查日期不能小于今天");
	     return; 
	  }
   }
   if (CheckFunction=="GetCollectPriceDs"){ 
      if ((DateNumStr=="")||(DateNumStr==" ")){
	     alert("获取日期信息失败!!");
	     return;
	  }
	  var DateNumStr1=DateNumStr.split("^"); 
	  var DateNum=DateNumStr1[0];
	  if ((DateNum=="")||(DateNum==" ")){
	     alert("获取日期信息失败!!");
	     return;   
	  }
	  if (isNaN(DateNum)){
	     alert("获取日期信息失败!!");
	     return;   
	  }
	  if (eval(DateNum)>20){
	     alert("核查日期不能大于20天");
	     return; 
	  }
	  if (eval(DateNum)<2){
	     ///alert("为使数据准确请核查2天前的数据");
	     ///return; 
	  }
   }
   if ((CheckFunction=="CheckLinkData")||(CheckFunction=="CheckPriceData")||(CheckFunction=="GetOEExecNull")||(CheckFunction=="GetItmPriceDs")){
      var RetCode=tkMakeServerCall("web.DHCIPBillCheckDaily",CheckFunction);
      if (RetCode!=""){
         alert("检查完成");
      }        
   }
   if ((CheckFunction=="GetItmPriceDsHosp")){
      var RetCode=tkMakeServerCall("web.DHCIPBillCheckDaily",CheckFunction);
      if (RetCode!=""){
         alert("检查完成");
      } 
   }
   if ((CheckFunction=="GetRebillNum")){
      var RetCode=tkMakeServerCall("web.DHCIPBillCheckDaily",CheckFunction,StDate,EndDate);
      if (RetCode!=""){
         alert("检查完成");
      } 
   }
   var DrugFlag=""
   if (CheckFunction=="GetCollectPriceDs"){
      DrugFlag="Old";
      var RetCode=tkMakeServerCall("web.DHCIPBillCheckDaily",CheckFunction,StDate,EndDate,DrugFlag); 
      if (RetCode!=""){
         alert("检查完成");
      }  
   }
   if (CheckFunction=="GetCollectPriceDsNew"){
      DrugFlag="New";
      CheckFunction1="GetCollectPriceDs"
      var RetCode=tkMakeServerCall("web.DHCIPBillCheckDaily",CheckFunction1,StDate,EndDate,DrugFlag);  
      if (RetCode!=""){
         alert("检查完成");
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