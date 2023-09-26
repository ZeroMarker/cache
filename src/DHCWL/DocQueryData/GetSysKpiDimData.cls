Class DHCWL.DocQueryData.GetSysKpiDimData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// ^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",946,"ADMTYPE",1492) = "" 
/// Creator：      duh
/// CreatDate：    2016年1月6日 11:27:12
/// Description:： 查找指标对应的纬度
/// Table：       DHCWL_MKPI.DHCWLMKPIDim
/// Input：       
/// Output：      
/// Return：      
/// Others：      d ##class(DHCWL.DocQueryData.GetSysKpiDimData).GetKpiDim(946)
/// [{},{},{}]
ClassMethod GetKpiDim(mkpiDr) As %String
{
	n (mkpiDr)
	k data
	s jsonData = "["
	s str = "children:["
	s mDimdimId = ""  f  s mDimdimId = $o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",mkpiDr,mDimdimId))  q:mDimdimId=""  d
	.s mDimId = ""  f  s mDimId = $o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",mkpiDr,mDimdimId,mDimId)) q:mDimId=""  d
	..s dimDesc = $list(^DHCWL.MKPI.MKPIDimensionsD(mDimId),4)
	..s jsonData = jsonData_"{"_"id:"_mDimdimId_",text:"_"'"_dimDesc_"'"_",leaf:false"_"},"
	s jsonData = $e(jsonData,1,$l(jsonData)-1)
	s jsonData = jsonData_"]"
	q jsonData
}

/// Creator：      duh
/// CreatDate：    2016年1月6日 11:27:12
/// Description:： 查找指标对应的纬度
/// Table：       DHCWL_MKPI.DHCWLDimProperty
/// Input：       
/// Output：      
/// Return：      
/// Others：      d ##class(DHCWL.DocQueryData.GetSysKpiDimData).GetDimProCode("YSKZRDetTest")
/// [{},{},{}]
ClassMethod GetDimProCode(syskpiCode) As %String
{
	n (syskpiCode)
	k data
	k ^TEMPDHCWLDUH($j)
	s syskpiCode = $zcvt(syskpiCode,"u")
	s mkpiDr=$o(^DHCWL.MKPI.MKPII("MKPICode",syskpiCode,"")) 
	s num =1
	s jsonData = "["
	s mDimdimId = ""  f  s mDimdimId = $o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",mkpiDr,mDimdimId))  q:mDimdimId=""  d  //纬度ID
	.s mDimId = ""  f  s mDimId = $o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",mkpiDr,mDimdimId,mDimId)) q:mDimId=""  d 
	..s dimCode = $list(^DHCWL.MKPI.MKPIDimensionsD(mDimId),2)
	..s dimDesc = $list(^DHCWL.MKPI.MKPIDimensionsD(mDimId),4)
	..s ^TEMPDHCWLDUH($j,mDimdimId,num)=dimCode_","_dimDesc_","_mDimId
	..s num= $g(num)+1
	..;s jsonData = jsonData_"{"_"tid:"_"'"_"'"_",tDesc:"_"'"_dimDesc_"',dimCode:"_"'"_dimCode_"'"_",dimId:"_"'"_mDimId_"'"_",leaf:false"_","
	s wdId = ""  f  s wdId = $o(^TEMPDHCWLDUH($j,wdId)) q:wdId=""  d
	.s count = ""  f  s count = $o(^TEMPDHCWLDUH($j,wdId,count)) q:count=""  d
	..s mDimDesc = $p($g(^TEMPDHCWLDUH($j,wdId,count)),",",2)
	..s mDimCode = $p($g(^TEMPDHCWLDUH($j,wdId,count)),",",1)
	..s nDimId = $p($g(^TEMPDHCWLDUH($j,wdId,count)),",",3)
	..s jsonData = jsonData_"{"_"tid:"_"'"_"'"_",tDesc:"_"'"_mDimDesc_"',dimCode:"_"'"_mDimCode_"'"_",dimId:"_"'"_nDimId_"'"_",leaf:false"_","
	..s str = ""
	..s dimProCode = ""  f  s dimProCode = $o(^DHCWL.MKPI.DimPropertyI("DimCodeI",wdId,dimProCode))  q:dimProCode=""  d   //纬度属性code
	...s dimProId = ""  f  s dimProId =  $o(^DHCWL.MKPI.DimPropertyI("DimCodeI",wdId,dimProCode,dimProId))  q:dimProId=""  d
	....s dimProDesc = $list(^DHCWL.MKPI.DimPropertyD(dimProId),4)
	....s lCode = $list(^DHCWL.MKPI.DimPropertyD(dimProId),3)
	....s str = $g(str)_"{"_"tid:"_wdId_",tDesc:"_"'"_dimProDesc_"'"_",dimProCode:"_"'"_lCode_"'"_",leaf:true"_"},"
	..s str = $e(str,1,$l(str)-1)
	..s jsonData = $g(jsonData)_"children:["_str_"]},"
	s jsonData = $e(jsonData,1,$l(jsonData)-1)_"]"
	//w jsonData,!
	q jsonData
}

/// 根据统计项的Code、维度属性code遍历所有维度属性值
/// d ##class(%ResultSet).RunQuery("DHCWL.DocQueryData.GetSysKpiDimData","GetDimProValue",1624,"Name","")
/// d ##class(%ResultSet).RunQuery("DHCWL.DocQueryData.GetSysKpiDimData","GetDimProValue",1564,"DocName","")
Query GetDimProValue(dimId As %Integer, proCode As %String, filterStr As %String = "") As %Query(ROWSPEC = "dimCode:%String,dimValue:%String,dimProValue:%String") [ SqlProc ]
{
}

ClassMethod GetDimProValueExecute(ByRef qHandle As %Binary, dimId As %Integer, proCode As %String, filterStr As %String = "") As %Status
{
	n (qHandle,proCode,dimId,filterStr)
 	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
    s ind=1
    //s mObject=##class(DHCWL.MKPI.MKPIDimensions).%OpenId(dimId)
    //s statCode = mObject.MKPIDimCode
	q:(dimId="")!(proCode="") $$$OK
	s dim=##class(DHCWL.DocQueryData.GetSysKpiDimData).GetDimByStatCode(dimId)
	s dimCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dim),2)
	q:dimCode="" $$$OK
	s dimCodeStr=dimCode_":"_proCode
	s rs=##class(%ResultSet).%New("DHCWL.Interface.MkpiData:QryDimValuesByDimType")
	s sc=rs.Execute(dimCodeStr)
	While rs.Next(.sc){
		s dimType=$g(rs.Data("dimType"))
		s dimIDV=$g(rs.Data("dimIDV")) 
		s dimProV=$g(rs.Data("dimProV"))
		continue:(dimProV'[filterStr)
		d OutPutRow
	}
	;d rs.Close()
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPutRow
	s Data=$lb(dimType,dimIDV,dimProV)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod GetDimProValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDimProValueExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDimProValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDimProValueExecute ]
{
	n (AtEnd,qHandle,Row)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// hetong
/// 2015-09-24
/// 通过统计项编码获得维度Rowid
/// w ##class(DHCWL.DocQueryData.GetSysKpiDimData).GetDimByStatCode(1491)
ClassMethod GetDimByStatCode(dimId) As %String
{
	n (dimId)
	s dimObject=##class(DHCWL.MKPI.MKPIDimensions).%OpenId(dimId)
	s dimDimDr = dimObject.MKPIDimDimDr.%Id()
	q $g(dimDimDr)
}

/// s j=##class(DHCWL.DocQueryData.GetSysKpiDimData).GetJsonFromQuery("DHCWL.DocQueryData.GetSysKpiDimData:GetDimProValue","{start:1,end:10,jsonProDeli:&}",1517,"LocDesc","")
ClassMethod GetJsonFromQuery(query, queryJsonPara = "{start:1,end:10,jsonProDeli:&,}", paras... As %List) As DHCWL.util.Json
{
	n (query,queryJsonPara,paras)
	//b
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
	s str="set sc=rs.Execute("_paraStr_")"   //set sc=rs.Execute("PatLoc","LocCode","")  
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
