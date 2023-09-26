/// 名称: DHCMed.CCService.Sys.ItemDicSrv
/// 描述: 监控项目
/// 编写者：zhufei
/// 编写日期: 2011-03-17
Class DHCMed.CCService.Sys.ItemDicSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-03-17
/// Description:  通过监控项目代码、子分类查询监控项目信息
/// Table：       DHCMed.CC.ItemDic
/// Input：       IDCode : 监控项目代码 IDSubCatDr : 子分类
/// 
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.Sys.ItemDicSrv","QryItems","","")
Query QryItems(argDesc As %String, argSubCatID As %String) As %Query(ROWSPEC = "rowid:%String,IDCode:%String,IDDesc:%String,IDSubCatDr:%String,IDExpression:%String,IDRange:%String,IDResume:%String,CDDesc:%String,ItemGrade:%String,ItemScore:%String,ItemGroup:%String,ItemActive:%String,ItemActiveDesc:%String,ItemAbsolute:%String,ItemAbsoluteDesc:%String,ItemIsSensitive:%String,ItemIsSensitiveDesc:%String,ItemIsSpecificity:%String,ItemIsSpecificityDesc:%String,ItemIsRunOnce:%String,ItemIsRunOnceDesc:%String,AdmType:%String,AdmTypeDesc:%String")
{
}

ClassMethod QryItemsExecute(ByRef qHandle As %Binary, argDesc As %String, argSubCatID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:argSubCatID="" $$$OK
	Set ItemDicID=0
	For {
		Set ItemDicID=$o(^DHCMed.CCi("ItemDic",0,"IDSubCatDrIndex",argSubCatID,ItemDicID))
		Quit:ItemDicID=""
		Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicID)
		If $IsObject(objItemDic){
			Set IDCode=objItemDic.IDCode
			Set IDDesc=objItemDic.IDDesc
			Continue:(argDesc'="")&&(argDesc'=ISCDesc)
			Set IDSubCatDr=objItemDic.IDSubCatDr
			Set IDExpression=objItemDic.IDExpression
			Set IDRange=objItemDic.IDRange
			Set IDResume=objItemDic.IDResume
			
			Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(IDSubCatDr)
			Continue:'$IsObject(objSubCat)
			Set CategID=objSubCat.ISCCatDr
			Set SubCatDesc=objSubCat.ISCDesc  //项目子类
			Set objCateg=##class(DHCMed.CC.ItemCat).GetObjById(CategID)
			Continue:'$IsObject(objCateg)
			Set SubjectID=objCateg.SubjectDr
			Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
			Continue:'$IsObject(objSubject)
			
			Set (ItemScore,ItemActive,ItemAbsolute)=0
			Set ItemID=$o(^DHCMed.CCi("SItem",0,"IndexItemDic",SubjectID,ItemDicID,0))
			Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
			If $IsObject(objItem){
				Set ItemScore=objItem.Score
				Set ItemActive=objItem.IsActive
				Set ItemAbsolute=objItem.IsAbsolute
			}
			Set ItemActiveDesc=$s(ItemActive=1:"是",1:"否")
			Set ItemAbsoluteDesc=$s(ItemAbsolute=1:"是",1:"否")
			
			Set IsSensitive=objItem.IsSensitive
			Set IsSensitiveDesc=$s(objItem.IsSensitive=1:"是",1:"否")
			
			Set IsSpecificity=objItem.IsSpecificity
			Set IsSpecificityDesc=$s(objItem.IsSpecificity=1:"是",1:"否")			
			
			Set IsRunOnce=objItem.IsRunOnce
			Set IsRunOnceDesc=$s(objItem.IsRunOnce=1:"是",1:"否")			
			
			Set ItemGroup=""
			set:(ItemScore>0)&&(ItemScore<=50) ItemGrade=1
			set:(ItemScore>50)&&(ItemScore<=100) ItemGrade=2
			set:ItemScore>100 ItemGrade=3
			
			set:(ItemScore>0)&&(ItemScore<=50) ItemGroup="一级"
			set:(ItemScore>50)&&(ItemScore<=100) ItemGroup="二级"
			set:ItemScore>100 ItemGroup="三级"
			
			set AdmType=objItem.AdmType,AdmTypeDesc=""
			set:AdmType["I" AdmTypeDesc=AdmTypeDesc_","_"住院"
			set:AdmType["O" AdmTypeDesc=AdmTypeDesc_","_"门诊"
			set:AdmType["E" AdmTypeDesc=AdmTypeDesc_","_"急诊"
			set:AdmTypeDesc'="" AdmTypeDesc=$e(AdmTypeDesc,2,$l(AdmTypeDesc))
			
			Set Data=$lb(ItemDicID,IDCode,IDDesc,IDSubCatDr,IDExpression,IDRange,IDResume,SubCatDesc,ItemGrade,ItemScore,ItemGroup,ItemActive,ItemActiveDesc,ItemAbsolute,ItemAbsoluteDesc,IsSensitive,IsSensitiveDesc,IsSpecificity,IsSpecificityDesc,IsRunOnce,IsRunOnceDesc,AdmType,AdmTypeDesc)
			Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     zhufei
/// CreatDate：   2011-03-17
/// Description:  更新监控项目和项目字典
/// 
/// Table：       DHCMed.CC.ItemDic,DHCMed.CC.SubjectItm
/// Input：       项目内容
///               
/// Return：      ret>0:成功   ret<0:失败
/// w ##class(DHCMed.CCService.Sys.ItemDicSrv).Update(argInput)
ClassMethod Update(argInput As %String) As %String
{
	New (argInput)
	Set return=0
	Quit:argInput="" return
	
	Set $ZT="UpdateErr"
	TStart
	Set IDID=$p(argInput,"^",1)
	Set IDCode=$p(argInput,"^",2)
	Set IDDesc=$p(argInput,"^",3)
	Set IDSubCatDr=$p(argInput,"^",4)
	Set IDExpression=$p(argInput,"^",5)
	Set IDRange=$p(argInput,"^",6)
	Set IDResume=$p(argInput,"^",7)
	
	Set ItemID=""
	Set ItemSubjectID=""
	Set ItemCode=""
	Set ItemDicID=""
	Set ItemScore=+$p(argInput,"^",8)
	Set ItemActive=$p(argInput,"^",9)
	Set ItemActive=$s(ItemActive["Y":"Y",1:"N")
	Set ItemResume=""
	Set ItemAbsolute=$p(argInput,"^",10)
	Set ItemAbsolute=$s(ItemAbsolute["Y":"Y",1:"N")
	set IsSensitive=$s($p(argInput,"^",11)["Y":"Y",1:"N")
	set IsSpecificity=$s($p(argInput,"^",12)["Y":"Y",1:"N")
	Set IsRunOnce=$s($p(argInput,"^",13)["Y":"Y",1:"N")
	Set AdmType=$p(argInput,"^",14)
	Set:AdmType="" AdmType="I"
	
	Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(IDSubCatDr)
	Quit:'$IsObject(objSubCat) return
	Set CategID=objSubCat.ISCCatDr
	Set objCateg=##class(DHCMed.CC.ItemCat).GetObjById(CategID)
	Quit:'$IsObject(objCateg) return
	Set SubjectID=objCateg.SubjectDr
	Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
	Quit:'$IsObject(objSubject) return
	
	Set return=-1
	Set strItemDic=IDID_"^"_IDCode_"^"_IDDesc_"^"_IDSubCatDr_"^"_IDExpression_"^"_IDRange_"^"_IDResume
	Set flg=##Class(DHCMed.CC.ItemDic).Update(strItemDic)
	If flg<0 TRollback
	Quit:flg<0 return
	
	Set ItemDicID=flg
	Set ItemID=$o(^DHCMed.CCi("SItem",0,"IndexItemDic",SubjectID,ItemDicID,0))
	Set strItem=ItemID_"^"_SubjectID_"^"_ItemCode_"^"_ItemDicID_"^"_ItemScore_"^"_ItemActive_"^"_ItemResume_"^"_""_"^"_ItemAbsolute_"^"_IsSensitive_"^"_IsSpecificity_"^"_IsRunOnce_"^"_AdmType
	Set flg=##Class(DHCMed.CC.SubjectItm).Update(strItem)
	If flg<0 TRollback
	Quit:flg<0 return
	
	TCommit
	Set return=1
	Quit return
	
UpdateErr
	Write "Error:"_$ZERROR,!
 	TRollback
 	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2011-03-17
/// Description:  删除监控项目和项目字典
/// 
/// Table：       DHCMed.CC.ItemDic,DHCMed.CC.SubjectItm
/// Input：       DHCMed.CC.ItemDic.ID
///               
/// Return：      ret>0:成功   ret<0:失败
/// w ##class(DHCMed.CCService.Sys.ItemDicSrv).DeleteById(argItemDicID)
ClassMethod DeleteById(argItemDicID As %String) As %String
{
	New (argItemDicID)
	Set return=0
	Quit:argItemDicID="" return
	
	Set $ZT="DeleteErr"
	TStart
	Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(argItemDicID)
	Quit:'$IsObject(objItemDic) return
	Set IDSubCatDr=objItemDic.IDSubCatDr
	
	Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(IDSubCatDr)
	Quit:'$IsObject(objSubCat) return
	Set CategID=objSubCat.ISCCatDr
	Set objCateg=##class(DHCMed.CC.ItemCat).GetObjById(CategID)
	Quit:'$IsObject(objCateg) return
	Set SubjectID=objCateg.SubjectDr
	Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
	Quit:'$IsObject(objSubject) return
	
	Set return=-1
	Set ItemID=$o(^DHCMed.CCi("SItem",0,"IndexItemDic",SubjectID,argItemDicID,0))
	Set objItem=##Class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
	If $IsObject(objItem){
		Set flg=##Class(DHCMed.CC.SubjectItm).DeleteById(ItemID)
		If flg<0 TRollback
		Quit:flg<0 return
	}
	Set flg=##Class(DHCMed.CC.ItemDic).DeleteById(argItemDicID)
	If flg<0 TRollback
	Quit:flg<0 return
	
	TCommit
	Set return=1
	Quit return
	
DeleteErr
	Write "Error:"_$ZERROR,!
 	TRollback
 	Quit -1
}

/// Creator：     liuyh
/// CreatDate：   2010-05-10
/// Description:  同时往监控内容字典和监控项目字典表中插入医嘱信息
/// 
/// Table：       DHCMed.CC.ContentDic,DHCMed.CC.ItemDic
/// Input：       Str:医嘱信息 Type:类型(医嘱、诊断、检验)           
/// Return：      返回是否成功标志 1:成功   0:失败
/// w ##class(DHCMed.CCService.Sys.ItemDicSrv).AddInfoToDic("^1^2^3^4^^","")
ClassMethod AddInfoToDic(Str As %String, Type As %String) As %String
{
	New (Str,Type)
	Set return=0
	Quit:(Str="")||(Type="") ret
	
	Set $ZT="AddInfoToDicErr"
	Set flg=##class(DHCMed.CC.ItemDic).Update(Str)
	If flg<0 TRollback
	Quit:flg<0 return
	
	Set ret=1
	Quit ret
	
AddInfoToDicErr
	Set ErrorMsg=$ZE
 	Quit "-1"_ErrorMsg
}

/// Creator: LiYang
/// CreateDate: 2011-09-14
/// Description: 复制监控项目
/// Table: DHCMed.CC.ItemDic
/// Input：ParentSubCatDr:所属的子类ID
/// Return：      成功：返回RowID，失败：返回<0的代码
/// w ##class(DHCMed.CCService.Sys.ItemDicSrv).CopyTo(4,129, 3,8)
ClassMethod CopyTo(SrcSubjectID, SrcItemDicID, ToSubjectID, TargetSubCatDr) As %Integer
{
	n (SrcSubjectID, SrcItemDicID, ToSubjectID, TargetSubCatDr)
	Set SubjectItmID=$o(^DHCMed.CCi("SItem",0,"IndexItemDic",SrcSubjectID,SrcItemDicID,""))
	
	Set objSubItm=##class(DHCMed.CC.SubjectItm).GetObjById(SubjectItmID)
	Set objSrc=##class(DHCMed.CC.ItemDic).GetObjById(objSubItm.ItemDic)
	Set flag=$d(^DHCMed.CCi("ItemDic",0,"IndexSubCatCode",TargetSubCatDr,$ZConvert(" "_objSrc.IDCode,"t")))  //Modified By LiYang 2011-10-02如果代码重复，则在代码字段增加“Copy”
	Set Code=objSrc.IDCode
	While (1)
	{
		Quit:$d(^DHCMed.CCi("ItemDic",0,"IndexSubCatCode",TargetSubCatDr,$ZConvert(" "_Code,"t")))=0
		Set Code=Code_"-Copy"
	}
	
	set obj=##class(DHCMed.CC.ItemDic).%New()
	
	set obj.IDCode=Code //$s(flag=0:objSrc.IDCode,1:objSrc.IDCode_"-Copy") //Modified By LiYang 2011-10-02如果代码重复，则在代码字段增加“Copy”
	set obj.IDDesc=objSrc.IDDesc
	set obj.IDSubCatDr=TargetSubCatDr
	set obj.IDExpression=objSrc.IDExpression
	set obj.IDRange=objSrc.IDRange
	set obj.IDResume=objSrc.IDResume
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		Quit -1
	}else{
		set id=obj.%Id()
	}	
	
	Set objTargetSubItm=##class(DHCMed.CC.SubjectItm).%New()
	Set objTargetSubItm.SubjectID=ToSubjectID
	Set objTargetSubItm.Code=objSubItm.Code
	Set objTargetSubItm.ItemDic=obj.%Id()
	Set objTargetSubItm.IsActive=objSubItm.IsActive
	Set objTargetSubItm.ResumeText=objSubItm.ResumeText
	Set objTargetSubItm.Score=objSubItm.Score
	Set objTargetSubItm.MultiTimes=objSubItm.MultiTimes
	Set objTargetSubItm.IsAbsolute=objSubItm.IsAbsolute
	Set sc=objTargetSubItm.%Save()
	
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}else{
		set id=objTargetSubItm.%Id()
	}
	do obj.%Close()
	do objSrc.%Close()
	do objTargetSubItm.%Close()
	do objSubItm.%Close()
	quit id
}

}
