Class web.DHCEQ.Interface.Inner.DHCEQPACSFrom Extends %Persistent
{

/// 获取RIS系统中的使用记录，通过参数日期，查询当天所有的检查记录。
/// 入参：
/// 		SysType:    系统类型（必传）    RIS（放射数据），PIS(病理数据)… 
/// 		GatherDate:  日期（必传）       格式dd/mm/yy
/// 		EquipID：   设备ID（可选）     设备ID不为空时，返回指定设备该日期所作检查，设备ID为空时，返回所有设备该日期所作检查
/// 		DateType	"Study"/"Report"	因为有些医院或某些科室不用“技师工作站”（我们系统里的一个控件），所以查询时要用报告时间（Report）来确定。
/// 		反之可以用真正的检查时间（Study）来确定。
/// 输出：
///       Info= 设备ID_"^"_检查项目ID(医嘱项)_"^"_价格_"^"_费用_"^"_医嘱号ID_"^"_检查科室ID_"^"_检查开始时间_"^"_检查结束时间_"^"_病人ID号_”^”_病人信息(名称，性别)_"^"_操作医生ID(SS_User) _"^"_RIS系统业务号（每一个检查的唯一业务id）_"^"_阴性/阳性 
/// 建议可以将获取的数据以字符串形式存到临时golable中,golable节点如下:
///     ///^TempDHCEQ("Gather","Result","DHC-RIS", GatherDate, Count)= Info
///     ^TempDHCEQ("Gather","Result","DHC-RIS","Cancel",StudyNo)=StudyNo
/// 		去掉了 GatherDate 原因是取消的接口本身确定不了检查时间，且取消的并不多
/// 		
/// DHCRIS获取使用记录信息
/// 根据登记日期获取
/// w ##Class(web.DHCEQ.Interface.Inner.DHCEQPACSFrom).GatherDHCRISByDeviceID("DHC-RIS","64510","92","Report")
/// RIS相关的Global:^DHCPACRegInfoi,^DHCPACRegInfo,^DHCRBRFi,^DHCRBRF,^RBC("EQ"
ClassMethod GatherDHCRISByDeviceID(SysType As %String, GatherDate As %String, EquipID As %String = "", DateType As %String = "Report") As %String
{
	//Info= 设备ID_"^"_检查项目ID(医嘱项)_"^"_价格_"^"_费用_"^"_医嘱号ID_"^"_检查科室ID
	//_"^"_检查开始时间_"^"_检查结束时间_"^"_病人ID号_”^”_病人信息(名称，性别)_"^"_
	//操作医生ID(SS_User)_"^"_检查号_"^"_阴性/阳性
	s (itemcode,price,oeorowid,loccode)=""
	s (ststarttime,stendtime,patid,name,sex)=""
	s (usercode,staccnum,yinyang)=""
	
	s (mdlid,itemid,price,oeorowid,locid)=""
	s (ststarttime,stendtime,patid,name,sex)=""
	s (userid,staccnum,yinyang)=""
	s mdlid=EquipID
	i (SysType="DHC-RIS")
	{
		s info=""
		//s date=$zd($zdh(GatherDate,4),3)
		s date=$zd(GatherDate,3)
		i EquipID'="" d
		.//modified by cjt 20221205 需求号2888051 ^DHCEQTemp改为^TempDHCEQ
		.k ^TempDHCEQ("Gather","Result","DHC-RIS",date,EquipID)
		e  d
		.k ^TempDHCEQ("Gather","Result","DHC-RIS",date)
		zn "DHC-PACS"
		d ##class(PACS.RISInterface).ModalityBenefitStatistics(date,EquipID,DateType)
		i EquipID'="" d
		.;modified by cjt 20221205 需求号2888051 DHC-PACS那边^DHCPACSEQTemp更名^Busi.RIS.EQTemp
		.s staccnum="" f  s staccnum=$o(^Busi.RIS.EQTemp("Gather","Result","DHC-RIS",date,EquipID,staccnum),1,info) q:staccnum=""  d
		..zn "DHC-APP"
		..s dhcinfo=##Class(web.DHCEQ.Interface.Inner.DHCEQPACSFrom).GatherDHCRISCodetoId(info)
		..q:dhcinfo=""
		..s eqid=+$p(dhcinfo,"^",1)
		..q:eqid=0
		..s ^TempDHCEQ("Gather","Result","DHC-RIS",date,eqid,staccnum)=dhcinfo
		..zn "DHC-PACS"
		e  d
		.s mdlid1="" f  s mdlid1=$o(^Busi.RIS.EQTemp("Gather","Result","DHC-RIS",date,mdlid1)) q:mdlid1=""  d
		..s staccnum="" f  s staccnum=$o(^Busi.RIS.EQTemp("Gather","Result","DHC-RIS",date,mdlid1,staccnum),1,info) q:staccnum=""  d
		...zn "DHC-APP"
		...s dhcinfo=##Class(web.DHCEQ.Interface.Inner.DHCEQPACSFrom).GatherDHCRISCodetoId(info)
		...q:dhcinfo=""
		...s eqid=+$p(dhcinfo,"^",1)
		...//q:(eqid=83)&&(staccnum'["MR")
		...q:eqid=0
		...s ^TempDHCEQ("Gather","Result","DHC-RIS",date,eqid,staccnum)=dhcinfo
		...zn "DHC-PACS"
		zn "DHC-APP"
		//查询取消检查
		k ^TempDHCEQ("Gather","Result","DHC-RIS",date,"Cancel")
		s eqid=0 f  s eqid=$o(^TempDHCEQ("Gather","Result","DHC-RIS",date,eqid)) q:eqid=""  d
		.s StudyNo="" f  s StudyNo=$o(^DHCPACSEQTemp("Gather","Result","DHC-RIS",date,eqid,StudyNo)) q:StudyNo=""  d
		..s ristemp=""
		..s ristemp=$g(^DHCEQRISTemp("Gather","Result","DHC-RIS","Cancel",StudyNo))
		..i ristemp'="" d
		...s ^TempDHCEQ("Gather","Result","DHC-RIS",date,"Cancel",StudyNo)=""
	}
	q 0
}

// 

/// w ##Class(web.DHCEQ.Interface.Inner.DHCEQPACSFrom).GatherDHCRISCodetoId("88^A056000002^100^100^4945903||12^骨密度室^1901-01-01 00:00:00^1901-01-01 00:00:00^0002055813^张爱玲,女^^GMD0017646^")
ClassMethod GatherDHCRISCodetoId(info As %String) As %String
{
	q:info="" ""
	s mdlid=$p(info,"^",1)
	q:mdlid="" ""
	s itemcode=$p(info,"^",2)
	q:itemcode="" ""
	s price=$p(info,"^",3)
	s fee=$p(info,"^",4)
	s oeorowid=$p(info,"^",5)
	s loccode=$p(info,"^",6)
	s ststarttime=$p(info,"^",7)
	s stendtime=$p(info,"^",8)
	s patid=""   //病人ID（非登记号）
	s patinfo=$p(info,"^",10)
	s usercode=$p(info,"^",11)
	s studyno=$p(info,"^",12)
	s yinyang=$p(info,"^",13)
	
	s (itemid,locid,patid,userid)=""
	s itemidSubscript=$o(^ARCIM(0,"Code",itemcode,""))
	i itemidSubscript'="" d
	.s itemidVersion=$o(^ARCIM(0,"Code",itemcode,itemidSubscript,""))
	.s itemid=itemidSubscript_"||"_itemidVersion
	i loccode'="" d
	.s locid=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(loccode),""))
	i oeorowid'="" d
	.s orderrowid=$p(oeorowid,"||",1)
	.s paadmdr=$p($g(^OEORD(orderrowid)),"^",1)
	.i paadmdr'="" s patid=$p($g(^PAADM(paadmdr)),"^",1)
	i usercode'="" d
	.s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
	
	s drinfo=mdlid_"^"_itemid_"^"_price_"^"_fee_"^"_oeorowid_"^"_locid_"^"_ststarttime_"^"_stendtime_"^"_patid_"^"_patinfo_"^"_userid_"^"_studyno_"^"_yinyang
	q drinfo
}

/// add by lmm 2018-05-29
/// w ##Class(web.DHCEQ.Interface.Inner.DHCEQPACSFrom).GetZeroFeeExID("DHC-RIS","64791","1443935||19:TB01~JC000065*1443935||18:TB01~JC000067*1443935||17:TB01~JC000768*1443935||16:TB01~JC000689")
ClassMethod GetZeroFeeExID(ExType, GatherDate, OeoStr)
{
	//add by lmm 2018-05-18 begin
	s oeoLength=$l(OeoStr,"*")
	s price=-1
	for i=1:1:oeoLength
	{
		s oeolist=$p(OeoStr,"*",i)
		//s oeoid=$p(oeolist,":",1)
		s partcodeinfo=$p(oeolist,":",2)
		s partcodestr=$p(partcodeinfo,"~",1)
			 
		s checkitemcode=$p(partcodeinfo,"~",2)   //$p(oeolist,"~",2)
		s checkitemid=""
		i checkitemcode'=""  d
		.s checkitemidSubscript=$o(^ARCIM(0,"Code",checkitemcode,""))   //医嘱项表
		.i checkitemidSubscript'="" d
		..s checkitemidVersion=$o(^ARCIM(0,"Code",checkitemcode,checkitemidSubscript,""))
		..s checkitemid=checkitemidSubscript_"||"_checkitemidVersion
		
		
		if checkitemid'="" s price=##Class(web.DHCEQ.BA.CTServiceItem).GetServicePriceByExID(ExType,checkitemid, GatherDate)
		if price=0 q		
	}
	if price=0 q price_"^"_checkitemid
	
	q price_"^"
}

Storage Default
{
<Data name="DHCEQPACSFromDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQ.Int5FF.DHCEQPACSFromD</DataLocation>
<DefaultData>DHCEQPACSFromDefaultData</DefaultData>
<IdLocation>^web.DHCEQ.Int5FF.DHCEQPACSFromD</IdLocation>
<IndexLocation>^web.DHCEQ.Int5FF.DHCEQPACSFromI</IndexLocation>
<StreamLocation>^web.DHCEQ.Int5FF.DHCEQPACSFromS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
