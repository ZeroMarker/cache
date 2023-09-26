/// 接口字典对照数据
/// 创建者：zhufei
/// 创建日期：2015-02-25
Class DHCMed.SMD.IOMapping Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 对照类型
Property Category As %String(TRUNCATE = 1);

/// 源值
Property SrcObjectID As %String(TRUNCATE = 1);

/// 源值描述
Property SrcDescription As %String(TRUNCATE = 1);

/// 目标值
Property Target As %String(TRUNCATE = 1);

/// 目标值描述
Property TargetDesc As %String(TRUNCATE = 1);

/// 备注
Property ResumeText As %String(TRUNCATE = 1);

/// 对照类别索引
Index IndexCategory On Category;

/// 对照类别和源ID索引
Index IndexCategorySrcID On (Category, SrcObjectID) [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2015-02-25
/// Description:  取接口字典对照
/// Table：       DHCMed.SMD.IOMapping
/// Input：       DHCMed.SMD.IOMapping.ID
/// Return：      返回obj
/// w ##class(DHCMed.SMD.IOMapping).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.SMD.IOMapping
{
	New (aId)
	Set obj=##Class(DHCMed.SMD.IOMapping).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-02-25
/// Description:  取接口字典对照
/// Table：       DHCMed.SMD.IOMapping
/// Input：       Category       字典分类
///               SrcObjectID    源数据ID
/// Return：      返回String
/// w ##class(DHCMed.SMD.IOMapping).GetMappingData("","")
ClassMethod GetMappingData(Category As %String, SrcObjectID As %String) As %String
{
	New (Category,SrcObjectID)
	Set return=""
	Quit:(Category="")||(SrcObjectID="") return
	
	Set SrcObjectID=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcObjectID)
	Set ID=$o(^DHCMed.SMD.IOMappingI("IndexCategorySrcID"," "_$ZCVT(Category,"U")," "_$ZCVT(SrcObjectID,"U"),""))
	Quit:ID="" return
	
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-02-25
/// Description:  更新接口字典对照
/// Table：       DHCMed.SMD.IOMapping
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.SMD.IOMapping).Update("CombinedMed^5^四联以上^5^四联以上^^","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	Set Category=$p(aInput,aSeparate,2)
	Set SrcID=$p(aInput,aSeparate,3)
	Set SrcID=$tr(SrcID," ","")
	
	If ((Category'="")&&(SrcID'="")) {
		Set tID=$o(^DHCMed.SMD.IOMappingI("IndexCategorySrcID"," "_$ZCVT(Category,"U")," "_$ZCVT(SrcID,"U"),""))
		Quit:tID'=ID -2
	}
	
	If (ID="") {
		Set obj=##class(DHCMed.SMD.IOMapping).%New()
	} Else {
		Set obj=##class(DHCMed.SMD.IOMapping).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Category=$p(aInput,aSeparate,2)
	Set obj.SrcObjectID=SrcID
	Set obj.SrcDescription=$p(aInput,aSeparate,4)
	Set obj.Target=$p(aInput,aSeparate,5)
	Set obj.TargetDesc=$p(aInput,aSeparate,6)
	Set obj.ResumeText=$p(aInput,aSeparate,7)
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
/// CreatDate：   2015-02-25
/// Description:  删除接口字典对照
/// Table：       DHCMed.SMD.IOMapping
/// Input：       DHCMed.SMD.IOMapping.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.SMD.IOMapping).%DeleteId(+aId)
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
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Category</Value>
</Value>
<Value name="3">
<Value>SrcObjectID</Value>
</Value>
<Value name="4">
<Value>SrcDescription</Value>
</Value>
<Value name="5">
<Value>Target</Value>
</Value>
<Value name="6">
<Value>TargetDesc</Value>
</Value>
<Value name="7">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SMD.IOMappingD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SMD.IOMappingI</IdLocation>
<IndexLocation>^DHCMed.SMD.IOMappingI</IndexLocation>
<StreamLocation>^DHCMed.SMD.IOMappingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
