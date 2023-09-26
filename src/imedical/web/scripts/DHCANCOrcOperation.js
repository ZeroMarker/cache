var preSelectRow=-1;
var selectRow=0;
var operId="",ancoplId="",bldtpId="",bodsId="",operPositionId="",operPositionId="",operTypeCode="",operCategId="";

function BodyLoadHandler()
{
	var obj=document.getElementById("btnSave");
	if (obj) obj.onclick=Save_click;
	var obj=document.getElementById("btnDelete");
	if (obj) obj.onclick=Delete_click;
	var obj=document.getElementById("operCategDesc");
	if (obj) obj.onblur=OperCategDesc_onblur;
	var obj=document.getElementById("operLocList");
    if (obj) {obj.ondblclick=operLocList_Dublclick};
}

function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCANCOrcOperation');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	selectRow=rowObj.rowIndex;
	if (!selectRow) return;
	document.getElementById("operLocList").options.length=0;
	
	if (preSelectRow!=selectRow)
	{
		//SetElementByElement('operDesc',"V",'tOperDescz'+selectRow,"I"," ","");
		SetElementByElement('ancoplDesc',"V",'tAncoplDescz'+selectRow,"I"," ","");
		SetElementByElement('bldtpDesc',"V",'tBldtpDescz'+selectRow,"I"," ","");
		SetElementByElement('bodsDesc',"V",'tBodsDescz'+selectRow,"I"," ","");
		SetElementByElement('operPositionDesc',"V",'tOperPositionDescz'+selectRow,"I"," ","");
		SetElementByElement('operCategDesc',"V",'tOperCategDescz'+selectRow,"I"," ","");
		SetElementByElement('operCategId',"V",'tOperCategIdz'+selectRow,"I"," ","");
		SetElementByElement('operLocation',"V",'tOperLocationz'+selectRow,"I"," ","");
		SetElementByElement('operType',"V",'tOperTypez'+selectRow,"I"," ","");
		operId=GetElementValue('tOperIdz'+selectRow,"I");
		ancoplId=GetElementValue('tAncopIdz'+selectRow,"I");
		bldtpId=GetElementValue('tBldtpIdz'+selectRow,"I");
		bodsId=GetElementValue('tBodsIdz'+selectRow,"I");
		operPositionId=GetElementValue('tOperPositionIdz'+selectRow,"I");
		operLocId=GetElementValue('tOperLocIdz'+selectRow,"I");
		tOperLocation=GetElementValue('tOperLocationz'+selectRow,"I");
		tOperTypez=GetElementValue('tOperTypez'+selectRow,"I");
		
		var operLocId=operLocId.split("|");
		var OperLocation=tOperLocation.split(",");
		var opLocStr=""
		if(operLocId.length!=OperLocation.length){
			return;
			}
		else{
			for(var i=0;i<operLocId.length;i++)
				{
					var objSelected = new Option(OperLocation[i], operLocId[i]);
	                var obj=document.getElementById('operLocList');
	                if (obj) obj.options[obj.options.length]=objSelected;
					
					
				}
			}
		preSelectRow=selectRow;
	}
	else
	{
		//SetElementValue('operDesc',"V","");
		SetElementValue('ancoplDesc',"V","");
		SetElementValue('bldtpDesc',"V","");
		SetElementValue('bodsDesc',"V","");
		SetElementValue('operPositionDesc',"V","");
		SetElementValue('operCategDesc',"V","");
		SetElementValue('operCategId',"V","");
		SetElementValue('operLocation',"V","");
		SetElementValue('operType',"V","");
		operId="",ancoplId="",bldtpId="",bodsId="",operPositionId="",operLocId=""
		preSelectRow=-1
		selectRow=0
	}
}


function Save_click()
{
	var operLocId=""
	obj=document.getElementById('operLocList');
	if (obj.length>0)
	{
		for(var i=0;i<obj.length;i++) 
		{
			if(operLocId!="")
			{
			operLocId=operLocId+"|"+obj.options[i].value;
			}
			if(operLocId=="") 
			{
			 operLocId=obj.options[i].value
			}
		}
	}
	//alert(operId+"/"+ancoplId+"^"+bldtpId+"^"+bodsId+"^"+operPositionId);
	if (selectRow<1) return;
	var obj=document.getElementById('save');
	if(obj) 
	{
		retStr=cspRunServerMethod(obj.value,operId,ancoplId+"^"+bldtpId+"^"+bodsId+"^"+operPositionId+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+operLocId+"^"+operTypeCode,operCategId);
		if (retStr!=0) alert(retStr);
		//else Find_click();
	}
}

function Delete_click()
{
	if (selectRow<1) return;
	
	var obj=document.getElementById('delete')
	if(obj) 
	{
		retStr=cspRunServerMethod(obj.value,operId);
		if (retStr!=0) alert(retStr);
		else Find_click();
	}
}
function GetOPLevel(value)
{
	ancoplId=SetElementAndReturnFromList('ancoplDesc',"V",value,"^",1,0)
}

function GetOPBladeType(value)
{
	bldtpId=SetElementAndReturnFromList('bldtpDesc',"V",value,"^",1,0)
}
function GetBodySite(value)
{
	bodsId=SetElementAndReturnFromList('bodsDesc',"V",value,"^",1,0)
}
function GetOperPosition(value)
{
	operPositionId=SetElementAndReturnFromList('operPositionDesc',"V",value,"^",1,0)
}
function GetORCOperationCategory(value)
{
	operCategId=SetElementAndReturnFromList('operCategDesc',"V",value,"^",1,0)
}
function OperCategDesc_onblur(value)
{
	SetAttachElementByName("operCategDesc","V","","operCategId","V","");
}
function GetOperLocation(str)
{
	var opLoc=str.split("^");
	var operLoc=document.getElementById('operLocation');
	operLoc.value="";
    var objSelected = new Option(opLoc[1], opLoc[0]);
	var obj=document.getElementById('operLocList');
	if (obj) obj.options[obj.options.length]=objSelected;
	if(obj.options[0].value<1)
	{
	document.getElementById("operLocList").remove(0);
	}
}
function operLocList_Dublclick()//delete operLocList
{
	var obj=document.getElementById("operLocList");
	var a=obj.selectedIndex;
	obj.remove(a) ;
}
function GetOperType(str)
{
	var opstr=str.split("^");
	var operType=document.getElementById('operType');
	operType.value=opstr[2];
	operTypeCode=opstr[1];
}

document.body.onload=BodyLoadHandler;
