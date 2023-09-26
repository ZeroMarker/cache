/// 名称:DHCMed.DTH.RepNo
/// 描述: 死亡证明书编号主表
/// 编写者：wangCS
/// 编写日期: 2011-07-18
Class DHCMed.DTH.RepNo Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 号码类型
Property TypeDR As DHCMed.SS.Dictionary;

/// 号码
Property ReportNo As %String(TRUNCATE = 1);

/// 科室 CT_Loc
Property LocDR As %String(TRUNCATE = 1);

/// 医护人员
Property DoctorDR As %String(TRUNCATE = 1);

/// 状态
Property StatusDR As DHCMed.SS.Dictionary;

/// 是否有效
Property IsActive As %Boolean;

/// 备注
Property Resume As %String(MAXLEN = 200, TRUNCATE = 1);

/// 号码索引
/// Index IndexReportNo On ReportNo [ Unique ];
Index IndexReportNo On ReportNo As Exact;

Index IndexStatus On StatusDR As Exact;

/// 科室索引
Index IndexLoc On LocDR;

/// 类型科室索引
/// Index IndexTypeLoc On (TypeDR, LocDR, StatusDR);
/// 类型状态索引
Index IndexTypeStatus On (TypeDR, StatusDR);

/// 状态子表
Relationship ChildReportNoStatus As DHCMed.DTH.RepNoStatus [ Cardinality = children, Inverse = ParrefReportNo ];

/// Creator:          wangCS
/// CreateDate:       2011-07-18
/// OperationTable:   DHCMed.DTH.RepNo
/// Input:            separete：分割符
/// Output:           RowId^TypeDR^ReportNo^LocDR^DoctorDR^StatusDR^IsActive^Resume
/// Description:      将对象格式化为字符串
Method ToString(separate As %String) As %String
{
	if ($g(separate)="")
	{
		set separate=..#SEPARATE
	}
	set return=..%Id()_separate
	set return=return_..TypeDR_separate
	set return=return_..ReportNo_separate
	set return=return_..LocDR_separate
	set return=return_..DoctorDR_separate
	set return=return_..StatusDR_separate
	set return=return_..IsActive_separate
	set return=return_..Resume_separate
	quit return
}

/// Creator:          wangCS
/// CreateDate:       2011-07-18
/// OperationTable:   DHCMed.DTH.RepNo
/// Input:            id:rowId
/// Output:           DHCMed.DTH.RepNo 对象
/// Description:      根据id得到DHCMed.DTH.RepNo对象
/// w ##Class(DHCMed.DTH.RepNo).GetObjById(21)
ClassMethod GetObjById(id As %String) As DHCMed.DTH.RepNo
{
	new (id)
	set return=""
	set obj=##Class(DHCMed.DTH.RepNo).%OpenId(id)
	if $IsObject(obj){
		set return=obj
		do obj.%Close()
	}
	quit return
}

/// Creator:          wangCS
/// CreateDate:       2011-07-18
/// OperationTable:   DHCMed.DTH.RepNo
/// Input:            id:rowId,
///                  separate:分割符
/// Output:           DHCMed.DTH.RepNo 对象内容拼凑的字符串
/// Description:      根据id得到对象内容的字符串
ClassMethod GetStringById(id As %String, separate As %String) As %String
{
	new (id,separate)
	set return=""
	set reportNoObj=..GetObjById(id)
	if ($IsObject(reportNoObj))
	{
		set return=reportNoObj.ToString($g(separate))
	}
	quit return
}

/// Creator:         wangCS
/// CreateDate:     2011-07-18
/// OperationTable: DHCMed.DTH.RepNo
/// Input:          instr:需要插入或更新的字符串,字符串格式 RowId^TypeDR^ReportNo^LocDR^DoctorDR^StatusDR^IsActive^Resume^UserId
///                separate:分割符
/// Output:         失败返回-1，成功返回该对象的rowId
/// Description:    插入一个对象，如果对象存在，更新这个对象
/// w ##Class(DHCMed.DTH.RepNo).Update("^1^1^1^^9^1^^627","^")
ClassMethod Update(instr As %String, separate As %String) As %String
{
	new (instr,separate)
	
	set return=""
	if ($g(separate)="")
	{
		set separate=..#SEPARATE
	}
	set id=$p($g(instr),separate,1)
	if (id="")
	{
		set obj=##Class(DHCMed.DTH.RepNo).%New()
	}
	else
	{
		set obj=##Class(DHCMed.DTH.RepNo).%OpenId(id)
	}
	set typeid=$p($g(instr),separate,2)
	set typeDicId=##Class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(typeid,"DTHRegion") 
	set typeDicObj=##Class(DHCMed.SS.Dictionary).GetObjById(+typeDicId)
	set obj.TypeDR=typeDicObj  ;$p($g(instr),separate,2)
	
	set obj.ReportNo=$p($g(instr),separate,3)
	set obj.LocDR=$p($g(instr),separate,4)
	set obj.DoctorDR=$p($g(instr),separate,5)
	
	set status=$p($g(instr),separate,6)
	set statusDicId=##Class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(status,"DTHCurrencyState") 
	set statusDicObj=##Class(DHCMed.SS.Dictionary).GetObjById(+statusDicId)
	set obj.StatusDR=statusDicObj
	
	set obj.IsActive=$p($g(instr),separate,7)
	set obj.Resume=$p($g(instr),separate,8)
	set noStatusObj=##Class(DHCMed.DTH.RepNoStatus).%New()
	set noStatusObj.StatusDR=statusDicObj
	set noStatusObj.OpeUserDR=$p($g(instr),separate,9)
	set currDate=+$h
	set currTime=+$p($h,",",2)
	set noStatusObj.OpeDate=currDate
	set noStatusObj.OpeTime=currTime
	set noStatusObj.ParrefReportNo=obj
	
	set retVal=obj.%Save()
	if ($system.Status.IsError(retVal))
	{
		do $system.OBJ.DisplayError(retVal)
		set id=-1
	}
	else
	{
		set id=obj.%Id()
	}
	do obj.%Close()
	do noStatusObj.%Close()
	quit id
}

/// Creator:        wangCS
/// CreateDate:     2011-07-18
/// OperationTable: DHCMed.DTH.RepNo
/// Description:    根据RowId删除一个对象
/// Input:          id:rowId
///                separate:分割符
/// Output:         返回0操作成功，小于0操作失败
ClassMethod DeleteObjById(id As %String) As %String
{
	new (id)
	set return=""
	set retVal=##Class(DHCMed.DTH.RepNo).%DeleteId(id)
	if ($system.Status.IsError(retVal))
	{
		do $system.OBJ.DisplayError(retVal)
		set return=-1
	}
	else
	{
		set return=0
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TypeDR</Value>
</Value>
<Value name="3">
<Value>ReportNo</Value>
</Value>
<Value name="4">
<Value>LocDR</Value>
</Value>
<Value name="5">
<Value>DoctorDR</Value>
</Value>
<Value name="6">
<Value>StatusDR</Value>
</Value>
<Value name="7">
<Value>IsActive</Value>
</Value>
<Value name="8">
<Value>Resume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DTH("REPNO")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DTH("REPNO")</IdLocation>
<IndexLocation>^DHCMed.DTHi("REPNO")</IndexLocation>
<StreamLocation>^DHCMed.DTH.RepNoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
