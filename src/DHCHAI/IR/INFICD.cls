/// 名称: DHCHAI.IR.INFICD
/// 描述: 医院感染 疾病诊断
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.INFICD Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property IREpisodeDr As DHCHAI.DP.PAAdm;

/// 疾病诊断指针
Property IRICDDr As DHCHAI.DP.MRDiagnos;

/// 诊断名称（临床诊断）
Property IRICDDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断名称（标准诊断）
Property IRICDDesc2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断日期
Property IRICDDate As %Date;

/// 诊断时间
Property IRICDTime As %Time;

/// 更新日期
Property IRUpdateDate As %Date;

/// 更新时间
Property IRUpdateTime As %Time;

/// 更新人
Property IRUpdateUserDr As DHCHAI.BT.SysUser;

/// 就诊记录+疾病诊断索引
Index IndexEpisodeICDDr On (IREpisodeDr, IRICDDr);

/// Creator：     chenjb
/// CreatDate：   2017-01-21
/// Description:  取医院感染报告 疾病诊断
/// Table：       DHCHAI.IR.INFICD
/// Input：       DHCHAI.IR.INFICD.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.INFICD).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.INFICD
{
	New (aId)
	Set obj=##Class(DHCHAI.IR.INFICD).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  更新医院感染报告 疾病诊断
/// Table：       DHCHAI.IR.INFICD
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.INFICD).Update("^2189^2^埃尔托型霍乱^^2017-09-11^05:01:30^9")
ClassMethod Update(aInput As %String, aSeparate As %String = "^") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	Set:$g(aSeparate)="" aSeparate=..#SEPARATE
	
	Set ID 			= $p(aInput,aSeparate,1)
	Set EpisodeID 	= $p(aInput,aSeparate,2)
	Set ICDID 		= $p(aInput,aSeparate,3)
	Set ICDDesc		= $p(aInput,aSeparate,4)
	Set ICDDesc2	= $p(aInput,aSeparate,5)
	Set ICDDate		= $p(aInput,aSeparate,6)
	Set ICDTime		= $p(aInput,aSeparate,7)
	Set UserID		= $p(aInput,aSeparate,8)
	Set:ICDDate'="" ICDDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ICDDate)
	Set:ICDTime[":" ICDTime=$zth(ICDTime,1)
	
	If (ID="") {
		Set obj=##class(DHCHAI.IR.INFICD).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.INFICD).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set objPAAdm=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(objPAAdm) return
	
	Set objICD=##class(DHCHAI.DP.MRDiagnos).GetObjById(ICDID)
	Set objUser = ##class(DHCHAI.BT.SysUser).GetObjById(UserID)
	
	Set obj.IREpisodeDr	=	objPAAdm
	Set obj.IRICDDr		=	objICD
	Set obj.IRICDDesc	=	ICDDesc
	Set obj.IRICDDesc2	=	ICDDesc2
	Set obj.IRICDDate	=	ICDDate
	Set obj.IRICDTime	=	ICDTime
	Set obj.IRUpdateDate=	+$h
	Set obj.IRUpdateTime=	$p($h,",",2)
	Set obj.IRUpdateUserDr	= objUser
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-01-21
/// Description:  删除医院感染报告 疾病诊断
/// Table：       DHCHAI.IR.INFICD
/// Input：       DHCHAI.IR.INFICD.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.INFICD).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCHAI.IR.INFICD).%DeleteId(aId)
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
<Data name="INFICDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IREpisodeDr</Value>
</Value>
<Value name="3">
<Value>IRICDDr</Value>
</Value>
<Value name="4">
<Value>IRICDDesc</Value>
</Value>
<Value name="5">
<Value>IRICDDesc2</Value>
</Value>
<Value name="6">
<Value>IRICDDate</Value>
</Value>
<Value name="7">
<Value>IRICDTime</Value>
</Value>
<Value name="8">
<Value>IRUpdateDate</Value>
</Value>
<Value name="9">
<Value>IRUpdateTime</Value>
</Value>
<Value name="10">
<Value>IRUpdateUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.INFICDD</DataLocation>
<DefaultData>INFICDDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.INFICDD</IdLocation>
<IndexLocation>^DHCHAI.IR.INFICDI</IndexLocation>
<StreamLocation>^DHCHAI.IR.INFICDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
