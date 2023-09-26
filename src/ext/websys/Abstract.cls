IncludeGenerator TRAK

/// websys.Abstract
/// Abstract class used to provide common functionality to classes in the websys package.
Class ext.websys.Abstract Extends %Library.RegisteredObject [ Abstract, Not Final, Not ProcedureBlock ]
{

Parameter BUILD = 80;

Parameter MAJORVERSION;

Parameter MINORVERSION;

Parameter SQLCODE;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION;

Parameter SQLFILTER;

/// Inputs:
/// array(columnnumber)=value as a reference to a table
/// 
/// Output:
/// 
/// array(columnnumber)=description from refrenced table
ClassMethod GetAuditDisplayInfo(ByRef aryColInfo As %Library.String) [ CodeMode = generator ]
{
}

Parameter SQLROWID;

/// This returns description,id,code (this is to be consitent with lookups)
ClassMethod GetCodeDescriptionFromId(id As %Library.String) As %Library.String [ CodeMode = generator, PlaceAfter = GetIdFromCodeOrDescription ]
{
	;d %code.WriteLine($$$TRAKDEF)
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean [ CodeMode = generator ]
{
}

/// Find the object id given either a code or a description.<br>
/// To provide control over the code that is generated the following parameters can be used:<br>
/// SQLROWID - specify the SQL field name to be returned from the function.<br>
/// SQLCODE - specify the SQL field name to be used in the search by code.<br>
/// SQLDESCRIPTION - specify the SQL field name to be used in the search by descripiton.<br>
/// <br>
/// NOTE that these same parameters are are in the generation of default lookups.<br>
ClassMethod GetIdFromCodeOrDescription(val As %Library.String) As %Library.String [ CodeMode = generator ]
{
	s %code=0
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean [ CodeMode = generator ]
{
}

/// Get Version of the class.
/// Compoiled version is based on MAJORVERSION, MINORVERSION, BUILD and includes a dat and time stamp.
ClassMethod GetCompiledVersion() As %Library.String [ CodeMode = objectgenerator, Final ]
{
	;新生成BUILD Parameter
	
	s myBuildPara="BUILD"
	s myMajorVersion = "MAJORVERSION"
	s myMinVersion = "MINORVERSION"
	s mySQLCODE = "SQLCODE"
	s mySQLDESCRIPTION="SQLDESCRIPTION"
	s mySQLFILTER="SQLFILTER"
	s mySQLROWID="SQLROWID"
	s mySQLDATEFROM="SQLDATEFROM"
	s mySQLDATETO="SQLDATETO"
	
	;Build para
	s myRowID=%class.Name_"||"_myBuildPara
	s myflag = ##class(%Dictionary.ParameterDefinition).%ExistsId(myRowID)
	i ('+myflag){
		s myparobj=##class(%Dictionary.ParameterDefinition).%New()
		s myparobj.Name=myBuildPara
		d %class.Parameters.Insert(myparobj)
	}else{
		s myparobj=##class(%Dictionary.ParameterDefinition).%OpenId(myRowID)
	}
	s myparobj.Default=myparobj.Default+1
	s myBuildValue=myparobj.Default
	d myparobj.%Save()
	
	;MAJORVERSION
	s myRowID=%class.Name_"||"_myMajorVersion
	s myflag = ##class(%Dictionary.ParameterDefinition).%ExistsId(myRowID)
	i ('(+myflag)){
		s myparobj=##class(%Dictionary.ParameterDefinition).%New()
		s myparobj.Name=myMajorVersion
		d %class.Parameters.Insert(myparobj)
		d myparobj.%Save()
	}

	;MAJORVERSION
	s myRowID=%class.Name_"||"_myMinVersion
	s myflag = ##class(%Dictionary.ParameterDefinition).%ExistsId(myRowID)
	i ('(+myflag)){
		s myparobj=##class(%Dictionary.ParameterDefinition).%New()
		s myparobj.Name=myMinVersion
		d %class.Parameters.Insert(myparobj)
		d myparobj.%Save()
	}
	
	;SQLCODE
	s myRowID=%class.Name_"||"_mySQLCODE
	s myflag = ##class(%Dictionary.ParameterDefinition).%ExistsId(myRowID)
	i ('(+myflag)){
		s myparobj=##class(%Dictionary.ParameterDefinition).%New()
		s myparobj.Name=mySQLCODE
		d %class.Parameters.Insert(myparobj)
		d myparobj.%Save()
	}
	
	;SQLDESCRIPTION
	s myRowID=%class.Name_"||"_mySQLDESCRIPTION
	s myflag = ##class(%Dictionary.ParameterDefinition).%ExistsId(myRowID)
	i ('(+myflag)){
		s myparobj=##class(%Dictionary.ParameterDefinition).%New()
		s myparobj.Name=mySQLDESCRIPTION
		d %class.Parameters.Insert(myparobj)
		d myparobj.%Save()
	}
	
	;mySQLFILTER
	s myRowID=%class.Name_"||"_mySQLFILTER
	s myflag = ##class(%Dictionary.ParameterDefinition).%ExistsId(myRowID)
	i ('(+myflag)){
		s myparobj=##class(%Dictionary.ParameterDefinition).%New()
		s myparobj.Name=mySQLFILTER
		d %class.Parameters.Insert(myparobj)
		d myparobj.%Save()
	}
	
	;mySQLROWID
	s myRowID=%class.Name_"||"_mySQLROWID
	s myflag = ##class(%Dictionary.ParameterDefinition).%ExistsId(myRowID)
	i ('(+myflag)){
		s myparobj=##class(%Dictionary.ParameterDefinition).%New()
		s myparobj.Name=mySQLROWID
		d %class.Parameters.Insert(myparobj)
		d myparobj.%Save()
	}
	
	;mySQLDATEFROM
	s myRowID=%class.Name_"||"_mySQLDATEFROM
	s myflag = ##class(%Dictionary.ParameterDefinition).%ExistsId(myRowID)
	i ('(+myflag)){
		s myparobj=##class(%Dictionary.ParameterDefinition).%New()
		s myparobj.Name=mySQLDATEFROM
		d %class.Parameters.Insert(myparobj)
		d myparobj.%Save()
	}
	
	;mySQLDATETO
	s myRowID=%class.Name_"||"_mySQLDATETO
	s myflag = ##class(%Dictionary.ParameterDefinition).%ExistsId(myRowID)
	i ('(+myflag)){
		s myparobj=##class(%Dictionary.ParameterDefinition).%New()
		s myparobj.Name=mySQLDATETO
		d %class.Parameters.Insert(myparobj)
		d myparobj.%Save()
	}
	
	
	;format "..1 at 2009-06-12 09:05:16AM"
	;定义一个时间区域格式
	Do %code.WriteLine(" Quit "_""".."_myBuildValue_" at "_+$h_" "_$p($h,",",2)_"""")
	Quit $$$OK
}

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String) [ CodeMode = generator ]
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String) [ CodeMode = generator ]
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean [ CodeMode = generator ]
{
}

/// Just like GetIdFromCodeOrDescription except now it accepts a parameter for date to be used for active date check
/// the following parameters is also used:
/// SQLDATEFROM - specify the SQL field name to be used in the search by datefrom.
/// SQLDATETO - specify the SQL field name to be used in the search by dateto.
ClassMethod GetIdFromDateCodeOrDesc(val As %Library.String, date As %Library.Date = "") As %Library.String [ CodeMode = generator, PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpClose(QHandle As %Library.Binary) As %Library.Status [ CodeMode = generator, PlaceAfter = LookUpFetch ]
{
	;Quit $$Error^%apiOBJ(5758,"%Query::Close")
}

/// Default implementation of LookUp Query.
ClassMethod LookUpExecute(ByRef QHandle As %Library.Binary, desc As %String) As %Library.Status [ CodeMode = generator, PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ CodeMode = generator, PlaceAfter = LookUpExecute ]
{
}

/// Just like LookUpBroker except it now accepts a date to be compared with SQLDATEFROM and SQLDATETO fields
ClassMethod LookUpDateBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean [ CodeMode = generator, PlaceAfter = GetIdFromDateCodeOrDesc ]
{
}

/// Default implementation of LookUpDate Query.
ClassMethod LookUpDateExecute(ByRef QHandle As %Library.Binary, desc As %String, date As %Date = "") As %Library.Status [ CodeMode = generator, PlaceAfter = GetIdFromDateCodeOrDesc ]
{
}

/// Default implementation of LookUpDate Query.
ClassMethod LookUpDateFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ CodeMode = generator, PlaceAfter = LookUpDateExecute ]
{
}

/// Default implementation of LookUpDate Query.
ClassMethod LookUpDateClose(QHandle As %Library.Binary) As %Library.Status [ CodeMode = generator, PlaceAfter = LookUpDateFetch ]
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUp(desc As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

/// Just like LookUp except it now accepts a date to be compared with SQLDATEFROM and SQLDATETO fields
Query LookUpDate(desc As %String, date As %Date) As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

/// [Previously private]
ClassMethod TestInc()
{
}

}
