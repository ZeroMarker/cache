var selectrow=0
//最后一行数据元素的名字的后缀序号
var LastNameIndex;
//新增一行数据元素的名字的后缀序号
var NewNameIndex;

function BodyLoadHandler() 
{
	InitPage();
	SetTableItem('','');
}
function InitPage()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
	var obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_Clicked;
}
function SetTableItem(RowNo,selectrow)
{
	var objtbl=document.getElementById('tDHCEQEquipFilter');
	var rows=objtbl.rows.length-1;
	if (RowNo=="")
	{
		for (var i=1;i<=rows;i++)
		{
			tableList[i]=0;
			ChangeRowStyle(objtbl.rows[i]);
		}
	}
	else
	{
		if (selectrow=='') selectrow=RowNo
		tableList[RowNo]=0;
		ChangeRowStyle(objtbl.rows[selectrow]);		///改变一行的内容显示
	}
}

///改变一行的内容显示
function ChangeRowStyle(RowObj)
{
	for (var j=0;j<RowObj.cells.length;j++)
	{
		var html="";
		var value="";

    	if (!RowObj.cells[j].firstChild) {continue}
    	
		var Id=RowObj.cells[j].firstChild.id;
		
		var offset=Id.lastIndexOf("z");
		var objindex=Id.substring(offset+1);
		var colName=Id.substring(0,offset);
		
		var objwidth=RowObj.cells[j].style.width;
		var objheight=RowObj.cells[j].style.height;
		if (colName=="Type")
		{
			value=GetElementValue("Typez"+objindex);
			html=CreatElementHtml(4,Id,objwidth,objheight,"KeyDown_Tab","SourceType_Change","1^名称&2^科室&3^供应商&4^类组&5^状态&6^型号&7^编号","")	//Old
		}
		else if (colName=="Filter")
		{
			value=document.getElementById(Id).innerText
			var Type=GetElementValue("Typez"+objindex)
			if ((Type==1)||(Type==7))
			{
         			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","","")
			}
			else
			{
         			html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpFilter","","","")
			}
		}
		else if (colName=="BDeleteList")
		{
			RowObj.cells[j].onclick=DeleteClickHandler;
		}
		if (html!="") RowObj.cells[j].innerHTML=html;
	    if (value!="")
	    {
		    value=trim(value);
		    if (RowObj.cells[j].firstChild.tagName=="LABEL")
		    {
			    RowObj.cells[j].firstChild.innerText=value;
			}
			else if ((RowObj.cells[j].firstChild.tagName=="INPUT")&&(RowObj.cells[j].firstChild.type=="checkbox"))
		    {
			    RowObj.cells[j].firstChild.checked=value;
			}
			else
		    {
			    RowObj.cells[j].firstChild.value=value;
		    }
	    }
	}
}

function LookUpFilter(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	if (event.keyCode==0)
	{
		selectrow=GetTableCurRow();
		var ObjType=document.getElementById('Typez'+selectrow);
		if (ObjType)
		{
			var ObjType=ObjType.value
			if (ObjType==1)
			{
				
			}
			else if (ObjType==2)
			{
				LookUpUseLoc();
			}
			else if (ObjType==3)
			{
				LookUpProvider();
			}
			else if (ObjType==4)
			{
				LookUpEquipType();
			}
			else if (ObjType==5)
			{
				LookUpStatus();
			}
			else if (ObjType==6)
			{
				LookUpModelDR();
			}
			else if (ObjType==7)
			{
				//
			}
		}
	}
	else
	{
		return;
	}
}

function SourceType_Change()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQEquipFilter'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	selectrow=rowObj.rowIndex;								//当前选择行
	RowNo=GetTableCurRow();
	var Type=GetElementValue("Typez"+RowNo)
	SetElement("Typez"+RowNo,Type);
	SetTableItem(RowNo,selectrow);
	/*
	if (TSourceType==1)
	{
		SetTableItem(RowNo,selectrow);		///改变一行的内容显示
	}
	if (TSourceType==2)
	{
		SetTableItem(RowNo,"2",selectrow);		///改变一行的内容显示
	}
	if (TSourceType==3)
	{
		SetTableItem(RowNo,"1",selectrow);		///改变一行的内容显示
	}
	selectrow=RowNo;
	SetFocusColumn("Type",selectrow)*/
}
function LookUpUseLoc()
{
	LookUpCTLoc("GetFilter","0,Filterz"+selectrow+",,0102");
}
function LookUpProvider()
{
	LookUpCTVendor("GetFilter","Filterz"+selectrow);
}
function LookUpEquipType()
{
	LookUp("","web.DHCEQFind:GetEquipType","GetFilter","Filterz"+selectrow);
}
function LookUpStatus()
{
	LookUp("","web.DHCEQEquip:GetEquipStatus","GetFilter","");
}
function LookUpModelDR()
{
	LookUpModel("GetFilter","Filterz"+selectrow);
}
function GetFilter(value)
{
	var list=value.split("^")
	SetElement('Filterz'+selectrow,list[0]);
	SetElement('FilterDRz'+selectrow,list[1]);
	var obj=document.getElementById("TFilterz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}


function AddClickHandler() {
	try 
	{
		var objtbl=document.getElementById('tDHCEQEquipFilter');
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
			///alertShow(LastNameIndex+"%%%%"+NewNameIndex)
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
	    	//alertShow(NewNameIndex+"&&"+tableList)
			//设置默认的来源类型与上一行一致
			var PreType=GetElementValue("Typez"+LastNameIndex);
			SetElement("Typez"+NewNameIndex,PreType);
	    }
        return false;
	} 
	catch(e) 
	{};
}

function CanAddRow(objtbl)
{
	var rows=objtbl.rows.length;
    if (rows==1) return false;
	LastNameIndex=GetRowIndex(objtbl.rows[rows-1]);
	if  (GetElementValue('Typez'+LastNameIndex)=="")
	{
		SetFocusColumn("Type",LastNameIndex);
		return false;
		
	}
	if  (GetElementValue('Filterz'+LastNameIndex)=="")
	{
		SetFocusColumn("Filter",LastNameIndex);
	 	return false;
	}
	return true;
}
///OK
function DeleteClickHandler() {
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	try
	{
		var objtbl=document.getElementById('tDHCEQEquipFilter');
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		tableList[selectrow]="-1";
		if (rows<=2)
		{
			//修改删除仅剩的一行后?编辑保存数据异常?无法保存的问题
			tableList[selectrow]=0;
			SetElement('Typez'+selectrow,"");	
			SetElement('Filterz'+selectrow,"");	
			SetElement('FilterDRz'+selectrow,"");	
		} 
		else
		{
	    	var eSrc=window.event.srcElement;
			var rowObj=getRow(eSrc);
			objtbl.deleteRow(rowObj.rowIndex);
		}
		//alertShow(selectrow+"&&"+tableList)
	} 
	catch(e) 
	{};
}

function BSave_Clicked()
{
	var NameStr="";
	var UseLocDRStr="";
	var ProviderDRStr="";
	var EquipTypeDRStr="";
	var StatusStr="";
	var ModelDRStr="";
	var NoStr=""
	var objtbl=document.getElementById('tDHCEQEquipFilter');
	var rows=tableList.length
	//alertShow(tableList)
	for (var i=1;i<=rows;i++)
	{
		if (tableList[i]=="0")
		{
			var Type=GetElementValue("Typez"+i);
			var Filter=GetElementValue("Filterz"+i);
			var FilterDR=GetElementValue("FilterDRz"+i);
			//alertShow(Type+"&&"+Filter+"&&"+FilterDR)
			if (Type=="1")
			{
				if (NameStr=="")
				{
					NameStr=Filter;
				}
				else
				{
					NameStr=NameStr+","+Filter;
				}
				var obj=opener.document.getElementById("Name")
				if (obj) obj.value="";
			}
			else if (Type==2)
			{
				if (UseLocDRStr=="")
				{
					UseLocDRStr=FilterDR;
				}
				else
				{
					UseLocDRStr=UseLocDRStr+","+FilterDR;
				}
				var obj=opener.document.getElementById("UseLoc")
				if (obj) obj.value="";
				var obj=opener.document.getElementById("UseLocDR")
				if (obj) obj.value="";
				var obj=opener.document.getElementById("StoreLoc")
				if (obj) obj.value="";
				var obj=opener.document.getElementById("StoreLocDR")
				if (obj) obj.value="";
			}
			else if (Type==3)
			{
				if (ProviderDRStr=="")
				{
					ProviderDRStr=FilterDR;
				}
				else
				{
					ProviderDRStr=ProviderDRStr+","+FilterDR;
				}
				var obj=opener.document.getElementById("Provider")
				if (obj) obj.value="";
				var obj=opener.document.getElementById("ProviderDR")
				if (obj) obj.value="";
			}
			else if (Type==4)
			{
				if (EquipTypeDRStr=="")
				{
					EquipTypeDRStr=FilterDR;
				}
				else
				{
					EquipTypeDRStr=EquipTypeDRStr+","+FilterDR;
				}
				var obj=opener.document.getElementById("EquipType")
				if (obj) obj.value="";
				var obj=opener.document.getElementById("EquipTypeDR")
				if (obj) obj.value="";
			}
			else if (Type==5)
			{
				if (StatusStr=="")
				{
					StatusStr=FilterDR;
				}
				else
				{
					StatusStr=StatusStr+","+FilterDR;
				}
				var obj=opener.document.getElementById("StatusDisplay")
				if (obj) obj.value="";
				var obj=opener.document.getElementById("Status")
				if (obj) obj.value="";
			}
			else if (Type==6)
			{
				if (ModelDRStr=="")
				{
					ModelDRStr=FilterDR;
				}
				else
				{
					ModelDRStr=ModelDRStr+","+FilterDR;
				}
				var obj=opener.document.getElementById("Model")
				if (obj) obj.value="";
				var obj=opener.document.getElementById("ModelDR")
				if (obj) obj.value="";
			}
			else if (Type==7)
			{
				if (NoStr=="")
				{
					NoStr=Filter;
				}
				else
				{
					NoStr=NoStr+","+Filter;
				}
				var obj=opener.document.getElementById("No")
				if (obj) obj.value="";
			}
		}
	}
	if ((NameStr=="")&(UseLocDRStr=="")&(ProviderDRStr=="")&(EquipTypeDRStr=="")&(StatusStr=="")&(ModelDRStr=="")&(NoStr==""))
	{
		alertShow("没有设置过滤条件.");
		return;
	}
	var FilterData="NameStr="+NameStr+"^UseLocDRStr="+UseLocDRStr+"^ProviderDRStr="+ProviderDRStr+"^EquipTypeDRStr="+EquipTypeDRStr+"^StatusStr="+StatusStr+"^ModelDRStr="+ModelDRStr+"^NoStr="+NoStr
	//alertShow(FilterData)
	var obj=opener.document.getElementById("FilterData")
	if (obj) obj.value=FilterData;
	var obj=opener.document.getElementById("FilterFlag")
	if (obj) obj.value="Y";
	window.close();
}
document.body.onload = BodyLoadHandler;