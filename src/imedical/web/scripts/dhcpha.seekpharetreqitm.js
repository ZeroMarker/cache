/// dhcpha.seekpharetreqitm.js
function BodyLoadHandler()
{
	window.prompt = (function(prompt)
	{
    	return function(msg)
    	{
			window.vbs_var = null;
			execScript('window.vbs_var = InputBox(unEscape("'+escape(msg)+'"), "用户提示")', "VBScript");
			return window.vbs_var;
		};
	})(window.prompt);

}

function SelectRowHandler() {
	var row=DHCWeb_GetRowIdx(window);
	var obj=document.getElementById("currentRow")  ;
	if (obj) obj.value=row ;
}
	
function UpdateQty()
{
    var obj=document.getElementById("t"+"dhcpha_seekpharetreqitm")
    if (obj)
    {
		var rowcnt=getRowcount(obj)
		if (rowcnt<=0)
		{alert(t['NO_ANY_ROW']) ;
		return;    	}
    }
    else
		{
			return;
		}
 	var obj=document.getElementById("currentRow")  ;
	if (obj) var currentRow=obj.value;
	if (currentRow<=0) 
		{alert(t['SELECT_ONEROW']) ;
	 	return;
		}
	var obj=document.getElementById("Status"+"z"+currentRow) ;
	if (obj) var status=obj.innerText
	if 	(status!="申请退药中")
		{alert(t['MODIFY_NOT_ALLOWED']) ;
		 return ;
		}
	var obj=document.getElementById("retrqrowid"+"z"+currentRow )
	if (obj) var retrq=obj.value  ;
	
	var IfONE=CheckPrioirty(retrq);   //是否取药医嘱
	if(IfONE==1)
	{
		alert("非取药医嘱或出院带药，不能修改数量!");
		return;	
	}
	else if(IfONE==2)
	{
		alert("已经执行过退费操作，不能修改数量!");
		return;	
	}
	else if(IfONE==3)
	{
		alert("已经执行过退药操作，不能修改数量!");
		return;	
	}
	else if(IfONE==4)
	{
		alert("此记录有附加收费项目，不能修改退药数量!!");
		return;	
	}
	
	//update qty
	var qty=window.prompt(t['INPUT_QTY'],"")
	if (qty==null) return;
	if (isNaN(qty)) 
	{
		alert(t['NOT_VALID_NUMBER']) ;
		return ;		}
	
	var obj=document.getElementById("mCheckAllowReturn") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	
	var result=cspRunServerMethod(encmeth,'','',retrq,qty  ) ;
	
	if (result==0) {
		alert(t['QTY_NOT_ALLOWED']);
		return 	;	}
	
	var user=session['LOGON.USERID']
	var obj=document.getElementById("mUpdateQty") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	
	var result=cspRunServerMethod(encmeth,'','',retrq,qty,user  ) ;
    if (result==0) 
    {
	    alert(t['UPDATE_OK']) ;
	    window.location.reload();  //refresh window display zhouyg 20141215
     	return ;
    }
    else
    {alert(t['UPDATE_FAILED']);}

}

function CheckPrioirty(reqitmid)
{
	
	var objPriority=document.getElementById("mCheckPriority") ;
	if (objPriority) {var encmeth=objPriority.value;} else {var encmeth='';}
  	var oneflag=cspRunServerMethod(encmeth,reqitmid)     //是否取药医嘱
  	return oneflag
}

function DeleteReq()

{
	
    var obj=document.getElementById("t"+"dhcpha_seekpharetreqitm")
    if (obj)
    {
	    
	    
		var rowcnt=getRowcount(obj)
		if (rowcnt<=0)
		{alert(t['NO_ANY_ROW']) ;
		return;    	}
    }
    else
		{
			return;
		}
 	var obj=document.getElementById("currentRow")  ;
	if (obj) var currentRow=obj.value;
	if (currentRow<=0) 
		{alert(t['SELECT_ONEROW']) ;
	 	return;
		}
	var obj=document.getElementById("Status"+"z"+currentRow) ;
	if (obj) var status=obj.innerText
	if 	(status!="申请退药中")
		{alert(t['DEL_NOT_ALLOWED']) ;
		 return ;		}
	
	var ret=confirm(t['REALLY_DEL']);
	if (ret==false) return ;
	//
	var obj=document.getElementById("retrqrowid"+"z"+currentRow )
	if (obj) var retrq=obj.value  ;
	var obj=document.getElementById("mDelRetReq") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	
	var result=cspRunServerMethod(encmeth,'','',retrq  ) ;

	window.location.reload();  //refresh window display


}

//撤消退费
function RevokeRefund()

{
	
	var obj=document.getElementById("t"+"dhcpha_seekpharetreqitm")
    if (obj)
    {
	    
	    
		var rowcnt=getRowcount(obj)
		if (rowcnt<=0)
		{alert(t['NO_ANY_ROW']) ;
		return;    	}
    }
    else
		{
			return;
		}
 	var obj=document.getElementById("currentRow")  ;
	if (obj) var currentRow=obj.value;
	if (currentRow<=0) 
		{alert(t['SELECT_ONEROW']) ;
	 	return;
		}
		
    var obj=document.getElementById("retrqrowid"+"z"+currentRow )
	if (obj) var retrq=obj.value  ;
	var obj=document.getElementById("mRevokeRefund") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,retrq  ) ;
	if (result==-11) { alert("已退药,不能撤消");return;}
	if (result==-9) { alert("已结算,不能撤消");return;}
	if (result==-10) { alert("未退费,不能撤消");return;}
	if (result==-12) { alert("已计帐,不能撤消");return;}
	if (result!=0) { alert("撤消失败");return;}
	
	window.location.reload();  //refresh window display
	
}


document.body.onload=BodyLoadHandler;