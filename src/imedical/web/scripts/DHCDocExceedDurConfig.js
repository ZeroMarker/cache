document.body.onload = BodyLoadHandler;
var SelectRow=0
var ObjExceedCode=document.getElementById("ExceedCode");
var ObjExceedDesc=document.getElementById("ExceedDesc");
var ObjExceedType=document.getElementById("ExceedType");
var ObjValidSttDate=document.getElementById("ValidSttDate");
var ObjValidEndDate=document.getElementById("ValidEndDate");
function BodyLoadHandler() {
	var obj=document.getElementById("Add")
	if(obj){obj.onclick=Add_click}
	var obj=document.getElementById("Update")
	if(obj){obj.onclick=Update_click}
	var obj=document.getElementById("Delete")
	if(obj){obj.onclick=Delete_click}
	var obj=document.getElementById("SaveDate")
	if(obj){obj.onclick=SaveDate_click}
	if (ObjExceedType){
		ObjExceedType.size=1;
		ObjExceedType.multiple=false;
		ObjExceedType.onchange=ExceedType_OnChange;
		var varItem = new Option("","");
		ObjExceedType.options.add(varItem);
		var varItem = new Option("�Ƴ�","Durg");
		ObjExceedType.options.add(varItem);
		var varItem = new Option("����","Num");
		ObjExceedType.options.add(varItem);
	}

}
function ExceedType_OnChange()
{
	
	
}
function CheckData(){
	var Obj=document.getElementById("ExceedDesc");
	if (Obj){if (Obj.value==""){alert("����ԭ����������Ϊ��!");return false;}}
	var Obj=document.getElementById("ExceedType");
	if (Obj){if (Obj.value==""){alert("����������������Ϊ��!");return false;}}
	return true
}

function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCDocExceedDurConfig');
	var rows=objtbl.rows.length;	
	var lastrowindex=rows-1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;
	if (!selectrow){return;}
	if (SelectRow==selectrow)
	{   
	    if (ObjExceedCode){ObjExceedCode.value=""};
		if (ObjExceedDesc){ObjExceedDesc.value=""};
		if (ObjExceedType){ObjExceedType.value=""};
		if (ObjValidSttDate){ObjValidSttDate.value=""};
		if (ObjValidEndDate){ObjValidEndDate.value=""};
		SelectRow=0
	} 
	else
	{
		var ExceedCode="";var TExceedDesc=""; var TExceedType="";
		var TExceedFromDate=""; var TExceedEndDate="";
		var Obj=document.getElementById("TExceedCodez"+selectrow)
		if (Obj){ExceedCode=Obj.innerText.replace(/\s/ig,'');;}
		var Obj=document.getElementById("TExceedDescz"+selectrow)
		if (Obj){TExceedDesc=Obj.innerText.replace(/\s/ig,'');;}
		var Obj=document.getElementById("TExceedTypez"+selectrow)
		if (Obj){TExceedType=Obj.innerText.replace(/\s/ig,'');;}
		var Obj=document.getElementById("TExceedFromDatez"+selectrow)
		if (Obj){TExceedFromDate=Obj.innerText.replace(/\s/ig,'');;}
		var Obj=document.getElementById("TExceedEndDatez"+selectrow)
		if (Obj){TExceedEndDate=Obj.innerText.replace(/\s/ig,'');;}
		if (ObjExceedCode){ObjExceedCode.value=ExceedCode};
		if (ObjExceedDesc){ObjExceedDesc.value=TExceedDesc};
		if (ObjExceedType){ObjExceedType.value=TExceedType};
		if (ObjValidSttDate){ObjValidSttDate.value=TExceedFromDate};
		if (ObjValidEndDate){ObjValidEndDate.value=TExceedEndDate};
		SelectRow=selectrow
	}
}
function Update_click()
{
	var rtn=CheckData();
    if (!rtn){
	    return false;
    } 
	var ExceedCode="";var ExceedDesc=""; var ExceedType="";
	var ExceedFromDate=""; var ExceedEndDate="";var UpdateStr="";
	if (ObjExceedCode){ExceedCode=ObjExceedCode.value};
	if (ObjExceedDesc){ExceedDesc=ObjExceedDesc.value};
	if (ObjExceedType){ExceedType=ObjExceedType.value};
	if (ObjValidSttDate){ExceedFromDate=ObjValidSttDate.value};
	if (ObjValidEndDate){ExceedEndDate=ObjValidEndDate.value};
	UpdateStr=ExceedCode+"^"+ExceedDesc+"^"+ExceedType+"^"+ExceedFromDate+"^"+ExceedEndDate
	var TExceedID=""
	var Obj=document.getElementById("TExceedIDz"+SelectRow)
	if (Obj){TExceedID=Obj.value;}
	if (TExceedID==""){alert("��ѡ��Ҫ���µļ�¼");return;}
    var rtn=tkMakeServerCall("web.DHCDocExceedReason","Update",TExceedID,UpdateStr)
    if(rtn==0){
	    alert("���³ɹ���")
	    location.reload()
	    }
	else {alert("����ʧ��"+rtn)}

}
function Add_click()
{  
	var rtn=CheckData();
    if (!rtn){
	    return false;
    } 
    var ExceedCode="";var ExceedDesc=""; var ExceedType="";
	var ExceedFromDate=""; var ExceedEndDate="";var InsertStr="";
	if (ObjExceedCode){ExceedCode=ObjExceedCode.value};
	if (ObjExceedDesc){ExceedDesc=ObjExceedDesc.value};
	if (ObjExceedType){ExceedType=ObjExceedType.value};
	if (ObjValidSttDate){ExceedFromDate=ObjValidSttDate.value};
	if (ObjValidEndDate){ExceedEndDate=ObjValidEndDate.value};
	InsertStr=ExceedCode+"^"+ExceedDesc+"^"+ExceedType+"^"+ExceedFromDate+"^"+ExceedEndDate
    var rtn=tkMakeServerCall("web.DHCDocExceedReason","Insert",InsertStr)
    if(rtn==0){
	    alert("���ӳɹ���")
        location.reload()
    }
    else
    {
	    alert("����ʧ��"+rtn)
	   }
}

function Delete_click()
{
	var TExceedID=""
	var Obj=document.getElementById("TExceedIDz"+SelectRow)
	if (Obj){TExceedID=Obj.value;}
	if (TExceedID==""){alert("��ѡ����Ҫɾ��������!");return;}
	var rtn=tkMakeServerCall("web.DHCDocExceedReason","Delete",TExceedID)
	if(rtn==0){
		alert("ɾ���ɹ���")
		location.reload();
	}
}
function SaveDate_click()
{
		var OPatDate=0;var EPatDate=0
		var Obj=document.getElementById("OPatDate");
		if (Obj){ if (CheckIsNum(Obj.value)){OPatDate=Obj.value}else{ alert("��������Ч����.");return;}}
		var Obj=document.getElementById("EPatDate");
		if (Obj){ if (CheckIsNum(Obj.value)){EPatDate=Obj.value}else{ alert("��������Ч����.");return;}}
	    var rtn=tkMakeServerCall("web.DHCDocExceedReason","SetExceedDate","O",OPatDate)
	    var rtn=tkMakeServerCall("web.DHCDocExceedReason","SetExceedDate","E",EPatDate)
	    alert("���óɹ���")
	    location.reload();

}

function CheckIsNum(NumStr)
{
for(i=0;i<NumStr.length;i++) 
{ 
	if(NumStr.charAt(i)<"0"||NumStr.charAt(i)>"9")
		{
		return false;
		}
}
return true;
}