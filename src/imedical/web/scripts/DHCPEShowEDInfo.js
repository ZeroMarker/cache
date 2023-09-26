document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	
	
	var obj=document.getElementById("QueryED");
	if (obj) obj.onkeydown=QueryED_KeyDown;
	
}
function QueryED_KeyDown(e)
{
	var Key=websys_getKey(e); 
	if ((13==Key)) 
	{
		var RLID="",OEORD="",QueryED=""
		var obj=document.getElementById("RLID");
		if (obj) RLID=obj.value;
		var obj=document.getElementById("OEORDItemID");
		if (obj) OEORD=obj.value;
		var obj=document.getElementById("QueryED");
		if (obj) QueryED=obj.value;
		
		var ret=tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","OutEDInfobyPrefix",RLID,OEORD,QueryED);
	
		document.getElementById("edprefix").innerHTML = ret;
	
		return false;
	}
	
}

function EDClick()
{
	var eSrc=window.event.srcElement;
	var eSrcID=eSrc.id;
	var InfoArr=eSrcID.split("^");
	var StationID=InfoArr[0];
	var Desc=InfoArr[1];
	var obj=document.getElementById("GetEDInfoByDesc");
	if (obj) encmeth=obj.value;
	var OEORDItemID=""
	var obj=document.getElementById("OEORDItemID");
	if (obj) OEORDItemID=obj.value;
	var Info=cspRunServerMethod(encmeth,StationID,Desc,OEORDItemID);
	if (Info=="") return false;
	CreateDiv(eSrc,Info)
}
function CreateDiv(obj,Info){  
    var div=document.getElementById("editBehaviorDiv");  
    if(div!=null)  
        document.body.removeChild(div);  
    div = document.createElement("div");   
    div.id="editBehaviorDiv";  
    div.style.position='absolute';  
    var op=getoffset(obj);  
    div.style.top=op[0]+20;  
    div.style.left=op[1]+30;  
    div.style.zIndex =100;  
    div.style.backgroundColor='#ecf1f6';  
    div.style.border="1px solid #666";  
    //div.className="td1";  
    var innerText="<TABLE border=1 width=200>"
    var Char_2=String.fromCharCode(2);
    var Char_1=String.fromCharCode(1);
    var EDArr=Info.split(Char_2);
    var EDArrLength=EDArr.length
    for (var i=0;i<EDArrLength;i++)
    {
    	var OneEDArr=EDArr[i];
    	var OneArr=OneEDArr.split(Char_1);
    	innerText=innerText+"<TR><TD style='cursor:hand' value='"+OneArr[0]+"' ondblclick=EDDblClick()>"+OneArr[1]+"</TD></TR>"
    }
    innerText=innerText+"</TABLE>"
    div.innerHTML=innerText;
    document.body.appendChild(div);  
}
function getoffset(e)   
{   
	var t=e.offsetTop;   
	var l=e.offsetLeft;   
	while(e=e.offsetParent)   
	{   
		t+=e.offsetTop;   
		l+=e.offsetLeft;   
	}   
	var rec = new Array(1);   
	rec[0] = t;   
	rec[1] = l;   
	return rec   
}
function AllEDDescDBLClick(e)
{

}
function EDDEscOnDBLClick(e)
{
	
}
function EDDblClick()
{
	
	var eSrc=window.event.srcElement;
	//var EDID=eSrc.value;
	var EDID=event.srcElement.getAttribute("value");
	if (opener){
		
		/*if (opener.parent.frames["diagnosis"]){
			opener.parent.frames["diagnosis"].AddDiagnosis(EDID);
		}else{
				opener.AddDiagnosis(EDID);
		}*/

	if (opener.frames["diagnosis"]){
			opener.parent.frames["diagnosis"].AddDiagnosis(EDID);

		}else{
		
			opener.AddDiagnosis(EDID);
		}
		
		
	}
	//window.close();

	var div=document.getElementById("editBehaviorDiv");  
    	if(div!=null)  
        	document.body.removeChild(div);  
}