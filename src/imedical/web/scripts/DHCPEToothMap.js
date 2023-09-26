//DHCPEToothMap
var lt="",rt="",lb="",rb=""
var ltstr="",rtstr="",lbstr="",rbstr=""
document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	for(i=1;i<=4;i++)
	{
		for(j=1;j<=8;j++)
		{
			var obj=document.getElementById("Tooth"+i+j);
			if (obj) obj.onclick=Tooth_click;
			
		}
		
		
	}
	var obj=document.getElementById("Clear");
	if (obj) obj.onclick=Clear_click;
	var obj=document.getElementById("Save");
	if (obj) obj.onclick=Save_click;
	
	
	
}
function Save_click()
{
	var obj=document.getElementById("ToothList");
	if (obj) var str=obj.value;
	var obj=document.getElementById("eSrc");
	if (obj) var curid=obj.value
	var curobject=opener.document.getElementById(curid);
	var NatureObj=opener.document.getElementById(curid+"S");
	if(NatureObj) NatureDesc=NatureObj.innerText;
	if(curobject.value==NatureDesc)
	{	curobject.value=""
		opener.insertAtCaret(curobject,str)
	}
	else opener.insertAtCaret(curobject,str)
	window.close()
	
}
function Clear_click()
{
	lt="",rt="",lb="",rb=""
	ltstr="",rtstr="",lbstr="",rbstr=""
	var obj=document.getElementById("ToothList");
	if (obj) obj.value="";
	
}
function Tooth_click()
{
	var eSrc=window.event.srcElement;
	var namestr=eSrc.id;
	if((namestr.substr(5,1)==1)&&(lt!="")) lt=lt+"、"+namestr.substr(6,1)
	if((namestr.substr(5,1)==1)&&(lt=="")) lt=namestr.substr(6,1)
	
	if((namestr.substr(5,1)==2)&&(rt!="")) rt=rt+"、"+namestr.substr(6,1)
	if((namestr.substr(5,1)==2)&&(rt=="")) rt=namestr.substr(6,1)
	
	if((namestr.substr(5,1)==3)&&(lb!="")) lb=lb+"、"+namestr.substr(6,1)
	if((namestr.substr(5,1)==3)&&(lb=="")) lb=namestr.substr(6,1)
	
	if((namestr.substr(5,1)==4)&&(rb!="")) rb=rb+"、"+namestr.substr(6,1)
	if((namestr.substr(5,1)==4)&&(rb=="")) rb=namestr.substr(6,1)
	
	if(lt!="") ltstr="右上第"+lt+"颗牙、"
	if(rt!="") rtstr="左上第"+rt+"颗牙、"
	if(lb!="") lbstr="右下第"+lb+"颗牙、"
	if(rb!="") rbstr="左下第"+rb+"颗牙、"
	var str=ltstr+rtstr+lbstr+rbstr
	var strsp=str.split("、")
	var strlen=strsp.length
	var xystr=""
	for(m=0;m<strlen-1;m++)
	{
		if(xystr=="") xystr=strsp[m]
		else xystr=xystr+"、"+strsp[m]
		
	}
	var obj=document.getElementById("ToothList");
	if (obj) obj.value=xystr;
}