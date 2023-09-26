//DHCPECommon.js




//Creator:xy
///Date:2018-08-09
///根据元素名字获取元素值
///ename:元素名字
///etype:元素类型 1:INPUT/TEXTAREA 2:CheckBox  3:LABEL	4:SELECT
function GetElementValueNew(ename,etype)
{
	var evalue="";
	var obj=document.getElementById(ename);
	if (!etype) etype=""

	if (obj)
	{
		//messageShow("","","",obj.tagName);
		//messageShow("","","",obj.type);
		//SetElement("Loc",obj.tagName);
		if ((etype=="1")||(etype=="4"))
		{	evalue=obj.value;}
		else if (etype=="2")
		{	evalue=obj.checked;}
		else if (etype=="3") 
		{	evalue=obj.innerText;}
		else if (etype=="")
		{	
			if (obj.tagName=="TEXTAREA")
			{	evalue=obj.value;}
			else if (obj.tagName=="INPUT")
			{				
				if (obj.type=="checkbox")
				{	evalue=obj.checked}
				else
				{	evalue=obj.value;}
			}
			else if (obj.tagName=="LABEL")
			{	evalue=obj.innerText}
			else if (obj.tagName=="SELECT")
			{	evalue=obj.value}
		}
	}
	return evalue;
}

//Creator:xy
///Date:2018-08-09
///复选框赋值
function SetChkElement(vElementID,vValue)
{	
	
		var objType=jQuery("#"+vElementID).prop("type")
		var objClassInfo=jQuery("#"+vElementID).prop("class")
	
	if ((vValue=="1")||(vValue==true)||(vValue=="Y"))
	{
		jQuery("#"+vElementID).checkbox("setValue",true);  
	}
	if ((vValue=="0")||(vValue==false)||(vValue=="N")||(vValue==""))
	{
		jQuery("#"+vElementID).checkbox("setValue",false);
	}
	
	
}