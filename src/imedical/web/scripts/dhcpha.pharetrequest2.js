
function BodyLoadHandler()
{
 	var obj;
 	obj=document.getElementById("Clear") ;
 	if (obj) obj.onclick=ClearClick; 
 	obj=document.getElementById("Exit") ;
 	if (obj) obj.onclick=ExitClick;
 	obj=document.getElementById("SeekDisp") ;
 	if (obj) obj.onclick=SeekDispClick;
	obj=document.getElementById("Ok") ;
 	if (obj) obj.onclick=OKClick; 
	obj=document.getElementById("AddToPhaReturn") ;
 	if (obj) obj.onclick=AddClick;  

 	var obj=document.getElementById("DispLoc"); 
 	if (obj) 
 	{
	 	obj.onkeydown=popDispLoc;
  		obj.onblur=DispLocCheck;
 	} 
	
	var obj=document.getElementById("Ward");
	if (obj) 
	{
		obj.onkeydown=popWard;
	 	obj.onblur=wardCheck;
	} 
	
	var obj=document.getElementById("Alias"); 
	if (obj) 
	{
		obj.onkeydown=popAlias;
	 	obj.onblur=AliasCheck;
	}
	
	obj=document.getElementById("BodyLoaded");
	if (obj.value!=1)
	{
		//GetDefLoc();
		setDefaultDate();
	}
	
	setBodyLoaded(); 
	
}

function DispLocCheck()
{
	
	var obj=document.getElementById("DispLoc");
	var obj2=document.getElementById("displocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
}

function popDispLoc()
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  DispLoc_lookuphandler();
	}
}//2006-05-26

function ClearClick()
{
	ClearField("Ward") ;
	ClearField("Alias") ;
	ClearField("StartDate") ;
	ClearField("EndDate") ;
	ClearField("WardRowID") ;
	ClearField("InciRowID") ;
	//ClearField("displocrowid") ;
	//ClearField("DispLoc") ;	
	
	//var objtbl=document.getElementById("t"+"dhcpha_pharetrequest") ;
	//if (objtbl) DelAllRows(objtbl) ;
	
	parent.frames['x'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.pharetrequest2"
	parent.frames['y'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.pharetrequestitm"
	
}

function ClearField(ss)
{	var obj; 
	obj = document.getElementById(ss) ;
	if (obj) obj.value="" ;
}

function ExitClick()
	{
		history.back();
	}
	
function SeekDispClick()
{
	if (CheckConPriorSeekDisp()==false) return ;

	SeekDisp_click();
}
		
function CheckConPriorSeekDisp()
{
	// check the query condition prior finding dispen
	var obj=document.getElementById("DispLocRowID");
	if (obj) 
	{
		if (obj.value=="") 
		{
			alert(t['NO_RETLOC'] ) ;
			return false;  
		} 
	}
	var obj=document.getElementById("WardRowID");
	if (obj)
	{
		if (obj.value=="" ) 
		{
	  		alert(t['NO_WARD']);
	  		return false;	  
	  	}	  
	}
	var obj=document.getElementById("InciRowID");
	if (obj)
	{
		if (obj.value=="" ) 
		{
	  		alert(t['NO_DRUG']);
	  		return false;	  
	  	}	  
	}
	
	var obj=document.getElementById("StartDate");
	if (obj)
	{
		if (obj.value=="")
		{
			alert(t['NO_STARTDATE']);
			alert("ss");
			return false;
		}
	}
	
	var obj=document.getElementById("EndDate");
	if (obj)
	{
		if (obj.value=="")
		{
			alsert(t['NO_ENDDATE']);
			return false;
		}
	}
}

function OKClick()
{
	//update the return qty 
 	//get return qty
	if (ValidateReqQty()==false) return ;
	
	var obj=document.getElementById("RetReqQty") ;
	var retqty=obj.value ;
	var obj=document.getElementById("CurrentRow") ;
	var row=obj.value ;

	var obj=document.getElementById("TReqQtyz"+row) ;
	if (obj)
	{
		obj.innerText=retqty;			//update the return qty .
	}   
}

function ValidateReqQty()
{
	//check the retqty's validation
	var obj=document.getElementById("RetReqQty")
	if (obj) 
	{
		var reqqty=obj.value ;
		if (reqqty<=0)
		{
			alert(t['INVALID_QTY']) ;
		 	return false;		
		}		
	}
	
	var obj=document.getElementById("CurrentRow") ;
	if (obj)
	{
		var row=obj.value;
		if (row<1)
		{
			alert(t['NO_ROW_SELECTED'])	;
			return false ;
		}
		var objitem=document.getElementById("Toedisz"+row) ;
		if (objitem)
		{
			//alert(reqqty) ;
			var oedis=objitem.value;
			//alert(oedis)
			if (allowReturn(oedis,reqqty)==false )
			{
				alert(t['RETQTY_TOOLARGE']) ;
			 	return false;				
			}
		}
		else 
		 	{ 	
		 		alert(t['NO_OBJECT'])
			 	return false;
		 	}
	}
	else
	{
		alert(t['NO_OBJECT'])	
		return false ;
	}
	return true;	
}

function DHCWeb_GetRowIdx(wobj)
{
	var eSrc=wobj.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	return 	selectrow
}

function DispLocLookUpSelect(str)
{
	var ss=str.split("^") ;
  	if ( ss.length>0) 
  	{ 
  		var obj=document.getElementById("displocrowid") ;
   		if (obj) obj.value=ss[1] ; // rowid of the disp loc
   }
}

function AddClick()
{	
	var obj1=document.getElementById("t"+"dhcpha_pharetrequest2") ;
    if (obj1)
    {
	    var rowcount=getRowcount(obj1) ;
    }
	if (rowcount<1) 
	{
		alert(t['NO_ANYROWS']) ;
		return ;	
	}
	for (var i=1;i<=rowcount;i++)
	{
		var obj=document.getElementById("TReqQtyz"+i);
		if ((obj)&&(obj.innerText>0)) 
		{
			var obj=document.getElementById("Toedisz"+i);
			if (obj) 
			{
				oedis=obj.value;
			}
			//if (allowAdd(oedis)==false) break ;
			if (allowAdd(oedis)==true) 
			{
				if (RetReqExists(oedis)==true)
				{  
					var msg=t['RETREQ_EXISTS2'] + " RowNo : " + i ;
					alert(msg) ;
					break ;
				}
				AddRowToRetReq(i);
			} 
		}
	}
}

function AddRowToRetReq(sourceRowNo)
{
 	
	//get the field value of the row
	var obj=document.getElementById("TRegNo"+"z"+ sourceRowNo) ;
	if (obj) var regno=obj.innerText;
	var obj=document.getElementById("TName"+"z"+sourceRowNo) ;
	if (obj)  var name=obj.innerText;
	var obj=document.getElementById("TPrescNo"+"z"+ sourceRowNo) ;
	if (obj)  var prescno=obj.innerText;
	var obj=document.getElementById("TDesc"+"z"+ sourceRowNo) ;
	if (obj)  var desc=obj.innerText;
	var obj=document.getElementById("TDispQty"+"z"+ sourceRowNo) ;
	if (obj)  var dispqty=obj.innerText;
	var obj=document.getElementById("TReqQty"+"z"+ sourceRowNo) ;
	if (obj)  var reqqty=obj.innerText;
	var obj=document.getElementById("TUom"+"z"+ sourceRowNo) ;
	if (obj)  var uom=obj.innerText;
	var obj=document.getElementById("TStatus"+"z"+ sourceRowNo) ;
	if (obj)  var status=obj.innerText;
	var obj=document.getElementById("Toedis"+"z"+ sourceRowNo) ;
	if (obj)  var oedis=obj.value;
 	//		 	
 	//
 	//alert(prescno);
 	//
  	var objtbl=parent.frames['y'].document.getElementById("tdhcpha_pharetrequestitm") ;
 
 	if (objtbl)  tAddRow(objtbl) ;
 	var cnt=getRowcount(objtbl);
 	var r=cnt-1;
 	//
	var docu=parent.frames['y'].document;
	if (docu) {
 		var obj=docu.getElementById("TRegNo"+"z"+ r) ;
		if (obj)  obj.innerText=regno ;		
		var obj=docu.getElementById("TPrescNo"+"z"+ r) ;
		if (obj) obj.innerText=prescno ;
		var obj=docu.getElementById("TDesc"+"z"+ r) ;
		if (obj) obj.innerText=desc ;
		var obj=docu.getElementById("TUom"+"z"+ r) ;
		if (obj) obj.innerText=uom ;
		var obj=docu.getElementById("TDispQty"+"z"+ r) ;
		if (obj) obj.innerText=dispqty ;
		var obj=docu.getElementById("TReqQty"+"z"+ r) ;
		if (obj) obj.innerText=reqqty ;
		var obj=docu.getElementById("TSalePrice"+"z"+ r) ;
		var sp=getSalePrice(desc,uom)  //the sale price
		if (obj) obj.innerText=sp  ;
		var spamt=sp*reqqty   ;
		var obj=docu.getElementById("TSalePriceAmt"+"z"+ r) ;
		if (obj) obj.innerText=spamt ;
		//
		var adm=getAdmByDsp(oedis) ;
		//
		var ss=adm.split("^") ;
		var recdeptdr=ss[0];
		var admdr=ss[1];
		var admlocdr=ss[2];
		var warddr=ss[3];
		var beddr=ss[4];
		var doctorDr=ss[5];
		//
		var obj=docu.getElementById("TDoctor"+"z"+ r) ;
		if (obj) obj.innerText=doctorDr ;
		var obj=docu.getElementById("TRecLocDr"+"z"+ r) ;
		if (obj) obj.innerText=recdeptdr ;
		var obj=docu.getElementById("TWardDr"+"z"+ r) ;
		if (obj) obj.innerText=warddr ;
		var obj=docu.getElementById("TBedDr"+"z"+ r) ;
		if (obj) obj.innerText=beddr ;
		var obj=docu.getElementById("TDspDr"+"z"+ r) ;
		if (obj) obj.innerText=oedis ;
		var obj=docu.getElementById("TAdmLocDR"+"z"+ r) ;
		if (obj) obj.innerText=admlocdr ;
		var obj=docu.getElementById("TAdmdr"+"z"+ r) ;
		if (obj) obj.innerText=admdr ;	
		}
	    //clear the last row
	  //  var cnt=getRowcount(objtbl);
}

function SelectRowHandler() 
{	
	var row=DHCWeb_GetRowIdx(window);
	var obj=document.getElementById("currentRow") ;
	if (obj) obj.value=row
}

function getSalePrice(desc,uomdesc)
{
	var getsp=document.getElementById("mGetItmSp");
	if (getsp) 
	{
		var encmeth=getsp.value
	} 
	else 
	{
		var encmeth='';
	}
	var sp=cspRunServerMethod(encmeth,'','',desc,uomdesc)  ;
	return sp;
}

function allowReturn(oedis,retreqqty)
{
	//根据已发药和已退药情况决定是否允许此次的退药
	//oedis : rowid of OE_Dispensing
	//retreqqty : quantity of requiring returned
	var validQty=document.getElementById("mValidateReqQty");
	if (validQty) 
	{
		var encmeth=validQty.value;
	} 
	else 
	{
		var encmeth='';
	}
	var result=cspRunServerMethod(encmeth,'','',oedis,retreqqty)  ;
	
	if (result==0)
	{
		return false; 
	}
	else
 	{
	 	return true;
	}
	
}

function allowAdd(oedis)
{  
	//if the oedis has already existed in the returning list
	var docu=parent.frames['y'].document;
	if (docu)
	{
		var objtbl=docu.getElementById("t"+"dhcpha_pharetrequestitm");
		if (objtbl)
		{
			rowcount=getRowcount(objtbl);
		}
		else 
		{
			alert(t['NO_OBJECT']) ;
			return false ; 
		}
		for (var i=1;i<=rowcount;i++)
		{
			var obj=docu.getElementById("TDspDrz"+i);
			if (obj) 
			{
				dsp=obj.value ;
				if (oedis==dsp)
				{	//alert(t['ADDED']);
					return false ;}
				}
			else
			{
				alert(t['NO_OBJECT']) ;
				return false;	 
			}
		}
	}
	else
	{
		alert(t['NO_OBJECT']) ;
		return false;		
	}
	return true ;
}

function RetReqExists(oedis)
{
	var obj=document.getElementById("mRetReqExists") ;
	if (obj) 
	{
		var encmeth=obj.value
	} 
	else 
	{
		var encmeth=''
	}
	var exists=cspRunServerMethod(encmeth,'','',oedis)  ;
	if (exists!="") return true ;
	return false ;
}

function getAdmByDsp(oedis)
{
	var getadm=document.getElementById("mGetAdmByDsp");
	if (getadm) 
	{
		var encmeth=getadm.value
	} 
	else 
	{
		var encmeth='';
	}
	var adm=cspRunServerMethod(encmeth,'','',oedis)  ;
	return adm;
}

function WardLookUpSelect(str)
{ 	
	var ward=str.split("^");
  	var obj=document.getElementById("WardRowID");
  	if (obj)
  	{		
  		if (ward.length>0)   
  			obj.value=ward[1] ;
    	else
       		obj.value="" ;  
  	}
}

function AliasLookupSelect(str)
{	
	var inci=str.split("^");
	var obj=document.getElementById("InciRowID");
	if (obj)
	{
		if (inci.length>0)   
			obj.value=inci[2] ;
		else  
			obj.value="" ;  
	}

}

function popWard()     
{ 
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	  	Ward_lookuphandler();
	}
}

function wardCheck()
{
	var obj=document.getElementById("Ward");
	var obj2=document.getElementById("WardRowID");
	if (obj) 
	{
		if (obj.value=="") 
		{
			obj2.value="";
		}
	}

}

function AliasCheck()
{
	var obj=document.getElementById("Alias");
	var obj2=document.getElementById("InciRowID");
	if (obj) 
	{
		if (obj.value=="") 
		{
			obj2.value="";
		}		
	}
	
}

function popAlias()
{ 
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	  	Alias_lookuphandler();
	}
}

function GetDefLoc()
{	
	var objBodyLoaded=document.getElementById("BodyLoaded") ;
	
	if (objBodyLoaded)
	{
		if (objBodyLoaded.value!=1)
		{
			var userid=session['LOGON.USERID'] ;
			var obj=document.getElementById("mGetDefaultLoc") ;
			if (obj) 
			{
				var encmeth=obj.value;
			}
			else 
			{
				var encmeth='';
			}
			
			var ss=cspRunServerMethod(encmeth,'setDefLoc','',userid) ;
			objBodyLoaded.value=1;
		}
	}
}

function setDefLoc(value)
{
	var defloc=value.split("^");
	if (defloc.length>0)
	{
		var locdr=defloc[0] ;
		var locdesc=defloc[1] ;
		if (locdr=="") return ;
	}
	var obj=document.getElementById("DispLoc") ;
	if (obj) obj.value=locdesc
	var obj=document.getElementById("DispLocRowID") ;
	if (obj) obj.value=locdr
	
}

function setDefaultDate()
{	
	var t=today();
	var obj=document.getElementById("StartDate") ;
	if (obj) obj.value=t;
	var obj=document.getElementById("EndDate") ;
	if (obj) obj.value=t;
}

function setBodyLoaded()
{
	var obj=document.getElementById("BodyLoaded") ;
	if (obj) obj.value=1;
}
			
document.body.onload=BodyLoadHandler;
