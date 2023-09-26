/// 名称: 设备维护
/// 编写者：ln
/// 编写日期: 2022-06-15
Class web.DHCPE.CT.UpLoadCheckResult Extends %RegisteredObject
{

/// Creator：    ln 
/// CreatDate：  20220615
/// Description: 设备维护更新数据
/// Table：      设备维护表 DHC_PE_UpLoadResult 
/// Input: 
/// Return：
/// debug: d ##class(web.DHCPE.CT.UpLoadCheckResult).UpdateUpLoadResult()
ClassMethod UpdateUpLoadResult(ID As %String = "", InfoStr As %String)
{
	s ^tempdhcpe("UpdateUpdateUpLoadResult")=$lb(ID,InfoStr)
	s LocDR=$P(InfoStr,"^",1)
	S Code=$P(InfoStr,"^",2)
	S Desc=$P(InfoStr,"^",3)
	s URNoActive=$P(InfoStr,"^",4)
	s UserID=$P(InfoStr,"^",5)
	
	s URCode=""
	s Date=+$h
	s Time=$p($h,",",2)
	if ID="" d
	.s obj=##class(User.DHCPEUpLoadResult).%New()
	e  d
	.s obj=##class(User.DHCPEUpLoadResult).%OpenId(ID)
	.s URCode=$lg($g(^CT.PE.UpLoadResultD(ID)),3)
	q:(URCode'=Code)&&($d(^CT.PE.UpLoadResultI("IdxOfLocCode"," "_LocDR," "_Code))) "0^代码重复!"
	
	s obj.URLocDR=LocDR
	s obj.URCode=Code
	s obj.URDesc=Desc
	s obj.URNoActive=URNoActive
	s obj.URUpdateDate=Date
    s obj.URUpdateTime=Time
    s obj.URUpdateUserDR=UserID
	
	s sc=obj.%Save()
	d obj.%Close()
	if ($System.Status.IsError(sc)) {
		q "-1^"_$System.Status.GetErrorText(sc)
	} else {
		q obj.%Id()
	}
}

/// Description: 查询设备
/// Table：设备维护表 DHC_PE_UpLoadResult 
/// Input: Code(代码), Desc(描述), NoActive(作废)
/// Return：
/// Creator：ln 
/// CreatDate：20220615
/// debug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.UpLoadCheckResult","FindUpLoadResult","","","Y","105")
Query FindUpLoadResult(Code As %String = "", Desc As %String = "", NoActive As %String = "Y", LocID As %String = "") As websys.Query(ROWSPEC = "id:%String,TCode:%String,TDesc:%String,TNoActive:%String,TUpdateDate:%String,TUpdateTime:%String,TUserName:%String")
{
}

ClassMethod FindUpLoadResultExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", NoActive As %String = "Y", LocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    s ^tempdhcpe("FindUpLoadResult")=$lb(Code,Desc,NoActive)
    
    s ID=0
	f  s ID=$O(^CT.PE.UpLoadResultD(ID)) q:ID=""  d
	.s LocDR=$lg($g(^CT.PE.UpLoadResultD(ID)),2)
	.q:(LocID'="")&&(LocID'=LocDR)
	.s URCode=$lg($g(^CT.PE.UpLoadResultD(ID)),3)
	.q:(Code'="")&&(Code'=URCode)
	.s URDesc=$lg($g(^CT.PE.UpLoadResultD(ID)),4)
	.q:(Desc'="")&&(URDesc'[Desc)
	.s URNoActive=$lg($g(^CT.PE.UpLoadResultD(ID)),5)
	.i URNoActive="" s URNoActive="N"
	.q:(NoActive'=URNoActive)
	.s UpdateDate=$lg($g(^CT.PE.UpLoadResultD(ID)),6)
	.i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
	.s UpdateTime=$lg($g(^CT.PE.UpLoadResultD(ID)),7)
	.i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
	.s UserDR=$lg($g(^CT.PE.UpLoadResultD(ID)),8)
	.s UserName=""
	.i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
	.s ^CacheTemp(repid,ind)=$lb(ID,URCode,URDesc,URNoActive,UpdateDate,UpdateTime,UserName)
	.s ind=ind+1
    
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Description: 设备维护详情更新数据
/// Table：设备维护详情表 DHC_PE_LocUpLoadResult
/// Input:
/// Return：
/// Creator：ln 
/// CreatDate：20220615
/// debug:w ##class(web.DHCPE.CT.UpLoadCheckResult).UpdateLocUpLoadResult("","4^5561||1^图^aa^bb^cc^dd^ee^ff^Y^18853")
ClassMethod UpdateLocUpLoadResult(ID As %String = "", InfoStr As %String)
{
	s ^tempdhcpe("UpdateLocUpLoadResult")=$lb(ID,InfoStr)

	s $ZT="UpdateLocUpLoadResultErr"
    s result=1		
	s URDR=$P(InfoStr,"^",1)
	s ARCIM=$P(InfoStr,"^",2)
	s ImgPath=$P(InfoStr,"^",3)
	s PENoSepB=$P(InfoStr,"^",4)
	s PENoSepA=$P(InfoStr,"^",5)	
	s JCSJSepB=$P(InfoStr,"^",6)
	s JCSJSepA=$P(InfoStr,"^",7)
	s ZDYJSepB=$P(InfoStr,"^",8)
	s ZDYJSepA=$P(InfoStr,"^",9)	
	s GetTextInfo=$P(InfoStr,"^",10)
	s UserID=$P(InfoStr,"^",11)
	s Date=+$h
	s Time=$p($h,",",2)
	
	q:(ID="")&&($d(^CF.PE.LocUpLoadResultI("IdxOfLURARCIMDR"," "_URDR,ARCIM))) "-1^该设备的该医嘱已维护"
	if ID="" d
	.s obj=##class(User.DHCPELocUpLoadResult).%New()
	e  d
	.s obj=##class(User.DHCPELocUpLoadResult).%OpenId(ID)
   
	d obj.LURUpLoadResultDRSetObjectId(URDR)
	s obj.LURARCIM=ARCIM
	s obj.LURImgPath=ImgPath
	s obj.LURPENoSepB=PENoSepB
	s obj.LURPENoSepA=PENoSepA
	s obj.LURJCSJSepB=JCSJSepB
	s obj.LURJCSJSepA=JCSJSepA
	s obj.LURZDYJSepB=ZDYJSepB
	s obj.LURZDYJSepA=ZDYJSepA
	s obj.LURTextInfo=GetTextInfo
	s obj.LURUpdateDate=Date
    s obj.LURUpdateTime=Time
    s obj.LURUpdateUserDR=UserID
	 
	TSTART
	s sc=obj.%Save()
	d obj.%Close()
    
	If ($System.Status.IsError(sc)) { 
        s result="-1^保存设备详情失败"
        goto UpdateLocUpLoadResultErr
	}else{
       if (ID="") {
   			s RowID=obj.%Id()
   			
       }
   	}
   	
	TCommit
        s result="0^保存成功"
        q result  
UpdateLocUpLoadResultErr
	
	TROLLBACK 
	//q $ZE
    q result
}

/// Description: 查询设备详情
/// Table：设备详情表 DHC_PE_LocUpLoadResult
/// Input:  LURID(设备ID)
/// Return：
/// Creator：ln 
/// CreatDate：20220615
/// debug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.UpLoadCheckResult","FindLocUpLoadResult","2")
Query FindLocUpLoadResult(LURID As %String = "", ARCIMDR As %String = "") As websys.Query(ROWSPEC = "TID,TARCIM,TARCIMDesc,TImgPath,TPENoSepB,TPENoSepA,TJCSJSepB,TJCSJSepA,TZDYJSepB,TZDYJSepA,TTextInfo,TUpdateDate,TUpdateTime,TUserName")
{
}

ClassMethod FindLocUpLoadResultExecute(ByRef qHandle As %Binary, LURID As %String = "", ARCIMDR As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    s ^tempdhcpe("FindLocUpLoadResult")=$lb(LURID,ARCIMDR)
    if (LURID=""){
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
    }
    s ID=0 
	f  s ID=$O(^CF.PE.LocUpLoadResultI("IdxOfLURDR",LURID,ID)) q:ID=""  d
	.s ARCIM=$lg($g(^CF.PE.LocUpLoadResultD(ID)),3)
	.q:(ARCIMDR'="")&&(ARCIMDR'=ARCIM)
	.s ARCIMDesc=$P($G(^ARCIM(+ARCIM,$p(ARCIM,"||",2),1)),"^",2)
	.s ImgPath=$lg($g(^CF.PE.LocUpLoadResultD(ID)),4)
	.s PENoSepB=$lg($g(^CF.PE.LocUpLoadResultD(ID)),6)
	.s PENoSepA=$lg($g(^CF.PE.LocUpLoadResultD(ID)),7)
	.s JCSJSepB=$lg($g(^CF.PE.LocUpLoadResultD(ID)),8)
	.s JCSJSepA=$lg($g(^CF.PE.LocUpLoadResultD(ID)),9)
	.s ZDYJSepB=$lg($g(^CF.PE.LocUpLoadResultD(ID)),10)
	.s ZDYJSepA=$lg($g(^CF.PE.LocUpLoadResultD(ID)),11)
	.s TextInfo=$lg($g(^CF.PE.LocUpLoadResultD(ID)),5)
	.s UpdateDate=$lg($g(^CF.PE.LocUpLoadResultD(ID)),12)
    .i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    .s UpdateTime=$lg($g(^CF.PE.LocUpLoadResultD(ID)),13)
    .i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    .s UserDR=$lg($g(^CF.PE.LocUpLoadResultD(ID)),14)
    .i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
	
	.s ^CacheTemp(repid,ind)=$lb(ID,ARCIM,ARCIMDesc,ImgPath,PENoSepB,PENoSepA,JCSJSepB,JCSJSepA,ZDYJSepB,ZDYJSepA,TextInfo,UpdateDate,UpdateTime,UserName)
	.s ind=ind+1
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
