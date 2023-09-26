//DHCRisServerSet.js

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
	
	
	//��ȡ�洢����
    GetStorageType();
 
		
}

function Add_click()
{
	var Info;
	var ServerDesc=document.getElementById("tServer").value;
	
	var IP=document.getElementById("tIP").value;

	var Port=document.getElementById("tPort").value;
	    Port=Number(Port);

	var Type=document.getElementById("tType").value;

	var User=document.getElementById("tUser").value;

	
	var Pwd=document.getElementById("tPwd").value;

	if (ServerDesc=="")
	{
		Info="���������Ʋ���Ϊ��";
		alert(Info);
		return ;
	}
	
	if (IP=="")
	{
		Info="������IP����Ϊ��";
		alert(Info);
		return ;
	
	}
	
	if (Port=="")
	{
		Info="������PORT����Ϊ��";
		alert(Info);
		return ;
	
	}
	

	//�жϷ����������Ƿ��ظ����
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisServerSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
    for (i=1;i<rows;i++)
    {
	    var ServerName=document.getElementById("ServerNamez"+i).value;
	    
	    if (ServerDesc==ServerName)
	    {
		    alert("���������ƴ���,�����ظ����");
		    return;
	    }
	}
	var Info=ServerDesc+"^"+IP+"^"+Port+"^"+Type+"^"+User+"^"+Pwd;
	
	var SaveFunction=document.getElementById("SaveFunction").value;
	var value=cspRunServerMethod(SaveFunction,Info);
	if (value!="0")
	{
		var Info="���ӷ���������ʧ��:SQLCODE="+value;
		alert(Info);
	}
	else
	{
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisServerSet"
   		location.href=lnk; 
	}
	
	
}
function Delete_click()
{
	var SelRowid=document.getElementById("SelRowid").value;
	if (SelRowid=="")
	{
		var Info="��ѡ��Ҫɾ��������";
		alert(Info);
		return ;
	}
	var DeleteFunction=document.getElementById("DeleteFunction").value;
	var ret=cspRunServerMethod(DeleteFunction,SelRowid);
	if (ret!="0")
	{
		var Info="ɾ������������ʧ��:SQLCODE="+ret;
		alert(Info);
	}
	else
	{
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisServerSet"
   		location.href=lnk; 
	}

	
}

function Modi_click()
{
	var Info;
	var ServerDesc=document.getElementById("tServer").value;
	
	var IP=document.getElementById("tIP").value;

	var Port=document.getElementById("tPort").value;
        Port=Number(Port);
        
	var Type=document.getElementById("tType").value;


	var User=document.getElementById("tUser").value;

	
	var Pwd=document.getElementById("tPwd").value;

	if (ServerDesc=="")
	{
		Info="���������Ʋ���Ϊ��";
		alert(Info);
		return ;
	}
	
	if (IP=="")
	{
		Info="������IP����Ϊ��";
		alert(Info);
		return ;
	
	}
	
	if (Port=="")
	{
		Info="������PORT����Ϊ��";
		alert(Info);
		return ;
	
	}
	
	var SelRowid=document.getElementById("SelRowid").value;
	if (SelRowid=="")
	{
		var Info="��ѡ��Ҫ�޸ķ�����";
		alert(Info);
		return ;
	}


	var Info=ServerDesc+"^"+IP+"^"+Port+"^"+Type+"^"+User+"^"+Pwd;

	
	var ModiFunction=document.getElementById("ModiFunction").value;
	var value=cspRunServerMethod(ModiFunction,Info,SelRowid);
	if (value!="0")
	{
		var Info="�޸ķ���������ʧ��:SQLCODE="+value;
		alert(Info);
	}
	else
	{
		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisServerSet"
   		location.href=lnk;*/
   		window.location.reload(); 
	}
	
}

//�洢����
function GetStorageType()
{
    tTypeObj=document.getElementById("tType");
    if (tTypeObj)
    {
 		combo("tType");
		var GetStoreageInfoFunction=document.getElementById("GetStoreageInfo").value;
		var Info1=cspRunServerMethod(GetStoreageInfoFunction);
    	AddItem("tType",Info1);
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
	var objtbl=document.getElementById('tDHCRisServerSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	var ServerName=document.getElementById("ServerNamez"+selectrow).innerText;

	var Ip=document.getElementById("IPz"+selectrow).innerText;
	var Port=document.getElementById("Portz"+selectrow).innerText;
	var User=document.getElementById("Userz"+selectrow).innerText;
	var Type=document.getElementById("Typez"+selectrow).innerText;
	var Pwd=document.getElementById("Passwordz"+selectrow).innerText;
	var Rowid= document.getElementById("Rowidz"+selectrow).value;

	
	document.getElementById("tServer").value=ServerName;
	
	document.getElementById("tIP").value=Ip;

	document.getElementById("tPort").value=Port;
	
	
	document.getElementById("tType").text=Type;
	if (Type=="һ������")
	{
		document.getElementById("tType").value="1";
	}
	else
	{
		document.getElementById("tType").value="2";
	}
	
	
	
	

	document.getElementById("tUser").value=User;

	document.getElementById("tPwd").value=Pwd;

    document.getElementById("SelRowid").value=Rowid;
    
	
}




document.body.onload = BodyLoadHandler;


