/// 名称: DHCMed.NINF.BC.CasesHandleB
/// 描述: 疑似病例处置记录（临床）
/// 编写者：zhufei
/// 编写日期: 2013-12-03
Class DHCMed.NINF.BC.CasesHandleB Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.BC.Cases [ Cardinality = parent, Inverse = ChildHandleB ];

/// 操作
Property CHBOperation As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CHB_Operation ];

/// 操作日期
Property CHBActDate As %Date [ SqlColumnNumber = 4, SqlFieldName = CHB_ActDate ];

/// 操作时间
Property CHBActTime As %Time [ SqlColumnNumber = 5, SqlFieldName = CHB_ActTime ];

/// 处置科室
Property CHBActDept As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CHB_ActDept ];

/// 处置人员
Property CHBActUser As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CHB_ActUser ];

/// 处置意见
Property CHBOpinion As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CHB_Opinion ];

/// 目标科室
Property CHBTargetDept As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CHB_TargetDept ];

/// 目标病区
Property CHBTargetWard As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CHB_TargetWard ];

/// 主管医生
Property CHBTargetDoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CHB_TargetDoc ];

/// 是否有效
Property CHBIsActive As %Boolean [ SqlColumnNumber = 12, SqlFieldName = CHB_IsActive ];

/// 取消/响应科室
Property CHBCancelDept As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = CHB_CancelDept ];

/// 取消/响应人员
Property CHBCancelUser As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = CHB_CancelUser ];

/// 取消/响应日期
Property CHBCancelDate As %String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = CHB_CancelDate ];

/// 取消/响应时间
Property CHBCancelTime As %String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CHB_CancelTime ];

/// 备注
Property CHBResume As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = CHB_Resume ];

Index IndexActDate On (CHBActDate As Exact, ParRef As Exact);

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  根据ID取疑似病例处置记录
/// Table：       DHCMed.NINF.BC.CasesHandleB
/// Input：       ID:    DHCMed.NINF.BC.CasesHandleB.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.NINF.BC.CasesHandleB).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.BC.CasesHandleB
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.BC.CasesHandleB).%ExistsId(id) return
	set obj=##Class(DHCMed.NINF.BC.CasesHandleB).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  更新疑似病例处置记录
/// Table：       DHCMed.NINF.BC.CasesHandleB
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.NINF.BC.CasesHandleB).Update("","")
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
	set IsActive   = +$p(InStr,separete,12)
	set CancelDept = $p(InStr,separete,13)
	set CancelUser = $p(InStr,separete,14)
	set CancelDate = $p(InStr,separete,15)
	set CancelTime = $p(InStr,separete,16)
	set Resume     = $p(InStr,separete,17)
	quit:(ParRef="")||(Operation="") return
	
	if Childsub="" {
		set obj=##class(DHCMed.NINF.BC.CasesHandleB).%New()
	}else{
		set ID=ParRef_"||"_Childsub
		set obj=##class(DHCMed.NINF.BC.CasesHandleB).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.ParRef=##class(DHCMed.NINF.BC.Cases).%OpenId(ParRef)
	set obj.CHBOperation  = Operation
	set obj.CHBActDate    = ActDate
	set obj.CHBActTime    = ActTime
	set obj.CHBActDept    = ActDept
	set obj.CHBActUser    = ActUser
	set obj.CHBOpinion    = Opinion
	set obj.CHBTargetDept = TargetDept
	set obj.CHBTargetWard = TargetWard
	set obj.CHBTargetDoc  = TargetDoc
	set obj.CHBIsActive   = IsActive
	set obj.CHBCancelDept = CancelDept
	set obj.CHBCancelUser = CancelUser
	set obj.CHBCancelDate = CancelDate
	set obj.CHBCancelTime = CancelTime
	set obj.CHBResume     = Resume
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
/// Table：       DHCMed.NINF.BC.CasesHandleB
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.NINF.BC.CasesHandleB).%DeleteId(Id)
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
<Value>CHBOperation</Value>
</Value>
<Value name="3">
<Value>CHBActDate</Value>
</Value>
<Value name="4">
<Value>CHBActTime</Value>
</Value>
<Value name="5">
<Value>CHBActDept</Value>
</Value>
<Value name="6">
<Value>CHBActUser</Value>
</Value>
<Value name="7">
<Value>CHBOpinion</Value>
</Value>
<Value name="8">
<Value>CHBTargetDept</Value>
</Value>
<Value name="9">
<Value>CHBTargetWard</Value>
</Value>
<Value name="10">
<Value>CHBTargetDoc</Value>
</Value>
<Value name="11">
<Value>CHBIsActive</Value>
</Value>
<Value name="12">
<Value>CHBCancelDept</Value>
</Value>
<Value name="13">
<Value>CHBCancelUser</Value>
</Value>
<Value name="14">
<Value>CHBCancelDate</Value>
</Value>
<Value name="15">
<Value>CHBCancelTime</Value>
</Value>
<Value name="16">
<Value>CHBResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("HB")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("HB")</IdLocation>
<IndexLocation>^DHCMed.NINF.BC.CasesI("HB")</IndexLocation>
<StreamLocation>^DHCMed.NINF.BC.CasesHandleBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
