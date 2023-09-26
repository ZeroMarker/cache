Class web.DHCEQ.Plat.CTPMTemplate Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTPMTemplate","PMTemplate","","","","","2021-11-24")
/// Modefied by zc0098 2021-1-29 添加输出TEquipRangeID
Query PMTemplate(Type As %Library.String = "", Name As %Library.String = "", Caption As %Library.String = "", Note As %Library.String = "", FromDate As %Library.String = "", ToDate As %Library.String = "") As %Query(ROWSPEC = "PMTRowID:%String,PMTType:%String,PMTName:%String,PMTCaption:%String,PMTNote:%String,PMTRemark:%String,PMTFromDate:%String,PMTToDate:%String,PMTTypeDesc:%String,TEquipRangeID:%String") [ SqlProc ]
{
}

ClassMethod PMTemplateExecute(ByRef qHandle As %Binary, Type As %Library.String = "", Name As %Library.String = "", Caption As %Library.String = "", Note As %Library.String = "", FromDate As %Library.String = "", ToDate As %Library.String = "") As %Status
{
	n repid, index,rowid
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
 	i FromDate'="" s FromDate=##Class(web.DHCEQCommon).TransValueFromPage(FromDate,"date")
 	i ToDate'="" s ToDate=##Class(web.DHCEQCommon).TransValueFromPage(ToDate,"date")
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCPMTemplate",rowid)) q:rowid=""  d
	.d ResetVariablesPMTemplate
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",11)
	.q:TInvalidFlag="Y"   ;过滤无效字段
	.s TRowID=rowid
	.s TType=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",1)
	.q:(+Type>0)&&(Type'=TType)
	.s TTypeDesc=$CASE(TType,"1":"保养","2":"检查","3":"维修") 
	.s TName=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",2)
	.q:(Name'="")&&(TName'[Name)
	.s TCaption=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",3)
	.q:(Caption'="")&&(TCaption'[Caption)
	.s TNote=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",4)
	.q:(Note'="")&&(TNote'[Note)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",5)
	.s TFromDate=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",6)
	.q:(FromDate'="")&&(FromDate<TFromDate)
	.q:(ToDate'="")&&(ToDate<TFromDate)
	.i TFromDate'="" s TFromDate=##class(web.DHCEQCommon).TransValueToPage(TFromDate,"date")  ;Modified by QW20170302日期格式统一调整
	.s TToDate=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",7)
	.q:(FromDate'="")&&(FromDate>TToDate)
	.q:(ToDate'="")&&(ToDate>TToDate)
	.i TToDate'="" s TToDate=##class(web.DHCEQCommon).TransValueToPage(TToDate,"date")  ;Modified by QW20170302日期格式统一调整
	.i $d(^DHCEQEquipRange(0,"SourceID","3",rowid))  d
	..s TEquipRangeID=$o(^DHCEQEquipRange(0,"SourceID","3",rowid,TEquipRangeID))
	.d OutputRowPMTemplate
	
	quit $$$OK
OutputRowPMTemplate
	s TRow=index
	s Data=$lb(TRowID,TType,TName,TCaption,TNote,TRemark,TFromDate,TToDate,TTypeDesc,TEquipRangeID)  ///Modefied by zc0098 2021-1-29 添加输出TEquipRangeID
	s ^CacheTemp(repid,index)=Data
	s index=index+1
	quit
ResetVariablesPMTemplate
	s (TRowID,TType,TName,TCaption,TNote,TRemark,TFromDate,TToDate,TTypeDesc,TEquipRangeID)=""  ///Modefied by zc0098 2021-1-29 添加输出TEquipRangeID
	quit
}

ClassMethod PMTemplateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PMTemplateExecute ]
{
	s AtEnd=$LIST(qHandle,1)
 	s repid=$LIST(qHandle,2)
 	s ind=$LIST(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 		}
 	else{
 		s Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod PMTemplateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PMTemplateExecute ]
{
	s repid=$LIST(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod SaveData(Data, Type As %String = "")
{
	s $ZT="ERRORPMTemplate"
	k PLIST,RowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCPMTemplate",JsonData,.PLIST)
	s RowID = JsonData.PMTRowID
	TSTART
	if (Type="1")
	{
		&SQL(update sqluser.DHC_EQCPMTemplate set PMT_InvalidFlag="Y" where PMT_RowID=:RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	ELSE
	{
		s PLIST(12)="N"  
		s PMTName=JsonData.PMTName
		s PMTType=JsonData.PMTType
		s TmpID=""
		&SQL(Select PMT_RowID Into :TmpID from SQLUSER.DHC_EQCPMTemplate Where PMT_Type=:PMTType and PMT_Name=:PMTName and PMT_InvalidFlag='N')
		
		i (TmpID'="")&&(TmpID'=RowID) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210")
	    if RowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQCPMTemplate Values :PLIST() where PMT_RowID = :RowID)
		}
		else
		{	
			&SQL(insert into SQLUSER.DHC_EQCPMTemplate Values :PLIST())
		}
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		s RowID=$g(%ROWID)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	
ERRORPMTemplate
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// w ##Class(web.DHCEQ.Plat.CTPMTemplate).GetOneFinaceSubject(1)
ClassMethod GetOnePMTemplate(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOnePMTemplate"
	s ObjPMTemplate=##Class(User.DHCEQCPMTemplate).%OpenId(RowID)
	s PMTemplateInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjFinaceSubject)
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,FinaceSubjectInfo)
ERRORGetOnePMTemplate
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1300",ErrorMsg)
}

/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTPMTemplate","PMTemplateList","")
Query PMTemplateList(TemplateDR, MaintItemDR As %String = "") As %Query(ROWSPEC = "PMTLRowID:%String,TType:%String,TName:%String,TCaption:%String,PMTLMaintItemDR_MIDesc:%String,TItemCat:%String,PMTLNote:%String,PMTLSort:%String,PMTLDefaultVal:%String,PMTLMaintItemDR:%String,TItemCode:%String")
{
}

ClassMethod PMTemplateListExecute(ByRef qHandle As %Binary, TemplateDR, MaintItemDR As %String = "") As %Status
{
	n repid, index,rowid
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
	s index=1
	i TemplateDR="" quit $$$OK
	s vSort=""
	f  s vSort=$o(	^DHCEQCCode("DHCEQCPMTemplateList",0,"PMTLTemplateDR",TemplateDR,vSort)) q:vSort=""  d
	.s rowid=""
	.f  s rowid=$o(	^DHCEQCCode("DHCEQCPMTemplateList",0,"PMTLTemplateDR",TemplateDR,vSort,rowid)) q:rowid=""  d
	..d ResetVariablesPMTemplateList
	..s TTemplateDR=TemplateDR
	..s TRowID=rowid
	..s TType=$p($g(^DHCEQCCode("DHCEQCPMTemplate",TTemplateDR)),"^",1)
	..s TType=$Case(TType,"":"","1":"保养","2":"检查","3":"维修")
	..s TName=$p($g(^DHCEQCCode("DHCEQCPMTemplate",TTemplateDR)),"^",2)
	..s TCaption=$p($g(^DHCEQCCode("DHCEQCPMTemplate",TTemplateDR)),"^",3)
	..s TMaintItemDR=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",rowid)),"^",2)
	..q:(MaintItemDR'="")&&(TMaintItemDR'=MaintItemDR)
	..i TMaintItemDR'=""  d
	...s TItemCode=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",1)
	...s TItem=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",2)
	...s ItemCatDR=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",7)
	...i ItemCatDR'="" d
	....s TItemCat=$p($g(^DHCEQCCode("DHCEQCMaintItemCat",ItemCatDR)),"^",3)
	..s TNote=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",rowid)),"^",3)
	..s TSort=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",rowid)),"^",4)
	..s TDefaultVal=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",rowid)),"^",5)
	..d OutputRowPMTemplateList
	quit $$$OK
OutputRowPMTemplateList
	s Data=$lb(TRowID,TType,TName,TCaption,TItem,TItemCat,TNote,TSort,TDefaultVal,TMaintItemDR,TItemCode)
	s ^CacheTemp(repid,index)=Data
	s index=index+1
	quit
ResetVariablesPMTemplateList
	s (TRowID,TType,TName,TCaption,TItem,TItemCat,TNote,TSort,TDefaultVal,TMaintItemDR,TItemCode)=""
	quit
}

ClassMethod PMTemplateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PMTemplateListExecute ]
{
	s AtEnd=$LIST(qHandle,1)
 	s repid=$LIST(qHandle,2)
 	s ind=$LIST(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 		}
 	else{
 		s Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod PMTemplateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PMTemplateListExecute ]
{
	s repid=$LIST(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// w ##Class(web.DHCEQ.Plat.CTPMTemplate).SavePMTemplateList("{""PMTLMaintItemDR_MIDesc"":""对仪器板件连接接头进行除尘清洁、防止接触不良"",""PMTLNote"":"""",""PMTLDefaultVal"":"""",""PMTLSort"":""7"",""PMTLTemplateDR"":""1"",""PMTLMaintItemDR"":""15"",""PMTLRowID"":""7""}","2")
ClassMethod SavePMTemplateList(Data, Type As %String = "")
{
	s $ZT="ERRORPMTemplateList"
	k PLIST,RowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCPMTemplateList",JsonData,.PLIST)
	s RowID = JsonData.PMTLRowID
	TSTART
	if (Type="1")
	{
		&SQL(Delete From SQLUSER.DHC_EQCPMTemplateList where PMTL_RowID = :RowID) 
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	ELSE
	{
		s PMTLMaintItemDR=JsonData.PMTLMaintItemDR
		s PMTLTemplateDR=JsonData.PMTLTemplateDR
		s TmpID=""
		&SQL(Select PMTL_RowID Into :TmpID from SQLUSER.DHC_EQCPMTemplateList Where PMTL_TemplateDR=:PMTLTemplateDR and PMTL_MaintItemDR=:PMTLMaintItemDR)
		
		i (TmpID'="")&&(TmpID'=RowID) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210")
	    if RowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQCPMTemplateList Values :PLIST() where PMTL_RowID = :RowID)
		}
		else
		{	
			&SQL(insert into SQLUSER.DHC_EQCPMTemplateList Values :PLIST())
		}
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		s RowID=$g(%ROWID)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	
ERRORPMTemplateList
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

}
