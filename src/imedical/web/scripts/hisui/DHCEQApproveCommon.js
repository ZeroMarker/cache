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
	editFieldInfo(RowID,FieldName,TableName,MustFlag,ListFlag,FieldType,RowIDName)
}

///��Ҫ��ҵ�������?��������Ԫ��GetReqFields?s val=##Class(%CSP.Page).Encrypt($lb("web.DHCEQApprove.GetRequiredFields"))
///��ʼ���ɱ༭�ֶ���Ϣ
function InitEditFields(ApproveSetDR,CurRole,ActionCode)
{
	initEditFields(ApproveSetDR,CurRole,ActionCode)
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
		//if (field=="InDate") messageShow("","","",ObjEditFields[i].FieldName+count+"&"+i);
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
	var EditFieldsInfo="";
	var EditFieldsInfo=approveEditFieldsInfo(objtbl,currow)
	return EditFieldsInfo
}

///����DR��Name��ȡ�༭Ԫ�ص�Name
function GetEditElementName(DRName)
{
	var EditElementName=DRName;
	var EditElementName=getEditElementName(DRName)
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
	//messageShow("","","",NewNameIndex);
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
	initApproveButton()
	//return;
}


///����һ��Table�е�CustomItemԪ�ص�ֻ������
///���?objTable?������
///		 Status?����״̬ 	
function ReadOnlyCustomItem(ObjTable,Status)
{
	var HasEditFields=0;
	if (!ObjTable) return HasEditFields;
	//����Input���͵�Ԫ��
	//messageShow("","","",Status)
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