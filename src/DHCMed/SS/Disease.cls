/// 名称 : DHCMed.SS.Disease
/// 说明 : 用于慢病、食源性疾病、重大精神疾病、食物中毒、农业中毒等各类报卡
Class DHCMed.SS.Disease Extends (%Persistent, DHCMed.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildICD As DHCMed.SS.DiseaseICD [ Cardinality = children, Inverse = Parref ];

Relationship ChildAlias As DHCMed.SS.DiseaseAlias [ Cardinality = children, Inverse = Parref ];

/// 疾病代码
Property IDCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 疾病描述
Property IDDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 疾病ICD
Property IDICD10 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 疾病分类
Property IDCateDr As DHCMed.SS.Dictionary;

/// 产品指针
Property IDProductDr As DHCMed.SS.Products;

/// 是否有效
Property IDIsActive As %Boolean;

/// 备注
Property IDResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 以疾病代码为索引
Index IndexCode On (IDProductDr, IDCode) [ Unique ];

/// Creator：     zhaoyu
/// CreatDate：   2014-11-17
/// Description:  取疾病信息
/// Table：       DHCMed.SS.Disease
/// Input：       Id : DHCMed.SS.Disease.ID
/// Return：      返回Object
/// w ##class(DHCMed.SS.Disease).GetObjById("")
ClassMethod GetObjById(aId As %String) As DHCMed.SS.Disease
{
	new (aId)
	quit:'##class(DHCMed.SS.Disease).%ExistsId(aId) ""
	set obj=##Class(DHCMed.SS.Disease).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-17
/// Description:  更新疾病信息
/// Table：       DHCMed.SS.Disease
/// Input：       InputStr ：
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.SS.Disease).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set Code=$p(aInputStr,aSeparate,2)
	Set Desc=$p(aInputStr,aSeparate,3)
	Set ICD10=$p(aInputStr,aSeparate,4)
	Set CateDr=$p(aInputStr,aSeparate,5)
	Set ProductDr=$p(aInputStr,aSeparate,6)
	Set IsActive=+$p(aInputStr,aSeparate,7)
	Set Resume=$p(aInputStr,aSeparate,8)
	Quit:(Code="")||(Desc="")||(ProductDr="") return
	
	Set objProduct=##class(DHCMed.SS.Products).GetObjById(ProductDr)
	Quit:'$IsObject(objProduct) return
	
	If ID="" {
		Set ID=$o(^DHCMed.SS.DiseaseI("IndexCode",ProductDr," "_$ZCVT(Code,"U"),""))
	} Else {
		Set xID=$o(^DHCMed.SS.DiseaseI("IndexCode",ProductDr," "_$ZCVT(Code,"U"),""))
		Quit:xID'=ID return
	}
	
	If (ID="") {
		Set obj=##class(DHCMed.SS.Disease).%New()
	} Else {
		Set obj=##class(DHCMed.SS.Disease).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IDCode=Code
	Set obj.IDDesc=Desc
	Set obj.IDICD10=ICD10
	Set obj.IDCateDr=##class(DHCMed.SS.Dictionary).GetObjById(CateDr)
	Set obj.IDProductDr=objProduct
	Set obj.IDIsActive=IsActive
	Set obj.IDResume=Resume
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-17
/// Description:  删除疾病信息
/// Table：       DHCMed.SS.Disease
/// Input：       Id : DHCMed.SS.Disease.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.SS.Disease).DeleteById("")
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCMed.SS.Disease).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator     : zhaoyu
/// CreatDate   : 2014-11-17
/// Description : 检查疾病代码是否重复
/// Table       : DHCMed.FBD.SignDic
/// Input       : ProID : 产品ID
///             : DisCode : 疾病代码
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.SS.Disease).CheckDiseaseCode("")
ClassMethod CheckDiseaseCode(aProID As %String, aDisCode As %String) As %String
{
	New (aProID,aDisCode)
	Set return=+$o(^DHCMed.SS.DiseaseI("IndexCode",aProID," "_$ZCVT(aDisCode,"U"),""))
	Quit return
}

/// Creator:      pylian
/// CreatDate:    2018-10-17
/// Description:  根据obj取疾病描述信息
/// Table：       DHCMed.SS.Disease
/// Input：       obj
/// Return：      返回String
/// w ##class(DHCMed.SS.Disease).GetDiseaseByObj()
ClassMethod GetDiseaseByObj(obj As DHCMed.SS.Disease, Languages As %String = "") As %String
{
	new (obj,Languages)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_obj.IDCode_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Disease","IDDesc",Languages,obj.IDDesc)
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDCode</Value>
</Value>
<Value name="3">
<Value>IDDesc</Value>
</Value>
<Value name="4">
<Value>IDICD10</Value>
</Value>
<Value name="5">
<Value>IDCateDr</Value>
</Value>
<Value name="6">
<Value>IDProductDr</Value>
</Value>
<Value name="7">
<Value>IDIsActive</Value>
</Value>
<Value name="8">
<Value>IDResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SS.DiseaseD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SS.DiseaseD</IdLocation>
<IndexLocation>^DHCMed.SS.DiseaseI</IndexLocation>
<StreamLocation>^DHCMed.SS.DiseaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
