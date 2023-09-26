Class web.DHCEQ.Code.DHCEQCPMTemplate Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// write by HHM HHM0032 
/// PM模板维护
ClassMethod SaveData(val, isDel)
{
 	k PLIST,rowid
 	s rowid=$p(val,"^",1)
 	i (+isDel=1)
 	{
 		//删除操作.
 		//&SQL(Delete From SQLUSER.DHC_EQCPMTemplate where PMT_RowID = :rowid) 
 		&SQL(UPDATE SQLUSER.DHC_EQCPMTemplate SET PMT_InvalidFlag='Y' WHERE PMT_RowID = :rowid)
 		i SQLCODE  q SQLCODE
 		q rowid
 	}
 	
 	s PLIST(2)=$p(val,"^",2)  ///Type
 	s PLIST(3)=$p(val,"^",3)  ///PMName
 	s PLIST(4)=$p(val,"^",4)  ///Caption
 	s PLIST(5)=$p(val,"^",5)  ///Note
 	s PLIST(6)=$p(val,"^",6)  ///Remark
 	//add by lmm 2018-03-15 begin 553289
 	s PLIST(7)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",7),"date")  ///FromDate
 	s PLIST(8)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"date")  ///TomDate
 	//add by lmm 2018-03-15 end 553289
 	s PLIST(9)=$p(val,"^",9)  ///Hold1
 	s PLIST(10)=$p(val,"^",10) ///Hold2
 	s PLIST(11)=$p(val,"^",11) ///Hold3

 	s Type=$p(val,"^",2)  ;Type
 	s Name=$p(val,"^",3)  ;PMName
 	s tmpid=0
	&SQL(select PMT_RowID into :tmpid from SQLUSER.DHC_EQCPMTemplate where PMT_InvalidFlag<>'Y' and PMT_Type=:Type and PMT_Name=:Name)
	i ((tmpid'="")&(tmpid'=rowid)) q -3001 //数据已存在
	i rowid=""
	{
		s PLIST(12)="N"
		&SQL(insert into sqluser.DHC_EQCPMTemplate Values :PLIST())
	}
	else
	{
		&SQL(update sqluser.DHC_EQCPMTemplate Values :PLIST() where PMT_RowID = :rowid)
	}
 	if SQLCODE  q SQLCODE
 	s ID=$g(%ROWID)
 	q ID
}

/// MZY0096	2134951		2021-09-16	增加查询参数:Type,Name,Caption,Note,FromDate,ToDate
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.Code.DHCEQCPMTemplate","PMTemplate","","","","","2021-11-24")
/// Modefied by zc0098 2021-1-29 添加输出TEquipRangeID
Query PMTemplate(Type As %Library.String = "", Name As %Library.String = "", Caption As %Library.String = "", Note As %Library.String = "", FromDate As %Library.String = "", ToDate As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TType:%String,TName:%String,TCaption:%String,TNote:%String,TRemark:%String,TFromDate:%String,TToDate:%String,THold1:%String,THold2:%String,THold3:%String,TInvalidFlag:%String,TRow:%String,TEquipRangeID:%String") [ SqlProc ]
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
	.s TType=$CASE(TType,"1":"保养","2":"检查","3":"维修") 
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
	.s THold1=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",8)
	.s THold2=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",9)
	.s THold3=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",10)
	.;Modefied by zc0098 2021-1-29 添加输出TEquipRangeID begin
	.i $d(^DHCEQEquipRange(0,"SourceID","3",rowid))  d
	..s TEquipRangeID=$o(^DHCEQEquipRange(0,"SourceID","3",rowid,TEquipRangeID))
	.;Modefied by zc0098 2021-1-29 添加输出TEquipRangeID end 
	.d OutputRowPMTemplate
	
	quit $$$OK
OutputRowPMTemplate
	s TRow=index
	s Data=$lb(TRowID,TType,TName,TCaption,TNote,TRemark,TFromDate,TToDate,THold1,THold2,THold3,TInvalidFlag,TRow,TEquipRangeID)  ///Modefied by zc0098 2021-1-29 添加输出TEquipRangeID
	s ^CacheTemp(repid,index)=Data
	s index=index+1
	quit
ResetVariablesPMTemplate
	s (TRowID,TType,TName,TCaption,TNote,TRemark,TFromDate,TToDate,THold1,THold2,THold3,TInvalidFlag,TRow,TEquipRangeID)=""  ///Modefied by zc0098 2021-1-29 添加输出TEquipRangeID
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

/// w ##Class(web.DHCEQ.Code.DHCEQCPMTemplate).GetPMTemplateByID(1)
ClassMethod GetPMTemplateByID(rowid As %Library.String = "")
{
	q:rowid=""
	
	s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",11)
	q:InvalidFlag="Y"
	s Type=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",1)
	s Name=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",2)
	s Caption=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",3)
	s Note=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",4)
	s Remark=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",5)
	s FromDate=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",6)
	i FromDate'="" s FromDate=##class(web.DHCEQCommon).TransValueToPage(FromDate,"date") ;Modified by QW20170302日期格式统一调整
	s ToDate=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",7)
	i ToDate'="" s ToDate=##class(web.DHCEQCommon).TransValueToPage(ToDate,"date") ;Modified by QW20170302日期格式统一调整
	s Hold1=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",8)
	s Hold2=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",9)
	s Hold3=$p($g(^DHCEQCCode("DHCEQCPMTemplate",rowid)),"^",10)
	
	s info=rowid_"^"_Type_"^"_Name_"^"_Caption_"^"_Note_"^"_Remark_"^"_FromDate_"^"_ToDate_"^"_Hold1_"^"_Hold2_"^"_Hold3
	q info
}

/// MZY0119	2574406		2022-04-07
/// w ##Class(web.DHCEQ.Code.DHCEQCPMTemplate).GetPMTemplateEquipRangeID(1)
ClassMethod GetPMTemplateEquipRangeID(rowid As %Library.String = "")
{
	i rowid="" q ""
	q $o(^DHCEQEquipRange(0,"SourceID","3",rowid,""))
}

}
