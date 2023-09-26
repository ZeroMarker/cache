Import SQLUser

/// 查询出院病人列表
/// 查询新入院卷信息－打印索引卡片
/// By wuqk 2007－03
/// Modify by 2007-05-22  for Structure Rebuild
Class web.DHCWMRVolDisAdmQry Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 211;

/// Update: 2009-03-10 刘学峰 修改查询参数，将CurrDate修改为StartDate和EndDate
/// Update: 2009-06-12 刘学峰 根据病案类型过滤出院列表
/// Update: 2010-04-15 刘学峰 增加入参DispalyFlag
ClassMethod GetDischargeList(JIndex, cTypeDr As %String, StartDate As %String, EndDate As %String, DispalyFlag As %String)
{
	n (JIndex,cTypeDr,StartDate,EndDate,DispalyFlag)
	s:JIndex="" JIndex=$j
	s num=0

	s:StartDate="" StartDate=+$h
	s:StartDate["/" StartDate=$zdh(StartDate,4)
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	
	s:EndDate="" EndDate=+$h
	s:EndDate["/" EndDate=$zdh(EndDate,4)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s EndDate=+EndDate
	;s EndDate=EndDate+1
	k ^CacheTemp("DHCWMRADLIST",JIndex)
	s HospCode=##class(web.DHCWMRMedBase01).GetDefaultHospCode() //add by liuxuefeng 2009-12-07

	if ((DispalyFlag="")||(DispalyFlag="N")){
		;Get cStatusDR by cTypeDr,$h
		;0、当前病案类型的工作流，找到第一个状态（在院） *
		;s cStatusDR="1"
		s cTypeDrTmp=cTypeDr
		s:+cTypeDrTmp<=0 cTypeDrTmp=7 //add by liuxuefeng 2010-04-16 如果传入病案类型为空，取病案类型为7的工作流
		s sFlow=##class(web.DHCWMRWorkFlowCtl).GetWFLByTypeActiveDate(cTypeDrTmp,"Y",$zd(+$h,3))
	    s aFlow=$p(sFlow,$c(1),1)
	    s cStatusDR=$p(aFlow,"^",3)

		;^DHCWMRVOL(0,"VolAFS",{IsActive},{InFlow},{Status_Dr},{DHC_WMR_Main.Rowid},{ChildSub})
		q:'$d(^DHCWMRVOL(0,"VolAFS","Y","Y",cStatusDR)) JIndex_"^"_num
		
		;1、在院状态的卷
		s VolRowid=""
		;^DHCWMRVOL(0,"VolAFS",{IsActive},{InFlow},{Status_Dr},{Rowid})
		f  s VolRowid=$o(^DHCWMRVOL(0,"VolAFS","Y","Y",cStatusDR,VolRowid)) q:VolRowid=""  d
		.s sVol=$g(^DHCWMRVOL(+VolRowid))
		.q:$p(sVol,"^",7)'="Y"                          //卷非活动
		.s MainRowid=+$p(sVol,"^",1)
		.q:$p($g(^DHCWMRMAIN(MainRowid)),"^",6)'="Y"    //病案主信息非活动
		.s MrType=$p($g(^DHCWMRMAIN(MainRowid)),"^",1)		//add by liuxuefeng 2009-06-12 根据病案类型过滤出院病人
		.q:(MrType'=cTypeDr)&&(+cTypeDr>0)								//add by liuxuefeng 2009-06-12
		.s MrNO=$p($g(^DHCWMRMAIN(MainRowid)),"^",2)	
		.s paadm=+$p(sVol,"^",2)
		.q:paadm=0
		.;3、查询Vol的adm，此adm之后，新卷adm之前的adm都属于此卷
		.;modify by liuxuefeng 2010-01-15 只有友谊医院检查
		.i HospCode="BeiJing_YY" d
		..s sPaadm=..GetAdmList(+VolRowid)
		..s LastAdm=$p(sPaadm,"^",$l(sPaadm,"^"))
		..s:LastAdm="" LastAdm=paadm
		.e  d
		..s LastAdm=paadm
		.;4、最后一个adm是否出院状态
		.s VisitStatus=$p($g(^PAADM(LastAdm)),"^",20)
		.//modify by liuxuefeng 2010-04-22 沈阳医大和妇产医院不判断VisitStatus										//test
		.q:(VisitStatus'="A")&&(VisitStatus'="D")
		.q:(VisitStatus'="D")&&(HospCode'="ShenYang_YDYFY")&&(HospCode'="BeiJing_FC")
		.;s DisDate=$p(##Class(web.DHCWMRMedBase01).GetDisDateTime(LastAdm),",",1)
		.;s:HospCode="ShenYang_YDYFY" DisDate=$p(..IGetDisDateTimeFromStatistic(LastAdm),"^",1) //add by liuxuefeng 2009-12-07 医大一院根据统计组出院日期查询
		.s DisDate=$p(##Class(web.DHCWMRBasePaadm).GetDisAdmDate(LastAdm)," ",1)
		.q:+DisDate=0
		.s DisDate=$zdh(DisDate,3)
		.q:(+DisDate<StartDate)||(+DisDate>EndDate)   ;取时间段内出院的病人
		.;5、按照病区排序
		.;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.s Ward=+$p($g(^PAADM(LastAdm)),"^",70)			;表PAC_Ward的RowId
		.s WardIndex=..GetWardIndex(Ward)				;表CT_Loc的RowId
		.s:WardIndex="" WardIndex="N"
		.;add 2010-11-18
		.;6、按照主治医生排序
		.s DocDr=+$p($g(^PAADM(+LastAdm)),"^",9)
		.s ^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,DocDr,LastAdm)=MrNO_"^"_VolRowid_"^"_MrType	//add VolRowid 2010-04-16
		.s num=num+1

	}elseif(DispalyFlag="A"){
			s DisIndex=##Class(web.DHCWMRBasePaadm).GetDisDateIndex()
			f DisDate=StartDate:1:EndDate d
			.s paadm=0
			.f  s paadm=$o(^PAADMi(DisIndex,DisDate,paadm)) q:paadm=""  d
			..s AdmType=$p($g(^PAADM(+paadm)),"^",2) 		//add
			..q:AdmType'="I"								//add
			..s VisitStatus=$p($g(^PAADM(+paadm)),"^",20)	//add
			..q:(VisitStatus'="A")&&(VisitStatus'="D")		//add
			..;^DHCWMRVOL(0,"PaadmDr",{Paadm_Dr},{Rowid})
			..s tmpVolRowid="",VolIsActive=""
			..s VolRowid=0 									//add 2010-09-07 fix bug
			..f  s tmpVolRowid=$o(^DHCWMRVOL(0,"PaadmDr",+paadm,tmpVolRowid),-1) q:((tmpVolRowid="")||(VolIsActive="Y"))  d
			...s VolIsActive=$p($g(^DHCWMRVOL(+tmpVolRowid)),"^",7)
			...s:VolIsActive="Y" VolRowid=tmpVolRowid
			..q:+VolRowid=0
			..s MainDr=$p($g(^DHCWMRVOL(VolRowid)),"^",1)
			..s MainIsActive=$p($g(^DHCWMRMAIN(MainDr)),"^",6)
			..q:MainIsActive'="Y"
			..s MrType=$p($g(^DHCWMRMAIN(MainDr)),"^",1)
			..q:(MrType'=cTypeDr)&&(+cTypeDr>0)
			..s MrNO=$p($g(^DHCWMRMAIN(MainDr)),"^",2)
			..;5、按照病区排序
			..;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			..s Ward=+$p($g(^PAADM(paadm)),"^",70)			;表PAC_Ward的RowId
			..s WardIndex=..GetWardIndex(Ward)				;表CT_Loc的RowId
			..s:WardIndex="" WardIndex="N"
			..;add 2010-11-18
			..;6、按照主治医生排序
			..s DocDr=+$p($g(^PAADM(+paadm)),"^",9)
			..s ^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,DocDr,paadm)=MrNO_"^"_VolRowid_"^"_MrType
			..s num=num+1

	}	
	q JIndex_"^"_num
}

ClassMethod GetDataBy(JIndex)
{
	n (JIndex)
	s s=""
	q:'$d(^CacheTemp("DHCWMRADLIST",JIndex))
	s num=0
	s WardIndex=""
	f  s WardIndex=$o(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex)) q:WardIndex=""  d
	.s tempAdm=""
	.f  s tempAdm=$o(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,tempAdm)) q:(tempAdm="")!(num=100)  d
	..s MrNO=$g(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,tempAdm))
	..s stmp=$$GetData()
	..s s=s_stmp_$c(1)
	..s num=num+1
	..k ^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,tempAdm)
	k:(WardIndex="")&(tempAdm="") ^CacheTemp("DHCWMRADLIST",JIndex)
	q s
GetData()
    s stmp=""
    ;s tmp=$g(^PAADM(+paadm))
    s tmp=$g(^PAADM(+tempAdm))
    s papmi=+$p(tmp,"^",1)
    s Ward=+$p(tmp,"^",70)
    s WardDesc="",DischgDate=""
    s:Ward'=0 WardDesc=$p($g(^PAWARD(Ward)),"^",2)
    s:$p(tmp,"^",17)'="" DischgDate=$zd($p(tmp,"^",17),3)
    s papmino=$p(^PAPER(papmi,"PAT",1),"^",1)
    s name=$p($g(^PAPER(papmi,"ALL")),"^",1)
    s stmp=WardDesc_"^"_DischgDate_"^"_papmino_"^"_name_"^"_MrNO
    q stmp
}

ClassMethod GetWardIndex(Ward)
{
	n (Ward)		;表PAC_Ward的RowId
	s PAWARDStr=$g(^PAWARD(Ward))
	s WARDLocationDR=$p(PAWARDStr,"^",5)		;字段WARD_LocationDR，指向表CT_Loc
	q WARDLocationDR
}

ClassMethod GetAdmList(VolRowid)
{
	n (VolRowid)
	s sPaadm=""
	q:'$d(^DHCWMRVOL(+VolRowid)) sPaadm
	s sVol=$g(^DHCWMRVOL(+VolRowid))
	s MainRowid=+$p(sVol,"^",1)
	s paadm=+$p(sVol,"^",2)
	s IsActive=$p(sVol,"^",7)

	q:paadm=0 sPaadm
	q:IsActive'="Y" sPaadm
	
	s patientId=+$p($g(^PAADM(paadm)),"^",1)
	s AdmType=$p($g(^PAADM(paadm)),"^",2)
	q:AdmType="" sPaadm
	
	;2、判断此病案号码下是否有更新的卷
	s NextVol="",IsActive=""
	/*
	s TempVol=VolRowid
	f  s TempVol=$o(^DHCWMRVOL(0,"Main",MainRowid,TempVol)) q:(TempVol="")!(IsActive="Y")  d
	.s IsActive=$p(^DHCWMRVOL(+TempVol),"^",7)
	.s NextVolPaadm=+$p($g(^DHCWMRVOL(+TempVol)),"^",2)
	.q:NextVolPaadm=0
	.s:IsActive="Y" NextVol=+TempVol
	.;q:IsActive="Y"
	*/
	s TempVol=0
	f  s TempVol=$o(^DHCWMRVOL(0,"Main",MainRowid,TempVol)) q:TempVol=""  d
	.s IsActive=$p(^DHCWMRVOL(+TempVol),"^",7)
	.s NextVolPaadm1=+$p($g(^DHCWMRVOL(+TempVol)),"^",2)
	.q:NextVolPaadm1=0
	.q:IsActive'="Y"
	.s VolPaadmList(NextVolPaadm1)=TempVol
	s NextVolPaadm=$o(VolPaadmList(paadm))
	s:NextVolPaadm'="" NextVol=VolPaadmList(NextVolPaadm1)
	
	i NextVol="" d
	.s LastPaadm=$o(^PAPERdr(patientId,"ADM",AdmType,""),-1)
	e  d
	.s LastPaadm=$o(^PAPERdr(patientId,"ADM",AdmType,NextVolPaadm),-1)
	
	;From paadm to LastPaadm,List by "^"
	s sPaadm=paadm
	s TempAdm=paadm
	f  s TempAdm=$o(^PAPERdr(patientId,"ADM",AdmType,TempAdm)) q:(TempAdm="")!(TempAdm>LastPaadm)  d
	.s VisitStatus=$p($g(^PAADM(TempAdm)),"^",20)
	.q:VisitStatus="C"                           ;Cancel
	.s sPaadm=sPaadm_"^"_+TempAdm
	q sPaadm
}

/// add "DispalyFlag"、"VolRowid" by liuxuefeng 2010-04-16
ClassMethod BuildDataDischarge(repid, ind, Adm, MrNo, MrType, DispalyFlag, VolRowid, dischCondit)
{
	n (repid, ind, Adm, MrNo, MrType, DispalyFlag, VolRowid,dischCondit)
	;s ^CacheTemp("BuildDataDischarge")=dischCondit
	s tmp=$g(^PAADM(+Adm))
    s papmi=+$p(tmp,"^",1)
    s Ward=+$p(tmp,"^",70)
    s CTLoc=+$p(tmp,"^",4)
    s docDr=+$p(tmp,"^",9)
    s MrDoctor=$p($g(^CTPCP(docDr,1)),"^",2)       
    s WardDesc="",DischgDate="",LocDesc=""
    s:Ward'=0 WardDesc=$p($g(^PAWARD(Ward)),"^",2)
    s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)			//add by liuxuefeng	2009-12-05 去除"-"
    ;s:$p(tmp,"^",17)'="" DischgDate=$zd($p(tmp,"^",17),3)
    ;s DischgDate=$p(##Class(web.DHCWMRMedBase01).GetDisDateTime(+Adm),",",1)
    
    s HospCode=##class(web.DHCWMRMedBase01).GetDefaultHospCode() //add by liuxuefeng 2009-12-07
	s DischgDate=$p(##Class(web.DHCWMRBasePaadm).GetDisAdmDate(+Adm)," ",1) //modify by liuxuefeng 2010-04-08
	;s:HospCode="ShenYang_YDYFY" DischgDate=$p(..IGetDisDateTimeFromStatistic(+Adm),"^",1) //add by liuxuefeng 2009-12-07 医大一院根据统计组出院日期查询
	
    s DischgDays=""								//add by liuxuefeng 2009-12-05					
	s:DischgDate'="" DischgDays=+$h-$zdh(DischgDate,3)	//add by liuxuefeng 2009-12-05
    ;s:DischgDate'="" DischgDate=$zd(+DischgDate,3)
    s:CTLoc'=0 LocDesc=$p($g(^CTLOC(+CTLoc)),"^",2)
    s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)			//add by liuxuefeng	2009-12-05 去除"-"
    s PapmiNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
    s Name=$p($g(^PAPER(papmi,"ALL")),"^",1)

	
	Set Data=$lb("")
	Set $li(Data,1)=WardDesc     //WardDesc
	Set $li(Data,2)=DischgDate   //DischgDate
 	Set $li(Data,3)=PapmiNo      //PapmiNo
	Set $li(Data,4)=Name         //PatName
	Set $li(Data,5)=MrNo         //MrNO
	
	s MrTypeId=+MrType
	s MrTypeDesc=$p(^DHCWMRDIC(MrTypeId),"^",3)
	Set $li(Data,6)=MrTypeId     	//MrTypeId
	Set $li(Data,7)=MrTypeDesc      //MrType
	Set $li(Data,8)=LocDesc       	//LocDesc Add BY wuqk 2007-07-30
 	Set $li(Data,9)=MrDoctor     	//MrDoctor Add By LYH 2009-11-27
 	Set $li(Data,10)=DischgDays     //DischgDays Add By liuxuefeng 2009-12-05
 	
 	s LendOutFlag="",LendOutType=""
 	////2010-01-28 增加判断此病人对应病案/病案卷是否借出的判断 复兴医院
 	if (HospCode="BeiJing_FX"){
	 	s LOWorkItemID=8				//病案借阅对应操作项目RowID
	 	s LOStr=..GetLendOutType(LOWorkItemID,papmi,MrType)
	
	 	s LendOutFlag=$p(LOStr,"^",1)		//是否借出
	 	s LendOutType=$p(LOStr,"^",2)		//借出类型
 	}
 	Set $li(Data,11)=LendOutFlag     
 	Set $li(Data,12)=LendOutType 
 	//////////////////////////////////////////
 	//2010-04-16 当查询所有出院病人时，增加查询病案回收信息
 	s RetFlag="",RetDate="",RetUser="",CurrVolStatus="",CurrVolStatusDr=""
 	if (DispalyFlag="A"){
	 	s VolStr=$g(^DHCWMRVOL(+VolRowid))
	 	s VolStatusDr=$p(VolStr,"^",6)
	 	//获取当前病案类型的工作流，找到第一个状态（在院） *
		s sFlow=##class(web.DHCWMRWorkFlowCtl).GetWFLByTypeActiveDate(MrType,"Y",$zd(+$h,3))
	    s InitStatusDR=$p($p(sFlow,$c(1),1),"^",3) 	//工作流中初始状态
	    s RetStatusDR=$p($p(sFlow,$c(1),2),"^",3) 	//工作流中病案收回
	    s RetFlag="",RetDate="",RetUser=""
	    s:VolStatusDr'=InitStatusDR RetFlag="Y"		//当前状态不为第一个初始状态，则收回标志置为“Y”
	    ;^DHCWMRVOL({DHC_WMR_MainVolume.Rowid},"S",0,"Status",{Status_Dr},{ChildSub})
	    s ChildSub=""
		s ChildSub=$o(^DHCWMRVOL(+VolRowid,"S",0,"Status",RetStatusDR,ChildSub),-1) //modify 2010-11-17 如果病案卷被多次回收，显示最后一次回收信息
		;^DHCWMRVOL({DHC_WMR_MainVolume.Rowid},"S",{ChildSub})
		s RetDate=$p($g(^DHCWMRVOL(+VolRowid,"S",+ChildSub)),"^",3)
		s:RetDate'="" RetDate=$zd(RetDate,3) 
		s RetUserID=$p($g(^DHCWMRVOL(+VolRowid,"S",+ChildSub)),"^",2)
		s:RetUserID'="" RetUser=$p($g(^SSU("SSUSR",+RetUserID)),"^",2)
		s CurrVolStatusDr=$p($g(^DHCWMRVOL(+VolRowid)),"^",6)
	    s CurrVolStatus=$p($g(^DHCWMRWITM(+CurrVolStatusDr)),"^",2)
	    s:CurrVolStatusDr=InitStatusDR RetDate="",RetUser=""  //add 2010-11-17如果病案卷状态为初始状态，回收日期和回收人为空
 	}
 	;set disch=##Class(web.DHCWMRDischConditQuery).DischCondit(Adm)
 	s mrAdmId=$p(tmp,"^",61)
 	s dischDesc=""
 	if (mrAdmId'=""){
	  ;b ;mrAdmId
	  s dischId=$p($g(^MR(+mrAdmId,"PRO",1)),"^",10)
	  s:dischId'="" dischDesc=$p($g(^PAC("DISCON",+dischId)),"^",2)
	}
    Set $li(Data,13)=RetFlag     	//病案收回标志
 	Set $li(Data,14)=RetDate		//病案收回日期
 	Set $li(Data,15)=RetUser		//病案收回操作员
 	Set $li(Data,16)=CurrVolStatus	//卷当前状态
 	//////////////////////////////////////////////
 	Set $li(Data,17)=VolRowid		//卷Rowid
 	set $li(Data,18)=dischDesc
 	s (deathDate,deathTime)=""
 	s deathDate=$p($g(^PAPER(papmi,"ALL")),"^",13) ;deathDate
 	s:deathDate'="" deathDate=$zd(deathDate,3)
 	s deathTime=$p($g(^PAPER(papmi,"ALL")),"^",8) ;deathTime
 	s:deathTime'="" deathTime=$zt(deathTime,1)
 	set $li(Data,19)=deathDate
 	set $li(Data,20)=deathTime
 	set $li(Data,21)=Adm
 	set $li(Data,22)=papmi
 	Set ^CacheTemp(repid,ind)=Data
 	s ret=RetFlag_"^"_CurrVolStatusDr
	q ret
}

ClassMethod QueryDischargeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDischargeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryDischargeListExecute(ByRef qHandle As %Binary, cType As %String, StartDate As %String, EndDate As %String, LocId As %String, WardId As %String, DispalyFlag As %String, PrintFlag As %String, dischCondit As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	set ^CacheTemp("QueryDischargeListExecute")=cType_","_StartDate_","_EndDate_","_LocId_","_WardId_","_DispalyFlag_","_PrintFlag_","_dischCondit
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	
	s JIndex=$j
	s CurrDate=""	
	s DisStr=..GetDischargeList(JIndex,cType,StartDate,EndDate,DispalyFlag)
	s JIndex=$p(DisStr,"^",1)
	s Num=+$p(DisStr,"^",2)
	s RetNum=0			//已回收病案卷数量
	s NotCodingNum=0	//未编目病案卷数量
	
	q:JIndex="" $$$OK
	q:Num<1 $$$OK
	s WardIndex=""
	f  s WardIndex=$o(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex)) q:WardIndex=""  d
	.s tempDocDr=""
	.f  s tempDocDr=$o(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,tempDocDr)) q:tempDocDr=""  d
	..s tempAdm=""
	..f  s tempAdm=$o(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,tempDocDr,tempAdm)) q:(tempAdm="")  d
	...s MrNo=$p($g(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,tempDocDr,tempAdm)),"^",1)
	...s VolRowid=$p($g(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,tempDocDr,tempAdm)),"^",2)
	...s cType=$p($g(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,tempDocDr,tempAdm)),"^",3)
	...s Adm=tempAdm
	...s Ward=+$p($g(^PAADM(+Adm)),"^",70)		;表PAC_Ward的RowId
	...s Loc=$p($g(^PAADM(+Adm)),"^",4)
	...q:((Loc'=LocId)&&(LocId'=""))
	...q:((Ward'=WardId)&&(WardId'=""))
	...b ;1
	...s dischId=""
	...i dischCondit'="" d
	....s mrAdmId=$p($g(^PAADM(+Adm)),"^",61)
 	....s:mrAdmId'="" dischId=$p($g(^MR(+mrAdmId,"PRO",1)),"^",10)
	...q:(dischCondit'="")&&(dischCondit'=dischId)
	...b ;2
	...s ret=..BuildDataDischarge(repid, ind, Adm, MrNo,cType,DispalyFlag,VolRowid,dischCondit) //add "DispalyFlag"、"VolRowid" by liuxuefeng 2010-04-16
	...s:ret'="" RetFlag=$p(ret,"^",1) //病案收回标志
	...s:RetFlag="Y" RetNum=RetNum+1
	...s CurrVolStatusDr=$p(ret,"^",2)
	...;^DHCWMRVOL({DHC_WMR_MainVolume.Rowid},"S",0,"Status",{Status_Dr},{ChildSub})
	...s CodingStatusDr=4 //妇产医院编目Rowid为6;宁医附院、安徽省立南区为8;潍坊人民医院为4
	...s:'$d(^DHCWMRVOL(VolRowid,"S",0,"Status",CodingStatusDr)) NotCodingNum=NotCodingNum+1 //卷当前状态
	...s ind=ind+1
	s DisCnt=ind-1				;add by liuxuefeng 2009-06-09 页面输出列表总数
	s NotRetNum=DisCnt-RetNum
	if (PrintFlag'="Y"){	
		w:DispalyFlag'="A" "出院未收回数量:"_DisCnt		;add by liuxuefeng 2009-06-09 页面输出列表总数
		w:DispalyFlag="A" "出院人数:"_DisCnt_"	; 未收回数量:"_NotRetNum
		w:DispalyFlag="A" " ; 未编目数量:"_NotCodingNum
	}
	Quit $$$OK
}

ClassMethod QueryDischargeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDischargeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询出院病人列表
/// cType：病案类型
/// update: 2010-04-15 liuxuefeng 
/// 增加入参DispalyFlag，当DispalyFlag为"A"时，显示全部出院病人列表；为"N"时，显示出院未回收列表
/// 增加入参PrintFlag，当进行"导出"、"打印"时，PrintFlag为"Y"，Query中write程序不执行
/// w ##Class(%ResultSet).RunQuery("web.DHCWMRVolDisAdmQry","QueryDischargeList",7,58778,62430,"","","N","",7)
Query QueryDischargeList(cType As %String, StartDate As %String, EndDate As %String, LocId As %String, WardId As %String, DispalyFlag As %String, PrintFlag As %String, dischCondit As %String = "") As %Query(ROWSPEC = "WardDesc:%String:所在病区,DischgDate:%String:出院日期,PapmiNo:%String:登记号,PatName:%String:病人姓名,MrNO:%String:病案号,MrTypeId:%String:病案类型ID,MrType:%String:病案类型,LocDesc:%String:科室,MrDoctor:%String:主治医生,DischgDays:%String:出院天数,LendOutFlag:%String:是否借出,LendOutType:%String:借出类型,RetFlag:%String:收回标志,RetDate:%String:收回日期,RetUser:%String:操作员,CurrVolStatus:%String:卷当前状态,VolRowid:%String:卷ID,dischCondit:%String:转归,DeathDate:%String,DeathTime:%String,Paadm:%String,PatientId:%String")
{
}

ClassMethod QueryNewAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryNewAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryNewAdmExecute(ByRef qHandle As %Binary, ADMType As %String, MRTypeDr As %String, AdmDate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;s AdmDate=$zdh(AdmDate,3)
	s:AdmDate["-" AdmDate=$zdh(AdmDate,3)
	s:AdmDate["/" AdmDate=$zdh(AdmDate,4)
	s AdmDate=+AdmDate
	q:'$d(^PAADMi("PAADM_AdmDate",AdmDate)) $$$OK
	s SYSMrNo=..GetSYSMrNo()
	
	;^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
	s paadm=""
    f  s paadm=$o(^PAADMi("PAADM_AdmDate",AdmDate,paadm)) q:paadm=""  d
    .s papmi=+$p($g(^PAADM(+paadm)),"^",1)
    .s Type=$p($g(^PAADM(+paadm)),"^",2)
    .s VisitStatus=$p($g(^PAADM(+paadm)),"^",20)
    .q:Type'=ADMType                              ;就诊类型
    .q:VisitStatus="C"                            ;VisitStatus="取消"
    .;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
    .s WardDesc=$p($g(^PAWARD(+$p($g(^PAADM(+paadm)),"^",70))),"^",2)                //病区  
    .;s Ward=+$p(tmp,"^",70)         
    .s MainRowid=""                //病案rowid      
    .s MrNO=""                     //病案号         
    .s FristFlag="N"               //是否第一次住院 
    .s VolFlag="N"                 //是否接诊       
    .s PrintFlag="N"               //是否需要打印 
    .s VolRowid=""  
    .s NameSpell=""
    .s MrNO=""
    .;Get base information
    .s PatNo=$p(^PAPER(papmi,"PAT",1),"^",1)
    .s Name=$p($g(^PAPER(papmi,"ALL")),"^",1)
    .s Sex=$p($g(^CT("SEX",$p($g(^PAPER(papmi,"ALL")),"^",7))),"^",2)
    .;s:paadm=$o(^PAPERdr(papmi,"ADM",ADMType,"")) FristFlag="Y"
    .i '$d(^DHCWMRVOL(0,"VolAdm",+paadm)) d         ;无卷
    ..;s:paadm=$o(^PAPERdr(papmi,"ADM",ADMType,"")) FristFlag="Y"
    .e  d                                          ;有卷
    ..s VolRowid=$o(^DHCWMRVOL(0,"VolAdm",paadm,""),-1)
    ..s sVol=$g(^DHCWMRVOL(VolRowid))
    ..i $p(sVol,"^",7)="Y" d                       ;卷有效状态
    ...s MainRowid=+$p(sVol,"^",1)
    ...s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
    ...i $p(sMain,"^",2)=MRTypeDr d                  ;病案类型
    ....s FristFlag=..CheckFirstVol(MainRowid,VolRowid)
    ....s VolFlag="Y"                               ;已经接诊
    ....s MrNO=$p(sMain,"^",3)
    ....s sVolInfo=##class(web.DHCWMRVolumeCtl).GetVolInfoByVol(VolRowid)
    ....s NameSpell=$p(sVolInfo,"^",3)
    .i VolFlag="N" d                              ;对未接诊按papmi查询
    ..i $d(^DHCWMRMAIN(0,"PAPMI",papmi)) d
    ...s NameSpell=##class(web.DHCWMRBaseInfoCtl).GetNameSpell(MainRowid)
    ...s tmpRowid=""
    ...f  s tmpRowid=$o(^DHCWMRMAIN(0,"PAPMI",papmi,tmpRowid),-1) q:tmpRowid=""  d
    ....s tmpMain=$g(^DHCWMRMAIN(+tmpRowid))
    ....q:$p(tmpMain,"^",2)'=MRTypeDr
    ....q:$p(tmpMain,"^",7)'="Y"
    ....s MrNO=$p(tmpMain,"^",3)
    ....s MainRowid=+tmpRowid
    .s:(MrNO>SYSMrNo)&(FristFlag="Y") PrintFlag="Y"
    .;q:$p(sMain,"^",3)<SYSMrNo                    ;病案号码
    .;s sBaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainRowid)
    .;s sVolInfo=##class(web.DHCWMRVolumeCtl).GetVolInfoByVol(VolRowid)
    .d BuildNewAdmData
	Quit $$$OK
BuildNewAdmData
	Set Data=$lb("")
	Set $li(Data,1)=papmi                      //Papmi
	Set $li(Data,2)=+paadm                     //Paadm,
	Set $li(Data,3)=VolRowid                   //VolRowid,
	Set $li(Data,4)=PatNo                      //PatNo,
	Set $li(Data,5)=Name                       //Name,
	Set $li(Data,6)=Sex                        //Sex,
	Set $li(Data,7)=NameSpell                  //NameSpell
	Set $li(Data,8)=WardDesc                   //病区
	Set $li(Data,9)=MainRowid                  //病案rowid
	Set $li(Data,10)=MrNO                      //病案号
	Set $li(Data,11)=FristFlag                 //是否第一次住院
	Set $li(Data,12)=VolFlag                   //是否接诊
	Set $li(Data,13)=PrintFlag                 //是否需要打印
	
	Set sBase=##Class(web.DHCWMRBaseInfoCtl).FormatBaseInfo(+papmi,"")
	Set $li(Data,14)=$p(sBase,"^",5)              ;Birthday/生日
	Set $li(Data,15)=$p(sBase,"^",6)              ;Age/年龄
	Set $li(Data,16)=$p(sBase,"^",7)              ;Wedlock/婚姻
	Set $li(Data,17)=$p(sBase,"^",8)              ;Occupation/职业
	Set $li(Data,18)=$p(sBase,"^",9)              ;City/出生市
	Set $li(Data,19)=$p(sBase,"^",11)             ;Nation/民族
	Set $li(Data,20)=$p(sBase,"^",12)             ;Nationality/国籍
	Set $li(Data,21)=$p(sBase,"^",13)             ;IdentityCode/身份证号
	Set $li(Data,22)=$p(sBase,"^",14)             ;Company/工作单位
	Set $li(Data,23)=$p(sBase,"^",15)             ;CompanyTel/工作单位电话
	Set $li(Data,24)=$p(sBase,"^",17)             ;HomeAddress/家庭住址
	Set $li(Data,25)=$p(sBase,"^",18)             ;HomeTel/家庭电话
	Set $li(Data,26)=$p(sBase,"^",20)             ;RelationDesc/与联系人关系
	Set $li(Data,27)=$p(sBase,"^",21)             ;RelativeName/联系人
	Set $li(Data,28)=$p(sBase,"^",22)             ;RelativeTel/联系人电话
	Set $li(Data,29)=$p(sBase,"^",23)             ;RelativeAddress/联系人地址
	
	Set $li(Data,30)=##Class(web.DHCWMRMedBaseCtl).GetHISMrNo(papmi, MRTypeDr)  //住院病案号 Modify by liuxuefeng 2009-06-11
	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit
}

ClassMethod QueryNewAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNewAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询入院病人列表，为打印索引卡片提供数据
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRVolDisAdmQry","QueryNewAdm","O",6,"2008-04-28")
Query QueryNewAdm(ADMType As %String, MRTypeDr As %String, AdmDate As %String) As %Query(ROWSPEC = "Papmi:%String,Paadm:%String,VolRowid:%String,PatNo:%String,Name:%String,Sex:%String,NameSpell:%String,WardDesc:%String,MainRowid:%String,MrNO:%String,FristFlag:%String,VolFlag:%String,PrintFlag:%String,Birthday:%String,Age:%String,Wedlock:%String,Occupation:%String,City:%String,Nation:%String,Nationality:%String,IdentityCode:%String,Company:%String,CompanyTel:%String,HomeAddress:%String,HomeTel:%String,RelationDesc:%String,RelativeName:%String,RelativeTel:%String,RelativeAddress:%String")
{
}

/// 检查是否是第一卷（首次住院）
ClassMethod CheckFirstVol(MainRowid, VolRowid)
{
	n (MainRowid,VolRowid)
	s ret="Y"
	;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})
	i $o(^DHCWMRVOL(0,"Main",MainRowid,VolRowid),-1)="" q:ret
	s tempVol=VolRowid
	f  s tempVol=$o(^DHCWMRVOL(0,"Main",MainRowid,tempVol),-1) q:tempVol=""  d
	.s sVol=$g(^DHCWMRVOL(VolRowid))
    .s:$p(sVol,"^",7)="Y" ret="N"                   ;卷有效状态
    
    
    //在友谊医院，由于历史数据录入问题，只有大于500000的病案才校验是否是多次住院，小于500000的病案一律视为住过院
    set MrNo = $p($g(^DHCWMRMAIN(MainRowid)), "^", 2)
    set strHospital = $g(^DHCMedHosptial(0))
    set HospitalCode = $p(strHospital, "/", 4)
    set:(HospitalCode="BeiJing_YY")&(MrNo < ..GetSYSMrNo()) ret="N"
	/*
	i $o(^DHCWMRMAIN(MainRowid,"V",VolChild),-1)="" q:ret
	s tempChild=VolChild
	f  s tempChild=$o(^DHCWMRMAIN(MainRowid,"V",tempChild),-1) q:tempChild=""  d
	.s sVolume=##class(web.DHCWMRVolumeCtl).GetVolume(MainRowid,tempChild)
    .s:$p(sVolume,"^",7)="Y" ret="N"                   ;卷有效状态
    */
	q ret
}

/// 取设定的病案号 大于此号才打印索引卡片
ClassMethod GetSYSMrNo()
{
	q "500000"
}

ClassMethod QueryNewAdmAAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryNewAdmAAExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryNewAdmAAExecute(ByRef qHandle As %Binary, ADMType As %String, MRTypeDr As %String, FromDate As %String, ToDate As %String, LocRowId As %String = "", WardRowid As %String = "", StartTime As %String = "", EndTime As %String = "", PatName As %String = "", PatMrNo As %String = "", PatNo As %String = "") As %Status
{
	;set ^CacheTemp("QueryNewAdmAAExecute")=StartTime_","_EndTime
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//add by lyh 2012-12-14 for 通过病案号、登记号、姓名 查询接诊信息
	s HospCode=""
	i PatName'="" d
	.q:'$d(^PAPERi("PAPER_PatName",PatName))
	.s papmi=""
	.f  s papmi=$o(^PAPERi("PAPER_PatName",PatName,papmi)) q:papmi=""  d
	..q:'$d(^PAPERdr(papmi))
	..q:'$d(^PAPERdr(papmi,"ADM","I"))
	..s paadm=""
	..f  s paadm=$o(^PAPERdr(papmi,"ADM","I",paadm)) q:paadm=""  d
	...s a=$$GetAdmInfo()
	s len=10
	i (PatNo'="")&($l(PatNo)<len) d
	.s prelen=len-$l(PatNo)
	.f i=1:1:prelen s PatNo="0"_PatNo
	.s papmi=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
	.q:$g(papmi)=""
	.q:'$d(^PAPERdr(papmi))
	.q:'$d(^PAPERdr(papmi,"ADM","I"))
	.s paadm=""
	.f  s paadm=$o(^PAPERdr(papmi,"ADM","I",paadm)) q:paadm=""  d
	..s a=$$GetAdmInfo()
	
	i PatMrNo'=""  d
	.s PatMrNo=##class(web.DHCWMRMedBaseCtl).FormatMrNo(7,PatMrNo)	// 补齐病案号
	.s rowid=$o(^DHCWMRMAIN(0,"TypeNO",7,PatMrNo,"")) 
	.q:rowid=""
	.s papmi=$p($g(^DHCWMRMAIN(rowid)),"^",3)
	.q:papmi=""
	.q:'$d(^PAPERdr(papmi))
	.q:'$d(^PAPERdr(papmi,"ADM","I"))
	.s paadm=""
	.f  s paadm=$o(^PAPERdr(papmi,"ADM","I",paadm)) q:paadm=""  d
	..s a=$$GetAdmInfo()
	
	q:(PatMrNo'="")||(PatName'="")||(PatNo'="") $$$OK
	
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s FromDate=+FromDate
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	s ToDate=+ToDate
	s SYSMrNo=..GetSYSMrNo()
	s HospCode=##class(web.DHCWMRMedBase01).GetDefaultHospCode() ;add by liuxuefeng 2009-05-14 for 复兴医院
	
	f AdmDate=FromDate:1:ToDate d
	.q:'$d(^PAADMi("PAADM_AdmDate",AdmDate))
	.;^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
	.s paadm=""
    .f  s paadm=$o(^PAADMi("PAADM_AdmDate",AdmDate,paadm)) q:paadm=""  d
    ..s papmi=+$p($g(^PAADM(+paadm)),"^",1)
    ..s Type=$p($g(^PAADM(+paadm)),"^",2)
    ..s VisitStatus=$p($g(^PAADM(+paadm)),"^",20)
    ..q:Type'=ADMType                              ;就诊类型
    ..q:VisitStatus="C"                            ;VisitStatus="取消"
    ..s admTime=$p($g(^PAADM(+paadm)),"^",7)       ;就诊时间
    ..q:((StartTime'="")&&(StartTime>admTime))!((EndTime'="")&&(EndTime<admTime))
    ..s PaadmMotherAdmDR=$p($g(^PAADM(+paadm)),"^",75) 		;add by liuxuefeng 2009-05-14 for 复兴医院
    ..q:PaadmMotherAdmDR'=""
    ..;q:(PaadmMotherAdmDR'="")&&(HospCode="BeiJing_FX")		;add by liuxuefeng 2009-05-14 for 复兴医院 如果PAADM_MotherAdm_DR不为空，说明此次住院就诊为婴儿就诊，此条记录不在接诊明细列表中显示
    ..;q:(PaadmMotherAdmDR'="")&&(HospCode="WeiFang_RMYY")	;add by liuxuefeng 2009-06-3 for 潍坊市人民医院 如果PAADM_MotherAdm_DR不为空，说明此次住院就诊为婴儿就诊，此条记录不在接诊明细列表中显示
    ..;q:(PaadmMotherAdmDR'="")&&(HospCode="ShenYang_YDYFY")	;add by liuxuefeng 2009-11-2 for 沈阳医大一院
    ..;q:(PaadmMotherAdmDR'="")&&(HospCode="BeiJing_FC")		;add by liuxuefeng 2010-01-28 for 妇产医院
    ..;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
    ..s paadmStr=..GetFirstLoc(+paadm)        ;住院登记就诊科室RowId 和病区RowId
    ..s pLocRowId=$p($g(paadmStr),"^",1)      ;住院登记科室RowId
    ..if (pLocRowId="")!(pLocRowId=0) do
    ...s pLocRowId=$p($g(^PAADM(+paadm)),"^",4)
    ..q:((LocRowId'="")&&(LocRowId'=pLocRowId))           ;有输入科室判断是否符合所输条件 不符合退出
    ..s pWardRowId=$p($g(paadmStr),"^",2)     ;住院登记病区RowId
    ..if (pWardRowId="")!(pWardRowId=0) do
    ...s pWardRowId=$p($g(^PAADM(+paadm)),"^",70) 
    ..;s pWardRowId=$p($g(^PAADM(+paadm)),"^",70)   ;就诊病区RowId
    ..q:((WardRowid'="")&&(WardRowid'=pWardRowId))        ;有输入病区判断是否符合所输条件 不符合退出
    ..;s WardDesc=$p($g(^PAWARD(+$p($g(^PAADM(+paadm)),"^",70))),"^",2)                //病区  
    ..s DepDesc=$p($g(^CTLOC(pLocRowId)),"^",2)                                        //科室
	..s:DepDesc["-" DepDesc=$p(DepDesc,"-",2)
	..s WardDesc=""
    ..s:pWardRowId'="" WardDesc=$p($g(^PAWARD(pWardRowId)),"^",2)                //病区
    ..;s Ward=+$p(tmp,"^",70)         
    ..s MainRowid=""                //病案rowid      
    ..s MrNO=""                     //病案号         
    ..s FristFlag="N"               //是否第一次住院 
    ..s VolFlag="N"                 //是否接诊       
    ..s PrintFlag="N"               //是否需要打印 
    ..s VolRowid=""  
    ..s NameSpell=""
    ..s MrNO=""
    ..;Get base information
    ..s PatNo=$p(^PAPER(papmi,"PAT",1),"^",1)
    ..s Name=$p($g(^PAPER(papmi,"ALL")),"^",1)
    ..s Sex=$p($g(^CT("SEX",$p($g(^PAPER(papmi,"ALL")),"^",7))),"^",2)
    ..;s:paadm=$o(^PAPERdr(papmi,"ADM",ADMType,"")) FristFlag="Y"
    ..i '$d(^DHCWMRVOL(0,"VolAdm",+paadm)) d         ;无卷
    ...;s:paadm=$o(^PAPERdr(papmi,"ADM",ADMType,"")) FristFlag="Y"
    ..e  d                                          ;有卷
    ...s VolRowid=$o(^DHCWMRVOL(0,"VolAdm",paadm,""),-1)
    ...s sVol=$g(^DHCWMRVOL(VolRowid))
    ...i $p(sVol,"^",7)="Y" d                       ;卷有效状态
    ....s MainRowid=+$p(sVol,"^",1)
    ....s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
    ....i $p(sMain,"^",2)=MRTypeDr d                  ;病案类型
    .....s FristFlag=..CheckFirstVol(MainRowid,VolRowid)
    .....s VolFlag="Y"                               ;已经接诊
    .....s MrNO=$p(sMain,"^",3)
    .....s sVolInfo=##class(web.DHCWMRVolumeCtl).GetVolInfoByVol(VolRowid)
    .....s NameSpell=$p(sVolInfo,"^",3)
    ..i VolFlag="N" d                              ;对未接诊按papmi查询
    ...i $d(^DHCWMRMAIN(0,"PAPMI",papmi)) d
    ....s NameSpell=##class(web.DHCWMRBaseInfoCtl).GetNameSpell(MainRowid)
    ....s tmpRowid=""
    ....f  s tmpRowid=$o(^DHCWMRMAIN(0,"PAPMI",papmi,tmpRowid),-1) q:tmpRowid=""  d
    .....s tmpMain=##class(web.DHCWMRMainCtl).GetMainById(+tmpRowid) 
    .....q:$p(tmpMain,"^",2)'=MRTypeDr
    .....q:$p(tmpMain,"^",7)'="Y"
    .....s MrNO=$p(tmpMain,"^",3)
    .....s MainRowid=+tmpRowid
    ..s:(MrNO>SYSMrNo)&(FristFlag="Y") PrintFlag="Y"
    ..;q:$p(sMain,"^",3)<SYSMrNo                    ;病案号码
    ..;s sBaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainRowid)
    ..;s sVolInfo=##class(web.DHCWMRVolumeCtl).GetVolInfoByVol(VolRowid)
    ..;s Hosp=##Class(web.DHCWMRMedBase01).GetDefaultHosp()
	..s:HospCode="ChengDu_HX" MrNO=$p($g(^PAADM(+paadm)),"^",81)
    ..//d BuildNewAdmData
    ..s a=$$BuildQueryNewAdmAAExecute()
    s Cnt=ind-1								;add by liuxuefeng 2009-07-17 页面输出列表总数
	;w !!,";数量总计:"_Cnt					;add by liuxuefeng 2009-07-17 页面输出列表总数
	
	Quit $$$OK
GetAdmInfo()
    s papmi=+$p($g(^PAADM(+paadm)),"^",1)
    s Type=$p($g(^PAADM(+paadm)),"^",2)
    s VisitStatus=$p($g(^PAADM(+paadm)),"^",20)
    q:Type'=ADMType ""                           ;就诊类型
    q:VisitStatus="C" ""                         ;VisitStatus="取消"
    s admTime=$p($g(^PAADM(+paadm)),"^",7)       ;就诊时间
    s PaadmMotherAdmDR=$p($g(^PAADM(+paadm)),"^",75) 		;add by liuxuefeng 2009-05-14 for 复兴医院
    q:PaadmMotherAdmDR'="" ""
    s paadmStr=..GetFirstLoc(+paadm)        ;住院登记就诊科室RowId 和病区RowId
    s pLocRowId=$p($g(paadmStr),"^",1)      ;住院登记科室RowId
    if (pLocRowId="")!(pLocRowId=0) do
    .s pLocRowId=$p($g(^PAADM(+paadm)),"^",4)
    q:((LocRowId'="")&&(LocRowId'=pLocRowId)) ""           ;有输入科室判断是否符合所输条件 不符合退出
    s pWardRowId=$p($g(paadmStr),"^",2)     ;住院登记病区RowId
    if (pWardRowId="")!(pWardRowId=0) do
    .s pWardRowId=$p($g(^PAADM(+paadm)),"^",70) 
    ;s pWardRowId=$p($g(^PAADM(+paadm)),"^",70)   ;就诊病区RowId
    q:((WardRowid'="")&&(WardRowid'=pWardRowId)) ""        ;有输入病区判断是否符合所输条件 不符合退出
    ;s WardDesc=$p($g(^PAWARD(+$p($g(^PAADM(+paadm)),"^",70))),"^",2)                //病区  
    s DepDesc=$p($g(^CTLOC(pLocRowId)),"^",2)                                        //科室
	s:DepDesc["-" DepDesc=$p(DepDesc,"-",2)
	s WardDesc=""
    s:pWardRowId'="" WardDesc=$p($g(^PAWARD(pWardRowId)),"^",2)                //病区
    ;s Ward=+$p(tmp,"^",70)         
    s MainRowid=""                //病案rowid      
    s MrNO=""                     //病案号         
    s FristFlag="N"               //是否第一次住院 
    s VolFlag="N"                 //是否接诊       
    s PrintFlag="N"               //是否需要打印 
    s VolRowid=""  
    s NameSpell=""
    s MrNO=""
    ;Get base information
    s PatNo=$p(^PAPER(papmi,"PAT",1),"^",1)
    s Name=$p($g(^PAPER(papmi,"ALL")),"^",1)
    s Sex=$p($g(^CT("SEX",$p($g(^PAPER(papmi,"ALL")),"^",7))),"^",2)
    ;s:paadm=$o(^PAPERdr(papmi,"ADM",ADMType,"")) FristFlag="Y"
    i '$d(^DHCWMRVOL(0,"VolAdm",+paadm)) d         ;无卷
    .;s:paadm=$o(^PAPERdr(papmi,"ADM",ADMType,"")) FristFlag="Y"
    e  d                                          ;有卷
    .s VolRowid=$o(^DHCWMRVOL(0,"VolAdm",paadm,""),-1)
    .s sVol=$g(^DHCWMRVOL(VolRowid))
    .i $p(sVol,"^",7)="Y" d                       ;卷有效状态
    ..s MainRowid=+$p(sVol,"^",1)
    ..s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
    ..i $p(sMain,"^",2)=MRTypeDr d                  ;病案类型
    ...s FristFlag=..CheckFirstVol(MainRowid,VolRowid)
    ...s VolFlag="Y"                               ;已经接诊
    ...s MrNO=$p(sMain,"^",3)
    ...s sVolInfo=##class(web.DHCWMRVolumeCtl).GetVolInfoByVol(VolRowid)
    ...s NameSpell=$p(sVolInfo,"^",3)
    i VolFlag="N" d                              ;对未接诊按papmi查询
    .i $d(^DHCWMRMAIN(0,"PAPMI",papmi)) d
    ..s NameSpell=##class(web.DHCWMRBaseInfoCtl).GetNameSpell(MainRowid)
    ..s tmpRowid=""
    ..f  s tmpRowid=$o(^DHCWMRMAIN(0,"PAPMI",papmi,tmpRowid),-1) q:tmpRowid=""  d
    ...s tmpMain=##class(web.DHCWMRMainCtl).GetMainById(+tmpRowid) 
    ...q:$p(tmpMain,"^",2)'=MRTypeDr
    ...q:$p(tmpMain,"^",7)'="Y"
    ...s MrNO=$p(tmpMain,"^",3)
    ...s MainRowid=+tmpRowid
    s PrintFlag="Y"

    s a=$$BuildQueryNewAdmAAExecute()
    s Cnt=ind-1								;add by liuxuefeng 2009-07-17 页面输出列表总数
	;w !!,";数量总计:"_Cnt					;add by liuxuefeng 2009-07-17 页面输出列表总数
	q Cnt
	//增加 上次住院日期，上次出院科室信息 Add By LiYang 2010-01-25
BuildQueryNewAdmAAExecute()
	Set Data=$lb("")
	Set $li(Data,1)=papmi                      //Papmi
	Set $li(Data,2)=+paadm                     //Paadm,
	Set $li(Data,3)=VolRowid                   //VolRowid,
	Set $li(Data,4)=PatNo                      //PatNo,
	Set $li(Data,5)=Name                       //Name,
	Set $li(Data,6)=Sex                        //Sex,
	Set $li(Data,7)=NameSpell                  //NameSpell
	s:WardDesc["-" WardDesc=$p(WardDesc,"-",2) 
	Set $li(Data,8)=WardDesc                   //病区
	Set $li(Data,9)=MainRowid                  //病案rowid
	Set $li(Data,10)=MrNO                      //病案号
	Set $li(Data,11)=FristFlag                 //是否第一次住院
	Set $li(Data,12)=VolFlag                   //是否接诊
	Set $li(Data,13)=PrintFlag                 //是否需要打印
	
	Set sBase=##Class(web.DHCWMRBaseInfoCtl).FormatBaseInfo(+papmi,"")
	Set $li(Data,14)=$p(sBase,"^",5)              ;Birthday/生日
	Set $li(Data,15)=$p(sBase,"^",6)              ;Age/年龄
	Set $li(Data,16)=$p(sBase,"^",7)              ;Wedlock/婚姻
	Set $li(Data,17)=$p(sBase,"^",8)              ;Occupation/职业
	Set $li(Data,18)=$p(sBase,"^",9)              ;City/出生市
	Set $li(Data,19)=$p(sBase,"^",11)             ;Nation/民族
	Set $li(Data,20)=$p(sBase,"^",12)             ;Nationality/国籍
	Set $li(Data,21)=$p(sBase,"^",13)             ;IdentityCode/身份证号
	Set $li(Data,22)=$p(sBase,"^",14)             ;Company/工作单位
	Set $li(Data,23)=$p(sBase,"^",15)             ;CompanyTel/工作单位电话
	Set $li(Data,24)=$p(sBase,"^",17)             ;HomeAddress/家庭住址
	Set $li(Data,25)=$p(sBase,"^",18)             ;HomeTel/家庭电话
	Set $li(Data,26)=$p(sBase,"^",20)             ;RelationDesc/与联系人关系
	Set $li(Data,27)=$p(sBase,"^",21)             ;RelativeName/联系人
	Set $li(Data,28)=$p(sBase,"^",22)             ;RelativeTel/联系人电话
	Set $li(Data,29)=$p(sBase,"^",23)             ;RelativeAddress/联系人地址
	
	Set $li(Data,30)=##Class(web.DHCWMRMedBaseCtl).GetHISMrNo(papmi, MRTypeDr)  //住院病案号 Modify by liuxuefeng 2009-06-11
	
	
	//Add By LiYang 2010-01-25  增加显示老病人上次住院信息
	S $li(Data,31)="" 	//上次就诊日期
	s $li(Data,32)="" 	//上次就诊病区
	s $li(Data,33)="" 	//上次就诊卷
	s $li(Data,34)=0	//是否老病人
	s $li(Data,35)=""	//历史就诊记录，即DHC_WMR_HistoryAdm历史数据
	
	s $li(Data,36)=""	//是否借出 LendOutFlag
	s $li(Data,37)=""	//借出类型 LendOutType
	//add by liuxuefeng 2010-07-09 增加本次就诊日期和就诊时间
	s $li(Data,38)=$zd($p($g(^PAADM(+paadm)),"^",6),3)	//本次就诊日期PAADM_AdmDate
	s $li(Data,39)=$zt($p($g(^PAADM(+paadm)),"^",7))	//本次就诊时间PAADM_AdmTime
	//add 2010-11-13 增加住院医生、科室
	s DocDr=+$p($g(^PAADM(+paadm)),"^",9)
	s DocDesc=""
	s:DocDr'=0 DocDesc=$p(##class(web.DHCWMRMedBaseCtl).GetUserByCTCP(DocDr),"/",3)
	s $li(Data,40)=DocDesc								//住院医生
	
	;s DepDr=+$p($g(^PAADM(+paadm)),"^",4) //科室
	;s retStr=..GetFirstLoc(+paadm)   ;住院登记的科室
	;s DepDr=$p($g(retStr),1)
	;if (DepDr="")!(DepDr=0)
	;{
	;	s DepDr=+$p($g(^PAADM(+paadm)),"^",4) //科室
	 ;}
	
	s $li(Data,41)=DepDesc
	
	//
	s flag=0
	s mainID=""
	s tmpID="" 
	;^DHCWMRMAIN(0,"PAPMI",{Papmi_Dr},{Rowid})
	f  s tmpID=$o(^DHCWMRMAIN(0,"PAPMI",papmi,tmpID)) q:((tmpID="")||(flag=1))  d
	.s mainStr=$g(^DHCWMRMAIN(tmpID))
	.s IsActive=$p(mainStr,"^",6)
	.q:IsActive'="Y"
	.s flag=1
	.s mainID=tmpID
	
	i ((mainID'="")&&(HospCode="BeiJing_FX"))  {
		;^DHCWMRVOL(0,"PaadmDr",{Paadm_Dr},{Rowid})
		//判读当前Adm是否接诊
		s ReceiptFlag=0
		s CurrVolID=0								//本次Adm就诊对应卷ID
		i $d(^DHCWMRVOL(0,"PaadmDr",+paadm))'=0  d  //本次住院已接诊，显示第前2次住院信息
		.s volID=""
		.f  s volID=$o(^DHCWMRVOL(0,"PaadmDr",+paadm,volID)) q:(volID="")||(ReceiptFlag=1)  d
		..s VolData=$g(^DHCWMRVOL(volID))
		..s VolIsActive=$p(VolData,"^",7)
		..q:VolIsActive'="Y"
		..s ReceiptFlag=1
		..s CurrVolID=volID
		
		i ReceiptFlag=1  d  //本次住院已接诊，显示第前2次住院信息
		.s VolData=$g(^DHCWMRVOL(CurrVolID))		//获取本次已接诊卷ID数据
		.s MainDr=+$p(VolData,"^",1)
		.;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})
		.s VolIDPre=CurrVolID
		.s VolPreFlag=0
		.f  s VolIDPre=$o(^DHCWMRVOL(0,"Main",MainDr,VolIDPre),-1) q:(VolIDPre="")||(VolPreFlag=1)  d
		..s VolPreData=$g(^DHCWMRVOL(VolIDPre))
		..s VolPreIsActive=$p(VolPreData,"^",7)
		..q:VolPreIsActive'="Y"
		..s VolPreFlag=1
		..;
		..s EpisodeIDPre=+$p(VolPreData,"^",2) 				//上次就诊卷指向的EpisodeID
		..s HistroyAdmPre=+$p(VolPreData,"^",3) 				//上次就诊卷指向的HistroyAdm_Dr	历史就诊信息
		..i HistroyAdmPre'=0 d
		...s HistroyAdmPreStr=$g(^DHCWMRHISADM(HistroyAdmPre))
		...s $li(Data,31)=$zd($p(HistroyAdmPreStr,"^",6),3) 	//上次就诊出院日期
		...s $li(Data,32)=$p(HistroyAdmPreStr,"^",8) 			//上次就诊出院病区
		...s $li(Data,33)=VolIDPre								//上次就诊卷ID
		...s $li(Data,34)=1
		...s $li(Data,35)="是"
		..i EpisodeIDPre'=0  d
		...s volAdmInfo=##class(web.DHCWMRBasePaadm).GetAdmInfo(EpisodeIDPre)
		...s $li(Data,31)=$p(volAdmInfo,"^",12) 				//上次就诊出院日期
		...s $li(Data,32)=$p($p(volAdmInfo,"^",9),"-",2) 		//上次就诊出院病区
		...s $li(Data,33)=VolIDPre 							//上次就诊卷ID
		...s $li(Data,34)=1
		...s $li(Data,35)=""
		e  d   								////未接诊，显示最后一次有效住院信息
		.s foundFlag=0
		.s VolIDPre="" 
		.f  s VolIDPre=$o(^DHCWMRVOL(0,"Main",mainID,VolIDPre),-1) q:((VolIDPre="")||(foundFlag=1))  d
		..s VolPreData=$g(^DHCWMRVOL(VolIDPre))					//找到病案最后一个卷
		..s VolPreIsActive=$p(VolPreData,"^",7)
		..q:VolPreIsActive'="Y"									//判断是否有效
		..s foundFlag=1
		..;
		..s EpisodeIDPre=+$p(VolPreData,"^",2) 					//上次就诊卷指向的EpisodeID
		..s HistroyAdmPre=+$p(VolPreData,"^",3) 				//上次就诊卷指向的HistroyAdm_Dr	历史就诊信息
		..i HistroyAdmPre'=0 d
		...s HistroyAdmPreStr=$g(^DHCWMRHISADM(HistroyAdmPre))
		...s $li(Data,31)=$zd($p(HistroyAdmPreStr,"^",6),3) 	//上次就诊出院日期
		...s $li(Data,32)=$p(HistroyAdmPreStr,"^",8) 			//上次就诊出院病区
		...s $li(Data,33)=VolIDPre								//上次就诊卷ID
		...s $li(Data,34)=1
		...s $li(Data,35)="是"
		..i EpisodeIDPre'=0  d
		...s volAdmInfo=##class(web.DHCWMRBasePaadm).GetAdmInfo(EpisodeIDPre)
		...s $li(Data,31)=$p(volAdmInfo,"^",12) 				//上次就诊出院日期
		...s $li(Data,32)=$p($p(volAdmInfo,"^",9),"-",2) 		//上次就诊出院病区
		...s $li(Data,33)=VolIDPre 								//上次就诊卷ID
		...s $li(Data,34)=1
		...s $li(Data,35)=""


 	 	////2010-01-28 增加判断此病人对应病案/病案卷是否借出的判断
	 	s LOWorkItemID=8				//病案借阅对应操作项目RowID
	 	s LOStr=..GetLendOutType(LOWorkItemID,papmi,MRTypeDr)
	
	 	s LendOutFlag=$p(LOStr,"^",1)		//是否借出
	 	s LendOutType=$p(LOStr,"^",2)		//借出类型
	 	
	 	Set $li(Data,36)=LendOutFlag     
	 	Set $li(Data,37)=LendOutType 
	 	//////////////////////////////////////////

 	
	}
	
    
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q 0
}

/// Creator:wangCS
/// CreateDate:2011-07-13
/// InPut:paadm 
/// OutPut:CTLocRowId^WardRowId
/// Description:根据就诊ID，Pa_admTransaction表取该病人住院登记时的科室ID和病区ID
/// 调试：w ##Class(web.DHCWMRVolDisAdmQry).GetFirstLoc(77284)
ClassMethod GetFirstLoc(paadm)
{
	new (paadm)
	set Ret=""
	set CTLocRowId=""
	set WardRowId=""
	;^PAADMi("TransDateTime1",{PA_Adm.PAADM_RowID},{TRANS_StartDate},{TRANS_StartTime},{TRANS_Childsub})
	if ($d(^PAADMi("TransDateTime1",+paadm))){
       set TransStartDate=0
       set TransStartDate=$o(^PAADMi("TransDateTime1",+paadm,TransStartDate))
       if ($d(^PAADMi("TransDateTime1",+paadm,TransStartDate))) {
          set TransStartTime=0
          set TransStartTime=$o(^PAADMi("TransDateTime1",+paadm,TransStartDate,TransStartTime))
          set ChildSub=0
          ;^PAADM({PA_Adm.PAADM_RowID},"TRANS",{TRANS_Childsub})
          if ($d(^PAADMi("TransDateTime1",+paadm,TransStartDate,TransStartTime))) {
	          set ChildSub=$o(^PAADMi("TransDateTime1",+paadm,TransStartDate,TransStartTime,ChildSub))
	          while(ChildSub'="")
	          {
		          if ($d(^PAADM(+paadm,"TRANS",ChildSub))) 
		          {
                     set CTLocRowId=$p(^PAADM(+paadm,"TRANS",ChildSub),"^",6)
                     if ((CTLocRowId'="")&&(CTLocRowId'=0))
                     {
	                     set Ret=CTLocRowId
	                  }
	                  set WardRowId=$p(^PAADM(+paadm,"TRANS",ChildSub),"^",9)
	                  if ((WardRowId'="")&&(WardRowId'=0))
	                  {
		                  set Ret=Ret_"^"_WardRowId
		               }
                     q:(CTLocRowId'="")&&(CTLocRowId'=0)&&(WardRowId'="")&&(WardRowId'=0)
		          }
		          set ChildSub=$o(^PAADMi("TransDateTime1",+paadm,TransStartDate,TransStartTime,ChildSub))
		      }
          }
       }
	}
	quit Ret
}

ClassMethod QueryNewAdmAAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNewAdmAAExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询入院病人列表，为打印索引卡片提供数据
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRVolDisAdmQry","QueryNewAdm","O",6,"2008-04-28","2008-04-28")
Query QueryNewAdmAA(ADMType As %String, MRTypeDr As %String, FromDate As %String, ToDate As %String, LocRowId As %String = "", WardRowid As %String = "", StartTime As %String = "", EndTime As %String = "", PatName As %String = "", PatMrNo As %String = "", PatNo As %String = "") As %Query(ROWSPEC = "Papmi:%String,Paadm:%String,VolRowid:%String,PatNo:%String,Name:%String,Sex:%String,NameSpell:%String,WardDesc:%String,MainRowid:%String,MrNO:%String,FristFlag:%String,VolFlag:%String,PrintFlag:%String,Birthday:%String,Age:%String,Wedlock:%String,Occupation:%String,City:%String,Nation:%String,Nationality:%String,IdentityCode:%String,Company:%String,CompanyTel:%String,HomeAddress:%String,HomeTel:%String,RelationDesc:%String,RelativeName:%String,RelativeTel:%String,RelativeAddress:%String,PapmiMrNo:%String,LastVisitDisDate:%String,LastVisitDep:%String,LastVisitVolID:%String,LastVisitFlag:%String,IsHistoryAdm:%String,LendOutFlag:%String,LendOutType:%String,AdmDate:%String,AdmTime:%String,DocDesc:%String,DepDesc:%String")
{
}

ClassMethod GetDischargeListByWard(JIndex, cTypeDr, FromDate, ToDate, cLoc, cWard)
{
	n (JIndex, cTypeDr, FromDate, ToDate, cLoc, cWard)
	s:JIndex="" JIndex=$j
	s num=0
	
	;s:cDate="" cDate=+$h
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	;s cDate=+cDate
	;s cDate=cDate+1
	k ^CacheTemp("DHCWMRADLIST",JIndex)
	;Get cStatusDR by cTypeDr,$h
	;0、当前病案类型的工作流，找到第一个状态（在院） *
	;s cStatusDR="1"
	s sFlow=##class(web.DHCWMRWorkFlowCtl).GetWFLByTypeActiveDate(cTypeDr,"Y",$zd(+$h,3))
    s aFlow=$p(sFlow,$c(1),1)
    s cStatusDR=$p(aFlow,"^",3)
	;^DHCWMRVOL(0,"VolAFS",{IsActive},{InFlow},{Status_Dr},{DHC_WMR_Main.Rowid},{ChildSub})
	q:'$d(^DHCWMRVOL(0,"VolAFS","Y","Y",cStatusDR)) JIndex_"^"_num
	
	;1、在院状态的卷
	s VolRowid=""
	f  s VolRowid=$o(^DHCWMRVOL(0,"VolAFS","Y","Y",cStatusDR,VolRowid)) q:VolRowid=""  d
	.s sVol=$g(^DHCWMRVOL(+VolRowid))
	.q:$p(sVol,"^",7)'="Y"                          //卷非活动
	.s MainRowid=+$p(sVol,"^",1)
	.q:$p($g(^DHCWMRMAIN(MainRowid)),"^",6)'="Y"    //病案主信息非活动
	.q:$p($g(^DHCWMRMAIN(MainRowid)),"^",1)'=cTypeDr //Add By LiYang 2009-06-11判断病案种类
	.s MrNO=$p($g(^DHCWMRMAIN(MainRowid)),"^",2)	
	.s paadm=+$p(sVol,"^",2)
	.q:paadm=0
	.;3、查询Vol的adm，此adm之后，新卷adm之前的adm都属于此卷
	.;s sPaadm=..GetAdmList(+VolRowid)  //wq
	.;s LastAdm=$p(sPaadm,"^",$l(sPaadm,"^"))  //wq
	.;s:LastAdm="" LastAdm=paadm   //wq
	.s LastAdm=paadm
	.;4、最后一个adm是否出院状态
	.s VisitStatus=$p($g(^PAADM(LastAdm)),"^",20)
	.q:VisitStatus'="D"
	.
	.;;cDate
	.;s DisDate=+$p($g(^PAADM(LastAdm)),"^",17)
	.s DisDate=$p(##Class(web.DHCWMRMedBase01).GetDisDateTime(LastAdm),",",1)
	.q:DisDate=""
	.q:(DisDate<FromDate)!(DisDate>ToDate)     ;Modified By LiYang 2009-7-11 设置成时间段
	.
	.;5、按照病区排序
	.;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.s Ward=+$p($g(^PAADM(LastAdm)),"^",70)
	.s Loc=$p($g(^PAADM(LastAdm)),"^",4) //Add By LiYang 2009-7-1 增加科室过滤
	.q:((Loc'=cLoc)&&(cLoc'="")) //Add By LiYang 2009-7-1 增加科室过滤
	.q:((Ward'=cWard)&&(cWard'="")) //Add By LiYang 2009-5-17 过滤病房
	.s WardIndex=..GetWardIndex(Ward)
	.s:WardIndex="" WardIndex="N"
	.s ^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,LastAdm)=MrNO
	.s num=num+1
	s WardIndex=""
	q JIndex_"^"_num
}

ClassMethod BuildDataDischargeByWard(repid, ind, Adm, MrNo, MrType)
{
	n (repid, ind, Adm, MrNo, MrType)
	
	s tmp=$g(^PAADM(+Adm))
    s papmi=+$p(tmp,"^",1)
    s Ward=+$p(tmp,"^",70)
    s CTLoc=+$p(tmp,"^",4)
    s WardDesc="",DischgDate="",LocDesc="",DocDesc=""
    s Bed=$p(tmp,"^",73)
    s BedDesc=""					//add by liuxuefeng 2009-07-16
    s:Bed'="" BedDesc=$p($g(^PAWARD(+Bed,"BED",$p(Bed,"||",2))),"^",1)
    s Doc=+$p(tmp,"^",9)
    s:Doc'=0 DocDesc=$$GetUserByCTCP(Doc)
    s:Ward'=0 WardDesc=$p($g(^PAWARD(Ward)),"^",2)
    ;s:$p(tmp,"^",17)'="" DischgDate=$zd($p(tmp,"^",17),3)
    s DischgDate=$p(##Class(web.DHCWMRMedBase01).GetDisDateTime(+Adm),",",1)
    s:DischgDate'="" DischgDate=$zd(+DischgDate,3)
    s:CTLoc'=0 LocDesc=$p($g(^CTLOC(+CTLoc)),"^",2)
    s PapmiNo=$p(^PAPER(papmi,"PAT",1),"^",1)
    s Name=$p($g(^PAPER(papmi,"ALL")),"^",1)
	
	Set Data=$lb("")
	Set $li(Data,1)=WardDesc     //WardDesc
	Set $li(Data,2)=DischgDate   //DischgDate
 	Set $li(Data,3)=PapmiNo      //PapmiNo
	Set $li(Data,4)=Name         //PatName
	Set $li(Data,5)=MrNo         //MrNO
	
	s MrTypeId=+MrType
	s MrType=$p(^DHCWMRDIC(MrTypeId),"^",3)
	Set $li(Data,6)=MrTypeId     //MrTypeId
	Set $li(Data,7)=MrType       //MrType
	Set $li(Data,8)=LocDesc       //LocDesc Add BY wuqk 2007-07-30
 	set $li(Data,9)=BedDesc
 	set $li(Data,10)=DocDesc
 	Set ^CacheTemp(repid,ind)=Data
	q Data

GetUserByCTCP(CTCPDR)       ;CT_CareProv
 q:'$d(^CTPCP(CTCPDR)) ""
 s Code=$p($g(^CTPCP((CTCPDR),1)),"^",1)
 s Desc=$p($g(^CTPCP((CTCPDR),1)),"^",2)
 s s=Code_"  "_Desc
 q s
}

ClassMethod QueryDischargeListByWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDischargeListByWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryDischargeListByWardExecute(ByRef qHandle As %Binary, cType As %String, FromDate As %String, ToDate As %String, Loc As %String, Ward As %String) As %Status
{
   	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:cType="" $$$OK			//add by liuxuefeng 2009-07-16
	q:FromDate="" $$$OK			//add by liuxuefeng 2009-07-16
	q:ToDate="" $$$OK			//add by liuxuefeng 2009-07-16
	
	s JIndex=$j
	s DisStr=..GetDischargeListByWard(JIndex,cType,FromDate,ToDate,Loc,Ward)
	s JIndex=$p(DisStr,"^",1)
	s Num=+$p(DisStr,"^",2)
	
	q:JIndex="" $$$OK
	q:Num<1 $$$OK
	s WardIndex=""
	f  s WardIndex=$o(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex)) q:WardIndex=""  d
	.s tempAdm=""
	.f  s tempAdm=$o(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,tempAdm)) q:((tempAdm="")!(Num=100))  d
	..s MrNo=$g(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,tempAdm))
	..s Adm=tempAdm
	..d ..BuildDataDischargeByWard(repid, ind, Adm, MrNo,cType,"")
	..s ind=ind+1
	
	s Cnt=ind-1						;add by liuxuefeng 2009-06-09 页面输出列表总数
	//w !,"数量:"_Cnt					;add by liuxuefeng 2009-06-09 页面输出列表总数
	Quit $$$OK
}

ClassMethod QueryDischargeListByWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDischargeListByWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query QueryDischargeListByWard(cType As %String, FromDate As %String, ToDate As %String, Loc As %String, Ward As %String) As %Query(ROWSPEC = "WardDesc:%String,DischgDate:%String,PapmiNo:%String,PatName:%String,MrNO:%String,MrTypeId:%String,MrType:%String,LocDesc:%String,Bed:%String,Doc:%String")
{
}

/// w ##Class(web.DHCWMRVolDisAdmQry).QueryDischargeListByWardToPrint(itmjs,strArguments)
ClassMethod QueryDischargeListByWardToPrint(itmjs As %Library.String = "", strArguments As %String) As %Status
{
	n (itmjs,strArguments)
	s Count=0
	
	s MrType=$p(strArguments,"^",1)
	s DateFrom=$p(strArguments,"^",2)
	s DateTo=$p(strArguments,"^",3)
	s LocId=$p(strArguments,"^",4)
	s WardId=$p(strArguments,"^",5)
	
	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRVolDisAdmQry:QueryDischargeListByWard")
	d ds.Execute(MrType,DateFrom,DateTo,LocId,WardId)
	s StartRow=4
	while(ds.Next())
	{
		s MrType=ds.Data("MrType")
		s PapmiNo=ds.Data("PapmiNo")
		s MrNO=ds.Data("MrNO")
		s PatName=ds.Data("PatName")
		s DischgDate=ds.Data("DischgDate")
		s LocDesc=ds.Data("LocDesc")
		s WardDesc=ds.Data("WardDesc")
		s Bed=ds.Data("Bed")
		s Doc=ds.Data("Doc")
		
		//登记号,病案号,姓名,出院日期,科室,病区,床号,医生
		s valCells=PapmiNo_$c(1)_MrNO_$c(1)_PatName_$c(1)_DischgDate_$c(1)_LocDesc_$c(1)_WardDesc_$c(1)_Bed_$c(1)_Doc
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	s valCells="统计日期："_$zd(DateFrom,3)_" 至 "_$zd(DateTo,3)_"    合计:"_Count_"份"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	q Count
}

/// w ##Class(web.DHCWMRVolDisAdmQry).QueryDischargeListToPrint(itmjs,strArguments)
ClassMethod QueryDischargeListToPrint(itmjs As %Library.String = "", strArguments As %String) As %Status
{
	n (itmjs,strArguments)
	s Count=0
	s MrType=$p(strArguments,"^",1)
	s DateFrom=$p(strArguments,"^",2)
	s DateTo=$p(strArguments,"^",3)
	s LocId=$p(strArguments,"^",4)
	s WardId=$p(strArguments,"^",5)
	s DispalyFlag=$p(strArguments,"^",6)
	s PrintFlag="Y" //$p(strArguments,"^",7) 此标志为"Y"，说明为导出或打印调用Query，Query中write函数不调用
	s dischCondit=$p(strArguments,"^",8)
	
	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRVolDisAdmQry:QueryDischargeList")
	d ds.Execute(MrType,DateFrom,DateTo,LocId,WardId,DispalyFlag,PrintFlag,dischCondit)
	s StartRow=4
	while(ds.Next())
	{
		s MrType=ds.Data("MrType")
		s PapmiNo=ds.Data("PapmiNo")
		s MrNO=ds.Data("MrNO")
		s PatName=ds.Data("PatName")
		s DischgDate=ds.Data("DischgDate")
		s LocDesc=ds.Data("LocDesc")
		s WardDesc=ds.Data("WardDesc")
		s MrDoctor=ds.Data("MrDoctor")
		s DischgDays=ds.Data("DischgDays")				//add by liuxuefeng	2009-12-05
		s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)			//add by liuxuefeng	2009-12-05
		s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)		//add by liuxuefeng	2009-12-05
		s LendOutFlag=ds.Data("LendOutFlag")			//add by liuxuefeng	2010-02-09 是否借出
		s LendOutType=ds.Data("LendOutType")			//add by liuxuefeng	2009-12-05 借出类型
    ;s dischCondit=ds.Data("dischCondit")            //add by wangcs 2011-12-05
		;s deathDate=ds.Data("DeathDate")
		;s deathTime=ds.Data("DeathTime")
		//登记号,病案号,姓名,出院日期,科室,病区,借出天数,是否借出,借出类型
		s valCells=PapmiNo_$c(1)_MrNO_$c(1)_PatName_$c(1)_DischgDate_$c(1)_LocDesc_$c(1)_WardDesc_$c(1)_MrDoctor_$c(1)_DischgDays_$c(1)_LendOutFlag_$c(1)_LendOutType ;_$c(1)_dischCondit_$c(1)_deathDate_$c(1)_deathTime
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	//打印标题
	s:DispalyFlag="A" valCells="出院病历清单"
	s:DispalyFlag'="A" valCells="出院病历清单(未回收)"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',1,1);"
	&javascript<#(retval)#>
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	//s valCells="统计日期："_$zd(DateFrom,3)_" 至 "_$zd(DateTo,3)_"    合计:"_Count_"份"
	//$zd($zdh("27/01/2009",4),3)   从“27/11/2009” 到“2009-11-27”
	s valCells="统计日期："_$zd($zdh(DateFrom,4),3)_" 至 "_$zd($zdh(DateTo,4),3)_"            合计:"_Count_"份"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	q Count
}

/// Creator：    刘学峰
/// CreatDate：  2009-12-07
/// Service User:沈阳医大一院项目组
/// Description：取统计组出院日期
/// Input：      EpisodeID
/// Return：     出院日期^出院时间
/// Debug:       w ##Class(web.DHCWMRVolDisAdmQry).IGetDisDateTimeFromStatistic(EpisodeID)
ClassMethod IGetDisDateTimeFromStatistic(EpisodeID)
{
    n (EpisodeID)
    
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$GetDisAdmDate^DHCMRIPday(EpisodeID)
	zn CurrentNS
	
	q ret
}

/// Creator：    刘学峰
/// CreatDate：  2010-01-27
/// Description：接诊明细查询打印
/// Input：      itmjs:js方法名;strArguments:方法参数
/// Debug:       w ##Class(web.DHCWMRVolDisAdmQry).QueryNewAdmAAToPrint("fillxlSheet","I^7^20/12/2013^20/12/2013^余测试^^")
ClassMethod QueryNewAdmAAToPrint(itmjs As %Library.String = "", strArguments As %String) As %Status
{
	n (itmjs,strArguments)
	s Count=0
	s ^Temp("PPP")=itmjs_"^"_strArguments
	s ADMType=$p(strArguments,"^",1)
	;s:ADMType="" ADMType="I"
	s MrType=$p(strArguments,"^",2)
	;s:MrType="" MrType="7"
	s DateFrom=$p(strArguments,"^",3)
	s:DateFrom'="" DateFrom=$zd($h,4)
	s DateTo=$p(strArguments,"^",4)
	s:DateTo'="" DateTo=$zd($h,4)
	s PrintType=$p(strArguments,"^",5) ;打印标志：为空时打印所有；为O时打印老病人；为N时打印新病人
	s PatName=$p(strArguments,"^",5)
	s PatMrNo=$p(strArguments,"^",6)
	s PatNo=$p(strArguments,"^",7)
	b
	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRVolDisAdmQry:QueryNewAdmAA")
	d ds.Execute(ADMType,MrType,DateFrom,DateTo,"","","","",PatName,PatMrNo,PatNo)
	s StartRow=4
	;s index=1
	while(ds.Next())
	{
		s MrNO=ds.Data("MrNO") 							//病案号
		s PatNo=ds.Data("PatNo") 						//登记号
		s Name=ds.Data("Name")							//姓名
		s WardDesc=ds.Data("WardDesc") 					//就诊病区
		s LastVisitDisDate=ds.Data("LastVisitDisDate") 	//上次出院日期
		s LastVisitDep=ds.Data("LastVisitDep")			//上次出院科室
		s LastVisitFlag=ds.Data("LastVisitFlag")		//是否老病人
		s:LastVisitFlag=1 LastVisitFlag="O"				//LastVisitFlag=1 标志着为老病人
		s:LastVisitFlag=0 LastVisitFlag="N"				//LastVisitFlag=0 标志着为新病人
		
		s LendOutFlag=ds.Data("LendOutFlag")			//是否借出 2010-02-19
		s LendOutType=ds.Data("LendOutType")			//借出标志 2010-02-19
		/*
		;s index=index+1
		continue:(PrintType'="")&&(PrintType'=LastVisitFlag)
		if (PatName'=""){
            continue:Name'=PatName
           
        }
        if (PatMrNo'=""){
	        continue:MrNO'=PatMrNo
	      
	        }
	    s len=10
	    if (PatMiNo'="")&($l(PatMiNo)<len){
           s prelen=len-$l(PatMiNo)
	       f i=1:1:prelen s PatMiNo="0"_PatMiNo
		   continue:PatNo'=PatMiNo
		    }
		    */
		//登记号,病案号,姓名,出院日期,科室,是否老病人,病区,是否借出,借出标志
		s:LastVisitFlag="O" LastVisitFlag="是"				//LastVisitFlag=1 标志着为老病人
		s:LastVisitFlag="N" LastVisitFlag=""				//LastVisitFlag=1 标志着为新病人
		s valCells=MrNO_$c(1)_PatNo_$c(1)_Name_$c(1)_WardDesc_$c(1)_LastVisitDisDate_$c(1)_LastVisitDep_$c(1)_LastVisitFlag_$c(1)_LendOutFlag_$c(1)_LendOutType
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	//s valCells="统计日期："_$zd(DateFrom,3)_" 至 "_$zd(DateTo,3)_"    合计:"_Count_"份"
	//$zd($zdh("27/01/2009",4),3)   从“27/11/2009” 到“2009-11-27”
	s valCells="统计日期："_$zd($zdh(DateFrom,4),3)_" 至 "_$zd($zdh(DateTo,4),3)_"                  合计:"_Count_"份"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	q Count
}

/// Creator：    刘学峰
/// CreatDate：  2010-02-09
/// Description：判断病人对应病案/病案卷是否借出
/// Input：      LOWorkItemI:D病案借阅对应操作项目RowID;PatientID;MrType:病案类型ID
/// Return：     是否借出^借出类型
/// Debug		 w ##class(web.DHCWMRVolDisAdmQry).GetLendOutType(LOWorkItemID,PatientID,MrType)
ClassMethod GetLendOutType(LOWorkItemID, PatientID, MrType)
{
	
	n (LOWorkItemID,PatientID,MrType)
 	//检查病案是否借出
 	;^DHCWMRMAIN(0,"PAPMI",{Papmi_Dr},{Rowid})
 	s MainLOFlag=0					//病案借出标志
 	s MainFindFlag=0				//找到有效病案标志
 	s CurrMainID=0
 	s MainID=""
 	f  s MainID=$o(^DHCWMRMAIN(0,"PAPMI",PatientID,MainID)) q:(MainID="")||(MainFindFlag=1)  d
 	.s MainData=$g(^DHCWMRMAIN(MainID))
 	.s MainIsActive=$p(MainData,"^",6)
 	.q:MainIsActive'="Y"
 	.s MainMrType=$p(MainData,"^",1)
 	.q:MainMrType'=MrType					//病案类型
 	.s MainFindFlag=1
 	.s CurrMainID=MainID
 	.;^DHCWMRMAIN({DHC_WMR_Main.Rowid},"S",{ChildSub})
 	.s ChildSub=""
 	.s ChildSub=$o(^DHCWMRMAIN(MainID,"S",ChildSub),-1)
 	.q:ChildSub=""
 	.s MainStatusData=$g(^DHCWMRMAIN(MainID,"S",ChildSub))
 	.s MainStatusDr=$p(MainStatusData,"^",1)	//病案最后一个状态
 	.s:MainStatusDr=LOWorkItemID MainLOFlag=1
 	
 	//检查病案卷是否借出
 	;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})
 	s VolLOFlag=0
 	s VolID=""
 	f  s VolID=$o(^DHCWMRVOL(0,"Main",CurrMainID,VolID)) q:(VolID="")||(VolLOFlag=1)  d
 	.s VolData=$g(^DHCWMRVOL(VolID))
 	.s VolIsActive=$p(VolData,"^",7)
 	.q:VolIsActive'="Y"
 	.s VolStatus=$p(VolData,"^",6)
 	.q:VolStatus'=LOWorkItemID
 	.s VolLOFlag=1
 	
 	s LendOutFlag=""											//是否借出
 	s LendOutType=""											//借出类型
 	s:(MainLOFlag=1)||(VolLOFlag=1) LendOutFlag="Y"
 	s:MainLOFlag=1 LendOutType="病案" 							//病案借出
 	s:VolLOFlag=1 LendOutType="卷" 								//病案卷借出
 	s:(MainLOFlag=1)&&(VolLOFlag=1) LendOutType="病案+卷" 		//病案和病案卷都借出	
	q LendOutFlag_"^"_LendOutType
}

/// Creator：    刘学峰
/// CreatDate：  2010-11-13
/// Description：构造分科室出院未回收打印列表数据
/// Query：      QueryCurrStatusByDate
/// Input：      itmjs：js处理返回值函数
/// 			 strArguments：Query入参，"^"分隔。MrTypeDr+"^"+StatusDr+"^"+OperStartDate+"^"+OperEndDate
/// Return：     返回值交由js中itmjs方法处理
/// Debug:       w ##Class(web.DHCWMRVolumeQry).QueryCurrStatusByDateToPrint(itmjs,strArguments)
ClassMethod QueryDisSignListToPrint(itmjs As %Library.String = "", strArguments As %String) As %Status
{
	n (itmjs,strArguments)
	
	s Count=0
	s MrType=$p(strArguments,"^",1)
	s DateFrom=$p(strArguments,"^",2)
	s DateTo=$p(strArguments,"^",3)
	s LocId=$p(strArguments,"^",4)
	s WardId=$p(strArguments,"^",5)
	s DispalyFlag=$p(strArguments,"^",6)
	;s PrintFlag="Y" //$p(strArguments,"^",7) 此标志为"Y"，说明为导出或打印调用Query，Query中write函数不调用
	
	s JIndex=$j
	s DisStr=..GetDischargeList(JIndex,MrType,DateFrom,DateTo,DispalyFlag)
	;s ^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,LastAdm)=MrNO_"^"_VolRowid_"^"_MrType
	
	s WardIndex=""
	f  s WardIndex=$o(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex)) q:WardIndex=""  d
	.s tempDocDr=""
	.f  s tempDocDr=$o(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,tempDocDr)) q:tempDocDr=""  d
	..s tempAdm=""
	..f  s tempAdm=$o(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,tempDocDr,tempAdm)) q:(tempAdm="")  d
	...s MrNo=$p($g(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,tempDocDr,tempAdm)),"^",1)
	...s VolRowid=$p($g(^CacheTemp("DHCWMRADLIST",JIndex,WardIndex,tempDocDr,tempAdm)),"^",2)
	...s EpisodeID=tempAdm
	...s Loc=+$p($g(^PAADM(+EpisodeID)),"^",4)
	...s cnt=$g(^CacheTempWMR("DisSignList",JIndex,Loc))+1
	...s ^CacheTempWMR("DisSignList",JIndex,Loc)=cnt
	
	s StartRow=4
	s Count=0
	s tmpLoc=""
	s valCells=""
	f  s tmpLoc=$o(^CacheTempWMR("DisSignList",JIndex,tmpLoc)) q:tmpLoc=""  d
	.s Count=Count+1
	.s MissCnt=+$g(^CacheTempWMR("DisSignList",JIndex,tmpLoc))
	.s LocDesc=$p($g(^CTLOC(tmpLoc)),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s valCells=LocDesc_$c(1)_MissCnt
	.i Count#2=0 d
	..s StartCol=4
	.e  d
	..s StartCol=1
	.s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_","_StartCol_");"
	.&javascript<#(retval)#>
	.s:Count#2=0 StartRow=StartRow+1
	

	//打印标题
	s valCells="催还病案通知签名表"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',1,1);"
	&javascript<#(retval)#>
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	//s valCells="统计日期："_$zd(DateFrom,3)_" 至 "_$zd(DateTo,3)_"    合计:"_Count_"份"
	//$zd($zdh("27/01/2009",4),3)   从“27/11/2009” 到“2009-11-27”
	s valCells="统计日期："_$zd($zdh(DateFrom,4),3)_" 至 "_$zd($zdh(DateTo,4),3)_"          科室数:"_Count
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	
	k ^CacheTempWMR("DisSignList",JIndex)
	q Count
}

/// //////////////////////////////////////////////////////////////////////////////////
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRVolDisAdmQry","QueryDocDischList","7",)
Query QueryDocDischList(argMrType As %String, argDocID As %String, argScheduleDays As %String, argCTLocID As %String, argUserFlag As %String, argDeptFlag As %String, PrintFlag As %String) As %Query(ROWSPEC = "MrNo:%String:病案号,RegNo:%String:登记号,Name:%String:姓名,DisDate:%String:出院日期,DisDays:%String:出院天数,MrType:%String:病案类型,DocID:%String:医生ID,DocName:%String:医生姓名,WardDesc:%String:病区,PatientID:%String,EpisodeID:%String,OverTimeFlag:%String:逾期未归标志,ScheduleDays:%String:规定归还天数,OverTimeDays:%String:超期天数,FSStatusDesc:%String:结算状态,LocDesc:%String:科室名称")
{
}

ClassMethod QueryDocDischListExecute(ByRef qHandle As %Binary, argMrType As %String, argDocID As %String, argScheduleDays As %String, argCTLocID As %String, argUserFlag As %String, argDeptFlag As %String, PrintFlag As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:+argMrType<=0 argMrType=7
	
	;s HospCode=##class(web.DHCWMRMedBase01).GetDefaultHospCode() //add by liuxuefeng 2009-12-07

	;Get cStatusDR by argMrType,$h
	;0、当前病案类型的工作流，找到第一个状态（在院） *
	s sFlow=##class(web.DHCWMRWorkFlowCtl).GetWFLByTypeActiveDate(argMrType,"Y",$zd(+$h,3))
	s aFlow=$p(sFlow,$c(1),1)
	s cStatusDR=$p(aFlow,"^",3) ;工作流开始状态ID

	;^DHCWMRVOL(0,"VolAFS",{IsActive},{InFlow},{Status_Dr},{Rowid})
	q:'$d(^DHCWMRVOL(0,"VolAFS","Y","Y",cStatusDR)) $$$OK
		
	;1、在院状态的卷
	s VolRowid=""
	;^DHCWMRVOL(0,"VolAFS",{IsActive},{InFlow},{Status_Dr},{Rowid})
	f  s VolRowid=$o(^DHCWMRVOL(0,"VolAFS","Y","Y",cStatusDR,VolRowid)) q:VolRowid=""  d
	.s sVol=$g(^DHCWMRVOL(+VolRowid))
	.q:$p(sVol,"^",7)'="Y"                          //卷非活动
	.s MainRowid=+$p(sVol,"^",1)
	.q:$p($g(^DHCWMRMAIN(MainRowid)),"^",6)'="Y"    	//病案主信息非活动
	.s MrType=$p($g(^DHCWMRMAIN(MainRowid)),"^",1)		//根据病案类型过滤出院病人
	.q:(MrType'=argMrType)&&(+argMrType>0)								
	.s MrNo=$p($g(^DHCWMRMAIN(MainRowid)),"^",2)	
	.s EpisodeID=+$p(sVol,"^",2)
	.q:EpisodeID=0
	.s VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)									
	.q:(VisitStatus'="A")&&(VisitStatus'="D")
	.s DisDate=$p(##Class(web.DHCWMRBasePaadm).GetDisAdmDate(EpisodeID)," ",1)
	.q:+DisDate=0
	.s DisDays=+$h-$zdh(DisDate,3)						;出院天数
	.s OverTimeFlag="N"									;逾期未归标志
	.s OverTimeDays=0									;超期天数
	.i (+argScheduleDays>0)&&(DisDays>argScheduleDays) d
	..s OverTimeFlag="Y" 
	..s OverTimeDays=DisDays-argScheduleDays
	.s DocDr=+$p($g(^PAADM(+EpisodeID)),"^",9)			;取主治医生 CT_CareProv表Rowid
	.s UserID=$p(##class(web.DHCWMRMedBaseCtl).GetUserByCTCP(DocDr),"/",1) ;SS_User表Rowid
	.q:(argUserFlag="Y")&&(UserID'=argDocID)&&(+argDocID'=0)				;按照医生过滤
	.s LocID=+$p($g(^PAADM(+EpisodeID)),"^",4) 			;表CT_Loc的RowId
	.q:(argDeptFlag="Y")&&(LocID'=argCTLocID)&&(+argCTLocID'=0)				;按照科室过滤
	.s LocDesc=$p($g(^CTLOC(LocID)),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)			;科室描述
	.s Ward=+$p($g(^PAADM(EpisodeID)),"^",70)			;表PAC_Ward的RowId
	.s WardDesc=$p($g(^PAWARD(+Ward)),"^",2)
	.s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)			;病区描述
	.s PatientID=+$p($g(^DHCWMRMAIN(MainRowid)),"^",3)	
	.s Name=$p($g(^PAPER(PatientID,"ALL")),"^",1)		;病人姓名
	.s RegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)	;登记号
	.s DocName=$p($g(^SSU("SSUSR",+UserID)),"^",2)		;医生姓名
	.s ScheduleDays=argScheduleDays						;规定病案归还日期
	.s FSStatus=##Class(web.DHCWMRBasePaadm).GetFSStatus(EpisodeID) ;潍坊人民医院增加结算状态
	.s FSStatusDesc=""
	.s:FSStatus'="N" FSStatusDesc="未结算"
	.s Data=$lb("")
	.s $li(Data,1)=MrNo 
	.s $li(Data,2)=RegNo
 	.s $li(Data,3)=Name
	.s $li(Data,4)=DisDate
	.s $li(Data,5)=DisDays
	.s $li(Data,6)=MrType
	.s $li(Data,7)=UserID
	.s $li(Data,8)=DocName
	.s $li(Data,9)=WardDesc
	.s $li(Data,10)=PatientID
	.s $li(Data,11)=EpisodeID
	.s $li(Data,12)=OverTimeFlag
	.s $li(Data,13)=ScheduleDays
	.s $li(Data,14)=OverTimeDays
	.s $li(Data,15)=FSStatusDesc
	.s $li(Data,16)=LocDesc
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	s cnt=ind-1
	w:PrintFlag'="Y" "数量:"_cnt
	
	Quit $$$OK
}

ClassMethod QueryDocDischListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDocDischListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryDocDischListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDocDischListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：    刘学峰
/// CreatDate：  2011-03-09
/// Description：构造未完成操作打印列表数据
/// Query：      QueryDocDischList
/// Input：      itmjs：js处理返回值函数
/// 			 strArguments：Query入参，"^"分隔。
/// 				 argMrType+"^"+argDocID+"^"+argScheduleDays+"^"+argCTLocID+"^"+argUserFlag+"^"+argDeptFlag+"^"+PrintFlag
/// Return：     返回值交由js中itmjs方法处理
/// Debug:       w ##Class(web.DHCWMRVolDisAdmQry).QueryDocDischListToPrint(itmjs,strArguments)
ClassMethod QueryDocDischListToPrint(itmjs As %Library.String = "", strArguments As %String) As %Status
{
	n (itmjs,strArguments)
	s Count=0
	
	s argMrType=$p(strArguments,"^",1)
	s argDocID=$p(strArguments,"^",2)
	s argScheduleDays=$p(strArguments,"^",3)
	s argCTLocID=$p(strArguments,"^",4)
	s argUserFlag=$p(strArguments,"^",5)
	s argDeptFlag=$p(strArguments,"^",6)
	s PrintFlag=$p(strArguments,"^",7)
	
	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRVolDisAdmQry:QueryDocDischList")
	d ds.Execute(argMrType,argDocID,argScheduleDays,argCTLocID,argUserFlag,argDeptFlag,PrintFlag)
	s StartRow=4
	while(ds.Next())
	{	
		s MrNo=ds.Data("MrNo")							//病案号
		s RegNo=ds.Data("RegNo") 						//登记号
		s Name=ds.Data("Name")							//姓名
		s LocDesc=ds.Data("LocDesc")					//科室
		s WardDesc=ds.Data("WardDesc")					//病区
		s DisDate=ds.Data("DisDate")					//出院日期			
		s DisDays=ds.Data("DisDays")					//出院天数
		s OverTimeFlag=ds.Data("OverTimeFlag")			//是否逾期
		s OverTimeDays=ds.Data("OverTimeDays")			//超期天数
		s DocName=ds.Data("DocName")					//主治医生
		s FSStatusDesc=ds.Data("FSStatusDesc")			//结算状态
		

		//病案号,登记号,姓名,科室、病区、出院天数、是否逾期、超期天数、主治医生、结算状态
		s valCells=MrNo_$c(1)_RegNo_$c(1)_Name_$c(1)_LocDesc_$c(1)_WardDesc_$c(1)_DisDate_$c(1)_DisDays_$c(1)_OverTimeFlag_$c(1)_OverTimeDays_$c(1)_DocName_$c(1)_FSStatusDesc
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	//打印标题
	s DefaultHospStr=##class(web.DHCWMRMedBase01).GetDefaultHosp()
	s HospDesc=$p(DefaultHospStr,"^",3)
	s valCells=HospDesc_" "_LocDesc_" 逾期未归病案"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',1,1);"
	&javascript<#(retval)#>
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	s valCells="查询日期："_$zd(+$h,3)_"  "_$zt($p($h,",",2))_"    合计:"_Count_"份"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	q Count
}

/// Creator:wangCS
/// CreateDate:2011-10-09
/// Description:查询延迟出院患者
/// Input：延迟出院开始日期（startDate）、延迟出院结束日期（endDate）、科室（loc）、病区（ward）
/// Output：登记号、病案号、姓名、性别、就诊科室、主管医生
/// Debug:  w ##Class(%ResultSet).RunQuery("web.DHCWMRVolDisAdmQry","DelayDischargeQry","58722","63374","","")
Query DelayDischargeQry(startDate As %String, endDate As %String, loc As %String, ward As %String) As %Query(ROWSPEC = "PAPMINO:%String:登记号,MrNo:%String:病案号,Name:%String:姓名,Sex:%String:性别,Loc:%String:科室,Doctor:%String:主管医生")
{
}

ClassMethod DelayDischargeQryExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, loc As %String, ward As %String) As %Status
{
	;set ^TestDD("DelayDischargeQryExecute")=startDate_","_endDate
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	if (startDate="")!(endDate=""){
		quit $$$OK	
	}  
	s:startDate["-" startDate=$zdh(startDate,3)
	s:startDate["/" startDate=$zdh(startDate,4)
	s startDate=+startDate
	s:endDate["-" endDate=$zdh(endDate,3)
	s:endDate["/" endDate=$zdh(endDate,4)
	s endDate=+endDate
	
	for dischargeDate=startDate:1:endDate {
		;continue:'$d(^DHCPAAdm(0,"DischDate",dischargeDate)
		;^DHCPAAdm(0,"DischDate",61522,1)
		if ($d(^DHCPAAdm(0,"DischDate",dischargeDate))){
			set dhcpaadmRowId=0
			set dhcpaadmRowId=$o(^DHCPAAdm(0,"DischDate",dischargeDate,dhcpaadmRowId))
			while (dhcpaadmRowId'=""){
		      set dhcpaadmId=dhcpaadmRowId
			  set dhcpaadmRowId=$o(^DHCPAAdm(0,"DischDate",dischargeDate,dhcpaadmRowId))
			  ;b  ;dhcpaadmId
			  ;^DHCPAAdm(3)
			  set paadm=$p($g(^DHCPAAdm(dhcpaadmId)),"^",1)
			  ;^PAADM({PAADM_RowID})
			  set paadmDischagDate=$p($g(^PAADM(paadm)),"^",17)
			  ;b ;paadmDischagDate
			  Continue:paadmDischagDate'=""
			  set locRowId=$p($g(^PAADM(paadm)),"^",4)
		      q:(loc'="")&&(loc'=locRowId)
		      set wardRowId=$p($g(^PAADM(paadm)),"^",70)
		      q:(ward'="")&&(ward'=wardRowId)
		      set papmi=$p($g(^PAADM(paadm)),"^",1)
		      ;^PAPER({PAPMI_RowId})
		      set papmiNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
		      set mrNo=$p($g(^PAPER(papmi,"PAT",1)),"^",22)
		      set name=$p($g(^PAPER(papmi,"ALL")),"^",1)
		      set sexDR=$p($g(^PAPER(papmi,"ALL")),"^",7)   ;性别
		      ;^CT("SEX",{CTSEX_RowId})
		      set sex=$p($g(^CT("SEX",sexDR)),"^",2)   
		      ;^CTLOC({CTLOC_RowID})
		      set locDesc=$p($g(^CTLOC(locRowId)),"^",2)        ;科室
		      set docRowId=$p($g(^PAADM(paadm)),"^",9)      ;医生
		      ;^CTPCP({CTPCP_RowId})
		      set doctor=$p($g(^CTPCP(docRowId,1)),"^",2)   ;主管医生
		      set data=$lb(papmiNo,mrNo,name,sex,locDesc,doctor)
		      set ^CacheTemp(repid,ind)=data
		      set ind=ind+1
			}
			
		}
	}
	/*
	;^PAADMi("PAADM_Type",{PAADM_Type},{PAADM_RowID})
	set paadm=""
	set paadm=$o(^PAADMi("PAADM_Type","I",paadm))
	while(paadm'=""){
		;^DHCMRIPDetail(0,"TYPE","CYRS","ADM",adm)
		if ($d(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",paadm))){
			set iprowid="" 
		    set iprowid=$o(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",paadm,iprowid),-1)  
		    q:iprowid=""
		    set MRIPDayDr=$p(^DHCMRIPDetail(iprowid),"^",3)
		    set disdate=$p(^MRIPdaily(MRIPDayDr),"^",6)
		    q:(disdate>endDate)!(disdate<startDate) 
		    ;^PAADM({PAADM_RowID})
		    set locRowId=$p($g(^PAADM(paadm)),"^",4)
		    q:(loc'="")&(loc'=locRowId)
		    set wardRowId=$p($g(^PAADM(paadm)),"^",70)
		    q:(ward'="")&(ward'=wardRowId)
		    set papmi=$p($g(^PAADM(paadm)),"^",1)
		    ;^PAPER({PAPMI_RowId})
		    set papmiNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
		    set mrNo=$p($g(^PAPER(papmi,"PAT",1)),"^",22)
		    set name=$p($g(^PAPER(papmi,"ALL")),"^",1)
		    set sexDR=$p($g(^PAPER(papmi,"ALL")),"^",7)   ;性别
		    ;^CT("SEX",{CTSEX_RowId})
		    set sex=$p($g(^CT("SEX",sexDR)),"^",2)   
		    ;^CTLOC({CTLOC_RowID})
		    set loc=$p($g(^CTLOC(locRowId)),"^",2)        ;科室
		    set docRowId=$p($g(^PAADM(paadm)),"^",9)      ;医生
		    ;^CTPCP({CTPCP_RowId})
		    set doctor=$p($g(^CTPCP(docRowId,1)),"^",2)   ;主管医生
		    set data=$lb(papmiNo,mrNo,name,sex,loc,doctor)
		    set ^CacheTemp(repid,ind)=data
		    set ind=ind+1
		}
		set paadm=$o(^PAADMi("PAADM_Type","I",paadm))
	}
	*/
	Quit $$$OK
}

ClassMethod DelayDischargeQryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DelayDischargeQryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DelayDischargeQryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DelayDischargeQryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
