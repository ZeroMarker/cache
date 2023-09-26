Import sqluser

/// Descript:生成点评单
/// Creater: wxj
/// CreateDate: 2019-10-23
Class web.DHCSTMHUI.CreateComment Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTMCOMMENT";

ClassMethod JobGetHvOrdNum(Params)
{
	s pid=..NewPid()
	Job ..GetHvOrdNum(pid,Params)
	q pid
}

ClassMethod GetHvOrdNum(pid, Params)
{
	s $zt="ThrowGetHvOrdNum"
	s Ret=..Select(Params)
	s ^JOBDHCMATCNT(pid)=Ret
	q Ret
ThrowGetHvOrdNum
	s errCode="-1^"_$tr($ze,"^","")
	s ^JOBDHCSTCNTS(pid)=errCode
	q errCode
}

/// Descripiton:统计高值医嘱数量
/// CreateDate:2019-10-23
/// Creater:wxj
/// w ##class(web.DHCSTMHUI.CreateComment).Select("{""StartDate"":""02/09/2019"",""gUserId"":""6423"",""gLocId"":""392"",""gGroupId"":""264"",""gHospId"":""2"",""OriLoc"":""110"",""StkGrpId"":"""",""EndDate"":""23/10/2019"",""OriDoctor"":""5007"",""StkCat"":"""",""Inci"":"""",""InciDesc"":""""}")
ClassMethod Select(Params As %Text) As %String
{
	n (Params)
	s npid=..NewPid()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s OriLoc=PJObj.%Get("OriLoc")
	s OriDoctor=PJObj.%Get("OriDoctor")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s StkGrpId=PJObj.%Get("StkGrpId")
	s StkCat=PJObj.%Get("StkCat")
	s Incid=PJObj.%Get("Inci")
	s TmpIncDesc=PJObj.%Get("InciDesc")
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	s cnt=0
	s tmptype="MP^MF^P^F"
	f date=StartDate:1:EndDate d
	.s orirowid=""
	.f  s orirowid=$o(^DHCHVMORI(0,"DATE",date,orirowid)) q:orirowid=""  d
	..s oridate=$p(^DHCHVMORI(orirowid,1),"^",2)	//医嘱日期
	..s:oridate'="" oridate=..DL2H(oridate)
	..s barcode=$p(^DHCHVMORI(orirowid,1),"^",24)	//高值条码
	..q:barcode=""
	..s dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
	..s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",barcode,0))
	..q:dhcit=""
	..s typeLoc=##class(web.DHCSTMHUI.DHCItmTrack).GetTypeLoc(dhcit) ;当前科室
	..s curtype=$p(typeLoc,"^",1)
	..q:(("^"_tmptype_"^")'[("^"_curtype_"^"))  ;过滤未使用的
	..s oeori=$p(^DHCHVMORI(orirowid,1),"^",1)	//医嘱id
	..s OrdUserId=$p(^DHCHVMORI(orirowid,1),"^",4)		;开单医生
	..q:(OriDoctor'="")&&(OrdUserId'=OriDoctor)
	..s:OrdUserId'="" OrdUserId=$o(^SSU("SSUSR",0,"CTPCP",OrdUserId,0))
	..s OrilocId = $p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",3)	//;医嘱开单科室
	..q:(OriLoc'="")&&(OriLoc'=OrilocId)
	..;s OriReclocId = $p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",6)	//;医嘱接收科室
	..;q:(LocId'="")&&(OriReclocId'=LocId)
	..;s:OriReclocId'="" orirecloc=$p(^CTLOC(orireclocid),"^",2)
	..s SCG=$p(^DHCHVMORI(orirowid,1),"^",11)	//类组
	..q:(StkGrpId'="")&&(StkGrpId'=SCG)
	..s inci=$p(^DHCHVMORI(orirowid,1),"^",34)	//物资id	
	..q:(Incid'="")&&(Incid'=inci)
	..s incsc=$p(^INCI(inci,2),"^",2)	//库存分类
	..q:(StkCat'="")&&(StkCat'=incsc)
	..s cnt=cnt+1
	..s ^TMPDHCMATCNT("Select","Common",npid,cnt)=orirowid
	q 0_"^"_cnt_"^"_npid
}

Query GetHvOrdItm(Params As %String) As Query(ROWSPEC = "Orirowid,Oeori,InciCode,InciDesc,Spec,BarCode,OrdLocDesc,OrdUser,OriDate")
{
}

ClassMethod GetHvOrdItmExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK
	s extraRet=..Select(Params)
	s extraSucc=$p(extraRet,"^",1)

	s extraCnt=$p(extraRet,"^",2)
	s extraPid=$p(extraRet,"^",3)
	q:extraSucc'=0 $$$OK
	q:extraCnt=0 $$$OK
	s cnt=0
	f  s cnt=$o(^TMPDHCMATCNT("Select","Common",extraPid,cnt)) q:cnt=""  d
	.s Orirowid=$g(^TMPDHCMATCNT("Select","Common",extraPid,cnt))
	.s Oeori=$p(^DHCHVMORI(Orirowid,1),"^",1)	//医嘱id
    .s OriDate=$p(^DHCHVMORI(Orirowid,1),"^",2)	//医嘱日期
	.s:OriDate'="" OriDate=..DL2H(OriDate)
	.s BarCode=$p(^DHCHVMORI(Orirowid,1),"^",24)	//高值条码
	.s Inci=$p(^DHCHVMORI(Orirowid,1),"^",34)
	.s OrdUserId=$p(^DHCHVMORI(Orirowid,1),"^",4)		;开单医生
	.s (OrdUser,OrdLocDesc)=""
	.s:OrdUserId'="" OrdUser=$o(^SSU("SSUSR",0,"CTPCP",OrdUserId,0))
	.s OriLocId = $p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),1),"^",3)	//;医嘱开单科室
	.s:OriLocId'="" OrdLocDesc=$p(^CTLOC(OriLocId),"^",2)
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.d OutPutOrdItm
	Quit $$$OK
OutPutOrdItm
	s Data=$lb(Orirowid,Oeori,InciCode,InciDesc,Spec,BarCode,OrdLocDesc,OrdUser,OriDate)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod JobSaveCommentData(ParamsQuery, ParamsSave)
{
	s pid=..NewPid()
	Job ..GetSaveCommentData(pid,ParamsQuery, ParamsSave)
	q pid
}

ClassMethod GetSaveCommentData(pid, ParamsQuery, ParamsSave)
{
	s saveRet=..SaveCommentData(ParamsQuery, ParamsSave)
	s ^JOBDHCMATCNT(pid)=saveRet
	q saveRet
}

/// w ##class(web.DHCSTMHUI.CreateComment).SaveCommentData("{""StartDate"":""2018-08-26"",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2"",""OriLoc"":"""",""StkGrpId"":"""",""EndDate"":""2019-11-18"",""OriDoctor"":"""",""StkCat"":"""",""Inci"":"""",""InciDesc"":""""}","{""saveType"":""rNum"",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2"",""conSaveRandomNum"":""4"",""conSpaceQty"":"""",""conTheoryQty"":"""",""conSavePercent"":"""",""conWriteQty"":"""",""conASpaceQty"":""""}")
ClassMethod SaveCommentData(ParamsQuery, ParamsSave)
{
	n (ParamsQuery, ParamsSave)
	s ^tempxj("com")=$lb(ParamsQuery, ParamsSave)
	s RtnObj=##class(RtnObj).%New()
	s extraRet=..Select(ParamsQuery)
	s extraSucc=$p(extraRet,"^",1)
	s extraCnt=$p(extraRet,"^",2)
	s extraPid=$p(extraRet,"^",3)
	i extraCnt=0 d RtnObj.Err(-2,"","没有符合条件的点评数据!","",0)
	q:RtnObj.success<0 RtnObj
 	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
 	s Sc=PJObj.%FromJSON(ParamsSave)
 	i Sc'=0 d
 	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
 	q:RtnObj.success'=0 RtnObj
 	s randNum=PJObj.%Get("conSaveRandomNum") // 随机数
	s centNum=PJObj.%Get("conSavePercent") 	// 抽取比例
	s spaceNum=PJObj.%Get("conSpaceQty") // 间隔数
	s randRet=..GeneRandom(extraPid,extraCnt,randNum,centNum,spaceNum)
	q:$p(randRet,"^",1)<0 randRet
	s Coditions=..GetConditions(ParamsQuery,randNum,centNum,spaceNum)
	tstart
	//保存主表
	s RtnObj=..SaveComment("",ParamsSave,Coditions)
	i RtnObj.success<0 tro  q RtnObj	
	s mainId=RtnObj.rowid
	//保存子表
	s RtnObj=..SaveComItm(extraPid,mainId)
	i RtnObj.success<0 tro  q RtnObj
	tcommit
	s commentNo=$LG(^User.DHCMatCommentsD(mainId),2)
	q 0_"^"_commentNo
}

/// 插入或更新点评主表记录
/// w ##class(web.DHCSTMHUI.CreateComment).SaveComment("","{""saveType"":""rNum"",""gUserId"":""6423"",""gLocId"":""392"",""gGroupId"":""264"",""gHospId"":""2"",""conSaveRandomNum"":""2"",""conSpaceQty"":"""",""conTheoryQty"":"""",""conSavePercent"":"""",""conWriteQty"":"""",""conASpaceQty"":""""}")
ClassMethod SaveComment(MatCntId As %String, ParamsSave As %String, Coditions As %String) As RtnObj
{
 n (MatCntId,ParamsSave,Coditions)
 s RtnObj=##class(RtnObj).%New()
 s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
 s Sc=PJObj.%FromJSON(ParamsSave)
 i Sc'=0 d
 .s Sc=RtnObj.Err(-1,"","入参解析失败!")
 q:RtnObj.success'=0 RtnObj
 s CreateUser=PJObj.%Get("gUserId")
 s LocId=PJObj.%Get("gLocId")
 s HospId=PJObj.%Get("gHospId")
 s CreateDate=+$h    //生成日期
 s CreateTime=$p($h,",",2)  //生成时间 
 i MatCntId=""  d  
 .s MATCNTNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(..%GetParameter("AppName"),"",LocId) 
 .i MATCNTNo="" s Sc=RtnObj.Err(-2,"","生成单号失败!")
 q:RtnObj.success'=0 RtnObj
 i MatCntId="" d
 .s Obj=##class(User.DHCMatComments).%New()
 .s Obj.MATCNTNo=MATCNTNo
 e  d
 .s Obj=##class(User.DHCMatComments).%OpenId(MatCntId)
 s Obj.MATCNTCreateDate=CreateDate
 s Obj.MATCNTCreateTime=CreateTime
 d Obj.MATCNTCreateUserSetObjectId(CreateUser)
 s Obj.MATCNTConditions=Coditions
 i HospId'="" d
 .d Obj.MATCNTHospDRSetObjectId(HospId)
 s Sc=Obj.%Save()
 i $$$ISERR(Sc) s Sc=RtnObj.Err(-3,"","更新主表失败!")
 q:RtnObj.success'=0 RtnObj
 s RowId= Obj.%Id()
 s RtnObj.rowid=RowId
 q RtnObj
}

/// Description:保存点评明细表数据
/// Input:
/// CreateDate:2019-10-23
/// Creater:wxj
/// w ##class(web.DHCSTMHUI.CreateComment).SaveComItm()
ClassMethod SaveComItm(pid As %String, MainId As %String) As RtnObj
{
	n (pid,MainId)
	s ^tempxj("SaveComItm")=$lb(pid,MainId)
	s RtnObj=##class(RtnObj).%New()
	i MainId="" s Sc=RtnObj.Err(-11,"","主单Id不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s errCode=""
	s itmnum=""
	f  s itmnum=$o(^TMPDHCMATCNT("Select","GeneRandom",pid,itmnum)) q:(itmnum="")||(RtnObj.success'=0)  d
	.s orirowid=$g(^TMPDHCMATCNT("Select","GeneRandom",pid,itmnum))
	.s oeori=$p(^DHCHVMORI(orirowid,1),"^",1)	//医嘱id
	.s OrdUserId=$p(^DHCHVMORI(orirowid,1),"^",4)		;开单医生
	.s OrilocId = $p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",3)	//;医嘱开单科室
	.;s OriReclocId = $p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",6)	//;医嘱接收科室
	.s RtnObj=..SaveItm(MainId,orirowid,OrdUserId,OrilocId)
	q RtnObj
}

/// w ##class(web.DHCSTMHUI.CreateComment).SaveItm(5,43)
ClassMethod SaveItm(MainId As %String, orirowid As %String, OrdUserId As %String, OrilocId As %String) As RtnObj
{
 n (MainId,orirowid,OrdUserId,OrilocId)
 s RtnObj=##class(RtnObj).%New()
 i MainId'="" q:..sssLock(..%GetParameter("AppName")_MainId)<0 -99		//锁定
 s obj=##class(User.DHCMatCommentsItm).%New(MainId)
 d obj.MATCNTIParRefSetObjectId(MainId)
 d obj.MATCNTIHvOrdItmDRSetObjectId(orirowid)
 d obj.MATCNTIOriLocDRSetObjectId(OrilocId)
 d obj.MATCNTIOriDoctorDRSetObjectId(OrdUserId)
 s Sc=obj.%Save()
 i $$$ISERR(Sc) d RtnObj.Err(-2,"","更新子表失败!")
 q:RtnObj.success'=0 RtnObj
 s RowId= obj.%Id()
 i RowId'="" d ..sssUnLock(..%GetParameter("AppName")_MainId)
 s RtnObj.rowid=RowId
 q RtnObj
}

/// Description: 公用NewPid方法
ClassMethod NewPid()
{
	q $i(^DHCSTMPID("PID"))
}

/// 此处不适用临时global,获取job返回值
ClassMethod JobRecieve(pid)
{
	s ret=$g(^JOBDHCMATCNT(pid))
	k ^JOBDHCMATCNT(pid)
	q ret
}

/// Description: 生成随机数据
/// input:extraPid(进程号),extraCnt(抽取总数),randNum(随机数),centNum(抽取比例), spaceNum(间隔数)
ClassMethod GeneRandom(extraPid As %String, extraCnt As %String, randNum As %String, centNum As %String, spaceNum As %String) As %String
{
	n (extraPid, extraCnt, randNum, centNum, spaceNum)
	i +centNum'=0 s randNum=(extraCnt*centNum)/100 	// 抽取比例不为空,则随机数按抽取比例计算
    s randNum=$p(randNum,".")
    i randNum>(extraCnt*0.8) q -1_"^抽取比例不能大于80%"	// 抽取比例大于80%
    i +spaceNum=0 d    
    .// 按随机数
    .s randCnt=0
    .f  q:randCnt=randNum  d
    ..s rand=$r(extraCnt)+1
    ..q:$d(GeneRandomData(rand))
    ..s GeneRandomData(rand)=""
    ..s randCnt=randCnt+1
    e  d 				
    .// 按间隔数,按区间抽取随机数,均匀分布 extraCnt=10  spaceNum=2
    .s spaceCnt=extraCnt\spaceNum	// 按此间隔得到的总数-整
    .s remainder=extraCnt#spaceNum	// 余数
    .i spaceCnt>=randNum d			// 该总数需大于随机数
    ..s spaceI=""
    ..f spaceI=0:1:spaceCnt d
    ...q:(spaceI=spaceCnt)&&(remainder=0)
    ...s spaceSt=spaceI*spaceNum+1		
    ...s range=spaceNum				// 随机数区间,最后可能不同,余数部分
    ...i spaceI=spaceCnt s range=remainder
    ...s rand=$r(range)				
	...s rand=spaceSt+rand			
    ...s GeneRandomData(rand)=""
    // 获取计算后的随机数据
    s rand="",cnt=0
    f  s rand=$o(GeneRandomData(rand)) q:rand=""  d
    .s orirowid=$g(^TMPDHCMATCNT("Select","Common",extraPid,rand))
    .s cnt=cnt+1
    .s ^TMPDHCMATCNT("Select","GeneRandom",extraPid,cnt)=orirowid
    k ^TMPDHCMATCNT("Select","Common",extraPid)
	q 0
}

/// Description: 获取查询条件
ClassMethod GetConditions(ParamsQuery As %String, randNum As %String = "", centNum As %String = "", spaceNum As %String = "") As %String
{
	n (ParamsQuery,randNum,centNum,spaceNum)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(ParamsQuery)
	s OriLoc=PJObj.%Get("OriLoc")
	s OriDoctor=PJObj.%Get("OriDoctor")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s StkGrpId=PJObj.%Get("StkGrpId")
	s StkCat=PJObj.%Get("StkCat")
	s Incid=PJObj.%Get("Inci")	
	s Conditions="日期范围:"
	s Conditions=Conditions_StartDate_"-"_EndDate
	i OriLoc'="" d
	..s OriLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(OriLoc)
	..s Conditions=Conditions_",开单科室:"_OriLocDesc
	i OriDoctor'="" d
	..s OriDoctorDesc=$p(^SSU("SSUSR",OriDoctor),"^",2)
	..s Conditions=Conditions_",开单医生:"_OriDoctorDesc
	i StkGrpId'="" d
	..s StkGrp=$p(^DHCSCG(StkGrpId),"^",2)
	..s Conditions=Conditions_",类组:"_StkGrp
	i Incid'="" d
	..s InciDesc=$p(^INCI(Incid),"^",2)
	..s Conditions=Conditions_",物资名称:"_InciDesc
	s:randNum'="" Conditions=Conditions_",随机数:"_randNum
	s:centNum'="" Conditions=Conditions_",百分比:"_centNum
	s:spaceNum'="" Conditions=Conditions_"间隔数:"_spaceNum
	q Conditions
}

}
