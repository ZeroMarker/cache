Class User.DHCMGPersonSchool Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMG_Persons_School ]
{

Parameter EXTENTSIZE = 250;

/// School_GraduateDate
Property SchoolGraduateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = School_GraduateDate ];

/// School_GraduateSchool
Property SchoolGraduateSchool As User.DHCMGCCode [ SqlColumnNumber = 3, SqlFieldName = School_GraduateSchool ];

/// School_Age_Dr
Property SchoolAgeDr As User.DHCMGCCode [ SqlColumnNumber = 4, SqlFieldName = School_Age_Dr ];

/// School_Degree_DR
Property SchoolDegreeDR As User.DHCMGCCode [ SqlColumnNumber = 5, SqlFieldName = School_Degree_DR ];

/// School_Profession
Property SchoolProfession As User.DHCMGCCode [ SqlColumnNumber = 6, SqlFieldName = School_Profession ];

/// School_Language
Property SchoolLanguage As User.DHCMGCCode [ SqlColumnNumber = 7, SqlFieldName = School_Language ];

/// School_Current
Property SchoolCurrent As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = School_Current ];

/// School_Reading
Property SchoolReading As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = School_Reading ];

/// School_Person
Property SchoolPerson As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = School_Person ];

/// School_mem
Property Schoolmem As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = School_mem ];

/// School_Type
Property SchoolType As User.DHCMGCCode [ SqlColumnNumber = 12, SqlFieldName = School_Type ];

/// School_MedWest
Property SchoolMedWest As User.DHCMGCCode [ SqlColumnNumber = 13, SqlFieldName = School_MedWest ];

Index Person On SchoolPerson;

ClassMethod saveSchool(parr As %String) As %String
{

		s id=$P(parr,"^",1)
		s personid=$P(parr,"^",2)
		s SchoolGraduateDate=$P(parr,"^",3)
		;q:SchoolGraduateDate=""
		s SchoolGraduateSchool=$P(parr,"^",4)
		s SchoolAgeDr=$P(parr,"^",5)
		s SchoolDegreeDR=$P(parr,"^",6)
		s SchoolProfession=$P(parr,"^",7)
		s SchoolLanguage=$P(parr,"^",8)
		s SchoolCurrent=$P(parr,"^",9)
		s SchoolReading=$P(parr,"^",10)
		s Schoolmem=$P(parr,"^",11)
		s SchoolType=$P(parr,"^",12)
		s SchoolMedWest=$P(parr,"^",13)
		if id="" s school=##class(User.DHCMGPersonSchool).%New()
  e  s school=##class(User.DHCMGPersonSchool).%OpenId(id)
  s school.SchoolPerson=personid
  i SchoolGraduateDate'="" s SchoolGraduateDate=$zdh(SchoolGraduateDate,3)
  s school.SchoolGraduateDate=SchoolGraduateDate
  i SchoolGraduateSchool'="" s school.SchoolGraduateSchool=##class(User.DHCMGCCode).%OpenId(SchoolGraduateSchool)
  e  s school.SchoolGraduateSchool=""
  i SchoolAgeDr'="" s school.SchoolAgeDr=##class(User.DHCMGCCode).%OpenId(SchoolAgeDr)
	 e  s school.SchoolAgeDr=""
	 i SchoolDegreeDR'="" s school.SchoolDegreeDR=##class(User.DHCMGCCode).%OpenId(SchoolDegreeDR)
 	e  s school.SchoolDegreeDR=""
  i SchoolProfession'="" s school.SchoolProfession=##class(User.DHCMGCCode).%OpenId(SchoolProfession)
	 e  s school.SchoolProfession=""
  i SchoolLanguage'="" s school.SchoolLanguage=##class(User.DHCMGCCode).%OpenId(SchoolLanguage)
	 e  s school.SchoolLanguage=""
  s school.SchoolCurrent=SchoolCurrent
  s school.SchoolReading=SchoolReading
  s school.Schoolmem=Schoolmem
  i SchoolType'="" s school.SchoolType=##class(User.DHCMGCCode).%OpenId(SchoolType)
	 e  s school.SchoolType=""
  i SchoolMedWest'="" s school.SchoolMedWest=##class(User.DHCMGCCode).%OpenId(SchoolMedWest)
  e  s school.SchoolMedWest=""
  d school.%Save()
  if (SchoolCurrent="Y")
    {
	  	s p=##class(User.DHCMGPersons).%OpenId(personid)
	  	s p.PersonGraduateDate=SchoolGraduateDate
	   i SchoolGraduateSchool'="" s p.PersonGraduateSchool=##class(User.DHCMGCCode).%OpenId(SchoolGraduateSchool)
	   e  s p.PersonGraduateSchool=""
	   i SchoolAgeDr'="" s p.PersonSchoolAgeDr=##class(User.DHCMGCCode).%OpenId(SchoolAgeDr)
	   e  s p.PersonSchoolAgeDr=""
	   i SchoolDegreeDR'="" s p.PersonDegreeDR=##class(User.DHCMGCCode).%OpenId(SchoolDegreeDR)
	   e  s p.PersonDegreeDR=""
	   i SchoolProfession'="" s p.PersonProfession=##class(User.DHCMGCCode).%OpenId(SchoolProfession)
	   e  s p.PersonProfession=""
	   i SchoolLanguage'="" s p.PersonLanguage=##class(User.DHCMGCCode).%OpenId(SchoolLanguage)
	   e  s p.PersonLanguage=""
	   i SchoolType'="" s p.PersonSchoolType=##class(User.DHCMGCCode).%OpenId(SchoolType)
	   e  s p.PersonSchoolType=""
	   i SchoolMedWest'="" s p.PersonSchoolMedWest=##class(User.DHCMGCCode).%OpenId(SchoolMedWest)
	   e  s p.PersonSchoolMedWest=""
	  d p.%Save()
	  }
	  
  q 0
}

Storage Default
{
<Data name="DHCMGPersonSchoolDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SchoolGraduateDate</Value>
</Value>
<Value name="3">
<Value>SchoolGraduateSchool</Value>
</Value>
<Value name="4">
<Value>SchoolAgeDr</Value>
</Value>
<Value name="5">
<Value>SchoolDegreeDR</Value>
</Value>
<Value name="6">
<Value>SchoolProfession</Value>
</Value>
<Value name="7">
<Value>SchoolLanguage</Value>
</Value>
<Value name="8">
<Value>SchoolCurrent</Value>
</Value>
<Value name="9">
<Value>SchoolReading</Value>
</Value>
<Value name="10">
<Value>SchoolPerson</Value>
</Value>
<Value name="11">
<Value>Schoolmem</Value>
</Value>
<Value name="12">
<Value>SchoolType</Value>
</Value>
<Value name="13">
<Value>SchoolMedWest</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGPersonSchoolD</DataLocation>
<DefaultData>DHCMGPersonSchoolDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.DHCMGPersonSchoolD</IdLocation>
<IndexLocation>^User.DHCMGPersonSchoolI</IndexLocation>
<StreamLocation>^User.DHCMGPersonSchoolS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
