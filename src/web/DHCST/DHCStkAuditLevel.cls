Import sqluser

Class web.DHCST.DHCStkAuditLevel Extends %Persistent [ ClassType = "", ProcedureBlock ]
{

Parameter AppTable [ Final ] = "DHC_StkAuditLevel";

/// CreateDate : 2014-09-15
/// Creator : MYQ
/// Function : 取已经维护业务审核等级配置
/// table : DHC_StkAuditLevel
/// w ##class(web.DHCST.DHCStkAuditLevel).QueryAuditLevel()
ClassMethod QueryAuditLevel(HospId = "")
{
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
    s pid=..NewPid()
    s h=0
	s stalid=0
	f  s stalid=$o(^DHCSTAL(stalid)) q:(stalid="")||(stalid=0)  d
    .s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,stalid,HospId) //医院级别授权
    .q:flag="N"
	.s tmpdata=^DHCSTAL(stalid)
	.s activeflag=$p(tmpdata,"^",5)
	.i activeflag="Y" s activeflagdesc="启用"
	.e  s activeflagdesc="未启用"
    .s TypeId=$p(tmpdata,"^",1)
    .s TypeStr=..GetTypeDesc(TypeId)
    .s TypeDesc=$p(TypeStr,"^",2)
    .s STALItmDesc=$p(TypeStr,"^",2)
    .s ItmLevel=$p(tmpdata,"^",3)
    .s SSGroupId=$p(tmpdata,"^",4)
    .s SSGroupDesc=""
    .s:SSGroupId'="" SSGroupDesc=$p(^SSU("SSGRP",SSGroupId),"^",1)
    .s StkGrp=$p(tmpdata,"^",6)
    .s ItmLocId=$p(tmpdata,"^",8)
    .q:(BDPHospAut="Y")&&(ItmLocId'="")&&($p(^CTLOC(ItmLocId),"^",22)'=HospId)
    .s ItmLocDesc=""
    .s:ItmLocId'="" ItmLocDesc=$p(^CTLOC(ItmLocId),"^",2)
    .s:ItmLocDesc["-" ItmLocDesc=$p(ItmLocDesc,"-",2)
    .s SSUserId=$p(tmpdata,"^",9)
    .s SSUserDesc=""
    .s:SSUserId'="" SSUserDesc=$p($g(^SSU("SSUSR",SSUserId)),"^",2)
	.s data=stalid_"^"_activeflag_"^"_activeflagdesc_"^"_TypeId_"^"_TypeDesc_"^"_STALItmDesc_"^"_ItmLevel_"^"_SSGroupId_"^"_SSGroupDesc_"^"_StkGrp_"^"_ItmLocId_"^"_ItmLocDesc_"^"_SSUserId_"^"_SSUserDesc
	.
	.s h=h+1
	.s ^TMP("DHCST","web.DHCST.DHCStkAuditLevel","QueryAuditLevel",pid,h)=data
	.
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","web.DHCST.DHCStkAuditLevel","QueryAuditLevel",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","web.DHCST.DHCStkAuditLevel","QueryAuditLevel",pid,h)
    .s STALRowId=$p(data,"^",1)
    .s ActiveFlagId=$p(data,"^",2)
    .s ActiveFlagDesc=$p(data,"^",3)
    .s TypeId=$p(data,"^",4)
    .s TypeDesc=$p(data,"^",5)
    .s STALItmDesc=$p(data,"^",6)
    .s ItmLevel=$p(data,"^",7)
    .s SSGroupId=$p(data,"^",8)
    .s SSGroupDesc=$p(data,"^",9)
    .s StkGrpId=$p(data,"^",10)
    .s StkGrpDesc=StkGrpId
    .s ItmLocId=$p(data,"^",11)
    .s ItmLocDesc=$p(data,"^",12)
    .s SSUserId=$p(data,"^",13)
    .s SSUserDesc=$p(data,"^",14)
    .
    .s STALRowId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("STALRowId",STALRowId)
    .s ActiveFlagId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ActiveFlagId",ActiveFlagId)
    .s ActiveFlagDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ActiveFlagDesc",ActiveFlagDesc)
    .s TypeId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("TypeId",TypeId)
    .s TypeDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("TypeDesc",TypeDesc)
    .s STALItmDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("STALItmDesc",STALItmDesc)
    .s ItmLevel=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ItmLevel",ItmLevel)
    .s SSGroupId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("SSGroupId",SSGroupId)
    .s SSGroupDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("SSGroupDesc",SSGroupDesc)
    .s StkGrpId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("StkGrpId",StkGrpId)
    .s StkGrpDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("StkGrpDesc",StkGrpDesc)
    .s ItmLocId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ItmLocId",ItmLocId)
    .s ItmLocDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ItmLocDesc",ItmLocDesc)
    .s SSUserId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("SSUserId",SSUserId)
	.s SSUserDesc=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("SSUserDesc",SSUserDesc)
	.s tmpstr=STALRowId_ActiveFlagId_ActiveFlagDesc_TypeId_TypeDesc_STALItmDesc_ItmLevel_SSGroupId_SSGroupDesc_StkGrpId_StkGrpDesc_ItmLocId_ItmLocDesc_SSUserId_SSUserDesc
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow 
    k ^TMP("DHCST","web.DHCST.DHCStkAuditLevel","QueryAuditLevel",pid)
    q ""
}

/// w ##class(web.DHCST.DHCStkAuditLevel).SaveAuditLevel("23^Y^Basic^???????^2^142^G^257^11643","2")
ClassMethod SaveAuditLevel(ListDetail As %String, HospId = "") As %Library.String
{
	;n (ListDetail)
	//s ^YSJTMP("SaveAuditLevel")=$LB(ListDetail,HospId)
	q:ListDetail="" -5
	//s Count=0
	s msg=0
    s Err=""
	s Len=$l(ListDetail,"!!")
	f i=1:1:Len  d
	.s Data=$p(ListDetail,"!!",i)
	.s STALRowId=$p(Data,"^",1)
	.s Type=$p(Data,"^",3)
	.s STALItmDesc=$p(Data,"^",4)
	.s ItmLevel=$p(Data,"^",5)
	.s SSGroupId=$p(Data,"^",6)
	.s StkGrp=$p(Data,"^",7)
	.s ItmLocId=$p(Data,"^",8)
	
	.s SSUserId=$p(Data,"^",9)
	.s tmpid=""
    .&SQL(SELECT STAL_RowId into :tmpid FROM DHC_StkAuditLevel WHERE STAL_Type=:Type AND STAL_StkGrp='G'  AND STAL_ItmLevel=:ItmLevel AND STAL_SSGroup=:SSGroupId AND STAL_ItmLoc_Dr=:ItmLocId AND STAL_SSUser_Dr=:SSUserId)
    .s tmphosp=""
    .i tmpid'=""  d
    ..s tmploc=$P(^DHCSTAL(tmpid),"^",8)
    ..s tmphosp=$P(^CTLOC(tmploc),"^",22)
    .s:(tmpid'="")&(tmpid'=STALRowId)&&(HospId=tmphosp) msg=-1
    .q:msg'=0
	.i STALRowId'=""  d
    ..s Ret=..Update(STALRowId,Data)
    ..i Ret'=0  d
    ...s Err=Err_","_STALItmDesc
    ..//e  d
    ...//s Count=Count+1
    .e  d
    ..s Ret=..Insert(Data,HospId)
    ..i Ret=""  d
    ...s Err=Err_","_STALItmDesc
    ..//e  d
    ...//s Count=Count+1
    //q:Count=0 -6  ;所有明细保存均失败
    q:Err'="" -7 //_"^"_Err  ;保存失败的明细
    q:msg=-1 msg //"重复"
    q 0
}

// w ##class(web.DHCST.DHCStkAuditLevel).Insert("^Y^R^^2^1^G^71^539")

ClassMethod Insert(Data As %String, HospId = "") As %Library.String
{
	;n (Data)
	s ActiveFlag=$p(Data,"^",2)
	i ActiveFlag="" s ActiveFlag="N"
	s Type=$p(Data,"^",3)
	s STALItmDesc=$p(Data,"^",4)
	s ItmLevel=$p(Data,"^",5)
	s SSGroupId=$p(Data,"^",6)
	s StkGrp=$p(Data,"^",7)
	s ItmLocId=$p(Data,"^",8)
	s SSUserId=$p(Data,"^",9)
	s Err=0
    &sql(INSERT INTO DHC_StkAuditLevel(STAL_Type,STAL_ItmLevel,STAL_SSGroup,STAL_ActiveFlag, 
    STAL_StkGrp,STAL_ItmLoc_Dr,STAL_SSUser_Dr)
    VALUES(:Type, :ItmLevel, :SSGroupId, :ActiveFlag,:StkGrp,:ItmLocId,:SSUserId))
    ;b ;22
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_StkAuditLevel",STALItmDesc,SQLCODE_":"_%msg)
    .s Err=-3
    .
    e  d
    .s Rowid=$p(%ROWID,$c(1))
    .i HospId'="" d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,Rowid,HospId)
    q:Err'=0 ""    ;保存失败
    ;
    q $p($g(%ROWID),$c(1))
}

ClassMethod Update(STALRowId As %String, Data As %String, HospId = "") As %Library.String [ Private ]
{
	;n (STALRowId,Data)
	s ActiveFlag=$p(Data,"^",2)
	i ActiveFlag="" s ActiveFlag="N"
	s Type=$p(Data,"^",3)
	s STALItmDesc=$p(Data,"^",4)
	s ItmLevel=$p(Data,"^",5)
	s SSGroupId=$p(Data,"^",6)
	s StkGrp=$p(Data,"^",7)
	s ItmLocId=$p(Data,"^",8)
	s SSUserId=$p(Data,"^",9)
	s Err=0
	
    &sql(Update DHC_StkAuditLevel set STAL_Type=:Type,STAL_ItmLevel=:ItmLevel,STAL_SSGroup=:SSGroupId,
    STAL_ActiveFlag=:ActiveFlag,STAL_StkGrp=:StkGrp,STAL_ItmLoc_Dr=:ItmLocId,STAL_SSUser_Dr=:SSUserId 
    where STAL_RowId=:STALRowId) 
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_StkAuditLevel",STALRowId,SQLCODE_":"_%msg)
    .s Err=-3
    .
    q:Err'=0 -11    ;更新明细失败
    ;
    q 0
}

/// w ##class(web.DHCST.DHCStkAuditLevel).DelAuditLevel(11)
ClassMethod DelAuditLevel(STALRowId, HospId = "") As %String
{
    
	q:STALRowId="" -1
	;不能为空项
    ;
    s Err=0
    &sql(Delete from DHC_StkAuditLevel where STAL_RowId=:STALRowId)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_StkAuditLevel",STALRowId,SQLCODE_":"_%msg)
    .s Err=-3
    e  d
    .i HospId'="" d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#AppTable,STALRowId,HospId)
    q Err
}

/// 获取项目类型
/// d ##class(web.DHCST.DHCStkAuditLevel).GetSTALType()
ClassMethod GetSTALType() As %String
{
	//业务类型
	s TypeStr="G^入库!!T^转移出库!!K^转移入库!!R^退货!!P^住院发药!!Y^住院退药!!D^报损!!C^消耗!!A^调整!!F^门诊发药!!H^门诊退药!!Basic^药品信息"
    s maxrow=$l(TypeStr,"!!")
    s count=0
    s Typei=""
    f Typei=1:1:maxrow d
    .s typedata=$p(TypeStr,"!!",Typei)
    .s TypeCode=$p(typedata,"^",1)
    .s TypeDesc=$p(typedata,"^",2)
    .s RowId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("RowId",TypeCode)
    .s Description=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("Description",TypeDesc)
	.s tmpstr=RowId_Description
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
    q ""
}

/// 获取项目类型id取描述
/// w ##class(web.DHCST.DHCStkAuditLevel).GetTypeDesc()
ClassMethod GetTypeDesc(TypeId) As %String
{
	;n (TypeId)
	q:TypeId="" ""
	s TypeDesc=""
	s:(TypeId=1)||(TypeId="G") TypeCode="G",TypeDesc="入库"
	s:(TypeId=2)||(TypeId="T") TypeCode="T",TypeDesc="转移出库"
	s:(TypeId=3)||(TypeId="K") TypeCode="K",TypeDesc="转移入库"
	s:(TypeId=4)||(TypeId="R") TypeCode="R",TypeDesc="退货"
	s:(TypeId=5)||(TypeId="P") TypeCode="P",TypeDesc="住院发药"
	s:(TypeId=6)||(TypeId="Y") TypeCode="Y",TypeDesc="住院退药"
	s:(TypeId=7)||(TypeId="D") TypeCode="D",TypeDesc="报损"
	s:(TypeId=8)||(TypeId="C") TypeCode="C",TypeDesc="消耗"
	s:(TypeId=9)||(TypeId="A") TypeCode="A",TypeDesc="调整"
	s:(TypeId=10)||(TypeId="F") TypeCode="F",TypeDesc="门诊发药"
	s:(TypeId=11)||(TypeId="H") TypeCode="H",TypeDesc="门诊退药"
	s:(TypeId=12)||(TypeId="Basic") TypeCode="Basic",TypeDesc="药品信息"

	q TypeCode_"^"_TypeDesc
}

ClassMethod NewPid()
{
	
	q $I(^DHCSTPID("DHCStkAuditLevel"))
}

}
