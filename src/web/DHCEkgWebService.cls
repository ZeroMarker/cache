/// web.DHCEkgWebServiceNew   ----湘雅医院,调用EKG命名空间独立类借口-----
/// For DHC EKG Studio System . 2008-12-30, Created by Rocky Lau .
/// 公布的Webservice方法，提供给EKGStudio系统使用
Class web.DHCEkgWebService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCEkgWebServiceNew";

//Parameter LOCATION = "http://localhost/csp/websource";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/EKG";

/// TODO: add arguments and implementation.
/// Test
/// 测试
ClassMethod Test() As %String [ WebMethod ]
{
	Quit "Test: if you see this ,  you can continue . -- liu peng"
}

/// Creator：      liupeng
/// CreatDate：    2008-12-30
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 按照输入条件查询符合条件的数据集 
/// Table：        
/// Input：        执行科室id；登记号；起始日期；终止日期
/// Output：       记录
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：       返回的最后一个字段是医嘱状态，其它分别是：
/// 					"TPattype:%String,TRegNo:%String,TStudyID:%String,TName:%String,
/// 					TSex:%String,TAge:%String,TBrithday:%String,TOrderItem:%String,
/// 					TStudyWay:%String,TStudyStatus:%String,TRptID:%String,TRptStatus:%String,
/// 					TImgCount:%String,TClinic:%String,TReqDocName:%String,TReqLocName:%String,
/// 					TRptDocName:%String,TRptDate:%String,TRptTime:%String,TVerifyDocName:%String,
/// 					TVerifyDate:%String,TVerifyTime:%String,TIsJZ:%String,TIsYX:%String,
/// 					TIsTSBL:%String,TIsKYBL:%String,TRegDate:%String,RegTime:%String,
/// 					TTotalPrice:%String,TEQdesc:%String,TOrderDate:%String,
/// 					TOrderTime:%String,TAccessionNum:%String,GetIndex:%String,
/// 					AppointDate:%String,AppointTime:%String,GetResDesc:%String,
/// 					Getifbed:%String,GetIPNo:%String,GetWardName:%String,Getroomdesc:%String,
/// 					GetBedNo:%String,feetype:%String,BodyPart:%String,Getbilled:%String,
/// 					MainDoc:%String,AssiantDoc:%String,Paadmdr:%String,OEordDR:%String,
/// 					GroupDesc:%String,OldNo:%String,Required:%String,SafetynetCardNo:%String,
/// 					TMemo:%String,TCallStatus:%String,TNumber:%String,TTelphone:%String,
/// 					TOEItemNum:%String,TAssisName:%String,TRoomIndex:%String,TReportInfo:%String")
/// History	2008-12-30	liupeng	根据RIS产品的脚本改造
/// 			2009-03-11	liupeng	增加注释
ClassMethod GetEKGInfoTxt(LocId As %String, InRegNo As %String) As %String [ WebMethod ]
{
	s return=""
	s return=##class(web.DHCEkgService).GetEKGInfoTxt(LocId,InRegNo) //,StartDate,Enddate)
	//i return="" s return="该申请号  "_InRegNo_" 不存在"
	q return
}

/// Creator：      liupeng
/// CreatDate：    2008-12-30
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 更新检查医嘱状态
/// Table：        
/// Input：        用户id；医嘱号；子类；状态；病人主索引
/// Output：       
/// Return：       
/// Others：       此方法慎用，可能导致用户纠纷，Status为"E",变成“执行”；"V",变成“核实”
/// History	2008-12-30	liupeng	根据RIS产品的脚本改造
/// 			2009-03-11	liupeng	增加注释
ClassMethod UpdataOrdInfo(OrditmRowids As %String, Status As %String) As %String [ WebMethod ]
{
	s return=##class(web.DHCEkgService).UpdataOrdInfo("", OrditmRowids,"", Status, "")
	q return
}

/// Creator：      liupeng
/// CreatDate：    2009-06-17
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 更新诊断结论及报告状态
/// Table：        
/// Input：        OrditmRowids-医嘱号；
/// 				BaseInfo- 病人类型^报告书写者代码^确认者^终审者
/// 				DiagInfo- 临床诊断
/// 				ExtInfo- 检查所见^诊断意见^其它
/// Output：       
/// Return：       暂未定义
/// History	2009-06-17	liupeng	创建
/// 		2009-06-22	hulifei	调试&修正bug
ClassMethod UpdataRptInfo(OrditmRowids As %String, BaseInfo As %String, DiagInfo As %String, ExtInfo As %String) As %String [ WebMethod ]
{
	s PatType=""
	s ReportUser="" 
	s AffirmUser="" 
	s ArbiterUser="" 
	s ClinicInfo="" 
	s ExamDesc="" 
	s ExamResult=""
	
	s DHCEkgVersion=""
	
	s CurrSpace=$ZNSPACE
	s DHCEkgVersion=##class(web.DHCEkgService).GetDHCEkgVersion()
	zn CurrSpace
	
	i (OrditmRowids'="")&(BaseInfo'="")&(ExtInfo'="")  d
    .s PatType=$p(BaseInfo,"^",1)
	.s ReportUser=$p(BaseInfo,"^",2)
	.s AffirmUser=$p(BaseInfo,"^",3) 
	.s ArbiterUser=$p(BaseInfo,"^",4)
	.s ClinicInfo=DiagInfo
	.s ExamDesc=$p(ExtInfo,"^",1) 
	.s ExamResult=$p(ExtInfo,"^",2)  
	.//宁波上了体检系统
	.//i (DHCEkgVersion="NBMZ")  d
	..//d ##class(web.DHCEkgInternalService).UpdatePEResult(OrditmRowids, ReportUser, ArbiterUser, ClinicInfo, ExamDesc, ExamResult)
	Q "OK"
}

/// GetCTLOCList
/// Creator：      liupeng
/// CreatDate：    2008-12-30
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 获取所有科室代码集合
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
/// History	2008-12-30	liupeng	参考RIS产品的脚本创建
/// 			2009-03-11	liupeng	增加注释
ClassMethod GetCTLOCList() As %String [ WebMethod ]
{
	s return=##class(web.DHCEkgService).GetCTLOCList()
	q return
}

/// EKGGetDeptCodeList
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 获取所有科室代码集合
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
ClassMethod EKGGetDeptCodeList() As %String [ WebMethod ]
{
	s return=##class(web.DHCEkgService).EKGGetDeptCodeList()
	q return
}

/// EKGGetDeptByCode
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 根据科室RowId，获取科室信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
ClassMethod EKGGetDeptByCode(CtLocId As %String) As %String [ WebMethod ]
{
	s return=##class(web.DHCEkgService).EKGGetDeptByCode(CtLocId)
	q return
}

/// EKGGetExamCodeList
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 取检查类的医嘱RowId
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
ClassMethod EKGGetExamCodeList(OrdCat As %String) As %String [ WebMethod ]
{
	;w ##Class(web.DHCEkgService).EKGGetExamCodeList(1)
	s:OrdCat="" OrdCat="1"
	s return=##class(web.DHCEkgService).EKGGetExamCodeList(OrdCat)
	q return
}

/// EKGGetExamByCode
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 根据检查类的RowId取医嘱信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
ClassMethod EKGGetExamByCode(ArcimId As %String) As %String [ WebMethod ]
{
	;w ##Class(web.DHCEkgService).EKGGetExamByCode()
	s return=##class(web.DHCEkgService).EKGGetExamByCode(ArcimId)
	q return
}

/// EKGGetUserCodeList
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 用户基本信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
ClassMethod EKGGetUserCodeList() As %String [ WebMethod ]
{
	;w ##Class(web.DHCEkgService).EKGGetUserCodeList()
	s return=##class(web.DHCEkgService).EKGGetUserCodeList()
	q return
}

/// EKGGetUserByCode
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 用户基本信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
ClassMethod EKGGetUserByCode(UserId As %String) As %String [ WebMethod ]
{
	;w ##Class(web.DHCEkgService).EKGGetUserCodeList()
	s return=##class(web.DHCEkgService).EKGGetUserByCode(UserId)
	q return
}

/// UserAuthenticate
/// Creator：      liupeng
/// CreatDate：    2008-12-30
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 用户登陆验证
/// Table：        
/// Input：        用户名，密码
/// Output：       
/// Return：       返回类似：23296^ys001^医师测试1^1188^医师测试1；非法登陆返回都为空
/// Others：
/// History	2008-12-30	liupeng	参考RIS产品的脚本创建
/// 			2009-03-11	liupeng	增加注释
ClassMethod UserAuthenticate(User As %String, PWD As %String) As %String [ WebMethod ]
{
	s return=##class(web.DHCEkgService).UserLogon(User,PWD)
	q return
}

/// GetEKGRegList,
/// 返回类似：00014143$99950061$99950093$99950093$00014143
/// Creator：      liupeng
/// CreatDate：    2009-03-05
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description：  获取指定执行科室、指定时间段内的“核实”状态的医嘱列表
/// Table：        
/// Input：        执行科室、指定时间段内
/// Output：       
/// Return：       返回类似：00014143$99950061$99950093$99950093$00014143
/// Others：
/// History	2008-03-05	liupeng	参考RIS产品的脚本创建
/// 			2009-03-11	liupeng	增加注释
ClassMethod GetEKGRegList(LocId As %String, StartDate As %String, Enddate As %String) As %String [ WebMethod ]
{
	s return=##class(web.DHCEkgService).GetEKGRegList(LocId,StartDate,Enddate)
	q return
}

/*
/// GetEKGRegList,
/// 返回类似：-201^^^0^0^0^^2416174^0002436125^2501710^P^PC^16^
/// Creator：      liupeng
/// CreatDate：    2009-04-28
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description：  根据制定卡号找到对应的登记号
/// Table：        
/// Input：        磁卡卡号
/// Output：       
/// Return：       返回类似：-201^^^0^0^0^^2416174^0002436125^2501710^P^PC^16^
/// Others：
/// History	2008-04-28	liupeng	创建
ClassMethod GetEKGRegNoByCardNo(CardNo As %String) As %String [ WebMethod ]
{

	//s return=##class(web.DHCEkgService).GetEKGRegList(LocId,StartDate,Enddate)
	//s return="-201^^^0^0^0^^2416174^0002436125^2501710^P^PC^16^"
	//下面这一句是华西第一医院根据卡号定位登记号的功能函数
	//s return=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CardNo,"",""_$c(2)_"16"_$c(2)_"PatInfo")
	q return
}


/// Creator：      liupeng
/// CreatDate：    2009-06-08
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 按照输入条件查询符合条件的数据集 
/// Table：        
/// Input：        执行科室id；登记号；科室id可为空
/// Output：       记录
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：       返回的最后一个字段是医嘱状态，全部内容请参考GetEKGInfoTxt函数
/// History	2009-06-08	liupeng	根据产品的原有脚本改造
/// 			2009-03-11	liupeng	创建方法
/// 			2009-03-11	liupeng 隐去WebMethod，嵌入到GetEKGInfoTxt函数中
ClassMethod GetEKGInfoTxtByLR(LocId As %String, InRegNo As %String) As %String [ WebMethod ]
{
	s return=##class(web.DHCEkgService).GetEKGInfoTxtByLR(LocId,InRegNo)
	q return
}

/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 按照输入条件查询符合条件的数据集 
/// Table：        
/// Input：        执行科室id；登记号；科室id可为空
/// Output：       记录
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：       返回的最后一个字段是医嘱状态，全部内容请参考GetEKGInfoTxt函数
/// History	2009-06-08	liupeng	根据产品的原有脚本改造
/// 			2009-03-11	liupeng	创建方法
/// 			2009-03-11	liupeng 隐去WebMethod，嵌入到GetEKGInfoTxt函数中
ClassMethod GetEKGInfoTxtByEmrFlow(LocId As %String, InRegNo As %String) As %String [ WebMethod ]
{
	s return=##class(web.DHCEkgService).GetEKGInfoTxtByEmrFlow(LocId,InRegNo)
	q return
}
*/
}
