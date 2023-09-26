///记录可编辑字段信息
///记录 字段名
///记录 字段ID
///记录 字段所在表名
var	ObjEditFields=new Array();

///记录 行的序号及增删改操作
///合计行记录?-1
///有修改需更新值为0
///删除记录明细RowID
var tableList=new Array();

///创建编辑字段信息对象
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
	//引用型
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

///需要在业务组件上?定义隐藏元素GetReqFields?s val=##Class(%CSP.Page).Encrypt($lb("web.DHCEQApprove.GetRequiredFields"))
///初始化可编辑字段信息
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

///检测该字段是否不可编辑
///status?单据状态
///field?界面元素名?列表元素名字传入时不带z及行号
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

///增加参数currow:在列表中,如果有选择框的,只处理当前选中那一行  DJ0104
///获取编辑字段及值信息
///表之间的信息用"@"分割
///记录之间的信息用"&"分割
///元素之间的信息用"^"分割
///返回值为: 表信息1@表信息2...@表信息n
///			 表信息中记录格式为?表名&记录1&记录2...&记录n
///			 记录信息中记录格式为?ID^fieldvalue1,fieldid1^fieldvalue2,fieldid2....^fieldvaluen,fieldidn
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
	var rows=0;		// Mozy 无表格组件
	if (objtbl) rows=objtbl.rows.length-1;
	if ((currow)&&(currow!=""))
	{
		rows=currow
	}
	else
	{
		currow=0
	}
	//i从0开始,保证没有列表也能照常执行
	for (var i=currow;i<=rows;i++)
	{
		//初始化新行标志
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
				//对于列表元素,如果没有TRowID则不处理
				if ((TRowID=="-1")||(TRowID=="")) continue;
				cellName=cellName+"z"+i;
				editCellName=editCellName+"z"+i;
			}
			else
			{
				//对于非列表字段只执行一次
				if (i!=0) continue;				
			}
			
			///查找对应的tableNames			
			var tableIndex=-1;
			for (var k=0;k<tableCount;k++)
			{
				if (tableNames[k]==ObjEditFields[j].TableName) tableIndex=k;
			}
			//如果在tableNames数组中尚未有该表信息,则建立该信息
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
				//如果为新行,则需要记录TRowID
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
					alertShow(t[ObjEditFields[j].FieldName]+"不能为空!");	// Mozy	2011-2-24	隐藏元素无Label
				}
				else
				{
					alertShow(ObjEditFields[j].FieldCaption+"不能为空!");
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

///根据DR的Name获取编辑元素的Name
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
			var obj=document.getElementById("BAdd");//更新
			if (obj) obj.onclick=BApproveUpdate_Clicked;
		}
	}
}

///获取该行的名字后缀序号
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

///重新为行编写行号
///startindex:开始行索引
///startno?开始行号
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

///新增一行
///		复制上一行的格式内容
///		增加的元素名字的后缀序号累加
///	objtbl:增加行的表格对象
///	LastNameIndex:最后一行数据行的名称后缀号,不包含合计行
///	NewNameIndex:新增行的名称后缀号	
///	注意?tableList为操作中的表的各行记录
///	
function AddRowToList(objtbl,LastNameIndex,NewNameIndex) 
{
	var rows=objtbl.rows.length;
	///最后固定合计行
	var fixLastRow;
	var lastDataRowIndex;
	
	///TotalFlag  0无合计 1合计在首行 2合计在末行))
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
		
	//设置序号
	var TRow=document.getElementById("TRowz"+NewNameIndex);
	var No=GetCElementValue("TRowz"+LastNameIndex);
	if (TRow)
	{		
		TRow.innerText=parseInt(No)+1;
	}
	
	//设置单双行的颜色
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
///处理审批相关按钮
///根据审批设置处理相关的按钮
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
	///当当前用户角色和下一步角色一致时方可操作
	///如果工作流设置中该步骤可以取消则取消按钮可用
	var CancelFlag=GetElementValue("CancelFlag");
	if ((curRole==nextRole)&&(CancelFlag=="Y")&&(nextStep==RoleStep))		//Add By DJ 2016-05-24
	{
		var obj=document.getElementById("BCancelSubmit");
		if (obj) obj.onclick=BCancelSubmit_Clicked;
		//Modified by JDL 2011-03-21 处理拒绝原因及审批意见的只读性
		ReadOnlyElement("RejectReason",false);		
	}
	else
	{
		DisableBElement("BCancelSubmit",true);
		//Modified by JDL 2011-03-21 处理拒绝原因及审批意见的只读性
		ReadOnlyElement("RejectReason",true);
	}
	//Modified by JDL 2011-03-21 处理拒绝原因及审批意见的只读性
	ReadOnlyElement("EditOpinion",true);
	
	if (ApproveSetDR=="") return;
	
	///设置审批按钮标题及是否可用
	var encmeth=GetElementValue("GetApproveFlow")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,ApproveSetDR);
	if (Rtn=="") return;	//没有审批工作流时退出	ZY0057 2011-2-15
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
				//Modified by JDL 2011-03-21 处理拒绝原因及审批意见的只读性
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


///设置一个Table中的CustomItem元素的只读属性
///入参?objTable?表格对象
///		 Status?单据状态 	
function ReadOnlyCustomItem(ObjTable,Status)
{
	var HasEditFields=0;
	if (!ObjTable) return HasEditFields;
	//设置Input类型的元素
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
	//设置TEXTAREA类型的元素
	var All=ObjTable.getElementsByTagName("TEXTAREA" );
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		if ((All[I].id=="EditOpinion")||(All[I].id=="RejectReason")) continue;
		var Flag=CheckUnEditField(Status,All[I].id);
		if (!Flag) HasEditFields=1;
		ReadOnlyElement(All[I].id,Flag)
	}
	//设置SELECT类型的元素
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
/// 描述:把当前角色的审批意见放到意见编辑栏中;
/// 参数:value:Role1,Step1,Opinion1^Role2,Step2,Opinion2
/// 	 ename:意见编辑栏元素的名字
///      根据CurRole来取当前角色以前的意见
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