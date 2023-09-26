Class DHCWL.DM.Test.HttpTest Extends %RegisteredObject
{

// d ##class(DHCWL.DM.Test.HttpTest).Test()

ClassMethod Test()
{
	s httprequest=##class(%Net.HttpRequest).%New()
    s httprequest.Server="localhost"
    s httprequest.Port=8088
    w "start request",!
    s status= httprequest.Get("/dm/theme/data/rtdcreate")
    if (status=$$$OK){
	  s response=httprequest.HttpResponse
	  w "response data:"_response.Data.WriteLine(),!
    }else{
	  w "error!",!
    }
}

// j ##class(DHCWL.DM.Test.HttpTest).Test2()

ClassMethod Test2()
{
	s ^lhhtest($j)=$ZJOB
}

}
