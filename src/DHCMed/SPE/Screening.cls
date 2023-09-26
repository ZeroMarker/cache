/// ClassName:    DHCMed.SPE.Screening
/// Description:  重点病人筛查条件
/// Creator：     zhufei
/// CreatDate:    2019-01-21
Class DHCMed.SPE.Screening Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 特殊患者类型
Property BTPatTypeDr As DHCMed.SPE.PatTypeSub;

/// 是否有效
Property BTIsActive As %Boolean;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人（SS_User.ID）
Property BTActUser As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexCode On BTCode [ Unique ];

// Index IndexActive on (BTIsActive);  

/// Creator：     liuzhenhe
/// CreatDate：   2019-01-23
/// Description:  根据ID取重点病人筛查条件
/// Table：       DHCMed.SPE.Screening
/// Input：       aId :  DHCMed.SPE.Screening.ID
/// Return：      返回obj
/// zw ##class(DHCMed.SPE.Screening).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.SPE.Screening
{
	New (aId)
	Quit:'##class(DHCMed.SPE.Screening).%ExistsId(aId) ""
	Set obj=##Class(DHCMed.SPE.Screening).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-01-23
/// Description:  根据Code取重点病人筛查条件
/// Table：       DHCMed.SPE.Screening
/// Input：       aCode :  DHCMed.SPE.Screening.BTCode
/// Return：      返回String
/// zw ##class(DHCMed.SPE.Screening).GetObjByCode("02")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	Set ID=$o(^DHCMed.SPE.ScreeningI("IndexCode"," "_$zcvt(aCode,"U"),0))
	
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-01-23
/// Description:  删除重点病人筛查条件
/// Table：       DHCMed.SPE.Screening
/// Input：       aId :  DHCMed.SPE.Screening.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.SPE.Screening).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMed.SPE.Screening")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCMed.SPE.Screening).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-01-23
/// Description:  更新时判断Code是否重复
/// Table：       DHCMed.SPE.Screening
/// Input：       aCode：    代码
/// Return：      重复：ID，不重复：0
/// w ##class(DHCMed.SPE.Screening).CheckPTCode("t3")
ClassMethod CheckPTCode(aCode As %String, aID As %String = "") As %String
{
	New (aCode,aID)
	Set return=""
	Quit:(aCode="") return
	
	If ($d(^DHCMed.SPE.ScreeningI("IdxofCode"," "_$zcvt(aCode,"U"))))
	{
		Set ID=$o(^DHCMed.SPE.ScreeningI("IdxofCode"," "_$zcvt(aCode,"U"),0))
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}
	
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-01-23
/// Description:  更新重点病人筛查条件
/// Table：       DHCMed.SPE.Screening
/// Input：       aCode：    代码
/// Return：      成功：ID，失败：>=0
/// Others: w ##class(DHCMed.SPE.Screening).Update("^CC02^行重大手术病人^1||5")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set ID=$p(aInputStr,aSeparete,1)
	Set Code=$p(aInputStr,aSeparete,2)
	Set Desc=$p(aInputStr,aSeparete,3)
	Set PatTypeDr=$p(aInputStr,aSeparete,4)
	Set IsActive=$p(aInputStr,aSeparete,5)
	Set ActDate=$p(aInputStr,aSeparete,6)
	Set ActTime=$p(aInputStr,aSeparete,7)
	Set ActUser=$p(aInputStr,aSeparete,8)
	Quit:Code="" return
	
	Set:ActDate["-" ActDate=$zdh(ActDate,3)
	Set:ActDate["/" ActDate=$zdh(ActDate,4)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	Set objPatType=##class(DHCMed.SPE.PatTypeSub).GetObjById(PatTypeDr)
	
	Set tID=$o(^DHCMed.SPE.ScreeningI("IndexCode"," "_$zcvt(Code,"U"),""))
	Set:ID="" ID=tID
	Quit:(ID'="")&&(ID'=tID) return 
	       
	if ID="" {
		Set obj=##class(DHCMed.SPE.Screening).%New()
	} else {
		Set obj=##class(DHCMed.SPE.Screening).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode   =Code
	Set obj.BTDesc   =Desc
	Set obj.BTPatTypeDr =objPatType
	Set obj.BTIsActive  =IsActive
	Set obj.BTActDate   =ActDate
	Set obj.BTActTime   =ActTime
	Set obj.BTActUser   =ActUser
	
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

Storage Default
{
<Data name="ScreeningDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTPatTypeDr</Value>
</Value>
<Value name="5">
<Value>BTIsActive</Value>
</Value>
<Value name="6">
<Value>BTActDate</Value>
</Value>
<Value name="7">
<Value>BTActTime</Value>
</Value>
<Value name="8">
<Value>BTActUser</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SPE.ScreeningD</DataLocation>
<DefaultData>ScreeningDefaultData</DefaultData>
<IdLocation>^DHCMed.SPE.ScreeningD</IdLocation>
<IndexLocation>^DHCMed.SPE.ScreeningI</IndexLocation>
<StreamLocation>^DHCMed.SPE.ScreeningS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
