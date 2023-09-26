Import sqluser

/// Descript:科室扩充信息相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-22
Class web.DHCST.CTLOC Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新科室扩充信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-22
/// Table:DHCST_CtLoc
/// Input:科室id^项目组id^科室组id^类型^激活标志,科室id^项目组id^科室组id^类型^激活标志
/// Output:     
/// Return：""：成功，非空：保存失败
ClassMethod Save(listData As %String) As %Library.String
{
    n (listData)
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    s err=""
    f i=1:1:len  d
    .s data=$p(listData,rowDelim,i)
    .s loc=$p(data,"^",1)
    .q:loc=""
    .s locdesc=$p(^CTLOC(loc),"^",2)
    .s lig=$p(data,"^",2)    ;项目组
    .s slg=$p(data,"^",3)    ;科室组
    .s type=$p(data,"^",4)   ;库房科室类型
    .s activeflag=$p(data,"^",5)   ;激活标志
    .s mainLoc=$p(data,"^",6)  //支配科室
    .s rowid=$o(^DHCLOC(0,"LOC",loc,0))
    .i activeflag="true" s activeflag="Y"
    .i activeflag="false" s activeflag="N"
    .i rowid'=""  d
    ..s ret=..Update(rowid,lig,slg,type,activeflag,mainLoc)
    ..s:ret'=0 err=err_","_locdesc
    .e  d
    ..s ret=..Insert(loc,lig,slg,type,activeflag,mainLoc)
    ..s:ret="" err=err_","_locdesc
    .
    q err
}

/// Descript:   增加科室扩充信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-22
/// Table:DHCST_CtLoc
/// Input:科室id,项目组id,科室组id,类型,激活标志
/// Output:     
/// Return：rowid
ClassMethod Insert(loc As %String, lig As %String, slg As %String, type As %String, active As %String, mainLoc As %String) As %Library.String [ Private ]
{
    n (loc,lig,slg,type,active,mainLoc)
    ;
    ;不能为空项
    q:loc="" ""
    ;
    s err=0
    &sql(Insert into DHCST_CtLoc(DHCLoc_Ctloc_dr,DHCLoc_LIG_Dr,DHCLoc_SLG_Dr,
    DHCLoc_Flag,DHCLoc_Type,DHCLoc_MainLoc_DR)
    values(:loc,:lig,:slg,:active,:type,:mainLoc))
    s ^xuantmp("kk")=SQLCODE
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHCST_CtLoc",loc,SQLCODE_":"_%msg)
    .s err=-1
    q:err'=0 ""
    q $p(%ROWID,$c(1))
}

/// Descript:   更新科室扩充信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-22
/// Table:DHCST_CtLoc
/// Input:rowid,项目组id,科室组id,类型,激活标志
/// Output:     
/// Return：0,成功,
ClassMethod Update(rowid As %String, lig As %String, slg As %String, type As %String, active As %String, mainLoc As %String) As %Library.String [ Private ]
{
    n (rowid,lig,slg,type,active,mainLoc)
    ;
    ;不能为空项
    q:rowid="" ""
    ;
    s Err=0
    &sql(Update DHCST_CtLoc set DHCLoc_LIG_Dr=:lig,DHCLoc_SLG_Dr=:slg,DHCLoc_Type=:type,
     DHCLoc_Flag=:active,DHCLoc_MainLoc_DR=:mainLoc where DHCLoc_Rowid=:rowid)
    i SQLCODE'=0  d
    .s ret=$$ErrorRecord^DHCSTERROR("Update:DHCST_CtLoc",rowid,SQLCODE_":"_%msg)
    .s Err=-3
    q Err
}

/// Descript:   查询科室扩充信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-22
/// Table:DHCST_CtLoc,CT_Loc
/// Input:开始行，一页记录数，排序字段，排序方向,科室代码^科室名称^科室组id^项目组id^科室类型^激活标志
/// Output:     
/// Return：科室id^科室代码^科室描述^项目组id^项目组^科室组id^科室组^科室类型^激活标志
/// w ##class(web.DHCST.CTLOC).Query(0,20,"Desc","DESC","肝病^")
ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrFilter As %String, HospId = "") As %String
{
    n (Start,Limit,Sort,Dir,StrFilter,HospId)
    s ^zdm("Query")=$lb(Start,Limit,Sort,Dir,StrFilter,HospId)
    s count = 0
    
    q:Limit=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s resultString = ""
    s StrSql="select a.CTLOC_RowId as DescId,a.CTLOC_Code as Code,a.CTLOC_Desc as CtDesc,"_
    "b.DHCLoc_LIG_Dr,b.DHCLoc_LIG_Dr->LIG_Desc as LigDesc,"_
    "b.DHCLoc_SLG_Dr,b.DHCLoc_SLG_Dr->SLG_Desc as SlgDesc,b.DHCLoc_Type,b.DHCLoc_Flag,"_
    "b.DHCLoc_MainLoc_DR as MainLoc,b.DHCLoc_MainLoc_DR->CTLOC_Desc as MainLocDesc"_
    " from CT_Loc a Left join DHCST_CtLoc b on a.CTLOC_Rowid=b.DHCLoc_Ctloc_dr"
    s OrderField="DescId"
    i StrFilter'=""  d
    .s StrSql=StrSql_" where 1=1 "
    s LocCode=$p(StrFilter,"^",1)
    s LocDesc=$p(StrFilter,"^",2)
    s Slg=$p(StrFilter,"^",3)
    s Lig=$p(StrFilter,"^",4)
    s Type=$p(StrFilter,"^",5)
    s Active=$p(StrFilter,"^",6)
    s mainLoc=$p(StrFilter,"^",7)
    i LocCode'=""  d
    .s StrSql=StrSql_" and a.CTLOC_Code like '%"_LocCode_"%'"
    i LocDesc'=""  d
    .s StrSql=StrSql_" and a.CTLOC_Desc like '%"_LocDesc_"%'"
    i Slg'=""  d
    .s StrSql=StrSql_" and b.DHCLoc_SLG_Dr = '"_Slg_"'"
    i Lig'=""  d
    .s StrSql=StrSql_" and b.DHCLoc_LIG_Dr = '"_Lig_"'"
    i Type'=""  d
    .s StrSql=StrSql_" and b.DHCLoc_Type = '"_Type_"'"
    i Active'=""  d
    .s StrSql=StrSql_" and b.DHCLoc_Flag = '"_Active_"'"
    i mainLoc'=""  d
    .s StrSql=StrSql_" and b.DHCLoc_MainLoc_DR = '"_mainLoc_"'"
    s:Sort="Code" OrderField="Code"
    s:Sort="Desc" OrderField="CtDesc"
    s:Sort="LigDesc" OrderField="LigDesc"
    s:Sort="SlgDesc" OrderField="SlgDesc"
    s:Sort="Type" OrderField="DHCLoc_Type"
    s:Sort="Active" OrderField="DHCLoc_Flag"
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
    //s ^zdm("Query_sql")=StrSql
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
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    ;
    s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
    While(result.Next())
    {   
        s DescId = result.Data("DescId")
        if BDPHospAut="Y"{
	        s locHospDr=$p(^CTLOC(DescId),"^",22)
	        continue:locHospDr'=HospId
	    }
        s Desc=$p(^CTLOC(DescId),2)
        s Code = result.Data("Code")
        s Desc = result.Data("CtDesc")
        s LigId=result.Data("DHCLoc_LIG_Dr")
        s LigDesc=result.Data("LigDesc")
        s SlgId=result.Data("DHCLoc_SLG_Dr")
        s SlgDesc=result.Data("SlgDesc")
        s Type = result.Data("DHCLoc_Type")
        s Active = result.Data("DHCLoc_Flag")
#;      i Active="Y" d
#;      .s Active="true"
#;      e  d
#;      .s Active="false"
        ;
        s MainLoc=result.Data("MainLoc")
        s MainLocDesc=result.Data("MainLocDesc")
        s Data=Code_"^"_DescId_"^"_Desc_"^"_LigId_"^"_LigDesc_"^"_SlgId_"^"_SlgDesc_"^"_Type_"^"_Active_"^"_MainLoc_"^"_MainLocDesc
        s count = count+1   
        CONTINUE:count<(Start+1)
        CONTINUE:count>end  
        d json.InsertRowData(Data)
    }
    d result.Close()
    s resultString = json.getJsonData("Code^DescId^Desc^LigId^LigDesc^SlgId^SlgDesc^Type^Active^MainLoc^MainLocDesc",count)
    k json
    Q resultString
}

/// Descript:   查询科室信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-12
/// Table:CT_Loc
/// Input:开始行，一页记录数，排序字段，排序方向,科室代码^科室名称
/// Output:     
/// Return：科室id^科室代码^科室描述
/// Others: w ##class(web.DHCST.CTLOC).QueryLoc(1,25,"Rowid","desc","^")
ClassMethod QueryLoc(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrFilter As %String) As %String
{
    n (StrFilter,Start,Limit,Sort,Dir)
    ;s ^zdm("Query")=Start_","_Limit_","_Sort_","_Dir_","_StrFilter
    s count = 0
    s resultString = ""
    s StrSql="select CTLOC_RowId as Rowid,CTLOC_Code as Code,CTLOC_Desc as CtDesc"_
    " from CT_Loc "
    s OrderField="Rowid"
    ;
    s LocCode=$p(StrFilter,"^",1)
    s LocDesc=$p(StrFilter,"^",2)
    i LocCode'=""  d
    .s StrSql=StrSql_" where CTLOC_Code like '%"_LocCode_"%'"
    i (LocDesc'="")&(LocCode'="")  d
    .s StrSql=StrSql_" and CTLOC_Desc like '%"_LocDesc_"%'"
    i (LocDesc'="")&(LocCode="")  d
    .s StrSql=StrSql_" where CTLOC_Desc like '%"_LocDesc_"%'"
    ;
    s:Sort="Code" OrderField="Code"
    s:Sort="Desc" OrderField="CtDesc"
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
    ;s ^zdm("Query_sql")=StrSql
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
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    ;
    While(result.Next())
    {   
        s Rowid = result.Data("Rowid")
        s Code = result.Data("Code")
        s Desc = result.Data("CtDesc")
        ;
        s Data=Rowid_"^"_Code_"^"_Desc
        s count = count+1   
        CONTINUE:count<(Start+1)
        CONTINUE:count>end  
        d json.InsertRowData(Data)
    }
    d result.Close()
    s resultString = json.getJsonData("Rowid^Code^Desc",count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2012-05-24
/// description: 安全组能访问的科室
/// Table:SS_GroupStockLocations
/// input:开始行，一页记录数，排序字段，排序方向,安全组id,科室代码^科室名称 
/// output: String "RowId^Code^Description"
/// others:
/// w ##class(web.DHCST.CTLOC).QueryGroupLoc(0,999,"","",142,"nsk")
ClassMethod QueryGroupLoc(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, GroupId As %String, StrFilter As %String, HospId = "")
{
    n (Start,Limit,Sort,Dir,GroupId,StrFilter,HospId)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT ST_CTLOC_DR AS Rowid,ST_CTLOC_DR->CTLOC_Code AS Code,ST_CTLOC_DR->CTLOC_DESC AS CtDesc FROM SS_GroupStockLocations"_
    " WHERE ST_ParRef='"_GroupId_"'"_" AND (ST_ActiveFlag IS NULL OR ST_ActiveFlag='Y')"
    s OrderField="Rowid"
    s LocCode=$$ALPHAUP^SSUTIL4($p(StrFilter,"^",1))
    s LocDesc=$$ALPHAUP^SSUTIL4($p(StrFilter,"^",2))
    i LocCode'=""  d
    .s sqlStr=sqlStr_" and ST_CTLOC_DR->CTLOC_Code like '%"_LocCode_"%'"
    i LocDesc'="" d
    .s sqlStr=sqlStr_" and (%ALPHAUP(ST_CTLOC_DR->CTLOC_Desc) like '%"_LocDesc_"%'"_" or %ALPHAUP(ST_CTLOC_DR->CTLOC_ContactName) like '%"_LocDesc_"%'"_")"
    s:Sort="Code" OrderField="Code"
    s:Sort="Desc" OrderField="CtDesc"
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s sqlStr=sqlStr_" order by "_OrderField_" "_Dir
    ;s ^zdm("Query_sql")=StrSql
    s json = ##class(Code.JsonObj).%New()
    ;b ;11
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlStr)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    ;
    If err  q ""
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
    ;
    While(result.Next())
    {   
        s Rowid = result.Data("Rowid")
        s Code = result.Data("Code")
        s Desc = result.Data("CtDesc")
        s locData = ^CTLOC(Rowid)
        s hospdr=$p(locData,"^",22)
        continue:(BDPHospAut="Y")&&(hospdr'=HospId)
        s dateTo = $p(locData, "^", 25)
		continue:(dateTo '= "")&&(dateTo <= (+$h))
        s Data=Rowid_"^"_Code_"^"_Desc
        s count = count+1   
        CONTINUE:count<(Start+1)
        CONTINUE:count>end  
        d json.InsertRowData(Data)
    }
    d result.Close()
    s resultString = json.getJsonData("Rowid^Code^Desc",count)
    k json
    Q resultString
}

}
