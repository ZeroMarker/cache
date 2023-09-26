///DHCIPBillDepList.js
function BodyLoadHandler()
{  
   IntDoument();	
}

///初始化窗体
function IntDoument(){
	///获取押金汇总信息
	InitDepositPayMode();
	getzyjfconfig();  //获取系统配置信息
	var selObj=document.getElementById("SelectFlag");
	if(selObj) {
		selObj.onclick=selObj_onClick;
	    selObj.checked=true;
	}
    //默认不可选择结算押金
    if(SelYjPaylFlag=="N"){                        ////update  by zhl 20111208  Start
	    selObj.disabled=true
	    ChangeBillFlagStatus(true)
    }
    else{
	    selObj.disabled=false
	    ChangeBillFlagStatus(false)                  //update  by zhl 20111208   end
	    }
	 //验证病人是否在院,徐州医院要求"最终结算"状态的病人的押金必须全部结算
	/*var rtn=tkMakeServerCall("web.UDHCJFPAY","CheckVisitStatus",document.getElementById("Adm").value)
	if(rtn!="A"){
		selObj.disabled=true
		ChangeBillFlagStatus(true)
		}*/
	//ChangeBillFlagStatus(true)             //update  by zhl 20111208
}
function InitDepositPayMode(){
	var depositInfo=tkMakeServerCall("web.UDHCJFBaseCommon","GetDepositPayM",document.getElementById("Adm").value);
	var tmp=depositInfo.replace(/\^/g,":");
	var tmp=tmp.replace(/!/g," ");
	document.getElementById('cDepositInfo').innerText="预交金合计: " +tmp;
}
///单击事件
function SelectRowHandler() {
  ///add  by  zhl 20120202    start  ////
  ///if(window.event.srcElement.id.indexOf("TBillFlag")>-1){
	    var payObj=parent.frames["UDHCJFPAY"];
	    var Objtbl=payObj.document.getElementById('tUDHCJFPAY');
        var Rows=Objtbl.rows.length;
        var PayMNum=0
        for (var i=2;i<Rows;i++){
	         var obj=payObj.document.getElementById("TInsuFlagz"+i)
	         if ((obj)&&(obj.innerText!="Y")) PayMNum=PayMNum+1 
	         }  
	    
	    if (PayMNum>0) {
		    
		    if (obj.checked){
			       obj.checked=false;
			    }
		    else{
			    obj.checked=true;
			    }
			    alert("添加支付方式后此操作无效");
		    return;}
	    
	    
     ///}
     ///add  by  zhl 20120202    end  ////
	    getBillDepositAmt();
}
///获取要结算的押金金额
function getBillDepositAmt(){
	var payObj=parent.frames["UDHCJFPAY"];
	var depListObj=parent.frames["DHCIPBillDepList"];
	var selectDepAmt=0,depRowidStr=""
	var eSrc=window.event.srcElement;
    var rowobj=getRow(eSrc)
	Objtbl=document.getElementById('tDHCIPBillDepList');
    Rows=Objtbl.rows.length;
    var lastrowindex=Rows - 1;
    var rowObj=getRow(eSrc);
    var selectrow=rowObj.rowIndex;
    if (!selectrow) return;
    var SelRowObj=document.getElementById('TBankBackFlagz'+selectrow);
    var TBankBackFlag=SelRowObj.value
    var TBillFlagObj=document.getElementById('TBillFlagz'+selectrow);
    var TDepPayMObj=document.getElementById('TDepPayMz'+selectrow);
    var TDepPayM=TDepPayMObj.innerText
    var TPrtStatusObj=document.getElementById('TPrtStatusz'+selectrow);
    var TPrtStatus=TPrtStatusObj.innerText    
    if ((TBankBackFlag=="1")&&(TDepPayM=="支票")&&(TPrtStatus=="正常")){	   
	   alert("支票未到帐");
	   TBillFlagObj.checked=false;
       return;  
	}
	if ((payObj)&&(depListObj)) {
		selectDepAmt=DHCWebD_CalListCol(depListObj,"TDepAmt","TBillFlag");
		depRowidStr=DHCWebD_GetColInfo(depListObj,"TPayMRowid","TBillFlag");
	}
	payObj.depositsumobj.value=selectDepAmt.toFixed(2);
	
	var tmpamt=eval(payObj.depositsum)-eval(selectDepAmt);
	var pay=eval(tmpamt)+eval(payObj.payobj.value);
    ///alert("selectDepAmt="+selectDepAmt)
    ///var pay=eval(tmpamt)+eval(payObj.amounttopayobj.value);
    payObj.balanceobj.value=pay.toFixed(2);
    payObj.pay=pay.toFixed(2);    //add  by zhl 20111208
    payObj.amounttopayobj.value=payObj.balanceobj.value;
    if(payObj.amounttopayobj.value<0){
		 payObj.amounttopayobj.style.color="red";   
	}else{
	     payObj.amounttopayobj.style.color="black";		
	}
	
	payObj.tmpdep="^"+depRowidStr;
}
function selObj_onClick(){
	
	if (SelYjPaylFlag=="N"){
	   alert("不能选择押金结算!!");
	   return;
	}
	////modify 2014-06-09 判断是否增加过非医保支付方式，如果增加过“全选”不能使用/////
	var payObj=parent.frames["UDHCJFPAY"];
	var Objtbl=payObj.document.getElementById('tUDHCJFPAY');
    var Rows=Objtbl.rows.length;
    var PayMNum=0
    for (var i=2;i<Rows;i++){
	   var obj=payObj.document.getElementById("TInsuFlagz"+i);
	   
	   if ((obj)&&(obj.innerText!="Y")) {PayMNum=PayMNum+1;} 
	}
	if (eval(PayMNum)>0){
	   alert("添加支付方式后此操作无效");
	   return;	
	}
	/////////////////////////////////////////////////////////////////////////////////
	if(this.checked){
		if(SelYjPaylFlag=="Y"){
		 	ChangeBillFlagStatus(true)    
		}
	}else{
		if(SelYjPaylFlag=="Y"){
	    	ChangeBillFlagStatus(false)	 
		}		
	}
	getALLDepositAmt();
}
function ChangeBillFlagStatusbak(bool){
	  
	   var selObj=document.getElementById("SelectFlag");
	   var tabObj=document.getElementById("tDHCIPBillDepList");
	   var rows=tabObj.rows.length;
	   for (var row=1;row<rows;row++){
			var obj=document.getElementById('TBillFlagz'+row);
			var TBankBackFlagobj=document.getElementById('TBankBackFlagz'+row); 
			var TBankBackFlag=TBankBackFlagobj.value
			var TPrtStatusobj=document.getElementById('TPrtStatusz'+row);
			var TPrtStatus=TPrtStatusobj.innerText;
			var TDepPayMobj=document.getElementById('TDepPayMz'+row);
			var TDepPayM=TDepPayMobj.innerText;
					
			if (selObj.checked){
				if (TBankBackFlag=="0"){
				   obj.checked=true;
				}else{
				   if ((TDepPayM=="支票")&&(TPrtStatus=="正常")){
				      obj.checked=false;   
				   }else{
				      obj.checked=true;	   
				   }
				}				
			}else{				
		        obj.checked=false; 		
			}
			obj.disabled=bool;
				
	   }
}
function ChangeBillFlagStatus(bool){
	
	   var selObj=document.getElementById("SelectFlag");
	   var tabObj=document.getElementById("tDHCIPBillDepList");
	   var rows=tabObj.rows.length;
	   for (var row=1;row<rows;row++){
			var obj=document.getElementById('TBillFlagz'+row);
			if(selObj.checked){
				obj.checked=true;	
			}
			obj.disabled=bool;
				
	   }
}
///Lid 获取选中列信息以"^"分割
function DHCWebD_GetColInfo(ListFramObj,colname,colfname){
	var tablistOPOE=ListFramObj.document.getElementById("t" + ListFramObj.name);
	var firstrow=tablistOPOE.rows[0];
	var firstitems=firstrow.all;
	if (!firstitems) firstitems=objrow.getElementsByTagName("*"); //N6
	var myaryid=firstitems[1].id.split("z");
	if (myaryid.length==2){
		//no header
			fIdx=0
		}else{
			fIdx=1
		}
	var rtnres=0;
	var i=0
	var tablistobj=ListFramObj.document.getElementById("t" + ListFramObj.name);
	var doclistobj=ListFramObj.document;
	var rowidxs=tablistobj.rows.length;  ///-1
	var tmpStr="";
	for (var i=fIdx;i<rowidxs;i++)
	{
		var fobj=doclistobj.getElementById(colfname+"z"+i);
		if (fobj){
			if (fobj.checked){
				var listobj=doclistobj.getElementById(colname+"z"+i);	////.innerText
				if (listobj){
					if(tmpStr===""){
					    tmpStr=DHCWebD_GetCellValue(listobj);
					    	
					}else{
						tmpStr=tmpStr+"^"+DHCWebD_GetCellValue(listobj);		
					}	
				} 
			    
			}
		}
	}
	//alert(tmpStr);
	return tmpStr;	
}
///modify 2014-06-09 全选或不全选时结算押金总额
function getALLDepositAmt(){
	var payObj=parent.frames["UDHCJFPAY"];
	var depListObj=parent.frames["DHCIPBillDepList"];
	var selectDepAmt=0,depRowidStr=""
	var eSrc=window.event.srcElement;
    var rowobj=getRow(eSrc)
	Objtbl=document.getElementById('tDHCIPBillDepList');
    Rows=Objtbl.rows.length;
    for (var i=1;i<Rows;i++){
    
       var SelRowObj=document.getElementById('TBankBackFlagz'+i);
       var TBankBackFlag=SelRowObj.value
       var TBillFlagObj=document.getElementById('TBillFlagz'+i);
       var TDepPayMObj=document.getElementById('TDepPayMz'+i);
       var TDepPayM=TDepPayMObj.innerText
       var TPrtStatusObj=document.getElementById('TPrtStatusz'+i);
       var TPrtStatus=TPrtStatusObj.innerText    
       if ((TBankBackFlag=="1")&&(TDepPayM=="支票")&&(TPrtStatus=="正常")){	   
	      alert("支票未到帐");
	      TBillFlagObj.checked=false;
          return;  
	   }
	   if ((payObj)&&(depListObj)) {
		  selectDepAmt=DHCWebD_CalListCol(depListObj,"TDepAmt","TBillFlag");
		  depRowidStr=DHCWebD_GetColInfo(depListObj,"TPayMRowid","TBillFlag");
	   }
    }   
    ///alert("selectDepAmt="+selectDepAmt);
    ///alert("depRowidStr="+depRowidStr);
    ///alert("payObj.depositsumobj.value="+payObj.depositsumobj.value)
	   payObj.depositsumobj.value=selectDepAmt.toFixed(2);
	
	   var tmpamt=eval(payObj.depositsum)-eval(selectDepAmt);
	   var pay=eval(tmpamt)+eval(payObj.payobj.value);
    
       payObj.balanceobj.value=pay.toFixed(2);
       payObj.pay=pay.toFixed(2);    //add  by zhl 20111208
       payObj.amounttopayobj.value=payObj.balanceobj.value;
       if(payObj.amounttopayobj.value<0){
		    payObj.amounttopayobj.style.color="red";   
	   }else{
	        payObj.amounttopayobj.style.color="black";		
	   }
    
	payObj.tmpdep="^"+depRowidStr;
}
document.body.onload = BodyLoadHandler;