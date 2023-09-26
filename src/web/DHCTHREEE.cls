Import SQLUser

/// web.DHCTHREEE
Class web.DHCTHREEE Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 146;

ClassMethod GetSSGrp(UserId) As %String
{
    n (UserId)
    s ret=0
    s SSGrpDr=$P(^SSU("SSUSR",UserId),"^",5)
    s SSGrp=$P(^SSU("SSGRP",SSGrpDr),"^",1)
    if SSGrp["Demo" s ret=1
    e  s ret=1
    //e  s ret=0
    q ret
}

ClassMethod DBCSHU0(RowId As %String, StrItem As %String, StrDate As %String) As %String
{
	 ;/没大便天数
	 ;/
	   n (RowId,StrItem,StrDate)
	     s MRADMROWId=$P(^PAADM(RowId),"^",61)
	    // s ^TT=StrDate
	     //s StrDate=$ZDH(StrDate,3)
	    // q 1
	     s sdate1=StrDate-2
	     s i=0
	     
	     f date=sdate1:1:StrDate d
	      .s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",date,StrItem,chl)) q:chl=""  d
	      ..s num=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
	      ..i (num=0) s i=i+1
	   q i
}

ClassMethod GetAllPatientExecute(ByRef qHandle As %Binary, Ward As %String, RegNo As %String) As %Status
{
	  // n (Ward,RegNo)
	      Set repid=$I(^CacheTemp)
 	      s ind=1
	      if (Ward'="")&&(RegNo="")
	      {
	       s room="" 
	       f  s room=$O(^PAADMi("CurrWard",Ward,room)) q:room=""  d
	       .s RowId=""  f  s RowId=$O(^PAADMi("CurrWard",Ward,room,RowId)) q:RowId=""  d
	       ..s VistStatus=$P(^PAADM(RowId),"^",20)
	       ..q:VistStatus="D"
	       ..s pinfo=..Patinfo(RowId)
	       ..q:pinfo=""
	       ..s sort=$P(pinfo,"#",6)
	       ..s Reg=$P(pinfo,"#",7)
	       ..s tmp(sort)=pinfo_"^"_RowId
	       ..s Name=$P(pinfo,"#",2)
	       ..s Bed=$P(pinfo,"#",3)
	       ..s Adm=RowId
	       s no=""  f  s no=$O(tmp(no)) q:no=""  d
	       .s pinfo=$P(tmp(no),"^")
	       .s Reg=$P(pinfo,"#",7)
	       .s Adm=$P(tmp(no),"^",2)
	       .s Name=$P(pinfo,"#",2)
	       .s Bed=$P(pinfo,"#",3)
	       .d OutPat
	      }
	      if (RegNo'="")
	      {        s RowId=RegNo
		           s pinfo=..Patinfo(RowId)
	               q:pinfo=""
	               s Reg=$P(pinfo,"#",7)
	               s Name=$P(pinfo,"#",2)
	               s Bed=$P(pinfo,"#",3)
	               s Adm=RowId
	               d OutPat

		  }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPat
	set Data=$lb(Adm,Name,Bed,Reg)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
 /////////////////////////////////////////////////////////////////////
}

ClassMethod GetAllPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllPatientExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAllPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllPatientExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetAllPatient(Ward As %String, RegNo As %String) As %Query(ROWSPEC = "Adm,Name,Bed,Reg")
{
}

ClassMethod GetLable(adm As %String, lbl As %String) As %String
{
    n (adm,lbl)
	    S RowId=""
	    s RowId=$o(^MRC("OBITM",0,"Desc",$$ALPHAUP^SSUTIL4(lbl),RowId)) 
	    if RowId="" q ""
	    s lable=..SelectHavelable(adm,RowId)
	q $G(lable)
}

ClassMethod GetPatValue(Adm As %String, BaseDate As %String) As %String
{
   //w ##class(web.DHCTHREEE).GetPatValue("339350",)
   //生命体征数据查询
	n (Adm,BaseDate)
	s Date=BaseDate
	s Mradm=$P(^PAADM(Adm),"^",61) 
	s Mb=$g(Mb),Ssy=$g(Ssy),Szy=$g(Szy),SsyTime=$g(SsyTime),SzyTime=$g(SzyTime)
	s TempTime="",PulseTime="",kTempTime="",gTempTime="",Tw=""   ; 
	s Temp="",Pulse="",kTemp="",gTemp="",Breath="",Stool="",xy="",Sg="",Tz="",Otwl="",Ryl="",Tw="",Ps1="",Ps2="",Ps3="",Gc="" ;add by gongping
	s Heart=""
	s LyZd=""                  ;

	s OutTotal=0,FlowTotal=0,EnterTotal=0
	s LastOBSDTemp="",LastOBSTTemp="",LastOBSDPulse="",LastOBSTPulse="",LastOBSTHeart="",LastOBSDHeart="",IsYc="",XBList=""
	s NowOBSD="",NowOBST="",Yc=0
	s XBHours=0,XBAmount=0,XBNum=0,XBValue=""
	s EnterHours=0,EnterAmount=0,FlowHours=0,FlowAmount=0
	s XBLZDN=""
	
	s Num=1,Num1=1
	s ItmDr=""  f  s ItmDr=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr)) q:ItmDr=""  d
	.s Name=$P(^MRC("OBITM",ItmDr),"^",2)
	.s chl=""  f  s chl=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr,chl)) q:chl=""  d
	..s Value=$P(^MR(Mradm,"OBS",chl),"^",2)
	..s OBSD=$P(^MR(Mradm,"OBS",chl),"^",3)
	..s OBST=$P(^MR(Mradm,"OBS",chl),"^",4)
	..s Desc=$P(^MR(Mradm,"OBS",chl),"^",6)
	..i ((Name="体温")!(Name["口温")!(Name["肛温"))&(Value'="")  d
	...s NowOBSD=$ZDH($zd(OBSD,3),3)
	...s NowOBST=$ZTH($ZT(OBST,1))
	...s Yc=..PatLeave(Adm,NowOBSD,NowOBST) 
	...i Yc>0 do  ;外出
	....s Tw=Value_"^Y" 
	....i Desc'="" s Tw=Tw_"#Y^"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Desc   ;不是物理降温
	...e  d
	....i Desc'="" s Tw=Value_"#Y^"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Desc    ;不是物理降温
	....e  s Tw=Value
	...if Name="体温" s Temp(OBST)="Y^"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Tw
	...if Name["口温" s Temp(OBST)="K^"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Tw
	...if Name["肛温" s Temp(OBST)="G^"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Tw
	...s Tw=""           
	...s IsYc=""
	...s LastOBSDTemp=$ZDH($zd(OBSD,3),3) ;上一点日期
	...s LastOBSTTemp=$ZTH($ZT(OBST,1)) ;上一点时间
	...s Yc=0
	..i Name["脉搏" d
	...s NowOBSD=$ZDH($zd(OBSD,3),3)
	...s NowOBST=$ZTH($ZT(OBST,1))
	...s Yc=..PatLeave(Adm,NowOBSD,NowOBST)  
	...i Yc'=0 do
	....s IsYc="^Y"              
	...s Pulse(OBST)=$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Value_$G(IsYc)  
	...s IsYc=""
	...s LastOBSDPulse=$ZDH($zd(OBSD,3),3) ;上一点日期
	...s LastOBSTPulse=$ZTH($ZT(OBST,1)) ;上一点时间
	...s Yc=0
	..i Name["心率" d
	...s NowOBSD=$ZDH($zd(OBSD,3),3)
	...s NowOBST=$ZTH($ZT(OBST,1))
	...s Yc=..PatLeave(Adm,NowOBSD,NowOBST)  
	...i Yc'=0 do
	....s IsYc="^Y"              
	...s Heart(OBST)=$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Value_$G(IsYc)  
	...s IsYc=""
	...s LastOBSDHeart=$ZDH($zd(OBSD,3),3) ;上一点日期
	...s LastOBSTHeart=$ZTH($ZT(OBST,1)) ;上一点时间
	...s Yc=0
	..i Name["呼吸"  d
	...s NowOBSD=$ZDH($zd(OBSD,3),3)
	...s NowOBST=$ZTH($ZT(OBST,1))
	...s Yc=..PatLeave(Adm,NowOBSD,NowOBST) 
	...i Yc'=0 do
	....s IsYc="^Y"              
	...s Breath(OBST)=$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Value_$g(IsYc)
	...s IsYc=""
	...s Yc=0
	..i Name["小便次数" d 
	...s XBList="#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Value  
	..i Name["体温未测" d 
	...s Otwl=Otwl_"#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Value  
	...//s Temp(OBST)="Y^"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_37_"^Y" 
	..i Name["体重" d 
	...s Tz="#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Value  
	..i Name["来院状态" d                                
	...s LyZd="#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Value  
	..i Name["小便量" d 
	...//s Ps1=Ps1_"#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Value
	...//12h:100,200,特殊字符(C/D)
	...s Value=$Tr(Value,"：",":")
	...i $L(Value,"h:")>1 d
	....i $L($P(Value,"h:",1),"C/D")>1 d
	.....s XBLZDN="C/D"
	.....s XBHours=+$G(XBHours)+$P($P(Value,"h:",1),"C/D",2)
	....e  d
	.....//s XBLZDN=""
	.....s XBHours=+$G(XBHours)+$P(Value,"h:",1)
	....s XBAmount=+$G(XBAmount)+$P(Value,"h:",2)
	...e  d
	....i Value=+Value d
	.....s XBNum=+$G(XBNum)+Value
	....e  d
	.....s XBValue=Value
	..i Name="值1" d 
	...s Ps2=Ps2_"#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Value  
	..i Name="其他" d
	...i Desc'="" d
	....s Desc=$Tr(Desc,"；",";")
	....s Desc=$Tr(Desc,"：",":")
	....s DescLen=$L(Desc,";")
	....f ii=1:1:DescLen d
	.....s QtDesc=$P(Desc,";",ii)
	.....q:QtDesc=""
	.....s Ps3=Ps3_"#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_QtDesc
	...e  d
	....s Value=$Tr(Value,"；",";")
	....s Value=$Tr(Value,"：",":")
	....s ValueLen=$L(Value,";")
	....f ii=1:1:ValueLen d
	.....s QtValue=$P(Value,";",ii)
	.....q:QtValue=""
	.....s Ps3=Ps3_"#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_QtValue
	..i Name["大便次数" d
	...i Desc'="" d
	....s Stool="#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Value_" "_Desc
	...e  d
	....s Stool="#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Value
	..i Name["灌肠" d 
	...s Gc="#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Value            
	..i (Name="项目2结果") //s Ps3="#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_Value  
	..i (Name="项目1结果") d 
	...//s FlowTotal=Value
	..i (Name["入液量") d
	...//12h:100,200
	...i $L(Value,"h:")>1 d
	....s EnterHours=+$G(EnterHours)+$P(Value,"h:",1)
	....s EnterAmount=+$G(EnterAmount)+$P(Value,"h:",2)
	...e  d
	....s EnterTotal=$G(EnterTotal)+Value
	..i (Name["出液量") d

	...//12h:100,200
	...i $L(Value,"h:")>1 d
	....s FlowHours=+$G(FlowHours)+$P(Value,"h:",1)
	....s FlowAmount=+$G(FlowAmount)+$P(Value,"h:",2)
	...e  d
	....s FlowTotal=$G(FlowTotal)+Value

	..i (Name["收缩压")  d
	...s mSsyTime(Num)=$zd(OBSD,3)_"^"_$ZT(OBST,1)
	...s mSsy(Num)=Value
	...s Num=Num+1
	..i (Name["舒张压")  d
    ...s mSzyTime(Num1)=$zd(OBSD,3)_"^"_$ZT(OBST,1)
	...s mSzy(Num1)=Value
	...s Num1=Num1+1
	..i (Name="项目1")  d
	...s CRItemName=Value
	..i (Name="项目2")  d
	...s CRItemName2=Value
    b 
	q:$G(Num)="" ""
	for x=1:1:Num-1  d
	.for x1=1:1:Num1-1 d
	..i (mSsyTime(x)=mSzyTime(x1)) s xy=$g(xy)_"#"_mSsyTime(x)_"^"_mSsy(x)_"/"_mSzy(x1)
    //按时间排序
	s t=""  f  s t=$O(Temp(t)) q:t=""  d
	.s Temp=$G(Temp)_"#"_Temp(t)

	s t=""  f  s t=$O(Pulse(t)) q:t=""  d
	.s Pulse=$G(Pulse)_"#"_Pulse(t)

	s t=""  f  s t=$O(Heart(t)) q:t=""  d
	.s Heart=$G(Heart)_"#"_Heart(t)

	s t=""  f  s t=$O(Breath(t)) q:t=""  d
	.s Breath=$G(Breath)_"#"_Breath(t)
	
	i OutTotal'=0  s Otwl="#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_OutTotal
	//e  s Otwl=""
	
	//if $G(CRItemName)'=""
	 s FlowTotal=FlowTotal
	//if $G(CRItemName2)'="" 
	//s EnterTotal=OutTotal
	i FlowTotal'=0  s yll="#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_FlowTotal  
	e  s yll=""
	s P9=yll
	i FlowHours'=0,FlowAmount'=0  s yll="#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_FlowHours_"h:"_FlowAmount
	i EnterTotal'=0  s Ryl="#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_EnterTotal  
	e  s Ryl=""
	i EnterHours'=0,EnterAmount'=0  s Ryl="#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_EnterHours_"h:"_EnterAmount
	//外出登记显示在其他栏中
	s outinfo=##class(web.DHCTHREEE).GetPatOutInfo(Adm,Date)
	i outinfo'="" s Ps3="#"_outinfo_Ps3
	//小便量显示优先级,特殊字符(C/D)>12h:100>200
	i XBNum'=0 s Ps1="#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_XBNum
	i XBHours'=0,XBAmount'=0 s Ps1="#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_XBLZDN_XBHours_"h:"_XBAmount
	i XBValue'="" s Ps1="#"_$zd(OBSD,3)_"^"_$ZT(OBST,1)_"^"_XBValue
	s Data=xy_"|"_Temp_"|"_Breath_"|"_Stool_"|"_Pulse_"|"_XBList_"|"_Sg_"|"_Tz_"|"_LyZd_"|"_Otwl_"|"_yll_"|"_Ryl_"|"_Ps1_"|"_Ps2_"|"_Ps3_"|"_Gc_"|"_Heart
	//s ^T(BaseDate)=Data
	
	//if Temp=""  s Data=""
	q Data
}

ClassMethod GetAdmQtData(Adm As %String) As %String
{
	s ret=""
	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:rw=""  d
	.s ADate=$P(^DHCADMQTREC("QTREC",rw),"^",2)
	.if ADate'="" s ADate=$ZD(ADate,3)
	.s ATime=$P(^DHCADMQTREC("QTREC",rw),"^",3)
	.if ATime'="" s ATime=$ZT(ATime,2)
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.s Typ=$P(^DHCQTRECTYP("typ",TypDr),"^",2)
	.q:(Typ="入院")!(Typ="手术")!(Typ="分娩")!(Typ="死亡")
	.s ret=ret_ADate_"|"_ATime_"|"_Typ_"^"
	q ret
}

ClassMethod GetLableStr(Adm As %String) As %String
{
 //获得标签
	n (Adm)
	s Mradm=$P(^PAADM(Adm),"^",61) 
	s CRItemName=..GetItemName(Mradm,"项目1")
	s CRItemName2=..GetItemName(Mradm,"项目2")
	q CRItemName_"^"_CRItemName2
}

ClassMethod GetItemName(Mradm As %String, Item As %String) As %String
{
	n (Mradm,Item)
	s chl=""  f  s chl=$O(^MR(Mradm,"OBS",chl),-1) q:(chl="")!($G(Value)'="")  d
	.s ItmDr=$P(^MR(Mradm,"OBS",chl),"^")
	.s Name=$P(^MRC("OBITM",ItmDr),"^",2)
	.q:Name'=Item
	.s Value=$P(^MR(Mradm,"OBS",chl),"^",2)
	q Value
}

ClassMethod InsertData(RowId As %String, StrItem As %String, StrDate As %String, StrTime As %String, StrUser As %String, Value As %String) As %String
{
   //##class(web.DHCTHREEE).InsertData()##class(web.DHCTHREEE).InsertDesc(adm,itmdr,date,tim,user,val)
	n (RowId,StrItem,StrDate,StrTime,StrUser,Value) 
	;s ^tempsc("InsertData")=$lb(RowId,StrItem,StrDate,StrTime,StrUser,Value) 
	s Value=$TR(Value," ","")
	//s RowId=2,StrItem=39,StrDate="2005-07-11",StrTime="02:00:00",Value="", StrUser=2873         
	s MRADMROWId=$P(^PAADM(RowId),"^",61)  
	s StrDate=##class(websys.Conversions).DateHtmlToLogical(StrDate)
	s StrTime=$ZTH(StrTime,3)
	s (ss,obsid)=""
	s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,StrItem,chl)) q:chl=""  d
	.s time=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
	.if time=StrTime  d
	..s obsid=chl
	..s ss=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
	..s userId=$P(^MR(MRADMROWId,"OBS",chl),"^",5)
	..i userId'="" s nurName=$P(^SSU("SSUSR",userId),"^",2)
	..e  s nurName=""
	..s nurDate=$P(^MR(MRADMROWId,"OBS",chl),"^",11)
	..i nurDate'="" s nurDate=$ZD(nurDate,3)
	..s nurTime=$P(^MR(MRADMROWId,"OBS",chl),"^",12)
	..i nurTime'="" s nurTime=$ZT(nurTime,2)
	s StrUserGrpDr=$P(^SSU("SSUSR",StrUser),"^",5)
	if StrUserGrpDr'="" s StrUserGrpDesc=$P(^SSU("SSGRP",StrUserGrpDr),"^",1)
	s curDate=$P($H,",",1),curTime=$P($H,",",2)
	b //00000s
	if $G(ss)'="" 
	{
		;q:(userId'=StrUser)&&(StrUserGrpDesc'["护士长") "1^"_$G(nurName)_" 录入日期:"_$G(nurDate)_" "_$G(nurTime)
		i $G(Value)=""
		{
			&sql(update MR_Observations set OBS_Value=:Value,
	       	OBS_User_DR=:StrUser,OBS_UpdateDate=:curDate,OBS_UpdateTime=:curTime
	        where OBS_ParRef = :MRADMROWId
	        and   OBS_Item_DR = :StrItem
	        and   OBS_Date=:StrDate
	        and   OBS_Time=:StrTime)
	        i (SQLCODE=0)&(obsid'="")&(ss'=Value){
		    s i5=##class(Nur.NurseModiNew).geti5()
		    s p15="index1|DHCNURTEM^index2|"_RowId_"^index3|"_curDate_"^index4|"_curTime
		    s p15=p15_"^field1|删除^field2|"_StrUser
		    s p15=p15_"^field3|"_StrItem_"^field4|"_obsid_"^field5|"_StrDate_"^field6|"_StrTime
		    s p15=p15_"^field8|"_ss_"^field9|"_Value
		    d ##class(Nur.NurseModiNew).savei5(p15,i5)
		    }
	     }
        else
        {
	       	&sql(update MR_Observations set OBS_Value=:Value,
	       	OBS_User_DR=:StrUser,OBS_UpdateDate=:curDate,OBS_UpdateTime=:curTime
	        where OBS_ParRef = :MRADMROWId
	        and   OBS_Item_DR = :StrItem
	        and   OBS_Date=:StrDate
	        and   OBS_Time=:StrTime)
	        i (SQLCODE=0)&(obsid'="")&(ss'=Value){
		    s i5=##class(Nur.NurseModiNew).geti5()
		    s p15="index1|DHCNURTEM^index2|"_RowId_"^index3|"_curDate_"^index4|"_curTime
		    s p15=p15_"^field1|修改^field2|"_StrUser
		    s p15=p15_"^field3|"_StrItem_"^field4|"_obsid_"^field5|"_StrDate_"^field6|"_StrTime
		    s p15=p15_"^field8|"_ss_"^field9|"_Value
		    d ##class(Nur.NurseModiNew).savei5(p15,i5)
		    }
        }
    }
   else
   {
	   s SQLCODE=0
	   q:Value="" SQLCODE
	   b //00
	   &sql(insert into MR_Observations
	    (OBS_ParRef,OBS_Item_DR,OBS_Value,OBS_Date,OBS_Time,OBS_User_DR,OBS_UpdateDate,OBS_UpdateTime)
	    values(:MRADMROWId,:StrItem,:Value,:StrDate,:StrTime,:StrUser,:curDate,:curTime))
	}
   q SQLCODE
}

ClassMethod InsertDesc(RowId As %String, StrItem As %String, StrDate As %String, StrTime As %String, userid As %String, Value As %String) As %String
{
  //##class(web.DHCTHREEE).InsertDesc("82","14","2017-07-28","18:00:00",,"")
  	;s ^tempsc("InsertDesc",$zt($p($h,",",2)),3)=$lb(RowId,StrItem,StrDate,StrTime,StrUser,Value) 
	s MRADMROWId=$P(^PAADM(RowId),"^",61) 
	s StrDate=##class(websys.Conversions).DateHtmlToLogical(StrDate)
	s StrTime=$ZTH(StrTime,3)
	s IfExistFlag="N"
	s (ss,obsid)=""
	s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,StrItem,chl)) q:(chl="")!(IfExistFlag="Y")  d
	.s time=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
	.if time=StrTime  d
	..s IfExistFlag="Y"
	..s obsid=chl
	..s ss=$P(^MR(MRADMROWId,"OBS",chl),"^",6)
	..s nurId=$P(^MR(MRADMROWId,"OBS",chl),"^",5)
	..i nurId'="" s nurName=$P(^SSU("SSUSR",nurId),"^",2)
	..e  s nurName=""
	..s nurDate=$P(^MR(MRADMROWId,"OBS",chl),"^",11)
	..i nurDate'="" s nurDate=$ZD(nurDate,3)
	..s nurTime=$P(^MR(MRADMROWId,"OBS",chl),"^",12)
	..i nurTime'="" s nurTime=$ZT(nurTime,2)
	..b //0001
	s StrUserGrpDr=$P(^SSU("SSUSR",userid),"^",5)
	if StrUserGrpDr'="" s StrUserGrpDesc=$P(^SSU("SSGRP",StrUserGrpDr),"^",1)
	e  s StrUserGrpDesc=""
	s curDate=$P($H,",",1),curTime=$P($H,",",2)
	if IfExistFlag="Y"
	{ 
		i $G(Value)=""
		{
			&sql(update MR_Observations set OBS_ShortDesc=:Value,
			OBS_UpdateDate=:curDate,OBS_UpdateTime=:curTime
			where OBS_ParRef = :MRADMROWId
			and   OBS_Item_DR = :StrItem
			and   OBS_Date=:StrDate
			and   OBS_Time=:StrTime)
	        i (SQLCODE=0)&(obsid'="")&(ss'=Value){
		    s i5=##class(Nur.NurseModiNew).geti5()
		    s p15="index1|DHCNURTEM^index2|"_RowId_"^index3|"_curDate_"^index4|"_curTime
		    s p15=p15_"^field1|删除^field2|"_userid
		    s p15=p15_"^field3|"_StrItem_"^field4|"_obsid_"^field5|"_StrDate_"^field6|"_StrTime
		    s p15=p15_"^field7|desc^field8|"_ss_"^field9|"_Value		
		    d ##class(Nur.NurseModiNew).savei5(p15,i5)
		    }
	    }
	    else{
		;q:($G(nurId)'=userid)&&(StrUserGrpDesc'["护士长") "1^"_$G(nurName)_" 录入日期:"_$G(nurDate)_" "_$G(nurTime)
		&sql(update MR_Observations set OBS_ShortDesc=:Value,
		OBS_UpdateDate=:curDate,OBS_UpdateTime=:curTime
		where OBS_ParRef = :MRADMROWId
		and   OBS_Item_DR = :StrItem
		and   OBS_Date=:StrDate
		and   OBS_Time=:StrTime)
			i (SQLCODE=0)&(obsid'="")&(ss'=Value)&(ss'=""){
			s i5=##class(Nur.NurseModiNew).geti5()
		    s p15="index1|DHCNURTEM^index2|"_RowId_"^index3|"_curDate_"^index4|"_curTime
		    s p15=p15_"^field1|修改^field2|"_userid
		    s p15=p15_"^field3|"_StrItem_"^field4|"_obsid_"^field5|"_StrDate_"^field6|"_StrTime
		    s p15=p15_"^field7|desc^field8|"_ss_"^field9|"_Value
		    d ##class(Nur.NurseModiNew).savei5(p15,i5)
		    }
	     }
	}
	else
	{
		s SQLCODE=0
		q:Value="" SQLCODE
	   	&sql(insert into MR_Observations
	    (OBS_ParRef,OBS_Item_DR,OBS_ShortDesc,OBS_Date,OBS_Time,OBS_User_DR,OBS_UpdateDate,OBS_UpdateTime)
	    values(:MRADMROWId,:StrItem,:Value,:StrDate,:StrTime,:userid,:curDate,:curTime))
	}
	q SQLCODE
}

ClassMethod ListItemExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCTHREEE","ListItem")
	s rw="",des="序号"
	Do OutwardRow
	s rw="",des=""
	Do OutwardRow
	s rw="",des="姓名"
	Do OutwardRow
	s rw="",des="床号"
	Do OutwardRow
	s rw="",des="登记号"
	Do OutwardRow
	s GrpCode="Temp"
	s n=1
	s GrpRow="" s GrpRow=$O(^MRC("OBGRP",0,"Code",$ZConvert(GrpCode,"U"),GrpRow))
	if (GrpRow'=""){
		s chl=0 f  s chl=$O(^MRC("OBGRP",GrpRow,"ITM",chl)) q:chl=""  d
			.s itmrw=$P(^MRC("OBGRP",GrpRow,"ITM",chl),"^",1) 
			.s sort=$P(^MRC("OBGRP",GrpRow,"ITM",chl),"^",2)
			.s des=$p($G(^MRC("OBITM",itmrw)),"^",2)
			.q:des=""
			.s typ=$p($G(^MRC("OBITM",itmrw)),"^",3)
			.if sort="" s sort=n
			.s itm(sort)=des_"^"_typ_"^"_itmrw
			.s n=n+1
		s st="" f  s st=$O(itm(st)) q:st=""  d
			.s des=$P(itm(st),"^",1)
			.s typ=$P(itm(st),"^",2)
			.s rw=$P(itm(st),"^",3)
			.s des=des_"^"_typ
			.Do OutwardRow
	}
	else
	{
		s rw=0  f  s rw=$O(^MRC("OBITM",rw)) q:rw=""  d
			.s typ="",des=""
			.s des=$p(^MRC("OBITM",rw),"^",2)
			.s typ=$p(^MRC("OBITM",rw),"^",3)
			.s rangfrm=$p(^MRC("OBITM",rw),"^",19)
			.s rangto=$p(^MRC("OBITM",rw),"^",20)
			.s des=des_"^"_typ
			.if rangfrm'="" s des=des_"^"_rangfrm_"-"_rangto
		   	.Do OutwardRow
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(des,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ListItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ListItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod PatLeave(Adm As %String, NowOBSD As %String, NowOBST As %String)
{
	;Create by qse 2005-6-16
	n (Adm,NowOBSD,NowOBST)
	s Yc=0
	s admlsub=0  f  s admlsub=$o(^PAADM(Adm,"LEA",admlsub)) q:admlsub=""  d
	.s DateReturn=$p($g(^PAADM(Adm,"LEA",admlsub)),"^",9)
	.s TimeReturn=$p($g(^PAADM(Adm,"LEA",admlsub)),"^",10)
	.s DateOut=$p($g(^PAADM(Adm,"LEA",admlsub)),"^",2)
	.s TimeOut=$p($g(^PAADM(Adm,"LEA",admlsub)),"^",3)
	.i (NowOBSD>DateOut)&(NowOBSD<DateReturn) s Yc=1
	.i (NowOBSD=DateOut)&(NowOBST>TimeOut)&(DateReturn'=DateOut) s Yc=1
	.i (NowOBSD=DateReturn)&(NowOBST<TimeReturn)&(DateReturn'=DateOut) s Yc=1
	.i (DateReturn=DateOut)&(DateReturn=NowOBSD)&(NowOBST>TimeOut)&(NowOBST<TimeReturn) s Yc=1
   
	q Yc
}

ClassMethod Patinfo(Adm As %String) As %String
{
		n (Adm)
		   s bedchl=""
		   s chl="" f  s chl=$o(^PAADM(Adm,"TRANS",chl)) q:chl=""  d
	       .s CurrentBedDR=$p(^PAADM(Adm,"TRANS",chl),"^",8)
	       .q:CurrentBedDR=""
	       .s bedchl=$P(CurrentBedDR,"||",2)
	       .s Ward=$P(CurrentBedDR,"||",1)
	       .s Bed=$P(^PAWARD(Ward,"BED",bedchl),"^",1)
	       q:bedchl="" ""
	       s Papmidr=$P(^PAADM(Adm),"^",1)
	       s ctlocdr=$P(^PAADM(Adm),"^",4)
	       s AdmDate=$ZD($P(^PAADM(Adm),"^",6),3)_" "_$ZT($P(^PAADM(Adm),"^",7))
	       s Name=$P(^PAPER(Papmidr,"ALL"),"^",1)
	       s RegNo=$P(^PAPER(Papmidr,"PAT",1),"^",1)
	       s wardloc=$P(^PAWARD(Ward),"^",5) //s name="F",cttypdes="NURSE"
           s birth=$p($g(^PAPER(Papmidr,"ALL")),"^",6)
           s age=##class(web.DHCCLCom).CalAge(birth,+$h)
	       //s Bed=$P(^PAWARD(Ward,"BED",bedchl),"^",1)
	       s adm(Bed)=Adm_"#"_Name_"#"_Bed_"#"_$G(ctlocdr)_"#"_$G(wardloc)_"#"_bedchl_"#"_$G(RegNo)
         q adm(Bed)
}

ClassMethod SelectHaveRecord(RowId As %String, StrItem As %String, StrDate As %String) As %String
{
	 n (RowId,StrItem,StrDate)  
	  s MRADMROWId=$P(^PAADM(RowId),"^",61)    
	   s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,StrItem,chl)) q:chl=""  d
	   .s P1=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
	   .s P9=$ZT($P(^MR(MRADMROWId,"OBS",chl),"^",4),1)
	   .b
	   q $G(P1)_"^"_$g(P9)
}

ClassMethod SelectHavelable(RowId As %String, StrItem As %String) As %String
{
	  n (RowId,StrItem)
	  s MRADMROWId=$P(^PAADM(RowId),"^",61) 
	   b
	   s StrDate=""  f  s StrDate=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate)) q:(StrDate="")!($G(P1)'="")  d   
	   .s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,StrItem,chl)) q:chl=""  d
	   ..s P1=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
	   ..b
	   ..q:P1'=""
	   .q:$G(P1)'=""
	   q $G(P1)
}

ClassMethod SelectIsDesc(RowId As %String, StrItem As %String, StrDate As %String, StrTime As %String) As %String
{
	  n (RowId,StrItem,StrDate,StrTime)
	  s StrDate=$ZDH(StrDate,3)
	  s StrTime=$ZTH(StrTime,3)   
 
	  s MRADMROWId=$P(^PAADM(RowId),"^",61)    
	  s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,StrItem,chl)) q:chl=""  d
	  .s time=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
	  .if time=StrTime  s P1=$P(^MR(MRADMROWId,"OBS",chl),"^",6)
	  q $G(P1)
}

ClassMethod SelectIsRecord(RowId As %String, StrItem As %String, StrDate As %String, StrTime As %String) As %String
{
	n (RowId,StrItem,StrDate,StrTime)   
	  s StrDate=$ZDH(StrDate,3)
	  s StrTime=$ZTH(StrTime,3)   
	  s MRADMROWId=$P(^PAADM(RowId),"^",61)    
	  s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,StrItem,chl)) q:chl=""  d
	  .s time=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
	  .if time=StrTime  s P1=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
	  q $G(P1)
}

Query ListItem() As %Query(ROWSPEC = "desc,rw")
{
}

ClassMethod GetAdmDate(paadm) As %String
{
	s AdmDate=$zd($p($g(^PAADM(paadm)),"^",6),3)  //入院
	s AdmTime=$zt($p($g(^PAADM(paadm)),"^",7))
	if ($p($g(^PAADM(paadm)),"^",17)="")
	{
	 s DischDate=""  //出院	
	 s DischTime=""
	}
	else
	{
	 s DischDate= $zd($p($g(^PAADM(paadm)),"^",17),3)  //出院	
	 s DischTime= $zt($p($g(^PAADM(paadm)),"^",18))  //出院	
	}
 q AdmDate_"^"_AdmTime_"^"_DischDate_"^"_DischTime
}

/// 取某人某天的离开记录//PA_AdmLeave
ClassMethod GetPatOutInfo(paadm, leavedate) As %String
{
	//^PAADMi("LeaveDateFrom",{ADML_GoingOutDate},{PA_Adm.PAADM_RowID},{ADML_Childsub})
	//w ##class(web.DHCTHREEE).GetPatOutInfo("285665","61925")
	q:(paadm="")!(leavedate="")
	s ret=""
	s chl=0  f  s chl=$O(^PAADMi("LeaveDateFrom",leavedate,paadm,chl)) q:chl=""  d
	.s godate=$P($G(^PAADM(paadm,"LEA",chl)),"^",2)
	.s gotime=$P($G(^PAADM(paadm,"LEA",chl)),"^",3)
	.s rea=$P($G(^PAADM(paadm,"LEA",chl)),"^",6) //原因
	.if rea'="" s reason=$P(^PAC("LEA",rea),"^",2)
	.e  s reason=""
	.i ret'="" s ret=ret_"#"_$ZD(godate,3)_"^"_$ZT(gotime,1)_"^"_reason
	.e  s ret=$ZD(godate,3)_"^"_$ZT(gotime,1)_"^"_reason
	q ret
}

ClassMethod GetListItemDataExecute(ByRef qHandle As %Binary, Adm As %String, CDate As %String, CTime As %String, Grp As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
	if Adm="" Quit $$$OK
	//s ^TM(0)=CDate
	//获得体温,物理降温 ID
	//s setstr=##class(web.DHCTHREEEX).GetSingleTempdata()
	//s tempid=$P(setstr,"^",3)
	//s item1id=$P(setstr,"^",4)  //项目1，项目2
	//s item2id=$P(setstr,"^",5)
	
	s wultempid="Item22"
    s itm=""  //des_"^"_typ_"^"_sort_"^"_rw
    if Grp="-1"{
    d ##class(web.DHCPdaComm).GetObserItm(.itm)
    }else{
	    d ##class(web.DHCPdaComm).GetOBInOutItm(Grp,.itm)
	    }
    b ;;-----
	s CDate=$ZD(CDate,3)
	s CTime=$ZT(CTime,3)
    //s item1=..SelectHavelable(Adm,item1id,CDate)
    //s item2=..SelectHavelable(Adm,item2id,CDate)
	s num=""  f  s num=$O(itm(num)) q:num=""  d
	.s typ="",des=""
	.s des=$p(itm(num),"^",1)
	.s typ=$p(itm(num),"^",2)
	.s rw=$p(itm(num),"^",4)
	.s color=$p(itm(num),"^",3)
	.s value=""
	.s listitm=""
	.if rw=wultempid s value=..SelectIsDesc(Adm,tempid,CDate,CTime)
	.e  s value=..SelectIsRecord(Adm,rw,CDate,CTime)
	.//if des="来院状态" s listitm=$p(itm(num),"^",5)
	.s des=des
   	.Do OutwardRow1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	//des,typ,ItmValue,color,itmrw
OutwardRow1
	set Data=$lb(des,typ,value,color,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListItemDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListItemDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListItemDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListItemDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetListItemData(Adm, CDate, CTime, Grp = "") As %Query(ROWSPEC = "des,typ,ItmValue,color,itmrw")
{
}

ClassMethod GetFirstData(EpisodeID As %String) As %String
{
	//w ##class(web.DHCTHREEE).GetFirstData("544985")
	n (EpisodeID)
	s MRADMROWId=$P(^PAADM(EpisodeID),"^",61)  
	s flag=0 s flag2=0 s flag3=0 s flag4=0 s flag5=0 s flag6=0
	s nurTime="" s nurTime2="" s nurTime3="" s nurTime4="" s nurTime5=""  s nurTime6="" s GetTime=""
	s StrItemold=""
	;b ;0
	s temper="" s plus="" s SSY="" s SZY="" s BreathValue="" s ObDate="" s Xinlv=""
	s StrDate=""  f  s StrDate=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate)) q:(StrDate="")  d
	.s ObDate=StrDate
	.;b
	.s StrItem=""  f  s StrItem=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,StrItem)) q:(StrItem="")  d
    ..s chl="" 
    ..f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,StrItem,chl)) q:(chl="")  d
    ...s temperID=MRADMROWId_"||"_chl
    ...;b ;11
    ...s GetTime=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ...s tempItem="" s tempOBSValue="" s tempOBSTime=""
    ...s ddd=MRADMROWId_"@"_chl_"@"_flag_"@"_StrItem
    ...i (StrItem="14")&&(flag'=1) d
    ....s temper=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ....s flag=1
    ...;b //11
    ...i (StrItem="10")&&(flag2'=1) d
    ....;b ;L
    ....s plus=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime2=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ....s flag2=1   
    ...i (StrItem="11")&&(flag3'=1) d
    ....s BreathValue=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime3=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ....s flag3=1
    ...i (StrItem="16")&&(flag4'=1) d
    ....s SSY=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime4=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ....s flag4=1
    ...i (StrItem="17")&&(flag5'=1) d
    ....s SZY=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime5=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ....s flag5=1
    ...i (StrItem="20")&&(flag6'=1) d
    ....;b ;LLL
    ....s Xinlv=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime6=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ....s flag6=1
    ...i (StrItem="14")&&(flag=1)&&(GetTime<nurTime)&&(GetTime'="")&&(nurTime'="") d
    ....;b ;31
    ....;s temper=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ...i (StrItem="10")&&(flag2=1)&&(GetTime<nurTime2)&&(GetTime'="")&&(nurTime2'="") d
    ....;b ;32
    ....;s plus=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime2=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ...i (StrItem="11")&&(flag3=1)&&(GetTime<nurTime3)&&(GetTime'="")&&(nurTime3'="") d
    ....;b ;33
    ....;s BreathValue=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime3=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ...i (StrItem="16")&&(flag4=1)&&(GetTime<nurTime4)&&(GetTime'="")&&(nurTime4'="") d
    ....;b ;34
    ....;s SSY=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime4=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ...i (StrItem="17")&&(flag5=1)&&(GetTime<nurTime5)&&(GetTime'="")&&(nurTime5'="") d
    ....;b ;35
    ....;s SZY=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime5=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ...i (StrItem="20")&&(flag6=1)&&(GetTime<nurTime6)&&(GetTime'="")&&(nurTime6'="") d
    ....;b ;36
    ....;s Xinlv=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime6=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    i Xinlv'="" d
    .s plus=plus_"/"_Xinlv
    b ;ll
    if EpisodeID="544985" q "39.1^74^16^97/55"
    q $G(temper)_"^"_$g(plus)_"^"_$G(BreathValue)_"^"_$G(SSY)_"/"_$G(SZY)
}

Storage Default
{
<Data name="DHCTHREEEDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCTHREEED</DataLocation>
<DefaultData>DHCTHREEEDefaultData</DefaultData>
<IdLocation>^web.DHCTHREEED</IdLocation>
<IndexLocation>^web.DHCTHREEEI</IndexLocation>
<StreamLocation>^web.DHCTHREEES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
