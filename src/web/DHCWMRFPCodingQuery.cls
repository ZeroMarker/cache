Import SQLUser

Class web.DHCWMRFPCodingQuery Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 219;

/*********************************************************************************
//by liyang 2008-6-4
//本查询的运行原理:
//1、构建一个疾病/手术查询的SQL语句
//2、执行SQL语句，筛选出VolumeID
//3、取得Volume的就诊信息以及基本信息
//4、根据各个表达式进行匹配
//5、生成结果集
//
//构建查询疾病/手术的SQL
//**目标是构建一个这种结构类型的SQL语句：
//   SELECT Rowid FROM DHC_WMR_MainVolume WHERE (rowid in <子查询1>) AND (rowid in <子查询2>) AND (rowid in <子查询X>))
//
//**子查询的构成：
//   SELECT DHC_WMR_FrontPage.volumedr from DHC_WMR_FrontPage,DHC_WMR_FPICD,<疾病/手术字典表>
//   WHERE (DHC_WMR_FrontPage.rowid =  DHC_WMR_FPICD.FrontPageDr AND <疾病/手术字典表>.<疾病/手术字典表的RowID列名>=DHC_WMR_FPICD.ICDdr) AND <用户自定义条件>
//
//**用户自定义条件构成：
//   (<字段名><比较运算符><匹配值>)<逻辑运算符>(<字段名><比较运算符><匹配值>)
//
//****通过GetFilterSqlMain函数，可以生成条件表达式，然后与主查询合并，形成最后形成的SQL查询语句
//****GetFilterSqlMain函数会检查ICD的设置，是使用HIS的ICD字典还是病案系统的ICD字典。
//****CheckInfo函数用来进行对病人的基本信息、就诊信息进行检察，如果符合查询条件，返回1，否则返回0，出错返回-1
**********************************************************************************/
ClassMethod BuildExpress(varName, str)
{
	quit:str="" ""
	set str=varName_"="_str
	set @str
	q ""
}

ClassMethod GetFilterSqlMain(Type)
{
          
		
	set strWMRICDDisDIC="DHC_WMR_ICDDx"
	set strWMRICDOpeDIC="DHC_WMR_ICDDx"
	set strWMRICDDisDICRowidColName="rowid"
	set strWMRICDOpeDICRowidColName="rowid"
	
	set strHISICDDisDIC="MRC_ICDDx"
	set strHISICDOpeDIC="ORC_Operation"
	set strHISICDDisDICRowidColName="MRCID_RowId"
	set strHISICDOpeDICRowidColName="OPER_RowId"
		
	set strTmp=""
	if (Type = "D")
	{
		if (DisConfig = 0)
		{
			set strTmp= "select DHC_WMR_FrontPage.volumedr from DHC_WMR_FrontPage,DHC_WMR_FPICD,"_strWMRICDDisDIC
			set strTmp=strTmp_" WHERE (DHC_WMR_FrontPage.rowid =  DHC_WMR_FPICD.FrontPageDr AND "_strWMRICDDisDIC_"."_strWMRICDDisDICRowidColName_"=DHC_WMR_FPICD.ICDdr) AND " 
		}else
		{
			set strTmp= "select DHC_WMR_FrontPage.volumedr from DHC_WMR_FrontPage,DHC_WMR_FPICD,"_strHISICDDisDIC
			set strTmp=strTmp_" WHERE (DHC_WMR_FrontPage.rowid =  DHC_WMR_FPICD.FrontPageDr AND "_strHISICDDisDIC_"."_strHISICDDisDICRowidColName_"=DHC_WMR_FPICD.ICDdr) AND " 
		}		
	}
	else
	{
		if (OpeConfig = 0)
		{
			set strTmp= "select DHC_WMR_FrontPage.volumedr from DHC_WMR_FrontPage,DHC_WMR_FPICD,"_strWMRICDOpeDIC
			set strTmp=strTmp_" WHERE (DHC_WMR_FrontPage.rowid =  DHC_WMR_FPICD.FrontPageDr AND "_strWMRICDOpeDIC_"."_strWMRICDOpeDICRowidColName_"=DHC_WMR_FPICD.ICDdr) AND " 
		}else
		{
			set strTmp= "select DHC_WMR_FrontPage.volumedr from DHC_WMR_FrontPage,DHC_WMR_FPICD,"_strHISICDOpeDIC
			set strTmp=strTmp_" WHERE (DHC_WMR_FrontPage.rowid =  DHC_WMR_FPICD.FrontPageDr AND "_strHISICDOpeDIC_"."_strHISICDOpeDICRowidColName_"=DHC_WMR_FPICD.ICDdr) AND " 		
		}
	}

	quit strTmp
}

ClassMethod FPQueryExecute(ByRef qHandle As %Binary, ICDCondition As %String, ExtraCondition As %String, mainCon As %String, baseCon As %String, volCon As %String, admCon As %String, fpCon As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(ICDCondition="")&(ExtraCondition="") $$$OK
	quit:(ICDCondition="")&(ExtraCondition="")&(mainCon="")&(baseCon="")&(volCon="")&(admCon="")&(fpCon="") $$$OK
	
	if ICDCondition'=""  d
	.set ICDCondition="ICDCondition="_ICDCondition
	.s @ICDCondition
	
	if ExtraCondition'=""  d
	.set ExtraCondition="ExtraCondition="_ExtraCondition
	.s @ExtraCondition
	
	if mainCon'=""  d
	.set mainCon="mainCon="_mainCon
	.s @mainCon
	
	if baseCon'=""  d
	.set baseCon="baseCon="_baseCon
	.s @baseCon

	if volCon'=""  d
	.set volCon="volCon="_volCon
	.s @volCon
	
	if admCon'=""  d
	.set admCon="admCon="_admCon
	.s @admCon

	if fpCon'=""  d
	.set admCon="fpCon="_fpCon
	.s @fpCon
	
	//********************设置**************************
	set DisConfig = ##class(web.DHCWMRMedBaseICD).GetDHCWMRICDSettingD()
	set OpeConfig = ##class(web.DHCWMRMedBaseICD).GetDHCWMRICDSettingO()
	//**************************************************
	
	set strSqlMain = "SELECT Rowid FROM DHC_WMR_MainVolume WHERE (1=1) "
	set strExtraFilterMain="select DHC_WMR_FrontPage.volumedr from DHC_WMR_FrontPage inner join DHC_WMR_FPExtra on DHC_WMR_FrontPage.rowid =  DHC_WMR_FPExtra.FrontPageDr WHERE (1=1) AND " 
	set strBuffer = strSqlMain
	set strSql = ""
	set intCounter = 0
	set $ZT="ErrorHandler"
	if (ICDCondition '= "")
	{
		for intCounter=1:1:$l(ICDCondition,$c(1))
		{
			set strArg = $p(ICDCondition,$c(1),intCounter)
			set strSql = $p(strArg,$c(2),2)
			set strType = $p(strArg,$c(2),3)
			if (strSql'="")
			{
				set strDisOpeFilterMain=..GetFilterSqlMain(strType)
				if ($p(strArg,$c(2),1)'="NOT")
				{
					set strBuffer=strBuffer_" AND (Rowid in ("_strDisOpeFilterMain_"("_strSql_")))"     //update by zf 2008-06-17 添加了一个括号
				}
				else
				{
					set strBuffer=strBuffer_" AND (Rowid NOT in ("_strDisOpeFilterMain_"("_strSql_")))"
				}
			}
		}
	}
	if (ExtraCondition '= "")
	{
		for intCounter=1:1:$l(ExtraCondition,$c(1))
		{
			set strArg = $p(ExtraCondition,$c(1),intCounter)
			set strSql = $p(strArg,$c(2),2)
			if (strSql'="")
			{
				for i=1:1:$l(strSql,"<")-1
				{
					s strSql=$p(strSql,"<",1)_" DHC_WMR_FPExtra.ItemId= "_$e(strSql,$l($p(strSql,"<",1))+2,$l(strSql))
				}
				for i=1:1:$l(strSql,">")-1
				{
					s strSql=$p(strSql,">",1)_" AND DHC_WMR_FPExtra.ItemValue "_$e(strSql,$l($p(strSql,">",1))+2,$l(strSql))
				}
				
				if ($p(strArg,$c(2),1)'="NOT")
				{
					set strBuffer=strBuffer_" AND (Rowid in ("_strExtraFilterMain_"("_strSql_")))"
				}
				else
				{
					set strBuffer=strBuffer_" AND (Rowid NOT in ("_strExtraFilterMain_"("_strSql_")))"
				}
			}
		}		
	}
	set strSql = strBuffer
	
	//k ^CacheTemp1($ZN)
	//set ^CacheTemp1($ZN,"InCond1")=$lb(ICDCondition,ExtraCondition,mainCon,baseCon,volCon,admCon,fpCon)
	
	set objRS = ##class(%ResultSet).%New()
	do objRS.Prepare(strSql)
	do objRS.Execute()
	set cs = 0
	set myNum=0
	s ind=0
	while (objRS.Next(cs)) // go to the next row of the result set
 	{
	 	set VolRowId=objRS.Data("Rowid")
	 	s ind=ind+1
	 	//set ^CacheTemp1($ZN,"CheckInfo",ind)=$lb(VolRowId, mainCon, baseCon, volCon, admCon, fpCon)
	 	set returnCode=..CheckInfo(VolRowId, mainCon, baseCon, volCon, admCon, fpCon)  //进行其他测试
	 	
	 	if (returnCode=1)
	 	{	 	
 			s myData=..buildData(VolRowId)
 			s ^CacheTemp(repid,ind)=myData
 			s ind=ind+1
	 	}
 	}
 	do objRS.Close()
 	k objRS
	Quit $$$OK

	//Type:O：手术  D：疾病

ErrorHandler
	set ^CacheTemp1($ZN,"QueryErr")=$ZERROR
	Quit $$$OK
}

ClassMethod FPQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FPQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

Query FPQuery(ICDCondition As %String, ExtraCondition As %String, mainCon As %String, baseCon As %String, volCon As %String, admCon As %String, fpCon As %String) As %Query(ROWSPEC = "MrType:%String,MainID:%String,VolID:%String,MrTypeDesc:%String,MrNo:%String,PatientName:%String,Sex:%String,Age:%String,AdmitDate:%String,AdmitDepartment:%String,DischargeDate:%String,DischargeDepartment:%String")
{
}

ClassMethod FPQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FPQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CheckInfo(VolumeID, mainCon, baseCon, volCon, admCon, fpCon)
{
	set $ZT="Error"
	n (VolumeID, mainCon, baseCon, volCon, admCon, fpCon)
	s fpInfo=##class(web.DHCWMRFrontPageCtl).GetFrontPageByVolumeID(VolumeID)
	s volume=##class(web.DHCWMRVolumeCtl).GetVolume(VolumeID)
	s main=##class(web.DHCWMRMainCtl).GetMainById($p(volume,"^",2))
	s adm=##class(web.DHCWMRBaseInfoCtl).GetAdmInfoByVol(VolumeID)
	s baseInfo=##class(web.DHCWMRVolumeCtl).GetVolInfoByVol(VolumeID)
	
	s resBase=0, resVol=0, resMain=0, resAdm=0, resFp=0
	s errCode=0
	//表达式不能为空，所以如果为空则赋予一个True的值
	s mainCon="(1=1)"_mainCon
	s baseCon="(1=1)"_baseCon
	s volCon="(1=1)"_volCon
	s admCon="(1=1)"_admCon
	s fpCon="(1=1)"_fpCon
	
	s mainCon="resMain="_mainCon
	s baseCon="resBase="_baseCon
	s volCon="resVol="_volCon
	s admCon="resAdm="_admCon
	s fpCon="resFp="_fpCon
	
	set @mainCon
	set @baseCon
	set @volCon
	set @admCon
	set @fpCon
	
	q resBase&resVol&resMain&resAdm&resFp
	
Error
    set ^CacheTemp1($ZN,"CheckInfoErr")=$ZERROR
	q -1
}

ClassMethod buildData(VolumeID)
{
	n (VolumeID)
	set data=$lb("")
 	set volume=##class(web.DHCWMRVolumeCtl).GetVolume(VolumeID)
	set main=##class(web.DHCWMRMainCtl).GetMainById($p(volume,"^",2))
	set adm=##class(web.DHCWMRBaseInfoCtl).GetAdmInfoByVol(VolumeID)
	set baseInfo=##class(web.DHCWMRVolumeCtl).GetVolInfoByVol(VolumeID)
	set mrTypeDic=##class(web.DHCWMRDictionaryCtl).GetDataById($p(main,"^",2))
	
	//by wuqk
 	set $li(data,1)=$p(main,"^",2) //MrType
 	set $li(data,2)=$p(main,"^",1) //MrMainID
 	set $li(data,3)=$p(volume,"^",1) //volumeID
 	set $li(data,4)=$p(mrTypeDic,"^",4) //MrTypeDesc
 	set $li(data,5)=$p(main,"^",3) //MrNo
 	set $li(data,6)=$p(baseInfo,"^",2) //PatientName
 	set $li(data,7)=$p(baseInfo,"^",4) //sex
 	set $li(data,8)=$p(baseInfo,"^",6) //age
 	set $li(data,9)=$p(adm,"^",3) //admit date
 	set $li(data,10)=$p(adm,"^",5) //admit dep
 	set $li(data,11)=$p(adm,"^",7) //discharge date
 	set $li(data,12)=$p(adm,"^",9) //discharge dep	
 	//Set ^CacheTemp(repid,ind)=data     //by wuqk 
 	Q data
}

}
