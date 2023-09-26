Import SQLUser

/// For DHC EKG Studio System . 2008-12-30, Created by Rocky Lau . 
Class web.DHCEkgService Extends %Library.RegisteredObject
{

/// 改变his检查状态，通过ris还是ens接口
Parameter ChangeStatus = "ens";

/// Creator：		liupeng
/// CreatDate：		2009-06-17
/// Description:	系统参数
Parameter DHCEKGSystemParam = "NBMZ^^^^^^^^^";

/// Creator：		liupeng
/// CreatDate：		2009-06-17
/// Description:	获取系统参数
ClassMethod GetSystemParam() As %String
{
	//w ##class(web.DHCEkgService).GetSystemParam()
	s rtn=..#DHCEKGSystemParam
	Quit rtn
}

/// Creator：		liupeng
/// CreatDate：		2009-06-17
/// Description:	获取版本号
ClassMethod GetDHCEkgVersion() As %String
{
	//w ##class(web.DHCEkgService).GetDHCEkgVersion()
	s DHCEkgVersion=$p(..#DHCEKGSystemParam,"^",1)
	Quit DHCEkgVersion
}

/// Creator：      liupeng
/// CreatDate：    2008-12-30
/// Description:： 按照输入条件查询符合条件的记录
/// Table：        
/// Input：        执行科室id；登记号；起始日期；终止日期
/// Output：       记录
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
/// 2009-03-11	liupeng	增加注释 
ClassMethod GetEKGInfoTxt(LocId As %String, InRegNo As %String, StartDate As %String, Enddate As %String) As %String [ WebMethod ]
{
	// w ##class(web.DHCEkgService).GetEKGInfoTxt(85,"500219^MedCareNo","","")
	// w ##class(web.DHCEkgService).GetEKGInfoTxt(343,"000000000001","","")
	
	set RegNoLength = +##class(web.DHCEkgNo).getRegNoLength() //登记号长度
	set CardNoLength = +##class(web.DHCEkgNo).getCardNoLength() //卡号长度
	set InNoLength = +##class(web.DHCEkgNo).getInNoLength() //住院号长度
	
	//根据InRegNo长度判断是登记号还是卡号
	//卡号
	s rtn=""
	
	//加后缀的 登记号
	if (##class(web.DHCEkgNo).numberIsContainRegNo(InRegNo)="1") set HisId=$p(InRegNo,"^",1) do
	.quit:HisId=""
	.set HisId=##class(web.DHCEkgNo).getFullNo(HisId,RegNoLength) //位数补齐
	.s rtn=..GetEKGInfoTxtByLRD(LocId,HisId,StartDate,Enddate)
	
	//^CardNo卡号
	if (##class(web.DHCEkgNo).numberIsContainCardNo(InRegNo)="1") set HisId=$p(InRegNo,"^",1) do
	.quit:HisId=""
	.set HisId=##class(web.DHCEkgNo).getFullNo(HisId,CardNoLength) //位数补齐
	.set HisId= ##class(web.DHCEkgNo).getRegNoByCardNo(HisId)
	.quit:HisId=""
    .set rtn=..GetEKGInfoTxtByLRD(LocId,HisId,StartDate,Enddate)
	
	//^MedCareNo 病案号
	if (##class(web.DHCEkgNo).numberIsContainMedCareNo(InRegNo)="1") set HisId=$p(InRegNo,"^",1) do
	.quit:HisId=""
	.set HisId=##class(web.DHCEkgNo).getFullNo(HisId,InNoLength) //位数补齐
	.set HisId= ##class(web.DHCEkgNo).getRegNoByInNo(HisId)
	.quit:HisId=""
	.set rtn=..GetEKGInfoTxtByLRD(LocId,HisId,StartDate,Enddate)
	
	
    //登记号
    i (rtn="") d
    .set HisId=##class(web.DHCEkgNo).getFullNo(InRegNo,RegNoLength) //位数补齐
    .q:HisId=""
	.set rtn=..GetEKGInfoTxtByLRD(LocId,HisId,StartDate,Enddate)  ///,StartDate,Enddate)
	
	//通过长度 卡号
	i (rtn="") d
	.set HisId=##class(web.DHCEkgNo).getFullNo(InRegNo,CardNoLength) //位数补齐
    .s HisId= ##class(web.DHCEkgNo).getRegNoByCardNo(HisId)
	.q:HisId=""
    .s rtn=..GetEKGInfoTxtByLRD(LocId,HisId,StartDate,Enddate)
    
   	// 病案号
	i (rtn="") d
	.set HisId=##class(web.DHCEkgNo).getFullNo(InRegNo,InNoLength) //位数补齐
	.s HisId= ##class(web.DHCEkgNo).getRegNoByInNo(HisId)
	.q:HisId=""
	.s rtn=..GetEKGInfoTxtByLRD(LocId,HisId,StartDate,Enddate)
	
	Quit rtn
}

/// Creator：		yyl
/// CreatDate：		2021-4-13
/// Description:	查询医嘱信息串，调用GetEKGInfoTxtSpeed实现
/// Table：        
/// Input：			执行科室id；登记号；起始日期；终止日期
/// Return：		医嘱信息串，不同医嘱信息之间用$间隔；一条医嘱信息中的不通值用^间隔
/// Others：
/// w ##class(web.DHCEkgService).GetEKGInfoTxtNew("85","0000000015","2020-1-1","2021-9-25")
ClassMethod GetEKGInfoTxtNew(LocId As %String, InRegNo As %String, StartDate As %String, Enddate As %String) As %String [ WebMethod ]
{
	
	set RegNoLength = +##class(web.DHCEkgNo).getRegNoLength() //登记号长度
	set CardNoLength = +##class(web.DHCEkgNo).getCardNoLength() //卡号长度
	set InNoLength = +##class(web.DHCEkgNo).getInNoLength() //住院号长度
	
	//根据InRegNo长度判断是登记号还是卡号
	//卡号
	s rtn=""
	
	//加后缀的 登记号
	if (##class(web.DHCEkgNo).numberIsContainRegNo(InRegNo)="1") set HisId=$p(InRegNo,"^",1) do
	.quit:HisId=""
	.set HisId=##class(web.DHCEkgNo).getFullNo(HisId,RegNoLength) //位数补齐
	.s rtn=..GetEKGInfoTxtSpeed(LocId,HisId,StartDate,Enddate)
	
	//^CardNo卡号
	if (##class(web.DHCEkgNo).numberIsContainCardNo(InRegNo)="1") set HisId=$p(InRegNo,"^",1) do
	.quit:HisId=""
	.set HisId=##class(web.DHCEkgNo).getFullNo(HisId,CardNoLength) //位数补齐
	.set HisId= ##class(web.DHCEkgNo).getRegNoByCardNo(HisId)
	.quit:HisId=""
    .set rtn=..GetEKGInfoTxtSpeed(LocId,HisId,StartDate,Enddate)
	
	//^MedCareNo 病案号
	if (##class(web.DHCEkgNo).numberIsContainMedCareNo(InRegNo)="1") set HisId=$p(InRegNo,"^",1) do
	.quit:HisId=""
	.set HisId=##class(web.DHCEkgNo).getFullNo(HisId,InNoLength) //位数补齐
	.set HisId= ##class(web.DHCEkgNo).getRegNoByInNo(HisId)
	.quit:HisId=""
	.set rtn=..GetEKGInfoTxtSpeed(LocId,HisId,StartDate,Enddate)
	
	
    //登记号
    i (rtn="") d
    .set HisId=##class(web.DHCEkgNo).getFullNo(InRegNo,RegNoLength) //位数补齐
    .q:HisId=""
	.set rtn=..GetEKGInfoTxtSpeed(LocId,HisId,StartDate,Enddate)  ///,StartDate,Enddate)
	
	//通过长度 卡号
	i (rtn="") d
	.set HisId=##class(web.DHCEkgNo).getFullNo(InRegNo,CardNoLength) //位数补齐
    .s HisId= ##class(web.DHCEkgNo).getRegNoByCardNo(HisId)
	.q:HisId=""
    .s rtn=..GetEKGInfoTxtSpeed(LocId,HisId,StartDate,Enddate)
    
   	// 病案号
	i (rtn="") d
	.set HisId=##class(web.DHCEkgNo).getFullNo(InRegNo,InNoLength) //位数补齐
	.s HisId= ##class(web.DHCEkgNo).getRegNoByInNo(HisId)
	.q:HisId=""
	.s rtn=..GetEKGInfoTxtSpeed(LocId,HisId,StartDate,Enddate)
	
	Quit rtn
}

ClassMethod GetEKGInfoTxtSpeed(LocId As %String, InRegNo As %String, StartDate As %String, Enddate As %String) As %String
{
	s Gettypedesc="",GetRegNo="",GetStudyNo="",GetName="",GetSexDesc="",GetstrAge="",GetstrDOB="",GetstrOrderName="",
	GetStudyWay="",GetPatientStatus="",GetRptID="",GetReportStatus="",GetImgcount="",GetIDCDesc="",
	Getrequestdoc="",GetLocName="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocName="",
	GetVerifyDate="",GetVerifyTime="",GetRoomDesc="",GetRptIsYX="",GetIsTSBL="",GetIsKYBL="",GetstrRegDate="",GetstrRegTime="",
	GetTotalPrice="",GetEQDesc="",GetstrDate="",GetstrTime="",GetstrAccessionNum="",GetIndex="",Getifbed="",GetIPNo="",
	GetWardName="",Getroomdesc="",GetBedNo="",feetype="",BodyDesc="",Getbilled="",GetMainDoc="",GetAssDoc="",paadmdr="",oeorditemdr="",
	GetEQGroupDesc="",GetOldNo="",Required="",SafetynetCardNo="",strMemo="",
	CallStatus="",Number="",GetTelPhone="",GetNum="",GetAssisName="",RoomIndex="",GetReportInfo="",
	(GetItemCode,GetItemRowId)=""
	
	
	//如果时间段为空，那么默认取当天到60天前的数据，可根据各医院情况，决定推前多长
	i (StartDate="")&&(Enddate="")  d
	.s sdate=$p($h,",",1)-7,edate=$p($h,",",1)
	e  d
	.s sdate=$zdh(StartDate,3),edate=$zdh(Enddate,3) //时间限制
	set rtn=""
    s ExmLocID=LocId
    s Number=""  //在此处检索的数据应该不是属于预约的了，所以预约号为空
 	s pami=$o(^PAPERi("PAPMI_PatNo",InRegNo,""))
 	
 	s validOrdIds=""
 
 	s paadmtype=0 f  s paadmtype=$o(^PAPERdr(pami,"ADM",paadmtype)) q:paadmtype=""  d
 	.s paadmdr=0 f  s paadmdr=$o(^PAPERdr(pami,"ADM",paadmtype,paadmdr)) q:paadmdr=""  d
 	..s OrderRowid=0 f  S OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid)) q:OrderRowid=""  d
    ...s itemsub=0 f  S itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:itemsub=""  d
    ....s recLoc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
    ....q:recLoc'=LocId
    ....s prior=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",8)
    ....q:prior'=3
    ....s date=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)
    ....q:date<sdate
    ....q:date>edate
    ....s ItemStatusCode=""
    ....s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	....i (ItemStatDR'="") s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
    ....q:(ItemStatusCode="D")
    ....q:(ItemStatusCode="C")
    ....q:(ItemStatusCode="U")
    ....i (validOrdIds'="") s validOrdIds=validOrdIds_"@"_OrderRowid_"||"_itemsub
    ....e  s validOrdIds=OrderRowid_"||"_itemsub
	
	i (validOrdIds'="") d
	.s rtn=..getDHCEKGOrderInfoBylistOrderItem(validOrdIds)
	Quit rtn
	/*
    ....s GetIDCDesc=##class(web.DHCEkgPatientInfo).GetDiagnose(paadmdr)
    ....s PatInfo=##class(web.DHCEkgPatientInfo).GetPaadmInfo(paadmdr)
    ....s ordInfo=##class(web.DHCEkgOeorditem).GetOeorditminfo(OrderRowid,itemsub)
    ....s GetRegNo=$p(PatInfo,"^",1)
    ....s GetName=$p(PatInfo,"^",2)
    ....s GetStudyNo=$p(PatInfo,"^",27)
    ....s GetstrDOB=$p(PatInfo,"^",3)
    ....s GetstrAge=$p(PatInfo,"^",4)
    ....s GetstrAge=$p(GetstrAge," ")
 	....s GetSexDesc=$p(PatInfo,"^",5)
    ....s Getpatienttype=$p(PatInfo,"^",6)
    ....s Gettypedesc=$p(PatInfo,"^",7)
    ....s GetLocName=$p(PatInfo,"^",8)
    ....s GetIPNo=$p(PatInfo,"^",9)       ;住院号
    ....s GetWardName=$p(PatInfo,"^",10)
    ....s GetBedNo=$p(PatInfo,"^",11)
    ....s GetReqLocDR=$p(PatInfo,"^",12)
    ....s GetWardDR=$p(PatInfo,"^",14)
    ....s Getroomdesc=$p(PatInfo,"^",15)
    ....s GetSexDr=$p(PatInfo,"^",13)
    ....s SafetynetCardNo=$p(PatInfo,"^",23)
    ....s GetTelPhone=$p($g(PatInfo),"^",19)
    ....s GetstrOrderName=$p(ordInfo,"^",1)
    ....s GetItemCode=$p(ordInfo,"^",24)
    ....s GetItemRowId=$p(ordInfo,"^",23)
    ....s GetstrOrderName=GetItemRowId_"#"_GetItemCode_"#"_GetstrOrderName
    ....s DHCRisSystemInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
    ....i DHCRisVersion="BJ_FX" d
    .....s strOrdItemMemo=##class(web.DHCEkgApplication).GetOrdItemMemo(oeorditemdr)
    .....i ((strOrdItemMemo'="")&(strOrdItemMemo'=" ")) s GetstrOrderName=GetstrOrderName_"(备注:"_strOrdItemMemo_")"
    ....s GetstrDate=$p(ordInfo,"^",2)
    ....s GetstrTime=$p(ordInfo,"^",3)
    ....s Getrequestdoc=$p(ordInfo,"^",4)
    ....s GetstrAccessionNum=$p(ordInfo,"^",5)
    ....s GetSGroupDesc=$p(ordInfo,"^",6)    ;是否需要预约项目的标记
    ....s GetsubCatDesc=$p(ordInfo,"^",7)
    ....s GetCatDesc=$p(ordInfo,"^",8)
    ....s Getifbed=$p(ordInfo,"^",9)
    ....s Getprice=$p(ordInfo,"^",10)
    ....s GetNum=$p(ordInfo,"^",11)
    ....s GetTotalPrice=$p(ordInfo,"^",12)
    ....s Getbilled=$p(ordInfo,"^",13)   //费别
    ....s GetItemStatusCode=$p(ordInfo,"^",14)
    ....s GetordDate=$p(ordInfo,"^",15)
    ....s GetordTime=$p(ordInfo,"^",16)
    ....s GetItemStatusCode=$p(ordInfo,"^",17)   		;医嘱状态
    ....q:(GetItemStatusCode="D")
    ....q:(GetItemStatusCode="C")
    ....q:(GetItemStatusCode="U")
    ....i GetItemStatusCode="V" s GetItemStatusCode=GetItemStatusCode_"#核实"
    ....i GetItemStatusCode="E" s GetItemStatusCode=GetItemStatusCode_"#执行"
    ....i GetItemStatusCode="D" s GetItemStatusCode=GetItemStatusCode_"#停止"
    ....s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记
    ....s strMemo=$p(ordInfo,"^",21)
    ....s IsDB = 1  ;哈医大，急诊(门诊)担保押金,门诊病人且医嘱为核实状态
    ....s DHCRisVersion=""
    ....i (Getpatienttype="O")&(GetItemStatusCode="V") d
    .....s DHCRisSystemInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
    .....s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
    .....i DHCRisVersion="HRB_HYD" d
    ......s DBMoney=0
    ......s DBMoney= $$GetAmtOP^|"meddata"|PCHCOLLS(paadmdr)
    ......s IsDB=(DBMoney>0)
    .....i DHCRisVersion="BJ_FX" d ;复兴医院门诊押金病人未缴费可以做检查
    ......Set CurrentNS=$ZNSPACE
    ......d ##class(web.DHCEkgSystemParam).SetMedTrakNameSpace()
    ......s IsDB= $$CheckDepositADM^CHOPDeposit(paadmdr)
    ......zn CurrentNS
    ....s SystemParamInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
    ....s SendApptoLoc=$p(SystemParamInfo,"^",3)  ;没写申请单,是否发检查医嘱到检查科室
    ....s SendInPtoLoc=$p(SystemParamInfo,"^",4)  ;没收费是否把住院病人的检查项目发送到检查科室  
    ....s SendOutPtoLoc=$p(SystemParamInfo,"^",5) ;没收费是否把门诊检查项目发送到检查科室
    ....s SendEmPtoLoc=$p(SystemParamInfo,"^",6)   ;没收费是否把急诊病人检查项目发送到检查科室
    ....s QueryonlyExam=$p(SystemParamInfo,"^",9)  ;是否只查询检查项目
    ....s SendHPtoLoc=$p(SystemParamInfo,"^",10)   ;没收费是否把体检病人的检查项目发送检查科室
    ....q:(SendOutPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="O")&(IsDB=0)   ;门诊病人没有付费退出
    ....q:(Getbilled'="P")&((Getpatienttype="O")||(Getpatienttype="E"))
    ....q:(Getbilled'="P")&(Getpatienttype="H") //体检病人需要收费才能检查
    ....s GetPatientStatusCode="A"
    ....s GetReportStatusCode="N"
    ....s Getapprowid="" //,GetStudyNo=""
    ....s GetRoomDr="",Getapprowid=""
    ....s GetImgcount="",GetMainDoc="",GetAssDoc=""
    ....s GetRptID="",GetRptVersion="",GetRptIsYX="",GetEQGroupDesc="",GetOldNo=""
    ....s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
    ....s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",GetStudyDescDR=""
    ....s GetStudyWay="",GetBodyPartDR="",GetIsKYBL="",GetIsTSBL="",GetResultDesc="",GetExamDesc=""
    ....s GetIndex="",GetstrRegDate="",GetstrRegTime="",GetEQDr="",GetEQDesc="",GetRoomDesc="",GetEQGroupDR="",GetMainSSuserdr="",BodyDesc=""
    ....s GetAssisName=""
    ....i (GetItemStatusCode="V")!(GetItemStatusCode="E") d
    .....s GetRejDR=$o(^DHCRBRejecti("OeordDR",oeorditemdr,0))
	.....i GetRejDR'="" d
	......s GetPatientStatusCode="R" ;拒绝申请
	.....else  d
	......i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" s Getapprowid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)  ; 已经预约RB_Appointment Rowid
	.....q:(Getapprowid'="")&(Getapprowid'=$c(0))   ;预约过的医嘱则退出 
	.....s GetImgcount=0
    ....Do OutRow145
    */
   Quit rtn ;$$$OK
OutRow145
 	s Required=""
   	if (GetSGroupDesc="无需预约")!(GetstrOrderName["床旁") s Required="N"
    set DataEx=Gettypedesc_"^"_GetRegNo_"^"_GetStudyNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetstrDOB_"^"_GetstrOrderName
	_"^"_GetStudyWay_"^"_GetPatientStatus_"^"_GetRptID_"^"_GetReportStatus_"^"_GetImgcount_"^"_GetIDCDesc
	_"^"_Getrequestdoc_"^"_GetLocName_"^"_GetRptDocName_"^"_GetRptDate_"^"_GetRptTime_"^"_GetVerifyDocName
	_"^"_GetVerifyDate_"^"_GetVerifyTime_"^"_GetRoomDesc_"^"_GetRptIsYX_"^"_GetIsTSBL_"^"_GetIsKYBL_"^"_GetstrRegDate_"^"_GetstrRegTime
	_"^"_GetTotalPrice_"^"_GetEQDesc_"^"_GetstrDate_"^"_GetstrTime_"^"_GetstrAccessionNum_"^"_GetIndex_"^"_""_"^"_""_"^"_""_"^"_Getifbed_"^"_GetIPNo
	_"^"_GetWardName_"^"_Getroomdesc_"^"_GetBedNo_"^"_feetype_"^"_BodyDesc_"^"_Getbilled_"^"_GetMainDoc_"^"_GetAssDoc_"^"_paadmdr_"^"_oeorditemdr
	_"^"_GetEQGroupDesc_"^"_GetOldNo_"^"_Required_"^"_SafetynetCardNo_"^"_strMemo
	_"^"_CallStatus_"^"_Number_"^"_GetTelPhone_"^"_GetNum_"^"_GetAssisName_"^"_RoomIndex_"^"_GetReportInfo
	_"^"_GetItemStatusCode
    
    
    ///将接口信息写到临时globe，便于核对数据，最大200条
    s disc="来源^登记号^^姓名^性别^年龄^出生日期^^^^^^^^^^^^^^^^^^^^^^价格^^^^^^^^^^^病区^^^^^是否收费^^^^^^^^^^^^^^^^^"
    /*
    s TMPStr=DataEx
    s Tstr=""
    f i=1:1:$l(TMPStr,"^") d
    .s PLIST(i)=i_"-"_$p(disc,"^",i)_"/"_$p(TMPStr,"^",i)
    .s Tstr=Tstr_PLIST(i)_"^"   
    i '$d(^TMPEKG("INFO")) d
    .s ^TMPEKG("INFO",+$h,GetRegNo,1)=Tstr
    e  d
    .s teml=$o(^TMPEKG("INFO",+$h,GetRegNo,""),-1)+1
    .i teml<201 d
    ..s ^TMPEKG("INFO",+$h,GetRegNo,teml)=Tstr
    .e  d
    ..k ^TMPEKG
    ..s ^TMPEKG("INFO",+$h,GetRegNo,1)=Tstr
	*/
    ;w "++++++++"_DataEx_"+++++++++:"
    ;如果是多条记录，用“$”间隔
   	if rtn'="" s rtn=rtn_"$"
    s rtn=rtn_DataEx
 	quit
}

/// Creator：      liupeng
/// CreatDate：    2008-12-30
/// Description:： 更新检查医嘱状态
/// Table：        
/// Input：        用户id；医嘱号；子类；状态；病人主索引
/// Output：       
/// Return：       
/// Others：
/// 2009-03-11	liupeng	增加注释 
ClassMethod UpdataOrdInfo(OrdIds, UserId, OrderStatus, LocId, notes = "") As %String
{
   ;w ##class(web.DHCEkgService).UpdataOrdInfo("", "51057||23","", "E", "")
   
   ;s return=..UpdataOrdInfoEx(Userid, OrditmRowid, ChildSub, Status, ResultStatus,PAADMDR)
   
   ;UpdataOrdInfoExXZY(OrdIds, UserId, OrderStatus, LocId, Notes = "")
   
   ;;;;;s return=..UpdataOrdInfoExXZY(OrdIds, UserId, OrderStatus, LocId, notes) //结果状态会根据状态调整
   
   set return=..UpdataOrdInfoNew(OrdIds, UserId, OrderStatus, LocId, notes)
   
   quit return
}

/// Creator：      liupeng
/// CreatDate：    2008-12-30
/// Description:： 获取所有科室代码
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
/// 2009-03-11	liupeng	增加注释 
ClassMethod GetCTLOCList() As %String
{
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetMedTrakNameSpace()
	s ctlocCount=$g(^CTLOC(0))
	s return=""
	s trueCount=0
	For index=1:1:ctlocCount
	{
		s currentLoc=$g(^CTLOC(index))
		if (currentLoc'="")
		{
			s trueCount=trueCount+1
			if (return'="")
			{
				s return=return_"$"
			}
			s desc=$p(currentLoc,"^",2)
			s return=return_index_"^"_$p(desc,"-",1)_"^"_$p(desc,"-",2)
		}
	}
	//if (trueCount>0) s return=return_"$"_trueCount
	zn CurrSpace
	q return
}

/// EKGGetDeptCodeList
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Description:： 获取所有科室RowId
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
ClassMethod EKGGetDeptCodeList() As %String
{
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetMedTrakNameSpace()
	s ctlocCount=$g(^CTLOC(0)) //^CTLOC(0) 取count
	s return=""
	s Today=$P($H,",",1)
	s index=0 f  s index=$O(^CTLOC(index)) q:index=""  d
	.s currentLoc=$g(^CTLOC(index))
	.if currentLoc'="" d
	..s CTLOCEndTime=$P(currentLoc,"^",9) //^CTLOC(1) = "产科^CK-产科^3^4^5^6^7^8^9^Y^Y^^E^^^9-妇产科^^N^2^^Y^^Y^61101^^N^Y^^N^^^^^N^N^^^^^^0001^^CK^^^^^^^^^^^^^^^^N^N^^N^^^N^N^N^N^^^N^^^^^^^^^^^^^" 
	..s:CTLOCEndTime>=Today CTLOCEndTime=""
	..;停止的不传
	..i $G(CTLOCEndTime)="" d
	...i return'="" s return=return_"$"
	...s return=return_index
	zn CurrSpace
	q return
}

/// EKGGetDeptByCode
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Description:： 根据科室RowId，获取科室信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
ClassMethod EKGGetDeptByCode(CtLocId As %String) As %String
{
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetMedTrakNameSpace()
	s return=""
	i $D(^CTLOC(CtLocId)) d ////^CTLOC(1) = "产科^CK-产科^3^4^5^6^7^8^9^Y^Y^^E^^^9-妇产科^^N^2^^Y^^Y^61101^^N^Y^^N^^^^^N^N^^^^^^0001^^CK^^^^^^^^^^^^^^^^N^N^^N^^^N^N^N^N^^^N^^^^^^^^^^^^^" 
	.s CtLocCode=$P(^CTLOC(CtLocId),"^",1)
	.s CtLocDesc=$P(^CTLOC(CtLocId),"^",2)
	.s StrLen=$L(CtLocDesc,"-")
	.i StrLen=2 d
	..s InputCode=$P(CtLocDesc,"-",1)
	..s CtLocName=$P(CtLocDesc,"-",2)
	.e  d
	..s InputCode=""
	..s CtLocName=CtLocDesc
	.s return=CtLocId_"$"_CtLocName_"$"_InputCode_"$"_CtLocCode
	//s return=CtLocId_"$"_CtLocName_"$"_CtLocDesc_"$"_CtLocCode
	e  d
	.s return="科室指针不存在"
	.q
	zn CurrSpace
	q return
}

/// EKGGetExamCodeList
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Description:： 取检查类的医嘱RowId
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
ClassMethod EKGGetExamCodeList(OrdCat As %String) As %String
{
	;w ##Class(web.DHCEkgService).EKGGetExamCodeList(1)
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetMedTrakNameSpace()
	s return=""
	s Today=$P($H,",",1)
	s OrdSubCat=0  f  s OrdSubCat=$O(^ARC("IC",0,"OrdCat",OrdCat,OrdSubCat)) q:OrdSubCat=""  d
	.i $D(^ARCIM(0,"ARCIC_DR",OrdSubCat)) d
	..s ARCIMSubscript=""  f  s ARCIMSubscript=$O(^ARCIM(0,"ARCIC_DR",OrdSubCat,ARCIMSubscript)) q:ARCIMSubscript=""  d
	...s Version=$O(^ARCIM(0,"ARCIC_DR",OrdSubCat,ARCIMSubscript,""))
	...i $D(^ARCIM(ARCIMSubscript,Version)) d
	....s EndDate=$P( ^ARCIM(ARCIMSubscript,Version,7),"^",1)
	....s:EndDate>=Today EndDate=""
	....;停止的不传
	....i $G(EndDate)="" d
	.....s ArcimId=ARCIMSubscript_"||"_Version
	.....i return'="" s return=return_"$"
	.....s return=return_ArcimId
	zn CurrSpace
	q return
}

/// EKGGetExamByCode
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Description:： 根据检查类的RowId取医嘱信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
ClassMethod EKGGetExamByCode(ArcimId As %String) As %String
{
	;w ##Class(web.DHCEkgService).EKGGetExamByCode("8219||1")
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetMedTrakNameSpace()
	s return=""
	s Today=$P($H,",",1)
	q:ArcimId="" "入参为空"
	s ARCIMSubscript=$P(ArcimId,"||",1)
	s Version=$P(ArcimId,"||",2)
	Q:'$d(^ARCIM(ARCIMSubscript,Version,1)) "医嘱指针不存在"
	s ArcimCode=$P(^ARCIM(ARCIMSubscript,Version,1),"^",1)
	s ArcimDesc=$P(^ARCIM(ARCIMSubscript,Version,1),"^",2)
	i $D(^ARC("ALIAS",0,"ARCIM",ArcimId)) d
	.s ALIASId=$O(^ARC("ALIAS",0,"ARCIM",ArcimId,""))
	.s InputCode=$P(^ARC("ALIAS",ALIASId),"^",6)
	e  d
	.s InputCode=""
	s SumPrice=0
	;^DHCOLT(0,"ARTTA","745||1",12,61526,1058)
	s TarId=""  f  s TarId=$O(^DHCOLT(0,"ARTTA",ArcimId,TarId)) q:TarId=""  d
	.;停止的不处理
	.s TARIEndDate=$P(^DHCTARI(TarId),"^",12)
	.s:TARIEndDate>=Today TARIEndDate=""
	.;取有效的调价记录
	.s AdjId=""
	.s TAdjId=0  f  s TAdjId=$O(^DHCTARI(TarId,"P",TAdjId)) q:TAdjId=""  d
	..s TPEndDate=$P(^DHCTARI(TarId,"P",TAdjId),"^",4)
	..s:TPEndDate>=Today TPEndDate=""
	..i $G(TPEndDate)="" d
	...s AdjId=TAdjId
	...q
	..q:AdjId=""
	.q:AdjId=""
	.i ($G(TARIEndDate)=""&$G(AdjId)'="") d  ;收费项目并且存在有效的调价记录
	..s StarDate=""  f  s StarDate=$O(^DHCOLT(0,"ARTTA",ArcimId,TarId,StarDate)) q:StarDate=""  d
	...s DHCOLTId=$O(^DHCOLT(0,"ARTTA",ArcimId,TarId,StarDate,""))
	...s EndDate=$P(^DHCOLT(DHCOLTId),"^",5)
	...s:EndDate>=Today EndDate=""
	...;医嘱项目和收费项目关联停止的不处理
	...i $G(EndDate)="" d
	....s Qty=$P(^DHCOLT(DHCOLTId),"^",3)
	....s IPrice=$P($g(^DHCTARI(TarId,"P",AdjId)),"^",5)
	....s:Qty="" Qty=1
	....s:IPrice="" IPrice=0
	....s SumPrice=SumPrice + (Qty*IPrice)
	s return=ArcimId_"$"_ArcimCode_"$"_ArcimDesc_"$"_InputCode_"$"_SumPrice
	zn CurrSpace
	q return
}

/// EKGGetUserCodeList
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Description:： 用户基本信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
ClassMethod EKGGetUserCodeList() As %String
{
	;w ##Class(web.DHCEkgService).EKGGetExamByCode("754||1")
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetMedTrakNameSpace()
	s return=""
	s UserId=""
	s Today=$P($H,",",1)
	s index=0 f  s index=$O(^SSU("SSUSR",index)) q:index=""  d
	.s currentLoc=$g(^SSU("SSUSR",index))
	.if currentLoc'="" d
	..s SSUSRDateTo=$P(currentLoc,"^",97)
	..s:SSUSRDateTo>=Today SSUSRDateTo=""
	..;停止的不传
	..i $G(SSUSRDateTo)="" d
	...i return'="" s return=return_"$"
	...s UserId=$P(currentLoc,"^",1)
	...s return=return_UserId
	zn CurrSpace
	q return
}

/// EKGGetUserByCode
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Description:： 用户基本信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
ClassMethod EKGGetUserByCode(UserCode As %String) As %String
{
	;w ##Class(web.DHCEkgService).EKGGetUserByCode()
	new $namespace
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetMedTrakNameSpace()
	s return=""
	s DocPower=""
	s Today=$P($H,",",1)
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$ZCONVERT(UserCode,"U"),0))
	;s UserCode=$P(^SSU("SSUSR",UserId),"^",1)
	s UserDesc=$P(^SSU("SSUSR",UserId),"^",2)
	;trak的用户和医护人员，没有性别
	s SexDesc="男"
	s DefaultDept=$P(^SSU("SSUSR",UserId),"^",4)
	s DefaultDeptCode=$P(^CTLOC(DefaultDept),"^",1)

	;取其他登录科室
	s OtherDept=""
	s OTHLLChildsub=0 f  s OTHLLChildsub=$O(^SSU("SSUSR",UserId,"OTHLL",OTHLLChildsub)) q:OTHLLChildsub=""  d
	.s OtherDeptDr=$P(^SSU("SSUSR",UserId,"OTHLL",OTHLLChildsub),"^",1)
	.s OtherDeptCode=$P(^CTLOC(OtherDeptDr),"^",1)
	.i OtherDept'="" s OtherDept=OtherDept_"^"
	.s OtherDept=OtherDept_OtherDeptCode
	
	s Permission=..GetHisUserType(UserId)
	
	s return=UserId_"$"_UserCode_"$"_UserDesc_"$"_SexDesc_"$"_DefaultDeptCode_"$"_OtherDept_"$"_DocPower
	zn CurrSpace
	q return
}

/// w ##class(web.DHCEkgService).UpdataOrdInfoNew("107||6","636","RP")
ClassMethod UpdataOrdInfoNew(OrdIds As %String, UserId As %String, OrderStatus As %String, LocId As %String, Notes As %String = "") As %String
{
	set params=OrdIds_"^"_UserId_"^"_OrderStatus_"^"_LocId
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","UpdataOrdInfoNew",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	set IsModify="N"
	set rtn=""
	
	if OrderStatus="" set OrderStatus="E"
	
	set UserRowId=""
	if (UserId'="") do
	.set UserRowId=..GetUserRowId(UserId)
	
	//只是医嘱的
	//第一个入参是医嘱id
	//第二个是执行人id
	if OrderStatus="E" do
	.d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Execute",$zd($h,3),$zt($p($h,",",2),1),OrdIds_"^"_UserId,OrdIds,"UpdataOrdInfoNew")	
	.set rtn=##class(appcom.OEOrdItem).Execute(OrdIds,UserId) //执行医嘱
	.d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Execute",$zd($h,3),$zt($p($h,",",2),1),rtn,OrdIds,"UpdataOrdInfoNew rtn")	
	.set RID=$Replace(OrdIds,"||","_") ;调用PACS方法，改变申请单状态
	.set RID=RID_"@"
	.set ExamNo="" ;检查号 2
	.set CurrSpace=$ZNSPACE
	.;do ..SetDHCEKGNameSpace()	
	.do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	.quit:OrdIds=""	
	.;set reqId=$o(^dbo.tblRequestI("idxExamCode"," "_OrdIds,""))
	.;quit:reqId=""
	.;set ExamNo = $o(^dbo.tblExaminationI("idxRequestID",reqId,""))
	.;quit:ExamNo=""
	.set ExamNo ="EKG||"_OrdIds	;检查号：EKG||医嘱ID
		
	.zn CurrSpace
	.set Notes=RID_"^"_ExamNo_"^R^^^^^^^^^^^^心电^"
	.b ;Notes
	.d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","UpdataOrdInfoNew",$zd($h,3),$zt($p($h,",",2),1),Notes,OrdIds,"SetReportInfoDo")
	.set rtn=##class(RISService.TrakRISService).SetReportInfoDo(Notes,"","","")
	.d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","UpdataOrdInfoNew",$zd($h,3),$zt($p($h,",",2),1),rtn,OrdIds,"SetReportInfoDoRtn")
	
	if OrderStatus="V" do
	.d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Verify",$zd($h,3),$zt($p($h,",",2),1),OrdIds_"^"_UserId,OrdIds,"UpdataOrdInfoNew")	
	.set rtn=##class(appcom.OEOrdItem).Verify(OrdIds,UserId) //撤销执行 变成核实
	.d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Verify",$zd($h,3),$zt($p($h,",",2),1),rtn,OrdIds,"UpdataOrdInfoNew rtn")
	.set ExamNo="" ;检查号 2
	.set ExamNo="EKG||"_OrdIds	;检查号：EKG||医嘱ID
	.set userInfo="^Y^Y^"
	.d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","UpdataOrdInfoNew",$zd($h,3),$zt($p($h,",",2),1),ExamNo_","_OrdIds_","_userInfo,OrdIds,"UnRegister")
	.set rtn=##class(RISService.TrakRISService).UnRegister(ExamNo,OrdIds,userInfo)
	.d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","UpdataOrdInfoNew",$zd($h,3),$zt($p($h,",",2),1),rtn,OrdIds,"UnRegisterRtn")
	
	if OrderStatus="RP" do //将结果状态变成 已写报告
	.set resultStatus="RP"
	.&sql(Update OE_OrdItem set OEORI_ResultFlag=:resultStatus  where OEORI_RowId=:OrdIds)
	.set RID=$Replace(OrdIds,"||","_") ;向PACS表里插入数据，以便电子病历调用检查结果
	.set RID=RID_"@"
	.set ExamNo="" ;检查号 2
	.set ReportDoctor = "" ;报告医生
	.set ArbiterDoctor = "" ;审核医生
	.set ReportDateTime = "" ;报告时间
	.set ReportDate=""
	.set ReportTime=""
	.set ArbiterDateTime = "" ;审核时间
	.set ArbiterDate=""
	.set ArbiterTime=""
	.set Diagnose = "" ;诊断内容
	.set NegativePositive=""
	.set Positive="N"
	
	.set CurrSpace=$ZNSPACE
	.;do ..SetDHCEKGNameSpace()
	.do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
	.quit:OrdIds=""	
	
	.set reqId=$o(^dbo.tblRequestI("idxExamCode"," "_OrdIds,""))
	.quit:reqId=""
	.set examId = $o(^dbo.tblExaminationI("idxRequestID",reqId,""))
	.quit:examId=""
	.set examInfo=^dbo.tblExaminationD(examId)
	.set ExamNo="EKG||"_OrdIds	;检查号：EKG||医嘱ID
	.set ReportUserID=$list(examInfo,7)
	.set ArbiterUserID=$list(examInfo,7)
	.set ReportDateTime=$list(examInfo,6)
	.set ArbiterDateTime=$list(examInfo,6)
	.set NegativePositive=$list(examInfo,30)
	.set Diagnose=$list(examInfo,11)
	.set ReportDate=$p(ReportDateTime," ",1)
	.set ReportTime=$p(ReportDateTime," ",2)
	.set ArbiterDate=$p(ArbiterDateTime," ",1)
	.set ArbiterTime=$p(ArbiterDateTime," ",2)
	.if (NegativePositive="阳性") set Positive="Y"
	.set ReportUserName="",ArbiterUserName=""
	.if ReportUserID'="" do
	..set ReportUserName=$list(^dbo.tblUserD(ReportUserID),8)
	.if ArbiterUserID'="" do
	..set ArbiterUserName=$list(^dbo.tblUserD(ArbiterUserID),8)
	.set ReportDoctor=ReportUserID_"@"_ReportUserName
	.set ArbiterDoctor=ArbiterUserID_"@"_ArbiterUserName
	.b ;Diagnose
	.if Diagnose'[$c(10) set Diagnose=Diagnose_$c(10) ;2015-08-13
	.set D=""
	.for i=1:1:$l(Diagnose,$c(10)) do
	..set tmpD=$p(Diagnose,$c(10),i)
	..if (tmpD'="") do
	...if (D="") set D=tmpD
	...else  set D=D_","_tmpD
	.b ;00
	.set Diagnose=D
	.b ;Diagnose after
		
	.;do result.Close()	
	.zn CurrSpace	
	.set Notes=RID_"^"_ExamNo_"^S^^"_ReportDoctor_"^"_ArbiterDoctor_"^"_ReportDate_"^"_ArbiterDate_"^"_ReportTime_"^"_ArbiterTime_"^^^"_Positive_"^N^心电^"
	.b ;space
	.d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","UpdataOrdInfoNew",$zd($h,3),$zt($p($h,",",2),1),Notes_","_Diagnose,OrdIds,"SetReportInfoDo")
	.set rtn=##class(RISService.TrakRISService).SetReportInfoDo(Notes,Diagnose,Diagnose,Diagnose)
	.d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","UpdataOrdInfoNew",$zd($h,3),$zt($p($h,",",2),1),rtn,OrdIds,"SetReportInfoDoRtn")
	
	.//创建知识库---xzy 2015-02-04--
	.;do ..CreateLibData(OrdIds)
	.//创建知识库---xzy 2015-02-04--
	
	quit rtn
}

/// //portal未读报告--xzy-----------------------------------------------
/// 	do ..PortalUnReadReport(OrdIds)
/// 	//portal未读报告--------------------------------------------------
/// 插入已发布报告信息
/// info:病人ID^病人姓名^性别^生日^检查项目^主治医生^申请医生^检查类型^检查号^医嘱日期^医嘱时间^报告日期^报告时间^检查医生^报告内容^医嘱ID
/// w ##class(DtPortal.Doctor.ClinicPrompt.UnReadReportService).SetPortalRPTInfo(info）
/// w ##class(DtPortal.Doctor.ClinicPrompt.UnReadReportService).SetPortalRPTInfo("0001234567^Portal测试一^女^62386^9478||1^496^661^RIS^ris0004^63386^42068^63386^40011^040^^2||6")
/// 注：1、其中姓名、性别、生日不是必填项目。
/// 2、检查类型： 1:检验,2病理,3心电,4超声,5内镜,6放射，7其他检查
/// 3、主治医生、申请医生、检查医生为UserCode
/// 4、报告内容：Url。如：“dhclabdoctorreport.csp?PatientBanner=1&TestSetRow=587||B004||1&OrderID=601||2”中，只需插入“PatientBanner=1&TestSetRow=587||B004||1&OrderID=601||2”，但是portal系统中涉及到单点登录，需各组给出csp，如上面url中的dhclabdoctorreport.csp，需大家给我回邮件说明报告在哪个csp下显示。
/// ;w ##class(web.DHCEkgService).PortalUnReadReport("203||107","N")
ClassMethod PortalUnReadReport(OrdIds As %String, IsModify As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","PortalUnReadReport",$zd($h,3),$zt($p($h,",",2),1),OrdIds_"^"_IsModify,"params")
	set info="" ;info:医嘱ROWID_"^"_检查号_"^"_报告状态(代码@名称)S_"^"_未发报告原因_"^"_报告医生(代码@名称)_"^"_审核医生(代码@名称)_"^"_报告日期_"^"_审核日期_"^"_报告时间_"^"_审核时间_"^"_备注信息_"^"_文件信息_"^"_HIS归档标记_"^"_危急值（Y/N）_"^"_系统类型
	//其中：例子：221_351@221_352^US20140915002^S^^ris@ris^ris@ris^2014-9-25^2014-9-25^11:46:25^11:46:30^^^N^N^心电
	//医嘱rowid ||双竖线 变成 _下划线
 	//归档标记 危急值 都传N就行
 	//系统类型传“心电”
	//日期类型  YY-MM-dd
 	//时间是 HH:mm:ss 
 	
 	set tmpRowID=OrdIds
 	set RowIDP = $p(tmpRowID,"||",1) ;
	set RowIDS = $p(tmpRowID,"||",2) ;
	
 	set ROWID=RowIDP_"_"_RowIDS_"@" ;OrdIds 医嘱ROWID 1
 	set ExamNo="" ;检查号 2
 	set ReportStatus="S" ;报告状态(代码@名称)S 3
 	set UnReportReason="" ;未发报告原因 4
 	set ReportDoc="" ;报告医生(代码@名称) 5
 	set AbriterDoc="" ;审核医生(代码@名称) 6
 	set ReportDate="" ;报告日期 7
 	set AbriterDate="" ;审核日期 8
 	set ReportTime="" ;报告时间 9
 	set AbriterTime="" ;审核时间 10
 	set Notes="" ;备注信息 11
 	set FileInfo="" ;文件信息 12
 	set HISDoc="N" ;HIS归档标记 13
 	set IsEmergcy="N" ;危急值（Y/N 14
 	set ExamType="心电" ;系统类型 15
	
	set CurrSpace=$ZNSPACE
	;zn "DHC-EKG"
	;do ..SetDHCEKGNameSpace()
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	
	quit:OrdIds=""
	
	set result = ##class(%Library.ResultSet).%New()
	set sqlStr = "select * from dbo.vwGetExaminationList where ekgExamCode= '"_OrdIds_"'" _" ORDER BY ekgArbiterTime desc"
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","PortalUnReadReport",$zd($h,3),$zt($p($h,",",2),1),sqlStr,"sqlStr")
	do result.Prepare(sqlStr) 
	do result.Execute() 
	if result.Next() do
	
	.set ExamNo ="EKG||"_OrdIds ;检查号 2
	
	.set ReportDocID = result.Data("ekgOperateUserID")
	.if ReportDocID'="" do
	..set ReportUserInfo = ^dbo.tblUserD(ReportDocID)
	..;^dbo.tblUserD(3)=$lb("1","2-妇产科门诊","3","4","5-男","6","7","8-432","9-1","10","11-朱龙英","","")
	..if ReportUserInfo'="" do
	...set ReportDocCode = $list(ReportUserInfo,8) ;
	...set ReportDocDesc = $list(ReportUserInfo,11)
	...set ReportDoc=ReportDocCode_"@"_ReportDocDesc ;报告医生(代码@名称) 5
	
	.set AbriterDocID = result.Data("ekgArbiterUserID")
	.if AbriterDocID'="" do
	..set AbriterUserInfo = ^dbo.tblUserD(AbriterDocID)
	..;^dbo.tblUserD(3)=$lb("1","2-妇产科门诊","3","4","5-男","6","7","8-432","9-1","10","11-朱龙英","","")
	..if AbriterUserInfo'="" do
	...set AbriterDocCode = $list(AbriterUserInfo,8) ;
	...set AbriterDocDesc = $list(AbriterUserInfo,11) ;
	...set AbriterDoc=AbriterDocCode_"@"_AbriterDocDesc ;审核医生(代码@名称) 6
	
	.set ReportDateTime = result.Data("ekgOperateTime")
	.set ReportDate = $p(ReportDateTime," ",1) ;7
	.set ReportTime = $p(ReportDateTime," ",2) ;9
	
	.set AbriterDateTime = result.Data("ekgArbiterTime")
	.set AbriterDate = $p(AbriterDateTime," ",1) ;8
	.set AbriterTime = $p(AbriterDateTime," ",2) ;10
	
	do result.Close()
	
	zn CurrSpace
	
	//拼接信息
	set info=ROWID_"^"_ExamNo_"^"_ReportStatus_"^"_UnReportReason_"^"_
			 ReportDoc_"^"_AbriterDoc_"^"_ReportDate_"^"_AbriterDate_"^"_
			 ReportTime_"^"_AbriterTime_"^"_Notes_"^"_FileInfo_"^"_
			 HISDoc_"^"_IsEmergcy_"^"_ExamType
	b ;info
	
	//调用方法
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","PortalUnReadReport",$zd($h,3),$zt($p($h,",",2),1),info,OrdIds,"SetReportInfoDo")
	set rtn=##class(RISService.TrakRISService).SetReportInfoDo(info,"","","")

	
	b  ;rtn
	;set ^TmpInfoTtn = info_"||"_rtn
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","PortalUnReadReport",$zd($h,3),$zt($p($h,",",2),1),rtn,OrdIds,"rtn")
	
	quit rtn
}

// 创建知识库

// w ##class(web.DHCEkgService).CreateLibData("203||109")

// 创建知识库

ClassMethod CreateLibData(OrdIds) As %String
{
	quit:OrdIds="" "OrdIds为空"
	
	set rtn=""
	set Input="" //日期^时间^病人id^就诊id^报告号^项目^结果值^单位^类型(检验L,检查C,心电H)
	
	set date="" //日期1--
	set time="" //时间2--
	set patid="" //病人id --登记号3--
	set paadmid="" //就诊id --request中的appointNo4--
	set reportid="" //报告号 --examid5--
	set examitem="" //项目6--
	set resultvalueHR="" //结果值7-HR
	set resultvalueD="" //结果值7-D
	set unit="" //单位8--
	set type="心电H" //类型9--
	
	set CurrSpace=$ZNSPACE
	;zn "DHC-EKG"
	;do ..SetDHCEKGNameSpace()
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	
	set requestId=""
	set requestId=$o(^dbo.tblRequestI("idxExamCode"," "_OrdIds,requestId)) //
	quit:requestId="" "requestId为空"
	
	//^dbo.tblRequestD(2)	=	$lb("1-","2-功能检查科心电图",3-402,"4-","5-","6-356||23","7-0501床","8-","9-中西医结合一科","10-356||23","11-WL0007","12-demo","13-","14-","15-2",16-2,"","2014-02-18 09:50:00","","1","","中西医结合一科护理单元","","","")
	set reqInfo=^dbo.tblRequestD(requestId) //获取到request表的信息
	quit:reqInfo="" "dbo.tblRequest信息为空"
	
	set patientId=$list(reqInfo,16) //
	quit:patientId="" "patientId为空"
	
	//^dbo.tblPatientD(2)	=	$lb("1-","2-","3-1980-04-19 00:00:00","4-","5-","6-","7-","8-f","9-","10","11-500220","12-","13-","14-","15-","15-测试","17-","18-","19-","20-0123456789","123","","LX","","","")
	set patInfo=^dbo.tblPatientD(patientId) //获取到patient表的信息
	quit:patInfo="" "dbo.tblPatient信息为空"
	
	set examId=""
	set examId=$o(^dbo.tblExaminationI("idxRequestID",requestId,examId))
	quit:examId="" "examId为空"
	
	//$lb("1-","2-","3-9999-12-31 23:59:59","4-",5-34,"6-2015-01-29 09:29:54",7-1,"8-","9-",1-5,"11-*** 数据质量较差，可能对解释造成不利影响"_$c(10)_" "_$c(10)_"*** 数据质量较差，可能对解释造成不利影响"_$c(10)_" "_$c(10)_"窦性心律"_$c(10)_" "_$c(10)_"窦率 60-100 次/分钟"_$c(10)_" "_$c(10)_"QRS 低电压"_$c(10)_" "_$c(10)_" I-III、aVR-aVF  中的 QRS; 0.5 毫伏，或者所有导联中的 QRS; 1.0 毫伏"_$c(10)_" "_$c(10)_"临界 ECG"_$c(10)_" "_$c(10)_"临界 ECG"_$c(10)_"窦性心律"_$c(10)_"窦性心律 正常心电图"_$c(10),"12-^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^","13-2015-01-27 14:51:15",14-2,"15-","16-2015-01-23 09:07:17","17-","18-",19-2,"20-17","21-","22-402机密^正部级","","","",0,"9999-12-31 23:59:59","","")
	set examInfo=^dbo.tblExaminationD(examId) //获取到examination表的信息
	quit:examInfo="" "dbo.tblExamination信息为空"
	
	set parRestId=""
	set parRestId=$o(^dbo.tblParamRestI("idxExaminationID",examId,parRestId))
	
	if parRestId'="" do
	.set parRestInfo=^dbo.tblParamRestD(parRestId) //$lb("1-",2-81,3-0,4-1,"5-",6-0,7-182,8-60,9-97,10-367,11-426,"12-0",13-77,"14-0",15-0,16-39,17-81,"","")
	.if parRestInfo'="" do
	..set resultvalueHR=$list(parRestInfo,2)
	
	set dateTime=$list(examInfo,6)
	set date=$zdh($p(dateTime," ",1),3) //日期1
	set time=$zth($p(dateTime," ",2),3) //时间2
	set patid=$list(patInfo,20) //病人id --登记号3
	set paadmid=$list(reqInfo,3) //4
	set reportid=examId //报告号 --examid5
	
	set resultvalueD=$list(examInfo,11) //结果值7-D--取诊断
	
	zn CurrSpace
	
	//心率
	set examitem="HR" //项目6
	
	set unit="bpm" // 心率单位 单位8
	set Input=date_"^"_time_"^"_patid_"^"_paadmid_"^"_
			  reportid_"^"_examitem_"^"_resultvalueHR_"^"_unit_"^"_type
			  
	set ^UpdataOrdInfo("CreateLibData@HR",reportid)=Input
	b ;Input//心率
	set rtn=##class(web.DHCSTPHCMPASS).CreateLibData(Input)
	
	
	
	//诊断
	set examitem="D" //项目6
	
	set unit="" // 为空 单位8
	set Input=date_"^"_time_"^"_patid_"^"_paadmid_"^"_
			  reportid_"^"_examitem_"^"_resultvalueD_"^"_unit_"^"_type
	set ^UpdataOrdInfo("CreateLibData@D",reportid)=Input
	b ;Input//诊断
	set rtn=##class(web.DHCSTPHCMPASS).CreateLibData(Input)
	
	quit rtn
}

// 报告修改 调子病历评级开发 xzy

ClassMethod SetRptModifyStatus(OrdIds As %String, IsModify As %String) As %String
{
	set return = "-1^失败"
	set return=..PortalUnReadReport(OrdIds,IsModify)
	
	quit return
}

// 设置报告已读状态

// w ##class(web.DHCEkgService).SetRtpReadedStatus("35||21^455")

ClassMethod SetRtpReadedStatus(info As %String) As %String
{
	
	s OrdIds=$p(info,"^",1)
	s userID=$p(info,"^",2)
	
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","SetRtpReadedStatus",$zd($h,3),$zt($p($h,",",2),1),info,"params")
	s return = "-1^失败"
	q:OrdIds="" return
	q:userID="" return
	
	s studyNo="EKG||"_OrdIds
	s OrderRowid=$p(OrdIds,"||",1)
	s itemsub=$p(OrdIds,"||",2)
	s RecLocId=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",5)
	s paadmdr=$p(^OEORD(OrderRowid),"^",1)
	s papatmasmdr=$p(^PAADM(paadmdr),"^",1)      
    s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
    s paramInfo=RecLocId_"^^"_RegNo_"^"_studyNo_"^"_userID_"^"_OrdIds
    
    //本机8.1his缺少接口
	/*
	;Input:Model(I图像/R报告),Params(接收科室^登录科室^登记号^检查号^阅读人user表rowid^医嘱ID)[接收科室可传空]
	;s rtn= ##class(web.DHCEMInterface).ClinicRecordSet("R",paramInfo) ;2020-02-24，修改接口类命名
	s rtn= ##class(web.DHCAPPInterface).ClinicRecordSet("R",paramInfo)
	q rtn
	*/
	
	
	set OEORowid=OrdIds
	set studyNo="EKG||"_OrdIds
	if userID'="" set docCode=$p(^SSU("SSUSR",userID),"^",1)
	else  set docCode="" 
	set checkStatus="Y"
	set ^tmpSetRtpReadedStatusInfo21=OEORowid_"||"_studyNo_"||"_docCode_"||"_checkStatus
	b ;^tmpSetRtpReadedStatusInfo21
	;set return=##class(DtPortal.Doctor.ClinicPrompt.UnReadReportService).SetPortalRPTCheckedByOEORowid(OEORowid,studyNo,docCode,checkStatus)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","SetRtpReadedStatus",$zd($h,3),$zt($p($h,",",2),1),OEORowid_","_studyNo_","_docCode_","_checkStatus,OEORowid,"SetPortalRPTCheckedByOEORowid")
	set return=##class(RISService.ReadReportInfo).SetPortalRPTCheckedByOEORowid(OEORowid,studyNo,docCode,checkStatus)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","SetRtpReadedStatus",$zd($h,3),$zt($p($h,",",2),1),return,OEORowid,"rtn")
	if $p(return,"^",1)="1" set return="0" //成功
	else  set return="-1^失败"	
	quit return
}

// ----电子病历 密码--------------

/// 获取密码最小长度限制
ClassMethod GetPasswordMinLength() As %String
{
	s return=##class(web.CFSM).GetPasswordMinLength()
	q return
}

/// 获取密码规则和时效
/// 参数为PwdContainWordAndNum获取是否必须包含数字与字母
/// 参数为PwdValidInterval获取密码时效性间隔
ClassMethod GetFieldValue(sign As %String) As %String
{
	s return=##class(websys.Configuration).GetFieldValue(sign)
	q return
}

/// 密码连续错误次数
ClassMethod GetInvalidLoginAttempts() As %String
{
	s return=##class(web.CFSM).GetInvalidLoginAttempts()
	if ((return="")!(return="0")!(return="1")) s return="5"
	q return
}

// -----电子病历 密码-------------

// 危急值

ClassMethod SaveEmergency(ExamID As %String, RowID As %String, Date As %String, Time As %String, Doctor As %String, Desc As %String, Result As %String) As %String
{
	s params=ExamID_"^"_RowID_"^"_Date_"^"_Time_"^"_Doctor_"^"_Desc_"^"_Result
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","SaveEmergency",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s ExamID="EKG||"_RowID ;此检查号保持与传给PACS的一致
	s RptType="3"
	  
	i Desc'[$c(10) s Desc=Desc_$c(10) ;2015-08-13
	s D=""
	f i=1:1:$l(Desc,$c(10)) d
	.s tmpD=$p(Desc,$c(10),i)
	.i (tmpD'="") d
	..i (D="") s D=tmpD
	..else  s D=D_","_tmpD
	s Desc=D
	
	
	i Result'[$c(10) s Result=Result_$c(10) ;2015-08-13
	s D=""
	f i=1:1:$l(Result,$c(10)) d
	.s tmpD=$p(Result,$c(10),i)
	.i (tmpD'="") d
	..i (D="") s D=tmpD
	..else  s D=D_","_tmpD
	s Result=D
	
	b ;Result Desc
	
	  s userName=$ZCONVERT(Doctor,"U")
	  s userRowID=$o(^SSU("SSUSR",0,"SSUSR_Initials",userName,"")) //获取到ss_user表中的rowid
	  s Doctor=userRowID
	  s RptInfo=Date_"^"_Time_"^"_Doctor_"^"_Desc
	  
	  s OrdID=$P(RowID,"||",1)
	  s AdmNo=$p(^OEORD(OrdID),"^",1)  ;根据医嘱号获取就诊号
	  b ;dhc-app
	  s invokeParam=RptType_","_ExamID_","_AdmNo_","_RowID_","_RptInfo_","_Result
	  d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","SaveEmergency",$zd($h,3),$zt($p($h,",",2),1),invokeParam,OrdID,"invokeParam")
	;s ^tmpEKGEmergency("SaveEmergency",$zdt($h,3))=RptType_","_ExamID_","_AdmNo_","_RowID_","_RptInfo_","_Result
	  
	  ;local
	  ;s rtn=##Class(web.DHCLabPanicResult).Save(RptType,ExamID,AdmNo,RowID,RptInfo,Result) ;旧接口，本地
	  ;临床接口改变
	  s rtn=##Class(web.DHCAntCVResult).Save(RptType,ExamID,AdmNo,RowID,RptInfo,Result)

	  d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","SaveEmergency",$zd($h,3),$zt($p($h,",",2),1),rtn,OrdID,"rtn")
	;s ^tmpEKGEmergency("SaveEmergency",RowID,$zdt($h,3))=RptType_","_ExamID_","_AdmNo_","_RowID_","_RptInfo_","_Result_"结果==>"_rtn
	  q rtn
}

/// 获取医嘱串信息 供常规检查界面调用
/// modify time:2017-05-11
/// modify by xzy：取医嘱部分提取出来变为方法getDHCEKGOrderInfoBylistOrderItem 传入参数之后直接返回串
ClassMethod GetEKGInfoTxtByLRD(LocId As %String, InRegNo As %String, StartDate As %String, Enddate As %String) As %String
{
	s params=LocId_"^"_InRegNo_"^"_StartDate_"^"_Enddate
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetEKGInfoTxtByLRD",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	//, StartDate As %String, Enddate As %String
	s Gettypedesc="",GetRegNo="",GetStudyNo="",GetName="",GetSexDesc="",GetstrAge="",GetstrDOB="",GetstrOrderName="",
	GetStudyWay="",GetPatientStatus="",GetRptID="",GetReportStatus="",GetImgcount="",GetIDCDesc="",
	Getrequestdoc="",GetLocName="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocName="",
	GetVerifyDate="",GetVerifyTime="",GetRoomDesc="",GetRptIsYX="",GetIsTSBL="",GetIsKYBL="",GetstrRegDate="",GetstrRegTime="",
	GetTotalPrice="",GetEQDesc="",GetstrDate="",GetstrTime="",GetstrAccessionNum="",GetIndex="",Getifbed="",GetIPNo="",
	GetWardName="",Getroomdesc="",GetBedNo="",feetype="",BodyDesc="",Getbilled="",GetMainDoc="",GetAssDoc="",paadmdr="",oeorditemdr="",
	GetEQGroupDesc="",GetOldNo="",Required="",SafetynetCardNo="",strMemo="",
	CallStatus="",Number="",GetTelPhone="",GetNum="",GetAssisName="",RoomIndex="",GetReportInfo="",
	(GetItemCode,GetItemRowId)=""
	//如果时间段为空，那么默认取当天到60天前的数据，可根据各医院情况，决定推前多长
	
	
	if StartDate["-" set StartDate=$zdh(StartDate,3)
	if Enddate["-" set Enddate=$zdh(Enddate,3)
	
	if StartDate["/" do
	.set StartDate=$translate(StartDate,"/","-") ;$translate("2015/02/05","/","-")
	.set StartDate=$zdh(StartDate,3)
	
	if Enddate["/" do
	.set Enddate=$translate(Enddate,"/","-")
	.set Enddate=$zdh(Enddate,3)
	
	i (StartDate="") &&(Enddate="")  d
	.s sdate=$p($h,",",1)-15,edate=$p($h,",",1)+2
	e  d
	.;s sdate=$zdh(StartDate,3),edate=$zdh(Enddate,3)+2 //时间限制
	.set sdate=StartDate,edate=Enddate
	
	;i (StartDate="") &&(Enddate="")  d
	;.s sdate=$p($h,",",1)-15,edate=$p($h,",",1)
	;e  d
	;.s sdate=$zdh(StartDate,3),edate=$zdh(Enddate,3) //时间限制
	set rtn=""
    s ExmLocID=LocId
	//f date=StdDate:1:EndDate d
    s Number=""  //在此处检索的数据应该不是属于预约的了，所以预约号为空
    set listOrderItemBody=""
 	s PriorityDR=0 f  s PriorityDR=$o(^OEORDi(0,"LocStDtPr",ExmLocID,PriorityDR)) q:PriorityDR=""  d
 	.q:PriorityDR'=3  ///3为临时医嘱，非临时医嘱过滤	
 	.;s date=sdate f  s date=$o(^OEORDi(0,"LocStDtPr",ExmLocID,PriorityDR,date)) Q:date=""   d
 	.;.i date>edate q	
 	.s date=edate f  s date=$o(^OEORDi(0,"LocStDtPr",ExmLocID,PriorityDR,date),-1) Q:date=""   d
 	..i date<sdate q
 	..;w "-PriorityDR-"_PriorityDR_"++"
    ..s OrderRowid=0 f  s OrderRowid=$o(^OEORDi(0,"LocStDtPr",ExmLocID,PriorityDR,date,OrderRowid)) q:OrderRowid=""  d
    ...;w "-OrderRowid-"_OrderRowid_"++"
    ...s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
    ...q:(paadmdr="")
	...q:'$D(^PAADM(paadmdr))
	...s papatmasmdr=$p($g(^PAADM(paadmdr)),"^",1)
	...q:(papatmasmdr="")!'$D(^PAPER(papatmasmdr))  
	...s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)
	...q:RegNo'=InRegNo
	...;w "-RegNo-"_RegNo_"++" ,如果登记号不匹配也不继续查找
    ...s itemsub=0 f  s itemsub=$o(^OEORDi(0,"LocStDtPr",ExmLocID,PriorityDR,date,OrderRowid,itemsub)) q:itemsub=""  d
    ....;---------------------copy from QueryByLoc..
    ....;s GetIDCDesc=##class(web.DHCEkgPatientInfo).GetDiagnose(paadmdr)
    ....;w "-GetIDCDesc-"_GetIDCDesc
    ....;s PatInfo=##class(web.DHCEkgPatientInfo).GetPaadmInfo(paadmdr)
    ....;w PatInfo_"----"
    ....;s ordInfo=##class(web.DHCEkgOeorditem).GetOeorditminfo(OrderRowid,itemsub)
    
    ....set listOrderItem=OrderRowid_"||"_itemsub
    ....if (listOrderItemBody="") set listOrderItemBody=listOrderItem
    ....else  set listOrderItemBody=listOrderItemBody_"@"_listOrderItem
    
    set rtn=..getDHCEKGOrderInfoBylistOrderItem(listOrderItemBody)
    
    d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetEKGInfoTxtByLRD",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	quit rtn
}

// 危急值

/*
ClassMethod GetEKGInfoTxtByLRD(LocId As %String, InRegNo As %String, StartDate As %String, Enddate As %String) As %String
{
	//, StartDate As %String, Enddate As %String
	s Gettypedesc="",GetRegNo="",GetStudyNo="",GetName="",GetSexDesc="",GetstrAge="",GetstrDOB="",GetstrOrderName="",
	GetStudyWay="",GetPatientStatus="",GetRptID="",GetReportStatus="",GetImgcount="",GetIDCDesc="",
	Getrequestdoc="",GetLocName="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocName="",
	GetVerifyDate="",GetVerifyTime="",GetRoomDesc="",GetRptIsYX="",GetIsTSBL="",GetIsKYBL="",GetstrRegDate="",GetstrRegTime="",
	GetTotalPrice="",GetEQDesc="",GetstrDate="",GetstrTime="",GetstrAccessionNum="",GetIndex="",Getifbed="",GetIPNo="",
	GetWardName="",Getroomdesc="",GetBedNo="",feetype="",BodyDesc="",Getbilled="",GetMainDoc="",GetAssDoc="",paadmdr="",oeorditemdr="",
	GetEQGroupDesc="",GetOldNo="",Required="",SafetynetCardNo="",strMemo="",
	CallStatus="",Number="",GetTelPhone="",GetNum="",GetAssisName="",RoomIndex="",GetReportInfo="",
	(GetItemCode,GetItemRowId)=""
	//如果时间段为空，那么默认取当天到60天前的数据，可根据各医院情况，决定推前多长
	
	
	if StartDate["-" set StartDate=$zdh(StartDate,3)
	if Enddate["-" set Enddate=$zdh(Enddate,3)
	
	if StartDate["/" do
	.set StartDate=$translate(StartDate,"/","-") ;$translate("2015/02/05","/","-")
	.set StartDate=$zdh(StartDate,3)
	
	if Enddate["/" do
	.set Enddate=$translate(Enddate,"/","-")
	.set Enddate=$zdh(Enddate,3)
	
	i (StartDate="") &&(Enddate="")  d
	.s sdate=$p($h,",",1)-15,edate=$p($h,",",1)+2
	e  d
	.;s sdate=$zdh(StartDate,3),edate=$zdh(Enddate,3)+2 //时间限制
	.set sdate=StartDate,edate=Enddate
	
	;i (StartDate="") &&(Enddate="")  d
	;.s sdate=$p($h,",",1)-15,edate=$p($h,",",1)
	;e  d
	;.s sdate=$zdh(StartDate,3),edate=$zdh(Enddate,3) //时间限制
	set rtn=""
    s ExmLocID=LocId
	//f date=StdDate:1:EndDate d
    s Number=""  //在此处检索的数据应该不是属于预约的了，所以预约号为空
 	s PriorityDR=0 f  s PriorityDR=$o(^OEORDi(0,"LocStDtPr",ExmLocID,PriorityDR)) q:PriorityDR=""  d
 	.q:PriorityDR'=3  ///3为临时医嘱，非临时医嘱过滤	
 	.;s date=sdate f  s date=$o(^OEORDi(0,"LocStDtPr",ExmLocID,PriorityDR,date)) Q:date=""   d
 	.;.i date>edate q	
 	.s date=edate f  s date=$o(^OEORDi(0,"LocStDtPr",ExmLocID,PriorityDR,date),-1) Q:date=""   d
 	..i date<sdate q
 	..;w "-PriorityDR-"_PriorityDR_"++"
    ..s OrderRowid=0 f  s OrderRowid=$o(^OEORDi(0,"LocStDtPr",ExmLocID,PriorityDR,date,OrderRowid)) q:OrderRowid=""  d
    ...;w "-OrderRowid-"_OrderRowid_"++"
    ...s paadmdr=$p(^OEORD(OrderRowid),"^",1)
	...q:'$D(^PAADM(paadmdr))
	...s papatmasmdr=$p($g(^PAADM(paadmdr)),"^",1)
	...q:(papatmasmdr="")!'$D(^PAPER(papatmasmdr))  
	...s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)
	...q:RegNo'=InRegNo
	...;w "-RegNo-"_RegNo_"++" ,如果登记号不匹配也不继续查找
    ...s itemsub=0 f  s itemsub=$o(^OEORDi(0,"LocStDtPr",ExmLocID,PriorityDR,date,OrderRowid,itemsub)) q:itemsub=""  d
    ....;---------------------copy from QueryByLoc..
    ....s GetIDCDesc=##class(web.DHCEkgPatientInfo).GetDiagnose(paadmdr)
    ....;w "-GetIDCDesc-"_GetIDCDesc
    ....s PatInfo=##class(web.DHCEkgPatientInfo).GetPaadmInfo(paadmdr)
    ....;w PatInfo_"----"
    ....s ordInfo=##class(web.DHCEkgOeorditem).GetOeorditminfo(OrderRowid,itemsub)
    ....;w ordInfo
    ....//s ^liuwei(1)=PatInfo
    ....s GetRegNo=$p(PatInfo,"^",1)
    ....s GetName=$p(PatInfo,"^",2)
    ....//GetStudyNo暂时没用到，用于姓名缩写，便于一些纯英文软件无法注入中文或显示时用
    ....s GetStudyNo=$p(PatInfo,"^",27)
    ....s GetstrDOB=$p(PatInfo,"^",3)
    ....s GetstrAge=$p(PatInfo,"^",4)
    ....s GetstrAge=$p(GetstrAge," ")
 	....s GetSexDesc=$p(PatInfo,"^",5)
    ....s Getpatienttype=$p(PatInfo,"^",6)
    ....s Gettypedesc=$p(PatInfo,"^",7)
    ....s GetLocName=$p(PatInfo,"^",8)
    ....s GetIPNo=$p(PatInfo,"^",9)       ;住院号
    ....s GetWardName=$p(PatInfo,"^",10)
    ....s GetBedNo=$p(PatInfo,"^",11)
    ....s GetReqLocDR=$p(PatInfo,"^",12)
    ....s GetWardDR=$p(PatInfo,"^",14)
    ....s Getroomdesc=$p(PatInfo,"^",15)
    ....s GetSexDr=$p(PatInfo,"^",13)
    ....s SafetynetCardNo=$p(PatInfo,"^",23)
    ....s GetTelPhone=$p($g(PatInfo),"^",19)
    ....;q:(Age'="")&(GetstrAge'=Age)
    ....;q:(WardDR'="")&(WardDR'=GetWardDR)  ;病区
    ....;q:(InRegNo'="")&(GetRegNo'=InRegNo) ;登记号
    ....;q:(InName'="")&(GetName'[InName)    ; 姓名
    ....;q:(zyh'="")&(zyh'=GetIPNo)          ;住院号
    ....;q:(InSexDR'="")&(GetSexDr'=InSexDR)
    ....;q:(InReqLocDR'="")&(GetReqLocDR'=InReqLocDR)     ;申请科室
    ....;q:(PatTypeDR'="")&(PatTypeDR'=Getpatienttype)  ;病人类型
    ....s GetstrOrderName=$p(ordInfo,"^",1)
    ....s GetItemCode=$p(ordInfo,"^",24)
    ....s GetItemRowId=$p(ordInfo,"^",23)
    ....s GetstrOrderName=GetItemRowId_"#"_GetItemCode_"#"_GetstrOrderName
    ....//q:GetstrOrderName'[("心电图")
    ....s DHCRisSystemInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
    ....i DHCRisVersion="BJ_FX" d
    .....s strOrdItemMemo=##class(web.DHCEkgApplication).GetOrdItemMemo(oeorditemdr)
    .....i ((strOrdItemMemo'="")&(strOrdItemMemo'=" ")) s GetstrOrderName=GetstrOrderName_"(备注:"_strOrdItemMemo_")"
    ....s GetstrDate=$p(ordInfo,"^",2)
    ....s GetstrTime=$p(ordInfo,"^",3)
    ....s Getrequestdoc=$p(ordInfo,"^",4)
    ....s GetstrAccessionNum=$p(ordInfo,"^",5)
    ....s GetSGroupDesc=$p(ordInfo,"^",6)    ;是否需要预约项目的标记
    ....s GetsubCatDesc=$p(ordInfo,"^",7)
    ....s GetCatDesc=$p(ordInfo,"^",8)
    ....s Getifbed=$p(ordInfo,"^",9)
    ....s Getprice=$p(ordInfo,"^",10)
    ....s GetNum=$p(ordInfo,"^",11)
    ....s GetTotalPrice=$p(ordInfo,"^",12)
    ....s Getbilled=$p(ordInfo,"^",13)   //费别
    ....s GetItemStatusCode=$p(ordInfo,"^",14)
    ....s GetordDate=$p(ordInfo,"^",15)
    ....s GetordTime=$p(ordInfo,"^",16)
    ....s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
    ....q:(GetItemStatusCode="D")
    ....q:(GetItemStatusCode="C")
    ....q:(GetItemStatusCode="U")
    ....i GetItemStatusCode="V" s GetItemStatusCode=GetItemStatusCode_"#核实"
    ....i GetItemStatusCode="E" s GetItemStatusCode=GetItemStatusCode_"#执行"
    ....i GetItemStatusCode="D" s GetItemStatusCode=GetItemStatusCode_"#停止"
    ....s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记
    ....s strMemo=$p(ordInfo,"^",21)
    ....s IsDB = 1  ;哈医大，急诊(门诊)担保押金,门诊病人且医嘱为核实状态
    ....s DHCRisVersion=""
    ....i (Getpatienttype="O")&(GetItemStatusCode="V") d
    .....s DHCRisSystemInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
    .....s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
    .....i DHCRisVersion="HRB_HYD" d
    ......s DBMoney=0
    ......s DBMoney= $$GetAmtOP^|"meddata"|PCHCOLLS(paadmdr)
    ......s IsDB=(DBMoney>0)
    .....i DHCRisVersion="BJ_FX" d ;复兴医院门诊押金病人未缴费可以做检查
    ......Set CurrentNS=$ZNSPACE
    ......d ##class(web.DHCEkgSystemParam).SetMedTrakNameSpace()
    ......s IsDB= $$CheckDepositADM^CHOPDeposit(paadmdr)
    ......zn CurrentNS
    ....;q:(RequireAppoint="Y")&(GetSGroupDesc="不预约")
    ....;q:(IsBedOrd="Y")&(Getifbed'="Y")  ;检索床旁医嘱，不是床旁医嘱
    ....s SystemParamInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
    ....s SendApptoLoc=$p(SystemParamInfo,"^",3)  ;没写申请单,是否发检查医嘱到检查科室
    ....s SendInPtoLoc=$p(SystemParamInfo,"^",4)  ;没收费是否把住院病人的检查项目发送到检查科室  
    ....s SendOutPtoLoc=$p(SystemParamInfo,"^",5) ;没收费是否把门诊检查项目发送到检查科室
    ....s SendEmPtoLoc=$p(SystemParamInfo,"^",6)   ;没收费是否把急诊病人检查项目发送到检查科室
    ....s QueryonlyExam=$p(SystemParamInfo,"^",9)  ;是否只查询检查项目
    ....s SendHPtoLoc=$p(SystemParamInfo,"^",10)   ;没收费是否把体检病人的检查项目发送检查科室
    ....;q:(SendInPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="I")    ;住院病人没有付费的退出
    ....q:(SendOutPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="O")&(IsDB=0)   ;门诊病人没有付费退出
    ....;q:(SendOutPtoLoc="Y")&(Getpatienttype="O")&((IsDB=0)&(Getbilled'="P")&(DHCRisVersion="HRB_HYD"))   ;门诊病人(HYD急诊)没有押金担保而且没有付费退出
    ....;q:(SendOutPtoLoc="Y")&(Getpatienttype="O")&((IsDB=0)&(Getbilled'="P")&(DHCRisVersion="BJ_FX"))   ;门诊病人(复兴)没有押金而且没有付费退出
    ....;q:(SendEmPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="E")   ;急症病人没付费退出
    ....;q:(SendHPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="H")   ;体检病人没付费退出
    ....;q:(QueryonlyExam="Y")&(GetServerMaterial'="S") ;不是检查项目的则退出
    ....;------------------------------------------------------------------
    ....s GetPatientStatusCode="A"
    ....s GetReportStatusCode="N"
    ....s Getapprowid="" //,GetStudyNo=""
    ....s GetRoomDr="",Getapprowid=""
    ....s GetImgcount="",GetMainDoc="",GetAssDoc=""
    ....s GetRptID="",GetRptVersion="",GetRptIsYX="",GetEQGroupDesc="",GetOldNo=""
    ....s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
    ....s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",GetStudyDescDR=""
    ....s GetStudyWay="",GetBodyPartDR="",GetIsKYBL="",GetIsTSBL="",GetResultDesc="",GetExamDesc=""
    ....s GetIndex="",GetstrRegDate="",GetstrRegTime="",GetEQDr="",GetEQDesc="",GetRoomDesc="",GetEQGroupDR="",GetMainSSuserdr="",BodyDesc=""
    ....s GetAssisName=""
    ....;--------------------------------------------------------------------
    ....i (GetItemStatusCode="V")!(GetItemStatusCode="E") d
    .....s GetRejDR=$o(^DHCRBRejecti("OeordDR",oeorditemdr,0))
	.....i GetRejDR'="" d
	......s GetPatientStatusCode="R" ;拒绝申请
	.....else  d
	......i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" s Getapprowid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)  ; 已经预约RB_Appointment Rowid
	.....q:(Getapprowid'="")&(Getapprowid'=$c(0))   ;预约过的医嘱则退出 
	.....s GetImgcount=0
	.....;i GetItemStatusCode="E"  d  ; 医嘱执行
	.....;s GetPatientStatusCode="I"
	.....//s GetStudyNo=""                  ;登记,用于存放姓名缩写
	.....//s RegInfo=##class(web.DHCEkgRegister).GetRegInfo(oeorditemdr)
    .....//s GetStudyNo=$p(RegInfo,"^",1)
    ....Do OutRow14
   Quit rtn ;$$$OK
OutRow14
 	s Required=""
   	if (GetSGroupDesc="无需预约")!(GetstrOrderName["床旁") s Required="N"
   	/*
  	set Data=$lb(Gettypedesc,GetRegNo,GetStudyNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetstrOrderName,
	GetStudyWay,GetPatientStatus,GetRptID,GetReportStatus,GetImgcount,GetIDCDesc,
	Getrequestdoc,GetLocName,GetRptDocName,GetRptDate,GetRptTime,GetVerifyDocName,
	GetVerifyDate,GetVerifyTime,GetRoomDesc,GetRptIsYX,GetIsTSBL,GetIsKYBL,GetstrRegDate,GetstrRegTime,
	GetTotalPrice,GetEQDesc,GetstrDate,GetstrTime,GetstrAccessionNum,GetIndex,"","","",Getifbed,GetIPNo,
	GetWardName,Getroomdesc,GetBedNo,feetype,BodyDesc,Getbilled,GetMainDoc,GetAssDoc,paadmdr,oeorditemdr,
	GetEQGroupDesc,GetOldNo,Required,SafetynetCardNo,strMemo,
	CallStatus,Number,GetTelPhone,GetNum,GetAssisName,RoomIndex,GetReportInfo)
    ///*
    //set DataEx=DataEx
    set DataEx=Gettypedesc_"^"_GetRegNo_"^"_GetStudyNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetstrDOB_"^"_GetstrOrderName
	_"^"_GetStudyWay_"^"_GetPatientStatus_"^"_GetRptID_"^"_GetReportStatus_"^"_GetImgcount_"^"_GetIDCDesc
	_"^"_Getrequestdoc_"^"_GetLocName_"^"_GetRptDocName_"^"_GetRptDate_"^"_GetRptTime_"^"_GetVerifyDocName
	_"^"_GetVerifyDate_"^"_GetVerifyTime_"^"_GetRoomDesc_"^"_GetRptIsYX_"^"_GetIsTSBL_"^"_GetIsKYBL_"^"_GetstrRegDate_"^"_GetstrRegTime
	_"^"_GetTotalPrice_"^"_GetEQDesc_"^"_GetstrDate_"^"_GetstrTime_"^"_GetstrAccessionNum_"^"_GetIndex_"^"_""_"^"_""_"^"_""_"^"_Getifbed_"^"_GetIPNo
	_"^"_GetWardName_"^"_Getroomdesc_"^"_GetBedNo_"^"_feetype_"^"_BodyDesc_"^"_Getbilled_"^"_GetMainDoc_"^"_GetAssDoc_"^"_paadmdr_"^"_oeorditemdr
	_"^"_GetEQGroupDesc_"^"_GetOldNo_"^"_Required_"^"_SafetynetCardNo_"^"_strMemo
	_"^"_CallStatus_"^"_Number_"^"_GetTelPhone_"^"_GetNum_"^"_GetAssisName_"^"_RoomIndex_"^"_GetReportInfo
	_"^"_GetItemStatusCode
    
    
    ///将接口信息写到临时globe，便于核对数据，最大200条
    s disc="来源^登记号^^姓名^性别^年龄^出生日期^^^^^^^^^^^^^^^^^^^^^^价格^^^^^^^^^^^病区^^^^^是否收费^^^^^^^^^^^^^^^^^"
    s TMPStr=DataEx
    s Tstr=""
    f i=1:1:$l(TMPStr,"^") d
    .s PLIST(i)=i_"-"_$p(disc,"^",i)_"/"_$p(TMPStr,"^",i)
    .s Tstr=Tstr_PLIST(i)_"^"   
    i '$d(^TMPEKG("INFO")) d
    .s ^TMPEKG("INFO",+$h,GetRegNo,1)=Tstr
    e  d
    .s teml=$o(^TMPEKG("INFO",+$h,GetRegNo,""),-1)+1
    .i teml<201 d
    ..s ^TMPEKG("INFO",+$h,GetRegNo,teml)=Tstr
    .e  d
    ..k ^TMPEKG
    ..s ^TMPEKG("INFO",+$h,GetRegNo,1)=Tstr

    
    
    ;w "++++++++"_DataEx_"+++++++++:"
    ;如果是多条记录，用“$”间隔
   	if rtn'="" s rtn=rtn_"$"
    s rtn=rtn_DataEx
 	quit
}
*/
/// Creator：      liupeng
/// CreatDate：    2009-03-04
/// Description：  查询心电医嘱项目
/// Table：        
/// Input：        执行科室id；登记号；起始日期；终止日期
/// Output：       记录
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
/// 2009-03-11	liupeng	增加注释
/// [Previously private]
/// 查询query，然后返回XML
/// 改造之前的GetBookedList，因为之前返回string，存在字符串超长的情况  
/// w ##class(web.DHCEkgService).GetBookedList("343", "", "", "21/04/2013", "23/04/2013")
ClassMethod GetBookedListXML(locId As %String, patID As %String, patName As %String, stdDate As %String, endDate As %String) As %GlobalCharacterStream
{
	// root/Rootdb01
	
	s return = ""
	s strCondition = ""
	
	s patN = ""
	s findStatusCode = ""
	s findStatus = ""
	
	
	i (stdDate="") &&(endDate="")  d
	.s stdDate=$p($h,",",1)-1,endDate=$p($h,",",1)
	
	//拆分查询条件
	s patN = $p(patName,"^",1)
	s findStatusCode = $p(patName,"^",2)
	s findStatus = $p(patName,"^",3)
	
	
	//1.预约、时间
	//"^^^343^B^^^^^^^^false^^^^^^false^false^N^N^^^^预约^^^20/04/2013^23/04/2013^N^N^N"
	//2.预约、病人id、时间
	//"^id111111111^^343^B^^^^^^^^false^^^^^^false^false^N^N^^^^预约^^^20/04/2013^23/04/2013^N^N^N"
	//3.预约、病人id、姓名、时间
	//"^id111111111^^343^B^^^name^^^^^false^^^^^^false^false^N^N^^^^预约^^^20/04/2013^23/04/2013^N^N^N"
	//4.预约、姓名、时间
	//"^^^343^B^^^name^^^^^false^^^^^^false^false^N^N^^^^预约^^^20/04/2013^23/04/2013^N^N^N"
	
	//test 正在申请
	//"^^^343^A^^^^^^^^false^^^^^^false^false^N^N^^^^正在申请^^^20/04/2013^23/04/2013^N^N^N"
		
	//^id111111病人ID/登记号^jch1.5检查号^343科室rowid^B预约状态^^^name2222^^^^^false^^^^^^false^false^N^N^^^^预约^^^20/04/2013^22/04/2013^N^N^N
	//s strCondition = "^"_patID_"^^"_locId_"^B^^^"_patName_"^^^^^false^^^^^^false^false^N^N^^^^预约^^^"_stdDate_"^"_endDate_"^N^N^N"
	
	//d ##class(%ResultSet).RunQuery("web.DHCEkgGetBookList","QueryEkgExamItem","^40243515^^626^^^^苏香丽^^^^^false^^^^^^false^false^N^N^^^^^^^21/04/2013^23/04/2013^N^Y^Y",^TMPRIS12,^TMPRIS13,^TMPRIS14)
	//"^40226467^^343^A^^^^^^^^false^^^^^^false^false^N^N^^^^正在申请^^^20/04/2013^22/04/2013^N^N^N" 
	
	//根据条件查询
	s strCondition = "^"_patID_"^^"_locId_"^"_findStatusCode_"^^^"_patN_"^^^^^false^^^^^^false^false^N^N^^^^"_findStatus_"^^^"_stdDate_"^"_endDate_"^N^N^N"
	
	
	//预约查询条件
	//s strCondition = "^"_patID_"^^"_locId_"^B^^^"_patName_"^^^^^false^^^^^^false^false^N^N^^^^预约^^^"_stdDate_"^"_endDate_"^N^N^N"
	
	//正在申请查询条件
	//s strCondition = "^"_patID_"^^"_locId_"^A^^^"_patName_"^^^^^false^^^^^^false^false^N^N^^^^正在申请^^^"_stdDate_"^"_endDate_"^N^N^N"
	
	//查询所有条件
	//s strCondition = "^"_patID_"^^"_locId_"^^^^"_patName_"^^^^^false^^^^^^false^false^N^N^^^^^^^"_stdDate_"^"_endDate_"^N^N^N"
	
	
	//s strCondition = "^40243515^^626^^^^苏香丽^^^^^false^^^^^^false^false^N^N^^^^^^^21/04/2013^23/04/2013^N^Y^Y"
	//s strCondition = "^40243515^^626^^^^苏香丽^^^^^false^^^^^^false^false^N^N^^^^^^^21/04/2013^23/04/2013^N^Y^Y"
	b ;0

	//BookedType ="" 或者是 0， 是用MEDTRAK 的预约方式 ， 1： 新开发的预约平台的预约方式
	s BookedType = 1
	
	
	s resultString=""
	
	//d ##class(%ResultSet).RunQuery("web.DHCRisWorkBenchDoEx","QueryExamItem","^^^343^A^^^^^^^^false^^^^^^false^false^N^N^^^^正在申请^^^20/04/2013^22/04/2013^N^N^N", "20/04/2013","22/04/2013","1")
	
	s rs=##class(%ResultSet).%New("web.DHCEkgGetBookList:QueryEkgExamItem")
	
	//d rs.Execute(strCondition,stdDate,endDate,BookedType,"","","","","","","","","","","","")
	
	d rs.Execute(strCondition,stdDate,endDate,BookedType)
			
	//Tregno,TName,TSex,TAge,TDob,TDiagonse,TStudyNo,TstrOrderName,TDoctor,TstrAccessionNum,TstrDate,TstrTime,TAppointDate,TAppointstTime,TBookedDuration,TstrRegDate,TstrRegTime,TReportDoc,TReportVerifyDoc,TPatientStatus,Tpaadmdr,TOeorditemdr,TLocName,Tprice,TOEORIItemStatus,TBillStatus,TPatientType,TNum,TPerprice,TIndex,TRegEQ,TBookedRes,Tifbed,TReportStatus,TMainDoc,TAssDoc,TRegRoom,TEQroupDesc,TWardDesc,TNo,TRequired,THopeTime,TOrdStatus,TPatMasDR,TBodyPart,TWeight,TTelNo,TIPNO,TSentFilm,TBedCode,TSendPrint,HasImage,RecLocId,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,BookedUser,PaymentDoc,PlatStatus,TEpissubtype
	k obj,objsub

	
	s objStream=##class(%GlobalCharacterStream).%New()
	d objStream.Write("<WinData>")
	while(rs.Next())
	{
		set objsub=##class(web.EKGBookedList).%New()
		s objsub.Tregno= $g(rs.Data("Tregno"))  //0
		s objsub.TName = $g(rs.Data("TName"))
		s objsub.TSex = $g(rs.Data("TSex"))
		s objsub.TAge = $g(rs.Data("TAge"))
		s objsub.TDob = $g(rs.Data("TDob"))
		s objsub.TDiagonse = $g(rs.Data("TDiagonse"))
		s objsub.TStudyNo = $g(rs.Data("TStudyNo"))
		s objsub.TstrOrderName = $g(rs.Data("TstrOrderName")) //医嘱名7
		s objsub.TDoctor = $g(rs.Data("TDoctor"))
		s objsub.TstrAccessionNum = $g(rs.Data("TstrAccessionNum"))
		s objsub.TstrDate = $g(rs.Data("TstrDate"))
		s objsub.TstrTime = $g(rs.Data("TstrTime"))
		s objsub.TAppointDate = $g(rs.Data("TAppointDate"))  //12预约时间
		s objsub.TAppointstTime = $g(rs.Data("TAppointstTime")) //13
		s objsub.TBookedDuration = $g(rs.Data("TBookedDuration"))
		s objsub.TstrRegDate = $g(rs.Data("TstrRegDate"))
		s objsub.TstrRegTime = $g(rs.Data("TstrRegTime"))
		s objsub.TReportDoc = $g(rs.Data("TReportDoc"))
		s objsub.TReportVerifyDoc = $g(rs.Data("TReportVerifyDoc"))
		s objsub.TPatientStatus = $g(rs.Data("TPatientStatus")) //19病人状态
		s objsub.Tpaadmdr = $g(rs.Data("Tpaadmdr"))  //20
		s objsub.TOeorditemdr = $g(rs.Data("TOeorditemdr"))
		s objsub.TLocName = $g(rs.Data("TLocName"))
		s objsub.Tprice = $g(rs.Data("Tprice"))
		s objsub.TOEORIItemStatus = $g(rs.Data("TOEORIItemStatus"))
		s objsub.TBillStatus = $g(rs.Data("TBillStatus"))
		s objsub.TPatientType = $g(rs.Data("TPatientType"))
		s objsub.TNum = $g(rs.Data("TNum"))
		s objsub.TPerprice = $g(rs.Data("TPerprice"))
		s objsub.TIndex = $g(rs.Data("TIndex"))
		s objsub.TRegEQ = $g(rs.Data("TRegEQ"))
		s objsub.TBookedRes = $g(rs.Data("TBookedRes"))  //预约资源 30
		s objsub.Tifbed = $g(rs.Data("Tifbed"))
		s objsub.TReportStatus = $g(rs.Data("TReportStatus"))
		s objsub.TMainDoc = $g(rs.Data("TMainDoc"))
		s objsub.TAssDoc = $g(rs.Data("TAssDoc"))
		s objsub.TRegRoom = $g(rs.Data("TRegRoom"))
		s objsub.TEQroupDesc = $g(rs.Data("TEQroupDesc"))
		s objsub.TWardDesc = $g(rs.Data("TWardDesc"))
		s objsub.TNo = $g(rs.Data("TNo"))
		s objsub.TRequired = $g(rs.Data("TRequired"))
		s objsub.THopeTime = $g(rs.Data("THopeTime"))
		s objsub.TOrdStatus = $g(rs.Data("TOrdStatus"))
		s objsub.TPatMasDR = $g(rs.Data("TPatMasDR"))
		s objsub.TBodyPart = $g(rs.Data("TBodyPart"))
		s objsub.TWeight = $g(rs.Data("TWeight"))
		s objsub.TTelNo = $g(rs.Data("TTelNo"))
		s objsub.TIPNO = $g(rs.Data("TIPNO"))
		s objsub.TSentFilm = $g(rs.Data("TSentFilm"))
		s objsub.TBedCode = $g(rs.Data("TBedCode"))
		s objsub.TSendPrint = $g(rs.Data("TSendPrint"))
		s objsub.HasImage = $g(rs.Data("HasImage"))
		s objsub.RecLocId = $g(rs.Data("RecLocId"))
		s objsub.RecLoc = $g(rs.Data("RecLoc"))
		s objsub.AutoInputFee = $g(rs.Data("AutoInputFee"))
		s objsub.EndInputFee = $g(rs.Data("EndInputFee"))
		s objsub.Detail = $g(rs.Data("Detail"))
		s objsub.RejectAppReason = $g(rs.Data("RejectAppReason"))
		s objsub.BilledDesc = $g(rs.Data("BilledDesc"))
		s objsub.PinYin = $g(rs.Data("PinYin"))
		s objsub.ToDayOeItem = $g(rs.Data("ToDayOeItem"))
		s objsub.CostRecords = $g(rs.Data("CostRecords"))
		s objsub.AppDate = $g(rs.Data("AppDate"))
		s objsub.BookedUser = $g(rs.Data("BookedUser"))
		s objsub.PaymentDoc = $g(rs.Data("PaymentDoc"))
		s objsub.PlatStatus = $g(rs.Data("PlatStatus"))
		s objsub.TEpissubtype = $g(rs.Data("TEpissubtype"))
			
		//s DataEx = Tregno_"^"_TName_"^"_TSex_"^"_TAge_"^"_TDob_"^"_TDiagonse_"^"_TStudyNo_"^"_TstrOrderName_"^"_TDoctor_"^"_TstrAccessionNum_"^"_TstrDate_"^"_TstrTime_"^"_TAppointDate_"^"_TAppointstTime_"^"_TBookedDuration_"^"_TstrRegDate_"^"_TstrRegTime_"^"_TReportDoc_"^"_TReportVerifyDoc_"^"_TPatientStatus_"^"_Tpaadmdr_"^"_TOeorditemdr_"^"_TLocName_"^"_Tprice_"^"_TOEORIItemStatus_"^"_TBillStatus_"^"_TPatientType_"^"_TNum_"^"_TPerprice_"^"_TIndex_"^"_TRegEQ_"^"_TBookedRes_"^"_Tifbed_"^"_TReportStatus_"^"_TMainDoc_"^"_TAssDoc_"^"_TRegRoom_"^"_TEQroupDesc_"^"_TWardDesc_"^"_TNo_"^"_TRequired_"^"_THopeTime_"^"_TOrdStatus_"^"_TPatMasDR_"^"_TBodyPart_"^"_TWeight_"^"_TTelNo_"^"_TIPNO_"^"_TSentFilm_"^"_TBedCode_"^"_TSendPrint_"^"_HasImage_"^"_RecLocId_"^"_RecLoc_"^"_AutoInputFee_"^"_EndInputFee_"^"_Detail_"^"_RejectAppReason_"^"_BilledDesc_"^"_PinYin_"^"_ToDayOeItem_"^"_CostRecords_"^"_AppDate_"^"_BookedUser_"^"_PaymentDoc_"^"_PlatStatus_"^"_TEpissubtype
			
		
   		;w "++++++++"_DataEx_"+++++++++:"
    	;如果是多条记录，用“$”间隔
   		//if resultString'="" s resultString=resultString_"$"
    	//s resultString=resultString_DataEx
		
		//i resultString'=""  s resultString=resultString_"$"
		;b ;22
		s Status=objsub.XMLExportToStream(.Xml)
		d objStream.CopyFrom(Xml)
	}
	
	d rs.Close()
	
	d objStream.Write("</WinData>")
	quit objStream
	//q resultString
}

ClassMethod GetBookedListCardXML(locId As %String, patID As %String, patName As %String, stdDate As %String, endDate As %String) As %GlobalCharacterStream
{
	// root/Rootdb01
	;set HISID=..GetPmiNoFrCardNo(patID)
	set HISID=##class(web.DHCEkgNo).getRegNoByCardNo(patID)
	s return = ""
	s strCondition = ""
	
	s patN = ""
	s findStatusCode = ""
	s findStatus = ""
	
	
	i (stdDate="") &&(endDate="")  d
	.s stdDate=$p($h,",",1)-1,endDate=$p($h,",",1)
	
	//拆分查询条件
	s patN = $p(patName,"^",1)
	s findStatusCode = $p(patName,"^",2)
	s findStatus = $p(patName,"^",3)
	
	
	//1.预约、时间
	//"^^^343^B^^^^^^^^false^^^^^^false^false^N^N^^^^预约^^^20/04/2013^23/04/2013^N^N^N"
	//2.预约、病人id、时间
	//"^id111111111^^343^B^^^^^^^^false^^^^^^false^false^N^N^^^^预约^^^20/04/2013^23/04/2013^N^N^N"
	//3.预约、病人id、姓名、时间
	//"^id111111111^^343^B^^^name^^^^^false^^^^^^false^false^N^N^^^^预约^^^20/04/2013^23/04/2013^N^N^N"
	//4.预约、姓名、时间
	//"^^^343^B^^^name^^^^^false^^^^^^false^false^N^N^^^^预约^^^20/04/2013^23/04/2013^N^N^N"
	
	//test 正在申请
	//"^^^343^A^^^^^^^^false^^^^^^false^false^N^N^^^^正在申请^^^20/04/2013^23/04/2013^N^N^N"
		
	//^id111111病人ID/登记号^jch1.5检查号^343科室rowid^B预约状态^^^name2222^^^^^false^^^^^^false^false^N^N^^^^预约^^^20/04/2013^22/04/2013^N^N^N
	//s strCondition = "^"_patID_"^^"_locId_"^B^^^"_patName_"^^^^^false^^^^^^false^false^N^N^^^^预约^^^"_stdDate_"^"_endDate_"^N^N^N"
	
	//d ##class(%ResultSet).RunQuery("web.DHCEkgGetBookList","QueryEkgExamItem","^40243515^^626^^^^苏香丽^^^^^false^^^^^^false^false^N^N^^^^^^^21/04/2013^23/04/2013^N^Y^Y",^TMPRIS12,^TMPRIS13,^TMPRIS14)
	//"^40226467^^343^A^^^^^^^^false^^^^^^false^false^N^N^^^^正在申请^^^20/04/2013^22/04/2013^N^N^N" 
	
	//根据条件查询
	s strCondition = "^"_HISID_"^^"_locId_"^"_findStatusCode_"^^^"_patN_"^^^^^false^^^^^^false^false^N^N^^^^"_findStatus_"^^^"_stdDate_"^"_endDate_"^N^N^N"
	
	
	//预约查询条件
	//s strCondition = "^"_patID_"^^"_locId_"^B^^^"_patName_"^^^^^false^^^^^^false^false^N^N^^^^预约^^^"_stdDate_"^"_endDate_"^N^N^N"
	
	//正在申请查询条件
	//s strCondition = "^"_patID_"^^"_locId_"^A^^^"_patName_"^^^^^false^^^^^^false^false^N^N^^^^正在申请^^^"_stdDate_"^"_endDate_"^N^N^N"
	
	//查询所有条件
	//s strCondition = "^"_patID_"^^"_locId_"^^^^"_patName_"^^^^^false^^^^^^false^false^N^N^^^^^^^"_stdDate_"^"_endDate_"^N^N^N"
	
	
	//s strCondition = "^40243515^^626^^^^苏香丽^^^^^false^^^^^^false^false^N^N^^^^^^^21/04/2013^23/04/2013^N^Y^Y"
	//s strCondition = "^40243515^^626^^^^苏香丽^^^^^false^^^^^^false^false^N^N^^^^^^^21/04/2013^23/04/2013^N^Y^Y"
	b ;0

	//BookedType ="" 或者是 0， 是用MEDTRAK 的预约方式 ， 1： 新开发的预约平台的预约方式
	s BookedType = 1
	
	
	s resultString=""
	
	//d ##class(%ResultSet).RunQuery("web.DHCRisWorkBenchDoEx","QueryExamItem","^^^343^A^^^^^^^^false^^^^^^false^false^N^N^^^^正在申请^^^20/04/2013^22/04/2013^N^N^N", "20/04/2013","22/04/2013","1")
	
	s rs=##class(%ResultSet).%New("web.DHCEkgGetBookList:QueryEkgExamItem")
	
	//d rs.Execute(strCondition,stdDate,endDate,BookedType,"","","","","","","","","","","","")
	
	d rs.Execute(strCondition,stdDate,endDate,BookedType)
			
	//Tregno,TName,TSex,TAge,TDob,TDiagonse,TStudyNo,TstrOrderName,TDoctor,TstrAccessionNum,TstrDate,TstrTime,TAppointDate,TAppointstTime,TBookedDuration,TstrRegDate,TstrRegTime,TReportDoc,TReportVerifyDoc,TPatientStatus,Tpaadmdr,TOeorditemdr,TLocName,Tprice,TOEORIItemStatus,TBillStatus,TPatientType,TNum,TPerprice,TIndex,TRegEQ,TBookedRes,Tifbed,TReportStatus,TMainDoc,TAssDoc,TRegRoom,TEQroupDesc,TWardDesc,TNo,TRequired,THopeTime,TOrdStatus,TPatMasDR,TBodyPart,TWeight,TTelNo,TIPNO,TSentFilm,TBedCode,TSendPrint,HasImage,RecLocId,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,BookedUser,PaymentDoc,PlatStatus,TEpissubtype
	k obj,objsub

	
	s objStream=##class(%GlobalCharacterStream).%New()
	d objStream.Write("<WinData>")
	while(rs.Next())
	{
		set objsub=##class(web.EKGBookedList).%New()
		s objsub.Tregno= $g(rs.Data("Tregno"))  //0
		s objsub.TName = $g(rs.Data("TName"))
		s objsub.TSex = $g(rs.Data("TSex"))
		s objsub.TAge = $g(rs.Data("TAge"))
		s objsub.TDob = $g(rs.Data("TDob"))
		s objsub.TDiagonse = $g(rs.Data("TDiagonse"))
		s objsub.TStudyNo = $g(rs.Data("TStudyNo"))
		s objsub.TstrOrderName = $g(rs.Data("TstrOrderName")) //医嘱名7
		s objsub.TDoctor = $g(rs.Data("TDoctor"))
		s objsub.TstrAccessionNum = $g(rs.Data("TstrAccessionNum"))
		s objsub.TstrDate = $g(rs.Data("TstrDate"))
		s objsub.TstrTime = $g(rs.Data("TstrTime"))
		s objsub.TAppointDate = $g(rs.Data("TAppointDate"))  //12预约时间
		s objsub.TAppointstTime = $g(rs.Data("TAppointstTime")) //13
		s objsub.TBookedDuration = $g(rs.Data("TBookedDuration"))
		s objsub.TstrRegDate = $g(rs.Data("TstrRegDate"))
		s objsub.TstrRegTime = $g(rs.Data("TstrRegTime"))
		s objsub.TReportDoc = $g(rs.Data("TReportDoc"))
		s objsub.TReportVerifyDoc = $g(rs.Data("TReportVerifyDoc"))
		s objsub.TPatientStatus = $g(rs.Data("TPatientStatus")) //19病人状态
		s objsub.Tpaadmdr = $g(rs.Data("Tpaadmdr"))  //20
		s objsub.TOeorditemdr = $g(rs.Data("TOeorditemdr"))
		s objsub.TLocName = $g(rs.Data("TLocName"))
		s objsub.Tprice = $g(rs.Data("Tprice"))
		s objsub.TOEORIItemStatus = $g(rs.Data("TOEORIItemStatus"))
		s objsub.TBillStatus = $g(rs.Data("TBillStatus"))
		s objsub.TPatientType = $g(rs.Data("TPatientType"))
		s objsub.TNum = $g(rs.Data("TNum"))
		s objsub.TPerprice = $g(rs.Data("TPerprice"))
		s objsub.TIndex = $g(rs.Data("TIndex"))
		s objsub.TRegEQ = $g(rs.Data("TRegEQ"))
		s objsub.TBookedRes = $g(rs.Data("TBookedRes"))  //预约资源 30
		s objsub.Tifbed = $g(rs.Data("Tifbed"))
		s objsub.TReportStatus = $g(rs.Data("TReportStatus"))
		s objsub.TMainDoc = $g(rs.Data("TMainDoc"))
		s objsub.TAssDoc = $g(rs.Data("TAssDoc"))
		s objsub.TRegRoom = $g(rs.Data("TRegRoom"))
		s objsub.TEQroupDesc = $g(rs.Data("TEQroupDesc"))
		s objsub.TWardDesc = $g(rs.Data("TWardDesc"))
		s objsub.TNo = $g(rs.Data("TNo"))
		s objsub.TRequired = $g(rs.Data("TRequired"))
		s objsub.THopeTime = $g(rs.Data("THopeTime"))
		s objsub.TOrdStatus = $g(rs.Data("TOrdStatus"))
		s objsub.TPatMasDR = $g(rs.Data("TPatMasDR"))
		s objsub.TBodyPart = $g(rs.Data("TBodyPart"))
		s objsub.TWeight = $g(rs.Data("TWeight"))
		s objsub.TTelNo = $g(rs.Data("TTelNo"))
		s objsub.TIPNO = $g(rs.Data("TIPNO"))
		s objsub.TSentFilm = $g(rs.Data("TSentFilm"))
		s objsub.TBedCode = $g(rs.Data("TBedCode"))
		s objsub.TSendPrint = $g(rs.Data("TSendPrint"))
		s objsub.HasImage = $g(rs.Data("HasImage"))
		s objsub.RecLocId = $g(rs.Data("RecLocId"))
		s objsub.RecLoc = $g(rs.Data("RecLoc"))
		s objsub.AutoInputFee = $g(rs.Data("AutoInputFee"))
		s objsub.EndInputFee = $g(rs.Data("EndInputFee"))
		s objsub.Detail = $g(rs.Data("Detail"))
		s objsub.RejectAppReason = $g(rs.Data("RejectAppReason"))
		s objsub.BilledDesc = $g(rs.Data("BilledDesc"))
		s objsub.PinYin = $g(rs.Data("PinYin"))
		s objsub.ToDayOeItem = $g(rs.Data("ToDayOeItem"))
		s objsub.CostRecords = $g(rs.Data("CostRecords"))
		s objsub.AppDate = $g(rs.Data("AppDate"))
		s objsub.BookedUser = $g(rs.Data("BookedUser"))
		s objsub.PaymentDoc = $g(rs.Data("PaymentDoc"))
		s objsub.PlatStatus = $g(rs.Data("PlatStatus"))
		s objsub.TEpissubtype = $g(rs.Data("TEpissubtype"))
			
		//s DataEx = Tregno_"^"_TName_"^"_TSex_"^"_TAge_"^"_TDob_"^"_TDiagonse_"^"_TStudyNo_"^"_TstrOrderName_"^"_TDoctor_"^"_TstrAccessionNum_"^"_TstrDate_"^"_TstrTime_"^"_TAppointDate_"^"_TAppointstTime_"^"_TBookedDuration_"^"_TstrRegDate_"^"_TstrRegTime_"^"_TReportDoc_"^"_TReportVerifyDoc_"^"_TPatientStatus_"^"_Tpaadmdr_"^"_TOeorditemdr_"^"_TLocName_"^"_Tprice_"^"_TOEORIItemStatus_"^"_TBillStatus_"^"_TPatientType_"^"_TNum_"^"_TPerprice_"^"_TIndex_"^"_TRegEQ_"^"_TBookedRes_"^"_Tifbed_"^"_TReportStatus_"^"_TMainDoc_"^"_TAssDoc_"^"_TRegRoom_"^"_TEQroupDesc_"^"_TWardDesc_"^"_TNo_"^"_TRequired_"^"_THopeTime_"^"_TOrdStatus_"^"_TPatMasDR_"^"_TBodyPart_"^"_TWeight_"^"_TTelNo_"^"_TIPNO_"^"_TSentFilm_"^"_TBedCode_"^"_TSendPrint_"^"_HasImage_"^"_RecLocId_"^"_RecLoc_"^"_AutoInputFee_"^"_EndInputFee_"^"_Detail_"^"_RejectAppReason_"^"_BilledDesc_"^"_PinYin_"^"_ToDayOeItem_"^"_CostRecords_"^"_AppDate_"^"_BookedUser_"^"_PaymentDoc_"^"_PlatStatus_"^"_TEpissubtype
			
		
   		;w "++++++++"_DataEx_"+++++++++:"
    	;如果是多条记录，用“$”间隔
   		//if resultString'="" s resultString=resultString_"$"
    	//s resultString=resultString_DataEx
		
		//i resultString'=""  s resultString=resultString_"$"
		;b ;22
		s Status=objsub.XMLExportToStream(.Xml)
		d objStream.CopyFrom(Xml)
	}
	
	d rs.Close()
	
	d objStream.Write("</WinData>")
	quit objStream
	//q resultString
}

/// 查询资源预约情况--xzy
/// w ##class(web.DHCEkgService).GetBookRescoure("1839977||209","344","2013-4-26","超声心动图")
ClassMethod GetBookRescoure(OrdId As %String, LocId As %String, BookDate As %String, ResourceName As %String) As %String
{
	s ResourceId = ""
	
	s ResourceId = ..GetResourceId(LocId, ResourceName)
	
	
	set:BookDate["-" BookDate=$zdh(BookDate, 3)
	set:BookDate["/" BookDate=$zdh(BookDate, 4)
	
	s resultString=""
		
	s rs=##class(%ResultSet).%New("web.DHCRisResourceApptSchudle:QueryResApptSchdule")
		
	d rs.Execute(OrdId,LocId,ResourceId,BookDate)
			
	//BookedDate,TimeDesc,ServiceGroupDesc,StartTime,EndTime,Resource,MaxNumber,UseNumber,RemainNumber,AutoNumber,AutoUseNumber,Rowid,ChargeTime,BKPIndex,PNumbe
	while(rs.Next())
	{
		s BookedDate = $g(rs.Data("BookedDate"))
		s TimeDesc = $g(rs.Data("TimeDesc"))
		s ServiceGroupDesc = $g(rs.Data("ServiceGroupDesc"))
		s StartTime = $g(rs.Data("StartTime"))
		s EndTime = $g(rs.Data("EndTime"))
		s Resource = $g(rs.Data("Resource"))
		s MaxNumber = $g(rs.Data("MaxNumber"))
		s UseNumber = $g(rs.Data("UseNumber"))
		s RemainNumber = $g(rs.Data("RemainNumber"))
		s AutoNumber = $g(rs.Data("AutoNumber"))
		s AutoUseNumber = $g(rs.Data("AutoUseNumber"))
		s Rowid = $g(rs.Data("Rowid"))
		s ChargeTime = $g(rs.Data("ChargeTime"))
		s BKPIndex = $g(rs.Data("BKPIndex"))
		s PNumbe = $g(rs.Data("PNumbe"))
		
		s DataEx = BookedDate_"^"_TimeDesc_"^"_ServiceGroupDesc_"^"_StartTime_"^"_EndTime_"^"_Resource_"^"_MaxNumber_"^"_UseNumber_"^"_RemainNumber_"^"_AutoNumber_"^"_AutoUseNumber_"^"_Rowid_"^"_ChargeTime_"^"_BKPIndex_"^"_PNumbe
		
		//s DataEx = Tregno_"^"_TName_"^"_TSex_"^"_TAge_"^"_TDob_"^"_TDiagonse_"^"_TStudyNo_"^"_TstrOrderName_"^"_TDoctor_"^"_TstrAccessionNum_"^"_TstrDate_"^"_TstrTime_"^"_TAppointDate_"^"_TAppointstTime_"^"_TBookedDuration_"^"_TstrRegDate_"^"_TstrRegTime_"^"_TReportDoc_"^"_TReportVerifyDoc_"^"_TPatientStatus_"^"_Tpaadmdr_"^"_TOeorditemdr_"^"_TLocName_"^"_Tprice_"^"_TOEORIItemStatus_"^"_TBillStatus_"^"_TPatientType_"^"_TNum_"^"_TPerprice_"^"_TIndex_"^"_TRegEQ_"^"_TBookedRes_"^"_Tifbed_"^"_TReportStatus_"^"_TMainDoc_"^"_TAssDoc_"^"_TRegRoom_"^"_TEQroupDesc_"^"_TWardDesc_"^"_TNo_"^"_TRequired_"^"_THopeTime_"^"_TOrdStatus_"^"_TPatMasDR_"^"_TBodyPart_"^"_TWeight_"^"_TTelNo_"^"_TIPNO_"^"_TSentFilm_"^"_TBedCode_"^"_TSendPrint_"^"_HasImage_"^"_RecLocId_"^"_RecLoc_"^"_AutoInputFee_"^"_EndInputFee_"^"_Detail_"^"_RejectAppReason_"^"_BilledDesc_"^"_PinYin_"^"_ToDayOeItem_"^"_CostRecords_"^"_AppDate_"^"_BookedUser_"^"_PaymentDoc_"^"_PlatStatus_"^"_TEpissubtype
			
		
   		;w "++++++++"_DataEx_"+++++++++:"
    	;如果是多条记录，用“$”间隔
   		if resultString'="" s resultString=resultString_"$"
    	s resultString=resultString_DataEx
		
		//i resultString'=""  s resultString=resultString_"$"
		;b ;22
	}
	
	d rs.Close()
	
	q resultString
}

/// 转预约  先取消预约，再预约--xzy
/// /// 函数 CancelBookedInfo
/// 功能：取消预约
/// d ##class(web.DHCRisResourceApptSchudle).CancelBookedInfo()
/// ClassMethod CancelBookedInfo(OrderItemRowid As %String)
/// 函数： InsertBookedInfo
/// 功能： 插入病人的预约信息
/// s ret=##class(web.DHCRisResourceApptSchudle).InsertBookedInfo(^TMP)
/// ClassMethod InsertBookedInfo(Info As %String) As %String
/// {
/// 	s ^DHCRis("Tmp")=Info
/// 	s OrderItemRowid=$p(Info,"^",1)
/// 	s ResSchduleID=$p(Info,"^",2)
/// 	s AppointMethod=$p(Info,"^",3)      ; 1: 手动， 2：自动
/// 	s OherParam=$p($g(Info),"^",4)      //计费标识 HIS
/// 	s ApptUser=$p($g(Info),"^",5)       //预约人
/// ResSchduleID 资源计划rowid
ClassMethod UpdateBookDateTime(OrdId As %String, ResSchduleID As %String) As %String
{
	s info = ""

	s info = OrdId_"^"_ResSchduleID_"^"_"1"_"^"_""_"^"_"" //1：手动模式，修改预约资源后，导致数量超出自动预约设置的数量
	//s info = OrdId_"^"_ResSchduleID_"^"_"2"_"^"_""_"^"_""    //2:自动模式，按照自动预约数量进行分配

	//撤销
	d ##class(web.DHCRisResourceApptSchudle).CancelBookedInfo(OrdId)

	//再预约
	s ret=##class(web.DHCRisResourceApptSchudle).InsertBookedInfo(info)

	q ret
}

/// 查询资源组信息
/// web.DHCRisResourceApptSchudle
/// 获取资源ID
/// Query QueryResource(LocID As %String) As %Query(ROWSPEC = "TResDesc:%String,TRowid:%String")
/// w ##class(web.DHCEkgService).GetResourceId("344","超声心动图")
/// 所有^Simens 超声3268^飞利浦US3269
ClassMethod GetResourceId(LocId As %String, ResourceName As %String) As %String
{
	s resource = ""
	s resource = ##class(web.DHCRisResourceApptSchudle).GetResourceInfo(LocId)
	
	s resName = ""
	s resId = ""
	
	f i=1:1:$length(resource,"^") d
	.s resStr=$p(resource,"^",i)
	.s resName=$p(resStr,$C(1),1)
	.i resName=ResourceName d
	..s resId=$p(resStr,$C(1),2)
	..q
	
	q resId
}

// ========================================================================

// web.DHCEkgService下添加：

// --------------------------------------------

/// Creator：      yangyali
/// CreatDate：    2014-08-11
/// Description:： 获取申请单列表
/// Table：        
/// Input：        
/// Output：       
/// Return：       xml串
/// Others：
/// GetConOder(EpisodeID As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, LocId As %String, ExecFlage As %String, PatLocId As %String, OrdCatId As %String, ArcimId As %String, PatAdmType As %String, PatNames As %String, StarTime As %String, EndTime As %String)
/// w ##class(web.DHCEkgService).GetConOrdXML("85","","","2018-1-18","2018-5-18","","1")
ClassMethod GetConOrdXML(locId As %String, patID As %String, patName As %String, stdDate As %String, endDate As %String, examItemID As %String, execFlag As %String, patientType = "") As %GlobalCharacterStream
{
	;set ^tmpInfo11111=locId_patID_ patName_ stdDate_endDate_examItemID_execFlag
	s params=locId_"^"_patID_"^"_patName_"^"_stdDate_"^"_endDate_"^"_examItemID_"^"_execFlag_"^"_patientType
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetConOrdXML",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	if locId=$c(0) set locId = ""	
	if patID=$c(0) set patID = ""	
	if patName=$c(0) set patName = ""	
	if stdDate=$c(0) set stdDate = ""	
	if endDate=$c(0) set endDate = ""	
	if examItemID=$c(0) set examItemID = ""	
	if execFlag=$c(0) set execFlag = ""	
	if patientType=$c(0) set patientType = ""	
	if execFlag="" set execFlag="0"
	
	set RegNoLength = +##class(web.DHCEkgNo).getRegNoLength() //卡号长度
	set CardNoLength = +##class(web.DHCEkgNo).getCardNoLength() //卡号长度
	set InNoLength = +##class(web.DHCEkgNo).getInNoLength() //住院号长度
	
	if (##class(web.DHCEkgNo).numberIsContainRegNo(patID)="1") set patID=$p(patID,"^",1) do
	.set patID=##class(web.DHCEkgNo).getFullNo(patID,RegNoLength)
	else  if (##class(web.DHCEkgNo).numberIsContainCardNo(patID)="1") set patID=$p(patID,"^",1) do
	.set patID=##class(web.DHCEkgNo).getFullNo(patID,CardNoLength)
	.set patID= ##class(web.DHCEkgNo).getRegNoByCardNo(patID)
	else  if (##class(web.DHCEkgNo).numberIsContainMedCareNo(patID)="1") set patID=$p(patID,"^",1) do
	.set patID=##class(web.DHCEkgNo).getFullNo(patID,InNoLength)
	.set patID= ##class(web.DHCEkgNo).getRegNoByInNo(patID)
    
    if ((patID="")&(patName'="")) do
	.set patID=##class(web.DHCEkgNo).getRegNoByPatName(patName,locId)	
	
	if stdDate="" set stdDate=$p($h,",",1)-5
	else  s stdDate=$zdh(stdDate,3)
	if endDate="" set endDate=$p($h,",",1)+1
	else  s endDate=$zdh(endDate,3)	
	
	k objStream,objsub	
	s objStream=##class(%GlobalCharacterStream).%New()
	d objStream.Write("<WinData>")	
	
	set regNoLen = $l(patID,"^")	
	set tmpPatID=patID	
	set queryPrams=locId_","_patID_","_patName_","_stdDate_","_endDate_","_examItemID_","_execFlag_","_patientType
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetConOrdXML",$zd($h,3),$zt($p($h,",",2),1),queryPrams,"query","params")
	for regNoI=1:1:regNoLen
	{
		set patID=$p(tmpPatID,"^",regNoI)
		s rs=##class(%ResultSet).%New("web.DHCEkgGetConOrd:GetConOder")
		d rs.Execute("",patID,stdDate,endDate,locId, execFlag,"","",examItemID,"","","","",patientType)
		while(rs.Next())
		{
			;set ^tmpGetConOrd("iii")="3333333"
			;b ;RegNo
			set objsub=##class(web.EKGConOrd).%New()
			s objsub.RegNo= $g(rs.Data("RegNo"))  //0
			s objsub.PatName = $g(rs.Data("PatName"))
			s objsub.BedCode = $g(rs.Data("BedCode"))
			s objsub.ArcimDesc = $g(rs.Data("ArcimDesc"))
			s objsub.OeordId = $g(rs.Data("OeordId"))
			s objsub.OrdStatDesc = $g(rs.Data("OrdStatDesc"))
			s objsub.OrcatDesc = $g(rs.Data("OrcatDesc"))
			s objsub.ExecDateTime = $g(rs.Data("ExecDateTime")) //医嘱名7
			s objsub.ExecCtcpDesc = $g(rs.Data("ExecCtcpDesc"))
			s objsub.CtcpDesc = $g(rs.Data("CtcpDesc"))
			s objsub.RecLocDesc = $g(rs.Data("RecLocDesc"))
			s objsub.OrdDateTime = $g(rs.Data("OrdDateTime"))
			s objsub.AdmDep = $g(rs.Data("AdmDep"))  //12预约时间
			s objsub.notes = $g(rs.Data("notes")) //13
			s objsub.OrdUnitCost = $g(rs.Data("OrdUnitCost"))
			s objsub.OrdQty = $g(rs.Data("OrdQty"))
			s objsub.OrdCost = $g(rs.Data("OrdCost"))
			s objsub.admId = $g(rs.Data("admId")) //19病人状态
			;s objsub.Medicare = $g(rs.Data("Medicare"))  //20
			s objsub.Medicare = $g(rs.Data("medcareno"))  //20
			s objsub.OrdBilled = $g(rs.Data("BillStatus"))
			s objsub.OrdBilled = $g(rs.Data("Billed"))
			s objsub.admType = $g(rs.Data("admType"))
			s objsub.Sex=$g(rs.Data("sex"))
			s objsub.Age=$g(rs.Data("age"))
			s objsub.DobDate = $g(rs.Data("dobDate"))		
			s Status=objsub.XMLExportToStream(.Xml)
			d objStream.CopyFrom(Xml)
		}	
		d rs.Close()	
	}	
	d objStream.Write("</WinData>")
	b ; d objStream.OutputToDevice()
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetConOrdXML",$zd($h,3),$zt($p($h,",",2),1),objStream,"rtn")
	quit objStream
}

// ==================================================================

// w ##class(web.DHCEkgService).DHCEKGDetpUserSynchronous("455","1")

ClassMethod DHCEKGDetpUserSynchronous(userName As %String, password As %String) As %String
{
	  set CurrentNS = $ZNSPACE
	  
	  set rtn="-111"
	  
	  //科室操作
	  set ctLocRowId="0" for  set ctLocRowId=$o(^CTLOC(ctLocRowId)) quit:ctLocRowId=""  do
	  .set ctLocInfo=^CTLOC(ctLocRowId)
	  .if ctLocInfo'="" do
	  ..;do ..SetDHCEKGNameSpace()
	  ..do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	  ..set rtn=##Class(dbo.DHCEkgServiceUserDeptOP).DHCEKGDeptOperate(ctLocRowId,ctLocInfo)
	  ..zn CurrentNS
	  
	  //user
	  set userName=$ZCONVERT(userName,"U")
	  set userRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",userName,"")) //获取到ss_user表中的rowid
	  quit:userRowId="" "-111"
	  set userInfo=^SSU("SSUSR",userRowId)
	  quit:userInfo="" "-111"
	  set ctInfo = ^CTLOC($p(userInfo,"^",4))
	  set defaultLoginLocCode=$p(ctInfo,"^",1)
	  set $p(userInfo,"^",4)=defaultLoginLocCode
	  ;b ;bbbb
	  //user 登录的其他科室
	  set otherLoginLocId=""
	  set otherLoginLocCodes=""
	  set OTHLLChildsub="" for  set OTHLLChildsub=$o(^SSU("SSUSR",userRowId,"OTHLL",OTHLLChildsub)) quit:OTHLLChildsub=""  do
	  .set subDeptInfo=^SSU("SSUSR",userRowId,"OTHLL",OTHLLChildsub)
	  .set otherLoginLocId=$p(subDeptInfo,"^",1)
	  .set ctLocInfom=^CTLOC(otherLoginLocId)
	  .if otherLoginLocCodes'="" do
	  ..set otherLoginLocCodes=otherLoginLocCodes_"^"_$p(ctLocInfom,"^",1)
	  .else  do
	  ..set otherLoginLocCodes=$p(ctLocInfom,"^",1)
	  //对user进行操作
	  
	  ;do ..SetDHCEKGNameSpace()
	  do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	  set rtn=##Class(dbo.DHCEkgServiceUserDeptOP).DHCEKGUserOperate(userInfo,otherLoginLocCodes)
	  zn CurrentNS
	  
	  ;set rtn=##Class(dbo.DHCEkgServiceUserDeptOP).DHCEKGDeptOperate()
	  ;set rtn=##Class(dbo.DHCEkgServiceUserDeptOP).DHCEKGUserOperate()
	  
	  ;zn CurrentNS
	  set password = ##class(web.SSUser).Encrypt(password)
	  
	  quit password
}

// w ##class(web.DHCEkgService).userLoginSynchronous("284","1")

/// Creator：      xuzuyuan
/// CreatDate：    2015-3-12
/// ModifyDate：    2020-2-19 增加用户权限
/// Description:： 从HIS验证用户名密码
/// Table：        用户名，密码
/// Input：        
/// Output：       
/// Return：       -111(无此用户或查询出错);-222(密码错误);加密后的密码(验证无误)
/// Others：
/// 2015-03-16	yangyali	增加注释 
ClassMethod userLoginSynchronous(userName As %String, password As %String) As %String
{
	s userRowId=""
	s IsValidUser=""
	s IsValidUser=##class(web.SSUser).IsValidUser(userName,password)
	i (+IsValidUser>0) s userRowId=IsValidUser
	e  s userRowId="-222"	
	s userInfo=^SSU("SSUSR",userRowId)
	s Permission=..GetHisUserType(userRowId)
	s userLoginName=$p(userInfo,"^",1)
	s userName=$p(userInfo,"^",2)
	s userPwd=$p(userInfo,"^",3)
	s userDefaultDeptRowid=$p(userInfo,"^",4)
	i (userDefaultDeptRowid'="") s userDefaultDeptCode=$P(^CTLOC(userDefaultDeptRowid),"^",1)

	s userNote=userLoginName_"^"_userName_"^"_userPwd_"^"_userDefaultDeptCode_"^"_Permission 

	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s rtn=##Class(dbo.DHCEkgServiceUserDeptOP).DHCEKGUserOperateOnlyUser(userNote)
	zn "dhc-app" ;CurrentNS
	
	q userRowId
	/*
	  set CurrentNS = $ZNSPACE
	  
	  set rtn="-111"
	  	  
	  //user
	  set userName=$ZCONVERT(userName,"U")
	  set userRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",userName,"")) //获取到ss_user表中的rowid
	  quit:userRowId="" "-111"   ;^SSUser中无此用户
	  set userInfo=^SSU("SSUSR",userRowId)
	  quit:userInfo="" "-111"
	  
	  //"FJN8793^方建娜^U&dDF1,""7k7k^93^101^^Y^Y^^Y^^^20^359^U&dDF1,""7k7k^^^^Y^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^N^^^^^^^^1^63389^56369^^^^^^^^^^^^^2^N^N^^^^63124^^2^^^^^^^^^^^^^^^^^^
	  //密码验证
	  set pwd=$p(userInfo,"^",3)
	  set tmpPwd=password
	  set password = ##class(web.SSUser).Encrypt(tmpPwd) //加密之后的密码
	  quit:pwd'=password "-222"  ;密码错误
	  set $p(userInfo,"^",3)=tmpPwd
	  
	  ;b ;1
	  
	  set ctInfo = ^CTLOC($p(userInfo,"^",4))
	  set defaultLoginLocCode=$p(ctInfo,"^",1)
	  set $p(userInfo,"^",4)=defaultLoginLocCode
	  ;b ;bbbb
	  
	  s Permission=..GetHisUserType(userRowId)
	  
	  s userLoginName=$p(userInfo,"^",1)
	  s userName=$p(userInfo,"^",2)
	  s userPwd=$p(userInfo,"^",3)
	  s userDefaultDeptCode=$p(userInfo,"^",4)
	  
	  s userNote=userLoginName_"^"_userName_"^"_userPwd_"^"_userDefaultDeptCode_"^"_Permission 
	  
	  do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	  set rtn=##Class(dbo.DHCEkgServiceUserDeptOP).DHCEKGUserOperateOnlyUser(userNote)
	  zn CurrentNS
	  
	  
	  quit password
	  */
}

ClassMethod GetUserRowId(userName As %String) As %String
{
	  set userRowId="-1"
	  	  
	  //user
	  set userName=$ZCONVERT(userName,"U")
	  set userRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",userName,"")) //获取到ss_user表中的rowid
	  quit userRowId
}

ClassMethod IfHisUser(userName As %String) As %String
{
	  
	  set rtn="-111"
	  	  
	  //user
	  set userName=$ZCONVERT(userName,"U")
	  set userRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",userName,"")) //获取到ss_user表中的rowid
	  quit:userRowId="" "-111"   ;^SSUser中无此用户
	  set userInfo=^SSU("SSUSR",userRowId)
	  quit:userInfo="" "-111"
	  
	  quit "1"
}

// w ##class(web.DHCEkgService).updateSSUserPwd("337","12")

// 更新ss_user表中的密码

/// Creator：      xuzuyuan
/// CreatDate：    2015-3-12
/// Description:： 修改密码
/// Table：        
/// Input：        用户名，密码 
/// Output：       
/// Return：       -111(无此用户);加密后的密码(修改密码成功)
/// Others：
/// 2015-03-16	yangyali	增加注释 
ClassMethod updateSSUserPwd(userName As %String, password As %String) As %String
{
	  ;set CurrentNS = $ZNSPACE
	  
	  set rtn="-111"
	  
	  //user
	  set userName=$ZCONVERT(userName,"U")
	  set userRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",userName,"")) //获取到ss_user表中的rowid
	  quit:userRowId="" "-111"
	  set userInfo=$d(^SSU("SSUSR",userRowId))
	  quit:userInfo="" "-111"
	  
	  //"FJN8793^方建娜^U&dDF1,""7k7k^93^101^^Y^Y^^Y^^^20^359^U&dDF1,""7k7k^^^^Y^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^N^^^^^^^^1^63389^56369^^^^^^^^^^^^^2^N^N^^^^63124^^2^^^^^^^^^^^^^^^^^^
	  //密码验证
	  set password = ##class(web.SSUser).Encrypt(password) //加密之后的密码
	  
	  set $p(^SSU("SSUSR",userRowId),"^",3)=password
	  
	  ;b ;1
	  
	  quit password
}

ClassMethod DHCEKGPdfPathOut(EpisodeID As %String) As %String
{
	set pdfPath=""
	if EpisodeID="" set pdfPath="EpisodeID is null" quit pdfPath
	
	 set CurrentNS = $ZNSPACE
	 ;do ..SetDHCEKGNameSpace()
	 do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	 set pdfPath=##Class(dbo.DHCEKGPdfPathOut).DHCEKGPdfPathOut(EpisodeID)
	 zn CurrentNS
	 quit pdfPath
}

ClassMethod DHCEKGPdfFiled(EpisodeID As %String) As %String
{
	new $namespace
	set filed=""
	if EpisodeID="" set pdfPath="EpisodeID is null" quit pdfPath
	
	 set CurrentNS = $ZNSPACE
	 ;do ..SetDHCEKGNameSpace()
	 do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	 set filed=##Class(dbo.DHCEKGPdfPathOut).DHCEKGPdfFiled(EpisodeID)
     zn CurrentNS
	 quit filed
}

ClassMethod DHCEKGPdfPathOutWL(EpisodeID As %String) As %String
{
	set pdfPath=""
	if EpisodeID="" set pdfPath="EpisodeID is null" quit pdfPath
	set CurrentNS = $ZNSPACE
	s OrdRowId=""
	set thisPath=""
	f  s OrdRowId=$o(^OEORD(0,"Adm",EpisodeID,OrdRowId)) q:OrdRowId=""  d
	.;b ;OrdRowId
	.s OrdSubId=0,tmpCount=0
	.f  s OrdSubId=$o(^OEORD(OrdRowId,"I",OrdSubId)) q:OrdSubId=""  d
	..s str=$g(^OEORD(OrdRowId,"I",OrdSubId,1))
	..s examItemExtend=""
	..if (str'="") do
	...s examItemExtend=$p(str,"^",2)
	..s OrdId=OrdRowId_"||"_OrdSubId
	..q:OrdId=""
	..;b ;OrdId
	..do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	..;set thisPath=##Class(dbo.DHCEKGPdfPathOut).DHCEKGPdfPathOutbyOrdID(OrdId)
	..set thisPath=##Class(dbo.DHCEKGPdfPathOut).DHCEKGPdfPathOutbyOrdIDEx(OrdId,examItemExtend)
	..zn CurrentNS
	..q:thisPath=""
	..if (pdfPath'="") set pdfPath=pdfPath_"^"
	..set pdfPath=pdfPath_thisPath
	..;b ;pdfPath
	zn CurrentNS
	q pdfPath
}

// PAPMIRowId就诊号 ErrMsg错误信息

ClassMethod GetPatEncryptLevel(PAPMIRowId As %String, ErrMsg As %String) As %String
{
	;set paadmid=PAPMIRowId //w $p(^PAADM(413),"^",1)
	set PAPMIRowId=$p(^PAADM(PAPMIRowId),"^",1) //传递进来的是paadm id，取paadmas id

	set rtn=##Class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PAPMIRowId,ErrMsg)
	if rtn="" do
	.set rtn="-100错误"
	quit rtn
}

// info=ModelName^Condition^Content^SecretCode^Success^UserId^IP^Mac^CName^LocId^GroupId

ClassMethod EventLog(info As %String) As %String
{
	//w ##class(web.DHCEkgService).EventLog(^tmpDHCEkgEventLog)
	//set ^tmpDHCEkgEventLog	=	"DHCEKGRestPrint^RegNo@0123456789$DateTime@20150122151128^EpisodeId@402$ExamID@2$DateTime@20150122151128^402机密^Y"
	//w ##class(web.DHCEkgService).EventLog("DHCEKGRestPrint^RegNo@0123456789$DateTime@20150122151128^EpisodeId@402$ExamID@2$DateTime@20150122151128^402机密^Y^636^fe80::785f:9898:6af4:4955%22^3C:97:0E:18:87:7C^xzy-pc^^")
	set ^tmpDHCEkgEventLog=info
	set ModelName=$p(info,"^",1)
	
	;if ModelName="DHCEKGLOGIN" do ;登录模块
	;.set SecretCode="1003" //最高级
	;else  do
	;.set SecretCode=$p(info,"^",4)
	
	if ModelName="DHCEKGLOGIN" do ;登录模块
	.set SecretCode="1003" //最高级
	else  do
	.set SecretCodeAlias=$p(info,"^",4) //^User.DHCSecretLevelI("Alias"," A",3) = "" 
	.if SecretCodeAlias'="" set DHCSecretLeveId=$o(^User.DHCSecretLevelI("Alias"," "_SecretCodeAlias,""))
	.if DHCSecretLeveId'="" set SecretCode=$List(^User.DHCSecretLevelD(DHCSecretLeveId),2)
	
	
	set Condition=$p(info,"^",2)
	set Condition=..getJson(Condition)
	
	set Content=$p(info,"^",3)
	set Content=..getJson(Content)
	
	;set SecretCode=$p(info,"^",4)
	set Success=$p(info,"^",5)
	set UserId=$p(info,"^",6) //usercode  SSUSR_Initials
	
	if UserId'="" set UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserId,""))
	
	set IP=$p(info,"^",7)
	set Mac=$p(info,"^",8)
	set CName=$p(info,"^",9)
	set LocId=$p(info,"^",10)
	set GroupId=$p(info,"^",11)
	b ;
	set rtn=##class(web.DHCEventLog).EventLog(ModelName, Condition, Content, SecretCode, Success, UserId, IP, Mac, CName, LocId, GroupId)
	b ;
	quit rtn
}

// Condition Content 多项用$分隔 没项用@分隔 如 DateTime@20150101121212$EpId@1112

ClassMethod getJson(str As %String) As %String
{
	//w ##class(web.DHCEkgService).getJson("DateTime@20150101121212$EpId@1112")
	set length1=$length(str,"$")
	
	set json=""
	set tmpData=""
	
	for i=1:1:length1
	{
		set strPeice=$p(str,"$",i)
	
		set key=$p(strPeice,"@",1)
		set value=$p(strPeice,"@",2)
		
		set tmpData=key_":"_$c(34)_value_$c(34)
		
		if json'="" do
		.set json=json_","_tmpData
		else  do
		.set json=tmpData
		
	}
	
	set json="{"_json_"}"
	
	quit json
}

ClassMethod getRegNoByCardNo(CardNo As %String) As %String
{
	
	set rtn=##Class(web.DHCEkgNo).getRegNoByCardNo(CardNo)
	quit rtn
}

ClassMethod SentResultToTJ(ResultToTJ As %String) As %String
{
	set rtn = ""
	
	//调用平台方法 不用再拼接图片路径，直接返回，因为含有图片路径了
	set Soap=##class(WebRisService.WebRisServiceSoap).%New()
	set rtn =Soap.GetXDReturnReport(ResultToTJ)
	
	;quit resultInfo
	quit rtn
}

// w ##class(web.DHCEkgService).DHCEKGExamNamePdfPathOut("402")

ClassMethod DHCEKGExamNamePdfPathOut(EpisodeID As %String) As %String
{
	new $namespace
	  set CurrentNS = $ZNSPACE
	  
	  set rtn=""
	  
	  ;do ..SetDHCEKGNameSpace()
	  do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	  set rtn=##Class(dbo.DHCEKGPdfPathOut).DHCEKGExamNamePdfPathOut(EpisodeID)
	  zn CurrentNS
	  
	  quit rtn
}

/// UserAuthenticate
/// Creator：      yangyali
/// CreatDate：    2016-8-10
/// Modify: 	   yangyali
/// ModifyDate：   2016-8-25
/// Description:： 判断用户是否已阅读过此医嘱的检查报告
/// Input：        医嘱ID，用户ID（ss_user.rowid）
/// Output：       是否已阅读
/// Return：       返回：Y表示已阅读；N表示未阅读
/// Others：
/// w ##class(web.DHCEkgService).IfRptRead("107||6","105")
ClassMethod IfRptRead(OrdIds As %String, UserId As %String) As %String
{
	;注：医嘱号或用户ID为空，返回Y，不显示"确认已读"按钮
	q:OrdIds="" "Y"
	q:UserId="" "Y"
	//本机8.1版本缺少接口
	/*
	;Input:Params(检查号^医嘱ID^用户ID)[检查号必传,其他参数表示可按照医嘱ID和阅读人判断是否阅读]
	;Return:Y/N
	s studyNo="EKG||"_OrdIds
	s paramInfo=studyNo_"^"_OrdIds_"^"_UserId
	;s rtn= ##class(web.DHCEMInterface).IsReadByParams(paramInfo) ;2020-02-24，修改接口类命名
	s rtn= ##class(web.DHCAPPInterface).IsReadByParams(paramInfo)
	q rtn
	*/
	
	
	set OEORowid=OrdIds
	set studyNo="EKG||"_OrdIds
	if UserId'="" set docCode=$p($g(^SSU("SSUSR",UserId)),"^",1)
	else  set docCode="" 
	set return=##class(RISService.TrakRISService).GetRPTCMStatus(OEORowid,studyNo,docCode)
	set return=$p(return,"^",1)
	quit return
}

ClassMethod MEncrypt(str As %String) As %String
{
	  set rtn=""
	  set rtn=##class(web.SSUser).Encrypt(str)	  
	  quit rtn
}

ClassMethod Md5Encrypt(str As %String) As %String
{
	  set rtn=""
	  set rtn=##class(web.Util.Encryption).MD5HexStr(str)
	  quit rtn
}

/// w ##class(web.DHCEkgService).GetUserGroup("636")
ClassMethod GetUserGroup(userInitial As %String) As %String
{
	  set userInitial=$ZCONVERT(userInitial,"U")
	  set userRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",userInitial,"")) //获取到ss_user表中的rowid
	  quit:userRowId="" "-111"   ;^SSUser中无此用户
	  set userInfo=^SSU("SSUSR",userRowId)
	  set userGroupID=$p(userInfo,"^",5)
	  quit:userGroupID="" "-222"
	  set userGroup=$p(^SSU("SSGRP",userGroupID),"^",1)
	  
	  quit userGroup
}

/// Creator：      yangyali
/// CreatDate：    2016-8-31
/// Modify: 	   yangyali
/// ModifyDate：   2016-8-31
/// Description:   查询病人所有的心电图检查
/// Input：        登记号，住院号，来源
/// Output：       xml串
/// Return：       检查信息
/// Others：
/// w ##class(web.DHCEkgService)DHCEKGExamInfo("0000000249","","I")
ClassMethod DHCEKGExamInfo(PatientCode As %String, InPatientCode As %String, PatSourceCode As %String) As %String
{
	set rtn=""
	set CurrSpace=$ZNSPACE
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	set rtn=##class(dbo.DHCEKGAutoPrtRpt).DHCEKGExamInfo(PatientCode,InPatientCode,PatSourceCode)
	zn CurrSpace
	q rtn
}

/// UserAuthenticate
/// Creator：      yangyali
/// CreatDate：    2016-8-31
/// Modify: 	   yangyali
/// ModifyDate：   2016-8-31
/// Description:   查询流水号对应的报告信息
/// Input：        流水号
/// Output：       xml串
/// Return：       检查信息
/// Others：
/// w ##class(web.DHCEkgService).DHCEKGRptInfo("154")
ClassMethod DHCEKGRptInfo(EXAMId As %String) As %String
{
	set rtn=""
	set CurrSpace=$ZNSPACE
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	set rtn=##class(dbo.DHCEKGAutoPrtRpt).DHCEKGRptInfo(EXAMId)
	zn CurrSpace
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2016-9-1
/// Modify: 	   yangyali
/// ModifyDate：   2016-9-1
/// Description:   查询病人在时间范围内所有的心电图检查
/// Input：        登记号，开始日期，结束日期
/// Output：       xml串
/// Return：       检查信息
/// Others：
/// w ##class(web.DHCEkgService).DHCEKGAutoPrtRptInfo("0000000249","2016-01-05","2016-04-07")
ClassMethod DHCEKGAutoPrtRptInfo(PatientCode As %String, StartDate As %String, Enddate As %String) As %String
{
	new $namespace
	set rtn=""
	if ($l(PatientCode)=12) ;12位，卡号，先获取登记号
	{
		s CardRowId=0,PatId=""
    	f  s CardRowId=$o(^DHCCARDi("CF",0,"CardNo",PatientCode,CardRowId)) q:CardRowId=""  d
    	.i CardRowId'="" s PatientCode=$p(^DHCCARD("CF",CardRowId),"^",6) //取病人的登记号
    	.s flag=$p(^DHCCARD("CF",CardRowId),"^",10)
    	.q:flag'="N"
	}
	
	set CurrSpace=$ZNSPACE
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	set rtn=##class(dbo.DHCEKGAutoPrtRpt).DHCEKGAutoPrtRptInfo(PatientCode, StartDate , Enddate)
	zn CurrSpace
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2016-9-21
/// Modify: 	   yangyali
/// ModifyDate：   2016-9-21
/// Description:   黄岛与浙江远图所做接口，检查结果查询，供集成平台调用
/// Input：        开始日期，结束日期，病人来源，平台流水号，号码类型，卡类型，卡号/住院号
/// Output：       xml流
/// Return：       检查信息
/// Others：
/// w ##class(web.DHCEkgService).GetExamInfo("2016-01-01","2020-09-20","住院","","1","","0000000202")
ClassMethod GetExamInfo(startDate As %String, endDate As %String, visitFrom As %String, platformId As %String, type As %String, cardType As %String, cardNo As %String) As %GlobalCharacterStream
{
	set CurrSpace=$ZNSPACE
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	set rtn=##class(dbo.interface.EkgService).GetExamInfo(startDate, endDate , visitFrom,platformId,type,cardType,cardNo)
	b ; d rtn.OutputToDevice()
	zn CurrSpace
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2016-10-14
/// Description：  调用ris接口保存检查结果
/// Table：        
/// Input：        医嘱ID
/// Output：       调用结果
/// Return：       
/// Others：
/// 2016-10-14	yangyali	增加注释
/// [Previously private]
/// d ##class(web.DHCEkgService).SentRpttoRIS("349||72")
ClassMethod SentRptInfotoRIS(OrdIds) As %String
{
	set rtn=""
	set RID=$Replace(OrdIds,"||","_") ;向PACS表里插入数据，以便电子病历调用检查结果
	set RID=RID_"@"
	set ExamNo="" ;检查号 2
	set Status="" ;检查状态
	set ReportDoctor = "" ;报告医生
	set ArbiterDoctor = "" ;审核医生
	set ReportDateTime = "" ;报告时间
	set ReportDate=""
	set ReportTime=""
	set ArbiterDateTime = "" ;审核时间
	set ArbiterDate=""
	set ArbiterTime=""
	set Diagnose = "" ;诊断内容
	set IfEmergency="N"
	set Positive="N"
	
	set CurrSpace=$ZNSPACE
	;do ..SetDHCEKGNameSpace()
	;do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	ZN "DHC-EKG-SZBA"	
	quit:OrdIds=""	
	set result = ##class(%Library.ResultSet).%New()
	set sqlStr = "select * from dbo.vwGetExaminationList where ekgExamCode= '"_OrdIds_"'" _" ORDER BY ekgArbiterTime desc"
	do result.Prepare(sqlStr) 
	do result.Execute() 
	if result.Next() do	
	.set ExamNo ="EKG||"_OrdIds ;检查号 2
	.set Status=result.Data("ekgStatusCode") ;检查状态
	.set ReportDoctor = result.Data("ekgReportUserID")_"@"_result.Data("ekgReportUserName") ;报告医生
	.set ArbiterDoctor = result.Data("ekgArbiterUserID")_"@"_result.Data("ekgArbiterUserName") ;审核医生
	.set ReportDateTime = result.Data("ekgOperateTime") ;报告时间
	.set ReportDate=$p(ReportDateTime," ",1)
	.set ReportTime=$p(ReportDateTime," ",2)
	.set ArbiterDateTime = result.Data("ekgArbiterTime") ;审核时间
	.set ArbiterDate=$p(ArbiterDateTime," ",1)
	.set ArbiterTime=$p(ArbiterDateTime," ",2)
	.set ekgIsEmergency=result.Data("ekgIsEmergency") ;是否危急
	.if (ekgIsEmergency="1") do
	..set IfEmergency="Y"
	.;set NegativePositive=result.Data("ekgNegativePositive") ;阴性阳性
	.;if (NegativePositive="阳性") do
	.;.set Positive="Y"
	.set Diagnose = result.Data("ekgDiagnosis") ;诊断内容
		.if (Diagnose'="") do
	.set D=""
	.set len=$l(Diagnose,$c(10))
	.if len>0 do
	..for i=1:1:len do
	...set tmpD=$p(Diagnose,$c(10),i)
	...if (tmpD'="") do
	....if (D="") set D=tmpD
	....else  set D=D_","_tmpD
	..s Diagnose=D
	
	do result.Close()	
	zn CurrSpace
	b ;space
	if ((Status'="15")&(Status'="17")) q rtn
	set Notes=RID_"^"_ExamNo_"^S^^"_ReportDoctor_"^"_ArbiterDoctor_"^"_ReportDate_"^"_ArbiterDate_"^"_ReportTime_"^"_ArbiterTime_"^^^"_Positive_"^"_IfEmergency_"^心电^"
	b ;Notes
	set rtn=##class(RISService.TrakRISService).SetReportInfoDo(Notes,Diagnose,Diagnose,Diagnose)
	set ^tmpInterfaceEKG("SetReportInfoDo","RP",OrdIds)=Notes_"#"_Diagnose_"==>"_rtn
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2016-10-31
/// Description：  调用ris接口保存检查结果
/// Table：        
/// Input：        医嘱ID，流水号，报告医生，审核医生，报告时间，审核时间，是否阳性，是否危急
/// Output：       调用结果
/// Return：       
/// Others：
/// 2016-10-14	yangyali	增加注释
/// [Previously private]
/// d ##class(web.DHCEkgService).SetReportInfoDo("349||72")
ClassMethod SetReportInfoDo(OrdIds As %String, ExamNo As %String, ReportDoctor As %String, ArbiterDoctor As %String, ReportDateTime As %String, ArbiterDateTime As %String, IfPositive As %String, IfEmergency As %String) As %String
{
	set rtn=""
	
	set RID=$Replace(OrdIds,"||","_") ;向PACS表里插入数据，以便电子病历调用检查结果
	set RID=RID_"@"
	
	if (ReportDateTime'="") do
	.set ReportDate=$p(ReportDateTime," ",1)
	.set ReportTime=$p(ReportDateTime," ",2)
	if (ArbiterDateTime'="") do
	.set ArbiterDate=$p(ArbiterDateTime," ",1)
	.set ArbiterTime=$p(ArbiterDateTime," ",2)
	
	if DiagInfo'[$c(10) set DiagInfo=DiagInfo_$c(10) ;2015-08-13
		
	set Notes=RID_"^"_ExamNo_"^S^^"_ReportDoctor_"^"_ArbiterDoctor_"^"_ReportDate_"^"_ArbiterDate_"^"_ReportTime_"^"_ArbiterTime_"^^^"_IfPositive_"^"_IfEmergency_"^心电^"
	set rtn=##class(RISService.TrakRISService).SetReportInfoDo(Notes,Diagnose,Diagnose,Diagnose)
	set ^tmpInterfaceEKG("SetReportInfoDo","RP",OrdIds)=Notes_"####"_Diagnose
}

// ==========================================================================

// w ##class(web.DHCEkgService).GetHXYYBookXML( "", "", "", "")

ClassMethod GetHXYYBookXML(patID As %String, patName As %String, stdDate As %String, endDate As %String) As %GlobalCharacterStream
{
	if patID=$c(0) do
	.set patID = ""
	
	if patName=$c(0) do //
	.set patName = ""
	
	if stdDate=$c(0) do //format 2016-08-11 12:21:22
	.set stdDate = ""
	
	if endDate=$c(0) do //format 2016-08-11 12:23:22
	.set endDate = ""
	
	set sD=$p($h,",",1)-5
	set sT=$p($h,",",2)-500
	if stdDate'="" do
	.set sD=$zdh($p(stdDate," ",1),3)
	.set sT=$zdt($p(stdDate," ",2),3)
	
	set eD=$p($h,",",1)
	set eT=$p($h,",",2)
	if endDate'="" do
	.set eD=$zdh($p(endDate," ",1),3)
	.set eT=$zdt($p(endDate," ",2),3)
	
	
	set objStream=##class(%GlobalCharacterStream).%New()
	do objStream.Write("<WinData>")
	
	set CurrSpace=$ZNSPACE
	do ..SetEKGNameSpace()
	
	set bookId="" for  set bookId=$o(^PSBookingInfo(bookId)) quit:bookId=""
	.set bookInfo=$g(^PSBookingInfo(bookId))
	.quit:bookInfo=""
	.set patRegNo=$p(bookInfo,4)
	.quit:((patID'="") & (patRegNo'=patID))
	.set patBKName=$p(bookInfo,5)
	.quit:((patName'="") & (patBKName'=patName))
	.set dt = patBKName=$p(bookInfo,41)
	.set date=$zdh($p(dt," ", 1),3)
	.set time=$zth($p(dt," ", 2),3)
	.quit:((date>eD) || (date<sD))
	.quit:((time>eT) || (time<sT))
	.
	.zn CurrSpace
	.set objsub=##class(web.EKGHXYYBookEntity).%New()
	
	.set objsub.InspectNo = $p(bookInfo,1)
	.set objsub.PatID = $p(bookInfo,2)
	.set objsub.PatCardNo = $p(bookInfo,3)
	.set objsub.PatRegNo = $p(bookInfo,4)
	.set objsub.PatName = $p(bookInfo,5)
	.set objsub.PatSex = $p(bookInfo,6)
	.set objsub.PatAge = $p(bookInfo,7)
	.set objsub.PatAgeUnit = $p(bookInfo,8)
	.set objsub.PatPhone = $p(bookInfo,9)
	.set objsub.PatAddress = $p(bookInfo,10)
	.set objsub.PatType = $p(bookInfo,11)
	.set objsub.HospitalCode = $p(bookInfo,12)
	.set objsub.HospitalName = $p(bookInfo,13)
	.set objsub.RegLocID = $p(bookInfo,14)
	.set objsub.RegLocName = $p(bookInfo,15)
	.set objsub.AdmLocID = $p(bookInfo,16)
	.set objsub.AdmLocName = $p(bookInfo,17)
	.set objsub.AdmWardID = $p(bookInfo,18)
	.set objsub.AdmWardName = $p(bookInfo,19)
	.set objsub.AdmBedNo = $p(bookInfo,20)
	.set objsub.AdmDoc = $p(bookInfo,21)
	.set objsub.AdmDiagnose = $p(bookInfo,22)
	.set objsub.AdmMedNo = $p(bookInfo,23)
	.set objsub.AdmISPect = $p(bookInfo,24)
	.set objsub.AdmISMultRes = $p(bookInfo,25)
	.set objsub.AdmNo = $p(bookInfo,26)
	.set objsub.AdmType = $p(bookInfo,27)
	.set objsub.ResOrdID = $p(bookInfo,28)
	.set objsub.ResArcimID = $p(bookInfo,29)
	.set objsub.ResArcimName = $p(bookInfo,30)
	.set objsub.ResArcimPrice = $p(bookInfo,31)
	.set objsub.ResDate = $p(bookInfo,32)
	.set objsub.ResTime = $p(bookInfo,33)
	.set objsub.ResResource = $p(bookInfo,34)
	.set objsub.ResNo = $p(bookInfo,35)
	.set objsub.ResWay = $p(bookInfo,36)
	.set objsub.ResUser = $p(bookInfo,37)
	.set objsub.WorkLoad = $p(bookInfo,38)
	.set objsub.GuideInfo = $p(bookInfo,39)
	.set objsub.Status = $p(bookInfo,40)
	.set objsub.DateTime = $p(bookInfo,41)
	.set objsub.UpdateUser = $p(bookInfo,42)
	.set objsub.UpdateDT = $p(bookInfo,43)
	.set objsub.UDate = $p(bookInfo,44)
	.set objsub.UTime = $p(bookInfo,45)
	.set objsub.Extend1 = $p(bookInfo,46)
	.set objsub.Extend2 = $p(bookInfo,47)
	
	.set Status=objsub.XMLExportToStream(.Xml)
	.do objStream.CopyFrom(Xml)
	.
	.do ..SetEKGNameSpace()
	
	zn CurrSpace
	
	do objStream.Write("</WinData>")
	quit objStream
}

ClassMethod SetEKGNameSpace()
{
	;ZN "DHC-EKG"
	ZN "EKG"
}

ClassMethod GetPatAgeStr(PAAdm As %String) As %String
{
	set PAPMIAge="-1001"
	Set PatientID=$P(^PAADM(PAAdm),"^",1)
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	b ;DobDate
	If DobDate'="" Do
	.Set PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.;Set PAPMIAge=$fn((+$H-DobDate)/365,"",0)
	.Set PAPMIAge=##class(web.DHCDTHealthCommon).GetAgeDesc(PAPMIDOB,+$h)
	Else  Do
	.Set PAPMIDOB="",PAPMIAge=""
	.s PAPMIAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,PAAdm)
	b ;PAPMIAge

	;set rtn=""
	;set rtn=##class(web.DHCBillInterface).GetPapmiAge(Papmi,Adm,Date,Time)
	q PAPMIAge
}

// ==========================================================================

ClassMethod GetPatAgeStr1(Papmi As %String, Adm As %String, Date As %String, Time As %String) As %String
{
    WRITE !,"Current namespace is ",$NAMESPACE
   SET ns="ACCOUNTING"
   IF 1=##class(%SYS.Namespace).Exists(ns) {
     WRITE !,"Changing namespace to: ",ns
     ZNSPACE ns
     XECUTE "SET x=##class(%SYSTEM.Process).TerminalPrompt(1)"
     WRITE !,"and ",$NAMESPACE," will display at the prompt"
     }
   ELSE {
     WRITE !,"Namespace ",ns," does not exist"
     SET ns="USER"
     WRITE !,"Changing namespace to: ",ns
     ZNSPACE ns
     XECUTE "SET x=##class(%SYSTEM.Process).TerminalPrompt(1)"
     WRITE !,"and ",$NAMESPACE," will display at the prompt"
     }
}

/// 电子迟归接口
ClassMethod DHCEKGEPRPublish(ordID As %String) As %String
{
	set rtn=""
	if (ordID="") q rtn
	set EpisodeID=$p($g(^OEORD(+ordID)),"^",1)
	if (EpisodeID'="") d
	.set rtn=##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishEKG(EpisodeID)
	
	set ^tmpEKG("DHCEKGEPRPublish",ordID)=EpisodeID_"==>"_rtn
	q rtn
}

/// w ##class(web.DHCEkgService).DHCEKGGetOrdInfotoBaihui("85","0000000202")
ClassMethod DHCEKGGetOrdInfotoBaihui(LocId As %String, InRegNo As %String) As %String
{
	set repid=$I(^CacheTemp)
	if $g(ind)="" set ind=1
	k ^TMP($zn,$j,repid)
	set rtn=""
	;set StartDate="",Enddate=""
	s StartDate=$p($h,",",1)-7,Enddate=$p($h,",",1)+2
	set ordInfo=..GetEKGInfoTxt(LocId,InRegNo,StartDate,Enddate)
	b ;ordInfo
	
	if (ordInfo="") q rtn
	
	set configLocID="85$301"
	set configExamItem="常规心电图检查(12导联)^心电图阿托品试验^心电图心得安试验^常规心电图^常规心电图检查^床旁心电图$常规心电图检查^床旁心电图"
	
	set tmpID=-1
	for i=1:1:$length($p(configLocID,"$")) do
	.set tmpLocID=$p(configLocID,"$",i)
	.if (tmpLocID=LocId) do
	..set tmpID=i
	
	set examItemFilter=""
	if (tmpID'=-1) do
	.set examItemFilter=$p(configExamItem,"$",tmpID)
	w examItemFilter,!
	set flag="0"
	set CurrSpace=$ZNSPACE
	for i=1:1:$length($p(ordInfo,"$")) do
	.;if (flag'="0") q
	.set tmpOrdInfo=$p(ordInfo,"$",i)
	.if (tmpOrdInfo="") q
	.set examInfo=$p(tmpOrdInfo,"^",8)
	.set examItem=$p(examInfo,"#",3)	;医嘱名称
	.if (examItem="") q
	.;w examItem,!
	.if (examItemFilter[examItem) do
	..;做时间排序
	..s OrdDate=$p(tmpOrdInfo,"^",31)
	..s OrdTime=$p(tmpOrdInfo,"^",32)
	..s OrdDate=$zdh(OrdDate,3)
	..s OrdTime=$zth(OrdTime,1)
	..;w OrdDate_","_OrdTime,!
	..s ^TMP($zn,$j,repid,OrdDate,OrdTime)=tmpOrdInfo
	b ; zw ^TMP($zn,$j,repid)
	s OrdDate=""
	f  s OrdDate=$o(^TMP($zn,$j,repid,OrdDate),-1) q:(OrdDate="")!(flag="1")  d
	.s OrdTime=""
	.f  s OrdTime=$o(^TMP($zn,$j,repid,OrdDate,OrdTime),-1) q:(OrdTime="")!(flag="1")  d
	..s tmpOrdInfo=^TMP($zn,$j,repid,OrdDate,OrdTime)
	..b ;tmpOrdInfo
	..do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	..set rtn=##class(dbo.interface.DHCEKGtoBaihui).SaveEKGInfo(tmpOrdInfo,LocId)
	..zn CurrSpace
	..set flag="1"
	zn CurrSpace
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2017-3-2
/// Modify: 	   yangyali
/// ModifyDate：   2017-3-2
/// Description:   根据医嘱号查询医嘱信息
/// ModifyDate：   2018-8-1
/// Modify: 	   xzy
/// Description:   将所有的逻辑处理放到此处处理 c#端只负责显示提示信息
/// Input：        医嘱号
/// Output：       提示信息：病人已出院或正在办理出院，\n请勿再进行操作
/// Return：       提示信息：病人已出院或正在办理出院，\n请勿再进行操作
/// Others：
/// w ##class(web.DHCEkgService).GetCurrentDischargeStatus("421")
ClassMethod GetCurrentDischargeStatus(episodId As %String) As %String
{
	set rtn=""
	quit:(episodId="") rtn  //如果episodId为空 表示没有paadm号 为手动检查患者 不做此判断
	
	new $namespace
	set CurrSpace=$ZNSPACE
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	//AllowOprateDischarge	是	病人出院后是否可再操作	是,否
	set configId=$o(^dbo.tblConfigureI("idxKey"," ALLOWOPRATEDISCHARGE",""))
	set confInfo=$g(^dbo.tblConfigureD(configId))
	zn CurrSpace
	
	set value=""
	if confInfo'="" set value=$listget(confInfo,6,"")
	if ((confInfo="")||(value="否")) do	//未配置或配置为不可操作
	.set rtn=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(episodId)
	.;if rtn'="" set rtn="病人已出院或正在办理出院，\n请勿再进行操作"
	quit rtn
}

ClassMethod GetAdmNobyOrdID(OrdID As %String) As %String
{
	s AdmNo=""
	s OrdRowId=$p(OrdID,"||",1)
	if (OrdRowId'="") do
	.s AdmNo=$p(^OEORD(+OrdRowId),"^",1)
	q AdmNo
}

/// w ##class(web.DHCEkgService).TestOrd("1131||50")
ClassMethod TestOrd(OrdID As %String) As %String
{
	s rtn=""
	s OrdRowId=$p(OrdID,"||",1)
	i (OrdRowId'="") d
	.i ($d(^OEORD(+OrdRowId))) d
	..s rtn="是这个his的医嘱"
	.e  d
	..s rtn="不是这个his的医嘱"
	q rtn
}

/// creator:xzy
/// time:2017-04-07
/// 门诊调用计费方法  划卡之后进行计费
/// Input: 
///        cardNO:卡号,不能为空
///        secrityNo: 卡校验码, 不能为空
///        cardType: 卡类型, 不能为空 如果医院有几种卡 这些卡都可以建账户的话 就需要
///        insType：费别, 可以为空
///        episodeID:就诊号, 可以为空（注:为空, OeoriIDStr不能为空)
///        oeoriIDStr：结算的医嘱串, 可以为空(注:为空, episodeID不能为空)
///        guser：操作员RowID, 不能为空
///        groupDR：安全组RowID, 不能为空
///        locDR：登录科室RowID, 不能为空
///        hospDR：院区RowiD, 可以为空(为空时,根据登录科室取院区)
/// Output: 
///         =0 结算成功, <>0 结算失败
///         -200  卡无效
///         -201  此卡无有效账户
///         -204  卡验证错误
///         -205  账户余额不足
///         -207  该卡对应的病人和界面上的病人不一致
///         101   无结算数据
///         102   金额不符
///         105   支付方式错误
///         120   有预结算异常数据,请先处理
///         2621  传入的医嘱串格式错误
///         -210  确认完成失败
///         -211  确认完成失败,撤销异常数据失败
ClassMethod checkOut(cardNO As %String, secrityNo As %String, cardType As %String, insType As %String, episodeID As %String, oeoriIDStr As %String, guser As %String, groupDR As %String, locDR As %String, hospDR As %String) As %String
{
	set userName=$ZCONVERT(guser,"U")
	set userRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",userName,"")) //获取到ss_user表中的rowid
	set guser=userRowId ;====
	set userInfo=$d(^SSU("SSUSR",userRowId))
	
	set groupDR=$p(userInfo,"^",5) ;===
	
	quit ##class(web.DHCBillInterface).checkOut(cardNO,secrityNo,cardType,insType,episodeID,oeoriIDStr,guser,groupDR,locDR,hospDR)
}

ClassMethod GetUserLoginName(userID As %String) As %String
{
	  set userLoginName="-1"
	  	  
	  //user
	  quit:userID="" "-1"
	  set userLoginName=$p(^SSU("SSUSR",userID),"^",1) //获取到ss_user表中的rowid
	  quit userLoginName
}

// w ##class(web.DHCRisRegisterPatientDoEx).register()

// orderBodyList+"^"+EQDR+"^"+RoomDR+"^"+EQGroupDR+"^"+userid+"^"+AssiantDocDR+"^"+MainDocDR+"^"+TelNo+"^"+weight+"^"+locdr;

/// Info=64||100@64||106@64||109^^^^455^^^^^85
/// w ##class(web.DHCEkgService).register("110||26^^^^455^^^^^85")
/// creator:xzy 2017-05-11
/// 供卡消费界面调用 传入参数格式为 64||100@64||106@64||109^^^^455^^^^^85
/// 根据医嘱号串64||100@64||106@64||109获取医嘱信息之后直接写入心电库
ClassMethod register(Info) As %String
{
	s $ZT="ERRORREGISTER"
	;s ^tmpDHCEkg("register")=Info
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","register",$zd($h,3),$zt($p($h,",",2),1),Info,"params")
	//分解参数
	
	s listOrderItemBody=$p(Info,"^",1)
	s RegEQDr=$p(Info,"^",2)
	s RoomDR=$p(Info,"^",3)
	s EQGroupDR=$p(Info,"^",4)
	s operateDocDr=$p(Info,"^",5)   //RAR_SSUSER_DR
	s AssDocDr=$p(Info,"^",6)
	s MainDocDr=$p(Info,"^",7)
	s TelNo=$p(Info,"^",8)   //RAR_SSUSER_DR
	s Weight=$p(Info,"^",9)
	s recLocDr=$p(Info,"^",10)
	s UgentFlag=$p(Info,"^",11)
	
	s userLoginName=..GetUserLoginName(operateDocDr)
	
	set DHCEKGOrderInfo = ..getDHCEKGOrderInfoBylistOrderItem(listOrderItemBody)
	
	set CurrSpace=$ZNSPACE
	for i=1:1:$length($p(DHCEKGOrderInfo,"$")) do
	.set tmpOrdInfo=$p(DHCEKGOrderInfo,"$",i)
	.if (tmpOrdInfo="") q
	.b ;tmpOrdInfo
	.do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	.;zn "dhc-ekg-test"
	.set rtn=##class(dbo.interface.DHCEKGtoBaihui).SaveEKGInfo(tmpOrdInfo,recLocDr,"23",userLoginName)
	.zn CurrSpace
	
	zn CurrSpace
	
	quit DHCEKGOrderInfo
ERRORREGISTER	
	s $ZT=""
	Set ErrorMsg=$ZE
	zn "DHC-APP"
	d ##class(web.DHCEkg.Base).Log("Error","web.DHCEkgService","register",$zd($h,3),$zt($p($h,",",2),1),ErrorMsg)
}

/// listOrderItemBody=64||100@64||106@64||109
/// creator:xzy 2017-05-11
/// modify: yyl 2017-8-25
/// modify:末尾增加患者计费接口控制，4.6.2
/// 			GetCheckArrears 0/Y:允许执行医嘱; N:不允许执行医嘱
/// 根据医嘱号串64||100@64||106@64||109获取医嘱信息
/// w ##class(web.DHCEkgService).getDHCEKGOrderInfoBylistOrderItem("1131||172")
ClassMethod getDHCEKGOrderInfoBylistOrderItem(listOrderItemBody) As %String
{
	s Gettypedesc="",GetRegNo="",GetStudyNo="",GetName="",GetSexDesc="",GetstrAge="",GetstrDOB="",GetstrOrderName="",
	GetStudyWay="",GetPatientStatus="",GetRptID="",GetReportStatus="",GetImgcount="",GetIDCDesc="",
	Getrequestdoc="",GetLocName="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocName="",
	GetVerifyDate="",GetVerifyTime="",GetRoomDesc="",GetRptIsYX="",GetIsTSBL="",GetIsKYBL="",GetstrRegDate="",GetstrRegTime="",
	GetTotalPrice="",GetEQDesc="",GetstrDate="",GetstrTime="",GetstrAccessionNum="",GetIndex="",Getifbed="",GetIPNo="",
	GetWardName="",Getroomdesc="",GetBedNo="",feetype="",BodyDesc="",Getbilled="",GetMainDoc="",GetAssDoc="",paadmdr="",oeorditemdr="",
	GetEQGroupDesc="",GetOldNo="",Required="",SafetynetCardNo="",strMemo="",
	CallStatus="",Number="",GetTelPhone="",GetNum="",GetAssisName="",RoomIndex="",GetReportInfo="",
	(GetItemCode,GetItemRowId)="",GetCheckArrears="",Urgent=""
	s (GetWeight,GetHeight)=""
	
	set rtn=""
	q:(listOrderItemBody="") rtn
	
	//64||100@64||106@64||109
	s count=$l(listOrderItemBody,"@")
    for indexFor=1:1:count d
    .s orderItemBody=$p(listOrderItemBody,"@",indexFor) //64||100
    .s perOrditemRowid=$p(orderItemBody,"$",1) //64||100
    
    .s OrderRowid=$p(perOrditemRowid,"||",1) //64
    .q:(OrderRowid="")
    .s itemsub=$p(perOrditemRowid,"||",2) //100
    
    .//加急获取
    .set Urgent=..GetUrgent(perOrditemRowid)
    
    .s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)  //update by caoll
    .q:(paadmdr="") //update by caoll
    .s GetIDCDesc=##class(web.DHCEkgPatientInfo).GetDiagnose(paadmdr)
    .s PatInfo=##class(web.DHCEkgPatientInfo).GetPaadmInfo(paadmdr)
    .s GetRegNo=$p(PatInfo,"^",1)
    .s GetName=$p(PatInfo,"^",2)
    .s GetStudyNo=$p(PatInfo,"^",27)
    .s GetStudyNo=$Replace(GetStudyNo," ","")
    .s GetstrDOB=$p(PatInfo,"^",3)
    .s GetstrAge=$p(PatInfo,"^",4)
    .s GetstrAge=$p(GetstrAge," ")
 	.s GetSexDesc=$p(PatInfo,"^",5)
    .s Getpatienttype=$p(PatInfo,"^",6)
    .//获取患者身高体重
	.s objNurInt=##class(%Dictionary.CompiledMethod).%OpenId("Nur.CommonInterface.Temperature||getLastItemValue",0)
	.i ($IsObject(objNurInt))  d //方法存在
	..s GetHeight=##Class(Nur.CommonInterface.Temperature).getLastItemValue(paadmdr,"height")
    ..s GetWeight=##Class(Nur.CommonInterface.Temperature).getLastItemValue(paadmdr,"weight")
    .;调用患者计费控制接口，判断是否可以执行医嘱 0:不控制; ^^^^C^^Y^^:允许执行; ^^^^C^^N^^:不允许执行;
    .s ordStr=""
    .i (Getpatienttype="I") d ;住院病人
    ..s OEOREExStDate=""
    ..f  s OEOREExStDate=$o(^OEORDi(0,"OrdItem",OrderRowid,itemsub,OEOREExStDate)) q:(OEOREExStDate="")  d
    ...s OEOREChildsub=""
    ...f  s OEOREChildsub=$o(^OEORDi(0,"OrdItem",OrderRowid,itemsub,OEOREExStDate,OEOREChildsub)) q:(OEOREChildsub="")  d
    ....s OEOREPhQtyOrd=$p($g(^OEORD(OrderRowid,"I",itemsub,"X",OEOREChildsub)),"^",4)
    ....s exStr=OrderRowid_"||"_itemsub_"||"_OEOREChildsub_$c(2)_OEOREPhQtyOrd
    ....;b ; w exStr
    ....i (ordStr'="") s ordStr=ordStr_"^"_exStr
    ....e  s ordStr=exStr
    .e  d
    ..s ordStr=perOrditemRowid_$c(2)_1
    .b ; w ordStr
    .s GetCheckArrears=##class(web.UDHCJFARREARSMANAGE).CheckArrears(paadmdr,ordStr,"RIS","")
    .b ; w GetCheckArrears
    .if ((GetCheckArrears'="0")&&(GetCheckArrears'="")) do
    ..s GetCheckArrears=$p(GetCheckArrears,"^",7)  ;P7：是否允许执行医嘱 Y/N(允许/不允许)
    .s Gettypedesc=$p(PatInfo,"^",7)
    .s ordInfo=##class(web.DHCEkgOeorditem).GetOeorditminfo(OrderRowid,itemsub,Gettypedesc)
    .s GetLocName=$p(PatInfo,"^",8)
    .s GetIPNo=$p(PatInfo,"^",9)       ;住院号
    .s GetWardName=$p(PatInfo,"^",10)
    .s GetBedNo=$p(PatInfo,"^",11)
    .s GetReqLocDR=$p(PatInfo,"^",12)
    .s GetWardDR=$p(PatInfo,"^",14)
    .s Getroomdesc=$p(PatInfo,"^",15)
    .s GetSexDr=$p(PatInfo,"^",13)
    .s SafetynetCardNo=$p(PatInfo,"^",23)
    .s GetTelPhone=$p($g(PatInfo),"^",19)
    .s GetstrOrderName=$p(ordInfo,"^",1)
    .s GetItemCode=$p(ordInfo,"^",24)
    .s GetItemRowId=$p(ordInfo,"^",23)
    .s GetstrOrderName=GetItemRowId_"#"_GetItemCode_"#"_GetstrOrderName
    .//q:GetstrOrderName'[("心电图")
    .s oeorditemdr=OrderRowid_"||"_itemsub
    .s DHCRisSystemInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
    .s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
    .i DHCRisVersion="BJ_FX" d
    ..s strOrdItemMemo=##class(web.DHCEkgApplication).GetOrdItemMemo(oeorditemdr)
    ..i ((strOrdItemMemo'="")&(strOrdItemMemo'=" ")) s GetstrOrderName=GetstrOrderName_"(备注:"_strOrdItemMemo_")"
    .s GetstrDate=$p(ordInfo,"^",2)
    .s GetstrTime=$p(ordInfo,"^",3)
    .s Getrequestdoc=$p(ordInfo,"^",4)
    .s GetstrAccessionNum=$p(ordInfo,"^",5)
    .s GetSGroupDesc=$p(ordInfo,"^",6)    ;是否需要预约项目的标记
    .s GetsubCatDesc=$p(ordInfo,"^",7)
    .s GetCatDesc=$p(ordInfo,"^",8)
    .s Getifbed=$p(ordInfo,"^",9)
    .s Getprice=$p(ordInfo,"^",10)
    .s GetNum=$p(ordInfo,"^",11)
    .s GetTotalPrice=$p(ordInfo,"^",12)
    .s GetTotalPrice=..GetOrdPrice(GetItemRowId)
    .s Getbilled=$p(ordInfo,"^",13)   //费别
    .s GetItemStatusCode=$p(ordInfo,"^",14)
    .s GetordDate=$p(ordInfo,"^",15)
    .s GetordTime=$p(ordInfo,"^",16)
    .s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
    .q:(GetItemStatusCode="D")
    .q:(GetItemStatusCode="C")
    .q:(GetItemStatusCode="U")
    .i GetItemStatusCode="V" s GetItemStatusCode=GetItemStatusCode_"#核实"
    .i GetItemStatusCode="E" s GetItemStatusCode=GetItemStatusCode_"#执行"
    .i GetItemStatusCode="D" s GetItemStatusCode=GetItemStatusCode_"#停止"
    .s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记
    .s strMemo=$p(ordInfo,"^",21)
    .s IsDB = 1  ;哈医大，急诊(门诊)担保押金,门诊病人且医嘱为核实状态
    .s DHCRisVersion=""
    .i (Getpatienttype="O")&(GetItemStatusCode="V") d
    ..s DHCRisSystemInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
    ..s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
    ..i DHCRisVersion="HRB_HYD" d
    ...s DBMoney=0
    ...s DBMoney= $$GetAmtOP^|"meddata"|PCHCOLLS(paadmdr)
    ...s IsDB=(DBMoney>0)
    ..i DHCRisVersion="BJ_FX" d ;复兴医院门诊押金病人未缴费可以做检查
    ...Set CurrentNS=$ZNSPACE
    ...d ##class(web.DHCEkgSystemParam).SetMedTrakNameSpace()
    ...s IsDB= $$CheckDepositADM^CHOPDeposit(paadmdr)
    ...zn CurrentNS
    .;q:(RequireAppoint="Y")&(GetSGroupDesc="不预约")
    .;q:(IsBedOrd="Y")&(Getifbed'="Y")  ;检索床旁医嘱，不是床旁医嘱
    .s SystemParamInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
    .s SendApptoLoc=$p(SystemParamInfo,"^",3)  ;没写申请单,是否发检查医嘱到检查科室
    .s SendInPtoLoc=$p(SystemParamInfo,"^",4)  ;没收费是否把住院病人的检查项目发送到检查科室  
    .s SendOutPtoLoc=$p(SystemParamInfo,"^",5) ;没收费是否把门诊检查项目发送到检查科室
    .s SendEmPtoLoc=$p(SystemParamInfo,"^",6)   ;没收费是否把急诊病人检查项目发送到检查科室
    .s QueryonlyExam=$p(SystemParamInfo,"^",9)  ;是否只查询检查项目
    .s SendHPtoLoc=$p(SystemParamInfo,"^",10)   ;没收费是否把体检病人的检查项目发送检查科室
    .;q:(SendInPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="I")    ;住院病人没有付费的退出
    .q:(SendOutPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="O")&(IsDB=0)   ;门诊病人没有付费退出
    .;q:(SendOutPtoLoc="Y")&(Getpatienttype="O")&((IsDB=0)&(Getbilled'="P")&(DHCRisVersion="HRB_HYD"))   ;门诊病人(HYD急诊)没有押金担保而且没有付费退出
    .;q:(SendOutPtoLoc="Y")&(Getpatienttype="O")&((IsDB=0)&(Getbilled'="P")&(DHCRisVersion="BJ_FX"))   ;门诊病人(复兴)没有押金而且没有付费退出
    .;q:(SendEmPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="E")   ;急症病人没付费退出
    .;q:(SendHPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="H")   ;体检病人没付费退出
    .;q:(QueryonlyExam="Y")&(GetServerMaterial'="S") ;不是检查项目的则退出
    .;------------------------------------------------------------------
    .s GetPatientStatusCode="A"
    .s GetReportStatusCode="N"
    .s Getapprowid="" //,GetStudyNo=""
    .s GetRoomDr="",Getapprowid=""
    .s GetImgcount="",GetMainDoc="",GetAssDoc=""
    .s GetRptID="",GetRptVersion="",GetRptIsYX="",GetEQGroupDesc="",GetOldNo=""
    .s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
    .s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",GetStudyDescDR=""
    .s GetStudyWay="",GetBodyPartDR="",GetIsKYBL="",GetIsTSBL="",GetResultDesc="",GetExamDesc=""
    .s GetIndex="",GetstrRegDate="",GetstrRegTime="",GetEQDr="",GetEQDesc="",GetRoomDesc="",GetEQGroupDR="",GetMainSSuserdr="",BodyDesc=""
    .s GetAssisName="",GetUrgent=""
    .;--------------------------------------------------------------------
    .i (GetItemStatusCode="V")!(GetItemStatusCode="E") d
    ..s GetRejDR=$o(^DHCRBRejecti("OeordDR",oeorditemdr,0))
	..i GetRejDR'="" d
	...s GetPatientStatusCode="R" ;拒绝申请
	..else  d
	...i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" s Getapprowid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)  ; 已经预约RB_Appointment Rowid
	..q:(Getapprowid'="")&(Getapprowid'=$c(0))   ;预约过的医嘱则退出 
	..s GetImgcount=0
	..;i GetItemStatusCode="E"  d  ; 医嘱执行
	..;s GetPatientStatusCode="I"
	..//s GetStudyNo=""                  ;登记,用于存放姓名缩写
	..//s RegInfo=##class(web.DHCEkgRegister).GetRegInfo(oeorditemdr)
    ..//s GetStudyNo=$p(RegInfo,"^",1)
    ..s GetUrgent = ##class(web.DHCEMInterface).GetEmgFlag(OeordId)
    .Do OutRow14
    
   Quit rtn ;$$$OK
OutRow14
 	s Required=""
   	if (GetSGroupDesc="无需预约")!(GetstrOrderName["床旁") s Required="N"
   	
    set DataEx=Gettypedesc_"^"_GetRegNo_"^"_GetStudyNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetstrDOB_"^"_GetstrOrderName
	_"^"_GetStudyWay_"^"_GetPatientStatus_"^"_GetRptID_"^"_GetReportStatus_"^"_GetImgcount_"^"_GetIDCDesc
	_"^"_Getrequestdoc_"^"_GetLocName_"^"_GetRptDocName_"^"_GetRptDate_"^"_GetRptTime_"^"_GetVerifyDocName
	_"^"_GetVerifyDate_"^"_GetVerifyTime_"^"_GetRoomDesc_"^"_GetRptIsYX_"^"_GetIsTSBL_"^"_GetIsKYBL_"^"_GetstrRegDate_"^"_GetstrRegTime
	_"^"_GetTotalPrice_"^"_GetEQDesc_"^"_GetstrDate_"^"_GetstrTime_"^"_GetstrAccessionNum_"^"_GetIndex_"^"_""_"^"_""_"^"_""_"^"_Getifbed_"^"_GetIPNo
	_"^"_GetWardName_"^"_Getroomdesc_"^"_GetBedNo_"^"_feetype_"^"_BodyDesc_"^"_Getbilled_"^"_GetMainDoc_"^"_GetAssDoc_"^"_paadmdr_"^"_oeorditemdr
	_"^"_GetEQGroupDesc_"^"_GetOldNo_"^"_Required_"^"_SafetynetCardNo_"^"_strMemo
	_"^"_CallStatus_"^"_Number_"^"_GetTelPhone_"^"_GetNum_"^"_GetAssisName_"^"_RoomIndex_"^"_GetReportInfo
	_"^"_GetItemStatusCode_"^"_GetCheckArrears_"^"_Urgent_"^^"_GetWeight_"^"_GetHeight
    ;b ; w GetIPNo_","_SafetynetCardNo
    i (DataEx[$c(0)) s DataEx=$translate(DataEx,$c(0),"")
    ///将接口信息写到临时globe，便于核对数据，最大200条
    s disc="来源^登记号^^姓名^性别^年龄^出生日期^^^^^^^^^^^^^^^^^^^^^^价格^^^^^^^^^^^病区^^^^^是否收费^^^^^^^^^^^^^^^^^"
    /*
    s TMPStr=DataEx
    s Tstr=""
    f i=1:1:$l(TMPStr,"^") d
    .s PLIST(i)=i_"-"_$p(disc,"^",i)_"/"_$p(TMPStr,"^",i)
    .s Tstr=Tstr_PLIST(i)_"^"   
    i '$d(^TMPEKG("INFO")) d
    .s ^TMPEKG("INFO",+$h,GetRegNo,1)=Tstr
    e  d
    .s teml=$o(^TMPEKG("INFO",+$h,GetRegNo,""),-1)+1
    .i teml<201 d
    ..s ^TMPEKG("INFO",+$h,GetRegNo,teml)=Tstr
    .e  d
    ..k ^TMPEKG
    ..s ^TMPEKG("INFO",+$h,GetRegNo,1)=Tstr
	*/
    
    
    ;w "++++++++"_DataEx_"+++++++++:"
    ;如果是多条记录，用“$”间隔
   	if rtn'="" s rtn=rtn_"$"
    s rtn=rtn_DataEx
    s rtn=$replace(rtn,$c(0),"")
 	quit
}

/// Creator：      xzy
/// CreatDate：    2018-07-26
/// Modify: 	   
/// ModifyDate：   
/// Description:   根据医嘱号获取加急描述
/// Table：        
/// Input：        医嘱号
/// Output：       如果加急，则返回"急",否则返回 ""
/// w ##class(web.DHCEkgService).getUrgent("41||80")
ClassMethod GetUrgent(OrdId As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetUrgent",$zd($h,3),$zt($p($h,",",2),1),OrdId,"params")
	set rtnUrgent=""
	//set OEORINotifyClinician = $p($G(^OEORD(orderParref,"I",orderId,11)),"^",55)
	//set OEORINotifyClinician=$case(OEORINotifyClinician,"Y":"<font color=red>急</font>",:"")
	
	set orderParref=$p(OrdId,"||",1) //+OrdId
	set orderId=$p(OrdId,"||",2)
	set OEORINotifyClinician = $p($G(^OEORD(orderParref,"I",orderId,11)),"^",55)
	set rtnUrgent=$case(OEORINotifyClinician,"Y":"急",:"")

	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetUrgent",$zd($h,3),$zt($p($h,",",2),1),rtnUrgent,"rtn")
	quit rtnUrgent
}

/// Creator：      yangyali
/// CreatDate：    2017-5-27
/// Modify: 	   yangyali
/// ModifyDate：   2017-5-27
/// Description:   把申请单状态置为登记，同时执行医嘱
/// Table：        
/// Input：        医嘱号，用户工号，科室ID
/// Output：       调用结果
/// w ##class(web.DHCEkgService).SetExamStatusInfo("179||112","636@孙燕姿","85")
ClassMethod SetExamStatusInfo(OrdIds As %String, UserName As %String, LocId As %String, Status = "ARRIVE") As %String
{
	s params=OrdIds_"^"_UserName_"^"_LocId_"^"_Status
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","SetExamStatusInfo",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	set UserId=..GetUserRowId($p(UserName,"@",1))
	set info=OrdIds_"^^^^"_UserId_"^^^^^"_LocId
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","SetExamStatusInfo",$zd($h,3),$zt($p($h,",",2),1),info,OrdIds,"register")
	set rtn=##class(web.DHCEkgRegisterPatient).register(info)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","SetExamStatusInfo",$zd($h,3),$zt($p($h,",",2),1),rtn,OrdIds,"rtn")
	q rtn
	
	/*set rtn=##class(appcom.OEOrdItem).Execute(OrdIds,UserId) //执行医嘱
	
	set ExamNo="EKG||"_OrdIds
	set RID=$Replace(OrdIds,"||","_")
	set info=RID_"^^"_$zd($h,3)_"^"_$p($zdt($h,3)," ",2)_"^"_UserName_"^^^"_ExamNo_"^"_Status_"^^^"
	set rtn=##class(RISService.TrakRISService).SetExamStatusInfo(info)
	set ^tmpInterfaceEKG("SetExamStatusInfo",OrdIds,$zdt($h,3))=info_"==>"_rtn
	q rtn*/
}

/// Creator：      yangyali
/// CreatDate：    2017-6-9
/// Modify: 	   yangyali
/// ModifyDate：   2017-6-9
/// Description:   登记医嘱：把申请单状态置为登记，同时执行医嘱
/// Table：       
/// Input：        医嘱号，用户工号，科室ID
/// Output：       调用结果
/// w ##class(web.DHCEkgService).EKGRegiseter4His("1318||4","636@孙燕姿","85")
ClassMethod EKGRegiseter4His(OrdId As %String, UserName As %String, LocId As %String) As %String
{
	set UserId=..GetUserRowId($p(UserName,"@",1))
	
	d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Execute",$zd($h,3),$zt($p($h,",",2),1),OrdId_"^"_UserId,OrdId,"EKGRegiseter4His")
	set rtn=##class(appcom.OEOrdItem).Execute(OrdId,UserId) //执行医嘱
	d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Execute",$zd($h,3),$zt($p($h,",",2),1),rtn,OrdId,"EKGRegiseter4His rtn")
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),rtn,OrdId,"Execute")
		
	//如果导入web.DHCEkgRegisterPatient.cls报错，则使用下面的代码
	set ExamNo="EKG||"_OrdId
	
	s flag=..#ChangeStatus ;调用ris或ens接口改变检查状态
	if (flag="ris")
	{		
		set RID=$Replace(OrdId,"||","_")
		set Status="ARRIVE"
		set info=RID_"^^"_$zd($h,3)_"^"_$p($zdt($h,3)," ",2)_"^"_UserName_"^^^"_ExamNo_"^"_Status_"^^^"
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),info,OrdId,"SetExamStatusInfo")
		set rtn=##class(RISService.TrakRISService).SetExamStatusInfo(info)
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),rtn,OrdId,"SetExamStatusInfoRtn")
	}
	else
	{		
		//调平台接口更新his检查状态
		s ExamStatus="SC" ;登记
		s inputObj=##class(web.DHCEkg.SystemStatus.Dict.UpdateRequest).%New()
		s inputObj.ExamID=ExamNo
		s inputObj.OEOrdItemID=OrdId
		s inputObj.Position=""
		s inputObj.SourceSystem="EKG"
		s inputObj.Status=ExamStatus
		s inputObj.UpDateTime=$zdt($h,3)
		s inputObj.UserID=UserName ;工号
		s inputObj.UserName=..GetUserNameByCode(UserName) ;姓名
		s OrderRowid=$p(OrdId,"||",1)
		s itemsub=$p(OrdId,"||",2)
		s recLoc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6) //检查科室rowid
		s CtLocCode=$P(^CTLOC(recLoc),"^",1)
		s CtLocDesc=$P(^CTLOC(recLoc),"^",2)
		s inputObj.OperateDeptCode=CtLocCode 
		s inputObj.OperateDept=CtLocDesc 
		
		s json=##class(ext.util.JsonObject).ObjToJson(inputObj,"","") ;web.DHCEkg.SystemStatus.Dict.UpdateRequest
		s json="["_json_"]"
		s jsonStream=##class(%GlobalCharacterStream).%New()
		d jsonStream.Write(json)
		b ; w json
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),json,OrdId,"UpdateSystemStatus")
		s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
		;q rtnUpdateSystem
		i $IsObject(rtnUpdateSystem) d
		.d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),rtnUpdateSystem.Read(),OrdId,"UpdateSystemStatusRtn")
		e  d
		.d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),rtnUpdateSystem,OrdId,"UpdateSystemStatusRtn")
		
		//预约接口，调用平台总线服务再次发送检查闭环
		try
		{
			s OrderRowid=$p(OrdId,"||",1)
			s itemsub=$p(OrdId,"||",2)
			q:((OrderRowid="")!(itemsub=""))
			q:($g(^OEORD(OrderRowid,"I",itemsub,1))="") ; 判断是否为his医嘱
			s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
			s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
			s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
			s StatusParameter=##class(web.DHCEkg.Dict.StatusParameter).%New()
			s StatusParameter.PATPatientID=RegNo
			s StatusParameter.PAADMVisitNumber=paadmdr
			s StatusParameter.OEORIOrderItemID=OrdId
			s StatusParameter.OEORIOrdExecID=""
			s StatusParameter.SpecimenID=""
			s StatusParameter.RISRExamID=ExamNo
			s StatusParameter.RISRSystemType="EKG"
			s StatusParameter.Position=""
			s StatusParameter.OperAppID=""
			s StatusParameter.BloodAppID=""
			s StatusParameter.BloodBagNo=""
			s StatusParameter.ConsultAppID=""
			s StatusParameter.StatusCode="SC"
			s StatusParameter.UpdateUserCode=UserName
			s StatusParameter.UpdateUserName=DocName
			s StatusParameter.UpdateDateTime=$zdt($h,3)
			
			s header=##class(web.DHCEkg.Dict.Header).%New()
			s header.SourceSystem="EKG"
			s header.MessageID=$system.Util.CreateGUID()				
			s body=##class(web.DHCEkg.Dict.Body).%New()
			s body.StatusParameter=StatusParameter
			s request=##class(web.DHCEkg.Dict.Request).%New()
			s request.Header=header
			s request.Body=body
			s Status=request.XMLExportToString(.inputXmlStr)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGRegiseter4His",
				$zd($h,3),$zt($p($h,",",2),1),inputXmlStr,OrdId,"MES0079")
			s soapObj=##class(web.DHCEkg.Soap.RIMServiceSoap).%New()
			s ensRtn=soapObj.HIPMessageServer("MES0079",inputXmlStr)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGRegiseter4His",
				$zd($h,3),$zt($p($h,",",2),1),ensRtn,OrdId,"MES0079 rtn")
		}
		catch
		{
			b ; error
			d ##class(web.DHCEkg.Base).Log("Error","web.DHCEkgService","EKGRegiseter4His",
				$zd($h,3),$zt($p($h,",",2),1),$ze,OrdId,"MES0079")
		}
		s rtn="0"
	}
	q rtn
	
	//如果成功导入web.DHCEkgRegisterPatient.cls，则使用下面的代码
	/*set info=OrdId_"^^^^"_UserId_"^^^^^"_LocId
	set rtn=##class(web.DHCEkgRegisterPatient).register(info)
	set ^tmpDHCEKG("register",OrdId,$zdt($h,3))=info_"==>"_rtn
	q rtn*/
}

/// Creator：      yangyali
/// CreatDate：    2018-11-2
/// Modify: 	   yangyali
/// ModifyDate：   2018-11-2
/// Description:   获取心电检查状态
/// Table：       
/// Input：        医嘱号
/// Output：       检查状态代码
/// w ##class(web.DHCEkgService).GetExamStatusCode("571||128")
ClassMethod GetExamStatusCode(OrdId As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetExamStatusCode",$zd($h,3),$zt($p($h,",",2),1),OrdId,"params")
	new $namespace
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s (reqId,examId,examInfo,statuscode)=""
	s reqId=$o(^dbo.tblRequestI("idxExamCode"," "_OrdId,""))
	q:reqId="" ""
	s examId = $o(^dbo.tblExaminationI("idxRequestID",reqId,""))
	q:examId="" ""
	s examInfo=$g(^dbo.tblExaminationD(examId))
	q:examInfo="" ""
	s statuscode=$listget(examInfo,20,"")
	zn CurrSpace
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetExamStatusCode",$zd($h,3),$zt($p($h,",",2),1),statuscode,"rtn")
	q statuscode
}

/// Creator：      yangyali
/// CreatDate：    2018-11-2
/// Modify: 	   yangyali
/// ModifyDate：   2018-11-2
/// Description:   根据工号获取用户名
/// Table：       
/// Input：        工号
/// Output：       姓名
/// w ##class(web.DHCEkgService).GetExamStatusCode("571||128")
ClassMethod GetUserNameByCode(userCode As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetUserNameByCode",$zd($h,3),$zt($p($h,",",2),1),userCode,"params")
	new $namespace
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s (userId,userInfo,userName)=""	
	s userCode=$system.SQL.UPPER(userCode) ;转大写，防止索引查不到
	s userId=$o(^dbo.tblUserI("idxLoginName"," "_userCode,""))
	q:userId="" ""
	s userInfo=$g(^dbo.tblUserD(userId))
	q:userInfo="" ""
	s userName=$listget(userInfo,11,"")
	zn CurrSpace
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetUserNameByCode",$zd($h,3),$zt($p($h,",",2),1),userName,"rtn")
	q userName
}

/// Creator：      yangyali
/// CreatDate：    2017-6-9
/// Modify: 	   yangyali
/// ModifyDate：   2018-11-2
/// Description:   检查后：把申请单状态置为登记，同时执行医嘱
/// Table：       
/// Input：        医嘱号，用户工号，是否执行医嘱^是否置检查状态
/// Output：       调用结果
/// w ##class(web.DHCEkgService).EKGExam4His("699||176","636@孙燕姿","85")
ClassMethod EKGExam4His(OrdId As %String, UserName As %String, IfExecute As %String) As %String
{
	
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGExam4His",$zd($h,3),$zt($p($h,",",2),1),OrdId_"^"_UserName_"^"_IfExecute,"param")
	//s rtnRemote=##class(web.DHCEkg.Remote.EKGServiceN).ChangeReqStatus(OrdId,"1")
	//s ^tmpInterfaceEKG("ChangeReqStatus",OrdId,"数据采集",$zdt($h,3))=rtnRemote
	
	s ChangeStatus="" ;是否置检查结束状态
	i (IfExecute["^") d 
	.s ChangeStatus=$p(IfExecute,"^",2)
	.s IfExecute=$p(IfExecute,"^",1) ;是否置执行状态
	s rtn=""
	b ;IfExecute
	s UserId=..GetUserRowId($p(UserName,"@",1))
	i (IfExecute'="")&&(IfExecute'="0")&&(IfExecute'=$c(0)&&(IfExecute'="N")) d ;不执行医嘱，传空或者0
	.d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Execute",$zd($h,3),$zt($p($h,",",2),1),OrdId_"^"_UserId,OrdId,"EKGExam4His")
	.s rtn=##class(appcom.OEOrdItem).Execute(OrdId,UserId) 
	.d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Execute",$zd($h,3),$zt($p($h,",",2),1),rtn,OrdId,"EKGExam4His rtn")
	
	//如果导入web.DHCEkgRegisterPatient.cls报错，则使用下面的代码
	s ExamNo="EKG||"_OrdId
	s flag=..#ChangeStatus ;调用ris或ens接口改变检查状态
	if (flag="ris")
	{
		//调ris接口更新his检查状态
		s RID=$Replace(OrdId,"||","_")
		s Status="CM"
		s info=RID_"^^"_$zd($h,3)_"^"_$p($zdt($h,3)," ",2)_"^"_UserName_"^^^"_ExamNo_"^"_Status_"^^^"
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGExam4His",$zd($h,3),$zt($p($h,",",2),1),info,OrdId,"SetExamStatusInfo")
		s rtn=##class(RISService.TrakRISService).SetExamStatusInfo(info)
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGExam4His",$zd($h,3),$zt($p($h,",",2),1),rtn,OrdId,"SetExamStatusInfoRtn")
		;s ^tmpInterfaceEKG("SetExamStatusInfo",OrdId,$zdt($h,3))=info_"==>"_rtn
	}
	else
	{
		
		i (ChangeStatus'="N")
		{
			s DocName=..GetUserNameByCode(UserName) ;姓名	
			//先从平台接口获取当前检查状态
			s orgStatus=..GetSystemStatus(OrdId)
			i ((orgStatus'="SC")&&(orgStatus'="CM")&&(orgStatus'="RP"))
			{	
				//当前状态不是登记状态，先发送登记状态	
				//调平台接口发送登记的检查状态
				s ExamStatus="SC" ;登记
				s inputObj=##class(web.DHCEkg.SystemStatus.Dict.UpdateRequest).%New()
				s inputObj.ExamID=ExamNo
				s inputObj.OEOrdItemID=OrdId
				s inputObj.Position=""
				s inputObj.SourceSystem="EKG"
				s inputObj.Status=ExamStatus
				s inputObj.UpDateTime=$zdt($h,3)
				s inputObj.UserID=UserName ;工号
				s inputObj.UserName=DocName ;姓名	
				s OrderRowid=$p(OrdId,"||",1)
				s itemsub=$p(OrdId,"||",2)
				s recLoc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6) //检查科室rowid
				s CtLocCode=$P(^CTLOC(recLoc),"^",1)
				s CtLocDesc=$P(^CTLOC(recLoc),"^",2)
				s inputObj.OperateDeptCode=CtLocCode 
				s inputObj.OperateDept=CtLocDesc 
				
				s json=##class(ext.util.JsonObject).ObjToJson(inputObj,"","") ;web.DHCEkg.SystemStatus.Dict.UpdateRequest
				s json="["_json_"]"
				s jsonStream=##class(%GlobalCharacterStream).%New()
				d jsonStream.Write(json)
				b ; w json
				d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGExam4His",$zd($h,3),$zt($p($h,",",2),1),json,OrdId,"SC")
				s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
				b ; zw rtnUpdateSystem
				d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGExam4His",$zd($h,3),$zt($p($h,",",2),1),rtnUpdateSystem.Read(),OrdId,"SC RTN")
		
			}
			;当前状态为登记状态，则不再登记
			
			//调平台接口发送检查完成的状态
			s ExamStatus="CM" ;检查完成
			s inputObj=##class(web.DHCEkg.SystemStatus.Dict.UpdateRequest).%New()
			s inputObj.ExamID=ExamNo
			s inputObj.OEOrdItemID=OrdId
			s inputObj.Position=""
			s inputObj.SourceSystem="EKG"
			s inputObj.Status=ExamStatus
			s inputObj.UpDateTime=$zdt($h,3)
			s inputObj.UserID=UserName ;工号
			s inputObj.UserName=DocName ;姓名	
			
			s json=##class(ext.util.JsonObject).ObjToJson(inputObj,"","") ;web.DHCEkg.SystemStatus.Dict.UpdateRequest
			s json="["_json_"]"
			s jsonStream=##class(%GlobalCharacterStream).%New()
			d jsonStream.Write(json)
			b ; w json
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGExam4His",$zd($h,3),$zt($p($h,",",2),1),json,OrdId,"CM")
			s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGExam4His",$zd($h,3),$zt($p($h,",",2),1),rtnUpdateSystem.Read(),OrdId,"CM RTN")
			;s ^tmpDHCEKG("UpdateSystemStatus",OrdId,$zdt($h,3),ExamStatus)=json_"==>"_rtnUpdateSystem.Read()
			s rtn="0"
			
			//预约接口，调用平台总线服务再次发送检查闭环
			try
			{
				s OrderRowid=$p(OrdId,"||",1)
				s itemsub=$p(OrdId,"||",2)
				q:((OrderRowid="")!(itemsub=""))
				q:($g(^OEORD(OrderRowid,"I",itemsub,1))="") ; 判断是否为his医嘱
				s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
				s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
				s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
				s StatusParameter=##class(web.DHCEkg.Dict.StatusParameter).%New()
				s StatusParameter.PATPatientID=RegNo
				s StatusParameter.PAADMVisitNumber=paadmdr
				s StatusParameter.OEORIOrderItemID=OrdId
				s StatusParameter.OEORIOrdExecID=""
				s StatusParameter.SpecimenID=""
				s StatusParameter.RISRExamID=ExamNo
				s StatusParameter.RISRSystemType="EKG"
				s StatusParameter.Position=""
				s StatusParameter.OperAppID=""
				s StatusParameter.BloodAppID=""
				s StatusParameter.BloodBagNo=""
				s StatusParameter.ConsultAppID=""
				s StatusParameter.StatusCode="CM"
				s StatusParameter.UpdateUserCode=UserName
				s StatusParameter.UpdateUserName=DocName
				s StatusParameter.UpdateDateTime=$zdt($h,3)
				
				s header=##class(web.DHCEkg.Dict.Header).%New()
				s header.SourceSystem="EKG"
				s header.MessageID=$system.Util.CreateGUID()				
				s body=##class(web.DHCEkg.Dict.Body).%New()
				s body.StatusParameter=StatusParameter
				s request=##class(web.DHCEkg.Dict.Request).%New()
				s request.Header=header
				s request.Body=body
				s Status=request.XMLExportToString(.inputXmlStr)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGExam4His",
				$zd($h,3),$zt($p($h,",",2),1),inputXmlStr,OrdId,"MES0079")
			s soapObj=##class(web.DHCEkg.Soap.RIMServiceSoap).%New()
			s ensRtn=soapObj.HIPMessageServer("MES0079",inputXmlStr)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGExam4His",
				$zd($h,3),$zt($p($h,",",2),1),ensRtn,OrdId,"MES0079 rtn")
			}
			catch
			{
			b ; error
				d ##class(web.DHCEkg.Base).Log("Error","web.DHCEkgService","EKGExam4His",
					$zd($h,3),$zt($p($h,",",2),1),$ze,OrdId,"MES0079")
			}
		
		}
	}
		;s rtnRemote=##class(web.DHCEkg.Remote.EKGServiceN).ChangeReqStatus(OrdId,"1")
		;s ^tmpInterfaceEKG("ChangeReqStatus",OrdId,"数据采集",$zdt($h,3))=rtnRemote
	q rtn ;_"^"_rtnRemote
}

/// Creator：      yangyali
/// CreatDate：    2017-6-9
/// Modify: 	   yangyali
/// ModifyDate：   2017-6-9
/// Description:   取消登记：把申请单状态置为正在申请，同时撤销执行医嘱
/// Table：       
/// Input：        医嘱号，用户工号，科室ID
/// Output：       调用结果
/// w ##class(web.DHCEkgService).EKGUnRegiseter4His("571||128","636")
ClassMethod EKGUnRegiseter4His(OrdId As %String, UserName As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGUnRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),OrdId_"^"_UserName,"param")
	s UserId=..GetUserRowId($p(UserName,"@",1))
	
	d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Verify",$zd($h,3),$zt($p($h,",",2),1),
					OrdId_"^"_UserId,OrdId,"EKGUnRegiseter4His")
	s rtn=##class(appcom.OEOrdItem).Verify(OrdId,UserId) //撤销执行 变成核实
	d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Verify",$zd($h,3),$zt($p($h,",",2),1),
					rtn,OrdId,"EKGUnRegiseter4His rtn")
	
	s ExamNo="" ;检查号 2
	s ExamNo="EKG||"_OrdId	;检查号：EKG||医嘱ID
	
	s flag=..#ChangeStatus ;调用ris或ens接口改变检查状态
	if (flag="ris")
	{
		s userInfo=UserName_"^Y^Y^"
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGUnRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),ExamNo_","_OrdId_","_userInfo,OrdId,"UnRegister")
		s rtn=##class(RISService.TrakRISService).UnRegister(ExamNo,OrdId,userInfo)
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGUnRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),rtn,"UnRegisterRtn")
		;s ^tmpDHCEKG("UnRegister",OrdId,$zdt($h,3))=ExamNo_","_OrdId_","_userInfo_"==>"_rtn
	
	}
	else
	{
		//调平台接口更新his检查状态，发送取消检查
		try
		{
			s ExamStatus="CA" ;取消检查
			s inputObj=##class(web.DHCEkg.SystemStatus.Dict.UpdateRequest).%New()
			s inputObj.ExamID=ExamNo
			s inputObj.OEOrdItemID=OrdId
			s inputObj.Position=""
			s inputObj.SourceSystem="EKG"
			s inputObj.Status=ExamStatus
			s inputObj.UpDateTime=$zdt($h,3)
			s inputObj.UserID=UserName ;工号
			s inputObj.UserName=..GetUserNameByCode(UserName) ;姓名
			s OrderRowid=$p(OrdId,"||",1)
			s itemsub=$p(OrdId,"||",2)
			s recLoc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6) //检查科室rowid
			s CtLocCode=$P(^CTLOC(recLoc),"^",1)
			s CtLocDesc=$P(^CTLOC(recLoc),"^",2)
			s inputObj.OperateDeptCode=CtLocCode 
			s inputObj.OperateDept=CtLocDesc 
		
			s json=##class(ext.util.JsonObject).ObjToJson(inputObj,"","") ;web.DHCEkg.SystemStatus.Dict.UpdateRequest
			s json="["_json_"]"
			s jsonStream=##class(%GlobalCharacterStream).%New()
			d jsonStream.Write(json)
			b ; w json
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGUnRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),json,OrdId,"CA")
			s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGUnRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),rtnUpdateSystem.Read(),OrdId,"CArtn")
		}
		catch
		{
		}
		try
		{
			//再发送取消登记CSC
			s ExamStatus="CSC" ;取消登记
			s inputObj.Status=ExamStatus
			s json=##class(ext.util.JsonObject).ObjToJson(inputObj,"","")
			s json="["_json_"]"
			s jsonStream=##class(%GlobalCharacterStream).%New()
			d jsonStream.Write(json)
			b ; w json
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGUnRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),json,OrdId,"CSC")
			s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGUnRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),rtnUpdateSystem.Read(),OrdId,"CSCrtn")
			;s ^tmpDHCEKG("UpdateSystemStatus",ordID,$zdt($h,3),ExamStatus)=json_"==>"_rtnUpdateSystem.Read()
		}
		catch
		{
		}
		//预约接口，调用平台总线服务再次发送检查闭环
		try
		{
			s OrderRowid=$p(OrdId,"||",1)
			s itemsub=$p(OrdId,"||",2)
			q:((OrderRowid="")!(itemsub=""))
			q:($g(^OEORD(OrderRowid,"I",itemsub,1))="") ; 判断是否为his医嘱
			s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
			s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
			s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
			s StatusParameter=##class(web.DHCEkg.Dict.StatusParameter).%New()
			s StatusParameter.PATPatientID=RegNo
			s StatusParameter.PAADMVisitNumber=paadmdr
			s StatusParameter.OEORIOrderItemID=OrdId
			s StatusParameter.OEORIOrdExecID=""
			s StatusParameter.SpecimenID=""
			s StatusParameter.RISRExamID=ExamNo
			s StatusParameter.RISRSystemType="EKG"
			s StatusParameter.Position=""
			s StatusParameter.OperAppID=""
			s StatusParameter.BloodAppID=""
			s StatusParameter.BloodBagNo=""
			s StatusParameter.ConsultAppID=""
			s StatusParameter.StatusCode="CSC"
			s StatusParameter.UpdateUserCode=UserName
			s StatusParameter.UpdateUserName=DocName
			s StatusParameter.UpdateDateTime=$zdt($h,3)
			
			s header=##class(web.DHCEkg.Dict.Header).%New()
			s header.SourceSystem="EKG"
			s header.MessageID=$system.Util.CreateGUID()				
			s body=##class(web.DHCEkg.Dict.Body).%New()
			s body.StatusParameter=StatusParameter
			s request=##class(web.DHCEkg.Dict.Request).%New()
			s request.Header=header
			s request.Body=body
			s Status=request.XMLExportToString(.inputXmlStr)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGRegiseter4His",
				$zd($h,3),$zt($p($h,",",2),1),inputXmlStr,OrdId,"MES0079")
			s soapObj=##class(web.DHCEkg.Soap.RIMServiceSoap).%New()
			s ensRtn=soapObj.HIPMessageServer("MES0079",inputXmlStr)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGRegiseter4His",
				$zd($h,3),$zt($p($h,",",2),1),ensRtn,OrdId,"MES0079 rtn")
		}
		catch
		{
			b ; error
			d ##class(web.DHCEkg.Base).Log("Error","web.DHCEkgService","EKGRegiseter4His",
				$zd($h,3),$zt($p($h,",",2),1),$ze,OrdId,"MES0079")
		}
	}
	
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2017-6-9
/// Modify: 	   yangyali
/// ModifyDate：   2019-10-9
/// Description:   检查状态传给平台，再调用pacs接口发送检查结果(HIS8.3版)
/// Table：       
/// Input：        医嘱号，用户工号，科室ID
/// Output：       调用结果
/// w ##class(web.DHCEkgService).EKGArbiter4His("451||106","636")
ClassMethod EKGArbiter4His(OrdId As %String, UserName As %String) As %String
{
	new $namespace
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGArbiter4His",$zd($h,3),$zt($p($h,",",2),1),OrdId_"^"_UserName,"param")
	;if OrderStatus="RP" do //将结果状态变成 已写报告
	set resultStatus="RP"
	&sql(Update OE_OrdItem set OEORI_ResultFlag=:resultStatus  where OEORI_RowId=:OrdId)
		
	;远程会诊接口
	//set rtnRemote=##class(web.DHCEkg.Remote.EKGServiceN).ChangeReqStatus(OrdId,"3")
	//set ^tmpInterfaceEKG("ChangeReqStatus",OrdId,"发布报告",$zdt($h,3))=rtnRemote
	
	
	set ExamNo="EKG||"_OrdId	;检查号：EKG||医嘱ID
	s flag=..#ChangeStatus ;调用ris或ens接口改变检查状态
	
	if (flag="ens")
	{
		//调平台接口更新his检查状态
		s ExamStatus="RP" ;报告
		s inputObj=##class(web.DHCEkg.SystemStatus.Dict.UpdateRequest).%New()
		s inputObj.ExamID=ExamNo
		s inputObj.OEOrdItemID=OrdId
		s inputObj.Position=""
		s inputObj.SourceSystem="EKG"
		s inputObj.Status=ExamStatus
		s inputObj.UpDateTime=$zdt($h,3)
		s inputObj.UserID=UserName ;工号
		s inputObj.UserName=..GetUserNameByCode(UserName) ;姓名
		
		s OrderRowid=$p(OrdId,"||",1)
		s itemsub=$p(OrdId,"||",2)
		s recLoc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6) //检查科室rowid
		s CtLocCode=$P(^CTLOC(recLoc),"^",1)
		s CtLocDesc=$P(^CTLOC(recLoc),"^",2)
		s inputObj.OperateDeptCode=CtLocCode 
		s inputObj.OperateDept=CtLocDesc 
	
		s json=##class(ext.util.JsonObject).ObjToJson(inputObj,"","") ;web.DHCEkg.SystemStatus.Dict.UpdateRequest
		s json="["_json_"]"
		s jsonStream=##class(%GlobalCharacterStream).%New()
		d jsonStream.Write(json)
		b ; w json
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGArbiter4His",$zd($h,3),$zt($p($h,",",2),1),json,OrdId,"UpdateSystemStatus")
		s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGArbiter4His",$zd($h,3),$zt($p($h,",",2),1),rtnUpdateSystem.Read(),OrdId,"UpdateSystemStatusRtn")
		;s ^tmpDHCEKG("UpdateSystemStatus",OrdId,$zdt($h,3),ExamStatus)=json_"==>"_rtnUpdateSystem.Read()
	}
	;
	;if (flag="ris")
	;{
		s RID=$Replace(OrdId,"||","_") ;向PACS表里插入数据，以便电子病历调用检查结果
		s RID=RID_"@"
		s ReportDoctor = "" ;报告医生
		s ArbiterDoctor = "" ;审核医生
		s ReportDateTime = "" ;报告时间
		s ReportDate=""
		s ReportTime=""
		s ArbiterDateTime = "" ;审核时间
		s ArbiterDate=""
		s ArbiterTime=""
		s Diagnose = "" ;诊断内容
		s NegativePositive=""
		s Positive="N"
		
		//预约接口增加参数
		s (PATPatientID,PAADMVisitNumber,OEORIOrderItemID,OEORIOrdExecID,SpecimenID,RISRExamID,RISRSystemType)=""
		s (Position,OperAppID,BloodAppID,BloodBagNo,ConsultAppID,StatusCode,UpdateUserCode,UpdateUserName,UpdateDateTime)=""

		s CurrSpace=$ZNSPACE
		d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
		q:OrdId="" "-1001^医嘱号为空"
		
		s reqId=$o(^dbo.tblRequestI("idxExamCode"," "_OrdId,""))
		q:reqId="" "-1002^心电库未查询到医嘱"
		s examId=""
		s tmpExamId=""
		f
		{
			s tmpExamId = $o(^dbo.tblExaminationI("idxRequestID",reqId,tmpExamId))
			q:(tmpExamId="")
			s tmpStatusCode=$lg($g(^dbo.tblExaminationD(tmpExamId)),20)
			i (tmpStatusCode<18)&&(tmpStatusCode>10)
			{
				s examId=tmpExamId
			}
		}
		q:(examId="") "-1003^心电库未查询到检查"
		s examInfo=^dbo.tblExaminationD(examId)
		s ReportUserID=$list(examInfo,7)
		s ArbiterUserID=$list(examInfo,7)
		s ReportDateTime=$list(examInfo,6)
		s ArbiterDateTime=$list(examInfo,6)
		s NegativePositive=$list(examInfo,30)
		s Diagnose=$list(examInfo,11)
		s ReportDate=$p(ReportDateTime," ",1)
		s ReportTime=$p(ReportDateTime," ",2)
		s ArbiterDate=$p(ArbiterDateTime," ",1)
		s ArbiterTime=$p(ArbiterDateTime," ",2)
		i (NegativePositive="阳性") s Positive="Y"
		s ReportUserName="",ArbiterUserName=""
		i ReportUserID'="" d
		.s ReportUserName=$list(^dbo.tblUserD(ReportUserID),11)
		.s ReportUserID=$list(^dbo.tblUserD(ReportUserID),8)
		s ArbiterUserID=ReportUserID
		s ArbiterUserName=ReportUserName
		s ReportDoctor=ReportUserID_"@"_ReportUserName
		s ArbiterDoctor=ArbiterUserID_"@"_ArbiterUserName
		b ;Diagnose
		i Diagnose'[$c(10) set Diagnose=Diagnose_$c(10) ;2015-08-13
		s D=""
		f i=1:1:$l(Diagnose,$c(10)) d
		.s tmpD=$p(Diagnose,$c(10),i)
		.i (tmpD'="") do
		..i (D="") set D=tmpD
		..e  set D=D_","_tmpD
		b ;00
		s Diagnose=D
		b ;Diagnose after
		
		//获取预约参数
		s PAADMVisitNumber=$lg($g(^dbo.tblRequestD(reqId)),3) ;就诊号
		s patId=$lg($g(^dbo.tblRequestD(reqId)),16)
		i (patId'="")
		{
			s PATPatientID=$lg($g(^dbo.tblPatientD(patId)),20) ; 登记号
			s OEORIOrderItemID=OrdId ; 医嘱id
			s RISRExamID="EKG"_OrdId ; 检查号
			s RISRSystemType="EKG" ; 系统类型
			s StatusCode="RP" ; 状态代码
			s UpdateUserCode=UserName ; 更新人工号
			i (UserName'="")
			{
				s userId=$o(^dbo.tblUserI("idxLoginName"," "_$zcvt(UserName,"u"),""))
				i (userId'="")
				{
					s UpdateUserName=$lg($g(^dbo.tblUserD(userId)),11) ; 最后更新人描述
				}
			}
			s UpdateDateTime=$zdt($h,3) ; 更新日期时间
		}	
				
		zn CurrSpace	
		s Notes=RID_"^"_ExamNo_"^S^^"_ReportDoctor_"^"_ArbiterDoctor_"^"_ReportDate_"^"_ArbiterDate_"^"_ReportTime_"^"_ArbiterTime_"^^^"_Positive_"^N^心电^"
		b ;space
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGArbiter4His",$zd($h,3),$zt($p($h,",",2),1),Notes_","_Diagnose,OrdId,"SetReportInfoDo")
		s rtn=##class(RISService.TrakRISService).SetReportInfoDo(Notes,Diagnose,Diagnose,Diagnose)
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGArbiter4His",$zd($h,3),$zt($p($h,",",2),1),rtn,OrdId,"SetReportInfoDoRtn")
		
	try
	{
		s StatusParameter=##class(web.DHCEkg.Dict.StatusParameter).%New()
		s StatusParameter.PATPatientID=PATPatientID
		s StatusParameter.PAADMVisitNumber=PAADMVisitNumber
		s StatusParameter.OEORIOrderItemID=OEORIOrderItemID
		s StatusParameter.OEORIOrdExecID=OEORIOrdExecID
		s StatusParameter.SpecimenID=SpecimenID
		s StatusParameter.RISRExamID=RISRExamID
		s StatusParameter.RISRSystemType=RISRSystemType
		s StatusParameter.Position=Position
		s StatusParameter.OperAppID=OperAppID
		s StatusParameter.BloodAppID=BloodAppID
		s StatusParameter.BloodBagNo=BloodBagNo
		s StatusParameter.ConsultAppID=ConsultAppID
		s StatusParameter.StatusCode=StatusCode
		s StatusParameter.UpdateUserCode=UpdateUserCode
		s StatusParameter.UpdateUserName=UpdateUserName
		s StatusParameter.UpdateDateTime=UpdateDateTime
		
		
		s header=##class(web.DHCEkg.Dict.Header).%New()
		s header.SourceSystem="EKG"
		s header.MessageID=$system.Util.CreateGUID()				
		s body=##class(web.DHCEkg.Dict.Body).%New()
		s body.StatusParameter=StatusParameter
		s request=##class(web.DHCEkg.Dict.Request).%New()
		s request.Header=header
		s request.Body=body
		s Status=request.XMLExportToString(.inputXmlStr)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGArbiter4His",
				$zd($h,3),$zt($p($h,",",2),1),inputXmlStr,OrdId,"MES0079")
			s soapObj=##class(web.DHCEkg.Soap.RIMServiceSoap).%New()
			s ensRtn=soapObj.HIPMessageServer("MES0079",inputXmlStr)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGArbiter4His",
				$zd($h,3),$zt($p($h,",",2),1),ensRtn,OrdId,"MES0079 rtn")
	}
	catch
	{
			b ; error
		d ##class(web.DHCEkg.Base).Log("Error","web.DHCEkgService","EKGArbiter4His",
			$zd($h,3),$zt($p($h,",",2),1),$ze,OrdId,"MES0079")
	}
		
	//检查结果回传给平台
	s rtnSentRpt=##class(web.DHCEkg.Method.SentRptENS).SentReportJob(OrdId)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","EKGArbiter4His",$zd($h,3),$zt($p($h,",",2),1),rtnSentRpt,OrdId,"SentReport")
	//调用平台接口回传预约检查状态
	
	quit rtn ;_rtn1
}

/// create: yyl
/// desc:   升级接口，发布报告时把检查保存到旧数据库
ClassMethod UpgradeExamInfo(OrdId As %String) As %String
{
	s saveRtn=""
	set CurrSpace=$ZNSPACE
	;s newEKG="dhc-ekg"
	;s oldEKG="dhc-ekg-yb"
	zn "dhc-ekg"
	b ;dhc-ekg
	s obj1=##class(Upgrade.Bll.Service.EKGService).%New()
	s ExamInfoStream=obj1.GetExamInfo(OrdId)
	b ;ExamInfoStream
	if (ExamInfoStream'="") do
	.zn "dhc-ekg-yb"
	.s obj2=##class(Upgrade.Bll.Service.EKGService).%New()
	.s saveRtn=obj2.SentExamInfo(ExamInfoStream)
	zn CurrSpace
	s ^tmpDHCEKG("SaveExamInfo",OrdId,$zdt($h,3))=saveRtn
	q saveRtn
}

/// w ##class(web.DHCEkgService).testCardBill("85","0000000015")
ClassMethod testCardBill(LocId As %String, InRegNo As %String) As %String
{
	set rtn=""
	;set StartDate="",Enddate=""
	s StartDate=$p($h,",",1)-7,Enddate=$p($h,",",1)+2
	set ordInfo=..GetEKGInfoTxt(LocId,InRegNo,StartDate,Enddate)
	b ;ordInfo
	
	if (ordInfo="") q rtn
	
	set configLocID="85$55"
	set configExamItem="心电图阿托品试验$常规心电图检查"
	
	set tmpID=-1
	for i=1:1:$length($p(configLocID,"$")) do
	.set tmpLocID=$p(configLocID,"$",i)
	.if (tmpLocID=LocId) do
	..set tmpID=i
	
	set examItemFilter=""
	if (tmpID'=-1) do
	.set examItemFilter=$p(configExamItem,"$",tmpID)
	b ;examItemFilter
	set flag="0"
	set CurrSpace=$ZNSPACE
	for i=1:1:$length($p(ordInfo,"$")) do
	.if (flag'="0") q
	.set tmpOrdInfo=$p(ordInfo,"$",i)
	.if (tmpOrdInfo="") q
	.set examInfo=$p(tmpOrdInfo,"^",8)
	.set examItem=$p(examInfo,"#",3)	;医嘱名称
	.if (examItem="") q
	.b ;examItem
	.if (examItemFilter[examItem) do
	..b ;tmpOrdInfo
	..do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	..set rtn=##class(dbo.interface.EkgService).SaveCardBill(tmpOrdInfo,LocId,"636")
	..zn CurrSpace
	..set flag="1"
	zn CurrSpace
	q rtn
}

/// 获取医嘱串信息 供常规检查界面调用
/// modify time:2017-07-13
/// modify by yyl: 南大二院旧his获取医嘱接口
/// w ##class(web.DHCEkgService).GetEKGInfoTxtNDEYOldHIS("")
ClassMethod GetEKGInfoTxtNDEYOldHIS(InRegNo As %String) As %String
{
	s Info="顾亚平^男^55岁^13870371273^1962-07-12 00:00:00.000^^血透诊区一诊室^徐红^2017-06-12 14:59:15.997^住院病人^分泌性中耳炎;鼻炎;鼻^1^常规心电图检查(12导联)+床旁心电图检查(18导联)+心电图阿托品试验" ;调用平台接口获取医嘱信息
	s rtnEKGInfo=""
	//重拼医嘱串	
	if (Info="") q ""
	s Name=$p(Info,"^",1)  ;姓名
	s Gender=$p(Info,"^",2)  ;性别
	s Age=$p(Info,"^",3)  ;年龄
	s Telephone=$p(Info,"^",4)  ;电话
	s BirthDay=$p(Info,"^",5)  ;生日
	s Adress=$p(Info,"^",6)  ;地址
	s Dept=$p(Info,"^",7)  ;申请科室
	s Doctor=$p(Info,"^",8)  ;申请医生
	s RequestTime=$p(Info,"^",9)  ;申请日期
	s PatSource=$p(Info,"^",10)  ;病人类型（门诊病人、住院病人）
	s ClinDiag=$p(Info,"^",11)  ;诊断
	s History=$p(Info,"^",12)  ;病史
	s ExamItems=$p(Info,"^",13)  ;医嘱
	
	s DobDate=$p(BirthDay," ",1)  ;出生日期
	s ReqDate=$p(RequestTime," ",1)  ;医嘱日期
	s ReqTime=$p(RequestTime," ",2)  ;医嘱时间
	
	//科室
	s DeptStr="#-"_Dept
	s DeptRowid=$o(^CTLOC(0,"Desc",Dept,""))
	if (DeptRowid'="") do
	.s DeptInfo=..EKGGetDeptByCode(DeptRowid)
	.q:(DeptInfo="")
	.s DeptName=$p(DeptInfo,"$",2)
	.s DeptCode=$p(DeptInfo,"$",4)
	.s DeptStr=DeptRowid_"#"_DeptCode_"-"_DeptName
	
	//医嘱
	f i=1:1:$l(ExamItems,"+") do 
	.b ;i
	.s ExamItem=$p(ExamItems,"+",i)
	.s ExamInfo=..GetExamInfoByExamName(ExamItem)
	.b ;ExamInfo
	.Do MakeInfoStr
	
   Quit rtnEKGInfo ;$$$OK
MakeInfoStr
    s DataEx=PatSource_"^"_InRegNo_"^"_"^"_Name_"^"_Gender_"^"_Age_"^"_DobDate_"^"_ExamInfo
	_"^"_"^"_"^"_"^"_"^"_"^"_ClinDiag
	_"^"_Doctor_"^"_DeptStr_"^"_"^"_"^"_"^"
	_"^"_"^"_"^"_"^"_"^"_"^"_"^"_"^"
	_"^"_"^"_"^"_ReqDate_"^"_ReqTime_"^"_"^"_"^"_""_"^"_""_"^"_""_"^N^"
	_"^"_Dept_"^"_"^"_"^"_"^"_"^"_"^"_"^"_"^"_"^"
	_"^"_"^"_"^"_"^"_"^"
	_"^"_"^"_"^"_Telephone_"^"_"^"_"^"_"^"
	_"^"
	b ;DataEx
	if rtnEKGInfo'="" s rtnEKGInfo=rtnEKGInfo_"$"
    s rtnEKGInfo=rtnEKGInfo_DataEx
    b ;rtnEKGInfo
}

/// 获取医嘱串信息 供常规检查界面调用
/// modify time:2017-07-13
/// modify by yyl: 根据医嘱项名称查询医嘱项信息
/// w ##class(web.DHCEkgService).GetExamInfoByExamName("常规心电图检查(12导联)")
ClassMethod GetExamInfoByExamName(ExamName As %String) As %String
{
	s rtn=""
	s ARCIMSubscript=""
	f  s ARCIMSubscript=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(ExamName),ARCIMSubscript)) q:ARCIMSubscript=""  d
	.s ARCIMVersion=0
	.f  s ARCIMVersion=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(ExamName),ARCIMSubscript,ARCIMVersion)) q:ARCIMVersion=""  d
	..s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
	..s ARCIMCode=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",1)
	..s rtn=ARCIMRowId_"#"_ARCIMCode_"#"_ExamName
	q rtn
}

/// modify time:2017-07-18
/// modify by yyl: 给影像CCA发送心电检查结果
/// 给影像CCA发送心电检查结果
/// w ##class(web.DHCEkgService).SentEKGInfoToCCA("16180495||11")
ClassMethod SentEKGInfoToCCA(OrdId As %String) As %String
{
	s rtn=""
	q:OrdId=""
	
	s AdmNo=..GetAdmNobyOrdID(OrdId)
	s CurrentSpace=$ZNSPACE
	zn "dhc-ekg"
	s Info=##class(dbo.DHCEKGPdfPathOut).GetRptInfoCCA(OrdId,AdmNo)
	zn CurrentSpace
	s ^tmpDHCEKG("SentEKGInfoToCCA",OrdId)=Info
	s rtn=##class(DHCENS.CCA.BS.HisToCCAService).submitReport(Info)
	s ^tmpDHCEKG("SentEKGInfoToCCA",OrdId,"rtn")=rtn
	q rtn
}

/// modify time:2017-07-18
/// modify by yyl: 获取体检医嘱的到达状态
/// 获取体检医嘱的到达状态
/// w ##class(web.DHCEkgService).GetTJArrivedInfo("16180495||11") 
ClassMethod GetTJArrivedInfo(OEORID)
{
	s rtnARRIVED="N"
	q:OEORID="" rtnARRIVED
	 s CRMORowId=$o(^DHCPECRMO(0,"OEORI",OEORID,""))
	 q:CRMORowId="" rtnARRIVED
	 s IADMDR=$p($g(^DHCPECRMO(CRMORowId)),"^",3)
	 q:IADMDR="" rtnARRIVED
	 s Status=$p($g(^DHCPEIADM(IADMDR)),"^",8)
	 ;q:Status'="ARRIVED"
	 q:Status=""
	 if (Status="ARRIVED") do
	 .s rtnARRIVED="ARRIVED"
	 q rtnARRIVED
}

/// web.DHCEkgService.cls
/// Creator：      xzy
/// CreatDate：    2017-8-9
/// Modify: 	   
/// ModifyDate：   
/// Description:   南大二院 纳龙传加急或者急诊状态 心电进行状态更新
/// Input：        纳龙唯一标识
/// 						patType 1=急诊加急 2=住院加急 3=胸痛加急
/// 				   statusFlag 0=不加急 1=加急
/// Output：       string
/// Return：       string
/// Others：
/// w ##class(web.DHCEkgService).SentEKGEmergencyOrUrgent("abc-121-dadf-2323-jkf3","1","1")
ClassMethod SentEKGEmergencyOrUrgent(uniqNo As %String, patType As %String, statusFlag As %String)
{
	set ^tmpDHCEKG("SentEKGEmergencyOrUrgent",$Now()) = uniqNo_","_patType_","_statusFlag
	if uniqNo="" set ^tmpDHCEKG("SentEKGEmergencyOrUrgent",$h)="参数 唯一标识为空" quit "参数 唯一标识为空"
	
	set CurrentSpace=$ZNSPACE
	set ^tmpDHCEKG("SentEKGEmergencyOrUrgent",$Now())="当前命名空间:"_CurrentSpace
	
	do ##class(DHCEkgSystemParam).SetEKGNameSpace()
	set ^tmpDHCEKG("SentEKGEmergencyOrUrgent",$Now())="切换到命名空间:"_$ZNSPACE
	
	/*
	体检	1	TJ
	住院	2	ZY
	门诊	3	MZ
	急诊	4	JZ
	其它	5	QT
	住院加急	41	ZYJJ
	急诊加急	42	JZJJ
	胸痛加急	43	XTJJ
	*/
	
	set flag=""
	set reqId=""
	for  set reqId=$o(^dbo.tblRequestD(reqId),-1) quit:reqId=""  do
	.set reqInfo=^dbo.tblRequestD(reqId)
	.quit:reqInfo=""
	.set reason=$listget(reqInfo,17,"")
	.quit:reason=""
	.quit:reason'=uniqNo
	.set ^tmpDHCEKG("SentEKGEmergencyOrUrgent",$Now())="查到的reqId="_reqId_",reqInfo="_reqInfo
	.if patType'="" do //根据病人类型来处理 patType 1=急诊加急 2=住院加急 3=胸痛加急
	
	..if statusFlag="1" do //statusFlag=1 加急
	...set patCode=40+patType
	...do ##class(dbo.tblRequest).updatePatCode(reqId,patCode)
	
	...set flag="Y"
	...quit
	
	zn CurrentSpace
	set ^tmpDHCEKG("SentEKGEmergencyOrUrgent",$Now())="切换回到命名空间:"_$ZNSPACE
	
	set rtn="ok"
	if flag="" set rtn="fail"
	quit rtn
	
	/*
	.//..&sql(update dbo.tblRequest set ekgPatSouceCode=:patCode where id=:reqId)
	.//..set $list(^dbo.tblRequestD(reqId),15)=40+patType 
	.//..set ^dbo.tblRequestI("idxPatSourceCode"," "_40+patType,reqId)=""
	.//.else  do //不加急 //statusFlag=0 不加急
	.//..if patType="1" do //patType 1=急诊加急 2=住院加急 3=胸痛加急
	.//...set $list(^dbo.tblRequestD(reqId),15)="4"  //急诊
	.//...set ^dbo.tblRequestI("idxPatSourceCode"," 4",reqId)=""
	.//..else  if patType="2" do
	.//...set $list(^dbo.tblRequestD(reqId),15)="2"  //住院
	.//...set ^dbo.tblRequestI("idxPatSourceCode"," 2",reqId)=""
	.//..else  if patType="3" do
	.//...set $list(^dbo.tblRequestD(reqId),15)="2"  //住院
	.//...set ^dbo.tblRequestI("idxPatSourceCode"," 2",reqId)=""
	
	.//else  do
	.//.set $list(^dbo.tblRequestD(reqId),15)="4"  //急诊
	.//.set ^dbo.tblRequestI("idxPatSourceCode"," 4",reqId)=""
	.
	*/
}

/// create
/// 
/// web.DHCEkgService.cls
/// Creator：      yyl
/// CreatDate：    2017-10-25
/// Modify: 	   
/// ModifyDate：   
/// Description:   发布报告时把完成的医嘱号更新到医生站提供的表中
/// Input：        登记号，就诊号，医嘱号
/// Output：       string
/// Return：       string
/// Others：
/// w ##class(web.DHCEkgService).UpdataEkgRpt("","","")
ClassMethod UpdataEkgRpt(OrdId As %String) As %String
{
	s rtn=""
	q:(OrdId="") ""
	s OrderRowid=$p(OrdId,"||",1)
	s paadmdr=$p(^OEORD(OrderRowid),"^",1)
	q:(paadmdr="") ""
	s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
	q:(papatmasmdr="") ""
	s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
	q:(RegNo="") ""
	s rtn=##class(web.DHCRisclinicQueryOEItemDo).UpdataRisRet(RegNo,paadmdr,OrdId)
	q rtn
}

/// create: yyl
/// create: 2017-10-26
/// desc:   获取该就诊ID是否存在已完成心电报告
/// input:  EpisodeID:就诊ID
/// return: 1:存在;0:不存在
/// w ##class(web.DHCEkgService).GetEkgReportState(179)
ClassMethod GetEkgReportState(EpisodeID As %String) As %String
{
	s CurrentSpace=$ZNSPACE
	d ##class(DHCEkgSystemParam).SetEKGNameSpace()
	s ReportState=##class(Interface.Service.EKGInterface).GetEkgReportState(EpisodeID)
	zn CurrentSpace
	q ReportState
}

/// create: yyl
/// create: 2017-10-26
/// desc:   获取医嘱号对应的心电检查结果
/// input:  OrdId:医嘱号
/// return: 报告医生，报告时间，诊断结论
/// w ##class(web.DHCEkgService).GetEkgDiagnose("81||108")
ClassMethod GetEkgDiagnose(OrdId As %String) As %GlobalCharacterStream
{
	s CurrentSpace=$ZNSPACE
	d ##class(DHCEkgSystemParam).SetEKGNameSpace()
	s EKGDiagnose=##class(Interface.Service.EKGInterface).GetEkgDiagnose(OrdId)
	zn CurrentSpace
	q EKGDiagnose
}

/// create: yyl
/// create: 2017-10-26
/// desc:   获取心电测量参数(一个结论可能对应多份测量值,但大部分医院是一份)
/// input:  OrdId:医嘱号
/// return: 测量参数
/// w ##class(web.DHCEkgService).GetEkgParam("89||109")
ClassMethod GetEkgParam(OrdId As %String) As %GlobalCharacterStream
{
	s CurrentSpace=$ZNSPACE
	d ##class(DHCEkgSystemParam).SetEKGNameSpace()
	s ParamRtn=##class(Interface.Service.EKGInterface).GetEkgParam(OrdId)
	zn CurrentSpace
	q ParamRtn
}

/// create: yyl
/// create: 2017-10-26
/// desc:   获取心电报告路径
/// input:  OrdId:医嘱号
/// return: 心电报告web路径
/// w ##class(web.DHCEkgService).GetEkgReportUrl("81||108")
ClassMethod GetEkgReportUrl(OrdId As %String) As %GlobalCharacterStream
{
	new $NAMESPACE
	s CurrentSpace=$ZNSPACE
	d ##class(DHCEkgSystemParam).SetEKGNameSpace()
	s EKGReportUrl=##class(Interface.Service.EKGInterface).GetEkgReportUrl(OrdId)
	zn CurrentSpace
	q EKGReportUrl
}

/// web.DHCEkgService.cls
/// Creator：      xzy
/// CreatDate：    2017-11-13
/// Modify: 	   
/// ModifyDate：   
/// Description:   江苏省中医接口方法
/// Input：        oeordid=医嘱号
/// Return：       json string
/// Others
/// w ##class(web.DHCEkgService).saveReport("")
ClassMethod saveReport(oeordid As %String) As %String
{
	set CurrentSpace=$ZNSPACE
	do ##class(DHCEkgSystemParam).SetEKGNameSpace()
	set rtn=##class(Interface.Service.EKGInterfaceJSSZY).saveReport(oeordid)
	zn CurrentSpace
	quit rtn
}

/// Creator：      yangyali
/// CreatDate：    2017-12-18
/// Description:： 获取申请单列表南大二院增加交费状态参数和返回值
/// Table：        
/// Input：        
/// Output：       
/// Return：       xml串
/// Others：
/// w ##class(web.DHCEkgService).GetConOrdNDEY("85","","","2018-3-1","2018-4-3","","","")
ClassMethod GetConOrdNDEY(locId As %String, patID As %String, patName As %String, stdDate As %String, endDate As %String, examItemID As %String, execFlag As %String, feeFlag As %String, patientType = "") As %GlobalCharacterStream
{
	;set ^tmpInfo11111=locId_patID_ patName_ stdDate_endDate_examItemID_execFlag
	
	i locId=$c(0) s locId = ""	
	i patID=$c(0) s patID = ""	
	i patName=$c(0) s patName = ""	
	i stdDate=$c(0) s stdDate = ""	
	i endDate=$c(0) s endDate = ""	
	i examItemID=$c(0) s examItemID = ""	
	i execFlag=$c(0) s execFlag = ""		
	i feeFlag=$c(0) s feeFlag = ""	
	i patientType=$c(0) s patientType = ""	
	i execFlag="" s execFlag="0"
	
	s RegNoLength = +##class(web.DHCEkgNo).getRegNoLength() //卡号长度
	s CardNoLength = +##class(web.DHCEkgNo).getCardNoLength() //卡号长度
	s InNoLength = +##class(web.DHCEkgNo).getInNoLength() //住院号长度
	
	i (##class(web.DHCEkgNo).numberIsContainRegNo(patID)="1") s patID=$p(patID,"^",1) d
	.s patID=##class(web.DHCEkgNo).getFullNo(patID,RegNoLength)
	else  i (##class(web.DHCEkgNo).numberIsContainCardNo(patID)="1") s patID=$p(patID,"^",1) d
	.s patID=##class(web.DHCEkgNo).getFullNo(patID,CardNoLength)
	.s patID= ##class(web.DHCEkgNo).getRegNoByCardNo(patID)
	else  i (##class(web.DHCEkgNo).numberIsContainMedCareNo(patID)="1") s patID=$p(patID,"^",1) d
	.s patID=##class(web.DHCEkgNo).getFullNo(patID,InNoLength)
	.s patID= ##class(web.DHCEkgNo).getRegNoByInNo(patID)
    
    i ((patID="")&(patName'="")) d
	.s patID=##class(web.DHCEkgNo).getRegNoByPatName(patName,locId)	
	
	i stdDate="" s stdDate=$p($h,",",1)-5
	else  s stdDate=$zdh(stdDate,3)
	i endDate="" s endDate=$p($h,",",1)+1
	else  s endDate=$zdh(endDate,3)	
	
	k objStream,objsub	
	s objStream=##class(%GlobalCharacterStream).%New()
	d objStream.Write("<WinData>")	
	
	s regNoLen = $l(patID,"^")	
	s tmpPatID=patID	
	s ^tmpGetConOrd("sss")=locId_","_patID_","_patName_","_stdDate_","_endDate_","_examItemID_","_execFlag_","_patientType
	f regNoI=1:1:regNoLen
	{
		s patID=$p(tmpPatID,"^",regNoI)
		s rs=##class(%ResultSet).%New("web.DHCEkgGetConOrd:GetConOdrFee")
		d rs.Execute("",patID,stdDate,endDate,locId, execFlag,feeFlag,"","",examItemID,"","","","",patientType)
		while(rs.Next())
		{
			s ^tmpGetConOrd("iii")="3333333"
			;b ;RegNo
			s objsub=##class(web.EKGConOrd).%New()
			s objsub.RegNo= $g(rs.Data("RegNo"))  //0
			s objsub.PatName = $g(rs.Data("PatName"))
			s objsub.BedCode = $g(rs.Data("BedCode"))
			s objsub.ArcimDesc = $g(rs.Data("ArcimDesc"))
			s objsub.OeordId = $g(rs.Data("OeordId"))
			s objsub.OrdStatDesc = $g(rs.Data("OrdStatDesc"))
			s objsub.OrcatDesc = $g(rs.Data("OrcatDesc"))
			s objsub.ExecDateTime = $g(rs.Data("ExecDateTime")) //医嘱名7
			s objsub.ExecCtcpDesc = $g(rs.Data("ExecCtcpDesc"))
			s objsub.CtcpDesc = $g(rs.Data("CtcpDesc"))
			s objsub.RecLocDesc = $g(rs.Data("RecLocDesc"))
			s objsub.OrdDateTime = $g(rs.Data("OrdDateTime"))
			s objsub.AdmDep = $g(rs.Data("AdmDep"))  //12预约时间
			s objsub.notes = $g(rs.Data("notes")) //13
			s objsub.OrdUnitCost = $g(rs.Data("OrdUnitCost"))
			s objsub.OrdQty = $g(rs.Data("OrdQty"))
			s objsub.OrdCost = $g(rs.Data("OrdCost"))
			s objsub.admId = $g(rs.Data("admId")) //19病人状态
			;s objsub.Medicare = $g(rs.Data("Medicare"))  //20
			s objsub.Medicare = $g(rs.Data("medcareno"))  //20
			s objsub.OrdBilled = $g(rs.Data("BillStatus"))
			s objsub.OrdBilled = $g(rs.Data("Billed"))
			s objsub.admType = $g(rs.Data("admType"))
			s objsub.Sex=$g(rs.Data("sex"))
			s objsub.Age=$g(rs.Data("age"))
			s objsub.DobDate = $g(rs.Data("dobDate"))	
			s objsub.FeeState = $g(rs.Data("FeeState"))	//是否缴费	
			s objsub.RptState = $g(rs.Data("RptState"))	//报告状态	
			s Status=objsub.XMLExportToStream(.Xml)
			d objStream.CopyFrom(Xml)
		}	
		d rs.Close()	
	}	
	d objStream.Write("</WinData>")
	b ; d objStream.OutputToDevice()
	q objStream
}

/// Creator：      yangyali
/// CreatDate：    2018-1-5
/// Description:： 按照输入条件查询符合条件的记录
/// Table：        
/// Input：        社保卡号
/// Output：       登记号
/// Return：       登记号
/// w ##class(web.DHCEkgService).GetRegNoBYSocialSecNo("")
ClassMethod GetRegNoBYSocialSecNo(SocialSecNo As %String) As %String
{
	s PAPMIIPNo=""
	 s PAPMIRowId=""
	 ;s PAPMIRowId=$o(^PAPERi("PAPER_PatName",$$ALPHAUP^SSUTIL4(SocialSecNo),PAPMIRowId))
	 s PAPMIRowId=$o(^PAPERi("PAPER_YBCode",$$ALPHAUP^SSUTIL4(SocialSecNo),PAPMIRowId))
	 b ;0
	 if (PAPMIRowId'="") do
	 .s PAPMIIPNo=$p(^PAPER(PAPMIRowId,"PAT",1),"^",1)
	 q PAPMIIPNo
}

/// Creator：      yangyali
/// CreatDate：    2018-3-27
/// Description:： 查询心电检查信息
/// Table：        
/// Input：        医嘱号
/// Output：       
/// Return：       
/// w ##class(web.DHCEkgService).GetExamDesc("59||224")
ClassMethod GetExamDesc(OrdId As %String) As %String
{
	
	new $NAMESPACE
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
	quit:OrdId="" ""
	set (ArbiterDate,ArbiterTime,ArbiterDoctor,ArbiterUserName,NegativePositive,Diagnose)=""
	set reqId=$o(^dbo.tblRequestI("idxExamCode"," "_OrdId,""))
	quit:reqId="" ""
	set examId = $o(^dbo.tblExaminationI("idxRequestID",reqId,""))
	quit:examId="" ""
	set examInfo=^dbo.tblExaminationD(examId)
	set ExamNo="EKG||"_OrdId	;检查号：EKG||医嘱ID
	set ReportUserID=$list(examInfo,7)
	set ArbiterUserID=$list(examInfo,7)
	set ReportDateTime=$list(examInfo,6)
	set ArbiterDateTime=$list(examInfo,6)
	set NegativePositive=$list(examInfo,30)
	set Diagnose=$list(examInfo,11)
	set ReportDate=$p(ReportDateTime," ",1)
	set ReportTime=$p(ReportDateTime," ",2)
	set ArbiterDate=$p(ArbiterDateTime," ",1)
	set ArbiterTime=$p(ArbiterDateTime," ",2)
	if (NegativePositive="阳性") set Positive="Y"
	set ReportUserName="",ArbiterUserName=""
	if ReportUserID'="" do
	.set ReportUserName=$list(^dbo.tblUserD(ReportUserID),8)
	if ArbiterUserID'="" do
	.set ArbiterUserName=$list(^dbo.tblUserD(ArbiterUserID),8)
	set ReportDoctor=ReportUserID_"@"_ReportUserName
	set ArbiterDoctor=ArbiterUserID_"@"_ArbiterUserName
	b ;Diagnose
	if Diagnose'[$c(10) set Diagnose=Diagnose_$c(10) ;2015-08-13
	set D=""
	for i=1:1:$l(Diagnose,$c(10)) do
	.set tmpD=$p(Diagnose,$c(10),i)
	.if (tmpD'="") do
	..if (D="") set D=tmpD
	..else  set D=D_","_tmpD
	b ;00
	set Diagnose=D
	
	set ExamInfo=ArbiterDate_"^"_ArbiterTime_"^"_ArbiterDoctor_"^"_ArbiterUserName_"^"_
				NegativePositive_"^"_Diagnose
	quit ExamInfo
}

/// Creator：      yangyali
/// CreatDate：    2018-4-28
/// Description:   获取医嘱列表
/// Input：        接收科室ID^病区名称^登记号^开始日期^结束日期^是否执行^医嘱项^病人类型
/// Return：       xml串
/// w ##class(web.DHCEkgService).GetEkgOrdList("85^中西医结合一科护理单元^^2018-1-18^2018-5-18^^^")
ClassMethod GetEkgOrdList(param As %String) As %GlobalCharacterStream
{
	s locId=$p(param,"^",1)
	s zone=$p(param,"^",2)
	s patID=$p(param,"^",3)
	s stdDate=$p(param,"^",4)
	s endDate=$p(param,"^",5)
	s execFlag=$p(param,"^",6)
	s examItemID=$p(param,"^",7)	
	s patientType =$p(param,"^",8)
	s patName = ""
	
	s RegNoLength = +##class(web.DHCEkgNo).getRegNoLength() //卡号长度
	s CardNoLength = +##class(web.DHCEkgNo).getCardNoLength() //卡号长度
	s InNoLength = +##class(web.DHCEkgNo).getInNoLength() //住院号长度
	
	if (##class(web.DHCEkgNo).numberIsContainRegNo(patID)="1") set patID=$p(patID,"^",1) do
	.set patID=##class(web.DHCEkgNo).getFullNo(patID,RegNoLength)
	else  if (##class(web.DHCEkgNo).numberIsContainCardNo(patID)="1") set patID=$p(patID,"^",1) do
	.set patID=##class(web.DHCEkgNo).getFullNo(patID,CardNoLength)
	.set patID= ##class(web.DHCEkgNo).getRegNoByCardNo(patID)
	else  if (##class(web.DHCEkgNo).numberIsContainMedCareNo(patID)="1") set patID=$p(patID,"^",1) do
	.set patID=##class(web.DHCEkgNo).getFullNo(patID,InNoLength)
	.set patID= ##class(web.DHCEkgNo).getRegNoByInNo(patID)
    
    if ((patID="")&(patName'="")) do
	.set patID=##class(web.DHCEkgNo).getRegNoByPatName(patName,locId)	
	
	if stdDate="" set stdDate=$p($h,",",1)-5
	else  s stdDate=$zdh(stdDate,3)
	if endDate="" set endDate=$p($h,",",1)+1
	else  s endDate=$zdh(endDate,3)	
	
	k objStream,objsub	
	s objStream=##class(%GlobalCharacterStream).%New()
	d objStream.Write("<WinData>")	
		
	set ^tmpDHCEKG("GetEkgOrdList")=locId_","_zone_","_patID_","_patName_","_stdDate_","_endDate_","_examItemID_","_execFlag_","_patientType
	
	s rs=##class(%ResultSet).%New("web.DHCEkgGetConOrd:GetOrdList")
	d rs.Execute("",patID,stdDate,endDate,locId,zone,execFlag,"","",examItemID,"","","","",patientType)
	while(rs.Next())
	{
			set objsub=##class(web.DHCEkgOrdItem).%New()
			s objsub.RegNo= $g(rs.Data("RegNo"))  //0
			s objsub.PatName = $g(rs.Data("PatName"))
			s objsub.BedCode = $g(rs.Data("BedCode"))
			s objsub.ArcimDesc = $g(rs.Data("ArcimDesc"))
			s objsub.OeordId = $g(rs.Data("OeordId"))
			s objsub.OrdStatDesc = $g(rs.Data("OrdStatDesc"))
			s objsub.OrcatDesc = $g(rs.Data("OrcatDesc"))
			s objsub.ExecDateTime = $g(rs.Data("ExecDateTime")) //医嘱名7
			s objsub.ExecCtcpDesc = $g(rs.Data("ExecCtcpDesc"))
			s objsub.CtcpDesc = $g(rs.Data("CtcpDesc"))
			s objsub.RecLocDesc = $g(rs.Data("RecLocDesc"))
			s objsub.OrdDateTime = $g(rs.Data("OrdDateTime"))
			s objsub.AdmDep = $g(rs.Data("AdmDep"))  //12预约时间
			s objsub.notes = $g(rs.Data("notes")) //13
			s objsub.OrdUnitCost = $g(rs.Data("OrdUnitCost"))
			s objsub.OrdQty = $g(rs.Data("OrdQty"))
			s objsub.OrdCost = $g(rs.Data("OrdCost"))
			s objsub.admId = $g(rs.Data("admId")) //19病人状态
			s objsub.Medicare = $g(rs.Data("medcareno"))  //20
			s objsub.OrdBilled = $g(rs.Data("BillStatus"))
			s objsub.OrdBilled = $g(rs.Data("Billed"))
			s objsub.admType = $g(rs.Data("admType"))
			s objsub.Sex=$g(rs.Data("sex"))
			s objsub.Age=$g(rs.Data("age"))
			s objsub.DobDate = $g(rs.Data("dobDate"))		
			s Status=objsub.XMLExportToStream(.Xml)
			d objStream.CopyFrom(Xml)
	}	
	d rs.Close()		
	d objStream.Write("</WinData>")
	b ; d objStream.OutputToDevice()
	quit objStream
}

/// creator: 	yyl
/// create:		2018-6-14
/// desc:		获取医嘱项的价格，由EKGGetExamByCode改写
/// input:		医嘱项ID
/// output:		单价
/// w ##class(web.DHCEkgService).GetOrdPrice("8845||1")
ClassMethod GetOrdPrice(ArcimId As %String) As %String
{
	s return=""
	s Today=$P($H,",",1)
	q:ArcimId="" ""
	;s ARCIMSubscript=$P(ArcimId,"||",1)
	;s Version=$P(ArcimId,"||",2)
	;Q:'$d(^ARCIM(ARCIMSubscript,Version,1)) "医嘱指针不存在"
	;s ArcimCode=$P(^ARCIM(ARCIMSubscript,Version,1),"^",1)
	;s ArcimDesc=$P(^ARCIM(ARCIMSubscript,Version,1),"^",2)
	;i $D(^ARC("ALIAS",0,"ARCIM",ArcimId)) d
	;.s ALIASId=$O(^ARC("ALIAS",0,"ARCIM",ArcimId,""))
	;.s InputCode=$P(^ARC("ALIAS",ALIASId),"^",6)
	;e  d
	;.s InputCode=""
	s SumPrice=0
	;^DHCOLT(0,"ARTTA","745||1",12,61526,1058)
	s TarId=""  f  s TarId=$O(^DHCOLT(0,"ARTTA",ArcimId,TarId)) q:TarId=""  d
	.;停止的不处理
	.s TARIEndDate=$P(^DHCTARI(TarId),"^",12)
	.s:TARIEndDate>=Today TARIEndDate=""
	.;取有效的调价记录
	.s AdjId=""
	.s TAdjId=0  f  s TAdjId=$O(^DHCTARI(TarId,"P",TAdjId)) q:TAdjId=""  d
	..s TPEndDate=$P(^DHCTARI(TarId,"P",TAdjId),"^",4)
	..s:TPEndDate>=Today TPEndDate=""
	..i $G(TPEndDate)="" d
	...s AdjId=TAdjId
	...q
	..q:AdjId=""
	.q:AdjId=""
	.i ($G(TARIEndDate)=""&$G(AdjId)'="") d  ;收费项目并且存在有效的调价记录
	..s StarDate=""  f  s StarDate=$O(^DHCOLT(0,"ARTTA",ArcimId,TarId,StarDate)) q:StarDate=""  d
	...s DHCOLTId=$O(^DHCOLT(0,"ARTTA",ArcimId,TarId,StarDate,""))
	...s EndDate=$P(^DHCOLT(DHCOLTId),"^",5)
	...s:EndDate>=Today EndDate=""
	...;医嘱项目和收费项目关联停止的不处理
	...i $G(EndDate)="" d
	....s Qty=$P(^DHCOLT(DHCOLTId),"^",3)
	....s IPrice=$P($g(^DHCTARI(TarId,"P",AdjId)),"^",5)
	....s:Qty="" Qty=1
	....s:IPrice="" IPrice=0
	....s SumPrice=SumPrice + (Qty*IPrice)
	s return=SumPrice
	q return
}

/// creator: 	yyl
/// create:		2018-6-20
/// desc:		执行医嘱后调用计费接口，更新账单信息
/// input:		医嘱rowid，用户
/// output:		调用结果
/// w ##class(web.DHCEkgService).UpdateBill("652||39","455")
ClassMethod UpdateBill(OrdId As %String, user As %String) As %String
{
	//调用计费组接口 web.UDHCJFBILL.cls   BILLN()
	/// adm,就诊rowid；billuser:用户
	/// ordstr:住院传执行记录rowid，门诊传医嘱rowid
	/// flag:0按就诊账单，1按医嘱或执行记录账单
	s rtn=""
	s OrdItmRowId=$P(OrdId,"||",1)
    s paadmdr=$p(^OEORD(OrdItmRowId),"^",1)
    ;s rtn=##class(web.UDHCJFBILL).BILLN(paadmdr,user,"",0)
    ;q rtn
    s patienttype=$p($g(^PAADM(paadmdr)),"^",2) ;病人类型
    b ; w patienttype
    i (patienttype="I") d
    .s ExecRowid=""
	.s Sub=0
	.f  s Sub=$O(^OEORD(+OrdId,"I",$P(OrdId,"||",2),"X",Sub))  q:Sub=""  d		
	..s ExecRowid=OrdId_"||"_Sub
	..b ; w ExecRowid
	..s rtn=##class(web.UDHCJFBILL).BILLN(paadmdr,user,ExecRowid,1)
	else  d
	.s rtn=##class(web.UDHCJFBILL).BILLN(paadmdr,user,OrdId,1)
	q rtn
}

/// Creator:		yangyali
/// CreatDate:		2018-6-28
/// Description:	接口调用统一入口
/// Table:			dbo.tblInterface
/// Input：			KeyName:方法编码,InputParameter:方法参数，参数之间以~分隔
/// Return：		接口调用结果
/// w ##class(web.DHCEkgService).EKGInterfaceInvoke("GETDHCEKGREPORT","172018060800000001")
ClassMethod EKGInterfaceInvoke(KeyName As %String, InputParameter As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $zt="err"
	s n = $zu(41)
	s method = $zu(41,n-2)	
	s proc = ##class(%SYS.ProcessQuery).%OpenId($j)
	s ip = proc.StartupClientIPAddress
	s proc=""
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^方法代码为空!")
	q:(""=KeyName) stream
	s methodInfo=""
	
	s methodInfo=..QueryInterfaceMethod(KeyName)
	
	i (methodInfo=""){
		d stream.Write("-1^方法不存在!")
		b ; d stream.OutputToDevice()
		q stream
	}
	s methodStatus=$li(methodInfo,5)
	if (methodStatus="N") {
		d stream.Write("-1^方法未启用!")
		b ; d stream.OutputToDevice()
		q stream
	}
	s className=$li(methodInfo,7)
	s methodName=$li(methodInfo,8)
	s input=$li(methodInfo,10)
	s output=$li(methodInfo,11)
	s inputType=$p($p(input,"~",1),"`",1)
	s inputDesc=$p($p(input,"~",1),"`",3)
	s OutputType=$p($p(output,"~",1),"`",1)
	s OutputDesc=$p($p(output,"~",1),"`",2)
	b ;info
		
	if inputType="%GlobalCharacterStream" {
		s @"InputParameter"=InputParameter
		s exeStr="rtn=##class("_className_")."_methodName_"(InputParameter)"
	}
	else {
		s tmpInput=InputParameter.Read(InputParameter.Size)
		s paramCount=$length(input,"~") ;方法入参个数
		s inputCount=$length(tmpInput,"~") ;传入参数个数
		i (paramCount'=inputCount)
		{
			d stream.Write("-1^入参个数不匹配，入参数为"_paramCount)
			b ; d stream.OutputToDevice()
			q stream
		}
		
		s InputParameters=""
		f i=1:1:paramCount {
			s tmpParam="Param"_i
			s @tmpParam=$p(tmpInput,"~",i)
			b ; w tmpParam
			i (InputParameters'="") s InputParameters=InputParameters_","_tmpParam
			e  s InputParameters=tmpParam
		}
		b ; w InputParameters
		s exeStr="rtn=##class("_className_")."_methodName_"("_InputParameters_")"
		
		;s @"InputParameter"=InputParameter.Read(InputParameter.Size)
		;s exeStr="rtn=##class("_className_")."_methodName_"(InputParameter)"
	}
	b ; w exeStr
	s @exeStr
	if OutputType="%GlobalCharacterStream" {
		set result=@"rtn"
		b ; d result.OutputToDevice()
		q result
	}
	else {
		set outputContent=@"rtn"
		set stream=##class(%GlobalCharacterStream).%New()
		d stream.Write(outputContent)
		b ; d stream.OutputToDevice()
		Quit stream
	}
	
err
	b ;err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	b ; d stream.OutputToDevice()
	q stream
}

ClassMethod QueryInterfaceMethod(KeyName As %String) As %List
{
	s rtnList=""
	new $NAMESPACE
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
	s rowId=$o(^dbo.tblInterfaceI("idxMethodCode"," "_KeyName,""))
	i (rowId=""){
		q rtnList
	}
	s rtnList=^dbo.tblInterfaceD(rowId)
	q rtnList
}

/// 方法说明：	获取心电医嘱列表
/// 创建者：	杨亚莉
/// 创建时间：	2018-7-19
/// 入参：		locId^patCode^patInCode^cardNo^patName^stdDate^endDate^examItemFilter^execFlag^feeFlag^patientType
/// 			科室ID^登记号^住院号^卡号^姓名^开始日期^结束日期^医嘱过滤^执行状态^费用状态^病人来源
/// Modifier: xzy  规定返回xml：第一个子节点为列头以及列name  避免在c#还得写一次 直接在此进行规定，c#端不用修改任何东西
/// 返回值：	医嘱信息(xml流)
/// w ##class(web.DHCEkgService).getEKGOrdInfo("85^38^^^^2022-6-8^2022-11-19^^^^^申请")
ClassMethod getEKGOrdInfo(params As %String) As %GlobalCharacterStream
{
	s (locId,patCode,patInCode,cardNo,patName,stdDate,endDate,examItemFilter,execFlag,feeFlag,patientType,examState,rptState)=""
	s locId=$p(params,"^",1)
	s patCode=$p(params,"^",2)
	s patInCode=$p(params,"^",3)
	s cardNo=$p(params,"^",4)  
	s patName=$p(params,"^",5)  
	s stdDate=$p(params,"^",6)  
	s endDate=$p(params,"^",7)  
	s examItemFilter=$p(params,"^",8)  
	s execFlag=$p(params,"^",9)  
	s feeFlag=$p(params,"^",10)
	s patientType=$p(params,"^",11)
	s examState=$p(params,"^",12)
	s rptState=$p(params,"^",13)
	s RegNoLength = +##class(web.DHCEkgNo).getRegNoLength() //卡号长度
	s CardNoLength = +##class(web.DHCEkgNo).getCardNoLength() //卡号长度
	s InNoLength = +##class(web.DHCEkgNo).getInNoLength() //住院号长度
	
	i (patCode'="") s patCode=##class(web.DHCEkgNo).getFullNo(patCode,RegNoLength)
	e  i (patInCode'="") d
	.s patInCode=##class(web.DHCEkgNo).getFullNo(patInCode,InNoLength)
	.s patCode= ##class(web.DHCEkgNo).getRegNoByInNo(patInCode)
	e  i (cardNo'="") d
	.s cardNo=##class(web.DHCEkgNo).getFullNo(cardNo,CardNoLength)
	.s patCode= ##class(web.DHCEkgNo).getRegNoByCardNo(cardNo)
	e  i (patName'="") d
	.s patCode=##class(web.DHCEkgNo).getRegNoByPatName(patName,locId)	
	
	i stdDate="" s stdDate=$p($h,",",1)-5
	else  s stdDate=$zdh(stdDate,3)
	i endDate="" s endDate=$p($h,",",1)+1
	else  s endDate=$zdh(endDate,3)	
	
	k objStream,objsub	
	s objStream=##class(%GlobalCharacterStream).%New()
	d objStream.Write("<WinData>")
	
	//形成列以及列头 第一个节点数据
	s objsub=##class(web.EKGConOrd).%New()
	s objsub.RegNo= "登记号"  //0
	s objsub.PatName = "姓名"
	s objsub.Age="年龄"
	s objsub.Sex="性别"
	s objsub.admType = "病人来源"
	s objsub.ArcimDesc = "医嘱名称"
	s objsub.OrdDateTime = "开单时间"
	s objsub.OrdStatDesc = "医嘱状态"
	s objsub.FeeStateCode = "费用状态代码"
	s objsub.FeeState = "费用状态"	//是否缴费
	s objsub.ExamState = "检查状态"	//检查状态
    ;s objsub.RptState = "报告状态"	//报告状态	
	s objsub.CtcpDesc =  "申请医生"
	s objsub.OeordId = "医嘱ID"
	s objsub.Ward = "病区"
	s objsub.BedCode = "床号"
	s objsub.Medicare = "住院号"  //20
	s objsub.IsUrgent = "是否加急"  //20
	s objsub.CliDig = "临床诊断"
	//s objsub.RegisterTime = "登记时间"	//登记时间
	//s objsub.RegisterUserName = "登记人"	//登记人姓名
	//s objsub.BedCode = $g(rs.Data("BedCode"))
	//s objsub.OrcatDesc = $g(rs.Data("OrcatDesc"))
	//s objsub.ExecDateTime = $g(rs.Data("ExecDateTime")) //医嘱名7
	//s objsub.ExecCtcpDesc = $g(rs.Data("ExecCtcpDesc"))
	//s objsub.RecLocDesc = $g(rs.Data("RecLocDesc"))
	//s objsub.AdmDep = $g(rs.Data("AdmDep"))  //12预约时间
	//s objsub.notes = $g(rs.Data("notes")) //13
	//s objsub.OrdUnitCost = $g(rs.Data("OrdUnitCost"))
	//s objsub.OrdQty = $g(rs.Data("OrdQty"))
	//s objsub.OrdCost = $g(rs.Data("OrdCost"))
	//s objsub.admId = $g(rs.Data("admId")) //19病人状态
	//s objsub.OrdBilled = $g(rs.Data("BillStatus"))
	//s objsub.OrdBilled = $g(rs.Data("Billed"))
	//s objsub.DobDate = $g(rs.Data("dobDate"))	
	//s objsub.RegisterUserId = $g(rs.Data("RegisterUserId"))	//登记人ID
	s Status=objsub.XMLExportToStream(.Xml)
	d objStream.CopyFrom(Xml)
	//形成列以及列头
	
	;i (execFlag="")
	;{
	;	s execFlag="0"
	;	d GetQueryOrd
			
	;	s execFlag="1"
	;	d GetQueryOrd
	;}
	;else
	;{
		d GetQueryOrd
	;}
	d objStream.Write("</WinData>")
	s ^tmpDHCEKG("YYLYZDJ")=objStream.Read()
	
	b ; d objStream.OutputToDevice()
	q objStream
GetQueryOrd
	s rs=##class(%ResultSet).%New("web.DHCEkgGetConOrd:GetEkgOdrList")
	d rs.Execute(locId,patCode,stdDate,endDate,examItemFilter, execFlag,feeFlag,patientType,examState,rptState)
	while(rs.Next())
	{
		s objsub=##class(web.EKGConOrd).%New()
		s objsub.RegNo= $g(rs.Data("RegNo"))  //0
		s objsub.PatName = $g(rs.Data("PatName"))
		s objsub.BedCode = $g(rs.Data("BedCode"))
		s objsub.ArcimDesc = $g(rs.Data("ArcimDesc"))
		s objsub.OeordId = $g(rs.Data("OeordId"))
		s objsub.OrdStatDesc = $g(rs.Data("OrdStatDesc"))
		s objsub.OrcatDesc = $g(rs.Data("OrcatDesc"))
		s objsub.ExecDateTime = $g(rs.Data("ExecDateTime")) //医嘱名7
		s objsub.ExecCtcpDesc = $g(rs.Data("ExecCtcpDesc"))
		s objsub.CtcpDesc = $g(rs.Data("CtcpDesc"))
		s objsub.RecLocDesc = $g(rs.Data("RecLocDesc"))
		s objsub.OrdDateTime = $g(rs.Data("OrdDateTime"))
		s objsub.AdmDep = $g(rs.Data("AdmDep"))  //12预约时间
		s objsub.notes = $g(rs.Data("notes")) //13
		s objsub.OrdUnitCost = $g(rs.Data("OrdUnitCost"))
		s objsub.OrdQty = $g(rs.Data("OrdQty"))
		s objsub.OrdCost = $g(rs.Data("OrdCost"))
		s objsub.admId = $g(rs.Data("admId")) //19病人状态
		s objsub.Medicare = $g(rs.Data("medcareno"))  //20
		s objsub.OrdBilled = $g(rs.Data("BillStatus"))
		s objsub.OrdBilled = $g(rs.Data("Billed"))
		s objsub.admType = $g(rs.Data("admType"))
		s objsub.Sex=$g(rs.Data("sex"))
		s objsub.Age=$g(rs.Data("age"))
		s objsub.DobDate = $g(rs.Data("dobDate"))	
		s objsub.FeeState = $p($g(rs.Data("FeeState")),"^",2)	//是否缴费
		s objsub.FeeStateCode =$p($g(rs.Data("FeeState")),"^",1)	
		;s objsub.RptState = $g(rs.Data("RptState"))	//报告状态	
		s objsub.ExamState = $g(rs.Data("ExamState"))	//报告状态
		s objsub.Ward = $g(rs.Data("wardid"))	//病区
		s objsub.BedCode = $g(rs.Data("BedCode"))	//床号
		s objsub.IsUrgent = $g(rs.Data("IsUrgent")) //是否加急
		s objsub.CliDig = $g(rs.Data("Diagnosis")) //
		s Status=objsub.XMLExportToStream(.Xml)
		d objStream.CopyFrom(Xml)
	}
	d rs.Close()
}

ClassMethod getEKGOrdInfo4m(locId As %String, patCode As %String, patInCode As %String, cardNo As %String, patName As %String, stdDate As %String, endDate As %String, examItemFilter As %String, execFlag As %String, feeFlag As %String, patientType As %String) As %GlobalCharacterStream
{
	//n (locId,patCode,patInCode,cardNo,patName,stdDate,endDate,examItemFilter,execFlag,feeFlag,patientType)
	s RegNoLength = +##class(web.DHCEkgNo).getRegNoLength() //卡号长度
	s CardNoLength = +##class(web.DHCEkgNo).getCardNoLength() //卡号长度
	s InNoLength = +##class(web.DHCEkgNo).getInNoLength() //住院号长度
	
	i (patCode'="") s patCode=##class(web.DHCEkgNo).getFullNo(patCode,RegNoLength)
	e  i (patInCode'="") d
	.s patInCode=##class(web.DHCEkgNo).getFullNo(patInCode,InNoLength)
	.s patCode= ##class(web.DHCEkgNo).getRegNoByInNo(patInCode)
	e  i (cardNo'="") d
	.s cardNo=##class(web.DHCEkgNo).getFullNo(cardNo,CardNoLength)
	.s patCode= ##class(web.DHCEkgNo).getRegNoByCardNo(cardNo)
	e  i (patName'="") d
	.s patCode=##class(web.DHCEkgNo).getRegNoByPatName(patName,locId)	
	
	i stdDate="" s stdDate=$p($h,",",1)-5
	else  s stdDate=$zdh(stdDate,3)
	i endDate="" s endDate=$p($h,",",1)+1
	else  s endDate=$zdh(endDate,3)	
	
	k objStream,objsub	
	s objStream=##class(%GlobalCharacterStream).%New()
	d objStream.Write("<WinData>")
	
	//形成列以及列头 第一个节点数据
	s objsub=##class(web.EKGConOrd).%New()
	s objsub.RegNo= "登记号"  //0
	s objsub.PatName = "姓名"
	s objsub.Age="年龄"
	s objsub.Sex="性别"
	s objsub.admType = "病人来源"
	s objsub.ArcimDesc = "医嘱名称"
	s objsub.OrdDateTime = "开单时间"
	s objsub.OrdStatDesc = "医嘱状态"
	;s objsub.FeeState = "费用状态"	//是否缴费
	s objsub.ExamState = "检查状态"	//检查状态
	;s objsub.RptState = "报告状态"	//报告状态	
	s objsub.CtcpDesc =  "申请医生"
	s objsub.OeordId = "医嘱ID"
	//s objsub.RegisterTime = "登记时间"	//登记时间
	//s objsub.RegisterUserName = "登记人"	//登记人姓名
	//s objsub.BedCode = $g(rs.Data("BedCode"))
	//s objsub.OrcatDesc = $g(rs.Data("OrcatDesc"))
	//s objsub.ExecDateTime = $g(rs.Data("ExecDateTime")) //医嘱名7
	//s objsub.ExecCtcpDesc = $g(rs.Data("ExecCtcpDesc"))
	//s objsub.RecLocDesc = $g(rs.Data("RecLocDesc"))
	//s objsub.AdmDep = $g(rs.Data("AdmDep"))  //12预约时间
	//s objsub.notes = $g(rs.Data("notes")) //13
	//s objsub.OrdUnitCost = $g(rs.Data("OrdUnitCost"))
	//s objsub.OrdQty = $g(rs.Data("OrdQty"))
	//s objsub.OrdCost = $g(rs.Data("OrdCost"))
	//s objsub.admId = $g(rs.Data("admId")) //19病人状态
	//s objsub.Medicare = $g(rs.Data("medcareno"))  //20
	//s objsub.OrdBilled = $g(rs.Data("BillStatus"))
	//s objsub.OrdBilled = $g(rs.Data("Billed"))
	//s objsub.DobDate = $g(rs.Data("dobDate"))	
	//s objsub.RegisterUserId = $g(rs.Data("RegisterUserId"))	//登记人ID
	s Status=objsub.XMLExportToStream(.Xml)
	d objStream.CopyFrom(Xml)
	//形成列以及列头
	
	i (execFlag="")
	{
		s execFlag="0"
		d GetQueryOrd1
			
		s execFlag="1"
		d GetQueryOrd1
	}
	else
	{
		d GetQueryOrd1
	}
	d objStream.Write("</WinData>")
	b ; d objStream.OutputToDevice()
	q objStream
GetQueryOrd1
	s rs=##class(%ResultSet).%New("web.DHCEkgGetConOrd:GetEkgOdrList")
	d rs.Execute(locId,patCode,stdDate,endDate,examItemFilter, execFlag,feeFlag,patientType)
	while(rs.Next())
	{
		s objsub=##class(web.EKGConOrd).%New()
		s objsub.RegNo= $g(rs.Data("RegNo"))  //0
		s objsub.PatName = $g(rs.Data("PatName"))
		s objsub.BedCode = $g(rs.Data("BedCode"))
		s objsub.ArcimDesc = $g(rs.Data("ArcimDesc"))
		s objsub.OeordId = $g(rs.Data("OeordId"))
		s objsub.OrdStatDesc = $g(rs.Data("OrdStatDesc"))
		s objsub.OrcatDesc = $g(rs.Data("OrcatDesc"))
		s objsub.ExecDateTime = $g(rs.Data("ExecDateTime")) //医嘱名7
		s objsub.ExecCtcpDesc = $g(rs.Data("ExecCtcpDesc"))
		s objsub.CtcpDesc = $g(rs.Data("CtcpDesc"))
		s objsub.RecLocDesc = $g(rs.Data("RecLocDesc"))
		s objsub.OrdDateTime = $g(rs.Data("OrdDateTime"))
		s objsub.AdmDep = $g(rs.Data("AdmDep"))  //12预约时间
		s objsub.notes = $g(rs.Data("notes")) //13
		s objsub.OrdUnitCost = $g(rs.Data("OrdUnitCost"))
		s objsub.OrdQty = $g(rs.Data("OrdQty"))
		s objsub.OrdCost = $g(rs.Data("OrdCost"))
		s objsub.admId = $g(rs.Data("admId")) //19病人状态
		s objsub.Medicare = $g(rs.Data("medcareno"))  //20
		s objsub.OrdBilled = $g(rs.Data("BillStatus"))
		s objsub.OrdBilled = $g(rs.Data("Billed"))
		s objsub.admType = $g(rs.Data("admType"))
		s objsub.Sex=$g(rs.Data("sex"))
		s objsub.Age=$g(rs.Data("age"))
		s objsub.DobDate = $g(rs.Data("dobDate"))	
		;s objsub.FeeState = $g(rs.Data("FeeState"))	//是否缴费	
		;s objsub.RptState = $g(rs.Data("RptState"))	//报告状态	
		s objsub.ExamState = $g(rs.Data("ExamState"))	//报告状态
		
		s Status=objsub.XMLExportToStream(.Xml)
		d objStream.CopyFrom(Xml)
	}
	d rs.Close()
}

/// 方法说明：	获取已登记医嘱列表
/// 创建者：	杨亚莉
/// 创建时间：	2018-7-24
/// 入参：		execDept^patCode^patInCode^cardNo^patName^stdDate^endDate^examItemFilter
/// 			接收科室Code^登记号^住院号^卡号^姓名^开始日期^结束日期^医嘱过滤项
/// 返回值：	医嘱信息(xml流)
/// Modifier: xzy  规定返回xml：第一个子节点为列头以及列name  避免在c#还得写一次 直接在此进行规定，c#端不用修改任何东西
/// w ##class(web.DHCEkgWebServiceNew).getEKGRegOrderInfo("功能检查科心电图^^^^^2018-7-30^2018-7-31")
ClassMethod getEKGRegOrderInfo(params As %String) As %GlobalCharacterStream [ WebMethod ]
{
	k objStream,objsub	
	s objStream=##class(%GlobalCharacterStream).%New()
	d objStream.Write("<WinData>")
	
	//形成列以及列头 第一个节点数据
	s objsub=##class(web.EKGConOrd).%New()
	s objsub.RegNo= "登记号"  //0
	s objsub.PatName = "姓名"
	s objsub.Age="年龄"
	s objsub.Sex="性别"
	s objsub.admType = "病人来源"
	s objsub.ArcimDesc = "医嘱名称"
	s objsub.OrdDateTime = "开单时间"
	s objsub.OrdStatDesc = "医嘱状态"
	;s objsub.FeeState = "费用状态"	//是否缴费
	s objsub.ExamState = "检查状态"	//检查状态
	;s objsub.RptState = "报告状态"	//报告状态	
	s objsub.CtcpDesc =  "申请医生"
	s objsub.OeordId = "医嘱ID"
	s objsub.RegisterTime = "登记时间"	//登记时间
	s objsub.RegisterUserName = "登记人"	//登记人姓名
	s objsub.BedCode = "床号"
	//s objsub.OrcatDesc = $g(rs.Data("OrcatDesc"))
	//s objsub.ExecDateTime = $g(rs.Data("ExecDateTime")) //医嘱名7
	//s objsub.ExecCtcpDesc = $g(rs.Data("ExecCtcpDesc"))
	//s objsub.RecLocDesc = $g(rs.Data("RecLocDesc"))
	//s objsub.AdmDep = $g(rs.Data("AdmDep"))  //12预约时间
	//s objsub.notes = $g(rs.Data("notes")) //13
	//s objsub.OrdUnitCost = $g(rs.Data("OrdUnitCost"))
	//s objsub.OrdQty = $g(rs.Data("OrdQty"))
	//s objsub.OrdCost = $g(rs.Data("OrdCost"))
	//s objsub.admId = $g(rs.Data("admId")) //19病人状态
	//s objsub.Medicare = "住院号"  //20
	//s objsub.wardid = "病区"
	//s objsub.OrdBilled = $g(rs.Data("BillStatus"))
	//s objsub.OrdBilled = $g(rs.Data("Billed"))
	//s objsub.DobDate = $g(rs.Data("dobDate"))	
	//s objsub.RegisterUserId = $g(rs.Data("RegisterUserId"))	//登记人ID
	s Status=objsub.XMLExportToStream(.Xml)
	d objStream.CopyFrom(Xml)
	//形成列以及列头
	
	s rs=##class(%ResultSet).%New("web.DHCEkgGetConOrd:GetRegOrdList")
	d rs.Execute(params)
	while(rs.Next())
	{
		s objsub=##class(web.EKGConOrd).%New()
		s objsub.RegNo= $g(rs.Data("RegNo"))  //0
		s objsub.PatName = $g(rs.Data("PatName"))
		s objsub.BedCode = $g(rs.Data("BedCode"))
		s objsub.ArcimDesc = $g(rs.Data("ArcimDesc"))
		s objsub.OeordId = $g(rs.Data("OeordId"))
		s objsub.OrdStatDesc = $g(rs.Data("OrdStatDesc"))
		s objsub.OrcatDesc = $g(rs.Data("OrcatDesc"))
		s objsub.ExecDateTime = $g(rs.Data("ExecDateTime")) //医嘱名7
		s objsub.ExecCtcpDesc = $g(rs.Data("ExecCtcpDesc"))
		s objsub.CtcpDesc = $g(rs.Data("CtcpDesc"))
		s objsub.RecLocDesc = $g(rs.Data("RecLocDesc"))
		s objsub.OrdDateTime = $g(rs.Data("OrdDateTime"))
		s objsub.AdmDep = $g(rs.Data("AdmDep"))  //12预约时间
		s objsub.notes = $g(rs.Data("notes")) //13
		s objsub.OrdUnitCost = $g(rs.Data("OrdUnitCost"))
		s objsub.OrdQty = $g(rs.Data("OrdQty"))
		s objsub.OrdCost = $g(rs.Data("OrdCost"))
		s objsub.admId = $g(rs.Data("admId")) //19病人状态
		b ;23wardid
		s objsub.Medicare = $g(rs.Data("medcareno"))  //20
		s objsub.Ward = $g(rs.Data("wardid"))  //20
		s objsub.CliDig=$g(rs.Data("Diagnosis"))
		s objsub.OrdBilled = $g(rs.Data("BillStatus"))
		s objsub.OrdBilled = $g(rs.Data("Billed"))
		s objsub.admType = $g(rs.Data("admType"))
		s objsub.Sex=$g(rs.Data("sex"))
		s objsub.Age=$g(rs.Data("age"))
		s objsub.DobDate = $g(rs.Data("dobDate"))	
		;s objsub.FeeState = $g(rs.Data("FeeState"))	//是否缴费	
		;s objsub.RptState = $g(rs.Data("RptState"))	//报告状态	
		s objsub.ExamState = $g(rs.Data("ExamState"))	//检查状态
		s objsub.RegisterTime = $g(rs.Data("RegisterTime"))	//登记时间
		s objsub.RegisterUserId = $g(rs.Data("RegisterUserId"))	//登记人ID
		s objsub.RegisterUserName = $g(rs.Data("RegisterUserName"))	//登记人姓名
		
		
		s Status=objsub.XMLExportToStream(.Xml)
		d objStream.CopyFrom(Xml)
	}
	d rs.Close()
	d objStream.Write("</WinData>")
	b ; d objStream.OutputToDevice()
	q objStream
}

/// update by caoll 2022-11-29 只改变医嘱状态与检查号状态
/// 方法说明：	登记医嘱
/// 创建者：	杨亚莉
/// 创建时间：	2018-7-19
/// 入参：		ordID^userLoginName^LocCode
/// 			医嘱ID^用户工号^判断出院状态("Y")^判断缴费状态("Ys")
/// 返回值：	登记结果 成功:"0" 失败:"-编码^"_原因 
/// w ##class(web.DHCEkgService).regEKGInfo4BS("1014||34^739^功能检查科心电图^N^N")
ClassMethod regEKGInfo4BS(params As %String) As %String
{
	s rtn=""
	try
	{
		s ordID=$p(params,"^",1) //医嘱号
		s userLoginName=$p(params,"^",2) //用户名
		s PLocCode=$p(params,"^",3) //科室编码
		s JudgeGoOutPat=$p(params,"^",4) //判断出院不允许操作
		s JudgeFee=$p(params,"^",5) //判断未交费不允许操作
		
		set OrderRowid=$p(ordID,"||",1) 
		set itemsub=$p(ordID,"||",2) 
		
		//入参是否合法
		if (ordID="")
		{
			s rtn="-2^医嘱ID不能为空"
		}
		elseif((OrderRowid="")!(itemsub=""))
		{
			s rtn="-2^医嘱ID格式不合法"
		}
		else
		{
			if (userLoginName="")
			{
				s rtn="-2^用户工号不能为空"
			}
			else
			{
				//判断出院
				if (JudgeGoOutPat="Y")
				{
					s paadmdr=$p(^OEORD(OrderRowid),"^",1)
    				s dischargeStatus=..GetCurrentDischargeStatus(paadmdr)
    				if ((dischargeStatus="F")!(dischargeStatus="T"))
    				{
	    				s rtn="患者已出院，不可进行操作"
    				}
				}
				//判断费用
				if (JudgeFee="Y")
				{
					s ordInfo=..getDHCEKGOrderInfoBylistOrderItem(ordID)
					if (ordInfo'="")
					{
						s patType=$p(ordInfo,"^",1)
						s canOpr=..CanOperate(ordID,patType)
						if (canOpr="1")
						{
							s rtn ="未收费医嘱不能登记"
						}
					}
					else
					{
						s rtn="判断费用，获取医嘱失败"
					}
				}
			
				if (rtn="")
				{
					//执行医嘱
					//判断医嘱状态是否需要执行
					s ItemStatDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13) ; 医嘱状态
					s status=$p($g(^OEC("OSTAT",ItemStatDR)),"^",1)
					if (status="V") //E执行 V核实 D停止 U作废 C撤销 I未审核
					{
						set UserId=..GetUserRowId($p(userLoginName,"@",1))
						d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Execute",$zd($h,3),$zt($p($h,",",2),1),ordID_"^"_UserId,ordID,"regEKGInfo")	
						s execRtn=##class(appcom.OEOrdItem).Execute(ordID,UserId) //执行医嘱
						d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Execute",$zd($h,3),$zt($p($h,",",2),1),execRtn,ordID,"regEKGInfo rtn")	
						s ^tmpDHCEKG("regEKGInfo",ordID,"Execute",$ZDT($H,3))=UserId_"==>"_execRtn
						if (execRtn'="0")
						{
							s rtn="-3^执行医嘱失败"_execRtn
						}
					}
					
					s ExamNo="EKG||"_ordID
					s flag=..#ChangeStatus ;调用ris或ens接口改变检查状态
					if (flag="ris")
					{
						//登记
						s RID=$Replace(ordID,"||","_")
						s Status="ARRIVE"
						s info=RID_"^^"_$zd($h,3)_"^"_$p($zdt($h,3)," ",2)_"^"_userLoginName_"^^^"_ExamNo_"^"_Status_"^^^"
						s regRtn=##class(RISService.TrakRISService).SetExamStatusInfo(info)
						s ^tmpDHCEKG("regEKGInfo",ordID,"SetExamStatusInfo",$ZDT($H,3))=info_"==>"_regRtn
						if (regRtn'=0)
						{
							s rtn=rtn_"-4^改变检查状态失败"
						}
						else
						{
							s rtn="0"
						}
					}
					else
					{
						s ExamStatus="SC" ;登记	
						s inputObj=##class(web.DHCEkg.SystemStatus.Dict.UpdateRequest).%New()
						s inputObj.ExamID=ExamNo
						s inputObj.OEOrdItemID=ordID
						s inputObj.Position=""
						s inputObj.SourceSystem="EKG"
						s inputObj.Status=ExamStatus
						s inputObj.UpDateTime=$zdt($h,3)
						s inputObj.UserID=userLoginName ;工号
						s inputObj.UserName=..GetUserNameByCode(userLoginName) ;姓名
		
						s json=##class(ext.util.JsonObject).ObjToJson(inputObj,"","") ;web.DHCEkg.SystemStatus.Dict.UpdateRequest
						s json="["_json_"]"
						s jsonStream=##class(%GlobalCharacterStream).%New()
						d jsonStream.Write(json)
						b ; w json
						s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
						//这块没详细测试 返回结果
						s rtnUpdateStr=""
						
						i ($IsObject(rtnUpdateSystem))
						{
						
							s rtnUpdateStr=rtnUpdateSystem.Read()
						}
						else
						{
							s rtnUpdateStr=rtnUpdateSystem
						}
						
						s ^tmpDHCEKG("UpdateSystemStatus",ordID,$zdt($h,3),ExamStatus)=json_"==>"_rtnUpdateStr
						if (+rtnUpdateStr<0)
						{
							s rtn=rtn_"-4^改变检查状态失败" 
						}
						else
						{
							s rtn="0"
						}
					}
				}
			}
		} 
		
		
	}catch(err)
	{
		s errStr="Exception in Location:"_err.Location_" Data:"_err.Data_"InnerException:"_err.InnerException
		d ##class(web.DHCEkg.Base).Log("Error","web.DHCEkgService","regEKGInfo4BS",
			$zd($h,3),$zt($p($h,",",2),1),errStr)
		s rtn="-1^"_errStr
	}
	q rtn
}

/// 方法说明：	登记医嘱
/// 创建者：	杨亚莉
/// 创建时间：	2018-7-19
/// 入参：		ordID^userLoginName^LocCode
/// 			医嘱ID^用户工号^登记者的登录科室code
/// 返回值：	登记结果
/// w ##class(web.DHCEkgService).regEKGInfo("42||165^admin^心电图室")
ClassMethod regEKGInfo(params As %String) As %String
{
	b ;222
	s $ZT="ERRORRegisterOrd"
	s rtn=""
	s ordID=$p(params,"^",1)
	s userLoginName=$p(params,"^",2)
	s PLocCode=$p(params,"^",3)
	q:(ordID="") "医嘱ID不能为空"
	q:(userLoginName="") "用户工号不能为空"
	s ordInfo=..getDHCEKGOrderInfoBylistOrderItem(ordID)
	q:(ordInfo="") "查询医嘱失败"
	
	
	;判断计费状态是否可以登记
	s Bill=$p(ordInfo,"^",45)
	s patType=$p(ordInfo,"^",1)
	s canOpr=..CanOperate(ordID,patType)
	q:(canOpr="1") "未收费医嘱不能登记"
	
	s OrderRowid=$p(ordID,"||",1)
	s itemsub=$p(ordID,"||",2)
	
	;判断是否已出院
    s paadmdr=$p(^OEORD(OrderRowid),"^",1)
    s dischargeStatus=..GetCurrentDischargeStatus(paadmdr)
    q:((dischargeStatus="F")!(dischargeStatus="T")) "患者已出院，不可进行操作"
	
	;s recLocDr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6) //不取此
	s recLocDr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6) ;获取医嘱接收科室DR
	s deptDr=..GetDeptDrByCode(PLocCode) ;获取登记科室DR
	q:(recLocDr'=deptDr) "选择的执行科室与医嘱接收科室DR不一致"
	set recLocCode=PLocCode
	s ordInfo=ordInfo_"^"_recLocCode_"^"_userLoginName ;医嘱串^接收科室ID^用户工号
	s saveRtn=""
	d SaveRegisterInfo
	s ^tmpDHCEKG("regEKGInfo",ordID,"SaveRegisterInfo",$ZDT($H,3))=recLocCode_"^"_userLoginName_"==>"_saveRtn
	q:(saveRtn'["ok") saveRtn
	
	
	set UserId=..GetUserRowId($p(userLoginName,"@",1))
	d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Execute",$zd($h,3),$zt($p($h,",",2),1),ordID_"^"_UserId,ordID,"regEKGInfo")	
	s execRtn=##class(appcom.OEOrdItem).Execute(ordID,UserId) //执行医嘱
	d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Execute",$zd($h,3),$zt($p($h,",",2),1),execRtn,ordID,"regEKGInfo rtn")	
	s ^tmpDHCEKG("regEKGInfo",ordID,"Execute",$ZDT($H,3))=UserId_"==>"_execRtn
	s rtn=rtn_"^"_execRtn
	q:(execRtn'="0") "执行医嘱失败"
	
	s ExamNo="EKG||"_ordID
	s flag=..#ChangeStatus ;调用ris或ens接口改变检查状态
	if (flag="ris")
	{
		//登记
		s RID=$Replace(ordID,"||","_")
		s Status="ARRIVE"
		s info=RID_"^^"_$zd($h,3)_"^"_$p($zdt($h,3)," ",2)_"^"_userLoginName_"^^^"_ExamNo_"^"_Status_"^^^"
		s regRtn=##class(RISService.TrakRISService).SetExamStatusInfo(info)
		s ^tmpDHCEKG("regEKGInfo",ordID,"SetExamStatusInfo",$ZDT($H,3))=info_"==>"_regRtn
	}
	else
	{
		s ExamStatus="SC" ;登记	
		s inputObj=##class(web.DHCEkg.SystemStatus.Dict.UpdateRequest).%New()
		s inputObj.ExamID=ExamNo
		s inputObj.OEOrdItemID=ordID
		s inputObj.Position=""
		s inputObj.SourceSystem="EKG"
		s inputObj.Status=ExamStatus
		s inputObj.UpDateTime=$zdt($h,3)
		s inputObj.UserID=userLoginName ;工号
		s inputObj.UserName=..GetUserNameByCode(userLoginName) ;姓名
		s OrderRowid=$p(ordID,"||",1)
		s itemsub=$p(ordID,"||",2)
		s recLoc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6) //检查科室rowid
		s CtLocCode=$P(^CTLOC(recLoc),"^",1)
		s CtLocDesc=$P(^CTLOC(recLoc),"^",2)
		s inputObj.OperateDeptCode=CtLocCode 
		s inputObj.OperateDept=CtLocDesc 
		
		s json=##class(ext.util.JsonObject).ObjToJson(inputObj,"","") ;web.DHCEkg.SystemStatus.Dict.UpdateRequest
		s json="["_json_"]"
		s jsonStream=##class(%GlobalCharacterStream).%New()
		d jsonStream.Write(json)
		b ; w json
		s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
		
		s ^tmpDHCEKG("UpdateSystemStatus",ordID,$zdt($h,3),ExamStatus)=json_"==>"_rtnUpdateSystem.Read()
		
		//预约接口，调用平台总线服务再次发送检查闭环
		try
		{
			s OrderRowid=$p(ordID,"||",1)
			s itemsub=$p(ordID,"||",2)
			q:((OrderRowid="")!(itemsub=""))
			q:($g(^OEORD(OrderRowid,"I",itemsub,1))="") ; 判断是否为his医嘱
			s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
			s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
			s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
			s StatusParameter=##class(web.DHCEkg.Dict.StatusParameter).%New()
			s StatusParameter.PATPatientID=RegNo
			s StatusParameter.PAADMVisitNumber=paadmdr
			s StatusParameter.OEORIOrderItemID=ordID
			s StatusParameter.OEORIOrdExecID=""
			s StatusParameter.SpecimenID=""
			s StatusParameter.RISRExamID=ExamNo
			s StatusParameter.RISRSystemType="EKG"
			s StatusParameter.Position=""
			s StatusParameter.OperAppID=""
			s StatusParameter.BloodAppID=""
			s StatusParameter.BloodBagNo=""
			s StatusParameter.ConsultAppID=""
			s StatusParameter.StatusCode="SC"
			s StatusParameter.UpdateUserCode=userLoginName
			s StatusParameter.UpdateUserName=..GetUserNameByCode(userLoginName)
			s StatusParameter.UpdateDateTime=$zdt($h,3)
			
			s header=##class(web.DHCEkg.Dict.Header).%New()
			s header.SourceSystem="EKG"
			s header.MessageID=$system.Util.CreateGUID()				
			s body=##class(web.DHCEkg.Dict.Body).%New()
			s body.StatusParameter=StatusParameter
			s request=##class(web.DHCEkg.Dict.Request).%New()
			s request.Header=header
			s request.Body=body
			s Status=request.XMLExportToString(.inputXmlStr)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","regEKGInfo",
				$zd($h,3),$zt($p($h,",",2),1),inputXmlStr,ordID,"MES0079")
			s soapObj=##class(web.DHCEkg.Soap.RIMServiceSoap).%New()
			s ensRtn=soapObj.HIPMessageServer("MES0079",inputXmlStr)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","regEKGInfo",
				$zd($h,3),$zt($p($h,",",2),1),ensRtn,ordID,"MES0079 rtn")
		}
		catch
		{
			b ; error
			d ##class(web.DHCEkg.Base).Log("Error","web.DHCEkgService","regEKGInfo",
				$zd($h,3),$zt($p($h,",",2),1),$ze,ordID,"MES0079")
		}
	}
	s rtn=""
	q rtn
	
SaveRegisterInfo
	new $namespace
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	;zn "dhc-ekg-dev"
	s saveRtn=##class(EKGService.EKGRegister).saveEkgInfo(ordInfo)
	zn CurrSpace
 	
ERRORRegisterOrd
	Set ErrorMsg=$ZE
	zn "DHC-APP"
	i (ordID=$c(0))!(ordID=$c(-1)) s ordID=1
	// ^DHCEKG("Error",方法名,日期,时间)=异常详情
	s ^DHCEKG("Error","regEKGInfo",$zd($h,3),$zt($p($h,",",2)))=ErrorMsg
	//s ^RegisterOrdError($zd($h,3),$zt($p($h,",",2)))=ErrorMsg	
	q ErrorMsg
}

/// Creator：		yangyali
/// CreatDate：		2020-8-18
/// Modify:			
/// ModifyDate：	
/// Description:	获取科室DR
/// Input：			科室编码，dbo.tblDictDept.ekgCode
/// Output：		科室DR，dbo.tblDictDept.ekgExtend，与his库中的DR一致
ClassMethod GetDeptDrByCode(deptCode As %String) As %String
{
	new $namespace
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s deptDr=##class(EKGService.Method.GetDeptInfo).GetDeptDrByCode(deptCode)
	zn CurrSpace
	q deptDr
}

ClassMethod executeOrder4M(orderNo As %String, loginName As %String)
{
	s ordInfo=..getDHCEKGOrderInfoBylistOrderItem(orderNo)
	q:(ordInfo="") "ERROR:查询医嘱失败"
	;判断计费状态是否可以登记
	s Bill=$p(ordInfo,"^",45)
	s patType=$p(ordInfo,"^",1)
	s canOpr=..CanOperate(orderNo,patType)
	q:(canOpr="1") "ERROR:未收费医嘱不能登记"
	
	set UserId=..GetUserRowId($p(loginName,"@",1))
	d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Execute",$zd($h,3),$zt($p($h,",",2),1),ordID_"^"_UserId,ordID,"executeOrder4M")	
	s execRtn=##class(appcom.OEOrdItem).Execute(ordID,UserId) //执行医嘱
	d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Execute",$zd($h,3),$zt($p($h,",",2),1),execRtn,ordID,"executeOrder4M rtn")	
	q:(execRtn'="0") "ERROR:执行医嘱失败"
	
	s ExamNo="EKG||"_orderNo
	s flag=..#ChangeStatus ;调用ris或ens接口改变检查状态
	if (flag="ris")
	{
		//登记
		s RID=$Replace(orderNo,"||","_")
		s Status="ARRIVE"
		s info=RID_"^^"_$zd($h,3)_"^"_$p($zdt($h,3)," ",2)_"^"_userLoginName_"^^^"_ExamNo_"^"_Status_"^^^"
		s rtn=##class(RISService.TrakRISService).SetExamStatusInfo(info)
		
		q "0"
	}
	else
	{
		s ExamStatus="SC" ;登记	
		s inputObj=##class(web.DHCEkg.SystemStatus.Dict.UpdateRequest).%New()
		s inputObj.ExamID=ExamNo
		s inputObj.OEOrdItemID=orderNo
		s inputObj.Position=""
		s inputObj.SourceSystem="EKG"
		s inputObj.Status=ExamStatus
		s inputObj.UpDateTime=$zdt($h,3)
		s inputObj.UserID=loginName ;工号
		s inputObj.UserName=..GetUserNameByCode(loginName) ;姓名
		
		s json=##class(ext.util.JsonObject).ObjToJson(inputObj,"","") ;web.DHCEkg.SystemStatus.Dict.UpdateRequest
		s json="["_json_"]"
		s jsonStream=##class(%GlobalCharacterStream).%New()
		d jsonStream.Write(json)
		b ; w json
		s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
		
		q "0"
	}
}

/// update by caoll 2022-11-29 只改变医嘱状态与检查号状态
/// 方法说明：	撤销登记医嘱
/// 创建者：	杨亚莉
/// 创建时间：	2018-7-24
/// 入参：		ordID^userLoginName
/// 			医嘱ID^用户工号^申请单状态
/// 返回值：	取消登记结果 成功:"0" 失败:"-编码^"_原因 
/// w ##class(web.DHCEkgService).revokeEKGOrder4BS("1015||10^admin^CSC")
ClassMethod revokeEKGOrder4BS(params As %String) As %String [ WebMethod ]
{
	s rtn=""
	try
	{
		
		s ordID=$p(params,"^",1)
		s userLoginName=$p(params,"^",2)
		s sqdStatus=$p(params,"^",3)
		
		set OrderRowid=$p(ordID,"||",1) 
		set itemsub=$p(ordID,"||",2)
		
		//判断入参合法
		if ((ordID="")!(userLoginName="")!(sqdStatus=""))
		{
			s rtn="-2^参数不合法"
		}
		elseif((OrderRowid="")!(itemsub=""))
		{
			s rtn="-2^医嘱ID格式不合法"
		}
		else
		{
			set UserId=..GetUserRowId($p(userLoginName,"@",1))
			if (+UserId<=0)
			{
				s rtn="-2^用户工号不合法"
			}
			else
			{
				//撤销执行医嘱
				//判断医嘱状态是否需要执行
				s ItemStatDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13) ; 医嘱状态
				s status=$p($g(^OEC("OSTAT",ItemStatDR)),"^",1)
				if (status="E") //E执行 V核实 D停止 U作废 C撤销 I未审核
				{
					d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Verify",$zd($h,3),$zt($p($h,",",2),1),ordID_"^"_UserId,ordID,"revokeEKGOrder")	
					s veriRtn=##class(appcom.OEOrdItem).Verify(ordID,UserId) //执行医嘱
					d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Verify",$zd($h,3),$zt($p($h,",",2),1),veriRtn,ordID,"revokeEKGOrder rtn")	
					s ^tmpDHCEKG("revokeEKGOrder",ordID,"Verify",$ZDT($H,3))=UserId_"==>"_veriRtn
					if (veriRtn'="0")
					{
						s rtn="-3^撤销执行医嘱失败,"_veriRtn
					}
				}
				
				s ExamNo="EKG||"_ordID	;检查号：EKG||医嘱ID
	
				s flag=..#ChangeStatus ;调用ris或ens接口改变检查状态
				if (flag="ris")
				{
					s userInfo=userLoginName_"^Y^Y^"
					s unregRtn=##class(RISService.TrakRISService).UnRegister(ExamNo,ordID,userInfo)	
					s ^tmpDHCEKG("revokeEKGOrder",ordID,"UnRegister",$ZDT($H,3))=ExamNo_","_ordID_","_userInfo_"===>"_unregRtn	
					if (unregRtn'=0)
					{
						s rtn=rtn_"-4^改变检查状态失败,"_unregRtn
					}
					else
					{
						s rtn="0"
					}
				}
				else
				{
					//调平台接口更新his检查状态
					s inputObj=##class(web.DHCEkg.SystemStatus.Dict.UpdateRequest).%New()
					s inputObj.ExamID=ExamNo
					s inputObj.OEOrdItemID=ordID
					s inputObj.Position=""
					s inputObj.SourceSystem="EKG"
					s inputObj.Status=sqdStatus
					s inputObj.UpDateTime=$zdt($h,3)
					s inputObj.UserID=userLoginName ;工号
					s inputObj.UserName=..GetUserNameByCode(userLoginName) ;姓名
		
					s json=##class(ext.util.JsonObject).ObjToJson(inputObj,"","") ;web.DHCEkg.SystemStatus.Dict.UpdateRequest
					s json="["_json_"]"
					s jsonStream=##class(%GlobalCharacterStream).%New()
					d jsonStream.Write(json)
					b ; w json
					s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
					b ; w rtnUpdateSystem
					
					s rtnUpdateStr=""
					i ($IsObject(rtnUpdateSystem))
					{
						
						s rtnUpdateStr=rtnUpdateSystem.Read()
					}
					else
					{
						s rtnUpdateStr=rtnUpdateSystem
					}
					
					
					w rtnUpdateStr,!
					b ; rtnUpdateStr
					s ^tmpDHCEKG("UpdateSystemStatus",ordID,$zdt($h,3),sqdStatus)=json_"==>"_rtnUpdateStr
				
					if (+rtnUpdateStr<0)
					{
						s rtn=rtn_"-4^改变检查状态失败"_rtnUpdateStr 
					}
					else
					{
						s rtn="0"
					}
				
				}
			}
		}
		
		
		
		 
	}catch(err)
	{
		s errStr="Exception in Location:"_err.Location_" Data:"_err.Data_"InnerException:"_err.InnerException
		d ##class(web.DHCEkg.Base).Log("Error","web.DHCEkgService","revokeEKGOrder4BS",
			$zd($h,3),$zt($p($h,",",2),1),errStr)
		s rtn="-1^"_errStr
	}
	q rtn
}

/// 方法说明：	撤销登记医嘱
/// 创建者：	杨亚莉
/// 创建时间：	2018-7-24
/// 入参：		ordID^userLoginName
/// 			医嘱ID^用户工号
/// 返回值：	存储数据结果^撤销执行医嘱结果^撤销登记申请单结果
/// w ##class(web.DHCEkgService).revokeEKGOrder("592||79^admin")
ClassMethod revokeEKGOrder(params As %String) As %String [ WebMethod ]
{
	b ;21
	s $ZT="ERRORRevokeOrd"
	s rtnRevoke=""
	s ordID=$p(params,"^",1)
	s userLoginName=$p(params,"^",2)
	q:(ordID="") "医嘱ID不能为空"
	q:(userLoginName="") "用户工号不能为空"
	s saveRtn=""
	d SaveRevokeInfo
	s ^tmpDHCEKG("revokeEKGOrder",ordID,"SaveRevokeInfo",$ZDT($H,3))=userLoginName_"==>"_saveRtn
	q:(saveRtn'["ok") saveRtn
	
	set UserId=..GetUserRowId($p(userLoginName,"@",1))
	d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Verify",$zd($h,3),$zt($p($h,",",2),1),ordID_"^"_UserId,ordID,"revokeEKGOrder")	
	s veriRtn=##class(appcom.OEOrdItem).Verify(ordID,UserId) //执行医嘱
	d ##class(web.DHCEkg.Base).Log("Log","appcom.OEOrdItem","Verify",$zd($h,3),$zt($p($h,",",2),1),veriRtn,ordID,"revokeEKGOrder rtn")	
	s ^tmpDHCEKG("revokeEKGOrder",ordID,"Verify",$ZDT($H,3))=UserId_"==>"_veriRtn
	;s rtn=rtn_"^"_veriRtn
	;q:(veriRtn'="0") "撤销执行失败"
	;考虑传图不执行医嘱的取消登记情况
	i (veriRtn'="0") s rtnRevoke="撤销执行失败"
	s ExamNo="EKG||"_ordID	;检查号：EKG||医嘱ID
	
	s flag=..#ChangeStatus ;调用ris或ens接口改变检查状态
	if (flag="ris")
	{
		s userInfo=userLoginName_"^Y^Y^"
		s unregRtn=##class(RISService.TrakRISService).UnRegister(ExamNo,ordID,userInfo)	
		s ^tmpDHCEKG("revokeEKGOrder",ordID,"UnRegister",$ZDT($H,3))=ExamNo_","_ordID_","_userInfo_"===>"_unregRtn	
	}
	else
	{
		//先从平台接口获取当前检查状态
		s orgStatus=..GetSystemStatus(ordID)
		i (orgStatus="CM") ;检查完成
		{
			s ExamStatus="CA" ;先取消检查
			s inputObj=##class(web.DHCEkg.SystemStatus.Dict.UpdateRequest).%New()
			s inputObj.ExamID=ExamNo
			s inputObj.OEOrdItemID=ordID
			s inputObj.Position=""
			s inputObj.SourceSystem="EKG"
			s inputObj.Status=ExamStatus
			s inputObj.UpDateTime=$zdt($h,3)
			s inputObj.UserID=userLoginName ;工号
			s inputObj.UserName=..GetUserNameByCode(userLoginName) ;姓名
			s OrderRowid=$p(ordID,"||",1)
			s itemsub=$p(ordID,"||",2)
			s recLoc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6) //检查科室rowid
			s CtLocCode=$P(^CTLOC(recLoc),"^",1)
			s CtLocDesc=$P(^CTLOC(recLoc),"^",2)
			s inputObj.OperateDeptCode=CtLocCode 
			s inputObj.OperateDept=CtLocDesc 
			
			s json=##class(ext.util.JsonObject).ObjToJson(inputObj,"","") ;web.DHCEkg.SystemStatus.Dict.UpdateRequest
			s json="["_json_"]"
			s jsonStream=##class(%GlobalCharacterStream).%New()
			d jsonStream.Write(json)
			b ; w json
			s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
			s ^tmpDHCEKG("UpdateSystemStatus",ordID,$zdt($h,3),ExamStatus)=json_"==>"_rtnUpdateSystem.Read()
		
		}
		//取消登记
		s ExamStatus="CSC"	;取消登记
		//调平台接口更新his检查状态
		s inputObj=##class(web.DHCEkg.SystemStatus.Dict.UpdateRequest).%New()
		s inputObj.ExamID=ExamNo
		s inputObj.OEOrdItemID=ordID
		s inputObj.Position=""
		s inputObj.SourceSystem="EKG"
		s inputObj.Status=ExamStatus
		s inputObj.UpDateTime=$zdt($h,3)
		s inputObj.UserID=userLoginName ;工号
		s inputObj.UserName=..GetUserNameByCode(userLoginName) ;姓名
		s OrderRowid=$p(ordID,"||",1)
		s itemsub=$p(ordID,"||",2)
		s recLoc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6) //检查科室rowid
		s CtLocCode=$P(^CTLOC(recLoc),"^",1)
		s CtLocDesc=$P(^CTLOC(recLoc),"^",2)
		s inputObj.OperateDeptCode=CtLocCode 
		s inputObj.OperateDept=CtLocDesc 
		
		s json=##class(ext.util.JsonObject).ObjToJson(inputObj,"","") ;web.DHCEkg.SystemStatus.Dict.UpdateRequest
		s json="["_json_"]"
		s jsonStream=##class(%GlobalCharacterStream).%New()
		d jsonStream.Write(json)
		b ; w json
		s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
		s ^tmpDHCEKG("UpdateSystemStatus",ordID,$zdt($h,3),ExamStatus)=json_"==>"_rtnUpdateSystem.Read()
		
		
		//预约接口，调用平台总线服务再次发送检查闭环
		try
		{
			s OrderRowid=$p(ordID,"||",1)
			s itemsub=$p(ordID,"||",2)
			q:((OrderRowid="")!(itemsub=""))
			q:($g(^OEORD(OrderRowid,"I",itemsub,1))="") ; 判断是否为his医嘱
			s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
			s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
			s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
			s StatusParameter=##class(web.DHCEkg.Dict.StatusParameter).%New()
			s StatusParameter.PATPatientID=RegNo
			s StatusParameter.PAADMVisitNumber=paadmdr
			s StatusParameter.OEORIOrderItemID=ordID
			s StatusParameter.OEORIOrdExecID=""
			s StatusParameter.SpecimenID=""
			s StatusParameter.RISRExamID=ExamNo
			s StatusParameter.RISRSystemType="EKG"
			s StatusParameter.Position=""
			s StatusParameter.OperAppID=""
			s StatusParameter.BloodAppID=""
			s StatusParameter.BloodBagNo=""
			s StatusParameter.ConsultAppID=""
			s StatusParameter.StatusCode="CSC"
			s StatusParameter.Uncheck="Y"
			s StatusParameter.UpdateUserCode=userLoginName
			s StatusParameter.UpdateUserName=..GetUserNameByCode(userLoginName)
			s StatusParameter.UpdateDateTime=$zdt($h,3)
			
			s header=##class(web.DHCEkg.Dict.Header).%New()
			s header.SourceSystem="EKG"
			s header.MessageID=$system.Util.CreateGUID()				
			s body=##class(web.DHCEkg.Dict.Body).%New()
			s body.StatusParameter=StatusParameter
			s request=##class(web.DHCEkg.Dict.Request).%New()
			s request.Header=header
			s request.Body=body
			s Status=request.XMLExportToString(.inputXmlStr)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","revokeEKGOrder",
				$zd($h,3),$zt($p($h,",",2),1),inputXmlStr,ordID,"MES0079")
			s soapObj=##class(web.DHCEkg.Soap.RIMServiceSoap).%New()
			s ensRtn=soapObj.HIPMessageServer("MES0079",inputXmlStr)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","revokeEKGOrder",
				$zd($h,3),$zt($p($h,",",2),1),ensRtn,ordID,"MES0079 rtn")
		}
		catch
		{
			b ; error
			d ##class(web.DHCEkg.Base).Log("Error","web.DHCEkgService","revokeEKGOrder",
				$zd($h,3),$zt($p($h,",",2),1),$ze,ordID,"MES0079")
		}
	}
	;s rtn=""
	q rtnRevoke
	
SaveRevokeInfo
	new $namespace
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
	s saveRtn=##class(EKGService.EKGRegister).revokeEkgInfo(params)
	zn CurrSpace
 	
ERRORRevokeOrd
	Set ErrorMsg=$ZE
	zn "DHC-APP"
	i (ordID=$c(0))!(ordID=$c(-1)) s ordID=1
	s ^RevokeOrdError($zd($h,3),$zt($p($h,",",2)))=ErrorMsg	
	q ErrorMsg
}

/// 方法说明：	判断医嘱是否可以登记或者检查
/// 创建者：	杨亚莉
/// 创建时间：	2018-7-20
/// 修改说明：	改为调用计费接口判断是否可以操作
/// 修改者：	杨亚莉
/// 修改时间：	2019-2-21
/// 入参：		BillStatus,patType
/// 			计费状态,病人类型
/// 返回值：	0:可以登记; 1:不可登记
/// w ##class(web.DHCEkgService).CanOperate("59||230","住院")
ClassMethod CanOperate(ordID As %String, patType As %String) As %String
{
	/*
	s rtn=0
	i (patType["住院") s rtn=0
	e  i (patType["门诊")!(patType["体检")!(patType["急诊") d
	.i BillStatus="P" s rtn=0
	.e  s rtn=1
	q rtn
	*/
	
	s rtn=0
	q:(ordID="") rtn
	s GetCheckArrears=""
	;s Getpatienttype=$p(PatInfo,"^",6)
    ;调用患者计费控制接口，判断是否可以执行医嘱 0:不控制; ^^^^C^^Y^^:允许执行; ^^^^C^^N^^:不允许执行;
    s ordStr=""
    s OrderRowid=$p(ordID,"||",1)
    s itemsub=$p(ordID,"||",2)
    s paadmdr=$p(^OEORD(OrderRowid),"^",1)
    q:(paadmdr="") rtn
    i (patType["住院") d ;住院病人
    .s OEOREExStDate=""
    .f  s OEOREExStDate=$o(^OEORDi(0,"OrdItem",OrderRowid,itemsub,OEOREExStDate)) q:(OEOREExStDate="")  d
    ..s OEOREChildsub=""
    ..f  s OEOREChildsub=$o(^OEORDi(0,"OrdItem",OrderRowid,itemsub,OEOREExStDate,OEOREChildsub)) q:(OEOREChildsub="")  d
    ...s OEOREPhQtyOrd=$p($g(^OEORD(OrderRowid,"I",itemsub,"X",OEOREChildsub)),"^",4)
    ...s exStr=OrderRowid_"||"_itemsub_"||"_OEOREChildsub_$c(2)_OEOREPhQtyOrd
    ...;b ; w exStr
    ...i (ordStr'="") s ordStr=ordStr_"^"_exStr
    ...e  s ordStr=exStr
    e  d
    .s ordStr=ordID_$c(2)_1
    ;b ; w ordStr
    s GetCheckArrears=##class(web.UDHCJFARREARSMANAGE).CheckArrears(paadmdr,ordStr,"RIS","")
    ;b ; w GetCheckArrears
    if ((GetCheckArrears'="0")&&(GetCheckArrears'="")) do
    .s GetCheckArrears=$p(GetCheckArrears,"^",7)  ;P7：是否允许执行医嘱 Y/N(允许/不允许)
    
    i (GetCheckArrears="N") s rtn=1
    q rtn
}

/// 方法说明：	审核医嘱时调用此方法，将信息入库，已经调用其他方法
/// 创建者：	xzy
/// 创建时间：	2018-8-1
/// 入参：		examId^userId^clientId^toStatus^diagnose^character^NP^isSendEmergency^setHISOrderStatus^deptId^examCode^patSource^opLoginName^abLoginName^deviceId
/// 			examinationId1^用户Id2^客户端Id3^toStatus4将要变为的状态^diagnose5诊断^character6特征^NP7阴性阳性^isSendEmergency8是否发送危急值^setHISOrderStatus9是否执行医嘱^参数deptId10^examCode11^patSource12^opLoginName13^abLoginName14^deviceId15
/// 返回值：	调用成功返回空，否则返回异常详情
/// w ##class(web.DHCEkgService).saveExamination("556^739^33^15^二尖瓣型P波^P波：    (-)"_$c(10)_"QRS波群：(-)"_$c(10)_"ST段：   (-)"_$c(10)_"T波：    (-)"_$c(10)_"^阴性^^^^6014||4^体检^admin^admin^^^1^Y")
ClassMethod saveExamination(params As %String) As %String
{
	set rtn=""
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","saveExamination",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	;set ^tmpDHCEKG("saveExamination",$H)=params
	
	//读取参数
	set sp = "^"
	set examId=$p(params,sp,1) //examinationId
	set userId=$p(params,sp,2) //用户Id
	set clientId=$p(params,sp,3) //客户端Id
	set toStatus=$p(params,sp,4) //将要变为的状态
	set diagnose=$p(params,sp,5) //诊断
	set setHISOrderStatus=$p(params,sp,9) //只执行医嘱，不做其他处理 ""=不发送 其他=发送
	set deptId=$p(params,sp,10) //是否发送危急值 ""=不发送 其他=发送
	set examCode=$p(params,sp,11) //医嘱号
	set patSource=$p(params,sp,12) //病人来源
	set opLoginName=$p(params,sp,13) //操作者工号
	set abLoginName=$p(params,sp,14) //审核者工号
	set IsEmergency=$p(params,sp,17) // 是否为危急值 NULL:正常; 0:正常; 1:预判危急; 2:发送危急值(未反馈处理结果); 3:发送危急值(已反馈处理结果，未确认); 4:发送危急值(已反馈处理结果，已确认)
	
	//参数的处理
	quit:(+examId<1) "exam id<=0,不合理"
	quit:(+userId<1) "user id<=0,不合理"
	;quit:(+clientId<1) "client id<=0,不合理"
	quit:(toStatus="") "将要变为的状态为空,不合理"
	
	
	//setHISOrderStatus'="" 则只做执行医嘱的操作 不做其他操作
	if ((setHISOrderStatus'="")&&((toStatus="15")||(toStatus="17"))) do
	.quit:(examCode="") //医嘱号为空.//医嘱处理
	.set ChangeStatus="N"
	.set orgStatus=..GetSystemStatus(examCode)
	.if ((orgStatus'="CM")&&(orgStatus'="RP")) do
	..set ChangeStatus="Y"
	.set rtn=..EKGExam4His(examCode,abLoginName,deptId_"^"_ChangeStatus) ;检查结束(执行医嘱，发送检查结束的检查状态)
	.if (IsEmergency="2") d ..SentEmergencyStatus(examCode,abLoginName)   ////给平台发送危急值状态
	.set rtn=..EKGArbiter4His(examCode,abLoginName) ;审核(发送报告的检查状态，向平台发送报告信息)
	.//调用体检
	.set rtn=##class(web.DHCEkgWebServiceNew).UpdataRptInfo(examCode,patSource_sp_opLoginName_sp_""_sp_abLoginName,diagnose,"")
	
	quit:((setHISOrderStatus'="")&&((toStatus="15")||(toStatus="17"))) rtn 	// 则只做执行医嘱的操作 不做其他操作
	
	
	//切换到ekg的命名空间进行处理
	new $namespace
	set CurrSpace=$ZNSPACE
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	
	set rtn=##class(EKGService.SaveExamination).save(params)
	b ; w rtn
	zn CurrSpace
	
	
	//new $namespace
	//set CurrSpace=$ZNSPACE
	//do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	//do...code.
	//zn CurrSpace
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","saveExamination",
		$zd($h,3),$zt($p($h,",",2),1),rtn,examCode,"rtn")
	;s ^tmpDHCEKG("saveExamination",examCode,"rtn",$zdt($h,3))=rtn
	
	quit rtn
}

/// 方法说明：	打印的时候调用此方法，改变打印时间以及打印状态
/// 创建者：	xzy
/// 创建时间：	2018-8-3
/// 入参：		examId
/// 			examinationId1
/// 返回值：	调用成功返回空，否则返回异常详情
/// w ##class(web.DHCEkgService).saveExamination("777")
ClassMethod savePrint(params As %String) As %String
{
	//切换到ekg的命名空间进行处理
	new $namespace
	set CurrSpace=$ZNSPACE
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	
	set rtn=##class(EKGService.SaveExamination).savePrint(params)
	
	zn CurrSpace
	quit rtn
}

/// Creator：      yyl
/// CreatDate：    2018-10-23
/// Description：  验证登陆，华西医院升级使用
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录的值之间用^间隔
/// Others：
/// w ##class(web.DHCEkgService).UserLogon("601","1")
ClassMethod UserLogon(User As %String, password As %String) As %String
{
	s LoginInfo="^^^^^"
	  s User=$ZCONVERT(User,"U")
	  s userRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",User,"")) //获取到ss_user表中的rowid
	  q:userRowId="" "-111"   ;^SSUser中无此用户
	  s userInfo=^SSU("SSUSR",userRowId)
	  q:userInfo="" "-111"
	  
	  //"FJN8793^方建娜^U&dDF1,""7k7k^93^101^^Y^Y^^Y^^^20^359^U&dDF1,""7k7k^^^^Y^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^N^^^^^^^^1^63389^56369^^^^^^^^^^^^^2^N^N^^^^63124^^2^^^^^^^^^^^^^^^^^^
	  //密码验证
	  s pwd=$p(userInfo,"^",3)
	  s tmpPwd=password
	  s password = ##class(web.SSUser).Encrypt(tmpPwd) //加密之后的密码
	  q:pwd'=password "-222"  ;密码错误
	  b ; 111
	  
	  s LoginInfo=userRowId_"^"_$p(userInfo,"^",1)_"^"_$p(userInfo,"^",2)_"^"_$p(userInfo,"^",4)_"^"_$p(userInfo,"^",2)
	  q LoginInfo
}

/// Creator：      yyl
/// CreatDate：    2018-11-7
/// Description：  调用平台接口获取医嘱检查状态
/// Creator：      yyl
/// CreatDate：    2019-12-11
/// Description：  修复从ris获取医嘱检查状态的问题
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录的值之间用^间隔
/// Others：
/// w ##class(web.DHCEkgService).GetSystemStatus("8383||4")
ClassMethod GetSystemStatus(ordID As %String) As %String
{
	new $namespace
	set CurrSpace=$ZNSPACE
	
	s rtnStatus=""
	s flag=..#ChangeStatus ;调用ris或ens接口改变检查状态
	if (flag="ris")
	{
		;b ; w flag
		s StudyNo="EKG||"_ordID
		s ReportRowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,0))
		s examStatus="A"   ;默认状态为申请
		s ReportDR="" ;默认状态为未写报告
		
		s reginfoRowid=$o(^DHCPACRegInfoi("OEORI",ordID,""))
		i (reginfoRowid'="") d
		.s examStatus="SC"  ;登记
		
		.i (ReportRowid'="") d
		..s examStatus="RP"  ;已写报告
		..s StatusDR=$p(^DHCRBStudy("Report",ReportRowid),"^",4)
		..s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
		..i (StatusCode="S") d  ;发布后 检查完成
		...s examStatus="CM"
		..s ReportInfo=^DHCRBStudy("Report",ReportRowid)
		..i (ReportInfo'="") d
		...s ReportDR=$p(ReportInfo,"^",4)
		...;q:(ReportDR="")
	
		s StatusDesc=""
		&sql(SELECT RESST_Desc INTO :StatusDesc FROM OEC_ResultStatus WHERE RESST_Code=:examStatus)
		if (StatusDesc="Awaiting")  s StatusDesc="申请"
		s rtnStatus=StatusDesc
		;b ; w rtnStatus
		i (ReportDR'="") d
		.s ReportStatusDesc=^DHCRBCStatus("ReportStatus",ReportDR)
		.i (ReportStatusDesc'="") d
		..s RptState=$p(ReportStatusDesc,"^",2)
		..s rtnStatus=RptState
		;b ; w rtnStatus
		
	}
	else
	{
		//调平台接口获取医嘱检查状态		
		;s inputObj=##class(web.DHCEkg.SystemStatus.Dict.QueryRequest).%New()
		;s inputObj.ExamID="EKG||"_ordID
		;s inputObj.OEOrdItemID=ordID
		
		;s json=##class(ext.util.JsonObject).ObjToJson(inputObj,"","") ;web.DHCEkg.SystemStatus.Dict.UpdateRequest
		;s json="["_json_"]"
		s jsonStream=##class(%GlobalCharacterStream).%New()
		d jsonStream.Write("[{""ExamID"":"""",""OEOrdItemID"":"""_ordID_"""}]")
		;b ; d jsonStream.OutputToDevice()
		s rtnStream=##class(web.DHCENS.EnsHISService).DHCHisInterface("QuerySystemStatus",jsonStream) 
		b ; w rtnStream
		try
		{
			s tmpJSONs={}.%FromJSON(rtnStream)
			s ErroString=""
			s tmpJSON=tmpJSONs.%Get(0)
			s rtnStatus=tmpJSON.%Get("Status")
		}
		catch
		{
		}
		;s strJson = rtnStream.Read()
		;s ^tmpDHCEKG("QuerySystemStatus",ordID,$zdt($h,3))=strJson		
		;s objResponse=..ObjectFromJSON(strJson,"web.DHCEkg.SystemStatus.Dict.QueryResponse")
		;s rtnStatus= objResponse.Status

	
	}
	q rtnStatus
}

/// @param : %String jsonstr  指向字段传入Id就成 	{ID:2,PAADMPAPMIDR:1,...}
/// @param : %String className
/// 把jsonstr转成className类的对象
ClassMethod ObjectFromJSON(jsonstr As %String, className As %String) As %ObjectHandle
{
	if jsonstr="{}" Quit ""
	s jsonstrlen=$length(jsonstr)
	s tempstr=$EXTRACT(jsonstr,2,jsonstrlen-1)
	s obj = ##class(ext.util.JsonObject).%New()
	s len=$length(tempstr,",")
	for i=1:1:len {
		s tempstr1=$P(tempstr,",",i)
		s name=$P(tempstr1,":",1)
		s value=$P(tempstr1,":",2)
		if name["""" s name=$P(name,"""",2)
		if value["""" s value=$P(value,"""",2)
		d obj.Put(name,value)
	}
	Q obj.Bean(className)
}

/// Creator：      zyw
/// CreatDate：    2019-12-10
/// Description：  获取HIS处理危急值信息并保存
/// Table：        
/// Input：        检查号^处理人工号（人事ID）^处理人姓名^联系电话^意见措施^联系人姓名^联系结果
/// Output：       
/// Return：      
/// Others：
/// w ##class(web.DHCEkgService).updateEmrRecord("EKG||356||22^1^TEST^13000000000^意见措施aa^张三^已通知")
ClassMethod updateEmrRecord(EmrInfo As %String) As %String
{
	new $namespace
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","updateEmrRecord",$zd($h,3),$zt($p($h,",",2),1),EmrInfo,"params")
	s rtnUpdate=""
	s CurrentSpace=$znspace
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s rtnUpdate=##class(EKGService.Report.Emergency).updateEmrRecord(EmrInfo)
	zn CurrentSpace
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","updateEmrRecord",$zd($h,3),$zt($p($h,",",2),1),rtnUpdate,"rtn")
	q rtnUpdate
}

/// Creator：      yangyali
/// CreatDate：    2020-2-10
/// Modify: 	   
/// ModifyDate：   
/// Description:   设置检查号前，获取检查号前缀
/// Table：       
/// Input：        医嘱号
/// Output：       检查号前缀
/// w ##class(web.DHCEkgService).GetStudyTag("59||234")
ClassMethod GetStudyTag(OrdId As %String) As %String
{
	s StudyTag="EKG||"
	try
	{
		s (arcimid,examItmCode,reqId,reqInfo,examItmId,examItmInfo,catCode,catId,catInfo,catName)=""
		//先在app下查找该医嘱的医嘱项code
		s OrderRowid=$p(OrdId,"||",1)
		s itemsub=$p(OrdId,"||",2)
	    s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	    i (arcimid'="")
	    {
	    	s examItmCode=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",1)
	    }
	    b ;w examItmCode
		new $namespace
		s CurrSpace=$ZNSPACE
		d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
		i (examItmCode="")
		{
			s reqId=$o(^dbo.tblRequestI("indexBarcode"," "_OrdId,""))
			i (reqId'="") 
			{
				s reqInfo=$g(^dbo.tblRequestD(reqId))
				i (reqInfo'="") s examItmCode=$listget(reqInfo,11)
			}
		}
	    b ;w examItmCode
		i (examItmCode'="")
		{
			//查询该项医嘱在心电库中的检查类型
			s examItmCode=$ZCVT(examItmCode,"u")
			s examItmId=$o(^dbo.tblDictExamItemI("idxExamItemCode"," "_examItmCode,""))
			i (examItmId'="") 
			{
				s examItmInfo=$g(^dbo.tblDictExamItemD(examItmId))
				i (examItmInfo'="") 
				{
					s catCode=$listget(examItmInfo,2)
					i (catCode'="")
					{
						s catId=$o(^dbo.tblDictCategoryI("idxCategoryCode"," "_catCode,""))
						i (catId'="")
						{
							s catInfo=$g(^dbo.tblDictCategoryD(catId))
							s catName=$listget(catInfo,4)
	    					b ;w catName						
							i (catName["肌电") s StudyTag="EMG||"  ;检查类型为肌电
						}
					}
				}
			}
		}
	}
	catch{}
	q StudyTag
}

/// Creator：      yangyali
/// CreatDate：    2020-2-10
/// Modify: 	   
/// ModifyDate：   
/// Description:   获取检查号
/// Table：       
/// Input：        医嘱号
/// Output：       检查号前缀
/// w ##class(web.DHCEkgService).GetStudyNo("179||129")
ClassMethod GetStudyNo(OrdId As %String) As %String
{

	s rtnStudyNo=""
	s flag=..#ChangeStatus ;调用ris或ens接口
		new $namespace
		s CurrSpace=$ZNSPACE
		d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
		
		s (SreqId,SexamId)=""
		
		s SreqId=$o(^dbo.tblRequestI("indexBarcode"," "_OrdId,SreqId))
		while (SreqId'="") 
		{
			s SexamId=""
			s SexamId=$o(^dbo.tblExaminationI("idxRequestID",SreqId,SexamId))
			while (SexamId'="")
			{
				s examInfo=$g(^dbo.tblExaminationD(SexamId))
				i (examInfo'="")
				{
					s statuscode=$listget(examInfo,20,"")
					i (statuscode="11")!(statuscode="12")!(statuscode="13")!(statuscode="14")!(statuscode="15")!(statuscode="16")!(statuscode="17") ;已做检查
					{
						;b ;000
						zn CurrSpace
						i (flag="ris")
						{
							//从ris获取检查号
							s RegDR=$o(^DHCPACRegInfoi("OEORI",OrdId,""))
							i $g(RegDR)'="" d
							.s rtnStudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)						
						}
						b ; w rtnStudyNo
						i (rtnStudyNo="")
						{
							s tag=..GetStudyTag(OrdId)
							s rtnStudyNo=tag_OrdId ;与平台接口、PACS接口的检查号保持一致
						}
						d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
					}
				}
				s SexamId=$o(^dbo.tblExaminationI("idxRequestID",SreqId,SexamId))
			}
			s SreqId=$o(^dbo.tblRequestI("indexBarcode"," "_OrdId,SreqId))
		}
		zn CurrSpace
	q rtnStudyNo
}

/// w ##class(web.DHCEkgService).GetHisUserType(1)
ClassMethod GetHisUserType(userID As %String) As %String
{
	q:($d(userID)=0)||(userID="") ""
	//获取医护人员表Rowid:ct_careprov
	s CareprovDr=""
	s CareprovDr=$p($g(^SSU("SSUSR",userID)),"^",14)
	q:($d(CareprovDr)=0)!(CareprovDr="") ""
	
	//获取职务表Rowid
	s CtpcpCarprvtpDr=""
	s CtpcpCarprvtpDr=$p($g(^CTPCP(CareprovDr,1)),"^",4)
	q:($d(CtpcpCarprvtpDr)=0)||(CtpcpCarprvtpDr="") ""
	//获取医护人员类型
	s DocPower=""
	s DocPower=$P($g(^CT("CPT",CtpcpCarprvtpDr)),"^",2)
	q DocPower
}

/// Creator：      zyw
/// CreatDate：    2020-04-20
/// Description：  更新床号信息
/// Table：        
/// Input：        医嘱ROWID
/// Output：       
/// Return：      
/// Others：
/// w ##class(web.DHCEkgService).updateBedByRowId("1")
ClassMethod updateBedByRowId(rowId As %String) As %String
{
	 s bedname=""
	 s OrderRowid=$p(rowId,"||",1) //64
     q:(OrderRowid="")
	 s paadmdr=$p(^OEORD(OrderRowid),"^",1)
	 s beddr=$p(^PAADM(paadmdr),"^",73)
     i beddr'=""  d 
     .set wardrowid=$p(beddr,"||",1)
     .set bedchildsub=$p(beddr,"||",2)
     .;lpd 有的床位被删除了，找不到，pacs 查询会报错 20100709
     .i $D(^PAWARD(wardrowid,"BED",bedchildsub)) d
     ..s bedname=$p(^PAWARD(wardrowid,"BED",bedchildsub),"^",1)
	
	
	//切换到ekg的命名空间进行处理
	new $namespace
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	
    s ReqID=$o(^dbo.tblRequestI("idxExamCode",rowId,""))
    q:ReqID=""
    s ReqInfo=^dbo.tblRequestD(ReqID)
    q:ReqInfo=""
    s ekgbed=$list(ReqInfo,7)
    i (ekgbed'=bedname) d
    .s params=ReqID_"^"_bedname
    .d ##class(EKGService.UpdateBedCode).updateBedCode(params)
    
    zn CurrSpace
}

/// w ##class(web.DHCEkgService).test()
ClassMethod test() As %String
{
	q ""
}

/// 方法说明：	取消检查(开始检查后，检查未能完成的情况)
/// 创建者：	杨亚莉
/// 创建时间：	2020-9-18
/// 入参：		OrdId,UserId
/// 			医嘱号^用户ID
/// 返回值：	成功返回空，否则返回失败详情
/// w ##class(web.DHCEkgService).CancleExam("")
ClassMethod CancleExam(params As %String, Output rtnStr As %String) As %String
{
	new $namespace
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","CancleExam",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	;s OrdId=$p(params,"^",1)
	;s UserId=$p(params,"^",2)
	;s CurrentSpace=$znspace
	;d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	;s UserInfo=##class(EKGService.BLL.BllUser).GetUserInfo(UserId)
	;zn CurrentSpace
	;s UserCode=$listget(UserInfo,8)
	;s rtnStr=##class(web.DHCEkgService).EKGUnRegiseter4His(OrdId,UserCode)
	
	;d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","CancleExam",$zd($h,3),$zt($p($h,",",2),1),rtnStr,OrdId,"rtn")
	s rtnStr=""
	q $$$OK
}

/// 方法说明：	撤回检查，取消已完成的检查
/// 创建者：	杨亚莉
/// 创建时间：	2021-11-2
/// 入参：		流水号^用户ID
/// 返回值：	成功返回空，否则返回失败详情
/// w ##class(web.DHCEkgService).RevokeExam("")
ClassMethod RevokeExam(params As %String, Output rtnStr As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","RevokeExam",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	
	s ExamId=$p(params,"^",1)
	s UserId=$p(params,"^",2)
	s CurrentSpace=$znspace
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s RequestInfo=##class(EKGService.BLL.BllRequest).GetRequestInfoByExamId(ExamId)
	s UserInfo=##class(EKGService.BLL.BllUser).GetUserInfo(UserId)
	zn CurrentSpace
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","RevokeExam",$zd($h,3),$zt($p($h,",",2),1),RequestInfo,"RequestInfo")
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","RevokeExam",$zd($h,3),$zt($p($h,",",2),1),UserInfo,"UserInfo")
	s OrdId=$listget(RequestInfo,6)
	s UserCode=$listget(UserInfo,8)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","RevokeExam",$zd($h,3),$zt($p($h,",",2),1),UserCode,OrdId)
	s rtnStr=##class(web.DHCEkgService).EKGUnRegiseter4His(OrdId,UserCode)
	
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","RevokeExam",$zd($h,3),$zt($p($h,",",2),1),rtnStr,OrdId,"rtn")
	s rtnStr= ""
	q $$$OK
}

/// 方法说明：	取消报告(取消审核)
/// 创建者：	杨亚莉
/// 创建时间：	2020-9-18
/// 入参：		ExamId,UserId
/// 			流水号^用户ID
/// 返回值：	成功返回空，否则返回失败详情
/// w ##class(web.DHCEkgService).CancleReport("")
ClassMethod CancleReport(params As %String, Output rtnStr As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","CancleReport",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s ExamId=$p(params,"^",1)
	s UserId=$p(params,"^",2)
	s CurrentSpace=$znspace
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s RequestInfo=##class(EKGService.BLL.BllRequest).GetRequestInfoByExamId(ExamId)
	s UserInfo=##class(EKGService.BLL.BllUser).GetUserInfo(UserId)
	zn CurrentSpace
	s OrdId=$listget(RequestInfo,6)
	s flag=..#ChangeStatus ;调用ris或ens接口改变检查状态
	if (flag="ens")
	{
		//调平台接口更新his检查状态，撤回报告
		s ExamStatus="CRP" ;取消报告
		s inputObj=##class(web.DHCEkg.SystemStatus.Dict.UpdateRequest).%New()
		s inputObj.ExamID="EKG||"_OrdId
		s inputObj.OEOrdItemID=OrdId
		s inputObj.Position=""
		s inputObj.SourceSystem="EKG"
		s inputObj.Status=ExamStatus
		s inputObj.UpDateTime=$zdt($h,3)
		s inputObj.UserID=$listget(UserInfo,8) ;工号
		s inputObj.UserName=$listget(UserInfo,11) ;姓名
	
		s json=##class(ext.util.JsonObject).ObjToJson(inputObj,"","") ;web.DHCEkg.SystemStatus.Dict.UpdateRequest
		s json="["_json_"]"
		s jsonStream=##class(%GlobalCharacterStream).%New()
		d jsonStream.Write(json)
		b ; w json
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","CancleReport",$zd($h,3),$zt($p($h,",",2),1),json,OrdId,"UpdateSystemStatus")
		s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","CancleReport",$zd($h,3),$zt($p($h,",",2),1),rtnUpdateSystem.Read(),OrdId,"UpdateSystemStatusRtn")
	
			//预约接口，调用平台总线服务再次发送检查闭环
			try
			{
				s OrderRowid=$p(OrdId,"||",1)
				s itemsub=$p(OrdId,"||",2)
				q:((OrderRowid="")!(itemsub=""))
				q:($g(^OEORD(OrderRowid,"I",itemsub,1))="") ; 判断是否为his医嘱
				s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
				s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
				s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
				s StatusParameter=##class(web.DHCEkg.Dict.StatusParameter).%New()
				s StatusParameter.PATPatientID=RegNo
				s StatusParameter.PAADMVisitNumber=paadmdr
				s StatusParameter.OEORIOrderItemID=OrdId
				s StatusParameter.OEORIOrdExecID=""
				s StatusParameter.SpecimenID=""
				s StatusParameter.RISRExamID="EKG||"_OrdId
				s StatusParameter.RISRSystemType="EKG"
				s StatusParameter.Position=""
				s StatusParameter.OperAppID=""
				s StatusParameter.BloodAppID=""
				s StatusParameter.BloodBagNo=""
				s StatusParameter.ConsultAppID=""
				s StatusParameter.StatusCode="CRP"
				s StatusParameter.UpdateUserCode=$listget(UserInfo,8)
				s StatusParameter.UpdateUserName=$listget(UserInfo,11)
				s StatusParameter.UpdateDateTime=$zdt($h,3)
				
				s header=##class(web.DHCEkg.Dict.Header).%New()
				s header.SourceSystem="EKG"
				s header.MessageID=$system.Util.CreateGUID()				
				s body=##class(web.DHCEkg.Dict.Body).%New()
				s body.StatusParameter=StatusParameter
				s request=##class(web.DHCEkg.Dict.Request).%New()
				s request.Header=header
				s request.Body=body
				s Status=request.XMLExportToString(.inputXmlStr)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","CancleReport",
				$zd($h,3),$zt($p($h,",",2),1),inputXmlStr,OrdId,"MES0079")
			s soapObj=##class(web.DHCEkg.Soap.RIMServiceSoap).%New()
			s ensRtn=soapObj.HIPMessageServer("MES0079",inputXmlStr)
			d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","CancleReport",
				$zd($h,3),$zt($p($h,",",2),1),ensRtn,OrdId,"MES0079 rtn")
			}
			catch
			{
			b ; error
				d ##class(web.DHCEkg.Base).Log("Error","web.DHCEkgService","CancleReport",
					$zd($h,3),$zt($p($h,",",2),1),$ze,OrdId,"MES0079")
			}
	}
	else
	{
		s rtnStr=##class(RISService.TrakRISService).CancelReport("EKG||"_OrdId)	
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","CancleReport",$zd($h,3),$zt($p($h,",",2),1),rtnStr,OrdId,"rtn")
	}
	s rtnStr=""
	q $$$OK
}

/// 方法说明：	获取病区列表
/// 创建者：	赵恒
/// 创建时间：	2020-11-20
/// 创建者：	杨亚莉
/// 创建时间：	2020-11-23
/// 入参：		
/// 返回值：	以$分隔的病区名称
/// w ##class(web.DHCEkgService).GetCTZoneList()
ClassMethod GetCTZoneList() As %String
{
	s return=""
	s CTLOCRowID=""
	s CTLOCRowID=$o(^CTLOC(0,"LocType","W",CTLOCRowID)) 
	while (CTLOCRowID'="")
	{
		s ctInfo=^CTLOC(CTLOCRowID)
		i (ctInfo'="")
		{
			s ctDesc=$p(ctInfo,"^",2)
			i (ctDesc["-") s ctDesc=$p(ctDesc,"-",2)
			i (return'="")
			{
				s return=return_"$"_ctDesc
			}
			else
			{
				s return=ctDesc
			}
		}
		s CTLOCRowID=$o(^CTLOC(0,"LocType","W",CTLOCRowID)) 
	}
	q return
	
	/*
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetMedTrakNameSpace()
	s ctlocCount=$g(^CTLOC(0))
	s return=""
	s trueCount=0
	For index=1:1:ctlocCount
	{
		s currentLoc=$g(^CTLOC(index))
		if (currentLoc'="")
		{
			s in=$p(currentLoc,"^",5)
			if (in = "Y"){
				;b ; w index
				s desc=$p(currentLoc,"^",2)
				i (desc["-") s desc=$p(desc,"-",2)
				if (return'="")
				{
					s return=return_"$"
				}
				s return=return_desc
				s trueCount=trueCount+1
			}
			
		}
	}
	zw trueCount
	//if (trueCount>0) s return=return_"$"_trueCount
	zn CurrSpace
	q return
	*/
}

/// 根据医嘱号获取医嘱大类
ClassMethod getBigClass(ordID As %String) As %String
{
	s oeordchild=$p(ordID,"||",2)
    s oeordid=$p(ordID,"||",1)
    s arcitmid=$p(^OEORD(oeordid,"I",oeordchild,1),"^",2)
    s arcid=$p(arcitmid,"||",1)
    s arcvsion=$p(arcitmid,"||",2)
    s arcitmcat=$p(^ARCIM(arcid,arcvsion,1),"^",10)
    s catgory=$p(^ARC("IC",arcitmcat),"^",8)
    q catgory
}

/// Creator：      zyw
/// CreatDate：    2019-12-10
/// Description：  获取HIS处理危急值信息并保存
/// Table：        
/// Input：        检查号^处理人工号（人事ID）^处理人姓名^联系电话^意见措施^联系人姓名^联系结果
/// Output：       
/// Return：      
/// Others：
/// w ##class(web.DHCEkgService).updateEmrRecord("EKG||356||22^1^TEST^13000000000^意见措施aa^张三^已通知")
ClassMethod ReplyEmrRecord(EmrInfo As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","updateEmrRecord",$zd($h,3),$zt($p($h,",",2),1),EmrInfo,"params")
	s rtnUpdate=""
	s rtnUpdate=##class(EKGService.Report.Emergency).updateEmrRecord(EmrInfo)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","updateEmrRecord",$zd($h,3),$zt($p($h,",",2),1),rtnUpdate,"rtn")
	q rtnUpdate
}

/// 方法说明：	根据医嘱号获取RIS申请单号
/// 创建者：	杨亚莉
/// 创建时间：	2021-11-29
/// 入参：		医嘱号
/// 返回值：	RIS申请单号
/// w ##class(web.DHCEkgService).GetRisAppId("")
ClassMethod GetRisAppId(params As %String, Output rtnStr As %String) As %String
{
	s rtnStr=""
	s obj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCENS.STBLL.RIS.METHOD.GetRisAppInfo||GetARRowID",0)
	i ($IsObject(obj))
	{
		s rtnStr= ##class(web.DHCENS.STBLL.RIS.METHOD.GetRisAppInfo).GetARRowID(params)
	}
	q ""
}

///  w ##class(web.DHCEkgGetConOrd).GetStatusCode("2262429||21")
ClassMethod GetStatusCode(OEOrdItemID As %String) As %String
{
	q:(OEOrdItemID="") ""
	s GexamNo="EKG||"_OEOrdItemID
	s Gstatus=""
		s tmpESStatusID=""
		for
		{
			s tmpESStatusID=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDExamID"," "_OEOrdItemID," "_GexamNo,tmpESStatusID),-1)
			q:tmpESStatusID=""
			
			s tmpESStatusStr=$g(^Busi.ENS.EnsStatusD(tmpESStatusID))
			s EffectiveFlag=$list(tmpESStatusStr,12)
			continue:EffectiveFlag="N"
			q:EffectiveFlag="Y"
		}
	i (tmpESStatusID'="")
	{	
		s tmpESStatusStr=$g(^Busi.ENS.EnsStatusD(tmpESStatusID))
		s Gstatus=$list(tmpESStatusStr,9)
	}
	q Gstatus
}

/// 方法说明：	调用平台接口发送检查状态
/// 创建者：	杨亚莉
/// 创建时间：	2022-9-29
/// 入参：		检查状态信息的json串
/// 返回值：	调用结果
/// w ##class(web.DHCEkgService).UpdateSystemStatus("")
ClassMethod UpdateSystemStatus(params As %String, Output rtnStr As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","UpdateSystemStatus",$zd($h,3),$zt($p($h,",",2),1),jsonStream.Read(jsonStream.Size),OrdId)
	s flag=..#ChangeStatus ;调用ris或ens接口改变检查状态
	if (flag="ens")
	{
		//调平台接口更新his检查状态，撤回报告
		s jsonStream=##class(%GlobalCharacterStream).%New()
		i ($IsObject(params))
		{
			s jsonStream=params
		}
		else
		{
			d jsonStream.Write(params)
		}
		d jsonStream.Rewind()
		s rtnStr=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)	
		i ($IsObject(rtnStr))
		{
			s rtnStr=rtnStr.Read(rtnStr.Size)
		}
	}
	else
	{
		try
		{
			s inputArray=##class(%DynamicAbstractObject).%FromJSON(params)
			i (inputArray'="")
			{
				s OrdId=inputArray.%Get(0).%Get("OEOrdItemID")
				s rtnStr=##class(RISService.TrakRISService).CancelReport("EKG||"_OrdId)	
			}
		}
		catch{}
	}
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","UpdateSystemStatus",$zd($h,3),$zt($p($h,",",2),1),rtnStr)
	
	q $$$OK
}

/// CreatDate： 20190514
/// Description： 获取人员科室
/// Table： 
/// Input：     
/// Output：
/// Return：  w ##CLASS(web.DHCEkgService).GetLocStaff()
ClassMethod GetLocStaff()
{
	
	Set ret=##class(%GlobalCharacterStream).%New()
	s RESID=0
	for {
		s RESID = $o(^RB("RES",RESID))
		q:RESID=""
		s LocID = $p(^RB("RES",RESID),"^",1)
		i '$d(^CTLOC(LocID)) continue
		s LocCode = $p(^CTLOC(LocID),"^",1)
		s LocName = $p(^CTLOC(LocID),"^",2)
		s CPID = $p(^RB("RES",RESID),"^",2)
		continue:'$l(CPID)
		i '$d(^CTPCP(CPID,1)) continue
		s CPCode = $P(^CTPCP(CPID,1),"^",1)
		s CPName = $P(^CTPCP(CPID,1),"^",2)
		s a=LocCode_"^"_LocName_"@"_CPCode_"^"_CPName
		d ret.WriteLine(LocCode_"^"_LocName_"@"_CPCode_"^"_CPName)
	}
	q ret
}

/// GetHisUserList
/// Creator：      yangyali
/// CreatDate：    2022-10-14
/// Description:： 获取his所有用户的信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       用户信息的json串，包含用户工号、姓名、医护人员类型、默认登录科室、可登录科室信息
/// Others：s stream= ##class(web.DHCEkgService).GetHisUserList()
ClassMethod GetHisUserList() As %GlobalCharacterStream
{
	new $namespace
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetHisUserList",$zd($h,3),$zt($p($h,",",2),1),"")	
	s userList=[]
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetMedTrakNameSpace()
	try
	{
		s Today=$P($H,",",1)
		;s countUser=0
		s index=0
		f
		{
			s index=$O(^SSU("SSUSR",index))
			q:index=""
			;s countUser=countUser+1
			;q:(countUser>3)
			s currentUser=$g(^SSU("SSUSR",index))
			if (currentUser'="")
			{
				s SSUSRDateTo=$P(currentUser,"^",97)
				s:SSUSRDateTo>=Today SSUSRDateTo=""
				;停止的不传
				i $G(SSUSRDateTo)=""
				{
					s UserCode=$P(currentUser,"^",1)
					i (UserCode'="")
					{
						s user={}
						//获取用户信息
						s DocPower=""
						s UserRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$ZCONVERT(UserCode,"U"),0))
						s UserDesc=$P(^SSU("SSUSR",UserRowId),"^",2)
						s user.RowId=UserRowId
						s user.LoginName=UserCode
						s user.UserName=UserDesc
						s user.Password=$P(currentUser,"^",3)
						;trak的用户和医护人员，没有性别
						s user.SexDesc=""
						s DefaultDeptRowId=$P(^SSU("SSUSR",UserRowId),"^",4)
						i (DefaultDeptRowId'="")
						{
							s DefaultDeptCode=$P(^CTLOC(DefaultDeptRowId),"^",1)
							s DefaultDeptDesc=$P(^CTLOC(DefaultDeptRowId),"^",2)
							i (DefaultDeptDesc["-")
							{
								s DefaultDeptSpell=$p(DefaultDeptDesc,"-",1)
								s DefaultDeptName=$p(DefaultDeptDesc,"-",2)
							}
							else
							{
								s DefaultDeptSpell=""
								s DefaultDeptName=DefaultDeptDesc
							}
							s user.DeptRowid=DefaultDeptRowId
							s user.DeptCode=DefaultDeptCode
							s user.DeptSpell=DefaultDeptSpell
							s user.DeptName=DefaultDeptName
						}

						;取其他登录科室
						s OtherDeptList=[]
						s OTHLLChildsub=0 
						f  
						{
							s OTHLLChildsub=$O(^SSU("SSUSR",UserRowId,"OTHLL",OTHLLChildsub))
							q:OTHLLChildsub=""
							s OtherDeptDr=$P(^SSU("SSUSR",UserRowId,"OTHLL",OTHLLChildsub),"^",1)
							i (OtherDeptDr'="")
							{
								s OtherDeptCode=$P(^CTLOC(OtherDeptDr),"^",1)
								s OtherDeptDesc=$P(^CTLOC(OtherDeptDr),"^",2)
								i (OtherDeptDesc["-")
								{
									s OtherDeptSpell=$p(OtherDeptDesc,"-",1)
									s OtherDeptName=$p(OtherDeptDesc,"-",2)
								}
								else
								{
									s OtherDeptSpell=""
									s OtherDeptName=OtherDeptDesc
								}
								s dept={}
								s dept.RowId=OtherDeptDr
								s dept.Code=OtherDeptCode
								s dept.Spell=OtherDeptSpell
								s dept.Name=OtherDeptName
								d OtherDeptList.%Push(dept)
							}
							;s OtherDeptCode=$P(^CTLOC(OtherDeptDr),"^",1)
							;i OtherDept'="" s OtherDept=OtherDept_"^"
							;s OtherDept=OtherDept_OtherDeptCode
						}
						s user.OtherDeptList=OtherDeptList
						s user.DocPower=..GetHisUserType(UserRowId)
						d userList.%Push(user)					
					}
				}
			}
		}
	}
	catch
	{
		b ; w $ze
		zn CurrSpace
		d ##class(web.DHCEkg.Base).Log("Error","web.DHCEkgService","GetHisUserList",$zd($h,3),$zt($p($h,",",2),1),$ze)	
	}
	zn CurrSpace
	s rtnStream=##class(%GlobalCharacterStream).%New()
	s rtnStr=userList.%ToJSON(.rtnStream)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetHisUserList",$zd($h,3),$zt($p($h,",",2),1),rtnStream.Read(rtnStream.Size))
	d rtnStream.Rewind()
	q rtnStream
}

/// 方法说明：	根据就诊号获取生理周期
/// 创建者：	杨亚莉
/// 创建时间：	2022-10-25
/// 入参：		生理周期信息
/// 返回值：	调用结果
/// w ##class(web.DHCEkgService).GetPhysiologicalCycle("")
ClassMethod GetPhysiologicalCycle(params As %String, Output rtnStr As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetPhysiologicalCycle",$zd($h,3),$zt($p($h,",",2),1),params)	
	i (params'="") s rtnStr=##class(DHCDoc.Interface.Inside.Service).GetPhysiologicalCycle(params)
	e  s rtnStr=""
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetPhysiologicalCycle",$zd($h,3),$zt($p($h,",",2),1),rtnStr)
	
	q $$$OK
}

/// 方法说明：	根据就诊号获取临床诊断
/// 创建者：	杨亚莉
/// 创建时间：	2022-10-25
/// 入参：		临床诊断
/// 返回值：	调用结果
/// w ##class(web.DHCEkgService).GetClinicDiag("")
ClassMethod GetClinicDiag(params As %String, Output rtnStr As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetClinicDiag",$zd($h,3),$zt($p($h,",",2),1),params)	
	
	s diagInfo=""
	i (params'="")
	{
		s mradmid=$p($g(^PAADM(params)),"^",61)
		i (mradmid'="")
		{
			s rs=##class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")
			d rs.Execute(mradmid, "", "")
			while(rs.Next())
			{
				s code=$g(rs.Data("DiagnosICDCode"))
				s desc=$g(rs.Data("DiagnosDesc"))
				i code'=""
				{
					i diagInfo'="" s diagInfo=diagInfo_code_":"_desc_";"
					else  s diagInfo=code_":"_desc_";"
				}
			}
		}
	}
	s rtnStr=diagInfo
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetClinicDiag",$zd($h,3),$zt($p($h,",",2),1),rtnStr)
	
	q $$$OK
}

/// 方法说明：	获取his科室信息
/// 创建者：	杨亚莉
/// 创建时间：	2022-11-29
/// 入参：		
/// 返回值：	科室信息集合
/// w ##class(web.DHCEkgService).GetHisDeptListold()
ClassMethod GetHisDeptListold()
{
	Set ret=##class(%GlobalCharacterStream).%New()
	s LocID=0
	for {
		s LocID = $o(^CTLOC(LocID))
		q:LocID=""
		s LocCode = $p(^CTLOC(LocID),"^",1)
		s LocName = $p(^CTLOC(LocID),"^",2)
		s InputCode = $p(^CTLOC(LocID),"^",43)
		s WardFlag = $p(^CTLOC(LocID),"^",5)
		s HISHospitalDR = $p(^CTLOC(LocID),"^",22)
		continue:'$l(HISHospitalDR)
		s HospitalCode=""
		i $l(HISHospitalDR) s HospitalCode= $p(^CT("HOSP",HISHospitalDR),"^",1)
		s TelePhone = $p(^CTLOC(LocID),"^",40)
		s Address = $g(^CTLOC(LocID,"ADDR",1))
		s ParentCode=""
		i $d(^CTLOC(LocID,"LINK",1)) d
		.s ParentLocID = ^CTLOC(LocID,"LINK",1)
		.s ParentCode = $p(^CTLOC(ParentLocID),"^",1)
		
		d ret.WriteLine(LocID_"^^"_LocCode_"^^"_LocName_"^^"_InputCode_"^^"_WardFlag_"^^"_HospitalCode_"^^"_Address_"^^"_TelePhone_"^^"_ParentCode)
		s str=LocID_"^^"_LocCode_"^^"_LocName_"^^"_InputCode_"^^"_WardFlag_"^^"_HospitalCode_"^^"_Address_"^^"_TelePhone_"^^"_ParentCode
	}
	w str,!
	q ret
}

/// GetHisDeptList
/// Creator：      yangyali
/// CreatDate：    2022-11-29
/// Description:： 获取his所有科室的信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       科室信息的json串
/// Others：s stream= ##class(web.DHCEkgService).GetHisDeptList()
ClassMethod GetHisDeptList() As %GlobalCharacterStream
{
	new $namespace
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetHisDeptList",$zd($h,3),$zt($p($h,",",2),1),"")	
	s deptList=[]
	
	s LocID=0
	for {
		s LocID = $o(^CTLOC(LocID))
		q:LocID=""
		s LocCode = $p(^CTLOC(LocID),"^",1)
		s LocName = $p(^CTLOC(LocID),"^",2)
		s InputCode = $p(^CTLOC(LocID),"^",43)
		s WardFlag = $p(^CTLOC(LocID),"^",5)
		s HISHospitalDR = $p(^CTLOC(LocID),"^",22)
		continue:'$l(HISHospitalDR)
		s HospitalCode=""
		i $l(HISHospitalDR) s HospitalCode= $p(^CT("HOSP",HISHospitalDR),"^",1)
		s TelePhone = $p(^CTLOC(LocID),"^",40)
		s Address = $g(^CTLOC(LocID,"ADDR",1))
		s ParentCode=""
		i $d(^CTLOC(LocID,"LINK",1)) d
		.s ParentLocID = ^CTLOC(LocID,"LINK",1)
		.s ParentCode = $p(^CTLOC(ParentLocID),"^",1)
		i (LocName["-")
		{
			s LocSpell=$p(LocName,"-",1)
			s LocName=$p(LocName,"-",2)
		}
		else
		{
			s LocSpell=""
			s LocName=LocName
		}
		s dept={}
		s dept.RowId=LocID
		s dept.Code=LocCode
		s dept.Spell=LocSpell
		s dept.Name=LocName
		s dept.WardFlag=WardFlag
		d deptList.%Push(dept)
		//d ret.WriteLine(LocID_"^^"_LocCode_"^^"_LocName_"^^"_InputCode_"^^"_WardFlag_"^^"_HospitalCode_"^^"_Address_"^^"_TelePhone_"^^"_ParentCode)
	}
	s rtnStream=##class(%GlobalCharacterStream).%New()
	s rtnStr=deptList.%ToJSON(.rtnStream)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetHisDeptList",$zd($h,3),$zt($p($h,",",2),1),rtnStream.Read(rtnStream.Size))
	d rtnStream.Rewind()
	q rtnStream
}

/// Creator：    	yangyali
/// CreatDate： 	2022-12-14
/// ModifyDate：   
/// Description:	用户密码加密
/// Input：     	密码原文
/// Output：    	加密后的密文
/// Others：		w ##class(web.DHCEkgService).PasswordEncrypt()
ClassMethod PasswordEncrypt(param As %String, Output rtnStr As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","PasswordEncrypt",$zd($h,3),$zt($p($h,",",2),1),param,"params")
	s rtnStr="" //加密密码
	s obj=##class(%Dictionary.CompiledMethod).%OpenId("BSP.SYS.BL.SSUser"_"||"_"ToCacheBCrypt",0)
	if ($IsObject(obj))
	{
		s rtnStr = ##class(BSP.SYS.BL.SSUser).ToCacheBCrypt(param)
	}
	else
	{
		s rtnStr = ##class(web.SSUser).Encrypt(param) //8.5之前加密的旧方法
	}
	//Set password = ##class(web.Util.Encryption).MD5HexStr(##class(web.SSUser).Encrypt(UserPwd))
 	//s retVal=##class(web.SSUser).IsValidUserMd5Password(UserCode,password) 
    //s retVal=##class(web.SSUser).IsValidUser(UserCode,UserPwd) 
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","PasswordEncrypt",$zd($h,3),$zt($p($h,",",2),1),rtnStr,"rtn")
	q $$$OK
}

/// Creator：    	yangyali
/// CreatDate： 	2022-12-30
/// ModifyDate：   
/// Description:	用户工号密码验证
/// Input：     	工号，密码原文
/// Output：    	
/// Others：		w ##class(web.DHCEkgService).IsValidUser()
ClassMethod IsValidUser(param As %String, Output rtnStr As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","IsValidUser",$zd($h,3),$zt($p($h,",",2),1),param,"params")
	s UserCode=$p(param,$c(10),1)
	s UserPwd=$p(param,$c(10),2)
	s rtnStr=##class(web.SSUser).IsValidUser(UserCode,UserPwd) 
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","IsValidUser",$zd($h,3),$zt($p($h,",",2),1),rtnStr,"rtn")
	q $$$OK
}

/// 方法说明：	获取生理周期字典
/// 创建者：	杨亚莉
/// 创建时间：	2023-1-29
/// 入参：		
/// 返回值：	生理周期信息(xml流)
/// w ##class(web.DHCEkgService).GetPhysiologicalCycleDic("",.rtn)
ClassMethod GetPhysiologicalCycleDic(param As %String, Output rtnPhc As %String) As %String
{
	s rtnPhc=""
	s rs=##class(%ResultSet).%New("web.DHCBL.CT.DHCPhysiologicalCycle:GetDataForCmb1")
	; d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCPhysiologicalCycle","GetDataForCmb1","","","")
	d rs.Execute("","","")
	while(rs.Next())
	{
		i (rtnPhc="") s rtnPhc=$g(rs.Data("PHYCDesc"))
		e  s rtnPhc=rtnPhc_"^"_$g(rs.Data("PHYCDesc"))
	}
	d rs.Close()
	q rtnPhc
}

/// 方法说明：	发送危急值状态给平台
/// 创建者：	杨亚莉
/// 创建时间：	2023-3-15
/// 入参：		
/// 返回值：	
/// w ##class(web.DHCEkgService).SentEmergencyStatus("5804||184","admin")
ClassMethod SentEmergencyStatus(OrdId As %String, UserName As %String) As %String
{
	try
	{
	//调平台接口更新his检查状态
	s ExamStatus="RP" ;报告
	s inputObj=##class(web.DHCEkg.SystemStatus.Dict.UpdateRequest).%New()
	s inputObj.ExamID="EKG||"_OrdId
	s inputObj.OEOrdItemID=OrdId
	s inputObj.Position=""
	s inputObj.SourceSystem="EKG"
	s inputObj.Status="CVRP"
	s inputObj.UpDateTime=$zdt($h,3)
	s inputObj.UserID=UserName ;工号
	s inputObj.UserName=..GetUserNameByCode(UserName) ;姓名
	
	s OrderRowid=$p(OrdId,"||",1)
	s itemsub=$p(OrdId,"||",2)
	s recLoc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6) //检查科室rowid
	s CtLocCode=$P(^CTLOC(recLoc),"^",1)
	s CtLocDesc=$P(^CTLOC(recLoc),"^",2)
	s inputObj.OperateDeptCode=CtLocCode 
	s inputObj.OperateDept=CtLocDesc 

	s json=##class(ext.util.JsonObject).ObjToJson(inputObj,"","") ;web.DHCEkg.SystemStatus.Dict.UpdateRequest
	s json="["_json_"]"
	s jsonStream=##class(%GlobalCharacterStream).%New()
	d jsonStream.Write(json)
	b ; w json
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","SentEmergencyStatus",$zd($h,3),$zt($p($h,",",2),1),json,OrdId,"UpdateSystemStatus")
	s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","SentEmergencyStatus",$zd($h,3),$zt($p($h,",",2),1),rtnUpdateSystem.Read(),OrdId,"UpdateSystemStatusRtn")
	}
	catch
	{
	d ##class(web.DHCEkg.Base).Log("ERROR","web.DHCEkgService","SentEmergencyStatus",$zd($h,3),$zt($p($h,",",2),1),$ze,OrdId,"UpdateSystemStatus")
	}
	q ""
}

/// Creator：    	yangyali
/// CreatDate： 	2023-3-23
/// ModifyDate：   
/// Description:	根据医嘱号获取部位
/// Input：     	医嘱号
/// Output：    	检查部位
/// Others：		w ##class(web.DHCEkgService).GetPosition("19951||14")
ClassMethod GetPosition(orditem As %String) As %String
{
	s arReqID=$o(^DHCAPREP(0,"OrdItem",orditem,""))    /// 检查申请ID
	Q:arReqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",orditem,arReqID,""))
	Q:CH="" ""
	s arPartDesc=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)  ///部位ID
	.Q:PartID=""
	.s ExeStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2) /// 执行状态
	.Q:ExeStat="D"
	.s PartCode=$p(^DHCAPPART(PartID),"^",1) 				 ///部位代码
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2) 				 ///部位
	.s arPartID=arReqID_"||"_CH_"||"_Sub
	.s PosiDesc=##Class(web.DHCAPPExaReportQuery).GetRepPosi(arPartID) /// 体位
	.i PosiDesc'="" s PartDesc=PartDesc_"("_PosiDesc_")"
	.i arPartDesc'="" s arPartDesc=arPartDesc_"、"_PartDesc
	.E  s arPartDesc=PartDesc
	q arPartDesc
}

/// 方法说明：	增加埋点信息
/// 创建者：	杨亚莉
/// 创建时间：	2023-3-29
/// 入参：		^分隔的参数
/// 				BizCode      必填  DTS系统业定义的业务代码
/// 				BizMainId    必填  业务主ID    如：就诊Id或病人id
/// 				BizId        可选  业务ID      如：医嘱Id, 执行Id, 处方Id, 报告Id
/// 				BizJson      可选  业务Json
/// 				UserCode    可选  默认当前用户代码
/// 				BizDate      可选  默认当前日期 YYYY-MM-DD
/// 				BizTime      可选  默认当前时间 HH:MM:SS 或 HH:MM
/// 返回值：	
/// w ##class(web.DHCEkgService).BizLogDTSInsert("",.rtn)
ClassMethod BizLogDTSInsert(param As %String, Output rtnInsert As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","BizLogDTSInsert",
		$zd($h,3),$zt($p($h,",",2),1),param,"param")
	s rtnInsert=""
	set obj=##class(%Dictionary.CompiledMethod).%OpenId("DHCDoc.Log.BizLogDTS"_"||"_"BizLogDTSInsert",0)
	if ($IsObject(obj))
	{
		s BizCode=$p(param,"^",1)
		s BizMainId=$p(param,"^",2)
		q:(BizId="")!(BizId'["||") ; 医嘱号过滤
		s BizId=$p(param,"^",3)
		s BizJson=$p(param,"^",4)
		s UserCode=$p(param,"^",5)
		i (BizMainId="") s BizMainId=$p($g(^OEORD($p(BizId,"||",1))),"^",1) //取就诊号
		q:(BizMainId="") ; 就诊号过滤
		s BizDate=$zd($h,3)
		s BizTime=$zt($p($h,",",2),1)
		
		s rtnInsert=##class(DHCDoc.Log.BizLogDTS).BizLogDTSInsert(BizCode,BizMainId,BizId,BizJson,UserCode,BizDate,BizTime)
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","BizLogDTSInsert",
			$zd($h,3),$zt($p($h,",",2),1),rtnInsert,"rtn")
	}
	q rtnInsert
}

}
