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
	
	//��ȡ�������б�
    GetServerList();
 
		
}

function Add_click(e)
{
	var Info;
	var IsFull="",IsOffline="",IsBackup="";
	var MeduimName=document.getElementById("tMeduimName").value;
	
	var Size=document.getElementById("Size").value;

	var iServer=document.getElementById("lServerName").value;
	
	var ckfullobj=document.getElementById("ckFull");
	if (ckfullobj)
	{
		if ((ckfullobj.checked))
		{
			IsFull="Y";
		}
		else
		{
			IsFull="N";
		}
	}
	var ckOfflineobj=document.getElementById("ckOffline");
	if (ckOfflineobj)
	{
		if ((ckOfflineobj.checked))
		{
			IsOffline="Y";
		}
		else
		{
			IsOffline="N";
		}
	}
	
	var ckBackupObj=document.getElementById("ckBackup");
	if (ckBackupObj)
	{
		if ((ckBackupObj.checked))
		{
			IsBackup="Y";
		}
		else
		{
			IsBackup="N";
		}
	}	


	if (MeduimName=="")
	{
		Info="�������Ʋ���Ϊ��";
		alert(Info);
		return ;
	}
	
	var Info=iServer+"^"+MeduimName+"^"+Size+"^"+IsFull+"^"+IsOffline+"^"+IsBackup;
	
	var SaveFunction=document.getElementById("SaveFunction").value;
	var value=cspRunServerMethod(SaveFunction,Info);
	if (value!="0")
	{
		var Info="���ӽ�������ʧ��:SQLCODE="+value;
		alert(Info);
	}
	else
	{
		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisMedium"
   		location.href=lnk;*/
   		window.location.reload(); 
	}
	
	
}
function Delete_click(e)
{
	var SelRowid=document.getElementById("SelRowid").value;
	if (SelRowid=="")
	{
		var Info="��ѡ��Ҫɾ������";
		alert(Info);
		return ;
	}
	var DeleteFunction=document.getElementById("DeleteFunction").value;
	var ret=cspRunServerMethod(DeleteFunction,SelRowid);
	if (ret!="0")
	{
		var Info="ɾ����������ʧ��:SQLCODE="+ret;
		alert(Info);
	}
	else
	{
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisMedium"
   		location.href=lnk; 
	}

	
}

function Modi_click(e)
{
	var Info;
	var IsFull="",IsOffline="",IsBackup="";
	var MeduimName=document.getElementById("tMeduimName").value;
	
	var Size=document.getElementById("Size").value;

	var iServer=document.getElementById("lServerName").value;
	
	var ckfullobj=document.getElementById("ckFull");
	if (ckfullobj)
	{
		if ((ckfullobj.checked))
		{
			IsFull="Y";
		}
		else
		{
			IsFull="N";
		}
	}
	var ckOfflineobj=document.getElementById("ckOffline");
	if (ckOfflineobj)
	{
		if ((ckOfflineobj.checked))
		{
			IsOffline="Y";
		}
		else
		{
			IsOffline="N";
		}
	}
	
	var ckBackupObj=document.getElementById("ckBackup");
	if (ckBackupObj)
	{
		if ((ckBackupObj.checked))
		{
			IsBackup="Y";
		}
		else
		{
			IsBackup="N";
		}
	}	


	if (MeduimName=="")
	{
		Info="�������Ʋ���Ϊ��";
		alert(Info);
		return ;
	}
	
	var SelRowid=document.getElementById("SelRowid").value;
	if (SelRowid=="")
	{
		var Info="��ѡ��ҪҪ�޸Ľ���";
		alert(Info);
		return ;
	}
	
	var Info=iServer+"^"+MeduimName+"^"+Size+"^"+IsFull+"^"+IsOffline+"^"+IsBackup;
	alert(Info);
	var ModiFunction=document.getElementById("ModiFunction").value;
	var value=cspRunServerMethod(ModiFunction,Info,SelRowid);
	if (value!="0")
	{
		var Info="�޸Ľ�������ʧ��:SQLCODE="+value;
		alert(Info);
	}
	else
	{
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisMedium"
   		location.href=lnk; 
	}
	
	
}

//�洢����
function GetServerList()
{
    lServerNameObj=document.getElementById("lServerName");
    if (lServerNameObj)
    {
 		combo("lServerName");
		var GetServerListFunction=document.getElementById("GetServerList").value;
		var Info1=cspRunServerMethod(GetServerListFunction);
    	AddItem("lServerName",Info1);
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
	var objtbl=document.getElementById('tDHCRisMedium');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	

	var MediumName=document.getElementById("Namez"+selectrow).innerText;
	
	
	var Size=document.getElementById("sizez"+selectrow).innerText;
	
	var ServerName=document.getElementById("ServerNamez"+selectrow).innerText;
	var ServerId=document.getElementById("ServerIdz"+selectrow).value;
	
	document.getElementById("tMeduimName").value=MediumName;
	
	document.getElementById("Size").value=Size;
 	
	document.getElementById("lServerName").value=ServerId;
    document.getElementById("lServerName").text=ServerName;
	
	var IsFull=document.getElementById("IsFullz"+selectrow).innerText;
	var ckfullobj=document.getElementById("ckFull");
    if (ckfullobj)
	{	
		if (IsFull=="Y")
		{
			ckfullobj.checked=true;
		}
		else
		{
			ckfullobj.checked=false;
		}
	}
	var IsOffline=document.getElementById("IsOfflinez"+selectrow).innerText;
	var ckOfflineobj=document.getElementById("ckOffline");
	if (ckOfflineobj)
	{
		if (IsOffline=="Y")
		{
			ckOfflineobj.checked=true;
		}
		else
		{
			ckOfflineobj.checked=false;
		}
	}
	
	var IsBackup=document.getElementById("IsBackupz"+selectrow).innerText;	
    	
	var ckBackupObj=document.getElementById("ckBackup");
	if (ckBackupObj)
	{
		if (IsBackup=="Y")
		{
			ckBackupObj.checked=true;
		}
		else
		{
			ckBackupObj.checked=false;
			
		}
	}

	var Rowid= document.getElementById("Rowidz"+selectrow).value;
  
    document.getElementById("SelRowid").value=Rowid;
	   
}




document.body.onload = BodyLoadHandler;


