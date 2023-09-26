Class web.DHCPE.TransResultDetail Extends %RegisteredObject
{

/// Creator：      xy
/// CreatDate：    20230111
/// Description:   查询回传结果详细信息
/// Return:        体检回传结果方法^接口返回信息^是否存在结果
/// dubug:  w ##class(web.DHCPE.TransResultDetail).GetTransResultInfo()
ClassMethod GetTransResultInfo(OEORDID As %String = "", LocID As %String = "", UserID As %String = "")
{
	s ret="",falg=""
	s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",LocID)) 
	s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))
	s RisStation="^"_RisStation_"^"
	//回传方式
	s TransResultFlag=##class(web.DHCPE.HISUICommon).GetSettingByLoc(LocID,"TransResult")
	s LabNo=$p($G(^OEORD(+OEORDID,"I",$p(OEORDID,"||",2),3)),"^",20)
	i LabNo'=""{
		i (LisNewVersion'="Y"){
			s ret="##class(web.DHCPE.TransResult).TransALabItem("_""""","_UserID_","_OEORDID_")"
			
		    s flag=##class(web.DHCPE.TransResult).TransALabItem("",UserID,OEORDID)
				i flag'="Over"{
					s ret=ret_"^"_flag
				}
		}elseif(LisNewVersion="Y"){
			i (TransResultFlag="PT"){			
				s ret="##class(web.DHCPE.TransResult).TransALabItemNewByPT("_""""","_UserID_","_OEORDID_")"
				s flag=##class(web.DHCPE.TransResult).TransALabItemNewByPT("",UserID,OEORDID)
				i flag'=""{
					s ret=ret_"^"_flag
				}		
			}elseif (TransResultFlag="PG"){
				s ret="##class(web.DHCPE.TransResult).TransALabItemNew("_""""","_UserID_","_OEORDID_")"
					
				s flag=##class(web.DHCPE.TransResult).TransALabItemNew("",UserID,OEORDID)
				i flag'=""{
					s ret=ret_"^"_flag
				}		
			}
		}
	}else{
		i (TransResultFlag="PT"){
			s ret="##class(web.DHCPE.TransResult).TransARisItemByPT("_""""","_OEORDID_","_UserID_")"	
			s flag=##class(web.DHCPE.TransResult).TransARisItemByPT("",OEORDID,UserID)
			i flag'=""{
					s ret=ret_"^"_flag
				}		
		}elseif(TransResultFlag="PG"){
			s ret="##class(web.DHCPE.TransResult).TransARisItem("_""""","_OEORDID_","_UserID_")"
			s flag=##class(web.DHCPE.TransResult).TransARisItem("",OEORDID,UserID)
			i flag'=""{
					s ret=ret_"^"_flag
				}		
						
		}
		
	}
	
	i '$D(^DHCPERLT(0,"OEORI",OEORDID)) s ret=ret_"^不存在结果"
	i $D(^DHCPERLT(0,"OEORI",OEORDID))  s ret=ret_"^已存在结果"
	
	q ret
}

/// Creator：      xy
/// CreatDate：    20230111
/// Description:   查询回传结果详细信息
/// dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.TransResultDetail","FindResultDetail","")
Query FindResultDetail(OEORDID As %String = "") As websys.Query(ROWSPEC = "RLTID,ODDesc,Result,ODUnit,Standard,UserName,ReportDoc,AuditDoc,TSInfo")
{
}

ClassMethod FindResultDetailExecute(ByRef qHandle As %Binary, OEORDID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    if (OEORDID=""){
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s RLT=0
	f  s RLT=$O(^DHCPERLT(0,"OEORI",OEORDID,RLT)) q:RLT=""  d
	.s ItemID=$P($g(^DHCPERLT(RLT)),"^",3)
	.s ODDesc=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",1)
	.s Result=$P($g(^DHCPERLT(RLT)),"^",4)
	.s UserName="",ReportDoc="",AuditDoc="",UserID=""
	.s User=$P($g(^DHCPERLT(RLT)),"^",16)
	.s:(User'="") UserName=$LG(^CF.PE.SSUserD(User),3)
	.s:(User="") UserID=$P($g(^DHCPERLT(RLT)),"^",5)
	.s:UserID'="" UserName=$P($G(^SSU("SSUSR",UserID)),"^",2)
	.// 报告医生
	.s RUser=$P($g(^DHCPERLT(RLT)),"^",17)
	.s:RUser'="" ReportDoc=$LG(^CF.PE.SSUserD(RUser),3)
	.// 审核医生
	.s AUser=$P($g(^DHCPERLT(RLT)),"^",18)
	.s:AUser'="" AuditDoc=$LG(^CF.PE.SSUserD(AUser),3)
	.s ODUnit=$G(^DHCPEDataEx("DHCPEResult",RLT,"Unit"))
	.s Standard=$G(^DHCPEDataEx("DHCPEResult",RLT,"Ranges"))
	.s ODID=$P($g(^DHCPERLT(RLT)),"^",3)
	.s ODData=$g(^DHCPEST(+ODID,"OD",$P(ODID,"||",2)))
	.s TSInfo=""
 	.s Type=$p(ODData,"^",2)  // 项目类型  T说明型，N数值型，C计算型，S选择型，A多行文本	
	.s:((Type="N")||(Type="C")) TSInfo=##class(web.DHCPE.TransResult).GetLabResultArrowNew(RLT)
    .s:TSInfo="1" TSInfo=""
    .s:TSInfo="2" TSInfo="↑"
   	.s:TSInfo="0" TSInfo="↓"
   	.s TSInfo="<font color=red>"_TSInfo_"</font>"
    .s ^CacheTemp(repid,ind)=$lb(RLT,ODDesc,Result,ODUnit,Standard,UserName,ReportDoc,AuditDoc,TSInfo)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator：      xy
/// CreatDate：    20230111
/// Description:   查询回传结果详细信息
/// debug：d ##class(web.DHCPE.TransResultDetail).GetInfoByOEORDID("6561||4")
ClassMethod GetInfoByOEORDID(OEORDID As %String = "")
{
	
	//医嘱名称
	s arcItemId=$p($g(^OEORD($p(OEORDID,"||",1),"I",$p(OEORDID,"||",2),1)),"^",2)
	s ArcDesc=$p(^ARCIM($p(arcItemId,"||",1),1,1),"^",2)
	
	//医嘱状态
	s ItemStatusDesc="核实"
	s ItemStatusDr=$p($g(^OEORD($p(OEORDID,"||",1),"I",$p(OEORDID,"||",2),1)),"^",13)
	i ItemStatusDr="6" s ItemStatusDesc="执行"
	i ItemStatusDr="4" s ItemStatusDesc="停止"
	i $d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORDID))   s ItemStatusDesc="谢绝检查"
	
	s RLTID=$O(^DHCPERLT(0,"OEORI",OEORDID,0))
	s UserName="",AuditDate=""
	
	i (RLTID'=""){
		// 医生名字
		s User=$P($g(^DHCPERLT(RLTID)),"^",16)
		s:(User'="") UserName=$LG(^CF.PE.SSUserD(User),3)
		s:(User="") UserID=$P($g(^DHCPERLT(RLTID)),"^",5)
		s:UserID'="" UserName=$P($G(^SSU("SSUSR",UserID)),"^",2)
		//医生时间
		
		s AuditDate=$P($g(^DHCPERLT(RLTID)),"^",6)
		s:AuditDate'="" AuditDate=$zd(AuditDate,3)
	}
	
	q ArcDesc_"^"_ItemStatusDesc_"^"_UserName_"^"_AuditDate_"^"_arcItemId
}

}
