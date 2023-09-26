/// 继承<CLASS>Code.DataStore</CLASS>
/// 拿出基础的数据格式按照json的数据格式处理
/// <EXAMPLE>
/// s obj=##class(Code.DataStore).<METHOD>%New</METHOD>("a^b^c")
/// d obj.<METHOD>InsertRowData</METHOD>("a1^b2^c3")
/// d obj.<METHOD>InsertRowData</METHOD>("d1^e2^f3")
/// d obj.<METHOD>InsertRowData</METHOD>("h1^g2^l3")
/// d obj.<METHOD>InsertRowData</METHOD>("q1^w2^r3")
/// w obj.<METHOD>WriteJsonData</METHOD>("Result","Root","b^c^c",2,2)
/// </EXAMPLE>
/// <P>Results:
/// <EXAMPLE>
/// <P>{'Result': 4,'Root':[{'b':'e2','c':'f3','c':'f3'},{'b':'g2','c':'l3','c':'l3'}]}
/// </EXAMPLE>
Class Code.JsonData Extends Code.DataStore [ ClassType = serial, ProcedureBlock ]
{

/// <P>构造函数，InitFiled按照自定义的分隔符分隔，Delimiter为自定义的分隔符
Method %OnNew(InitFiled, Delimiter As %String = "^") As %Status
{
	q:InitFiled="" 0
	s i%Delimiter=Delimiter
	s ColCount=$l(InitFiled,Delimiter)	
	s i%ColSize=ColCount
	s i%ColField=InitFiled
	q 1
}

Method GetJsonData(MappingField As %String = "", Start As %Integer = 1, End As %Integer = 1) As %String [ Private ]
{
	s str=""
	s MappingSize=$l(MappingField,i%Delimiter)

	f i=Start:1:End
	{
		i str="" s str="{"
		e  s str=str_"{"
		s RowData=..GetAt(i)
		f j=1:1:MappingSize
		{
			s ColFields=$p(MappingField,i%Delimiter,j)
			s ColField=$p(ColFields,":",1)
			s ColNumber=$p(ColFields,":",2)
			
			i j=1 s str=str_"'"_ColField_"':'"_$p(RowData,i%Delimiter,ColNumber)_"'"
			e  s str=str_",'"_ColField_"':'"_$p(RowData,i%Delimiter,ColNumber)_"'"
		}
		s str=str_"}"
		i i'=End s str=str_","
	}
	q str
}

/// 输出json的方法
/// 
/// <P>MappingField的三种格式,按照定义的<Property>Delimiter</Property>分隔:
/// <P>空即按照定义的列名输出
/// <P>不带:号，按照顺序输出自定义的字段
/// <P>带:号，前面为输出的字段名，后面为mapping的字段名
/// 
/// Start开始的行，默认从第一行开始
/// Limit限制的行数，默认为0，则Limit没有限制
Method WriteJsonData(TotalProperty As %String = "results", Root As %String = "root", MappingField As %String = "", Start As %Integer = 1, Limit As %Integer = 0, Total As %Integer = 0) As %String
{
	q:(Start>i%Size) ""
	i ((Limit+Start-1)>i%Size)!(Limit=0) s End=i%Size
	e  s End=Limit+Start-1
	i Total=0 s Total=i%Size
	s Field=""
	i MappingField="" {
		for i=1:1:i%ColSize
		{
			i Field="" s Field=$p(i%ColField,i%Delimiter,i)_":"_i
			e  s Field=Field_i%Delimiter_$p(i%ColField,i%Delimiter,i)_":"_i
		}
	}
	else{
		for i=1:1:$l(MappingField,i%Delimiter)
		{
			s ColFields=$p(MappingField,i%Delimiter,i)
			s ColField=$p(ColFields,":",1)
			s Map=$p(ColFields,":",2)
			i Map="" s Map=ColField
			s ColNumber=+..FindColNumber(Map)
			i Field="" s Field=ColField_":"_ColNumber
			e  s Field=Field_i%Delimiter_ColField_":"_ColNumber

		}
	
	}
	//q "{'"_TotalProperty_"': "_i%Size_",'"_Root_"':["_..GetJsonData(Field,Start,End)_"]}"
	q "{'"_TotalProperty_"': "_Total_",'"_Root_"':["_..GetJsonData(Field,Start,End)_"]}"
}

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}
