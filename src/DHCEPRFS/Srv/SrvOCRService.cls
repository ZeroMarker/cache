Class DHCEPRFS.Srv.SrvOCRService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvOCRService";

/// Desc: Ocr识别返回ScanItemId与ScanItem
/// Debug: w ##Class(DHCEPRFS.Srv.SrvOCRService).RecognizeOCRContentNew("体温单")
ClassMethod RecognizeOCRContentNew(AOCRContent As %String) As %String [ WebMethod ]
{
	s fatalRes = ##class(DHCEPRFS.BL.BLOCRService).GetDefaultUnOCRType()
	q:(AOCRContent="") fatalRes
	s ret = ##class(DHCEPRFS.BL.BLOCRService).RecognizeOCRContent(AOCRContent)
	s:(ret="") ret = ..GetMrItemByCompare(AOCRContent)
	s:(ret="") ret=fatalRes
	q ret
}

ClassMethod GetNeedOcrFileMasterId() As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLOCRService).GetNeedOcrFileMaster()
	
	q ret
}

ClassMethod UpdateOcrScanFile(AID, AScanItemId, AScanItem, AMedRecordNo) As %Boolean [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLOCRService).UpdateOcrScanFile(AID,AScanItem,AScanItemId,AMedRecordNo)
	q ret
}

/// w ##Class(DHCEPRFS.Srv.SrvOCRService).RecognizeOCRContent("1、 中国医学科学院肿瘤医院深圳医院2、 体温单3、 姓名张洲4、 性别:女年龄25岁")
ClassMethod RecognizeOCRContent(AOCRContent As %String) As %String [ WebMethod ]
{
	s arrEpisode=##class(%ArrayOfDataTypes).%New() 
	d arrEpisode.SetAt("","入院记录")
	d arrEpisode.SetAt("","病程记录")
	d arrEpisode.SetAt("","手术记录")
	d arrEpisode.SetAt("","治疗记录")
	d arrEpisode.SetAt("","出院记录")
	d arrEpisode.SetAt("","死亡记录")
	d arrEpisode.SetAt("","检查报告")
	d arrEpisode.SetAt("","检验报告")
	d arrEpisode.SetAt("","病案首页")
	
	d arrEpisode.SetAt("","病理报告")
	d arrEpisode.SetAt("","外院报告")
	d arrEpisode.SetAt("","医嘱单")
	d arrEpisode.SetAt("","体温单")
	d arrEpisode.SetAt("","护理记录单")
	d arrEpisode.SetAt("","知情同意书")
	d arrEpisode.SetAt("","入院通知单")
	d arrEpisode.SetAt("","身份证复印件")
	d arrEpisode.SetAt("","放射治疗记录单")
	d arrEpisode.SetAt("","其他")
	
	s strUserID =""
 	s strReturn=""
 	s strScanItem =""
	for {
		s strScanItem=arrEpisode.Next(strScanItem)
		
		q:(strScanItem = "")
		if (AOCRContent [ strScanItem)	//如果包含，直接返回
		{
			s strReturn=strScanItem
			q
		}
	}
	
	q strReturn
}

// w ##Class(EPRservice.Quality.DataGather.AdmInfo).getTextSimilarity("我知道你","你知道我你")

// 计算两个文本的相似度（余弦相似度算法）

// text1文本1，text2文本2

/// w ##Class(DHCEPRFS.Srv.SrvOCRService).getTextSimilarity("理赂决定通知书","理赔决定通知书")
ClassMethod getTextSimilarity(text1 As %String, text2 As %String) As %String
{
	 k ^Temp("String")
	 s text1 = ..filter(text1)
	 s text2 = ..filter(text2)
	 Set ret = ##class(%Library.ArrayOfDataTypes).%New()
	 for i=1:1:$l(text1)
	 {
		 s char = ret.GetAt($e(text1,i))
		 if (char'="")
		 {
			 s ^Temp("String",1,$e(text1,i)) = $g(^Temp("String",1,$e(text1,i))) + 1
			 d ret.SetAt($g(^Temp("String",1,$e(text1,i)))_" "_$g(^Temp("String",2,$e(text1,i))),$e(text1,i))
		 }
		 else
		 {
			 s ^Temp("String",1,$e(text1,i)) = 1
			 s ^Temp("String",2,$e(text1,i)) = 0
			 d ret.SetAt($g(^Temp("String",1,$e(text1,i)))_" "_$g(^Temp("String",2,$e(text1,i))),$e(text1,i))
		 }
	 }
	
	 for j=1:1:$l(text2)
	 {
		 s char = ret.GetAt($e(text2,j))
		 if (char'="")
		 {
			 s ^Temp("String",2,$e(text2,j)) = $g(^Temp("String",2,$e(text2,j))) + 1
			 d ret.SetAt($g(^Temp("String",1,$e(text2,j)))_" "_$g(^Temp("String",2,$e(text2,j))),$e(text2,j))
		 }
		 else
		 {
			 s ^Temp("String",1,$e(text2,j)) = 0
			 s ^Temp("String",2,$e(text2,j)) = 1
			 d ret.SetAt($g(^Temp("String",1,$e(text2,j)))_" "_$g(^Temp("String",2,$e(text2,j))),$e(text2,j))
		 }
	 }
	 s dividend = 0
	 s divisor1 = 0
	 s divisor2 = 0
	 s key = ""
	 for
	 {
		 s key = ret.Next(key)
		 q:(key="")
		 s value = ret.GetAt(key)
		 s dividend = dividend + ($p(value," ",1) * $p(value," ",2))
		 s divisor1 = divisor1 + ($p(value," ",1) * $p(value," ",1))
		 s divisor2 = divisor2 + ($p(value," ",2) * $p(value," ",2))
	 }
	 s Similarity = dividend / ((divisor1 ** 0.5) * (divisor2 ** 0.5))
	 k ^Temp("String")
	 q Similarity
}

// 过滤掉文本中的标点符号

/// Debug: w ##class(DHCEPRFS.Srv.SrvOCRService).GetCategoryByCompare("首次病程记录")
ClassMethod GetMrItemByCompare(AName As %String) As %String
{
	s len = $L(AName)
	s mrItemId = ""
	s max = 0
	s res = ""
	f
	{
		s mrItemId = $O(^DHCEPRFS.META.MRItemD(mrItemId))
		q:(mrItemId="")
		s obj = ##class(DHCEPRFS.META.MRItem).%OpenId(mrItemId)
		s mrItemSubs = obj.OCRArrangeTitle
		s mrItemCount = $L(mrItemSubs,"^")
		s index = 1
		f
		{
			q:(index>mrItemCount)
			s AMrItem = $P(mrItemSubs,"^",index)
			s index = index+1
			continue:($L(AMrItem)'=len)
			s compare = ..getTextSimilarity(AName,AMrItem)
			
			i (compare>max)
			{
				s max = compare
				s res = mrItemId_"^"_obj.Name
			}
			
		}
		d obj.%Close()
		s obj = ""
		
	}
	q:(max>0.5) res
	q ""
}

ClassMethod filter(text As %String)
{
	s SpecialString = ",\.\，\。\?\？\:\：\“\”\!\！\;\；\、\·\~\(\)\（\）\/\<\>\《\》\—\="
	for i=1:1:$l(SpecialString,"\")
	{
		s text = $tr(text,$p(SpecialString,"\",i))
	}
	s text = $tr(text," ")
	s text = $tr(text,"\")
	s text = $tr(text,$c(10))
	q text
}

/// Create: 2021-12-21 ys 
/// Desc: 查询智能分类后成功的数量，和具体那些没有成功
/// Debug: w ##class(DHCEPRFS.Srv.SrvOCRService).GetOcrInfoByDate("2021-12-21","2021-12-22")
ClassMethod GetOcrInfoByDate(AStartDate As %String, AEndDate As %String) As %XML.DataSet [ WebMethod ]
{
	q:(AStartDate="") ""
	q:(AEndDate="") ""
	
	Set result=##class(%XML.DataSet).%New("DHCEPRFS.BL.BLOCRService:GetOcrResultByDate")
    Do result.SetArgs(AStartDate,AEndDate)
    Quit result
}

ClassMethod GetArchiveResultByEpisodeID(AEpisodeID As %String) As %XML.DataSet [ WebMethod ]
{
	 s ret = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLOCRService:GetArchiveResultByEpisodeID")
	 d ret.SetArgs(AEpisodeID)
	 q ret
}

/// Debug: w ##class(DHCEPRFS.Srv.SrvOCRService).GetArchiveResultByDate("2022-3-2","0:00:00","2022-3-23","23:59:59","")
ClassMethod GetArchiveResultByDate(AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String, AMedRecord As %String) As %XML.DataSet [ WebMethod ]
{
	s ret = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLOCRService:GetArchiveResultByDateTime")
	
	d ret.SetArgs(AStartDate,AStartTime,AEndDate,AEndTime,AMedRecord)
	q ret
}

}
