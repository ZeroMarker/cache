Import SQLUser

Class web.DHCEMExecBtnSet Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetExecBtnSetList(page = 1, rows = 10, hospDrID = "")
{
	n (page,rows,hospDrID)
	s Start=(page-1)*rows+1
    s End=page*rows
    s Count=0
    s DataStr = "EBSRowID^EBSNurSheetCode^EBSShowBtn^EBSActiveFlag^EBSHospDr^EBSHosp"
    w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	s EBSRowID=0
	f  s EBSRowID=$o(^DHCEMEBS(EBSRowID)) q:EBSRowID=""  d
	.s EBSNurSheetCode=$p(^DHCEMEBS(EBSRowID),"^",1)
	.s EBSShowBtn=$p(^DHCEMEBS(EBSRowID),"^",2)
	.s EBSActiveFlag=$p(^DHCEMEBS(EBSRowID),"^",3)
	.s EBSHospDr=$p(^DHCEMEBS(EBSRowID),"^",4)
	.q:(hospDrID'="")&(hospDrID'=EBSHospDr) //hxy 2019-07-18
	.s EBSHosp=""
	.s:EBSHospDr'="" EBSHosp = $p(^CT("HOSP",EBSHospDr),"^",2)
	.s DataList = EBSRowID_"^"_EBSNurSheetCode_"^"_EBSShowBtn_"^"_EBSActiveFlag_"^"_EBSHospDr_"^"_EBSHosp
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
    .w $case(Count,Start:"",:",") 
	.w ##class(web.DHCAPPJsonCommon).getJsonData(DataStr,DataList)	
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)
	q ""
}

/// Script:修改或者增加数据
/// w ##class(web.DHCEMExecBtnSet).SaveExecBtnSet(1,10)
ClassMethod Save(params)
{
	n (params) 
	s $Zt="Err"
  	TStart
  	s Ret=0
  	s Len=$l(params,"$$")
  	for i=1:1:Len d
  	.q:Ret<0
  	.s Str=$p(params,"$$",i)
  	.s Ret=..SaveOrUpdate(Str)
	i Ret<0 TRollback
	TCOMMIT
	q Ret
Err
	TRollback
	q -1
}

/// Creator：      qiaoqingao
/// CreatDate：    2017-03-01
/// Description:   保存或者新增 医生更新病人分级原因表
/// Table：        DHC_EmLevKey
/// Input：	       
/// Return：  w ##class(web.DHCEMExecBtnSet).SaveOrUpdate("^SYDO^执行并打印^Y^2^0 ")     
ClassMethod SaveOrUpdate(Str)
{
	n (Str)

	s EBSRowID = $p(Str,"^",1)
	s EBSNurSheetCode = $p(Str,"^",2)
	s EBSShowBtn = $p(Str,"^",3)
	s EBSActiveFlag = $p(Str,"^",4)
	s EBSHospDr = $p(Str,"^",6)
	
	s HasFlag=0
	s HasEBSRowID=""
	f  s HasEBSRowID = $o(^DHCEMEBS(0,"IndexCode",EBSNurSheetCode,HasEBSRowID)) q:(HasEBSRowID="")||(HasFlag'=0)  d
	.s HasEBSHospID = ""
	.s:HasEBSRowID'="" HasEBSHospID = $p(^DHCEMEBS(HasEBSRowID),"^",4)
	.;s:(HasEBSRowID'="")&&(HasEBSRowID'=EBSRowID)&&(HasEBSHospID=EBSHospDr) HasFlag=1 //hxy 2023-02-01注释 私有数据医院组间代码不能重复 st
	.s:(HasEBSRowID'="")&&(HasEBSRowID'=EBSRowID) HasFlag=1 //ed
	q:HasFlag=1 HasFlag
	
	s Ret=0
	i EBSRowID="" d
	.&sql(INSERT INTO DHC_EmExecBtnSet( EBS_NurSheetCode,EBS_ShowBtn,EBS_ActiveFlag,EBS_Hosp_Dr) VALUES 
		(:EBSNurSheetCode,:EBSShowBtn,:EBSActiveFlag,:EBSHospDr))
	.s Ret = SQLCODE
	
	i EBSRowID'="" d
	.&sql(UPDATE DHC_EmExecBtnSet SET EBS_NurSheetCode=:EBSNurSheetCode,EBS_ShowBtn=:EBSShowBtn,EBS_ActiveFlag=:EBSActiveFlag,
		EBS_Hosp_Dr=:EBSHospDr WHERE EBS_RowID =:EBSRowID
	)
	.s Ret = SQLCODE
	q Ret
}

ClassMethod Delete(Id)
{
	n (Id)
	&sql(DELETE DHC_EmExecBtnSet WHERE EBS_RowID=:Id)
	q SQLCODE
}

/// w ##class(web.DHCEMExecBtnSet).GetBtns("3") 
ClassMethod GetBtns(InHospID)
{
	n (InHospID)
	
	s InHospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmExecBtnSet",InHospID)
	
	s Del="""",Count=0
	w "{"
	s EBSNurSheetCode=""
	f  s EBSNurSheetCode =$o(^DHCEMEBS(0,"IndexCode",EBSNurSheetCode)) q:EBSNurSheetCode=""  d
	.
	.s EBSRowID =0
	.f  s EBSRowID =$o(^DHCEMEBS(0,"IndexCode",EBSNurSheetCode,EBSRowID)) q:EBSRowID=""  d
	..s Active = $p(^DHCEMEBS(EBSRowID),"^",3)
	..q:Active'="Y"
	..s HospID = $p(^DHCEMEBS(EBSRowID),"^",4)
	..q:(InHospID'="")&&(HospID'=InHospID)
	..s ExecBtns = $p(^DHCEMEBS(EBSRowID),"^",2)
	..s Count=Count+1
	..w $case(Count,1:"",:",")
	..w Del_EBSNurSheetCode_Del_":"_Del_ExecBtns_Del
	w "}"
	q ""
}

}
