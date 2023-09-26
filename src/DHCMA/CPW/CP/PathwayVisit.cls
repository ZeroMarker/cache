/// 名称: DHCMA.CPW.CP.PathwayVisit
/// 描述: 临床路径 重复就诊
/// 编写者：zhufei
/// 编写日期: 2019-05-28
/// 业务规则[修改]：一次门诊就诊中只考虑一条路径的执行情况，不考虑多条路径入径；一次就诊可对应一个或多个阶段的执行并生成对应的一个或多个Visit记录,设置配置参数区分
Class DHCMA.CPW.CP.PathwayVisit Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊ID（DHCMA.Util.EP.Episode.OID）
Property CPEpisodeID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 病人主索引（DHCMA.Util.EP.Episode.PatientID）
Property CPPatientID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 身份证号码
Property CPIdentityCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出入径记录指针
Property CPPathwayDr As DHCMA.CPW.CP.Pathway [ Required ];

/// 当前（入径、切换）路径指针
Property CPFormDr As DHCMA.CPW.BT.PathForm [ Required ];

/// 当前（入径、切换）阶段指针
Property CPEpisDr As DHCMA.CPW.CP.PathwayEpis;

/// 当前（不入径）申请指针
Property CPApplyDr As DHCMA.CPW.CP.PathwayApply;

/// 路径状态[门诊路径使用状态：T不入径、就诊入径I、作废U(出径O、完成C存到Pathway表中)]
Property CPStatus As %String(DISPLAYLIST = "TMP,IN,UN", VALUELIST = ",T,I,U");

/// 处置日期
Property CPActDate As %Date;

/// 处置时间
Property CPActTime As %Time;

/// 处置人ID（指向DHCMA.Util.EP.SSUser.OID）
Property CPActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 入径医生ID（指向DHCMA.Util.EP.CareProv.OID）
Property CPInDocID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 入径日期
Property CPInDate As %Date;

/// 入径时间
Property CPInTime As %Time;

/// 入径人ID（指向DHCMA.Util.EP.SSUser.OID）
Property CPInUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 入径科室ID（指向DHCMA.Util.EP.Location.OID）
Property CPInLocID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 入径病区ID（指向DHCMA.Util.EP.Location.OID）
Property CPInWardID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 触发入径诊断主诊断表(MR_Adm)ID字符串(","分隔)
Property CPInDiags As %String;

/// 病人就诊ID索引
Index IdxOfEpisodeID On CPEpisodeID;

/// 病人就诊ID入径阶段索引
Index IdxOfEpisodeIDEpisDr On (CPEpisodeID, CPEpisDr, CPStatus) [ Unique ];

/// 病人ID出入径记录索引
Index IdxOfPatIDPathwayDr On (CPPatientID As Exact, CPPathwayDr);

/// 病人身份证号出入径记录索引
Index IdxOfIDCodePathwayDr On (CPIdentityCode As Exact, CPPathwayDr);

/// 病人入径记录日期索引
Index IdxOfInLocDate On (CPInLocID As Exact, CPInDate);

/// 出入径记录索引
Index IdxOfPathwayDr On CPPathwayDr;

/// Creator：     yankai
/// CreatDate：   2019-06-04
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.CP.PathwayVisit
/// Input：       aId : DHCMA.CPW.CP.PathwayVisit.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.CP.PathwayVisit
{
	New (aId)
	Quit:'##class(DHCMA.CPW.CP.PathwayVisit).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.CP.PathwayVisit).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2019-06-04
/// Description:  根据就诊阶段及状态取唯一对象
/// Table：       DHCMA.CPW.CP.PathwayVisit
/// Input：       aId : DHCMA.CPW.CP.PathwayVisit.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.CP.PathwayVisit).GetObjByEpisID("550!!1","40||2","")
ClassMethod GetObjByEpisID(aEpisodeID As %String, aEpisID As %String, aStatus As %String = "") As DHCMA.CPW.CP.PathwayVisit
{
	New (aEpisodeID,aEpisID,aStatus)
	Set return=""
	Quit:(aEpisodeID="")||(aEpisID="") ""
	
	If aStatus=""{
		Set Status=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfEpisodeIDEpisDr"," "_aEpisodeID,aEpisID,""),-1)
		Set VisitID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfEpisodeIDEpisDr"," "_aEpisodeID,aEpisID,Status,""))
	}Else{
		Set VisitID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfEpisodeIDEpisDr"," "_aEpisodeID,aEpisID," "_aStatus,""))
	}
	
	Set obj=##Class(DHCMA.CPW.CP.PathwayVisit).GetObjById(VisitID)
	Quit:'$IsObject(obj) ""
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2019-07-03
/// Description:  根据就诊号取最新有效Visit记录
/// Table：       DHCMA.CPW.CP.PathwayVisit
/// Input：       aEpisodeID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.CP.PathwayVisit).GetObjByPathwayID("550!!1",40)
/// w ##class(DHCMA.CPW.CP.PathwayVisit).GetObjByEpisodeID(aEpisodeID)
ClassMethod GetObjByEpisodeID(aEpisodeID As %String) As DHCMA.CPW.CP.PathwayVisit
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}

	//倒叙查找本次就诊所有入径的最新一条有效Visit记录
	Set xEpisDr=""
	For {
		Set xEpisDr=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfEpisodeIDEpisDr"," "_aEpisodeID,xEpisDr),-1)
		Quit:return'=""
		Quit:xEpisDr=""
				
		Set VisitID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfEpisodeIDEpisDr"," "_aEpisodeID,xEpisDr," I",""))
		Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(VisitID)
		Continue:'$IsObject(objVisit)
		Continue:'$IsObject(objVisit.CPPathwayDr)
		Continue:'$IsObject(objVisit.CPEpisDr)
		Set return=objVisit	
	}
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2019-06-04
/// Description:  更新入径就诊记录
/// Table：       DHCMA.CPW.CP.PathwayVisit
/// Input：       "^"分隔字符串
/// Return：      返回ID
/// w ##class(DHCMA.CPW.CP.PathwayVisit).Update("^550!!1^177^370902200202145024^40^17^40||1^^I^^^10209!!1^1!!1^65201^67805^10209!!1^6!!1^!!1^550||1,550||2,550||3","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set ID=$p(aInputStr,aSeparete,1)
	Set EpisodeOID=$p(aInputStr,aSeparete,2)
	Set PatientID=$p(aInputStr,aSeparete,3)
	Set IdentityCode=$p(aInputStr,aSeparete,4)
	Set PathwayID=$p(aInputStr,aSeparete,5)
	Set PathFormID=$p(aInputStr,aSeparete,6)
	Set PathEpisID=$p(aInputStr,aSeparete,7)
	Set PathApplyID=$p(aInputStr,aSeparete,8)
	Set Status=$p(aInputStr,aSeparete,9)
	Set ActDate=+$h
	Set ActTime=$p($h,",",2)
	Set ActUserOID=$p(aInputStr,aSeparete,12)
	Set InDocOID=$p(aInputStr,aSeparete,13)
	Set InDate=$p(aInputStr,aSeparete,14)
	Set InTime=$p(aInputStr,aSeparete,15)
	Set InUserOID=$p(aInputStr,aSeparete,16)
	Set InLocOID=$p(aInputStr,aSeparete,17)
	Set InWardOID=$p(aInputStr,aSeparete,18)
	Set InDiags=$p(aInputStr,aSeparete,19)
	
	If ID="" {                                  //根据ID判断是添加还是修改
		Set obj=##class(DHCMA.CPW.CP.PathwayVisit).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.CP.PathwayVisit).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CPEpisodeID=EpisodeOID
	Set obj.CPPatientID=PatientID
	Set obj.CPIdentityCode=IdentityCode
	Set obj.CPPathwayDr=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
	Quit:'$IsObject(obj.CPPathwayDr) return
	
	Set obj.CPFormDr=##class(DHCMA.CPW.BT.PathForm).GetObjById(PathFormID)
	Quit:'$IsObject(obj.CPFormDr) return
	
	Set obj.CPEpisDr=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(PathEpisID)
	Quit:(obj.CPEpisDr'="")&&('$IsObject(obj.CPEpisDr)) return
	
	Set obj.CPApplyDr=##class(DHCMA.CPW.CP.PathwayApply).GetObjById(PathApplyID)
	Set obj.CPStatus=Status
	Set obj.CPActDate=ActDate
	Set obj.CPActTime=ActTime
	Set obj.CPActUserID=ActUserOID
	Set obj.CPInDocID=InDocOID
	Set obj.CPInDate=InDate
	Set obj.CPInTime=InTime
	Set obj.CPInUserID=InUserOID
	Set obj.CPInLocID=InLocOID
	Set obj.CPInWardID=InWardOID
	Set obj.CPInDiags=InDiags
	
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
<Data name="PathwayVisitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPEpisodeID</Value>
</Value>
<Value name="3">
<Value>CPPatientID</Value>
</Value>
<Value name="4">
<Value>CPIdentityCode</Value>
</Value>
<Value name="5">
<Value>CPPathwayDr</Value>
</Value>
<Value name="6">
<Value>CPFormDr</Value>
</Value>
<Value name="7">
<Value>CPEpisDr</Value>
</Value>
<Value name="8">
<Value>CPApplyDr</Value>
</Value>
<Value name="9">
<Value>CPStatus</Value>
</Value>
<Value name="10">
<Value>CPIsActive</Value>
</Value>
<Value name="11">
<Value>CPActDate</Value>
</Value>
<Value name="12">
<Value>CPActTime</Value>
</Value>
<Value name="13">
<Value>CPActUserID</Value>
</Value>
<Value name="14">
<Value>CPInDocID</Value>
</Value>
<Value name="15">
<Value>CPInDate</Value>
</Value>
<Value name="16">
<Value>CPInTime</Value>
</Value>
<Value name="17">
<Value>CPInUserID</Value>
</Value>
<Value name="18">
<Value>CPInLocID</Value>
</Value>
<Value name="19">
<Value>CPInWardID</Value>
</Value>
<Value name="20">
<Value>CPInDiags</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.CP.PathwayVisitD</DataLocation>
<DefaultData>PathwayVisitDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.CP.PathwayVisitD</IdLocation>
<IndexLocation>^DHCMA.CPW.CP.PathwayVisitI</IndexLocation>
<StreamLocation>^DHCMA.CPW.CP.PathwayVisitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
