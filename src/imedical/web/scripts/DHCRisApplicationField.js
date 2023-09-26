
//DHCRisApplicationField.js
//2011-10-18 sunyi
var CurrentSel=0,TypeIndex

function BodyLoadHandler()
{

	var AddObj=document.getElementById("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click;
	}
	
	var ModiObj=document.getElementById("Update");
	if (ModiObj)
	{
		ModiObj.onclick=Update_click;
	}
	
	var DeleteObj=document.getElementById("Delete");
	if (DeleteObj)
	{
		DeleteObj.onclick=Delete_click;
	}
	
	var QueryObj=document.getElementById("Query");
	if(QueryObj)
	{
		QueryObj.onclick=Query_click;
	}

	GetFiledType();

}

function Add_click()
{
	 var OperateCode="I";
	 var Rowid="";
	 var Desc=document.getElementById("Desc").value;
	 var Type=document.getElementById("Type").value;
	 if(Desc=="")
        {
           alert("字段名称不能为空!");
           return;
         }	 
	 
	 if(Type=="")
	 {
		 alert("类型不能为空!");
		 return;
	 }
	 
	 
	 var Content=document.getElementById("Content").value;
	 var Option=document.getElementById("Option").value;
	 var Width=document.getElementById("Width").value;
	 var Height=document.getElementById("Height").value;
	  
	 if (document.getElementById("Require").checked)
     {
  	     var Require="1";
     }
     else
     {
  	     var Require="0";
     }
	 var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisApplicationField');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	for (i=1;i<rows;i++)
    {   
	    //var ItemCatDesc=document.getElementById("ItemCatz"+i).innerText;
	    var DescL=document.getElementById("TDescz"+i).innerText;
	var TypeL=document.getElementById("TTypez"+i).innerText;
	    //alert(ItmMastDesc)
	    if ((DescL==Desc)||(TypeL==Type))
	    {
		    alert("该记录已存在,不能重复添加");
		    return;
	    }
	}
    
	 var Info=Rowid+"^"+Desc+"^"+Type+"^"+Content+"^"+Option+"^"+Require+"^"+Width+"^"+Height;
	 SetApplicationField(Info,OperateCode);
}



function Update_click()
{
	
	 var OperateCode="U";
	 var SelRowid=document.getElementById("SelRowid").value;
	
	 if (SelRowid=="")
	 {
		alert("未选择记录不能更新!")
		return;
		
	 }
	
	 var Desc=document.getElementById("Desc").value;
	 var Type=document.getElementById("Type").value;
	 
	 if(Type=="")
	 {
		 alert("类型不能为空!");
		 return;
	 }
	 
	 
	 var Content=document.getElementById("Content").value;
	 var Option=document.getElementById("Option").value;
	 var Width=document.getElementById("Width").value;
	 var Height=document.getElementById("Height").value;
	  
	 if (document.getElementById("Require").checked)
	 {
	     var Require="1";
	 }
	 else
	 {
	     var Require="0";
	 }
	 
	
	 var Info=SelRowid+"^"+Desc+"^"+Type+"^"+Content+"^"+Option+"^"+Require+"^"+Width+"^"+Height;
	 SetApplicationField(Info,OperateCode);
	
}




function Delete_click()
{
    var OperateCode="D"
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("未选择记录不能删除!")
		return;
		
	}
	
	var str="^^^^^^^";
    var Info=SelRowid+str;
    SetApplicationField(Info,OperateCode);
	
}


function Query_click()
{
	var Desc=document.getElementById("Desc").value;
	var Type=document.getElementById("Type").value;
	var Info=Desc+"^"+Type;
	document.getElementById("Info").value=Info;
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisApplicationField"+"&Info="+Info;
	
}


function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisApplicationField');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;

    
 	var SelRowid=document.getElementById("TRowidz"+selectrow).value;
	var Desc=document.getElementById("TDescz"+selectrow).innerText;
	var Type=document.getElementById("TTypez"+selectrow).innerText;
	var Content=document.getElementById("TContentz"+selectrow).innerText;
	var Option=document.getElementById("TOptionz"+selectrow).innerText;
	var Require=document.getElementById("TRequirez"+selectrow).innerText;
	var Width=document.getElementById("TWidthz"+selectrow).innerText;
	var Height=document.getElementById("THeightz"+selectrow).innerText;
	
	
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
	}
	
	var DescObj=document.getElementById("Desc");
	if (DescObj)
	{
		DescObj.value=Desc;
	}
	var TypeObj=document.getElementById("Type");
	if (TypeObj)
	{
		TypeObj.value=Type;
		TypeObj.text=Type;
	}
	var ContentObj=document.getElementById("Content");
	if (ContentObj)
	{
		ContentObj.value=Content;
	}
	var OptionObj=document.getElementById("Option");
	if (OptionObj)
	{
		OptionObj.value=Option;
	}
	
	var RequireObj=document.getElementById("Require");
	if (RequireObj)
	{
		RequireObj.value=Require;
		if (RequireObj.value=="1")
        {
  	       RequireObj.checked=true;
  	    }
        else
        {
  	       RequireObj.checked=false;
        }
	}
	
	var WidthObj=document.getElementById("Width");
	if (WidthObj)
	{
		WidthObj.value=Width;
	}
	var HeightObj=document.getElementById("Height");
	if (HeightObj)
	{
		HeightObj.value=Height;
	}
	
	
}




function SetApplicationField(Info,OperateCode)
{
	var SetApplicationFieldFun=document.getElementById("SetApplicationField").value;
	var value=cspRunServerMethod(SetApplicationFieldFun,Info,OperateCode);
	if (value!="0")
	{  
	     if(OperateCode=="I")
	     {
		    var Info="增加失败:SQLCODE="+value;
		 }
	     if(OperateCode=="U")
	     {
		    var Info="更新失败:SQLCODE="+value;
		 }
		 else
		 {
			var Info="删除失败:SQLCODE="+value;
	     }	 
		
	     alert(Info);
	}
	else
	{   
		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisApplicationField";
   		location.href=lnk;*/
   		window.location.reload(); 
	}
	
}

function GetFiledType()
{
	TypeObj=document.getElementById("Type");
    if (TypeObj)
    {
	 	combo("Type");
	}
}

function InitInstance()
{
	var Temp="^ListBox^CheckBox^TextBox^Query"
	var TypeObj=document.getElementById("Type");
	
	if(TypeObj)
	{
		TypeObj.onchange=OnChangeType;
		combo("Type");
		AddItem("Type",Temp);
		
		var SelectInfoObj=document.getElementById("SelType");
	    var SelectInfo;
	   	
		if (SelectInfoObj)
		{
			SelectInfo=SelectInfoObj.value;
		}
	    if (SelectInfo!="")
		{
			var item=SelectInfo.split("^");
			TypeObj.selectedIndex=item[1];
			TypeObj.options[TypeObj.selectedIndex].innerText=item[0];
		}
	
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
	 	perInfo=ItemInfo[i].split(String.fromCharCode(1));
	 	var sel=new Option(perInfo[0],perInfo[1]);
		Obj.options[Obj.options.length]=sel;
	} 
}


function OnChangeType()
{
	TypeObj=document.getElementById("Type");
		
	var selectIndex=TypeObj.selectedIndex;
	var Type=TypeObj.options[TypeObj.selectedIndex].innerText;
	var SelectInfoObj=document.getElementById("SelType");
		
	if (SelectInfoObj)
	{
		SelectInfoObj.value=Type+"&"+selectIndex
	}

}



document.body.onload = BodyLoadHandler;
