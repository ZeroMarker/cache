Class web.DHCCarPrvTpPHPoison Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:guobaoping
/// date:2009-03-23
/// description: 新增医护人员级别药品管制分类对照 
/// input:  GRGroupDr(安全组)  GRReasonDr(费别 )  GRDefault(是否默认值)
/// output: SQLCODE
/// others: d ##class(web.DHCMRCDiagnosSignSymptom).AddDHCCarPrvTpPHPoison(2,2)
/// others: w ##class(web.DHCCarPrvTpPHPoison).AddDHCCarPrvTpPHPoison(18,6,"","O")
ClassMethod AddDHCCarPrvTpPHPoison(TPPParRef As %String, TPPPoisonDR As %String, TPPControlType As %String, EpisodeType As %String, ChkVerify As %String)
{
	 i TPPControlType=" " s TPPControlType=""
	 s ChkVerify=$case(ChkVerify,1:"Y",0:"N",:"")
 TSTART		
 &SQL(insert into SQLUser.DHC_CarPrvTpPHPoison(TPP_ParRef,TPP_Poison_DR,TPP_ControlType,TPP_EpisodeType,TPP_ChkVerify) 
	  values(:TPPParRef,:TPPPoisonDR,:TPPControlType,:EpisodeType,:ChkVerify)
	 )
 i SQLCODE
	{
	 TROLLBACK
	q SQLCODE
	}
 TCOMMIT
 q SQLCODE
}

/// 判断是否重复
/// w ##class(web.DHCCarPrvTpPHPoison).CheckUnique(1,"1||2",4,"EM")
/// w ##class(web.DHCCarPrvTpPHPoison).CheckUnique(1,"",4,"EM")
ClassMethod CheckUnique(TPPParRef As %String, qTPPRowid As %String, qTPPPoisonDR As %String, qTPPEpisodeType As %String)
{
	n (TPPParRef,qTPPRowid,qTPPPoisonDR,qTPPEpisodeType)
	s RowId=+TPPParRef
	q:'$d(^CT("CPT",RowId)) ""
	
	s Flag="N"
	s Child=0
	f  s Child=$o(^CT("CPT",RowId,"PHPO",Child)) q:Child=""!(Flag="Y")  d
	.q:'$d(^CT("CPT",RowId,"PHPO",Child))
	.s TPPPoisonDR=$p($g(^CT("CPT",RowId,"PHPO",Child)),"^",1)
 	.s TPPEpisodeType=$p($g(^CT("CPT",RowId,"PHPO",Child)),"^",3)
 	.q:(RowId_"||"_Child)=qTPPRowid
	.q:qTPPPoisonDR'=TPPPoisonDR
	.q:qTPPEpisodeType'=TPPEpisodeType
	.s Flag="Y"
	q Flag
}

/// creator:guobaoping
/// date:2009-03-23
/// description: 删除医护人员级别药品管制分类对照
/// input: TPProwID(医护人员级别药品管制分类对照rowid)
/// output: SQLCODE
ClassMethod DelDHCCarPrvTpPHPoison(TPProwID As %String)
{
	 TSTART 		
	 &SQL(delete from SQLUser.DHC_CarPrvTpPHPoison  where TPP_RowId=:TPProwID)
	 i SQLCODE {
		 TROLLBACK	
		 q SQLCODE
	 }
 TCOMMIT
 q SQLCODE
}

/// creator:guobaoping
/// date:2009-03-17
/// description: 取得医护人员级别 
/// input:  
/// output: ret 医护人员级别信息
ClassMethod GetCTCarPrvTp() As %String
{
	n
	s ret=""
	S RowId=0 
	f  s RowId=$O(^CT("CPT",RowId)) Q:(RowId="")  d
	.s CTCPTDesc=$P(^CT("CPT",RowId),"^",2)
	.i ret="" s ret=RowId_$C(1)_CTCPTDesc 
	.e  s ret=ret_"^"_RowId_$C(1)_CTCPTDesc
	Q ret
}

ClassMethod GetDHCCarPrvTpPHPoisonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDHCCarPrvTpPHPoisonExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDHCCarPrvTpPHPoisonExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s RowId="" 
 f  s RowId=$o(^CT("CPT",RowId)) q:RowId=""  d
 .q:'$d(^CT("CPT",RowId))
 .s CTCPTDesc=$P(^CT("CPT",RowId),"^",2)
 .s Child=0   //对照记录
 .f  s Child=$o(^CT("CPT",RowId,"PHPO",Child)) q:Child=""  d
 ..q:'$d(^CT("CPT",RowId,"PHPO",Child))
 ..s TPPPoisonDR=$p($g(^CT("CPT",RowId,"PHPO",Child)),"^",1)
 ..i (TPPPoisonDR'="")&&($d(^PHCPO(TPPPoisonDR)))  d
 ...s PHCPODesc=$p($g(^PHCPO(TPPPoisonDR)),"^",2)
 ..s TPPRowId=RowId_"||"_Child
 ..s TPPControlType=$p($g(^CT("CPT",RowId,"PHPO",Child)),"^",2)
 ..if TPPControlType="A" Set TPPControlTypeDesc="提示"
 ..if TPPControlType="F" Set TPPControlTypeDesc="禁止"
 ..if TPPControlType="P" Set TPPControlTypeDesc="申请单"
 ..if TPPControlType="S" Set TPPControlTypeDesc="系统申请"
 ..s TPPEpisodeType=$p($g(^CT("CPT",RowId,"PHPO",Child)),"^",3)
 ..if TPPEpisodeType="O" Set TPPEpisodeTypeDesc="门诊"
 ..if TPPEpisodeType="E" Set TPPEpisodeTypeDesc="急诊"
 ..if TPPEpisodeType="I" Set TPPEpisodeTypeDesc="住院"
 ..s TPPChkVerify=$p($g(^CT("CPT",RowId,"PHPO",Child)),"^",4)
 ..s TPPChkVerify=$case(TPPChkVerify,"Y":1,"N":0,:"")
 ..Set Data=$ListBuild(TPPRowId,PHCPODesc,TPPPoisonDR,CTCPTDesc,TPPControlType,TPPEpisodeType,TPPChkVerify,TPPControlTypeDesc,TPPEpisodeTypeDesc)
 ..Set ^CacheTemp(repid,ind)=Data
	..Set ind=ind+1
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetDHCCarPrvTpPHPoisonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDHCCarPrvTpPHPoisonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				
 Set AtEnd=1
 Set Row=""
 }
 Else      {				
 Set Row=^CacheTemp(repid,ind)
 }

 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:guobaoping
/// date:2009-03-17
/// description: 取得药品管制分类 
/// input:  
/// output: 药品管制分类信息
ClassMethod GetPHCPoison() As %String
{
	n
	s ret=""
	S RowId=0 
	f  s RowId=$O(^PHCPO(RowId)) Q:(RowId="")  d
	.s PHCPODesc=$P(^PHCPO(RowId),"^",2)
	.i ret="" s ret=RowId_$C(1)_PHCPODesc
	.e  s ret=ret_"^"_RowId_$C(1)_PHCPODesc
	Q ret
}

/// creator:guobaoping
/// date:2009-03-17
/// description: 更新医护人员级别药品管制分类对照 
/// input:  GRGroupReasonID(安全组费别对照记录rowid)  GRReasonDr(费别 )  GRDefault(是否默认值)
/// output: SQLCODE
ClassMethod UpdateDHCCarPrvTpPHPoison(TPProwID As %String, TPPPoisonDR As %String, TPPControlType As %String, EpisodeType As %String, ChkVerify As %String)
{
	i TPPControlType=" " s TPPControlType=""
	s ChkVerify=$case(ChkVerify,1:"Y",0:"N",:"")
 TSTART
 &SQL(update SQLUser.DHC_CarPrvTpPHPoison  
	    set TPP_Poison_DR=:TPPPoisonDR,
	        TPP_ControlType=:TPPControlType,
	        TPP_EpisodeType=:EpisodeType,
	        TPP_ChkVerify=:ChkVerify
	  where TPP_RowId=:TPProwID  
	 )
 i SQLCODE
	{
	 TROLLBACK
	q SQLCODE
	}
 TCOMMIT
 q SQLCODE
}

/// creator:guobaoping
/// date:2009-03-17
/// description: 取得医护人员级别药品管制分类对照信息 
/// input:  
/// output: 
Query GetDHCCarPrvTpPHPoison() As %Query(ROWSPEC = "TPPRowId:%String,PHCPODesc:%String,TPPPoisonDR:%String,CTCPTDesc:%String,TPPControlType:%String,TPPEpisodeType:%String,TPPChkVerify,TPPControlTypeDesc:%String,TPPEpisodeTypeDesc:%String")
{
}

}
