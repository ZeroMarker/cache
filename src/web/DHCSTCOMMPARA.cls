Import SQLUser

/// Descript:取公共参数设置的函数
/// CreateDate：2011-03-17
/// Creater：周永刚
Class web.DHCSTCOMMPARA Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Descript:取应用程序ID
/// CreateDate：2011-03-08
/// Creater：周永刚 
/// Table：	DHC_StkSysApp
/// Input:应用程序代码
/// Output:
/// Return:应用程序ID
ClassMethod GetAppID(AppCode As %String) As %String
{
 //N (AppCode)
 S AppCode=$$ALPHAUP^SSUTIL4(AppCode)
 Q:AppCode="" ""
 S App=$O(^DHCSSA(0,"ACODE",AppCode,""))
 Q App
}

/// Descript:精确查询应用程序参数配置属性,查找符合条件的最小级别的属性值
/// CreateDate：2011-03-08
/// Creater：周永刚 
/// Table：	DHC_StkSysApp
/// Input:App-应用程序代码,APName-应用程序属性名称,APPerv-权限ID字符串(用户ID^科室ID^安全组ID^Drug或Material^医院ID(STCUS_RowID,bs药库版为CT_Hospital的ID)^DHC)
/// Return:属性值
ClassMethod GetAppPropValue(AppCode As %String, APName As %String, APPerv As %String) As %String
{
 //N (AppCode,APName,APPerv)
 S APValue=""
 //判断项目版本
 s ver=..GetSysAppVersion()
 i ver'="" d
 .s GroupId=$p(APPerv,"^",3)
 .s LocId=$p(APPerv,"^",2)
 .s UserId=$p(APPerv,"^",1)
 .s HospId=$p(APPerv,"^",5)
 .s APPerv=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
 .s APValue=##Class(web.DHCST.Common.AppCommon).GetAppPropValue(AppCode,APName,APPerv)
 q:ver'="" APValue
 //
 Q:AppCode="" APValue
 S App=..GetAppID(AppCode)
 Q:App="" APValue
 S APName=$$ALPHAUP^SSUTIL4(APName)
 Q:APName="" APValue
 s PervList=..GetPervIDList(APPerv)
 q:PervList="" APValue
 s lenPerv=$l(PervList,"^")
 q:lenPerv=0 APValue
 f i=1:1:lenPerv q:APValue'=""  d
 .s SSPID=$p(PervList,"^",i)
 .q:SSPID=""
 .s SSAPSub=$O(^DHCSSA(0,"PAPPID",SSPID,App,APName,"")) 
 .q:SSAPSub=""
 .S APValue=$P(^DHCSSA(App,"AP",SSAPSub),"^",3)
 //S SSPLevel=""	//级别
 //F  S SSPLevel=$O(^DHCSSA(0,"APLEVEL",App,APName,SSPLevel)) Q:(SSPLevel="")!(APValue'="")  D
 //.S SSPID=""
 //.F  S SSPID=$O(^DHCSSA(0,"APLEVEL",App,APName,SSPLevel,SSPID)) Q:(SSPID="")!(APValue'="")  D
 //..S CurList=##Class(web.DHCSTCOMMO).FindInList(APPerv,SSPID,"^")
 //..b //44
 //..I CurList>0 D
 //...S SSAPSub=$O(^DHCSSA(0,"APLEVEL",App,APName,SSPLevel,SSPID,""))
 //...S APValue=$P(^DHCSSA(App,"AP",SSAPSub),"^",3)
 //b //33
 Q APValue
}

/// Descript:	取公共的参数设置
/// CreateDate:	2011-03-17
/// Creater：	周永刚
/// Input:		APName-参数名称，Perv-权限字符串(用户ID^科室ID^安全组ID^Drug或Material^医院ID(STCUS_RowID,bs药库版为CT_Hospital的ID)^DHC)
/// Return:		参数设置的属性值
ClassMethod GetCommPropValue(APName As %String, Perv As %String) As %String
{
 //N (APName,Perv)
 S CMValue=..GetAppPropValue("DHCSTCOMMON",APName,Perv)
 Q CMValue
}

/// Descript:	取格式后的数值
/// CreateDate:	2011-03-17
/// Creater：	周永刚
/// Input:		Number-格式前的数值，FmtStr-格式(如"0.00",或"#,##0.00"),DFlag(1-入库单位,2-基本单位,只对参与计算的价格有意义,其他都是1)
/// Return:		四舍五入后未格式化^四舍五入后格式化,格式(如"#.00",或"#,##0.00")
ClassMethod FNDecNumber(Number As %String, FmtStr As %String, DFlag As %String = 1) As %String
{
 //N (Number,FmtStr,DFlag)
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
 S DecNumber=$FN(Number,"",DecLen)
 S Ret=DecNumber_"^"_FmtNumber
 Q Ret
}

/// Descript:	取数值格式后的数值
/// CreateDate:	2011-03-17
/// Creater：	周永刚
/// Input:		Number-数值,Perv-权限字符串(^^^Drug或Material^医院ID(STCUS_RowID,bs药库版为CT_Hospital的ID)^DHC),Prop-参数属性,DFlag(1-入库单位,2-基本单位,只对参与计算的价格有意义,其他都是1)
/// Return:		四舍五入后未格式化^四舍五入后格式化,格式(如"0.00",或"#,##0.00")
ClassMethod GetNumbFNDec(Number As %String, Perv As %String, Prop As %String, DFlag As %String = 1) As %String
{
 //N (Number,Perv,Prop,DFlag)
 s Number=+Number
 Q:Number=0 0_"^"_0
 s FmtStr=..GetHospComPropValue(Prop,$p(Perv,"^",5))
 Q:FmtStr="" Number_"^"_Number
 S Ret=..FNDecNumber(Number,FmtStr,DFlag)
 Q Ret
}

/// Descript:	取数值格式后的数值
/// CreateDate:	2011-03-17
/// Creater：	周永刚
/// Input:		Number-数值,Perv-权限字符串(^^^Drug或Material^医院ID(STCUS_RowID)^DHC),Prop-参数属性,DFlag(1-入库单位,2-基本单位,只对参与计算的价格有意义,其他都是1)
/// Return:		四舍五入后未格式化,格式(如"0.00")
ClassMethod GetNumbDec(Number As %String, Perv As %String, Prop As %String, DFlag As %String = 1) As %String
{
 
 S FNDecStr=..GetNumbFNDec(Number,Perv,Prop,DFlag)
 S Ret=$P(FNDecStr,"^",1)
 q Ret
}

/// Descript:	取数值格式后的数值
/// CreateDate:	2011-03-17
/// Creater：	周永刚
/// Input:		Number-数值,Perv-权限字符串(^^^Drug或Material^医院ID(STCUS_RowID)^DHC),Prop-参数属性,DFlag(1-入库单位,2-基本单位,只对参与计算的价格有意义,此函数作为显示用都是1)
/// Return:		四舍五入后格式化,格式(如"#,##0.00")
ClassMethod GetNumbFN(Number As %String, Perv As %String, Prop As %String, DFlag As %String = 1) As %String
{
 //N (Number,Perv,Prop,DFlag)
 S FNDecStr=..GetNumbFNDec(Number,Perv,Prop,DFlag)
 S Ret=$P(FNDecStr,"^",2)
 Q Ret
}

/// Descript:	取集团化医院标志
/// CreateDate:	2011-04-14
/// Creater：	周永刚
/// Input:		
/// Return:		1-是,0-否	
ClassMethod GetGroupFlag(hosp = "") As %String
{
	/*
	q ..GetHospComPropValue("GroupFlag",hosp)
	*/
	
	 //重写 2021-03-17 yangsj
	 s GroupFlag = ""
	 s App=$O(^DHCSSA(0,"ACODE","DHCSTCOMMON",0))
	 s chl=$O(^DHCSSA(0,"APCODE",App,"GROUPFLAG",0))
	 s sub=$O(^DHCSSA(App,"AP",chl,"PF",0))
	 i sub'="" s GroupFlag = $p(^DHCSSA(App,"AP",chl,"PF",sub),"^",3)
	 e  s GroupFlag = $p(^DHCSSA(App,"AP",chl),"^",3)
	 q GroupFlag
}

/// Descript:	取进价规则
/// CreateDate:	2013-03-20
/// Creater：	周永刚
/// Input:		HospID(院区ID),DateH(+$h格式的日期,该日期因业务不同而不同,空为当前日期)
/// Return:		1-按入库进价，2-按统一进价(调价进价)，3-按批次进价
/// Modify:     2013-07-01,增加批次价规则
/// 			2019-08-13,增加生效日期判断
/// w ##class(web.DHCSTCOMMPARA).GetRpRule()
ClassMethod GetRpRule(HospID As %String = "", DateH = "") As %String
{
	//N (HospID)
	/*
	s CustID=##Class(web.DHCSTCOMMO).GetCusIDByHospID(HospID)	//zhouyg 20141225
	S Prop="RpRule"
	S Perv="^^^^"_CustID_"^DHC"
	S RetFlag=..GetCommPropValue(Prop,Perv)
	q RetFlag
	*/
	i DateH="" s DateH=+$h
	i DateH'=+DateH s DateH=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(DateH)
	q:$d(^||GetRpRule(+HospID,+DateH)) ^||GetRpRule(+HospID,+DateH)
	s APValue=""
	s App=$O(^DHCSSA(0,"ACODE","DHCSTCOMMON",0))
	q:App="" APValue
	s Chl=$o(^DHCSSA(0,"APCODE",App,"RPRULE",0)) 
	q:Chl="" APValue
	s RetVal=""
	i HospID'="" d
	.s Sub=""
	.// 倒序,维护的数据肯定是按日期增加上来的
	.f  s Sub=$o(^DHCSSA(0,"HOSPTypePointer",HospID,"D","DHC",App,Chl,Sub),-1) q:(Sub="")||(RetVal'="")  d
	..q:+Sub=0
	..s DHCSSAAPPF=$g(^DHCSSA(App,"AP",Chl,"PF",Sub))
	..s APValue=$p(DHCSSAAPPF,"^",3)
	..s StDate=$p(DHCSSAAPPF,"^",5)
	..i StDate="" s StDate=21550
	..i (StDate'="")&&(DateH>=StDate) s RetVal=APValue
	
	s groupFlag = ..GetGroupFlag()
	i groupFlag = 2 s ^||GetRpRule(+HospID,+DateH)=RetVal q RetVal
	
	i RetVal=""  d
	.s Sub=""
	.f  s Sub=$o(^DHCSSA(0,"TypePointer","D","DHC",App,Chl,Sub),-1) q:(Sub="")||(RetVal'="")  d
	..q:+Sub=0
	..s DHCSSAAPPF=$g(^DHCSSA(App,"AP",Chl,"PF",Sub))
	..s APValue=$p(DHCSSAAPPF,"^",3)
	..s StDate=$p(DHCSSAAPPF,"^",5)
	..i StDate="" s StDate=21550
	..i (StDate'="")&&(DateH>=StDate) s RetVal=APValue
	
	s ^||GetRpRule(+HospID,+DateH)=RetVal
	q RetVal
}

/// Descript:	根据权限字符串取维护的权限ID
/// CreateDate:	2011-08-30
/// Creater：	周永刚
/// Table:		DHC_StkSysPerview
/// Input:		APPerv-权限ID字符串(用户ID^科室ID^安全组ID^Drug或Material^医院ID(STCUS_RowID)^DHC
/// Return:		已经维护的权限字符串ID("^"分隔)
ClassMethod GetPervIDList(APPerv) As %String
{
 //N (APPerv)
 s plen=$l(APPerv,"^")
 q:plen'=6 ""	//传入字符串必须6级
 s RetStr=""
 //1 按用户
 s point1=$p(APPerv,"^",1)
 i point1'="" d
 .s sspID=$o(^DHCSSP(0,"TP","U",point1,""))
 .i sspID'="" d
 ..s RetStr=sspID
 //2 按科室
 s point2=$p(APPerv,"^",2)
 i point2'="" d
 .s sspID=$o(^DHCSSP(0,"TP","L",point2,""))
 .i sspID'="" d
 ..i RetStr="" d
 ...s RetStr=sspID
 ..e  d
 ...s RetStr=RetStr_"^"_sspID
 //3 按安全组
 s point3=$p(APPerv,"^",3)
 i point3'="" d
 .s sspID=$o(^DHCSSP(0,"TP","G",point3,""))
 .i sspID'="" d
 ..i RetStr="" d
 ...s RetStr=sspID
 ..e  d
 ...s RetStr=RetStr_"^"_sspID
 //4 按药品和材料
 s point4=$p(APPerv,"^",4)
 i point4'="" d
 .s sspID=$o(^DHCSSP(0,"TP","S",point4,""))
 .i sspID'="" d
 ..i RetStr="" d
 ...s RetStr=sspID
 ..e  d
 ...s RetStr=RetStr_"^"_sspID
 //5 按医院
 s point5=$p(APPerv,"^",5)
 i point5'="" d
 .s sspID=$o(^DHCSSP(0,"TP","H",point5,""))
 .i sspID'="" d
 ..i RetStr="" d
 ...s RetStr=sspID
 ..e  d
 ...s RetStr=RetStr_"^"_sspID
 //6 按系统
 s point6=$p(APPerv,"^",6)
 i point6'="" d
 .s sspID=$o(^DHCSSP(0,"TP","D",point6,""))
 .i sspID'="" d
 ..i RetStr="" d
 ...s RetStr=sspID
 ..e  d
 ...s RetStr=RetStr_"^"_sspID
 Q RetStr
}

/// Descript:	检查系统设置是否新版本,存在子表,
/// CreateDate:	2013-12-30
/// Creater：	LiangQiang
/// Table:		DHC_StkSysApp
/// Input:		
/// Return:		空-旧版,非空-新版
ClassMethod GetSysAppVersion() As %String
{
	 
	 s SSACode="DHCSTCOMMON"
	 S SSACode=$$ALPHAUP^SSUTIL4(SSACode)
	 s rowid=""
	 s ssa=$o(^DHCSSA(0,"ACODE",SSACode,0))
	 q:ssa="" rowid
	 s chl=$o(^DHCSSA(ssa,"AP",0)) 
	 q:chl="" rowid
	 s sub=$o(^DHCSSA(ssa,"AP",chl,"PF",0))
	 q:sub="" rowid
	 s rowid=ssa_"||"_chl_"||"_sub
	 q rowid
}

/// Descript:	取批次索引规则
/// CreateDate:	2014-05-26
/// Creater：	wyx
/// Input:		
/// Return:0为先进先出，1-效期优先
ClassMethod GetSelBatRule(HospID As %String = "") As %String
{
 //N (HospID)
 s CustID=##Class(web.DHCSTCOMMO).GetCusIDByHospID(HospID)	//zhouyg 20141225
 //s CustID=""
 //i HospID'="" d
 //.s CustID=$O(^STCUS(0,"HOSPID",HospID,""))
 S Prop="SelBatRule"
 S Perv="^^^^"_CustID_"^DHC"
 S RetFlag=..GetCommPropValue(Prop,Perv)
 Q RetFlag
}

/// Descript:	取人员密级调用标志
/// CreateDate:	2015-01-30
/// Creater：	曹霆
/// Input:		
/// Return:		0-不调用 1-调用
ClassMethod GetEncryptLevelFlag(HospID As %String = "") As %String
{
 //N (HospID)
 s CustID=##Class(web.DHCSTCOMMO).GetCusIDByHospID(HospID)	//zhouyg 20141225
 //s CustID=""
 //i HospID'="" d
 //.s CustID=$O(^STCUS(0,"HOSPID",HospID,""))
 S Prop="EncryptLevelFlag"
 S Perv="^^^^"_CustID_"^DHC"
 S RetFlag=..GetCommPropValue(Prop,Perv)
 Q RetFlag
}

/// Descript:	取Portal调用标志
/// CreateDate:	2015-11-09
/// Creater：	yunhaibao
/// Input:		
/// Return:		0-不调用 1-调用
/// w ##class(web.DHCSTCOMMPARA).GetSendPortalFlag()
ClassMethod GetSendPortalFlag(HospID As %String = "") As %String
{
 //N (HospID)
 s CustID=##Class(web.DHCSTCOMMO).GetCusIDByHospID(HospID)	//zhouyg 20141225
 //s CustID=""
 //i HospID'="" d
 //.s CustID=$O(^STCUS(0,"HOSPID",HospID,""))
 S Prop="SendPortalFlag"
 S Perv="^^^^"_CustID_"^DHC"
 S RetFlag=..GetCommPropValue(Prop,Perv)
 Q RetFlag
}

/// Descript:	批次价下医嘱分配批次规则参数
/// CreateDate:	2017-06-09
/// Creater：	yunhaibao
/// w ##class(web.DHCSTCOMMPARA).GetSelOrderBatRule(2)
ClassMethod GetSelOrderBatRule(HospID As %String = "") As %String
{
 s CustID=##Class(web.DHCSTCOMMO).GetCusIDByHospID(HospID)	
 S Prop="SelOrderBatRule"
 S Perv="^^^^"_CustID_"^DHC"
 S RetFlag=..GetCommPropValue(Prop,Perv)
 Q RetFlag
}

/// Description: 仅仅是根据医院来获取公共参数(解决取价格速度问题),无值取默认
ClassMethod GetHospComPropValue(propCode, hosp)
{
	q:$d(^||GetHospComPropValue(propCode,+hosp)) ^||GetHospComPropValue(propCode,+hosp)
	s app = ..GetAppID("DHCSTCOMMON")
	s chl = $o(^DHCSSA(0,"APCODE", app, $$ALPHAUP^SSUTIL4(propCode), 0))
	q:(+app = 0)||(+chl = 0) ""
	s sub = $o(^DHCSSA(0, "HOSPTypePointer", +hosp, "D", "DHC", app, chl, ""), -1)
	s val=""
	i +sub '= 0 d
	.s val = $p($g(^DHCSSA(app, "AP", chl, "PF", sub)), "^", 3)
	i val = "" d
	.s val = $p(^DHCSSA(app, "AP", chl),"^",3)
	s ^||GetHospComPropValue(propCode,+hosp)=val
	q val
}

}
