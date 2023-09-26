function BodyLoadHandler()
{  
	var schobj=document.getElementById("butcancel");
    if (schobj) {schobj.onclick=Cancel_click;}
}
function Cancel_click()
{		
	    var selrow=document.getElementById("SelRow");
	    if (selrow.value!="")
	    {
		   var wardId=document.getElementById("wardid").value;
           var pDateTimeStr=document.getElementById("DateTimez"+selrow.value).innerText;
           var UndoPrinted=document.getElementById("UndoPrinted").value; 
           var querytyp=document.getElementById("RpTypez"+selrow.value).innerText;
          // alert (wardId+" "+pDateTimeStr+" "+UndoPrinted+"^"+querytyp+"--");
           var ResStr=cspRunServerMethod(UndoPrinted,pDateTimeStr,wardId,querytyp);
            if (ResStr!=0)  {alert("data access err"); return false};
		    if (ResStr==0) {alert("cancel");parent.parent.frames['RPRight'].location.reload();}
		    else alert("not cancel");
		    window.location.reload();
       } 

}
 function SelectRowHandler()
 {
    //pDateTimeStr As %String, wardId 
    var selrow=document.getElementById("SelRow"); 
    selrow.value=DHCWeb_GetRowIdx(window);
    var wardId=document.getElementById("wardid").value;
    var pDateTimeStr=document.getElementById("DateTimez"+selrow.value).innerText;
    var str=pDateTimeStr.split("|");
    var querytyp=document.getElementById("RpTypez"+selrow.value).innerText;
    var RpDes=document.getElementById("FormDesz"+selrow.value).innerText;
    var pDateStr=str[0];
    var pTimeStr=str[1];
    RpDes=escape(RpDes);
    
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNursePrintedDtl&pDateStr="+pDateStr+"&pTimeStr="+pTimeStr+"&wardId="+wardId+"&SelRow="+selrow.value+"&querytyp="+querytyp+"&RpDes="+RpDes;
    parent.parent.frames['RPRight'].location.href=lnk;
 }
  function SelectedSet(selObj,indStr,delim) 
    {
	    var tmpList=new Array();
	    for(i=0;i<selObj.options.length;i++)
	    {
		    selObj.options[i].selected=false;
	    }
	    tmpList=indStr.split(delim)
	    for(j=0;j<tmpList.length;j++)
	    {
		    for(i=0;i<selObj.options.length;i++)
		    {  // if (selObj.name=="displayall")
		        //{
			      //alert(selObj.options[i].value+"|"+tmpList[j]); 
			    //}
		        if (selObj.options[i].value==tmpList[j])
		        {
			        selObj.options[i].selected=true;break
		        }
		    }
	    }
	    
    }
function del_click()  
{//	    resStr=#server(web.udhcclnurseexec.TypeDel(form1.txtCode.value))#;

}
function savecatdr(str)
{
	var obj=document.getElementById('catid');
	var tem=str.split("^");
	obj.value=tem[1];
}
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}
function getwardid(str)
{
	var obj=document.getElementById('wardid');
	var tem=str.split("^");
	obj.value=tem[1];
}
function savetyp(str)
{
	var obj=document.getElementById('vartyp');
	var tem=str.split("^");
	obj.value=tem[1];
}

document.body.onload = BodyLoadHandler;