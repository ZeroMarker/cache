//modified by GR 2014-09-24 2961 解决提示信息不准确问题
//修改位置BUpdate_Click() 
//----------------------------------------------------------
//设备机型
var SelectedRow = -1;
var rowid=0;
var HospFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990051")

///modify by jyp 2018-08-16 Hisui改造：添加initButtonWidth()方法控制按钮长度
function BodyLoadHandler() 
{
	initPanelHeaderStyle();
	initButtonColor();
	InitUserInfo(); //系统参数
	InitPage();	    ///modify by jyp 2018-08-16 Hisui改造：HisUI改造-界面调整后，datagrid行选择事件的参数发生变化、界面数据不能正常填充
	disabled(true);//灰化
	//modified by cjt 20230324 需求号3221868 注释initButtonWidth
	//initButtonWidth()  ///add by jyp 2018-08-16 Hisui改造：添加initButtonWidth()方法控制按钮长度
	initBDPHospComponent("DHC_EQCEquipType");	//CZF0138 多院区改造
}

//CZF0138 平台医院组件选择事件
function onBDPHospSelectHandler()
{
	BClear_Click();
	initEquipTypeGrid();
}

//CZF0138
function initEquipTypeGrid()
{
	var HospDR=GetBDPHospValue("_HospList");
	$("#tDHCEQCEquipType").datagrid( {
		url:$URL,
		queryParams:{
			ComponentID:GetElementValue("GetComponentID"),
			gHospId:curSSHospitalID,
			BDPHospId:HospDR
		},
		showRefresh:false,
		showPageList:false,
		afterPageText:'',
		beforePageText:''
	})
}

///modify by jyp 2018-08-16 Hisui改造：HisUI改造-界面调整后，datagrid行选择事件的参数发生变化、界面数据不能正常填充
function InitPage()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("Code") ;
  	combindata=combindata+"^"+GetElementValue("Desc") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetChkElementValue("InvalidFlag") ;
  	combindata=combindata+"^"+GetElementValue("EQType") ;
  	combindata=combindata+"^"+GetChkElementValue("EQFlag") ;
  	combindata=combindata+"^"+GetElementValue("MinPrice") ;
  	combindata=combindata+"^"+GetElementValue("MaxPrice") ;	
  	combindata=combindata+"^"+GetElementValue("Hold1") ; //Modifeid by HHM 20150917 HHM0021
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("Hold3") ;
  	combindata=combindata+"^"+GetElementValue("Hold4") ;
  	combindata=combindata+"^"+GetElementValue("Hold5") ;
  	return combindata;
}
function BUpdate_Click() 
{
	///add by ZY0304 20220616
	if (!charLegalCheck("Code^Desc")) return true;
	
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var gHospId=curSSHospitalID;
	var BDPHospId=GetBDPHospValue("_HospList");
	var result=cspRunServerMethod(encmeth,plist,"",gHospId,BDPHospId);
	if(result<0) 
	{
		messageShow("","","",t[result]);
		return
	}
	if (result>0)
	{
		alertShow("操作成功!")
		//location.reload();
		$('#tDHCEQCEquipType').datagrid('reload');		//czf 2176487
		Clear();
		disabled(true);
	}	
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		messageShow("","","",t[-3001])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1',curSSHospitalID,GetBDPHospValue("_HospList"));
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("删除成功!")
		//location.reload();
		$('#tDHCEQCEquipType').datagrid('reload');	//czf 2176487
		Clear();
		disabled(true);
	}	
}
///选择表格行触发此方法
///begin add by jyp 2018-08-16 Hisui改造：HisUI改造-界面调整后，datagrid行选择事件的参数发生变化、界面数据不能正常填充
function SelectRowHandler(index,rowdata){
	if (index==SelectedRow){
		Clear();
		SelectedRow= -1;
		ChangeStatus(false);
		$('#tDHCEQCEquipType').datagrid('unselectAll'); 
		return;
		}
	ChangeStatus(true);
	SetData(rowdata.TRowID);    
    SelectedRow = index;
}
function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
}
///end add by jyp 2018-08-16 Hisui改造：HisUI改造-界面调整后，datagrid行选择事件的参数发生变化、界面数据不能正常填充
/*
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCEquipType');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	
	{
		Clear();
		disabled(true);//灰化	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		disabled(false);//反灰化
	}
}
*/
///end add by jyp 2018-08-16 Hisui改造：HisUI改造-界面调整后，datagrid行选择事件的参数发生变化、界面数据不能正常填充
function Clear()
{
	SetElement("RowID","")
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Remark","");
	SetElement("InvalidFlag","");
	SetElement("EQType","");
	SetElement("EQFlag","");
	SetElement("MinPrice","");
	SetElement("MaxPrice","");
	SetElement("Hold1","");
	SetElement("Hold1Desc","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("RowID",list[0])
	SetElement("Code",list[1]); 
	SetElement("Desc",list[2]);
	SetElement("Remark",list[3]);
	SetElement("InvalidFlag",list[4]);
	SetElement("EQType",list[5]);
	SetChkElement("EQFlag",list[6]);	// 2012-5-31	Mozy0083
	SetElement("MinPrice",list[7]);
	SetElement("MaxPrice",list[8]);
	SetElement("Hold1",list[9]);
	SetElement("Hold1Desc",list[14]);    //13+1
	SetElement("Hold2",list[10]);
	SetElement("Hold3",list[11]);
	SetElement("Hold4",list[12]);
	SetElement("Hold5",list[13]);
}
function disabled(value)//灰化
{
	InitPage();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}
//add by HHM 20150917 HHM0021
function GetFinanceType(value)
{
	var val=value.split("^");
	var obj=document.getElementById("Hold1");	
	if (obj) obj.value=val[0];
	var obj=document.getElementById("Hold1Desc");
	if (obj) obj.value=val[2];
}	
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	var minPrice=parseFloat(GetElementValue("MinPrice"));  //modified by kdf 2018-02-08 需求号：549092
	var maxPrice=parseFloat(GetElementValue("MaxPrice"));   //modified by kdf 2018-02-08 需求号：549092
	if ((minPrice!="")&&(maxPrice!="")&&(minPrice>maxPrice))
	{
		messageShow("","","",t['-3002']);
		return true;
	}
	return false;
}
document.body.onload = BodyLoadHandler;
