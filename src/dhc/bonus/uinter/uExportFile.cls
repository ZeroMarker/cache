Class dhc.bonus.uinter.uExportFile Extends %SerialObject
{

ClassMethod ExportFile(fdate, tdate) As %String
{
	s file="/tmp/shouru1304.txt"
	o file:"WNS"
	u file
	w "病案号^医嘱日期^医嘱时间^收费项目ID^收费项目名称^数量^单价^开单科室^接收科室"
	&sql(declare baoshi cursor for
		select b.PAPMI_Medicare as 病案号,a.WorkLoad_OrdDate as 医嘱日期,a.WorkLoad_OrdTime as 医嘱时间,a.WorkLoad_TarItem_DR as 收费项id
			,a.WorkLoad_TarItem_DR->TARI_Desc as 收费项名称,a.WorkLoad_Quantity as 数量,a.WorkLoad_UnitPrice as 单价,a.WorkLoad_PatDep_DR->ctloc_desc as 开单科室
			,a.WorkLoad_RecDep_DR->ctloc_desc as 接收科室 
		into:a1,a2,a3,a4,a5,a6,a7,a8,a9 
		from sqluser.dhc_workload a, sqluser.pa_patmas b 
		where a.WorkLoad_PAPMI_DR=b.PAPMI_RowId1 and a.WorkLoad_Type='I' 
			and a.WorkLoad_OrdDate>=:fdate and a.WorkLoad_OrdDate<=:tdate
	)
	&sql(open baoshi)
	f  &sql(fetch baoshi)  q:SQLCODE  d
	.w !,a1_"^"_$zd(a2,3)_"^"_$zt(a3,3)_"^"_a4_"^"_a5_"^"_a6_"^"_a7_"^"_a8_"^"_a9
	&sql(close baoshi)
  	c file
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.uinter.uExportFileS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
