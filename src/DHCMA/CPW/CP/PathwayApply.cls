/// 名称: DHCMA.CPW.CP.PathwayApply
/// 描述: 临床路径 申请记录
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.CP.PathwayApply Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.CP.Pathway [ Cardinality = parent, Inverse = ChildApply ];

/// 原因类型（未入径原因NotIn、出径原因Out、再入径原因...）
Property CPTypeDr As DHCMA.Util.BT.Dictionary [ Required ];

/// 申请原因
Property CPReasonDr As DHCMA.CPW.BT.PathVariat;

/// 申请备注 自定义
Property CPApplyTxt As %String(MAXLEN = 500, TRUNCATE = 1);

/// 申请标志（有效1、无效0）
Property CPIsActive As %Boolean;

/// 申请科室ID（指向DHCMA.Util.EP.Location.OID）
Property CPLocID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 申请病区ID（指向DHCMA.Util.EP.Location.OID）
Property CPWardID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 处置日期
Property CPActDate As %Date;

/// 处置时间
Property CPActTime As %Time;

/// 处置人ID（DHCMA.Util.EP.SSUser.OID）
Property CPActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 审核标志（同意1、拒绝0）
Property CPIsVerify As %Boolean;

/// 审核意见/拒绝原因
Property CPVerNote As %String(MAXLEN = 500, TRUNCATE = 1);

/// 审核日期
Property CPVerDate As %Date;

/// 审核时间
Property CPVerTime As %Time;

/// 审核人ID（指向DHCMA.Util.EP.SSUser.OID）
Property CPVerUserID As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxofParRef On (Parref, CPTypeDr);

Index IdxofActDate On (CPTypeDr, CPActDate, Parref);

Index IdxofVerDate On (CPTypeDr, CPVerDate, Parref);

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-13
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.CP.PathwayApply
/// Input：       aId : DHCMA.CPW.CP.PathwayApply
/// Return：      返回obj
/// w ##class(DHCMA.CPW.CP.PathwayApply).GetObjById(1||1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.CP.PathwayApply
{
	New (aId)
	Quit:'##class(DHCMA.CPW.CP.PathwayApply).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.CP.PathwayApply).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-13
/// Description:  更新数据
/// Table：       DHCMA.CPW.CP.PathwayApply
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayApply).Update(1)
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set Parref=$p(aInputStr,aSeparete,1)
	Set ChildID=$p(aInputStr,aSeparete,2)
	Set TypeCode=$p(aInputStr,aSeparete,3)
	Set ReasonID=$p(aInputStr,aSeparete,4)
	Set ApplyTxt=$p(aInputStr,aSeparete,5)
	Set ActUserID=$p(aInputStr,aSeparete,6)
	Set LocID=$p(aInputStr,aSeparete,7)
	Set WardID=$p(aInputStr,aSeparete,8)
	Set IsActive=1
	Set ActDate=+$H
	Set ActTime=$p($H,",",2)
	
	Set objParref=##class(DHCMA.CPW.CP.Pathway).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objDicType=##class(DHCMA.Util.BT.DicType).GetObjByCode("CPWVariatType")
	Quit:'$IsObject(objDicType) return
	Set DicTypeID=objDicType.%Id()
	Set DicID=$o(^DHCMA.Util.BT.DictionaryI("IdxofTypeDrCode",DicTypeID," "_$zcvt(TypeCode,"U"),""))
	Set objType=##class(DHCMA.Util.BT.Dictionary).GetObjById(DicID)
	Quit:'$IsObject(objType) return
	Set objReason=##class(DHCMA.CPW.BT.PathVariat).GetObjById(ReasonID)
	Quit:'$IsObject(objReason) return
	
	If ChildID="" {
		Set obj=##class(DHCMA.CPW.CP.PathwayApply).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.CP.PathwayApply).%OpenId(Parref_"||"_ChildID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=objParref
	Set obj.CPTypeDr=objType
	Set obj.CPReasonDr=objReason
	Set obj.CPApplyTxt=ApplyTxt
	Set obj.CPIsActive=IsActive
	Set obj.CPActDate=ActDate
	Set obj.CPActTime=ActTime
	Set obj.CPActUserID=ActUserID
	Set obj.CPLocID=LocID
	Set obj.CPWardID=WardID
	
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-13
/// Description:  出入径审核
/// Table：       DHCMA.CPW.CP.PathwayApply
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayApply).Update(1)
ClassMethod Check(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set Parref=$p(aInputStr,aSeparete,1)
	Set ChildID=$p(aInputStr,aSeparete,2)
	Quit:ChildID="" return
	Set IsVerify=$p(aInputStr,aSeparete,3)
	Set VerNote=$p(aInputStr,aSeparete,4)
	Set UserID=$p(aInputStr,aSeparete,5)
	
	Set VerDate=+$H
	Set VerTime=$p($H,",",2)
	Set IsActive=1
	Set ActDate=+$H
	Set ActTime=$p($H,",",2)
	
	Set objParref=##class(DHCMA.CPW.CP.Pathway).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	//Set objType=##class(DHCMA.Util.BTS.DictionarySrv).GetObjByCode("",TypeCode)
	//Quit:'$IsObject(objType) return
	//Set objReason=##class(DHCMA.CPW.BT.PathVariat).GetObjById(ReasonID)
	//Quit:'$IsObject(objReason) return
	
	Set obj=##class(DHCMA.CPW.CP.PathwayApply).%OpenId(Parref_"||"_ChildID)
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=objParref
	Set obj.CPIsVerify=IsVerify
	Set obj.CPVerNote=VerNote
	Set obj.CPVerDate=VerDate
	Set obj.CPVerTime=VerTime
	Set obj.CPVerUserID=UserID
	
	Set obj.CPIsActive=IsActive
	//Set obj.CPActDate=ActDate
	//Set obj.CPActTime=ActTime
	//Set obj.CPActUserID=UserID
	
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-13
/// Description:  作废数据
/// Table：       DHCMA.CPW.CP.PathwayApply
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayApply).Invalid(1||1)
ClassMethod Invalid(aID As %String, aUserID As %String) As %String
{
	New (aID,aUserID)
	Set return=""
	Quit:aID="" return
	
	Set obj=##class(DHCMA.CPW.CP.PathwayApply).GetObjById(aID)
	Quit:'$IsObject(obj) return
	
	Set obj.CPIsActive=0
	Set obj.CPActDate=+$H
	Set obj.CPActTime=$p($H,",",2)
	Set obj.CPActUserID=aUserID
	
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
<Data name="PathwayApplyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPTypeDr</Value>
</Value>
<Value name="3">
<Value>CPReasonDr</Value>
</Value>
<Value name="4">
<Value>CPApplyTxt</Value>
</Value>
<Value name="5">
<Value>CPIsActive</Value>
</Value>
<Value name="6">
<Value>CPLocID</Value>
</Value>
<Value name="7">
<Value>CPWardID</Value>
</Value>
<Value name="8">
<Value>CPActDate</Value>
</Value>
<Value name="9">
<Value>CPActTime</Value>
</Value>
<Value name="10">
<Value>CPActUserID</Value>
</Value>
<Value name="11">
<Value>CPIsVerify</Value>
</Value>
<Value name="12">
<Value>CPVerNote</Value>
</Value>
<Value name="13">
<Value>CPVerDate</Value>
</Value>
<Value name="14">
<Value>CPVerTime</Value>
</Value>
<Value name="15">
<Value>CPVerUserID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("APPLY")</DataLocation>
<DefaultData>PathwayVarDefaultData</DefaultData>
<IdLocation>{%%PARENT}("APPLY")</IdLocation>
<IndexLocation>^DHCMA.CPW.CP.PathwayI("APPLY")</IndexLocation>
<StreamLocation>^DHCMA.CPW.CP.PathwayApplyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
