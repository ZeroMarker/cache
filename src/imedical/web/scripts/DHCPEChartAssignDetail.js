
function BodyLoadHandler() {
  
	var obj;
	obj=document.getElementById("BSave");
	if (obj) {obj.onclick=BSave_click;}
    obj=document.getElementById("SelectAll");
	if (obj) {obj.onclick=SelectAll_click;}
	obj=document.getElementById("SelectAllWrite");
	if (obj) {obj.onclick=SelectAllWrite_click;}
	InitCheckBox();
}
function InitCheckBox()
{
	var OpenType="";
	var obj=document.getElementById("OpenType");
	if (obj) OpenType=obj.value;
	if (OpenType=="") return false;
	var objtbl=document.getElementById('tDHCPEChartAssignDetail');	
	var rows=objtbl.rows.length;
	var obj;
	
	var obj=document.getElementById("SelectAllWrite");
	if (obj) obj.disabled=true;
	
	var obj=document.getElementById("SelectAll");
	if (obj) obj.disabled=true;

	for (i = 1; i < rows; i++)
	{
		obj=document.getElementById("TUseFlagz"+i);
		if (obj) obj.disabled=true;
		obj=document.getElementById("TWritez"+i);
		if (obj){
			obj.disabled=true;
			if (!obj.checked){
				obj=document.getElementById("TDefaultz"+i);
				if (obj) obj.disabled=true;
			}else{
				//obj=document.getElementById("TDefaultz"+i);
			}
		}
		
	}
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}  
function BSave_click()   
{  
	var eSrc = window.event.srcElement;	
	var objtbl=document.getElementById('tDHCPEChartAssignDetail');	
	var rows=objtbl.rows.length;
	var str="";
	var DefaultNum=0
	//alert('sxxaaax')
	for (i = 1; i < rows; i++)
	{
		var obj,chartID="",useFlag="0",WriteFlag="N",DefaultFlag="N",WriteWay="";
		obj=document.getElementById("TChartIDz"+i);
		if (obj) chartID=obj.value;
		if (chartID=="") continue;
		obj=document.getElementById("TUseFlagz"+i);
		if (obj&&obj.checked) useFlag="1"
		obj=document.getElementById("TWritez"+i);
		if (obj&&obj.checked) WriteFlag="Y"
		obj=document.getElementById("TDefaultz"+i);
		if (obj&&obj.checked) DefaultFlag="Y"
		
		
		//alert(i)
		//if (i-1)
		//{	
			obj=document.getElementById("WriteWay"+(chartID));
			if (obj){ WriteWay=obj.value;}
		//}
		//else {WriteWay="WriteWayNULL";}
		//alert(WriteWay)
		if (DefaultFlag=="Y") DefaultNum=DefaultNum+1;
		if (str==""){
			str=chartID+"$"+useFlag+"$"+WriteFlag+"$"+DefaultFlag+"$"+WriteWay;
		}else{
			str=str+"^"+chartID+"$"+useFlag+"$"+WriteFlag+"$"+DefaultFlag+"$"+WriteWay;
		} 
	}
	if (DefaultNum>1){
		alert("默认站点只能选择一个");
		return false;
	}
	var UserID="",GroupID="",LocID="",Method="";  
    var obj=document.getElementById("UserID");
	if (obj) UserID=obj.value;
	if (UserID==""){
		alert("操作员不能为空");
		websys_setfocus("UserName");
		return false;
	}
	var obj=document.getElementById("LocID");
	if (obj) LocID=obj.value;
	if (LocID==""){
		alert("科室不能为空");
		websys_setfocus("LocName");
		return false;
	}
	var obj=document.getElementById("GroupID");
	if (obj) GroupID=obj.value;
	if (GroupID==""){
		alert("安全组不能为空");
		websys_setfocus("GroupName");
		return false;
	}
	var obj=document.getElementById("Method");
	if (obj) Method=obj.value;
	if (Method==""){
		alert("没有设置操作方法")
		return false;
	}
	var ret=cspRunServerMethod(Method,UserID,LocID,GroupID,str);
	alert("操作成功")
}
function SelectAll_click()
{
	var eSrc = window.event.srcElement;	
	var objtbl=document.getElementById('tDHCPEChartAssignDetail');	
	var rows=objtbl.rows.length;
	for (i = 1; i < rows; i++)
	{
		var obj;
		obj=document.getElementById("TUseFlagz"+i);
		if (obj){
			//obj.checked=!obj.checked;
			obj.checked=eSrc.checked;;
		}

	}
}
function SelectAllWrite_click()
{
	var eSrc = window.event.srcElement;	
	var objtbl=document.getElementById('tDHCPEChartAssignDetail');	
	var rows=objtbl.rows.length;
	for (i = 1; i < rows; i++)
	{
		obj=document.getElementById("TWritez"+i);
		if (obj){
			//obj.checked=!obj.checked;
			obj.checked=eSrc.checked;
		}
	}
}
document.body.onload = BodyLoadHandler;

