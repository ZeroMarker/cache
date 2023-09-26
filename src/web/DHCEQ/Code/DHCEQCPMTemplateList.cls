Class web.DHCEQ.Code.DHCEQCPMTemplateList Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// write by HHM HHM0032 
/// PM模板明细维护
ClassMethod SaveData(val, isDel)
{
 	k PLIST,rowid
 	s rowid=$p(val,"^",1)
 	i (+isDel=1)
 	{
 		//删除操作.
 		&SQL(Delete From SQLUSER.DHC_EQCPMTemplateList where PMTL_RowID = :rowid) 
 		i SQLCODE  q SQLCODE
 		q rowid
 	}
 	
 	s PLIST(2)=$p(val,"^",2)  ;PMTL_TemplateDR
 	s PLIST(3)=$p(val,"^",3)  ;PMTL_MaintItemDR
 	s PLIST(4)=$p(val,"^",4)  ;note
 	s PLIST(5)=$p(val,"^",5)  ;sort
 	s PLIST(6)=$p(val,"^",6)  ;defaultval
 	
 	s TemplateDR=$p(val,"^",2)
 	s Sort=$p(val,"^",5)
 	s tmpid=0
	&SQL(select PMTL_RowID into :tmpid from SQLUSER.DHC_EQCPMTemplateList where PMTL_TemplateDR=:TemplateDR And PMTL_Sort=:Sort)
	i ((tmpid'="")&(tmpid'=rowid)) q -3001 //数据已存在 
	i rowid=""
	{
		&SQL(insert into sqluser.DHC_EQCPMTemplateList Values :PLIST())
	}
	else
	{
		&SQL(update sqluser.DHC_EQCPMTemplateList Values :PLIST() where PMTL_RowID = :rowid)
	}
 	if SQLCODE  q SQLCODE
 	s ID=$g(%ROWID)
 	q ID
}

/// MZY0076	2021-05-25	增加输出项TItemCode
/// modified by csj 2020-02-17 添加维护类型参数：Type 需求号：1191838
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.Code.DHCEQCPMTemplateList","PMTemplateList","")
Query PMTemplateList(TemplateDR, Type As %String = "") As %Query(ROWSPEC = "TRowID:%String,TType:%String,TName:%String,TCaption:%String,TItem:%String,TItemCat:%String,TNote:%String,TSort:%String,TDefaultVal:%String,TMaintItemDR:%String,TItemCode:%String")
{
}

ClassMethod PMTemplateListExecute(ByRef qHandle As %Binary, TemplateDR, Type As %String = "") As %Status
{
	n repid, index,rowid
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
	s index=1
	
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCPMTemplateList",rowid)) q:rowid=""  d
	.d ResetVariablesPMTemplateList
	.s TTemplateDR=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",rowid)),"^",1)
	.q:TTemplateDR=""
	.q:TTemplateDR'=TemplateDR  //过滤
	.s TRowID=rowid
	.s TPMInvalidFlag=$p($g(^DHCEQCCode("DHCEQCPMTemplate",TTemplateDR)),"^",11)
	.q:TPMInvalidFlag="Y"
	.s TType=$p($g(^DHCEQCCode("DHCEQCPMTemplate",TTemplateDR)),"^",1)
	.q:(Type'="")&&(Type'=TType)	//add by csj 2020-02-17 需求号：1191838
	.s TType=$Case(TType,"":"","1":"保养","2":"检查","3":"维修")
	.s TName=$p($g(^DHCEQCCode("DHCEQCPMTemplate",TTemplateDR)),"^",2)
	.s TCaption=$p($g(^DHCEQCCode("DHCEQCPMTemplate",TTemplateDR)),"^",3)
	.s TMaintItemDR=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",rowid)),"^",2)
	.s (TMIInvalidFlag,TMICInvalidFlag)=""
	.i TMaintItemDR'=""  d
	..s TMIInvalidFlag=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",4)
	..q:TMIInvalidFlag="Y"
	..s TItemCode=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",1)
	..s TItem=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",2)
	..s ItemCatDR=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",7)
	..i ItemCatDR'="" d
	...s TMICInvalidFlag=$p($g(^DHCEQCCode("DHCEQCMaintItemCat",ItemCatDR)),"^",5)
	...q:TMICInvalidFlag="Y"
	...s TItemCat=$p($g(^DHCEQCCode("DHCEQCMaintItemCat",ItemCatDR)),"^",3)
	.q:(TMIInvalidFlag="Y")||(TMICInvalidFlag="Y")	//add by csj 2020-03-28 组内需求：1247424
	.s TNote=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",rowid)),"^",3)
	.s TSort=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",rowid)),"^",4)
	.s TDefaultVal=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",rowid)),"^",5)
	.d OutputRowPMTemplateList
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

/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.Code.DHCEQCPMTemplateList","GetMaintItem","1")
Query GetMaintItem(Type) As %Query(ROWSPEC = "TRowID:%String,TMICode:%String,TMIDesc:%String,TMICaption:%String,TMICDesc:%String")
{
}

ClassMethod GetMaintItemExecute(ByRef qHandle As %Binary, Type) As %Status
{
	n repid, index,rowid
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
	s index=1 
	
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCMaintItem",rowid)) q:rowid=""  d
	.d ResetVariablesPMTemplateList
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",4)
	.q:InvalidFlag="Y"
	.s TRowID=rowid
	.s TMICode=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",1)
	.s TMIDesc=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",2)
	.s TMIType=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",5)	//add by csj 2020-02-24 需求号：1191838
	.q:(Type'="")&&(Type'=TMIType)	//add by csj 2020-02-24 需求号：1191838
	.s TMICaption=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",6)
	.s ItemCatDR=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",7)
	.i ItemCatDR'="" d
	..s MICInvalidFlag=$p($g(^DHCEQCCode("DHCEQCMaintItemCat",ItemCatDR)),"^",5)
	..q:MICInvalidFlag="Y"
	..s TMICDesc=$p($g(^DHCEQCCode("DHCEQCMaintItemCat",ItemCatDR)),"^",3)
	.e  d
	..s TMICDesc=""
	.d OutputRowGetMaintItem
	quit $$$OK
OutputRowGetMaintItem
	s Data=$lb(TRowID,TMICode,TMIDesc,TMICaption,TMICDesc)
	s ^CacheTemp(repid,index)=Data
	s index=index+1
	quit
ResetVariablesGetMaintItem
	s (TRowID,TMICode,TMIDesc,TMICaption,TMICDesc)=""
	quit
}

ClassMethod GetMaintItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintItemExecute ]
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

ClassMethod GetMaintItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintItemExecute ]
{
	s repid=$LIST(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##Class(web.DHCEQ.Code.DHCEQCPMTemplateList).GetPMTemplateListByID(2)
ClassMethod GetPMTemplateListByID(rowid)
{
	q:rowid=""
	q:rowid=0
	
	s TemplateDR=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",rowid)),"^",1)
	s MaintItemDR=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",rowid)),"^",2)
	s Note=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",rowid)),"^",3)
	s Sort=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",rowid)),"^",4)
	s DefaultVal=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",rowid)),"^",5)

	q:TemplateDR=""
	q:MaintItemDR=""
	
	s PMInvalidFlag=$p($g(^DHCEQCCode("DHCEQCPMTemplate",TemplateDR)),"^",11)
	q:PMInvalidFlag="Y"
	s Type=$p($g(^DHCEQCCode("DHCEQCPMTemplate",TemplateDR)),"^",1)
	s Name=$p($g(^DHCEQCCode("DHCEQCPMTemplate",TemplateDR)),"^",2)
	s Caption=$p($g(^DHCEQCCode("DHCEQCPMTemplate",TemplateDR)),"^",3)
	
	s MIInvalidFlag=$p($g(^DHCEQCCode("DHCEQCMaintItem",MaintItemDR)),"^",4)
	q:MIInvalidFlag="Y"
	s Item=$p($g(^DHCEQCCode("DHCEQCMaintItem",MaintItemDR)),"^",2)
	s ItemCatDR=$p($g(^DHCEQCCode("DHCEQCMaintItem",MaintItemDR)),"^",7)
	i ItemCatDR="" d
	.s ItemCat=""
	e  d	;modified by csj 20190530
	.s MICInvalidFlag=$p($g(^DHCEQCCode("DHCEQCMaintItemCat",ItemCatDR)),"^",5)
	.q:MICInvalidFlag="Y"
	.s ItemCat=$p($g(^DHCEQCCode("DHCEQCMaintItemCat",ItemCatDR)),"^",3)
	
	s result=rowid_"^"_Note_"^"_DefaultVal_"^"_Sort_"^"_TemplateDR_"^"_Type_"^"_Name_"^"_Caption_"^"_MaintItemDR_"^"_Item_"^"_ItemCatDR_"^"_ItemCat
	q result
}

}
