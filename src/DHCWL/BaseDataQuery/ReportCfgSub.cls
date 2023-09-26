/// d ##class(DHCWL.BaseDataQuery.ReportCfgSub).%BuildIndices()
Class DHCWL.BaseDataQuery.ReportCfgSub Extends %Persistent
{

/// 报表ID
Property RptID As %String(COLLATION = "EXACT");

/// 统计项,保存编码或表达式
Property Item As %String(COLLATION = "EXACT", MAXLEN = 150);

/// 统计项类型：行统计项，列统计项，度量统计项，过滤统计项
Property Type As %String;

/// 统计项名称。如果该字段是空值，取item中的描述
Property Name As %String;

Index InxRptNameItem On (RptID, Item);

ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""

	s rptType=inParam("rptType")	//报表类型，聚合类型：aggregat；明细类型：detail

	if rptType="corssRpt" {
		//1、保存行
		s items=inParam("paramRows")
		if items'="" {
			s itemType="row"
			s itemCnt=$l(items,",")	
			f inx=1:1:itemCnt {
				s item=$p(items,",",inx)
				s newObj=##class(DHCWL.BaseDataQuery.ReportCfgSub).%New()
				s newObj.RptID=inParam("RptID")
				s newObj.Item=item
				s newObj.Type=itemType
				s sc=newObj.%Save()
				If $$$ISERR(sc) {
					s ret="Insert 'ReportCfgSub'对象失败:"_$System.Status.GetErrorText(sc)
		 		}	
		 		q:ret'=""		
		 		d newObj.%Close()
			}
		}

		//2、保存列
		s items=inParam("paramCols")
		if items'="" {
			s itemType="col"
			s itemCnt=$l(items,",")	
			f inx=1:1:itemCnt {
				s item=$p(items,",",inx)
				s newObj=##class(DHCWL.BaseDataQuery.ReportCfgSub).%New()
				s newObj.RptID=inParam("RptID")
				s newObj.Item=item
				s newObj.Type=itemType
				s sc=newObj.%Save()
				If $$$ISERR(sc) {
					s ret="Insert 'ReportCfgSub'对象失败:"_$System.Status.GetErrorText(sc)
		 		}	
		 		q:ret'=""			
				d newObj.%Close()
			}
		}

		//3、保存度量
		s items=inParam("paramMeasure")
		if items'="" {
			s itemType="measure"
			s itemCnt=$l(items,",")	
			f inx=1:1:itemCnt {
				s item=$p(items,",",inx)
				s newObj=##class(DHCWL.BaseDataQuery.ReportCfgSub).%New()
				s newObj.RptID=inParam("RptID")
				s newObj.Item=item
				s newObj.Type=itemType
				s sc=newObj.%Save()
				If $$$ISERR(sc) {
					s ret="Insert 'ReportCfgSub'对象失败:"_$System.Status.GetErrorText(sc)
		 		}	
		 		q:ret'=""			
				d newObj.%Close()
			}	
		}	
		//4、保存过滤
		s items=inParam("filterIDs")
		if items'="" {
			s itemType="filter"
			s itemCnt=$l(items,",")	
			//w !,"items="_items
			f inx=1:1:itemCnt {
				s item=$p(items,",",inx)
				s newObj=##class(DHCWL.BaseDataQuery.ReportCfgSub).%New()
				s newObj.RptID=inParam("RptID")
				s newObj.Item=item
				s newObj.Type=itemType
				s sc=newObj.%Save()
				If $$$ISERR(sc) {
					s ret="Insert 'ReportCfgSub'对象失败:"_$System.Status.GetErrorText(sc)
		 		}	
		 		q:ret'=""			
				d newObj.%Close()
			}	
		}			
	}elseif rptType="grpRpt" {
		//1、保存列
		s items=inParam("paramCols")
		s colTypes=inParam("colTypes")
		s colNames=inParam("colNames")
	
		if items'="" {
			s itemCnt=$l(items,",")	
			f inx=1:1:itemCnt {
				s itemType=$p(colTypes,",",inx)
				if $g(itemType)="" s itemType="col"
				s Name=$p(colNames,",",inx)
				s item=$p(items,",",inx)
				s newObj=##class(DHCWL.BaseDataQuery.ReportCfgSub).%New()
				s newObj.RptID=inParam("RptID")
				s newObj.Item=item
				s newObj.Type=itemType
				s newObj.Name=Name
				s sc=newObj.%Save()
				If $$$ISERR(sc) {
					s ret="Insert 'ReportCfgSub'对象失败:"_$System.Status.GetErrorText(sc)
		 		}	
		 		q:ret'=""			
				d newObj.%Close()
			}
		}

	
		//2、保存过滤,分组,排序
		for itemsName="filterData","colGroupbys","colOrderbys" {
			s items=inParam(itemsName)
			if items'="" {
				if itemsName="filterData" {
					s itemType="filter" 
				}elseif itemsName="colGroupbys" {
					s itemType="colGroup" 
				}
				elseif itemsName="colOrderbys" {
					 s itemType="colOrder" 
					 
				}
				s itemCnt=$l(items,$C(2))	
				//w !,"items="_items
				s name=""
				f inx=1:1:itemCnt {
					s item=$p(items,$C(2),inx)
					s newObj=##class(DHCWL.BaseDataQuery.ReportCfgSub).%New()
					s newObj.RptID=inParam("RptID")
					if itemType="colOrder" {
						s name=$p(item,"^",3)
						s item=$p(item,"^",1,2)
					}elseif itemType="colGroup" {
						s name=$p(item,"^",2)
						s item=$p(item,"^",1)
					}
					elseif itemType="filter" {
						s name=$p(item,"^",7)
						s item=$p(item,"^",1,6)
					}
					s newObj.Name=name
					s newObj.Item=item
					s newObj.Type=itemType
					
					s sc=newObj.%Save()
					If $$$ISERR(sc) {
						s ret="Insert 'ReportCfgSub'对象失败:"_$System.Status.GetErrorText(sc)
			 		}	
			 		q:ret'=""			
					d newObj.%Close()
				}	
			}			
		}
							
	}
	
	q ret
	
SQLErr
	if ret="" s ret="Insert 'ReportCfgSub'对象失败:未知错误!"
	q ret
}

ClassMethod Update(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	
	s RptID=inParam("RptID")
	&sql(DELETE FROM DHCWL_BaseDataQuery.ReportCfgSub WHERE RptID = :RptID)
	if SQLCODE'=0 {
		s ret="更新DHCWL.BaseDataQuery.ReportCfgSub对象失败:SQLCODE="_SQLCODE
		q ret
	}

	s ret=..Insert(.inParam,.outParam)

	q ret
	
SQLErr
	if ret="" s ret="更新DHCWL.BaseDataQuery.ReportCfgSub对象失败:未知错误!"
	q ret
}

/// d ##class(DHCWL.BaseDataQuery.ReportCfgSub).IsValidAggreExp(.inParam,.outParam)
ClassMethod IsValidAggreExp(ByRef inParam, ByRef outParam) As %String
{
	s ret=""
	s qryObjName=inParam("qryObjName")
	s exp=inParam("exp")
				
	s Sql="select top 1* from "_qryObjName
	s rs=##class(%Library.ResultSet).%New()
	s st=rs.Prepare(Sql) 
	if ($$$ISERR(st)) {
		s ret=$System.Status.GetErrorText(st)
		q ret
	}
	s st=rs.Execute() 
	if ($$$ISERR(st)) {
		s ret=$System.Status.GetErrorText(st)
		q ret
	}
	s IDFieldName=""
	s cols=rs.GetColumnCount()
	f i=1:1:cols {
		if $lg(rs.GetColumnExtInfo(i),2)="%%ID" {
			s IDFieldName=rs.GetColumnHeader(i)
			q
		}
	}
	d rs.Close()
	if (IDFieldName'="") {
		s Sql="select "_exp_" from "_qryObjName_" where "_IDFieldName_"=-1"
		s rs=##class(%Library.ResultSet).%New()
		s st=rs.Prepare(Sql) 
		if ($$$ISERR(st)) {
			s ret=$System.Status.GetErrorText(st)
			q ret
		}
		s st=rs.Execute() 
		if ($$$ISERR(st)) {
			s ret=$System.Status.GetErrorText(st)
			q ret
		}		
		
	}
	
	q ret
}

/// ##class(DHCWL.BaseDataQuery.ReportCfgSub).GetSubs(1)
ClassMethod GetSubs(rptID) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	k aryObj
	q:rptID="" list
	q:'$d(^DHCWL.BaseDat9E76.ReportCfgSubI("InxRptNameItem",rptID)) list
	s item="" f{
	  s item=$o(^DHCWL.BaseDat9E76.ReportCfgSubI("InxRptNameItem",rptID,item))
	  q:item=""
	  s id=$o(^DHCWL.BaseDat9E76.ReportCfgSubI("InxRptNameItem",rptID,item,""))
	  s obj=##class(DHCWL.BaseDataQuery.ReportCfgSub).%OpenId(id)
	  continue:obj=""
	  s aryObj(id)=obj
	}
	//按ID排序
	s id=""
	f {
		s id=$o(aryObj(id))
		q:id=""
		s obj=aryObj(id)
		d list.Insert(obj)
	}

	q list
}

/// ##class(DHCWL.BaseDataQuery.ReportCfgSub).GetSub(1)
ClassMethod GetSub(rptID, item) As ReportCfgSub
{
	q:'$d(^DHCWL.BaseDat9E76.ReportCfgSubI("InxRptNameItem",rptID)) ""
	q:'$d(^DHCWL.BaseDat9E76.ReportCfgSubI("InxRptNameItem",rptID,item)) ""
	
	s id=$o(^DHCWL.BaseDat9E76.ReportCfgSubI("InxRptNameItem",rptID,item,""))
	s obj=##class(DHCWL.BaseDataQuery.ReportCfgSub).%OpenId(id)
	q obj
}

/// ##class(DHCWL.BaseDataQuery.ReportCfgSub).GetSubByID(1)
ClassMethod GetSubByID(subID) As ReportCfgSub
{
	s obj=##class(DHCWL.BaseDataQuery.ReportCfgSub).%OpenId(subID)
	q obj
}

Storage Default
{
<Data name="ReportCfgSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RptName</Value>
</Value>
<Value name="3">
<Value>Item</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>RptID</Value>
</Value>
<Value name="6">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^DHCWL.BaseDat9E76.ReportCfgSubD</DataLocation>
<DefaultData>ReportCfgSubDefaultData</DefaultData>
<IdLocation>^DHCWL.BaseDat9E76.ReportCfgSubD</IdLocation>
<IndexLocation>^DHCWL.BaseDat9E76.ReportCfgSubI</IndexLocation>
<StreamLocation>^DHCWL.BaseDat9E76.ReportCfgSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
