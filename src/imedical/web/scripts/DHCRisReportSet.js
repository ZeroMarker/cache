//DHCRisReportSet.js

function BodyLoadHandler()
{
	var AddObj=document.getElementById("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click;
	}
	
	var DeleteObj=document.getElementById("Delete");
	if (DeleteObj)
	{
		DeleteObj.onclick=Delete_click;
	}
	
	var ModiObj=document.getElementById("Modi");
	if (ModiObj)
	{
		ModiObj.onclick=Modi_click;
	}
	
	var AddLocObj=document.getElementById("AddLoc");
	if (AddLocObj)
	{
		AddLocObj.onclick=AddLoc_click;
	}
	var DeleteLocObj=document.getElementById("DeleteLoc");
	if (DeleteLocObj)
	{
		DeleteLocObj.onclick=DeleteLoc_click;
	}
	
	
	//��ѯ���еĿ���    
    QueryLoc();
}



function AddLoc_click()
{
	var SelLocObj=document.getElementById("SelLoc");
	if (SelLocObj)
	{
		var LocId=SelLocObj.value;
		var SelRowid=document.getElementById("SelRowid").value;
		
		var LocName=SelLocObj.text;
		var Info="^"+LocId+"^"+SelRowid;
		
	    var SaveFunction=document.getElementById("SetLocShapeFunction").value;
		var value=cspRunServerMethod(SaveFunction,Info,"I");
		if (value=="0")
		{
			alert("���Ӷ�Ӧ���ҳɹ�");
		  	GeLocByShapId(SelRowid);
		}
		else
		{
			alert("���Ӷ�Ӧ����ʧ��");
	
		}
		  
	}

	
}

function DeleteLoc_click()
{
	
		var SelLocListOBJ=document.getElementById("SelLocList");
		if (SelLocListOBJ)
		{
			var nIndex=SelLocListOBJ.selectedIndex;
			if (nIndex==-1) return;
			var value=SelLocListOBJ.options[nIndex].value;
			var item=value.split(":");
			var rowid=item[0];
			var LocId=item[1];
			var Info=rowid+"^"+LocId+"^";
			
			var SaveFunction=document.getElementById("SetLocShapeFunction").value;
			var value=cspRunServerMethod(SaveFunction,Info,"D");
			if (value=="0")
			{
				alert("ɾ����Ӧ���ҳɹ�");
				//��ȡ��Ӧ�Ŀ���
				var SelRowid=document.getElementById("SelRowid").value;
		    	GeLocByShapId(SelRowid);
		    	
    

			}
			else
			{
				alert("ɾ����Ӧ����ʧ��");
			}
		}
	
	
	
}


function Add_click()
{
	var Info;

	
	var Shape=document.getElementById("tReportShapName").value;
	
	var File=document.getElementById("tFileName").value;

	var TableName=document.getElementById("tTableName").value;
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisReportSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

for (i=1;i<rows;i++)
    {   
	    //var ItemCatDesc=document.getElementById("ItemCatz"+i).innerText;
	    var ShapeL=document.getElementById("ReportShapez"+i).innerText;
	    var FileL=document.getElementById("ReportFileNamez"+i).innerText;
	    //alert(ItmMastDesc)
	    if ((ShapeL==Shape)||(FileL==File))
	    {
		    alert("������ʽ�Ѵ���,�����ظ����");
		    return;
	    }
	}


	if (Shape=="")
	{
		Info="��ʽ���Ʋ���Ϊ��";
		alert(Info);
		return ;
	}
	
	var Info=""+"^"+Shape+"^"+File+"^"+TableName;
	
	var SaveFunction=document.getElementById("SetFunction").value;
	var value=cspRunServerMethod(SaveFunction,Info,"I");
	if (value!="0")
	{
		var Info="���ӱ�����ʽʧ��:SQLCODE="+value;
		alert(Info);
	}
	else
	{
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisReportSet"
   		location.href=lnk; 
	}
	
	
}
function Delete_click()
{
	var Info;

	var SelRowid=document.getElementById("SelRowid").value;
	
	var Shape=document.getElementById("tReportShapName").value;
	
	var File=document.getElementById("tFileName").value;

	var TableName=document.getElementById("tTableName").value;
	

	if (Shape=="")
	{
		Info="��ʽ���Ʋ���Ϊ��";
		alert(Info);
		return ;
	}
	
	var Info=SelRowid+"^"+Shape+"^"+File+"^"+TableName;
	
	var SaveFunction=document.getElementById("SetFunction").value;
	var value=cspRunServerMethod(SaveFunction,Info,"D");
	if (value!="0")
	{
		var Info="ɾ��������ʽʧ��,����ɾ����������";
		alert(Info);
	}
	else
	{
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisReportSet"
   		location.href=lnk; 
	}
	
	
}

function Modi_click()
{
	var Info;

	var SelRowid=document.getElementById("SelRowid").value;
	
	var Shape=document.getElementById("tReportShapName").value;
	
	var File=document.getElementById("tFileName").value;

	var TableName=document.getElementById("tTableName").value;
	

	if (Shape=="")
	{
		Info="��ʽ���Ʋ���Ϊ��";
		alert(Info);
		return ;
	}
	
	var Info=SelRowid+"^"+Shape+"^"+File+"^"+TableName;
	
	var SaveFunction=document.getElementById("SetFunction").value;
	var value=cspRunServerMethod(SaveFunction,Info,"U");
	if (value!="0")
	{
		var Info="���ӱ�����ʽʧ��:SQLCODE="+value;
		alert(Info);
	}
	else
	{
		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisReportSet"
   		location.href=lnk;*/
   		window.location.reload(); 
	}	
}

// ��ѯ���еĿ���
function QueryLoc()
{
    SelLocObj=document.getElementById("SelLoc");
    if (SelLocObj)
    {
 		combo("SelLoc");
		var GetAllLocFunction=document.getElementById("GetAllLoc").value;
		var Info1=cspRunServerMethod(GetAllLocFunction,"");
    	AddItem("SelLoc",Info1);
    }
}



function combo(cmstr)
{
	var obj=document.getElementById(cmstr);
	obj.size=1; 
	obj.multiple=false;
}

function AddItem(ObjName, Info)
{
	var Obj=document.getElementById(ObjName);
    if (Obj.options.length>0)
 	{
		for (var i=Obj.options.length-1; i>=0; i--) Obj.options[i] = null;
	}
	
    var ItemInfo=Info.split("^");
 	for (var i=0;i<ItemInfo.length;i++)
 	{
	 	perInfo=ItemInfo[i].split(String.fromCharCode(1))
	 	var sel=new Option(perInfo[1],perInfo[0]);
		Obj.options[Obj.options.length]=sel;
	} 
}


function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisReportSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	var Shape=document.getElementById("ReportShapez"+selectrow).innerText;

	var File=document.getElementById("ReportFileNamez"+selectrow).innerText;
	var Table=document.getElementById("TableNamez"+selectrow).innerText;
	var Rowid= document.getElementById("Rowidz"+selectrow).value;

	
	document.getElementById("tReportShapName").value=Shape;
	
	document.getElementById("tFileName").value=File;

	document.getElementById("tTableName").value=Table;

    document.getElementById("SelRowid").value=Rowid;
    
    //��ȡ��Ӧ�Ŀ���
    GeLocByShapId(Rowid);
    
	
}

function GeLocByShapId(ShapeId)
{
	    //��ȡ��Ӧ�Ŀ���
    var GetLocByShapeIdFunction=document.getElementById("GetLocByShapeId").value;

	var Info1=cspRunServerMethod(GetLocByShapeIdFunction,ShapeId);
	
	AddItem("SelLocList",Info1);

	
	
}




document.body.onload = BodyLoadHandler;


