/// 名称: DHCMA.CPW.BT.PathComplExt
/// 描述: 合并症（并发症）扩展
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.BT.PathComplExt Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.BT.PathCompl [ Cardinality = parent, Inverse = ChildExt ];

/// 扩展项名称
Property BTExtDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

Index IdxofExtDesc On BTExtDesc [ Unique ];

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-23
/// Description:  根据ID取合并症（并发症）扩展项
/// Table：       DHCMA.CPW.BT.PathComplExt
/// Input：       ID:    DHCMA.CPW.BT.PathComplExt.ID
///               aSeparete: 指定的分隔符
/// Return：      返回Object
/// zw ##class(DHCMA.CPW.BT.PathComplExt).GetObjById("6||4")
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathComplExt
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCMA.CPW.BT.PathComplExt).%ExistsId(aId) return
	set obj=##Class(DHCMA.CPW.BT.PathComplExt).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-23
/// Description:  更新合并症（并发症）扩展
/// Table：       DHCMA.CPW.BT.PathComplExt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码  （=0 参数错误）
/// w ##class(DHCMA.CPW.BT.PathComplExt).Update("6^^t1","")
ClassMethod Update(aInStr As %String, aSeparete As %String = "^") As %String
{
	new (aInStr,aSeparete)
	set return=0
	quit:aInStr="" return
	set:$g(aSeparete)="" aSeparete="^"
	set ParRef       = $p(aInStr,aSeparete,1)
	set ChildSub     = $p(aInStr,aSeparete,2)
	set BTExtDesc    = $p(aInStr,aSeparete,3)
	
	quit:(ParRef="")||(BTExtDesc="") return
	
	if ChildSub="" {
		Set Parref=$o(^DHCMA.CPW.BT.PathComplI("EXT","IdxofExtDesc"," "_$zcvt(BTExtDesc,"U"),0))
		If Parref'="" {
			Set ChildSub=$o(^DHCMA.CPW.BT.PathComplI("EXT","IdxofExtDesc"," "_$zcvt(BTExtDesc,"U"),Parref,0))
			
		}
	}
	
	if ChildSub="" {
		set obj=##class(DHCMA.CPW.BT.PathComplExt).%New()
	}else{
		set ID=ParRef_"||"_ChildSub
		set obj=##class(DHCMA.CPW.BT.PathComplExt).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.Parref       = ##class(DHCMA.CPW.BT.PathCompl).GetObjById(ParRef)
	set obj.BTExtDesc    = BTExtDesc
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

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-23
/// Description:  删除合并症（并发症）扩展项
/// Table：       DHCMA.CPW.BT.PathComplExt
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathComplExt).DeleteById("6||3")
ClassMethod DeleteById(aId)
{
	new (aId)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.BT.PathComplExt")
	Quit:Flg'=1 -777
	
	set sc = ##class(DHCMA.CPW.BT.PathComplExt).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-23
/// Description:  更新时判断扩展项是否重复
/// Table：       DHCMA.CPW.BT.PathComplExt
/// Input：       aDesc：    扩展项名
/// Return：      重复：1，不重复：0
/// w ##class(DHCMA.CPW.BT.PathComplExt).CheckBTSDesc("t3","")
ClassMethod CheckBTSDesc(aDesc As %String, aSubID As %String) As %String
{
	New (aDesc,aSubID)
	Set return=""
	Quit:(aDesc="") return
	
	If ($d(^DHCMA.CPW.BT.PathComplI("EXT","IdxofExtDesc"," "_$zcvt(aDesc,"U")))) {
		Set return=1
		Set Parref=$o(^DHCMA.CPW.BT.PathComplI("EXT","IdxofExtDesc"," "_$zcvt(aDesc,"U"),0))
		Set ChildSub=$o(^DHCMA.CPW.BT.PathComplI("EXT","IdxofExtDesc"," "_$zcvt(aDesc,"U"),Parref,0))
		Set SubID=Parref_"||"_ChildSub
		Set:(aSubID'="")&&(aSubID=SubID) return=0
	}else{
		set return=0
	}
	
	Quit return
}

Storage Default
{
<Data name="PathComplExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTExtDesc</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EXT")</DataLocation>
<DefaultData>PathComplExtDefaultData</DefaultData>
<IdLocation>{%%PARENT}("EXT")</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathComplI("EXT")</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathComplExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
