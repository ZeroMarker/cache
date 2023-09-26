var currRow;
var Rowid="";
var Code="";
var Desc="";

function BodyLoadHandler()
{
  var obj=document.getElementById("Add")
  if (obj) obj.onclick=AddReason;
  var obj=document.getElementById("Delete")
  if (obj) obj.onclick=DeleteReason;
  var obj=document.getElementById("Modify")
  if (obj) obj.onclick=ModifyReason;
	}
function AddReason()
{
	Rowid=""
	Code=""
	Desc=""

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.drugrefusereasonAdd&Rowid="+Rowid+"&Code="+Code+"&Desc="+Desc
	window.open(lnk,"_blank","height=50,width=500,menubar=no,status=no,toolbar=no,resizable=yes") ;

}

function ModifyReason()
{
	if (currRow>0) 
	{
	 var obj=document.getElementById("Rowid"+"z"+currRow);
	 if (obj) Rowid=obj.value
	 var obj=document.getElementById("Code"+"z"+currRow);
	 if (obj) Code=obj.innerText
	 var obj=document.getElementById("Desc"+"z"+currRow);
	 if (obj) Desc=obj.innerText
	 
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.drugrefusereasonAdd&Rowid="+Rowid+"&Code="+Code+"&Desc="+Desc
	window.open(lnk,"_blank","height=50,width=500,menubar=no,status=no,toolbar=no,resizable=yes") ;
	}
	else
	{	Rowid=""
		Code=""
		Desc=""
		alert("请选择要修改的记录！")
	} 
	
	
}

function DeleteReason()
{
	var exe;
	if (currRow>0)
	{
		var obj=document.getElementById("Rowid"+"z"+currRow);
		if (obj) 
		{	
			Rowid=obj.value;
		}
		var obj=document.getElementById("mDelete");
		if (obj) exe=obj.value;
		else  exe=""

		var result=cspRunServerMethod(exe,Rowid)
		self.location.reload();
	}
}
function SelectRowHandler()
{
	currRow=selectedRow(window)
}
document.body.onload=BodyLoadHandler