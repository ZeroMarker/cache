function BodyLoadHandler()
{
	var obj=document.getElementById('deleteppd');
	if (obj) obj.onclick=Delete;
}
function Delete()
{
	var ObjDelete=document.getElementById('Delete').value;
	var idStr="",count=0
	var objtbl=document.getElementById('tGetSkinPPD');	
    var tableRows=objtbl.rows.length;
    for (var i=1;i<tableRows;i++)
	{
		var check=document.getElementById('seleitemz'+i);
		if (check.checked==true){
			count=count+1
			id=document.getElementById('idz'+i).innerText;
			if (idStr=="") {idStr=id}
			else
			{
			idStr=idStr+"^"+id
			}
		}
	}
	if (count==0) 
	{
		alert("请选择记录")
		return;
		}
	var ret=cspRunServerMethod(ObjDelete,idStr);
	if (ret==0)
	{
		alert("删除成功")
		 self.location.reload();
		}
    
	}
document.body.onload = BodyLoadHandler;
