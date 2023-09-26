Class DHCMed.EPD.EpidemicSub Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MEPDS_Rowid, SqlTableName = EpidemicSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MEPDSChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCMed_EPD.Epidemic Parent Reference
Relationship MEPDSParRef As DHCMed.EPD.Epidemic [ Cardinality = parent, Inverse = ChildDHCMedEpidemicSub, Required, SqlFieldName = MEPDS_ParRef ];

/// Child subscript
Property MEPDSChildSub As %Library.Float [ InitialExpression = {$i(^DHCMed.EPD("EPD",$p(%d(0),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MEPDS_ChildSub ];

/// MEPDS_Value
Property MEPDSValue As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MEPDS_Value ];

/// 传染病附卡项目ID
Property MEPDSAppendixItemID As %String [ SqlColumnNumber = 3, SqlFieldName = MEPDS_AppendixItemID ];

/// add By pylian 2018-09-11 传染病附卡项目Code
Property MEPDSAppendixItem As %String [ SqlColumnNumber = 5, SqlFieldName = MEPDS_AppendixItem ];

Index MEPDSAppendixItemIndex On MEPDSAppendixItem;

Index MEPDSAppendixItemIDIndex On MEPDSAppendixItemID;

ClassMethod GetObjById(ID As %String) As DHCMed.EPD.EpidemicSub
{
	New (ID)
	Set obj=##Class(DHCMed.EPD.EpidemicSub).%OpenId(ID)
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
	set return=return_..MEPDSValue_separete
	set return=return_..MEPDSAppendixItemID_separete
	set return=return_..MEPDSAppendixItem_separete
	q return
}

/// Creator：     李阳
/// CreatDate：   2010-04-08
/// Description:  根据ID取传染病附卡信息
/// Input：       DHCMed.EPD.EpidemicSub.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.EPD.EpidemicSub).GetStringById(1)
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
/// w ##class(DHCMed.EPD.EpidemicSub).Update("","^")
ClassMethod Update(InString As %String, separete As %String) As %String
{
	n (InString,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	//update by zf 2014-05-23
	//原来ID指针记录在^DHCMEPD下了,导致升级后旧系统用不了了
	set Parref=$p(InString,separete,1)
	set MaxChild=+$o(^DHCMed.EPD("EPD",Parref,"I",""),-1)
	set CurrChild=+$g(^DHCMed.EPD("EPD",Parref,"I",0))
	if MaxChild>CurrChild {
		set ^DHCMed.EPD("EPD",Parref,"I",0)=MaxChild
	}
	
    s PLIST(0)=$p(InString,separete,1)        ;MEPDS_ParRef                           
    s ParRef=PLIST(0)
    q:ParRef="" -100
    s ChildSub=$p(InString,separete,3)        ;MEPDS_ChildSub                         
    s PLIST(4)=$p(InString,separete,4)        ;MEPDS_Value
    s PLIST(3)=$p(InString,separete,5)        ;MEPDSAppendixItemID   
    s PLIST(5)=$p(InString,separete,6)        ;MEPDSAppendixItem   
    
    i ChildSub="" d
    .&sql(Insert into DHCMed_EPD.EpidemicSub values :PLIST())
    e  d
    .&sql(update DHCMed_EPD.EpidemicSub  values :PLIST() where MEPDS_ParRef=:ParRef and MEPDS_ChildSub=:ChildSub)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod DeleteEpidemicSub(EpidemicReportID)
{
	n (EpidemicReportID)
	set childSub=""
	while 1
	{
		set childSub=$o(^DHCMed.EPD("EPD",EpidemicReportID,"I",childSub))
		quit:childSub=""
		set ret=##class(DHCMed.EPD.EpidemicSub).%DeleteId(EpidemicReportID_"||"_childSub)
	}
	quit 1
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MEPDS_AppendixItem">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MEPDS_AppendixItemID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MEPDS_Value">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCMed.EPD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCMed_EPD.Epidemic.MEPD_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MEPDS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EPD"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHCMed_EPD.Epidemic.MEPD_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MEPDS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^DHCMed.EPD.EpidemicSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
