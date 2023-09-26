Class web.DHCAPPChart Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      zhouxin
/// CreatDate：    2016-05-25
/// Description:： 查询图表，优先级，菜单图表高于安全组
/// w ##class(web.DHCAPPChart).ShowChartJson()
ClassMethod ShowChartJson(EpisodeID As %String = "", ChartBookID As %String = "") As %String
{
		
		n (EpisodeID,%session,ChartBookID)
		s GroupID=$g(%session.Data("LOGON.GROUPID"))
        i ChartBookID="" d
        .&SQL(SELECT MainChartBookDR INTO :ChartBookID FROM epr.GroupSettings WHERE GroupDR = :GroupID)
		//s ChartBookID=58
		s jsonObj=##class(web.DHCAPPJsonObject).%New()
  		s listObj=##class(%ListOfObjects).%New()
		s obj=##Class(epr.ChartBook).%OpenId(ChartBookID,0)
		i obj {
			s lst=obj.ChartList
			s count=lst.Count()
			f jh=1:1:count {
				i lst.GetAt(jh) {
					s ChartID=lst.GetAt(jh).%Id()	
					n chrt
					s chrt=##class(epr.Chart).%OpenId(ChartID)
					s ChartName=chrt.Name
					s LinkUrl=..getChartUrl(ChartID)
					s tmpObj=##class(web.DHCAPPJsonObject).%New()
					d tmpObj.Put("ChartName",ChartName)
					d tmpObj.Put("LinkUrl",LinkUrl)
					d tmpObj.Put("ChartID",ChartID)
					d listObj.Insert(tmpObj)
				}
			}
		}
		w jsonObj.ListToJson(listObj)
		q ""
}

ClassMethod getChartUrl(ChartID) As %String
{
		n (ChartID)
		s url=""
		s chrt=##class(epr.Chart).%OpenId(ChartID,0)
		s ChartName=chrt.Name
		i chrt.ChartSettings.Count()>0 {
			s CTProfileParamsType = chrt.ChartSettings.GetAt(1).ItemType
			s CTProfileParamsId = chrt.ChartSettings.GetAt(1).Item
			s paramsObj = ##class(epr.CTProfileParams).%OpenId(CTProfileParamsId,0)	
			i $IsObject(paramsObj)&&(CTProfileParamsType="CSPNAME") {
				s url = $p(paramsObj.PPParameters,"^",1)
			}
			s paramsObj= ""
		}
		q url
}

ClassMethod getChart(ChartBookID As %String = "") As %ListOfObjects
{
		
		n (%session,ChartBookID)
		s GroupID=$g(%session.Data("LOGON.GROUPID"))
        i ChartBookID="" d
        .&SQL(SELECT MainChartBookDR INTO :ChartBookID FROM epr.GroupSettings WHERE GroupDR = :GroupID)
		//s ChartBookID=58
  		s listObj=##class(%ListOfObjects).%New()
		s obj=##Class(epr.ChartBook).%OpenId(ChartBookID,0)
		i obj {
			s lst=obj.ChartList
			s count=lst.Count()
			f jh=1:1:count {
				i lst.GetAt(jh) {
					s ChartID=lst.GetAt(jh).%Id()	
					n chrt
					s chrt=##class(epr.Chart).%OpenId(ChartID)
					s ChartName=chrt.Name
					s LinkUrl=..getChartUrl(ChartID)
					s tmpObj=##class(web.DHCAPPJsonObject).%New()
					d tmpObj.Put("ChartName",ChartName)
					d tmpObj.Put("LinkUrl",LinkUrl)
					d tmpObj.Put("ChartID",ChartID)
					d listObj.Insert(tmpObj)
				}
			}
		}
		q listObj
}

}
