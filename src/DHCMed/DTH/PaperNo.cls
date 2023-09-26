/// 名称:DHCMed.DTH.PaperNo
/// 描述: 死亡证明书纸单号主表
/// 编写者：yhb
/// 编写日期: 2014-06-19
Class DHCMed.DTH.PaperNo Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

//Relationship ParRef As DHCMed.DTH.Report [ Cardinality = parent, Inverse = PaperNo ];

/// 状态子表
Relationship ChildPaperNoStatus As DHCMed.DTH.PaperNoStatus [ Cardinality = children, Inverse = ParrefRaperNo ];

/// 死亡报告对象
Property RepObj As DHCMed.DTH.Report;

/// 号码
Property PaperNo As %String(TRUNCATE = 1);

/// 入库科室 CT_Loc  入库【Storage】
Property StLocDR As %String(TRUNCATE = 1);

/// 入库人员
Property StDoctorDR As %String(TRUNCATE = 1);

/// 操作日期
Property StDate As %Date;

/// 操作时间
Property StTime As %Time;

/// 分配科室 CT_Loc
Property AllocLocDR As %String(TRUNCATE = 1);

/// 状态
Property StatusDR As DHCMed.SS.Dictionary;

/// 三联打印标记
Property ThreeFlag As %String(TRUNCATE = 1);

/// 首联打印标记
Property OneFlag As %String(TRUNCATE = 1);

/// 是否有效
Property IsActive As %Boolean;

/// 备注
Property Resume As %String(MAXLEN = 200, TRUNCATE = 1);

/// 报告纸单号索引
Index IndexDTRepPaperNo On (StDate As Exact, StTime As Exact, RepObj As Exact, PaperNo As Exact);

/// 报告纸单号索引
/// Index IndexTimeRepPaperNo On (StTime As Exact, RepObj As Exact, PaperNo As Exact);
/// 纸单号索引
Index IndexPaperNo On PaperNo As Exact;

/// Creator:          yhb
/// CreateDate:       2014-06-19
/// OperationTable:   DHCMed.DTH.PaperNo
/// Input:            separete：分割符
/// Output:           RowId^PaperNo^StLocDR^StDoctorDR^AllocLocDR^StatusDR^IsActive^Resume
/// Description:      将对象格式化为字符串
Method ToString(separate As %String) As %String
{
	if ($g(separate)="")
	{
		set separate=..#SEPARATE
	}
	set return=..%Id()_separate
	set return=return_..PaperNo_separate
	set return=return_..StLocDR_separate
	set return=return_..StDoctorDR_separate  
	set return=return_..AllocLocDR_separate
	set return=return_..StatusDR_separate
	set return=return_..IsActive_separate
	set return=return_..Resume_separate
	quit return
}

/// Creator:          yhb
/// CreateDate:       2014-06-19
/// OperationTable:   DHCMed.DTH.PaperNo
/// Input:            id:rowId
/// Output:           DHCMed.DTH.PaperNo 对象
/// Description:      根据id得到DHCMed.DTH.PaperNo对象
/// w ##Class(DHCMed.DTH.PaperNo).GetObjById(21)
ClassMethod GetObjById(id As %String) As DHCMed.DTH.RepNo
{
	new (id)
	set return=""
	set obj=##Class(DHCMed.DTH.PaperNo).%OpenId(id)
	if $IsObject(obj){
		set return=obj
		do obj.%Close()
	}
	quit return
}

/// Creator:          yhb
/// CreateDate:       2014-06-19
/// OperationTable:   DHCMed.DTH.PaperNo
/// Input:            id:rowId,
///                   separate:分割符
/// Output:           DHCMed.DTH.PaperNo 对象内容拼凑的字符串
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

/// Creator:          yhb
/// CreateDate:       2014-06-19
/// OperationTable: DHCMed.DTH.PaperNo
/// Input:          instr:需要插入或更新的字符串,字符串格式 
///       RowId^RepID^RaperNo^StLocDR^STDoctorDR^AllocLocDR^StatusDR^IsActive^Resume
///                 separate:分割符
/// Output:         失败返回-1，成功返回该对象的rowId
/// Description:    插入一个对象，如果对象存在，更新这个对象
/// w ##Class(DHCMed.DTH.PaperNo).Update("^1^1234567^1^9^1^1^1^备注","^")
ClassMethod Update(instr As %String, separate As %String) As %String
{
	new (instr,separate)
	
	set return=-1
	if ($g(separate)="")
	{
		set separate=..#SEPARATE
	}
	set id=$p($g(instr),separate,1)
	if (id="")
	{
		set obj=##Class(DHCMed.DTH.PaperNo).%New()
	}
	else
	{
		set obj=##Class(DHCMed.DTH.PaperNo).%OpenId(id)
	}
	set RepID=$p($g(instr),separate,2)
	set objRep=##Class(DHCMed.DTH.Report).%OpenId(RepID)
	if ($IsObject(objRep)) {
		set obj.RepObj=objRep
	}
	set paperNo=+$p($g(instr),separate,3)
	s $p(PaperNo,"0",8-$l(paperNo))= paperNo
	if (RepID'="") {
		s oldPaperNo=""
		for {
			s oldPaperNo = $o(^DHCMed.DTHi("PAPERNO","IndexPaperNo",oldPaperNo))
			q:oldPaperNo=""
			if (PaperNo=oldPaperNo){
				s return=-99
			}
		}
		q:return=-99 return
	}
	set obj.PaperNo=PaperNo
	set obj.StLocDR=$p($g(instr),separate,4)
	set obj.StDoctorDR=$p($g(instr),separate,5)
	set currDate=+$h
	set currTime=+$p($h,",",2)
	set obj.StDate=currDate
	set obj.StTime=currTime
	set obj.AllocLocDR=$p($g(instr),separate,6)
	set status=$p($g(instr),separate,7)
	set statusDicId=##Class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(status,"DTHCurrencyState") 
	set statusDicObj=##Class(DHCMed.SS.Dictionary).GetObjById(+statusDicId)
	set obj.StatusDR=statusDicObj
	set obj.IsActive=$p($g(instr),separate,8)
	set obj.Resume=$p($g(instr),separate,9)
	set OneFlag = $p($g(instr),separate,10)
	if (OneFlag'="") {
		set obj.OneFlag = OneFlag
	}
	set ThreeFlag = $p($g(instr),separate,11)
	if (ThreeFlag'="") {
		set obj.ThreeFlag = ThreeFlag
	}
	set paperNoStatus=##Class(DHCMed.DTH.PaperNoStatus).%New()
	set paperNoStatus.StatusDR=statusDicObj
	set paperNoStatus.OpeDate=currDate
	set paperNoStatus.OpeTime=currTime
	set paperNoStatus.OpeLocDR=$p($g(instr),separate,4)
	set paperNoStatus.OpeUserDR=$p($g(instr),separate,5)
	set paperNoStatus.ParrefRaperNo = obj
	set paperNoRowId=paperNoStatus.%Save()
	set retVal=obj.%Save()
	if ($system.Status.IsError(retVal))
	{
		do $system.OBJ.DisplayError(retVal)
		set return=-1
	}
	else
	{
		set return=obj.%Id()
	}
	do obj.%Close()
	quit return
}

/// Creator:          yhb
/// CreateDate:       2014-06-19
/// OperationTable: DHCMed.DTH.PaperNo
/// Description:    根据RowId删除一个对象
/// Input:          id:RepID||rowId
/// Output:         返回0操作成功，小于0操作失败
ClassMethod DeleteObjById(id As %String) As %String
{
	new (id)
	set return=""
	set retVal=##Class(DHCMed.DTH.PaperNo).%DeleteId(id)
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
<Value>PaperNo</Value>
</Value>
<Value name="3">
<Value>LocDR</Value>
</Value>
<Value name="4">
<Value>DoctorDR</Value>
</Value>
<Value name="5">
<Value>StatusDR</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
<Value name="7">
<Value>Resume</Value>
</Value>
<Value name="8">
<Value>DPaperNo</Value>
</Value>
<Value name="9">
<Value>OpeDate</Value>
</Value>
<Value name="10">
<Value>OpeTime</Value>
</Value>
</Data>
<Data name="PaperNoDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>RepObj</Value>
</Value>
<Value name="2">
<Value>StLocDR</Value>
</Value>
<Value name="3">
<Value>StDoctorDR</Value>
</Value>
<Value name="4">
<Value>StDate</Value>
</Value>
<Value name="5">
<Value>StTime</Value>
</Value>
<Value name="6">
<Value>AllocLocDR</Value>
</Value>
<Value name="7">
<Value>ThreeFlag</Value>
</Value>
<Value name="8">
<Value>OneFlag</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DTH("PAPERNO")</DataLocation>
<DefaultData>PaperNoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DTH("PAPERNO")</IdLocation>
<IndexLocation>^DHCMed.DTHi("PAPERNO")</IndexLocation>
<StreamLocation>^DHCMed.DTH.PaperNoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
