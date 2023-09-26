Import sqluser

/// Descript:应用系统参数设定
/// Creater:    LiMingzhong
/// CreateDate: 2012-6-7
Class web.DHCST.StkSysAppParame Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   查询应用系统参数信息
/// Creater:    LiMingzhong
/// CreateDate: 2012-6-7
/// Table:DHC_StkSysAProp
/// Input:
/// Output:     
/// Return：应用系统参数信息
/// Others: w ##class(web.DHCST.StkSysAppParame).SelectAll(91)
ClassMethod SelectAll(Parref As %String)
{
    n (Parref)
    q:Parref="" ""
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select SSAP_RowID as RowId,SSAP_Code as Code,SSAP_Desc as Description,SSAP_Memo as Memo,SSAP_Value as DefaultVal from DHC_StkSysAProp where SSAP_RowID>0 and SSAP_SSA_Parref="_Parref
    d result.Prepare(sqlStr)
    d result.Execute()

    ;
    s count = 0
    s resultString = ""
	s dataJson={}
    s rows=[]
    While(result.Next())
    {   
        s RowId = result.Data("RowId")
        s Code = result.Data("Code")
        s Description = result.Data("Description")
        s Memo = result.Data("Memo")
		s DefaultVal = result.Data("DefaultVal")
		i (Code="FtpPassword")&&(DefaultVal'="") s DefaultVal=$tr($j(" ",$l(DefaultVal))," ","●")
		s row={}
		s row.RowId=RowId
		s row.Parref=Parref
		s row.Code=Code
		s row.Desc=Description
		s row.Memo=Memo
		s row.DefaultVal=DefaultVal
		d rows.%Push(row)
		s count=count+1
    }
	s dataJson.rows=rows
	s dataJson.results=count
	q dataJson.%ToJSON()
}

/// Descript:   删除应用系统参数信息
/// Creater:    LiMingzhong
/// CreateDate: 2012-6-7
/// Table:DHC_StkSysAProp
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String) As %Library.String
{
    n (rowid)
    ;
    ;不能为空项
    q:rowid="" ""
    ;
    s Err=0
    &sql(Delete from DHC_StkSysAProp where SSAP_RowID=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_StkSysAProp",rowid,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// Descript:   保存/更新应用系统参数信息
/// Creater:    LiMingzhong
/// CreateDate: 2012-6-7
/// Table:DHC_StkSysAProp
/// Input:数据串:rowid^父表id^名称^描述^备注,
/// rowid^父表id^名称^描述^备注
/// Output:     
/// Return："" – 成功，非空：失败
/// Others:w ##class(web.DHCST.StkSysAppParame).Save("^1^dd^dd^dd^dd")
ClassMethod Save(listData As %String) As %Library.String
{
    n (listData)
    ;s ^zdm("cs")=listData
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    ;s msg=0
    s err=""
    f i=1:1:len  d
    .s data=$p(listData,rowDelim,i)
    .s rowid=$p(data,"^",1)
    .s parref=$p(data,"^",2)
    .s name=$p(data,"^",3)
    .s desc=$p(data,"^",4)
    .s memo=$p(data,"^",5)
	.s defaultVal=$p(data,"^",6)
    .q:parref=""
    .i rowid'=""  d
    ..s ret=..Update(rowid,name,desc,memo,defaultVal)
    ..s:ret'=0 err=err_","_name_"-"_desc
    .e  d
    ..s ret=..Insert(parref,name,desc,memo,defaultVal)
    ..s:ret="" err=err_","_name_"-"_desc
    .
    q err
}

/// Descript:   增加应用系统参数信息
/// Creater:    LiMingzhong
/// CreateDate: 2012-6-7
/// Table:DHC_StkSysAProp
/// Input:父表id,名称,描述,备注
/// Output:     
/// Return：rowid
ClassMethod Insert(Parref As %String, Name As %String, Desc As %String, Memo As %String, Value As %String = "") As %Library.String [ Private ]
{
    n (Parref,Name,Desc,Memo,Value)
    ;不能为空项
    q:Parref="" ""
    s Chl=1+$o(^DHCSSA(Parref,"AP",""),-1)
 
    q:$d(^DHCSSA(0,"APNAME",Parref,$$ALPHAUP^SSUTIL4(Name))) ""
    
    &sql(
		Insert into DHC_StkSysAProp
		(SSAP_SSA_Parref,SSAP_ChildSub,SSAP_Code,SSAP_Desc,SSAP_Memo,SSAP_Value) 
		values
		(:Parref,:Chl,:Name,:Desc,:Memo,:Value))
    s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_StkSysAProp",Parref,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 ""
    q $p(%ROWID,$c(1))
}

/// Descript:   更新应用系统参数信息
/// Creater:    LiMingzhong
/// CreateDate: 2012-6-7
/// Table:DHC_StkSysAProp
/// Input:rowid,名称,描述,备注
/// Output:     
/// Return：0:成功;非0：失败
ClassMethod Update(Rowid As %String, Name As %String, Desc As %String, Memo As %String, Value As %String = "") As %Library.String [ Private ]
{
    n (Rowid,Name,Desc,Memo,Value)
    ;不能为空项
    q:Rowid="" ""
    
    s Err=0
    &sql(Update DHC_StkSysAProp set SSAP_Code=:Name,SSAP_Desc=:Desc,SSAP_Memo=:Memo,SSAP_Value=:Value where SSAP_RowID=:Rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_StkSysAProp",Rowid,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// Descript:   查询应用系统参数值信息
/// Creater:    LiMingzhong
/// CreateDate: 2012-7-4
/// Table:DHC_StkSysAPropPref
/// Input:参数ID,安全组
/// Output:     
/// Return：应用系统参数值信息
/// Others: w ##class(web.DHCST.StkSysAppParame).SelectProp("91||1")
ClassMethod SelectProp(Parref As %String, GroupId As %String)
{
    n (Parref,GroupId)
    q:Parref="" ""
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select PF_SSAP_ParRef as ParRef,PF_RowId as RowId,PF_Type as Type,PF_Pointer as Pointer,PF_Value as PFValue,PF_Hospital_DR as HospDr,PF_StDate as StDate from DHC_StkSysAPropPref where PF_RowId>0 and PF_SSAP_ParRef='"_Parref_"'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {   
        s TypeName = "",PointerName = "",HospName = ""
        s ParRef = result.Data("ParRef")
        s RowId = result.Data("RowId")
        s Type = result.Data("Type")
        s Pointer = result.Data("Pointer")
        ;,G,L,U,D
        i Type = "" d
        .s TypeName = "全部"
        i Type = "G" d
        .s TypeName = "安全组"
        .s PointerName = ..FindPointer(Pointer,Type,GroupId)
        i Type = "L" d
        .s TypeName = "科室"
        .s PointerName = ..FindPointer(Pointer,Type,GroupId)
        i Type = "U" d
        .s TypeName = "用户"
        .s PointerName = ..FindPointer(Pointer,Type,GroupId)
        i Type = "D" d
        .s TypeName = "全院"
        .s PointerName="DHC"
        s Value = result.Data("PFValue")
        s HospDr = result.Data("HospDr")
        i HospDr'="" d
        .i $d(^CT("HOSP",HospDr)) d
        ..s HospName = $P($G(^CT("HOSP",HospDr)),"^",2)
        s StDate= result.Data("StDate")
        s StDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(StDate)
        s tmp=ParRef_"^"_RowId_"^"_Type_"^"_TypeName_"^"_Pointer_"^"_PointerName_"^"_Value_"^"_HospDr_"^"_HospName_"^"_StDate_"^"_Value
        s count = count+1       
        d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("ParRef^RowId^Type^TypeName^Pointer^PointerName^Value^HospDr^HospName^StDate^ValueCipher",count)
    k json
    Q resultString
}

/// Descript:   保存/更新应用系统参数值信息
/// Creater:    LiMingzhong
/// CreateDate: 2012-7-5
/// Table:DHC_StkSysAPropPref
/// Input:数据串:rowid^父表id^类型^类型值^参数值^医院,rowid^父表id^类型^类型值^参数值^医院
/// Output:     
/// Return："" – 成功，非空：失败
/// Others:w ##class(web.DHCST.StkSysAppParame).SaveProp("104||7||1^104||7^D^DHC^1^2^")
ClassMethod SaveProp(listData As %String) As %Library.String
{
    n (listData)
    s ^zdm("cs")=listData
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    ;s msg=0
    s err=""
    
        // 2019-12-26  yangsj
    // 此处针对集团化标致额外做判断，规则1：集团化标致只允许录入一条明细；2：集团化标致为非2时，定价规则各个院区不允许维护不同的定价类型(在保存定价类型时控制)
    // 只允许单独录入单条明细的参数配置可以在此处增加配置，公用下方判断
    s firstDetail=$p(listData,rowDelim,1)
    s ssap=$P(firstDetail,"^",2)
    s ssapCode=$P(^DHCSSA(+ssap,"AP",$P(ssap,"||",2)),"^",1)
    i (ssapCode="GroupFlag") d
    .i (len>1) s err="("_$P(^DHCSSA(+ssap,"AP",$P(ssap,"||",2)),"^",2)_") 该配置只允许维护一条明细数据，请检查明细记录条数" q
    .s InPutFirstSsapp=$P(firstDetail,"^",1)
    .s CurLastSsapp=$O(^DHCSSA(+ssap,"AP",$P(ssap,"||",2),"PF",""),-1)
    .i (InPutFirstSsapp="")&&(CurLastSsapp'="") s err="("_$P(^DHCSSA(+ssap,"AP",$P(ssap,"||",2)),"^",2)_") 该配置只允许维护一条明细数据，请检查明细记录条数" q
    .// 判断单条数据结束，开始检查定价规则
    .s GroupFlag=$P(firstDetail,"^",5)
    .q:GroupFlag=2
    .s RpRulessa=$O(^DHCSSA(0,"ACODE","DHCSTCOMMON",""))  //模块id  避免用id写死，此处用配置的Code来取值id
    .q:RpRulessa=""
    .s RpRulessapChl=$O(^DHCSSA(0,"APCODE",RpRulessa,$ZCVT("RpRule","U"),""))
    .q:RpRulessapChl="" 
    .s sameFlag=0
    .s RpRuleStr=..GetRpRuleStr()
    .q:RpRuleStr=""
    .s RpRuleStrlen=$L(RpRuleStr,"#")
    .f i=1:1:RpRuleStrlen  q:(err'="")  d
    ..s RpRuleDetail=$P(RpRuleStr,"#",i)
    ..s tmpRpRuleValue=$P(RpRuleDetail,"^",2)
    ..i sameFlag=0 s sameFlag=tmpRpRuleValue
    ..e  i sameFlag'=tmpRpRuleValue s err="修改(集团化标志)为非2时，所有院区的(定价规则)必须保持一致。请检查(定价类型)数据" q
    q:err'="" err
    
    
    // 此处针对定价规则额外做判断。规则：(承接上方判断)，如果集团化标致为非2，怎定价规则必须与第一条明细记录保持一致(默认第一条记录为主院)。
    i (ssapCode="RpRule") d
    .s ssa=$O(^DHCSSA(0,"ACODE","DHCSTCOMMON",""))  //模块id  避免用id写死，此处用配置的Code来取值id
    .q:ssa=""
    .s ssapChl=$O(^DHCSSA(0,"APCODE",ssa,$ZCVT("GroupFlag","U"),""))
    .q:ssapChl="" 
    .s ssappFirstChl=$O(^DHCSSA(ssa,"AP",ssapChl,"PF",""))
    .q:ssappFirstChl=""
    .s GroupFlag=$P(^DHCSSA(ssa,"AP",ssapChl,"PF",ssappFirstChl),"^",3)
    .q:GroupFlag=2
    .s sameFlag=""
    .//检查录入数据
    .f i=1:1:len q:(err'="")  d
    ..s data=$p(listData,rowDelim,i)
    ..s tmpvalue=$p(data,"^",5)
    ..i (sameFlag="") s sameFlag=tmpvalue
    ..e  i (sameFlag'=tmpvalue) s sameFlag=-1
    ..i (sameFlag=-1) s err="(集团化标志)不为2时不同院区的定价规则必须一致，请检查数据或者修改(集团化标志)为2" q
    .q:err'=""
    .s RpRuleStr=..GetRpRuleStr()
    .q:RpRuleStr=""
    .s curRpRuleValue=$P($P(RpRuleStr,"#",1),"^",2)
    .//录入的最后一条和已存在的第一条记录比较
    .i tmpvalue'=curRpRuleValue s err="(集团化标志)不为2时不同院区的定价规则必须一致，请检查数据或者修改(集团化标志)为2" q 
    q:err'="" err
    
    
    f i=1:1:len  d
    .s data=$p(listData,rowDelim,i)
    .q:data=""
    .s chkInfo=..CheckPropValue(listData)
    .i $p(chkInfo,"^",1)<0 s err=chkInfo q
    .s rowid=$p(data,"^",1)
    .s parref=$p(data,"^",2)
    .s type=$p(data,"^",3)
    .s Pointer=$p(data,"^",4)
    .s value=$p(data,"^",5)
    .s hospDr=$p(data,"^",6)
    .s stDate=$p(data,"^",7)
    .s stDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stDate)
    .q:parref=""
    .i rowid'=""  d
    ..s ret=..UpdateProp(rowid,type,Pointer,value,hospDr,stDate)
    ..s:ret'=0 err=err_","_name_"-"_desc
    .e  d
    ..s ret=..InsertProp(parref,type,Pointer,value,hospDr,stDate)
    ..s:ret="" err=err_","_name_"-"_desc
    .
    q err
}

/// Descript:   增加应用系统参数值信息
/// Creater:    LiMingzhong
/// CreateDate: 2012-7-5
/// Table:DHC_StkSysAPropPref
/// Input:父表id,类型,类型值,参数值,医院
/// Output:     
/// Return：rowid
ClassMethod InsertProp(Parref As %String, type As %String, Pointer As %String, value As %String, hospDr As %String, stDate) As %Library.String
{
    n (Parref,type,Pointer,value,hospDr,stDate)
    ;不能为空项
    q:Parref="" ""
    s Chl=1+$o(^DHCSSA($P(Parref,"||",1),"AP",$P(Parref,"||",2),"PF",""),-1)

    
    &sql(Insert into DHC_StkSysAPropPref(PF_SSAP_ParRef,PF_ChildSub,PF_Type,PF_Pointer,PF_Value,PF_Hospital_DR,PF_StDate) values(:Parref,:Chl,:type,:Pointer,:value,:hospDr,:stDate))
    s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_StkSysAPropPref",Parref,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 ""
    q $p(%ROWID,$c(1))
}

/// Descript:   更新应用系统参数值信息
/// Creater:    LiMingzhong
/// CreateDate: 2012-7-5
/// Table:DHC_StkSysAPropPref
/// Input:rowid,类型,类型值,参数值,医院
/// Output:     
/// Return：0:成功;非0：失败
ClassMethod UpdateProp(Rowid As %String, type As %String, Pointer As %String, value As %String, hospDr As %String, stDate) As %Library.String
{
    n (Rowid,type,Pointer,value,hospDr,stDate)
    ;不能为空项
    q:Rowid="" ""
    
    s Err=0
    &sql(Update DHC_StkSysAPropPref set PF_Type=:type,PF_Pointer=:Pointer,PF_Value=:value,PF_Hospital_DR=:hospDr,PF_StDate=:stDate where PF_RowId=:Rowid)
    i SQLCODE'=0  d
    .s ret=$$ErrorRecord^DHCSTERROR("Update:DHC_StkSysAPropPref",Rowid,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// Descript:   删除应用系统参数值信息
/// Creater:    LiMingzhong
/// CreateDate: 2012-7-5
/// Table:DHC_StkSysAPropPref
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod DeleteProp(rowid As %String) As %Library.String
{
    n (rowid)
    ;
    ;不能为空项
    q:rowid="" ""
    s Err=0
    s DHCSSAAP=$g(^DHCSSA(+rowid,"AP",+$p(rowid,"||",2)))
    i $p(DHCSSAAP,"^",1)="RpRule" d
    .s DHCSSAAPPF=$g(^DHCSSA(+rowid,"AP",+$p(rowid,"||",2),"PF",+$p(rowid,"||",3)))
    .i DHCSSAAPPF'="" d
    ..s code=$p(DHCSSAAPPF,"^",1)
    ..s stDate=$p(DHCSSAAPPF,"^",5)
    ..i stDate="" s Err=-2 q
    ..i stDate<=+$h s Err=-2 q
	q:Err'=0 Err
    &sql(Delete from DHC_StkSysAPropPref where PF_RowId=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_StkSysAPropPref",rowid,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// Descript:   查询类型值
/// Creater:    LiMingzhong
/// CreateDate: 2012-7-5
/// Table:DHC_StkSysAPropPref
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod FindPointer(Pointer As %String, Type As %String, GroupId As %String) As %Library.String
{
    n (Pointer,Type,GroupId)
 
    q:Pointer="" ""
    q:Type="" ""
    q:GroupId="" ""
    
    s PointerName = ""
    s sql = ""
    i Type="G" d
    .s sql = "select SSGRP_Desc AS Name from SS_Group where SSGRP_RowId="_Pointer
    i Type="L" d
    .s sql="select CTLOC_DESC AS Name from CT_Loc WHERE CTLOC_ROWID="_Pointer 
    i Type="U" d
    .s sql="select  ssusr_name as Name from SS_user where ssusr_rowid="_Pointer 
    
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sql)
    d result.Execute()
    While(result.Next())
    {
        s PointerName = result.Data("Name")
    }
    Q PointerName
}

/// 获取某参数值 DHC_StkSysAPropPref
/// Author:gwj
/// Date:2012-09-29
/// Argu:
///   SSACode -模块代码
///   SSAPCode-参数代码
///   PFType-权限类型
/// Return:
///    参数值^类型值^医院
ClassMethod GetPropValue(SSACode As %String, SSAPCode As %String, PFType As %String) As %Library.String
{
    s SSARid=$o(^DHCSSA(0,"ACODE",$$ALPHAUP^SSUTIL4(SSACode),""))
    q:SSARid="" ""
    s SSAP=$O(^DHCSSA(0,"APCODE",SSARid,$$ALPHAUP^SSUTIL4(SSAPCode),""))
    q:SSAP="" ""
    s Value="",Pointer="",Hosp=""
    s PFsub="" f  s PFsub=$o(^DHCSSA(SSARid,"AP",SSAP,"PF",PFsub)) q:PFsub=""  d
    .s Type=$p(^DHCSSA(SSARid,"AP",SSAP,"PF",PFsub),"^",1)
    .q:Type'=PFType
    .s Pointer=$p(^DHCSSA(SSARid,"AP",SSAP,"PF",PFsub),"^",2)
    .s Value=$p(^DHCSSA(SSARid,"AP",SSAP,"PF",PFsub),"^",3)
    .s Hosp=$p(^DHCSSA(SSARid,"AP",SSAP,"PF",PFsub),"^",4)
    q Value_"^"_Pointer_"^"_Hosp
}

/// Description: 验证RpRule是否可新增或修改
/// 按院区判断,院区必填
/// w ##class(web.DHCST.StkSysAppParame).CheckPropValue("^104||8^D^DHC^4^2^2019-05-08")
ClassMethod CheckPropValue(DataStr)
{
	n (DataStr)
    s RowId=$p(DataStr,"^",1)
    s Parref=$p(DataStr,"^",2)
    s Type=$p(DataStr,"^",3)
    s Pointer=$p(DataStr,"^",4)
    s Value=$p(DataStr,"^",5)
    s HospDr=$p(DataStr,"^",6)
    s StDate=$p(DataStr,"^",7)
    s appId=+Parref
    s appProp=+$p(Parref,"||",2)
    s DHCSSAAP=$g(^DHCSSA(appId,"AP",appProp))
    q:$p(DHCSSAAP,"^",1)'="RpRule" ""
    s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
    q:(StDate'="")&&(StDate<=+$h) "-1^生效日期应大于当前日期"
    s chkInfo=""
    s appPropPref=""
    f  s appPropPref=$o(^DHCSSA(appId,"AP",appProp,"PF",appPropPref)) q:(appPropPref="")||(chkInfo'="")  d
    .q:+appPropPref=0
    .q:(RowId'="")&&(RowId=appId_"||"_appProp_"||"_appPropPref)
    .s DHCSSAAPPF=$g(^DHCSSA(appId,"AP",appProp,"PF",appPropPref))
    .s val=$p(DHCSSAAPPF,"^",3)
    .s hospId=$p(DHCSSAAPPF,"^",4)
    .s stDate=$p(DHCSSAAPPF,"^",5)
    .q:HospDr'=hospId
    .i (StDate="")&&(stDate="") s chkInfo="-1^已存在生效日期为空的记录"
    .i StDate=stDate s chkInfo="-1^已存在生效日期相同记录"
    .i StDate<stDate s chkInfo="-1^存在最后生效日期大于生效日期"
    q chkInfo
}

/// Description:获取每个医院当前的定价规则
/// Creator:yangsj
/// CreateDate;2019-12-26
/// Input:
/// Output: hospid1^value1#hospid2^value2#hospid3^value3...
/// Others:w ##class(web.DHCST.StkSysAppParame).GetRpRuleStr() 
ClassMethod GetRpRuleStr()
{
	s ssa=$O(^DHCSSA(0,"ACODE","DHCSTCOMMON",""))  //模块id  避免用id写死，此处用配置的Code来取值id
    q:ssa=""
    s ssapChl=$O(^DHCSSA(0,"APCODE",ssa,$ZCVT("RpRule","U"),""))
    q:ssapChl="" 
    s ssappChl=""
    f  s ssappChl=$O(^DHCSSA(ssa,"AP",ssapChl,"PF",ssappChl)) q:ssappChl=""  d
    .s data=^DHCSSA(ssa,"AP",ssapChl,"PF",ssappChl)
    .s value=$P(data,"^",3)
    .s hospid=$P(data,"^",4)
    .s date=$P(data,"^",5)
    .i date="" s date="0"
    .s listhosvalue(hospid,date)=value
    s RpRuleStr=""
    s hospid=""
    f  s hospid=$O(listhosvalue(hospid)) q:hospid=""  d
    .s date=$O(listhosvalue(hospid,""),-1)
    .s value=listhosvalue(hospid,date)
    .s str=hospid_"^"_value
    .s RpRuleStr=$S(RpRuleStr="":str,1:RpRuleStr_"#"_str)
    
    k listhosvalue
    q RpRuleStr
}

}
