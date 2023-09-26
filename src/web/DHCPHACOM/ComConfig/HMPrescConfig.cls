Import sqluser

/// creator:	 DingHongying
/// createdate:	 2018-11-20
/// description: 草药处方配置
Class web.DHCPHACOM.ComConfig.HMPrescConfig Extends %RegisteredObject [ ProcedureBlock ]
{

/// description: 草药处方配置列表
/// others:		
/// input:	
/// d ##class(%ResultSet).RunQuery("web.DHCPHACOM.ComConfig.HMPrescConfig","Config")
Query Config(inputStr = "") As websys.Query(ROWSPEC = "rowId,ctlocDr,ctloc,presFormDr,presForm,presChkFlag,presChkSelDr,presChkSel,patRepFlag,printPresFlag,printLabSelectDr,printLabSelect,callFlag,screenFlag,allSendFlag,agreeRetFlag,printDispSheet")
{
}

ClassMethod ConfigExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PivaLocId=$p(inputStr,"^",1)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT PHCF_RowID as rowId,"
    		  		 _"PHCF_Ctloc_Dr as ctlocDr,"
    		  		 _"PHCF_PresType_Dr as presTypeDr,"
    		  		 _"PHCF_PresChkFlag as presChkFlag,"
    		  		 _"PHCF_PresChkSel as presChkSel,"
    		  		 _"PHCF_PatRepFlag as patRepFlag,"
    		  		 _"PHCF_PrintPresFlag as printPresFlag,"
    		  		 _"PHCF_PrintLabSelect as printLabSelect,"
    		  		 _"PHCF_CallFlag as callFlag,"
    		  		 _"PHCF_ScreenFlag as screenFlag,"
    		  		 _"PHCF_PresAllSendFlag as allSendFlag,"
    		  		 _"PHCF_PresAgreeRetFlag as agreeRetFlag,"
    		  		 _"PHCF_PrintDispSheet as printDispSheet "
    		  		 _"FROM PHAHERB_Config"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s rowId= result.Data("rowId") 
	    continue:rowId=0
	    s ctlocDr= result.Data("ctlocDr") 
	    s ctloc=$p(^CTLOC(ctlocDr),"^",2)
		s hospId=+$p($g(^CTLOC(+ctlocDr)),"^",22)
		s hospDr="HospDr_"_hospId
	    s presFormDr= result.Data("presTypeDr")
	    s presForm=$p($g(^DHCDocConfig(hospDr,"CMPrescTypeList",presFormDr)),"^")
	    s presChkFlag= result.Data("presChkFlag")
	    s presChkSelDr= result.Data("presChkSel") 
	    i presChkSelDr=1 s presChkSel="先收费后审方"
	    e  i presChkSelDr=2 s presChkSel="先审方后收费"
	    e  s presChkSel=""
	    s patRepFlag= result.Data("patRepFlag")
	    s printPresFlag= result.Data("printPresFlag")
	    s printLabSelectDr= result.Data("printLabSelect") 
	    i printLabSelectDr=0  s printLabSelect="不打印标签"
	    e  i printLabSelectDr=1 s printLabSelect="调配完成后打印标签"
	    e  i printLabSelectDr=2 s printLabSelect="单独打印标签"
	    e  s printLabSelect=""
	    s callFlag= result.Data("callFlag")
	    s screenFlag= result.Data("screenFlag")
	    s allSendFlag=result.Data("allSendFlag")
	    s agreeRetFlag=result.Data("agreeRetFlag")
	    s printDispSheet=result.Data("printDispSheet")
        d outputConfig
    }
    d result.Close()
	Quit $$$OK
outputConfig
	s Data=$lb(rowId,ctlocDr,ctloc,presFormDr,presForm,presChkFlag,presChkSelDr,presChkSel,patRepFlag,printPresFlag,printLabSelectDr,printLabSelect,callFlag,screenFlag,allSendFlag,agreeRetFlag,printDispSheet)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// description: 保存移动药房配置
/// input:		 inputStr^1:id,inputStr^2:药房科室,inputStr^3:配方类型
/// return:		 +ret=0 成功
/// w ##class(web.PHA.HERB.Config).SaveConfig("1^XY^西药^Y")
ClassMethod SaveConfig(inputStr)
{
	s rowId=$p(inputStr,"^",1)
	s ctlocDr=$p(inputStr,"^",2)
	s presTypeDr=$p(inputStr,"^",3)
	s presChkFlag=$p(inputStr,"^",4)
	s presChkSelDr=$p(inputStr,"^",5)
	s patRepFlag=$p(inputStr,"^",6)
	s printPresFlag=$p(inputStr,"^",7)
	s printLabSelectDr=$p(inputStr,"^",8)
	s callFlag=$p(inputStr,"^",9)
	s screenFlag=$p(inputStr,"^",10)
	s allSendFlag=$p(inputStr,"^",11)
	s agreeRetFlag=$p(inputStr,"^",12)
	s printDispSheet=$p(inputStr,"^",13)
  	q:ctlocDr="" "-1^药房不能为空"
  	q:presTypeDr="" "-1^处方剂型不能为空"
  	s errCode=""
  	i rowId="" d
  	.&SQL(SELECT PHCF_RowID FROM PHAHERB_Config WHERE PHCF_Ctloc_Dr=:ctlocDr and PHCF_PresType_Dr=:presTypeDr)
  	.i SQLCODE=0 s errCode="-1^该药房科室的此处方剂型已存在"
  	.q:errCode'=""
  	e  d 
  	.&SQL(SELECT PHCF_RowID FROM PHAHERB_Config WHERE PHCF_Ctloc_Dr=:ctlocDr and PHCF_PresType_Dr=:presTypeDr and PHCF_RowID!=:rowId)
  	.i SQLCODE=0 s errCode="-1^该药房科室的此处方剂型已存在"
  	.q:errCode'=""
  	q:errCode'="" errCode
  	i rowId=""  d
  	.&sql(
  		insert into PHAHERB_Config 
  		(PHCF_Ctloc_Dr,PHCF_PresType_Dr,PHCF_PresChkFlag,PHCF_PresChkSel,PHCF_PatRepFlag,PHCF_PrintPresFlag,
  		PHCF_PrintLabSelect,PHCF_CallFlag,PHCF_ScreenFlag,PHCF_PresAllSendFlag,PHCF_PresAgreeRetFlag,PHCF_PrintDispSheet) 
  		values 
  		(:ctlocDr,:presTypeDr,:presChkFlag,:presChkSelDr,:patRepFlag,:printPresFlag,
  		:printLabSelectDr,:callFlag,:screenFlag,:allSendFlag,:agreeRetFlag,:printDispSheet)
  	  )
  	.i SQLCODE'=0 s errCode="-1^增加失败"
  	e   d
	.&sql(
		update PHAHERB_Config 
		set PHCF_Ctloc_Dr=:ctlocDr,PHCF_PresType_Dr=:presTypeDr ,PHCF_PresChkFlag=:presChkFlag,
		PHCF_PresChkSel=:presChkSelDr,PHCF_PatRepFlag=:patRepFlag,PHCF_PrintPresFlag=:printPresFlag,
		PHCF_PrintLabSelect=:printLabSelectDr,PHCF_CallFlag=:callFlag,PHCF_ScreenFlag=:screenFlag,
		PHCF_PresAllSendFlag=:allSendFlag,PHCF_PresAgreeRetFlag=:agreeRetFlag,PHCF_PrintDispSheet=:printDispSheet 
		where PHCF_RowID=:rowId  
	 )
	.i SQLCODE'=0 s errCode="-1^修改失败"
	q:errCode'="" errCode
	q 0_"^保存成功"
}

/// description: 删除移动药房配置
/// w ##class(web.PHA.HERB.Config).DeleteConfig("2")
ClassMethod DeleteConfig(Id)
{
	q:Id="" "-1^Id为空"
	&sql(delete from PHAHERB_Config where PHCF_Rowid=:Id)
	q SQLCODE
}

/// description: 批量保存
ClassMethod Save(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SaveConfig(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

}
