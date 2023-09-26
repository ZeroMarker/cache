/// 名称: DHCHAI.IR.ASPOpinion
/// 描述: 抗菌用药导向计划（ASP）处置意见表
///       1、停止使用抗生素
///       2、用法调整（txt）
///       3、降阶梯为（txt）---调整抗生素等级
///       4、抗生素治疗更改（area）
///       5、其他建议（area）
///       6、请感染科会诊
/// 编写者：zhufei
/// 编写日期: 2017-11-28
Class DHCHAI.IR.ASPOpinion Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 指向计划表
Property IRProgramDr As DHCHAI.IR.ASPProgram;

/// 处置方案（"IRASPOpinionType"）
Property IROpinionDr As DHCHAI.BT.Dictionary;

/// 处置意见
Property IROpinionTxt As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 抗菌用药处置索引
Index IndexOpinionDr On (IRProgramDr, IROpinionDr);

/// Creator：     mayanpeng
/// CreatDate：   2017-11-30
/// Description:  根据ID取抗菌用药处置意见表
/// Table：       DHCHAI.IR.ASPOpinion
/// Input：       ID:    DHCHAI.IR.ASPOpinion.ID
/// Return：      返回Object
/// w ##class(DHCHAI.IR.ASPOpinion).GetObjById(1)
ClassMethod GetObjById(ID As %String) As DHCHAI.IR.ASPOpinion
{
	New (ID)
	Set return=""
	Quit:ID="" return
	Quit:'##class(DHCHAI.IR.ASPOpinion).%ExistsId(+ID) return
	
	Set obj=##Class(DHCHAI.IR.ASPOpinion).%OpenId(+ID)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2017-12-04
/// Description:  更新抗菌用药处置意见表
/// Table：       DHCHAI.IR.ASPOpinion
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.ASPOpinion).Update("^1^^3^2333^1^1^^1^^^7935")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set ProgramDr	= $p(InStr,aSeparete,2)
	Set OpinionDr	= $p(InStr,aSeparete,3)
	Set OpinionTxt	= $p(InStr,aSeparete,4)
	Quit:(ProgramDr="")||(OpinionDr="")||(OpinionTxt="") return
	
	Set objProgram = ##class(DHCHAI.IR.ASPProgram).GetObjById(ProgramDr)
	Set objOpinion = ##class(DHCHAI.BT.Dictionary).GetObjById(OpinionDr)
	Quit:'$IsObject(objProgram) return
	Quit:'$IsObject(objOpinion) return
	
	Set tID=$o(^DHCHAI.IR.ASPOpinionI("IndexOpinionDr",ProgramDr,OpinionDr,""))
	Set:(tID'="")&(ID'=tID) ID=tID
	
	if ID="" {
		Set obj=##class(DHCHAI.IR.ASPOpinion).%New()
	}else{
		Set obj=##class(DHCHAI.IR.ASPOpinion).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IRProgramDr	= objProgram
	Set obj.IROpinionDr = objOpinion
	Set obj.IROpinionTxt= OpinionTxt
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2017-12-04
/// Description:  根据ID删除抗菌用药处置意见表
/// Table：       DHCHAI.IR.ASPOpinion
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	New (Id)
	Set sc = ##class(DHCHAI.IR.ASPOpinion).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="ASPOpinionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IRProgramDr</Value>
</Value>
<Value name="3">
<Value>IROpinionDr</Value>
</Value>
<Value name="4">
<Value>IROpinionTxt</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.ASPOpinionD</DataLocation>
<DefaultData>ASPOpinionDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.ASPOpinionD</IdLocation>
<IndexLocation>^DHCHAI.IR.ASPOpinionI</IndexLocation>
<StreamLocation>^DHCHAI.IR.ASPOpinionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
