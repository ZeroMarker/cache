Class web.DHCANOPData Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod UpdateANOPData(opaId, anopData = "", PreDate = "", userId = "") As %String
{
	s ^TEMPYQ("OPAID")=opaId_"^"_anopData_"^"_PreDate_"^"_userId
	s curDate=+$h
	s curTime=$p($h,",",2)
	s ^TMPCCQ(opaId,"ANOPData",curDate,curTime)=anopData
	//排班^麻醉^手术^附加手术
	q:(+opaId=0) "手术申请号不能为空!"
	q:$d(^DHCANOPArrange(opaId))<1 "申请号有误!"
	s opaStr=$p(anopData,"^")
	s anaStr=$p(anopData,"^",2)
	s anopStr=$p(anopData,"^",3)
	s attAnaopStr=$p(anopData,"^",4)
	s aniInfoStr=$p(anopData,"^",5)
	s inOutInfoStr=$p(anopData,"^",6)
	
	s preAssStr=$p(PreDate,"^",1)
	s preSedationAssStr=$p(PreDate,"^",2)
	s outRoomStr=$p(PreDate,"^",3)
	//s puncStr=$p(anopData,"^",4)
	//s ansStr=$p(anopData,"^",6)
	//s aniStr=$p(anopData,"^",7)
	
	s anaId=$p(^DHCANOPArrange(opaId),"^",2)
	s EpisodeID=+anaId
	s anaSub=$p(anaId,"||",2)
	
	s retStr=##Class(web.DHCANOPData).UpdateOpArrInfo(opaId,opaStr)
	//q:retStr'=0 retStr
	
	s retStr=##Class(web.DHCANOPData).UpdateAnaInfo(opaId,anaStr)
	//q:retStr'=0 retStr
	
	s retStr=##Class(web.DHCANOPData).UpdateANAOPInfo(opaId,anopStr,userId)
	//q:retStr'=0 retStr

	s retStr=##class(web.DHCANOPCom).UpdateAttOperation(anaId, attAnaopStr)
	//q:retStr'=0 retStr
	s retStr=..UpdateAnaestItem(opaId,aniInfoStr)
	
	s retStr=..UpdateInOutInfo(opaId,inOutInfoStr)
	
	s retStr=..UpdatePreAssInfo(opaId,preAssStr)
	
	s retStr=..UpdateSedationAssInfo(opaId,preSedationAssStr)
	
	s retStr=..UpdateOutRoomInfo(opaId,outRoomStr)
	//s retStr=##Class(web.DHCANCom).UpdateAnShift(opaId,ansStr)
	//q:retStr'=0 retStr
	
	q retStr
}

ClassMethod UpdateOutRoomInfo(opaId, outroomStr) As %String
{
	s $p(^DHCANOPArrange(opaId,"PACU"),"^",13)=$p(outroomStr,$c(3),1)
	s $p(^DHCANOPArrange(opaId,"PA"),"^",101)=$p(outroomStr,$c(3),2) 
	s $p(^DHCANOPArrange(opaId,"PA"),"^",102)=$p(outroomStr,$c(3),3) 
	s $p(^DHCANOPArrange(opaId,"PA"),"^",103)=$p(outroomStr,$c(3),4) 
	q 0
}

ClassMethod UpdatePreAssInfo(opaId, preAssStr) As %String
{
	
	s $p(^DHCANOPArrange(opaId,"PA"),"^",1)=$p(preAssStr,$c(3),1)         //现病史
	s $p(^DHCANOPArrange(opaId,"PA"),"^",44)=$p(preAssStr,$c(3),2)        //系统疾病史
	s $p(^DHCANOPArrange(opaId,"PA"),"^",46)=$p(preAssStr,$c(3),3)        //手术镇静麻醉史
	s $p(^DHCANOPArrange(opaId,"PA"),"^",54)=$p(preAssStr,$c(3),4)        //烟酒史
	s $p(^DHCANOPArrange(opaId,"PA"),"^",50)=$p(preAssStr,$c(3),5)        //用药情况和药物滥用史
	s $p(^DHCANOPArrange(opaId,"PA"),"^",48)=$p(preAssStr,$c(3),6)        //过敏史
	s $p(^DHCANOPArrange(opaId,"PA"),"^",56)=$p(preAssStr,$c(3),7)        //怀孕(无字段存储)
	s $p(^DHCANOPArrange(opaId,"PA"),"^",57)=$p(preAssStr,$c(3),8)        //哺乳(无字段存储)
	s $p(^DHCANOPArrange(opaId,"PA"),"^",64)=$p(preAssStr,$c(3),9)        //神志
	s $p(^DHCANOPArrange(opaId,"PA"),"^",27)=$p(preAssStr,$c(3),10)       //营养状态(无字段存储)
	s $p(^DHCANOPArrange(opaId,"PA"),"^",86)=$p(preAssStr,$c(3),11)       //插管评估
	s $p(^DHCANOPArrange(opaId,"PA"),"^",68)=$p(preAssStr,$c(3),12)       //牙齿/口腔/颌面
	s $p(^DHCANOPArrange(opaId,"PA"),"^",66)=$p(preAssStr,$c(3),13)       //Mallampati分级
	s $p(^DHCANOPArrange(opaId,"PA"),"^",58)=$p(preAssStr,$c(3),14)       //系统体格检查
	s $p(^DHCANOPArrange(opaId,"PA"),"^",83)=$p(preAssStr,$c(3),15)       //辅助检查
	s $p(^DHCANOPArrange(opaId,"PA"),"^",94)=$p(preAssStr,$c(3),16)       //实验室检查
	s $p(^DHCANOPArrange(opaId,"PA"),"^",108)=$p(preAssStr,$c(3),17)      //术后去向(无字段存储)
	s $p(^DHCANOPArrange(opaId,"PA"),"^",109)=$p(preAssStr,$c(3),18)      //术前评估麻醉医生(无字段存储)
	q "0"
}

ClassMethod UpdateSedationAssInfo(opaId, preSedationAssStr) As %String
{
	s $p(^DHCANOPArrange(opaId,"PA"),"^",93)=$p(preSedationAssStr,$c(3),1)      //OSAS/困难插管史
	s $p(^DHCANOPArrange(opaId,"PACU"),"^",20)=$p(preSedationAssStr,$c(3),2)    //镇静麻醉后恶心呕吐史
	s $p(^DHCANOPArrange(opaId,"PA"),"^",16)=$p(preSedationAssStr,$c(3),3)      //胃肠返流误吸史(无字段存储)
	s $p(^DHCANOPArrange(opaId,"PA"),"^",17)=$p(preSedationAssStr,$c(3),4)      //术前饮食服药情况(无字段存储)
	s $p(^DHCANOPArrange(opaId,"PA"),"^",18)=$p(preSedationAssStr,$c(3),5)      //禁饮时间(无字段存储)
	s $p(^DHCANOPArrange(opaId,"PA"),"^",19)=$p(preSedationAssStr,$c(3),6)      //疼痛评分(无字段存储)
	s $p(^DHCANOPArrange(opaId,"PA"),"^",20)=$p(preSedationAssStr,$c(3),7)      //部位(无字段存储)
	s $p(^DHCANOPArrange(opaId,"PA"),"^",21)=$p(preSedationAssStr,$c(3),8)      //性质(无字段存储)
	s $p(^DHCANOPArrange(opaId,"PA"),"^",22)=$p(preSedationAssStr,$c(3),9)      //意识水平(无字段存储)
	s $p(^DHCANOPArrange(opaId,"PA"),"^",23)=$p(preSedationAssStr,$c(3),10)      //气道评估(无字段存储)	
	s $p(^DHCANOPArrange(opaId,"PA"),"^",104)=$p(preSedationAssStr,$c(3),11)    //特殊检查报告
	s $p(^DHCANOPArrange(opaId,"PA"),"^",91)=$p(preSedationAssStr,$c(3),12)     //术中特殊困难和防治措施
	s $p(^DHCANOPArrange(opaId,"PA"),"^",24)=$p(preSedationAssStr,$c(3),13)      //术后去向(无字段存储)
	s $p(^DHCANOPArrange(opaId,"PA"),"^",25)=$p(preSedationAssStr,$c(3),14)      //用药前评估医生(无字段存储)
	q "0"
}

ClassMethod UpdateInOutInfo(opaId, inOutInfo) As %String
{
	s inOutCount=$l(inOutInfo,$c(3))
	f i=1:1:inOutCount  d
	.s singleInOutInfo=$p(inOutInfo,$c(3),i)
	.s inOutCode=$p(singleInOutInfo,"#",1)
	.q:(inOutCode="")
	.s inOutDesc=$p(singleInOutInfo,"#",2)
	.s inOutValue=$p(singleInOutInfo,"#",3)
	.s inOutType=$p(singleInOutInfo,"#",4)
	.s ^DHCANOPArrange(opaId,"InOut",i)=inOutCode_"^"_inOutDesc_"^"_inOutValue_"^"_inOutType
	
	q "0"
}

ClassMethod UpdateOperationAssitant(opaId, anaopId, node, ctcpIdStr, delimStr, opaOpDocNote)
{
	s EpisodeID=$p(anaopId,"||",1)
	s anaSub=$p(anaopId,"||",2)
	s anaopSub=$p(anaopId,"||",3)
	k ^TMPCCQ(EpisodeID,"ANA",anaSub,"OP",anaopSub,node)
	s ^TMPCCQ(EpisodeID,"ANA",anaSub,"OP",anaopSub,node)=anaopId_"^"_node_"^"_ctcpIdStr_"^"_opaOpDocNote
	q:anaopSub="" 0
	q:delimStr="" 0
	k ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub, node)
	s count=0
	f i=1:1:$l(ctcpIdStr,delimStr) d
		.s ctcpId=$p(ctcpIdStr,delimStr,i)
		.q:ctcpId=""
		.s count=count+1
		.s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,node,count),"^",1)=ctcpId
	s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,node,0)=count
	q 0
}

/// OR_Anaest_Operation
/// d ##class(web.DHCANOPData).UpdateANAOPInfo(146,"310"_$c(3)_"1368|206"_$c(3)_"16460|10543"_$c(3)_"16460"_$c(3)_"2"_$c(3)_$c(3)_"2"_$c(3)_$c(3)_$c(3)_"发热"_$c(3,3,3)_"扁桃体病损切除术+脑室－小脑延髓池分流术[Torkildsen手术](123)"_$c(3)_"发热"_$c(3),"")
/// d ##class(web.DHCANOPData).UpdateANAOPInfo(146,"310"_$c(3)_"1368|206","")
ClassMethod UpdateANAOPInfo(opaId, anopInfo, userId = "") As %String
{
	s ^TMPCCQ(opaId,"ANAOP",+$h,$p($h,",",2))=anopInfo
	//_surgId_$c(3)_operId_$c(3)_preMrcidId_$c(3)_postMrcidId_$c(3)_opposId_$c(3)_assIdStr_$c(3)_anAssIdStr_c(3)_opscnIdStr_$c(3)_cirnIdStr
	q:opaId="" "anaop^-1"
	s EpisodeID=$p(^DHCANOPArrange(opaId),"^",1)
	s anaId=$p(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$p(anaId,"||",2)
	s opaOpDocNote=$p(^DHCANOPArrange(opaId),"^",42)
	
	s anaopSub=0,opStr=""
	//从手术及手术备注存储 YuanLin 20170831
	s operNum=$l($p(anopInfo,$c(3),2),"|")
	//f k=2:1:operNum d //从第二条手术开始
	.//s operId=$p($p(anopInfo,$c(3),2),"|",k)
	.//s operDesc=$p($p(anopInfo,$c(3),13),"+",k)
	.//s operNote=$p(operDesc,"(",2)
	.//s operNote=$tr(operNote,")","")
	.//s opStr=opStr_operId_"|"_""_"|"_operNote_"|"_""_"|"_"^"    //手术级别和切口拼空,不规范,暂时处理 YuanLin 20170831
	.//s ret=##class(web.UDHCANOPArrange).insertchlop("","",anaId,opStr,"ward")  //不能直接用手术申请时插入手术的方法，删除了原来的手术就把原来的拟施手术也删除了 yq 20190102
	//修改实施手术名称,从第二条开始 yq 20190102
	s anachlSub=1,k=2
	
	f  s anachlSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anachlSub)) q:(anachlSub="")&&(k>operNum)  d
	.s operId=$p($p(anopInfo,$c(3),2),"|",k)
	.i anachlSub'="" d
	..s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anachlSub),"^",6)=operId
	.e  d
	..k PLIST
	..s PLIST(0)=anaId
	..s PLIST(9)=operId
	..&sql(INSERT INTO sqluser.OR_Anaest_Operation Values :PLIST())
	..i SQLCODE'=0 s retStr="插入数据失败!Code="_SQLCODE q
	.s k=k+1
	
	f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
	.s anaopId=anaId_"||"_anaopSub
	.q:'##class(User.ORAnaestOperation).%ExistsId(anaopId)
	.s obj=##class(User.ORAnaestOperation).%OpenId(anaopId)
	.i anaopSub=1 d
	..s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)=$p($p(anopInfo,$c(3),2),"|",anaopSub)  ;ANAOP_Type_DR     ；手术名称  
	..s operDesc=$p($p(anopInfo,$c(3),13),"+",1)  //主手术描述+(手术备注)  YuanLin 20170831
	..s operNote=$p(operDesc,"(",2)
	..s operNote=$tr(operNote,")","")
	..s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",1)=operNote
	.q:anaopSub>1
	.s anaopId=EpisodeID_"||"_anaSub_"||"_anaopSub
	.s operDocInfo=$p(anopInfo,$c(3),1)
	.i (+operDocInfo>0)  d
	..s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",8)=operDocInfo   ;ANAOP_Surgeon_DR  ；手术医师
	..s ^TMPCCQ(opaId,"ANAOP","OperDocId",+$h,$p($h,",",2))=operDocInfo
	.e  d
	..i (operDocInfo'="") s extendId=..SaveSurgeonDescription(opaId,operDocInfo,userId)
	
	.s preMrcidId=$p(anopInfo,$c(3),3)
	.s preMrcidDesc=$p(anopInfo,$c(3),14)
	.i preMrcidId'="" d
	..s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",4)=preMrcidId   ;术前诊断
	..s ^OR(EpisodeID,"ANA",anaSub,"TXT",2)=preMrcidDesc
	.s postMrcidId=$p(anopInfo,$c(3),4)
	.s postMrcidDesc=$p(anopInfo,$c(3),10)
	.i postMrcidId'="" d
	..s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",5)=postMrcidId   ;ANAOP_PostDiag_DR 术后诊断
	..s ^OR(EpisodeID,"ANA",anaSub,"TXT",3)=postMrcidDesc
	.e  d
	..s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",5)=""
	..s ^OR(EpisodeID,"ANA",anaSub,"TXT",3)=postMrcidDesc
	
	.s opposSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"POS",0)) 
	.i opposSub'="" d
	..s $p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"POS",opposSub),"^")=$p(anopInfo,$c(3),5)
	.e  d
	..s opposSub=1
	..s $p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"POS",opposSub),"^")=$p(anopInfo,$c(3),5)
	..s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"POS",0)=opposSub
	.s assIdStr=$p(anopInfo,$c(3),6)
	.;s opaOpDocNote=$tr(assIdStr,",","|")
	.;s opaOpDocNote="||"_opaOpDocNote
	.;s retStr=##class(web.DHCANOPCom).UpdateOperationCtcp(anaopId,"ASS",assIdStr,",",opaOpDocNote)
	.s retStr=..UpdateOperationAssitant(opaId,anaopId,"ASS",assIdStr,",",opaOpDocNote)
	.s anAssCpcpIdStr=""
	.i $p(anopInfo,$c(3),7)'="" s anAssCpcpIdStr=$p(anopInfo,$c(3),7)
	.s retStr=##class(web.DHCANOPCom).UpdateOperationCtcp(anaopId,"ANASS",anAssCpcpIdStr,",")
	.s opscnIdStr=$p(anopInfo,$c(3),8)
	.s retStr=##class(web.DHCANOPCom).UpdateOperationCtcp(anaopId,"SCN",opscnIdStr,",")
	.s cirnIdStr=$p(anopInfo,$c(3),9)
	.s retStr=##class(web.DHCANOPCom).UpdateOperationCtcp(anaopId,"CIRN",cirnIdStr,",")
	
	s retStr=##class(web.DHCANOPCom).AdjustPlanOperation("",anaId)  //主手术和从手术名称更新完之后再更新拟施手术 yq 20190104
	q:retStr'=0 "更新拟施手术名称失败！"

	Q retStr
}

/// DHC_AN_AnaestItem
ClassMethod UpdateAnaestItem(opaId, aniInfo) As %String
{
	s aniId="",findANIId=""
	f  s aniId=$o(^DHCANOPArrange(opaId,"ANI",aniId)) q:((aniId="")!(findANIId'=""))  d
	.i aniId'="0" s findANIId=opaId_"||"_aniId
	.s $P(^DHCANOPArrange(opaId,"ANI",aniId),"^",101)=$p(aniInfo,$c(3),1)
	;s anaestItem=""
	;i findANIId=""  s anaestItem=##class(User.DHCANAnaestItem).%New(opaId)
	;e  s anaestItem=##class(User.DHCANAnaestItem).%OpenId(findANIId)
	;s anaestItem.ANIParref=##class(User.DHCANOPArrange).%OpenId(opaId) 
	;s anaestItem.ANITheatreTransferTo=$p(aniInfo,$c(3),1)
	;d anaestItem.%Save()
	q "0"
}

/// OR_Anaesthesia
ClassMethod UpdateAnaInfo(opaId, anaInfo) As %String
{
	q:opaId="" "opaId^-1"
	s anaId=$p(^DHCANOPArrange(opaId),"^",2)
	q:anaId="" "ana^-1"
	q:'##class(User.ORAnaesthesia).%ExistsId(anaId) "ana^-2"		
	s anaSub=$p(anaId,"||",2)
	s EpisodeID=+anaId
	s $P(^OR(EpisodeID,"ANA",anaSub),"^",5)=$P(anaInfo,$C(3),1)		//麻醉方法Dr
	s $P(^OR(EpisodeID,"ANA",anaSub),"^",6)=$P(anaInfo,$C(3),2)		//麻醉主治Dr	
	s $P(^OR(EpisodeID,"ANA",anaSub),"^",7)=$P(anaInfo,$C(3),3)		//麻醉指导Dr	
	s $P(^OR(EpisodeID,"ANA",anaSub),"^",8)=$P(anaInfo,$C(3),4)		//麻醉护士Dr
	s $P(^OR(EpisodeID,"ANA",anaSub),"^",9)=$P(anaInfo,$C(3),5)		//PACU麻醉护士Dr
	s $P(^OR(EpisodeID,"ANA",anaSub),"^",26)=$P(anaInfo,$C(3),6)	//ASA分级Dr
	
	//保存气管导管信息
	
	s anamethodIdStr=$P(anaInfo,$C(3),1)
	s anamethodCount=$l(anamethodIdStr,"|")
	f n=1:1:anamethodCount d
	.s anamethodId=$p(anamethodIdStr,"|",n)
	.q:anamethodId=""
	.k ^OR(EpisodeID,"ANA",anaSub,"MethodInfo",anamethodId)
	
	s methodInfoStr=$P(anaInfo,$C(3),7)
	s methodInfoCount=$l(methodInfoStr,$c(1))
	f i=1:1:methodInfoCount  d
	.s singleMethodInfo=$p(methodInfoStr,$c(1),i)
	.s methodInfoCode=$p(singleMethodInfo,":",1)
	.s methodInfoDesc=$p(singleMethodInfo,":",2)
	.s methodInfoValue=$p(singleMethodInfo,":",3)
	.s methodId=$p(singleMethodInfo,":",4)
	.q:(methodId="")
	.;s ^OR(EpisodeID,"ANA",anaSub,"MethodInfo",methodId,methodInfoCode)=methodInfoDesc_"^"_methodInfoValue
	.s ^OR(EpisodeID,"ANA",anaSub,"MethodInfo",methodId,i,methodInfoCode)=methodInfoDesc_"^"_methodInfoValue
	
	s planAnmetId=##class(web.DHCANOPCom).ConvertToAnMethodId($P(anaInfo,$C(3),8),"+")
	i planAnmetId'="" s $p(^DHCANOPArrange(opaId,"PA"),"^",89)=planAnmetId

	
	
	q "0"
}

/// dhc_an_oparrange
ClassMethod UpdateOpArrInfo(opaId, operInfo) As %String
{
	//operInfo=手术间Dr_$C(3)_台次
	q:opaId="" "oper^-1"
	q:'##class(User.DHCANOPArrange).%ExistsId(opaId) "oper^-2"
	s ^TMPCCQ(opaId,"OPArrangeInfo")=operInfo
	s retStr="0"
	//s obj=##class(User.DHCANOPArrange).%OpenId(opaId)
	//s obj.OPAOpRoomDr=$P(operInfo,$C(3),1)			//手术间Dr
	//s obj.OPASeq=$P(operInfo,$C(3),2)				//台次
	//s obj.OPAStartDate=$P(operInfo,$C(3),3)			//开始日期
	//s obj.OPAEndDate=$P(operInfo,$C(3),4)			//结束日期
	//s obj.OPAStartTime=$P(operInfo,$C(3),5)			//开始时间
	//s obj.OPAEndTime=$P(operInfo,$C(3),6)			//结束时间
	//s obj.OPAPatStatus=$P(operInfo,$C(3),7)			//病人状态
	//s obj.OPAArrangeUserDr=$P(operInfo,$C(3),8)		//排班用户Dr
	//s obj.OPAArrangeDate=$P(operInfo,$C(3),9)   	//排班日期
	//s obj.OPAArrangeTime=$P(operInfo,$C(3),10)    	//排班时间
	//s obj.OPAStatus=$P(operInfo,$C(3),11)			//病人状态
	//s obj.OPAOpLevelDr=$P(operInfo,$C(3),12)    	//手术级别Dr
	//s obj.OPACollectedStatus=$P(operInfo,$C(3),13)  //采集状态
	
	s $p(^DHCANOPArrange(opaId),"^",12)=$P(operInfo,$C(3),14)	//麻醉效果
	s $p(^DHCANOPArrange(opaId),"^",22)=$P(operInfo,$C(3),15)	//身高
	s $p(^DHCANOPArrange(opaId),"^",24)=$P(operInfo,$C(3),16)	//体重
	s $p(^DHCANOPArrange(opaId),"^",11)=$P(operInfo,$C(3),17)	//血型Dr
	s $p(^DHCANOPArrange(opaId),"^",25)=$P(operInfo,$C(3),18)	//RH血型
	//s $p(^DHCANOPArrange(opaId),"^",10)=$P(operInfo,$C(3),19)   //是否隔离
	//s $p(^DHCANOPArrange(opaId),"^",29)=$P(operInfo,$C(3),20)	//术前用药
	//s $p(^DHCANOPArrange(opaId),"^",30)=$P(operInfo,$C(3),21)   //器械dr
	//s $p(^DHCANOPArrange(opaId),"^",31)=$P(operInfo,$C(3),22)   //是否补充器械
	//s $p(^DHCANOPArrange(opaId),"^",32)=$P(operInfo,$C(3),23)   //OPAWardDr
	//s $p(^DHCANOPArrange(opaId),"^",33)=$P(operInfo,$C(3),24)   //是否备血
	//s $p(^DHCANOPArrange(opaId),"^",34)=$P(operInfo,$C(3),25)   //自体血
	//s $p(^DHCANOPArrange(opaId),"^",35)=$P(operInfo,$C(3),26)   //手术取消原因
	//s $p(^DHCANOPArrange(opaId),"^",38)=$P(operInfo,$C(3),27)   //术前讨论日期
	//s $p(^DHCANOPArrange(opaId),"^",41)=$P(operInfo,$C(3),28)   //医生手术申请序号
	//s $p(^DHCANOPArrange(opaId),"^",42)=$P(operInfo,$C(3),29)	//手术医生备注
	s $p(^DHCANOPArrange(opaId),"^",43)=$P(operInfo,$C(3),30)	//麻醉医生备注
	s $p(^DHCANOPArrange(opaId),"^",70)=$P(operInfo,$C(3),37)	//术前禁食
	s $p(^DHCANOPArrange(opaId),"^",66)=$P(operInfo,$C(3),43)	//PCA
	s $p(^DHCANOPArrange(opaId),"^",68)=$P(operInfo,$C(3),44)	//麻醉效果评分
	s $p(^DHCANOPArrange(opaId),"^",81)=$P(operInfo,$C(3),46)	//麻醉记录单病人基本信息体温
	s $p(^DHCANOPArrange(opaId),"^",84)=$P(operInfo,$C(3),47)	//麻醉记录单病人基本信息脉搏	
	s $p(^DHCANOPArrange(opaId),"^",85)=$P(operInfo,$C(3),48)	//麻醉记录单病人基本信息呼吸
	s $p(^DHCANOPArrange(opaId),"^",82)=$P(operInfo,$C(3),49)	//麻醉记录单病人基本信息收缩压
	s $p(^DHCANOPArrange(opaId),"^",83)=$P(operInfo,$C(3),50)	//麻醉记录单病人基本信息舒张压
	s $p(^DHCANOPArrange(opaId),"^",59)=$P(operInfo,$C(3),51)	//手术延迟原因
	s $p(^DHCANOPArrange(opaId),"^",86)=$P(operInfo,$C(3),52)	//SPO2(无字段存储)
	//s obj.OPAAnaEffect=$P(operInfo,$C(3),14)   		//麻醉效果
	//s obj.OPAPatHeight=$P(operInfo,$C(3),15)		//身高
	//s obj.OPAPatWeight=$P(operInfo,$C(3),16)   		//体重
	//s obj.OPABloodTypeDr=$P(operInfo,$C(3),17)		//血型Dr
	//s obj.OPARHBloodType=$P(operInfo,$C(3),18)		//RH血型
	//s obj.OPAIsolated=$P(operInfo,$C(3),19)			//是否隔离
	//s obj.OPAPreAnDrug=$P(operInfo,$C(3),20)		//术前用药
	//s obj.OPAInstrumentDr=$P(operInfo,$C(3),21)		//器械Dr
	//s obj.OPAAddInstrument=$P(operInfo,$C(3),22)	//增加器械
	//s obj.OPAWardDr=$P(operInfo,$C(3),23)			//病区Dr
	//s obj.OPAPrepareBlood=$P(operInfo,$C(3),24)		//术前备雪
	//s obj.OPAUseSelfBlood=$P(operInfo,$C(3),25)		//自体血
	//s obj.OPAReturnReasonDr=$P(operInfo,$C(3),26)	//回转原因Dr
	//s obj.OPAPreDiscussDate=$P(operInfo,$C(3),27)	//术前讨论日期
	//s obj.OPASeqNote=$P(operInfo,$C(3),28)			//备注
	//s obj.OPAOpDocNote=$P(operInfo,$C(3),29)		//手术医生备注
	//s obj.OPAAnDocNote=$P(operInfo,$C(3),30)		//麻醉医生备注
	//s obj.OPANeedAnaesthetist=$P(operInfo,$C(3),31)	//是否需要麻醉
	//s obj.OPAUnPlanedOperation=$P(operInfo,$C(3),32)	//非计划手术
	//s obj.OPAPacuBedDr=$P(operInfo,$C(3),33)		//PACU床位Dr
	s $p(^DHCANOPArrange(opaId),"^",48)=$P(operInfo,$C(3),34)
	//s obj.OPAAnaDoctorOrdered=$P(operInfo,$C(3),34)	//麻醉医生计费
	//s obj.OPAAnaNurseOrdered=$P(operInfo,$C(3),35)	//麻醉护士计费
	//s obj.OPAOpNurseOrdered=$P(operInfo,$C(3),36)	//手术护士计费
	//s obj.OPAPreOperPatTeaching=$P(operInfo,$C(3),37)	//术前禁食
	//s obj.OPAPAHeartRate=$P(operInfo,$C(3),38)	//术前心率
	//s obj.OPAPABPSystolic=$P(operInfo,$C(3),39)	//术前收缩压
	//s obj.OPAPABPDiastolic=$P(operInfo,$C(3),40)	//术前舒张压
	//s obj.OPAPARespRate=$P(operInfo,$C(3),41)	//术前呼吸
	//s obj.OPAAnalgesia=$P(operInfo,$C(3),43)    //PCA
	//s obj.OPAAnalgesiaEstimate=$P(operInfo,$C(3),44)
	//s obj.OPABloodTypeDr=$P(operInfo,$C(3),45)
	
	//s obj.OPAInAreaTemperature=$P(operInfo,$C(3),46)
	//s obj.OPAInAreaHeartRate=$P(operInfo,$C(3),47)
	//s obj.OPAInAreaRespRate=$P(operInfo,$C(3),48)
	//s obj.OPAInAreaBPSystolic=$P(operInfo,$C(3),49)
	//s obj.OPAInAreaBPDiastolic=$P(operInfo,$C(3),50)
	//s updateStatus=obj.%Save()
	//q:(+updateStatus=0) "数据修改失败!"
	//s retStr=+updateStatus
	//s opaId=obj.%Id()
	//d obj.%Close()

	//s planAnmetId=##class(web.DHCANOPCom).ConvertToAnMethodId($p(operInfo,$c(3),37),"+")
	//i planAnmetId'="" s $p(^DHCANOPArrange(opaId,"PA"),"^",89)=planAnmetId
	
	q retStr
}

ClassMethod UpdatePreAnaVisitInfo(opaId, visitInfo) As %String
{
	s $p(^DHCANOPArrange(opaId,"PA"),"^",106)=$p(visitInfo,$c(3),1)		//主诉
	s $p(^DHCANOPArrange(opaId,"PA"),"^",107)=$p(visitInfo,$c(3),2)		//术前访视其它信息
	
	s $p(^DHCANOPArrange(opaId,"PA"),"^",60)=$p(visitInfo,$c(3),3)		//体温
	s $p(^DHCANOPArrange(opaId,"PA"),"^",59)=$p(visitInfo,$c(3),4)		//脉搏
	s $p(^DHCANOPArrange(opaId,"PA"),"^",63)=$p(visitInfo,$c(3),5)		//呼吸
	s $p(^DHCANOPArrange(opaId,"PA"),"^",61)=$p(visitInfo,$c(3),6)		//收缩压
	s $p(^DHCANOPArrange(opaId,"PA"),"^",62)=$p(visitInfo,$c(3),7)		//舒张压
	
	s $p(^DHCANOPArrange(opaId,"PALab"),"^",5)=$p(visitInfo,$c(3),8)		//HB
	s $p(^DHCANOPArrange(opaId,"PALab"),"^",6)=$p(visitInfo,$c(3),9)		//HCT
	s $p(^DHCANOPArrange(opaId,"PALab"),"^",3)=$p(visitInfo,$c(3),10)		//WBC
	s $p(^DHCANOPArrange(opaId,"PALab"),"^",7)=$p(visitInfo,$c(3),11)		//PLT
	s $p(^DHCANOPArrange(opaId,"PALab"),"^",8)=$p(visitInfo,$c(3),12)		//ALT
	s $p(^DHCANOPArrange(opaId,"PALab"),"^",16)=$p(visitInfo,$c(3),13)		//BUN
	s $p(^DHCANOPArrange(opaId,"PALab"),"^",15)=$p(visitInfo,$c(3),14)		//CR
	s $p(^DHCANOPArrange(opaId,"PALab"),"^",14)=$p(visitInfo,$c(3),15)		//GLU
	s $p(^DHCANOPArrange(opaId,"PALab"),"^",25)=$p(visitInfo,$c(3),16)		//K
	s $p(^DHCANOPArrange(opaId,"PALab"),"^",26)=$p(visitInfo,$c(3),17)		//Na
	s $p(^DHCANOPArrange(opaId,"PALab"),"^",28)=$p(visitInfo,$c(3),18)		//Cl
	s $p(^DHCANOPArrange(opaId,"PALab"),"^",37)=$p(visitInfo,$c(3),19)		//PT
	s $p(^DHCANOPArrange(opaId,"PALab"),"^",41)=$p(visitInfo,$c(3),20)		//APTT
	s $p(^DHCANOPArrange(opaId,"PALab"),"^",52)=$p(visitInfo,$c(3),21)		//PaO2
	
	i ($p(visitInfo,$c(3),22)'="") s $p(^DHCANOPArrange(opaId),"^",11)=$p(visitInfo,$c(3),22)	//血型
	
	s RHBloodType=$p(^DHCANOPArrange(opaId),"^",25)
	i (RHBloodType="") s $p(^DHCANOPArrange(opaId),"^",25)=$p(visitInfo,$c(3),23)	//血型
	
	s patHeight=$p(^DHCANOPArrange(opaId),"^",22)
	i (patHeight="")!(patHeight="0") s $p(^DHCANOPArrange(opaId),"^",22)=$p(visitInfo,$c(3),24)		//身高
	
	q "0"
}

ClassMethod UpdateAnShift(opaId, ansInfo) As %String
{
	
	q 0
		s ansSub=0,quitFlag=0,curAnsSub=""
	f  s ansSub=$o(^DHCANOPArrange(opaId,"Shift",ansSub)) q:(ansSub="")!(quitFlag)  d
		.i $p(^DHCANOPArrange(opaId,"Shift",ansSub),"^",1)="TI" d
			..s quitFlag=1,curAnsSub=ansSub
	i curAnsSub="" d
		.s ^DHCANOPArrange(opaId,"Shift",0)=$g(^DHCANOPArrange(opaId,"Shift",0))+1
		.s curAnsSub=^DHCANOPArrange(opaId,"Shift",0)
		.s ^DHCANOPArrange(opaId,"Shift",curAnsSub)="TI"
		
		s setValList="5^6^8^9^11"
	f i=1:1:$l(setValList,"^") d
		.s itemPos=$p(setValList,"^",i)
		.s $p(^DHCANOPArrange(opaId,"Shift",curAnsSub),"^",itemPos)=$p(ansStr,$c(3),itemPos)
}

/// 获取实施手术
ClassMethod GetExecOperation(EpisodeID As %String, anaSubId As %String, OPSubId As %String) As %String
{
	
	s operationId=$p(^OR(EpisodeID,"ANA",anaSubId,"OP",OPSubId),"^",6)
	s operationCount=$l(operationId,"|")
	s operation=""
	f operIdItem=1:1:operationCount  d
	.s singleOperId=$p(operationId,"|",operIdItem)
	.s singleOperation=$p($g(^ORC("OPER",+singleOperId)),"^",2)
	.i (singleOperation'="")&(operation'="") s operation=operation_";"
	.i (singleOperation'="") s operation=operation_singleOperation
	i (operation="") s operation=^OR(EpisodeID,"ANA",anaSubId,"OP",OPSubId,"REM",2)
	
	q operation
}

/// 获取麻醉助手
ClassMethod GetAnaAssistant(EpisodeID As %String, anaSubId As %String, OPSubId As %String) As %String
{
	s anaAssistant="",assistantId="",assistantSubId=0
	f  s assistantSubId=$o(^OR(EpisodeID,"ANA",anaSubId,"OP",OPSubId,"ANASS",assistantSubId)) q:assistantSubId=""  d
	.s assistantId=$p(^OR(EpisodeID,"ANA",anaSubId,"OP",OPSubId,"ANASS",assistantSubId),"^")
	.q:(assistantId="")
	.s singleAssistant=##class(web.DHCANOPCom).GetNameById(assistantId)
	.i (singleAssistant'="")&(anaAssistant'="") s anaAssistant=anaAssistant_","
	.s anaAssistant=anaAssistant_singleAssistant
			
	q anaAssistant
}

/// 获取手术助手
ClassMethod GetOperAssistant(EpisodeID As %String, anaSubId As %String, OPSubId As %String) As %String
{
	s assistantSubId=0,assistantId="",assistant=""
	f  s assistantSubId=$o(^OR(EpisodeID,"ANA",anaSubId,"OP",OPSubId,"ASS",assistantSubId)) q:(assistantSubId="")  d
	.s assistantId=$p(^OR(EpisodeID,"ANA",anaSubId,"OP",OPSubId,"ASS",assistantSubId),"^")
	.s singleAssistant=##class(web.DHCANOPCom).GetNameById(assistantId)
	.i (singleAssistant'="")&(assistant'="") s assistant=assistant_","
	.s assistant=assistant_singleAssistant
	
	q assistant
}

/// 获取巡回或器械护士
ClassMethod GetANOPNurse(EpisodeID As %String, anaSubId As %String, OPSubId As %String, node As %String) As %String
{
	s nurseId="",nurse=""
	s nurseSubId=0
	f  s nurseSubId=$o(^OR(EpisodeID,"ANA",anaSubId,"OP",OPSubId,node,nurseSubId)) q:nurseSubId=""  d
	.s singleNurseId=$p(^OR(EpisodeID,"ANA",anaSubId,"OP",OPSubId,node,nurseSubId),"^")
	.q:singleNurseId=""
	.i (nurseId'="") s nurseId=nurseId_","
	.s nurseId=nurseId_singleNurseId
	.s singleNurse=##class(web.DHCANOPCom).GetNameById(singleNurseId)
	.i (nurse'="") s nurse=nurse_","
	.s nurse=nurse_singleNurse
	
	q nurse_"^"_nurseId
}

/// 获取术后诊断
ClassMethod GetPostOPDiagnosis(EpisodeID As %String, anaSubId As %String, OPSubId As %String) As %String
{
	s postOPDiagnosisId="",postOPDiagnosis=""
	
	s postOPDiagnosisId=$P(^OR(EpisodeID,"ANA",anaSubId,"OP",OPSubId),"^",5)
	i (postOPDiagnosisId'="")  d
	.s postOPDiagCount=$l(postOPDiagnosisId,"|")
	.f i=1:1:postOPDiagCount  d
	..s singlePostOPDiagId=$p(postOPDiagnosisId,"|",i)
	..s singlePostOPDiag=""
	..i (singlePostOPDiagId=+singlePostOPDiagId) s singlePostOPDiag=$P($g(^MRC("ID",singlePostOPDiagId)),"^",2)
	..e  s singlePostOPDiag=$p($g(^OR(EpisodeID,"ANA",anaSubId,"TXT",3)),";",i)
	..i (singlePostOPDiag'="")&(postOPDiagnosis'="") s postOPDiagnosis=postOPDiagnosis_";"
	..s postOPDiagnosis=postOPDiagnosis_singlePostOPDiag
	e  s postOPDiagnosis=$g(^OR(EpisodeID,"ANA",anaSubId,"TXT",3))
	
	q postOPDiagnosis_"^"_postOPDiagnosisId
}

ClassMethod GetInOutItemValue(opaId As %String, inOutItemCode As %String) As %String
{
	s inOutValue="",inOutId=""
 	f  s inOutId=$o(^DHCANOPArrange(opaId,"InOut",inOutId)) q:(inOutId="")!(inOutValue'="")  d
 	.s inOutCode=$p(^DHCANOPArrange(opaId,"InOut",inOutId),"^",1)
 	.q:(inOutCode'=inOutItemCode)
 	.s inOutValue=$p(^DHCANOPArrange(opaId,"InOut",inOutId),"^",3)
 	
 	q inOutValue
}

ClassMethod GetEventInfo(opaId As %String, eventCode As %String, ifSingle As %String = "Y") As %String
{
	q:(opaId="")!(eventCode="") ""
	s retStr=""
	s ancoId=$o(^DHCANC("ComOrd",0,"TypeCode","E",eventCode,""))
	q:ancoId="" ""
	s anoId="",ifFind=0
	f  s anoId=$o(^DHCANOrder(0,"CommOrd",ancoId,opaId,anoId)) q:(anoId="")!(ifFind)  d
		.q:"CD"[$p($g(^DHCANOrder(anoId)),"^",25)
		.s eventNote=$p($g(^DHCANOrder(anoId)),"^",10)
		.s eventAbbreviate=$p($g(^DHCANOrder(anoId)),"^",35)
		.s userId=$p($g(^DHCANOrder(anoId)),"^",4)
		.s userDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
		.s startDate=$p($g(^DHCANOrder(anoId)),"^",5)
		.s startTime=$p($g(^DHCANOrder(anoId)),"^",6)
		.s startDate=##class(web.DHCANOPCom).ConvertToDate(startDate)
		.s startTime=##class(web.DHCANOPCom).ConvertToTime(startTime)
		.s startDT=startDate_" "_startTime
		.s retStr=eventNote_"^"_eventAbbreviate_"^"_userDesc_"^"_startDT_"^"_anoId
		.i ifSingle="Y" s ifFind=1
	q retStr
}

/// 判断手术是否是第一台手术（不按台次判断）
ClassMethod IsRoomFirstOperation(currentOpaId As %String) As %String
{
	q:(currentOpaId="") "手术申请排班ID不能为空"
	
	s result="0",ifFind="N"
	
	s operDate=$p(^DHCANOPArrange(currentOpaId),"^",14)
	s operRoomId=$p(^DHCANOPArrange(currentOpaId),"^",20)
	
	s opaId=""
	f  s opaId=$o(^DHCANOPArrange(0,"SDate",operDate,opaId)) q:(opaId="")!(ifFind="Y")  d
	.q:(currentOpaId=opaId)
	.s roomId=$p(^DHCANOPArrange(opaId),"^",20)
	.q:(operRoomId'=roomId)
	.s anaId=$p(^DHCANOPArrange(opaId),"^",2)
	.s EpisodeID=+anaId
	.s anaSubId=$p(anaId,"||",2)
	.s sourceType=$p(^OR(EpisodeID,"ANA",anaSubId),"^",32)
	.q:(sourceType="E")	//不涉及急诊手术
	.s opaStatus=$p(^DHCANOPArrange(opaId),"^",27)
	.i "ILFP"[opaStatus s ifFind="Y"
	
	i (ifFind="Y") s result="1"
	
	q result
}

ClassMethod UpdateAnaestItemData(opaId, ANIData) As %String
{
	s ^tempck("ANIData",opaId)=ANIData
	q:(+opaId=0) "手术申请号不能为空!"
	q:$d(^DHCANOPArrange(opaId))<1 "申请号有误!"
	s chl=$o(^DHCANOPArrange(opaId,"ANI",""),-1)
	//s $p(^DHCANOPArrange(opaId,"ANI",chl),"^",1)=$p(ANIData,"^",1)
	f i=2:1:$l(ANIData,"^") d
	.;i $p(ANIData,"^",i)'="" s $p(^DHCANOPArrange(opaId,"ANI",chl),"^",i)=$p(ANIData,"^",i)
	.s $p(^DHCANOPArrange(opaId,"ANI",chl),"^",i)=$p(ANIData,"^",i)
	q 0
}

// w ##class(web.DHCANOPData).UpdateSedationInfo(43,"55"_$c(3)_"已禁"_$c(3)_"Ⅲ"_$c(3)_"111"_$c(3)_"99"_$c(3)_"99"_$c(3)_"88"_$c(3)_"22"_$c(3,3,3,3)_"1"_$c(3,3)_"无"_$c(3)_"无"_$c(3)_"无"_$c(3,3,3,3)_"平稳"_$c(3,3,3,3,3,3,3,3)_"ADSFDS"_$c(3))

ClassMethod UpdateSedationInfo(opaId, SedationData) As %String
{
	s ^tempck("SedationData",opaId)=SedationData
	q:(+opaId=0) "手术申请号不能为空!"
	q:$d(^DHCANOPArrange(opaId))<1 "申请号有误!"
	s EpisodeID=$p(^DHCANOPArrange(opaId),"^",1)
	s anaSub=$p($p(^DHCANOPArrange(opaId),"^",2),"||",2)
	s chl=$o(^DHCANOPArrange(opaId,"ANI",""),-1)
	
	//s $p(^DHCANOPArrange(opaId),"^",24)=$P(SedationData,$C(3),1)	//体重
	//s $p(^DHCANOPArrange(opaId),"^",70)=$P(SedationData,$C(3),2)	//术前禁食
	//s $P(^OR(EpisodeID,"ANA",anaSub),"^",26)=$P(SedationData,$C(3),3)	//ASA分级Dr
	b //1
	s $p(^DHCANOPArrange(opaId,"ANI",chl),"^",7)=$P(SedationData,$C(3),11)  //常规监测
	s $p(^DHCANOPArrange(opaId),"^",12)=$P(SedationData,$C(3),12)  //麻醉效果
	s $p(^DHCANOPArrange(opaId,"ANI",chl),"^",112)=$P(SedationData,$C(3),13)  //生命体征
	s $p(^DHCANOPArrange(opaId,"PACU"),"^",20)=$P(SedationData,$C(3),14)  //呕吐
	s $p(^DHCANOPArrange(opaId,"ANI",chl),"^",111)=$P(SedationData,$C(3),15)  //呼吸停顿
	s $p(^DHCANOPArrange(opaId,"ANI",chl),"^",113)=$P(SedationData,$C(3),16)  //心律失常
	s $p(^DHCANOPArrange(opaId,"ANI",chl),"^",109)=$P(SedationData,$C(3),17)  //其他
	b  //2
	s retStr=..UpdateInOutInfo(opaId,$P(SedationData,$C(3),18))  //出入量
	w !,retStr
	b  //3
	s $p(^DHCANOPArrange(opaId,"PACU"),"^",6)=$P(SedationData,$C(3),19)  //入PACU日期
	//s $p(^DHCANOPArrange(opaId,"PACU"),"^",7)=$P(SedationData,$C(3),19)  //入PACU时间
	s $p(^DHCANOPArrange(opaId,"ANI",chl),"^",114)=$P(SedationData,$C(3),20)  //生命体征
	
	s $P(^OR(EpisodeID,"ANA",anaSub),"^",41)=$P(SedationData,$C(3),21)   //离室日期
	//s $P(^OR(EpisodeID,"ANA",anaSub),"^",42)=$P(SedationData,$C(3),21)   //离室时间
	s $p(^DHCANOPArrange(opaId),"^",68)=$P(SedationData,$C(3),22)   //麻醉效果评分	
	
	s $p(^DHCANOPArrange(opaId,"ANI",chl),"^",119)=$P(SedationData,$C(3),23)    //ANIBPDiastolic
	s $p(^DHCANOPArrange(opaId,"ANI",chl),"^",118)=$P(SedationData,$C(3),24)    //ANIBPSystolic
	s $p(^DHCANOPArrange(opaId,"ANI",chl),"^",122)=$P(SedationData,$C(3),25)    //ANIOxygenSaturation
	s $p(^DHCANOPArrange(opaId,"ANI",chl),"^",120)=$P(SedationData,$C(3),26)    //ANIHeartRate
	s $p(^DHCANOPArrange(opaId,"ANI",chl),"^",121)=$P(SedationData,$C(3),27)    //ANIRespRate

	
	q 0
}

ClassMethod UpdatePacuInfo(opaId, PacuData) As %String
{
	s ^tempck("PacuData",opaId)=PacuData
	q:(+opaId=0) "手术申请号不能为空!"
	q:$d(^DHCANOPArrange(opaId))<1 "申请号有误!"
	s para=""
	f i=1:1:$l(PacuData,"^")
	{
		s pacuStr=$p(PacuData,"^",i)
		q:pacuStr=""
		s ancoCode=$p(pacuStr,$c(3),3)
		s ancoId="",ancoType="",ancoViewCat=""
		s ancoType="" f  s ancoType=$o(^DHCANC("ComOrd",0,"TypeCode",ancoType)) q:ancoType=""  d
		.s ancoId=$o(^DHCANC("ComOrd",0,"TypeCode",ancoType,ancoCode,""))
		.q:ancoId=""
		.s ancoDesc=$p(^DHCANC("ComOrd",ancoId),"^",2)
		.s ancoType=$p(^DHCANC("ComOrd",ancoId),"^",3)
		.s ancoViewCat=$p(^DHCANC("ComOrd",ancoId),"^",5)
		
		.s para=para_$p(pacuStr,$c(3),1)_$c(3)
		.s para=para_$p(pacuStr,$c(3),2)_$c(3)
		.s para=para_ancoId_$c(3)
		.s para=para_$p(pacuStr,$c(3),4)_$c(3)
		.s para=para_+$h_$c(3)
		.s para=para_$p(pacuStr,$c(3),6)_$c(3)
		.s para=para_+$h_$c(3)
		.s para=para_$p(pacuStr,$c(3),8)_$c(3)
		.s para=para_$p(pacuStr,$c(3),9)_$c(3)
		.s para=para_$p(pacuStr,$c(3),10)_$c(3)
		
		.s para=para_$p(pacuStr,$c(3),11)_$c(3)
		.s para=para_$p(pacuStr,$c(3),12)_$c(3)
		.s para=para_$p(pacuStr,$c(3),13)_$c(3)
		.s para=para_$p(pacuStr,$c(3),14)_$c(3)
		.s para=para_$p(pacuStr,$c(3),15)_$c(3)
		.s para=para_ancoViewCat_$c(3)
		.s para=para_$p(pacuStr,$c(3),17)_$c(3)
		.s para=para_$p(pacuStr,$c(3),18)_$c(3)
		.s para=para_$p(pacuStr,$c(3),19)_$c(3)
		.s para=para_$p(pacuStr,$c(3),20)_$c(3)
		
		.s para=para_+$h_$c(3)
		.s para=para_$p($h,",",2)_$c(3)
		.s para=para_$p(pacuStr,$c(3),23)_$c(3)
		.s para=para_$p(pacuStr,$c(3),24)_$c(3)
		.s para=para_$p(pacuStr,$c(3),25)_$c(3)
		.s para=para_$p(pacuStr,$c(3),26)_$c(3)
		.s para=para_$p(pacuStr,$c(3),27)_$c(3)
		.s para=para_$p(pacuStr,$c(3),28)_$c(3)
		.s para=para_$p(pacuStr,$c(3),29)_$c(3)
		.s para=para_$p(pacuStr,$c(3),30)_$c(3)
		
		.s para=para_ancoType_$c(3)
		.s para=para_$p(pacuStr,$c(3),32)_$c(3)
		.s para=para_$p(pacuStr,$c(3),33)_$c(3)
		.s para=para_$p(pacuStr,$c(3),34)_$c(3)
		.s para=para_$p(pacuStr,$c(3),35)_$c(3)
		.s para=para_ancoCode_$c(3)
		.s para=para_$p(pacuStr,$c(3),37)_"^"	
	}
	s retStr=##class(web.DHCANOrder).SaveANOrders(para)
	s ^tempck("sdf")=retStr
	q 0
}

/// Creator：      	陈长青
/// CreatDate：    	2014-11-06
/// Description： 	获取病人的麻醉信息
/// Table：        	OR_Anaesthesia
/// Input：        	opaId：手术申请排班ID
/// Return：       	
/// w ##Class(web.DHCClinicCom).GetAnaestInfo("186500")
ClassMethod GetAnaestInfo(opaId As %String) As %String
{
	quit:(+opaId=0) ""  ;不存在手术申请排班记录
	
	set anaestId=$piece(^DHCANOPArrange(opaId),"^",2)
	set EpisodeID=+anaestId
	set anaestSubId=$piece(anaestId,"||",2)
	set operSubId=""
	set assistantSubId=""
	
	set anaDoctorId=$piece(^OR(EpisodeID,"ANA",anaestSubId),"^",6)  ;麻醉医生Id
	set anaSuperDoctorId=$piece(^OR(EpisodeID,"ANA",anaestSubId),"^",7)  ;麻醉指导Id
	set anaAssistantId="",anaAssistant=""  ;麻醉助手Id，麻醉助手姓名 多个助手用逗号连接
	for
	{
		set operSubId=$order(^OR(EpisodeID,"ANA",anaestSubId,"OP",operSubId))
		quit:(operSubId="")
		for
		{
			set assistantSubId=$order(^OR(EpisodeID,"ANA",anaestSubId,"OP",operSubId,"ANASS",assistantSubId))
			quit:(assistantSubId="")
			set singleAssistantId=$piece(^OR(EpisodeID,"ANA",anaestSubId,"OP",operSubId,"ANASS",assistantSubId),"^")	
			set anaAssistantId=anaAssistantId_singleAssSubId_","
			set singleAssistant=##class(web.DHCANOPCom).GetNameById(singleAssistantId)
			set anaAssistant=anaAssistant_singleAssistant_","
		}	
	}
	
	;set anaest
}

/// Creator：      	陈长青
/// CreatDate：    	2014-11-06
/// Description： 	获取病人的主刀医生姓名描述
/// Table：        	DHC_AN_OPArrangeExtend
/// Input：        	opaId：手术申请排班ID,extendCode：手术申请排班扩展字段代码
/// Return：       	主刀医生姓名描述字符串
/// w ##Class(web.DHCANOPData)GetSurgeonDescription("186500")
ClassMethod GetSurgeonDescription(opaId As %String, extendCode As %String = "SurgeonDesc") As %String
{
	set extendValueStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,extendCode)
	set surgeonDesc=$piece(extendValueStr,$char(3),1)
	
	quit surgeonDesc
}

/// Creator：      	陈长青
/// CreatDate：    	2014-11-06
/// Description： 	保存病人的主刀医生姓名描述
/// Table：        	DHC_AN_OPArrangeExtend
/// Input：        	opaId：手术申请排班ID,extendValue：主刀医生姓名描述值,
///                 userId:操作用户ID,extendCode：手术申请排班扩展字段代码
/// Return：       	主刀医生姓名描述字符串
/// w ##Class(web.DHCANOPData)GetSurgeonDescription("186500")
ClassMethod SaveSurgeonDescription(opaId As %String, extendValue As %String, userId As %String, extendCode As %String = "SurgeonDesc") As %String
{
	set ^TMPCCQ(opaId,"SurgeonDesc")=opaId_"^"_extendValue_"^"_userId
	set result=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,extendCode,extendValue,"",userId)
	
	quit result
}

ClassMethod JudgeRoomUseStatus(opaId As %String) As %String
{
	set result="0"
	
	quit:(+opaId=0) "参数opaId不能为空"
	
	set roomId=$piece(^DHCANOPArrange(opaId),"^",20)
	quit:(roomId="") "未安排手术间"
	
	if $data(^DHCANOPArrange(0,"RoomStatus",roomId,"I"))>0
	{
		set inRoomOpaId=$order(^DHCANOPArrange(0,"RoomStatus",roomId,"I",""))
		if (inRoomOpaId'=opaId)
		{
			set result=##class(web.DHCANCom).AutoTerminal(inRoomOpaId)	
		}	
	}
	
	quit result
}

}
