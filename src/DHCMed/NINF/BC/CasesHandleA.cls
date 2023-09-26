/// 名称: DHCMed.NINF.BC.CasesHandleA
/// 描述: 疑似病例处置记录（管理）
/// 编写者：zhufei
/// 编写日期: 2013-12-03
Class DHCMed.NINF.BC.CasesHandleA Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.BC.Cases [ Cardinality = parent, Inverse = ChildHandleA ];

/// 操作
Property CHAOperation As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CHA_Operation ];

/// 操作日期
Property CHAActDate As %Date [ SqlColumnNumber = 4, SqlFieldName = CHA_ActDate ];

/// 操作时间
Property CHAActTime As %Time [ SqlColumnNumber = 5, SqlFieldName = CHA_ActTime ];

/// 处置科室
Property CHAActDept As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CHA_ActDept ];

/// 处置人员
Property CHAActUser As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CHA_ActUser ];

/// 处置意见
Property CHAOpinion As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CHA_Opinion ];

/// 目标科室
Property CHATargetDept As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CHA_TargetDept ];

/// 目标病区
Property CHATargetWard As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CHA_TargetWard ];

/// 主管医生
Property CHATargetDoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CHA_TargetDoc ];

/// 自动生成标记
Property CHAAutoFlag As %Boolean [ SqlColumnNumber = 12, SqlFieldName = CHA_AutoFlag ];

/// 关联筛查日志
Property CHALnkCasesX As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = CHA_LnkCasesX ];

/// 是否有效
Property CHAIsActive As %Boolean [ SqlColumnNumber = 14, SqlFieldName = CHA_IsActive ];

/// 取消/响应科室
Property CHACancelDept As %String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = CHA_CancelDept ];

/// 取消/响应人员
Property CHACancelUser As %String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CHA_CancelUser ];

/// 取消/响应日期
Property CHACancelDate As %String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = CHA_CancelDate ];

/// 取消/响应时间
Property CHACancelTime As %String(TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = CHA_CancelTime ];

/// 备注
Property CHAResume As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = CHA_Resume ];

Index IndexLnkCasesX On (CHALnkCasesX As Exact, ParRef As Exact);

Index IndexActDate On (CHAActDate As Exact, ParRef As Exact);

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  根据ID取疑似病例处置记录
/// Table：       DHCMed.NINF.BC.CasesHandleA
/// Input：       ID:    DHCMed.NINF.BC.CasesHandleA.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.NINF.BC.CasesHandleA).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.BC.CasesHandleA
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.BC.CasesHandleA).%ExistsId(id) return
	set obj=##Class(DHCMed.NINF.BC.CasesHandleA).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  更新疑似病例处置记录
/// Table：       DHCMed.NINF.BC.CasesHandleA
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.NINF.BC.CasesHandleA).Update("","")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set:$g(separete)="" separete=..#SEPARATE
	set ParRef     = $p(InStr,separete,1)
	set Childsub   = $p(InStr,separete,2)
	set Operation  = $p(InStr,separete,3)
	set ActDate    = $p(InStr,separete,4)
	set:ActDate="" ActDate=+$h
	set ActTime    = $p(InStr,separete,5)
	set:ActTime="" ActTime=$p($h,",",2)
	set ActDept    = $p(InStr,separete,6)
	set ActUser    = $p(InStr,separete,7)
	set Opinion    = $p(InStr,separete,8)
	set TargetDept = $p(InStr,separete,9)
	set TargetWard = $p(InStr,separete,10)
	set TargetDoc  = $p(InStr,separete,11)
	set AutoFlag   = $p(InStr,separete,12)
	set LnkCasesX  = $p(InStr,separete,13)
	set IsActive   = +$p(InStr,separete,14)
	set CancelDept = $p(InStr,separete,15)
	set CancelUser = $p(InStr,separete,16)
	set CancelDate = $p(InStr,separete,17)
	set CancelTime = $p(InStr,separete,18)
	set Resume     = $p(InStr,separete,19)
	quit:(ParRef="")||(Operation="") return
	
	if Childsub="" {
		set obj=##class(DHCMed.NINF.BC.CasesHandleA).%New()
	}else{
		set ID=ParRef_"||"_Childsub
		set obj=##class(DHCMed.NINF.BC.CasesHandleA).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.ParRef=##class(DHCMed.NINF.BC.Cases).%OpenId(ParRef)
	set obj.CHAOperation  = Operation
	set obj.CHAActDate    = ActDate
	set obj.CHAActTime    = ActTime
	set obj.CHAActDept    = ActDept
	set obj.CHAActUser    = ActUser
	set obj.CHAOpinion    = Opinion
	set obj.CHATargetDept = TargetDept
	set obj.CHATargetWard = TargetWard
	set obj.CHATargetDoc  = TargetDoc
	set obj.CHAAutoFlag   = AutoFlag
	set obj.CHALnkCasesX  = LnkCasesX
	set obj.CHAIsActive   = IsActive
	set obj.CHACancelDept = CancelDept
	set obj.CHACancelUser = CancelUser
	set obj.CHACancelDate = CancelDate
	set obj.CHACancelTime = CancelTime
	set obj.CHAResume     = Resume
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  删除疑似病例处置记录
/// Table：       DHCMed.NINF.BC.CasesHandleA
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.NINF.BC.CasesHandleA).%DeleteId(Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CHAOperation</Value>
</Value>
<Value name="3">
<Value>CHAActDate</Value>
</Value>
<Value name="4">
<Value>CHAActTime</Value>
</Value>
<Value name="5">
<Value>CHAActDept</Value>
</Value>
<Value name="6">
<Value>CHAActUser</Value>
</Value>
<Value name="7">
<Value>CHAOpinion</Value>
</Value>
<Value name="8">
<Value>CHATargetDept</Value>
</Value>
<Value name="9">
<Value>CHATargetWard</Value>
</Value>
<Value name="10">
<Value>CHATargetDoc</Value>
</Value>
<Value name="11">
<Value>CHAAutoFlag</Value>
</Value>
<Value name="12">
<Value>CHALnkCasesX</Value>
</Value>
<Value name="13">
<Value>CHAIsActive</Value>
</Value>
<Value name="14">
<Value>CHACancelDept</Value>
</Value>
<Value name="15">
<Value>CHACancelUser</Value>
</Value>
<Value name="16">
<Value>CHACancelDate</Value>
</Value>
<Value name="17">
<Value>CHACancelTime</Value>
</Value>
<Value name="18">
<Value>CHAResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("HA")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("HA")</IdLocation>
<IndexLocation>^DHCMed.NINF.BC.CasesI("HA")</IndexLocation>
<StreamLocation>^DHCMed.NINF.BC.CasesHandleAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
