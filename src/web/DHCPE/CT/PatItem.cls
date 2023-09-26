/// 名称: 导诊单分类维护
/// 编写者：xy
/// 编写日期: 2021-08-15
Class web.DHCPE.CT.PatItem Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 查询导诊单类别
/// Table：导诊单分类表 DHC_PE_UsherItemCat 
/// Input: LocID(科室ID),Desc(分类描述),NoActive(作废)
/// Return：
/// Creator：xy 
/// CreatDate：20210815
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.PatItem","FindPatItem","1","")
Query FindPatItem(LocID As %String = "", Desc As %String = "", NoActive As %String = "Y") As websys.Query(ROWSPEC = "TID,TCategory,TSort,TPlace,TDocSignName,TPatSignName,TNoActive,TUpdateDate,TUpdateTime,TUserName")
{
}

ClassMethod FindPatItemExecute(ByRef qHandle As %Binary, LocID As %String = "", Desc As %String = "", NoActive As %String = "Y") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    s ^tempdhcpe("FindPatItem")=$lb(LocID,Desc,NoActive)
    s Category=""
    f  s Category=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID,Category)) q:Category=""  d
    .s ID=""
    .f  s ID=$O(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID,Category,ID))  q:ID=""  d
    ..s PICategory=$lg($g(^CF.PE.UsherItemCatD(ID)),3)
    ..q:(Desc'="")&&(PICategory'[Desc)
    ..s Sort=$lg($g(^CF.PE.UsherItemCatD(ID)),4)
    ..s Place=$lg($g(^CF.PE.UsherItemCatD(ID)),5)
    ..s DocSignName=$lg($g(^CF.PE.UsherItemCatD(ID)),6)
    ..s PatSignName=$lg($g(^CF.PE.UsherItemCatD(ID)),7)
    ..s PINoActive=$lg($g(^CF.PE.UsherItemCatD(ID)),8)
    ..i PINoActive="" s PINoActive="Y"
    ..q:(NoActive'="")&&(PINoActive'=NoActive)
    ..s UpdateDate=$lg($g(^CF.PE.UsherItemCatD(ID)),9)
    ..i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    ..s UpdateTime=$lg($g(^CF.PE.UsherItemCatD(ID)),10)
    ..i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    ..s UserDR=$lg($g(^CF.PE.UsherItemCatD(ID)),11)
    ..i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
    ..;d TranslateFindPatItem
	..s ^CacheTemp(repid,ind)=$lb(ID,PICategory,Sort,Place,DocSignName,PatSignName,PINoActive,UpdateDate,UpdateTime,UserName)
	..s ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TranslateFindPatItem
	s PICategory=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEUsherItemCat",PICategory,"PICategory","cls")
	s Place=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEUsherItemCat",Place,"PIPlace","cls")
	s UserName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",UserName,"SSUSRName","cls")
}

/// Description: 导诊单类别新增/更新数据
/// Table：导诊单分类表 DHC_PE_UsherItemCat
/// Input: InfoStr(信息拼串)，tableName(表名)
/// Return：
/// Creator：xy 
/// CreatDate：20210815
/// dubug：w ##class(web.DHCPE.CT.PatItem).SavePatItem()
ClassMethod SavePatItem(InfoStr As %String = "", tableName As %String = "")
{
	s ^tempdhcpe("SavePatItem")=$lb(InfoStr,tableName)
	s $ZT="SavePatItemErr"
	s result=1	
	s Date=+$h
	s Time=$p($h,",",2)
	
	S ID=$P(InfoStr,"^",1)
	s Category=$P(InfoStr,"^",2)
	s Sort=$P(InfoStr,"^",3)
	s Place=$P(InfoStr,"^",4)
	s DocSignName=$P(InfoStr,"^",5)
	s PatSignName=$P(InfoStr,"^",6)
	s NoActive=$P(InfoStr,"^",7)
	s LocID=$P(InfoStr,"^",8)
	s UserID=$P(InfoStr,"^",9)
	
	
	if ID="" d
	.s obj=##class(User.DHCPEUsherItemCat).%New()
	e  d
	.s obj=##class(User.DHCPEUsherItemCat).%OpenId(ID)
	
	s obj.PILocDR=LocID
	s obj.PICategory=Category
	s obj.PISort=Sort
	s obj.PIPlace=Place
	s obj.PIDocSignName=DocSignName
	s obj.PIPatSignName=PatSignName
	s obj.PINoActive=NoActive
	s obj.PIUpdateDate=Date
	s obj.PIUpdateTime=Time
	s obj.PIUpdateUserDR=UserID

    TSTART
	s sc=obj.%Save()
	d obj.%Close()
	;b ;obj.%Id()
	If ($System.Status.IsError(sc))	 
     { 
        s result="-1^保存导诊单分类失败"
        goto SavePatItemErr
		
      }else{
	      //表里面有科室字段，无需再给记录授权表插入数据
	    /*
       if (ID="") {     
   			s RowID=obj.%Id()
   			;b ;tableName,RowID,LocID,UserID
   			s ret=##class(User.DHCPEUsherItemCat).SaveDataToPowerControl(RowID,LocID,UserID)
   			//表记录授权插入数据失败
    		If ($p(ret,"^",1)="-1")	 
    		{ 
        		s result="-1^插入记录授权表失败"
        		goto SavePatItemErr
		
   			 }
       }  
       */ 		
   		
   	}
	   
	TCommit
        s result="0^保存成功"
        q result  
SavePatItemErr
	TROLLBACK 
	//q $ZE
    q result
}

}
