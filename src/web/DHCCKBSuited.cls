Class web.DHCCKBSuited Extends %Persistent [ Not ProcedureBlock ]
{

/// Descript:导入excel，数据存入临时globar
/// CreateDate:2020-09-29
/// Creator:wangxin
///  d ##Class(web.DHCCKBSuited).InsertByData("","")
ClassMethod InsertByData(count As %String, cellVals As %String) As %String
{
	n (count,cellVals)
	s ^TMP("Data",count)=cellVals
	Q 0
}

/// Descript:组织未匹配的诊断串
/// Creator:WangXin
/// CreateDate:2020-09-29
/// d ##class(web.DHCCKBSuited).GetOrgMatchDiagExecute()
Query GetOrgMatchDiag() As websys.Query(ROWSPEC = "libDiag:%String:诊断,icdCode:%String:ICD诊断代码,icdDiag:%String:ICD诊断")
{
}

ClassMethod GetOrgMatchDiagExecute(ByRef qHandle As %Binary) As %Status
{
 n (qHandle)
	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	//存储未匹配数据
	k ^TMP("extArr")
	k ^TMP("dealresult")
	d ..ExportLibNotMatDiagExecute()
	s obj= ##class(%DynamicObject).%New()
	s source = []
	d source.%Push("LC")
	s obj.source = source
	s obj.dbname = "zhenduan"
	s obj.size = 1

	s index = "",num=0
	for {
	 s index = $o(^TMP("extArr",index))
	 q:index=""
		s num=num+1
		s match=[]
		s libDiag = ^TMP("extArr",index)
		d match.%Push(libDiag)
		s obj.terms = match
		s data=obj.%ToJSON()
		s result=..matchIcdDiag(data)
		s dealresult=..DealResult(result)
		s ^TMP("dealresult",ind)=$g(dealresult)
		s ^CacheTemp(repid,ind) = $lb(dealresult)
		s ind=ind+1 
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// d ##class(web.DHCCKBSuited).GetData()
ClassMethod GetData() As %String
{
 s index=0
 for{
 s index=$o(^TMP("dealresult",index))
	  q:index=""  d
		 s hisDiag=$p(^TMP("dealresult",index),",",1)
		 s icdCode=$p(^TMP("dealresult",index),",",2)
		 s icdDiag=$p(^TMP("dealresult",index),",",3)
	  w "hisDiag:"_hisDiag_",icdCode:"_icdCode_",icdDiag:"_icdDiag
}
}

/// ////////////////////////////////Query方法获取数据集//////////////////////////
/// 1拷贝四段 2改query名称 3改入参 4改出参
/// d ##class(%ResultSet).RunQuery("web.DHCCKBSuited","GetList","")   调用格式
Query GetList(Id As %String) As %Query(ROWSPEC = "Id,hisDiag,icdCode,icdDiag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, Id As %String) As %Status
{
		s repid=$I(^CacheTemp)
		s ind=1
		
		if (Id'="")
		{
			s Id=Id
			q:'($data(^TMP("dealresult",Id)))
			
				s hisDiag =$p(^TMP("dealresult",Id),",",1)
				s icdCode =$p(^TMP("dealresult",Id),",",2)
				s icdDiag =$p(^TMP("dealresult",Id),",",3)
			
			d QutputRow
		}
		
		else
		{
			s Id=0
			for{
				s Id=$O(^TMP("dealresult",Id))
				q:Id=""
				s hisDiag =$p(^TMP("dealresult",Id),",",1)
				s icdCode =$p(^TMP("dealresult",Id),",",2)
				s icdDiag =$p(^TMP("dealresult",Id),",",3)
				d QutputRow    // target	
			}	
			
		}
		
													
		set qHandle=$lb(0,repid,0)
		quit $$$OK
		
QutputRow
		set Data=$lb(Id,hisDiag,icdCode,icdDiag)
		
		set ^CacheTemp(repid,ind)=Data
		set ind=ind+1
		quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	
	s ind=$o(^CacheTemp(repid,ind))
	if ind=""
	{
		s AtEnd=1
		s Row=""
		}
		else {
			
			s Row=^CacheTemp(repid,ind)
			}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	
	s repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	q $$$OK
}

/// w ##class(web.DHCCKBSuited).matchIcdDiag()
ClassMethod matchIcdDiag(data)
{
	n (data)
	
	Set httprequest=##class(%Net.HttpRequest).%New()
	Set httprequest.Server="172.19.19.90"
	Set httprequest.Port=8003
	Set stream=##class(%CSP.BinaryStream).%New()
	Do stream.Write(data)
	Set httprequest.EntityBody=stream
	Do httprequest.EntityBody.SetAttribute("CONTENT-TYPE","application/json; charset=UTF-8")
	Do httprequest.Post("/match_icd")
	
	Set response=httprequest.HttpResponse
	if response {
		set StatusCode=response.StatusCode
		Set Data=response.Data
		
		if $IsObject(Data){
			if $CLASSNAME(Data)["Binary" { //字节流   
				//还是会有1个bug 比如流比较长 一次读不完 当一个字符的两个字节刚好被截断在两边  就会转化错误
				//所以暂时就当作返回的是个比较短的 一次可以处理玩的
				Set strData=Data.Read(30000)
				;b ;2
				if ##class(ext.util.String).IsUTF8ByteString(strData) { //满足utf8编码格式的 按utf8转成字符串
					s strData=$zcvt(strData,"I","UTF8")
				}else{ //按GB18030转
					s strData=$zcvt(strData,"I","GB18030")
				}
				q strData
			}else{
				Set strData=Data.Read(30000)
				if Data.AtEnd {
					q strData
				}else{
					s stream=##class(%GlobalCharacterStream).%New()
					d stream.CopyFrom(Data)
					q stream
				}
			}
		}else{
			q Data
		}
	}
	q ""
}

ClassMethod DealResult(res)
{
	n (res)
	s hisDiag=$p($p(res,"[[",2),",",1)
	s icdDiag=$p($p(res,"[[",3),",",1)
	s icdCode=$p($p(res,"[[",3),",",2)
	q hisDiag_","_icdCode_","_icdDiag
}

/// Descript:导出知识库诊断和hsi的icd未匹配的数据
/// CreateDate:2020-09-30
/// Creator:wangxin
/// d ##class(web.DHCCKBSuited).ExportLibNotMatDiagExecute()
ClassMethod ExportLibNotMatDiagExecute() As %String
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
	Set ind=1
	s icdIndex =""
 s num = 0
	s diagDictionId = ##class(web.DHCCKBCommon).GetDiseaseData()
	s Id = ""
	for{
		s Id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",diagDictionId,Id))  Q:Id=""  d
		Q:##class(web.DHCCKBCommon).IsEnabled(Id)=0
		s text = $lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),3)
		s extflag=0
		for
		{
						//循环已经存储的临时global
						s icdIndex =$o(^TMP("Data",icdIndex)) 
						q:(icdIndex="")||(extflag=1)  d
						s icdDiag = ^TMP("Data",icdIndex)
						if (icdDiag[text){
						   s extflag=1
						}
		}
		s num = num+1
		i extflag=0 s ^TMP("extArr",num)=text
	}
}

/// DHCCKBPrescTest       GetOrgMatchDiag
Storage Default
{
<Data name="DHCCKBSuitedDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCKBSuitedD</DataLocation>
<DefaultData>DHCCKBSuitedDefaultData</DefaultData>
<Description>
<![CDATA[DHCCKBPrescTest       GetOrgMatchDiag]]></Description>
<IdLocation>^web.DHCCKBSuitedD</IdLocation>
<IndexLocation>^web.DHCCKBSuitedI</IndexLocation>
<StreamLocation>^web.DHCCKBSuitedS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
