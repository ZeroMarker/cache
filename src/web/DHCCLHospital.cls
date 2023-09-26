Class web.DHCCLHospital Extends %RegisteredObject
{

ClassMethod InsertHospital(code As %String, name As %String) As %String
{
	q:name="" "名称不能为空"
	s ret="0"
	s hosId="" 
	f  s hosId=$O(^DHCCLC("Hospital",hosId)) q:hosId=""  d
		.s codeC=$li(^DHCCLC("Hospital",hosId),1)
		.i codeC=code s ret="代码重复"
		.s nameC=$li(^DHCCLC("Hospital",hosId),2)
		.i nameC=name s ret="名称重复"
	q:ret'="0" ret
		&Sql(insert into SQLUser.DHC_CL_Hospital(HOSP_Code,HOSP_Desc) values(:code, :name))
		
		i SQLCODE'=0 q "增加医院失败"
		
		q "0"
}

ClassMethod UpdateHospital(rowId As %String, code As %String, name As %String) As %String
{
		q:rowId="" "请选择一条记录更新"
		q:name="" "名称不能为空"
	s ret="0"
	s hosId="" 
	f  s hosId=$O(^DHCCLC("Hospital",hosId)) q:hosId=""  d
		.s codeC=$li(^DHCCLC("Hospital",hosId),1)
		.i (codeC=code)&(rowId'=hosId) s ret="代码重复"
		.s nameC=$li(^DHCCLC("Hospital",hosId),2)
		.i (nameC=name)&(rowId'=hosId) s ret="名称重复"
	q:ret'="0" ret
		&Sql(update SQLUser.DHC_CL_Hospital set HOSP_Code=:code,HOSP_Desc=:name where HOSP_RowId=:rowId)
		
		i SQLCODE'=0 q "更新医院失败"
		
		q "0"
}

ClassMethod DeleteHospital(rowId As %String)
{
		 q:rowId="" "请选择一条记录删除"
		 
		 &Sql(delete from SQLUser.DHC_CL_Hospital where HOSP_RowId=:rowId)
		 
		 i SQLCODE'=0 q "删除医院失败"
		
		 q "0"
}

Query FindHospital(code As %String = "", name As %String = "") As %Query(ROWSPEC = "RowId:%String,Code:%String,Name:%String")
{
}

ClassMethod FindHospitalExecute(ByRef qHandle As %Binary, code As %String = "", name As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s rowId=""
 	f  s rowId = $o(^DHCCLC("Hospital",rowId)) q:rowId=""  d
 	.s hos = ^DHCCLC("Hospital",rowId)
 	.s tcode = $list(hos,1)
 	.q:(code'="")&($$UPPER^SSUTIL4(tcode)'[$$UPPER^SSUTIL4(code))
 	.s tname = $list(hos,2)
 	.q:(name'="")&($$UPPER^SSUTIL4(tname)'[$$UPPER^SSUTIL4(name))
 	.d OutPut
 	s qHandle=$lb(0,repid,0)
	q $$$OK
OutPut
 	s Data=$lb(rowId,tcode,tname)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod FindHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHospitalExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {			
 		s Row=^CacheTemp(repid,ind)
 		//w "<b>"_$List(Row,3)_"</b>"
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHospitalExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

}
