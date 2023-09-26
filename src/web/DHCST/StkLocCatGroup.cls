Import sqluser

/// Descript:科室类组维护
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-12
Class web.DHCST.StkLocCatGroup Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新科室类组
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-12
/// Table:DHC_StkLocCatGroup
/// Input:科室id;类组id^默认标志,类组id^默认标志
/// Output:     
/// Return：""：成功，非空：保存失败
ClassMethod Save(LocId As %String, listData) As %Library.String
{
    n (LocId,listData)
    ;s ^zdm("web.DHCST.StkLocCatGroup.Save")=listData
     s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    q:LocId="" ""
    s len=$l(listData,rowDelim)
    s err=""
    s msg=0
    f i=1:1:len q:msg'=0  d
    .s GrpInfo=$p(listData,rowDelim,i)
    .s RowId=$p(GrpInfo,"^",1)
    .s GrpId=$p(GrpInfo,"^",2)
    .s DefaultFlag=$p(GrpInfo,"^",3)
    .s DefaultUnique = ..CheckDefaultUniq(LocId, DefaultFlag, RowId)
    .i (DefaultUnique = "Y") s err = "缺省标志重复！"  q
    .s GrpDesc=$p(GrpInfo,"^",4)
    .q:GrpId=""
    .s tmpGrpDesc=$p(^DHCSCG(GrpId),"^",2)
    .i tmpGrpDesc'=GrpDesc d
    ..s tmpId=$o(^DHCSLCG(0,"LOCCAT",LocId,GrpId,""))
    ..s:+tmpId>0 msg=-1
    .q:msg'=0
    .
    .i +RowId>0 d
    ..s ret=..Update(RowId,GrpId,DefaultFlag)
    ..i ret'=0 s err=err_","_GrpDesc
    .e  d
    ..s ret=..Insert(LocId,GrpId,DefaultFlag)
    ..i ret="" s err=err_","_GrpDesc
    .
    q:msg'=0 msg
    q err
}

/// Decription	: 判断科室类组的默认标志是否重复
/// Creator		: yangsj
/// CreateDate	: 2021-08-24
/// Input		:
/// Output		: Y/N  重复/唯一
/// Table		:
/// Debugger	: w ##class(web.DHCST.StkLocCatGroup).CheckDefaultUniq(257,"Y","")
ClassMethod CheckDefaultUniq(LocId, DefaultFlag, RowId = "")
{
	s Unique = "N"
	q:(DefaultFlag '= "Y") Unique
	s SLCG = 0
	for {
		q:(Unique = "Y")
		s SLCG = $O(^DHCSLCG(0,"CTLOC",LocId,"G",SLCG))
		q:(SLCG = "")
		s TmpDefualt = $P(^DHCSLCG(SLCG), "^", 4)
		i (TmpDefualt = "Y")&&(SLCG '=RowId) s Unique = "Y"  q
	}
	q Unique
}

/// Descript:   增加科室类组定义
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-12
/// Table:DHC_StkLocCatGroup
/// Input:科室id,类组id,默认标志
/// Output:     
/// Return：rowid
ClassMethod Insert(LocId As %String, GrpId As %String, DefaultFlag As %String) As %Library.String [ Private ]
{
    n (LocId,GrpId,DefaultFlag)
    ;
    s Type=..sssCode()
    s err=0
    &sql(Insert into DHC_StkLocCatGroup(SLCG_CTLoc_Dr,SLCG_StkCatGrp_Dr,SLCG_Type,SLCG_Default)
    values(:LocId,:GrpId,:Type,:DefaultFlag))
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Insert:DHC_StkLocCatGroup",GrpId,SQLCODE_":"_%msg)
    .s err=-1
    q:err'=0 ""
    q $p(%ROWID,$c(1))
}

/// Descript:   更新科室类组定义
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-12
/// Table:DHC_StkLocCatGroup
/// Input:Rowid,默认标志
/// Output:     
/// Return：0,成功;
ClassMethod Update(Rowid As %String, GrpId As %String, DefaultFlag As %String) As %Library.String [ Private ]
{
    n (Rowid,GrpId,DefaultFlag)
    ;
    s err=0
    &sql(Update DHC_StkLocCatGroup set SLCG_StkCatGrp_Dr=:GrpId,SLCG_Default=:DefaultFlag where SLCG_Rowid=:Rowid)
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Update:DHC_StkLocCatGroup",Rowid,SQLCODE_":"_%msg)
    .s err=-1
    q:err'=0 -1
    q 0
}

/// Descript:   删除科室类组定义
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-12
/// Table:DHC_StkLocCatGroup
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
    &sql(Delete from DHC_StkLocCatGroup where SLCG_Rowid=:rowid)
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Delete:DHC_StkLocCatGroup",rowid,SQLCODE_":"_%msg)
    .s Err=-3
    q Err
}

/// Descript:   查询某科室对应的类组信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-12
/// Table:DHC_StkLocCatGroup
/// Input:科室id
/// Output:     
/// Return：Rowid^类组id^类组代码^类组描述^默认标志
/// 
ClassMethod Query(LocId As %String) As %String
{
    n (LocId)
    ;s ^zdm("Query")=Start_","_Limit_","_Sort_","_Dir_","_StrFilter
    q:LocId="" ""
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    s GrpId=0
    f  s GrpId=$o(^DHCSLCG(0,"LOCCAT",LocId,GrpId)) q:GrpId=""  d
    .s Rowid=$o(^DHCSLCG(0,"LOCCAT",LocId,GrpId,0))
    .q:'$d(^DHCSLCG(Rowid))
    .s Type=$p(^DHCSLCG(Rowid),"^",3)
    .q:Type'=..sssCode()
    .s DefaultFlag=$p(^DHCSLCG(Rowid),"^",4)
	.//i DefaultFlag="Y" d
	.//.s DefaultFlag="true"
	.//e  d
	.//.s DefaultFlag="false"
	.i $d(^DHCSCG(GrpId)) d
    ..s GrpCode=$p(^DHCSCG(GrpId),"^",1)
    ..s GrpDesc=$p(^DHCSCG(GrpId),"^",2)
    ..s Data=Rowid_"^"_GrpId_"^"_GrpCode_"^"_GrpDesc_"^"_DefaultFlag
    ..s count = count+1  
    ..d json.InsertRowData(Data)
    s resultString = json.getJsonData("Rowid^GrpId^GrpCode^GrpDesc^DefaultFlag",count)
    k json
    Q resultString
}

}
