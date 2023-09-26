///Modified By HZY 2011-10-08 HZY0013
///�޸ĺ���:BodyLoadHandler , GetHref , InitPage , BPrint_Click
///���Ӻ���:GetToLoc , SetValues , GetEquipType , ChangeType_Change
///--------------------------------
///�޸�: ZY 2009-11-17 ZY0017
///�޸ĺ���BPrint_Click
///����:����ʱ����·��������
/// -------------------------------
function BodyLoadHandler(){		
	InitPage();
	SetValues();	//Add By HZY 2011-10-08 HZY0013
	SetLink();
}

///Add By HZY 2011-10-08 HZY0013
function SetValues()
{
	SetElement("ChangeType",GetElementValue("ChangeTypeDR"))
	SetElement("SubChangeType",GetElementValue("SubChangeTypeDR"))
}

function SetLink()
{
	var SelRowObj;
	var objtbl=document.getElementById('tDHCEQChangeStockFind');
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		SelRowObj=document.getElementById('TChangeTypez'+i);
		if (SelRowObj)
		{
		SelRowObj.onclick=lnk_Click;//����
		SelRowObj.href="#";
		}
	}	
}
function lnk_Click()
{
	var eSrc=window.event.srcElement;	//��ȡ�¼�Դͷ
	var row=GetRowByColName(eSrc.id);//����
    var lnk=GetHref(row);//����
    window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}
function GetRowByColName(colname)
{
	var offset=colname.lastIndexOf("z");
	var row=colname.substring(offset+1);
	return row;
}

///Modified By HZY 2011-10-10 HZY0013
///Desc:����?����?�䶯���� .
function GetHref(row)
{
	var TypeObj=document.getElementById('TChangeTypeDRz'+row);
	var SourceObj=document.getElementById('TParSourceIDz'+row);
	var SourceDR=SourceObj.value;
	var Type=TypeObj.value;
	var ComponentName=""
	switch (Type) { 
   	case "0" :
       ComponentName="DHCEQInstockNew"		//�������
       break;
   	case "1" :
       ComponentName="DHCEQStoreMoveNew"	//ת��
        break;
    case "2" :
       ComponentName="DHCEQReturnNew"		//�˻�
        break;
   	case "3" :
       ComponentName="DHCEQOutStockNew"		//����. Add By HZY 2011-10-09 HZY0013
        break;
    case "4" :
       
        break;
   	case "5" :
       
        break;
   	default :
       
	} 
	var lnk="";
	lnk='websys.default.csp?WEBSYS.TCOMPONENT='+ComponentName+'&RowID='+SourceDR;	
	return lnk;
}

///Modified By HZY 2011-10-10 HZY0013
///Desc:���'�䶯������'�仯��Ӧ�¼��ĳ�ʼ�� .
function InitPage()
{
	KeyUp("StoreLoc^Equip^ToLoc^EquipType");
	Muilt_LookUp("StoreLoc^Equip^ToLoc^EquipType");
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("ChangeType");	///Add By HZY 2011-10-09 HZY0013
	if (obj) obj.onchange=ChangeType_Change;
}

///Add By HZY 2011-10-09 HZY0013
///Desc:'�䶯������'�仯�¼�����Ӧ���� .
function ChangeType_Change()
{
	SetElement("ChangeTypeDR",GetElementValue("ChangeType"));	
	var obj=document.getElementById("SubChangeType");	
	if (obj)
	{
		var encmeth=GetElementValue("GetCboHtml");
		if (encmeth=="") return;
		var	HtmlStr=cspRunServerMethod(encmeth,GetElementValue("ChangeType"),"SubChangeType",155);
		obj.parentElement.innerHTML=HtmlStr;
		return;
	}
}

/// Modified By HZY 2011-10-10 HZY0013
/// Desc:����5��������ӡ���ֶ�,�������˴�ӡģ�� DHCEQChangeStock.xls .
/// ----------------------------------
///Creator:ZY  2009-03-19 ZY0017
///��ӡ��������
function BPrint_Click()
{
	//0            1              2                 3          4              5               6                 7             8               9          10            11            12                  13                14
	//TRowID_"^"_TEquipDR_"^"_TStoreLocDR_"^"_TFromToLoc_"^"_TSourceID_"^"_TChangeType_"^"_TChangeDate_"^"_TAuditUserDR_"^"_TAuditDate_"^"_TEquip_"^"_TStoreLoc_"^"_TAuditUser_"^"_TChangeTypeDR_"^"_TParSourceID_"^"_TBillChangeDate
	var encmeth=GetElementValue("GetPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="")  return;
	var encmeth=GetElementValue("GetChangeStockDetail");
	var TotalRows=cspRunServerMethod(encmeth,0,TJob);
	
	var PageRows=43 //ÿҳ�̶�����
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try {
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQChangeStock.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    	//xlsheet.PageSetup.RightMargin=0;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=0
	    	if (ModRows==0)
	    	{
		    	OnePageRow=PageRows
	    	}
	    	else
	    	{
	    		if (i==Pages)
	    		{
		    		OnePageRow=ModRows
	    		}
		    	else
		    	{
			    	OnePageRow=PageRows
		    	}
	    	}
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
			    var OneDetail=cspRunServerMethod(encmeth,l,TJob);
		    	var OneDetailList=OneDetail.split("^");
		    	var j=k+3;
		    	xlsheet.Rows(j).Insert();
		    	var StoreLocList=OneDetailList[10].split("-");
		    	if (StoreLocList[1]!="")
		    	{
			    	var StoreLoc=StoreLocList[1];
		    	}
		    	else
		    	{
			    	var StoreLoc=OneDetailList[4]
		    	}
		    	var FromLocList=OneDetailList[3].split("-");
		    	if (FromLocList[1]!="")
		    	{
			    	var FromLoc=FromLocList[1];
		    	}
		    	else
		    	{
			    	var FromLoc=OneDetailList[4]
		    	}
		    	//Start Modified By HZY 2011-10-10 HZY0013
		    	xlsheet.cells(j,1)=OneDetailList[9];
		    	xlsheet.cells(j,2)=OneDetailList[16];
		    	xlsheet.cells(j,3)=OneDetailList[19];
		    	xlsheet.cells(j,4)=OneDetailList[15];
		    	xlsheet.cells(j,5)=OneDetailList[20];
		    	xlsheet.cells(j,6)=OneDetailList[22];
		    	xlsheet.cells(j,7)=OneDetailList[5];
		    	xlsheet.cells(j,8)=StoreLoc;
		    	xlsheet.cells(j,9)=FromLoc;
		    	xlsheet.cells(j,10)=FormatDate(OneDetailList[6]);
		    	//End Modified By HZY 2011-10-10 HZY0013
			}
			
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,1)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
			xlsheet.cells(2,1)="ʱ�䷶Χ:"+FormatDate(GetElementValue("StartDate"))+"--"+FormatDate(GetElementValue("EndDate"))
			xlsheet.cells(j+1,5)="�Ʊ���:"
			xlsheet.cells(j+1,6)=curUserName
	    	//xlsheet.printout; //��ӡ���
			var savepath=GetFileName();
			xlBook.SaveAs(savepath);
			alertShow('����ɹ�,����·��:'+savepath);	//Add By HZY 2011-10-10 HZY0013
	    	xlBook.Close (savechanges=false);
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
} 
function GetStoreLoc(value)
{
	GetLookUpID("StoreLocDR",value);
}

///Add By HZY 2011-10-08 HZY0013
function GetToLoc(value)
{
	GetLookUpID("ToLocDR",value);
}
///Add By HZY 2011-10-08 HZY0013
function GetEquipType(value)
{
	GetLookUpID("EquipTypeDR",value);
}

function GetEquip(value)
{
	GetLookUpID("EquipDR",value);
}
document.body.onload = BodyLoadHandler;
