Class DHCMed.EPD.Infection Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIF_RowId, SqlTableName = Infection, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCMedInfectionAlias As DHCMed.EPD.InfectionAlias [ Cardinality = children, Inverse = MIFAParRef ];

/// 疾病ICD
Property MIFICD As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MIF_ICD ];

/// 疾病名称
Property MIFDisease As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MIF_Disease ];

/// 类别
Property MIFKind As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MIF_Kind ];

/// 等级
Property MIFRank As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MIF_Rank ];

/// 传染病附卡
Property MIFAppendix As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MIF_Appendix ];

/// 多次患病
Property MIFMulti As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = MIF_Multi ];

/// 依赖关系
Property MIFDependence As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = MIF_Dependence ];

/// 时限要求
Property MIFTimeLimit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MIF_TimeLimit ];

/// 备注
Property MIFResume As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MIF_Resume ];

/// 最小上报年龄
Property MIFMinAge As %Integer [ SqlColumnNumber = 11, SqlFieldName = MIF_MinAge ];

/// 最大上报年龄
Property MIFMaxAge As %Integer [ SqlColumnNumber = 12, SqlFieldName = MIF_MaxAge ];

/// 是否有效
Property MIFIsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = MIF_IsActive ];

/// 是否强制上报
Property MIFIsForceReport As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = MIF_IsForceReport ];

/// 是否慢性传染病
Property MIFIsChronic As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = MIF_IsChronic ];

/// Creator:       PanLei
/// CreatDate:     2011-06-10
/// Description:   更新/保存
/// Table:         DHCMed_EPD.Infection
/// Input:         Instring:传入的字符串信息, Delimiter:分隔符
/// Return:        执行SQL以后返回的SQLCODE值
/// Others:        w ##class(DHCMed.EPD.Infection).Update("^^^^^^Y^Y^^", "^")
ClassMethod Update(Instring As %String, Delimiter As %String) As %String
{
	//必须在类属性中定义Not ProcedureBlock，才能使用New (Instring, Delimiter)
	New (Instring, Delimiter)
	if $g(Delimiter)=""{
		set Delimiter=..#SEPARATE
	}
	/*判断是否有相同ICD及名称的数据，去重*/
	Set sRowid=$p(Instring,Delimiter,1)
	if (sRowid=""){
		Set ICD		=$p(Instring,Delimiter,2)
		Set DName	=$p(Instring,Delimiter,3)
		Set xID = ""
		Set TempICD = ""
		Set TempName = ""
		For {
			Set xID = $o(^DHCMed.EPDC("IF",xID))
			Quit:xID=""
			Set TempData 	= ^DHCMed.EPDC("IF",xID)
			Set TICD  		= $p(TempData,"^",1)
			Set TName  		= $p(TempData,"^",2)
			Set TempICD 	= TempICD_","_TICD
			Set TempName 	= TempName_","_TName
			
		}
		if (((","_TempICD_",")[(","_xID_","))&&((","_TempName_",")[(","_DName_","))){
			Quit -2
		}
	}

	
	
	
	//数组PLIST
	Set sRowid=$p(Instring,Delimiter,1)
	Set PLIST(2)=$p(Instring,Delimiter,2)
	Set PLIST(3)=$p(Instring,Delimiter,3)
	Set PLIST(4)=$p(Instring,Delimiter,4)
	Set PLIST(5)=$p(Instring,Delimiter,5)
	Set PLIST(6)=$p(Instring,Delimiter,6)
	Set PLIST(7)=$p(Instring,Delimiter,7)
	Set PLIST(8)=$p(Instring,Delimiter,8)
	Set PLIST(9)=$p(Instring,Delimiter,9)
	Set PLIST(10)=$p(Instring,Delimiter,10)
	Set PLIST(11)=$p(Instring,Delimiter,11)
	Set PLIST(12)=$p(Instring,Delimiter,12)
	Set PLIST(13)=$p(Instring,Delimiter,13)  //有效
	Set PLIST(14)=$p(Instring,Delimiter,14)  //强制报卡
	Set PLIST(15)=$p(Instring,Delimiter,15)  //慢性传染病
	
	If sRowid="" Do
	.&sql(insert into DHCMed_EPD.Infection values :PLIST())
	Else  Do
	.&sql(update DHCMed_EPD.Infection values :PLIST() where MIF_RowId=:sRowid)
	
	If SQLCODE = 0 {
		Set ret = $p(%ROWID, $c(1))
	} Else {
		Set ret = -1
	}
	Quit ret
}

/// Creator:       PanLei
/// CreatDate:     2011-06-10
/// Description:   根据id获取对象
/// Table:         DHCMed.EPD.Infection
/// Input:         id:传入的id数值
/// Return:        returnObj
ClassMethod GetObjById(id As %String) As DHCMed.EPD.Infection
{
	New (id)
	Set return=""
	Set return = ##class(DHCMed.EPD.Infection).%OpenId(id)
	Quit:'$IsObject(return) return
	If return'="" Do return.%Close()
	Quit return
}

/// Creator:       PanLei
/// CreatDate:     2011-06-10
/// Description:   转化为字符串
/// Table:         DHCMed.EPD.Infection
/// Input:         separete:分隔符
/// Return:        return
Method ToString(separete As %String) As %String
{
	//如果传递的分隔符为空，则使用父类默认的
	If $g(separete)="" {
		Set separete=..#SEPARATE
	}
	
	//_为连接符
	Set return=""
	Set return=..%Id()_separete
	Set return=return_..MIFICD_separete
	Set return=return_..MIFDisease_separete
	Set return=return_..MIFKind_separete
	Set return=return_..MIFRank_separete
	Set return=return_..MIFAppendix_separete
	Set return=return_..MIFMulti_separete
	Set return=return_..MIFDependence_separete
	Set return=return_..MIFTimeLimit_separete
	Set return=return_..MIFResume_separete
	Set return=return_..MIFMinAge_separete
	Set return=return_..MIFMaxAge_separete
	Set return=return_..MIFIsActive_separete  //有效
	Set return=return_..MIFIsForceReport_separete  	//强制报卡
	Set return=return_..MIFIsChronic_separete  		//慢性传染病
	quit return
}

/// Creator:       PanLei
/// CreatDate:     2011-06-10
/// Description:   根据传递的id获取对象，然后转化为字符串
/// Table:         DHCMed.EPD.Infection
/// Input:         id:传入的id数值，separete:分隔符
/// Return:        return
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	New (id, separete)
	Set return = ""
	
	Set obj = ..GetObjById(id)
	If $IsObject(obj) {
		Set return = obj.ToString($g(separete))
	}
	Quit return
}

/// Creator:       PanLei
/// CreatDate:     2011-06-10
/// Description:   更新/保存
/// Table:         DHCMed_EPD.Infection
/// Input:         Instring:传入的字符串信息, Delimiter:分隔符
/// Return:        执行SQL以后返回的SQLCODE值
/// w ##class(DHCMed.EPD.Infection).ImportEPDDics("^053^HIV^艾滋病^2^1^Y^Y^2^^^^HIV","^")
ClassMethod ImportEPDDics(Instring As %String, Delimiter As %String) As %String
{
	New (Instring, Delimiter)
	
	If $g(Delimiter)=""{
		Set Delimiter=..#SEPARATE
	}
	
	Set sRowid=$p(Instring,Delimiter,1)
	Set PLIST(2)=$p(Instring,Delimiter,2)
	Set PLIST(3)=$p(Instring,Delimiter,3)
	Set TypeDesc=$p(Instring,Delimiter,4)
	Set TypeCode=""
	&sql(SELECT Code INTO :TypeCode FROM DHCMed_SS.Dictionary WHERE Description=:TypeDesc and Type='EpdemicType')
	Set PLIST(4)=TypeCode
	Set PLIST(5)=$p(Instring,Delimiter,5)
	Set PLIST(6)=$p(Instring,Delimiter,6)
	Set:PLIST(6)="undefined" PLIST(6)=""
	Set PLIST(7)=$p(Instring,Delimiter,7)
	Set PLIST(8)=$p(Instring,Delimiter,8)
	Set PLIST(9)=$p(Instring,Delimiter,9)
	Set PLIST(10)=$p(Instring,Delimiter,10)
	Set PLIST(11)=$p(Instring,Delimiter,11)
	Set PLIST(12)=$p(Instring,Delimiter,12)
	Set PLIST(13)=$p(Instring,Delimiter,13)  //有效
	Set PLIST(14)=$p(Instring,Delimiter,14)  //是否强制报卡
	Set PLIST(15)=$p(Instring,Delimiter,15)  //是否慢性传染病
	
	Set ICD10=$p(Instring,Delimiter,2)
	Set Name=$p(Instring,Delimiter,3)
	Set PinYins=$p(Instring,Delimiter,14)
	//Set KeyWords=$p(Instring,Delimiter,14)
	//Set ICD10s=$p(Instring,Delimiter,15)
	
	Set PinYins=$tr(PinYins,"，",",")
	Set PinYins=$tr(PinYins,"、",",")
	Set:PinYins="undefined" PinYins=""
	//Set KeyWords=$tr(KeyWords,"，",",")
	//Set KeyWords=$tr(KeyWords,"、",",")
	//Set:KeyWords="undefined" KeyWords=""
	//Set ICD10s=$tr(ICD10s,"，",",")
	//Set ICD10s=$tr(ICD10s,"、",",")
	//Set:ICD10s="undefined" ICD10s=""
	
	If sRowid="" {
		&sql(SELECT MIF_RowId INTO :sRowid FROM DHCMed_EPD.Infection WHERE MIF_Disease=:Name)
	}
	
	If sRowid'="" {
		&sql(update DHCMed_EPD.Infection values :PLIST() where MIF_RowId=:sRowid)
	}Else{
		&sql(insert into DHCMed_EPD.Infection values :PLIST())
	}
	
	If SQLCODE = 0 {
		Set ret = $p(%ROWID, $c(1))
		Set strAlias = ret_"^^^"_Name_"^1"
		Set subret=##class(DHCMed.EPD.InfectionAlias).Update(strAlias,"^")
		
		//update by zf 2012-11-20 传染病ICD10当代码用
		//Set strAlias = ret_"^^^"_ICD10_"^2"
		//Set subret=##class(DHCMed.EPD.InfectionAlias).Update(strAlias,"^")
		
		//w "PinYins="_PinYins,!
		For tmpIndex=1:1:$l(PinYins,",") {
			Set tmpDesc=$p(PinYins,",",tmpIndex)
			Continue:tmpDesc=""
			//w "tmpDesc="_tmpDesc,!
			Set strAlias = ret_"^^^"_tmpDesc_"^0"
			Set subret=##class(DHCMed.EPD.InfectionAlias).Update(strAlias,"^")
		}
		
		/*  update by zf 2012-11-20 关键字和ICD10通过另一页签单独导入
		//w "KeyWords="_KeyWords,!
		For tmpIndex=1:1:$l(KeyWords,",") {
			Set tmpDesc=$p(KeyWords,",",tmpIndex)
			Continue:tmpDesc=""
			//w "tmpDesc="_tmpDesc,!
			Set strAlias = ret_"^^^"_tmpDesc_"^1"
			Set subret=##class(DHCMed.EPD.InfectionAlias).Update(strAlias,"^")
		}
		
		//w "ICD10s="_ICD10s,!
		For tmpIndex=1:1:$l(ICD10s,",") {
			Set tmpDesc=$p(ICD10s,",",tmpIndex)
			Continue:tmpDesc=""
			//w "tmpDesc="_tmpDesc,!
			Set strAlias = ret_"^^^"_tmpDesc_"^2"
			Set subret=##class(DHCMed.EPD.InfectionAlias).Update(strAlias,"^")
		}
		*/
	} Else {
		Set ret = -1
	}
	Quit ret
}

/// Creator:       zhufei
/// CreatDate:     2012-11-20
/// Description:   导入传染病字典别名数据
/// Table:         DHCMed_EPD.InfectionAlias
/// Input:         aInput:输入字符串
/// Return:        return>0 : 成功   return<1 : 失败
/// w ##class(DHCMed.EPD.Infection).ImportEPDAlias("B20.001^艾滋病伴分枝杆菌感染^^艾滋病")
ClassMethod ImportEPDAlias(aInput As %String) As %String
{
	New (aInput)
	Set return=0
	
	Set ICD10=$p(aInput,"^",1)     //ICD10
	Set ICDName=$p(aInput,"^",2)   //关键字
	Set ICDAlias=$p(aInput,"^",3)  //拼音别名
	Set EpdName=$p(aInput,"^",4)   //传染病字典
	Set Type=$p(aInput,"^",5)      //类型  //add by pylian 20151231 增加类型便于维护关键字(过滤)功能
	Quit:EpdName="" return
	
	Set EpdRowId=""
	Set DicID=0
	For {
		Set DicID=$o(^DHCMed.EPDC("IF",DicID))
		Quit:DicID=""
		Quit:EpdRowId'=""
		
		Set DicName=$p($g(^DHCMed.EPDC("IF",DicID)),"^",2)
		Continue:EpdName'=DicName
		Set EpdRowId=DicID
	}
	Quit:EpdRowId="" return
	
	If ICDAlias'="" {
		Set strInput = EpdRowId_"^^^"_ICDAlias_"^0"
		Set subret=##class(DHCMed.EPD.InfectionAlias).Update(strInput,"^")
	}
	
	If ICDName'="" {
		If (Type'="") {
			Set strInput = EpdRowId_"^^^"_ICDName_"^"_Type
		}else {
			Set strInput = EpdRowId_"^^^"_ICDName_"^1"
		}
		Set subret=##class(DHCMed.EPD.InfectionAlias).Update(strInput,"^")
	}
	
	If ICD10'="" {
		Set strInput = EpdRowId_"^^^"_ICD10_"^2"
		Set subret=##class(DHCMed.EPD.InfectionAlias).Update(strInput,"^")
	}
	
	Set return=1
	Quit return
}

/// w ##Class(DHCMed.EPD.Infection).DeleteEPDDics()
ClassMethod DeleteEPDDics() As %String
{
	New
	Set return=-1
	
	Set $ZT="DeleteEPDDicsErr"
	
	Set TimeStr=$h
	M ^DHCMed.EPDC("IF"_TimeStr)=^DHCMed.EPDC("IF")
	M ^DHCMed.EPDCi("IF"_TimeStr)=^DHCMed.EPDCi("IF")
	Kill ^DHCMed.EPDC("IF")
	Kill ^DHCMed.EPDCi("IF")
	
	Set return=1
	Quit return
	
DeleteEPDDicsErr
	Write "Error:"_$ZError,!
	Quit -999
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMed.EPDC("IF"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MIF_Appendix">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MIF_Dependence">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MIF_Disease">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MIF_ICD">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIF_IsActive">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MIF_IsChronic">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MIF_IsForceReport">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MIF_Kind">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MIF_MaxAge">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MIF_MinAge">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MIF_Multi">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MIF_Rank">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MIF_Resume">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MIF_TimeLimit">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCMed.EPDC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MIF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{MIF_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexICD">
<Global>^DHCMed.EPDCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MIF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"ICD"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MIF_ICD}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MIF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^DHCMed.EPD.InfectionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
