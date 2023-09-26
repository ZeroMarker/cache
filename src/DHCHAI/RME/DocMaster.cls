/// 文档主记录
Class DHCHAI.RME.DocMaster Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildDS As DHCHAI.RME.DocSection [ Cardinality = children, Inverse = Parref ];

/// 文档编号（不同数据源定义不同的文档编号格式）
Property DMDocNumber As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 就诊号（指向DHCHAI.DP.PAAdm.ID）
Property DMEpisodeDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 文档内容（字符串超长）
Property DMDocContent As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 文档标题
Property DMDocTitle As %String(MAXLEN = 100, TRUNCATE = 1);

/// 语义词库版本
Property DMVersionDr As DHCHAI.RME.Version;

/// 文档类型
Property DMDocTypeDr As DHCHAI.RME.DocType;

/// 自然语言处理结果 是否有效
Property DMIsActive As %Boolean;

/// 更新日期
Property DMUpdateDate As %Date;

/// 更新时间
Property DMUpdateTime As %Time;

Index IndexDocNumber On (DMVersionDr, DMDocNumber) [ Unique ];

Index IndexEpisodeDr On DMEpisodeDr As Exact;

/// Creator：     zhufei
/// CreatDate：   2017-08-09
/// Description:  根据DocNumber取语义分析结果
/// Table：       DHCHAI.RME.DocMaster
/// Input：       aVersionDr : DHCHAI.RME.DocMaster.DMVersionDr
///               aDocNumber : DHCHAI.RME.DocMaster.DMDocNumber
/// Return：      返回obj
/// w ##class(DHCHAI.RME.DocMaster).GetObjByDocNumber(1,"EMR||15")
ClassMethod GetObjByDocNumber(aVersionDr As %String, aDocNumber As %String) As DHCHAI.RME.DocMaster
{
	New (aVersionDr,aDocNumber)
	Set return = ""
	Quit:(aVersionDr="")||(aDocNumber="") return
	
	Set ID=$o(^DHCHAI.RME.DocMasterI("IndexDocNumber",aVersionDr," "_$zcvt(aDocNumber,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-08-09
/// Description:  根据ID取信息
/// Table：       DHCHAI.RME.DocMaster
/// Input：       aId : ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.DocMaster).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.RME.DocMaster
{
	New (aId)
	Quit:'##class(DHCHAI.RME.DocMaster).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.RME.DocMaster).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2017-08-09
/// Description:  更新信息
/// Table：       DHCHAI.RME.DocMaster
/// Input：       各属性列表 ^分隔
/// 1 ID 2 DMDocNumber 3 DMEpisodeDr 4 DMDocContent 5 DMDocTitle 6 DMVersionDr 7 DMDocTypeDr 
/// 8 DMIsActive ;9 DMUpdateDate 10 DMUpdateTime
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.DocMaster).Update("^DocType02^文档类型02","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID              = $p(aInputStr,aSeparete,1)
	Set DMDocNumber     = $p(aInputStr,aSeparete,2)
	Set DMEpisodeDr     = $p(aInputStr,aSeparete,3)
	Set DMDocContent    = $p(aInputStr,aSeparete,4)
	Set DMDocTitle      = $p(aInputStr,aSeparete,5)
	Set DMVersionDr     = $p(aInputStr,aSeparete,6)
	Set DMDocTypeDr     = $p(aInputStr,aSeparete,7)
	Set DMIsActive      = $p(aInputStr,aSeparete,8)
	Quit:(DMVersionDr="")||(DMDocNumber="") return
	
	Set objVersion=##class(DHCHAI.RME.Version).GetObjById(DMVersionDr)
	Quit:'$IsObject(objVersion) return
	Set objDocType=##class(DHCHAI.RME.DocType).GetObjById(DMDocTypeDr)
	//Quit:'$IsObject(objDocType) return
	
	// 唯一性 有空格
	Set tID=$o(^DHCHAI.RME.DocMasterI("IndexDocNumber",DMVersionDr," "_DMDocNumber,0))
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(DHCHAI.RME.DocMaster).%New()
	}Else{
		Set obj=##class(DHCHAI.RME.DocMaster).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.DMDocNumber  = DMDocNumber
	Set obj.DMEpisodeDr  = DMEpisodeDr
	Set obj.DMDocContent = DMDocContent
	Set obj.DMDocTitle   = DMDocTitle
	Set obj.DMVersionDr  = objVersion
	Set obj.DMDocTypeDr  = objDocType
	Set obj.DMIsActive   = DMIsActive
	Set obj.DMUpdateDate =+$h
	Set obj.DMUpdateTime = $p($h,",",2)
	
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

/// Creator：     zhufei
/// CreatDate：   2017-10-13
/// Description:  清空文档段落
/// Table：       DHCHAI.RME.DocSection
/// Input：       aId : DHCHAI.RME.DocMaster.ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.DocMaster).ClearSection()
ClassMethod ClearSection(aMasterID As %String) As %String
{
	New (aMasterID)
	Set return=0
	Quit:aMasterID="" return
	
	Set xSub=0
	For {
		Set xSub=$o(^DHCHAI.RME.DocMasterD(aMasterID,"DS",xSub))
		Quit:xSub=""
		Set flg=##class(DHCHAI.RME.DocSection).DeleteById(aMasterID_"||"_xSub)
	}
	Set return=1
	Quit return
}

Storage Default
{
<Data name="DocMasterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DMDocNumber</Value>
</Value>
<Value name="3">
<Value>DMEpisodeDr</Value>
</Value>
<Value name="4">
<Value>DMDocContent</Value>
</Value>
<Value name="5">
<Value>DMDocTitle</Value>
</Value>
<Value name="6">
<Value>DMVersionDr</Value>
</Value>
<Value name="7">
<Value>DMDocTypeDr</Value>
</Value>
<Value name="8">
<Value>DMIsActive</Value>
</Value>
<Value name="9">
<Value>DMUpdateDate</Value>
</Value>
<Value name="10">
<Value>DMUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.RME.DocMasterD</DataLocation>
<DefaultData>DocMasterDefaultData</DefaultData>
<IdLocation>^DHCHAI.RME.DocMasterD</IdLocation>
<IndexLocation>^DHCHAI.RME.DocMasterI</IndexLocation>
<StreamLocation>^DHCHAI.RME.DocMasterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
