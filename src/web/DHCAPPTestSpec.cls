Class web.DHCAPPTestSpec Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      yuliping
/// CreatDate：    2017-07-08
/// Description:   分页显示 病理标本字典表
/// Table：        DHC_APPTestSpec
/// Input：	       page：当前页数
///                rows：每页条数 
/// Return：       json
/// w ##class(web.DHCAPPTestSpec).ListAPPTestSpec("1","10","","")
ClassMethod ListAPPTestSpec(page = 1, rows = 10, ATSCode, ATSDesc, HospID)
{
	
	n (page,rows,ATSCode,ATSDesc,HospID)
	
	s start=(page-1)*rows+1
	s end=page*rows
	s count=0
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	w "{""rows"":["
	s ATSid=""
	f  s ATSid=$o(^DHCAPPTS(ATSid))  q:ATSid=""  d
	.q:ATSid=0
	.s msg=$g(^DHCAPPTS(ATSid))
	.q:msg=""
	.s code=$p(msg,"^",1)			//项目代码
	.s desc=$p(msg,"^",2)			//项目描述
	.s CatDr=$p(msg,"^",3)     	    //检查分类
	.s HospDr=$p(msg,"^",4)			//医院标识
	.q:((HospID'="")&&(HospID'=HospDr))
	.s ActiveFlag=$p(msg,"^",5)		//是否可用
	.s ActiveFlagCode=ActiveFlag
	.s ActiveFlag=$s(ActiveFlag="Y":"是",ActiveFlag="N":"否",1:"")
	.s MulFlag=$p(msg,"^",6)		//是否支持多选 bianshuai 2018-01-18
	.s MulFlagCode=MulFlag
	.s MulFlag=$s(MulFlag="Y":"是",MulFlag="N":"否",1:"")
	.s CatInsFlag=$p(msg,"^",7)		//是否支持多选 bianshuai 2018-01-18
	.s CatInsFlagCode=CatInsFlag
	.s CatInsFlag=$s(CatInsFlag="Y":"是",CatInsFlag="N":"否",1:"")
	.s CatDesc=""
	.s HospDesc=""
	.i (+HospDr'=0)  s HospDesc=$P(^CT("HOSP",HospDr),"^",2)
	.i (+CatDr'=0) s CatDesc=$p($g(^DHCAPPTC(CatDr)),"^",2)								   //检查分类描述
	 
	.s tmp=code_"^"_desc_"^"_CatDesc_"^"_HospDesc_"^"_ActiveFlag_"^"_CatDr_"^"_HospDr_"^"_ATSid_"^"_MulFlag_"^"_ActiveFlagCode_"^"_MulFlagCode_"^"_CatInsFlag_"^"_CatInsFlagCode
	.q:(ATSCode'="")&(code'[ATSCode)
	.q:(ATSDesc'="")&(desc'[ATSDesc)
	.s count=count+1
	.q:count<start
	.q:count>end
	.w $case(count,start:"",:",") 
	.w ##class(web.DHCAPPJsonCommon).getJsonData("ATSCode^ATSDesc^CatDesc^HospDesc^ActiveFlag^CatDr^HospDr^ATSid^MulFlag^ActiveFlagCode^MulFlagCode^CatInsFlag^CatInsFlagCode",tmp)
	w "],""total"":"_count_"}"
	q ""
}

/// w ##class(web.DHCAPPTestSpec).SaveUpdTestSpec("test^test^^2^Y^Y^0^0^0^Y^Y")
ClassMethod SaveUpdTestSpec(params, HospID)
{
    n (params,HospID)
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..SaveOrUpdate(str,HospID)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Creator：      yuliping
/// CreatDate：    2017-07-08
/// Description:   更新或添加 病理标本字典表
/// Table：        DHC_APPTestSpec
/// Input：	       page：当前页数
///                rows：每页条数 
/// Return：       json
/// w ##class(web.DHCAPPTestSpec).SaveOrUpdate("6666^666^2^2^Y^Y^0^0^0^Y^Y")
ClassMethod SaveOrUpdate(str, HospID)
{
	 n (str,HospID)
	 s ValueFlag=0,isIN=0,isINC=0		
	 s Code=$p(str,"^",1)				//项目代码
	 s Desc=$p(str,"^",2)				//项目描述
	 s CatDesc=$p(str,"^",3)			//标本所属分类
	 s HospDesc=$p(str,"^",4)			//医院标识
	 s ActiveFlag=$p(str,"^",6)			//是否可用
	 s CatDr=$p(str,"^",7)
	 s HospDr=HospID
	 s ID=$p(str,"^",9)
	 s MulFlag=$p(str,"^",11)            /// 是否支持多选 bianshuai 2018-01-18
	 s CatInsFlag=$p(str,"^",13)            /// 是否为穿刺
	 
	 i ((+CatDesc=0)&&(CatDesc'=0)) s CatDesc=CatDr
	 i ((+HospDesc=0)&&(HospDesc'=0)) s HospDesc=HospDr
	 
	 s ret=..CheckRepeat(str,HospID)
	 Q:(ret="-1")||(ret="-3") 1
	 Q:(ret="-2")||(ret="-4") 2
	 i +ID=0  d											//id为空，新建对象
	 .s obj=##class(User.DHCAppTestSpec).%New()
	 e  d
	 .s obj=##class(User.DHCAppTestSpec).%OpenId(ID)	//id不为空，打开对象
	 
	 
	 q:(isIN=1) 1
	 q:(isINC=1) 2													//保存数据
	 s obj.ATSHospDr=##class(User.CTHospital).%OpenId(HospDesc)
	 s obj.ATSCode=Code 
	 s obj.ATSDesc=Desc
 	 s obj.ATSCatDr=##class(User.DHCAppArcCat).%OpenId(CatDesc)
 	 s obj.ATSActiveFlag=ActiveFlag
 	 s obj.ATSMulFlag=MulFlag
 	 s obj.ATSCatIns=CatInsFlag
     s sc=obj.%Save()  
     
	 ;i $$$ISERR(sc) q -2
	 q 0
}

/// Creator：  sufan
/// CreatDate: 2017-07-06
/// Descript:  检查代码、描述是否重复
/// Table：    User.DHCAppTreMet
/// Others：   w ##class(web.DHCAPPTreMet).CheckRepeat("痰液^恩恩^^东华标准版数字化医院[总院]^Y^Y^0^0^0^Y^Y^否^N")
ClassMethod CheckRepeat(ItmTempStr As %String, HospID As %String = "") As %String
{
	n (ItmTempStr,HospID)
	s ret=0
	s ID=$p(ItmTempStr,"^",9)   	 ///ID
	s ATCode=$p(ItmTempStr,"^",1)  	 ///代码
	s ATDesc=$p(ItmTempStr,"^",2) 	 ///描述
	//s HospDesc=$p(ItmTempStr,"^",8)	 ///医院ID
	//s HospID=$p(ItmTempStr,"^",4)			//医院标识
	
	//i ((+HospID=0)&&(HospID'=0)) s HospID=HospDesc
		 
		 
	/// 新记录
	if ID=""  d
	.i $d(^DHCAPPTS(0,"Code",$$ALPHAUP^SSUTIL4((ATCode))))   d
	..s ATID=""
	..for  s ATID=$o(^DHCAPPTS(0,"Code",$$ALPHAUP^SSUTIL4(ATCode),ATID)) q:(ATID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTS(ATID),"^",4)
	...q:HospDr'=HospID
	...s ret=-1
	..
	.
	.i $d(^DHCAPPTS(0,"Desc",$$ALPHAUP^SSUTIL4(ATDesc)))  d
	..s ATID=""
	..f  s ATID=$o(^DHCAPPTS(0,"Desc",$$ALPHAUP^SSUTIL4(ATDesc),ATID))  q:(ATID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTS(ATID),"^",4)
	...q:HospDr'=HospID
	...s ret=-2
	..
	.
	/// 修改记录
	else  d
	.s Code=$p($g(^DHCAPPTS(ID)),"^",1)    //代码
	.s Desc=$p($g(^DHCAPPTS(ID)),"^",2)    //描述
	.i (Code'=ATCode)&($d(^DHCAPPTS(0,"Code",$$ALPHAUP^SSUTIL4(ATCode))))  d
	..s ATID=""
	..f  s ATID=$o(^DHCAPPTS(0,"Code",$$ALPHAUP^SSUTIL4(ATCode),ATID)) q:(ATID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTS(ATID),"^",4)
	...q:HospDr'=HospID
	...s ret=-3
	..
	.
	.i (Desc'=ATDesc)&($d(^DHCAPPTS(0,"Desc",$$ALPHAUP^SSUTIL4(ATDesc))))  d
	..s ATID=""
	..f  s ATID=$o(^DHCAPPTS(0,"Desc",$$ALPHAUP^SSUTIL4(ATDesc),ATID)) q:(ATID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTS(ATID),"^",4)
	...q:HospDr'=HospID
	...s ret=-4
	..
	.
	q ret
}

/// Creator：      yuliping
/// CreatDate：    2017-07-07
/// Description:   删除 病理标本字典表
/// Table：        DHC_APPTestSpec
/// Input：	      
///                
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败 
/// d ##class(web.DHCAPPTestSpec).RemoveTestSpec("")
ClassMethod RemoveTestSpec(Id)
{
	n (Id)
  
	q:+Id=0 -1
	s obj=##class(User.DHCAppTestSpec).%DeleteId(Id)
	q 0
}

/// 关联医嘱项目
/// w ##class(web.DHCAppPisDicRelationBLMap).InsertAppTestSpecRelArc("003","ceshi","script")
ClassMethod InsertAppTestSpecRelArc(TestSpec, TestSpecArc)
{
	Q:$d(^DHCAppTestSpecRelArc("AppTest",TestSpec,TestSpecArc)) "-1"
	&SQL(insert into SQLUser.DHCAppTestSpecRelArc 
		(App_TestSpec,App_TestSpecArc
		) Values(:TestSpec,:TestSpecArc))
	s rtn=SQLCODE
	q rtn
}

ClassMethod DelectAppTestSpecRelArc(RowID As %String)
{
	q:RowID="" ""
	&SQL(DELETE SQLUser.DHCAppTestSpecRelArc where RowID=:RowID)
	s rtn=SQLCODE
	q rtn
}

Query FindAppTestSpecRelArc(PisDicItem) As %Query(ROWSPEC = "RowID:%String,arcimid:%String,arcitmdesc:%String,arcitmcode:%String")
{
}

ClassMethod FindAppTestSpecRelArcClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAppTestSpecRelArcExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAppTestSpecRelArcFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAppTestSpecRelArcExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAppTestSpecRelArcExecute(ByRef qHandle As %Binary, PisDicItem) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCAPPTestSpec","FindAppTestSpecRelArc",2)
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s arcimid=""
	for{
		s arcimid=$O(^DHCAppTestSpecRelArc("AppTest",PisDicItem,arcimid))
		q:arcimid=""
		s RowID=""
		for {
			s RowID=$O(^DHCAppTestSpecRelArc("AppTest",PisDicItem,arcimid,RowID))
			Q:RowID=""
			s itmmastid=$p(arcimid,"||",1)
			s itmmastver=$p(arcimid,"||",2)
			s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  //医嘱项代码
			s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  //医嘱项名称
			set Data=$lb(RowID,arcimid,arcitmdesc,arcitmcode)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod CheckForArcitem(arcimid, PisDicItem)
{
	s rtn=0
	s RowID=$O(^DHCAppTestSpecRelArc("AppTest",PisDicItem,arcimid,""))
	if RowID'="" s rtn=1
	q rtn
}

Query FindArcItem(HospID As %String = "") As %Query(ROWSPEC = "arcimid:%String ,arcitmdesc:%String,arcitmcode:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCAPPTestSpec","FindArcItem")
ClassMethod FindArcItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArcItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcItemExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCAPPTestSpec","FindArcItem",2)
ClassMethod FindArcItemExecute(ByRef qHandle As %Binary, HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	k FindArcItemList
	s TraID=0
	for {
		s TraID=$O(^DHCAPPTRA(TraID))
		q:TraID=""
		///只显示病理
		continue:$P(^DHCAPPTRA(TraID),"^",10)'="P"
		continue:$P(^DHCAPPTRA(TraID),"^",5)'=HospID
		s CH=0
		f  {
			s CH=$o(^DHCAPPTRA(TraID,"I",CH)) 
			q:CH=""  
			s arcimid=$p(^DHCAPPTRA(TraID,"I",CH),"^",2)
			continue:$d(FindArcItemList(arcimid))
			s ArcimClassification=##class(web.DHCDocOrderCommon).GetArcimClassification(arcimid)
			continue:(ArcimClassification'="L")&&(ArcimClassification'="E")
			s itmmastid=$p(arcimid,"||",1)
			s itmmastver=$p(arcimid,"||",2)
			s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  //医嘱项代码
			s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  //医嘱项名称
			s FindArcItemList(arcimid)=1
			set Data=$lb(arcimid,arcitmdesc,arcitmcode)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
