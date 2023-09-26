
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//��ʼ��
	KeyUp("MasterItem^EquipCat^UseLoc^EquipType^StatCat");	//���ѡ��	
	Muilt_LookUp("MasterItem^EquipCat^UseLoc^EquipType^StatCat");
}

function InitEvent() //��ʼ��
{
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById(GetLookupName("EquipCat"));
	if (obj) obj.onclick=EquipCat_Click;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}

function BClear_Click() //��հ�ť
{
	SetElement("MasterItem","");  
	SetElement("MasterItemDR","");
	SetElement("MinValue","");
	SetElement("MaxValue","");
	SetElement("StatCat","");
	SetElement("StatCatDR","");
	SetElement("EquipType","");
	SetElement("EquipTypeDR","");
	SetElement("EquipCat","");
	SetElement("EquipCatDR","");
	SetElement("UseLoc","");
	SetElement("UseLocDR","");
	SetChkElement("IncludeFlag","");
}
///��ӡ����
function BPrint_Click()
{
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var encmeth=GetElementValue("GetEquipDistributionReport");
	var TotalRows=cspRunServerMethod(encmeth,0);
	var PageRows=30                          //ÿҳ�̶�����
	var Pages=parseInt(TotalRows/PageRows)   //��ҳ��  
	var ModRows=TotalRows%PageRows           //���һҳ����
	if (ModRows==0) Pages=Pages-1		
    try {
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQEquipDistribution.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;	    	
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
		    	var OneDetail=cspRunServerMethod(encmeth,l);
		    	var OneDetailList=OneDetail.split("^");
		    	var j=k+3;
		    	xlsheet.Rows(j).Insert();		    	
		    	xlsheet.cells(j,1)=OneDetailList[1];	///�豸����
		    	xlsheet.cells(j,2)=OneDetailList[2];	///�豸��
		    	xlsheet.cells(j,3)=OneDetailList[3];	///�豸����	    	
		    	xlsheet.cells(j,4)=OneDetailList[4];	///�豸����
		    	xlsheet.cells(j,5)=OneDetailList[5];	///�豸����	
		    	xlsheet.cells(j,6)=OneDetailList[6];	///�豸ԭֵ		    	
		    	xlsheet.cells(j,7)=OneDetailList[7];	///ʹ�ÿ���		    	
			}	
			if (GetElementValue("EquipType")=="") //�豸����
			{
				if (GetElementValue("StatCat")=="") ///�豸����
			   {
				    xlsheet.cells(1,1)="�����豸�ֲ�ͳ�Ʊ���"
			   }
			    else
			   {
				    xlsheet.cells(1,1)="�����豸�ֲ�ͳ�Ʊ���("+GetElementValue("StatCat")+")"
			   }	
			}
			else
			{
				if (GetElementValue("StatCat")=="") 
			   {
				    xlsheet.cells(1,1)="�����豸�ֲ�ͳ�Ʊ���("+GetElementValue("EquipType")+")"
			   }
			    else
			   {
				    xlsheet.cells(1,1)="�����豸�ֲ�ͳ�Ʊ���("+GetElementValue("EquipType")+"-"+GetElementValue("StatCat")+")"
			   }
			}	
			if (GetElementValue("EquipCat")=="") ///�豸����
			{
				 if (GetElementValue("MasterItem")=="") //�豸��
			    {
				    xlsheet.cells(2,1)=""
			    }
			    else
			    {
				    xlsheet.cells(2,1)="�豸��:"
				    xlsheet.cells(2,2)=GetElementValue("MasterItem")
			    }	
			}
			else
			{
				 if (GetElementValue("MasterItem")=="") //�豸��
			    {
				    xlsheet.cells(2,1)="�豸����:"
				    xlsheet.cells(2,2)=GetElementValue("EquipCat")
			    }
			    else
			    {
				    xlsheet.cells(2,1)="�豸����/�豸��:"
				    xlsheet.cells(2,2)=GetElementValue("EquipCat")+"/"+GetElementValue("MasterItem")
			    }
			}
			if (GetElementValue("UseLoc")=="") //ʹ�ÿ���
			{
				xlsheet.cells(2,4)=""
			}
			else
			{
				xlsheet.cells(2,4)="ʹ�ÿ���:"+GetElementValue("UseLoc")
			}			
			if (GetElementValue("MinValue")=="") //�豸ԭֵ��Χ
			{
				if (GetElementValue("MaxValue")=="") //�豸ԭֵ��Χ
			    {
				xlsheet.cells(2,6)=""
			    }
			    else
			    {				    
				xlsheet.cells(2,6)="��Χ:"
				xlsheet.cells(2,7)="<="+GetElementValue("MaxValue")
			    }
			}
			else
			{
				if (GetElementValue("MaxValue")=="") //�豸ԭֵ��Χ
			    {
				xlsheet.cells(2,6)="��Χ:"
				xlsheet.cells(2,7)=">="+GetElementValue("MinValue")
			    }
			    else
			    {				    
				xlsheet.cells(2,6)="��Χ:"
				xlsheet.cells(2,7)="��"+GetElementValue("MinValue")+"��"+GetElementValue("MaxValue")
			    }
			}		
			xlsheet.Rows(j+1).Delete();	
			xlsheet.cells(j+1,1)="�Ʊ���:"+curUserName			
			xlsheet.cells(j+1,4)="�Ʊ�����:"+FormatDate(GetCurrentDate())			
			xlsheet.cells(j+1,7)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
	    	xlsheet.printout; //��ӡ���
	    	//xlsheet.PrintPreview 	
	    	//xlBook.SaveAs("D:\DHCEQCEmployeeType.xls");    	
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
///ȡ���豸��rowid
function GetMasterItem(value)
{
	var obj=document.getElementById("MasterItemDR");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}
///ȡ���豸����rowid
function GetEquipType(value)
{
	var obj=document.getElementById("EquipTypeDR");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}
function EquipCat_Click()
{
	var CatName=GetElementValue("EquipCat")
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}

function SetEquipCat(id,text)
{
	SetElement("EquipCat",text);
	SetElement("EquipCatDR",id);
}
//ȡ���豸����rowid
function GetEquipCat(value)
{
	var obj=document.getElementById("EquipCatDR");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}


///ȡ���豸����rowid
function GetStatCat(value) 
{	
	var obj=document.getElementById("StatCatDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
///ȡ���豸ʹ�ÿ���rowid
function GetUseLoc(value)
{
	var obj=document.getElementById("UseLocDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}


function BFind_Click()
{
	var flag=GetChkElementValue("IncludeFlag")
	if (flag==false)
	{
		flag=""
	}
	else
	{
		flag=1
	}
	var val="&MasterItemDR="+GetElementValue("MasterItemDR");
	val=val+"&EquipTypeDR="+GetElementValue("EquipTypeDR");
	val=val+"&UseLocDR="+GetElementValue("UseLocDR");
	val=val+"&EquipCatDR="+GetElementValue("EquipCatDR");
	val=val+"&StatCatDR="+GetElementValue("StatCatDR");
	val=val+"&MinValue="+GetElementValue("MinValue");
	val=val+"&MaxValue="+GetElementValue("MaxValue");
	val=val+"&IncludeFlag="+flag;
	val=val+"&QXType="+GetElementValue("QXType");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipDistribution"+val;
}


//����ҳ����ط���
document.body.onload = BodyLoadHandler;
