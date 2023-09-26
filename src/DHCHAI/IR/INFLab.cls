/// 名称: DHCHAI.IR.INFLab
/// 描述: 医院感染 病原学检验
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.INFLab Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检出菌
Relationship ChildBact As DHCHAI.IR.INFLabBact [ Cardinality = children, Inverse = Parref ];

/// 就诊记录
Property IREpisodeDr As DHCHAI.DP.PAAdm;

/// 检验报告指针
Property IRLabRepDr As DHCHAI.DP.LabVisitReport;

/// 检验组套（检验报告）
Property IRTSDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检验组套（标准医嘱）
Property IRTSDesc2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检验标本
Property IRSpecimenDr As DHCHAI.DP.LabSpecimen;

/// 送检日期
Property IRSubmissDate As %Date;

/// 送检科室
Property IRSubmissLocDr As DHCHAI.BT.Location;

/// 检验方法
Property IRAssayMethod As DHCHAI.BT.Dictionary;

/// 病原学检验(阴性/阳性)
Property IRPathogenTest As DHCHAI.BT.Dictionary;

/// 传染病病原（是/否）
Property IRLABIsEPD As DHCHAI.BT.Dictionary;

/// 更新日期
Property IRUpdateDate As %Date;

/// 更新时间
Property IRUpdateTime As %Time;

/// 更新人
Property IRUpdateUserDr As DHCHAI.BT.SysUser;

/// 就诊记录+检验报告 索引
Index IndexEpisodeLabRepDr On (IREpisodeDr, IRLabRepDr);

/// Creator：     chenjb
/// CreatDate：   2017-02-21
/// Description:  取医院感染报告 病原学检验
/// Table：       DHCHAI.IR.INFLab
/// Input：       DHCHAI.IR.INFLab.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.INFLab).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.INFLab
{
	New (aId)
	Set obj=##Class(DHCHAI.IR.INFLab).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2017-02-21
/// Description:  更新医院感染报告 病原学检验
/// Table：       DHCHAI.IR.INFLab
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.INFLab).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "^") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set ID 			= $p(aInput,aSeparate,1)
	Set EpisodeDr 	= $p(aInput,aSeparate,2)
	Set LabRepDr 	= $p(aInput,aSeparate,3)
	Set TSDesc		= $p(aInput,aSeparate,4)
	Set TSDesc2		= $p(aInput,aSeparate,5)
	Set SpecimenDr	= $p(aInput,aSeparate,6)
	Set SubmissDate	= $p(aInput,aSeparate,7)
	Set:SubmissDate'="" SubmissDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(SubmissDate)
	Set SubmissLocDr= $p(aInput,aSeparate,8)
	Set AssayMethod = $p(aInput,aSeparate,9)
	Set PathogenTest= $p(aInput,aSeparate,10)
	Set UpdateDate	= $p(aInput,aSeparate,11)
	Set:UpdateDate="" UpdateDate = +$h
	Set UpdateTime	= $p(aInput,aSeparate,12)
	Set:UpdateTime="" UpdateTime = +($p($h,",",2))
	Set UpdateUserDr= $p(aInput,aSeparate,13)
	Set LABIsEPDDr  = $p(aInput,aSeparate,14)
	Set objPAAdm=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$IsObject(objPAAdm) return
	
	If (ID="") {
		Set obj=##class(DHCHAI.IR.INFLab).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.INFLab).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set objLabRep =##class(DHCHAI.DP.LabVisitReport).GetObjById(LabRepDr)
	Set objSpecimen = ##class(DHCHAI.DP.LabSpecimen).GetObjById(SpecimenDr)
	Set objSubmissLoc = ##class(DHCHAI.BT.Location).GetObjById(SubmissLocDr)
	Set objAssayMethod = ##class(DHCHAI.BT.Dictionary).GetObjById(AssayMethod)
	Set objPathogenTest = ##class(DHCHAI.BT.Dictionary).GetObjById(PathogenTest)
	Set objUpdateUser = ##class(DHCHAI.BT.SysUser).GetObjById(UpdateUserDr)
	Set objLABIsEPD = ##class(DHCHAI.BT.Dictionary).GetObjById(LABIsEPDDr)
	Set obj.IREpisodeDr = objPAAdm
	Set obj.IRLabRepDr = objLabRep
	Set obj.IRTSDesc = TSDesc
	Set obj.IRTSDesc2 = TSDesc2
	Set obj.IRSpecimenDr = objSpecimen
	Set obj.IRSubmissDate = SubmissDate
	Set obj.IRSubmissLocDr = objSubmissLoc
	Set obj.IRAssayMethod = objAssayMethod
	Set obj.IRPathogenTest = objPathogenTest
	Set obj.IRLABIsEPD   = objLABIsEPD
	Set obj.IRUpdateDate = UpdateDate
	Set obj.IRUpdateTime = UpdateTime
	Set obj.IRUpdateUserDr = objUpdateUser
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
/// CreatDate：   2017-02-21
/// Description:  删除医院感染报告 病原学检验
/// Table：       DHCHAI.IR.INFLab
/// Input：       DHCHAI.IR.INFLabb.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.INFLab).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCHAI.IR.INFLab).%DeleteId(aId)
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
<Data name="INFLabDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IREpisodeDr</Value>
</Value>
<Value name="3">
<Value>IRLabRepDr</Value>
</Value>
<Value name="4">
<Value>IRTSDesc</Value>
</Value>
<Value name="5">
<Value>IRTSDesc2</Value>
</Value>
<Value name="6">
<Value>IRSpecimenDr</Value>
</Value>
<Value name="7">
<Value>IRSubmissDate</Value>
</Value>
<Value name="8">
<Value>IRSubmissLocDr</Value>
</Value>
<Value name="9">
<Value>IRAssayMethod</Value>
</Value>
<Value name="10">
<Value>IRPathogenTest</Value>
</Value>
<Value name="11">
<Value>IRUpdateDate</Value>
</Value>
<Value name="12">
<Value>IRUpdateTime</Value>
</Value>
<Value name="13">
<Value>IRUpdateUserDr</Value>
</Value>
<Value name="14">
<Value>IRLABIsEPD</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.INFLabD</DataLocation>
<DefaultData>INFLabDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.INFLabD</IdLocation>
<IndexLocation>^DHCHAI.IR.INFLabI</IndexLocation>
<StreamLocation>^DHCHAI.IR.INFLabS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
