/// desc CDSS工具维护表逻辑处理类
/// creator duan
/// createDate 2020-06-03
Class EMRservice.BL.BLCDSSTool Extends %RegisteredObject
{

/// desc 获取使用的第三方CDSS工具名称  惠每:CDSSHM, 百度:CDSSBD, 东华:CDSSDH, 万方:CDSSWF, 睿杰:CDSSRJ
/// debug d ##class(EMRservice.BL.BLCDSSTool).GetCDSSTool()
ClassMethod GetCDSSTool()
{
	s $ZT="ERROR"
	s (Id,cdssTool)=""
	for{
		s Id = $O(^DHCEMRM.CDSSToolI("CDSSToolActive"," 1",Id))
		q:Id=""	
		s CDSSObj = ##class(EMRmeta.CDSS.CDSSTool).%OpenId(Id)
		s:cdssTool'="" cdssTool=cdssTool_"^"_$zcvt(CDSSObj.CDSSTool,"U")
		s:cdssTool="" cdssTool=$zcvt(CDSSObj.CDSSTool,"U")
	}
	q cdssTool
ERROR
	q ""
}

/// debug d ##class(EMRservice.BL.BLCDSSTool).GetCDSSLock()
/// desc 获取CDSS科室控制条件，只有Y，全院开启，Y^科室ID（多个科室ID，英文逗号隔开）开启指定科室,N不开启CDSS
ClassMethod GetCDSSLock()
{
	s $ZT="ERROR"
	s (Id,CDSSLock)= ""
	for{
		s Id = $O(^DHCEMRM.CDSSToolI("CDSSToolActive"," 1",Id))
		q:Id=""	
		s CDSSObj = ##class(EMRmeta.CDSS.CDSSTool).%OpenId(Id)
		s:CDSSLock'="" CDSSLock=CDSSLock_"#"_$zcvt(CDSSObj.CDSSLock,"U")_"&"_$zcvt(CDSSObj.CDSSTool,"U")
		s:CDSSLock="" CDSSLock=$zcvt(CDSSObj.CDSSLock,"U")_"&"_$zcvt(CDSSObj.CDSSTool,"U")
	}
	s:CDSSLock="" CDSSLock="N"
	q CDSSLock
ERROR
	q "N"
}

/// desc 维护第三方CDSS工具标识
/// debug w ##class(EMRservice.BL.BLCDSSTool).InitAndUpdateCDSS()
ClassMethod InitAndUpdateCDSS(CDSSTool As %String, CDSSLock As %String = "Y", CDSSParam As %String = "", isActive As %String = 1)
{
	//判断是否存在对应工具
	s $ZT="ERROR"
	s Id = ""
	s result = "工具设置失败，检查参数接口"
	q:(CDSSTool="")||(CDSSLock="") result 
	&SQL(SELECT ID INTO :Id from EMRmeta_CDSS.CDSSTool where CDSSTool = :CDSSTool)
	if (Id=""){
		&SQL(INSERT INTO EMRmeta_CDSS.CDSSTool (CDSSLock,CDSSTool,IsActive,Paramter) VALUES (:CDSSLock,:CDSSTool,:isActive,:CDSSParam))
		s result = "插入工具成功"
	}else{
		//存在工具 更新数据	
		&SQL(UPDATE EMRmeta_CDSS.CDSSTool SET CDSSLock=:CDSSLock,CDSSTool=:CDSSTool,IsActive=:isActive,Paramter=:CDSSParam WHERE ID = Id)
		s result = "更新工具成功"
	}
	q result
ERROR
	q "工具设置失败："_$zerror
}

/// desc 初始化术语集关联临床决策支持系统(EMRmeta.CDSS.HDSDLinkCDSS)
/// debug w ##class(EMRservice.BL.BLCDSSTool).initHDSDLinkCDSS("D:\HDSDLinkCDSS.txt")
ClassMethod initHDSDLinkCDSS(argFile)
{
	s $ZT="ERROR"
	k ^DHCEMRM.CDSS.HDSDLinkCDSSD
	k ^DHCEMRM.CDSS.HDSDLinkCDSSI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s count=0
	While 'Stream.AtEnd {
		s Line = Stream.ReadLine()
		continue:Line=""
		s CDSSCode = $P(Line,$C(9),1)
		s CDSSTool = $P(Line,$C(9),2)
		s DocumentDesc = $P(Line,$C(9),3)
		s EMRDocID = $P(Line,$C(9),4)
		s TitleCode = $P(Line,$C(9),5)
		&sql(INSERT INTO EMRmeta_CDSS.HDSDLinkCDSS d (d.CDSSCode,d.CDSSTool,d.DocumentDesc,d.EMRDocID,d.TitleCode) VALUES (:CDSSCode,:CDSSTool,:DocumentDesc,:EMRDocID,:TitleCode))
		s count = count+1
	}
	q "初始化术语集关联临床决策支持系统成功:"_count
ERROR
	q "未知错误："_$zerror
}

/// desc 初始化术语集关联临床决策支持系统(EMRmeta.CDSS.HDSDLinkEMRDoc)
/// debug w ##class(EMRservice.BL.BLCDSSTool).initHDSDLinkEMRDoc("D:\HDSDLinkEMRDoc.txt")
ClassMethod initHDSDLinkEMRDoc(argFile)
{
	s $ZT="ERROR"
	k ^DHCEMRM.CDSS.HDSDLinkEMRDocD
	k ^DHCEMRM.CDSS.HDSDLinkEMRDocI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s count=0
	While 'Stream.AtEnd {
		s Line = Stream.ReadLine()
		continue:Line=""
		s CDSSTool = $P(Line,$C(9),1)
		s EMRDocID = $P(Line,$C(9),2)
		s HDSDCode = $P(Line,$C(9),3)
		s TitleCode = $P(Line,$C(9),4)
		&sql(INSERT INTO EMRmeta_CDSS.HDSDLinkEMRDoc d (d.CDSSTool,d.EMRDocID,d.HDSDCode,d.TitleCode) VALUES(:CDSSTool,:EMRDocID,:HDSDCode,:TitleCode))
		s count = count+1
	}
	q "初始化语集关联临床决策支持系统成功:"_count
ERROR
	q "未知错误："_$zerror
}

/// desc 初始化临床决策病历章节代码表(EMRmeta.CDSS.HDSDSection)
/// debug w ##class(EMRservice.BL.BLCDSSTool).initHDSDSection("D:\HDSDSection.txt")
ClassMethod initHDSDSection(argFile)
{
	s $ZT="ERROR"
	k ^DHCEMRM.CDSS.HDSDSectionD
	k ^DHCEMRM.CDSS.HDSDSectionI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s count=0
	While 'Stream.AtEnd {
		s Line = Stream.ReadLine()
		continue:Line=""
		s CDSSTool = $P(Line,$C(9),1)
		s ConfigSpecial = $P(Line,$C(9),2)
		s DiagnosisType = $P(Line,$C(9),3)
		s HDSDCode = $P(Line,$C(9),4)
		s HDSDSectionCode = $P(Line,$C(9),5)
		s SectionDesc = $P(Line,$C(9),6)
		s SectionKeyDesc = $P(Line,$C(9),7)
		&sql(INSERT INTO EMRmeta_CDSS.HDSDSection d (d.CDSSTool,d.ConfigSpecial,d.DiagnosisType,d.HDSDCode,d.HDSDSectionCode,d.SectionDesc,d.SectionKeyDesc) VALUES(:CDSSTool,:ConfigSpecial,:DiagnosisType,:HDSDCode,:HDSDSectionCode,:SectionDesc,:SectionKeyDesc))
		s count = count+1
	}
	q "初始化临床决策病历章节代码表成功:"_count
ERROR
	q "未知错误："_$zerror
}

/// 批量索引建立（谨慎使用）
/// w ##class(EMRservice.BL.BLCDSSTool).initIndices()
ClassMethod initIndices()
{
	d ##class(EMRmeta.CDSS.CDSSTool).%BuildIndices()
	d ##class(EMRmeta.CDSS.CDSSConfig).%BuildIndices()
	d ##class(EMRmeta.CDSS.HDSDLinkCDSS).%BuildIndices()
	d ##class(EMRmeta.CDSS.HDSDLinkEMRDoc).%BuildIndices()
	d ##class(EMRmeta.CDSS.HDSDSection).%BuildIndices()
	q "索引建立结束"
}

}
