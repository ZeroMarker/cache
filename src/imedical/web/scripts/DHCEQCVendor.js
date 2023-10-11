
var SelectedRow = -1;
var rowid=0;
function BodyLoadHandler() 
{
	//modified by cjt 20230212 需求号3221967 UI页面改造
	initPanelHeaderStyle();
	initButtonColor();
	InitUserInfo(); //系统参数
	InitEvent();
	disabled(true);//灰化
	initButtonWidth();	//modified by czf 20180827 HISUI改造
	initFirmType();		//add by CZF0093 2020-03-17 begin
	var FirmTypeDR=GetElementValue("FirmTypeDR");
	if (FirmTypeDR.indexOf(",")>-1)
	{
		FirmTypeDR=FirmTypeDR.split(",")
	}
	$("#FirmType").combobox("setValues",FirmTypeDR);
    ///add by ZY 2926611  20220915
    if (FirmTypeDR!="")
    {
        //hiddenObj("FirmType",true)
        disableElement("FirmType",true)
    }
	setRequiredElements("FirmType")		//add by CZF0093 2020-03-17 end
}
function InitEvent()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("BFind")
	if (obj) obj.onclick=BFind_Click;
}
function BFind_Click()
{
	var val="&Code="+GetElementValue("Code");
	val=val+"&Name="+GetElementValue("Name")
	val=val+"&ConPerson="+GetElementValue("ConPerson")
	val=val+"&Tel="+GetElementValue("Tel")
	val=val+"&ShName="+GetElementValue("ShName")
	val=val+"&FirmTypeDR="+($("#FirmType").combobox("getValues"))		//add by CZF0093 2020-03-17
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		val += "&MWToken="+websys_getMWToken()
	}
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCVendor"+val;
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
	if (GetElementValue("Code")=="") combindata=combindata+GetPYCode(GetElementValue("Name"));
  	combindata=combindata+"^"+GetElementValue("Name") ; 
  	combindata=combindata+"^"+GetElementValue("Address") ;
  	combindata=combindata+"^"+GetElementValue("Province") ;
  	combindata=combindata+"^"+GetElementValue("City") ;
  	combindata=combindata+"^"+GetElementValue("State") ;
  	combindata=combindata+"^"+GetElementValue("ZipCode") ;
  	combindata=combindata+"^"+GetElementValue("ConPerson") ;
  	combindata=combindata+"^"+GetElementValue("Tel") ;
  	combindata=combindata+"^"+GetElementValue("Fax") ;
  	combindata=combindata+"^"+GetElementValue("ShName") ;
  	if (GetElementValue("ShName")=="") combindata=combindata+GetPYCode(GetElementValue("Name"));
  	combindata=combindata+"^"+GetElementValue("Grading") ;
  	combindata=combindata+"^"+GetElementValue("Bank") ;
  	combindata=combindata+"^"+GetElementValue("BankNo") ;
  	combindata=combindata+"^"+GetElementValue("RegistrationNo") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("Hold1") ; 	//经营许可证号
  	combindata=combindata+"^"+GetElementValue("Hold2") ; 	//电子邮件
  	combindata=combindata+"^"+GetElementValue("Hold3") ; 
  	combindata=combindata+"^"+GetElementValue("Hold4") ; 
  	combindata=combindata+"^"+GetElementValue("Hold5") ; 
  	combindata=combindata+"^"+GetElementValue("ExDesc") ;	// Mozy0055	2011-7-7
	combindata=combindata+"^"+($("#FirmType").combobox("getValues")) 	//add by CZF0093 2020-03-17 公司类型
  	return combindata;
}
function BUpdate_Click() 
{
	SetElement("FirmTypeDR",$("#FirmType").combobox("getValues"));		//modified by czf 2020-04-01 1254647 新增数据全选时FirmTypeDRI未赋值
	if (condition()) return;
	if((GetElementValue("EMail")!="")&&( GetElementValue("EMail").indexOf("@") <= -1 )) //2011-10-27 DJ DJ0097
	{
		alertShow("电子邮件地址有误,请正确输入!")
		return
	}
	
	//modified by ZY 2015-4-27 ZY0125
	var encmeth=GetElementValue("CheckVendorUsed");
	var result=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	if (result==1)
	{
		var truthBeTold = window.confirm("供应商在其他院区用到,确认是否要修改?");
		if (!truthBeTold) return;
	}	
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,"");
	result=result.replace(/\\n/g,"\n")
	if(result>0)		//modified by czf 20200404 
	{
		alertShow("保存成功!");
		location.reload();
	}
	else
	{
		messageShow("","","",t[-3001]);
		return
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
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}

//modified by czf 20180827 HISUI改造
function SelectRowHandler(index,rowdata)	{
	if (index==SelectedRow){
		Clear();
		SelectedRow= -1;
		disabled(true)//灰化
		$('#tDHCEQCVendor').datagrid('unselectAll'); 
		return;
		}
		
	SetData(rowdata.TRowID); 
	disabled(false)//反灰化  
    SelectedRow = index;
}

function Clear()
{
	SetElement("RowID","");
	SetElement("Code",""); 
	SetElement("Name","");
	SetElement("Address",""); 
	SetElement("Province",""); 
	SetElement("City",""); 
	SetElement("State","");
	SetElement("ZipCode","");
	SetElement("ConPerson","");
	SetElement("Tel","");
	SetElement("Fax","");
	SetElement("ShName","");
	SetElement("Grading","");
	SetElement("Bank","");
	SetElement("BankNo","");
	SetElement("RegistrationNo","");
	SetElement("Remark","");	
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
	SetElement("ExDesc","");	// Mozy0055	2011-7-7
	$("#FirmType").combobox("setValues","")//czf 1247304 2020-03-30
	SetElement("FirmTypeDR","")
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("RowID",rowid);
	SetElement("Code",list[0]); 
	SetElement("Name",list[1]);
	SetElement("Address",list[2]); 
	SetElement("Province",list[3]); 
	SetElement("City",list[4]); 
	SetElement("State",list[5]);
	SetElement("ZipCode",list[6]);
	SetElement("ConPerson",list[7]);
	SetElement("Tel",list[8]);
	SetElement("Fax",list[9]);
	SetElement("ShName",list[10]);
	SetElement("Grading",list[11]);
	SetElement("Bank",list[12]);
	SetElement("BankNo",list[13]);
	SetElement("RegistrationNo",list[14]);
	SetElement("Remark",list[15]);	
	SetElement("Hold1",list[19]);
	SetElement("Hold2",list[20]);
	var Hold3=list[21];
	if (Hold3.indexOf(",")>-1)			//modified by czf 20200404
	{
		Hold3=Hold3.split(",")
	}	
	$("#FirmType").combobox("setValues",Hold3);	//Hold3 modified by CZF0093 2020-03-17  
	SetElement("FirmTypeDR",Hold3);
	SetElement("Hold4",list[22]);
	///modified by ZY
	if (list[23]=="Y") 
	{
		SetChkElement("Hold5",1);
	}
	else
	{
		SetChkElement("Hold5",0);
	}
	
	SetElement("ExDesc",list[17]);	// Mozy0055	2011-7-7
}
function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BDelete",value)
}	
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}

function initFirmType()
{
	var FirmType = $HUI.combobox("#FirmType",{
		valueField:'id',
		textField:'text',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'2',text:'供应商'},{id:'3',text:'生产厂商'},{id:'4',text:'服务商'}
		],
		onSelect:function(e){
			SetElement("FirmTypeDR",$(this).combobox("getValues"));
		}
	});	
}
document.body.onload = BodyLoadHandler;
