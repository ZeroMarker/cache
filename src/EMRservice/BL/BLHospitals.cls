///  名称：		EMRservice.BL.BLHospitals
///  描述：		多院区BL层
///  编写者：	yejian
///  编写时间：	2021-6-25
Class EMRservice.BL.BLHospitals Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       获取所有院区数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     DataSet 返回数据
/// debug d ##class(%ResultSet).RunQuery("EMRservice.BL.BLHospitals","SelectHospitals")
Query SelectHospitals() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,Name:%String,HosGroupID:%String", SELECTMODE = "RUNTIME")
{
	SELECT h.HOSP_RowId,h.HOSP_Code,h.HOSP_Desc,h.HOSP_DefaultHospital_DR FROM SQLUser.CT_Hospital h
	WHERE (h.HOSP_DateTo>=now() AND h.HOSP_DateFrom<=now()) or h.HOSP_DateTo IS NULL OR h.HOSP_DateFrom IS NULL
}

/// Desc:       获取所有科室及院区数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     DataSet 返回数据
/// debug d ##class(%ResultSet).RunQuery("EMRservice.BL.BLHospitals","SelectAllLoc")
Query SelectAllLoc() As %SQLQuery(CONTAINID = 0, ROWSPEC = "rowID:%String,Code:%String,Desc:%String,HosID:%String,HosName:%String")
{
SELECT CTLOC_RowId,CTLOC_CODE,CTLOC_Desc,CTLOC_Hospital_DR->HOSP_RowId,CTLOC_Hospital_DR->HOSP_Desc From SQLUser.CT_Loc  Order By CTLOC_Desc,CTLOC_RowId
}

}
