Import SQLUSER

Class web.DHCEMPatStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      lvpeng
/// CreatDate：    2016-08-01
/// Description:   保存或者新增  状态授权表
/// Table：        DHC_EmPatStatusAcc
/// Input：	       SYCode：代码
///                SYDesc：描述
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
         
  		 s PSAStatusDr=$p(str,"^",1)
  		 s PSAPointer=$p(str,"^",2)
  		 s PSAType=$p(str,"^",3)
		 s PSADesc=$p(str,"^",4)
		 s ID=$p(str,"^",5)
		 s HospDr=$p(str,"^",6) //hxy 2020-06-02
		 i PSAPointer=0 q 2
		 
		 i +ID=0 	//新的一行
		 {
			 s obj=##class(User.DHCEmPatStatusAcc).%New()
			 ;Q:$d(^DHCEMPSA(0,"Pointer",PSAPointer,PSAStatusDr)) 1 //hxy 2020-06-02 注释
			 Q:..CheckExist(PSAPointer,PSAStatusDr,HospDr) 1 //hxy 2020-06-02

			 s obj.PSAStatusDr=##class(User.DHCPACVisitStatus).%OpenId(PSAStatusDr) 
			 s obj.PSAHospDr=##class(User.CTHospital).%OpenId(HospDr) //hxy 2020-06-02
		 }else{		//双击编辑行
			 s obj=##class(User.DHCEmPatStatusAcc).%OpenId(ID)
			 
			 s isIN=0
			 i PSAPointer=0 q 2
			 i $d(^DHCEMPSA(0,"Pointer",PSAPointer)) d
			 .s isIN=1
			 q:isIN=1 2
			 }
			 
		 	 s obj.PSAType=PSAType
		 	 s obj.PSAPointer=PSAPointer
	    	 s sc=obj.%Save()   
			 ;i $$$ISERR(sc) q -2
			 q 0
}

ClassMethod SavePsaAcc(params)
{
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..SaveOrUpdate(str)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Creator：      lvpeng
/// CreatDate：    2016-08-01
/// Description：  分页显示病人状态表
/// Table：        DHC_PACVisitStatus
/// Input：	       page：当前页数
///                rows：每页条数
/// Return：       
/// d ##class(web.DHCEmPatStatus).ListPsa(,,"到","")
ClassMethod ListPsa(page = 1, rows = 10, Stdesc, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s PVSRowId=""
		f  s PVSRowId=$o(^DHCPACVisitStatus(PVSRowId)) q:PVSRowId=""  d
		.q:PVSRowId=0
		.s code=$p(^DHCPACVisitStatus(PVSRowId),"^",1)
		.s desc=$p(^DHCPACVisitStatus(PVSRowId),"^",2)
		.s proID=$p(^DHCPACVisitStatus(PVSRowId),"^",9)
		.s autoDis=$p(^DHCPACVisitStatus(PVSRowId),"^",10)
		.s Active=$p(^DHCPACVisitStatus(PVSRowId),"^",11)
		.s proDesc=""
		.s:proID'="" proDesc=$p(^DHCPACVisitStatus(proID),"^",2)
		.s tmp=PVSRowId_"^"_code_"^"_desc_"^"_proDesc_"^"_proID_"^"_autoDis_"^"_Active
		.q:(Stdesc'="")&(desc'[Stdesc)
		.q:(q'="")&(desc'[q)
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
	    .;w jsonObj.FromObject(##class(User.DHCEmSys).%OpenId(phId)).Json()
	    .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^PTCode^PTDesc^PTProCombo^PTProID^AutoDis^Active",tmp)
		.
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      lvpeng
/// CreatDate：    2016-08-01
/// Description：  分页显示状态授权表
/// Table：        DHC_EmPatStatusAcc
/// Input：	       page：当前页数
///                rows：每页条数
/// Return：       
/// d ##class(web.DHCEMPatStatus).ListPstAccItm(,,"","","1","")
ClassMethod ListPstAccItm(page = 1, rows = 10, PSAType, PSAPointer, PVId, HospDr, q)
{
   
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s PSARowId=""
		f  s PSARowId=$o(^DHCEMPSA(PSARowId)) quit:PSARowId=""  d 
		.q:+PSARowId=0
		.s PSAStatusDr=$p(^DHCEMPSA(PSARowId),"^",1)
		.q:PVId'=PSAStatusDr&PVId'=0
		.s type=$p(^DHCEMPSA(PSARowId),"^",2)
		.s pointer=$p(^DHCEMPSA(PSARowId),"^",3)
		.;q:(type="G")&(##class(web.DHCEMCommonUtil).GetHospShowDataFlag("SS_Group",pointer,HospDr)'="Y") //hxy 2020-05-26 //hxy 2020-06-02 st 
		.;q:(type="U")&(##class(web.DHCEMCommonUtil).GetHospShowDataFlag("SS_User",pointer,HospDr)'="Y") //hxy 2020-05-26
		.s CurHospDr=$p(^DHCEMPSA(PSARowId),"^",4) 
		.q:(CurHospDr'="")&(CurHospDr'=HospDr) //hxy ed
		.q:(PSAType'="")&(PSAType'=type)
		.q:(PSAPointer'="")&(PSAPointer'=pointer)
		.q:(q'="")&(pointer'[q)
		.s Id=PSARowId
		.s count=count+1
		.q:count<start
		.q:count>end
		.i type="G" d
		..s PointerDesc=$P(^SSU("SSGRP",pointer),"^",1)
		.i type="L" d
		..s PointerDesc=$P(^CTLOC(pointer),"^",1)
		.i type="U" d
		..s PointerDesc=$P(^SSU("SSUSR",pointer),"^",1)
		..s PointerDescTwo=$P(^SSU("SSUSR",pointer),"^",2)
		..s PointerDesc=PointerDescTwo_" ("_PointerDesc_")"
		.i type="D" d
		..s PointerDesc="DHC"
		.s tmp=Id_"^"_type_"^"_pointer_"^"_PointerDesc_"^"_PSAStatusDr
	    .w $case(count,start:"",:",")
	    .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^PSAType^PSAPointer^PointerDesc^PSAStatusDr",tmp)
	    .;w jsonObj.FromObject(##class(User.DHCEmSysItm).%OpenId(Id)).Json() 
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      lvpeng
/// CreatDate：    2016-08-01
/// Description：  下拉列表显示类型
/// Return
/// d ##class(web.DHCEmPatStatus).ListIsWhich()
ClassMethod ListIsWhich()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","G").Put("text","安全组"))
	  //d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","L").Put("text","科室"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","U").Put("text","人员"))
	  //d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","D").Put("text","全院"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Creator：      lvpeng
/// CreatDate：    2016-08-01
/// Description：  下拉列表显示	安全组
/// Table：        SS_Group
/// Return
/// d ##class(web.DHCEmPatStatus).ListGroup("L",1,10,"","")
ClassMethod ListGroup(type, page = 1, rows = 10, text, HospDr, q)
{
     
	 s start=(page-1)*rows+1
	 s end=page*rows
	 if (type="G")
	 {
		 w "{""rows"":["
		 s count=0
		 s pointer=0
	     f  s pointer=$o(^SSU("SSGRP",pointer)) q:pointer=""  d
	     .s PointerDesc=$P(^SSU("SSGRP",pointer),"^",1)
		 .s tmp=pointer_"^"_PointerDesc
		 .q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("SS_Group",pointer,HospDr)'="Y" //hxy 2020-05-26
	 	 .q:(text'="")&(text'=PointerDesc)
		 .q:(q'="")&(PointerDesc'[q)
		 .s data = ^SSU("SSGRP",pointer)
		 .s active=$p(data,"^",151)
		 .q:active'="Y"
		 .s count = count+1
		 .q:count<start
	 	 .q:count>end
	 	 .w $case(count,start:"",:",") 
	 	 .w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
		 w "],""total"":"_count_"}"
	 }elseif(type="U")
     {
	    s str=..ListUser(page , rows ,text,HospDr, q)	
	 }
	
	 q ""
}

/// Creator：      lvpeng
/// CreatDate：    2016-08-01
/// Description：  下拉列表显示 用户
/// Table：        SS_User
/// Return
/// d ##class(web.DHCEmPatStatus).ListUser(1,10,"","")
ClassMethod ListUser(page = 1, rows = 10, text, HospDr, q)
{
	 s start=(page-1)*rows+1
	 s end=page*rows
	 w "{""rows"":["
	 s count=0
	 s pointer=0
     f  s pointer=$o(^SSU("SSUSR",pointer)) q:pointer=""  d
     .s Code=$P(^SSU("SSUSR",pointer),"^",1)
	 .s Codename=$P(^SSU("SSUSR",pointer),"^",2)
	 .s Code=Codename_" ("_Code_")"
	 .s tmp=pointer_"^"_Code
	 .;q:##class(web.DHCEMCommonUtil).GetHospStrShowDataFlag("SS_User",pointer,hospStr)'="Y"
	 .q:##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlagSpecial("SS_User",pointer,HospDr,"","DHC_EmPatStatusAcc")'="Y"
	 .q:(text'="")&(text'=Code)
	 .q:(q'="")&(Code'[q)
	 .s Active=$p(^SSU("SSUSR",pointer),"^",19)
	 .q:Active'="Y"
	 .s StDate=$p(^SSU("SSUSR",pointer),"^",96)
	 .s EndDate=$p(^SSU("SSUSR",pointer),"^",97)
	 .q:(StDate'="")&&(+$h<StDate)
	 .q:(EndDate'="")&&(+$h>EndDate)
	 .s count = count+1
	 .q:count<start
 	 .q:count>end
 	 .w $case(count,start:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：      lvpeng
/// CreatDate：    2016-08-01
/// Description：  删除 状态授权表
/// Table：        DHC_EmSysItmAut
/// Input：	      Id：rowid
/// /Return：      操作成功 0，其他 失败
/// w ##class(web.DHCEmPatStatus).RemovePsaAcc()
ClassMethod RemovePsaAcc(Id)
{
	  q:+Id=0 -1
	  s obj=##class(User.DHCEmPatStatusAcc).%DeleteId(Id)
	  q 0
}

/// w ##class(web.DHCEMPatStatus).GetAccessStatJsonList("2^203^104^11841")
ClassMethod GetAccessStatJsonList(LgParams)
{

	s HospID=$p(LgParams,"^",1)
	s LocID=$p(LgParams,"^",2)
	s GroupID=$p(LgParams,"^",3)
	s UserID=$p(LgParams,"^",4)

	w "["
	s Count=0
	s ID=""
	f  s ID=$o(^DHCPACVisitStatus(ID)) q:ID=""  d
	.s Code=$p(^DHCPACVisitStatus(ID),"^",1)
	.s Desc=$p(^DHCPACVisitStatus(ID),"^",2)
	.s PACRowID=""
	.s IsHasQx=0
	.f  s PACRowID=$o(^DHCEMPSA(0,"IndexStatus",ID,PACRowID)) q:(PACRowID="")||(IsHasQx=1)  d
	..s Type=$p(^DHCEMPSA(PACRowID),"^",2)
	..s Point=$p(^DHCEMPSA(PACRowID),"^",3)
	..s HospDr=$p(^DHCEMPSA(PACRowID),"^",4) //hxy 2020-06-02 st
	..s RealHospDr=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmPatStatusAcc",HospID)
	..q:HospDr'=RealHospDr //ed
	..q:(Type="G")&&(GroupID'=Point)
	..q:(Type="U")&&(UserID'=Point)
	..s IsHasQx=1
	.q:IsHasQx'=1
	.s Desc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCPACVisitStatus","PVSDesc","",Desc) //hxy 2023-01-31
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ItmData = Code_"^"_Desc
	.w ##class(web.DHCEMJsonCommon).getJsonData("id^text",ItmData)
	w "]"
	q ""
}

/// w ##class(web.DHCEMPatStatus).GetAllAccessStatJsonList(")
ClassMethod GetAllAccessStatJsonList()
{
	w "["
	s Count=0
	s ID=""
	f  s ID=$o(^DHCPACVisitStatus(ID)) q:ID=""  d
	.s Desc=$p(^DHCPACVisitStatus(ID),"^",2)
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ItmData = ID_"^"_Desc
	.w ##class(web.DHCEMJsonCommon).getJsonData("id^text",ItmData)
	w "]"
	q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		mdt疑难病种分组维护表
/// w ##class(web.DHCMDTGroup).save("8^000003^测试000003^N^65")
ClassMethod save(mParam As %String) As %String
{

	s Err=0
	F i=1:1:$L(mParam,"$$") Q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.s Err=..isExist(mdata)   /// 重复性判断
	.Q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..insert(mdata)
	.e  d
	..s Err=..update(mdata)
	Q Err
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		检查代码、描述是否重复
/// w ##class(web.DHCMDTGroup).isExist("")
ClassMethod isExist(mParam As %String) As %String
{
	Q 0
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		增加
/// w ##class(web.DHCMDTGroup).insert("")
ClassMethod insert(mParam As %String) As %String
{
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ProID=$p(mParam,"^",4)    ///上一状态
	s AutoDis=$p(mParam,"^",5)    ///自动离院
	s Active=$p(mParam,"^",6)    ///是否可用
 	&SQL(INSERT INTO DHC_PACVisitStatus(PVS_Code, PVS_Desc, PVS_PreVisitStat_Dr,PVS_AutoDischarge,PVS_Active) VALUES(:Code,:Desc,:ProID,:AutoDis,:Active))
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		更新
/// w ##class(web.DHCMDTGroup).update("")
ClassMethod update(mParam As %String) As %String
{
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ProID=$p(mParam,"^",4)    ///上一状态
	s AutoDis=$p(mParam,"^",5)    ///自动离院
	s Active=$p(mParam,"^",6)    ///是否可用

	&SQL(Update DHC_PACVisitStatus Set PVS_Code=:Code, PVS_Desc=:Desc, PVS_PreVisitStat_Dr=:ProID,PVS_AutoDischarge=:AutoDis,PVS_Active=:Active WHERE PVS_RowId=:ID)
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		删除
/// w ##class(web.DHCMDTGroup).delete("1")
ClassMethod delete(ID As %String) As %String
{
	s ret=0
	ts
	
	&SQL(Delete From DHC_PACVisitStatus Where PVS_RowId=:ID)
	s ret=SQLCODE
	tro:ret'=0
	q:ret'=0 ret
	
	i $d(^DHCEMPSA(0,"IndexStatus",ID)) d
	.&SQL(DELETE DHC_EmPatStatusAcc WHERE PSA_Status_Dr=:ID)
	.s ret=SQLCODE
	tro:ret'=0
	q:ret'=0 ret
	
	tc
	Q ret
}

/// d ##class(web.DHCEMPatHistory).CheckExist("03","2")
ClassMethod CheckExist(Pointer, StatusDr, Hosp)
{
	s ret=0
	s RowID=0
	f  s RowID=$o(^DHCEMPSA(0,"Pointer",Pointer,StatusDr,RowID)) q:RowID=""  d
	.s CurHosp=$p(^DHCEMPSA(RowID),"^",4)
    .q:Hosp'=CurHosp
	.s ret=RowID
	q ret
}

}
