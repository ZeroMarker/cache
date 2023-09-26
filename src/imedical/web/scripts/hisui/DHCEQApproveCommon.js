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
	editFieldInfo(RowID,FieldName,TableName,MustFlag,ListFlag,FieldType,RowIDName)
}

///需要在业务组件上?定义隐藏元素GetReqFields?s val=##Class(%CSP.Page).Encrypt($lb("web.DHCEQApprove.GetRequiredFields"))
///初始化可编辑字段信息
function InitEditFields(ApproveSetDR,CurRole,ActionCode)
{
	initEditFields(ApproveSetDR,CurRole,ActionCode)
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
		//if (field=="InDate") messageShow("","","",ObjEditFields[i].FieldName+count+"&"+i);
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
	var EditFieldsInfo="";
	var EditFieldsInfo=approveEditFieldsInfo(objtbl,currow)
	return EditFieldsInfo
}

///根据DR的Name获取编辑元素的Name
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
	//messageShow("","","",NewNameIndex);
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
	initApproveButton()
	//return;
}


///设置一个Table中的CustomItem元素的只读属性
///入参?objTable?表格对象
///		 Status?单据状态 	
function ReadOnlyCustomItem(ObjTable,Status)
{
	var HasEditFields=0;
	if (!ObjTable) return HasEditFields;
	//设置Input类型的元素
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