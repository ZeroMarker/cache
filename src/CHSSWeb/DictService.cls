Class CHSSWeb.DictService Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

ClassMethod ListPage1(Start, Limit, TableName) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowId,Code,Description,StartDate,EndDate,Active,Sort FROM CHSS."_TableName_" "
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s Rowid = result.Data("RowId")
	s Code = result.Data("Code")
	s Description = result.Data("Description")
	s StartDate = result.Data("StartDate")
	i (StartDate'="") d
	.s StartDate = $zd(StartDate,3)
	s EndDate = result.Data("EndDate")
	i (EndDate'="") d
	.s EndDate = $zd(EndDate,3)
	s Active = "true"
	s Sort = ""
	s tmp=Rowid_"^"_Code_"^"_Description_"^"_StartDate_"^"_EndDate_"^"_Active_"^"_Sort

	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	.
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Description^StartDate^EndDate^Active^Sort",count)
	k json
	q resultString
}

ClassMethod insert(Code, Description, StartDate, EndDate, Active, Sort, TableName) As %String
{
	//调用方法：d ##class(CBCS.CBCS.UDHCCAHospital).insert("001","医院","Y")
	
	//code重复不允许插入
	//name重复不允许插入
	
	s rowId=""
	//s rowId=..rCode(code)
	//q:rowId'="0" "code-rep"
	//s rowId=..rName(Description)
	//q:rowId'="" "name-rep"
	
	//i (active'="Y")||(active'="N") s active="Y"
	i StartDate '= "" d
	.s StartDate=$zdh(StartDate,3)
    e  d
    . s StartDate="null"
	i EndDate '= "" d
	.s EndDate=$zdh(EndDate,3)
    e  d
    . s EndDate="null"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "insert into CHSS."_TableName_" (Code,Description,StartDate,EndDate,Active,Sort) values ('"_Code_"','"_Description_"',"_StartDate_","_EndDate_",'"_Active_"','"_Sort_"')"

	d result.Prepare(sqlStr)
	s SQLCODE = result.Execute()
	k result
	q SQLCODE
}

ClassMethod update(RowId, Code, Description, StartDate, EndDate, Active, Sort, TableName) As %String
{
	//调用方法：d ##class(CBCS.UDHCCAHospital).update(1,"001","医院","Y")
	
	//code重复不允许修改
	//name重复不允许修改
	//
	//
  
   //s ^TMP("wangbo")=RowId_","_Code_","_Description_","_StartDate_","_EndDate_","_Active_","_Sort_","_TableName
	/*
	s rowId=""
	s rowId=..rCode(code)
	q:(rowId'="")&(rowId'=dr) "code-rep" //rowId不为空且rowId'=dr不可以修改
	s rowId=..rName(name)
	q:(rowId'="")&(rowId'=dr) "name-rep"
	*/
	q:(RowId="") "code-rep"
	i StartDate '= "" d
	.s StartDate=$zdh(StartDate,3)
    e  d
    . s StartDate="null"
	i EndDate '= "" d
	.s EndDate=$zdh(EndDate,3)
    e  d
    . s EndDate="null"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "update CHSS."_TableName_" set Code='"_Code_"',Description='"_Description_"',StartDate="_StartDate_",EndDate="_EndDate_",Active='"_Active_"',Sort='"_Sort_"' where %ID = "_RowId

	d result.Prepare(sqlStr)
	s SQLCODE = result.Execute()
	k result
	q SQLCODE
}

//删除一条数据库中已经存在的记录

ClassMethod delete(RowId, TableName) As %String
{
	//&sql(delete from CHSS.DictDentition where %ID=:RowId)
	//q SQLCODE
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "delete from CHSS."_TableName_" where RowId = "_RowId
	d result.Prepare(sqlStr)
	s SQLCODE = result.Execute()
	k result
	q SQLCODE
}

ClassMethod insertFromExcel() As %String
{
	//调用方法：d ##class(CBCS.CBCS.UDHCCAHospital).insert("001","医院","Y")
	
	//code重复不允许插入
	//name重复不允许插入
	
	s rowId=""
	s TableName = ""
	s Code = ""
	s Description = ""
	s StartDate = ""
	s EndDate = ""
	s Active = ""
	s Sort = ""
	
	//q:rowId'="0" "code-rep"
	//s rowId=..rName(Description)
	//q:rowId'="" "name-rep"

	s id=0
	
 	f  s id=$o(^FHQIQIQCHSS(id)) q:id=""  d
    .s str=$g(^FHQIQIQCHSS(id))
	.s TableName=$p(str,"^",1)
	.s Code=$p(str,"^",2)
	.s Description=$p(str,"^",3)
	.s StartDate=$p(str,"^",4)
	.s EndDate=$p(str,"^",5)
	.//s Active=$p(str,"^",6)
	.//s Sort=$p(str,"^",7)
	.i StartDate '= "" d
	..s StartDate=$zdh(StartDate,3)
    .e  d
    .. s StartDate="null"
	.i EndDate '= "" d
	..s EndDate=$zdh(EndDate,3)
    .e  d
    .. s EndDate="null"
    .s rowcode=..rcode(0,Code,TableName,"add")
    .
    .i rowcode '= "1" d
	..s result = ##class(%Library.ResultSet).%New()
	..s sqlStr = "insert into CHSS."_TableName_" (Code,Description,StartDate,EndDate,Active,Sort) values ('"_Code_"','"_Description_"',"_StartDate_","_EndDate_",'true','1')"
	..d result.Prepare(sqlStr)
	..s SQLCODE = result.Execute()
	.
	q SQLCODE
}

ClassMethod rDescription(RowId, rDescription, TableName, RecordType) As %String
{
	n (RowId, rCode, TableName,RecordType)
		set count = 0
		set tempRowId = 0
		Set json = ##class(Code.JsonObj).%New()
		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT Description FROM CHSS."_TableName_" where Description = '"_rDescription_"' "

		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
			if (RecordType = "edit")
			{
				set tempRowId = result.Get("RowId")
			}
			s count = count + 1
		}
		if (RecordType = "add")
		{
			if (count>0)
			{
				q "1"
			}
			elseif (count=0)
			{
				q "0"
			}
		}
		elseif (RecordType = "edit")
		{
			if (count=1 && (RowId '= tempRowId))
			{
				q "1"
			}
			elseif (count>1)
			{
				q "1"
			}
			else
			{
				q "0"
			}
		}
}

ClassMethod rcode(RowId, rCode, TableName, RecordType) As %String
{
	n (RowId, rCode, TableName,RecordType)
		set count = 0
		set tempRowId = 0
		Set json = ##class(Code.JsonObj).%New()
		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT Code FROM CHSS."_TableName_" where Code = '"_rCode_"' "

		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
			if (RecordType = "edit")
			{
				set tempRowId = result.Get("RowId")
			}
			s count = count + 1
		}
		if (RecordType = "add")
		{
			if (count>0)
			{
				q "1"
			}
			elseif (count=0)
			{
				q "0"
			}
		}
		elseif (RecordType = "edit")
		{
			if (count=1 && (RowId '= tempRowId))
			{
				q "1"
			}
			elseif (count>1)
			{
				q "1"
			}
			else
			{
				q "0"
			}
		}
}

ClassMethod ReadFromExcel() As %String
{
	Set stream=##class(%FileCharacterStream).%New()
	;If ##class(%File).Exists("file.txt")
	s file = "D:\AllDict.csv"
	Set stream.Filename=file
	s count=0
	s lenFlag=0
	s CountFlag=0
	s mess=""
	s errFlag=0
	
	s TableName = ""
	s Code = ""
	s Description = ""

	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		;w line,!
		; Process the line here
		If (line'=""){
			s count=count+1
			s len=$LENGTH(line,",")
			If (len<3) {
				s lenFlag=1
				s mess=mess_"第"_count_"条数据长度: "_len_" 小于4, 请核实!"
				s errFlag=1
				continue
			}
			s TableName=$p(line,",",1)
			if (TableName="") {
				s mess=mess_"第"_count_"条数据中表名为空, 请核实!"
				s errFlag=1
				continue
			}
			s Code=$p(line,",",2)
			if (Code="") {
				s mess=mess_"第"_count_"条数据中代码为空, 请核实!"
				s errFlag=1
				continue
			}
			s Description=$p(line,",",3)
			if (Description="") {
				s mess=mess_"第"_count_"条数据中描述为空, 请核实!"
				s errFlag=1
				continue
			}
			s Type=$p(line,",",4)
			if (Type="" && Type = "DictDrug") {
				s mess=mess_"第"_count_"条数据中描述为空, 请核实!"
				s errFlag=1
				continue
			}
			s TableType=$p(line,",",5)
			if (Type="" && TableType = "DictChronicSymptom") {
				s mess=mess_"第"_count_"条数据中描述为空, 请核实!"
				s errFlag=1
				continue
			}
			If (errFlag=0)&(count'=0){
				;清除所有数据
				;s result = ##class(%Library.ResultSet).%New()
				;s sqlStr = "delete from CHSS."_TableName
				;d result.Prepare(sqlStr)
				;s SQLCODE = result.Execute()
				;w "delete "_TableName_"^"_Description,!
				;判断名称是否重复
				s rowDescription=..rcode(0,Description,TableName,"add")
				if (rowDescription '= "1")
				{
					s rowcode=..rcode(0,Code,TableName,"add")
					if (rowcode '= "1")
					{
						s sqlStr = ""
						s result = ##class(%Library.ResultSet).%New()
						i TableName = "DictDrug" d
						.s sqlStr = "insert into CHSS."_TableName_" (Code,Description,StartDate,EndDate,Active,Sort,Type) values ('"_Code_"','"_Description_"',null,null,'true','1',"_Type_")"
						e  i TableName = "DictChronicSymptom" d
						.s sqlStr = "insert into CHSS."_TableName_" (Code,Description,StartDate,EndDate,Active,Sort,Type,TableName) values ('"_Code_"','"_Description_"',null,null,'true','1',"_Type_",'"_TableType_"')"
						e  d
						.s sqlStr = "insert into CHSS."_TableName_" (Code,Description,StartDate,EndDate,Active,Sort) values ('"_Code_"','"_Description_"',null,null,'true','1')"
						
						d result.Prepare(sqlStr)
						s SQLCODE = result.Execute()
						w "insert "_TableName_"^"_Description,!
					}
					elseif (rowcode = "1")
					{
						s sqlStr = ""
						s result = ##class(%Library.ResultSet).%New()
						i TableName = "DictDrug" d
						.s sqlStr = "update CHSS."_TableName_" set Description = '"_Description_"', Type = "_Type_" where Code = '"_Code_"'"
						e  i TableName = "DictChronicSymptom" d
						.s sqlStr = "update CHSS."_TableName_" set Description = '"_Description_"', Type = "_Type_", TableName = '"_TableType_"' where Code = '"_Code_"'"
						e  d
						.s sqlStr = "update CHSS."_TableName_" set Description = '"_Description_"' where Code = '"_Code_"'"
						d result.Prepare(sqlStr)
						s SQLCODE = result.Execute()
						w "update "_TableName_"^"_Description,!
					}
				}
				
			}
		}
			
		

	}
	k stream
}

ClassMethod ReadDictDrugFromExcel() As %String
{
	Set stream=##class(%FileCharacterStream).%New()
	;If ##class(%File).Exists("file.txt")
	s file = "D:\AllDictDrug.csv"
	Set stream.Filename=file
	s count=0
	s lenFlag=0
	s CountFlag=0
	s mess=""
	s errFlag=0
	
	s TableName = ""
	s Code = ""
	s Description = ""

	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		;w line,!
		; Process the line here
		If (line'=""){
			s count=count+1
			s len=$LENGTH(line,",")
			If (len<3) {
				s lenFlag=1
				s mess=mess_"第"_count_"条数据长度: "_len_" 小于4, 请核实!"
				s errFlag=1
				continue
			}
			s TableName=$p(line,",",1)
			if (TableName="") {
				s mess=mess_"第"_count_"条数据中表名为空, 请核实!"
				s errFlag=1
				continue
			}
			s Code=$p(line,",",2)
			if (Code="") {
				s mess=mess_"第"_count_"条数据中代码为空, 请核实!"
				s errFlag=1
				continue
			}
			s Description=$p(line,",",3)
			if (Description="") {
				s mess=mess_"第"_count_"条数据中描述为空, 请核实!"
				s errFlag=1
				continue
			}
			s Type=$p(line,",",4)
			if (Type="") {
				s mess=mess_"第"_count_"条数据中描述为空, 请核实!"
				s errFlag=1
				continue
			}
			If (errFlag=0)&(count'=0){
				;清除所有数据
				;s result = ##class(%Library.ResultSet).%New()
				;s sqlStr = "delete from CHSS."_TableName
				;d result.Prepare(sqlStr)
				;s SQLCODE = result.Execute()
				;w "delete "_TableName_"^"_Description,!
				;判断名称是否重复
				s rowDescription=..rcode(0,Description,TableName,"add")
				if (rowDescription '= "1")
				{
					s rowcode=..rcode(0,Code,TableName,"add")
					if (rowcode '= "1")
					{
						s result = ##class(%Library.ResultSet).%New()
						s sqlStr = "insert into CHSS."_TableName_" (Code,Description,StartDate,EndDate,Active,Sort,Type) values ('"_Code_"','"_Description_"',null,null,'true','1',"_Type_")"
						d result.Prepare(sqlStr)
						s SQLCODE = result.Execute()
						w "insert "_TableName_"^"_Description,!
					}
					elseif (rowcode = "1")
					{
						s result = ##class(%Library.ResultSet).%New()
						s sqlStr = "update CHSS."_TableName_" set Description = '"_Description_"', Type = "_Type_" where Code = '"_Code_"'"
						d result.Prepare(sqlStr)
						s SQLCODE = result.Execute()
						w "update "_TableName_"^"_Description,!
					}
				}
				
			}
		}
			
		

	}
	k stream
}

Storage Default
{
<Data name="DictServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.DictServiceD</DataLocation>
<DefaultData>DictServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.DictServiceD</IdLocation>
<IndexLocation>^CHSSWeb.DictServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.DictServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
