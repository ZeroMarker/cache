///add by jyp 2016-11-18
function BodyLoadHandler()
{
	InitPage();
}

function InitPage()
{
	document.getElementById('BAdd').onclick=BAdd_Click;
	document.getElementById('BUpdate').onclick=BUpdate_Click;
	document.getElementById('BDelete').onclick=BDelete_Click;
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
		alertShow(t[-4001]);
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
		alertShow(t[-3001])
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
		alertShow(t[-3001])
		return
		}
	if (result>0)location.reload();	
}

function BDelete_Click() //删除
{
	if (GetElementValue("RowID")=="")	
	{
		alertShow("请选中一条记录")
		return
	}
	/// Mozy	2017-10-12	463564	增加删除确认提示
	var truthBeTold = window.confirm("确定要删除该消耗项目记录?");
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetDelete");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		alertShow(t[-3001])
		return
	}
	if (result>=0)location.reload();	
}

var select=-1;
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectRow=rowObj.rowIndex;
	if(select!=selectRow){
	document.getElementById('RowID').value=document.getElementById("TRowIDz"+selectRow).value;
	document.getElementById('UseRecord').value=document.getElementById("TUseRecordz"+selectRow).innerText;
	document.getElementById('ConsumableItem').value=document.getElementById("TConsumableItemz"+selectRow).innerText;
	document.getElementById('UseRecordDR').value=document.getElementById("TUseRecordDRz"+selectRow).value;
	document.getElementById('ConsumableItemDR').value=document.getElementById("TConsumableItemDRz"+selectRow).value;
	//document.getElementById('Uom').value=document.getElementById("TUomz"+selectRow).innerText;
	//document.getElementById('UomDR').value=document.getElementById("TUomDRz"+selectRow).innerText;
	document.getElementById('Quantity').value=document.getElementById("TQuantityz"+selectRow).innerText;
	document.getElementById('Price').value=document.getElementById("TPricez"+selectRow).innerText;    //add by kdf 2017-12-26 需求号：468836
	document.getElementById('Amount').value=document.getElementById("TAmountz"+selectRow).innerText;
	select=selectRow;
	}
	
	else{
		select=-1;
	document.getElementById('RowID').value='';
	document.getElementById('UseRecord').value='';
	document.getElementById('ConsumableItem').value='';
	document.getElementById('UseRecordDR').value='';
	document.getElementById('ConsumableItemDR').value='';
	//document.getElementById('Uom').value='';
	//document.getElementById('UomDR').value='';
	document.getElementById('Quantity').value='';
	//document.getElementById('Price').valu;e=''
	document.getElementById('Amount').value='';
	}
	
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
	var List=value.split("^");
	var obj=document.getElementById('ConsumableItem');
	obj.value=List[1];
	var obj=document.getElementById('ConsumableItemDR');
	obj.value=List[0];
	var obj=document.getElementById('Price');	//add by czf 461821 begin
	obj.value=List[4];
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
	alertShow(value);
	var val=value.split("^");
	var obj=document.getElementById("UomDR");	
	if (obj) obj.value=val[1];
	var obj=document.getElementById("Uom");	
	if (obj) obj.value=val[0];

}
*/
document.body.onload = BodyLoadHandler;