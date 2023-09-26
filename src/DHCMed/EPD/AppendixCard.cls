Class DHCMed.EPD.AppendixCard Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MAC_Rowid, SqlTableName = AppendixCard, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MAC_Code
Property MACCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MAC_Code ];

/// MAC_Desc
Property MACDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MAC_Desc ];

/// MAC_Active
Property MACActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MAC_Active ];

/// MAC_Type
Property MACType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MAC_Type ];

/// MAC_Date
Property MACDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MAC_Date ];

/// MAC_Demo
Property MACDemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MAC_Demo ];

ClassMethod GetObjById(ID As %String) As DHCMed.EPD.AppendixCard
{
	New (ID)
	Set obj=##Class(DHCMed.EPD.AppendixCard).%OpenId(ID)
	if (obj'="")
	{
		d obj.%Close()
	}
	Quit obj
}

Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set return=return_..MACCode_separete
	set return=return_..MACDesc_separete
	set return=return_..MACActive_separete
	set return=return_..MACType_separete
	//set return=return_$s(+..MACDate>0:$zd(..MACDate,3),1:"")_separete
	set return=return_##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(..MACDate)_separete
	set return=return_..MACDemo_separete
	q return
}

/// Creator：     李阳
/// CreatDate：   2010-04-08
/// Description:  根据ID取传染病附卡信息
/// Input：       DHCMed.EPD.AppendixCard.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.EPD.AppendixCard).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// 功能：保存传染病附卡信息
/// 参数：Rowid^代码^描述^是否生效^类别^生效日期^备注
/// 返回值：生成的Rowid
/// w ##class(DHCMed.EPD.AppendixCard).Update("^01^北京市性病报告卡^Y^类别^2011-6-11^备注","^")
ClassMethod Update(arg As %String, separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	s id=$p(arg,separete,1)
	
	s MACCode=$p(arg,separete,2)
	s id = ..GetIDByCode(MACCode)
	s sMACCode=""
	
	&sql(SELECT MAC_Code INTO :sMACCode FROM DHCMed_EPD.AppendixCard WHERE MAC_Code=:MACCode)
	q:(id="")&&(sMACCode=MACCode) -1	//update by lyh 2014-01-21 代码不能重复
	
	s obj=""
	i id'=""  d
	.i ##class(DHCMed.EPD.AppendixCard).%ExistsId(id)  d
	..s obj=##class(DHCMed.EPD.AppendixCard).%OpenId(id)
	i $IsObject(obj)=0  d
	.s obj=##class(DHCMed.EPD.AppendixCard).%New()
	s obj.MACCode=$p(arg,separete,2)
	s obj.MACDesc=$p(arg,separete,3)
	s obj.MACActive=$s($p(arg,separete,4)["Y":"Y",1:"N")
	s obj.MACType=$p(arg,separete,5)
	s Date=$p(arg,separete,6)
	//s:Date["-" Date=$zdh(Date,3)
	//s:Date["/" Date=$zdh(Date,4)
	Set Date=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(Date)
	s obj.MACDate=Date	
	s obj.MACDemo=$p(arg,separete,7)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	k obj
	quit id
}

/// w ##class(DHCMed.EPD.AppendixCard).GetIDByCode("HIV")
ClassMethod GetIDByCode(aCode As %String) As %String
{
	new (aCode)
	Set return = ""
	Set aFlag  = 0
	Set xID = ""
	For{
		Set xID = $o(^DHCMed.EPDC("AC",xID))
		Quit:xID=""
		Quit:aFlag=1
		Set ACInfo = $g(^DHCMed.EPDC("AC",xID))
		Set ACCode = $p(ACInfo,"^",1)
		Continue:ACCode'=aCode
		Set aFlag = 1
		Set return = xID
	}
	Quit return
}

ClassMethod DeleteAppCards() As %String
{
	New
	Set return=-1
	
	Set $ZT="DeleteAppCardsErr"
	
	Set TimeStr=$h
	M ^DHCMed.EPDC("AC"_TimeStr)=^DHCMed.EPDC("AC")
	M ^DHCMed.EPDCi("AC"_TimeStr)=^DHCMed.EPDCi("AC")
	M ^DHCMed.EPDC("ACSUB"_TimeStr)=^DHCMed.EPDC("ACSUB")
	M ^DHCMed.EPDCi("ACSUB"_TimeStr)=^DHCMed.EPDCi("ACSUB")
	Kill ^DHCMed.EPDC("AC")
	Kill ^DHCMed.EPDCi("AC")
	Kill ^DHCMed.EPDC("ACSUB")
	Kill ^DHCMed.EPDCi("ACSUB")
	
	Set return=1
	Quit return
	
DeleteAppCardsErr
	Write "Error:"_$ZError,!
	Quit -999
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMed.EPDC("AC"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MAC_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MAC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MAC_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MAC_Demo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MAC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MAC_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCMed.EPDC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MAC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{MAC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^DHCMed.EPD.AppendixCardS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
