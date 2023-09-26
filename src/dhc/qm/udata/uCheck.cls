Class dhc.qm.udata.uCheck Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others:w ##class(dhc.qm.udata.uCheck).IfRepCode("code")
ClassMethod IfRepCode(CheckCode) As %String
{
	new (CheckCode)
	s rowid=0
	s rowid=$o(^DHCCJXQMCheckI("CheckCode",CheckCode,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Others:w ##class(dhc.qm.udata.uCheck).IfRepName("name")
ClassMethod IfRepName(CheckName) As %String
{
	new (CheckName)
	s rowid=0
	s rowid=$o(^DHCCJXQMCheckI("CheckName",CheckName,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Others:w ##class(dhc.qm.udata.uCheck).List("", "", 0, 15)
ClassMethod List(sortField, sortDir, start, limit) As %String
{
	n (sortField,sortDir,start,limit)
	s sqlStr="SELECT Check_rowid, Check_code, Check_name, Check_locType, Check_colType, Check_AssessType, Check_desc, Check_active, Check_photo, Check_spcil, Check_ObjectType,Check_comp FROM dhc_qm_data.CheckInfo "
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()

	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name^loctype^coltype^assesstype^desc^active^photo^spcil^objecttype^comp"
	While(result.Next())
	{
	s rowid= result.Data("Check_rowid")
	s code= result.Data("Check_code")
	s name= result.Data("Check_name")
	s loctype= result.Data("Check_locType")
	s coltype= result.Data("Check_colType")
	s assesstype= result.Data("Check_AssessType")
	s desc= result.Data("Check_desc")
	s active= result.Data("Check_active")
	s photo= result.Data("Check_photo")
	s spcil= result.Data("Check_spcil")
	s objecttype= result.Data("Check_ObjectType")
	s comp= result.Data("Check_comp")

	s temp=rowid_"^"_code_"^"_name_"^"_loctype_"^"_coltype_"^"_assesstype_"^"_desc_"^"_active_"^"_photo_"^"_spcil_"^"_objecttype_"^"_comp
	i (count>=start)&(count<=end) d
	.d json.InsertRowData(temp)
	s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// Others:w ##class(dhc.qm.udata.uCheck).InsertRec("code","name",1,1,1,"desc","Y","Y","Y",1)
ClassMethod InsertRec(code, name, loctype, coltype, assesstype, desc, active, photo, spcil, objecttype, checkComp) As %String
{
	n (code,name,loctype,coltype,assesstype,desc,active,photo,spcil,objecttype,checkComp)

	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"

	s rowid=0
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"

	&sql(INSERT INTO dhc_qm_data.CheckInfo VALUES (:code,:name,:loctype,:coltype,:assesstype,:desc,:active,:photo,:spcil,:objecttype,:checkComp ))

	q SQLCODE
}

/// Others:w ##class(dhc.qm.udata.uCheck).UpdateRec("1","","","2","","","","","","","","")
ClassMethod UpdateRec(rowid, code, name, loctype, coltype, assesstype, desc, active, photo, spcil, objecttype, checkComp) As %String
{
	n (rowid,code,name,loctype,coltype,assesstype,desc,active,photo,spcil,objecttype,checkComp)

	i code'=""
	{
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	}

	i name'=""
	{
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepName"
	}
    /*
 	i code =""  s Plist(2) = $list(^DHCCJXQMCheckD(rowid),2)
 	i name =""  s Plist(3) = $list(^DHCCJXQMCheckD(rowid),3)
 	i loctype =""  s Plist(4) = $list(^DHCCJXQMCheckD(rowid),4)
 	i coltype =""  s Plist(5) = $list(^DHCCJXQMCheckD(rowid),5)
 	i assesstype =""  s Plist(6) = $list(^DHCCJXQMCheckD(rowid),6)
 	i desc =""  s Plist(7) = $list(^DHCCJXQMCheckD(rowid),7)
 	i active =""  s Plist(8) = $list(^DHCCJXQMCheckD(rowid),8)
 	i photo =""  s Plist(9) = $list(^DHCCJXQMCheckD(rowid),9)
 	i spcil =""  s Plist(10) = $list(^DHCCJXQMCheckD(rowid),10)
 	i objecttype =""  s Plist(11) = $list(^DHCCJXQMCheckD(rowid),11)
 	*/
 	i code '=""  s Plist(2) = code
 	i name '=""  s Plist(3) = name
 	i loctype '=""  s Plist(4) = loctype
 	i coltype '=""  s Plist(5) = coltype
 	i assesstype '=""  s Plist(6) = assesstype
 	i desc '=""  s Plist(7) = desc
 	i active '=""  s Plist(8) = active
 	i photo '=""  s Plist(9) = photo
 	i spcil '=""  s Plist(10) = spcil
 	i objecttype '=""  s Plist(11) = objecttype
 	i checkComp '=""  s Plist(12) = checkComp
 	
	&sql(UPDATE dhc_qm_data.CheckInfo VALUES Plist() where %ID=:rowid)
	q SQLCODE
}

/// Others:w ##class(dhc.qm.udata.uCheck).Delete(1)
ClassMethod Delete(rowid) As %String
{
	&sql( DELETE FROM dhc_qm_data.CheckInfo WHERE %ID=:rowid)

	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.qm.udata.uCheckS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
