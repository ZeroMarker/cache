Class web.DHCENS.STBLL.MDM.ArcItmMast Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：liyan
/// CreatDate：2022-09-27
/// 主数据管理平台2.0  获取医嘱大类消息格式（Json）
/// Others：w ##class(web.DHCENS.STBLL.MDM.ArcItmMast).OrderCategory(1)
ClassMethod OrderCategory(ordCategoryRowId As %String = "") As %GlobalCharacterStream
{
	s retStream=##class(%GlobalCharacterStream).%New()
	s mainJson=##class(%DynamicObject).%New()
	s reqJson=##class(%DynamicObject).%New()
	s dataArr=##class(%DynamicArray).%New()
	if +ordCategoryRowId=0 {
		s json=##class(%DynamicObject).%New()
		d dataArr.%Push(json)
		s reqJson.data=dataArr
		s reqJson.tableCode="CT_Category"
		s mainJson.request=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Write(jsonStr)
		q retStream
		}
	try{
		s status="",code="",sourcerowid="",originalDesc="",release="1",description="",createDate="",createTime="",businessrowid=""
		s businessFieldCode="BF00001",hosCode="",startDate="",endDate="",version="",system="",ordCategoryCode="",ordCategoryDesc="",codeSystemCode="CT_Category"
		s lastUpdateDate="",lastUpdateTime="",lastUpdateUser="demo"
		s ordCategoryCode=$p($g(^OEC("ORCAT",ordCategoryRowId)),"^",1)
		s ordCategoryDesc=$p($g(^OEC("ORCAT",ordCategoryRowId)),"^",2)
		s sourcerowid=ordCategoryRowId
		s businessrowid=businessFieldCode_"_"_sourcerowid
		s json=##class(%DynamicObject).%New()
		d json.%Set("BusinessFieldCode",businessFieldCode)
		d json.%Set("CTC_Status",1)
		d json.%Set("code",ordCategoryCode)
		d json.%Set("sourcerowid",sourcerowid)
		d json.%Set("CTC_OriginalCode",ordCategoryCode)
		d json.%Set("CTC_OriginalDesc",ordCategoryDesc)
		d json.%Set("description",ordCategoryDesc)
		d json.%Set("CTC_CreatDate","")
		d json.%Set("CTC_CreatTime","")
		d json.%Set("CTC_Code",ordCategoryCode)
		d json.%Set("CTC_Desc",ordCategoryDesc)
		d json.%Set("release",release)
		d json.%Set("CTC_UpdateDate",$ZD(+$h,3))
		d json.%Set("CTC_UpdateTime",$ZT($p($h,",",2),1))
		d json.%Set("CTC_UpdateUserCode","")
		d json.%Set("businessrowid",businessrowid)
		d json.%Set("CTC_HosCode","")
		d json.%Set("BusinessFieldCode",businessFieldCode)
		d json.%Set("CTC_StartDate","")
		d json.%Set("CTC_EndDate","")
		d json.%Set("version","")
		d json.%Set("system","SSIS00008")
		d json.%Set("CTC_Remarks","")
		d json.%Set("CTC_CodesystemCode","CT_Category")
		d dataArr.%Push(json)
		s reqJson.data=dataArr
		s reqJson.tableCode="CT_Category"
		s mainJson.request=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Write(jsonStr)
	}
	catch{
		s json=##class(%DynamicObject).%New()
		d dataArr.%Push(json)
		s reqJson.data=dataArr
		s reqJson.tableCode="CT_Category"
		s mainJson.request=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Write(jsonStr)			
		}
	q retStream
}

}
