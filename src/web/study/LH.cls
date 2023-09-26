Class web.study.LH Extends %RegisteredObject
{

ClassMethod GetPAADMSex(RowID As %String)
{
	q:RowID="" "RowID不能为空"
	q:'$d(^PAADM(RowID)) "数据不存在"
	&sql(
	SELECT PAADM_PAPMI_DR->PAPMI_Sex_DR->CTSEX_Desc,PAADM_RowID 
	INTO :CTSEXDesc,:PAADMRowID 
	FROM PA_Adm WHERE PAADM_RowID=:RowID
	)
	if (SQLCODE=0)
	{
		q "RowID为"_PAADMRowID_"的就诊病人的性别为"_CTSEXDesc
	}
	else
	{
		q "查询失败"
	}
}

}
