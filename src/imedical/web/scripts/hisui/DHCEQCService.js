///Modified By HZY 2011-10-18 HZY0017
///修改函数: BAdd_Click ,BUpdate_Click ,BDelete_Click

//服务商
var SelectedRow = -1;
var rowid=0;
function BodyLoadHandler() 
{
	initButtonWidth()  //hisui改造 add by kdf 2018-10-25
	InitUserInfo();
	InitEvent();
	disabled(true)//灰化
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
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
	var val="&Name="+GetElementValue("Name");
	val=val+"&Code="+GetElementValue("Code");
	val=val+"&Address="+GetElementValue("Address")
	val=val+"&Tel="+GetElementValue("Tel")
	val=val+"&Zip="+GetElementValue("Zip")
	val=val+"&Fax="+GetElementValue("Fax")
	val=val+"&ContPerson="+GetElementValue("ContPerson")
	val=val+"&ShName="+GetElementValue("ShName")
	val=val+"&Grading="+GetElementValue("Grading")
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCService"+val;
}
function disabled(value)//反灰化
{
	InitEvent();
	DisableBElement("BUpdate",value)

	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}

///Modified By HZY 2011-10-18 HZY0017
function BAdd_Click() 
{
	if (CheckNull()) return;
	if((GetElementValue("EMail")!="")&&( GetElementValue("EMail").indexOf("@") <= -1 )) //2011-10-27 DJ DJ0097
	{
		alertShow("电子邮件地址有误,请正确输入!")
		return
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //函数调用
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n");
	if (result==0)		//Modified By HZY 2011-10-18 HZY0017
	{ 
		location.reload();
		return;
	}
	else
	{
		messageShow("","","",t[result]);
	}
}

///Modified By HZY 2011-10-18 HZY0017
function BUpdate_Click() 
{
	if (CheckNull()) return;
	var RowID=GetElementValue("RowID");
	if (RowID=="")
	{
		messageShow("","","",t[-4002]);
		return;
	}
	if (CheckNull()) return;
	if((GetElementValue("EMail")!="")&&( GetElementValue("EMail").indexOf("@") <= -1 )) //2011-10-27 DJ DJ0097
	{
		alertShow("电子邮件地址有误,请正确输入!")
		return
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //函数调用
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n");
	if (result==0)		//Modified By HZY 2011-10-18 HZY0017
	{ 
		location.reload();
		return;
	}
	else
	{
		messageShow("","","",t[result]);
	}	
}
function CombinData()
{
	var combindata="";
	combindata=GetElementValue("RowID") ;
	//Modified by HHM 20150914 HHM0019
	//去除字符串前后空格
    var Name=trim(GetElementValue("Name"));
    var Code=trim(GetElementValue("Code"));
  	combindata=combindata+"^"+Name ;//名称2
  	combindata=combindata+"^"+Code ; //代码3
  	//*****************************************
  	combindata=combindata+"^"+GetElementValue("Address") ; //地址4
  	combindata=combindata+"^"+GetElementValue("Tel") ; //电话5
  	combindata=combindata+"^"+GetElementValue("Zip") ; //邮编6
  	combindata=combindata+"^"+GetElementValue("Fax") ; //传真7
  	combindata=combindata+"^"+GetElementValue("ContPerson") ; //联系人8
  	combindata=combindata+"^"+GetElementValue("ShName") ; //短名称
  	combindata=combindata+"^"+GetElementValue("Grading") ; //等级
  	combindata=combindata+"^"+GetElementValue("Bank") ; //开户银行  2011-10-27 DJ DJ0097 Begin
  	combindata=combindata+"^"+GetElementValue("BankNo") ; //开户帐号
  	combindata=combindata+"^"+GetElementValue("EMail") ; //EMail
  	combindata=combindata+"^"+GetElementValue("Hold1") ; //
  	combindata=combindata+"^"+GetElementValue("Hold2") ; //
  	combindata=combindata+"^"+GetElementValue("Hold3") ; //
  	combindata=combindata+"^"+GetElementValue("Hold4") ; //
  	combindata=combindata+"^"+GetElementValue("Hold5") ; // 2011-10-27 DJ DJ0097 end
  	return combindata;
}

///Modified By HZY 2011-10-18 HZY0017
function BDelete_Click() 
{
	///modified by ZY0215 2020-04-02
	messageShow("confirm","","",t[-4003],"",confirmFun,"")
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	rowid=GetElementValue("RowID");
	if (rowid=="")
	{
		messageShow("","","",t[-4002]);
		return;
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n");
	if (result==0)		//Modified By HZY 2011-10-18 HZY0017
	{ 
		location.reload();
		return;
	}
	else
	{
		messageShow("","","",t[result]);
	}
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	/if (CheckItemNull(2,"Name")) return true;
	if (CheckItemNull(2,"Code")) return true;
	*/
	return false;
}	
///选择表格行触发此方法
// modified by kdf 2018-10-18 hisui-改造
function SelectRowHandler(index,rowdata)	{
	if (SelectedRow==index)
		{
			
		Clear();
		SetElement("RowID","");
		SelectedRow=-1;
		$('#tDHCEQCService').datagrid('unselectAll');  //hisui改造 add by kdf 2018-10-18
		disabled(true)
		}
	else{
		SelectedRow=index;
		rowid=rowdata.TRowID ;
		SetElement("RowID",rowid);
		SetData(rowid);//调用函数
		disabled(false)
		}
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	//	alertShow("list"+list);
	SetElement("Name",list[1]); //名称
	SetElement("Code",list[2]); //代码
	SetElement("Address",list[3]);//地址
	SetElement("Tel",list[4]); //电话
	SetElement("Zip",list[5]); //邮编
	SetElement("Fax",list[6]); //传真
	SetElement("ContPerson",list[7]); //联系人
	SetElement("ShName",list[8]); //短名称
	SetElement("Grading",list[9]); //等级
	SetElement("InvalidFlag",list[10]); //无效标志
	SetElement("Bank",list[11]) //2011-10-27 DJ DJ0097 begin
	SetElement("BankNo",list[12])
	SetElement("EMail",list[13])
	SetElement("Hold1",list[14])
	SetElement("Hold2",list[15])
	SetElement("Hold3",list[16])
	SetElement("Hold4",list[17])
	SetElement("Hold5",list[18]) //2011-10-27 DJ DJ0097 end

}
function Clear()
{
	SetElement("RowID","");
	SetElement("Name",""); //名称
	SetElement("Code",""); //代码
	SetElement("Address",""); //地址
	SetElement("Tel",""); //电话
	SetElement("Zip",""); //邮编
	SetElement("Fax",""); //传真
	SetElement("ContPerson",""); //联系人
	SetElement("ShName",""); //短名称
	SetElement("Grading",""); //等级
	SetElement("Bank","") //2011-10-27 DJ DJ0097 begin
	SetElement("BankNo","")
	SetElement("EMail","")
	SetElement("Hold1","")
	SetElement("Hold2","")
	SetElement("Hold3","")
	SetElement("Hold4","")
	SetElement("Hold5","") //2011-10-27 DJ DJ0097 end
	}
document.body.onload = BodyLoadHandler;