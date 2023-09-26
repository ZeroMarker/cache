Class DHCWMR.MQ.DataItems Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 数据来源
Property DataSource As %String(MAXLEN = 100, TRUNCATE = 1);

/// 数据单元代码
Property ElementCode As %String(MAXLEN = 500, TRUNCATE = 1);

/// 数据单元名称
Property ElementDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 数据类型(TEXT-字符串、NUMBER-数字、DATE-日期、TIME-时间)
Property DataType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 项目名称
Property MRItemDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 大类
Property MRItemCat As DHCWMR.MQ.DataCat;

/// 子类
Property MRItemSubCat As DHCWMR.MQ.DataSubCat;

/// 默认列显示顺序
Property MRItemCol As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否建索引
Property MRIsIndex As %Boolean;

/// 编目项目
Property FPltemDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property IsActive As %Boolean;

/// 备注
Property Resume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexDataSrcEleCode On (DataSource, ElementCode) [ Unique ];

Index IndexDataSrcItemDesc On (DataSource, MRItemDesc);

Index IndexDataSrcCatDesc On (DataSource, MRItemCat, MRItemDesc);

Index IndexDataSrcSubCatDesc On (DataSource, MRItemSubCat, MRItemDesc);

Index IndexItemSubCat On MRItemSubCat;

/// Creator：     zhufei
/// CreatDate：   2014-12-07
/// Description:  取首页数据项
/// Table：       DHCWMR.MQ.DataItems
/// Input：       ID : DHCWMR.MQ.DataItems.ID
/// Return：      返回obj
/// w ##class(DHCWMR.MQ.DataItems).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.MQ.DataItems
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.MQ.DataItems).%ExistsId(aId) return
	set obj=##Class(DHCWMR.MQ.DataItems).%OpenId(aId)
	if $IsObject(obj){
		set obj.FPltemDesc=..GetFPItemDesc(aId)
		set:obj.MRItemCat="" obj.MRItemCat="其它"
	}
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-07
/// Description:  更新首页数据项
/// Table：       DHCWMR.MQ.DataItems
/// Input：       InputStr ：首页数据项内容
///               Separate : 分隔符（不允许带"^"）
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.DataItems).Update("^EPR^HDSD00.11.851^登记号^TEXT^医疗付费方式描述^患者信息^医疗付费方式^^1^1^登记号","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:aInputStr="" return
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set DataSource=$p(aInputStr,aSeparate,2)
	Set ElementCode=$p(aInputStr,aSeparate,3)
	Set ElementDesc=$p(aInputStr,aSeparate,4)
	Set DataType=$p(aInputStr,aSeparate,5)
	Set MRItemDesc=$p(aInputStr,aSeparate,6)
	Set MRItemCat=$p(aInputStr,aSeparate,7)
	Set MRItemSubCat=$p(aInputStr,aSeparate,8)
	Set MRItemCol=$p(aInputStr,aSeparate,9)
	Set MRIsIndex=+$p(aInputStr,aSeparate,10)
	Set IsActive=+$p(aInputStr,aSeparate,11)
	Set Resume=$p(aInputStr,aSeparate,12)

	Quit:(DataSource="")||(ElementCode="")||(ElementDesc="")||(DataType="")||(MRItemCat="")||(MRItemSubCat="") return
	
	//存储大类和子类
	Set ItemCatID= ##class(DHCWMR.MQ.DataCat).Update("^"_MRItemCat,"^")
	Quit:+ItemCatID<1 return

	Set ItemSubCatID= ##class(DHCWMR.MQ.DataSubCat).Update(ItemCatID_"^^"_MRItemSubCat,"^")
	Quit:+ItemSubCatID<1 return

	Set objItemCat=##class(DHCWMR.MQ.DataCat).GetObjById(ItemCatID)
	Set objItemSubCat=##class(DHCWMR.MQ.DataSubCat).GetObjById(ItemSubCatID)
	
	Set:MRItemDesc="" MRItemDesc=ElementDesc
	Set:(ElementDesc["停用")||(ElementDesc["作废") IsActive=0
	Set:(ElementDesc["停用")||(ElementDesc["作废") IsActive=0
	
	If $l(ElementCode,"^")>1 {
		Set xElementCode=$p(ElementCode,"^",$l(ElementCode,"^"))
		Set ElementCode=xElementCode
	}
	Quit:ElementCode="" return
	
	//fix bug 108607 修改信息一条记录提示单元重复，不允许修改
	//在前台界面选中一条记录修改时不提示重复，当新增一条数据来源，首页单元相同的记录时视为修改不是增加
	If ID="" {
		Set ID=$o(^DHCWMR.MQ.DataItemsI("IndexDataSrcEleCode"," "_$zcvt(DataSource,"U")," "_$zcvt(ElementCode,"U"),0))
	} Else {
		Set xID=$o(^DHCWMR.MQ.DataItemsI("IndexDataSrcEleCode"," "_$zcvt(DataSource,"U")," "_$zcvt(ElementCode,"U"),0))
		Set return=-100
		Quit:(xID'="")&&(xID'=ID) return
	}
	If (ID="") {
		Set obj=##class(DHCWMR.MQ.DataItems).%New()
	} Else {
		Set obj=##class(DHCWMR.MQ.DataItems).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.DataSource=DataSource
	Set obj.ElementCode=ElementCode
	Set obj.ElementDesc=ElementDesc
	Set obj.DataType=DataType
	Set obj.MRItemDesc=MRItemDesc
	Set obj.MRItemCat=objItemCat
	Set obj.MRItemSubCat=objItemSubCat
	Set obj.MRItemCol=MRItemCol
	Set obj.MRIsIndex=MRIsIndex
	Set obj.FPltemDesc=""
	Set obj.IsActive=IsActive
	Set obj.Resume=Resume
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1_"^"_sc
	} Else {
		Set return=obj.%Id()
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-07
/// Description:  删除首页数据项
/// Table：       DHCWMR.MQ.DataItems
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.DataItems).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MQ.DataItems).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// w ##class(DHCWMR.MQ.DataItems).GetFPItemDesc()
ClassMethod GetFPItemDesc(aMRItemID As %String) As %String
{
	New (aMRItemID)
	Set return=""
	Quit:aMRItemID="" return
	
	Set FPItemID=$o(^DHCWMR.FP.DataItemI("DIL","IndexItemDr",aMRItemID,0))
	Quit:FPItemID="" return
 	Set objFPItem=##class(DHCWMR.FP.DataItem).GetObjById(FPItemID)
 	Quit:'$IsObject(objFPItem) return
	Set return=objFPItem.DIDesc
	Quit return
}

Query QueryAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,DataSource,DataType,ElementCode,ElementDesc,FPltemDesc,IsActive,MRIsIndex,MRItemCat,MRItemCol,MRItemDesc,Resume FROM DataItems
 ORDER BY %ID
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataSource</Value>
</Value>
<Value name="3">
<Value>ElementCode</Value>
</Value>
<Value name="4">
<Value>ElementDesc</Value>
</Value>
<Value name="5">
<Value>DataType</Value>
</Value>
<Value name="6">
<Value>MRItemDesc</Value>
</Value>
<Value name="7">
<Value>MRItemCat</Value>
</Value>
<Value name="8">
<Value>MRItemCol</Value>
</Value>
<Value name="9">
<Value>MRIsIndex</Value>
</Value>
<Value name="10">
<Value>FPltemDesc</Value>
</Value>
<Value name="11">
<Value>IsActive</Value>
</Value>
<Value name="12">
<Value>Resume</Value>
</Value>
<Value name="13">
<Value>MRItemSubCat</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MQ.DataItemsD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.MQ.DataItemsD</IdLocation>
<IndexLocation>^DHCWMR.MQ.DataItemsI</IndexLocation>
<StreamLocation>^DHCWMR.MQ.DataItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
