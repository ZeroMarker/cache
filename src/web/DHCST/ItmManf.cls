Import sqluser

/// Descript:厂商相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-10
Class web.DHCST.ItmManf Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   查询厂商信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-10
/// Table:PH_Manufacturer,DHC_Manf_AddionInfo
/// Input:
/// Output:     
/// Return：厂商信息
ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, Code As %String, Name As %String, Hosp) As %String
{
    n (Code,Name,Start,Limit,Sort,Dir,Hosp)
    s count = 0
    s resultString = ""
    s type=..sssCode()
    s type="M"
    s StrSql="select a.PHMNF_RowId,a.PHMNF_Name,a.PHMNF_Tel,"_
    "a.PHMNF_Code,b.MANF_Rowid,b.MANF_ParManf_DR,b.MANF_ParManf_DR->PHMNF_Name as ParManf,"_
    "b.MANF_DrugProduct_Permit,"_
    "b.MANF_DrugProduct_ExpDate,b.MANF_MatProduct_Permit,b.MANF_MatProduct_ExpDate,"_
    "b.MANF_ComLic,b.MANF_ComLicDate,b.MANF_Active,b.MANF_Type"_
    " from ph_manufacturer a left join DHC_Manf_AddionInfo b on a.phMnf_rowid=b.MANF_PhcManf_DR"_
    " where b.MANF_Type "_"!"_"= "_"'"_type_"'"
    s OrderField="PHMNF_RowId"
    s:Code'="" StrSql=StrSql_" and a.PHMNF_Code like '%"_Code_"%'"
    s:Name'="" StrSql=StrSql_" and a.PHMNF_Name like '%"_Name_"%'"
    s:Sort="Code" OrderField="a.PHMNF_Code"
    s:Sort="Name" OrderField="a.PHMNF_Name"
    s:Sort="DrugProductExp" OrderField="b.MANF_DrugProduct_ExpDate"
    s:Sort="MatProductExp" OrderField="b.MANF_MatProduct_ExpDate"
    s:Sort="ComLicDate" OrderField="b.MANF_ComLicDate"
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
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
        s Rowid = result.Data("PHMNF_RowId")
        continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("PH_Manufacturer",Rowid,Hosp)="N"
        s ManfCode = result.Data("PHMNF_Code")
        s ManfName = result.Data("PHMNF_Name")
        s Address =..GetAddress(Rowid)
        s Tel = result.Data("PHMNF_Tel")
        s AddManfId = result.Data("MANF_Rowid")
        s ParManfId = result.Data("MANF_ParManf_DR")
        s ParManf = result.Data("ParManf")
        s DrugProductP = result.Data("MANF_DrugProduct_Permit")
        s DrugProductE = result.Data("MANF_DrugProduct_ExpDate")
        s:DrugProductE'="" DrugProductE=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(DrugProductE,"ST")
        s MatProductP = result.Data("MANF_MatProduct_Permit")
        s MatProductE = result.Data("MANF_MatProduct_ExpDate")
        s:MatProductE'="" MatProductE=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(MatProductE,"ST")
        s ComLic = result.Data("MANF_ComLic")
        s ComLicDate = result.Data("MANF_ComLicDate")
        s:ComLicDate'="" ComLicDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ComLicDate,"ST")
        s Active = result.Data("MANF_Active")
        //s ManfType = result.Data("MANF_Type")
        //continue:ManfType="M"
        s Data1=Rowid_"^"_ManfCode_"^"_ManfName_"^"_Address_"^"_Tel_"^"_AddManfId
        s Data2=ParManfId_"^"_ParManf_"^"_DrugProductP_"^"_DrugProductE_"^"_MatProductP_"^"_MatProductE
        s Data3=ComLic_"^"_ComLicDate_"^"_Active
        s Data=Data1_"^"_Data2_"^"_Data3
		s Data= ##class(web.DHCST.Common.JsonObj).GetData(Data)
        s count = count+1   
        CONTINUE:count<(Start+1)
        CONTINUE:count>end  
        d json.InsertRowData(Data)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Code^Name^Address^Tel^AddManfId^ParManfId^ParManf^DrugProductP^DrugProductExp^MatProductP^MatProductExp^ComLic^ComLicDate^Active",count)
    k json
    Q resultString
}

/// Descript:查询某厂商明细
/// Creater:ZhangDongmei
/// CreateDate: 2012-05-10
/// Table:PH_Manufacturer,DHC_Manf_AddionInfo
/// Input:
/// Output:     
/// Return： 代码^描述^地址^电话^附加表RowId^上一级厂商
/// 药物生产许可^药物生产许可有效期^材料生产许可^材料生产许可有效期^工商执照^工商执照许可证^激活标志
ClassMethod Select(PhManfId) As %Library.String
{

    n (PhManfId)
    q:PhManfId="" ""
    q:'$d(^PHMNF(PhManfId)) ""
    ;
    s Code=$p(^PHMNF(PhManfId),"^",1)
    s Name=$p(^PHMNF(PhManfId),"^",2)
    s Tel=$p(^PHMNF(PhManfId),"^",3)
    s Address=..GetAddress(PhManfId)
    s ManfAddId=$o(^DHCMANF(0,"MANF",PhManfId,""))
    i ManfAddId'=""  d
    .s ParManfId=$p(^DHCMANF(ManfAddId),"^",2)
    .s DrugProductP=$p(^DHCMANF(ManfAddId),"^",3)
    .s DrugProductE=$p(^DHCMANF(ManfAddId),"^",4)
    .s:DrugProductE'="" DrugProductE=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(DrugProductE,"ST")
    .s MatProductP=$p(^DHCMANF(ManfAddId),"^",5)
    .s MatProductE=$p(^DHCMANF(ManfAddId),"^",6)
    .s:MatProductE'="" MatProductE=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(MatProductE,"ST")
    .s Type=$p(^DHCMANF(ManfAddId),"^",7)
    .s ComLic=$p(^DHCMANF(ManfAddId),"^",8)
    .s ComLicDate=$p(^DHCMANF(ManfAddId),"^",9)
    .s:ComLicDate'="" ComLicDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ComLicDate,"ST")
    .s Active=$p(^DHCMANF(ManfAddId),"^",10)
    .
    s:$g(ParManfId)'="" ParManf=$p(^PHMNF(ParManfId),"^",2)
    ;
    s Data1=Code_"^"_Name_"^"_Address_"^"_Tel_"^"_ManfAddId_"^"_$g(ParManfId)_"^"_$g(ParManf)
    s Data2=$g(DrugProductP)_"^"_$g(DrugProductE)_"^"_$g(MatProductP)_"^"_$g(MatProductE)_"^"_$g(ComLic)_"^"_$g(ComLicDate)_"^"_Active
    s Data=Data1_"^"_Data2
    q Data
}

/// Descript:   增加厂商信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-11
/// Table:PH_Manufacturer,DHC_Manf_AddionInfo
/// Input:代码^名称^地址^电话^上级厂商id^药品生产许可证^药品生产许可证效期^
/// 器械生产许可证^器械生产许可证效期^工商执照^工商执照有效期^激活标志
/// Output:     
/// Return：成功:rowid, 失败:"", -1:名称不能重复，-11:代码不能重复
/// 
ClassMethod Save(listData As %String, hosp) As %Library.String
{
    n (listData,hosp)
    ;不能为空项
    q:listData="" ""
    s Code=$p(listData,"^",1)
    s Name=$p(listData,"^",2)
    q:Code="" ""
    q:Name="" ""
    s Address=$p(listData,"^",3)
    s Tel=$p(listData,"^",4)
    s ParManfId=$p(listData,"^",5)
    s DrugPermit=$p(listData,"^",6)
    s DrugPermitExp=$p(listData,"^",7)
    s:DrugPermitExp'="" DrugPermitExp=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(DrugPermitExp)
    s MatPermit=$p(listData,"^",8)
    s MatPermitExp=$p(listData,"^",9)
    s:MatPermitExp'="" MatPermitExp=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(MatPermitExp)
    s ComLic=$p(listData,"^",10)
    s ComLicDate=$p(listData,"^",11)
    s:ComLicDate'="" ComLicDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ComLicDate)
    s Active=$p(listData,"^",12)
	s sqlStr="SELECT PHMNF_RowId AS rowID FROM PH_Manufacturer WHERE PHMNF_Code='"_Code_"'"
	s existFlag=##class(PHA.COM.Method).IsSQLDataExist(sqlStr,"PH_Manufacturer",hosp)
    q:existFlag'="" -11  ;代码不能重复
    ;
    s Type=..sssCode()
    s Err=0
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    &sql(Insert into PH_Manufacturer(PHMNF_Code,PHMNF_Name,PHMNF_Tel)
    values(:Code,:Name,:Tel))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Save:PH_Manufacturer",Name,SQLCODE_":"_%msg)
    .s Err=-2
    i Err'=0 trollback
    q:Err'=0 ""
    s ManfId=$p(%ROWID,$c(1))
    d ..SaveAddress(Address,ManfId)
    &sql(Insert into DHC_Manf_AddionInfo(MANF_ParManf_DR,MANF_DrugProduct_Permit,
    MANF_DrugProduct_ExpDate,MANF_MatProduct_Permit,MANF_MatProduct_ExpDate,
    MANF_PhcManf_DR,MANF_Type,MANF_ComLic,MANF_ComLicDate,MANF_Active)
    values(:ParManfId,:DrugPermit,:DrugPermitExp,:MatPermit,:MatPermitExp,
    :ManfId,:Type,:ComLic,:ComLicDate,:Active))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Save:DHC_Manf_AddionInfo",Name,SQLCODE_":"_%msg)
    .s Err=-3
    i Err'=0 trollback
    q:Err'=0 ""
    d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp("PH_Manufacturer", ManfId, hosp)
    tcommit
    q ManfId
}

/// Descript:   更新厂商信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-11
/// Table:PH_Manufacturer
/// Input:rowid^代码^名称^地址^电话^上级厂商id^药品生产许可证^药品生产许可证效期^
/// 器械生产许可证^器械生产许可证效期^工商执照^工商执照有效期^激活标志
/// Output:     
/// Return：成功:0;失败：非0,-1:名称重复,-11:代码不能重复
ClassMethod Update(listData As %String, histype As %String = "", hosp = "") As %Library.String
{
    n (listData,histype,hosp)
    ;
    ;不能为空项
    q:listData="" ""
    s ManfId=$p(listData,"^",1)
    q:ManfId="" ""
    s ManfAddId=$o(^DHCMANF(0,"MANF",ManfId,""))
    s Code=$p(listData,"^",2)
    s Name=$p(listData,"^",3)
    s Address=$p(listData,"^",4)
    s Tel=$p(listData,"^",5)
    s ParManfId=$p(listData,"^",6)
    s DrugPermit=$p(listData,"^",7)
    s DrugPermitExp=$p(listData,"^",8)
    s:DrugPermitExp'="" DrugPermitExp=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(DrugPermitExp)
    s MatPermit=$p(listData,"^",9)
    s MatPermitExp=$p(listData,"^",10)
    s:MatPermitExp'="" MatPermitExp=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(MatPermitExp)
    s ComLic=$p(listData,"^",11)
    s ComLicDate=$p(listData,"^",12)
    s:ComLicDate'="" ComLicDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ComLicDate)
    s Active=$p(listData,"^",13)
    s TmpId=$o(^PHMNF(0,"Name",$$ALPHAUP^SSUTIL4(Name),""))
    //q:(TmpId'="")&(TmpId'=ManfId) -1     ;名称重复
    s sqlStr="SELECT PHMNF_RowId AS rowID FROM PH_Manufacturer WHERE PHMNF_Code='"_Code_"'" _"AND PHMNF_RowId!='"_ManfId_"'"
	s existFlag=##class(PHA.COM.Method).IsSQLDataExist(sqlStr,"PH_Manufacturer",hosp)
    q:existFlag'="" -11  ;代码不能重复
    s manfhisinfo=..GetManfHisInfo(ManfId)     ;取原厂商信息
    s hismanfcode=$p(manfhisinfo,"^",1)
    s hismanfdesc=$p(manfhisinfo,"^",2)
    s hismanftel=$p(manfhisinfo,"^",3)
    s hismanfaddress=$p(manfhisinfo,"^",4)
    s hismanfDrugPermit=$p(manfhisinfo,"^",5)
    s hismanfDrugPermitExp=$p(manfhisinfo,"^",6)
    s hismanfMatPermit=$p(manfhisinfo,"^",7)
    s hismanfMatPermitExp=$p(manfhisinfo,"^",8)
    s hismanfComLic=$p(manfhisinfo,"^",9)
    s hismanfComLicDate=$p(manfhisinfo,"^",10)
    s hismanParId=$p(manfhisinfo,"^",11)
    s hisstartdate=..GetHisEndDate(ManfId)
    s hisenddate=+$h-1
    i hisstartdate>hisenddate s hisenddate=hisstartdate
    ;
    s Err=0
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    i histype'="" d
    .&sql(Insert into DHC_Manf_History(MANFH_Phmnf_Dr,MANFH_StartDate,MANFH_EndDate,MANFH_Code,MANFH_Name,MANFH_Tel,MANFH_Address,MANFH_DrugProduct_Permit,MANFH_DrugProduct_ExpDate,
    MANFH_MatProduct_Permit,MANFH_MatProduct_ExpDate,MANFH_ComLic,MANFH_ComLicDate,MANFH_ParMANF_Dr)
    values(:ManfId,:hisstartdate,:hisenddate,:hismanfcode,:hismanfdesc,:hismanftel,:hismanfaddress,:hismanfDrugPermit,:hismanfDrugPermitExp,:hismanfMatPermit,:hismanfMatPermitExp,:hismanfComLic,:hismanfComLicDate,:hismanParId))
    .i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Save:DHC_Manf_History",hismanfdesc,SQLCODE_":"_%msg)
    ..s Err=-4
    i Err'=0 trollback
    q:Err'=0 -4
    
    &sql(update PH_Manufacturer set PHMNF_Code=:Code,PHMNF_Name=:Name,
    PHMNF_Tel=:Tel where PHMNF_Rowid=:ManfId)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:PH_Manufacturer",Name,SQLCODE_":"_%msg)
    .s Err=-2
    i Err'=0 trollback
    q:Err'=0 -2
    d ..SaveAddress(Address,ManfId)
    i ManfAddId'=""  d
    .&sql(Update DHC_Manf_AddionInfo set MANF_ParManf_DR=:ParManfId,MANF_DrugProduct_Permit=:DrugPermit,
    MANF_DrugProduct_ExpDate=:DrugPermitExp,MANF_MatProduct_Permit=:MatPermit,
    MANF_MatProduct_ExpDate=:MatPermitExp,MANF_ComLic=:ComLic,MANF_ComLicDate=:ComLicDate,
    MANF_Active=:Active where MANF_Rowid=:ManfAddId)
    .i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_Manf_AddionInfo",Name,SQLCODE_":"_%msg)
    ..s Err=-3
    .
    i Err'=0 trollback
    q:Err'=0 -3
    tcommit
    q 0
}

/// Descript:   取厂家地址信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-08
/// Table:PH_Manufacturer
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod GetAddress(rowid As %String) As %Library.String
{
    n (rowid)
    s chl=0
    s ret=""
    f  s chl=$o(^PHMNF(rowid,"Address",chl))  q:chl=""  d
    .s address=^PHMNF(rowid,"Address",chl)
    .i ret=""  d
    ..s ret=address
    .e  d
    ..s ret=ret_address
    .
    q ret
}

/// Descript:   取厂家地址信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-08
/// Table:PH_Manufacturer
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod SaveAddress(add As %String, rowid As %String) As %Library.String
{

 n (add,rowid)
 s linenum=$l(add,$c(13,10))
 k ^PHMNF(rowid,"Address")
 s ^PHMNF(rowid,"Address",0)=linenum 
 f i=1:1:linenum d
 .s ^PHMNF(rowid,"Address",i)=$p(add,$c(13,10),i) 
 .
 q
}

/// 获取修改前厂商信息
ClassMethod GetManfHisInfo(ManfId) As %String
{
	n (ManfId)
	s (manfcode,manfname,manftel,manfaddress,DrugProductP,DrugProductE,MatProductP,MatProductE,Type,ComLic,ComLicDate,ParManf)=""
	s manfcode=$p(^PHMNF(ManfId),"^",1)
	s manfname=$p(^PHMNF(ManfId),"^",2)
	s manftel=$p(^PHMNF(ManfId),"^",3)
	s manfaddress=..GetAddress(ManfId)
	
	s ManfAddId=$o(^DHCMANF(0,"MANF",ManfId,""))
	i ManfAddId'=""  d
    .s ParManfId=$p(^DHCMANF(ManfAddId),"^",2)
    .s DrugProductP=$p(^DHCMANF(ManfAddId),"^",3)
    .s DrugProductE=$p(^DHCMANF(ManfAddId),"^",4)
    .;s:DrugProductE'="" DrugProductE=$zd(DrugProductE,3)
    .s MatProductP=$p(^DHCMANF(ManfAddId),"^",5)
    .s MatProductE=$p(^DHCMANF(ManfAddId),"^",6)
    .;s:MatProductE'="" MatProductE=$zd(MatProductE,3)
    .s Type=$p(^DHCMANF(ManfAddId),"^",7)
    .s ComLic=$p(^DHCMANF(ManfAddId),"^",8)
    .s ComLicDate=$p(^DHCMANF(ManfAddId),"^",9)
    .;s:ComLicDate'="" ComLicDate=$zd(ComLicDate,3)
    .s:$g(ParManfId)'="" ParManf=$p(^PHMNF(ParManfId),"^",2)
    s hisinfostr=manfcode_"^"_manfname_"^"_manftel_"^"_manfaddress_"^"_DrugProductP_"^"_DrugProductE_"^"_MatProductP_"^"_MatProductE_"^"_ComLic_"^"_ComLicDate_"^"_ParManfId
    q hisinfostr
}

/// 获取历史厂商的截止日期
ClassMethod GetHisEndDate(ManfId) As %String
{
	s enddate=54422         //默认1990年
	s stdate=$o(^DHCMANFH(0,"SDManf",ManfId,""),-1)
	i stdate'="" d
	.s hismanfid=$o(^DHCMANFH(0,"SDManf",ManfId,stdate,""))
	.s enddate=$p(^DHCMANFH(hismanfid),"^",3)+1
	i enddate>+$h s enddate=+$h
	q enddate
}

/// w ##class(web.DHCST.ItmManf).QueryManfHis(0,99,671)
ClassMethod QueryManfHis(Start, Limit, ManfId) As %String
{
	s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    s stdate=""
    f  s stdate=$o(^DHCMANFH(0,"SDManf",ManfId,stdate)) q:stdate=""  d
    .s hisid=""
    .f  s hisid=$o(^DHCMANFH(0,"SDManf",ManfId,stdate,hisid)) q:hisid=""  d
    ..s manfstdate=$p(^DHCMANFH(hisid),"^",2)
    ..i manfstdate'="" s manfstdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(manfstdate,"ST")
    ..s manfenddate=$p(^DHCMANFH(hisid),"^",3)
    ..i manfenddate'="" s manfenddate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(manfenddate,"ST")
    ..s manfcode=$p(^DHCMANFH(hisid),"^",4)
    ..s manfdesc=$p(^DHCMANFH(hisid),"^",5)
    ..s manftel=$p(^DHCMANFH(hisid),"^",6)
    ..s manfaddress=$p(^DHCMANFH(hisid),"^",7)
    ..s manfDrugProductP=$p(^DHCMANFH(hisid),"^",8)
    ..s manfDrugProductE=$p(^DHCMANFH(hisid),"^",9)
    ..i manfDrugProductE'="" s manfDrugProductE=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(manfDrugProductE,"ST")
    ..s manfMatProductP=$p(^DHCMANFH(hisid),"^",10)
    ..s manfMatProductE=$p(^DHCMANFH(hisid),"^",11)
    ..i manfMatProductE'="" s manfMatProductE=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(manfMatProductE,"ST")
    ..s manfComLic=$p(^DHCMANFH(hisid),"^",12)
    ..s manfComLicDate=$p(^DHCMANFH(hisid),"^",13)
    ..i manfComLicDate'="" s manfComLicDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(manfComLicDate,"ST")
    ..s ParManf=""
    ..s ParManfId=$p(^DHCMANFH(hisid),"^",19)
    ..i ParManfId'="" s ParManf=$p(^PHMNF(ParManfId),"^",2)
    ..s Data=hisid_"^"_manfcode_"^"_manfdesc_"^"_manfaddress_"^"_manftel_"^"_ParManf_"^"_manfDrugProductP_"^"_manfDrugProductE_"^"_manfMatProductP_"^"_manfMatProductE_"^"_manfComLic_"^"_manfComLicDate_"^"_manfstdate_"^"_manfenddate
    ..s count = count+1
	..i (count>Start)&(count<=end) d
	...d json.InsertRowData(Data)
	s Title="ManfHisId^ManfHisCode^ManfHisDesc^ManfHisAddress^ManfHisTel^ManfHisPar^ManfHisDProductP^ManfHisDProductE^ManfHisMProductP^ManfHisMProductE^ManfHisComLic^ManfHisComLicDate^ManfHisStDate^ManfHisEdDate"
	if count>0 d
    .s resultString = json.getJsonData(Title,count)
    k json
    q resultString
}

ClassMethod GetManfHis(hisid)
{
    s manfstdate=$p(^DHCMANFH(hisid),"^",2)
    i manfstdate'="" s manfstdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(manfstdate,"ST")
    s manfenddate=$p(^DHCMANFH(hisid),"^",3)
    i manfenddate'="" s manfenddate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(manfenddate,"St")
    s manfcode=$p(^DHCMANFH(hisid),"^",4)
    s manfdesc=$p(^DHCMANFH(hisid),"^",5)
    s manftel=$p(^DHCMANFH(hisid),"^",6)
    s manfaddress=$p(^DHCMANFH(hisid),"^",7)
    s manfDrugProductP=$p(^DHCMANFH(hisid),"^",8)
    s manfDrugProductE=$p(^DHCMANFH(hisid),"^",9)
    i manfDrugProductE'="" s manfDrugProductE=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(manfDrugProductE,"ST")
    s manfMatProductP=$p(^DHCMANFH(hisid),"^",10)
    s manfMatProductE=$p(^DHCMANFH(hisid),"^",11)
    i manfMatProductE'="" s manfMatProductE=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(manfMatProductE,"ST")
    s manfComLic=$p(^DHCMANFH(hisid),"^",12)
    s manfComLicDate=$p(^DHCMANFH(hisid),"^",13)
    i manfComLicDate'="" s manfComLicDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(manfComLicDate,"ST")
    s ParManf=""
    s ParManfId=$p(^DHCMANFH(hisid),"^",19)
    i ParManfId'="" s ParManf=$p(^PHMNF(ParManfId),"^",2)
    s Data=manfcode_"^"_manfdesc_"^"_manfaddress_"^"_manftel_"^"_ParManfId_"^"_ParManf_"^"_manfDrugProductP_"^"_manfDrugProductE_"^"_manfMatProductP_"^"_manfMatProductE_"^"_manfComLic_"^"_manfComLicDate_"^"_manfstdate_"^"_manfenddate

    q Data
}

/// 更新厂商历史信息
/// w ##class(web.DHCST.ItmManf).updateManfHis("28^李高^李高^1^^^^^^^^^24/10/2016^26/10/2016")
ClassMethod updateManfHis(listData As %String) As %Library.String
{
    n (listData)
    //s ^yunhaibao($this)=listData
    ;不能为空项
    q:listData="" ""
    s ManfId=$p(listData,"^",1)
    q:ManfId="" ""
    s Code=$p(listData,"^",2)
    s Name=$p(listData,"^",3)
    s Address=$p(listData,"^",4)
    s Tel=$p(listData,"^",5)
    s ParManfId=$p(listData,"^",6)
    s DrugPermit=$p(listData,"^",7)
    s DrugPermitExp=$p(listData,"^",8)
    s:DrugPermitExp'="" DrugPermitExp=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(DrugPermitExp)
    s MatPermit=$p(listData,"^",9)
    s MatPermitExp=$p(listData,"^",10)
    s:MatPermitExp'="" MatPermitExp=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(MatPermitExp)
    s ComLic=$p(listData,"^",11)
    s ComLicDate=$p(listData,"^",12)
    s:ComLicDate'="" ComLicDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ComLicDate)
    s StartDate=$p(listData,"^",13)
    s:StartDate'="" StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    s EndDate=$p(listData,"^",14)
    s:EndDate'="" EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    s ManfDr=$p(^DHCMANFH(ManfId),"^",1)
    s lastenddate=""
    s lasthisid=""
    S stdate=$o(^DHCMANFH(0,"SDManf",ManfDr,StartDate),-1)
    i stdate'="" d
    .s lasthisid=$o(^DHCMANFH(0,"SDManf",ManfDr,stdate,""),-1)
    .i lasthisid'="" d
    ..s lastenddate=StartDate-1
    
    s nextdate=""
    s nexthisid=""
    S stdate=$o(^DHCMANFH(0,"SDManf",ManfDr,StartDate))
    i stdate'="" d
    .s nexthisid=$o(^DHCMANFH(0,"SDManf",ManfDr,stdate,""))
    .i nexthisid'="" d
    ..s nextdate=EndDate+1
    
    s Err=0
    tstart
    s $ZT="Error^DHCSTERROR"
    &sql(update DHC_Manf_History set MANFH_Code=:Code,MANFH_Name=:Name,MANFH_Tel=:Tel,MANFH_Address=:Address,MANFH_DrugProduct_Permit=:DrugPermit,MANFH_DrugProduct_ExpDate=:DrugPermitExp,
    MANFH_MatProduct_Permit=:MatPermit,MANFH_MatProduct_ExpDate=:MatPermitExp,MANFH_ComLic=:ComLic,MANFH_ComLicDate=:ComLicDate,MANFH_ParMANF_Dr=:ParManfId,MANFH_StartDate=:StartDate,MANFH_EndDate=:EndDate where MANFH_RowId=:ManfId)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_Manf_History",Name,SQLCODE_":"_%msg)
    .s Err=-1
    i Err'=0 trollback
    q:Err'=0 -1
    i lasthisid'="" d
    .&sql(update DHC_Manf_History set MANFH_EndDate=:lastenddate where MANFH_RowId=:lasthisid)   ;更新上一个历史厂商的截止日期
    .i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_Manf_History",Name,SQLCODE_":"_%msg)
    ..s Err=-2
    i Err'=0 trollback
    q:Err'=0 -2
    i nexthisid'="" d
    .&sql(update DHC_Manf_History set MANFH_StartDate=:nextdate where MANFH_RowId=:nexthisid)   ;更新上一个历史厂商的截止日期
    .i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_Manf_History",Name,SQLCODE_":"_%msg)
    ..s Err=-3
    i Err'=0 trollback
    q:Err'=0 -3
    tcommit
    q 0
}

/// 插入新的厂家前检查判断是否允许插入
/// w ##class(web.DHCST.ItmManf).CheckManfBeforeInsert("AM00032^11111")
ClassMethod CheckManfBeforeInsert(listData, hosp)
{
	n (listData,hosp)
	s Code=$p(listData,"^",1)
    q:Code="" "-1^"_"厂家代码不能为空!"  
    s Name=$p(listData,"^",2)
    q:Name="" "-1^"_"厂家名称不能为空!" 
    s ret=..CheckManfCode(Code,"",hosp)
    q:+ret<0 "-2^"_$p(ret,"^",2)
    q:+ret>0 "1^"_ret
    s ret=..CheckManfName(Name,"",hosp)
    q:+ret<0 "-2^"_$p(ret,"^",2)
    q:+ret>0 "1^"_ret
    s ret="0^没有重复代码和名称"
    q ret
}

ClassMethod CheckManfCode(Code, ManfID = "", Hosp = "")
{
	n (Code,ManfID,Hosp)
	s Code=$$ALPHAUP^SSUTIL4(Code)
	s sqlStr="SELECT PHMNF_RowId AS rowID FROM PH_Manufacturer WHERE PHMNF_Code='"_Code_"'"
	s ManfDr=##class(PHA.COM.Method).IsSQLDataExist(sqlStr,"PH_Manufacturer",Hosp)
	q:ManfDr="" 0
	q:ManfID=ManfDr 0
	s Type=..sssCode()
	s manfType=""
	s sqlStr=""
	&sql(select MANF_Rowid,MANF_Type into :rowid,:manfType from DHC_Manf_AddionInfo where MANF_Rowid=:ManfDr)
	q:rowid="" 0
	q:manfType="O" -1_"^"_rowid
 	q:manfType=Type -1_"^"_rowid
 	q rowid
}

ClassMethod CheckManfName(Name, ManfID = "", Hosp = "")
{
	n (Name,ManfID,Hosp)
	s Name=$$ALPHAUP^SSUTIL4(Name)
	s sqlStr="SELECT PHMNF_RowId AS rowID FROM PH_Manufacturer WHERE PHMNF_Name='"_Name_"'"
	s ManfDr=##class(PHA.COM.Method).IsSQLDataExist(sqlStr,"PH_Manufacturer",Hosp)
	q:ManfDr="" 0
	q:ManfID=ManfDr 0
	s Type=..sssCode()
	s manfType=""
	&sql(select MANF_Rowid,MANF_Type into :rowid,:manfType from DHC_Manf_AddionInfo where MANF_Rowid=:ManfDr)
	q:rowid="" 0
	q:manfType="O" -1_"^"_rowid
 	q:manfType=Type -1_"^"_rowid
 	q rowid
}

/// 更新通用类型
ClassMethod UpdateUniversal(rowid, updflag)
{
	n (rowid,updflag)
	s Err=0,Active="Y",Type="G"
	s:updflag=1 Type="O"
	TStart
    &sql(Update DHC_Manf_AddionInfo set MANF_Active=:Active,MANF_Type=:Type where MANF_Rowid=:rowid)
    .i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_Manf_AddionInfo",rowid,SQLCODE_":"_%msg)
    ..s Err=-3
    i Err'=0 trollback
    q:Err'=0 -3
    TCommit
	q Err
}

/// 插入新的厂家前检查判断是否允许插入
/// w ##class(web.DHCST.ItmManf).CheckManfBeforeUpdate("AM00032^11111")
ClassMethod CheckManfBeforeUpdate(listData, hosp)
{
	n (listData,hosp)
	s ManfID=$p(listData,"^",1)
	s Code=$p(listData,"^",2)
    q:Code="" "-1^"_"厂家代码不能为空!"  
    s Name=$p(listData,"^",3)
    q:Name="" "-1^"_"厂家名称不能为空!" 
    s ret=..CheckManfCode(Code,ManfID,hosp)
    q:+ret<0 "-2^"_$p(ret,"^",2)
    q:+ret>0 "1^"_ret
    s ret=..CheckManfName(Name,ManfID,hosp)
    q:+ret<0 "-2^"_$p(ret,"^",2)
    q:+ret>0 "1^"_ret
    s ret="0^没有重复代码和名称"
    q ret
}

/// 更新厂商记录
ClassMethod UpdateManf(listData, rowid, updflag = "", histype = "")
{
	n (listData,rowid,updflag,histype)
	s ManfID=$p(listData,"^",1)
    q:ManfID="" "-1^"_"厂商ID不能为空!"  
    s Code=$p(listData,"^",2)
    q:Code="" "-1^"_"厂商代码不能为空!"  
    s Name=$p(listData,"^",3)
    q:Name="" "-1^"_"厂商名称不能为空!"
    s Err=0,Active="Y",Type="G"
	s:updflag=1 Type="O"
	i histype'=""  d
	.s manfhisinfo=..GetManfHisInfo(ManfID)     ;取原厂商信息
    .s hismanfcode=$p(manfhisinfo,"^",1)
    .s hismanfdesc=$p(manfhisinfo,"^",2)
    .s hismanftel=$p(manfhisinfo,"^",3)
    .s hismanfaddress=$p(manfhisinfo,"^",4)
    .s hismanfDrugPermit=$p(manfhisinfo,"^",5)
    .s hismanfDrugPermitExp=$p(manfhisinfo,"^",6)
    .s hismanfMatPermit=$p(manfhisinfo,"^",7)
    .s hismanfMatPermitExp=$p(manfhisinfo,"^",8)
    .s hismanfComLic=$p(manfhisinfo,"^",9)
    .s hismanfComLicDate=$p(manfhisinfo,"^",10)
    .s hismanParId=$p(manfhisinfo,"^",11)
    .s hisstartdate=..GetHisEndDate(ManfID)
    .s hisenddate=+$h-1
    .i hisstartdate>hisenddate s hisenddate=hisstartdate
    .s oldmanfid=$p(^DHCMANF(rowid),"^",1)
    .s oldmanfhisinfo=..GetManfHisInfo(oldmanfid)     ;取原厂商信息
    .s oldhismanfcode=$p(oldmanfhisinfo,"^",1)
    .s oldhismanfdesc=$p(oldmanfhisinfo,"^",2)
    .s oldhismanftel=$p(oldmanfhisinfo,"^",3)
    .s oldhismanfaddress=$p(oldmanfhisinfo,"^",4)
    .s oldhismanfDrugPermit=$p(oldmanfhisinfo,"^",5)
    .s oldhismanfDrugPermitExp=$p(oldmanfhisinfo,"^",6)
    .s oldhismanfMatPermit=$p(oldmanfhisinfo,"^",7)
    .s oldhismanfMatPermitExp=$p(oldmanfhisinfo,"^",8)
    .s oldhismanfComLic=$p(oldmanfhisinfo,"^",9)
    .s oldhismanfComLicDate=$p(oldmanfhisinfo,"^",10)
    .s oldhismanParId=$p(oldmanfhisinfo,"^",11)
    .s oldhisstartdate=..GetHisEndDate(oldmanfid)
    .s oldhisenddate=+$h-1
    .i oldhisstartdate>oldhisenddate s oldhisenddate=oldhisstartdate

	TStart
	s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    i histype'="" d
    .&sql(Insert into DHC_Manf_History(MANFH_Phmnf_Dr,MANFH_StartDate,MANFH_EndDate,MANFH_Code,MANFH_Name,MANFH_Tel,MANFH_Address,MANFH_DrugProduct_Permit,MANFH_DrugProduct_ExpDate,
    MANFH_MatProduct_Permit,MANFH_MatProduct_ExpDate,MANFH_ComLic,MANFH_ComLicDate,MANFH_ParMANF_Dr)
    values(:ManfID,:hisstartdate,:hisenddate,:hismanfcode,:hismanfdesc,:hismanftel,:hismanfaddress,:hismanfDrugPermit,:hismanfDrugPermitExp,:hismanfMatPermit,:hismanfMatPermitExp,:hismanfComLic,:hismanfComLicDate,:hismanParId))
    .i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Save:DHC_Manf_History",hismanfdesc,SQLCODE_":"_%msg)
    ..s Err=-4
    .i Err'=0 trollback
    .q:Err'=0
    .&sql(Insert into DHC_Manf_History(MANFH_Phmnf_Dr,MANFH_StartDate,MANFH_EndDate,MANFH_Code,MANFH_Name,MANFH_Tel,MANFH_Address,MANFH_DrugProduct_Permit,MANFH_DrugProduct_ExpDate,
    MANFH_MatProduct_Permit,MANFH_MatProduct_ExpDate,MANFH_ComLic,MANFH_ComLicDate,MANFH_ParMANF_Dr)
    values(:oldmanfid,:oldhisstartdate,:oldhisenddate,:oldhismanfcode,:oldhismanfdesc,:oldhismanftel,:oldhismanfaddress,:oldhismanfDrugPermit,:oldhismanfDrugPermitExp,:oldhismanfMatPermit,:oldhismanfMatPermitExp,:oldhismanfComLic,:oldhismanfComLicDate,:oldhismanParId))
    .i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Save:DHC_Manf_History",oldhismanfdesc,SQLCODE_":"_%msg)
    ..s Err=-4
    .i Err'=0 trollback
    q:Err'=0 -1_"^"_"插入修改记录历史信息失败!"
	s manfinfodr=""
	&sql(select MANF_Rowid into :manfinfodr from DHC_Manf_AddionInfo where MANF_Rowid=:ManfID)
	i manfinfodr'=""  d
	.&sql(Update DHC_Manf_AddionInfo set MANF_Active="N" where MANF_Rowid=:manfinfodr)
    .i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_Manf_AddionInfo",manfinfodr,SQLCODE_":"_%msg)
    ..s Err=-3
    .i Err'=0 trollback
    q:Err'=0 -1_"^"_"作废本次修改记录失败!"
    &sql(Update DHC_Manf_AddionInfo set MANF_Active=:Active,MANF_Type=:Type where MANF_Rowid=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_Manf_AddionInfo",rowid,SQLCODE_":"_%msg)
    .s Err=-3
    i Err'=0 trollback
    q:Err'=0 -1_"^"_"更新原有记录通用类型失败!"
    TCommit	
    q 0_"^"_"更新成功"
}

}
