// JavaScript Document
var SelectedRow = 0;
var preRowInd=0;
 //var obj=document.getElementById('itemType')
   //if(obj)obj.innerValue=""
function BodyLoadHandler(){ 
	var obj=document.getElementById('Add')
	if(obj) obj.onclick=Add_click;
	var obj=document.getElementById('Update')
	if(obj) obj.onclick=Update_click;
	var obj=document.getElementById('Delete')
	if(obj) obj.onclick=Delete_click;
	var obj=document.getElementById('Sch')
	if(obj) obj.onclick=Sch_click;
	var obj=document.getElementById("ctrType")
	if(obj)
	{ 
	  var objItem1=new Option(t['val:alert'],"A");
	  obj.options[obj.options.length]=objItem1;
	  var objItem2=new Option(t['val:forbidden'],"F");
	  obj.options[obj.options.length]=objItem2;
	  var objItem3=new Option("无控制","");
	  obj.options[obj.options.length]=objItem3;
	  obj.size=1;
	  obj.multiple=false;
	  obj.options[0].selected=true 
    }                 
}
function Sch_click(e)                                                        
{  
//20150313+dyl:因为里面东西不多，所以考虑查询功能目前暂时不用了
/*
 var obj=document.getElementById('itemType');
 if(obj)
 {
	 itemType=obj.innerValue;
	 }
 if(itemType==null)alert(t['03'])
 
 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCOPItemCheck&itemType="+itemType
 */
 
 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCOPItemCheck"
 window.location.href=lnk
}
function SelectRowHandler(e){
	var eSrc=window.event.srcElement;
	//var objtbl=document.getElementById('tDHCANCOPItemCheck');
	//var rows=objtbl.rows.length;
	//var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj1=document.getElementById('ID');
	var obj2=document.getElementById('itemDesc');
	var obj3=document.getElementById('itemCode');
	var obj4=document.getElementById('ctrType');
	var obj5=document.getElementById('itemType')
	obj5.disabled=true;
	
	var SelRowObj1=document.getElementById('tIdz'+selectrow);
	var SelRowObj2=document.getElementById('tItemDescz'+selectrow);
	var SelRowObj3=document.getElementById('tItemCodez'+selectrow);
	var SelRowObj4=document.getElementById('tCtrTypez'+selectrow);
	var SelRowObj5=document.getElementById('tItemTypez'+selectrow);
	var SelRowObj6=document.getElementById('tTypeCodez'+selectrow);
	if (preRowInd==selectrow){
		obj1.value="";
		obj2.value="";
		obj3.value="";
		obj4.selectedIndex=-1;
		obj5.value="";
		obj5.disabled=false;
   		preRowInd=0;
    }
	else
	{
    if (obj1) obj1.value=SelRowObj1.innerText;
	if (obj2) obj2.value=SelRowObj2.innerText;
	if (obj3) obj3.value=SelRowObj3.innerText;
	if (obj4) 
    {
    if(SelRowObj4.innerText==t['val:alert'])
    {obj4.selectedIndex=0}
    else if(SelRowObj4.innerText==t['val:forbidden'])
    {obj4.selectedIndex=1}
    else 
    {obj4.selectedIndex=2}
    }
    
	if(obj5)
	{obj5.value=SelRowObj5.innerText;
     obj5.innerValue=SelRowObj6.innerText;
     }
	preRowInd=selectrow;
   }
	return;
}   
function Add_click(e){
	var obj=document.getElementById('itemCode')
	if(obj) var itemCode=obj.value;
	else var itemCode=""
	if(itemCode==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('itemDesc')
	if(obj) 
    {
     var itemDesc=obj.value;
     }
	else var itemDesc=""
	if(itemDesc==""){
		alert(t['02']); 
		return;
		}
	var obj=document.getElementById('ctrType')
	if(obj) 
    {
      var ctrType=obj.value;
      //alert(ctrType)
    }
	else var ctrType=""
	var obj=document.getElementById('itemType')
	if(obj)
	{var itemType=obj.innerValue;
    }                                      
    if(itemType==null)
    {
      alert(t['03']);
      return;
    }
	var obj=document.getElementById('InsertItemCheck')
	if(obj)
	{   
		var encmeth=obj.value;
		var retStr=cspRunServerMethod(encmeth,itemCode,itemDesc,ctrType,itemType)
		if(retStr==0)
		{
			alert(t['alert:insertFail']);
			return
		}
		else
		{
			alert(t['succeed']);
			window.location.reload();
		} 
	}  
}
function Update_click(e){
	if(preRowInd<1)return;
	var obj=document.getElementById('ID')
	if(obj) var rowId=obj.value;
	else var rowId=""
	if(rowId=="")
	{
	 alert(t['04'])
	 return;
	}
	var obj=document.getElementById('itemCode')
	if(obj) var itemCode=obj.value;
	else var itemCode=""
	if(itemCode==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('itemDesc')
	if(obj) var itemDesc=obj.value;
	else var itemDesc=""
	if(itemDesc==""){
		alert(t['02']) 
		return;
		}
	var obj=document.getElementById('ctrType')
	if(obj) 
    {  var ctrType=obj.value; }
	else var ctrType=""
	var obj=document.getElementById('itemType')
	if(obj)
	{var itemType=obj.innerValue;
    }                                      
    if(itemType=="")
    {
      alert(t['03']);
      return;
    }
	var obj=document.getElementById('UpdateItemCheck')
	if(obj)
	{  
		var encmeth=obj.value;
		var retStr=cspRunServerMethod(encmeth,itemCode,itemDesc,ctrType,itemType,rowId)
		if(retStr==0)
		{
			alert(t['alert:updateFail']);
			return
		}
		
		else
		{   
			alert(t['succeed']);
			window.location.reload();
		} 
	}  
}
function Delete_click(e){
	if(preRowInd<1)return;
	var obj=document.getElementById('ID')
	if(obj) var rowId=obj.value;
	else var rowId=""
	if(rowId=="")
	{
	 alert(t['04'])
	 return;
	}
	var obj=document.getElementById('itemType')
	if(obj)
	{var itemType=obj.innerValue;
    }                                      
    if(itemType=="")
    {
      alert(t['03']);
      return;
    }
	var obj=document.getElementById('DeleteItemCheck')
	if(obj)
	{
		var encmeth=obj.value;
		var retStr=cspRunServerMethod(encmeth,itemType,rowId)
		if(retStr==1)
		{
			alert(t['succeed']);
			window.location.reload();
		}
	}
} 
function GetItemType(str)
{
  var tye=str.split("^")
  var obj=document.getElementById("itemType")
  if(obj)
  {
	  	obj.value=tye[1]
   		obj.innerValue=tye[0]
   		
  }
}
document.body.onload=BodyLoadHandler;
