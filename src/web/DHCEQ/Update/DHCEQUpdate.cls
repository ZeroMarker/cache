Import SQLUser

Class web.DHCEQ.Update.DHCEQUpdate Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQ.Update.DHCEQUpdate).PatchData("3.7.4","Mozy0010")
ClassMethod PatchData(Versions As %Library.String = "", BugIDs As %Library.String = "")
{
		n Err,PatchCount,Version,i
		set PatchCount=0
		set Err=""
		if (Versions'="")
		{
			s Len=$l(Versions,",")
			for i=1:1:Len
			{
				s Version=$p(Versions,",",i)
				i (Version="")
				{					
				}
				elseif (Version="3.7.4")
				{
					d ..Patch374(BugIDs)
					s PatchCount=PatchCount+1
				}
				elseif (Version="3.7.5")
				{
					d ..Patch375(BugIDs)
					s PatchCount=PatchCount+1
				}
				elseif (Version="3.7.7")
				{
					d ..Patch377(BugIDs)
					s PatchCount=PatchCount+1
				}
			}
		}
		q PatchCount_"^"_Err
}

ClassMethod Patch374(BugIDs As %Library.String = "")
{
		n Err,RowID,IDs
		s Err=""
		
		if (BugIDs="")||(BugIDs["Mozy0118")
		{
			;Mozy0118
			b "Mozy0118"
			&SQL(insert into DHC_EQCEmployeeType(ET_Code, ET_Desc ,ET_InvalidFlag) values ('03','驾驶员','N'))
			k ^DHCEQCCode("DHCEQCTypeEmployee")
			&SQL(insert into DHC_EQCCodeTable(CT_TableName,CT_TableDesc,CT_Type,CT_Hidden,CT_ReadOnly,CT_PreFix) values ('DHC_EQCCertificateType','证件类型',1,0,0,'CT'))
		}
	
		
		if (BugIDs="")||(BugIDs["Mozy0119")
		{
			;Mozy0119
			b "Mozy0119"
			&SQL(insert into DHC_EQCCounterType(CT_Desc,CT_TableName,CT_InvalidFlag) values ('派车单号','DHC_EQDispatchVehicle','N'))
			s RowID=$g(%ROWID)
			&SQL(insert into DHC_EQCCounter(CNT_CounterNum, CNT_TypeDR, CNT_Length,CNT_Prefix,CNT_GroupFlag,CNT_Group) values (1,:RowID,4,'[Date]','Y','[Year]'))
		
			&SQL(insert into DHC_EQCApproveType(AT_Code,AT_Desc,AT_InvalidFlag) values (24,'车辆派遣','N'))
			s RowID=$g(%ROWID)
			&SQL(insert into DHC_EQCApproveSet(AS_ApproveTypeDR,AS_Desc,AS_Code,AS_AutoAuditFlag) values (:RowID,'车辆派遣','CP01','Y'))
		}
		
		
		if (BugIDs="")||(BugIDs["MR0010")
		{
			;MR0010
			b "MR0010"
			&SQL(insert into DHC_EQCCounterType (CT_Desc,CT_TableName,CT_InvalidFlag) values('销毁更换单号','DHC_EQSwap','N'))
			s RowID=$g(%ROWID)
			&SQL(insert into DHC_EQCCounter (CNT_CounterNum,CNT_TypeDR,CNT_Length,CNT_Prefix,CNT_GroupFlag) values('0',:RowID,'6','[Date,6]','N'))
			
			&SQL(insert into DHC_EQCApproveType (AT_Code,AT_desc,AT_InvalidFlag)values('23','被服销毁','N'))
			
			s IDs="3"	//被服类组的ID串?
			&SQL(insert into dhc_eqcsysset (ss_code,ss_value,ss_desc,ss_remark,ss_hidden) values ('990024',:IDs,'属于被服资产类组ID串','添加类组的ID串，以","分割','N'))

		}
		
		
		if (BugIDs="")||(BugIDs["QW0001")
		{
			;QW0001
			b "QW0001"
			&SQL(insert into DHC_EQCCounterType (CT_Desc,CT_TableName,CT_InvalidFlag) values('被服洗涤单号','DHC_EQWash','N'))
			s RowID=$g(%ROWID)
			&SQL(insert into DHC_EQCCounter (CNT_CounterNum,CNT_TypeDR,CNT_Length,CNT_Prefix,CNT_GroupFlag) values(0,:RowID,'6','[Date]','N'))
			
			&SQL(insert into DHC_EQCApproveType (AT_Code,AT_desc,AT_InvalidFlag)values('22','被服洗涤','N'))
			
		}
		
		
		if (BugIDs="")||(BugIDs["HZY0045")
		{
			b "HZY0045"
			&SQL(insert into dhc_eqcbuildingstruct values('GJG','钢结构','','N'))
			&SQL(insert into dhc_eqcbuildingstruct values('GJHLTJG','钢筋混凝土结构','','N'))
			&SQL(insert into dhc_eqcbuildingstruct values('ZHJG','砖混结构','','N'))
			&SQL(insert into dhc_eqcbuildingstruct values('ZMJG','砖木结构','','N'))
		}
		
		if (BugIDs="")||(BugIDs["HZY0035")
		{
			b "HZY0035"
			;新增配件编号，'配件编号','DHC_EQCAccessory'
			&SQL(insert into  DHC_EQCCounterType(CT_Desc,CT_TableName,CT_InvalidFlag) values('配件编号','DHC_EQCAccessory','N'))
			s RowID=$g(%ROWID)
			&SQL(insert into  DHC_EQCCounter (CNT_CounterNum,CNT_TypeDR,CNT_Length,CNT_Prefix,CNT_GroupFlag) values('0',:RowID,'6','[Date,6]','N'))

			&SQL(insert into DHC_EQCCounterType set ct_desc='配件转移单号',ct_tablename='DHC_EQAMoveStock',ct_InvalidFlag='N')
			s RowID=$g(%ROWID)
			&SQL(insert into DHC_EQCCounter set cnt_counternum=0,cnt_typedr=:RowID,cnt_length=6,cnt_prefix='[Date,6]',cnt_groupflag='N')
			
			&SQL(insert into dhc_eqcconditionfields(cf_name,cf_tablename,cf_type) values('MoveType','DHCEQAMoveStock','1'))
  			;(上面SQL语句中的数字根据具体的情况而定。)

  			;在 DHC_EQCCounterType 表里插入配件退货单这条数据
			&SQL(insert into sqluser.DHC_EQCCounterType (CT_Desc,CT_TableName,CT_InvalidFlag) values ("配件退货单","DHC_EQAReduce","N"))
			s RowID=$g(%ROWID)
  			&SQL(insert into DHC_EQCCounter(CNT_CounterNum,CNT_TypeDR,CNT_Length,CNT_Prefix,CNT_GroupFlag) values('0',:RowID,"6","[Date,6]","N") )
  			
  			;在表DHC_EQCApproveType中插入配件退货的审批类型 
			&SQL(insert into DHC_EQCApproveType(AT_Code,AT_Desc,AT_InvalidFlag) values ("21","配件退货","N") ) 
			
			&SQL(Update DHC_EQCSysSet Set SS_Desc='月结报表开始日期' where SS_Code='901001')
			&SQL(Update DHC_EQCSysSet Set SS_Desc='月结报表结束日期' where SS_Code='901002')
		}
		
		q ""
}

ClassMethod Patch375(BugIDs As %Library.String = "")
{
		n Err,RowID,IDs
		s Err=""	
		
		if (BugIDs="")||(BugIDs["ZX0006")
		{
			b "ZX0006"			     
			&SQL(insert into DHC_EQCCounterType (CT_Desc,CT_TableName,CT_InvalidFlag) values('新维修单号','DHC_EQMMaintRequest','N'))
			s RowID=$g(%ROWID)
			&SQL(insert into DHC_EQCCounter(CNT_CounterNum, CNT_TypeDR, CNT_Length,CNT_Prefix,CNT_GroupFlag,CNT_Group) values (1,:RowID,4,'[Date]','Y','[Year]'))
			
			;在表DHC_EQCApproveType中插入资产维修的审批类型 
			&SQL(insert into DHC_EQCApproveType (AT_Code,AT_desc,AT_InvalidFlag)values('25','资产维修','N'))
		}
}

ClassMethod Patch377(BugIDs As %Library.String = "")
{
		n Err,RowID,IDs
		s Err=""	
		
		if (BugIDs="")||(BugIDs["DJ0123")
		{
			b "DJ0123"			     
			&SQL(insert into dhc_eqcuserdefined(ud_code,ud_desc,ud_shortcode,ud_invalidflag) values('DHCEQTrain','培训记录登记','F','N'))			
			s RowID=$g(%ROWID)
			&SQL(insert into dhc_eqcuserdefinedlist(udl_userdefineddr,udl_name,udl_desc,udl_filedtype,udl_hiddenflag,udl_invalidflag) values(:RowID,'F_TrainDate','培训日期',1,'N','N'))
			&SQL(insert into dhc_eqcuserdefinedlist(udl_userdefineddr,udl_name,udl_desc,udl_filedtype,udl_hiddenflag,udl_invalidflag) values(:RowID,'F_TrainAddress','培训地点',0,'N','N'))
			&SQL(insert into dhc_eqcuserdefinedlist(udl_userdefineddr,udl_name,udl_desc,udl_filedtype,udl_hiddenflag,udl_invalidflag) values(:RowID,'F_TrainUser','培训人',0,'N','N'))
			&SQL(insert into dhc_eqcuserdefinedlist(udl_userdefineddr,udl_name,udl_desc,udl_filedtype,udl_hiddenflag,udl_invalidflag) values(:RowID,'F_TrainTitle','培训主题',0,'N','N'))
			&SQL(insert into dhc_eqcuserdefinedlist(udl_userdefineddr,udl_name,udl_desc,udl_filedtype,udl_hiddenflag,udl_invalidflag) values(:RowID,'F_TrainContent','培训内容',0,'N','N'))
			&SQL(insert into dhc_eqcuserdefinedlist(udl_userdefineddr,udl_name,udl_desc,udl_filedtype,udl_hiddenflag,udl_invalidflag) values(:RowID,'F_Remark','备注',0,'N','N'))
			&SQL(insert into dhc_eqcuserdefinedlist(udl_userdefineddr,udl_name,udl_desc,udl_filedtype,udl_hiddenflag,udl_invalidflag) values(:RowID,'F_TrainEquip','培训设备',0,'N','N'))		
		}
		
		if (BugIDs="")||(BugIDs["ZY0114")
		{
			b "ZY0114"
			&SQL(insert into dhc_eqccodetable (ct_tablename,ct_tabledesc,ct_remark,ct_type,ct_hidden,ct_readonly,ct_prefix) select 'DHC_EQForCWJW','卫计委资产类别','',ct_type,ct_hidden,ct_readonly,'AT' from dhc_eqccodetable where ct_tablename='DHC_EQCOrigin')
			&SQL(insert into DHC_EQForCWJW (AT_Code,AT_Desc,AT_InvalidFlag) values ('01','医疗设备','N'))
			&SQL(insert into DHC_EQForCWJW (AT_Code,AT_Desc,AT_InvalidFlag) values ('02','房屋建筑','N'))
			&SQL(insert into DHC_EQForCWJW (AT_Code,AT_Desc,AT_InvalidFlag) values ('03','土地','N'))
			&SQL(insert into DHC_EQForCWJW (AT_Code,AT_Desc,AT_InvalidFlag) values ('04','其他','N'))
			&SQL(insert into DHC_EQForCWJW (AT_Code,AT_Desc,AT_InvalidFlag) values ('09','非卫计委统计类型','N'))
		}
}

}
