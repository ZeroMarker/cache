Import SQLUser

Class web.DHCRisImportData Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCRisImportData).ImportItemCatInfo("")
/// 导入检查医嘱项分组信息
/// 入参: 医嘱项code^医嘱项名称^检查组名称^检查组code
/// 返回值：200 检查组code/desc为空
///         210 检查组rowid没取到
///         220 医嘱项未找到
ClassMethod ImportItemCatInfo(Info As %String) As %String
{
	s ^TempDHCRisWf("ImportItemCatInfo")=Info
	
	s ArcItmCode=$p($g(Info),"^",1)
	s ItemCatDesc=$p($g(Info),"^",3)
	s ItemCatCode=$zcvt($p($g(Info),"^",4),"U")
    
    q:((ItemCatCode="")||(ItemCatDesc="")) "200"
    //插入检查组表dhcrb_examcat
    s examCatRowid=$o(^DHCRBExamCati("catcode",ItemCatCode,0))

    if (examCatRowid="")
    {
	    &sql(insert into dhcrb_examcat( CatCode,CatDesc) VALUES (:ItemCatCode,:ItemCatDesc))
	    s examCatRowid=$p(%ROWID,$c(1))
    }
    else
    {
	    &sql(update dhcrb_examcat(CatDesc) values(:ItemCatDesc) where EC_RowId=:examCatRowid)
    }
    
    q:(examCatRowid="") "210"
    
    s ArcItmRowid=""
   	i ArcItmCode'="" 
   	{
    	s SubscriptID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),0))
    	i SubscriptID'="" 
    	{
	    	s VersionID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),SubscriptID,0))
	    	i VersionID'="" s ArcItmRowid=SubscriptID_"||"_VersionID 
    	}
   	}
	
	q:(ArcItmRowid="") "220"
	
	s arcItemDesc=$p(^ARCIM(SubscriptID,VersionID,1),"^",2)
	
	s examItemRowid=$o(^DHCRBExamItemi("arcItem",ArcItmRowid,0))
	

	if (examItemRowid="")
	{
		&sql(INSERT INTO dhcrb_examitem(examcatrowid,itemrowid,itemCode,itemdesc) VALUES(:examCatRowid,:ArcItmRowid,:ArcItmCode,:arcItemDesc))
	}
	else
	{
		&sql(update dhcrb_examitem(examcatrowid,itemCode,itemdesc) VALUES(:examCatRowid,:ArcItmCode,:arcItemDesc) where itemrowid=:ArcItmRowid)
	}
	
	q SQLCODE
}

/// w ##class(web.DHCRisImportData).ImportDocExamCap("")
/// 导入检查科室医生能力 与 检查组 关联
/// 入参：医生登陆代码^医生姓名^检查数量1^检查数量2^检查数量3^医生可做检查组(多项,分隔)
/// 返回值：200 医生代码无法在ssuser表查到
///         210 医生检查能力rowid没取到
///         
ClassMethod ImportDocExamCap(Info As %String) As %String
{
	s ^TempDHCRisWf("ImportDocExamCap")=Info
	//005988^魏常华^26^26^26^心脏
	s docInit=$p($g(Info),"^",1)
	s examNum1=$p($g(Info),"^",3)
	s examNum2=$p($g(Info),"^",4)
	s examNum3=$p($g(Info),"^",5)
	s examCatList=$p($g(Info),"^",6)
	
	s userRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(docInit,"U"),0))
	
	q:(userRowid="") "200"
	
	s docExamCapRowid=$o(^DHCRBDocExamCapSeti("userRowid",userRowid,0))
	
	if (docExamCapRowid="")
	{
		&sql(INSERT INTO DHCRB_DocExamCapSet(UserCode,UserRowid,ExamNum1,ExamNum2,ExamNum3) VALUES(:docInit,:userRowid,:examNum1,:examNum2,:examNum3))
		s docExamCapRowid=$p(%ROWID,$c(1))
	}
	else
	{
		&sql(update DHCRB_DocExamCapSet(UserCode,UserRowid,ExamNum1,ExamNum2,ExamNum3) VALUES(:docInit,:userRowid,:examNum1,:examNum2,:examNum3) where DECS_RowId=:docExamCapRowid)
	}
	
	q:(docExamCapRowid="") "210"
	
	if (examCatList'="")
	{
		&sql(delete FROM DHCRB_DocExamCapSetCat where DocCapSetRowid=:docExamCapRowid)
		for i=1:1:$l(examCatList,",")
		{
			s examCatDesc=$p(examCatList,",",i)
			if (examCatDesc'="" )
			{
				s examCatRowid=$o(^DHCRBExamCati("catDesc",examCatDesc,0))
				if ( examCatRowid'="")
				{
					&sql(insert into DHCRB_DocExamCapSetCat(DocCapSetRowid,ExamCatRowid) values(:docExamCapRowid,:examCatRowid))
				}
			}
		}
	}
	
	q SQLCODE
}

/// w ##class(web.DHCRisImportData).ImportResAppLoc("心外监护病房护士站^病房01诊室^病房01诊室")
/// 导入资源和申请科室关联关系
/// 入参:科室名称^设备名称^服务组(可以不填)
/// 返回值：100 参数为空
///         200 科室没找到
///         210 设备没找到
///         
ClassMethod ImportResAppLoc(Info As %String) As %String
{
	s ^TempDHCRisWf("ImportResAppLoc")=Info
	s locName=$p($g(Info),"^",1)
	s resourceDesc=$p($g(Info),"^",2)
	s serviceGroupDesc=$p($g(Info),"^",3)
	
	q:((locName="")||(resourceDesc="")) "100"
	
	s locRowid=$o(^CTLOC(0,"Desc",$zcvt(locName,"U"),0))
	q:(locRowid="") "200"
	
	s equipmentRowid=$o(^RBC("EQ",0,"Desc",$zcvt(resourceDesc,"U"),0)) 
	q:(equipmentRowid="") "210"
	s locRowidRes=$o(^RB("RES",0,"EQ",equipmentRowid,0))
	q:locRowidRes="" "210"
	s resourceRowid=$o(^RB("RES",0,"EQ",equipmentRowid,locRowidRes,0))
	q:resourceRowid="" "210"
	
	s serviceGroupRowid=""
	if (serviceGroupDesc'="")
	{
		s serviceGroupRowid=$o(^RBC("SG",0,"Desc",$zcvt(serviceGroupDesc,"U"),0))
	}
	
	s resInAppLocRowid=$o(^DHCRBCResourceInAppLoci("APPLOC",locRowid,resourceRowid,0))
	
	if ( resInAppLocRowid'="")
	{
		&sql(update DHCRBC_ResourceInAppLoc(DRIL_AppLoc_DR,DRIL_ServiceGroup_DR,DRIL_Resource_DR) values(:locRowid,:serviceGroupRowid,:resourceRowid) where DRIL_RowID=:resInAppLocRowid)
	}
	else
	{
		&sql(insert into DHCRBC_ResourceInAppLoc(DRIL_AppLoc_DR,DRIL_ServiceGroup_DR,DRIL_Resource_DR) values(:locRowid,:serviceGroupRowid,:resourceRowid))
		
	}
	q SQLCODE
}

}
