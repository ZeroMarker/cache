Import sqluser

/// Descript:科室管理组相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-08-23
Class web.DHCST.LocManGrp Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新管理组
/// Creater:    ZhangDongmei
/// CreateDate: 2012-08-23
/// Table:DHC_LocManGrp
/// Input:科室id;管理组id^管理组代码^管理组名称,管理组id^管理组代码^管理组名称
/// Output:     
/// Return：0：成功，
/// -1:科室不能为空
ClassMethod Save(LocId As %String, listData) As %Library.String
{
    n (LocId,listData)
    q:LocId="" -1   ;科室不能为空
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    i listData="" d
	.s len=0
	e  d
    .s len=$l(listData,rowDelim)
    s msg=""
    s err=""
    f i=1:1:len  q:msg'=""  d
    .s Detail=$p(listData,rowDelim,i)
    .q:Detail=""
    .s Rowid=$p(Detail,"^",1)
    .s Code=$p(Detail,"^",2)
    .s Desc=$p(Detail,"^",3)
    .q:Code=""
	.q:Desc=""
	.s tmpid=""
    .&SQL(SELECT LMG_Rowid into :tmpid FROM DHC_LocManGrp WHERE LMG_Code=:Code AND LMG_CTLOC_DR=:LocId)
    .s:(tmpid'="")&(tmpid'=Rowid) msg=-5
    .s tmpid=""
    .&SQL(SELECT LMG_Rowid into :tmpid FROM DHC_LocManGrp WHERE LMG_Desc=:Desc AND LMG_CTLOC_DR=:LocId)
    .s:(tmpid'="")&(tmpid'=Rowid) msg=-6
    .q:msg'=""
    .i Rowid=""  d
    ..s ret=..Insert(LocId,Code,Desc)
    ..s:ret'=0 err=err
    .e  d
    ..s ret=..Update(Rowid,Code,Desc)
    ..s:ret'=0 err=err 
    q:msg=-5 msg 
	q:msg=-6 msg 
	q:msg'=0 msg
    q err
}

/// Descript:   增加管理组定义
/// Creater:    ZhangDongmei
/// CreateDate: 2012-08-23
/// Table:DHC_LocManGrp
/// Input:科室id,管理组代码,管理组描述
/// Output:     
/// Return：rowid
ClassMethod Insert(LocId As %String, Code As %String, Desc As %String) As %Library.String [ Private ]
{
    n (LocId,Code,Desc)
    q:LocId="" ""
    ;
    s err=0
    &sql(Insert into DHC_LocManGrp(LMG_CTLOC_DR,LMG_Code,LMG_Desc)
    values(:LocId,:Code,:Desc))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_LocManGrp",LocId,SQLCODE_":"_%msg)
    .s err=-1
    q err
    //q:err'=0 ""
    //q $p(%ROWID,$c(1))
}

/// Descript:   更新管理组定义
/// Creater:    ZhangDongmei
/// CreateDate: 2012-08-23
/// Table:DHC_LocManGrp
/// Input:rowid,管理组代码,管理组描述
/// Output:     
/// Return：0:成功
ClassMethod Update(Rowid As %String, Code As %String, Desc As %String) As %Library.String [ Private ]
{
    n (Rowid,Code,Desc)
    q:Rowid="" ""
    ;
    s err=0
    &sql(Update DHC_LocManGrp set LMG_Code=:Code,LMG_Desc=:Desc where LMG_Rowid=:Rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_LocManGrp",Rowid,SQLCODE_":"_%msg)
    .s err=-1
    q err
}

/// Descript:   删除管理组
/// Creater:    ZhangDongmei
/// CreateDate: 2012-08-23
/// Table:DHC_LocManGrp
/// Input:rowid
/// Output:     
/// Return：0,成功,
ClassMethod Delete(rowid As %String) As %Library.String
{
    n (rowid)
    ;
    ;不能为空项
    q:rowid="" ""
    ;
    s Err=0
    &sql(Delete from DHC_LocManGrp where LMG_ROWID=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_LocManGrp",rowid,SQLCODE_":"_%msg)
    .s Err=-3
    q Err
}

/// Descript:   删除某科室类组对应的人员信息
/// Creater:    LiMingzhong
/// CreateDate: 2012-06-15
/// Table:DHC_StkLocUserCatGrp
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod DeleteUser(rowid As %String) As %Library.String
{
    n (rowid)
    ;
    ;不能为空项
    q:rowid="" ""
    ;
    &sql(Delete from DHC_LocUserManGrp where LUMG_RowId=:rowid)
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Delete:DHC_LocUserManGrp",rowid,SQLCODE_":"_%msg)
    q SQLCODE
}

/// Descript:   查询某科室对应的管理组信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-08-23
/// Table:DHC_DefLoc
/// Input:主科室id
/// Output:     
/// Return：Rowid^代码^描述
/// 
ClassMethod Query(LocId As %String, UserId = "") As %String
{
    n (LocId,UserId)
    //s ^zdm("Query")=Start_","_Limit_","_Sort_","_Dir_","_StrFilter
   
    q:LocId="" ""
    s count = 0
    s resultString = ""
    s StrSql="select LMG_ROWID as Rowid,LMG_Code as Code,LMG_Desc as Description"_
    " from DHC_LocManGrp where LMG_CTLOC_DR='"_LocId_"'"
    ;
    s json = ##class(Code.JsonObj).%New()
    ;b ;11
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(StrSql)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    ;
    If err  q ""
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    ;
    While(result.Next())
    {   
        s Rowid = result.Data("Rowid")
        s Code = result.Data("Code")
        s Desc = result.Data("Description")
        i (UserId'="") {
        continue:'$d(^DHCLMG(0,"USER",UserId,Rowid))
        s lmgsub=$o(^DHCLMG(0,"USER",UserId,Rowid,""))
        s actflag=$p(^DHCLMG(Rowid,"I",lmgsub),"^",2)
        continue:actflag'="Y"
        }
   
        s Data=Rowid_"^"_Code_"^"_Desc
        s count = count+1   
        d json.InsertRowData(Data)
    }
    d result.Close()
    s resultString = json.getJsonData("Rowid^Code^Desc",count)
    k json
    Q resultString
}

/// Descript:   科室管理组按人员定义
/// Creater:    LiangQiang
/// CreateDate: 2013-11-26
/// Table:DHC_LocManGrp
/// Input:科室id;管理组id^管理组代码^管理组名称,管理组id^管理组代码^管理组名称
/// Output:     
/// Return：0：成功，
/// -1:科室不能为空
ClassMethod SaveLocUserMan(LocGrpId As %String, listData) As %Library.String
{
    n (LocGrpId,listData)
    q:LocGrpId="" -1   ;科室不能为空
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    s err=""
    s msg=0
    f i=1:1:len  q:msg'=0  d
    .s Detail=$p(listData,rowDelim,i)
    .q:Detail=""
    .s Rowid=$p(Detail,"^",1)
    .s Userid=$p(Detail,"^",2)
    .s Active=$p(Detail,"^",3)
    .s Name=$p(Detail,"^",4)
    .i Rowid=""  d
    ..s msg=..InsertUM(LocGrpId,Userid)
    ..i msg'=0 s err=msg_","_Name
    .e  d
    ..s msg=..UpdateUM(Rowid,Userid,Active)
    ..i msg'=0 s err=msg_","_Name
    ..
    q:err="" 0
    q err
}

/// Descript:   增加管理组按人员定义
/// Creater:    LiangQiang
/// CreateDate: 2013-11-26
/// Table:DHC_LocUserManGrp
/// Input:管理组id,人员id
/// Output:     
/// Return：rowid
ClassMethod InsertUM(LocGrpId As %String, UserDr As %String) As %Library.String [ Private ]
{
    n (LocGrpId,UserDr)
    q:LocGrpId="" ""
    ;
    
    q:$d(^DHCLMG(0,"USER",UserDr,LocGrpId)) -99
    s Chl=1+$o(^DHCLMG(LocGrpId,"I",""),-1)
    s Active="Y"
    s err=0
    &sql(Insert into DHC_LocUserManGrp(LUMG_Parref,LUMG_ChildSub,LUMG_SSUSR_DR,LUMG_Active)
    values(:LocGrpId,:Chl,:UserDr,:Active))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_LocUserManGrp",LocGrpId,SQLCODE_":"_%msg)
    .s err=-1
    q:err'=0 ""
    q 0
}

/// Descript:   更新管理组定义
/// Creater:    LiangQiang
/// CreateDate: 2013-11-26
/// Table:DHC_LocUserManGrp
/// Input:rowid,管理组Id,人员Id,启用标志
/// Output:     
/// Return：0:成功
ClassMethod UpdateUM(Rowid As %String, UserDr As %String, Active As %String) As %Library.String [ Private ]
{
    n (Rowid,UserDr,Active)
    q:Rowid="" ""
    ;
    s err=0
    &sql(Update DHC_LocUserManGrp set LUMG_SSUSR_DR=:UserDr,LUMG_Active=:Active where LUMG_RowId=:Rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_LocUserManGrp",Rowid,SQLCODE_":"_%msg)
    .s err=-1
    q err
}

/// Descript:取科室库存项集合
/// Creater:	LiangQaing
/// CreateDate:	2013-11-13
/// Table:
/// Input:开始行,限制数,入参串
/// Output:		
/// Return：
/// w ##class(web.DHCST.LocManGrp).GetLocUserManDs(0,30,"")
ClassMethod GetLocUserManDs(Start, Limit, locGrpId)
{
	n (Start,Limit,locGrpId)
	
	q:locGrpId="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	
	s endpage=Start+Limit  //结束行
	s stpage=Start+1 //开始行

    s h=0
	s pid=..NewPid()

	Set $ZT="ERRORGetLocUserManDs"
	s chl=""
	f  s chl=$o(^DHCLMG(locGrpId,"I",chl)) q:chl=""  d
	.s ssuser=+$p(^DHCLMG(locGrpId,"I",chl),"^",1)
	.s code=$p(^SSU("SSUSR",ssuser),"^",1)
	.s name=$p(^SSU("SSUSR",ssuser),"^",2)
	.s active=$p(^DHCLMG(locGrpId,"I",chl),"^",2)
	.s rowid=locGrpId_"||"_chl
    .s data=ssuser_"^"_code_"^"_name_"^"_active_"^"_rowid
    .s h=h+1
    .s index="Sort^"_name_"^"_h  //排序
    .s ^TMP("DHCST","LocManGrp","GetLocUserManDs",pid,"index",index)=data
    .

    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","LocManGrp","GetLocUserManDs",pid,"index",h)) q:h=""  d
    .s data=^TMP("DHCST","LocManGrp","GetLocUserManDs",pid,"index",h)
    .s ssuser=$p(data,"^",1)
    .s code=$p(data,"^",2)
    .s name=$p(data,"^",3)
    .s active=$p(data,"^",4)
    .s rowid=$p(data,"^",5)
    .
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
	.s UserId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("UserId",ssuser)
	.s Code=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Code",code)
	.s Name=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Name",name)
	.s Active=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Active",active)
	.s Rowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("Rowid",rowid)
    .s tmpstr=UserId_Code_Name_Active_Rowid
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	k ^TMP("DHCST","LocManGrp","GetLocUserManDs",pid)

    q ""
    
ERRORGetLocUserManDs
    //遇报错,则先kill TMP
    Set Method=	"##class(web.DHCST.LocManGrp).GetLocUserManDs"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_locGrpId_")"_","_$ZE
	k ^TMP("DHCST","LocManGrp","GetLocUserManDs",pid)    
    q ErrorMsg
}

ClassMethod NewPid() As %String
{
  	q $I(^DHCSTPID("LocManGrp"))
}

}
