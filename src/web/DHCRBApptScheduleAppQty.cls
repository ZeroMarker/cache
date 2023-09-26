Class web.DHCRBApptScheduleAppQty Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 取得预约号范围
ClassMethod GetAPPMethodAppRange(RBASId As %String, MethodCode As %String) As %String
{
	;w ##class(web.DHCRBApptScheduleAppQty).GetAPPMethodAppRange("143||10","WIN")
	s APPQty=0
	s ResRowId=$P(RBASId,"||",1)
	s ASChild=$P(RBASId,"||",2)
	s IncludeAppRange=""
	s ExcludeAppRange=""
	
	s Child=$O(^RBAS(ResRowId,ASChild,"AQ",0))
	While (Child'="") {
		s APPData=$G(^RBAS(ResRowId,ASChild,"AQ",Child))
		s APPMethodDR=$P(APPData,"^",1)
		s APPQty=$P(APPData,"^",2)
		s AppStartNum=$P(APPData,"^",3)
		s AppRange=""
		i AppStartNum'="" s AppRange=AppStartNum_$C(1)_(AppStartNum+APPQty-1)
		; 
		s APPMethodCode=""
		i APPMethodDR'="" s APPMethodCode=$P($G(^RBC("APTM",APPMethodDR)),"^",1)
		;
		i APPMethodCode=MethodCode {
			s IncludeAppRange=AppRange
		}else{
			i AppRange'="" {
				if ExcludeAppRange="" s ExcludeAppRange=AppRange
				e  s ExcludeAppRange=ExcludeAppRange_$C(2)_AppRange
			}
		}
		s Child=$O(^RBAS(ResRowId,ASChild,"AQ",Child))
	}
	Q IncludeAppRange_"^"_ExcludeAppRange
}

/// 取得预约限额
ClassMethod GetAPPMethodQty(RBASId As %String, MethodCode As %String) As %String
{
	;w ##class(web.DHCRBApptScheduleAppQty).GetAPPMethodQty("3226||58","VIP")
	s ResRowId=$P(RBASId,"||",1)
	s ASChild=$P(RBASId,"||",2)
	s APPQty=0
	s CurApptQty=0
	s Child=0  
	f  s Child=$O(^RBAS(ResRowId,ASChild,"AQ",Child)) Q:(Child="")  d
	.s APPData=$G(^RBAS(ResRowId,ASChild,"AQ",Child))
	.s APPMethodDR=$P(APPData,"^",1)
	.s APPMethodCode=""
	.i APPMethodDR'="" s APPMethodCode=$P(^RBC("APTM",APPMethodDR),"^",1)
	.s OneApptQty=$P(APPData,"^",2)
	.i (MethodCode=APPMethodCode) s CurApptQty=CurApptQty+OneApptQty 
	.s APPQty=APPQty+OneApptQty
	q:CurApptQty'=0 CurApptQty  	//如果设置了预约限额返回限额
	/*
	q:MethodCode="VIP" CurApptQty   //如果是本院VIP预约返回设置数量，没有设置数量就是不允许预约
	s AppLoad=$P(^RBAS(ResRowId,ASChild),"^",2)
	i AppLoad="" s AppLoad=0
	s APPQty=AppLoad-APPQty 		//如果没有设置限额就用总的限额减去各个已经设置的限额数量
	*/
	q CurApptQty
	
	if MethodCode="WIN" d
	.s Child=0  f  s Child=$O(^RBAS(ResRowId,ASChild,"AQ",Child)) Q:Child=""  d
	..s APPData=$G(^RBAS(ResRowId,ASChild,"AQ",Child))
	..s APPMethodDR=$P(APPData,"^",1)
	..s APPMethodCode=""
	..i APPMethodDR'="" s APPMethodCode=$P(^RBC("APTM",APPMethodDR),"^",1)
	..Q:(MethodCode=APPMethodCode)
	..s APPQty=APPQty+$P(APPData,"^",2)
	.s AppLoad=$P(^RBAS(ResRowId,ASChild),"^",2)
	.i AppLoad="" s AppLoad=0
	.s APPQty=AppLoad-APPQty
	e  d
	.s Child=0  f  s Child=$O(^RBAS(ResRowId,ASChild,"AQ",Child)) Q:Child=""  d
	..s APPData=$G(^RBAS(ResRowId,ASChild,"AQ",Child))
	..s APPMethodDR=$P(APPData,"^",1)
	..s APPMethodCode=""
	..i APPMethodDR'="" s APPMethodCode=$P($G(^RBC("APTM",APPMethodDR)),"^",1)
	..Q:(MethodCode'=APPMethodCode)
	..s APPQty=$P(APPData,"^",2)
	Q APPQty
}

/// creator:guorongyong
/// date:20130427
/// desc:判断顺序号是否在预约号段记录中
/// w ##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp("426||14","2","")
ClassMethod CheckQueueNoInApp(RBASId As %String, QueueNo As %String, MethodDR As %String = "") As %String
{
	;1 在,0 不在
	;n (QueueNo)
	s findFlag=1,findMethodDR=""
	Q:(+QueueNo=0)||(RBASId="") findFlag_"^"_findMethodDR
	s QueueNo=+QueueNo
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	s AppMethodID=MethodDR
	s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
 	;正号串与加号串
 	;先计算整体的预约方式是否还有预约号
 	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
 	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	if AppMethodID="" s AppMethodID=$O(^RBC("APTM",0,"Code","WIN",0))
	s findMethodDR=AppMethodID
	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	s len=$l(NormalQueueNoStr,",")
	s MethodUsedQty=0,MastLeftQty=0
	f i=1:1:len{
		s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		s OneQueueNo=$P(SingleQueueNoStr,":",1)
		s QueueStatus=$P(SingleQueueNoStr,":",2)
		s MethodID=$P(SingleQueueNoStr,":",3)
		if ((MethodID=AppMethodID)&&("123"[QueueStatus)) s MethodUsedQty=MethodUsedQty+1
		s ASMethodID=""
		for{
			s ASMethodID=$O(ASQQueueArry(ASMethodID))
			q:ASMethodID=""
			if ((ASMethodID=AppMethodID)&&("123"[QueueStatus)) {
				if $G(ASQQueueArry(ASMethodID,1))=0 s ASQQueueArry(ASMethodID,1)=1
				else  s ASQQueueArry(ASMethodID,1)=$G(ASQQueueArry(ASMethodID,1))+1
			}
		}
		if QueueStatus=0 s MastLeftQty=MastLeftQty+1
		s QueueNoList(OneQueueNo)=QueueStatus_":"_MethodID
	}
	s (AppReserveQty,OtherReservSum,SubMastLeftQty)=0
	s SumAppMaxQty=$l(NormalQueueNoStr,",")
	s ASQSub=0 for{
		s ASQSub=$O(^RBAS(ResRowId,Childsub,"AQ",ASQSub))
		Q:ASQSub=""  
		s ASMethodID=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",1)
		continue:ASMethodID=""
		s NowDateFLag=$P(^RBC("APTM",ASMethodID),"^",7)
		if (ASMethodID=AppMethodID) {
			s AppMaxQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",4)
			s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
		}else{
			s ReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
			s OtherReservSum=OtherReservSum+ReserveQty
		}
		s OneReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)-$G(ASQQueueArry(ASMethodID,1))
		if OneReserveQty<0 s OneReserveQty=0
		s SubMastLeftQty=SubMastLeftQty+OneReserveQty
	}
	b ;0923
	if ((SumAppMaxQty<0)||(SumAppMaxQty<=MethodUsedQty)||(MastLeftQty<=SubMastLeftQty)){
		Q "0"
	}
	s TRFlag=$p(^RBAS(ResRowId,Childsub,"DHC"),"^",19)	
	i TRFlag="Y" {
		s ASTRSub=0 
		s OneEndNo=0
		for {
			s ASTRSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub))
			q:ASTRSub=""
			s TRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",3)
			s OneSttNo=OneEndNo+1,OneEndNo=OneEndNo+TRLoad
			continue:((OneSttNo>QueueNo)||(OneEndNo<QueueNo))
			k TRAMAppQueueArry
			s TRAMSub=0 for{
				s TRAMSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub))
				q:TRAMSub=""
				s TRAMAppMethodID=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",1)
				s TRAMAppQueueArry(TRAMAppMethodID)=1
				s TRAMMaxQty=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",2)
				s TRAMReserveQty=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",3)
				s NowDateFLag=$P(^RBC("APTM",TRAMAppMethodID),"^",7)
				s TRAMAppQueueArry(TRAMAppMethodID,"TRAMMaxQty")=TRAMMaxQty
				s TRAMAppQueueArry(TRAMAppMethodID,"TRAMReserveQty")=TRAMReserveQty
			}
			b ;计算已经挂过号，看是否还有号可以挂
			s TRAMAppMethodIDLeft=0,TRAMUserQty=0
			for oneQueuENo=OneSttNo:1:OneEndNo{
					s OneMethodID=$P(QueueNoList(oneQueuENo),":",2)
					s Status=$P(QueueNoList(oneQueuENo),":",1)
					if (Status=0) s TRAMAppMethodIDLeft=TRAMAppMethodIDLeft+1
					if OneMethodID=AppMethodID s TRAMUserQty=TRAMUserQty+1
					s ASMethodID=""
					for{
						s ASMethodID=$O(TRAMAppQueueArry(ASMethodID))
						q:ASMethodID=""
						if ((ASMethodID=AppMethodID)&&("123"[QueueStatus)) {  
							if $G(TRAMAppQueueArry(ASMethodID,1))=0 s TRAMAppQueueArry(ASMethodID,1)=1
							else  s TRAMAppQueueArry(ASMethodID,1)=$G(TRAMAppQueueArry(ASMethodID,1))+1
						}
					}
			}
			if TRAMAppMethodIDLeft=0 {s findFlag=0 continue}
			;计算这个时段是否还有号可以用
			s ASMethodID="",TRAMAppSubMastLeftQty=0,AppMaxQty=TRLoad,AppReserveQty=0
			for {
				s ASMethodID=$O(TRAMAppQueueArry(ASMethodID))
				q:ASMethodID=""
				s NowDateFLag=$P(^RBC("APTM",ASMethodID),"^",7)
				if (ASMethodID=AppMethodID) {
					s AppMaxQty=TRAMAppQueueArry(ASMethodID,"TRAMMaxQty")
					s AppReserveQty=TRAMAppQueueArry(ASMethodID,"TRAMReserveQty")
				}else{
					s OtherReservSum=OtherReservSum+TRAMAppQueueArry(ASMethodID,"TRAMReserveQty")
				}
				s OneReserveQty=TRAMAppQueueArry(ASMethodID,"TRAMReserveQty")-$G(TRAMAppQueueArry(ASMethodID,1))
				if OneReserveQty<0 s OneReserveQty=0
				s TRAMAppSubMastLeftQty=TRAMAppSubMastLeftQty+OneReserveQty
				
			}
			if (TRAMUserQty>AppMaxQty) {s findFlag=0 continue}
			if (TRAMAppMethodIDLeft<=TRAMAppSubMastLeftQty) {s findFlag=0 continue}
		}
		
		}
	/*s Child=0  
	f  s Child=$O(^RBAS(ResRowId,ASChild,"AQ",Child)) Q:(Child="")||(findFlag=1)  d
	.s APPData=$G(^RBAS(ResRowId,ASChild,"AQ",Child))
	.s APPMethodDR=$P(APPData,"^",1)
	.s APPQty=$P(APPData,"^",2)
	.s AppStartNum=$P(APPData,"^",3)
	.q:(MethodDR'="")&&(MethodDR'=APPMethodDR)
	.i (QueueNo'<AppStartNum)&&(QueueNo'>(AppStartNum+APPQty-1)) d
	..s findFlag=1,findMethodDR=APPMethodDR
	*/
	Q findFlag_"^"_findMethodDR
}

ClassMethod GetAppQtyByApptSchedule(ScheduleID As %String) As %String
{
	set returnvalue=""
	set ASQASParRef=$Piece(ScheduleID,"||",1)
	set ASQChildsub=$Piece(ScheduleID,"||",2)
	set RowID=""
	set RowID=$Order(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID))
	while(RowID'="")
	{
		set AppQty=$Get(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID))
		
		set Name=$Piece($Get(^RBC("APTM",$Piece(AppQty,"^",1))),"^",2)
		set Qty=$Piece(AppQty,"^",2)
		set StartNum=$Piece(AppQty,"^",3)
		set AppRowID=ScheduleID_"||"_RowID
		if (returnvalue="")
		{
			set returnvalue=AppRowID_"^"_Name_"^"_Qty_"^"_StartNum
		}
		else
		{
			set returnvalue=returnvalue_","_AppRowID_"^"_Name_"^"_Qty_"^"_StartNum
		}
		set RowID=$Order(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID))
	}
	
	quit returnvalue
}

ClassMethod GetMethodAppedQty(ASRowId As %String, APPMethodRowId As %String) As %String
{
	n (ASRowId,APPMethodRowId)
	s ResRowId=$P(ASRowId,"||",1)
	s Childsub=$P(ASRowId,"||",2)
	s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	Q:NormalQueueNoStr="" 0
	s Count=0
	for n=1:1:$l(NormalQueueNoStr,",") {
	 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",n)
	 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
	 	s QueueNo=$P(SingleQueueNoStr,":",1)
	 	s QueueNoMethodRowId=$P(SingleQueueNoStr,":",3)
	 	;先统计已预约和已预约取号
	 	i ((QueueNoStatus=2)||(QueueNoStatus=3))&(QueueNoMethodRowId=APPMethodRowId){
		 	s Count=Count+1
		 	/*
		 	;只取预约号段里的号
		 	if (QueueNo'<AppStartSeqNo)&&(QueueNo'>(AppStartSeqNo+APPSeqNoCount-1)){
			 	s ArriveCount=ArriveCount+1
		 	}
		 	*/
	 	}
 }
 Q Count
}

ClassMethod Insert(ScheduleID As %String) As %String
{
	set flag=0
	TStart
	set RowID="0"
	set RowID=$order(^RBC("APTM",RowID))
	while(RowID'=""){
		s endtime=$P($G(^RBC("APTM",RowID)),"^",5)
		if (endtime="")!((endtime'="")&&(endtime>+$H)){
			set obj=##class(User.DHCRBApptSchedule).%OpenId(ScheduleID)
			set SessionId=obj.%New(ScheduleID)
			set appQty=##class(User.DHCRBApptScheduleAppQty).%New(ScheduleID)
			do appQty.ASQASParRefSetObjectId(ScheduleID)
			do appQty.ASQMethodDRSetObjectId(RowID)
			set appQty.ASQQty=0
			Set sc = appQty.%Save()
			If $$$ISERR(sc) 
			{
				set flag=1
				Do $System.Status.DisplayError()
				Trollback
				break
			}
			do appQty.%Close()
		}
		set RowID=$order(^RBC("APTM",RowID))
	}
	if (flag=1) quit 100
	TCommit
	;d ##class(DtPortal.Doctor.DHCDocComService).SendOScheInfoPortal(ScheduleID)
	;d ##class(DHCExternalService.RegInterface.SynVisitSchedule).SynRegCount(ScheduleID)
	quit 0
}

/// w ##class(web.DHCRBApptScheduleAppQty).Update("1095||243","1095||243||7^窗口预约^6^1")
ClassMethod Update(ScheduleID As %String, AppString As %String) As %String
{
	set flag=0
	s OldRBApptQtyInfo=..GetOneRBApptQtySchedule(ScheduleID)
	TStart
	set len=$length(AppString,",")
	for i=1:1:len
	{
		set RowData=$Piece(AppString,",",i)
		set RowID=$Piece(RowData,"^",1)
		set Qty=$Piece(RowData,"^",3)
		set StartNum=$Piece(RowData,"^",4)
		set appQty=##class(User.DHCRBApptScheduleAppQty).%OpenId(RowID)
		Set appMethodDr=appQty.ASQMethodDR.%Id()
		Set appedCount=..GetMethodAppedQty(ScheduleID,appMethodDr)
		if appedCount>Qty {
			do appQty.%Close()
			s flag=1
			break
		}
	}
	if (flag=1) quit 100
	for i=1:1:len
	{
		set RowData=$Piece(AppString,",",i)
		set RowID=$Piece(RowData,"^",1)
		set Qty=$Piece(RowData,"^",3)
		set StartNum=$Piece(RowData,"^",4)
		set appQty=##class(User.DHCRBApptScheduleAppQty).%OpenId(RowID)
		set appQty.ASQQty=Qty
		set appQty.ASQStartNum=StartNum
		Set sc = appQty.%Save()
		If $$$ISERR(sc) 
		{
			set flag=1
			Do $System.Status.DisplayError()
			Trollback
			break
		}
		do appQty.%Close()
	}
	if (flag=1) quit 101
	d ..UpdateScheduleAppt(ScheduleID)
	TCommit
	s NewRBApptQtyInfo=..GetOneRBApptQtySchedule(ScheduleID)
	if (OldRBApptQtyInfo'=NewRBApptQtyInfo) d ..AddRBApptScheduleLog(ScheduleID,OldRBApptQtyInfo,NewRBApptQtyInfo)
	;d ##class(DHCExternalService.RegInterface.SynVisitSchedule).SynRegCount(ScheduleID)
	quit 0
}

ClassMethod Delete(ASQRowId As %String) As %String
{
	n (ASQRowId)
	set appQty=##class(User.DHCRBApptScheduleAppQty).%OpenId(ASQRowId)
	Set appMethodDr=appQty.ASQMethodDR.%Id()
	Set ScheduleID=$p(ASQRowId,"||",1,2)
	Set appedCount=..GetMethodAppedQty(ScheduleID,appMethodDr)
	do appQty.%Close()
	if appedCount>0 {
		Q appedCount
	}
	TStart
	&sql(delete from SQLUser.DHC_RBApptScheduleAppQty where ASQ_RowId=:ASQRowId)
	i " 0 100 "'[(" "_SQLCODE_" ") {
		 Tro
		 Q 101
	}else{
		d ..UpdateScheduleAppt(ScheduleID)
	}
	Tcommit
	Q 0
}

ClassMethod DeleteByAS(ASRowID As %String) As %String
{
	n (ASRowID)
	s ret=0
	TStart
	s ASQChildsub=0
	for{
		s ASQChildsub=$o(^RBAS(+ASRowID,$p(ASRowID,"||",2),"AQ",ASQChildsub))
		q:ASQChildsub=""
		s ASQRowId=ASRowID_"||"_ASQChildsub
		s ret=..Delete(ASQRowId)
		if ret'=0{
			Q	
		}
	}
	if ret=0{
		TC	
	}else{
		Tro	
	}
	Q ret
}

ClassMethod AddRBApptScheduleLog(ASRowID As %String, OldRBApptQtyInfo As %String, NewRBApptQtyInfo As %String) As %String
{
	s UserID=""
	if ($d(%session)) s UserID=%session.Get("LOGON.USERID")
	s UpdateInfo="预约机构预约限额 由"_OldRBApptQtyInfo_" 修改为"_NewRBApptQtyInfo
	 s object = ##class(User.DHCRBApptScheduleUpdateLog).%New()
	 s object.ASULRBASDR=ASRowID
	 s object.ASULUpdateDate=..%SysDate()
	 s object.ASULUpdateTime=..%SysTime()
	 s object.ASLUpdateUser=UserID
	 s object.ASULType="U"
	 s object.ASULNotes=UpdateInfo
	 Set sc = object.%Save()

	 If $$$ISERR(sc) {
			;Do $System.Status.DisplayError()
			Trollback
			Quit 100
		}

	 do object.%Close()
	 Q 0
}

ClassMethod GetOneRBApptQtySchedule(ASRowID As %String)
{
	s OldApptQtyInfo=""
	s ASQChildsub=0
	f  s ASQChildsub=$o(^RBAS(+ASRowID,$p(ASRowID,"||",2),"AQ",ASQChildsub)) q:ASQChildsub=""  d
	.s str=$g(^RBAS(+ASRowID,$p(ASRowID,"||",2),"AQ",ASQChildsub))
	.s ASQMethodDR=$p(str,"^",1)
	.s APTMDesc=$p(^RBC("APTM",ASQMethodDR),"^",2)
	.s ASQQty=$p(str,"^",2)
	.s ASQStartNum=$p(str,"^",3)
	.i OldApptQtyInfo="" s OldApptQtyInfo=APTMDesc_":限额值"_ASQQty_"起始号"_ASQStartNum
	.e  s OldApptQtyInfo=OldApptQtyInfo_";"_APTMDesc_":限额值"_ASQQty_"起始号"_ASQStartNum
	q OldApptQtyInfo
}

/// creator:guorongyong
/// date:2010-08-28
/// desc:新增预约机构限额,机构预约起始号
/// input：生成排班ID,预约方法,机构限额,机构预约起始号
/// output：0 成功，其他 失败
ClassMethod NewAppMethod(ScheduleID As %String, MethodId As %String, AllCount As %String, StartNum As %String, AutoInsertFlag As %String = "") As %String
{
   s OldRBApptQtyInfo=..GetOneRBApptQtySchedule(ScheduleID)
	TS
	set object=##class(User.DHCRBApptScheduleAppQty).%New(ScheduleID)
	do object.ASQASParRefSetObjectId(ScheduleID)
	do object.ASQMethodDRSetObjectId(MethodId)
	set object.ASQQty=AllCount
	set object.ASQStartNum=StartNum
	set ASQLastUpDate=..%SysDate()
	set ASQLastUpTime=..%SysTime()
	//预约回归不释放并增号时记录用户ID,用以和手工维护做区分
	if (AutoInsertFlag=1){
		do object.ASQLastUpUserDRSetObjectId(%session.Get("LOGON.USERID"))
	}
	Set sc = object.%Save()
	If $$$ISERR(sc) 
	{
		//Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	do object.%Close()
	if (AutoInsertFlag=1){
		TC
		quit 0
	}
	d ..UpdateScheduleAppt(ScheduleID)
	TC
	s NewRBApptQtyInfo=..GetOneRBApptQtySchedule(ScheduleID)
	if (OldRBApptQtyInfo'=NewRBApptQtyInfo) d ..AddRBApptScheduleLog(ScheduleID,OldRBApptQtyInfo,NewRBApptQtyInfo)

	quit 0
}

ClassMethod UpdateScheduleAppt(ScheduleID As %String) As %String
{
	s EStartPrefix=##class(web.DHCRBApptScheduleAppQty).GetAppStartNum(ScheduleID)
	s ApptMax=##class(web.DHCRBApptScheduleAppQty).GetAppQtySumByApptSchedule(ScheduleID)
	Set object = ##class(User.RBApptSchedule).%OpenId(ScheduleID)
	;预约限额
	s object.ASNoApptSession=ApptMax
	;预约起始号
	s object.ASQueueNoCount=EStartPrefix
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		Trollback
		Quit 100
	}
	do object.%Close()
}

/// 
/// 取得每类号的设置数量  guobaoping
ClassMethod GetSeqnoAvailQty(RBASId As %String, MethodCode As %String) As %String
{
	;w ##class(web.DHCRBApptScheduleAppQty).GetSeqnoAvailQty("81||1","WIN^114^DOCADD")
	s TotalAPPQty=0
	s ResRowId=$P(RBASId,"||",1)
	s ASChild=$P(RBASId,"||",2)
	Q:'$d(^RBAS(ResRowId,ASChild)) TotalAPPQty
	s Child=0  f  s Child=$O(^RBAS(ResRowId,ASChild,"AQ",Child)) Q:Child=""  d
	.s APPData=$G(^RBAS(ResRowId,ASChild,"AQ",Child))
	.s APPMethodDR=$P(APPData,"^",1)
	.s APPMethodCode=""
	.i APPMethodDR'="" s APPMethodCode=$P($G(^RBC("APTM",APPMethodDR)),"^",1)
	.Q:(("^"_MethodCode_"^")'[("^"_APPMethodCode_"^"))
	.s APPQty=+$P(APPData,"^",2)
	.s TotalAPPQty=TotalAPPQty+APPQty
	Q TotalAPPQty
}

ClassMethod GetAppQtySumByApptSchedule(ScheduleID As %String) As %String
{
	//如果允许重叠维护预约方式号段 那么最大值取预约最大号
	set returnvalue=0
	set ASQASParRef=$Piece(ScheduleID,"||",1)
	set ASQChildsub=$Piece(ScheduleID,"||",2)
	set RowID=""
	set RowID=$Order(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID))
	while(RowID'="")
	{
		set AppQty=$Get(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID))
		set StQty=$Piece(AppQty,"^",2)
		set Qty=$Piece(AppQty,"^",3)
		set AppLastUser=$Piece(AppQty,"^",6)
	    if (AppLastUser'=""){ //预约回归自动插入的记录在排班模板维护界面不显示
	    	set RowID=$Order(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID))
	    	continue
	    }
		Set EndNum=(StQty+Qty-1)
		s:EndNum<1 EndNum=0
		if (EndNum>returnvalue){s returnvalue=EndNum}
		//s returnvalue=returnvalue+Qty
		set RowID=$Order(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID))
	}
	
	quit returnvalue
}

// RBC_AppointMethod

// d ##class(%ResultSet).RunQuery("web.DHCRBApptScheduleAppQty","FindAppQty","635||1840")

Query FindAppQty(ScheduleID As %String) As %Query(ROWSPEC = "ASQRowId:%String,ApptMethodDr:%String,AppMethodName:%String,AppQty:%String,AppStartNum:%String")
{
}

ClassMethod FindAppQtyExecute(ByRef qHandle As %Binary, ScheduleID As %String) As %Status
{
	n repid
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	set ASQASParRef=$Piece(ScheduleID,"||",1)
	set ASQChildsub=$Piece(ScheduleID,"||",2)
	/*s APTMRowId=0
	f  s APTMRowId=$o(^RBC("APTM",APTMRowId)) q:APTMRowId=""  d
	.s RowID=0,findRecord=0
	.f  s RowID=$Order(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID)) q:RowID=""  d
	..s Methoddr=$p(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID),"^",1)
	..q:Methoddr'=APTMRowId
	..s findRecord=1
	..s AppQty=$p(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID),"^",2)
	..s AppStartNum=$p(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID),"^",3)
	..s AppMethodName=$p($g(^RBC("APTM",Methoddr)),"^",2)
	..d OutPutRow
	.i findRecord=0 d
	..s AppMethodName=$p($g(^RBC("APTM",APTMRowId)),"^",2)
	..s Methoddr=APTMRowId,AppQty="",AppStartNum=""
	..d OutPutRow*/
	s RowID=0
	f  s RowID=$Order(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID)) q:RowID=""  d
	.s Methoddr=$p(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID),"^",1)
	.s AppQty=$p(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID),"^",2)
	.s AppStartNum=$p(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID),"^",3)
	.s AppMethodName=$p($g(^RBC("APTM",Methoddr)),"^",2)
	.s AppLastUser=$p(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID),"^",6)
	.Q:AppLastUser'="" //预约回归自动插入的记录在排班模板维护界面不显示
	.d OutPutRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRow
   	s Data=$lb(ScheduleID_"||"_RowID,Methoddr,AppMethodName,AppQty,AppStartNum)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod FindAppQtyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAppQtyExecute ]
{
	n repid
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAppQtyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAppQtyExecute ]
{
	n repid
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	 k ^CacheTemp(repid)
	}Else {				// fetch rowf
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// 1521||1003||21^1^1^1,1521||1003||^2^2^1,1521||1003||^20^0^0,1521||1003||^21^0^0,1521||1003||^22^0^0

// w ##class(web.DHCRBApptScheduleAppQty).SaveScheduleAppQty("1521||1003||^1^1^1,1521||1003||^2^2^1,1521||1003||^20^0^0,1521||1003||^21^0^0,1521||1003||^22^0^0")

ClassMethod SaveScheduleAppQty(paraString As %String) As %String
{
	s ^temscl("SaveScheduleAppQty")=paraString
	s updateParaString="",err=0
	s len=$length(paraString,",")
	TS
	for i=1:1:len
	{
		s oneparaString=$p(paraString,",",i)
		s oneASQRowId=$p(oneparaString,"^",1)
		s ScheduleID=$p(oneASQRowId,"||",1,2)
		if ($p(oneASQRowId,"||",3)'=""){
			i updateParaString="" s updateParaString=oneparaString
			e  s updateParaString=updateParaString_","_oneparaString
		}else{
			s ScheduleID=$p(oneASQRowId,"||",1,2)
			s MethodId=$p(oneparaString,"^",2)
			s AllCount=$p(oneparaString,"^",3)
			s StartNum=$p(oneparaString,"^",4)
			if (AllCount=0)&&(StartNum=0) continue
			s err=..NewAppMethod(ScheduleID,MethodId,AllCount,StartNum)
		}
	}
	if (updateParaString'=""){
		s err=..Update(ScheduleID,updateParaString)
	}
	if (err'=0){
		Trollback
		Q err
	}
	TC
    Q err
}

ClassMethod GetAppStartNum(ScheduleID As %String)
{
	set minAppStartNum=""
	set ASQASParRef=$Piece(ScheduleID,"||",1)
	set ASQChildsub=$Piece(ScheduleID,"||",2)
	set RowID=""
	set RowID=$Order(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID))
	while(RowID'=""){
		set AppQty=$Get(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID))
		set ASQStartNum=$Piece(AppQty,"^",3)
		s AppLastUser=$Piece(AppQty,"^",6)
	    if (AppLastUser'=""){ //预约回归自动插入的记录在排班模板维护界面不显示
	    	set RowID=$Order(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID))
	    	continue
	    }
		i minAppStartNum="" s minAppStartNum=ASQStartNum
		if (minAppStartNum<ASQStartNum)||(ASQStartNum="") set RowID=$Order(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID)) continue
		set minAppStartNum=ASQStartNum
		set RowID=$Order(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID))
	}
	Q minAppStartNum
}

ClassMethod GetASLoad(ScheduleID As %String)
{
	s ASLoad=$p(^RBAS(+ScheduleID,$p(ScheduleID,"||",2)),"^",8)
	Q ASLoad
}

}
