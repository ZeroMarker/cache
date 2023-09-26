//DHCPERelateItem.js
var CurrentSel;
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }

	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }


}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function SearchArcItmmast(value){
	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;

		//医嘱名称
		obj=document.getElementById("ARCIMDesc");
		obj.value=aiList[1];

		//医嘱编号
		obj=document.getElementById("ARCIMDR");
		obj.value=aiList[2];
		
	}
}

function Update_click() {
	var iItemID="",iARCIMDR="";
	  
	var obj=document.getElementById("ItemID");
	if (obj){iItemID=obj.value; } 

	var obj=document.getElementById("ARCIMDR");
	if (obj){iARCIMDR=obj.value; } 

	
	var Instring=trim(iItemID)			
				+"^"+trim(iARCIMDR)
				; 

	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,Instring)
	
	
	if (flag=='0') {}
	else {alert("更新错误!")}

	
	//刷新页面
	location.reload(); 
}

function Delete_click() {

	var iItemID="",iARCIMDR="";

	var obj=document.getElementById("ItemID");
	if (obj){iItemID=obj.value; } 
	
	var obj=document.getElementById("RelateIDz"+CurrentSel);
	if (obj){iARCIMDR=obj.innerText; } 
   
	
	var Instring=trim(iItemID)			
				+"^"+trim(iARCIMDR)
				; 
				
	var Ins=document.getElementById('DeleteBox');
	if (Ins) {var encmeth=Ins.value; } 
	else {var encmeth=''; };

	var flag=cspRunServerMethod(encmeth,Instring);
		
	location.reload();

}


function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);	
	
	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurrentSel)
	{	    
	    CurrentSel=0;
	    return;
	}

	CurrentSel=selectrow;


}

document.body.onload = BodyLoadHandler;

