/// 
/// 质控项目重组公共
Class web.DHCMgNurQcRestruct Extends %RegisteredObject
{

/// 按照质控一级项目查找二级项目
Query FindSecQcItm(par As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSecQcItmExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ret=""
 	s level=0 f  s level=$O(^DHCMGNUR.QualCodeItemSubI("Level",level)) q:level=""  d
 	.s code="" f  s code=$O(^DHCMGNUR.QualCodeItemSubI("Level",level,code)) q:code=""  d
 	..s rw="" f  s rw=$O(^DHCMGNUR.QualCodeItemSubI("Level",level,code,par,rw)) q:rw=""  d
 	...s obj=##class(DHCMGNUR.QualCodeItemSub).%OpenId(par_"||"_rw)
 	...q:$L(obj.ItemCode,".")>1
 	...s ItemDesc=$zcvt($tr(obj.ItemDesc," ",""),"U")
 	...s ret="itemDesc|"_ItemDesc_"^par|"_par_"^raw|"_rw
 	...d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindSecQcItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSecQcItmExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindSecQcItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSecQcItmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod settmp(parr, tmp) As %String
{
	s l=$L(parr,"^")
	for i=1:1:l
	{
	  s itm=$P(parr,"^",i)
	  if itm="" continue
	  s name=$P(itm,"|")
	  if $P(name,"_",2)'=""  s name=$P(name,"_",1)
	  s val=$P(itm,"|",2)
	  if '$D(tmp(name)) s tmp(name)=val
	  e  s tmp(name)=tmp(name)_";"_val
	  if $F(val,"!")'=0
	  {
	    s rw=$P(val,"!")
	    s rwv=$P(val,"!",2)
	    if rwv'=""
	    {
		  if (rwv="date")
		  {
			  if (rw'="") s val=$ZDH(rw,3)
			  e  s val=""
		  }
		  if (rwv="time")
		  {
			  if (rw'="") s val=$ZTH(rw,4)
			  e  s val=""
		  }
		}else{
			s val=""
			}
	   s tmp(name)=val
	  }
	}
  q 0
}

/// 查询模板
Query FindQcModel(typ As %String = "", ward As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindQcModelExecute(ByRef qHandle As %Binary, typ As %String = "", ward As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s desc="" f  s desc=$O(^DHCMGNUR.MgNurQcModelI("typ"," "_typ,desc)) q:desc=""  d
 	.s id="" f  s id=$O(^DHCMGNUR.MgNurQcModelI("typ"," "_typ,desc,id)) q:id=""  d
 	..s obj=##class(DHCMGNUR.MgNurQcModel).%OpenId(id)
 	..q:((ward'="")&&(obj.ModelDep'=ward))
 	..s modelname=obj.ModelName
 	..s ret="modelname|"_modelname_"^modelid|"_id
 	..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindQcModelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQcModelExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindQcModelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQcModelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 查找重组二级项目
Query FindResSecQcItm(par As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindResSecQcItmExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ret=""
 	s raw="" f  s raw=$O(^DHCMGNUR.MgNurQcModelChildD(par,raw)) q:raw=""  d
 	.s obj=##class(DHCMGNUR.MgNurQcModelChild).%OpenId(par_"||"_raw)
 	.s QcDesc=obj.ChildDesc
 	.s ChildPar=obj.ChildPar
 	.s ChildRw=obj.ChildRw
 	.s ChildMinLev=obj.ChildMinLev
 	.s ret="QcDesc|"_QcDesc_"^ChildPar|"_ChildPar_"^ChildRw|"_ChildRw_"^ChildMinLev|"_ChildMinLev_"^PRow|"_par_"^RowID|"_raw
 	.d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindResSecQcItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindResSecQcItmExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindResSecQcItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindResSecQcItmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 查询常用模板关联的三级项目
Query FindThirdQcItms(par As %String = "", rw As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindThirdQcItmsExecute(ByRef qHandle As %Binary, par As %String = "", rw As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ret=""
 	s raw="" f  s raw=$O(^DHCMGNUR.MgNurQcModChildSubD(par,rw,raw)) q:raw=""  d
 	.s obj=##class(DHCMGNUR.MgNurQcModChildSub).%OpenId(par_"||"_rw_"||"_raw)
 	.s ret="thirddesc|"_obj.ItemDesc_"^Fpar|"_par_"^Spar|"_rw_"^Thraw|"_raw_"^TMinLevel|"_obj.MinLevel
 	.d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindThirdQcItmsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindThirdQcItmsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindThirdQcItmsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindThirdQcItmsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 获取质控项目
Query GetQualCode(sid As %String, locid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetQualCodeExecute(ByRef qHandle As %Binary, sid As %String = "", locid As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
	if (sid="QualSelfCheck")
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",1," "_locid,id)) q:id=""  d
	 	.s rw="" f  s rw=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",1," "_locid,id,rw)) q:rw=""  d
	 	..s a=##class(DHCMGNUR.MgNurQualRelLoc).%OpenId(rw)
	 	..s Pos=a.SortPos
	 	..s arr(Pos)=##class(DHCMGNUR.QualCodeItem).getVal(id)
	 	..s arr(Pos)=arr(Pos)_"^rw|"_id
	 	s row="" f  s row=$o(arr(row)) q:row=""  d
	 	.s ret=arr(row)
	 	.d outtyp2
	}
 	else
 	{
	 	s QualTemp=""
 		s Qual="" f  s Qual=$O(^DHCMGNUR.QualCodeItemI("Version",Qual)) q:Qual=""  d
 		.q:QualTemp=Qual
 		.s QualTemp=Qual
 		.s flag=0
 		.s Ver="" f  s Ver=$O(^DHCMGNUR.QualCodeItemI("Version",Qual,Ver),-1) q:Ver=""  d
 		..q:flag=1
 		..s flag=1
 		..s id="" f  s id=$O(^DHCMGNUR.QualCodeItemI("Version",Qual,Ver,id)) q:id=""  d
 		...s a=##class(DHCMGNUR.QualCodeItem).%OpenId(id)
		...s rw=id
		...q:a.QualDesc="夜查房"
		...q:a.QualCat="Satisfaction"
		...i (sid="SafeCheck")||(sid="SafeSelfCheck") q:a.QualCat'="SafeCheck"   ;(a.QualDesc'["核查")||(a.QualDesc["满意度")
		...s ret=""
		...s ret=##class(DHCMGNUR.QualCodeItem).getVal(rw)
		...s ret=ret_"^rw|"_id
		...d outtyp2
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetQualCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualCodeExecute ]
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

ClassMethod GetQualCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 
/// 获取自定义项目
Query GetCusQualCode(typ As %String, ward As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetCusQualCodeExecute(ByRef qHandle As %Binary, typ As %String, ward As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s loc="" f  s loc=$O(^DHCMGNUR.MgNurQcModelI("flag"," "_typ,loc)) q:loc=""  d
 	.q:((ward'="")&&($tr(loc," ","")'=ward))
 	.s desc="" f  s desc=$O(^DHCMGNUR.MgNurQcModelI("flag"," "_typ,loc,desc)) q:desc=""  d
 	..s id="" f  s id=$O(^DHCMGNUR.MgNurQcModelI("flag"," "_typ,loc,desc,id)) q:id=""  d
 	...s obj=##class(DHCMGNUR.MgNurQcModel).%OpenId(id)
 	...s modelname=obj.ModelName
 	...s ret="modelname|"_modelname_"^rw|"_id
	...d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCusQualCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCusQualCodeExecute ]
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

ClassMethod GetCusQualCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCusQualCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 获取模板条目
Query GetCustItmsSub(Par As %String, flag As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetCustItmsSubExecute(ByRef qHandle As %Binary, Par As %String, flag As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	i flag=1
 	{
 		s ModelTmp=""
 		s pObj=##class(DHCMGNUR.MgNurQcModel).%OpenId(Par)
 		s pNo=1
 		s prw="" f  s prw=$O(^DHCMGNUR.MgNurQcModelChildD(Par,prw)) q:prw=""  d
 		.s prwObj=##class(DHCMGNUR.MgNurQcModelChild).%OpenId(Par_"||"_prw)
 		.;s ModelTmp(Par,pNo,prw,0)="moldesc|"_prwObj.ChildDesc_"^code|"_pNo_"^MinLev|"_prwObj.ChildMinLev_"^par|"_Par_"^raw|"_prw_"^subrw|"_""_"^sort|"_pNo_"^QualPar|"_prwObj.ChildPar_"^QualRaw|"_prwObj.ChildRw
 		.s rwNo=1,tscore=0
 		.s rwsub="" f  s rwsub=$O(^DHCMGNUR.MgNurQcModChildSubD(Par,prw,rwsub)) q:rwsub=""  d
 		..s subObj=##class(DHCMGNUR.MgNurQcModChildSub).%OpenId(Par_"||"_prw_"||"_rwsub)
 		..s ModelTmp(Par,pNo,prw,rwsub)="moldesc|"_subObj.ItemDesc_"^code|"_subObj.ItemCode_"^MinLev|"_subObj.MinLevel_"^par|"_Par_"^raw|"_prw_"^subrw|"_rwsub_"^sort|"_pNo_"."_rwNo_"^checkscore|"_subObj.ItemValue_"^QualPar|"_subObj.ChildPar_"^QualRaw|"_subObj.ChildRw
 		..s rwNo=rwNo+1
 		..s tscore=tscore+subObj.ItemValue
 		.s ModelTmp(Par,pNo,prw,0)="moldesc|"_prwObj.ChildDesc_"^code|"_pNo_"^MinLev|"_prwObj.ChildMinLev_"^par|"_Par_"^raw|"_prw_"^subrw|"_""_"^sort|"_pNo_"^QualPar|"_prwObj.ChildPar_"^QualRaw|"_prwObj.ChildRw_"^checkscore|"_tscore
 		.s pNo=pNo+1
 		s prow="" f  s prow=$O(ModelTmp(Par,prow)) q:prow=""  d
 		.s pcrow="" f  s pcrow=$O(ModelTmp(Par,prow,pcrow)) q:pcrow=""  d
 		..s psrow="" f  s psrow=$O(ModelTmp(Par,prow,pcrow,psrow)) q:psrow=""  d
 		...s ret=ModelTmp(Par,prow,pcrow,psrow)
 		...d outtyp2
 	}
 	i flag=0
	{
		s raw="" f  s raw=$O(^DHCMGNUR.QualCodeItemSubD(Par,raw)) q:raw=""  d
 		.s obj=##class(DHCMGNUR.QualCodeItemSub).%OpenId(Par_"||"_raw)
 		.s code=obj.ItemCode
 		.s moldesc=obj.ItemDesc
 		.s checkscore=obj.ItemValue
 		.i $l(code,".")=1 s MinLev="N"
 		.e  i $l(code,".")=2 s MinLev="Y"
 		.s ret="code|"_code_"^moldesc|"_moldesc_"^checkscore|"_checkscore_"^MinLev|"_MinLev_"^par|"_Par_"^raw|"_raw_"^sort|"_code_"^QualPar|"_Par_"^QualRaw|"_raw
 		.d outtyp2
	}
	i flag=-1
	{
 		s prw="" f  s prw=$O(^DHCMGNUR.QuCheckWardD(Par,"ChildSub",prw)) q:prw=""  d
 		.s obj=##class(DHCMGNUR.QuCheckWardChild).%OpenId(Par_"||"_prw)
 		.s rwNo=1,tscore=0
 		.i $l(obj.ModleCode,".")=1 s MinLev="N"
 		.e  i $l(obj.ModleCode,".")=2 s MinLev="Y"
 		.s ret="moldesc|"_obj.ItemDesc_"^code|"_obj.ItemCode_"^MinLev|"_MinLev_"^par|"_Par_"^raw|"_prw_"^subrw|"_""_"^sort|"_obj.ModleCode_"^checkscore|"_obj.ItemValue_"^QualPar|"_$P(obj.CheckItem.%Id(),"||",1)_"^QualRaw|"_$P(obj.CheckItem.%Id(),"||",2)
 		.d outtyp2
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCustItmsSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCustItmsSubExecute ]
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

ClassMethod GetCustItmsSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCustItmsSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetModelItemSub(parr As %String, checkflag As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetModelItemSubExecute(ByRef qHandle As %Binary, parr As %String, checkflag As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ParRow=$P(parr,"^",1)
 	s Par=$P(parr,"^",2)
 	s checktype=$P(parr,"^",3)
 	s ret=""
 	i Par=""
 	{
	 	s raw="" f  s raw=$O(^DHCMGNUR.QuCheckWardD(ParRow,"ChildSub",raw)) q:raw=""  d
	 	.s obj=##class(DHCMGNUR.QuCheckWardChild).%OpenId(ParRow_"||"_raw)
	 	.s ModleCode=obj.ModleCode
	 	.s ItemDesc=obj.ItemDesc
	 	.s ItemValue=obj.ItemValue
	 	.i $l(ModleCode,".")=1 s MinLevel="N"
	 	.e  i $l(ModleCode,".")=2 s MinLevel="Y"
	 	.s CheckItem=obj.CheckItem.%Id()
	 	.s ret="ItemCode|"_ModleCode_"^ItemDesc|"_ItemDesc_"^ItemValue|"_ItemValue_"^rw|"_raw_"^Par|"_ParRow_"^MinLevel|"_MinLevel_"^QualPar|"_$P(CheckItem,"||",1)_"^QualRw|"_$P(CheckItem,"||",2)
	 	.d outtyp2
 	}
 	else
 	{
 		s raw="" f  s raw=$O(^Nur.CheckRoomD(Par,"ChildRec",raw)) q:raw=""  d
 		.s a=##class(Nur.CheckRoomItem).%OpenId(Par_"||"_raw)
 		.s ModleCode=a.CheckCode
 		.s ItemDesc=a.CheckDesc
 		.s ItemValue=a.CheckValue
 		.s CheckScore=a.CheckScore
 		.s CheckMem=a.CheckMem
 		.i $l(ModleCode,".")=1 s MinLevel="N"
	 	.e  i $l(ModleCode,".")=2 s MinLevel="Y"
	 	.s CheckItem=a.CheckItem
 		.s ret="ItemCode|"_ModleCode_"^ItemDesc|"_ItemDesc_"^ItemValue|"_ItemValue_"^CheckScore|"_CheckScore_"^CheckMem|"_CheckMem_"^rw|"_raw_"^Par|"_Par_"^MinLevel|"_MinLevel_"^QualPar|"_$P(CheckItem,"||",1)_"^QualRw|"_$P(CheckItem,"||",2)
	 	.d outtyp2	
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetModelItemSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetModelItemSubExecute ]
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

ClassMethod GetModelItemSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetModelItemSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 获取夜查房记录的flag标识0：标准模板 1：重组模板
ClassMethod getRecFlag(id) As %String
{
	q:id="" -1
	s obj=##class(DHCMGNUR.QuCheckWard).%OpenId(id)
	s flag=obj.CheckFlag
	q flag
}

/// 获取总分
ClassMethod getQualScore(id, flag) As %String
{
	s score=0
	s raw="" f  s raw=$O(^DHCMGNUR.QuCheckWardD(id,"ChildSub",raw)) q:raw=""  d
	.s obj=##class(DHCMGNUR.QuCheckWardChild).%OpenId(id_"||"_raw)
	.q:$l(obj.ModleCode,".")=2
	.s score=score+obj.ItemValue
	q score
}

/// 
/// 获取查房信息列表
Query FindCheckRoom(parr As %String = "") As %Query(ROWSPEC = "CheckTyp,CheckDate,WardLoc,QualDesc,Score,HunScore,CheckUser,Question,rw,PatName,NightNur,RTime,BedPat,BWPat,OpPat")
{
}

ClassMethod FindCheckRoomExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s stdate=$ZDH($P(parr,"^",1),3)
 	s eddate=$ZDH($P(parr,"^",2),3)
 	s chktyp=$P(parr,"^",3)
 	s qualdr=$P(parr,"^",4)
 	s Wardloc=$P(parr,"^",5)
 	s chktyp=$TR($ZConvert(chktyp,"U")," ","")
    if (chktyp="NIGHTCHK") s CheckTyp="夜查房"
    if (chktyp="DAYCHK") s CheckTyp="随机督查"
	s ret=""
	s rw="" f  s rw=$O(^Nur.CheckRoomI("CheckQual"," "_qualdr,rw)) q:rw=""  d
	.s obj=##class(Nur.CheckRoom).%OpenId(rw)
	.s LocDr=obj.WardLoc
	.q:((LocDr'=Wardloc)&&(Wardloc'=""))
	.s Ward=$p(^CTLOC(LocDr),"^",2)
	.q:(obj.CheckQual'=qualdr)&&(qualdr'="")   
	.s CheckUserT=obj.CheckUser
	.s ret=""
	.s sum=$l(CheckUserT,";")
	.f i=1:1:sum {s des=$P(..getsuser($p(CheckUserT,";",i)),"!",2)  i des'="" s ret=ret_des_";"}
	.s CheckUser=ret
	.s Score=obj.Score
	.s sumscore=..getQualScore(qualdr,0)
	.s HunScore=$fnumber(Score*100/sumscore,"",1)
	.i obj.CheckPat'="" s PatName=##Class(web.DHCMgQualCheck).getPatName(a.CheckPat)
	.s NurName=obj.NightNur
	.s chekdate=$ZD(obj.RDate,3)
	.s Question=obj.CheckQuestion
	.s RTime=$zt(obj.RTime,1)
	.s BedPat=$P(obj.PatCounts,"!",1)
	.s BWPat=$P(obj.PatCounts,"!",2)
	.s OpPat=$P(obj.PatCounts,"!",3)
	.d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(chktyp,chekdate,Ward,$G(QualDesc),Score,HunScore,CheckUser,Question,rw,PatName,NurName,RTime,BedPat,BWPat,OpPat)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCheckRoomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckRoomExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCheckRoomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckRoomExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getsuser(recuserId) As %String
{
  q:recuserId="" ""
  s User=$p($g(^SSU("SSUSR",recuserId)),"^",2)
  q recuserId_"!"_User
}

/// 
/// 夜查房检查病区
Query FindWardLoc(HsDr, typ, ward = "", Par = "", nurtype = "") As %Query(ROWSPEC = "LocDes,LocDr,SortPos")
{
}

ClassMethod FindWardLocExecute(ByRef qHandle As %Binary, HsDr, typ, ward = "", Par = "", nurtype = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ^TEMP("g07111713001")=HsDr_"%"_typ_"%"_ward_"%"_Par_"%"_nurtype
 	s typ=$TR($ZConvert(typ,"U")," ","")
 	s ward=$TR($ZConvert(ward,"U")," ","")
 	s secGrp=$P(nurtype,"^",1)
 	s useid=$P(nurtype,"^",2)
 	s chkTyp=$P(nurtype,"^",3)
    s tmp=""
    i ((secGrp="demo")!(secGrp="hlb"))
    {
	    s sort="" f  s sort=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",sort)) q:sort=""  d
	    .s rw="" f  s rw=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",sort,rw)) q:rw=""  d
	    ..s obj=##class(DHCMGNUR.MgNurPerWard).%OpenId(rw)
	    ..s CtLocDr=obj.WardLoc
	    ..s ctlocDesc=""
	    ..q:$G(^CTLOC(CtLocDr))=""
	    ..s ctlocDesc=$P(^CTLOC(CtLocDr),"^",2)
	    ..q:((ward'="")&&(ctlocDesc'[$zcvt(ward,"U")))
	    ..d OutputRow8
    }
    elseif (secGrp="nurhead")
    {
	    i (chkTyp="W")
	    {
		    s raw="" f  s raw=$O(^DHCMGNUR.MgNurseI("typ"," NUR",raw)) q:raw=""  d
	   		.s nurObj=##class(DHCMGNUR.MgNurse).%OpenId(raw)
	    	.q:((useid'="")&&(nurObj.Nurse'=useid))
	    	.s rw="" f  s rw=$O(^DHCMGNUR.MgNurseD(raw,"ChildSub",rw)) q:rw=""  d
	    	..s obj=##class(DHCMGNUR.MgNurseSub).%OpenId(raw_"||"_rw)
	    	..s CtLocDr=obj.WardLoc
	    	..s ctlocDesc=$P(^CTLOC(CtLocDr),"^",2)
	    	..q:((ward'="")&&(ctlocDesc'[$zcvt(ward,"U")))
	    	..d OutputRow8
	    }elseif(chkTyp="H")
	    {
		   s sort="" f  s sort=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",sort)) q:sort=""  d
	    	.s rw="" f  s rw=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",sort,rw)) q:rw=""  d
	    	..s obj=##class(DHCMGNUR.MgNurPerWard).%OpenId(rw)
	    	..s CtLocDr=obj.WardLoc
	    	..s ctlocDesc=""
	    	..q:$G(^CTLOC(CtLocDr))=""
	    	..s ctlocDesc=$P(^CTLOC(CtLocDr),"^",2)
	    	..q:((ward'="")&&(ctlocDesc'[$zcvt(ward,"U")))
	    	..d OutputRow8 
	    }elseif(chkTyp="Z")
	    {
		    s nurse="" f  s nurse=$O(^DHCMGNUR.MgNurseI("Nurse",useid,nurse)) q:nurse=""  d
		    .s rid="" f  s rid=$O(^DHCMGNUR.MgNurseI("Nurse",useid,nurse,rid)) q:rid=""  d
		    ..s obj1=##class(DHCMGNUR.MgNurse).%OpenId(rid)
		    ..s wardloc=obj1.WardLoc
		    ..s unitrw=$O(^DHCMGNUR.MgNurMaCareUnitI("WardId",wardloc,""))
		    ..i unitrw'="" d
		    ...s unitobj=##class(DHCMGNUR.MgNurMaCareUnit).%OpenId(unitrw)
		    ...s unit=unitobj.WardTyp
		    ...s loc="" f  s loc=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ"," "_unit,loc)) q:loc=""  d
		    ....s rw="" f  s rw=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ"," "_unit,loc,rw)) q:rw=""  d
		    .....s obj=##class(DHCMGNUR.MgNurMaCareUnit).%OpenId(rw)
		    .....s CtLocDr=obj.WardLoc
			.....s ctlocDesc=$P(^CTLOC(CtLocDr),"^",2)
			.....q:((ward'="")&&(ctlocDesc'[$zcvt(ward,"U")))
			.....d OutputRow8
	    }
    }
    elseif(secGrp="znurhead")
	{
		i chkTyp="Z"
		{
			s unit="" f  s unit=$O(^DHCMGNUR.DHCMgNurLarNurForLocI("Typ"," "_useid,unit)) q:unit=""  d
			.s loc="" f  s loc=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ",unit,loc)) q:loc=""  d
			..s rw="" f  s rw=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ",unit,loc,rw)) q:rw=""  d
			...s obj=##class(DHCMGNUR.MgNurMaCareUnit).%OpenId(rw)
			...s CtLocDr=obj.WardLoc
			...s ctlocDesc=$P(^CTLOC(CtLocDr),"^",2)
			...q:((ward'="")&&(ctlocDesc'[$zcvt(ward,"U")))
			...d OutputRow8
		}elseif(chkTyp="H")
		{
			s sort="" f  s sort=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",sort)) q:sort=""  d
	    	.s rw="" f  s rw=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",sort,rw)) q:rw=""  d
	    	..s obj=##class(DHCMGNUR.MgNurPerWard).%OpenId(rw)
	    	..s CtLocDr=obj.WardLoc
	    	..s ctlocDesc=""
	    	..q:$G(^CTLOC(CtLocDr))=""
	    	..s ctlocDesc=$P(^CTLOC(CtLocDr),"^",2)
	    	..q:((ward'="")&&(ctlocDesc'[$zcvt(ward,"U")))
	    	..d OutputRow8
		}
	}elseif(secGrp="nurse")
	{
		s perNurseId=$P(^SSU("SSUSR",useid),"^",1)
	 	s rw="" f  s rw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$zcvt(perNurseId,"U"),rw)) q:rw=""  d
	 	.s a=##class(DHCMGNUR.MgPersons).%OpenId(rw)
	 	.s CtLocDr=a.PersonDepDR
	 	.s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
	 	.d OutputRow8
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,CtLocDr,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardLocExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWardLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 夜查房检查人员
Query FindTypNur(Name = "", nurtype = "") As %Query(ROWSPEC = "nursename,nurdr")
{
}

ClassMethod FindTypNurExecute(ByRef qHandle As %Binary, Name As %String = "", nurtype As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    s secGrp=$P(nurtype,"^",1)
 	s useid=$P(nurtype,"^",2)
 	i ((secGrp="demo")!(secGrp="hlb"))
 	{
	 	s typ="" f  s typ=$O(^DHCMGNUR.MgNurseI("typ",typ)) q:typ=""  d
	 	.s rw="" f  s rw=$O(^DHCMGNUR.MgNurseI("typ",typ,rw)) q:rw=""  d
	 	..s obj=##class(DHCMGNUR.MgNurse).%OpenId(rw)
	 	..s ssuser=obj.Nurse
	 	..s list=^SSU("SSUSR",ssuser)
	 	..s nursename=$P(list,"^",2)
	 	..d OutputRow8
 	}
 	elseif (secGrp="znurhead")
 	{
	 	s unit="" f  s unit=$O(^DHCMGNUR.DHCMgNurLarNurForLocI("Typ"," "_useid,unit)) q:unit=""  d
		.s loc="" f  s loc=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ",unit,loc)) q:loc=""  d
		..s rw="" f  s rw=$O(^DHCMGNUR.MgNurseI("loc",loc,rw)) q:rw=""  d
		...s obj=##class(DHCMGNUR.MgNurse).%OpenId(rw)
		...s ssuser=obj.Nurse
		...s list=^SSU("SSUSR",ssuser)
		...s nursename=$P(list,"^",2)
		...d OutputRow8
 	}
 	elseif (secGrp="nurhead")
	{
		s ssuser=useid
		s list=^SSU("SSUSR",useid)
		s nursename=$P(list,"^",2)
		d OutputRow8
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	;set Data=$lb(checktyp,nursename,nurdr,$G(ctlocDesc),loc,rw)
 	set Data=$lb(nursename,ssuser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindTypNurFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTypNurExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindTypNurClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTypNurExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 获取夜查房检查列表
Query CheckRoomList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod CheckRoomListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
    s stdate=$P(parr,"^",1)
    s edate=$P(parr,"^",2)
    s typ=$P(parr,"^",3)
    s userid=$P(parr,"^",4)
    s flag=$P(parr,"^",5)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    s limittyp=$P(parr,"^",6)
    s secgrp=$P(parr,"^",7)
    s roomtype=$P(parr,"^",8)
    s date="" f  s date=$O(^DHCMGNUR.QuCheckWardI("CheckDate",date)) q:date=""  d
    .q:((date<stdate)&&(stdate'=""))
    .q:((date>edate)&&(edate'=""))
    .s rw="" f  s rw=$O(^DHCMGNUR.QuCheckWardI("CheckDate",date,rw)) q:rw=""  d
    ..s a=##class(DHCMGNUR.QuCheckWard).%OpenId(rw)
    ..q:a.CheckTyp="SelfDayChk"
    ..q:((roomtype'="")&&(a.CheckTyp'=roomtype))
    ..q:(typ'=a.CheckTyp)&&(typ'="")
    ..i a.CheckDate'="" s CheckDate=$zd(a.CheckDate,3)
    ..e  s CheckDate=""
    ..;i a.CheckEndTime'="" s CheckEndTime=$zt(a.CheckEndTime,2)
    ..;e  s CheckEndTime=""
    ..s CheckEndTime=a.CheckEndTime
    ..s CheckFlag=a.CheckFlag
    ..i a.CheckLevel="H" s CheckLevel="护理部"
    ..e  i a.CheckLevel="W" s CheckLevel="病区"
    ..e  i a.CheckLevel="Z" s CheckLevel="科护士长"
    ..e  s CheckLevel=""
    ..s CheckMoudId=a.CheckMoudId
    ..i a.CheckTyp="NightChk" s CheckRoom="夜查房"
    ..e  i a.CheckTyp="DayChk" s CheckRoom="随机督查"
    ..e  s CheckRoom=""
    ..;i a.CheckSTime'="" s CheckSTime=$zt(a.CheckSTime,2)
    ..;e  s CheckSTime=""
    ..s CheckSTime=a.CheckSTime
    ..i a.RecDate'="" s RecDate=$zd(a.RecDate,3)
    ..e  s RecDate=""
    ..i a.RecTime'="" s RecTime=$zt(a.RecTime,2)
    ..e  s RecTime=""
    ..s itms=..getitmsM(a)
    ..s CheckUsers=$P(itms,"$",1)
    ..s userlen=a.CheckUsers.Count()
    ..s userlst=0
    ..f i=1:1:userlen d
    ...s userw=a.CheckUsers.GetAt(i)
    ...i userid=userw s userlst=1
    ..q:((a.CheckLevel="H")!(a.CheckLevel="Z"))&&(secgrp="nurhead")&&(userlst=0)
    ..q:((a.CheckLevel="H"))&&(secgrp="znurhead")&&(userlst=0)
    ..s Wards=$P(itms,"$",2)
    ..s RecUser=a.RecUser
    ..s ret="CheckDate|"_CheckDate_"^CheckEndTime|"_CheckEndTime_"^CheckFlag|"_CheckFlag_"^CheckLevel|"_CheckLevel_"^CheckMoudId|"_CheckMoudId_"^CheckRoom|"_CheckRoom_"^CheckSTime|"_CheckSTime_"^RecDate|"_RecDate_"^RecTime|"_RecTime_"^CheckUsers|"_CheckUsers_"^Wards|"_Wards_"^row|"_rw_"^CheckTyp|"_CheckRoom_"^RecUser|"_RecUser
    ..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CheckRoomListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckRoomListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CheckRoomListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckRoomListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getitmsM(itm) As %String
{
   		s l=itm.CheckUsers.Count()
	    s ret1="",ret2=""
	    for i=1:1:l
	    {
		  s rw=itm.CheckUsers.GetAt(i)
		  s des=$P(..getsuser(rw),"!",2)
		  s ret1=ret1_des_";"
		} 
        s l=itm.Wards.Count()
	    for i=1:1:l
	    {
		  s rw=itm.Wards.GetAt(i)
		  s des=$p(^CTLOC(rw),"^",2)	    

		  s ret2=ret2_des_";"
		}
		s ret=ret1_"$"_ret2
		q ret
}

/// 
/// 质控查房列表
/// d ##class(%ResultSet).RunQuery("web.DHCMgNurQcRestruct","QuCheckList","2018-06-01^2018-06-30^QualSelfCheck^4636^nurhead")
Query QuCheckList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod QuCheckListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s stdate=$P(parr,"^",1)
    s edate=$P(parr,"^",2)
    s typ=$P(parr,"^",3)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    s checktyp=$TR($ZConvert(typ,"U")," ","")
    s loguser=$P(parr,"^",4)
    s username=$p($g(^SSU("SSUSR",loguser)),"^",2)
    s secgrp=$P(parr,"^",5)
    s date="" f  s date=$O(^DHCMGNUR.MgCheckWardI("CheckDate"," "_checktyp,date),-1) q:date=""  d
    .s rw="" f  s rw=$O(^DHCMGNUR.MgCheckWardI("CheckDate"," "_checktyp,date,rw),-1) q:rw=""  d
    ..s obj=##class(DHCMGNUR.MgCheckWard).%OpenId(rw)
    ..q:((stdate'="")&&(obj.CheckStDate<stdate))
    ..q:((edate'="")&&(obj.CheckEdDate>edate))
    ..i obj.CheckStDate'="" s CheckStDate=$zd(obj.CheckStDate,3)
    ..e  s CheckStDate=""
    ..i obj.CheckEdDate'="" s CheckEdDate=$zd(obj.CheckEdDate,3)
    ..e  s CheckEdDate=""
    ..s CheckMem=obj.CheckMem
    ..s CheckTitle=obj.CheckTitle
    ..s CheckTyp=obj.CheckTyp
    ..s CheckUsers=..getUser(obj.CheckUsers)
    ..s Wards=..getQual(rw)
    ..i obj.NurTyp="H" s NurTyp="护理部"
    ..e  i obj.NurTyp="W" s NurTyp="病区"
    ..e  i obj.NurTyp="Z" s NurTyp="科护士长"
    ..e  s NurTyp=""
    ..s userlen=obj.CheckUsers.Count()
    ..s userlst=0
    ..f i=1:1:userlen d
    ...s userw=obj.CheckUsers.GetAt(i)
    ...i loguser=userw s userlst=1
    ..;q:(((obj.NurTyp="H")!(obj.NurTyp="Z"))&&(secgrp="nurhead")&&(userlst=0))
    ..;q:((obj.NurTyp="H")&&(secgrp="znurhead")&&(userlst=0))
    ..q:((secgrp="nurhead")&&(userlst=0))
    ..q:((secgrp="znurhead")&&(userlst=0))
    ..s ret="CheckStDate|"_CheckStDate_"^CheckEdDate|"_CheckEdDate_"^CheckMem|"_CheckMem_"^CheckTitle|"_CheckTitle_"^CheckTyp|"_CheckTyp_"^CheckUsers|"_CheckUsers_"^Wards|"_Wards_"^NurTyp|"_NurTyp_"^rw|"_rw
	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QuCheckListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuCheckListExecute ]
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

ClassMethod QuCheckListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuCheckListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getUser(itm) As %String
{
	s l=itm.Count()
	s ret=""
	for i=1:1:l
	{
		s rw=itm.GetAt(i)
		s des=$P(..getsuser(rw),"!",2)
		s ret=ret_des_";"
	}
	q ret
}

ClassMethod getQual(id) As %String
{
	s itm=##class(DHCMGNUR.MgCheckWard).%OpenId(id)
	s l=itm.CheckQuals.Count()
	s ret=""
	for i=1:1:l
	{
		s rww=itm.CheckQuals.GetAt(i)
		s rw=$P(rww,"!",2)
		s qtype=$P(rww,"!",1)
		i qtype="S" d
		.s obj=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
		.s des=obj.QualDesc
		.i ret="" s ret=des_";"
		.e  s ret=ret_des_";"
		e  i qtype="C" d
		.s obj1=##class(DHCMGNUR.MgNurQcModel).%OpenId(rw)
		.s des=obj1.ModelName
		.i ret="" s ret=des_";"
		.e  s ret=ret_des_";"
	}
	q ret
}

ClassMethod getitms1(id) As %String
{
	s itm=##class(DHCMGNUR.MgCheckWard).%OpenId(id)
   	s l=itm.CheckUsers.Count()
	s ret1="",ret2=""
	for i=1:1:l
	{
		s rw=itm.CheckUsers.GetAt(i)
		s des=$P(..getsuser(rw),"!",2)
		i ret1="" s ret1=des_"^"_rw
		e  s ret1=ret1_"!"_des_"^"_rw
	} 
    s l=itm.CheckQuals.Count()
	for i=1:1:l
	{
		s rww=itm.CheckQuals.GetAt(i)
		s rw=$p(rww,"!",2)
		s qtype=$p(rww,"!",1)
		i qtype="S" d
		.s obj=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
		.s des=obj.QualDesc
		.i ret2="" s ret2=des_"^"_qtype_"^"_rw_"!"
		.e  s ret2=ret2_des_"^"_qtype_"^"_rw_"!"
		e  i qtype="C" d
		.s obj1=##class(DHCMGNUR.MgNurQcModel).%OpenId(rw)
		.s des=obj1.ModelName
		.i ret2="" s ret2=des_"^"_qtype_"^"_rw_"!"
		.e  s ret2=ret2_des_"^"_qtype_"^"_rw_"!"
	} 
	s ret=ret1_"$"_ret2
	q ret
}

/// 
/// 根据类型科室选择质控项目（标准项目S 自定义项目C）
Query findQualItms(typ As %String, ward As %String = "", parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod findQualItmsExecute(ByRef qHandle As %Binary, typ As %String, ward As %String = "", parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
   	s secgrp=$P(parr,"^",1)
   	s loginuser=$P(parr,"^",2)
   	s ret=""
   	i typ="S"
   	{
	   	s qual="" f  s qual=$O(^DHCMGNUR.QualCodeItemI("Code",qual)) q:qual=""  d
	   	.s raw="" f  s raw=$O(^DHCMGNUR.QualCodeItemI("Code",qual,raw)) q:raw=""  d
	   	..s obj=##class(DHCMGNUR.QualCodeItem).%OpenId(raw)
	   	..s QualDesc=obj.QualDesc
	   	..s ret="QualDesc|"_QualDesc_"^raw|"_raw_"^QType|"_typ
	   	..d OutRowtyp
   	}
   	elseif typ="C"
   	{
	   	i ((secgrp="demo")!(secgrp="hlb"))
	   	{
		   s desc="" f  s desc=$O(^DHCMGNUR.MgNurQcModelI("typ"," H",desc)) q:desc=""  d
		   .s raw="" f  s raw=$O(^DHCMGNUR.MgNurQcModelI("typ"," H",desc,raw)) q:raw=""  d
		   ..s a=##class(DHCMGNUR.MgNurQcModel).%OpenId(raw)
		   ..s QualDesc=a.ModelName
		   ..s ret="QualDesc|"_QualDesc_"^raw|"_raw_"^QType|"_typ
		   ..d OutRowtyp
	   	}
	   	elseif(secgrp="nurhead")
	   	{
		   	s desc="" f  s desc=$O(^DHCMGNUR.MgNurQcModelI("typ"," W",desc)) q:desc=""  d
		   	.s raw="" f  s raw=$O(^DHCMGNUR.MgNurQcModelI("typ"," W",desc,raw)) q:raw=""  d
		   	..s a=##class(DHCMGNUR.MgNurQcModel).%OpenId(raw)
		   	..q:((loginuser'="")&&(a.RecUser'=loginuser))
		   	..s QualDesc=a.ModelName
		   	..s ret="QualDesc|"_QualDesc_"^raw|"_raw_"^QType|"_typ
		   	..d OutRowtyp
	   	}elseif(secgrp="znurhead")
	   	{
		   	s desc="" f  s desc=$O(^DHCMGNUR.MgNurQcModelI("typ"," Z",desc)) q:desc=""  d
		   	.s raw="" f  s raw=$O(^DHCMGNUR.MgNurQcModelI("typ"," Z",desc,raw)) q:raw=""  d
		   	..s a=##class(DHCMGNUR.MgNurQcModel).%OpenId(raw)
		   	..q:((loginuser'="")&&(a.RecUser'=loginuser))
		   	..s QualDesc=a.ModelName
		   	..s ret="QualDesc|"_QualDesc_"^raw|"_raw_"^QType|"_typ
		   	..d OutRowtyp
	   	}
   	}	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod findQualItmsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findQualItmsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod findQualItmsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findQualItmsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 获取质控查房条目信息
Query FindQualChkItms(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindQualChkItmsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s qtype=$P(parr,"^",1)
 	s qualcode=$P(parr,"^",2)
 	s rowId=$P(parr,"^",3)
 	s ret=""
 	i rowId=""
 	{
	 	i qtype="S"
 		{
	 		i qualcode'=""
	 		{
		 		s raw="" f  s raw=$O(^DHCMGNUR.QualCodeItemSubD(qualcode,raw)) q:raw=""  d
		 		.s obj=##class(DHCMGNUR.QualCodeItemSub).%OpenId(qualcode_"||"_raw)
		 		.s ItemCode=obj.ItemCode
		 		.s ItemDesc=obj.ItemDesc
		 		.s ItemValue=obj.ItemValue
		 		.s ItemDedStand=obj.ItemDedStand
		 		.i $L(ItemCode,".")=1 s MinLevel="N"
		 		.e  i $L(ItemCode,".")=2 s MinLevel="Y"
		 		.s ret="ItemCode|"_ItemCode_"^ItemDesc|"_ItemDesc_"^ItemValue|"_ItemValue_"^ItemDedStand|"_ItemDedStand_"^MinLevel|"_MinLevel_"^QualPar|"_qualcode_"^QualRw|"_raw_"^rw|"_raw_"^Par|"
	 			.d OutputRow8
	 		}
 		}elseif(qtype="C")
 		{
	 		i qualcode'=""
	 		{
		 		s ModelTmp=""
 				s pObj=##class(DHCMGNUR.MgNurQcModel).%OpenId(qualcode)
 				s pNo=1
 				s prw="" f  s prw=$O(^DHCMGNUR.MgNurQcModelChildD(qualcode,prw)) q:prw=""  d
 				.s prwObj=##class(DHCMGNUR.MgNurQcModelChild).%OpenId(qualcode_"||"_prw)
 				.s rwNo=1,tscore=0
 				.s rwsub="" f  s rwsub=$O(^DHCMGNUR.MgNurQcModChildSubD(qualcode,prw,rwsub)) q:rwsub=""  d
 				..s subObj=##class(DHCMGNUR.MgNurQcModChildSub).%OpenId(qualcode_"||"_prw_"||"_rwsub)
 				..s ModelTmp(qualcode,pNo,prw,rwsub)="ItemDesc|"_subObj.ItemDesc_"^ItemCode|"_subObj.ItemCode_"^MinLevel|"_subObj.MinLevel_"^par|"_qualcode_"^raw|"_prw_"^subrw|"_rwsub_"^sort|"_pNo_"."_rwNo_"^ItemValue|"_subObj.ItemValue_"^QualPar|"_subObj.ChildPar_"^QualRw|"_subObj.ChildRw
 				..s rwNo=rwNo+1
 				..s tscore=tscore+subObj.ItemValue
 				.s ModelTmp(qualcode,pNo,prw,0)="ItemDesc|"_prwObj.ChildDesc_"^ItemCode|"_pNo_"^MinLevel|"_prwObj.ChildMinLev_"^par|"_qualcode_"^raw|"_prw_"^subrw|"_""_"^sort|"_pNo_"^QualPar|"_prwObj.ChildPar_"^QualRw|"_prwObj.ChildRw_"^ItemValue|"_tscore
 				.s pNo=pNo+1
 				s prow="" f  s prow=$O(ModelTmp(qualcode,prow)) q:prow=""  d
 				.s pcrow="" f  s pcrow=$O(ModelTmp(qualcode,prow,pcrow)) q:pcrow=""  d
 				..s psrow="" f  s psrow=$O(ModelTmp(qualcode,prow,pcrow,psrow)) q:psrow=""  d
 				...s ret=ModelTmp(qualcode,prow,pcrow,psrow)
 				...d OutputRow8
	 		}
 		}
 	}elseif(rowId'="")
 	{
	 	s raw="" f  s raw=$O(^Nur.QualCheckRecD(rowId,"ChildRec",raw)) q:raw=""  d
	 	.s obj1=##class(Nur.QualCheckRecChild).%OpenId(rowId_"||"_raw)
	 	.s ItemCode=obj1.CheckCode
	 	.s ItemDesc=obj1.CheckDesc
	 	.s ItemValue=obj1.CheckValue
	 	.s CheckScore=obj1.CheckScore
	 	.s CheckMem=obj1.CheckMem
	 	.s Complete=obj1.CheckComplete
	 	.i $L(ItemCode,".")=1 s MinLevel="N"
	 	.e  i $L(ItemCode,".")=2 s MinLevel="Y"
	 	.s QualPar=$P(obj1.CheckItem,"||",1)
	 	.s QualRw=$P(obj1.CheckItem,"||",2)
	 	.s ret="ItemCode|"_ItemCode_"^ItemDesc|"_ItemDesc_"^ItemValue|"_ItemValue_"^CheckScore|"_CheckScore_"^CheckMem|"_CheckMem_"^Complete|"_Complete_"^QualPar|"_QualPar_"^QualRw|"_QualRw_"^MinLevel|"_MinLevel
	 	.d OutputRow8
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindQualChkItmsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualChkItmsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindQualChkItmsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualChkItmsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getQualModelScore(qualcode, typ) As %String
{
	s score=0
	i typ="S"
	{
		s raw="" f  s raw=$O(^DHCMGNUR.QualCodeItemSubD(qualcode,raw)) q:raw=""  d
		.s obj=##class(DHCMGNUR.QualCodeItemSub).%OpenId(qualcode_"||"_raw)
		.s code=obj.ItemCode
		.i $L(code,".")=2 s score=score+obj.ItemValue
		.e  s score=score+0
	}elseif(typ="C")
	{
		s sub="" f  s sub=$O(^DHCMGNUR.MgNurQcModChildSubD(qualcode,sub)) q:sub=""  d
		.s raw="" f  s raw=$O(^DHCMGNUR.MgNurQcModChildSubD(qualcode,sub,raw)) q:raw=""  d
		..s obj1=##class(DHCMGNUR.MgNurQcModChildSub).%OpenId(qualcode_"||"_sub_"||"_raw)
		..s minLevel=obj1.MinLevel
		..i minLevel="Y" s score=score+obj1.ItemValue
		..e  s score=score+0
	}
	q score
}

/// 
/// 质控评分列表
Query FindChkScorelst(QualDr, wardLoc As %String = "", CheckCode, ckDate, typ, qtype) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindChkScorelstExecute(ByRef qHandle As %Binary, QualDr, wardLoc As %String = "", CheckCode, ckDate, typ, qtype) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^TEMP("g07051111001")=QualDr_"&"_wardLoc_"&"_CheckCode_"&"_ckDate_"&"_typ_"&"_qtype //16&&4&2016-06-30^2016-06-30&H
 	s stdate=$P(ckDate,"^",1)
 	s enddate=$P(ckDate,"^",2)
 	s ret=""
 	s date="" f  s date=$O(^Nur.QualCheckRecI("Check",date)) q:date=""  d
 	.q:((stdate'="")&&(date<$zdh(stdate,3)))
 	.q:((enddate'="")&&(date>$zdh(enddate,3)))
 	.s ctype="" f  s ctype=$O(^Nur.QualCheckRecI("Check",date,ctype)) q:ctype=""  d
 	..q:((typ'="")&&($tr(ctype," ","")'=typ))
 	..s ward="" f  s ward=$O(^Nur.QualCheckRecI("Check",date,ctype,ward)) q:ward=""  d
 	...q:((wardLoc'="")&&($Tr(ward," ","")'=wardLoc))
 	...s prowId="" f  s prowId=$O(^Nur.QualCheckRecI("Check",date,ctype,ward,prowId)) q:prowId=""  d
 	....q:((QualDr'="")&&($tr(prowId," ","")'=QualDr))
 	....s raw="" f  s raw=$O(^Nur.QualCheckRecI("Check",date,ctype,ward,prowId,raw)) q:raw=""  d
 	.....s obj=##class(Nur.QualCheckRec).%OpenId(raw)
 	.....q:((qtype'="")&&(obj.QType'=qtype))
 	.....q:((CheckCode'="")&&(obj.CheckCode'=CheckCode))
 	.....i obj.CheckTyp="H" s CheckTyp="护理部"
 	.....e  i obj.CheckTyp="Z" s CheckTyp="科护士长"
 	.....e  i obj.CheckTyp="W" s CheckTyp="病区"
 	.....e  s CheckTyp=""
 	.....i $G(^CTLOC(obj.WardLoc))'="" s WardLoc=$P(^CTLOC(obj.WardLoc),"^",2)
 	.....e  s WardLoc=""
 	.....s QualDesc=""
 	.....i obj.QType="S" d
 	......s qualobj=##class(DHCMGNUR.QualCodeItem).%OpenId(obj.CheckCode)
 	......s QualDesc=qualobj.QualDesc
 	.....e  i obj.QType="C" d
 	......s modelobj=##class(DHCMGNUR.MgNurQcModel).%OpenId(obj.CheckCode)
 	......s QualDesc=modelobj.ModelName
 	.....s Score=obj.Score
 	.....s CheckDate=$zd(obj.RDate,3)
 	.....s CheckUser=$P(..getsuser(obj.RUser),"!",2)
 	.....s Question=obj.CheckQuestion
 	.....s ret="CheckTyp|"_CheckTyp_"^WardLoc|"_WardLoc_"^QualDesc|"_QualDesc_"^Score|"_Score_"^CheckDate|"_CheckDate_"^CheckUser|"_CheckUser_"^Question|"_Question_"^rw|"_raw
 	.....d OutCheckScoreLst
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckScoreLst
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindChkScorelstFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindChkScorelstExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindChkScorelstClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindChkScorelstExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 问题汇总
Query ProCollectsLsts(Type, CheckCode, QualDr, WardLoc, SEDate, Statu, question) As %Query(ROWSPEC = "CheckTyp,CheckDate,WardLoc,QualDesc,Score,CheckUser,Question,rw,PatName,Status,Reason,Method,Goal,Praise,Opinion,CheckId,ReMark,QualTyp")
{
}

ClassMethod ProCollectsLstsExecute(ByRef qHandle As %Binary, Type, CheckCode, QualDr = "", WardLoc, SEDate, Statu, question) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ^TEMP("g07081356001")=Type_"%"_CheckCode_"%"_QualDr_"%"_WardLoc_"%"_SEDate_"%"_Statu_"%"_question
 	s stdate=$P(SEDate,"^",1)
 	s enddate=$P(SEDate,"^",2)
 	s date="" f  s date=$O(^Nur.CheckRoomI("Check",date)) q:date=""  d
 	.s typDesc="" f  s typDesc=$O(^Nur.CheckRoomI("Check",date,typDesc)) q:typDesc=""  d
 	..s wardloc="" f  s wardloc=$O(^Nur.CheckRoomI("Check",date,typDesc,wardloc)) q:wardloc=""  d
 	...s qual="" f  s qual=$O(^Nur.CheckRoomI("Check",date,typDesc,wardloc,qual)) q:qual=""  d
 	....s rw="" f  s rw=$O(^Nur.CheckRoomI("Check",date,typDesc,wardloc,qual,rw)) q:rw=""  d
 	.....s obj=##class(Nur.CheckRoom).%OpenId(rw)
 	.....q:(stdate'="")&&(obj.CheckDate<$zdh(stdate,3))
 	.....q:(enddate'="")&&(obj.CheckDate>$zdh(enddate,3))
 	.....i obj.CheckDate'="" s chekdate=$zd(obj.CheckDate,3)
 	.....e  s chekdate=""
 	.....q:((WardLoc'="")&&(obj.WardLoc'=WardLoc))
 	.....i $G(^CTLOC(obj.WardLoc))'="" s Ward=$P(^CTLOC(obj.WardLoc),"^",2)
 	.....e  s Ward=""
 	.....s QualDesc=obj.CheckTyp
 	.....i obj.CheckTyp="夜查房" s QualTyp="NightChk"
 	.....e  i obj.CheckTyp="随机督查" s QualTyp="DayChk"
 	.....q:((CheckCode'="")&&($zcvt(QualTyp,"U")'=CheckCode))
 	.....s Question=obj.CheckQuestion
 	.....s CheckTyp=""
 	.....i obj.CheckQual'="" d
 	......s qualObj=##class(DHCMGNUR.QuCheckWard).%OpenId(obj.CheckQual)
 	......i qualObj.CheckLevel'="" s CheckTypTmp=qualObj.CheckLevel
 	......;i qualObj.CheckLevel="H" s CheckTyp="护理部"
 	......;e  i qualObj.CheckLevel="W" s CheckTyp="病区"
 	......;e  i qualObj.CheckLevel="Z" s CheckTyp="科护士长"
 	......e  s CheckTypTmp=""
 	.....q:(Type'="")&&(CheckTypTmp'="")&&(CheckTypTmp'=Type)
 	.....i CheckTypTmp="H" s CheckTyp="护理部"
 	.....e  i CheckTypTmp="W" s CheckTyp="病区"
 	.....e  i CheckTypTmp="Z" s CheckTyp="科护士长"
 	.....q:((Statu'="")&&(obj.Status'=Statu))
 	.....i ((obj.Status="1")!(obj.Status="")) s statu="待处理"
 	.....e  i obj.Status="2" s statu="处理中"
 	.....e  i obj.Status="3" s statu="已解决"
 	.....e  i obj.Status="4" s statu="问题上诉"
 	.....e  s statu=""
 	.....d OutputLst
 
 	s date="" f  s date=$O(^Nur.QualCheckRecI("Check",date)) q:date=""  d
 	.s qutyp="" f  s qutyp=$O(^Nur.QualCheckRecI("Check",date,qutyp)) q:qutyp=""  d
 	..s wardloc="" f  s wardloc=$O(^Nur.QualCheckRecI("Check",date,qutyp,wardloc)) q:wardloc=""  d
 	...s qualcode="" f  s qualcode=$O(^Nur.QualCheckRecI("Check",date,qutyp,wardloc,qualcode)) q:qualcode=""  d
 	....s rw="" f  s rw=$O(^Nur.QualCheckRecI("Check",date,qutyp,wardloc,qualcode,rw)) q:rw=""  d
 	.....s QuObj=##class(Nur.QualCheckRec).%OpenId(rw)
 	.....q:(stdate'="")&&(QuObj.CheckDate<$zdh(stdate,3))
 	.....q:(enddate'="")&&(QuObj.CheckDate>$zdh(enddate,3))
 	.....i QuObj.CheckDate'="" s chekdate=$ZD(QuObj.CheckDate,3)
 	.....e  s chekdate=""
 	.....i QuObj.ChkType="QualSelfCheck" s QualDesc="病区自查",QualTyp="QualSelfCheck"
 	.....e  i QuObj.ChkType="QualCheck" s QualDesc="质控查房",QualTyp="QualCheck"
 	.....e  s QualDesc="",QualTyp=""
 	.....q:((CheckCode'="")&&($zcvt(QualTyp,"U")'=CheckCode))
 	.....s CheckTyp=""
 	.....i QuObj.CheckQual'="" d
 	......s mgObj=##class(DHCMGNUR.MgCheckWard).%OpenId(QuObj.CheckQual)
 	......q:mgObj=""
 	......i mgObj.NurTyp'="" s CheckTypTmp=mgObj.NurTyp
 	......;i mgObj.NurTyp="H" s CheckTyp="护理部"
 	......;e  i mgObj.NurTyp="W" s CheckTyp="病区"
 	......;e  i mgObj.NurTyp="Z" s CheckTyp="科护士长"
 	......e  s CheckTypTmp=""
 	.....q:((Type'="")&&(CheckTypTmp'="")&&(CheckTypTmp'=Type))
 	.....i CheckTypTmp="H" s CheckTyp="护理部"
 	.....e  i CheckTypTmp="W" s CheckTyp="病区"
 	.....e  i CheckTypTmp="Z" s CheckTyp="科护士长"
 	.....q:((WardLoc'="")&&(QuObj.WardLoc'=WardLoc))
 	.....i $G(^CTLOC(QuObj.WardLoc))'="" s Ward=$P(^CTLOC(QuObj.WardLoc),"^",2)
 	.....e  s Ward=""
 	.....s Question=QuObj.CheckQuestion
 	.....q:((Statu'="")&&(QuObj.Status'=Statu))
 	.....i ((QuObj.Status="1")!(QuObj.Status="")) s statu="待处理"
 	.....e  i QuObj.Status="2" s statu="处理中"
 	.....e  i QuObj.Status="3" s statu="已解决"
 	.....e  i QuObj.Status="4" s statu="问题上诉"
 	.....e  s statu=""
 	.....d OutputLst
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputLst
	set Data=$lb(CheckTyp,chekdate,Ward,QualDesc,Score,CheckUser,Question,rw,PatName,statu,$g(Reason),$g(Method),$g(Goal),$g(Praise),$g(Opinion),$g(CheckId),$g(ReMark),QualTyp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ProCollectsLstsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ProCollectsLstsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ProCollectsLstsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ProCollectsLstsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
