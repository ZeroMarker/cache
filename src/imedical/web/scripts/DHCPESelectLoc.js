var CurRow=0
function BodyLoadHandler() 
{
	var obj
    obj=document.getElementById("Delete")
	if (obj) {obj.onclick=Delete_click};
	obj=document.getElementById("Close")
	if (obj) {obj.onclick=Close_click};
	obj=document.getElementById("Update")
	if (obj) {obj.onclick=Update_click};
}

function Close_click()
{
	window.opener.location.reload();
	window.self.close();
	
} 
function trim(s) 
{
	if (""==s) {return ""}
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/)
	return (m == null) ? "" : m[0]
}	

 function LocInfo(value) 
{
    if (value=="") return;
    var  ilocid="",irowid=""
    var tmp=value.split("^")   
     var obj=document.getElementById("LocID")
    if(obj){obj.value=tmp[1]}                         
    //ilocid=tmp[1]
    //var obj=document.getElementById("RowId")
    //if(obj){irowid=obj.value}
   // var Instring=trim(ilocid)+"^"+trim(irowid)
    //var Ins=document.getElementById("AddBox")	
    //if (Ins) 
   // {var encmeth=Ins.value} 
    //else 
    //{var encmeth=""} 
   //// var flag=cspRunServerMethod(encmeth,Instring) 
   // if (flag==0)
   // {location.reload()}
}  

function Close_click()
{
	window.opener.location.reload();
	window.self.close();
	
}   
function Delete_click()
{   
    var ilocid="",iloc="",irowid=""
	if (CurRow==0) 
	{
		alert("请先选择要删除的记录");
		return;
	}
	var obj=document.getElementById("TLocIdz"+CurRow)
	if (obj) var ilocid=obj.value;
	
	var obj=document.getElementById("TRowIdz"+CurRow)
	if (obj) var irowid=obj.value;

    var obj=document.getElementById("TSelectLocz"+CurRow)
	if (obj) var iloc=obj.innerText;
		
	var string=trim(ilocid)
	                     +"^"+trim(iloc)
                         +"^"+trim(irowid)
    var encmeth="";
	var encmethobj=document.getElementById("DeleteBox")
	if (encmethobj) var encmeth=encmethobj.value
	else encmeth="";
	var flag=cspRunServerMethod(encmeth,string)	
	if (flag==0)
	{
		window.location.reload()
	}
}
		
function SelectRowHandler()	
{	
    var SelRowObj;
    var obj;
	var eSrc = window.event.srcElement;	
	var rowobj=getRow(eSrc);
	var Row=rowobj.rowIndex;
	if (Row==CurRow)
	{CurRow=0}
	else
	{CurRow=Row}
	SelRowObj=document.getElementById('TRowId'+'z'+CurRow);
	obj=document.getElementById("OrderLocID");
	obj.value=SelRowObj.value;
	SelRowObj=document.getElementById('TLocId'+'z'+CurRow);
	obj=document.getElementById("LocID");
	obj.value=SelRowObj.value;
	SelRowObj=document.getElementById('TSelectLoc'+'z'+CurRow);
	obj=document.getElementById("AddLoc");
	obj.value=SelRowObj.innerText;
	//SelRowObj=document.getElementById('TNoPrint'+'z'+CurRow);
	//obj=document.getElementById("NoPrint");
	//alert(SelRowObj.checked)
	//obj.checked=SelRowObj.checked;
	FromTableToItem("NoPrint","TNoPrint",CurRow);
	//FromTableToItem("NoPrint","OD_NoPrint",selectrow); 
	
}
function Update_click()
{   
    
    var  ilocid="",irowid="",iNoPrint="",iOrderLocID=""
    var obj=document.getElementById("RowId")
    if(obj){irowid=obj.value}
    if(irowid=="")
    {
	    alert("请先选择医嘱");
	    return false;
    }	
	
     var obj=document.getElementById("LocID")
    if(obj){ilocid=obj.value}	
    
    if(ilocid=="")
    {
	    alert("科室不能为空");
	    return false;
    }

    var obj=document.getElementById("OrderLocID")   //DHC_PE_StationOrderLoc
    if(obj){iOrderLocID=obj.value}
    	
    obj=document.getElementById("NoPrint");
	if (obj) {
		if (true==obj.checked){iNoPrint="Y"; }
		else{ iNoPrint="N"; }	
		}  

    var Instring=trim(ilocid)+"^"+trim(irowid)+"^"+trim(iNoPrint)+"^"+trim(iOrderLocID)
    var Ins=document.getElementById("AddBox")	
    if (Ins) 
    {var encmeth=Ins.value} 
    else 
    {var encmeth=""} 
    var flag=cspRunServerMethod(encmeth,Instring) 
    if (flag==0)
    {location.reload()}
}	
function FromTableToItem(Dobj,Sobj,selectrow) {

  
	var SelRowObj;
	var obj;
	var LabelValue="";

	SelRowObj=document.getElementById(Sobj+'z'+selectrow);
	if (!(SelRowObj)) { return null; }
	
	LabelValue=SelRowObj.tagName.toUpperCase();
   	obj=document.getElementById(Dobj);
   	if ("LABEL"==LabelValue) {
		
		obj.value=trim(SelRowObj.innerText);
		return obj;
	}
	
	if ("INPUT"==LabelValue) {

		LabelValue=SelRowObj.type.toUpperCase();
		if ("CHECKBOX"==LabelValue) {			
			obj.checked=SelRowObj.checked;
			return obj;
		}
		if ("HIDDEN"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}
		if ("TEXT"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}

			obj.value=trim(SelRowObj.value);
			return obj;
	}

}
document.body.onload=BodyLoadHandler;