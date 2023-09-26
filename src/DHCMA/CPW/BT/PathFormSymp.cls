/// 名称: DHCMA.CPW.BT.PathFormSymp
/// 描述: 临床路径症候诊断
/// 编写者：zhufei
/// 编写日期: 2019-05-28
Class DHCMA.CPW.BT.PathFormSymp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.BT.PathForm [ Cardinality = parent, Inverse = ChildSymp ];

/// 症候诊断
Property SympDiagnos As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 中药方剂
Property SympTCMDr As DHCMA.CPW.BT.PathTCM;

/// 操作日期
Property SympActDate As %Date;

/// 操作时间
Property SympActTime As %Time;

/// 操作人ID（指向DHCMA.CPW.EP.SSUser.OID）
Property SympActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxofFormTCMDr On (Parref, SympTCMDr);

/// Creator：     zhufei
/// CreatDate：   2019-07-18
/// Description:  根据ID取路径表单症候+中药方剂信息
/// Table：       DHCMA.CPW.BT.PathFormSymp
/// Input：       aId :  DHCMA.CPW.BT.PathFormSymp.ID
/// Return：      返回obj
/// zw ##class(DHCMA.CPW.BT.PathFormSymp).GetObjById("8||3")
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathFormSymp
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCMA.CPW.BT.PathFormSymp).%ExistsId(aId) return
	set obj=##Class(DHCMA.CPW.BT.PathFormSymp).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-07-18
/// Description:  删除路径表单症候+中药方剂信息
/// Table：       DHCMA.CPW.BT.PathFormSymp
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathFormSymp).DeleteById("2||2")
ClassMethod DeleteById(aId)
{
	new (aId)
	set sc = ##class(DHCMA.CPW.BT.PathFormSymp).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

/// Creator：     zhufei
/// CreatDate：   2019-07-18
/// Description:  更新路径表单症候+中药方剂信息
/// Table：       DHCMA.CPW.BT.PathFormSymp
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码  （=0 参数错误）
/// w ##class(DHCMA.CPW.BT.PathFormSymp).Update("16^^对对对^2^^^9!!1","^")
ClassMethod Update(aInStr As %String, aSeparete As %String = "^") As %String
{
	new (aInStr,aSeparete)
	set return=0
	quit:aInStr="" return
	
	set:$g(aSeparete)="" aSeparete="^"
	set PathFormDr   = $p(aInStr,aSeparete,1)
	set FormSympSub  = $p(aInStr,aSeparete,2)
	set SympDiagnos  = $p(aInStr,aSeparete,3)
	set SympTCMDr    = $p(aInStr,aSeparete,4)
	set ActDate      = +$h
	set ActTime      = $p($h,",",2)
	set ActUserID    = $p(aInStr,aSeparete,7)
	quit:(PathFormDr="")||(SympTCMDr="") return
	
	set objPathForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(PathFormDr)
	quit:'$IsObject(objPathForm) return
	
	set objPathTCM=##class(DHCMA.CPW.BT.PathTCM).GetObjById(SympTCMDr)
	quit:'$IsObject(objPathTCM) return
	
	if FormSympSub="" {
		set obj=##class(DHCMA.CPW.BT.PathFormSymp).%New()
	}else{
		set ID=PathFormDr_"||"_FormSympSub
		set obj=##class(DHCMA.CPW.BT.PathFormSymp).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.Parref        = objPathForm
	set obj.SympDiagnos   = SympDiagnos
	set obj.SympTCMDr     = objPathTCM
	set obj.SympActDate   = ActDate
	set obj.SympActTime   = ActTime
	set obj.SympActUserID = ActUserID
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

Storage Default
{
<Data name="PathFormSympDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SympDiagnos</Value>
</Value>
<Value name="3">
<Value>SympTCMDr</Value>
</Value>
<Value name="4">
<Value>SympActDate</Value>
</Value>
<Value name="5">
<Value>SympActTime</Value>
</Value>
<Value name="6">
<Value>SympActUserID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("SYMP")</DataLocation>
<DefaultData>PathFormSympDefaultData</DefaultData>
<IdLocation>{%%PARENT}("SYMP")</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathFormI("SYMP")</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathFormSympS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
