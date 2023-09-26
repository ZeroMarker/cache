/// 名称: DHCHAI.IR.PDCAModExt
/// 描述: PDCA扩展模板定义
/// 编写者：ShenC
/// 编写日期: 2022-07-21
Class DHCHAI.IR.PDCAModExt Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.PDCAMod [ Cardinality = parent, Inverse = ChildExt ];

/// 代码(六位编码)
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目分类
Property BTExtType As DHCHAI.BT.Dictionary;

/// 数据格式（S列表、T文本、N0整数、N1小数、B1是/否、B2有/无、E富文本框）
Property BTDatType As DHCHAI.BT.Dictionary;

/// 关联字典
Property BTDicType As DHCHAI.BT.DicType;

/// 该扩展项目是否必填
Property BTIsRequired As %Boolean;

/// 代码索引
Index IndexCode On (Parref, BTCode As Exact);

/// 分类索引
Index IndexType On (Parref, BTExtType As Exact);

/// Creator：     ShenC
/// CreatDate：   2022-09-07
/// Description:  根据Code取PDCA项目扩展项目定义
/// Table：       DHCHAI.IR.PDCAModExt
/// Input：       aId : DHCHAI.IR.PDCAModExt.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.PDCAModExt).GetOExtIDByCode(4,"000101")
ClassMethod GetOExtIDByCode(aRegID As %String, aCode As %String) As DHCHAI.IR.PDCAModExt
{
	New (aRegID,aCode)
	Quit:(aRegID="")||(aCode="") ""
	Set ID=$o(^CT.MA.HAI.IR.PDCAModI("Ext","IndexCode",aRegID,aCode,""))
	Quit:ID="" ""
	
	Quit ID
}

/// Creator：     ShenC
/// CreatDate：   2022-07-07
/// Description:  根据ID取PDCA项目扩展项目定义
/// Table：       DHCHAI.IR.PDCAModExt
/// Input：       aId : DHCHAI.IR.PDCAModExt.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.PDCAModExt).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.PDCAModExt
{
	New (aId)
	Quit:'##class(DHCHAI.IR.PDCAModExt).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.PDCAModExt).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     ShenC
/// CreatDate：   2020-07-07
/// Description:  更新PDCA项目扩展项目定义
/// Table：       DHCHAI.IR.PDCAModExt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCAModExt).Update("1^^010200^问题聚焦-描述^1068^1066^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set Parref	   = $p(aInputStr,aSeparete,1)
	Set ChildSub   = $p(aInputStr,aSeparete,2)
	Set Code	   = $p(aInputStr,aSeparete,3)
	Set Desc	   = $p(aInputStr,aSeparete,4)
	Set ExtTypeDr  = $p(aInputStr,aSeparete,5)
	Set DatTypeDr  = $p(aInputStr,aSeparete,6)
	Set DicTypeDr  = $p(aInputStr,aSeparete,7)
	Set IsRequired   = $p(aInputStr,aSeparete,8)
	Quit:(Parref="")||(Code="")||(Desc="") return
	
	Set Code=$zcvt(Code,"U")
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set objParref=##class(DHCHAI.IR.PDCAMod).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objType=##class(DHCHAI.BT.Dictionary).GetObjById(ExtTypeDr)
	Quit:'$IsObject(objType) return
	Set objDat=##class(DHCHAI.BT.Dictionary).GetObjById(DatTypeDr)
	Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DicTypeDr)
	Set objDicType="" 
	If $IsObject(objDic) {
		Set objDicType=##class(DHCHAI.BT.DicType).GetObjByCode(objDic.BTCode)
	}
	Set tID=$o(^CT.MA.HAI.IR.PDCAModI("Ext","IndexCode",Parref,Code,0))
	Quit:(tID'="")&(ChildSub'=tID) -2
	If (ChildSub="") {
		Set obj=##class(DHCHAI.IR.PDCAModExt).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.PDCAModExt).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
   
	Set obj.Parref	    = objParref
	Set obj.BTCode	    = Code
	Set obj.BTDesc	    = Desc
	Set obj.BTExtType 	= objType
	Set obj.BTDatType 	= objDat
	Set obj.BTDicType 	= objDicType
	Set obj.BTIsRequired  = IsRequired

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

/// Creator：     ShenC
/// CreatDate：   2022-07-07
/// Description:  导入扩展项目定义
/// w ##Class(DHCHAI.IR.PDCAModExt).ImportExt("ZLGL^000203^现状分析-描述^现状分析^文件框^undefined","^")
ClassMethod ImportExt(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Type    = $p(aInputStr,aSeparate,1)		//PDCA模板
	Set Code    = $p(aInputStr,aSeparate,2)		//代码
	Set Desc    = $p(aInputStr,aSeparate,3)		//名称
	Set ExtType = $p(aInputStr,aSeparate,4)		//分类
	Set DatType = $p(aInputStr,aSeparate,5)		//格式
	Set DicType = $p(aInputStr,aSeparate,6)		//关联

	Quit:'$d(^CT.MA.HAI.IR.PDCAModI("IndexCode",Type)) return
    Set Parref =$o(^CT.MA.HAI.IR.PDCAModI("IndexCode",Type,0))
    Set ChildSub=$o(^CT.MA.HAI.IR.PDCAModI("EXT","IndexCode",Parref,Code,0))
    Set ExtTypeDr =""
    Set objExtType = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("PDCAExType",ExtType)
    Set:$IsObject(objExtType) ExtTypeDr = objExtType.%Id()
   	Set DatTypeDr =""
    Set objDatType = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("PDCADaType",DatType)
    Set:$IsObject(objDatType) DatTypeDr = objDatType.%Id()
    
    Set DicTypeDr =""
    Set objDicType = ##class(DHCHAI.BT.Dictionary).GetObjByCode("PDCADicType",DicType)
    Set:$IsObject(objDicType) DicTypeDr = objDicType.%Id()
	Set InputStr=Parref_aSeparate_ChildSub_aSeparate_Code_aSeparate_Desc_aSeparate_ExtTypeDr_aSeparate_DatTypeDr_aSeparate_DicTypeDr

	Set return=##Class(DHCHAI.IR.PDCAModExt).Update(InputStr,aSeparate)
	
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2022-07-07
/// Description:  删除PDCA项目扩展项目定义
/// Table：       DHCHAI.IR.PDCAModExt
/// Input：       aId : DHCHAI.IR.PDCAModExt.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCAModExt).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.PDCAModExt).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="PDCAModExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTExtType</Value>
</Value>
<Value name="5">
<Value>BTDatType</Value>
</Value>
<Value name="6">
<Value>BTDicType</Value>
</Value>
<Value name="7">
<Value>BTIsRequired</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Ext")</DataLocation>
<DefaultData>PDCAModExtDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Ext")</IdLocation>
<IndexLocation>^CT.MA.HAI.IR.PDCAModI("Ext")</IndexLocation>
<StreamLocation>^CT.MA.HAI.IR.PDCAModExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
