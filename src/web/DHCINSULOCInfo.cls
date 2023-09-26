Import SQLUser

/// 医保就诊信息类
Class web.DHCINSULOCInfo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// Parameter BUILD = 92;

/// 保存
ClassMethod Save(InString As %String) As %String
{
	
	n (InString)
	s ^CacheTemp("SaveSave")=$lb(InString)
	q:InString="" -100
	s Save=$$Save^DHCINSULOCInfo(InString)
	q Save
}

ClassMethod check(YLZBH As %String) As %String
{
	
	n (YLZBH)
	q $d(^DHCINLOC(0,"YLZBH",YLZBH))
}

/// 删除
ClassMethod Delete(LocRowid As %String) As %String
{
	n (LocRowid,%session)
	q:LocRowid="" -100
	s Save=$$Delete^DHCINSULOCInfo(LocRowid)
	q Save
}

ClassMethod QueryLocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocInfoExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

Query QueryLocInfo(AdmReason As %String, YLZBH As %String, Name As %String, SFZH As %String, FYID As %String, FFXZID As %String, DWDM As %String, HospDr As %String) As %Query(ROWSPEC = "RecordSum:%String,TXXLX:%String,TYLZBH:%String,TYLZZT:%String,TSBCARD:%String,TTXM:%String,TSFZH:%String,TXM:%String,TXB:%String,TCSNY:%String,TFYID:%String,TFFXZID:%String,TRZID:%String,TJBID:%String,TBZNY:%String,TYYDH:%String,TDWDM:%String,TDWXZDM:%String,TDWMC:%String,TDWDZ:%String,TDWDH:%String,TDWYB:%String,TJTZZ:%String,TZZDH:%String,TZZYB:%String,TiDate:%String,TStaDate:%String,TEndDate:%String,TAdmReason:%String,TYearStrDate:%String,TMZQFD:%String,TMZLJ:%String,TZYQFX:%String,TNDLJ:%String,TZYCS:%String,TTZLX:%String,TZCYYDM:%String,TZCKSMC:%String,TZCBQMC:%String,TZCCWBH:%String,TZRYYDH:%String,TZRKSMC:%String,TZRBQMC:%String,TRowid:%String,TXXLXDesc:%String,TAdmReaDesc:%String,TFYIDDesc:%String,TFFXZIDDesc:%String,TRZIDDesc:%String,TJBIDDesc:%String,TDWXZDMDesc:%String,TAdmReasonDr:%String,TTZLXDesc")
{
}

/// D ##class(%ResultSet).RunQuery("web.DHCINSULOCInfo","QueryLocInfo","2","0800","","","","","")
ClassMethod QueryLocInfoExecute(ByRef qHandle As %Binary, AdmReason As %String, YLZBH As %String, Name As %String, SFZH As %String, FYID As %String, FFXZID As %String, DWDM As %String, HospDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	;admreason_dr   保健号    姓名   身份证号  区别      类别    单位代码     
	;w AdmReason_"^"_YLZBH_"^"_Name_"^"_SFZH_"^"_FYID_"^"_FFXZID_"^"_DWDM  ,!
	;s ^cachetemp("d")=AdmReason_"^"_YLZBH_"^"_Name_"^"_SFZH_"^"_FYID_"^"_FFXZID_"^"_DWDM
	s AdmReason=$tr(AdmReason," ")
	s YLZBH=$tr(YLZBH," ")
	s Name=$tr(Name," ")
	s SFZH=$tr(SFZH," ")
	s FYID=$tr(FYID," ")
	s FFXZID=$tr(FFXZID," ")
	s DWDM=$tr(DWDM," ")
	
	s TXXLX="",TYLZBH="",TYLZZT="",TSBCARD="",TTXM="",TSFZH="",TName="",TXB="",TCSNY=""
	s TFYID="",TFFXZID="",TRZID="",TJBID="",TBZNY="",TYYDH="",TDWDM="",TDWXZDM="",TDWMC=""
	s TDWDZ="",TDWDH="",TDWYB="",TJTZZ="",TZZDH="",TZZYB="",TiDate="",TStaDate="",TTZLXDesc=""
	s TEndDate="",TAdmReason="",TYearStrDate=""
	s TMZQFD="",TMZLJ="",TZYQFX="",TNDLJ="",TZYCS="",TTZLX="",TZCYYDM="",TZCKSMC="",TZCBQMC=""
	s TZCCWBH="",TZRYYDH="",TZRKSMC="",TZRBQMC="",TRowid="",TXXLXDesc=""
	s TFYIDDesc="",TFFXZIDDesc="",TRZIDDesc="",TJBIDDesc="" ,TDWXZDMDesc="" ;20160323 DingSH 
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("DHC_INSULOCInfo",HospDr) 
	f  s TAdmReason=$o(^DHCINLOC("0","AdmReason",TAdmReason))  q:TAdmReason=""  d
	.q:((AdmReason'="")&&(AdmReason'=TAdmReason))	;费别过滤
	.s LocInfoDr=""
	.f  s LocInfoDr=$o(^DHCINLOC("0","AdmReason",TAdmReason,LocInfoDr)) q:LocInfoDr=""  d
	..;+2019-7-30 tangzf 医院授权判断 start
	..s TmpHospital=$p($g(^DHCINLOC(LocInfoDr)),"^",49)
	..q:GroupHospDr'=TmpHospital
	..//s CheckHosipitalSession=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("DHC_INSULocInfo",LocInfoDr,"",TmpHospital)
	..//q:CheckHosipitalSession'="Y" ; 该院区无权查看该数据
	..;+2019-7-30 tangzf 医院授权判断 end
	..s TXXLX="",TYLZBH="",TYLZZT="",TSBCARD="",TTXM="",TSFZH="",TName="",TXB="",TCSNY=""
	..s TFYID="",TFFXZID="",TRZID="",TJBID="",TBZNY="",TYYDH="",TDWDM="",TDWXZDM="",TDWMC=""
	..s TDWDZ="",TDWDH="",TDWYB="",TJTZZ="",TZZDH="",TZZYB="",TiDate="",TStaDate=""
	..s TEndDate="",TYearStrDate=""
	..s TMZQFD="",TMZLJ="",TZYQFX="",TNDLJ="",TZYCS="",TTZLX="",TZCYYDM="",TZCKSMC="",TZCBQMC=""
	..s TZCCWBH="",TZRYYDH="",TZRKSMC="",TZRBQMC="",TRowid=""
	..s TFYIDDesc="",TFFXZIDDesc="",TRZIDDesc="",TJBIDDesc="" ;20160323 DingSH 
	..s TRowid=LocInfoDr
	..s LocInfo=$g(^DHCINLOC(LocInfoDr))
	..s TStaDate=$p(LocInfo,"^",27)
	..s TEndDate=$p(LocInfo,"^",29)				
	..s TXXLX=$p(LocInfo,"^",1)
	..i TXXLX'=""    d
	...s TXXLXStr=$$QueryByCode^DHCINSUDicData("XXLX",TXXLX,HospDr)
	...s TXXLXDesc=$p(TXXLXStr,"^",4)
	..s TYLZBH=$tr($p(LocInfo,"^",2)," ")			
	..q:((YLZBH'="")&&(TYLZBH'=YLZBH))				;医疗证号过滤
	..s TYLZZT=$p(LocInfo,"^",3)
	..;q:((YLZZT'="")&&(YLZZT'=TYLZZT))
	..s:$l(TStaDate)'=5 TStaDate=""
	..s:$l(TEndDate)'=5 TEndDate=""
	..i TStaDate'=""     d
	...;s TStaDate=$zd(TStaDate,4)
	...s TStaDate=##class(websys.Conversions).DateLogicalToHtml(TStaDate)
	..i TEndDate'=""	 d
	...;s TEndDate=$zd(TEndDate,4)
	...s TEndDate=##class(websys.Conversions).DateLogicalToHtml(TEndDate)
	..s TSBCARD=$p(LocInfo,"^",4)
	..s TName=$tr($p(LocInfo,"^",7)," ")				
	..q:((Name'="")&&(TName'[Name))					;姓名过滤
	..s TSFZH=$tr($p(LocInfo,"^",6)," ")
	..q:((SFZH'="")&&(TSFZH'=SFZH))					;身份证号过滤
	..s TTXM=$p(LocInfo,"^",5)
	..s TXB=$p(LocInfo,"^",8)
	..s TCSNY=$p(LocInfo,"^",9)
	..s tmpCSNY=TCSNY
	..;s:$l(TCSNY)=8 tmpCSNY=$zdh(TCSNY,8)
	..;s:$l(TCSNY,"-")=3 tmpCSNY=$zdh(TCSNY,3)
	..;s:$l(TCSNY,"/")=3 tmpCSNY=$zdh(TCSNY,1)
	..//s tmpCSNY=##class(websys.Conversions).DateHtmlToLogical(TCSNY)
	..s TCSNY=##class(websys.Conversions).DateLogicalToHtml(TCSNY)
	..s TFYID=$tr($p(LocInfo,"^",10)," ")			
	..q:((FYID'="")&&(TFYID'=FYID))					;区别过滤
	..s TFFXZID=$tr($p(LocInfo,"^",11), " ")
	..q:((FFXZID'="")&&(TFFXZID'=FFXZID))			;类别过滤
	..s TRZID=$p(LocInfo,"^",12)
	..s TJBID=$p(LocInfo,"^",13)
	..s TBZNY=$p(LocInfo,"^",14)
	..//s tmpTBZNY=##class(websys.Conversions).DateHtmlToLogical(TBZNY)
	..s TBZNY=##class(websys.Conversions).DateLogicalToHtml(TBZNY)
	..s TYYDH=$p(LocInfo,"^",15)
	..s TDWDM=$tr($p(LocInfo,"^",16)," ")				
	..q:((DWDM'="")&&(TDWDM'=DWDM))					;单位代码过滤
	..s TDWXZDM=$p(LocInfo,"^",17)
	..s TDWMC=$p(LocInfo,"^",18)
	..i ((TDWDM'="")&&(TDWMC=""))         d
	...;s TDWMCInfo=$$QueryByCode^DHCINSUDicData("DWDM",TDWDM)
	...;s TDWMC=$p(TDWMCInfo,"^",4)
	..s TDWDZ=$p(LocInfo,"^",19)
	..s TDWDH=$p(LocInfo,"^",20)
	..s TDWYB=$p(LocInfo,"^",21)
	..s TJTZZ=$p(LocInfo,"^",22)
	..s TZZDH=$p(LocInfo,"^",23)
	..s TZZYB=$p(LocInfo,"^",24)
	..s TiDate=$p(LocInfo,"^",25)
	..;s TiDate=$zd(TiDate,4)
	..s TiDate=##class(websys.Conversions).DateLogicalToHtml(TiDate)
	..s TYearStrDate=$p(LocInfo,"^",31)
	..s TMZQFD=$fn(+$p(LocInfo,"^",34),"",2)
	..s TMZLJ=$fn(+$p(LocInfo,"^",35),"",2)
	..s TZYQFX=$fn($p(LocInfo,"^",36),"",2)
	..s TNDLJ=$fn($p(LocInfo,"^",37),"",2)
	..s TZYCS=+$p(LocInfo,"^",38)
	..s TTZLX=$p(LocInfo,"^",39)
	..s TTZLXDesc=$case(TTZLX,"TZLX1":"延期通知","TZLX0":"正常通知",:TTZLX)
	..s TZCYYDM=$p(LocInfo,"^",40)
	..s TZCKSMC=$p(LocInfo,"^",41)
	..s TZCBQMC=$p(LocInfo,"^",42)
	..s TZCCWBH=$p(LocInfo,"^",43)
	..s TZRYYDH=$p(LocInfo,"^",44)
	..s TZRKSMC=$p(LocInfo,"^",45)
	..s TZRBQMC=$p(LocInfo,"^",46)
	..;s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReason,6)
	..s InsuType="",TAdmReaDesc=""
	..s TFYIDDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("FYQB"_InsuType,TFYID,4,HospDr)
	..s TFFXZIDDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("FYLB"_InsuType,TFFXZID,4,HospDr)
	..s TRZIDDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("RZID"_InsuType,TRZID,4,HospDr)
	..s TJBIDDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("JBID"_InsuType,TJBID,4,HospDr)
	..s TDWXZDMDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DWXZDM"_InsuType,TDWXZDM,4,HospDr)
	..s:$d(^PAC("ADMREA",+TAdmReason)) TAdmReaDesc=$p(^PAC("ADMREA",+TAdmReason),"^",2)  ;add hwq 2011 09 16
	..d BuildDiv
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildDiv 
	set Data=$lb(0,TXXLX,TYLZBH,TYLZZT,TSBCARD,TTXM,TSFZH,TName,TXB,TCSNY,TFYID,TFFXZID,TRZID,TJBID,TBZNY,TYYDH,TDWDM,TDWXZDM,TDWMC,TDWDZ,TDWDH,TDWYB,TJTZZ,TZZDH,TZZYB,TiDate,TStaDate,TEndDate,TAdmReason,TYearStrDate,TMZQFD,TMZLJ,TZYQFX,TNDLJ,TZYCS,TTZLX,TZCYYDM,TZCKSMC,TZCBQMC,TZCCWBH,TZRYYDH,TZRKSMC,TZRBQMC,TRowid,TXXLXDesc,TAdmReaDesc, TFYIDDesc,TFFXZIDDesc,TRZIDDesc,TJBIDDesc,TDWXZDMDesc,TAdmReason,TTZLXDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryLocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocInfoExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		s RecordSum=$o(^CacheTemp(repid,""),-1)     //新增ㄛ获取总记录数   2010 08 26
		s $List(^CacheTemp(repid,ind),1)=RecordSum  //新增ㄛ替换每条记录的第一列数据  2010 08 26
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryLoc1InfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLoc1InfoExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

Query QueryLoc1Info(AdmReason As %String, Name As %String, YLZBH As %String, SFZH As %String) As %Query(ROWSPEC = "RecordSum:%Integer,TXXLX:%String,TYLZBH:%String,TYLZZT:%String,TSBCARD:%String,TTXM:%String,TSFZH:%String,TName:%String,TXB:%String,TCSNY:%String,TFYID:%String,TFFXZID:%String,TRZID:%String,TJBID:%String,TBZNY:%String,TYYDH:%String,TDWDM:%String,TDWXZDM:%String,TDWMC:%String,TDWDZ:%String,TDWDH:%String,TDWYB:%String,TJTZZ:%String,TZZDH:%String,TZZYB:%String,TiDate:%String,TStaDate:%String,TEndDate:%String,TAdmReaDesc:%String,TYearStrDate:%String,TMZQFD:%String,TMZLJ:%String,TZYQFX:%String,TNDLJ:%String,TZYCS:%String,TTZLX:%String,TZCYYDM:%String,TZCKSMC:%String,TZCBQMC:%String,TZCCWBH:%String,TZRYYDH:%String,TZRKSMC:%String,TZRBQMC:%String,TRowid:%String,TAdmReaDesc:%String")
{
}

ClassMethod QueryLoc1InfoExecute(ByRef qHandle As %Binary, AdmReason As %String, Name As %String, YLZBH As %String, SFZH As %String, HospDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	;-s AdmReason="07"
	

	q:$g(AdmReason)="" $$$OK
	s StaDate="",EndDate="",YLZBH="",YLZZT=""
	s TXXLX="",TYLZBH="",TYLZZT="",TSBCARD="",TTXM="",TSFZH="",TName="",TXB="",TCSNY=""
	s TFYID="",TFFXZID="",TRZID="",TJBID="",TBZNY="",TYYDH="",TDWDM="",TDWXZDM="",TDWMC=""
	s TDWDZ="",TDWDH="",TDWYB="",TJTZZ="",TZZDH="",TZZYB="",TiDate="",TStaDate=""
	s TEndDate="",TAdmReason="",TYearStrDate=""
	s TMZQFD="",TMZLJ="",TZYQFX="",TNDLJ="",TZYCS="",TTZLX="",TZCYYDM="",TZCKSMC="",TZCBQMC=""
	s TZCCWBH="",TZRYYDH="",TZRKSMC="",TZRBQMC="",TRowid=""
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("DHC_INSULOCInfo",HospDr) 
	f  s TAdmReason=$o(^DHCINLOC("0","AdmReason",TAdmReason))  q:TAdmReason=""  d
	.q:((AdmReason'="")&&(TAdmReason'=AdmReason))
	.s LocInfoDr=""
	.f  s LocInfoDr=$o(^DHCINLOC("0","AdmReason",TAdmReason,LocInfoDr)) q:LocInfoDr=""  d
	..s TXXLX="",TYLZBH="",TYLZZT="",TSBCARD="",TTXM="",TSFZH="",TName="",TXB="",TCSNY=""
	..s TFYID="",TFFXZID="",TRZID="",TJBID="",TBZNY="",TYYDH="",TDWDM="",TDWXZDM="",TDWMC=""
	..s TDWDZ="",TDWDH="",TDWYB="",TJTZZ="",TZZDH="",TZZYB="",TiDate="",TStaDate=""
	..s TEndDate="",TYearStrDate=""
	..s TMZQFD="",TMZLJ="",TZYQFX="",TNDLJ="",TZYCS="",TTZLX="",TZCYYDM="",TZCKSMC="",TZCBQMC=""
	..s TZCCWBH="",TZRYYDH="",TZRKSMC="",TZRBQMC="",TRowid=""
	..s TRowid=LocInfoDr
	..s LocInfo=$g(^DHCINLOC(LocInfoDr))
	..s tHospDr=$P(LocInfo,"^",49)
	..q:tHospDr'=GroupHospDr
	..s TStaDate=$p(LocInfo,"^",27)
	..s TEndDate=$p(LocInfo,"^",29)
	..;判断有效开始、截止日期
	..i StaDate'=""          d
	...;s StaDate=$zdh(StaDate,3)
	...s StaDate=##class(websys.Conversions).DateHtmlToLogical(StaDate)
	...q:(TStaDate<StaDate)
	..i EndDate'=""      d
	...;s EndDate=$zdh(EndDate,3)
	...s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	...q:(TEndDate>EndDate)					
	..s TXXLX=$p(LocInfo,"^",1)
	..i TXXLX'=""    d
	...s TXXLXStr=$$QueryByCode^DHCINSUDicData("XXLX",TXXLX,HospDr)
	...s TXXLXDesc=$p(TXXLXStr,"^",4)
	..s TYLZBH=$p(LocInfo,"^",2)
	..q:((YLZBH'="")&&(TYLZBH'=YLZBH))
	..s TYLZZT=$p(LocInfo,"^",3)
	..q:((YLZZT'="")&&(YLZZT'=TYLZZT))
	..i TStaDate'=""     d
	...;s TStaDate=$zd(TStaDate,4)
	...s TStaDate=##class(websys.Conversions).DateLogicalToHtml(TStaDate)
	..i TEndDate'=""	 d
	...;s TEndDate=$zd(TEndDate,4)
	...s TEndDate=##class(websys.Conversions).DateLogicalToHtml(TEndDate)
	..s TSBCARD=$p(LocInfo,"^",4)
	..s TName=$p(LocInfo,"^",7)
	..s TSFZH=$p(LocInfo,"^",6)
	..s TTXM=$p(LocInfo,"^",5)
	..s TXB=$p(LocInfo,"^",8)
	..s TCSNY=$p(LocInfo,"^",9)
	..s tmpCSNY=TCSNY
	..s tmpCSNY=##class(websys.Conversions).DateHtmlToLogical(TCSNY)
	..s TCSNY=##class(websys.Conversions).DateLogicalToHtml(tmpCSNY)
	..s TFYID=$p(LocInfo,"^",10)
	..s TFFXZID=$p(LocInfo,"^",11)
	..s TRZID=$p(LocInfo,"^",12)
	..s TJBID=$p(LocInfo,"^",13)
	..s TBZNY=$p(LocInfo,"^",14)
	..s TYYDH=$p(LocInfo,"^",15)
	..s TDWDM=$p(LocInfo,"^",16)
	..s TDWXZDM=$p(LocInfo,"^",17)
	..s TDWMC=$p(LocInfo,"^",18)
	..i ((TDWDM'="")&&(TDWMC=""))         d
	...s TDWMCInfo=$$QueryByCode^DHCINSUDicData("DWDM",TDWDM,HospDr)
	...s TDWMC=$p(TDWMCInfo,"^",4)
	..s TDWDZ=$p(LocInfo,"^",19)
	..s TDWDH=$p(LocInfo,"^",20)
	..s TDWYB=$p(LocInfo,"^",21)
	..s TJTZZ=$p(LocInfo,"^",22)
	..s TZZDH=$p(LocInfo,"^",23)
	..s TZZYB=$p(LocInfo,"^",24)
	..s TiDate=$p(LocInfo,"^",25)
	..;s TiDate=$zd(TiDate,4)
	..s TiDate=##class(websys.Conversions).DateLogicalToHtml(TiDate)
	..s TYearStrDate=$p(LocInfo,"^",31)
	..s TMZQFD=$p(LocInfo,"^",34)
	..s TMZLJ=$p(LocInfo,"^",35)
	..s TZYQFX=$p(LocInfo,"^",36)
	..s TNDLJ=$p(LocInfo,"^",37)
	..s TZYCS=$p(LocInfo,"^",38)
	..s TTZLX=$p(LocInfo,"^",39)
	..s TZCYYDM=$p(LocInfo,"^",40)
	..s TZCKSMC=$p(LocInfo,"^",41)
	..s TZCBQMC=$p(LocInfo,"^",42)
	..s TZCCWBH=$p(LocInfo,"^",43)
	..s TZRYYDH=$p(LocInfo,"^",44)
	..s TZRKSMC=$p(LocInfo,"^",45)
	..s TAdmReaDesc=$p(^PAC("ADMREA",TAdmReason),"^",2)  ;add hwq 2011 09 16
	..d BuildDi1v
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildDi1v 
	set Data=$lb(0,TXXLX,TYLZBH,TYLZZT,TSBCARD,TTXM,TSFZH,TName,TXB,TCSNY,TFYID,TFFXZID,TRZID,TJBID,TBZNY,TYYDH,TDWDM,TDWXZDM,TDWMC,TDWDZ,TDWDH,TDWYB,TJTZZ,TZZDH,TZZYB,TiDate,TStaDate,TEndDate,TAdmReason,TYearStrDate,TMZQFD,TMZLJ,TZYQFX,TNDLJ,TZYCS,TTZLX,TZCYYDM,TZCKSMC,TZCBQMC,TZCCWBH,TZRYYDH,TZRKSMC,TZRBQMC,TRowid,TAdmReaDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryLoc1InfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLoc1InfoExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
   s RecordSum=$o(^CacheTemp(repid,""),-1)     //新增ㄛ获取总记录数
		    s $List(^CacheTemp(repid,ind),1)=RecordSum  //新增ㄛ替换每条记录的第一列数据
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryLocByYLZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocByYLZExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryLocByYLZExecute(ByRef qHandle As %Binary, YLZBH As %String, AdmType As %String) As %Status
{
	;Q-0452
	;d ##CLASS(%ResultSet).RunQuery("web.DHCINSULOCInfo","QueryLocByYLZ","Q-0452","OP")

	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	i AdmType="IP" d
	.s tmpType="MZ"
	e  d
	.s tmpType="ZY"
	s tmpSSRowid=0
	f  s tmpSSRowid=$o(^CT("SS",tmpSSRowid)) q:tmpSSRowid=""     d
	.s CTSSInfo=$g(^CT("SS",tmpSSRowid))
	.s SSCode=$p(CTSSInfo,"^",1)
	.q:(SSCode[tmpType)
	.s SSRowid=tmpSSRowid
	.s SSDesc=$p(CTSSInfo,"^",2)
	.s SBCARD="",TXM="",SFZH="",XM="",XB="",CSNY="",FYID="",FYXZ="",FFXZID="",FFXZ="",RZID="",JBID="",DWDM="",DWMC="",DWDZ="",DWDH="",DWYB="",JTZZ="",ZZDH="",ZZYB=""
	.i YLZBH=""    d
	..d BuildYLZ
	.e             d
	..s INLOCDr=""
	..f  s INLOCDr=$o(^DHCINLOC("0","YLZBH",YLZBH,INLOCDr)) q:INLOCDr=""  d
	...s INLOCInfo=$g(^DHCINLOC(INLOCDr))
	...s LocType=$p(INLOCInfo,"^",32)
	...s INDIDDr=""
	...f  s INDIDDr=$o(^DHCINDID("0","IType","LocInfoCon",INDIDDr))  q:INDIDDr=""  d
	....s INDIDInfo=$g(^DHCINDID(INDIDDr))
	....s DimDemo=$p(INDIDInfo,"^",6)
	....s InsuCode=$p(INDIDInfo,"^",4)
	....s HisCode=$p(INDIDInfo,"^",2)
	....s XXLX=$p(INLOCInfo,"^",1)
	....q:XXLX=4			;排除信息类型
	....q:(DimDemo[tmpType)
	....q:(LocType'=InsuCode)
	....q:SSRowid'=HisCode
	....s SBCARD=$p(INLOCInfo,"^",4)
	....s TXM=$p(INLOCInfo,"^",5)
	....s SFZH=$p(INLOCInfo,"^",6)
	....s XM=$p(INLOCInfo,"^",7)
	....s XB=$p(INLOCInfo,"^",8)
	....s CSNY=$p(INLOCInfo,"^",9)
	....s FYID=$p(INLOCInfo,"^",10)
	....i (FYID'="")         d
	.....s FYIDInfo=$$QueryByCode^DHCINSUDicData("FYID",FYID)
	.....s FYXZ=$p(FYIDInfo,"^",4)
	....s FFXZID=$p(INLOCInfo,"^",11)
	....i (FFXZID'="")         d
	.....s FFXZIDInfo=$$QueryByCode^DHCINSUDicData("FFXZID",FFXZID)
	.....s FYXZ=$p(FFXZIDInfo,"^",4)
	....s RZID=+$p(INLOCInfo,"^",12)				;职退情况，干保名单中的职退情况(001,002...)与医保读卡返回值(1，2...)不一致不一致，做相应处理
	....s JBID=$p(INLOCInfo,"^",13)
	....s DWDM=$p(INLOCInfo,"^",16)
	....s DWMC=$p(INLOCInfo,"^",18)
	....s DWDZ=$p(INLOCInfo,"^",19)
	....s DWDH=$p(INLOCInfo,"^",20)
	....s DWYB=$p(INLOCInfo,"^",21)
	....s JTZZ=$p(INLOCInfo,"^",22)
	....s ZZDH=$p(INLOCInfo,"^",23)
	....s ZZYB=$p(INLOCInfo,"^",24)
	....d BuildYLZ
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildYLZ 
	set Data=$lb(SSRowid,SSCode,SSDesc,SBCARD,TXM,SFZH,XM,XB,CSNY,FYID,FYXZ,FFXZID,FFXZ,RZID,JBID,DWDM,DWMC,DWDZ,DWDH,DWYB,JTZZ,ZZDH,ZZYB)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryLocByYLZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocByYLZExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

/// w ##class(%ResultSet).RunQuery("web.DHCINSULOCInfo","QueryLocByYLZ","0024249","OP")
/// 通过"凭证号码"返回对应患者的信息
/// 出参:社会地位rowid,社会地位code,社会地位Desc,社保卡号,条形码,身份证号,姓名,性别,出生年月,费用性质code,费用性质,付费性质id,付费性质,职退情况,级别代码,单位代码,单位名称,单位地址,单位代号,单位邮编,家庭住址,住址电话,住址邮编)
/// 43:MZ-103:其他市管干部(在职):                P02597180:   :310109194901014017:李文善:1:19490101:009:干保统筹:004::001:009:03001238:上海市浦东新区人民法院:上海市浦东新区丁香路⒌号:68542391:200135:浦东新区洋泾街道灵山路701弄28号1203室:58213116:200135:
Query QueryLocByYLZ(YLZBH, AdmType) As %Query(ROWSPEC = "SSRowid:%String,SSCode:%String,SSDesc:%String,SBCARD:%String,TXM:%String,SFZH:%String,XM:%String,XB:%String,CSNY:%String,FYID:%String,FYXZ:%String,FFXZID:%String,FFXZ:%String,RZID:%String,JBID:%String,DWDM:%String,DWMC:%String,DWDZ:%String,DWDH:%String,DWYB:%String,JTZZ:%String,ZZDH:%String,ZZYB:%String")
{
}

/// *根据身份证号查找患者信息
/// 入参：CardNo	dhc_insulocinfo表的INLOC_SFZH
///      ReaId  类别
/// 出参：INLOCInfo
/// 编写者：yangjianzhang
/// 编写日期:2010-03-08
/// 修改日期:2020-12-22 DingSH
/// 修改日期:2021-02-19 DingSH 增加院区指针
/// w ##class(web.DHCINSULOCInfo).GetLocInfoBySSID("111111111111111111","1",2)
ClassMethod GetLocInfoBySSID(SFZH As %String, AdmReason As %String, HospDr As %String = "") As %String
{
	n (SFZH,AdmReason,HospDr)
	s OutStr="-1"
	q:(SFZH="") OutStr
	s LocInfoDr=""
	s tmpID=""
	f  s LocInfoDr=$o(^DHCINLOC("0","SSID",SFZH,LocInfoDr)) q:LocInfoDr=""   d
	.s XXLX=$p($g(^DHCINLOC(LocInfoDr)),"^",1)
	.q:(XXLX=4)
	.s TmpAdmReason=$p($g(^DHCINLOC(LocInfoDr)),"^",32)
	.q:((AdmReason'="")&&(TmpAdmReason'=AdmReason))
	.s TmpHospDr=$p($g(^DHCINLOC(LocInfoDr)),"^",49) //+ DingSH 20210219
	.q:((HospDr'="")&&(TmpHospDr'=HospDr))           //+ DingSH 20210219
	.s tmpID=LocInfoDr
	q:(+tmpID=0) OutStr
	s OutStr=$$GetInfoById^DHCINSULOCInfo(tmpID)
	q OutStr
}

/// *根据保健号查找患者信息
/// 入参：CardNo	dhc_insulocinfo表的INLOC_YLZBH
///      ReaId  类别
/// 出参：INLOCInfo
/// 编写者：yangjianzhang
/// 编写日期:2010-03-08
/// 修改日期:2021-02-19 DingSH 增加院区指针
/// w ##class(web.DHCINSULOCInfo).GetLocInfoByCardNo()
/// w ##class(web.DHCINSULOCInfo).GetLocInfoByYLZBH("1","1")
ClassMethod GetLocInfoByYLZBH(YLZ As %String, AdmReason As %String, HospDr As %String = "") As %String
{
	n (YLZ,AdmReason,HospDr)
	s OutStr="-1"
	q:(YLZ="") OutStr
	s LocInfoDr=""
	s tmpID=""
	f  s LocInfoDr=$o(^DHCINLOC("0","YLZBH",YLZ,LocInfoDr)) q:LocInfoDr=""   d
	.s XXLX=$p($g(^DHCINLOC(LocInfoDr)),"^",1)
	.q:(XXLX=4)
	.s TmpAdmReason=$p($g(^DHCINLOC(LocInfoDr)),"^",32)
	.q:((AdmReason'="")&&(TmpAdmReason'=AdmReason))
	.s TmpHospDr=$p($g(^DHCINLOC(LocInfoDr)),"^",49) //+ DingSH 20210219
	.q:((HospDr'="")&&(TmpHospDr'=HospDr))           //+ DingSH 20210219
	.s tmpID=LocInfoDr
	q:(+tmpID=0) OutStr
	s OutStr=$$GetInfoById^DHCINSULOCInfo(tmpID)
	q OutStr
}

/// *根据医保卡号查找患者信息
/// 入参：CardNo	dhc_insulocinfo表的INLOC_SBCARD
///      ReaId  类别
/// 出参：INLOCInfo
/// 编写者：yangjianzhang
/// 编写日期:2010-03-08
/// w ##class(web.DHCINSULOCInfo).GetLocInfoByCardNo("1222",1,2)
ClassMethod GetLocInfoByCardNo(CardNo As %String, ReaId As %String, HospDr As %String = "") As %String
{
	n (CardNo,ReaId,HospDr)
	s OutStr="-1"
	q:CardNo="" OutStr
	//s INDIDInfo=$$QueryByCode^DHCINSUDicData("LocPacCon",ReaId)
	//s tmpAdmReason=$p(INDIDInfo,"^",6)
	s INLOCDr=""
	f  s INLOCDr=$o(^DHCINLOC("0","SBCARD",CardNo,INLOCDr)) q:INLOCDr=""  d
	.s INLOCInfo=$g(^DHCINLOC(INLOCDr))
	.s AdmReason=$p(INLOCInfo,"^",32)
	.q:(ReaId'=AdmReason)
	.s TmpHospDr=$p($g(^DHCINLOC(INLOCDr)),"^",49) //+ DingSH 20210219
	.q:((HospDr'="")&&(TmpHospDr'=HospDr))           //+ DingSH 20210219
	.s XXLX=$p(INLOCInfo,"^",1)
	.q:(XXLX="4")
	.s OutStr=INLOCDr_"^"_INLOCInfo
	q OutStr
}

ClassMethod GetLocID(YLZBH As %String, ReaId As %String) As %String
{
	n (YLZBH,ReaId)
	s tmpRowid="",Rowid=""
	s INDIDInfo=$$QueryByCode^DHCINSUDicData("LocPacCon",ReaId)
	s Admreason=$p(INDIDInfo,"^",6)
	q:(Admreason="") Rowid
	f  s tmpRowid=$o(^DHCINLOC("0","YLZBH",YLZ,tmpRowid))  q:tmpRowid=""  d
	.s InlocInfo=$g(^DHCINLOC(tmpRowid))
	.s tmpAdmreason=$p(InlocInfo,"^",32)
	.s XXLX=$p(InlocInfo,"^",1)
	.q:XXLX=4				;排除注销信息
	.q:(tmpAdmreason'=Admreason)
	.s Rowid=tmpRowid
	q Rowid
}

/// *根据个人编号和患者费别查找该患者的年度累计
/// 入参：YLZBH	dhc_insulocinfo表的YLZBH
///      ReaId   Pac_Admreason 的RowID
/// 出参：Rowid^跨年标志!门诊累计^住院累计^住院次数
/// 编写者：yangjianzhang
/// 编写日期:2010-03-04
ClassMethod GetYearAcc(YLZBH As %String, ReaId As %String) As %String
{
	n (YLZBH,ReaId)
	s OutStr="-1"
	s Rowid=##class(web.DHCINSULOCInfo).GetLocID(YLZBH,ReaId)
	q:(+Rowid=0) OutStr
	s InlocInfo=$g(^DHCINLOC(Rowid))
	s YearStaDate=+$p(InlocInfo,"^",31)
	s MZLJ=0,ZYLJ=0,ZYCS=0
	s tmpMZLJ=+$p(InlocInfo,"^",35)	;门诊累计
	s tmpZYLJ=+$p(InlocInfo,"^",37)	;住院累计
	s tmpZYCS=+$p(InlocInfo,"^",38)	;住院次数
	s today=+$e($zd(+$h,8),5,8)
	s Year=+$e($zd(+$h,8),1,4)
	s knFlag=0
	i today'<LastOpDate			d
	.s YearStaDate=$zdh((Year-1)_YearStaDate,8)
	e  s YearStaDate=$zdh((Year)_YearStaDate,8)
	s LastOpDate=$p(InlocInfo,"^",47)
	i LastOpDate=""			d
	.s LastOpDate=+$h
	s LsatIpDate=$p(InlocInfo,"^",48)
	i LsatIpDate=""			d
	.s LsatIpDate=+$h
	i LastOpDate'<YearStaDate            d
	.s knFlag=1
	.s MZLJ=tmpMZLJ
	i LsatIpDate'<YearStaDate			 d
	.s knFlag=1
	.s ZYLJ=tmpZYLJ
	.s ZYCS=tmpZYCS
	q Rowid_"^"_knFlag_"!"_MZLJ_"^"_ZYLJ_"^"_ZYCS
}

ClassMethod QueryLocByYLZIPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocByYLZIPExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryLocByYLZIPExecute(ByRef qHandle As %Binary, YLZBH As %String, AdmType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	q:(YLZBH)="" $$$OK
	s YLZBH=$ZCVT(YLZBH,"U")
	s tmpSSRowid=0
	f  s tmpSSRowid=$o(^CT("SS",tmpSSRowid)) q:tmpSSRowid=""     d
	.s CTSSInfo=$g(^CT("SS",tmpSSRowid))
	.s SSCode=$p(CTSSInfo,"^",1)
	.s SSRowid=tmpSSRowid
	.s SSDesc=$p(CTSSInfo,"^",2)
	.s SBCARD="",TXM="",SFZH="",XM="",XB="",CSNY="",FYID="",FYXZ="",FFXZID="",FFXZ="",RZID="",JBID="",DWDM="",DWMC="",DWDZ="",DWDH="",DWYB="",JTZZ="",ZZDH="",ZZYB="",PAPMINO=""
	.i YLZBH'=""    d
	..s INLOCDr=""
	..f  s INLOCDr=$o(^DHCINLOC("0","YLZBH",YLZBH,INLOCDr)) q:INLOCDr=""  d
	...s INLOCInfo=$g(^DHCINLOC(INLOCDr))
	...s LocType=$p(INLOCInfo,"^",32)
	...s INDIDDr=""
	...f  s INDIDDr=$o(^DHCINDID("0","IType","LocInfoCon",INDIDDr))  q:INDIDDr=""  d
	....s INDIDInfo=$g(^DHCINDID(INDIDDr))
	....s DimDemo=$p(INDIDInfo,"^",6)
	....s InsuCode=$p(INDIDInfo,"^",4)
	....s HisCode=$p(INDIDInfo,"^",2)
	....s XXLX=$p(INLOCInfo,"^",1)
	....q:XXLX=4			;排除信息类型
	....;q:(DimDemo[tmpType)
	....q:('$d(^DHCJFPACADM(0,"Social",SSRowid)))
	....q:(LocType'=InsuCode)
	....q:SSRowid'=HisCode
	....s SBCARD=$p(INLOCInfo,"^",4)
	....s TXM=$p(INLOCInfo,"^",5)
	....s SFZH=$p(INLOCInfo,"^",6)
	....s XM=$p(INLOCInfo,"^",7)
	....s XB=$p(INLOCInfo,"^",8)
	....s CSNY=$p(INLOCInfo,"^",9)
	....s FYID=$p(INLOCInfo,"^",10)
	....i (FYID'="")         d
	.....s FYIDInfo=$$QueryByCode^DHCINSUDicData("FYID",FYID)
	.....s FYXZ=$p(FYIDInfo,"^",4)
	....s FFXZID=$p(INLOCInfo,"^",11)
	....i (FFXZID'="")         d
	.....s FFXZIDInfo=$$QueryByCode^DHCINSUDicData("FFXZID",FFXZID)
	.....s FYXZ=$p(FFXZIDInfo,"^",4)
	....s RZID=+$p(INLOCInfo,"^",12)				;职退情况，干保名单中的职退情况(001,002...)与医保读卡返回值(1，2...)不一致不一致，做相应处理
	....s JBID=$p(INLOCInfo,"^",13)
	....s DWDM=$p(INLOCInfo,"^",16)
	....s DWMC=$p(INLOCInfo,"^",18)
	....s DWDZ=$p(INLOCInfo,"^",19)
	....s DWDH=$p(INLOCInfo,"^",20)
	....s DWYB=$p(INLOCInfo,"^",21)
	....s JTZZ=$p(INLOCInfo,"^",22)
	....s ZZDH=$p(INLOCInfo,"^",23)
	....s ZZYB=$p(INLOCInfo,"^",24)
	....s PAPMINO=$g(^TMPDHCIPBill("DHCIPBill","AdmPZH",YLZBH,SSRowid))
	....d BuildYLZIP
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildYLZIP 
	set Data=$lb(SSRowid,SSCode,SSDesc,SBCARD,TXM,SFZH,XM,XB,CSNY,FYID,FYXZ,FFXZID,FFXZ,RZID,JBID,DWDM,DWMC,DWDZ,DWDH,DWYB,JTZZ,ZZDH,ZZYB,YLZBH,PAPMINO)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryLocByYLZIPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocByYLZIPExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

/// w ##class(%ResultSet).RunQuery("web.DHCINSULOCInfo","QueryLocByYLZIP","0024249","OP")
/// 通过"凭证号码"返回对应患者的信息
/// 出参:社会地位rowid,社会地位code,社会地位Desc,社保卡号,条形码,身份证号,姓名,性别,出生年月,费用性质code,费用性质,付费性质id,付费性质,职退情况,级别代码,单位代码,单位名称,单位地址,单位代号,单位邮编,家庭住址,住址电话,住址邮编)
/// 43:MZ-103:其他市管干部(在职):                P02597180:   :310109194901014017:李文善:1:19490101:009:干保统筹:004::001:009:03001238:上海市浦东新区人民法院:上海市浦东新区丁香路⒌号:68542391:200135:浦东新区洋泾街道灵山路701弄28号1203室:58213116:200135:
Query QueryLocByYLZIP(YLZBH As %String, AdmType As %String) As %Query(ROWSPEC = "SSRowid:%String,SSCode:%String,SSDesc:%String,社保卡号:%String,条形码:%String,身份证号:%String,姓名:%String,性别:%String,出生年月:%String,费用性质Code:%String,费用性质:%String,付费性质Code:%String,付费性质:%String,职退情况:%String,级别代码:%String,DWDM:%String,单位代码:%String,单位地址:%String,单位电话:%String,单位邮编:%String,家庭住址:%String,住址电话:%String,住址邮编:%String,医疗证码:%String,登记号:%String")
{
}

/// 更新病人年度累计金额  hwq 2011 07 19
/// w ##class(web.DHCINSULOCInfo).UpdateNDLJ("300160046","1.1")
ClassMethod UpdateNDLJ(InsuNo, NDLJStr) As %String
{
	n (InsuNo,NDLJStr)
	s Out="-1"
	q:NDLJStr="" -100
	q:$d(^DHCINLOC("0","YLZBH",InsuNo))=0 -3
	s InLocRowid=""
	s InLocRowid=$o(^DHCINLOC("0","YLZBH",InsuNo,InLocRowid))
	s Update=$$UpdateNDLJ^DHCINSULOCInfo(InLocRowid,NDLJStr)
	i Update>0 s Out="0"
	e  s Out="-1"
	q Out
}

/// 获取病人年度累计金额和限额  hwq 2011 09 17   modefy by zhangdongliang at 2011-11-10
/// w ##class(web.DHCINSULOCInfo).GetLimitByInsuNo("111000")
ClassMethod GetLimitByInsuNo(InsuNo) As %String
{
	n (InsuNo)
	s Out="-1"
	s LocInfoDr=""
	f  s LocInfoDr=$o(^DHCINLOC("0","YLZBH",InsuNo,LocInfoDr)) q:LocInfoDr=""   d
	.;s XXLX=$p($g(^DHCINLOC(LocInfoDr)),"^",1)
	.;q:(XXLX=4)  ;已注销
	.s LocInfo=$g(^DHCINLOC(LocInfoDr))
	.s Limit=+$p(LocInfo,"^",34)
	.s OPTotFund=+$p(LocInfo,"^",35)  ;门诊年度累计
	.s Out=Limit_"^"_OPTotFund
	q Out
}

/// Creator: tangzf
/// CreatDate: 2019-09-11
/// Description: 保存本地名单维护信息
/// Input: Input : xml串
///        RowId : 新增时为空，修改时不为空
/// Output: 
/// Return: 0=“成功”  ；非0 失败
/// Debug: w ##class(web.DHCINSULOCInfo).SaveLocalInfo(^Temp("LOC"),^Temp("LOCRowId"))
ClassMethod SaveLocalInfo(Input, RowId)
{
	set HospDr="2"
	s:$g(%session)'="" HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital")) // tangzf 2019-8-2
	;s Input="<root> <INLOCXM>测试啊</INLOCXM><INLOCXXLX></INLOCXXLX> <INLOCYLZBH>123123</INLOCYLZBH>  <INLOCYLZZT></INLOCYLZZT>  <INLOCSBCARD>123123</INLOCSBCARD>  <INLOCTXM></INLOCTXM>  <INLOCSFZH>622126199412131419</INLOCSFZH>  <INLOCXB>男</INLOCXB>  <INLOCCSNY></INLO CCS NY>  <INLOCBZNY> </INLOCBZNY>  <INLOCYYDH></INLOCYYDH>  <INLOCDWDM></INLOCDWDM>  <INLOCDWMC></INLOCDWMC>  <INLOCDWDZ></INLOCDWDZ>  <INLOCDWDH></INLOCDWDH>  <INLOCDWYB>111111</INLOCDWYB>  <INLOCJTZZ></INLOCJTZZ><INLOCZZDH></INLOCZZDH><INLOCZZYB></INLOCZZYB>  <INLOCiDate></INLOCiDate><INLOCStaDate>18/12/2020</INLOCStaDate><INLOCEndDate></INLOCEndDate><INLOCYearStrDate></INLOCYearStrDate>  <INLOCMZQFD></INLOCMZQFD><INLOCMZLJ></INLOCMZLJ><INLOCZYQFX></INLOCZYQFX><INLOCNDLJ></INLOCNDLJ><INLOCZYCS></INLOCZYCS><INLOCTZLX>TZLX0</INLOCTZLX>  <INLOCZCYYDM></INLOCZCYYDM>  <INLOCZCKSMC></INLOCZCKSMC>  <INLOCZCBQMC></INLOCZCBQMC>  <INLOCZCCWBH></INLOCZCCWBH>  <INLOCZRYYDH></INLOCZRYYDH>  <INLOCZRKSMC></INLOCZRKSMC>  <INLOCZRBQMC></INLOCZRBQMC>  <INLOCDWXZDM>31</INLOCDWXZDM>  <INLOCAdmReasonDr>1</INLOCAdmReasonDr><INLOCFYID>01</INLOCFYID><INLOCFFXZID>01</INLOCFFXZID><INLOCRZID>11</INLOCRZID><INLOCJBID>M6</INLOCJBID></root>"
	s ^Temp("LOC")=Input
	s ^Temp("LOCRowId")=RowId
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("DHC_INSULOCInfo",HospDr) 
	set InputStr=$tr(Input," ","")
	set ^CacheTemp("DHCINSUSaveLocalInfo")=$lb(Input,RowId)
	if +RowId=0 d
	.set tmpObj=##class(User.DHCINSULocInfo).%New()
	.set tmpObj=##class(web.INSUCacheXML).Deserialize(tmpObj,"root",InputStr)
	else  d
	.set tmpObj=..UpdateLocalInfo(Input, RowId)
	if tmpObj.INLOCXM=""{
		Quit "-101^解析xml串失败"
	}
	//1 验证身份证号 + DingSH 20201222
	s SFZH=tmpObj.INLOCSFZH
    s AdmReasonId = tmpObj.INLOCAdmReasonDr
	s rtn=..GetLocInfoBySSID(SFZH,AdmReasonId,HospDr)
    
	q:(rtn'=-1)&&(RowId'=+rtn) "-101^已经存在身份证号为"_SFZH_"记录"
		
		
	//2 验证保健号 + DingSH 20201222
	s YZLH=tmpObj.INLOCYLZBH
	s rtn=..GetLocInfoByYLZBH(YZLH,AdmReasonId)
	q:(rtn'=-1)&&(RowId'=+rtn) "-101^已经存在保健号为"_YZLH_"记录"
	
	//3 验证医保卡号 + DingSH 20201222
	s CardNo=tmpObj.INLOCSBCARD
	s rtn=..GetLocInfoByCardNo(CardNo,AdmReasonId)
    q:(rtn'=-1)&&(RowId'=+rtn) "-101^已经存在医保卡号为"_CardNo_"记录"
    
    s INLOCCSNY=tmpObj.INLOCCSNY  //出生日期 + DingSH 20201222
    
    q:(+INLOCCSNY'=0)&&'($match(INLOCCSNY,"\d{4}-\d{2}-\d{2}|\d{2}/\d{2}/\d{4}")) "-101^出生日期非法"_INLOCCSNY
    s:+INLOCCSNY'=0 tmpObj.INLOCCSNY=##class(websys.Conversions).DateHtmlToLogical(INLOCCSNY)
    
    s INLOCBZNY=tmpObj.INLOCBZNY  //办证日期 + DingSH 20201222
    q:(+INLOCBZNY'=0)&&'($match(INLOCBZNY,"\d{4}-\d{2}-\d{2}|\d{2}/\d{2}/\d{4}")) "-101^办证日期非法"_INLOCBZNY
	s:+INLOCBZNY'=0 tmpObj.INLOCBZNY =##class(websys.Conversions).DateHtmlToLogical(INLOCBZNY)
	set tmpObj.INLOCiDate=+$h
	set tmpObj.INLOCHospDr=GroupHospDr
	set err=tmpObj.%Save()
	
    if $$$ISERR(err){
		Quit "-100^"_$SYSTEM.Status.GetErrorText(err)
	}else{
		Quit "0"
	}
}

/// Creator: tangzf
/// CreatDate: 2020-02-09
/// Description: 通过xml串更新对象
/// Input: Input : xml串
///        RowId : 
/// Output: 
/// Return: LocInfoObj =User.DHCINSULocInfo  对象
/// Debug: w ##class(web.DHCINSULOCInfo).UpdateLocalInfo("111000")
ClassMethod UpdateLocalInfo(Input, RowId)
{
	set LocInfoObj=##class(User.DHCINSULocInfo).%OpenId(RowId)
	set UpdateObj=##class(web.INSUCacheXML).Deserialize(LocInfoObj,"root",Input)
	set tempObj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCINSULocInfo")
	quit:('$IsObject(tempObj)) "-1"

	for i=1:1:tempObj.Properties.Count() {
		set property=tempObj.Properties.GetAt(i)
		set name=property.Name
		continue:($e(name,1)="%")||(name="ChildDHCINSULocAccount")
		set $ZOBJPROPERTY(LocInfoObj,name)=$ZOBJPROPERTY(UpdateObj,name)
	}
	set UpdateObj=""
	do tempObj.%Close() 
	quit LocInfoObj
}

/// w ##class(web.DHCINSULOCInfo).TransDate("111000")
ClassMethod TransDate(Paramdate)
{
	q:Paramdate="" ""
	s Paramdate=##class(websys.Conversions).DateHtmlToLogical(Paramdate)
	s Paramdate=$zd(Paramdate,3)
	q Paramdate
}

}
