var Component="DHCEQAReturn";
//���һ������Ԫ�ص����ֵĺ�׺���
var LastNameIndex;
//����һ������Ԫ�ص����ֵĺ�׺���
var NewNameIndex;
var ObjSources=new Array();
var selectrow=0;

function BodyLoadHandler()
{
	var ComponentID=GetElementValue("GetComponentID");	
	//�˻����ؼ�������
	//�������ع�Ӧ��
	var ReturnTypeDR=GetElementValue("ReturnTypeDR")
	if (ReturnTypeDR == 1)
	{
		EQCommon_HiddenElement("ReduceType");
		EQCommon_HiddenElement("cReduceType");
	}
	else 
	{
		var ProviderFD='ld'+ComponentID+'iProvider';
		EQCommon_HiddenElement("Provider");
		EQCommon_HiddenElement("cProvider");
		EQCommon_HiddenElement(ProviderFD);
	}
	InitUserInfo();
	InitPage();
	FillData();
	SetEnabled();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	SetDisplay();
	SetTableItem();
	InitApproveButton(); //�����Button�Ĵ���
	SetElement("Job",GetElementValue("TJobz1"));
	SetElement("ReturnTypeDR",GetElementValue("ReturnTypeDR"));
	document.body.onunload = BodyUnloadHandler;
	KeyUp("Provider^AccessoryType^ReduceLoc");
	Muilt_LookUp("Provider^AccessoryType^ReduceLoc");
}

function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	
	//var obj=document.getElementById("BPrintBar");
	//if (obj) obj.onclick=BPrintBar_Clicked;

	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Clicked;
	
	//var obj=document.getElementById("BOutPrint");
	//if (obj) obj.onclick=BOutPrint_Clicked;
	
	if (opener)
	{
		var obj=document.getElementById("BClose");
		if (obj) obj.onclick=CloseWindow;
	}
	else
	{
		EQCommon_HiddenElement("BClose")
	}
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
	/*		//Modify DJ 2014-09-12
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	// 0:�Ŵ�ѡ��ģʽ 1:�ֹ�¼��ģʽ,���Զ����»��ͱ� 2:���־���
	if (GetProviderOperMethod==1) 
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iProvider").removeNode(true)
	}
	*/
}

function FillData()
{
	var RowID=GetElementValue("RowID")
	if ((RowID=="")||(RowID<1)){	return;	}
	var obj=document.getElementById("fillData");
	if(obj) {var encmeth=obj.value}
	else{var encmeth=""}
	var ReturnList=cspRunServerMethod(encmeth,RowID)
	ReturnList=ReturnList.replace(/\\n/g,"\n")
	var list=ReturnList.split("^")
	var sort=28
	//alertShow(list[sort+15])
	SetElement("ReduceNo",list[0])
	SetElement("AccessoryTypeDR",list[1])
	SetElement("AccessoryType",list[sort])
	SetElement("ReduceType",list[2])
	SetElement("ReturnLocDR",list[3])
	SetElement("ReduceLoc",list[sort+2])
	SetElement("ProviderDR",list[5])
	SetElement("Provider",list[sort+3])
	SetElement("Remark",list[21])
	SetElement("Status",list[22])
	SetElement("MakeDate",list[sort+7]);
	SetElement("ApproveSetDR",list[sort+9]);
	SetElement("NextRoleDR",list[sort+10]);
	SetElement("NextFlowStep",list[sort+11]);
	SetElement("ApproveStatu",list[sort+12]);
	SetElement("ApproveRoleDR",list[sort+13]);
	SetElement("CancelFlag",list[sort+14]);
	SetElement("CancelToFlowDR",list[sort+15]);
}

function BCancelSubmit_Clicked() 
{
	var combindata=GetValueList();
  	var encmeth=GetElementValue("CancelSubmitData")
  	if (encmeth=="") return;
  	var Rtn=cspRunServerMethod(encmeth,combindata,GetElementValue("CurRole"));
	if (Rtn>0)
    {
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+Component;
		lnk=lnk+"&RowID="+Rtn
		lnk=lnk+"&ReturnTypeDR="+GetElementValue("ReturnTypeDR")
		window.location.href=lnk;
	}
    else
    {
	    alertShow(Rtn+"   "+t["01"]);
    }
}

function BSubmit_Clicked()
{
	if (CheckNull()) return;
	if(confirm("�ύ���ܸ���\nȷ���ύ��?")==true)
	{
		var combindata=GetValueList();
		var valList=GetTableInfo();
		if (valList=="")
		{
			alertShow(t["-1003"])
			return;
		}
		
		var encmeth=GetElementValue("SubmitData")
		if (encmeth=="") return;
		var Rtn=cspRunServerMethod(encmeth,combindata);
		if (Rtn>0)
		{
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+Component;
			lnk=lnk+"&RowID="+Rtn
			lnk=lnk+"&QXType="+GetElementValue("QXType")
			lnk=lnk+"&WaitAD="+GetElementValue("WaitAD")
			lnk=lnk+"&ReturnTypeDR="+GetElementValue("ReturnTypeDR")
			window.location.href=lnk;
		}
		else
		{
			if (isNaN(Rtn))
			{
				alertShow(Rtn+"   "+t["01"]);
			}
			else
			{
				alertShow(t[Rtn]+"   "+t["01"]);
			}
		}
	}
}

function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var combindata=GetValueList();
  	var encmeth=GetElementValue("DeleteData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata);
	if (Rtn==0)
    {
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+Component;
		lnk=lnk+"&WaitAD=off&QXType="+GetElementValue("QXType")
		lnk=lnk+"&ReturnTypeDR="+GetElementValue("ReturnTypeDR")
		window.location.href=lnk;
	}
    else
    {
	    alertShow(Rtn+"   "+t["01"]);
    }
}
//add by wl 2019-11-20 WL0013
function BPrint_Clicked()
{ 
	var id=GetElementValue("RowID");
	var PrintFlag = GetElementValue("PrintFlag");	 //��ӡ��ʽ��־λ excel��0  ��Ǭ:1   
	var PreviewRptFlag = GetElementValue("PreviewRptFlag"); //��ǬԤ����־ ��Ԥ�� :0  Ԥ�� :1
	var fileName="";
	var CurGroupID = session['LOGON.GROUPID']
	var HOSPDESC = GetElementValue("GetHospitalDesc");
	//Excel��ӡ��ʽ
	if(PrintFlag==0)  
	{
		PrintExcel();
	}
	//��Ǭ��ӡ
	if(PrintFlag==1)
	{
		if(PreviewRptFlag==0)
		{ 
		    fileName="{DHCEQAReduce.raq(RowID="+id
		    +";CurGroupID="+CurGroupID
		    +";HOSPDESC="+HOSPDESC
		    +")}"
		    
	        DHCCPM_RQDirectPrint(fileName);		
		}
		if(PreviewRptFlag==1)
		{ 
			fileName="DHCEQAReduce.raq&RowID="+id
			+"&CurGroupID="+CurGroupID
		    +"&HOSPDESC="+HOSPDESC
			DHCCPM_RQPrint(fileName);
		}
}
}
//modify by wl 2019-11-20 WL0013
function PrintExcel()
{
	var id=GetElementValue("RowID");
	var ReturnTypeDR=GetElementValue("ReturnTypeDR")
	var encmeth=GetElementValue("GetData");
	var result=cspRunServerMethod(encmeth,id);
	var list=result.split("^");
	var No=list[0]; //����
	var Type=list[1];//����
	var Loc=list[2];//�˻�����
	var Prov=list[3];//��Ӧ��
	var Maker=list[4];//�Ƶ���
	var MDate=list[5];//�Ƶ�ʱ��
	var ReduceType=list[6]; //��������
	var encmeth=GetElementValue("GetList");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,id);
	if (gbldata=="") return;
	var RLList=gbldata.split("^");
	var rows=RLList.length;
	var PageRows=4; //ÿҳ�̶�����
	var Pages=parseInt(rows / PageRows); //��ҳ��-1   
	var ModRows=rows%PageRows; //���һҳ����
	if (ModRows==0) Pages=Pages-1;
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	//var Template=TemplatePath+"DHCEQAReduceSP.xls";
	var encmeth=GetElementValue("GetOneList");
	try
	{
		var xlApp,xlsheet,xlBook;
		if (ReturnTypeDR == 1)
		{
			var Template=TemplatePath+"DHCEQAReduceSP.xls";
		}
		else
		{
			var Template=TemplatePath+"DHCEQAReduceSP1.xls";
		}
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet;
		xlsheet.PageSetup.TopMargin=0;
		xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"));
		//xlsheet.cells.replace("Maker",Maker);
		for(var i=0;i<rows;i++)
		{
			xlsheet.cells(2,3)=MDate;
			xlsheet.cells(2,6)=Type;
			if (ReturnTypeDR == 1)
			{
				xlsheet.cells(2,1)="�˻�����:"+No;;
				xlsheet.cells(3,1)="�˻��ⷿ:"+GetShortName(list[2],"-");
				xlsheet.cells(3,6)=GetShortName(list[3],"-");
			}
			else
			{
				xlsheet.cells(2,1)="���ٵ���:"+No;
				xlsheet.cells(3,1)="���ٿⷿ:"+GetShortName(list[2],"-");
				xlsheet.cells(3,2)="��������:"
				xlsheet.cells(3,3)=ReduceType;
				xlsheet.cells(3,5)="";
			}
			var SumQty="";
			var SumFee="";
			
			var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	for(var j=1;j<=OnePageRow;j++)
			{
				var RLID=RLList[i];
				var ReduceList=cspRunServerMethod(encmeth,RLID);
				var ListData=ReduceList.split("^");
				var Row=4+j;
				xlsheet.cells(Row,1)=ListData[0]; //����
				xlsheet.cells(Row,2)=ListData[1]; //�ͺ�
				xlsheet.cells(Row,3)=ListData[2]; //��λ
				xlsheet.cells(Row,4)=ListData[3]; //����
				xlsheet.cells(Row,5)=ListData[4]; //����
				xlsheet.cells(Row,6)=ListData[5]; //���
				xlsheet.cells(Row,7)=ListData[6]; //��ע
				SumQty=SumQty+ListData[3];
				SumFee=SumFee+ListData[5];
			}
			xlsheet.cells(Row+1,1)="�ϼ�:";
			xlsheet.cells(Row+1,4)=SumQty;
			xlsheet.cells(Row+1,6)=SumFee;
			
			xlsheet.cells(9,6)="�Ƶ���:"+curUserName; //�Ƶ���		Mozy	2019-6-6	923457
			xlsheet.cells(10,7)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ";
		}
		var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		var size=obj.GetPaperInfo("DHCEQInStock");
		if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    
		xlsheet.printout; 
		xlBook.Close (savechanges=false);
	    xlsheet.Quit;
	    xlsheet=null;
	    xlApp=null;
	}
	catch(e)
	{
		alertShow(e.message);
	}
}

function BClear_Clicked()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+Component;
	lnk=lnk+"&Status=0&QXType=2&WaitAD=off"
	lnk=lnk+"&ReturnTypeDR="+GetElementValue("ReturnTypeDR")
	window.location.href=lnk;
}

function BUpdate_Clicked()
{
	//var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	//if (GetProviderOperMethod=="") SetElement("GetProviderOperMethod","0");
	if (CheckNull()) return;
	var combindata=GetValueList();
	var valList=""
  	var valList=GetTableInfo();
   	if (valList=="-1")  return;
	var DelRowid=tableList.toString();
  	var encmeth=GetElementValue("UpdateData");
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,valList,DelRowid)
	var list=Rtn.split("^");
	if ((list[1]!="")&&(list.length>1))
	{
		alertShow("��"+list[0]+"��"+list[1])
	}
	else
	{
		if (list[0]>0)
		{
			ShowMessage("����ɹ�!");
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+Component;
			lnk=lnk+"&WaitAD=off&RowID="+Rtn
			lnk=lnk+"&ReturnTypeDR="+GetElementValue("ReturnTypeDR")
			window.location.href=lnk;
		}
		else
		{
			if (list[0]=="-1015")
			{
				alertShow(t[list[0]])
			}
			else
			{
				alertShow(t["01"])
			}
		}
	}
}

function GetValueList()
{
	var combindata="";
	combindata=GetElementValue("RowID");  //1 ID
	combindata=combindata+"^"+GetElementValue("AccessoryTypeDR");  //2  �������
	combindata=combindata+"^"+GetElementValue("ReduceLocDR");  //3  �˻�����
	combindata=combindata+"^"+GetElementValue("ProviderDR");   //4  ��Ӧ��
	combindata=combindata+"^"+GetElementValue("MakeDate");  //5  �Ƶ�ʱ��
	combindata=combindata+"^"+GetElementValue("Remark");  //6  ��ע
	combindata=combindata+"^"+GetElementValue("TAccessoryDR");  //7  ���
	combindata=combindata+"^"+curUserID;  //8  ȷ����
	combindata=combindata+"^"+GetElementValue("Job");   //9
	combindata=combindata+"^"+GetElementValue("CancelToFlowDR");//10
	combindata=combindata+"^"+GetElementValue("ReturnTypeDR"); //11  ReduceType
	return combindata;
}

function GetTableInfo()
{
  	var objtbl=document.getElementById('t'+Component);
	var rows=tableList.length
	var valList="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRow=GetCElementValue("TRowz"+i);
			var TRowID=GetElementValue('TRowIDz'+i);
			var TStockDetailDR=GetElementValue('TStockDetailDRz'+i);
			var TAccessory=GetElementValue('TAccessoryz'+i);
			var TSerialFlag=GetElementValue('TSerialFlagz'+i); //�������к���ʾ��־
			if (TAccessory=="")
			{
				//continue;
				//�������:	418216		Mozy	20170731	����ϸ��¼���ܽ��и���
				alertShow("��"+TRow+"��,ѡ���������Ϊ��")
				SetFocusColumn("TAccessory",i)
				return "-1"
			}
			var TAccessoryDR=GetElementValue('TAccessoryDRz'+i);				
			if ((TAccessoryDR=="")&&(TStockDetailDR==""))
			{
				alertShow("��"+TRow+"����ϸΪ��,����!")
				return "-1"
			}
			var TReturnQtyNum=GetElementValue('TReturnQtyNumz'+i);
			if ((TReturnQtyNum=="")||(parseInt(TReturnQtyNum)<=0))
			{
				alertShow("��"+TRow+"����������ȷ!");
				SetFocusColumn("TReturnQtyNum",i)
				return "-1";
			}
			// ��������ΪС��
			if (parseInt(TReturnQtyNum)!=TReturnQtyNum)
			{
				alertShow("��"+TRow+"����������ȷ,����ΪС��!");
				SetFocusColumn("TReturnQtyNum",i)
				return "-1";
			}
			var TReturnFee=GetCElementValue('TReturnFeez'+i);
			var TReturnReasonDR=GetElementValue('TReturnReasonDRz'+i);
			///var TBaseUOMDR=GetCElementValue('TBaseUOMDRz'+i);  ///��λ
			var TManuFactoryDR=GetElementValue('TManuFactoryDRz'+i); ///��������
			var TManuFactory=GetCElementValue('TManuFactoryz'+i)
			var TRemark=GetElementValue('TRemarkz'+i);
			var THold1=GetElementValue("THold1z"+i);
			var THold2=GetElementValue("TAInStockListDRz"+i);
			var THold3=GetElementValue("THold3z"+i);
			var THold4=GetElementValue("THold4z"+i);
			var THold5=GetElementValue("THold5z"+i);
			if(valList!="") {valList=valList+"&";}
			//               1      2            3                   4                 5               6                 7               8          9
			valList=valList+i+"^"+TRowID+"^"+TStockDetailDR+"^"+TAccessoryDR+"^"+TReturnQtyNum+"^"+TReturnFee+"^"+TReturnReasonDR+"^"+TRemark;
			valList=valList+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5+"^"+TManuFactory+"^"+TManuFactoryDR+"^"+TSerialFlag;  ////QW0006-2014-08-21
		}
	}
	return  valList
}

function SetEnabled()
{
	var Status=GetElementValue("Status");
	var WaitAD=GetElementValue("WaitAD");
	//״̬Ϊ����ʱ,�����ύ��ɾ��
	//״̬С��1ʱ,������ɾ��
	if (Status!="0")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		if (Status!="")
		{
			DisableBElement("BUpdate",true);
			DisableBElement("BAdd",true);
			DisableBElement("BClear",true);
		}
	}
	//��˺�ſɴ�ӡ������ת�Ƶ�
	if (Status!="2")
	{
		DisableBElement("BPrint",true);
	}
	//�ǽ����ݲ˵�,���ɸ��µȲ�������
	if (WaitAD!="off")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAdd",true);
		DisableBElement("BClear",true);
	}	
}

function BApprove_Clicked() //��˰�ť�¼�
{
	var combindata=GetValueList();
	var CurRole=GetElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep")
  	if (RoleStep=="") return;
  	var objtbl=document.getElementById('t'+Component);
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
  	if (EditFieldsInfo=="-1") return;
  	var encmeth=GetElementValue("AuditData")
  	if (encmeth=="") return; 
	var Rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo);
    if (Rtn>0)
    {
	    window.location.reload();
	}
    else
    {
	    if (isNaN(Rtn))
	    {
		    alertShow(Rtn+"   "+t["01"]);
	    }
	    else
	    {
		    alertShow(t[Rtn]+"   "+t["01"]);
	    }
    }
}

function SetDisplay()  //�˻����Ų��ɱ༭
{
	ReadOnlyCustomItem(GetParentTable("ReturnNo"),GetElementValue("Status"));
	ReadOnlyElement("ReturnNo",true)
}

function SetTableItem()
{
	var objtbl=document.getElementById('t'+Component);
	var rows=objtbl.rows.length-1;
	for(var i=1;i<=rows;i++)
	{
		if(tableList[i]!="0") tableList[i]=0;
		var TRowID=GetElementValue("TRowIDz"+i);
		var TotalFlag=GetElementValue("TotalFlag")
		if (TRowID==-1)
		{
			if ((TotalFlag==1)||(TotalFlag==2))
			{
				obj=document.getElementById("TRowz"+i);
				if (obj) obj.innerText="�ϼ�:"
				obj=document.getElementById("BDeleteListz"+i);
				if (obj) obj.innerText=""
				obj=document.getElementById("TBSerialNoz"+i);
				if (obj) obj.innerText=""	
				
				obj=document.getElementById("TAccessoryListz"+i);
				if (obj)
				{
					obj.innerText=""
					DisableBElement("TAccessoryListz"+i,true);
				}
				tableList[i]=-1;
				continue;
			}
		}
		ChangeRowStyle(objtbl.rows[i]);   //�ı�һ����ʾ����
	}
}

function ChangeRowStyle(RowObj)
{
   var objtbl=document.getElementById('t'+Component);
   var Status=GetElementValue("Status");
   for (var j=0;j<RowObj.cells.length;j++)
   {
     var html="";
     var value="";
     if (!RowObj.cells[j].firstChild) {continue}
     var Id=RowObj.cells[j].firstChild.id;
     var offset=Id.lastIndexOf("z");
     var objindex=Id.substring(offset+1);
     var colName=Id.substring(0,offset);
     //alertShow(colName)
     var objwidth=RowObj.cells[j].style.width;
     var objheight=RowObj.cells[j].style.height;
     
     if(colName=="TAccessory")
     {
	    
      if (CheckUnEditField(Status,colName)) continue;
       
       value=GetCElementValue(Id);
       html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpAccessory","","","KeyUpAccessory")
       
     }
   	else if (colName=="TFlag")//QW0006-2014-08-21������ʾ��־
	{
		value=GetCElementValue(Id)
		html=CreatElementHtml(5,Id,objwidth,objheight,"","","","")
	}
	else if (colName=="TSerialFlag")
	{
		value=GetCElementValue(Id);
		html=CreatElementHtml(5,Id,objwidth,objheight,"ClickCheckBox","","","")	// 5 ClickCheckBox
		//RowObj.cells[j].firstChild.disabled=true;	
	}
     else if(colName=="TRemark")
     {
	     
        if (CheckUnEditField(Status,colName)) continue;
        value=GetCElementValue(Id);
        html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","");
     }
     else if (colName=="TReturnQtyNum")
	{
		if (CheckUnEditField(Status,colName)) continue;
		value=GetCElementValue(Id);
        html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","TotalFee_Change")
		//����
		var objTQuantityNum=GetElementValue(Id);;
		if(objTQuantityNum)
		{
			objTQuantityNum.onkeypress=NumberPressHandler
		}
	}
	else if (colName=="TReturnReason")
	{	
		if (CheckUnEditField(Status,colName)) continue;
		value=GetCElementValue(Id);
		html=CreatElementHtml(2,Id,objwidth,objheight,"ReturnReason","","","") ///ɾ�����һ���������ú���Standard_TableKeyUp 2014-4-16 BY:GBX GBX0005
	}
	else if (colName=="BDeleteList")
	{
		if (Status>0)
		{
			HiddenObj(colName+"z"+objindex,1)
			continue;
		}
		RowObj.cells[j].onclick=DeleteClickHandler;
	}
	else if (colName=="TBSerialNo")
	{
		RowObj.cells[j].onclick=BSerialNoClick;
	}
	if (html!="") RowObj.cells[j].innerHTML=html;
	if (value!="")
	{
		if (RowObj.cells[j].firstChild.tagName=="LABEL")
	    {
		    value=trim(value);
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
			    if (colName=="TSerialFlag")
				{
				    RowObj.cells[j].firstChild.disabled=true;
				}
			}
		    else
		    {
			    value=trim(value);
		    	RowObj.cells[j].firstChild.value=value;
		    }
		   }
		}
    }
}

function CheckNull()
{
	var ReturnTypeDR=GetElementValue("ReturnTypeDR")
	var Exceptions="Provider";
	if (ReturnTypeDR=="1") Exceptions="";
	if (CheckMustItemNull(Exceptions)) return true;

	/*
	{
		var Provider=GetElementValue("Provider")
		if (Provider=="")
		{
			alertShow("����ѡ���˻��Ĺ�Ӧ��!")
			return true
		}
	}
	
	if (CheckMustItemNull()) return true;
			//Modify DJ 2014-09-12
	var obj=document.getElementById("cProvider");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (GetElementValue("GetProviderOperMethod")==0)
		{
			if (CheckItemNull(1,"Provider")==true) return true;
		}
		else
		{
			if (CheckItemNull("","Provider")==true) return true;
		}
				
	}
	*/
	return false;
}
//QW0006-2014-08-21 ���кŰ�ť��Ӧ
function BSerialNoClick()
{
	selectrow=GetTableCurRow();
	var SerialFlag="Y"
	if (true!=GetElementValue("TSerialFlagz"+selectrow))
	{
		alertShow("���ǰ����кŹ���,����ѡ�����к�.");
		return;
	}
	var AListDR=GetElementValue("TRowIDz"+selectrow)
	//if (AListDR=="") return;
	var QuantityNum=GetElementValue("TReturnQtyNumz"+selectrow)
	if (QuantityNum=="") return;
	var StockDetailDR=GetElementValue("TStockDetailDRz"+selectrow)
	if (StockDetailDR=="") return;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUpdateAccessoryByList";
	lnk=lnk+"&SourceID="+StockDetailDR;
	lnk=lnk+"&QuantityNum="+QuantityNum;
	lnk=lnk+"&Job="+GetElementValue("Job");
	lnk=lnk+"&index="+selectrow;
	lnk=lnk+"&MXRowID="+AListDR;
	lnk=lnk+"&StoreLocDR="+GetElementValue("ReduceLocDR");
	lnk=lnk+"&Status="+GetElementValue("Status");
	lnk=lnk+"&Type=0";
	lnk=lnk+"&SerialFlag="+SerialFlag;
   	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
function TotalFee_Change()
{
	selectrow=GetTableCurRow();
	var TReturnFee=GetElementValue("TReturnFeez"+selectrow)
	var TReturnQtyNum=parseInt(GetElementValue("TReturnQtyNumz"+selectrow))
	var TReturnNum=parseInt(GetElementValue("TReturnNumz"+selectrow))
	if((TReturnQtyNum>TReturnNum)||(TReturnQtyNum<1)||(isNaN(TReturnQtyNum)))
	{
		var TSerialFlag=GetElementValue("TSerialFlagz"+selectrow);
		if (!TSerialFlag)
		{
			alertShow("�޸����������˿���������Χ!");
			SetElement('TReturnQtyNumz'+selectrow,'');
			TReturnQtyNum="";
		}
		else
		{
			alertShow("�޸����������˿���������Χ!");
			SetElement('TReturnQtyNumz'+selectrow,1);
			TReturnQtyNum=1;
		}
		/*
		alertShow("������Ч!")
		SetElement('TReturnQtyNumz'+selectrow,'');
		return
		*/
	}
	var TotalFee=TReturnQtyNum*TReturnFee
	if (TotalFee<=0)
	{
		SetElement('TTotalFeez'+selectrow,'');
	}
	else
	{
		SetElement('TTotalFeez'+selectrow,TotalFee.toFixed(2));
	}
	SumList_Change()
}

function ClearValue()
{
	selectrow=GetTableCurRow();
	SetElement('TAccessoryz'+selectrow,"");
	SetElement('TAccessoryDRz'+selectrow,"");
	SetElement('TStockDetailDRz'+selectrow,"");
	SetElement('TManuFactoryz'+selectrow,"");
	SetElement('TManuFactoryDRz'+selectrow,"");
	SetElement('TQuantityNumz'+selectrow,"");
	SetElement('TRemarkz'+selectrow,"");
	SetElement('TReturnNumz'+selectrow,"");
	SetElement('TReturnQtyNumz'+selectrow,"");
	SetElement('TReturnFeez'+selectrow,"");
	SetElement('TTotalFeez'+selectrow,"");
	SetElement('TReturnReasonz'+selectrow,"");
	SetElement('TReturnReasonDRz'+selectrow,"");
	if (GetElementValue("TotalFlag")!=0)
	{
		SumList_Change();
	}
}

function SumList_Change()
{
	var length=tableList.length
	var Num=0
	var Fee=0
	for (var i=1;i<=length;i++)
	{
		if (tableList[i]=="0")
		{
			// ���ת����ʧС��			
			var TReturnFee=parseFloat(GetElementValue("TReturnFeez"+i))
			var TReturnQtyNum=parseInt(GetElementValue("TReturnQtyNumz"+i))
			if ((isNaN(TReturnFee))||(isNaN(TReturnQtyNum))) continue;
			var TotalFee=TReturnFee*TReturnQtyNum
			SetElement('TTotalFeez'+i,TotalFee.toFixed(2));
			Num=Num+TReturnQtyNum
			Fee=Fee+TotalFee
		}
		else if (tableList[i]==-1)
		{
			var index=i
		}
	}
	SetElement('TReturnQtyNumz'+index,Num);
	SetElement('TTotalFeez'+index,Fee.toFixed(2));
}

function DeleteClickHandler() {
	var truthBeTold = window.confirm("ȷ��ɾ���ü�¼��?");
	if (!truthBeTold) return;
	try
	{
  		var objtbl=document.getElementById('t'+Component);
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		var TotalFlag=GetElementValue("TotalFlag")
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID;
		var delNo=GetElementValue("TRowz"+selectrow);
		if (((TotalFlag==0)&&(rows<=2))||((rows<=3)&&((TotalFlag==1)||(TotalFlag==2))))
		{
			tableList[selectrow]=0;
			if (TRowID!="")
			{
				SetElement('TRowIDz'+selectrow,"");				
				tableList[tableList.length]=TRowID;
			}
			ClearValue()
			//SetElement("Job","")
		} 
		else
		{
	    	var eSrc=window.event.srcElement;
			var rowObj=getRow(eSrc);
			objtbl.deleteRow(rowObj.rowIndex);
			
		}
		ResetNo(selectrow,delNo);
	    SumList_Change();
	} catch(e) {};
}

function ResetNo(delindex,delno)
{
	var len=tableList.length;
	var nextNo=delno;
	for (var i=delindex;i<len;i++) 
	{
		if (tableList[i]=="0")
		{			
			SetElement("TRowz"+i,nextNo);
			nextNo=parseInt(nextNo)+1;			
		}
	}	
}

function AddClickHandler() {
	try 
	{
  		var objtbl=document.getElementById('t'+Component);
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
	    	ObjSources[NewNameIndex]=new SourceInfo("","");
	    	// ����ʱ�������кŵ���¼�
			var TBSerialNo=document.getElementById("TBSerialNoz"+NewNameIndex);
			if (TBSerialNo)	 TBSerialNo.onclick=BSerialNoClick;
			
	    	var TAccessoryList=document.getElementById("TAccessoryListz"+NewNameIndex); //ѡ���豸
			if (TAccessoryList)	TAccessoryList.onclick=TAccessoryListClick;
	    }
        return false;
	} catch(e) {};
}
function CanAddRow(objtbl)
{
	var rows=objtbl.rows.length;
    if (rows==1) return false;
	var TotalFlag=GetElementValue("TotalFlag")
	if (TotalFlag==2) rows=rows-1
	LastNameIndex=GetRowIndex(objtbl.rows[rows-1]);
	if  (GetElementValue('TAccessoryz'+LastNameIndex)=="")
	{
		// Mozy	2016-1-18	�Զ����һ��ʱ��������
		//SetFocusColumn("TAccessory",LastNameIndex);
		//return false;
	}
	return true;
}

function LookUpAccessory(vClickEventFlag)
{
   if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		var changeType=GetElementValue("ChangeType");
		//LookUp("","web.DHCEQAReduce:GetInStockList","GetInStockList","AccessoryTypeDR,ReduceLocDR,ProviderDR,TAccessoryz"+selectrow+",TFlagz"+selectrow);
		LookUp("","web.DHCEQAReduce:GetAStockDetail","GetInStockList","TStockDetailDRz"+selectrow+",ReduceLocDR,AccessoryTypeDR,TAccessoryz"+selectrow+",TFlagz"+selectrow+",ChangeType,TRowIDz"+selectrow+",ProviderDR"); //QW0006-2014-08-21 ���һ������������ת�ƻ����˻�  //Modify DJ 2014-09-11
	}
}
//QW0006-2014-08-21 �������ת���ڵķ�����ȡ���ݵ�˳��
function GetInStockList(value)
{
	AddClickHandler();
	var list=value.split("^");
	//�˿������������ͬһ����ⵥ,��ֻ������һ������
	var Length=tableList.length
	var currow=GetCElementValue("TRowz"+selectrow);
	for (var i=1;i<Length;i++)
	{
		//Mozy0186	2010406	�˿������������ͬһ�������ϸ��ֻ������һ������
		if ((tableList[i]=="0")&&(list[0]==GetElementValue('TStockDetailDRz'+i)))
		{
			var TRow=GetCElementValue("TRowz"+i);
			if (TRow==currow)
			{
				continue;
			}
			alertShow("��ǰѡ��������ϸ�е�"+(TRow)+"���ظ�,��ֱ���޸�����")
			return;
		}
	}
	
	var objtbl=document.getElementById('t'+Component);
	var Length=objtbl.rows.length;
	//var Length=ObjSources.length
	SetElement('TAInStockListDRz'+selectrow,list[11]);
	SetElement('TAccessoryz'+selectrow,list[1]);
	SetElement('TManuFactoryz'+selectrow,list[20]);
	SetElement('TReturnQtyNumz'+selectrow,list[35]);
	SetElement('TReturnNumz'+selectrow,list[35]);
	SetElement('TReturnFeez'+selectrow,list[37]);
	SetElement('TTotalFeez'+selectrow,list[38]);
	SetElement('TAccessoryDRz'+selectrow,list[9]);
	SetElement('TStockDetailDRz'+selectrow,list[0]);
	SetElement('TManuFactoryDRz'+selectrow,list[19]);
	if (list[41]=="Y")	//���Ź����ʶ  Modify DJ 2014-09-11
	{
		SetElement("TSerialFlagz"+selectrow,0);
	}
	else
	{
		SetElement("TSerialFlagz"+selectrow,1);
	}
	/*
	var DetailDR=GetElementValue('TStockDetailDRz'+selectrow)
	for(var i=1;i<Length-2;i++)
	{
		var TDetailDR=GetElementValue('TStockDetailDRz'+i)
		if(GetElementValue('TStockDetailDRz'+i)==" ")
		{
			i++;
		}
		if((DetailDR==GetElementValue('TStockDetailDRz'+i))&&(Length!=3))
		{
			
			var ObjTRow=document.getElementById("TRowz"+i);
			if (ObjTRow)  var TRow=ObjTRow.innerText;
			alertShow("�ü�¼���"+(TRow)+"�м�¼�ظ�!");
			SetElement('TAccessoryz'+selectrow,'');
	        SetElement('TManuFactoryz'+selectrow,'');
	        SetElement('TReturnQtyNumz'+selectrow,'');
	        SetElement('TReturnNumz'+selectrow,'');
	        SetElement('TReturnFeez'+selectrow,'');
	        SetElement('TTotalFeez'+selectrow,'');
	        SetElement('TAccessoryDRz'+selectrow,'');
	        SetElement('TStockDetailDRz'+selectrow,'');
	        SetElement('TManuFactoryDRz'+selectrow,''); 
	        SetFocusColumn("TAccessory",i)
	        return;
		}
		else
		{}
	}
	*/
	SumList_Change()
	var obj=document.getElementById("TAccessoryz"+selectrow);
	if (obj) websys_nextfocusElement(obj); 
}

function ReturnReason(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		LookUpReturnReason("GetReturnReason","TReturnReasonz"+selectrow);
	}
}

function GetReturnReason(value)
{
	var list=value.split("^")
	SetElement('TReturnReasonz'+selectrow,list[0]);
	SetElement('TReturnReasonDRz'+selectrow,list[1]);
	var obj=document.getElementById("TReturnReasonz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function KeyUpAccessory()
{
	selectrow=GetTableCurRow();
	SetElement('TStockDetailDRz'+selectrow,"");
}
function GetAccessoryType(value)  //�������Ŵ�
{
	 GetLookUpID("AccessoryTypeDR",value);
}
function ProviderDR(value)       //��Ӧ�̷Ŵ�
{
	 GetLookUpID("ProviderDR",value);
}
function ReturnLocDR(value)
{
	GetLookUpID("ReduceLocDR",value);
}

function BodyUnloadHandler()
{
	var Job=GetElementValue("Job");
  	var encmeth=GetElementValue("KillTEMPEQ");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,Job);
}

document.body.onload = BodyLoadHandler;

