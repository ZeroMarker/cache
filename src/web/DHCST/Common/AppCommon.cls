/// Descript:应用程序设置相关的公共方法
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-02
Class web.DHCST.Common.AppCommon Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTCOMMON";

/// LastUpdate:  增加Date参数，by zhaoxinlong 2022.04.15
/// Description: 取业务单号-可供外部程序调用
/// Input:      AppName-程序名称,类组id,科室id
/// Return:     单号
/// w ##class(web.DHCST.Common.AppCommon).GetAppNo("DHCSTORDDISP","",1)
ClassMethod GetAppNo(AppName As %String, StkGrpId As %String, LocId As %String, Date As %String = {+$H}) As %Library.String
{
 s HospId=""
 i LocId'="" d
 .s HospId=$p(^CTLOC(LocId),"^",22)
 .s LocDesc=$p(^CTLOC(LocId),"^",2)
 .s LocPre=##class(ext.util.String).ToChineseSpell(LocDesc)
 .i LocPre["-" s LocPre=$p(LocPre,"-",1)
 e  i $d(%session) d
 .s HospId=$g(%session.Data("LOGON.HOSPID"))
 S coustr=..GetAppCounter(AppName,HospId)
 Q:coustr="" ""
 s HospFlag=$p(coustr,"^",1) 
 s LocFlag=$p(coustr,"^",2)
 s CatGrpFlag=$p(coustr,"^",3)
 s Pre=$P(coustr,"^",4)
 s YearFlag=$P(coustr,"^",5)
 s MonthFlag=$P(coustr,"^",6)
 s DayFlag=$P(coustr,"^",7)
 S NoLen=+$P(coustr,"^",8)
 s Today=$zd(Date,3)
 s:HospId'="" HospCode=$p(^CT("HOSP",HospId),"^",1)
 s:StkGrpId'="" GrpCode=$p($g(^DHCSCG(StkGrpId)),"^",1)
 s Prefix=""
 i (HospFlag="Y")&($g(HospCode)'="")  d
 .i Prefix="" d
 ..s Prefix=HospCode
 .e  d
 ..s Prefix=Prefix_HospCode
 .
 i (LocFlag="Y")&($g(LocPre)'="")  d
 .i Prefix="" d
 ..s Prefix=LocPre
 .e  d
 ..s Prefix=Prefix_LocPre
 .
 i (CatGrpFlag="Y")&($g(GrpCode)'="")  d
 .i Prefix="" d
 ..s Prefix=GrpCode
 .e  d
 ..s Prefix=Prefix_GrpCode
 .
 s:Pre'="" Prefix=Prefix_Pre
 i YearFlag="Y"  d
 .s Prefix=Prefix_$p(Today,"-",1)
 i MonthFlag="Y"  d
 .s Prefix=Prefix_$p(Today,"-",2)
 i DayFlag="Y"  d
 .s Prefix=Prefix_$p(Today,"-",3)
 Q:NoLen=0 ""
 Q:Prefix="" ""
 S MaxSuffix=9
 S flen=NoLen-1
 F i=1:1:flen S MaxSuffix=MaxSuffix_"9"
 S MaxNo=Prefix_MaxSuffix   //最大单号
 S MinSuffix=1
 F i=1:1:flen S MinSuffix="0"_MinSuffix
 S MinNo=Prefix_MinSuffix   //最小单号
 S AppName=$$ALPHAUP^SSUTIL4(AppName)
 i (LocFlag="Y")&&(LocId'="")&&(LocPre'="") d       ;LocId未传入时,不按科室流水号,避免报错
 .S CurNo=##class(web.DHCST.Common.DHCStkSysCounter).GetAppNoByLoc(AppName,LocId)
 e  S CurNo=..GetCurNo(AppName,HospId)
 q:CurNo="" ""
 s CurNo=Prefix_CurNo
 Q CurNo
}

/// Description: 根据exe名称取单号规则，可供外部程序调用
/// Input:AppName-应用程序名称
/// Output:
/// Return:返回规则字符串
/// w ##class(web.DHCST.Common.AppCommon).GetAppCounter("DHCSTORDDISP",2)
ClassMethod GetAppCounter(AppName, Hosp) [ Private ]
{
    #; 内部逻辑应与其一致, ##class(PHA.SYS.No.Query).GetSSCRowId
    Q:AppName="" ""
    S AppName=$$ALPHAUP^SSUTIL4(AppName)
    S ssa=$O(^DHCSSA(0,"ACODE",AppName,""))
    Q:ssa="" ""
    S retstr=""
    S sscsub=0
    F  S sscsub = $o(^DHCSSA(ssa, "SSC", sscsub)) Q:(sscsub="")||(retstr'="")  D
    .Q:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_StkSysCounter",ssa _ "||" _ sscsub, Hosp)="N"
    .S retstr=^DHCSSA(ssa,"SSC",sscsub)
    Q retstr
}

/// Description:取新单号的序号
ClassMethod GetCurNo(AppName, Hosp) [ Private ]
{
 //N (AppName)
 s ret=##class(web.DHCST.Common.AppCommon).Lock(AppName_"NO")  
 q:ret'=0 "" ;加锁失败
 S coustr=..GetAppCounter(AppName,Hosp)
 s YearFlag=$P(coustr,"^",5)
 s MonthFlag=$P(coustr,"^",6)
 s DayFlag=$P(coustr,"^",7)
 S NoLen=+$P(coustr,"^",8)
 s CurrentYear=+$P(coustr,"^",11)
 s CurrentMon=+$P(coustr,"^",12)
 s CurrentDay=+$P(coustr,"^",13)
 s CurrentNo=+$P(coustr,"^",14)
 s Today=$zd(+$h,3)
 s Year=$p(Today,"-",1)
 s Month=+$p(Today,"-",2)
 s Day=+$p(Today,"-",3)
 ;b ;1
 ;flag=1,表示CurrentNo即为前一个单号
 ;flag=0,表示目前没有相应的单号记录，新单号需要从1开始记
 s Flag=1   
 i (YearFlag="Y")&(CurrentYear'=Year)  d
 .s Flag=0
 i (MonthFlag="Y")&(CurrentMon'=Month)  d
 .s Flag=0
 i (DayFlag="Y")&(CurrentDay'=Day)  d
 .s Flag=0
 ;
 i Flag=1  d
 .s PreNo=1+CurrentNo
 e  d
 .s PreNo=1
 .
 ;将新序号写回到单号设置表
 s ret=0
 s ret=##class(web.DHCST.Common.DHCStkSysCounter).UpdateCounterNo(AppName,Year,Month,Day,PreNo,Hosp)
 ;b ;2
 d ##class(web.DHCST.Common.AppCommon).UnLock(AppName_"NO") 
 i ret'=0  q ""   ;写入失败返回空
 s len=$l(PreNo)
 s PreFixLen=NoLen-len
 f i=1:1:PreFixLen  d
 .s PreNo="0"_PreNo
 Q PreNo
}

/// Descript:取应用程序ID
/// CreateDate：2011-03-08
/// Creater：周永刚 
/// Table：  DHC_StkSysApp
/// Input:应用程序代码
/// Output:
/// Return:应用程序ID
ClassMethod GetAppID(AppCode) As %Library.String [ Private ]
{
    //N (AppCode)
    S AppCode=$$ALPHAUP^SSUTIL4(AppCode)
    Q:AppCode="" ""
    S App=$O(^DHCSSA(0,"ACODE",AppCode,""))
    Q App
}

/// Descript:查询应用程序参数配置属性
/// CreateDate：2012-06-19
/// Creater：zhangdongmei
/// Table：DHC_StkSysAProp
/// Input:App-应用程序代码,APName-应用程序属性名称,安全组id^科室id^用户id^医院id
/// Return:属性值
/// w ##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTSCRAPSTAT","heihei","^^^2")
ClassMethod GetAppPropValue(AppCode As %String, APCode As %String, StrParam As %String = "") As %Library.String
{
    //N (AppCode,APCode,StrParam)
    q:$zcvt(APCode,"U")="RPRULE" ##Class(web.DHCSTCOMMPARA).GetRpRule($p(StrParam,"^",4),+$h)
    S APValue=""
    Q:AppCode="" APValue
    S App=..GetAppID(AppCode)
    Q:App="" APValue
    S APCode=$$ALPHAUP^SSUTIL4(APCode)
    Q:APCode="" APValue
    s GroupId=$p(StrParam,"^",1)
    s LocId=$p(StrParam,"^",2)
    s UserId=$p(StrParam,"^",3)
    s HospId=$p(StrParam,"^",4)
    ;
    s Chl=$o(^DHCSSA(0,"APCODE",App,APCode,0)) 
    q:Chl="" APValue
    ;优先按人取配置
    i (UserId'="")  d
    .s Type="U"
    .s Pointer=UserId
    .s APValue=$$GetAPValue(Type,Pointer)
    ;不存在按人的定义，则按安全组取
    i (APValue="")&&(GroupId'="")  d
    .s Type="G"
    .s Pointer=GroupId
    .s APValue=$$GetAPValue(Type,Pointer)
    ;不存在按人和安全组的定义，则按科室取
    i (APValue="")&&(LocId'="")  d
    .s Type="L"
    .s Pointer=LocId
    .s APValue=$$GetAPValue(Type,Pointer)
    ;不存在按人、安全组及科室的定义，则按医院取
    i (APValue="")&&(HospId'="")  d
    .s Sub=$o(^DHCSSA(0,"HOSPTypePointer",HospId,"D","DHC",App,Chl,0))
    .q:Sub=""
    .s APValue=$p(^DHCSSA(App,"AP",Chl,"PF",Sub),"^",3)
    ;没有维护参数值，取参数设置中默认值  
    i APValue="" d
    .s APValue=$p(^DHCSSA(App,"AP",Chl),"^",3)
    Q APValue
    
GetAPValue(Type,Pointer)
    s retVal=""
    s Sub="" 
    f  s Sub=$o(^DHCSSA(0,"TypePointer",Type,Pointer,App,Chl,Sub)) q:(Sub="")||(retVal'="")  d
    .s hospDr=$p(^DHCSSA(App,"AP",Chl,"PF",Sub),"^",4)
    .q:(HospId'="")&&(hospDr'="")&&(hospDr'=HospId)
    .s retVal=$p(^DHCSSA(App,"AP",Chl,"PF",Sub),"^",3)
    q retVal
}

/// Description:格式化售价(带单位和库存项id)
/// Creator:yangsj
/// CreateDate:2021-01-30
/// Input: Number: 数值, HospID: 医院id, InciId:库存项id ,Uom：价格单位
/// Output
/// w ##Class(web.DHCST.Common.AppCommon).FormatInciSp(.5,2,1,1)
ClassMethod FormatInciSp(Number, HospID, InciId, Uom)
{
    q:+Number=0 0
    q:InciId="" 0
    q:Uom="" 0
    s buom = $P(^INCI(InciId,1),"^",10)
    s puom = $P(^INCI(InciId,3),"^",6)
    q:(Uom'=buom)&&(Uom'=puom) $fn(Number,"",2)
    s DFlag = $S((Uom=buom)&&(buom'=puom):2,1:1)
    s HerbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(InciId) 
    s FmtCode = $S(HerbFlag="Y":"FmtSPHerb",1:"FmtSP")
    s StrParam="^^^"_HospID
    s StkType="G"
    s FmtStr=..GetCommPropValue(FmtCode,StkType,StrParam)
    q:FmtStr="" Number
    s Ret=..FNDecNumber(Number,FmtStr,DFlag)
    q $p(Ret,"^",1)
}

/// Description:格式化进价(带单位和库存项id)
/// Creator:yangsj
/// CreateDate:2021-01-30
/// Input: Number: 数值, HospID: 医院id, InciId:库存项id ,Uom：价格单位
/// Output
/// w ##Class(web.DHCST.Common.AppCommon).FormatInciRp(.5,2,1,1)
ClassMethod FormatInciRp(Number, HospID, InciId, Uom)
{
    q:+Number=0 0
    q:InciId="" 0
    q:Uom="" 0
    s buom = $P(^INCI(InciId,1),"^",10)
    s puom = $P(^INCI(InciId,3),"^",6)
    q:(Uom'=buom)&&(Uom'=puom) $fn(Number,"",2)
    s DFlag = $S((Uom=buom)&&(buom'=puom):2,1:1)
    s HerbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(InciId) 
    s FmtCode = $S(HerbFlag="Y":"FmtRPHerb",1:"FmtRP")
    s StrParam="^^^"_HospID
    s StkType="G"
    s FmtStr=..GetCommPropValue(FmtCode,StkType,StrParam)
    q:FmtStr="" Number
    s Ret=..FNDecNumber(Number,FmtStr,DFlag)
    q $p(Ret,"^",1)
}

/// Descript:   格式化售价
/// CreateDate: 2012-05-03
/// Creator:    zhangdongmei
/// Input:      Number: 数值, HospID: 医院id, DFlag: 1 - 入库单位, 2 - 基本单位, StkType: 固定为G, HerbFlag: 是否草药(Y\N) 
/// Return:     四舍五入后未格式化,格式(如"0.00")
/// w ##Class(web.DHCST.Common.AppCommon).FormatSp(.5,2,1,"G","")
ClassMethod FormatSp(Number, HospID, DFlag, StkType = "G", HerbFlag = "", InciId = "") As %Library.String
{
    q:+Number=0 0
    i InciId'="" d
    .s InciUomEquel = ##class(PHA.IN.COM.Method).CompInciUomIfEqual(InciId)
    .i InciUomEquel = "Y" s DFlag=1
    .i HerbFlag="" s HerbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(InciId) 
    s StrParam="^^^"_HospID
    s FmtCode = "FmtSP"
    i HerbFlag = "Y" s FmtCode = "FmtSPHerb"
    s FmtStr=..GetCommPropValue(FmtCode,StkType,StrParam)
    q:FmtStr="" Number
    s Ret=..FNDecNumber(Number,FmtStr,DFlag)
    q $p(Ret,"^",1)
}

/// Descript:   格式化进价
/// CreateDate: 2012-05-03
/// Creator:    zhangdongmei
/// Input:      Number: 数值, HospID: 医院id, DFlag: 1 - 入库单位, 2 - 基本单位, StkType: 固定为G, HerbFlag: 是否草药(Y\N)
/// Return:     四舍五入后未格式化,格式(如"0.00")
ClassMethod FormatRp(Number, HospID, DFlag, StkType = "G", HerbFlag = "", InciId = "") As %Library.String
{
    q:+Number=0 0
    i InciId'="" d
    .s InciUomEquel = ##class(PHA.IN.COM.Method).CompInciUomIfEqual(InciId)
    .i InciUomEquel = "Y" s DFlag=1
    .i HerbFlag="" s HerbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(InciId) 
    s StrParam="^^^"_HospID
    s FmtCode = "FmtRP"
    i HerbFlag = "Y" s FmtCode = "FmtRPHerb"
    s FmtStr=..GetCommPropValue(FmtCode,StkType,StrParam)
    q:FmtStr="" Number
    s Ret=..FNDecNumber(Number,FmtStr,DFlag)
    q $p(Ret,"^",1)
}

/// Descript:格式化批价
/// CreateDate: 2012-05-04
/// Creater：zhangdongmei
/// Input:Number-数值,HospID:医院id,DFlag:1,入库单位，2：基本单位
/// Return:     四舍五入后未格式化,格式(如"0.00")
ClassMethod FormatPp(Number, HospID, DFlag, StkType = "G") As %Library.String
{
    Q:+Number=0 0
    //S Perv=HospID_"^DHC"    ;权限字符串(医院ID^DHC)
    s StrParam="^^^"_HospID
    S FmtStr=..GetCommPropValue("FmtPP",StkType,StrParam)
    Q:FmtStr="" Number
    S Ret=..FNDecNumber(Number,FmtStr,DFlag)
    Q $p(Ret,"^",1)
}

/// Descript:格式化进价金额
/// CreateDate: 2012-05-03
/// Creater：zhangdongmei
/// Input:Number-数值,HospID:医院id
/// Return:     四舍五入后未格式化,格式(如"0.00")
ClassMethod FormatRpAmt(Number, HospID, StkType = "G", HerbFlag = "") As %Library.String
{
    Q:+Number=0 0
    s StrParam="^^^"_HospID
    S FmtStr=..GetCommPropValue("FmtRA",StkType,StrParam)
    Q:FmtStr="" Number
    S Ret=..FNDecNumber(Number,FmtStr)
    Q $p(Ret,"^",1)
}

/// Descript:格式化售价金额
/// CreateDate: 2012-05-03
/// Creater：zhangdongmei
/// Input:Number-数值,HospID:医院id
/// Return:     四舍五入后未格式化,格式(如"0.00")
ClassMethod FormatSpAmt(Number, HospID, StkType = "G", HerbFlag = "") As %Library.String
{
    Q:+Number=0 0
    s StrParam="^^^"_HospID
    S FmtStr=..GetCommPropValue("FmtSA",StkType,StrParam)
    Q:FmtStr="" Number
    S Ret=..FNDecNumber(Number,FmtStr)
    Q $p(Ret,"^",1)
}

/// Descript:格式化批价金额
/// CreateDate: 2012-05-04
/// Creater：zhangdongmei
/// Input:Number-数值,HospID:医院id
/// Return:     四舍五入后未格式化,格式(如"0.00")
ClassMethod FormatPpAmt(Number, HospID, StkType = "G", HerbFlag = "") As %Library.String
{
    Q:+Number=0 0
    //S Perv=HospID_"^DHC"    ;权限字符串(医院ID^DHC)
    s StrParam="^^^"_HospID
    S FmtStr=..GetCommPropValue("FmtPA",StkType,StrParam)
    Q:FmtStr="" Number
    s DFlag=""
    S Ret=..FNDecNumber(Number,FmtStr,DFlag)
    Q $p(Ret,"^",1)
}

/// Descript:格式化库存数量,（补充:保留位数不随单位变化变化）
/// CreateDate: 2014-01-08
/// Creater：wyx
/// Input:Number-数值,HospID:医院id,DFlag:1,入库单位，2：基本单位
/// Return:     四舍五入后未格式化,格式(如"0.00")
ClassMethod FormatSq(Number, HospID, DFlag, StkType = "G") As %Library.String
{
    
    //N (Number, HospID,DFlag,StkType)
    Q:+Number=0 0
    //S Perv=HospID_"^DHC"    ;权限字符串(医院ID^DHC)
    s StrParam="^^^"_HospID
    S FmtStr=..GetCommPropValue("FmtSQ",StkType,StrParam)
    Q:FmtStr="" Number
    S Ret=..FNDecNumber(Number,FmtStr,DFlag)
    Q $fn($p(Ret,"^",1),"N")  //库存小数后面就不补零了 2021-03-05
}

/// Descript:   取公共的参数设置
/// CreateDate: 2011-03-17
/// Creater：    周永刚
/// Input:      APName-参数名称,StkType-G或M,安全组id^科室id^用户id^医院id
/// Return:     参数设置的属性值
/// 添加stkType参数, 区分药品,材料
ClassMethod GetCommPropValue(APName, StkType, StrParam) As %Library.String [ Private ]
{
    s:StkType="G" CommonAppName="DHCSTCOMMON"
    s:StkType="M" CommonAppName="DHCSTCOMMONM"
    s:$g(CommonAppName)="" CommonAppName="DHCSTCOMMON"
    S CMValue=..GetAppPropValue(CommonAppName,APName,StrParam)
    Q CMValue
}

/// Descript:   取格式后的数值
/// CreateDate: 2011-03-17
/// Creater：    周永刚
/// Input:      Number-格式前的数值，FmtStr-格式(如"0.00",或"#,##0.00"),DFlag(1-入库单位,2-基本单位,只对参与计算的价格有意义,其他都是1)
/// Return:     四舍五入后未格式化^四舍五入后格式化,格式(如"0.00",或"#,##0.00")
/// w ##class(web.DHCST.Common.AppCommon).FNDecNumber(40.48,0.00,1)
ClassMethod FNDecNumber(Number, FmtStr, DFlag = 1) As %Library.String [ Private ]
{
    S Number=$tr(Number,",")    //转换成正常数值格式
    S Fmt=""            //format
    S DecStr=$P(FmtStr,".",2)
    S FmtDecLen=$L(DecStr)  //小数位数
    I DFlag'=1 D
    .S DecLen=FmtDecLen+4
    E  D
    .S DecLen=FmtDecLen
    I $f(FmtStr,",")'=0 S Fmt=","
    //S FmtNumber=$FN(Number,Fmt,FmtDecLen)
    S FmtNumber=$FN($FN(Number,"",FmtDecLen),Fmt,FmtDecLen) //zhouyg 20141204   //最后一个FmtDecLen  20210125 yangsj
    S DecNumber=$FN(Number,"",DecLen)
    //s DecNumber=$FN(DecNumber,"N")
    S Ret=DecNumber_"^"_FmtNumber
    Q Ret
}

/// Descript:加锁
/// CreateDate: 2012-06-18
/// Creater:zhangdongmei
/// Input:锁名(PURPLANNO:生成采购计划单号)
/// Return: 0，成功;
ClassMethod Lock(LockName) As %Library.String
{
    l +^DHCSTLOCK(LockName):2 e  q -99   ;加锁失败
    q 0
}

/// Descript:加锁
/// CreateDate: 2012-06-18
/// Creater:zhangdongmei
/// Input:锁名(PURPLANNO:生成采购计划单号)
/// Return:
ClassMethod UnLock(LockName) As %Library.String
{
    l -^DHCSTLOCK(LockName)
    q
}

/// Descript:根据药品(物资)desc获取返回汉字的编码信息(处理问号等问题)
/// CreateDate：2013-07-24
/// Creator：wangjiabin
/// Input:汉字字符串
/// Return:返回编码信息
/// w ##class(web.DHCST.Common.AppCommon).GetCNCODE("★(静配正规）胰岛素注射液[10ml:400u]")
ClassMethod GetCNCODE(str) As %Library.String
{
    i str["[" d
    .s str=$p(str,"[",1)    //去掉规格[spec]部分
    .
    s str=$$ALPHAUP^SSUTIL4(str)
    s str=##class(web.DHCINSUPort).GetCNCODE(str,4,"")
    s str=$tr(str,"(")      //去掉可能出现的全角括号带来的干扰
    s str=$tr(str,")")
    s str=$tr(str,"?")      //去掉括号等特殊字符带来的"?"
    
    q str
}

/// Descript:取参数设置公共模块相关配置属性
/// Creater:    wyx
/// CreateDate: 2013-03-13
/// Table:
/// Input:安全组id,科室id,用户id
/// Output:     
/// Return：进价小数位数(入库单位)^批价小数位数(入库单位)^售价小数位数(入库单位)^进价金额小数位数
///         ^批价金额小数位数^售价金额小数位数^集团化标志^进价规则^库存数量小数位数^类组设置
///         ^医嘱批次不可用的是否可发药
///         w ##class(web.DHCST.Common.AppCommon).GetParamCommon(142,102,590)
ClassMethod GetParamCommon(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCST.Common.AppCommon).%GetParameter("AppName")
    s FmtRP=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtRP",Param)
    s FmtPP=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtPP",Param)
    s FmtSP=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtSP",Param)
    s FmtRA=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtRA",Param)
    s FmtPA=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtPA",Param)
    s FmtSA=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtSA",Param)
    s GroupFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"GroupFlag",Param)
    s RpRule=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RpRule",Param)
    s FmtSQ=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtSQ",Param)
    s StkCatSet=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"StkCatSet",Param)
    s GridSet=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"GridSet",Param)
    s DispActiveFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"OeoriBatActiveDisp",Param)
    s FmtRPHerb=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtRPHerb",Param)
    s FmtSPHerb=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtSPHerb",Param)
    s RetLB = $lb(FmtRP, FmtPP, FmtSP, FmtRA, FmtPA)
            _ $lb(FmtSA, GroupFlag, RpRule, FmtSQ, StkCatSet)
            _ $lb(GridSet, DispActiveFlag, FmtRPHerb, FmtSPHerb)
    q $lts(RetLB, "^")
}

/// Descript:   格式化售价
/// CreateDate: 2014-12-04
/// Creator：    zhouyg
/// Input:      Number: 数值, HospID: 医院id, DFlag: 1 - 入库单位, 2 - 基本单位, StkType: 固定为G, HerbFlag: 是否草药(Y\N)
/// Return:     四舍五入后格式化,格式(如"#,##0.00")
ClassMethod TFormatSp(Number, HospID, DFlag, StkType = "G", HerbFlag = "") As %Library.String
{
    q:+Number=0 0
    s StrParam="^^^"_HospID
    s FmtCode = "FmtSP"
    i HerbFlag = "Y" s FmtCode = "FmtSPHerb"    
    s FmtStr=..GetCommPropValue(FmtCode,StkType,StrParam)
    q:FmtStr="" Number
    s Ret=..FNDecNumber(Number,FmtStr,DFlag)
    q $p(Ret,"^",2)
}

/// Descript:   格式化进价
/// CreateDate: 2014-12-04
/// Creator：    zhouyg
/// Input:      Number: 数值, HospID: 医院id, DFlag: 1 - 入库单位, 2 - 基本单位, StkType: 固定为G, HerbFlag: 是否草药(Y\N)
/// Return:     四舍五入后格式化,格式(如"#,##0.00")
ClassMethod TFormatRp(Number, HospID, DFlag, StkType = "G", HerbFlag = "") As %Library.String
{
    q:+Number=0 0
    s StrParam="^^^"_HospID
    s FmtCode = "FmtRP"
    i HerbFlag = "Y" s FmtCode = "FmtRPHerb"
    s FmtStr=..GetCommPropValue(FmtCode,StkType,StrParam)
    q:FmtStr="" Number
    s Ret=..FNDecNumber(Number,FmtStr,DFlag)
    q $p(Ret,"^",2)
}

/// Descript:   取进价售价批次以及金额的小数长度,用于控制前台输入小数位数保留
/// CreateDate: 2015-11-24
/// Creater：    yunhaibao
/// Input:      InciUom对应前台业务的单位,InciBaseUom为基本单位id(此用于药品维护未保存前)
/// Return:     例:4代表小数保留四位
/// w ##class(web.DHCST.Common.AppCommon).GetDecimalCommon("142","395","13609","3862","88","")
ClassMethod GetDecimalCommon(GroupId As %String, LocId As %String, UserId As %String, InciRowid = "", InciUom = "", InciBaseUom = "") As %Library.String
{
    s ^YSJTMP("GetDecimalCommon")=$LB(GroupId , LocId , UserId , InciRowid, InciUom , InciBaseUom )
    i +InciRowid=0 s InciRowid=""
    i +InciUom=0 s InciUom=""
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCST.Common.AppCommon).%GetParameter("AppName")
    s FmtRP=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtRP",Param)
    s FmtPP=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtPP",Param)
    s FmtSP=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtSP",Param)
    s FmtRA=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtRA",Param)
    s FmtPA=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtPA",Param)
    s FmtSA=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtSA",Param)
    s FmtRPHerb=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtRPHerb",Param)
    s FmtSPHerb=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"FmtSPHerb",Param)
    s RPLen=$l($p(FmtRP,".",2))
    s PPLen=$l($p(FmtPP,".",2))
    s SPLen=$l($p(FmtSP,".",2))
    s RALen=$l($p(FmtRA,".",2))
    s PALen=$l($p(FmtPA,".",2))
    s SALen=$l($p(FmtSA,".",2))
    s RPHerbLen=$l($p(FmtRPHerb,".",2))
    s SPHerbLen=$l($p(FmtSPHerb,".",2))
    i InciRowid'="" d
    .i $d(^INCI(InciRowid,1)) d
    ..s InciBuom=$p($g(^INCI(InciRowid,1)),"^",10)
    ..s InciPuom=$p($g(^INCI(InciRowid,3)),"^",6)
    ..i (InciBuom'="")&&(InciPuom'="") d
    ...i (InciUom=InciBuom)&&(InciBuom'=InciPuom) d 
    ....s RPLen=RPLen+4,PPLen=PPLen+4,SPLen=SPLen+4,RPHerbLen=RPHerbLen+4,SPHerbLen=SPHerbLen+4
    .s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(InciRowid)  // 如果是草药则 RPLen，PPLen 取草药位数
    .i herbFlag = "Y" s RPLen=RPHerbLen,SPLen=SPHerbLen
    e  d
    .i (InciUom'="")&&(InciBaseUom'="")&&(InciUom=InciBaseUom) d
    ..s RPLen=RPLen+4,PPLen=PPLen+4,SPLen=SPLen+4,RPHerbLen=RPHerbLen+4,SPHerbLen=SPHerbLen+4
    s RetLB = $lb(RPLen, PPLen, SPLen, RALen, PALen)
            _ $lb(SALen, RPHerbLen, SPHerbLen)
    q $lts(RetLB, "^")
}

/// creator:yunhaibao
/// createdate:20151209
/// description:零加成判断,根据药品id获取类组进而获取是否零加成的标志
/// output:Y为加成
/// w ##class(web.DHCST.Common.AppCommon).GetZeroMarginByInci(1758,"123","11","11")
/// Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
ClassMethod GetZeroMarginByInci(Inci As %String, GroupId As %String, LocId As %String, UserId As %String)
{
    s Inci=+Inci
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s equalflag="N"
    q:Inci="0" equalflag  
    q:'$d(^INCI(Inci,2)) equalflag
    s inccatdr=$p(^INCI(Inci,2),"^",2)
    q:inccatdr="" equalflag
    q:'$d(^DHCSCG("STKCAT",inccatdr)) equalflag
    s scg=$o(^DHCSCG("STKCAT",inccatdr,""))
    q:scg="" equalflag
    s scgcode=$p(^DHCSCG(scg),"^",1)  //类组代码
    s AppName=##class(web.DHCST.Common.AppCommon).%GetParameter("AppName")
    s ZeroMargin=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ZeroMargin",Param)  //全院统一配置
    q:ZeroMargin="" "N"
    s ZeroMarginList=$lfs(ZeroMargin)
    i $lf(ZeroMarginList,scgcode)>0 s equalflag="Y"
    q equalflag
}

/// Description:获取价格格式化小数长度
/// Creator:    wangjiabin
/// CreateDate: 2014-10-30
/// Input:      格式化类型(FmtRP,FmtPP,FmtSP,FmtRA,FmtPA,FmtSA,FmtQTY,FmtRPHerb,FmtSPHerb)
/// Output:     格式化小数位数
/// w ##class(web.DHCST.Common.AppCommon).DecLenByFmtType("FmtSQ",2)
ClassMethod DecLenByFmtType(FmtType As %String, HospId As %String) As %Integer
{
    s FmtDecLen=2           ;缺省显示两位
    s NormTypes="FmtRP,FmtPP,FmtSP,FmtRA,FmtPA,FmtSA,FmtSQ,FmtRPHerb,FmtSPHerb"
    q:'$f(NormTypes,$g(FmtType)) FmtDecLen
    s StrParam="^^^"_HospId
    s FmtStr=..GetAppPropValue(..%GetParameter("AppName"),FmtType,StrParam)
    s DecStr=$P(FmtStr,".",2)
    S FmtDecLen=$l(DecStr)  ;小数位数   
    q FmtDecLen
}

/// Description:调用基础平台的加锁解锁
/// Creator:    yunhaibao
/// CreateDate: 2016-12-22
/// Input:      单据id,单据类型,L/UL(加锁/解锁)
/// Output:     1:成功,0:失败,其他:错误信息
/// Others:     classname的条件随用随加
///             w ##class(web.DHCST.Common.AppCommon).WebSysLock("1","R")
ClassMethod WebSysLock(lockid As %String, locktype As %String, locktoggle As %String, userid As %String = "", locid As %String = "") As %String
{
    q:'$d(%session) "获取不到session!"
    q:(locktype="")||(locktype="")||(locktoggle="") ""
    s classname=$case(locktype,"G":"User.DHCINGdRec","R":"User.DHCINGDRET","REQ":"User.INRequest",:"")
    q:classname="" "获取不到对应类型的User类"
    s oid=$Lb(lockid,classname)
    s userid=$s(userid'="":userid,1:$g(%session.Data("LOGON.USERID")))
    s locid=$s(locid'="":locid,1:$g(%session.Data("LOGON.CTLOCID")))
    s ipaddr=$g(%session.Data("REMOTE_ADDR"))
    s sessionid=ipaddr_"||"_userid //用于判断加锁
    s lockret=""
    i locktoggle="UL" d
    .d ##class(websys.Lock).LockClear(oid,sessionid)  //no return data,cant w
    .s lockret=1
    q:locktoggle="UL" lockret
    s lockret=##class(websys.Lock).Lock(oid,sessionid,userid,.msg,locid)
    i lockret=0 d //加锁失败后获取谁在锁
    .s lockretmsg=##class(websys.Lock).GetLockedUser(oid)
    .s lockret=$p(lockretmsg,"|",1)_" "_"正在编辑该单据"
    .s lockret=lockret_"</br></br>"_"登陆科室: "_$p(lockretmsg,"|",2)
    .s lockret=lockret_"</br>"_"登录地址: "_$p($p(lockretmsg,"|",3)," ",2)_"</br>"_"锁定时间: "_$p(lockretmsg,"|",4)
    q lockret
}

/// Descript:   根据药品desc获取返回汉字的五笔编码首拼
/// CreateDate：2017-03-30
/// Creator：    yunhaibao
/// Input:      汉字字符串
/// Return:     五笔编码首拼
/// w ##class(web.DHCST.Common.AppCommon).GetCNWBCODE("阿莫西林胶囊[0.5g*16粒]")
ClassMethod GetCNWBCODE(str) As %Library.String
{
    i str["[" d
    .s str=$p(str,"[",1)    //去掉规格[spec]部分
    s str=$$ALPHAUP^SSUTIL4(str)
    s str=##class(web.DHCINSUPort).GetCNCODE(str,6,"^")
    s str=$tr(str,"(")  
    s str=$tr(str,")")
    s str=$tr(str,"?")
    s wbstr=""  
    f wbi=1:1:$l(str,"^") d
    .s wbicode=$p(str,"^",wbi)
    .s wbicode=$e(wbicode,1)
    .s wbstr=$s(wbstr="":wbicode,1:wbstr_wbicode)
    q wbstr
}

/// description: 获取公共参数单个配置
/// 医嘱批次不可用是否允许发药
/// w ##class(web.DHCST.Common.AppCommon).GetParamOeoriBatActiveDisp(308)
ClassMethod GetParamOeoriBatActiveDisp(LocId = "") As %Library.String
{
    s HospId=$s(LocId'="":$p(^CTLOC(+LocId),"^",22),1:"")
    s Param=""_"^"_LocId_"^"_""_"^"_HospId
    s activeDisp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"OeoriBatActiveDisp",Param)
    q activeDisp
}

/// 校验单号规则是否正确
/// w ##class(web.DHCST.Common.AppCommon).ValidateCounterMapping("DHC_StkSysCounter")
ClassMethod ValidateCounterMapping(dataTable)
{
    &SQL( 
        DECLARE xx CURSOR FOR 
        SELECT %ID, BDPMPH_DataReference, BDPMPH_Hospital, BDPMPH_TableName FROM SQLUSER.BDP_MappingHosp where BDPMPH_TableName = :dataTable
    )
    &SQL(OPEN xx)
    for {
        &SQL(FETCH xx into :rowID, :dataDR, :dataHosp, :dataTable)
        q:(SQLCODE '= 0)
        if ($d(tmpMData(dataHosp, +dataDR))) {
            w rowID,!
        }
        s tmpMData(dataHosp, +dataDR) = dataDR

    } 
    &SQL(CLOSE xx)
    q $$$OK
}

}
