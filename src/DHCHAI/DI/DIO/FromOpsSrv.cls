/// 名称: DHCHAI.DI.DIO.FromOpsSrv
/// 描述: 手麻数据接口
/// 编写者：liyi
/// 编写日期: 2017-07-04
Class DHCHAI.DI.DIO.FromOpsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator 丁延丽 2017-08-03   日期索引：^DHCANOPArrange(0,"SDate",日期数字的)
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromOpsSrv","GetAnOpListForM","2021-03-29","2021-03-29","178")
Query GetAnOpListForM(stdate As %String, enddate As %String, EpisodeId As %String) As %Query(ROWSPEC = "OperID,EpisodeID,OperICD,OperDesc,OperType,StartDate,StartTime,EndDate,EndTime,OperHour,OperLocCode,OperLocDesc,OpertorCode,OpertorName,Assistant1,Assistant2,IncisionCode,Incision,HealingCode,Healing,AnesMethodCode,AnesMethod,Anesthesia,ASAScore,NNISGrade,WBC,IncisionNum,IsSightGlass,IsImplants,LoseBlood,GotBlood,Complication,DiagDesc,OpRoomDesc,OpStatus,OperTypeValue,OPertypesoc,Status")
{
}

ClassMethod GetAnOpListForMExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, EpisodeId As %String) As %Status
{
	///paidType "Y"已收费，"N"未收费，其它为全部
  	Set repid=$I(^CacheTemp)
  	s ind=1
    k ^TMPAN("AppM",$j)
	//手麻记录ID：OperID、手术编码：OperICD、手术名称：OperDesc、手术类型：OperType、手术开始日期：StartDate
	//OperID,OperICD,OperDesc,OperType,StartDate
	//、手术开始时间：StartTime、手术结束日期：EndDate、手术结束时间：EndTime、手术时长：OperHour、手术科室代码：OperLocCode
	//,StartTime,EndDate,EndTime,OperHour,OperLocCode
	//手术科室名称：OperLocDesc、术者代码：OpertorCode、术者名称：OpertorName、一助：Assistant1、二助：Assistant2
	//,OperLocCode,OperLocDesc,OpertorCode,OpertorName,Assistant1,Assistant2
	//切口类型代码：IncisionCode、切口类型：Incision、愈合情况代码：HealingCode、愈合情况：Healing、麻醉方式代码：AnesMethodCode
	//,IncisionCode,Incision,HealingCode,Healing,AnesMethodCode
	//麻醉方式：AnesMethod、麻醉医师：Anesthesia,ASA评分：ASAScore、NNIS分级：NNISGrade、术前外周WBC计数：WBC、切口个数：IncisionNum
	//,AnesMethod,Anesthesia,ASAScore,NNISGrade,WBC,IncisionNum
	//是否使用窥镜：IsSightGlass、是否有植入物：IsImplants、失血量：LoseBlood、输血量：GotBlood、术后并发症：Complication
	//,IsSightGlass,IsImplants,LoseBlood,GotBlood,Complication
	//诊断:DiagDesc,术间:OpRoomDesc,状态:OpStatus,组织部位:OperTypeValue
	//,DiagDesc,OpRoomDesc,OpStatus,OperTypeValue

	i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
	Set sdate=stdate
	Set edate=enddate
	Set:stdate["-" sdate=$zdh(stdate,3)
	Set:enddate["-" edate=$zdh(enddate,3)
	if (EpisodeId'=""){   
		s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeId,opaId)) q:opaId=""  d
		.d GetANOperationForM
	}else {  
		f date=sdate:1:+edate {
			s opaId=""
			f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
			.d GetANOperationForM  
		}
	}  
	k ^TMPAN("AppM",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

GetANOperationForM
	q:$d(^DHCANOPArrange(opaId))<1
	s NewTableFlag=0
	s ifOutOper=$g(^DHCANOPArrange("OUTOP",opaId))
	q:(ifOutOper="O") ;门诊不在之内
	s opdate="",oproomdes="",regNo="",patName="",diag=""
	s sopdes="",locdes="",opd="",mzdoc="",anmethod=""
	s xsh="",xch="",OPCategory="",opUnPlanedOperation="",ASA=""
	s IsSightGlass="",IsImplants="",LoseBlood="",GotBlood="",Complication=""
	s OperLocCode="",OperLocDesc="",OpertorCode="",OpertorName="",Assistant1=""
	s Assistant2="",oproomdes="",opaStatus="",operTypeValue=""
	s IncisionCode="",Incision="",HealingCode="",Healing="",AnesMethodCode=""
	s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	i oproomdr'="" s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)

	s LoseBlood=$p($g(^DHCANOPArrange(opaId,"InOut",11)),"^",3) 
	s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
	s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
	
	s openddate=$P(^DHCANOPArrange(opaId),"^",16)
	s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
	s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm
	q:adm=""
	s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	i opaStatus=""  s opaStatus="A"
	//q:(opaStatus="D")!(opaStatus="C")  //判断去除会造成安排的手术后面取消状态无法同步到
	i opaStatus="A" s status="申请"
	i (opaStatus="D") s status="拒绝"
	i opaStatus="R" s status="安排"
	i opaStatus="N" s status="非预约"
	i opaStatus="I" s status="术中"
	i opaStatus="P" s status="恢复室"
	i opaStatus="L" s status="术毕"
	i opaStatus="F" s status="完成"
	i (opaStatus="C") s status="撤销"
	i opaStatus="S" s status="拟日间"

	s opaPatStatus=$P(^DHCANOPArrange(opaId),"^",23)
	s papmiId=$p($g(^PAADM(admId)),"^",1)
	s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	s jz=$P(^OR(adm,"ANA",chl),"^",32) //ANA_SourceType 急诊(E)/择期(B)
	i jz="E" s jzstat="急诊"
	e  s jzstat="择期"
	s anaTheatreIn=""
	s anaTheatreInDate=$p(^OR(adm,"ANA",chl),"^",39)
	e  s anaTheatreInDate=opstdate
	s anaTheatreInTime=$p(^OR(adm,"ANA",chl),"^",40)
	e  s anaTheatreInTime=opsttime
	
	s ass=0,surgeonDesc=""
	;ANA_Method:麻醉方法+dyl+20120611
	s mzdoc=""
	s mzdr=$P(^OR(adm,"ANA",chl),"^",6)        				;ANA_Anaesthetist_Dr 
	i mzdr'="" d		
	.s mzdoc=##class(web.DHCANOPCom).GetNameById(mzdr)		;麻醉医师
	.e  s mzdoc=""
	s anmethod="",anmethodCodeStr=""
	s anmthdr=$P(^OR(adm,"ANA",chl),"^",5)
	s anmthdr=$tr(anmthdr,"|",",")
	i anmthdr'="" d
	.s anmetNum=$l(anmthdr,",")
	.f i=1:1:anmetNum d
	..s anmetId=$p(anmthdr,",",i)
	..q:anmetId=""
	..s anmethodCode=$p($g(^ORC("ANMET",anmetId)),"^",1)
	..s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
	..i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
	..i (anmethod'="")&(anmethod'[anmetDesc) s anmethod=anmethod_","_anmetDesc
	..i (anmethod'="")&(anmethod[anmetDesc) s anmethod=anmethod
	..e  s anmethod=anmetDesc
	..e  i (anmethodCodeStr'="")&(anmethodCodeStr'[anmethodCode) s anmethodCodeStr=anmethodCodeStr_","_anmethodCode
	..e  i (anmethodCodeStr'="")&(anmethodCodeStr[anmethodCode) s anmethodCodeStr=anmethodCode
	..e  s anmethodCodeStr=anmethodCode

	;并发症
	s anCompDesc="",diag="" ,OPertypesoc="" //手术类型 治疗性操作                                        //+ wxl 090316 合并疾病
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"COMP",subchl)) q:(subchl="")  d
	.s AnCompDr=$P(^OR(adm,"ANA",chl,"COMP",subchl),"^",1)
	.q:AnCompDr=""
	.i anCompDesc="" s anCompDesc=$P(^ORC("COMP",AnCompDr),"^",2)
	.e  s anCompDesc=anCompDesc_","_$P(^ORC("COMP",AnCompDr),"^",2)
	.s predigdrS=$P($g(^OR(adm,"ANA",chl,"OP",subchl)),"^",4)   		;ANAOP_PreopDiag_DR 术前诊断字符串  zhangtao add
	.s num=$l(predigdrS,"|")
	.f pi=1:1:num d
	..s predigdr=$p(predigdrS,"|",pi)
	..i predigdr'=""  d
	...s anaOPPreopDiagDR=$P(^MRC("ID",predigdr),"^",2)
	..s $p(diag,",",pi)=$G(anaOPPreopDiagDR)
	..e  d
	...i $g(^OR(EpisodeID,"ANA",anaSub,"TXT",2))'="" d 
	....s diamen=$p(^OR(EpisodeID,"ANA",anaSub,"TXT",2),"|",pi)  
	....s $p(diag,",",pi)=$G(diamen)            //zhangtao add

	s i=0
	s icdCodeStr="",OpertorCode="",opdes="",anaopBladeTypeCode="",anaopBladeType=""
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
	.s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6) ;ANAOP_Type_DR ；手术名称
	.i opdr'=""  d
	..s OPertypesoc=$p($g(^ORC("OPER",+opdr,"DHC")),"^",11)
	..i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d  
	...s operICDcode=$p(^ORC("OPER",+opdr),"^",14)
	...i opdes'="" s opdes=opdes_"," _$P($g(^ORC("OPER",+opdr)),"^",2)
	...e  s opdes=$P($g(^ORC("OPER",+opdr)),"^",2)
	...i icdCodeStr'="" s icdCodeStr=icdCodeStr _"," _operICDcode
	...e  s icdCodeStr=operICDcode
	.e  d
	..i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="" d
	...s opdes=$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))
	.s i=i+1
	.q:i>1 ;手术级别只取主手术的
	.s opd=""
	.s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8) ;ANAOP_Surgeon_DR 手术医师
	.i docdr'="" d
	..s opd=##class(web.DHCANOPCom).GetNameById(docdr)
	..s userId=$o(^SSU("SSUSR",0,"CTPCP",docdr,""),-1)
	..i userId'="" s OpertorCode=$p($g(^SSU("SSUSR",userId)),"^",1)
	.s surgeonDesc=opd   
	.s operLocId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",10) ;ANAOP_CTLOC_DR
	.s as=0 f  s as=$O(^OR(adm,"ANA",chl,"OP",subchl,"ASS",as)) q:(as="")  d
	..s asdr=$P(^OR(adm,"ANA",chl,"OP",subchl,"ASS",as),"^",1)
	..i as=1 s ass1=##class(web.DHCANOPCom).GetNameById(asdr)
	..i as=2 s ash=##class(web.DHCANOPCom).GetNameById(asdr)
	    .s curAnaopBladeTypeId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",9)
	.i curAnaopBladeTypeId'="" d
	..s tmpCode=$p(^ORC("BLDTP",curAnaopBladeTypeId),"^",1)
	..i anaopBladeTypeCode'="" d
	...s anaopBladeTypeCode=anaopBladeTypeCode_","_tmpCode
	...s anaopBladeType=anaopBladeType_","_$p(^ORC("BLDTP",+curAnaopBladeTypeId),"^",2)
	..e  s anaopBladeTypeCode=tmpCode,anaopBladeType=$p(^ORC("BLDTP",+curAnaopBladeTypeId),"^",2)

	s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)

	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$P(anaId,"||",2)
	s appLocId=$P($G(^DHCANOPArrange(opaId)),"^",54) //OPA_AppLoc_Dr
	s adm=$P(^DHCANOPArrange(opaId),"^",1)
	i appLocId="" s appLocId=$P(^PAADM(adm),"^",4)
	s appLocDesc=$P($G(^CTLOC(+appLocId)),"^",2)
	s appLocCode=$P($G(^CTLOC(+appLocId)),"^",1)
	Set Anesthesia=mzdoc   // 麻醉医师
	
	//取手麻系统的手术开始、结束时间
	s opsId="",DataModuleId="",StItemId="",EndItemId="",Opstarttime="",Opendtime="",Opstartdate="",Openddate="",AnaStartdate="",AnaEnddate="",OperRoomIndate="",OperRoomOutdate="",AnaStarttime="",AnaEndtime="",OperRoomIntime="",OperRoomOuttime=""
	s OpsReportVer=##class(DHCHAI.BT.Config).GetValByCode("DPOpsReportVer")
	i OpsReportVer="OPS2.0"  {
		
		Set ModuleID =$o(^CT.AN.DataModuleI("ICode"," ANAESTRECORD",0))     //麻醉记录	
		Set StItemID = $o(^CT.AN.DataItemI("ICode"," "_$ZCVT("OperStart","U"),0))
		Set EndItemID = $o(^CT.AN.DataItemI("ICode"," "_$ZCVT("OperEnd","U"),0))
		Set AnaStItemID = $o(^CT.AN.DataItemI("ICode"," "_$ZCVT("AnaStart","U"),0))
		Set AnaEndItemID = $o(^CT.AN.DataItemI("ICode"," "_$ZCVT("AnaEnd","U"),0))
		Set RoomInItemID = $o(^CT.AN.DataItemI("ICode"," "_$ZCVT("OperRoomIn","U"),0))
		Set RoomOutItemID = $o(^CT.AN.DataItemI("ICode"," "_$ZCVT("OperRoomOut","U"),0))
		Set xScheduleID=0
		For {
			Set xScheduleID=$o(^CIS.AN.OperScheduleI("Ext"," "_opaId,xScheduleID))
			Quit:xScheduleID=""
		
			Set xSheetID = 0
			For {
				Set xSheetID=$o(^CIS.AN.RecordSheetI("IOPS",xScheduleID,xSheetID))
				Quit:xSheetID=""
				
				Set RecordSheet=$g(^CIS.AN.RecordSheetD(xSheetID))
				Continue:RecordSheet=""
				Set DataModule= $lg(RecordSheet,2)			
				Continue:DataModule'=ModuleID
			
				Set xParaItemID = 0
				For {
					Set xParaItemID=$o(^CIS.AN.ParaItemI("ISheet",xSheetID,xParaItemID))
					Quit:xParaItemID=""

					Set ParaItem=$g(^CIS.AN.ParaItemD(xParaItemID))
					Continue:ParaItem=""
					Set ItemCode= $lg(ParaItem,3)
					Continue:ItemCode'="OperationEvent"

					Set xAnaDataID = 0
					For {
						Set xAnaDataID=$o(^CIS.AN.AnaDataI("IParaItem",xParaItemID,xAnaDataID))
						Quit:xAnaDataID=""
						
						Set AnaData=$g(^CIS.AN.AnaDataD(xAnaDataID))
						Continue:AnaData=""
						Set StartDate=$lg(AnaData,2)
						Set StartTime=$lg(AnaData,3)
   					    Set DataItem=$lg(AnaData,12)
   					    Continue:(DataItem'=StItemID)&(DataItem'=EndItemID)&(DataItem'=AnaStItemID)&(DataItem'=AnaEndItemID)&(DataItem'=RoomInItemID)&(DataItem'=RoomOutItemID)
						Set:DataItem=StItemID Opstartdate=StartDate,Opstarttime=StartTime
						Set:DataItem=EndItemID Openddate=StartDate,Opendtime=StartTime
						Set:DataItem=AnaStItemID AnaStartdate=StartDate,AnaStarttime=StartTime
						Set:DataItem=AnaEndItemID AnaEnddate=StartDate,AnaEndtime=StartTime
						Set:DataItem=RoomInItemID OperRoomIndate=StartDate,OperRoomIntime=StartTime
						Set:DataItem=RoomOutItemID OperRoomOutdate=StartDate,OperRoomOuttime=StartTime

					}
				}
			}			
		}
		
		Set ASA=##class(DHCHAI.DI.DIO.FromOpsSrv).GetExtendValueByOpaId(opaId,"ASAClass")
		Set NNISGrade=##class(DHCHAI.DI.DIO.FromOpsSrv).GetExtendValueByOpaId(opaId,"NNISRate")
		Set operTypeValue=##class(DHCHAI.DI.DIO.FromOpsSrv).GetExtendValueByOpaId(opaId,"OperationType")
		Set GotBlood=##class(DHCHAI.DI.DIO.FromOpsSrv).GetExtendValueByOpaId(opaId,"BloodVol")
		Set LoseBlood=##class(DHCHAI.DI.DIO.FromOpsSrv).GetExtendValueByOpaId(opaId,"BloodLoss")
		Set BladeClean=##class(DHCHAI.DI.DIO.FromOpsSrv).GetExtendValueByOpaId(opaId,"OpBladeClean")  //手术切口清洁程度
		Set:BladeClean'="" anaopBladeType=BladeClean
		Set:BladeClean="I" anaopBladeTypeCode=2
		Set:BladeClean="II" anaopBladeTypeCode=3
		Set:BladeClean="III" anaopBladeTypeCode=4
		Set:BladeClean="IV" anaopBladeTypeCode=5
		
		/*
		Set xScheduleID=0
		For {
			Set xScheduleID=$o(^CIS.AN.OperScheduleI("Ext"," "_opaId,xScheduleID))
			Quit:xScheduleID=""
			
			Set xAnaID=0
			For {
				Set xAnaID=$o(^CIS.AN.AnaesthesiaI("IOPS",xScheduleID,xAnaID))
				Quit:xAnaID=""
				Set AnaInfo=$g(^CIS.AN.AnaesthesiaD(xAnaID))
				Continue:AnaInfo=""
				Set Starttime=$lg(AnaInfo,15)   //手术开始时间
				Set Endtime=$lg(AnaInfo,16)     //手术结束时间
				Set Inortime=$lg(AnaInfo,7)     //入手术室时间
				Set Outortime=$lg(AnaInfo,8)    //出手术室时间
				Set Anaesthesiatime=$lg(AnaInfo,11)    //麻醉开始时间
				Set AnesthesiaendTime=$lg(AnaInfo,12)  //麻醉结束时间
				Set InpacuTime=$lg(AnaInfo,17)          //入麻醉后监测室时间
				Set OutpacuTime=$lg(AnaInfo,18)         //出麻醉后监测室时间				
				
				Set Opstartdate=$p(Starttime," ",1),Opstarttime=$p(Starttime," ",2)
				Set Openddate=$p(Endtime," ",1),Opendtime=$p(Endtime," ",2)
				Set AnaStartdate=$p(Anaesthesiatime," ",1),AnaStarttime=$p(Anaesthesiatime," ",2)
				Set AnaEnddate=$p(AnesthesiaendTime," ",1),AnaEndtime=$p(AnesthesiaendTime," ",2)
				Set OperRoomIndate=$p(Inortime," ",1),OperRoomIntime=$p(Inortime," ",2)
				Set OperRoomOutdate=$p(Outortime," ",1),OperRoomOuttime=$p(Outortime," ",2)
			  
				Set ASA=$lg(AnaInfo,19)           //ASA分级
				Set Asalevel=$lg(AnaInfo,20)           //麻醉手术分级
				Set LoseBlood=$lg(AnaInfo,32)          //术中失血总量
			}
		}
	    */
	
	} else {
		;旧版-手术开始、结束日期时间-Opstartdate、Opstarttime、Openddate、Opendtime
		s StItemId=$o(^DHCANC("ComOrd",0,"TypeCode","E","OperStart",""))
		s EndItemId=$o(^DHCANC("ComOrd",0,"TypeCode","E","OperEnd",""))
		i StItemId'="" d
		.s anoId="" f  s anoId=$o(^DHCANOrder(0,"CommOrd",StItemId,opaId,anoId),-1) q:(anoId="")  d
	    ..q:"CD"[$p($g(^DHCANOrder(anoId)),"^",25)
	    ..s Opstartdate=$p(^DHCANOrder(anoId),"^",5)
	    ..s Opstarttime=$p(^DHCANOrder(anoId),"^",6)
	    i EndItemId'="" d
		.s anoId="" f  s anoId=$o(^DHCANOrder(0,"CommOrd",EndItemId,opaId,anoId),-1) q:(anoId="")  d
	    ..q:"CD"[$p($g(^DHCANOrder(anoId)),"^",25)
	    ..s Openddate=$p(^DHCANOrder(anoId),"^",5)
	    ..s Opendtime=$p(^DHCANOrder(anoId),"^",6)
	    
		;旧版-麻醉开始、结束时间-AnaStarttime、AnaEndtime
		s StItemId=$o(^DHCANC("ComOrd",0,"TypeCode","E","AnaStart",""))
		s EndItemId=$o(^DHCANC("ComOrd",0,"TypeCode","E","AnaEnd",""))
		i StItemId'="" d
		.s anoId="" f  s anoId=$o(^DHCANOrder(0,"CommOrd",StItemId,opaId,anoId),-1) q:(anoId="")  d
	    ..q:"CD"[$p($g(^DHCANOrder(anoId)),"^",25)
	    ..s AnaStarttime=$p(^DHCANOrder(anoId),"^",6)
	    i EndItemId'="" d
		.s anoId="" f  s anoId=$o(^DHCANOrder(0,"CommOrd",EndItemId,opaId,anoId),-1) q:(anoId="")  d
	    ..q:"CD"[$p($g(^DHCANOrder(anoId)),"^",25)
	    ..s AnaEndtime=$p(^DHCANOrder(anoId),"^",6)
		;旧版-入室、离室时间-OperRoomIntime、OperRoomOuttime
		s StItemId=$o(^DHCANC("ComOrd",0,"TypeCode","E","TheatreIn",""))
		s EndItemId=$o(^DHCANC("ComOrd",0,"TypeCode","E","TheatreOut",""))
		i StItemId'="" d
		.s anoId="" f  s anoId=$o(^DHCANOrder(0,"CommOrd",StItemId,opaId,anoId),-1) q:(anoId="")  d
	    ..q:"CD"[$p($g(^DHCANOrder(anoId)),"^",25)
	    ..s OperRoomIntime=$p(^DHCANOrder(anoId),"^",6)
	    i EndItemId'="" d
		.s anoId="" f  s anoId=$o(^DHCANOrder(0,"CommOrd",EndItemId,opaId,anoId),-1) q:(anoId="")  d
	    ..q:"CD"[$p($g(^DHCANOrder(anoId)),"^",25)
	    ..s OperRoomOuttime=$p(^DHCANOrder(anoId),"^",6)
	    
	    s ASA=$p(##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"ASAClass"),$c(3),1)
		s NNISGrade=$p(##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"NNISRate"),$c(3),1)
		s operTypeValue=""
		s retStrT=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"comOPType")
		i retStrT'="" s operTypeValue=$p(retStrT,$c(3),1)
	}
	//手术日期取值优先顺序 手术时间>麻醉时间>入室出室时间
	i Opstartdate'="" s opstdate=Opstartdate
	i Openddate'="" s openddate=Openddate
	i Opstarttime'="" s opsttime=Opstarttime
	i Opendtime'="" s opendtime=Opendtime
	
	i (Opstartdate="")&(AnaStartdate'="") s opstdate=AnaStartdate
	i (Openddate="")&(AnaEnddate'="") s openddate=AnaEnddate
	i (Opstarttime="")&(AnaStarttime'="") s opsttime=AnaStarttime
	i (Opendtime="")&(AnaEndtime'="") s opendtime=AnaEndtime
	
	i (Opstartdate="")&(AnaStartdate="")&(OperRoomIndate'="") s opstdate=OperRoomIndate
	i (Openddate="")&(AnaEnddate="")&(OperRoomOutdate'="") s openddate=OperRoomOutdate
	i (Opstarttime="")&(AnaStarttime="")&(OperRoomIntime'="") s opsttime=OperRoomIntime
	i (Opendtime="")&(AnaEndtime="")&(OperRoomOuttime'="") s opendtime=OperRoomOuttime

	// 手术时长
	Set OperHour = ..GetHourByDateTime(opstdate,opsttime,openddate,opendtime)

	s ^TMPAN("AppM",$j,opaId)=$lb(opaId,EpisodeID,icdCodeStr,opdes,jzstat,opstdate,opsttime,openddate,opendtime,OperHour,appLocCode,appLocDesc,OpertorCode,surgeonDesc,ass1,ass2,anaopBladeTypeCode,anaopBladeType,HealingCode,Healing,anmethodCodeStr,anmethod,Anesthesia,ASA,NNISGrade,WBC,IncisionNum,IsSightGlass,IsImplants,LoseBlood,GotBlood,anCompDesc,diag,oproomdes,opaStatus,operTypeValue,OPertypesoc,status)
	d OutRow2
	q

OutRow2
	Set ^CacheTemp(repid,ind)=^TMPAN("AppM",$j,opaId)
	Set ind=ind+1
	quit
}

ClassMethod GetAnOpListForMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpListForMExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
  	Set repid=$LIST(qHandle,2)
  	Set ind=$LIST(qHandle,3)
  	Set ind=$o(^CacheTemp(repid,ind))
  	If ind="" { // if there are no more rows, finish fetching
  		Set AtEnd=1
  		Set Row=""
  	}
  	Else {
  		Set Row=^CacheTemp(repid,ind)
  	}
  	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpListForMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpListForMExecute ]
{
	Set repid=$LIST(qHandle,2)
  	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-04
/// Description:  计算两个时间的间隔小时数（时差-小时）
/// Input：       aFromDate ：开始日期  YYYY-MM-DD 或者 数字格式
///               aFromTime : 开始时间  HH:MM:SS   或者 数字格式
///               aEndDate  ：结束日期  YYYY-MM-DD 或者 数字格式
///               aEndTime  : 结束时间  HH:MM:SS   或者 数字格式
/// Return:		  时间间隔小时数
/// Debug:		  w ##class(DHCHAI.Utils.CommonSrv).GetHourByDateTime("2017-08-04","01:00:00","2017-08-04","05:00:00")
ClassMethod GetHourByDateTime(aFromDate As %String, aFromTime As %String, aEndDate As %String, aEndTime As %String) As %String
{
	Set return=0
	Quit:(aFromDate="")||(aFromTime="")||(aEndDate="")||(aEndTime="") return
	Set Hours=0
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Set:aEndDate["-" aEndDate=$zdh(aEndDate,3)
	Set:aEndTime[":" aEndTime=$zth(aEndTime,1)
	Quit:(aFromDate>aEndDate) return  // 开始日期大于结束日期
	Quit:(aFromDate=aEndDate)&&(aFromTime>aEndTime) return
	
	If (aFromDate=aEndDate) {
		Set HoursNumber = $Number((aEndTime-aFromTime)/3600,1) 
		If (HoursNumber["."){
			Set Hours = $e(HoursNumber,0,1)+1
		}else{
			Set Hours = $e(HoursNumber,0,1)
		}
		//Set Hours=$Number((aEndTime-aFromTime)/3600,0)+1     // 向上取整
	} Else {  // aFromDate<aEndDate
		Set DayHours=(aEndDate-aFromDate)*24
		//Set tmpHours=$Number((aEndTime-aFromTime)/3600,0)+1  // 向上取整	
		Set tmpHours=$Number((aEndTime-aFromTime)/3600,1)  // 向上取整
		If (tmpHours["."){
			Set Hours = $e(tmpHours,0,1)+1
		}else{
			Set Hours = $e(tmpHours,0,1)
		}
		Set Hours=DayHours+tmpHours
	}
	Set return = Hours
	Quit return
}

/// Creator：  YuanLin
/// CreatDate：2021-06-11
/// Input：    opaId,项目Code
/// Output:    ASAClass,NNISRateValue,OperClassDesc
/// Function:  获取扩展信息(手术ASA评分、NNIS分级、手术级别(可能有多个,逗号分隔)、麻醉单失血量、输血量)
/// d ##class(web.DHCANAdaptor).GetExtendValueByOpaId("64","OpBladeClean")
ClassMethod GetExtendValueByOpaId(opaId As %String, code As %String) As %String
{
	q:opaId="" ""
	q:code="" ""
	s ExtendValue="",opsId="",DataModuldId="",RecordSheetId="",OperDataId="",AnaesthesiaId=""
	s DataCategoryId="",dataCategoryId="",ParaItemId="",AnaDataId=""
	s opsId=$o(^CIS.AN.OperScheduleI("Ext"," "_opaId,opsId))
	q:opsId="" ""           //add 20220214 没有手麻记录导致报错修改
	f  s DataCategoryId=$o(^CT.AN.DataCategoryD(DataCategoryId)) q:DataCategoryId=""  d
	.s DataCategoryDesc=$lg(^CT.AN.DataCategoryD(DataCategoryId),2)
	.s MainCategory=$lg(^CT.AN.DataCategoryD(DataCategoryId),3)
	.q:MainCategory=""
	.q:DataCategoryDesc'="血浆制品"
	.s dataCategoryId=DataCategoryId
	
    i code="ASAClass" d
    .s AnaesthesiaId=$o(^CIS.AN.AnaesthesiaI("IOPS",opsId,AnaesthesiaId))
    .s ExtendValue=$lg(^CIS.AN.AnaesthesiaD(AnaesthesiaId),19)
    i code="OperClass" d
	.s operListObj=##class(CIS.AN.BL.OperationList).GetOperListObject(opsId)
	.s OperClass=operListObj.OperClass
	.s ExtendValue=operListObj.OperClassDesc
	i code="NNISRate" d
	.s url="CIS.AN.OperRiskAssessment.csp"
	.f  s DataModuldId=$o(^CT.AN.DataModuleD(DataModuldId)) q:DataModuldId=""  d
	..s URL=$lg(^CT.AN.DataModuleD(DataModuldId),4)
	..q:$zcvt(URL,"U")'=$zcvt(url,"U")
	..f  s RecordSheetId=$o(^CIS.AN.RecordSheetI("IOPS",opsId,RecordSheetId)) q:RecordSheetId=""  d
	...s dataModuldId=$lg(^CIS.AN.RecordSheetD(RecordSheetId),2)
	...q:(dataModuldId'=DataModuldId)
	...f  s OperDataId=$o(^CIS.AN.OperDataI("ISheet",RecordSheetId,OperDataId)) q:OperDataId=""  d
	....s OperCode=$lg(^CIS.AN.OperDataD(OperDataId),2)
	....q:(OperCode'=code)
	....s ExtendValue=$lg(^CIS.AN.OperDataD(OperDataId),3)
	i code="OperationType" d
	.s url="CIS.AN.OperRiskAssessment.csp"
	.f  s DataModuldId=$o(^CT.AN.DataModuleD(DataModuldId)) q:DataModuldId=""  d
	..s URL=$lg(^CT.AN.DataModuleD(DataModuldId),4)
	..q:$zcvt(URL,"U")'=$zcvt(url,"U")
	..f  s RecordSheetId=$o(^CIS.AN.RecordSheetI("IOPS",opsId,RecordSheetId)) q:RecordSheetId=""  d
	...s dataModuldId=$lg(^CIS.AN.RecordSheetD(RecordSheetId),2)
	...q:(dataModuldId'=DataModuldId)
	...f  s OperDataId=$o(^CIS.AN.OperDataI("ISheet",RecordSheetId,OperDataId)) q:OperDataId=""  d
	....s OperCode=$lg(^CIS.AN.OperDataD(OperDataId),2)
	....q:(OperCode'=code)
	....s ExtendValue=$lg(^CIS.AN.OperDataD(OperDataId),3)
	//手术切口清洁程度
	i code="OpBladeClean" d              
	.s url="CIS.AN.OperRiskAssessment.csp"
	.f  s DataModuldId=$o(^CT.AN.DataModuleD(DataModuldId)) q:DataModuldId=""  d
	..s URL=$lg(^CT.AN.DataModuleD(DataModuldId),4)
	..q:$zcvt(URL,"U")'=$zcvt(url,"U")
	..f  s RecordSheetId=$o(^CIS.AN.RecordSheetI("IOPS",opsId,RecordSheetId)) q:RecordSheetId=""  d
	...s dataModuldId=$lg(^CIS.AN.RecordSheetD(RecordSheetId),2)
	...q:(dataModuldId'=DataModuldId)
	...f  s OperDataId=$o(^CIS.AN.OperDataI("ISheet",RecordSheetId,OperDataId)) q:OperDataId=""  d
	....s OperCode=$lg(^CIS.AN.OperDataD(OperDataId),2)
	....q:(OperCode'=code)
	....s ExtendValue=$lg(^CIS.AN.OperDataD(OperDataId),3)
	
	i code="BloodVol" d
	.s url="CIS.AN.AnaestRecord.csp"
	.f  s DataModuldId=$o(^CT.AN.DataModuleD(DataModuldId)) q:DataModuldId=""  d
	..s URL=$lg(^CT.AN.DataModuleD(DataModuldId),4)
	..q:$zcvt(URL,"U")'=$zcvt(url,"U")      //手麻组存储URL变化导致取不到值修改
	..f  s RecordSheetId=$o(^CIS.AN.RecordSheetI("IOPS",opsId,RecordSheetId)) q:RecordSheetId=""  d
	...s dataModuldId=$lg(^CIS.AN.RecordSheetD(RecordSheetId),2)
	...q:(dataModuldId'=DataModuldId)
	...f  s ParaItemId=$o(^CIS.AN.ParaItemI("ISheet",RecordSheetId,ParaItemId)) q:ParaItemId=""  d
	....s DataCategory=$lg(^CIS.AN.ParaItemD(ParaItemId),5)
	....i (DataCategory=dataCategoryId) d
	.....f  s AnaDataId=$o(^CIS.AN.AnaDataI("IParaItem",ParaItemId,AnaDataId)) q:AnaDataId=""  d
	......s DrugDataId=""
	......s EditFlag=$lg(^CIS.AN.AnaDataD(AnaDataId),7)
	......q:EditFlag'="N"
	......s DrugDataId=$o(^CIS.AN.DrugDataI("IAnaData",AnaDataId,DrugDataId))
	......s Blood=$lg(^CIS.AN.DrugDataD(DrugDataId),2)
	......s ExtendValue=ExtendValue+Blood
	...s:ExtendValue'="" ExtendValue=ExtendValue_"ml"
	i code="BloodLoss" d
	.s url="CIS.AN.AnaestRecord.csp"
	.f  s DataModuldId=$o(^CT.AN.DataModuleD(DataModuldId)) q:DataModuldId=""  d
	..s URL=$lg(^CT.AN.DataModuleD(DataModuldId),4)
	..q:$zcvt(URL,"U")'=$zcvt(url,"U")
	..f  s RecordSheetId=$o(^CIS.AN.RecordSheetI("IOPS",opsId,RecordSheetId)) q:RecordSheetId=""  d
	...s dataModuldId=$lg(^CIS.AN.RecordSheetD(RecordSheetId),2)
	...q:(dataModuldId'=DataModuldId)
	...f  s ParaItemId=$o(^CIS.AN.ParaItemI("ISheet",RecordSheetId,ParaItemId)) q:ParaItemId=""  d
	....s ParaDesc=$lg(^CIS.AN.ParaItemD(ParaItemId),4)
	....q:ParaDesc'="失血量"
	....f  s AnaDataId=$o(^CIS.AN.AnaDataI("IParaItem",ParaItemId,AnaDataId)) q:AnaDataId=""  d
	.....s EditFlag=$lg(^CIS.AN.AnaDataD(AnaDataId),7)
	.....q:EditFlag'="N"
	.....s ExtendValue=$lg(^CIS.AN.AnaDataD(AnaDataId),6)
	....s:ExtendValue'="" ExtendValue=ExtendValue_"ml"
	q ExtendValue
}

}
