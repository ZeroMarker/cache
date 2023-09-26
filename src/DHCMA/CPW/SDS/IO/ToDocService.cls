/// 名称: DHCMA.CPW.SDS.IO.ToDocService
/// 描述: 为医生站提供单病种接口方法
/// 编写者：zhugz
/// 编写日期: 2020-2-11
Class DHCMA.CPW.SDS.IO.ToDocService Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:  检查是否单病种、当前提示天数（总天数）、提示内容
/// Table：       DHCMA.CPW.SD.QCEntityMatchRule,DHCMA.CPW.SD.QCEntityTips
/// Input：       aEpisodeID：就诊号 aTipsType:诊疗Diag、术前BOper、术中IOper、术后AOper
/// Return：      否单病种、当前提示天数（总天数）、提示内容
/// w ##class(DHCMA.CPW.SDS.IO.ToDocService).GetSDTipsByAdm("96")
ClassMethod GetSDTipsByAdm(aEpisodeID As %String, aTipsType As %String = "", aDocID As %String = "", aLocID As %String = "", aWardID As %String = "") As %String
{
	New (aEpisodeID,aTipsType,aDocID,aLocID,aWardID)
	Set return=""
	Set ^tmpzgz215=aEpisodeID
	Quit:(aEpisodeID="") return
	Set MrListID="",MrFlg=0
	Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(aEpisodeID)
	IF (aDocID="") {
 			Set ObjPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
 			Set aDocID=ObjPaadm.PAAdmDocID
 			Set aLocID=ObjPaadm.PAAdmLocID
 			Set aWardID=ObjPaadm.PAAdmWardID
		}
	IF ($d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))){
		Set xMrlistID=""
		For {
				Set xMrlistID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,xMrlistID))
				Quit:xMrlistID=""
				Quit:+MrListID>0
				Set xMrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xMrlistID)
				Set:xMrListObj.QCState'="O" MrListID=xMrlistID
				}
	}
	//如果患者未进入单病种
	IF (MrFlg'=1) {
		Set MRAdm=$p($g(^PAADM(+aEpisodeID)),"^",61)
		Quit:MRAdm="" return
		Set MRDIASub=$o(^MR(MRAdm,"DIA",""),-1)
		Quit:MRDIASub="" return
		Set ICDDR=$p($g(^MR(MRAdm,"DIA",MRDIASub)),"^",1)
		Set ICD10=$p($g(^MRC("ID",+ICDDR)),"^",4)
		Set EntityID=""
		For {
			Set EntityID        = $o(^DHCMA.CPW.SD.QCEntityD(EntityID))
		 	Quit:EntityID=""
		 	Quit:+MrListID>0  	//如果已入组，则不再判断其他单病种
		 	Set objEntity        = ##class(DHCMA.CPW.SD.QCEntity).GetObjById(EntityID)
		 	Set IsActive         = objEntity.BTIsActive
		 	Set BTLocation		 = objEntity.BTLocation
		 	
		 	//按照关联科室过滤患者
		 	Continue:(BTLocation'="")&&($listfind(BTLocation,aLocID)=0)
		 	Continue:IsActive'=1
		 	
		 	//遍历病种的配置项目
		 	Set RuleSubID="",InMrFlg=""	
		 	For
		 	{	
		 		Set RuleSubID=$o(^DHCMA.CPW.SD.QCEntityMatchRuleI("IndexParref",EntityID,RuleSubID))
		 		Quit:RuleSubID=""
		 		Set RuleID = EntityID_"||"_RuleSubID
		 		Set ObjRule = ##class(DHCMA.CPW.SD.QCEntityMatchRule).GetObjById(RuleID)
		 		Set IsActive          	= ObjRule.IsActive
		 		Continue:IsActive'=1
		 		Set RuleType          	= ObjRule.RuleType
		 		Continue:RuleType'=1    //只判断准入条件
		 		Set RuleParam          	= ObjRule.RuleParam	
		 		Set RuleParam=$tr(RuleParam,"~","-")
				Set RuleParam=$tr(RuleParam,"、",",")
		 		For i=1:1:$l(RuleParam,",")
				{
					Set xDiagCode=$p(RuleParam,",",i)
					Set flag=..CheckICDArea(ICD10,xDiagCode)
					Set:flag=1 InMrFlg="Y"
					Quit:flag=1
				}
		 	}
			IF (InMrFlg="Y") {
				//如果满足准入条件，直接进入单病种列表
	 			Set InputStr=EpisodeID_"^"_""_"^"_EntityID_"^"_aDocID_"^"_aLocID_"^"_aWardID
	 			Set MrListID=##class(DHCMA.CPW.SDS.QCMrListSrv).InQCEntity(InputStr)
	 			IF (+MrListID>0 ) {
		 			//添加病历状态记录
		 			Set StateStr=MrListID_"^"_"I"_"^"_aLocID
		 			Set StateID=##class(DHCMA.CPW.SD.QCMrListState).Update(StateStr)
	 			}	
		 	}
		}	
	}
	Quit:+MrListID=0 return
	//如果患者已入有效单病种
	Set MrObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrListID)
	Set InMrDate	= MrObj.QCInDate
	Set EntityID	= MrObj.QCEntityDr.%Id()
	Set InHosDays	= MrObj.QCEntityDr.BTInDays
	Set TotalFee	= MrObj.QCEntityDr.BTTotalFee
	//检查提醒时机
	Set TipsType=""
	For{
	 	Set TipsType=$o(^DHCMA.CPW.SD.QCEntityTipsI("IndexPType",EntityID,TipsType))
	 	Quit:TipsType=""
	 	//提示类型索引
	 	Set SubID=$o(^DHCMA.CPW.SD.QCEntityTipsI("IndexPType",EntityID,TipsType,""),-1)
	 	Set xID=EntityID_"||"_SubID
	 	Set obj=##class(DHCMA.CPW.SD.QCEntityTips).GetObjById(xID)
	 	Continue:'$IsObject(obj)
		Set TipType		= obj.TipType        		
		Set TipDays		= obj.TipDays        			
		Set TipProxy	= obj.TipProxy   			
		Set TipContent	= obj.TipContent
		Continue:TipContent=""
		Continue:(aTipsType'="")&&(aTipsType'[TipType)
		//如果不是持续提醒，已经提醒过则不再提醒
		Continue:(TipDays="")&&($d(^DHCMA.CPW.SD.QCMrListTipsI("IndexMrType",MrListID,TipType)))
		
		//如果当天已经提醒过则不再提醒
		Continue:$d(^DHCMA.CPW.SD.QCMrListTipsI("IndexMrTypeDate",MrListID,TipType,+$h))
		If (TipType="Diag") {
			
			//超过提示日期则不再提醒，提示当天算一天。
			;Continue:(+$h-TipDays)>=InMrDate   

			//检查是否单病种^当前提示天数（总天数）^提示内容
			Set IndDay=+$h-InMrDate+1
			
			Set return="Y^当前提示天数:"_IndDay_"天(共"_TipDays_"天)^"_TipContent
		}elseIf(TipType="AOper"){
			
			//术后AOper:接口返回是否术后^手术日期
			Set %EpisodeID=aEpisodeID
			Set exp="Set ret="_RuleMethod
			x exp
			Set AOperFlg=$p(ret,"^",1)
			Set OperDate=$p(ret,"^",2)
			Continue:AOperFlg'="Y"
			Set IndDay=+$h-OperDate+1
			Set return="Y^当前提示天数:"_IndDay_"天(共"_TipDays_"天)^"_TipContent
		}else{
			
			//术前BOper:接口返回是否术前;术中IOper:接口返回是否术中
			Set %EpisodeID=aEpisodeID
			Set exp="Set ret="_RuleMethod
			x exp
			Continue:ret'["Y"
			Set return="Y^^"_TipContent
		}
	}
	Set:return'="" return=return_"^"_InHosDays_"^"_TotalFee
	Quit return
}

/// 获取术前术中术后信息
/// w ##class().GetOperInfo()
ClassMethod GetOperInfo(aOperTime As %String) As %String
{
	new (%EpisodeID,aOperTime)
	Set return=""
	Quit:(aOperTime="")||(%EpisodeID="") return
	//取术前信息接口
	
	//取术中信息接口
	
	//取术后信息接口
}

/// 准入ICD范围检查方法
/// w ##Class(DHCMA.CPW.SDS.IO.ToDocService).CheckICDArea("J45","J45-J46")
ClassMethod CheckICDArea(argICD As %String, argArea As %String) As %String
{
	New (argICD,argArea)
	Set return=-1
	Quit:(argArea="")||(argICD="") return
	Set:$e(argICD,$l(argICD))'=" " argICD=argICD_" "
	Set argArea=$tr(argArea,"，",",")
	Set argArea=$tr(argArea,"－","-")
	Set argArea=$tr(argArea,"~","-")
	For Index=1:1:$l(argArea,",") {
		Set Area=$p(argArea,",",Index)
		Continue:Area=""
		Set Area1=$p(Area,"-",1)
		Set Area2=$p(Area,"-",2)
		If (Area1'="")&&(Area2'="") {
			Kill ICD,ICDO
			Set ICD(" "_Area1)=""
			Set ICD(" "_Area2)=""
			If $o(ICD(" "_Area1))="" {
				Set Areatmp=Area1
				Set Area1=Area2
				Set Area2=Areatmp
			}
			
			Set ICD=$o(ICD(" "_argICD),-1)
			Set ICDO=$e(ICD,2,$l(ICD))
			Set:(ICDO=Area1) return=1
			Set:(ICDO=Area2)&&($e(argICD,1,$l(Area2))=Area2) return=1
		} Else {
			Set:$e(argICD,1,$l(Area))=Area return=1
		}
	}
	
	Quit return
}

/// 准入关键词范围检查方法
/// 多个关键字并列用 & 连接
/// w ##Class(DHCMA.CPW.SDS.QCInterface).CheckKeyArea("CCC","AAA,BBB")
ClassMethod CheckKeyArea(argDiagDesc As %String, argArea As %String) As %String
{
	New (argDiagDesc,argArea)
	Set return=-1
	Quit:(argArea="")||(argDiagDesc="") return
	
	Set argArea=$tr(argArea,"，",",")
	Set argArea=$tr(argArea,"－","-")
	Set argArea=$tr(argArea,"~","-")
	Set argDiagDesc=$tr(argDiagDesc,"，",",")
	Set argDiagDesc=$tr(argDiagDesc,"－","-")
	Set argDiagDesc=$tr(argDiagDesc,"~","-")
	For Index=1:1:$l(argArea,",") {
		Set Area=$p(argArea,",",Index)
		Continue:Area=""
		Set flg=1
		for AInd=1:1:$l(Area,"&") {
			Set xArea=$p(Area,"&")
			continue:xArea=""
			Set:argDiagDesc'[xArea flg=-1
		}
		Continue:flg<1
		Set return=1
		Quit 
	}
	Quit return
}

/// Description:  获取单病种相关信息
/// Table：       DHCMA.CPW.SD.QCMrList
/// Input：       aEpisodeID：就诊号 
/// Return：      单病种相关信息
/// w ##class(DHCMA.CPW.SDS.IO.ToDocService).GetSDInfoByAdm("587")
ClassMethod GetSDInfoByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	Set MrListID="",MrFlg=0
	Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(aEpisodeID)
	IF ($d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))){
		Set xMrlistID=""
		For {
				Set xMrlistID	=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,xMrlistID))
				Quit:xMrlistID=""
				Set xMrListObj	=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xMrlistID)
				Continue:xMrListObj.QCState="O"
				Set return = xMrListObj.QCEntityDr.BTDesc
				Quit
			}
	}
	Set:return'="" return="单病种【"_return_"】"
	Quit return
}

/// 通过手术编码确定是否入组单病种，如果已经入组 返回入组提示。
/// w ##class(DHCMA.CPW.SDS.IO.ToDocService).InSDByOperCode("")
/// Input：	aEpisodeID 	就诊号
/// 			aOperCode	手术编码Code
/// 			aDocID 		医护人员ID
/// 			aLocID		科室ID	
/// 			aWardID		病区ID
ClassMethod InSDByOperCode(aEpisodeID As %String, aOperCode As %String, aDocID As %String, aLocID As %String, aWardID As %String) As %String
{
	new (aEpisodeID,aOperCode)
	Set return=""
	Quit:(aEpisodeID="")||(aOperCode="") return
	Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(aEpisodeID)
	Set MrListID=""
	IF ($d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))){
		Set xMrlistID=""
		For {
				Set xMrlistID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,xMrlistID))
				Quit:xMrlistID=""
				Quit:+MrListID>0
				Set xMrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xMrlistID)
				Set:xMrListObj.QCState'="O" MrListID=xMrlistID
				}
		//如果已入单病种则不再提示
		Quit:+MrListID>0 return
	}
	Set EntityID=""
	For {
		Set EntityID        = $o(^DHCMA.CPW.SD.QCEntityD(EntityID))
	 	Quit:EntityID=""
	 	Quit:+MrListID>0  	//如果已入组，则不再判断其他单病种
	 	Set objEntity        = ##class(DHCMA.CPW.SD.QCEntity).GetObjById(EntityID)
	 	Set IsActive         = objEntity.BTIsActive
	 	Set BTLocation		 = objEntity.BTLocation
	 	
	 	//按照关联科室过滤患者
	 	Continue:(BTLocation'="")&&($listfind(BTLocation,aLocID)=0)
	 	Continue:IsActive'=1
	 	
	 	//遍历病种的配置项目
	 	Set RuleSubID=""
	 	For
	 	{	
	 		Set RuleSubID=$o(^DHCMA.CPW.SD.QCEntityMatchRuleI("IndexParref",EntityID,RuleSubID))
	 		Quit:RuleSubID=""
	 		Set RuleID = EntityID_"||"_RuleSubID
	 		Set ObjRule = ##class(DHCMA.CPW.SD.QCEntityMatchRule).GetObjById(RuleID)
	 		Set IsActive          	= ObjRule.IsActive
	 		Continue:IsActive'=1
	 		Set RuleType          	= ObjRule.RuleType
	 		Continue:RuleType'=1    //只判断准入条件
	 		Set RuleParam          	= ObjRule.RuleParam	
	 		Set RuleParam=$tr(RuleParam,"~","-")
			Set RuleParam=$tr(RuleParam,"、",",")
	 		For i=1:1:$l(RuleParam,",")
			{
				Set xDiagCode=$p(RuleParam,",",i)
				Set flag=..CheckICDArea(aOperCode,xDiagCode)
				Set:flag=1 InMrFlg="Y"
				Quit:flag=1
			}
	 	}
		IF (InMrFlg="Y") {
			//如果满足准入条件，直接进入单病种列表
 			Set InputStr=EpisodeID_"^"_""_"^"_EntityID_"^"_aDocID_"^"_aLocID_"^"_aWardID
 			Set MrListID=##class(DHCMA.CPW.SDS.QCMrListSrv).InQCEntity(InputStr)
 			IF (+MrListID>0 ) {
	 			//添加病历状态记录
	 			Set StateStr=MrListID_"^"_"I"_"^"_aLocID
	 			Set StateID=##class(DHCMA.CPW.SD.QCMrListState).Update(StateStr)
 			}	
	 	}
	 	
	}	
	Quit:+MrListID=0 return
	//如果患者已入有效单病种
	Set MrObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrListID)
	Set InMrDate	= MrObj.QCInDate
	Set EntityID	= MrObj.QCEntityDr.%Id()
	Set InHosDays	= MrObj.QCEntityDr.BTInDays
	Set TotalFee	= MrObj.QCEntityDr.BTTotalFee
	//检查提醒时机
	Set TipsType=""
	For{
	 	Set TipsType=$o(^DHCMA.CPW.SD.QCEntityTipsI("IndexPType",EntityID,TipsType))
	 	Quit:TipsType=""
	 	//提示类型索引
	 	Set SubID=$o(^DHCMA.CPW.SD.QCEntityTipsI("IndexPType",EntityID,TipsType,""),-1)
	 	Set xID=EntityID_"||"_SubID
	 	Set obj=##class(DHCMA.CPW.SD.QCEntityTips).GetObjById(xID)
	 	Continue:'$IsObject(obj)
		Set TipType		= obj.TipType        		
		Set TipDays		= obj.TipDays        			
		Set TipProxy	= obj.TipProxy   			
		Set TipContent	= obj.TipContent
		Continue:TipContent=""
		Continue:(aTipsType'="")&&(aTipsType'[TipType)
		//如果不是持续提醒，已经提醒过则不再提醒
		Continue:(TipDays="")&&($d(^DHCMA.CPW.SD.QCMrListTipsI("IndexMrType",MrListID,TipType)))
		
		//如果当天已经提醒过则不再提醒
		Continue:$d(^DHCMA.CPW.SD.QCMrListTipsI("IndexMrTypeDate",MrListID,TipType,+$h))
		If (TipType="Diag") {
			
			//超过提示日期则不再提醒，提示当天算一天。
			;Continue:(+$h-TipDays)>=InMrDate   

			//检查是否单病种^当前提示天数（总天数）^提示内容
			Set IndDay=+$h-InMrDate+1
			
			Set return="Y^当前提示天数:"_IndDay_"天(共"_TipDays_"天)^"_TipContent
		}elseIf(TipType="AOper"){
			
			//术后AOper:接口返回是否术后^手术日期
			Set %EpisodeID=aEpisodeID
			Set exp="Set ret="_RuleMethod
			x exp
			Set AOperFlg=$p(ret,"^",1)
			Set OperDate=$p(ret,"^",2)
			Continue:AOperFlg'="Y"
			Set IndDay=+$h-OperDate+1
			Set return="Y^当前提示天数:"_IndDay_"天(共"_TipDays_"天)^"_TipContent
		}else{
			
			//术前BOper:接口返回是否术前;术中IOper:接口返回是否术中
			Set %EpisodeID=aEpisodeID
			Set exp="Set ret="_RuleMethod
			x exp
			Continue:ret'["Y"
			Set return="Y^^"_TipContent
		}
	}
	Set:return'="" return=return_"^"_InHosDays_"^"_TotalFee
	Quit return
}

/// w ##class(DHCMA.CPW.SDS.IO.ToDocService).GetPatFee()
ClassMethod GetPatFee(Admid) As %String
{
 	n (Admid)
 	k ^TEMPDHCFee($j)
 	s pbId=0 f  s pbId=$o(^DHCPB(0,"ADM",Admid,pbId)) q:pbId=""  d
 	.s pboId=0 f  s pboId=$o(^DHCPB(pbId,"O",pboId)) q:pboId=""  d
 	..s pbdId=0 f  s pbdId=$o(^DHCPB(pbId,"O",pboId,"D",pbdId)) q:pbdId=""  d
 	...s tariDr=$p(^DHCPB(pbId,"O",pboId,"D",pbdId),"^",3)  ;DHC_TarItem
 	...s amount=$p(^DHCPB(pbId,"O",pboId,"D",pbdId),"^",7)
 	...q:tariDr=""
 	...s mrCate=$p(^DHCTARI(tariDr),"^",30)	           ; DHC_TarMCCateNew  病案子类
 	...q:$g(mrCate)=""
 	...s bigmrCate=$p(^DHCTarC("MCNew",mrCate),"^",3)  ; DHC_TarMCNew  病案大类
 	...s ^TEMPDHCFee($j,"mrCate",mrCate)=$g(^TEMPDHCFee($j,"mrCate",mrCate))+$g(amount)
 	...s ^TEMPDHCFee($j,"bigmrCate",bigmrCate)=$g(^TEMPDHCFee($j,"bigmrCate",bigmrCate))+$g(amount)
 	...s ^TEMPDHCFee($j,"allfee")=$g(^TEMPDHCFee($j,"allfee"))+$g(amount)
 	
 	s fee1=0,fee2=0,fee3=0,fee4=0,fee5=0,fee6=0,fee7=0,fee8=0,fee9=0,fee10=0,fee11=0,fee12=0,fee13=0,fee14=0,fee15=0,fee16=0,fee17=0,fee18=0,fee19=0,fee20=0,fee21=0,fee22=0,fee23=0,fee24=0,fee25=0,fee26=0,fee27=0,fee28=0,fee29=0,fee30=0
 	s fee1=$g(^TEMPDHCFee($j,"bigmrCate",1))
    s fee2=$g(^TEMPDHCFee($j,"bigmrCate",2))
    s fee3=$g(^TEMPDHCFee($j,"bigmrCate",3))
    s fee4=$g(^TEMPDHCFee($j,"bigmrCate",4))
    s fee5=$g(^TEMPDHCFee($j,"bigmrCate",5))
    s fee6=$g(^TEMPDHCFee($j,"bigmrCate",6))
    s fee7=$g(^TEMPDHCFee($j,"bigmrCate",7))
    s fee8=$g(^TEMPDHCFee($j,"bigmrCate",8))
    s fee9=$g(^TEMPDHCFee($j,"bigmrCate",9))
    s fee10=$g(^TEMPDHCFee($j,"bigmrCate",10))
    s fee11=$g(^TEMPDHCFee($j,"mrCate",11))
    s fee12=$g(^TEMPDHCFee($j,"bigmrCate",11))
    s fee13=$g(^TEMPDHCFee($j,"bigmrCate",12))
    s fee14=$g(^TEMPDHCFee($j,"bigmrCate",13))
    s fee15=$g(^TEMPDHCFee($j,"bigmrCate",14))
    s fee16=$g(^TEMPDHCFee($j,"bigmrCate",15))
    s fee17=$g(^TEMPDHCFee($j,"bigmrCate",16))
    s fee18=$g(^TEMPDHCFee($j,"bigmrCate",17))
    s fee19=$g(^TEMPDHCFee($j,"bigmrCate",18))
    s fee20=$g(^TEMPDHCFee($j,"mrCate",20))
    s fee21=$g(^TEMPDHCFee($j,"mrCate",21))
    s fee22=$g(^TEMPDHCFee($j,"bigmrCate",19))
    s fee23=$g(^TEMPDHCFee($j,"mrCate",23))
    s fee24=$g(^TEMPDHCFee($j,"bigmrCate",20))
    s fee25=$g(^TEMPDHCFee($j,"bigmrCate",21))
    s fee26=$g(^TEMPDHCFee($j,"bigmrCate",22))
    s fee27=$g(^TEMPDHCFee($j,"bigmrCate",23))
    s fee28=$g(^TEMPDHCFee($j,"bigmrCate",24))
    s fee29=$g(^TEMPDHCFee($j,"allfee"))    
 	s fee30=..GetPersonGrzf(Admid)
 	
 	s ret=fee1_"^"_fee2_"^"_fee3_"^"_fee4_"^"_fee5_"^"_fee6_"^"_fee7_"^"_fee8_"^"_fee9_"^"_fee10_"^"_fee11_"^"_fee12_"^"_fee13_"^"_fee14_"^"_fee15_"^"_fee16_"^"_fee17_"^"_fee18_"^"_fee19_"^"_fee20_"^"_fee21_"^"_fee22_"^"_fee23_"^"_fee24_"^"_fee25_"^"_fee26_"^"_fee27_"^"_fee28_"^"_fee29_"^"_fee30
 	k ^TEMPDHCFee($j)
 	q ret
}

/// 根据就诊获取患者个人自付金额
ClassMethod GetPersonGrzf(PAAdmID As %String) As %String
{
	set Atm=0
	quit:PAAdmID="" Atm
	set billid=$o(^DHCPB(0,"ADM",PAAdmID,""))
	quit:billid="" Atm
	set PatInsTypeDR=$P($g(^DHCPB(billid)),"^",4)
	if (PatInsTypeDR=2){
		set InsuPayMOdeAmt=..getInsuPayMOdeAmtByPbDrNew("",billid)
		set Atm=$p($p(InsuPayMOdeAmt,"个人现金支付:",2),"^",1)
	}else{
		set Atm=$P($g(^DHCPB(billid)),"^",8)
	}
	
	quit Atm
}

/// 通过账单号获取医保各支付方式金额
ClassMethod getInsuPayMOdeAmtByPbDrNew(PrtRowId As %String, BillNo As %String) As %String
{
	
    q:(BillNo="")&&(PrtRowId="") "-1"
	s INPAYRowID="",Center=""
	i PrtRowId'=""  d
	.q:'$d(^DHCINDIV("0","DHCInvPrt",PrtRowId))
	.s INPAYRowID=$o(^DHCINDIV("0","DHCInvPrt",PrtRowId,INPAYRowID),-1)
	else  d
	.q:$d(^DHCINDIV("0","DHCPB",BillNo))=0 
	.s INPAYRowID=$o(^DHCINDIV("0","DHCPB",BillNo,INPAYRowID),-1) 
	q:INPAYRowID="" "0"
	s InsuDivideInfo=$g(^DHCINDIV(INPAYRowID))
	s INPAYFlag=$p(^DHCINDIV(INPAYRowID),"^",5)
	;q:INPAYFlag'="I" "-1"	//2020-07-17
	s adminfodr=$p(^DHCINDIV(INPAYRowID),"^",2)
	s InsuType=$p(^DHCINADM(adminfodr),"^",18)
	s grzfe0=$p(^DHCINDIV(INPAYRowID),"^",15)	//个人现金支付额
	s zhzfe0=$p(^DHCINDIV(INPAYRowID),"^",28)	//账户支付额
	s InsuPay1=$p(^DHCINDIV(INPAYRowID),"^",31) //基本统筹支付额
	s InsuPay9=$p(^DHCINDIV(INPAYRowID),"^",49)	//医院支付金额 20110405
	s jjzfe0=$p(^DHCINDIV(INPAYRowID),"^",19)	//基金支付额
    s InsuPay2=$p(^DHCINDIV(INPAYRowID),"^",32) //补助金额
    s InsuPay3=$p(^DHCINDIV(INPAYRowID),"^",33) //大额支付金额
    if $p($p(^DHCINDIV(INPAYRowID),"^",41),"$",2)["城乡"  do
    .s Center="城乡居民"
    if $p($p(^DHCINDIV(INPAYRowID),"^",41),"$",2)["职工"  do
    .s Center="职工医疗保险"
    if $p($p(^DHCINDIV(INPAYRowID),"^",41),"$",2)["离休"  do
    .s Center="离休人员"
     if $p($p(^DHCINDIV(INPAYRowID),"^",41),"$",2)["工伤"  do
    .s Center="工伤支付"
    ;b ;s Zstr06=xming0_$p($p(^DHCINDIV(INPAYRowID),"^",41),"$",2)    //险种代码
             //xming0_Center    //险种代码
    s xming0=""
    s Zstr06="",CenterDesc=xming0_Center
    i ($p($p(^DHCINDIV(INPAYRowID),"^",27),"$",2)["市")  d
    .s xming0=$p($p($p($G(^DHCINDIV(INPAYRowID)),"^",27),"$",2),"市",1)_"市"
    else  d
    .s xming0=$p($p(^DHCINDIV(INPAYRowID),"^",27),"$",2)
    
    s:xming0="宁夏回族自治区社会保险事业管理局" xming0="宁夏社会保险"
    s:xming0="中宁县社会保险事业管理局" xming0="中宁县"
    ;s:xming0="宁夏回族自治区社会保险事业管理局" xming0="宁夏社会保险"
    s:xming0="宁夏回族自治区医疗保障经办服务中心" xming0="宁夏社会保险"
    s:xming0="中宁县社会保险事业管理局" xming0="中宁县"
    s:xming0="同心县医疗保险服务中心" xming0="同心县"
    s Zstr06="",CenterDesc=xming0_Center
    ;if ($p($p(^DHCINDIV(INPAYRowID),"^",27),"$",2)="宁夏回族自治区社会保险事业管理局")& (Center="离休支付")  do
    ;.s Zstr06="宁夏回族自治区社会保险事业管理局(区离休)"
    ;b ;Zstr06
    ;s CenterDesc=Zstr06
    ;s rtn=Zstr06_"账户支付:"_zhzfe0_"^"_Zstr06_"个人现金支付额:"_grzfe0_"^"_Zstr06_"基本统筹:"_InsuPay1_"^"_Zstr06_"医院支付金额:"_InsuPay9_"^"_Zstr06_"基金总金额"_jjzfe0
    ;s rtn=rtn_"^"_Zstr06_"补助金额:"_InsuPay2_"^"_Zstr06_"大额支付金额:"_InsuPay3
    ;动态添加
    ;;;add 增加个人支付额支付方式
    s grzfe1=""
    if (+grzfe0'=0) && (PrtRowId'="") d
    .s grzfe1=..GetGrzfPayMode(PrtRowId)
    .;s grzfe0=grzfe1
    if (+grzfe0'=0)&(BillNo'="") d
    .s grzfe1=grzfe0
    s rtn=""
    ;b ;3434=
    s rtn=""
    s:+zhzfe0'=0 rtn=Zstr06_"账户支付:"_zhzfe0
    
    i (+grzfe0'=0)&(rtn="") d
    .s rtn=Zstr06_"个人现金支付:"_grzfe0
    else  if (+grzfe0'=0)  d
    .s rtn=rtn_"^"_Zstr06_"个人现金支付:"_grzfe0
    ;b ;;
    i (+jjzfe0'=0)&(rtn="") d
    .s rtn=Zstr06_"基本统筹:"_(jjzfe0-InsuPay2)
    else  if (+jjzfe0'=0)  d
    .s rtn=rtn_"^"_Zstr06_"基本统筹:"_(jjzfe0-InsuPay2)
    
    i (+InsuPay2'=0)&(rtn="") d
    .s rtn=Zstr06_"补助金额:"_InsuPay2
    else  if (+InsuPay2'=0)  d
    .s rtn=rtn_"^"_Zstr06_"补助金额:"_InsuPay2
    
    s rtn=CenterDesc_"^"_rtn
    
    q rtn
}

/// 通过发票表ID获取医保个人现金支付支付方式
/// Others: w ##class(web.DHCINSUPort).GetGrzfPayMode("240585")
ClassMethod GetGrzfPayMode(PrtRowId As %String) As %String
{
	s Rtn=""
	q:PrtRowId="" Rtn
	s IPMSub=""
	for  s IPMSub=$o(^DHCINVPRT(PrtRowId,"P",IPMSub)) q:IPMSub=""  d
	     .s IPMSubinfo=$g(^DHCINVPRT(PrtRowId,"P",IPMSub))
	     .q:$p(IPMSubinfo,"^",12)'="1"     ;过滤非自费支付
	     .s IPMPayModeDR=$p(IPMSubinfo,"^",1) ;支付方式
	     .s:IPMPayModeDR'="" IPMPayModeDR=$p($g(^CT("CTPM",IPMPayModeDR)),"^",2)
	     .s Amt=+$p(IPMSubinfo,"^",3)      ;支付方式金额
	     .q:+$p(IPMSubinfo,"^",3)=0        ;过滤金额为0的
	     .s Rtn=IPMPayModeDR_":"_Amt 
	q Rtn
}

/// 检查患者诊断是否符合单病种准入条件
/// 从住院病案首页上获取诊断手术信息，进行入组判断
/// w ##class(DHCMA.CPW.SDS.IO.ToDocService).CheckSD("142445591")
ClassMethod CheckSD(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Set $ZT="IOCheckSDErr"
	Quit:aEpisodeID="" return

	
	Set MRAdm=+$p($g(^PAADM(aEpisodeID)),"^",61)
	Quit:MRAdm="" return
	Set AdmType=$p($g(^PAADM(aEpisodeID)),"^",2)
	Quit:AdmType'="I" return
	
	Set LocationDR=$p($g(^PAADM(aEpisodeID)),"^",4)
	Quit:LocationDR="" return
	Set aLocID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(LocationDR)
	Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(aEpisodeID)
	//1 如果患者已入组,无论是否出组,返回空,不再检查是否入单
	Quit:$d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID)) return
	Set EntityID=""
	For {
		Set EntityID        = $o(^DHCMA.CPW.SD.QCEntityD(EntityID))
	 	Quit:EntityID=""
	 	Set objEntity        = ##class(DHCMA.CPW.SD.QCEntity).GetObjById(EntityID)
	 	Set IsActive         = objEntity.BTIsActive
	 	Set BTLocation		 = objEntity.BTLocation
	 	Set EntityDesc		 = objEntity.BTDesc
	 	//如果符合单病种，则退出判断
	 	Quit:return'=""
	 	Continue:IsActive'=1
	 	//按照关联科室过滤患者
	 	Continue:(BTLocation'="")&&($listfind(BTLocation,aLocID)=0)
	 	//遍历病种的配置项目
	 	Set RuleSubID="",flag=0
	 	For
	 	{	
	 		Set RuleSubID=$o(^DHCMA.CPW.SD.QCEntityMatchRuleI("IndexParref",EntityID,RuleSubID))
	 		Quit:RuleSubID=""
	 		Quit:flag=1
	 		Set RuleID = EntityID_"||"_RuleSubID
	 		Set ObjRule = ##class(DHCMA.CPW.SD.QCEntityMatchRule).GetObjById(RuleID)
	 		Set IsActive          	= ObjRule.IsActive
	 		Continue:IsActive'=1
	 		Set RuleType          	= ObjRule.RuleType
	 		Continue:RuleType'=1    //只判断准入条件
	 		Set RuleParam          	= ObjRule.RuleParam	
	 		Set RuleParam=$tr(RuleParam,"~","-")
			Set RuleParam=$tr(RuleParam,"、",",")
	 		For i=1:1:$l(RuleParam,",")
			{
				Set xDiagCode=$p(RuleParam,",",i)
				Set flag=..CheckICDArea(aICD10,xDiagCode)
				Quit:flag=1
			}
			Set:flag=1 return=return_"^"_EntityID_"-"_EntityDesc
			Quit:flag=1
			Set RuleKey = ObjRule.RuleKey	
			Set:RuleKey'="" RuleParam=RuleParam_","_RuleKey
			For i=1:1:$l(RuleParam,",")
			{
				Set xDiagDesc=$p(RuleParam,",",i)
				Continue:xDiagDesc=""
				Set flag=..CheckKeyArea(aICDDesc,xDiagDesc)
				quit:flag=1
			}
			Set:flag=1 return=return_"^"_EntityID_"-"_EntityDesc
	 	}
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
IOCheckSDErr
	Quit ""
}

/// w ##Class(DHCMA.CPW.SDS.IO.ToDocService).AnalyDHC("入院前8小时，患者被家属发现呼吸困难,伴出汗,在家吸痰无呛咳能力，呕吐3次，呕吐物为胃内容物，最后一次为喷射样，不伴双眼凝视、口角歪斜、抽搐、大小便失禁等，院外测得血压90+/70+mmhg，予以吸痰、吸氧等处理，病情无好转，为进一步诊治呼120，测得血压80/40mmhg，家属要求收入普通病房，普通病房值班医师评估病情后为进一步诊治以“肺部感染 呼吸衰竭”收入我科，自发病以来，未进食，解1次略呈黑色干大便，量约50g，小便使用尿管，量约50ml，近期体重下降，具体不详")
ClassMethod AnalyDHC(aInputStr As %String) As %String
{
	//HttpRequest调用
	Set httpRequest=##class(%Net.HttpRequest).%New()		
	Set httpRequest.Server = "49.235.17.9"
	Set httpRequest.Port   = "7723"
	Do httpRequest.InsertParam("data",aInputStr)
	Set sc=httpRequest.Post("/tag")
	If $system.Status.IsError(sc) {
		Do $system.OBJ.DisplayError(sc)
	}
	Set jsonStream=httpRequest.HttpResponse.Data
	
	//解析Json数据流
	Set jsonObject=##class(%DynamicObject).%FromJSON(jsonStream)
	Quit:'$IsObject(jsonObject) return
	Set tStructResult=..ChangeJsonObject(jsonObject)
	Set return=""
	For indJS=1:1:tStructResult.Count() {
		//关键词节点
		Set objResult=tStructResult.GetAt(indJS-1)
		Continue:'$IsObject(objResult)
		Set OneWord     = objResult.GetAt("name")       //关键词
		Set FormalWord	= objResult.GetAt("formal")		//归一词
		Set ResultType  = objResult.GetAt("type")       //结果类型
		Set Context     = objResult.GetAt("context")    //上下文
		Set Position    = objResult.GetAt("position")   //部位
		Set:Position'="" Position = Position.GetAt("name")
		Set Disease     = objResult.GetAt("disease")    //疾病
		Set:Disease'="" Disease = Disease.GetAt("name")
		Set Symptom     = objResult.GetAt("symptom")    //症状或体征
		Set:Symptom'="" Symptom = Symptom.GetAt("name")
		Continue:ResultType=""
		Set (IndNoStart,IndNoEnd)=""
		Set indxObj=objResult.GetAt("index")
		Set indxStr=""
		k xindxArr
		For xindx=1:1:indxObj.Count() {
			Set sindx=indxObj.GetAt(xindx).GetAt(1)
			Set eindx=indxObj.GetAt(xindx).GetAt(2)
			Set xindxArr(sindx)=sindx_"^"_eindx
		}
		Set xsindx=""
		For {
			Set xsindx=$o(xindxArr(xsindx))	
			Quit:xsindx=""
			Set indxStr=indxStr_$g(xindxArr(xsindx))_"^"
		}
		Set return=return_$c(1)_OneWord_$c(2)_ResultType_$c(2)_Context_$c(2)_Position_$c(2)_Disease_$c(2)_Symptom_$c(2)_indxStr_$c(2)_FormalWord
	}
	Set:return'="" return=$e(return,2,$l(return))	
	Quit return
	
GetJsonResultErr
	//w $ZError,!
	Quit return
}

/// Do ##class(DHCMA.CPW.SDS.IO.ToDocService).ChangeJsonObject()
ClassMethod ChangeJsonObject(jsonObject As %DynamicObject) As %ArrayOfDataTypes
{
	New (jsonObject)
	Set return=##Class(%ArrayOfDataTypes).%New()
	Quit:jsonObject="" return
	
	set iter=jsonObject.%GetIterator()
	While iter.%GetNext(.key,.value) {
		Set type=jsonObject.%GetTypeOf(key)
		If type="object" {
			Set obj=..ChangeJsonObject(value)
			Do return.SetAt(obj,key)
		} ElseIf type="array" {
			Set arr=..ChangeJsonArray(value)
			Do return.SetAt(arr,key)
		} Else {
			Do return.SetAt(value,key)
		}
	}
	Quit return
}

/// Do ##class(DHCMA.CPW.SDS.IO.ToDocService).ChangeJsonArray()
ClassMethod ChangeJsonArray(jsonArray As %DynamicArray) As %ArrayOfDataTypes
{
	New (jsonArray)
	Set return=##Class(%ArrayOfDataTypes).%New()
	Quit:jsonArray="" return
	
	For indCnt=0:1:(jsonArray.%Size()-1){
		Set type=jsonArray.%GetTypeOf(indCnt)
		Set value=jsonArray.%Get(indCnt)
		If type="object" {
			Set obj=..ChangeJsonObject(value)
			Set cnt=return.Count()
			Do return.SetAt(obj,cnt+1)
		} ElseIf type="array" {
			Set arr=..ChangeJsonArray(value)
			Set cnt=return.Count()
			Do return.SetAt(arr,cnt+1)
		} Else {
			Set cnt=return.Count()
			Do return.SetAt(value,cnt+1)
		}
	}
	Quit return
}

}
