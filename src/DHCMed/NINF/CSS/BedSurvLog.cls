/// 名称: DHCMed.NINF.CSS.BedSurvLog
/// 描述: 横断面调查床旁调查生成日志
/// 编写者：maxp
/// 编写日期: 2013-12-02
Class DHCMed.NINF.CSS.BedSurvLog Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 调查编号
Property BSLSurvNumber As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = BSL_SurvNumber ];

/// 科室
Property BSLSurvLoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = BSL_SurvLoc ];

/// 调查日期
Property BSLSurvDate As %Date [ SqlColumnNumber = 4, SqlFieldName = BSL_SurvDate ];

/// 生成日期
Property BSLUpdateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = BSL_UpdateDate ];

/// 生成时间
Property BSLUpdateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = BSL_UpdateTime ];

/// 操作员
Property BSLUpdateUser As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = BSL_UpdateUser ];

/// 是否有效
Property BSLIsActive As %Boolean [ SqlColumnNumber = 8, SqlFieldName = BSL_IsActive ];

/// 备注
Property BSLResume As %String(MAXLEN = 500) [ SqlColumnNumber = 9, SqlFieldName = BSL_Resume ];

Index IndexSurvNumber On BSLSurvNumber As Exact;

/// w ##class(DHCMed.NINF.CSS.BedSurvLog).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.CSS.BedSurvLog
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.CSS.BedSurvLog).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.CSS.BedSurvLog).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     maxp
/// CreatDate：   2013-12-02
/// input: InStr="ID^BSLSurvNumber^BSLSurvLoc^BSLSurvDate^BSLUpdateUser^BSLIsActive^BSLResume"
/// w ##Class(DHCMed.NINF.CSS.BedSurvLog).Update("")
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set return=0
	quit:InStr="" return
	
	set ID=$p(InStr,"^",1)
	if ID="" {
		set obj=##class(DHCMed.NINF.CSS.BedSurvLog).%New()
	} else {
		set obj=##class(DHCMed.NINF.CSS.BedSurvLog).%OpenId(ID)
	}
	
	set obj.BSLSurvNumber=$p(InStr,"^",2)
	set obj.BSLSurvLoc=$p(InStr,"^",3)
	set SurvDate=$p(InStr,"^",4)
	;set:SurvDate["-" SurvDate=$zdh(SurvDate,3)
	set:SurvDate'="" SurvDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(SurvDate)
	set obj.BSLSurvDate=SurvDate
	set UpdateDate=$p(InStr,"^",5)
	;set:UpdateDate["-" UpdateDate=$zdh(UpdateDate,3)
	set:UpdateDate'="" UpdateDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(UpdateDate)
	set:UpdateDate="" UpdateDate=+$h
	set obj.BSLUpdateDate=+UpdateDate
	set UpdateTime=$p(InStr,"^",6)
	set:UpdateTime[":" UpdateTime=$zth(UpdateTime,1)
	set:UpdateTime="" UpdateTime=$p($h,",",2)
	set obj.BSLUpdateTime=UpdateTime
	set obj.BSLUpdateUser=$p(InStr,"^",7)
	set obj.BSLIsActive=$p(InStr,"^",8)
	set obj.BSLResume=$p(InStr,"^",9)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     maxp
/// CreatDate：   2013-12-02
/// Description:  删除
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Quit:aId="" return
	Set sc = ##class(DHCMed.NINF.CSS.BedSurvLog).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BSLSurvNumber</Value>
</Value>
<Value name="3">
<Value>BSLSurvLoc</Value>
</Value>
<Value name="4">
<Value>BSLSurvDate</Value>
</Value>
<Value name="5">
<Value>BSLUpdateDate</Value>
</Value>
<Value name="6">
<Value>BSLUpdateTime</Value>
</Value>
<Value name="7">
<Value>BSLUpdateUser</Value>
</Value>
<Value name="8">
<Value>BSLIsActive</Value>
</Value>
<Value name="9">
<Value>BSLResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.CSS("BSL")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.CSS("BSL")</IdLocation>
<IndexLocation>^DHCMed.NINF.CSSi("BSL")</IndexLocation>
<StreamLocation>^DHCMed.NINF.CSS.BedSurvLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
