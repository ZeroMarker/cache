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
		        alert("先选中药品名称后再重试")
		        return;
	        }
	        var objqty=document.getElementById("addqty") 
	        var addqty=trim(objqty.value);
	     
			var obj=document.getElementById("mInsert") ;
			if (obj) {var encmeth=obj.value;} else {var encmeth='';}
			var ret=cspRunServerMethod(encmeth,arci,mrowid,addqty) ;
			
			
			if (ret<0)
			{
				alert("保存失败,请重试")
			}
			else
			{
				QueryClick();
			}

		} else{
			alert("请先录入收费医嘱!");
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
		alert("请先选中预修改的记录");
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
		alert("收费医嘱名称和数量没有发生变化!")
		return;
	}	
	
	var obj=document.getElementById("mUpdate") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,tarrowid,arci,addqty) ;
	if (ret<0)
			{
				alert("保存失败,请重试")
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
		alert("请先选中预删除的记录");
		return;
	}

	var objdesc=document.getElementById("Tdesc"+"z"+CurrentRow);
	if (confirm("确认要删除< "+objdesc.innerText+" >记录吗?")==false)  return ; 
	
	var obj=document.getElementById("Trowid"+"z"+CurrentRow) 
	var tarrowid=obj.innerText;
	
	var obj=document.getElementById("mDelete") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,tarrowid) ;
	if (ret<0)
			{
				alert("删除失败,请重试")
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