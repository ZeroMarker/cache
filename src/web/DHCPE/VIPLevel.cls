Class web.DHCPE.VIPLevel Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod OutAlcolToHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='AlcolHis' id='AlcolHis' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	w "<option value=''>  </option>",!
	s selected=""
	s:DefaultValue="不饮酒" selected="selected"
	w "<option value='不饮酒' "_selected_"> 不饮酒 </option>",!
	s selected=""
	s:DefaultValue="偶饮酒" selected="selected"
	w "<option value='偶饮酒' "_selected_"> 偶饮酒 </option>",!
	s selected=""
	s:DefaultValue="经常饮" selected="selected"
	w "<option value='经饮' "_selected_"> 经常饮 </option>",!	
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutSmokeToHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='SmokeHis' id='SmokeHis' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	w "<option value=''>  </option>",!
	s selected=""
	s:DefaultValue="不吸烟" selected="selected"
	w "<option value='不吸烟' "_selected_"> 不吸烟 </option>",!
	s selected=""
	s:DefaultValue="偶吸烟" selected="selected"
	w "<option value='偶吸烟' "_selected_"> 偶吸烟 </option>",!
	s selected=""
	s:DefaultValue="经常吸" selected="selected"
	w "<option value='经吸' "_selected_"> 经常吸 </option>",!
	
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutCategoryToHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	//s DefaultValue=1
	w "<select name='category' id='category' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^User.DHCPEOMETypeD(id)) q:id=""  d
	.s selected=""
	.s:DefaultValue=id selected="selected"
	.s Active=$LG(^User.DHCPEOMETypeD(id),4)
	.q:Active'="Y"
	.s VipLevel=$LG(^User.DHCPEOMETypeD(id),5)
	.s VIPDesc=""
	.i VipLevel'="" s VIPDesc=##class(web.DHCPE.PreCommon).GetVIPDescBYLevel(VipLevel)
	.q:VIPDesc'["职业病"
	.w "<option value='"_id_"' "_selected_">"_$LG(^User.DHCPEOMETypeD(id),3)_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutIndustryToHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	//s DefaultValue=1
	w "<select name='Industry' id='Industry' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^User.DHCPEIndustryD(id)) q:id=""  d
	.s selected=""
	.s:DefaultValue=id selected="selected"
	.s Active=$LG(^User.DHCPEIndustryD(id),4)
    .q:Active'="Y"
	.w "<option value='"_id_"' "_selected_">"_$LG(^User.DHCPEIndustryD(id),3)_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutWorkTypeToHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	//s DefaultValue=1
	w "<select name='Typeofwork' id='Typeofwork' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^User.DHCPEWorkTypeD(id)) q:id=""  d
	.s selected=""
	.s:DefaultValue=id selected="selected"
	.s Active=$LG(^User.DHCPEWorkTypeD(id),4)
	.q:Active'="Y"
	.w "<option value='"_id_"' "_selected_">"_$LG(^User.DHCPEWorkTypeD(id),3)_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutProtectiveMeasureToHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	
	w "<select name='ProtectiveMeasure' id='ProtectiveMeasure' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^User.DHCPEProtectiveMeasuresD(id)) q:id=""  d
	.s selected=""
	.s:DefaultValue=id selected="selected"
	.s Active=$LG(^User.DHCPEProtectiveMeasuresD(id),4)
	.q:Active'="Y"
	.w "<option value='"_id_"' "_selected_">"_$LG(^User.DHCPEProtectiveMeasuresD(id),3)_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

ClassMethod Insert(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
   s level=$p(InString,"^",1)
   s desc=$p(InString,"^",2)
   s secret=$p(InString,"^",3)
   s use=$p(InString,"^",4)
   s approve=$p(InString,"^",5)
   s id=$p(InString,"^",6)
   s Template=$p(InString,"^",7)
   s FeeType=$p(InString,"^",8)
   s SetCode=$p(InString,"^",9)
   s HPNo=$p(InString,"^",10)
   s cspfile=$p(InString,"^",11)
   s OrdSetsDR=$p(InString,"^",12)
   s ZYDInfo=$p(InString,"^",13)
   s ZYDTemplate=$p(InString,"^",14)
   s HMService=$p(InString,"^",15)
   s GeneralType=$p(InString,"^",16)
   s IfInsert=$p(InString,"^",17)
   i id'="" d
   .s OldFeeType=$P(^DHCPEVIPLevel("VIP",id),"^",7)
   .k:OldFeeType'="" ^DHCPEVIPLevelI(OldFeeType)
   i $d(^DHCPEVIPLevel("VIP"))="" s id=0
   e  i id="" s id=$o(^DHCPEVIPLevel("VIP",""),-1)
   e  s id=id-1
   s id=id+1
   s VIPNVID=$G(^DHCPEVIPLevel("VIPapprove"))
   i approve="Y" d
   .s ^DHCPEVIPLevel("VIPapprove")=id
   else   d
   .if VIPNVID=id  d 
   ..k ^DHCPEVIPLevel("VIPapprove")
 
   s ^DHCPEVIPLevel("VIP",id)=level_"^"_desc_"^"_secret_"^"_use_"^"_approve_"^"_Template_"^"_FeeType_"^"_SetCode_"^"_HPNo_"^"_cspfile_"^"_OrdSetsDR_"^"_ZYDInfo_"^"_ZYDTemplate_"^"_HMService_"^"_GeneralType_"^"_IfInsert
   i FeeType'="" d
   .s ^DHCPEVIPLevelI(FeeType)=id
  
   q 0
}

ClassMethod GetVIPIDByDesc(VIPDesc)
{
	;##class(web.DHCPE.VIPLevel).GetVIPIDByDesc(VIPDesc)
	s ret=""
	s VIPID=""
	f  s VIPID=$O(^DHCPEVIPLevel("VIP",VIPID)) q:(VIPID="")||(ret'="")  d
	.s Desc=$P(^DHCPEVIPLevel("VIP",VIPID),"^",2)
	.s:Desc=VIPDesc ret=VIPID
	q ret
}

/*
ClassMethod GetPatFeeType(VIPLevel)
{
	q:VIPLevel="" ""
	q $P($G(^DHCPEVIPLevel("VIP",VIPLevel)),"^",7)
}
*/
/// Creator：    xy 
/// CreatDate：  20210822
/// Description: 获取客户VIP等级对应的病人类型
/// Table：      科室VIP等级维护 DHC_PE_LocVIPLevel
/// Input:       VIPLevel（VIPID）,LocID（科室ID）
/// Return：      return=病人类型
/// debug: w ##class(web.DHCPE.VIPLevel).GetPatFeeType()
ClassMethod GetPatFeeType(VIPLevel, LocID)
{
	q:VIPLevel="" ""
	s ID=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP", " "_LocID,VIPLevel,""))
	q:ID="" ""
	s Active=$lg($g(^CF.PE.LocVIPLevelD(ID)),15)
	q:Active="N" ""
	s PatFeeType=$lg($g(^CF.PE.LocVIPLevelD(ID)),7)
	q PatFeeType
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.VIPLevel","FindVIPLevel")
Query FindVIPLevel() As %Query(ROWSPEC = "TLevel:%String,TDesc:%String,TIsSecret:%String,TIsUse:%String,TIsApprove:%String,TID:%String,TTemplate:%String,TFeeTypeDR:%String,TFeeTypeName:%String,TSetCode:%String,THPCode:%String,Tcspfile:%String,TOrdSetsDR:%String,TOrdSetsDesc:%String,TZYDInfo:%String,TZYDTemplate:%String,THMService:%String,THMServiceDR:%String,TGeneralType:%String,TIfInsert:%String") [ SqlProc ]
{
}

ClassMethod FindVIPLevelExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=0
	f  s id=$o(^DHCPEVIPLevel("VIP",id)) q:id=""  d
	.s level=$p($g(^DHCPEVIPLevel("VIP",id)),"^",1)
	.s desc=$p($g(^DHCPEVIPLevel("VIP",id)),"^",2)
	.s secret=$p($g(^DHCPEVIPLevel("VIP",id)),"^",3)
	.i secret="Y"  S secret="是"
	.e  S secret="否"
	.s use=$p($g(^DHCPEVIPLevel("VIP",id)),"^",4)
	.i use="Y"  S use="是"
	.e  S use="否"
	.s approve=$p($g(^DHCPEVIPLevel("VIP",id)),"^",5)
	.i approve="Y"  S approve="是"
	.e  S approve="否"
	.s Template=$p($g(^DHCPEVIPLevel("VIP",id)),"^",6)
	.s TFeeTypeDR=$P($G(^DHCPEVIPLevel("VIP",id)),"^",7)
	.s TSetCode=$P($G(^DHCPEVIPLevel("VIP",id)),"^",8)
	.s THPCode=$P($G(^DHCPEVIPLevel("VIP",id)),"^",9)
	.s THMServiceDR=$P($G(^DHCPEVIPLevel("VIP",id)),"^",14)
	.s THMService=""
	.i THMServiceDR'="" d
	..s THMService=$lg(^User.DHCHMCServiceClassD(THMServiceDR),4)
	.s TFeeTypeName=""
	.s:TFeeTypeDR'="" TFeeTypeName=$P($G(^PAC("SUBT",TFeeTypeDR)),"^",2)
	.s cspfile=$P($G(^DHCPEVIPLevel("VIP",id)),"^",10)
	.s OrdSetsDR=$P($G(^DHCPEVIPLevel("VIP",id)),"^",11)
	.s OrdSetsDesc=""
	.i OrdSetsDR'="" d
	..s OrdSetsDesc=$P($G(^ARCOS(OrdSetsDR)),"^",2)
	.s ZYDInfo=$P($G(^DHCPEVIPLevel("VIP",id)),"^",12)
	.s TZYDTemplate=$P($G(^DHCPEVIPLevel("VIP",id)),"^",13)
	.s TGeneralType=$P($G(^DHCPEVIPLevel("VIP",id)),"^",15)
	.s TIfInsert=$P($G(^DHCPEVIPLevel("VIP",id)),"^",16)

	.d FindBuild	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(level,desc,secret,use,approve,id,Template,TFeeTypeDR,TFeeTypeName,TSetCode,THPCode,cspfile,OrdSetsDR,OrdSetsDesc,ZYDInfo,TZYDTemplate,THMService,THMServiceDR,TGeneralType,TIfInsert)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindVIPLevelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindVIPLevelExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindVIPLevelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindVIPLevelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/*
ClassMethod OutVIPToHTML(ContrlWidth As %String = "", DefaultValue As %String = "", tabIndex As %String = 0) As %String
{
	;d ##class(web.DHCPE.VIPLevel).OutVIPToHTML()
	s:(""=ContrlWidth) ContrlWidth="155"
	;w "<select name='VIPLevel' id='VIPLevel' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex="_tabIndex_">",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("VIPLevel","")
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$o(^DHCPEVIPLevel("VIP",id)) q:id=""  d
	.s selected=""
	.s:DefaultValue=id selected="selected"
	.s use=$p($g(^DHCPEVIPLevel("VIP",id)),"^",4)
	.q:use'="Y"
	.i use="Y" d
	..s use="可用"
	.e  d
	..s use="<color = red>禁用</color>"
	.s desc=$p($g(^DHCPEVIPLevel("VIP",id)),"^",2)
	.w "<option value='"_id_"' "_selected_">"_desc_"</option>",!
	w "</select>",!
	Quit $$$OK
}
*/
ClassMethod OutVIPToHTML(ContrlWidth As %String = "", DefaultValue As %String = "", tabIndex As %String = 0) As %String
{
	;d ##class(web.DHCPE.VIPLevel).OutVIPToHTML()
	s:(""=ContrlWidth) ContrlWidth="155"
	;w "<select name='VIPLevel' id='VIPLevel' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex="_tabIndex_">",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("VIPLevel","")
	w "<option value=''>  </option>",!
	S LocID=%session.Get("LOGON.CTLOCID")
	s VIPLevelID=0 
	f  s VIPLevelID=$O(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIPLevelID)) q:VIPLevelID=""  d
	.s id=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIPLevelID,0)) // 1个科室不能存在相同VIP
	.s selected=""
	.s LocActive=$lg($g(^CF.PE.LocVIPLevelD(id)),15)
	.q:LocActive'="Y"
	.s VIPLevelDR=$lg($g(^CF.PE.LocVIPLevelD(id)),3)
	.s Active=$lg($g(^CT.PE.VIPLevelD(VIPLevelDR)),4)
	.q:Active'="Y"
	.s desc=$lg($g(^CT.PE.VIPLevelD(VIPLevelDR)),3)
	.;s Default=$lg($g(^CF.PE.LocVIPLevelD(id)),5)
	.;i Default="Y"  s selected="selected"
	.w "<option value='"_id_"' "_selected_">"_desc_"</option>",!
	w "</select>",!
	Quit $$$OK
}

/// d ##class(web.DHCPE.PreCommon).OutSexToHTML()
ClassMethod OutSexToHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	;w "<select name='Sex' id='Sex' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("SexDR","")
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^CT("SEX",id)) q:id=""  d
	.s selected=""
	.s:DefaultValue=id selected="selected"
	.w "<option value='"_id_"' "_selected_">"_$P($G(^CT("SEX",id)),"^",2)_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

ClassMethod SetTemplateGlobal(Template, SetInfo)
{
	if '($L(Template,".xls")>1) q "不是Excel模板,不能如此设置"
	k ^DHCPESpecialReportInfo(Template)
	k ^DHCPESpecialReportInfoBase(Template)
	s SetLength=$L(SetInfo,$C(1))
	f i=1:1:SetLength
	{
		s OneInfo=$P(SetInfo,$C(1),i)
		s Element=$P(OneInfo,$C(2),1)
		continue:Element=""
		s OneSetInfo=$P(OneInfo,$C(2),2)
		s Type=$P(OneSetInfo,"^",1)
		continue:Type=""
		s OneLength=$L(OneSetInfo,"^")
		i Type="B" d
		.s BaseName=$P(OneSetInfo,"^",2)
		.s ^DHCPESpecialReportInfoBase(Template,BaseName)=Element
		i Type="D" d
		.s BaseName=$P(OneSetInfo,"^",2)
		.s ^DHCPESpecialReportInfoBase(Template,BaseName)=Element
		i Type="C" d
		.s OneSetType=$P(OneSetInfo,"^",2)
		.s OneSet=$P(OneSetInfo,"^",3,OneLength)
		.s ^DHCPESpecialReportInfo(Template,OneSetType,Element)=OneSet
		.
		
		
	}
	q "OVER"
}

ClassMethod GetVIPDescByID(VIPID)
{
	//w ##class(web.DHCPE.VIPLevel).GetVIPDescByID(5)
	q:VIPID="" ""
	Q:'$D(^DHCPEVIPLevel("VIP",VIPID)) ""
	s Desc=$P($G(^DHCPEVIPLevel("VIP",VIPID)),"^",2)
	q Desc
}

ClassMethod GetVipApprove()
{
	s flag=0
	i $d(^DHCPEVIPLevel("VIPapprove")) s flag=1
	e  s flag=0 
	q flag
}

ClassMethod SetDefaultVIP(UserID, VIPLevel)
{
	s ^DHCPEDataEx("DefaultVIPLevel",UserID)=VIPLevel
	q 0
}

ClassMethod OutSplitTypeToHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("SplitType","")
	w "<option value=''> </option>",!
	s selected=""
	s:DefaultValue="item" selected="selected"
	w "<option value='item' "_selected_">项目</option>",!
	s selected=""
	s:DefaultValue="person" selected="selected"
	w "<option value='person' "_selected_">人员</option>",!
	s selected=""
	s:DefaultValue="group" selected="selected"
	w "<option value='group' "_selected_">分组</option>",! 
	w "</select>",!
	Quit $$$OK
}

}
