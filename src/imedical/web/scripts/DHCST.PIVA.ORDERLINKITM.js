var CurrentRow;
function BodyLoadHandler()
{
	
	obj=document.getElementById("Add") ;
    if (obj) obj.onclick=AddClick;
    
    obj=document.getElementById("Delete") ;
    if (obj) obj.onclick=DeleteClick;
    
    obj=document.getElementById("Update") ;
    if (obj) obj.onclick=UpdateClick;
    
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
	var obj2=document.getElementById("incirowid");
	if (obj) 
	{if (obj.value=="") obj2.value="";	}
	
}

function popDesc()
{ 
	if (window.event.keyCode==13) 
	{  	
		if (event.preventDefault()){event.preventDefault()} //yunhaibao20160201,��������Ļس�������keydown�¼�	
		window.event.keyCode=117;
		window.event.isLookup=true;
  	    Desc_lookuphandler(window.event);
	}
}

function DescLookupSelect(str)
{	
	var inci=str.split("^");
	var obj=document.getElementById("incirowid");
	if (obj)
	{if (inci.length>0)   obj.value=inci[2] ;
		else  obj.value="" ;  
	}

}
function AddClick()
{
	var obj=document.getElementById("incirowid"); 
	if (obj) 
	{	
	    var inci=obj.value;
		if (inci!="")
		{
            var objRowid=document.getElementById("mRowid") ;
            mrowid=objRowid.value;
            if (mrowid=="")
	        {
		        alert("��ѡ���շ�������������")
		        return;
	        }
			var obj=document.getElementById("mInsert") ;
			if (obj) {var encmeth=obj.value;} else {var encmeth='';}
			var ret=cspRunServerMethod(encmeth,inci,mrowid) ;
			
			if (ret<0)
			{
				alert("����ʧ��,������")
			}
			else
			{
				QueryClick();
			}

		}else{
			alert("����¼��ҩƷ����!");
		}   
	} 
}

function QueryClick()
{
	var obj=document.getElementById("mRowid"); 
	if (obj)
	{
		var rowid=obj.value;
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.ORDERLINKITM&mRowid="+rowid;
        parent.frames['DHCST.PIVA.ORDERLINKITM'].location.href=lnk;	
	
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
	var objinci=document.getElementById("incirowid") 
	var inci=objinci.value;
	if (inci=="")
	{
		alert("ҩƷ����û�з����仯!")
		return;
	}	
	var obj=document.getElementById("mUpdate") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,tarrowid,inci) ;
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
	
	var obj=document.getElementById("Trowid"+"z"+CurrentRow); 
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

	 SetDesc();
	
 
 }
 function SetDesc()
 {
	 var obj=document.getElementById("Tdesc"+"z"+CurrentRow)
	 var desc=obj.innerText;
	 var objDesc=document.getElementById("Desc")
	 objDesc.value=desc; 
 }
 

 
document.body.onload=BodyLoadHandler;