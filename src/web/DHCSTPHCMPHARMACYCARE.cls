Import SQLUser

/// 药学监护模块
Class web.DHCSTPHCMPHARMACYCARE Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:查询药学监护
/// w ##class(web.DHCSTPHCMPHARMACYCARE).QueryPhaCare("30","1","2016-09-17^2016-09-19^^^^")
ClassMethod QueryPhaCare(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s pid=..NewPid()
	s EndPage=page*rows  		 //结束行
	s StPage=((page-1)*rows)+1   //开始行
	s StDate=$p(params,"^",1)    //开始日期
	s EndDate=$p(params,"^",2)   //结束日期
	s WardID=$p(params,"^",3)    //病区
	s DeptID=$p(params,"^",4)    //科室
	s MonLv=$p(params,"^",5)     //级别
	s InPatNo=$p(params,"^",6)   //登记号
	
	d ..killTmpGlobal(pid)
	s StDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(StDate) ;$zdh(StDate,3)
	s EndDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(EndDate) ;$zdh(EndDate,3)
	s QuitFlag=0
	s Num=0
	s monSubClass=""
	f dd=StDate:1:EndDate d
	.s monID=""
	.f  S monID=$o(^DHCPHPC(0,"Date",dd,monID)) Q:monID=""  D
	..s monAdmID=$p(^DHCPHPC(monID),"^",2)      //病人就诊指针
	..s papmi=$p(^PAADM(monAdmID),"^",1)
	..s PatName=$p(^PAPER(papmi,"ALL"),"^",1)   //姓名
	..s PatNo=$p(^PAPER(papmi,"PAT",1),"^",1)   //登记号
	..q:(InPatNo'="")&(InPatNo'=PatNo)
	..s monWardID=$p(^DHCPHPC(monID),"^",3)     //病区ID
	..q:(WardID'="")&(WardID'=monWardID)
	..s monWard=$p(^PAWARD(monWardID),"^",2)
	..s monLocID=$p(^DHCPHPC(monID),"^",4)      //科室ID
	..q:(DeptID'="")&(DeptID'=monLocID)
	..s monLocDesc=$p($p(^CTLOC(monLocID),"^",2),"-",2)
	..s monSubClass=""
	
	..s monSubIdList=..getPatMonSubClass(monID)
	..f i=1:1:$l(monSubIdList,"/") d				//加载多学科分类 qunianpeng 2016-09-20
	...s monSubClassId=$p(monSubIdList,"/",i)    
	...s monSubClass=$p(^DHCPHMSC(monSubClassId),"^",2)

	...s monCount=##Class(web.DHCSTPHCMPHARMACYCARE).getPatMonCount("",monAdmID)
	...s ListData=monAdmID_"^"_PatNo_"^"_PatName_"^"_monWard_"^"_monWardID_"^"_monLocID_"^"_monLocDesc_"^"_monCount_"^"_monSubClassId_"^"_monSubClass
	...s Num=Num+1
	...;s ^TMP("DHCST","web.DHCSTPHCMPHARMACYCARE","QueryPhaCare",pid,monAdmID_"^"_monLocID)=ListData
	...s ^TMP("DHCST","web.DHCSTPHCMPHARMACYCARE","QueryPhaCare",pid,monAdmID_"^"_monSubClassId)=ListData  //qunianpeng 2016-09-20
	
	
	q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMPHARMACYCARE","QueryPhaCare",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMPHARMACYCARE","QueryPhaCare",pid,index)
	.S Title="monAdmID^PatNo^PatName^monWard^monWardID^monLocID^monLocDesc^monCount^monSubClassId^monSubClass"
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:获取监护信息
ClassMethod getMonLevelInfo(AdmDr As %String, MonLevel As %String) As %String
{
	N (AdmDr,MonLevel)
	S monID=""
	S phEPID=""
	F  S phEPID=$o(^DHCPHEP(0,"ADMDR",AdmDr,phEPID)) Q:(phEPID="")||(monID'="")  D
	.S Level=$p(^DHCPHEP(phEPID),"^",6)  //监护
	.//Q:MonLevel'=Level
	.S monID=phEPID

	Q:monID="" ""
	S MonStDate=$p(^DHCPHEP(monID),"^",1)    //开始日期
	i MonStDate'="" S MonStDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(MonStDate)  ;$zd(MonStDate,3)
	S MonStTime=$p(^DHCPHEP(monID),"^",2)   //开始时间
	i MonStTime'="" S MonStTime=$zt(MonStTime,1)
	S MonEndDate=$p(^DHCPHEP(monID),"^",7)  //结束日期
	i MonEndDate'="" S MonEndDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(MonEndDate)  ;$zd(MonEndDate,3)
	S MonEndTime=$p(^DHCPHEP(monID),"^",8)  //结束时间
	i MonEndTime'="" S MonEndTime=$zt(MonEndTime,1)
	S MonUserID=$p(^DHCPHEP(monID),"^",9)   //监护人
	S MonUser=$p(^SSU("SSUSR",MonUserID),"^",2)
	S MonRemark=$p(^DHCPHEP(monID),"^",10)  //备注
	S MonReason=$p(^DHCPHEP(monID),"^",11)  //原因
	
	Q MonStDate_"^"_MonStTime_"^"_MonRemark_"^"_MonEndDate_"^"_MonEndTime_"^"_MonReason_"^"_MonUser
}

/// Descript:获取监护范围
ClassMethod getCareMonScope(MonID) As %String
{
	N (MonID)
	S MonScopeList=""
	S chilsub=""
	F  S chilsub=$o(^DHCPHPC(MonID,"MS",chilsub)) Q:chilsub=""  D
	.S MonScopeID=$p(^DHCPHPC(MonID,"MS",chilsub),"^",1)
	.Q:'$D(^DHCPHMS(MonScopeID))
	.S MonScopeDesc=$p(^DHCPHMS(MonScopeID),"^",2)
	.i MonScopeList'="" S MonScopeList=MonScopeList_"; "_MonScopeDesc
	.E  S MonScopeList=MonScopeDesc
	Q MonScopeList
}

/// Descript:获取监护项目
ClassMethod getCareMonItem(MonID) As %String
{
	N (MonID)
	S MonItemList=""
	S chilsub=""
	F  S chilsub=$o(^DHCPHPC(MonID,"MI",chilsub)) Q:chilsub=""  D
	.S MonItemID=+$p(^DHCPHPC(MonID,"MI",chilsub),"^",1)
	.Q:$d(^DHCPHMI(MonItemID))=10
	.Q:'$d(^DHCPHMI(MonItemID))
	.S MonItemDesc=$p(^DHCPHMI(MonItemID),"^",2)
	.S MonItemVal=$p(^DHCPHPC(MonID,"MI",chilsub),"^",2)
	.S MonItemDesc=$replace(MonItemDesc,"[]",MonItemVal)
	.i MonItemList'="" S MonItemList=MonItemList_"; "_MonItemDesc
	.E  S MonItemList=MonItemDesc
	Q MonItemList
}

/// Descript:关注药品
/// w ##class(web.DHCSTPHCMPHARMACYCARE).getMonDrgItm("102")
ClassMethod getMonDrgItm(MonID As %String) As %String
{
	N (MonID)

	S pid=..NewPid()
	d ..killTmpGlobal(pid)

	S Num=0
	S chilsub=""
	F  S chilsub=$o(^DHCPHPC(MonID,"DI",chilsub)) Q:chilsub=""  D
	.S oeori=$p(^DHCPHPC(MonID,"DI",chilsub),"^",1)  //医嘱ID
	.S ArcItmId=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	.S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.Q:inci=""  //医嘱名称
	.S incidesc=$p(^INCI(inci,1),"^",2) //药品名称
	.S phcdf=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12) q:phcdf=""
    .S genenicdr=$p($g(^PHCD(+phcdf,4)),"^",1)
    .S genenic=$p($g(^PHCGE("GE",genenicdr)),"^",2) //通用名
    .S manf=""
    .S manfdr=$p($g(^PHCD(+phcdf,2)),"^",4) //厂家
    .S:manfdr'="" manf=$p($p($g(^PHMNF(manfdr)),"^",2),"-",2)
	.S ListData=oeori_"^"_incidesc_"^"_genenic_"^"_manf
	.
	.S Num=Num+1
	.S ^TMP("DHCST","web.DHCSTPHCMPHARMACYCARE","getMonDrgItm",pid,Num)=ListData

	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMPHARMACYCARE","getMonDrgItm",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMPHARMACYCARE","getMonDrgItm",pid,index)
	.S Title="oeori^goodname^genenic^manf"
	.S Num=Num+1
	.//Q:Num<StPage
	.//S:Num=EndPage quitflag=1
	.I Num=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:获取病人相关指标
ClassMethod getPatLabItems(EpisodeID) As %String
{
	n (EpisodeID)
	s MonitorItmList=""
	s OrderID=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:OrderID="" ""
	S SubID=""
    f  S SubID=$o(^OEORDi(0,"LabNotRead",OrderID,SubID))  q:SubID=""  d
    .S OrdItem=OrderID_"||"_SubID
    .S OrdDate=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",7) //医嘱日期
    .Q:OrdDate<(+$h-1)
	.S LabTestSetRow=$p($g(^OEORD(+OrderID,"I",SubID,3)),"^",35)
	.S VisitNumber=$p(LabTestSetRow,"||",1)
	.S TestSet=$p(LabTestSetRow,"||",2)
	.S TestSetCount=$p(LabTestSetRow,"||",3)
	.Q:(VisitNumber="")||(TestSet="")||(TestSetCount="")
	.s TestCode=""
    .f  s TestCode=$o(^TEPI(VisitNumber,1,TestSet,TestSetCount,"DATA",TestCode)) q:TestCode=""  d
	..q:'$d(^DHCPHLabItems("LabItems",TestCode))  ///非关注指标
	..s tmpResult=$g(^TEPI(VisitNumber,1,TestSet,TestSetCount,"DATA",TestCode))
	..s tmpResult=$p(tmpResult,"\",1)
	..s LabResult=##Class(web.DHCSTPHCMFUNLIBITM).GetTestCodeResult(VisitNumber,TestCode,tmpResult)
	..s LabResult=$TRanslate(LabResult,$Char(13,10),"")
	..s ItemCode=$p(LabResult,$c(2),1)    //检验项目描述
	..s ItemDesc=$p(LabResult,$c(2),2)    //检验项目描述
	..s ItemResult=$p(LabResult,$c(2),3)  //结果
	..s ItemUnit=$p(LabResult,$c(2),4)    //检验项目的单位
	..s AbnorFlag=$p(LabResult,$c(2),5)   //异常标记
	..s AbnorFlag=$p(AbnorFlag,$c(28),2)
	..s RefRanges=$p(LabResult,$c(2),6)   //参考范围
	..s RangL=$p(RefRanges,$c(1),1)  //低值
	..s RangH=$p(RefRanges,$c(1),2)  //高值
	..s ItmRange=""
	..If $Length(RangL) s ItmRange=RangL_"-"_RangH
	..If $E(RangL,1)="<" s ItmRange=RangL
	..If $E(RangL,1)=">" s ItmRange=RangL
	..s $p(LabResult,$c(2),6)=ItmRange
	..
    ..i MonitorItmList="" d
    ...s MonitorItmList=ItemDesc_":"_ItemResult_ItemUnit //_"["_LabResult_"]"
    ..e  s MonitorItmList=MonitorItmList_";"_ItemDesc_":"_ItemResult_ItemUnit //_"["_LabResult_"]"
  q MonitorItmList
}

/// Descript:病人监护列表
/// w ##class(web.DHCSTPHCMPHARMACYCARE).getPatMonList(2,198)
ClassMethod getPatMonList(monLevId As %String, AdmDr As %String) As %String
{
	n (monLevId, AdmDr,%session)
	q:AdmDr="" "[]"
	s retArr = []
	k monLevelArr
	s monID="", count=0
	f  s monID=$o(^DHCPHPC(0,"ADM",AdmDr,monID)) q:monID=""  d
	.s tmpArr = {}
	.s monLeID=$p(^DHCPHPC(monID),"^",1)
	.s monLeDesc=$p(^DHCPHML(monLeID),"^",2)
	.s monLeDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMonLevel","PHMLDesc","",monLeDesc)
	.s Desc=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("监护")
	.s tmpArr.text = monLeDesc
	.i '$d(monLevelArr(monLeDesc)) d
	..s monLevelArr(monLeDesc)=""
	..d tmpArr.%Set("id","level"_monLeID)
	..d tmpArr.%Set("text",monLeDesc_Desc)
	..d tmpArr.%Set("_parentId","")
	..d tmpArr.%Set("color",$p(^DHCPHML(monLeID),"^",3))
	..d retArr.%Push(tmpArr)
	..s tmpArr = {}
	..s count=count+1
	.s monUser=""
	.s monUserID=$p(^DHCPHPC(monID),"^",5)  //监护人
	.s:monUserID'="" monUser=$p(^SSU("SSUSR",monUserID),"^",2)
	.s monUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",monUser)
	.s monDate=$p(^DHCPHPC(monID),"^",6)  //监护日期
	.s:monDate'="" monDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(monDate) ;$zd(monDate,1)
	.s monTime=$p(^DHCPHPC(monID),"^",7)  //监护时间
	.s:monTime'="" monTime=$zt(monTime,1)
	.d tmpArr.%Set("id",monID)
	.d tmpArr.%Set("text",monDate_" "_monUser)
	.d tmpArr.%Set("monLevId",monLeID)
	.d tmpArr.%Set("monId",monID)
	.d tmpArr.%Set("_parentId","level"_monLeID)
	.d retArr.%Push(tmpArr)
	.s count=count+1
	k monLevelArr
	s json={}
	s json.total = count
	s json.rows = retArr
	q json.%ToJSON()
}

/// Descript:病人监护范围
ClassMethod getPatMonScopeList(monId As %String) As %String
{
    n (monId,%session)
    q:monId="" "[]"
	w "["
	s CH="",count=0
	f  s CH=$o(^DHCPHPC(monId,"MS",CH)) q:CH=""  d
	.s monScopeID=$p(^DHCPHPC(monId,"MS",CH),"^",1)
	.q:'$D(^DHCPHMS(monScopeID))
	.s monScopeDesc=$p(^DHCPHMS(monScopeID),"^",2)
	.s monScopeDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMonScope","PHMSDesc","",monScopeDesc)
	.s ListData=monScopeID_"^"_monScopeDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData("monScopeID^monScopeDesc",ListData)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("monScopeID^monScopeDesc",ListData)
	w "]"
	q ""
}

/// Descript:病人监护项目
ClassMethod getPatMonItemList(monId As %String) As %String
{
    n (monId,%session)
    q:monId="" "[]"
	w "["
	s CH="",count=0
	f  s CH=$o(^DHCPHPC(monId,"MI",CH)) q:CH=""  d
	.s monItemID=$p(^DHCPHPC(monId,"MI",CH),"^",1)
	.q:$d(^DHCPHMI(monItemID))=10
	.q:'$d(^DHCPHMI(monItemID))
	.s monItemDesc=$p(^DHCPHMI(monItemID),"^",2)
	.s monItemDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMonItem","PHMIDesc","",monItemDesc)
	.s monItemVal=$p(^DHCPHPC(monId,"MI",CH),"^",2)
	.s monItemDesc=$replace(monItemDesc,"[]",monItemVal)
	.
	.s ListData=monItemID_"^"_monItemVal_"^"_monItemDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData("monItemID^monItemVal^monItemDesc",ListData)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("monItemID^monItemVal^monItemDesc",ListData)
	w "]"
	q ""
}

/// Descript:病人监护项目
ClassMethod getMonImpLabsAndGuidCon(monID As %String) As %String
{
    n (monID,%session)
    q:monID="" "[]"
	w "["
	s ImpMonContent=$p(^DHCPHPC(monID),"^",8)  //相关内容
	s ImpMonItems=$p(^DHCPHPC(monID),"^",9)  //重要检验
	s ImpMonContent=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHPharCare","PHPCContent","",ImpMonContent)
	s ImpMonItems=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHPharCare","PHPCImpMonItems","",ImpMonItems)
	s ListData=ImpMonContent_"^"_ImpMonItems
	w ##class(web.DHCSTPHCMCOMMON).getJsonData("ImpMonContent^ImpMonItems",ListData)
	w "]"
	q ""
}

/// Descript:监护记录对应的监护类别
/// w ##class(web.DHCSTPHCMPHARMACYCARE).getPatMonSubClass(5)
ClassMethod getPatMonSubClass(monId) As %String
{
	n (monId)
	s monSubClassId=""
	s monSubIdList=""
	s ch=""
	f  s ch=$o(^DHCPHPC(monId,"MS",ch)) q:(ch="")  d  //qunianpeng 2016-09-20
	.s monScopeID=$p(^DHCPHPC(monId,"MS",ch),"^",1)
	.q:'$d(^DHCPHMS(monScopeID))
	.s monSubClassId=$p(^DHCPHMS(monScopeID),"^",5)  ///学科分类
	.s:'(monSubIdList[monSubClassId) monSubIdList=monSubIdList_"/"_monSubClassId  //去掉重复的学科分类Id   qunianpeng 2016-09-20
	
	s monSubIdList=$e(monSubIdList,2,$l(monSubIdList))   //去掉拼接学科分类中第一个多余的/  qunianpeng 2016-09-20
	q:monSubIdList'="" monSubIdList						
	
	
	s ch=""
	f  s ch=$o(^DHCPHPC(monId,"MI",ch)) q:(ch="")||(monSubClassId'="")  d
	.s monItemID=$p(^DHCPHPC(monId,"MI",ch),"^",1)
	.q:+monItemID=0
	.q:'$d(^DHCPHMI(monItemID))
	.s monSubClassId=$p(^DHCPHMI(monItemID),"^",5)  ///学科分类
	q monSubClassId
}

/// Descript:病人监护次数
ClassMethod getPatMonCount(monLevId As %String, AdmDr As %String) As %String
{
	n (monLevId, AdmDr)
	q:AdmDr="" ""
	s monID="", Num=""
	f  s monID=$o(^DHCPHPC(0,"ADM",AdmDr,monID)) q:monID=""  d
	.s monLeID=$p(^DHCPHPC(monID),"^",1)
	.//q:(monLevId'="")&(monLevId'=monLeID)
	.s Num = Num+1
	.
	q Num
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMPHARMACYCARE","QueryPhaCare",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMPHARMACYCARE"))
}

}
