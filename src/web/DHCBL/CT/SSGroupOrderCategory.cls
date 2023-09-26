Import SQLUser

/// 名称:系统管理-安全组 子表，医嘱授权
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 -陈莹
/// 编写日期:2013-5-4
Class web.DHCBL.CT.SSGroupOrderCategory Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-05-06
/// Description:查询 可开放医嘱
/// Table:User.web.DHCBL.CT.SSGroupOrderCategory
/// Input:ssgrprowid,rowid(至少有一个不为空)
/// Output:SSORDParRef,SSORDRowId,SSORDOrdCatDR,OrdCatDR,SSORDOrdSubCategory,OrdSubCategory,SSORDOrderOnDischarge,SSORDOrderInvisbleItem,SSORDOrderSets,SSORDRequireAuthorisation,SSORDOrderOnFinanceDisch,SSORDBookingOnly
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSGroupOrderCategory","GetList","1","","","")
Query GetList(ssgrprowid As %String, rowid As %String, ordcat As %String, hospid As %String) As %Query(ROWSPEC = "SSORDParRef:%String,SSORDRowId:%String,SSORDOrdCatDR:%String,OrdCatDR:%String,SSORDOrdSubCategory:%String,OrdSubCategory:%String,SSORDOrderOnDischarge:%String,SSORDOrderInvisbleItem:%String,SSORDOrderSets:%String,SSORDRequireAuthorisation:%String,SSORDOrderOnFinanceDisch:%String,SSORDBookingOnly:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ssgrprowid As %String, rowid As %String, ordcat As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s SSGRPRowId=$p(rowid,"||",1)
		s SSORDChildsub=$p(rowid,"||",2)
		s SSORDRowId=rowid
		s SSORDParRef=SSGRPRowId
		s OrdCatDR=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",1)
		i OrdCatDR'="" {
			s SSORDOrdCatDR=$p($g(^OEC("ORCAT",OrdCatDR)),"^",2)
		}
		else {
			s SSORDOrdCatDR=""
		}
		
		s OrdSubCategory=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",5)
		i OrdSubCategory'="" {
			s SSORDOrdSubCategory=$p($g(^ARC("IC",OrdSubCategory)),"^",2)
		}
		else {
			s SSORDOrdSubCategory=""
		}
		s SSORDOrderOnDischarge=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",2)
		s SSORDOrderInvisbleItem=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",3)
		s SSORDOrderSets=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",4)
		s SSORDRequireAuthorisation=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",7)
		s SSORDOrderOnFinanceDisch=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",8)
		s SSORDBookingOnly=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",9)
		
		d OutputRow
	}
	else
	{
		if (ssgrprowid)
		{
			s:ordcat'="" ordcat=$ZCONVERT(ordcat,"U")
			s SSGRPRowId=ssgrprowid,SSORDChildsub=0
			for
			{
				s SSORDChildsub=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)) q:SSORDChildsub=""
				s SSORDRowId=SSGRPRowId_"||"_SSORDChildsub
				s SSORDParRef=ssgrprowid
				s OrdCatDR=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",1)
				i OrdCatDR'=""
				{
					s SSORDOrdCatDR=$p($g(^OEC("ORCAT",OrdCatDR)),"^",2)
					if hospid'=""
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("OEC_OrderCategory",OrdCatDR,hospid)
						continue:showflag="N"
					}
					
				}
				else
				{
					s SSORDOrdCatDR=""	
				}
				s OrdSubCategory=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",5) //输出此项是为了明细里取子类id
				i OrdSubCategory'=""
				{
					s SSORDOrdSubCategory=$p($g(^ARC("IC",OrdSubCategory)),"^",2)
					if hospid'=""
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat",OrdSubCategory,hospid)
						continue:showflag="N"
					}
				}
				else
				{
					s SSORDOrdSubCategory=""
				}
				
				s SSORDOrderOnDischarge=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",2)
				s SSORDOrderInvisbleItem=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",3)
				s SSORDOrderSets=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",4)
				s SSORDRequireAuthorisation=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",7)
				s SSORDOrderOnFinanceDisch=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",8)
				s SSORDBookingOnly=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",9)
				i ((OrdCatDR=ordcat)||(ordcat=""))&(SSORDChildsub>0)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(SSORDParRef,SSORDRowId,SSORDOrdCatDR,OrdCatDR,SSORDOrdSubCategory,OrdSubCategory,SSORDOrderOnDischarge,SSORDOrderInvisbleItem,SSORDOrderSets,SSORDRequireAuthorisation,SSORDOrderOnFinanceDisch,SSORDBookingOnly)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2012-9-10
/// Description:双击修改时,从后台取数据
/// Table:User.SSGroupOrderCategory
/// Input:id
/// Return:Json格式的字符串str={list:[SSORDParRef,SSORDRowId,SSORDOrdCatDR,SSORDOrderOnDischarge,SSORDOrderInvisbleItem,SSORDOrderSets,SSORDOrdSubCategory,SSORDRequireAuthorisation,SSORDOrderOnFinanceDisch,SSORDBookingOnly]}
/// Other:w ##class(web.DHCBL.CT.SSGroupOrderCategory).OpenData("1||7")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.SSGroupOrderCategory).%OpenId(id)
	s eobj = ##class(web.Entity.CT.SSGroupOrderCategory).%New()
	s eobj.SSORDRowId = id
	s eobj.SSORDParRef = $p(id,"||",1)
	if $IsObject(pobj.SSORDOrdCatDR){
		s eobj.SSORDOrdCatDR = pobj.SSORDOrdCatDR.%Id() 
		}
	if $IsObject(pobj.SSORDOrdSubCategory){
		s eobj.SSORDOrdSubCategory = pobj.SSORDOrdSubCategory.%Id() 
		}
	//s eobj.SSORDOrderOnDischarge = pobj.SSORDOrderOnDischarge  //radio
	s:pobj.SSORDOrderOnDischarge="Y" eobj.SSORDOrderOnDischarge="true" // checkox
	s:pobj.SSORDOrderInvisbleItem="Y" eobj.SSORDOrderInvisbleItem="true"
	s:pobj.SSORDOrderSets="Y" eobj.SSORDOrderSets="true"
	s:pobj.SSORDRequireAuthorisation="Y" eobj.SSORDRequireAuthorisation="true"
	s:pobj.SSORDOrderOnFinanceDisch="Y" eobj.SSORDOrderOnFinanceDisch="true"
	s:pobj.SSORDBookingOnly="Y" eobj.SSORDBookingOnly="true"
	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2014-3-12
/// Description:保存新增树节点
/// Table:User.SSGroupOrderCategory
/// Input:SSGRPRowId,ORCATRowId,ARCICRowId
/// Return:成功返回success:'true'和id;失败返回success:'false'和errorinfo
ClassMethod SaveTreePanel(SSGRPRowId As %String, ORCATRowId As %String, ARCICRowId As %String) As %String
{
	s sobj = ##class(web.Entity.CT.SSGroupOrderCategory).%New()
	s sobj.SSORDRowId=""
	s sobj.SSORDParRef=SSGRPRowId
	s sobj.SSORDOrdCatDR=ORCATRowId
	s sobj.SSORDOrdSubCategory=ARCICRowId
	s sobj.SSORDOrderSets="Y"
	s result= ##class(web.DHCBL.CT.SSGroupOrderCategory).SaveEntity(sobj)
	q result
}

/// Creator:陈莹
/// CreatDate:2012-9-20
/// Description:增加/修改 医嘱授权
/// Table:User.SSGroupOrderCategory
/// Input:web.Entity.CT.SSGroupOrderCategory
/// Return:成功返回success:'true'和id;失败返回success:'false'和errorinfo
ClassMethod SaveEntity(eobj As web.Entity.CT.SSGroupOrderCategory) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.SSORDOrderOnDischarge="" eobj.SSORDOrderOnDischarge="N"  //checkbox  radio没有
		s:eobj.SSORDOrderInvisbleItem="" eobj.SSORDOrderInvisbleItem="N"
		s:eobj.SSORDOrderSets="" eobj.SSORDOrderSets="N"
		s:eobj.SSORDRequireAuthorisation="" eobj.SSORDRequireAuthorisation="N"
		s:eobj.SSORDOrderOnFinanceDisch="" eobj.SSORDOrderOnFinanceDisch="N"
		s:eobj.SSORDBookingOnly="" eobj.SSORDBookingOnly="N"
		//如果RowId未赋值则增加
		if (eobj.SSORDRowId="")
		{
			s SSGRPRowId=0,flag=0
			for
			{
				s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
				s SSORDChildsub=0
				for
				{
					s SSORDChildsub=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)) q:SSORDChildsub=""
					s SSORDRowId=SSGRPRowId_"||"_SSORDChildsub
					s SSORDParRef=SSGRPRowId
					s SSORDOrdCatDR=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",1)
					s SSORDOrdSubCategory=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",5)
					i ((eobj.SSORDParRef=SSORDParRef)&(eobj.SSORDOrdCatDR=SSORDOrdCatDR)&(eobj.SSORDOrdSubCategory=SSORDOrdSubCategory)&(SSORDChildsub>0))
					{
						s flag=1 //flag=1 有重复
					}
				}
			}
			if (flag'=1) {
				s obj = ##class(User.SSGroupOrderCategory).%New(eobj.SSORDParRef)
			
	 			d obj.SSORDParRefSetObjectId(eobj.SSORDParRef)
				d obj.SSORDOrdCatDRSetObjectId(eobj.SSORDOrdCatDR)
				
				d obj.SSORDOrdSubCategorySetObjectId(eobj.SSORDOrdSubCategory)
				s obj.SSORDOrderOnDischarge=eobj.SSORDOrderOnDischarge
				s obj.SSORDOrderInvisbleItem=eobj.SSORDOrderInvisbleItem
				s obj.SSORDOrderSets=eobj.SSORDOrderSets
				s obj.SSORDRequireAuthorisation=eobj.SSORDRequireAuthorisation
				s obj.SSORDOrderOnFinanceDisch=eobj.SSORDOrderOnFinanceDisch
				s obj.SSORDBookingOnly=eobj.SSORDBookingOnly
				s SSGRPDesc=$p($g(^SSU("SSGRP",eobj.SSORDParRef)),"^",1)
				s ORCATDesc=$p($g(^OEC("ORCAT",eobj.SSORDOrdCatDR)),"^",2)
				
				Tstart
				s sc=obj.%Save()
				do obj.%Close()
				if $$$ISOK(sc){
					Tcommit
					s id = obj.%Id()
					s result = "{success:'true',id:'"_id_"'}"
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupOrderCategory","User.SSGroupOrderCategory","安全组-医嘱授权",id,SSGRPDesc_"->"_ORCATDesc,"A",eobj)
				}else{
					Trollback
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组-医嘱授权","web.DHCBL.CT.SSGroupOrderCategory","SaveEntity",eobj)
	   				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				}
			}
			else{
				s result = "{success:'false',errorinfo:'该记录已经存在！'}"
			}
		}
		//如果RowId已赋值则修改
		else           
		{
			s SSGRPRowId=0,flag=0
			for
			{
				s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
				s SSORDChildsub=0
				f
				{
					s SSORDChildsub=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)) q:SSORDChildsub=""
					s SSORDRowId=SSGRPRowId_"||"_SSORDChildsub
					s SSORDParRef=SSGRPRowId
					s SSORDOrdCatDR=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",1)
					s SSORDOrdSubCategory=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",5)
					;指向同一个安全组的'医嘱大类'和'医嘱子类'不能同时重复
					i ((eobj.SSORDParRef=SSORDParRef)&(eobj.SSORDOrdCatDR=SSORDOrdCatDR)&(eobj.SSORDOrdSubCategory=SSORDOrdSubCategory)&(eobj.SSORDRowId'=SSORDRowId)&(SSORDChildsub>0))
					{
						s flag=1 //flag=1 有重复
					}
				}
			}
			if (flag'=1) {
				
				s obj = ##class(User.SSGroupOrderCategory).%OpenId(eobj.SSORDRowId)
				s bobj = ##class(web.Entity.CT.SSGroupOrderCategory).%New()
				s bobj.SSORDRowId=eobj.SSORDRowId
				s bobj.SSORDParRef=$p(eobj.SSORDRowId ,"||",1)
				if $IsObject(obj.SSORDOrdCatDR){
					s bobj.SSORDOrdCatDR = obj.SSORDOrdCatDR.%Id() 
				}
				if $IsObject(obj.SSORDOrdSubCategory){
					s bobj.SSORDOrdSubCategory = obj.SSORDOrdSubCategory.%Id() 
				}
				s bobj.SSORDOrderOnDischarge=obj.SSORDOrderOnDischarge
				s bobj.SSORDOrderInvisbleItem=obj.SSORDOrderInvisbleItem
				s bobj.SSORDOrderSets=obj.SSORDOrderSets
				s bobj.SSORDRequireAuthorisation=obj.SSORDRequireAuthorisation
				s bobj.SSORDOrderOnFinanceDisch=obj.SSORDOrderOnFinanceDisch
				s bobj.SSORDBookingOnly=obj.SSORDBookingOnly
				
				
				
	 			d obj.SSORDParRefSetObjectId(eobj.SSORDParRef)
				d obj.SSORDOrdCatDRSetObjectId(eobj.SSORDOrdCatDR)
				d obj.SSORDOrdSubCategorySetObjectId(eobj.SSORDOrdSubCategory)
				s obj.SSORDOrderOnDischarge=eobj.SSORDOrderOnDischarge
				s obj.SSORDOrderInvisbleItem=eobj.SSORDOrderInvisbleItem
				s obj.SSORDOrderSets=eobj.SSORDOrderSets
				s obj.SSORDRequireAuthorisation=eobj.SSORDRequireAuthorisation
				s obj.SSORDOrderOnFinanceDisch=eobj.SSORDOrderOnFinanceDisch
				s obj.SSORDBookingOnly=eobj.SSORDBookingOnly
				s SSGRPDesc=$p($g(^SSU("SSGRP",eobj.SSORDParRef)),"^",1)
				s ORCATDesc=$p($g(^OEC("ORCAT",eobj.SSORDOrdCatDR)),"^",2)
				
				Tstart
				s sc=obj.%Save()
				do obj.%Close()
				if $$$ISOK(sc){
					Tcommit
					s id = obj.%Id()
					s result = "{success:'true',id:'"_id_"'}"
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupOrderCategory","User.SSGroupOrderCategory","安全组-医嘱授权",id,SSGRPDesc_"->"_ORCATDesc,"U",eobj,bobj)
				}else{
					Trollback
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组-医嘱授权","web.DHCBL.CT.SSGroupOrderCategory","SaveEntity",eobj)
	   				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				}
			}
			else{
				s result = "{success:'false',errorinfo:'该记录已经存在！'}"
			}	
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：陈莹
/// CreatDate: 2014-3-12
/// Description：根据SSGRPRowId,ORCATRowId,ARCICRowId获取医嘱授权SSORDRowId,并删掉这条数据
/// Table：User.SSGroupOrderCategory
/// Input：SSGRPRowId,ORCATRowId,ARCICRowId
/// Return：SSORDRowId
/// w ##class(web.DHCBL.CT.SSGroupOrderCategory).DeleteTreePanel("1","1","407")
ClassMethod DeleteTreePanel(SSGRPRowId As %String, ORCATRowId As %String, ARCICRowId As %String) As %String
{
	s flag=0		
	s SSORDChildsub=0
	for
	{
		s SSORDChildsub=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)) 
		q:(flag=1)
		s SSORDRowId=SSGRPRowId_"||"_SSORDChildsub
		s SSORDOrdCatDR=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",1)
		s SSORDOrdSubCategory=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",5)
		i ((SSORDOrdCatDR=ORCATRowId)&(SSORDOrdSubCategory=ARCICRowId)&(SSORDChildsub>0))
		{
			s flag=1
		}
	}
	s result= ##class(web.DHCBL.CT.SSGroupOrderCategory).DeleteData(SSORDRowId)
	q result
}

/// Creator：陈莹
/// CreatDate: 2012-12-5
/// Description：根据id删除 医嘱授权
/// Table：User.SSGroupOrderCategory
/// Input：id 
/// Return：成功返回true和info，失败返回false和info
ClassMethod DeleteData(id As %String) As %String
{
	n (id,%session)
	s result=""
	s pobj = ##class(User.SSGroupOrderCategory).%OpenId(id)
	s eobj = ##class(web.Entity.CT.SSGroupOrderCategory).%New()
	s eobj.SSORDRowId = id
	s eobj.SSORDParRef = $p(id,"||",1)
	if $IsObject(pobj.SSORDOrdCatDR){
		s eobj.SSORDOrdCatDR = pobj.SSORDOrdCatDR.%Id() 
		}
	if $IsObject(pobj.SSORDOrdSubCategory){
		s eobj.SSORDOrdSubCategory = pobj.SSORDOrdSubCategory.%Id() 
		}
	s eobj.SSORDOrderOnDischarge=pobj.SSORDOrderOnDischarge
	s eobj.SSORDOrderInvisbleItem=pobj.SSORDOrderInvisbleItem
	s eobj.SSORDOrderSets=pobj.SSORDOrderSets
	s eobj.SSORDRequireAuthorisation=pobj.SSORDRequireAuthorisation
	s eobj.SSORDOrderOnFinanceDisch=pobj.SSORDOrderOnFinanceDisch
	s eobj.SSORDBookingOnly=pobj.SSORDBookingOnly			
	s SSGRPDesc=$p($g(^SSU("SSGRP",eobj.SSORDParRef)),"^",1)
	s ORCATDesc=$p($g(^OEC("ORCAT",eobj.SSORDOrdCatDR)),"^",2)
			
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.SSGroupOrderCategory).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupOrderCategory","User.SSGroupOrderCategory","安全组-医嘱授权",id,SSGRPDesc_"->"_ORCATDesc,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组-医嘱授权","web.DHCBL.CT.SSGroupOrderCategory","DeleteData",eobj)
	   	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator:陈莹
/// CreatDate:2013-2-22
/// Description:为combobox查询取数据(医嘱子类)SSORDOrdSubCategory->ARC_ItemCat
/// Table:User.ARCItemCat
/// Input:rowid,code,desc
/// Return:ARCICRowId,ARCICCode,ARCICDesc,
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSGroupOrderCategory","GetARCICDR","","","")
Query GetARCICDR(ordcat As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ARCICRowId:%String,ARCICCode:%String,ARCICDesc:%String")
{
}

ClassMethod GetARCICDRExecute(ByRef qHandle As %Binary, ordcat As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.ARCItemCat).DHCGetDataByDefaultSession()
	s AuFlag=0
	if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	s ARCICRowId=0
	for
	{
		s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""
		//筛选授权后的数据
		s strRowId="{ID:"_ARCICRowId_"}"
		if (AuStr[strRowId)||(AuFlag=1) {
			s ARCICCode=$p($g(^ARC("IC",ARCICRowId)),"^",1)
			s ARCICDesc=$p($g(^ARC("IC",ARCICRowId)),"^",2)
			s ARCICOrdCatDR=$p($g(^ARC("IC",ARCICRowId)),"^",8)
			s ARCICCode1=$ZCONVERT(ARCICCode,"U")
			s ARCICDesc1=$ZCONVERT(ARCICDesc,"U")
			i (ARCICCode1[code)&(ARCICDesc1[desc)&(ARCICOrdCatDR=ordcat)
			{
				d OutputRowARCIC
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowARCIC
    set Data=$lb(ARCICRowId,ARCICCode,ARCICDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetARCICDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetARCICDRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetARCICDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetARCICDRExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取医嘱大类-医嘱子类Tree类型的json串
/// GroupID:要进行医嘱授权的安全组ROWID
/// w ##class(web.DHCBL.CT.SSGroupOrderCategory).GetTreeJson("","1","checked",2)
ClassMethod GetTreeJson(ParentID As %String, GroupID As %String, FilterCK, hospid As %String = "") As %String
{
	n (FilterCK,GroupID,ParentID,%session,hospid)
	if (GroupID="") s GroupID="1" 
	//输出菜单JSON串
	k ^TMP("CheckedFlag")
	s SSORDChildsub=0
	for
	{
		s SSORDChildsub=$o(^SSU("SSGRP",GroupID,"SSORD",SSORDChildsub)) 
		q:(SSORDChildsub="")
		s SSORDParRef=GroupID
		s SSORDOrdCatDR=$P($g(^SSU("SSGRP",GroupID,"SSORD",SSORDChildsub)),"^",1)
		s SSORDOrdSubCategory=$P($g(^SSU("SSGRP",GroupID,"SSORD",SSORDChildsub)),"^",5)
		if (SSORDOrdCatDR="") s SSORDOrdCatDR=0
		if (SSORDOrdSubCategory="") s SSORDOrdSubCategory=0
		s ^TMP("CheckedFlag",GroupID,SSORDOrdCatDR,SSORDOrdSubCategory)=""
	}
	
	s myJsonStr=""
	//获取授权Json
	
	s AuStr=##class(web.DHCBL.Authorize.OECOrderCategory).DHCGetDataByDefaultSession()
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	s myORCATRowId=0
	for 
	{
		s myORCATRowId=$o(^OEC("ORCAT",myORCATRowId)) q:(myORCATRowId="")
		s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("OEC_OrderCategory",myORCATRowId,hospid)  //根据医院过滤
		continue:showflag="N"
		//过滤已选、未选
		s CheckedFlag=0
		if $d(^TMP("CheckedFlag",GroupID,myORCATRowId,0))>0 s CheckedFlag=1
		
		//s CheckedFlag=##class(web.DHCBL.CT.SSGroupOrderCategory).GetCheckedFlag(GroupID,myORCATRowId,"")
		s childJson=..GetChildTreeJson("",GroupID,myORCATRowId,FilterCK,hospid)
		if (FilterCK="checked") 
		{
			if ('CheckedFlag)
			{
				if (childJson'["true") continue
			}
		}
		elseif (FilterCK="unchecked") 
		{
			if (CheckedFlag) {
				if (childJson'["false") continue
			}
		}
		
		//筛选授权后的数据
		s strRowId="{ID:"_myORCATRowId_"}"
		if (AuStr[strRowId)||(AuFlag=1) {
			s myORCATObj=##Class(User.OECOrderCategory).%OpenId(myORCATRowId)
			if $IsObject(myORCATObj) {
				s myORCATDesc = myORCATObj.ORCATDesc
				s AuStrC=##class(web.DHCBL.Authorize.ARCItemCat).DHCGetDataByDefaultSession()
				s AuFlagC=0
				if (AuStrC="")||(AuStrC["limited:0") s AuFlagC=1
				
				s myChildFlag=0 
				//判断是否有子菜单
				s ARCICRowId=0
				for
				{
					s ARCICRowId=$o(^ARC("IC",0,"OrdCat",myORCATRowId,ARCICRowId)) q:(ARCICRowId="")||(myChildFlag=1)
					
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat",ARCICRowId,hospid)  //根据医院过滤
					continue:showflag="N"
		
					//筛选授权后的数据
					s strRowIdC="{ID:"_ARCICRowId_"}"
					if (AuStrC[strRowIdC)||(AuFlagC=1) {
						
						s ARCICCode=$p($g(^ARC("IC",ARCICRowId)),"^",1)
						s ARCICDesc=$p($g(^ARC("IC",ARCICRowId)),"^",2)
						s ARCICOrdCatDR=$p($g(^ARC("IC",ARCICRowId)),"^",8)
						s myChildFlag=1
						
					}
				}
			
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s mid=GroupID_"^"_myORCATRowId_"^"_""   //医嘱子类ID为空
				s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myORCATDesc_""","
				
				if (CheckedFlag) s myJsonStr=myJsonStr_"""checked"":true,"	
				else  s myJsonStr=myJsonStr_"""checked"":false,"

				if (+myChildFlag'=0) {
					s myJsonStr=myJsonStr_"""leaf"":false,"
					s myJsonStr=myJsonStr_"""expanded"":true,"
					//获取子菜单
					s myJsonStr=myJsonStr_"""children"":"_childJson //..GetChildTreeJson("",GroupID,myORCATRowId,FilterCK,hospid)
				}else {
					s myJsonStr=myJsonStr_"""leaf"":true"
				}	
				s myJsonStr=myJsonStr_"}"
				d myORCATObj.%Close()
			}
		}
		
	}

	s myJsonStr="["_myJsonStr_"]"
	
	k ^TMP("CheckedFlag")
	q myJsonStr
}

/// 获取医嘱大类-医嘱子类Tree类型的json串
/// GroupID:要进行医嘱授权的安全组ROWID
/// ORCATRowId:医嘱大类ROWID
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
ClassMethod GetChildTreeJson(ParentID As %String, GroupID As %String, myORCATRowId As %String, FilterCK, hospid As %String = "") As %String
{
	n (FilterCK,GroupID,myORCATRowId,ParentID,%session,hospid)
	if (GroupID="") s GroupID="1" 
	s myARCICRowId=0

	//输出菜单JSON串
	s myARCICRowId=0
	s myJsonStr=""
	
	s AuStr1=##class(web.DHCBL.Authorize.ARCItemCat).DHCGetDataByDefaultSession()
	s AuFlag1=0
	if (AuStr1="")||(AuStr1["limited:0") s AuFlag1=1
	for 
	{
		s myARCICRowId=$o(^ARC("IC",0,"OrdCat",myORCATRowId,myARCICRowId)) q:(myARCICRowId="")
		s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat",myARCICRowId,hospid)  //根据医院过滤
		continue:showflag="N"
		//过滤已选、未选
		s CheckedFlag=0
		if $d(^TMP("CheckedFlag",GroupID,myORCATRowId,myARCICRowId))>0 s CheckedFlag=1
		///s CheckedFlag= ##class(web.DHCBL.CT.SSGroupOrderCategory).GetCheckedFlag(GroupID,myORCATRowId,myARCICRowId)
		if (FilterCK="checked") {
			if ('CheckedFlag) continue
		}
		elseif (FilterCK="unchecked") {
			if (CheckedFlag) continue 
		}
		
		//筛选授权后的数据
		s strRowId1="{ID:"_myARCICRowId_"}"
		if (AuStr1[strRowId1)||(AuFlag1=1) {
		
			s myARCICObj=##Class(User.ARCItemCat).%OpenId(myARCICRowId)
			if $IsObject(myARCICObj) {
				s myARCICDesc = myARCICObj.ARCICDesc
				s myChildFlag=0 
		
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s nid=GroupID_"^"_myORCATRowId_"^"_myARCICRowId
				s myJsonStr=myJsonStr_"""id"":"""_""_nid_""",""text"":"""_myARCICDesc_""","
			
				if (CheckedFlag) s myJsonStr=myJsonStr_"""checked"":true,"	
				else   s myJsonStr=myJsonStr_"""checked"":false,"

				s myJsonStr=myJsonStr_"""leaf"":true"	
				s myJsonStr=myJsonStr_"}"	
				d myARCICObj.%Close()
			}
		}
	}
	s myJsonStr =$tr(myJsonStr,$c(13,10),"")
	s myJsonStr=$tr(myJsonStr,$c(0),"")
	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// CheckedFlag=1 checked：true
/// w ##class(web.DHCBL.CT.SSGroupOrderCategory).GetCheckedFlag("1","4","218")
ClassMethod GetCheckedFlag(GroupID As %String, ORCATRowId As %String, ARCICRowId As %String) As %String
{
	n (ARCICRowId,GroupID,ORCATRowId)
	s SSORDChildsub=0,CheckedFlag=0
	for
	{
		s SSORDChildsub=$o(^SSU("SSGRP",GroupID,"SSORD",SSORDChildsub)) 
		q:(SSORDChildsub="")||(CheckedFlag=1)
		s SSORDParRef=GroupID
		s SSORDOrdCatDR=$P($g(^SSU("SSGRP",GroupID,"SSORD",SSORDChildsub)),"^",1)
		s SSORDOrdSubCategory=$P($g(^SSU("SSGRP",GroupID,"SSORD",SSORDChildsub)),"^",5)
		i ((ORCATRowId=SSORDOrdCatDR)&(ARCICRowId=SSORDOrdSubCategory)&(SSORDChildsub>0))
		{
			s CheckedFlag=1 //CheckedFlag=1 已存在，所以checked：true
		}
	}
	
	q CheckedFlag
}

}
