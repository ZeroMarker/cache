Import sqluser

/// Descript:库存分类（包括类组）相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-08
Class web.DHCST.INCSTKCAT Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppTable [ Final ] = "DHC_StkCatGroup";

/// Descript:   保存/更新库存分类信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-08
/// Table:DHC_StkCatGroup
/// Input:库存分类数据串:rowid^代码^描述,rowid^代码^描述
/// Output:     
/// Return："" – 成功，非空：失败
/// w ##class(web.DHCST.INCSTKCAT).Save("7^KYY^科研药^GZ")
ClassMethod Save(listData As %String, HospId As %String) As %Library.String
{
    n (listData,HospId,%session)
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    s err=""
    f i=1:1:len  d
    .s data=$p(listData,rowDelim,i)
    .s rowid=$p(data,"^",1)
    .s code=$p(data,"^",2)
    .s desc=$p(data,"^",3)
    .s setCode=$p(data,"^",4)
    .s strumodeflag=$p(data,"^",5)
    .s existFlag=..CheckExist(rowid,code,desc,HospId)
	.i existFlag'="" d
	..s err=$p(existFlag,"^",2)
	.q:err'=""
    .i code'="" s code=$$ALPHAUP^SSUTIL4(code)
    .i rowid'=""  d
    ..s ret=..Update(rowid,code,desc,setCode,strumodeflag)
    ..s:ret'=0 err=err_","_desc
    .e  d
    ..s ret=..Insert(code,desc,setCode,strumodeflag,HospId)
    ..s:ret="" err=err_","_desc
    .
    q err
}

/// Descript:   增加类组信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-08
/// Table:DHC_StkCatGroup
/// Input:代码,描述,类型
/// Output:     
/// Return：rowid
ClassMethod Insert(code As %String, desc As %String, setCode As %String, strumodeflag As %String, HospId As %String) As %Library.String [ Private ]
{
    n (code,desc,setCode,strumodeflag,HospId,%session)
    ;
    ;不能为空项
    q:code="" ""
    q:desc="" ""
    ;
    s type=..sssCode()
    s Err=0
    &sql(Insert into DHC_StkCatGroup(SCG_Code,SCG_Desc,SCG_Type,SCG_Set,SCG_StruModeFlag)
    values(:code,:desc,:type,:setCode,:strumodeflag))
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Insert:DHC_StkCatGroup",code,SQLCODE_":"_%msg)
    ..s Err=-1   ;插入失败
    e  d
    .s ScgID=$p(%ROWID,$c(1))
    .s ret=##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,ScgID,HospId)
    .i ret'=1 d
    ..d ErrorRecord^DHCSTERROR("Insert:BDP_MappingHosp",ScgID,ret_":DHC_StkCatGroup")
    q:SQLCODE'=0 ""
    s ScgID=$p(%ROWID,$c(1))
    s AppName="DHCSTCOMMON"
    s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    i RecordTraceFlag="Y" d
    .s JsonStr1=##class(web.DHCST.Common.JsonObj).GetValue("DHC_StkCatGroup",ScgID)
    .d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_StkCatGroup","User.DHCStkCatGroup","类组",ScgID,desc,"A",JsonStr1)
    
    q $p(%ROWID,$c(1))
}

/// Descript:   更新类组信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-08
/// Table:DHC_StkCatGroup
/// Input:rowid^代码^描述^类型
/// Output:     
/// Return：rowid
ClassMethod Update(rowid As %String, code As %String, desc As %String, setCode As %String, strumodeflag As %String) As %Library.String [ Private ]
{
    n (rowid,code,desc,setCode,strumodeflag)
    ;不能为空项
    q:code="" ""
    q:desc="" ""
    q:rowid="" ""
    ;
    s $ZT="Error^DHCSTERROR"
    &sql(Update DHC_StkCatGroup set SCG_Code=:code,SCG_Desc=:desc,SCG_Set=:setCode,SCG_StruModeFlag=:strumodeflag
    where SCG_Rowid=:rowid)
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Update:DHC_StkCatGroup",code,SQLCODE_":"_%msg)
    q SQLCODE
}

/// Descript:   删除类组信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-08
/// Table:DHC_StkCatGroup
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String, HospId As %String) As %Library.String
{
    n (rowid,HospId,%session)
    ;
    ;不能为空项
    q:rowid="" ""
    &sql(SELECT SCG_Code, SCG_Desc into :SCGCode,:SCGDesc FROM DHC_StkCatGroup WHERE SCG_Rowid=:Phcd)
    s JsonStr="{类组代码:"""_SCGCode_""",类组名称:"""_SCGDesc_"""}"
 	;
    &sql(Delete from DHC_StkCatGroup where SCG_Rowid=:rowid)
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Delete:DHC_StkCatGroup",rowid,SQLCODE_":"_%msg)
    e  d
    .s ret=##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#AppTable,rowid,HospId)
    s AppName="DHCSTCOMMON"
    s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    i RecordTraceFlag="Y" d
    .d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_StkCatGroup","User.DHCStkCatGroup","类组",rowid,SCGDesc,"D",JsonStr)

    q SQLCODE
}

/// Descript:   查询类组信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-08
/// Table:DHC_StkCatGroup
/// Input:
/// Output:     
/// Return：类组信息
ClassMethod SelectAll(HospId)
{
	n (HospId,%session)
    //q:type="" ""
    s result = ##class(%Library.ResultSet).%New()
    s type=..sssCode()
    s sqlStr = "SELECT SCG_ROWID as Rowid,SCG_CODE as Code,SCG_DESC as Description,SCG_Set as SetCode,SCG_StruModeFlag as StruModeFlag  FROM DHC_StkCatGroup WHERE SCG_Type ="_"'"_type_"'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {   
        s Rowid = result.Data("Rowid")
        s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_StkCatGroup",Rowid,HospId) //医院级别授权
	continue:flag="N"
        s Code = result.Data("Code")
        s Description = result.Data("Description")
        s SetCode=result.Data("SetCode")
        s SetDesc=$s(SetCode="GX":"西药",SetCode="GZ":"中成药",SetCode="GC":"草药",1:"")
        s StruModeFlag = result.Data("StruModeFlag")
        s tmp=Rowid_"^"_Code_"^"_Description_"^"_SetCode_"^"_SetDesc_"^"_StruModeFlag
        s count = count+1       
        d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Code^Desc^SetCode^SetDesc^StruModeFlag",count)
    k json
    Q resultString
}

/// Descript:   增加类组和库存分类关联
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-08
/// Table:DHC_StkCatGrpRelations
/// Input:类组id^库存分类id,类组id^库存分类id
/// Output:     
/// Return：成功:"", 失败:失败串
ClassMethod AddRelation(ListData As %String) As %Library.String
{
    n (ListData)
    ;
    ;不能为空项
    q:ListData="" ""
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(ListData,rowDelim)
    s err=""
    f i=1:1:len  d
    .s data=$p(ListData,rowDelim,i)
    .s StkGrpId=$p(data,"^",1)
    .s StkCatId=$p(data,"^",2)
    .q:StkCatId="" 
    .q:'$d(^DHCSCG(StkGrpId)) 
    .q:'$d(^INC("SC",StkCatId)) 
    .
    .s ret=..InsertRelation(StkGrpId,StkCatId)
    .i ret=""  d
    ..s StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
    ..s err=err_","_StkCatDesc
    .
    q err
}

/// Descript:   增加类组和库存分类关联
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-08
/// Table:DHC_StkCatGrpRelations
/// Input:类组id,库存分类id
/// Output:     
/// Return：成功:rowid, 失败:空
ClassMethod InsertRelation(StkGrpId As %String, StkCatId As %String) As %Library.String [ Private ]
{
    n (StkGrpId,StkCatId)
    ;
    ;不能为空项
    q:StkGrpId="" ""
    q:StkCatId="" ""
    q:'$d(^DHCSCG(StkGrpId)) ""
    q:'$d(^INC("SC",StkCatId)) ""
    ;
    ;s type=..sssCode() //不做处理
    s chl=1+$o(^DHCSCG(StkGrpId,"RE",""),-1)
    &sql(Insert into DHC_StkCatGrpRelations(SCGR_SCG_Parref,SCGR_StkCat_DR,SCGR_Childsub)
    values(:StkGrpId,:StkCatId,:chl))
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("AddRelation:DHC_StkCatGrpRelations",StkCatId,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ""
    q $p(%ROWID,$c(1))
}

/// Descript:   删除类组和库存分类关联
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-08
/// Table:DHC_StkCatGrpRelations
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod DeleteRelation(rowid As %String) As %Library.String
{
    n (rowid)
    ;
    ;不能为空项
    q:rowid="" ""
    s IncSC=$P(^DHCSCG(+rowid,"RE",$P(rowid,"||",2)),"^",1)
    q:..CheckIncSCHavenUse(IncSC)=1 "-1^有药品维护了该库存分类，请将药品的库存分类修改后再删除！"
    ;
    &sql(Delete from DHC_StkCatGrpRelations where SCGR_Rowid=:rowid)
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("DeleteRelation:DHC_StkCatGrpRelations",rowid,SQLCODE_":"_%msg)
    q SQLCODE
}

/// Description:判断是否有药品维护了该库存分类
/// Creator:yangsj
/// CreateDate:2020-06-17
/// Input:incstkcat
/// Output:1 维护了药品 0 未维护
/// w ##class(web.DHCST.INCSTKCAT).CheckIncSCHavenUse(19)
ClassMethod CheckIncSCHavenUse(IncSC)
{
	n (IncSC)
	s ret=0
	q:IncSC="" ret
	s tmpInci=$o(^INCI(0,"StkCat",IncSC,""))
	q:tmpInci'="" 1
	q ret
}

/// Descript:   查询类组关联的库存分类
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-08
/// Table:DHC_StkCatGrpRelations
/// Input:类组id
/// Output:     
/// Return：类组信息
ClassMethod SelectRelationCat(StkGrpId As %String, HospId)
{
    n (StkGrpId,HospId,%session)
    q:StkGrpId="" ""
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    s Chl=""
    f  s Chl=$o(^DHCSCG(StkGrpId,"RE",Chl)) q:Chl=""  d
    .s StkCatId=$p(^DHCSCG(StkGrpId,"RE",Chl),"^",1)
    .q:StkCatId=""
    .q:'$d(^INC("SC",StkCatId))
    .s flag=##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_StkCat",StkCatId,HospId) //医院级别授权
    .q:flag="N"
    .s StkCatCode=$p(^INC("SC",StkCatId),"^",1)
    .s StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
    .s RelationId=StkGrpId_"||"_Chl
    .s tmp=RelationId_"^"_StkCatId_"^"_StkCatCode_"^"_StkCatDesc
    .s count = count+1      
    .d json.InsertRowData(tmp)
    .
    s resultString = json.getJsonData("relationId^catId^code^desc",count)
    k json
    Q resultString
}

/// Descript:   查询尚未归属类组的库存分类
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-10
/// Table:DHC_StkCatGrpRelations
/// Input:
/// Output:     
/// Return：分类信息
ClassMethod SelectNoRelationCat(HospId)
{
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    s type=..sssCode()
    s StkCatId=0
    f  s StkCatId=$o(^INC("SC",StkCatId)) q:StkCatId=""  d
    .s StkGrpId=+$o(^DHCSCG("STKCAT",StkCatId,""))
    .s StkType=$p(^INC("SC",StkCatId),"^",3)
	.q:StkType'=type
    .s flag=0               ;默认没归属类组
    .i StkGrpId'="" d
    ..s Chl=$o(^DHCSCG("STKCAT",StkCatId,StkGrpId,""))
    ..q:Chl=""
    ..s:$d(^DHCSCG(StkGrpId,"RE",Chl)) flag=1   ;存在归属类组
    .q:flag=1     ;维护了类组
    .s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_StkCat",StkCatId,HospId) //医院级别授权
    .q:flag="N"
    .s StkCatCode=$p(^INC("SC",StkCatId),"^",1)
    .s StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
    .s tmp=StkCatId_"^"_StkCatCode_"^"_StkCatDesc
    .s count = count+1      
    .d json.InsertRowData(tmp)
    .
    s resultString = json.getJsonData("RowId^Code^Description",count)
    k json
    Q resultString
}

ClassMethod CodeToID(code, HospId)
{
	n (code,HospId)
	s RetRowID=""
	s code=$$ALPHAUP^SSUTIL4(code)
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
    s Rowid=0
	f  s Rowid=$o(^DHCSCG(Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s scgType=$p(^DHCSCG(Rowid),"^",3)
	.q:scgType'=..sssCode()
	.s scgCode=$p(^DHCSCG(Rowid),"^",1)
	.q:scgCode'=code
	.s flag="Y"
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s RetRowID=Rowid
	q $g(RetRowID)
}

ClassMethod DescToID(desc, HospId)
{
	n (desc,HospId)
	s RetRowID=""
	//s desc=$$ALPHAUP^SSUTIL4(desc)
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
    s Rowid=0
	f  s Rowid=$o(^DHCSCG(0,"TYPE","G",desc,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s flag="Y"
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s RetRowID=Rowid
	q $g(RetRowID)
}

/// description: 判断是否重复
/// return:      -1^验证信息
ClassMethod CheckExist(rowId, code, desc, HospId = "")
{
 	n (code,desc,rowId,HospId)
 	s errCode=""
 	s id=..CodeToID(code,HospId)
 	i (id'="")&&(id'=rowId) s errCode="-1^代码重复"
	s id=..DescToID(desc,HospId)
 	i (id'="")&&(id'=rowId) s errCode="-1^名称重复"
	q errCode
}

}
