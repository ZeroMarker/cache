Class web.DHCENS.STBLL.DRUG.METHOD.DrugPackageLab Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod DrugPackageLab(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $zt="SendMessageET"		
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("Request","web.DHCENS.STBLL.DRUG.MODEL.Request")
	set PackageLabList=##class(web.DHCENS.STBLL.DRUG.MODEL.Request).%New()
	set Flag=0,MyRtn=""
	While reader.Next(.obj,.sc) {
		set PackageLabList=obj
		set PackageLabCount=PackageLabList.body.DrugOrdInfos.Count()
		for i=1:1:PackageLabCount
		{
			set PackageLabStr=""
			set PackageLab=##class(web.DHCENS.STBLL.DRUG.MODEL.DrugPackageLab).%New()
			set PackageLab=PackageLabList.body.DrugOrdInfos.GetAt(i)
			set PackageLabStr=PackageLab.DrugPackageLab_"^"_PackageLab.OrdRowID_"^"_PackageLab.OccDate_"^"_PackageLab.OccTime	
			s PackageLab.OccDate=$zdh(PackageLab.OccDate,5)
			s PackageLab.OccDate=$zd(PackageLab.OccDate,3)
			if (PackageLab.OccTime="88:88")||(PackageLab.OrdRowID="||") 
			{
				s Flag="-1"
			}
			//调用护士站接口
			if Flag=0
			{
				set MyRtn=##class(Nur.MedicineBagInfo).Save(PackageLab.DrugPackageLab,PackageLab.OrdRowID,PackageLab.OccDate,PackageLab.OccTime)
				if MyRtn<1
				{
					set Flag=-1
				}
			}
			
		}
	}
	
	set ResultObj=##class(web.DHCENS.STBLL.DRUG.MODEL.ResultString).%New()
	if MyRtn>"0"
	{
		set ResultObj.ResultCode="0"
		set ResultObj.ResultContent="成功"
	}
	else
	{
		set ResultObj.ResultCode="-1"
		set ResultObj.ResultContent="更新失败"
	}
	d ResultObj.XMLExportToStream(.stream)
	Quit stream
SendMessageET
	set ResultObj=##class(web.DHCENS.STBLL.DRUG.MODEL.ResultString).%New()
	set ResultObj.ResultCode="-1"
	set ResultObj.ResultContent=$ze
	d ResultObj.XMLExportToStream(.stream)
	Quit stream
}

/// w ##class(web.DHCENS.STBLL.DRUG.METHOD.DrugPackageLab).Test()
ClassMethod Test() As %String
{
	s input="<Request><Header><SourceSystem>SYS0007</SourceSystem><MessageID></MessageID></Header><Body><DrugOrdInfos><DrugOrdInfo><DrugPackageLab>201909160001</DrugPackageLab><OccDate>2019-09-16</OccDate><OccTime>15:00:02</OccTime><OrdRowID>988||1</OrdRowID></DrugOrdInfo></DrugOrdInfos></Body></Request>"
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(input)
	s rtn=..DrugPackageLab(stream)
	q rtn
}

}
