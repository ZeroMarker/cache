var SelectedRow = 0;
var SelectRow = 0;
var rowid=0;
var paths,remarks,rows;

function BodyLoadHandler() 
{
	InitUserInfo();
	if (1==GetElementValue("ReadOnly"))
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BUpload",true);	
	}
	InitButton(false);
	SetPictsData();
}

function InitButton(isselected)
{
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
	var obj=document.getElementById("BView");
	if (obj) obj.onclick=BView_Click;
	DisableBElement("BView",!isselected);
	
	if (1==GetElementValue("ReadOnly")) return;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;	
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;	
	var obj=document.getElementById("BUpload");
	if (obj) obj.onclick=BUpload_Click;
	
	DisableBElement("BAdd",isselected);
	DisableBElement("BUpdate",!isselected);
	DisableBElement("BDelete",!isselected);	
	//DisableBElement("BUpload",!isselected);	
}

function Selected(selectrow)
{
	SelectRow=selectrow;
	if (SelectedRow==selectrow)	{	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		InitButton(false);
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetElement("RowID",rowid);
		//Add By DJ 2014-10-15	非同一来源的不可以删除 DJ0129
		var TOriginalTypeDR=GetElementValue("TOriginalTypeDRz"+SelectedRow);
		var OriginalType=GetElementValue("OriginalType");
		if (TOriginalTypeDR==OriginalType)
		{
			InitButton(true);
		}
		else
		{
			InitButton(false);
		}
		}
}

function BAdd_Click() 
{
	if (CheckSaveData()) return;
	SaveData(0);
}

function BUpdate_Click() 
{
	if (CheckSaveData()) return;
	SaveData(0);
}

function CheckSaveData()
{
	if (CheckMustItemNull()) return true;
	/*
	if (GetElementValue("Path")=="") return false;
	if (GetElementValue("Remark")=="") return false;
	*/
	return false;
}

function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="")	{
		alertShow(t['04']);
		return;
	}
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
    SaveData(1);
}

function BClose_Click() 
{
	window.close();
}


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	Selected(selectrow);
}

function SaveData(isDel)
{
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	
	var result=cspRunServerMethod(encmeth,GetElementValue("User"),GetElementValue("RowID"),"",isDel);
	if (result>0)
	{	location.reload();	}
}

function SetPictsData()
{
	var SelRowObj;
	var objtbl=document.getElementById('tDHCEQAppendFile');
	rows=objtbl.rows.length;
	paths="";
	remarks="";
	for (var i=1;i<rows;i++)
	{
		paths=paths+","+GetElementValue('TFileNamez'+i);
		remarks=remarks+","+GetCElementValue('TDocNamez'+i);
	}
	rows=rows-1;
}



function BUpload_Click()
{
	var lnk='dhceqappendfile.csp?&User='+GetElementValue("User")+'&OriginalType='+GetElementValue("OriginalType")+'&OriginalID='+GetElementValue("OriginalID");
	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,width=600,height=240,left=120,top=100')
	///window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');	
}


function BView_Click()
{
	var row=SelectedRow	
	var path=GetElementValue('TFileNamez'+row);
	
	var remark=GetCElementValue('TDocNamez'+row);
	var height=screen.availHeight;
	var width=screen.availwidth;
	var lnk='dhceqviewfile.csp?&Paths='+paths+'&Remarks='+remarks+'&Rows='+rows+'&Row='+row+'&Path='+path+'&Remark='+remark;
	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left=0,top=0');	
}

document.body.onload = BodyLoadHandler;
