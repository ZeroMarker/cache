//modified by GR 2014-09-24 缺陷号2995 删除厂商记录，部分查询条件未自动清空
//修改位置：BDelete_Click()，BDelete_Click()，BUpdate_Click()
//-------------------------------------------------------------------------
//设备生产厂商
function BodyLoadHandler() 
{
	InitUserInfo();
	InitEvent();
	disabled(true)//灰化
	initButtonWidth()  //hisui改造 add by czf 20180905
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
	val=val+"&Contperson="+GetElementValue("Contperson")
	val=val+"&Shname="+GetElementValue("Shname")
	val=val+"&Grading="+GetElementValue("Grading")
	val=val+"&Hold1="+GetElementValue("Hold1")             //modified by czf 需求号：335916
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCManufacturer"+val;	//HISUI改造 modified by czf 20180831
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")	{return;}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n");
	//alertShow("result"+result);
	//if (result>0) {location.reload();}
	//HISUI改造 modified by czf 20180831
	if (result>0) { window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCManufacturer";} //modified by GR 2014-09-24 缺陷号2995 删除厂商记录，部分查询条件未自动清空 	
}
function BUpdate_Click() 
{
	if (condition()) return;
	if((GetElementValue("EMail")!="")&&( GetElementValue("EMail").indexOf("@") <= -1 )) //2011-10-27 DJ DJ0097
	{
		alertShow("电子邮件地址有误,请正确输入!")
		return
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")	return;	
	var plist=CombinData(); //函数调用
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n");
	if (result==-2001)messageShow("","","",t[-3002])
	//if (result>0)	location.reload();
	if (result>0)
	{
		alertShow("保存成功!");
		//HISUI改造 modified by czf 20180831
		window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCManufacturer";	//modified by GR 2014-09-24 缺陷号2995 删除厂商记录，部分查询条件未自动清空
	}
}
function BAdd_Click() //增加
{
	if (condition()) return;
	if((GetElementValue("EMail")!="")&&( GetElementValue("EMail").indexOf("@") <= -1 )) //2011-10-27 DJ DJ0097
	{
		alertShow("电子邮件地址有误,请正确输入!")
		return
	}
var encmeth=GetElementValue("GetUpdate");
	if (encmeth==""){return;}
	var plist=CombinData(); //函数调用
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n");
	if (result==-2001)messageShow("","","",t[-3001])
	//if (result>0)	location.reload();
	if (result>0)
	{
		alertShow("增加成功!");
		//HISUI改造 modified by czf 20180831
		window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCManufacturer";	//modified by GR 2014-09-24 缺陷号2995 删除厂商记录，部分查询条件未自动清空
	}
}	
	function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Name") ;//名称2
  	combindata=combindata+"^"+GetElementValue("Code") ; //代码3
	if (GetElementValue("Code")=="") combindata=combindata+GetPYCode(GetElementValue("Name"));
  	combindata=combindata+"^"+GetElementValue("Address") ; //地址4
  	combindata=combindata+"^"+GetElementValue("Tel") ; //电话5
  	combindata=combindata+"^"+GetElementValue("Zip") ; //邮编6
  	combindata=combindata+"^"+GetElementValue("Fax") ; //传真7
  	combindata=combindata+"^"+GetElementValue("Contperson") ; //联系人8
  	combindata=combindata+"^"+GetElementValue("Shname") ; //短名称9
	if (GetElementValue("Shname")=="") combindata=combindata+GetPYCode(GetElementValue("Name"));   //modified by czf 需求号：335979
  	combindata=combindata+"^"+GetElementValue("Grading") ; //等级10
  	combindata=combindata+"^"+GetElementValue("Hold1") ; //
  	combindata=combindata+"^"+GetElementValue("Hold2") ; //
  	combindata=combindata+"^"+GetElementValue("Hold3") ; //
  	combindata=combindata+"^"+GetElementValue("Hold4") ; //
  	combindata=combindata+"^"+GetElementValue("Hold5") ; //
  	return combindata;
}
///选择表格行触发此方法
///HISUI改造 modified by czf 20180830
var SelectedRow = -1;
var rowid=0;
function SelectRowHandler(index,rowdata)	{
	if (index==SelectedRow){
		Clear();
		SelectedRow= -1;
		disabled(true)//灰化
		$('#tDHCEQCManufacturer').datagrid('unselectAll'); 
		return;
		}
		
	SetData(rowdata.TRowID); 
	disabled(false)//反灰化  
    SelectedRow = index;
}
/*
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCManufacturer');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		Clear();
		disabled(true)//灰化	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		disabled(false)//反灰化
		}
}*/
function Clear()
{
	SetElement("RowID","");
	SetElement("Name",""); //名称1
	SetElement("Code","");//代码2
	SetElement("Address","");//地址3
	SetElement("Tel","");//电话4
	SetElement("Zip","");//邮编
	SetElement("Fax","");//传真
	SetElement("Contperson","");//联系人
	SetElement("Shname","");//短名称
	SetElement("Grading","");//等级
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth==""){return;}
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	//alertShow("list"+list);
	SetElement("RowID",list[0]); //rowid
	SetElement("Name",list[1]); //名称1
	SetElement("Code",list[2]);//代码2
	SetElement("Address",list[3]);//地址3
	SetElement("Tel",list[4]);//电话4
	SetElement("Zip",list[5]);//邮编
	SetElement("Fax",list[6]);//传真
	SetElement("Contperson",list[7]);//联系人
	SetElement("Shname",list[8]);//短名称
	SetElement("Grading",list[9]);//等级
	SetElement("Hold1",list[10]);//
	SetElement("Hold2",list[11]);//
	SetElement("Hold3",list[12]);//
	SetElement("Hold4",list[13]);//
	SetElement("Hold5",list[14]);//
}
/*
function disabledt()//灰化
{
	DisableBElement("BUpdate",true)
	DisableBElement("BDelete",true)
	DisableBElement("BAdd",false)
	//document.all["BUpdate"].style.display="none";
	//document.all["BDelete"].style.display="inline";
}
*/
function disabled(value)//反灰化
{
	InitEvent();
	DisableBElement("BUpdate",value)

	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}	
function condition()//条件Code
{
	if (CheckMustItemNull()) return true;
	/*if (CheckItemNull(0,"Name")) return true;
	if (CheckItemNull(0,"Code")) return true;*/
	return false;
}
document.body.onload = BodyLoadHandler; //声明函数 必须