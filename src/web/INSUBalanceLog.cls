Class web.INSUBalanceLog Extends %RegisteredObject
{

/// 名称:		INSUBalanceLog
/// 描述: 		增、删、改、查的后台M方法
/// 编写者：	王辉
/// 编写日期: 	20160123
/// w ##class(web.INSUBalanceLog).SaveINSUBalanceLog("^^^^^2019-6-6^10:33:33^2019-6-6^10:33:33^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
ClassMethod SaveINSUBalanceLog(Args As %String) As %String
{
	s RtnStr=""		
	s RtnStr=$$Save^DHCINSUBalanceLog(Args)
	q RtnStr
}

ClassMethod DelINSUBalanceLog(Args As %String) As %String
{
	s RtnStr=""
	q:+Args<1 "-1"
	s RtnStr=$$Delete^DHCINSUBalanceLog(Args)
	q RtnStr
}

/// Creator：      王辉
/// CreatDate：    20160125
/// Description:： 根据开始日期、结束日期、医保类型、操作员工号查询对账记录
/// Table：        INSU_BalanceLog
/// Input：        StDate:开始日期 , EnDate:结束日期,InsuType:医保类型, UserNo:操作员工号
/// Output：       整个表中的字段值
/// Return：        
/// Others：        
/// d ##class(%ResultSet).RunQuery("web.INSUBalanceLog","QueryBalanceLog","2016-01-01","2016-03-11","","")
Query QueryBalanceLog(StDate As %String, EnDate As %String, InsuType As %String, UserNo As %String, HospId) As %Query(ROWSPEC = "INSUTypte:%String,OptDate:%String,UserDr:%String,Flag:%String,StartDate:%String,StartTime:%String,EndDate:%String,EndTime:%String,TotAmt:%String,JJZFE:%String,ZHZFE:%String,GRZFE:%String,TCZF:%String,DBZF:%String,GWYZF:%String,MZJZ:%String,INSUTotAmt:%String,INSUJJZFE:%String,INSUZHZFE:%String,INSUGRZFE:%String,INSUTCZF:%String,INSUDBZF:%String,INSUGWYZF:%String,INSUMZJZ:%String,Note:%String,Str1:%String,Str2:%String,Str3:%String,Str4:%String,Str5:%String") [ SqlProc ]
{
}

ClassMethod QueryBalanceLogExecute(ByRef qHandle As %Binary, StDate As %String, EnDate As %String, InsuType As %String, UserNo As %String, HospId) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	If $g(ind)="" Set ind=1
 	i StDate=""||EnDate="" q $$$OK
 	
 	;s StDate="63586"
 	;s EndDate="63586"
 	;i StDate["-" d  s StDate=$zdh(StDate,3)
 	;i EnDate["-" d  s EnDate=$zdh(EnDate,3)
 	s StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)	;zhan20170316
 	s EnDate=##class(websys.Conversions).DateHtmlToLogical(EnDate)	;zhan20170316
 	
 	;s ^Tmp("Log")=StDate_"^"_EnDate_"^"_InsuType_"^"_UserNo_"03/02/2015"
 	s Date="",UserRowid=""
 	f Date=StDate:1:EnDate d
 	.s INBLLRowid=0
 	.f  s INBLLRowid=$o(^DHCINBLL("0","OptDate",Date,INBLLRowid))   q:INBLLRowid=""  d
 	..s InString=^DHCINBLL(INBLLRowid)
 	..quit:HospId'=$p(InString,"^",31) 
  	..s tmpINSUTypte=$p(InString,"^",1)         ///医保类型 
 	..q:(InsuType'="")&(tmpINSUTypte'=InsuType)      ///医保类型
 	..i UserNo'=""  d
 	...s UserRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserNo),"0"))
 	..q:(UserNo'="")&($p(InString,"^",3)'=UserRowid)      ///操作员工号

  	..s INSUTypte=##class(web.INSUDicDataCom).GetDicByCodeAndInd("TariType",tmpINSUTypte,4,HospId)                
 	..s OptDate=$p(InString,"^",2)         ///对账日期                   
	..s UserDr=$p(InString,"^",3)         ///操作员ID                      
	..s tmpFlag=$p(InString,"^",4)         ///对账成功标志  
	..s Flag=$S(tmpFlag>0:"成功",1:"失败")                   
	..s StartDate=$p(InString,"^",5)         ///对账开始日期                  
	..s StartTime=$p(InString,"^",6)         ///对账开始时间                    
	..s EndDate=$p(InString,"^",7)         ///对账结束日期                       
	..s EndTime=$p(InString,"^",8)         ///对账结束时间                    
	..s TotAmt=+$p(InString,"^",9)      ///his对账总金额               
	..s JJZFE=+$p(InString,"^",10)      ///his基金支付金额            
	..s ZHZFE=+$p(InString,"^",11)      ///his账户支付金额                 
	..s GRZFE=+$p(InString,"^",12)      ///his现金支付金额                
	..s TCZF=+$p(InString,"^",13)      ///his基本统筹支付金额                  
	..s DBZF=+$p(InString,"^",14)      ///his大病支付金额                 
	..s GWYZF=+$p(InString,"^",15)      ///his公务员支付金额                
	..s MZJZ=+$p(InString,"^",16)      ///his民正救助金额                
	..s INSUTotAmt=+$p(InString,"^",17)      ///医保返回对账总金额                
	..s INSUJJZFE=+$p(InString,"^",18)      ///医保返回基金支付金额                
	..s INSUZHZFE=+$p(InString,"^",19)      ///医保返回账户支付金额           
	..s INSUGRZFE=+$p(InString,"^",20)      ///医保返回现金支付金额                  
	..s INSUTCZF=+$p(InString,"^",21)      ///医保返回基本统筹支付金额                     
	..s INSUDBZF=+$p(InString,"^",22)      ///医保返回大病支付金额                
	..s INSUGWYZF=+$p(InString,"^",23)      ///医保返回公务员支付金额                  
	..s INSUMZJZ=+$p(InString,"^",24)      ///医保返回民正救助金额
	..s Note=$p(InString,"^",25)       ///对账失败原因  
	..s Str1=$p(InString,"^",26)       ///扩展字段1                   
	..s Str2=$p(InString,"^",27)       ///扩展字段2                    
	..s Str3=$p(InString,"^",28)       ///扩展字段3                 
	..s Str4=$p(InString,"^",29)       ///扩展字段4                      
	..s Str5=$p(InString,"^",30)      ///扩展字段5
 	..d QueryBalanceLog
	Quit $$$OK
    
QueryBalanceLog
	s OptDate=##class(websys.Conversions).DateLogicalToHtml(OptDate)
	s StartDate=##class(websys.Conversions).DateLogicalToHtml(StartDate)
	s EndDate=##class(websys.Conversions).DateLogicalToHtml(EndDate)
	s StartTime=##class(websys.Conversions).TimeLogicalToHtml(StartTime)
	s EndTime=##class(websys.Conversions).TimeLogicalToHtml(EndTime)
	set Data=$lb(INSUTypte,OptDate,UserDr,Flag,StartDate,StartTime,EndDate,EndTime,$fn(TotAmt,"",2),$fn(JJZFE,"",2),$fn(ZHZFE,"",2),$fn(GRZFE,"",2),$fn(TCZF,"",2),$fn(DBZF,"",2),$fn(GWYZF,"",2),$fn(MZJZ,"",2),$fn(INSUTotAmt,"",2),$fn(INSUJJZFE,"",2),$fn(INSUZHZFE,"",2),$fn(INSUGRZFE,"",2),$fn(INSUTCZF,"",2),$fn(INSUDBZF,"",2),$fn(INSUGWYZF,"",2),$fn(INSUMZJZ,"",2),Note,Str1,Str2,Str3,Str4,Str5)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryBalanceLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBalanceLogExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryBalanceLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBalanceLogExecute ]
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

}
