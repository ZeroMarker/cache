
//DHCPEItemSequence.js
// create by zhouli
// 2008-03-10
var CurRow=0
function BodyLoadHandler() {
  
	var obj;
	obj=document.getElementById("Save");
	if (obj) {obj.onclick=Save_click;}
    obj=document.getElementById("Delete");
	if (obj) {obj.onclick=Delete_click;}
	var obj=document.getElementById('ItemName');
	if (obj) obj.onkeydown=ItemName_KeyDown;
	
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}	

function ItemInfo(value) {
	if (value=="") return;
    var tmp=value.split("^")
    var obj=document.getElementById('ItemID');
    obj.value=tmp[1];
    var obj=document.getElementById('ItemCode');
    obj.value=tmp[2]
    var obj=document.getElementById('ItemName');
    obj.value=tmp[0]
    }
    
    
function ItemName_KeyDown(e)
{   
	var key=websys_getKey(e);
	if (13==key) {
		var obj=document.getElementById('GDComponentID');
		if (obj) var ComponentID=obj.value;
	    var obj=document.getElementById('ld'+ComponentID+'iItemName');
		if (obj) obj.click();return false;
		}
}   
    
    
    
    
 function Save_click()
    
 {  
    var ID=""
	var iItemID="",iItemCode="",iItemName="" ,iItemSequence=""
	var obj=document.getElementById("ItemID");
    if (obj) {iItemID=obj.value;}
 
    var obj=document.getElementById("ItemCode");
    if (obj) {iItemCode=obj.value;}
    
    var obj=document.getElementById("ItemName");
    if (obj) {iItemName=obj.value;}
 
    var obj=document.getElementById("ItemSequence")
    if (obj) {iItemSequence=obj.value;}
   
    if (""==iItemID) {
		obj=document.getElementById("ItemID")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("医嘱名称不能为空");
		return false;
	 }
   if (""==iItemSequence) {
		obj=document.getElementById("ItemSequence")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("医嘱顺序不能为空");
		return false;
	 }
    /*if ((iItemID=="")||(iItemSequence=="")) { 
		
		alert(t['02']);
		return;
		}  */
		
     var Instring=trim(iItemID)
	                      +"^"+trim(iItemCode)
	                      +"^"+trim(iItemName)
	                      +"^"+trim(iItemSequence);
	 
	                    
	var Ins=document.getElementById('ClassBox')	
    if (Ins) {var encmeth=Ins.value; } 
	else {var encmeth=''; } 

    var flag=cspRunServerMethod(encmeth,'','',Instring) 
    if (flag==0)  
    
	{   // window.location.reload();
		alert(t["Success"]);
		 location.reload();
	}
	else
	{
		alert(t["Err"]);
	}
}

function Delete_click()
{   var ID="",Sequence=""
	if (CurRow==0) 
	{
		alert("请先选择要删除的记录");
		return;
	}
	var obj=document.getElementById("TItemIDz"+CurRow)
	if (obj) var ID=obj.value;
    var obj=document.getElementById("TItemSequencez"+CurRow)
	if (obj) var Sequence=obj.innerText;
	var string=trim(ID)+"^"+trim(Sequence)
	var encmeth="";
	var encmethobj=document.getElementById("DeleteBox");
	if (encmethobj) var encmeth=encmethobj.value;
	else encmeth="";
	var flag=cspRunServerMethod(encmeth,string);
	
	if (flag==0)
	{
		location.reload();
	}
	else
	{
		alert(t[flag]);
	}
	}
	
	
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	
	var objtbl=document.getElementById('tDHCPEItemSequence');	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var Row=rowObj.rowIndex;
	if (Row==CurRow)
	{
		CurRow=0      
	
	}
	else
	{
		CurRow=Row;
	}
	
  
	
	var obj=document.getElementById("TItemNamez"+CurRow)
	var objItemName=document.getElementById("ItemName")
	if (objItemName)  objItemName.value=obj.innerText;


	
	var obj=document.getElementById("TItemSequencez"+CurRow)
	var objSeq=document.getElementById("ItemSequence")
	if (objSeq)  objSeq.value=obj.innerText;

      var obj=document.getElementById("TItemIDz"+CurRow)
  
	var objItemId=document.getElementById("ItemID")
	if (objItemId)  objItemId.value=obj.value;
   
    
    var obj=document.getElementById("TItemCodez"+CurRow)
	var objCode=document.getElementById("ItemCode")
	if (objCode)  objCode.value=obj.innerText;

 

	



}	

document.body.onload = BodyLoadHandler;
