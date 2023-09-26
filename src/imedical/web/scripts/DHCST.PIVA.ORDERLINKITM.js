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
		if (event.preventDefault()){event.preventDefault()} //yunhaibao20160201,弹出界面的回车需屏蔽keydown事件	
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
		        alert("先选中收费描述后再重试")
		        return;
	        }
			var obj=document.getElementById("mInsert") ;
			if (obj) {var encmeth=obj.value;} else {var encmeth='';}
			var ret=cspRunServerMethod(encmeth,inci,mrowid) ;
			
			if (ret<0)
			{
				alert("保存失败,请重试")
			}
			else
			{
				QueryClick();
			}

		}else{
			alert("请先录入药品名称!");
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
		alert("请先选中预修改的记录");
		return;
	}
	
	var obj=document.getElementById("Trowid"+"z"+CurrentRow) 
	var tarrowid=obj.innerText;
	var objinci=document.getElementById("incirowid") 
	var inci=objinci.value;
	if (inci=="")
	{
		alert("药品名称没有发生变化!")
		return;
	}	
	var obj=document.getElementById("mUpdate") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,tarrowid,inci) ;
	if (ret<0)
			{
				alert("更新失败,请重试")
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
	
	var obj=document.getElementById("Trowid"+"z"+CurrentRow); 
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