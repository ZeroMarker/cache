//------------------------------------------------------------
//modified by GR2014-10-24 ȱ�ݺ�3221
//�豸�ɹ�����-��Ȳɹ���������-��������������ϸ�Ĳɹ���������ʱ��ִ�гɹ�����ʾ"xx���뵥�����ϵ��ݲ���ʧ��!",����һ����ϸ�⣬������������Զ����
//�޸ģ�������ͬһ�������ϸ��¼ͬʱִ����˲���
//-------------------------------------------------------------------------
var SelectedRow = 0;
var rowid=0;
var Component="tDHCEQYearBuyRequest"
function BodyLoadHandler() 
{
	initButtonWidth();  //add by lmm 2018-09-05 hisui���죺�޸İ�ť����
	InitUserInfo();
	InitPage();
	KeyUp("RequestLoc")
	Muilt_LookUp("RequestLoc")
	//add 20191012 by zy �жϰ�ť�Ƿ����
	var Action=getElementValue("Action")
	if (Action=="BuyReq_Assign")
	{
		$("#BExecute").linkbutton({text:"�ɵ�"})
	}
	// add by zx 2019-09-16 
	if ((Action=="BuyReq_Research")||(Action=="BuyReq_Decision"))
	{
		hiddenObj("BExecute",true);
	}
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

///add by zy 2018-10-19
///hisui���죺���ӿɱ༭�б�
var editFlag="undefined";
var SelectedRow = -1;
var rowid=0;
$('#'+Component).datagrid({
	onSelect: function (rowIndex, rowData) {	//�����н����༭
		if (editFlag!="undefined") 
		{
	    	jQuery('#'+Component).datagrid('endEdit', editFlag);
	    	//EditRowColor();
	    	editFlag="undefined";
	    }
    },
})
//modified by zy ZY0223 2020-04-17
//�����������Ҫ����
/*
//add 20191012 by zy ��������ʽ�ı�
function SelectRowHandler(index,rowdata)	{	//˫���п�ʼ�༭
	//var Value=$('#'+Component).datagrid('getColumnOption','TApproveInfo');
	//Value.editor={type:'validatebox'};
	//var Value=$('#'+Component).datagrid('getColumnOption','TApproveNum');
	//Value.editor={type:'validatebox'};
	//var Value=$('#'+Component).datagrid('getColumnOption','TRejectReason');
	//Value.editor={type:'validatebox'};
	//modified by ZY0222 2020-04-16
	//var Value=$('#'+Component).datagrid('getColumnOption','TOperator');
	//Value.editor={type: 'checkbox',options:{on:'Y',off:'N'}}
	if (editFlag!="undefined")
	{
    	jQuery('#'+Component).datagrid('endEdit', editFlag);
    	editFlag="undefined"
	}
    jQuery('#'+Component).datagrid('beginEdit', index);
    editFlag =index;
}
*/
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
///modified by ZY0201  
function BFind_Click()
{
	/*
	var Flag=GetChkElementValue("ApproveFlag")
	if (Flag==false)
	{
		Flag=0
	}
	else
	{
		Flag=1
	}
	*/
	var Flag=getValueById("ApproveFlag")
	if (!$(this).linkbutton('options').disabled){
			$('#tDHCEQYearBuyRequest').datagrid('load',{
				ComponentID:getValueById("GetComponentID"),
				PrjName:getValueById("PrjName"),
				RequestNo:getValueById("RequestNo"),
				StartDate:$('#StartDate').datebox("getValue"),
				EndDate:$('#EndDate').datebox("getValue"),
				BRYear:getValueById("BRYear"),
				RequestLocDR:getValueById("RequestLocDR"),
				ApproveRole:getValueById("ApproveRole"),
				ApproveFlag:Flag,
				Action:getValueById("Action"),
				ManageLocDR:getValueById("ManageLocDR")
				});
		}
}
//add by wl 2020-06-03 WL0066   ����Ԫ�ػ�ȡ 
function GetVData()
{
	var val="^GetComponentID="+GetElementValue("GetComponentID");
	val=val+"^PrjName="+GetElementValue("PrjName");
	val=val+"^RequestNo="+GetElementValue("RequestNo");
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^BRYear="+GetElementValue("BRYear");
	val=val+"^RequestLocDR="+GetElementValue("RequestLocDR");
	val=val+"^ApproveRole="+GetElementValue("ApproveRole");	
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	//messageShow("","","",GetElementValue("StartDate"))
	val=val+"^ApproveFlag="+GetElementValue("ApproveFlag");
	val=val+"^Action="+GetElementValue("Action");
	val=val+"^ManageLocDR="+GetElementValue("ManageLocDR");
	return val;
}

function BExport_Click()
{
	//add by wl 2020-06-03 WL0066  ������������,ԭ�еĵ�������
	var ObjTJob=$('#tDHCEQYearBuyRequest').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"])  TJob=ObjTJob.rows[0]["TJob"];
	if (TJob=="")  return;
	PrintDHCEQEquipNew("YearBuyRequest",1,TJob,GetVData())
	return;
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	//var TJob=getColumnValue(0,"TJob","tDHCEQYearBuyRequest")
	var TJob=""
	var Rows = $('#'+Component).datagrid('getRows');
	var RowCount=Rows.length
	if(RowCount<=0){
		jQuery.messager.alert("û�д���������");
		return;
	}
	else
	{
		TJob=Rows[0].TJob
	}
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
		messageShow("","","",e.message);
	}
}

function BSelectAll_Click()
{
	var obj=document.getElementById("BSelectAll")
	if (obj.innerText=="ȫѡ(��ǰҳ)")
	{
		obj.innerText="��ѡ(��ǰҳ)"
		var flag="Y"
	}
	else
	{
		obj.innerText="ȫѡ(��ǰҳ)"
		var flag="N"
	}
	var Rows = $('#'+Component).datagrid('getRows');
	var RowCount=Rows.length
	for (var i=0;i<RowCount;i++)
	{
		Rows[i].TOperator=flag
	}
}
function BExecute_Click()
{
	//add 20191012 by zy ������˷�ʽ�ı�
	batchApprove()
	return
	var ErrorStr=""
	var Rows = $('#'+Component).datagrid('getRows');
	var RowCount=Rows.length
	if(RowCount<=0){
		jQuery.messager.alert("û�д���������");
		return;
	}
	var Count=0
	for (var i=0;i<RowCount;i++)
	{
		$('#'+Component).datagrid('endEdit',i);	//modified by czf 20190116
		var TOperator=Rows[i].TOperator
		if (TOperator=="Y")
		{
			Count=Count+1
			//δ��������
			var ApproveNum=Rows[i].TApproveNum
			var RejectReason=Rows[i].TRejectReason
			var ApproveInfo=Rows[i].TApproveInfo
			var RequestNum=Rows[i].TRequestNum
			if (ApproveNum=="")
			{
				alertShow("["+Rows[i].TName+"] δ������������!")
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
				alertShow("["+Rows[i].TName+"] ������ܾ�ԭ��!")
				SetFocus("TRejectReasonz"+i)
				return
			}
			//������Ϊ0,δ�������������
			if ((ApproveNum!=0)&&(ApproveInfo==""))
			{
				alertShow("["+Rows[i].TName+"] �������������!")
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
	for (var i=0;i<=RowCount-1;i++)		//Modify DJ 2015-09-07 DJ0160
	{
		///modified by zy ZY0176 hisui����
		InitEditFields(Rows[i].TApproveSet,CurRole)
		var TOperator=Rows[i].TOperator
		if (TOperator=="Y")
		{
			ApproveNum=Rows[i].TApproveNum
			var RoleStep=Rows[i].TRoleStep
			var combindata=Rows[i].TRowID;
			combindata=combindata+"^"+curUserID;
			combindata=combindata+"^"+Rows[i].TCancelToFlow;
			combindata=combindata+"^"+Rows[i].TApproveInfo;
			combindata=combindata+"^";
			combindata=combindata+"^"+Rows[i].TRejectReason;
			//���
			if (ApproveNum!=0)
			{
				///modified by zy ZY0176 hisui����
			  	//var objtbl=document.getElementById('tDHCEQYearBuyRequest');
			  	var objtbl=$('#tDHCEQYearBuyRequest')
				var EditFieldsInfo=ApproveEditFieldsInfo(objtbl,i);
				if (EditFieldsInfo=="-1") return;
				/*
				for(var j=i+1;j<RowCount;j++)                                  //modified by GR2014-10-24 begin ȱ�ݺ�3221
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
				}  */    											//modified by GR2014-10-24 end ȱ�ݺ�3221
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
		messageShow("","","",ErrorStr+"���ϵ��ݲ���ʧ��!")
	}
	///modified by zy ZY0176 hisui����
	window.location.reload();
}

function GetRequestLoc(value)
{
	GetLookUpID("RequestLocDR",value);
}
//add 20191012 by zy �������
function batchApprove()
{
	var Rows = $('#'+Component).datagrid('getRows');
	//modified by zy 20191025 ZY0194
	///add by zy 2019-10-21 �����֮�����ʧ
	if (typeof(Rows) === 'undefined')
	{
		messageShow("","","","��ˢ�½����ѡҪ����������!")
		return;
	}
	var RowCount=Rows.length;
	if(RowCount<=0){
		messageShow("","","","û�д���������!")
		return;
	}
	var Count=0
	var RowIDs=""
	var BuyReqNos=""
	for (var i=0;i<RowCount;i++)
	{
		$('#'+Component).datagrid('endEdit',i);	//modified by czf 20190116
		var TOperator=Rows[i].TOperator;
		if (TOperator=="1"||TOperator=="Y") //modified by csj 20191023
		{
			Count=Count+1
			if (RowIDs=="")
			{
				RowIDs=Rows[i].TRowID;
			}
			else
			{
				RowIDs=RowIDs+","+Rows[i].TRowID;
			}
		}
		$('#'+Component).datagrid('beginEdit',i); //add by zx 2019-09-16
	}
	if(Count==0){
		messageShow("","","","�빴ѡ��Ҫ���������!")
		return;
	}
	var Action=getElementValue("Action");
	var CurRole=getElementValue("ApproveRole");
	url="dhceq.em.buyrequestassign.csp?&Action="+Action+"&RowIDs="+RowIDs+"&CurRole="+CurRole;
	//alertShow(url)
	showWindow(url,"�������","","","icon-w-paper","modal","","","small",reloadGrid);
}

//add by zx 2019-06-01 �����޸ĺ�ˢ���б�����
function reloadGrid()
{
	$('#'+Component).datagrid('reload');
}

document.body.onload = BodyLoadHandler;
