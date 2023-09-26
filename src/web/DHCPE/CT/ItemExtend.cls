Import SQLuser

/// 名称: 医嘱扩展
/// 编写者：xy
/// 编写日期: 2021-08-16
Class web.DHCPE.CT.ItemExtend Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    xy 
/// CreatDate：  20210816
/// Description: 医嘱扩展表插入数据
/// Table：      医嘱扩展表 DHC_PE_ItemExtend
/// Input:       OrderID(站点和项目组合ID), tableName(表名),UserID(当前登陆人ID),LocID(科室ID),Empower（是否单独授权）       
/// Return：
/// debug:d ##class(web.DHCPE.CT.ItemExtend).InsertIE()
ClassMethod InsertIE(OrderID As %String = "", tableName As %String = "", LocID As %String = "", UserID As %String = "", Empower As %String = "N")
{
	s ^tempdhcpe("InsertIE")=$lb(OrderID,tableName,LocID,UserID,Empower)
	n (OrderID,tableName,LocID,UserID,Empower)
	
	s $ZT="InsertIEErr"
    s result=1
    
    //s IEID=$O(^DHCPEIE(0,"ARCIM",ID,0))
	//q:+IEID>0 "项目已经添加"
	q:(OrderID="")||(tableName="")||(LocID="")||(UserID="") "-1^数据不能为空"
    s IEID=$O(^DHCPEIE(0,"Order",OrderID,0))
	q:+IEID>0 "-1^项目已经添加,不允许重复添加"

	k PLIST
	s PLIST(2)=""
	s PLIST(3)=UserID
	s Date=+$H
	s Time=$P($H,",",2)
	s PLIST(4)=Date
	s PLIST(5)=Time
    s PLIST(6)=OrderID
   TSTART
	&SQL(Insert into sqluser.DHC_PE_ItemExtend values :PLIST())
	b ; SQLCODE
    //医嘱扩展表插入数据失败
     If (SQLCODE'=0)	 
      { 
        s result="-1^插入医嘱扩展表失败"
        goto InsertIEErr
		
      }
   	i (SQLCODE=0) {
   		s RowID=%ROWID
   		;b ;tableName,RowID,LocID,UserID,Empowe
   		s ret=##class(User.DHCPEItemExtend).SaveDataToPowerControl(RowID,LocID,UserID,Empower)
   		//表记录授权插入数据失败
    	If ($p(ret,"^",1)="-1")	{ 
        	s result="-1^插入记录授权表失败"
        	goto InsertIEErr
   		}else{
   	    	s OldRecord=""
   	    	s NewRecord=$g(^DHCPEIE(RowID))
   	    	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_ItemExtend",RowID,"I",OldRecord,NewRecord,UserID)
   	    
			if ($p(Logret,"^",1)="-1"){
				s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        		goto InsertIEErr
			}
   		}
   	    	
   		
   	}
	
	TCommit
        s result="0^插入成功"
        q result 
         
InsertIEErr
	
	TROLLBACK 
	//q $ZE
    q result
}

/// Creator：    xy 
/// CreatDate：  20210816
/// Description: 医嘱扩展表查询
/// Table：		 医嘱扩展表 DHC_PE_ItemExtend
/// debug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.ItemExtend","FindItemExtend","","1","DHC_PE_ItemExtend")
Query FindItemExtend(OrderID As %String = "", LocID As %String = "", tableName As %String = "") As websys.Query(ROWSPEC = "TID,TOrderID,TARCIMID,TARCIMDesc,TUser,TUpdateDate,TUpdateTime,TEmpower,TEffPowerFlag")
{
}

ClassMethod FindItemExtendExecute(ByRef qHandle As %Binary, OrderID As %String = "", LocID As %String = "", tableName As %String = "") As %Status
{
	s ^tempdhcpe("FindItemExtend")=$lb(OrderID,LocID,tableName)
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
   
    s hospId=$p($g(^CTLOC(LocID )),"^",22)
 	s ID=0
	f  s ID=$O(^DHCPEIE(ID)) q:ID=""  d
	.s IEOrderID=$P($g(^DHCPEIE(ID)),"^",6)
	.q:(OrderID'="")&&(OrderID'=IEOrderID)
	.q:IEOrderID=""
	.s ARCIMID=$p($g(^DHCPEST($p(IEOrderID,"||",1),"O",$p(IEOrderID,"||",2))),"^",1)
	.s ARCIMDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ARCIMID,"A",LocID)
	.s UserDR=$P($g(^DHCPEIE(ID)),"^",3)
	.i UserDR'="" s User=$P($g(^SSU("SSUSR",UserDR)),"^",2)
	.s UpdateDate=$P($g(^DHCPEIE(ID)),"^",4)
	.i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
	.s UpdateTime=$P($g(^DHCPEIE(ID)),"^",5)
	.i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
	.s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",ARCIMID,hospId)
	.q:(HOSPshowFlag="N")
	.s LocShowDFlag=##class(User.DHCPEItemExtend).GetLocShowDataFlag(ID,LocID)
    .q:LocShowDFlag="N"
    .s EmpowerStr=##class(User.DHCPEItemExtend).GetEmpowerFlag(ID,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    .;d TranslateFindItemExtend
	.s ^CacheTemp(repid,ind)=$lb(ID,IEOrderID,ARCIMID,ARCIMDesc,User,UpdateDate,UpdateTime,Empower,EffPowerFlag)
	.s ind=ind+1
        
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TranslateFindItemExtend
	s User=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",User,"SSUSRName","cls")
}

/// Creator：    xy 
/// CreatDate：  20210816
/// Description: 根据医嘱扩展表ID获取医嘱名称和价格
/// Table：      医嘱扩展表 DHC_PE_ItemExtend
/// Input:     ParRef(医嘱扩展表ID), hospid（当前登录医院ID）
/// Return：
/// debug:d ##class(web.DHCPE.CT.ItemExtend).GetARCDesc()
ClassMethod GetARCDesc(ParRef, hospid As %String = "")
{
	s IEOrderID=$P($g(^DHCPEIE(ParRef)),"^",6)
	q:IEOrderID=""
	s ARCIMID=$p($g(^DHCPEST($p(IEOrderID,"||",1),"O",$p(IEOrderID,"||",2))),"^",1)
	s Desc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ARCIMID)
	s Price=##class(web.UDHCJFPRICE).GetOrderPrice("","",ARCIMID,+$H,"","","","",hospid)
	q Desc_"^"_$fn($p(Price,"^",4),"",2)
}

/// Creator：    xy 
/// CreatDate：  20210816
/// Description: 赠送项目保存数据
/// Table：      赠送项目表 DHC_PE_IESendItem
/// Input:       ID(数据ID), Strs（拼串信息）
/// Return：
/// debug:d ##class(web.DHCPE.CT.ItemExtend).SaveIESendItem()
ClassMethod SaveIESendItem(ID, Strs)
{
	s $ZT="SaveIESendItemErr"
    s result=1
    
	k PLIST
	
	s PLIST(3)=$P(Strs,"^",2) 
	s PLIST(4)=+$P(Strs,"^",3)
	s PLIST(5)=$P(Strs,"^",4)
	i PLIST(5)'="" s PLIST(5)=##class(websys.Conversions).DateHtmlToLogical(PLIST(5))
	s PLIST(6)=$P(Strs,"^",5)
	i PLIST(6)'="" s PLIST(6)=##class(websys.Conversions).DateHtmlToLogical(PLIST(6))
	
	s PLIST(8)=""
	s PLIST(9)=""
	s PLIST(7)=$P(Strs,"^",6)
	s PLIST(10)=$P(Strs,"^",7)
	s PLIST(11)=+$H
	s PLIST(12)=$p($H,",",2)
	
	TSTART
	if (ID'=""){
		s OldRecord=$g(^DHCPEIE(+ID,"SI",$P(ID,"||",2)))
		&SQL(update Sqluser.DHC_PE_IESendItem values :PLIST() where SI_RowID=:ID)
	}else{
		s PLIST(0)=$P(Strs,"^",1)	
		&SQL(Insert into Sqluser.DHC_PE_IESendItem values :PLIST())
	}
	If (SQLCODE'=0)	 
     { 
        s result="-1^保存数据失败"
        goto SaveIESendItemErr
		
      }else{
	    s RowID=%ROWID
		if (ID=""){	
   	   		s OldRecord=""
   	    	s NewRecord=$g(^DHCPEIE(+RowID,"SI",$P(RowID,"||",2)))
   	    	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_IESendItem",RowID,"I",OldRecord,NewRecord,$P(Strs,"^",7))
   	    	if ($p(Logret,"^",1)="-1"){
				s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        		goto SaveIESendItemErr
			}
   	    }else{
   	    	s NewRecord=$g(^DHCPEIE(+RowID,"SI",$P(RowID,"||",2)))
   	    	if (OldRecord'=NewRecord) {
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_IESendItem",RowID,"U",OldRecord,NewRecord,$P(Strs,"^",7))
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        			goto SaveIESendItemErr
				}
   	    	}
   	    }	  
      }
	
	i SQLCODE'=0 q "更新错误,SQLCODE:"_SQLCODE
	TCommit
        s result="0^保存数据成功"
        q result  
SaveIESendItemErr
	TROLLBACK 
	//q $ZE
    q result
}

/// Creator：	  xy 
/// CreatDate：	 20210816
/// Description: 体检项目价格维护表保存数据
/// Table：      体检项目价格维护表 DHC_PE_IEPrice
/// Input:       ID(数据ID), Strs（拼串信息）
/// Return：
/// debug:d ##class(web.DHCPE.CT.ItemExtend).SaveIEPrice()
ClassMethod SaveIEPrice(ID, Strs)
{
	s ^TMP("DHCPE","SaveIEPrice")=$LB(ID, Strs)
	s $ZT="SaveIEPriceErr"
    s result=1
    
	k PLIST
	
	s PLIST(3)=$P(Strs,"^",2)
	s PLIST(4)=$P(Strs,"^",3)
	i PLIST(4)'="" s PLIST(4)=##class(websys.Conversions).DateHtmlToLogical(PLIST(4))
	s PLIST(5)=$P(Strs,"^",4)
	i PLIST(5)'="" s PLIST(5)=##class(websys.Conversions).DateHtmlToLogical(PLIST(5))	
	s PLIST(7)=$P(Strs,"^",5)
	s PLIST(8)=""
	s PLIST(6)=$P(Strs,"^",6)
	s PLIST(9)=$P(Strs,"^",7)
	s PLIST(10)=+$H
	s PLIST(11)=$p($H,",",2)
	
	TSTART
	if (ID'="") {
		s OldRecord=$g(^DHCPEIE(+ID,"P",$P(ID,"||",2)))
		&SQL(update Sqluser.DHC_PE_IEPrice values :PLIST() where P_RowID=:ID)
	}else{
		s PLIST(0)=$P(Strs,"^",1)
		&SQL(Insert into Sqluser.DHC_PE_IEPrice values :PLIST())
	}
	
	if (SQLCODE'=0){
		s result="-1^保存失败"
        goto SaveIEPriceErr
	}else{
		s RowID=%ROWID
		if (ID=""){	
   	   		s OldRecord=""
   	    	s NewRecord=$g(^DHCPEIE(+RowID,"P",$P(RowID,"||",2)))
   	    	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_IEPrice",RowID,"I",OldRecord,NewRecord,$P(Strs,"^",7))
   	    	if ($p(Logret,"^",1)="-1"){
				s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        		goto SaveIEPriceErr
			}
   	    }else{
   	    	s NewRecord=$g(^DHCPEIE(+RowID,"P",$P(RowID,"||",2)))
   	    	if (OldRecord'=NewRecord) {
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_IEPrice",RowID,"U",OldRecord,NewRecord,$P(Strs,"^",7))
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        			goto SaveIEPriceErr
				}
   	    	}
   	    }	  
	}
	
 TCommit
   s result="0^保存数据成功"
   q result  
SaveIEPriceErr
	TROLLBACK 
	//q $ZE
    q result
}

/// Creator：    xy 
/// CreatDate：  20210816
/// Description: 体检项目价格表查询
/// Table：      体检项目价格维护表 DHC_PE_IEPrice
/// Input:       ParRef(医嘱扩展表DI), LocID(科室ID)
/// Return：
/// debug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.ItemExtend","SerchIEPrice","","1","DHC_PE_ItemExtend")
Query SerchIEPrice(ParRef As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "TRowID:%String,TPrice:%String,TBeginDate:%String,TEndDate:%String,TSetsFlag:%String,TCreateUser:%String,TCreateDate:%String")
{
}

ClassMethod SerchIEPriceExecute(ByRef qHandle As %Binary, ParRef As %String = "", LocID As %String = "") As %Status
{
	s ^tempdhcpe("SerchIEPrice")=$lb(ParRef,LocID)
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    if (ParRef="")&&(LocID=""){
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
    }
   
 	s Sub=0
	f  s Sub=$O(^DHCPEIE(ParRef,"P",Sub)) q:Sub=""  d
	.s Loc=$p($g(^DHCPEIE(ParRef,"P",Sub)),"^",4)
	.q:Loc'=LocID
	.s ID=ParRef_"||"_Sub
	.s Price=$p($g(^DHCPEIE(ParRef,"P",Sub)),"^",1)
	.s BeginDate=$p($g(^DHCPEIE(ParRef,"P",Sub)),"^",2)
	.i BeginDate'="" s BeginDate=##class(websys.Conversions).DateLogicalToHtml(BeginDate)
	.s EndDate=$p($g(^DHCPEIE(ParRef,"P",Sub)),"^",3)
	.i EndDate'="" s EndDate=##class(websys.Conversions).DateLogicalToHtml(EndDate)
	.s SetsFlag=$p($g(^DHCPEIE(ParRef,"P",Sub)),"^",5)
	.s User=$p($g(^DHCPEIE(ParRef,"P",Sub)),"^",7)
	.i User'="" s User=$P($g(^SSU("SSUSR",User)),"^",2)
	.s Date=$p($g(^DHCPEIE(ParRef,"P",Sub)),"^",8)
	.i Date'="" s Date=##class(websys.Conversions).DateLogicalToHtml(Date)
	.;d TranslateSerchIEPrice
	.s ^CacheTemp(repid,ind)=$lb(ID,$J(Price,"",2),BeginDate,EndDate,SetsFlag,User,Date)
	
	.s ind=ind+1
        
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TranslateSerchIEPrice
	s User=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",User,"SSUSRName","cls")
}

/// Creator：    xy 
/// CreatDate：  20210816
/// Description: 体检赠送项目表查询
/// Table：      体检赠送项目 DHC_PE_IESendItem
/// Input:       ParRef(医嘱扩展表DI), LocID(科室ID)
/// Return：
/// debug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.ItemExtend","SerchIESendItem","","1","DHC_PE_ItemExtend")
Query SerchIESendItem(ParRef As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "TRowID:%String,TCostFeeMin:%String,TBeginDate:%String,TEndDate:%String,TGroupFlag:%String,TCreateUser:%String,TCreateDate:%String,TCostFeeMax:%String")
{
}

ClassMethod SerchIESendItemExecute(ByRef qHandle As %Binary, ParRef As %String = "", LocID As %String = "") As %Status
{
	s ^tempdhcpe("SerchIESendItem")=$lb(ParRef,LocID)
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    if (ParRef="")&&(LocID=""){
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
    }
   
    s Sub=0
	f  s Sub=$O(^DHCPEIE(ParRef,"SI",Sub)) q:Sub=""  d
	.s Loc=$p(^DHCPEIE(ParRef,"SI",Sub),"^",5)
	.q:Loc'=LocID
	.s ID=ParRef_"||"_Sub
	.s CostFeeMin=$p(^DHCPEIE(ParRef,"SI",Sub),"^",1)
	.s BeginDate=$p(^DHCPEIE(ParRef,"SI",Sub),"^",3)
	.i BeginDate'="" s BeginDate=##class(websys.Conversions).DateLogicalToHtml(BeginDate)
	.s EndDate=$p(^DHCPEIE(ParRef,"SI",Sub),"^",4)
	.i EndDate'="" s EndDate=##class(websys.Conversions).DateLogicalToHtml(EndDate)
	.s GroupFlag=$p(^DHCPEIE(ParRef,"SI",Sub),"^",6)
	.s User=$p(^DHCPEIE(ParRef,"SI",Sub),"^",8)
	.i User'="" s User=$P(^SSU("SSUSR",User),"^",2)
	.s Date=$p(^DHCPEIE(ParRef,"SI",Sub),"^",9)
	.i Date'="" s Date=##class(websys.Conversions).DateLogicalToHtml(Date)
	.s CostFeeMax=$p(^DHCPEIE(ParRef,"SI",Sub),"^",2)
	.;d TranslateSerchIESendItem
	.s ^CacheTemp(repid,ind)=$lb(ID,$J(CostFeeMin,"",2),BeginDate,EndDate,SetsFlag,User,Date,$fn(CostFeeMax,",",2))
	.s ind=ind+1
        
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TranslateSerchIESendItem
	s User=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",User,"SSUSRName","cls")
}

/// Creator：    xy 
/// CreatDate：  20210816
/// Description: 获取体检赠送项目表/项目价格维护表的最新记录截止日期
/// debug:w ##class(web.DHCPE.CT.ItemExtend).GetNewPriceEndDate(3,1,1)
ClassMethod GetNewPriceEndDate(ID, type, LocID)
{
	s ^tempdhcpe("GetNewPriceEndDate")=$lb(ID,type,LocID)
	q:'$d(^DHCPEIE(ID,"P"))&&(type="1") ""_"^0"
	q:'$d(^DHCPEIE(ID,"SI"))&&(type="2") ""_"^0"
	s PFlag=0,SIFlag=0,EndDate=""
	
	if (type="1"){
		s PSub=""
		f  s PSub=$o(^DHCPEIE(ID,"P",PSub),-1) q:(PSub="")||(PFlag=1)  d
		.s PLocID=$P($G(^DHCPEIE(ID,"P",PSub)),"^",4)
		.i PLocID=LocID s PFlag=1
		.s EndDate=$P($G(^DHCPEIE(ID,"P",PSub)),"^",3)
	}
	if (type="2"){
		s PSub=""
		f  s PSub=$o(^DHCPEIE(ID,"SI",PSub),-1) q:(PSub="")||(SIFlag=1)  d	
		.s PLocID=$P($G(^DHCPEIE(ID,"SI",PSub)),"^",5)
		.i PLocID=LocID s SIFlag=1
		.s EndDate=$P($G(^DHCPEIE(ID,"SI",PSub)),"^",4)
		
	}
	if (type="1"){ q EndDate_"^"_PFlag}
	if (type="2"){ q EndDate_"^"_SIFlag}
}

}
