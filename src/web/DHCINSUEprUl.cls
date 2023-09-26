Import SQLUser

/// 病历上传信息相关类
/// wty 20210305
Class web.DHCINSUEprUl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Query QueryPat(PatNo As %String, MedNo As %String, Zylsh As %String, Djlsh As %String, UpFlag As %String, DateFlag As %String, SDate As %String, EDate As %String, InsuType As %String, PatType As %String, HospId As %String, OptType As %String = "", CenterType As %String, StasType As %String = "") As %Query(ROWSPEC = "ListDtl,ChangeDtl,TPatRegNo,TPatName,TMedcasNo,TAdmReason,TDepDesc,TAdmDate,TOutDate,TDisDate,TInsuNo,TInsuZylsh,TInsuDjlsh,TOpter,TOptDate,TOptFlag,TListId,Eid,AdmDr,DivDr,TOptType,TEMRDate,TIPMRDate,DivFlag,TPrtDr,TPrtActStus,TStasType,TStasTypeDesc")
{
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSUEprUl","QueryPat","","","","","2","4",66172,66541,"00A","","2","IP","1","0")  
/// d ##Class(%ResultSet).RunQuery("web.DHCINSUEprUl","QueryPat","","","","","2","4",66233,66536,"00A","","2","","1","1")
ClassMethod QueryPatExecute(ByRef qHandle As %Binary, PatNo As %String, MedNo As %String, Zylsh As %String, Djlsh As %String, UpFlag As %String, DateFlag As %String, SDate As %String, EDate As %String, InsuType As %String, PatType As %String, HospId As %String, OptType As %String = "", CenterType As %String, StasType As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	i $g(ind)="" Set ind=1
	s SDate=##class(websys.Conversions).DateHtmlToLogical(SDate)
	s EDate=##class(websys.Conversions).DateHtmlToLogical(EDate)
	s ^TMP("QueryPat")=$lb(PatNo,MedNo,Zylsh,Djlsh,UpFlag,DateFlag,SDate,EDate,InsuType,PatType,HospId,OptType,CenterType,StasType)
	//已上传
	
	s OptFlag=$case(UpFlag,"1":"","2":"Y","3":"E",:"")
	i ((UpFlag="2")||(UpFlag="3")){
		//s DateFlag=4 ;已上传数据只能按照上传日期查询
		i PatNo'="" d  ;登记号
		.s PAPMIDR=""
		.s PAPMIDR=$o(^PAPERi("PAPMI_PatNo",PatNo,PAPMIDR))
		.s Eid=""
		.f  s Eid=$o(^DHCINEULi("PapmiDr",PAPMIDR,Eid)) q:Eid=""  d
		..d queryItm
		e  i MedNo'="" d  ;病案号
		.s Eid=""
		.f  s Eid=$o(^DHCINEULi("MedNo",MedNo,Eid)) q:Eid=""  d
		..d queryItm
		e  i Zylsh'="" d  ;医保登记流水号
		.s Eid=""
		.f  s Eid=$o(^DHCINEULi("Zylsh",Zylsh,Eid)) q:Eid=""  d
		..d queryItm
		e  i Djlsh'="" d  ;医保结算流水号
		.s Eid=""
		.f  s Eid=$o(^DHCINEULi("Djlsh",Djlsh,Eid)) q:Eid=""  d
		..d queryItm
		e  i DateFlag>0  d  ;DateFlag 0不按日期，1入院日期，2出院日期，3结算日期，4上传日期，5编目日期，6病历提交日期
		.i DateFlag=1 d
		..f iDate=SDate:1:EDate d ;1入院日期
		...s Eid=""
		...f  s Eid=$o(^DHCINEULi("AdmDate",iDate,Eid)) q:Eid=""  d
		....q:(InsuType'="")&(InsuType'=$p($g(^DHCINEUL(Eid)),"^",8))
		....q:(PatType'="")&(PatType'=$p($g(^DHCINEUL(Eid)),"^",15))
		....d queryItm
		.i DateFlag=2 d  ;2出院日期
		..f iDate=SDate:1:EDate d
		...s Eid=""      
		...f  s Eid=$o(^DHCINEULi("OutDate",iDate,Eid)) q:Eid=""  d
		....q:(InsuType'="")&(InsuType'=$p($g(^DHCINEUL(Eid)),"^",8))
		....q:(PatType'="")&(PatType'=$p($g(^DHCINEUL(Eid)),"^",15))
		....d queryItm
		.i DateFlag=3 d ;3结算日期
		..f iDate=SDate:1:EDate d
		...s Eid=""
		...f  s Eid=$o(^DHCINEULi("DisDate",iDate,Eid)) q:Eid=""  d
		....q:(InsuType'="")&(InsuType'=$p($g(^DHCINEUL(Eid)),"^",8))
		....q:(PatType'="")&(PatType'=$p($g(^DHCINEUL(Eid)),"^",15))
		....d queryItm
		.i DateFlag=4 d ;4上传日期
		..f iDate=SDate:1:EDate d 
		...s Eid=""
		...f  s Eid=$o(^DHCINEULi("OptDate",iDate,Eid)) q:Eid=""  d
		....q:(InsuType'="")&(InsuType'=$p($g(^DHCINEUL(Eid)),"^",8))
		....q:(PatType'="")&(PatType'=$p($g(^DHCINEUL(Eid)),"^",15))
		....d queryItm
		.i DateFlag=5 d ;5病案编目日期
		..f iDate=SDate:1:EDate d
		...s Eid=""
		...f  s Eid=$o(^DHCINEULi("IPMRDate",iDate,Eid)) q:Eid=""  d
		....q:(InsuType'="")&(InsuType'=$p($g(^DHCINEUL(Eid)),"^",8))
		....q:(PatType'="")&(PatType'=$p($g(^DHCINEUL(Eid)),"^",15))
		....d queryItm
		.i DateFlag=6 d ;6病历提交日期
		..f iDate=SDate:1:EDate d
		...s Eid=""
		...f  s Eid=$o(^DHCINEULi("EMRDate",iDate,Eid)) q:Eid=""  d
		....q:(InsuType'="")&(InsuType'=$p($g(^DHCINEUL(Eid)),"^",8))
		....q:(PatType'="")&(PatType'=$p($g(^DHCINEUL(Eid)),"^",15))
		....d queryItm
		
	}else {
		i DateFlag=3 {   //按照结算日期
		 f iDate=SDate:1:EDate d
		 .s DivDr=""
		 .f  s DivDr=$o(^DHCINDIV("0","IDate",iDate,DivDr)) q:DivDr=""  d
		 ..s DivInfo=$g(^DHCINDIV(DivDr))
		 ..s Flag=$p(DivInfo,"^",5)
		 ..q:Flag'="I"
		 ..s InDivDr=DivDr
		 ..d queryUnItm
		 ..b ;
		}
		 i +DateFlag=5 {  //5病案编目日期
		     #dim AdmAry As %ArrayOfDataTypes
		     s AdmAry=..GetEpisodeListFromIMPR(HospId,SDate,EDate)
		     q:($g(AdmAry)="")||(+AdmAry<0) $$$OK
		     s Cnt=AdmAry.Count()
		     f num=1:1:Cnt
		     {
			    s AdmDr=AdmAry.GetAt(num)
			    b ;hhh
			    d queryUnItm
			  }
		 }
		 i +DateFlag=6 {  //6病历提交日期
		     #dim EMRAdmAry As %ArrayOfDataTypes
		     s EMRAdmAry=..GetEpisodeListFromEMR($zd(SDate,3),$zd(EDate,3))
		     q:($g(EMRAdmAry)="")||(+EMRAdmAry<0) $$$OK
		     s Cnt=EMRAdmAry.Count()
		     f num=1:1:Cnt
		     {
			    s AdmDr=EMRAdmAry.GetAt(num)
			    s tmpHospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
				continue:tmpHospId'=HospId //院区过滤
			    d queryUnItm
			  }
		   
		}
		
    }
	s qHandle=$lb(0,repid,0)
	q $$$OK
queryItm
	s EPLStr=$g(^DHCINEUL(Eid))
 
	s PatID=$p(EPLStr,"^",1)
	s AdmID=$p(EPLStr,"^",2)
	s TOptFlag=$p(EPLStr,"^",15)		;上传标志
	s HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmID) //+ DingSH 20200526
	s PrtDr="",DivFlag=""

	q:HospId'=HospDr
	s HisAdmType=$P(^PAADM(AdmID),"^",2)
	q:+(UpFlag=3)&&(TOptFlag'="E") 
	q:(OptType'="")&&(OptType="IP")&&(HisAdmType'="I")
	q:(OptType'="")&&(OptType="OP")&&(HisAdmType="I")
	s PatInfo=$$GetPatInfoByPatID^DHCINSUPatInfo(PatID,HospDr)

    b ; PatInfo
	s TPatName=$p(PatInfo,"^",3)		;姓名
	s TPatRegNo=$p(PatInfo,"^",2)		;登记号
	s AdmInfo=$$GetAdmInfoByAdmID^DHCINSUPatInfo(AdmID)
    
    b ; AdmInfo
	s TMedcasNo=$p(EPLStr,"^",4)		;病案号
	;q:UpFlag'=$p(EPLStr,"^",14)
	s TAdmReason=$p(AdmInfo,"^",29)		;费别

   

	s TDepDesc=$p(AdmInfo,"^",5)		;科室
	s TInsuNo=$p(EPLStr,"^",5)			;医保卡号
	s TInsuZylsh=$p(EPLStr,"^",6)		;医保登记流水号
	s TInsuDjlsh=$p(EPLStr,"^",7)		;医保结算流水号
	s TInsuType=$p(EPLStr,"^",8)		;医保类型
	s TAdmDate=$p(EPLStr,"^",9)			;入院日期
	s TOutDate=$p(EPLStr,"^",10)		;出院日期
	s:TOutDate'="" TOutDate=$zd(TOutDate,3)
	s TDisDate=$p(EPLStr,"^",11)		;结算日期
	s TOpter=$p(EPLStr,"^",12)			;上传操作员
	s TOpter=$p(^SSU("SSUSR",TOpter),"^",2) 
	s TOptDate=$p(EPLStr,"^",13)		;上传日期
	s TOptTime=$p(EPLStr,"^",14)		;上传日期
	s TOptDate=$zd(TOptDate,3)_" "_$zt(TOptTime)
	//i TOptFlag="Y" s TOptFlag="已上传"
	s TOptFlag=$case(TOptFlag,"Y":"上传成功","E":"上传失败",:"未上传")
	s TPatType=$p(EPLStr,"^",16)		;险种（病人类型）
	s TListId=$p(EPLStr,"^",17)			;清单id
	s ListDtl="清单详情"
	s Change="变更详情"
	s DivDr=$p(EPLStr,"^",3)

    s Divstr=$g(^DHCINDIV(DivDr))
	b ;Divstr
	s AdmStr=$g(^DHCINADM(AdmID))
	b ;AdmStr
    s TmpInsuCenterID=$p(AdmStr,"^",8) ;统筹区号
	s TmpAdmCenterID=$p(AdmStr,"^",7) ;统筹区号 
	s ClrTpye= $p(Divstr,"^",39)     ;清算类别
	b ;TmpAdmCenterID;TmpInsuCenterID
	;upt 20230316 JinS1010 参保类型
	s patCenterType=##class(web.DHCINSUEprUl).GetPatCenterTpye(TmpAdmCenterID,ClrTpye,InsuType,HospId) ;CenterType,1市医保，2省本级，3省异地
	b ;patCenterType
    q:CenterType'=patCenterType
	;+20230303 清单分类状态 HanZH
	s TStasType=$p(EPLStr,"^",21)	;清单分类状态
	q:(StasType'="")&&(TStasType'=StasType)
	//s TStasTypeDesc=$case(TStasType,"0":"未提交","1":"已提交","2":"审核通过","3":"审核不通过")	;清单分类状态描述
	s TStasTypeDesc=$case(TStasType,"":"未提交","0":"未提交","1":"已提交","2":"审核通过","3":"审核不通过")	;清单分类状态描述 upt 20230316 HanZH
	s TOptType=$case(HisAdmType,"I":"IP","O":"OP",:"")
    s TEMRDate=$p(EPLStr,"^",25)		   ;病案提交日期
    s:TEMRDate'="" TEMRDate=$zd(TEMRDate,3)
    s TIPMRDate=$p(EPLStr,"^",26)		   ;病案编目日期
    s:TIPMRDate'="" TIPMRDate=$zd(TIPMRDate,3)
    i +DivDr>0 d
    .s DivInfo=$g(^DHCINDIV(DivDr))
    .s DivFlag=$p(DivInfo,"^",5)
    .s PrtDr=$p(DivInfo,"^",4)
    .s BillDr=$p(DivInfo,"^",3)
    .i +BillDr>0 d
    ..s PrtDr=""
    ..s PrtDr=$O(^DHCINVPRTZY(0,"AR",BillDr,PrtDr),-1)
    s TPrtActStus=..CheckPrtActStus(TOptType,PrtDr)     //发票状态
	s DivFlag=$case(DivFlag,"I":"结算","D":"预结算","B":"被撤销","S":"撤销",:"其他")
	b ;end
	s Data=$lb(ListDtl,Change,TPatRegNo,TPatName,TMedcasNo,TAdmReason,TDepDesc,$zd(TAdmDate,3),TOutDate,$zd(TDisDate,3),TInsuNo,TInsuZylsh,TInsuDjlsh,TOpter,TOptDate,TOptFlag,TListId,Eid,AdmID,DivDr,TOptType,TEMRDate,TIPMRDate,DivFlag,PrtDr,TPrtActStus,TStasType,TStasTypeDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q 



queryUnItm
    s tmpInDivDr="",tmpAdmDr=""
	s tmpStates=$p(^DHCINADM(InAdmDr),"^",7)

    b ;0
    s tmpInDivDr=$g(InDivDr)
    s tmpAdmDr=$g(AdmDr)
    q:(+tmpInDivDr=0)&&(+$g(tmpAdmDr)=0)
    s QFlag="Y",PrtDr="",DivFlag=""
    i (+tmpInDivDr=0)  d
    .s AdmReasonDr=$P(^PAADM(tmpAdmDr,1),"^",7)
	.q:+AdmReasonDr=0
	.s NationalCode=$P(^PAC("ADMREA",AdmReasonDr),"^",5)  
	.q:+NationalCode=0           //自费患者
	.s QFlag="N"
    .s tmpInDivDr=$O(^DHCINDIV("0","Paadm",tmpAdmDr,""),-1)
    e  d
    .s QFlag="N"
    q:QFlag="Y"
    s InAdmDr=""
    i +tmpInDivDr=0 d
    .s InAdmDr=$O(^DHCINADM("0","ADM",tmpAdmDr,""),-1)
    e  d
    .s DivInfo=$g(^DHCINDIV(tmpInDivDr))
    .s InAdmDr=$p(DivInfo,"^",2)
    .s tmpAdmDr=$p(DivInfo,"^",1)
    .s DivFlag=$p(DivInfo,"^",5)
    .s PrtDr=$p(DivInfo,"^",4)
    .s BillDr=$p(DivInfo,"^",3)
    .i +BillDr>0 d
    ..s PrtDr=""
    ..s PrtDr=$O(^DHCINVPRTZY(0,"AR",BillDr,PrtDr),-1)
    
    q:+InAdmDr=0                     //医保未登记
    s ActFlag=$P(^DHCINADM(InAdmDr),"^",11)
    q:(ActFlag'="A")&&(ActFlag'="O")  //非有效状态
	//s offsite=$P(^DHCINADM(InAdmDr),"^",46) //异地
	//b offsite
	//s InsuTyp=$P(^DHCINADM(InAdmDr),"^",44)
	//b InsuTyp

    s Flag=""
    i +tmpInDivDr>0  d
    .s Flag=$p(DivInfo,"^",5)
	.s tmpInsuAdmType=$p(^DHCINADM(InAdmDr),"^",14)
	.s tmpInsuPatType=$p(^DHCINADM(InAdmDr),"^",4) ;险种（病人类型）
	.s tmpInsuType=$P(^DHCINADM(InAdmDr),"^",18)
    .s tmpInsuNo=$p(^DHCINADM(InAdmDr),"^",2)	;医保卡号


    .s tmpInsuZylsh=$p(DivInfo,"^",30)		    ;医保登记流水号
	.s tmpInsuDjlsh=$p(DivInfo,"^",8)		    ;医保结算流水号
    .s tmpInsuiDate=$p(DivInfo,"^",16)		    ;结算日期
    .s tmpInsuiDate=$zd(tmpInsuiDate,3) 
    e  d
    .s tmpInsuAdmType=""
	.s tmpInsuPatType=""
	.s tmpInsuType=""
    .s tmpInsuNo=""
    .s tmpInsuZylsh=""
	.s tmpInsuDjlsh=""
    .s tmpInsuiDate="登记未结算"
    q:(+tmpInDivDr>0)&&(Flag'="I")
    s tmpOptFlag="",tmpEpr="",tmpEMRDate="",tmpIPMRDate="",TStasType="",TStasTypeDesc=""
    i (+tmpInDivDr>0)&&($d(^DHCINEULi("DivDr",tmpInDivDr))) d
	.s EpDr=""
    .s EpDr=$O(^DHCINEULi("DivDr",tmpInDivDr,""),-1)
	.s tmpOptFlag=$p(^DHCINEUL(EpDr),"^",15)		;上传标志
	.s tmpEMRDate=$p(^DHCINEUL(EpDr),"^",25)		;
	.s tmpIPMRDate=$p(^DHCINEUL(EpDr),"^",26)		;
	.s:tmpEMRDate'="" tmpEMRDate=$zd(tmpEMRDate,3)
	.s:tmpIPMRDate'="" tmpIPMRDate=$zd(tmpIPMRDate,3)
	.s tmpEpr=EpDr
	.s TStasType=$p(^DHCINEUL(EpDr),"^",21)			;清单分类状态	+20230303 HanZH
    e  d
    .s FrontpageInfo =##class(MA.IPMR.IO.OutService).GetFrontpageInfo(tmpAdmDr,"")  //1^编目日期^编目时间^编码员
    .i +FrontpageInfo=1 d
    ..s tmpIPMRDate=$P(FrontpageInfo,"^",2)
    .s EMRStusInfo=##Class(EMRservice.BL.BLAdmRecordStatus).GetAdmRecordStatusInfoByEpisodeID(tmpAdmDr)
    .i +EMRStusInfo=1 d
    ..s tmpEMRDate=$P($P(EMRStusInfo,"^",2)," ",1)
	b ;000
    q:OptFlag'=tmpOptFlag
	q:(StasType'="")&&(TStasType'=StasType)	;清单分类状态过滤 +20230303 HanZH
	s HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(tmpAdmDr) //+ DingSH 20200526
	s PatID=+^PAADM(tmpAdmDr)
	s HisAdmType=$P(^PAADM(tmpAdmDr),"^",2)
	s InsuAdmType=tmpInsuAdmType
	q:(OptType'="")&&(OptType="IP")&&(HisAdmType'="I")
	s DicSpeDiseType=""
	s:HisAdmType'="I" DicSpeDiseType=##class(web.DHCINSUPort).GetDicByCodeAndInd("HISPROPerty00A","SpeDiseType",4,HospDr)
    q:(HisAdmType'="I")&&(DicSpeDiseType'[("|"_InsuAdmType_"|")) //门诊慢特病
	s AdmInfo=$$GetAdmInfoByAdmID^DHCINSUPatInfo(tmpAdmDr)
	s PatInfo=$$GetPatInfoByPatID^DHCINSUPatInfo(PatID,HospDr)		
	s TPatName=$p(PatInfo,"^",3)			;姓名
	s TPatRegNo=$p(PatInfo,"^",2)
	q:(PatNo'="")&(PatNo'=TPatRegNo) 		;登记号
	s TMedcasNo=$p(AdmInfo,"^",27)
	q:(MedNo'="")&(MedNo'=TMedcasNo) 		;病案号
	s TAdmReason=$p(AdmInfo,"^",29)		    ;费别
	
	s TDepDesc=$p(AdmInfo,"^",5)			;科室
	s TInsuNo=tmpInsuNo
	s TInsuZylsh=tmpInsuZylsh		        ;医保登记流水号
	q:(Zylsh'="")&(Zylsh'=TInsuZylsh)		
	s TInsuDjlsh=tmpInsuDjlsh		         ;医保结算流水号
	q:(Djlsh'="")&(Djlsh'=TInsuDjlsh)
	s TInsuType=tmpInsuType	                ;医保类型
	q:(InsuType'="")&(InsuType'=TInsuType)	;	
	s TAdmDate=$p(AdmInfo,"^",6)			;入院日期
	s TOutDate=$p(AdmInfo,"^",10)			;出院日期


    s TmpInsuCenterID=$p(AdmInfo,"^",8) ;统筹区号    
	s TmpAdmCenterID=$p(AdmInfo,"^",7) ;统筹区号  
	s ClrTpye= $p(Divstr,"^",39)     ;清算类别
	;upt 20230316 JinS1010 参保类型
    s patCenterType=##class(web.DHCINSUEprUl).GetPatCenterTpye(TmpAdmCenterID,ClrTpye,InsuType,HospId)   ;CenterType,1市医保，2省本级，3省异地
	b ;patCenterType
    q:CenterType'=patCenterType
    d queryData
    q

queryData

	s TDisDate=tmpInsuiDate		            ;结算日期
	s TOpter=""							    ;上传操作员
	s TOptDate=""							;上传日期
	s TOptFlag=tmpOptFlag				    ;上传标志
	s TOptFlag=$case(TOptFlag,"Y":"上传成功","E":"上传失败",:"未上传")
	s TStasTypeDesc=$case(TStasType,"0":"未提交","1":"已提交","2":"审核通过","3":"审核不通过")	;清单分类状态描述	+20230303 HanZH
	s TPatType=tmpInsuPatType ;险种（病人类型）
	s TListId=""							;清单id
	s Eid=tmpEpr
	s ListDtl=""
	s ChangeDtl=""
	s TOptType=$case(HisAdmType,"I":"IP","O":"OP",:"")  //??
	s TPrtActStus=..CheckPrtActStus(TOptType,PrtDr)     //发票状态
	s DivFlag=$case(DivFlag,"I":"结算","D":"预结算","B":"被撤销","S":"撤销",:"其他")
    s TEMRDate=tmpEMRDate
    s TIPMRDate=tmpIPMRDate
	b ;5
	s Data=$lb(ListDtl,ChangeDtl,TPatRegNo,TPatName,TMedcasNo,TAdmReason,TDepDesc,TAdmDate,TOutDate,TDisDate,TInsuNo,TInsuZylsh,TInsuDjlsh,TOpter,TOptDate,TOptFlag,TListId,Eid,tmpAdmDr,tmpInDivDr,TOptType,TEMRDate,TIPMRDate,DivFlag,PrtDr,TPrtActStus,TStasType,TStasTypeDesc)
	s ^CacheTemp(repid,ind)=Data
	
	s ind=ind+1
	q
}

ClassMethod QueryPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" { Set AtEnd=1 Set Row=""}
 Else      { Set Row=^CacheTemp(repid,ind) }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Creator：JinS1010
/// CreatDate：2023/03/16
/// Description: 根据患者统筹区号和院区，判断病人的参保类型为：1，市医保，2省本级，3，省异地
/// Input：InsuCenterID（参保地区），ClrType(清算类别代码),InsuTpye,HospId
/// Output：参保类型代码 ：1，市医保，2省本级，3，省异地
/// Others：w ##class(web.DHCINSUEprUl).GetPatCenterTpye("360111","99903","00A","2") 
ClassMethod GetPatCenterTpye(InsuCenterID As %String, ClrType As %String, InsuTpye As %String, HospId As %String) As %String
{
	s $zt="GetPatCenterTpyeEx"
	q:InsuCenterID="" "-1"
	q:InsuTpye="" "-1"
	q:HospId="" "-1"
	q:ClrType="" "-1"
	s HospInsuCenterNo= ##class(web.DHCINSUPort).GetDicByCodeAndInd("HISPROPerty"_InsuTpye,"InsuCenterNo",4,HospId)
	s Hospclrtype= ##class(web.DHCINSUPort).GetDicByCodeAndInd("clr_type"_InsuTpye,ClrType,"4",HospId)  ;获取清算类别
	s PatCenterTpye=""
	i ($e(InsuCenterID,1,4)=$e(HospInsuCenterNo,1,4))    d
	.s PatCenterTpye = "1"
	e                                                    d
	.s PatCenterTpye = "2"
	i Hospclrtype["省"                                   d
	.s PatCenterTpye = "3"
	q PatCenterTpye
GetPatCenterTpyeEx
     s $zt=""
     q "-1^"_$ze
}

/// 获取已编目就诊列表数据
ClassMethod GetEpisodeListFromIMPR(HospId, DateFrom, DateTo) As %ArrayOfDataTypes
{
	 s $zt="GetEpisodeListEx"
	 s ErrMsg=""
     s EpiAry=##class(MA.IPMR.IO.OutService).GetEpisodeList(HospId,3,7,"","","","","",DateFrom,DateTo,"",.ErrMsg)
     q EpiAry
GetEpisodeListEx
     s $zt=""
     q "-1^"_$ze
}

/// 获取病历提交就诊列表数据
/// 调用病历组接口：##Class(EMRservice.BL.BLAdmRecordStatus).GetEpisodeIDByDateFromARStatus("2022-01-01","2022-04-28")
ClassMethod GetEpisodeListFromEMR(DateFrom, DateTo, HospId = "") As %ArrayOfDataTypes
{
	 s $zt="GetEpisodeListFromEMREx"
	 s ErrMsg=""
	 s EMRAdmAry =##Class(EMRservice.BL.BLAdmRecordStatus).GetEpisodeIDByDateFromARStatus(DateFrom,DateTo)
	 q EMRAdmAry
GetEpisodeListFromEMREx
     s $zt=""
     q "-1^"_$ze
}

/// 保存清单上传记录主表
/// w ##class(web.DHCINSUEprUl).SaveEprUl(1,1809501,898760,"123","456")
/// 操作员id，就诊表id,结算表id,清单接口入参串，清单接口返回串（没用）
/// w ##class(web.DHCINSUEprUl).SaveEprUl($lg(^Temp("SaveEprUl",2576),1),$lg(^Temp("SaveEprUl",2576),2),$lg(^Temp("SaveEprUl",2576),3),$lg(^Temp("SaveEprUl",2576),4),$lg(^Temp("SaveEprUl",2576),5),$lg(^Temp("SaveEprUl",2576),6))
ClassMethod SaveEprUl(userdr, admdr, divdr, inargs, outargs, backStr) As %String
{
	s ^Temp("SaveEprUl",admdr)=$lb(userdr, admdr, divdr, inargs, outargs, backStr)
	s PatID=+^PAADM(admdr)
	s AdmInfo=$$GetAdmInfoByAdmID^DHCINSUPatInfo(admdr)
	s HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(admdr) //+ DingSH 20200526
	s PatInfo=$$GetPatInfoByPatID^DHCINSUPatInfo(PatID,HospDr)
	s TPatName=$p(PatInfo,"^",3)			;姓名	
	s TMedcasNo=$p(AdmInfo,"^",27)
	s TAdmReason=$p(AdmInfo,"^",29)		;费别
	s TDepDesc=$p(AdmInfo,"^",5)			;科室
	s DivInfo=$g(^DHCINDIV(divdr))
	s AdmInfoDr=$p(DivInfo,"^",2)
	s TInsuNo=$p(^DHCINADM(AdmInfoDr),"^",2)	;医保卡号	
	s TBillDr=$p(DivInfo,"^",3)		;
	s TInsuZylsh=$p(DivInfo,"^",30)		;医保登记流水号
	s TInsuDjlsh=$p(DivInfo,"^",8)		;医保结算流水号
	s TInsuType=$p(^DHCINADM(AdmInfoDr),"^",18)	;医保类型
	s TAdmDate=$zdh($p(AdmInfo,"^",6),3)			;入院日期
	s TOutDate=""
	s:$p(AdmInfo,"^",10)'="" TOutDate=$zdh($p(AdmInfo,"^",10),3)		;出院日期
	s TDisDate=$p(DivInfo,"^",16)				;结算日期	
	s TPatType=$p(^DHCINADM(AdmInfoDr),"^",4) ;险种（病人类型）
	s TOptDate=+$h							;上传日期
	s TOptTime=$p($h,",",2)
	s TOptFlag=$P(backStr,"^",2)
	s:TOptFlag="" TOptFlag="Y"
	s TListId=""		;清单id
	s InPutData=inargs
	s OutPutData=outargs
	s TEMRDate="",TIPMRDate=""
	s FrontpageInfo =##class(MA.IPMR.IO.OutService).GetFrontpageInfo(admdr,"")  //1^编目日期^编目时间^编码员
    i +FrontpageInfo=1 d
    .s TIPMRDate=$P(FrontpageInfo,"^",2)
    s EMRStusInfo=##Class(EMRservice.BL.BLAdmRecordStatus).GetAdmRecordStatusInfoByEpisodeID(admdr)
    .i +EMRStusInfo=1 d
    ..s TEMRDate=$P($P(EMRStusInfo,"^",2)," ",1)
	s:(TEMRDate'="")&&(TEMRDate["-") TEMRDate=$zdh(TEMRDate,3)		     	;病历提交日期 // DingSH 20220427 
	s:(TIPMRDate'="")&&(TIPMRDate["-") TIPMRDate=$zdh(TIPMRDate,3)		 	;病案编目日期 // DingSH 20220427 
	s InString="^"_PatID_"^"_admdr_"^"_divdr_"^"_TMedcasNo_"^"_TInsuNo_"^"_TInsuZylsh_"^"_TInsuDjlsh_"^"_TInsuType_"^"_TAdmDate
	s InString=InString_"^"_TOutDate_"^"_TDisDate_"^"_userdr_"^"_TOptDate_"^"_TOptTime_"^"_TOptFlag_"^"_TPatType
	s InString=InString_"^"_TListId_"^"_InPutData_"^"_OutPutData_"^^^^^"_"^"_TEMRDate_"^"_TIPMRDate
	s flag=$$Save^DHCINSUEprUl(InString)
	//i flag>0 d
	//.s ^DHCINEULi(flag)=inargs
	//不需要在这里保存数据 DingSH 20220428 
	q flag
}

/// 删除清单上传记录主表
/// w ##class(web.DHCINSUEprUl).DelectEprUl(1)
/// INSU_EprUL表id，
ClassMethod DelectEprUl(rowid) As %String
{
	q "-1^不允许删除" //？？
	&SQL(DELETE INSU_EprUL WHERE INEUL_Rowid =:rowid)
	q SQLCODE
}

/// s ^DHCINEULi(17)="{""settlementId"":""清单流水号"",""type"":""业务类型"",""userName"":""用户名"",""passWord"":""用户码"",""name"":""姓名"",""personCode"":""个人/医保编号"",""sex"":""性别"",""birthDay"":""出生日期"",""ageYear"":""年龄（岁）"",""nationality"":""国籍"",""ageDay"":""年龄（天）"",""nation"":""民族"",""idType"":""证件类别"",""cardNo"":""证件号码"",""vocation"":""职业"",""addressNow"":""现住址"",""unitName"":""工作单位名称"",""unitAddress"":""工作单位地址"",""unitPhone"":""单位电话"",""postCode"":""邮编"",""contactName"":""联系人姓名"",""relationship"":""与患者关系"",""contactAddress"":""联系人地址"",""contactPhone"":""联系人电话"",""insuredAreaId"":""参保地编码"",""insuredType"":""医保类型"",""personType"":""特殊人员类型"",""newbornInType"":""新生儿入院类型"",""newbornWeight"":""新生儿出生体重"",""newbornInWeight"":""新生儿入院体重"",""illnessCategory"":""诊断科别"",""medicalTime"":""就诊日期"",""hospName"":""医疗机构名称"",""hospCode"":""医疗机构编码"",""compenLevel"":""医保结算等级"",""medicalRecordNo"":""病案号"",""applyTime"":""申报时间"",""medicalCategory"":""住院医疗类型"",""inWay"":""入院途径"",""medicalType"":""治疗类别"",""inHospTime"":""入院时间"",""inHospCategory"":""入院科别"",""transCategory"":""转科科别"",""outHospTime"":""出院时间"",""outHospCategory"":""出院科别"",""inHospDays"":""实际住院天数"",""icdName"":""门（急）诊诊断（西医诊断）"",""icdCode"":""西医疾病代码"",""icdNameCh"":""门（急）诊诊断（中医诊断）"",""icdCodeCh"":""中医疾病代码"",""icdCount"":""诊断代码计数"",""operationCount"":""手术及操作代码计数"",""ventilatorUseTime"":""呼吸机使用时间"",""headInjuryComaBefore"":""颅脑损伤患者昏迷时间（入院前）"",""headInjuryComaAfter"":""颅脑损伤患者昏迷时间（入院后）"",""transfuseVarieties"":""输血品种"",""transfuseVolume"":""输血量"",""transfuseUnit"":""输血计量单位"",""nursingDaysSpecial"":""特级护理天数"",""nursingDaysOne"":""一级护理天数"",""nursingDaysTwo"":""二级护理天数"",""nursingDaysThree"":""三级护理天数"",""outHospWay"":""离院方式"",""transToHospName"":""拟接收机构名称"",""transToHospCode"":""拟接收机构代码"",""inHospAgainPlan"":""是否有出院31天内再住院计划"",""inHospAgainObj"":""是否有出院31天内再住院计划目的"",""attendingDoctorName"":""主诊医师姓名"",""attendingDoctorCode"":""主诊医师代码"",""medicalId"":""就诊ID"",""compenId"":""结算ID"",""bizSerialNumber"":""业务流水号"",""billCode"":""票据代码"",""billNumber"":""票据号码"",""compenStartDate"":""结算期间开始时间"",""compenEndDate"":""结算期间结束时间"",""hospFillingDept"":""医疗机构填报部门"",""hospFillingCreator"":""医疗机构填报人"",""codeCreator"":""编码员"",""miPayType"":""医保支付方式"",""groupSerial"":""入组编号"",""data1"":[{""settlementId"":""清单id"",""medicalId"":""登记流水号"",""compenId"":""结算Id"",""icdName"":""诊断名称1"",""icdCode"":""诊断代码1"",""operationName"":""手术及操作名称1"",""operationCode"":""手术及操作代码1"",""illnessCategory"":""诊科别1"",""medicalTime"":""就诊日期1""},{""settlementId"":""清单id"",""medicalId"":""登记流水号"",""compenId"":""结算Id"",""icdName"":""诊断名称2"",""icdCode"":""诊断代码2"",""operationName"":""手术及操作名称2"",""operationCode"":""手术及操作代码2"",""illnessCategory"":""诊断科别2"",""medicalTime"":""就诊日期2""}],""data2"":[{""settlementId"":""清单id"",""medicalId"":""登记流水号"",""compenId"":""结算Id"",""icdType"":""诊断类别1"",""icdName"":""诊断名称1"",""icdCode"":""诊断编码1"",""inHospIllness"":""入院病情1"",""type"":""中西医1"",""serial"":""诊断序号1""},{""settlementId"":""清单id"",""medicalId"":""登记流水号"",""compenId"":""结算Id"",""icdType"":""诊断类别2"",""icdName"":""诊断名称2"",""icdCode"":""诊断编码2"",""inHospIllness"":""入院病情2"",""type"":""中西医2"",""serial"":""诊断序号2""}],""data3"":[{""settlementId"":""清单id"",""medicalId"":""登记流水号"",""compenId"":""结算Id"",""operationName"":""手术及操作名称1"",""operationCode"":""手术及操作代码1"",""operationLevel"":""手术级别"",""operationDate"":""手术及操作日期1"",""narcosisWay"":""麻醉方式1"",""optDoctorName"":""术者医师姓名1"",""optDoctorCode"":""术者医师代码1"",""nrcDoctorName"":""麻醉医师姓名1"",""nrcDoctorCode"":""麻醉医师代码1"",""operationType"":""手术操作类别1"",""serial"":""手术操作序号1""},{""settlementId"":""清单id"",""medicalId"":""登记流水号"",""compenId"":""结算Id"",""operationName"":""手术及操作名称2"",""operationCode"":""手术及操作代码2"",""operationLevel"":""手术级别"",""operationDate"":""手术及操作日期2"",""narcosisWay"":""麻醉方式2"",""optDoctorName"":""术者医师姓名2"",""optDoctorCode"":""术者医师代码2"",""nrcDoctorName"":""麻醉医师姓名2"",""nrcDoctorCode"":""麻醉医师代码2"",""operationType"":""手术操作类别2"",""serial"":""手术操作序号2""}],""data4"":[{""settlementId"":""清单id"",""medicalId"":""登记流水号"",""compenId"":""结算Id"",""intensiveCareType"":""重症监护病房类型1"",""intensiveCareInTime"":""进重症监护室时间1"",""intensiveCareOutTime"":""出重症监护室时间1"",""totalTime"":""重症监护合计时长1""},{""settlementId"":""清单id"",""medicalId"":""登记流水号"",""compenId"":""结算Id"",""intensiveCareType"":""重症监护病房类型2"",""intensiveCareInTime"":""进重症监护室时间2"",""intensiveCareOutTime"":""出重症监护室时间2"",""totalTime"":""重症监护合计时长2""}],""data5"":[{""settlementId"":""清单id"",""medicalId"":""登记流水号"",""compenId"":""结算Id"",""feeType"":""医疗收费项目类别1"",""amount"":""金额1"",""amountCassA"":""甲类1"",""amountCassB"":""乙类1"",""amountPersonal"":""自费1"",""amountOther"":""其他1""},{""settlementId"":""清单id"",""medicalId"":""登记流水号"",""compenId"":""结算Id"",""feeType"":""医疗收费项目类别2"",""amount"":""金额2"",""amountCassA"":""甲类2"",""amountCassB"":""乙类2"",""amountPersonal"":""自费2"",""amountOther"":""其他2""}],""data6"":[{""settlementId"":""清单id"",""medicalId"":""登记流水号"",""compenId"":""结算Id"",""actualFee"":""医保统筹基金支付"",""otherPay"":""其他支付"",""siiPay"":""大病保险支付"",""maPay"":""医疗救助支付"",""csmaPay"":""公务员医疗补助"",""largePay"":""大额补充"",""unitPay"":""企业补充"",""personalPay"":""个人自付"",""personalExpenses"":""个人自费"",""personalPayAccount"":""个人账户支付"",""personalPayCash"":""个人现金支付""}]}"
/// s ^DHCINEULi(17)="{""settlementId"":""清单流水号"",""type"":""业务类型"",""userName"":""用户名"",""passWord"":""用户码"",""name"":""姓名"",""personCode"":""个人/医保编号"",""sex"":""性别"",""birthDay"":""出生日期"",""ageYear"":""年龄（岁）"",""nationality"":""国籍"",""ageDay"":""年龄（天）"",""nation"":""民族"",""idType"":""证件类别"",""cardNo"":""证件号码"",""vocation"":""职业"",""addressNow"":""现住址"",""unitName"":""工作单位名称"",""unitAddress"":""工作单位地址"",""unitPhone"":""单位电话"",""postCode"":""邮编"",""contactName"":""联系人姓名"",""relationship"":""与患者关系"",""contactAddress"":""联系人地址"",""contactPhone"":""联系人电话"",""insuredAreaId"":""参保地编码"",""insuredType"":""医保类型"",""personType"":""特殊人员类型"",""newbornInType"":""新生儿入院类型"",""newbornWeight"":""新生儿出生体重"",""newbornInWeight"":""新生儿入院体重"",""illnessCategory"":""诊断科别"",""medicalTime"":""就诊日期"",""hospName"":""医疗机构名称"",""hospCode"":""医疗机构编码"",""compenLevel"":""医保结算等级"",""medicalRecordNo"":""病案号"",""applyTime"":""申报时间"",""medicalCategory"":""住院医疗类型"",""inWay"":""入院途径"",""medicalType"":""治疗类别"",""inHospTime"":""入院时间"",""inHospCategory"":""入院科别"",""transCategory"":""转科科别"",""outHospTime"":""出院时间"",""outHospCategory"":""出院科别"",""inHospDays"":""实际住院天数"",""icdName"":""门（急）诊诊断（西医诊断）"",""icdCode"":""西医疾病代码"",""icdNameCh"":""门（急）诊诊断（中医诊断）"",""icdCodeCh"":""中医疾病代码"",""icdCount"":""诊断代码计数"",""operationCount"":""手术及操作代码计数"",""ventilatorUseTime"":""呼吸机使用时间"",""headInjuryComaBefore"":""颅脑损伤患者昏迷时间（入院前）"",""headInjuryComaAfter"":""颅脑损伤患者昏迷时间（入院后）"",""transfuseVarieties"":""输血品种"",""transfuseVolume"":""输血量"",""transfuseUnit"":""输血计量单位"",""nursingDaysSpecial"":""特级护理天数"",""nursingDaysOne"":""一级护理天数"",""nursingDaysTwo"":""二级护理天数"",""nursingDaysThree"":""三级护理天数"",""outHospWay"":""离院方式"",""transToHospName"":""拟接收机构名称"",""transToHospCode"":""拟接收机构代码"",""inHospAgainPlan"":""是否有出院31天内再住院计划"",""inHospAgainObj"":""是否有出院31天内再住院计划目的"",""attendingDoctorName"":""主诊医师姓名"",""attendingDoctorCode"":""主诊医师代码"",""medicalId"":""就诊ID"",""compenId"":""结算ID"",""bizSerialNumber"":""业务流水号"",""billCode"":""票据代码"",""billNumber"":""票据号码"",""compenStartDate"":""结算期间开始时间"",""compenEndDate"":""结算期间结束时间"",""hospFillingDept"":""医疗机构填报部门"",""hospFillingCreator"":""医疗机构填报人"",""codeCreator"":""编码员"",""miPayType"":""医保支付方式"",""groupSerial"":""入组编号""}"
/// s ^DHCINEULi(1)="{""infno"":""4101"",""msgid"":""H4690050019720210408171009323"",""insuplc_admdvs"":""469005"",""mdtrtarea_admvs"":""460000"",""recer_sys_code"":""DHCC"",""cainfo"":"""",""dev_no"":"""",""dev_safe_info"":"""",""signtype"":""SM3"",""infver"":""V1.0"",""opter_type"":""1"",""opter"":""5"",""opter_name"":""cashier"",""inf_time"":""2021-04-08 17:10:09"",""fixmedins_code"":""H46900500197"",""fixmedins_name"":""文昌市人民医院"",""sign_no"":""90007"",""input"":{""setlinfo"":{""mdtrt_id"":""2020050203878291"",""setl_id"":""2020050603691932"",""fixmedins_name"":"""",""fixmedins_code"":"""",""hi_setl_lv"":""3"",""hi_no"":""3501096965"",""medcasno"":""*0000128390*"",""dcla_time"":""20210408171013"",""psn_name"":""冯所政"",""gend"":""1"",""brdy"":""19681213"",""age"":""51"",""ntly"":""CHN"",""nwb_age"":"""",""naty"":""01"",""patn_cert_type"":""01"",""certno"":""460022196812131710"",""prfs"":""90"",""curr_addr"":""460000469005"",""emp_name"":""文"",""emp_addr"":""文昌市罐头厂"",""emp_tel"":""13322007687"",""poscode"":""571300"",""coner_name"":""林海梅"",""patn_rlts"":""10"",""coner_addr"":""文昌市罐头厂"",""coner_tel"":""13976950636"",""hi_type"":""320"",""insuplc"":""469005"",""sp_psn_type"":"""",""nwb_adm_type"":"""",""nwb_bir_wt"":""0"",""nwb_adm_wt"":""0"",""opsp_diag_caty"":"""",""opsp_mdtrt_date"":"""",""ipt_med_type"":""1"",""adm_way"":""2"",""trt_type"":""1"",""adm_time"":""2020050200"",""adm_caty"":""A03.02"",""refldept_dept"":"""",""dscg_time"":""2020050200"",""dscg_caty"":""A03.02"",""act_ipt_days"":""1"",""otp_wm_dise"":""上消化道出血"",""wm_dise_code"":""K92.208"",""otp_tcm_dise"":"""",""tcm_dise_code"":"""",""diag_code_cnt"":""3"",""oprn_oprt_code_cnt"":""0"",""vent_used_dura"":"""",""pwcry_bfadm_coma_du"":""—/—/—"",""pwcry_afadm_coma_du"":""—/—/—"",""bld_cat"":"""",""bld_amt"":"""",""bld_unt"":"""",""spga_nurscare_days"":""0"",""lv1_nurscare_days"":""0"",""scd_nurscare_days"":""0"",""lv3_nurscare_days"":""0"",""dscg_way"":""2"",""acp_medins_name"":""海南省人民医院"",""acp_optins_code"":"""",""bill_code"":""0000138005"",""bill_no"":""0000138005"",""biz_sn"":""185755650608245"",""days_rinp_flag_31"":""1"",""days_rinp_pup_31"":""-"",""chfpdr_name"":""林崖"",""chfpdr_code"":""82015"",""setl_begn_date"":""20200502"",""setl_end_date"":""20200506"",""psn_selfpay"":""1003.88"",""psn_ownpay"":""32.76"",""acct_pay"":""0"",""psn_cashpay"":""1034.7"",""hi_paymtd"":""9"",""hsorg"":""-"",""hsorg_opter"":""-"",""medins_fill_dept"":""医保科"",""medins_fill_psn"":""潘阿妮""},""diseinfo"":[{""maindiag_flag"":""1"",""diag_type"":""1"",""diag_code"":""K74.617+I98.3*"",""diag_name"":""肝硬化伴食管胃底静脉曲张破裂出血"",""adm_cond_type"":""1""},{""maindiag_flag"":""0"",""diag_type"":""2"",""diag_code"":""E11.900"",""diag_name"":""2型糖尿病"",""adm_cond_type"":""1""},{""maindiag_flag"":""0"",""diag_type"":""2"",""diag_code"":""K92.208"",""diag_name"":""上消化道出血"",""adm_cond_type"":""4""}],""payinfo"":[{""fund_pay_type"":""390100"",""fund_payamt"":""1034.7""}],""iteminfo"":[{""med_chrgitm"":""1"",""amt"":""30"",""claa_sumfee"":""27"",""clab_amt"":""0"",""fulamt_ownpay_amt"":""3"",""oth_amt"":""0""},{""med_chrgitm"":""4"",""amt"":""895.6"",""claa_sumfee"":""895.6"",""clab_amt"":""0"",""fulamt_ownpay_amt"":""0"",""oth_amt"":""0""},{""med_chrgitm"":""5"",""amt"":""101.9"",""claa_sumfee"":""101.9"",""clab_amt"":""0"",""fulamt_ownpay_amt"":""0"",""oth_amt"":""0""},{""med_chrgitm"":""7"",""amt"":""28.5"",""claa_sumfee"":""28.5"",""clab_amt"":""0"",""fulamt_ownpay_amt"":""0"",""oth_amt"":""0""},{""med_chrgitm"":""8"",""amt"":""57.95"",""claa_sumfee"":""43.99"",""clab_amt"":""0"",""fulamt_ownpay_amt"":""13.96"",""oth_amt"":""0""},{""med_chrgitm"":""9"",""amt"":""905.19"",""claa_sumfee"":""131.13"",""clab_amt"":""774.06"",""fulamt_ownpay_amt"":""0"",""oth_amt"":""0""},{""med_chrgitm"":""14"",""amt"":""15.8"",""claa_sumfee"":""0"",""clab_amt"":""0"",""fulamt_ownpay_amt"":""15.8"",""oth_amt"":""0""}]}}"
/// s ^DHCINEULi(1)="{""cainfo"":"""",""dev_no"":"""",""dev_safe_info"":"""",""fixmedins_code"":""H44060600189"",""fixmedins_name"":""广州中医药大学顺德医院（佛山市顺德区中医院）"",""inf_time"":""2021-06-02 16:55:35"",""infno"":4101,""infver"":""V1.0"",""input"":{""diseinfo"":[{""adm_cond_type"":1,""diag_code"":""I84.400"",""diag_name"":""外痔伴有其他并发症"",""diag_type"":1,""maindiag_flag"":1},{""adm_cond_type"":1,""diag_code"":""K62.816"",""diag_name"":""肛乳头肥大"",""diag_type"":2,""maindiag_flag"":""0""},{""adm_cond_type"":1,""diag_code"":""B02.05.04.02.06"",""diag_name"":""湿热下注证"",""diag_type"":4,""maindiag_flag"":""0""},{""adm_cond_type"":1,""diag_code"":""A08.03.01."",""diag_name"":""痔疮"",""diag_type"":3,""maindiag_flag"":""0""}],""icuinfo"":[],""iteminfo"":[{""amt"":5432.92,""claa_sumfee"":""0"",""clab_amt"":""0"",""fulamt_ownpay_amt"":""0"",""med_chrgitm"":14,""oth_amt"":5432.92}],""oprninfo"":[{""anst_dr_code"":""欧楚君"",""anst_dr_name"":""欧楚君"",""anst_way"":6,""oper_dr_code"":3787,""oper_dr_name"":""郑富强"",""oprn_oprt_code"":49.4601,""oprn_oprt_date"":""2021-05-14"",""oprn_oprt_name"":""痔切除术伴肛门成形术"",""oprn_oprt_type"":1},{""anst_dr_code"":"""",""anst_dr_name"":"""",""anst_way"":"""",""oper_dr_code"":3301,""oper_dr_name"":""吕杰升"",""oprn_oprt_code"":""17.9500x005"",""oprn_oprt_date"":""2021-05-14"",""oprn_oprt_name"":""穴位贴敷治疗"",""oprn_oprt_type"":""0""},{""anst_dr_code"":""欧楚君"",""anst_dr_name"":""欧楚君"",""anst_way"":6,""oper_dr_code"":3787,""oper_dr_name"":""郑富强"",""oprn_oprt_code"":49.3906,""oprn_oprt_date"":""2021-05-14"",""oprn_oprt_name"":""肛乳头切除术"",""oprn_oprt_type"":""0""}],""opspdiseinfo"":[],""payinfo"":[{""fund_pay_type"":310100,""fund_payamt"":3346.27}],""setlinfo"":{""acct_pay"":""0"",""acp_medins_name"":"""",""acp_optins_code"":"""",""act_ipt_days"":2,""adm_caty"":""肛肠科"",""adm_time"":""2021-05-13 08:15:00"",""adm_way"":"""",""age"":30,""bill_code"":15713503,""bill_no"":15713503,""biz_sn"":25916473,""bld_amt"":""0"",""bld_cat"":"""",""bld_unt"":"""",""brdy"":""1990-05-14"",""certno"":440681199005142045,""chfpdr_code"":1583,""chfpdr_name"":""吴瑞云"",""coner_addr"":""广东省佛山市顺德区伦教街道仕版奋扬路一街5号"",""coner_name"":""卢子强"",""coner_tel"":13726340957,""curr_addr"":""440606002广东省佛山市顺德区伦教街道仕版奋扬路一街5号"",""days_rinp_flag_31"":1,""days_rinp_pup_31"":"""",""dcla_time"":""2021-05-25 08:15:26"",""diag_code_cnt"":3,""dscg_caty"":""肛肠科"",""dscg_time"":""2021-05-15 11:45:00"",""dscg_way"":2,""emp_addr"":"""",""emp_name"":"""",""emp_tel"":"""",""fixmedins_code"":"""",""fixmedins_name"":""广州中医药大学顺德医院"",""gend"":2,""hi_no"":44060000000300180337,""hi_paymtd"":3,""hi_setl_lv"":3,""hi_type"":310,""hsorg"":"""",""hsorg_opter"":""demo"",""insuplc"":1101,""ipt_med_type"":1,""lv1_nurscare_days"":1,""lv3_nurscare_days"":""0"",""mdtrt_id"":28355614,""medcasno"":""*275676*"",""medins_fill_dept"":""Demo Group"",""medins_fill_psn"":""demo"",""naty"":""汉族"",""ntly"":""中国"",""nwb_adm_type"":"""",""nwb_adm_wt"":"""",""nwb_age"":""0"",""nwb_bir_wt"":"""",""oprn_oprt_code_cnt"":2,""opsp_diag_caty"":"""",""opsp_mdtrt_date"":"""",""otp_tcm_dise"":"""",""otp_wm_dise"":""外痔"",""patn_cert_type"":""01"",""patn_rlts"":""配偶"",""poscode"":"""",""prfs"":90,""psn_cashpay"":2086.65,""psn_name"":""梁丽珍"",""psn_ownpay"":96.6,""psn_selfpay"":171.53,""pwcry_afadm_coma_dura"":"""",""pwcry_bfadm_coma_dura"":"""",""refldept_dept"":"""",""scd_nurscare_days"":1,""setl_begn_date"":""2021-05-13"",""setl_end_date"":""2021-05-16"",""setl_id"":25916473,""sp_psn_type"":"""",""spga_nurscare_days"":""0"",""tcm_dise_code"":"""",""trt_type"":2,""vent_used_dura"":"""",""wm_dise_code"":""I84.500x001""}},""insuplc_admdvs"":440600,""mdtrtarea_admvs"":440600,""msgid"":""H4406060018920210602165535892"",""opter"":""demo"",""opter_name"":""Demo Group"",""opter_type"":1,""recer_sys_code"":""DHCC"",""sign_no"":"""",""signtype"":""""}"
/// w ##class(web.DHCINSUEprUl).Getinargs(17)
ClassMethod Getinargs(id) As %String
{
	q:id="" "-1"
	//s outStr=$g(^DHCINEULi(id))		
	s UlSRowid=$P(^DHCINEUL(id),"^",18)
	s InData=""
	i +UlSRowid>0 d
    .s InData=$g(^User.INSUEprUlS(UlSRowid,1))
	s outStr=$zcvt($SYSTEM.Encryption.Base64Decode(InData),"I","UTF8") 
	q outStr
}

///  w ##class(web.DHCINSUEprUl).GetEprStr(58)
///  w ##class(web.DHCINSUEprUl).GetEprStr("13","","4101A")
///  医保结算清单预览
ClassMethod GetEprStr(DivDr, EId = "", Infno = "") As %String
{
	s $zt="GetErpStrEx"
	k ^temp("GetEprStr")
	s ^temp("GetEprStr")=$lb(DivDr, EId , Infno )
	s EprObj=..GetEprJObj(DivDr,EId,Infno)
	q:'$IsObject(EprObj) EprObj
	s EprData=EprObj.ToJSON()
	q EprData
	
GetErpStrEx
 s $zt=""
 q "-1^"_$ze
}

///  医保结算清单预览JSON OBJ
ClassMethod GetEprJObj(DivDr, EId = "", Infno = "", Node = "")
{
	s $zt="GetEprJObjEx"
	k ^temp("GetEprJObj")
	s ^temp("GetEprJObj")=$lb(DivDr, EId , Infno,Node="")
	//q ^DHCINEULi(1) ;测试
	q:$g(DivDr)=""&&($g(EId)="") "-1^DivDr或EId不能都为空"
	s EprData=""    //结算清单信息
	s InPutData="",OutPutData="",AdmDr="",InsuType="",HospDr=""
	i ($g(DivDr)'=""&&($g(EId)="")) d
	.s EId=$O(^DHCINEULi("DivDr",DivDr,""),-1)
	.s OptFlag=""
	.i +EId>0 d
	..s OptFlag=$P(^DHCINEUL(EId),"^",15)
	.i OptFlag'="Y" d
	..s EId=""
	if +EId> 0 d 
	.s InUlSRowid=$P(^DHCINEUL(EId),"^",18)
	.s tmpInPutData=""
	.i +InUlSRowid>0 d
    ..s tmpInPutData=$g(^User.INSUEprUlS(InUlSRowid,1))
	..s InPutData=$zcvt($SYSTEM.Encryption.Base64Decode(tmpInPutData),"I","UTF8") 
	.s OptFlag=$P(^DHCINEUL(EId),"^",15)
	.i OptFlag="Y" d  //已上传成功的
	..s InsuType=$P(^DHCINEUL(EId),"^",8)
	..s DivDr=$P(^DHCINEUL(EId),"^",3)
	..s AdmDr=$P(^DHCINEUL(EId),"^",2)
	..s OutUlSRowid=$P(^DHCINEUL(EId),"^",19)
	..s tmpOutPutData=""
	..b ;out
	..i +OutUlSRowid>0 d
    ...s tmpOutPutData=$g(^User.INSUEprUlS(OutUlSRowid,1))
	...s OutPutData=$zcvt($SYSTEM.Encryption.Base64Decode(tmpOutPutData),"I","UTF8") 
	e  d
	.i Infno="" d
	..s Infno="4101"
	.s AdmDr=$p(^DHCINDIV(DivDr),"^",1)
	.s InAdmDr=$p(^DHCINDIV(DivDr),"^",2)
	.i InAdmDr>0 d 
	..s InsuType=$P(^DHCINADM(InAdmDr),"^",18)
	.s AdmType=$P(^PAADM(AdmDr),"^",2)
	.s:AdmType'="I" Infno=$P(Infno,"-",1)_"-OP"
	.s InPutDataS=##class(INSU.OFFBIZ.BL.BIZ00A).InsuSettlementUL(InsuType_"^"_Infno_"^2^1^0^^1^"_AdmDr_"^"_DivDr,"STR","JSON")
	.s:$IsObject($g(InPutDataS)) InPutData=InPutDataS.Read()
	
	s:+AdmDr>0 HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) 
	//组织结算清单需要的json串
	s EprData=InPutData
	s InputObj="",OutputObj="",EprObj=""
	i InPutData'="" d
	.s InputObj=##class(INSU.Utils.COM.Object).FromJSON(InPutData)
	.s EprObj=##class(INSU.Utils.COM.Object).FromJSON(InPutData)
	i OutPutData'="" d
	.s OutputObj=##class(INSU.Utils.COM.Object).FromJSON(OutPutData)
		
	i $IsObject(EprObj)&&($IsObject(EprObj.input))
	{
	  s tmpInfno=EprObj."infno"
	  b ;eprobj
	  //结算信息（节点标识：setlinfo） 补充、格式化处理
	  s setlinfo=..GetSetlinfo(tmpInfno,EprObj.input.setlinfo,OutputObj,DivDr,InsuType,HospDr)
	  s EprObj.input."setlinfo" =setlinfo
	 
	  //收费项目信息（节点标识：iteminfo） 补充、格式化处理
	  s iteminfo =..GetIteminfo(tmpInfno,EprObj.input.iteminfo,DivDr,InsuType,HospDr)
	  s EprObj.input."iteminfo"=iteminfo
	  
	  //补充 setlinfo 项目分类汇总信息
	  s setlinfo=..GetSetlinfoExt(tmpInfno,EprObj.input.setlinfo,EprObj.input.iteminfo,DivDr,InsuType,HospDr)
	  s EprObj.input."setlinfo" =setlinfo
	   
	  //基金支付信息（节点标识：payinfo） 补充、格式化处理
	  s payinfo =..GetPayinfo(tmpInfno,EprObj.input.payinfo,DivDr,InsuType,HospDr)
	  s EprObj.input."payinfo"=payinfo
	  
	  // 门诊慢特病诊断信息（节点标识：opspdiseinfo）补充、格式化处理
	  s opspdiseinfo =..GetOpspdiseinfo(tmpInfno,EprObj.input.opspdiseinfo,DivDr,InsuType,HospDr)
	  s EprObj.input."opspdiseinfo"=opspdiseinfo
	  
	  //输血信息（节点标识： bldinfo） 补充、格式化处理
	  s bldinfo =..GetBldinfo(tmpInfno,EprObj.input.bldinfo,EprObj.input.setlinfo,DivDr,InsuType,HospDr)
	  s EprObj.input."bldinfo"=bldinfo
	  
	  //诊断信息（节点标识：diseinfo） 补充、格式化处理
	  s diseinfo =..GetDiseinfo(tmpInfno,EprObj.input.diseinfo,DivDr,InsuType,HospDr)
	  s EprObj.input."diseinfo"=diseinfo
	  
	  //手术信息（节点标识：oprninfo） 补充、格式化处理
	  s oprninfo =..GetOprninfo(tmpInfno,EprObj.input.oprninfo,DivDr,InsuType,HospDr)
	  s EprObj.input."oprninfo"=oprninfo
	  
	  //重症监护信息（节点标识：icuinfo） 补充、格式化处理
	  s icuinfo =..GetIcuinfo(tmpInfno,EprObj.input.icuinfo,DivDr,InsuType,HospDr)
	  s EprObj.input."icuinfo"=icuinfo
	
	}
	s rtnObj=""
	i Node'="" d
	.s rtnObj=EprObj.input.Get(Node)
	e  d
	.s rtnObj=EprObj
	q rtnObj
GetEprJObjEx
 s $zt=""
 q "-1^"_$ze
}

/// 获取结算节点信息
/// 4101(4101A) 结算信息（节点标识：setlinfo）
/// w ##class(web.DHCINSUEprUl).GetIteminfo(13)
ClassMethod GetSetlinfo(Infno, setlinfo, OutputObj, InDivDr, InsuType, HospDr)
{
	
	//结算信息（节点标识：setlinfo） 补充、格式化处理
	  s currAddr=setlinfo."curr_addr" ;江西省/南昌市/东湖区/现住址c's"
	  //s currAddr 的格式"江西省/南昌市/东湖区/现住址c's"
	  s setlinfo."curr_addr_province" = $P(currAddr,"/",1)
	  s setlinfo."curr_addr_city"= $P(currAddr,"/",2)
	  s setlinfo."curr_addr_county"= $P(currAddr,"/",3)
	  s setlinfo."curr_addr_detail"= $P(currAddr,"/",4)
	  s setlinfo."setl_list_id"=""  ;清单流水号
	  if ($IsObject(OutputObj)&&($IsObject(OutputObj.output))) d
	  .s setlinfo."setl_list_id"=OutputObj.output."setl_list_id"
	  //???hi_type	医保类型	字符型	3	Y	Y	参照字典MDCS_TYPE
	  s hiType=setlinfo."hi_type"
	  s setlinfo."hi_type_desc"=hiType
	  s tmpVal=##class(web.INSUDicDataCom).GetDicByCodeAndInd("insutype"_InsuType,hiType,4,HospDr)  //?? insutypemdcs_typecon00A
	  s:tmpVal'="" setlinfo."hi_type_desc"=tmpVal
	  
	  s dscgWay=setlinfo."dscg_way" //离院方式
	  s acpMedinsName= setlinfo."acp_medins_name"	;拟接收机构名称
	  s setlinfo."acp_medins_name_2"=acpMedinsName
	  s setlinfo."acp_medins_name_3"=""
	  i +dscgWay=3 d
	  .s setlinfo."acp_medins_name_3"=acpMedinsName
	  .s setlinfo."acp_medins_name_2"=""

	  //vent_used_dura	呼吸机使用时长 格式：天数/小时数/分钟数 例：1/13/24
	  s ventUsedDura=""
	  s ventUsedDura=setlinfo."vent_used_dura"  ;
	  s:ventUsedDura="" ventUsedDura="///"
	  s setlinfo."vent_used_dura_day"=$P(ventUsedDura,"/",1)
	  s setlinfo."vent_used_dura_hour"=$P(ventUsedDura,"/",2)
	  s setlinfo."vent_used_dura_min"=$P(ventUsedDura,"/",3)  
	 // pwcry_bfadm_coma_dura	颅脑损伤患者入院前昏迷时长	格式：天数/小时数/分钟数例：1/13/24
	  s pwcryBfadmComaDura=""
	  s pwcryBfadmComaDura=setlinfo."pwcry_bfadm_coma_dura"  ;
	  s:pwcryBfadmComaDura="" pwcryBfadmComaDura="///"
	  s setlinfo."pwcry_bfadm_coma_dura_day"=$P(pwcryBfadmComaDura,"/",1)
	  s setlinfo."pwcry_bfadm_coma_dura_hour"=$P(pwcryBfadmComaDura,"/",2)
	  s setlinfo."pwcry_bfadm_coma_dura_min"=$P(pwcryBfadmComaDura,"/",3)  
      //pwcry_afadm_coma_dura	颅脑损伤患者入院后昏迷时长	格式：天数/小时数/分钟数 例：1/13/24
	  s pwcryAfadmComaDura=""
	  s pwcryAfadmComaDura=setlinfo."pwcry_afadm_coma_dura"  ;
	  s:pwcryAfadmComaDura="" pwcryAfadmComaDura="///"
	  s setlinfo."pwcry_afadm_coma_dura_day"=$P(pwcryAfadmComaDura,"/",1)
	  s setlinfo."pwcry_afadm_coma_dura_hour"=$P(pwcryAfadmComaDura,"/",2)
	  s setlinfo."pwcry_afadm_coma_dura_min"=$P(pwcryAfadmComaDura,"/",3)  
	  i +InDivDr>0 d
	  .s setlinfo."fund_pay_sumamt"=$p(^DHCINDIV(InDivDr),"^",19)   // fund_pay_sumamt	基金支付总额	数值型	16,2		Y
	  .s setlinfo."hifp_pay"=$p(^DHCINDIV(InDivDr),"^",31)          // hifp_pay	基本医疗保险统筹基金支出	数值型	16,2
	  .s setlinfo."hifob_pay"=$p(^DHCINDIV(InDivDr),"^",32)         // hifob_pay	职工大额医疗费用补助基金支出	数值型	16,2
	  .s setlinfo."hifmi_pay"=$p(^DHCINDIV(InDivDr),"^",46)         // hifmi_pay	居民大病保险资金支出	数值型	16,2
	  .s setlinfo."cvlserv_pay"=$p(^DHCINDIV(InDivDr),"^",33)       // cvlserv_pay	公务员医疗补助资金支出	数值型	16,2
	  .s setlinfo."maf_pay"=$p(^DHCINDIV(InDivDr),"^",34)           // maf_pay	医疗救助基金支出	数值型	16,2
	  .s setlinfo."oth_pay"=$p(^DHCINDIV(InDivDr),"^",47)           // oth_pay	其他支出	数值型	16,2
	  .s setlinfo."hifes_pay"=$p(^DHCINDIV(InDivDr),"^",35)         // hifes_pay	企业补充医疗保险基金支出	数值型	16,2
	  .s setlinfo."psn_cashpay"=$p(^DHCINDIV(InDivDr),"^",15) 
	q setlinfo
}

/// 获取结算节点扩展信息
/// 4101(4101A) 结算信息（节点标识：setlinfo）
/// w ##class(web.DHCINSUEprUl).GetIteminfo(13)
ClassMethod GetSetlinfoExt(Infno, setlinfo, iteminfo, InDivDr, InsuType, HospDr)
{
	    
	  s (amtTotal,claaSumfeeTotal,clabAmtTotal,fulamtOwnpayAmtTotal,othAmtTotal)=0
	  f itmIdx=0:1:iteminfo.Size()-1
	  {
		  s medChrgitm=iteminfo.Get(itmIdx)."med_chrgitm"
		  s iteminfo.Get(itmIdx)."med_chrgitm_desc"=medChrgitm
		  s tmpVal=##class(web.INSUDicDataCom).GetDicByCodeAndInd("med_chrgitm_type"_InsuType,medChrgitm,4,HospDr)
		  s:tmpVal'="" iteminfo.Get(itmIdx)."med_chrgitm_desc"=tmpVal
	      s amtTotal=amtTotal+iteminfo.Get(itmIdx)."amt"
	      s claaSumfeeTotal=claaSumfeeTotal+iteminfo.Get(itmIdx)."claa_sumfee"
	      s clabAmtTotal=clabAmtTotal+iteminfo.Get(itmIdx)."clab_amt"
	      s fulamtOwnpayAmtTotal=fulamtOwnpayAmtTotal+iteminfo.Get(itmIdx)."fulamt_ownpay_amt"
	      s othAmtTotal=othAmtTotal+iteminfo.Get(itmIdx)."oth_amt"
	  }
	  s setlinfo."amt_total"=amtTotal
	  s setlinfo."claa_sumfee_total"=claaSumfeeTotal
	  s setlinfo."clab_amt_total"=clabAmtTotal
	  s setlinfo."fulamt_ownpay_amt_total"=fulamtOwnpayAmtTotal
	  s setlinfo."oth_amt_total"=othAmtTotal
	
	q setlinfo
}

/// 获取收费项目节点信息
/// 4101(4101A) iteminfo 节点 
/// w ##class(web.DHCINSUEprUl).GetIteminfo(13)
ClassMethod GetIteminfo(Infno, iteminfo, InDivDr, InsuType, HospDr)
{
	
	i (Infno="4101A"){
	Set rset=##class(%ResultSet).%New("INSU.BL.Interface.DataRpUp:PatFeeItemInfoQuery")
	do rset.Execute("","",InDivDr) 
	s iteminfo=##class(INSU.Utils.COM.Array).%New()
	While (rset.Next()) {
		s item=##class(INSU.Utils.COM.Object).%New()	
		s item."med_chrgitm"=rset.GetDataByName("med_chrgitm")	
		s item."amt"=rset.GetDataByName("amt")
		s item."claa_sumfee"=rset.GetDataByName("claa_sumfee")
		s item."clab_amt"=rset.GetDataByName("clab_amt")
		s item."fulamt_ownpay_amt"=rset.GetDataByName("fulamt_ownpay_amt")
		s item."oth_am"=rset.GetDataByName("oth_am")
		d iteminfo.Insert(item)
	 }
  }
  //iteminfo 数据格式化
  
  
  q iteminfo
}

/// 获取基金支付节点信息
/// 4101 基金支付信息（payinfo） 节点 
/// w ##class(web.DHCINSUEprUl).GetPayinfo(13)
ClassMethod GetPayinfo(Infno, payinfo, InDivDr, InsuType, HospDr)
{
	if (Infno="4101A"){
	Set rset=##class(%ResultSet).%New("INSU.BL.Interface.DataRpUp:PatPayInfoQuery")
	do rset.Execute("","",InDivDr) 
	s payinfo=##class(INSU.Utils.COM.Array).%New()
	While (rset.Next()) {
		s pay=##class(INSU.Utils.COM.Object).%New()	
		s pay."med_chrgitm"=rset.GetDataByName("fund_pay_type")	
		s pay."amt"=rset.GetDataByName("fund_payamt")
		d payinfo.Insert(pay)
	  }
	}
	//..payinfo 数据格式化
	  s PayLen=0
	  i $IsObject(payinfo){
		  s PayLen=payinfo.Size()
		   }
	  f payIdx=0:1:PayLen-1
	  {
		 s fundPayType=payinfo.Get(payIdx)."fund_pay_type"
		 s payinfo.Get(payIdx)."oth_pay_flag"="1" ;//是否【其他基金支付】分项标识
		 // 如下是不属于【其他基金支付】分项情况（注意，每个项目开发需要确认修改）
		 //   城乡居民基本医疗保险基金 390100，城乡居民大病医疗保险基金390200，
		 //   城镇职工基本医疗保险统筹基金 310100，城镇职工基本医疗保险个人账户基金 310200
		 //   公务员医疗补助基金 320100
		 i (fundPayType="310100")||(fundPayType="310200") ||(fundPayType="320100")||(fundPayType="390100")||(fundPayType="390200")
		 {
			 s payinfo.Get(payIdx)."oth_pay_flag"="0"
		 }
		  s payinfo.Get(payIdx)."fund_pay"=fundPayType
		  s tmpVal=##class(web.INSUDicDataCom).GetDicByCodeAndInd("fund_pay_type"_InsuType,fundPayType,4,HospDr)
		  s:tmpVal'="" payinfo.Get(payIdx)."fund_pay"=tmpVal
	  }
	
	q payinfo
}

/// 获取门诊慢特病诊断节点信息（补充,格式化等）
/// 4101(4101A) opspdiseinfo 节点 
/// w ##class(web.DHCINSUEprUl).GetOpspdiseinfo(13)
ClassMethod GetOpspdiseinfo(Infno, opspdiseinfo, InDivDr, InsuType, HospDr)
{
	
	
  //opspdiseinfo 数据格式化...
  
  q opspdiseinfo
}

/// 获取诊断节点信息（补充,格式化等）
/// 4101(4101A) diseinfo 节点 
/// w ##class(web.DHCINSUEprUl).GetDiseinfo(13)
ClassMethod GetDiseinfo(Infno, diseinfo, InDivDr, InsuType, HospDr)
{
	
	
  //diseinfo 数据格式化...
  
  q diseinfo
}

/// 获取手术节点信息（补充,格式化等）
/// 4101(4101A) oprninfo 节点 
/// w ##class(web.DHCINSUEprUl).GetOprninfo(13)
ClassMethod GetOprninfo(Infno, oprninfo, InDivDr, InsuType, HospDr)
{
	
	
  //oprninfo 数据格式化...
  
  q oprninfo
}

/// 获取重症监护节点信息（补充,格式化等）
/// 4101(4101A) icuinfo 节点 
/// w ##class(web.DHCINSUEprUl).GetIcuinfo(13)
ClassMethod GetIcuinfo(Infno, icuinfo, InDivDr, InsuType, HospDr)
{
	
	
  //icuinfo 数据格式化...
  
  q icuinfo
}

/// 获取输血节点信息（补充,格式化等）
/// 4101(4101A) 输血信息（节点标识：bldinfo）
ClassMethod GetBldinfo(Infno, bldinfo, setlinfo, InDivDr, InsuType, HospDr)
{
	i (Infno="4101"){
		   s bldinfo = ##class(INSU.Utils.COM.Array).%New()
		   s bldCatStr=setlinfo."bld_cat"
		   s bldAmtStr=setlinfo."bld_amt"
		   s bldUntStr=setlinfo."bld_unt"
		   s bldCnt=$l(bldCatStr,"/")
		   f bldIdx=1:1:bldCnt {
		   s bldsub=##class(INSU.Utils.COM.Object).%New()
		   s bldsub."bld_cat"=$P(bldCatStr,"/",bldIdx)
		   s bldsub."bld_amt"=$P(bldAmtStr,"/",bldIdx)
		   s bldsub."bld_unt"=$P(bldUntStr,"/",bldIdx)
		   d bldinfo.Insert(bldsub)
		   }
	
	}
	//bldinfo 数据格式...
	
	
	q bldinfo
}

/// w ##class(web.DHCINSUEprUl).GetErpiInargInfo("2163047",1)
ClassMethod GetErpiInargInfo(DivDr As %String, UploadId As %String) As %String
{
	;q ^DHCINEULi(1) ;测试
	q:(DivDr="")&&(UploadId="") "-1^结算ID和上传ID不能都为空"
	i UploadId="" {
		s AdmDr=$p(^DHCINDIV(DivDr),"^",1)
		q:$d(^DHCINEUL("DivDr",DivDr))=0 "-1^未找到对应的上传记录"	
		s:UploadId="" UploadId=$o(^DHCINEUL("DivDr",DivDr,""),-1)
	}
	q:UploadId="" "-1^未找到对应的上传记录"	
	;s outStr=$p(^DHCINEUL(UploadId),"^",18)
	//s outStr=^DHCINEULi(UploadId)  //注释掉 20220428 
	s UlSRowid=$P(^DHCINEUL(UploadId),"^",18)
	b ;000
	s InData=""
	i +UlSRowid>0 d
    .s InData=$g(^User.INSUEprUlS(UlSRowid,1))
	s outStr=$zcvt($SYSTEM.Encryption.Base64Decode(InData),"I","UTF8") 
	q outStr
}

/// w ##class(web.DHCINSUEprUl).GetErpiOutargInfo("",2)
ClassMethod GetErpiOutargInfo(DivDr As %String, UploadId As %String) As %String
{
	;q ^DHCINEULi(1) ;测试
	s OutData=""
	q:(DivDr="")&&(UploadId="") "-1^结算ID和上传ID不能都为空"
	i UploadId="" {
		s AdmDr=$p(^DHCINDIV(DivDr),"^",1)
		q:$d(^DHCINEUL("DivDr",DivDr))=0 "-1^未找到对应的上传记录"	
		s:UploadId="" UploadId=$o(^DHCINEUL("DivDr",DivDr,""),-1)
	}
	q:UploadId="" "-1^未找到对应的上传记录"	

	s UlSRowid=$P(^DHCINEUL(UploadId),"^",19)
	b ;000
	i +UlSRowid>0 d
    .s OutData=$g(^User.INSUEprUlS(UlSRowid,1))
	s OutData=$zcvt($SYSTEM.Encryption.Base64Decode(OutData),"I","UTF8") 
	q OutData
}

/// 查询医疗保障基金结算清单信息(4101,4101a)--结算清单信息（节点标识setlinfo）
/// d ##class(%ResultSet).RunQuery("web.DHCINSUEprUl","QrySetlinfoForBill","","1","") 
Query QrySetlinfoForBill(DivDr As %String, EId As %String, Infno As %String) As websys.Query(ROWSPEC = "mdtrt_id:%String,setl_id:%String,fixmedins_name:%String,fixmedins_code:%String,hi_setl_lv:%String,hi_no:%String,medcasno:%String,dcla_time:%String,psn_name:%String,gend:%String,brdy:%String,age:%String,ntly:%String,nwb_age:%String,naty:%String,patn_cert_type:%String,certno:%String,prfs:%String,curr_addr:%String,emp_name:%String,emp_addr:%String,emp_tel:%String,poscode:%String,coner_name:%String,patn_rlts:%String,coner_addr:%String,coner_tel:%String,hi_type:%String,insuplc:%String,sp_psn_type:%String,nwb_adm_type:%String,nwb_bir_wt:%String,nwb_adm_wt:%String,opsp_diag_caty:%String,opsp_mdtrt_date:%String,ipt_med_type:%String,adm_way:%String,trt_type:%String,adm_time:%String,adm_caty:%String,refldept_dept:%String,dscg_time:%String,dscg_caty:%String,act_ipt_days:%String,otp_wm_dise:%String,wm_dise_code:%String,otp_tcm_dise:%String,tcm_dise_code:%String,diag_code_cnt:%String,oprn_oprt_code_cnt:%String,vent_used_dura:%String,pwcry_bfadm_coma_dura:%String,pwcry_afadm_coma_dura:%String,bld_cat:%String,bld_amt:%String,bld_unt:%String,spga_nurscare_days:%String,lv1_nurscare_days:%String,scd_nurscare_days:%String,lv3_nurscare_days:%String,dscg_way:%String,acp_medins_name:%String,acp_optins_code:%String,bill_code:%String,bill_no:%String,biz_sn:%String,days_rinp_flag_31:%String,days_rinp_pup_31:%String,chfpdr_name:%String,chfpdr_code:%String,setl_begn_date:%String,setl_end_date:%String,psn_selfpay:%String,psn_ownpay:%String,acct_pay:%String,psn_cashpay:%String,hi_paymtd:%String,hsorg:%String,hsorg_opter:%String,medins_fill_dept:%String,medins_fill_psn:%String,fund_pay_sumamt:%Double,hifp_pay:%Double,hifob_pay:%Double,hifmi_pay:%Double,cvlserv_pay:%Double,maf_pay:%Double,oth_pay:%Double,hifes_pay:%Double,setl_list_id:%String,hi_type_desc:%String,curr_addr_province:%String,curr_addr_city:%String,curr_addr_county:%String,curr_addr_detail:%String,acp_medins_name_2:%String,acp_medins_name_3:%String,vent_used_dura_day:%String,vent_used_dura_hour:%String,vent_used_dura_min:%String,pwcry_bfadm_coma_dura_day:%String, pwcry_bfadm_coma_dura_hour:%String,pwcry_bfadm_coma_dura_min:%String,pwcry_afadm_coma_dura_day:%String,pwcry_afadm_coma_dura_hour:%String,pwcry_afadm_coma_dura_min:%String") [ SqlProc ]
{
}

ClassMethod QrySetlinfoForBillExecute(ByRef qHandle As %Binary, DivDr As %String, EId As %String, Infno As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (DivDr="")&&(EId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    //ExpDataAry获取部分参数示例
    s (mdtrtid,setlid,fixmedinsname,fixmedinscode,hisetllv,hino,medcasno,dclatime,psnname,gend,brdy,age,ntly,nwbage,naty,patncerttype,certno,prfs,curraddr,empname,empaddr,emptel,poscode,conername,patnrlts,coneraddr,conertel,hitype,insuplc,sppsntype,nwbadmtype,nwbbirwt,nwbadmwt,opspdiagcaty,opspmdtrtdate,iptmedtype,admway,trttype,admtime,admcaty,refldeptdept,dscgtime,dscgcaty,actiptdays,otpwmdise,wmdisecode,otptcmdise,tcmdisecode,diagcodecnt,oprnoprtcodecnt,ventuseddura,pwcrybfadmcomadura,pwcryafadmcomadura,bldcat,bldamt,bldunt,spganurscaredays,lv1nurscaredays,scdnurscaredays,lv3nurscaredays,dscgway,acpmedinsname,acpoptinscode,billcode,billno,bizsn,daysrinpflag31,daysrinppup31,chfpdrname,chfpdrcode,setlbegndate,setlenddate,psnselfpay,psnownpay,acctpay,psncashpay,hipaymtd,hsorg,hsorgopter,medinsfilldept,medinsfillpsn)=""
    #Dim setlinfo As INSU.Utils.COM.Object
    s setlinfo=##class(web.DHCINSUEprUl).GetEprJObj(DivDr,EId,Infno,"setlinfo")
    i '$IsObject(setlinfo) Set qHandle=$lb(0,repid,0) Quit $$$OK
	s mdtrtid = setlinfo."mdtrt_id"
	s setlid = setlinfo."setl_id"
	s fixmedinsname = setlinfo."fixmedins_name"
	s fixmedinscode = setlinfo."fixmedins_code"
	s hisetllv = setlinfo."hi_setl_lv"
	s hino = setlinfo."hi_no"
	s medcasno = setlinfo."medcasno"
	s dclatime = setlinfo."dcla_time"
	s psnname = setlinfo."psn_name"
	s gend = setlinfo."gend"
	s brdy = setlinfo."brdy"
	s age = setlinfo."age"
	s ntly = setlinfo."ntly"
	s nwbage = setlinfo."nwb_age"
	s naty = setlinfo."naty"
	s patncerttype = setlinfo."patn_cert_type"
	s certno = setlinfo."certno"
	s prfs = setlinfo."prfs"
	s curraddr = setlinfo."curr_addr"
	s empname = setlinfo."emp_name"
	s empaddr = setlinfo."emp_addr"
	s emptel = setlinfo."emp_tel"
	s poscode = setlinfo."poscode"
	s conername = setlinfo."coner_name"
	s patnrlts = setlinfo."patn_rlts"
	s coneraddr = setlinfo."coner_addr"
	s conertel = setlinfo."coner_tel"
	s hitype = setlinfo."hi_type"
	s insuplc = setlinfo."insuplc"
	s sppsntype = setlinfo."sp_psn_type"
	s nwbadmtype = setlinfo."nwb_adm_type"
	s nwbbirwt = setlinfo."nwb_bir_wt"
	s nwbadmwt = setlinfo."nwb_adm_wt"
	s opspdiagcaty = setlinfo."opsp_diag_caty"
	s opspmdtrtdate = setlinfo."opsp_mdtrt_date"
	s iptmedtype = setlinfo."ipt_med_type"
	s admway = setlinfo."adm_way"
	s trttype = setlinfo."trt_type"
	s admtime = setlinfo."adm_time"
	s admcaty = setlinfo."adm_caty"
	s refldeptdept = setlinfo."refldept_dept"
	s dscgtime = setlinfo."dscg_time"
	s dscgcaty = setlinfo."dscg_caty"
	s actiptdays = setlinfo."act_ipt_days"
	s otpwmdise = setlinfo."otp_wm_dise"
	s wmdisecode = setlinfo."wm_dise_code"
	s otptcmdise = setlinfo."otp_tcm_dise"
	s tcmdisecode = setlinfo."tcm_dise_code"
	s diagcodecnt = setlinfo."diag_code_cnt"
	s oprnoprtcodecnt = setlinfo."oprn_oprt_code_cnt"
	s ventuseddura = setlinfo."vent_used_dura"
	s pwcrybfadmcomadura = setlinfo."pwcry_bfadm_coma_dura"
	s pwcryafadmcomadura = setlinfo."pwcry_afadm_coma_dura"
	s bldcat = setlinfo."bld_cat"
	s bldamt = setlinfo."bld_amt"
	s bldunt = setlinfo."bld_unt"
	s spganurscaredays = setlinfo."spga_nurscare_days"
	s lv1nurscaredays = setlinfo."lv1_nurscare_days"
	s scdnurscaredays = setlinfo."scd_nurscare_days"
	s lv3nurscaredays = setlinfo."lv3_nurscare_days"
	s dscgway = setlinfo."dscg_way"
	s acpmedinsname = setlinfo."acp_medins_name"
	s acpoptinscode = setlinfo."acp_optins_code"
	s billcode = setlinfo."bill_code"
	s billno = setlinfo."bill_no"
	s bizsn = setlinfo."biz_sn"
	s daysrinpflag31 = setlinfo."days_rinp_flag_31"
	s daysrinppup31 = setlinfo."days_rinp_pup_31"
	s chfpdrname = setlinfo."chfpdr_name"
	s chfpdrcode = setlinfo."chfpdr_code"
	s setlbegndate = setlinfo."setl_begn_date"
	s setlenddate = setlinfo."setl_end_date"
	s psnselfpay = setlinfo."psn_selfpay"
	s psnownpay = setlinfo."psn_ownpay"
	s acctpay = setlinfo."acct_pay"
	s psncashpay = setlinfo."psn_cashpay"
	s hipaymtd = setlinfo."hi_paymtd"
	s hsorg = setlinfo."hsorg"
	s hsorgopter = setlinfo."hsorg_opter"
	s medinsfilldept = setlinfo."medins_fill_dept"
	s medinsfillpsn = setlinfo."medins_fill_psn"
	s (fundpaysumamt,hifppay,hifobpay,hifmipay,cvlservpay,mafpay,othpay,hifespay)=0
	
	s fundpaysumamt = setlinfo."fund_pay_sumamt"   // fund_pay_sumamt	基金支付总额	数值型	16,2		Y
	s hifppay = setlinfo."hifp_pay"         // hifp_pay	基本医疗保险统筹基金支出	数值型	16,2
	s hifobpay  = setlinfo."hifob_pay"         // hifob_pay	职工大额医疗费用补助基金支出	数值型	16,2
	s hifmipay  = setlinfo."hifmi_pay"        // hifmi_pay	居民大病保险资金支出	数值型	16,2
	s cvlservpay  = setlinfo."cvlserv_pay"       // cvlserv_pay	公务员医疗补助资金支出	数值型	16,2
	s mafpay   = setlinfo."maf_pay"         // maf_pay	医疗救助基金支出	数值型	16,2
	s othpay   = setlinfo."oth_pay"          // oth_pay	其他支出	数值型	16,2
	s hifespay = setlinfo."hifes_pay"         // hifes_pay	企业补充医疗保险基金支出
	s (setllistid,hitypedesc,curraddrprovince,curraddrcity,curraddrcounty,curraddrdetail,acpmedinsname2,acpmedinsname3,ventusedduraday,ventuseddurahour,ventusedduramin,pwcrybfadmcomaduraday,pwcrybfadmcomadurahour,pwcrybfadmcomaduramin,pwcryafadmcomaduraday,pwcryafadmcomadurahour,pwcryafadmcomaduramin)=""
	
	
	s setllistid=setlinfo."setl_list_id"
	s hitypedesc = setlinfo."hi_type_desc"
	s curraddrprovince = setlinfo."curr_addr_province" 
	s curraddrcity = setlinfo."curr_addr_city"
	s curraddrcounty = setlinfo."curr_addr_county"
	s curraddrdetail = setlinfo."curr_addr_detail"
	s acpmedinsname2 = setlinfo."acp_medins_name_2"
	s acpmedinsname3 =  setlinfo."acp_medins_name_3"
	s ventusedduraday = setlinfo."vent_used_dura_day"
	s ventuseddurahour = setlinfo."vent_used_dura_hour"
	s ventusedduramin = setlinfo."vent_used_dura_min" 
	s pwcrybfadmcomaduraday = setlinfo."pwcry_bfadm_coma_dura_day"
	s pwcrybfadmcomadurahour = setlinfo."pwcry_bfadm_coma_dura_hour"
	s pwcrybfadmcomaduramin = setlinfo."pwcry_bfadm_coma_dura_min"
	s pwcryafadmcomaduraday = setlinfo."pwcry_afadm_coma_dura_day"
	s pwcryafadmcomadurahour=setlinfo."pwcry_afadm_coma_dura_hour"
	s pwcryafadmcomaduramin=setlinfo."pwcry_afadm_coma_dura_min"
    d BuildSetlinfo
	Quit $$$OK
BuildSetlinfo	
	set Data=$lb(mdtrtid,setlid,fixmedinsname,fixmedinscode,hisetllv,hino,medcasno,dclatime,psnname,gend,brdy,age,ntly,nwbage,naty,patncerttype,certno,prfs,curraddr,empname,empaddr,emptel,poscode,conername,patnrlts,coneraddr,conertel,hitype,insuplc,sppsntype,nwbadmtype,nwbbirwt,nwbadmwt,opspdiagcaty,opspmdtrtdate,iptmedtype,admway,trttype,admtime,admcaty,refldeptdept,dscgtime,dscgcaty,actiptdays,otpwmdise,wmdisecode,otptcmdise,tcmdisecode,diagcodecnt,oprnoprtcodecnt,ventuseddura,pwcrybfadmcomadura,pwcryafadmcomadura,bldcat,bldamt,bldunt,spganurscaredays,lv1nurscaredays,scdnurscaredays,lv3nurscaredays,dscgway,acpmedinsname,acpoptinscode,billcode,billno,bizsn,daysrinpflag31,daysrinppup31,chfpdrname,chfpdrcode,setlbegndate,setlenddate,psnselfpay,psnownpay,acctpay,psncashpay,hipaymtd,hsorg,hsorgopter,medinsfilldept,medinsfillpsn,fundpaysumamt,hifppay,hifobpay,hifmipay,cvlservpay,mafpay,othpay,hifespay,setllistid,hitypedesc,curraddrprovince,curraddrcity,curraddrcounty,curraddrdetail,acpmedinsname2,acpmedinsname3,ventusedduraday,ventuseddurahour,ventusedduramin,pwcrybfadmcomaduraday,pwcrybfadmcomadurahour,pwcrybfadmcomaduramin,pwcryafadmcomaduraday,pwcryafadmcomadurahour,pwcryafadmcomaduramin)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 查询医疗保障基金结算清单信息(4101,4101a)--门诊慢特病诊断信息（节点标识：opspdiseinfo）
Query QryOpspdiseinfoForBill(DivDr, EId = "", Infno = "") As websys.Query(ROWSPEC = "diag_name:%String,diag_code:%String,oprn_oprt_name:%String,oprn_oprt_code:%String,maindiag_flag:%String") [ SqlProc ]
{
}

ClassMethod QryOpspdiseinfoForBillExecute(ByRef qHandle As %Binary, DivDr, EId = "", Infno = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	if (DivDr="")&&(EId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	//ExpDataAry获取部分参数示例
	s (diagname,diagcode,oprnoprtname,oprnoprtcode,maindiagflag)=""
    #Dim opspdiseinfo As INSU.Utils.COM.Array
    s opspdiseinfo=##class(web.DHCINSUEprUl).GetEprJObj(DivDr,EId,Infno,"opspdiseinfo")
    i '$IsObject(opspdiseinfo) Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	
	s (diagname,diagcode,oprnoprtname,oprnoprtcode,maindiagflag)=""
	f itmIdx=0:1:opspdiseinfo.Size()-1
	 {
	  s diagname=opspdiseinfo.Get(itmIdx)."diag_name"			        ;诊断名称
	  s diagcode=opspdiseinfo.Get(itmIdx)."diag_code"			        ;诊断代码
	  s oprnoprtname=opspdiseinfo.Get(itmIdx)."oprn_oprt_name"		    ;手术操作名称
	  s oprnoprtcode=opspdiseinfo.Get(itmIdx)."oprn_oprt_code"			;手术操作代码
	  s maindiagflag=opspdiseinfo.Get(itmIdx)."maindiag_flag"			;主诊断标志
	  d BuildOpspdiseinfo	
	 }
	
	Quit $$$OK
BuildOpspdiseinfo
	set Data=$lb(diagname,diagcode,oprnoprtname,oprnoprtcode,maindiagflag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 查询医疗保障基金结算清单信息(4101,4101a)--住院诊断信息（节点标识：diseinfo）
/// 基金结清清单报表Query
/// diag_type:诊断类别,diag_code:诊断代码,diag_name:诊断名称,adm_cond_type:入院病情类型,maindiag_flag:主诊断标志
/// d ##class(%ResultSet).RunQuery("web.DHCINSUEprUlHZH","QryDiseinfoForBill","","1","")
Query QryDiseinfoForBill(DivDr, EId = "", Infno = "") As websys.Query(ROWSPEC = "diag_type:%String,diag_code:%String,diag_name:%String,adm_cond_type:%String,maindiag_flag:%String") [ SqlProc ]
{
}

ClassMethod QryDiseinfoForBillExecute(ByRef qHandle As %Binary, DivDr, EId = "", Infno = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (DivDr="")&&(EId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    //ExpDataAry获取部分参数示例
    s (diagtype,diagcode,diagname,admcondtype,maindiagflag)=""
    s fundpayamt=0
    #Dim diseinfo As INSU.Utils.COM.Array
    s diseinfo=##class(web.DHCINSUEprUl).GetEprJObj(DivDr,EId,Infno,"diseinfo")
	i '$IsObject(diseinfo) Set qHandle=$lb(0,repid,0) Quit $$$OK
	f itmIdx=0:1:diseinfo.Size()-1
	{
		s diagtype=diseinfo.Get(itmIdx)."diag_type"
		s diagcode=diseinfo.Get(itmIdx)."diag_code"
		s diagname=diseinfo.Get(itmIdx)."diag_name"
		s admcondtype=diseinfo.Get(itmIdx)."adm_cond_type"
		s maindiagflag=diseinfo.Get(itmIdx)."maindiag_flag"
		d BuildDiseinfo
	}
	
	Quit $$$OK
BuildDiseinfo
	set Data=$lb(diagtype,diagcode,diagname,admcondtype,maindiagflag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 查询医疗保障基金结算清单信息(4101,4101a)--手术操作信息（节点标识：oprninfo）
/// 基金结清清单报表Query
/// oprn_oprt_type:手术操作类别,oprn_oprt_name:手术操作名称,oprn_oprt_code:手术操作代码,oprn_oprt_date:手术操作日期,anst_way:麻醉方式,oper_dr_name:术者医师姓名,oper_dr_code:术者医师代码,anst_dr_name:麻醉医师姓名,anst_dr_code:麻醉医师代码,oprn_oprt_begntime:手术操作开始时间,oprn_oprt_endtime:手术操作结束时间,anst_begntime:麻醉开始时间,anst_endtime:麻醉结束时间
Query QryOprninfoForBill(DivDr, EId = "", Infno = "") As websys.Query(ROWSPEC = "oprn_oprt_type:%String,oprn_oprt_name:%String,oprn_oprt_code:%String,oprn_oprt_date:%String,anst_way:%String,oper_dr_name:%String,oper_dr_code:%String,anst_dr_name:%String,anst_dr_code:%String,oprn_oprt_begntime:%String,oprn_oprt_endtime:%String,anst_begntime:%String,anst_endtime:%String") [ SqlProc ]
{
}

ClassMethod QryOprninfoForBillExecute(ByRef qHandle As %Binary, DivDr, EId = "", Infno = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	if (DivDr="")&&(EId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
    #Dim oprninfo As INSU.Utils.COM.Array
    s oprninfo=##class(web.DHCINSUEprUl).GetEprJObj(DivDr,EId,Infno,"oprninfo")
    i '$IsObject(oprninfo) Set qHandle=$lb(0,repid,0) Quit $$$OK
	s (anstdrcode,anstdrname,anstway,operdrcode,operdrname,oprnoprtcode,oprnoprtdate,oprnoprtname,oprnoprttype)=""
	s (oprnoprtbegntime,oprnoprtendtime,anstbegntime,anstendtime)=""
	f itmIdx=0:1:oprninfo.Size()-1
	 {
	  s oprnoprttype=oprninfo.Get(itmIdx)."oprn_oprt_type"		 
	  s oprnoprtname=oprninfo.Get(itmIdx)."oprn_oprt_name"		;手术名称
	  s oprnoprtcode=oprninfo.Get(itmIdx)."oprn_oprt_code"		;手术编码	 
	  s oprnoprtdate=oprninfo.Get(itmIdx)."oprn_oprt_date"		;手术日期	 
	  s anstway=oprninfo.Get(itmIdx)."anst_way"				    ;麻醉方式
	  s operdrname=oprninfo.Get(itmIdx)."oper_dr_name"			;手术医师名称
	  s operdrcode=oprninfo.Get(itmIdx)."oper_dr_code"			;手术医师编码
	  s anstdrname=oprninfo.Get(itmIdx)."anst_dr_name"			;麻醉医师名字
	  s anstdrcode=oprninfo.Get(itmIdx)."anst_dr_code"			;麻醉医师编码
	  s oprnoprtbegntime=oprninfo.Get(itmIdx)."oprn_oprt_begntime"	
	  s oprnoprtendtime=oprninfo.Get(itmIdx)."oprn_oprt_endtime"	
	  s anstbegntime=oprninfo.Get(itmIdx)."anst_begntime"	
	  s anstendtime=oprninfo.Get(itmIdx)."anst_endtime"	
	  d BuildOprninfo	
	 }
	
	Quit $$$OK
BuildOprninfo	
	set Data=$lb(oprnoprttype ,oprnoprtname,oprnoprtcode,oprnoprtdate,anstway,operdrname,operdrcode,anstdrname,anstdrcode,oprnoprtbegntime,oprnoprtendtime,anstbegntime,anstendtime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 查询医疗保障基金结算清单信息(4101,4101a)--表 193重症监护信息（节点标识：icuinfo）
/// 基金结清清单报表Query
/// scs_cutd_ward_type:重症监护病房类型,scs_cutd_inpool_time:重症监护进入时间,scs_cutd_exit_time:重症监护退出时间
/// d ##class(%ResultSet).RunQuery("web.DHCINSUEprUlHZH","QryIcuinfoForBill","","1","") 
Query QryIcuinfoForBill(DivDr, EId = "", Infno = "") As websys.Query(ROWSPEC = "scs_cutd_ward_type:%String,scs_cutd_inpool_time:%String,scs_cutd_exit_time:%String") [ SqlProc ]
{
}

ClassMethod QryIcuinfoForBillExecute(ByRef qHandle As %Binary, DivDr, EId = "", Infno = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (DivDr="")&&(EId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    //ExpDataAry获取部分参数示例
    s (scscutdwardtype,scscutdinpooltime,scscutdexittime)=""
    #Dim icuinfo As INSU.Utils.COM.Array
    s icuinfo=##class(web.DHCINSUEprUl).GetEprJObj(DivDr,EId,Infno,"icuinfo")
	i '$IsObject(icuinfo) Set qHandle=$lb(0,repid,0) Quit $$$OK
 	f itmIdx=0:1:icuinfo.Size()-1
	{
		s scscutdwardtype=icuinfo.Get(itmIdx)."scs_cutd_ward_type"
		s scscutdinpooltime=icuinfo.Get(itmIdx)."scs_cutd_inpool_time"
		s scscutdexittime=icuinfo.Get(itmIdx)."scs_cutd_exit_time"
		d BuildIcuinfo
	}
	
	Quit $$$OK
BuildIcuinfo	
	set Data=$lb(scscutdwardtype,scscutdinpooltime,scscutdexittime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 查询医疗保障基金结算清单信息(4101a)--输血信息（节点标识：bldinfo）
/// 基金结清清单报表Query
/// bld_cat:输血品种,bld_amt:输血量,bld_unt:输血计量单位
/// d ##class(%ResultSet).RunQuery("web.DHCINSUEprUl","QryBldinfoForBill","","1","") 
Query QryBldinfoForBill(DivDr, EId = "", Infno = "") As websys.Query(ROWSPEC = "bld_cat:%String,bld_amt:%Double,bld_unt:%String") [ SqlProc ]
{
}

ClassMethod QryBldinfoForBillExecute(ByRef qHandle As %Binary, DivDr, EId = "", Infno = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (DivDr="")&&(EId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    //ExpDataAry获取部分参数示例
    s (scscutdwardtype,scscutdinpooltime,scscutdexittime)=""
    #Dim bldinfo As INSU.Utils.COM.Array
    s bldinfo=##class(web.DHCINSUEprUl).GetEprJObj(DivDr,EId,Infno,"bldinfo")
    b ;oooo
	i '$IsObject(bldinfo) Set qHandle=$lb(0,repid,0) Quit $$$OK
 	f itmIdx=0:1:bldinfo.Size()-1
	{
		s bldcat=bldinfo.Get(itmIdx)."bld_cat"
		s bldamt=bldinfo.Get(itmIdx)."bld_amt"
		s bldunt=bldinfo.Get(itmIdx)."bld_unt"
		d BuildBldinfo
	}
	Quit $$$OK
BuildBldinfo	
	set Data=$lb(bldcat,bldamt,bldunt)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 查询医疗保障基金结算清单信息(4101,4101A单据需要此数据)--基金支付信息（节点标识：payinfo）
/// 基金结清清单报表Query
/// fund_pay_type:基金支付类型,fund_payamt:基金支付金额
/// d ##class(%ResultSet).RunQuery("web.DHCINSUEprUlHZH","QryPayinfoForBill","","1","")
Query QryPayinfoForBill(DivDr, EId = "", Infno = "") As websys.Query(ROWSPEC = "fund_pay_type:%String,fund_payamt:%Double") [ SqlProc ]
{
}

ClassMethod QryPayinfoForBillExecute(ByRef qHandle As %Binary, DivDr, EId = "", Infno = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (DivDr="")&&(EId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    //ExpDataAry获取部分参数示例
    s fundpaytype=""
    s fundpayamt=0
    #Dim payinfo As INSU.Utils.COM.Array
    s payinfo=##class(web.DHCINSUEprUl).GetEprJObj(DivDr,EId,Infno,"payinfo")
	i '$IsObject(payinfo) Set qHandle=$lb(0,repid,0) Quit $$$OK
	f itmIdx=0:1:payinfo.Size()-1
	{
		s fundpaytype=payinfo.Get(itmIdx)."fund_pay_type"
		s fundpayamt=+payinfo.Get(itmIdx)."fund_payamt"
		d BuildPayinfo
	}
	
	Quit $$$OK
BuildPayinfo	
	set Data=$lb(fundpaytype,fundpayamt)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 查询医疗保障基金结算清单信息(4101,4101A单据需要此数据)--收费项目信息（节点标识：iteminfo）
/// 基金结清清单报表Query
/// med_chrgitm:医疗收费项目:,amt:金额,claa_sumfee:甲类费用合计,clab_amt:乙类金额,fulamt_ownpay_amt:全自费金额,oth_amt:其他金额
/// d ##class(%ResultSet).RunQuery("web.DHCINSUEprUl","QryIteminfoForBill","","1","") 
Query QryIteminfoForBill(DivDr, EId = "", Infno = "") As websys.Query(ROWSPEC = "med_chrgitm:%String,med_chrgitm_desc:%String,amt:%Float,claa_sumfee:%Float,clab_amt:%Float,fulamt_ownpay_amt:%Float,oth_amt:%Float") [ SqlProc ]
{
}

ClassMethod QryIteminfoForBillExecute(ByRef qHandle As %Binary, DivDr, EId = "", Infno = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	//tro 
	//s ^TMP("QryIteminfoForBill")=$lb(DivDr, EId, Infno)
	i (DivDr="")&&(EId="") Quit $$$OK
    //ExpDataAry获取部分参数示例
    s (medchrgitm,medchrgitmdesc)=""
    s (amt,claasumfee,clabamt,fulamt,ownpayamt,othamt)=0
    #Dim iteminfo As INSU.Utils.COM.Array
    s iteminfo=##class(web.DHCINSUEprUl).GetEprJObj(DivDr,EId,Infno,"iteminfo")
    i '$IsObject(iteminfo) quit $$$OK
	s (amtTotal,claaSumfeeTotal,clabAmtTotal,fulamtOwnpayAmtTotal,othAmtTotal)=0
	f itmIdx=0:1:iteminfo.Size()-1
	 {
		  s medchrgitm=iteminfo.Get(itmIdx)."med_chrgitm"
		  s medchrgitmdesc=iteminfo.Get(itmIdx)."med_chrgitm_desc"
		  s amt=$fn(+iteminfo.Get(itmIdx)."amt","",2)
		  s claasumfee=$fn(+iteminfo.Get(itmIdx)."claa_sumfee","",2)
		  s clabamt=+$fn(iteminfo.Get(itmIdx)."cla_bamt","",2)
		  s fulamtownpayamt=+$fn(iteminfo.Get(itmIdx)."fulamt_ownpay_amt","",2)
		  s othamt=+$fn(iteminfo.Get(itmIdx)."oth_amt","",2)
		  d BuildIteminfo
	  }
	
	Quit $$$OK
BuildIteminfo
	set Data=$lb(medchrgitm,medchrgitmdesc,amt,claasumfee,clabamt,fulamtownpayamt,othamt)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSUEprUl","ReadInsuType")
Query ReadInsuType() As %SQLQuery(CONTAINID = 1)
{
	SELECT INDID_DicCode, INDID_DicDesc  FROM INSU_DicData where INDID_DicType="TariType"
}

/// 将json串转为对象，再解析为global
/// w ##class(web.DHCINSUEprUl).CompareJson("","")
ClassMethod AnalysisJson(JsonStr, Node) As %String
{
	;s JsonStr=^DHCINEULi(1)
	do ##class(ext.util.JsonObject).ParseJSON(JsonStr,"",.ObjA) ;json串转对象
	s keydata=""
	f  s keydata=$o(ObjA.input.%data(keydata)) q:keydata=""  d
	.s Objinput=ObjA.input.%data(keydata)	;对象的一个节点
	.i $IsObject(Objinput) d
	..i Objinput.%IsA("%Library.ListOfObjects") d ;节点是个多维数组
	...s Count=Objinput.Size
	...f i=1:1:Count d
	....s paysubinfo=Objinput.GetAt(i)
	....s keycode=""
	....f  s keycode=$o(paysubinfo.%data(keycode)) q:keycode=""  d
	.....s keyvalueA=paysubinfo.%data(keycode)
	.....s ^TMP($j,Node,keydata,keycode,i)=keyvalueA
	..e  d
	...s keycode="" 
	...f  s keycode=$o(Objinput.%data(keycode)) q:keycode=""  d
	....s keyvalueA=Objinput.%data(keycode)
	....s ^TMP($j,Node,keydata,keycode)=keyvalueA

	q 0
}

/// 将json串转为对象，再解析为global，global对比，生成json串返回
/// w ##class(web.DHCINSUEprUl).CompareJson("")
ClassMethod CompareJson(Eid) As %String
{
	k ^TMP($j)
	;s DivDr=$p(^DHCINEUL(Eid),"^",3)	
	;s JsonA=..GetErpStr(DivDr)	;his中现在的清单串
	;s JsonB=..Getinargs(Eid) ;上传医保的清单串
	s JsonA=^DHCINEULi(111) ;测试
	s JsonB=^DHCINEULi(110) ;测试
	s r=..AnalysisJson(JsonA,"A")
	s r=..AnalysisJson(JsonB,"B")
	;^TMP($j,"B","iteminfo","oth_amt",7)=0
	;^TMP($j,"B","payinfo","fund_pay_type",1)=390100
	s keydata="",num=0,keynum="0"
	f  s keydata=$o(^TMP($j,"A",keydata)) q:keydata=""  d  ;
	.s keycode=""
	.f  s keycode=$o(^TMP($j,"A",keydata,keycode)) q:keycode=""  d
	..i $d(^TMP($j,"A",keydata,keycode))=1 d   ;无下层节点
	...s keyvalueA=^TMP($j,"A",keydata,keycode)
	...i $d(^TMP($j,"B",keydata,keycode))=1 d  ;无下层节点
	....s keyvalueB=^TMP($j,"B",keydata,keycode)
	....i keyvalueA=keyvalueB d  ;2个数据一致
	.....s ^TMP($j,"A",keydata,keycode)=keyvalueA_"^Y"
	.....s ^TMP($j,"B",keydata,keycode)=keyvalueB_"^Y"
	....e  d ;2个数据不一致
	.....s num=num+1
	.....s ^TMP($j,"C",num)=keydata_"^"_keycode_"^"_keynum_"^"_keyvalueA_"^"_keyvalueB_"^"_"change"
	.....s ^TMP($j,"A",keydata,keycode)=keyvalueA_"^Y"
	.....s ^TMP($j,"B",keydata,keycode)=keyvalueB_"^Y"	
	..e  d
	...s keynum=0
	...f  s keynum=$o(^TMP($j,"A",keydata,keycode,keynum)) q:keynum=""  d
	....i $d(^TMP($j,"A",keydata,keycode,keynum))=1 d ;无下层节点
	.....s keyvalueA=^TMP($j,"A",keydata,keycode,keynum)
	.....i $d(^TMP($j,"B",keydata,keycode,keynum))=1 d
	......s keyvalueB=^TMP($j,"B",keydata,keycode,keynum)
	......i keyvalueA=keyvalueB d ;2个数据一致
	.......s ^TMP($j,"A",keydata,keycode,keynum)=keyvalueA_"^Y"
	.......s ^TMP($j,"B",keydata,keycode,keynum)=keyvalueB_"^Y"
	......e  d ;2个数据不一致
	.......s num=num+1
	.......s ^TMP($j,"C",num)=keydata_"^"_keycode_"^"_keynum_"^"_keyvalueA_"^"_keyvalueB_"^"_"change"
	.......s ^TMP($j,"A",keydata,keycode,keynum)=keyvalueA_"^Y"
	.......s ^TMP($j,"B",keydata,keycode,keynum)=keyvalueB_"^Y"
	
	;A数据多的字段
	s keydata="",keynum="0"
	f  s keydata=$o(^TMP($j,"A",keydata)) q:keydata=""  d  ;
	.s keycode=""
	.f  s keycode=$o(^TMP($j,"A",keydata,keycode)) q:keycode=""  d
	..i $d(^TMP($j,"A",keydata,keycode))=1 d   ;无下层节点
	...s keyvalueA=^TMP($j,"A",keydata,keycode)
	...i $p(keyvalueA,"^",2)'="Y" d
	....s num=num+1
	....s ^TMP($j,"C",num)=keydata_"^"_keycode_"^"_keynum_"^"_keyvalueA_"^"_""_"^"_"Aadd"
	..e  d
	...s keynum=0
	...f  s keynum=$o(^TMP($j,"A",keydata,keycode,keynum)) q:keynum=""  d
	....i $d(^TMP($j,"A",keydata,keycode,keynum))=1 d ;无下层节点
	.....s keyvalueA=^TMP($j,"A",keydata,keycode,keynum)
	.....i $p(keyvalueA,"^",2)'="Y" d
	......s num=num+1
	......s ^TMP($j,"C",num)=keydata_"^"_keycode_"^"_keynum_"^"_keyvalueA_"^"_""_"^"_"Aadd"
	
	;B数据多的字段
	s keydata="",keynum="0"
	f  s keydata=$o(^TMP($j,"B",keydata)) q:keydata=""  d  ;
	.s keycode=""
	.f  s keycode=$o(^TMP($j,"B",keydata,keycode)) q:keycode=""  d
	..i $d(^TMP($j,"B",keydata,keycode))=1 d   ;无下层节点
	...s keyvalueB=^TMP($j,"B",keydata,keycode)
	...i $p(keyvalueB,"^",2)'="Y" d
	....s num=num+1
	....s ^TMP($j,"C",num)=keydata_"^"_keycode_"^"_keynum_"^"_""_"^"_keyvalueB_"^"_"Badd"
	..e  d
	...s keynum=0
	...f  s keynum=$o(^TMP($j,"B",keydata,keycode,keynum)) q:keynum=""  d
	....i $d(^TMP($j,"B",keydata,keycode,keynum))=1 d ;无下层节点
	.....s keyvalueB=^TMP($j,"B",keydata,keycode,keynum)
	.....i $p(keyvalueB,"^",2)'="Y" d
	......s num=num+1
	......s ^TMP($j,"C",num)=keydata_"^"_keycode_"^"_keynum_"^"_""_"^"_keyvalueB_"^"_"Badd"
	
	;按照序号排序
	s num=0
	f  s num=$o(^TMP($j,"C",num)) q:num=""  d 
	.s str=^TMP($j,"C",num)
	.s xh=+$p(str,"^",3)
	.s ^TMP($j,"D",xh,num)=str
	
	;^TMP($j,"C",2)="iteminfo^med_chrgitm^4^7^70"
	;^TMP($j,"C",3)="setlinfo^fixmedins_name^^^qq"
	set json=##class(%DynamicObject).%New()	
	set jsonArr=##class(%DynamicArray).%New()
	s x="",total=0
	f  s x=$o(^TMP($j,"D",x)) q:x=""  d
	.s num=""
	.f  s num=$o(^TMP($j,"D",x,num)) q:num=""  d
	..s str=^TMP($j,"D",x,num)
	..s keydata=$p(str,"^",1)
	..s keycode=$p(str,"^",2)
	..s NodeStr=..GetNodeDesc(keydata,keycode) ;获取节点名称
	..s keydatadesc=$p(NodeStr,"^",1)
	..s keycodedesc=$p(NodeStr,"^",2)
	..s xh=$p(str,"^",3)
	..s keyvalueA=$p(str,"^",4)
	..s keyvalueB=$p(str,"^",5)
	..s type=$p(str,"^",6)
	..s:type="change" type="值变化"
	..s:type="Aadd" type="his多字段"
	..s:type="Badd" type="his少字段"
	..;w keydata_"^"_keydatadesc_"^"_keycode_"^"_keycodedesc_"^"_xh_"^"_keyvalueA_"^"_keyvalueB,!
	..s jsonobj=##class(%DynamicObject).%New()	
	..d jsonobj.%Set("keydata",keydata)
	..d jsonobj.%Set("keydatadesc",keydatadesc)
	..d jsonobj.%Set("keycode",keycode)
	..d jsonobj.%Set("keycodedesc",keycodedesc)
	..d jsonobj.%Set("xh",xh)
	..d jsonobj.%Set("keyvalueA",keyvalueA)
	..d jsonobj.%Set("keyvalueB",keyvalueB)
	..d jsonobj.%Set("type",type)
	..d jsonArr.%Push(jsonobj)
	..s total=total+1
	k ^TMP($j)
	s json.rows=jsonArr
	d json.%Set("total",total)
	q json.%ToJSON()
	q 0
}

/// 将json串转为对象，再解析为global，global对比，生成json串返回
/// w ##class(web.DHCINSUEprUl).CompareJson("")
ClassMethod CompareJsonold(Eid) As %String
{
	k ^||TMP
	;s DivDr=$p(^DHCINEUL(Eid),"^",3)
	;s JsonA=..Getinargs(Eid) ;上传医保的清单串
	;s JsonB=..GetErpStr(DivDr)	;his中现在的清单串
	s JsonA=^DHCINEULi(110) ;测试
	s JsonB=^DHCINEULi(111) ;测试	
	s r=..AnalysisJson(JsonA,"A")
	s r=..AnalysisJson(JsonB,"B")
	b
	;^TMP($j,"B","iteminfo","oth_amt",7)=0
	;^TMP($j,"B","payinfo","fund_pay_type",1)=390100
	s keydata="",num=0,keynum="0"
	f  s keydata=$o(^TMP($j,"A",keydata)) q:keydata=""  d  ;
	.s keycode=""
	.f  s keycode=$o(^TMP($j,"A",keydata,keycode)) q:keycode=""  d
	..i $d(^TMP($j,"A",keydata,keycode))=1 d   ;无下层节点
	...s keyvalueA=^TMP($j,"A",keydata,keycode)
	...i $d(^TMP($j,"B",keydata,keycode))=1 d  ;无下层节点
	....s keyvalueB=^TMP($j,"B",keydata,keycode)
	....i keyvalueA'=keyvalueB d  ;2个数据不一致
	.....s num=num+1
	.....s ^TMP($j,"C",num)=keydata_"^"_keycode_"^"_keynum_"^"_keyvalueA_"^"_keyvalueB
	...e  d
	....s num=num+1   ;global无值
	....s ^TMP($j,"C",num)=keydata_"^"_keycode_"^"_keynum_"^"_keyvalueA_"^"_""
	..e  d
	...s keynum="0"
	...f  s keynum=$o(^TMP($j,"A",keydata,keycode,keynum)) q:keynum=""  d
	....i $d(^TMP($j,"A",keydata,keycode,keynum))=1 d ;无下层节点
	.....s keyvalueA=^TMP($j,"A",keydata,keycode,keynum)
	.....i $d(^TMP($j,"B",keydata,keycode,keynum))=1 d
	......s keyvalueB=^TMP($j,"B",keydata,keycode,keynum)
	......i keyvalueA'=keyvalueB d
	.......s num=num+1
	.......s ^TMP($j,"C",num)=keydata_"^"_keycode_"^"_keynum_"^"_keyvalueA_"^"_keyvalueB
	.....e  d
	......s num=num+1
	......s ^TMP($j,"C",num)=keydata_"^"_keycode_"^"_keynum_"^"_keyvalueA_"^"_""
	...;B global数据多
	...i $o(^TMP($j,"A",keydata,keycode,""),-1)<$o(^TMP($j,"B",keydata,keycode,""),-1) d
	....s keynum=$o(^TMP($j,"A",keydata,keycode,""))
	....f  s keynum=$o(^TMP($j,"A",keydata,keycode,keynum)) q:keynum=""  d
	.....s keyvalueB=^TMP($j,"B",keydata,keycode,keynum)
	.....s num=num+1
	.....s ^TMP($j,"C",num)=keydata_"^"_keycode_"^"_keynum_"^"_""_"^"_keyvalueB
	
	s num=0
	f  s num=$o(^TMP($j,"C",num)) q:num=""  d ;按照序号排序
	.s str=^TMP($j,"C",num)
	.s xh=+$p(str,"^",3)
	.s ^TMP($j,"D",xh,num)=str
	
	;^TMP($j,"C",2)="iteminfo^med_chrgitm^4^7^70"
	;^TMP($j,"C",3)="setlinfo^fixmedins_name^^^qq"
	set json=##class(%DynamicObject).%New()	
	set jsonArr=##class(%DynamicArray).%New()
	s x="",total=0
	f  s x=$o(^TMP($j,"D",x)) q:x=""  d
	.s num=""
	.f  s num=$o(^TMP($j,"D",x,num)) q:num=""  d
	..s str=^TMP($j,"D",x,num)
	..s keydata=$p(str,"^",1)
	..s keycode=$p(str,"^",2)
	..s NodeStr=..GetNodeDesc(keydata,keycode) ;获取节点名称
	..s keydatadesc=$p(NodeStr,"^",1)
	..s keycodedesc=$p(NodeStr,"^",2)
	..s xh=$p(str,"^",3)
	..s keyvalueA=$p(str,"^",4)
	..s keyvalueB=$p(str,"^",5)
	..;w keydata_"^"_keydatadesc_"^"_keycode_"^"_keycodedesc_"^"_xh_"^"_keyvalueA_"^"_keyvalueB,!
	..s jsonobj=##class(%DynamicObject).%New()	
	..d jsonobj.%Set("keydata",keydata)
	..d jsonobj.%Set("keydatadesc",keydatadesc)
	..d jsonobj.%Set("keycode",keycode)
	..d jsonobj.%Set("keycodedesc",keycodedesc)
	..d jsonobj.%Set("xh",xh)
	..d jsonobj.%Set("keyvalueA",keyvalueA)
	..d jsonobj.%Set("keyvalueB",keyvalueB)
	..d jsonArr.%Push(jsonobj)
	..s total=total+1
	s json.rows=jsonArr
	d json.%Set("total",total)
	q json.%ToJSON()
	q 0
}

/// 根据节点代码，取节点名称
/// w ##class(web.DHCINSUEprUl).GetNodeDesc("diseinfo","out_icu_time")
ClassMethod GetNodeDesc(NODECODE, ARGCODE) As %String
{
	s NODEDESC="",ARGDESC=""
	s PORTLISTID=$o(^CF.INSU.MI.PORTLISTI("IndexHOSPTYPEHITYPEINFNO",2,0,"00A",4101,""),-1)
	q:PORTLISTID="" ""
	s indexid=""
	f  s indexid=$o(^CF.INSU.MI.PORTNODEI("IndexOfPARIDSEQ",PORTLISTID,indexid)) q:indexid=""  d
	.s PORTNODEId=""
	.f  s PORTNODEId=$o(^CF.INSU.MI.PORTNODEI("IndexOfPARIDSEQ",PORTLISTID,indexid,PORTNODEId)) q:PORTNODEId=""  d
	..s PORTNODEinfo=^CF.INSU.MI.PORTNODED(PORTNODEId)		
	..q:NODECODE'=$lg(PORTNODEinfo,4)	;节点代码
	..s NODEDESC=$lg(PORTNODEinfo,5)	;节点名称
	..s ARGindex=""
	..f  s ARGindex=$o(^CF.INSU.MI.PORTINARGSI("IndexOfPARIDSEQ",PORTNODEId,ARGindex)) q:ARGindex=""  d
	...s ARGCODEId=""
	...s ARGCODEId=$o(^CF.INSU.MI.PORTINARGSI("IndexOfPARIDSEQ",PORTNODEId,ARGindex,""))
	...s ARGCODEInfo=$g(^CF.INSU.MI.PORTINARGSD(ARGCODEId))
	...q:ARGCODE'=$lg(ARGCODEInfo,4)	;参数代码
	...s ARGDESC=$lg(ARGCODEInfo,5)	;参数名称
	
	q NODEDESC_"^"_ARGDESC
}

/// 根据就诊类型及发票Id校验是否有效
/// Y/N
/// w ##class(web.DHCINSUDataUL).CheckPrtActStus("IP","290")
ClassMethod CheckPrtActStus(OptType, PrtDr)
{
	s $zt="CheckPrtActStusEx"
	q:$g(PrtDr)="" ""
	s PrtActStus="N"                   //发票状态
	i (OptType="IP"){
		q:+$d(^DHCINVPRTZY(+PrtDr))=0 ""
		s PrtFlag=$p(^DHCINVPRTZY(PrtDr),"^",8)
	    i ((PrtFlag="N")||(PrtFlag="I"))&&($d(^DHCINVPRTZY(0,"InitInv",PrtDr))=0){
		   s PrtActStus="Y"
		   }
	}
	i (OptType="OP")
	{
		q:+$d(^DHCINVPRT(+PrtDr))=0 ""
	    s PrtFlag=$p(^DHCINVPRT(PrtDr),"^",8)
		i PrtFlag="N"{
		 s PrtActStus="Y"
		}
	}	
   q PrtActStus
CheckPrtActStusEx
 s $zt=""
 q "N"
}

/// 根据UploadIdStr取对应基金结算清单上传信息	4102,4103使用 
/// +20230302 HanZH
/// 入参：
/// 	UploadIdStr： 病案上传信息主表Id串（INSU_EprUl.Rowid串）
/// 出参：
/// 	病案上传信息串$病案上传信息串
/// w ##class(web.DHCINSUEprUl).GetErpiInfoStr("976^975")
ClassMethod GetErpiInfoStr(UploadIdStr As %String) As %String
{
	s OutData=""
	s UploadId=""
	q:(UploadIdStr="") "-1^上传ID不能为空"
	
	f i=1:1:$l(UploadIdStr,"$") d
	.s UploadId=$p(UploadIdStr,"$",i)
	.q:UploadId=""
	.s ErpiInfo = $g(^DHCINEUL(UploadId))
	.if (OutData="") d
	..s OutData=UploadId_"^"_ErpiInfo
	.else  d
	..s OutData=OutData_"$"_UploadId_"^"_ErpiInfo
	q OutData
}

/// 根据INSU_EprUl.Rowid串更新基金结算清单分类状态	4102
/// +20230302 HanZH
/// 入参:
/// 	UploadIdStr：病案上传信息主表Id串（INSU_EprUl.Rowid串）, StasType:分类状态, OptFlag:上传标志
/// 出参：
/// 	总条数^成功条数^失败条数
/// w ##class(web.DHCINSUEprUl).UploadEprStasType("909","1","1","Y")
ClassMethod UploadEprStasType(UserId As %String, UploadIdStr As %String, StasType As %String, OptFlag As %String) As %String
{
	s num=0,errnum=0,ErpiInfoStr=""
	q:(UploadIdStr="") "-1^更新数据不能为空"
	s num=$l(UploadIdStr,"^")
	f i=1:1:num d
	.s UploadId=$p(UploadIdStr,"^",i)
	.s ErpiInfoStr=$g(^DHCINEUL(UploadId))
	.q:ErpiInfoStr=""
	.s ErpiInfoStr=UploadId_"^"_ErpiInfoStr
	.b ;数据格式化
	.d InDataFormat
	.b ;数据格式化2
	.s Flag=$$Save^DHCINSUEprUl(ErpiInfoStr)
	.i +Flag<0	d
	..s errnum = errnum+1
	
	q num_"^"_(num-errnum)_"^"_errnum
 
InDataFormat

	s InputJsonDr=$P(ErpiInfoStr,"^",19)
	i +InputJsonDr>0 d
    .s $P(ErpiInfoStr,"^",19)=$g(^User.INSUEprUlS(InputJsonDr,1))		//入参串
	s OutnputJsonDr=$P(ErpiInfoStr,"^",20)
	i +OutnputJsonDr>0 d
    .s $P(ErpiInfoStr,"^",20)=$g(^User.INSUEprUlS(OutnputJsonDr,1))		//出参串
	s $P(ErpiInfoStr,"^",16)=OptFlag			//上传标志
	s $P(ErpiInfoStr,"^",22)=StasType			//分类状态
	//清单提交	格式化提交人、提交日期、提交时间
	i StasType="1" d
	.s $P(ErpiInfoStr,"^",28)=UserId			//上传人
	.s $P(ErpiInfoStr,"^",29)=+$H				//上传日期
	.s $P(ErpiInfoStr,"^",30)=$P($H,",",2)		//上传时间

	//清单撤销	格式化撤销人、撤销日期、撤销时间
	i StasType="0" d
	.s $P(ErpiInfoStr,"^",31)=UserId			//撤销人
	.s $P(ErpiInfoStr,"^",32)=+$H				//撤销日期
	.s $P(ErpiInfoStr,"^",33)=$P($H,",",2)		//撤销时间
}

}
