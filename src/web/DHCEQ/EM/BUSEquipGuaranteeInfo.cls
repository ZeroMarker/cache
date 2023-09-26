Class web.DHCEQ.EM.BUSEquipGuaranteeInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// w ##Class(web.DHCEQ.EM.BUSEquipGuaranteeInfo).SaveEquipGuaranteeInfo("0","20")
ClassMethod SaveEquipGuaranteeInfo(SourceType As %Library.String = "", EquipID As %Library.String = "")
{
	//S OpenCheckListDR=$p($g(^DHCEQEquip(EquipID)),"^",77)	
	//Modefied by zc0129 2023-02-11 不存在质保修不插入数据 begin
	s SQLCODE=0
	i EquipID="" q SQLCODE
	i $p($g(^DHCEQEquip(EquipID)),"^",73)=""  q SQLCODE
	//Modefied by zc0129 2023-02-11 不存在质保修不插入数据 end
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))   //Modefied by zc0129 2023-02-11 人员取值错误修正
	s Date=+$H
	s PLIST(2) = SourceType	;保修类型
	s PLIST(3) = EquipID	;保修设备
	s PLIST(4) =$p($g(^DHCEQEquip(EquipID)),"^",13)	;保修开始日期
	s PLIST(5) = ##Class(web.DHCEQCommon).DateAddInt("M",$p($g(^DHCEQEquip(EquipID)),"^",73),$p($g(^DHCEQEquip(EquipID)),"^",13))	;保修结束日期
	s PLIST(6) = $p($g(^DHCEQEquip(EquipID)),"^",69)			;服务商ID
	s PLIST(7) = $p($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",18)	;服务联系
	s PLIST(8) = $p($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",19)	;服务联系电话
	s PLIST(9) = $p($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",22)	;售后经理
	s PLIST(10) = $p($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",23)	;售后经理电话
	s PLIST(11) = $p($g(^DHCEQEquip(EquipID)),"^",32)	;合同明细ID
	s PLIST(12) = ""	;合同ID
	s PLIST(13) = ""	;合同金额
	s PLIST(14) = ""	;维修时间
	s PLIST(15) = ""	;自付费用
	s PLIST(16) = ""	;保修费用
	s PLIST(17) = ""	;维修总费用
	s PLIST(18) = "0"	;状态
	s PLIST(19) = ""	;备注
	s PLIST(20) = "Y"	;最后标记
	s PLIST(21) = "N" ;
	s PLIST(22) = User	;最后更新人
	s PLIST(23) = +$H	;最后更新日期
	s PLIST(24) = $Piece($H,",",2)	;最后更新时间
	
	&SQL(select EGI_RowID into :rowid from SQLUSER.DHC_EQEquipGuaranteeInfo where EGI_EquipDR=:PLIST(3))
	i rowid=""
 	{
 		&SQL(Insert Into SQLUSER.DHC_EQEquipGuaranteeInfo Values :PLIST())		
 	} 
 	else
 	{
 		&SQL(Update SQLUSER.DHC_EQEquipGuaranteeInfo Values :PLIST() where EGI_RowID = :rowid)  			
 	}
 	
	q SQLCODE
}

// Modefied by zc0129 2023-02-11 维修质保修需要写入质保信息表里 begin

ClassMethod SaveMaintGuaranteeInfo(SourceType As %Library.String = "", SourceID As %Library.String = "", EquipID As %Library.String = "")
{
	s SQLCODE=0
	i EquipID="" q SQLCODE
	s RLastEGIRowID=##Class(web.DHCEQ.EM.BUSEquipGuaranteeInfo).GetLastEGIRowID(SourceType,EquipID)
	if (RLastEGIRowID'="")
	{
		&SQL(Update SQLUSER.DHC_EQEquipGuaranteeInfo set EGI_Status='1' where EGI_RowID = :RLastEGIRowID)  
	}
	If SQLCODE Quit SQLCODE
	k MGLIST
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))   //Modefied by zc0129 2023-02-11 人员取值错误修正
	s Date=+$H
	s MGLIST(2) = SourceType	;保修类型
	s MGLIST(3) = EquipID	;保修设备
	s MGLIST(4) =$p($g(^DHCEQMMaintRequest(SourceID)),"^",16)	;保修开始日期
	s MGLIST(5) = ##Class(web.DHCEQCommon).DateAddInt("M",$p($g(^DHCEQMMaintRequest(SourceID)),"^",73),$p($g(^DHCEQMMaintRequest(SourceID)),"^",16))	;保修结束日期
	s MGLIST(6) = $p($g(^DHCEQMMaintRequest(SourceID)),"^",31)			;服务商ID
	s MGLIST(17) = $p($g(^DHCEQMMaintRequest(SourceID)),"^",60)	;维修总费用
	s MGLIST(18) = "0"	;状态
	s MGLIST(19) = ""	;备注
	s MGLIST(20) = "Y"	;最后标记
	s MGLIST(21) = "N" ;
	s MGLIST(22) = User	;最后更新人
	s MGLIST(23) = +$H	;最后更新日期
	s MGLIST(24) = $Piece($H,",",2)	;最后更新时间

 	&SQL(Insert Into SQLUSER.DHC_EQEquipGuaranteeInfo Values :MGLIST())		

	q SQLCODE
}

ClassMethod GetLastEGIRowID(SourceType As %Library.String = "", EquipID As %Library.String = "")
{
	
	i EquipID="" q ""
	s LastEGIRowID=""
	s EGIRowID=0
	f  s EGIRowID=$o(^DHCEQEquipGuaranteeInfo(0,"EquipDR",EquipID,EGIRowID))  q:EGIRowID=""  d
	.q:$p($g(^DHCEQEquipGuaranteeInfo(EGIRowID)),"^",20)="Y"
	.q:$p($g(^DHCEQEquipGuaranteeInfo(EGIRowID)),"^",17)'=0
	.q:$p($g(^DHCEQEquipGuaranteeInfo(EGIRowID)),"^",2)'=SourceType
	.s LastEGIRowID=EGIRowID
	q LastEGIRowID
}

}
