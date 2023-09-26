/// 名称: DHCMA.CPW.BT.PathTCMExt
/// 描述: 方剂明细
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.BT.PathTCMExt Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.BT.PathTCM [ Cardinality = parent, Inverse = ChildExt ];

/// 医嘱项ID 
Property BTOrdMastID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 类型（君药、臣药、佐药、使药）
Property BTTypeDr As DHCMA.Util.BT.Dictionary [ Required ];

/// 剂量
Property DoseQty As %Float;

/// 单位 	CT_Unit
Property CTUnit As %String(TRUNCATE = 1);

/// 是否备用
Property SPriority As %Boolean;

/// 医生站中草药备注 $g(^DHCDocConfig("CNMedItemPhSpecInstr"))
Property ArcResume As %String(TRUNCATE = 1);

Index IdxofOrdMastID On (BTOrdMastID, Parref) [ Unique ];

Index IdxofTypeDr On BTTypeDr;

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-26
/// Description:  根据ID取中药方剂扩展字典信息
/// Table：       DHCMA.CPW.BT.PathTCMExt
/// Input：       aId :  DHCMA.CPW.BT.PathTCMExt.ID
/// Return：      返回obj
/// zw ##class(DHCMA.CPW.BT.PathTCMExt).GetObjById("8||3")
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathTCMExt
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCMA.CPW.BT.PathTCMExt).%ExistsId(aId) return
	set obj=##Class(DHCMA.CPW.BT.PathTCMExt).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-26
/// Description:  删除中药方剂扩展扩展项
/// Table：       DHCMA.CPW.BT.PathTCMExt
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathTCMExt).DeleteById("2||2")
ClassMethod DeleteById(aId)
{
	new (aId)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.BT.PathTCMExt")
	Quit:Flg'=1 -777
	
	set sc = ##class(DHCMA.CPW.BT.PathTCMExt).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-26
/// Description:  更新时判断扩展项是否重复
/// Table：       DHCMA.CPW.BT.PathTCMExt
/// Input：       aDesc：    扩展项名
/// Return：      重复：1，不重复：0
/// w ##class(DHCMA.CPW.BT.PathTCMExt).CheckBTSDesc("当归[17-2]","2")
ClassMethod CheckBTSDesc(aOrdMastID As %String, aParref As %String) As %String
{
	New (aOrdMastID,aParref)
	Set return=0
	Quit:(aOrdMastID="")||(aParref="") return
	
	If ($d(^DHCMA.CPW.BT.PathTCMI("EXT","IdxofOrdMastID"," "_$zcvt(aOrdMastID,"U")))) {
		Set ChildSub=$o(^DHCMA.CPW.BT.PathTCMI("EXT","IdxofOrdMastID"," "_$zcvt(aOrdMastID,"U"),aParref,0))
		Set:ChildSub'="" return=1
	}else{
		set return=0
	}
		
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-26
/// Description:  更新中药方剂扩展项
/// Table：       DHCMA.CPW.BT.PathTCMExt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码  （=0 参数错误）
/// w ##class(DHCMA.CPW.BT.PathTCMExt).Update("2^^03^0","")
ClassMethod Update(aInStr As %String, aSeparete As %String = "^") As %String
{
	new (aInStr,aSeparete)
	set return=0
	quit:aInStr="" return
	
	set:$g(aSeparete)="" aSeparete="^"
	set ParRef       = $p(aInStr,aSeparete,1)
	set ChildSub     = $p(aInStr,aSeparete,2)
	set OrdMastID    = $p(aInStr,aSeparete,3)
	set TypeDr       = $p(aInStr,aSeparete,4)
	set DoseQty      = $p(aInStr,aSeparete,5)
	set CTUnit       = $p(aInStr,aSeparete,6)
	set SPriority    = $p(aInStr,aSeparete,7)
	Set ArcResume	 = $p(aInStr,aSeparete,8)
	quit:(ParRef="")||(OrdMastID="")||(TypeDr="") return
	
	set objParref=##class(DHCMA.CPW.BT.PathTCM).GetObjById(ParRef)
	quit:'$IsObject(objParref) return
	
	set objType=##class(DHCMA.Util.BT.Dictionary).GetObjById(TypeDr)
	quit:'$Isobject(objType) return
	
	set tChildSub=$o(^DHCMA.CPW.BT.PathTCMI("EXT","IdxofOrdMastID"," "_$zcvt(OrdMastID,"U"),ParRef,0))
	Quit:(tChildSub'="")&(ChildSub'=tChildSub) -2	    //根据代码找ID,如果id对不上号 返回-2
	
	if ChildSub="" {
		set obj=##class(DHCMA.CPW.BT.PathTCMExt).%New()
	}else{
		set ID=ParRef_"||"_ChildSub
		set obj=##class(DHCMA.CPW.BT.PathTCMExt).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	set obj.Parref       = objParref
	set obj.BTOrdMastID  = OrdMastID
	set obj.BTTypeDr     = objType
	set obj.DoseQty      = DoseQty
	set obj.CTUnit       = CTUnit
	set obj.SPriority    = SPriority
	Set obj.ArcResume	 = ArcResume
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
<Data name="PathTCMExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTTypeDr</Value>
</Value>
<Value name="3">
<Value>BTOrdMastID</Value>
</Value>
<Value name="4">
<Value>DoseQty</Value>
</Value>
<Value name="5">
<Value>CTUnit</Value>
</Value>
<Value name="6">
<Value>SPriority</Value>
</Value>
<Value name="7">
<Value>ArcResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EXT")</DataLocation>
<DefaultData>PathTCMExtDefaultData</DefaultData>
<IdLocation>{%%PARENT}("EXT")</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathTCMI("EXT")</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathTCMExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
