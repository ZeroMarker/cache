Import sqluser

Class web.DHCST.DispUom Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// creator:zhaozhiduan
/// date: 2014-04-23
/// table: 查询 DHC_IncilDispUom
/// input:  科室id,医嘱项id,
/// output: 
/// others:
/// exec: w ##class(web.DHCST.DispUom).GetDispUomInfo("243","4||1")
ClassMethod GetDispUomInfo(Phaloc As %String, Arcitm As %String) As %Library.String
{
	n (Phaloc,Arcitm)
	;s ^zzdt("GetDispUomInfo")=Phaloc_"^"_Arcitm
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT ILDU_RowId AS ilduid,ILDU_DispUom->CTUOM_Desc as Uomdesc,ILDU_DispUom as UomId,ILDU_Active as ActiveFlag,ILDU_DateFrom as SDate,ILDU_DateTo as EDate  FROM DHC_IncilDispUom where ILDU_INCIL_DR->INCIL_CTLOC_DR="_"'"_Phaloc_"'"_" and  ILDU_INCIL_DR->INCIL_INCI_ParRef->INCI_OriginalARCIM_DR="_"'"_Arcitm_"'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    b
    While(result.Next())
    {
    s ilduid = result.Data("ilduid")
    s UomId = result.Data("UomId")
    s Uom = result.Data("Uomdesc")
    
    s ActiveFlag = result.Data("ActiveFlag")
    s SDate = result.Data("SDate")
    s EDate = result.Data("EDate")
    s:SDate'="" SDate=$zd(SDate,2)
    s:EDate'="" EDate=$zd(EDate,2)
    s tmp=ilduid_"^"_UomId_"^"_Uom_"^"_ActiveFlag_"^"_SDate_"^"_EDate
    d json.InsertRowData(tmp)
    s count = count+1
    }
    d result.Close()
    s titil="ilduid^UomId^Uom^ActiveFlag^SDate^EDate"
    s resultString = json.getJsonData(titil,count)
    k json
   
    Q resultString
}

/// creator:zhaozhiduan
/// date:2014-04-23
/// table:  DHC_IncilDispUom
/// input:  科室id,医嘱项id,"科室发药单位id^单位id^激活标志(Y或N)^开始时间^截至时间,。。。"
/// output: 
/// others:
/// exec: w ##class(web.DHCST.DispUom).Save("2","","^176^Y^10/10/2017^","1247)
ClassMethod Save(Phaloc As %String, Arcitm As %String, ListData As %String, IncItmId As %String = "") As %Library.String
{
	n (Phaloc,Arcitm,ListData,IncItmId)
	q:ListData="" 0
	i IncItmId'="" d
	.s inci=IncItmId
	e  d
	.s inci=$s(Arcitm'="":$o(^INCI(0,"ARCIM_DR",$p(Arcitm,"||",1),"")),1:"")
	q:inci="" "-1^库存项Id为空"
	s incCnt=0
	s arcItmId=$p(^INCI(inci,1),"^",3)
	q:arcItmId="" "-1^需关联医嘱项后进行维护"
	i arcItmId'="" d
	.s tmpIncId=""
	.f  s tmpIncId=$o(^INCI(0,"ARCIM_DR",+arcItmId,tmpIncId)) q:tmpIncId=""  d
	..q:+tmpIncId=0
	..s incCnt=incCnt+1
	q:incCnt>1 "-1^该库存项关联的医嘱项还存在其他库存项,不能增加"
	s Incilsub=$o(^INCI("IL_LOC",Phaloc,inci,""))
	i Incilsub="" d
	.&SQL(insert into INC_ItmLoc (INCIL_CTLOC_DR,INCIL_INCI_ParRef) values (:Phaloc,:inci))
	.s Incil=$p(%ROWID,$c(1))
	e  s Incil=inci_"||"_Incilsub
	s len=$l(ListData,",")
	s err=0
	f i=1:1:len q:err'=0  d
	.s datestr=$p(ListData,",",i)
	.s ilduid=$p(datestr,"^",1)
	.s uomId=$p(datestr,"^",2)
	.s chkExist=..CheckExist(ilduid,Incil,uomId)
	.i $p(chkExist,"^",1)<0 s err="-1^该药房此发药单位已维护" q
	.i ilduid="" d
	..s ret=..Insert(Incil,datestr)
	.e  d
	..s ret=..Update(Incil,datestr)
	.i ret<0 s err=ret
	.q:+ret<0
	
	q err
}

/// creator:zhaozhiduan
/// date:2014-04-23
/// table: 删除 DHC_IncilDispUom
/// input: 科室发药单位表的id
/// output: 
/// others:
/// exec: w ##class(web.DHCST.DispUom).DeleteDispUomInfo("2")
ClassMethod DeleteDispUomInfo(ilduid As %String) As %Library.String
{
	n (ilduid)
	q:ilduid="" ""
	q:'$d(^DHCILDU(ilduid)) 0
	s Err=0
	&sql(Delete from DHC_IncilDispUom  where ILDU_RowId=:ilduid) 
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_IncilDispUom",ilduid,SQLCODE_":"_%msg)
    .s Err=-3
    .
    q:Err'=0 -3  
    ;
    q 0
}

/// creator:zhaozhiduan
/// date:2014-04-23
/// table: 插入 DHC_IncilDispUom
/// input:  incil,""^单位id^激活标志(Y或N)^开始时间^截至时间
/// output: 
/// others:
/// exec: w ##class(web.DHCST.DispUom).Insert("4||1","^92^Y^2014-04-23^2014-04-23")
ClassMethod Insert(incil As %String, ListData As %String) As %Library.String
{
	
	n (ListData,incil)
 	q:ListData="" 0
	q:incil="" -12
	s ilduid=$p(ListData,"^",1)
	s uom=$p(ListData,"^",2)
 	s active=$p(ListData,"^",3)
 	s df=$p(ListData,"^",4)
 	s dt=$p(ListData,"^",5)
 	
 	s buom=$p(^INCI(+incil,1),"^",10)
 	q:'$d(^CT("CTCF",0,"UOM",uom,buom)) -15
 	
 	s Err=0
 	i df'="" s df=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(df)
 	i dt'="" s dt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(dt)
 	;i uom'="" s uom=$$CTUOMToID^DHCSTCOMMONSRV(uom)
 	tstart
 	&sql(insert into DHC_IncilDispUom(ILDU_INCIL_DR,ILDU_DispUom,ILDU_Active,ILDU_DateFrom,ILDU_DateTo)
    values (:incil,:uom,:active,:df,:dt)  )
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Save:DHC_IncilDispUom","",SQLCODE_":"_%msg)
 	.s Err=-11
 	.
 	q:Err'=0 Err
 	s ilduid=$p(%ROWID,$c(1))
 	tcommit
 	
 	q ilduid
}

/// creator:zhaozhiduan
/// date:2014-04-23
/// table:	更新 DHC_IncilDispUom
/// input:  incil,科室发药单位id^单位id^激活标志(Y或N)^开始时间^截至时间
/// output: 
/// others:
/// exec: w ##class(web.DHCST.DispUom).Update("4||1","1^92^Y^2014-05-17^2014-05-17")
ClassMethod Update(incil As %String, ListData As %String) As %Library.String
{
	n (incil,ListData)
 	q:ListData="" 0
	q:incil="" -12
	s ilduid=$p(ListData,"^",1)
	s uom=$p(ListData,"^",2)
 	s active=$p(ListData,"^",3)
 	s df=$p(ListData,"^",4)
 	s dt=$p(ListData,"^",5)
 	
 	s buom=$p(^INCI(+incil,1),"^",10)
 	q:'$d(^CT("CTCF",0,"UOM",uom,buom)) -15
 	
 	s Err=0
 	i df'="" s df=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(df)
 	i dt'="" s dt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(dt)
 	tstart
 	&sql(Update DHC_IncilDispUom set ILDU_INCIL_DR=:incil,ILDU_DispUom=:uom,
 	ILDU_Active=:active,ILDU_DateFrom=:df,ILDU_DateTo=:dt where ILDU_Rowid=:ilduid )
 	i SQLCODE'=0  d
 	.s ret=$$ErrorRecord^DHCSTERROR("Update:DHC_IncilDispUom",ilduid,SQLCODE_":"_%msg)
 	.s Err=-11
 	q:Err'=0 Err
 	
 	tcommit
 	q 0
}

/// creator:zhaozhiduan
/// date:2014-04-23
/// description: 库存所在的科室
/// input:  inci
/// output: String "RowId^Description"
/// others:
/// exec: w ##class(web.DHCST.DispUom).GetInciLoc("1273||1","zyyf")
ClassMethod GetInciLoc(Arcitm As %String = "", Input As %String = "") As %Library.String
{
	n (Arcitm,Input)
	s Input=$zcvt(Input,"U")
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT INCIL_CTLOC_DR->CTLOC_ROWID AS RowId, INCIL_CTLOC_DR->CTLOC_DESC AS Description, INCIL_CTLOC_DR->CTLOC_ContactName AS Name FROM INC_ItmLoc where INCIL_INCI_ParRef->INCI_OriginalARCIM_DR="_"'"_Arcitm_"'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
	    s Rowid = result.Data("RowId")
	    continue:Rowid=""
	    s Description = result.Data("Description")
	    s Name = result.Data("Name")
        continue:(Input'="")&&($zcvt(Name,"U")'[Input)&&(Name'[Input)
	    s tmp=Rowid_"^"_Description
	    d json.InsertRowData(tmp)
	    s count = count+1
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
   
    Q resultString
}

/// creator:	yunhaibao
/// createdate: 2017-07-10
/// description:发药单位列表
/// w ##class(%ResultSet).RunQuery("web.DHCST.DispUom","GetDispUomInfo","98","858")
Query GetDispUomInfo(phaLoc As %String, incItmId As %String = "") As websys.Query(ROWSPEC = "ilduId,locId,uomId,uomDesc,active,startDate,endDate")
{
}

ClassMethod GetDispUomInfoExecute(ByRef qHandle As %Binary, phaLoc As %String, incItmId As %String = "") As %Status
{
	n (qHandle,phaLoc,incItmId)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT ILDU_RowId AS ilduId,ILDU_DispUom->CTUOM_Desc as uomDesc,ILDU_DispUom as uomId,"_
    		   "ILDU_Active as activeFlag,ILDU_DateFrom as startDate,ILDU_DateTo as endDate  FROM DHC_IncilDispUom "_
    		   "where ILDU_INCIL_DR->INCIL_CTLOC_DR="_"'"_phaLoc_"'"_
    		   " and  ILDU_INCIL_DR->INCIL_INCI_ParRef="_"'"_incItmId_"'"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s ilduId = result.Data("ilduId")
	    s uomId = result.Data("uomId")
	    s uomDesc=result.Data("uomDesc")
	    s active=result.Data("activeFlag")
	    s startDate=result.Data("startDate")
	    s endDate=result.Data("endDate")
	    i startDate'="" s startDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(startDate,"ST")
	    i endDate'="" s endDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(endDate,"ST")
		s Data=$lb(ilduId,phaLoc,uomId,uomDesc,active,startDate,endDate)
		s ^CacheTemp(repid,ind)=Data    
		s ind=ind+1
    }
    d result.Close()
	Quit $$$OK
}

/// description: 判断发药单位在本药房是否已维护
ClassMethod CheckExist(ILDURowId, Incil, UomId)
{
	n (ILDURowId,Incil,UomId)
	s ret=""
	i ILDURowId="" d
	.&SQL(SELECT * FROM DHC_IncilDispUom WHERE ILDU_INCIL_DR=:Incil AND ILDU_DispUom=:UomId)
	.i SQLCODE=0 s ret="-1^该发药单位已维护"
	e  d
	.&SQL(SELECT * FROM DHC_IncilDispUom WHERE ILDU_INCIL_DR=:Incil AND ILDU_DispUom=:UomId AND ILDU_RowId!=:ILDURowId)
	.i SQLCODE=0 s ret="-1^该发药单位已维护"
	q ret
}

}
