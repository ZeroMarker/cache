Class web.DHCICUPublishCom Extends %Persistent
{

ClassMethod GenSaveCode(clsName)
{
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(clsName) 
	// Write cdef.Name,! 
	set sqlName=cdef.SqlTableName
	Set count = cdef.Properties.Count() 
	set codeFieldName=$$GetCodeField()
	
	For i = 1:1:count 
	{ 
		set name=cdef.Properties.GetAt(i).Name
		set sqlSeqNo=cdef.Properties.GetAt(i).SqlColumnNumber
		continue:sqlSeqNo=""
		set Array(sqlSeqNo)=name
	}
	set seqNo=""
	set seqNo=$O(Array(seqNo))
	Write "Save"_$p(clsName,".",2)_"("_Array(seqNo)
	For 
	{ 
		set seqNo=$O(Array(seqNo))
		quit:seqNo=""
		set name=Array(seqNo)
		Write ",",name
	}
	Write ")",!
	Write "    set rowId=..GetIdByCode("""_clsName_""","""_codeFieldName_""","_$$GetCodeField()_")",!
	Write "    set obj=##class("_clsName_").%New()",!
	Write "    if (rowId'="""")",!
	Write "    {",!
	Write "    set obj=##class("_clsName_").%OpenId(rowId)",!
	Write "    }",!
	Write "    else",!
	Write "    {",!
	Write "    set obj=##class("_clsName_").%New()",!
	Write "    }",!
	
	set seqNo=""
	For 
	{ 
		set seqNo=$O(Array(seqNo))
		quit:seqNo=""
		set name=Array(seqNo)
		Write "    set obj.",name,"=",name,!
	}
	
	Write "    do obj.%Save()",!
	Write "    quit obj.%Id()"
	quit 0
GetCodeField()
    set codeFieldName=""
	For i = 1:1:count 
	{ 
		set name=cdef.Properties.GetAt(i).Name
		if name["Code"
		{
			set codeFieldName=name
			quit
		}
	}
	quit codeFieldName
}

ClassMethod GetIdByCode(className, codeFieldName, code)
{
	set rowIdName=..GetRowIdName(className)
	set tableName=..GetTableName(className)
	set sqlStr="select "_rowIdName_" as Id from SQLUser."_tableName_" where "_codeFieldName_"="""_code_""""
	set ^tempClDebug("2")=sqlStr
	SET tStatement=##class(%SQL.Statement).%New()
	// SET tStatement.%ObjectSelectMode=1
    SET tStatus=tStatement.%Prepare(sqlStr)
    SET rset=tStatement.%Execute()
    set id=""
    
    while rset.%Next() {
	   set id=rset.%Get("Id")
	   set ^tempClDebug("4")=id
	   quit
    }
    
    IF ((rset.%SQLCODE'=0)&&(rset.%SQLCODE'=100))
    {
	    set ^tempClDebug("3")=rset.%Message
	    quit rset.%Message
    }
    do tStatement.%Close()
    quit id
}

ClassMethod GetRowIdName(cdef)
{
	if (cdef'["%Dictionary.ClassDefinition")
	{
		set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(cdef)
	}
	set rowIdName=""
	if cdef.ClassType="persistent" 
	{
		if (cdef.SqlRowIdName'="")
		{
			s rowIdName = dsd.SqlRowIdName		
		}
		else
		{
			if ((cdef.Storages)&&(cdef.Storages.Count()>0) && (cdef.Storages.GetAt(1).SqlRowIdName'="")){
				s rowIdName=cdef.Storages.GetAt(1).SqlRowIdName
			}
		}
	}
	quit rowIdName
}

ClassMethod GetTableName()
{
	if (cdef'["%Dictionary.ClassDefinition")
	{
		set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(cdef)
	}
	set tableName=cdef.SqlTableName
	quit tableName
}

Storage Default
{
<Data name="DHCICUPublishComDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCICUPublishComD</DataLocation>
<DefaultData>DHCICUPublishComDefaultData</DefaultData>
<IdLocation>^web.DHCICUPublishComD</IdLocation>
<IndexLocation>^web.DHCICUPublishComI</IndexLocation>
<StreamLocation>^web.DHCICUPublishComS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
