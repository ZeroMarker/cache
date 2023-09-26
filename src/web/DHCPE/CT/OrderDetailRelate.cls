Import SQLuser

/// 名称: 大项和细项对照关系维护
/// 编写者：xy
/// 编写日期: 2021-08-14
Class web.DHCPE.CT.OrderDetailRelate Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：    xueying
/// CreatDate：  20211122
/// Description: 获取大项细项组合信息
/// Table：      大项细项组合表  User.DHCPEOrderDetailRelate
/// Input:       OrderID(站点项目ID),ODDetailID(细项ID),LocID(科室下拉列表值)             
/// Return：     0/1(无/有)
/// Dubug： w ##class(web.DHCPE.CT.OrderDetailRelate).GetODRelateInfo("7914")
ClassMethod GetODRelateInfo(ODRID As %String)
{
	S ^tempdhcpe("GetODRelateInfo")=$lb(ODRID)
	q:ODRID="" ""
	q:'$d(^DHCPEODR(ODRID)) ""
	q:$d(^DHCPEODR(ODRID)) $g(^DHCPEODR(ODRID))
}

/// Creator：    xueying
/// CreatDate：  20211122
/// Description: 判断科室组下是否有重复的大项细项组合
/// Table：      大项细项组合表  User.DHCPEOrderDetailRelate
/// Input:       OrderID(站点项目ID),ODDetailID(细项ID),LocID(科室下拉列表值)             
/// Return：     0/1(无/有)
/// Dubug： w ##class(web.DHCPE.CT.OrderDetailRelate).IsExsistODRelate("2||2","2||31","152")
ClassMethod IsExsistODRelate(OrderID, ODDetailID As %String, LocID As %String)
{
	S ^tempdhcpe("IsExsistODRelate")=$lb(OrderID,ODDetailID,LocID)
	s flag=0
	s ODRID=""
	f  s ODRID=$o(^DHCPEODR(0,"OrderID",OrderID,ODRID))  q:(ODRID="")||(flag=1)  d
	.s LocShowDFlag=##class(User.DHCPEOrderDetailRelate).GetLocShowDataFlag(ODRID,LocID)
    .q:LocShowDFlag'="Y"
    .s ODDR=$p($g(^DHCPEODR(ODRID)),"^",2)
    .s:(ODDR=ODDetailID) flag=1
    q flag
}

/// Creator：		xy 
/// CreatDate：		20210814
/// Description: 	大项和细项对照关系保存数据
/// Table：			大项和细项对照关系表 DHC_PE_OrderDetailRelate
/// Input: 			InString(数据信息拼串), tableName(表名),UserID(登陆用户ID),LocID(登陆科室ID)
/// Return：
/// Debug: d ##class(web.DHCPE.CT.OrderDetailRelate).SaveOrderDetailRelate("3^3650||1^1||32^1^Y^^^Y^1||2","DHC_PE_OrderDetailRelate","1","1")
ClassMethod SaveOrderDetailRelate(InString As %String = "", tableName As %String = "", UserID As %String = "", LocID As %String = "")
{
    s ^tempdhcpe("SaveOrderDetailRelate")=$lb(InString,tableName,UserID,LocID)
    n (InString,tableName,UserID,LocID)
    
    s $ZT="SaveOrderDetailRelateErr"
    s result=1
   
    s Rowid=$p(InString,"^",1)
	s ARCIMDR=$p(InString,"^",2)
    s ODDR=$p(InString,"^",3)
	s Sequence=$p(InString,"^",4)
    s Required=$p(InString,"^",5)
    s ParentDR=$p(InString,"^",6)
    s Cascade=$p(InString,"^",7)
    s NoActive=$p(InString,"^",8)
    s OrderID=$p(InString,"^",9)
    s Empower=$p(InString,"^",10)
    s Date=$p($h,",",1)
    s Time=$p($h,",",1)
  
	TSTART
	
	i (""=Rowid) {
		
		&sql(insert into DHC_PE_OrderDetailRelate(ODR_ARCIM_DR, ODR_OD_DR, ODR_Sequence, ODR_Required, ODR_Parent_DR, ODR_Cascade,ODR_OrderDR,ODR_NoActive,ODR_UpdateDate,ODR_UpdateTime,ODR_UpdateUserDR)
	     values (:ARCIMDR, :ODDR, :Sequence, :Required,:ParentDR,:Cascade,:OrderID,:NoActive,:Date,:Time,:UserID)
	     )
	
		;b ; SQLCODE
 		//大项和细项对照关系表插入数据失败
     	If (SQLCODE'=0)	 
      	{ 
        	s result="-1^插入大项和细项对照关系表失败"
        	goto SaveOrderDetailRelateErr
		
       	}   	 
	
	}else{
		s OldRecord=$g(^DHCPEODR(Rowid))
		&sql(update DHC_PE_OrderDetailRelate
	     	set ODR_ARCIM_DR = :ARCIMDR
	         ,ODR_OD_DR = :ODDR
	         ,ODR_Sequence = :Sequence
	         ,ODR_Required = :Required
	         ,ODR_Parent_DR =:ParentDR
	         ,ODR_Cascade=:Cascade
	         ,ODR_OrderDR=:OrderID
	         ,ODR_NoActive=:NoActive
	         ,ODR_UpdateDate=:Date
	         ,ODR_UpdateTime=:Time 
	         ,ODR_UpdateUserDR=:UserID
	     where ODR_RowId= :Rowid
	     )
	     
	     //大项和细项对照关系表更新数据失败
	    ;b ;SQLCODE
     	If (SQLCODE'=0)	 
      	{ 
        	s result="-1^更新大项和细项对照关系表失败"
        	goto SaveOrderDetailRelateErr
       	}
       
	}
	; b ;SQLCODE
	i (SQLCODE=0) {
		
   			s RowID=%ROWID
   			b ;tableName,RowID,LocID,UserID
   			s ret=##class(User.DHCPEOrderDetailRelate).SaveDataToPowerControl(RowID,LocID,UserID,Empower)
   			//表记录授权插入数据失败
    		If ($p(ret,"^",1)="-1")	 
    		{ 
        		s result="-1^插入记录授权表失败"
        		goto SaveOrderDetailRelateErr
		
   			 }	
   			 
   			 if (""=Rowid){	
   	    		s OldRecord=""
   	    		s NewRecord=$g(^DHCPEODR(RowID))
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_OrderDetailRelate",RowID,"I",OldRecord,NewRecord,UserID)
   	    
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        			goto SaveOrderDetailRelateErr
				}
   	    	}else{
	   	    
   	    		s NewRecord=$g(^DHCPEODR(RowID))
   	    		if (OldRecord'=NewRecord) {
   	    			s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_OrderDetailRelate",RowID,"U",OldRecord,NewRecord,UserID)
					if ($p(Logret,"^",1)="-1"){
						s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        				goto SaveOrderDetailRelateErr
					}
   	    		}
   	    	}
   		
   		
   	 }
   	 
   	TCommit
        s result="0^保存成功"
        q result  
SaveOrderDetailRelateErr
	TROLLBACK 
	//q $ZE
    q result
}

/// Creator：		xy 
/// CreatDate：		20210814
/// Description: 	查询大项和细项对照
/// Table：			大项和细项对照表 DHC_PE_OrderDetailRelate
/// Input: 			ParRef（细项表ID),NoActiveFlag(作废), tableName(表名), LocID(科室下拉列表值)
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.OrderDetailRelate","FindOrderDetailRelate","1||2","N","DHC_PE_OrderDetailRelate","1")
Query FindOrderDetailRelate(ODROrderDR As %String = "", NoActiveFlag As %String = "Y", tableName As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "ODR_RowId:%String, ODR_ARCIM_DR:%String, ODR_OD_DR:%String, ODR_ARCIM_DR_Name:%String, ODR_OD_DR_Name:%String, ODR_OD_DR_Code:%String, ODR_Sequence:%String, ODR_Required:%String, ODR_Parent_DR:%String, ODR_Parent_DR_Name:%String, ODR_Cascade:%String,TNoActive,TUpdateDate,TUpdateTime,TUserName,TEmpower,TEffPowerFlag")
{
}

ClassMethod FindOrderDetailRelateExecute(ByRef qHandle As %Binary, ODROrderDR As %String = "", NoActiveFlag As %String = "Y", tableName As %String = "", LocID As %String = "") As %Status
{
	s ^tempdhcpe("FindOrderDetailRelate")=$lb(ODROrderDR,NoActiveFlag,tableName,LocID)
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if (""=ODROrderDR) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}

 	s id="0"	//不能使用空字符串开始 s id="" ,否则会取到 0
 	f  s id=$o(^DHCPEODR(0,"OrderID",ODROrderDR,id))  q:id=""  d
	.s CurData=$g(^DHCPEODR(id))
	.//大项RowId
	.s ODRARCIMDR=$p(CurData,"^",1)
    .//大项名称(ARC_ItmMast)
    .s ARCIMSubscript=$p(ODRARCIMDR,"||",1)		
    .s ARCIMVersion=$p(ODRARCIMDR,"||",2)		
    .s ODRARCIMDRName=$p($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	.// 细项RowId
    .s ODRODDR=$p(CurData,"^",2)
    .q:ODRODDR=""
    .//细项名称
    .s STRowId=$p(ODRODDR,"||",1)
    .s ODChildSub=$p(ODRODDR,"||",2)
    .s ODRODDRName=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",1)
    .q:(""=ODRODDRName) 
    .//细项编码
    .s ODRODDRCode=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",11)
	.//顺序号
	.s ODRSequence=$p(CurData,"^",3)
	.//是否必填项
	.s ODRRequired=$p(CurData,"^",4)
	.//大类指针
	.s ODRParentDR=$p(CurData,"^",5)
	.i ""'=ODRParentDR d
	..s PODRODDR=$p($g(^DHCPEODR(ODRParentDR)),"^",2)
	..i ""'=PODRODDR
	..s PSTRowId=$p(PODRODDR,"||",1)
	..q:PSTRowId=""
	..s PODChildSub=$p(PODRODDR,"||",2)
	..s ODRParentDRName=$p($G(^DHCPEST(PSTRowId,"OD",PODChildSub)),"^",1)
	.e  d
	..s ODRParentDR=""
	..s ODRParentDRName=""
	.//层次
	.s ODRCascade=$p(CurData,"^",6)
	.i "1"=ODRCascade d
	..s ODRParentDR=""
	..s ODRParentDRName=""
	.s NoActive=$p(CurData,"^",8)
	.i NoActive="" s NoActive="Y"
	.q:( NoActiveFlag'="")&&(NoActiveFlag'=NoActive)
	.s UpdateDate=$p(CurData,"^",9)
	.i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    .s UpdateTime=$p(CurData,"^",10)
    .i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    .s UserDR=$p(CurData,"^",11)
    .i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
    .s LocShowDFlag=##class(User.DHCPEOrderDetailRelate).GetLocShowDataFlag(id,LocID)
    .q:LocShowDFlag="N"
    .s EmpowerStr=##class(User.DHCPEOrderDetailRelate).GetEmpowerFlag(id,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
	.d Build	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build      
	;d TranslateFindOrderDetailRelate
	set Data=$lb($g(id),ODRARCIMDR,ODRODDR,ODRARCIMDRName,ODRODDRName,ODRODDRCode,ODRSequence, ODRRequired,ODRParentDR,ODRParentDRName,ODRCascade,NoActive,UpdateDate,UpdateTime,UserName,Empower,EffPowerFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
TranslateFindOrderDetailRelate
	s ODRARCIMDRName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ODRARCIMDRName,"ARCIMDesc","cls")
	s ODRODDRName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEOrderDetail",ODRODDRName,"ODDesc","cls")
	s UserName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",UserName,"SSUSRName","cls")
}

/// Creator：    xueying
/// CreatDate：  20221214
/// Description: 删除大项细项对照数据
/// Table：      大项细项组合表  User.DHCPEOrderDetailRelate
/// Input:       RowID(大项细项组合ID),UserID(操作人ID),LocID(科室ID)             
/// Return：     0^删除数据成功/-1^删除失败信息
/// Dubug： w ##class(web.DHCPE.CT.OrderDetailRelate).DeleteODRelate("4","18853","105")
ClassMethod DeleteODRelate(RowID As %String = "", UserID As %String = "", LocID As %String = "")
{
	s ^TMP("DHCPE","DeleteODRelate")=$LB(RowID,UserID,LocID)
	s LocGrpID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetLocGrpByLocID(LocID)
	i LocGrpID'=""  s LocListID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetLocIDByLocGrp(LocID)
	s $ZT="DeleteODRelateErr"
	s result=1
	
	TStart
	s OldRecord=$g(^DHCPEODR(RowID))
	&sql(delete from DHC_PE_OrderDetailRelate where ODR_RowId=:RowID)
   
	If (SQLCODE'=0){ 
        s result="-1^删除大项细项组合表数据失败"
        goto DeleteODRelateErr
     }else{
	     
	    s length=$l(LocListID,"^")
		f LocNum=1:1:length d
		.s OneLocID=$p(LocListID,"^",LocNum)
		.s ret=##class(web.DHCPE.CT.StationOrder).DeletePowerControl("User.DHCPEOrderDetailRelate",RowID,OneLocID)
	    .i (ret'=0) d
        ..s result="-1^删除大项细项组合表对应的表记录授权表的数据失败"
	    ..goto DeleteODRelateErr
	    
   	    s NewRecord=""
   	    s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_OrderDetailRelate",RowID,"D",OldRecord,NewRecord,UserID)

		if ($p(Logret,"^",1)="-1"){
			s result="-1^插入删除大项细项组合表数据日志失败"_$p(Logret,"^",2)
        	goto DeleteODRelateErr
		}
	}
	TCOMMIT
	 s result="0^删除数据成功"
     q result 
	
DeleteODRelateErr
	TROLLBACK
	 q result
}

}
