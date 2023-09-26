Class DHCMed.EPD.InfectionAlias Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIFA_Rowid, SqlTableName = InfectionAlias, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MIFAChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCMed_EPD.Infection Parent Reference
Relationship MIFAParRef As DHCMed.EPD.Infection [ Cardinality = parent, Inverse = ChildDHCMedInfectionAlias, Required, SqlFieldName = MIFA_ParRef ];

/// Child subscript
Property MIFAChildSub As %Library.Float [ InitialExpression = {$i(^DHCMed.EPDC("IF",$p(%d(0),$c(1),1),"InfAlias",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MIFA_ChildSub ];

/// MIFA_Alias
Property MIFAAlias As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MIFA_Alias ];

/// 是否是关键字(1-关键字,2-ICD10)
Property MIFAIsKeyword As %String [ SqlColumnNumber = 4, SqlFieldName = MIFA_IsKeyword ];

Index MIFAIsKeywordIndex On MIFAIsKeyword;

ClassMethod GetObjById(ID As %String) As DHCMed.EPD.InfectionAlias
{
	New (ID)
	Set obj=##Class(DHCMed.EPD.InfectionAlias).%OpenId(ID)
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
	set return=return_..MIFAParRef.%Id()_separete
	set return=return_..MIFAChildSub_separete
	set return=return_..MIFAAlias_separete
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
/// w ##class(DHCMed.EPD.InfectionAlias).Update("1^^32^HL^0","^")
ClassMethod Update(Instring As %String, separete As %String) As %String
{
	n (Instring,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	//update by zf 2014-05-23
	//原来ID指针记录在^DHCMIF下了,导致升级后旧系统用不了了
	set Parref=$p(Instring,"^",1)
	set MaxChild=+$o(^DHCMed.EPDC("IF",Parref,"InfAlias",""),-1)
	set CurrChild=+$g(^DHCMed.EPDC("IF",Parref,"InfAlias",0))
	if MaxChild>CurrChild {
		set ^DHCMed.EPDC("IF",Parref,"InfAlias",0)=MaxChild
	}
	
	s PLIST(0)=$p(Instring,"^",1)
    s ChildSub=$p(Instring,"^",3)
    s PLIST(3)=$p(Instring,"^",4)
    S PLIST(4)=$p(Instring,"^",5)
    s ParRef=$p(Instring,"^",1)
    s Alias=$p(Instring,"^",4)
    s AType=$p(Instring,"^",5)
    q:(Alias="undefined")||(Alias="")||(AType="") -1
    
    If ChildSub="" {
	    Set SubID=0,IsError=1
	    For {
			Set SubID=$o(^DHCMed.EPDC("IF",ParRef,"InfAlias",SubID))
			Quit:SubID=""
			Quit:ChildSub'=""
			
			Set xAlias=$p($g(^DHCMed.EPDC("IF",+ParRef,"InfAlias",SubID)),"^",1)
			Set xAType=$p($g(^DHCMed.EPDC("IF",+ParRef,"InfAlias",SubID)),"^",2)
			Continue:(Alias'=xAlias)||(AType'=xAType)
			// fix bug 8338 by pylian 2015-04-01 传染病字典维护-别名-添加已存在的记录，点击【保存】，提示"保存成功"
			//Set ChildSub=SubID
			If (Alias=xAlias)&&(AType=xAType) {
				Set:ChildSub'=SubID IsError=0
			}
	    }
	    Quit:IsError'=1 "-100"  //存在重名别名 
		
	} Else {
		Set SubID=0,IsError=1
	    For {
			Set SubID=$o(^DHCMed.EPDC("IF",ParRef,"InfAlias",SubID))
			Quit:SubID=""
			
			Set xAlias=$p($g(^DHCMed.EPDC("IF",+ParRef,"InfAlias",SubID)),"^",1)
			Set xAType=$p($g(^DHCMed.EPDC("IF",+ParRef,"InfAlias",SubID)),"^",2)
			If (Alias=xAlias)&&(AType=xAType) {
				Set:ChildSub'=SubID IsError=0
			}
		}
		Quit:IsError'=1 "-100"  //存在重名别名
	}
	
    If ChildSub'="" {
		&sql(update DHCMed_EPD.InfectionAlias values :PLIST() where MIFA_ParRef=:ParRef and MIFA_ChildSub=:ChildSub)
	}Else{
		&sql(insert into DHCMed_EPD.InfectionAlias values :PLIST())
	}
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod Delete(ID As %String) As %String
{
	n (ID)
	Set Parref=$p(ID,"||",1)
	Set ChildSub=$p(ID,"||",2)
	&sql(delete from DHCMed_EPD.InfectionAlias where MIFA_ParRef=:Parref AND MIFA_ChildSub=:ChildSub)
	q SQLCODE
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MIFA_Alias">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIFA_IsKeyword">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMed.EPDC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHCMed_EPD.Infection.MIF_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MIFA_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"IF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{DHCMed_EPD.Infection.MIF_RowId}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"InfAlias"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MIFA_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAlias">
<Global>^DHCMed.EPDCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMed_EPD.Infection.MIF_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MIFA_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"InfALIAS"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MIFA_Alias}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHCMed_EPD.Infection.MIF_RowId}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{MIFA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIsKeyword">
<Global>^DHCMed.EPDCi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"IF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"IsKeyword"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{MIFA_IsKeyword}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MIFA_Alias}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{DHCMed_EPD.Infection.MIF_RowId}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{MIFA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^DHCMed.EPD.InfectionAliasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
