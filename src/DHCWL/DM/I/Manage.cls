Class DHCWL.DM.I.Manage Extends %RegisteredObject
{

// s status=##class(DHCWL.DM.I.Manage).ShutdownService()

ClassMethod ShutdownService()
{
	s httpRequest=##class(DHCWL.DM.Util.HttpUtil).GetHttpRequest()
	s status= httpRequest.Get("/dm/manage/service/stop",2)
	if (status=$$$OK){
	  s response=httpRequest.HttpResponse
	  w response.Data.ReadLine()
	  q status
  }else{
	  q $$$ERROR("Request "_httpRequest.Server_":"_httpRequest.Port_"/dm/dim/data/manual is error,message is "_httpRequest.HttpResponse.Data.WriteLine())
  }
}

ClassMethod ThemeTask()
{
	s httpRequest=##class(DHCWL.DM.Util.HttpUtil).GetHttpRequest()
	/*
	s list= ##class(DHCWL.DM.T.ThemeBase).GetAll()
	f i=1:1:list.Count(){
	  s theme=list.GetAt(i)
	  s path=theme.GetPath()
	  d httpRequest.InsertParam("themePath",path)
	}
	*/
	d httpRequest.InsertParam("themePath","/DHCMRInfo.t")
	d httpRequest.InsertParam("dateExpression","N-7")
	s status= httpRequest.Get("/dm/theme/data/schedule",2)
	if (status=$$$OK){
	  s response=httpRequest.HttpResponse
	  s rstatus=response.Data.ReadLine()
	  i rstatus'="1"{
		  q $$$ERROR("Request "_httpRequest.Server_":"_httpRequest.Port_"/dm/theme/data/schedule is error,message is "_rstatus) 
	  }else{
		  q status
	  }
  }else{
	  q $$$ERROR("Request "_httpRequest.Server_":"_httpRequest.Port_"/dm/theme/data/schedule is error,message is "_httpRequest.HttpResponse.Data.WriteLine())
  }
}

// s status=##class(DHCWL.DM.I.Manage).ThemeDataManualBuild("/DHCMRInfo.t","2016-03-09","2016-03-09")

ClassMethod ThemeDataManualBuild(theme, startDate, endDate = "", rebuild As %Boolean = 0)
{
	q:(theme="")||(startDate="") $$$OK
	s:endDate="" endDate=startDate
	s status=$$$OK
	s sd=$zdh(startDate,3),ed=$zdh(endDate,3)
	f i=sd:1:ed{
		q:status'=$$$OK
		s date=$zd(i,3)
		s httpRequest=##class(DHCWL.DM.Util.HttpUtil).GetHttpRequest()
		d httpRequest.InsertParam("themePath",theme)
		d httpRequest.InsertParam("date",date)
		;d httpRequest.InsertParam("rebuild",rebuild)
		s status= httpRequest.Get("/dm/theme/data/manual",2)
		w "themePath:"_theme_"  date:"_date,!
		if (status=$$$OK){
		  s response=httpRequest.HttpResponse
		  s rstatus=response.Data.ReadLine()
		  i rstatus'="1"{
			  s status= $$$ERROR("Request "_httpRequest.Server_":"_httpRequest.Port_"/dm/theme/data/manual is error,message is "_rstatus) 
		  }
	  }else{
		  s status= $$$ERROR("Request "_httpRequest.Server_":"_httpRequest.Port_"/dm/theme/data/manual is error,message is "_httpRequest.HttpResponse.Data.WriteLine())
	  }
	}
	q status
}

// s status=##class(DHCWL.DM.I.Manage).ThemeDataDelete("/DHCMRInfo.t","2016-03-09","2016-03-09")

ClassMethod ThemeDataDelete(theme, startDate, endDate = "")
{
	q:(theme="")||(startDate="") $$$OK
	s:endDate="" endDate=startDate
	s status=$$$OK
	s sd=$zdh(startDate,3),ed=$zdh(endDate,3)
	f i=sd:1:ed{
		q:status'=$$$OK
		s date=$zd(i,3)
		s httpRequest=##class(DHCWL.DM.Util.HttpUtil).GetHttpRequest()
		d httpRequest.InsertParam("themePath",theme)
		d httpRequest.InsertParam("date",date)
		s status= httpRequest.Get("/dm/theme/data/delete",2)
		if (status=$$$OK){
		  s response=httpRequest.HttpResponse
		  s rstatus=response.Data.ReadLine()
		  i rstatus'="1"{
			  s status= $$$ERROR("Request "_httpRequest.Server_":"_httpRequest.Port_"/dm/theme/data/manual is error,message is "_rstatus) 
		  }
	  }else{
		  s status= $$$ERROR("Request "_httpRequest.Server_":"_httpRequest.Port_"/dm/theme/data/manual is error,message is "_httpRequest.HttpResponse.Data.WriteLine())
	  }
	}
	q status
}

// s status=##class(DHCWL.DM.I.Manage).CubeDataManualBuild("DHCWorkLoad_OrdDate","2016-06-22","2016-06-22")

ClassMethod CubeDataManualBuild(cubeCode, startDate, endDate = "", rebuild As %Boolean = 0)
{
	q:(cubeCode="")||(startDate="") $$$OK
	s:endDate="" endDate=startDate
	s status=$$$OK
	s sd=$zdh(startDate,3),ed=$zdh(endDate,3)
	f i=sd:1:ed{
		q:status'=$$$OK
		s date=$zd(i,3)
		s httpRequest=##class(DHCWL.DM.Util.HttpUtil).GetHttpRequest()
		d httpRequest.InsertParam("cubeCode",cubeCode)
		d httpRequest.InsertParam("date",date)
		d httpRequest.InsertParam("rebuild",rebuild)
		s status= httpRequest.Get("/dm/theme/data/cube/buildData",2)
		if (status=$$$OK){
		  s response=httpRequest.HttpResponse
		  s rstatus=response.Data.ReadLine()
		  i rstatus'="1"{
			  s status= $$$ERROR("Request "_httpRequest.Server_":"_httpRequest.Port_"/dm/theme/data/cube/buildData is error,message is "_rstatus) 
		  }
	  }else{
		  s status= $$$ERROR("Request "_httpRequest.Server_":"_httpRequest.Port_"/dm/theme/data/cube/buildData is error,message is "_httpRequest.HttpResponse.Data.WriteLine())
	  }
	}
	q status
}

// s status=##class(DHCWL.DM.I.Manage).DimDataTask()

ClassMethod DimDataTask()
{
	s httpRequest=##class(DHCWL.DM.Util.HttpUtil).GetHttpRequest()
	s status= httpRequest.Get("/dm/dim/data/schedule",2)
	if (status=$$$OK){
	  s response=httpRequest.HttpResponse
	  s rstatus=response.Data.ReadLine()
	  i rstatus'="1"{
		  q $$$ERROR("Request "_httpRequest.Server_":"_httpRequest.Port_"/dm/dim/data/schedule is error,message is "_rstatus) 
	  }else{
		  q status
	  }
  }else{
	  q $$$ERROR("Request "_httpRequest.Server_":"_httpRequest.Port_"/dm/dim/data/schedule is error,message is "_httpRequest.HttpResponse.Data.WriteLine())
  }
}

// s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_DIMDAY.d")

ClassMethod DimDataManualBuild(dimPath)
{
	q:(dimPath="") $$$OK
	s httpRequest=##class(DHCWL.DM.Util.HttpUtil).GetHttpRequest()
	d httpRequest.InsertParam("dimPath",dimPath)
	s status= httpRequest.Get("/dm/dim/data/manual",2)
	if (status=$$$OK){
	  s response=httpRequest.HttpResponse
	  s rstatus=response.Data.ReadLine()
	  i rstatus'="1"{
		  q $$$ERROR("Request "_httpRequest.Server_":"_httpRequest.Port_"/dm/dim/data/manual is error,message is "_rstatus) 
	  }else{
		  q status
	  }
  }else{
	  q $$$ERROR("Request "_httpRequest.Server_":"_httpRequest.Port_"/dm/dim/data/manual is error,message is "_httpRequest.HttpResponse.Data.WriteLine())
  }
}

// s status=##class(DHCWL.DM.I.Manage).MetaInfoBuild("/DHCMRInfo.mf")

ClassMethod MetaInfoBuild(metaPath)
{
	q:(metaPath="") $$$OK
	s httpRequest=##class(DHCWL.DM.Util.HttpUtil).GetHttpRequest()
	d httpRequest.InsertParam("metaPath",metaPath)
	s status= httpRequest.Get("/dm/manage/define/meta/build",2)
	if (status=$$$OK){
	  s response=httpRequest.HttpResponse
	  s rstatus=response.Data.ReadLine()
	  i rstatus'="1" || rstatus [ """success"":true" {
		  q $$$ERROR(metaPath_" Request "_httpRequest.Server_":"_httpRequest.Port_"/dm/manage/define/meta/build is error,message is "_rstatus) 
	  }else{
		  q status
	  }
  }else{
	  q $$$ERROR("Request "_httpRequest.Server_":"_httpRequest.Port_"/dm/manage/define/meta/build is error,message is "_httpRequest.HttpResponse.Data.WriteLine())
  }
}

}
