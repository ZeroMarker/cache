/// 名称: DHCMed.CCService.Sys.ItemCatSrv
/// 描述: DHCMed.CC.ItemCat 监控项目大类表常用方法
/// 
/// 编写者：liuyh
/// 编写日期: 2010-04-27
Class DHCMed.CCService.Sys.ItemCatSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-03-17
/// Description:  查询监控项目大类信息
/// Table：       DHCMed.CC.ItemCat
/// Input：       SubjectID:监控主题ID
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.Sys.ItemCatSrv","QryItemCat","1")
Query QryItemCat(argSubjectID As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,DepID:%String,Dep:%String,WardID:%String,Ward:%String")
{
}

ClassMethod QryItemCatExecute(ByRef qHandle As %Binary, argSubjectID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:argSubjectID="" $$$OK
	Set CategID=0
	For {
		Set CategID=$o(^DHCMed.CCi("ItemCat",0,"SubjectIndex",argSubjectID,CategID))
		Quit:CategID=""
		Set objCateg=##class(DHCMed.CC.ItemCat).GetObjById(CategID)
		If $IsObject(objCateg){
			Set Code=objCateg.ICCode
			Set Desc=objCateg.ICDesc
			Set DepID=objCateg.LocDr //Add by LiYang 2011-09-19
			Set Dep=""
			if (DepID'="")
			{
				Set objDep=##class(DHCMed.Base.Ctloc).GetObjById(DepID)
				Set Dep=objDep.Descs
				Do objDep.%Close()
			}
			Set WardID=objCateg.WardDr
			Set Ward=""
			if (WardID'="")
			{
				Set objWard=##class(DHCMed.Base.PacWard).GetObjById(WardID)
				Set Ward=objWard.Descs
				do objWard.%Close()
			}
			Set Data=$lb(CategID,Code,Desc,DepID,Dep,WardID,Ward)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItemCatExecute ]
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

/// Creator：     lyh
/// CreatDate：   2010-04-28
/// Description:  根据项目大类ID删除项目大类及对应的项目子类
/// Table：       DHCMed.CC.ItemCat,DHCMed.CC.ItemSubCat
/// Input：       CategID  项目大类Id
///               
/// Return：      返回是否成功标志 1:成功   0:失败
/// w ##class(DHCMed.CCService.Sys.ItemCatSrv).DeleteItemCat(1)
ClassMethod DeleteItemCat(argCategID As %String) As %String
{
	New (argCategID)
	Set return=0
	Quit:argCategID="" return
	
	Set $ZT="DeleteItemCatErr"
	TStart
	Set flg=##class(DHCMed.CC.ItemCat).DeleteById(argCategID)
	If flg<0 TRollback
	Set SubCatCode=""
	For {
		Set SubCatCode=$o(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",argCategID,SubCatCode))
		Quit:SubCatCode=""
		Set SubCatID=0
		For {
			Set SubCatID=$o(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",argCategID,SubCatCode,SubCatID))
			Quit:SubCatID=""
			Set flg=##class(DHCMed.CC.ItemSubCat).DeleteById(SubCatID)
			If flg<0 TRollback
		}
	}
	TCommit
	
	Set return=1
	Quit return
	
DeleteItemCatErr
	Write "Error:"_$ZERROR,!
 	TRollback
 	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2011-03-17
/// Description:  查询监控项目子类信息
/// Table：       DHCMed.CC.ItemSubCat
/// Input：       CategID:监控大类ID
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.Sys.ItemCatSrv","QryItemSubCat","1")
Query QryItemSubCat(argCategID As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,KeywordID:%String,KeywordDesc:%String")
{
}

ClassMethod QryItemSubCatExecute(ByRef qHandle As %Binary, argCategID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:argCategID="" $$$OK
	Set SubCatCode=""
	For {
		Set SubCatCode=$o(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",argCategID,SubCatCode))
		Quit:SubCatCode=""
		Set SubCatID=0
		For {
			Set SubCatID=$o(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",argCategID,SubCatCode,SubCatID))
			Quit:SubCatID=""
			Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
			If $IsObject(objSubCat){
				Set Code=objSubCat.ISCCode
				Set Desc=objSubCat.ISCDesc
				Set KeywordID=objSubCat.ISCKeywordID
				set KeywordDesc=""
				set objKeyword=##class(DHCMed.CC.KeyWord).GetObjById(KeywordID)
				if $IsObject(objKeyword) {
					set KeywordDesc=objKeyword.Description
				}
				Set Data=$lb(SubCatID,Code,Desc,KeywordID,KeywordDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryItemSubCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItemSubCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryItemSubCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItemSubCatExecute ]
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

/// Creator: LiYang
/// CreateDate: 2011-09-14
/// Description: 复制监控子类
/// Table: DHCMed.CC.ItemSubCat
/// Input：
/// SrcSubjectID:源主题ID, SrcItemCatID：源类别, TargetSubjectID:目标主题ID, TargetItemCatID：目标大类ID
/// Return：      成功：返回RowID，失败：返回<0的代码
/// w ##class(DHCMed.CCService.Sys.ItemCatSrv).SubCatCopyTo(9,13,3,8)
ClassMethod SubCatCopyTo(SrcSubjectID, SrcItemSubCatID, TargetSubjectID, TargetItemCatID) As %Integer
{
	n (SrcSubjectID, SrcItemSubCatID, TargetSubjectID, TargetItemCatID)
	set objSrc=##class(DHCMed.CC.ItemSubCat).GetObjById(SrcItemSubCatID)
	//Set flag=$d(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",TargetItemCatID,$ZConvert(" "_objSrc.ISCCode,"t"))) //Add By LiYang 2011-09-26如果有重复项目，则在代码后面加上“-Copy”
	Set Code=objSrc.ISCCode
	while (1)
	{
		Quit:$d(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",TargetItemCatID,$ZConvert(" "_Code,"t")))=0
		Set Code=Code_"-Copy"
	}
	set obj=##class(DHCMed.CC.ItemSubCat).%New()
	set obj.ISCCode=Code  //$s(flag=0:objSrc.ISCCode,1:objSrc.ISCCode_"-Copy") //Add By LiYang 2011-09-26如果有重复项目，则在代码后面加上“-Copy”
	set obj.ISCDesc=objSrc.ISCDesc
	set obj.ISCCatDr=TargetItemCatID
	set sc=obj.%Save()
	Set ItemDicID=""
	Set ItemDicCode=""
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}else{
		set id=obj.%Id()
	}	
	For {
		Set ItemDicID=$o(^DHCMed.CCi("ItemDic",0,"IDSubCatDrIndex",objSrc.%Id(),ItemDicID))
		Quit:ItemDicID=""
		Set ret=##class(DHCMed.CCService.Sys.ItemDicSrv).CopyTo(SrcSubjectID,ItemDicID,TargetSubjectID,obj.%Id())
		//do objItemDic.%Close()
	}

	do obj.%Close()
	do objSrc.%Close()
	quit id
}

/// Creator: LiYang
/// CreateDate: 2011-09-14
/// Description: 复制监控大类
/// Table: DHCMed.CC.ItemCat
/// Input：无
/// Return：      成功：返回RowID，失败：返回<0的代码
/// w ##class(DHCMed.CCService.Sys.ItemCatSrv).CatCopyTo(9,3)
ClassMethod CatCopyTo(SrcCateID, TargetSubjectID) As %Integer
{
	n (SrcCateID,TargetSubjectID)
	Set objSrc=##class(DHCMed.CC.ItemCat).GetObjById(SrcCateID)
	//Set flag=$d(^DHCMed.CCi("ItemCat",0,"ICCodeIndex",TargetSubjectID,$ZConvert(" "_objSrc.ICCode,"t"))) //Modify by LiYang 2011-10-02如果代码重复，则不进行复制
	set obj=##class(DHCMed.CC.ItemCat).%New()
	set Code=objSrc.ICCode
	while (1)
	{
		quit:$d(^DHCMed.CCi("ItemCat",0,"ICCodeIndex",TargetSubjectID,$ZConvert(" "_Code,"t")))=0
		Set Code=Code_"-Copy"
	}
	set obj.ICCode=Code //$s(flag=0:objSrc.ICCode,1:objSrc.ICCode_"-Copy") //Modify by LiYang 2011-10-02如果代码重复，则不进行复制
	set obj.ICDesc=objSrc.ICDesc
	set obj.SubjectDr=TargetSubjectID
	set obj.LocDr=objSrc.LocDr
	set obj.WardDr=objSrc.WardDr	
	set sc=obj.%Save()
	Set Code=""
	Set RowID=""
	For {
		Set Code=$o(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",objSrc.%Id(),Code))
		Quit:Code=""
		For {
			Set RowID=$o(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",objSrc.%Id(),Code,RowID))
			Quit:RowID=""
			Set ret=##class(DHCMed.CCService.Sys.ItemCatSrv).SubCatCopyTo(objSrc.SubjectDr,RowID,TargetSubjectID,obj.%Id())
			
		}
	}
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}else{
		set id=obj.%Id()
	}
	do obj.%Close()
	do objSrc.%Close()
	quit id
}

}
