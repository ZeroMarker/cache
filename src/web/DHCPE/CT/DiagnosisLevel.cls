Import SQLuser

/// 名称: 建议级别维护
/// 编写者：xy
/// 编写日期: 2021-08-04
Class web.DHCPE.CT.DiagnosisLevel Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description: 查询建议级别
/// Table：建议级别表 User.DHCPEEDClass 
/// Input: Code(级别), Desc(描述),NoActiveFlag(作废), tableName(表名), LocID(科室下拉列表值)
/// Return：
/// Creator：xy 
/// CreatDate：20210804
/// debug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.DiagnosisLevel","LevelAll","","","N","DHC_PE_EDClass","152")
Query LevelAll(Code As %String, Desc As %String, NoActiveFlag As %String = "Y", tableName As %String, LocID As %String) As websys.Query(ROWSPEC = "TRowID:%String,TLevel:%String,TDesc:%String,TEmpower:%String,TEffPowerFlag,TNoActive,TUpdateDate,TUpdateTime,TUserName")
{
}

ClassMethod LevelAllExecute(ByRef qHandle As %Binary, Code As %String, Desc As %String, NoActiveFlag As %String = "Y", tableName As %String, LocID As %String) As %Status
{
	s ^tempdhcpe("LevelAll")=$lb(Code,Desc,NoActiveFlag,tableName, LocID)
	
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
   
    s id=0
    f  s id=$O(^DHCPEEDC(id)) q:id=""  d
    .s EDCLevel=$p($g(^DHCPEEDC(id)),"^",1)
    .q:(Code'="")&&(EDCLevel'[Code)
    .S EDCDesc=$p($g(^DHCPEEDC(id)),"^",2)
    .q:(Desc'="")&&(EDCDesc'[Desc)
    .s LocShowDFlag=##class(User.DHCPEEDClass).GetLocShowDataFlag(id,LocID)
    .q:LocShowDFlag="N"
    .s EmpowerStr=##class(User.DHCPEEDClass).GetEmpowerFlag(id,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    .s NoActive=$p($g(^DHCPEEDC(id)),"^",3)
    .i NoActive="" s NoActive="Y"
    .q:(NoActiveFlag'="")&&(NoActiveFlag'=NoActive)
    .s UpdateDate=$p($g(^DHCPEEDC(id)),"^",4)
    .i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    .s UpdateTime=$p($g(^DHCPEEDC(id)),"^",5)
    .i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    .s UserDR=$p($g(^DHCPEEDC(id)),"^",6)
    .i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
    
    .;d TranslateLevelAll
    .s ^CacheTemp(repid,ind)=$lb(id,EDCLevel,EDCDesc,Empower,EffPowerFlag,NoActive,UpdateDate,UpdateTime,UserName)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
TranslateLevelAll
	s EDCDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEEDClass",EDCDesc,"EDCDesc","cls")
	s UserName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",UserName,"SSUSRName","cls")
}

/// Creator：     xy 
/// CreatDate：  20210804
/// Description: 建议级别插入数据
/// Table：      建议级别表 User.DHCPEEDClass 
/// Input:       level(级别), Desc(描述), NoActive(作废), tableName(表名), 
///              LocID(科室下拉列表值), UserID（当前登陆人员ID）, Empower（是否单独授权）
/// Return：
/// debug：w ##class(web.DHCPE.CT.DiagnosisLevel).Insert("110","测试10","DHC_PE_EDClass","152","12187","Y")
ClassMethod Insert(level As %String, Desc As %String, NoActive As %String = "N", tableName As %String, LocID As %String, UserID As %String, Empower As %String = "N")
{
   s ^tempdhcpe("Insert")=$lb(level,Desc,NoActive,tableName,LocID,UserID,,Empower)
   n (level,Desc,tableName,LocID,UserID,Empower)
   s $ZT="InsertErr"
   s result=1
   s Date=$p($h,",",1) 
   s Time=$p($h,",",2)  
   TSTART
  	&sql(insert into DHC_PE_EDClass(EDC_Code, EDC_Desc,EDC_NoActive,EDC_UpdateDate,EDC_UpdateTime,EDC_UpdateUserDR)
	    values (:level,:Desc,:NoActive,:Date,:Time,:UserID))
	   ;b ; SQLCODE
 	//诊断建议表插入数据失败
     If (SQLCODE'=0)	 
      { 
        s result="-1^插入诊断表失败"
        goto InsertErr
		
       }
   	i (SQLCODE=0) {
   		s RowID=%ROWID
   		;b ;tableName,RowID,LocID,UserID,Empower
   		
   		s ret=##class(User.DHCPEEDClass).SaveDataToPowerControl(RowID,LocID,UserID,Empower)
   		//表记录授权插入数据失败
    	If ($p(ret,"^",1)="-1")	 
    	{ 
        	s result="-1^插入记录授权表失败"
        	goto InsertErr
		
   		}else{
	   		s OldRecord=""
   	    	s NewRecord=$g(^DHCPEEDC(RowID))
   	    	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_EDClass",RowID,"I",OldRecord,NewRecord,UserID)
			if ($p(Logret,"^",1)="-1"){
				s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        		goto InsertErr
			}
   		}	
   		
   	}
	
    
	TCommit
        s result="0^插入成功"
        q result  
InsertErr
	
	TROLLBACK 
	//q $ZE
    q result
}

/// Creator：     xy 
/// CreatDate：   20210807
/// Description:  更新建议级别数据
/// Table：       建议级别表 User.DHCPEEDClass 
/// Input:        rowid(数据ID),level(级别), Desc(描述), NoActive(作废), UserID(当前登陆人ID), 
///               Empower（是否单独授权）
/// Return：
/// debug：w ##class(web.DHCPE.CT.DiagnosisLevel).Update("80","112","测试112","N","12187","DHC_PE_EDClass","152","Y")
ClassMethod Update(rowid As %String = "", level As %String = "", Desc As %String = "", NoActive As %String = "", UserID As %String = "", tableName As %String, LocID As %String, Empower As %String)
{
   s ^tempdhcpe("Update")=$lb(rowid,level,Desc,NoActive,UserID,tableName,LocID,Empower)
   n (rowid,level,Desc,NoActive,UserID,tableName,LocID,Empower)
   
   s $ZT="UpdateErr"
   s result=0
   
   TSTART
   s OldRecord=$g(^DHCPEEDC(rowid))
   s $p(^DHCPEEDC(rowid),"^",1)=level
   s $p(^DHCPEEDC(rowid),"^",2)=Desc
   s $p(^DHCPEEDC(rowid),"^",3)=NoActive
   s $p(^DHCPEEDC(rowid),"^",4)=$p($h,",",1)
   s $p(^DHCPEEDC(rowid),"^",5)=$p($h,",",2)
   s $p(^DHCPEEDC(rowid),"^",6)=UserID
   
   s ret=##class(User.DHCPEEDClass).SaveDataToPowerControl(rowid,LocID,UserID,Empower)
   	b ;ret
   	//表记录授权插入/更新数据失败
    If ($p(ret,"^",1)="-1")	 
    { 
        s result="-1^插入记录授权表失败"
        goto UpdateErr
		
   	}else{
   	    s NewRecord=$g(^DHCPEEDC(rowid))
   	    if (OldRecord'=NewRecord) {
   	    	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_EDClass",rowid,"U",OldRecord,NewRecord,UserID)
			if ($p(Logret,"^",1)="-1"){
				s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        		goto UpdateErr
			}
   	    }
   	    	  
   	}
  TCommit
     s result="0^更新数据成功"
     q result  
UpdateErr
	TROLLBACK 
	//q $ZE
    q result
}

}
