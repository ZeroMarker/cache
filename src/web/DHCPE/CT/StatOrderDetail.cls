Import SQLuser

/// 名称: 细项维护
/// 编写者：xy
/// 编写日期: 2021-08-13
Class web.DHCPE.CT.StatOrderDetail Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod UpdateOrderDetailEx(ID, Code, Desc)
{
    s SQLCODE=0
    &SQL(Update Sqluser.DHC_PE_OrderDetail (OD_KBXCode,OD_KBItemDtlDesc) values (:Code,:Desc) where OD_RowId=:ID)    
    q SQLCODE
}

/// Creator：		xy 
/// CreatDate：		20210814
/// Description: 	获取细项扩展表数据
/// Table：			细项扩展表 DHC_PE_OrderDetailSet
/// Input: 			ID(数据ID)
/// Return：
/// Debug: d ##class(web.DHCPE.CT.StatOrderDetail).GetOrdDetailSetByID()
ClassMethod GetOrdDetailSetByID(ID)
{
	q:ID="" ""
	s ODSSummary=$lg($g(^CF.PE.OrderDetailSetD(ID)),4)
    s ODSZhToEn=$lg($g(^CF.PE.OrderDetailSetD(ID)),9) 
    s ODSNoPrint=$lg($g(^CF.PE.OrderDetailSetD(ID)),10)
    s ODSHistoryFlag=$lg($g(^CF.PE.OrderDetailSetD(ID)),11)
    s ODSRange=$lg($g(^CF.PE.OrderDetailSetD(ID)),12) 
    s ODSMarriedDR=$lg($g(^CF.PE.OrderDetailSetD(ID)),13)
	q ODSSummary_"^"_ODSZhToEn_"^"_ODSHistoryFlag_"^"_ODSRange_"^"_ODSMarriedDR_"^"_ODSNoPrint
}

/// Creator：		xy 
/// CreatDate：		20210814
/// Description: 	细项扩展表保存数据
/// Table：			细项扩展表 DHC_PE_OrderDetailSet
/// Input: 			ID(数据ID), InString(数据信息拼串), tableName(表名),
///      			UserID(登陆用户ID),LocID(登陆科室ID)
/// Return：
/// Debug: d ##class(web.DHCPE.CT.StatOrderDetail).SaveOrderDetailSet("","1^1||32^Y^Y^sss^10-1000^21^Y","DHC_PE_OrderDetailSet","1","1")
ClassMethod SaveOrderDetailSet(ID As %String = "", InString As %String = "", tableName As %String = "", UserID As %String = "", LocID As %String = "")
{
	
	s ^TMP("DHCPE","SaveOrderDetailSet")=$lb(ID,InString,tableName,UserID,LocID)
	n (ID,InString,tableName,UserID,LocID)
  	
  	s $ZT="SaveOrderDetailSetErr"
    s result=1
	s Date=+$h
	s Time=$p($h,",",2)
  	s StationID=$p(InString,"^",1)
  	s OrdDetailID=$p(InString,"^",2)
  	s Summary=$p(InString,"^",3)
  	s NoPrint=$p(InString,"^",4)
  	s ZhToEng=$p(InString,"^",5)
  	s SpecialNature=$p(InString,"^",6)
  	s Married=$p(InString,"^",7)
  	s HistoryFlag=$p(InString,"^",8)
  	s NoActive=$p(InString,"^",9)
   	if ID="" d
	.s obj=##class(User.DHCPEOrderDetailSet).%New()
	e  d
	.s obj=##class(User.DHCPEOrderDetailSet).%OpenId(ID)
	.s OldRecord=$ListToString($g(^CF.PE.OrderDetailSetD(ID)),,1) // 1  缺省的默认为空
	
	
	d obj.ODSOrderDtlDRSetObjectId(OrdDetailID)
	s obj.ODSLocDR=LocID
	s obj.ODSSummary=Summary
	s obj.ODSZhToEn=ZhToEng
	s obj.ODSNoPrint=NoPrint

	s obj.ODSHistoryFlag=HistoryFlag
	s obj.ODSRange=SpecialNature
	s obj.ODSMarriedDR=Married
	s obj.ODSNoActive=NoActive
	s obj.ODSUpdateDate=Date
	s obj.ODSUpdateTime=Time
	s obj.ODSUpdateUserDR=UserID

	TSTART
	s sc=obj.%Save()
	d obj.%Close()
	;b ;obj.%Id()
	If ($System.Status.IsError(sc))	 
     { 
        s result="-1^保存细项详情失败"
        goto SaveOrderDetailSetErr
		
      }else{
	   	s RowID=obj.%Id()
       	if (ID="") {
   			;b ;tableName,RowID,LocID,UserID
   			s ret=##class(User.DHCPEOrderDetailSet).SaveDataToPowerControl(RowID,LocID,UserID)
   			//表记录授权插入数据失败
    		If ($p(ret,"^",1)="-1")	 
    		{ 
        		s result="-1^插入记录授权表失败"
        		goto SaveOrderDetailSetErr
		
   			 }
       } 
        if (ID=""){	
   	    	s OldRecord=""
   	    	s NewRecord=$ListToString($g(^CF.PE.OrderDetailSetD(RowID)),,1)
   	    	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_OrderDetailSet",RowID,"I",OldRecord,NewRecord,UserID)
   	    
			if ($p(Logret,"^",1)="-1"){
				s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        		goto SaveOrderDetailSetErr
			}
   	    }else{
   	    	s NewRecord=$ListToString($g(^CF.PE.OrderDetailSetD(RowID)),,1)
   	    	
   	    	if (OldRecord'=NewRecord) {
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_OrderDetailSet",RowID,"U",OldRecord,NewRecord,UserID)
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        			goto SaveOrderDetailSetErr
				}
   	    	}
   	    }	  
         		
   		
   	}
	  
	TCommit
        s result="0^保存数据成功"
        q result  
SaveOrderDetailSetErr
	TROLLBACK 
	//q $ZE
    q result
}

/// Creator：		xy 
/// CreatDate：		20210814
/// Description: 	细项扩展表查询
/// Table：			细项扩展表 DHC_PE_OrderDetailSet
/// Input: 
/// Debug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.StatOrderDetail","FindOrderDetailSet","1||32","1","DHC_PE_OrderDetailSet")
Query FindOrderDetailSet(OrdDetailID As %String = "", LocID As %String = "", tableName As %String = "") As websys.Query(ROWSPEC = "TODSID,TODDesc,TODSSummary,TODSAdvice,TODSExplain,TODSSequence,TODSLabtrakCode,TODSZhToEn,TODSNoPrint,TODSHistoryFlag,TODSRange,TODSMarriedDR,TODSMarriedDesc,TODSNoActive,TODSUpdateDate,TODSUpdateTime,TODSUpdateUser")
{
}

ClassMethod FindOrderDetailSetExecute(ByRef qHandle As %Binary, OrdDetailID As %String = "", LocID As %String = "", tableName As %String = "") As %Status
{
	s ^tempdhcpe("FindOrderDetailSet")=$lb(OrdDetailID,LocID,tableName)
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
   
    if (OrdDetailID="")||(LocID=""){ 
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
    }
    
    s ID=""
    f  s ID=$o(^CF.PE.OrderDetailSetI("IdxOfLocOrdDtl"," "_LocID,OrdDetailID,ID))  q:ID=""  d
    .s OrderDtlDR=$lg($g(^CF.PE.OrderDetailSetD(ID)),2)
    .s ODDesc=$p($g(^DHCPEST($p(OrdDetailID,"||",1),"OD",$p(OrdDetailID,"||",2))),"^",1)
    .s ODSSummary=$lg($g(^CF.PE.OrderDetailSetD(ID)),4)
    .s ODSAdvice=$lg($g(^CF.PE.OrderDetailSetD(ID)),5)
    .s ODSExplain=$lg($g(^CF.PE.OrderDetailSetD(ID)),6) 
    .s ODSSequence=$lg($g(^CF.PE.OrderDetailSetD(ID)),7)
    .s ODSLabtrakCode=$lg($g(^CF.PE.OrderDetailSetD(ID)),8)
    .s ODSZhToEn=$lg($g(^CF.PE.OrderDetailSetD(ID)),9) 
    .s ODSNoPrint=$lg($g(^CF.PE.OrderDetailSetD(ID)),10)
    .s ODSHistoryFlag=$lg($g(^CF.PE.OrderDetailSetD(ID)),11)
    .s ODSRange=$lg($g(^CF.PE.OrderDetailSetD(ID)),12) 
    .s ODSMarriedDR=$lg($g(^CF.PE.OrderDetailSetD(ID)),13)
    .s ODSMarriedDesc=""
    .i ODSMarriedDR'="" s ODSMarriedDesc=$p($g(^CT("MAR",ODSMarriedDR)),"^",2)
    .s ODSNoActive=$lg($g(^CF.PE.OrderDetailSetD(ID)),14) 
    .s ODSUpdateDate=$lg($g(^CF.PE.OrderDetailSetD(ID)),15) 
    .i ODSUpdateDate'="" s ODSUpdateDate=##class(websys.Conversions).DateLogicalToHtml(ODSUpdateDate)
    .s ODSUpdateTime=$lg($g(^CF.PE.OrderDetailSetD(ID)),16) 
    .i ODSUpdateTime'="" s ODSUpdateTime=##class(websys.Conversions).TimeLogicalToHtml(ODSUpdateTime)
    .s ODSUpdateUserDR=$lg($g(^CF.PE.OrderDetailSetD(ID)),17)
    .s ODSUpdateUserName=""
	.i ODSUpdateUserDR'="" s ODSUpdateUserName=$p($g(^SSU("SSUSR",ODSUpdateUserDR)),"^",2)	 
  	.;d TranslateFindOrderDetailSet
	.s ^CacheTemp(repid,ind)=$lb(ID,ODDesc,ODSSummary,ODSAdvice,ODSExplain,ODSSequence,ODSLabtrakCode2,ODSZhToEn,ODSNoPrint,ODSHistoryFlag,ODSRange,ODSMarriedDR,ODSMarriedDesc,ODSNoActive,ODSUpdateDate,ODSUpdateTime,ODSUpdateUserName)
	.s ind=ind+1
     
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TranslateFindOrderDetailSet
	s ODDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEOrderDetail",ODDesc,"ODDesc","cls")
	s ODSUpdateUserName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",ODSUpdateUserName,"SSUSRName","cls")
}

/// Creator：    xueying
/// CreatDate：  20211117
/// Description: 判断科室组下是否有重复的细项
/// Table：      细项表 User.DHCPEOrderDetail
/// Input:       StationID(站点ID),Desc(细项描述),LocID(科室下拉列表值) ,Code(细项编码)             
/// Return：     0/1(无/有)
/// Dubug： w ##class(web.DHCPE.CT.StatOrderDetail).IsExsistODDesc(1,"身高","152")
ClassMethod IsExsistODDesc(StationID, Desc As %String, LocID As %String, Code As %String = "")
{
	s flag=0
	s sub=""
	f  s sub=$o(^DHCPEST(StationID,"OD",sub))  q:(sub="")||(flag=1)  d
	.s ODID=StationID_"||"_sub
	.s aODDesc=$P($g(^DHCPEST(StationID,"OD",sub)),"^",1)
	.s aODCode=$p($g(^DHCPEST(StationID,"OD",sub)),"^",11)
	.s LocShowDFlag=##class(User.DHCPEOrderDetail).GetLocShowDataFlag(ODID,LocID)
	.q:LocShowDFlag="N"
	.s:(aODDesc=Desc)||(aODCode=Code) flag=1
    q flag
}

/// Creator：    xueying
/// CreatDate：  20220909
/// Description: 根据细项描述获取对应科室的细项ID
/// Input:       ADMLocID(就诊科室ID),Desc(细项描述)
/// Return：     细项ID
/// debug: w ##class(web.DHCPE.CT.StatOrderDetail).GetOrdDetailIDByDesc()
ClassMethod GetOrdDetailIDByDesc(ADMLocID As %String = "", Desc As %String = "")
{
	q:(Desc="")||(ADMLocID="") ""
	i Desc["("  s Desc=##class(web.DHCPE.Public.Setting).Replace(Desc,"(","")
	i Desc[")"  s Desc=##class(web.DHCPE.Public.Setting).Replace(Desc,")","")
	s StationRowId=""
	s ODRowID=""
    f  s StationRowId=$o(^DHCPEST(0,"OD_Desc",Desc,StationRowId))  q:(StationRowId="")||(ODRowID'="")  d
    .s ODSub=0
    .f  s ODSub=$o(^DHCPEST(0,"OD_Desc",Desc,StationRowId,ODSub))  q:(ODSub="")||(ODRowID'="")  d
    ..s LocShowDFlag=##class(User.DHCPEOrderDetail).GetLocShowDataFlag(StationRowId_"||"_ODSub,ADMLocID)
    ..q:LocShowDFlag'="Y"  //细项（无效授权的退出）
    ..s ODRowID=StationRowId_"||"_ODSub
    q ODRowID
}

/// Creator：		xy 
/// CreatDate：		20210813
/// Description: 	细项表保存数据
/// Table：			细项表 DHC_PE_OrderDetail
/// Input: 			ID(数据ID), InString(数据信息拼串), tableName(表名), 
/// 				UserID(登陆用户ID),LocID(登陆科室ID),Empower(是否单独授权)
/// Return：
/// Debug:d ##class(web.DHCPE.CT.StatOrderDetail).SaveOrderDetail("","1^100001^身高测试^N^^cm^测试说明^N^","DHC_PE_OrderDetail","1","1","N")
ClassMethod SaveOrderDetail(ID As %String = "", InString As %String = "", tableName As %String = "", UserID As %String = "", LocID As %String = "", Empower As %String = "")
{
	
	s ^tempdhcpe("SaveOrderDetail")=$lb(ID,InString,tableName,UserID,LocID,Empower)
	n (ID,InString,tableName,UserID,LocID,Empower)
  	
  	s $ZT="SaveOrderDetailErr"
  	s ODDesc=""
    s result=1
	s Date=+$h
	s Time=$p($h,",",2)
  	s StationID=$p(InString,"^",1)
  	s Code=$p(InString,"^",2)
  	s Desc=$p(InString,"^",3)
  	s Type=$p(InString,"^",4)
  	s Expression=$p(InString,"^",5)
  	s Unit=$p(InString,"^",6)
  	s Explain=$p(InString,"^",7)
  	s Sex=$p(InString,"^",8)
  	s ODLabtrakCode=$p(InString,"^",9)
 
 	//由于细项是私有数据，因为不同科室组下面的描述有可能是重复的,因此采用下面的方法进行判断
	if ID'="" s ODDesc=$P($g(^DHCPEST(StationID,"OD",$p(ID,"||",2))),"^",1)
	if (ODDesc'=Desc) {
    	s ExsistFlag=##class(web.DHCPE.CT.StatOrderDetail).IsExsistODDesc(StationID,Desc,LocID)
    	q:ExsistFlag=1 "-1^细项描述重复!"
	}
	
	TSTART
	;b ;Date Time UserID
	if (ID=""){
	&sql(insert into DHC_PE_OrderDetail
	     (OD_ParRef,OD_Code,OD_Desc,OD_Type,OD_Expression,OD_Unit,OD_Explain,OD_Sex,OD_LabtrakCode,OD_UpdateDate,OD_UpdateTime,OD_UpdateUserDR)
	     values 
	     (:StationID,:Code,:Desc,:Type,:Expression,:Unit,:Explain,:Sex,:ODLabtrakCode,:Date,:Time,:UserID)
	     )
	     
	}else{
		s ParRef=$p(ID,"||",1)
		s ChildSub=$p(ID,"||",2)
		s OldRecord=$g(^DHCPEST(ParRef,"OD",ChildSub))
	  	&sql(update DHC_PE_OrderDetail
	     set OD_Code =:Code,
	     	 OD_Desc =:Desc,
	         OD_Type =:Type,
	         OD_Expression =:Expression,
	         OD_Unit =:Unit,
	         OD_Explain =:Explain,
	         OD_Sex =:Sex,
	         OD_LabtrakCode =:ODLabtrakCode,
	         OD_UpdateDate =:Date,
	         OD_UpdateTime =:Time,
	         OD_UpdateUserDR =:UserID
	     where OD_ParRef=:ParRef and OD_ChildSub=:ChildSub
	     )
	}
	
	
	//细项表保存数据失败
     If (SQLCODE'=0)	 
      { 
        s result="-1^细项表保存数据失败"
        goto SaveOrderDetailErr
		
     }
       
     i (SQLCODE=0) {
   	    s RowID=%ROWID
   		;b ;tableName,RowID,LocID,UserID,Empower	
   		s ret=##class(User.DHCPEOrderDetail).SaveDataToPowerControl(RowID,LocID,UserID,Empower)
   		//表记录授权插入数据失败
    	If ($p(ret,"^",1)="-1")	 
    	{ 
        	s result="-1^插入记录授权表失败"
        	goto SaveOrderDetailErr
		
   	    }	
   	    if (ID=""){	
   	    	s OldRecord=""
   	    	s NewRecord=$g(^DHCPEST($p(RowID,"||",1),"OD",$p(RowID,"||",2)))
   	    	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_OrderDetail",RowID,"I",OldRecord,NewRecord,UserID)
   	    
			if ($p(Logret,"^",1)="-1"){
				s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        		goto SaveOrderDetailErr
			}
   	    }else{
	   	    
   	    	s NewRecord=$g(^DHCPEST($p(RowID,"||",1),"OD",$p(RowID,"||",2)))
   	    	if (OldRecord'=NewRecord) {
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_OrderDetail",RowID,"U",OldRecord,NewRecord,UserID)
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        			goto SaveOrderDetailErr
				}
   	    	}
   	    }		
   		
   	}  
	TCommit
        s result="0^保存数据成功"
        q result  
SaveOrderDetailErr	
	TROLLBACK 
	//q $ZE
    q result
}

/// Creator：		xy 
/// CreatDate：		20210813
/// Description: 	细项查询（使用数据，只有授权的科室才显示）
/// Table：			细项表 DHC_PE_OrderDetail
/// Input: 			StationID(站点ID),Desc(细项描述),LocID（科室ID）,tableName(细项表 DHC_PE_OrderDetail)
/// Debug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.StatOrderDetail","FindOrderDetail","1","","1","DHC_PE_OrderDetail")
Query FindOrderDetail(StationID As %String = "", Desc As %String = "", LocID As %String = "", tableName As %String = "") As websys.Query(ROWSPEC = "TODID,TStationName,TODDesc,TODCode,TODTypeDR,TODType,TODExpression,TODUnit,TODSexDR,TODSex,TODExplain,TODLabtrakCode,TUpdateDate,TUpdateTime,TUpdateUser,TEmpower,TEffPowerFlag,ItemDtlDesc")
{
}

ClassMethod FindOrderDetailExecute(ByRef qHandle As %Binary, StationID As %String = "", Desc As %String = "", LocID As %String = "", tableName As %String = "") As %Status
{
	s ^tempdhcpe("FindOrderDetail")=$lb(StationID,Desc,LocID,tableName)
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
   
    if (StationID=""){ 
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
    }
    
    s Desc=##class(web.DHCPE.DHCPECommon).UnEscape(Desc)

    s ODChildSub=0  //不能使用空字符串开始 s id="" ,否则会取到 0
    f  s ODChildSub=$o(^DHCPEST(StationID,"OD",ODChildSub))   q:ODChildSub=""  d
    .s ODRowID=StationID_"||"_ODChildSub
    .s StationName=$p($g(^DHCPEST(StationID)),"^",2)
    .s ODDesc=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",1)
    .q:(ODDesc'[Desc)&&(Desc'="")
    
    .s ODCode=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",11)
    .s ODTypeDR=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",2)
    .s ODType=""
    .I ODTypeDR'="" s ODType=..GetODType(ODTypeDR)
    .s ODExpression=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",3)
    .s ODUnit=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",4)
    .s ODSexDR=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",9)
    .s ODSex=""
    .I ODSexDR'="" S ODSex=..GetODSex(ODSexDR)
    .s ODExplain=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",7)
    .s ODLabtrakCode=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",10)
    .s UpdateDate="",UpdateTime=""
    .s UpdateDate=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",13)
    .i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    .s UpdateTime=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",14)
    .i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    .s UpdateUserDR=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",15)
    .s UpdateUser=""
	.i UpdateUserDR'="" s UpdateUser=$p($g(^SSU("SSUSR",UpdateUserDR)),"^",2)
	.s LocShowDFlag=##class(User.DHCPEOrderDetail).GetLocShowDataFlag(ODRowID,LocID)
    .q:LocShowDFlag'="Y"
    .s EmpowerStr=##class(User.DHCPEOrderDetail).GetEmpowerFlag(ODRowID,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
	.s ItemDtlDesc=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",17)
	.;d TranslateFindOrderDetail
	.s ^CacheTemp(repid,ind)=$lb(ODRowID,StationName,ODDesc,ODCode,ODTypeDR,ODType,ODExpression,ODUnit,ODSexDR,ODSex,ODExplain,ODLabtrakCode,UpdateDate,UpdateTime,UpdateUser,Empower,EffPowerFlag,ItemDtlDesc)
	.s ind=ind+1
     
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TranslateFindOrderDetail
	s StationName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",StationName,"STDesc","cls")
	s ODDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEOrderDetail",ODDesc,"ODDesc","cls")
	s UpdateUser=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",UpdateUser,"SSUSRName","cls")
	s ItemDtlDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEOrderDetail",ItemDtlDesc,"ODKBItemDtlDesc","cls")
	s ODExplain=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEOrderDetail",ODExplain,"ODExplain","cls")
}

/// Creator：		xy 
/// CreatDate：		20211122
/// Description: 	细项查询(维护数据，所有数据都显示)
/// Table：			细项表 DHC_PE_OrderDetail
/// Input: 			StationID(站点ID),Desc(细项描述),LocID（科室ID）
/// 					tableName(细项表 DHC_PE_OrderDetail)
/// Debug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.StatOrderDetail","FindOrderDetailNew","1","","1","DHC_PE_OrderDetail")
Query FindOrderDetailNew(StationID As %String = "", Desc As %String = "", LocID As %String = "", tableName As %String = "") As websys.Query(ROWSPEC = "TODID,TStationName,TODDesc,TODCode,TODTypeDR,TODType,TODExpression,TODUnit,TODSexDR,TODSex,TODExplain,TODLabtrakCode,TUpdateDate,TUpdateTime,TUpdateUser,TEmpower,TEffPowerFlag,ItemDtlDesc")
{
}

ClassMethod FindOrderDetailNewExecute(ByRef qHandle As %Binary, StationID As %String = "", Desc As %String = "", LocID As %String = "", tableName As %String = "") As %Status
{
	s ^tempdhcpe("FindOrderDetailNew")=$lb(StationID,Desc,LocID,tableName)
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
   
    if (StationID=""){ 
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
    }
    
    s Desc=##class(web.DHCPE.DHCPECommon).UnEscape(Desc)

    s ODChildSub=0  //不能使用空字符串开始 s id="" ,否则会取到 0
    f  s ODChildSub=$o(^DHCPEST(StationID,"OD",ODChildSub))   q:ODChildSub=""  d
    .s ODRowID=StationID_"||"_ODChildSub
    .s StationName=$p($g(^DHCPEST(StationID)),"^",2)
    .s ODDesc=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",1)
    .q:(ODDesc'[Desc)&&(Desc'="")
    
    .s ODCode=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",11)
    .s ODTypeDR=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",2)
    .s ODType=""
    .I ODTypeDR'="" s ODType=..GetODType(ODTypeDR)
    .s ODExpression=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",3)
    .s ODUnit=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",4)
    .s ODSexDR=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",9)
    .s ODSex=""
    .I ODSexDR'="" S ODSex=..GetODSex(ODSexDR)
    .s ODExplain=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",7)
    .s ODLabtrakCode=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",10)
    .s UpdateDate="",UpdateTime=""
    .s UpdateDate=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",13)
    .i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    .s UpdateTime=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",14)
    .i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    .s UpdateUserDR=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",15)
    .s UpdateUser=""
	.i UpdateUserDR'="" s UpdateUser=$p($g(^SSU("SSUSR",UpdateUserDR)),"^",2)
	.s LocShowDFlag=##class(User.DHCPEOrderDetail).GetLocShowDataFlag(ODRowID,LocID)
    .q:LocShowDFlag="N"
    .s EmpowerStr=##class(User.DHCPEOrderDetail).GetEmpowerFlag(ODRowID,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
	.s ItemDtlDesc=$p($g(^DHCPEST(StationID,"OD",ODChildSub)),"^",17)
	.;d Translate
	.s ^CacheTemp(repid,ind)=$lb(ODRowID,StationName,ODDesc,ODCode,ODTypeDR,ODType,ODExpression,ODUnit,ODSexDR,ODSex,ODExplain,ODLabtrakCode,UpdateDate,UpdateTime,UpdateUser,Empower,EffPowerFlag,ItemDtlDesc)
	.s ind=ind+1
     
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Translate
	s ItemDtlDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEOrderDetail",ItemDtlDesc,"ODKBItemDtlDesc","cls")
	s ODDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEOrderDetail",ODDesc,"ODDesc","cls")
	s StationName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",StationName,"STDesc","cls")
	s UpdateUser=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",UpdateUser,"SSUSRName","cls")
	s ODExplain=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEOrderDetail",ODExplain,"ODExplain","cls")
}

/// Creator：	 xy 
/// CreatDate：	 20210813
/// Description: 获取细项的类型描述
/// Input: 		 细项类型
/// Debug:##class(web.DHCPE.CT.StatOrderDetail).GetODType()
ClassMethod GetODType(ODType)
{
   s Type=""
	i ODType="T" S Type="说明型"
	i ODType="N" S Type="数值型"
	i ODType="C" S Type="计算型"
	i ODType="S" S Type="选择型"
	i ODType="A" S Type="多行文本"
	;s Type=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.orderdetail.csp",Type)
	q Type
}

/// Creator：    xy 
/// CreatDate：  20210813
/// Description: 获取细项的性别描述
/// Input: 
/// Debug:##class(web.DHCPE.CT.StatOrderDetail).GetODSex()
ClassMethod GetODSex(ODSex)
{
    s Sex=""
	i ODSex="M" S Sex="男"
	i ODSex="F" S Sex="女"
	i ODSex="N" S Sex="不限"
	;s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.orderdetail.csp",Sex)
	q Sex
}

/// Creator：	  xy
/// CreatDate：	  20211210
/// Description:  多院区————总检回传结果自动插入检验细项，细项扩展表
/// Input:        CTTCCode(检验外部代码),Name（细项描述）,Units（单位）, 
///               ZhToEng（英文）,OrderDR(站点和项目组合ID),LocID(科室ID), UserID(用户ID)
/// Return：      细项ID
/// Dubug: w ##class(web.DHCPE.CT.StatOrderDetail).ImpOneLabDetailNew()
ClassMethod ImpOneLabDetailNew(CTTCCode, DetailDesc, Units, ZhToEng, OrderDR, LocID, UserID)
{
	
	s labStationId=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
  	s myId=""
  	
  	/***********插入细项表 start**********/
  	s UpdateDate=+$h,UpdateTime=$p($h,",",2)
	s ExsistFlag=##class(web.DHCPE.CT.StatOrderDetail).IsExsistODDesc(labStationId,"",LocID,CTTCCode)
	i ExsistFlag="0" d	
	.&sql( insert into SQLUSER.DHC_PE_OrderDetail
		(
			OD_ParRef,OD_Code,OD_Type,OD_Unit,
			OD_Desc,OD_LabTrakCode,OD_Sex,
			OD_UpdateDate,OD_UpdateTime,OD_UpdateUserDR
		) values(
			:labStationId,:CTTCCode,'N',:Units,
			:DetailDesc,:CTTCCode,'N',
			:UpdateDate,:UpdateTime,:UserID
		))
	.i SQLCODE'=0 s SQLCODE="-1^插入细项表失败"
	.q:SQLCODE'=0
	.s myId=%ROWID
	.s ret=##class(User.DHCPEOrderDetail).SaveDataToPowerControl(myId,LocID,UserID,"N") //插入授权表
	.If ($p(ret,"^",1)="-1") s SQLCODE="-1^细项插入记录授权表失败"	 
	.q:SQLCODE'=0
	./***********插入细项表 end**********/
	.	
  	./***********插入细项扩展表 start**********/
	.s Summary="Y",NoPrint="N",ODSetID=""
	.s UpdateDate=+$h,UpdateTime=$p($h,",",2)
	.s OrdDetailSetID=""
	.s OrdDetailSetID=$o(^CF.PE.OrderDetailSetI("IdxOfLocOrdDtl"," "_LocID,myId,0))
	.i OrdDetailSetID=""  d
	..&sql(insert into sqluser.DHC_PE_OrderDetailSet
		(
			ODS_OrderDtlDR,ODS_LocDR,ODS_Summary,ODS_NoPrint,ODS_ZhToEn,
			ODS_UpdateDate,ODS_UpdateTime,ODS_UpdateUserDR
		)values 
		(
			:myId,:LocID,:Summary,:NoPrint,:ZhToEng,
			:UpdateDate,:UpdateTime,:UserID
		))
    ..b ;插入细项扩展表  SQLCODE
	..i SQLCODE'=0 s SQLCODE="-1^插入细项扩展表失败"
	..q:SQLCODE'=0
	..s ODSetID=%ROWID //细项扩展表ID
	..s ret=##class(User.DHCPEOrderDetailSet).SaveDataToPowerControl(ODSetID,LocID,UserID)
	..If ($p(ret,"^",1)="-1") s SQLCODE="-1^细项扩展表插入记录授权表失败"	 
	..q:SQLCODE'=0
	../***********插入细项扩展表 end**********/

  	
    q myId
}

}
