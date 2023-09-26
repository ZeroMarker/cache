/// 医院感染对照数据
/// 创建者：李阳
/// 创建日期：2012-12-11
Class DHCMed.NINF.Srv.MKDicMapping Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 对照类型
Property Category As %String(TRUNCATE = 1);

/// 源值
Property SrcObjectID As %String(TRUNCATE = 1);

/// 源值描述
Property SrcDescription As %String(TRUNCATE = 1);

/// 目标值
Property Target As %String(TRUNCATE = 1);

/// 目标值描述
Property TargetDesc As %String(TRUNCATE = 1);

/// 备注
Property ResumeText As %String(TRUNCATE = 1);

/// 对照类别索引
Index IndexCategory On Category;

/// 对照类别和源ID索引
Index IndexCategorySrcID On (Category, SrcObjectID) [ Unique ];

/// Creator：     liyang
/// CreatDate：   2013-01-25
/// Description:  取民科院感字典对照
/// Table：       DHCMed.NINF.Srv.MKDicMapping
/// Input：       DHCMed.NINF.Srv.MKDicMapping.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Srv.MKDicMapping
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Srv.MKDicMapping).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liyang
/// CreatDate：   2013-01-25
/// Description:  更新民科院感字典对照
/// Table：       DHCMed.NINF.Srv.MKDicMapping
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Srv.MKDicMapping).Update("CombinedMed^5^四联以上^5^四联以上^^","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	Set Category=$p(aInput,aSeparate,2)
	Set SrcID=$p(aInput,aSeparate,3)
	Set SrcID=$tr(SrcID," ","")
	//If (ID="")&&(Category'="")&&(SrcID'="") {
	If ((Category'="")&&(SrcID'="")) {		//Modified By LiYang 2014-11-01 FixBug:3952 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-将原有记录的源值更改为已存在记录的源值时，提示“SyntaxError:无效字符”
		Set tID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(Category,"U")," "_$ZCVT(SrcID,"U"),""))
		Quit:tID'=ID -2
	}
	
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Srv.MKDicMapping).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Srv.MKDicMapping).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Category=$p(aInput,aSeparate,2)
	Set obj.SrcObjectID=SrcID
	Set obj.SrcDescription=$p(aInput,aSeparate,4)
	Set obj.Target=$p(aInput,aSeparate,5)
	Set obj.TargetDesc=$p(aInput,aSeparate,6)
	Set obj.ResumeText=$p(aInput,aSeparate,7)
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyang
/// CreatDate：   2013-01-25
/// Description:  删除民科院感字典对照
/// Table：       DHCMed.NINF.Srv.MKDicMapping
/// Input：       DHCMed.NINF.Srv.MKDicMapping.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Srv.MKDicMapping).%DeleteId(+aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     liyang
/// CreatDate：   2013-01-25
/// Description:  取民科院感字典对照
/// Table：       DHCMed.NINF.Srv.MKDicMapping
/// Input：       Category       字典分类
///               SrcObjectID    源数据ID
/// Return：      返回String
/// w ##class(DHCMed.NINF.Srv.MKDicMapping).GetMappingData("","")
ClassMethod GetMappingData(Category As %String, SrcObjectID As %String) As %String
{
	New (Category,SrcObjectID)
	Set return=""
	Quit:(Category="")||(SrcObjectID="") return
	
	Set SrcObjectID=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcObjectID)
	Set ID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(Category,"U")," "_$ZCVT(SrcObjectID,"U"),""))
	Quit:ID="" return
	
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     liyang
/// CreatDate：   2013-01-25
/// Description:  按类别查询民科院感字典对照
/// Table：       DHCMed.NINF.Srv.MKDicMapping
/// Input：       
/// Do ##class(%ResultSet).RunQuery("DHCMed.NINF.Srv.MKDicMapping","QryByCategory","")
Query QryByCategory(Category As %String) As %SQLQuery(ROWSPEC = "ID:%String,Category:%String,SrcObjectID:%String,SrcDescription:%String,Target:%String,TargetDesc:%String,ResumeText:%String")
{
	SELECT %ID,Category,SrcObjectID,SrcDescription,Target,TargetDesc,ResumeText 
	FROM DHCMed_NINF_Srv.MKDicMapping 
	WHERE (Category = :Category) 
	ORDER BY SrcDescription
}

/// Creator：     zhufei
/// CreatDate：   2013-06-14
/// Description:  按类别查询民科院感字典对照
/// Table：       DHCMed.NINF.Srv.MKDicMapping
/// Input：       
/// Do ##class(%ResultSet).RunQuery("DHCMed.NINF.Srv.MKDicMapping","QryByCategoryNew","MKDiagnos","霍乱","","","")
Query QryByCategoryNew(aCategory As %String, aSrcValue As %String, aSrcDesc As %String, aTargetValue As %String, aTargetDesc As %String) As %Query(ROWSPEC = "ID:%String,Category:%String,SrcObjectID:%String,SrcDescription:%String,Target:%String,TargetDesc:%String,ResumeText:%String")
{
}

ClassMethod QryByCategoryNewExecute(ByRef qHandle As %Binary, aCategory As %String, aSrcValue As %String, aSrcDesc As %String, aTargetValue As %String, aTargetDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aCategory="" $$$OK
 	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategory"," "_$zcvt(aCategory,"U"),xID))
	 	Quit:xID=""
	 	
	 	Set objMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(xID)
	 	Continue:'$IsObject(objMap)
	 	Set Category=objMap.Category
	 	Set SrcValue=objMap.SrcObjectID
	 	Set SrcDesc=objMap.SrcDescription
	 	Set TargetValue=objMap.Target
	 	Set TargetDesc=objMap.TargetDesc
	 	Set ResumeText=objMap.ResumeText
	 	Continue:(aSrcValue'="")&&($zcvt(SrcValue,"U")'[$zcvt(aSrcValue,"U"))
	 	Continue:(aSrcDesc'="")&&($zcvt(SrcDesc,"U")'[$zcvt(aSrcDesc,"U"))
	 	Continue:(aTargetValue'="")&&($zcvt(TargetValue,"U")'[$zcvt(aTargetValue,"U"))
	 	Continue:(aTargetDesc'="")&&($zcvt(TargetDesc,"U")'[$zcvt(aTargetDesc,"U"))
	 	
	 	Set Data=$lb(xID,Category,SrcValue,SrcDesc,TargetValue,TargetDesc,ResumeText)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}
 	
	Quit $$$OK
}

ClassMethod QryByCategoryNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByCategoryNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryByCategoryNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByCategoryNewExecute ]
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

/// w ##Class(DHCMed.NINFService.CSS.ClinReport).GetMapSrcData()
ClassMethod GetMapSrcData(aCategory As %String) As %String
{
	New (aCategory)
	Set return=0
	Quit:aCategory="" return
	
	//update by zf 20140714
	//处理字符串最后空格引起的索引问题
	Set flg=..ProErrData()
	
	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(aCategory)
	Quit:'$IsObject(objDic) return
	Set CategoryCode=objDic.Code
	
	Set Count=0
	//[横]科室对照（医院科室->标准科室）
	If CategoryCode="CSSLocGroup" {
		Set xLocID=0,count=0
		For {
			Set xLocID=$o(^CTLOC(xLocID))
			Quit:xLocID=""
			
			Set LocType=$p($g(^CTLOC(xLocID)),"^",13)
			Continue:(LocType'="E")&&(LocType'="W")
			Set LocDesc=$p($g(^CTLOC(xLocID)),"^",2)
			Continue:LocDesc=""
			Continue:LocDesc["门诊"
			Continue:LocDesc["不用"
			Continue:LocDesc["作废"
			Continue:LocDesc["停用"
			Continue:LocDesc="无"
			Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
			
			Set Target=""
			Set TargetDesc=""
			Set ResumeText="" //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空
			Set MapID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(CategoryCode,"U")," "_$ZCVT(xLocID,"U"),""))
			If MapID'="" {
				Set objMKMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(MapID)
				If $IsObject(objMKMap){
					Set Target=objMKMap.Target
					Set TargetDesc=objMKMap.TargetDesc
					Set ResumeText=objMKMap.ResumeText //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空
				}
			}
			
			Set Count=Count+1
			Set InputStr=MapID_"^"_CategoryCode_"^"_xLocID_"^"_LocDesc_"^"_Target_"^"_TargetDesc_"^"_ResumeText
			Set flg=##Class(DHCMed.NINF.Srv.MKDicMapping).Update(InputStr,"^")
		}
	}
	
	//[感]标本    (检验->院感)
	If CategoryCode="InfDicSpecimen" {
		//update by zf 20160308 数据池相关程序修改(检验)
		Set xSpecID=0
		For {
			Set xSpecID=$o(^DHCMed.DC.LIS.BTSpecimenD(xSpecID))
			Quit:xSpecID=""
			
			Set obj=##class(DHCMed.DC.LIS.BTSpecimen).GetObjById(xSpecID)
			Continue:'$IsObject(obj)
			Continue:obj.Active'=1
			Set SpecCode=obj.Code
			Set SpecDesc=obj.CName
			
			Set Target=""
			Set TargetDesc=""
			Set ResumeText="" //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空
			Set MapID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(CategoryCode,"U")," "_$ZCVT(SpecCode,"U"),""))
			If MapID'="" {
				Set objMKMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(MapID)
				If $IsObject(objMKMap){
					Set Target=objMKMap.Target
					Set TargetDesc=objMKMap.TargetDesc
					Set ResumeText=objMKMap.ResumeText //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空
				}
			}
			
			Set Count=Count+1
			Set InputStr=MapID_"^"_CategoryCode_"^"_SpecCode_"^"_SpecDesc_"^"_Target_"^"_TargetDesc_"^"_ResumeText
			Set flg=##Class(DHCMed.NINF.Srv.MKDicMapping).Update(InputStr,"^")
		}
	}
	
	//[感]敏感耐药(检验->院感)
	If CategoryCode="InfDicSenTestRst" {
		//update by zf 20160308 数据池相关程序修改(检验)
		Set xSensID=0
		For {
			Set xSensID=$o(^DHCMed.DC.LIS.BTSensitivityD(xSensID))
			Quit:xSensID=""
			
			Set obj=##class(DHCMed.DC.LIS.BTSensitivity).GetObjById(xSensID)
			Continue:'$IsObject(obj)
			Continue:obj.Active'=1
			Set SensCode=obj.Code
			Set SensDesc=obj.CName
			
			Set Target=""
			Set TargetDesc=""
			Set ResumeText="" //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空			
			Set MapID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(CategoryCode,"U")," "_$ZCVT(SensCode,"U"),""))
			If MapID'="" {
				Set objMKMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(MapID)
				If $IsObject(objMKMap){
					Set Target=objMKMap.Target
					Set TargetDesc=objMKMap.TargetDesc
					Set ResumeText=objMKMap.ResumeText //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空
				}
			}
			
			Set Count=Count+1
			Set InputStr=MapID_"^"_CategoryCode_"^"_SensCode_"^"_SensDesc_"^"_Target_"^"_TargetDesc_"^"_ResumeText
			Set flg=##Class(DHCMed.NINF.Srv.MKDicMapping).Update(InputStr,"^")
		}
	}
	
	//[感]给药途径(医嘱->院感)
	If CategoryCode="InfDicAdminRoute" {
		Set xPHCInstID=0
		For {
			Set xPHCInstID=$o(^PHCIN(xPHCInstID))
			Quit:xPHCInstID=""
			Set PHCInstDesc=$p($g(^PHCIN(xPHCInstID)),"^",2)
			Set:PHCInstDesc="" PHCInstDesc=$p($g(^PHCIN(xPHCInstID)),"^",3)
			Continue:PHCInstDesc=""
			
			Set Target=""
			Set TargetDesc=""
			Set ResumeText="" //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空						
			Set MapID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(CategoryCode,"U")," "_$ZCVT(xPHCInstID,"U"),""))
			If MapID'="" {
				Set objMKMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(MapID)
				If $IsObject(objMKMap){
					Set Target=objMKMap.Target
					Set TargetDesc=objMKMap.TargetDesc
					Set ResumeText=objMKMap.ResumeText //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空
				}
			}
			
			Set Count=Count+1
			Set InputStr=MapID_"^"_CategoryCode_"^"_xPHCInstID_"^"_PHCInstDesc_"^"_Target_"^"_TargetDesc_"^"_ResumeText
			Set flg=##Class(DHCMed.NINF.Srv.MKDicMapping).Update(InputStr,"^")
		}
	}
	
	//[感]麻醉方式(手术->院感)
	If CategoryCode="InfDicAnesthesia" {
		Set OrdsOperFlag=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfOperDataSource","")
	 	Set OrdsOperFlag=+OrdsOperFlag
	 	If OrdsOperFlag=1 {        //取安贞手术申请信息
	 		//略
	 	} ElseIf OrdsOperFlag=2 {  //取手术麻醉系统信息
	 		Set xAnmetID=""
			For {
				Set xAnmetID=$o(^ORC("ANMET",xAnmetID))
				Quit:xAnmetID=""
				Set AnmetDesc=$p($g(^ORC("ANMET",xAnmetID)),"^",2)
				Continue:AnmetDesc=""
				
				Set Target=""
				Set TargetDesc=""
				Set ResumeText="" //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空						
				Set MapID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(CategoryCode,"U")," "_$ZCVT(xAnmetID,"U"),""))
				If MapID'="" {
					Set objMKMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(MapID)
					If $IsObject(objMKMap){
						Set Target=objMKMap.Target
						Set TargetDesc=objMKMap.TargetDesc
						Set ResumeText=objMKMap.ResumeText //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空
					}
				}
				
				Set Count=Count+1
				Set InputStr=MapID_"^"_CategoryCode_"^"_xAnmetID_"^"_AnmetDesc_"^"_Target_"^"_TargetDesc_"^"_ResumeText
				Set flg=##Class(DHCMed.NINF.Srv.MKDicMapping).Update(InputStr,"^")
			}
	 	} ElseIf OrdsOperFlag=3 {  //取电子病历系统信息
	 		//无
	 	} ElseIf OrdsOperFlag=5{   //手术接口
	 		//无
	 	} Else {                   //取手术医嘱信息
	 		//无
	 	}
	}
	
	//[目]协和-标本(检验->多耐监测)
	If CategoryCode="XHAIMDicSpecimen" {
		//update by zf 20160308 数据池相关程序修改(检验)
		Set xSpecID=0
		For {
			Set xSpecID=$o(^DHCMed.DC.LIS.BTSpecimenD(xSpecID))
			Quit:xSpecID=""
			
			Set obj=##class(DHCMed.DC.LIS.BTSpecimen).GetObjById(xSpecID)
			Continue:'$IsObject(obj)
			Continue:obj.Active'=1
			Set SpecCode=obj.Code
			Set SpecDesc=obj.CName
			Continue:SpecDesc=""
			
			Set Target=""
			Set TargetDesc=""
			Set ResumeText="" //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空						
			Set MapID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(CategoryCode,"U")," "_$ZCVT(SpecDesc,"U"),""))
			If MapID'="" {
				Set objMKMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(MapID)
				If $IsObject(objMKMap){
					Set Target=objMKMap.Target
					Set TargetDesc=objMKMap.TargetDesc
					Set ResumeText=objMKMap.ResumeText //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空
				}
			}
			
			Set Count=Count+1
			Set InputStr=MapID_"^"_CategoryCode_"^"_SpecDesc_"^"_""_"^"_Target_"^"_TargetDesc_"^"_ResumeText
			Set flg=##Class(DHCMed.NINF.Srv.MKDicMapping).Update(InputStr,"^")
		}
	}
	
	//[目]协和-多重耐药菌 (院感->多耐监测)
	If CategoryCode="XHAIMDicMRB" {
		Set xID=""
	 	For {
		 	Set xID=$o(^DHCMed.NINFD("MRB",xID))
		 	Quit:xID=""
		 	
			Set objMRB=##class(DHCMed.NINF.Dic.MRB).GetObjById(xID)
			Continue:'$IsObject(objMRB)
			Set IsActive=objMRB.Active
			Continue:IsActive'=1
			Set MRBCode=objMRB.Code
			Set MRBDesc=objMRB.Description
			Continue:MRBDesc=""
			
			Set Target=""
			Set TargetDesc=""
			Set ResumeText="" //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空						
			Set MapID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(CategoryCode,"U")," "_$ZCVT(MRBDesc,"U"),""))
			If MapID'="" {
				Set objMKMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(MapID)
				If $IsObject(objMKMap){
					Set Target=objMKMap.Target
					Set TargetDesc=objMKMap.TargetDesc
					Set ResumeText=objMKMap.ResumeText //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空
				}
			}
			
			Set Count=Count+1
			Set InputStr=MapID_"^"_CategoryCode_"^"_MRBDesc_"^"_""_"^"_Target_"^"_TargetDesc_"^"_ResumeText
			Set flg=##Class(DHCMed.NINF.Srv.MKDicMapping).Update(InputStr,"^")
		}
	}
	
	//[目]协和-麻醉方式 (手术->手术切口监测)
	If CategoryCode="XHAIMDicAnesthesia" {
		Set xID=""
	 	For {
		 	Set xID=$o(^ORC("ANMET",xID))
		 	Quit:xID=""
		 	
		 	Set ANMETDesc=$p(^ORC("ANMET",xID),"^",2)
		 	Continue:ANMETDesc=""
			
			Set Target=""
			Set TargetDesc=""
			Set ResumeText="" //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空						
			Set MapID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(CategoryCode,"U")," "_$ZCVT(ANMETDesc,"U"),""))
			If MapID'="" {
				Set objMKMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(MapID)
				If $IsObject(objMKMap){
					Set Target=objMKMap.Target
					Set TargetDesc=objMKMap.TargetDesc
					Set ResumeText=objMKMap.ResumeText //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空
				}
			}
			
			Set Count=Count+1
			Set InputStr=MapID_"^"_CategoryCode_"^"_ANMETDesc_"^"_""_"^"_Target_"^"_TargetDesc_"^"_ResumeText
			Set flg=##Class(DHCMed.NINF.Srv.MKDicMapping).Update(InputStr,"^")
		}
	}
	
	Set return=Count
	Quit return
}

/// w ##Class(DHCMed.NINF.Srv.MKDicMapping).ProMKDicMap()
ClassMethod ProMKDicMap()
{
	New
	
	Kill ^TMP($zn,$j,"ProMKDicMap")
	
	Set SSDicType="INFMinkeMappingType"
	Set xSSDicID=0
 	For {
	 	Set xSSDicID=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_$zcvt(SSDicType,"U"),xSSDicID))
	 	Quit:xSSDicID=""
	 	
	 	Set objSSDic=##class(DHCMed.SS.Dictionary).GetObjById(xSSDicID)
	 	Continue:'$IsObject(objSSDic)
	 	Set Active=objSSDic.Active
		Continue:Active'=1
		Set Type=objSSDic.Type
		Continue:SSDicType'=Type
		Set Code=objSSDic.Code
		Set StrA=objSSDic.StrA
		Set StrB=objSSDic.StrB
		Set StrC=objSSDic.StrC
		Continue:(StrA'="MKDIC")||(StrB="")||(Code="")
		
		Set Category=Code
		
		//^DHCMed.NINFSi("MKDic",0,"IndexIDCode"," 000",25866)
		Set xMKDicIDCode=" "_$zcvt(StrB,"U")
		For {
			Set xMKDicIDCode=$o(^DHCMed.NINFSi("MKDic",0,"IndexIDCode",xMKDicIDCode))
			Quit:xMKDicIDCode=""
			Quit:$e(xMKDicIDCode,2,$l(StrB)+1)'=StrB
			
			Set xMKDicID=$o(^DHCMed.NINFSi("MKDic",0,"IndexIDCode",xMKDicIDCode,""))
			Continue:xMKDicID=""
			Set objMKDic=##class(DHCMed.NINF.Srv.MKDictionary).GetObjById(xMKDicID)
			Continue:'$IsObject(objMKDic)
			Set IsActive=objMKDic.IsActive
			Continue:IsActive=""
			Continue:IsActive=1
			Set MKDicCode=objMKDic.Code
			Set MKDicDesc=objMKDic.Description
			//w MKDicDesc,!
			Set ^TMP($zn,$j,"ProMKDicMap",StrB,MKDicCode)=MKDicDesc
		}
		
		//^DHCMed.NINFSi("MKDMap",0,"IndexCategory"," INFDICANTIBIOTICS",2361)
		Set xMKMapID=0
		For {
			Set xMKMapID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategory"," "_$zcvt(Category,"U"),xMKMapID))
			Quit:xMKMapID=""
			
			Set objMKMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(xMKMapID)
			Continue:'$IsObject(objMKMap)
			Set Target=objMKMap.Target
			Set TargetDesc=objMKMap.TargetDesc
			If Target'="" {
				Continue:'$d(^TMP($zn,$j,"ProMKDicMap",StrB,Target))
			} Else {
				Continue:(Target="")&&(TargetDesc="")
			}
			
			Set objMKMap=##class(DHCMed.NINF.Srv.MKDicMapping).%OpenId(xMKMapID)
			Set objMKMap.Target=""
			Set objMKMap.TargetDesc=""
			Set sc=objMKMap.%Save()
			If $System.Status.IsError(sc) {  //检查Save是否成功
		   		Do $System.OBJ.DisplayError(sc)
			}
			Do objMKMap.%Close()
		}
 	}
 	Kill ^TMP($zn,$j,"ProMKDicMap")
	
	Quit "OK"
}

/// w ##Class(DHCMed.NINF.Srv.MKDicMapping).ProErrData()
ClassMethod ProErrData()
{
	New
	Set xID=0
	For {
		Set xID=$o(^DHCMed.NINFS("MKDMap",xID))
		Quit:xID=""
		
		Set objMKMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(xID)
		Continue:'$IsObject(objMKMap)
		Set Target=objMKMap.Target
		Set TargetDesc=objMKMap.TargetDesc
		Set Category=objMKMap.Category
		Set SrcObjectID=objMKMap.SrcObjectID
		Set SrcDescription=objMKMap.SrcDescription
		Set ResumeText=objMKMap.ResumeText //Add By LiYang 2014-11-01 FixBug:3951 医院感染管理-全院综合性监测-基础数据维护-基础字典对照-输入的说明不能成功保存,再次打开显示为空						
		Set InputStr=xID_"^"_Category_"^"_SrcObjectID_"^"_SrcDescription_"^"_Target_"^"_TargetDesc_"^"_ResumeText
		Set flg=##Class(DHCMed.NINF.Srv.MKDicMapping).Update(InputStr,"^")
	}
	
	Quit "OK"
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Category</Value>
</Value>
<Value name="3">
<Value>SrcObjectID</Value>
</Value>
<Value name="4">
<Value>SrcDescription</Value>
</Value>
<Value name="5">
<Value>Target</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
<Value name="7">
<Value>TargetDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFS("MKDMap")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFS("MKDMap")</IdLocation>
<IndexLocation>^DHCMed.NINFSi("MKDMap",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Srv.MKDicMappingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
