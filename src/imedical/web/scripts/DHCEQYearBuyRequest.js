//------------------------------------------------------------
//modified by GR2014-10-24 ȱ�ݺ�3221
//�豸�ɹ�����-��Ȳɹ���������-��������������ϸ�Ĳɹ���������ʱ��ִ�гɹ�����ʾ"xx���뵥�����ϵ��ݲ���ʧ��!",����һ����ϸ�⣬������������Զ����
//�޸ģ�������ͬһ�������ϸ��¼ͬʱִ����˲���
//-------------------------------------------------------------------------
var SelectedRow = 0;
var rowid=0;

function BodyLoadHandler() 
{	
	InitUserInfo();
	InitPage();
	KeyUp("RequestLoc")
	Muilt_LookUp("RequestLoc")
	var Flag=GetChkElementValue("ApproveFlag")
	if (Flag==false)
	{
		DisableBElement("BExecute",false)
	}
	else
	{
		DisableBElement("BExecute",true)
	}
}

function InitPage()
{
	var obj=document.getElementById("BFind"); //����
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BExport"); //����
	if (obj) obj.onclick=BExport_Click;
	var obj=document.getElementById("BSelectAll"); //ȫѡ
	if (obj) obj.onclick=BSelectAll_Click;
	var obj=document.getElementById("BExecute"); //ִ��
	if (obj) obj.onclick=BExecute_Click;
}

function BFind_Click()
{
	var Flag=GetChkElementValue("ApproveFlag")
	if (Flag==false)
	{
		Flag=0
	}
	else
	{
		Flag=1
	}
	var val="&PrjName="+GetElementValue("PrjName");
	val=val+"&RequestNo="+GetElementValue("RequestNo");
	val=val+"&StartDate="+GetElementValue("StartDate")
	val=val+"&EndDate="+GetElementValue("EndDate")
	val=val+"&BRYear="+GetElementValue("BRYear")
	val=val+"&RequestLocDR="+GetElementValue("RequestLocDR")
	val=val+"&RequestLoc="+GetElementValue("RequestLoc")
	val=val+"&ApproveRole="+GetElementValue("ApproveRole")
	val=val+"&ApproveFlag="+Flag
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQYearBuyRequest"+val;
}

function BExport_Click()
{
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="")  return;
	var encmeth=GetElementValue("GetOneYearBuyRequest");
	var TotalRows=cspRunServerMethod(encmeth,0,TJob);
	
	var PageRows=43 //ÿҳ�̶�����
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try {
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQYearBuyRequest.xls";
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
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
			    var OneDetail=cspRunServerMethod(encmeth,l,TJob);
		    	var OneDetailList=OneDetail.split("^");
		    	var j=k+3;
		    	xlsheet.Rows(j).Insert();
		    	xlsheet.cells(j,1)=OneDetailList[1];
		    	xlsheet.cells(j,2)=GetShortName(OneDetailList[15],"-");
		    	xlsheet.cells(j,3)=FormatDate(OneDetailList[4]);
		    	xlsheet.cells(j,4)=OneDetailList[5];
		    	xlsheet.cells(j,5)=OneDetailList[3];
		    	xlsheet.cells(j,6)=OneDetailList[6];
		    	xlsheet.cells(j,7)=OneDetailList[7];
		    	xlsheet.cells(j,8)=OneDetailList[9];
		    	xlsheet.cells(j,9)=OneDetailList[10];
		    	xlsheet.cells(j,10)=OneDetailList[11];
			}
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,10)="��"+(i+1)+"ҳ("+"��"+(Pages+1)+"ҳ)"
			xlsheet.cells(2,1)="ʱ�䷶Χ:"+FormatDate(GetElementValue("StartDate"))+"--"+FormatDate(GetElementValue("EndDate"))
			xlsheet.cells(j+1,8)="�Ʊ���:"
			xlsheet.cells(j+1,9)=curUserName
	    	//xlsheet.printout; //��ӡ���
			var savepath=GetFileName();  //Modified By ZY 2009-11-17 ZY0017
			xlBook.SaveAs(savepath);   //Modified By ZY 2009-11-17 ZY0017
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

function BSelectAll_Click()
{
	var obj=document.getElementById("BSelectAll")
	if (obj.innerText=="ȫѡ(��ǰҳ)")
	{
		obj.innerText="��ѡ(��ǰҳ)"
		var flag=1
	}
	else
	{
		obj.innerText="ȫѡ(��ǰҳ)"
		var flag=0
	}
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQYearBuyRequest');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		selobj.checked=flag;
	}
}

///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQYearBuyRequest');
	var Rows=Objtbl.rows.length;
	var Count=0
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			Count=Count+1
		}
	}
	var obj=document.getElementById("BSelectAll")
	if (Count==(Rows-1))
	{
		obj.innerText="��ѡ(��ǰҳ)"
	}
	else
	{
		obj.innerText="ȫѡ(��ǰҳ)"
	}
}

function GetAuditData(ID)
{
	var ValueList="";
	ValueList=GetElementValue("TRowIDz"+ID);
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+GetElementValue("TCancelToFlowz"+ID);
	ValueList=ValueList+"^"+GetElementValue("TApproveInfoz"+ID);
  	ValueList=ValueList+"^";
	ValueList=ValueList+"^"+GetElementValue("TRejectReasonz"+ID);
	
	return ValueList;
}
function BExecute_Click()
{
	//�Ƿ���ѡ���¼
	var ErrorStr=""
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQYearBuyRequest');
	var Rows=Objtbl.rows.length;
	var Count=0
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			Count=Count+1
			//δ��������
			var ApproveNum=GetElementValue("TApproveNumz"+i)
			var RejectReason=GetElementValue("TRejectReasonz"+i)
			var ApproveInfo=GetElementValue("TApproveInfoz"+i)
			var RequestNum=GetElementValue("TRequestNumz"+i)
			if (ApproveNum=="")
			{
				alertShow("["+GetElementValue("TNamez"+i)+"] δ������������!")
				SetFocus("TApproveNumz"+i)
				return
			}
			
			if (isNaN(ApproveNum))
			{
				alertShow("��������ȷ����������!")
				return
			}
			else
			{
				if ((ApproveNum*1)>(RequestNum*1))
				{
					alertShow("�����������ܴ�����������!")
					return
				}
			}
			//����Ϊ0,δ����ܾ�ԭ��
			if ((ApproveNum==0)&&(RejectReason==""))
			{
				alertShow("["+GetElementValue("TNamez"+i)+"] ������ܾ�ԭ��!")
				SetFocus("TRejectReasonz"+i)
				return
			}
			//������Ϊ0,δ�������������
			if ((ApproveNum!=0)&&(ApproveInfo==""))
			{
				alertShow("["+GetElementValue("TNamez"+i)+"] �������������!")
				SetFocus("TApproveInfoz"+i)
				return
			}
		}
	}
	if (Count==0)
	{
		alertShow("δѡ��ִ�м�¼!")
		return
	}
	//��ʼִ��
	var CurRole=GetElementValue("ApproveRole");
  	if (CurRole=="") return;
  	var encmeth=GetElementValue("AuditData");
  	if (encmeth=="") return;
  	var encmeth1=GetElementValue("CancelSubmitData");
  	if (encmeth1=="") return;
	for (var i=1;i<=Rows-1;i++)		//Modify DJ 2015-09-07 DJ0160
	{
		InitEditFields(GetElementValue("TApproveSetz"+i),CurRole)
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			ApproveNum=GetElementValue("TApproveNumz"+i)
			var RoleStep=GetElementValue("TRoleStepz"+i);
			var combindata=GetAuditData(i);
			//���
			if (ApproveNum!=0)
			{
			  	var objtbl=document.getElementById('tDHCEQYearBuyRequest');
				var EditFieldsInfo=ApproveEditFieldsInfo(objtbl,i);
				if (EditFieldsInfo=="-1") return;
				for(var j=i+1;j<Rows;j++)                                  //modified by GR2014-10-24 begin ȱ�ݺ�3221
				{
					var selobjj=document.getElementById('TOperatorz'+j);
					if (selobjj.checked)
					{
						if (GetElementValue("TRowIDz"+i)==GetElementValue("TRowIDz"+j))		//Modify DJ 2015-09-07 DJ0160
						{
							if (""==GetElementValue("TApproveNumz"+j))
							{
								alertShow("["+GetElementValue("TNamez"+j)+"] δ������������!")
								SetFocus("TApproveNumz"+j)
								return
							}
							else
							{
								var EditFieldsInfotemp=ApproveEditFieldsInfo(objtbl,j);
								if (EditFieldsInfotemp=="-1") return;
								EditFieldsInfo=EditFieldsInfo+"@"+EditFieldsInfotemp
							}
						}
						else
						{
							i=j-1		//Modify DJ 2015-09-07 DJ0160
							break
						}
					}
				}      											//modified by GR2014-10-24 end ȱ�ݺ�3221
				var rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo);
			}
			else //ȡ���ύ
			{
				var rtn=cspRunServerMethod(encmeth1,combindata,CurRole);
			}
			var list=rtn.split("^");
			if (list[0]=="-1")
			{
				if (ErrorStr=="")
				{
					ErrorStr=list[1]
				}
				else
				{
					ErrorStr=ErrorStr+","+list[1]
				}
			}
		}
	}
	if (ErrorStr!="")
	{
		alertShow(ErrorStr+"���ϵ��ݲ���ʧ��!")
	}
	BFind_Click();
}

function GetRequestLoc(value)
{
	GetLookUpID("RequestLocDR",value);
}


document.body.onload = BodyLoadHandler;
