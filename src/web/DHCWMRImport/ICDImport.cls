Import SQLUser

/// 名称: 	     web.DHCWMRImport.ICDImport
/// 描述: 	     ICD数据导入程序
/// 编写者：	 刘学峰
/// 编写日期:    2009-02-24
Class web.DHCWMRImport.ICDImport Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    刘学峰
/// CreatDate：  2009-02-24
/// Description：导入ICD编码、建立索引方法
/// Table：      DHC_WMR_ICDDx、DHC_WMR_ICDAlias
/// Input：      无
/// Output：     
/// Execute:	 w ##class(web.DHCWMRImport.ICDImport).ImportICD()
/// Resume:
///     DHC_WMR_ICDDx表字段：Rowid^ICD^ICD1^Name^Verion^ResumeText^IsActive
///     DHC_WMR_ICDAlias表字段：Rowid^ICDDxDr^Alias
///     Excel文档数据格式如下：
///      1	    2		  3		 4		 5		   6		 7
///     ICD	   ICD1  	名称	版本	备注	IsActive	拼音
ClassMethod ImportICD()
{
	s i=0  						;记录一共导入的数据数
	s index=0
	f  s index=$o(^DHCWMRTempICD(7,"ICD",index)) q:index=""  d
	.s tempICDStr=$g(^DHCWMRTempICD(7,"ICD",index))
	.s ICD=$p(tempICDStr,"^",1)
	.s ICD1=$p(tempICDStr,"^",2)
	.s Name=$p(tempICDStr,"^",3)
	.s Verion=$p(tempICDStr,"^",4)
	.s ResumeText=$p(tempICDStr,"^",5)
	.s IsActive=$p(tempICDStr,"^",6)
	.s PinYin=$p(tempICDStr,"^",7)
	.s ICDIndex=$tr(ICD,".","") ;去掉ICD中的".",作为索引,插入到DHC_WMR_ICDAlias表中
	.Tstart
	.;ICD数据。写入DHC_WMR_ICDDx表
	.s ICDString="^"_ICD_"^"_ICD1_"^"_Name_"^"_Verion_"^"_ResumeText_"^"_IsActive
	.s ICDRowID=##class(web.DHCWMRICDCtl).UpdateICDDx(ICDString)
	.i ICDRowID<0 TRollBack
	.s:ICDRowID<0 ^DHCWMRTempICD("ICD","NotImported",index,1)=tempICDStr
	.q:ICDRowID<0
	.;索引一：ICD编码。写入DHC_WMR_ICDAlias表
	.s ICDAliasStr1="^"_ICDRowID_"^"_ICDIndex
	.s flg=##class(web.DHCWMRICDCtl).UpdateICDAlias(ICDAliasStr1)
	.i flg<0 TRollBack
	.s:flg<0 ^DHCWMRTempICD("ICD","NotImported",index,2)=tempICDStr
	.q:flg<0
	.;索引一：拼音。写入DHC_WMR_ICDAlias表
	.s ICDAliasStr2="^"_ICDRowID_"^"_PinYin
	.s flg=##class(web.DHCWMRICDCtl).UpdateICDAlias(ICDAliasStr2)
	.i flg<0 TRollBack
	.s:flg<0 ^DHCWMRTempICD("ICD","NotImported",index,3)=tempICDStr
	.q:flg<0
	.TCommit
	.s i=i+1
	.w !,"第"_i_"条数据导入!"
	s ^DHCWMRTempICD("ICD","Imported")=i
	w !
    q "ICD Import Success!"
}

}
