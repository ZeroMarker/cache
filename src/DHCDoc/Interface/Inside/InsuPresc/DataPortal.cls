/// Author：李旭  
/// CreatDate：2021-12-16
/// Description：国家医保数据接口(目前缺少药房组关于统一采购药品等信息的接口，见：GetDrugInfo方法)
/// Input: 就诊ID、数组(取值按照接口文档中字段说明，组内测试方法：Test)
/// Debugger: 实际部署时，由于存在HIS版本差异，需注意一下公共取值方法的数据取值是否正确
/// Note：标版有医生站接口注册，医保组可调用标准医生站接口方法。其他版本可直接调用Query
Class DHCDoc.Interface.Inside.InsuPresc.DataPortal Extends %RegisteredObject
{

/******************************* 国家医保处方数据采集 Start ******************************************/
/// 内部测试接口
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.DataPortal).Test()
ClassMethod Test()
{
	s Params=##class(%ArrayOfDataTypes).%New()
	;住院医嘱记录
	d Params.SetAt(1935,"mdtrt_sn")
	d Params.SetAt(1935,"mdtrt_id")
	d Params.SetAt("Test001","psn_no")
	d Params.SetAt("东华医为","medins_orgcode")
	
	;住院处方信息
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.DataPortal","IPOrderInfo",1932,Params)
	;门诊挂号信息
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.DataPortal","RegInfo","1936",Params)
	;门诊诊断信息
	d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.DataPortal","OPDiagInfo","1936",Params)
	;门诊处方信息
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.DataPortal","OPPresc","1933")
	
	;因为医保组走配置，需要直接调用Query,故下面的医生站接口注册方法不使用
	Q ""
	
	;直接调用医生站接口注册方法
	set result=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.insu.OPDiagInfo",195,Params)
	if $IsObject(result){
		s ColCounts=result.GetColumnCount()
		for len=1:1:ColCounts {
			s Desc=result.GetColumnHeader(len)
			s Code=result.GetColumnName(len)
			w Code_":"_Desc_":"
		}
		w !
		while(result.Next()){
			for len=1:1:ColCounts {
				s Data=result.GetData(len)
				w Data_":"
			}
			w !
		}
	}
	q ""
}

Query IPOrderInfo(AdmID As %String, ByRef Params As %ArrayOfDataTypes) As %Query(ROWSPEC = "mdtrt_sn:%String:就医流水号,mdtrt_id:%String:就诊ID,psn_no:%String:人员编号,ipt_bed_no:%String:住院床号,drord_no:%String:医嘱号,isu_dept_code:%String:下达科室代码,drord_isu_time:%String:医嘱下达时间,exe_dept_code:%String:执行科室代码,exe_dept_name:%String:执行科室名称,drord_chker_name:%String:医嘱审核人姓名,drord_ptr_name:%String:医嘱执行人姓名,drord_grp_no:%String:医嘱组号,drord_type:%String:医嘱类别,drord_item_type_code:%String:医嘱项目分类代码,drord_item_type_name:%String:医嘱项目分类名称,drord_detl_code:%String:医嘱明细代码,drord_detl_name:%String:医嘱明细名称,medn_type_code:%String:药物类型代码,medn_type_name:%String:药物类型名称,drug_dosform:%String:药品剂型,drug_dosform_name:%String:药品剂型名称,drug_spec:%String:药品规格,dismed_cnt:%String:发药数量,dismed_cnt_unt:%String:发药数量单位,medn_use_frqu:%String:药物使用-频率,medn_used_dosunt:%String:药物使用-剂量单位,drug_used_sdose:%String:药物使用-次剂量,drug_used_idose:%String:药物使用-总剂量,drug_used_way_code:%String:药物使用-途径代码,drug_used_way:%String:药物使用-途径,medc_days:%String:用药天数,medc_begntime:%String:用药开始时间,medc_endtime:%String:用药停止时间,skintst_dicm:%String:皮试判别,tcmherb_foote:%String:草药脚注,drord_endtime:%String:医嘱结束时间,ipt_dept_code:%String:住院科室代码,medins_orgcode:%String:医疗机构组织机构代码,unif_purc_drug_flag:%String:统一采购药品标志,drug_mgt_plaf_code:%String:药品管理平台代码,drug_purc_code:%String:药品采购代码,bas_medn_flag:%String:基本药物标志,vali_flag:%String:有效标志,medcas_drord_detl_id:%String:病案医嘱明细id") [ SqlProc ]
{
}

/// 住院医嘱记录(4402)
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.DataPortal","IPOrderInfo","195")
ClassMethod IPOrderInfoExecute(ByRef qHandle As %Binary, AdmID As %String, ByRef Params As %ArrayOfDataTypes) As %Status
{
	s mdtrtsn=Params.GetAt("mdtrt_sn")
    s mdtrtid=Params.GetAt("mdtrt_id")
    s psnno=Params.GetAt("psn_no")
    s medinsorgcode=Params.GetAt("medins_orgcode")
    
    s ^templx("IPOrderInfo")=$lb(AdmID)
    s ind=1
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s OrdID=$o(^OEORD(0,"Adm",AdmID,""))
    q:OrdID="" $$$OK
    
    s (iptbedno,iptdeptcode)=""
    s AdmInfo=$g(^PAADM(AdmID))
    s PatID=$p(AdmInfo,"^",1)
    s AdmLocID=$p(AdmInfo,"^",4)
	i AdmLocID'="" d
	.s iptdeptcode=$p($g(^CTLOC(AdmLocID)),"^",1)
	.s HospID=$p($g(^CTLOC(AdmLocID)),"^",22)
	s BedID=$p(AdmInfo,"^",73)
	i BedID'="" d
	.s iptbedno=$p(^PAWARD(+BedID,"BED",$p(BedID,"||",2)),"^",1)
     
    s SubID=0
    f {
	    s SubID=$o(^OEORD(OrdID,"I",SubID))
	    q:SubID=""
	    do ReSetOrderInfo
	   	s OrdInfo1=$g(^OEORD(OrdID,"I",SubID,1))
	   	s ArcimID=$p(OrdInfo1,"^",2)
	   	continue:(OrdInfo1="")||(ArcimID="")
	   	s ItemStat=$p(OrdInfo1,"^",13)
	   	s:ItemStat'="" ItemStat=$p($g(^OEC("OSTAT",ItemStat)),"^",1)
	   	continue:(ItemStat="")||(ItemStat="U")			;作废的不传
		
		s OrdInfo2=$g(^OEORD(OrdID,"I",SubID,2))
		s OrdInfo3=$g(^OEORD(OrdID,"I",SubID,3))
		s OrdInfo5=$g(^OEORD(OrdID,"I",SubID,5))
		s OrdInfo11=$g(^OEORD(OrdID,"I",SubID,11))
		s drordno=OrdID_"||"_SubID
		
		s OrdDeptID=$p(OrdInfo1,"^",3)
		i OrdDeptID'="" d
		.s isudeptcode=$p($g(^CTLOC(OrdDeptID)),"^",1)
		s InsertDate=$p(OrdInfo1,"^",19)				;插入医嘱
		s InsertTime=$p(OrdInfo1,"^",20)
		s drordisutime=$zd(InsertDate,3)_" "_$zt(InsertTime)
		s RecDepID=$p(OrdInfo3,"^",6)
		i RecDepID'="" d
		.s exedeptcode=$p($g(^CTLOC(RecDepID)),"^",1)
		.s exedeptname=$p($g(^CTLOC(RecDepID)),"^",2)
		s OrdDocID=$p(OrdInfo1,"^",11)
		i OrdDocID'="" d
		.s drordchkername=$p($g(^CTPCP(OrdDocID,1)),"^",2)
		
		s LinkOrderID=$p(OrdInfo11,"^",39)
		s:LinkOrderID'="" LinkOrderID=$p(LinkOrderID,"||",2)
		s drordgrpno=$s(LinkOrderID'="":LinkOrderID,1:SubID)
		s PriorityID=$p(OrdInfo1,"^",8)				;医嘱类型
		s drordtype=$p(^OECPR(PriorityID),"^",1)
		
		s ItemCatID=$p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",10)
		s drorditemtypecode=$p($g(^ARC("IC",ItemCatID)),"^",1)			;医嘱项目分类代码
		s drorditemtypename=$p($g(^ARC("IC",ItemCatID)),"^",2)			;医嘱项目分类名称
		s drorddetlcode=$p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",1)
		s drorddetlname=$p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",2)
		
		s DrugData=..GetDrugInfo(ArcimID)
		s medntypecode=$lg(DrugData,6)		;药物类型代码
		s medntypename=$lg(DrugData,7)		;药物类型名称
		s drugdosform=$lg(DrugData,1)
		s drugdosformname=$lg(DrugData,2)
		s drugspec=$lg(DrugData,3)
		s DispInfo=..GetOrdDispInfo(OrdID_"||"_SubID)
		s dismedcnt=$lg(DispInfo,1)			;发药数量
		s dismedcntunt=$lg(DispInfo,2)		;发药数量单位
		
		s PHFreqID=$p(OrdInfo2,"^",4)
		i PHFreqID'="" d
		.s mednusefrqu=$p(^PHCFR(PHFreqID),"^",4)
		s UnitID=$p(OrdInfo2,"^",3)
		i UnitID'="" d
		.s mednuseddosunt=$p(^CT("UOM",UnitID),"^",2)
		s drugusedsdose=$p(OrdInfo2,"^",1)
		s OrderFreqTimeDoseStr=$p($g(^OEORD(OrdID,"I",SubID,"DHC")),"^",59)
		i OrderFreqTimeDoseStr'=""{
			s drugusedsdose=$p(##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdDoseQty(OrdID_"||"_SubID),"-",1)
		}

		;执行记录执行人
		s OrdExecInfo=..GetOrdExecInfo(OrdID_"||"_SubID)
		s drordptrname=$lg(OrdExecInfo,3)
		s drugusedidose=$lg(OrdExecInfo,4)				;药物使用-总剂量
		
		s InstrID=$p(OrdInfo2,"^",7)
		i InstrID'="" d
		.s drugusedwaycode=$p(^PHCIN(InstrID),"^",1)
		.s drugusedway=$p(^PHCIN(InstrID),"^",2)
		s DuratID=$p(OrdInfo2,"^",6)
		i DuratID'="" d
		.s medcdays=$p(^PHCDU(DuratID),"^",2)
		
		s SttDate=$p(OrdInfo1,"^",9)					;医嘱开始时间
		s SttTime=$p(OrdInfo1,"^",10)
		s medcbegntime=$zd(SttDate,3)_" "_$zt(SttTime)
		s XTime=+$p(OrdInfo2,"^",15)			;停止时间
		s XDate=$p(OrdInfo3,"^",34)			
		i XDate'="" d
		.s medcendtime=$zd(XDate,3)_" "_$zt(XTime)
		.s drordendtime=medcendtime
		.s medcdays=$SYSTEM.SQL.DATEDIFF("dd", SttDate, XDate)	
		s skintstdicm=$p(OrdInfo5,"^",2)
		s tcmherbfoote=$p(OrdInfo2,"^",8)	;草药备注
		;统一采购药品标志信息
		s unifpurcdrugflag=$lg(DrugData,8)
		s drugpurccode=$lg(DrugData,9)
		s drugmgtplafcode=$lg(DrugData,10)
		s basmednflag=$lg(DrugData,4)
		s valiflag=1
		s IsLong=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityID) 
		i (IsLong=0)&&(ItemStat="C") s valiflag=0
		s medcasdrorddetlid=drordno
		d IPOrderInfoOut
    }
    q $$$OK

ReSetOrderInfo
	s (drordno,isudeptcode,drordisutime,exedeptcode,exedeptname,drordchkername,drordptrname,drordgrpno,drordtype,drorditemtypecode,drorditemtypename,drorddetlcode,drorddetlname,medntypecode,medntypename,drugdosform,drugdosformname,drugspec,dismedcnt,dismedcntunt,mednusefrqu,mednuseddosunt,drugusedsdose,drugusedidose,drugusedwaycode,drugusedway,medcdays,medcbegntime,medcendtime,skintstdicm,tcmherbfoote,drordendtime,unifpurcdrugflag,drugmgtplafcode,drugpurccode,basmednflag,valiflag,medcasdrorddetlid)=""
	q ""
       
IPOrderInfoOut    	
	s Data=$lb(mdtrtsn,mdtrtid,psnno,iptbedno,drordno,isudeptcode,drordisutime,exedeptcode,exedeptname,drordchkername,drordptrname,drordgrpno,drordtype,drorditemtypecode,drorditemtypename,drorddetlcode,drorddetlname,medntypecode,medntypename,drugdosform,drugdosformname,drugspec,dismedcnt,dismedcntunt,mednusefrqu,mednuseddosunt,drugusedsdose,drugusedidose,drugusedwaycode,drugusedway,medcdays,medcbegntime,medcendtime,skintstdicm,tcmherbfoote,drordendtime,iptdeptcode,medinsorgcode,unifpurcdrugflag,drugmgtplafcode,drugpurccode,basmednflag,valiflag,medcasdrorddetlid)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q ""
}

ClassMethod IPOrderInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IPOrderInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod IPOrderInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IPOrderInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {                
		Set AtEnd=1
		Set Row=""
	}Else {         
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query RegInfo(AdmID As %String, ByRef Params As %ArrayOfDataTypes) As %Query(ROWSPEC = "mdtrt_sn:%String:就医流水号,mdtrt_id:%String:就诊ID,psn_no:%String:人员编号,rgst_type_code:%String:挂号类别代码,rgst_way_code:%String:挂号方式代码,rgst_serv_fee:%String:挂号费/医事服务费,ordr_way_code:%String:预约途径代码,retnr_flag:%String:退号标志,fstdiag_flag:%String:初诊标志,mdtrt_flag:%String:就诊标志,rgst_retnr_time:%String:挂号/退号时间,medfee_paymtd_code:%String:医疗费用支付方式代码,vali_flag:%String:有效标志") [ SqlProc ]
{
}

/// 门急诊诊疗记录--挂号信息(4301)
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.DataPortal","RegInfo","497")
ClassMethod RegInfoExecute(ByRef qHandle As %Binary, AdmID As %String, ByRef Params As %ArrayOfDataTypes) As %Status
{
	s (mdtrtsn,mdtrtid,psnno,rgsttypecode,rgstwaycode,rgstservfee,ordrwaycode,retnrflag,fstdiagflag,mdtrtflag,rgstretnrtime,medfeepaymtdcode,valiflag)=""
	s mdtrtsn=Params.GetAt("mdtrt_sn")
    s mdtrtid=Params.GetAt("mdtrt_id")
    s psnno=Params.GetAt("psn_no")
    s medfeepaymtdcode=Params.GetAt("medfee_paymtd_code")
    
    s ^templx("RegInfo")=$lb(AdmID)
    s ind=1
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    
    s rgstwaycode=9
    s RegID=$o(^User.DHCRegistrationFeeI("ADM",AdmID,""))
	i RegID="" s RegID=$o(^User.DHCRegistrationFeeI("ADM",AdmID,""))
	i RegID'="" d
	.s rgstwaycode=1
	.s rgstservfee=$lg(^User.DHCRegistrationFeeD(RegID),4)  		;挂号费
	.s RBASDr=$lg(^User.DHCRegistrationFeeD(RegID),18)				;排班ID
	.s AppSub=$o(^RBAS("ADM",AdmID,+RBASDr,$p(RBASDr,"||",2),0))
	.i AppSub'="" d
	..s rgstwaycode=2
	..s AppMethodID=$p($g(^RBAS(+RBASDr,$p(RBASDr,"||",2),"APPT",AppSub)),"^",12)
	..s ordrwaycode=$p($g(^RBC("APTM",AppMethodID)),"^",1)
	
    s AdmInfo=$g(^PAADM(AdmID))
    s PatID=$p(AdmInfo,"^",1)
    s AdmType=$p(AdmInfo,"^",2)
    s AdmLocID=$p(AdmInfo,"^",4)
    i AdmLocID'="" d
    .s rgsttypecode=$p($g(^CTLOC(AdmLocID)),"^",1)
   
    s VisitStatus=$p(AdmInfo,"^",20)
    s retnrflag=$case(VisitStatus,"C":0,:1)
    s fstdiagflag=1
	s mdtrtflag=$case(VisitStatus,"C":0,:1)
	s AdmDate=$p(AdmInfo,"^",6)
	s AdmTime=$p(AdmInfo,"^",7)
	s rgstretnrtime=$zd(AdmDate,3)_" "_$zt(AdmTime)
	s medfeepaymtdcode=99
	s valiflag=$case(VisitStatus,"C":0,:1)
    
    d RegInfoOut
    q $$$OK
    
RegInfoOut    	
	s Data=$lb(mdtrtsn,mdtrtid,psnno,rgsttypecode,rgstwaycode,rgstservfee,ordrwaycode,retnrflag,fstdiagflag,mdtrtflag,rgstretnrtime,medfeepaymtdcode,valiflag)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod RegInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RegInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod RegInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RegInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {                
		Set AtEnd=1
		Set Row=""
	}Else {         
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query OPDiagInfo(AdmID As %String, ByRef Params As %ArrayOfDataTypes) As %Query(ROWSPEC = "tcm_diag_flag:%String:中医诊断标志,maindiag_flag:%String:主诊断标志,diag_code:%String:诊断代码,diag_name:%String:诊断名称,tcm_dise_code:%String:中医病名代码,tcm_dise_name:%String:中医病名名称,tcmsymp_code:%String:中医证候代码,tcmsymp:%String:中医证候,vali_flag:%String:有效标志") [ SqlProc ]
{
}

/// 门急诊诊疗记录--诊断信息(4301)
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.DataPortal","OPDiagInfo","497")
ClassMethod OPDiagInfoExecute(ByRef qHandle As %Binary, AdmID As %String, ByRef Params As %ArrayOfDataTypes) As %Status
{
    s ^templx("OPDiagInfo")=$lb(AdmID)
    s ind=1
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    
    s MRAdm=$p(^PAADM(AdmID),"^",61)
    q:MRAdm="" $$$OK
    
    s Sub=0
    f {
		s Sub=$o(^MR(MRAdm,"DIA",Sub))
		q:Sub=""
		do ReSetOPDiagInfo
		s OneInfo=$g(^MR(MRAdm,"DIA",Sub))	
		s ICDCodeID=$p(OneInfo,"^",1)
		continue:ICDCodeID=""   ;由项目决定是否需要非ICD诊断(默认不传)
		i ICDCodeID'="" d
		.s diagcode=$p($g(^MRC("ID",ICDCodeID)),"^",1)
		.s diagname=$p($g(^MRC("ID",ICDCodeID)),"^",2)
		.s BillFlag1=$p($g(^MRC("ID",ICDCodeID)),"^",13)
		.s BillFlag3=$p($g(^MRC("ID",ICDCodeID)),"^",15)
		.i (BillFlag1="Y")||(BillFlag3="Y") s tcmdiagflag=1
		.i BillFlag1="Y" d
		..s tcmsympcode=diagcode
		..s tcmsymp=diagname
		.e  i BillFlag3="Y" d
		..s tcmdisecode=diagcode
		..s tcmdisename=diagname
		e  d
		.s NoteID=$g(^MR(MRAdm,"DIA",Sub,"DES",0))					;诊断备注(非ICD诊断)
		.i NoteID'="" d
		..s diagname=$g(^MR(MRAdm,"DIA",Sub,"DES",NoteID))
		s maindiagflag=$p($g(^MR(MRAdm,"DIA",Sub,1)),"^",20)		;主诊断
		s valiflag=1
		d OPDiagInfoOut
	}
    q $$$OK
   
ReSetOPDiagInfo
	s (tcmdiagflag,maindiagflag,diagcode,diagname,tcmdisecode,tcmdisename,tcmsympcode,tcmsymp,valiflag)=""
    q ""
    
OPDiagInfoOut    	
	s Data=$lb(tcmdiagflag,maindiagflag,diagcode,diagname,tcmdisecode,tcmdisename,tcmsympcode,tcmsymp,valiflag)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod OPDiagInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPDiagInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OPDiagInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPDiagInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {                
		Set AtEnd=1
		Set Row=""
	}Else {         
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query OPPresc(AdmID As %String, ByRef Params As %ArrayOfDataTypes) As %Query(ROWSPEC = "rxno:%String:处方号,rx_prsc_time:%String:处方开方时间,rx_type_code:%String:处方类别代码,rx_item_type_code:%String:处方项目分类代码,rx_item_type_name:%String:处方项目分类名称,rx_detl_id:%String:处方明细代码,rx_detl_name:%String:处方明细名称,tcmdrug_type_name:%String:中药类别名称,tcmdrug_type_code:%String:中药类别代码,tcmherb_foote:%String:草药脚注,medn_type_code:%String:药物类型代码,medn_type_name:%String:药物类型,drug_dosform:%String:药品剂型,drug_dosform_name:%String:药品剂型名称,drug_spec:%String:药品规格,drug_used_frqu:%String:药物使用-频率,drug_used-idose:%String:药物使用-总剂量,drug_used_sdose:%String:药物使用-次剂量,drug_used_dosunt:%String:药物使用-剂量单位,drug_used_way_code:%String:药物使用-途径代码,drug_medc_way:%String:药物使用-途径,skintst_dicm:%String:皮试判别,medc_begntime:%String:用药开始时间,medc_endtime:%String:用药停止日期时间,medc_days:%String:用药天数,main_medc_flag:%String:主要用药标志,urgt_flag:%String:加急标志,unif_purc_drug:%String:统一采购药品,drug_purc_code:%String:药品采购代码,drug_mgt_plaf_code:%String:药品管理平台代码,bas_medn_flag:%String:基本药物标志,vali_flag:%String:有效标志") [ SqlProc ]
{
}

/// 门急诊诊疗记录--处方信息(4301)
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.DataPortal","OPPresc","195")
ClassMethod OPPrescExecute(ByRef qHandle As %Binary, AdmID As %String, ByRef Params As %ArrayOfDataTypes) As %Status
{
    s ^templx("OPPresc")=$lb(AdmID)
    s ind=1
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    
    s OrdID=$o(^OEORD(0,"Adm",AdmID,""))
    q:OrdID="" $$$OK
    s AdmDepID=$p($g(^PAADM(AdmID)),"^",4)
	s HospID=$p($g(^CTLOC(AdmDepID)),"^",22)
    
 	s SubID=0
    f {
	    s SubID=$o(^OEORD(OrdID,"I",SubID))
	    q:SubID=""
	    do ReSetOPPresc
	   	s OrdInfo1=$g(^OEORD(OrdID,"I",SubID,1))
	   	s ArcimID=$p(OrdInfo1,"^",2)
    	s PrescNo=$p(OrdInfo1,"^",14)
    	s ItemStat=$p(OrdInfo1,"^",13)
	   	continue:(OrdInfo1="")||(ItemStat="")||(PrescNo="")
	   	s ItemStat=$p($g(^OEC("OSTAT",ItemStat)),"^",1)
		
		s OrdInfo2=$g(^OEORD(OrdID,"I",SubID,2))
		s OrdInfo3=$g(^OEORD(OrdID,"I",SubID,3))
    	s OrdInfo5=$g(^OEORD(OrdID,"I",SubID,5))
    	
    	s rxno=PrescNo
		s InsertDate=$p(OrdInfo1,"^",19)				;插入医嘱
		s InsertTime=$p(OrdInfo1,"^",20)
		s rxprsctime=$zd(InsertDate,3)_" "_$zt(InsertTime)
		s PrescType=..GetPrescTypeInfo(OrdID_"||"_SubID)
		s rxtypecode=$p(PrescType,"^",1)
		s ItemCatID=$p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",10)
		s rxitemtypecode=$p($g(^ARC("IC",ItemCatID)),"^",1)			;处方项目分类代码
		s rxitemtypename=$p($g(^ARC("IC",ItemCatID)),"^",2)			;处方项目分类名称
		s rxdetlid=$p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",1)
		s rxdetlname=$p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",2)
		s tcmdrugtypename=$p(PrescType,"^",3)	;中药类别名称
		s tcmdrugtypecode=$p(PrescType,"^",4)	;中药类别代码
		s tcmherbfoote=$p(OrdInfo2,"^",8)		;草药备注

		s DrugData=..GetDrugInfo(ArcimID)
		s medntypecode=$lg(DrugData,6)		;药物类型代码
		s medntypename=$lg(DrugData,7)		;药物类型名称
		s drugdosform=$lg(DrugData,1)
		s drugdosformname=$lg(DrugData,2)
		s drugspec=$lg(DrugData,3)
		
		s PHFreqID=$p(OrdInfo2,"^",4)
		i PHFreqID'="" d
		.s drugusedfrqu=$p(^PHCFR(PHFreqID),"^",4)
		s drugusedsdose=$p(OrdInfo2,"^",1)
		s OrderFreqTimeDoseStr=$p($g(^OEORD(OrdID,"I",SubID,"DHC")),"^",59)
		i OrderFreqTimeDoseStr'=""{
			s drugusedsdose=$p(##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdDoseQty(OrdID_"||"_SubID),"-",1)
		}
		s UnitID=$p(OrdInfo2,"^",3)
		i UnitID'="" d
		.s druguseddosunt=$p(^CT("UOM",UnitID),"^",2)
		;执行记录执行人
		s OrdExecInfo=..GetOrdExecInfo(OrdID_"||"_SubID)
		s drugusedidose=$lg(OrdExecInfo,4)				;药物使用-总剂量

		s InstrID=$p(OrdInfo2,"^",7)
		i InstrID'="" d
		.s drugusedwaycode=$p(^PHCIN(InstrID),"^",1)
		.s drugmedcway=$p(^PHCIN(InstrID),"^",2)
		s skintstdicm=$p(OrdInfo5,"^",2)
		s SttDate=$p(OrdInfo1,"^",9)					;医嘱开始时间
		s SttTime=$p(OrdInfo1,"^",10)
		s medcbegntime=$zd(SttDate,3)_" "_$zt(SttTime)
		s DuratID=$p(OrdInfo2,"^",6)
		i DuratID'="" d
		.s medcdays=$p(^PHCDU(DuratID),"^",2)
		s XTime=+$p(OrdInfo2,"^",15)			;停止时间
		s XDate=$p(OrdInfo3,"^",34)			
		i XDate'="" d
		.s medcendtime=$zd(XDate,3)_" "_$zt(XTime)
		.s medcdays=$SYSTEM.SQL.DATEDIFF("dd", SttDate, XDate)	
		s urgtflag=$p($g(^OEORD(OrdID,"I",SubID,11)),"^",55)
		s DrugData=..GetDrugInfo(ArcimID)
		s unifpurcdrug=$lg(DrugData,8)
		s drugpurccode=$lg(DrugData,9)
		s drugmgtplafcode=$lg(DrugData,10)
		s basmednflag=$lg(DrugData,4)
		s valiflag=$case(ItemStat,"V":1,:0)
		d OPPrescOut
    }
    q $$$OK
  
ReSetOPPresc
    s (rxno,rxprsctime,rxtypecode,rxitemtypecode,rxitemtypename,rxdetlid,rxdetlname,tcmdrugtypename,tcmdrugtypecode,tcmherbfoote,medntypecode,medntypename,drugdosform,drugdosformname,drugspec,drugusedfrqu,drugusedidose,drugusedsdose,druguseddosunt,drugusedwaycode,drugmedcway,skintstdicm,medcbegntime,medcendtime,medcdays,mainmedcflag,urgtflag,unifpurcdrug,drugpurccode,drugmgtplafcode,basmednflag,valiflag)=""
    q ""
OPPrescOut    	
	s Data=$lb(rxno,rxprsctime,rxtypecode,rxitemtypecode,rxitemtypename,rxdetlid,rxdetlname,tcmdrugtypename,tcmdrugtypecode,tcmherbfoote,medntypecode,medntypename,drugdosform,drugdosformname,drugspec,drugusedfrqu,drugusedidose,drugusedsdose,druguseddosunt,drugusedwaycode,drugmedcway,skintstdicm,medcbegntime,medcendtime,medcdays,mainmedcflag,urgtflag,unifpurcdrug,drugpurccode,drugmgtplafcode,basmednflag,valiflag)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod OPPrescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPPrescExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OPPrescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPPrescExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {                
		Set AtEnd=1
		Set Row=""
	}Else {         
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/******************************* 双通道电子处方上传(河南)  返回数组(医保组在用) Start ******************************************/
/// 校验审核后的医嘱数据，判断对应的处方号是否需要上传
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.DataPortal).CheckDualElectPresc(195,"5043||1*15281962||1*V*^",2)
ClassMethod CheckDualElectPresc(AdmID, OrderStr, HospID, UserID) As %String
{
	s ^templx("CheckDualElectPresc")=$lb(AdmID,OrderStr,HospID,UserID)
	i HospID="" {
		s AdmLocID=$p(^PAADM(AdmID),"^",4)
		s HospID=$p(^CTLOC(AdmLocID),"^",22)
	}
	k PrescList
	f len=1:1:$l(OrderStr,"^"){
		s OrderID=$p($p(OrderStr,"^",len),"*",2)
		continue:OrderID=""
		s PrescNo=$p($g(^OEORD(+OrderID,"I",$p(OrderID,"||",2),1)),"^",14)
		continue:PrescNo=""
		;可加入不需上传的规则
		s ContinueFlag=0
		continue:ContinueFlag=1
		
		i $d(PrescList(PrescNo))=0 s PrescList(PrescNo)=OrderID
		e  s PrescList(PrescNo)=PrescList(PrescNo)_"^"_OrderID
	}
	s RtnStr=""	
	s Params="" 	;其它扩展参数
	s PrescOrdList=""
	i $d(PrescList){
		s PrescNo=""
		f  {
			s PrescNo=$o(PrescList(PrescNo))
			q:PrescNo=""
			;调用医保组接口进行数据上传
			s Ret=##class(INSU.OFFBIZ.BL.BIZ00A).InsuSettlementULForDZCF("00A",9211,HospID,UserID,0,AdmID,PrescNo,Params)
			s RetObj=##class(DHCDoc.Util.FromXML).Json2Arr(Ret)
			s psnno=RetObj."psn_no"				;人员编号
			s epcid=RetObj."epc_id"				;处方id
			s expContent=RetObj."expContent"	;扩展字段
			i (psnno'="")&&(epcid'=""){
				s rtn=..SaveDualElectPrescInfo(PrescNo,psnno,epcid,expContent,"")
				i $p(rtn,"^",1)'=0{
					i RtnStr="" s RtnStr="处方号："_PrescNo_"保存失败、"
					e  s RtnStr=RtnStr_"处方号："_PrescNo_"保存失败、"
				}
			}
		}
	}
	q RtnStr
}

/// 保存双通道电子处方信息
/// InPut： PrescNo:HIS处方号, DualPSNNo:双通道人员编号, DualPrescNo:双通道处方号, DualContent:双通道扩展字段
/// 		ExptStr:待扩展(^拼接)
/// OutPut: "-1/0"^"失败描述/表ID": "成功标识"^"描述"
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.DataPortal).SaveDualElectPrescInfo("I211221000009","1","SP211221000009","3")
ClassMethod SaveDualElectPrescInfo(PrescNo, DualPSNNo, DualPrescNo, DualContent, ExptStr = "")
{
	s $zt="SaveDualElectPrescInfoErr"
	s ^templx("SaveDualElectPrescInfo")=$lb(PrescNo,DualPSNNo,DualPrescNo,DualContent,ExptStr)
	
	s Obj=##Class(User.DHCDocPrescBaseExt).%New()
	s Obj.PrescNo=PrescNo
	s Obj.DualPSNNo=DualPSNNo
	s Obj.DualPrescNo=DualPrescNo
	s Obj.DualContent=DualContent
	s Obj.CreateDate=+$h
	s Obj.CreateTime=$p($h,",",2)
	s sc=Obj.%Save()
	if $$$ISERR(sc){
	 	q "-1^"_$g(%msg)
	}
	s RowID=Obj.%Id()
	q "0^"_RowID
	
SaveDualElectPrescInfoErr
	s $t=""
	q "-1^"_$ze
}

/// 【9211】双通道电子处方上传(医嘱审核成功后上传)
/// Input: 就诊号、处方号、医院ID、医保数组
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.DataPortal).DualElectPrescData1(195,"I211221000009","2","")
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.DataPortal).DualElectPrescDataArray(911435,"I210918006320","2","")
/// As %ArrayOfDataTypes
ClassMethod DualElectPrescDataArray(AdmID, PrescNo, HospID, Params) As %ArrayOfDataTypes
{
	s $zt="DualElectPrescData1Err"
	;s Obj=##class(%ArrayOfDataTypes).%New()
	;q:PrescNo="" Obj
	q:(AdmID="")||(PrescNo="") "-1^缺少对应入参"
	
	s (psnno,psncerttype,certno,insutype,orgmedtype,dscgmaindisecodg,dscgmaindisename,disecodg,disename,deptcodg,deptname,endtime,chfpdrname,chfpdrcode,epcsort,epctype,medrcdno,diagdscr,mainconddscr,tcmdrugusedway,tcmdrugcnt,reviewname,adjustname,expContent)=""
	
	;医保组需给出的数据(需要进一步确认取值)
#;    s psnno=Params.GetAt("psn_no")			;人员编号
#;    s insutype=Params.GetAt("insutype")		;险种类型
#;    s usefixmedinscode=Params.GetAt("use_fixmedins_code")		;使用处方定点医药机构编号
#;    s usefixmedinsname=Params.GetAt("use_fixmedins_name")		;使用处方定点医药机构名称
#;	  s orgmedtype=Params.GetAt("org_med_type")					;处方对应医疗类别
	;如果已经医保挂号或者已经医保登记，可以从insu_adminfo表获取对应数据，否则无法获取
	;普通门诊和门诊慢病的时候，医疗类别无法区分
	s INSUAdmInfo=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(AdmID)
	s psnno=$p(INSUAdmInfo,"^",2)
	s insutype=$p(INSUAdmInfo,"^",44)	
	s orgmedtype=$p(INSUAdmInfo,"^",14)
	;s certno=$p(INSUAdmInfo,"^",34)

	;患者信息相关
	s PatID=$p(^PAADM(AdmID),"^",1)
	s AdmType=$p(^PAADM(AdmID),"^",2)
	s MRAdmID=$p(^PAADM(AdmID),"^",61)
	s CredType=$p($g(^PAPER(PatID,"PAT",3)),"^",7)		;证件类型
	i CredType'="" d
	.s psncerttype=$p(^PAC("CARD",CredType),"^",1)
	.s CredTypeDesc=$p(^PAC("CARD",CredType),"^",2)
	s psncerttype="1"
	s certno=$p($g(^PAPER(PatID,"PAT",3)),"^",6)		;证件号
	s medrcdno=$p($g(^PAPER(PatID,"PAT",1)),"^",22)		;住院号
	
	;诊断相关
	s MRSub=0
	for {
		s MRSub=$o(^MR(MRAdmID,"DIA",MRSub)) 
		q:(MRSub="")  
		s ICDCodeID=$p($g(^MR(MRAdmID,"DIA",MRSub)),"^",1)
		q:(ICDCodeID="")	
		s DiagCode=$p($g(^MRC("ID",ICDCodeID)),"^",1)
		s DiagDesc=$p($g(^MRC("ID",ICDCodeID)),"^",2)
		s MainFlag=$p($g(^MR(MRAdmID,"DIA",MRSub,1)),"^",20)
		i MainFlag="Y" d
		.s dscgmaindisecodg=DiagCode
		.s dscgmaindisename=DiagDesc
		i diagdscr="" s diagdscr=DiagDesc
		e  s diagdscr=diagdscr_","_DiagDesc
	}
	
	;处方相关信息
	s OrdID=$o(^OEORD(0,"PrescNo",PrescNo,""))
	s SubID=$o(^OEORD(0,"PrescNo",PrescNo,OrdID,""))
	s OrdInfo1=$g(^OEORD(OrdID,"I",SubID,1))
	s OrdInfo2=$g(^OEORD(OrdID,"I",SubID,2))
	s OrdInfo3=$g(^OEORD(OrdID,"I",SubID,3))
	s OrdInfo7=$g(^OEORD(OrdID,"I",SubID,7))
	s ArcimID=$p(OrdInfo1,"^",2)
	s SttDate=$p(OrdInfo1,"^",9)
	s SttTime=$p(OrdInfo1,"^",10)
	s OrdDocID=$p(OrdInfo1,"^",11)
	i OrdDocID'="" d
	.s chfpdrcode=$p($g(^CTPCP(OrdDocID,1)),"^",1)
	.s chfpdrname=$p($g(^CTPCP(OrdDocID,1)),"^",2)
	.s reviewname=chfpdrname
	s UserDepartmentID=$p(OrdInfo7,"^",2)
	i UserDepartmentID'="" d
	.s deptcodg=$p($g(^CTLOC(UserDepartmentID)),"^",1)
	.s deptname=$p($g(^CTLOC(UserDepartmentID)),"^",2)
	s DuratID=$p(OrdInfo2,"^",6)
	i DuratID'="" d
	.s medcdays=$p(^PHCDU(DuratID),"^",2)
	.s tcmdrugcnt=medcdays
	.s endtime=$zd(SttDate+medcdays,3)_" "_$zt(SttTime)
	s XTime=+$p(OrdInfo2,"^",15)
	s XDate=$p(OrdInfo3,"^",34)			
	i XDate'="" d
	.s endtime=$zd(XDate,3)_" "_$zt(XTime)
	.s medcdays=$SYSTEM.SQL.DATEDIFF("dd", SttDate, XDate)
	
	s disecodg=$p($g(^OEORD(OrdID,"I",SubID,"DHC")),"^",66)			;病种编码
	i disecodg'="" d
	.s DiseID=$o(^DHCINDID("0","ITypeCode","opsp_dise00A",disecodg,""))
	.s:DiseID'="" disename=$p(^DHCINDID(DiseID),"^",3)				;病种名称

	;具体医嘱明细 (组织对应的Json)
	;s Obj=##class(DHCDoc.Util.ArrayData).%New()  ;##class(%ArrayOfDataTypes).%New()	
	s Obj=##class(%ArrayOfDataTypes).%New()
	;s OrdList=##class(DHCDoc.Util.ListData).%New()	;##class(%ListOfDataTypes).%New()
	s OrdList=##class(%ListOfDataTypes).%New()
	s SubID=""
	for {
		s SubID=$o(^OEORD(0,"PrescNo",PrescNo,OrdID,SubID))
		q:SubID=""
		s (regname,prodname,spec,sindosdscr,usedfrqudscr,DoseQty,dosformname,usetime,usefixmedinscode,usefixmedinsname,setlid,expContent)=""

		s OrdInfo1=$g(^OEORD(OrdID,"I",SubID,1))
		s OrdInfo2=$g(^OEORD(OrdID,"I",SubID,2))
		s ArcimID=$p(OrdInfo1,"^",2)
		s DrugInfo=..GetDrugInfoExt(ArcimID)
		s prodname=$lg(DrugInfo,2)
		s spec=$lg(DrugInfo,7)
		s dosformname=$lg(DrugInfo,6)
		s SttDate=$p(OrdInfo1,"^",9)
		s SttTime=$p(OrdInfo1,"^",10)
		s usetime=$zd(SttDate,3)_" "_$zt(SttTime)
		s DoseQty=$p(OrdInfo2,"^",1)
		s DoseUOM=$p(OrdInfo2,"^",3)
		s:DoseUOM'="" sindosdscr=$p($g(^CT("UOM",DoseUOM)),"^",1)
		s PHFreqID=$p(OrdInfo2,"^",4)
		i PHFreqID'="" d
		.s usedfrqudscr=$p(^PHCFR(PHFreqID),"^",4)

		s OrdObj=##class(%ArrayOfDataTypes).%New()
		;s OrdObj=##class(DHCDoc.Util.ArrayData).%New()
		d OrdObj.SetAt(regname,"reg_name")        	;注册名称
		d OrdObj.SetAt(prodname,"prodname")        	;商品名
		d OrdObj.SetAt(spec,"spec")        			;规格
		d OrdObj.SetAt(sindosdscr,"sin_dos_dscr")      ;单次剂量描述
		d OrdObj.SetAt(usedfrqudscr,"used_frqu_dscr")	;使用频次描述
		d OrdObj.SetAt(DoseQty,"cnt")        			;数量
		d OrdObj.SetAt(dosformname,"dosform_name")      ;剂型名称
		d OrdObj.SetAt(usetime,"use_time")        		;处方使用时间
		d OrdObj.SetAt(usefixmedinscode,"use_fixmedins_code")        ;使用处方定点医药机构编号
		d OrdObj.SetAt(usefixmedinsname,"use_fixmedins_name")        ;使用处方定点医药机构名称
		d OrdObj.SetAt(AdmID,"mdtrt_id")        		;购药就诊ID
		d OrdObj.SetAt(setlid,"setl_id")        		;购药结算ID
		d OrdObj.SetAt(expContent,"expContent")        ;扩展字段
		d OrdList.Insert(OrdObj)
		
	}
	;处方扩展信息
	s PAQueID=$o(^PAQUE1(0,"PrescNo",PrescNo,""))
	i PAQueID'="" d
	.s PrescDuratID=$p($g(^PAQUE1(PAQueID,"DHC")),"^",10)
	.s PrescCookModeID=$p($g(^PAQUE1(PAQueID,"DHC")),"^",15)
	.i PrescDuratID'="" d
	..s tcmdrugcnt=$p(^PHCDU(DuratID),"^",2)
	.i PrescCookModeID'="" d
	..s tcmdrugusedway=$P($g(^DHCDocConfig("CookMode",PrescCookModeID)),"^",2)
	
	s epcsort=2			;处方种类: 1-中药方、2-西药方
	s:tcmdrugusedway'="" epcsort=1			
	s epctype=1			;处方类型: 1-普通、2-急诊、3-儿童、4-麻/精一、5-精二
	i AdmType="E" s epctype=2
	s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ArcimID)
	i PoisonRowid'="" {
		s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
		i PoisonCode="J2" s epctype=5
		i (PoisonCode="J1")||(PoisonCode="DM")||(PoisonCode="DX")||(PoisonCode="MZ") s epctype=4
	}
	
	d Obj.SetAt(psnno,"psn_no")					;人员编号
	d Obj.SetAt(psncerttype,"psn_cert_type")      ;人员证件类型
	d Obj.SetAt(certno,"certno")        		;证件号码
	d Obj.SetAt(insutype,"insutype")        	;险种类型
	d Obj.SetAt(orgmedtype,"org_med_type")      ;处方对应医疗类别
	d Obj.SetAt(AdmID,"org_mdtrt_id")        	;处方对应就诊ID
	d Obj.SetAt(dscgmaindisecodg,"dscg_main_dise_codg")        ;主诊断编码
	d Obj.SetAt(dscgmaindisename,"dscg_main_dise_name")        ;主诊断名称
	d Obj.SetAt(disecodg,"dise_codg")        	;病种编码
	d Obj.SetAt(disename,"dise_name")        	;病种名称
	d Obj.SetAt(deptcodg,"dept_codg")        	;科室编码
	d Obj.SetAt(deptname,"dept_name")        	;科室名称
	d Obj.SetAt(endtime,"end_time")				;处方有效截止时间
	d Obj.SetAt(chfpdrname,"chfpdr_name")       ;主诊医师姓名
	d Obj.SetAt(chfpdrcode,"chfpdr_code")       ;主诊医师代码
	d Obj.SetAt(epcsort,"epc_sort")        		;处方种类
	d Obj.SetAt(epctype,"epc_type")        		;处方类型
	d Obj.SetAt(medrcdno,"medrcdno")        	;病历号
	d Obj.SetAt(diagdscr,"diag_dscr")        	;诊断描述
	d Obj.SetAt(mainconddscr,"main_cond_dscr")        	;主要病情描述
	d Obj.SetAt(tcmdrugusedway,"tcmdrug_used_way")      ;中药煎服方式
	d Obj.SetAt(tcmdrugcnt,"tcmdrug_cnt")        ;中药付数
	d Obj.SetAt(reviewname,"review_name")        ;审核人姓名
	d Obj.SetAt(adjustname,"adjust_name")        ;调剂人姓名
	d Obj.SetAt(expContent,"expContent")        ;扩展字段
	d Obj.SetAt(OrdList,"epclist")        		;处方明细
	;q Obj.%ToJSON()
	q Obj
	
	
DualElectPrescData1Err
	s $zt=""
	q "-1^"_$ze
	s Obj=##class(%ArrayOfDataTypes).%New()
	q Obj
}

/// 【9211--处方明细】双通道电子处方上传(医嘱审核成功后上传)
/// Input: 就诊号、处方号、医院ID、医保数组
/// Output: "失败字符串"/%ArrayOfDataTypes
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.DataPortal).DualElectPrescOrdListData(911435,"I210918006320","2","")
ClassMethod DualElectPrescOrdListData(AdmID, PrescNo, HospID, Params) As %ListOfDataTypes
{
	s $zt="DualElectPrescData1Err"
	;s Obj=##class(%ArrayOfDataTypes).%New()
	;q:PrescNo="" Obj
	q:(AdmID="")||(PrescNo="") "-1^缺少对应入参"
	
	s (psnno,psncerttype,certno,insutype,orgmedtype,dscgmaindisecodg,dscgmaindisename,disecodg,disename,deptcodg,deptname,endtime,chfpdrname,chfpdrcode,epcsort,epctype,medrcdno,diagdscr,mainconddscr,tcmdrugusedway,tcmdrugcnt,reviewname,adjustname,expContent)=""
	
	;医保组需给出的数据(需要进一步确认取值)
#;    s psnno=Params.GetAt("psn_no")			;人员编号
#;    s insutype=Params.GetAt("insutype")		;险种类型
#;    s usefixmedinscode=Params.GetAt("use_fixmedins_code")		;使用处方定点医药机构编号
#;    s usefixmedinsname=Params.GetAt("use_fixmedins_name")		;使用处方定点医药机构名称
#;	  s orgmedtype=Params.GetAt("org_med_type")					;处方对应医疗类别
	;普通门诊和门诊慢病的时候，医疗类别无法区分
	s INSUAdmInfo=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(AdmID)
	s psnno=$p(INSUAdmInfo,"^",2)
	s insutype=$p(INSUAdmInfo,"^",44)	
	s orgmedtype=$p(INSUAdmInfo,"^",14)
	;s certno=$p(INSUAdmInfo,"^",34)
	
	;患者信息相关
	s PatID=$p(^PAADM(AdmID),"^",1)
	s AdmType=$p(^PAADM(AdmID),"^",2)
	s MRAdmID=$p(^PAADM(AdmID),"^",61)
	s CredType=$p($g(^PAPER(PatID,"PAT",3)),"^",7)		;证件类型
	i CredType'="" d
	.s psncerttype=$p(^PAC("CARD",CredType),"^",1)
	.s CredTypeDesc=$p(^PAC("CARD",CredType),"^",2)
	s psncerttype="1"
	s certno=$p($g(^PAPER(PatID,"PAT",3)),"^",6)		;证件号
	s medrcdno=$p($g(^PAPER(PatID,"PAT",1)),"^",22)		;住院号
	
	;诊断相关
	s MRSub=0
	for {
		s MRSub=$o(^MR(MRAdmID,"DIA",MRSub)) 
		q:(MRSub="")  
		s ICDCodeID=$p($g(^MR(MRAdmID,"DIA",MRSub)),"^",1)
		q:(ICDCodeID="")	
		s DiagCode=$p($g(^MRC("ID",ICDCodeID)),"^",1)
		s DiagDesc=$p($g(^MRC("ID",ICDCodeID)),"^",2)
		s MainFlag=$p($g(^MR(MRAdmID,"DIA",MRSub,1)),"^",20)
		i MainFlag="Y" d
		.s dscgmaindisecodg=DiagCode
		.s dscgmaindisename=DiagDesc
		i diagdscr="" s diagdscr=DiagDesc
		e  s diagdscr=diagdscr_","_DiagDesc
	}
	
	;处方相关信息
	s OrdID=$o(^OEORD(0,"PrescNo",PrescNo,""))
	s SubID=$o(^OEORD(0,"PrescNo",PrescNo,OrdID,""))
	s OrdInfo1=$g(^OEORD(OrdID,"I",SubID,1))
	s OrdInfo2=$g(^OEORD(OrdID,"I",SubID,2))
	s OrdInfo3=$g(^OEORD(OrdID,"I",SubID,3))
	s OrdInfo7=$g(^OEORD(OrdID,"I",SubID,7))
	s ArcimID=$p(OrdInfo1,"^",2)
	s SttDate=$p(OrdInfo1,"^",9)
	s SttTime=$p(OrdInfo1,"^",10)
	s OrdDocID=$p(OrdInfo1,"^",11)
	i OrdDocID'="" d
	.s chfpdrcode=$p($g(^CTPCP(OrdDocID,1)),"^",1)
	.s chfpdrname=$p($g(^CTPCP(OrdDocID,1)),"^",2)
	.s reviewname=chfpdrname
	s UserDepartmentID=$p(OrdInfo7,"^",2)
	i UserDepartmentID'="" d
	.s deptcodg=$p($g(^CTLOC(UserDepartmentID)),"^",1)
	.s deptname=$p($g(^CTLOC(UserDepartmentID)),"^",2)
	s DuratID=$p(OrdInfo2,"^",6)
	i DuratID'="" d
	.s medcdays=$p(^PHCDU(DuratID),"^",2)
	.s tcmdrugcnt=medcdays
	.s endtime=$zd(SttDate+medcdays,3)_" "_$zt(SttTime)
	s XTime=+$p(OrdInfo2,"^",15)
	s XDate=$p(OrdInfo3,"^",34)			
	i XDate'="" d
	.s endtime=$zd(XDate,3)_" "_$zt(XTime)
	.s medcdays=$SYSTEM.SQL.DATEDIFF("dd", SttDate, XDate)	
	s disecodg=$p($g(^OEORD(OrdID,"I",SubID,"DHC")),"^",66)			;病种编码
	i disecodg'="" d
	.s DiseID=$o(^DHCINDID("0","ITypeCode","opsp_dise00A",disecodg,""))
	.s:DiseID'="" disename=$p(^DHCINDID(DiseID),"^",3)				;病种名称

	;具体医嘱明细 (组织对应的Json)
	;s Obj=##class(DHCDoc.Util.ArrayData).%New()  ;##class(%ArrayOfDataTypes).%New()	
	s Obj=##class(%ArrayOfDataTypes).%New()
	;s OrdList=##class(DHCDoc.Util.ListData).%New()	;##class(%ListOfDataTypes).%New()
	s OrdList=##class(%ListOfDataTypes).%New()
	s SubID=""
	for {
		s SubID=$o(^OEORD(0,"PrescNo",PrescNo,OrdID,SubID))
		q:SubID=""
		s (regname,prodname,spec,sindosdscr,usedfrqudscr,DoseQty,dosformname,usetime,usefixmedinscode,usefixmedinsname,setlid,expContent)=""

		s OrdInfo1=$g(^OEORD(OrdID,"I",SubID,1))
		s OrdInfo2=$g(^OEORD(OrdID,"I",SubID,2))
		s ArcimID=$p(OrdInfo1,"^",2)
		s DrugInfo=..GetDrugInfoExt(ArcimID)
		s prodname=$lg(DrugInfo,2)
		s spec=$lg(DrugInfo,7)
		s dosformname=$lg(DrugInfo,6)
		s SttDate=$p(OrdInfo1,"^",9)
		s SttTime=$p(OrdInfo1,"^",10)
		s usetime=$zd(SttDate,3)_" "_$zt(SttTime)
		s DoseQty=$p(OrdInfo2,"^",1)
		s DoseUOM=$p(OrdInfo2,"^",3)
		s:DoseUOM'="" sindosdscr=$p($g(^CT("UOM",DoseUOM)),"^",1)
		s PHFreqID=$p(OrdInfo2,"^",4)
		i PHFreqID'="" d
		.s usedfrqudscr=$p(^PHCFR(PHFreqID),"^",4)

		s OrdObj=##class(%ArrayOfDataTypes).%New()
		;s OrdObj=##class(DHCDoc.Util.ArrayData).%New()
		
		d OrdObj.SetAt(regname,"reg_name")        	;注册名称
		d OrdObj.SetAt(prodname,"prodname")        	;商品名
		d OrdObj.SetAt(spec,"spec")        			;规格
		d OrdObj.SetAt(sindosdscr,"sin_dos_dscr")      ;单次剂量描述
		d OrdObj.SetAt(usedfrqudscr,"used_frqu_dscr")	;使用频次描述
		d OrdObj.SetAt(DoseQty,"cnt")        			;数量
		d OrdObj.SetAt(dosformname,"dosform_name")      ;剂型名称
		d OrdObj.SetAt(usetime,"use_time")        		;处方使用时间
		d OrdObj.SetAt(usefixmedinscode,"use_fixmedins_code")        ;使用处方定点医药机构编号
		d OrdObj.SetAt(usefixmedinsname,"use_fixmedins_name")        ;使用处方定点医药机构名称
		d OrdObj.SetAt(AdmID,"mdtrt_id")        		;购药就诊ID
		d OrdObj.SetAt(setlid,"setl_id")        		;购药结算ID
		d OrdObj.SetAt(expContent,"expContent")        	;扩展字段
		d OrdList.Insert(OrdObj)
	}

	q OrdList
	
DualElectPrescData1Err
	s $zt=""
	q "-1^"_$ze
	s Obj=##class(%ArrayOfDataTypes).%New()
	q Obj
}

/// 【9212】双通道电子处方查询
/// Input: 就诊号、处方号
/// Output: "失败字符串"/%ArrayOfDataTypes
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.DataPortal).GetDualElectPresDataArray(911435,"I210918006320")
ClassMethod GetDualElectPresDataArray(AdmID, PrescNo, HospID, UserID, Params = "") As %ArrayOfDataTypes
{
	
	s $zt="GetDualElectPrescListErr"
	;s Obj=##class(%ArrayOfDataTypes).%New()
	;q:PrescNo="" Obj
	q:(AdmID="")||(PrescNo="") "-1^缺少对应入参"
	;获取处方号对应的医保处方ID
	s DualID=$o(^User.DHCDocPrescBaseExtI("IdxPrescNo",PrescNo,0))
	
	q:DualID="" "-1^该处方号没有对应的上传记录"
	s DualPSNNo=$lg(^User.DHCDocPrescBaseExtD(DualID),3)	;人员编号
	s DualPrescNo=$lg(^User.DHCDocPrescBaseExtD(DualID),4)	;处方id
	s DualContent=$lg(^User.DHCDocPrescBaseExtD(DualID),5)	;扩展字段

	;s Obj=##class(DHCDoc.Util.ArrayData).%New()
	s Obj=##class(%ArrayOfDataTypes).%New()
	d Obj.SetAt(DualPSNNo,"psn_no")        		
	d Obj.SetAt(DualPrescNo,"epc_id")       
	d Obj.SetAt(DualContent,"expContent")       
	;q Obj.%ToJSON()
	q Obj
	;调用查询接口及返回值解析
	s Ret=##class(INSU.OFFBIZ.BL.BIZ00A).InsuSettlementULForDZCF("00A",9212,HospID,UserID,0,AdmID,PrescNo,Params)
	s RetObj=##class(DHCDoc.Util.FromXML).Json2Arr(Ret)
	s psnno=RetObj."psn_no"				;人员编号
	s epcid=RetObj."epc_id"				;处方id
	s expContent=RetObj."expContent"	;扩展字段

GetDualElectPrescListErr
	s $zt=""
	q "-1^"_$ze
}

/// 【9213】双通道电子处方撤销
/// Input: 就诊号、处方号
/// Output: "失败字符串"/%ArrayOfDataTypes
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.DataPortal).CancelDualElectPresc(195,"I211221000009")
ClassMethod CancelDualElectPrescArray(AdmID, PrescNo, HospID, UserID, Params = "") As %ArrayOfDataTypes
{
	s $zt="CancelDualElectPrescErr"
	;s Obj=##class(%ArrayOfDataTypes).%New()
	;q:PrescNo="" Obj
	q:(AdmID="")||(PrescNo="") "-1^缺少对应入参"
	;获取处方号对应的医保处方ID
	s DualID=$o(^User.DHCDocPrescBaseExtI("IdxPrescNo",PrescNo,0))
	q:DualID="" "-1^该处方号没有对应的上传记录"
	
	s DualPSNNo=$lg(^User.DHCDocPrescBaseExtD(DualID),3)	;人员编号
	s DualPrescNo=$lg(^User.DHCDocPrescBaseExtD(DualID),4)	;处方id
	s DualContent=$lg(^User.DHCDocPrescBaseExtD(DualID),5)	;扩展字段

	;s Obj=##class(DHCDoc.Util.ArrayData).%New()
	s Obj=##class(%ArrayOfDataTypes).%New()
	d Obj.SetAt(DualPSNNo,"psn_no")        		
	d Obj.SetAt(DualPrescNo,"epc_id")       
	d Obj.SetAt(DualContent,"expContent")       
	;q Obj.%ToJSON()
	q Obj
	;调用撤销接口及返回值解析

CancelDualElectPrescErr
	s $zt=""
	q "-1^"_$ze
}

/******************************* 公共取值方法 Start ******************************************/
/// 通过医嘱ID获取处方类别以及中药类别代码
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.DataPortal).GetPrescTypeInfo("178||265")
ClassMethod GetPrescTypeInfo(OrderID)
{
	s Rtn="99^其它"
	s $zt="GetPrescTypeInfo"
	
	q:(+OrderID=0) Rtn
	s ArcimID=$p($g(^OEORD(+OrderID,"I",$p(OrderID,"||",2),1)),"^",2)
	q:(+ArcimID=0) Rtn
	
	s AdmID=$p(^OEORD(+OrderID),"^",1)
	s AdmType=$p(^PAADM(AdmID),"^",2)
	s AdmLocID=$p(^PAADM(AdmID),"^",4)
	s OrdAddLocID=$p($g(^OEORD(+OrderID,"I",$p(OrderID,"||",2),7)),"^",2)
	s:OrdAddLocID'="" AdmLocID=OrdAddLocID
	s HospID=$p($g(^CTLOC(AdmLocID)),"^",22)
	s CMType=""
	
	s ItemCatRowid=$p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",10)
	;西药
	s MedItemCat=##Class(web.DHCDocConfig).GetConfigNode("MedItemCat",HospID)
	i "^"_MedItemCat_"^"[("^"_ItemCatRowid_"^"){
		s:AdmType="O" ItemType=1
		s:AdmType="E" ItemType=3
	}
	;中药饮片(草药录入设置)
	s PrescTypeItemCat=##class(web.DHCDocConfig).GetConfigNodeNew2("CNMedPackItemCat",HospID)
	i "^"_PrescTypeItemCat_"^"[("^"_ItemCatRowid_"^"){
		s ItemType="9"
		s CMType=3
		s:AdmType="O" ItemType=2
		s:AdmType="E" ItemType=4
	}
	;草药		
	s CNMedItemCat=##class(web.DHCDocOrderCommon).GetCNMedItemCatStr(HospID)
	i "^"_CNMedItemCat_"^"[("^"_ItemCatRowid_"^"){
		s ItemType="9"
		s CMType=9
	}
	;中成药
	s CPMedItemCat=##Class(web.DHCDocConfig).GetConfigNode("CPMedItemCat",HospID)
	i "^"_CPMedItemCat_"^"[("^"_ItemCatRowid_"^") {
		s ItemType="10"
		s CMType=2
	}
	;精神类
	s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ArcimID)
	i PoisonRowid'="" {
		s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
		i PoisonCode="J2" s ItemType="8"
		i (PoisonCode="J1")||(PoisonCode="DM")||(PoisonCode="DX")||(PoisonCode="MZ") s ItemType="7"
	}	
	
	s:$g(ItemType)="" ItemType=99
	s ItemDesc=$case(ItemType,"1":"门诊西药","2":"门诊中药饮片","3":"急诊西药","4":"急诊中药饮片","5":"儿科西药","6":"儿科中药饮片","7":"麻、精一","8":"精二","9":"中药饮片","10":"中成药",:"其它")
	s CMTypeDesc=$case(CMType,2:"中成药",3:"中药饮片",9:"其他中药",:"")
	s Rtn=ItemType_"^"_ItemDesc_"^"_CMType_"^"_CMTypeDesc
	q Rtn

GetPrescTypeInfo
	s $zt=""
	q Rtn
}

/// 根据库存项获取本位码
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.DataPortal).GetStanderCode("573")
ClassMethod GetStanderCode(InciId)
{
	q:InciId="" ""
    s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
    q:Info="" ""
    s StanderCode=$p($g(^DHCITMINFO(Info)),"^",44)
    q StanderCode
}

/// 获取药品相关信息
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.DataPortal).GetDrugInfo("597||1")
ClassMethod GetDrugInfo(ArcimID)
{
	s BasicFlag=2 
	s (drugdosform,drugdosformname,drugSpec,BasicDesc,PhaCatCode,PhaCatDesc)=""
	
	;药学项相关
	s DrgFormRowID=$p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",12)
	i DrgFormRowID=-1 s DrgFormRowID=""
	i DrgFormRowID'="" d
	.s DrgID=+DrgFormRowID,DrgSub=$p(DrgFormRowID,"||",2)
	.;药品剂型
	.s PHCFID=$p($g(^PHCD(DrgID,"DF",DrgSub,1)),"^",1)
	.i PHCFID'="" d
	..s drugdosform=$p($g(^PHCF(PHCFID)),"^",1)
	..s drugdosformname=$p($g(^PHCF(PHCFID)),"^",2)
	.;基本药物
	.s BasicDrug=$p($g(^PHCD(DrgID,"DF",DrgSub,"DHC")),"^",31)		;国家基本药物
	.i BasicDrug="Y" s BasicDesc="是(国)"
 	.s Drugbase2=$p($g(^PHCD(DrgID,"DF",DrgSub,"DHC")),"^",32)		;省基本药物
 	.i Drugbase2="Y" s BasicDesc="是(省)"
 	.s PDrugbase1=$p($g(^PHCD(DrgID,"DF",DrgSub,"DHC")),"^",33)		;市基本药物
 	.i PDrugbase1="Y" s BasicDesc="是(市)"
 	.s PDrugbase2=$p($g(^PHCD(DrgID,"DF",DrgSub,"DHC")),"^",34)		;区县基本药物
 	.i PDrugbase2="Y" s BasicDesc="是(区)"
	.i BasicDesc'="" s BasicFlag=1
	
	;库存项相关
	s InciID=$o(^INCI(0,"ARCIM_DR",+ArcimID,""))
	i InciID'="" d
	.;库存附加信息
	.s ItmInfoID=$o(^DHCITMINFO(0,"INCI",InciID,""))		
	.i +ItmInfoID'=0 d
	..s drugSpec=$p($g(^DHCITMINFO(ItmInfoID)),"^",27)
	.;药学分类信息
	.s PhaCatInfo=##class(web.DHCSTINTERFACE).GetPhaCatAllByInci(InciID)
	.s PhaCatID=$p(PhaCatInfo,"^",1)
	.s PhaCatDesc=$p(PhaCatInfo,"^",2)
	.i PhaCatID'="" d
	..s PhaCatCode=$p(^DHCPHCC(PhaCatID),"^",1)
	
	;药房组接口获取
	s DurgPurcFlag=""		;统一采购药品标志
	s DurgPurcCode=""		;药品采购代码
	s DurgPlafCode=""		;药品管理平台代码
 	i InciID'="" d
 	.s DurgPurcFlag=$p($g(^DHCITMINFO(InciID,1)),"^",9)
 	.s DurgPurcCode=$p($g(^DHCITMINFO(InciID)),"^",56)
 	
	;1-10
	;药品剂型Code,药品剂型Desc,药品规格,基本药物标识,基本药物名称,药学分类代码,药学分类描述,统一采购药品标志,药品采购代码,药品管理平台代码
	s Data=$lb(drugdosform,drugdosformname,drugSpec,BasicFlag,BasicDesc,PhaCatCode,PhaCatDesc,DurgPurcFlag,DurgPurcCode,DurgPlafCode)
	q Data
}

/// 获取药品相关信息(药房组提供相应取值)
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.DataPortal).GetDrugInfoExt("597||1")
ClassMethod GetDrugInfoExt(ArcimID)
{
	s (BasicFlag,GoodName,GeneCode,GeneName,StanderCode,FormDesc,Spec,ManfDesc,PhaCatCode,PhaCatDesc)=""
	;库存项相关
	s InciID=$o(^INCI(0,"ARCIM_DR",+ArcimID,""))
	i InciID'="" d
	.s BasicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetCountryBasicFlag(InciID)	;基本药物标志
	.s BasicFlag=$case(BasicFlag,"Y":1,:2)
	.s GoodName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodName(InciID)	;商品名
	.s GeneInfo=##class(web.DHCST.Common.DrugInfoCommon).GetGene(InciID)	;通用名
	.s GeneCode=$p(GeneInfo,"^",1)
	.s GeneName=$p(GeneInfo,"^",2)
	.s StanderCode=..GetStanderCode(InciID)				;本位码
	.s FormInfo=##class(web.DHCST.Common.DrugInfoCommon).GetForm(InciID)		;药品剂型
	.s FormDesc=$p(FormInfo,"^",2)
	.s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",InciID)		;规格
	.s ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetManf(InciID)	;厂商名称
	.s ManfDesc=$p(ManfInfo,"^",3)
	.s PhaCatInfo=##class(web.DHCSTINTERFACE).GetPhaCatAllByInci(InciID)	;药学分类信息
	.s PhaCatID=$p(PhaCatInfo,"^",1)
	.s PhaCatDesc=$p(PhaCatInfo,"^",2)
	.i PhaCatID'="" d
	..s PhaCatCode=$p(^DHCPHCC(PhaCatID),"^",1)
	;1-10
	;基本药物标志,商品名,通用名编码,药品通用名,药品本位码,  	药品剂型,规格,生厂厂家,药物类型代码,药物类型
	s Data=$lb(BasicFlag,GoodName,GeneCode,GeneName,StanderCode,FormDesc,Spec,ManfDesc,PhaCatCode,PhaCatDesc)
	q Data
}

/// 通过医嘱ID获取医嘱执行记录相关数据
/// w $LISTTOSTRING(##class(DHCDoc.Interface.Inside.InsuPresc.DataPortal).GetOrdExecInfo("178||265"),"^")
ClassMethod GetOrdExecInfo(OrderID)
{
	s OrdID=+OrderID
	s SubID=$p(OrderID,"||",2)
	s (ExecCTPID,ExecUserCode,ExecUserDesc,DoseUnit)=""
	s DoseUnitID=$p($g(^OEORD(OrdID,"I",SubID,2)),"^",3)
	i DoseUnitID'="" d
	.s DoseUnit=$p(^CT("UOM",DoseUnitID),"^",2)		;单次剂量单位
	
	s (QtySum,Child)=0
	f {
		s Child=$o(^OEORD(OrdID,"I",SubID,"X",Child))
		q:Child=""
		s ExecInfo=$g(^OEORD(OrdID,"I",SubID,"X",Child))
		s ExecCTPCPID=$p(ExecInfo,"^",15)
		i (ExecCTPID="") s ExecCTPID=ExecCTPCPID		;执行人
		s StatusID=$p(ExecInfo,"^",16)		;执行状态
		i StatusID=1 d
		.s PhQtyOrd=$p(ExecInfo,"^",4)		;执行数量
		.s QtySum=QtySum+PhQtyOrd
	}
	i ExecCTPID'=""{
		s ExecUserCode=$p($g(^CTPCP(ExecCTPID,1)),"^",1)
		s ExecUserDesc=$p($g(^CTPCP(ExecCTPID,1)),"^",2)
	}
	s Ret=$lb(ExecCTPID,ExecUserCode,ExecUserDesc,QtySum,DoseUnit)
	q Ret
}

/// 通过医嘱ID获取打包表相关数据
/// w $LISTTOSTRING(##class(DHCDoc.Interface.Inside.InsuPresc.DataPortal).GetOrdDispInfo("178||265"),"^")
ClassMethod GetOrdDispInfo(OrderID)
{
	s (DspQtyUOM)=""
	s (DspQtySum,DspRowID)=0
	f  {
		s DspRowID=$O(^DHCOEDISQTY(0,"OEORI",OrderID,DspRowID))
		q:DspRowID=""
		
		s DspQty=$p(^DHCOEDISQTY(DspRowID),"^",5)			;发药数量
		s DspQtyUOM=$p(^DHCOEDISQTY(DspRowID),"^",6)		;发药退药数量(基本单位)
		s:DspQtyUOM'="" DspQtyUOM=$p(^CT("UOM",DspQtyUOM),"^",2)
		s DspStatus=$p(^DHCOEDISQTY(DspRowID),"^",7)		;发药状态
		i DspStatus="C" d
		.s DspQtySum=DspQtySum+DspQty						;发药总数量	
	}
	s Ret=$lb(DspQtySum,DspQtyUOM)
	q Ret
}

/******************************* 国家医保处方流转(国标-医保组在用) Start ******************************************/
/// Creator:	jm
/// CreatDate:	2022.12.24
/// Description:电子处方上传预核验-处方信息
/// Input:		EpisodeID:就诊id  PrescNo:处方号
/// Return:		见文档
/// Others:		d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.DataPortal","QryPrescInfo","7468","O230210000160")
Query QryPrescInfo(EpisodeID As %String, PrescNo As %String) As %Query(ROWSPEC = "mdtrtCertType,mdtrtCertNo,cardSn,ecToken,authNo,bizTypeCode,insuPlcNo,hospRxno,initRxno,rxTypeCode,prscTime,rxDrugCnt,rxUsedWayCodg,rxUsedWayName,rxFrquCodg,rxFrquName,rxDosunt,rxDoscnt,rxDrordDscr,valiDays,valiEndTime,reptFlag,maxReptCnt,reptdCnt,minInrvDays,rxCotnFlag,longRxFlag") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.DataPortal","QryPrescInfo","7468","O230210000160")
ClassMethod QryPrescInfoExecute(ByRef qHandle As %Binary, EpisodeID As %String, PrescNo As %String) As %Status
{
    s ^jm("QryPrescInfo")=$lb(EpisodeID,PrescNo)
    s repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s qHandle=$lb(0,repid,0)
    ;
    s OrderRowid=$o(^OEORD(0,"Adm",EpisodeID,0))
    if (OrderRowid="") {
	    Q $$$OK
    }
    s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
    s HospitalId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp(EpisodeID),"^",1)
    ;就诊凭证类型(01:电子凭证令牌,02:身份证号,03:社会保障卡号)
    s mdtrtCertType="02"
    ;就诊凭证编号
    s mdtrtCertNo=##class(web.DHCDocService).GetIDCardNoByPatientID(PatientID)
    ;卡识别码
    s cardSn=""
    ;电子凭证令牌
    s ecToken=""
    ;电子凭证线上身份核验流水号
    s authNo=""
    ;业务类型代码(01:定点医疗机构就诊,02:互联网医院问诊)
    s bizTypeCode="01"
    ;参保地编号(异地参保人必填)
    s InsuAdmInfo=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetInsuAdmInfoByAdmDr(EpisodeID)
    s insuPlcNo=$p(InsuAdmInfo,"^",3)
	;定点医疗机构处方编号
    s hospRxno=PrescNo
    ;续方的原处方编号
    s initRxno=""
    ;处方类别代码
    s rxTypeCode=$p(##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetPrescTypeByNo(EpisodeID,PrescNo),"^",1)
    ;开方时间(yyyy-MM-dd HH:mm:ss)
    s PrescRowid=$o(^PAQUE1(0,"PrescNo",PrescNo,0))
    s TransDate=$p($g(^PAQUE1(PrescRowid)),"^",7)
    s TransTime=$p($g(^PAQUE1(PrescRowid)),"^",8)
    s prscTime=$zd(TransDate,3)_" "_$zt(TransTime,1)
    ;药品类目数(非中药时为处方药品类目数量,中药时为药品总剂数)
    s rxDrugCnt=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetDrugCntByNo(PrescNo,HospitalId)
    ;处方整剂用法编号 处方整剂用法名称(中药汤剂处方使用字段)
    s InstrRowid=$p($g(^PAQUE1(PrescRowid,"DHC")),"^",11)
    s InstrCompInfo=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetInstrCompInfo(InstrRowid,HospitalId)
    s rxUsedWayCodg=$p(InstrCompInfo,"^",1),rxUsedWayName=$p(InstrCompInfo,"^",2)
    ;处方整剂频次编号 处方整剂频次名称(中药汤剂处方使用字段)
    s FreqRowid=$p($g(^PAQUE1(PrescRowid,"DHC")),"^",9)
    s FreqCompInfo=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetFreqCompInfo(FreqRowid,HospitalId)
    s rxFrquCodg=$p(FreqCompInfo,"^",1),rxFrquName=$p(FreqCompInfo,"^",2)
    ;处方整剂剂量单位
    s rxDosunt=""
    s PrescOrderQtyUOM=$p($g(^PAQUE1(PrescRowid,"DHC")),"^",14)
    if (PrescOrderQtyUOM'="") s rxDosunt=$p($g(^CT("UOM",PrescOrderQtyUOM)),"^",2)
    ;处方整剂单次剂量数
    s rxDoscnt=$p($g(^PAQUE1(PrescRowid,"DHC")),"^",13)
    ;处方整剂医嘱说明
    s rxDrordDscr=$p($g(^PAQUE1(PrescRowid,"DHC")),"^",21)
    ;处方有效天数
    s valiDays="3"
    ;有效截止时间
    s valiEndTime=$zd((TransDate+valiDays),3)_" "_$zt(TransTime,1)
    ;复用(多次)使用标志(0:否,1:是)
    s reptFlag=""
    ;最大使用次数
    s maxReptCnt=""
    ;已使用次数
    s reptdCnt=""
    ;使用最小间隔(天数)
    s minInrvDays=""
    ;续方标志(0:否,1:是)
    s rxCotnFlag="0"
    ;长期处方标志(0:否,1:是)
    s longRxFlag="0"
    ;
    d OutputQryPrescInfo
    
    Q $$$OK
OutputQryPrescInfo
	s Data=$lb(mdtrtCertType,mdtrtCertNo,cardSn,ecToken,authNo,bizTypeCode,insuPlcNo,hospRxno,initRxno,rxTypeCode,
		prscTime,rxDrugCnt,rxUsedWayCodg,rxUsedWayName,rxFrquCodg,rxFrquName,rxDosunt,rxDoscnt,rxDrordDscr,valiDays,
		valiEndTime,reptFlag,maxReptCnt,reptdCnt,minInrvDays,rxCotnFlag,longRxFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
}

ClassMethod QryPrescInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPrescInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {                
		Set AtEnd=1
		Set Row=""
	}Else {         
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryPrescInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPrescInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:	jm
/// CreatDate:	2022.12.24
/// Description:电子处方上传预核验-处方明细信息
/// Input:		EpisodeID:就诊id  PrescNo:处方号
/// Return:		
/// Others:		d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.DataPortal","QryDrugDetail","7468","O230210000160")
Query QryDrugDetail(EpisodeID As %String, PrescNo As %String) As %Query(ROWSPEC = "medListCodg,fixmedinsHilistId,hospPrepFlag,rxItemTypeCode,rxItemTypeName,tcmdrugTypeCode,tcmdrugTypeName,tcmherbFoote,mednTypeCode,mednTypeName,mainMedcFlag,urgtFlag,basMednFlag,impDrugFlag,prodBarc,drugProdname,drugGenname,chemname,drugstdcode,drugDosform,drugSpec,prdrName,medcWayCodg,medcWayDscr,medcBegntime,medcDays,medcEndtime,drugPric,drugCnt,drugDosunt,drugSumamt,sinDoscnt,sinDosunt,usedFrquCodg,usedFrquName,drugTotlcnt,drugTotlcntEmp,hospApprFlag,extras") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.DataPortal","QryDrugDetail","7468","O230210000160")
ClassMethod QryDrugDetailExecute(ByRef qHandle As %Binary, EpisodeID As %String, PrescNo As %String) As %Status
{
    s ^jm("QryDrugDetail")=$lb(EpisodeID,PrescNo)
    s repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    ;
    s HospitalId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp(EpisodeID),"^",1)
    s OrderRowid=$o(^OEORD(0,"Adm",EpisodeID,0))
    s ChildSub=0 for {
        s ChildSub=$o(^OEORD(0,"PrescNo",PrescNo,OrderRowid,ChildSub))
        Q:ChildSub=""
        s OrdStatusDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",13)
        s StatusCode=$case(OrdStatusDr,"":"",:$p($g(^OEC("OSTAT",OrdStatusDr)),"^",1))
        continue:(StatusCode'="V")&&(StatusCode'="E")
        s ARCIMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)
        s TariStr=##class(web.DHCINSUPortUse).GetTariDrByArcimRowid(ARCIMRowid,"")
        for j=1:1:$l(TariStr,"^") {
            s TariDr=$p(TariStr,"^",j)
            continue:TariDr=""
            ;医疗目录编码(医保)
            s medListCodg=$p(##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetTarInsuInfo(EpisodeID,TariDr),"^",1)
	        ;医药机构目录编码
	        s fixmedinsHilistId=$p($g(^DHCTARI(TariDr)),"^",1)
	        ;医疗机构制剂标志(0:否,1:是)
	        s hospPrepFlag="0"
	        ;处方项目分类代码 处方项目分类名称
	        s PrescType=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetPrescTypeByNo(EpisodeID,"",OrderRowid_"||"_ChildSub)
	        s rxItemTypeCode=$p(PrescType,"^",2)
	        s rxItemTypeName=$p(PrescType,"^",3)
	        ;中药类别代码 中药类别名称
	        s tcmdrugTypeCode=$p(PrescType,"^",4)
	        s tcmdrugTypeName=$p(PrescType,"^",5)
	        ;草药脚注
	        s tcmherbFoote=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",8)
	        ;药物类型代码 药物类型
	        s mednTypeCode="",mednTypeName=""
	        ;主要用药标志(0:否,1:是)
	        s mainMedcFlag=""
	        ;加急标志(0:否,1:是)
	        s urgtFlag=""
	        ;基本药物标志
	        s basMednFlag=""
	        ;是否进口药品
	        s impDrugFlag=""
	        ;药品条形编码
	        s prodBarc=""
	        ;药品商品名
	        s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
	        s drugProdname=##class(web.DHCST.Common.DrugInfoCommon).GetGoodName(INCIRowid)
	        ;药品通用名
	        s drugGenname=##class(web.DHCSTCOMMONSRV).getGeneric(INCIRowid)
	        ;化学名称
	        s chemname=""
	        ;药品本位码
	        s drugstdcode=""
	        ;药品剂型
	        s drugDosform=$p(##class(web.DHCST.Common.DrugInfoCommon).GetForm(INCIRowid),"^",2)
	        ;药品规格
	        s drugSpec=##class(web.DHCSTCOMMONSRV).getBarcode(INCIRowid)
	        ;生厂厂家
	        s prdrName=""
	        ;用药途径代码 用药途径描述
	        s InstrRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",7)
	        s InstrCompInfo=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetInstrCompInfo(InstrRowid,HospitalId)
			s medcWayCodg=$p(InstrCompInfo,"^",1),medcWayDscr=$p(InstrCompInfo,"^",2)
	        ;用药开始时间(yyyy-MM-dd HH:mm:ss)
	        s StartDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",9)
	        s StartTime=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",10)
	        s medcBegntime=$zd(StartDate,3)_" "_$zt(StartTime,1)
	        ;用药天数
	        s medcDays=""
	        s DurRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",6)
	        if (DurRowid'="") s medcDays=$p($g(^PHCDU(DurRowid)),"^",2)
	        ;用药结束时间(yyyy-MM-dd HH:mm:ss)
	        s medcEndtime=$zd((StartDate+medcDays),3)_" "_$zt(StartTime,1)
	        ;药品单价
	        s drugPric=$p(##class(web.DHCDocOrderCommon).GetOEORIPrice(OrderRowid_"||"_ChildSub),"^",1)
	        s drugPric=$fn(drugPric,"","4")
	        ;药品发药数量
	        s drugCnt=$p($g(^OEORD(OrderRowid,"I",ChildSub,9)),"^",4)
	        ;药品发药单位(医保结算单位)
	        s PackUOMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,"DHC")),"^",13)
            s drugDosunt=$p(##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetUomCompInfo(PackUOMRowid,HospitalId),"^",2)
	        ;药品总金额
	        s drugSumamt=$fn(drugPric*drugCnt,"","2")
	        ;单次用量
	        s sinDoscnt=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",1)
	        ;单次剂量单位
	        s sinDosuntDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",3)
	        s sinDosunt=$p($g(^CT("UOM",sinDosuntDr)),"^",2)
	        ;使用频次编码  使用频次名称
	        s FreqRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",4)
	        s FreqCompInfo=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetFreqCompInfo(FreqRowid,HospitalId)
    		s usedFrquCodg=$p(FreqCompInfo,"^",1),usedFrquName=$p(FreqCompInfo,"^",2)
	        ;用药总量
	        s drugTotlcnt=$p($g(^OEORD(OrderRowid,"I",ChildSub,9)),"^",4)
	        ;用药总量单位
	        s drugTotlcntEmpDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,"DHC")),"^",13)
	        s drugTotlcntEmp=$p($g(^CT("UOM",drugTotlcntEmpDr)),"^",2)
	        ;医院审批标志(0:无须审批,1:,审批通过,2:审批不通过)
	        s hospApprFlag="1"
	        ;扩展数据
        	s extras=""
        	;
        	d OutputQryDrugDetail
        }
    }
    s qHandle=$lb(0,repid,0)
    Q $$$OK
OutputQryDrugDetail
	s Data=$lb(medListCodg,fixmedinsHilistId,hospPrepFlag,rxItemTypeCode,rxItemTypeName,tcmdrugTypeCode,tcmdrugTypeName,
		tcmherbFoote,mednTypeCode,mednTypeName,mainMedcFlag,urgtFlag,basMednFlag,impDrugFlag,prodBarc,drugProdname,drugGenname,
		chemname,drugstdcode,drugDosform,drugSpec,prdrName,medcWayCodg,medcWayDscr,medcBegntime,medcDays,medcEndtime,drugPric,
		drugCnt,drugDosunt,drugSumamt,sinDoscnt,sinDosunt,usedFrquCodg,usedFrquName,drugTotlcnt,drugTotlcntEmp,hospApprFlag,extras)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
}

ClassMethod QryDrugDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDrugDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {                
		Set AtEnd=1
		Set Row=""
	}Else {         
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryDrugDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDrugDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:	jm
/// CreatDate:	2022.12.24
/// Description:电子处方上传预核验-就诊信息
/// Input:		EpisodeID:就诊id  PrescNo:处方号
/// Return:		
/// Others:		d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.DataPortal","QryMdtrtInfo","7468","O230210000160")
Query QryMdtrtInfo(EpisodeID As %String, PrescNo As %String) As %Query(ROWSPEC = "fixmedinsCode,fixmedinsName,mdtrtId,medType,iptOtpNo,otpIptFlag,psnNo,patnName,psnCertType,certno,patnAge,patnHgt,patnWt,gend,gesoVal,nwbFlag,nwbAge,suckPrdFlag,algsHis,prscDeptCode,prscDeptName,drCode,prscDrName,prscDrCertType,prscDrCertno,drProfttlCodg,drProfttlName,drDeptCode,drDeptName,mdtrtTime,diseCodg,diseName,spDiseFlag,maindiagCode,maindiagName,diseCondDscr,hiFeesetlType,hiFeesetlName,rgstFee,medfeeSumamt,fstdiagFlag,extras") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.DataPortal","QryMdtrtInfo","7468","O230210000160")
ClassMethod QryMdtrtInfoExecute(ByRef qHandle As %Binary, EpisodeID As %String, PrescNo As %String) As %Status
{
    s ^jm("QryMdtrtInfo")=$lb(EpisodeID,PrescNo)
    s repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    ;
    s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
    s HospitalId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp(EpisodeID),"^",1)
	s InsuAdmInfo=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetInsuAdmInfoByAdmDr(EpisodeID)
    ;定点医疗机构编号
    s fixmedinsCode=$p(InsuAdmInfo,"^",1)
    ;定点医疗机构名称
    s fixmedinsName=$p(InsuAdmInfo,"^",2)
    ;医保就诊ID
    s mdtrtId=$p(InsuAdmInfo,"^",4)
    ;医疗类别
    s medType=$p(InsuAdmInfo,"^",5)
    ;医保人员编号
    s psnNo=$p(InsuAdmInfo,"^",6)
	;病种编码 病种名称
    s diseCodg=$p(InsuAdmInfo,"^",7)
    s diseName=$p(InsuAdmInfo,"^",8)
    ;住院/门诊号
    s iptOtpNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
    ;门诊住院标识(1:门诊,2:住院)
    s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
    s otpIptFlag=$case(AdmType,"I":"2",:"1")
    ;患者姓名
    s patnName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
    ;人员证件类型
	s psnCertType=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetPsnCertType(EpisodeID)
    ;证件号码
    s certno=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
    ;年龄
    s patnAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID,HospitalId)
    s patnAge=$s(patnAge["岁":+patnAge,1:0)
    ;患者身高(cm) 患者体重(kg)
    s patnHgt="",patnWt=""
    ;性别(0:未知的性别,1:男,2:女,9:未说明性别)
    s gendDr=$p($g(^PAPER(PatientID,"ALL")),"^",7)
    s gend=$p($g(^CT("SEX",gendDr)),"^",1)
	;妊娠(孕周)
	s gesoVal=""
	;新生儿标志(0:否,1:是)
	s nwbFlag="0"
	;新生儿日、月龄
	s nwbAge=""
    ;哺乳期标志
	s suckPrdFlag=""
	;过敏史
	s algsHis=""
	;开方科室编号 开方科室名称
    s OrderRowid=$o(^OEORD(0,"Adm",EpisodeID,0))
    s ChildSub=$o(^OEORD(0,"PrescNo",PrescNo,OrderRowid,0))
    s prscDeptDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,7)),"^",2)
	s prscDeptCode=$p($g(^CTLOC(prscDeptDr)),"^",1)
	s prscDeptName=$p($g(^CTLOC(prscDeptDr)),"^",2)
	;开方医保医师代码 开方医师姓名
    s OrdUserID=$p($g(^OEORD(OrderRowid,"I",ChildSub,7)),"^",1)
    s UserInfo=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetUserInfo(OrdUserID,"",HospitalId)
    s drCode=$p(UserInfo,"^",1)
    s prscDrName=$p(UserInfo,"^",2)
	;开方医师证件类型
	s prscDrCertType="01"
	;开方医师证件号码
	s prscDrCertno=$p(UserInfo,"^",3)
	;医生职称编码 医生职称名称
	s drProfttlCodg=$p(UserInfo,"^",4)
	s drProfttlName=$p(UserInfo,"^",5)
	;医生科室编码 医生科室名称
	s drDeptCode=prscDeptCode
	s drDeptName=prscDeptName
	;就诊时间(yyyy-MM-dd HH:mm:sss)
    s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
    s AdmTime=$p($g(^PAADM(EpisodeID)),"^",7)
    s mdtrtTime=$zd(AdmDate,3)_" "_$zt(AdmTime,1)
	;特殊病种标志(0:否,1:是)
    s spDiseFlag="0"
	;主诊断代码 主诊断名称
    s maindiagCode="",maindiagName=""
    s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
    s MRSub=0 for {
        s MRSub=$o(^MR(MRAdmRowid,"DIA",MRSub))
        Q:MRSub=""
        s ICDRowid=$p($g(^MR(MRAdmRowid,"DIA",MRSub)),"^",1)
        continue:ICDRowid=""
        s DiagInsuInfo=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetDiagInsuInfo(ICDRowid,HospitalId)
        s ICDCode=$p(DiagInsuInfo,"^",1),ICDDesc=$p(DiagInsuInfo,"^",2)
        s MainFlag=$p($g(^MR(MRAdmRowid,"DIA",MRSub,1)),"^",20)
        if ((maindiagCode="")||(MainFlag="Y")) {
            s maindiagCode=ICDCode,maindiagName=ICDDesc
        }
    }
	;疾病病情描述
    s diseCondDscr=""
	;医保费用结算类型
	s hiFeesetlType=""
	;医保费用类别名
	s hiFeesetlName=""
	;挂号费
	s rgstFee=""
    ;医疗费总额
    s medfeeSumamt="0"
    ;是否初诊(0:否,1:是)
	s fstdiagFlag=""
    ;扩展数据
    s extras=""
	;
    d OutputQryMdtrtInfo
    
    s qHandle=$lb(0,repid,0)
    Q $$$OK
OutputQryMdtrtInfo
	s Data=$lb(fixmedinsCode,fixmedinsName,mdtrtId,medType,iptOtpNo,otpIptFlag,psnNo,patnName,psnCertType,certno,patnAge,
		patnHgt,patnWt,gend,gesoVal,nwbFlag,nwbAge,suckPrdFlag,algsHis,prscDeptCode,prscDeptName,drCode,prscDrName,
		prscDrCertType,prscDrCertno,drProfttlCodg,drProfttlName,drDeptCode,drDeptName,mdtrtTime,diseCodg,diseName,spDiseFlag,
		maindiagCode,maindiagName,diseCondDscr,hiFeesetlType,hiFeesetlName,rgstFee,medfeeSumamt,fstdiagFlag,extras)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
}

ClassMethod QryMdtrtInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMdtrtInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {                
		Set AtEnd=1
		Set Row=""
	}Else {         
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryMdtrtInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMdtrtInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:	jm
/// CreatDate:	2022.12.24
/// Description:电子处方上传预核验-诊断信息
/// Input:		EpisodeID:就诊id
/// Return:		
/// Others:		d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.DataPortal","QryDiseInfo","7468")
Query QryDiseInfo(EpisodeID As %String) As %Query(ROWSPEC = "diagType,maindiagFlag,diagSrtNo,diagCode,diagName,diagDept,diagDrNo,diagDrName,diagTime,tcmDiseCode,tcmDiseName,tcmsympCode,tcmsymp") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.InsuPresc.DataPortal","QryDiseInfo","7468")
ClassMethod QryDiseInfoExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
    s ^jm("QryDiseInfo")=$lb(EpisodeID)
    s repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    ;
    s HospitalId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp(EpisodeID),"^",1)
    s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	s ChildSub=0 for {
		s ChildSub=$o(^MR(MRAdmRowid,"DIA",ChildSub))
		Q:ChildSub=""
		s ICDRowid=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",1)
		continue:ICDRowid=""
		;诊断类别(1:西医诊断,2:中医主病诊断,3:中医主证诊断其他诊断)
		s diagType="1"
		s BillFlag3=$p($g(^MRC("ID",ICDRowid)),"^",15)
		if (BillFlag3="Y") {
			s diagType="2"
			s BillFlag1=$p($g(^MRC("ID",ICDRowid)),"^",13)
			if (BillFlag1="Y") s diagType="3"
		}
		;主诊断标志(0:否,1:是)
		s MainFlag=$p($g(^MR(MRAdmRowid,"DIA",ChildSub,1)),"^",20)
		s maindiagFlag=$case(MainFlag,"Y":"1",:"0")
		;诊断排序号
		s diagSrtNo=ChildSub
		;诊断代码(使用国家医保诊断代码)  诊断名称
		s DiagInsuInfo=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetDiagInsuInfo(ICDRowid,HospitalId)
        s diagCode=$p(DiagInsuInfo,"^",1),diagName=$p(DiagInsuInfo,"^",2)
		;诊断科室
		s AddLocDr=$p($g(^MR(MRAdmRowid,"DIA",ChildSub,1)),"^",25)
		if (AddLocDr="") s AddLocDr=$p($g(^PAADM(EpisodeID)),"^",4)
		s diagDept=$p($g(^CTLOC(AddLocDr)),"^",2)
		;诊断医生编码(国家医保医师代码) 诊断医生姓名
		s AddUserDr=$p($g(^MR(MRAdmRowid,"DIA",ChildSub,1)),"^",18)
		if (AddUserDr'="") {
			s UserInfo=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetUserInfo(AddUserDr,"",HospitalId)
		}else{
			s AddDocDr=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",4)
			s UserInfo=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetUserInfo("",AddDocDr,HospitalId)
		}
		s diagDrNo=$p(UserInfo,"^",1)
		s diagDrName=$p(UserInfo,"^",2)
		;诊断时间(yyyy-MM-dd HH:mm:ss)
		s MRDIADate=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",7)
		s MRDIATime=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",8)
		s diagTime=$zd(MRDIADate,3)_" "_$zt(MRDIATime,1)
		;中医病名代码 中医病名 中医症候代码 中医症候(diagType为2,3时上传)
		s (tcmDiseCode,tcmDiseName,tcmsympCode,tcmsymp)=""
		if ((diagType="2")||(diagType="3")) {
			s (tcmDiseCode,tcmsympCode)=$p($g(^MRC("ID",ICDRowid)),"^",4)
			s (tcmDiseName,tcmsymp)=$p($g(^MRC("ID",ICDRowid)),"^",2)
		}
    	d OutputQryDiseInfo
	}
    s qHandle=$lb(0,repid,0)
    Q $$$OK
OutputQryDiseInfo
	s Data=$lb(diagType,maindiagFlag,diagSrtNo,diagCode,diagName,diagDept,diagDrNo,diagDrName,diagTime,tcmDiseCode,tcmDiseName,tcmsympCode,tcmsymp)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
}

ClassMethod QryDiseInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiseInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {                
		Set AtEnd=1
		Set Row=""
	}Else {         
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryDiseInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiseInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:	jm
/// CreatDate:	2022.12.24
/// Description:电子处方医保电子签名+上传+撤销+查询
/// Input:		EpisodeID:就诊id  PrescNo:处方号  InfoType:交易类型编码(具体见文档)
/// Return:		见文档
/// Others:		zw ##class(DHCDoc.Interface.Inside.InsuPresc.DataPortal).GetRxSignUpldInfo("8310","O230301000169","rxUndo")
/// rxFixmedinsSign  rxFileUpld  rxUndo  hospRxDetlQuery  rxChkInfoQuery  rxSetlInfoQuery
ClassMethod GetRxSignUpldInfo(EpisodeID As %String, PrescNo As %String, InfoType As %String) As %String
{
	s DataObj=##class(%ArrayOfDataTypes).%New()
	s PrescBaseRowid=$o(^DOC.Interface.PrescBaseI("IdxPrescNo",PrescNo,0))
	Q:PrescBaseRowid="" DataObj
	;
	s HospitalId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp(EpisodeID),"^",1)
	s InsuAdmInfo=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetInsuAdmInfoByAdmDr(EpisodeID)
	if (InfoType="rxFixmedinsSign") {
		s DataObj=##class(DHCDoc.Util.ArrayData).%New()
	}
	;定点医疗机构编号
	s fixmedinsCode=$p(InsuAdmInfo,"^",1)
	d DataObj.SetAt(fixmedinsCode,"fixmedinsCode")
	;医保处方编号
	s hiRxno=$lg(^DOC.Interface.PrescBaseD(PrescBaseRowid),8)
	d DataObj.SetAt(hiRxno,"hiRxno")
	;医保就诊ID
	s mdtrtId=$p(InsuAdmInfo,"^",4)
	d DataObj.SetAt(mdtrtId,"mdtrtId")
    if (InfoType="rxUndo") {	;撤销
	    ;撤销医师的医保医师代码 撤销医师姓名 撤销医师证件类型 撤销医师证件号码
    	s OrderRowid=$o(^OEORD(0,"Adm",EpisodeID,0))
    	s ChildSub=$o(^OEORD(0,"PrescNo",PrescNo,OrderRowid,0))
    	s XCTPCPRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",29)
    	s UserInfo=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetUserInfo("",XCTPCPRowid,HospitalId)
    	s drCode=$p(UserInfo,"^",1),undoDrName=$p(UserInfo,"^",2),undoDrCertno=$p(UserInfo,"^",3)
    	d DataObj.SetAt(drCode,"undoDrCode")
    	d DataObj.SetAt(undoDrName,"undoDrName")
		d DataObj.SetAt("01","undoDrCertType")
		d DataObj.SetAt(undoDrCertno,"undoDrCertno")
		;撤销原因描述
		d DataObj.SetAt("病情需要","undoRea")
		;撤销时间(yyyy-MM-dd HH:mm:ss)
		s XDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",34)
		s XTime=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",15)
		s undoTime=$zd(XDate,3)_" "_$zt(XTime,1)
		d DataObj.SetAt(undoTime,"undoTime")
    }else{
	    ;患者姓名
		s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	    s patnName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	    d DataObj.SetAt(patnName,"patnName")
		;人员证件类型
		s psnCertType=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetPsnCertType(EpisodeID)
		d DataObj.SetAt(psnCertType,"psnCertType")
		;证件号码
	    s certno=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	    d DataObj.SetAt(certno,"certno")
	    if ((InfoType="rxFixmedinsSign")||(InfoType="rxFileUpld")) {	;医保电子签名+上传
		    ;定点医疗机构名称
			s fixmedinsName=$p(InsuAdmInfo,"^",2)
			d DataObj.SetAt(fixmedinsName,"fixmedinsName")
			;处方追溯码
			s rxTraceCode=$lg(^DOC.Interface.PrescBaseD(PrescBaseRowid),7)
			d DataObj.SetAt(rxTraceCode,"rxTraceCode")
			;开方医保医师代码  开方医师姓名
			s OrderRowid=$o(^OEORD(0,"Adm",EpisodeID,0))
		    s ChildSub=$o(^OEORD(0,"PrescNo",PrescNo,OrderRowid,0))
		    s OrdUserID=$p($g(^OEORD(OrderRowid,"I",ChildSub,7)),"^",1)
		    s UserInfo=##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetUserInfo(OrdUserID,"",HospitalId)
		    s drCode=$p(UserInfo,"^",1)
		    s prscDrName=$p(UserInfo,"^",2)
		    d DataObj.SetAt(drCode,"drCode")
		    d DataObj.SetAt(prscDrName,"prscDrName")
		    ;审方药师科室编号  审方药师科室名称
			s RecDepRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",6)
		    s pharDeptCode=$p($g(^CTLOC(RecDepRowid)),"^",1)
		    s pharDeptName=$p($g(^CTLOC(RecDepRowid)),"^",2)
		    d DataObj.SetAt(pharDeptCode,"pharDeptCode")
		    d DataObj.SetAt(pharDeptName,"pharDeptName")
		    ;审方医保药师代码  审方药师姓名
		    d DataObj.SetAt("","pharCode")
		    d DataObj.SetAt("","pharName")
		    ;审方药师证件类型  审方药师证件号码
		    d DataObj.SetAt("01","pharCertType")
		    d DataObj.SetAt("","pharCertno")
		    ;审方药师职称编码  审方药师职称名称
		    d DataObj.SetAt("","pharProfttlCodg")
		    d DataObj.SetAt("","pharProfttlName")
		    ;审方药师执业资格证号
		    d DataObj.SetAt("","pharPracCertNo")
		    ;医疗机构药师审方时间(yyyy-MM-dd HH:mm:ss)
		    s StartDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",9)
		    s StartTime=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",10)
		    s pharChkTime=$zd(StartDate,3)_" "_$zt(StartTime,1)
		    d DataObj.SetAt(pharChkTime,"pharChkTime")
		    ;
		    if (InfoType="rxFixmedinsSign") {
			    s RxObj=##class(%ArrayOfDataTypes).%New()
			    ;定点机构代码
			    d RxObj.SetAt(fixmedinsCode,"fixmedinsCode")
			    ;原始待签名处方信息
			    s originalJson=DataObj.%ToJSON().Read()
				s originalValue=##class(web.Util.Encryption).Base64Encode(originalJson)
				s originalValue=$replace(originalValue,$c(10),"")
				s originalValue=$replace(originalValue,$c(13),"")
				d RxObj.SetAt(originalValue,"originalValue")
				;原始待签名处方文件
				s obj=##class(DOC.Interface.PrescBase).%OpenId(PrescBaseRowid)
			    s Base64Stream=obj.Base64Str
				s originalRxFile=##Class(%CSP.CharacterStream).%New()
				while ('Base64Stream.AtEnd) {
					s OneBase64Str=Base64Stream.Read()
					if (OneBase64Str[",") s OneBase64Str=$p(OneBase64Str,",",2)
					d originalRxFile.Write(OneBase64Str)
				}
				d RxObj.SetAt(originalRxFile,"originalRxFile")
				;扩展字段
				d RxObj.SetAt("","extras")
				Q RxObj
		    }else{
			    ;处方原件
				s obj=##class(DOC.Interface.PrescBase).%OpenId(PrescBaseRowid)
			    s rxFileStream=obj.rxFile
				d DataObj.SetAt(rxFileStream,"rxFile")
			    ;处方信息签名值
	    		s signDigestStream=obj.signDigest
	    		d DataObj.SetAt(signDigestStream,"signDigest")
	 			;扩展字段
				d DataObj.SetAt("","extras")
		    }
		}else{	;查询
    		;电子凭证令牌
    		d DataObj.SetAt("","ecToken")
		}
    }
	Q DataObj
}

}
