function BodyLoadHandler() 
{
	InitUserInfo();
	InitStandardKeyUp();
	if (1==GetElementValue("ReadOnly"))
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
	}	
	InitButton(false);
	//initButtonWidth()  //hisui改造：修改界面按钮长度不一致 add by czf2018-08-31
	initPanelHeaderStyle();
	initButtonColor();//cjc 2023-01-18 设置极简积极按钮颜色
	hidePanelTitle();//cjc 2023-02-01 隐藏标题面版
}

function InitButton(isselected)
{
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
	
	if (1==GetElementValue("ReadOnly")) return;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;	
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;	
	DisableBElement("BAdd",isselected);
	DisableBElement("BUpdate",!isselected);
	DisableBElement("BDelete",!isselected);
}
var SelectedRow = -1;	//HISUI改造 modified by czf 20180831
var rowid=0;
function Selected(selectrow)
{
	if (SelectedRow==selectrow)	{	
		Clear();	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		InitButton(false);
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetElement("RowID",rowid);
		SetData(rowid);
		InitButton(true);
		}
}

function BAdd_Click() 
{
	SaveData();
}

function BUpdate_Click() 
{
	SaveData();
}

function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="")	{
		messageShow("","","",t['04']);
		return;
	}
	//modified by CZF0105 20200409
	messageShow("confirm","info","提示",t['03'],"",function(){
		var encmeth=GetElementValue("GetUpdate");
		if (encmeth=="")
		{
			messageShow("","","",t[-4001]);
			return;
		}
		var result=cspRunServerMethod(encmeth,'','',rowid+"^"+GetElementValue("EquipDR"),GetElementValue("CheckListDR"),'1'); //2009-08-20 党军
		if (result>0)
		{	location.reload();	}
	},function(){
		return;
	});
}


function BClose_Click() 
{
	//window.close();
	//websys_showModal("close");  //HISUI改造 modified by czf 20181029
	closeWindow('modal');
}

function GetDocOriginalID(value)
{
	GetLookUpID('DocOriginalDR',value);
}
function GetDocType(value)
{
	GetLookUpID('DocTypeDR',value);
}
function GetLocID(value)
{
	GetLookUpID('LocDR',value);
}

function GetManagerID(value)
{
	GetLookUpID('ManagerDR',value);
}

function CombinData() //2009-08-20 党军
{
	var combindata="";
	combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("EquipDR") ; 
	combindata=combindata+"^"+GetElementValue("DocOriginalDR") ;
  	combindata=combindata+"^"+GetElementValue("DocName") ;
  	combindata=combindata+"^"+GetElementValue("LocDR") ;
  	combindata=combindata+"^"+GetElementValue("ManagerDR") ;
  	combindata=combindata+"^"+GetElementValue("ShareNum") ;
  	combindata=combindata+"^"+GetElementValue("PagesNum") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("DocTypeDR") ;
  	//messageShow("","","",GetElementValue("DocTypeDR"))
  	return combindata;
}
///HISUI改造 add by czf 20180831
function SelectRowHandler(index,rowdata)	{
	if (index==SelectedRow){
		Clear();
		SelectedRow= -1;
		rowid=0;
		SetElement("RowID","");
		InitButton(false);//灰化
		$('#tDHCEQDoc').datagrid('unselectAll'); //modified by sjh SJH0044 2020-01-18
		return;
		}
	rowid=rowdata.TRowID;
	if (rowid=="") return;
	SetElement("RowID",rowid);
	SetData(rowid); 
	InitButton(true);//反灰化  
    SelectedRow = index;
}
/*
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQDoc');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

//messageShow("","","",selectrow+"/"+rows)

	if (!selectrow) return;
	Selected(selectrow);
}*/

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		messageShow("","","",t[-4001]);
		return;
	}
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	var sort=18 //2009-08-20 党军
	SetElement("DocOriginalDR",list[0]);
	SetElement("DocOriginal",list[sort+0]);
	SetElement("DocName",list[1]);
	SetElement("LocDR",list[2]);
	SetElement("Loc",list[sort+1]);
	SetElement("ManagerDR",list[3]);
	SetElement("Manager",list[sort+2]);
	SetElement("ShareNum",list[4]);
	SetElement("PagesNum",list[5]);
	SetElement("Remark",list[6]);
	SetElement("AddUserDR",list[7]);
	SetElement("AddUser",list[sort+3]);
	SetElement("AddDate",list[8]);
	SetElement("AddTime",list[9]);
	SetElement("UpdateUserDR",list[10]);
	SetElement("UpdateUser",list[sort+4]);
	SetElement("UpdateDate",list[11]);
	SetElement("UpdateTime",list[12]);
	//SetElement("EquipDR",list[13]); //2009-08-20 党军
	SetElement("Equip",list[sort+5]);
	SetElement("DocTypeDR",list[14]);
	SetElement("DocType",list[sort+6]);
}

function SaveData()
{
	if (CheckMustItemNull()) return ;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		messageShow("","","",t[-4001]);
		return;
	}
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,'','',plist,GetElementValue("CheckListDR"),'0'); //2009-08-20 党军
	if (result>0)
	{
		//add by HHM 20150910 HHM0013
		//添加操作成功是否提示
		ShowMessage();
		//****************************
		location.reload();
	}
	//2010-06-11 党军 begin
	if (result==-99)
	{
		alertShow("数据重复!请检查!")
		return
	}
	if (result<0)
	{
		alertShow("操作失败!")
		return
	}
	//2010-06-11 党军 end
}

function InitStandardKeyUp()
{
	KeyUp("DocOriginal^DocType^Loc^Manager^Equip","N");
	Muilt_LookUp("DocOriginal^DocType^Loc^Manager^Equip");
	return;
	var obj=document.getElementById("DocOriginal");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("DocType");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Loc");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Manager");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("AddUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("UpdateUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Equip");
	if (obj) obj.onkeyup=Standard_KeyUp;
}

function Clear()
{
	SetElement("RowID","");
	SetElement("DocOriginal","");
	SetElement("DocOriginalDR","");
	SetElement("DocName","");
	SetElement("Loc","");
	SetElement("LocDR","");
	SetElement("Manager","");
	SetElement("ManagerDR","");
	SetElement("ShareNum","");
	SetElement("PagesNum","");
	SetElement("Remark","");
	SetElement("AddUser","");
	SetElement("AddUserDR","");
	SetElement("AddDate","");
	SetElement("AddTime","");
	SetElement("UpdateUser","");
	SetElement("UpdateUserDR","");
	SetElement("UpdateDate","");
	SetElement("UpdateTime","");
	SetElement("Equip","");
	//SetElement("EquipDR",""); //modified by sjh SJH0045 2020-01-28
	SetElement("DocType","");//add by HHM 20150914 HHM0020
}

document.body.onload = BodyLoadHandler;
