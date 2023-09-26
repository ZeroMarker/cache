/// 名称: DHCHAI.IR.ICUGrade
/// 描述: ICU临床病情等级调查
/// 编写者：zhufei
/// 编写日期: 2017-10-13
Class DHCHAI.IR.ICUGrade Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property IGEpisodeDr As DHCHAI.DP.PAAdm;

/// 调查科室
Property IGLocDr As DHCHAI.BT.Location;

/// 调查年
Property IGYear As %Integer;

/// 调查月
Property IGMonth As %Integer;

/// 调查周
Property IGWeek As %Integer;

/// 调查项目1(A)
Property IGItem1 As %Float;

/// 调查项目2(B)
Property IGItem2 As %Float;

/// 调查项目3(C)
Property IGItem3 As %Float;

/// 调查项目4(D)
Property IGItem4 As %Float;

/// 调查项目5(E)
Property IGItem5 As %Float;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 更新用户
Property UpdateUser As DHCHAI.BT.SysUser;

Index IndexEpisodeLocYYMM On (IGLocDr, IGYear, IGMonth, IGWeek, IGEpisodeDr);

/// Creator：     pylian
/// CreatDate：   2017-10-18
/// Description:  根据ID取ICU临床病情等级记录
/// Table：       DHCHAI.IR.ICUGrade
/// Input：       ID:    DHCHAI.IR.ICUGrade.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.ICUGrade).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.ICUGrade
{
	new (aId)
	Set return=""
	Set obj=##Class(DHCHAI.IR.ICUGrade).%OpenId(aId)
	if obj'="" do obj.%Close()
	Set return=obj
	quit return
}

/// Creator：     pylian
/// CreatDate：   2017-10-18
/// Description:  更新ICU临床病情等级记录
/// Table：       DHCHAI.IR.ICUGrade
/// Input：       各属性列表 ^ 分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: ID 2: IGLocDr 3: IGYear 4: IGMonth 5: IGWeek 6: IGItem1 7: IGItem2 ...
/// w ##Class(DHCHAI.IR.ICUGrade).Update("^33^43^2020^06^Week2^0^0^0^0^0","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String) As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" separete=..#SEPARATE

	Set ID			= $p(aInputStr,aSeparete,1)
	Set GEpisodeDr	= $p(aInputStr,aSeparete,2)
	Set GLocDr      = $p(aInputStr,aSeparete,3)
	Set GYear       = +$p(aInputStr,aSeparete,4)
	Set GMonth      = +$p(aInputStr,aSeparete,5)
	Set GWeek       = +$p(aInputStr,aSeparete,6)
	Set GItem1      = +$p(aInputStr,aSeparete,7)
	Set GItem2      = +$p(aInputStr,aSeparete,8)
	Set GItem3      = +$p(aInputStr,aSeparete,9)
	Set GItem4      = +$p(aInputStr,aSeparete,10)
	Set GItem5      = +$p(aInputStr,aSeparete,11)
	Set UpdateDate  = $p(aInputStr,aSeparete,12)
	Set UpdateTime  = $p(aInputStr,aSeparete,13)
	Set UpdateUser  = $p(aInputStr,aSeparete,14)
	Quit:(GEpisodeDr="")||(GLocDr="")||(GYear="")||(GMonth="")||(GWeek="") return
  
	Set tID=$o(^DHCHAI.IR.ICUGradeI("IndexEpisodeLocYYMM",GLocDr,GYear,GMonth,GWeek,GEpisodeDr,0))
	Quit:(ID'="")&(tID'="")&(ID'=tID) -2
	Set:(ID="")&(tID'="") ID=tID
	
	Set:UpdateDate'="" UpdateDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(UpdateDate)
	Set:UpdateDate="" UpdateDate=+$h
	Set:UpdateTime[":" UpdateTime = $zth(UpdateTime,1)
	Set:UpdateTime="" UpdateTime=$p($h,",",2)
	
	Set objPaadm=##class(DHCHAI.DP.PAAdm).GetObjById(GEpisodeDr)
	Quit:'$IsObject(objPaadm) return
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(GLocDr)
	Quit:'$IsObject(objLoc) return
	Set objUser=##class(DHCHAI.BT.SysUser).GetObjById(UpdateUser)

	If ID="" {
		Set obj=##class(DHCHAI.IR.ICUGrade).%New()
	} else {
		Set obj=##class(DHCHAI.IR.ICUGrade).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IGEpisodeDr= objPaadm
	Set obj.IGLocDr    = objLoc    
	Set obj.IGYear     = GYear     
	Set obj.IGMonth    = GMonth    
	Set obj.IGWeek     = GWeek     
	Set obj.IGItem1    = GItem1    
	Set obj.IGItem2    = GItem2    
	Set obj.IGItem3    = GItem3    
	Set obj.IGItem4    = GItem4    
	Set obj.IGItem5    = GItem5
	Set obj.UpdateDate = UpdateDate
	Set obj.UpdateTime = UpdateTime
	Set obj.UpdateUser = objUser  

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
/// CreatDate：   2017-10-18
/// Description:  删除ICU临床病情等级记录
/// Table：       DHCHAI.IR.ICUGrade
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.ICUGrade).%DeleteId(+aId)
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
<Data name="ICUGradeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IGEpisodeDr</Value>
</Value>
<Value name="3">
<Value>IGLocDr</Value>
</Value>
<Value name="4">
<Value>IGYear</Value>
</Value>
<Value name="5">
<Value>IGMonth</Value>
</Value>
<Value name="6">
<Value>IGWeek</Value>
</Value>
<Value name="7">
<Value>IGItem1</Value>
</Value>
<Value name="8">
<Value>IGItem2</Value>
</Value>
<Value name="9">
<Value>IGItem3</Value>
</Value>
<Value name="10">
<Value>IGItem4</Value>
</Value>
<Value name="11">
<Value>IGItem5</Value>
</Value>
<Value name="12">
<Value>UpdateDate</Value>
</Value>
<Value name="13">
<Value>UpdateTime</Value>
</Value>
<Value name="14">
<Value>UpdateUser</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.ICUGradeD</DataLocation>
<DefaultData>ICUGradeDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.ICUGradeD</IdLocation>
<IndexLocation>^DHCHAI.IR.ICUGradeI</IndexLocation>
<StreamLocation>^DHCHAI.IR.ICUGradeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
