Import SQLuser

/// 名称: 短信模板维护
/// 编写者：xy
/// 编写日期: 2021-08-09
Class web.DHCPE.CT.Station Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：	 xy 
/// CreatDate：	 20210809
/// Description: 站点表插入数据
/// Table：      站点表 DHC_PE_Station
/// Input:       Code（编码）,Desc（描述）,UserID（操作人ID）
/// Return：
/// dubug：w ##class(web.DHCPE.CT.Station).Insert()
ClassMethod Insert(Code As %String, Desc As %String, UserID As %String)
{
	s $ZT="InsertStationErr" 
    s result=1
    
    TSTART
    
	&sql(insert into DHC_PE_Station(ST_Code,ST_Desc)
	     values (:Code,:Desc))
	if (SQLCODE'=0)	{ 
        	s result="-1^插入站点表失败"
        	goto InsertStationErr
		
     }else{
		s RowID=%ROWID
		s OldRecord=""
   		s NewRecord=$g(^DHCPEST(RowID))
 		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_Station",RowID,"I",OldRecord,NewRecord,UserID)
		if ($p(Logret,"^",1)="-1"){
			s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        	goto InsertStationErr
		}
	}
	TCommit
      s result="0^新增成功"
      q result  
InsertStationErr	
	TROLLBACK 
    q result
}

/// Creator：	  xy 
/// CreatDate：	  20210809
/// Description:  站点表更新数据
/// Table：       站点表 DHC_PE_Station
/// Input:        ID(数据ID),Code（编码）,Desc（描述）,UserID（操作人ID）
/// Return：
/// dubug：w ##class(web.DHCPE.CT.Station).Update()
ClassMethod Update(ID As %String, Code As %String, Desc As %String, UserID As %String)
{
	s $ZT="UpdateStationErr" 
    s result=1
    
    TSTART
    s OldRecord=$g(^DHCPEST(ID))
	&sql(update DHC_PE_Station
	     set ST_Code =:Code,
	         ST_Desc =:Desc
	      where ST_RowId= :ID
	    )
	if (SQLCODE'=0)	{ 
        	s result="-1^更新站点表失败"
        	goto UpdateStationErr
		
     }else{
   		s NewRecord=$g(^DHCPEST(ID))
 		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_Station",ID,"U",OldRecord,NewRecord,UserID)
		if ($p(Logret,"^",1)="-1"){
			s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        	goto UpdateStationErr
		}
	}
	TCommit
      s result="0^更新成功"
      q result  
UpdateStationErr	
	TROLLBACK 
    q result
}

ClassMethod UpdateEx(ID As %String, Code As %String, Desc As %String)
{
    &sql(update DHC_PE_Station
         set ST_KBXCode =:Code,
             ST_KBItemCatDesc =:Desc
          where ST_RowId= :ID
        )
    q SQLCODE
}

/// Creator：	  xy 
/// CreatDate：	  20211231
/// Description:  查询有效站点（使用数据，只有授权的科室才显示）
/// Table：       站点表 DHC_PE_Station
/// Input:        Code(代码), Desc(描述), LocID (科室ID)
/// dubug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.Station","FindEffStation","","","152")
Query FindEffStation(Code As %String = "", Desc As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "TID:%String,TCode:%String,TDesc:%String,TEffPowerFlag:%String,TSTKBItemCatDesc:%String")
{
}

ClassMethod FindEffStationExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", LocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
  	
  	s ID="0"	                        //不能使用空字符串开始 s id="" ,否则会取到 0
	f  s ID=$o(^DHCPEST(ID)) q:ID=""  d
	.s CurData=$g(^DHCPEST(ID))
	.s LocShowDFlag = ##class(User.DHCPEStation).GetLocShowDataFlag(ID,LocID)
	.q:LocShowDFlag'="Y"
	.s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
	.s STCode=$p(CurData,"^",1)
	.q:((""'=Code)&('(STCode[Code)))
    .s STDesc=$p(CurData,"^",2)
    .q:((""'=Desc)&('(STDesc[Desc)))
	.s STKBItemCatDesc=$p(CurData,"^",14)
	.;s STDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",STDesc,"STDesc","cls")
	.;s STKBItemCatDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",STKBItemCatDesc,"STKBItemCatDesc","cls")
	.s ^CacheTemp(repid,ind)=$lb(ID,STCode,STDesc,EffPowerFlag,STKBItemCatDesc)
	.s ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator：	 xy 
/// CreatDate：  20210809
/// Description: 查询站点（使用数据，只有授权的科室才显示）
/// Table：      站点表 DHC_PE_Station
/// Input:       Code(代码), Desc(描述), LocID (科室ID)
/// dubug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.Station","FindStation","","")
Query FindStation(Code As %String = "", Desc As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "TID:%String,TCode:%String,TDesc:%String,TEffPowerFlag:%String,TSTKBItemCatDesc:%String")
{
}

ClassMethod FindStationExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", LocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
  	
  	s ID="0"	                        //不能使用空字符串开始 s id="" ,否则会取到 0
	f  s ID=$o(^DHCPEST(ID)) q:ID=""  d
	.s CurData=$g(^DHCPEST(ID))
	.s LocShowDFlag = ##class(User.DHCPEStation).GetLocShowDataFlag(ID,LocID)
	.q:LocShowDFlag'="Y"
	.s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
	.s STCode=$p(CurData,"^",1)
	.q:((""'=Code)&('(STCode[Code)))
    .s STDesc=$p(CurData,"^",2)
    .q:((""'=Desc)&('(STDesc[Desc)))
    .s StatSetID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,ID,0))
	.s Active=""
    .I StatSetID'="" s Active=$lg($g(^CF.PE.StationSetD(StatSetID)),11) 
	.q:Active'="Y"
	.s STKBItemCatDesc=$p(CurData,"^",14)
	.;s STDesc= ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",STDesc,"STDesc","cls")
	.;s STKBItemCatDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",STKBItemCatDesc,"STKBItemCatDesc","cls")
	.s ^CacheTemp(repid,ind)=$lb(ID,STCode,STDesc,EffPowerFlag,STKBItemCatDesc)
	.s ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator：    xy 
/// CreatDate：  20210809
/// Description: 查询站点(维护数据，所有数据都显示)
/// Table：      站点表 DHC_PE_Station
/// Input:       Code(代码), Desc(描述), LocID (科室ID)
/// dubug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.Station","FindStationNew","","","152")
Query FindStationNew(Code As %String = "", Desc As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "TID:%String,TCode:%String,TDesc:%String,TEffPowerFlag:%String,TSTKBItemCatDesc:%String")
{
}

ClassMethod FindStationNewExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", LocID As %String = "") As %Status
{
   
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    
  	s ID=0	                        //不能使用空字符串开始 s id="" ,否则会取到 0
	f  s ID=$o(^DHCPEST(ID)) q:ID=""  d
	.s CurData=$g(^DHCPEST(ID))
    .s EffPowerFlag=##class(User.DHCPEStation).GetLocShowDataFlag(ID,LocID)
    .s EffPowerFlag=$s(EffPowerFlag="Y":"Y",1:"N")
	.s STCode=$p(CurData,"^",1)
	.q:((""'=Code)&('(STCode[Code)))
    .s STDesc=$p(CurData,"^",2)
    .;s STDesc= ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",STDesc,"STDesc","cls")
    .q:((""'=Desc)&('(STDesc[Desc)))
	.s STKBItemCatDesc=$p(CurData,"^",14)
	.;s STKBItemCatDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",STKBItemCatDesc,"STKBItemCatDesc","cls")
	.s ^CacheTemp(repid,ind)=$lb(ID,STCode,STDesc,EffPowerFlag,STKBItemCatDesc)
	.s ind=ind+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator：    xy 
/// CreatDate：  20210809
/// Description: 科室站点详情表新增/更新数据
/// Table：      科室站点详情表 DHC_PE_StationSet
/// Input:       ID(数据ID)
/// dubug：w ##class(web.DHCPE.CT.Station).UpdateStationSet("","111^1^Y^1^1^1^Y^Y^1^1^1^DHC_PE_StationSet")
ClassMethod UpdateStationSet(ID As %String = "", InfoStr As %String)
{
	s ^tempdhcpe("UpdateStationSet")=$lb(ID,InfoStr)
	s $ZT="UpdateStationSetErr"
	s result=1	
	s Date=+$h
	s Time=$p($h,",",2)
	S Place=$P(InfoStr,"^",1)
	S Sequence=$P(InfoStr,"^",2)
	s AutoAudit=$P(InfoStr,"^",3)
	s LayoutType=$P(InfoStr,"^",4)
	S ButtonType=$P(InfoStr,"^",5)
	S ReportSequence=$P(InfoStr,"^",6)
	s AllResultShow=$P(InfoStr,"^",7)
	s Active=$P(InfoStr,"^",8)
	s LocID=$P(InfoStr,"^",9)
	s UserID=$P(InfoStr,"^",10)
	s StationID=$P(InfoStr,"^",11)
	s tableName=$P(InfoStr,"^",12)
	q:($d(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,StationID)))&&(ID="") "-1^该科室站点详情已维护"
	
	if ID="" d
	.s obj=##class(User.DHCPEStationSet).%New()
	e  d
	.s OldRecord=$ListToString($g(^CF.PE.StationSetD(ID)))
	.s obj=##class(User.DHCPEStationSet).%OpenId(ID)
	
	d obj.SSStationDRSetObjectId(StationID)
	s obj.SSLocDR=LocID
	s obj.SSPlace=Place
	s obj.SSSequence=Sequence
	s obj.SSAutoAudit=AutoAudit
	s obj.SSLayoutType=LayoutType
	s obj.SSButtonType=ButtonType
	s obj.SSReportSequence=ReportSequence
	s obj.SSAllResultShow=AllResultShow
	s obj.SSActive=Active
	s obj.SSUpdateDate=Date
	s obj.SSUpdateTime=Time
	s obj.SSUpdateUserDR=UserID

    TSTART
	s sc=obj.%Save()
	d obj.%Close()
	;b ;obj.%Id()
	If ($System.Status.IsError(sc))	 
     { 
        s result="-1^保存科室站点详情失败"
        goto UpdateStationSetErr
		
      }else{
	   
	   s RowID=obj.%Id()
       if (ID="") {     
   			;b ;tableName,RowID,LocID,UserID
   			s ret=##class(User.DHCPEStationSet).SaveDataToPowerControl(RowID,LocID,UserID)
   			//表记录授权插入数据失败
    		If ($p(ret,"^",1)="-1")	 
    		{ 
        		s result="-1^插入记录授权表失败"
        		goto UpdateStationSetErr	
		
   			 }
       }
       
        if (ID=""){	
   	    	s OldRecord=""
   	    	s NewRecord=$ListToString($g(^CF.PE.StationSetD(RowID)))
   	    	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_StationSet",RowID,"I",OldRecord,NewRecord,UserID)
			if ($p(Logret,"^",1)="-1"){
				s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        		goto UpdateStationSetErr	
			}
   	    }else{
   	    	s NewRecord=$ListToString($g(^CF.PE.StationSetD(RowID)))
   	    	if (OldRecord'=NewRecord) {
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_StationSet",RowID,"U",OldRecord,NewRecord,UserID)
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        			goto UpdateStationSetErr	
				}
   	    	}
   	    }	  
           		
   		
   	}
	   
	TCommit
        s result="0^保存成功"
        q result  
UpdateStationSetErr	
	TROLLBACK 
	//q $ZE
    q result
}

/// Creator：     xy 
/// CreatDate：   20210809
/// Description:  查询科室站点详情
/// Table：       科室站点详情表 DHC_PE_StationSet
/// Input:        StaionID(站点ID),LocID(科室ID)
/// Dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.Station","FindStationSet","1","1")
Query FindStationSet(StaionID As %String = "", LocID As %String = "", Desc As %String = "", STActive As %String = "") As websys.Query(ROWSPEC = "TSTSID,TStationID,TStationDesc,TStationCode,TPlace,TSequence,TAutoAudit,TLayoutTypeDR,TLayoutType,TButtonTypeDR,TButtonType,TReportSequence,TAllResultShow,TActive,TUpdateDate,TUpdateTime,TUpdateUserName,TSingleLine")
{
}

ClassMethod FindStationSetExecute(ByRef qHandle As %Binary, StaionID As %String = "", LocID As %String = "", Desc As %String = "", STActive As %String = "") As %Status
{
	s ^tempdhcpe("FindStationSet")=$lb(StaionID,LocID,Desc,STActive)
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    if ((StaionID="")&&(LocID="")) 
    {
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
    }
    if (StaionID'=""){
	    s ID=""	           
		f  s ID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,StaionID,ID)) q:ID=""  d
	    .d GetLocStationList
    }else{
	    s LocStaionID=""	           
		f  s LocStaionID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,LocStaionID)) q:LocStaionID=""  d
		.s ID=""	           
		.f  s ID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,LocStaionID,ID)) q:ID=""  d
		..d GetLocStationList
	    
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
GetLocStationList
	s StationDR=$lg($g(^CF.PE.StationSetD(ID)),2) 
	s StationDesc="",StationCode=""
	i StationDR'="" d
	.s StationDesc=$P($g(^DHCPEST(StationDR)),"^",2)
	.s StationCode=$P($g(^DHCPEST(StationDR)),"^",1)
	q:(Desc'="")&&(StationDesc'[Desc)
	s powerFlg = ##class(User.DHCPEStation).GetLocShowDataFlag(StationDR,LocID)
	q:powerFlg'="Y" 
	s Place=$lg($g(^CF.PE.StationSetD(ID)),4) 
	s Sequence=$lg($g(^CF.PE.StationSetD(ID)),5) 
	s AutoAudit=$lg($g(^CF.PE.StationSetD(ID)),6) 
	s LayoutTypeDR=$lg($g(^CF.PE.StationSetD(ID)),7)
	i LayoutTypeDR'="" s LayoutType=..GetLayoutDesc(LayoutTypeDR)
	s ButtonTypeDR=$lg($g(^CF.PE.StationSetD(ID)),8) 
	i ButtonTypeDR'="" s ButtonType=..GetButtonDesc(ButtonTypeDR)
	s ReportSequence=$lg($g(^CF.PE.StationSetD(ID)),9) 
	s AllResultShow=$lg($g(^CF.PE.StationSetD(ID)),10) 
	s Active=$lg($g(^CF.PE.StationSetD(ID)),11) 
	q:(STActive'="")&&(STActive'=Active) 
	s UpdateDate= $lg($g(^CF.PE.StationSetD(ID)),12)
	i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
	s UpdateTime=$lg($g(^CF.PE.StationSetD(ID)),13)
	i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
	s UpdateUserDR=$lg($g(^CF.PE.StationSetD(ID)),14) 
	s UpdateUserName=""
	;i UpdateUserDR'="" s UpdateUserName=$p($g(^SSU("SSUSR",UpdateUserDR)),"^",2)
	i UpdateUserDR'=""
	{
		s UpdateUserName=$p($g(^SSU("SSUSR",UpdateUserDR)),"^",2)
	}
	s SingleLine=$lg($g(^CF.PE.StationSetD(ID)),15) 	
	d FindBuild 
 	q	
FindBuild 
	;s StationDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",StationDesc,"STDesc","cls")
	;s UpdateUserName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",UpdateUserName,"SSUSRName","cls")
	set Data=$lb(ID,StationDR,StationDesc,StationCode,Place,Sequence,AutoAudit,LayoutTypeDR,LayoutType,ButtonTypeDR,ButtonType,ReportSequence,AllResultShow,Active,UpdateDate,UpdateTime,UpdateUserName,SingleLine)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator：     xy 
/// CreatDate：  20210810
/// Description: 获取按钮类型描述
/// dubug：w ##class(web.DHCPE.CT.Station).GetButtonDesc()
ClassMethod GetButtonDesc(Type)
{
	q:Type=1 "标准"
	q:Type=2 "妇科"
	q:Type=3 "超声"
	;q:Type=1 ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stationset.csp","标准")
	;q:Type=2 ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stationset.csp","妇科")
	;q:Type=3 ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stationset.csp","超声")
	q ""
}

/// Creator：    xy 
/// CreatDate：  20210810
/// Description: 获取界面类型描述
/// dubug：w ##class(web.DHCPE.CT.Station).GetLayoutDesc()
ClassMethod GetLayoutDesc(Type)
{
	q:Type=1 "简化"
	q:Type=2 "详细"
	q:Type=3 "普通化验"
	q:Type=4 "接口化验"
	q:Type=5 "普通检查"
	q:Type=6 "接口检查"
	q:Type=7 "其它"
	q:Type=8 "药品"

	;q:Type=1 ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stationset.csp","简化")
	;q:Type=2 ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stationset.csp","详细")
	;q:Type=3 ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stationset.csp","普通化验")
	;q:Type=4 ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stationset.csp","接口化验")
	;q:Type=5 ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stationset.csp","普通检查")
	;q:Type=6 ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stationset.csp","接口检查")
	;q:Type=7 ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stationset.csp","其它")
	;q:Type=8 ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stationset.csp","药品")
	q ""
}

/// Creator：	 xy 
/// CreatDate：	 20230515
/// Description: 检验站点下直接导入细项
/// Input:       StationID（站点ID）,LocID（科室ID）,UserID（操作人ID）,LocStr（科室组）
/// Return：     0/非0
/// dubug：w ##class(web.DHCPE.CT.Station).ImportLISOD()
ClassMethod ImportLISOD(StationID As %String, LocID As %String, UserID As %String, LocStr As %String)
{
	
    s hospId=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(LocID)  
    s flag=0
    
    s LabStationID=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
    
    s id="0"    
    f  s id=$O(^DHCPEST(StationID,"O",id)) q:id=""  d
    .q:LabStationID'=StationID
    .
    .s iARCIMDR=$p($g(^DHCPEST(StationID,"O",id)),"^",1)
    .q:iARCIMDR=""
    .
    .s iARCIMDesc=$p($G(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1)),"^",2)
    .s EffDate=$p($g(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),7)),"^",1)
    .i EffDate="" s EffDate=+$H+1
    .q:EffDate<+$H
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",iARCIMDR,hospId)
    .q:(HOSPshowFlag="N")
    .s LocShowDFlag=##class(User.DHCPEStationOrder).GetLocShowDataFlag(StationID_"||"_id,LocID)
    .q:LocShowDFlag'="Y"
    .s TActive=$p($g(^DHCPEST(StationID,"O",id)),"^",9)
    .q:TActive'="Y"
    .s flag=##class(web.DHCPE.TransOrderDetail).MainNew(iARCIMDR,StationID,StationID_"||"_id,LocID,UserID,LocStr)
    .i $p(flag,"^",1)="-1" s flag=flag_":   "_iARCIMDesc
    .i $p(flag,"^",1)="-1" s ^DHCPEDataEx("ImportLISOD",LocID,iARCIMDR)=$LB($H,$p(flag,"^",2))
   
    q flag
}

}
