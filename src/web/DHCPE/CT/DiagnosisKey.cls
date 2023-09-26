Import SQLuser

/// 名称: 建议关键词维护
/// 编写者：yupeng
/// 编写日期: 2021-08-04
Class web.DHCPE.CT.DiagnosisKey Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：    yupeng
/// CreatDate：  20210804
/// Description: 查询建议关键词
/// Table：		 建议关键词表 User.DHCPEEDKey 
/// Input:       Desc(关键词), Color(颜色), NoActiveFlag(作废), tableName(表名), LocID(科室下拉列表值)
/// Return：
/// Dubug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.DiagnosisKey","KeyAll","","","N","DHC_PE_EDKey","152")
Query KeyAll(Desc As %String, Color As %String, NoActiveFlag As %String, tableName As %String, LocID As %String) As websys.Query(ROWSPEC = "TRowID:%String,TDesc:%String,TColor:%String,TEmpower:%String,TEffPowerFlag:%String,TNoActive:%String,TUpdateDate:%String,TUpdateTime:%String,TUserName:%String")
{
}

ClassMethod KeyAllExecute(ByRef qHandle As %Binary, Desc As %String, Color As %String, NoActiveFlag As %String, tableName As %String, LocID As %String) As %Status
{
    
    //s ^tempdhcpe("KeyAll")=$lb(Desc,Color,NoActiveFlag,tableName,LocID)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
   
    s id=0
    f  s id=$O(^User.DHCPEEDKeyD(id)) q:id=""  d
    .s EDKDesc=$lg(^User.DHCPEEDKeyD(id),2)
    .q:(Desc'="")&&(EDKDesc'[Desc)
    .S EDKColor=$lg(^User.DHCPEEDKeyD(id),3)
    .q:(Color'="")&&(EDKColor'[Color)
    .s LocShowDFlag=##class(User.DHCPEEDKey).GetLocShowDataFlag(id,LocID)
    .q:LocShowDFlag="N"
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    .s EmpowerStr=##class(User.DHCPEEDKey).GetEmpowerFlag(id,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s NoActive=$lg(^User.DHCPEEDKeyD(id),4)
    .i NoActive="" s NoActive="Y"
    .q:NoActiveFlag'=NoActive
    .s UpdateDate=$lg(^User.DHCPEEDKeyD(id),5)
    .i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    .s UpdateTime=$lg(^User.DHCPEEDKeyD(id),6)
    .i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    .s UserDR=$lg(^User.DHCPEEDKeyD(id),7)
    .i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
    .;d TranslateKeyAll
    .s ^CacheTemp(repid,ind)=$lb(id,EDKDesc,EDKColor,Empower,EffPowerFlag,NoActive,UpdateDate,UpdateTime,UserName)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
TranslateKeyAll
	s EDKDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEEDKey",EDKDesc,"EDKDesc","cls")
	s UserName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",UserName,"SSUSRName","cls")
}

/// Creator：    xueying
/// CreatDate：  20211105
/// Description: 判断科室组下是否有重复的建议关键词
/// Table：      建议关键词表 User.DHCPEEDKey 
/// Input:       LocID(科室下拉列表值)             
/// Return：     0/1
/// Dubug： w ##class(web.DHCPE.CT.DiagnosisKey).IsExsistEDDesc("正常","152")
ClassMethod IsExsistEDDesc(EDKDesc As %String, LocID As %String)
{
	s flag=0
	s EDID=""
	f  s EDID=$o(^User.DHCPEEDKeyI("EDKDescIndex"," "_EDKDesc,EDID))  q:(EDID="")||(flag=1)  d
	.s LocShowDFlag=##class(User.DHCPEEDKey).GetLocShowDataFlag(EDID,LocID)
    .q:LocShowDFlag="N"
    .i EDID'="" s flag=1
    q flag
}

/// Creator：    yupeng
/// CreatDate：  20210804
/// Description: 建议关键词更新数据
/// Table：      建议关键词表 User.DHCPEEDKey 
/// Input:       Color(颜色), Desc(关键词), NoActive(作废), tableName(表名), 
///              LocID(科室下拉列表值), UserID（当前登陆人员ID）, Empower（是否单独授权）
/// Return：     result
/// Dubug： w ##class(web.DHCPE.CT.DiagnosisKey).Update("1","red1","测试","N","DHC_PE_EDKey","152","12187","N")
ClassMethod Update(RowId As %String, Color As %String, Desc As %String, NoActive As %String = "N", tableName As %String, LocID As %String, UserID As %String, Empower As %String = "N")
{
   s ^tempdhcpekey("Update")=$lb(RowId,Color,Desc,NoActive,tableName,LocID,UserID,Empower)
   n (RowId,Color,Desc,NoActive,tableName,LocID,UserID,Empower)
   s $ZT="UpdateErr"
   s result=1
   s Date=+$h
   s Time=$p($h,",",2) 
   s EDDesc=""  
   TSTART
    
    i RowId="" d
    .s obj=##class(User.DHCPEEDKey).%New()
    e  d
    .s OldRecord=$ListToString($g(^User.DHCPEEDKeyD(RowId)))
    .s obj=##class(User.DHCPEEDKey).%OpenId(RowId)
    .s EDDesc=$lg($g(^User.DHCPEEDKeyD(RowId)),2)
	//q:(EDDesc'=Desc)&&($d(^User.DHCPEEDKeyI("EDKDescIndex"," "_Desc))) "0^关键字重复!"
	//由于建议关键字是私有数据，因为不同科室组下面的关键字有可能是重复的,
	//因此将关键字索引的唯一性去掉,采用下面的方法进行判断
	if (EDDesc'=Desc) {
    	s ExsistFlag=##class(web.DHCPE.CT.DiagnosisKey).IsExsistEDDesc(Desc,LocID)
    	q:ExsistFlag=1 "-1^建议关键字重复!"
	}
	
    s obj.EDKDesc=Desc
    s obj.EDKColor=Color
    s obj.EDKNoActive=NoActive
    s obj.EDKUpdateDate=Date
    s obj.EDKUpdateTime=Time
    s obj.EDKUpdateUserDR=UserID
    
    s sc=obj.%Save()
    d obj.%Close()
    
    If ($System.Status.IsError(sc)) 
    {
        s result="-1^更新关键词失败:"_$System.Status.GetErrorText(sc)
        goto UpdateErr
    }
    
    else 
    {
	    
        s NewRowId=obj.%Id()
        s ret=##class(User.DHCPEEDKey).SaveDataToPowerControl(NewRowId,LocID,UserID,Empower)
        //表记录授权插入数据失败
        If ($p(ret,"^",1)="-1")  
        { 
            s result="-1^插入记录授权表失败"
            goto UpdateErr
        }
        
        if (RowId=""){	
   	    	s OldRecord=""
   	    	s NewRecord=$ListToString($g(^User.DHCPEEDKeyD(NewRowId)))
   	    	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_EDKey",NewRowId,"I",OldRecord,NewRecord,UserID)
   	    
			if ($p(Logret,"^",1)="-1"){
				s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        		goto UpdateErr
			}
   	    }else{
   	    	s NewRecord=$ListToString($g(^User.DHCPEEDKeyD(NewRowId)))
   	    	if (OldRecord'=NewRecord) {
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_EDKey",NewRowId,"U",OldRecord,NewRecord,UserID)
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        			goto UpdateErr
				}
   	    	}
   	    }	  
        
        
    }
    
    
    TCommit
       s result="0^保存成功"
       q result  
UpdateErr
    s $ZT=""
    TROLLBACK 
    q result_$ZE
}

}
