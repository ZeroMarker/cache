/// 名称: DHCMed.EPD.ESurTypeExt
/// 描述: 流调扩展项目定义
/// 编写者：chenrui
/// 编写日期: 2021-07-16
Class DHCMed.EPD.ESurTypeExt Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMed.EPD.ESurType [ Cardinality = parent, Inverse = ChildExt ];

/// 代码(六位编码)
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目分类
Property BTExtType As DHCMed.SS.Dictionary;

/// 数据格式（S列表、T文本、N0整数、N1小数、B1是/否、B2有/无）
Property BTDatType As DHCMed.SS.Dictionary;

/// 关联字典
Property BTDicType As DHCMed.SS.Dictionary;

/// 该扩展项目是否必填
Property BTIsRequired As %Boolean;

/// 代码索引
Index IndexCode On (Parref, BTCode As Exact);

/// 分类索引
Index IndexType On (Parref, BTExtType As Exact);

/// Creator：     chenrui
/// CreatDate：   2021-07-16
/// Description:  根据ID取流调项目定义
/// Table：       DHCMed.EPD.ESurTypeExt
/// Input：       aId : DHCMed.EPD.ESurTypeExt.ID
/// Return：      返回obj
/// w ##class(DHCMed.EPD.ESurTypeExt).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.EPD.ESurTypeExt
{
	New (aId)
	Quit:'##class(DHCMed.EPD.ESurTypeExt).%ExistsId(aId) ""
	Set obj=##Class(DHCMed.EPD.ESurTypeExt).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenrui
/// CreatDate：   2021-07-16
/// Description:  更新流调项目定义
/// Table：       DHCMed.EPD.ESurTypeExt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.ESurTypeExt).Update("3^^1^1^5618^5625^5634^1")
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
	
	Set objParref=##class(DHCMed.EPD.ESurType).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objType=##class(DHCMed.SS.Dictionary).GetObjById(ExtTypeDr)
	Quit:'$IsObject(objType) return
	Set objDat=##class(DHCMed.SS.Dictionary).GetObjById(DatTypeDr)
	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DicTypeDr)
	
	Set tID=$o(^DHCMed.EPD.ESurTypeI("EXT","IndexCode",Parref,Code,0))
	Quit:(tID'="")&(ChildSub'=tID) -2
	If (ChildSub="") {
		Set obj=##class(DHCMed.EPD.ESurTypeExt).%New()
	} Else {
		Set obj=##class(DHCMed.EPD.ESurTypeExt).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
   
	Set obj.Parref	    	= objParref
	Set obj.BTCode	    	= Code
	Set obj.BTDesc	    	= Desc
	Set obj.BTExtType 		= objType
	Set obj.BTDatType 		= objDat
	Set obj.BTDicType 		= objDic
	Set obj.BTIsRequired  	= IsRequired

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

/// Creator：     chenr
/// CreatDate：   2022-08-08
/// Description:  删除配置
/// Table：       DHCMed.EPD.ESurTypeExt
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.EPD.ESurTypeExt).DeleteById("1||1")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMed.EPD.ESurTypeExt).%DeleteId(aID)
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="ESurTypeExtDefaultData">
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
<DataLocation>{%%PARENT}("ChildExt")</DataLocation>
<DefaultData>ESurTypeExtDefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.ESurTypeC("ChildExt")</IdLocation>
<IndexLocation>^DHCMed.EPD.ESurTypeExtI</IndexLocation>
<StreamLocation>^DHCMed.EPD.ESurTypeExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
