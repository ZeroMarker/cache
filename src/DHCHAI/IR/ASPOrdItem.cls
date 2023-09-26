/// 名称: DHCHAI.IR.ASPOrdItem
/// 描述: 抗菌用药导向计划（ASP）医嘱表
/// 编写者：zhufei
/// 编写日期: 2017-11-28
Class DHCHAI.IR.ASPOrdItem Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 指向计划表
Property IRProgramDr As DHCHAI.IR.ASPProgram;

/// 抗菌用药字典
Property IRAntiMastDr As DHCHAI.DP.OEAntiMast;

/// 指向医嘱
Property IROrdItemDr As DHCHAI.DP.OEOrdItem;

/// 指向计划表索引
Index IndexProgramDr On IRProgramDr;

/// 抗菌用药医嘱索引
Index IndexOrdItemDr On IROrdItemDr;

/// 指向计划表医嘱索引
Index IndexProOrdItem On (IRProgramDr, IROrdItemDr);

/// Creator：     mayanpeng
/// CreatDate：   2017-11-30
/// Description:  根据ID取抗菌用药医嘱表
/// Table：       DHCHAI.IR.ASPOrdItem
/// Input：       ID:    DHCHAI.IR.ASPOrdItem.ID
/// Return：      返回Object
/// w ##class(DHCHAI.IR.ASPOrdItem).GetObjById(1)
ClassMethod GetObjById(ID As %String) As DHCHAI.IR.ASPOrdItem
{
	New (ID)
	Set return=""
	Quit:ID="" return
	Quit:'##class(DHCHAI.IR.ASPOrdItem).%ExistsId(+ID) return
	
	Set obj=##Class(DHCHAI.IR.ASPOrdItem).%OpenId(+ID)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2017-12-04
/// Description:  更新抗菌用药医嘱表
/// Table：       DHCHAI.IR.ASPOrdItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.ASPOrdItem).Update("^1^^3^2333^1^1^^1^^^7935")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set ProgramDr	= $p(InStr,aSeparete,2)
	Set AntiMastDr	= $p(InStr,aSeparete,3)
	Set OrdItemDr	= $p(InStr,aSeparete,4)
	Quit:(ProgramDr="")||(AntiMastDr="")||(OrdItemDr="") return
	
	Set objProgram = ##class(DHCHAI.IR.ASPProgram).GetObjById(ProgramDr)
	Set objAntiMast = ##class(DHCHAI.DP.OEAntiMast).GetObjById(AntiMastDr)
	Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(OrdItemDr)
	Quit:'$IsObject(objProgram) return
	Quit:'$IsObject(objAntiMast) return
	Quit:'$IsObject(objOrdItem) return
	
	Set tID=$o(^DHCHAI.IR.ASPOrdItemI("IndexProOrdItem",ProgramDr,OrdItemDr,""))
	Set:(tID'="")&(ID'=tID) ID=tID
	
	if ID="" {
		Set obj=##class(DHCHAI.IR.ASPOrdItem).%New()
	}else{
		Set obj=##class(DHCHAI.IR.ASPOrdItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IRProgramDr	= objProgram
	Set obj.IRAntiMastDr = objAntiMast
	Set obj.IROrdItemDr	= objOrdItem
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
/// Description:  根据ID删除抗菌用药医嘱表
/// Table：       DHCHAI.IR.ASPOrdItem
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	New (Id)
	Set sc = ##class(DHCHAI.IR.ASPOrdItem).%DeleteId(+Id)
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
<Data name="ASPOrdItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IRProgramDr</Value>
</Value>
<Value name="3">
<Value>IROrdItemDr</Value>
</Value>
<Value name="4">
<Value>IRAntiMastDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.ASPOrdItemD</DataLocation>
<DefaultData>ASPOrdItemDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.ASPOrdItemD</IdLocation>
<IndexLocation>^DHCHAI.IR.ASPOrdItemI</IndexLocation>
<StreamLocation>^DHCHAI.IR.ASPOrdItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
