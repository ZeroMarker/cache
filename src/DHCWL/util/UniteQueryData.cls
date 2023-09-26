Class DHCWL.util.UniteQueryData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(DHCWL.util.UniteQueryData).GetQueryDate(.data,"DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate","165,2,1,22,25","2012-04-01","2012-04-30","byMonth")
ClassMethod GetQueryDate(ByRef queryData As %String, query, paras... As %List) As %Status
{
	n (queryData,query,paras)
	;s queryData=""
	set rs=##class(%ResultSet).%New(query)  ;("Sample.Person:ByName")
	s paraStr="" f i = 1 : 1 : $GET(paras, 0) d
	.s paraStr=paraStr_""""_$g(paras(i))_""","
	s paraStr=$e(paraStr,1,$l(paraStr)-1),sc=""
	s str="set sc=rs.Execute("_paraStr_")"
	xecute str
	i $$$ISERR(sc) q 0
	s id=1,cols=rs.GetColumnCount()
	f i=1:1:cols d
	.s colName(i)=rs.GetColumnHeader(i)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s queryData(id)=""
		f i=1:1:cols {
			s queryData(id,colName(i))=rs.Data(colName(i))
			;w colName(i)_"="_queryData(id,colName(i)),!
		}
		s id=id+1
	}
	q $$$OK
}

/// s j=##class(DHCWL.util.UniteQueryData).GetJsonFromQuery("web.DHCWL.StatisticsQuery:NeedUpdateKpis","{start:1,end:10,jsonProDeli:&}","2012-10-29","","15:RegLoc,16:RegLoc")
ClassMethod GetJsonFromQuery(query, queryJsonPara = "{start:1,end:10,jsonProDeli:&,}", paras... As %List) As DHCWL.util.Json
{
	n (query,queryJsonPara,paras)
	d ..ResolveParams(queryJsonPara,.resolvedPara)
	s start=$g(resolvedPara("start"),0),end=$g(resolvedPara("end"),0)
	s jsonPros=$g(resolvedPara("jsonPros"),""),proDeli=$g(resolvedPara("jsonProDeli"),"&")
	s choiceCols=$g(resolvedPara("choiceCols"),"")
	i (start=0)&&(end=0) s ignorePage=1
	e  s ignorePage=0
	s deli=proDeli
	s choiceColArr="",defaultCol=1,len=$l(choiceCols,",")
	i choiceCols="" s len=0
	f i=1:1:len {
		s choiceColArr($p(choiceCols,",",i))="",defaultCol=0
	}
	s rs=""
	set rs=##class(%ResultSet).%New(query)  ;("Sample.Person:ByName")
	s paraStr="" f i = 1 : 1 : $GET(paras, 0) d
	.s paraStr=paraStr_""""_$g(paras(i))_""","
	s paraStr=$e(paraStr,1,$l(paraStr)-1),sc=""
	s str="set sc=rs.Execute("_paraStr_")"
	//s ^TEMPDHCWL("interfaceQueryData",$j)="query"
	xecute str
	s id=1,cols=rs.GetColumnCount()
	s titleRS="",columName=""
	f i=1:1:cols d
	.s columName=rs.GetColumnName(i),columType=rs.GetColumnType(i)
	.s cols(i,columName)=columType
	.i defaultCol=1 s choiceColArr(columName)=""
	.q:$d(choiceColArr(columName))=0
	.i titleRS="" s titleRS=columName
	.e  s titleRS=titleRS_deli_columName
	i jsonPros="" s jsonPros=titleRS
	s json=##class(DHCWL.util.Json).Json(jsonPros,"result","root",deli) ;*-1),"result","root",deli)
	;b ;001
	s num=0
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s num=num+1
		i (ignorePage=0)&&(num<(start)) continue
		i (ignorePage=0)&&(num>end) continue
		s queryData="",col=""
		f i=1:1:cols {
			s col=$o(cols(i,""))
			continue:$d(choiceColArr(col))=0
			s colV=rs.Data(col)
			i (colV="")||(colV=$c(0))&&((cols(i,col)=3)||(cols(i,col)=5)) s colV=0
			i queryData="" s queryData=$$TypeString(cols(i,col))_colV_$$TypeString(cols(i,col))
			e  s queryData=queryData_deli_$$TypeString(cols(i,col))_colV_$$TypeString(cols(i,col))  ;$case(rs.Data(col),"":"",:rs.Data(col))
			;w "queryData"_queryData,!
			;b ;001
		}
		d json.Insert(queryData)
	}
	;s num=rs.%ROWCOUNT
	d json.SetTotalNum(num)
	q json
TypeString(sqlType)
	i (sqlType=10)||(sqlType=13)||(sqlType=13) q "'"
	q ""
}

/// w ##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate",)
ClassMethod GetQueryDateRef(query, paras... As %List) As %ResultSet
{
	n (query,paras)
	;s queryData=""
	set rs=##class(%ResultSet).%New(query)  ;("Sample.Person:ByName")
	s paraStr="" f i = 1 : 1 : $GET(paras, 0) d
	.s paraStr=paraStr_""""_$g(paras(i))_""","
	s paraStr=$e(paraStr,1,$l(paraStr)-1),sc=""
	s str="set sc=rs.Execute("_paraStr_")"
	xecute str
	i $$$ISERR(sc) q 0
	q rs
	s id=1,cols=rs.GetColumnCount()
	f i=1:1:cols d
	.s colName(i)=rs.GetColumnHeader(i)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s queryData(id)=""
		f i=1:1:cols {
			s queryData(id,colName(i))=rs.Data(colName(i))
			;w colName(i)_"="_queryData(id,colName(i)),!
		}
		s id=id+1
	}
	q $$$OK
}

/// d ##class(DHCWL.util.UniteQueryData).ResolveParams("{start:1,end:10,jsonProDeli:&,choiceCols:monId,monDes}",.res)
ClassMethod ResolveParams(roleParam, ByRef resolvedArr)
{
	n (resolvedArr,roleParam)
	s params=$p(roleParam,"{",2)
	s params=$p(params,"}"),len=$l(params,":")
	f i=1:1:len-1 {
		s paramP=$p(params,":",i)
		s plen=$l(paramP,",")
		s p=$p(paramP,",",plen)
		s paramV=$p(params,":",i+1)
		s vlen=$l(paramV,",")-1
		s:vlen=0 vlen=1
		s:i=(len-1) vlen=vlen+1
		s v=$p(paramV,",",1,vlen)
		s resolvedArr(p)=v
	}
}

}
