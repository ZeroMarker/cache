Import SQLUser

/// Creator :qiaoqingao
/// CrratDate:2017-03-10
Class web.DHCEMDocUpReason Extends %Persistent [ Not ProcedureBlock ]
{

/// Script:获取字典表数据，返回json
/// w ##class(web.DHCEMDocUpReason).ListDocUpReason(1,10)
ClassMethod ListDocUpReason(page = 1, rows = 10, HospDr)
{
	n (page,rows,HospDr)
	s start=(page-1)*rows+1
    s end=page*rows
    s count=0
    s jsonObj=##class(web.DHCAPPJsonObject).%New()
    w "{""rows"":["
	s DurId="0"
	f  s DurId = $o(^DHCEMDUR(DurId)) q:DurId=""  d
	.s DurCode= $p(^DHCEMDUR(DurId),"^",1)
	.s DurDesc= $p(^DHCEMDUR(DurId),"^",2)
	.s DurHospDr= $p(^DHCEMDUR(DurId),"^",3)
	.s:DurHospDr'="" DurHospDesc = $p(^CT("HOSP",DurHospDr),"^",2)
	.s DurActive= $p(^DHCEMDUR(DurId),"^",4)
	.s Type= $p(^DHCEMDUR(DurId),"^",5)   /// 类型
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmDocUpdReason",DurId,HospDr)'="Y" //hxy 2020-05-14
	.s tmp = DurCode_"^"_DurDesc_"^"_DurHospDr_"^"_DurHospDesc_"^"_DurActive_"^"_DurId_"^"_Type_"^"_HospDr //hxy 2020-05-14 HospDr
	.s count=count+1
	.q:count<start
	.q:count>end
    .w $case(count,start:"",:",") 
	.w ##class(web.DHCAPPJsonCommon).getJsonData("DurCode^DurDesc^DurHospDr^DurHospDesc^DurActive^DurId^Type^HospDr",tmp) //hxy 2020-05-14 HospDr
	w "],""total"":"_count_"}"
	q ""
}

/// Script:修改或者增加数据
/// w ##class(web.DHCEMDocUpReason).SaveDocUpReason("01^病情恶化1^N^东华标准版数字化医院[总院]^2^7^Doc^2")
ClassMethod SaveDocUpReason(params)
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

/// Creator：      qiaoqingao
/// CreatDate：    2017-03-01
/// Description:   保存或者新增 医生更新病人分级原因表
/// Table：        DHC_EmLevKey
/// Input：	       
/// Return：       
ClassMethod SaveOrUpdate(str)
{
  		 s DurCode=$p(str,"^",1)
		 s DurDesc=$p(str,"^",2)
		 s DurActiveFlag=$p(str,"^",3)
		 s DurHospDr=$p(str,"^",4)
		 S DurHospID = $p(str,"^",5)
		 s ID=$p(str,"^",6)
		 s Type=$p(str,"^",7)
		 s HospDr=$p(str,"^",8) //hxy 2020-05-14

		 i +ID=0 
		 {
			 s obj=##class(User.DHCEmDocUpdReason).%New()
			 s obj.DURHospDr=##class(User.CTHospital).%OpenId(DurHospDr,0)
			 Q:$d(^DHCEMDUR(0,"Code",DurCode)) 1 //hxy 2020-05-14 注释 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
			 ;Q:..CheckExist(DurCode,HospDr) 1 //hxy 2020-05-14 //2023-01-18 注释
			 
		 }else{
			 s obj=##class(User.DHCEmDocUpdReason).%OpenId(ID)
			 i +DurHospDr=0 d
			 .s obj.DURHospDr=##class(User.CTHospital).%OpenId(DurHospID,0)
			 e  d
			 .s obj.DURHospDr=##class(User.CTHospital).%OpenId(DurHospDr,0)
			 
			 s isIN=0
			 i $d(^DHCEMDUR(0,"Code",DurCode)) d
			 .s DurID=$O(^DHCEMDUR(0,"Code",DurCode,""))
			 .q:DurID=ID
			 .s isIN=1
			 q:isIN=1 1 //hxy 2020-05-14 注释 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
			 ;s PHIDUP=..CheckExist(DurCode,HospDr) //hxy 2020-05-14 st //2023-01-18 注释
			 ;Q:(PHIDUP'=0)&(ID'=PHIDUP) 1 //ed
			 }

		 s obj.DURCode=DurCode
		 s obj.DURDesc=DurDesc
		 s obj.DURActiveFlag=DurActiveFlag
		 s obj.DURType=Type
	 	 s sc=obj.%Save()   
	 	 
	 	 d obj.%Close() //hxy 2020-05-14 st
	     s ret=""
	     s:+ID=0 ret=##Class(web.DHCEMCommonUtil).SaveHOSP("DHC_EmDocUpdReason",obj.%Id(),HospDr)
         q:ret<0 ret //ed
	 	 
		 q 0
}

/// Creator：      qiaoqingao
/// CreatDate：    2017-03-10
/// Description:： 删除医生更新病人分级原因表
/// Table：        DHC_EmDocUpdReason
/// Input：	      	Id：rowid
/// /Return：      操作成功 0，其他 失败
ClassMethod RemoveDocUpdReason(Id)
{
  
	q:+Id=0 -1
	s $Zt="Erro" //hxy 2020-05-14 加事务和删除关联表 st
  	TStart
  	s obj=##class(User.DHCEmDocUpdReason).%DeleteId(Id)
	s ret=##class(web.DHCEMCommonUtil).DeleteHospitals("DHC_EmDocUpdReason",Id) 
	q:ret<0 ret
	i ret<0 TRollback
	TCOMMIT
Erro
	TRollback
	;s obj=##class(User.DHCEmDocUpdReason).%DeleteId(Id) //ed
	q 0
}

/// Creator：      qiaoqingao
/// CreatDate：    2017-03-10
/// Description:： 医生更新病人分级原因Combobox
/// Table：        DHC_EmDocUpdReason
/// Input：	      	
/// Return：      json数据
/// w ##class(web.DHCEMDocUpReason).JsonComboDocUpdReason()
ClassMethod JsonComboDocUpdReason(hopDr, Type As %String) As %String
{
	n (hopDr,Type,%session)
  	s count= 0
  	w "["
  	s DurId="0"
	f  s DurId = $o(^DHCEMDUR(DurId)) q:DurId=""  d
	.s DurDesc= $p(^DHCEMDUR(DurId),"^",2)
	.s HospID= $p(^DHCEMDUR(DurId),"^",3)
	.Q:$p(^DHCEMDUR(DurId),"^",4)'="Y"
	.;q:(hopDr'="")&&(hopDr'=HospID) //hxy 2019-12-25 云his公有，不区分医院
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmDocUpdReason",DurId,hopDr)'="Y" //hxy 2020-05-27
	.Q:(Type'="")&(Type'=$p(^DHCEMDUR(DurId),"^",5))
	.s DurDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmDocUpdReason","DURDesc","",DurDesc)
	.s tmp = DurId_"^"_DurDesc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Creator：      bianshuai
/// CreatDate：    2018-05-31
/// Description:： 下拉列表显示Doc/Nur
/// d ##class(web.DHCEMDocUpReason).JsonGetReaType()
ClassMethod JsonGetReaType()
{
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s listObj=##class(%ListOfObjects).%New()
	d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Doc").Put("text","Doc"))
	d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Nur").Put("text","Nur"))
	w jsonObj.ListToJson(listObj)	
	q ""
}

/// d ##class(web.DHCEMPatHistory).CheckExist("03","2")
ClassMethod CheckExist(PHCode, HospDr)
{
	s Ret=0
	s RowID=0
	f  s RowID=$o(^DHCEMDUR(0,"Code",PHCode,RowID)) q:RowID=""  d
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmDocUpdReason",RowID,HospDr)'="Y"
	.s Ret=RowID
	q Ret
}

Storage Default
{
<Data name="DHCEMDocUpReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMDocUpReasonD</DataLocation>
<DefaultData>DHCEMDocUpReasonDefaultData</DefaultData>
<IdLocation>^web.DHCEMDocUpReasonD</IdLocation>
<IndexLocation>^web.DHCEMDocUpReasonI</IndexLocation>
<StreamLocation>^web.DHCEMDocUpReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
