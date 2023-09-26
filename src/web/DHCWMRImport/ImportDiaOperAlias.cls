Import SQLUser

Class web.DHCWMRImport.ImportDiaOperAlias Extends %RegisteredObject
{

/// 向表MRC_ICDAlias中插入以MRCID_ICD9CM_Code为数据的别名
/// w ##class(web.DHCWMRImport.ImportDiaOperAlias).InsertAliasToMRCICDAlias()
ClassMethod InsertAliasToMRCICDAlias()
{
	;^MRC("ID",{MRCID_RowId})
	s MRCIDRowId=0
	s i=0
	f  s MRCIDRowId=$o(^MRC("ID",MRCIDRowId)) q:MRCIDRowId=""  d
	.s i=i+1
	.w "The "_i_" Starts",!
	.s str=$g(^MRC("ID",MRCIDRowId))
	.s ICD9CMCode=$p(str,"^",4)
	.w "ICD9CMCode="_ICD9CMCode,!
	.k PLIST 
	.s PLIST(0)=MRCIDRowId
	.s PLIST(3)=ICD9CMCode
	.&sql(INSERT INTO MRC_ICDAlias VALUES PLIST())
	w !,"Total:"_i,!
	q "finish"
}

/// 向表ORC_OperationAlias中插入以"s"+OPER_ICD10为数据的别名
/// 如果OPER_ICD9Map为空，执行update orc_operation set OPER_ICD9Map=OPER_ICD10，用于在Ajax查询时显示手术编码
/// w ##class(web.DHCWMRImport.ImportDiaOperAlias).InsertAliasToORCOperationAlias()
ClassMethod InsertAliasToORCOperationAlias()
{
	;^ORC("OPER",{OPER_RowId})
	s OPERRowId=0
	s i=0
	f  s OPERRowId=$o(^ORC("OPER",OPERRowId)) q:OPERRowId=""  d
	.s i=i+1
	.w "The "_i_" Starts",!
	.s str=$g(^ORC("OPER",OPERRowId))
	.s OPERICD10=$p(str,"^",14)
	.w "OPERICD10="_OPERICD10,!
	.k PLIST 
	.s PLIST(0)=OPERRowId
	.s PLIST(3)="S"_OPERICD10
	.&sql(INSERT INTO ORC_OperationAlias VALUES PLIST())
	w !,"Total:"_i,!
	q "finish"
}

/// 向表ORC_OperationAlias中插入以"s"+OPER_Code为数据的别名
/// 如果OPER_ICD9Map为空，执行update orc_operation set OPER_ICD9Map=OPER_Code，用于在Ajax查询时显示手术编码
/// w ##class(web.DHCWMRImport.ImportDiaOperAlias).InsertAliasToORCOperationAlias2()
ClassMethod InsertAliasToORCOperationAlias2()
{
	;^ORC("OPER",{OPER_RowId})
	s OPERRowId=0
	s i=0
	f  s OPERRowId=$o(^ORC("OPER",OPERRowId)) q:OPERRowId=""  d
	.s i=i+1
	.w "The "_i_" Starts",!
	.s str=$g(^ORC("OPER",OPERRowId))
	.s OPERCode=$p(str,"^",1)
	.w "OPERCode="_OPERCode,!
	.k PLIST 
	.s PLIST(0)=OPERRowId
	.s PLIST(3)="S"_OPERCode
	.&sql(INSERT INTO ORC_OperationAlias VALUES PLIST())
	w !,"Total:"_i,!
	q "finish"
}

}
