Import sqluser

/// creator:    yunhaibao
/// createdate: 2018-05-15
/// description:处方点评抽取
Class web.DHCSTCNTS.Main Extends %RegisteredObject
{

/// descripiton: 处方综合点评抽取-获取处方数
/// 原method:    w ##class(web.DHCSTCNTSMAIN).GetPrescDataNum
/// w ##class(web.DHCSTCNTS.Main).GetPrescDataNum(164287245,"01/01/2017^16/10/2018^^^^^^^^P^^^^^^^0^^^^^","238")
ClassMethod GetPrescDataNum(pid, inputStr, lgLocId)
{
	s $zt="ThrowGetPrescDataNum"
	s extraRet=##class(web.DHCSTCNTS.Extract).ExtraPresc(inputStr, lgLocId)
	// extraRet: 0^cnt^pid
	s ^JOBDHCSTCNTS(pid)=extraRet
	q extraRet
ThrowGetPrescDataNum
	s errCode="-1^"_$tr($ze,"^","")
	s ^JOBDHCSTCNTS(pid)=errCode
	q errCode
}

/// descripiton: 处方综合点评-保存
/// w ##class(web.DHCSTCNTS.Main).SaveCommentData("1/01/2017^20/01/2017^130^^^50^^^^P^^^^^^^0^^^^^","66","6840")
ClassMethod SaveCommentData(inputStr, lgLocId, userId)
{
	s ^TMPDHCSTPARAMS("web.DHCSTCNTS.Main","SaveCommentData")=$lb(inputStr, lgLocId, userId)
	s $zt="ThrowSaveCommentData"
	s extraRet=##class(web.DHCSTCNTS.Extract).ExtraPresc(inputStr, lgLocId,1)
	s extraSucc=$p(extraRet,"^",1)
	s extraCnt=$p(extraRet,"^",2)
	s extraPid=$p(extraRet,"^",3)
	q:extraSucc<0 extraRet
	q:extraCnt=0 "-1^没有符合条件的点评数据"
	s randNum=+$p(inputStr,"^",5)
	s randNum=$p(randNum,".")		// 随机数
	s centNum=+$p(inputStr,"^",6) 	// 抽取比例
	s spaceNum=+$p(inputStr,"^",19) // 间隔数
	s randRet=##class(web.DHCSTCNTS.Extract).GeneRandom(extraPid,extraCnt,randNum,centNum,spaceNum)
	q:$p(randRet,"^",1)<0 randRet
	s notes=..ConditonNotes(inputStr,"P")
    s wayCode=$p(inputStr,"^",10)	// 点评方式代码
    s wayId=$o(^DHCPCWAY(0,"Code",wayCode,""),-1)
    s reSaveFlag=""
    i wayId'="" s reSaveFlag=$p(^DHCPCWAY(wayId),"^",5)	// 重复抽取标记
    s hospId=$p($g(^CTLOC(+lgLocId)),"^",22)
	tstart
	s mainId=##class(web.DHCSTCNTSMAIN).SaveCommentNo(userId,notes,wayCode,hospId,"F")
	i +mainId'>0 d ErrorSaveCommentData
	q:+mainId'>0 -1_"^"_"保存主表失败"
	s itm=..SaveCommentItm(extraPid,mainId,reSaveFlag)
	i +itm<0 d ErrorSaveCommentData
	q:+itm<0 -3_"^"_"保存子表失败"
	tcommit
	k ^TMPDHCSTCNTS("Extract","GeneRandom",extraPid)
	s commentNo=$p(^DHCPHCNTS(mainId),"^",1)
	q 0_"^"_commentNo
ErrorSaveCommentData
	i $d(extraPid)&&(extraPid'="") d
	.k ^TMPDHCSTCNTS("Extract","Common",extraPid)
	.k ^TMPDHCSTCNTS("Extract","GeneRandom",extraPid)
	tro
	q	
ThrowSaveCommentData
	d ErrorSaveCommentData
	q -1_"^"_$tr($ze,"^","")
}

/// description: 保存处方点评子表
ClassMethod SaveCommentItm(pid, mainId, reSaveFlag)
{
	s errCode=""
	s i=""
	f  s i=$o(^TMPDHCSTCNTS("Extract","GeneRandom",pid,i)) q:(i="")||(errCode'="")  d
	.s phcoId=$g(^TMPDHCSTCNTS("Extract","GeneRandom",pid,i))
    .s phcoItm=$o(^DHCPHCNTSORDER(phcoId,"I",""))
    .q:phcoItm=""
    .s oeori=$p(^DHCPHCNTSORDER(phcoId,"I",phcoItm),"^",7)
    .s ordId=+oeori,ordItm=$p(oeori,"||",2)
    .s prescNo=$p(^OEORD(ordId,"I",ordItm,1),"^",14)
    .s admId=$p(^OEORD(ordId),"^",1)
	.s docLocId=$p($g(^OEORD(ordId,"I",ordItm,1)),"^",3)
	.s doctorId=$p($g(^OEORD(ordId,"I",ordItm,7)),"^",1)
	.s passVal="" //$g(^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","PassData",pid,prescno))
	.s itmRet=##class(web.DHCSTCNTSMAIN).SaveItm(mainId,prescNo,oeori,admId,docLocId,doctorId,passVal,reSaveFlag)
	.i $p(itmRet,"^",1)=-1 s errCode="-1^插入子表失败"
	q:errCode'="" errCode
	q 0
}

/// descripiton: 住院医嘱点评抽取-获取出院人数
/// 原method:    #class(web.DHCSTCNTSIPDATA).GetLeavePersonNum
/// w ##class(web.DHCSTCNTS.Main).GetLeavePersonNum("2017-01-16^2018-05-16^^^^^^^^^^^^^false^IP","")
ClassMethod GetLeavePersonNum(pid, inputStr, lgLocId = "")
{
	s $zt="ThrowGetLeavePersonNum"
	s extraRet=##class(web.DHCSTCNTS.Extract).ExtraDisch(inputStr, lgLocId)
	// extraRet: 0^cnt^pid
	s ^JOBDHCSTCNTS(pid)=extraRet
	q extraRet
ThrowGetLeavePersonNum
	s errCode="-1^"_$tr($ze,"^","")
	s ^JOBDHCSTCNTS(pid)=errCode
	q errCode
}

/// descripiton: 住院医嘱点评-保存
/// w ##class(web.DHCSTCNTS.Main).SaveIPCommentData("17/10/2016^17/10/2018^1^^^^^^^^^^^^false^IP","306","4638")
ClassMethod SaveIPCommentData(inputStr, lgLocId, userId)
{
	s ^TMPDHCSTPARAMS("web.DHCSTCNTS.Main","SaveIPCommentData")=$lb(inputStr, lgLocId, userId)
	s $zt="ThrowSaveIPCommentData"
	s extraRet=##class(web.DHCSTCNTS.Extract).ExtraDisch(inputStr, lgLocId,1)
	s extraSucc=$p(extraRet,"^",1)
	s extraCnt=$p(extraRet,"^",2)
	s extraPid=$p(extraRet,"^",3)
	q:extraSucc<0 extraRet
	q:extraCnt=0 "-1^没有符合条件的点评数据"
	s randNum=+$p(inputStr,"^",3)
	s randNum=$p(randNum,".")		// 随机数
	s centNum=+$p(inputStr,"^",5) 	// 抽取比例
	s spaceNum=+$p(inputStr,"^",11) // 间隔数
	s randRet=##class(web.DHCSTCNTS.Extract).GeneRandom(extraPid,extraCnt,randNum,centNum,spaceNum)
	q:$p(randRet,"^",1)<0 randRet
	s notes=..ConditonNotes(inputStr,"IP")
    s wayCode=$p(inputStr,"^",16)	// 点评方式代码
    s wayId=$o(^DHCPCWAY(0,"Code",wayCode,""),-1)
    s reSaveFlag=""
    i wayId'="" s reSaveFlag=$p(^DHCPCWAY(wayId),"^",5)	// 重复抽取标记
    s hospId=$p($g(^CTLOC(+lgLocId)),"^",22)
	tstart
	s mainId=##class(web.DHCSTCNTSMAIN).SaveCommentNo(userId,notes,wayCode,hospId,"P")
	i +mainId'>0 d ErrorSaveIPCommentData
	q:+mainId'>0 -1_"^"_"保存主表失败"
	s itm=..SaveIpCommentItm(extraPid,mainId,reSaveFlag)
	i +itm<0 d ErrorSaveIPCommentData
	q:+itm<0 -3_"^"_"保存子表失败"
	tcommit
	s commentNo=$p(^DHCPHCNTS(mainId),"^",1)
	q 0_"^"_commentNo
ErrorSaveIPCommentData
	i $d(extraPid)&&(extraPid'="") d
	.k ^TMPDHCSTCNTS("Extract","Common",extraPid)
	.k ^TMPDHCSTCNTS("Extract","GeneRandom",extraPid)
	tro
	q	
ThrowSaveIPCommentData
	d ErrorSaveIPCommentData
	q -1_"^"_$tr($ze,"^","")
}

/// description: 保存住院医嘱抽取子表
ClassMethod SaveIpCommentItm(pid, mainId, reSaveFlag)
{
	s errCode=""
	s i=""
	f  s i=$o(^TMPDHCSTCNTS("Extract","GeneRandom",pid,i)) q:(i="")||(errCode'="")  d
	.s admId=$g(^TMPDHCSTCNTS("Extract","GeneRandom",pid,i))
	.s itmRet=##class(web.DHCSTCNTSIPDATA).SaveItm(mainId,admId,"IP")
	.i $p(itmRet,"^",1)=-1 s errCode="-1^插入子表失败"
	q:errCode'="" errCode
	q 0
}

/// description: 拼接查询条件串
/// input:		 inputStr(查询参数),calcuType(类型<P,IP,C,K>)
ClassMethod ConditonNotes(inputStr, calcuType)
{
	q:calcuType="" ""
	s (admType,randNum,centNum,spaceNum,arcItmId,antLevelStr,wayCode,docLocStr,doctorId)=""
	s (docCent,prescNum)=""
    s notes="日期范围: "
    s notes=notes_$p(inputStr,"^",1)_"至"_$p(inputStr,"^",2)
    i calcuType="P" d
    .s docLocStr=$p(inputStr,"^",3)
    .s arcItmId=$p(inputStr,"^",4)
    .s randNum=$p(inputStr,"^",5)
    .s centNum=$p(inputStr,"^",6)
    .s admType=$p(inputStr,"^",7)
    .s doctorId=$p(inputStr,"^",8)
    .s antLevelStr=$p(inputStr,"^",9)
    .s wayCode=$p(inputStr,"^",10)
    .s spaceNum=$p(inputStr,"^",19)
    e  i calcuType="IP" d
    .s docLocStr=$p(inputStr,"^",4)
    .s arcItmId=$p(inputStr,"^",6)
    .s randNum=$p(inputStr,"^",3)
    .s centNum=$p(inputStr,"^",5)
    .s admType=""
    .s doctorId=$p(inputStr,"^",7)
    .s antLevelStr=$p(inputStr,"^",9)
    .s wayCode=$p(inputStr,"^",16)
    .s spaceNum=$p(inputStr,"^",11)
    e  i calcuType="K" d
    .s wayCode=$p(inputStr,"^",6)
	.s docCent=$p(inputStr,"^",3)
	.s prescNum=$p(inputStr,"^",4)
	.s antLevelStr=$p(inputStr,"^",5)
    e  i calcuType="C" d
    .s wayCode=$p(inputStr,"^",6)
	.s randNum=$p(inputStr,"^",3)
	.s docLocStr=$p(inputStr,"^",4)
	.s antLevelStr=$p(inputStr,"^",5)
	.s admType=$p(inputStr,"^",6)
    i admType=1 s admType="门诊"
    e  i admType=2 s admType="急诊"
    e  s admType="全部"
    s notes=notes_","_"类型: "_admType
    i randNum'="" 	s notes=notes_","_"随机数: "_randNum
    i centNum'="" 	s notes=notes_","_"随机比: "_centNum
    i spaceNum'="" 	s notes=notes_","_"间隔数: "_spaceNum
    i arcItmId'="" 	s notes=notes_","_"医嘱名称: "_$p($g(^ARCIM(+arcItmId,1,1)),"^",2)
    i docLocStr'="" d
    .s notes=notes_","_"医生科室: "
    .s locLen=$l(docLocStr,",")
    .s i=""
    .f i=1:1:locLen d
    ..s docLocId=$p(docLocStr,",",i)
    ..q:docLocId=""
    ..s docLocDesc=$p(^CTLOC(docLocId),"^",2)
    ..i $f(docLocDesc,"-") s docLocDesc=$p(docLocDesc,"-",2)
    ..i i'="1" s docLocDesc="、"_docLocDesc
    ..s notes=notes_docLocDesc
    i doctorId'="" 	s notes=notes_","_"医生: "_$p($g(^SSU("SSUSR",doctorId)),"^",2)
    i docCent'="" s notes=notes_","_"医生比例: "_docCent
    i prescNum'="" s notes=notes_","_"处方张数: "_prescNum
    q notes
}

/// descripiton: 抗菌药专项点评-保存
/// w ##class(web.DHCSTCNTS.Main).SaveCommentData("1/01/2017^20/01/2017^130^^^50^^^^P^^^^^^^0^^^^^","66","6840")
ClassMethod SaveAntiCommentData(inputStr, lgLocId, userId)
{
	s ^TMPDHCSTPARAMS("web.DHCSTCNTS.Main","SaveAntiCommentData")=$lb(inputStr, lgLocId, userId)
	s $zt="ThrowSaveAntiCommentData"
	s extraRet=##class(web.DHCSTCNTS.Extract).ExtraAntiPresc(inputStr, lgLocId,1)
	s extraSucc=$p(extraRet,"^",1)
	s extraCnt=$p(extraRet,"^",2)
	s extraPid=$p(extraRet,"^",3)
	q:extraSucc<0 extraRet
	q:extraCnt=0 "-1^没有符合条件的点评数据"
	// 抗菌药随机计算方式不同,于ExtraAntiPresc中计算
	merge ^TMPDHCSTCNTS("Extract","GeneRandom",extraPid)=^TMPDHCSTCNTS("Extract","Common",extraPid)
	k ^TMPDHCSTCNTS("Extract","Common",extraPid)
	s notes=..ConditonNotes(inputStr,"K")
    s wayCode=$p(inputStr,"^",6)
    s wayId=$o(^DHCPCWAY(0,"Code",wayCode,""),-1)
    s reSaveFlag=""
    i wayId'="" s reSaveFlag=$p(^DHCPCWAY(wayId),"^",5)	// 重复抽取标记
    s hospId=$p($g(^CTLOC(+lgLocId)),"^",22)
	tstart
	s mainId=##class(web.DHCSTCNTSMAIN).SaveCommentNo(userId,notes,wayCode,hospId,"F")
	i +mainId'>0 d ErrorSaveAntiCommentData
	q:+mainId'>0 -1_"^"_"保存主表失败"
	s itm=..SaveCommentItm(extraPid,mainId,reSaveFlag)
	i +itm<0 d ErrorSaveAntiCommentData
	q:+itm<0 -3_"^"_"保存子表失败"
	tcommit
	k ^TMPDHCSTCNTS("Extract","GeneRandom",extraPid)
	s commentNo=$p(^DHCPHCNTS(mainId),"^",1)
	q 0_"^"_commentNo
ErrorSaveAntiCommentData
	i $d(extraPid)&&(extraPid'="") d
	.k ^TMPDHCSTCNTS("Extract","Common",extraPid)
	.k ^TMPDHCSTCNTS("Extract","GeneRandom",extraPid)
	tro
	q	
ThrowSaveAntiCommentData
	d ErrorSaveAntiCommentData
	q -1_"^"_$tr($ze,"^","")
}

/// descripiton: 成人专项点评-保存
ClassMethod SaveAdultCommentData(inputStr, lgLocId, userId)
{
	s ^TMPDHCSTPARAMS("web.DHCSTCNTS.Main","SaveAdultCommentData")=$lb(inputStr, lgLocId, userId)
	s $zt="ThrowSaveAdultCommentData"
	s extraRet=##class(web.DHCSTCNTS.Extract).ExtraAdultPresc(inputStr, lgLocId,1)
	s extraSucc=$p(extraRet,"^",1)
	s extraCnt=$p(extraRet,"^",2)
	s extraPid=$p(extraRet,"^",3)
	q:extraSucc<0 extraRet
	q:extraCnt=0 "-1^没有符合条件的点评数据"
	s randNum=+$p(inputStr,"^",3)
	s randNum=$p(randNum,".")		// 随机数
	s centNum="" 					// 抽取比例
	s spaceNum=""   				// 间隔数
	s randRet=##class(web.DHCSTCNTS.Extract).GeneRandom(extraPid,extraCnt,randNum,centNum,spaceNum)
	q:$p(randRet,"^",1)<0 randRet
	s notes=..ConditonNotes(inputStr,"C")
    s wayCode=$p(inputStr,"^",7)	// 点评方式代码
    s wayId=$o(^DHCPCWAY(0,"Code",wayCode,""),-1)
    s reSaveFlag=""
    i wayId'="" s reSaveFlag=$p(^DHCPCWAY(wayId),"^",5)	// 重复抽取标记
    s hospId=$p($g(^CTLOC(+lgLocId)),"^",22)
	tstart
	s mainId=##class(web.DHCSTCNTSMAIN).SaveCommentNo(userId,notes,wayCode,hospId,"F")
	i +mainId'>0 d ErrorSaveAdultCommentData
	q:+mainId'>0 -1_"^"_"保存主表失败"
	s itm=..SaveCommentItm(extraPid,mainId,reSaveFlag)
	i +itm<0 d ErrorSaveAdultCommentData
	q:+itm<0 -3_"^"_"保存子表失败"
	tcommit
	k ^TMPDHCSTCNTS("Extract","GeneRandom",extraPid)
	s commentNo=$p(^DHCPHCNTS(mainId),"^",1)
	q 0_"^"_commentNo
ErrorSaveAdultCommentData
	i $d(extraPid)&&(extraPid'="") d
	.k ^TMPDHCSTCNTS("Extract","Common",extraPid)
	.k ^TMPDHCSTCNTS("Extract","GeneRandom",extraPid)
	tro
	q	
ThrowSaveAdultCommentData
	d ErrorSaveAdultCommentData
	q -1_"^"_$tr($ze,"^","")
}

/// 处方综合点评-统计
ClassMethod JobGetPrescDataNum(inputStr, lgLocId)
{
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	Job ..GetPrescDataNum(pid,inputStr, lgLocId)
	q pid
}

/// 处方综合点评-抽取
ClassMethod JobSaveCommentData(inputStr, lgLocId, userId)
{
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	Job ..GetSaveCommentData(pid,inputStr, lgLocId, userId)
	q pid
}

/// 处方综合点评-抽取-中介
ClassMethod GetSaveCommentData(pid, inputStr, lgLocId, userId)
{
	s saveRet=..SaveCommentData(inputStr, lgLocId, userId)
	s ^JOBDHCSTCNTS(pid)=saveRet
	q saveRet
}

/// 住院医嘱点评-统计
ClassMethod JobGetLeavePersonNum(inputStr, lgLocId)
{
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	Job ..GetLeavePersonNum(pid,inputStr, lgLocId)
	q pid
}

/// 住院医嘱点评-抽取
ClassMethod JobSaveIPCommentData(inputStr, lgLocId, userId)
{
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	Job ..GetSaveIPCommentData(pid,inputStr, lgLocId, userId)
	q pid
}

/// 住院医嘱点评-抽取-中介
/// w ##class(web.DHCSTCNTS.Main).GetSaveIPCommentData("11111","17/10/2016^17/10/2018^1^^^^^^^^^^^^false^IP","306","4638")
ClassMethod GetSaveIPCommentData(pid, inputStr, lgLocId, userId)
{
	s saveRet=..SaveIPCommentData(inputStr, lgLocId, userId)
	s ^JOBDHCSTCNTS(pid)=saveRet
	q saveRet
}

/// 抗菌药专项点评-抽取
ClassMethod JobGetAntiPrescDataNum(inputStr, lgLocId)
{
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	Job ..GetAntiPrescDataNum(pid,inputStr,lgLocId)
	q pid
}

/// 抗菌药专项点评-抽取-中介
ClassMethod GetAntiPrescDataNum(pid, inputStr, lgLocId)
{
	s $zt="ThrowGetAntiPrescDataNum"
	s extraRet=##class(web.DHCSTCNTS.Extract).ExtraAntiPresc(inputStr,lgLocId)
	// extraRet: 0^cnt^pid
	s ^JOBDHCSTCNTS(pid)=extraRet
	q extraRet
ThrowGetAntiPrescDataNum
	s errCode="-1^"_$tr($ze,"^","")
	s ^JOBDHCSTCNTS(pid)=errCode
	q errCode
}

/// 抗菌药专项点评-保存
ClassMethod JobSaveAntiCommentData(inputStr, lgLocId, userId)
{
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	Job ..GetSaveAntiCommentData(pid,inputStr, lgLocId, userId)
	q pid
}

/// 抗菌药专项点评-保存-中介
/// w ##class(web.DHCSTCNTS.Main).GetSaveIPCommentData("11111","17/10/2016^17/10/2018^1^^^^^^^^^^^^false^IP","306","4638")
ClassMethod GetSaveAntiCommentData(pid, inputStr, lgLocId, userId)
{
	s saveRet=..SaveAntiCommentData(inputStr, lgLocId, userId)
	s ^JOBDHCSTCNTS(pid)=saveRet
	q saveRet
}

/// 成人专项点评-抽取
ClassMethod JobGetAdultPrescDataNum(inputStr, lgLocId)
{
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	Job ..GetAdultPrescDataNum(pid,inputStr,lgLocId)
	q pid
}

/// 成人专项点评-抽取-中介
ClassMethod GetAdultPrescDataNum(pid, inputStr, lgLocId)
{
	s $zt="ThrowGetAdultPrescDataNum"
	s extraRet=##class(web.DHCSTCNTS.Extract).ExtraAdultPresc(inputStr,lgLocId)
	// extraRet: 0^cnt^pid
	s ^JOBDHCSTCNTS(pid)=extraRet
	q extraRet
ThrowGetAdultPrescDataNum
	s errCode="-1^"_$tr($ze,"^","")
	s ^JOBDHCSTCNTS(pid)=errCode
	q errCode
}

/// 成人专项点评-保存
ClassMethod JobSaveAdultCommentData(inputStr, lgLocId, userId)
{
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	Job ..GetSaveAdultCommentData(pid,inputStr, lgLocId, userId)
	q pid
}

/// 成人专项点评-保存-中介
ClassMethod GetSaveAdultCommentData(pid, inputStr, lgLocId, userId)
{
	s saveRet=..SaveAdultCommentData(inputStr, lgLocId, userId)
	s ^JOBDHCSTCNTS(pid)=saveRet
	q saveRet
}

/// 此处不适用临时global,获取job返回值
ClassMethod JobRecieve(pid)
{
	s ret=$g(^JOBDHCSTCNTS(pid))
	k ^JOBDHCSTCNTS(pid)
	q ret
}

}
