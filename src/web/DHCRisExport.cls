Import SQLUser

Class web.DHCRisExport Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 查询HIS系统中检查自动预约数据明细
/// w ##class(web.DHCRisExport).export()
ClassMethod export() As %String
{
	s file="d:\\ris\\export.txt"
  	k pData
  	k PLIST 
 
 	o file:"WNS"
  	u file
  	s titel1="检查项目"_"^"_"检查项目code"_"^"_"预约方式"_"^"_"是否空腹"_"^"_"检查时间"_"^"_"服务组"_"^"_"检查子类"_"^"_"部位"_"^"_"申请单树"
  	w !,titel1
    
  
   s itmMastRowid=""
   for
   {
	   s itmMastRowid=$o(^DHCAPPTRA(0,"Arc",itmMastRowid))
	   q:(itmMastRowid="")
	   s itmMastName=$p(^ARCIM($p(itmMastRowid,"||",1),$p(itmMastRowid,"||",2),1),"^",2 )
	   s itmMastCode=$p(^ARCIM($p(itmMastRowid,"||",1),$p(itmMastRowid,"||",2),1),"^",1 )
	   
	   s (servcieGroupDr,servcieGroupDescList,bookType,isEmpty,examTime)=""
	   s servcieGroupDr=$p(^ARCIM($p(itmMastRowid,"||",1),$p(itmMastRowid,"||",2),1),"^",7 )
	   if ( servcieGroupDr'="")
	   {
		   s servcieGroupDesc=$p(^RBC("SG",servcieGroupDr),"^",2)
		   s servcieGroupDescList=servcieGroupDesc
	   }
	   
	   s itemProBookProRowid=$o(^DHCRBCItemBookProperTypei(itmMastRowid,0))
	   if (itemProBookProRowid'="")
	   {
		   s bookTypeDr=$p(^DHCRBCItemBookProperty(itemProBookProRowid),"^",2)
		   if (bookTypeDr'="")
		   {
		   		s bookType=$p(^DHCRBCAppointMethod(bookTypeDr),"^",2)
		   }
		   s isEmpty=$p(^DHCRBCItemBookProperty(itemProBookProRowid),"^",4)
		   s examTime=$p(^DHCRBCItemBookProperty(itemProBookProRowid),"^",9)
		   s childSub=""
		   for 
		   {
			   s childSub=$o(^DHCRBCItemBookPropertySG("ServiceGroup",itemProBookProRowid,childSub))
			   q:(childSub="")
			   s servcieGroupDr=$p(^DHCRBCItemBookPropertySG("ServiceGroup",itemProBookProRowid,childSub),"^",4)
			   if ( servcieGroupDr'="")
			   {
				   s servcieGroupDesc=$p(^RBC("SG",servcieGroupDr),"^",2)
			   } 
			   if (servcieGroupDescList'="")
			   {
				   s servcieGroupDescList=servcieGroupDescList_","_servcieGroupDesc
			   }
			   else
			   {
				   s servcieGroupDescList=servcieGroupDesc
			   }
		   }
		   
	   }
	   s itmCatRowid=$p(^ARCIM($p(itmMastRowid,"||",1),$p(itmMastRowid,"||",2),1),"^",10 )
	   s itmCatDesc=$p(^ARC("IC",itmCatRowid),"^",2)
	   //w !,itmMastName_"^"_itmMastCode_"^"_itmCatDesc
	   s appTreeAddRowid=0
	   for
	   {
		   s appTreeAddRowid=$o(^DHCAPPTRA(0,"Arc",itmMastRowid,appTreeAddRowid))
		   q:(appTreeAddRowid="")
		   s appTreeAddCode=$p(^DHCAPPTRA(appTreeAddRowid),"^",1)
		   s appTreeAddDesc=$p(^DHCAPPTRA(appTreeAddRowid),"^",2)
		   
		   s lastLevel=$p(^DHCAPPTRA(appTreeAddRowid),"^",4)
		   s treeList=appTreeAddDesc
		   while(lastLevel'=0)
		   {
			   s appTreeAddDesc=$p(^DHCAPPTRA(lastLevel),"^",2)
			   s treeList=appTreeAddDesc_","_treeList
			   s lastLevel=$p(^DHCAPPTRA(lastLevel),"^",4)
			   
		   }
		   s bodyPart=""
		   s hasBody="N"
		   s appTreeChildSub=0
		   for
		   {
				s appTreeChildSub=$o(^DHCAPPTRA(0,"Arc",itmMastRowid,appTreeAddRowid,appTreeChildSub))
				q:(appTreeChildSub="")
				s bodyPartRowid=+$p(^DHCAPPTRA(appTreeAddRowid,"I",appTreeChildSub),"^",1)
				if ( (bodyPartRowid="") || (bodyPartRowid=0) || (bodyPartRowid=$c(0) ))
				{
					continue
				}
				s bodyPartDesc=$p(^DHCAPPART(bodyPartRowid),"^",2)
				s hasBody="Y"
				//itmMastRowid
				s (bookTypeDr,bookType,isEmpty,examTime,SerDesc,SerID)=""
				s bookparamRowid=$o(^User.DHCRBCBookParamI("IndexItemBody",itmMastRowid,bodyPartRowid,0))
				if (bookparamRowid'="")
				{
					s bookTypeDr=$lg(^User.DHCRBCBookParamD(bookparamRowid),5)
					if (bookTypeDr'="")
					{
						s bookType=$p(^DHCRBCAppointMethod(bookTypeDr),"^",2)
					}
					s isEmpty=$lg(^User.DHCRBCBookParamD(bookparamRowid),6)
					s examTime=$lg(^User.DHCRBCBookParamD(bookparamRowid),7)
					s child=""
					for 
					{
						s child=$o(^User.DHCRBCBookParamD(bookparamRowid,"BPChild",child))
						q:(child="")
						s SerGroupDR=$lg($g(^User.DHCRBCBookParamD(bookparamRowid,"BPChild",child)),2)
						i SerGroupDR'=""  s SerGroup=$p($g(^RBC("SG",SerGroupDR)),"^",2)
						i SerID="" s SerID=SerGroupDR
						e  s SerID=SerID_","_SerGroupDR
						i SerDesc="" s SerDesc=SerGroup
						e  s SerDesc=SerDesc_","_SerGroup
					}

				}
				w !,itmMastName_"^"_itmMastCode_"^"_bookType_"^"_isEmpty_"^"_examTime_"^"_SerDesc_"^"_itmCatDesc_"^"_bodyPartDesc_"^"_treeList_"^"_bodyPartRowid_"^"_appTreeAddRowid_"^"_appTreeChildSub
			   
		   }
		   if ( hasBody="N")
		   {
		  		w !,itmMastName_"^"_itmMastCode_"^"_bookType_"^"_isEmpty_"^"_examTime_"^"_servcieGroupDescList_"^"_itmCatDesc_"^"_bodyPart_"^"_treeList
		   }
	   }
	   
	   
	   
   }
   
  c file
    Q "0"
}

//科室ID^设备名称^星期(直接输入数字)^服务组^开始时间^结束时间^最大预约数^自动预约数^截止缴费时间^科室描述^设备Id

/// w ##class(web.DHCRisExport).exportResourcePlan()
ClassMethod exportResourcePlan() As %String
{
	s file="d:\\ris\\exportResPlan.txt"
  	k pData
  	k PLIST 
 
 	o file:"WNS"
  	u file
  	;s titel1="科室ID"_"^"_"设备名称"_"^"_"星期(直接输入数字)"_"^"_"服务组"_"^"_"开始时间"_"^"_"结束时间"_"^"_"最大预约数"_"^"_"自动预约数"_"^"_"截止缴费时间"
  	s title="科室ID^设备名称^星期(直接输入数字)^服务组^开始时间^结束时间^最大预约数^自动预约数^截止缴费时间^科室描述^设备Id"
  	w !,title

	s locId=""
	for
	{
		s locId=$o(^DHCRBCResPlani("LocSTime",locId))
		q:(locId="")
		s locDesc=$p(^CTLOC(locId),"^",2)
		s resourceId=""
		for
		{
			s resourceId=$o(^DHCRBCResPlani("LocSTime",locId,resourceId))
			q:(resourceId="")
			s (ResourceDesc,EqId)=""
			i resourceId'="" d
       		.s EqId=$p($g(^RB("RES",resourceId)),"^",3)
       		.i EqId'="" d
       		..s ResourceDesc=$p(^RBC("EQ",EqId),"^",2) 
       		..s ResourceCode=$p(^RBC("EQ",EqId),"^",1)
			s week=""
			for 
			{
				s week=$o(^DHCRBCResPlani("LocSTime",locId,resourceId,week))
				q:(week="")
				s stTime=""
				for
				{
					s stTime=$o(^DHCRBCResPlani("LocSTime",locId,resourceId,week,stTime))
					q:(stTime="")
					s resplanId=""
					for
					{
						s resplanId=$o(^DHCRBCResPlani("LocSTime",locId,resourceId,week,stTime,resplanId))
						q:(resplanId="")
						s serviceGroupId=$p(^DHCRBCResourcePlan(resplanId),"^",3)
						s ServiceGroupDesc=$p(^RBC("SG",serviceGroupId),"^",2)
						s startTime=$p(^DHCRBCResourcePlan(resplanId),"^",5)
						i (startTime'="") s startTime=$zt(startTime)
						s endTime=$p(^DHCRBCResourcePlan(resplanId),"^",6)
						i (endTime'="") s endTime=$zt(endTime)
						s maxNum=$p(^DHCRBCResourcePlan(resplanId),"^",8)
						s autoNum=$p(^DHCRBCResourcePlan(resplanId),"^",9)
						s chargeTime=$p(^DHCRBCResourcePlan(resplanId),"^",10)
						i (chargeTime'="") s chargeTime=$zt(chargeTime)
						s notAvaile=$p(^DHCRBCResourcePlan(resplanId),"^",15)
						//"科室ID^设备名称^星期(直接输入数字)^服务组^开始时间^结束时间^最大预约数^自动预约数^截止缴费时间^科室描述^设备Id"
						w !,locId_"^"_ResourceDesc_"^"_week_"^"_ServiceGroupDesc_"^"_startTime_"^"_endTime_"^"_maxNum_"^"_autoNum_"^"_chargeTime_"^"_locDesc_"^"_resourceId
					}
				}
			}
			
		}
	}
	c file
    Q "0"
}

/// w ##class(web.DHCRisExport).clearDate()
ClassMethod clearDate() As %String
{
	//登记信息
	&sql(delete from dhcrb_reginfo_bodyparts)
	&sql(delete from dhcrb_reginfo)
	//预约信息
	&sql(delete from DHCRBC_SchduleDetailBody)
	&sql(delete from dhcrbc_resschduledetail)
	&sql(delete from DHCRBC_BookInfoExternal)
	//预约资源计划
	&sql(delete from DHCRBC_ResSchdule)
	//报告信息
	&sql(delete from DHCRB_Report)
	&sql(delete from DHCRB_Report_Files)
	&sql(delete from DHCRB_StudyDesc)
	&sql(delete from DHCRB_StudyImages)
	//诊间表
	&sql(delete from DHCRBC_Room)
	&sql(delete from DHCRBC_Room_Equipment)
	//预约参数表
	&sql(delete from DHCRBC_ItemBookProperty)
	&sql(delete from DHCRBC_ItemBookProperty_ServiceG)
	&sql(delete from dhcrbc_bookparam)
	&sql(delete from dhcrbc_bookparamsg)
	
	q ""
}

/// w ##class(web.DHCRisExport).clearDate()
/// 日/月/年
/// w ##class(web.DHCRisExport).createResSchedule("","08/09/2016","30/09/2016")
ClassMethod createResSchedule(locIdList As %String, startDate As %String, endDate As %String) As %String
{
	//s locCTList="390^391^392^393^396^400^544"
	//s locMRList="388^389"
	//s locPFList="394"
	if (locIdList="")
	{
		s locIdList="390^391^392^393^396^400^544^388^389^394"
	}
	q:((startDate="")||(endDate="")) ret
	s infoRet=""
	for iii=1:1:$l(locIdList,"^")
	{
		s locId=$p(locIdList,"^",iii)
		if (locId'="")
		{
			s resourceList=##class(web.DHCRisCommFunction).GetResIdByLocRowid(locId)
			if (resourceList'="")
			{
				s param=locId_"^"_resourceList_"^"_startDate_"^"_endDate
				s ret=##class(web.DHCRisResourceApptSchudle).CreateResApptSchulde(param)
				s infoRet=infoRet_"**"_ret
			}
			
		}
	}
	q infoRet
}

}
