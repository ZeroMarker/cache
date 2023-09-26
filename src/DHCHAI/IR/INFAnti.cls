/// 名称: DHCHAI.IR.INFAnti
/// 描述: 医院感染报告 抗菌用药
/// 编写者：chenjb
/// 编写日期: 2017-01-19
Class DHCHAI.IR.INFAnti Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property IREpisodeDr As DHCHAI.DP.PAAdm;

/// 抗生素指针
Property IRAntiUseDr As DHCHAI.DP.OEOrdItem;

/// 抗生素（医嘱名称）
Property IRAntiDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 抗生素（药品通用名）
Property IRAntiDesc2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 开始日期
Property IRSttDate As %Date;

/// 结束日期
Property IREndDate As %Date;

/// 剂量
Property IRDoseQty As %Float;

/// 剂量单位
Property IRDoseUnit As DHCHAI.BT.Dictionary;

/// 频次
Property IRPhcFreq As DHCHAI.BT.Dictionary;

/// 用途(麻醉开始时、术前0.5-2小时、术前2-24小时、术前>24小时、术中用药、术后用药)
Property IRMedUsePurpose As DHCHAI.BT.Dictionary;

/// 给药途径
Property IRAdminRoute As DHCHAI.BT.Dictionary;

/// 目的
Property IRMedPurpose As DHCHAI.BT.Dictionary;

/// 治疗用药方式
Property IRTreatmentMode As DHCHAI.BT.Dictionary;

/// 预防用药效果
Property IRPreMedEffect As DHCHAI.BT.Dictionary;

/// 预防用药指征
Property IRPreMedIndicat As DHCHAI.BT.Dictionary;

/// 联合用药
Property IRCombinedMed As DHCHAI.BT.Dictionary;

/// 术前用药时间(分钟)
Property IRPreMedTime As %Integer;

/// 术后用药天数(天)
Property IRPostMedDays As %Integer;

/// 敏感度
Property IRSenAna As DHCHAI.BT.Dictionary;

/// 更新日期
Property IRUpdateDate As %Date;

/// 更新时间
Property IRUpdateTime As %Time;

/// 更新人
Property IRUpdateUserDr As DHCHAI.BT.SysUser;

/// 就诊记录+抗生素指针 索引
Index IndexEpisodeAntiUseDr On (IREpisodeDr, IRAntiUseDr);

/// 开始时间
Property IRSttTime As %Time;

/// 结束时间
Property IREndTime As %Time;

/// Creator：     chenjb
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 抗菌用药
/// Table：       DHCHAI.IR.INFAnti
/// Input：       DHCHAI.IR.INFAnti.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.INFAnti).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.INFAnti
{
	New (aId)
	Set obj=##Class(DHCHAI.IR.INFAnti).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2012-06-21
/// Description:  更新医院感染报告 抗菌用药
/// Table：       DHCHAI.IR.INFAnti
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.INFAnti).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "^") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set ID 			= $p(aInput,aSeparate,1)
	Set EpisodeDr 	= $p(aInput,aSeparate,2)
	Set AntiUseDr 	= $p(aInput,aSeparate,3)
	Set AntiDesc 	= $p(aInput,aSeparate,4)
	Set AntiDesc2 	= $p(aInput,aSeparate,5)
	Set SttDateTime = $p(aInput,aSeparate,6)
	Set EndDateTime = $p(aInput,aSeparate,7)
	Set SttTime=""
	Set EndTime=""
	Set SttDate=""
	Set EndDate=""
	Set:SttDateTime'="" SttDate =$p(SttDateTime," ",1) 
	Set:SttDateTime'="" SttTime =$p(SttDateTime," ",2)
	Set:SttDate'="" SttDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(SttDate)
	Set:SttTime'="" SttTime=$zth(SttTime,1)
	
	Set:EndDateTime'="" EndDate =$p(EndDateTime," ",1)
	Set:EndDateTime'="" EndTime =$p(EndDateTime," ",2)
	Set:EndDate'="" EndDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(EndDate)
	Set:EndTime'="" EndTime=$zth(EndTime,1)

	Set DoseQty 	= $p(aInput,aSeparate,8)
	Set DoseUnit 	= $p(aInput,aSeparate,9)
	Set PhcFreq 	= $p(aInput,aSeparate,10)
	Set MedUsePurpose 	= $p(aInput,aSeparate,11)
	Set AdminRoute 	= $p(aInput,aSeparate,12)
	Set MedPurpose 	= $p(aInput,aSeparate,13)
	Set TreatmentMode 	= $p(aInput,aSeparate,14)
	Set PreMedEffect 	= $p(aInput,aSeparate,15)
	Set PreMedIndicat 	= $p(aInput,aSeparate,16)
	Set CombinedMed 	= $p(aInput,aSeparate,17)
	Set PreMedTime 	= $p(aInput,aSeparate,18)
	Set PostMedDays 	= $p(aInput,aSeparate,19)
	Set SenAna 	= $p(aInput,aSeparate,20)
	Set UpdateDate 	= $p(aInput,aSeparate,21)
	Set:UpdateDate="" UpdateDate = +$h
	Set UpdateTime 	= $p(aInput,aSeparate,22)
	Set:UpdateTime="" UpdateTime = +($p($h,",",2))
	Set UpdateUserDr 	= $p(aInput,aSeparate,23)
	Set objEpisode =##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$IsObject(objEpisode) return
	
	If (ID="") {
		Set obj=##class(DHCHAI.IR.INFAnti).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.INFAnti).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set objAntiUse =##class(DHCHAI.DP.OEOrdItem).GetObjById(AntiUseDr)
	Set objDoseUnit =##class(DHCHAI.BT.Dictionary).GetObjById(DoseUnit)
	Set objPhcFreq =##class(DHCHAI.BT.Dictionary).GetObjById(PhcFreq)
	Set objMedUsePurpose =##class(DHCHAI.BT.Dictionary).GetObjById(MedUsePurpose)
	Set objAdminRoute =##class(DHCHAI.BT.Dictionary).GetObjById(AdminRoute)
	Set objMedPurpose =##class(DHCHAI.BT.Dictionary).GetObjById(MedPurpose)
	Set objTreatmentMode =##class(DHCHAI.BT.Dictionary).GetObjById(TreatmentMode)
	Set objPreMedEffect =##class(DHCHAI.BT.Dictionary).GetObjById(PreMedEffect)
	Set objPreMedIndicat =##class(DHCHAI.BT.Dictionary).GetObjById(PreMedIndicat)
	Set objCombinedMed =##class(DHCHAI.BT.Dictionary).GetObjById(CombinedMed)
	Set objSenAna =##class(DHCHAI.BT.Dictionary).GetObjById(SenAna)
	Set objUpdateUser =##class(DHCHAI.BT.SysUser).GetObjById(UpdateUserDr)
	
	Set obj.IREpisodeDr=objEpisode
	Set obj.IRAntiUseDr=objAntiUse
	Set obj.IRAntiDesc=AntiDesc
	Set obj.IRAntiDesc2=AntiDesc2
	Set obj.IRSttDate=SttDate
	Set obj.IREndDate=EndDate
	Set obj.IRDoseQty=DoseQty
	Set obj.IRDoseUnit=objDoseUnit
	Set obj.IRPhcFreq=objPhcFreq
	Set obj.IRMedUsePurpose=objMedUsePurpose
	Set obj.IRAdminRoute=objAdminRoute
	Set obj.IRMedPurpose=objMedPurpose
	Set obj.IRTreatmentMode=objTreatmentMode
	Set obj.IRPreMedEffect=objPreMedEffect
	Set obj.IRPreMedIndicat=objPreMedIndicat
	Set obj.IRCombinedMed=objCombinedMed
	Set obj.IRPreMedTime=PreMedTime
	Set obj.IRPostMedDays=PostMedDays
	Set obj.IRSenAna=objSenAna
	Set obj.IRUpdateDate=UpdateDate
	Set obj.IRUpdateTime=UpdateTime
	Set obj.IRUpdateUserDr=objUpdateUser
	Set obj.IRSttTime=SttTime
	Set obj.IREndTime=EndTime
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
/// CreatDate：   2012-06-21
/// Description:  删除医院感染报告 抗菌用药
/// Table：       DHCHAI.IR.INFAnti
/// Input：       DHCHAI.IR.INFAnti.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.INFAnti).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCHAI.IR.INFAnti).%DeleteId(aId)
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
<Data name="INFAntiDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IREpisodeDr</Value>
</Value>
<Value name="3">
<Value>IRAntiUseDr</Value>
</Value>
<Value name="4">
<Value>IRAntiDesc</Value>
</Value>
<Value name="5">
<Value>IRAntiDesc2</Value>
</Value>
<Value name="6">
<Value>IRSttDate</Value>
</Value>
<Value name="7">
<Value>IREndDate</Value>
</Value>
<Value name="8">
<Value>IRDoseQty</Value>
</Value>
<Value name="9">
<Value>IRDoseUnit</Value>
</Value>
<Value name="10">
<Value>IRPhcFreq</Value>
</Value>
<Value name="11">
<Value>IRMedUsePurpose</Value>
</Value>
<Value name="12">
<Value>IRAdminRoute</Value>
</Value>
<Value name="13">
<Value>IRMedPurpose</Value>
</Value>
<Value name="14">
<Value>IRTreatmentMode</Value>
</Value>
<Value name="15">
<Value>IRPreMedEffect</Value>
</Value>
<Value name="16">
<Value>IRPreMedIndicat</Value>
</Value>
<Value name="17">
<Value>IRCombinedMed</Value>
</Value>
<Value name="18">
<Value>IRPreMedTime</Value>
</Value>
<Value name="19">
<Value>IRPostMedDays</Value>
</Value>
<Value name="20">
<Value>IRSenAna</Value>
</Value>
<Value name="21">
<Value>IRUpdateDate</Value>
</Value>
<Value name="22">
<Value>IRUpdateTime</Value>
</Value>
<Value name="23">
<Value>IRUpdateUserDr</Value>
</Value>
<Value name="24">
<Value>IRSttTime</Value>
</Value>
<Value name="25">
<Value>IREndTime</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.INFAntiD</DataLocation>
<DefaultData>INFAntiDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.INFAntiD</IdLocation>
<IndexLocation>^DHCHAI.IR.INFAntiI</IndexLocation>
<StreamLocation>^DHCHAI.IR.INFAntiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
