function BodyLoadHandler()
{
	var objClclogDesc=document.getElementById("clclogDesc");
	if (objClclogDesc) objClclogDesc.onblur=ClclogDesc_onblur;
	var objClclogDesc=document.getElementById("preValueDesc");
	if (objClclogDesc) objClclogDesc.onblur=PreValueDesc_onblur;
	var objClclogDesc=document.getElementById("postValueDesc");
	if (objClclogDesc) objClclogDesc.onblur=PostValueDesc_onblur;
}

function ClclogDesc_onblur()
{
	SetAttachElementByName("clclogDesc","V","","clclogId","V","");
}

function PreValueDesc_onblur()
{
	SetAttachElementByName("preValueDesc","V","","preValue","V","");	
}

function PostValueDesc_onblur()
{
	SetAttachElementByName("postValueDesc","V","","postValue","V","");	
}


function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCCLLog');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	}

function LookupCLCLogSelect(value)
{
	SetElementFromListByName('clclogId',"V",'clclogDesc',"V",value,"^",0,1)
	SetElementFromListByName('preValue',"V",'preValueDesc',"V","^","^",0,1)
	SetElementFromListByName('postValue',"V",'postValueDesc',"V","^","^",0,1)
}
function LookupCLCLogPreValueSelect(value)
{
	SetElementFromListByName('preValue',"V",'preValueDesc',"V",value,"^",0,1)
}

function LookupCLCLogPostValueSelect(value)
{
	SetElementFromListByName('postValue',"V",'postValueDesc',"V",value,"^",0,1)
}

document.body.onload=BodyLoadHandler;
