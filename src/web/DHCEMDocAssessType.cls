Import SQLUser

/// Creator :qiaoqingao
/// CrratDate:2017-03-10
Class web.DHCEMDocAssessType Extends %Persistent [ Not ProcedureBlock ]
{

/// 医生评估护士分级
/// Script:获取字典表数据，返回json
/// w ##class(web.DHCEMDocAssessType).ListDocAssessType(1,10)
ClassMethod ListDocAssessType(page = 1, rows = 10, HospDr)
{
	n (page,rows,HospDr)
	s start=(page-1)*rows+1
    s end=page*rows
    s count=0
    s jsonObj=##class(web.DHCAPPJsonObject).%New()
    w "{""rows"":["
	s DatId="0"
	f  s DatId = $o(^DHCEMDAT(DatId)) q:DatId=""  d
	.s DatCode= $p(^DHCEMDAT(DatId),"^",1)
	.s DatDesc= $p(^DHCEMDAT(DatId),"^",2)
	.s DatHospDr= $p(^DHCEMDAT(DatId),"^",3)
	.s:DatHospDr'="" DatHospDesc = $p(^CT("HOSP",DatHospDr),"^",2)
	.s DatActive= $p(^DHCEMDAT(DatId),"^",4)
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmDocAssessType",DatId,HospDr)'="Y" //hxy 2020-05-14
	.s tmp = DatCode_"^"_DatDesc_"^"_DatHospDr_"^"_DatHospDesc_"^"_DatActive_"^"_DatId_"^"_HospDr //hxy 2020-05-14 HospDr
	.s count=count+1
	.q:count<start
	.q:count>end
    .w $case(count,start:"",:",") 
	.w ##class(web.DHCAPPJsonCommon).getJsonData("DatCode^DatDesc^DatHospDr^DatHospDesc^DatActive^DatId^HospDr",tmp) //hxy 2020-05-14 HospDr
	w "],""total"":"_count_"}"
	q ""
}

/// Script:修改或者增加数据
/// w ##class(web.DHCEMDocAssessType).SaveDocAssessType(1,10)
ClassMethod SaveDocAssessType(params)
{
  	n (params)
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..SaveOrUpdate(str)
	i ret<0 TRollback
	q:ret="-1^没有开启医院级授权" "-11" //hxy 2020-05-24
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Creator：      qiaoqingao
/// CreatDate：    2017-03-01
/// Description:   保存或者新增 医生评估护士分级表
/// Table：        DHC_EmLevKey
/// Input：	       
/// Return：       
ClassMethod SaveOrUpdate(str)
{
  		 s DatCode=$p(str,"^",1)
		 s DatDesc=$p(str,"^",2)
		 s DatActiveFlag=$p(str,"^",3)
		 s DatHospDr=$p(str,"^",4)
		 S DatHospID = $p(str,"^",5)
		 s ID=$p(str,"^",6)
		 s HospDr=$p(str,"^",7) //hxy 2020-05-14

		 i +ID=0 
		 {
			 s obj=##class(User.DHCEmDocAssessType).%New()
			 s obj.DATHospDr=##class(User.CTHospital).%OpenId(DatHospDr,0)
			 /*s isIN=0
			 s datID=""
			 f  s datID=$o(^DHCEMDAT(0,"Code",DatCode,datID)) q:datID=""  d
			 .s hasHospID=$p(^DHCEMDAT(datID),"^",3)
			 .q:hasHospID'=DatHospDr
			 .s isIN=1
			 q:isIN=1 1*/ //hxy 2020-05-14 注释
			 ;Q:..CheckExist(DatCode,HospDr) 1 //hxy 2020-05-14 //2023-01-18 注释
			 Q:$d(^DHCEMDAT(0,"Code",DatCode)) 1 //hxy 2023-01-18 私有数据医院组间代码不能重复
		 }else{
			 s obj=##class(User.DHCEmDocAssessType).%OpenId(ID)
			 i +DatHospDr=0 d
			 .s obj.DATHospDr=##class(User.CTHospital).%OpenId(DatHospID,0)
			 e  d
			 .s obj.DATHospDr=##class(User.CTHospital).%OpenId(DatHospDr,0)
			 
			 /*s isIN=0
			 s datID=""
			 f  s datID=$o(^DHCEMDAT(0,"Code",DatCode,datID)) q:datID=""  d
			 .s hasHospID=$p(^DHCEMDAT(datID),"^",3)
			 .q:hasHospID'=DatHospDr
			 .q:datID=ID
			 .s isIN=1
			 q:isIN=1 1*/ //hxy 2020-05-14 注释
			 ;s PHIDUP=..CheckExist(DatCode,HospDr) //hxy 2020-05-14 st //2023-01-18 注释
			 ;Q:(PHIDUP'=0)&(ID'=PHIDUP) 1 //ed
			 s isIN=0
			 i $d(^DHCEMDAT(0,"Code",DatCode)) d
			 .s DurID=$O(^DHCEMDAT(0,"Code",DatCode,""))
			 .q:DurID=ID
			 .s isIN=1
			 q:isIN=1 1
		}

		 s obj.DATCode=DatCode
		 s obj.DATDesc=DatDesc
		 s obj.DATActiveFlag=DatActiveFlag
	 	 s sc=obj.%Save()   
	 	 
	 	 d obj.%Close() //hxy 2020-05-14 st
	     s ret=""
	     s:+ID=0 ret=##Class(web.DHCEMCommonUtil).SaveHOSP("DHC_EmDocAssessType",obj.%Id(),HospDr)
         q:ret<0 ret //ed
	 	 
		 q 0
}

/// Creator：      qiaoqingao
/// CreatDate：    2017-03-10
/// Description:： 删除医生评估护士分级表
/// Table：        DHC_EmDocUpdReason
/// Input：	      	Id：rowid
/// /Return：      操作成功 0，其他 失败
ClassMethod RemoveDocUpdReason(Id)
{
  
	q:+Id=0 -1
	s $Zt="Erro" //hxy 2020-05-14 加事务和删除关联表 st
  	TStart
  	s obj=##class(User.DHCEmDocAssessType).%DeleteId(Id)
	s ret=##class(web.DHCEMCommonUtil).DeleteHospitals("DHC_EmDocAssessType",Id) 
	q:ret<0 ret
	i ret<0 TRollback
	TCOMMIT
Erro
	TRollback
	;s obj=##class(User.DHCEmDocAssessType).%DeleteId(Id) //ed
	q 0
}

/// Creator：      qiaoqingao
/// CreatDate：    2017-03-10
/// Description:： 医生评估护士分级Combobox
/// Table：        DHC_EmDocUpdReason
/// Input：	      	
/// Return：      json数据
/// w ##class(web.DHCEMDocAssessType).JsonComboDocUpdReason()
ClassMethod JsonComboDocAssessType(hopDr)
{
	n (hopDr,%session)
  	s count= 0
  	w "["
  	s DatId="0"
	f  s DatId = $o(^DHCEMDAT(DatId)) q:DatId=""  d
	.s DatDesc= $p(^DHCEMDAT(DatId),"^",2)
	.s UseFlag= $p(^DHCEMDAT(DatId),"^",4)
	.s HospID = $p(^DHCEMDAT(DatId),"^",3)
	.;q:(hopDr'="")&&(hopDr'=HospID) //hxy 2019-12-25 云his公有，不区分医院
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmDocAssessType",DatId,hopDr)'="Y" //hxy 2020-05-27
	.q:UseFlag'="Y"
	.s DatDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmDocAssessType","DATDesc","",DatDesc)
	.s tmp = DatId_"^"_DatDesc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// d ##class(web.DHCEMPatHistory).CheckExist("01","2")
ClassMethod CheckExist(PHCode, HospDr)
{
	s ret=0
	s RowID=0
	f  s RowID=$o(^DHCEMDAT(0,"Code",PHCode,RowID)) q:RowID=""  d
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmDocAssessType",RowID,HospDr)'="Y"
	.s ret=RowID
	q ret
}

Storage Default
{
<Data name="DHCEMDocAssessTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMDocAssessTypeD</DataLocation>
<DefaultData>DHCEMDocAssessTypeDefaultData</DefaultData>
<IdLocation>^web.DHCEMDocAssessTypeD</IdLocation>
<IndexLocation>^web.DHCEMDocAssessTypeI</IndexLocation>
<StreamLocation>^web.DHCEMDocAssessTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
