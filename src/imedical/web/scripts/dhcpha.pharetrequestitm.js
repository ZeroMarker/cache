
function BodyLoadHandler()
{
	var obj=document.getElementById("Save");
	if (obj) obj.onclick=SaveClick;
	var obj=document.getElementById("Delete");
	if (obj) obj.onclick=DeleteClick;
	var obj=document.getElementById("DeleteAll");
	if (obj) obj.onclick=DeleteAllClick;
	
	}
function GetNewNo()
{	//create the No .
	var getno=document.getElementById("mCreatNo") ;
	if (getno) {var encmeth=getno.value} else {var encmeth=''};
	var newno=cspRunServerMethod(encmeth,'','')  ;
	return newno
	}
function InsertRetReq(user,reqloc,data)
{
	var insert=document.getElementById("mInsert") ;
	if (insert) {var encmeth=insert.value} else {var encmeth=''};
	var result=(cspRunServerMethod(encmeth,user,reqloc,data))
    var msg=result.split("^");
	if (msg[0]=="success") {return msg[1];}
	else{
		alert(t['INSERT_FAILED']+":"+ msg[1]);
		return "" ;
		}
	}

function SaveClick()
{
 	// save result data
 	var h=0
 	
	var objtbl=document.getElementById("t"+"dhcpha_pharetrequestitm") ;
	if (objtbl)
	{ var cnt=getRowcount(objtbl) ;
		if (cnt<2) {alert(t['NO_ROWS']) ;
			return ; } }
	else return ;
	//
	/*
	var newno=GetNewNo();
	if (newno=="") 
	{alert(t['CANNOT_CREATE_RETNO']);
	 return ;		}
	*/
	var userid=session['LOGON.USERID'] ;
	var reqloc="";
	var data="";
	for (var i=1;i<cnt;i++)
	{
		/*
		var col=document.getElementById("TRegNoz"+i) ;
		if (col) {var regno=col.innerText} ;
		var col=document.getElementById("TPrescNoz"+i) ;
		if (col) var prescno=col.innerText ;
		
		var col=document.getElementById("TUomz"+i) ;
		if (col) var uom=col.innerText ;
		var col=document.getElementById("TDispQtyz"+i) ;
		if (col) var dispqty=col.innerText ;
		*/
		var col=document.getElementById("TReqQtyz"+i) ;
		if (col){ var reqqty=col.innerText ;
		}else{
			cnt++;
			continue;
			}
		var col=document.getElementById("TDescz"+i) ;
		if (col) var desc=col.innerText ;
		/*
		var col=document.getElementById("TSalePricez"+i) ;
		if (col) var sp=col.innerText ;
		var col=document.getElementById("TSalePriceAmtz"+i) ;
		if (col) var spamt=col.innerText ;
		var col=document.getElementById("TDoctorz"+i) ;
		if (col) var doctor=col.innerText ;
		var col=document.getElementById("TRecLocDrz"+i) ;
		if (col) var reclocdr=col.value ;
		*/
		var col=document.getElementById("TWardDrz"+i) ;
		if (col) var warddr=col.value ;
		reqloc=warddr
		/*
		var col=document.getElementById("TBedDrz"+i) ;
		if (col) var beddr=col.value ;
		var col=document.getElementById("TDspDrz"+i) ;
		if (col) var oedis=col.value ;
		
		var col=document.getElementById("TAdmLocDRz"+i) ;
		if (col) var admlocdr=col.value ;
		var col=document.getElementById("TAdmdrz"+i) ;
		if (col) var admdr=col.value ;
		*/
		var col=document.getElementById("TRetReasonDR"+"z"+i) ;
		if (col)
		 {
		  var reasonDR=col.value ;
		 }
		
		
		var col=document.getElementById("Tdspid"+"z"+i) ;
		if (col) var dspid=col.value ;
		
		/*
        var s1 = newno+"^"+reclocdr+"^"+regno+"^"+prescno+"^"+reqqty;
        var s2=sp+"^"+spamt+"^"+ doctor+"^"+userid+"^"+warddr;
        var s3=beddr+"^"+oedis+"^"+admdr+"^"+admlocdr+"^"+reasonDR+"^"+dspid;
		var data=s1+"^"+s2+"^"+s3 */
		///lq 08-11-14--------------保存前再次判断
	    if (RetReqExists(dspid)==true)
			{ 	
				alert("该药品的退药申请已存在!请核实!"+ " RowNo : " + i+", "+desc );
			    continue;

			 }
							 
		if  (allowReturn(dspid,reqqty)==false)
				  {   
					 alert("申请数量 > 可退数量 ,请重新补填该药品"+ " RowNo : " + i+", "+desc)
					 continue;
			       }
		if(data==""){
			data=dspid+"^"+reqqty+"^"+reasonDR;
		}else{
			data=data+","+dspid+"^"+reqqty+"^"+reasonDR;
		}
		h=h+1;
	}
	
	if(h==0)
	{return;}
	var newno=InsertRetReq(userid,reqloc,data);
	///------------	
	if (newno=="") 
	{		
		return ;		
	}
	
	displayReqNo(newno);
	//AutoExecReturn(newno,468)    ;//"468" is the dispensing location rowid which need to return .2006-09-26
	alert(t['SAVE_OK']) ;
	ReloadWinowAll();

}

function displayReqNo(reqno)
{
	var obj=document.getElementById("RetReqNo");
	if (obj)
	{obj.value=reqno ;}
}
function clearReqNo()
{
	var obj=document.getElementById("RetReqNo");
	if (obj)
	{obj.value="" ;}
	}
function DeleteClick()
{
	var obj=document.getElementById("currentRow")
	var row;
	if (obj) row=obj.value;
	if (row<1) return ;

	var objtbl=parent.frames['y'].window.document.getElementById("tdhcpha_pharetrequestitm")
	DelOneRow(objtbl,row) ;
	if (getRowcount(objtbl)==0) ReloadWinow();
	}
function DeleteAllClick()
{  ReloadWinow();
	}
function ReloadWinow()
{	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.pharetrequestitm" ;
	location.href=lnk;
}

function AddDataToTable()
{ 
	var obj=document.getElementById("tdhcpha.pharetrequestitm");
	if (obj) alert("xxxxxxxxxxx");
	
}
function SelectRowHandler() {
	var row=DHCWeb_GetRowIdx(window);
	var obj=document.getElementById("currentRow") ;
	if (obj) obj.value=row
	var obj=document.getElementById("TRegNoz"+row) ;
	
}
function AutoExecReturn(reqNo,ctloc)
{  
	//Program Execute returning automotically. 2006-09-26
	var xx ;
	var obj=document.getElementById("mAutoReturn") ;
	if (obj) xx=obj.value;
	else xx='';
	var ret=cspRunServerMethod(xx,reqNo,ctloc)
	return ret;
}
function ReloadWinowAll()
{	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.pharetrequestitm" ;
	//location.href=lnk;
	//
var obj=parent.frames['x'].window.document.getElementById("Clear")
if (obj) obj.click();
	
}
function RetReqExists(dodis)
{
	//Description?G判断该医嘱是否已有未处理的申请单
	//lq 08-11-14
	var obj=document.getElementById("mRetReqExists") ;
	if (obj) {var encmeth=obj.value} else {var encmeth=''}
	var exists=cspRunServerMethod(encmeth,dodis)  ;
	if (exists!="") return true ;
	return false ;
}
function allowReturn(oedis,retreqqty)
	{//根据已发药和已退药情况决定是否允许此次的退药
	 //oedis : rowid of OE_Dispensing
	 //retreqqty : quantity of requiring returned
	 //lq 08-11-14
	
	var validQty=document.getElementById("mValidateReqQty");
	if (validQty) {var encmeth=validQty.value} else {var encmeth=''};
	var result=cspRunServerMethod(encmeth,'','',oedis,retreqqty)  ;
	
	 if (result==0)
	 	 {return false }
	 else
 		{return true };
	}
document.body.onload=BodyLoadHandler;
