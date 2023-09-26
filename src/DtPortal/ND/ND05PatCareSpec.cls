/// 类名: DtPortal.ND.ND05PatCareSpec
/// Creator： 程鹏
/// CreatDate： 2018-12-14
/// Description: 查询护理部护患比
Class DtPortal.ND.ND05PatCareSpec Extends %RegisteredObject
{

/// Creator： 程鹏
/// CreatDate： 2018-12-12
/// Description: 查询全院各病区昨天护患比
/// 增加入参 type all代表取全院的数据 allItem代表取全院和各个科室的数据 其他值取各个科室的数据 modify by 赵丽
/// Return： 
/// 服务编码：ND05.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND05PatCareSpec","ND050101","")
Query ND050101(type As %String) As DtPortal.Query(ROWSPEC = "wardLocID,WardDesc,bedratio,PatQty,DutyQty,SichQty,MaternityQty,OtherQty")
{
}

ClassMethod ND050101Execute(ByRef qHandle As %Binary, type As %String) As %Status
{

	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	set:type="allItem" ind=2      //当偷偷加入全院数据时，给全院预留第一条  update By chengpeng
	
	k ^||TMPPortalND050101	
	s date=+$h-1
	
	//取护理版本号,可在数据规则配置中配置  2 ext版护理版本  3 新版护理管理
	set NURMIS=##Class(DtPortal.Common.PublicService).getValueByCode("NURMIS")
	
	if NURMIS=2
	{
		set wardLocID=""
		for
		{
			set wardLocID= $O(^DHCMGNUR.MgNurArrangeJobI("AJWardDateIdx",wardLocID))
			quit:wardLocID=""
			//获取在岗,病假,产假,其他假人数
			set DutyQty=0,SichQty=0,MaternityQty=0,OtherQty=0
		
			set AJRowId="" 
			for
			{
				set AJRowId = $O(^DHCMGNUR.MgNurArrangeJobI("AJWardDateIdx",wardLocID," "_date,AJRowId))
				quit:AJRowId=""
				
				set AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
				continue:'$IsObject(AJObject)
				set AJTypes = AJObject.AJType
				d AJObject.%Close()
				set:AJTypes["Post" DutyQty=DutyQty+1		//在岗
				
				for i=1:1:$L(AJTypes,",")
				{
					set AJType = $P(AJTypes,",",i)
					continue:((AJType'="Holiday")&&(AJType'="Rest"))
					s AJCode = $P(AJObject.AJCodeDR,",",i)
					continue:AJCode=""
			
					set HolidayCodeObj=##class(DHCMGNUR.MgNurHolidayCode).%OpenId(AJCode)
					set HolidayDesc=HolidayCodeObj.HolidayDesc
					set:HolidayDesc="病假" SichQty=SichQty+1								//病假
					set:HolidayDesc="产假" MaternityQty=MaternityQty+1						//产假
					set:((HolidayDesc'="产假")&&(HolidayDesc'="病假")) OtherQty=OtherQty+1	//其他假期
				}
			} 
			 
			set wardLocID1=$tr(wardLocID," ","")
			set ^||TMPPortalND050101(wardLocID1,"DutyQty")=DutyQty
			set ^||TMPPortalND050101(wardLocID1,"SichQty")=SichQty
			set ^||TMPPortalND050101(wardLocID1,"MaternityQty")=MaternityQty
			set ^||TMPPortalND050101(wardLocID1,"OtherQty")=OtherQty
		}
	}else
	{
		set dateDesc=$zd(date,3)
		set wardID=0
		for
		{
			set wardID=$o(^PAWARD(wardID))
			quit:+wardID=0
			
			set wardLocID=$p(^PAWARD(wardID),"^",5)

			
			set DutyQty=0,SichQty=0,MaternityQty=0,OtherQty=0
			Set rset = ##class(%ResultSet).%New("web.NurMgOutInterface:FindWardDateArgList")
			Do rset.Execute(wardID,dateDesc)
			
			While (rset.Next()) {
				set Vacation=""
				set NurName=rset.Data("NurName")				//护士姓名
				set ArgPost=rset.Data("ArgPost")				//班次类型  多个班次用 "「"分割
				set ArgTime=rset.Data("ArgTime")				//班次时间段 多班次用  "「",一班次多时间段用","分割
				set IsNight=rset.Data("IsNight")				//是否夜班  多班次用  "「"
				set SichQtya=rset.Data("SickLeave")				//病假
				set MaternityQtya=rset.Data("MaternityLeave")	//产假
				set OtherQtya=rset.Data("OtherLeave")			//其他假期
				
			
				
				set:ArgPost'="" DutyQty=DutyQty+1
				set SichQty=SichQty+SichQtya
				set MaternityQty=MaternityQty+MaternityQtya
				set OtherQty=OtherQty+OtherQtya
			}
			
			set ^||TMPPortalND050101(wardLocID,"DutyQty")=DutyQty
			set ^||TMPPortalND050101(wardLocID,"SichQty")=SichQty
			set ^||TMPPortalND050101(wardLocID,"MaternityQty")=MaternityQty
			set ^||TMPPortalND050101(wardLocID,"OtherQty")=OtherQty
		}
		
	}
	
	set kpiRule="SK0122:WARD"
	set dateType=""
	set filterRule=""
	
	set startDateDay=$zd(+$h-1,3)
	set endDateDay=$zd(+$h-1,3)
	set mode="H"
	//期初取上个月最后一天
	set rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDateDay,endDateDay,dateType,kpiRule,filterRule,mode,"")
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s date=rs.Data("month")
		s wardId=rs.Data("dimIdCol1")
		continue:wardId=""
		continue:$g(^PAWARD(wardId))=""  //加过滤保护
		set wardLocID=$p(^PAWARD(wardId),"^",5)
		continue:wardLocID=""
		
		s num=$g(rs.Data("kpiValueCol1"))
		set ^||TMPPortalND050101(wardLocID,"Xyrs")=+$g(^||TMPPortalND050101(wardLocID,"Xyrs"))+num		
		
		
	}
	
	
	set DutyQtyAll=0, SichQtyAll=0,MaternityQtyAll=0,OtherQtyAll=0,PatQtyAll=0
	set wardLocID=0
	for
	{
		set wardLocID=$o(^||TMPPortalND050101(wardLocID))
		quit:wardLocID=""
		
		set DutyQty=+$g(^||TMPPortalND050101(wardLocID,"DutyQty"))					//在岗人数
		set SichQty=+$g(^||TMPPortalND050101(wardLocID,"SichQty"))					//病假人数
		set MaternityQty=+$g(^||TMPPortalND050101(wardLocID,"MaternityQty"))			//产假人数
		set OtherQty=+$g(^||TMPPortalND050101(wardLocID,"OtherQty"))					//其他人数
		set Xyrs=+$g(^||TMPPortalND050101(wardLocID,"Xyrs"))							//昨日0点现有人数
		continue:Xyrs=0
		set admNum=+$g(^||TMPPortalND050101(wardLocID,"admNum"))						//昨日入院人数
		
		set PatQty=Xyrs+admNum													//昨日病人数
		set bedratio="1:0",tmpbedratio=0
		set:((PatQty'=0)&&(DutyQty'=0)) tmpbedratio=$fn((PatQty/DutyQty),"",2)
		set:tmpbedratio bedratio=1_":"_tmpbedratio								//护患比
		
		set WardDesc=$p(^CTLOC(wardLocID),"^",2)
    	set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
    	set DutyQtyAll=DutyQtyAll+DutyQty
    	set SichQtyAll=SichQtyAll+SichQty
    	set MaternityQtyAll=MaternityQtyAll+MaternityQty
    	set OtherQtyAll=OtherQtyAll+OtherQty
    	set PatQtyAll=PatQtyAll+PatQty
		if (type'="all"){
			
			if ($p(DutyQty,".")=""){
				s DutyQty=0_DutyQty	
			}
			if ($p(SichQty,".")=""){
				s SichQty=0_SichQty	
			}
			if ($p(MaternityQty,".")=""){
				s MaternityQty=0_MaternityQty	
			}
			
			if ($p(OtherQty,".")=""){
				s OtherQty=0_OtherQty	
			}
			
		    set Data=$lb(wardLocID,WardDesc,bedratio,PatQty,DutyQty,SichQty,MaternityQty,OtherQty)
 			set ^||CacheTemp(repid,ind)=Data	
 			set ind=ind+1
		}
		
	}
	if (type="all")||(type="allItem"){
		set bedratio="1:0",tmpbedratio=0
		set:((PatQtyAll'=0)&&(DutyQtyAll'=0)) tmpbedratio=$fn((PatQtyAll/DutyQtyAll),"",2)
		set:tmpbedratio bedratio=1_":"_tmpbedratio	
		if ($p(DutyQtyAll,".")=""){
			s DutyQtyAll=0_DutyQtyAll	
		}
		if ($p(SichQtyAll,".")=""){
			s SichQtyAll=0_SichQtyAll	
		}
		if ($p(MaternityQtyAll,".")=""){
			s MaternityQtyAll=0_MaternityQtyAll	
		}
		
		if ($p(OtherQtyAll,".")=""){
			s OtherQtyAll=0_OtherQtyAll	
		}
		set Data=$lb("all","全院",bedratio,PatQtyAll,DutyQtyAll,SichQtyAll,MaternityQtyAll,OtherQtyAll)
 		set ^||CacheTemp(repid,1)=Data	
 		 
	}
	k ^||TMPPortalND050101
	
	
  	q $$$OK
}

}
