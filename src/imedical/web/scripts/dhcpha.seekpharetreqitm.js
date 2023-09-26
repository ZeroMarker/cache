/// dhcpha.seekpharetreqitm.js
function BodyLoadHandler()
{
	window.prompt = (function(prompt)
	{
    	return function(msg)
    	{
			window.vbs_var = null;
			execScript('window.vbs_var = InputBox(unEscape("'+escape(msg)+'"), "�û���ʾ")', "VBScript");
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
	if 	(status!="������ҩ��")
		{alert(t['MODIFY_NOT_ALLOWED']) ;
		 return ;
		}
	var obj=document.getElementById("retrqrowid"+"z"+currentRow )
	if (obj) var retrq=obj.value  ;
	
	var IfONE=CheckPrioirty(retrq);   //�Ƿ�ȡҩҽ��
	if(IfONE==1)
	{
		alert("��ȡҩҽ�����Ժ��ҩ�������޸�����!");
		return;	
	}
	else if(IfONE==2)
	{
		alert("�Ѿ�ִ�й��˷Ѳ����������޸�����!");
		return;	
	}
	else if(IfONE==3)
	{
		alert("�Ѿ�ִ�й���ҩ�����������޸�����!");
		return;	
	}
	else if(IfONE==4)
	{
		alert("�˼�¼�и����շ���Ŀ�������޸���ҩ����!!");
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
  	var oneflag=cspRunServerMethod(encmeth,reqitmid)     //�Ƿ�ȡҩҽ��
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
	if 	(status!="������ҩ��")
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

//�����˷�
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
	if (result==-11) { alert("����ҩ,���ܳ���");return;}
	if (result==-9) { alert("�ѽ���,���ܳ���");return;}
	if (result==-10) { alert("δ�˷�,���ܳ���");return;}
	if (result==-12) { alert("�Ѽ���,���ܳ���");return;}
	if (result!=0) { alert("����ʧ��");return;}
	
	window.location.reload();  //refresh window display
	
}


document.body.onload=BodyLoadHandler;