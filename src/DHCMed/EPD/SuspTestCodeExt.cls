/// 传染病疑似检验项目（外部码）
Class DHCMed.EPD.SuspTestCodeExt Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMed.EPD.SuspTestCode [ Cardinality = parent, Inverse = ChildExt ];

/// 项目代码（DHCMA.Util.EP.TestCode.OID）
Property TestCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 项目名称
Property TestDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标本代码（DHCMA.Util.EP.Specimen.OID）
Property SpecCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标本名称
Property SpecDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果类型
Property ResultType As %String(DISPLAYLIST = ",Number,List,Key", VALUELIST = ",N,L,K");

/// 结果单位
Property ResultUnit As %String(MAXLEN = 100, TRUNCATE = 1);

/// 阳性结果比较值（Number最大）
Property CompValueMax As %String(MAXLEN = 100, TRUNCATE = 1);

/// 阳性结果比较值（Number最小）
Property CompValueMin As %String(MAXLEN = 100, TRUNCATE = 1);

/// 阳性结果比较值（List等于、Key包含）多值!!分隔
Property CompValues As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效标志
Property IsActive As %Boolean;

/// 更新日期
Property ActDate As %Date;

/// 更新时间
Property ActTime As %Time;

/// 更新用户
Property ActUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 性别
Property PatSex As %String(MAXLEN = 3, TRUNCATE = 1);

Index IdxofCode On TestCode As Exact;

Index IdxofDesc On TestDesc As Exact;

/// Creator：     pylian
/// CreatDate：   2019-01-22
/// Description:  根据ID取传染病疑似检验项目（外部码）
/// Table：       DHCMed.EPD.SuspTestCodeExt
/// Input：       aId : DHCMed.EPD.SuspTestCodeExt.ID
/// Return：      返回obj
/// w ##class(DHCMed.EPD.SuspTestCodeExt).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.EPD.SuspTestCodeExt
{
	New (aId)
	Quit:'##class(DHCMed.EPD.SuspTestCodeExt).%ExistsId(aId) ""
	Set obj=##Class(DHCMed.EPD.SuspTestCodeExt).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2019-01-22
/// Description:  更新传染病疑似检验项目（外部码）
/// Table：       DHCMed.EPD.SuspTestCodeExt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.SuspTestCodeExt).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set Parref       = $p(aInputStr,aSeparete,1)
	Set ChildSub     = $p(aInputStr,aSeparete,2)
	Set TestCode     = $p(aInputStr,aSeparete,3)
	Set TestDesc     = $p(aInputStr,aSeparete,4)
	Set SpecCode     = $p(aInputStr,aSeparete,5)
	Set SpecDesc     = $p(aInputStr,aSeparete,6)
	Set ResultType   = $p(aInputStr,aSeparete,7)
	Set ResultUnit   = $p(aInputStr,aSeparete,8)
	Set CompValueMax = $p(aInputStr,aSeparete,9)
	Set CompValueMin = $p(aInputStr,aSeparete,10)
	Set CompValues   = $p(aInputStr,aSeparete,11)
	Set IsActive     = $p(aInputStr,aSeparete,12)
	Set ActDate      = $p(aInputStr,aSeparete,13)
	Set ActTime      = $p(aInputStr,aSeparete,14)
	Set ActUser      = $p(aInputStr,aSeparete,15)
	Set PatSex      = $p(aInputStr,aSeparete,16)
	
	Quit:(TestCode="")||(TestDesc="") return
	
	Set objParref=##class(DHCMed.EPD.SuspTestCode).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	Set:ActDate'="" ActDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)

	If ChildSub="" {
		Set obj=##class(DHCMed.EPD.SuspTestCodeExt).%New()
	}Else{
		Set obj=##class(DHCMed.EPD.SuspTestCodeExt).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       = objParref         
	Set obj.TestCode     = TestCode    
	Set obj.TestDesc     = TestDesc 
	Set obj.SpecCode     = SpecCode      
	Set obj.SpecDesc     = SpecDesc    
	Set obj.ResultType   = ResultType  
	Set obj.ResultUnit   = ResultUnit  
	Set obj.CompValueMax = CompValueMax
	Set obj.CompValueMin = CompValueMin
	Set obj.CompValues   = CompValues  
	Set obj.IsActive     = IsActive    
	Set obj.ActDate      = ActDate     
	Set obj.ActTime      = ActTime     
	Set obj.ActUser      = ActUser   
	Set obj.PatSex       = PatSex   
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-01-22
/// Description:  删除传染病疑似检验项目（外部码）
/// Table：       DHCMed.EPD.SuspTestCodeExt
/// Input：       aId : DHCMed.EPD.SuspTestCodeExt.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.EPD.SuspTestCodeExt).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMed.EPD.SuspTestCodeExt).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="SuspTestCodeExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCode</Value>
</Value>
<Value name="3">
<Value>TestDesc</Value>
</Value>
<Value name="4">
<Value>SpecCode</Value>
</Value>
<Value name="5">
<Value>SpecDesc</Value>
</Value>
<Value name="6">
<Value>ResultType</Value>
</Value>
<Value name="7">
<Value>ResultUnit</Value>
</Value>
<Value name="8">
<Value>CompValueMax</Value>
</Value>
<Value name="9">
<Value>CompValueMin</Value>
</Value>
<Value name="10">
<Value>CompValues</Value>
</Value>
<Value name="11">
<Value>IsActive</Value>
</Value>
<Value name="12">
<Value>ActDate</Value>
</Value>
<Value name="13">
<Value>ActTime</Value>
</Value>
<Value name="14">
<Value>ActUser</Value>
</Value>
<Value name="15">
<Value>PatSex</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EXT")</DataLocation>
<DefaultData>SuspTestCodeExtDefaultData</DefaultData>
<IdLocation>{%%PARENT}("EXT")</IdLocation>
<IndexLocation>^DHCMed.EPD.SuspTestCodeI("EXT")</IndexLocation>
<StreamLocation>^DHCMed.EPD.SuspTestCodeExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
