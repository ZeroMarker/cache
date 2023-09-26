/// 病案编目主表
Class DHCWMR.FP.FrontPage Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildDiagnos As DHCWMR.FP.FPDiagnos [ Cardinality = children, Inverse = Parref ];

Relationship ChildOperation As DHCWMR.FP.FPOperation [ Cardinality = children, Inverse = Parref ];

Relationship ChildExtra As DHCWMR.FP.FPExtraItem [ Cardinality = children, Inverse = Parref ];

Relationship ChildAdmit As DHCWMR.FP.FPAdmitInfo [ Cardinality = children, Inverse = Parref ];

/// 病案主表
Property FPVolumeDr As DHCWMR.SS.Volume;

/// 编目类型
Property FPType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否完成
Property FPIsFinish As %Boolean;

/// 创建日期
Property FPBuildDate As %Date;

/// 创建时间
Property FPBuildTime As %Time;

/// 创建人(SS_User.ID)
Property FPBuildUser As %String;

/// 修改日期
Property FPUpdateDate As %Date;

/// 修改时间
Property FPUpdateTime As %Time;

/// 修改人(SS_User.ID)
Property FPUpdateUser As %String;

/// 备注
Property FPResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 数据流
Property StreamData As %GlobalCharacterStream;

/// 病案卷、操作项
Index IndexVolType On (FPVolumeDr, FPType) [ Unique ];

/// 病案卷、操作项
Index IndexVolume On (FPVolumeDr As Exact, FPType As Exact);

/// 创建日期、时间
Index IndexBuildDate On (FPIsFinish As Exact, FPBuildDate As Exact, FPBuildTime As Exact);

/// 修改日期、时间
Index IndexUpdateDate On (FPIsFinish As Exact, FPUpdateDate As Exact, FPUpdateTime As Exact);

/// Creator：     zhufei
/// CreatDate：   2014-08-26
/// Description:  根据ID取编目主记录
/// Table：       DHCWMR.FP.FrontPage
/// Input：       Id : DHCWMR.FP.FrontPage.ID
/// Return：      返回obj
/// w ##class(DHCWMR.FP.FrontPage).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.FP.FrontPage
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.FP.FrontPage).%ExistsId(aId) return
	set obj=##Class(DHCWMR.FP.FrontPage).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-08
/// Description:  根据卷ID取编目主记录
/// Table：       DHCWMR.FP.FrontPage
/// Input：       VolID : DHCWMR.SS.Volume.ID
///               FPCode : 编目系统操作代码
/// Return：      返回obj
/// w ##class(DHCWMR.FP.FrontPage).GetObjByVolId(1)
ClassMethod GetObjByVolId(aVolID As %String, aFPType As %String = "F") As DHCWMR.FP.FrontPage
{
	new (aVolID,aFPType)
	set return=""
	quit:(aVolID="")||(aFPType="") return
	
	set FrontPageID=$o(^DHCWMR.FP.FrontPageI("IndexVolume",aVolID,aFPType,0))
	quit:FrontPageID="" return
	set return=..GetObjById(FrontPageID)
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-26
/// Description:  更新编目主记录
/// Table：       DHCWMR.FP.FrontPage
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:ID 2:VolumeDr 3:WorkItem 4:IsFinish 5:BuildDate 6:BuildTime 7:Resume
/// w ##class(DHCWMR.FP.FrontPage).Update("^1^1^1^^^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set VolumeDr=$p(aInputStr,aSeparate,2)
	Set FPType=$p(aInputStr,aSeparate,3)
	Set IsFinish=+$p(aInputStr,aSeparate,4)
	Set BuildDate=$p(aInputStr,aSeparate,5)
	Set:BuildDate["-" BuildDate=$zdh(BuildDate,3)
	Set:BuildDate="" BuildDate=CurrDate
	Set BuildTime=$p(aInputStr,aSeparate,6)
	Set:BuildTime[":" BuildTime=$zdt(BuildTime,1)
	Set:BuildTime="" BuildTime=CurrTime
	Set BuildUser=$p(aInputStr,aSeparate,7)
	Set UpdateUser=$p(aInputStr,aSeparate,8)
	Set Resume=$p(aInputStr,aSeparate,9)
	Quit:(VolumeDr="")||(FPType="") return
	
	Set:ID="" ID=$o(^DHCWMR.FP.FrontPageI("IndexVolume",VolumeDr,FPType,0))
	
	Set CurrDate=+$h,CurrTime=$p($h,",",2)
	
	//数据唯一性判断
	Set:ID="" ID=$o(^DHCWMR.FP.FrontPageI("IndexVolume",VolumeDr," "_FPType,0))
	
	Set objVolume=##Class(DHCWMR.SS.Volume).GetObjById(VolumeDr)
	Quit:'$IsObject(objVolume) return
	
	If ID="" {
		Set obj=##class(DHCWMR.FP.FrontPage).%New()
	}Else{
		Set obj=##class(DHCWMR.FP.FrontPage).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.FPVolumeDr   = objVolume
	Set obj.FPType       = FPType
	Set obj.FPIsFinish   = IsFinish
	Set obj.FPBuildDate  = BuildDate
	Set obj.FPBuildTime  = BuildTime
	Set obj.FPBuildUser  = BuildUser
	Set obj.FPUpdateDate = CurrDate
	Set obj.FPUpdateTime = CurrTime
	Set obj.FPUpdateUser = UpdateUser
	Set obj.FPResume     = Resume
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

/// w ##Class(DHCWMR.FP.FrontPage).SavePatInfo(1,"")
ClassMethod SavePatInfo(aId As %String, aPatInfo As %String) As %String
{
	New (aId,aPatInfo)
	Set return=0
	Quit:(aId="")||(aPatInfo="") return
	
	Set obj=##class(DHCWMR.FP.FrontPage).GetObjById(aId)
	Quit:'$IsObject(obj) return
	
	Set return=1
	For indAI=1:1:$l(aPatInfo,$c(1)) {
		Set AIInfo=$p(aPatInfo,$c(1),indAI)
		Continue:AIInfo=""
		Set AICode=$p(AIInfo,$c(2),1)
		Set AIValue=$p(AIInfo,$c(2),2)
		Continue:AICode=""
		Set InputStr=aId_"^"_AICode_"^"_AIValue
		Set flg=##class(DHCWMR.FP.FPAdmitInfo).Update(InputStr,"^")
		If flg<0 {
			Set return=-1
		}
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-26
/// Description:  删除编目主记录
/// Table：       DHCWMR.FP.FrontPage
/// Input：       Id : DHCWMR.FP.FrontPage.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId)
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.FP.FrontPage).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
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
<Value>FPVolumeDr</Value>
</Value>
<Value name="3">
<Value>FPType</Value>
</Value>
<Value name="4">
<Value>FPIsFinish</Value>
</Value>
<Value name="5">
<Value>FPBuildDate</Value>
</Value>
<Value name="6">
<Value>FPBuildTime</Value>
</Value>
<Value name="7">
<Value>FPBuildUser</Value>
</Value>
<Value name="8">
<Value>FPUpdateDate</Value>
</Value>
<Value name="9">
<Value>FPUpdateTime</Value>
</Value>
<Value name="10">
<Value>FPUpdateUser</Value>
</Value>
<Value name="11">
<Value>FPResume</Value>
</Value>
<Value name="12">
<Value>StreamData</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.FP.FrontPageD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.FP.FrontPageD</IdLocation>
<IndexLocation>^DHCWMR.FP.FrontPageI</IndexLocation>
<StreamLocation>^DHCWMR.FP.FrontPageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
