/// 名称:DtPortal.Doctor.D01PatList.D0103TransPat
/// 描述:Portal医生角色 D0103转科患者服务
/// 编写者：程鹏
/// 编写日期: 2018-11-03
Class DtPortal.Doctor.D01PatList.D0103TransPat Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator： 赵忠原--白明哲更改---20141214------bmz 20150309
/// CreatDate： 2014-7-11
/// Description: 查询转科患者列表
/// Input：		QueryType : 查询单位(P.当前医生;PG.当前医疗组); 
/// 			UserCode：查询单位(用户Code); 
/// 			Type : (1、转入 2、转出)
/// 		   	StartDate：查询开始日期;
/// 		  	EndDate：查询结束日期
/// Return：	InOutTime：转入/转出时间 	
/// 			InOutBedNo：转入/转出床号
/// 			MedicareNo：病案号
/// 			Name：姓名
/// 			TransId：转科记录号(不清楚，取RowId?)
/// 			Sex：性别
/// 			Age：年龄
/// 			PAPMINo：登记号 
/// 			CurLoc：当前科室
/// 			CurBedNo：当前床号
/// 			OutTime：出院时间
/// 			InOutRecord：转入/转出记录  
/// 服务号:		D01.03.01     
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0103TransPat","D010301TransPat","P","ys01","1","2018-11-20","2018-11-29")
Query D010301TransPat(QueryType As %String, UserCode As %String, Type As %String, StartDate As %String, EndDate As %String) As DtPortal.Query(ROWSPEC = "InOutTime,InOutBedNo,MedicareNo,Name,TransId,Sex,Age,PAPMINO, CurLoc,CurBedNo,OutTime,InOutRecord,UserCode,InBed,OutBed,InDept,OutDept,InDoc,DiagnoseDesc,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId")
{
}

ClassMethod D010301TransPatExecute(ByRef qHandle As %Binary, QueryType As %String, UserCode As %String, Type As %String, StartDate As %String, EndDate As %String) As %Status
{
	//s ^zzy("QueryTransPat")=UserCode_"^"_Type_"^"_StartDate_"^"_EndDate_"^"_DateType
	
	n (qHandle,QueryType,UserCode,Type,StartDate,EndDate)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	
	quit:((QueryType="")&&(UserCode="")&&(Type="")) $$$OK
	
	s Today=+$h
	if StartDate["-"  Set StartDate=$zdh(StartDate,3)
	if EndDate["-" Set EndDate=$zdh(EndDate,3)
	if StartDate="" Set StartDate=Today
	if EndDate=""  Set EndDate=Today
	

	s UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
	if UserId="" Quit $$$OK
	s DocId=$P(^SSU("SSUSR",UserId),"^",14)
	if DocId="" Quit $$$OK
	Set LocStr=##class(DtPortal.Doctor.D00CommonService).GetLocByUserCode(UserCode)
	if LocStr="" Quit $$$OK
	
	if QueryType="P" {//个人
		set MUDocIDs="^"_DocId_"^"
	}elseif QueryType="PG" {//主诊组
		//获取医生ID集合
		set MUDocIDs=##Class(DtPortal.Common.PublicService).GetMUDocList(DocId) 
		i MUDocIDs=""  Quit $$$OK
	}else{
		set MUDocIDs="^"_DocId_"^"
	}
	
	Kill ^TMPTransferPatientList($j)
	//转入
	if (Type=1)
	{
	//转入增加循环医生所在科室
	//For indLoc=1:1:$l(LocStr,"^") {
		
		//Set LocId=$p(LocStr,"^",indLoc)
		for Date=StartDate:1:EndDate d
		.s TRANSStartTime=""
		.f  s TRANSStartTime=$o(^PAADMi("TransDateTime",Date,TRANSStartTime)) q:TRANSStartTime=""  d
		..s PAAdm=""
		..f  s PAAdm=$o(^PAADMi("TransDateTime",Date,TRANSStartTime,PAAdm)) q:PAAdm=""  d
		...s firstInDept=""     //记录转入前的科室
		...s firstInBed=""     //记录转入前的床号
		...s firstInDoc=""     //转入前的医生
		...s secInDept=""   //转入后科室
		...s secInBed=""   //转入后床号-不用
		
		
		
		...s InBed=""   //转入前的床号--转出床号  
		...s OutBed=""  //转入床号---转出用?
		...s InDept=""  //转出科室---转入用?
		...s OutDept="" //转入科室---转出用?
		...s child=""
		...s InOutBedNo=""
		...s TransId=""
		...s Age=""
		...s CurBedNo=""
		...s CurLoc=""
		...s InOutTime=""
		...s InOutRecord=""
		...s PaadmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
		...q:PaadmVisitStatus'="A"   //出院病人退出
		...q:$d(^TMPTransferPatientList($j,PAAdm))  //一个就诊记录只查询一次，因为遍历的是所有转科记录
		...s ^TMPTransferPatientList($j,PAAdm)=1
		...s TransBed1=""        //记录床号
		...s CTPCPDR1=""         //记录转科医生
		...s TransLocDr1=""
		...f  s child= $o(^PAADM(PAAdm,"TRANS",child)) q:child=""  d 
		....s TransLocDr=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",6)   //转科科室
		....i TransLocDr'="" s TransLocDr1=TransLocDr
		....s CTPCPDR=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",5)      //转科医护人员
		....i CTPCPDR'="" s CTPCPDR1=CTPCPDR
		....s TransBed=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",8)     //转科床号
		....i TransBed'=""  s TransBed1=TransBed
		....s TransDate=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",1)
		....s TransTime=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",2)
		....s TransDate1=""
	
		....;i (CTPCPDR1'=DocId) d     //20150424修改bug----bmz
		....;i (CTPCPDR'="")&(CTPCPDR'=DocId) d
		....i (CTPCPDR'="")&(MUDocIDs'[("^"_CTPCPDR_"^")) d   //bmz20170704 
		.....s firstInDept=TransLocDr1   //记录转科前科室
		.....s firstInBed=TransBed1  //记录床号
		.....s firstInDoc=CTPCPDR1   //记录主管医生
		
		....i (TransLocDr'="")&(firstInDept'="")&(firstInDept'=TransLocDr) d
		.....s secInDept=TransLocDr //转科后科室
		.....;b ;002
		.....if TransDate1="" d
		......s TransDate1=$p($zd(TransDate,3),"-",1)_"-"_$p($zd(TransDate,3),"-",2)_"-"_$p($zd(TransDate,3),"-",3)
		.....i $g(InOutTime)="" s InOutTime=TransDate1_"&nbsp;"_$zt(TransTime,2)
		.....i $g(TransDate2)="" s TransDate2=TransDate
		....e  i (firstInDept=TransLocDr)  s firstInBed=TransBed1    //记录转入患者的转出床号--bmz20150709  增加if条件  20180605
		
		
		....;i ((CTPCPDR=DocId)&&(secInDept'="")&&(secInDept'=firstInDept)&&(TransDate2>=StartDate)&&(TransDate2<=EndDate)) d   //转入的医生为当前登录医生
		....i ((MUDocIDs[("^"_CTPCPDR_"^"))&&(secInDept'="")&&(secInDept'=firstInDept)&&(TransDate2>=StartDate)&&(TransDate2<=EndDate)) d   //转入的医生为当前登录医生或在当前主诊组   bmz20170704
		.....s secInDept=TransLocDr1
		.....i TransBed1'=firstInBed s secInBed=TransBed1
		.....s OutDept=$p(^CTLOC(firstInDept),"^",2)     //转出科室----firseInDept
		.....i OutDept["-" s OutDept=$p(OutDept,"-",2)
		.....i firstInBed'="" s OutBed=$P($g(^PAWARD(+firstInBed,"BED",$P(firstInBed,"||",2))),"^",1)
		.....i firstInDoc'="" s InDoc=$p(^CTPCP(firstInDoc,1),"^",2)   //前主管医生
    	.....s TransId=PAAdm_"||"_child          //转出床号----转入
		.....d OutPutRow
		
		....s endFlag=..ifEndFlag(secInDept,PAAdm,child)  //下一条有变化，转换科室
		....i ((secInDept'="")&&(secInDept'=firstInDept)&&(endFlag=1)) d 
    	.....s firstInBed=secInBed
    	.....s secInBed=""
    	.....s firstInDept=secInDept
    	.....s secInDept=""
    	.....s InOutTime=""   //chushihuazhuanrushijian
    	.....s TransDate1=""
    	.....s TransDate2=""
		//}
		
		
		


		
		
		Kill ^TMPTransferPatientList($j)
		Quit $$$OK
	}
	
	//转出
	if (Type=2){
	s TransDateNew="" //记录新的转出时间
	s TransTimeNew="" //记录新的转出时间
		
		
	for Date=StartDate:1:EndDate d
	.s TRANSStartTime=""
	.f  s TRANSStartTime=$o(^PAADMi("TransDateTime",Date,TRANSStartTime)) q:TRANSStartTime=""  d
	..s PAAdm=""
	..f  s PAAdm=$o(^PAADMi("TransDateTime",Date,TRANSStartTime,PAAdm)) q:PAAdm=""  d
	...s firstInDept=""     //记录转入前的科室---转入用
	...s firstInBed=""     //记录转入前的床号---转入用
	...s firstInDoc=""     //转入前的医生----转入用
	...s firstOutDept=""   //记录转出前的科室---转出用
	...s firstOutBed=""   //记录转出前的床号
	...s secOutDept=""    //记录转出后的科室
	...s secOutBed=""     //记录转出后的床号
	...s firstDocId=""    //记录转出医生
	...s secDocId=""	//记录转科后的医生
	...s InBed=""   //转出床号---转入用  
	...s OutBed=""  //转入床号---转出用
	...s InDept=""  //转出科室---转入用
	...s OutDept="" //转入科室---转出用
	...s flagOutTrans=0  //设置转科标记
	...s InFlag=""
	...s OutFlag=""
	...s child=""
	...s InOutBedNo=""
	...s TransId=""
	...s Age=""
	...s CurBedNo=""
	...s CurLoc=""
	...s InOutRecord=""
	...;b ;3
	...s PaadmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	...q:PaadmVisitStatus'="A"   //出院病人退出
	...q:$d(^TMPTransferPatientList($j,PAAdm)) 
	...s ^TMPTransferPatientList($j,PAAdm)=1
	...s TransBed1=""        //记录床号
	...s CTPCPDR1=""         //记录转科医生
	...s TransLocDr1=""
	...f  s child= $o(^PAADM(PAAdm,"TRANS",child)) q:child=""  d 
	....s InDoc=""
	....s InBed=""   //转出床号---转入用  
	....s OutBed=""  //转入床号---转出用
	....s InDept=""  //转出科室---转入用
	....s OutDept="" //转入科室---转出用

	
	....s TransLocDr=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",6)   //转科科室
	....i TransLocDr'="" s TransLocDr1=TransLocDr
	....s CTPCPDR=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",5)      //转科医护人员
	....i CTPCPDR'="" s CTPCPDR1=CTPCPDR
	....s TransBed=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",8)     //转科床号
	....i TransBed'=""  s TransBed1=TransBed
	....;i PAAdm="788" b ;111
	....s TransDate=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",1)
	....s TransTime=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",2)
	....;w !,"TransDate="_$zt(TransTime)_"^admId="_PAAdm_"%="_child
	....s TransDate1=""
	....if TransDate'="" d
	.....s TransDate1=$zd(TransDate,3),TransDate1Temp=TransDate
	
	....s DateTime=TransDate1_"&nbsp;"_$zt(TransTime,2)
	

    ....;i CTPCPDR=DocId d 
    ....i MUDocIDs[("^"_CTPCPDR_"^") d    //bmz20170704
    .....s firstOutDept=TransLocDr1  //记录转科前的科室
    .....s firstDocId=DocId         //记录转科前的医生
    
    
	....i (TransLocDr'="")&(firstOutDept'="")&(firstOutDept'=TransLocDr) d
	.....s secOutDept=TransLocDr //转科后科室

	....;i ((CTPCPDR1=DocId)&&(secOutDept="")&&(firstOutDept'="")&&(firstOutDept=TransLocDr1)) d
	....i ((MUDocIDs["^"_CTPCPDR1_"^")&&(secOutDept="")&&(firstOutDept'="")&&(firstOutDept=TransLocDr1)) d   //bmz20170704
	.....s firstOutBed=TransBed1    //记录床号

	....i ((firstOutDept'="")&&(secOutDept'="")&&(secOutDept'=firstOutDept)) d
	.....i TransBed'="" s secOutBed=TransBed
	.....i CTPCPDR'="" s secDocId=CTPCPDR
	.....q:firstDocId'=DocId   //转出的非主管医生退出
	.....;b ;01
	.....i TransDateNew="" s TransDateNew=TransDate   //记录转科时间，
	.....i TransTimeNew="" s TransTimeNew=TransTime  //记录转科时间，
	.....s endFlag=..ifEndFlag(secOutDept,PAAdm,child)
	.....i (secOutBed'="")&(secDocId'="") d
	......d ifBedInfo
	.....e  i endFlag=1 d
	......d ifBedInfo

	/*
	...;转入后再没有转科记录的情况，没有转入床号的患者取出----未判断还有再次转科没有床号的情况,这种情况记录取不出来
	...;一般这种情况出现为刚转科进去，而没有分配床位
	...i (flagOutDeptBed=0)&&(flagOutDeptNoBed=1) d
	....d ifBedInfo  */
	
	//s endFlag=..ifEndFlag(secOutDept,PAAdm,child)
	
	
	
    Kill ^TMPTransferPatientList($j)
	Quit $$$OK
	
	}
	

ifBedInfo

	s OutDept=$p(^CTLOC(firstOutDept),"^",2)      //转出科室
	i OutDept["-" s OutDept=$p(OutDept,"-",2)
	s InDept=$p(^CTLOC(TransLocDr1),"^",2)     //转入科室
	i InDept["-" s InDept=$p(InDept,"-",2)
	i firstOutBed'="" s OutBed=$P($g(^PAWARD(+firstOutBed,"BED",$P(firstOutBed,"||",2))),"^",1)	
	;i TransBed1'=""  s InBed=$P($g(^PAWARD(+TransBed1,"BED",$P(TransBed1,"||",2))),"^",1)
	i secOutBed'=""  s InBed=$P($g(^PAWARD(+secOutBed,"BED",$P(secOutBed,"||",2))),"^",1)
	i secDocId'="" s InDoc=$p(^CTPCP(secDocId,1),"^",2)
	s InOutTime=DateTime
	i (TransDateNew'="")&&(TransTimeNew'="") s InOutTime=$zd(TransDateNew,3)_"&nbsp;"_$zt(TransTimeNew,2)
	s TransId=PAAdm_"||"_child
	
	s firstOutDept=secOutDept
	s secOutDept=""
	s TransBed1=""
	s CTPCPDR1=""
	s firstDocId=secDocId
	s secDocId=""
	s secOutBed=""
	
	s TransDateNew="" //记录新的转出时间
	s TransTimeNew="" //记录新的转出时间
	
	q:(TransDate1Temp<StartDate)
	q:(TransDate1Temp>EndDate)

	d OutPutRow
	
	q


	
OutPutRow
	Set PatientID=$P($g(^PAADM(PAAdm)),"^",1)
	s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(PAAdm)
	s BedNo=$p(patInfoStr,"^",1)
	s MedicareNo=$p(patInfoStr,"^",5)
	s Name=$p(patInfoStr,"^",2)
	s Sex=$p(patInfoStr,"^",3)
	s Age=$p(patInfoStr,"^",4)
	s AdmReason=$p(patInfoStr,"^",6)
	s:CurBedNo="" CurBedNo=BedNo
    Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
    Set CurLocDr=$P($g(^PAADM(PAAdm)),"^",4)
    Set:CurLocDr'="" CurLoc=$p(^CTLOC(CurLocDr),"^",2) 

	set disDateStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(PAAdm)
	Set DischgDate=$P(disDateStr,"^",1)
	Set DischgTime=$P(disDateStr,"^",2)
	if DischgDate'="" s DischgDate=$zd(DischgDate,3)
	if DischgDate'="" s DischgDate=$p(DischgDate,"-",1)_"年"_$p(DischgDate,"-",2)_"月"_$p(DischgDate,"-",3)_"日"
	if DischgTime'="" s DischgTime=$zt(DischgTime)
    if DischgDate'="" Set OutTime=DischgDate_" "_DischgTime
    s DiagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(PAAdm)
    Set AdmId=PAAdm
	//获取打开电子病历所需要的参数
	set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(PAAdm)
	set EMRDocID=$p(EMRinfo,"^",1)
	set EMRInstanceID=$p(EMRinfo,"^",2)
	set locID=$p(EMRinfo,"^",3)
	set PatientID=$p(EMRinfo,"^",4)
	set EpisodeID=$p(EMRinfo,"^",5)
	Set ^||CacheTemp(repid,ind)=$lb(InOutTime,InOutBedNo,MedicareNo,Name,TransId,Sex,Age,PAPMINO, CurLoc,CurBedNo,OutTime,InOutRecord,UserCode,InBed,OutBed,InDept,OutDept,InDoc,DiagnoseDesc,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId)
	Set ind=ind+1
	quit
}

// 判断转科记录数据是否是转科后最后一条数据---bmz 20150309

ClassMethod ifEndFlag(secOutDept, PAAdm, child) As %String
{
	;b ;3
	n (secOutDept,PAAdm,child)
	s flagEnd=0
	//判断转科结束
	s flagEnd=0   //转科结束标记
	s childEnd= $o(^PAADM(PAAdm,"TRANS",child))
	i childEnd'="" d
	.s TransLocDrNext=$p($g(^PAADM(PAAdm,"TRANS",childEnd)),"^",6)    //下一条数据的转科科室
	.i (TransLocDrNext'="")&(TransLocDrNext'=secOutDept) s flagEnd=1    //科室发生变化，说明上条记录是转科的最后一条记录
	e  s flagEnd=1     //childEnd为空说明是最后一条记录
	;b ;4
	q flagEnd
}

}
