Class web.DHCPE.Public.HealthRecordDetail Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s desc=$p(InString,"^",1)
	s code=$p(InString,"^",2)
	s type=$p(InString,"^",3)
	s ciname=$p(InString,"^",4)
	s required=$p(InString,"^",5)
	s cascade=$p(InString,"^",6)
	s parent=$p(InString,"^",7)
	s sequence=$p(InString,"^",8)
	s hrrowid=$p(InString,"^",9)
	s hrdrowid=$p(InString,"^",10)
	s rowid=$p(InString,"^",11)

	&sql(insert into sqluser.DHC_PE_HealthRecordDetail (HRD_Code,HRD_Desc,HRD_DisplayType,HRD_ComponentItemName)values(:code,:desc,:type,:ciname))
	&sql(insert into sqluser.DHC_PE_HRDRelate (HRDR_Required,HRDR_Cascade,HRDR_Sequence)values(:required,:cascade,:sequence))
	s distype=$g(type)
	i $g(type)="2"||"3"||"4"||"5"
	.s distype="C"
	i $g(type)="6"
	.s distype="T"
	&sql(insert into websys.ComponentItems (Name,Caption,DisplayType,ParRef)values(:ciname,:desc,:distype,'50921'))
	q
}

ClassMethod ChooseType(ContrlWidth As %String = "") As %String
{
  
    s:(""=ContrlWidth) ContrlWidth="155"            
	w "<select name='类型' id='DisplayType' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value='0'></option>",!
	w "<option value='1'>标题</option>",!
    w "<option value='2'>单选</option>",!
	w "<option value='3'>多选</option>",!
	w "<option value='4'>单选+文本</option>",!
	w "<option value='5'>多选+文本</option>",!
	w "<option value='6'>文本框</option>",!
	w "</select>",!
	Quit $$$OK
}

}
