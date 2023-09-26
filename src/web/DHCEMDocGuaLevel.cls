/// 担保金额
Class web.DHCEMDocGuaLevel Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      zhouxin
/// CreatDate：    2018-07-06
/// Description:： 保存或者新增急诊担保金额
/// Table：        DHC_EmGuaLevel
/// Return：       {code:0,msg:msg}
ClassMethod saveOrUpdate(str)
{
 
 n (str)	
 s ID=$p(str,"^",1)
 s Min=$p(str,"^",2)
 s Max=$p(str,"^",3)
 s ActiveFlag=$p(str,"^",4)
 s HospDr=$p(str,"^",5)
 i ($a(HospDr)>57)||($a(HospDr)<48) d
 .s HospDr=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HospDr),""))
 
 i +ID=0 d
 .s obj=##class(User.DHCEmGuaLevel).%New()
 e  d
 .s obj=##class(User.DHCEmGuaLevel).%OpenId(ID)
 .d obj.%Reload()
 s obj.GLEActiveFlag=ActiveFlag
 s obj.GLEMax=Max
 s obj.GLEMin=Min
 d obj.GLEHospDrSetObjectId(HospDr)

 s sc=obj.%Save()
 s code=0
 i $SYSTEM.Status.IsError(sc) d
 .s code=$SYSTEM.Status.GetErrorCodes(sc)
 .s msg=$SYSTEM.Status.GetErrorText(sc)
 .i code="5808" d
 ..s:$f(msg,"GLEMinIndex")>0 msg="起始金额不唯一"
 ..s:$f(msg,"GLEMaxIndex")>0 msg="结束金额不唯一"
 .d ##class(web.DHCEMDocGuarantee).R(code,msg)
 q code
}

/// Creator：      zhouxin
/// CreatDate：    2018-07-06
/// Description:： 批量保存或者修改急诊担保金额
/// Table：        DHC_EmGuaLevel
/// Return：       {code:0,msg:msg}
ClassMethod save(params)
{
    n (params)
  	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret'=0
  	.s str=$p(params,"$$",i)
  	.s ret=..saveOrUpdate(str)
	i ret'=0 TRollback
	q:ret'=0 ""
	TCOMMIT
	d ##class(web.DHCEMDocGuarantee).R(0,0)
	q ""
Err
	TRollback
	d ##class(web.DHCEMDocGuarantee).R($Zc,$ze)
	q ""
}

/// Creator：      zhouxin
/// CreatDate：    2018-07-06
/// Description:： 急诊担保原因
/// Table：        DHC_EmGuaReason 
/// Others：       w ##class(web.DHCEMDocGuaLevel).ListGuaLevel("10","1","^呵呵")
ClassMethod ListGuaLevel(rows As %String, page As %String, hospDrID As %String) As %String
{
	n (rows,page,hospDrID)

	s end=page*rows
	s start=(page-1)*rows+1
	s titlestr="ID^GLEMin^GLEMax^GLEActiveFlag^GLEHospDr^GLEHospDesc"
	s count=0
	w "{""rows"":["
	s id=""
	f  s id=$o(^User.DHCEmGuaLevelD(id)) q:id=""  d
	.  
	.s levelMin=$LISTGET(^User.DHCEmGuaLevelD(id),2)
	.s levelMax=$LISTGET(^User.DHCEmGuaLevelD(id),3)
	.s:levelMin<1 levelMin="0."_$p(levelMin,".",2)
	.s activeFlag=$LISTGET(^User.DHCEmGuaLevelD(id),4)
	.s hospDr=+$LISTGET(^User.DHCEmGuaLevelD(id),5)
	.q:(hospDrID'="")&(hospDrID'=hospDr) //hxy 2019-07-20
	.s hospDesc=""
	.s:hospDr'=0 hospDesc=$p(^CT("HOSP",hospDr),"^",2)
	.s count = count+1
	.q:(count<start)||(count>end)
	.w $case(count,start:"",:",")
	.s tempstr=id_"^"_levelMin_"^"_levelMax_"^"_activeFlag_"^"_hospDr_"^"_hospDesc
	.w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,tempstr)
    w "],""total"":"_count_"}"
	q ""
}

/// Creator：      zhouxin
/// CreatDate：    2018-07-06
/// Description:： 删除急诊担保金额
/// Table：        DHC_EmGuaLevel
/// Return：       {code:0,msg:msg}
ClassMethod remove(ID) As %String
{
 
 n (ID)	
 s code=0,msg="success"
 d:+ID=0 ##class(web.DHCEMDocGuarantee).R(code,msg)
 q:+ID=0 ""
 
 s sc=##class(User.DHCEmGuaLevel).%DeleteId(ID)
 i $SYSTEM.Status.IsError(sc) d
 .s code=$SYSTEM.Status.GetErrorCodes(sc)
 .s msg=$SYSTEM.Status.GetErrorText(sc)
 d ##class(web.DHCEMDocGuarantee).R(code,msg)
 q ""
}

/// 输出担保金额combox
ClassMethod levelCombox(hosp) As %String
{
	n (hosp)
	s hosp=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmGuaLevel",hosp) //hxy 2020-05-27 产品配置-私有
	w "["
	s id="",count=0
	f  s id=$o(^User.DHCEmGuaLevelD(id)) q:id=""  d
	.s levelMin=$LISTGET(^User.DHCEmGuaLevelD(id),2)
	.s:levelMin<1 levelMin="0."_$p(levelMin,".",2)
	.s levelMax=$LISTGET(^User.DHCEmGuaLevelD(id),3)
	.s activeFlag=$LISTGET(^User.DHCEmGuaLevelD(id),4)
	.s hospDr=+$LISTGET(^User.DHCEmGuaLevelD(id),5)
	.q:+hosp'=hospDr
	.q:activeFlag="N"
	.s count=count+1
	.w $case(count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",id_"^"_levelMin)
	w "]"
	q ""
}

}
