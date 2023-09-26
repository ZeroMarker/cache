Class DHCWL.DM.Util.HttpUtil Extends %RegisteredObject
{

ClassMethod GetHttpRequest()
{
	s httprequest=##class(%Net.HttpRequest).%New()
  s httprequest.Server="127.0.0.1"  ;127.0.0.1  10.1.5.89  10.1.41.108
  s httprequest.Port=8188
  s httprequest.Timeout=60*60  ;60 min
  q httprequest
}

}
