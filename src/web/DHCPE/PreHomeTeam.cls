/// Description: 团体主场关联分组
/// FileName: web.DHCPE.PreHomeTeam.cls
/// Creator: wangguoying
/// Date: 2022-12-20
Class web.DHCPE.PreHomeTeam Extends %RegisteredObject
{

/// Description：查询关联分组
/// Creator： wangguoying
/// CreateDate： 2022-12-20
/// Debug： d ##class(%ResultSet).RunQuery("web.DHCPE.PreHomeTeam","QueryHomeTeam","226||4126")
Query QueryHomeTeam(ParRef As %String) As websys.Query(ROWSPEC = "TID,TTeamID,TTeamDesc,TNumMale,TNumFemale,TTag") [ SqlProc ]
{
}

ClassMethod QueryHomeTeamExecute(ByRef qHandle As %Binary, ParRef As %String) As %Status
{
   Set repid=$INCREMENT(^CacheTemp)
   Set ind=1
   If (ParRef = "")
   {
      Set qHandle=$LISTBUILD(0,repid,0)
      Quit $$$OK
   }
   Set homeId = + ParRef
   Set timeSub = $PIECE(ParRef,"||",2)
   Set teamId = ""
   For {
        Set teamId = $ORDER(^User.DHCPEHomeTimeTeamI("IndOfParTeam",homeId,timeSub,teamId))
        Quit:teamId=""
        Set pgadm = $LISTGET(^User.DHCPEPreHomeInfoD(homeId),2)
        Continue:+teamId'=pgadm
        Set teamDesc = $PIECE(^DHCPEPreGADM(pgadm,"Team",$PIECE(teamId,"||",2)),"^",1)
        Set teamSub = 0
        For {
            Set teamSub = $ORDER(^User.DHCPEHomeTimeTeamI("IndOfParTeam",homeId,timeSub,teamId,teamSub))
            Quit:teamSub=""
            Set maleNum = $LISTGET(^User.DHCPEPreHomeInfoD(homeId,"PGTimeInfo",timeSub,"PHTTeam",teamSub),3)
            Set femaleNum = $LISTGET(^User.DHCPEPreHomeInfoD(homeId,"PGTimeInfo",timeSub,"PHTTeam",teamSub),4)
            Set tag = $LISTGET(^User.DHCPEPreHomeInfoD(homeId,"PGTimeInfo",timeSub,"PHTTeam",teamSub),5)
            Do OutputRowData
        } 
   }    
   Set qHandle=$LISTBUILD(0,repid,0)
   Quit $$$OK
OutputRowData
   Set Data=$LISTBUILD(ParRef_"||"_teamSub,teamId,teamDesc,maleNum,femaleNum,tag)
   Set ^CacheTemp(repid,ind)=Data
   Set ind=ind+1
   Quit
}

/// Description：更新主场时段
/// Input：
///               ParRef：DHC_PE_PreHomeInfo
///               ID: DHC_PE_HomeTimeInfo
///               Instring：开始时间^结束时间^男性数量^女性数量
///               UserID： 操作用户
///               ExtStr：PGADM^日期^主场类型
/// Return：      ID  非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2022-12-20
/// Debug: w ##class(web.DHCPE.PreHomeTeam).UpdateTime("217","","10:00:01^10:30:00^1^1","11849")
ClassMethod UpdateTime(ParRef, ID, Instring, UserID, ExtStr = "")
{
    Set ^tmpwgy("UpdateTime") = $LISTBUILD(ParRef, ID, Instring, UserID)
    Set $ZTRAP="UpdateTimeErr"
    Tstart
    If ParRef = ""  //先创建一个0数量的父记录
    {
        Set ParRef = ..CreateHomeRecord($PIECE(ExtStr,"^",1),$PIECE(ExtStr,"^",2),$PIECE(ExtStr,"^",3),"0-0",UserID)
        If +ParRef<0   Trollback  Quit ParRef
    }
    Set startTime = $PIECE(Instring,"^",1)
    Set endTime = $PIECE(Instring,"^",2)
    Set maleNum = $PIECE(Instring,"^",3)
    Set femaleNum = $PIECE(Instring,"^",4)
    Set logicalStart = ##class(websys.Conversions).TimeHtmlToLogical(startTime)
    Set logicalEnd = ##class(websys.Conversions).TimeHtmlToLogical(endTime)
    If ..IsExistTemaplateTime(ParRef,ID,logicalStart,logicalEnd)=1  Trollback  Quit "-1^时间段与现有时间段重叠，不允许更新！"
    Set oldMaleNum = 0 ,oldFemaleNum = 0
    If ID '= ""
    {
        Set preNum = ..GetPreNum(ID)
        If +preNum>maleNum  Trollback  Quit "-1^男性数量【"_maleNum_"】不能小于预约数量【"_+preNum_"】"
        If +$PIECE(preNum,"-",2)>femaleNum   Trollback  Quit "-1^女性数量【"_femaleNum_"】不能小于预约数量【"_+$PIECE(preNum,"-",2)_"】"
        Set oldMaleNum = $LISTGET(^User.DHCPEPreHomeInfoD(+ID,"PGTimeInfo",$PIECE(ID,"||",2)),4)
        Set oldFemaleNum = $LISTGET(^User.DHCPEPreHomeInfoD(+ID,"PGTimeInfo",$PIECE(ID,"||",2)),5)
    }
    Set parRefObj = ##class(User.DHCPEPreHomeInfo).%OpenId(ParRef)
    Set parRefObj.PGADMHomeMaleNum = parRefObj.PGADMHomeMaleNum - oldMaleNum + maleNum
    Set parRefObj.PGADMHomeFemaleNum = parRefObj.PGADMHomeFemaleNum - oldFemaleNum + femaleNum
    Set sc = parRefObj.%Save()
    If $$$ISERR(sc)  Trollback  Quit "-1^"_$SYSTEM.Status.GetErrorText(sc)
    Do parRefObj.%Close()
    Set obj = $CASE(ID '= "" ,1:##class(User.DHCPEPreHomeTimeInfo).%OpenId(ID),:##class(User.DHCPEPreHomeTimeInfo).%New())
    Do obj.PHTParRefSetObjectId(ParRef)
    Set obj.PHStartTime = logicalStart
    Set obj.PHEndTime = logicalEnd
    Set obj.PHNumMale = maleNum
    Set obj.PHNumFemale = femaleNum
    Set sc = obj.%Save()
    If $$$ISERR(sc)  Trollback  Quit "-1^"_$SYSTEM.Status.GetErrorText(sc)
    Set:ID="" ID = obj.%Id()
    Do obj.%Close()
    Tcommit
    Quit ID
UpdateTimeErr
    Set $ZTRAP=""
    Trollback
    Quit "-100^"_$ZERROR
}

/// Description：创建主场记录
/// Input：
///               PGADM：DHC_PE_PreGADM
///               DateStr: 日期
///               HomeType：G:团体主场  C：合同主场
///               NumStr：男-女
///               UserID： 操作用户
/// Return：      ID  非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2022-12-21
/// Debug: w ##class(web.DHCPE.PreHomeTeam).CreateHomeRecord("217","","10:00:01^10:30:00^1^1","11849")
ClassMethod CreateHomeRecord(PGADM, DateStr, HomeType, NumStr, UserID)
{
    Set LogicalDate = ##class(websys.Conversions).DateHtmlToLogical(DateStr)
    Quit:$DATA(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",PGADM,LogicalDate)) $ORDER(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",PGADM,LogicalDate,""),-1)
    Set obj = ##class(User.DHCPEPreHomeInfo).%New()
    Set obj.PGADMDr = PGADM
    Set obj.PGADMHomeMaleNum = $PIECE(NumStr,"-",1)
    Set obj.PGADMHomeFemaleNum = $PIECE(NumStr,"-",2)
    Do obj.PGADMUpdateUserDRSetObjectId(UserID)
    Set obj.PGADMUpdateDate = +$HOROLOG
    Set obj.PGADMUpdateTime = $PIECE($HOROLOG,",",2)
    Set obj.PGADMHomeDate = LogicalDate
    Set obj.PGADMType = HomeType
    Set sc = obj.%Save()
    If $$$ISERR(sc) Quit "-1^"_$SYSTEM.Status.GetErrorText(sc)
    Set id = obj.%Id()
    Do obj.%Close()
    Quit id
}

/// 判断时间段是否存在  0：不存在  1：存在
ClassMethod IsExistTemaplateTime(ParRef, ID, StartTime, EndTime)
{
    Set ret = 0
    Set start = 0
    For  Set start = $ORDER(^User.DHCPEPreHomeTimeInfoI("IndOfSTime",ParRef,start))  Quit:(start="")||(ret=1)  Do
    .Set sub = ""
    .For  Set sub = $ORDER(^User.DHCPEPreHomeTimeInfoI("IndOfSTime",ParRef,start,sub))  Quit:(sub="")||(ret=1)  Do
    ..Quit:ID=(ParRef_"||"_sub)
    ..Set endTime = $LISTGET(^User.DHCPEPreHomeInfoD(ParRef,"PGTimeInfo",sub),3)
    ..If (StartTime>=start)&&(StartTime<=endTime)  Set ret = 1 Quit
     ..If (EndTime>=start)&&(EndTime<=endTime)  Set ret = 1 Quit
    Quit ret
}

/// Description：查询主场时段预约数量
/// Input：
///               HomeTimeID: DHC_PE_HomeTimeInfo
///               teamId： 分组ID
///               tag：标志位 按标志位查询时，teamID应为空
///               ExtraTeamID：按标志位查询时，额外的teamID，主要用于分组原标志位为空，新增一个标志位时，预约数量判断需要增加当前分组的预约数  
/// Return：      男性预约数量-女性预约数量
/// Creator：     wangguoying
/// CreateDate：  2022-12-20
/// Debug: w ##class(web.DHCPE.PreHomeTeam).UpdateTime()
ClassMethod GetPreNum(HomeTimeID, teamId = "", tag = "", ExtraTeamID = "")
{
    Set maleNum = 0,femaleNum = 0
    Set date = $LISTGET(^User.DHCPEPreHomeInfoD(+HomeTimeID),10)
    Set netId = ""
    For{
        Set netId = $ORDER(^User.DHCPENetPreRecordI("PreDateIndex",date))
        Quit:netId=""
        Set stat = $LISTGET(^User.DHCPENetPreRecordD(netId),7)
        Continue:(stat=2)||(stat=3)||(stat=6)
        Continue:$LISTGET(^User.DHCPENetPreRecordD(netId),23)'=HomeTimeID
        Set piadm = $LISTGET(^User.DHCPENetPreRecordD(netId),13)
        Continue:piadm=""
        Set preGTeam = $PIECE(^DHCPEPreIADM(piadm),"^",3)
        Continue:preGTeam=""
        Continue:(teamId'="")&&(preGTeam'=teamId)
        If (tag'="")&&(preGTeam'=ExtraTeamID)
        {
            Set homeTeamSub = $ORDER(^User.DHCPEHomeTimeTeamI("IndOfParTeam",+HomeTimeID,$PIECE(HomeTimeID,"||",2),preGTeam,0))
            Continue:homeTeamSub=""
            Set curTag = $LISTGET(^User.DHCPEPreHomeInfoD(+HomeTimeID,"PGTimeInfo",$PIECE(HomeTimeID,"||",2),"PHTTeam",homeTeamSub),5)
            Continue:curTag'=tag
        } 
        If ($LISTGET(^User.DHCPENetPreRecordD(netId),4)=1) Set maleNum = maleNum + 1
        Else  Set femaleNum = femaleNum + 1
    }
    Quit maleNum_"_"_femaleNum
}

ClassMethod DeleteTime(ID)
{
    Set preNum = ..GetPreNum(ID)
    Quit:(+preNum>0)||(+$PIECE(preNum,"||",2)>0) "-1^存在预约记录不允许删除！"
    Set $ZTRAP = "DeleteTimeErr"
    Tstart
    Set oldMaleNum = $LISTGET(^User.DHCPEPreHomeInfoD(+ID,"PGTimeInfo",$PIECE(ID,"||",2)),4)
    Set oldFemaleNum = $LISTGET(^User.DHCPEPreHomeInfoD(+ID,"PGTimeInfo",$PIECE(ID,"||",2)),5)
    Set parRefObj = ##class(User.DHCPEPreHomeInfo).%OpenId(+ID)
    Set parRefObj.PGADMHomeMaleNum = parRefObj.PGADMHomeMaleNum - oldMaleNum 
    Set parRefObj.PGADMHomeFemaleNum = parRefObj.PGADMHomeFemaleNum - oldFemaleNum
    Set sc = parRefObj.%Save()
    If $$$ISERR(sc)  Trollback  Quit "-1^"_$SYSTEM.Status.GetErrorText(sc)
    Do parRefObj.%Close()
    Set sc = ##class(User.DHCPEPreHomeTimeInfo).%DeleteId(ID)
    If $$$ISERR(sc)  Trollback   Quit "-1^"_$SYSTEM.Status.GetErrorText(sc)
    Tcommit
    Quit 0
DeleteTimeErr
    Set $ZTRAP=""
    Trollback
    Quit "-100^"_$ZERROR
}

/// 查询时段限额数量 
/// Tag：不为空时，查询该标志位的限额数量
/// ExcludeID：排除的分组限额ID
ClassMethod GetManagerNum(TimeID, Tag = "", ExcludeID = "")
{
    Set maleNum = 0,femaleNum=0
    Set teamSub = 0
    For {
        Set teamSub = $ORDER(^User.DHCPEPreHomeInfoD(+TimeID,"PGTimeInfo",$PIECE(TimeID,"||",2),"PHTTeam",teamSub))
        Quit:teamSub=""
        Continue:(ExcludeID'="")&&((TimeID_"||"_teamSub)=ExcludeID)
        Set curTag = $LISTGET(^User.DHCPEPreHomeInfoD(+TimeID,"PGTimeInfo",$PIECE(TimeID,"||",2),"PHTTeam",teamSub),5)
        Continue:(Tag'="")&&(curTag'=Tag)
        Set maleNum = maleNum + $LISTGET(^User.DHCPEPreHomeInfoD(+TimeID,"PGTimeInfo",$PIECE(TimeID,"||",2),"PHTTeam",teamSub),3)
        Set femaleNum = femaleNum + $LISTGET(^User.DHCPEPreHomeInfoD(+TimeID,"PGTimeInfo",$PIECE(TimeID,"||",2),"PHTTeam",teamSub),4)
    }
    Quit maleNum_"-"_femaleNum
}

/// Description：更新时段分组
/// Input：
///               ParRef：DHC_PE_HomeTimeInfo
///               ID: DHC_PE_HomeTimeTeam
///               Instring：分组ID^男性数量^女性数量^标注位
///               UserID： 操作用户
/// Return：      ID  非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2022-12-20
/// Debug: w ##class(web.DHCPE.PreHomeTeam).UpdateTeam("217","","10:00:01^10:30:00^1^1","11849")
ClassMethod UpdateTeam(ParRef, ID, Instring, UserID)
{
    Quit:ParRef="" "-1^父记录不能为空！"
    Set teamId = $PIECE(Instring,"^",1)
    Set maleNum = $PIECE(Instring,"^",2)
    Set femaleNum = $PIECE(Instring,"^",3)
    Set tag = $PIECE(Instring,"^",4)
    Set teamDesc = $PIECE(^DHCPEPreGADM(+teamId,"Team",$PIECE(teamId,"||",2)),"^",1)
    Quit:(ID="")&&($DATA(^User.DHCPEHomeTimeTeamI("IndOfParTeam",+ParRef,$PIECE(ParRef,"||",2),teamId))) "-1^该分组已存在！"
    Set mTotalNum = ..GetManagerNum(ParRef,"",ID)
    Set parRefMaleNum = $LISTGET(^User.DHCPEPreHomeInfoD(+ParRef,"PGTimeInfo",$PIECE(ParRef,"||",2)),4)
    Set parRefFemaleNum = $LISTGET(^User.DHCPEPreHomeInfoD(+ParRef,"PGTimeInfo",$PIECE(ParRef,"||",2)),5)
    If parRefMaleNum<(maleNum+$PIECE(mTotalNum,"-",1))  Quit "-1^分组男性总数量【"_(maleNum+$PIECE(mTotalNum,"-",1))_"】不能大于时段数量【"_parRefMaleNum_"】"
    If parRefFemaleNum<(femaleNum+$PIECE(mTotalNum,"-",2)) Quit "-1^分组女性总数量【"_(femaleNum+$PIECE(mTotalNum,"-",2))_"】不能大于时段数量【"_parRefFemaleNum_"】"
    If ID'=""
    {
        Set oldTag = $LISTGET(^User.DHCPEPreHomeInfoD(+ID,"PGTimeInfo",$PIECE(ID,"||",2),"PHTTeam",$PIECE(ID,"||",3)),5)
        If oldTag'=""
        {
            Set oldPreNum = ..GetPreNum(ParRef,"",oldTag)
            Quit:((+oldPreNum>0)||(+$PIECE(oldPreNum,"||",2)>0))&&(tag'=oldTag) "-1^原标志位已存在预约记录，不允许修改"
        }
    }
    If tag  = ""
    {
        Set preNum =  ..GetPreNum(ParRef,teamId,"")
        If +preNum>maleNum  Quit "-1^分组【"_teamDesc_"】男性数量【"_maleNum_"】不能小于预约数量【"_+preNum_"】"
        If +$PIECE(preNum,"-",2)>femaleNum Quit "-1^分组【"_teamDesc_"】女性数量【"_femaleNum_"】不能小于预约数量【"_+$PIECE(preNum,"-",2)_"】"   
    }Else{
        Set preNum =  ..GetPreNum(ParRef,"",tag,teamId)
        Set mNum = ..GetManagerNum(ParRef,tag,ID)
        If +preNum>(maleNum+$PIECE(mNum,"-",1))  Quit "-1^分组【"_teamDesc_"】男性数量【"_(maleNum+$PIECE(mNum,"-",1))_"】不能小于预约数量【"_+preNum_"】"
        If +$PIECE(preNum,"-",2)>(femaleNum+$PIECE(mNum,"-",2)) Quit "-1^分组【"_teamDesc_"】女性数量【"_(femaleNum+$PIECE(mNum,"-",2))_"】不能小于预约数量【"_+$PIECE(preNum,"-",2)_"】"
    }
    Set obj = $CASE(ID="",1:##class(User.DHCPEHomeTimeTeam).%New(),:##class(User.DHCPEHomeTimeTeam).%OpenId(ID))
    Do obj.HTTParRefSetObjectId(ParRef)
    Do obj.HTTPTeamDRSetObjectId(teamId)
    Set obj.HTTNumMale = maleNum
    Set obj.HTTNumFemale = femaleNum
    Set obj.HTTTag = tag
    Set sc = obj.%Save()
    If $$$ISERR(sc) Quit "-1^"_$SYSTEM.Status.GetErrorText(sc)
    Set id = obj.%Id()
    Do obj.%Close()
    Quit id
}

ClassMethod DeleteTeam(ID)
{
    Set teamId= $LISTGET(^User.DHCPEPreHomeInfoD(+ID,"PGTimeInfo",$PIECE(ID,"||",2),"PHTTeam",$PIECE(ID,"||",3)),2)
    Set oldTag = $LISTGET(^User.DHCPEPreHomeInfoD(+ID,"PGTimeInfo",$PIECE(ID,"||",2),"PHTTeam",$PIECE(ID,"||",3)),5)
    Set preNum = $CASE(oldTag="",1:..GetPreNum($PIECE(ID,"||",1,2),teamId),:..GetPreNum($PIECE(ID,"||",1,2),"",oldTag))
    Quit:(+preNum>0)||(+$PIECE(preNum,"||",2)>0) "-1^存在预约记录不允许删除！"  
    Set sc = ##class(User.DHCPEHomeTimeTeam).%DeleteId(ID)
    If $$$ISERR(sc)  Trollback   Quit "-1^"_$SYSTEM.Status.GetErrorText(sc)
    Quit 0
}

/// Description: 获取号源池Event数组
/// Input:
/// 						BeginDate：开始日期
/// 						EndDate：结束日期
/// Return:  	  
/// Creator:	wangguoying
/// CreateDate:	2022-12-19
/// Debug: w ##class(web.DHCPE.PreHomeTeam).GetDocSourceEventArr(66346,66350)
ClassMethod GetDocSourceEventArr(BeginDate, EndDate, PGADM) As %DynamicArray
{
	Set arr = []
	For date = BeginDate:1:EndDate
	{
        Set id = ""
		For {
			Set id = $ORDER(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",PGADM,date,id))
			Quit:id=""
			Continue:$LISTGET(^User.DHCPEPreHomeInfoD(id),11)'="G"
			Set sub = ""
			For {
				Set sub = $ORDER(^User.DHCPEPreHomeInfoD(id,"PGTimeInfo",sub))
				Quit:sub=""
				Set startTime = $LISTGET(^User.DHCPEPreHomeInfoD(id,"PGTimeInfo",sub),2)
				Set endTime = $LISTGET(^User.DHCPEPreHomeInfoD(id,"PGTimeInfo",sub),3)
				Set maleNum = $LISTGET(^User.DHCPEPreHomeInfoD(id,"PGTimeInfo",sub),4)
				Set femaleNum = $LISTGET(^User.DHCPEPreHomeInfoD(id,"PGTimeInfo",sub),5)
                Set info = ""
                Set teamSub = 0
                For {
                    Set teamSub = $ORDER(^User.DHCPEPreHomeInfoD(id,"PGTimeInfo",sub,"PHTTeam",teamSub))
                    Quit:teamSub=""
                    Set curTag = $LISTGET(^User.DHCPEPreHomeInfoD(id,"PGTimeInfo",sub,"PHTTeam",teamSub),5)
                    Set teamId = $LISTGET(^User.DHCPEPreHomeInfoD(id,"PGTimeInfo",sub,"PHTTeam",teamSub),2)
                    Set teamDesc = $PIECE(^DHCPEPreGADM(+teamId,"Team",$PIECE(teamId,"||",2)),"^",1)
                    Set maleTeamNum = $LISTGET(^User.DHCPEPreHomeInfoD(id,"PGTimeInfo",sub,"PHTTeam",teamSub),3)
                    Set femaleTeamNum = $LISTGET(^User.DHCPEPreHomeInfoD(id,"PGTimeInfo",sub,"PHTTeam",teamSub),4)
                    Set tag = $LISTGET(^User.DHCPEPreHomeInfoD(id,"PGTimeInfo",sub,"PHTTeam",teamSub),5)
                    Set:tag'="" tag = "(<label style='font-weight:600;color:red;'>"_tag_"</label>)"
                    Set tmpInfo = teamDesc_tag_"："_maleTeamNum_"-"_femaleTeamNum
                    If info'=""  Set info = info_"</br>"_tmpInfo
                    e  Set info = tmpInfo
                }
				Set obj = {}
                Set title = $ZTIME(startTime)_"-"_$ZTIME(endTime)_"<br>●男："_maleNum_"<br>●女："_femaleNum
                Set obj.id = id_"||"_sub
                Set obj.title = title
                Set obj.type = "Time"
                Set obj.start = $ZDATE(date,3)_" "_$ZTIME(startTime)
                Set obj.end = $ZDATE(date,3)_" "_$ZTIME(endTime)
				Set obj.detail = info 
                Do arr.%Push(obj)
			}
		}
	}
	Quit arr
}

/// Description：按日复制
/// Input：
///               PGADM：DHC_PE_PreGADM 
///               SourceDate：源日期
///               TargerDate：目标日期
///               CopyTeam：是否复制分组
///               UserID：操作用户
/// Return：       0：成功  非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2022-12-21
/// Debug: w ##class(web.DHCPE.PreHomeTeam).CopyByDate(340,"2022-12-31","2023-01-01","Y",1)
ClassMethod CopyByDate(PGADM, SourceDate, TargerDate, CopyTeam, UserID)
{
    Set sDate = ##class(websys.Conversions).DateHtmlToLogical(SourceDate)
    Set tDate = ##class(websys.Conversions).DateHtmlToLogical(TargerDate)
    Set sourceId = $ORDER(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",PGADM,sDate,""),-1)
    Quit:sourceId="" "-1^源日期【"_SourceDate_"】不存在主场记录"
    Quit:$DATA(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",PGADM,tDate)) "-1^目标日期【"_TargerDate_"】已存在主场记录"
    Set err = ""
    Set $ZTRAP="CopyDateErr"
    Tstart
    Set tId = ..CreateHomeRecord(PGADM,TargerDate,"G","0-0",UserID)
    If +tId<0 Trollback  Quit tId
    Set timeSub = 0
    For {
        Set timeSub = $ORDER(^User.DHCPEPreHomeInfoD(sourceId,"PGTimeInfo",timeSub))
        Quit:(timeSub="")||(err'="")
        Set startTime = $LISTGET(^User.DHCPEPreHomeInfoD(sourceId,"PGTimeInfo",timeSub),2)
        Set endTime = $LISTGET(^User.DHCPEPreHomeInfoD(sourceId,"PGTimeInfo",timeSub),3)
        Set maleNum = $LISTGET(^User.DHCPEPreHomeInfoD(sourceId,"PGTimeInfo",timeSub),4)
        Set femaleNum = $LISTGET(^User.DHCPEPreHomeInfoD(sourceId,"PGTimeInfo",timeSub),5)
        Set inString = startTime _"^"_ endTime _"^"_ maleNum _"^"_ femaleNum
        Set timeId = ..UpdateTime(tId,"",inString,UserID)
        If +timeId<0  Set err = timeId  Quit
        If CopyTeam = "Y"
        {
            Set teamSub = 0
            For {
                Set teamSub = $ORDER(^User.DHCPEPreHomeInfoD(sourceId,"PGTimeInfo",timeSub,"PHTTeam",teamSub))
                Quit:(teamSub="")||(err'="")
                Set teamId = $LISTGET(^User.DHCPEPreHomeInfoD(sourceId,"PGTimeInfo",timeSub,"PHTTeam",teamSub),2)
                Set maleTeamNum = $LISTGET(^User.DHCPEPreHomeInfoD(sourceId,"PGTimeInfo",timeSub,"PHTTeam",teamSub),3)
                Set femaleTeamNum = $LISTGET(^User.DHCPEPreHomeInfoD(sourceId,"PGTimeInfo",timeSub,"PHTTeam",teamSub),4)
                Set tag = $LISTGET(^User.DHCPEPreHomeInfoD(sourceId,"PGTimeInfo",timeSub,"PHTTeam",teamSub),5)
                Set ret = ..UpdateTeam(timeId,"",teamId _"^"_ maleTeamNum _"^"_ femaleTeamNum _"^"_ tag,UserID)
                If +ret<0  Set err = ret  Quit
            }
        }
    }
    If err'=""  Trollback  Quit err
    Tcommit
    Quit 0
CopyDateErr
    Set $ZTRAP=""
    Trollback
    Quit "-100^"_$ZERROR
}

/// Description:获取指定日期所在周的日期范围
/// Input:   
/// 				Date：2021-07-21
/// 				RtnType: HTML Logical
/// Return: 	周一到周天的指定格式
/// Creater:	wangguoying
/// CreateDate:	2021-07-21
/// Debug: w ##class(web.DHCPE.SourceManager).GetWeekDateRange("2021-07-21")
ClassMethod GetWeekDateRange(Date, RtnType = "HTML")
{
	If Date=""
 	{
	 	Set Date = $HOROLOG
 	}Else{
		Set Date = ##class(websys.Conversions).DateHtmlToLogical(Date)
 	}
	Set week =  $ZDATE(Date,10)
	Set:week=0 week=7
	Set week1 = Date-(week-1)
	Set week7 = Date+(7-week)
	Set ret = ""
	For date=week1:1:week7
	{
		If RtnType = "Logical"
		{
			Set:ret'="" ret = ret_"^"_date
			Set:ret="" ret = date
		}Else{
			Set:ret'="" ret = ret_"^"_$ZDATE(date,3)
			Set:ret="" ret = $ZDATE(date,3)
		}
	}
	Quit ret
}

/// Description：通过周复制
/// Input：
///               PGADM：DHC_PE_PreGADM 
///               SWeekDate：源日期周
///               TWeekDate：目标日期周
///               CopyTeam：是否复制分组
///               UserID：用户ID 
/// Return：       0：成功  非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2022-12-21
/// Debug: w ##class(web.DHCPE.PreHomeTeam).CopyByWeek("2022-08-25","2022-09-08","SKIP",11849)
ClassMethod CopyByWeek(PGADM, SWeekDate, TWeekDate, CopyTeam, UserID)
{
    Set sDateRange = ..GetWeekDateRange(SWeekDate,"HTML")
    Set tDateRange = ..GetWeekDateRange(TWeekDate,"HTML")
    Set err = ""
    Set $ZTRAP="CopyWeekErr"
    Tstart
    For i = 1:1:7
    {
        Quit:err'=""
        Continue:'$DATA(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",PGADM,##class(websys.Conversions).DateHtmlToLogical($PIECE(sDateRange,"^",i)))) //原日期排班为空时  跳过
        Continue:$DATA(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",PGADM,##class(websys.Conversions).DateHtmlToLogical($PIECE(tDateRange,"^",i)))) //目标日期排班不为空时  跳过
        Set ret = ..CopyByDate(PGADM, $PIECE(sDateRange,"^",i),$PIECE(tDateRange,"^",i),CopyTeam,UserID)
        If ret'=0  Set err = ret  Quit  
    }
    If err '="" Trollback  Quit err
    Tcommit
    Quit 0
CopyWeekErr
    Set $ZTRAP=""
    Trollback
    Quit "-100^"_$ZERROR
}

/// Description：查询分组可用限额
/// Input：
///               PreGTeam：DHC_PE_PreGTeam
///               DateStr：日期
///               TimeID：指定时间段 
/// Return：      总限额（男）-总限额(女)^已预约数量男-已预约数量女^可用余额男-可用预约女
/// Creator：     wangguoying
/// CreateDate：  2022-12-21
/// Debug: w ##class(web.DHCPE.PreHomeTeam).GetTeamAvailNum("2022-08-25","2022-09-08","SKIP",11849)
ClassMethod GetTeamAvailNum(PreGTeam, DateStr, TimeID = "")
{
    Set date = ##class(websys.Conversions).DateHtmlToLogical(DateStr)
    Set mId = $ORDER(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",+PreGTeam,date,""),-1)
    Quit:mId="" "0-0^0-0^0-0"
    Set totalMNum = 0,totalFNum=0, preMNum = 0,preFNum = 0
    Set timeSub = 0
    For {
        Set timeSub = $ORDER(^User.DHCPEPreHomeInfoD(mId,"PGTimeInfo",timeSub))
        Quit:timeSub=""
        Set detailId = mId_"||"_timeSub
        Continue:(TimeID'="")&&(detailId'=TimeID)
        Set timeMaleNum = $LISTGET(^User.DHCPEPreHomeInfoD(mId,"PGTimeInfo",timeSub),4)
        Set timeFemaleNum = $LISTGET(^User.DHCPEPreHomeInfoD(mId,"PGTimeInfo",timeSub),5)
        Set teamSub = $ORDER(^User.DHCPEHomeTimeTeamI("IndOfParTeam",mId,timeSub,PreGTeam,0))
        If teamSub = "" //该分组未关联 按时段总限额
        {
            Set totalMNum = totalMNum + timeMaleNum
            Set totalFNum = totalFNum + timeFemaleNum
            Set preInfo = ..GetPreNum(detailId,"","","")
            Set preMNum = +$PIECE(preInfo,"-",1)+preMNum
            Set preFNum = +$PIECE(preInfo,"-",2)+preFNum
        }Else{
            Set tag = $LISTGET(^User.DHCPEPreHomeInfoD(mId,"PGTimeInfo",timeSub,"PHTTeam",teamSub),5)
            If tag'="" //标志位不为空
            {
                Set managerInfo = ..GetManagerNum(detailId,tag,"")
                Set preInfo = ..GetPreNum(detailId,"",tag,"")
                Set totalMNum = +$PIECE(managerInfo,"-",1) + totalMNum 
                Set totalFNum = +$PIECE(managerInfo,"-",2) + totalFNum 
                Set preMNum = +$PIECE(preInfo,"-",1)+preMNum
                Set preFNum = +$PIECE(preInfo,"-",2)+preFNum
            }Else{
                Set totalMNum = totalMNum + $LISTGET(^User.DHCPEPreHomeInfoD(mId,"PGTimeInfo",timeSub,"PHTTeam",teamSub),3)
                Set totalFNum = totalFNum + $LISTGET(^User.DHCPEPreHomeInfoD(mId,"PGTimeInfo",timeSub,"PHTTeam",teamSub),4)
                Set preInfo = ..GetPreNum(detailId,PreGTeam,"","")
                Set preMNum = +$PIECE(preInfo,"-",1)+preMNum
                Set preFNum = +$PIECE(preInfo,"-",2)+preFNum
            } 
        }
    }
    Set availMNum = totalMNum - preMNum
    Set availFNum = totalFNum - preFNum
    Quit totalMNum_"-"_totalFNum _"^"_ preMNum_"-"_preFNum _"^"_availMNum_"-"_availFNum
}

/// Description：查询主场一段日期内排班
/// Input：
/// Return：      
/// Creator：     wangguoying
/// CreateDate：  2022-12-21
/// Debug: w ##class(web.DHCPE.PreHomeTeam).QueryHomeAvailRegCount()
ClassMethod QueryHomeAvailRegCount(params As %String = "") As %String
{
 	Set params=$TRANSLATE(params,$CHAR(0))
	Quit:params="" "-1^参数不能为空"
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenString(params)
	If $$$ISERR(sc) Quit "-2^读取参数错误:"_$SYSTEM.Status.GetErrorText(sc)
	Do reader.Correlate("Request","HS.Temp.ExaminationRegRequest")
	If reader.Next(.request,.sc){
		Set startDate=$TRANSLATE(request.startExamDate,$CHAR(0))
		Set endDate=$TRANSLATE(request.endExamDate,$CHAR(0))
		Set preIADM =$TRANSLATE(request.preIADM,$CHAR(0)) 
	}Else{
		Quit "-3^解析参数错误："_$SYSTEM.Status.GetErrorText(sc)
	}
	Quit:(startDate="")||(endDate="")||(preIADM="") "-4^参数不能为空"
	Set retStr = ""
    Set pibi = $PIECE(^DHCPEPreIADM(preIADM),"^",1)
    Set sexId = $PIECE(^DHCPEPreIBI(pibi),"^",3)
    Set preTeam = $PIECE(^DHCPEPreIADM(preIADM),"^",3)
    Set locId = $PIECE(^DHCPEPreIADM(preIADM),"^",26)
    Set locDesc=$PIECE(^CTLOC(locId),"^",2)
	For date=startDate:1:endDate  Do
    .Set htmlDate = ##class(websys.Conversions).DateLogicalToHtml(date)
    .Set managerInfo = ..GetTeamAvailNum(preTeam,htmlDate,"")
    .Set mInfo = $PIECE(managerInfo,"^",1)
    .Set preInfo = $PIECE(managerInfo,"^",2)
    .Set totalCount = $PIECE(mInfo,"-",sexId)
    .Set totalRegCount = $PIECE(preInfo,"-",sexId)
	.Set myObj=##class(HS.Temp.ExamAvailDate).%New()
	.Set myObj.examDate=$ZDATE(date,3)
	.Set myObj.examLocId=locId
	.Set myObj.examLocDesc=$GET(locDesc)
	.Set availCount=totalCount-totalRegCount
	.Set:availCount<0 availCount=0
	.If totalCount=0  Do
	..Set myObj.status="不可约"
	.e  Do
	..If availCount=0  Do
	...Set myObj.status="已约满"
	..e  Do
	...Set myObj.status="可预约"
	.Set advanceRegDate=0 //提前预约天数
	.Set:$GET(^DHCPESetting("DHCPE","AdvRegDate",locId)) advanceRegDate=^DHCPESetting("DHCPE","AdvRegDate",locId)
	.If date<=((+$HOROLOG)+advanceRegDate)  Do
	.Set availCount=0  
	.Set myObj.status = "已过期"
	.If myObj.status = "可预约" Set RegFlag = "true"
	.Set myObj.availRegCount = availCount
	.Set myObj.totalCount = totalCount
	.Set myObj.regCount = totalRegCount
	.Set myObj.strID = $ORDER(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",+preTeam,date,""),-1)
	.Set myObj.datePmType = "H"
	.Set sc=myObj.XMLExportToString(.XML,"ExamAvailDate")
	.If '$$$ISERR(sc)  Do
	..Set retStr=retStr_XML
	Quit retStr
}

/// Description：查询主场某个日期内时段排班
/// Input：
/// Return：      
/// Creator：     wangguoying
/// CreateDate：  2022-12-21
/// Debug: w ##class(web.DHCPE.PreHomeTeam).QueryHomeAvailRegCount()
ClassMethod QueryAvailRegTimeCount(params As %String = "") As %String
{
 	Set params=$TRANSLATE(params,$CHAR(0))
	Quit:params="" "-1^参数不能为空"
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenString(params)
	If $$$ISERR(sc) Quit "-2^读取参数错误:"_$SYSTEM.Status.GetErrorText(sc)
	Do reader.Correlate("Request","HS.Temp.ExaminationRegRequest")
	If reader.Next(.request,.sc){
        Set date=$TRANSLATE(request.date,$CHAR(0))
		Set strID=$TRANSLATE(request.strID,$CHAR(0))
		Set preIADM =$TRANSLATE(request.preIADM,$CHAR(0)) 
	}Else{
		Quit "-3^解析参数错误："_$SYSTEM.Status.GetErrorText(sc)
	}
	Quit:(date="")||(strID="")||(preIADM="") "-5^参数不能为空"
	Set retStr=""
    Set date = $ZDATEH(date,3)
    Set htmlDate = ##class(websys.Conversions).DateLogicalToHtml(date)
    Set pibi = $PIECE(^DHCPEPreIADM(preIADM),"^",1)
    Set sexId = $PIECE(^DHCPEPreIBI(pibi),"^",3)
    Set sexDesc = $PIECE(^CT("SEX",sexId),"^",2)
    Set preTeam = $PIECE(^DHCPEPreIADM(preIADM),"^",3)
    Set locId = $PIECE(^DHCPEPreIADM(preIADM),"^",26)
    Set locDesc=$PIECE(^CTLOC(locId),"^",2)
    Set timeSub = 0
    For {
        Set timeSub = $ORDER(^User.DHCPEPreHomeInfoD(strID,"PGTimeInfo",timeSub))
        Quit:timeSub=""
        Set detailId = strID_"||"_timeSub
        Set startTime = $LISTGET(^User.DHCPEPreHomeInfoD(strID,"PGTimeInfo",timeSub),2)
        Set endTime = $LISTGET(^User.DHCPEPreHomeInfoD(strID,"PGTimeInfo",timeSub),3)
        Set managerInfo = ..GetTeamAvailNum(preTeam,htmlDate,detailId)
        Set mInfo = $PIECE(managerInfo,"^",1)
        Set preInfo = $PIECE(managerInfo,"^",2)
        Set totalCount = $PIECE(mInfo,"-",sexId)
        Set regCount = $PIECE(preInfo,"-",sexId)
        Set myObj=##class(HS.Temp.ExamAvailDate).%New()
	    Set myObj.startTime = $ZTIME(startTime,2)
	    Set myObj.endTime = $ZTIME(endTime,2)
	    Set myObj.availRegCount=totalCount-regCount
	    Set myObj.detailID=detailId
	    Set myObj.datePmType="H"
	    Set myObj.sexDesc = sexDesc
	    Set sc=myObj.XMLExportToString(.XML,"ExamAvailTime")
	    If '$$$ISERR(sc) Set retStr=retStr_XML
    }
    Quit retStr
}

}
