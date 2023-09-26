function BodyLoadHandler()
{
	MakeComboBox("ResYear");
	var InfNum=document.getElementById("ResYear");
	if (InfNum)	gSetListIndex("ResYear",0);
	
	MakeComboBox("ResMonth");
	var InfNum=document.getElementById("ResMonth");
	if (InfNum)	gSetListIndex("ResMonth",0);
	
	var obj=document.getElementById("Find");
	if(obj) obj.onclick=Find_Onclick;
	
	var obj=document.getElementById("Export");
	if(obj) obj.onclick=Export_Onclick;
 
}

function Export_Onclick()
{
	var ResYear="",ResMonth="",CurrentWard="",CurrentBed="",cArguments=""
  ResYear=GetTextValues("ResYear");
  ResMonth=GetTextValues("ResMonth");
  CurrentWard=GetValues("WardId");
  BedNo=GetValues("BedId");
  cArguments=ResYear+"^"+ResMonth+"^"+ BedNo+"^"+CurrentWard;

	var flg=ExportDataToExcel("MethodGetServer","MethodGetData","DHCMedICURes.xls",cArguments);
	
}

function gGetObjValue(objname)
{
	var obj=document.getElementById(objname);
	var ret="";
	if (obj){
		switch (obj.type)
		{
			case "select-one":
				myidx=obj.selectedIndex;
				ret=obj.options[myidx].text;
				break;
			case "checkbox":
				ret=obj.checked;
				break;
			default:
				ret=obj.value;
				break;
		}
	}
	return ret;
}

function Find_Onclick()
{
  var ResYear="",ResMonth="",CurrentWard="",CurrentBed=""
  ResYear=GetTextValues("ResYear");
  ResMonth=GetTextValues("ResMonth");
  CurrentWard=GetValues("WardId");
  BedNo=GetValues("BedId");

  lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedICUResList" + "&cResYear=" + encodeURIComponent(ResYear) + "&cResMonth=" +encodeURIComponent(ResMonth)+ "&cBedNo=" +BedNo+"&cCurrentWard="+CurrentWard;
  parent.frames[1].location.href=lnk;	
	
}

function GetValues(Str)
{
	var ret=""
	var obj=document.getElementById(Str);
	if(obj) ret=obj.value;
	return ret;	
}

function GetTextValues(Str)
{
	var ret="";
	var select = document.getElementById(Str);
  if(select) ret=select.options[select.selectedIndex].innerText
  return ret ;
}

function GetValuesSel(Str)
{
	var ret="";
	var select = document.getElementById("UrinePipe");
  if(select) ret=select.options[select.selectedIndex].innerText
  return ret ;
	
}

function gSetListIndex(objname,Index)
{
	var obj=document.getElementById(objname);
	if (obj)
	{
		//obj.selectedIndex=Index;
		obj.options[Index].selected=true;
	}
}

function SetWardRoomId(Str)
{
	var WardId=document.getElementById('WardId');
	var tem=Str.split("^");
	WardId.value=tem[1];
	
}

function SetBedId(Str)
{
	var BedId=document.getElementById('BedId');
	var tem=Str.split("^");
	BedId.value=tem[1];
}

function MakeComboBox(controlID)
{
	var obj = document.getElementById(controlID);
	obj.multiple = false;
	obj.size = 1;
}
function BASE_GetWebConfig(encmeth){
	var objWebConfig=new clsWebConfig("")
	if (encmeth!=""){		
		ret=cspRunServerMethod(encmeth);
		if (ret!=""){
			var TempFileds=ret.split(CHR_1)
			objWebConfig.CurrentNS=TempFileds[0];
			objWebConfig.MEDDATA=TempFileds[1];
			objWebConfig.LABDATA=TempFileds[2];
			objWebConfig.Server="cn_iptcp:"+TempFileds[3]+"[1972]";
			objWebConfig.Path=TempFileds[4];
			objWebConfig.LayOutManager=TempFileds[5];
			}
		}
	return objWebConfig;
	}
function GetWebConfig(encmeth){
	var objWebConfig=new Object();
	if (encmeth!=""){
		ret=cspRunServerMethod(encmeth);
		if (ret!=""){
			var TempFileds=ret.split(String.fromCharCode(1));
			objWebConfig.CurrentNS=TempFileds[0];
			objWebConfig.MEDDATA=TempFileds[1];
			objWebConfig.LABDATA=TempFileds[2];
			objWebConfig.Server="cn_iptcp:"+TempFileds[3]+"[1972]";
			objWebConfig.Path=TempFileds[4];
			objWebConfig.LayOutManager=TempFileds[5];
		}
	}else{
		objWebConfig=null;
	}
	return objWebConfig;
}	

document.body.onload=BodyLoadHandler;