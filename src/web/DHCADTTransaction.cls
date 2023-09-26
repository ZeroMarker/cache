Import SQLUser

Include Nur.DateFormat

Class web.DHCADTTransaction Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：     PuYongHua
/// CreatDate :   2018-03-21
/// Description : 获取某段时间内通过入院转科进入某个科室的总人数
/// Input :       开始日期,结束日期,科室Id,
/// Return ：     某段时间内通过入院转科进入某个科室的总人数
ClassMethod GetPatNumByTransLoc(SttDate As %String, EndDate As %String, LocId As %String) As %String
{
	q:LocId="" ""
	q:SttDate="" ""
	i SttDate["/" s sttDate=$zdh(SttDate,4)
    i EndDate["/" s endDate=$zdh(EndDate,4)
    i SttDate["-" s sttDate=$zdh(SttDate,3)
    i EndDate["-" s endDate=$zdh(EndDate,3)
    i EndDate="" s endDate=+$h
    s Count=0
	for date=sttDate:1:endDate d
    .s time=""
    .f  s time=$o(^PAADMi("TransDateTime",date,time)) q:time=""  d
    ..s episodeID=""
    ..f  s episodeID=$o(^PAADMi("TransDateTime",date,time,episodeID)) q:episodeID=""  d
	...s transSub="" f  s transSub=$o(^PAADMi("TransLoc",episodeID,LocId,transSub)) q:transSub=""  d
	....s transStartDate=$P(^PAADM(episodeID,"TRANS",transSub),"^",1)
	....s transStartTime=$P(^PAADM(episodeID,"TRANS",transSub),"^",2)
	....q:(transStartDate'=date)!(transStartTime'=time)
	....s Count=Count+1
	q Count
}

/// 病人转病区、转床
ClassMethod MoveAdm(EpisodeID = "", userId = "", wardDescOrId = "", bedId = "", editPreTrans = "Y") As %String
{
	q:(EpisodeID="") "无病人信息!"
	q:(userId="") "无用户信息!"
	
	
	s PatCurWardID=$p(^PAADM(EpisodeID),"^",70)
	s PatCurBedID=$p(^PAADM(EpisodeID),"^",73)
	q:((+wardDescOrId=PatCurWardID)&&(PatCurBedID=bedId)&&(editPreTrans'="N")) "转移位置与患者当前位置相同！"
	
	s wardId=""
	i wardDescOrId'="" d
	    .i wardDescOrId=+wardDescOrId s wardId=wardDescOrId q
	    .s wardDesc=$$ALPHAUP^SSUTIL4(wardDescOrId)
	    .s wardId=$o(^PAWARD(0,"WARD_Desc",wardDesc,""))
	i bedId'="" s wardId=+bedId
	q:(wardId="") "无病区信息!"
	s roomId="",bedSub=""
	i bedId'="" s bedSub=$p(bedId,"||",2)
	s bedCodeName=""
	s:bedId'="" bedCodeName=$p(^PAWARD(+bedId,"BED",bedSub),"^",1)
	
	i bedSub'="" s roomId=$p(^PAWARD(+bedId,"BED",bedSub),"^",3)
	s curDate=+$h,curTime=$p($h,",",2)
	s curTime=$E($zt(curTime,1),1,5)
	s curTime=$zth(curTime,2)
	s reqstId=$o(^PAC("REQST",0,"Code","T",""))
	s transtypId=$o(^PAC("TRANSTYP",0,"Code","M",""))
	s preTransSub="",transSub=0
	f  s preTransSub=$o(^PAADM(EpisodeID,"TRANS",preTransSub),-1) q:(preTransSub="")!(transSub>0)  d
	    .i $p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",21)=transtypId s transSub=preTransSub
	//s ^ypzTmp("tran")=transSub
	s firstToBed=1,tmpTransSub=""
	f  s tmpTransSub=$o(^PAADM(EpisodeID,"TRANS",tmpTransSub)) q:(tmpTransSub="")||(firstToBed=0)  d
	.i +$p($g(^PAADM(EpisodeID,"TRANS",tmpTransSub)),"^",8)>0 s firstToBed=0
	i (firstToBed=1){
				//第一次分床时记录下时间
			s motherAdm=$p($g(^PAADM(EpisodeID)),"^",75)
			i motherAdm'="" d
			.s PAAdmCurrLoc = $p($g(^PAADM(motherAdm)),"^",4)
			.s adminDateTimeRtn = ##class(web.DHCDischargeHistory).SaveAdminDateTime(EpisodeID,+$h,$p($h,",",2),2,PAAdmCurrLoc,wardId)	
				
	}
	i transSub>0,editPreTrans="Y" d
	    .s preTransId=EpisodeID_"||"_transSub
	    .s preReqstId=$o(^PAC("REQST",0,"Code","D",""))
	    .&sql(update PA_AdmTransaction set TRANS_Status_DR=:preReqstId,TRANS_EndDate=:curDate,TRANS_EndTime=:curTime,TRANS_BedCode=:bedCodeName where TRANS_RowId=:preTransId)
	&sql(insert into PA_AdmTransaction (TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
		TRANS_Ward_DR,TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
		TRANS_TransType_DR,TRANS_Room_DR,TRANS_Bed_DR,TRANS_BedCode)  
		Values (:EpisodeID,:curDate,:curTime,:wardId,:reqstId,:curDate,:curTime,:userId,:transtypId,:roomId,:bedId,:bedCodeName))
	i SQLCODE q "插入转病区信息出错!"
	s transId=$g(%ROWID)
	q:transId="" ""
	s bookedStatus="O"
	i $o(^PAWARDA(0,"ADM",EpisodeID,""))'="" d
	    .//s mBabyBedtpId=$o(^PAC("BEDTP",0,"BEDTP_Code","MATERNALBABY",""))
	    .s curWardId=$o(^PAWARDA(0,"ADM",EpisodeID,""))
	    .s curBedSub=$o(^PAWARDA(0,"ADM",EpisodeID,+curWardId,""))
	    .s bedtpId=$p(^PAWARD(+curWardId,"BED",+curBedSub),"^",2)
	    .&sql(delete from PAC_BedAdm where ADM_PAADM_DR=:EpisodeID)
	    .q:SQLCODE
	    .//q:mBabyBedtpId=""
	    .//i mBabyBedtpId=bedtpId s $p(^PAWARD(curWardId,"BED",curBedSub),"^",4)="N"
	    .i ##class(Nur.NIS.Service.Base.Bed).ifBabyBedByBedTypeId(bedtpId)="Y" s $p(^PAWARD(curWardId,"BED",curBedSub),"^",4)="N"
	i $o(^PAWARDA(0,"WADM",EpisodeID,""))'="" &sql(delete from PAC_WardAdm where WADM_PAADM_DR=:EpisodeID)
	if bedSub'="" 
	{
		&sql(insert into PAC_BedAdm (ADM_ParRef,ADM_PAADM_DR,ADM_BookedStatus,ADM_Trans_DR)
			Values (:bedId,:EpisodeID,:bookedStatus,:transId))
		i SQLCODE q "插入床位信息出错!"

	}
	else
	{
		&sql(insert into PAC_WardAdm (WADM_ParRef,WADM_PAADM_DR,WADM_BookedStatus,WADM_Trans_DR)
			Values (:wardId,:EpisodeID,:bookedStatus,:transId))
		i SQLCODE q "插入等待区信息出错!"
	}
	&sql(update PA_Adm (PAADM_CurrentBed_DR,PAADM_CurrentWard_Dr,PAADM_CurrentRoom_DR) Values (:bedId,:wardId,:roomId) Where PAADM_RowId=:EpisodeID)
	i SQLCODE q "更新就诊病区、房间及床位信息出错!"
	s locId=$p(^PAWARD(wardId),"^",5)
	q:locId="" ""
	s cptSub=$o(^CTLOC(locId,"CPT",0))
	q:cptSub="" 0
	s caretypId=$p($g(^CTLOC(locId,"CPT",cptSub)),"^")
	q:caretypId="" 0
	s caretypCode=$p(^PAC("CARETYP",caretypId),"^")
	q:caretypCode="" 0
	s ctacuId=$o(^CT("ACU",0,"Code",caretypCode,""))
	q:ctacuId="" 0
	&sql(update PA_Adm (PAADM_Priority_DR) Values (:ctacuId) Where PAADM_RowId=:EpisodeID)
    i SQLCODE q "修改病人等级出错!"
	q 0
}

/// Test: ##class(web.DHCADTTransaction).MoveAttachBaby("117","4636","","")
ClassMethod MoveAttachBaby(EpisodeID = "", userId = "", wardDesc = "", bedId = "") As %String
{
	s ^tempsc("MoveAttachBaby")=$lb(EpisodeID , userId , wardDesc , bedId ) 
	q:$o(^PAADMi("Mother",EpisodeID,""))="" 0 //非产妇
	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	q:wardId="" 0
	s ret=##class(Nur.CommonInterface.Bed).transBabyWithMother(EpisodeID, wardId, userId, "","1")
	q ret
}

/// Test: ##class(web.DHCADTTransaction).MoveAttachBaby("117","4636","","")
ClassMethod MoveAttachBabyBak(EpisodeID = "", userId = "", wardDesc = "", bedId = "") As %String
{
	;s ^tempsc("MoveAttachBaby")=$lb(EpisodeID , userId , wardDesc , bedId ) 
	//暂不考虑母亲转科的情况，小孩可以转到等待区
	q:(EpisodeID="") "无病人信息!"
    //s mBabyBedtpId=$o(^PAC("BEDTP",0,"BEDTP_Code","MATERNALBABY",""))
    //k ^ypzTmp
    s curBedId=$p(^PAADM(EpisodeID),"^",73)
    s curBedSub=$p(curBedId,"||",2)
    s curBedtpId=""
    i curBedSub'="" s curBedtpId=$p(^PAWARD(+curBedId,"BED",curBedSub),"^",2)
    //s ^ypzTmp(EpisodeID,"00bedtp")=curBedId_"/"_mBabyBedtpId_"/"_curBedtpId
    //i curBedSub'="",mBabyBedtpId'="",curBedtpId=mBabyBedtpId q "不能移动该婴儿床!"
	q:$o(^PAADMi("Mother",EpisodeID,""))="" 0 //非产妇
	q:(userId="") "无用户信息!"
	s wardId=""
	i wardDesc'="" d
	    .s wardDesc=$$ALPHAUP^SSUTIL4(wardDesc)
	    .s wardId=$o(^PAWARD(0,"WARD_Desc",wardDesc,""))
	i bedId'="" s wardId=+bedId
	i bedId="",wardId="" d
	    .s wardId=$p(^PAADM(EpisodeID),"^",70)
	    .s bedId=$p(^PAADM(EpisodeID),"^",73)
	q:(wardId="") "无母亲病区信息!"
	s bedtpId="",bedSub="",retStr=0
	s bedSub=$p(bedId,"||",2)
	i bedSub'="" s bedtpId=$p(^PAWARD(+bedId,"BED",bedSub),"^",2)
    //如果床位上有人则报错，退出
	i bedSub'="",$p(^PAWARD(+bedId,"BED",bedSub),"^",4)'="Y" q "母亲待移床位未激活!"
    //i mBabyBedtpId'="",mBabyBedtpId=bedtpId q "母亲不能移到婴儿床!"
    i ##class(Nur.NIS.Service.Base.Bed).ifBabyBedByBedTypeId(bedtpId="Y") q "母亲不能移到婴儿床!"
	i bedSub'="" d
	    .s bedAdmSub=0
	    .f  s bedAdmSub=$o(^PAWARDA(+bedId,"BED",bedSub,"ADM",bedAdmSub)) q:bedAdmSub=""  d
	        ..i $p(^PAWARDA(+bedId,"BED",bedSub,"ADM",bedAdmSub),"^")=EpisodeID q //只移婴儿
	        ..i $p(^PAWARDA(+bedId,"BED",bedSub,"ADM",bedAdmSub),"^",2)="O" s retStr="母亲床位已占用!"
	i bedSub'="",retStr'=0 q retStr
	
	s tmpBmbId=0,bmbId="" //找婴儿床偏离记录病人信息
	f  s tmpBmbId=$o(^DHCBed("MaternalBaby",0,"Ward",wardId,tmpBmbId)) q:tmpBmbId=""  d
	    .q:'$d(^DHCBed("MaternalBaby",tmpBmbId))
	    .s motherBedtpId=$p(^DHCBed("MaternalBaby",tmpBmbId),"^",2) 
	    .i motherBedtpId="" s bmbId=tmpBmbId //一般值
	    .i bedtpId=motherBedtpId s bmbId=tmpBmbId q //对应床位类型值
    
    i bedSub'="",mBabyBedtpId'="",bmbId'="" d
        .//取婴儿床偏离信息
        .s bmbMotherLeftOffset=$p(^DHCBed("MaternalBaby",bmbId),"^",3)
        .s bmbMotherTopOffset=$p(^DHCBed("MaternalBaby",bmbId),"^",4)
        .s bmbMotherIntervalX=$p(^DHCBed("MaternalBaby",bmbId),"^",5)
        .s bmbMotherIntervalY=$p(^DHCBed("MaternalBaby",bmbId),"^",6)
        .s bmbWidth=$p(^DHCBed("MaternalBaby",bmbId),"^",7)
        .s bmbHeight=$p(^DHCBed("MaternalBaby",bmbId),"^",8)
        .s bmbBabyIntervalY=$p(^DHCBed("MaternalBaby",bmbId),"^",9)
        .s bmbMaxAttachBabies=$p(^DHCBed("MaternalBaby",bmbId),"^",10)
        .i bmbMotherIntervalX="" s bmbMotherIntervalX=-1
        .i bmbMotherIntervalY="" s bmbMotherIntervalY=-1
        .
	    .s bedPositionLeft=$p(^PAWARD(+bedId,"BED",bedSub),"^",15)
	    .i bmbMotherIntervalX'<0 s bedPositionLeft=bedPositionLeft+$p(^PAWARD(+bedId,"BED",bedSub),"^",18)+bmbMotherIntervalX
	    .e  s bedPositionLeft=bedPositionLeft+bmbMotherLeftOffset
	    .s bedPositionTop=$p(^PAWARD(+bedId,"BED",bedSub),"^",16)
	    .//w bedPositionTop_"/"_bmbMotherIntervalY,!
	    .i bmbMotherIntervalY'<0 s bedPositionTop=bedPositionTop+$p(^PAWARD(+bedId,"BED",bedSub),"^",17)+bmbMotherIntervalY
	    .e  s bedPositionTop=bedPositionTop+bmbMotherTopOffset
        .
        .//判婴儿床位是否已占用
        .s motherBabiesLeft=bedPositionLeft
        .s motherBabiesRight=bedPositionLeft+1
        .s motherBabiesTop=bedPositionTop
        .s motherBabiesBottom=bedPositionTop+(bmbMaxAttachBabies*(bmbHeight+bmbBabyIntervalY))
        .s babyBedSub=""
        .f  s babyBedSub=$o(^PAWARD("BED_BedType_DR",mBabyBedtpId,wardId,babyBedSub)) q:babyBedSub=""  d
            ..s bedAdmSub=$o(^PAWARDA(wardId,"BED",babyBedSub,"ADM",0)) //暂不考虑一床多人
            ..q:bedAdmSub=""
            ..q:$p(^PAWARDA(wardId,"BED",babyBedSub,"ADM",bedAdmSub),"^",2)'="O"
            ..s curBedAdmId=$p(^PAWARDA(wardId,"BED",babyBedSub,"ADM",bedAdmSub),"^")
            ..q:$P(^PAADM(curBedAdmId),"^",75)=EpisodeID //兄姊不占用
            ..q:$p(^PAWARD(wardId,"BED",babyBedSub),"^",4)'="Y"  //判已画床是否占了位置
            ..s curBedPositionLeft=$p(^PAWARD(wardId,"BED",babyBedSub),"^",15) //
            ..s curBedPositionTop=$p(^PAWARD(wardId,"BED",babyBedSub),"^",16)
            ..q:(curBedPositionLeft'="")!(curBedPositionLeft<motherBabiesLeft)!(curBedPositionLeft>motherBabiesRight)
            ..q:(curBedPositionTop'="")!(curBedPositionTop<motherBabiesTop)!(curBedPositionTop>motherBabiesBottom)
            ..s retStr="婴儿床已占用!"
	i bedSub'="",retStr'=0 q retStr
    //新增婴儿、婴儿与母亲同步：在同一科室，则同步到相邻床或同在等待区。
    //??同步母婴：如果母亲在床位上，婴儿在等待区，出图标提示？双击同步（同步条件：未出院，同一科室）
    
    //如果是移入等待区：如果原来婴儿是等待区则退出
    //                结束转科，加入新转科，撤销等待区/床位占用，加入等待区占用
    //转病区
	s babyAdmId=""
	f  s babyAdmId=$o(^PAADMi("Mother",EpisodeID,babyAdmId)) q:babyAdmId=""  d
	    .q:$p($g(^PAADM(babyAdmId)),"^",20)'="A"
	    .s babyWardId=$p(^PAADM(babyAdmId),"^",70)
	    .s babyBedId=$p(^PAADM(babyAdmId),"^",73)
	    .s babyBedSub=$p(babyBedId,"||",2)
	    .
	    .//如果两个婴儿的床位号相同，床位信息不是该婴儿的视为在等待区，另找一床
	    .s isDuplicateBed=0
	    .i babyWardId'="",babyBedSub'="" d
	        ..s bedAdmSub=0
	        ..f  s bedAdmSub=$o(^PAWARDA(babyWardId,"BED",babyBedSub,"ADM",bedAdmSub)) q:bedAdmSub=""  d
	            ...q:$p(^PAWARDA(babyWardId,"BED",babyBedSub,"ADM",bedAdmSub),"^")=babyAdmId //正确
	            ...s isDuplicateBed=1
	    .i isDuplicateBed s babyBedId="",babyBedSub="" //作为等待区处理
	    .s babyBedtpId=""
	    .i babyBedSub'="" s babyBedtpId=$p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",2)
	    .//s ^ypzTmp(babyAdmId,"01bedtp")=wardId_"/"_bedId_"/"_babyWardId_"/"_babyBedId_"/"_mBabyBedtpId_"/"_babyBedtpId
	    .q:(babyBedSub'="")&(mBabyBedtpId'=babyBedtpId) //不处理在非母婴同室床上的婴儿
	    .
	    .//s ^ypzTmp(babyAdmId,"02start")=wardId_"/"_bedId_"/"_babyWardId_"/"_babyBedId_"/"_bedSub_"/"_bmbId
	    .i (bmbId="")&(babyBedSub="") q //新病区无母婴同室
	    .i (bmbId="")&(babyBedSub'="") d
	        ..i babyBedtpId=mBabyBedtpId s $p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",4)="N"
	        ..//s ^ypzTmp(babyAdmId,"02Move")=wardId_"/"_bedId_"/"_babyWardId_"/"_babyBedId_"/"_bedSub_"/"_bmbId
	        ..s retStr=..MoveAdm(babyAdmId, userId, babyWardId, "") //婴儿在床上，目标不是母婴同室
	    .//s ^ypzTmp(babyAdmId,"03bmbExit")=wardId_"/"_bedId_"/"_babyWardId_"/"_babyBedId_"/"_bedSub_"/"_bmbId
	    .q:bmbId=""
	    .q:(wardId=babyWardId)&(bedSub="")&(babyBedSub="") //同一个等待区，无变化
	    .//s ^ypzTmp(babyAdmId,"04bmbExit")=wardId_"/"_bedId_"/"_babyWardId_"/"_babyBedId_"/"_bedSub_"/"_bmbId
	    .q:(wardId=babyWardId)&(bedSub'="")&(babyBedSub'="") //1同区移床
	    .//s ^ypzTmp(babyAdmId,"05bmbExit")=wardId_"/"_bedId_"/"_babyWardId_"/"_babyBedId_"/"_bedSub_"/"_bmbId
	    .//2移区，3区移跨区床，4区移区床，5床移区，6床移跨区，7床移跨区床 
	    .s newBabyBedId="" //找床位:347
	    .i bedSub'="",bmbId'="" d  //找新婴儿床：母亲有床位，是母婴病区347
            ..s newBabyBedSub=""
            ..f  s newBabyBedSub=$o(^PAWARD("BED_BedType_DR",mBabyBedtpId,wardId,newBabyBedSub)) q:(newBabyBedSub="")!(newBabyBedId'="")  d
                ...//s ^ypzTmp(babyAdmId,newBabyBedSub)=wardId_"/"_bedId_","_babyWardId_"/"_babyBedId_"\"_$p(^PAWARD(wardId,"BED",newBabyBedSub),"^",4)
                ...q:$p(^PAWARD(wardId,"BED",newBabyBedSub),"^",4)="Y"
                ...s bedAdmSub=$o(^PAWARDA(wardId,"BED",newBabyBedSub,"ADM",0)) //暂不考虑一床多人
                ...//s ^ypzTmp(babyAdmId,newBabyBedSub)=wardId_"/"_bedId_","_babyWardId_"/"_babyBedId_"\\"_bedAdmSub_"/"
                ...i bedAdmSub="" s newBabyBedId=wardId_"||"_newBabyBedSub q
                ...//s ^ypzTmp(babyAdmId,newBabyBedSub)=wardId_"/"_bedId_","_babyWardId_"/"_babyBedId_"\\\"_bedAdmSub_"/"
                ...q:$p($g(^PAWARDA(wardId,"BED",newBabyBedSub,"ADM",bedAdmSub)),"^",2)="O"
                ...s newBabyBedId=wardId_"||"_newBabyBedSub
	    .//取消床位可用567
	    .//s ^ypzTmp(babyAdmId,"06find")=wardId_"/"_bedId_","_babyWardId_"/"_babyBedId_","_newBabyBedId
	    .
	    .//s ^ypzTmp(babyAdmId,"07get")=wardId_"/"_bedId_","_babyWardId_"/"_babyBedId_","_mBabyBedtpId_"/"_babyBedtpId
	    .i babyBedSub'="",babyBedtpId=mBabyBedtpId  s $p(^PAWARD(babyWardId,"BED",babyBedSub),"^",4)="N"
	    .s retStr=..MoveAdm(babyAdmId, userId, wardId, newBabyBedId)
    //s ^ypzTmp(EpisodeID,"08bmb")=wardId_"/"_bedId_","_bmbId
    q:bmbId="" 0 //非母婴同室病区
    //s ^ypzTmp(EpisodeID,"08bedsub")=wardId_"/"_bedId_","_bmbId
    i bedSub="" q retStr
    i mBabyBedtpId="" q retStr
    s bedCode=$p(^PAWARD(+bedId,"BED",bedSub),"^",1)
    
    //如果是等待区移入床位，是否有空闲床可用，无则退出
    //                      结束转科，加入新转科，撤销等待区/床位占用，加入床位占用

	s motherCtlocId=$p(^PAADM(EpisodeID),"^",4)
	
	s babyAdmId="",babyNum=0
	f  s babyAdmId=$o(^PAADMi("Mother",EpisodeID,babyAdmId)) q:babyAdmId=""  d
	    .//死亡婴儿未办理住院
	    .//s ^ypzTmp(babyAdmId,"09get")=wardId_"/"_bedId_","_babyWardId_"/"_babyBedId_","_mBabyBedtpId_"/"_babyBedtpId
	    .q:$p($g(^PAADM(babyAdmId)),"^",20)'="A"
	    .q:motherCtlocId'=$p(^PAADM(babyAdmId),"^",4) //跨科退出
	    .//w "babyAdmId="_babyAdmId,!
	    .s babyWardId=$p(^PAADM(babyAdmId),"^",70)
	    .s babyBedId=$p(^PAADM(babyAdmId),"^",73)
	    .s babyBedSub=""
	    .i babyBedId'="" s babyBedSub=$p(babyBedId,"||",2)
	    .//s ^ypzTmp(babyAdmId,"10get")=wardId_"/"_bedId_","_babyWardId_"/"_babyBedId_","_mBabyBedtpId_"/"_babyBedtpId
	    .q:babyBedSub="" /////////////temp
	    .//s ^ypzTmp(babyAdmId,"11adj")=mBabyBedtpId_"/"_$p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",2)
	    .q:mBabyBedtpId'=$p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",2)
	    .
	    .//修改床位名称、位置、激活属性
	    .s $p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",4)="Y"
	    .s $p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",15)=bedPositionLeft
	    .s $p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",16)=bedPositionTop+(babyNum*(bmbHeight+bmbBabyIntervalY))
	    .s $p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",17)=bmbHeight
	    .s $p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",18)=bmbWidth
	    .s $p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",3)=$p(^PAWARD(+bedId,"BED",bedSub),"^",3)
	    .s babyNum=babyNum+1
	    .s $p(^PAWARD(+babyBedId,"BED",babyBedSub),"^",1)=bedCode_"婴儿"_babyNum
	    .
	q 0
}

ClassMethod GetMotherLocWard(PatientID)
{
	q:PatientID="" "^"
	s motherPatientID=$p(^PAPER(PatientID,"PER",4),"^",13)
	q:motherPatientID="" "^"
	s EpisodeID=0,motherEpisodeID=""
	f  s EpisodeID=$o(^PAPERdr(motherPatientID,"ADM","I",EpisodeID)) q:(EpisodeID="")!(motherEpisodeID'="")  d
        .s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
        .i pavisit'="A" q
        .s motherEpisodeID=EpisodeID
    i motherEpisodeID="" q "^"
    s patLocId=$p(^PAADM(motherEpisodeID),"^",4)
    s patLocDesc=$p(^CTLOC(+patLocId),"^",2)
    s patWardId=$p(^PAADM(motherEpisodeID),"^",70)
    s patWardDesc=$p(^PAWARD(+patWardId),"^",2)
    q patLocId_"^"_patLocDesc_"^"_patWardId_"^"_patWardDesc
}

ClassMethod GetLocWard(EpisodeID, TransLocId, transWardDesc) As %String
{
	//科室与病区不关联时不能转科
	q:$g(^DHCDishChargeSet("Trans","ifNeedLocWardRelation"))'="Y" 0
 	i EpisodeID="" q "就诊号为空!"
  	q:(TransLocId="")&(transWardDesc="") 0
  	i TransLocId="" s TransLocId=$p($g(^PAADM(EpisodeID)),"^",4)
  	q:TransLocId="" 0
  	i transWardDesc="" s TransWardId=$p($g(^PAADM(EpisodeID)),"^",70)
  	e  s TransWardId=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(transWardDesc),""))
  	q:TransWardId="" 0
  	s TransWardLocId=$p($G(^PAWARD(TransWardId)),"^",5)
 	
 	s patWardId=$p($g(^PAADM(EpisodeID)),"^",70)
 	s patWardLocId=$p($G(^PAWARD(patWardId)),"^",5)
 	s patWardLocType=$p($G(^CTLOC(patWardLocId)),"^",13)
 	
 	s TransWardLocType=$p($G(^CTLOC(TransWardLocId)),"^",13)
 	i patWardLocType'="EM",TransWardLocType="EM" q "不能转到急诊科室!"
 	
 	s ret="请选择正确的病区与对应科室!"
 	s LinkChildSub=0   
 	f  s LinkChildSub=$o(^CTLOC(TransWardLocId,"LINK",LinkChildSub)) q:LinkChildSub=""  d
 	.s LinklocId=$p($G(^CTLOC(TransWardLocId,"LINK",LinkChildSub)),"^",1)
 	.i LinklocId=TransLocId s ret=0
 	q ret
}

/// 查询本病区的病人
Query GetQueryReg(PacWard As %String) As %Query(ROWSPEC = "patName:%String,regNo:%String,bedCode:%String,EpisodeID:%String")
{
}

ClassMethod GetQueryRegExecute(ByRef qHandle As %Binary, PacWard As %String) As %Status
{
	s repid=$i(^CacheTemp)
	s ind=1
	s paroom=0 f  s paroom=$o(^PAADMi("CurrWard",PacWard,paroom)) q:paroom=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",PacWard,paroom,EpisodeID)) q:EpisodeID=""  d
	..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	..s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	..s bedSub=$p($g(^PAADM(EpisodeID)),"^",73)
	..q:bedSub=""
	..s curWardId=$P(bedSub,"||",1)
	..s curbedSub=$P(bedSub,"||",2)
	..q:(curWardId="")!(curbedSub="")
	..s bedCode=$p($g(^PAWARD(curWardId,"BED",curbedSub)),"^",1)
    ..q:bedCode=""
	..d OutRowReg
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutRowReg
	s Data=$lb(patName,regNo,bedCode,EpisodeID)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod GetQueryRegFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQueryRegExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
		s AtEnd=1
		s Row=""
	}
	else {			
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetQueryRegClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQueryRegExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 在PAC_BedStatusChange中插入一条记录,插入包床患者ID
ClassMethod UpdatePatBedStChange(STATRowId = "", StartDate = "", StartTime = "", EndDate = "", EndTime = "", UnavailableReason = "", EpisodeID = "", userId = "", WardId = "", BedId = "") As %String
{
	
	;w ##class(web.DHCADTTransaction).UpdatePatBedStChange("","17/06/2009","11:48","","","1","54429","69","10","10||11")
	q:(StartDate="") "'开始日期'必填项空白!"
	q:(StartTime="") "'开始时间'必填项空白!"
	q:(UnavailableReason="") "'不可用原因'必填项空白!"
  	q:(WardId="") "无病区信息!"
  	q:(BedId="") "无床位信息!"
  	q:(userId="") "无更新用户!"
  	q:(EpisodeID="")&&(UnavailableReason["包床") "包床患者空白"
  	s CtlocId=""
  	i EpisodeID'="" s CtlocId=$p(^PAADM(EpisodeID),"^",4)
	q:(CtlocId="")&(EpisodeID'="") "无就诊科室信息!"

	
	s StartDate=$$$zdh(StartDate,4)
	s StartTime=$zth(StartTime,2)
	i EndDate'="" s EndDate=$$$zdh(EndDate,4)
	i EndTime'="" s EndTime=$zth(EndTime,2)
	q:(EndDate'="")&&(EndDate<StartDate) "截止日期应当大于开始日期！"
	q:(EndDate=StartDate)&&(EndTime<StartTime) "截止时间应当大于开始时间！"
	s curDate=+$h,curTime=$p($h,",",2)
	s curTime=$E($zt(curTime,1),1,5)
	s curTime=$zth(curTime,2)
	
	i BedId'=""  d
	.s WardId=$P(BedId,"||",1)
	.s BedSub=$P(BedId,"||",2)
	
	s bedAdm=$o(^PAWARDA(+WardId,"BED",BedSub,"ADM",0))
	q:bedAdm'="" "不能为该床位包床, 床位已经有人!"
	s preBedStatSub="",BedStatSub=0 	
 	s preBedStatSub=$o(^PAWARDA(WardId,"BED",BedSub,"STAT",""),-1)
 	i preBedStatSub'=""  d
 	.i $p(^PAWARDA(WardId,"BED",BedSub,"STAT",preBedStatSub),"^",5)="" s BedStatSub=preBedStatSub

	s retStr=0
	s BedStatusId=$o(^PAC("BSTAT",0,"Code","U",""))
	s UnavailableReason=$$ALPHAUP^SSUTIL4(UnavailableReason)
	s UnavailableReasonId=$O(^PAC("RNAV",0,"Desc",UnavailableReason,"")) //PAC_BedReasonNotAvail 
	i STATRowId="" d
	.i BedStatSub>0  d
	..s BedStatId=BedId_"||"_BedStatSub
	..&sql(update PAC_BedStatusChange (STAT_User_DR,STAT_DateTo,STAT_TimeTo,STAT_UpdateDate,STAT_UpdateTime)  
		Values (:userId,:StartDate,:StartTime,:curDate,:curTime) Where STAT_RowId=:BedStatId)
	..i SQLCODE  s retStr="更新占床信息出错!" q
	.&sql(insert into PAC_BedStatusChange (STAT_ParRef,STAT_Date,STAT_Time,STAT_DateTo,STAT_TimeTo,STAT_Status_DR,STAT_User_DR,STAT_ReasonNotAvail_DR,STAT_UpdateDate,STAT_UpdateTime)  
		Values (:BedId,:StartDate,:StartTime,:EndDate,:EndTime,:BedStatusId,:userId,:UnavailableReasonId,:curDate,:curTime))
	.i SQLCODE  s retStr="插入占床信息出错!" q
	.s BedStatId=$g(%ROWID)
	.q:EpisodeID=""
	.&sql(update DHC_PAC_BedStatusChange (STAT_PAADM_Dr,STAT_CTLOC_Dr)  
		Values (:EpisodeID,:CtlocId) Where STAT_RowId=:BedStatId)
	.i SQLCODE  s retStr="更新占床患者信息出错!" q
	
	i STATRowId'="" d
	.&sql(update PAC_BedStatusChange (STAT_Date,STAT_Time,STAT_Status_DR,STAT_User_DR,STAT_DateTo,STAT_TimeTo,STAT_ReasonNotAvail_DR,STAT_UpdateDate,STAT_UpdateTime)  
		Values (:StartDate,:StartTime,:BedStatusId,:userId,:EndDate,:EndTime,:UnavailableReasonId,:curDate,:curTime) Where STAT_RowId=:STATRowId)
	.i SQLCODE  s retStr="取消占床信息出错!" q
	.q:EpisodeID=""
	.&sql(update DHC_PAC_BedStatusChange (STAT_PAADM_Dr,STAT_CTLOC_Dr)  
		Values (:EpisodeID,:CtlocId) Where STAT_RowId=:STATRowId)
	.i SQLCODE  s retStr="更新占床患者信息出错!" q
	q retStr
}

/// 获取包床患者信息
ClassMethod GetPatBedInfo(STATRowId = "") As %String
{
	;w ##class(web.DHCADTTransaction).GetPatBedInfo("10||11||4")
	q:STATRowId="" ""
	s STATWardId=$P(STATRowId,"||",1),STATBedChildsub=$P(STATRowId,"||",2),STATChildsub=$P(STATRowId,"||",3)
	q:(STATWardId="")!(STATBedChildsub="")!(STATChildsub="") ""
	s AdmId=$p($G(^PAWARDA(STATWardId,"BED",STATBedChildsub,"STAT",STATChildsub,"DHC")),"^",1)
	q:AdmId="" ""
	s papmiId=$p($g(^PAADM(AdmId)),"^",1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s bedSub=$p($g(^PAADM(AdmId)),"^",73)
	q:bedSub="" ""
	s curWardId=$P(bedSub,"||",1)
	s curbedSub=$P(bedSub,"||",2)
	q:(curWardId="")!(curbedSub="") ""
	s bedCode=$p($g(^PAWARD(curWardId,"BED",curbedSub)),"^",1)
    q:bedCode="" ""
	q patName_"^"_regNo_"^"_bedCode_"^"_AdmId
}

/// 通病人就诊ID找包床信息
/// 查询就诊病区内是否有包床,有返回包床ID,否则返回空
ClassMethod GetPatBedByAdm(EpisodeID = "", TransLocId = "", TransWardDescOrId = "") As %String
{
	;w ##class(web.DHCADTTransaction).GetPatBedByAdm("16874","","7")
	q:EpisodeID="" ""
	q:TransWardDescOrId="" ""
	s AdmLoc=$p($g(^PAADM(EpisodeID)),"^",4)
	s AdmWard=$p($g(^PAADM(EpisodeID)),"^",70)
	q:AdmWard="" ""
	s TransWard=""
	i TransWardDescOrId'="" d
	    .i TransWardDescOrId=+TransWardDescOrId s TransWard=TransWardDescOrId q
	    .s TransWardDesc=$$ALPHAUP^SSUTIL4(TransWardDescOrId)
	    .s TransWard=$o(^PAWARD(0,"WARD_Desc",TransWardDesc,""))
	q:TransWard=AdmWard ""
	s ret=..IfPatOccupyBed(EpisodeID)
	i ret=0 q ""
	e  q ret
}

/// 判断病人是否有包床未退
ClassMethod IfPatOccupyBed(EpisodeID = "") As %String
{
	;w ##class(web.DHCADTTransaction).IfPatOccupyBed("16874")
	q:EpisodeID="" 0
	s AdmWard=$p($g(^PAADM(EpisodeID)),"^",70)
	q:AdmWard="" 0
	
	s ret=0
	s BedSub="" f  s BedSub=$O(^PAWARDA(0,"SADM",EpisodeID,AdmWard,BedSub),-1) q:BedSub=""  d
	.s StatSub="" f  s StatSub=$O(^PAWARDA(0,"SADM",EpisodeID,AdmWard,BedSub,StatSub),-1) q:StatSub=""  d
	..s StatDateTo=$p($g(^PAWARDA(AdmWard,"BED",BedSub,"STAT",StatSub)),"^",5)
	..s StatTimeTo=$p($g(^PAWARDA(AdmWard,"BED",BedSub,"STAT",StatSub)),"^",6)
	..q:(StatDateTo'="")!(StatTimeTo'="")
	..s StatusId=$p($g(^PAWARDA(AdmWard,"BED",BedSub,"STAT",StatSub)),"^",7)
	..i StatusId'="" s StatusDesc=$p(^PAC("RNAV",StatusId),"^",2)
	..e  s StatusDesc=""
	..q:StatusDesc'["包床"
	..s ret=1
	q ret
}

/// 删除包床时,扩展表数据一并删除
/// PAC_BedStatusChangeDHC_PAC_BedStatusChange
ClassMethod DeletePatBedStChange(STATRowId = "") As %String
{
	;w ##class(web.DHCADTTransaction).DeletePatBedStChange()	
	q:STATRowId="" ""
	q:$L(STATRowId,"||")<3 ""
	&sql(delete from DHC_PAC_BedStatusChange Where STAT_RowId=:STATRowId)
	q:SQLCODE "删除包床信息错误!"
}

/// 转科时发送转科信息给平台
ClassMethod ISendTransInfo(EpisodeID As %String, TransFromId As %String, TransToDesc As %String) As %String
{
   s res=0
   q:(EpisodeID="")||(TransFromId="")||(TransToDesc="") res
   i TransToDesc'="" d
   .s TransToDesc1=$$ALPHAUP^SSUTIL4(TransToDesc)
   .s TransToId=$o(^PAWARD(0,"WARD_Desc",TransToDesc1,""))
   q:(TransToId="") res
   s TransToCode=$p($g(^PAWARD(TransToId)),"^")
   s TransFromCode=$p($g(^PAWARD(TransFromId)),"^")
   s TransFromDesc=$p($g(^PAWARD(TransFromId)),"^",2)
   s curDat=$zd($p($h,","),3),curTim=$zt($p($h,",",2))
   s curDatTim=curDat_" "_curTim
   s TransStr=EpisodeID_"^"_curDatTim_"^"_TransToCode_"^"_TransToDesc_"^"_TransFromCode_"^"_TransFromDesc
   s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDTRANSOUTDEPTINFO",TransStr)
   s rtnmes1=$p(rtn,"^")
   s rtnmes2=$p(rtn,"^",2)
   i rtnmes1'=0 s res=rtnmes2
   q res
}

/// 分床换床时发送床位信息给平台
ClassMethod ISendTransInBed(EpisodeID As %String, TransDate As %String, TransTime As %String, TransToBed As %String) As %String
{
   s res=0
   q:(EpisodeID="") res
   s admType=$p($G(^PAADM(EpisodeID)),"^",2)
   q:admType="E" 0
   i TransDate["/" d
   .s TransDate=$ZDH(TransDate,4)
   .s TransDate=$ZD(TransDate,3)
   
   i (TransDate="") d
   .s curDat=$zd($p($h,","),3)
   .s TransDate=curDat
   
   i (TransTime="") d
   .s curTim=$zt($p($h,",",2))
   .s TransTime=curTim
   
   s TransDateTime=TransDate_" "_TransTime
   s TransFromBed=""
   s bedId=$p($g(^PAADM(EpisodeID)),"^",73)
   s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
   i bedId'="" d
   .s bedSub=$p(bedId,"||",2)
   .i bedSub'="" s TransFromBed=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
   
   s TransStr=EpisodeID_"^"_TransDateTime_"^"_TransFromBed_"^"_TransToBed
   s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDTRANSOUTBEDINFO",TransStr)
   s rtnmes1=$p(rtn,"^")
   s rtnmes2=$p(rtn,"^",2)
   i rtnmes1'=0 s res=rtnmes2
   q res
}

}
