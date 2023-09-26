/// 手术名称业务类
Class CIS.AN.BL.Operation Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2017-03-13
/// Description： 	查询手术名称字典
/// Table：        	DHCAN.Operation
/// Input:			filterDesc:手术名称筛选字符串,surgeonId:手术医生医护人员ID,surDeptId:手术医生科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Operation","FindOperation","","","191","",285)
Query FindOperation(filterDesc As %String, surgeonId As %String, surDeptId As %String, operId As %String = "", EpisodeID As %String = "", HospDr As %String = "") As %Query(ROWSPEC = "RowId,Description,OperClass,OperClassDesc,BladeType,BladeTypeDesc,BodySite,BodySiteDesc,OperPos,OperPosDesc,ICDCode,ICDDesc,ExternalID,StandardCode,StandardDesc") [ SqlProc ]
{
}

ClassMethod FindOperationExecute(ByRef qHandle As %Binary, filterDesc As %String, surgeonId As %String, surDeptId As %String, operId As %String = "", EpisodeID As %String = "", HospDr As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	s operationId="",operDesc="",operClass="",operClassDesc=""="",bladeType="",bladeTypeDesc=""
	s bodySite="",bodySiteDesc="",operPos="",operPosDesc="",ICDCode="",ICDDesc="",externalID=""
	if (##class(User.ORCOperation).%ExistsId(operId))
	{
		set operationId=operId,operDesc="",operClass="",operClassDesc="",bladeType="",bladeTypeDesc="",bodySite="",bodySiteDesc="",operPos="",operPosDesc="",ICDCode="",ICDDesc="",externalID=""
		&sql(select OPER_Desc,OPER_ICD10,OPER_Desc into :operDesc,:ICDCode,:ICDDesc from SQLUser.ORC_Operation where %ID=:operId)
		&sql(select OPER_Class_Dr,OPER_Class_Dr->CATEG_Desc,OPER_Blade_Dr,OPER_Blade_Dr->BLDTP_Desc,OPER_BodySite_Dr,OPER_BodySite_Dr->BODS_Desc,OPER_OperPosition_Dr,OPER_OperPosition_Dr->OPPOS_Desc into 
		:operClass,:operClassDesc,:bladeType,:bladeTypeDesc,:bodySite,:bodySiteDesc,:operPos,:operPosDesc from SQLUser.ORC_OperationExtend where %ID=:operId)
		do OutputRow1(operationId)
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	if (filterDesc="")&(surgeonId="")&(surDeptId="")
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	set filterDesc=$System.SQL.ALPHAUP(filterDesc)
	set careProv="",careProvTpId="",aliasSplitChar=";"
	// 获取手术资质管理配置
	set OperQualificationManager=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("OperQualificationManager")
	if (surgeonId="")&(surDeptId'="")
	{
		if (filterDesc="")
	    {
		    s qHandle=$lb(0,repid,0)
		    q $$$OK	
	    }
		//set operationByDeptObj=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.ConfigQueries:FindDeptOperations",surDeptId)
		set operationByDeptObj=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.CodeQueries:FindOperation",filterDesc,"","Y")
		for i=1:1:operationByDeptObj.Size
		{
			/*
			set operationByDept=operationByDeptObj.GetAt(i)
			set operationId=operationByDept.GetValue("Operation")
			set operDesc=operationByDept.GetValue("OperationDesc")
			set operAlis=##class(web.DHCClinicCom).GetChinaChar(operDesc)
			set operClass=operationByDept.GetValue("OperClass")
			set operClassDesc=operationByDept.GetValue("OperClassDesc")
			set ActiveDate=operationByDept.GetValue("ActiveDate")
			set ExpireDate=operationByDept.GetValue("ExpireDate")
			continue:(filterDesc'="")&($System.SQL.ALPHAUP(operDesc)'[filterDesc)&($System.SQL.ALPHAUP(operAlis)'[filterDesc)
			continue:(ActiveDate>+$h)
			continue:(ExpireDate'="")&(ExpireDate<+$h)
			*/
			//20220124 8.5版本不再设置科室关联手术限制
			set operationByDept=operationByDeptObj.GetAt(i)
			set operationId=operationByDept.GetValue("RowId")
			set operDesc=operationByDept.GetValue("Description")
			set operAlis=##class(web.DHCClinicCom).GetChinaChar(operDesc)
			set operClass=operationByDept.GetValue("OperClass")
			set operClassDesc=operationByDept.GetValue("OperClassDesc")
			continue:(filterDesc'="")&($System.SQL.ALPHAUP(operDesc)'[filterDesc)&($System.SQL.ALPHAUP(operAlis)'[filterDesc)
			do OutputRow(operationId)
		}
	}
	if (surgeonId'="")&(surDeptId'="")
	{
		set surDeptId=""  //20220124 8.5版本不再设置科室关联手术限制
		set operationBySurgeonObj=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperQualificationManager:FindSurgeonOperations",surgeonId,surDeptId)
		for i=1:1:operationBySurgeonObj.Size
		{
			set operationBySurgeon=operationBySurgeonObj.GetAt(i)
			set operationId=operationBySurgeon.GetValue("Operation")
			set operDesc=operationBySurgeon.GetValue("OperationDesc")
			set operAlis=##class(web.DHCClinicCom).GetChinaChar(operDesc)
			set operClass=operationBySurgeon.GetValue("OperClass")
			set operClassDesc=operationBySurgeon.GetValue("OperClassDesc")
			continue:(filterDesc'="")&($System.SQL.ALPHAUP(operDesc)'[filterDesc)&($System.SQL.ALPHAUP(operAlis)'[filterDesc)
			do OutputRow(operationId)
		}
		if (operationBySurgeonObj.Size=0)  //如果没有任何关联则显示全部手术
		{
			if (filterDesc="")
	    	{
		    	s qHandle=$lb(0,repid,0)
		    	q $$$OK	
	    	}
			set operationByDeptObj=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.CodeQueries:FindOperation",filterDesc,"","Y")
			for i=1:1:operationByDeptObj.Size
			{
				set operationByDept=operationByDeptObj.GetAt(i)
				set operationId=operationByDept.GetValue("RowId")
				set operDesc=operationByDept.GetValue("Description")
				set operAlis=##class(web.DHCClinicCom).GetChinaChar(operDesc)
				set operClass=operationByDept.GetValue("OperClass")
				set operClassDesc=operationByDept.GetValue("OperClassDesc")
				continue:(filterDesc'="")&($System.SQL.ALPHAUP(operDesc)'[filterDesc)&($System.SQL.ALPHAUP(operAlis)'[filterDesc)
				do OutputRow(operationId)
			}
		}
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow(operationId)
    if (##class(User.ORCOperation).%ExistsId(operationId))
    {
    	set operationInfo=##class(User.ORCOperation).%OpenId(operationId)
    	set ICDCode=operationInfo.OPERICD10
    	set ICDDesc=operDesc
    	set:(ICDCode'="") ICDDesc="["_ICDCode_"]"_ICDDesc
    	set externalID=""
    	set operExtend=##class(User.ORCOperationExtend).%OpenId(operationId)
    	if (operExtend'="")
    	{
	    	if (operExtend.OPERBodySiteDr'="")
	    	{
		    	set bodySite=operExtend.OPERBodySiteDr.%Id()
		    	set bodySiteDesc=$p($g(^OEC("BODS",+bodySite)),"^",2)
			}
			if (operExtend.OPERBladeDr'="")
			{
				set bladeType=operExtend.OPERBladeDr.%Id()
				set bladeTypeDesc=$p($g(^ORC("BLDTP",+bladeType)),"^",2)
			}
			if (operExtend.OPEROperPositionDr'="")
			{
				set operPos=operExtend.OPEROperPositionDr.%Id()
				set operPosDesc=$p($g(^ORC("OPPOS",+operPos)),"^",2)
			}
		}
    }
	//新增国家医保编码及名称
	s StandardCode="",StandardDesc="",StdInfo=""
	i HospDr="" s HospDr=2
	if (EpisodeID'=""){
		s AdmResonDr=$p($g(^PAAdm(EpisodeID,1)),"^",7)
		s ActDate=$zd(+$h,3)
		try{
			i operationId'="" s StdInfo=##class(web.DHCINSUPort).GetStdInfoByORCOperRowId(operationId,HospDr,AdmResonDr,ActDate,1)
		}catch(e){
		}
		s:StdInfo'="" StandardCode=$p(StdInfo,"^",1)
		s:StdInfo'="" StandardDesc=$p(StdInfo,"^",2)
	}
	s ^CacheTemp(repid,ind)=$lb(operationId,operDesc,operClass,operClassDesc,bladeType,bladeTypeDesc,bodySite,bodySiteDesc,operPos,operPosDesc,ICDCode,ICDDesc,externalID,StandardCode,StandardDesc)
	s ind=ind+1
	q
OutputRow1(operationId)
    //新增国家医保编码及名称
	s StandardCode="",StandardDesc=""
	i HospDr="" s HospDr=2
	s AdmResonDr=$p($g(^PAAdm(EpisodeID,1)),"^",7)
	s ActDate=$zd(+$h,3)
	//s StdInfo=##class(web.DHCINSUPort).GetStdInfoByORCOperRowId(operationId,HospDr,AdmResonDr,ActDate,1)
	try{
		s StdInfo=##class(web.DHCINSUPort).GetStdInfoByORCOperRowId(operationId,HospDr,AdmResonDr,ActDate,1)
	}catch(e){
	}
	s:StdInfo'="" StandardCode=$p(StdInfo,"^",1)
	s:StdInfo'="" StandardDesc=$p(StdInfo,"^",2)
	s ^CacheTemp(repid,ind)=$lb(operationId,operDesc,operClass,operClassDesc,bladeType,bladeTypeDesc,bodySite,bodySiteDesc,operPos,operPosDesc,ICDCode,ICDDesc,externalID,StandardCode,StandardDesc)
	s ind=ind+1
	q
}

ClassMethod FindOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperationExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperationExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator:		杨勤
/// CreatDate:		2017-07-21
/// Description: 	根据医护人员类型和手术分类获取关联ID
/// Table: 			DHCAN.CPTypeOperClass
/// Input:			careProvTpId：医护人员类型ID,operClass:手术分类ID
/// Return: 		DHCAN.CPTypeOperClass的RowId,-1:参数错误，-2：不存在关联
/// Debug:			w ##class(CIS.AN.BL.Operation).GetCPTypeOperClass(4,8)
ClassMethod GetCPTypeOperClass(careProvTpId, operClass) As %String [ SqlProc ]
{
	quit:(careProvTpId="")!(operClass="") "-1"
	&sql(SELECT %ID into :RowId FROM CF_AN.CPTypeOperClass WHERE CPTypeID=:careProvTpId AND OperClass=:operClass)
	if SQLCODE quit "-2"
	quit RowId
}

/// Creator：      	陈长青
/// CreatDate：    	2017-03-13
/// Description： 	查询手术名称字典
/// Table：        	DHCAN.Operation
/// Input:			filterDesc:手术名称筛选字符串,surgeonId:手术医生医护人员ID,surDeptId:手术医生科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Operation","FindOperationColumns","","","191","",285)
Query FindOperationColumns(filterDesc As %String, surgeonId As %String, surDeptId As %String, operId As %String = "", EpisodeID As %String = "", HospDr As %String = "") As %Query(ROWSPEC = "Description:%String:名称,OperClassDesc:%String:分级,ICDCode:%String:ICD编码,StandardCode:%String:医保编码,StandardDesc:%String:医保名称") [ SqlProc ]
{
}

ClassMethod FindOperationColumnsExecute(ByRef qHandle As %Binary, filterDesc As %String, surgeonId As %String, surDeptId As %String, operId As %String = "", EpisodeID As %String = "", HospDr As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	s operationId="",operDesc="",operClass="",operClassDesc=""="",bladeType="",bladeTypeDesc=""
	s bodySite="",bodySiteDesc="",operPos="",operPosDesc="",ICDCode="",ICDDesc="",externalID=""
	if (##class(User.ORCOperation).%ExistsId(operId))
	{
		set operationId=operId,operDesc="",operClass="",operClassDesc="",bladeType="",bladeTypeDesc="",bodySite="",bodySiteDesc="",operPos="",operPosDesc="",ICDCode="",ICDDesc="",externalID=""
		&sql(select OPER_Desc,OPER_ICD10,OPER_Desc into :operDesc,:ICDCode,:ICDDesc from SQLUser.ORC_Operation where %ID=:operId)
		&sql(select OPER_Class_Dr,OPER_Class_Dr->CATEG_Desc,OPER_Blade_Dr,OPER_Blade_Dr->BLDTP_Desc,OPER_BodySite_Dr,OPER_BodySite_Dr->BODS_Desc,OPER_OperPosition_Dr,OPER_OperPosition_Dr->OPPOS_Desc into 
		:operClass,:operClassDesc,:bladeType,:bladeTypeDesc,:bodySite,:bodySiteDesc,:operPos,:operPosDesc from SQLUser.ORC_OperationExtend where %ID=:operId)
		do OutputRow1(operationId)
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	if (filterDesc="")&(surgeonId="")&(surDeptId="")
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	set filterDesc=$System.SQL.ALPHAUP(filterDesc)
	set careProv="",careProvTpId="",aliasSplitChar=";"
	// 获取手术资质管理配置
	set OperQualificationManager=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("OperQualificationManager")
	if (surgeonId="")&(surDeptId'="")
	{
		if (filterDesc="")
	    {
		    s qHandle=$lb(0,repid,0)
		    q $$$OK	
	    }
		set operationByDeptObj=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.CodeQueries:FindOperation",filterDesc,"","Y")
		for i=1:1:operationByDeptObj.Size
		{
			//20220124 8.5版本不再设置科室关联手术限制
			set operationByDept=operationByDeptObj.GetAt(i)
			set operationId=operationByDept.GetValue("RowId")
			set operDesc=operationByDept.GetValue("Description")
			set operAlis=##class(web.DHCClinicCom).GetChinaChar(operDesc)
			set operClass=operationByDept.GetValue("OperClass")
			set operClassDesc=operationByDept.GetValue("OperClassDesc")
			continue:(filterDesc'="")&($System.SQL.ALPHAUP(operDesc)'[filterDesc)&($System.SQL.ALPHAUP(operAlis)'[filterDesc)
			do OutputRow(operationId)
		}
	}
	if (surgeonId'="")&(surDeptId'="")
	{
		set surDeptId=""  //20220124 8.5版本不再设置科室关联手术限制
		set operationBySurgeonObj=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperQualificationManager:FindSurgeonOperations",surgeonId,surDeptId)
		for i=1:1:operationBySurgeonObj.Size
		{
			set operationBySurgeon=operationBySurgeonObj.GetAt(i)
			set operationId=operationBySurgeon.GetValue("Operation")
			set operDesc=operationBySurgeon.GetValue("OperationDesc")
			set operAlis=##class(web.DHCClinicCom).GetChinaChar(operDesc)
			set operClass=operationBySurgeon.GetValue("OperClass")
			set operClassDesc=operationBySurgeon.GetValue("OperClassDesc")
			continue:(filterDesc'="")&($System.SQL.ALPHAUP(operDesc)'[filterDesc)&($System.SQL.ALPHAUP(operAlis)'[filterDesc)
			do OutputRow(operationId)
		}
		if (operationBySurgeonObj.Size=0)  //如果没有任何关联则显示全部手术
		{
			if (filterDesc="")
	    	{
		    	s qHandle=$lb(0,repid,0)
		    	q $$$OK	
	    	}
			set operationByDeptObj=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.CodeQueries:FindOperation",filterDesc,"","Y")
			for i=1:1:operationByDeptObj.Size
			{
				set operationByDept=operationByDeptObj.GetAt(i)
				set operationId=operationByDept.GetValue("RowId")
				set operDesc=operationByDept.GetValue("Description")
				set operAlis=##class(web.DHCClinicCom).GetChinaChar(operDesc)
				set operClass=operationByDept.GetValue("OperClass")
				set operClassDesc=operationByDept.GetValue("OperClassDesc")
				continue:(filterDesc'="")&($System.SQL.ALPHAUP(operDesc)'[filterDesc)&($System.SQL.ALPHAUP(operAlis)'[filterDesc)
				do OutputRow(operationId)
			}
		}
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow(operationId)
    set operationInfo=##class(User.ORCOperation).%OpenId(operationId)
    set ICDCode=operationInfo.OPERICD10
    set ICDDesc=operDesc
    set:(ICDCode'="") ICDDesc="["_ICDCode_"]"_ICDDesc
    set externalID=""
    set operExtend=##class(User.ORCOperationExtend).%OpenId(operationId)
    if (operExtend'="")
    {
	    if (operExtend.OPERBodySiteDr'="")
	    {
		    set bodySite=operExtend.OPERBodySiteDr.%Id()
		    set bodySiteDesc=$p($g(^OEC("BODS",+bodySite)),"^",2)
		}
		if (operExtend.OPERBladeDr'="")
		{
			set bladeType=operExtend.OPERBladeDr.%Id()
			set bladeTypeDesc=$p($g(^ORC("BLDTP",+bladeType)),"^",2)
		}
		if (operExtend.OPEROperPositionDr'="")
		{
			set operPos=operExtend.OPEROperPositionDr.%Id()
			set operPosDesc=$p($g(^ORC("OPPOS",+operPos)),"^",2)
		}
	}
	//新增国家医保编码及名称
	s StandardCode="",StandardDesc="",StdInfo=""
	i HospDr="" s HospDr=2
	s AdmResonDr=$p($g(^PAAdm(EpisodeID,1)),"^",7)
	s ActDate=$zd(+$h,3)
	//i operationId'="" s StdInfo=##class(web.DHCINSUPort).GetStdInfoByORCOperRowId(operationId,HospDr,AdmResonDr,ActDate,1)
	try{
		i operationId'="" s StdInfo=##class(web.DHCINSUPort).GetStdInfoByORCOperRowId(operationId,HospDr,AdmResonDr,ActDate,1)
	}catch(e){
	}
	s:StdInfo'="" StandardCode=$p(StdInfo,"^",1)
	s:StdInfo'="" StandardDesc=$p(StdInfo,"^",2)
	s ^CacheTemp(repid,ind)=$lb(operationId,operDesc,operClassDesc,ICDCode,StandardCode,StandardDesc)
	s ind=ind+1
	q
OutputRow1(operationId)
    //新增国家医保编码及名称
	s StandardCode="",StandardDesc=""
	i HospDr="" s HospDr=2
	s AdmResonDr=$p($g(^PAAdm(EpisodeID,1)),"^",7)
	s ActDate=$zd(+$h,3)
	//s StdInfo=##class(web.DHCINSUPort).GetStdInfoByORCOperRowId(operationId,HospDr,AdmResonDr,ActDate,1)
	try{
		s StdInfo=##class(web.DHCINSUPort).GetStdInfoByORCOperRowId(operationId,HospDr,AdmResonDr,ActDate,1)
	}catch(e){
	}
	s:StdInfo'="" StandardCode=$p(StdInfo,"^",1)
	s:StdInfo'="" StandardDesc=$p(StdInfo,"^",2)
	s ^CacheTemp(repid,ind)=$lb(operDesc,operClassDesc,ICDCode,StandardCode,StandardDesc)
	s ind=ind+1
	q
}

ClassMethod FindOperationColumnsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperationColumnsExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindOperationColumnsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperationColumnsExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

}
