Import sqluser

Class web.INSUTarContrastCom Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 176;

ClassMethod GetTarCateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTarCateExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.INSUTarContrastCom","GetTarCate","")

ClassMethod GetTarCateExecute(ByRef qHandle As %Binary, GroupId As %String = "", HospDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s rowid="0",desc="全部",code="" ;为空时显示异常，前台处理
	s:($g(%session)'="")&&(+HospDr=0) HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s TarCateStr=##class(web.INSUDicDataCom).GetDicByCodeAndInd("GroupIdToTarCate",GroupId,6,HospDr)	
	d BuildTarCate
	s rowid="0"
	f  s rowid=$o(^DHCTarC("CC",rowid)) q:rowid=""  d
	.s s=$g(^DHCTarC("CC",rowid))
	.s code=$p(s,"^",1)
	.s desc=$p(s,"^",2)
	.;+2019-7-30 tangzf 医院授权判断 start
	.s CheckHosipitalSession=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("DHC_TarCate",rowid,"","","Y")
	.q:CheckHosipitalSession'="Y" ; 该院区无权查看该数据
	.;+2019-7-30 tangzf 医院授权判断 end
	.//s hidflag=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DHCTARHID",rowid,0,HospDr)	
	.//q:hidflag'=""	;如果在不显示的费用分类列表中则退出。Zhan 20151224
	.q:(TarCateStr'="")&&(("|"_TarCateStr_"|")'[("|"_code_"|")) // 不在安全组到费用分类对照中的则退出 tangzf 2019-12-19
	.d BuildTarCate
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCate      
	set Data=$lb(rowid,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetTarCateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTarCateExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetTarCate(GroupId As %String = "") As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod DhcTarQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DhcTarQueryExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

// add liusf 2010 08 26           

Query DhcTarQuery(sKeyWord As %String, Class As %String, Type As %String, ConType As %String, TarCate As %String, ActDate As %String, ExpStr As %String) As %Query(ROWSPEC = "Record:%String,TarId:%String,HisCode:%String,HisDesc:%String,DW:%String,Cate:%String,SubCate:%String,Price:%String,ConId:%String,InsuId:%String,InsuCode:%String,InsuDesc:%String,ConQty:%String,InsuGG:%String,InsuDW:%String,InsuSeltPer:%String,InsuCate:%String,InsuClass:%String,conActDate:%String,Index:%String,LimitFlag:%String,factory:%String,HISPutInTime:%String,Demo:%String,UserDr:%String,ConDate:%String,ConTime:%String,conExpiryDate:%String,PZWH:%String,HISDosage:%String,HISSpecification:%String,AuditUser,AuditDate,AuditTime,conAddFlag,TARIInsuCode,TARIInsuName") [ SqlProc ]
{
}

/// Creator: tangzf
/// CreateDate: 2020-06-24
/// Descript: 查询 医保目录对照数据(包括HIS收费项及对照记录)
/// Input:		sKeyWord : 关键字(与Class结合使用)
/// 			Class ： 关键字类型 (与sKeyWord结合使用) 1:按拼音， 2：按代码 ，3：按名称
/// 			Type : 医保类型 (ZZB)
/// 			废弃->ConType :	对照关系 A: 所有， Y：已对照， N：未对照， 0：未上传 ，1： 已上传， 2：未审核 ，3：已审核
/// 				ConType :	对照关系  A: 所有 0：已对照未审核未上传 ，1： 已上传， 2：医保中心审核通过 ，3：医保中心审核不通过，4：HIS审核通过，5:HIS审核不通过
/// 			TarCate : 收费项大类RowId
/// 			ActDate : 对照生效日期
/// 			ExpStr : PrtFlag(作废，不用) ^ 收费项有效日期 ^ 院区ID（最小院区未分组）
/// Output: 
/// Return: 
/// DeBug: 
/// D ##class(%ResultSet).RunQuery("web.INSUTarContrastCom","DhcTarQuery","aspl","1","BJ","A","","2017-03-09","")
ClassMethod DhcTarQueryExecute(ByRef qHandle As %Binary, sKeyWord As %String, Class As %String, Type As %String, ConType As %String, TarCate As %String, ActDate As %String, ExpStr As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	i Type="" goto L1       ;add by liusf 2007 07 26
	s ^CacheTemp("INSUDHCTarQuery")=$p($h,",",2)
	s:$l(ActDate)>4 ActDate=##class(websys.Conversions).DateHtmlToLogical(ActDate)	;Zhan 20170309
	s PrtFlag=$p(ExpStr,"|",1) // 分割符由 ^ 修改为 |   因为^ 与 参数分隔符冲突  tangzf 2019-12-19
	s TarDate=$p(ExpStr,"|",2) // 收费项目日期
	s selHosDr=+$p(ExpStr,"|",3) // 选择的医院ID
	s QueryType=+$p(ExpStr,"|",4)  //查询类型  如果不为空 则从临时Global中取数据 QueryType=repid= 上次查询保存的repid
	s ^TMPtangzf("DhcTarQueryExecute","Start")=$lb(sKeyWord , Class, Type , ConType, TarCate , ActDate , ExpStr)
	//i QueryType'=0 goto Build2   //-DingSH 20220816
	s:TarDate'="" TarDate=##class(websys.Conversions).DateHtmlToLogical(TarDate)
	i selHosDr'=0 d
	.s ^||TMPSELHOSDR("DhcTarQuery",$j)=selHosDr
	s cateStr = ..GetUnConCateIdStr(selHosDr)
	s ^CacheTemp("INSUDHCTarQuery",1)=$p($h,",",2)-^CacheTemp("INSUDHCTarQuery")
	s flag=$$QueryAll^DHCINSUTarContrast(sKeyWord,Class,Type,ConType,TarCate,ActDate,selHosDr)
	s:Class="4" sKeyWord=##class(websys.Conversions).DateLogicalToHtml(sKeyWord) ;Zhan 20170309	
	s index=0
	s id=""
	;s (HisCode,HisDesc,DW,Cate,SubCate,Price,InsuCode,InsuDesc,InsuGG,InsuDW,InsuSeltPer,InsuCate,InsuClass,conActDate,LimitFlag,FactoryName,UserDr,ConDate,PZWH,JX,GG)=""
	s (HisCode,HisDesc,DW,Cate,SubCate,Price,InsuCode,InsuDesc,InsuGG,InsuDW,InsuSeltPer,InsuCate,InsuClass,conActDate,LimitFlag,FactoryName,UserDr,ConDate,ConTime,conExpiryDate,PZWH,HISDosage,HISSpecification,AuditUser,AuditDate,AuditTime,conAddFlag,JX,GG)=""
	s TARIInsuCode="",TARIInsuName=""  ; hyw 20221202 取国家医保编码
	;w "查询出的数据在:^CacheTemp(TAR,"_flag_",  临时globla节点下。",!
	s ^CacheTemp("INSUDHCTarQuery",2)=$p($h,",",2)-^CacheTemp("INSUDHCTarQuery")
	f  s id=$o(^CacheTemp("TAR",flag,id)) q:id=""  d
	.s s=$g(^CacheTemp("TAR",flag,id))
	.s TarId=$p(s,"^",1)
	.s TmpTarDate=$p($g(^DHCTARI(TarId)),"^",11)
	.q:(TarDate'="")&&(TarDate>TmpTarDate) // 增加收费项日期判断 tangzf 2019-12-19
	.//------Zhan 2013-11-30 --->
	.s VirFlag=$p($g(^DHCTARI(TarId)),"^",17)	//specialFlag
	.;q:(##class(web.DHCINSUPortUse).GetTarItemActive(TarId)="N")&(VirFlag'="Y")	;20181115医嘱结构改造后注释
 	.;q:(##class(web.DHCINSUPortUse).GetTarItemActiveByOlt(TarId)="N")&(VirFlag'="Y") ;20181115医嘱结构改造后注释
 	.;q:(##class(web.DHCINSUPortUse).GetTarItemActiveByARCIMItemCat(TarId)="N")&(VirFlag'="Y") ;20181115医嘱结构改造后注释
 	.;q:(##class(web.DHCINSUPortUse).GetTarItemActiveByOltDate(TarId)="N")&(VirFlag'="Y") ;20181115医嘱结构改造后注释
 	.;q:(##class(web.DHCINSUPortUse).GetTarItemActiveFlag(TarId,"",selHosDr)="N")&(VirFlag'="Y") ; 8000条数据 1.2秒左右20220713
 	.;q:(##class(web.DHCINSUPortUse).GetTarItemActiveFlag(TarId,"",selHosDr,TarDate)="N")&(VirFlag'="Y") //WangXQ 20220713增加未启用收费项日期查询
 	.s TarItemActiveFlag=""
 	.i +QueryType=0 d
 	..s TarItemActiveFlag=##class(web.DHCINSUPortUse).GetTarItemActiveFlag(TarId,"",selHosDr,TarDate,cateStr) //+DingSH 20220816
 	..s ^INSUDHCTarQuery(TarId,selHosDr,"TarItemActiveFlag")=TarItemActiveFlag
 	.e  d
 	..s TarItemActiveFlag=^INSUDHCTarQuery(TarId,selHosDr,"TarItemActiveFlag")
    .q:(TarItemActiveFlag="N")&(VirFlag'="Y") //WangXQ 20220713增加未启用收费项日期查询
	.s HisCode=$p(s,"^",2)
	.s HisDesc=$p(s,"^",3)
	.s ConIdString=$p(s,"^",4) 
	.;s TarString=$$GetTarDetail^DHCINSUTarContrast(TarId,selHosDr)
	.s TarString=""
	.i +QueryType=0 d
	..s TarString=$$GetTarDetail^DHCINSUTarContrast(TarId,selHosDr) //+DingSH 20220816
 	..s ^INSUDHCTarQuery(TarId,selHosDr,"TarInfo")=TarString
 	.e  d
 	..s TarString=^INSUDHCTarQuery(TarId,selHosDr,"TarInfo")
	.s PZWH=$p(TarString,"^",13) //	;取批准文号
	.S Dosage=$P(TarString,"^",11) 
	.s TARIInsuCode=$p($g(^DHCTARI(TarId)),"^",59)	
	.s TARIInsuName=$p($g(^DHCTARI(TarId)),"^",48)
	.S Specification=$P(TarString,"^",12) //规格
	.s DW=$p(TarString,"^",4), Cate=$p(TarString,"^",5) , SubCate=$p(TarString,"^",6) , Price=$p(TarString,"^",7)
	.;q:(SubCate="化学试剂材料")!(SubCate="检验试剂材料")!(SubCate="病理试剂材料")      //医保办要求不收费的检验项目（共500多条）不需要显示，gcj 2009-06-09
	.s FactoryName=$P(TarString,"^",14) 	;厂家	Zhan 20191009
	.s tcode=$p(TarString,"^",2)      //tarcode
	.;i ($d(^PHCD(0,"Code",tcode)) & FactoryName="") d //tangzf2020-6-15 通过药房接口取数据 -
	.;.s Facrowid=$o(^PHCD(0,"Code",tcode,0))                          //PHC_DrgMast
	.;.s:Facrowid'="" PHCDPHMNFDR=$p($g(^PHCD(Facrowid,"2")),"^",4)    //PH_Manufacturer 表rowid
	.;.s:PHCDPHMNFDR'="" FactoryName=$p($g(^PHMNF(PHCDPHMNFDR)),"^",2) //厂家名称
	.;s HISPutInTime=$zd($p($g(^DHCTARI(TarId)),"^",11),3)             //药品录入时间
	.s HISPutInTime=""
	.s:+$p($g(^DHCTARI(TarId)),"^",11)>0 HISPutInTime=##class(websys.Conversions).DateLogicalToHtml($p($g(^DHCTARI(TarId)),"^",11)) ;Zhan 20170309
	.s LimitFlag=$p($g(^DHCTARI(TarId)),"^",13)                       //限药标志 added by gcj 2009-08-31
	.s Demo=$p($g(^DHCTARI(TarId)),"^",19)                            //备注  added by gcj 2009-08-31
	.q:(Class="5")&(LimitFlag="")
	.s ConCount=$l(ConIdString,"!")
	.s ConId="", InsuId="", InsuCode="", InsuDesc="", ConQty="", InsuGG="", InsuDW="", InsuSeltPer="",conActDate="", InsuCate="", InsuClass="",conExpiryDate=""
	.s (UserDr,ConDate,ConTime)=""
	.i ConCount<=1  d
	..s index=index+1  								  //modified by gcj 2009-04-24 增加序号   衢州人民医院提出                           
	..d Build
	.e  d
	..f ConIndex=2:1:2 d                       ;默认只取最后一条有效记录 ConCount
	...s ConId=$p(ConIdString,"!",ConIndex)
	...s ConString=$$GetContDetail^DHCINSUTarContrast(ConId)
	...s InsuId=$p(ConString,"^",4)    
	...s ConQty=$p(ConString,"^",10)
	...s conExpiryDate=$p(ConString,"^",20)
	...// tangzf 2020-6-1 add 院内审核信息
	...s conAddFlag=+$p(ConString,"^",11)
	...s conAddFlag=##class(web.INSUDicDataCom).GetDicByCodeAndInd("TarContrastAuditCode",conAddFlag,4,selHosDr)
	...s AuditUser=$p(ConString,"^",28)
	...s:+AuditUser'=0 AuditUser=$p($g(^SSU("SSUSR",AuditUser)),"^",2) 
	...s AuditDate=$p(ConString,"^",29)
	...S:AuditDate'="" AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
	...s AuditTime=$p(ConString,"^",30)
	...s:AuditTime'="" AuditTime=##class(websys.Conversions).TimeLogicalToHtml(AuditTime)
	...// tangzf 2020-6-1 院内审核信息end
	...;s:conExpiryDate'="" conExpiryDate=$zd(conExpiryDate,3)
	...s:+conExpiryDate>0 conExpiryDate=##class(websys.Conversions).DateLogicalToHtml(conExpiryDate) ;Zhan 20170309
	...s UserDr=$p(ConString,"^",15) 
	...i UserDr'="" d
	....s:($d(^SSU("SSUSR",UserDr))) UserDr=$p($g(^SSU("SSUSR",UserDr)),"^",2)
	...;s:$p(ConString,"^",16)'="" ConDate=$zd($p(ConString,"^",16),3) 
	...s:+$p(ConString,"^",16)>0 ConDate=##class(websys.Conversions).DateLogicalToHtml($p(ConString,"^",16)) ;Zhan 20170309
	...;s:$p(ConString,"^",17)'="" ConTime=$zt($p(ConString,"^",17),1) 
	...s:+$p(ConString,"^",17)>0 ConTime=##class(websys.Conversions).TimeLogicalToHtml($p(ConString,"^",17)) ;Zhan 20170309
	...s conActDate=$p(ConString,"^",13)
	...s conActDate=##class(websys.Conversions).DateLogicalToHtml($p(ConString,"^",13)) ;Zhan 20170309
	...s index=index+1
	...i InsuId'="" d
	....s InsuString=$$GetInsuDetail^DHCINSUTarItems(InsuId)
	....s InsuCode=$p(InsuString,"^",3)
	....s InsuDesc=$p(InsuString,"^",4)
	....s InsuGG=$p(InsuString,"^",9)
	....s InsuDW=$p(InsuString,"^",10)
	....s InsuSeltPer=$p(InsuString,"^",18)
	....s InsuCate=$p(InsuString,"^",1)  		;$p(InsuString,"^",38)    ;
	....s:InsuCate'="" InsuCate=##class(web.INSUDicDataCom).GetDicByCodeAndInd("FeeType"_Type,InsuCate,4,selHosDr)	//Zhan 20150711
	....s InsuClass=$p(InsuString,"^",23)
	....s:InsuClass'="" InsuClass=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKA065",InsuClass,4,selHosDr)	//Zhan 20150711
	...d Build
	k ^CacheTemp("TAR",flag)
	s ^CacheTemp("INSUDHCTarQuery",3)=$p($h,",",2)-^CacheTemp("INSUDHCTarQuery")
	b //end
	//-----------------------------Zhan 2012-03-15 记录repid和打印行数的值------------>
	;s scval="document.getElementById("_"'Repid'"_").value='"_repid_"';"
	;s scval=scval_"document.getElementById("_"'PrtRowCnt'"_").value='"_ind_"';"
	s scval="var repidsub="_repid_";"
	s scval=scval_"var PrtRowCnt="_ind_";"
	;s retval="alert('"_$ZCVT(repid,"O","JS")_"');"
	;&javascript<#(retval)#>
	i $g(PrtFlag)="Y" d
	.w !,"<script type='text/javascript'>"_scval_"</script>"
	//--------------------------------------------------------------------------------//

	/*
	s indsub=ind/25
	if indsub<1  d
	.s indsub=1
	s indsub=$fn(indsub,"",0)
	w !,"总计数据:"_ind_" 条,  每页25条数据,共:"_indsub_" 页"
	*/
	i $d(^||TMPSELHOSDR("DhcTarQuery",$j)) k ^||TMPSELHOSDR("DhcTarQuery",$j)
L1	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

Build  
	//s:($p(InsuSeltPer,".",1)="")&(InsuSeltPer'="") InsuSeltPer="0"_InsuSeltPer
	set InsuSeltPer=$fn(InsuSeltPer,"",2)
	//s:$p(Price,".",1)="" $p(Price,".",1)=0
	set Price=$fn(Price,"",2)
	set Data=$lb(repid,TarId,HisCode,HisDesc,DW,Cate,SubCate,Price,ConId,InsuId,InsuCode,InsuDesc,ConQty,InsuGG,InsuDW,InsuSeltPer,InsuCate,InsuClass,conActDate,index,LimitFlag,FactoryName,HISPutInTime,Demo,UserDr,ConDate,ConTime,conExpiryDate,PZWH,Dosage,Specification,$g(AuditUser),$g(AuditDate),$g(AuditTime),$g(conAddFlag),TARIInsuCode,TARIInsuName)
 	Set ^CacheTemp(repid,ind)=Data
 	b //要导出的数据->																																	
 	s:ind=1 ^CacheTemp("INSUTCCExport",repid,0)="收费项目ID^医院编码^医院名称^单位^收费类别^收费子类^单价^对照Id^医保Id^医保代码^医保名称^对照数量^医保规格^医保单位^自付比例^医保费用类别^项目等级^生效日期^对照数^限制标志^厂家^导入日期^备注^操作员^对照日期^对照失效时间^批准文号" //^HIS剂型^HIS规格^对照审核人^对照审核日期^对照审核时间^对照审核状态"
 	;s ^CacheTemp("INSUTCCExport",repid,ind)=TarId_"^"_HisCode_"^"_HisDesc_"^"_DW_"^"_Cate_"^"_SubCate_"^"_Price_"^"_ConId_"^"_InsuId_"^"_InsuCode_"^"_InsuDesc_"^"_ConQty_"^"_InsuGG_"^"_InsuDW_"^"_InsuSeltPer_"^"_InsuCate_"^"_"A"_"^"_conActDate_"^"_index_"^"_LimitFlag_"^"_FactoryName_"^"_HISPutInTime_"^"_Demo_"^"_UserDr_"^"_ConDate_"^"_conExpiryDate_"^"_PZWH
 	//s ^CacheTemp("INSUTCCExport",repid,ind)=TarId_"^"_HisCode_"^"_HisDesc_"^"_DW_"^"_Cate_"^"_SubCate_"^"_Price_"^"_ConId_"^"_InsuId_"^"_InsuCode_"^"_InsuDesc_"^"_ConQty_"^"_InsuGG_"^"_InsuDW_"^"_InsuSeltPer_"^"_InsuCate_"^"_"A"_"^"_conActDate_"^"_index_"^"_LimitFlag_"^"_FactoryName_"^"_HISPutInTime_"^"_Demo_"^"_UserDr_"^"_ConDate_"^"_ConTime_"^"_conExpiryDate_"^"_PZWH_"^"_Dosage_"^"_Specification_"^"_$g(AuditUser)_"^"_$g(AuditDate)_"^"_$g(AuditTime)_"^"_$g(conAddFlag)	;upt 20220815 HanZH
 	s ^CacheTemp("INSUTCCExport",repid,ind)=$LISTTOSTRING(Data,"^",1) //DingSH 20220816
 	//-------------//
 	Set ind=ind+1
 	q
Build2 //从临时Global取数据
	quit:'$d(^CacheTemp("INSUTCCExport",QueryType))
	set TmpIndex=0
	for  set TmpIndex=$o(^CacheTemp("INSUTCCExport",QueryType,TmpIndex))  quit:TmpIndex=""  d
	.set Data=$g(^CacheTemp("INSUTCCExport",QueryType,TmpIndex))
	.d Global2List
 	.Set ^CacheTemp(repid,ind)=Data
 	.Set ind=ind+1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Global2List
	set GlobalLen=$l(Data,"^")
	set TmpData=$lb(QueryType)
	for GlobalIndex=1:1:GlobalLen  d
	.set $list(TmpData,GlobalIndex+1)=$p(Data,"^",GlobalIndex) //第一位是序号
	set Data=TmpData
	q
}

ClassMethod DhcTarQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DhcTarQueryExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 	       	s RecordSum=$o(^CacheTemp(repid,""),-1)     //新增ㄛ获取总记录数   2010 08 26
		    //s $List(^CacheTemp(repid,ind),1)=RecordSum  //新增ㄛ替换每条记录的第一列数据  2010 08 26
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// D ##class(%ResultSet).RunQuery("web.INSUTarContrastCom","DhcTarQuery","2009-04-08","4","QZB2","A","","")

// w ##class(web.INSUTarContrastCom).Update("","","^5175^0000004^抗生素药^441396^140040101010104010102000000000000^阿司匹林肠溶片^^^^^^2013-03-28^^BJ^1^TEST^TEST^^^^^^^")

ClassMethod Update(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "") As %Library.String
{
	q:InString="" -100
	s flag=$$SaveCont^DHCINSUTarContrast(InString)
	q:flag<0 flag    ;add by lilizhi 2013-03-28    sql失败直接返回SQLCODE
	s Update=flag
	s HisDr=$p(InString,"^",2)
	s INTCTDr=$o(^DHCINTCT("0","DHCTID",HisDr,""),-1)
	s:INTCTDr'="" Update=INTCTDr ;Lou 2010-09-03 在目录对照界面需要获得对照ID
	q Update
}

ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", ContId As %Library.String = "")
{
	q:ContId=""
	q:$d(^DHCINTCT(ContId))=0 0
	s ConString=$g(^DHCINTCT(ContId))
	s tarid=$p(ConString,"^",1)
	s InsuId=$p(ConString,"^",4)
	s ConQty=$p(ConString,"^",10)
	s type=$p(ConString,"^",12)
	s UpdateUser=%session.Get("LOGON.USERNAME")
	;s UpdateDate=$zd($h,8)_" "_$zt($p($h,",",2),2)
	s UpdateDate=##class(websys.Conversions).DateLogicalToHtml($h)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($h,",",2))
	s UpStr=UpdateUser_"|"_UpdateDate
	s conActDate=$p(ConString,"^",13)
	s Str=tarid_"^"_"^"_"^"_InsuId_"^"_"^"_"^"_"^"_"^"_"^"_ConQty_"^"_"^"_type_"^"_conActDate_"^"_UpStr
	i $d(^INTCTHistory(tarid))=0  d
	.s ^INTCTHistory(tarid,1)=Str
	e  d
	.s tmpid=$o(^INTCTHistory(tarid,""),-1)+1
	.s ^INTCTHistory(tarid,tmpid)=Str
	s flag=$$DeleteCont^DHCINSUTarContrast(ContId)
	q flag
}

/// 目录对照数据导入
ClassMethod CheckInCont(Instring As %Library.String) As %Library.String
{
	;s Instring="^27010000100^尸检病理诊断^000005_SI^检查费^LFA^1^2010-5-10^^^"
	q:Instring="" -1
	s hiscode=$p(Instring,"^",2)
	s hidesc=$e($p(Instring,"^",3),1,29)
	s insucode=$p(Instring,"^",4)
	s insudesc=$e($p(Instring,"^",5),1,29)
	s type=$p(Instring,"^",6)
	s Qty=+$p(Instring,"^",7)
	s ActiveDate=$p(Instring,"^",8)
	q:hiscode="" -1011
	q:insucode="" -1021
	;s hiscode=$ZCVT(hiscode,"U")
	s hiscode=$$ALPHAUP^SSUTIL4(hiscode)    ;2009 03 18
	;s insucode=$ZCVT(insucode,"U")
	s insucode=$$ALPHAUP^SSUTIL4(insucode)    ;2009 03 18
	q:$d(^DHCTARI(0,"Code",hiscode))=0 -1012
	;s Insuid=""
	///s Tarid=hiscode
	q:$O(^DHCINTIM("0","CODE",insucode))=0 -1022
	s Tarid=""
	s Tarid=$o(^DHCTARI(0,"Code",hiscode,Tarid))
	s tempid="",Insuid=""
	f  s tempid=$O(^DHCINTIM("0","CODE",insucode,tempid)) q:tempid=""  d
	.i $p(^DHCINTIM(tempid),"^",2)=type d
	..s Insuid=tempid
	q:Insuid="" -1032
	s XString=""
	s $p(XString,"^",1)=""
    s $p(XString,"^",2)=Tarid
    s $p(XString,"^",3)=hiscode
    s $p(XString,"^",4)=hidesc
    s $p(XString,"^",5)=Insuid
    s $p(XString,"^",6)=insucode
    s $p(XString,"^",7)=insudesc
    s $p(XString,"^",8)=""
    s $p(XString,"^",9)=""
    s $p(XString,"^",10)=""
    s $p(XString,"^",11)=1
    s $p(XString,"^",12)=""
    s $p(XString,"^",13)=ActiveDate
    s $p(XString,"^",14)=""
    s $p(XString,"^",15)=type
    s flag=..Update("","",XString)
	s CheckInCont=flag
	q CheckInCont
}

/// 目录对照数据导入
/// w ##class(web.INSUTarContrastCom).SaveInCont("^309618**0^胰体尾切除术(经腹腔镜)^309618**0^胰体尾切除术(经腹腔镜)^WHB1^1^2011-01-01^^^") 
/// w ##class(web.INSUTarContrastCom).SaveInCont("^302884**0^^23315030170001^^WHA^1^2008-1-1^^^") 
/// 新增院区 20200319 tangzf 20200319 第26位
ClassMethod SaveInCont(Instring As %Library.String) As %Library.String
{
	;s Instring="^302884**0^^23315030170001^^WHA^1^2008-1-1^^^"
	n (Instring)
	q:Instring="" -1
	s hiscode=$p(Instring,"^",2)
	s hidesc=$e($p(Instring,"^",3),1,29)
	s insucode=$p(Instring,"^",4)
	s insudesc=$e($p(Instring,"^",5),1,29)
	s type=$p(Instring,"^",6)
	s Qty=+$p(Instring,"^",7)
	s ActiveDate=$p(Instring,"^",8)
	q:hiscode="" -1011
	q:insucode="" -1021
	;s hiscode=$ZCVT(hiscode,"U")
	;s insucode=$ZCVT(insucode,"U")
	s insucode2=$$ALPHAUP^SSUTIL4(insucode) ;去掉数字字母之外的字符 2008 10 15
	s hiscode2=$$ALPHAUP^SSUTIL4(hiscode) ;去掉数字字母之外的字符 2008 10 15
	;w insucode2_"^"_insucode,!
	q:($d(^DHCTARI(0,"Code",hiscode))=0)&($d(^DHCTARI(0,"Code",hiscode2))=0) -1012
	;s Insuid=""
	///s Tarid=hiscode
	q:($O(^DHCINTIM("0","CODE",insucode))=0)&($O(^DHCINTIM("0","CODE",insucode2))=0) -1022
	s Tarid=""
	;s Tarid=$o(^DHCTARI(0,"Code",hiscode,Tarid))
	;s:Tarid="" Tarid=$o(^DHCTARI(0,"Code",hiscode2,Tarid))
	s TmpTarid=""
	f  s TmpTarid=$o(^DHCTARI(0,"Code",hiscode2,TmpTarid)) q:TmpTarid=""  d
	.s TarDesc=$p($g(^DHCTARI(TmpTarid)),"^",2)
	.s TarCode=$p($g(^DHCTARI(TmpTarid)),"^",1)
	.;i hidesc=TarDesc d
	.i TarCode=hiscode d
	..s Tarid=TmpTarid
	..;w "Tarid="_Tarid,!
	q:Tarid="" -1013
	s tempid="",Insuid=""
	f  s tempid=$O(^DHCINTIM("0","CODE",insucode2,tempid)) q:tempid=""  d
	.s INTIMxmbm=$p(^DHCINTIM(tempid),"^",3)
	.s NTIMsfxmbm=$p(^DHCINTIM(tempid),"^",2)
	.i (NTIMsfxmbm=type)&(INTIMxmbm=insucode) d
	..s Insuid=tempid
	..;w "Insuid"_Insuid,!
	q:Insuid="" -1023
	s XString=""
	s $p(XString,"^",1)=""
	s $p(XString,"^",2)=Tarid
	s $p(XString,"^",3)=hiscode
	s $p(XString,"^",4)=hidesc
	s $p(XString,"^",5)=Insuid
	s $p(XString,"^",6)=insucode
	s $p(XString,"^",7)=insudesc
	s $p(XString,"^",8)=""
	s $p(XString,"^",9)=""
	s $p(XString,"^",10)=""
	s $p(XString,"^",11)=1
	s $p(XString,"^",12)=""
	s $p(XString,"^",13)=ActiveDate
	s $p(XString,"^",14)=""
	s $p(XString,"^",15)=type
	s $p(XString,"^",26)=$p(Instring,"^",9) // 2019-11-13 hospital
	s flag=..Update("","",XString)
	s CheckInCont=flag
	q CheckInCont
}

// 更新收费项目的外部码

// add liusf 2008 10 23

ClassMethod UpdateExCode(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "") As %Library.String
{
	q:InString="" -100
	s HisId=$p(InString,"^",1)
    s ExternalCode=$p(InString,"^",7)
    &sql(update dhc_taritem set tari_ExternalCode=:ExternalCode where tari_rowid=:HisId)
	s Update=SQLCODE
	q Update
}

// 按《药品类医保》或《诊疗类医保》的格式获得导出程序

// InStr  Tarid^Type   :Tarid是dhc_taritem的rowid  Type若药品为“YP ” 否则为“ZL”

// w ##Class(web.INSUTarContrastCom).GetPrint("","","7799^YP")

// ?? 何处使用

ClassMethod GetPrint(itmjs As %Library.String = "", itmjsex As %Library.String = "", InStr As %Library.String = "")
{
	s Tarid=$P(InStr,"^",1)
	q:Tarid="" ""
	s Type=$P(InStr,"^",2)
	q:Type="" ""
	s OutStr=""
	i Type="YP" d
	.s OutStr=$$GetPrintYP^DHCINSUTarContrast(Tarid)
	e  d
	.s OutStr=$$GetPrintZL^DHCINSUTarContrast(Tarid)
    q OutStr
}

// w ##class(web.INSUTarContrastCom).SetInsuTarConALL()

ClassMethod SetInsuTarConALL() As %Library.String
{
	s Tarid=""
	s UpdateStr=""
	s GetDHCTaritemALL=""
	f  s Tarid=$o(^DHCTARI(Tarid)) q:Tarid=""  d
	.s s=$g(^DHCTARI(+Tarid))
    .s HisCode=$p(s,"^",1)
    .s HisDesc=$p(s,"^",2)
	.s InsuCode=HisCode
	.s InsuDesc=HisDesc
	.s UpdateStr="^"_HisCode_"^"_HisDesc_"^"_InsuCode_"^"_InsuDesc_"^"_"QHDA"_"^"_"1"_"^"_"2010-10-15"
	.s GetDHCTaritemALL=##class(web.INSUTarContrastCom).SaveInCont(UpdateStr)
	q GetDHCTaritemALL
}

// w ##class(web.INSUTarContrastCom).GetDHCTarItemALL()

ClassMethod GetDHCTarItemALL() As %Library.String
{
	s InsuPID=$I(^CacheTemp("TAR"))			//增量函数$Increment(number[,num]),将变量增加1或者指定的值
	k ^CacheTemp("TAR",InsuPID)
	s i=1
	s Tarid=0
	s tCate=""
	f  s Tarid=$o(^DHCTARI(Tarid)) q:Tarid=""  d
	.s s=$g(^DHCTARI(+Tarid))
    .s tCode=$p(s,"^",1)
    .s tDesc=$p(s,"^",2)
	.s tSubcate=$p(s,"^",4)
	.;s:tSubcate'="" tSubcateDesc=$p($g(^DHCTarC("SC",tSubcate)),"^",2)
	.s:tSubcate'="" tCate=$p($g(^DHCTarC("SC",tSubcate)),"^",3)
	.;w !,Tarid_"^"_tSubcate_"^"_tCate
	.s:tCate'="" tCateCode=$p($g(^DHCTarC("CC",tCate)),"^",1)		;modefy by zhangdongliang 2010-11-08
	.s:tCate'="" tCateDesc=$p($g(^DHCTarC("CC",tCate)),"^",2)
	.s DicType="FeeTypeConQHDA"
	.;s:Type="QHDB" DicType="FeeTypeConQHDB"
	.s TarCateMC=$$QueryByCode^DHCINSUDicData(DicType,tCateCode)
	.s TarInsuCate=$p(TarCateMC,"^",6)	
	.s ^CacheTemp("TAR",InsuPID,i)=Tarid_"^"_tCode_"^"_tDesc_"^"_TarInsuCate
	.s i=i+1
	q i-1_"|"_InsuPID
}

// w ##class(web.INSUTarContrastCom).GetDHCTarInfoFromCache("1","1")

ClassMethod GetDHCTarInfoFromCache(ID, index) As %Library.String
{
	;Tarid_"^"_tCode_"^"_tDesc_"^"_TarInsuCate
    new (ID,index)
    s outstr=""
    s outstr=$g(^CacheTemp("TAR",ID ,index))
    i $O(^CacheTemp("TAR",ID,""),-1)=index d
    .k ^CacheTemp("TAR",ID)
    q outstr
}

// w ##class(web.INSUTarContrastCom).UpdateDHCTarItem("3","2187","甲类")

ClassMethod UpdateDHCTarItem(ID, index, tjdm) As %Library.String
{
		;"441490^0^LFA^140070509010218190400000000000000^肌苷葡萄糖注射液^^^1^^^^^^^^^^^^^^^^甲类^Y^Y^^^^^^^^^^^0101^^1^^1840-12-31^"
	;InStr="^2^LFA^000002^中成1药费^ZCYF^^0^^^^^^^^^^^^^^^^普通检查治疗^^^^^^^^^^^^^^"

	;s i=""
	;f  s i=$o(^CacheTemp("TAR",InsuPID,i)) q:i=""  d
	s s=$g(^CacheTemp("TAR",ID,index))
	s TarId=$p(s,"^",1)
	s HisCode=$p(s,"^",2)
	s HisDesc=$p(s,"^",3)
	s HisDesc=$e(HisDesc,0,30)
	s TarInsuCate=$p(s,"^",4)	
	s InString=""_"^"_TarInsuCate_"^"_"QHDA"_"^"_HisCode_"^"_HisDesc_"^^^"_TarInsuCate_"^^^^^^^^^^^^^^^^"_tjdm_"^^^^^^^^^^^^^^^^^^"
	q:InString=""
    s flag=$$SaveINTIM^DHCINSUTarItems(InString)
	q flag
}

// w ##class(web.INSUTarContrastCom).UpdateConByWHBNo("WHB1")

ClassMethod UpdateConByWHBNo(TariType) As %Library.String
{
	s OutStr=""
	s OutStrSum=""
	s OutStrTMP=""

	s Type="TariType"
	s Code=""
	s OutString=$$Query^DHCINSUDicData(Type,Code)	
	s JustId=+$p(OutString,"^",2)
	s Index=""
	f  s Index=$o(^CacheTemp("INSUDic",JustId,Index)) q:Index=""  d
	.s DataString=$g(^CacheTemp("INSUDic",JustId,Index))
	.;w DataString,!
	.s id=$p(DataString,"^",1)
    .s cType=$p(DataString,"^",2)
    .s cCode=$p(DataString,"^",3)
    .s cDesc=$p(DataString,"^",4)
    .s cDemo=$p(DataString,"^",5)
    .s cBill1=$p(DataString,"^",6)
    .s cBill2=$p(DataString,"^",7)
    .s cCodeTMP=$e(cCode,1,3)
    .q:cCodeTMP'="WHB" 
    .q:cCode'=TariType
    
    .b "cCode"
    
    .;找sfxmbm=cCode
    
    .s i=0
    .s Tarid=0  
    .f  s Tarid=$o(^DHCTARI(Tarid)) q:Tarid=""  d
	..s s=$g(^DHCTARI(+Tarid))
	..q:s=""
    ..s tCode=$p(s,"^",1)
    ..s tDesc=$p(s,"^",2)
    ..s TIARowId=$o(^DHCTARAL("A",Tarid,""))   q:TIARowId=""  d
    ..s TIAAlias=$e($P(^DHCTARAL(TIARowId),"^",3),0,25)
    
    ..s sfxmbm=cCode
	..s xmbm=tCode
	..s code=$$ALPHAUP^SSUTIL4(xmbm) 
	
	..s INTIMID="" 
	..s SaveFlag="Y"
	..f  s INTIMID=$o(^DHCINTIM("0","CODE",code,INTIMID))   q:(INTIMID="")||(SaveFlag="N")  d
	...s INTIMsfxmbm=$p(^DHCINTIM(INTIMID),"^",2)
	...s INTIMxmbm=$p(^DHCINTIM(INTIMID),"^",3)
	...i (INTIMsfxmbm=sfxmbm)&(INTIMxmbm=xmbm)  d
	....s SaveFlag="N"
	
	..S InString=""
	..i SaveFlag="Y" d 
	...b "SaveFlag=Y"
	...s InString=""_"^^"_sfxmbm_"^"_tCode_"^"_tDesc_"^"_TIAAlias_"^^^^^^^^^^^^^100^^^^^^^^^^^^^^^^^^^^^^^"
	...b "InString"
	...s OutStrTMP=$$Insert^DHCINSUTarItems(InString)
	...s InString=""_"^"_tCode_"^"_tDesc_"^"_tCode_"^"_tDesc_"^"_sfxmbm_"^"_"1"_"^"_"2011-01-01"_"^^^"
	...s OutStrTMP=##class(web.INSUTarContrastCom).SaveInCont(InString) 
	...s i=i+1

	..s OutStr=cDesc_"("_cCode_")"_"^"_i			;增加目录编码^增加条数
		
	.s OutStrSum=OutStrSum_"!"_OutStr
	.b "OutStrSum"
	
	q OutStrSum
}

// 取打印数据

ClassMethod GetPrtDateByID(subID As %Library.String = "", Index As %Library.String = "") As %Library.String
{
	q:(subID="")||(Index="") -1
	//^CacheTemp("INSUTCCExport",repid,ind)
	q:$d(^CacheTemp("INSUTCCExport",subID,Index))=0 -2
	q $g(^CacheTemp("INSUTCCExport",subID,Index))
}

// 清除临时Global

ClassMethod ClearTmpGlobal(subID As %Library.String = "") As %Library.String
{
	;q:subID="" -1 tangzf 2020-11-20
	;2020-11-20 add
	i subID=""  d
	.k ^CacheTemp("INSUTCCExport")
	q:subID="" 1
	;2020-11-20 add
	q:$d(^CacheTemp("INSUTCCExport",subID))=0 1
	k ^CacheTemp("INSUTCCExport",subID)
	q 1
}

/// w ##class(web.INSUTarContrastCom).QueryInsuTarConInfo("CSB","","","")
ClassMethod QueryInsuTarConInfo(InsuType, Flag, ConDr, ActDate, HospDr As %String = "", ZText As %String = "") As %Library.String
{
	n (InsuType,Flag,ConDr,ActDate,HospDr,ZText)
	s gnum=0
	s index=0
	s id=""
	k ^CacheTemp("TarCon")
	s (sKeyWord, Class)="" 
	i ConDr'="" d ;Ding 20180308
	.s Class=2    ;按收费项目Code查询
	.s INTCTHisDr=$P($g(^DHCINTCT(ConDr)),"^",1)
	.s:INTCTHisDr'="" sKeyWord=$P(^DHCTARI(INTCTHisDr),"^",1)  ;HisTarCode
	
	//根据院区取医保分组默认院区的ID
	//s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_TarContrast",HospDr)
	
	s flag=$$QueryAll^DHCINSUTarContrast(sKeyWord,Class,InsuType,"Y","",ActDate,HospDr)
	f  s id=$o(^CacheTemp("TAR",flag,id)) q:id=""  d
	.s s=$g(^CacheTemp("TAR",flag,id))
	.s TarId=$p(s,"^",1)
	.s HisCode=$p(s,"^",2)
	.s HisDesc=$p(s,"^",3)
	.s ConIdString=$p(s,"^",4) 
	.s TarString=$$GetTarDetail^DHCINSUTarContrast(TarId)
	.s Price=$p(TarString,"^",7)
	.s DrgForm=$p(TarString,"^",9)	
	.s ConCount=$l(ConIdString,"!")
	.q:ConCount<=1
	.f ConIndex=2:1:2 d                       
	..s ConId=$p(ConIdString,"!",ConIndex)
	..q:(ConId'=ConDr)&&(ConDr'="") ;Ding 20180308
	..s ConString=$$GetContDetail^DHCINSUTarContrast(ConId)
	..;s conActDate=$zd($p(ConString,"^",13),3)
	..s conActDate=##class(websys.Conversions).DateLogicalToHtml($p(ConString,"^",13))	;Zhan 20170309
	..s UpFlag=$p(ConString,"^",11)  //INTCT_DrAddFlag
	..q:(UpFlag'="")&(Flag="")
	..s tmpZText=$p(ConString,"^",14) //INTCT_ZText
	..q:(tmpZText'=ZText)&(ZText'="")
	..s InsuId=$p(ConString,"^",4)    
	..i InsuId'="" d
	...s InsuString=$$GetInsuDetail^DHCINSUTarItems(InsuId)
	...s InsuString=InsuId_"^"_InsuString
	...s InsuString=$replace(InsuString,"|","*")
	...s xmlb=$p(InsuString,"^",1)
	...s InsuCode=$p(InsuString,"^",3)
	...s InsuDesc=$p(InsuString,"^",4)
	...s InsuJX=$p(InsuString,"^",8)
	...;s $p(ConString,"^",13)=$zd($p(ConString,"^",13),3)
	...s $p(ConString,"^",13)=##class(websys.Conversions).DateLogicalToHtml($p(ConString,"^",13))	;Zhan 20170309
	...;s $p(ConString,"^",16)=$zd($p(ConString,"^",16),3)
	...s $p(ConString,"^",16)=##class(websys.Conversions).DateLogicalToHtml($p(ConString,"^",16))	;Zhan 20170309
	...;s $p(ConString,"^",17)=$zt($p(ConString,"^",17),1)
	...s $p(ConString,"^",17)=##class(websys.Conversions).TimeLogicalToHtml($p(ConString,"^",17))	;Zhan 20170309
	...s ConString=ConId_"^"_ConString
	...s ^CacheTemp("TarCon",$j,gnum)=TarString_"|"_InsuString_"|"_ConString
	...s gnum=gnum+1
	q gnum_"|"_$j
}

/// w ##class(web.INSUTarContrastCom).QueryInsuTarConInfo("BJ","")
ClassMethod QueryInsuTarConInfoOld(InsuType, Flag) As %Library.String
{
	n (InsuType,Flag)
	s gnum=0
	s index=0
	s xcode=""
	k ^CacheTemp("TarCon")
	s flag=$$QueryAll^DHCINSUTarContrast("","",InsuType,"Y","","")
	f  s xcode=$o(^CacheTemp("TAR",flag,xcode)) q:xcode=""  d
	.s s=$g(^CacheTemp("TAR",flag,xcode))
	.s TarId=$p(s,"^",1)
	.s HisCode=$p(s,"^",2)
	.s HisDesc=$p(s,"^",3)
	.s ConIdString=$p(s,"^",4) 
	.s TarString=$$GetTarDetail^DHCINSUTarContrast(TarId)
	.s Price=$p(TarString,"^",7)
	.s DrgForm=$p(TarString,"^",9)	
	.s ConCount=$l(ConIdString,"!")
	.q:ConCount<=1
	.f ConIndex=2:1:2 d                       
	..s ConId=$p(ConIdString,"!",ConIndex)
	..s ConString=$$GetContDetail^DHCINSUTarContrast(ConId)
	..;s conActDate=$zd($p(ConString,"^",13),3)
	..s conActDate=##class(websys.Conversions).DateLogicalToHtml($p(ConString,"^",13))	;Zhan 20170309
	..s UpFlag=$p(ConString,"^",11)
	..q:(UpFlag'="")&(Flag="")
	..s conflag=$p(ConString,"^",14)
	..q:(conflag'=Flag)&(Flag'="")
	..s InsuId=$p(ConString,"^",4)    
	..i InsuId'="" d
	...s InsuString=$$GetInsuDetail^DHCINSUTarItems(InsuId)
	...s xmlb=$p(InsuString,"^",1)
	...s InsuCode=$p(InsuString,"^",3)
	...s InsuDesc=$p(InsuString,"^",4)
	...s InsuJX=$p(InsuString,"^",8)
	...;s $p(ConString,"^",13)=$zd($p(ConString,"^",13),3)
	...s $p(ConString,"^",13)=##class(websys.Conversions).DateLogicalToHtml($p(ConString,"^",13))	;Zhan 20170309
	...;s $p(ConString,"^",16)=$zd($p(ConString,"^",16),3)
	...s $p(ConString,"^",16)=##class(websys.Conversions).DateLogicalToHtml($p(ConString,"^",16))	;Zhan 20170309
	...;s $p(ConString,"^",17)=$zt($p(ConString,"^",17),1)
	...s $p(ConString,"^",17)=##class(websys.Conversions).TimeLogicalToHtml($p(ConString,"^",17))	;Zhan 20170309
	...s ConString=ConId_"^"_ConString
	
	...s ^CacheTemp("TarCon",$j,gnum)=TarString_"|"_InsuString_"|"_ConString
	...s gnum=gnum+1
	q gnum_"|"_$j
}

ClassMethod GetInsuTarConUpInfo(job, gnum) As %Library.String
{
	;n (job,gnum)
 	s str=$g(^CacheTemp("TarCon",job,gnum))
 	i $o(^CacheTemp("TarCon",job,""),-1)=gnum d
  	.k ^CacheTemp("TarCon",job)			
 	q str
}

/// w ##class(web.INSUTarContrastCom).QueryInsuTarConInfo("436487","0")
ClassMethod UpdateTarCon(rowid, flag, ZText = "1") As %Library.String
{
	n (rowid,flag,ZText)	
	&sql(update INSU_TarContrast set INTCT_DrAddFlag=:flag,INTCT_ZText=:ZText where INTCT_Rowid=:rowid)
	q SQLCODE
}

/// 更新对照关系
/// 说明：
/// 入参: INTCTDr    说明  Insu_Tarcontrast.RowId [可为空]
///     ：DrAddFlag  说明  空(null):已对照未上传, 1:已对照已上传,2:已对照已审核,3:已对照审核不通过
/// /    ：ZText      说明  通常医保中心返回唯一信息[例如创智对照关系下载的匹配序号]            
///     ：ExpStr     说明  医保目录类型[例如ZZB]^HIS项目编码^HIS项目名称^医保项目编码^医保项名称^医保项目类别^项目等级              
/// 出参：  >=0:成功;  <0:失败                 
///  DingSH 20170302 
/// w ##class(web.INSUTarContrastCom).UpdateTarConFlag("","1","10098","BJ^H23N034^聚乙二醇干扰素α-2b注射剂^101154001000001190200000000000000^聚乙二醇干扰素α-2b注射剂^2")                 
ClassMethod UpdateTarConFlag(INTCTDr, DrAddFlag, ZText, ExpStr) As %Library.String
{
	n (INTCTDr, DrAddFlag, ZText, ExpStr)
	s OutStr="-1"
	i INTCTDr'="" d
	.s DwnDate=+$H
	.s DwnTime=$P($H,",",2)
	.&sql(update INSU_TarContrast set INTCT_DrAddFlag=:DrAddFlag,INTCT_ZText=:ZText,INTCT_DownLoadDate=:DwnDate,INTCT_DownLoadTime=:DwnTime where INTCT_Rowid=:INTCTDr)
	.s OutStr=SQLCODE
	e    d
	.s InsuType=$P($g(ExpStr),"^",1),HisTarCode=$P($g(ExpStr),"^",2),HisTarDesc=$P($g(ExpStr),"^",3),InsuTarCode=$P($g(ExpStr),"^",4),InsuTarDesc=$P($g(ExpStr),"^",5),InsuXmlb=$P($g(ExpStr),"^",6),InsuLevel=$P($g(ExpStr),"^",7)
	.s Flag="1"
    .s INTCTInCode=""
    .s Tarid="0"
    .s HisTarCode1=$$ALPHAUP^SSUTIL4(HisTarCode)			
    .s Tarid=$o(^DHCTARI(0,"Code",HisTarCode1,Tarid)) 
    .s DwnDate=+$H
	.s DwnTime=$P($H,",",2)
    .&sql(Select INTCT_InsuCode into:INTCTInCode from INSU_TarContrast where INTCT_DicType=:InsuType And INTCT_His_Dr=:Tarid)
    .i InsuTarCode=INTCTInCode d
    ..&sql(Update INSU_TarContrast set INTCT_HisCode=:HisTarCode,INTCT_HisDesc=:HisTarDesc,INTCT_InsuDesc=:InsuTarDesc,INTCT_DrAddFlag=:DrAddFlag,INTCT_ZText=:ZText,INTCT_Level=:InsuLevel,INTCT_DownLoadDate=:DwnDate,INTCT_DownLoadTime=:DwnTime where INTCT_DicType=:InsuType And INTCT_His_Dr=:Tarid
          And INTCT_InsuCode=:InsuTarCode) ;And INTCT_Insu_Dr->INTIM_xmlb=:InsuXmlb)
    ..s OutStr=SQLCODE    
    .e  d
    ..s tempid="",Insuid=""
    ..f  s tempid=$o(^DHCINTIM("0","CODE",$$ALPHAUP^SSUTIL4(InsuTarCode),tempid)) q:tempid=""  d
	...s INTIMxmbm=$p(^DHCINTIM(tempid),"^",3)
	...s INTIMsfxmbm=$p(^DHCINTIM(tempid),"^",2)
	...i (INTIMsfxmbm=InsuType)&&(INTIMxmbm=InsuTarCode) d
	....s Insuid=tempid
	..q:Insuid=""
	..&sql(Update INSU_TarContrast set INTCT_HisCode=:HisTarCode,INTCT_HisDesc=:HisTarDesc,INTCT_DrAddFlag=:DrAddFlag,INTCT_ZText=:ZText,INTCT_InsuCode=:InsuTarCode,INTCT_InsuDesc=:InsuTarDesc,INTCT_Level=:InsuLevel,INTCT_DownLoadDate=:DwnDate,INTCT_DownLoadTime=:DwnTime 
	      where INTCT_DicType=:InsuType And INTCT_His_Dr=:Tarid And INTCT_Insu_Dr=:Insuid) ;And INTCT_Insu_Dr->INTIM_xmlb=:InsuXmlb)
    ..s OutStr=SQLCODE
    
	q OutStr
}

/// from 株洲 20150716 DingSH 获取版本号?
ClassMethod QueryVersonId(InsuType As %String) As %String
{
    n (InsuType)
    s Flag=""
    &sql(select MAX(INTCT_Level) into:Flag from INSU_TarContrast where INTCT_DicType=:InsuType)
    ;s Flag=Flag-2
    ;s Flag="88888"
    ;s Flag="" 
    q Flag
}

/// w ##class(web.INSUTarContrastCom).QueryTarSHInfo("YYB","XY00001176")
/// 
ClassMethod QueryTarSHInfo(InsuType As %String, TarCode As %String) As %String
{
    n (InsuType,TarCode)
    s outstr=""
    s (ArcimDr,PHCDFDr,PHCFDr)=""
    s intctdr=""
    &sql(select INTCT_Rowid into:intctdr from INSU_TarContrast where INTCT_DicType=:InsuType and INTCT_HisCode=:TarCode)
    q:intctdr="" outstr
    
	q:'$d(^DHCINTCT(intctdr)) outstr
	s IntctType=$P(^DHCINTCT(intctdr),"^",12)
	q:IntctType'=InsuType outstr
	;s IntctDrAddFlag=$P(^DHCINTCT(intctdr),"^",11)
	s HisDr=$p(^DHCINTCT(intctdr),"^",1)
	s InsuDr=$P(^DHCINTCT(intctdr),"^",4)
	s IntctActDate=$p(^DHCINTCT(intctdr),"^",13)
	;s IntctActDate=$zd(IntctActDate,"3")
	s IntctActDate=##class(websys.Conversions).DateLogicalToHtml(IntctActDate)	;Zhan 20170309
	s IntctClass=$p(^DHCINTCT(intctdr),"^",7)
	
	s IntimType=$p(^DHCINTIM(InsuDr),"^",2)
	q:IntimType'=InsuType outstr
	s InsuCode=$p(^DHCINTIM(InsuDr),"^",3)
	s InsuDesc=$p(^DHCINTIM(InsuDr),"^",4)
	s InsuXmlb=$p(^DHCINTIM(InsuDr),"^",7)
	s InsuJx=$p(^DHCINTIM(InsuDr),"^",8)
    ;s JxType="modelcode"_InsuType
	;s InsuJx=##class(web.DHCINSUPort).RtnDicCodeStrByDicBill1(JxType,InsuJx)
	s InsuJx=""
	s HisCode=$p(^DHCTARI(HisDr),"^",1)
	;s HisCode=$p(^DHCINTCT(intctdr),"^",2)
    q:HisCode'=TarCode outstr
	s HisDesc=$p(^DHCTARI(HisDr),"^",2)
	;s HisDesc=$p(^DHCINTCT(intctdr),"^",3)
	i InsuXmlb="0"  d
	.s HisJx=""
	e  d
	.s HisJx=$$GetTarJX^DHCINSUTarContrast(HisDr)
	s tPrice=##class(web.UDHCJFPRICE).GetItmPrice(HisDr,$h,"","","")
	s tPrice=$p(tPrice,"^",1)
	s outstr=InsuXmlb_"^"_HisCode_"^"_HisDesc_"^"_HisJx_"^"_InsuCode_"^"_InsuDesc_"^"_InsuJx_"^"_IntctActDate_"^"_intctdr_"^"_IntctClass_"^"_tPrice
	q outstr
}

// w ##class(web.INSUTarContrastCom).Insert("","","^5175^0000004^抗生素药^441396^140040101010104010102000000000000^阿司匹林肠溶片^^^^^^2013-03-28^^BJ^1^TEST^TEST^^^^^^^")

// 插入一条对照数据  add by lilizhi 2013-03-29

/// 新增院区 20200319 tangzf 20200319 第26位
ClassMethod Insert(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "") As %Library.String
{
	q:InString="" -100
	s:($g(%session)'="")&&($p(InString,"^",26)="") $p(InString,"^",26)=$g(%session.Data("DHCBILLINSUCloud.Hospital")) // tangzf 2019-8-2
	s flag=$$Insert^DHCINSUTarContrast(InString)
	q:flag<0 flag    ;add by lilizhi 2013-03-28    sql失败直接返回SQLCODE
	s Insert=flag
	s HisDr=$p(InString,"^",2)
	s INTCTDr=$o(^DHCINTCT("0","DHCTID",HisDr,""),-1)
	s:INTCTDr'="" Insert=INTCTDr ;Lou 2010-09-03 在目录对照界面需要获得对照ID
	q Insert
}

/// 目录对照数据下载
/// w ##class(web.INSUTarContrastCom).SaveTarConNet("^^-415-3^螺旋CT平扫+三维重建^^N210300001_10^X线计算机体层(螺旋CT)平扫+三维重建+单次多层--特等^^14752984^^^2^2011-04-01^14752984^CSA^1^^^^^2099-01-01") 
/// w ##class(web.INSUTarContrastCom).SaveTarConNet("^^XWY000006^克痤隐酮凝胶[6g]^^WSSCP^维生素C片[0.2g*100]^^14752984^^^2^2011-04-01^14752984^ZZB^1^^^^^2099-01-01") 
/// Instring:格式
///  Rowid^HisDr^HisCode^HisDesc^InsuDr^InsuCode^InsuDesc^Class^Level^PatTypeDr^Amount^DrAddFlag^ActiveDate^ZText^DicType
///  ^UserDr^Date^Time^ADDIP^Unique^ExpiryDate^UpLoadDate^UpLoadTime^DownLoadDate^DownLoadTime^LastModDate^LastModTime
ClassMethod SaveTarConNet(Instring As %Library.String) As %Library.String
{
	;s Instring=""
	n (Instring)
	q:Instring="" -1
	s ^TMP("SaveTarConNet")=Instring
	s hiscode=$p(Instring,"^",3)
	s hidesc=$e($p(Instring,"^",4),1,29)
	s insucode=$p(Instring,"^",6)
	s insudesc=$e($p(Instring,"^",7),1,29)
	s INTCTLevel=$p(Instring,"^",9)
	s Qty=+$p(Instring,"^",11)
	s INTCTDrAddFlag=$p(Instring,"^",12) ;by bsw 20180626
	s ActiveDate=$p(Instring,"^",13)
	s INTCTZText=$p(Instring,"^",14) ;by BSW 20180626
	s type=$p(Instring,"^",15)
	s INTCTExpiryDate=$p(Instring,"^",21)
	q:hiscode="" -1011
	q:insucode="" -1021
	;s hiscode=$ZCVT(hiscode,"U")
	;s insucode=$ZCVT(insucode,"U")
	b ;0
	s insucode2=$$ALPHAUP^SSUTIL4(insucode) ;去掉数字字母之外的字符 2008 10 15
	;s hiscode2=$$ALPHAUP^SSUTIL4(hiscode) ;去掉数字字母之外的字符 2008 10 15 by bsw 2018-06-25
	s hiscode2=hiscode ;by bsw 2018-06-25
	;w insucode2_"^"_insucode,!
	q:($d(^DHCTARI(0,"Code",hiscode))=0)&($d(^DHCTARI(0,"Code",hiscode2))=0) -1012
	;s Insuid=""
	///s Tarid=hiscode
	q:($O(^DHCINTIM("0","CODE",insucode))=0)&($O(^DHCINTIM("0","CODE",insucode2))=0) -1022
	s Tarid=""
	;s Tarid=$o(^DHCTARI(0,"Code",hiscode,Tarid))
	;s:Tarid="" Tarid=$o(^DHCTARI(0,"Code",hiscode2,Tarid))
	s TmpTarid=""
	f  s TmpTarid=$o(^DHCTARI(0,"Code",hiscode2,TmpTarid)) q:TmpTarid=""  d
	.s TarDesc=$p($g(^DHCTARI(TmpTarid)),"^",2)
	.s TarCode=$p($g(^DHCTARI(TmpTarid)),"^",1)
	.;i hidesc=TarDesc d
	.i TarCode=hiscode d
	..s Tarid=TmpTarid
	..;w "Tarid="_Tarid,!

	q:Tarid="" -1013
	s tempid="",Insuid=""
	f  s tempid=$O(^DHCINTIM("0","CODE",insucode2,tempid)) q:tempid=""  d
	.s INTIMxmbm=$p(^DHCINTIM(tempid),"^",3)
	.s NTIMsfxmbm=$p(^DHCINTIM(tempid),"^",2)
	.i (NTIMsfxmbm=type)&(INTIMxmbm=insucode) d
	..s Insuid=tempid
	..;w "Insuid"_Insuid,!
	q:Insuid="" -1023
	s XString=""
	s $p(XString,"^",1)=""
	s $p(XString,"^",2)=Tarid
	s $p(XString,"^",3)=hiscode
	s $p(XString,"^",4)=hidesc
	s $p(XString,"^",5)=Insuid
	s $p(XString,"^",6)=insucode
	s $p(XString,"^",7)=insudesc
	;s $p(XString,"^",8)=""
	s $p(XString,"^",9)=INTCTLevel
	;s $p(XString,"^",10)=""
	s $p(XString,"^",11)=1
	;s $p(XString,"^",12)=""
	s $p(XString,"^",12)=INTCTDrAddFlag
	s $p(XString,"^",13)=ActiveDate
	;s $p(XString,"^",14)=""
	s $p(XString,"^",14)=INTCTZText ;by bsw 20180626
	s $p(XString,"^",15)=type
    s $p(XString,"^",19)=INTCTExpiryDate
    b ;1
	s flag=..Update("","",XString)
	s CheckInCont=flag
	q CheckInCont
}

/// Creator: tangzf
/// CreateDate: 2020-03-11
/// Descript: 修改 表 User.INSUContrast.cls 中日期
/// Input:		RowId : 	User.INSUContrast.RowId 必填
/// Output: 
/// Return: 返回值  不为0为失败  
/// DeBug: 
/// w ##class(web.INSUMsgInfo).Abort
ClassMethod Abort(RowId, ExpiryDate)
{
	set rtn=-1
	quit:(+RowId=0) rtn
	quit:'$d(^DHCINTCT(RowId)) rtn
	set:ExpiryDate="" ExpiryDate=+$h
	set ExpiryDate=##class(websys.Conversions).DateHtmlToLogical(ExpiryDate)
	set obj=##class(User.INSUTarContrast).%OpenId(RowId)
	set obj.INTCTExpiryDate=ExpiryDate
	set err=obj.%Save()
    if $$$ISERR(err){
		set rtn="-100^"_$SYSTEM.Status.GetErrorText(err)
	}else{
		set rtn=0
	}
	quit rtn
}

/// Creator: tangzf
/// CreateDate: 2020-06-1
/// Descript: 目录对照院内审核-审核通过
/// Input:		RowId : 	User.INSUContrast.RowId 必填
/// 			AuditFalg: 
/// 					 0：是表示目录对照完成以后未做任何操作
/// 					 1：是表示目录上传医保中心
/// 					 2：是表示目录中心审核通过
/// 					 3：是表示目录中心审核不通过
/// 					 4：是表示目录院内审核通过
/// 					 5：是表示目录院内审核不通过
/// 			UserDr:SSUser.RowID	
/// Output: 
/// Return: 返回值  不为0为失败  ,如果操作失败 则增加INSU_MsgInfo ，需要确保有业务类型 TarCntrastAudit
/// DeBug: 
/// w ##class(web.INSUMsgInfo).Abort
ClassMethod TarContrastAudit(RowId, AuditFalg, UserDr)
{
	set SQLCODE=0
	if (+RowId=0) set SQLCODE=-1
	if '$d(^DHCINTCT(RowId)) set SQLCODE=-2
	if +SQLCODE=0  d
	.set AuditDate=+$h
	.set AuditTime=$p($h,",",2)
	.&sql(
		update INSU_TarContrast set INTCT_AuditDate=:AuditDate,INTCT_AuditTime=:AuditTime,INTCT_DrAddFlag=:AuditFalg,INTCT_AuditUser=:UserDr where INTCT_Rowid =:RowId
	)
	quit SQLCODE
}

/// Creator: tangzf
/// CreatDate: 2023-04-13
/// Description: 
/// Input: hospId: CT_Hospital.RowId
/// Return: OEC_OrderCategory.RowId
/// Others: 通用配置-医保基础信息-不进行对照的项目-医嘱子类
/// Debug: w ##class(web.INSUTarContrastCom).GetUnConCateIdStr( 2)
ClassMethod GetUnConCateIdStr(hospId As %String) As %String
{
	///
	//set ItemCatDR=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",10)
	//set OrdCateDR=$p($g(^ARC("IC",ItemCatDR)),"^",8)    //医嘱大类
	//continue:((PrtCateIdStr'="")&&(("^"_PrtCateIdStr_"^")'[("^"_OrdCateDR_"^")))
	set cateIdStr=""
	set rset=##class(%ResultSet).%New("BILL.CFG.COM.GeneralCfg:GetResultForQuery")
	do rset.Execute("INSUBASINFO.TarContrast.BJHDZDXM-YZZL", "", "", hospId)
	while (rset.Next()) {
		set id=rset.Get("ID")
		continue:(id="")
		set cateIdStr=$s((cateIdStr=""):id,1:(cateIdStr_"^"_id))
	}
	quit cateIdStr
}

}
