Import sqluser

/// Descript:应用程序设置相关的公共方法
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-02
Class web.DHCSTMHUI.Common.AppCommon Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTCOMMONM";

/// Description: 取业务单号-可供外部程序调用
/// Input:		AppName-程序名称,类组id,科室id
/// Return:		单号
/// w ##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo("DHCSTPOM","","","")
ClassMethod GetAppNo(AppName As %String, StkGrpId As %String, LocId As %String, Hospid = "") As %Library.String
{
	N (AppName,StkGrpId,LocId,Hospid,%session)
	i AppName="" q ""
	
	s Lock=..Lock(AppName)
	i Lock'=0 q ""
	s $ZT="GetAppNoError"
	
	s HospId=""
	i LocId'="" d
	.s HospId=$p(^CTLOC(LocId),"^",22)
	i HospId="" s HospId=Hospid
	s AppName=$$ALPHAUP^SSUTIL4(AppName)
	s coustr=""
	
	s HospAutFlag=##class(web.DHCSTMHUI.MatForBDPData).GetHospAutFlag()
	i HospAutFlag="Y" d
	.s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType("DHC_StkSysCounter")
	.i (HospId="")||(TableType="G") s HospAutFlag="N"
	.q:HospAutFlag="N"
	.s HospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(HospId,HospId,"Y","DHC_StkSysCounter")
	
	i (HospAutFlag="Y")&&(HospId'="") d
	.s coustr=..GetAppCounterhosp(AppName,HospId)
	e  d
	.s coustr=..GetAppCounter(AppName)
	i coustr="" d ..UnLock(AppName) q ""
	
	s HospFlag=$p(coustr,"^",1) 
	s LocFlag=$p(coustr,"^",2)
	s CatGrpFlag=$p(coustr,"^",3)
	s Pre=$P(coustr,"^",4)
	s YearFlag=$P(coustr,"^",5)
	s MonthFlag=$P(coustr,"^",6)
	s DayFlag=$P(coustr,"^",7)
	S NoLen=+$P(coustr,"^",8)
	s countByLoc=$P(coustr,"^",15)
	i NoLen=0 d ..UnLock(AppName) q ""
	
	s (Prefix,HospCode,LocCode,GrpCode,Year,Month,Day)=""
	
	i (HospFlag="Y")&&(HospId'="") d
	.s HospCode=$p(^CT("HOSP",HospId),"^",1)
	i (LocFlag="Y")&&(LocId'="") d
	.s LocCode=$p(^CTLOC(LocId),"^",1)
	i (CatGrpFlag="Y")&(StkGrpId'="")  d
	.s GrpCode=$p(^DHCSCG(StkGrpId),"^",1)
	s Today=$zd(+$h,3)
	i YearFlag="Y"  d
	.s Year=$p(Today,"-",1)
	i MonthFlag="Y"  d
	.s Month=$p(Today,"-",2)
	i DayFlag="Y"  d
	.s Day=$p(Today,"-",3)
	
	s Prefix=HospCode_LocCode_GrpCode_Pre_Year_Month_Day
	i Prefix="" d ..UnLock(AppName) q ""

	i (countByLoc="Y")&&(LocId'="") d
	.S CurNo=##class(web.DHCSTMHUI.Common.DHCStkSysCounter).GetAppNoByLoc(AppName,LocId)
	e  d
	.S CurNo=..GetCurNo(AppName,HospId)
	i CurNo="" d ..UnLock(AppName) q ""
	
	s CurNo=Prefix_CurNo
	d ..UnLock(AppName)

	Q CurNo

GetAppNoError
	d ..UnLock(AppName)
	q -99
}

/// Description: 根据exe名称取单号规则，可供外部程序调用
/// Input:AppName-应用程序名称
/// Output:
/// Return:返回规则字符串
ClassMethod GetAppCounter(AppName) [ Private ]
{
	N (AppName)
	Q:AppName="" ""
	S AppName=$$ALPHAUP^SSUTIL4(AppName)
	S ssa=$O(^DHCSSA(0,"ACODE",AppName,""))
	Q:ssa="" ""
	S sscsub=$O(^DHCSSA(ssa,"SSC","0"))
	Q:sscsub="" ""
	S retstr=^DHCSSA(ssa,"SSC",sscsub)
	Q retstr
}

/// Description: 根据exe名称以及院区取单号规则，可供外部程序调用
/// Input:AppName-应用程序名称
/// Output:
/// Return:返回规则字符串 
/// w ##class(web.DHCSTMHUI.Common.AppCommon).GetAppCounterhosp("DHCSTADJSPM",2)
ClassMethod GetAppCounterhosp(AppName, HospId) [ Private ]
{
	N (AppName,HospId)
	Q:AppName="" ""
	Q:HospId="" ""
	S AppName=$$ALPHAUP^SSUTIL4(AppName)
	S ssa=$O(^DHCSSA(0,"ACODE",AppName,""))
	Q:ssa="" ""
	s tmpsscsub=0,retRowid="",tableName="DHC_StkSysCounter"
	f  s tmpsscsub=$O(^DHCSSA(ssa,"SSC",tmpsscsub)) q:(tmpsscsub="")!(retRowid'="")  d
	.s Rowid=ssa_"||"_tmpsscsub
	.s BDPMapId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPMapId(tableName,HospId,Rowid)
	.i BDPMapId>0 s retRowid=Rowid
	.q:retRowid'=""
	s sscsub=0,retstr=""
	i retRowid'="" d 
	.s sscsub=$p(retRowid,"||",2) 
	.S retstr=^DHCSSA(ssa,"SSC",sscsub)
	Q retstr
}

/// Description:取新单号的序号
ClassMethod GetCurNo(AppName, HospId = "") [ Private ]
{
	N (AppName,HospId)
	s ret=##class(web.DHCSTMHUI.Common.AppCommon).Lock(AppName_"NO")  
	q:ret'=0 "" ;加锁失败
	s HospAutFlag=##class(web.DHCSTMHUI.MatForBDPData).GetHospAutFlag()
	
	s coustr=""
	i (HospAutFlag="Y")&&(HospId'="") d
	.s coustr=..GetAppCounterhosp(AppName,HospId)
	e  d
	.s coustr=..GetAppCounter(AppName)
	i coustr="" d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(AppName_"NO") q ""
	
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
	s ret=##class(web.DHCSTMHUI.Common.DHCStkSysCounter).UpdateCounterNo(AppName,Year,Month,Day,PreNo,HospId)
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(AppName_"NO") 
	i ret'=0 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(AppName_"NO") q ""   ;写入失败返回空
	s len=$l(PreNo)
	s PreFixLen=NoLen-len
	f i=1:1:PreFixLen  d
	.s PreNo="0"_PreNo
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(AppName_"NO")
	Q PreNo
}

/// Descript:取应用程序ID
/// CreateDate：2011-03-08
/// Creater：周永刚 
/// Table：	DHC_StkSysApp
/// Input:应用程序代码
/// Output:
/// Return:应用程序ID
ClassMethod GetAppID(AppCode) As %Library.String [ Private ]
{
	N (AppCode)
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
/// w ##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTFTPFILEM","FtpPassword","")
ClassMethod GetAppPropValue(AppCode As %String, APCode As %String, StrParam As %String = "") As %Library.String
{
	N (AppCode,APCode,StrParam)
	S APValue=""
	Q:AppCode="" APValue
	S App=..GetAppID(AppCode)
	Q:App="" APValue
	S APCode=$$ALPHAUP^SSUTIL4(APCode)
	Q:APCode="" APValue
	s Sub=""
	s GroupId=$p(StrParam,"^",1)
	s LocId=$p(StrParam,"^",2)
	s UserId=$p(StrParam,"^",3)
	s HospId=$p(StrParam,"^",4)
	i (LocId'="")&&(HospId="") d
	.s HospId=$p(^CTLOC(LocId),"^",22)
	;
	s Chl=$o(^DHCSSA(0,"APCODE",App,APCode,0)) 
	q:Chl="" APValue
	;优先按人取配置
	i (UserId'="")&(APValue="")  d
	.s Sub=$o(^DHCSSA(0,"TypePointer","U",UserId,App,Chl,0))
	.q:Sub=""
	.s APValue=$p(^DHCSSA(App,"AP",Chl,"PF",Sub),"^",3)
	;不存在按人的定义，则按安全组取
	i (GroupId'="")&(APValue="")  d
	.s Sub=$o(^DHCSSA(0,"TypePointer","G",GroupId,App,Chl,0))
	.q:Sub=""
	.s APValue=$p(^DHCSSA(App,"AP",Chl,"PF",Sub),"^",3)
	;不存在按人和安全组的定义，则按科室取
	i (LocId'="")&(APValue="")  d
	.s Sub=$o(^DHCSSA(0,"TypePointer","L",LocId,App,Chl,0))
	.q:Sub=""
	.s APValue=$p(^DHCSSA(App,"AP",Chl,"PF",Sub),"^",3)
	;不存在按人、安全组及科室的定义，则按医院取
	i (HospId'="")&(APValue="")  d
	.s Sub=$o(^DHCSSA(0,"TypePointer","D",HospId,App,Chl,0))
	.s:Sub="" Sub=$o(^DHCSSA(0,"HOSPTypePointer",HospId,"D","DHC",App,Chl,0))
	.q:Sub=""
	.s APValue=$p(^DHCSSA(App,"AP",Chl,"PF",Sub),"^",3)
	
	i APValue=""  d
	.s APValue=$p(^DHCSSA(App,"AP",Chl),"^",3)
	
	i APCode=$$ALPHAUP^SSUTIL4("FtpPassword") s APValue=##class(web.DHCSTMHUI.Common.UtilCommon).DecryptPW(APValue)
	
	Q APValue
}

/// Descript:格式化售价
/// CreateDate:	2012-05-03
/// Creater：zhangdongmei
/// Input:Number-数值,HospID:医院id,DFlag:1,入库单位，2：基本单位
/// Return:		四舍五入后未格式化,格式(如"0.00")
ClassMethod FormatSp(Number, HospID, DFlag) As %Library.String
{
	N (Number,HospID,DFlag)
	Q:+Number=0 0
	//S Perv=HospID_"^DHC"    ;权限字符串(医院ID^DHC)
	s StrParam="^^^"_HospID
	S FmtStr=..GetCommPropValue("FmtSP",StrParam)
	Q:FmtStr="" Number
	S Ret=..FNDecNumber(Number,FmtStr,DFlag)
	Q $p(Ret,"^",1)
}

/// Descript:格式化进价
/// CreateDate:	2012-05-03
/// Creater：zhangdongmei
/// Input:Number-数值,HospID:医院id,DFlag:1,入库单位，2：基本单位
/// Return:		四舍五入后未格式化,格式(如"0.00")
ClassMethod FormatRp(Number, HospID, DFlag) As %Library.String
{
	N (Number, HospID,DFlag)
	Q:+Number=0 0
	//S Perv=HospID_"^DHC"    ;权限字符串(医院ID^DHC)
	s StrParam="^^^"_HospID
	S FmtStr=..GetCommPropValue("FmtRP",StrParam)
	Q:FmtStr="" Number
	S Ret=..FNDecNumber(Number,FmtStr,DFlag)
	Q $p(Ret,"^",1)
}

/// Descript:格式化批价
/// CreateDate:	2012-05-04
/// Creater：zhangdongmei
/// Input:Number-数值,HospID:医院id,DFlag:1,入库单位，2：基本单位
/// Return:		四舍五入后未格式化,格式(如"0.00")
ClassMethod FormatPp(Number, HospID, DFlag) As %Library.String
{
	N (Number,HospID,DFlag)
	Q:+Number=0 0
	//S Perv=HospID_"^DHC"    ;权限字符串(医院ID^DHC)
	s StrParam="^^^"_HospID
	S FmtStr=..GetCommPropValue("FmtPP",StrParam)
	Q:FmtStr="" Number
	S Ret=..FNDecNumber(Number,FmtStr,DFlag)
	Q $p(Ret,"^",1)
}

/// Descript:格式化进价金额
/// CreateDate:	2012-05-03
/// Creater：zhangdongmei
/// Input:Number-数值,HospID:医院id
/// Return:		四舍五入后未格式化,格式(如"0.00")
ClassMethod FormatRpAmt(Number, HospID) As %Library.String
{
	N (Number, HospID)
	Q:+Number=0 0
	//S Perv=HospID_"^DHC"    ;权限字符串(医院ID^DHC)
	s StrParam="^^^"_HospID
	S FmtStr=..GetCommPropValue("FmtRA",StrParam)
	Q:FmtStr="" Number
	S Ret=..FNDecNumber(Number,FmtStr)
	Q $p(Ret,"^",1)
}

/// Descript:格式化售价金额
/// CreateDate:	2012-05-03
/// Creater：zhangdongmei
/// Input:Number-数值,HospID:医院id
/// Return:		四舍五入后未格式化,格式(如"0.00")
ClassMethod FormatSpAmt(Number, HospID) As %Library.String
{
	N (Number, HospID)
	Q:+Number=0 0
	//S Perv=HospID_"^DHC"    ;权限字符串(医院ID^DHC)
	s StrParam="^^^"_HospID
	S FmtStr=..GetCommPropValue("FmtSA",StrParam)
	Q:FmtStr="" Number
	S Ret=..FNDecNumber(Number,FmtStr)
	Q $p(Ret,"^",1)
}

/// Descript:格式化批价金额
/// CreateDate:	2012-05-04
/// Creater：zhangdongmei
/// Input:Number-数值,HospID:医院id
/// Return:		四舍五入后未格式化,格式(如"0.00")
ClassMethod FormatPpAmt(Number, HospID) As %Library.String
{
	N (Number, HospID)
	Q:+Number=0 0
	//S Perv=HospID_"^DHC"    ;权限字符串(医院ID^DHC)
	s StrParam="^^^"_HospID
	S FmtStr=..GetCommPropValue("FmtPA",StrParam)
	Q:FmtStr="" Number
	S Ret=..FNDecNumber(Number,FmtStr,DFlag)
	Q $p(Ret,"^",1)
}

/// Descript:格式化库存数量
/// CreateDate:	2014-01-08
/// Creater：wyx
/// Input:Number-数值,HospID:医院id,DFlag:1,入库单位，2：基本单位
/// Return:		四舍五入后未格式化,格式(如"0.00")
ClassMethod FormatSq(Number, HospID, DFlag) As %Library.String
{
	N (Number,HospID,DFlag)
	Q:+Number=0 0
	//S Perv=HospID_"^DHC"    ;权限字符串(医院ID^DHC)
	s StrParam="^^^"_HospID
	S FmtStr=..GetCommPropValue("FmtSQ",StrParam)
	Q:FmtStr="" Number
	S Ret=..FNDecNumber(Number,FmtStr,DFlag)
	Q $p(Ret,"^",1)
}

/// Descript:	取公共的参数设置
/// CreateDate:	2011-03-17
/// Creater：	周永刚
/// Input:		APName-参数名称
/// Return:		参数设置的属性值
ClassMethod GetCommPropValue(APName, StrParam = "") As %Library.String
{
	N (APName,StrParam)
	s CommonAppName="DHCSTCOMMONM"
	S CMValue=..GetAppPropValue(CommonAppName,APName,StrParam)
	Q CMValue
}

/// Descript:	取格式后的数值
/// CreateDate:	2011-03-17
/// Creater：	周永刚
/// Input:		Number-格式前的数值，FmtStr-格式(如"0.00",或"#,##0.00"),DFlag(1-入库单位,2-基本单位,只对参与计算的价格有意义,其他都是1)
/// Return:		四舍五入后未格式化^四舍五入后格式化,格式(如"0.00",或"#,##0.00")
ClassMethod FNDecNumber(Number, FmtStr, DFlag = 1) As %Library.String [ Private ]
{
		N (Number,FmtStr,DFlag)
		S Number=$tr(Number,",")	//转换成正常数值格式
		S Fmt="" 			//format
		S DecStr=$P(FmtStr,".",2)
		S FmtDecLen=$L(DecStr)	//小数位数
		I DFlag'=1 D
		.S DecLen=FmtDecLen+4
		E  D
		.S DecLen=FmtDecLen
		I $f(FmtStr,",")'=0 S Fmt=","
		S FmtNumber=$FN(Number,Fmt,FmtDecLen)
		S DecNumber=+$FN(Number,"",DecLen)
		S Ret=DecNumber_"^"_FmtNumber
		Q Ret
}

/// Descript:加锁
/// CreateDate:	2012-06-18
/// Creater:zhangdongmei
/// Input:锁名(PURPLANNO:生成采购计划单号)
/// Return:	0，成功;
ClassMethod Lock(LockName) As %Library.String
{
	N (LockName)
	l +^DHCSTMLOCK(LockName):20 e  q -99   ;加锁失败
	q 0
}

/// Descript:加锁
/// CreateDate:	2012-06-18
/// Creater:zhangdongmei
/// Input:锁名(PURPLANNO:生成采购计划单号)
/// Return:
ClassMethod UnLock(LockName) As %Library.String
{
	N (LockName)
	l -^DHCSTMLOCK(LockName)
	q
}

/// Descript:根据药品(物资)desc获取返回汉字的编码信息(处理问号等问题)
/// CreateDate：2013-07-24
/// Creator：wangjiabin
/// Input:汉字字符串
/// Return:返回编码信息
/// w ##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE("★(静配正规）胰岛素注射液[10ml:400u]")
ClassMethod GetCNCODE(str As %String, FLAG As %String = "4", SPLIT = "", MAXLEN As %String = "") As %Library.String
{
	n (str,FLAG,SPLIT,MAXLEN)
	i str["[" d
	.s str=$p(str,"[",1)	//去掉规格[spec]部分
	.
	s str=$$ALPHAUP^SSUTIL4(str)
	s str=..zhanGetCNCODE(str,FLAG,SPLIT)
	s str=$tr(str,"(")		//去掉可能出现的全角括号带来的干扰
	s str=$tr(str,")")
	s str=$tr(str,"?")		//去掉括号等特殊字符带来的"?"
	
	;最大长度截取
	i (+MAXLEN>0)&&($l(str)>+MAXLEN) d
	.s str=$e(str,1,+MAXLEN)
	
	q str
}

/// Creator:ZhanMingChao
/// Description:返回汉字的编码信息
/// Input：	HANZI:汉字
/// 			FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码6:五笔码7:区位码8:笔划数9:郑码)
/// 			SPLIT:分割符(可以为空)
/// Output：
/// 	非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
/// 	0：未找到编码信息
/// CreatDate:2011-06-08
/// rem: 2014-10-24 独立出来,不再到医保程序调用
/// w ##class(web.DHCSTMHUI.Common.AppCommon).zhanGetCNCODE("东华",4,"^")
ClassMethod zhanGetCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
	s Rtnstr="0"
	q:$g(HANZIS)="" Rtnstr
	s Rtnstr=""
	f i=1:1:$l(HANZIS) d
	.s HANZI=$EXTRACT(HANZIS,i)
	.s ASCIICODE=$ASCII(HANZI)
	.i $D(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0 d
	..s rowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
	..s tmpstr=""
	..s:FLAG="" tmpstr=$g(^DHCCharacterEncoding(rowid))
	..s:FLAG'="" tmpstr=$p(^DHCCharacterEncoding(rowid),"^",FLAG)
	..s:(tmpstr'="")&&(FLAG=6) tmpstr=$e(tmpstr,1)
	..i Rtnstr=""  d
	...s Rtnstr=tmpstr
	..e  d
	...s Rtnstr=Rtnstr_SPLIT_tmpstr
	.e  d
	..s:Rtnstr="" Rtnstr="?"
	..s Rtnstr=Rtnstr_SPLIT_"?"
	q Rtnstr
}

ClassMethod SetStockLoc(loc)
{
	s %session.Data("CurrentStkLoc")=loc
	q
}

/// Description:根据AppName,获取相应参数值
/// Creator:	wangjiabin
/// CreateDate:	2016-07-08
/// Input:		AppName, Param(安全组id^科室id^人员id)
/// Return:		js-object格式 {参数1:参数值1,参数2:参数值2,...}
/// w ##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropStr("DHCSTRETURNM","111^153^541")
ClassMethod GetAppPropStr(AppName As %String, Param As %String) As %String
{
	n (AppName,Param)
	q:AppName="" "{}"
	s AppId=..GetAppID(AppName)
	q:AppId="" "{}"
	s LocId=$p(Param,"^",2)
	s HospId=""
	s:LocId'="" HospId=$p($g(^CTLOC(LocId)),"^",22)
	s $p(Param,"^",4)=HospId
	
	s (TitleStr,DataStr)=""
	s APCh=""
	f  s APCh=$o(^DHCSSA(AppId,"AP",APCh)) q:APCh=""  d
	.s APCode=$p(^DHCSSA(AppId,"AP",APCh),"^",1)
	.q:APCode=""
	.s APValue=..GetAppPropValue(AppName,APCode,Param)
	.
	.i TitleStr="" d
	..s TitleStr=APCode
	..s DataStr=APValue
	.e  d
	..s TitleStr=TitleStr_"^"_APCode
	..s DataStr=DataStr_"^"_APValue
	
	s PropValueStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q PropValueStr
}

}
