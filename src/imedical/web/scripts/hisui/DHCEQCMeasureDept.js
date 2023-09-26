//国家计量部门 计量检测部门
function BodyLoadHandler() 
{
	InitUserInfo();
	InitEvent();
	disabled(true)//灰化
	initButtonWidth();
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
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCMeasureDept"+val;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BDelete_Click() 
{
	var rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n");
	if (result>0) {
		alertShow("删除成功!");  //add by kdf 2018-01-16 需求号：528983
		location.reload();}	
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
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n");
	if (result==-99) //2010-06-11 党军 begin
 	{
	 	alertShow("数据重复!请检查!")
	 	return
	 } //2010-06-11 党军 end
	if (result>0){
		alertShow("更新成功!"); // add by kdf 2018-01-16 需求号：528977
		location.reload();}	
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
	if (encmeth=="")return;
	var plist=CombinData(); //函数调用
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n");
	if (result==-99) //2010-06-11 党军 begin
 	{
	 	alertShow("数据重复!请检查!")
	 	return
	 } //2010-06-11 党军 end
	if (result>0){
	alertShow("增加成功!"); // add by kdf 2018-01-16 需求号：528975
	location.reload(); }
}	
	function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Name") ;//名称2
  	combindata=combindata+"^"+GetElementValue("Code") ; //代码3
  	combindata=combindata+"^"+GetElementValue("Address") ; //地址4
  	combindata=combindata+"^"+GetElementValue("Tel") ; //电话5
  	combindata=combindata+"^"+GetElementValue("Zip") ; //邮编6
  	combindata=combindata+"^"+GetElementValue("Fax") ; //传真7
  	combindata=combindata+"^"+GetElementValue("Contperson") ; //联系人8
  	combindata=combindata+"^"+GetElementValue("Shname") ; //短名称9
  	combindata=combindata+"^"+GetElementValue("Grading") ; //等级10
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

///选择表格行触发此方法
var SelectedRow = -1;
var rowid=0;
function SelectRowHandler(index,rowdata)
{
	if (SelectedRow==index)
	{
		Clear();
		disabled(true)//灰化
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=index;
		rowid=rowdata.TRowID;
		SetData(rowid);//调用函数
		disabled(false)//反灰化
	}
}
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
	SetElement("Bank","") //2011-10-27 DJ DJ0097 begin
	SetElement("BankNo","")
	SetElement("EMail","")
	SetElement("Hold1","")
	SetElement("Hold2","")
	SetElement("Hold3","")
	SetElement("Hold4","")
	SetElement("Hold5","") //2011-10-27 DJ DJ0097 end
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
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
	SetElement("Bank",list[10]) //2011-10-27 DJ DJ0097 begin
	SetElement("BankNo",list[11])
	SetElement("EMail",list[12])
	SetElement("Hold1",list[13])
	SetElement("Hold2",list[14])
	SetElement("Hold3",list[15])
	SetElement("Hold4",list[16])
	SetElement("Hold5",list[17]) //2011-10-27 DJ DJ0097 end
}

function disabled(value)//反灰化
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}	
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	/*if (CheckItemNull(2,"Name")) return true;
	if (CheckItemNull(2,"Code")) return true;
	*/
	return false;
}
document.body.onload = BodyLoadHandler; //声明函数 必须