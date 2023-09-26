/// 总检扩展业务数据操作类
Class web.DHCPE.GeneralSummarizeEx Extends %RegisteredObject
{

ClassMethod Save(GSID, Str)
{
	s Date=+$H
	s Time=$P($H,",",2)
	s GSEXID=$O(^User.DHCPEGeneralSummarizeExI("GeneralSummarizeID",GSID,0))
 	i GSEXID="" d
 	.s obj=##class(User.DHCPEGeneralSummarizeEx).%New()
 	.d obj.GSEGeneralSummarizeIDSetObjectId(GSID)
 	e  d
 	.s obj=##class(User.DHCPEGeneralSummarizeEx).%OpenId(GSEXID)
 	d obj.GSEConclusionIDSetObjectId($P(Str,"^",1))
 	d obj.GSEDCIDSetObjectId($P(Str,"^",2))
	s obj.GSESuggestions=$P(Str,"^",3)
	s obj.GSETestResult=$P(Str,"^",4)
	s obj.GSEClinical=$P(Str,"^",5)
	s obj.GSEOccupationalHistory=$P(Str,"^",6)
	s obj.GSEConclusionDesc=$P(Str,"^",7)  //结论(健康证)
	s obj.GSEDate=Date
	s obj.GSETime=Time
	//d obj.GSEUserIDSetObjectId(UserID)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

/// w ##class(web.DHCPE.GeneralSummarizeEx).GetGSExInfo(579) 
ClassMethod GetGSExInfo(GSID As %String)
{
	
	s GSExInfo=""
	q:GSID="" ""
	s GSEXID=$O(^User.DHCPEGeneralSummarizeExI("GeneralSummarizeID",GSID,0))
	q:GSEXID="" ""
	for i=3:1:9  do
	.s OneInfo=$LG(^User.DHCPEGeneralSummarizeExD(GSEXID),i)
	.i GSExInfo'="" d
	..s GSExInfo=GSExInfo_"^"_OneInfo
	.e  d
	..s GSExInfo=OneInfo
	q GSExInfo
}

/// Creator：      zhongricheng
/// CreatDate：    
/// Description:： 保存职业病总检信息 一个总检记录对应多个扩展记录
/// Table：        DHC_PE_GeneralSummarizeEx
/// Input：        总检ID  数据JSON  类型  状态  用户ID  科室ID  院区ID
/// Output：       
/// Return：       返回 json 数据 code -1 则插入失败
/// Others：       
/// Debug:		   w ##class(web.DHCPE.GeneralSummarizeEx).UpdateOccuSummaryEx(54565, "", "OC", "", 16762, 422, 9)
ClassMethod UpdateOccuSummaryEx(GSID, JsonStr, Type, ExStr = "", UserID = "", LocID = "", HospID = "")
{
	//s JsonStr="[{""id"":""1"",""text"":""目前未见异常"",""selected"":""true"",""concData"":{""Endangers"":[""1"",""2""],""EdIllness"":"""",""ReviewItems"":[],""Suggestions"":""目前伟建议称""}},{""id"":""2"",""text"":""复查"",""concData"":{""Endangers"":[""3"",""39""],""EdIllness"":"""",""ReviewItems"":[""23688||1"",""23685||1""],""Suggestions"":""复查皮肤眼科""}},{""id"":""3"",""text"":""职业禁忌症"",""concData"":{""Endangers"":[""40""],""EdIllness"":""4"",""ReviewItems"":[],""Suggestions"":""这是目标疾病""}},{""id"":""4"",""text"":""疑似职业病""},{""id"":""5"",""text"":""其他疾病或异常""}]"
	s $ZT="UpdateOccuSummaryExErr"
	q:GSID="" ..OutJson(-1,"总检ID为空","")
	q:JsonStr="" ..OutJson(-1,"总检数据为空","")
	q:Type="" ..OutJson(-1,"类型不能为空","")
	
	s:UserID="" UserID=%session.Get("LOGON.USERID")
	s:LocID="" LocID=%session.Get("LOGON.CTLOCID")
	s:HospID="" HospID=%session.Get("LOGON.HOSPID")
	
	s err=""
	s Date=+$H
	s Time=$P($H,",",2)
	s JsonArr={}.%FromJSON(JsonStr)
	s Status="U"
	
	s Evaluation=$p(ExStr,$c(1,1),1)  // 适应性评价
	s ExStr=$p(ExStr,$c(1,1),*)
	
	TStart
	s Flag=0
	f jsonInd=0:1:(JsonArr.%Size()-1) {
		s JsonObj=JsonArr.%Get(jsonInd)
		s concId=JsonObj.id
		continue:concId=""
		s enStrs=JsonObj.concData.Endangers
		//continue:enStrs=""
		//continue:enStrs.%Size()<=0
		s endangers=""
		i $ISOBJECT(enStrs) d
		.f ind=0:1:(enStrs.%Size()-1) d
		..s tempId=enStrs.%Get(ind)
		..q:tempId=""
		..s:endangers'="" endangers=endangers_"^"_tempId
		..s:endangers="" endangers=tempId
		s:endangers="" Status="NU"
		
		s edIllness=JsonObj.concData.EdIllness
		s illness=""
		i $ISOBJECT(edIllness) d
		.f ind=0:1:(edIllness.%Size()-1) d
		..s tempId=edIllness.%Get(ind)
		..q:tempId=""
		..s:illness'="" illness=illness_"^"_tempId
		..s:illness="" illness=tempId
		
		s reviewItems=JsonObj.concData.ReviewItems
		s result=""
		i $ISOBJECT(reviewItems) d
		.f ind=0:1:(reviewItems.%Size()-1) d
		..s tempId=reviewItems.%Get(ind)
		..q:tempId=""
		..s:result'="" result=result_"^"_tempId
		..s:result="" result=tempId
		s suggestions=JsonObj.concData.Suggestions
		
		s OtherData=""
		;w GSID," ",Type," ",concId," ",endangers," ",illness," ",result," ",suggestions," ",Status," ",OtherData," ",UserID," ",LocID," ",HospID,!
		s err=..SaveNew(GSID, Type, concId, endangers, illness, result, suggestions, Status, OtherData, UserID, LocID, HospID)
		i err'="" goto UpdateOccuSummaryExErr
		
		/// 保存适应性评价
		i Evaluation'="" {
			s GSObj=##class(User.DHCPEGeneralSummarize).%OpenId(GSID)
			s GSObj.GSEvaluation=Evaluation
			s sc=GSObj.%Save()
			d GSObj.%Close()
			if ($System.Status.IsError(sc)) {
				s err=$System.Status.GetErrorText(sc)
				goto UpdateOccuSummaryExErr
			}
		}
		
		s Flag=1
	}
	
	i ((Flag=1)&&(ExStr'="")) {
		s ^DHCPEGS(GSID,"OCCUSUM")=ExStr
	}
	
	TCOMMIT
	
	q ..OutJson(0,err,"")
UpdateOccuSummaryExErr
	s $ZT=""
	TROLLBACK
	q ..OutJson(-1,err_$ze,"")
}

/// Creator：      zhongricheng
/// CreatDate：    
/// Description:： 保存职业病总检扩展信息
/// Table：        DHC_PE_GeneralSummarizeEx
/// Input：        总检ID  类型  结论ID  危害因素  疾病  结果  处理意见  状态  其他数据  用户ID  科室ID  院区ID
/// Output：       
/// Return：       返回 json 数据 code -1 则插入失败
/// Others：       
/// Debug:		   w ##class(web.DHCPE.GeneralSummarizeEx).SaveNew()
ClassMethod SaveNew(GSID, Type, ConcId, Endangers, EdIllness, TestResult, Suggestions, Status, OtherData, UserID, LocID, HospID)
{
	s err=""
	
	q:Type="" "总检类型不能为空"
	q:ConcId="" "总检ID不能为空"
	q:Status="" "总检状态不能为空"
	q:((Endangers="")&&(Status="U")) "危害因素不能为空"
	
	s GSExId=$o(^User.DHCPEGeneralSummarizeExI("GSESumTypeConcIndex",GSID,Type,ConcId,0))
	if (GSExId="") {	
		s GSExObj=##class(User.DHCPEGeneralSummarizeEx).%New()
	} else {
		s GSExObj=##class(User.DHCPEGeneralSummarizeEx).%OpenId(GSExId)
	}
	d GSExObj.GSEGeneralSummarizeIDSetObjectId(GSID)
	d GSExObj.GSEConclusionIDSetObjectId(ConcId)
	
	b // 危害因素
	d GSExObj.GSEEndangers.Clear()
	f edInd=1:1:$l(Endangers,"^") d
	.s EDRowId=$p(Endangers,"^",edInd)
	.q:EDRowId=""
	.d GSExObj.GSEEndangers.InsertObjectId(EDRowId)
	
	b // 目标疾病
	d GSExObj.GSEIllness.Clear()
	i EdIllness'="" d
	.f illInd=1:1:$l(EdIllness,"^") d
	..s illRowId=$p(EdIllness,"^",illInd)
	..q:illRowId=""
	..d GSExObj.GSEIllness.InsertObjectId(illRowId)
	
	s GSExObj.GSETestResult=TestResult
	s GSExObj.GSESuggestions=Suggestions
	s GSExObj.GSEType=Type
	s GSExObj.GSEDate=+$h
	s GSExObj.GSETime=$p($h,",",2)
	d GSExObj.GSEUserIDSetObjectId(UserID)
	d GSExObj.GSELocIDSetObjectId(LocID)
	s GSExObj.GSEStatus=Status
	
	s sc=GSExObj.%Save()
	d GSExObj.%Close()
	if ($System.Status.IsError(sc)) {
		s err=$System.Status.GetErrorText(sc)
	}
	q err
}

/// Creator：      zhongricheng
/// CreatDate：    
/// Description:： 根据VIP等级显示结论 通过总检ID 判断是否选中
/// Table：        DHC_PE_Conclusion
/// Input：        VIP等级  总检ID
/// Output：       
/// Return：       返回 json 数组
/// Others：       
/// Debug:		   w ##class(web.DHCPE.GeneralSummarizeEx).OutConclusionJson(3,54565)
ClassMethod OutConclusionJson(VIPLevel, GSID = "", Type = "")
{
	s Arr=[]
	q:VIPLevel="" Arr.%ToJSON()
	s selFlag=0
	s id=0
	f  s id=$O(^User.DHCPEConclusionI("VIPLevelIndex",VIPLevel,id)) q:id=""  d
	.s Active=$LG(^User.DHCPEConclusionD(id),4)
	.q:Active'="Y"
	.s text=$LG(^User.DHCPEConclusionD(id),3)
	.s Obj={}
	.s Obj.id=id
	.s Obj.text=text
	.
	.s OccuSumData=""
	.
	.s selected=""
	.if GSID'="" d
	..s OccuSumData=..GetGSExInfo(GSID,Type,id,"Arr")
	..s:OccuSumData.%Size()<=0 OccuSumData=""
	..if selFlag=0 d
	...if Type'="" d
	....s GSEXID=$o(^User.DHCPEGeneralSummarizeExI("GSESumTypeConcIndex",GSID,Type,id,0))
	....i GSEXID'="" d
	.....s:$lg(^User.DHCPEGeneralSummarizeExD(GSEXID),15)="U" selected="true",selFlag=1
	...e  d
	....s GSEXID=0
	....f  s GSEXID=$o(^User.DHCPEGeneralSummarizeExI("GeneralSummarizeID",GSID,GSEXID)) q:GSEXID=""  d
	.....q:$lg(^User.DHCPEGeneralSummarizeExD(GSEXID),3)'=id
	.....s:$lg(^User.DHCPEGeneralSummarizeExD(GSEXID),15)="U" selected="true",selFlag=1
	.
	.s:selected="true" Obj.selected=selected
	.
	.s concData={}
	.if OccuSumData'="" d
	..s OccuSumObj=OccuSumData.%Get(0)
	..s concData.Endangers=OccuSumObj.EndangerArr
	..s concData.EdIllness=OccuSumObj.IllnessArr
	..s tmpArr=[],tmpResult=OccuSumObj.result
	..f tmpi=1:1:$l(tmpResult,"^") d
	...s tmpId=$p(tmpResult,"^",tmpi)
	...q:tmpId=""
	...d tmpArr.%Push(tmpId)
	..s concData.ReviewItems=tmpArr
	..s concData.Suggestions=OccuSumObj.Suggestions
	.s Obj.concData=concData
	.
	.d Arr.%Push(Obj)
	
	q Arr.%ToJSON()
}

/// Creator：      zhongricheng
/// CreatDate：    
/// Description:： 根据通过总检ID 获取职业总检小结
/// Table：        DHC_PE_Result
/// Input：        总检ID
/// Output：       
/// Return：       返回 所有科室的总检小结
/// Others：       写的太长 不想优化
/// Debug:		   w ##class(web.DHCPE.GeneralSummarizeEx).OutConcResult(54565,"",422)
ClassMethod OutConcResult(GSID, Type = "", CTLocId = "")
{
	q:GSID="" ..OutJson(-1,"总检ID为空","")
	s PAADM=$p($g(^DHCPEGS(GSID,1)),"^",8)
	q:PAADM="" ..OutJson(-1,"就诊号为空","")
	s Order=$o(^OEORD(0,"Adm",PAADM,0))
	q:Order="" ..OutJson(-1,"无对应医嘱","")
	
	s json={}
	s json."Evaluation"=$p($g(^DHCPEGS(GSID,1)),"^",9)
	if $d(^DHCPEGS(GSID,"OCCUSUM")) {
		s json."OCCUSUM"=$g(^DHCPEGS(GSID,"OCCUSUM"))
		q ..OutJson(0,"成功",json.%ToJSON())
	}
	
	k tmpDHCPEOrdResult
	k tmpDHCPEOrdDetail
	k tmpDHCPEOrderItem
	s:CTLocId="" CTLocId=%session.Get("LOGON.CTLOCID")
	
    s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",CTLocId))
    s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",CTLocId))
	
	s myStr=##class(web.DHCPE.ResultEdit).GetAgeSex(PAADM)
    s myAge=$p(myStr,"^",1)
    s mySex=$p(myStr,"^",2)
	
	s retInfo=""
	s OrderSub="0"
	f  s OrderSub=$o(^OEORD(Order,"I",OrderSub)) q:OrderSub=""  d
	.s OrderID=Order_"||"_OrderSub
	.s Stat=$p($g(^OEORD(Order,"I",OrderSub,1)),"^",13)
	.q:Stat'=6
	.q:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OrderID))
	
	.s CrmOrder=$o(^DHCPECRMO(0,"OEORI",OrderID,0))
	.q:CrmOrder=""
	.s ArcimID=$p($g(^OEORD(Order,"I",OrderSub,1)),"^",2)
	.q:ArcimID=""
	
	.s QFlag=0
	.s RARRowId=$o(^DHCPACRegInfoi("OEORI",OrderID,0))
	.i RARRowId'="" d
	..s RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
	..s:$d(tmpDHCPEOrdResult(RisStudyNo)) QFlag=1
	..s tmpDHCPEOrdResult(RisStudyNo)=""
	.q:QFlag=1
	.
	.s STID=$o(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
	.s STName=""
	.s:STID'="" STName=$P($g(^DHCPEST(STID)),"^",2)
    
    .s STSort=$P(^DHCPEST(STID),"^",4)
    .i STSort="" s STSort="z"
    
    .s STSub=$o(^DHCPEST(0,"STORD_ARCIM",ArcimID,STID,0))
    .s ItemSort=$p($g(^DHCPEST(STID,"O",STSub)),"^",7)
    .s:ItemSort="" ItemSort="z"
	.s ArcimShortDesc=##class(web.DHCPE.ResultDiagnosisNew).GetOEItemDesc(OrderID)
	
	.s RLTID=0
    .f  s RLTID=$o(^DHCPERLT(0,"OEORI",OrderID,RLTID)) q:RLTID=""  d
    ..s NormalFlag=$p($g(^DHCPERLT(RLTID)),"^",7)
    ..//q:(NormalFlag="1")&&(STID'="1")&&(STID'="9")
    ..q:(NormalFlag="1")&&($g(^DHCPECTDataEx("DHCPEStation",STID,"AllResultShow",CTLocId))'="Y")
    ..s ODID=$p($g(^DHCPERLT(RLTID)),"^",3)
    ..q:ODID=""
    ..s NeedFlag=$p($g(^DHCPEST(+ODID,"OD",$p(ODID,"||",2))),"^",5)
    ..q:NeedFlag="N"
    ..q:$d(tmpDHCPEOrdDetail(ODID))
    ..s tmpDHCPEOrdDetail(ODID)=""
    ..s ODDesc=$p($g(^DHCPEST(+ODID,"OD",$p(ODID,"||",2))),"^",1)
    ..q:ODDesc=""
    
    ..s Result=$p($g(^DHCPERLT(RLTID)),"^",4)
    ..s Result=##class(web.DHCPE.Public.Setting).Replace(Result,"@@","<br>")
    ..i $L(Result,";诊断意见:")>1 d
    ...s Other=$p(Result,";诊断意见:",1)
    ...s ZDYJ=$p(Result,";诊断意见:",2)
    ...s JCSJ=$p(Other,";检查所见:",2)
    ...s Other=$p(Other,";检查所见:",1)
    ...s LCZD=$p(Other,"临床诊断:",2)
    ...s:ZDYJ="" ZDYJ=JCSJ
    ...s Result=ZDYJ
    ..q:Result=""
    
    ..s HighRisk=$p($g(^DHCPERLT(RLTID)),"^",12)
    ..s ODUnit=$p($g(^DHCPEST(+ODID,"OD",$p(ODID,"||",2))),"^",4)
    ..s ODType=$p($g(^DHCPEST(+ODID,"OD",$p(ODID,"||",2))),"^",2)
    ..i LabStation=+ODID d
    ...s NormalResult=$g(^DHCPEDataEx("DHCPEResult",RLTID,"Ranges"))
    ...s ODUnit=$g(^DHCPEDataEx("DHCPEResult",RLTID,"Unit"))
    ..e  d
    ...s NormalResult=##class(web.DHCPE.ResultEdit).GetNormal(ODID,mySex,myAge)
    
    ..s TSInfo="1"
    ..s:(ODType="N")||(ODType="C") TSInfo=##class(web.DHCPE.TransResult).GetLabResultArrowNew(RLTID)
    ..s:TSInfo="2" TSInfo="↑"
    ..s:TSInfo="0" TSInfo="↓"
    ..s:TSInfo'="1" Result=Result_" "_TSInfo
    ..s ResultFormat=##class(web.DHCPE.ResultNew).GetResultFormat(+ODID,CTLocId)
    ..s:ODUnit'="" Result=Result_" "_ODUnit
    ..;s:((ODType="N")||(ODType="C"))&&(NormalResult'="")&&(NormalResult'[("阴性")) Result=Result_"【"_NormalResult_"】"
	
    ..i ResultFormat'=3 d
    ...i LabStation=STID  d
    ....s Desc=ArcimShortDesc_" "_ODDesc
    ...e  s Desc=ODDesc
    ..e  d
    ...s Desc=ArcimShortDesc
    ..;s Result=##class(web.DHCPE.Public.Setting).Replace(Result,$c(13,10),"<br>")
    ..s ret=Desc_":"_Result
    
    ..s ShowSort=$P(^DHCPERLT(RLTID),"^",14)
    ..s:ShowSort="" ShowSort="z"
    ..s tmpDHCPEOrderItem(STSort,ItemSort,ArcimID,ShowSort,RLTID)=ret
	
	i '$d(tmpDHCPEOrderItem) {
		s json."OCCUSUM"=""
		q ..OutJson(0,"无数据",json.%ToJSON())
	}
	s ret=""
	s isort=""
	f  s isort=$o(tmpDHCPEOrderItem(isort)) q:isort=""  d
	.s jsort=""
	.f  s jsort=$o(tmpDHCPEOrderItem(isort,jsort)) q:jsort=""  d
	..s arcid=""
	..f  s arcid=$o(tmpDHCPEOrderItem(isort,jsort,arcid)) q:arcid=""  d
	...s ksort=""
	...f  s ksort=$o(tmpDHCPEOrderItem(isort,jsort,arcid,ksort)) q:ksort=""  d
	....s result=""
	....f  s result=$o(tmpDHCPEOrderItem(isort,jsort,arcid,ksort,result)) q:result=""  d
	.....
	.....s:ret'="" ret=ret_$c(13,10)_$g(tmpDHCPEOrderItem(isort,jsort,arcid,ksort,result))
	.....s:ret="" ret=$g(tmpDHCPEOrderItem(isort,jsort,arcid,ksort,result))
	
	s json."OCCUSUM"=ret
	q ..OutJson(0,"成功",json.%ToJSON())
}

/// Creator：      zhongricheng
/// CreatDate：    
/// Description:： 根据总检ID 获取总检信息
/// Table：        DHC_PE_GeneralSummarizeEx
/// Input：        总检ID    Type (OC-职业病)    Conclusions 结论ID    OutFormatter (Arr-数组,Text-文本)
/// Output：       
/// Return：       返回 json 数组
/// Others：       
/// Debug:		   w ##class(web.DHCPE.GeneralSummarizeEx).GetGSExInfoNew(54565,"OC","","Text") 
ClassMethod GetGSExInfoNew(GSID As %String, Type As %String = "", Conclusions As %String = "", OutFormatter As %String = "")
{
	s GSExInfo=""
	s GSDataArr=[]
	i GSID="" {
		q:OutFormatter="Arr" GSDataArr
		q:OutFormatter="Text" GSDataArr
		q ..OutJson(-1,"总检ID为空","")
	}
	
	s GSEXID=0
	f  s GSEXID=$O(^User.DHCPEGeneralSummarizeExI("GeneralSummarizeID",GSID,GSEXID)) q:GSEXID=""  d
	.s gsExData=$g(^User.DHCPEGeneralSummarizeExD(GSEXID))
	.s status=$lg(gsExData,15)
	.q:status'="U"
	.s exType=$lg(gsExData,14)
	.q:((Type'="")&&(Type'=exType))
	.s concId=$lg(gsExData,3)
	.q:((Conclusions'="")&&(("^"_Conclusions_"^")'[("^"_concId_"^")))
	.s concDesc=$LG(^User.DHCPEConclusionD(concId),3)
	.
	.s endangerList=$lg(gsExData,4)  // 危害因素
	.s endanger=$$HandListData(endangerList,",")
	.s endangerArr=$$HandListObject(endangerList)
	.s endangerDes=$$HandTextData(endangerList,",","Endanger")
	.
	.s criteriaList=$lg(gsExData,5)  // 诊断标准
	.s criteria=$$HandListData(criteriaList,",")
	.s criteriaArr=$$HandListObject(criteriaList)
	.s criteriaDes=$$HandTextData(criteriaList,",","Criteria")
	.
	.s illnessList=$lg(gsExData,6)  // 目标疾病
	.s illness=$$HandListData(illnessList,",")
	.s illnessArr=$$HandListObject(illnessList)
	.s illnessDes=$$HandTextData(illnessList,",","Illness")
	.
	.s suggestions=$lg(gsExData,7)  // 处理意见
	.s testResult=$lg(gsExData,8)  // 检查结果
	.s clinical=$lg(gsExData,9)  // 临床表现
	.s contact=$lg(gsExData,10)  // 职业接触史
	.s userID=$lg(gsExData,11)  // 操作员
	.s userName=""
	.s:userID'="" userName=$p($g(^SSU("SSUSR",userID)),"^",2)
	.s date=$lg(gsExData,12)  // 操作日期
	.s:date'="" date=##class(websys.Conversions).DateLogicalToHtml(date)
	.s time=$lg(gsExData,13)  // 操作时间
	.s:time'="" time=$zt(time)
	.s locID=$lg(gsExData,16)  // 操作科室
	.s locDesc=""
	.s:locID'="" locDesc=$p($g(^CTLOC(locID)),"^",2)
	
	.s data={}
	.s data.ConcId=concId, data.Type=exType, data.Status=status, data.Endanger=endanger, data.Criteria=criteria
	.s data.Illness=illness, data.Suggestions=suggestions, data.result=testResult, data.Clinical=clinical, data.Contact=contact
	.s data.UserID=userID, data.Date=date, data.Time=time, data.LocID=locID
	.s data.ConcDesc=concDesc, data.UserName=userName, data.LocDesc=locDesc
	.s:OutFormatter="Arr" data.EndangerArr=endangerArr, data.CriteriaArr=criteriaArr,data.IllnessArr=illnessArr
	.s:OutFormatter="Text" data.EndangerDes=endangerDes, data.CriteriaDes=criteriaDes,data.IllnessDes=illnessDes
	.d GSDataArr.%Push(data)
	
	q:OutFormatter="Arr" GSDataArr
	q:OutFormatter="Text" GSDataArr
	q ..OutJson(0,"",GSDataArr.%ToJSON())
	
HandListData(list, splitChar)
	s listStr=""
	f ti=1:1:$ll(list) d
	.s temId=$lg($lg(list,ti))
	.q:temId=""
	.s:listStr'="" listStr=listStr_splitChar_temId
	.s:listStr="" listStr=temId
	q listStr
		
HandListObject(list)
	s listArr=[]
	f ti=1:1:$ll(list) d
	.s temId=$lg($lg(list,ti))
	.q:temId=""
	.d listArr.%Push(temId)
	q:listArr.%Size()=0 [""]
	q listArr
	
HandTextData(list, splitChar, dataT)
	s textStr=""
	f ti=1:1:$ll(list) d
	.s temId=$lg($lg(list,ti))
	.q:temId=""
	.s tmpDesc=""
	.s:dataT="Endanger" tmpDesc=$LG(^User.DHCPEEndangerD(temId),3)
	.s:dataT="Criteria" tmpDesc=$LG(^User.DHCPEDiagnosticCriteriaD(temId),3)
	.s:dataT="Illness" tmpDesc=$LG(^User.DHCPEOMEIllnessD(temId),3)
	.q:tmpDesc=""
	.s:textStr'="" textStr=textStr_splitChar_tmpDesc
	.s:textStr="" textStr=tmpDesc
	q textStr
}

ClassMethod OutJson(code, msg, data = "")
{
	s json = {}
	s json.code = code
	s json.msg = msg
	s json.data = data
	q json.%ToJSON()
}

}
