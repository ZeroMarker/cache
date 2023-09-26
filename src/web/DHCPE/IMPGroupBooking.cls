Import SQLUser

/// 创建时间		：2006.09.27
/// 创建人		：xuwm
/// 存在系统		：体检系统
/// 关联数据		: DHC_PE_PreGTeam,DHC_PE_PreIADM
/// 索引			: 
/// 主要功能		：导入团体的预约信息
/// 主要功能		：从一个团体给的Excel文件导入分组的信息和检验项目
/// 									个人 的信息、预约记录、检验项目
/// 最后修改时间	：
/// 最后修改人	：
/// 文件状态		: 未完成
/// 
Class web.DHCPE.IMPGroupBooking Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 31;

// w $$GetOEOrdItem^DHCPEIMPGInfor("9608")

/// 导入团体组信息
ClassMethod ImportGTeamInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s ^xList("GTeam")=InString
	
	k PLIST
    s iLLoop=1
    // 1 PGT_ParRef 团体ADM
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(0)=value
	s iLLoop=iLLoop+1
	
    // 2 PGT_RowId	
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(1)=value
	s iLLoop=iLLoop+1
	
    // 3 PGT_ChildSub
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(2)=value
	s iLLoop=iLLoop+1
	
    // 4 PGT_Desc	分组名称
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(3)=value
	s iLLoop=iLLoop+1
	
    // 5 PGT_Sex 性别
    s value=$p(InString,"^",iLLoop)
    s PLIST(4)=""
    i "男"=value s PLIST(4)="M"
    i "女"=value s PLIST(4)="F"
    i ""=PLIST(4) s PLIST(4)="N"
	s iLLoop=iLLoop+1
 	
 	// 6 PGT_UpperLimit	年龄上限 
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(5)=value
	s iLLoop=iLLoop+1
	
    // 7 PGT_LowerLimit	年龄下限
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(6)=value
	s iLLoop=iLLoop+1
	
	// 8 PGT_Married	婚姻状况
    s value=$p(InString,"^",iLLoop)
    s PLIST(7)=""
    i "未婚"=value s PLIST(7)="UM"
    i "已婚"=value s PLIST(7)="M"
    i ""=PLIST(7) s PLIST(7)="N"
	s iLLoop=iLLoop+1
	
	// 9 PGT_UpdateUser_DR	操作员
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(8)=value
	s iLLoop=iLLoop+1
	    
    // 10 PGT_UpdateDate	日期
    s PLIST(9)=+$H
	
	/// 查看是否已插入记录

	&sql(
		select PGT_RowId into :RowId 
		from DHC_PE_PreGTeam 
		where PGT_Desc=:PLIST(3) and PGT_ParRef=:PLIST(0)
		)
	
	i "0"=SQLCODE d 
	.k PLIST,P0,P1
	.s P0="Err 01" //
	.s PLIST(1)="Err 01"
	.s P1=RowId
	.s PLIST(2)=RowId
	.s PLIST=2
	Q:("0"=SQLCODE) 

	/// 
	s ret=..GTPInsert()
	Q ret
}

/// 个人进本信息
/// 使用 PLIST 插入数据 要求设置PLIST
/// 可以使用 Vism 调用
ClassMethod GTPInsert()
{
	&sql(
		insert into DHC_PE_PreGTeam values :PLIST()
	)
	
	k PLIST
	s PLIST(1)=SQLCODE
	s PLIST(2)=""
	i "0"=PLIST(1) s PLIST(2)=%ROWID
	
	s P0=PLIST(1)
	s P1=PLIST(2)
	
	s PLIST=3
	Q PLIST(1)_"^"_PLIST(2)
}

/// 保存客户信息
/// d ##Class(web.DHCPE.IMPGroupBooking).ImportPreIBaseInfo()
/// 
ClassMethod ImportPreIBaseInfo(InString As %String)
{
	s ^xList("PreIBaseInfo")=InString
	
	k PLIST
	
	s iLLoop=1
	
	//	PIBI_RowId 1
	//s PLIST(1)=""
	s iLLoop=iLLoop+1
	
	//	PIBI_PAPMINo	登记号 2
    //s value=$p(InString,"^",iLLoop)
    s value=$p(InString,"^",iLLoop)
    s PLIST(2)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_Name	姓名 3
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(3)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_Sex_DR	性别 4
    s value=$p(InString,"^",iLLoop)
    i ""'=value d
    .// CT_Sex
    .s value=$ZCVT(value,"U")
    .s id=""
    .s id=$O(^CT("SEX",0,"Desc",value,id))
    .i ""'=id s value=id
    i ""'=value s PLIST(4)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_DOB	生日 5
	s value=$p(InString,"^",iLLoop)
	i (""'=value) s value=$ZDATEH(value,3)
	i ""'=value s PLIST(5)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_PatTypePIBI_DR	客人类型 6
	s value=$p(InString,"^",iLLoop)
	i ""'=value d
	.// CT_SocialStatus
	.s value=$ZCVT(value,"U")
	.s id=""
	.s id=$O(^CT("SS",0,"Desc",value,id))
    .i ""'=id s value=id
    i ""'=value s PLIST(6)=value
	s iLLoop=iLLoop+1
		
	//	PIBI_Tel1	电话号码1 7
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(7)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_Tel2	电话号码2 8
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(8)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_MobilePhone	移动电话 9
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(9)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_IDCard	身份证号 10
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(10)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_Vocation	职业 11
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(12)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_Position	职位 12
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(12)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_Company	公司 13
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(13)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_Postalcode	邮编 14
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(14)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_Address	联系地址 15
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(15)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_Nation	民族 16
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(16)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_Email	电子邮件 17
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(17)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_Married	婚姻状况 18 
    s value=$p(InString,"^",iLLoop)
    i ""'=value d
    .// CT_Marital
    .s value=$ZCVT(value,"U")
    .s id=""
    .s id=$O(^CT("MAR",0,"Desc",value,id))
    .
    .i ""'=id s value=id
    i ""'=value s PLIST(18)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_Blood	血型 19 
    s value=$p(InString,"^",iLLoop)
    i ""'=value d
    .// PAC_BloodType
    .s value=$ZCVT(value,"U")
    .s id=""
    .s id=$O(^PAC("BLDT",0,"Desc",value,id))
    .i ""'=id s value=id
    i ""'=value s PLIST(19)=value
	s iLLoop=iLLoop+1
	
	//	PIBI_UpdateDate	日期 21
	//s UpdateDate=$p(InString,"^",iLLoop)
	s PLIST(20)=+$H
	s iLLoop=iLLoop+1
	
	//	PIBI_UpdateUser_DR	更新人 22
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(21)=value
	
	s ret=..IBPInsert()
	Q ret
}

/// 个人进本信息
/// 使用 PLIST 插入数据 要求设置PLIST
/// 可以使用 Vism 调用
ClassMethod IBPInsert()
{

	&sql(
		insert into DHC_PE_PreIBaseInfo values :PLIST()
	    )

	k PLIST
	s PLIST(1)=SQLCODE
	s PLIST(2)=""
	i "0"=PLIST(1) s PLIST(2)=%ROWID
	
	s P0=PLIST(1)
	s P1=PLIST(2)

	s PLIST=3
	Q PLIST(1)_"^"_PLIST(2)
}

/// 客户预约
/// d ##Class(web.DHCPE.IMPGroupBooking).ImportPreIADM()
ClassMethod ImportPreIADM(value)
{
	
	s ^xList("PreIADM")=value
	
	s InString=value
	k PLIST
	s iLLoop=1
	
	//PIADM_RowId 1
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(1)=value
	s iLLoop=iLLoop+1
	
	//预登记个人基本信息号 PIADM_PIBIDR	2
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(2)=value
	s iLLoop=iLLoop+1
	
	//对应团体的ADM PIADM_PGADMDR	3
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(17)=value
	s iLLoop=iLLoop+1
	
	//对应组ADM PIADM_PGTeamDR	4
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(18)=value
	s iLLoop=iLLoop+1
	
	//预约体检日期 PIADM_PEDate	5
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(19)=value
	s iLLoop=iLLoop+1
	
	//预约体检时间 PIADM_PETime	6
	s value=$p(InString,"^",iLLoop)
	i ""'=value s PLIST(20)=value
	s iLLoop=iLLoop+1
	
	//预约接待人员 PIADM_PEDeskClerk_DR	7
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(21)=value
	s iLLoop=iLLoop+1
	
	// PIADM_Status	8
    s value=$p(InString,"^",iLLoop)
    i ""'=value d
    .s PLIST(22)=value
	e  d
	.s PLIST(22)="PREREG"
	s iLLoop=iLLoop+1
	
	//视同收费 PIADM_AsCharged	9
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(23)=value
	s iLLoop=iLLoop+1
	
	//应收金额 PIADM_AccountAmount	10
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(24)=value
	s iLLoop=iLLoop+1
	
	//打折后金额 PIADM_DiscountedAmount	11
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(25)=value
	s iLLoop=iLLoop+1
	
	//最终金额 PIADM_FactAmount	12
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(26)=value
	s iLLoop=iLLoop+1

	//审核人 PIADM_AuditUserDR	13
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(27)=value
	s iLLoop=iLLoop+1
	
	//审核日期 PIADM_AuditDate	14
	s value=$p(InString,"^",iLLoop)
	i ""'=value s PLIST(28)=value
	s iLLoop=iLLoop+1

	// PIADM_UpdateUserDR		15
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(29)=value
	s iLLoop=iLLoop+1

	// PIADM_UpdateDate			16
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(30)=value
	s iLLoop=iLLoop+1	
	
	//销售金额	PIADM_SaleAmount 17
    s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(30)=value
	s iLLoop=iLLoop+1	
	
	&SQL(select PIADM_RowId into :RowId
		from DHC_PE_PreIADM
		where PIADM_PIBI_DR=:PLIST(2) 
		and PIADM_PGADM_DR=:PLIST(17) 
		and PIADM_PGTeam_DR=:PLIST(18)
	)
	i "0"=SQLCODE d 
	.k PLIST,P0,P1,P2
	.s P0="Err 01" //
	.s PLIST(1)="Err 01"
	.s P1=RowId
	.s PLIST(2)=RowId
	.s PLIST=2
	Q:("0"=SQLCODE)	
	
	&sql(
		insert into DHC_PE_PreIADM values :PLIST()
	)
	
	k PLIST,P0,P1,P2
	s PLIST(1)=SQLCODE
	s P0=SQLCODE
	i ""'=SQLCODE d
	.s PLIST(2)=%ROWID
	.s P1=%ROWID
	e  d
	.s PLIST(2)=""
	.s P1=""
	s PLIST=2
	Q
}

ClassMethod test()
{
	s Data="^885^测试站点^^"
	s Count=$l(Data,"^")
	//s $P(Data,"^",3)="aaaa"
	k PLIST
	f iLLoop=1:1:Count d
	.s PLIST(iLLoop)=$P(Data,"^",iLLoop)
	
	s ret=..test2()
	//k PLIST
	Q ret
}

ClassMethod test2()
{
	w "test2",!
	//w PLIST
	
	//&sql(
	//	insert into DHC_PE_Station values :PLIST()
	//    )
	
	//&sql(select * into :PLIST() from DHC_PE_Station
	//     where ST_RowId=8
	//     )
	
	//&sql(select * into :PLIST() from DHC_PE_PreGTeam
	//     where PGT_RowId="7||2"
	//     )
	
	//&sql(select * into :PLIST() from DHC_PE_PreIBaseInfo
	//     where PIBI_RowId="10"
	//     )
	
	//&sql(select * into :PLIST() from DHC_PE_PreGADM
	//     where PGADM_RowId="8"
	//     )
	//&sql(select * into :PLIST() from DHC_PE_PreGADM
	//     where PGADM_RowId="8"
	//     )	
	//s Desc="tes1t"
	//s ParRef="7"
	//&sql(select PGT_RowId into :RowId from DHC_PE_PreGTeam
	//     where PGT_Desc=:Desc and PGT_ParRef=:ParRef
	//     )
	
	//i "0"=SQLCODE w RowId
	
	&sql(select * into :PLIST() from DHC_PE_PreIADM
	     where PIADM_RowId='10'
	     )
	w "SQLCODE:"_SQLCODE,!  
	
	// w "aaa"_SQLCODE_"^"_%ROWID	
	Q
}

ClassMethod GetOEOrdItem(AdmId)
{
	// OE_Order.{OEORD_RowId}
	s OEORDRowId=0 
	s OEORDRowId=$O(^OEORD(0,"Adm",AdmId,OEORDRowId))
	Q:(""=OEORDRowId) ""
	w "ZN:"_$ZN_"  $J:"_$j,!
	
	Kill ^TMP($ZN,$j)
	
	// OE_OrdItem	医嘱项表
	s OEORIChildsub=0
	s ret=""
	s iLLoop=1

	// 		0				1				2			3	
	s Flag="STation"_"^"_"DietSesc"_"^"_"LabNo"_"^"_"ARCIMDesc"
	
	f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
	.s OEORIRowId=OEORDRowId_"||"_OEORIChildsub
	.
	.// OE_OrdItem.{OEORI_ItemStat_DR}(OEC_OrderStatus)
	.s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	.Q:(1'=OEORIItemStatDR)		// 是否有效医嘱
	.
	.// OE_OrdItem.{OEORI_LabEpisodeNo}
	.s OEORILabEpisodeNo=+$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",20)
	.
	.// ARC_ItmMast.{ARCIM_Desc} 项目名称
	.s OEORIItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	.s ARCIMSubscript=$P(OEORIItmMastDR,"||",1)
	.s ARCIMVersion=$P(OEORIItmMastDR,"||",2)
	.s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	.
	.
	.// 站点信息
	.s STInfor=..FromARCIMToStation(OEORIItmMastDR)
	.Q:(""=STInfor)
	.s STID=$P(STInfor,"^",1)
	.s STDesc=$P(STInfor,"^",2)
	.s Diet=$P(STInfor,"^",3)
	.s ^TMP($ZN,$j,STID,OEORILabEpisodeNo,OEORIItmMastDR)=STDesc_"^"_ARCIMDesc_"^"_Diet_"^"_OEORILabEpisodeNo
	
	// 整理数据(排序)
	s ret=""
	
	// 站点排序
	s STLoop="0"
	f  s STLoop=$O(^TMP($ZN,$j,STLoop)) Q:(""=STLoop)  d
	.// 标本号排序
	.s LabNo=""
	.s STDesc=""
	.f  s LabNo=$O(^TMP($ZN,$j,STLoop,LabNo)) Q:(""=LabNo)  d
	..s ARCIMID="0"
	..f  s ARCIMID=$O(^TMP($ZN,$j,STLoop,LabNo,ARCIMID)) Q:(""=ARCIMID)  d
	...s CurData=$G(^TMP($ZN,$j,STLoop,LabNo,ARCIMID))
	...i ""'=STDesc s $P(CurData,"^",1)=""
	...i ""=STDesc s STDesc=$P(CurData,"^",1)
	...
	...s ret=ret_CurData_";"
	...w CurData,!
	
	Q ret
}

ClassMethod FromARCIMToStation(ARICM)
{
	&sql(
		select STORD_ParRef->ST_RowId,STORD_ParRef->ST_Desc,STORD_Diet into :STRowId, :STation,:STORDDiet 
		from DHC_PE_StationOrder 
		where STORD_ARCIM_DR=:ARICM
		)
	Q:("0"'=SQLCODE) ""
	
	s DietSesc=""
	i ("Preprandial"=STORDDiet)||("PRE"=STORDDiet) s DietSesc="空腹项目"
	i ("Postprandial"=STORDDiet)||("POST"=STORDDiet) s DietSesc="餐后项目"
	
	Q STRowId_"^"_STation_"^"_DietSesc
}

/// 存储团体信息
/// d SaveGBaseInfor^DHCPEIMPGInfor(P0)
ClassMethod ImportGBaseInor(value)
{
	k PLIST
	
	s Data=value
	s iLLoop=1
 	//单位编码	PGBI_Code	1
	s Code=$p(Data,"^",iLLoop)
	s iLLoop=iLLoop+1
	
	
 	//描    述	PGBI_Desc	2
	s Desc=$p(Data,"^",iLLoop)
	s iLLoop=iLLoop+1

 	//地    址	PGBI_Address	3
	s Address=$p(Data,"^",iLLoop)
	s iLLoop=iLLoop+1
	
 	//邮政编码	PGBI_Postalcode	4
	s Postalcode=$p(Data,"^",iLLoop)
	s iLLoop=iLLoop+1
	
 	//联系人	PGBI_Linkman	5
	s Linkman=$p(Data,"^",iLLoop)
	s iLLoop=iLLoop+1
	
 	//业务银行	PGBI_Bank	6
	s Bank=$p(Data,"^",iLLoop)
	s iLLoop=iLLoop+1
	
 	//帐    号	PGBI_Account	7
	s Account=$p(Data,"^",iLLoop)
	s iLLoop=iLLoop+1
	
 	//联系电话1	PGBI_Tel1	8
	s Tel1=$p(Data,"^",iLLoop)
	s iLLoop=iLLoop+1
	
 	//联系电话2	PGBI_Tel2	9
	s Tel2=$p(Data,"^",iLLoop)
	s iLLoop=iLLoop+1
	
 	//电子邮件	PGBI_Email	10
	s Email=$p(Data,"^",iLLoop)
	s iLLoop=iLLoop+1
	
	//						11
	//s RowId=$p(Data,"^",iLLoop)
	
	s RowId=""
	
	s InString=Code_"^"_Desc_"^"_Address_"^"_Postalcode_"^"_Linkman_"^"_Bank_"^"_Account_"^"_Tel1_"^"_Tel2_"^"_Email_"^"_RowId
	
	//q PLIST	
	s ret=##class(web.DHCPE.PreGBaseInfo).Save("","",InString)
	
	i "0"=ret d
	.s id=""
	.s id=$O(^DHCPEPreGBI(0,"Code",Code,id))
	e  d
	.s id=""
	
	s PLIST(1)=ret_"^"_id
	s PLIST=1
	q PLIST
}

}
