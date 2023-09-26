Class BILL.DC.Check Extends (%RegisteredObject, %XML.Adaptor, %ZEN.DataModel.Adaptor) [ ProcedureBlock ]
{

/// 方法必须有返回值-------------!!!!!!!!!!!!!!!!!!!!!!方法必须有返回值 禁止过程调用
/// 在terminal调试时是否显示w异常数据
Parameter WriteErrInfo [ Final, Internal ] = "N";

/// Creator：      tangzf
/// CreatDate：    2022-05-19
/// Description：  数据核查唯一入口
///                 1.核查流程
///                    BILL.DC.Check.Check()->循环核查分类(CheckType)->根据CheckType配置的类方法循环要核查的数据  
///                    ->每一条需要核查的数据进行各项指标核查（在每一条数据下根据CheckType循环指标），
///                 2.方法流程：BILL.DC.Check.Check()->CheckType中配置的类方法(组织数据参数)->指标方法QueruIndi()
///                    ->核查结果(根据指标插如、不计成功与否)InsertCheckResult()->异常数据存储SaveExInfo()
///                 3.新增核查指标对应的方法请保证：1.核查方法有返回值
/// Table：        
/// input:         
///                     StartDate, EndDate, StartTime , EndTime , HospDr
///                      CheckMode 核查模式 S,系统核查，U 用户核查，如果是手动核查请传U
///                     CheckType 核查分类多个用^分割CheckType1^CheckType2,
///                     IndicatorCodeStr:指标代码字符串（），多个指标用^分割：{checktype1:指标1^指标2,checktype2:指标1^指标2}
///                         ,UserId（系统任务核查时传入demo用户的ID）
///                         OldCKResultID:原核查结果主表记录RowId,如果不为空表示重新核查该单个指标，用于核查结果明细界面的重新核查
/// Output：       
/// Debug：   w ##class(BILL.DC.Check).Check("2021-1-1","2021-1-1","","","",2,"S","","1")
ClassMethod Check(StartDate, EndDate, StartTime, EndTime, CheckType, HospDr, CheckMode, IndicatorCodeStr, UserId, OldCKResultID = "")
{
	//如果起止日期是空值，则默认成T-1
	if (StartDate="")||(EndDate=""){
		s StartDate=$zd((+$h-1),3)
		s EndDate=$zd((+$h-1),3)
		d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Recommendation,"开始调用核查接口：入参起止日期为空，默认成T-1",StartDate, EndDate)
	}
    k ^TMPCheckTime
    s ^TMPCheckTime("CheckDate")=StartDate
    s ^TMPCheckTime("Start")=$zdt($h,3)
    s IndicatorCodeStr=$replace(IndicatorCodeStr,"'","""")
    s ^CacheTemp("DDataCheck1")=$lb(StartDate, EndDate, StartTime, EndTime, CheckType, HospDr, CheckMode, IndicatorCodeStr, UserId,OldCKResultID)
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Recommendation,"开始调用核查接口:",StartDate, EndDate, StartTime, EndTime, CheckType, HospDr, CheckMode, IndicatorCodeStr, UserId,OldCKResultID)
    s $zt="BILLDCCheckErr"
    k ^||TMPCheck
    k ^CacheTemp("BILL.DC.Batch",+$h-1) //将前一天的批次号清除，因此 请勿在凌晨12点左右进行核查
        // 原核查结果再次核查
        if (OldCKResultID'=""){
            s BusinessType=$lg(^BILL.DC.PO.CheckResultD(OldCKResultID),1)
            s IndicatorCode=$lg(^BILL.DC.PO.CheckResultD(OldCKResultID),2)
            s IndicatorCodeStr=BusinessType_IndicatorCode
            s CheckMode=$lg(^BILL.DC.PO.CheckResultD(OldCKResultID),4)
            s StartDate=$lg(^BILL.DC.PO.CheckResultD(OldCKResultID),5)
            s StartTime=$lg(^BILL.DC.PO.CheckResultD(OldCKResultID),6)
            s EndDate=$lg(^BILL.DC.PO.CheckResultD(OldCKResultID),7)
            s EndTime=$lg(^BILL.DC.PO.CheckResultD(OldCKResultID),8)
            s CheckMode=$lg(^BILL.DC.PO.CheckResultD(OldCKResultID),9)
            s HospDr=$lg(^BILL.DC.PO.CheckResultD(OldCKResultID),10)
            s UserId=$lg(^BILL.DC.PO.CheckResultD(OldCKResultID),11)
            s CheckType=##class(BILL.DC.BL.IndicatorDefCtl).GetIndiInfo(HospDr,"Y",BusinessType,IndicatorCode,4)
            q:+CheckType<0 "-99DC^再次核查时根据指标代码未取到核查分类"
            s rtn=##class(BILL.DC.BL.CheckResultDetCtl).DeleteByParent(OldCKResultID)
            q:(+rtn'=0)&&(rtn'=100) "-98DC^再次核查时删除核查结果子表失败"
            s ^||TMPCheck("CheckBatch")=$lg(^BILL.DC.PO.CheckResultD(OldCKResultID),17)         
        }
        if (OldCKResultID=""){
            s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
            s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
            s:StartTime'="" StartTime=$zth(StartTime)
            s:EndTime'="" EndTime=$zth(EndTime)
        }
        //一开始已判断值为空则赋值T-1
        //q:(StartDate="")||(EndDate="") "-2DC^核查日期不能为空"
        q:HospDr="" "-3DC^院区不能为空"
        q:##class(BILL.DC.BL.DicDataCtl).GetDicInfoByTypeCode("SYS","HISVer",HospDr,14)="" "-99DC^字典[SYS-HISVer]的对照代码处未维护版本号"
        q:UserId="" "-4DC^用户不能为空"
        s IsAlready="0"
        s ErrMsg=""
        //判断当前用户上一次核查是否完成
        if $d(^TMPBILL.DC.Check("UserID"))
        {
            if ^TMPBILL.DC.Check("UserID")=UserId 
            {
                s ErrMsg="时间:"_^TMPBILL.DC.Check("DateTime")_",用户:"_UserId_",核查方式:"_^TMPBILL.DC.Check("CheckMode")_",提交的查询未完成，请勿重复操作"
                s IsAlready="1"
            }
        }
        q:IsAlready="1" ErrMsg
        s ^TMPBILL.DC.Check("OldCKResultID")=OldCKResultID
        s ^TMPBILL.DC.Check("UserID")=UserId
        s ^TMPBILL.DC.Check("CheckMode")=CheckMode
        s ^TMPBILL.DC.Check("DateTime")=$zdt($h,3)
        // 全局变量
        s ^||TMPCheck("CheckMode")=CheckMode // 核查方式
        s ^||TMPCheck("HospDr")=HospDr
        s ^||TMPCheck("StartDate")=StartDate // 
        s ^||TMPCheck("EndDate")=EndDate
        s ^||TMPCheck("StartTime")=StartTime // 
        s ^||TMPCheck("EndTime")=EndTime
        s ^||TMPCheck("UserId")=UserId
        s ^||TMPCheck("IndicatorCodeStr")=IndicatorCodeStr
        q:(IndicatorCodeStr'="")&&('$IsObject(##class(%DynamicAbstractObject).%FromJSON(IndicatorCodeStr))) "-4DC^指标代码串不合法，不是json格式"
        //保存指标结果时用
        s ^||TMPCheck("IndicatorCode")=""
        s ^||TMPCheck("IndicatorId")=""
        //生成批次号
        s:OldCKResultID="" ^||TMPCheck("CheckBatch")=..BuildCheckBatch()
        s ^||TMPCheck("BusinessCode")=""  //指标业务代码
        // HIS版本号
        s ^||TMPCheck("HISVer")=##class(BILL.DC.BL.DicDataCtl).GetDicInfoByTypeCode("SYS","HISVer",HospDr,14)
        
        // 核查分类
        Set rrset=##class(%ResultSet).%New("BILL.DC.BL.DicDataCtl:QueryInfo")
        do rrset.Execute("G","","CheckType") 
        Set columns = rrset.GetColumnCount()
        //w "42",!,$zt($p($h,",",2)),!
        // 根据核查分类校验
        While (rrset.Next()) {
            s DicDemo=$p(rrset.GetDataByName("DicDemo"),":",1)
            s DicCode=rrset.GetDataByName("DicCode")
            continue:(CheckType'[DicCode)&&(CheckType'="")
            continue:(DicCode="NONE")
            continue:(rrset.GetDataByName("ActiveFlag")'="Y")
            s ^||TMPCheck("CheckType")=DicCode
            s methodTypertn=##class(%Dictionary.MethodDefinition).%ExistsId(DicDemo)
            if methodTypertn'="0"  d
            .//先插入核查分类相关的指标结果
            .d ..QueruIndi("","Y")
            .//
            .s Param=StartDate_$c(94)_EndDate_$c(94)_StartTime_$c(94)_EndTime
            .d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Recommendation,"开始核查分类:",DicCode,$p(DicDemo,"||",1),$p(DicDemo,"||",2),Param)
            .d XECUTECLASS^INSUFUN($p(DicDemo,"||",1),$p(DicDemo,"||",2),Param) 
            .d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Recommendation,"结束核查分类:",DicCode,$p(DicDemo,"||",1),$p(DicDemo,"||",2),Param)
        }
        //自定义指标校验
        s ^||TMPCheck("CheckType")="NONE"
        s inputObj=##class(%ArrayOfDataTypes).%New()
        d ..QueruIndi(inputObj,"Y")
        d ..QueruIndi(inputObj)
        // 一次性更新每个指标的异常数量
        s IndicatorId=""
        for  s IndicatorId=$o(^||TMPCheck("NUM",IndicatorId))  q:IndicatorId=""  d
        .s Num=^||TMPCheck("NUM",IndicatorId)
        .d ##class(BILL.DC.BL.CheckResultCtl).UpdateExceptionNum(Num,IndicatorId)

        //w "62",!,$zt($p($h,",",2)),!
        k ^||TMPCheck
        k ^TMPBILL.DC.Check
        s ^TMPCheckTime("End")=$zdt($h,3)
        q ""
BILLDCCheckErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"调用核查接口异常:",$ze)
    //b //ex----
    k ^||TMPCheck
    k ^TMPBILL.DC.Check
    //zw ex
    s ^TMPCheckTime("End")=$zdt($h,3)
    q $ze
}

/// Creator：      tangzf
/// CreatDate：    2022-05-19
/// Description：  根据核查分类查询指标 ，每条需要核查的数据调用
///                         不是由CheckType直接到此处，由CheckType->数据->到QueruIndi
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(INSU.COM.CheckBasicData).QueryOrdItem()
ClassMethod QueruIndi(InArgArr As %ArrayOfDataTypes, BuildFlag = "")
{
    s CheckType=^||TMPCheck("CheckType")
    s IndicatorCodeStr=^||TMPCheck("IndicatorCodeStr")
    i IndicatorCodeStr'="" d
    .s IndicatorCodeObj=##class(%DynamicAbstractObject).%FromJSON(IndicatorCodeStr)
    s Rowid=""
    f  s Rowid=$o(^CT.BILL.DC.IndicatorDefI("IndexHospActCheckType","G","Y",CheckType,Rowid)) q:Rowid=""  d
    .s Code=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),1)
    .s BusinessType=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),17)
    .q:..CheckHisVer(BusinessType,Code)=0 // 通过版本号控制哪些指标和业务类型不进行核查
    .s BusCode=BusinessType_Code
    .q:(IndicatorCodeStr'="")&&($ZOBJPROPERTY(IndicatorCodeObj,CheckType)'[Code)
    .s Desc=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),2)
    .s ExecClass=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),8)
    .s ExecClassMethodInfo=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),9)
    .s ExecClassMethod=$p(ExecClassMethodInfo,":",1)
    .s ParamInfo=$p(ExecClassMethodInfo,":",2) // 指标方法参数
    .s Param=""
    .s methodTypertn=##class(%Dictionary.MethodDefinition).%ExistsId(ExecClass_"||"_ExecClassMethod)
    .i methodTypertn="0"  d
    ..d ##class(BILL.DC.Common).Log("类方法不存在："_ExecClass_ExecClassMethod)
    .if methodTypertn'="0"  d
    ..s ^||TMPCheck("IndicatorCode")=Code
    ..s ^||TMPCheck("IndicatorId")=Rowid
    ..s ^||TMPCheck("BusinessCode")=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),17)
    ..s:BuildFlag="Y" rtn=..InsertCheckResult(Desc)
    ..q:BuildFlag="Y" //仅生成主表
    ..//构造入参
    ..q:($l(ParamInfo,"||")'=InArgArr.Count())&&(CheckType'="NONE") // 1.参数配置不正确的  2.父子表类型，且父子表都有校验的放在此处过滤可减少程序循环
    ..for i=1:1:$l(ParamInfo,"||")  d
    ...s ParamCode=$p(ParamInfo,"||",i)
    ...q:ParamCode=""
    ...i Param=""  d
    ....s Param=InArgArr.GetAt(ParamCode)
    ...e  d
    ....s Param=Param_$C(94)_InArgArr.GetAt(ParamCode)
    ..d XECUTECLASS^INSUFUN(ExecClass,ExecClassMethod,Param)
    .k ^||TMPCheck("IndicatorCode")
    .k ^||TMPCheck("BusinessCode")
    .k ^||TMPCheck("IndicatorId")
    .;d ##class(BILL.DC.Common).Log("核查方法不存在、核查参数不正确")
}

/// Creator：      tangzf
/// CreatDate：    2022-05-19
/// Description：  查询门诊日报
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(INSU.COM.CheckBasicData).QueryOrdItem()
ClassMethod QueryOPDailyReport(StartDate, EndDate, StartTime = "", EndTime = "")
{
    s inputObj=##class(%ArrayOfDataTypes).%New()
    for date=StartDate:1:EndDate
    {
        s footId=""
        while $o(^DHCOPInsFootI(0,"Date",date,footId))
        {
            s footId=$o(^DHCOPInsFootI(0,"Date",date,footId))
            d inputObj.SetAt(footId,"footId")
            d ..QueruIndi(inputObj)
        }
    }
    q ""
}

/// Creator：      tangzf
/// CreatDate：    2022-05-19
/// Description：  查询收费项目 
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(INSU.COM.CheckBasicData).QueryDHCTarItem("","","","")
ClassMethod QueryDHCTarItem(StartDate, EndDate, StartTime = "", EndTime = "")
{
    s RowId=""
    f  s RowId = $o(^DHCTARI(RowId)) q:RowId=""   d
    .s inputObj=##class(%ArrayOfDataTypes).%New()
    .;1.收费项目分类是否维护正确
    .q:(+RowId=0)
    .q:$g(^DHCTARI(RowId))=""
    .q:$p(^DHCTARI(RowId),"^",7)'="Y" //过滤无效标志
    .d inputObj.SetAt(RowId,"TarId")
    .d ..QueruIndi(inputObj)
    .s ChildSub=0
    .for  s ChildSub=$o(^DHCTARI(RowId,"P",ChildSub))  q:ChildSub=""  d
    ..;2023/2/1 过滤非核查院区的收费项数据
    ..s TPHospitalDR=$p($g(^DHCTARI(RowId,"P",ChildSub)),"^",16)
    ..q:(TPHospitalDR'="")&&(TPHospitalDR'=^||TMPCheck("HospDr"))
    
    ..d inputObj.SetAt(ChildSub,"TarPriceId")
    ..d ..QueruIndi(inputObj)
    ..;2.收费项目价格维护是否正确
    ..;d ..CheckTarItemPrice(RowId,ChildSub)
    ..//1.物价表中费别指针是否正确,2.收费项目单价是否为零
    ..//d ..QueryItemPriceTypeUnNormal(RowId, ChildSub)
    q ""
}

/// Creator：      tangzf
/// CreatDate：    2022-05-19
/// Description：  查询医嘱项目
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(INSU.COM.CheckBasicData).QueryArcItm("","","","")
ClassMethod QueryArcItm(StartDate, EndDate, StartTime = "", EndTime = "")
{
    s inputObj=##class(%ArrayOfDataTypes).%New()
    s RowId=""
    s Nowdate=$p($h,",",1) //当前日期
    f  s RowId=$O(^ARCIM(RowId)) Quit:RowId=""  d
    .s ver=""
    .f  s ver=$O(^ARCIM(RowId,ver)) Quit:ver=""  d
    ..q:(+RowId=0)||(+ver=0)
    ..s ARCIMEffDateTo="" //失效日期
    ..s ARCIMEffDate="" //生效日期
    ..s ORCATCode="" //医嘱名称
    ..if $g(^ARCIM(RowId,ver,7))'="" d
    ...s ARCIMEffDateTo=$p(^ARCIM(RowId,ver,7),"^",1) //失效日期
    ..if $g(^ARCIM(RowId,ver,1))'="" d
    ...s ARCIMEffDate=$p(^ARCIM(RowId,ver,1),"^",13) 
    ...s ARCIMItemCatDR=$p(^ARCIM(RowId,ver,1),"^",10)
    ...s ARCICOrdCatDR=$p(^ARC("IC",ARCIMItemCatDR),"^",8)
    ...s ORCATCode=""
    ...if ARCICOrdCatDR'="" d
    ....s ORCATCode=$p(^OEC("ORCAT",ARCICOrdCatDR),"^",1)
    ..s IsCheck=0 //判断是否检查此医嘱项
    ..s DicCode=""
    ..f  s DicCode=$o(^CT.BILL.DC.DicDataI("IndexDicTypeCodeHosp","G","PassArcItm",DicCode)) Quit:DicCode=""  d //字典中医嘱项目是否过滤，针对嘱托医嘱
    ...s DicRowid=$o(^CT.BILL.DC.DicDataI("IndexDicTypeCodeHosp","G","PassArcItm",DicCode,"")) //从字典取配置数据
    ...s ActiveFlag=$lg(^CT.BILL.DC.DicDataD(DicRowid),6)
    ...q:ActiveFlag'="Y"
    ...s DicDesc=$lg(^CT.BILL.DC.DicDataD(DicRowid),2)
    ...if (DicDesc'="")&&(ORCATCode[DicDesc) d //名称包括
    ....s IsCheck=1
    ...if RowId_"||"_ver=DicCode d //医嘱项id相同
    ....s IsCheck=1
    ..s DicCode=""
    ..f  s DicCode=$o(^CT.BILL.DC.DicDataI("IndexDicTypeCodeHosp","G","PassArcItmCat",DicCode)) Quit:DicCode=""  d
    ...s DicRowid=$o(^CT.BILL.DC.DicDataI("IndexDicTypeCodeHosp","G","PassArcItmCat",DicCode,"")) //从字典取配置数据 //字典中医嘱子类是否过滤，针对嘱托医嘱
    ...s ActiveFlag=$lg(^CT.BILL.DC.DicDataD(DicRowid),6)
    ...q:ActiveFlag'="Y"
    ...s DicDesc=$lg(^CT.BILL.DC.DicDataD(DicRowid),2)
    ...if ARCIMItemCatDR=DicCode d //医嘱子类相同
    ....s IsCheck=1
    ...if (DicDesc'="")&&($p(^ARC("IC",ARCIMItemCatDR),"^",3)[DicDesc) d //医嘱子类相同
    ....s IsCheck=1
    ..q:IsCheck=1   //(ORCATCode["嘱托") //由配置决定，不在写死
    ..q:(+Nowdate>+ARCIMEffDateTo)&&(+ARCIMEffDateTo>0)&&(+ARCIMEffDate<+Nowdate)  //过滤已经失效项目
    ..d inputObj.SetAt(RowId,"ArcItmId")
    ..d inputObj.SetAt(ver,"ver")
    ..d ..QueruIndi(inputObj)
    q ""
}

/// Creator：      tangzf
/// CreatDate：    2022-05-19
/// Description：  根据医嘱日期 查询医嘱明细 
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(INSU.COM.CheckBasicData).QueryOrdItem()
ClassMethod QueryOrdItem(StartDate, EndDate, StartTime = "", EndTime = "")
{
    f OEORIDate=StartDate:1:EndDate  d
    .s OEORD=""
    .for  s OEORD=$o(^OEORDi(0,"ItemDate",OEORIDate,OEORD))  q:OEORD=""  d
    ..s OEORI=0
    ..for  s OEORI=$o(^OEORDi(0,"ItemDate",OEORIDate,OEORD,OEORI))  q:OEORI=""  d
    ...s inputObj=##class(%ArrayOfDataTypes).%New()
    ...set ordPriorDR=$p(^OEORD(OEORD,"I",OEORI,1),"^",8)
    ...set ordPriorCode=$s((+ordPriorDR'=0):$p($g(^OECPR(+ordPriorDR)),"^",1),1:"")
    ...quit:(ordPriorCode["OM")   //自备药医嘱退出
    ...s TtemStat=$P($G(^OEORD(+OEORD,"I",OEORI,1)),"^",13)
    ...s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
    ...;医嘱无效和实习生审核的
    ...Q:(statcode="U")||(statcode="C")||(statcode="I")
    ...d inputObj.SetAt(OEORD,"OEORD")
    ...d inputObj.SetAt(OEORI,"OEORI")
    ...d ..QueruIndi(inputObj)
    ...d inputObj.SetAt(OEORIDate,"OEORIDate") 
    ...d ..QueruIndi(inputObj)
    q ""
}

/// Creator：      zjb
/// CreatDate：    2022-05-19
/// Description:根据账单日期查询账单信息
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(BILL.DC.Check).QueryBillInfo()
ClassMethod QueryBillInfo(StartDate, EndDate, StartTime = "", EndTime = "")
{
    f UpdateDate=StartDate:1:EndDate  
    {
        s BillRowid=0
        while $o(^DHCPB(0,"Date",UpdateDate,BillRowid))  
        {
            s inputObj=##class(%ArrayOfDataTypes).%New()
            s BillRowid=$o(^DHCPB(0,"Date",UpdateDate,BillRowid))
            continue:BillRowid=""
            s Adm=$p(^DHCPB(BillRowid),"^",1)
            s AdmType=$p(^PAADM(Adm),"^",2)
            i AdmType="H"  d
            .s a=1
            e  i AdmType="I"  d
            .//2.住院相关校验
            e  d
            .//3.门急诊相关校验
            d inputObj.SetAt(BillRowid,"BILL") 
            //d inputObj.SetAt("","PBO")
            //d inputObj.SetAt("","PBD") 
            d ..QueruIndi(inputObj)
            set BillData=$g(^DHCPB(BillRowid))
            
            s PBOChildSub=0
            while ($o(^DHCPB(BillRowid,"O",PBOChildSub))) {
                set PBOChildSub=$o(^DHCPB(BillRowid,"O",PBOChildSub))
                set PBOData=$g(^DHCPB(BillRowid,"O",PBOChildSub))
                //PBO相关校验开始
                d inputObj.SetAt(PBOChildSub,"PBO") 
                //d inputObj.SetAt(0,"PBD") 
                d ..QueruIndi(inputObj)
                //---
                s PBDChildSub=0
                while ($o(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))) {
                    set PBDChildSub=$o(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))
                    // PBD相关校验开始
                    d inputObj.SetAt(PBDChildSub,"PBD") 
                    d ..QueruIndi(inputObj)
                }
            }
        }       
    }
    q ""
}

/// Creator：      tangzf
/// CreatDate：    2022-05-19
/// Description：  根据门诊发票日期查询发票信息
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(BILL.DC.Check).QueryOrdItem()
ClassMethod QueryOPINVInfo(StartDate, EndDate, StartTime = "", EndTime = "")
{
    s inputObj=##class(%ArrayOfDataTypes).%New()
    f INVDate=StartDate:1:EndDate  d
    .s INV=""
    .for  s INV=$o(^DHCINVPRT(0,"Date",INVDate,INV))  q:INV=""  d
    ..s INVFlag=$p($g(^DHCINVPRT(INV)),"^",8)
    ..d inputObj.SetAt(INV,"PRTRowid") 
    ..d ..QueruIndi(inputObj)
    ..//是否存在预结算数据
    ..;d ..CheckINVPRT(INV)
    ..//门诊正常发票没有对应的账单
    ..;d ..CheckOPInvBillFlag(INV)
    ..// 发票对应的医嘱的计费状态是否正确
    ..;d ..CheckOPINVOEORIBillFlag(INV)
    ..//发票表与账单表是否平衡
    ..;d ..CheckOPInvPrtAndBillBalance(INV)
    q ""
}

/// Creator：      tangzf
/// CreatDate：    2022-05-19
/// Description：  根据住院发票日期查询发票信息
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(BILL.DC.Check).QueryOrdItem()
ClassMethod QueryIPINVInfo(StartDate, EndDate, StartTime = "", EndTime = "")
{
    s inputObj=##class(%ArrayOfDataTypes).%New()
    f INVDate=StartDate:1:EndDate  d
    .s IPINV=""
    .for  s IPINV=$o(^DHCINVPRTZY(0,"DATE",INVDate,IPINV))  q:IPINV=""  d
    ..d inputObj.SetAt(IPINV,"PRTRowid") 
    ..d ..QueruIndi(inputObj)
    ..// 住院正常发票没有对应的账单
    ..;d ..CheckIPInvBillFlag(IPINV)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-06-08
/// Description：  根据医保登记日期查询医保信息
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(BILL.DC.Check).QueryINSUAdmInfo()
ClassMethod QueryINSUAdmInfo(StartDate, EndDate, StartTime = "", EndTime = "")
{
    s inputObj=##class(%ArrayOfDataTypes).%New()
    f FunDate=StartDate:1:EndDate  d
    .s INADMRow=""
    .for  s INADMRow=$o(^DHCINADM("0","FunDate",FunDate,INADMRow))  q:INADMRow=""  d
    ..d inputObj.SetAt(INADMRow,"RowId") 
    ..d ..QueruIndi(inputObj)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-06-08
/// Description：  根据医保结算日期查询医保结算信息
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(BILL.DC.Check).QueryINSUDivide()
ClassMethod QueryINSUDivide(StartDate, EndDate, StartTime = "", EndTime = "")
{
    s inputObj=##class(%ArrayOfDataTypes).%New()
    f FunDate=StartDate:1:EndDate  d
    .s INPAYRow=""
    .for  s INPAYRow=$o(^DHCINDIV("0","IDate",FunDate,INPAYRow))  q:INPAYRow=""  d
    ..d inputObj.SetAt(INPAYRow,"RowId") 
    ..d ..QueruIndi(inputObj)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-06-09
/// Description：  查询院内账户信息
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(BILL.DC.Check).QueryAccManager()
ClassMethod QueryAccManager(StartDate, EndDate, StartTime = "", EndTime = "")
{
    s inputObj=##class(%ArrayOfDataTypes).%New()
    ;f FunDate=StartDate:1:EndDate  d
    s AccMRow=""
    for  s AccMRow=$o(^DHCACD("AccM",AccMRow))  q:AccMRow=""  d
    .d inputObj.SetAt(AccMRow,"RowId") 
    .d ..QueruIndi(inputObj)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-06-09
/// Description：  根据交款日期查询住院预交金明细
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(BILL.DC.Check).QueryIPDeposit()
ClassMethod QueryIPDeposit(StartDate, EndDate, StartTime = "", EndTime = "")
{
    s inputObj=##class(%ArrayOfDataTypes).%New()
    f FunDate=StartDate:1:EndDate  d
    .s prtrow=""
    .for  s prtrow=$o(^DHCSFPRINTDETAIL(0,"PrtDate",FunDate,prtrow))  q:prtrow=""  d
    ..d inputObj.SetAt(prtrow,"RowId") 
    ..d ..QueruIndi(inputObj)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2023-01-30
/// Description：  查询用户
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(BILL.DC.Check)QuerySSUser("","","","")
ClassMethod QuerySSUser(StartDate = "", EndDate = "", StartTime = "", EndTime = "")
{
    s inputObj=##class(%ArrayOfDataTypes).%New()
    s RowId=""
    s Nowdate=$p($h,",",1) //当前日期
    f  s RowId=$O(^SSU("SSUSR",RowId)) Quit:RowId=""  d
    .s IsCheck=0 //判断字典配置是否存在此医生
    .s DicCode=""
    .f  s DicCode=$o(^CT.BILL.DC.DicDataI("IndexDicTypeCodeHosp","G","PassUser",DicCode)) Quit:DicCode=""  d //字典中医嘱项目是否过滤，针对嘱托医嘱
    ..s DicRowid=$o(^CT.BILL.DC.DicDataI("IndexDicTypeCodeHosp","G","PassUser",DicCode,"")) //从字典取配置数据
    ..s ActiveFlag=$lg(^CT.BILL.DC.DicDataD(DicRowid),6)
    ..q:ActiveFlag'="Y"
    ..if RowId=DicCode d
    ...s IsCheck=1
    .q:IsCheck=1
    .s SSUSRDateTo=$p(^SSU("SSUSR",RowId),"^",97) //结束日期
    .s SSUSRActive=$p(^SSU("SSUSR",RowId),"^",19) //是否激活
    .q:(SSUSRActive="N")||((+SSUSRDateTo<+Nowdate)&&(SSUSRDateTo'=""))
    .d inputObj.SetAt(RowId,"RowId")
    .d ..QueruIndi(inputObj)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2023-02-03
/// Description：  根据入院日期核查
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(BILL.DC.Check).QueryOrdItemByExpDate()
ClassMethod QueryOrdItemByExpDate(StartDate, EndDate, StartTime = "", EndTime = "")
{
    f DischDate=StartDate:1:EndDate  d
    .s PAADM=""
    .for  s PAADM=$o(^PAADMi("DischDate",DischDate,PAADM))  q:PAADM=""  d
    ..s OEORD=0
    ..f  s OEORD=$o(^OEORD(0,"Adm",PAADM,OEORD)) q:OEORD=""  d
    ...s OEORI=0
    ...for  s OEORI=$o(^OEORD(OEORD,"I",OEORI))  q:OEORI=""  d
    ....s inputObj=##class(%ArrayOfDataTypes).%New()
    ....set ordPriorDR=$p(^OEORD(OEORD,"I",OEORI,1),"^",8)
    ....set ordPriorCode=$s((+ordPriorDR'=0):$p($g(^OECPR(+ordPriorDR)),"^",1),1:"")
    ....quit:(ordPriorCode["OM")   //自备药医嘱退出
    ....s TtemStat=$P($G(^OEORD(+OEORD,"I",OEORI,1)),"^",13)
    ....s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
    ....;医嘱无效和实习生审核的
    ....Q:(statcode="U")||(statcode="C")||(statcode="I")
    ....d inputObj.SetAt(OEORD,"OEORD")
    ....d inputObj.SetAt(OEORI,"OEORI")
    ....d ..QueruIndi(inputObj)
    q ""
}

/// ------------------------------------以上为查询入口-以下为核查逻辑
/// Creator：      Lizhi
/// CreatDate：    2023-01-30
/// Description：  校验医师是否维护医师编码
/// 1.表SS_User中判断结束日期是否大于当前核查日期，结束日期小于核查日期，不核查
/// 2.判断是否激活，未激活不核查
/// 3.判断是否是医生，不是医生跳过
/// 4.判断医生是否维护SSUSRFreeText3
/// Table：        SS_User
/// input:         
/// Output：      
/// Debug：       d ##class(BILL.DC.Check).CheckDoctorFreeText3(17434)
ClassMethod CheckDoctorFreeText3(RowId)
{
    s $zt="CheckDoctorFreeText3"
    ;s SSUSRIsThisDoctor=$p(^SSU("SSUSR",RowId),"^",7)
    ;q:SSUSRIsThisDoctor'="Y" ""
    s SSUSRCareProvDR=$p(^SSU("SSUSR",RowId),"^",14)
    q:SSUSRCareProvDR="" ""
    s CTPCPDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)
    s CTCPTInternalType=$p($g(^CT("CPT",CTPCPDR)),"^",4)
    q:CTCPTInternalType'="DOCTOR" ""
    s SSUSRFreeText3=$p(^SSU("SSUSR",RowId),"^",124) //国家医保代码
    s SSUSRName=$p(^SSU("SSUSR",RowId),"^",2) //姓名
    if SSUSRFreeText3="" d
    .s DataSrc="SS_User"
    .s DataID=RowId
    .s ErrCode="CT0106"
    .s ErrInfo="用户表SS_User.SSUSR_RowId:"_RowId_",姓名:"_SSUSRName_"的医师编码为空"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    q ""
CheckDoctorFreeText3
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"校验医师是否维护医师编码异常:",RowId,$ze)
    q ""
}

/// Creator：      ZhYW
/// CreatDate：    2022-05-06
/// Description：  住院实际发药数量与计费数量不一致
/// input:         
/// Output：      
/// Debug：       d ##class(BILL.DC.Check).CheckItemHospitalDR(3903,1)
ClassMethod CheckIPDspAndBillQty(OEORD, OEORI)
{
    s $zt="CheckIPDspAndBillQtyErr"
    s OEORIRowId=OEORD_"||"_OEORI
    s order=OEORD
    s itm=OEORI
    
    s PAADM=$p(^OEORD(OEORD),"^",1)
    s AdmType=$p(^PAADM(PAADM),"^",2)
    q:AdmType'="I" ""
    set ordCateType=..CheckDrug(OEORIRowId,"")
    q:ordCateType'="R" ""
    set CP=..GetBillPoint(OEORIRowId)     //取计费点
    q:CP'="CR" ""
                    
                
    set exec=0
    while($o(^OEORD(order,"I",itm,"X",exec))) {
        set exec=$o(^OEORD(order,"I",itm,"X",exec))
        set execData=$g(^OEORD(order,"I",itm,"X",exec))
        set execStDate=$p(execData,"^",1)
        set oeore=order_"||"_itm_"||"_exec
        set oeoreStatDR=$p(^OEORD(order,"I",itm,"X",exec,"BILL"),"^",1)    // OE_OrdExecExt.OEORE_OrderStatus_DR
        set oeoreStatCode=$s((+oeoreStatDR'=0):$p($g(^OEC("OSTAT",oeoreStatDR)),"^",1),1:"")
        //取实际计费数量
        set pboBillInfo=..GetOrderBillInfo(oeore)
        set pboUnitPrice=$p(pboBillInfo,"^",1)
        set pboTotalQty=$p(pboBillInfo,"^",2)
        set pboTotalAmount=$p(pboBillInfo,"^",3)
        //取实际发药数量
        set dspTotalQty=..GetDspQty(oeore)
        if (+pboTotalQty'=+dspTotalQty) {
            s DataSrc="User.OEOrdItem"
            s DataID=OEORIRowId
            s ErrCode="CT0102"
            s ErrInfo="医嘱"_OEORIRowId_"住院实际发药数量与计费数量不一致,计费数量:"_pboTotalQty_",发药数量："_dspTotalQty
            d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
        }
    }
    q ""
CheckIPDspAndBillQtyErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"住院实际发药数量与计费数量不一致异常:",OEORD_"||"_OEORI,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-06
/// Description：  物价表中院区指针是否正确
/// 1.表DHC_TarItemPrice中的TP_HospitalDR值是否在CT_Hospital中整表校验（过滤无效项目TARIActiveFlag）
/// 2.DHC_TarItemPrice中的TPHospitalDR值是否为空值 整表校验（过滤无效项目TARIActiveFlag）
/// Table：        DHC_TarItemPrice、CT_Hospital
/// input:         
/// Output：      
/// Debug：       d ##class(BILL.DC.Check).CheckItemHospitalDR(3903,1)
ClassMethod CheckItemHospitalDR(RowId, ChildSub)
{
    s $zt="CheckItemHospitalDRErr"
    s TPRowid = RowId_"||"_ChildSub
    q:$g(^DHCTARI(RowId,"P",(ChildSub)))="" ""  //过滤数据为空的数据
    s flag=$p(^DHCTARI($p(^DHCTARI(RowId,"P",(ChildSub)),"^",1)),"^",7)
    q:flag="N" "" //过滤无效项目
    s HospitalDR=$p(^DHCTARI(RowId,"P",ChildSub),"^",16)
    if HospitalDR=""  d ///DHC_TarItemPrice中的TPHospitalDR值为空值
    .s DataSrc="User.DHCTarItemPrice"
    .s ErrInfo="物价表DHCTarItemPrice.TPRowid:"_TPRowid_"中院区指针为空"
    .s DataID=TPRowid
    .s ErrCode="CT0101"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    else  if $g(^CT("HOSP",HospitalDR))=""  d   ///表DHC_TarItemPrice中的TP_HospitalDR值不在CT_Hospital中
    .s DataSrc="User.DHCTarItemPrice"
    .s DataID=TPRowid
    .s ErrCode="CT0102"
    .s ErrInfo="物价表DHCTarItemPrice.TPRowid:"_TPRowid_"的TP_HospitalDR值不在CT_Hospital中"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    q ""
CheckItemHospitalDRErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"物价表中院区指针是否正确异常:",RowId_"||"_ChildSub,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/05/08
/// Description:1.物价表中费别指针是否正确
/// 1.表DHC_TarItemPrice中的TP_PatInsType值是否在PAC_AdmReason中
/// 2.DHC_TarItemPrice中的TP_PatInsType值是否为空值
/// 3.整表校验（（过滤无效项目TARIActiveFlag））
/// Input:
/// Output:
/// do ##class(BILL.DC.Check).CheckItemPriceTypeUnNormal()
ClassMethod CheckItemPayTypeUnNormal(RowId, ChildSub)
{
    s $zt="CheckItemPayTypeUnNormalErr"
    set TARIActiveFlag=$p(^DHCTARI(RowId),"^",7)
    quit:TARIActiveFlag'="Y" ""  //过滤非Y项目
 
    set TPDATA = $g(^DHCTARI(RowId,"P",ChildSub))
    quit:TPDATA="" ""
    set TPRowid = RowId_"||"_ChildSub
    set TPPatInsType = $p(TPDATA,"^",13) //病人保险类型  PAC_AdmReason
    set TPPrice = $p(TPDATA,"^",5) //标准价格
    
    if TPPatInsType="" 
    {   
        //w "TPRowid：",TPRowid,"，错误描述：CT0201，物价表中费别指针为空",!
        //s ^TMPTPPatInsType(TPRowid) = TPRowid_"，错误描述：CT0201，物价表中费别指针为空"
        s DataSrc="User.DHCTarItemPrice"
        s DataID=TPRowid
        s ErrCode="CT0201"
        s ErrInfo="物价表DHC_TarItemPrice.TP_RowId:"_TPRowid_"中费别指针TP_PatInsType为空值。"
        d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
    }else{
        set PACAdmReasonData = $g(^PAC("ADMREA",TPPatInsType))
        if PACAdmReasonData="" {
            //w "TPRowid：",TPRowid,"，错误代码：CT0202，物价表中费别指针指向的医院不存在",!
            //s ^TMPAdmReasonData(TPRowid) = TPRowid_"，错误描述：CT0202，物价表中费别指针指向的费别不存在"
            s DataSrc="User.DHCTarItemPrice"
            s DataID=TPRowid
            s ErrCode="CT0202"
            s ErrInfo="物价表DHC_TarItemPrice.TP_RowId:"_TPRowid_"中费别指针TP_PatInsType:"_TPPatInsType_",指向的费别不存在。"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
        }
    }
    q ""
CheckItemPayTypeUnNormalErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"物价表中费别指针是否正确异常:",RowId_"||"_ChildSub,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-07
/// Description：  收费项目分类维护是否正确
/// 1.DHC_TarItem中的TARI_SubCate、TARI_AcctCate、TARI_OutpatCate、TARI_EMCCate、TARI_MRCate、TARI_MCNew、TARI_InpatCate是否为空
/// 2.DHC_TarItem中的TARI_SubCate->DHC_TarSubCate、TARI_AcctCate->DHC_TarAcctCate、TARI_OutpatCate->DHC_TarOutpatCate、TARI_EMCCate->DHC_TarEMCCate、TARI_MRCate->DHC_TarMRCate、TARI_MCNew->DHC_TarMCCateNew、TARI_InpatCate->DHC_TarInpatCate值是否存在
/// 3.整表校验(过滤无效项目TARIActiveFlag)
/// input:         
/// Output：    
/// Debug：       d ##class(BILL.DC.Check).CheckItemProjectClass(1000)
ClassMethod CheckItemProjectClass(RowId)
{
    s $zt="CheckItemProjectClassErr"
    s TPRowid = RowId
    q:TPRowid="0" ""
    q:$g(^DHCTARI(RowId))="" "" ///过滤空项目
    q:$p(^DHCTARI(RowId),"^",7)="N" "" ///过滤TARIActiveFlag无效的项目
    if $p(^DHCTARI(RowId),"^",4)="" d  ///DHC_TarItem中的TARI_SubCate值为空
    .s DataSrc="User.DHCTarItem"
    .s DataID=TPRowid
    .s ErrCode="CT0301"
    .s ErrInfo="DHC_TarItem.TPRowid:"_TPRowid_"中的TARI_SubCate值在对应字典表中不存在"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    else  if $g(^DHCTarC("SC",($p(^DHCTARI(RowId),"^",4))))="" d ///DHC_TarItem中的TARI_SubCate值在对应字典表中不存在
    .s DataSrc="User.DHCTarItem"
    .s DataID=TPRowid
    .s ErrInfo="DHC_TarItem.TPRowid:"_TPRowid_"中的TARI_SubCate值在对应字典表中不存在"
    .s ErrCode="CT0308"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    if $p(^DHCTARI(RowId),"^",5)="" d  ///TARI_AcctCate为空
    .s DataSrc="User.DHCTarItem"
    .s DataID=TPRowid
    .s ErrInfo="DHC_TarItem.TPRowid:"_TPRowid_"中的TARI_AcctCate值为空"
    .s ErrCode="CT0302"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    else  if $g(^DHCTarC("AC",($p(^DHCTARI(RowId),"^",5))))="" d ///DHC_TarItem中的TARI_AcctCate值在对应字典表中不存在
    .s DataSrc="User.DHCTarItem"
    .s DataID=TPRowid
    .s ErrInfo="DHC_TarItem.TPRowid:"_TPRowid_"中的TARI_AcctCate值在对应字典表中不存在"
    .s ErrCode="CT0309"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    if $p(^DHCTARI(RowId),"^",15)="" d  ///TARIOutpatCate为空
    .s DataSrc="User.DHCTarItem"
    .s DataID=TPRowid
    .s ErrCode="CT0303"
    .s ErrInfo="DHC_TarItem.TPRowid:"_TPRowid_"中的TARI_OutpatCate值为空"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    else  if $g(^DHCTarC("OC",$p(^DHCTARI(RowId),"^",15)))="" d ///DHC_TarItem中的TARI_OutpatCate值在对应字典表中不存在
    .s DataSrc="User.DHCTarItem"
    .s DataID=TPRowid
    .s ErrInfo="DHC_TarItem.TPRowid:"_TPRowid_"中的TARI_OutpatCate值在对应字典表中不存在"
    .s ErrCode="CT0310"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    if $p(^DHCTARI(RowId),"^",16)="" d  ///TARIEMCCate为空
    .s DataSrc="User.DHCTarItem"
    .s DataID=TPRowid
    .s ErrInfo="DHC_TarItem.TPRowid:"_TPRowid_"中的TARI_EMCCate值为空"
    .s ErrCode="CT0304"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    else  if $g(^DHCTarC("EC",$p(^DHCTARI(RowId),"^",16)))="" d ///DHC_TarItem中的TARI_EMCCate值在对应字典表中不存在
    .s DataSrc="User.DHCTarItem"
    .s DataID=TPRowid
    .s ErrInfo="DHC_TarItem.TPRowid:"_TPRowid_"中的TARI_EMCCate值在对应字典表中不存在"
    .s ErrCode="CT0311"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    if $p(^DHCTARI(RowId),"^",6)="" d  ///TARIMRCate为空
    .s DataSrc="User.DHCTarItem"
    .s DataID=TPRowid
    .s ErrInfo="DHC_TarItem.TPRowid:"_TPRowid_"中的TARI_MRCate值为空"
    .s ErrCode="CT0305"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    else  if $g(^DHCTarC("MC",$p(^DHCTARI(RowId),"^",6)))="" d ///DHC_TarItem中的TARI_MRCate值在对应字典表中不存在
    .s DataSrc="User.DHCTarItem"
    .s DataID=TPRowid
    .s ErrInfo="DHC_TarItem.TPRowid:"_TPRowid_"中的TARI_MRCate值在对应字典表中不存在"
    .s ErrCode="CT0312"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    if $p(^DHCTARI(RowId),"^",30)="" d  ///TARIMCNew为空
    .s DataSrc="User.DHCTarItem"
    .s DataID=TPRowid
    .s ErrInfo="DHC_TarItem.TPRowid:"_TPRowid_"中的TARI_MCNew值为空"
    .s ErrCode="CT0306"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    else  if $g(^DHCTarC("MCNew",$p(^DHCTARI(RowId),"^",30)))="" d ///DHC_TarItem中的TARI_MCNew值在对应字典表中不存在
    .s DataSrc="User.DHCTarItem"
    .s DataID=TPRowid
    .s ErrInfo="DHC_TarItem.TPRowid:"_TPRowid_"中的TARI_MCNew值在对应字典表中不存在"
    .s ErrCode="CT0313"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    if $p(^DHCTARI(RowId),"^",14)="" d  ///TARIInpatCate为空
    .s DataSrc="User.DHCTarItem"
    .s DataID=TPRowid
    .s ErrInfo="DHC_TarItem.TPRowid:"_TPRowid_"中的TARI_InpatCate值为空"
    .s ErrCode="CT0307"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    else  if $g(^DHCTarC("IC",$p(^DHCTARI(RowId),"^",14)))="" d ///DHC_TarItem中的TARI_InpatCate值在对应字典表中不存在
    .s DataSrc="User.DHCTarItem"
    .s DataID=TPRowid
    .s ErrInfo="DHC_TarItem.TPRowid:"_TPRowid_"中的TARI_InpatCate值在对应字典表中不存在"
    .s ErrCode="CT0314"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    q ""
CheckItemProjectClassErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"收费项目分类维护是否正确异常:",RowId,$ze)
    q ""
}

/// Creator: dingsh
/// CreatDate:2022/08/29
/// Description: 校验医院审批标志
/// Input:
/// Output:
/// do ##class(BILL.DC.Check).CheckItemPriceUnNormal(8025,1)
ClassMethod CheckPBDInsuFlag(PBRowId, PBOChildSub, PBDChildSub)
{
    
    s $zt="CheckPBDInsuFlagErr"
    //过滤免审项目
    s IndicatorId=^||TMPCheck("BusinessCode")_"||"_^||TMPCheck("IndicatorCode")
    s ConfigValue=$p(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub),"^",3) //收费项id
    s ischeck=##class(BILL.DC.BL.UnAuditItmCtl).CheckUnAuditItm(^||TMPCheck("HospDr"),IndicatorId,"TarItem",ConfigValue) //检查是否在表
    q:ischeck="Y" ""
    
    s rtn=##class(web.DHCINSUPort).CheckINSUDivideSubSelfAmountByPBDId(PBRowId_"||"_PBOChildSub_"||"_PBDChildSub)
    if (+rtn="-2")
    {
        s DataSrc="User.DHCPatBillDetails"
        s DataID=PBRowId_"||"_PBOChildSub_"||"_PBDChildSub
        s ErrCode="IPBILL1001"
        s ErrInfo="医院审批标志和上传时的不一致"_rtn
        d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
    }
    
    q ""
CheckPBDInsuFlagErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"校验医院审批标志")
    q ""
}

/// Creator: zjb
/// CreatDate:2022/05/08
/// Description:1.收费项目单价是否为零
/// 1.DHC_TarItemPrice中的TPPrice是否为0（过滤指定项目（配置指定项目不需要校验））
/// 2.整表校验（过滤无效项目TARIActiveFlag）
/// Input:
/// Output:
/// do ##class(BILL.DC.Check).CheckItemPriceUnNormal(8025,1)
ClassMethod CheckItemPriceUnNormal(RowId, ChildSub)
{
    
    s $zt="CheckItemPriceUnNormalErr"
    //^DHCTARI({DHC_TarItem.TARI_RowId},"P",{TP_ChildSub})  
    set TARIActiveFlag=$p($g(^DHCTARI(RowId)),"^",7)
    quit:TARIActiveFlag'="Y" ""  //过滤非Y项目
    set TARISubCate=$p(^DHCTARI(RowId),"^",4)
    q:TARISubCate="" ""
    set TARSCTARCDR=$p($g(^DHCTarC("SC",TARISubCate)),"^",3)
    q:TARSCTARCDR="" ""
    set TPDATA = $g(^DHCTARI(RowId,"P",ChildSub))
    quit:TPDATA="" ""
    ;+2019-7-30 tangzf 医院授权判断 start
    s CheckHosipitalSession=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarItem",RowId,^||TMPCheck("HospDr"))
    q:CheckHosipitalSession'="Y" "" ; 该院区无权查看该数据
    ;+2019-7-30 tangzf 医院授权判断 end
    set TPRowid = RowId_"||"_ChildSub
    set TPPrice = 0 //标准价格
    if TARSCTARCDR="1"  //药品
    {
        set TPPrice=$p(##class(web.UDHCJFPRICE).GetItmPrice(RowId,"","","","",^||TMPCheck("HospDr"),""),"^",1)
    }
    else
    {
        set TPPrice = $p(TPDATA,"^",5) //非药品价格
    }
    //收费项目单价是否为零
    if TPPrice=0 
    {
        s IndicatorId=^||TMPCheck("BusinessCode")_"||"_^||TMPCheck("IndicatorCode")
        //过滤免审项目
        if "Y"'=##class(BILL.DC.BL.UnAuditItmCtl).CheckUnAuditItm(^||TMPCheck("HospDr"),IndicatorId,"TarItem",RowId)
        {
            //w "TPRowid：",TPRowid,"，错误描述：CT0401，DHC_TarItemPrice中的TPPrice为0",!
            //s ^TMPTPPrice(TPRowid) = TPRowid_"，错误描述：CT0401，DHC_TarItemPrice中的TPPrice为0"
            s DataSrc="User.DHCTarItemPrice"
            s DataID=TPRowid
            s ErrCode="CT0401"
            s ErrInfo="物价表DHC_TarItemPrice.TP_RowId:"_TPRowid_"中的TP_Price为0。"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
        }
    }
    q ""
CheckItemPriceUnNormalErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"收费项目单价是否为零异常:",RowId_"||"_ChildSub,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-07
/// Description： 医嘱项是否对应有效收费项
/// 1.非药品医嘱项是否在医嘱项和收费项关联表,DHC_OrderLinkTar中有对照
/// 2.如果有对照，对照的收费项目TARIActiveFlag是否有效
/// 2.药品医嘱：接口判断##class(PHA.FACE.OUT.Com).GetTarListByArcim(ArcimRowid,"")
/// 3.非药品医嘱项在医嘱项和收费项关联表DHC_OrderLinkTar的对照开始时间OLT_StartDate是否比医嘱项Arc_ItmMast.ARCIM_EffDate的有效日期早
/// 4.从Arc_ItmMast开始整表循环
/// Debug：d ##class(BILL.DC.Check).CheckArcimCharge(8805,2)
ClassMethod CheckArcimCharge(ArcItmId, ver)
{
    s $zt="CheckArcimChargeErr"
    q:(ArcItmId="0")||(ver="0") ""
    //q:$g(^ARCIM(ArcItmId,ver))="" ""
    s RowId=ArcItmId
    s TPRowid=RowId_"||"_ver
    if ##class(PHA.COM.Drug).IsDrug(RowId_"||"_ver,"1")'="1"   d ///非药品
    .s ARCIMEffDate=$p($p(^ARCIM(RowId,ver,1),"^","13"),"Z",1) //医嘱项有效日期
    .s OLTTariffDR="0"
    .if $o(^DHCOLT(0,"ARTTA",RowId_"||"_ver,""))=""  d  //非药品医嘱项没有维护对应的收费项
    ..s DataSrc="User.ArcItmMast"
    ..s DataID=TPRowid
    ..s ErrCode="CT0501"
    ..s ErrInfo="非药品医嘱项ArcItmMast.ARCIM_Subscript:"_ArcItmId_"ARCIM_Version:"_ver_"没有维护对应的收费项"
    ..d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    .else  d //查询TARIActiveFlag
    ..s OLTTariffDR="0"
    ..f  s OLTTariffDR=$o(^DHCOLT(0,"ARTTA",RowId_"||"_ver,OLTTariffDR)) q:OLTTariffDR=""  d //获取医嘱对应的收费项列表
    ...q:$g(^DHCTARI(OLTTariffDR))="" //数据为空跳过
    ...s TARIActiveFlag=$p(^DHCTARI(OLTTariffDR),"^",7)
    ...if TARIActiveFlag="N" d
    ....s DataSrc="User.ArcItmMast"
    ....s DataID=TPRowid
    ....s ErrCode="CT0502"
    ....s ErrInfo="非药品医嘱项ArcItmMast.ARCIM_Subscript:"_ArcItmId_"ARCIM_Version:"_ver_"对应收费项TARI_RowId:"_OLTTariffDR_"的TARIActiveFlag=“N”"
    ....d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
#;  .f  s OLTTariffDR=$o(^DHCOLT(0,"ARTTA",RowId_"||"_ver,OLTTariffDR)) q:OLTTariffDR=""  d //获取医嘱对应的收费项列表
#;  ..q:$g(^DHCTARI(OLTTariffDR))="" //数据为空跳过
#;  ..s OLTStartDateRow=""
#;  ..f  s OLTStartDateRow=$o(^DHCOLT(0,"ARTTA",RowId_"||"_ver,OLTTariffDR,OLTStartDateRow)) q:OLTStartDateRow=""  d //取对照时间
#;  ...if +OLTStartDateRow>+ARCIMEffDate d  //对照开始时间晚于医嘱生效日期
#;  ....s DataSrc="User.ArcItmMast"
#;  ....s DataID=TPRowid
#;  ....s ErrInfo="非药品医嘱项ArcItmMast.ARCIM_Subscript:"_ArcItmId_"ARCIM_Version:"_ver_"与收费项DHC_OrderLinkTar.OLT_ARCIM_DR:"_TPRowid_"OLT_Tariff_DR:"_OLTTariffDR_"对照开始时间晚于医嘱生效日期"
#;  ....s ErrCode="CT0701"
#;  ....d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
#;  ...s OLTRowId="0"
#;  ...f  s OLTRowId=$o(^DHCOLT(0,"ARTTA",RowId_"||"_ver,OLTTariffDR,OLTStartDateRow,OLTRowId)) q:OLTRowId="" 
#;  ....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
#;  ....if +OLTEndDate'<+$h d //对照结束日期未失效
#;  .....if $p(^DHCTARI(OLTTariffDR),"^",7)'="Y" d  //失效的收费项
#;  ......s DataSrc="User.ArcItmMast"
#;  ......s DataID=TPRowid
#;  ......s ErrInfo="非药品医嘱项ArcItmMast.ARCIM_Subscript:"_ArcItmId_"ARCIM_Version:"_ver_"维护了失效的收费项"
#;  ......s ErrCode="CT0502"
#;  ......d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    else  d
    .if ##class(PHA.FACE.OUT.Com).GetTarListByArcim(RowId_"||"_ver,$h)="" d  ///药品医嘱没有对照收费项
    ..s DataSrc="User.ArcItmMast"
    ..s DataID=TPRowid
    ..s ErrCode="CT0503"
    ..s ErrInfo="药品医嘱项ArcItmMast.ARCIM_Subscript:"_ArcItmId_"ARCIM_Version:"_ver_"没有维护有效的收费项"
    ..d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    q ""
CheckArcimChargeErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"医嘱项是否对应有效收费项异常:",ArcItmId_"||"_ver,$ze)
    q ""
}

/// Creator：      Lizhi---停用
/// CreatDate：    2022-05-07
/// Description：  医嘱项与收费项对照开始时间是否正确
/// 1.非药品医嘱项在医嘱项和收费项关联表DHC_OrderLinkTar的对照开始时间OLT_StartDate是否比医嘱项Arc_ItmMast.ARCIM_EffDate的有效日期早
/// Debug：d ##class(BILL.DC.Check).CheckArcimChargeTime(8805,1)
ClassMethod CheckArcimChargeTime(ArcItmId, ver)
{
    s $zt="CheckArcimChargeTimeErr"
    //q:$g(^ARCIM(ArcItmId,ver))="" ""
    q:(ArcItmId="0")||(ver="0") ""
    s RowId=ArcItmId
    s TPRowid=RowId_"||"_ver
    if ##class(PHA.COM.Drug).IsDrug(RowId_"||"_ver,"1")'="1"   d ///非药品
    .s ARCIMEffDate=$p($p(^ARCIM(RowId,ver,1),"^","13"),"Z",1) //医嘱项有效日期
    .s OLTTariffDR="0"
    .f  s OLTTariffDR=$o(^DHCOLT(0,"ARTTA",RowId_"||"_ver,OLTTariffDR)) q:OLTTariffDR=""  d //获取医嘱对应的收费项列表
    ..q:$g(^DHCTARI(OLTTariffDR))="" //数据为空跳过
    ..if $o(^DHCOLT(0,"ARTTA",RowId_"||"_ver,OLTTariffDR,""))="" d
    ...s DataSrc="User.ArcItmMast"
    ...s DataID=TPRowid
    ...s ErrInfo="非药品医嘱项ArcItmMast.ARCIM_Subscript:"_ArcItmId_"ARCIM_Version:"_ver_"与收费项DHC_OrderLinkTar.OLT_ARCIM_DR:"_TPRowid_"OLT_Tariff_DR:"_OLTTariffDR_"对照开始时间为空"
    ...s ErrCode="CT0701"
    ...d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    ..s OLTStartDateRow=""
    ..f  s OLTStartDateRow=$o(^DHCOLT(0,"ARTTA",RowId_"||"_ver,OLTTariffDR,OLTStartDateRow)) q:OLTStartDateRow=""  d //取对照时间
    ...if OLTStartDateRow>ARCIMEffDate d  //对照开始时间晚于医嘱有效日期 
    ....s DataSrc="User.ArcItmMast"
    ....s DataID=TPRowid
    ....s ErrInfo="非药品医嘱项ArcItmMast.ARCIM_Subscript:"_ArcItmId_"ARCIM_Version:"_ver_"与收费项DHC_OrderLinkTar.OLT_ARCIM_DR:"_TPRowid_"OLT_Tariff_DR:"_OLTTariffDR_"对照开始时间晚于医嘱录入时间"
    ....s ErrCode="CT0701"
    ....d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    q ""
CheckArcimChargeTimeErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"医嘱项与收费项对照开始时间是否正确异常:",ArcItmId_"||"_ver,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/05/08
/// Description:各项目子类大类是否正确
/// Input:
/// Output:
/// do ##class(BILL.DC.Check).CheckTarItemAndCate()
ClassMethod CheckTarItemAndCate(a = "")
{
    s $zt="CheckTarItemAndCateErr"
    //1、验证DHC_TarSubCate.TARSC_TARC_DR->DHC_TarCate
    //DHC_TarSubCate,^DHCTarC("SC",{TARSC_RowId});  DHC_TarCate,^DHCTarC("CC",{TARC_RowId})
    set TARSCRowId = 0
    while ($o(^DHCTarC("SC",TARSCRowId)))  {
        set TARSCRowId = $o(^DHCTarC("SC",TARSCRowId))
        set TARSCData=$g(^DHCTarC("SC",TARSCRowId))
        set TARSCTARCDR = $p(TARSCData,"^",3) //指针
        set TARSCDesc =$p(TARSCData,"^",2) //描述
        //w "TARSCRowId："_TARSCRowId_",TARSC_TARC_DR："_TARSCTARCDR,!
        if TARSCTARCDR="" {
            //set ^TMPTARSC(TARSCRowId)="Rowid:"_TARSCRowId_",TARSC_TARC_DR值为空"
            //w "DHC_TarSubCate,Rowid:"_TARSCRowId_",TARSC_TARC_DR值为空",!
            s DataSrc="User.DHCTarSubCate"
            s DataID=TARSCRowId
            s ErrCode="CT0601"
            s ErrInfo="DHC_TarSubCate.TARSC_RowId:"_TARSCRowId_"的TARSC_TARC_DR值为空。"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
        }else{
            set RARSCDataSub=$g(^DHCTarC("CC",TARSCTARCDR))
            if RARSCDataSub=""{
                //set ^TMPTARSC(TARSCRowId)="Rowid:"_TARSCRowId_",指向DHC_TarCate值为空"
                //w "DHC_TarSubCate,Rowid:"_TARSCRowId_",指向DHC_TarCate值为空",!
                s DataSrc="User.DHCTarSubCate"
                s DataID=TARSCRowId
                s ErrCode="CT0601"
                s ErrInfo="DHC_TarSubCate.TARSC_RowId:"_TARSCRowId_"的TARSC_TARC_DR:"_TARSCTARCDR_",指向DHC_TarCate值为空。"
                d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            }
        }
    }
    ;w !
    //2、验证DHC_TarAcctCate.TARAC_TARTAC_DR->DHC_TarAC
    //DHC_TarAcctCate,^DHCTarC("AC",{TARAC_RowId});  DHC_TarAC,^DHCTarC("TAC",{TARTAC_RowId})
    set TARACRowId = 0
    while ($o(^DHCTarC("AC",TARACRowId)))  {
        set TARACRowId = $o(^DHCTarC("AC",TARACRowId))
        set TARACData=$g(^DHCTarC("AC",TARACRowId))
        set TARACTARTACDR = $p(TARACData,"^",3) //指针
        set TARACDesc =$p(TARACData,"^",2) //描述
        //w "TARACRowId："_TARACRowId_",TARAC_TARTAC_DR："_TARACTARTACDR,!
        if TARACTARTACDR="" {
            //set ^TMPTARAC(TARACRowId)="Rowid:"_TARACRowId_",TARAC_TARTAC_DR值为空"
            //w "DHC_TarAcctCate,Rowid:"_TARACRowId_",TARAC_TARTAC_DR值为空",!
            s DataSrc="User.DHCTarAcctCate"
            s DataID=TARACRowId
            s ErrCode="CT0602"
            s ErrInfo="DHC_TarAcctCate.TARAC_RowId:"_TARACRowId_"的TARAC_TARTAC_DR值为空。"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
        }else{
            set RARACDataSub=$g(^DHCTarC("TAC",TARACTARTACDR))
            if RARACDataSub=""{
                //set ^TMPTARAC(TARACRowId)="Rowid:"_TARACRowId_",指向DHC_TarAC值为空"
                //w "DHC_TarAcctCate,Rowid:"_TARACRowId_",指向DHC_TarAC值为空",!
                s DataSrc="User.DHCTarAcctCate"
                s DataID=TARACRowId
                s ErrCode="CT0602"
                s ErrInfo="DHC_TarAcctCate.TARAC_RowId:"_TARACRowId_"的TARAC_TARTAC_DR:"_TARACTARTACDR_",指向DHC_TarAC值为空。"
                d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            }
        }
    }
    ;w !
    //3、验证DHC_TarOutpatCate.TAROC_TARTOC_DR->DHC_TarOC
    //DHC_TarOutpatCate,^DHCTarC("OC",{TAROC_RowId});  DHC_TarOC,^DHCTarC("TOC",{TARTOC_RowId})
    set TAROCRowId = 0
    while ($o(^DHCTarC("OC",TAROCRowId)))  {
        set TAROCRowId = $o(^DHCTarC("OC",TAROCRowId))
        set TAROCData=$g(^DHCTarC("OC",TAROCRowId))
        set TAROCTARTOCDR = $p(TAROCData,"^",3) //指针
        set TAROCDesc =$p(TAROCData,"^",2) //描述
        //w "TAROCRowId："_TAROCRowId_",TAROC_TARC_DR："_TAROCTARTOCDR,!
        if TAROCTARTOCDR="" {
            //set ^TMPTAROC(TAROCRowId)="Rowid:"_TAROCRowId_",TAROC_TARTOC_DR值为空"
            //w "DHC_TarOutpatCate,Rowid:"_TAROCRowId_",TAROC_TARTOC_DR值为空",!
            s DataSrc="User.DHCTarOutpatCate"
            s DataID=TAROCRowId
            s ErrCode="CT0603"
            s ErrInfo="DHC_TarOutpatCate.TAROC_RowId:"_TAROCRowId_"的TAROC_TARTOC_DR值为空。"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
        }else{
            set RAROCDataSub=$g(^DHCTarC("TOC",TAROCTARTOCDR))
            if RAROCDataSub=""{
                //set ^TMPTAROC(TAROCRowId)="Rowid:"_TAROCRowId_",指向DHC_TarOC值为空"
                //w "DHC_TarOutpatCate,Rowid:"_TAROCRowId_",指向DHC_TarOC值为空",!
                s DataSrc="User.DHCTarOutpatCate"
                s DataID=TAROCRowId
                s ErrCode="CT0603"
                s ErrInfo="DHC_TarOutpatCate.TAROC_RowId:"_TAROCRowId_"的TAROC_TARTOC_DR:"_TAROCTARTOCDR_",指向DHC_TarOC值为空。"
                d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            }
        }
    }
    ;w !
    //4、验证DHC_TarEMCCate.TAREC_TARTEC_DR->DHC_TarEC
    //DHC_TarEMCCate,^DHCTarC("EC",{TAREC_RowId});  DHC_TarEC,^DHCTarC("TEC",{TARTEC_RowId})
    set TARECRowId = 0
    while ($o(^DHCTarC("EC",TARECRowId)))  {
        set TARECRowId = $o(^DHCTarC("EC",TARECRowId))
        set TARECData=$g(^DHCTarC("EC",TARECRowId))
        set TARECTARTECDR = $p(TARECData,"^",3) //指针
        set TARECDesc =$p(TARECData,"^",2) //描述
        //w "TARECRowId："_TARECRowId_",TAREC_TARTEC_DR："_TARECTARTECDR,!
        if TARECTARTECDR="" {
            //set ^TMPTAREC(TARECRowId)="Rowid:"_TARECRowId_",TAREC_TARTEC_DR值为空"
            //w "DHC_TarEMCCate,Rowid:"_TARECRowId_",TAREC_TARTEC_DR值为空",!
            s DataSrc="User.DHCTarEMCCate"
            s DataID=TARECRowId
            s ErrCode="CT0604"
            s ErrInfo="DHC_TarEMCCate.TAREC_RowId:"_TARECRowId_"的TAREC_TARTEC_DR值为空。"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
        }else{
            set RARECDataSub=$g(^DHCTarC("TEC",TARECTARTECDR))
            if RARECDataSub=""{
                //set ^TMPTAREC(TARECRowId)="Rowid:"_TARECRowId_",指向DHC_TarEC值为空"
                //w "DHC_TarEMCCate,Rowid:"_TARECRowId_",指向DHC_TarEC值为空",!
                s DataSrc="User.DHCTarEMCCate"
                s DataID=TARECRowId
                s ErrCode="CT0604"
                s ErrInfo="DHC_TarEMCCate.TAREC_RowId:"_TARECRowId_"的TAREC_TARTEC_DR:"_TARECTARTECDR_",指向DHC_TarEC值为空。"
                d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            }
        }
    }
    ;w !
    //5、验证DHC_TarMRCate.TARMC_TARTMC_DR->DHC_TarMC
    //DHC_TarMRCate,^DHCTarC("MC",{TARMC_RowId});  DHC_TarMC,^DHCTarC("TMC",{TARTMC_RowId})
    set TARMCRowId = 0
    while ($o(^DHCTarC("MC",TARMCRowId)))  {
        set TARMCRowId = $o(^DHCTarC("MC",TARMCRowId))
        set TARMCData=$g(^DHCTarC("MC",TARMCRowId))
        set TARMCTARTMCDR = $p(TARMCData,"^",3) //指针
        set TARMCDesc =$p(TARMCData,"^",2) //描述
        //w "TARMCRowId："_TARMCRowId_",TARMC_TARTMC_DR："_TARMCTARTMCDR,!
        if TARMCTARTMCDR="" {
            //set ^TMPTARMC(TARMCRowId)="Rowid:"_TARMCRowId_",TARMC_TARTMC_DR值为空"
            //w "DHC_TarMRCate,Rowid:"_TARMCRowId_",TARMC_TARTMC_DR值为空",!
            s DataSrc="User.DHCTarMRCate"
            s DataID=TARMCRowId
            s ErrCode="CT0605"
            s ErrInfo="DHC_TarMRCate.TARMC_RowId:"_TARMCRowId_"的TARMC_TARTMC_DR值为空。"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
        }else{
            set RARMCDataSub=$g(^DHCTarC("TMC",TARMCTARTMCDR))
            if RARMCDataSub=""{
                //set ^TMPTARMC(TARMCRowId)="Rowid:"_TARMCRowId_",指向DHC_TarMC值为空"
                //w "DHC_TarMRCate,Rowid:"_TARMCRowId_",指向DHC_TarMC值为空",!
                s DataSrc="User.DHCTarMRCate"
                s DataID=TARMCRowId
                s ErrCode="CT0605"
                s ErrInfo="DHC_TarMRCate.TARMC_RowId:"_TARMCRowId_"的TARMC_TARTMC_DR:"_TARMCTARTMCDR_",指向DHC_TarMC值为空。"
                d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            }
        }
    }
    ;w !
    //6、验证DHC_TarMCCateNew.TARMCCNew_TARTMC_DR->DHC_TarMCNew
    //DHC_TarMCCateNew,^DHCTarC("MCNew",{TARMCCNew_RowId});  DHC_TarMCNew,^DHCTarC("TMCNew",{TARTMCNew_RowId})
    set TARMCCNewRowId = 0
    while ($o(^DHCTarC("MCNew",TARMCCNewRowId)))  {
        set TARMCCNewRowId = $o(^DHCTarC("MCNew",TARMCCNewRowId))
        set TARMCCNewData=$g(^DHCTarC("MCNew",TARMCCNewRowId))
        set TARMCCNewTARTMCDR = $p(TARMCCNewData,"^",3) //指针
        set TARMCCNewDesc =$p(TARMCCNewData,"^",2) //描述
        //w "TARMCCNewRowId："_TARMCCNewRowId_",TARMCCNew_TARTMC_DR："_TARMCCNewTARTMCDR,!
        if TARMCCNewTARTMCDR="" {
            //set ^TMPTARMCCNew(TARMCCNewRowId)="Rowid:"_TARMCCNewRowId_",TARMCCNew_TARTMC_DR值为空"
            //w "DHC_TarMCCateNew,Rowid:"_TARMCCNewRowId_",TARMCCNew_TARTMC_DR值为空",!
            s DataSrc="User.DHCTarMCCateNew"
            s DataID=TARMCCNewRowId
            s ErrCode="CT0606"
            s ErrInfo="DHC_TarMCCateNew.TARMCCNew_RowId:"_TARMCCNewRowId_"的TARMCCNew_TARTMC_DR值为空。"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
        }else{
            set RARMCNewDataSub=$g(^DHCTarC("TMCNew",TARMCCNewTARTMCDR))
            if RARMCNewDataSub=""{
                //set ^TMPTARMCCNew(TARMCCNewRowId)="Rowid:"_TARMCCNewRowId_",指向DHC_TarMCNew值为空"
                //w "DHC_TarMCCateNew,Rowid:"_TARMCCNewRowId_",指向DHC_TarMCNew值为空",!
                s DataSrc="User.DHCTarMCCateNew"
                s DataID=TARMCCNewRowId
                s ErrCode="CT0606"
                s ErrInfo="DHC_TarMCCateNew.TARMCCNew_RowId:"_TARMCCNewRowId_"的TARMCCNew_TARTMC_DR:"_TARMCCNewTARTMCDR_",指向DHC_TarMCNew值为空。"
                d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            }
        }
    }
    ;w !
    //7、验证DHC_TarInpatCate.TARIC_TARTIC_DR->DHC_TarIC
    //DHC_TarInpatCate, ^DHCTarC("IC",{TARIC_RowId});  DHC_TarIC,^DHCTarC("TIC",{TARTIC_RowId})
    set TARICRowId = 0
    while ($o(^DHCTarC("IC",TARICRowId)))  {
        set TARICRowId = $o(^DHCTarC("IC",TARICRowId))
        set TARICData=$g(^DHCTarC("IC",TARICRowId))
        set TARICTARTICDR = $p(TARICData,"^",3) //指针
        set TARICDesc =$p(TARICData,"^",2) //描述
        //w "TARICRowId："_TARICRowId_",TARIC_TARTIC_DR："_TARICTARTICDR,!
        if TARICTARTICDR="" {
            //set ^TMPTARIC(TARICRowId)="Rowid:"_TARICRowId_",TARIC_TARTIC_DR值为空"
            //w "DHC_TarInpatCate,Rowid:"_TARICRowId_",TARIC_TARTIC_DR值为空",!
            s DataSrc="User.DHCTarInpatCate"
            s DataID=TARICRowId
            s ErrCode="CT0607"
            s ErrInfo="DHC_TarInpatCate.TARIC_RowId:"_TARICRowId_"的TARIC_TARTIC_DR值为空。"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
        }else{
            set RARICDataSub=$g(^DHCTarC("TIC",TARICTARTICDR))
            if RARICDataSub=""{
                //set ^TMPTARIC(TARICRowId)="Rowid:"_TARICRowId_",指向DHC_TarIC值为空"
                //w "DHC_TarInpatCate,Rowid:"_TARICRowId_",指向DHC_TarIC值为空",!
                s DataSrc="User.DHCTarInpatCate"
                s DataID=TARICRowId
                s ErrCode="CT0607"
                s ErrInfo="DHC_TarInpatCate.TARIC_RowId:"_TARICRowId_"的TARIC_TARTIC_DR:"_TARICTARTICDR_",指向DHC_TarIC值为空。"
                d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            }
        }
    }
    q ""
CheckTarItemAndCateErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"各项目子类大类是否正确异常:",$ze)
    q ""
}

/// Creator：      Lizhi------
/// CreatDate：    2022-05-09
/// Description：  核查是否存在预结算数据
/// 1.检查DHC_INVPRT中PRT_Flag为TP状态的数据
/// 2.非当日的，通过DHC_INVPRT.PRTDATE日期索引，校验当日以前的数据
/// 3.当日的DHC_INVPRT.PRTTIME，校验半小时以前的数据
/// Table：        DHC_INVPRT
/// input:         
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckTPINVPRT("1045")
ClassMethod CheckTPINVPRT(PRTRowid)
{
    s $zt="CheckTPINVPRTErr"
    s NowDate=$p($h,",",1) //当前日期
    s EndTime=$p($h,",",2)-1800 //当前时间半小时之前
    q:$g(^DHCINVPRT((PRTRowid)))="" "" ///数据为空的数据跳过
    s INVDate=$p(^DHCINVPRT((PRTRowid)),"^",5)
    if INVDate<NowDate d //非当天数据
    .if $p(^DHCINVPRT((PRTRowid)),"^",8)="TP" d  ///PRTFlag="TP",存在预结数据
    ..s DataSrc="User.DHCINVPRT"
    ..s DataID=PRTRowid
    ..s ErrInfo="DHC_INVPRT.PRT_Rowid:"_PRTRowid_"今日之前存在预结算状态的发票"
    ..s ErrCode="OPBILL0101"
    ..d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    else  d  //当天数据
    .q:$p(^DHCINVPRT((PRTRowid)),"^",20)>EndTime //过滤当前时间半小时之内的数据
    .if $p(^DHCINVPRT((PRTRowid)),"^",8)="TP" d  //PRTFlag="TP"
    ..s DataSrc="User.DHCINVPRT"
    ..s DataID=PRTRowid
    ..s ErrInfo="DHC_INVPRT.PRT_Rowid:"_PRTRowid_"今日存在预结算状态的发票"
    ..s ErrCode="OPBILL0102"
    ..d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    q ""
CheckTPINVPRTErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"核查是否存在预结算数据异常:",PRTRowid,$ze)
    q ""
}

/// Creator：      zjb
/// CreatDate：    2022-05-19
/// Description:门诊已经结算账单表是否平衡
/// 1.校验DHC_PatientBill的金额是否等于DHC_PatBillOrder的金额之和(总金额和自负金额)
/// 2.校验DHC_PatBillOrder的金额是否等于DHC_PatBillDetails的金额之和(总金额和自负金额)
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(BILL.DC.Check).CheckBillBalance()
ClassMethod CheckOPBillBalance(a = "")
{
    s $zt="CheckBillBalanceErr"
    s CheckMode = ^||TMPCheck("CheckMode") 
    s HospDr = ^||TMPCheck("HospDr")
    s StartDate=^||TMPCheck("StartDate") 
    s EndDate = ^||TMPCheck("EndDate")
    s StartTime = ^||TMPCheck("StartTime")  
    s EndTime = ^||TMPCheck("EndTime")
    
    f UpdateDate=StartDate:1:EndDate  
    {
        s BillRowid=0
        while $o(^DHCPB(0,"Date",UpdateDate,BillRowid))  
        {
            s BillRowid=$o(^DHCPB(0,"Date",UpdateDate,BillRowid))
            continue:BillRowid=""
            s Adm=$p(^DHCPB(BillRowid),"^",1)
            s AdmType=$p(^PAADM(Adm),"^",2)
            continue:(AdmType'="O")&&(AdmType'="E")
            s BillConINV=$o(^DHCBCI(0,"Bill",BillRowid,""),-1)
            continue:BillConINV=""
            set InvPrt=$p($g(^DHCBCI(BillConINV)),"^",1) //发票指针
            continue:InvPrt=""
            s INVFlag=..CheckNormalInv(InvPrt,"O")  
            continue:INVFlag'="N"
            
            set BillData=$g(^DHCPB(BillRowid))
            set PBTotalAmount=$fn(+$p(BillData,"^",8),"",2) //账单主表 本次计费的总额
            set PBPatientShare=$fn(+$p(BillData,"^",12),"",2) //账单主表 本次费用病人自付额
            set PBOTotalAmt=0 //病人医嘱费用明细表 病人医嘱总费用之和
            set PBOPatientAmt=0 //病人医嘱费用明细表 病人自费部分之和
            set PBOChildSub=0
            while ($o(^DHCPB(BillRowid,"O",PBOChildSub))) {
                //PBO相关校验开始
                
                //---
                set PBOChildSub=$o(^DHCPB(BillRowid,"O",PBOChildSub))
                set PBOData=$g(^DHCPB(BillRowid,"O",PBOChildSub))
                set PBOToTalAmount=$fn(+$p(PBOData,"^",8),"",2) //病人医嘱费用明细表 病人医嘱总费用
                set PBOPatientShare=$fn(+$p(PBOData,"^",11),"",2) //病人医嘱费用明细表 病人自费部分
                set PBOTotalAmt=PBOTotalAmt+PBOToTalAmount 
                set PBOPatientAmt=PBOPatientAmt+PBOPatientShare 
                set PBDChildSub=0
                set PBDTotalAmt=0 //账单收费项目明细表 发生总数之和
                set PBDPatientAmt=0 //账单收费项目明细表 病人自费数之和
                set DetailNum=1
                while ($o(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))) {
                    set PBDChildSub=$o(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))
                    set PBDData=$g(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))
                    set PBDTotalAmount=$fn(+$p(PBDData,"^",7),"",2) //账单收费项目明细表 发生总数
                    set PBDPatientShare=$fn(+$p(PBDData,"^",10),"",2) //账单收费项目明细表 病人自费数
                    set PBDPatientAmt=PBDPatientAmt+PBDPatientShare
                    set PBDTotalAmt=PBDTotalAmt+PBDTotalAmount
                    // PBD相关校验开始
                }
                if ($fn(+PBOPatientShare,"",2))'=($fn(+PBDPatientAmt,"",2)){
                    //s ^TMPOrderPatientAmt(BillRowid_"||"_PBOChildSub)="DHC_PatientBill.PB_RowId:"_BillRowid_"DHC_PatBillOrder.PBO_ChildSub:"_PBOChildSub_",错误代码：OPBILL0204，错误信息：账单医嘱表和账单明细表自负金额不平"
                    s DataSrc="User.DHCPatBillOrder"
                    s DataID=BillRowid_"||"_PBOChildSub
                    s ErrCode="OPBILL0204"
                    s ErrInfo="DHC_PatientBill.PB_RowId:"_BillRowid_",账单医嘱表自付金额："_PBOPatientShare_",账单明细表自付金额："_PBDPatientAmt_",账单医嘱表和账单明细表自负金额不平。"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
                }
                if ($fn(+PBOToTalAmount,"",2))'=($fn(+PBDTotalAmt,"",2)){
                    //s ^TMPOrderTotalAmt(BillRowid_"||"_PBOChildSub)="DHC_PatientBill.PB_RowId:"_BillRowid_"DHC_PatBillOrder.PBO_ChildSub:"_PBOChildSub_",错误代码：OPBILL0203，错误信息：账单医嘱表和账单明细表总金额不平"
                    s DataSrc="User.DHCPatBillOrder"
                    s DataID=BillRowid_"||"_PBOChildSub
                    s ErrCode="OPBILL0203"
                    s ErrInfo="DHC_PatientBill.PB_RowId:"_BillRowid_",账单医嘱表总金额："_PBOToTalAmount_",账单明细表总金额："_PBDTotalAmt_",账单医嘱表和账单明细表总金额不平。"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
                }
            }
            if ($fn(+PBTotalAmount,"",2))'=($fn(+PBOTotalAmt,"",2)) {
                //s ^TMPBillTotalAmt(BillRowid)=    "DHC_PatientBill.PB_RowId:"_BillRowid_",错误代码：OPBILL0201，错误信息：账单主表和账单医嘱表总金额不平"
                s DataSrc="User.DHCPatientBill"
                s DataID=BillRowid
                s ErrCode="OPBILL0201"
                s ErrInfo="DHC_PatientBill.PB_RowId:"_BillRowid_",账单主表总金额："_PBTotalAmount_",账单主表总金额："_PBOTotalAmt_",账单主表和账单医嘱表总金额不平。"
                d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            }
            if ($fn(+PBPatientShare,"",2))'=($fn(+PBOPatientAmt,"",2)) {
                //s ^TMPBillPatientAmt(BillRowid)="DHC_PatientBill.PB_RowId:"_BillRowid_",错误代码：OPBILL0202，错误信息：账单主表和账单医嘱表自负金额不平"
                s DataSrc="User.DHCPatientBill"
                s DataID=BillRowid
                s ErrCode="OPBILL0202"
                s ErrInfo="DHC_PatientBill.PB_RowId:"_BillRowid_",账单主表自付金额："_PBPatientShare_",账单主表自付金额："_PBOPatientAmt_",账单主表和账单医嘱表自付金额不平。"
                d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            }
        }       
    }
    q ""
CheckBillBalanceErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"门诊已经结算账单表是否平衡异常:",$ze)
    q ""
}

/// Creator：      zjb
/// CreatDate：    2022-05-19
/// Description:门诊未结算账单表是否平衡
/// 1.校验DHC_PatientBill的金额是否等于DHC_PatBillOrder的金额之和(总金额和自负金额)
/// 2.校验DHC_PatBillOrder的金额是否等于DHC_PatBillDetails的金额之和(总金额和自负金额)
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(BILL.DC.Check).CheckBillBalance()
ClassMethod CheckOPUnPayBalance(a = "")
{
    s $zt="CheckBillBalanceErr"
    s CheckMode = ^||TMPCheck("CheckMode") 
    s HospDr = ^||TMPCheck("HospDr")
    s StartDate=^||TMPCheck("StartDate") 
    s EndDate = ^||TMPCheck("EndDate")+1 //例：急诊跨天A账单日期是1号，核查程序是2号执行，查询默认是查询前一天（1号）的账单。核查程序2号执行前A账单发生费用，A账单日期变为2号，导致程序查询不到A账单。
    s StartTime = ^||TMPCheck("StartTime")  
    s EndTime = ^||TMPCheck("EndTime")
    
    f UpdateDate=StartDate:1:EndDate  
    {
        s BillRowid=0
        while $o(^DHCPB(0,"Date",UpdateDate,BillRowid))  
        {
            s BillRowid=$o(^DHCPB(0,"Date",UpdateDate,BillRowid))
            continue:BillRowid=""
            s Adm=$p(^DHCPB(BillRowid),"^",1)
            s AdmType=$p(^PAADM(Adm),"^",2)
            continue:(AdmType'="O")&&(AdmType'="E")
            //过滤门诊已经结算的
            s BillConINV=$o(^DHCBCI(0,"Bill",BillRowid,""),-1)
            if (BillConINV'=""){
                set InvPrt=$p($g(^DHCBCI(BillConINV)),"^",1) //发票指针
                if (InvPrt'=""){
                    s INVFlag=..CheckNormalInv(InvPrt,"O")  
                    continue:INVFlag="N"    
                }
                
            }
            
            set BillData=$g(^DHCPB(BillRowid))
            set PBTotalAmount=$fn(+$p(BillData,"^",8),"",2) //账单主表 本次计费的总额
            set PBPatientShare=$fn(+$p(BillData,"^",12),"",2) //账单主表 本次费用病人自付额
            set PBOTotalAmt=0 //病人医嘱费用明细表 病人医嘱总费用之和
            set PBOPatientAmt=0 //病人医嘱费用明细表 病人自费部分之和
            set PBOChildSub=0
            while ($o(^DHCPB(BillRowid,"O",PBOChildSub))) {
                //PBO相关校验开始
                
                //---
                set PBOChildSub=$o(^DHCPB(BillRowid,"O",PBOChildSub))
                set PBOData=$g(^DHCPB(BillRowid,"O",PBOChildSub))
                set PBOToTalAmount=$fn(+$p(PBOData,"^",8),"",2) //病人医嘱费用明细表 病人医嘱总费用
                set PBOPatientShare=$fn(+$p(PBOData,"^",11),"",2) //病人医嘱费用明细表 病人自费部分
                set PBOTotalAmt=PBOTotalAmt+PBOToTalAmount 
                set PBOPatientAmt=PBOPatientAmt+PBOPatientShare 
                set PBDChildSub=0
                set PBDTotalAmt=0 //账单收费项目明细表 发生总数之和
                set PBDPatientAmt=0 //账单收费项目明细表 病人自费数之和
                set DetailNum=1
                while ($o(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))) {
                    set PBDChildSub=$o(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))
                    set PBDData=$g(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))
                    set PBDTotalAmount=$fn(+$p(PBDData,"^",7),"",2) //账单收费项目明细表 发生总数
                    set PBDPatientShare=$fn(+$p(PBDData,"^",10),"",2) //账单收费项目明细表 病人自费数
                    set PBDPatientAmt=PBDPatientAmt+PBDPatientShare
                    set PBDTotalAmt=PBDTotalAmt+PBDTotalAmount
                    // PBD相关校验开始
                }
                if ($fn(+PBOPatientShare,"",2))'=($fn(+PBDPatientAmt,"",2)){
                    //s ^TMPOrderPatientAmt(BillRowid_"||"_PBOChildSub)="DHC_PatientBill.PB_RowId:"_BillRowid_"DHC_PatBillOrder.PBO_ChildSub:"_PBOChildSub_",错误代码：OPBILL0204，错误信息：账单医嘱表和账单明细表自负金额不平"
                    s DataSrc="User.DHCPatBillOrder"
                    s DataID=BillRowid_"||"_PBOChildSub
                    s ErrCode="OPBILL0204"
                    s ErrInfo="DHC_PatientBill.PB_RowId:"_BillRowid_",账单医嘱表自付金额："_PBOPatientShare_",账单明细表自付金额："_PBDPatientAmt_",账单医嘱表和账单明细表自负金额不平。"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
                }
                if ($fn(+PBOToTalAmount,"",2))'=($fn(+PBDTotalAmt,"",2)){
                    //s ^TMPOrderTotalAmt(BillRowid_"||"_PBOChildSub)="DHC_PatientBill.PB_RowId:"_BillRowid_"DHC_PatBillOrder.PBO_ChildSub:"_PBOChildSub_",错误代码：OPBILL0203，错误信息：账单医嘱表和账单明细表总金额不平"
                    s DataSrc="User.DHCPatBillOrder"
                    s DataID=BillRowid_"||"_PBOChildSub
                    s ErrCode="OPBILL0203"
                    s ErrInfo="DHC_PatientBill.PB_RowId:"_BillRowid_",账单医嘱表总金额："_PBOToTalAmount_",账单明细表总金额："_PBDTotalAmt_",账单医嘱表和账单明细表总金额不平。"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
                }
            }
            if ($fn(+PBTotalAmount,"",2))'=($fn(+PBOTotalAmt,"",2)) {
                //s ^TMPBillTotalAmt(BillRowid)=    "DHC_PatientBill.PB_RowId:"_BillRowid_",错误代码：OPBILL0201，错误信息：账单主表和账单医嘱表总金额不平"
                s DataSrc="User.DHCPatientBill"
                s DataID=BillRowid
                s ErrCode="OPBILL0201"
                s ErrInfo="DHC_PatientBill.PB_RowId:"_BillRowid_",账单主表总金额："_PBTotalAmount_",账单主表总金额："_PBOTotalAmt_",账单主表和账单医嘱表总金额不平。"
                d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            }
            if ($fn(+PBPatientShare,"",2))'=($fn(+PBOPatientAmt,"",2)) {
                //s ^TMPBillPatientAmt(BillRowid)="DHC_PatientBill.PB_RowId:"_BillRowid_",错误代码：OPBILL0202，错误信息：账单主表和账单医嘱表自负金额不平"
                s DataSrc="User.DHCPatientBill"
                s DataID=BillRowid
                s ErrCode="OPBILL0202"
                s ErrInfo="DHC_PatientBill.PB_RowId:"_BillRowid_",账单主表自付金额："_PBPatientShare_",账单主表自付金额："_PBOPatientAmt_",账单主表和账单医嘱表自付金额不平。"
                d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            }
        }       
    }
    q ""
CheckBillBalanceErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"门诊未结算账单表是否平衡异常:",$ze)
    q ""
}

/// Creator：      zjb
/// CreatDate：    2022-05-19
/// Description:住院未结算账单表是否平衡
/// 1.校验DHC_PatientBill的金额是否等于DHC_PatBillOrder的金额之和(总金额和自负金额)
/// 2.校验DHC_PatBillOrder的金额是否等于DHC_PatBillDetails的金额之和(总金额和自负金额)
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(BILL.DC.Check).CheckBillBalance()
ClassMethod CheckIPUnPayBalance(a = "")
{
    s $zt="CheckBillBalanceErr"
    s CheckMode = ^||TMPCheck("CheckMode") 
    s HospDr = ^||TMPCheck("HospDr")
    s StartDate=^||TMPCheck("StartDate") 
    s EndDate = ^||TMPCheck("EndDate")+1 //例：A账单日期是1号，核查程序是2号执行，查询默认是查询前一天（1号）的账单。核查程序2号执行前A账单发生费用，A账单日期变为2号，导致程序查询不到A账单。
    s StartTime = ^||TMPCheck("StartTime")  
    s EndTime = ^||TMPCheck("EndTime")
    
    f UpdateDate=StartDate:1:EndDate  
    {
        s BillRowid=0
        while $o(^DHCPB(0,"Date",UpdateDate,BillRowid))  
        {
            s BillRowid=$o(^DHCPB(0,"Date",UpdateDate,BillRowid))
            continue:BillRowid=""
            s Adm=$p(^DHCPB(BillRowid),"^",1)
            s AdmType=$p(^PAADM(Adm),"^",2)
            continue:AdmType'="I"
            s InvPrt=$o(^DHCINVPRTZY("0","AR",BillRowid,""),-1)
            if (InvPrt'=""){
                s INVFlag=..CheckNormalInv(InvPrt,"I")  
                continue:INVFlag="N"
            }
            set BillData=$g(^DHCPB(BillRowid))
            set PBTotalAmount=$fn(+$p(BillData,"^",8),"",2) //账单主表 本次计费的总额
            set PBPatientShare=$fn(+$p(BillData,"^",12),"",2) //账单主表 本次费用病人自付额
            set PBOTotalAmt=0 //病人医嘱费用明细表 病人医嘱总费用之和
            set PBOPatientAmt=0 //病人医嘱费用明细表 病人自费部分之和
            set PBOChildSub=0
            while ($o(^DHCPB(BillRowid,"O",PBOChildSub))) {
                //PBO相关校验开始
                
                //---
                set PBOChildSub=$o(^DHCPB(BillRowid,"O",PBOChildSub))
                set PBOData=$g(^DHCPB(BillRowid,"O",PBOChildSub))
                set PBOToTalAmount=$fn(+$p(PBOData,"^",8),"",2) //病人医嘱费用明细表 病人医嘱总费用
                set PBOPatientShare=$fn(+$p(PBOData,"^",11),"",2) //病人医嘱费用明细表 病人自费部分
                set PBOTotalAmt=PBOTotalAmt+PBOToTalAmount 
                set PBOPatientAmt=PBOPatientAmt+PBOPatientShare 
                set PBDChildSub=0
                set PBDTotalAmt=0 //账单收费项目明细表 发生总数之和
                set PBDPatientAmt=0 //账单收费项目明细表 病人自费数之和
                set DetailNum=1
                while ($o(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))) {
                    set PBDChildSub=$o(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))
                    set PBDData=$g(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))
                    set PBDTotalAmount=$fn(+$p(PBDData,"^",7),"",2) //账单收费项目明细表 发生总数
                    set PBDPatientShare=$fn(+$p(PBDData,"^",10),"",2) //账单收费项目明细表 病人自费数
                    set PBDPatientAmt=PBDPatientAmt+PBDPatientShare
                    set PBDTotalAmt=PBDTotalAmt+PBDTotalAmount
                    // PBD相关校验开始
                }
                if ($fn(+PBOPatientShare,"",2))'=($fn(+PBDPatientAmt,"",2)){
                    //s ^TMPOrderPatientAmt(BillRowid_"||"_PBOChildSub)="DHC_PatientBill.PB_RowId:"_BillRowid_"DHC_PatBillOrder.PBO_ChildSub:"_PBOChildSub_",错误代码：OPBILL0204，错误信息：账单医嘱表和账单明细表自负金额不平"
                    s DataSrc="User.DHCPatBillOrder"
                    s DataID=BillRowid_"||"_PBOChildSub
                    s ErrCode="OPBILL0204"
                    s ErrInfo="DHC_PatientBill.PB_RowId:"_BillRowid_",账单医嘱表自付金额："_PBOPatientShare_",账单明细表自付金额："_PBDPatientAmt_",账单医嘱表和账单明细表自负金额不平。"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
                }
                if ($fn(+PBOToTalAmount,"",2))'=($fn(+PBDTotalAmt,"",2)){
                    //s ^TMPOrderTotalAmt(BillRowid_"||"_PBOChildSub)="DHC_PatientBill.PB_RowId:"_BillRowid_"DHC_PatBillOrder.PBO_ChildSub:"_PBOChildSub_",错误代码：OPBILL0203，错误信息：账单医嘱表和账单明细表总金额不平"
                    s DataSrc="User.DHCPatBillOrder"
                    s DataID=BillRowid_"||"_PBOChildSub
                    s ErrCode="OPBILL0203"
                    s ErrInfo="DHC_PatientBill.PB_RowId:"_BillRowid_",账单医嘱表总金额："_PBOToTalAmount_",账单明细表总金额："_PBDTotalAmt_",账单医嘱表和账单明细表总金额不平。"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
                }
            }
            if ($fn(+PBTotalAmount,"",2))'=($fn(+PBOTotalAmt,"",2)) {
                //s ^TMPBillTotalAmt(BillRowid)=    "DHC_PatientBill.PB_RowId:"_BillRowid_",错误代码：OPBILL0201，错误信息：账单主表和账单医嘱表总金额不平"
                s DataSrc="User.DHCPatientBill"
                s DataID=BillRowid
                s ErrCode="OPBILL0201"
                s ErrInfo="DHC_PatientBill.PB_RowId:"_BillRowid_",账单主表总金额："_PBTotalAmount_",账单主表总金额："_PBOTotalAmt_",账单主表和账单医嘱表总金额不平。"
                d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            }
            if ($fn(+PBPatientShare,"",2))'=($fn(+PBOPatientAmt,"",2)) {
                //s ^TMPBillPatientAmt(BillRowid)="DHC_PatientBill.PB_RowId:"_BillRowid_",错误代码：OPBILL0202，错误信息：账单主表和账单医嘱表自负金额不平"
                s DataSrc="User.DHCPatientBill"
                s DataID=BillRowid
                s ErrCode="OPBILL0202"
                s ErrInfo="DHC_PatientBill.PB_RowId:"_BillRowid_",账单主表自付金额："_PBPatientShare_",账单主表自付金额："_PBOPatientAmt_",账单主表和账单医嘱表自付金额不平。"
                d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            }
        }       
    }
    q ""
CheckBillBalanceErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"住院未结算账单表是否平衡异常:",$ze)
    q ""
}

/// Creator：      zjb
/// CreatDate：    2022-05-19
/// Description:住院已经结算账单表是否平衡
/// 1.校验DHC_PatientBill的金额是否等于DHC_PatBillOrder的金额之和(总金额和自负金额)
/// 2.校验DHC_PatBillOrder的金额是否等于DHC_PatBillDetails的金额之和(总金额和自负金额)
/// Table：        
/// input:         
/// Output：       
/// Debug：       d ##class(BILL.DC.Check).CheckBillBalance()
ClassMethod CheckIPBillBalance(a = "")
{
    s $zt="CheckBillBalanceErr"
    s CheckMode = ^||TMPCheck("CheckMode") 
    s HospDr = ^||TMPCheck("HospDr")
    s StartDate=^||TMPCheck("StartDate") 
    s EndDate = ^||TMPCheck("EndDate")
    s StartTime = ^||TMPCheck("StartTime")  
    s EndTime = ^||TMPCheck("EndTime")
    
    f UpdateDate=StartDate:1:EndDate  
    {
        s BillRowid=0
        while $o(^DHCPB(0,"Date",UpdateDate,BillRowid))  
        {
            s BillRowid=$o(^DHCPB(0,"Date",UpdateDate,BillRowid))
            continue:BillRowid=""
            s Adm=$p(^DHCPB(BillRowid),"^",1)
            s AdmType=$p(^PAADM(Adm),"^",2)
            continue:AdmType'="I"
            s InvPrt=$o(^DHCINVPRTZY("0","AR",BillRowid,""),-1)
            continue:InvPrt=""
            s INVFlag=..CheckNormalInv(InvPrt,"I")  
            continue:INVFlag'="N"
            
            
            set BillData=$g(^DHCPB(BillRowid))
            set PBTotalAmount=$fn(+$p(BillData,"^",8),"",2) //账单主表 本次计费的总额
            set PBPatientShare=$fn(+$p(BillData,"^",12),"",2) //账单主表 本次费用病人自付额
            set PBOTotalAmt=0 //病人医嘱费用明细表 病人医嘱总费用之和
            set PBOPatientAmt=0 //病人医嘱费用明细表 病人自费部分之和
            set PBOChildSub=0
            while ($o(^DHCPB(BillRowid,"O",PBOChildSub))) {
                //PBO相关校验开始
                
                //---
                set PBOChildSub=$o(^DHCPB(BillRowid,"O",PBOChildSub))
                set PBOData=$g(^DHCPB(BillRowid,"O",PBOChildSub))
                set PBOToTalAmount=$fn(+$p(PBOData,"^",8),"",2) //病人医嘱费用明细表 病人医嘱总费用
                set PBOPatientShare=$fn(+$p(PBOData,"^",11),"",2) //病人医嘱费用明细表 病人自费部分
                set PBOTotalAmt=PBOTotalAmt+PBOToTalAmount 
                set PBOPatientAmt=PBOPatientAmt+PBOPatientShare 
                set PBDChildSub=0
                set PBDTotalAmt=0 //账单收费项目明细表 发生总数之和
                set PBDPatientAmt=0 //账单收费项目明细表 病人自费数之和
                set DetailNum=1
                while ($o(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))) {
                    set PBDChildSub=$o(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))
                    set PBDData=$g(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))
                    set PBDTotalAmount=$fn(+$p(PBDData,"^",7),"",2) //账单收费项目明细表 发生总数
                    set PBDPatientShare=$fn(+$p(PBDData,"^",10),"",2) //账单收费项目明细表 病人自费数
                    set PBDPatientAmt=PBDPatientAmt+PBDPatientShare
                    set PBDTotalAmt=PBDTotalAmt+PBDTotalAmount
                    // PBD相关校验开始
                }
                if ($fn(+PBOPatientShare,"",2))'=($fn(+PBDPatientAmt,"",2)){
                    //s ^TMPOrderPatientAmt(BillRowid_"||"_PBOChildSub)="DHC_PatientBill.PB_RowId:"_BillRowid_"DHC_PatBillOrder.PBO_ChildSub:"_PBOChildSub_",错误代码：OPBILL0204，错误信息：账单医嘱表和账单明细表自负金额不平"
                    s DataSrc="User.DHCPatBillOrder"
                    s DataID=BillRowid_"||"_PBOChildSub
                    s ErrCode="OPBILL0204"
                    s ErrInfo="DHC_PatientBill.PB_RowId:"_BillRowid_",账单医嘱表自付金额："_PBOPatientShare_",账单明细表自付金额："_PBDPatientAmt_",账单医嘱表和账单明细表自负金额不平。"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
                }
                if ($fn(+PBOToTalAmount,"",2))'=($fn(+PBDTotalAmt,"",2)){
                    //s ^TMPOrderTotalAmt(BillRowid_"||"_PBOChildSub)="DHC_PatientBill.PB_RowId:"_BillRowid_"DHC_PatBillOrder.PBO_ChildSub:"_PBOChildSub_",错误代码：OPBILL0203，错误信息：账单医嘱表和账单明细表总金额不平"
                    s DataSrc="User.DHCPatBillOrder"
                    s DataID=BillRowid_"||"_PBOChildSub
                    s ErrCode="OPBILL0203"
                    s ErrInfo="DHC_PatientBill.PB_RowId:"_BillRowid_",账单医嘱表总金额："_PBOToTalAmount_",账单明细表总金额："_PBDTotalAmt_",账单医嘱表和账单明细表总金额不平。"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
                }
            }
            if ($fn(+PBTotalAmount,"",2))'=($fn(+PBOTotalAmt,"",2)) {
                //s ^TMPBillTotalAmt(BillRowid)=    "DHC_PatientBill.PB_RowId:"_BillRowid_",错误代码：OPBILL0201，错误信息：账单主表和账单医嘱表总金额不平"
                s DataSrc="User.DHCPatientBill"
                s DataID=BillRowid
                s ErrCode="OPBILL0201"
                s ErrInfo="DHC_PatientBill.PB_RowId:"_BillRowid_",账单主表总金额："_PBTotalAmount_",账单主表总金额："_PBOTotalAmt_",账单主表和账单医嘱表总金额不平。"
                d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            }
            if ($fn(+PBPatientShare,"",2))'=($fn(+PBOPatientAmt,"",2)) {
                //s ^TMPBillPatientAmt(BillRowid)="DHC_PatientBill.PB_RowId:"_BillRowid_",错误代码：OPBILL0202，错误信息：账单主表和账单医嘱表自负金额不平"
                s DataSrc="User.DHCPatientBill"
                s DataID=BillRowid
                s ErrCode="OPBILL0202"
                s ErrInfo="DHC_PatientBill.PB_RowId:"_BillRowid_",账单主表自付金额："_PBPatientShare_",账单主表自付金额："_PBOPatientAmt_",账单主表和账单医嘱表自付金额不平。"
                d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            }
        }       
    }
    q ""
CheckBillBalanceErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"住院未结算账单表是否平衡异常:",$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-10
/// Description：  账单明细单价是否为零
/// 1.校验DHC_PatBillDetails.PBD_UnitPrice是否为0
/// 2.如果为0校验对应的收费项是否在表中DC_UnAuditItm，如果不在配置表中 则记录异常
/// 3.指定日期段的账单信息，通过日期索引
/// Table：        DHC_PatBillDetails、DC_UnAuditItm
/// input:         
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckPBDetailsUnitPrice("")
ClassMethod CheckPBDetailsUnitPrice(PBRowId, PBOChildSub, PBDChildSub)
{
    s $zt="CheckPBDetailsUnitPriceErr"
    q:(+PBRowId=0)||(+PBOChildSub=0)||(+PBDChildSub=0) ""
    q:$g(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub))="" ""
    ;q:$p(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub),"^",14)="R" "" //过滤已经退费的账单
    s PBOOEORIDR=$p(^DHCPB(PBRowId,"O",PBOChildSub),"^",4)
    s OEORDStatus=($p(^OEORD($p(PBOOEORIDR,"||",1),"I",$p(PBOOEORIDR,"||",2),1),"^",13))
    s statCode=$p($g(^OEC("OSTAT",+OEORDStatus)),"^",1)
    q:(statCode'="V")&&(statCode'="E") ""  //过滤已经停止和作废的医嘱
    s IndicatorId=^||TMPCheck("BusinessCode")_"||"_^||TMPCheck("IndicatorCode")
    s OEORIItmMastDR=$p(^OEORD($p(PBOOEORIDR,"||",1),"I",$p(PBOOEORIDR,"||",2),1),"^",2)
    q:##class(BILL.DC.BL.UnAuditItmCtl).CheckUnAuditItm(^||TMPCheck("HospDr"),IndicatorId,"ArcItm",OEORIItmMastDR)="Y" ""
    if $p(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub),"^",4)="0" d  //金额为0
    .s IndicatorId=^||TMPCheck("BusinessCode")_"||"_^||TMPCheck("IndicatorCode")
    .s ConfigValue=$p(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub),"^",3) //收费项id
    .s ischeck=##class(BILL.DC.BL.UnAuditItmCtl).CheckUnAuditItm(^||TMPCheck("HospDr"),IndicatorId,"TarItem",ConfigValue) //检查是否在表
    .if ischeck'="Y" d
    ..s DataSrc="User.DHCPatBillDetails"
    ..s DataID=PBRowId_"||"_PBOChildSub_"||"_PBDChildSub
    ..s ErrInfo="DHC_PatBillDetails.PBRowId:"_PBRowId_"PBOChildSub:"_PBOChildSub_"PBDChildSub:"_PBDChildSub_"收费项目金额为0"
    ..s ErrCode="OPBILL0301"
    ..d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    q ""
CheckPBDetailsUnitPriceErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"账单明细单价是否为零异常:",PBRowId_"||"_PBOChildSub_"||"_PBDChildSub,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-10
/// Description：  账单明细数量是否为零
/// Table：        DHC_PatBillDetails
/// input:         StartDate、EndDate
/// Output：       ^CheckPBDetails(ind)
/// Debug：        d ##class(BILL.DC.Check).CheckPBDetailsUnit("2021-01-01","2021-01-15")
ClassMethod CheckPBDetailsUnit(PBRowId, PBOChildSub, PBDChildSub)
{
    s $zt="CheckPBDetailsUnitErr"
    q:(+PBRowId=0)||(+PBOChildSub=0)||(+PBDChildSub=0) ""
    q:$g(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub))="" ""
    q:$p(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub),"^",14)="R" "" //过滤已经退费的账单
    s PBOOEORIDR=$p(^DHCPB(PBRowId,"O",PBOChildSub),"^",4)
    s OEORDStatus=($p(^OEORD($p(PBOOEORIDR,"||",1),"I",$p(PBOOEORIDR,"||",2),1),"^",13))
    s statCode=$p($g(^OEC("OSTAT",+OEORDStatus)),"^",1)
    q:(statCode'="V")&&(statCode'="E") ""  //过滤已经停止和作废的医嘱
    s OECPriorityFlag=..ReadOECPriorityFlag($p(PBOOEORIDR,"||",1)_"||"_$p(PBOOEORIDR,"||",2))  //判断是否是自备药
    q:(+OECPriorityFlag=1) ""
    s OrdIsOPToIP=..OrdIsOPToIPByOEORI($p(PBOOEORIDR,"||",1)_"||"_$p(PBOOEORIDR,"||",2)) //判断医嘱是否是急诊转入住院的医嘱
    s AdmDR=$p(^OEORD($p(PBOOEORIDR,"||",1)),"^",1)
    q:(+OrdIsOPToIP=1)&&($p(^PAADM(AdmDR),"^",2)'="I") ""
    q:$p(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub),"^",4)="0" "" //过滤单价为0
    q:($p(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub),"^",14)'="B")&&($p(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub),"^",14)'="P") ""
    if $p(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub),"^",5)="0" d  //PBD_UnitPrice="0" 数量为0
    .s DataSrc="User.DHCPatBillDetails"
    .s DataID=PBRowId_"||"_PBOChildSub_"||"_PBDChildSub
    .s ErrInfo="DHC_PatBillDetails.PBRowId:"_PBRowId_"PBOChildSub:"_PBOChildSub_"PBDChildSub:"_PBDChildSub_"收费项目数量为0"
    .s ErrCode="OPBILL0401"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    q ""
CheckPBDetailsUnitErr
    s $zt=""    
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"账单明细数量是否为零异常:",PBRowId_"||"_PBOChildSub_"||"_PBDChildSub,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/05/10
/// Description:门诊发票表与账单表是否平衡
/// 1.DHC_INVPRT的总金额是否和DHC_PatientBill的总金额是否相等
/// 2.DHC_INVPRT的自负金额是否和DHC_PatientBill的自负金额是否相等
/// 3.DHC_INVPRT->DHC_BillConINV->DHC_PatientBill
/// 4.指定日期段
/// Input:
/// Output:
/// Debug: do ##class(BILL.DC.Check).CheckInvPrtAndBillByAmt(2019-01-01, 2019-01-31)
ClassMethod CheckOPInvPrtAndBillByAmt(InvRowid)
{
    s $zt="CheckOPInvPrtAndBillByAmtErr"
    set InvData=^DHCINVPRT(InvRowid)
    set PRTAcount=$p(InvData,"^",1) //发票总金额
    set PRTPatientShare=$p(InvData,"^",16) //发票患者自费金额
    set BillTotalAmt=0 //账单主表 本次计费的总额之和
    set PBPatientShare=0 //账单主表 本次费用病人自付额之和
    set BillConRowid=""
    for  set BillConRowid=$o(^DHCBCI(0,"INV",InvRowid,BillConRowid)) q:BillConRowid=""  d
    .q:$g(^DHCBCI(BillConRowid))="" //数据为空
    .set DHCBCIPatBillDR = $p(^DHCBCI(BillConRowid),"^",2)
    .set BillData=$g(^DHCPB(DHCBCIPatBillDR))
    .q:BillData=""
    .set BillTotalAmtSub=$p(BillData,"^",8) //账单主表 本次计费的总额
    .set BillTotalAmt=BillTotalAmt+BillTotalAmtSub
    .set PBPatientShareSub=$p(BillData,"^",12) //账单主表 本次费用病人自付额
    .set PBPatientShare=PBPatientShare+PBPatientShareSub
    if PRTAcount'=BillTotalAmt do
    .s DataSrc="User.DHCINVPRT"
    .s DataID=InvRowid
    .s ErrCode="OPBILL0501"
    .s ErrInfo="DHC_INVPRT.PRT_Rowid:"_InvRowid_"，门诊发票总金额："_PRTAcount_",账单总金额："_BillTotalAmt_"，门诊发票和账单的总金额不平。"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
    if PRTPatientShare'=PBPatientShare do
    .s DataSrc="User.DHCINVPRT"
    .s DataID=InvRowid
    .s ErrCode="OPBILL0502"
    .s ErrInfo="DHC_INVPRT.PRT_Rowid:"_InvRowid_"，门诊发票自付金额："_PRTPatientShare_",账单自付金额："_PBPatientShare_"，门诊发票和账单的自付金额不平。"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)  
    q ""
CheckOPInvPrtAndBillByAmtErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"门诊发票表与账单表是否平衡异常:",InvRowid,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/05/10
/// Description:门诊发票表与支付方式表是否平衡
/// 1.DHC_INVPRT的自负金额+DHC_INVPRT.PRT_OPCRoundErr(分币误差)是否等于各发票支付方式DHC_INVPayMode相加
/// 2.对应的DHC_INVPayMode->CT_PayMode支付方式是否存在
/// 3.指定日期范围内校验
/// Input:
/// Output:
/// Debug: do ##class(BILL.DC.Check).CheckOPInvAmtAndPayModeByShareAmt(20)
ClassMethod CheckOPInvAmtAndPayModeByShareAmt(rowid)
{
    s $zt="CheckOPInvAmtAndPayModeByShareAmtErr"
    //^DHCINVPRT({PRT_Rowid})
    //^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"P",{IPM_Sub})
    //^CT("CTPM",{CTPM_RowId})
    set InvData=^DHCINVPRT(rowid)
    q:InvData="" ""
    set PRTFlag=$p(InvData,"^",8) //发票状态
    q:PRTFlag="TP" ""
    set PRTPatientShare=$fn($p(InvData,"^",16),"",2) //发票患者自费金额
    set PRTOPCRoundErr=$fn($p(InvData,"^",37),"",2) //分币误差
    set CheckShareAmt=PRTPatientShare+PRTOPCRoundErr //算发票表需要对比自费金额
    set IPMTotalAmt=0 //支付方式表金额总和
    set IPMSub=0
    for  set IPMSub=$o(^DHCINVPRT(rowid,"P",IPMSub)) quit:(IPMSub="")  do
    .set IPMData=^DHCINVPRT(rowid,"P",IPMSub)
    .set IPMAmt=$fn($p(IPMData,"^",3),"",2) //支付方式表金额
    .set IPMPayModeDR =$p(IPMData,"^",1) //支付方式
    .if IPMPayModeDR="" d
    ..s DataSrc="User.DHCINVPayMode"
    ..s DataID=rowid_"||"_IPMSub
    ..s ErrCode="OPBILL0601"
    ..s ErrInfo="DHC_INVPayMode.IPM_RowID:"_rowid_"||"_IPMSub_",的IPM_PayMode_DR的值为空。"
    ..d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
    .else  d 
    ..set CTPMData=$g(^CT("CTPM",IPMPayModeDR))
    ..if CTPMData=""  do
    ...s DataSrc="User.DHCINVPayMode"
    ...s DataID=rowid_"||"_IPMSub
    ...s ErrCode="OPBILL0601"
    ...s ErrInfo="DHC_INVPayMode.IPM_RowID:"_rowid_"||"_IPMSub_",的IPM_PayMode_DR:"_IPMPayModeDR_"->CT_PayMode支付方式不存在。"
    ...d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
    .set IPMTotalAmt=IPMTotalAmt+IPMAmt
    if CheckShareAmt'=IPMTotalAmt  d
    .s DataSrc="User.DHCINVPRT"
    .s DataID=rowid
    .s ErrCode="OPBILL0601"
    .s ErrInfo="DHC_INVPRT.PRT_Rowid:"_rowid_",发票表自付金额+分币误差："_CheckShareAmt_"，各发票支付方式相加金额："_IPMTotalAmt_"，门诊发票自付金额与支付方式表金额不平。"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
    q ""
CheckOPInvAmtAndPayModeByShareAmtErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"门诊发票表与支付方式表是否平衡异常:",rowid,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-09
/// Description：  门诊发票对应的医嘱的计费状态是否正确
/// 1.DHC_INVPRT对应医嘱的OE_OrdItem.OEORI_Billed字段是否为P(收费)
/// 2.DHC_INVPRT->DHC_BillConInv->DHC_PatBillOrder->OE_OrdItem
/// 3.正常发票PRT_Flag="N"
/// Table：        DHC_INVPRT
/// input:         
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckINVOEORIBilled("1045")
ClassMethod CheckINVOEORIBilled(PRTRowid)
{
    s $zt="CheckINVOEORIBilledErr"
    q:$g(^DHCINVPRT((PRTRowid)))="" "" ///数据为空的数据跳过
    if ..CheckNormalInv(PRTRowid,"O")="N" d
    .s DHCBCIRow="0"
    .f  s DHCBCIRow=$o(^DHCBCI(0,"INV",PRTRowid,DHCBCIRow)) q:DHCBCIRow=""  d //通过发票rowid查询DHC_BillConInv表
    ..s DHCBCIPBRow=$p(^DHCBCI(DHCBCIRow),"^",2)  //指向DHCPatientBillRowid
    ..s PBOChildSub="0"
    ..f  s PBOChildSub=$o(^DHCPB(DHCBCIPBRow,"O",PBOChildSub)) q:PBOChildSub=""  d //查询DHC_PatBillOrder表
    ...q:$g(^DHCPB(DHCBCIPBRow,"O",PBOChildSub))="" //过滤数据为空的数据
    ...s OEORDRowId=$p($p(^DHCPB(DHCBCIPBRow,"O",PBOChildSub),"^",4),"||",1) 
    ...s OEORDChildRow=$p($p(^DHCPB(DHCBCIPBRow,"O",PBOChildSub),"^",4),"||",2) 
    ...s OEORDStatus=($p(^OEORD(OEORDRowId,"I",OEORDChildRow,1),"^",13))
    ...s statCode=$p($g(^OEC("OSTAT",+OEORDStatus)),"^",1)
    ...q:(statCode'="V")&&(statCode'="E") //过滤停止或作废的医嘱
    ...s OEORDFlag=$p(^OEORD(OEORDRowId,"I",OEORDChildRow,3),"^",5) //医嘱计费状态
    ...if (OEORDFlag="B")||(OEORDFlag="TB") d 
    ....s DataSrc="User.DHCINVPRT"
    ....s DataID=PRTRowid
    ....s ErrInfo="门诊发票DHC_INVPRT.PRTRowid:"_PRTRowid_"状态为N,医嘱OE_Order.OEORD_RowId:"_OEORDRowId_"OEORI_Childsub:"_OEORDChildRow_"计费状态为"_OEORDFlag_"门诊发票上存在未收费的医嘱"
    ....s ErrCode="OPBILL0701"
    ....d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    q ""
CheckINVOEORIBilledErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"门诊发票对应的医嘱的计费状态是否正确异常:",PRTRowid,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/05/19
/// Description:门诊医嘱是否重复计费
/// 1.DHC_INVPRT对应医嘱的OE_OrdItem是否有多条已收费的DHC_PatBillOrder记录。如果有多条DHC_PatBillOrder，根据OE_OrdItem反查其是否在同一个账单内或者不同正常发票内，如果在同一个账单或者不同正常发票内则属于重复计费数据。如果反查结果只有一条DHC_PatBillOrder则退出本次循环不需要下一步校验
/// 2.DHC_INVPRT->DHC_BillConInv->DHC_PatBillOrder->OE_OrdItem,然后根据OE_OrdItem反查->DHC_PatBillOrder->DHC_BillConInv->DHC_INVPRT
/// 3.指定日期段
/// 4.正常发票PRT_Flag="N"
/// Input:
/// Output:
/// Debug: do ##class(BILL.DC.Check).CheckOPOrderRepeatBill(7630)
ClassMethod CheckOPOrderRepeatBill(PRTRowid)
{
    s $zt="CheckOPOrderRepeatBillErr"
    if (PRTRowid="") quit ""
    
    set PRTFlag=$p($g(^DHCINVPRT(PRTRowid)),"^",8) //发票状态
    quit:..CheckNormalInv(PRTRowid,"O")'="N" ""
    set DHCBCIRowid=$o(^DHCBCI(0,"INV",PRTRowid,""))
    set PBRowid=$p(^DHCBCI(DHCBCIRowid),"^",2) //账单主表DHC_PatientBill.PB_RowId
    set PBOChildSub=0
    for
    {
        set PBOChildSub=$o(^DHCPB(PBRowid,"O",PBOChildSub))
        quit:PBOChildSub=""
        set PBOData=$g(^DHCPB(PBRowid,"O",PBOChildSub))
        set PBORowid=PBRowid_"||"_PBOChildSub
        
        quit:PBOData=""
        set PBOOEORIDR=$p(PBOData,"^",4) //病人医嘱指针OE_OrdItem
        s OEORDStatus=($p(^OEORD($p(PBOOEORIDR,"||",1),"I",$p(PBOOEORIDR,"||",2),1),"^",13))
        s statCode=$p($g(^OEC("OSTAT",+OEORDStatus)),"^",1)
        continue:(statCode'="V")&&(statCode'="E")  //过滤已经停止和作废的医嘱
        quit:PBOOEORIDR=""
        set NewPBRowid=0
        set NewInvNum=0
        while ($o(^DHCPBi(0,"OEORI",PBOOEORIDR,NewPBRowid)))
        {
            //反查新账单rowid
            set NewPBRowid=$o(^DHCPBi(0,"OEORI",PBOOEORIDR,NewPBRowid))
            //set NewPatBillData=^DHCPB(NewPBRowid)
            if NewPBRowid'=PBRowid
            {
                set DHCBCIRowid=$o(^DHCBCI(0,"Bill",NewPBRowid,0))
                continue:DHCBCIRowid=""
                set DHCBCIData=$g(^DHCBCI(DHCBCIRowid))
                set DHCBCIINVDR=$p(DHCBCIData,"^",1) //发票指针
                set NewInvData=$g(^DHCINVPRT(DHCBCIINVDR))
                continue:NewInvData=""
                set NewInvFlag=..CheckNormalInv(DHCBCIINVDR,"O") //$p(NewInvData,"^",8) //发票状态
               
                if NewInvFlag="N"
                {
                    set OldDHCBCIRowid=$o(^DHCBCI(0,"Bill",PBRowid,0))  
                    continue:OldDHCBCIRowid=""
                    set OldDHCBCIINVDR=$p($g(^DHCBCI(OldDHCBCIRowid)),"^",1) //发票指针
                    //s OldPRTinv=$p($g(^DHCINVPRT(OldDHCBCIINVDR)),"^",14) //PBRowid对应的发票号
                    
                    //s NewPRTinv=$p(NewInvData,"^",14) //反查重复正常发票号
                    
                    s DataSrc="User.DHCINVPRT"
                    s DataID=PRTRowid
                    s ErrCode="OPBILL0801"
                    s ErrInfo="DHC_PatientBill.PB_RowId:"_NewPBRowid_",OE_OrdItem.OEORI_RowId:"_PBOOEORIDR_"，INVRowid："_OldDHCBCIINVDR_"跟"_DHCBCIINVDR_"，医嘱重复计费,同一医嘱存在多张不同正常发票。"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
                    //w "医嘱重复计费,多张不通正常发票,医嘱PBOOEORIDR："_PBOOEORIDR,!
                }
            }
            //同一账单多个多个医嘱的情况
            else
            {
                //^DHCPB({DHC_PatientBill.PB_RowId},"O",{PBO_ChildSub})
                set NewPBOChildSub=0
                set OrderNum=0
                for
                {
                    s NewPBOChildSub=$o(^DHCPBi(0,"OEORI",PBOOEORIDR,PBRowid,NewPBOChildSub))
                    quit:NewPBOChildSub=""
                    //w "NewPBOChildSub:"_NewPBOChildSub_",PBO_OEORI_DR:"_$p(^DHCPB(PBRowid,"O",NewPBOChildSub),"^",4),!
                
                    s OrderNum=OrderNum+1
                    if OrderNum>1
                    {
                        s DataSrc="User.DHCPatBillOrder"
                        s DataID=PBRowid_"||"_NewPBOChildSub
                        s ErrCode="OPBILL0801"
                        s ErrInfo="DHC_PatBillOrder.Rowid:"_PBRowid_"||"_NewPBOChildSub_"，PBO_OEORI_DR:"_PBOOEORIDR_"，医嘱重复计费,同一账单存在重复医嘱。"
                        d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
                        //w "同一账单存在重复医嘱,PBRowid:"_PBRowid,!
                    }
                }
                
            }
        }
    }
    q ""
CheckOPOrderRepeatBillErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"门诊医嘱是否重复计费异常:",PRTRowid,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-11
/// Description：  核查第三方支付是否成功
/// 1.DHC_INVPRT->DHC_INVPayMode,然后根据支付方式校验是否调用第三方接口##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(4)
/// 2.如果需要调用第三方接口DHC_INVPRT->DHC_BillExtTradeConSub->DHC_BillExtTradePay.ETP_Rc是否成功，是否和发票状态对应
/// 3.校验DHC_INVPayMode.IPM_ETP_DR->DHC_BillExtTradePay是否存在
/// 4.指定日期段
/// Table：        DHC_INVPRT、DHCBillConINV
/// input:         
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckINVPRTThirdPay()
ClassMethod CheckINVPRTThirdPay(PRTRowid)
{
    s $zt="CheckINVPRTThirdPayErr"
    s IPMSub="0"
    for
    {
        s IPMSub=$o(^DHCINVPRT(PRTRowid,"P",IPMSub))
        q:IPMSub=""  //退出循环
        if ($g(^DHCINVPRT(PRTRowid,"P",IPMSub))="") //数据为空跳过
        {
            continue
        }
        s IPMPayModeDR=$p(^DHCINVPRT(PRTRowid,"P",IPMSub),"^",1) //支付方式id
        s PayModeStr=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(IPMPayModeDR) //支付方式扩展表字段(调用标志、调用方法、调用方式、退费标志)
        if ($p(PayModeStr,"^",1)>0)
        {
            ///校验发票对应的第三方交易信息
            s ETCTradeType="OP" 
            s ETPRowID=$o(^DHCBILLETPi(0,"TTypePRT",ETCTradeType,"PRT",PRTRowid,""),-1)
            if ((ETPRowID="") || ($g(^DHCBILLETP(ETPRowID))="")) //发票找不到对应的第三方交易信息
            {
                s DataSrc="User.DHCINVPRT"
                s DataID=PRTRowid
                s ErrInfo="发票表DHC_INVPRT.PRTRowid:"_PRTRowid_"第三方交易表DHC_BillExtTradePay.ETP_RowID:"_ETPRowID_"发票找不到对应的第三方交易信息"
                s ErrCode="OPBILL1101"
                d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
            }
            else 
            {
                s ETPRc=$p(^DHCBILLETP(ETPRowID),"^",1)  //第三方交易表的状态 00 表示成功，非00表示失败
                s PRTFlag=..CheckNormalInv(PRTRowid,"O") //$p(^DHCINVPRT(PRTRowid),"^",8) // N 表示成功 非N 表示失败
                s Type=$p(^DHCBILLETP(ETPRowID),"^",26) //,C:支付,D:退费,T:退货,B:批量退货
                i ((PRTFlag="N")&&(ETPRc'="00")){
                    
                    s DataSrc="User.DHCINVPRT"
                    s DataID=PRTRowid
                    s ErrInfo="发票表DHC_INVPRT.PRTRowid:"_PRTRowid_"交易状态:"_PRTFlag_",第三方交易表DHC_BillExtTradePay.ETP_RowID:"_ETPRowID_"交易状态:"_ETPRc_"Type"_Type_"发票状态与第三方交易表的状态不一致"
                    s ErrCode="OPBILL1102"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                }
                //i ((PRTFlag'="N")&&((ETPRc'="00")||((Type'="D")&&(Type'="T")&&(Type'="B")))){
                i ((PRTFlag'="N")&&(ETPRc'="00")){  
                    s DataSrc="User.DHCINVPRT"
                    s DataID=PRTRowid
                    s ErrInfo="发票表DHC_INVPRT.PRTRowid:"_PRTRowid_"交易状态:"_PRTFlag_",第三方交易表DHC_BillExtTradePay.ETP_RowID:"_ETPRowID_"交易状态:"_ETPRc_"Type"_Type_"发票状态与第三方交易表的状态不一致"_Type
                    s ErrCode="OPBILL1102"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)    
                }
                continue:(Type="P")||(Type="S")||(Type="V") //这三种状态不判断金额
                s ETPAmout=$p(^DHCBILLETP(ETPRowID),"^",4) //第三方支付金额
                if ((Type="D")||(Type="T")||(Type="B"))
                {
                    s ETPAmout=-ETPAmout //第三方支付金额
                }
                s ETCSub=""
                s PRTAmout="0" //发票表第三方支付金额
                f
                {
                    s ETCSub=$o(^DHCBILLETP(ETPRowID,"C",ETCSub))
                    q:ETCSub=""
                    s ETCHISPRTDR=$p(^DHCBILLETP(ETPRowID,"C",ETCSub),"^",1)
                    s ETCPRTPayModeDR=$p(^DHCBILLETP(ETPRowID,"C",ETCSub),"^",3)
                    s IPMSubNew=""
                    f
                    {
                        s IPMSubNew=$o(^DHCINVPRT(ETCHISPRTDR,"P",IPMSubNew))
                        q:IPMSubNew=""  //退出循环
                        if (ETCHISPRTDR_"||"_IPMSubNew=ETCPRTPayModeDR)
                        {
                            s PRTAmout=PRTAmout+$p(^DHCINVPRT(ETCHISPRTDR,"P",IPMSubNew),"^",3) //发票表第三方支付金额
                        }
                    }
                }
                if ($fn(PRTAmout,"",2)'=$fn(ETPAmout,"",2)) //发票支付金额与第三方交易支付金额不一致
                {
                    s DataSrc="User.DHCINVPRT"
                    s DataID=PRTRowid
                    s ErrInfo="发票表DHC_INVPRT.PRTRowid:"_PRTRowid_"发票第三方支付金额:"_PRTAmout_",第三方交易表DHC_BillExtTradePay.ETP_RowID:"_ETPRowID_"交易金额:"_ETPAmout_"发票第三方支付金额与第三方交易支付金额不一致"
                    s ErrCode="OPBILL1103"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                }
            }
            
            ///校验DHC_INVPayMode.IPM_ETP_DR->DHC_BillExtTradePay是否存在
            //根据HIS版本号判断 支付方式表是否需要进行校验----2022-7-21
            s HISVer=^||TMPCheck("HISVer")
            if (HISVer>8.5) {       
                if ($p(^DHCINVPRT(PRTRowid,"P",IPMSub),"^",15)'="") //IPMETPDR 第三方支付交易表指针不为空
                {
                    s ETPID=$p(^DHCINVPRT(PRTRowid,"P",IPMSub),"^",15)
                    if ($g(^DHCBILLETP(ETPID))="") //第三方交易表数据为空
                    {
                        s DataSrc="User.DHCINVPRT"
                        s DataID=PRTRowid
                        s ErrInfo="发票支付方式表DHC_INVPayMode.PRTRowid:"_PRTRowid_"IPM_Sub:"_IPMSub_"对应第三方交易表DHC_BillExtTradePay.ETP_RowID:"_ETPID_"数据为空,发票支付方式找不到对应的第三方交易表"
                        s ErrCode="OPBILL1104"
                        d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                    }
                }
                else  //IPMETPDR 第三方支付交易表指针为空
                {
                    s DataSrc="User.DHCINVPRT"
                    s DataID=PRTRowid
                    s ErrInfo="发票支付方式表DHC_INVPayMode.PRTRowid:"_PRTRowid_"IPM_Sub:"_IPMSub_"中IPMETPDR为空,发票支付方式对应第三方支付交易表指针为空"
                    s ErrCode="OPBILL1104"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                }
            }
        }   
    }
    q ""
CheckINVPRTThirdPayErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"核查第三方支付是否成功异常:",PRTRowid,$ze)
    q ""
}

/// Creator：      tangzf
/// CreatDate：    2022-07-25
/// Description：  核查第三方支付是否成功
/// 4.指定日期段
/// Table：        DHC_INVPRT、DHCBillConINV
/// input:         
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckINVPRTThirdPay()
ClassMethod CheckACCThirdPay(a = "")
{
    s $zt="CheckACCThirdPayErr"
    s CheckMode = ^||TMPCheck("CheckMode") 
    s HospDr = ^||TMPCheck("HospDr")
    s StartDate=^||TMPCheck("StartDate") 
    s EndDate = ^||TMPCheck("EndDate")
    s StartTime = ^||TMPCheck("StartTime")  
    s EndTime = ^||TMPCheck("EndTime")
    
    f UpdateDate=StartDate:1:EndDate  
    {
        s AccM=0
        while $o(^DHCACDi("AccM","0","APDDate",UpdateDate,AccM))
        {
            s AccM=$o(^DHCACDi("AccM","0","APDDate",UpdateDate,AccM))
            continue:AccM=""
            s AccPD=0
            while $o(^DHCACDi("AccM","0","APDDate",UpdateDate,"AccPD",AccPD))
            {
                s AccPD=$o(^DHCACDi("AccM","0","APDDate",UpdateDate,"AccPD",AccPD))
                s AccPayMode=0
                while $o(^DHCACD("AccM",AccM,"AccPD",AccPD,"P",AccPayMode))
                {
                    s AccPayMode=$o(^DHCACD("AccM",AccM,"AccPD",AccPD,"P",AccPayMode))
                    s IPMPayModeDR=$p(^DHCACD("AccM",AccM,"AccPD",AccPD,"P",AccPayMode),"^",1) //支付方式id
                    s PayModeStr=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(IPMPayModeDR) //支付方式扩展表字段(调用标志、调用方法、调用方式、退费标志)
                    if ($p(PayModeStr,"^",1)>0)
                    {
                        ///校验门诊预交金对应的第三方交易信息
                        s ETCTradeType="PRE"
                        s PRTRowid=AccM_"||"_AccPD
                        s ETPRowID=$o(^DHCBILLETPi(0,"TTypePRT",ETCTradeType,"PRT",PRTRowid,""),-1)
                        if ((ETPRowID="") || ($g(^DHCBILLETP(ETPRowID))="")) //发票找不到对应的第三方交易信息
                        {
                            s DataSrc="User.DHCAccPreDeposit"
                            s DataID=PRTRowid
                            s ErrInfo=DataID_"门诊预交金记录找不到对应的第三方交易信息"
                            s ErrCode="OPBILL1001"
                            d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                        }
                        else 
                        {
                            s ETPRc=$p(^DHCBILLETP(ETPRowID),"^",1)  //第三方交易表的状态 00 表示成功，非00表示失败
                            s PRTFlag=..CheckNormalInv(PRTRowid,"PRE") //$p(^DHCINVPRT(PRTRowid),"^",8) // N 表示成功 非N 表示失败
                            s Type=$p(^DHCBILLETP(ETPRowID),"^",26) //,C:支付,D:退费,T:退货,B:批量退货
                            i ((PRTFlag="N")&&(ETPRc'="00")){
                                s DataSrc="User.DHCAccPreDeposit"
                                s DataID=PRTRowid
                                s ErrInfo="门诊正常收费预交金："_PRTRowid_"交易状态:"_PRTFlag_"Type"_Type_",第三方交易表DHC_BillExtTradePay.ETP_RowID:"_ETPRowID_"交易状态:"_Type_ETPRc_"发票状态与第三方交易表的状态不一致"
                                s ErrCode="OPBILL1002"
                                d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                            }
                            
                            i ((PRTFlag'="N")&&(ETPRc'="00")){
                                s DataSrc="User.DHCAccPreDeposit"
                                s DataID=PRTRowid
                                s ErrInfo="门诊退费预交金："_PRTRowid_"交易状态:"_PRTFlag_"Type"_Type_",第三方交易表DHC_BillExtTradePay.ETP_RowID:"_ETPRowID_"交易状态:"_Type_ETPRc_"发票状态与第三方交易表的状态不一致"
                                s ErrCode="OPBILL1102"
                                d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)    
                            }
                            continue:(Type="P")||(Type="S")||(Type="V") //这三种状态不判断金额
                            s ETPAmout=$p(^DHCBILLETP(ETPRowID),"^",4) //第三方支付金额
                            if ((Type="D")||(Type="T")||(Type="B"))
                            {
                                s ETPAmout=-ETPAmout //第三方支付金额
                            }
                            s PRTAmout=$p(^DHCACD("AccM",AccM,"AccPD",AccPD,"P",AccPayMode),"^",6) 
                            if ($fn(PRTAmout,"",2)'=$fn(ETPAmout,"",2)) //发票支付金额与第三方交易支付金额不一致
                            {
                                s DataSrc="User.DHCAccPrePayMode"
                                s DataID=PRTRowid_"||"_AccPayMode
                                s ErrInfo="预交金支付方式金额:"_PRTAmout_",第三方交易表DHC_BillExtTradePay.ETP_RowID:"_ETPRowID_"交易金额:"_ETPAmout_"不一致"
                                s ErrCode="OPBILL1003"
                                d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    q ""
CheckACCThirdPayErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"核查第三方支付是否成功异常:",$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-11
/// Description：  账单医嘱表没有对应的账单明细
/// 1.DHC_PatBillOrder->对应的DHC_PatBillDetails是否为空
/// Table：        DHC_PatBillOrder、DHC_PatBillDetails
/// input:         
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckPatBillOrderDetial()
ClassMethod CheckPatBillOrderDetial(PBRowId, PBOChildSub)
{
    s $zt="CheckPatBillOrderDetialErr"
    q:(+PBRowId=0)||(+PBOChildSub=0) ""
    q:$g(^DHCPB(PBRowId,"O",PBOChildSub))="" "" 
    q:$p(^DHCPB(PBRowId,"O",PBOChildSub),"^",8)="0" "" //过滤价格为0
    s PBOOEORIDR=$p(^DHCPB(PBRowId,"O",PBOChildSub),"^",4)
    s OEORDStatus=($p(^OEORD($p(PBOOEORIDR,"||",1),"I",$p(PBOOEORIDR,"||",2),1),"^",13))
    s statCode=$p($g(^OEC("OSTAT",+OEORDStatus)),"^",1)
    q:(statCode'="V")&&(statCode'="E") ""  //过滤已经停止和作废的医嘱
    if ($o(^DHCPB(PBRowId,"O",PBOChildSub,"D","0"))="") //对应的DHC_PatBillDetails为空
    {
        s DataSrc="User.DHCPatBillOrder"
        s DataID=PBRowId_"||"_PBOChildSub
        s ErrInfo="账单医嘱表DHC_PatBillOrder.PB_RowId:"_PBRowId_"PBO_ChildSub:"_PBOChildSub_"没有对应的账单明细"
        s ErrCode="OPBILL1401"
        d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    }
    q:""
CheckPatBillOrderDetialErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"账单医嘱表没有对应的账单明细异常:",PBRowId_"||"_PBOChildSub,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-16
/// Description：  住院发票表与支付方式表是否平衡
/// 1.DHC_INVPRTZY.PRT_ARPBL.PB_PatientShare-DHC_INVPRTZY.Deposit的金额是否等于AR_RcptPayMode的各项金额之和
/// 2.DHC_INVPRTZY.PRT_ARRCP_DR->AR_RcptPayMode.PAYM_ParRef
/// 3.指定日期段
/// Table：    
/// input:       
/// Output：     
/// Debug：        d ##class(BILL.DC.Check).CheckINVPRTZYToARRcptPayMode("")
ClassMethod CheckINVPRTZYToARRcptPayMode(PRTRowid)
{
    s $zt="CheckINVPRTZYToARRcptPayModeErr"
    q:$g(^DHCINVPRTZY(PRTRowid))="" "" //为空直接返回
    s PBAtm=$p(^DHCPB($p(^DHCINVPRTZY(PRTRowid),"^",5)),"^",12) //自付金额
    s PRTDeposit=$p(^DHCINVPRTZY(PRTRowid),"^",22)  //充值总额
    s HISVer=^||TMPCheck("HISVer")
    if (HISVer<9.0) //9.0以上版本表结构有变动
    { 
        s ARRCPRow=$p(^DHCINVPRTZY(PRTRowid),"^",17) 
        s PAYMChildsub="0"
        s PAYMAmt="0"
        f  //获取各种支付总额
        {
            s PAYMChildsub=$o(^ARRCP(ARRCPRow,"PAYM",PAYMChildsub))
            q:PAYMChildsub=""
            s PAYMAmt=PAYMAmt+$p(^ARRCP(ARRCPRow,"PAYM",PAYMChildsub),"^",3)
        }
        s PRTAmt=PBAtm-PRTDeposit
        if ($fn(PRTAmt,"",2)'=$fn(PAYMAmt,"",2))
        {
            s DataSrc="User.DHCINVPRTZY"
            s DataID=PRTRowid
            s ErrInfo="住院发票表DHC_INVPRTZY.PRTRowid:"_PRTRowid_"金额:"_PRTAmt_"支付方式表金额:"_PAYMAmt_"住院发票表与支付方式表金额不平"
            s ErrCode="IPBILL0201"
            d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
        }
    }
    else
    {
        set paymSum=0     //支付方式金额合计
        set paymSub=0
        while($o(^DHCINVPRTZY(PRTRowid,"P",paymSub))) {
            set paymSub=$o(^DHCINVPRTZY(PRTRowid,"P",paymSub))
            set paymSubData=$g(^DHCINVPRTZY(PRTRowid,"P",paymSub))
            continue:(paymSubData="")
            set paymAmt=$p(paymSubData,"^",3)
            set paymSum=$i(paymSum, paymAmt)
        }
        set paymSum=$fn(paymSum,"",2)
        s PRTAmt=PBAtm-PRTDeposit
        if ($fn(PRTAmt,"",2)'=$fn(paymSum,"",2))
        {
            s DataSrc="User.DHCINVPRTZY"
            s DataID=PRTRowid
            s ErrInfo="住院发票表DHC_INVPRTZY.PRTRowid:"_PRTRowid_"金额:"_PRTAmt_"支付方式表金额:"_PAYMAmt_"住院发票表与支付方式表金额不平"
            s ErrCode="IPBILL0201"
            d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
        }
    }
    q ""
CheckINVPRTZYToARRcptPayModeErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"住院发票表与支付方式表是否平衡异常:",PRTRowid,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-16
/// Description：  住院发票表与账单表是否平衡
/// 1.DHC_INVPRTZY.PRT_Acount的金额是否等于对应账单的金额(总金额)
/// 2.DHC_INVPRTZY.PRT_ARPBL->DHC_PatientBill
/// 3.指定日期段
/// Table：    
/// input:       
/// Output：     
/// Debug：        d ##class(BILL.DC.Check).CheckINVPRTZY("")
ClassMethod CheckINVPRTZYToDHCPatientBill(PBZYRowid)
{
    s $zt="CheckINVPRTZYToDHCPatientBillErr"
    s PRTRowid=PBZYRowid
    q:$g(^DHCINVPRTZY(PRTRowid))="" "" //为空直接返回
    q:..CheckNormalInv(PRTRowid,"I")'="N" "" 
    s PBAtm=$p(^DHCPB($p(^DHCINVPRTZY(PRTRowid),"^",5)),"^",12) //自付金额
    s PRTDeposit=$p(^DHCINVPRTZY(PRTRowid),"^",22)  //充值总额
    s PRTAcount=$p(^DHCINVPRTZY(PRTRowid),"^",6) //住院发票表总金额
    s PBRowId=$p(^DHCINVPRTZY(PRTRowid),"^",5)
    s PBOChildSub="0"
    s PBTotalAmt="0"
    f
    {
        s PBOChildSub=$o(^DHCPB(PBRowId,"O",PBOChildSub))
        q:PBOChildSub=""
        s PBTotalAmt=PBTotalAmt+$p(^DHCPB(PBRowId,"O",PBOChildSub),"^",8) //计费的总额
    }
    if ($fn(PBTotalAmt,"",2)'=$fn(PRTAcount,"",2))
    {
        s DataSrc="User.DHCINVPRTZY"
        s DataID=PBZYRowid
        s ErrInfo="住院发票表DHC_INVPRTZY.PRTRowid:"_PBZYRowid_"金额:"_PRTAcount_"账单表金额:"_PBTotalAmt_"住院发票表与账单表金额不平"
        s ErrCode="IPBILL0301"
        d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    }
    q ""
CheckINVPRTZYToDHCPatientBillErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"住院发票表与账单表是否平衡异常:",PBZYRowid,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-12
/// Description：  已计费医嘱没有执行记录
/// 1.DHC_PatientBill->DHC_PatBillOrder->OE_OrdItem->OE_OrdExec。医嘱是否有对应的执行记录OE_OrdExec
/// 2.DHC_PatientBill.PB_PayedFlag=B状态账单
/// 3.指定时间段通过Update索引
/// Table：        DHC_PatBill
/// input:         
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckPBToOEOrdExec(23,1)
ClassMethod CheckPBToOEOrdExec(PBRow, PBOChild)
{
    s $zt="CheckPBToOEOrdExecErr"
    q:(+PBRow=0)||(+PBOChild=0) ""
    q:$g(^DHCPB(PBRow))="" ""
    q:($p((^DHCPB(PBRow)),"^",16)'="B")&&($p((^DHCPB(PBRow)),"^",16)'="P") "" //未计费的账单
    s PBOOEORIDR=$p(^DHCPB(PBRow,"O",PBOChild),"^",4)
    s OEORDStatus=($p(^OEORD($p(PBOOEORIDR,"||",1),"I",$p(PBOOEORIDR,"||",2),1),"^",13))
    s statCode=$p($g(^OEC("OSTAT",+OEORDStatus)),"^",1)
    s OEORIPriorityDR=$p(^OEORD($p(PBOOEORIDR,"||",1),"I",$p(PBOOEORIDR,"||",2),1),"^",8)
    q:(statCode'="V")&&(statCode'="E")&&(OEORIPriorityDR'=5)&&(OEORIPriorityDR'=14) ""  //医嘱过滤已经停止和未审核的，长期医嘱出院是停止状态,所以不过滤
    s myPriorFlag=..ReadOECPriorityFlag($p(PBOOEORIDR,"||",1)_"||"_$p(PBOOEORIDR,"||",2))
    q:(+myPriorFlag=1) ""   //自备药品退出 是没有计费账单还是没有发票？ 如果是没有发票换个地方判断
    q:$p(^PAADM($p((^DHCPB(PBRow)),"^",1)),"^",8)'="I" ""
    q:$g(^DHCPB(PBRow,"O",PBOChild))="" "" //数据为空退出
    s OEORDRow=$p($p(^DHCPB(PBRow,"O",PBOChild),"^",4),"||",1)
    s OEORIChild=$p($p(^DHCPB(PBRow,"O",PBOChild),"^",4),"||",2)
    s OEOREChild=$o(^OEORD(OEORDRow,"I",OEORIChild,"X","0"))
    if (OEOREChild="") //"已计费医嘱没有执行记录" ,!
    {
        s DataSrc="User.PatBillOrder"
        s DataID=PBRow_"||"_PBOChild
        s ErrInfo="账单医嘱表DHC_PatBillOrder.PB_RowId:"_PBRow_"PBO_ChildSub:"_PBOChild_"已计费医嘱没有执行记录"
        s ErrCode="IPBILL0501"
        d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    }
    q ""
CheckPBToOEOrdExecErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"已计费医嘱没有执行记录异常:",PBRow_"||"_PBOChild,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/05/16
/// Description:住院发票对应的医嘱的计费状态是否正确
/// 1.DHC_INVPRTZY对应医嘱的OE_OrdItem.OEORI_Billed字段是否为P(收费)
/// 2.DHC_INVPRTZY.PRT_ARPBL->DHC_PatBillOrder->OE_OrdItem
/// 3.指定日期段
/// Input:
/// Output:
/// Debug: do ##class(BILL.DC.Check).CheckIPFromInvZYToOrdItemGetBilled("7646")
/// Debug: do ##class(BILL.DC.Check).CheckIPFromInvZYToOrdItemGetBilled("7822")
ClassMethod CheckIPFromInvZYToOrdItemGetBilled(PBZYRowid)
{
    s $zt="CheckIPFromInvZYToOrdItemGetBilledErr"
    if PBZYRowid="" quit $$$OK
    //w "PatBillID:",PatBillID,!
    set PBRowid=$p(^DHCINVPRTZY(PBZYRowid),"^",5) //invZY指向账单主表指针
    q:..CheckNormalInv(PBZYRowid,"I")'="N" ""
    quit:PBRowid="" ""
    set PBOChildSub=0
    while ($o(^DHCPB(PBRowid,"O",PBOChildSub))) 
    {
        set PBOChildSub=$o(^DHCPB(PBRowid,"O",PBOChildSub))
        set PatBillOrderData=^DHCPB(PBRowid,"O",PBOChildSub)
        set PBOOEORIDR=$p(PatBillOrderData,"^",4)
        set OEORIOEORDParRef=$p(PBOOEORIDR,"||",1)
        set OEORIChildsub=$p(PBOOEORIDR,"||",2)
        set OEOrdItemData=^OEORD(OEORIOEORDParRef,"I",OEORIChildsub,3)
        set OEORIBilled=$p(OEOrdItemData,"^",5)
        //w "OEORIBilled:"_OEORIBilled,!
        continue:OEORIBilled="R"
        s OEORDStatus=($p(^OEORD(OEORIOEORDParRef,"I",OEORIChildsub,1),"^",13))
        s statCode=$p($g(^OEC("OSTAT",+OEORDStatus)),"^",1)
        continue:(statCode'="V")&&(statCode'="E") //过滤已经停止和作废的医嘱
    
        if OEORIBilled'="P" 
        {
            s DataSrc="User.OEOrdItem"
            s DataID=PBOOEORIDR
            s ErrCode="IPBILL0801"
            s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_PBZYRowid_",OE_OrdItem.OEORI_RowId:"_PBOOEORIDR_",OEORI_Billed:"_OEORIBilled_"，发票对应的医嘱的计费状态不正确(不为P)。"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            //set ^TMPOEORIBilledNotP(PBOOEORIDR)="OE_OrdItem.OEORI_RowId:"_PBOOEORIDR_",OEORI_Billed:"_OEORIBilled
            //w "OE_OrdItem.OEORI_RowId:"_PBOOEORIDR_",OEORI_Billed:"_OEORIBilled,!
        }
    }
    q ""
CheckIPFromInvZYToOrdItemGetBilledErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"住院发票对应的医嘱的计费状态是否正确异常:",PBZYRowid,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-16
/// Description：  住院发票上存在重复收费的医嘱
/// 1.DHC_INVPRTZY对应医嘱的OE_OrdItem是否有多条已收费的DHC_PatBillOrder记录。如果有多条DHC_PatBillOrder，根据OE_OrdItem反查其是否在同一个账单内或者不同账单内，如果在同一个账单或者多个账单内则属于重复计费数据。如果反查结果只有一条DHC_PatBillOrder则退出本次循环不需要下一步校验
/// 2.DHC_INVPRTZY.PRT_ARPBL->DHC_PatBillOrder->OE_OrdItem,然后根据OE_OrdItem反查->DHC_PatBillOrder->DHC_INVPRTZ
/// 3.指定日期段
/// Table：    
/// input:       
/// Output：     
/// Debug：d ##class(BILL.DC.Check).CheckINVPRTZYToOEOrdItem("492")
ClassMethod CheckINVPRTZYToOEOrdItem(PRTRowid)
{
    s $zt="CheckINVPRTZYToOEOrdItemErr"
    q:$g(^DHCINVPRTZY(PRTRowid))="" "" //为空直接返回
    q:..CheckNormalInv(PRTRowid,"I")'="N" ""
    s PBBillType=$p((^DHCPB($p(^DHCINVPRTZY(PRTRowid),"^",5))),"^",16)
    q:(PBBillType="B")||(PBBillType="TB") "" //如果状态是未结算，则跳过
    s PBOChild="0"
    f //获取表DHC_PatBillOrder
    {
        s PBOChild=$o(^DHCPB($p(^DHCINVPRTZY(PRTRowid),"^",5),"O",PBOChild))
        q:PBOChild=""
        if ($p(^DHCPB($p(^DHCINVPRTZY(PRTRowid),"^",5),"O",PBOChild),"^",16)'="B")&&($p(^DHCPB($p(^DHCINVPRTZY(PRTRowid),"^",5),"O",PBOChild),"^",16)'="P")
        {continue}
        s OEORDRow=$p($p(^DHCPB($p(^DHCINVPRTZY(PRTRowid),"^",5),"O",PBOChild),"^",4),"||",1)
        s OEORIChild=$p($p(^DHCPB($p(^DHCINVPRTZY(PRTRowid),"^",5),"O",PBOChild),"^",4),"||",2)
        s PBRowId="0"
        f
        {
            s PBRowId=$o(^DHCPBi(0,"OEORI",OEORDRow_"||"_OEORIChild,PBRowId))
            q:PBRowId=""
            s OEORDStatus=($p(^OEORD(OEORDRow,"I",OEORIChild,1),"^",13))
            s statCode=$p($g(^OEC("OSTAT",+OEORDStatus)),"^",1)
            q:(statCode'="V")&&(statCode'="E")  //过滤已经停止和作废的医嘱
            s PBBillTypeNew=$p((^DHCPB(PBRowId)),"^",16)
            if ((PBBillTypeNew="B")||(PBBillTypeNew="TB")) //如果账单未结算，则跳过
            {continue}
            s PBOChildNew="0"
            f 
            {
                s PBOChildNew=$o(^DHCPBi(0,"OEORI",OEORDRow_"||"_OEORIChild,PBRowId,PBOChildNew))
                q:PBOChildNew=""
                if ($p(^DHCPB(PBRowId,"O",PBOChildNew),"^",16)'="B")&&($p(^DHCPB(PBRowId,"O",PBOChildNew),"^",16)'="P")
                {continue}
                if (PBRowId'=$p(^DHCINVPRTZY(PRTRowid),"^",5)) //医嘱反查回来的账单表PBRowId和发票查下来的PBRowId不一致
                {
                    s PRTRowNew="0" //反查回来的发票PRTRow
                    f
                    {
                        s PRTRowNew=$o(^DHCINVPRTZY(0,"AR",PBRowId,PRTRowNew))
                        q:PRTRowNew=""
                        if (..CheckNormalInv(PRTRowNew,"I")="N") //发票为正常
                        {
                            s DataSrc="User.DHCINVPRTZY"
                            s DataID=PRTRowid
                            s ErrCode="IPBILL0901"
                            s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_PRTRowid_"，OE_OrdItem.OEORD_RowId:"_OEORDRow_"||"_OEORIChild_"INVZYROwid："_PRTRowid_"跟"_PRTRowNew_"，医嘱重复计费,同一医嘱存在多张不同正常发票。"
                            d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                        }
                    }
                }
                else  //医嘱反查回来的账单表PBRowId和发票查下来的PBRowId一致,判断是否有多条
                {   
                    /*   2022-8-1 tangzf - 住院判断执行记录    
                    if (PBOChildNew'=PBOChild) //同一个账单内存在相同收费的医嘱
                    {
                        b  //111
                        s DataSrc="User.DHCINVPRTZY"
                        s DataID=PRTRowid
                        s ErrCode="IPBILL0901"
                        s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_PRTRowid_"，OE_OrdItem.OEORD_RowId:"_OEORDRow_"OEORI_Childsub:"_OEORIChild_"，医嘱重复计费,同一账单存在重复医嘱。"
                        d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                    }*/
                }
            }
        }
    }
    q ""
CheckINVPRTZYToOEOrdItemErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"住院发票上存在重复收费的医嘱异常:",PRTRowid,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/08/8
/// Description:核查医嘱项目价格是否为0
/// Input:
/// Output:
/// Debug: do ##class(BILL.DC.Check).CheckARCItmMastPriceZero(7848,1)
ClassMethod CheckARCItmMastPriceZero(Rowid, ChildSub)
{
    s $zt="CheckARCItmMastPriceZeroErr"
    q:(Rowid="")||(ChildSub="") ""
    s IndicatorId=^||TMPCheck("BusinessCode")_"||"_^||TMPCheck("IndicatorCode")
    q:##class(BILL.DC.BL.UnAuditItmCtl).CheckUnAuditItm(^||TMPCheck("HospDr"),IndicatorId,"ArcItm",Rowid_"||"_ChildSub)="Y" ""
    s ItmPriceStr=##class(web.UDHCJFPRICE).GetOrderPrice("","",Rowid_"||"_ChildSub,"","","","","",^||TMPCheck("HospDr"),"")
    s ArcIMPrice=$p(ItmPriceStr,"^",1)
    if ArcIMPrice=0 d
    .s ARCData=$g(^ARCIM(Rowid,ChildSub,1))
    .s ARCDesc=""
    .if (ARCData'="") d
    ..s ARCDesc=$p(ARCData,"^",2)
    .s DataSrc="User.ARCItmMast"
    .s DataID=Rowid_"||"_ChildSub
    .s ErrCode="ARCIM0101"
    .s ErrInfo="ARC_ItmMast.Rowid:"_Rowid_"||"_ChildSub_"，医嘱项目："_ARCDesc_"，价格是否为0"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    q ""
CheckARCItmMastPriceZeroErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"核查医嘱项目价格是否为0异常:",Rowid_"||"_ChildSub,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/08/2
/// Description:住院执行记录重复计费
/// 1.DHC_PatientBill->DHC_PatBillOrder.PBO_OrdExec_DR->OE_OrdExec.OEORE_Billed,OE_OrdExecExt.OEORE_Billed，三个表的计费状态是否一致
/// 2.通过住院发票查询DHC_INVPRTZY.PRT_Date
/// Input:
/// Output:
/// Debug: do ##class(BILL.DC.Check).CheckIPOEOrdExecBYStatus(1)
ClassMethod CheckIPOEOrdExecBYStatus(PRTZYRowid)
{
    s $zt="CheckIPOEOrdExecBYStatusErr"
    q:PRTZYRowid="" ""
    q:$g(^DHCINVPRTZY(PRTZYRowid))="" ""
    s PRTFlag=..CheckNormalInv(PRTZYRowid,"I")
    q:(PRTFlag'="N")&&(PRTFlag'="I") ""
    s PBRowid=$p($g(^DHCINVPRTZY(PRTZYRowid)),"^",5)
    q:PBRowid="" ""
    s PBOChildSub=""
    for  s PBOChildSub=$o(^DHCPB(PBRowid,"O",PBOChildSub)) q:PBOChildSub=""  d
    .q:$g(^DHCPB(PBRowid,"O",PBOChildSub))=""
    .s PBOOEORIDR=$p(^DHCPB(PBRowid,"O",PBOChildSub),"^",20)
    .q:PBOOEORIDR=""
    .q:+$p(^DHCPB(PBRowid,"O",PBOChildSub),"^",11)<="0"
    .s OEORIOrderStatusDR=$p($g(^OEORD(+PBOOEORIDR,"I",$p(PBOOEORIDR,"||",2),1)),"^",13)
    .s statCode=$p($g(^OEC("OSTAT",+OEORIOrderStatusDR)),"^",1)
    .q:(statCode'="V")&&(statCode'="E")  //过滤已经停止和作废的医嘱
    .s OEOREOrderStatusDR=$p($g(^OEORD(+PBOOEORIDR,"I",$p(PBOOEORIDR,"||",2),"X",$p(PBOOEORIDR,"||",3))),"^",16) //执行状态
    .if (OEOREOrderStatusDR="1") d //执行记录为已执行，反查pbo
    ..s NewPBRowid=""
    ..for  s NewPBRowid=$o(^DHCPB(0,"OEEXC",PBOOEORIDR,NewPBRowid)) q:NewPBRowid=""  d
    ...s NewPBOChildSub=0
    ...for  s NewPBOChildSub=$o(^DHCPB(0,"OEEXC",PBOOEORIDR,NewPBRowid,NewPBOChildSub)) q:NewPBOChildSub=""  d
    ....q:(NewPBRowid_"||"_NewPBOChildSub)=(PBRowid_"||"_PBOChildSub) //过滤同一张医嘱费用明细
    ....q:+$p(^DHCPB(NewPBRowid,"O",NewPBOChildSub),"^",11)<=0
    ....s NewPBOOEORIDR=$p(^DHCPB(NewPBRowid,"O",NewPBOChildSub),"^",4)
    ....q:NewPBOOEORIDR=""
    ....s NewOEORDRowId=$p(NewPBOOEORIDR,"||",1)
    ....s NewOEORIChildsub=$p(NewPBOOEORIDR,"||",2)
    ....s NewOEOREChildsub=0
    ....for  s NewOEOREChildsub=$o(^OEORD(NewOEORDRowId,"I",NewOEORIChildsub,"X",NewOEOREChildsub)) q:NewOEOREChildsub=""  d
    .....s NewOEOREOrderStatusDR=$p($g(^OEORD(NewOEORDRowId,"I",NewOEORIChildsub,"X",NewOEOREChildsub)),"^",16) //新的执行状态
    .....if (NewOEOREOrderStatusDR="1")&&(NewPBRowid=PBRowid) d //同一账单下，重复执行
    ......s DataSrc="User.DHCPatBillOrder"
    ......s DataID=NewPBRowid_"||"_NewPBOChildSub
    ......s ErrCode="IPBILL1908"
    ......s ErrInfo="User.DHCPatBillOrder.Rowid:"_NewPBRowid_"||"_NewPBOChildSub_" 与 "_PBRowid_"||"_PBOChildSub_"，OE_OrdItem.Rowid:"_+PBOOEORIDR_"||"_$p(PBOOEORIDR,"||",2)_"，同一账单下，重复医嘱且医嘱重复执行。"
    ......d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    .....if (NewOEOREOrderStatusDR="1")&&(NewPBRowid'=PBRowid) d //不同账单下，重复执行
    ......s DataSrc="User.DHCPatBillOrder"
    ......s DataID=PBRowid_"||"_PBOChildSub
    ......s ErrCode="IPBILL1908"
    ......s ErrInfo="User.DHCPatBillOrder.Rowid:"_NewPBRowid_"||"_NewPBOChildSub_" 与 "_PBRowid_"||"_PBOChildSub_"，OE_OrdItem.Rowid:"_+PBOOEORIDR_"||"_$p(PBOOEORIDR,"||",2)_"，不同账单下，重复医嘱且医嘱重复执行。"
    ......d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
CheckIPOEOrdExecBYStatusErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"住院执行记录重复计费异常:",PRTZYRowid,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/08/3
/// Description:根据医嘱查询住院状态是D的未收费的医嘱  //注意：如果项目有执行状态是核实，需要加上核实判断
/// 
/// Input:
/// Output:
/// Debug: do ##class(BILL.DC.Check).CheckIPOrdItemNotBillBYOrdItem("6","2")
ClassMethod CheckIPOrdItemNotBillBYOrdItem(OEORDRowId, OEORIChildsub)
{
    s $zt="CheckIPOrdItemNotBillBYOrdItemErr"
    q:(OEORDRowId="")||(OEORIChildsub="") ""
    q:$g(^OEORD(OEORDRowId))="" ""
    s OEORDAdmDR =$p($g(^OEORD(OEORDRowId)),"^",1)
    q:OEORDAdmDR="" ""
    q:$g(^PAADM(OEORDAdmDR))="" ""
    q:($p($g(^PAADM(OEORDAdmDR)),"^",2)'="I")&&($p($g(^PAADM(OEORDAdmDR)),"^",20)'="D") "" //过滤非住院类型，非出院状态
    s OEORIOrderStatusDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
    s statCode=$p($g(^OEC("OSTAT",+OEORIOrderStatusDR)),"^",1)
    s OEORIPriorityDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",8)
    q:(statCode'="V")&&(statCode'="E")&&(OEORIPriorityDR'=5)&&(OEORIPriorityDR'=14) ""  //医嘱过滤已经停止和未审核的，长期医嘱出院是停止状态
    if $o(^DHCPBi(0,"OEORI",OEORDRowId_"||"_OEORIChildsub,""))="" d
    .s DataSrc="User.OEOrdItem"
    .s DataID=OEORDRowId_"||"_OEORIChildsub
    .s ErrCode="IPBILL1901"
    .s ErrInfo="User.OEOrdItem.Rowid:"_OEORDRowId_"||"_OEORIChildsub_"，执行状态："_OEORIOrderStatusDR_",根据OE_OrdItem找不到对应的账单记录"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    q ""
CheckIPOrdItemNotBillBYOrdItemErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"根据医嘱查询住院状态是D的未收费的医嘱异常:",OEORDRowId_"||"_OEORIChildsub,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/05/17
/// Description:指定日期范围内校验  住院发票已经结算的执行记录计费状态与账单表状态是否相符
/// 1.DHC_PatientBill->DHC_PatBillOrder.PBO_OrdExec_DR->OE_OrdExec.OEORE_Billed,OE_OrdExecExt.OEORE_Billed，三个表的计费状态是否一致
/// 2.通过住院发票查询DHC_INVPRTZY.PRT_Date
/// Input:
/// Output:
/// Debug: do ##class(BILL.DC.Check).CheckBillAndEcecByBilled(1)
ClassMethod CheckBillAndEcecByBilled(PBZYRowid)
{
    s $zt="CheckBillAndEcecByBilledErr"
    if PBZYRowid="" quit $$$OK
    set PRTFlag =..CheckNormalInv(PBZYRowid,"I")
    q:PRTFlag'="N" ""
    //w "PBZYRowid:"_PBZYRowid,!
    //b
    set PatBillID=$p(^DHCINVPRTZY(PBZYRowid),"^",5) //invZY指向账单主表指针
    if PatBillID="" quit $$$OK
    set PatBillData=$g(^DHCPB(PatBillID))
    set PatBillFlag=$p(PatBillData,"^",16) //DHC_PatientBill计费状态
    q:(PatBillFlag'="P") ""
    set PBOChildSub=0
    //w "PatBillFlag:"_PatBillFlag,!
    //w "PatBillID:"_PatBillID,!
    //b
    while ($o(^DHCPB(PatBillID,"O",PBOChildSub))) 
    {
        set PBOChildSub=$o(^DHCPB(PatBillID,"O",PBOChildSub))
        set PatBillOrderData=$g(^DHCPB(PatBillID,"O",PBOChildSub))
        continue:PatBillOrderData=""
        set PBORefundFlag=$p(PatBillOrderData,"^",14)
        continue:PatBillOrderData="R"
        set PBOOrdExecDR=$p(PatBillOrderData,"^",20) //OEOrdExec指针
        //w "PBOOrdExecDR:"_PBOOrdExecDR,!
        set OEORDRowId=$p(PBOOrdExecDR,"||",1)
        set OEORIChildsub=$p(PBOOrdExecDR,"||",2)
        set OEOREChildsub=$p(PBOOrdExecDR,"||",3)
        set OEOrdExecData=^OEORD(OEORDRowId,"I",OEORIChildsub,"X",OEOREChildsub) 
        //w "OEOrdExecData:"_OEOrdExecData,!
        continue:OEOrdExecData=""
        s OEORDStatus=($p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",13))
        s statCode=$p($g(^OEC("OSTAT",+OEORDStatus)),"^",1)
        s OEORIPriorityDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",8)
        continue:(statCode'="V")&&(statCode'="E")&&(OEORIPriorityDR'=5)&&(OEORIPriorityDR'=14)  //医嘱过滤已经停止和未审核的，长期医嘱长期嘱托出院是停止状态
        //continue:(statCode'="V")&&(statCode'="E") //过滤已经停止和作废的医嘱
        set OEOREBilled=$p(OEOrdExecData,"^",6) //OEOrdExec计费状态
        //w "OEOREBilled:"_OEOREBilled,!
        //b
        continue:OEOREBilled="R"
        if OEOREBilled'="P"
        {
            s DataSrc="User.OEOrdExec"
            s DataID=PBOOrdExecDR
            s ErrCode="IPBILL1001"
            s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_PBZYRowid_",DHC_PatientBill.Rowid:"_PatBillID_",PatBillFlag:"_PatBillFlag_"，与OE_OrdExec.Rowid:"_PBOOrdExecDR_",OEOREBilled:"_OEOREBilled_"，已执行记录计费状态为P账单表计费状态不为P。"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
        }
        
        //暂时不对比OE_OrdExecExt计费状态
#;      set PBOOEORIDR=$p(PatBillOrderData,"^",4) //OEOrdItem指针
#;      set OEORIOEORDParRef=$p(PBOOEORIDR,"^",1) 
#;      //set OEORIChildsub=$p(PBOOEORIDR,"^",2)
#;      set OEORIChildsub=0
#;      //^OEORD({OEORI_OEORD_ParRef},"I",{OEORI_Childsub})
#;      while ($o(^OEORD(OEORIOEORDParRef,"I",OEORIChildsub)))
#;      {
#;          set OEORIChildsub=$o(^OEORD(OEORIOEORDParRef,"I",OEORIChildsub))
#;          set OEOREChildsub=0
#;          //^OEORD({OE_OrdItemExt.OEORI_OEORD_ParRef},"I",{OE_OrdItemExt.OEORI_Childsub},"X",{OEORE_Childsub})
#;          while ($o(^OEORD(OEORIOEORDParRef,"I",OEORIChildsub,"X",OEOREChildsub)))
#;          {
#;              set OEOREChildsub=$o(^OEORD(OEORIOEORDParRef,"I",OEORIChildsub,"X",OEOREChildsub))
#;              set OEOrdExecExtBILLData=$g(^OEORD(OEORIOEORDParRef,"I",OEORIChildsub,"X",OEOREChildsub,"BILL"))
#;              set OEOREBlillFlag=$p(OEOrdExecExtBILLData,"",19) //OE_OrdExecExt计费状态
#;          }
#;      }
        
    }
    q ""
CheckBillAndEcecByBilledErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"住院发票已经结算的执行记录计费状态与账单表状态是否相符异常:",PBZYRowid,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/05/18
/// Description:指定日期范围内校验  财务结算后又产生新未结算账单
/// 1.DHC_INVPRTZY.PRT_Flag="N"，PRT_Adm->PA_Adm->有2条及以上的DHC_PatientBill，且至少有一条账单的PB_PayedFlag为B的记录
/// 2.指定时间段PRT_Date
/// Input:
/// Output:
/// Debug: do ##class(BILL.DC.Check).CheckInvPrtZYAndDivideByBill("2020-07-07","2020-07-07")
ClassMethod CheckInvPrtZYAndPAAdmByBillB(PBZYRowid)
{
    s $zt="CheckInvPrtZYAndPAAdmByBillBErr"
    if PBZYRowid="" quit $$$OK
    set InvZYData=^DHCINVPRTZY(PBZYRowid)
    set PRTFlag=..CheckNormalInv(PBZYRowid,"I") //$p(InvZYData,"^",8) 
    quit:PRTFlag'="N" ""    
    set PRTAdm=$p(InvZYData,"^",4) //PAAdm指针
    set PatBillRowid=0
    set PatBillNum=0
    //判断有2条以上的DHC_PatientBill
    while ($o(^DHCPB(0,"ADM",PRTAdm,PatBillRowid)))
    {
        set PatBillNum=PatBillNum+1
        set PatBillRowid=$o(^DHCPB(0,"ADM",PRTAdm,PatBillRowid))
    }
    quit:PatBillNum<2 ""
    set PatBillNum=0
    set PatBillRowid=0
    //查找2条以上DHC_PatientBill的PBPayedFlag="B"的记录
    while ($o(^DHCPB(0,"ADM",PRTAdm,PatBillRowid)))
    {
        set PatBillRowid=$o(^DHCPB(0,"ADM",PRTAdm,PatBillRowid))
        set PatBillData=$g(^DHCPB(PatBillRowid))
        set PBPayedFlag=$p(PatBillData,"^",16) //PatBill计费状态
        if PBPayedFlag="B"
        {
            s DataSrc="User.DHCPatientBill"
            s DataID=PatBillRowid
            s ErrCode="IPBILL1101"
            s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_PBZYRowid_",DHC_PatientBill.Rowid:"_PatBillRowid_",PB_Adm_Dr:"_PRTAdm_"，财务结算后又产生新未结算账单。"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
            //w "DHC_INVPRTZY.rowid:"_rowid_",PRTAdm:"_PRTAdm_",PatBillRowid:"_PatBillRowid_",PBPayedFlag:"_PBPayedFlag,!   
        }
    }
    q ""
CheckInvPrtZYAndPAAdmByBillBErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"财务结算后又产生新未结算账单异常:",PBZYRowid,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/05/18
/// Description:门诊医保结算成功，HIS未结算
/// 1.INSU.Divide.INPAY_DHCpblDr->没有对应的DHC_INVPRTZY为异常数据
/// 2.INPAY_Flag="I"
/// 3.通过INSU_Divide.INPAY_iDate查询
/// Input:
/// Output:
/// Debug: do ##class(BILL.DC.Check).CheckOPDivideToPatBillByRowid("2022-02-10","2022-02-11")
ClassMethod CheckOPDivideToPatBillByRowid(rowid)
{
    s $zt="CheckOPDivideToPatBillByRowidErr"
    //^DHCINDIV("0","IDate",{INPAY_iDate},{INPAY_Rowid})
    //^DHCINVPRTZY(0,"AR",{PRT_ARPBL},{PRT_Rowid})
    if rowid="" quit ""
    set DivideData=$g(^DHCINDIV(rowid))
    set INPAYFlag=$p(DivideData,"^",5) //结算状态
    quit:INPAYFlag'="I" ""
    s paadmtype=$p(^PAADM($p(DivideData,"^",1)),"^",2) //就诊类型,O门诊，I住院
    q:(paadmtype'="O")&&(paadmtype'="E") "" //过滤非门诊病人
    set INPAYDHCpblDr=$p(DivideData,"^",3) //指向DHC_PatientBill的指针
    s PRTRowid=$p(DivideData,"^",4) //指向门诊发票的rowid
    q:(INPAYDHCpblDr="")&&(PRTRowid="") ""
    s INVDATA=$g(^DHCINVPRT(PRTRowid))
    if INVDATA=""
    {
        s DataSrc="User.INSUDivide"
        s DataID=rowid
        s ErrCode="IPBILL1201"
        s ErrInfo="INSU_Divide.INPAY_Rowid:"_rowid_",DHCINVPRT.PRTRowid:"_PRTRowid_"门诊发票信息不存在，未查询到发票信息。"
        d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
    }
    q:INVDATA="" ""
    s PRTFlag=..CheckNormalInv(PRTRowid,"O") //$p($g(^DHCINVPRT(PRTRowid)),"^",8) //发票状态
    if PRTFlag'="N"
    {
        s invDesc=""
        if PRTFlag="A"
        {
            s invDesc="A作废"
        }
        elseif PRTFlag="S"
        {
            s invDesc="S红冲"
        }
        elseif PRTFlag="TP"
        {
            s invDesc="TP预结算状态"
        }
        else
        {
            s invDesc=PRTFlag
        }
        s DataSrc="User.INSUDivide"
        s DataID=rowid
        s ErrCode="IPBILL1201"
        s ErrInfo="INSU_Divide.INPAY_Rowid:"_rowid_",DHCINVPRT.PRTRowid:"_PRTRowid_",PRTFlag:"_PRTFlag_",门诊HIS已退费，医保未退费"
        d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
    }
    q ""
CheckOPDivideToPatBillByRowidErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"门诊医保结算成功，HIS未结算异常:",rowid,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/05/18
/// Description:住院医保结算成功，HIS未结算
/// 1.INSU.Divide.INPAY_DHCpblDr->没有对应的DHC_INVPRTZY为异常数据
/// 2.INPAY_Flag="I"
/// 3.通过INSU_Divide.INPAY_iDate查询
/// Input:
/// Output:
/// Debug: do ##class(BILL.DC.Check).CheckIPDivideToPatBillByRowid("2022-02-10","2022-02-11")
ClassMethod CheckIPDivideToPatBillByRowid(rowid)
{
    s $zt="CheckIPDivideToPatBillByRowidErr"
    if rowid="" quit $$$OK
    set DivideData=$g(^DHCINDIV(rowid))
    set INPAYFlag=$p(DivideData,"^",5) //结算状态
    quit:INPAYFlag'="I" ""
    s paadmtype=$p(^PAADM($p(DivideData,"^",1)),"^",2) //就诊类型,O门诊，I住院
    q:paadmtype'="I" "" //过滤非住院病人
    set INPAYDHCpblDr=$p(DivideData,"^",3) //指向DHC_PatientBill的指针
    s PRTRowid=$p(DivideData,"^",4) //指向门诊发票的rowid
    q:(INPAYDHCpblDr="")&&(PRTRowid="") ""
    set PRTRowid=$o(^DHCINVPRTZY(0,"AR",INPAYDHCpblDr,PRTRowid))
    if PRTRowid=""
    {   
        s DataSrc="User.INSUDivide"
        s DataID=rowid
        s ErrCode="IPBILL1201"
        s ErrInfo="INSU_Divide.INPAY_Rowid:"_rowid_",INPAYDHCpblDr:"_INPAYDHCpblDr_"，指向DHC_INVPRTZY为空，未查询到发票信息。"
        d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
    }
    else
    {
        s INVZYDATA=$g(^DHCINVPRTZY(PRTRowid))
        if INVZYDATA=""
        {
            s DataSrc="User.INSUDivide"
            s DataID=rowid
            s ErrCode="IPBILL1201"
            s ErrInfo="INSU_Divide.INPAY_Rowid:"_rowid_",DHCINVPRTZY.PRTRowid:"_PRTRowid_"住院发票信息不存在，未查询到发票信息。"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
        }
        q:INVZYDATA="" ""
        s PRTFlag=..CheckNormalInv(PRTRowid,"I") //$p($g(^DHCINVPRTZY(PRTRowid)),"^",8) //发票状态
        if PRTFlag'="N"
        {
            s invDesc=""
            if PRTFlag="A"
            {
                s invDesc="A作废"
            }
            elseif PRTFlag="S"
            {
                s invDesc="S红冲"
            }
            elseif PRTFlag="I"
            {
                s invDesc="I中途结算"
            }
            else
            {
                s invDesc=PRTFlag
            }
            s DataSrc="User.INSUDivide"
            s DataID=rowid
            s ErrCode="IPBILL1201"
            s ErrInfo="INSU_Divide.INPAY_Rowid:"_rowid_",DHCINVPRTZY.PRTRowid:"_PRTRowid_",PRTFlag:"_PRTFlag_",HIS已取消，医保未取消"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
        }
    }
    q ""
CheckIPDivideToPatBillByRowidErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"住院医保结算成功，HIS未结算异常:",rowid,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-16
/// Description：  住院发票表与押金表关系是否正确
/// 1.DHC_INVPRTZY.PRT_ARPBL->^DHCJFDepositRowID("ZYJF",billno)->DHC_sfprintdetails.prt_status=1,押金之和是否等于DHC_INVPRTZTZY.PRT_Deposit
/// Table：    
/// input:       
/// Output：     
/// Debug：        d ##class(BILL.DC.Check).CheckINVPRTZYToDHCsfprintdetails("61")
ClassMethod CheckINVPRTZYToDHCsfprintdetails(PRTRowid)
{
    s $zt="CheckINVPRTZYToDHCsfprintdetailsErr"
    q:$g(^DHCINVPRTZY(PRTRowid))="" "" //为空直接返回
    q:..CheckNormalInv(PRTRowid,"I")'="N" "" //非正常发票不统计
    s HISVer=^||TMPCheck("HISVer")
    s PRTDeposit=$p(^DHCINVPRTZY(PRTRowid),"^",22)  //充值总额
    if (+HISVer<9.0) //9.0及以上版本表结构有变化
    {
        s PRTARPBL=$p(^DHCINVPRTZY(PRTRowid),"^",5)
        s DHCJFDepositStr=$g(^DHCJFDepositRowID("ZYJF",PRTARPBL))
        s DHCJFDepositCount=0
        s chgDeposit="0"
        for
        {
            s DHCJFDepositCount=DHCJFDepositCount+1
            s DHCJFDepositRowStr=$p(DHCJFDepositStr,"^",DHCJFDepositCount)
            s DHCJFDepositRow=$p(DHCJFDepositRowStr,"!",1)
            q:DHCJFDepositRow=""
            if ($g(^DHCSFPRINTDETAIL(DHCJFDepositRow))="")
            {
                continue    
            }
            s prtstatus=$p(^DHCSFPRINTDETAIL(DHCJFDepositRow),"^",8)
            if (prtstatus="1")
            {
                s chgDeposit=chgDeposit+$p(^DHCSFPRINTDETAIL(DHCJFDepositRow),"^",6)
            }
        }
    }
    else
    {
        set chgDeposit=0
        set conId=0
        while($o(^DHCINVPRTZYCONDEPi(0,"Inv",PRTRowid,conId))) {
            set conId=$o(^DHCINVPRTZYCONDEPi(0,"Inv",PRTRowid,conId))
            set conData=$g(^DHCINVPRTZYCONDEP(conId))
            continue:(conData="")
            set depRowId=$p(conData,"^",3)
            continue:(depRowId="")
            set depAmt=$p($g(^DHCSFPRINTDETAIL(depRowId)),"^",6)
            set chgDeposit=$i(chgDeposit, depAmt)
        }
    }
    if (PRTDeposit'=chgDeposit)
    {
        s DataSrc="User.DHCINVPRTZY"
        s DataID=PRTRowid
        s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_PRTRowid_"金额:"_PRTDeposit_"与押金表关系dhc_sfprintdetails金额:"_prtpayamount_"不一致,住院发票表与押金表关系不正确"
        s ErrCode="IPBILL1301"
        d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    }
    q ""
CheckINVPRTZYToDHCsfprintdetailsErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"住院发票表与押金表关系是否正确异常:",PRTRowid,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-16
/// Description：  住院结算核查第三方支付是否成功
/// 1.DHC_INVPRTZY.PRT_ARRCP_DR->AR_RcptPayMode,根据支付方式校验是否调用第三方接口##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(4)
/// 2.DHC_INVPRTZY.PRT_ARRCP_DR->AR_Receipts->DHC_BillExtTradeConSub->DHC_BillExtTradePay.ETP_Rc是否成功，是否和发票状态对应(收对收，退费对应退费)
/// 3.指定日期段
/// Table：    
/// input:       
/// Output：     
/// Debug：        d ##class(BILL.DC.Check).CheckINVPRTZYToDHCBillExtTradePay("47")
ClassMethod CheckINVPRTZYToDHCBillExtTradePay(PRTRowid)
{
    s $zt="CheckINVPRTZYToDHCBillExtTradePayErr"
    q:$g(^DHCINVPRTZY(PRTRowid))="" "" //数据为空
    s HISVer=^||TMPCheck("HISVer")
    if (HISVer<9.0) //9.0及以上版本表结构有变化
    {  
        s PRTARRCPDR=$p(^DHCINVPRTZY(PRTRowid),"^",17)  
        s PAYMChild="0" 
        f
        {
            s PAYMChild= $o(^ARRCP(PRTARRCPDR,"PAYM",PAYMChild))
            q:PAYMChild=""
            s PayModeDR= $p(^ARRCP(PRTARRCPDR,"PAYM",PAYMChild),"^",1)
            s PayModeStr=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayModeDR)
            q:PayModeStr=""
            if ($p(PayModeStr,"^",1)>0)
            {
                s ETCTradeType="IP"
                s DHCINVPRTZYFlag=..CheckNormalInv(PRTRowid,"I") //$p(^DHCINVPRTZY(PRTRowid),"^",8) //住院发票状态N 表示成功 非N 表示失败
                s ETPRowID=$o(^DHCBILLETPi(0,"TTypePRT",ETCTradeType,"PRT",PRTRowid,""),-1)
                if ((ETPRowID="")||($g(^DHCBILLETP(ETPRowID))=""))
                {
                    s DataSrc="User.DHCINVPRTZY"
                    s DataID=PRTRowid
                    s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_PRTRowid_"收费状态:"_DHCINVPRTZYFlag_"没有对应第三方交易"
                    s ErrCode="IPBILL16"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                    
                }
                s DHCBILLETPFlag=$p(^DHCBILLETP(ETPRowID),"^",1) //账单状态 第三方交易表的状态 00 表示成功，非00表示失败
                s Type=$p(^DHCBILLETP(ETPRowID),"^",26) //,C:支付,D:退费,T:退货,B:批量退货
                //if ((PRTFlag="N")&&((ETPRc'="00")||(Type'="C")))
                if ((DHCINVPRTZYFlag="N")&&((DHCBILLETPFlag'="00")))
                {
                    s DataSrc="User.DHCINVPRTZY"
                    s DataID=PRTRowid
                    s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_PRTRowid_"收费状态:"_DHCINVPRTZYFlag_"Type"_Type_"与押金表关系dhc_sfprintdetails收费状态:"_DHCBILLETPFlag_"不一致"
                    s ErrCode="IPBILL16"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                }
                //if ((PRTFlag'="N")&&((ETPRc'="00")||((Type'="D")&&(Type'="T")&&(Type'="B"))))
                if ((DHCINVPRTZYFlag'="N")&&(DHCBILLETPFlag'="00"))
                {
                    s DataSrc="User.DHCINVPRTZY"
                    s DataID=PRTRowid
                    s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_PRTRowid_"收费状态:"_DHCINVPRTZYFlag_"Type"_Type_"与押金表关系dhc_sfprintdetails收费状态:"_DHCBILLETPFlag_"不一致"
                    s ErrCode="IPBILL16"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                }
                continue:(Type="P")||(Type="S")||(Type="V") //这三种状态不判断金额
                s ETPAmout=$p(^DHCBILLETP(ETPRowID),"^",4) //第三方支付金额
                if ((Type="D")||(Type="T")||(Type="B"))
                {
                    s ETPAmout=-ETPAmout //第三方支付金额
                }
                s PRTAmout=$p(^ARRCP(PRTARRCPDR,"PAYM",PAYMChild),"^",3)
                if ($fn(PRTAmout,"",2)'=$fn(ETPAmout,"",2)) //发票支付金额与第三方交易支付金额不一致
                {
                    s DataSrc="User.DHCINVPRTZY"
                    s DataID=PRTRowid
                    s ErrInfo="发票表User.DHCINVPRTZY.PRTRowid:"_PRTRowid_"交易金额:"_PRTAmout_",第三方交易表DHC_BillExtTradePay.ETP_RowID:"_ETPRowID_"交易金额:"_ETPAmout_"发票支付方式金额与第三方交易支付金额不一致"
                    s ErrCode="IPBILL16"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                }
            }
        }
    }
    else
    {
        s PRTARRCPDR=$p(^DHCINVPRTZY(PRTRowid),"^",17)  
        set paymSub=0
        while($o(^DHCINVPRTZY(prtRowId,"P",paymSub))) {
            set paymSub=$o(^DHCINVPRTZY(prtRowId,"P",paymSub))
            set paymSubData=$g(^DHCINVPRTZY(prtRowId,"P",paymSub))
            continue:(paymSubData="")
            s PayModeDR= $p(paymSubData,"^",1)
            s PayModeStr=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayModeDR)
            q:PayModeStr=""
            if ($p(PayModeStr,"^",1)>0)
            {
                s ETCTradeType="IP"
                s DHCINVPRTZYFlag=..CheckNormalInv(PRTRowid,"I") //$p(^DHCINVPRTZY(PRTRowid),"^",8) //住院发票状态N 表示成功 非N 表示失败
                s ETPRowID=$o(^DHCBILLETPi(0,"TTypePRT",ETCTradeType,"PRT",PRTRowid,""),-1)
                if ((ETPRowID="")||($g(^DHCBILLETP(ETPRowID))=""))
                {
                    s DataSrc="User.DHCINVPRTZY"
                    s DataID=PRTRowid
                    s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_PRTRowid_"收费状态:"_DHCINVPRTZYFlag_"没有对应第三方交易"
                    s ErrCode="IPBILL16"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                    
                }
                s DHCBILLETPFlag=$p(^DHCBILLETP(ETPRowID),"^",1) //账单状态 第三方交易表的状态 00 表示成功，非00表示失败
                s Type=$p(^DHCBILLETP(ETPRowID),"^",26) //,C:支付,D:退费,T:退货,B:批量退货
                //if ((PRTFlag="N")&&((ETPRc'="00")||(Type'="C")))
                if ((DHCINVPRTZYFlag="N")&&((DHCBILLETPFlag'="00")))
                {
                    s DataSrc="User.DHCINVPRTZY"
                    s DataID=PRTRowid
                    s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_PRTRowid_"收费状态:"_DHCINVPRTZYFlag_"Type"_Type_"与押金表关系dhc_sfprintdetails收费状态:"_DHCBILLETPFlag_"不一致"
                    s ErrCode="IPBILL16"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                }
                //if ((PRTFlag'="N")&&((ETPRc'="00")||((Type'="D")&&(Type'="T")&&(Type'="B"))))
                if ((DHCINVPRTZYFlag'="N")&&(DHCBILLETPFlag'="00"))
                {
                    s DataSrc="User.DHCINVPRTZY"
                    s DataID=PRTRowid
                    s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_PRTRowid_"收费状态:"_DHCINVPRTZYFlag_"Type"_Type_"与押金表关系dhc_sfprintdetails收费状态:"_DHCBILLETPFlag_"不一致"
                    s ErrCode="IPBILL16"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                }
                continue:(Type="P")||(Type="S")||(Type="V") //这三种状态不判断金额
                s ETPAmout=$p(^DHCBILLETP(ETPRowID),"^",4) //第三方支付金额
                if ((Type="D")||(Type="T")||(Type="B"))
                {
                    s ETPAmout=-ETPAmout //第三方支付金额
                }
                s PRTAmout=$p(paymSubData,"^",3)
                if ($fn(PRTAmout,"",2)'=$fn(ETPAmout,"",2)) //发票支付金额与第三方交易支付金额不一致
                {
                    s DataSrc="User.DHCINVPRTZY"
                    s DataID=PRTRowid
                    s ErrInfo="发票表User.DHCINVPRTZY.PRTRowid:"_PRTRowid_"交易金额:"_PRTAmout_",第三方交易表DHC_BillExtTradePay.ETP_RowID:"_ETPRowID_"交易金额:"_ETPAmout_"发票支付方式金额与第三方交易支付金额不一致"
                    s ErrCode="IPBILL16"
                    d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
                }
            }
        }

    }
    q ""
CheckINVPRTZYToDHCBillExtTradePayErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"住院结算核查第三方支付是否成功异常:",PRTRowid,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-17
/// Description：  押金核查第三方支付是否成功
/// 1.dhc_sfprintdetail.prt_paymode,根据支付方式校验是否调用第三方接口##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(4)
/// 2.如果需要调用第三方接口dhc_sfprintdetail.RowId->DHC_BillExtTradeConSub->DHC_BillExtTradePay.ETP_Rc是否成功，是否和押金状态对应
/// 3.指定日期段
/// Table：        dhc_sfprintdetail
/// input:         
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckDHCSFPRINT("")
ClassMethod CheckDHCSFPRINT(PRTRowid)
{
    s $zt="CheckDHCSFPRINTErr"
    q:$g(^DHCSFPRINTDETAIL(PRTRowid))="" ""
    s PayModeDR= $p(^DHCSFPRINTDETAIL(PRTRowid),"^",9)
    s PayModeStr=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayModeDR)
    if ($p(PayModeStr,"^",1)>0)
    {
        s ETCTradeType="DEP"
        s PRTStatus=$p(^DHCSFPRINTDETAIL(PRTRowid),"^",8) //押金状态1正常
        s ETPRowID=$o(^DHCBILLETPi(0,"TTypePRT",ETCTradeType,"PRT",PRTRowid,""),-1)
        if ((ETPRowID="")||($g(^DHCBILLETP(ETPRowID))=""))
        {
            s DataSrc="User.dhcsfprintdetail"
            s DataID=PRTRowid
            s ErrCode="IPBILL1701"
            s ErrInfo="dhc_sfprintdetail.prtrowid:"_PRTRowid_"的押金状态:"_PRTStatus_"没有第三方交易信息"
            d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
        }
        s ETPRc=$p(^DHCBILLETP(ETPRowID),"^",1) //第三方交易状态
        s Type=$p(^DHCBILLETP(ETPRowID),"^",26) //,C:支付,D:退费,T:退货,B:批量退货
        if (((PRTStatus="1")||(PRTStatus="4"))&&((ETPRc'="00")||(Type'="C")))
        {
            s DataSrc="User.dhcsfprintdetail"
            s DataID=PRTRowid
            s ErrCode="IPBILL1701"
            s ErrInfo="dhc_sfprintdetail.prtrowid:"_PRTRowid_"的押金状态:"_PRTStatus_"DHC_BillExtTradePay.ETP_RowID"_ETPRowID_"的状态:"_ETPRc_"Type="_Type_"不对应，押金核查第三方支付失败"
            d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
        }
        if ((PRTStatus="3")&&((ETPRc'="00")||((Type'="D")&&(Type'="T")&&(Type'="B"))))
        {
            s DataSrc="User.dhcsfprintdetail"
            s DataID=PRTRowid
            s ErrCode="IPBILL1701"
            s ErrInfo="dhc_sfprintdetail.prtrowid:"_PRTRowid_"的押金状态:"_PRTStatus_"DHC_BillExtTradePay.ETP_RowID"_ETPRowID_"的状态:"_ETPRc_"Type="_Type_"不对应，押金核查第三方支付失败"
            d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
        }
        s HISVer=^||TMPCheck("HISVer")
        if (HISVer>8.4) { //从8.4后期开始，状态为2的有退费记录
            if ((PRTStatus="2")&&((ETPRc'="00")||((Type'="D")&&(Type'="T")&&(Type'="B"))))
            {
                s DataSrc="User.dhcsfprintdetail"
                s DataID=PRTRowid
                s ErrCode="IPBILL1701"
                s ErrInfo="dhc_sfprintdetail.prtrowid:"_PRTRowid_"的押金状态:"_PRTStatus_"DHC_BillExtTradePay.ETP_RowID"_ETPRowID_"的状态:"_ETPRc_"Type="_Type_"不对应，押金核查第三方支付失败"
                d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
            }
        }
        q:(Type="P")||(Type="S")||(Type="V") "" //这三种状态不判断金额
        s ETPAmout=$p(^DHCBILLETP(ETPRowID),"^",4) //第三方支付金额
        if ((Type="D")||(Type="T")||(Type="B"))
        {
            s ETPAmout=-ETPAmout //第三方支付金额
        }
        s PRTAmout=$p(^DHCSFPRINTDETAIL(PRTRowid),"^",6) //发票支付金额
        if ($fn(PRTAmout,"",2)'=$fn(ETPAmout,"",2)) //发票支付金额与第三方交易支付金额不一致
        {
            s DataSrc="User.dhcsfprintdetail"
            s DataID=PRTRowid
            s ErrInfo="dhc_sfprintdetail.prtrowid:"_PRTRowid_"交易金额:"_PRTAmout_",第三方交易表DHC_BillExtTradePay.ETP_RowID:"_ETPRowID_"交易金额:"_ETPAmout_"发票支付方式金额与第三方交易支付金额不一致"
            s ErrCode="OPBILL1103"
            d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
        }
    }
    q ""
CheckDHCSFPRINTErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"押金核查第三方支付是否成功异常:",PRTRowid,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/05/23
/// Description:计费点维护是否正确
/// 1.是否有非药品医嘱维护为CR(发药计费)
/// DHC_BillCondition.BC_Condition="CR"对应的医嘱子类BC_SubCate_Dr是非药品
/// Input:
/// Output:
/// Debug: do ##class(ZJB.QueryItemPrice).CheckBillConAndARCItemByOrderType()
ClassMethod CheckBillConAndARCItemByOrderType(a = "")
{
    s $zt="CheckBillConAndARCItemByOrderTypeErr"
    s BCRowid=0
    while ($o(^DHCTarC("BC",BCRowid)))
    {
        s BCRowid=$o(^DHCTarC("BC",BCRowid))
        s BCData=$g(^DHCTarC("BC",BCRowid))
        continue:BCData=""
        s BCCondition=$p(BCData,"^",2)
        continue:BCCondition'="CR"
        //w "BCRowid:"_BCRowid,!
        s BCSubCateDr=$p(BCData,"^",1)
        //医嘱子类ARC_ItemCat R:药品 N:诊疗 L:检验P:自定价医嘱，X：检查（与医生站的S区别），M:材料
        s ARCICOrderType=$p(^ARC("IC",BCSubCateDr),"^",7) 
        if (ARCICOrderType'="R")
        {
            //w "DHC_BillCondition.BCRowid:"_BCRowid_",错误代码：CF0101",!
            s DataSrc="User.DHCBillCondition"
            s DataID=BCRowid
            s ErrCode="CF0101"
            s ErrInfo="DHC_BillCondition.BC_RowId:"_BCRowid_"，对应ARC_ItemCat.ARCIC_RowId:"_BCSubCateDr_",ARCIC_OrderType:"_ARCICOrderType_",有非药品医嘱计费点维护为CR(发药计费)。"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
        }
    }
    q ""
CheckBillConAndARCItemByOrderTypeErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"计费点维护是否正确异常:",$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-17
/// Description：  核查患者账户表收支不平的记录
/// 1.个人账户DHC_AccManager下的流水表DHC_AccPreDeposit累加是否等于DHC_AccManager.AccM_Balance+DHC_AccPayList.AccPL_PayNum的和
/// Table：        DHC_AccManager
/// input:        
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckDHCAccMIncomeAndExpenditure()
ClassMethod CheckDHCAccMIncomeAndExpenditure(AccMRow)
{
    s $zt="CheckDHCAccMIncomeAndExpenditureErr"
    q:AccMRow="" ""
    q:$g(^DHCACD("AccM",AccMRow))="" ""
    s AccMBalance=$p(^DHCACD("AccM",AccMRow),"^",8)
    s AccPDPreSum="0"
    s AccPDSub="0"
    f //计算流水表DHC_AccPreDeposit累加金额
    {
        s AccPDSub=$o(^DHCACD("AccM",AccMRow,"AccPD",AccPDSub))
        q:AccPDSub=""
        s AccPDPreSum=AccPDPreSum+$p(^DHCACD("AccM",AccMRow,"AccPD",AccPDSub),"^",2)
    }
    s AccPLSub="0"
    s AccPLPayNum="0"
    f
    {
        s AccPLSub=$o(^DHCACD("AccM",AccMRow,"AccPL",AccPLSub))
        q:AccPLSub=""
        s AccPLPayNum=AccPLPayNum+$p(^DHCACD("AccM",AccMRow,"AccPL",AccPLSub),"^",8)
    }
    if (AccMBalance="")
    {s AccMBalance="0"}
    s AccSum=AccMBalance+AccPLPayNum
    if ($fn(AccSum,"",2))'=($fn(AccPDPreSum,"",2))
    {
        s DataSrc="User.DHCAccManager"
        s DataID=AccMRow
        s ErrInfo="患者账户表DHC_AccManager.AccMRow:"_AccMRow_"的流水表累加金额:"_AccPDPreSum_"不等于DHC_AccManager.AccM_Balance金额:"_AccMBalance_"加上DHC_AccPayList.AccPL_PayNum的金额:"_AccPLPayNum_"账户收支不平"
        s ErrCode="OPACC0101"
        d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    }
    q ""
CheckDHCAccMIncomeAndExpenditureErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"核查患者账户表收支不平的记录异常:",AccMRow,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-17
/// Description：  核查患者账户余额为负数的记录
/// Table：        DHC_AccManager
/// input:        
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckDHCAccMBalance()
ClassMethod CheckDHCAccMBalance(AccMRow)
{
    s $zt="CheckDHCAccMBalanceErr"
    q:$g(^DHCACD("AccM",AccMRow))="" ""
    s AccMBalance=$p(^DHCACD("AccM",AccMRow),"^",8)
    if (AccMBalance<"0")
    {
        s DataSrc="User.DHCAccManager"
        s DataID=AccMRow
        s ErrCode="OPACC0201"
        s ErrInfo="患者账户表DHC_AccManager.AccMRow:"_AccMRow_"的账户余额为负数"
        d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    }
    q ""
CheckDHCAccMBalanceErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"核查患者账户余额为负数的记录异常:",AccMRow,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-17
/// Description：  住院医保登记成功，费别是自费
/// 1.INSU_AdmInfo.INADM_ActiveFlag="A",
/// 2.INSU_AdmInfo.INADM_AdmDr->PA_Adm.PAADM_AdmReason_Dr->PAC_AdmReason.REA_NationalCode是否大于0    ;以及EAAdmSource是否大于0
/// 3.从日期开始查询
/// Table：        INSU_AdmInfo
/// input:         
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckINSUAdmSelfPay("")
ClassMethod CheckIPINSUAdmSelfPay(INADMRowid)
{
    s $zt="CheckINSUAdmSelfPayErr"
    q:$g(^DHCINADM(INADMRowid))="" "" 
    s INADMActiveFlag=$p(^DHCINADM(INADMRowid),"^",11)
    s INADMAdmDr=$p(^DHCINADM(INADMRowid),"^",1) //指向PAADM的指针
    quit:INADMAdmDr="" ""
    s PAADMType=$p($g(^PAADM(INADMAdmDr)),"^",2)
    quit:(PAADMType'="I") ""
    if (INADMActiveFlag="A")
    {
        s PAADMRow=$p(^DHCINADM(INADMRowid),"^",1)
        s REARowId=$p(^PAADM(PAADMRow,"1"),"^",7)
        s REANationalCode=$p(^PAC("ADMREA",REARowId),"^",5)
        s EAAdmSource=$p(^PAC("ADMREA",REARowId),"^",9)
        //if ((REANationalCode'>"0")&&(EAAdmSource'>"0"))
        if (REANationalCode'>"0")
        {
            s DataSrc="User.INSUAdmInfo"
            s DataID=INADMRowid
            s ErrInfo="医保登记INSU_AdmInfo.INADM_Rowid:"_INADMRowid_"成功，费别PAC_AdmReason.REA_RowId:"_REARowId_"是自费"
            s ErrCode="INSUDIV08"
            d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
        }
    }
    q ""
CheckINSUAdmSelfPayErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"住院医保登记成功，费别是自费异常:",INADMRowid,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-17
/// Description：  门急诊医保登记成功，费别是自费
/// 1.INSU_AdmInfo.INADM_ActiveFlag="A",
/// 2.INSU_AdmInfo.INADM_AdmDr->PA_Adm.PAADM_AdmReason_Dr->PAC_AdmReason.EAAdmSource是否大于0     ;REA_NationalCode是否大于0以及
/// 3.从日期开始查询
/// Table：        INSU_AdmInfo
/// input:         
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckINSUAdmSelfPay("")
ClassMethod CheckOPINSUAdmSelfPay(INADMRowid)
{
    s $zt="CheckINSUAdmSelfPayErr"
    q:$g(^DHCINADM(INADMRowid))="" "" 
    s INADMActiveFlag=$p(^DHCINADM(INADMRowid),"^",11)
    s INADMAdmDr=$p(^DHCINADM(INADMRowid),"^",1) //指向PAADM的指针
    quit:INADMAdmDr="" ""
    s PAADMType=$p($g(^PAADM(INADMAdmDr)),"^",2)
    quit:(PAADMType'="O")&&((PAADMType'="E")) ""
    if (INADMActiveFlag="A")
    {
        s PAADMRow=$p(^DHCINADM(INADMRowid),"^",1)
        s REARowId=$p(^PAADM(PAADMRow,"1"),"^",7)
        s REANationalCode=$p(^PAC("ADMREA",REARowId),"^",5)
        s EAAdmSource=$p(^PAC("ADMREA",REARowId),"^",9)
        //if ((REANationalCode'>"0")&&(EAAdmSource'>"0"))
        if (EAAdmSource'>"0")
        {
            s DataSrc="User.INSUAdmInfo"
            s DataID=INADMRowid
            s ErrInfo="医保登记INSU_AdmInfo.INADM_Rowid:"_INADMRowid_"成功，费别PAC_AdmReason.REA_RowId:"_REARowId_"是自费"
            s ErrCode="INSUDIV08"
            d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
        }
    }
    q ""
CheckINSUAdmSelfPayErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"门急诊医保登记成功，费别是自费异常:",INADMRowid,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-05-17
/// Description：  医保登记HIS患者身份证号与医保返回的身份证号是否一致
/// 1.INSU_AdmInfo.INADM_XString5是否等于患者基本信息的$p(^PAPER(PAPMIID,"ALL"),"^",9)
/// 2.INSU_AdmInfo.INSU_AdmInfo->PA_Adm.PAADM_PAPMI_DR
/// 3.INADM_ActiveFlag=“A”
/// 4.INADM_FunDate 从日期开始查询
/// Table：        INSU_AdmInfo
/// input:         
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckINSUAdmSelfPay("")
ClassMethod CheckINSUAdmIdNumb(INADMRowid)
{
    s $zt="CheckINSUAdmIdNumbErr"
    q:$g(^DHCINADM(INADMRowid))="" "" 
    s INADMActiveFlag=$p(^DHCINADM(INADMRowid),"^",11)
    if (INADMActiveFlag="A")
    {
        s PAADMRow=$p(^DHCINADM(INADMRowid),"^",1)
        s REANationalCode=$p(^PAC("ADMREA",$p(^PAADM(PAADMRow,"1"),"^",7)),"^",5)
        s INADMXS=$p(^DHCINADM(INADMRowid),"^",34) 
        s PAADMPAPMIDR=$p(^PAADM(PAADMRow),"^",1)
        s IDCard=$p(^PAPER(PAADMPAPMIDR,"ALL"),"^",9) 
        if (INADMXS="")
        {
            s DataSrc="User.INSUAdmInfo"
            s DataID=INADMRowid
            s ErrInfo="医保登记INSU_AdmInfo.INADM_Rowid:"_INADMRowid_"HIS患者身份证号为空"
            s ErrCode="INSUDIV09"
            d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
        }
        s INADMXS=$zcvt(INADMXS,"U")
        s IDCard=$zcvt(IDCard,"U")
        if (INADMXS'=IDCard)
        {
            s DataSrc="User.INSUAdmInfo"
            s DataID=INADMRowid
            s ErrCode="INSUDIV09"
            s ErrInfo="医保登记INSU_AdmInfo.INADM_Rowid:"_INADMRowid_"身份证号:"_INADMXS_"与患者基本信息表PA_PatMas.PAPMI_RowId:"_PAADMPAPMIDR_"的身份证号:"_IDCard_"不一致"
            d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
        }
    }
    q ""
CheckINSUAdmIdNumbErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"医保登记HIS患者身份证号与医保返回的身份证号是否一致异常:",INADMRowid,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-06-24
/// Description：  医嘱执行记录为停止或撤销但未退费的医嘱
/// 1.OE_OrdItem->OE_OrdExec.OEORE_Order_Status_DR等于D或者C的，OE_OrdExec.OEORE_Billed等于B或者P的
/// Table：        OE_OrdExec
/// input:         
/// Output：       
/// Debug：        w ##class(BILL.DC.Check).CheckOEOrdExecBilledAndOrderStatus("2022-02-01","2022-02-02")
ClassMethod CheckOEOrdExecBilledAndOrderStatus(OEORDRowId, OEORIChildsub)
{
    s $zt="CheckOEOREBilledToOEORIBilledErr"
    q:(+OEORDRowId=0)||(+OEORIChildsub="0") ""
    s OEOREChildsub="0"
    f
    {
        s OEOREChildsub=$o(^OEORD(OEORDRowId,"I",OEORIChildsub,"X",OEOREChildsub))
        q:OEOREChildsub=""
        q:$g(^OEORD(OEORDRowId,"I",OEORIChildsub,"X",OEOREChildsub))=""
        s OEOREOrderStatusDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,"X",OEOREChildsub),"^",16) //执行记录状态
        s OEOREOrderStatus=$p($g(^OEC("STAT",OEOREOrderStatusDR)),"^",1)
        if (OEOREOrderStatus="D")||(OEOREOrderStatus="C")
        {
            s OEOREBilled=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,"X",OEOREChildsub),"^",6) //医嘱状态
            if (OEOREBilled="B")||(OEOREBilled="P") 
            {
                s DataSrc="User.OEOrdItem"
                s DataID=OEORDRowId_"||"_OEORIChildsub
                s ErrInfo="OE_OrdExec.OEORE_RowId:"_DataID_"||"_OEOREChildsub_"执行记录为"_OEOREOrderStatus_"但未退费"
                s ErrCode="COM0901"
                d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
            }
        }   
    }
    q ""
CheckOEOREBilledToOEORIBilledErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"医嘱执行记录为停止或撤销但未退费的医嘱异常:",OEORDRowId_"||"_OEORIChildsub,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-06-30
/// Description：  门诊HIS结算成功，医保未结算或者结算失败
/// 1.DHCINVPRT.FLAG=“N”且找不到对应的INSU_DIVIDE或者对应的INSU_DIVIDE.FLAG不等于I的记录
/// 2.DHCINV_PRT.PRT_INSUDIV_DR对应的insu_divide不存在
/// Table：        dhc_invprt
/// input:         
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckOPSettlementANDInsuFail("")
ClassMethod CheckOPSettlementANDInsuFail(PRTRowid)
{
    s $zt="CheckOPSettlementANDInsuFailErr"
    q:$g(^DHCINVPRT(PRTRowid))="" ""
    s PRTFlagFLAG=..CheckNormalInv(PRTRowid,"O") //$p(^DHCINVPRT(PRTRowid),"^",8)
#;  s PRTPatType=$p(^DHCINVPRT(PRTRowid),"^",9)
#;  s PACAdmReasonData=$g(^PAC("ADMREA",PRTPatType))
#;  q:PACAdmReasonData="" ""
#;  s REAAdmSource=$p(PACAdmReasonData,"^",9)
#;  s REANationalCode=$p(PACAdmReasonData,"^",5)
#;  q:(REAAdmSource'>"0")&&(REANationalCode'>"0") "" //去除非医保结算的订单
    s PRTInsDivDR=$p(^DHCINVPRT(PRTRowid),"^",30)
    q:(PRTInsDivDR="") "" //去除非医保结算的订单
    s INPAYRowid=$o(^DHCINDIV("0","DHCInvPrt",PRTRowid,""),-1)
    if (PRTInsDivDR'=INPAYRowid)
    {
        s DataSrc="User.DHCINVPRT"
        s DataID=PRTRowid
        s ErrCode="OPBIL1701"
        s ErrInfo="DHC_INVPRT.PRT_Rowid:"_PRTRowid_",对应的PRTInsDivDR:"_PRTInsDivDR_"与医保表的INPAYRowid:"_INPAYRowid_"不一致"
        d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo) 
    }
    if (PRTFlagFLAG="N")&&((INPAYRowid="")||($g(^DHCINDIV(INPAYRowid))=""))
    {
        s DataSrc="User.DHCINVPRT"
        s DataID=PRTRowid
        s ErrCode="OPBIL1701"
        s ErrInfo="DHC_INVPRT.PRT_Rowid:"_PRTRowid_",医保没有结算信息"
        d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)   
    }
    q:(PRTFlagFLAG="N")&&((INPAYRowid="")||($g(^DHCINDIV(INPAYRowid))="")) ""
    s DivideData=$g(^DHCINDIV(INPAYRowid))
    if ($p(DivideData,"^",5)'="I")&&(PRTFlagFLAG="N")
    {
        s DataSrc="User.DHCINVPRT"
        s DataID=PRTRowid
        s ErrCode="OPBIL1701"
        s ErrInfo="DHC_INVPRT.PRT_Rowid:"_PRTRowid_",医保结算失败"
        d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
    }
    if ($p(DivideData,"^",5)="I")&&(PRTFlagFLAG="N")
    {
        s PRTPAPMIDR=$p(^DHCINVPRT(PRTRowid),"^",15)
        s INPAYAdmDr=$p(DivideData,"^",1)
        if (PRTPAPMIDR'=$p(^PAADM(INPAYAdmDr),"^",1))
        {
            s DataSrc="User.DHCINVPRT"
            s DataID=PRTRowid
            s ErrCode="IPBILL1701"
            s ErrInfo="DHC_INVPRT.PRT_Rowid:"_PRTRowid_",医保INSUDivide"_INPAYRowid_"发票和医保结算成功，对应不是同一人"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
        }
    }
    q ""
CheckOPSettlementANDInsuFailErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"门诊HIS结算成功，医保未结算或者结算失败异常:",PRTRowid,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-06-30
/// Description：  住院HIS结算成功，医保未结算或者结算失败
/// 1.DHCINVPRTZY.FLAG="N"且找不到对应的INSU_DIVIDE或者对应的INSU_DIVIDE.FLAG不等于I的记录
/// 2.需要根据费别判断是否调用医保接口
/// Table：        dhc_invprtzy
/// input:         
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckIPSettlementANDInsuFail("")
ClassMethod CheckIPSettlementANDInsuFail(PRTRowid)
{
    s $zt="CheckIPSettlementANDInsuFailErr"
    q:$g(^DHCINVPRTZY(PRTRowid))="" ""
    s PRTFlagFLAG=..CheckNormalInv(PRTRowid,"I") //111$p(^DHCINVPRTZY(PRTRowid),"^",8)
    //q:PRTFlagFLAG'="N" "" //去除未结算的发票
    s PRTPatType=$p(^DHCINVPRTZY(PRTRowid),"^",9)
    s PACAdmReasonData=$g(^PAC("ADMREA",PRTPatType))
    q:PACAdmReasonData="" ""
    s REAAdmSource=$p(PACAdmReasonData,"^",9)
    s REANationalCode=$p(PACAdmReasonData,"^",5)
    q:(REAAdmSource'>"0")&&(REANationalCode'>"0") "" //去除非医保结算的订单
    s PRTARPBL=$p(^DHCINVPRTZY(PRTRowid),"^",5) //账单表指针
    s INPAYRowid=$o(^DHCINDIV("0","DHCPB",PRTARPBL,""),-1)
    if (PRTFlagFLAG="N")&&((INPAYRowid="")||($g(^DHCINDIV(INPAYRowid))=""))
    {
        s DataSrc="User.DHCINVPRTZY"
        s DataID=PRTRowid
        s ErrCode="IPBILL1901"
        s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_PRTRowid_",医保没有结算信息"
        d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)   
    }
    q:(PRTFlagFLAG="N")&&((INPAYRowid="")||($g(^DHCINDIV(INPAYRowid))="")) ""
    s DivideData=$g(^DHCINDIV(INPAYRowid))
    if (($p(DivideData,"^",5)'="I"))&&(PRTFlagFLAG="N")
    {
        s DataSrc="User.DHCINVPRTZY"
        s DataID=PRTRowid
        s ErrCode="IPBILL1901"
        s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_PRTRowid_",医保INSUDivide"_INPAYRowid_"未结算或者结算失败"
        d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
    }
    if ((($p(DivideData,"^",5)="I"))&&(PRTFlagFLAG="N")) //医保和发票都结算，判断是否是同一人
    {
        s PRTAdm=$p(^DHCINVPRTZY(PRTRowid),"^",4)
        s INPAYAdmDr=$p(DivideData,"^",1)
        if ($p(^PAADM(PRTAdm),"^",1)'=$p(^PAADM(INPAYAdmDr),"^",1))
        {
            s DataSrc="User.DHCINVPRTZY"
            s DataID=PRTRowid
            s ErrCode="IPBILL1901"
            s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_PRTRowid_",医保INSUDivide"_INPAYRowid_"发票和医保结算成功，对应不是同一人"
            d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
        }
    }
    q ""
CheckIPSettlementANDInsuFailErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"住院HIS结算成功，医保未结算或者结算失败异常:",PRTRowid,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-07-05
/// Description：  医嘱项名称核查
/// 1.判断医嘱名称是否有字典中维护的特殊字符
/// Table：        CT_BILL_DC.DicData、ARC_ItmMast
/// input:        
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckARCIMDesc()
ClassMethod CheckARCIMDesc(Rowid, Ver)
{
    s $zt="CheckARCIMDescErr"
    q:(+Rowid=0)||(+Ver=0) ""
    q:$g(^ARCIM(Rowid,Ver),1)="" ""
    s ARCIMDesc=$p(^ARCIM(Rowid,Ver,1),"^",2)
    s DicDataRowID="0"
    f
    {
        s DicDataRowID=$o(^CT.BILL.DC.DicDataI("IndexDicTypeHosp",^||TMPCheck("HospDr"),"TarItmSpeChar",DicDataRowID))
        q:DicDataRowID=""
        q:^CT.BILL.DC.DicDataD(DicDataRowID)=""
        s DicDataDicDesc=$lg(^CT.BILL.DC.DicDataD(DicDataRowID),1)
        if (ARCIMDesc[($c(DicDataDicDesc)))
        {
            s DataSrc="User.ARCItmMast"
            s DataID=Rowid_"||"_Ver
            s ErrInfo="User.ARCItmMast:"_DataID_"包含特殊字符"_($c(DicDataDicDesc))
            s ErrCode="CT0801"
            d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
        }
    }
    q ""
CheckARCIMDescErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"医嘱项名称核查异常:",Rowid_"||"_Ver,$ze)
    q ""
}

/// Creator：      Lizhi
/// CreatDate：    2022-07-05
/// Description：  收费项目名称核查
/// 1.判断收费项目名称是否有字典中维护的特殊字符
/// Table：        CT_BILL_DC.DicData、DHC_TarItem
/// input:        
/// Output：       
/// Debug：        d ##class(BILL.DC.Check).CheckTARIDesc()
ClassMethod CheckTARIDesc(Rowid)
{
    s $zt="CheckTARIDescErr"
    q:$g(^DHCTARI(Rowid))="" ""
    s TARIDesc=$p(^DHCTARI(Rowid),"^",2)
    s DicDataRowID="0"
    f
    {
        s DicDataRowID=$o(^CT.BILL.DC.DicDataI("IndexDicTypeHosp",^||TMPCheck("HospDr"),"TarItmSpeChar",DicDataRowID))
        q:DicDataRowID=""
        q:^CT.BILL.DC.DicDataD(DicDataRowID)=""
        s DicDataDicDesc=$lg(^CT.BILL.DC.DicDataD(DicDataRowID),1)
        if (TARIDesc[($c(DicDataDicDesc)))
        {
            s DataSrc="User.DHCTarItem"
            s DataID=Rowid
            s ErrInfo="User.DHCTarItem:"_DataID_"包含特殊字符"_($c(DicDataDicDesc))
            s ErrCode="CT0802"
            d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
        }
    }
    q ""
CheckTARIDescErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"收费项目名称核查异常:",Rowid,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/05/23
/// Description:医保登记：入院主诊断代码和名称是否正确
/// 1.INSU_AdmInfo.XString1诊断编码
/// INSU_AdmInfo.XString2诊断名称是否和接口返回值一样
/// w ##class(web.DHCINSUPortUse).GetPatAllDiagsByADM("6","C008","^^")
/// 2.根据日期查询INSU_AdmInfo.INADM_FunDate
/// 3.只查INADM_ActiveFlag=A，只查住院INADM_AdmDr->PAADM_AdmType="I"
/// Input:
/// Output:
/// Debug: do ##class(BILL.DC.Check).CheckINSUAdmInfoXSByINADMRowid(12)
ClassMethod CheckINSUAdmInfoXSByINADMRowid(INADMRowid)
{
    s $zt="CheckINSUAdmInfoXSByINADMRowidErr"
    if INADMRowid="" quit $$$OK
    s INADMData=$g(^DHCINADM(INADMRowid))
    s INADMActiveFlag=$p(INADMData,"^",11) //有效标志w
    //w "INADMActiveFlag:",INADMActiveFlag,!
    quit:INADMActiveFlag'="A" ""
    s INADMXString1=$p(INADMData,"^",26) //入院诊断编码
    s INADMXString2=$p(INADMData,"^",27) //入院诊断名称
    
    s INADMAdmDr=$p(INADMData,"^",1) //指向PAADM的指针
    //w "INADMAdmDr:"_INADMAdmDr,!
    quit:INADMAdmDr="" ""
    s PAADMType=$p($g(^PAADM(INADMAdmDr)),"^",2)
    //w "PAADMType:",PAADMType,!
    quit:PAADMType'="I" ""
    //通过就诊号取病人所有诊断信息。
    s GetPatAdm=##class(web.DHCINSUPortUse).GetPatAllDiagsByADM(INADMAdmDr,"C008","^^")
    b //INADMXString1,INADMXString2
    if (GetPatAdm="")
    {
        s DataSrc="User.INSUAdmInfo"
        s DataID=INADMRowid
        s ErrCode="INSUDIV1001"
        s ErrInfo="INSU_AdmInfo.INADM_Rowid:"_INADMRowid_",医保登记表诊断:"_INADMXString2_",his诊断为空"
        //w "INSU_AdmInfo.INADM_Rowid:"_INADMRowid_",医保登记表没有对应入院诊断。"
        d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
    }
    //w "GetPatAdm:",GetPatAdm,! 
    quit:GetPatAdm="" ""
    s DiagnosisCode=$p(GetPatAdm,"^",3) //获取诊断编码
    s DiagnosisDesc=$p(GetPatAdm,"^",4) //获取诊断名称
    //w "接口返回诊断编码："_DiagnosisCode_",诊断名称："_DiagnosisDesc,!
    b //INADMXString1 DiagnosisCode INADMXString2 DiagnosisDesc
    if (DiagnosisCode="")||(DiagnosisDesc="")
    {
        s DataSrc="User.INSUAdmInfo"
        s DataID=INADMRowid
        s ErrCode="INSUDIV1001"
        s ErrInfo="INSU_AdmInfo.INADM_Rowid:"_INADMRowid_",医保登记表诊断:"_INADMXString2_",his诊断为空"
        //w "INSU_AdmInfo.INADM_Rowid:"_INADMRowid_",医保登记表没有对应入院诊断。"
        d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
    }
    if (INADMXString1'=DiagnosisCode)||(INADMXString2'=DiagnosisDesc)
    {
        s DataSrc="User.INSUAdmInfo"
        s DataID=INADMRowid
        s ErrCode="INSUDIV1002"
        s ErrInfo="INSU_AdmInfo.INADM_Rowid:"_INADMRowid_",医保登记表诊断："_INADMXString2_",his诊断："_DiagnosisDesc_",医保表存的入院诊断和HIS不一致。"
        //w "INSU_AdmInfo.INADM_Rowid:"_INADMRowid_",医保登记表诊断："_INADMXString2_",获取病人诊断："_DiagnosisDesc_",医保表存的入院诊断和HIS不一致。"
        d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
    }
    q ""
CheckINSUAdmInfoXSByINADMRowidErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"入院主诊断代码和名称是否正确异常:",INADMRowid,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/05/23
/// Description:检验门诊发票对应的医保记录日期是否同一天
/// 1.DHC_INVPRT.PRT_InsDiv_DR->INSU_Divide
/// 2.判断DHC_INVPRT.PRT_Date是否=INSU_Divide.INPAY_iDate
/// 3.通过日期查询发票表
/// 4.只查正常发票的记录
/// Input:
/// Output:
/// Debug: do ##class(ZJB.QueryItemPrice).CheckOPInvPrtAndDivideByDate("")
ClassMethod CheckOPInvPrtAndDivideByDate(InvRowid)
{
    s $zt="CheckOPInvPrtAndDivideByDateErr"
    //^DHCINVPRT({PRT_Rowid})
    if InvRowid=""  quit $$$OK
    s InvPrtData=$g(^DHCINVPRT(InvRowid))
    q:InvPrtData="" ""
    s PRTFlag=..CheckNormalInv(InvRowid,"O") //$p(InvPrtData,"^",8) //发票状态
    q:PRTFlag'="N" ""
    q:..IsOPInvPassRePrint(InvRowid)="1" "" //过号重打不算
    s PRTDT=$p(InvPrtData,"^",5) //发票 收费日期
    s PRTDate=$p(PRTDT," ",1) //取日期
    s PRTInsDivDR=$p(InvPrtData,"^",30) //指向INSU_Divide表
    q:PRTInsDivDR="" ""
    s DivideData=$g(^DHCINDIV(PRTInsDivDR))
    q:DivideData="" ""
    s INPAYiDT=$p(DivideData,"^",16) //医保结算表 结算日期
    s INPAYiDate=$p(INPAYiDT," ",1) //取日期
    if PRTDate'=INPAYiDate
    {
        //w "Dhc_invprt.Rowid:"_InvRowid_",OPBILL1601,发票日期与医保结算表结算日期不一致。",!
        s DataSrc="User.DHCINVPRT"
        s DataID=InvRowid
        s ErrCode="OPBILL1601"
        s ErrInfo="DHC_INVPRT.PRT_Rowid:"_InvRowid_",门诊发票表日期："_$zd(PRTDate,3)_",INSU_Divide.INPAY_Rowid:"_PRTInsDivDR_",医保记录日期:"_$zd(INPAYiDate,3)_",发票对应的医保记录日期不是同一天。"
        d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
    }
    q ""
CheckOPInvPrtAndDivideByDateErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"检验门诊发票对应的医保记录日期是否同一天异常:",InvRowid,$ze)
    q ""
}

/// Creator: zjb
/// CreatDate:2022/05/23
/// Description:检验住院发票对应的医保记录日期是否同一天
/// 1.DHC_INVPRTZY->DHC_PatientBill->INSU_Divide
/// 2.判断DHC_INVPRTZY.PRT_Date是否=INSU_Divide.INPAY_iDate
/// 3.通过日期查询发票表
/// 4.只查正常发票的记录
/// Input:
/// Output:
/// Debug: do ##class(ZJB.QueryItemPrice).CheckIPInvPrtAndDivideByDate("")
ClassMethod CheckIPInvPrtAndDivideByDate(InvRowid)
{
    s $zt="CheckIPInvPrtAndDivideByDateErr"
    //^DHCINVPRT({PRT_Rowid})
    if InvRowid="" quit $$$OK
    s InvPrtData=$g(^DHCINVPRTZY(InvRowid))
    s PRTFlag=..CheckNormalInv(InvRowid,"I") //$p(InvPrtData,"^",8) //发票状态
    q:PRTFlag'="N" ""
    s PRTDT=$p(InvPrtData,"^",2) //发票 收费日期
    s PRTDate=$p(PRTDT," ",1) //取日期
    s PRTARPBL=$p(InvPrtData,"^",5) //账单表指针
    s INPAYRowid=$o(^DHCINDIV("0","DHCPB",PRTARPBL,0))
    q:INPAYRowid="" ""
    s DivideData=$g(^DHCINDIV(INPAYRowid))
    q:DivideData="" ""
    s INPAYiDT=$p(DivideData,"^",16) //医保结算表 结算日期
    s INPAYiDate=$p(INPAYiDT," ",1) //取日期
    if PRTDate'=INPAYiDate
    {
        s DataSrc="User.DHCINVPRTZY"
        s DataID=InvRowid
        s ErrCode="IPBILL1801"
        s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_InvRowid_",住院发票表日期："_$zd(PRTDate,3)_",INSU_Divide.INPAY_Rowid:"_INPAYRowid_",医保记录日期:"_$zd(INPAYiDate,3)_",发票对应的医保记录日期不是同一天。"
        d ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
        //w "Dhc_invprt.Rowid:"_InvRowid_",OPBILL1601,发票日期与医保结算表结算日期不一致。",!
    }
    q ""
CheckIPInvPrtAndDivideByDateErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"检验住院发票对应的医保记录日期是否同一天异常:",InvRowid,$ze)
    q ""
}

/// Creator：      tangzf
/// CreatDate：    2022-05-12
/// Description：  门诊正常发票没有对应的账单
/// Table：        
/// input:         
/// Output：       
/// Debug：        
///  d ##class(web.DataCheckTest).CheckOrdBillFlag("2022-4-03","2022-5-12")
ClassMethod CheckOPInvBillFlag(INV)
{
    s $zt="CheckOPInvBillFlagErr"
    q:$g(^DHCINVPRT(INV))="" ""
    s INVFlag=..CheckNormalInv(INV,"O") //$p(^DHCINVPRT(INV),"^",8)
    quit:INVFlag'="N" ""
    s FindBill=""
    s BillConINV=$o(^DHCBCI(0,"INV",INV,""))
    i (BillConINV'="")  d
    .s Bill=$p($g(^DHCBCI(BillConINV)),"^",2)
    .s BillFlag=$p($g(^DHCPB(Bill)),"^",16)
    .q:BillFlag'="P" // 异常:未计费账单
    .s FindBill="Y"
    
    i FindBill'="Y" d
    .s DataSrc="User.DHCINVPRT"
    .s DataID=INV
    .s ErrCode="OPBILL1201"
    .s ErrInfo="DHC_INVPRT.PRT_Rowid:"_INV_",门诊正常发票没有对应的账单"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    q ""
    ;w:FindBill'="Y" "INV:"_INV_"-门诊正常发票没有对应的账单",!
CheckOPInvBillFlagErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"门诊正常发票没有对应的账单异常:",INV,$ze)
    q ""
}

/// Creator：      tangzf
/// CreatDate：    2022-05-12
/// Description：  住院正常发票没有对应的账单
/// Table：        
/// input:         
/// Output：       
/// Debug：        
///  d ##class(web.DataCheckTest).CheckOrdBillFlag("2022-4-03","2022-5-12")
ClassMethod CheckIPInvBillFlag(IPINV)
{
    s $zt="CheckIPInvBillFlagErr"
    s INVFlag=..CheckNormalInv(IPINV,"I") //$p($g(^DHCINVPRTZY(IPINV)),"^",8)
    q:(INVFlag'="N")&&(INVFlag'="I") ""
    s Bill=$p($g(^DHCINVPRTZY(IPINV)),"^",5)
    s BillFlag=$p($g(^DHCPB(Bill)),"^",16)
    
    i $g(^DHCPB(Bill))=""  d
    .s DataSrc="User.DHCINVPRTZY"
    .s DataID=IPINV
    .s ErrCode="IPBILL1801"
    .s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_IPINV_",住院正常发票没有对应的账单"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    .;set ^TMPInvAndBillAmt("Amt",InvRowid)="DHC_INVPRT.PRT_Rowid:"_InvRowid_",DHC_PatientBill.PB_RowId:"_DHCBCIPatBillDR_",错误代码：OPBILL0501，错误信息：门诊发票和账单的总金额不平。"
    e  i (BillFlag'="P")  d
    .s DataSrc="User.DHCINVPRTZY"
    .s DataID=IPINV
    .s ErrCode="IPBILL1802"
    .s ErrInfo="DHC_INVPRTZY.PRT_Rowid:"_IPINV_"账单状态为"_BillFlag_",住院正常发票对应账单状态不正确"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode)
    .;set ^TMPInvAndBillAmt("Amt",InvRowid)="DHC_INVPRT.PRT_Rowid:"_InvRowid_",DHC_PatientBill.PB_RowId:"_DHCBCIPatBillDR_",错误代码：OPBILL0501，错误信息：门诊发票和账单的总金额不平。"
    
    ;w:BillFlag'="P" "INV:"_IPINV_"-住院正常发票没有对应的账单",! // 异常:未计费账单
    q ""
CheckIPInvBillFlagErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"住院正常发票没有对应的账单异常:",IPINV,$ze)
    q ""
}

/// Creator：      tangzf
/// CreatDate：    2022-05-12
/// Description：  查找门诊已计费账单是否有对应发票记录  必须在医嘱的基础上进行查询，否则无法处理不需要发票的情况
///                 有哪些正常情况下账单没有对应发票记录
/// Table：        仅供 CheckOrdBillFlag方法    调用
/// input:         
/// Output：       
/// Debug：        
///  d ##class(web.DataCheckTest).CheckOrdBillFlag("2022-4-03","2022-5-12")
ClassMethod CheckBillOPInvFlag(BILL)
{
    s $zt="CheckBillOPInvFlagErr"
    s BILLFlag=$p(^DHCPB(BILL),"^",16)
    q:BILLFlag'="P" ""
    s FindINV=""
    s BillConINV=$o(^DHCBCI(0,"Bill",BILL,""),-1)
    i BillConINV'=""  d
    .s INV=$p($g(^DHCBCI(BillConINV)),"^",1)
    .s INVFlag=..CheckNormalInv(INV,"O") //$p($g(^DHCINVPRT(INV)),"^",8)
    .i INVFlag="N" d  
    ..s FindINV="Y"
    i FindINV'="Y"  d
    .s DataSrc="User.DHCPatientBill"
    .s DataID=BILL
    .s ErrCode="OPBILL1501"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode)
    .;w BILL_"异常，门诊 计费账单没有对应有效发票",!
    q FindINV
CheckBillOPInvFlagErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"查找门诊已计费账单是否有对应发票记录异常:",BILL,$ze)
    q ""
}

/// Creator：      tangzf
/// CreatDate：    2022-05-12
/// Description：  查找住院已计费账单是否有对应发票记录 必须在医嘱的基础上进行查询，否则无法处理不需要发票的情况
///                 有哪些正常情况下账单没有对应发票记录
/// Table：     仅供 CheckOrdBillFlag方法   调用
/// input:         
/// Output：       
/// Debug：        
///  d ##class(web.DataCheckTest).CheckBillIPInvFlag("2022-4-03","2022-5-12")
ClassMethod CheckBillIPInvFlag(BILL)
{
    s $zt="CheckBillIPInvFlagErr"
    s BILLFlag=$p(^DHCPB(BILL),"^",16)
    q:BILLFlag'="P" ""
    s FindINV=""
    s INV=$o(^DHCINVPRTZY("0","AR",BILL,""),-1)
    i INV'=""  d
    .s INVFlag=..CheckNormalInv(INV,"I") //$p(^DHCINVPRTZY(INV),"^",8)
    .s:(INVFlag="N")||(INVFlag="I") FindINV="Y"
    i FindINV'="Y"  d
    .s DataSrc="User.DHCPatientBill"
    .s DataID=BILL
    .s ErrCode="IPBILL2001"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode)
    .;w BILL_"异常，住院计费账单没有对应有效发票",!
    q FindINV
CheckBillIPInvFlagErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"查找住院已计费账单是否有对应发票记录异常:",BILL,$ze)
    q ""
}

/// Creator：      tangzf
/// CreatDate：    2022-05-12
/// Description：  已收费医嘱是否有对应的计费的账单（查漏费）
///                     在哪些情况下 已计费医嘱可以没有对应的计费账单？
/// Table：        
/// input:         
/// Output：       
/// Debug：        
///  d ##class(web.DataCheckTest).CheckOrdBillFlag("2022-4-03","2022-5-12")
ClassMethod CheckOrdBillFlag(OEORD, OEORI, OEORIDate)
{
    s $zt="CheckOrdBillFlagErr"
    q:+OEORI=0 ""
    s ADM=$p($g(^OEORD(+OEORD)),"^",1)
    s HospDr=""
    s DepCodeDR=$P(^PAADM(ADM),"^",4)
    s:DepCodeDR'="" HospDr=$P(^CTLOC(DepCodeDR),"^",22)
    s PAPMI=$p($g(^PAADM(ADM)),"^",1)
    s RegNo=$p(^PAPER(PAPMI,"PAT",1),"^",1)
    
    s ADMType=$p($g(^PAADM(ADM)),"^",2)
    q:(ADMType="H") "" // 体检 有计费账单，但是没对于门诊发票 所以不在此判断
    
    s OEORIBilled=$p($g(^OEORD(OEORD,"I",OEORI,3)),"^",5)
    q:OEORIBilled'="P" "" //未收费医嘱
    
    s myPriorFlag=..ReadOECPriorityFlag(OEORD_"||"_OEORI)
    q:(+myPriorFlag=1) ""   //自备药品退出 是没有计费账单还是没有发票？ 如果是没有发票换个地方判断
    
    s TransFLag=..OrdIsOPToIPByOEORI(OEORD_"||"_OEORI)
    q:(ADMType'="I")&&(TransFLag="1") "" // 门诊 直接过滤门急诊转住院的医嘱，在住院进行校验
    
    s ArcItmMast=$p($g(^OEORD(OEORD,"I",OEORI,1)),"^",2)
    s PatSelfPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ArcItmMast,OEORIDate,"","","","",HospDr,"")
    //----------------------------此处还需要增加条件维护了价格可以为0的项目
    q:+$p(PatSelfPrice,"^",4)=0 "" // 价格为0的医嘱是没账单还是没发票？
    
    s ArcItmDesc=$p(^ARCIM(+ArcItmMast,$p(ArcItmMast,"||",2),1),"^",2)
    s OEORITime=$p($g(^OEORD(OEORD,"I",OEORI,3)),"^",15)

    s FindBill=""
    s FindINV=""
    s BILL=""
    for  s BILL=$o(^DHCPBi("0","OEORI",OEORD_"||"_OEORI,BILL)) q:BILL=""  d //根据医嘱找账单
    .s BILLFlag=$p($g(^DHCPB(BILL)),"^",16)
    .q:BILLFlag'="P" // 异常:未计费账单
    .s RefundFlag=$p($g(^DHCPB(BILL)),"^",17)
    .q:RefundFlag="R"
    .s PBO=$o(^DHCPBi("0","OEORI",OEORD_"||"_OEORI,BILL,0))
    .q:PBO="" // 异常:PBO不存在
    .s TotalAmt=$p($g(^DHCPB(BILL,"O",PBO)),"^",8)
    .s PatAmt=$p($g(^DHCPB(BILL,"O",PBO)),"^",11)
    .s DiscAmt=$p($g(^DHCPB(BILL,"O",PBO)),"^",9)
    .s PayorAmt=$p($g(^DHCPB(BILL,"O",PBO)),"^",10)
    .i (+TotalAmt)=0  d //总金额为0 此处还需要增加条件判断维护了价格可以为0的项目
    ..s FindINV="Y"
    ..s FindBill="Y"
    .q:+TotalAmt=0 // 不计0费用
    .s FindBill="Y" // 账单正常
    .// 开始查找发票
    .i ADMType="I"  d // IP
    ..s FindINV=..CheckBillIPInvFlag(BILL)
    .e  d //OP 
    ..s FindINV=..CheckBillOPInvFlag(BILL)
    s AdmTypeDesc=$case(ADMType,"I":"住院",:"门诊")
    
    s rowid=""
    s CKRRowId=$o(^||TMPCheck("CKRRowId",""))
    i (FindBill'="Y") d
    .s DataSrc="User.OEOrdItem"
    .s DataID=OEORD_"||"_OEORI
    .s ErrCode=$case(ADMType,"I":"IPBILL1901",:"OPBILL1301")
    .s ErrInfo="已收费医嘱："_OEORD_"||"_OEORI_",没有对应的账单"
    .d ..SaveExInfo(DataSrc, DataID, ErrCode)
    q ""
    ;w:FindBill'="Y" $zd(OEORIDate,3)_$zt(OEORITime)_"RegNo:"_RegNo_"-"_AdmTypeDesc_"已计费医嘱："_OEORD_"||"_OEORI_ArcItmDesc_",没有对应的账单",!
    ;w:(FindBill="Y")&&(FindINV'="Y") $zd(OEORIDate,3)_$zt(OEORITime)_"RegNo:"_RegNo_"-"_AdmTypeDesc_"已计费医嘱："_OEORD_"||"_OEORI_ArcItmDesc_",有收费账单，但是没发票",!
CheckOrdBillFlagErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"已计费医嘱是否有对应的计费的账单异常:",OEORD_"||"_OEORI,$ze)
    q ""
}

/// Creator: ZhYW
/// CreatDate: 2022-03-22
/// Description: 门诊收费收入金额质控
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.QC.BL.OPDailyHandin).CheckOPChgAcount()
ClassMethod CheckOPChgAcount(footId As %String) As %String
{
    s $zt="CheckOPChgAcountErr"
    set rtn=0
    
    set rptTotalSum=0
    
    set cateSub=0
    while($o(^DHCOPInsFoot(footId,"C",cateSub))) {
        set cateSub=$o(^DHCOPInsFoot(footId,"C",cateSub))
        set subData=$g(^DHCOPInsFoot(footId,"C",cateSub))
        continue:(subData="")
        set tarType=$p(subData,"^",4)
        continue:(tarType'="OP")
        set payAmt=$p(subData,"^",5) //子分类收费金额
        set refAmt=$p(subData,"^",6) //子分类退费金额
        set amt=payAmt+refAmt
        set rptTotalSum=$i(rptTotalSum,amt)
    }
    set rptTotalSum=$fn(rptTotalSum,"",2)
    
    //门诊收费小条表
    set bizTotalSum=0
    set prtRowId=0
    while($o(^DHCINVPRT(0,"Report",footId,prtRowId))) {
        set prtRowId=$o(^DHCINVPRT(0,"Report",footId,prtRowId))
        set prtData=$g(^DHCINVPRT(prtRowId))
        set prtAcount=$p(prtData,"^",1)
        set bizTotalSum=$i(bizTotalSum,prtAcount)
    }
    set bizTotalSum=$fn(bizTotalSum,"",2)
    
    if (+rptTotalSum'=+bizTotalSum) {
        s DataSrc="DHC_INVPRTReports"
        s DataID=footId
        s ErrCode="BILLREP0301"
        s ErrInfo="DHC_INVPRTReports.footId"_footId_",日结支付方式总额:"_rptTotalSum_"不等于门诊收费收入金额表合计:"_bizTotalSum
        d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    }
    
    quit rtn
CheckOPChgAcountErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"门诊收费收入金额质控异常:",footId,$ze)
    q ""
}

/// Creator: ZhYW
/// CreatDate: 2022-03-22
/// Description: 门诊收费支付方式金额质控
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.QC.BL.OPDailyHandin).CheckOPChgPayM()
ClassMethod CheckOPChgPayM(footId As %String) As %String
{
    s $zt="CheckOPChgPayMErr"
    set rtn=0
    
    set rptTotalSum=0
    
    set paymSub=0
    while($o(^DHCOPInsFoot(footId,"P",paymSub))) {
        set paymSub=$o(^DHCOPInsFoot(footId,"P",paymSub))
        set subData=$g(^DHCOPInsFoot(footId,"P",paymSub))
        continue:(subData="")
        set bizType=$p(subData,"^",22)
        continue:(bizType'="OP")
        set payAmt=$p(subData,"^",2)        //收费金额
        set refAmt=$p(subData,"^",4)        //退费金额
        set amt=payAmt+refAmt
        set rptTotalSum=$i(rptTotalSum,amt)
    }
    set rptTotalSum=$fn(rptTotalSum,"",2)
    
    //门诊收费小条
    set bizTotalSum=0
    set prtRowId=0
    while($o(^DHCINVPRT(0,"Report",footId,prtRowId))) {
        set prtRowId=$o(^DHCINVPRT(0,"Report",footId,prtRowId))
        set paymSub=0
        while($o(^DHCINVPRT(prtRowId,"P",paymSub))) {
            set paymSub=$o(^DHCINVPRT(prtRowId,"P",paymSub))
            set subData=$g(^DHCINVPRT(prtRowId,"P",paymSub))
            continue:(subData="")
            set amt=$p(subData,"^",3)
            set bizTotalSum=$i(bizTotalSum,amt)
        }
    }
    set bizTotalSum=$fn(bizTotalSum,"",2)
    
    if (+rptTotalSum'=+bizTotalSum) {
        s DataSrc="DHC_INVPRTReports"
        s DataID=footId
        s ErrCode="BILLREP0301"
        s ErrInfo="DHC_INVPRTReports.footId"_footId_",日结支付方式总额:"_rptTotalSum_"不等于门诊收费支付方式表合计:"_bizTotalSum
        d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    }
    
    quit rtn
CheckOPChgPayMErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"门诊收费支付方式金额质控异常:",footId,$ze)
    q ""
}

/// Creator: ZhYW
/// CreatDate: 2022-03-22
/// Description: 卡费支付方式金额质控
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.QC.BL.OPDailyHandin).CheckCardPayM()
ClassMethod CheckCardPayM(footId As %String) As %String
{
    s $zt="CheckCardPayMErr"
    set rtn=0
    
    set rptTotalSum=0
    
    set paymSub=0
    while($o(^DHCOPInsFoot(footId,"P",paymSub))) {
        set paymSub=$o(^DHCOPInsFoot(footId,"P",paymSub))
        set subData=$g(^DHCOPInsFoot(footId,"P",paymSub))
        continue:(subData="")
        set bizType=$p(subData,"^",22)
        continue:(bizType'="OP")&&(bizType'="")
        set payAmt=$p(subData,"^",14)       //建卡金额
        set refAmt=$p(subData,"^",16)       //退卡金额
        set amt=payAmt+refAmt
        set rptTotalSum=$i(rptTotalSum,amt)
    }
    set rptTotalSum=$fn(rptTotalSum,"",2)
    
    //卡费
    set bizTotalSum=0
    set prtRowId=0
    while($o(^DHCCARDINVPRTi(0,"Report",footId,prtRowId))) {
        set prtRowId=$o(^DHCCARDINVPRTi(0,"Report",footId,prtRowId))
        set paymSub=0
        while($o(^DHCCARDINVPRT(prtRowId,"P",paymSub))) {
            set paymSub=$o(^DHCCARDINVPRT(prtRowId,"P",paymSub))
            set subData=$g(^DHCCARDINVPRT(prtRowId,"P",paymSub))
            continue:(subData="")
            set amt=$p(subData,"^",3)
            set bizTotalSum=$i(bizTotalSum,amt)
        }
    }
    set bizTotalSum=$fn(bizTotalSum,"",2)
    
    if (+rptTotalSum'=+bizTotalSum) {
        s DataSrc="DHC_INVPRTReports"
        s DataID=footId
        s ErrCode="BILLREP0301"
        s ErrInfo="DHC_INVPRTReports.footId"_footId_",日结支付方式总额:"_rptTotalSum_"不等于卡费支付方式表合计:"_bizTotalSum
        d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    }
    
    quit rtn
CheckCardPayMErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"卡费支付方式金额质控异常:",footId,$ze)
    q ""
}

/// Creator: ZhYW
/// CreatDate: 2022-03-22
/// Description: 门诊预交金支付方式金额质控
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.QC.BL.OPDailyHandin).CheckOPPrePayM()
ClassMethod CheckOPPrePayM(footId As %String) As %String
{
    s $zt="CheckOPPrePayMErr"
    set rtn=0
    
    set rptTotalSum=0
    
    set paymSub=0
    while($o(^DHCOPInsFoot(footId,"P",paymSub))) {
        set paymSub=$o(^DHCOPInsFoot(footId,"P",paymSub))
        set subData=$g(^DHCOPInsFoot(footId,"P",paymSub))
        continue:(subData="")
        set bizType=$p(subData,"^",22)
        continue:(bizType'="OP")&&(bizType'="")
        set payAmt=$p(subData,"^",10)     //收预交金金额
        set refAmt=$p(subData,"^",12)     //退预交金金额
        set amt=payAmt+refAmt
        set rptTotalSum=$i(rptTotalSum,amt)
    }
    set rptTotalSum=$fn(rptTotalSum,"",2)
    
    //门诊预交金
    set bizTotalSum=0
    set accM=0
    while($o(^DHCACDi("AccM",0,"PDFootDR",footId,accM))) {
        set accM=$o(^DHCACDi("AccM",0,"PDFootDR",footId,accM))
        set preSub=0
        while($o(^DHCACDi("AccM",0,"PDFootDR",footId,accM,"AccPD",preSub))) {
            set preSub=$o(^DHCACDi("AccM",0,"PDFootDR",footId,accM,"AccPD",preSub))
            set paymSub=0
            while($o(^DHCACD("AccM",accM,"AccPD",preSub,"P",paymSub))) {
                set paymSub=$o(^DHCACD("AccM",accM,"AccPD",preSub,"P",paymSub))
                set accPMData=$g(^DHCACD("AccM",accM,"AccPD",preSub,"P",paymSub))
                set amt=$p(accPMData,"^",6)
                set bizTotalSum=$i(bizTotalSum,amt)
            }
        }
    }
    set bizTotalSum=$fn(bizTotalSum,"",2)
    
    if (+rptTotalSum'=+bizTotalSum) {
        s DataSrc="DHC_INVPRTReports"
        s DataID=footId
        s ErrCode="BILLREP0301"
        s ErrInfo="DHC_INVPRTReports.footId"_footId_",日结支付方式总额:"_rptTotalSum_"不等于门诊预交金支付方式表合计:"_bizTotalSum
        d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    }
    
    quit rtn
CheckOPPrePayMErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"门诊预交金支付方式金额质控异常:",footId,$ze)
    q ""
}

/// Creator: ZhYW
/// CreatDate: 2022-03-22
/// Description: 门诊留观押金支付方式金额质控
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.QC.BL.OPDailyHandin).CheckEPPrePayM()
ClassMethod CheckEPPrePayM(footId As %String) As %String
{
    s $zt="CheckEPPrePayMErr"
    set rtn=0
    
    set rptTotalSum=0
    
    set paymSub=0
    while($o(^DHCOPInsFoot(footId,"P",paymSub))) {
        set paymSub=$o(^DHCOPInsFoot(footId,"P",paymSub))
        set subData=$g(^DHCOPInsFoot(footId,"P",paymSub))
        continue:(subData="")
        set bizType=$p(subData,"^",22)
        continue:(bizType'="OP")&&(bizType'="")
        set payAmt=$p(subData,"^",18)       //留观押金收费金额
        set refAmt=$p(subData,"^",20)       //留观押金退费金额
        set amt=payAmt+refAmt
        set rptTotalSum=$i(rptTotalSum,amt)
    }
    set rptTotalSum=$fn(rptTotalSum,"",2)
    
    //留观押金
    set bizTotalSum=0
    set accM=0
    while($o(^DHCEPMi("EPM",0,"EPMDReport",footId,accM))) {
        set accM=$o(^DHCEPMi("EPM",0,"EPMDReport",footId,accM))
        set preSub=0
        while($o(^DHCEPMi("EPM",0,"EPMDReport",footId,accM,"EPMD",preSub))) {
            set preSub=$o(^DHCEPMi("EPM",0,"EPMDReport",footId,accM,"EPMD",preSub))
            if (preSub'=""){
                set paymSub=0
                while($o(^DHCEPM("EPM",accM,"EPMD",preSub,"P",paymSub))) {
                    set paymSub=$o(^DHCEPM("EPM",accM,"EPMD",preSub,"P",paymSub))
                    set accPMData=$g(^DHCEPM("EPM",accM,"EPMD",preSub,"P",paymSub))
                    set amt=$p(accPMData,"^",6)
                    set bizTotalSum=$i(bizTotalSum,amt)
                }
            }
        }
    }
    set bizTotalSum=$fn(bizTotalSum,"",2)
    
    if (+rptTotalSum'=+bizTotalSum) {
        s DataSrc="DHC_INVPRTReports"
        s DataID=footId
        s ErrCode="BILLREP0301"
        s ErrInfo="DHC_INVPRTReports.footId"_footId_",日结支付方式总额:"_rptTotalSum_"不等于留观押金明细表合计:"_bizTotalSum
        d ..SaveExInfo(DataSrc, DataID, ErrCode,ErrInfo)
    }
    
    quit rtn
CheckEPPrePayMErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"门诊留观押金支付方式金额质控异常:",footId,$ze)
    q ""
}

/*
ClassMethod CheckPBOAndOeore(PBRow, PBOChild) As %String
{
    s $zt="CheckPBOAndOeoreErr"
    s MissExecList=""
    s rtn=##class(web.DHCDocMain).CheckExecValidity(OEORDRowId_"||"_OEORIChildsub, .MissExecList)
    
    quit rtn
CheckPBOAndOeoreErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"门诊留观押金支付方式金额质控异常:",footId,$ze)
    q ""
}*/
/// Creator: tangzf
/// CreatDate: 2023-01-06
/// Description: 异常数据监控增加一指标用于监测住院账单医嘱表的执行记录rowid为空的异常数据。
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.QC.BL.OPDailyHandin).CheckEPPrePayM()
/// //---------------------------------------------以下为接口-----------------
/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 取待发药数量
/// Input: oeore:OE_OrdExec.OEORE_RowId
/// Return: retQty
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).GetTCDspQty()
ClassMethod GetTCDspQty(oeore As %String) As %String
{
    s $zt="GetTCDspQtyErr"
    set retQty=0
    quit:(oeore="") retQty
    set order=$p(oeore,"||",1)
    set itm=$p(oeore,"||",2)
    set exec=$p(oeore,"||",3)
    quit:((order="")||(itm="")||(exec="")) retQty
    
    //判断医嘱优先级(是否自备药)    
    set prioDR=$p(^OEORD(order,"I",itm,1),"^",8)
    quit:(prioDR="") retQty
    set priority=$p(^OECPR(prioDR),"^",1)
    quit:(priority="") retQty  
    quit:($zcvt(priority,"U")["OM") retQty
    //判断医嘱状态(医嘱核实、未核实、停止状态)
    set oeoreStatusDR=$p(^OEORD(order,"I",itm,"X",exec,"BILL"),"^",1) 
    quit:(+oeoreStatusDR=0) retQty
    set oeoreStatCode=$p($g(^OEC("OSTAT",oeoreStatusDR)),"^",1)
    quit:(" V E "'[(" "_oeoreStatCode_" ")) retQty
    
    set arcimDR=$p(^OEORD(order,"I",itm,1),"^",2)
    quit:(arcimDR="") retQty
    set inci=$o(^INCI(0,"ARCIM_DR",+arcimDR,""))
    quit:(inci="") retQty
    set UomDR=$p(^INCI(inci,1),"^",10)
    quit:(UomDR="") retQty
    
    set dsp=0
    while($o(^DHCOEDISQTY(0,"OEORE",oeore,dsp))) {
        set dsp=$o(^DHCOEDISQTY(0,"OEORE",oeore,dsp))
        set dspData=$g(^DHCOEDISQTY(dsp))
        set dspStatus=$p(dspData,"^",7)
        continue:(dspStatus'="TC")        //状态不是"TC"的退出
        set dspQty=$p(dspData,"^",11)
        set retQty=retQty+dspQty
    }
    quit retQty
GetTCDspQtyErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"取待发药数量异常:",oeore,$ze)
    q ""
}

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 取实际发药数量
/// Input: oeore:OE_OrdExec.OEORE_RowId
/// Return: dspTotalQty: 实际发药数量
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).GetDspQty("1641||3||1")
ClassMethod GetDspQty(oeore As %String) As %String
{
    s $zt="GetDspQtyErr"
    set dspTotalQty=0
    quit:(oeore="") dspTotalQty
    set dsp=0
    while($o(^DHCOEDISQTY(0,"OEORE",oeore,dsp))) {
        set dsp=$o(^DHCOEDISQTY(0,"OEORE",oeore,dsp))
        set dspData=$g(^DHCOEDISQTY(dsp))
        set dspStatus=$p(dspData,"^",7)
        continue:(dspStatus="TC")
        set dspQty=$p(dspData,"^",11)
        if (dspStatus="C") {
            set dspTotalQty=$i(dspTotalQty, dspQty)
        }else {
            set dspTotalQty=$i(dspTotalQty, -dspQty)
        }
    }
    
    quit dspTotalQty
GetDspQtyErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"取实际发药数量异常:",oeore,$ze)
    q ""
}

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 取医嘱账单单价、数量、金额
/// Input: OEExecRowID:OE_OrdExec.OEORE_RowId
/// Return: pboUnitPrice: 单价, totalQty: 计费数量, pboTotalAmount: 账单金额
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).GetOrderBillInfo("1641||1||1")
ClassMethod GetOrderBillInfo(oeore As %String) As %String
{
    s $zt="GetOrderBillInfoErr"
    set (unitPrice, qty, totalAmt)=0
    set ord=+oeore, itm=$p(oeore,"||",2), exec=$p(oeore,"||",3)
    set pboRowId=$p($g(^OEORD(ord,"I",itm,"X",exec,"BILL")),"^",2)
    if (pboRowId'="") {
        set pboData=$g(^DHCPB(+pboRowId,"O",$p(pboRowId,"||",2)))
        if (pboData'="") {
            set billQty=$p(pboData,"^",5)
            set refQty=$p(pboData,"^",6)
            set unitPrice=$p(pboData,"^",7)
            set totalAmt=$p(pboData,"^",8)
            set qty=$i(billQty, refQty)
        }
    }
    quit unitPrice_"^"_qty_"^"_totalAmt
GetOrderBillInfoErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"取医嘱账单单价、数量、金额异常:",oeore,$ze)
    q ""
}

/// Creator: tangzf
/// CreatDate: 2022-07-25
/// Description: 判断是否是正常收费发票
/// Input: InvDr:发票RowId,AdmType:就诊类型(I:住院,O:门急诊)
/// Output: 
/// Return: S:不是正常收费的发票(作废、红冲), N:是正常收费的发票
/// Debug: w ##class(BILL.DC.Check).CheckNormalInv(,"O")
ClassMethod CheckNormalInv(InvDr, AdmType) As %String
{
    s $zt="CheckNormalInvErr"
    q:(AdmType="")||(InvDr="") "-1"
    if (AdmType="I"){
        s InvFlag=$p(^DHCINVPRTZY(InvDr),"^",8)
        q:InvFlag'="N" "S"
        q:$o(^DHCINVPRTZY(0,"InitInv",InvDr,""))'="" "S"
    }elseif(AdmType="PRE"){
        q:+($p(^DHCACD("AccM",+InvDr,"AccPD",$p(InvDr,"||",2)),"^",1)>=0) "N"
        q:+($p(^DHCACD("AccM",+InvDr,"AccPD",$p(InvDr,"||",2)),"^",1)<0) "S"
    }
    else{
        s InvFlag=$p(^DHCINVPRT(InvDr),"^",8)
        q:InvFlag'="N" "S"
        q:$o(^DHCINVPRT(0,"InitInvDR",InvDr,""))'="" "S"
    }
    q "N"
CheckNormalInvErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"判断是否是正常收费发票异常:",InvDr_"||"_AdmType,$ze)
    q "-2"
}

/// Creator: ZhYW
/// CreatDate: 2019-07-23
/// Description: 判断医嘱是否是急诊转入住院的医嘱
/// Input: oeitm: OE_OrdItem.RowId
/// Output: 
/// Return: 0:否, 1:是
/// Debug: w ##class(web.DataCheckTest).OrdIsOPToIPByOEORI("8322394||38")
ClassMethod OrdIsOPToIPByOEORI(oeitm As %String) As %String
{
    s $zt="OrdIsOPToIPByOEORIErr"
    set rtn=0
    quit:($l(oeitm,"||")'=2) rtn
    
    set adm=$p($g(^OEORD(+oeitm)),"^",1)
    quit:(+adm=0) rtn
    set ociId=$o(^DHCOPIPADMCON(0,"OPADM",adm,"OEORI",oeitm,""),-1) // 8.4以后新版门急诊转住院
    if (+ociId'=0) {
        set tmp=$g(^DHCOPIPADMCON(ociId))
        set status=$p(tmp,"^",7)
        if (status="N") {
            set rtn=1
        }
    }else{ // 8.4以前旧版
        if $d(^DHCOPIPADMCON("OPADMORDER","OPAdm",adm,oeitm)){
            s rtn=1 
        }
    }
    quit rtn
OrdIsOPToIPByOEORIErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"判断医嘱是否是急诊转入住院的医嘱异常:",oeitm,$ze)
    q ""
}

/// Creator: ZhYW
/// CreatDate: 2019-07-23
/// Description: 判断医嘱是否为药品
/// Input: oeitm: OE_OrdItem.RowId，ArcItmRowId,两个参数二选一
/// Output: 
/// Return: R:是药品
/// Debug: w ##class(web.DataCheckTest).CheckDrug("8322394||38")
ClassMethod CheckDrug(OEORIDR, arcimDR) As %String
{
    s $zt="BILLDCCheckDrugErr"
    i OEORIDR '=""  d
    .s order=$p(OEORIDR,"||",1)
    .s itm=$p(OEORIDR,"||",2)
    .set arcimDR=$p(^OEORD(order,"I",itm,1),"^",2)
    q:(arcimDR="") "-1"
    set itemCatDR=$p($g(^ARCIM($p(arcimDR,"||",1),$p(arcimDR,"||",2),1)),"^",10)    //医嘱子类
    set ordCateType=$p(^ARC("IC",itemCatDR),"^",7)        //医嘱类型
    q ordCateType
BILLDCCheckDrugErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"判断医嘱是否为药品异常:",OEORIDR_"||"_arcimDR,$ze)
    q ""
}

/// Creator: ZhYW
/// CreatDate: 2019-07-23
/// Description: 判断医嘱是否是自备药
/// Input: oeitm: OE_OrdItem.RowId
/// Output: 
/// Return: 0:否, 1:是
/// Debug: w ##class(web.DataCheckTest).ReadOECPriorityFlag("8322394||38")
ClassMethod ReadOECPriorityFlag(OEORIDR As %String) As %String
{
    s $zt="ReadOECPriorityFlagErr"
    s myPRFlag=0
    
    q:(OEORIDR="") myPRFlag
    
    s myPriorDR=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1)),"^",8)
    q:(myPriorDR="") myPRFlag
    s myPriorCode=$p($g(^OECPR(myPriorDR)),"^",1)
    i (myPriorCode["OM") {
        s myPRFlag=1
    }
    
    q myPRFlag
ReadOECPriorityFlagErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"判断医嘱是否是自备药异常:",OEORIDR,$ze)
    q ""
}

/*
/// Creator：      tangzf
/// CreatDate：    2022-05-12
/// Description：  结算发票没有对应的账单
/// Table：        
/// input:         
/// Output：       
/// Debug：        
///  d ##class(web.DataCheckTest).CheckINVConBill("2022-4-03","2022-5-12")
ClassMethod CheckINVConBill(StartDate, EndDate)
{
    s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    f INVDate=StartDate:1:EndDate  d
    .s INV=""
    .for  s INV=$o(^DHCINVPRT(0,"Date",INVDate,INV))  q:INV=""  d
    ..s INVFlag=$p($g(^DHCINVPRT(INV)),"^",8)
    ..q:INVFlag'="N"
    ..s FindBill=""
    ..s BillConINV=$o(^DHCBCI(0,"INV",INV,""))
    ..i (BillConINV'="")  d
    ...s Bill=$p($g(^DHCBCI(BillConINV)),"^",2)
    ...s BillFlag=$p($g(^DHCPB(Bill)),"^",16)
    ...q:BillFlag'="P" // 异常:未计费账单
    ...s FindBill="Y"
    ..w:FindBill'="Y" "INV:"_INV_"-门诊正常发票没有对应的账单",!
    .//IP
    .s IPINV=""
    .for  s IPINV=$o(^DHCINVPRTZY(0,"DATE",INVDate,IPINV))  q:IPINV=""  d
    ..s INVFlag=$p($g(^DHCINVPRTZY(IPINV)),"^",8)
    ..q:(INVFlag'="N")&&(INVFlag'="I")
    ..s Bill=$p($g(^DHCINVPRTZY(IPINV)),"^",5)
    ..s BillFlag=$p($g(^DHCPB(Bill)),"^",16)
    ..w:BillFlag'="P" "INV:"_IPINV_"-住院正常发票没有对应的账单",! // 异常:未计费账单
}*/
/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 数据核查插入核查结果(供BILL.DC.Check.Check()调用)  放在核查类调用，提高效率
/// Table : 
/// Input:  
/// Output: 
/// Return: 
/// w ##class(BILL.DC.BL.CheckResultCtl).Save(InJson)
ClassMethod InsertCheckResult(IndicatorName)
{

    s CheckMode=^||TMPCheck("CheckMode")
    s StartDate=^||TMPCheck("StartDate") 
    s StartTime=^||TMPCheck("StartTime") 
    s EndDate=^||TMPCheck("EndDate") 
    s EndTime=^||TMPCheck("EndTime") 
    s HospDr=^||TMPCheck("HospDr")
    s CheckUser=^||TMPCheck("UserId")
    s CheckBatch=^||TMPCheck("CheckBatch")
    s BusinessCode=^||TMPCheck("BusinessCode")
    s IndicatorCode=^||TMPCheck("IndicatorCode")
    s $p(InStr,"^",1)=$g(^TMPBILL.DC.Check("OldCKResultID"))
    s $p(InStr,"^",2)=BusinessCode // BusinessCode
    s $p(InStr,"^",3)=IndicatorCode // 指标代码
    s $p(InStr,"^",4)=IndicatorName // 指标名称
    s $p(InStr,"^",5)=CheckMode // 核查方式
    s $p(InStr,"^",6)=StartDate // 核查开始日期
    s $p(InStr,"^",7)=StartTime // 核查开始时间
    s $p(InStr,"^",8)=EndDate // 核查结束日期
    s $p(InStr,"^",9)=EndTime // 核查结束时间
    s $p(InStr,"^",10)="" // 审核标志
    s $p(InStr,"^",11)=HospDr // HOSPID
    q:CheckBatch="" "-2"
    s $p(InStr,"^",18)=CheckBatch // CheckBatch
    q:$g(^||TMPCheck("CheckBatch",^||TMPCheck("CheckType"),BusinessCode_IndicatorCode))'="" "1" // 每次核查的一个指标只存一行记录 保证唯一性
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Recommendation,"开始插入核查结果:",InStr,CheckUser)
    s rtn=##class(BILL.DC.BL.CheckResultCtl).Save(InStr,CheckUser)
    i +rtn>0  d
    .s ^||TMPCheck("CheckBatch",^||TMPCheck("CheckType"),BusinessCode_IndicatorCode)=rtn
    e  d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"插入核查结果失败:",rtn)
    q rtn
}

/// 一次核查生成一个批次号
ClassMethod BuildCheckBatch()
{
    s ^CacheTemp("BILL.DC.Batch",+$h)=$i(^CacheTemp("BILL.DC.Batch",+$h))
    s CheckBatch=$g(^||TMPCheck("CheckBatch")) // 一次核查Check,一个批次号
    i CheckBatch=""  d
    .s CheckBatch="D"_$zd($p($h,",",1),3)_$zt($p($h,",",2))_^CacheTemp("BILL.DC.Batch",+$h)
    .s CheckBatch=$tr(CheckBatch,"-","")
    .s CheckBatch=$tr(CheckBatch,":","")
    .s ^||TMPCheck("CheckBatch")=CheckBatch
    q CheckBatch
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 保存核查明细 放在核查类调用，提高效率
/// Table : CF_BILL_DataCheck.UnAuditItm
/// Input:  
/// Output: 
/// Return: 
/// w ..SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo)
ClassMethod SaveExInfo(DataSrc, DataID, ErrCode, ErrInfo = "")
{
    q:(DataSrc="")||(DataID="")||(ErrCode="") "-1"
    w:..#WriteErrInfo="Y" DataSrc,DataID,"ErrCode:",ErrCode,!
    q:..#WriteErrInfo="Y" ""
    s IndicatorCode=^||TMPCheck("IndicatorCode")
    s BusinessCode=^||TMPCheck("BusinessCode")
    s CKRRowId=^||TMPCheck("CheckBatch",^||TMPCheck("CheckType"),BusinessCode_IndicatorCode)
    q:$o(^BILL.DC.PO.CheckResultDetI("IndexUnique",CKRRowId,ErrCode,DataSrc,DataID,"")) // 不插重复记录
    s ^||TMPCheck("NUM",CKRRowId)=$i(^||TMPCheck("NUM",CKRRowId))
    s $p(InStr,"^",2)=CKRRowId // ParID
    s $p(InStr,"^",3)=DataSrc // DataSrc
    s $p(InStr,"^",4)=DataID // DataID
    s $p(InStr,"^",5)=ErrCode // ErrCode
    s $p(InStr,"^",6)=ErrInfo //从字典取
    s $p(InStr,"^",11)=$lg(^BILL.DC.PO.CheckResultD(CKRRowId),10) // HOSPID
    s User = $lg(^BILL.DC.PO.CheckResultD(CKRRowId),11) // HOSPID
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Recommendation,"保存核查明细开始:",InStr,User)
    s rtn=##class(BILL.DC.BL.CheckResultDetCtl).Save(InStr,User)
    
    i +rtn<0  d
    .d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"保存核查明细失败:",rtn)
}

/*
/// Creator：      tangzf
/// CreatDate：    2022-05-12
/// Description：  住院已执行医嘱未计费
/// Table：        
/// input:         
/// Output：       
/// Debug：        
///  d ##class(web.DataCheckTest).CheckOrdBillFlag("2022-5-25","2022-5-25")
ClassMethod CheckOrdBillFlag1(StartDate, EndDate)
{
    s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    f OEORIDate=StartDate:1:EndDate  d
    .s OEORD=""
    .for  s OEORD=$o(^OEORDi(0,"ItemDate",OEORIDate,OEORD))  q:OEORD=""  d
    ..s OEORI=0
    ..for  s OEORI=$o(^OEORDi(0,"ItemDate",OEORIDate,OEORD,OEORI))  q:OEORI=""  d
    ...s myPriorFlag=..ReadOECPriorityFlag(OEORD_"||"_OEORI)
    ...q:(+myPriorFlag=1)   //自备药品退出
    ...s ADM=$p($g(^OEORD(+OEORD)),"^",1)
    ...s HospDr=""
    ...s DepCodeDR=$P(^PAADM(ADM),"^",4)
    ...s:DepCodeDR'="" HospDr=$P(^CTLOC(DepCodeDR),"^",22)
    ...s PAPMI=$p($g(^PAADM(ADM)),"^",1)
    ...s RegNo=$p(^PAPER(PAPMI,"PAT",1),"^",1)
    ...s ADMType=$p($g(^PAADM(ADM)),"^",2)
    ...q:(ADMType'="I") // 不计
    ...s OEORIBilled=$p($g(^OEORD(OEORD,"I",OEORI,3)),"^",5)
    ...;q:OEORIBilled'="P" //未计费医嘱
    ...s ArcItmMast=$p($g(^OEORD(OEORD,"I",OEORI,1)),"^",2)
    ...s ArcItmDesc=$p(^ARCIM(+ArcItmMast,$p(ArcItmMast,"||",2),1),"^",2)
    ...s TransFLag=..OrdIsOPToIPByOEORI(OEORD_"||"_OEORI)
    ...q:(ADMType'="I")&&(TransFLag="1") // 不计门急诊转住院的医嘱
    ...s OEORITime=$p($g(^OEORD(OEORD,"I",OEORI,3)),"^",15)
    ...s BILL=""
    ...s FindBill=""
    ...s FindINV=""
    ...s FindOEOREBillFlag="Y"
    ...s AdmTypeDesc=$case(ADMType,"I":"住院",:"门诊")
    ...s PatSelfPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ArcItmMast,OEORIDate,"","","","",HospDr,"")
    ...//----------------------------此处还需要增加条件维护了价格可以为0的项目
    ...q:+$p(PatSelfPrice,"^",4)=0 // 价格为0
    ...s OEORE=0
    ...for  s OEORE=$o(^OEORD(OEORD,"I",OEORI,"X",OEORE))  q:OEORE=""  d
    ....s OEOREBilled=$p(^OEORD(OEORD,"I",OEORI,"X",OEORE),"^",6)
    ....s BillUom=$p($g(^ARCIM(+ArcItmMast,$p(ArcItmMast,"||",2),8)),"^",14)
    ....s BUomCode=$s((+BillUom'=0):$p($g(^CT("UOM",BillUom)),"^"),1:"")
    ....s BUomCode=$zcvt(BUomCode,"U")
    ....q:BUomCode="HOUR" //小时医嘱计费
    ....Q:($p(^OEORD(OEORD,"I",OEORI,"X",OEORE),"^",16)'=1)&&($p(^OEORD(OEORD,"I",OEORI,"X",OEORE),"^",16)'=6)
    ....i OEOREBilled="B"  d
    .....S FindOEOREBillFlag="N"
    .....s BILL=$o(^DHCPB(0,"OEEXC",OEORD_"||"_OEORI_"||"_OEORE,""))
    .....i BILL'=""  d
    ......s PBO=$o(^DHCPB(0,"OEEXC",OEORD_"||"_OEORI_"||"_OEORE,BILL,""))
    ......i PBO'=""  d
    .......s BillTotalAmt=$p($g(^DHCPB(BILL,"O",PBO)),"^",8)
    .......i BillTotalAmt'=0  d
    ........s FindOEOREBillFlag="Y"
    ...w:FindOEOREBillFlag'="Y" $zd(OEORIDate,3)_$zt(OEORITime)_"RegNo:"_RegNo_"-"_AdmTypeDesc_"需计费医嘱："_OEORD_"||"_OEORI_ArcItmDesc_",没有计费,价格："_PatSelfPrice,!
}
*/
/// Creator：      tangzf
/// CreatDate：    2022-05-12
/// Description：  根据HIS版本判断指标是否需要核查
/// Table：        
/// input: BussinessType 业务类型,  IndiCode:指标代码      
/// Output： 0 不需要校验 1 满足版本核查 需要校验      
/// Debug：        
///  d ##class(BILL.DC.Check).CheckHisVer(BussinessType)
/// 
ClassMethod CheckHisVer(BussinessType, IndiCode)
{
    s HISVer=^||TMPCheck("HISVer")
    s UniqueCode=BussinessType_IndiCode
    s IndiHisVer=##class(BILL.DC.BL.IndicatorDefCtl).GetIndiInfo("G","Y",BussinessType,IndiCode,18)
    if ((IndiHisVer[HISVer)||(IndiHisVer=HISVer))&&(HISVer'=""){
        q "1"   
    }else{
        q "0"   
    }
    ;q:(BussinessType="BILLREP")&&(HISVer'="")&&(+HISVer<8.2) 0 // 报表相关指标从8.2以后开始校验
    ;q:(UniqueCode="CT01")&&(HISVer'="")&&(+HISVer<8.2) 0 // 院区相关指标从8.2以后开始校验
    q "1"
}

/// Creator: ZhYW
/// CreatDate: 2021-03-11
/// Description: 取计费点
/// Input: oeitm:OE_OrdItem.OEORI_RowId
/// Return: 
/// Debug: w ##class(BILL.DC.Check).GetBillPoint("1||5")
ClassMethod GetBillPoint(oeitm As %String) As %String
{
    s $zt="BILLDCGetBillPointErr"
    s HISVer=$g(^||TMPCheck("HISVer"))
    if (+HISVer>=8.4){
        q ##class(BILL.IP.COM.Method).GetBillPoint(oeitm)
    }
    set ord=$p(oeitm,"||",1)
    set itm=$p(oeitm,"||",2)
    set adm=$p(^OEORD(ord),"^",1)
    set arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
    set itemCatDR=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1)),"^",10)    //医嘱子类
    set cateType=$p(^ARC("IC",itemCatDR),"^",7)      //医嘱类型
    set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
    s defHospId=admHospDR
    set prioDR=$p(^OEORD(ord,"I",itm,1),"^",8)
    set priority=$s((+prioDR'=0):$p(^OECPR(prioDR),"^",1),1:"")

    set condition=""
    set myRowId=0
    while($o(^DHCTarC("BC",0,itemCatDR,myRowId))&&(condition="")) {
        set myRowId=$o(^DHCTarC("BC",0,itemCatDR,myRowId))
        set myHospDR=$p($g(^DHCTarC("BC",myRowId)),"^",3)
        continue:(myHospDR'=defHospId)
        set condition=myRowId
    }
    set CP=$s((+condition'=0):$p($g(^DHCTarC("BC",condition)),"^",2),1:defaultCP)
    if (+HISVer>=8.4){
        if ((CP="CR")&&(cateType="R")) {
            set linkFlag=##class(web.UDHCJFBILLIP).GetUserLocLinkRecLoc(oeitm)
            if (linkFlag="Y") {
                set CP="OD"
            }
            if (priority="OUT") {
                set PhOutFlag=##class(web.UDHCJFBILLIP).GetPhOutFlag(adm)
                if (PhOutFlag="N") {
                    set CP="OD"
                }
            }
        }
    }
    quit CP
BILLDCGetBillPointErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"取计费点异常:",oeitm,$ze)
    q ""
}

/// Creator: ZhYW
/// CreatDate: 2022-02-24
/// Description: 校验门诊发票是否是过号重打
/// Input: prtRowId: DHC_INVPRT.RowId
/// Return: 0:否，1:是
/// Debug: w ##class(BILL.OP.COM.Method).IsOPInvPassRePrint(3055)
ClassMethod IsOPInvPassRePrint(prtRowId As %String) As %String
{
    s $zt="IsOPInvPassRePrintErr"
    quit:(+prtRowId=0) 0
    
    set initInvDR="", newPrtRowId=""
    if ($p($g(^DHCINVPRT(prtRowId)),"^",13)>0) {
        //prtRowId是负票RowId
        set initInvDR=$p($g(^DHCINVPRT(prtRowId)),"^",13)      //PRT_initInv_DR
        set newPrtRowId=$o(^DHCINVPRT(0,"OldINV",initInvDR,0))    //部分退产生的新票
        quit:(+newPrtRowId=0) 0   //新票不存在时退出
    }
    if ($p($g(^DHCINVPRT(prtRowId)),"^",29)>0) {
        //prtRowId是新票RowId
        set initInvDR=$p($g(^DHCINVPRT(prtRowId)),"^",29)      //PRT_OldINV_DR
        set newPrtRowId=prtRowId
    }
    quit:((+initInvDR=0)||(+newPrtRowId=0)) 0    //prtRowId不是部分退费产生的数据时退出
    
    kill initPMAry, newPMAry
    
    set paymSub=0
    while($o(^DHCINVPRT(initInvDR,"P",paymSub))) {
        set paymSub=$o(^DHCINVPRT(initInvDR,"P",paymSub))
        set paymData=$g(^DHCINVPRT(initInvDR,"P",paymSub))
        continue:(paymData="")
        set paymDR=$p(paymData,"^",1)
        set paymAmt=$p(paymData,"^",3)
        set paymAmt=$fn(paymAmt,"",2)
        set initPMAry(paymDR)=$i(initPMAry(paymDR),paymAmt)
    }
    
    set paymSub=0
    while($o(^DHCINVPRT(newPrtRowId,"P",paymSub))) {
        set paymSub=$o(^DHCINVPRT(newPrtRowId,"P",paymSub))
        set paymData=$g(^DHCINVPRT(newPrtRowId,"P",paymSub))
        continue:(paymData="")
        set paymDR=$p(paymData,"^",1)
        set paymAmt=$p(paymData,"^",3)
        set paymAmt=$fn(paymAmt,"",2)
        set newPMAry(paymDR)=$i(newPMAry(paymDR),paymAmt)
    }
    
    set rtn=1
    
    set paymId=0
    while($o(initPMAry(paymId))) {
        set paymId=$o(initPMAry(paymId))
        set paymAmt=$g(initPMAry(paymId))
        set newPaymAmt=$g(newPMAry(paymId))
        if (+paymAmt'=+newPaymAmt) {
            set rtn=0
            quit
        }
    }
    quit:(rtn=0) rtn
    
    set paymId=0
    while($o(newPMAry(paymId))) {
        set paymId=$o(newPMAry(paymId))
        set paymAmt=$g(newPMAry(paymId))
        set initPaymAmt=$g(initPMAry(paymId))
        if (+paymAmt'=+initPaymAmt) {
            set rtn=0
            quit
        }
    }
    quit rtn
IsOPInvPassRePrintErr
    s $zt=""
    d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"校验门诊发票是否是过号重打异常:",prtRowId,$ze)
    q ""
}

ClassMethod Init()
{
}

// w ##class(web.DHCDocMain).CheckExecValidity("1902||33", .MissExecList)

}
