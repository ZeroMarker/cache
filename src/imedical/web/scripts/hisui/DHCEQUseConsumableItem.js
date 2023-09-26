///add by jyp 2016-11-18
function BodyLoadHandler()
{
	initButtonWidth();///Add By QW 2018-10-11 HISUI改造:修改按钮长度
	setButtonText();///Add By QW 2018-10-11 HISUI改造:按钮文字规范
	InitPage();
}

function InitPage()
{
	document.getElementById('BAdd').onclick=BAdd_Click;
	document.getElementById('BUpdate').onclick=BUpdate_Click;
	document.getElementById('BDelete').onclick=BDelete_Click;
	setRequiredElements("ConsumableItem^UseRecord")   //add by yh 20190801
	var obj=document.getElementById("Quantity");         //add by czf 461821
	if (obj) obj.onkeyup=Num_KeyUp;
	var obj=document.getElementById("ConsumableItem");
	if (obj) obj.onchange=ValueClear;
}

function FillData()
{
	var rowid=GetElementValue("RowID");	
	if ((rowid=="")||(rowid<1)) 
	{	
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		messageShow("","","",t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid);
	SetData(result);
}
}

function BAdd_Click() //增加
{
	if (GetElementValue("RowID")!="")	
	{
		alertShow("请不要选中一条记录")
		return
	}
	if (GetElementValue("UseRecordDR")=="")	
	{
		alertShow("使用记录不能为空!");
		return
	}
	if (GetElementValue("ConsumableItemDR")=="")	
	{
		alertShow("消耗项目不能为空!")
		return
	}		
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		messageShow("","","",t[-3001])
		return
		}
	if (result>0)location.reload();	
}

function BUpdate_Click()
{
	if (GetElementValue("RowID")=="")	
	{
		alertShow("请选中一条记录")
		return
	}
	if (GetElementValue("UseRecordDR")=="")	
	{
		alertShow("使用记录不能为空!");
		return
	}
	if (GetElementValue("ConsumableItemDR")=="")	
	{
		alertShow("消耗项目不能为空!")
		return
	}		
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		messageShow("","","",t[-3001])
		return
		}
	if (result>0)location.reload();	
}

function BDelete_Click() //删除
{
	///modified by ZY0215 2020-04-02
	messageShow("confirm","","","确定要删除该消耗项目记录?","",confirmFun,"")
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	if (GetElementValue("RowID")=="")	
	{
		alertShow("请选中一条记录")
		return
	}
	var encmeth=GetElementValue("GetDelete");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		messageShow("","","",t[-3001])
		return
	}
	if (result>=0)location.reload();	
}

var SelectedRow = -1; ///Modify By QW 2018-10-11 HISUI改造
///选择表格行触发此方法
///Modify By QW 2018-10-11 HISUI改造：点击选择行后，界面无法正常填充数据
///解决方法传入index,rowdata两个参数，并修改判断逻辑
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
	    SelectedRow=-1;	
		document.getElementById('RowID').value='';
		document.getElementById('UseRecord').value='';
		document.getElementById('ConsumableItem').value='';
		document.getElementById('UseRecordDR').value='';
		document.getElementById('ConsumableItemDR').value='';
		document.getElementById('Quantity').value='';
		document.getElementById('Amount').value='';
		document.getElementById('Price').value='';  //Add BY QW20181029 需求号:581780 清空单价
		$('#tDHCEQUseConsumableItem').datagrid('unselectAll');
		return;
	 }
	document.getElementById('RowID').value=rowdata.TRowID;
	document.getElementById('UseRecord').value=rowdata.TUseRecord;
	document.getElementById('ConsumableItem').value=rowdata.TConsumableItem;
	document.getElementById('UseRecordDR').value=rowdata.TUseRecordDR;
	document.getElementById('ConsumableItemDR').value=rowdata.TConsumableItemDR;
	document.getElementById('Quantity').value=rowdata.TQuantity;
	document.getElementById('Price').value=rowdata.TPrice;
	document.getElementById('Amount').value=rowdata.TAmount;
	SelectedRow=index;
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("UseRecordDR") ;//
  	combindata=combindata+"^"+GetElementValue("ConsumableItemDR") ; //
  //	combindata=combindata+"^"+GetElementValue("UomDR") ;//单位
  	combindata=combindata+"^"+GetElementValue("Quantity") ;//数量
  //	combindata=combindata+"^"+GetElementValue("Price") ;//单价
  	combindata=combindata+"^"+GetElementValue("Amount") ; //金额
  	return combindata;
}
function GetUseRecordInfo(value)
{
	var List=value.split("^");
	var obj=document.getElementById('UseRecord');
	obj.value=List[2];
	var obj=document.getElementById('UseRecordDR');
	obj.value=List[0];	
}
function GetConsumableItemInfo(value)
{
	var List=value.split("^");						// modify by wl 2019-9-10 begin 1025258
	var obj=document.getElementById('ConsumableItem');
	obj.value=List[2];
	var obj=document.getElementById('ConsumableItemDR');
	obj.value=List[1];
	var obj=document.getElementById('Price');	//add by czf 461821 begin
	obj.value=List[5];							   // modify by wl 2019-9-10 end
}

function Num_KeyUp()
{
	var Num=GetElementValue("Quantity");
	var Price=GetElementValue("Price");
	if (Num!="")
	{
		Amount=Num*Price;
	}
	else
	{
		Amount=0;
	}
	SetElement("Amount",Amount.toFixed(2));
}

function ValueClear()
{
	SetElement("Quantity","");
	SetElement("Price","");
	SetElement("Amount","");
}									 //add by czf 461821 end
/*
function UnitDR(value) // 单位
{
	messageShow("","","",value);
	var val=value.split("^");
	var obj=document.getElementById("UomDR");	
	if (obj) obj.value=val[1];
	var obj=document.getElementById("Uom");	
	if (obj) obj.value=val[0];

}
*/
document.body.onload = BodyLoadHandler;