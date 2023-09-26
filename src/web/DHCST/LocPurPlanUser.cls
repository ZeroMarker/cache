Import sqluser

/// Descript:科室采购人员限定维护
/// Creater:	lihui
/// CreateDate:	2015-05-25
Class web.DHCST.LocPurPlanUser Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	查询某安全组下科室对应的人员信息
/// CreateDate:	2015-05-25
/// Table:DHC_LocPurPlanUser
/// Input:开始行，一页记录数，排序字段，排序方向,科室类组id
/// Output:		
/// Return：Rowid^UserId^人员代码^人员姓名^默认标志^激活状态
/// 
ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, CTLocId As %String) As %String
{
	n (CTLocId,Start,Limit,Sort,Dir)
	q:CTLocId="" ""
	s count = 0
	s resultString = ""
	s StrSql="select LPP_RowId as Rowid,LPP_SSUSR_DR,LPP_SSUSR_DR->SSUSR_Initials as Code,"_
	"LPP_SSUSR_DR->SSUSR_Name as Name,LPP_Active,LPP_Default "_
    " from DHC_LocPurPlanUser where LPP_CTLOC_DR='"_CTLocId_"'"
    s OrderField="Rowid"
    s:Sort="Code" OrderField="Code"
    s:Sort="Name" OrderField="Name"
    s:Sort="Active" OrderField="U_Active"
    s:Sort="Default" OrderField="U_Default"
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
	s json = ##class(Code.JsonObj).%New()
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	;
	If err  q ""
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s json = ##class(Code.JsonObj).%New()
	;
	While(result.Next())
	{	
		s Rowid = result.Data("Rowid")
		s UserId = result.Data("LPP_SSUSR_DR")
		s Code = result.Data("Code")
		s Name = result.Data("Name")
		s Active=result.Data("LPP_Active")
		s Default=result.Data("LPP_Default")		
		s Data=Rowid_"^"_UserId_"^"_Code_"^"_Name_"^"_Default_"^"_Active
		s count = count+1	
		CONTINUE:count<(Start+1)
		CONTINUE:count>end	
		d json.InsertRowData(Data)
	}
	d result.Close()
	s resultString = json.getJsonData("Rowid^UserId^Code^Name^Default^Active",count)
	k json
	Q resultString
}

/// Descript:	保存/更新人员限定
/// CreateDate:	2015-05-25
/// Table:DHC_LocPurPlanUser
/// Input:科室id;人员id^激活标志^默认标志,人员id^激活标志^默认标志
/// Output:		
/// Return：""：成功，非空：保存失败
/// w ##class(web.DHCST.LocPurPlanUser).Save(558,"^1^Y^Y^Demo Group")
ClassMethod Save(CTLocId As %String, listData) As %Library.String
{
	n (CTLocId,listData,%session)
	//s ^yunhaibao("save")=CTLocId_"~"_listData
	q:CTLocId="" ""
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
	s err=""
	s msg=0
	f i=1:1:len q:msg'=0  d
    .s LocUserInfo=$p(listData,rowDelim,i)
	.s RowId=$p(LocUserInfo,"^",1)
	.s UserId=$p(LocUserInfo,"^",2)
	.q:UserId=""
	.s ActiveFlag=$p(LocUserInfo,"^",3)
	.s DefaultFlag=$p(LocUserInfo,"^",4)
	.s UserName=$p(LocUserInfo,"^",5)
	.s tmpName=$p(^SSU("SSUSR",UserId),"^",2)
	.s existflag=..CheckLocUserExist(RowId,CTLocId,UserId)
	.i existflag'="" s msg=tmpName_"已存在" //已存在
	.s DefaultExistFlag = ..CheckDefualtExist(RowId, CTLocId, DefaultFlag)
	.i DefaultExistFlag="Y" s msg=tmpName_"的(是否默认)属性重复" 
	.q:msg'=0
	.i RowId'="" d
	..s ret=..Update(RowId,UserId,DefaultFlag,ActiveFlag)
	..s:ret'=0 err=err_","_tmpName
	.e  d
	..s ret=..Insert(CTLocId,UserId,DefaultFlag,ActiveFlag)
	..s:ret="" err=err_","_tmpName
	q:msg'=0 msg
	q err
}

/// Descript:	删除某科室类组对应的人员信息
/// CreateDate:	2015-05-25
/// Table:DHC_LocPurPlanUser
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String) As %Library.String
{
	n (rowid,%session)
 	;不能为空项
 	q:rowid="" ""
 	&sql(select LPP_SSUSR_DR,LPP_Default,LPP_Active into :OldUserId,:OldDefaultFlag,:OldActiveFlag from DHC_LocPurPlanUser where LPP_RowId=:rowid)
    s OldJsonStr="{人员id:"_OldUserId_",默认标志:"_OldDefaultFlag_",激活标志:"_OldActiveFlag_"}"
 	&sql(Delete from DHC_LocPurPlanUser where LPP_RowId=:rowid)
 	i SQLCODE'=0  d
 	.d ErrorRecord^DHCSTERROR(..%GetParameter("AppName"),rowid,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_%msg)
 	e  d
    .s AppName="DHCSTCOMMON"
    .s Version=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"Version","")
    .i Version="Y" d
    ..d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_StkLocUserCatGrp","User.DHCStkLocUserCatGrp","科室用户类组配置信息",rowid,OldUserId,"D",OldJsonStr)
 	q SQLCODE
}

/// Descript:	增加人员限定
/// CreateDate:	2015-05-25
/// Table:DHC_LocPurPlanUser
/// Input:科室id,人员id,默认标志,激活标志
/// Output:		
/// Return：rowid
ClassMethod Insert(LocId As %String, UserId As %String, DefaultFlag As %String, ActiveFlag As %String) As %Library.String [ Private ]
{
	n (LocId,UserId,DefaultFlag,ActiveFlag,%session)
    s JsonStr="{科室id:"_LocId_",人员id:"_UserId_",默认标志:"_DefaultFlag_",激活标志:"_ActiveFlag_"}"
 	s err=0
 	&sql(Insert into DHC_LocPurPlanUser(LPP_CTLOC_DR,LPP_SSUSR_DR,LPP_Active,LPP_Default)
 	values(:LocId,:UserId,:ActiveFlag,:DefaultFlag))
 	i SQLCODE'=0  d
 	.d ErrorRecord^DHCSTERROR(..%GetParameter("AppName"),LocId_","_UserId_","_ActiveFlag_","_DefaultFlag,$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_%msg)
 	.s err=-1
 	q:err'=0 ""
    s AppName="DHCSTCOMMON"
    s Version=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"Version","")
    i Version="Y" d
    .d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_StkLocUserCatGrp","User.DHCStkLocUserCatGrp","科室用户类组配置信息",$SYSTEM.SQL.GetROWID(),UserId,"A",JsonStr)
 	q $p(%ROWID,$c(1))
}

/// Descript:	更新人员限定
/// CreateDate:	2015-05-25
/// Table:DHC_LocPurPlanUser
/// Input:Rowid,默认标志,激活标志
/// Output:		
/// Return：0,成功;  
ClassMethod Update(Rowid As %String, UserId As %String, DefaultFlag As %String, ActiveFlag As %String) As %Library.String [ Private ]
{
	n (Rowid,UserId,DefaultFlag,ActiveFlag,%session)
 	&sql(select LPP_SSUSR_DR,LPP_Default,LPP_Active into :OldUserId,:OldDefaultFlag,:OldActiveFlag from DHC_LocPurPlanUser where LPP_RowId=:Rowid)
    s OldJsonStr="{人员id:"_OldUserId_",默认标志:"_OldDefaultFlag_",激活标志:"_OldActiveFlag_"}"
    s JsonStr="{人员id:"_UserId_",默认标志:"_DefaultFlag_",激活标志:"_ActiveFlag_"}"
 	s err=0
 	&sql(Update DHC_LocPurPlanUser set LPP_SSUSR_DR=:UserId,LPP_Default=:DefaultFlag ,LPP_Active=:ActiveFlag where LPP_RowId=:Rowid)
 	i SQLCODE'=0  d
 	.d ErrorRecord^DHCSTERROR(..%GetParameter("AppName"),UserId_","_DefaultFlag_","_ActiveFlag_","_Rowid,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_%msg)
 	.s err=-1
 	e  d
    .s AppName="DHCSTCOMMON"
    .s Version=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"Version","")
    .i Version="Y" d
    ..d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_StkLocUserCatGrp","User.DHCStkLocUserCatGrp","科室用户类组配置信息",Rowid,UserId,"U",JsonStr,OldJsonStr)
 	q:err'=0 -1
 	q 0
}

/// description:验证人员是否已经存在
/// output:"" 不存在,非空存在
/// w ##class(web.DHCST.LocPurPlanUser).CheckLocUserExist("","102","873")
ClassMethod CheckLocUserExist(rowid, locid, userid) As %String
{
	q:userid="" ""
	q:locid="" ""
	s userexist=""
	s tmprowid=""
	f  s tmprowid=$o(^DHCLOCPPUSER(0,"LOC",locid,tmprowid))  Q:(tmprowid="")||(userexist'="")  d
	.q:+tmprowid=0
	.q:(rowid'="")&&(rowid=tmprowid)
	.s tmpuserid=$p(^DHCLOCPPUSER(tmprowid),"^",2)
	.i tmpuserid=userid s userexist=1
	q userexist
}

/// description:验证默认标志是否存在
/// output:N/Y 不存在,非空存在
/// w ##class(web.DHCST.LocPurPlanUser).CheckDefualtExist("","102","873")
ClassMethod CheckDefualtExist(rowid, locid, defaultFlag) As %String
{
	n (rowid, locid, defaultFlag)
	s Exist = "N"
	q:locid="" Exist
	q:defaultFlag'="Y" Exist
	s tmprowid=""
	f  s tmprowid = $o(^DHCLOCPPUSER(0,"LOC",locid,tmprowid))  Q:(tmprowid="")||(Exist="Y")  d
	.q:+tmprowid=0
	.q:(rowid'="")&&(rowid=tmprowid)
	.s tmpDefaultFlag=$p(^DHCLOCPPUSER(tmprowid),"^",4)
	.i tmpDefaultFlag="Y" s Exist="Y"
	q Exist
}

}
