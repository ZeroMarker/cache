/// 名称: VIP等级维护
/// 编写者：xy
/// 编写日期: 2021-08-08
Class web.DHCPE.CT.VIPLevel Extends %RegisteredObject
{

/// Creator：    xy 
/// CreatDate：  20210808
/// Description: VIP等级更新数据
/// Table：      VIP等级表 DHC_PE_VIPLevel 
/// Input: 
/// Return：
/// debug: d ##class(web.DHCPE.CT.VIPLevel).UpdateVIPLevel()
ClassMethod UpdateVIPLevel(ID As %String = "", InfoStr As %String)
{
	s ^tempdhcpe("UpdateVIPLevel")=$lb(ID,InfoStr)
	
	s $ZT="UpdateVIPLevelErr"
    s result=1
    
	S Code=$P(InfoStr,"^",1)
	S Desc=$P(InfoStr,"^",2)
	s VIPNoActive=$P(InfoStr,"^",3)
	s UserID=$P(InfoStr,"^",4)
	s VLCode=""
	s Date=+$h
	s Time=$p($h,",",2)
	if ID="" d
	.s obj=##class(User.DHCPEVIPLevel).%New()
	e  d
	.s OldRecord=$ListToString($g(^CT.PE.VIPLevelD(ID)),,1) // 1  缺省的默认为空

	.s obj=##class(User.DHCPEVIPLevel).%OpenId(ID)
	.s VLCode=$lg($g(^CT.PE.VIPLevelD(ID)),2)
	q:(VLCode'=Code)&&($d(^CT.PE.VIPLevelI("IdxOfCode"," "_Code))) "-1^代码重复!"
	
	s obj.VLCode=Code
	s obj.VLDesc=Desc
	s obj.VLNoActive=VIPNoActive
	s obj.VLUpdateDate=Date
    s obj.VLUpdateTime=Time
    s obj.VLUpdateUserDR=UserID
    
	TSTART
	s sc=obj.%Save()
	d obj.%Close()
	if ($System.Status.IsError(sc)) {
		if (ID="") s result="-1^新增数据失败"
		else  s result="-1^保存数据失败"
        goto UpdateVIPLevelErr
	} else {
		 s RowID=obj.%Id()
		  if (ID=""){
			s result="0^新增数据成功"	
   	    	s OldRecord=""
   	    	s NewRecord=$ListToString($g(^CT.PE.VIPLevelD(RowID)),,1) // 1  缺省的默认为空
   	    	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_VIPLevel",RowID,"I",OldRecord,NewRecord,UserID)
   	    
			if ($p(Logret,"^",1)="-1"){
				s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        		goto UpdateVIPLevelErr
			}
   	    }else{
	   	    s result="0^修改数据成功"
   	    	s NewRecord=$ListToString($g(^CT.PE.VIPLevelD(RowID)),,1) // 1  缺省的默认为空
   	    	if (OldRecord'=NewRecord) {
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_VIPLevel",RowID,"U",OldRecord,NewRecord,UserID)
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        			goto UpdateVIPLevelErr
				}
   	    	}
   	    }	  
        
		
	}
	TCommit
     
      q result  
UpdateVIPLevelErr	
	TROLLBACK 
    q result
}

/// Description: 查询VIP等级
/// Table：VIP等级表 DHC_PE_VIPLevel 
/// Input: Code(代码), Desc(描述), NoActive(作废)
/// Return：
/// Creator：xy 
/// CreatDate：20210808
/// debug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.VIPLevel","FindVIPLevel","","")
Query FindVIPLevel(Code As %String = "", Desc As %String = "", NoActive As %String = "Y") As websys.Query(ROWSPEC = "id:%String,TCode:%String,TDesc:%String,TNoActive:%String,TUpdateDate:%String,TUpdateTime:%String,TUserName:%String")
{
}

ClassMethod FindVIPLevelExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", NoActive As %String = "Y") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    s ^tempdhcpe("FindVIPLevel")=$lb(Code,Desc,NoActive)
    s ID=0
	f  s ID=$O(^CT.PE.VIPLevelD(ID)) q:ID=""  d
	.s VIPCode=$lg($g(^CT.PE.VIPLevelD(ID)),2)
	.q:(Code'="")&&(Code'=VIPCode)
	.s VIPDesc=$lg($g(^CT.PE.VIPLevelD(ID)),3)
	.q:(Desc'="")&&(VIPDesc'[Desc)
	.s VIPNoActive=$lg($g(^CT.PE.VIPLevelD(ID)),4)
	.i VIPNoActive="" s VIPNoActive="N"
	.q:(NoActive'=VIPNoActive)
	.s UpdateDate=$lg($g(^CT.PE.VIPLevelD(ID)),5)
	.i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
	.s UpdateTime=$lg($g(^CT.PE.VIPLevelD(ID)),6)
	.i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
	.s UserDR=$lg($g(^CT.PE.VIPLevelD(ID)),7)
	.s UserName=""
	.i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
	.s ^CacheTemp(repid,ind)=$lb(ID,VIPCode,VIPDesc,VIPNoActive,UpdateDate,UpdateTime,UserName)
	.s ind=ind+1
    
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Description: 科室VIP等级详情更新数据
/// Table：VIP等级表 DHC_PE_LocVIPLevel 
/// Input:
/// Return：
/// Creator：xy 
/// CreatDate：20210808
/// debug:d ##class(web.DHCPE.CT.VIPLevel).UpdateLocVIPLevel("","PT^^^^^JKTJ^^^^N^N^N^1^1^DHC_PE_LocVIPLevel^1")
ClassMethod UpdateLocVIPLevel(ID As %String = "", InfoStr As %String)
{
	s ^tempdhcpe("UpdateLocVIPLevel")=$lb(ID,InfoStr)
	s $ZT="UpdateLocVIPErr"
    s result=1		
	s HPCode=$P(InfoStr,"^",1)
	s ZYDTemplate=$P(InfoStr,"^",2)
	s ZYDInfo=$P(InfoStr,"^",3)
	s Template=$P(InfoStr,"^",4)	
	s PatFeeType=$P(InfoStr,"^",5)
	s GeneralType=$P(InfoStr,"^",6)
	s HMService=$P(InfoStr,"^",7)
	s CutInLine=$P(InfoStr,"^",8)	
	s OrdSetsDesc=$P(InfoStr,"^",9)
	s NoActive=$P(InfoStr,"^",10)
	s Secret=$P(InfoStr,"^",11)
	s Default=$P(InfoStr,"^",12)
	s LocID=$P(InfoStr,"^",13)
	s UserID=$P(InfoStr,"^",14)
	s tableName=$P(InfoStr,"^",15)
	s VIPLevelDR=$P(InfoStr,"^",16)
	s GIFlag =  $P(InfoStr,"^",17)
	s Date=+$h
	s Time=$p($h,",",2)
	
	q:(ID="")&&($d(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIPLevelDR))) "-1^该科室VIP等级详情已维护"

	if ID="" d
	.s obj=##class(User.DHCPELocVIPLevel).%New()
	e  d
	.s OldRecord=$ListToString($g(^CF.PE.LocVIPLevelD(ID)),,1) // 1  缺省的默认为空
	.s obj=##class(User.DHCPELocVIPLevel).%OpenId(ID)

	s obj.LVLLocDR=LocID
	d obj.LVLVIPLevelDRSetObjectId(VIPLevelDR)
	s obj.LVLSecret=Secret
	s obj.LVLDefale=Default
	s obj.LVLTemplate=Template
	s obj.LVLHPCode=HPCode
	s obj.LVLFeeTypeDR=PatFeeType
	s obj.LVLOrdSetsDR=OrdSetsDesc
	s obj.LVLZYDInfo=ZYDInfo
	s obj.LVLZYDTemplate=ZYDTemplate
    d obj.LVLHMServiceDRSetObjectId(HMService)
    s obj.LVLCutInLine=CutInLine
    s obj.LVLGeneralType=GeneralType
    s obj.LVLNoActive=NoActive
	s obj.LVLUpdateDate=Date
    s obj.LVLUpdateTime=Time
    s obj.LVLUpdateUserDR=UserID
    s obj.LVLGIFlag = GIFlag
    
	TSTART
	s sc=obj.%Save()
	d obj.%Close()

	If ($System.Status.IsError(sc)) { 
	
      	s result="-1^保存科室VIP详情失败"
       	goto UpdateLocVIPErr
	}else{
		s RowID=obj.%Id()
       if (ID="") {
   			
   			//b ;tableName,RowID,LocID,UserID
   			s ret=##class(User.DHCPELocVIPLevel).SaveDataToPowerControl(RowID,LocID,UserID)
   			//表记录授权插入数据失败
    		If ($p(ret,"^",1)="-1")	 
    		{ 
        		s result="-1^插入记录授权表失败"
        		goto UpdateLocVIPErr
		
   			 }
       }
       
        if (ID=""){	
         
   	    	s OldRecord=""
   	    	s NewRecord=$ListToString($g(^CF.PE.LocVIPLevelD(RowID)),,1) // 1  缺省的默认为空
   	    	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_LocVIPLevel",RowID,"I",OldRecord,NewRecord,UserID)
   	    
			if ($p(Logret,"^",1)="-1"){
				s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        		goto UpdateLocVIPErr
			}
   	    }else{
   	    	
   	    	s NewRecord=$ListToString($g(^CF.PE.LocVIPLevelD(RowID)),,1) // 1  缺省的默认为空
   	    	if (OldRecord'=NewRecord) {
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_LocVIPLevel",RowID,"U",OldRecord,NewRecord,UserID)
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        			goto UpdateLocVIPErr
				}
   	    	}
   	    }	  
        
   	}
   	
	TCommit
       	s result="0^保存成功"
        q result  
UpdateLocVIPErr
	
	TROLLBACK 
	//q $ZE
    q result
}

/// Creator：     zhongricheng
/// CreatDate：   20210918
/// Description:  更新科室VIP等级详情中导检单数据
/// Table：       VIP等级表 DHC_PE_LocVIPLevel 
/// Input:
/// Return：
/// Debug:d ##class(web.DHCPE.CT.VIPLevel).UpdDJDDataForVIP("","")
ClassMethod UpdDJDDataForVIP(ID, DJDData As %String, UserID As %String = "")
{
	s json={}
	if ID="" {
		s json.code="-1"
		s json.msg="请选择科室VIP等级！"
		q json.%ToJSON()
	}
	if DJDData="" {
		s json.code="-1"
		s json.msg="请选择对应的导诊单格式！"
		q json.%ToJSON()
	}
	
	s obj=##class(User.DHCPELocVIPLevel).%OpenId(ID)

	s:UserID="" UserID=%session.Get("LOGON.USERID")
	s Date=+$h
	s Time=$p($h,",",2)
	
	//s obj.LVLZYDInfo=$p(DJDData,"^",2)
	s obj.LVLZYDTemplate=$p(DJDData,"^",1)
    
	s obj.LVLUpdateDate=Date
    s obj.LVLUpdateTime=Time
    s obj.LVLUpdateUserDR=UserID
    
	s sc=obj.%Save()
	d obj.%Close()

	if ($System.Status.IsError(sc)) {
		s json.code="-1"
		s json.msg="保存科室VIP中导检单信息失败！"
        q json.%ToJSON()
	}
   	s json.code="0"
	s json.msg="保存成功"
    q json.%ToJSON()
}

/// Creator：    xy 
/// CreatDate：  20210808
/// Description: 查询科室VIP等级详情
/// Table：      科室VIP等级表 DHC_PE_LocVIPLevel
/// Input:       LocID(科室ID), VIPLevelID(VIP等级ID)
/// Return：
/// debug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.VIPLevel","FindLocVIPInfo","152","N","1")
Query FindLocVIPInfo(LocID As %String = "", NoActiveFlag As %String = "Y", VIPLevelID As %String = "") As websys.Query(ROWSPEC = "ID,Secret,Default,Template,FeeTypeDR,FeeType,HPCode,OrdSetsDR,OrdSets,ZYDInfo,ZYDTemplate,HMServiceDR,HMService,CutInLine,GeneralType,NoActive,UpdateDate,UpdateTime,UserName,TGIFlagDR,TGIFlag")
{
}

ClassMethod FindLocVIPInfoExecute(ByRef qHandle As %Binary, LocID As %String = "", NoActiveFlag As %String = "Y", VIPLevelID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    s ^tempdhcpe("FindLocVIPInfo")=$lb(LocID,NoActiveFlag,VIPLevelID)
    if (LocID=""){
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
    }
    s ID=0 
	f  s ID=$O(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIPLevelID,ID)) q:ID=""  d
	.s LocDR=$lg($g(^CF.PE.LocVIPLevelD(ID)),2)
	.q:(LocID'="")&&(LocDR'=LocID)
	.s VIPLevelDR=$lg($g(^CF.PE.LocVIPLevelD(ID)),3)
	.q:(VIPLevelID'="")&&(VIPLevelID'=VIPLevelDR)
	.s Secret=$lg($g(^CF.PE.LocVIPLevelD(ID)),4)
	.s Default=$lg($g(^CF.PE.LocVIPLevelD(ID)),5)
	.s Template=$lg($g(^CF.PE.LocVIPLevelD(ID)),6)
	.s FeeTypeDR=$lg($g(^CF.PE.LocVIPLevelD(ID)),7)
	.s FeeType=""
	.s:FeeTypeDR'="" FeeType=$p($g(^PAC("SUBT",FeeTypeDR)),"^",2)
	.s HPCode=$lg($g(^CF.PE.LocVIPLevelD(ID)),8)
	.s OrdSetsDR=$lg($g(^CF.PE.LocVIPLevelD(ID)),9)
	.s OrdSets=""
	.i OrdSetsDR'="" s OrdSets=$P($g(^ARCOS(OrdSetsDR)),"^",2)
	.s ZYDInfo=$lg($g(^CF.PE.LocVIPLevelD(ID)),10)
	.s ZYDTemplate=$lg($g(^CF.PE.LocVIPLevelD(ID)),11)
	.s HMServiceDR=$lg($g(^CF.PE.LocVIPLevelD(ID)),12)
	.s HMService=""
	.i HMServiceDR'="" s HMService=$lg(^User.DHCHMCServiceClassD(HMServiceDR),4)
	.s CutInLine=$lg($g(^CF.PE.LocVIPLevelD(ID)),13)
	.s GeneralType=$lg($g(^CF.PE.LocVIPLevelD(ID)),14)
	.s NoActive=$lg($g(^CF.PE.LocVIPLevelD(ID)),15)
	.i NoActive="" s NoActive="Y"	
	.q:(NoActiveFlag'=NoActive)&&(NoActiveFlag'="")
	.s UpdateDate=$lg($g(^CF.PE.LocVIPLevelD(ID)),16)
    .i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    .s UpdateTime=$lg($g(^CF.PE.LocVIPLevelD(ID)),17)
    .i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    .s UserDR=$lg($g(^CF.PE.LocVIPLevelD(ID)),18)
    .i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
    .s GIFlag=""
	.s GIFlagDR=$lg($g(^CF.PE.LocVIPLevelD(ID)),21)
	.i GIFlagDR="A" s GIFlag="所有"
	.i GIFlagDR="I" s GIFlag="个人"
	.i GIFlagDR="G" s GIFlag="团体"
	.i GIFlagDR="N" s GIFlag="不限"
	.s ^CacheTemp(repid,ind)=$lb(ID,Secret,Default,Template,FeeTypeDR,FeeType,HPCode,OrdSetsDR,OrdSets,ZYDInfo,ZYDTemplate,HMServiceDR,HMService,CutInLine,GeneralType,NoActive,UpdateDate,UpdateTime,UserName,GIFlagDR,GIFlag)
	.s ind=ind+1
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator：    xy 
/// CreatDate：  20210820
/// Description: 获取科室默认的VIP等级
/// Table：      科室VIP等级维护表  DHC_PE_LocVIPLevel 
/// Input:       LocID:科室ID
/// Return：     return=默认VIPID
/// debug: w ##class(web.DHCPE.CT.VIPLevel).GetDefaultVIP(152)
ClassMethod GetDefaultVIP(LocID As %String = "")
{
	q:LocID="" ""
	s DefaultFlag=0
	s VIPLevelDR=""
	s VIPLevelID=0
	f  s VIPLevelID=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIPLevelID))  q:(VIPLevelID="")||(DefaultFlag=1)  d
	.s LVID=0 
	.f  s LVID=$O(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIPLevelID,LVID)) q:(LVID="")||(DefaultFlag=1)  d
	..s LocDR=$lg($g(^CF.PE.LocVIPLevelD(LVID)),2)
	..s VIPLevelDR=$lg($g(^CF.PE.LocVIPLevelD(LVID)),3)
	..s Default=$lg($g(^CF.PE.LocVIPLevelD(LVID)),5)
	..i Default="Y" s DefaultFlag=1	 
	
	q VIPLevelDR
}

/// Creator:	   wangguoying
/// CreateDate:	   2022-07-01
/// Description：  根据VIP等级描述获取ID
/// Input:         VIPDesc：VIP描述 				
/// Return:		   VIPID
/// Debug: w ##class(web.DHCPE.CT.VIPLevel).GetVIPIDByDesc("普通")
ClassMethod GetVIPIDByDesc(VIPDesc)
{
	
	s ret="",id = ""
	f  s id = $O(^CT.PE.VIPLevelI("IdxOfDesc",$C(32)_VIPDesc,id))  q:(id="")||(ret'="")  d
	.q:$LG(^CT.PE.VIPLevelD(id),4)'="Y" 
	.s ret = id
	q ret
}

}
