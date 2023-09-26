Class User.PATest Extends (%Persistent, User.Abstract) [ SqlTableName = PA_Test_ ]
{

Property PARowId As %Integer [ SqlColumnNumber = 2, SqlFieldName = PA_RowId ];

Property PAName As %String [ SqlColumnNumber = 3, SqlFieldName = PA_Name ];

Property PACardNo As %String [ SqlColumnNumber = 4, SqlFieldName = PA_CardNo ];

Property PASexDr As User.CTSex [ SqlColumnNumber = 5, SqlFieldName = PA_Sex_Dr ];

Index PANameIndex On PAName;

Index PACardNoIndex On PACardNo;

// 

// Method %OnBeforeSave() As %Status

// {

// 		Set oldName = ..%Get("PAName", 1)

//        Set oldCardNo = ..%Get("PACardNo", 1)

//        Set status = $$$OK

// 

//        If (..%IsModified("PAName") && oldName '= ..PAName) {

//            Do ..LogChange("PA_Name", oldName, ..PAName)

//        }

// 

//        If (..%IsModified("PACardNo") && oldCardNo '= ..PACardNo) {

//            Do ..LogChange("PA_CardNo", oldCardNo, ..PACardNo)

//        }

// 

//        Quit status

// }

// 

// Method LogChange(fieldName As %String, oldValue As %String, newValue As %String) As %Status [ Private ]

// {

//        Set log = ##class(User.PATestLog).%New()

//        Set log.LogPersonDr = ..%Id()

//        Set log.LogFiled = fieldName

//        Set log.LogOldValue = oldValue

//        Set log.LogNewValue = newValue

//        Set status = log.%Save()

// 

//        Quit status

// }

/// // Override the %OnBeforeSave method to handle logging when PAName or PACardNo changes
/// // Method to log a change in a specific field
Storage Default
{
<Data name="PATestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PARowId</Value>
</Value>
<Value name="3">
<Value>PAName</Value>
</Value>
<Value name="4">
<Value>PACardNo</Value>
</Value>
<Value name="5">
<Value>PASexDr</Value>
</Value>
</Data>
<DataLocation>^User.PATestD</DataLocation>
<DefaultData>PATestDefaultData</DefaultData>
<Description>
<![CDATA[// Override the %OnBeforeSave method to handle logging when PAName or PACardNo changes
// Method to log a change in a specific field]]></Description>
<IdLocation>^User.PATestD</IdLocation>
<IndexLocation>^User.PATestI</IndexLocation>
<StreamLocation>^User.PATestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
