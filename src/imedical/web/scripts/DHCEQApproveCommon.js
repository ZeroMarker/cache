///��¼�ɱ༭�ֶ���Ϣ
///��¼ �ֶ���
///��¼ �ֶ�ID
///��¼ �ֶ����ڱ���
var	ObjEditFields=new Array();

///��¼ �е���ż���ɾ�Ĳ���
///�ϼ��м�¼?-1
///���޸������ֵΪ0
///ɾ����¼��ϸRowID
var tableList=new Array();

///�����༭�ֶ���Ϣ����
function EditFieldInfo(RowID,FieldName,TableName,MustFlag,ListFlag,FieldType,RowIDName)
{
	this.RowID=RowID;
	this.FieldName=FieldName;
	this.TableName=TableName;
	this.MustFlag=MustFlag;
	this.ListFlag=ListFlag;
	this.FieldType=FieldType;	
	if (!RowIDName) RowIDName="";	//ZY0057 2011-2-15
	this.RowIDName=RowIDName;		// Mozy0040 2011-2-10
	//������
	if (FieldType==3)
	{
		FieldName=GetEditElementName(FieldName);
	}
	this.EditFieldName=FieldName;
	if (ListFlag=="Y")
	{
		this.FieldCaption=GetColCaption(FieldName);
	}
	else
	{
		this.FieldCaption=GetCElementValue("c"+FieldName);
		var obj=document.getElementById("c"+FieldName);
		if (obj&&(MustFlag=="Y")) obj.className="clsRequired";
	}
}

///��Ҫ��ҵ�������?��������Ԫ��GetReqFields?s val=##Class(%CSP.Page).Encrypt($lb("web.DHCEQApprove.GetRequiredFields"))
///��ʼ���ɱ༭�ֶ���Ϣ
function InitEditFields(ApproveSetDR,CurRole,ActionCode)
{
	if (ActionCode==null) ActionCode=""		//Add By DJ 2016-05-11
	var encmeth=GetElementValue("GetReqFields");
	var value=cspRunServerMethod(encmeth,ApproveSetDR,CurRole,ActionCode);	//Add By DJ 2016-05-11
	if (value=="") return;
	var List=value.split("^");
	var Len=List.length;
	for (var i=0;i<Len;i++)
	{
		var infor=List[i];
		var infor=infor.split(",");
		ObjEditFields[i]=new EditFieldInfo(infor[0],infor[1],infor[2],infor[3],infor[4],infor[5],infor[6]);
	}
}

///�����ֶ��Ƿ񲻿ɱ༭
///status?����״̬
///field?����Ԫ����?�б�Ԫ�����ִ���ʱ����z���к�
function CheckUnEditField(status,field)
{	
	var count=ObjEditFields.length;
	var fieldDR=field+"DR";
	if (status<1) return false;
	for (var i=0;i<count;i++)
	{
		//if (field=="InDate") alertShow(ObjEditFields[i].FieldName+count+"&"+i);
		if (field==ObjEditFields[i].FieldName) return false;
		if ((ObjEditFields[i].FieldType=="3")&&(fieldDR==ObjEditFields[i].FieldName)) return false;
	}
	return true;	
}

///���Ӳ���currow:���б���,�����ѡ����,ֻ����ǰѡ����һ��  DJ0104
///��ȡ�༭�ֶμ�ֵ��Ϣ
///��֮�����Ϣ��"@"�ָ�
///��¼֮�����Ϣ��"&"�ָ�
///Ԫ��֮�����Ϣ��"^"�ָ�
///����ֵΪ: ����Ϣ1@����Ϣ2...@����Ϣn
///			 ����Ϣ�м�¼��ʽΪ?����&��¼1&��¼2...&��¼n
///			 ��¼��Ϣ�м�¼��ʽΪ?ID^fieldvalue1,fieldid1^fieldvalue2,fieldid2....^fieldvaluen,fieldidn
function ApproveEditFieldsInfo(objtbl,currow)
{
	var cellName="";
	var cellValue="";
	var editCellName="";
	var cols=ObjEditFields.length;
	if (cols==0)  return ""
	
	var tableNames=new Array();
	var tableInfos=new Array();
	var newRowFlags=new Array();
	var tableCount=0;
	
	var RowID=GetElementValue("RowID");	
	var rows=0;		// Mozy �ޱ�����
	if (objtbl) rows=objtbl.rows.length-1;
	if ((currow)&&(currow!=""))
	{
		rows=currow
	}
	else
	{
		currow=0
	}
	//i��0��ʼ,��֤û���б�Ҳ���ճ�ִ��
	for (var i=currow;i<=rows;i++)
	{
		//��ʼ�����б�־
		for (var k=0;k<tableCount;k++)
		{
			newRowFlags[k]=1;
		}		
		
		var TRowID=GetElementValue("TRowIDz"+i)
		
		for (var j=0;j<cols;j++)
		{
			cellName=ObjEditFields[j].FieldName;
			editCellName=ObjEditFields[j].EditFieldName;
			if (ObjEditFields[j].ListFlag=="Y")
			{
				//�����б�Ԫ��,���û��TRowID�򲻴���
				if ((TRowID=="-1")||(TRowID=="")) continue;
				cellName=cellName+"z"+i;
				editCellName=editCellName+"z"+i;
			}
			else
			{
				//���ڷ��б��ֶ�ִֻ��һ��
				if (i!=0) continue;				
			}
			
			///���Ҷ�Ӧ��tableNames			
			var tableIndex=-1;
			for (var k=0;k<tableCount;k++)
			{
				if (tableNames[k]==ObjEditFields[j].TableName) tableIndex=k;
			}
			//�����tableNames��������δ�иñ���Ϣ,��������Ϣ
			if (tableIndex==-1)
			{
				tableNames[tableCount]=ObjEditFields[j].TableName;
				tableInfos[tableCount]=ObjEditFields[j].TableName;
				newRowFlags[tableCount]=0;
				tableIndex=tableCount;
				tableCount=tableCount+1;				
				if (ObjEditFields[j].ListFlag!="Y")
				{
					if (ObjEditFields[j].RowIDName=="")
					{
						tableInfos[tableIndex]=tableInfos[tableIndex]+"&"+RowID;
					}
					else
					{
						tableInfos[tableIndex]=tableInfos[tableIndex]+"&"+GetElementValue(ObjEditFields[j].RowIDName);
					}					
				}
				else
				{
					// Mozy0040 2011-2-10
					if (ObjEditFields[j].RowIDName=="")
					{
						tableInfos[tableIndex]=tableInfos[tableIndex]+"&"+TRowID;
					}
					else
					{
						tableInfos[tableIndex]=tableInfos[tableIndex]+"&"+GetElementValue(ObjEditFields[j].RowIDName+"z"+i);
					}
				}
			}
			else
			{
				//���Ϊ����,����Ҫ��¼TRowID
				if (newRowFlags[tableIndex]==1)
				{
					// Mozy0040 2011-2-10
					if (ObjEditFields[j].RowIDName=="")
					{
						tableInfos[tableIndex]=tableInfos[tableIndex]+"&"+TRowID;
					}
					else
					{
						tableInfos[tableIndex]=tableInfos[tableIndex]+"&"+GetElementValue(ObjEditFields[j].RowIDName+"z"+i);
					}
					newRowFlags[tableIndex]=0;
				}
			}
			if (ObjEditFields[j].FieldType=6)		//Add By DJ 2016-05-24
			{
				cellValue= GetElementValue(cellName);
			}
			else
			{
				cellValue= trim(GetElementValue(cellName));
			}
			if ((ObjEditFields[j].MustFlag=="Y")&&(cellValue==""))
			{
				if (ObjEditFields[j].FieldCaption=="")
				{
					alertShow(t[ObjEditFields[j].FieldName]+"����Ϊ��!");	// Mozy	2011-2-24	����Ԫ����Label
				}
				else
				{
					alertShow(ObjEditFields[j].FieldCaption+"����Ϊ��!");
				}
				SetFocus(editCellName);
				return "-1";
			}
			tableInfos[tableIndex]=tableInfos[tableIndex]+"^"+cellValue+","+ObjEditFields[j].RowID;
		}
	}
	
	var EditFieldsInfo="";
	for (var k=0;k<tableCount;k++)
	{
		if (EditFieldsInfo!="") EditFieldsInfo=EditFieldsInfo+"@";
		EditFieldsInfo=EditFieldsInfo+tableInfos[k];
	}
	return EditFieldsInfo
}

///����DR��Name��ȡ�༭Ԫ�ص�Name
function GetEditElementName(DRName)
{
	var EditElementName=DRName;
	var len=DRName.length;
	if ((len>2)&&(DRName.substring(len-2)=="DR"))
	{
		EditElementName=DRName.substring(0,len-2);
	}
	return EditElementName	
}

function SetItemDisabale(approvetype,approveset,approverole)
{
	var encmeth=GetElementValue("GetApproveNeedField");
	if (encmeth=="") return;
	var ReturnValue=cspRunServerMethod(encmeth,approvetype,approveset,approverole);
	if (ReturnValue!="")
	{		
		var list=ReturnValue.split(",");
		var len=list.length;
		for (var i=0;i<len;i++)
		{
			var nameinfo=list[i].split("-");
			if (nameinfo.length>1)
			{	for (var j=1;j<=nameinfo[1];j++)
				{
					DisableBElement(nameinfo[0]+j,false);
				}
			}
			else
			{	DisableBElement(list[i],false);}
		}
		if (len>0)
		{
			DisableBElement("BAdd",false);
			var obj=document.getElementById("BAdd");//����
			if (obj) obj.onclick=BApproveUpdate_Clicked;
		}
	}
}

///��ȡ���е����ֺ�׺���
function GetRowIndex(RowObj)
{
	var rowitems=RowObj.all;
	if (!rowitems) rowitems=RowObj.getElementsByTagName("LABEL");
	for (var j=0;j<rowitems.length;j++) 
	{
		if (rowitems[j].id) 
		{
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			var Row=arrId[arrId.length-1];
			if (Row>0) return Row;
		}
	}
	return 0;
}

///����Ϊ�б�д�к�
///startindex:��ʼ������
///startno?��ʼ�к�
function ResetNo(startindex,startno)
{
	var len=tableList.length;
	var nextNo=startno;
	for (var i=startindex;i<len;i++) 
	{
		if (tableList[i]=="0")
		{			
			SetElement("TRowz"+i,nextNo);
			nextNo=parseInt(nextNo)+1;			
		}
	}	
}

///����һ��
///		������һ�еĸ�ʽ����
///		���ӵ�Ԫ�����ֵĺ�׺����ۼ�
///	objtbl:�����еı�����
///	LastNameIndex:���һ�������е����ƺ�׺��,�������ϼ���
///	NewNameIndex:�����е����ƺ�׺��	
///	ע��?tableListΪ�����еı�ĸ��м�¼
///	
function AddRowToList(objtbl,LastNameIndex,NewNameIndex) 
{
	var rows=objtbl.rows.length;
	///���̶��ϼ���
	var fixLastRow;
	var lastDataRowIndex;
	
	///TotalFlag  0�޺ϼ� 1�ϼ������� 2�ϼ���ĩ��))
	var TotalFlag=GetElementValue("TotalFlag");	
	if (TotalFlag==2)
	{
		fixLastRow=objtbl.rows[rows-1];
		lastDataRowIndex=rows-2;
	}
	else
	{
		fixLastRow=null;
		lastDataRowIndex=rows-1;
	}

	var objlastrow=objtbl.rows[lastDataRowIndex];
	objtbody=tk_getTBody(objlastrow);

	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all;
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*");
	for (var j=0;j<rowitems.length;j++)
	{
		if (rowitems[j].id) 
		{
			var Id=rowitems[j].id;
			var offset=Id.lastIndexOf("z");
			var colName=Id.substring(0,offset+1);
			rowitems[j].id=colName+NewNameIndex;
			rowitems[j].name=colName+NewNameIndex;
			if (rowitems[j].tagName=='LABEL')
			{
				rowitems[j].innerText="";
			}
			else
			{
				rowitems[j].value="";
			}
		}
	}
	objnewrow=objtbody.insertBefore(objnewrow,fixLastRow);
	//alertShow(NewNameIndex);
	tableList[NewNameIndex]=0	
	var BDeleteList=document.getElementById("BDeleteListz"+NewNameIndex);
	if (BDeleteList) BDeleteList.onclick=DeleteClickHandler;
		
	//�������
	var TRow=document.getElementById("TRowz"+NewNameIndex);
	var No=GetCElementValue("TRowz"+LastNameIndex);
	if (TRow)
	{		
		TRow.innerText=parseInt(No)+1;
	}
	
	//���õ�˫�е���ɫ
	if ((objnewrow.rowIndex)%2==0)
	{
		objnewrow.className="RowEven";
	}
	else
	{
		objnewrow.className="RowOdd";
	}	
}

///Modified by JDL 2010-8-3
///����������ذ�ť
///�����������ô�����صİ�ť
function InitApproveButton()
{
	var ApproveSetDR=GetElementValue("ApproveSetDR");
	for (var i=1;i<=6;i++)
	{
		HiddenObj("BApprove"+i,1);
	}
	var nextStep=GetElementValue("NextFlowStep");
	var curRole=GetElementValue("CurRole");
	var nextRole=GetElementValue("NextRoleDR");
	var RoleStep=GetElementValue("RoleStep");		//Add By DJ 2016-05-24
	///����ǰ�û���ɫ����һ����ɫһ��ʱ���ɲ���
	///��������������иò������ȡ����ȡ����ť����
	var CancelFlag=GetElementValue("CancelFlag");
	if ((curRole==nextRole)&&(CancelFlag=="Y")&&(nextStep==RoleStep))		//Add By DJ 2016-05-24
	{
		var obj=document.getElementById("BCancelSubmit");
		if (obj) obj.onclick=BCancelSubmit_Clicked;
		//Modified by JDL 2011-03-21 ����ܾ�ԭ�����������ֻ����
		ReadOnlyElement("RejectReason",false);		
	}
	else
	{
		DisableBElement("BCancelSubmit",true);
		//Modified by JDL 2011-03-21 ����ܾ�ԭ�����������ֻ����
		ReadOnlyElement("RejectReason",true);
	}
	//Modified by JDL 2011-03-21 ����ܾ�ԭ�����������ֻ����
	ReadOnlyElement("EditOpinion",true);
	
	if (ApproveSetDR=="") return;
	
	///����������ť���⼰�Ƿ����
	var encmeth=GetElementValue("GetApproveFlow")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,ApproveSetDR);
	if (Rtn=="") return;	//û������������ʱ�˳�	ZY0057 2011-2-15
	var List=Rtn.split("^")
	//alertShow(ApproveSetDR+","+curRole+","+nextRole)
	for (var i=1;i<=List.length;i++)
	{
		var FlowInfo=List[i-1];
		var FlowList=FlowInfo.split(",");
		SetCElement("BApprove"+i,FlowList[2]);
		
		if ((curRole==nextRole)&&(nextStep==FlowList[0])&&(nextStep==RoleStep))		//Add By DJ 2016-05-24
		{
			//alertShow("FlowInfo="+FlowInfo)
			var obj=document.getElementById("BApprove"+nextStep);
			if (obj) 
			{
				obj.onclick=BApprove_Clicked;
				//Modified by JDL 2011-03-21 ����ܾ�ԭ�����������ֻ����
				ReadOnlyElement("EditOpinion",false);
			}
		}
		else
		{
			DisableBElement("BApprove"+i,true);
		}
		HiddenObj("BApprove"+i,0);
	}
	return;
}


///����һ��Table�е�CustomItemԪ�ص�ֻ������
///���?objTable?������
///		 Status?����״̬ 	
function ReadOnlyCustomItem(ObjTable,Status)
{
	var HasEditFields=0;
	if (!ObjTable) return HasEditFields;
	//����Input���͵�Ԫ��
	//alertShow(Status)
	var All=ObjTable.getElementsByTagName( "INPUT" );
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		var Flag=CheckUnEditField(Status,All[I].id);
		if (!Flag) HasEditFields=1;
		ReadOnlyElement(All[I].id,Flag)
		if (All[I].type=="checkbox") DisableElement(All[I].id,Flag);
		if (document.getElementById(GetLookupName(All[I].id)))
		{
			DisableElement(GetLookupName(All[I].id),Flag);
		}
	}
	//����TEXTAREA���͵�Ԫ��
	var All=ObjTable.getElementsByTagName("TEXTAREA" );
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		if ((All[I].id=="EditOpinion")||(All[I].id=="RejectReason")) continue;
		var Flag=CheckUnEditField(Status,All[I].id);
		if (!Flag) HasEditFields=1;
		ReadOnlyElement(All[I].id,Flag)
	}
	//����SELECT���͵�Ԫ��
	var All=ObjTable.getElementsByTagName("SELECT" );
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		var Flag=CheckUnEditField(Status,All[I].id);
		if (!Flag) HasEditFields=1;
		ReadOnlyElement(All[I].id,Flag);
		DisableElement(All[I].id,Flag);
	}	
	return HasEditFields;
}

/// Add By ZY 2011-03-10
/// ����:�ѵ�ǰ��ɫ����������ŵ�����༭����;
/// ����:value:Role1,Step1,Opinion1^Role2,Step2,Opinion2
/// 	 ename:����༭��Ԫ�ص�����
///      ����CurRole��ȡ��ǰ��ɫ��ǰ�����
function FillEditOpinion(value,ename)
{
	if (!value) return
	var list=value.split("^");
	var len=list.length
	for (var i=0;i<len;i++)
	{
		var EditOpinion=list[i].split(",");
		if (GetElementValue("CurRole")==EditOpinion[0])
		{
			SetElement("EditOpinion",EditOpinion[2])
			i=len;
		}
		else
		{
			SetElement("EditOpinion","")
		}		
	}
}