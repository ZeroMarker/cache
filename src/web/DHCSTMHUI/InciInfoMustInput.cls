Import sqluser

/// Descript:控制基础数据字段是否必填项
/// Creater:lihui
/// CreateDate:	2017-03-23
/// Table: DHC_InciInfoMustInput
Class web.DHCSTMHUI.InciInfoMustInput Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// d ##class(web.DHCSTMHUI.InciInfoMustInput).Query()
ClassMethod Query(Block = "", LocId = "")
{
	s result=##class(%Library.ResultSet).%New()
	s sqlstr="SELECT INCMI_RowId as RowId, INCMI_ElementId as ElementId,INCMI_ElementLabel as ElementLabel, INCMI_ElementName as ElementName, INCMI_CspName as CspName, INCMI_MustFlag as MustFlag FROM DHC_InciInfoMustInput"
	s sqlstr=sqlstr_" where 1=1"
	i Block'="" s sqlstr=sqlstr_" and INCMI_Block='"_Block_"'"
	i LocId'="" s sqlstr=sqlstr_" and INCMI_Loc_Dr='"_LocId_"'"
	d result.Prepare(sqlstr)
	d result.Execute()
	s count=0
	s cspCHNname=""
	s json=##class(web.DHCSTMHUI.Common.JsonObj).%New()
	while(result.Next())
	{
		s RowId=result.Data("RowId")
		s INCMIEleId=result.Data("ElementId")
		s INCMIEleName=result.Data("ElementName")
		s INCMIEleLabel=result.Data("ElementLabel")
		s INCMICspName=result.Data("CspName")
		&sql(SELECT Caption into :cspCHNname FROM websys.menu WHERE LinkUrl=:INCMICspName)
		s INCMIMustFlag=result.Data("MustFlag")
		s tmp=RowId_"^"_INCMIEleId_"^"_INCMIEleName_"^"_INCMICspName_"^"_INCMIMustFlag_"^"_cspCHNname_"^"_INCMIEleLabel
		s count=count+1
		d json.InsertRowData(tmp)
	}
	d result.Close()
	d json.getJsonData("RowId^INCMIEleId^INCMIEleName^INCMICspName^INCMIMustFlag^cspCHNname^INCMIEleLabel",count)
	k json
	q ""
}

ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (Params,%session)  
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj="" 
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..Delete(RowId)
		continue:RtnObj.success<0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

ClassMethod Delete(RowId As %String) As RtnObj
{
	n (RowId,%session)
	s MethodName=$CLASSNAME()_".Delete"
	s RtnObj=##class(RtnObj).%New()
	
	i RowId="" q RtnObj.Err(-2,"",MethodName_":参数错误")
	&sql(SELECT INCMI_ElementId, INCMI_ElementName, INCMI_CspName, INCMI_MustFlag into :OldElemId,:OldElemname,:OldCspname,:OldMustflag FROM DHC_InciInfoMustInput WHERE INCMI_RowId=:RowId) 
 	s JsonStr=OldElemId_","_OldElemname_","_OldCspname_","_OldMustflag
 	&sql(DELETE from DHC_InciInfoMustInput WHERE INCMI_RowId=:RowId)
	i SQLCODE'=0 d
	.d RtnObj.Err(-4,RowId,MethodName_":删除数据失败","{RowId:"_RowId_"}")
	e  d
    .s RtnObj=##class(Log).SaveLog("DHC_InciInfoMustInput","User.DHCInciInfoMustInput","基础字典必填项信息",RowId,"","D",JsonStr)
	q:RtnObj.success<0 RtnObj
	
	q RtnObj
}

/// Descript:	保存/更新信息
/// Creater:	zx
/// CreateDate:	2018-07-27
/// Table:		DHC_InciInfoMustInput
/// Input:		数据Json串
/// Return：	RtnObj Json
/// w ##class(web.DHCSTMHUI.InciInfoMustInput).Save("[{""INCMIEleId"":""ArcimRpPuruom"",""INCMIEleName"":""222"",""INCMICspName"":""dhcstm.druginfoarcim.csp"",""cspCHNname"":""wz"",""INCMIMustFlag"":""N""}]")
ClassMethod Save(Params, LocId) As %Library.String
{
	n (Params,LocId,%session)
	s $ZT=..sssError()
	s ^tmpxu=Params
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s ElemId=Obj.%Get("INCMIEleId")
		s ElemName=Obj.%Get("INCMIEleName")
		s ElemLabel=Obj.%Get("INCMIEleLabel")
		s CspName=Obj.%Get("INCMICspName")
		s CspChName=Obj.%Get("cspCHNname")
		s MustFlag=Obj.%Get("INCMIMustFlag")
		s Block=Obj.%Get("INCMIBlock")
	 	i (ElemId="")||(CspName="")  d RtnObj.Err(-2,"","必填项不能为空!","",0)  
	 	q:RtnObj.success'=0
		i RowId'=""  d
		.s RtnObj=..Update(RowId,ElemId,ElemName,CspName,CspChName,MustFlag,LocId)
		e  d
		.s RtnObj=..Insert(ElemId,ElemName,CspName,MustFlag,Block,ElemLabel,LocId)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

ClassMethod InitSave(Params, LocId) As %Library.String
{
	n (Params,LocId,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
 	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s ElemId=Obj.%Get("INCMIEleId")
		s ElemName=Obj.%Get("INCMIEleName")
		s ElemLabel=Obj.%Get("INCMIEleLabel")
		s CspName=Obj.%Get("INCMICspName")
		s CspChName=Obj.%Get("cspCHNname")
		s MustFlag=Obj.%Get("INCMIMustFlag")
		s Block=Obj.%Get("INCMIBlock")
	 	i (ElemId="")||(CspName="")  d RtnObj.Err(-2,"","必填项不能为空!","",0)  
	 	q:RtnObj.success'=0
	 	i RowId=""  d
	 	.&sql(SELECT INCMI_RowId Into :RowId FROM DHC_InciInfoMustInput WHERE INCMI_Block=:Block AND INCMI_CspName=:CspName AND INCMI_ElementId=:ElemId AND INCMI_Loc_Dr=:LocId)
		i 'SQLCODE  d
		.//s RtnObj=..Update(RowId,ElemId,ElemName,CspName,CspChName,MustFlag)
		e  d
		.s RtnObj=..Insert(ElemId,ElemName,CspName,MustFlag,Block,ElemLabel,LocId)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	插入基础数据控件信息
/// Creater:	zx
/// CreateDate:	2018-07-27
/// Table:		DHC_InciInfoMustInput
/// Input:		
/// Output:		
/// Return：	RtnObj
ClassMethod Insert(ElemId As %String, ElemName As %String, CspName As %String, MustFlag As %String, Block, ElemLabel, LocId) As RtnObj [ Private ]
{
	n (ElemId,ElemName,CspName,MustFlag,Block,ElemLabel,LocId,%session)
	s RtnObj=##class(RtnObj).%New()
	s INCMIRowId=""
	&sql(SELECT INCMI_RowId into :INCMIRowId FROM DHC_InciInfoMustInput WHERE INCMI_ElementId=:ElemId AND INCMI_CspName=:CspChName and INCMI_Loc_Dr=:LocId)
	i (+INCMIRowId>0) d RtnObj.Err(-6,"","数据重复!","",0)
	q:RtnObj.success'=0 RtnObj
	
	&sql(SELECT ID into :CspId FROM websys.menu WHERE LinkUrl=:CspName)
	if +CspId'>0 d RtnObj.Err(-7,"","csp没有对应的菜单!","",0) 
	q:RtnObj.success'=0 RtnObj
	s JsonStr=ElemId_","_ElemName_","_CspName_","_MustFlag
	&sql(INSERT INTO DHC_InciInfoMustInput (INCMI_ElementId, INCMI_ElementName, INCMI_CspName, INCMI_MustFlag,INCMI_Block,INCMI_ElementLabel,INCMI_Loc_Dr) 
	VALUES(:ElemId,:ElemName,:CspName,:MustFlag,:Block,:ElemLabel,:LocId))
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_InciInfoMustInput","User.DHCInciInfoMustInput","基础数据控件信息",$SYSTEM.SQL.GetROWID(),ElemId,"A",JsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新信息
/// Creater:	zx
/// CreateDate:	2018-07-27
/// Table:		DHC_InciInfoMustInput
/// Input:		
/// Return：	RtnObj
ClassMethod Update(RowId As %String, ElemId As %String, ElemName As %String, CspName As %String, CspChName As %String, MustFlag As %String, LocId As %String) As RtnObj [ Private ]
{
	n (RowId,ElemId,ElemName,CspName,CspChName,MustFlag,LocId,%session)
	s RtnObj=##class(RtnObj).%New()
 	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_InciInfoMustInput",RowId)
 	&sql(SELECT INCMI_RowId into :INCMIRowId FROM DHC_InciInfoMustInput WHERE INCMI_ElementId=:ElemId AND INCMI_CspName=:CspName and INCMI_Loc_Dr=:LocId)
	if ((INCMIRowId'="")&&(+INCMIRowId'=+RowId)) d RtnObj.Err(-3,"","数据重复!","",0) 
	q:RtnObj.success'=0 RtnObj
	&sql(SELECT ID into :CspId FROM websys.menu WHERE LinkUrl=:CspName)
	if +CspId'>0 d RtnObj.Err(-4,"","csp没有对应的菜单!","",0) 
	q:RtnObj.success'=0 RtnObj
	&sql(SELECT INCMI_ElementId, INCMI_ElementName, INCMI_CspName, INCMI_MustFlag into :oldelemid,:oldelemname,:oldcspname,:oldmustflag FROM DHC_InciInfoMustInput WHERE INCMI_RowId=:RowId)
	s OldJsonStr=oldelemid_","_oldelemname_","_oldcspname_","_oldmustflag
	s JsonStr=ElemId_","_ElemName_","_CspName_","_MustFlag

	&sql(UPDATE DHC_InciInfoMustInput SET INCMI_ElementId=:ElemId,INCMI_ElementName=:ElemName,INCMI_CspName=:CspName,INCMI_MustFlag=:MustFlag WHERE INCMI_RowId=:RowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-5,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_InciInfoMustInput","User.DHCInciInfoMustInput","基础字典必填项信息",RowId,"","U",JsonStr,OldJsonStr)
	q:RtnObj.success'=0 RtnObj

	q RtnObj
}

/// Descript:根据传入的控件元素获取相应的控制标志
/// Creater:lihui
/// CreateDate:	2017-03-23
/// Input:控件信息串:控件id串,控件所在csp名称
/// Output:		
/// Return：控件元素控制标志串
/// w ##class(web.DHCSTMHUI.InciInfoMustInput).getElemetstrflag("INCICode^INCIDesc","dhcstm.basicdruginfo.csp")
ClassMethod getElemetstrflag(elemidstr As %String, cspname As %String) As %Library.String
{
	n (elemidstr,cspname)
	s ^tmpli("getElemetstrflag")=elemidstr_","_cspname
	q:elemidstr="" ""
	q:cspname="" ""
	s rowdelim="^"
	s len=$l(elemidstr,rowdelim)
	s elemstr=""
	f i=1:1:len d
	.s elem=$p(elemidstr,rowdelim,i)
	.s flag=..getElemetflag(elem,cspname)
	.i elemstr="" d
	..s elemstr=flag
	.e  d
	..s elemstr=elemstr_"^"_flag
 	q elemstr
}

/// 获取某个元素的标志
ClassMethod getElemetflag(elemid As %String, cspname As %String) As %Library.String
{
	n (elemid,cspname)
	q:elemid="" "N"
	q:cspname="" "N"
	s flag="N"
	s INCMID=$O(^INCMI(0,"INCMID",elemid,cspname,""))
	IF (INCMID'="") d
	.s flag=$p(^INCMI(INCMID),"^",4)
	.s:flag="" flag="N"
 	q flag
}

}
