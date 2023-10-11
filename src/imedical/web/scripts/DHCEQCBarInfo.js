/// Mozy	2019-7-1	DHCEQCBarInfo.js	条码维护
var selectrow=0;
var ObjSources=new Array();		//最后一行数据元素的名字的后缀序号
var LastNameIndex;				//新增一行数据元素的名字的后缀序号
var NewNameIndex;
document.body.onload = BodyLoadHandler;

function BodyLoadHandler() 
{
	InitPage();	
	FillData();
	if (GetElementValue("BarInfoDR")!="")
	{
		disabled(false);		//灰化	SetEnabled();
	}
	else
	{
		disabled(true);
	}
	
	KeyUp("BorderStyle^BarStyle^CorrectLevel","N");
	SetTableItem('','','');
	Muilt_LookUp("BorderStyle^BarStyle^CorrectLevel");
	//SetFocus("Desc");
	document.getElementById("cEQTitle").innerHTML = "条码配置 ("+GetElementValue("VersionInfo")+")"
	// MZY0069	1726270,1726281,1726345		2021-02-18
	//EQCommon_HiddenElement("BExportData");
	//EQCommon_HiddenElement("BImportData");
}
function InitPage()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Clicked;
	var obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BBarSet");
	if (obj) obj.onclick=BBarSet_Clicked;
	var obj=document.getElementById("BImportData");
	if (obj) obj.onclick=BImportData_Clicked;
	var obj=document.getElementById("BExportData");
	if (obj) obj.onclick=BExportData_Clicked;
}

function FillData()
{
	var obj=document.getElementById("BarInfoDR");
	var BarInfoDR=obj.value;
	if ((BarInfoDR=="")||(BarInfoDR<1))
	{
		return;
	}
	
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,BarInfoDR);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var list=ReturnList.split("^");
	//alert(ReturnList)
	var sort=37;
	SetElement("Desc",list[0]);
	SetElement("Style",list[1]);
	SetElement("Left",list[2]);
	SetElement("Top",list[3]);
	SetElement("BorderStyleDR",list[4]);
	SetElement("BorderStyle",list[sort+0]);
	SetElement("Line",list[5]);
	SetElement("LineB",list[6]);
	SetElement("BorderX",list[7]);
	SetElement("BorderY",list[8]);
	SetElement("OffsetX",list[9]);
	SetElement("LineHeigh",list[10]);
	
	SetElement("FontName",list[11]);
	SetElement("FontSize",list[12]);
	SetChkElement("FontBold",list[13]);
	SetElement("BarStyleDR",list[14]);
	SetElement("BarStyle",list[sort+1]);
	SetElement("BarPosX",list[15]);
	SetElement("BarPosY",list[16]);
	SetElement("BarWidth",list[17]);
	SetElement("BarHeight",list[18]);
	SetElement("CorrectLevelDR",list[19]);
	SetElement("CorrectLevel",list[sort+2]);
	SetElement("BarMark",list[20]);
	
	SetElement("CapationCellWidth",list[21]);
	SetElement("ColWidth",list[22]);
	SetElement("LineOffset",list[23]);
	SetChkElement("ActiveFlag",list[24]);
	SetElement("PrtName",list[25]);
	SetElement("BarLine",list[26]);
	SetElement("WordCount",list[31]);
	SetElement("Hold1",list[32]);
	SetElement("Hold1Desc",list[sort+3]);
	SetChkElement("Hold2",list[33]);
	SetElement("Hold3",list[34]);
	SetElement("Hold4",list[35]);
	SetElement("Hold5",list[36]);
}

function disabled(value)//灰化
{
	DisableBElement("BDelete",value);
	DisableBElement("BBarSet",value);
	DisableBElement("BExportData",value);
}

function BSave_Clicked()
{
	if (CheckNull()) return;
  	var combindata=GetElementValue("BarInfoDR");
  	combindata=combindata+"^"+GetElementValue("Desc");
	combindata=combindata+"^"+GetElementValue("Style");
	combindata=combindata+"^"+GetElementValue("Left");
	combindata=combindata+"^"+GetElementValue("Top");
	combindata=combindata+"^"+GetElementValue("BorderStyleDR");
	combindata=combindata+"^"+GetElementValue("Line");
	combindata=combindata+"^"+GetElementValue("LineB");
	combindata=combindata+"^"+GetElementValue("BorderX");
	combindata=combindata+"^"+GetElementValue("BorderY");
	combindata=combindata+"^"+GetElementValue("OffsetX");
	combindata=combindata+"^"+GetElementValue("LineHeigh");
	combindata=combindata+"^"+GetElementValue("FontName");
	combindata=combindata+"^"+GetElementValue("FontSize");
	combindata=combindata+"^"+GetChkElementValue("FontBold");
	combindata=combindata+"^"+GetElementValue("BarStyleDR");
	combindata=combindata+"^"+GetElementValue("BarPosX");
	combindata=combindata+"^"+GetElementValue("BarPosY");
	combindata=combindata+"^"+GetElementValue("BarWidth");
	combindata=combindata+"^"+GetElementValue("BarHeight");
	combindata=combindata+"^"+GetElementValue("CorrectLevelDR");
	combindata=combindata+"^"+GetElementValue("BarMark");
	combindata=combindata+"^"+GetElementValue("CapationCellWidth");
	combindata=combindata+"^"+GetElementValue("ColWidth");
	combindata=combindata+"^"+GetElementValue("LineOffset");
	combindata=combindata+"^"+GetChkElementValue("ActiveFlag");
	combindata=combindata+"^"+GetElementValue("PrtName");
	combindata=combindata+"^"+GetElementValue("BarLine");
	combindata=combindata+"^"+GetElementValue("WordCount");
	combindata=combindata+"^"+GetElementValue("Hold1");		//30
	combindata=combindata+"^"+GetChkElementValue("Hold2");
  	var valList=GetTableInfo();
  	if (valList=="-1") return;
  	var DelRowid=tableList.toString();
  	var encmeth=GetElementValue("SaveData");
  	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,combindata,valList,DelRowid);
	//alert(result)
    if (result>0)
	{
		alert("操作成功!");
		parent.DHCEQCBarInfoList.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCBarInfoList";
		location.reload();
	}
}

function BDelete_Clicked()
{
	var truthBeTold = window.confirm("您确认要删除该记录吗?");
	if (!truthBeTold) return;
  	var encmeth=GetElementValue("DeleteData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,GetElementValue("BarInfoDR"));
	if (Rtn==0)
    {
		alert("操作成功!")
		//location.reload();
		parent.DHCEQCBarInfoList.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCBarInfoList";
		parent.DHCEQCBarInfo.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCBarInfo";
	}
    else
    {
	    alert(Rtn+"   操作失败!");
    }
}

function BBarSet_Clicked() 
{
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCBarSet&BarInfoDR="+GetElementValue("BarInfoDR");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=720,height=480,left=150,top=150')
}
function BClear_Clicked() 
{
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCBarInfo';
	//disabled(true);
}
function SetTableItem(RowNo,SourceType,selectrow)
{
	var objtbl=document.getElementById('tDHCEQCBarInfo');
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		tableList[i]=0;
		ChangeRowStyle(objtbl.rows[i],SourceType);		///改变一行的内容显示
	}
}

///改变一行的内容显示
function ChangeRowStyle(RowObj,SourceType)
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
		if (colName=="TType")
		{
			//if (CheckUnEditField(Status,colName)) continue;
			value=GetElementValue("TTypez"+objindex);
			html=CreatElementHtml(4,Id,objwidth,objheight,"KeyDown_Tab","Type_Change","0^文本&1^直线","");
			//value=GetCElementValue(Id)
		    //html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TKey")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(2,Id,objwidth,objheight,"LookBarDetailKey","","","")
		}
		else if (colName=="TCaption")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TPrtCaption")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TFontName")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TFontSize")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TBold")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(5,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TLineNum")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TColNum")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TPrintLine")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(5,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TLeft")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TTop")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TCFontName")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TCFontSize")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TCBold")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(5,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TLineX")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TLineY")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TLine")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="THidden")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(5,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TFormat")
		{
			value=GetCElementValue(Id)
		    //html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		    html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpFormatList","","","Standard_TableKeyUp")
		}
		else if (colName=="TRemark")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TCharacters")
		{
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="BDeleteList")
		{
			RowObj.cells[j].onclick=DeleteClickHandler;
		}
		
		if (html!="")
		{
			RowObj.cells[j].firstChild.outerHTML=html;
			//RowObj.cells[j].innerHTML=html;
		}
		if (value!="")
		{
			value=trim(value);
		    if (RowObj.cells[j].firstChild.tagName=="LABEL")
		    {
			    RowObj.cells[j].firstChild.innerText=value;
			}
			else
		    {			    
			    if ((RowObj.cells[j].firstChild.tagName=="INPUT")&&(RowObj.cells[j].firstChild.type=="checkbox"))
			    {
				    if (value==true)
				    {
					    RowObj.cells[j].firstChild.checked=true;
				    }
				    else
				    {
					    RowObj.cells[j].firstChild.checked=false;
					}
				}
			    else
			    {
			    	RowObj.cells[j].firstChild.value=value;
			    }
		    }
		}
	}
}
function AddClickHandler()
{
	try 
	{
		var objtbl=document.getElementById('tDHCEQCBarInfo');
		var rows=objtbl.rows.length;
		LastNameIndex=GetRowIndex(objtbl.rows[rows-1]);
		NewNameIndex=tableList.length;
	    AddRowToList(objtbl,LastNameIndex,NewNameIndex);
	} 
	catch(e) 
	{};
}

function DeleteClickHandler()
{
	var truthBeTold = window.confirm("您确认要删除该行记录吗?");
	if (!truthBeTold) return
	try
	{
		var objtbl=document.getElementById('tDHCEQCBarInfo');
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		var TotalFlag=GetElementValue("TotalFlag");	//s val=##class(web.DHCEQCommon).GetSysInfo("301006")
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID;
		var delNo=GetElementValue("TRowz"+selectrow);
		//判断是否删除仅剩的1行记录
		if (rows<=2)
		{
			//修改删除仅剩的一行后编辑保存数据异常无法保存的问题
			tableList[selectrow]=0;
			if (TRowID!="")
			{
				SetElement('TRowIDz'+selectrow,"");				
				tableList[tableList.length]=TRowID;
			}
		}
		else
		{
			DeleteTabRow(objtbl,selectrow);
		}
	    ResetNo(selectrow,delNo) //重新产生新的序号
	} catch(e) {};
}
function DeleteTabRow(objtbl,selectrow)
{
	var rows=objtbl.rows.length;
	if (rows>2)
	{
		var eSrc=window.event.srcElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex; //当前选择行
		objtbl.deleteRow(selectrow);
	}
}
function GetBorderStyle(value)
{
    GetLookUpID("BorderStyleDR",value);
}
function GetBarStyle(value)
{
    GetLookUpID("BarStyleDR",value);
}
function GetCorrectLevel(value)
{
    GetLookUpID("CorrectLevelDR",value);
}
function GetHold1(value)
{
	var list=value.split("^");
	SetElement('Hold1',list[1]);
}
function LookUpFormatList(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUp("","web.DHCEQCColumns:Format","GetFormat","");
	}
}
function GetFormat(value)
{
	var list=value.split("^");
	SetElement('TFormatz'+selectrow,list[0]);
	SetElement('TFormatDRz'+selectrow,list[1]);
	
	var obj=document.getElementById("TFormatz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}
function GetTableInfo()
{
    var objtbl=document.getElementById('tDHCEQInStockNew');
	var rows=tableList.length
	var valList="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRow=GetCElementValue("TRowz"+i);
			var TRowID=GetElementValue("TRowIDz"+i);
			var TType=GetElementValue("TTypez"+i);
			var TKey=GetElementValue("TKeyz"+i);
			var TCaption=GetElementValue("TCaptionz"+i);
			var TPrtCaption=GetElementValue("TPrtCaptionz"+i);
			var TFontName=GetElementValue("TFontNamez"+i);
			var TFontSize=GetElementValue("TFontSizez"+i);
			var TBold=GetChkElementValue("TBoldz"+i);
			var TLineNum=GetElementValue("TLineNumz"+i);
			var TColNum=GetElementValue("TColNumz"+i);
			var TPrintLine=GetChkElementValue("TPrintLinez"+i);
			var TLeft=GetElementValue("TLeftz"+i);
			var TTop=GetElementValue("TTopz"+i);
			var TCFontName=GetElementValue("TCFontNamez"+i);
			var TCFontSize=GetElementValue("TCFontSizez"+i);
			var TCBold=GetChkElementValue("TCBoldz"+i);
			var TLineX=GetElementValue("TLineXz"+i);
			var TLineY=GetElementValue("TLineYz"+i);
			var TLine=GetElementValue("TLinez"+i);
			var THidden=GetChkElementValue("THiddenz"+i);
			var TFormatDR=GetElementValue("TFormatDRz"+i);
			var TRemark=GetElementValue("TRemarkz"+i);
			var TCharacters=GetElementValue("TCharactersz"+i);
			
			//alert(TType)
			if (TType=="")
			{
				alert("第"+TRow+"行,未设置条码元素信息!");
				return "-1";
			}
			else if (TType=="0")
			{
				//文本
				if ((TLineNum=="")&&((TLeft=="")||(TTop=="")))
				{
					alert("第"+TRow+"行,未设置文本行号及起点XY坐标!");
					return "-1";
				}
			}
			else if (TType=="1")
			{
				//直线
				if ((TLeft=="")||(TTop=="")||(TLineX=="")||(TLineY==""))
				{
					alert("第"+TRow+"行,未设置直线起、始XY坐标!");
					return "-1";
				}
			}
			//alert(GetChkElementValue("TBoldz"+i)+":"+GetElementValue("THiddenz"+i))
			if(valList!="") {valList=valList+"&";}		
			valList=valList+TRow+"^"+TRowID+"^"+TType+"^"+TKey+"^"+TCaption+"^"+TPrtCaption+"^"+TFontName+"^"+TFontSize+"^"+TBold+"^"+TLineNum+"^"+TColNum+"^"+TPrintLine+"^"+TLeft+"^"+TTop+"^"+TCFontName+"^"+TCFontSize+"^"+TCBold+"^"+TLineX+"^"+TLineY+"^"+TLine+"^"+THidden+"^"+TFormatDR+"^"+TRemark+"^"+TCharacters;
		}
	}
	//alert(valList)
	return  valList
}

// 条码配置数据导入
function BImportData_Clicked()
{
	var truthBeTold = window.confirm("每次只能导入一条配置信息!继续吗?");
	if (!truthBeTold) return;
	var FileName=GetFileNameNew();		// MZY0140	2612987		2022-10-31
    if (FileName=="") return 1;
    var xlApp,xlsheet,xlBook
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(FileName);
    xlsheet =xlBook.Worksheets("条码列表");
    
    var Row=3;
    var Col=1;
    //var combindata=GetElementValue("BarInfoDR");
    var Desc=xlsheet.cells(Row,Col++).value;		//BI_Desc
	if (Desc==undefined) Desc="";
    if (Desc==="")
	{
	    alert("条码列表:第"+Row+"行"+"标签名称为空!");
	    return 1;
	}
  	var combindata="^"+Desc;
  	var Style=xlsheet.cells(Row,Col++).value;		//BI_Style
	if (Style==undefined) Style="";
	combindata=combindata+"^"+Style;
	var Left=xlsheet.cells(Row,Col++).value;		//BI_Left
	if (Left==undefined) Left="";
	combindata=combindata+"^"+Left;
	var Top=xlsheet.cells(Row,Col++).value;			//BI_Top
	if (Top==undefined) Top="";
	combindata=combindata+"^"+Top;
	var BorderStyle=xlsheet.cells(Row,Col++).value;	//BI_BorderStyle
	if (BorderStyle==undefined) BorderStyle="";
	combindata=combindata+"^"+BorderStyle;
	var Line=xlsheet.cells(Row,Col++).value;		//BI_Line
	if (Line==undefined) Line="";
	combindata=combindata+"^"+Line;
	var LineB=xlsheet.cells(Row,Col++).value;		//BI_LineB
	if (LineB==undefined) LineB="";
	combindata=combindata+"^"+LineB;
	var BorderX=xlsheet.cells(Row,Col++).value;		//BI_BorderX
	if (BorderX==undefined) BorderX="";
	combindata=combindata+"^"+BorderX;
	var BorderY=xlsheet.cells(Row,Col++).value;		//BI_BorderY
	if (BorderY==undefined) BorderY="";
	combindata=combindata+"^"+BorderY;
	var OffsetX=xlsheet.cells(Row,Col++).value;		//BI_OffsetX
	if (OffsetX==undefined) OffsetX="";
	combindata=combindata+"^"+OffsetX;
	var LineHeigh=xlsheet.cells(Row,Col++).value;	//BI_LineHeigh
	if (LineHeigh==undefined) LineHeigh="";
	combindata=combindata+"^"+LineHeigh;
	var FontName=xlsheet.cells(Row,Col++).value;	//BI_FontName
	if (FontName==undefined) FontName="";
	combindata=combindata+"^"+FontName;
	var FontSize=xlsheet.cells(Row,Col++).value;	//BI_FontSize
	if (FontSize==undefined) FontSize="";
	combindata=combindata+"^"+FontSize;
	var FontBold=xlsheet.cells(Row,Col++).value;	//BI_FontBold
	if (FontBold==undefined) FontBold="";
	if (FontBold=="Y") FontBold=true;
	if (FontBold=="N") FontBold=false;
	combindata=combindata+"^"+FontBold;
	var BarStyle=xlsheet.cells(Row,Col++).value;	//BI_BarStyle
	if (BarStyle==undefined) BarStyle="";
	if (BarStyle==="")
	{
	    alert("条码列表:第"+Row+"行"+"条码样式为空!");
	    return 1;
	}
	combindata=combindata+"^"+BarStyle;
	var BarPosX=xlsheet.cells(Row,Col++).value;		//BI_BarPosX
	if (BarPosX==undefined) BarPosX="";
	if (BarPosX==="")
	{
	    alert("条码列表:第"+Row+"行"+"条码X坐标为空!");
	    return 1;
	}
	combindata=combindata+"^"+BarPosX;
	var BarPosY=xlsheet.cells(Row,Col++).value;		//BI_BarPosY
	if (BarPosY==undefined) BarPosY="";
	if (BarPosY==="")
	{
	    alert("条码列表:第"+Row+"行"+"条码Y坐标为空!");
	    return 1;
	}
	combindata=combindata+"^"+BarPosY;
	var BarWidth=xlsheet.cells(Row,Col++).value;	//BI_BarWidth
	if (BarWidth==undefined) BarWidth="";
	combindata=combindata+"^"+BarWidth;
	var BarHeight=xlsheet.cells(Row,Col++).value;	//BI_BarHeight
	if (BarHeight==undefined) BarHeight="";
	combindata=combindata+"^"+BarHeight;
	var CorrectLevel=xlsheet.cells(Row,Col++).value;//BI_CorrectLevel
	if (CorrectLevel==undefined) CorrectLevel="";
	combindata=combindata+"^"+CorrectLevel;
	var BarMark=xlsheet.cells(Row,Col++).value;		//BI_BarMark
	if (BarMark==undefined) BarMark="";
	combindata=combindata+"^"+BarMark;
	var CapationCellWidth=xlsheet.cells(Row,Col++).value;	//BI_CapationCellWidth
	if (CapationCellWidth==undefined) CapationCellWidth="";
	combindata=combindata+"^"+CapationCellWidth;
	var ColWidth=xlsheet.cells(Row,Col++).value;	//BI_ColWidth
	if (ColWidth==undefined) ColWidth="";
	combindata=combindata+"^"+ColWidth;
	var LineOffset=xlsheet.cells(Row,Col++).value;	//BI_LineOffset
	if (LineOffset==undefined) LineOffset="";
	combindata=combindata+"^"+LineOffset;
	var ActiveFlag=xlsheet.cells(Row,Col++).value;	//BI_ActiveFlag
	if (ActiveFlag==undefined) ActiveFlag="";
	if (ActiveFlag=="Y") ActiveFlag=true;
	if (ActiveFlag=="N") ActiveFlag=false;
	combindata=combindata+"^"+ActiveFlag;
	var PrtName=xlsheet.cells(Row,Col++).value;		//BI_PrtName
	if (PrtName==undefined) PrtName="";
	combindata=combindata+"^"+PrtName;
	var BarLine=xlsheet.cells(Row,Col++).value;		//BI_BarLine
	if (BarLine==undefined) BarLine="";
	combindata=combindata+"^"+BarLine;
	var WordCount=xlsheet.cells(Row,Col++).value;		//BI_WordCount
	if (WordCount==undefined) WordCount="";
	combindata=combindata+"^"+WordCount;
	//Modiedy by zc0057 增加标签打印限定条件  begin
	var BIHold1=xlsheet.cells(Row,Col++).value;		//BI_Hold1
	if (BIHold1==undefined) BIHold1="";
	combindata=combindata+"^"+BIHold1;
	var BIHold2=xlsheet.cells(Row,Col++).value;		//BI_Hold2
	if (BIHold2==undefined) BIHold2="";
	combindata=combindata+"^"+BIHold2;
	//Modiedy by zc0057 增加标签打印限定条件   end
	xlsheet =xlBook.Worksheets("条码元素");
	var MaxRow=xlsheet.UsedRange.Cells.Rows.Count;
	var valList="";
	for (Row=3;Row<=MaxRow;Row++)
	{
	    Col=1;
	    if(valList!="") valList=valList+"&";
		var valList=valList+(Row-2);	//TRow
		valList=valList+"^";			//TRowID
		var TType=xlsheet.cells(Row,Col++).value;	//BD_Type
		if (TType==undefined) TType="";
		valList=valList+"^"+TType;
		var Key=xlsheet.cells(Row,Col++).value;		//BD_Key
		if (Key==undefined) Key="";
		valList=valList+"^"+Key;
		var Caption=xlsheet.cells(Row,Col++).value;		//BD_Caption
		if (Caption==undefined) Caption="";
		valList=valList+"^"+Caption;
		var PrtCaption=xlsheet.cells(Row,Col++).value;	//BD_PrtCaption
		if (PrtCaption==undefined) PrtCaption="";
		valList=valList+"^"+PrtCaption;
		var FontName=xlsheet.cells(Row,Col++).value;	//BD_FontName
		if (FontName==undefined) FontName="";
		valList=valList+"^"+FontName;
		var FontSize=xlsheet.cells(Row,Col++).value;	//BD_FontSize
		if (FontSize==undefined) FontSize="";
		valList=valList+"^"+FontSize;
		var Bold=xlsheet.cells(Row,Col++).value;	//BD_Bold
		if (Bold==undefined) Bold="";
		if (Bold=="Y") Bold=true;
		if (Bold=="N") Bold=false;
		valList=valList+"^"+Bold;
		var LineNum=xlsheet.cells(Row,Col++).value;	//BD_LineNum
		if (LineNum==undefined) LineNum="";
		valList=valList+"^"+LineNum;
		var ColNum=xlsheet.cells(Row,Col++).value;	//BD_ColNum
		if (ColNum==undefined) ColNum="";
		valList=valList+"^"+ColNum;
		var PrintLine=xlsheet.cells(Row,Col++).value;	//BD_PrintLine
		if (PrintLine==undefined) PrintLine="";
		if (PrintLine=="Y") PrintLine=true;
		if (PrintLine=="N") PrintLine=false;
		valList=valList+"^"+PrintLine;
		var Left=xlsheet.cells(Row,Col++).value;	//BD_Left
		if (Left==undefined) Left="";
		valList=valList+"^"+Left;
		var Top=xlsheet.cells(Row,Col++).value;		//BD_Top
		if (Top==undefined) Top="";
		valList=valList+"^"+Top;
		var CFontName=xlsheet.cells(Row,Col++).value;	//BD_CFontName
		if (CFontName==undefined) CFontName="";
		valList=valList+"^"+CFontName;
		var CFontSize=xlsheet.cells(Row,Col++).value;	//BD_CFontSize
		if (CFontSize==undefined) CFontSize="";
		valList=valList+"^"+CFontSize;
		var CBold=xlsheet.cells(Row,Col++).value;	//BD_CBold
		if (CBold==undefined) CBold="";
		if (CBold=="Y") CBold=true;
		if (CBold=="N") CBold=false;
		valList=valList+"^"+CBold;
		var LineX=xlsheet.cells(Row,Col++).value;	//BD_LineX
		if (LineX==undefined) LineX="";
		valList=valList+"^"+LineX;
		var LineY=xlsheet.cells(Row,Col++).value;	//BD_LineY
		if (LineY==undefined) LineY="";
		valList=valList+"^"+LineY;
		var Line=xlsheet.cells(Row,Col++).value;	//BD_Line
		if (Line==undefined) Line="";
		valList=valList+"^"+Line;
		var Hidden=xlsheet.cells(Row,Col++).value;	//BD_Hidden
		if (Hidden==undefined) Hidden="";
		if (Hidden=="Y") Hidden=true;
		if (Hidden=="N") Hidden=false;
		valList=valList+"^"+Hidden;
		var Format=xlsheet.cells(Row,Col++).value;	//BD_Format
		if (Format==undefined) Format="";
		valList=valList+"^"+Format;
		var Remark=xlsheet.cells(Row,Col++).value;	//BD_Remark
		if (Remark==undefined) Remark="";
		valList=valList+"^"+Remark;
		var Characters=xlsheet.cells(Row,Col++).value;	//BD_Characters
		if (Characters==undefined) Characters="";
		valList=valList+"^"+Characters;
		//Modiedy by zc0057 增加标签打印限定条件  begin
		var BDHold1=xlsheet.cells(Row,Col++).value;	//BD_Hold1
		if (BDHold1==undefined) BDHold1="";
		valList=valList+"^"+BDHold1;
		//Modiedy by zc0057 增加标签打印限定条件  end
	    if (TType==="")
		{
			alert("条码元素:第"+TRow+"行,未设置条码元素信息!");
			return "-1";
		}
		else if (TType==0)
		{
			//文本
			if ((LineNum==="")&&((Left==="")||(Top==="")))
			{
				alert("条码元素:第"+TRow+"行,未设置文本行号或起点XY坐标!");
				return "-1";
			}
		}
		else if (TType==1)
		{
			//直线
			if ((Left==="")||(Top==="")||(LineX==="")||(LineY===""))
			{
				alert("条码元素:第"+TRow+"行,未设置直线起、始XY坐标!");
				return "-1";
			}
		}
	}
	var truthBeTold = window.confirm("您确认要导入并新增该条码配置信息吗?");
	if (!truthBeTold) return;
	//valList.replace(/undefined/g,"新字符串")
	//alert(valList)
  	var encmeth=GetElementValue("SaveData");
  	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,combindata,valList,"");
	//alert(result)
    if (result>0)
	{
		alert("操作成功!");
		parent.DHCEQCBarInfoList.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCBarInfoList";
		location.reload();
	}
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    xlsheet.Quit;
    xlsheet=null;
    return 0
}
// MZY0099	2152554		2021-11-13	调整修正导出为IE和Chrome方式
// 条码配置数据导出
function BExportData_Clicked()
{
	if (GetElementValue("BarInfoDR")=="")
	{
		alert("无条码配置信息!");
		return
	}
	var ChromeFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",991109);
	if (ChromeFlag=="1")
	{
		BExport_Chrome();
	}
	else
	{
		BExport_IE();
	}
}
// MZY0099	2152554		2021-11-13
function BExport_IE()
{	
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	try
	{
		var xlApp,xlsheet,xlBook;
		var Template=TemplatePath+"DHCEQCBarInfo.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    //xlBook = xlApp.Workbooks.Add(FileName);
	    xlBook = xlApp.Workbooks.Add(Template);
	    //xlsheet = xlBook.ActiveSheet
	    xlsheet = xlBook.Worksheets("条码列表");
		var encmeth=GetElementValue("GetPrintBarInfo");
		if (encmeth=="") return;
		var Listall=cspRunServerMethod(encmeth, -1, GetElementValue("BarInfoDR"));	// Mozy003007		2020-04-07	调整参数
		var Lists=Listall.split(GetElementValue("SplitRowCode"));
		var InfoList=Lists[0].split("^");
		//var DetailList=Lists[1].split("&");	// Mozy003007		2020-04-07
		//alert(Lists[1])
		//维条码左侧打印-南方医院^1^60^500^0^2^2^3500^2000^1350^200^宋体^10^Y^0^160^600^1200^0^3^EQNo^0^520^0^Y^tiaoma^2^N^1^65199^60734^^^^^^标准二维码^2400301000328$CHAR(3)
		xlsheet.cells(3,1)=InfoList[0]; //BI_Desc
		xlsheet.cells(3,2)=InfoList[1]; //BI_Style
		xlsheet.cells(3,3)=InfoList[2]; //BI_Left
		xlsheet.cells(3,4)=InfoList[3]; //BI_Top
		xlsheet.cells(3,5)=InfoList[4]; //BI_BorderStyle
		xlsheet.cells(3,6)=InfoList[5]; //BI_Line
		xlsheet.cells(3,7)=InfoList[6]; //BI_LineB
		xlsheet.cells(3,8)=InfoList[7]; //BI_BorderX
		xlsheet.cells(3,9)=InfoList[8]; //BI_BorderY
		xlsheet.cells(3,10)=InfoList[9]; //BI_OffsetX
		xlsheet.cells(3,11)=InfoList[10]; //BI_LineHeigh
		xlsheet.cells(3,12)=InfoList[11]; //BI_FontName
		xlsheet.cells(3,13)=InfoList[12]; //BI_FontSize
		xlsheet.cells(3,14)="N"; 		//BI_FontBold
		if (InfoList[13]=="Y")
		{
			xlsheet.cells(3,14)="Y"; 	//BI_FontBold
		}
		xlsheet.cells(3,15)=InfoList[14]; //BI_BarStyle
		xlsheet.cells(3,16)=InfoList[15]; //BI_BarPosX
		xlsheet.cells(3,17)=InfoList[16]; //BI_BarPosY
		xlsheet.cells(3,18)=InfoList[17]; //BI_BarWidth
		xlsheet.cells(3,19)=InfoList[18]; //BI_BarHeight
		xlsheet.cells(3,20)=InfoList[19]; //BI_CorrectLevel
		xlsheet.cells(3,21)=InfoList[20]; //BI_BarMark
		xlsheet.cells(3,22)=InfoList[21]; //BI_CapationCellWidth
		xlsheet.cells(3,23)=InfoList[22]; //BI_ColWidth
		xlsheet.cells(3,24)=InfoList[23]; //BI_LineOffset
		xlsheet.cells(3,25)="N"; 		//BI_ActiveFlag
		if (InfoList[24]=="Y")
		{
			xlsheet.cells(3,25)="Y"; 	//BI_FontBold
		}
		xlsheet.cells(3,26)=InfoList[25]; //BI_PrtName
		xlsheet.cells(3,27)=InfoList[26]; //BI_BarLine
		xlsheet.cells(3,28)=InfoList[31]; //WordCount
		xlsheet.cells(3,29)=InfoList[32]; //BI_Hold1
		xlsheet.cells(3,30)=InfoList[33]; //BI_Hold2
		/*xlsheet.cells(3,28)=InfoList[27]; //BI_InvalidFlag
		xlsheet.cells(3,29)=InfoList[28]; //BI_UpdateUserDR
		xlsheet.cells(3,30)=InfoList[29]; //BI_UpdateDate
		xlsheet.cells(3,31)=InfoList[30]; //BI_UpdateTime
		xlsheet.cells(3,34)=InfoList[34]; //BI_Hold3
		xlsheet.cells(3,35)=InfoList[35]; //BI_Hold4
		xlsheet.cells(3,36)=InfoList[36]; //BI_Hold5*/
		
		xlsheet = xlBook.Worksheets("条码元素");
		// Mozy003007		2020-04-07	调整取值
		for (var i=1;i<Lists.length;i++)
		{
			//alert(Lists[i])
			var row=2+i;
			var tmplist=Lists[i].split("^");
			//xlsheet.cells(row,1)=tmplist[0]; //BD_BarInfoDR
			xlsheet.cells(row,1)=tmplist[1]; //BD_Type
			xlsheet.cells(row,2)=tmplist[2]; //BD_Key
			xlsheet.cells(row,3)=tmplist[3]; //BD_Caption
			xlsheet.cells(row,4)=tmplist[4]; //BD_PrtCaption
			xlsheet.cells(row,5)=tmplist[5]; //BD_FontName
			xlsheet.cells(row,6)=tmplist[6]; //BD_FontSize
			xlsheet.cells(row,7)=tmplist[7]; //BD_Bold
			xlsheet.cells(row,8)=tmplist[8]; //BD_LineNum
			xlsheet.cells(row,9)=tmplist[9]; //BD_ColNum
			xlsheet.cells(row,10)=tmplist[10]; //BD_PrintLine
			xlsheet.cells(row,11)=tmplist[11]; //BD_Left
			xlsheet.cells(row,12)=tmplist[12]; //BD_Top
			xlsheet.cells(row,13)=tmplist[13]; //BD_CFontName
			xlsheet.cells(row,14)=tmplist[14]; //BD_CFontSize
			xlsheet.cells(row,15)=tmplist[15]; //BD_CBold
			xlsheet.cells(row,16)=tmplist[16]; //BD_LineX
			xlsheet.cells(row,17)=tmplist[17]; //BD_LineY
			xlsheet.cells(row,18)=tmplist[18]; //BD_Line
			xlsheet.cells(row,19)=tmplist[19]; //BD_Hidden
			xlsheet.cells(row,20)=tmplist[20]; //BD_Format
			xlsheet.cells(row,21)=tmplist[21]; //BD_Remark
			xlsheet.cells(row,22)=tmplist[22]; //BD_Characters
			//xlsheet.cells(row,22)=tmplist[22]; //BD_Hold1
			//xlsheet.cells(row,23)=tmplist[23]; //BD_Hold2
			//xlsheet.cells(row,24)=tmplist[24]; //BD_Hold3
			//xlsheet.cells(row,25)=tmplist[25]; //BD_Hold4
			//xlsheet.cells(row,26)=tmplist[26]; //BD_Hold5
		}
		var savepath=GetFileNameNew();		// MZY0099	2152554		2021-11-13
		xlBook.SaveAs(savepath);
	    xlBook.Close (savechanges=false);
	    xlsheet.Quit;
	    xlsheet=null;
	    xlApp=null;
	} 
	catch(e)
	{
		alert(e.message);
	}
	alert("操作完成!");
}
function LookBarDetailKey(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUp("","web.DHCEQCBarInfo:BarDetailKeyList","GetBarDetailKey","TKeyz"+selectrow);
	}
}
function GetBarDetailKey(value)
{
	var list=value.split("^");
	SetElement('TKeyz'+selectrow,list[2]);
	SetElement('TCaptionz'+selectrow,list[3]);
}
// MZY0099	2152554		2021-11-13
function BExport_Chrome()
{
	var FileName=GetFileNameNew();
	if (FileName=="") {return;}
	var NewFileName=filepath(FileName,"\\","\\\\")
	var NewFileName=NewFileName.substr(0,NewFileName.length-4)
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var encmeth=GetElementValue("GetPrintBarInfo");
	if (encmeth=="") return;
	var Listall=cspRunServerMethod(encmeth, -1, GetElementValue("BarInfoDR"));
	var splitChar=GetElementValue("SplitRowCode");
	
	// Chrome兼容性处理
	var Str ="(function test(x){"
	Str +="var xlApp,xlsheet,xlBook;"
	Str +="var Template='"+TemplatePath+"DHCEQCBarInfo.xls';"
	Str +="xlApp = new ActiveXObject('Excel.Application');"
	Str +="xlBook = xlApp.Workbooks.Add(Template);"
	
	Str +="var ListallStr='"+Listall+"';"
	Str +="var Lists=ListallStr.split('"+splitChar+"');"
	Str +="var InfoList=Lists[0].split('^');"
	
	//Str +="xlsheet = xlBook.ActiveSheet;"
	Str +="xlsheet = xlBook.Worksheets('条码列表');"
	Str +="xlsheet.cells(3,1)=InfoList[0];"
	Str +="xlsheet.cells(3,2)=InfoList[1];"
	Str +="xlsheet.cells(3,3)=InfoList[2];"
	Str +="xlsheet.cells(3,4)=InfoList[3];"
	Str +="xlsheet.cells(3,5)=InfoList[4];"
	Str +="xlsheet.cells(3,6)=InfoList[5];"
	Str +="xlsheet.cells(3,7)=InfoList[6];"
	Str +="xlsheet.cells(3,8)=InfoList[7];"
	Str +="xlsheet.cells(3,9)=InfoList[8];"
	Str +="xlsheet.cells(3,10)=InfoList[9];"
	Str +="xlsheet.cells(3,11)=InfoList[10];"
	Str +="xlsheet.cells(3,12)=InfoList[11];"
	Str +="xlsheet.cells(3,13)=InfoList[12];"
	Str +="xlsheet.cells(3,14)='N';"
	Str +="if (InfoList[13]=='Y') xlsheet.cells(3,14)='Y';"
	Str +="xlsheet.cells(3,15)=InfoList[14];"
	Str +="xlsheet.cells(3,16)=InfoList[15];"
	Str +="xlsheet.cells(3,17)=InfoList[16];"
	Str +="xlsheet.cells(3,18)=InfoList[17];"
	Str +="xlsheet.cells(3,19)=InfoList[18];"
	Str +="xlsheet.cells(3,20)=InfoList[19];"
	Str +="xlsheet.cells(3,21)=InfoList[20];"
	Str +="xlsheet.cells(3,22)=InfoList[21];"
	Str +="xlsheet.cells(3,23)=InfoList[22];"
	Str +="xlsheet.cells(3,24)=InfoList[23];"
	Str +="xlsheet.cells(3,25)='N';"
	Str +="if (InfoList[24]=='Y') xlsheet.cells(3,25)='Y';"
	Str +="xlsheet.cells(3,26)=InfoList[25];"
	Str +="xlsheet.cells(3,27)=InfoList[26];"
	Str +="xlsheet.cells(3,28)=InfoList[31];"
	Str +="xlsheet.cells(3,29)=InfoList[32];"
	Str +="xlsheet.cells(3,30)=InfoList[33];"
	
	Str +="xlsheet = xlBook.Worksheets('条码元素');"
	Str +="for (var i=1;i<Lists.length;i++){"
	Str +="var row=2+i;"
	Str +="var tmplist=Lists[i].split('^');"
	Str +="xlsheet.cells(row,1)=tmplist[1];"
	Str +="xlsheet.cells(row,2)=tmplist[2];"
	Str +="xlsheet.cells(row,3)=tmplist[3];"
	Str +="xlsheet.cells(row,4)=tmplist[4];"
	Str +="xlsheet.cells(row,5)=tmplist[5];"
	Str +="xlsheet.cells(row,6)=tmplist[6];"
	Str +="xlsheet.cells(row,7)=tmplist[7];"
	Str +="xlsheet.cells(row,8)=tmplist[8];"
	Str +="xlsheet.cells(row,9)=tmplist[9];"
	Str +="xlsheet.cells(row,10)=tmplist[10];"
	Str +="xlsheet.cells(row,11)=tmplist[11];"
	Str +="xlsheet.cells(row,12)=tmplist[12];"
	Str +="xlsheet.cells(row,13)=tmplist[13];"
	Str +="xlsheet.cells(row,14)=tmplist[14];"
	Str +="xlsheet.cells(row,15)=tmplist[15];"
	Str +="xlsheet.cells(row,16)=tmplist[16];"
	Str +="xlsheet.cells(row,17)=tmplist[17];"
	Str +="xlsheet.cells(row,18)=tmplist[18];"
	Str +="xlsheet.cells(row,19)=tmplist[19];"
	Str +="xlsheet.cells(row,20)=tmplist[20];"
	Str +="xlsheet.cells(row,21)=tmplist[21];"
	Str +="xlsheet.cells(row,22)=tmplist[22];}"
	
	Str +="xlBook.SaveAs('"+NewFileName+"');"
	Str +="xlBook.Close (savechanges=false);"
	Str +="xlApp.Quit();"
	Str +="xlApp=null;"
	Str +="xlsheet.Quit;"
	Str +="xlsheet=null;"
	Str +="return 1;}());";
	//以上为拼接Excel打印代码为字符串
	CmdShell.notReturn = 0;
	//alert(Str)
	var rtn = CmdShell.EvalJs(Str);
	if (rtn.rtn==1)
	{
	    alert("导出完成!");
	}
}
function GetFileNameNew()
{
	var ChromeFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",991109);
	if (ChromeFlag=="1")
	{
		var Str ="(function test(x){"
		Str +="var xlApp = new ActiveXObject('Excel.Application');"
		Str +="var fName = xlApp.GetSaveAsFilename('','Excel File(*.xls),*.xls');"
		Str +="if (fName==false){return ''}"
		Str += "return fName}());";
		CmdShell.notReturn =0;   			//设置无结果调用不阻塞调用
		var rtn = CmdShell.EvalJs(Str);   	//通过中间件运行
		return rtn.rtn
	}
	else
	{
		try
		{
			var xls = new ActiveXObject("Excel.Application");
			var fName = xls.GetSaveAsFilename("","Excel File(*.xls),*.xls")
			if (fName==false)
			{
			 fName=""
			}
			return fName
		}
		catch(e)
		{
			return "";
		}
	}
}
function filepath(oldpath,findstr,replacestr)
{
	if (oldpath=="") return ""
	var newpath=""
	var pathcount=oldpath.length
	for (var i=0;i<pathcount;i++)
	{
		var curchar=oldpath.substr(0,1)
		if (curchar==findstr)
		{
			newpath=newpath+replacestr
		}
		else
		{
			newpath=newpath+curchar
		}
		oldpath=oldpath.substr(1,oldpath.length)
	}
	return newpath
}
