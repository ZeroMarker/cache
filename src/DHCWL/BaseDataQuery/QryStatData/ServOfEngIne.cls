Class DHCWL.BaseDataQuery.QryStatData.ServOfEngIne Extends %RegisteredObject
{

Property curRowID As %Integer;

Property sqlTableName As %String;

Property className As %String;

Property dateInx As %String;

Property dateField As %String;

Property startDate As %Date;

Property endDate As %Date;

Property curDate As %Date;

Property aryFieldPiece [ MultiDimensional ];

Property sqlRowIdName;

Method GetFieldPiece()
{
 	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(..className)
 	s storages=cdef.Storages
 	s ..sqlRowIdName=cdef.SqlRowIdName
 	Set key = ""
    Set stgd = cdef.Storages.GetNext(.key)	//%Dictionary.StorageDefinition
    Set key = ""
    Set sqlmd = stgd.SQLMaps.GetNext(.key)	//%Dictionary.StorageSQLMapDefinition 
    Set key = ""
    //Set sqlmdd = sqlmd.Data.GetNext(.key) //%Dictionary.StorageSQLMapDataDefinition
	
	Do {
	    Set sqlmdd = sqlmd.Data.GetNext(.key)
	    If (sqlmdd '= "") {
		    
		    s ..aryFieldPiece(sqlmdd.Name)=sqlmdd.Piece
	        //Write !,sqlmdd.Name_","_sqlmdd.Delimiter_","_sqlmdd.Piece
	    }
	 } While (key '= "")
}

Method Prepare(startDate As %String, endDate As %String)
{
 	if ..curDate=0 s ..curDate=startDate
 	s ..curRowID=0
	d ..GetFieldPiece()
	s ..startDate=$zdh(startDate,3)
	s ..endDate=$zdh(endDate,3)

	s ..curDate=..startDate
}

Method Execute()
{
}

Method Next() As %Integer
{
	q 0
}

Method FieldData(fieldName As %String) As %String
{
	q:fieldName=..sqlRowIdName ..curRowID
	s piece=..aryFieldPiece(fieldName)
	q $p($g(^DHCWorkLoad(..curRowID)),"^",piece)
}

Method %OnNew() As %Status
{
	
	s ..sqlTableName=^||DHCWLTEMP("RPTCFG","BaseObjName")
	s ..className=^||DHCWLTEMP("classSqlTableMap",..sqlTableName)
	s ..dateField=^||DHCWLTEMP("RPTCFG","DateItemName") /// 日期统计项
	s ..curRowID=""
	/**/
	Quit $$$OK
}

Method LoadInxData()
{
}

}
