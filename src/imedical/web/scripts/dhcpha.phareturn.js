// dhcpha.phareturn.js
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("RegNo") ;
	if (obj)
	{ obj.onblur=RegNoBlur; 
	  obj.onkeydown=ValidateRegNo ;
	}
	obj=document.getElementById("Clear") ;
	if (obj) obj.onclick=ClearClick;
	obj=document.getElementById("Exit") ;
	if (obj) obj.onclick=ExitClick;
	obj=document.getElementById("FindDisp") ;
	if (obj) obj.onclick=FindDispClick;
	obj=document.getElementById("FindRetRequest") ;
	if (obj) obj.onclick=SeekPhaRetReqClick;
	obj=document.getElementById("ReturnQuery") ;
	if (obj) obj.onclick=ReturnQueryClick;
	obj=document.getElementById("Ok") ;
	if (obj) obj.onclick=OKClick;
	obj=document.getElementById("ExecuteReturn") ;
	if (obj) obj.onclick=ExecuteReturnClick;
	
	obj=document.getElementById("PaName")
	if (obj) obj.readOnly=true ;
	obj=document.getElementById("Sex")
	if (obj) obj.readOnly=true ;
	obj=document.getElementById("DOB")
	if (obj) obj.readOnly=true ;
	
	var obj=document.getElementById("ReturnLoc"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popReturnLoc;
	 obj.onblur=ReturnLocCheck;
	} //2005-05-26

	var obj=document.getElementById("ReturnReason"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popReturnReason;
	 obj.onblur=ReturnReasonCheck;
	} //2005-05-26



	obj=document.getElementById("BodyLoaded");
	if (obj.value!=1)
	{
	//	GetDefLoc();
		setDefaultDate();
	}
	setBodyLoaded();
}
function ValidateRegNo()
{
	if (window.event.keyCode==13) 
	{RegNoBlur(); }
}
function popReturnReason()
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  ReturnReason_lookuphandler();
		}
}//2006-05-26

function ReturnReasonCheck()
{
	// 2006-05-26
	var obj=document.getElementById("ReturnReason");
	var obj2=document.getElementById("retreasonrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}// 2006-05-26

function ReturnLocCheck()
{
	// 2006-05-26
	var obj=document.getElementById("ReturnLoc");
	var obj2=document.getElementById("returnlocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}// 2006-05-26
function popReturnLoc()
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  ReturnLoc_lookuphandler();
		}
}//2006-05-26

function setBodyLoaded()
{
	var obj=document.getElementById("BodyLoaded") ;
	if (obj) obj.value=1;
}

function setDefaultDate()
{
	var start=getRelaDate(-7);
	var end=today();
	var obj=document.getElementById("StartDate") ;
	if (obj) obj.value=start;
	var obj=document.getElementById("EndDate") ;
	if (obj) obj.value=end;
	
}
function ClearClick()
{  
	//ClearField("ReturnLoc");
	ClearField("RetRequestNo");
	//ClearField("StartDate");
	//ClearField("EndDate");
	ClearField("RegNo");
	ClearField("PaName");
	ClearField("Sex");
	ClearField("DOB");
	ClearField("ReturnReason");
	ClearField("retreasonrowid");
	ClearField("ReturnQty");
parent.frames['dhcpha.phareturn'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phareturn"
}
function ClearField(ss)
{	var obj; 
	obj = document.getElementById(ss) ;
	if (obj) obj.value="" ;
}

function ExitClick()
{history.back();}
function FindDispClick()
{
	if ( CheckConWhenFindingDsp()==false ) return ;
	FindDisp_click();
	
	//var obj=document.getElementById("StartDate") ;
	//if (obj) sd=obj.value ;
	//var obj=document.getElementById("EndDate");
	//if (obj) ed=obj.value ;
	//var obj=document.getElementById("RegNo");
	//if (obj) regno=obj.value ;
	//var obj=document.getElementById("returnlocrowid");
	//if (obj) retloc=obj.value ;
	
	//var url="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phareturn&StartDate="+sd+"&EndDate="+ed+"&RegNo="+regno+"&returnlocrowid="+retloc
	//alert(url);
	//location.href=url ;
}
function ReturnQueryClick()
{var lnk="dhcpha.phareturnquery.csp";
   //location.href=lnk;
   //window.open(lnk,"_blank") ;
    window.open(lnk,"_blank","height=500,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
}
function CheckConWhenFindingDsp()
{//check and valiate the condition input 
// when you want to find dispensing
	var obj ;
	obj = document.getElementById("returnlocrowid")
	if (obj) {
		if (obj.value==''){
			alert(t['NO_RETLOC']);
			return false ;
						}		}
	var obj1 = document.getElementById("StartDate")
	if (obj1) {
		if (obj1.value==''){
			alert(t['NO_STARTDATE']);	
			return false ;
					}		}
	var obj2 = document.getElementById("EndDate")
	if (obj2) {
		if (obj2.value==''){
			alert(t['NO_ENDDATE']);
			return false ;
					}		}

	
	if (DateStringCompare(obj1.value,obj2.value)==1)
	{alert(t['INVALID_DATESCOPE']) ;
		return false ;
		}
		
	var obj3 = document.getElementById("RegNO")
	if (obj3) {
		if (obj3.value=='') {
			alert(t['NO_REGNO&REQ']);	
			return false ;
				}		}
	return true ;
}


function getAdmInfo()
{
	}
function SetPa(value)
{
  //set patient info of compoment
	var painfo=value.split("^")	;
	var obj;
	obj=document.getElementById("Name");
	if (obj) obj.value=painfo[0];
	obj=document.getElementById("Sex");
	if (obj) obj.value=painfo[1];
	obj=document.getElementById("Age");
	if (obj) obj.value=painfo[2];
}
function RegNoBlur()
{
	//when RegNo lost focus then this event fires .
	var obj;
	obj=document.getElementById("RegNo") ;
	if (obj) {var regno=obj.value ;}
	if (regno=="")
	{ 
		ClearField("PaName");
		ClearField("Sex");
		ClearField("DOB");
		return ;
		}
	else
		{
		obj.value=getRegNo(regno)
		regno=obj.value ; }
		
	
	//set patient info
    var getpa=document.getElementById('mGetPa');
	if (getpa) {var encmeth=getpa.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetPa','',regno)=='0') {}  
    else
	  {	
	  alert(t['INVALID_REGNO']) ;
	  ClearField("RegNo");
	ClearField("PaName");
	ClearField("Sex");
	ClearField("DOB");
	}	
 }	
function SetPa(value)
{
  //set patient info of compoment
	var painfo=value.split("^")	;
	var obj;
	obj=document.getElementById("PaName");
	if (obj) obj.value=painfo[0];
	obj=document.getElementById("Sex");
	if (obj) obj.value=painfo[1];
	obj=document.getElementById("DOB");
	if (obj) obj.value=painfo[2];
}
function SeekPhaRetReqClick()
{  var lnk="dhcpha.phareturnbyreq.csp" ;  //"dhcpha.seekpharetrequest.csp";
   window.open(lnk,"_blank","height=500,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
	}
function DispLocLookUpSelect(str)
{
	var ss=str.split("^") ;
	if ( ss.length>0) 
	{ 
		var obj=document.getElementById("returnlocrowid") ;
		if (obj) obj.value=ss[1] ; // rowid of the disp loc
	}
}
function OKClick()
{ //update the return qty to table 

  //Validate the condition 
	var dspid="";
	var obj=document.getElementById("currentRow") ;
	var row=obj.value ;
	if (row<1) {
		alert(t['NO_ROW_SELECTED']) ;
		return ;
	}
	//
	var obj=document.getElementById("ReturnQty")
	if (obj) {
		var retqty=obj.value ;
		if (parseFloat(retqty)<=0||(isNaN(retqty))||(retqty==""))
		{
			alert(t['INVALID_RETQTY']) ;
		 	return;
		}
	}
	//var obj=document.getElementById("TOEDISDRz"+row) ;
	// var obj=document.getElementById("TPhaciz"+row) ; zhouyg 20121008
	var obj=document.getElementById("TDspidz"+row);
    if (obj)
    {
	    var dspid=obj.value; 
    	if (allowReturn(dspid,parseFloat(retqty))==false)
    	{alert(t['RETQTY_TOOLARGE']) ;
    	 return ;
    	}
	}
	//
	var obj=document.getElementById("TDispQtyz"+row);
	if (obj){
		var PartFlag=CheckRetPart(dspid,parseFloat(retqty))
		if (PartFlag=="0")
		{						
			alert("此记录有附加收费项目，不能部分退药!")
			return ;	
		}
		var dspqty=DHCWeb_GetValue("TDispQtyz"+row);
		
		/*var IfONE=CheckPrioirty(dspid);
		if((IfONE!=1)&&(parseFloat(dspqty)!=parseFloat(retqty)))
		{
			alert("非取药医嘱和出院带药，不能部分退药!");
			return ;
		}*/
		
		if (parseFloat(retqty)>parseFloat(dspqty))
		{
			alert("退药数量不能大于发药数量!")
			return;
		}
		var incicode=document.getElementById("TCodez"+row).value;
		var refrefuseflag=tkMakeServerCall("web.DHCST.ARCALIAS","GetRefReasonByCode",incicode);
		if (refrefuseflag!=""){
			if (refrefuseflag.split("^")[3]!=""){
				alert("第"+row+"行药品"+refrefuseflag.split("^")[1]+",在药品基础数据中目前为不可退药状态,不能申请!\n不可退药原因:"+refrefuseflag.split("^")[3]);
				canreq=4;
				return;
			}			
		}
	}
	var obj=document.getElementById("TReturnQtyz"+row) ;
	if (obj)
	{obj.innerText=parseFloat(retqty);	}   //update the return qty .
}
///是否允许部分退药
///1-可以修改退药，0-不可以修改退药
function CheckRetPart(dodis,RetQty)
{
	var objmPartFlag=document.getElementById("mGetRetPartFlag") ;
	if (objmPartFlag) {var encmeth=objmPartFlag.value;} else {var encmeth='';}
  	var Retflag=cspRunServerMethod(encmeth,dodis,RetQty);     //是否取药医嘱
  	return Retflag;
}
function CheckRetQty()
{
		
	}
function allowReturn(oedis,retreqqty)
	{//根据已发药和已退药情况决定是否允许此次的退药
	 //oedis : rowid of OE_Dispensing
	 //retreqqty : quantity of requiring returned
	var validQty=document.getElementById("mValidateReqQty");
	if (validQty) {var encmeth=validQty.value} else {var encmeth=''};
	var result=cspRunServerMethod(encmeth,'','',oedis,retreqqty)  ;
	
	 if (result==0)
	 	 {return false }
	 else
 		{return true };
	}

function RetReasonLookUpSelect(str)
{
	var reason=str.split("^") ;
	if (reason.length>0)
	{var reasonrowid=reason[1] ;
	 var obj=document.getElementById("retreasonrowid");
	 if (obj){
		 obj.value=reasonrowid;	 }
	 else
	 	obj.value="" ;
		}
	}
function getRetNewNo()
{
	//create and get return No 
    var getRetNo=document.getElementById('mCreateRetNo');
	if (getRetNo) {var encmeth=getRetNo.value} else {var encmeth=''};
	var newRetNo=cspRunServerMethod(encmeth,'SetPa','','RT')
	if (newRetNo=="") 
	{ alert(t['CANNOT_CREATE_NO']) ;
		return "" ;	}
	return newRetNo	
}


function ExecuteReturnClick()
{// the code for returning 
// 1.save the return data
// 2.handle the stock changing 
    
	var RetNo="";  //getRetNewNo();
	//if (RetNo=="") return ;
	
	//check the data
	var objtbl=document.getElementById("t"+"dhcpha_phareturn");
	if (objtbl)	var rowcnt=getRowcount(objtbl) ;
	if (rowcnt<1)
	{alert(t['NO_ROWS']) ;
	 return ;}

	 var reasonid="",retSuccess=""
 	// reason
 	var obj=document.getElementById("retreasonrowid")
 	if (obj)	var reasonid=obj.value;
 	if (reasonid==""){
	 	alert(t['NO_RETREASON']) ;
	 	return ;  }
	
	//var reasonid="",retSuccess=""
	var UserDR=session['LOGON.USERID']
	var datastr="" ;
	var Reclocdr="";
	for (var i=1;i<=rowcnt;i++)
	{  
		var obj=document.getElementById("TReturnQtyz"+i)
		if (obj)
		{
			var retqty=obj.innerText ;
			//alert(retqty);
			if (retqty>0)
			{
			 	//execute insert
			 	var obj=document.getElementById("TOEDISDR"+"z"+i);
			 	if (obj) var Oedisdr  = obj.value 
			 	var obj=document.getElementById("TINCLBDR"+"z"+i);
			 	if (obj) var Inclbdr = obj.value 
			 	var obj=document.getElementById("TADMDR"+"z"+i);
			 	if (obj) var Admdr = obj.value 
			 	
			 	var obj=document.getElementById("TADMLOCDR"+"z"+i);
			 	if (obj) var Admlocdr = obj.value
			 	var obj=document.getElementById("TDEPTDR"+"z"+i);
			 	if (obj) var DeptDr = obj.value 
			 	var obj=document.getElementById("TBEDDR"+"z"+i);
			 	if (obj) var BedDr = obj.value 
			 	var obj=document.getElementById("TRETRQDR"+"z"+i);
			 	if (obj) var  RetRqDR= obj.value 
			 	var DD=""
			 	var TT=""
			 	var obj=document.getElementById("TPrescNo"+"z"+i);
			 	if (obj) var Prescno= obj.innerText 
			 	var obj=document.getElementById("TReturnQty"+"z"+i);
			 	if (obj) var Qty= obj.innerText; 
			 	var obj=document.getElementById("TReturnPrice"+"z"+i);
			 	if (obj) var Price= obj.innerText 
			 	var Amount=Price*Qty
			 	//
			 	var obj=document.getElementById("TCode"+"z"+i);
			 	if (obj) var itmcode= obj.value 
			 	var obj=document.getElementById("TUom"+"z"+i);
			 	if (obj) var Uom= obj.innerText 
				var obj=document.getElementById("TDspid"+"z"+i);
			 	if (obj) var DspId= obj.value
			 	var obj=document.getElementById("TRECLOCDR"+"z"+i);
			 	if (obj) Reclocdr  = obj.value 
			 	
			 	var obj=document.getElementById("TDesc"+"z"+i);
			 	if (obj) var desc= obj.innerText
			 	 
		    
		 		if(datastr==""){
			 		datastr=DspId+"^"+Qty+"^"+reasonid;	
			 	}
			 	else{
				 	datastr=datastr+","+DspId+"^"+Qty+"^"+reasonid;
				}					  
			    retSuccess=1;
		  				  
			  }
	
		}		
	}
	

	if (retSuccess=="") {alert("请选择记录并填入退药数量!");return;}
	
	//sendMessageToHX(RetNo); ///传退药数据至华西老HIS  LQ
	//alert(datastr);
	//alert(Reclocdr);
	//alert(UserDR);
	var execRet=document.getElementById('mExecReturn');
	if (execRet) {var encmeth=execRet.value} else {var encmeth=''};
	var result=cspRunServerMethod(encmeth,Reclocdr,UserDR,"RT",datastr);
    var msg=result.split("^")
    if(msg[0]=="success"){
	    RetNo=msg[1];
	    alert(t['EXERET_SUCCEED']) ;
	}
	else
	{
		if (msg[1]==-3){  
			alert("存在药品退药数量 >  (发药数量 - 已退药数量),请刷新后核实!") ;
		}
		else if(msg[1]==-12){
			 alert("存在执行记录状态不是停止执行或撤销执行的药品，不允许退药!") ;
			 
		} 
		else if(msg[1]==-9){
			 alert("存在未退申请单，不允许再使用直接退药!") ;
			 
		}
		else if(msg[1]==-4){
			 alert("该患者已做完最终结算，不允许退药!") ;
			 
		}
		else if(msg[1]==-11){
			 alert("不允许退药:已经中途结算,不能退药!") ;
			 
		}else{ 
			alert(t['EXERET_FAILED']+":"+msg[1]) ;
		}
		
		 return ;
	}				  
	
	
	if (confirm(t['ASKPRINT'])==true)  
	{
	
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.printphareturn&PhaRetNo="+RetNo
        parent.frames['dhcpha.printphareturn'].window.document.location.href=lnk;	
	 }  
	
	ReLoadWin();	
	
}
function sendMessageToHX(RetNo)
{    
        ///description:传退药数量至华西老HIS

        var obj=document.getElementById("SendMssage") ;
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		var message=cspRunServerMethod(encmeth,RetNo) ;

}
function ReLoadWin()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phareturn"
	location.href=lnk ;
	
	}
function SelectRowHandler() {
	var row=selectedRow(window);
	var obj=document.getElementById("currentRow") ;
	if (obj) obj.value=row
}
function ReqNoBlur()
{
	var obj=me.getElementById("RetRequestNo")
	if (obj) var retreqno=obj.value;
	if (retreqno!="")
	{
		getRetRequest(retreqno) ;
		}
	}
function getRetRequest(reqno)
{ //get the data of ret request
   // if (reqno=="") return ;
    
  //  var setret=document.getElementById('mSetRetByReq');
//	if (setret) {var encmeth=setret.value} else {var encmeth=''};
//	if (cspRunServerMethod(encmeth,'setRet','',reqno)=='0') {}  

 
	
}
function GetDefLoc()
{	
	var objBodyLoaded=document.getElementById("BodyLoaded") ;
	if (objBodyLoaded) BodyLoaded=objBodyLoaded.value;
	
	//alert(BodyLoaded);
	if (BodyLoaded!=1)
	{
		var userid=session['LOGON.USERID'] ;
		var obj=document.getElementById("mGetDefaultLoc") ;
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		var ss=cspRunServerMethod(encmeth,'setDefLoc','',userid) ;
		objBodyLoaded.value=1;
	}
}
function setDefLoc(value)
{
	var defloc=value.split("^");
	if (defloc.length>0)
	var locdr=defloc[0] ;
	var locdesc=defloc[1] ;
	if (locdr=="") return ;
	var obj=document.getElementById("ReturnLoc") ;
	if (obj) obj.value=locdesc
	var obj=document.getElementById("returnlocrowid") ;
	if (obj) obj.value=locdr
	
}
function CheckPrioirty(dodis)
{
	var objPriority=document.getElementById("mCheckPriority") ;
	if (objPriority) {var encmeth=objPriority.value;} else {var encmeth='';}
  	var oneflag=cspRunServerMethod(encmeth,dodis)     //是否取药医嘱
  	return oneflag
}
document.body.onload=BodyLoadHandler;
