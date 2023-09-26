var CurrentRow;
function BodyLoadHandler()
{
	
	obj=document.getElementById("Add") ;
    if (obj) obj.onclick=AddClick;
    
    obj=document.getElementById("Query") ;
    if (obj) obj.onclick=QueryClick;
    
    obj=document.getElementById("Update") ;
    if (obj) obj.onclick=UpdateClick;
    
    obj=document.getElementById("Delete") ;
    if (obj) obj.onclick=DeleteClick;
    
    var obj=document.getElementById("Desc"); 
	if (obj) 
	{	
		obj.onkeydown=popDesc;
	 	obj.onblur=DescCheck;
	} 
	
	
}
function DescCheck()
{
	var obj=document.getElementById("Desc");
	var obj2=document.getElementById("arcrowid");
	if (obj) 
	{if (obj.value=="") obj2.value="";	}
	
}

function popDesc()
{ 
	if (window.event.keyCode==13) 
	{  	
		if (event.preventDefault()){event.preventDefault()}
		window.event.keyCode=117;
		window.event.isLookup=true;
  	    Desc_lookuphandler(window.event);
	}
}

function DescLookupSelect(str)
{	
	var inci=str.split("^");
	var obj=document.getElementById("arcrowid");
	if (obj)
	{if (inci.length>0)   obj.value=inci[2] ;
		else  obj.value="" ;  
	}

}
function AddClick()
{
	var obj=document.getElementById("arcrowid"); 
	if (obj) 
	{
	    var arci=(trim(obj.value))
		if (arci!="")
		{
            var objRowid=document.getElementById("mRowid") ;
            var mrowid=objRowid.value;
            if (mrowid=="")
	        {
		        alert("��ѡ��ҩƷ���ƺ�������")
		        return;
	        }
	        var objqty=document.getElementById("addqty") 
	        var addqty=trim(objqty.value);
	     
			var obj=document.getElementById("mInsert") ;
			if (obj) {var encmeth=obj.value;} else {var encmeth='';}
			var ret=cspRunServerMethod(encmeth,arci,mrowid,addqty) ;
			
			
			if (ret<0)
			{
				alert("����ʧ��,������")
			}
			else
			{
				QueryClick();
			}

		} else{
			alert("����¼���շ�ҽ��!");
		}  
	} 
}

function QueryClick()
{
	var obj=document.getElementById("mRowid"); 
	if (obj)
	{
		var rowid=trim(obj.value);
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.ORDERLINKORD&mRowid="+rowid;
        parent.frames['DHCST.PIVA.ORDERLINKORD'].location.href=lnk;	
	
	}
	

}

function UpdateClick()
{
	if (typeof(CurrentRow)=='undefined') 
	{
		alert("����ѡ��Ԥ�޸ĵļ�¼");
		return;
	}
	
	var obj=document.getElementById("Trowid"+"z"+CurrentRow) 
	var tarrowid=obj.innerText;
	var obj=document.getElementById("Tqty"+"z"+CurrentRow) 
	var tqty=obj.innerText;
	var objarci=document.getElementById("arcrowid") 
	var arci=trim(objarci.value);
	var objqty=document.getElementById("addqty") 
	var addqty=trim(objqty.value);
	if ((arci=="")&&(tqty==addqty))
	{
		alert("�շ�ҽ�����ƺ�����û�з����仯!")
		return;
	}	
	
	var obj=document.getElementById("mUpdate") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,tarrowid,arci,addqty) ;
	if (ret<0)
			{
				alert("����ʧ��,������")
			}
	else
			{
				QueryClick();
			}



}

function DeleteClick()
{
	
	if (typeof(CurrentRow)=='undefined') 
	{
		alert("����ѡ��Ԥɾ���ļ�¼");
		return;
	}

	var objdesc=document.getElementById("Tdesc"+"z"+CurrentRow);
	if (confirm("ȷ��Ҫɾ��< "+objdesc.innerText+" >��¼��?")==false)  return ; 
	
	var obj=document.getElementById("Trowid"+"z"+CurrentRow) 
	var tarrowid=obj.innerText;
	
	var obj=document.getElementById("mDelete") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,tarrowid) ;
	if (ret<0)
			{
				alert("ɾ��ʧ��,������")
			}
	else
			{
				QueryClick();
			}

}

function SelectRowHandler()
 {
	 var row=selectedRow(window);
	 CurrentRow=row;
     SetValue();
 }
function SetValue()
{
	 var obj=document.getElementById("Tdesc"+"z"+CurrentRow)
	 var desc=obj.innerText;
	 var objDesc=document.getElementById("Desc")
	 objDesc.value=desc;
	 var obj=document.getElementById("Tqty"+"z"+CurrentRow)
	 var qty=obj.innerText;
	 var objqty=document.getElementById("addqty")
	 objqty.value=qty;
}
document.body.onload=BodyLoadHandler;