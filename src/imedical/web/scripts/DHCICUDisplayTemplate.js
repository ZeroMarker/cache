var preSelectRow=-1;
var selectRow=0;
function BodyLoadHandler()
{
	var obj=document.getElementById("Modify");
	if (obj) obj.onclick=Update_click;
	var obj=document.getElementById("Remove");
	if (obj) obj.onclick=Delete_click;
	var obj=document.getElementById("Add");
	if (obj) obj.onclick=Add_click;
}
//添加
function Add_click() 
{
	var elDeptID=document.getElementById("DeptID");
	var deptID="";
	if(elDeptID)
	{
		deptID=elDeptID.value;
    }
    
    var elTemplateName=document.getElementById("TemplateName");
    var templateName="";
    if(elTemplateName)
    {
		templateName=elTemplateName.value;    
	}
	
	var elTemplate=document.getElementById('AddTemplate');
	if(elTemplate) 
	{  
		retStr=cspRunServerMethod(elTemplate.value,deptID,templateName);
		if (retStr!=0) alert(retStr);
		else 
		{
			alert("成功添加!");
			self.location.reload();
		}
	}
}

function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCICUDisplayTemplate');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	selectRow=rowObj.rowIndex;
	if (!selectRow) return;
	var ctlocId="";
	if (preSelectRow!=selectRow)
	{
		SetElementByElement('TemplateName',"V",'TTemplateNamez'+selectRow,"I"," ","");
		SetElementByElement("Department","V", "TDeptNamez" + selectRow,"I"," ","");
	    SetElementByElement("TemplateID","V", "TIDz" + selectRow,"I"," ","");
	    SetElementByElement("DeptID","V", "TDeptIDz" + selectRow,"I"," ","");

		preSelectRow = selectRow;
		ctlocId=document.getElementById('DeptID').value;
	}
	else
	{
		SetElementValue('TemplateName',"V","");
		SetElementValue("Department","V", "");
	    SetElementValue("TemplateID","V","");
	    SetElementValue("DeptID","V","");
		preSelectRow=-1
		selectRow=0
		parent.frames['RPBottom'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCICUDisplayProperties&DisplayItemID="; 
	}
	parent.frames['RPMiddle'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCICUDisplayItems&ctlocId="+ctlocId; 
}

function Update_click()
{
    if (selectRow < 1) return;
    var elTemplateID = document.getElementById("TemplateID").value;
    var elDeptID = document.getElementById("DeptID").value;
    var elTemplateName = document.getElementById("TemplateName").value;
	var obj=document.getElementById('ModifyTemplate');
	if(obj) 
	{
	    retStr = cspRunServerMethod(obj.value, elTemplateID, elDeptID, "", elTemplateName);
		if (retStr!=0) alert(retStr);
		else 
		{
			alert("成功修改!");
			self.location.reload();
		}
	}
}
function GetAppLoc(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("Department")
	if (obj){obj.value=loc[1]}
	var objLocId=document.getElementById("DeptID")
	if(objLocId) {objLocId.value=loc[0];}
	LocId=loc[0];
}

function Delete_click()
{
	if (selectRow<1) return;
	var elTemplateID = document.getElementById("TemplateID").value;
	var obj=document.getElementById('RemoveTemplate')
	if(obj) 
	{
	    retStr = cspRunServerMethod(obj.value, elTemplateID);
		if (retStr!=0) alert(retStr);
		else 
		{
			alert("删除成功!");
			self.location.reload();
		}
	}
}
document.body.onload=BodyLoadHandler;
