var preSelectRow=-1;
var selectRow=0;
function BodyLoadHandler()
{
	var obj=document.getElementById('Insert')
	if(obj) obj.onclick=Insert_click;
	var obj=document.getElementById('UPDATE')
	if(obj) obj.onclick=Update_click;
	var obj=document.getElementById('DELETE')
	if(obj) obj.onclick=Delete_click;
	
	var obj=document.getElementById("icucioiTypeDesc");
	if (obj) obj.onblur=IcucioiTypeDesc_onblur;
	var obj=document.getElementById("ancoDesc");
	if (obj) obj.onblur=AncoDesc_onblur;
	var obj=document.getElementById("ancvcDesc");
	if (obj) obj.onblur=AncvcDesc_onblur;
	var obj=document.getElementById("phcinDesc");
	if (obj) obj.onblur=PhcinDesc_onblur;
	var obj=document.getElementById("icucioiActiveDesc");
	if (obj) obj.onblur=IcucioiActiveDesc_onblur;
	var obj=document.getElementById("ctlocDesc");
	if (obj) obj.onblur=CtlocDesc_onblur;
}
	
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	selectRow=rowObj.rowIndex;
	if (!selectRow) return;
	
	if (preSelectRow!=selectRow)
	{
		SetElementByElement('icucioiId',"V",'tIcucioiIdz'+selectRow,"I"," ","");
		SetElementByElement('icucioiCode',"V",'tIcucioiCodez'+selectRow,"I"," ","");
		SetElementByElement('icucioiDesc',"V",'tIcucioiDescz'+selectRow,"I"," ","");
		SetElementByElement('icucioiTypeDesc',"V",'tIcucioiTypeDescz'+selectRow,"I"," ","");
		SetElementByElement('icucioiType',"V",'tIcucioiTypez'+selectRow,"I"," ","");
		SetElementByElement('ancoDesc',"V",'tAncoDescz'+selectRow,"I"," ","");
		SetElementByElement('ancoId',"V",'tAncoIdz'+selectRow,"I"," ","");
		SetElementByElement('ancvcDesc',"V",'tAncvcDescz'+selectRow,"I"," ","");
		SetElementByElement('ancvcId',"V",'tAncvcIdz'+selectRow,"I"," ","");
		SetElementByElement('phcinDesc',"V",'tPhcinDescz'+selectRow,"I"," ","");
		SetElementByElement('phcinId',"V",'tPhcinIdz'+selectRow,"I"," ","");
		SetElementByElement('icucioiActiveDesc',"V",'tIcucioiActiveDescz'+selectRow,"I"," ","");
		SetElementByElement('icucioiActive',"V",'tIcucioiActivez'+selectRow,"I"," ","");
		SetElementByElement('ctlocDesc',"V",'tCtlocDescz'+selectRow,"I"," ","");
		SetElementByElement('ctlocId',"V",'tCtlocIdz'+selectRow,"I"," ","");

		preSelectRow=selectRow;
	}
	else
	{
		SetElementValue('icucioiId',"V","");
		SetElementValue('icucioiCode',"V","");
		SetElementValue('icucioiDesc',"V","");
		SetElementValue('icucioiType',"V","");
		SetElementValue('icucioiTypeDesc',"V","");
		SetElementValue('ancoDesc',"V","");
		SetElementValue('ancoId',"V","");
		SetElementValue('ancvcDesc',"V","");
		SetElementValue('ancvcId',"V","");
		SetElementValue('phcinDesc',"V","");
		SetElementValue('phcinId',"V","");
		SetElementValue('icucioiActiveDesc',"V","");
		SetElementValue('icucioiActive',"V","");
		SetElementValue('ctlocDesc',"V","");
		SetElementValue('ctlocId',"V","");

		preSelectRow=-1
		selectRow=0
	}
}

function Insert_click()
{
	if (selectRow>0) return;
	var icucioiCode=GetElementValue('icucioiCode',"V");
	var icucioiDesc=GetElementValue('icucioiDesc',"V");
	var icucioiType=GetElementValue('icucioiType',"V");
	var ancoId=GetElementValue('ancoId',"V");
	var ancvcId=GetElementValue('ancvcId',"V");
	var phcinId=GetElementValue('phcinId',"V");
	var icucioiActive=GetElementValue('icucioiActive',"V");
	var ctlocId=GetElementValue('ctlocId',"V");

	var obj=document.getElementById('InsertICUCIOItem')
	if(obj) 
	{
		var insertICUCIOItem=obj.value;
		var retStr=cspRunServerMethod(insertICUCIOItem,icucioiCode,icucioiDesc,icucioiType,ancoId,ancvcId,phcinId,icucioiActive,ctlocId);
		if (retStr!=0) alert(retStr);
		else Find_click();
	}
}

function Update_click(){
	if (selectRow<1) return;
	
	var icucioiId=GetElementValue('icucioiId',"V");
	var icucioiCode=GetElementValue('icucioiCode',"V");
	var icucioiDesc=GetElementValue('icucioiDesc',"V");
	var icucioiType=GetElementValue('icucioiType',"V");
	var ancoId=GetElementValue('ancoId',"V");
	var ancvcId=GetElementValue('ancvcId',"V");
	var phcinId=GetElementValue('phcinId',"V");
	var icucioiActive=GetElementValue('icucioiActive',"V");
	var ctlocId=GetElementValue('ctlocId',"V");
	var obj=document.getElementById('UpdateICUCIOItem')
	if(obj) 
	{
		//alert(icucioiId+"/"+icucioiCode+"/"+icucioiDesc+"/"+icucioiType+"/"+ancoId+"/"+ancvcId+"/"+phcinId+"/"+icucioiActive+"/"+ctlocId)
		var retStr=cspRunServerMethod(obj.value,icucioiId,icucioiCode,icucioiDesc,icucioiType,ancoId,ancvcId,phcinId,icucioiActive,ctlocId);
		if (retStr!=0) alert(retStr);
		else Find_click();
	}
}

function Delete_click(){
	if (selectRow<1) return;
	var icucioiId=GetElementValue('tIcucioiIdz'+selectRow,"I");
	
	var obj=document.getElementById('DeleteICUCIOItem')
	if(obj) 
	{
		var deleteICUCIOItem=obj.value;
		retStr=cspRunServerMethod(deleteICUCIOItem,icucioiId);
		if (retStr!=0) alert(retStr);
		else Find_click();
	}	
}

function GetType(value)
{
	SetElementFromListByName('icucioiType',"V",'icucioiTypeDesc',"V",value,"^",0,1)
}
function IcucioiTypeDesc_onblur()
{
	SetAttachElementByName("icucioiTypeDesc","V","","icucioiType","V","");
}
function GetCommonOrd(value)
{
	SetElementFromListByName('ancoId',"V",'ancoDesc',"V",value,"^",6,2)
}
function AncoDesc_onblur()
{
	SetAttachElementByName("ancoDesc","V","","ancoId","V","");
}
function GetViewCat(value)
{
	SetElementFromListByName('ancvcId',"V",'ancvcDesc',"V",value,"^",0,1)
}
function AncvcDesc_onblur()
{
	SetAttachElementByName("ancvcDesc","V","","ancvcId","V","");
}
function GetActive(value)
{
	SetElementFromListByName('icucioiActive',"V",'icucioiActiveDesc',"V",value,"^",0,1)
}
function IcucioiActiveDesc_onblur()
{
	SetAttachElementByName("icucioiActiveDesc","V","","icucioiActive","V","");
}
function LookUpInstruc(value)
{
	SetElementFromListByName('phcinDesc',"V",'phcinId',"V",value,"^",0,1)
}
function PhcinDesc_onblur()
{
	SetAttachElementByName("phcinDesc","V","","phcinId","V","");
}
function GetCtloc(value)
{
	SetElementFromListByName('ctlocId',"V",'ctlocDesc',"V",value,"^",1,0)
}

function CtlocDesc_onblur()
{
	SetAttachElementByName("ctlocDesc","V","","ctlocId","V","");
}
function selitem(selbox,delimStr)
{
      var tmpList=new Array();
        for ( var i=0;i<selbox.options.length;i++)
		{   
			if (selbox.options[i].selected)
			{   
			    tmpList[tmpList.length]=selbox.options[i].value
			}
		}
		if (tmpList[0]=="") tmpList=tmpList.slice(1)
		var Str=tmpList.join(delimStr);
  return Str
}
function SelectedSet(selObj,indStr,delim) 
{
	var tmpList=new Array();
	for(i=0;i<selObj.options.length;i++)
	{
		selObj.options[i].selected=false;
	}
	tmpList=indStr.split(delim)
	for(j=0;j<tmpList.length;j++)
	{
		for(i=0;i<selObj.options.length;i++)
		{
			if (selObj.options[i].value==tmpList[j])
		    {
			    selObj.options[i].selected=true;break
		    }
		}
	}
}
document.body.onload=BodyLoadHandler;