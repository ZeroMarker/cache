/// 名称: 升级代码表基础数据相关服务
/// 编写者：zhufei
/// 编写日期: 2021-08-25
Class web.DHCPE.Upgrade.BusiTableSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  20210825
/// Description: 升级业务表数据调整主程序
/// Table：      所有新建或新加字段的业务数据表
/// Input:       无
/// Return：     return="OK!!!"
/// debug: w ##class(web.DHCPE.Upgrade.BusiTableSrv).Main(1)
ClassMethod Main(aUserID As %String) As %String
{
    n (aUserID)
    s return="-1^参数为空"
    q:(aUserID="") return
    q:'$d(^SSU("SSUSR",aUserID)) return
	
	//与医嘱项目和医嘱套相关表
	//DHC_PE_PreGTOrdEnt
	//DHC_PE_PreGTOrdItem
	//DHC_PE_PreIOrdEnt
	//DHC_PE_PreIOrdItem
	
    w "DHC_PE_PreGTOrdEnt--新加字段，补全数据",!
    w "---如果存在未补全的数据，手工维护上之后再重新执行此方法",!
    w "执行结果="_..toPreGTOrdEnt("DHC_PE_PreGTOrdEnt",aUserID),!!
    
    w "DHC_PE_PreGTOrdItem--新加字段，补全数据",!
    w "---如果存在未补全的数据，手工维护上之后再重新执行此方法",!
    w "执行结果="_..toPreGTOrdItem("DHC_PE_PreGTOrdItem",aUserID),!!
    
    w "DHC_PE_PreIOrdEnt--新加字段，补全数据",!
    w "---如果存在未补全的数据，手工维护上之后再重新执行此方法",!
    w "执行结果="_..toPreIOrdEnt("DHC_PE_PreIOrdEnt",aUserID),!!
    
    w "DHC_PE_PreIOrdItem--新加字段，补全数据",!
    w "---如果存在未补全的数据，手工维护上之后再重新执行此方法",!
    w "执行结果="_..toPreIOrdItem("DHC_PE_PreIOrdItem",aUserID),!!
    
    //与科室相关表
    //DHC_PE_PreIADM--就诊科室/登记科室
    //DHC_PE_IADM--新加字段，补全数据（到达科室）
	
    w "DHC_PE_IADM--新加字段，补全数据（到达科室）",!
    w "---历史数据把个人预约表的就诊科室作为到达科室",!
    w "执行结果="_..toIADM("DHC_PE_IADM",aUserID),!!
	
	q "OK!!!"
}

/// DHC_PE_IADM--新加字段，补全数据（到达科室）
ClassMethod toIADM(aTableName As %String, aUserID As %String) As %String
{
    n (aTableName,aUserID)
    
    s return=""
	s xIADM=0
	for {
		s xIADM=$o(^DHCPEIADM(xIADM))
		q:xIADM=""
		q:return'=""
		
		s LocID=""
		s obj=##class(User.DHCPEIADM).%OpenId(xIADM)
		continue:'$IsObject(obj)
		if '$IsObject(obj.IADMCRMADM){
			d obj.%Close()
			continue
		} else {
			s LocID=obj.IADMCRMADM.PIADMDepCodeDR
		}
		s obj.IADMAdmLocDR=LocID
		s sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
	   		d $system.OBJ.DisplayError(sc)
	   		s return=aTableName_" 表数据迁移报错"
	   		q
		}
		d obj.%Close()
	}
	q return
}

/// DHC_PE_PreIOrdItem--新加字段，补全数据
ClassMethod toPreIOrdItem(aTableName As %String, aUserID As %String) As %String
{
    n (aTableName,aUserID)
    
    k arrSTError
    s return=""
	s xIADM=0
	for {
		s xIADM=$o(^DHCPEPreIADM(xIADM))
		q:xIADM=""
		q:return'=""
		
		s xOrdItem=0
		for {
			s xOrdItem=$o(^DHCPEPreIADM(xIADM,"ORDITEM",xOrdItem))
			q:xOrdItem=""
			q:return'=""
			
			s ID=xIADM_"||"_xOrdItem
		    s obj=##class(User.DHCPEPreIOrdItem).%OpenId(ID)
			continue:'$IsObject(obj)
			s LocID=obj.PIOIParRef.PIADMDepCodeDR
			d obj.PIOISTOrderSetDRSetObjectId(..GetSTOrderSetDR(obj.PIOIItmMastDR,LocID))
			s obj.PIOIOrderLocDR=LocID
			s sc=obj.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
		   		d $system.OBJ.DisplayError(sc)
		   		s return=aTableName_" 表数据迁移报错"
		   		q
			} else {
				if '$IsObject(obj.PIOISTOrderSetDR)&&(obj.PIOIItmMastDR'="") {
					s ARCIMID=obj.PIOIItmMastDR
					s arrSTError(+LocID,ARCIMID)=$p($g(^CTLOC(+LocID)),"^",2)_","_$p($g(^ARCIM(+ARCIMID,+$p(ARCIMID,"||",2),1)),"^",2)
				}
			}
			d obj.%Close()
		}
	}
	zw arrSTError
	k arrSTError
	q return
}

/// DHC_PE_PreIOrdEnt--新加字段，补全数据
ClassMethod toPreIOrdEnt(aTableName As %String, aUserID As %String) As %String
{
    n (aTableName,aUserID)
    
    k arrSTError
    s return=""
	s xIADM=0
	for {
		s xIADM=$o(^DHCPEPreIADM(xIADM))
		q:xIADM=""
		q:return'=""
		
		s xOrdEnt=0
		for {
			s xOrdEnt=$o(^DHCPEPreIADM(xIADM,"ORDENT",xOrdEnt))
			q:xOrdEnt=""
			q:return'=""
			
			s ID=xIADM_"||"_xOrdEnt
		    s obj=##class(User.DHCPEPreIOrdEnt).%OpenId(ID)
			continue:'$IsObject(obj)
			s LocID=obj.PIOEParRef.PIADMDepCodeDR
			d obj.PIOESTOrdSetsExDRSetObjectId(..GetSTOrdSetsExDR(obj.PIOEOrderSetsDR))
			s obj.PIOEOrderLocDR=LocID
			s sc=obj.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
		   		d $system.OBJ.DisplayError(sc)
		   		s return=aTableName_" 新建表数据迁移报错"
		   		q
			} else {
				if '$IsObject(obj.PIOESTOrdSetsExDR)&&(obj.PIOEOrderSetsDR'="") {
					s ARCOSID=obj.PIOEOrderSetsDR
					s arrSTError(ARCOSID)=$p($g(^ARCOS(+ARCOSID)),"^",2)
				}
			}
			d obj.%Close()
		}
	}
	zw arrSTError
	k arrSTError
	q return
}

/// DHC_PE_PreGTOrdItem--新加字段，补全数据
ClassMethod toPreGTOrdItem(aTableName As %String, aUserID As %String) As %String
{
    n (aTableName,aUserID)
    
    k arrSTError
    s return=""
	s xGADM=0
	for {
		s xGADM=$o(^DHCPEPreGADM(xGADM))
		q:xGADM=""
		q:return'=""
		
		s xTeam=0
		for {
			s xTeam=$o(^DHCPEPreGADM(xGADM,"Team",xTeam))
			q:xTeam=""
			q:return'=""
			
			s xOrdItem=0
			for {
				s xOrdItem=$o(^DHCPEPreGADM(xGADM,"Team",xTeam,"ORDITEM",xOrdItem))
				q:xOrdItem=""
				q:return'=""
				
				s ID=xGADM_"||"_xTeam_"||"_xOrdItem
			    s obj=##class(User.DHCPEPreGTOrdItem).%OpenId(ID)
				continue:'$IsObject(obj)
				s LocID=obj.PGTOIParRef.PGTParRef.PGADMDepCodeDR
				d obj.PGTOISTOrderSetDRSetObjectId(..GetSTOrderSetDR(obj.PGTOIItmMastDR,LocID))
				s obj.PGTOIOrderLocDR=LocID
				s sc=obj.%Save()
				if $system.Status.IsError(sc) {        //检查Save是否成功
			   		d $system.OBJ.DisplayError(sc)
			   		s return=aTableName_" 新建表数据迁移报错"
			   		q
				} else {
					if '$IsObject(obj.PGTOISTOrderSetDR)&&(obj.PGTOIItmMastDR'="") {
						s ARCIMID=obj.PGTOIItmMastDR
						s arrSTError(+LocID,ARCIMID)=$p($g(^CTLOC(+LocID)),"^",2)_","_$p($g(^ARCIM(+ARCIMID,+$p(ARCIMID,"||",2),1)),"^",2)
					}
				}
				d obj.%Close()
			}
		}
	}
	zw arrSTError
	k arrSTError
	q return
}

/// DHC_PE_PreGTOrdEnt--新加字段，补全数据
ClassMethod toPreGTOrdEnt(aTableName As %String, aUserID As %String) As %String
{
    n (aTableName,aUserID)
    
    k arrSTError
    s return=""
	s xGADM=0
	for {
		s xGADM=$o(^DHCPEPreGADM(xGADM))
		q:xGADM=""
		q:return'=""
		
		s xTeam=0
		for {
			s xTeam=$o(^DHCPEPreGADM(xGADM,"Team",xTeam))
			q:xTeam=""
			q:return'=""
			
			s xOrdEnt=0
			for {
				s xOrdEnt=$o(^DHCPEPreGADM(xGADM,"Team",xTeam,"ORDENT",xOrdEnt))
				q:xOrdEnt=""
				q:return'=""
				
				s ID=xGADM_"||"_xTeam_"||"_xOrdEnt
			    s obj=##class(User.DHCPEPreGTOrdEnt).%OpenId(xGADM_"||"_xTeam_"||"_xOrdEnt)
				continue:'$IsObject(obj)
				s LocID=obj.PGTOEParRef.PGTParRef.PGADMDepCodeDR
				d obj.PGTOESTOrdSetsExDRSetObjectId(..GetSTOrdSetsExDR(obj.PGTOEOrderSetsDR))
				s obj.PGTOEOrderLocDR=LocID
				s sc=obj.%Save()
				if $system.Status.IsError(sc) {        //检查Save是否成功
			   		d $system.OBJ.DisplayError(sc)
			   		s return=aTableName_" 新建表数据迁移报错"
			   		q
				} else {
					if '$IsObject(obj.PGTOESTOrdSetsExDR)&&(obj.PGTOEOrderSetsDR'="") {
						s ARCOSID=obj.PGTOEOrderSetsDR
						s arrSTError(ARCOSID)=$p($g(^ARCOS(+ARCOSID)),"^",2)
					}
				}
				d obj.%Close()
			}
		}
	}
	zw arrSTError
	k arrSTError
	q return
}

/// 通过医嘱项ID找站点项目组合表ID
/// w ##class(web.DHCPE.Upgrade.BusiTableSrv).GetSTOrderSetDR("1385||1",1)
ClassMethod GetSTOrderSetDR(aARCIMID As %String, aLocID As %String) As %String
{
	n (aARCIMID,aLocID)
	s return=""
	q:(aARCIMID="")||(aLocID="") return
	
	s STID=$o(^DHCPEST(0,"STORD_ARCIM",aARCIMID,0))
	q:STID="" return
	s Sub=$o(^DHCPEST(0,"STORD_ARCIM",aARCIMID,STID,0))
	q:Sub="" return
	s STOrderID=STID_"||"_Sub
	s return=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_aLocID,STOrderID,0))
	q return
}

/// 通过医嘱套ID找体检套餐扩展表ID
/// w ##class(web.DHCPE.Upgrade.BusiTableSrv).GetSTOrdSetsExDR()
ClassMethod GetSTOrdSetsExDR(aARCOSID As %String) As %String
{
	n (aARCOSID)
	s return=""
	q:(aARCOSID="") return
	
	s return=$o(^DHCPEOSE(0,"OrdSets",aARCOSID,0))
	q return
}

}
