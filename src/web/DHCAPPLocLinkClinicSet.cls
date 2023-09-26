Import sqluser

Class web.DHCAPPLocLinkClinicSet Extends DHCDoc.Util.RegisteredObject [ Not ProcedureBlock ]
{

/// Description: 查询出科室的信息
/// Creator:     wangxuejian
/// CreateDate:  2017-02-23  
/// Table: 		 CT_LOC
/// Output:  	 所有科室描述、代码、科室id
/// w ##class(web.DHCAPPLocLinkClinicSet).QueryLocInfor(30,1,"") 
/// 查询科室
ClassMethod QueryLocInfor(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s desc=params
	s h=0,count=0
	s locRowId=0
	f  s locRowId=$o(^CTLOC( locRowId)) q:locRowId=""  d  //查询表ct_loc
	.s locCode=$p(^CTLOC(locRowId),"^",1)
	.s locDesc=$p(^CTLOC(locRowId),"^",2)
	.s locType=$p(^CTLOC(locRowId),"^",13)
	.q:(locType'="E")
	.q:(locDesc'=desc)&(desc'="")
	.s LocDateTo=$p($g(^CTLOC(locRowId)),"^",25)
	.q:(LocDateTo'="")&&(LocDateTo<+$H)
	.s h=h+1
	.s tempstr=locRowId_"^"_locCode_"^"_locDesc
	.s ^TMP("DHCST","web.DHCAPPLocLinkClinicSet","QueryLocInfor",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="LocRowId^LocCode^LocDesc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPLocLinkClinicSet","QueryLocInfor",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCAPPLocLinkClinicSet","QueryLocInfor",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(title,mdate)
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCAPPLocLinkClinicSet","QueryLocInfor",pid)
}

/// Description: 下拉框显示科室
/// Table: 		 CT_LOC
/// Output:  	 所有科室描述（下拉框显示） 
/// W ##class(web.DHCAPPLocLinkClinicSet).SelAllLoc() 
ClassMethod SelAllLoc(HospID) As %String
{
	n (HospID)
	S result = ##class(%Library.ResultSet).%New()
	S sqlStr = "SELECT CTLOC_ROWID as LocDr,CTLOC_DESC as LocDesc FROM CT_LOC"
    D result.Prepare(sqlStr)
	D result.Execute()
	S count = 0
	w "["
	While(result.Next())
	{	
		S locDr = result.Data("LocDr")
		s LocHospitalID=$p($g(^CTLOC(locDr)),"^",22)
		continue:HospID'=LocHospitalID
		S locDesc = result.Data("LocDesc")
		S tmp=locDr_"^"_locDesc
		S count = count+1
		I count=1 D
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
		E  D
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	}
	W "]"
	q ""
}

/// Description: 保存执行报告参数信息
/// Creator:     WangXuejian
/// CreateDate:  2017-02-25
/// Table:		 DHCRBC_ClinicSet
/// Input:  	 DataList: 以字符"^"分割,格式为:id^科室id^执行报告路径^....^报告参数分隔符
/// Return: 	 保存成功 0,保存失败 非0
/// Others:      d ##class(web.DHCAPPLocLinkClinicSet).SaveReport("40^329^超声医学科^http://172.19.19.82/RISWeb3/Default.aspx?Type=6^N^ ^Y^SID^Y^OID^Y^RepID^Y^LID=329^")
ClassMethod SaveReport(params As %String) As %String
{
	N (params)
	s ^tempqujian("SaveReport")=params
	;40^329^1^http://172.19.19.57/RISWeb3/Default.aspx?Type=1^否^^是^&SID^Y^&OID^是^&LID=329^
	S ret=0
	S len=$L(params,"$$")
	F i=1:1:len D
	.S tmpStr=$p(params,"$$",i)
	.s ret = ..InsOrUpdReport(tmpStr,"R")	
	Q ret
}

/// Description: 保存执行报告参数信息
/// Creator:     WangXuejian
/// CreateDate:  2017-02-25
/// Table:		 DHCRBC_ClinicSet
/// Input:  	 DataList: 以字符"^"分割,格式为:id^科室id^执行报告路径^....^报告参数分隔符
/// Return: 	 保存成功 0,保存失败 非0
/// Others:      d ##class(web.DHCAPPLocLinkClinicSet).SaveReport("49^345^http://172.19.19.57/pisRpt/RptForOtherLoc.aspx^是^^是^^否^^")
ClassMethod SaveImage(params As %String) As %String
{
	N (params)
	
	;40^329^1^http://172.19.19.57/RISWeb3/Default.aspx?Type=1^否^^是^&SID^Y^&OID^是^&LID=329^
	S ret=0
	S len=$L(params,"$$")
	F i=1:1:len D
	.S tmpStr=$p(params,"$$",i)
	.s ret = ..InsOrUpdReport(tmpStr,"I")	
	Q ret
}

/// Description: 更新 执行报告参数信息
/// Creator:     WangXuejian
/// CreateDate:  2017-02-25
/// Table:		 DHCRBC_ClinicSet
/// Input:  	 DataList: 以字符"^"分割,格式为:id^科室id^执行报告路径^....^报告参数分隔符
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCAPPLocLinkClinicSet).UpdReport("49^345^http://172.19.19.57/pisRpt/RptForOtherLoc.aspx^是^^是^^否^^^")
ClassMethod InsOrUpdReport(DataList, Model) As %String
{
	N (DataList,Model)
	S RowID=$p(DataList,"^",1)
	S LocDr=$p(DataList,"^",2)
	S FullFile=$p(DataList,"^",4)
	S HasReg=$p(DataList,"^",5)
	S RegParam=$p(DataList,"^",6)
	s HasStudyNo=$p(DataList,"^",7)
	s StuyParam=$p(DataList,"^",8)
	s HasOrdItm=$p(DataList,"^",9)
	s OrdItmParam=$p(DataList,"^",10)	
	s HasRepId=$p(DataList,"^",11)	
	s RepIdParam=$p(DataList,"^",12)	
	s HasOther=$p(DataList,"^",13)     
	s OtherParam=$p(DataList,"^",14)
	s Delim=$p(DataList,"^",15)
	s StartDate=$p(DataList,"^",16)
	if (StartDate'=""){s StartDate=..%ZDH(StartDate)}
	s EndDate=$p(DataList,"^",17)
	if (EndDate'=""){s EndDate=..%ZDH(EndDate)}
	if (StartDate["ERROR") s StartDate=""
	if (EndDate["ERROR") s EndDate=""
	s OpenMethod=$p(DataList,"^",18)
	i (RowID'="")&&(Model="R") d
	.&SQL(Update DHCRBC_ClinicSet Set DPCS_Loc_DR=:LocDr,DPCS_ReportFullFile=:FullFile,
		DPCS_RhasReg=:HasReg,DPCS_RRegParam=:RegParam,DPCS_RhasStudyNo=:HasStudyNo,DPCS_RStuyParam=:StuyParam,
		DPCS_RhasOther=:HasOther,DPCS_ROtherParam=:OtherParam,DPCS_RhasOeord=:HasOrdItm,DPCS_ROeordParam=:OrdItmParam,
		DPCS_RhasRepId=:HasRepId,DPCS_RRepIdParam=:RepIdParam,DPCS_RDelim=:Delim,DPCS_RStartDate=:StartDate,DPCS_REndDate=:EndDate
		,DPCS_ROpenMethod=:OpenMethod WHERE DPCS_RowID=:RowID)
	b ;333
 	i (RowID="")&&(Model="R") d
 	.&SQL(INSERT INTO DHCRBC_ClinicSet
 		(DPCS_Loc_DR,DPCS_ReportFullFile,DPCS_RhasReg,DPCS_RRegParam,DPCS_RhasStudyNo,DPCS_RStuyParam,
 		DPCS_RhasOther,DPCS_ROtherParam,DPCS_RhasOeord,DPCS_ROeordParam,DPCS_RhasRepId,DPCS_RRepIdParam,
 		DPCS_RDelim,DPCS_RStartDate,DPCS_REndDate,DPCS_ROpenMethod) 
 		VALUES   
 		(:LocDr,:FullFile,:HasReg,:RegParam,:HasStudyNo,:StuyParam,:HasOther,:OtherParam,:HasOrdItm,
 		:OrdItmParam,:HasRepId,:RepIdParam,:Delim,:StartDate,:EndDate,:OpenMethod))  
 	i (RowID'="")&&(Model'="R") d
	.&SQL(Update DHCRBC_ClinicSet Set DPCS_Loc_DR=:LocDr,DPCS_ImageFullFile=:FullFile,
		DPCS_IhasReg=:HasReg,DPCS_IRegParam=:RegParam,DPCS_IhasStudyNo=:HasStudyNo,DPCS_IStudyNoParam=:StuyParam,
		DPCS_IhasOther=:HasOther,DPCS_IOtherParam=:OtherParam,DPCS_IhasOeord=:HasOrdItm,
		DPCS_IOeordParam=:OrdItmParam,DPCS_IhasRepId=:HasRepId,DPCS_IRepIdParam=:RepIdParam,
		DPCS_IDelim=:Delim ,DPCS_IStartDate=:StartDate,DPCS_IEndDate=:EndDate,DPCS_IOpenMethod=:OpenMethod WHERE DPCS_RowID=:RowID)	
 	i (RowID="")&&(Model'="R") d
 	.&SQL(INSERT INTO DHCRBC_ClinicSet
 		(DPCS_Loc_DR,DPCS_ImageFullFile,DPCS_IhasReg,DPCS_IRegParam,DPCS_IhasStudyNo,DPCS_IStudyNoParam,
 		DPCS_IhasOther,DPCS_IOtherParam,DPCS_IhasOeord,DPCS_IOeordParam,DPCS_IhasRepId,DPCS_IRepIdParam,
 		DPCS_IDelim,DPCS_IStartDate,DPCS_IEndDate,DPCS_IOpenMethod) 
 		VALUES   
 		(:LocDr,:FullFile,:HasReg,:RegParam,:HasStudyNo,:StuyParam,:HasOther,:OtherParam,:HasOrdItm,
 		:OrdItmParam,:HasRepId,:RepIdParam,:Delim,:StartDate,:EndDate,:OpenMethod))  
 	Q SQLCODE
}

/// Description: 查询出执行报告参数
/// Creator:     wangxuejian
/// CreateDate:  2017-02-23  
/// Table: 		 DHCRBC_ClinicSet
/// Output:  	 表的id、科室rowid、执行报告路径、是否需要登记号、登记号前参数^是否需要检查号、检查号前参数、是否需要其他参数、其他参数、报告参数分隔符
/// w ##class(web.DHCAPPLocLinkClinicSet).QueryReportParam(30,1,1) 
ClassMethod QueryReportParam(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s end=page*rows
	s start=(page-1)*rows+1
	s locRowid=params
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s h=0,count=0
	s DPCSRowID=0
	f  s DPCSRowID=$o(^DHCRBC("ClinicSet",DPCSRowID)) q:DPCSRowID=""  d  //查询表DHCRBC_ClinicSet
	.s DPCSLocRowid=$p(^DHCRBC("ClinicSet",DPCSRowID),"^",1)
	.q:DPCSLocRowid'=locRowid
	.s DPCSReportFullFile=$p(^DHCRBC("ClinicSet",DPCSRowID),"^",2)
	.s DPCSRhasReg=$p(^DHCRBC("ClinicSet",DPCSRowID),"^",3)
	.;s DPCSRhasReg=$s(DPCSRhasReg="Y":"是",DPCSRhasReg="N":"否",1:"")
	.s DPCSRRegParam  =$p(^DHCRBC("ClinicSet",DPCSRowID),"^",4)
	.s DPCSRhasStudyNo=$p(^DHCRBC("ClinicSet",DPCSRowID),"^",5)
	.;s DPCSRhasStudyNo=$s(DPCSRhasStudyNo="Y":"是",DPCSRhasStudyNo="N":"否",1:"")
	.s DPCSRStuyParam=$p(^DHCRBC("ClinicSet",DPCSRowID),"^",6)
	.s DPCSRhasOther=$p(^DHCRBC("ClinicSet",DPCSRowID),"^",14)
	.;s DPCSRhasOther=$s(DPCSRhasOther="Y":"是",DPCSRhasOther="N":"否",1:"")
	.s DPCSROtherParam=$p(^DHCRBC("ClinicSet",DPCSRowID),"^",15)
	.s DPCSRDelim=$p(^DHCRBC("ClinicSet",DPCSRowID),"^",7)
	.s h=h+1
	.s tempstr=DPCSRowID_"^"_DPCSLocRowid_"^"_DPCSReportFullFile_"^"_DPCSRhasReg_"^"_DPCSRRegParam_"^"_DPCSRhasStudyNo_"^"_DPCSRStuyParam_"^"_DPCSRhasOther_"^"_DPCSROtherParam_"^"_DPCSRDelim
	.s ^TMP("DHCST","web.DHCAPPLocLinkClinicSet","QueryReportParam",pid,h)=tempstr
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="Rowid^LocDr^ReportFullFile^RhasReg^RRegParam^RhasStudyNo^RStuyParam^RhasOther^ROtherParam^RDelim"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPLocLinkClinicSet","QueryReportParam",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCAPPLocLinkClinicSet","QueryReportParam",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(title,mdate)
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Description: 查询出影像调用参数
/// Creator:     wangxuejian
/// CreateDate:  2017-02-26  
/// Table: 		 DHCRBC_ClinicSet
/// Output:  	 表的id、科室rowid、影像调用参数路径、是否需要登记号、登记号前参数^是否需要检查号、检查号前参数、是否需要其他参数、其他参数、影像参数分隔符
/// w ##class(web.DHCAPPLocLinkClinicSet).QueryImageParam(1,1,1) 
ClassMethod QueryImageParam(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s end=page*rows
	s start=(page-1)*rows+1
	s locRowid=params
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s h=0,count=0
	s DPCSRowID=0
	f  s DPCSRowID=$o(^DHCRBC("ClinicSet",DPCSRowID)) q:DPCSRowID=""  d  //查询表DHCRBC_ClinicSet
	.s DPCSLocRowid=$p(^DHCRBC("ClinicSet",DPCSRowID),"^",1)
	.q:DPCSLocRowid'=locRowid
	.s DPCSImageFullFile=$p(^DHCRBC("ClinicSet",DPCSRowID),"^",8)
	.s DPCSIhasReg=$p(^DHCRBC("ClinicSet",DPCSRowID),"^",9)
	.s DPCSRhasReg=$s(DPCSRhasReg="Y":"是",DPCSRhasReg="N":"否",1:"")
	.s DPCSIRegParam  =$p(^DHCRBC("ClinicSet",DPCSRowID),"^",10)
	.s DPCSIhasStudyNo=$p(^DHCRBC("ClinicSet",DPCSRowID),"^",11)
	.s DPCSIhasStudyNo=$s(DPCSIhasStudyNo="Y":"是",DPCSIhasStudyNo="N":"否",1:"")
	.s DPCSIStuyNOParam=$p(^DHCRBC("ClinicSet",DPCSRowID),"^",12)
	.s DPCSIhasOther=$p(^DHCRBC("ClinicSet",DPCSRowID),"^",16)
	.s DPCSIhasOther=$s(DPCSIhasOther="Y":"是",DPCSIhasOther="N":"否",1:"")
	.s DPCSIOtherParam=$p(^DHCRBC("ClinicSet",DPCSRowID),"^",17)
	.s DPCSIDelim=$p(^DHCRBC("ClinicSet",DPCSRowID),"^",13)
	.s h=h+1
	.s tempstr=DPCSRowID_"^"_DPCSLocRowid_"^"_DPCSImageFullFile_"^"_DPCSIhasReg_"^"_DPCSIRegParam_"^"_DPCSIhasStudyNo_"^"_DPCSIStuyNOParam_"^"_DPCSIhasOther_"^"_DPCSIOtherParam_"^"_DPCSIDelim
	.s ^TMP("DHCST","web.DHCAPPLocLinkClinicSet","QueryImageParam",pid,h)=tempstr
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="Rowid^LocDr^ImageFullFile^IhasReg^IRegParam^IhasStudyNo^IStudyNOParam^IhasOther^IOtherParam^IDelim"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPLocLinkClinicSet","QueryImageParam",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCAPPLocLinkClinicSet","QueryImageParam",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(title,mdate)
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Description: 查询出影像调用参数
/// Creator:     wangxuejian
/// CreateDate:  2017-02-26  
/// Table: 		 DHCRBC_ClinicSet
/// Output:  	 表的id、科室rowid、影像调用参数路径、是否需要登记号、登记号前参数^是否需要检查号、检查号前参数、是否需要其他参数、其他参数、影像参数分隔符
/// w ##class(web.DHCAPPLocLinkClinicSet).QueryPortSetList(10,1,"R") 
ClassMethod QueryPortSetList(rows As %String, page As %String, Params As %String, HospID As %String) As %String
{
	n (rows,page,Params,HospID)
	s ^tempqujian("QueryPortSetList")=rows_","_page_","_Params_","_HospID
	s End=page*rows
	s Start=(page-1)*rows+1
	s InType=$p(Params,"^",1)   //R：报告，I：图像
	s:InType="" InType="R"      //默认查询R类型的数据
	s InLocID=$p(Params,"^",2)   //
	s Count=0
	S DataTtle = "RBCDr^LocDr^Loc^FullFile^HasRegNo^RegNoParam^HasStudyNo^StudyNoParam^HasOrdItm^OrdItmParam^HasOther^OtherParam^HasRepId^RepIdParam^Delimt^StartDate^EndDate^OpenMethod"	
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	s RBCDr=""
	f  s RBCDr = $o(^DHCRBC("ClinicSet",RBCDr)) q:RBCDr=""  d
	.s LocDr = $p(^DHCRBC("ClinicSet",RBCDr),"^",1)  
	.q:(InLocID'="")&&(InLocID'=LocDr)
	.s Loc=$p($g(^CTLOC(+LocDr)),"^",2)
	.s LocHospitalID=$p($g(^CTLOC(+LocDr)),"^",22)
	.q:HospID'=LocHospitalID  
	.s DataList=""
	.i InType="R" d
	..s FullFile=$p(^DHCRBC("ClinicSet",RBCDr),"^",2)     			//图像路径
	..s HasRegNo=$p(^DHCRBC("ClinicSet",RBCDr),"^",3)      			//登记号
	..;s HasRegNo=$s(HasRegNo="Y":"是",HasRegNo="N":"否",1:"")
	..s RegNoParam  =$p(^DHCRBC("ClinicSet",RBCDr),"^",4) 			//登记号参数
	..s HasStudyNo=$p(^DHCRBC("ClinicSet",RBCDr),"^",5)   			//检查号
	..;s HasStudyNo=$s(HasStudyNo="Y":"是",HasStudyNo="N":"否",1:"")  
	..s StudyNoParam=$p(^DHCRBC("ClinicSet",RBCDr),"^",6)			//检查号参数
	..s HasOrdItm=$P($g(^DHCRBC("ClinicSet",RBCDr)),"^",18)			//医嘱ID
	..s OrdItmParam=$P($g(^DHCRBC("ClinicSet",RBCDr)),"^",19)		//医嘱ID参数
	..s HasOther=$p(^DHCRBC("ClinicSet",RBCDr),"^",14)				//其他参数
	..;s HasOther=$s(HasOther="Y":"是",HasOther="N":"否",1:"")
	..s OtherParam=$p(^DHCRBC("ClinicSet",RBCDr),"^",15)			//其他参数参数
	..s HasRepId=$p(^DHCRBC("ClinicSet",RBCDr),"^",23)				//报告ID
	..s RepIdParam=$p(^DHCRBC("ClinicSet",RBCDr),"^",24)			//报告ID参数
	..s Delimt=$p(^DHCRBC("ClinicSet",RBCDr),"^",7)					//分隔符
	..s StartDate=$p(^DHCRBC("ClinicSet",RBCDr),"^",27)
	..if StartDate'="" s StartDate=..%ZD(StartDate)
	..s EndDate=$p(^DHCRBC("ClinicSet",RBCDr),"^",28)
	..if EndDate'="" s EndDate=..%ZD(EndDate)
	..s OpenMethd=$p(^DHCRBC("ClinicSet",RBCDr),"^",31)
	..s DataList = RBCDr_"^"_LocDr_"^"_Loc_"^"_FullFile_"^"_HasRegNo_"^"_RegNoParam_"^"_HasStudyNo_"^"_StudyNoParam
	..s DataList = DataList_"^"_HasOrdItm_"^"_OrdItmParam_"^"_HasOther_"^"_OtherParam_"^"_HasRepId_"^"_RepIdParam_"^"_Delimt_"^"_StartDate_"^"_EndDate_"^"_OpenMethd
	.
	.i InType="I" d
	..s FullFile=$p(^DHCRBC("ClinicSet",RBCDr),"^",8)     			//图像路径
	..s HasRegNo=$p(^DHCRBC("ClinicSet",RBCDr),"^",9)      			//登记号
	..;s HasRegNo=$s(HasRegNo="Y":"是",HasRegNo="N":"否",1:"")
	..s RegNoParam  =$p(^DHCRBC("ClinicSet",RBCDr),"^",10) 			//登记号参数
	..s HasStudyNo=$p(^DHCRBC("ClinicSet",RBCDr),"^",11)   			//检查号
	..;s HasStudyNo=$s(HasStudyNo="Y":"是",HasStudyNo="N":"否",1:"")  
	..s StudyNoParam=$p(^DHCRBC("ClinicSet",RBCDr),"^",12)			//检查号参数
	..s HasOrdItm=$P($g(^DHCRBC("ClinicSet",RBCDr)),"^",20)			//医嘱ID
	..s OrdItmParam=$P($g(^DHCRBC("ClinicSet",RBCDr)),"^",21)		//医嘱ID参数
	..s HasOther=$p(^DHCRBC("ClinicSet",RBCDr),"^",16)				//其他参数
	..;s HasOther=$s(HasOther="Y":"是",HasOther="N":"否",1:"")
	..s OtherParam=$p(^DHCRBC("ClinicSet",RBCDr),"^",17)			//其他参数参数
	..s HasRepId=$p(^DHCRBC("ClinicSet",RBCDr),"^",25)				//报告ID
	..s RepIdParam=$p(^DHCRBC("ClinicSet",RBCDr),"^",26)			//报告ID参数
	..s Delimt=$p(^DHCRBC("ClinicSet",RBCDr),"^",13)					//分隔符
	..s StartDate=$p(^DHCRBC("ClinicSet",RBCDr),"^",29)
	..if StartDate'="" s StartDate=..%ZD(StartDate)
	..s EndDate=$p(^DHCRBC("ClinicSet",RBCDr),"^",30)
	..if EndDate'="" s EndDate=..%ZD(EndDate)
	..s OpenMethd=$p(^DHCRBC("ClinicSet",RBCDr),"^",32)
	..s DataList = RBCDr_"^"_LocDr_"^"_Loc_"^"_FullFile_"^"_HasRegNo_"^"_RegNoParam_"^"_HasStudyNo_"^"_StudyNoParam
	..s DataList = DataList_"^"_HasOrdItm_"^"_OrdItmParam_"^"_HasOther_"^"_OtherParam_"^"_HasRepId_"^"_RepIdParam_"^"_Delimt_"^"_StartDate_"^"_EndDate_"^"_OpenMethd
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.W $case(Count,Start:"",:",") 
	.W ##class(web.DHCAPPJsonCommon).getJsonData(DataTtle,DataList)
	W ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)
	q ""
}

/// Description: 删除 执行报告参数和影像参数信息
/// Creator:     Wangxuejian
/// CreateDate:  2016-02-27
/// Table:		 DHCRBC_ClinicSet
/// Input:  	 表的Rowid
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCAPPLocLinkClinicSet).DelReportImage("3")
ClassMethod DelReportImage(params As %String) As %String
{
	N (params)
	&SQL(Delete From DHCRBC_ClinicSet Where DPCS_RowID=:params)
	Q SQLCODE
}

/// Creator : QQ
/// Descript: 检验获取reportID(方法即界面配置是否需要报告ID获取报告ID的方法)
/// w ##class(web.DHCAPPLocLinkClinicSet).GetLisReportID(50090336,179)
ClassMethod GetLisReportID(Ord, Itm)
{
	n (Ord,Itm)
	q ##class(web.DHCEMInComUseMethod).GetLisReportID(Ord,Itm)
}

/// Creator : QQ
/// Descript: 检验获取reportID(方法即界面配置是否需要报告ID获取报告ID的方法)
/// w ##class(web.DHCAPPLocLinkClinicSet).GetLisReportID(50090336,179)
ClassMethod GetLisReportIDs(OrdItms)
{
	n (OrdItms)
	q ##class(web.DHCEMInComUseMethod).GetLisReportIDs(OrdItms)
}

/// d ##class(web.DHCAPPLocLinkClinicSet).JsonLocList("",2)
ClassMethod JsonLocList(q, HospID)
{
	n (q,HospID)
	s Count=0
	w "["
	s LocID=0
	f  s LocID=$o(^CTLOC(LocID)) q:LocID=""  d
	.s LocCode = $P(^CTLOC(LocID),"^",1)
	.s LocDesc = $P(^CTLOC(LocID),"^",2)
	.s CTLOCHosDR=$P(^CTLOC(LocID),"^",22)
	.s LocHospitalID=$p($g(^CTLOC(LocID)),"^",22)
	.q:HospID'=LocHospitalID
	.s LocAllDesc = LocCode_LocDesc
	.s Tmp=LocID_"^"_LocDesc
	.q:(q'="")&(LocAllDesc'[q)
	.s LocDateTo=$p($g(^CTLOC(LocID)),"^",25)
	.q:(LocDateTo'="")&&(LocDateTo<+$H)
	.s Count=Count+1
	.w $case(Count,1:"",:",") 
	.w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	w "]"
	q ""
}

}
