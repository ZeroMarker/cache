/// ClassName:    DHCMed.SPE.Patients
/// Description:  特殊患者记录
/// Creator：     zhufei
/// CreatDate:    2014-07-24
Class DHCMed.SPE.Patients Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildLog As DHCMed.SPE.PatientsLog [ Cardinality = children, Inverse = ParRef ];

/// 就诊号
Property PSEpisodeID As %String(TRUNCATE = 1);

/// 患者类型
Property PSPatTypeDr As DHCMed.SPE.PatTypeSub;

/// 责任科室(CT_Loc.ID)
Property PSDutyDept As %String(TRUNCATE = 1);

/// 责任医师(CT_CareProv.ID)
Property PSDutyUser As %String(TRUNCATE = 1);

/// 标记日期
Property PSMarkDate As %Date;

/// 标记时间
Property PSMarkTime As %Time;

/// 情况说明
Property PSNote As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 初步意见
Property PSOpinion As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 审核标志（0未审核、1自动审核、2手工审核）
Property PSIsCheck As %Integer;

/// 审核日期
Property PSCheckDate As %Date;

/// 审核时间
Property PSCheckTime As %Time;

/// 审核意见
Property PSCheckOpinion As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 终结标志/关闭标志（0未关闭、1自动关闭、2手工关闭）
Property PSIsFinal As %Integer;

/// 终结日期/关闭日期
Property PSFinalDate As %Date;

/// 终结时间/关闭时间
Property PSFinalTime As %Time;

/// 转归情况("SPEPrognosis")
Property PSPrognosis As DHCMed.SS.Dictionary;

/// 当前状态("SPEStatus")
Property PSCurrStatus As DHCMed.SS.Dictionary;

/// 更新日期
Property PSUpdateDate As %Date;

/// 更新时间
Property PSUpdateTime As %Time;

/// 更新人(SS_User.ID)
Property PSUpdateUser As %String(TRUNCATE = 1);

Index IndexAdmPatType On (PSEpisodeID As Exact, PSPatTypeDr As Exact);

Index IndexIsCheckMark On (PSIsCheck, PSMarkDate, PSMarkTime);

Index IndexIsFinalMark On (PSIsFinal, PSMarkDate, PSMarkTime);

Index IndexMarkDate On (PSMarkDate, PSMarkTime);

Index IndexCheckDate On (PSCheckDate, PSCheckTime);

Index IndexFinalDate On (PSFinalDate, PSFinalTime);

/// Creator：     zhufei
/// CreatDate：   2014-07-24
/// Description:  取值特殊患者记录
/// Table：       DHCMed.SPE.Patients
/// Input：       DHCMed.SPE.Patients.ID
/// Return：      返回obj
/// w ##class(DHCMed.SPE.Patients).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.SPE.Patients
{
	New (aId)
	Set obj=##Class(DHCMed.SPE.Patients).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2014-07-24
/// Description:  更新特殊患者记录
/// Table：       DHCMed.SPE.Patients
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.SPE.Patients).Update("^4^1||1^1^366^63392^情况说明^初步意见^^^^^5793^5785^63392^76596^366","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set PatTypeID=$p(aInput,aSeparate,3)
	Set objPatType=##class(DHCMed.SPE.PatTypeSub).GetObjById(PatTypeID)
	Quit:'$IsObject(objPatType) return
	
	Set StatusID=$p(aInput,aSeparate,10)
	Set objStatus=##class(DHCMed.SS.Dictionary).GetObjById(StatusID)
	Quit:'$IsObject(objStatus) return
	
	Set PrognosisID=$p(aInput,aSeparate,14)
	Set objPrognosis=##class(DHCMed.SS.Dictionary).GetObjById(PrognosisID)
	
	Set ID=$p(aInput,aSeparate,1)
	If ID="" {
		Set obj=##class(DHCMed.SPE.Patients).%New()
	} Else {
		Set obj=##class(DHCMed.SPE.Patients).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.PSEpisodeID    = $p(aInput,aSeparate,2)
	Set obj.PSPatTypeDr    = objPatType
	Set obj.PSDutyDept     = $p(aInput,aSeparate,4)
	Set obj.PSDutyUser     = $p(aInput,aSeparate,5)
	Set obj.PSNote         = $p(aInput,aSeparate,6)
	Set obj.PSOpinion      = $p(aInput,aSeparate,7)
	Set obj.PSMarkDate     = $p(aInput,aSeparate,8)
	Set obj.PSMarkTime     = $p(aInput,aSeparate,9)
	Set obj.PSCurrStatus   = objStatus
	Set obj.PSCheckOpinion = $p(aInput,aSeparate,11)
	Set obj.PSCheckDate    = $p(aInput,aSeparate,12)
	Set obj.PSCheckTime    = $p(aInput,aSeparate,13)
	Set obj.PSPrognosis    = objPrognosis
	Set obj.PSFinalDate    = $p(aInput,aSeparate,15)
	Set obj.PSFinalTime    = $p(aInput,aSeparate,16)
	Set obj.PSUpdateDate   = $p(aInput,aSeparate,17)
	Set obj.PSUpdateTime   = $p(aInput,aSeparate,18)
	Set obj.PSUpdateUser   = $p(aInput,aSeparate,19)
	Set obj.PSIsCheck      = +$p(aInput,aSeparate,20)
	Set obj.PSIsFinal      = +$p(aInput,aSeparate,21)
	
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

/// Creator：     zhufei
/// CreatDate：   2014-07-24
/// Description:  删除特殊患者记录
/// Table：       DHCMed.SPE.Patients
/// Input：       DHCMed.SPE.Patients.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.SPE.Patients).%DeleteId(+aId)
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
<Value>PSEpisodeID</Value>
</Value>
<Value name="3">
<Value>PSPatTypeDr</Value>
</Value>
<Value name="4">
<Value>PSCurrStatus</Value>
</Value>
<Value name="5">
<Value>PSDutyDept</Value>
</Value>
<Value name="6">
<Value>PSDutyUser</Value>
</Value>
<Value name="7">
<Value>PSMarkDate</Value>
</Value>
<Value name="8">
<Value>PSMarkTime</Value>
</Value>
<Value name="9">
<Value>PSNote</Value>
</Value>
<Value name="10">
<Value>PSOpinion</Value>
</Value>
<Value name="11">
<Value>PSIsCheck</Value>
</Value>
<Value name="12">
<Value>PSCheckDate</Value>
</Value>
<Value name="13">
<Value>PSCheckTime</Value>
</Value>
<Value name="14">
<Value>PSCheckOpinion</Value>
</Value>
<Value name="15">
<Value>PSIsFinal</Value>
</Value>
<Value name="16">
<Value>PSFinalDate</Value>
</Value>
<Value name="17">
<Value>PSFinalTime</Value>
</Value>
<Value name="18">
<Value>PSPrognosis</Value>
</Value>
<Value name="19">
<Value>PSUpdateDate</Value>
</Value>
<Value name="20">
<Value>PSUpdateTime</Value>
</Value>
<Value name="21">
<Value>PSUpdateUser</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SPE("Pat")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SPE("Pat")</IdLocation>
<IndexLocation>^DHCMed.SPEi("Pat",0)</IndexLocation>
<StreamLocation>^DHCMed.SPE.PatientsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
