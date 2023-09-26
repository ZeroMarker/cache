// dhcpha.reservequery.js
var CurrentRow;

function BodyLoadHandler()
{
	var obj=document.getElementById("Ward"); 
	if (obj) 
	{obj.onkeydown=popWard;
	 obj.onblur=wardCheck;
	} 
	
	var obj=document.getElementById("DispLoc"); 
	if (obj) 
	{obj.onkeydown=popDispLoc;
	 obj.onblur=DispLocCheck;
	}
	
	obj=document.getElementById("Clear") ;
    if (obj) obj.onclick=ClearClick;
    
    obj=document.getElementById("ClearWard") ;
    if (obj) obj.onclick=ClearWardClick;
    
    obj=document.getElementById("ClearAll") ;
    if (obj) obj.onclick=ClearAllClick;
    
	obj=document.getElementById("Find") ;
    if (obj) obj.onclick=findclick;
}

function popWard()     
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  Ward_lookuphandler();
		}
}

function popDispLoc()
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  DispLoc_lookuphandler();
		}
}

function wardCheck()
{
	var obj=document.getElementById("Ward");
	var obj2=document.getElementById("wardrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}

}

function DispLocLookUpSelect(str)
{ 
	var loc=str.split("^");
	var obj=document.getElementById("displocrowid");
	if (obj)
	{if (loc.length>0)   obj.value=loc[1] ;
		else	obj.value="" ;  
	}
}

function WardLookUpSelect(str)
{
	var ward=str.split("^");
	var obj=document.getElementById("wardrowid");
	if (obj)
	{if (ward.length>0)   obj.value=ward[1] ;
		else  obj.value="" ;  
	 }	
}

function DispLocCheck()
{
	
	var obj=document.getElementById("DispLoc");
	var obj2=document.getElementById("displocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
}

function ClearClick()
{
	var wardrowid=""
	var obj=document.getElementById("displocrowid");
    var displocrowid=obj.value;
	if (typeof(CurrentRow)=='undefined') 
	{
		alert("����ѡ��һ����¼��,������...")  
		return ;
	}
	else
	{

		var obj=document.getElementById("Tward"+"z"+CurrentRow) 
	    var warddesc=obj.innerText;
	    var obj=document.getElementById("Tinci"+"z"+CurrentRow) 
	    var incidesc=obj.innerText;
	    var obj=document.getElementById("Tqty"+"z"+CurrentRow) 
	    var inciqty=obj.innerText;
	    if (inciqty==0){
		    alert("�Ѿ�Ϊ�㣬�����ظ����㣡")
		    return;
	    }
	    if (confirm("ȷ��Ҫ���< "+warddesc+"  "+incidesc+" >��?")==false)  return ;
	    var obj=document.getElementById("Twardrowid"+"z"+CurrentRow)
	    var wardrowid=obj.value;
	    var obj=document.getElementById("Tincirowid"+"z"+CurrentRow) 
	    var inci=obj.value;
	    var obj=document.getElementById("Tpres"+"z"+CurrentRow) 
	    var pres=obj.value;
	    var user=session['LOGON.USERID'] ;
	}
	var obj=document.getElementById("mDelete") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,displocrowid,wardrowid,inci,user,pres) ;
	
	if (ret<0)
			{
				alert("����ʧ��,������")
			}
	if (ret==0)
			{
				alert("����ɹ�")
				findclick();
			}
	
	
}

function ClearWard()
{
		var obj=document.getElementById("DispLoc");
	var obj2=document.getElementById("displocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
}
///�����ѡ����
function ClearWardClick()
{
	var wardrowid=""
	var obj=document.getElementById("displocrowid");
    var displocrowid=obj.value;
	if (typeof(CurrentRow)=='undefined') 
	{
		alert("����ѡ������¼��,������...");  return ;
	}
	else
	{
		var obj=document.getElementById("Tward"+"z"+CurrentRow) 
	    var warddesc=obj.innerText;

	    if (confirm("ȷ��Ҫ���< "+warddesc +">��?")==false)  return ;
	    var obj=document.getElementById("Twardrowid"+"z"+CurrentRow)
	    var wardrowid=obj.value;
 
	    var user=session['LOGON.USERID'] ;
	}
	var obj=document.getElementById("mDeleteWard") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,displocrowid,wardrowid,user) ;
	
	if (ret<0)
			{
				alert("����ʧ��,������")
			}
	if (ret==0)
			{
				alert("����ɹ�")
				findclick();
			}
	
}

///������в���
function ClearAllClick()
{
	var wardrowid=""
	var obj=document.getElementById("displocrowid");
    var displocrowid=obj.value;
    
    var objtbl=document.getElementById("t"+"dhcpha_reservequery");
		if (objtbl)
		{
			var cnt=objtbl.rows.length -1
			if (!(cnt>0)) return;
		}
		 

	if (confirm("ȷ��������в�����?")==false)  return ;
	
	var user=session['LOGON.USERID'] ;

	var obj=document.getElementById("mDeleteAll") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,displocrowid,user) ;
	
	if (ret<0)
			{
				alert("����ʧ��,������")
			}
	if (ret==0)
			{
				alert("����ɹ�")
				findclick();
			}
	
}


function findclick()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.reservequeryitm&pres=";
	parent.frames['dhcpha.reservequeryitm'].location.href=lnk;
	Find_click();
}

function SelectRowHandler()
 {
	 
	 var row=selectedRow(window);
	 CurrentRow=row;
	 var pres="";
	 var obj=document.getElementById("Tpres"+"z"+CurrentRow)
	 if (obj) var pres=obj.value;
	 if (pres=="") {return;}
	 var obj=document.getElementById("startdate")
	 if (obj) var startdate=obj.value;
	 var obj=document.getElementById("enddate")
	 if (obj) var enddate=obj.value;
	 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.reservequeryitm&pres="+pres+"&startdate="+startdate+"&enddate="+enddate ;
	 parent.frames['dhcpha.reservequeryitm'].location.href=lnk;


 }
 

document.body.onload=BodyLoadHandler;