/// 临床路径查询
Class web.DHCCPW.MRC.PathWayQry Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 处理科室、常用临床路径、版本的三级查询
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.PathWayQry","QryLocPathVer","15-dep","")
Query QryLocPathVer(argNodeID As %String, argLocID As %String) As %Query(ROWSPEC = "id:%String,text:%String,icon:%String,leaf:%String")
{
}

ClassMethod QryLocPathVerExecute(ByRef qHandle As %Binary, argNodeID As %String, argLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set QryType=$p(argNodeID,"-",2)
	If QryType="root" {  //查询临床路径类别
		//临床路径版本树的结构改为：类别-临床路径字典-版本
		Set ZIndex=$zn,JIndex=$j
		Kill ^TMP(ZIndex,JIndex,"QryLocPathVerTMP")
		Set argLocID=+argLocID
		Set CPWDicID=0
		For {
			Set CPWDicID=$o(^DHCMRC("CPWD",CPWDicID))
			Quit:CPWDicID=""
			Set objCPWDic=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWDicID)
			Continue:'$IsObject(objCPWDic)
			Continue:'$IsObject(objCPWDic.CPWDCPWTypeDR)
			Continue:(objCPWDic.CPWDActive="N") //FixBug:72 临床路径维护--基础字典维护-路径字典维护-路径修改为不生效后,科室路径维护没有及时刷新 临床路径类别列表中显示的是ID，不是版本号
			Continue:((+$h<objCPWDic.CPWDDateFrom)&&(objCPWDic.CPWDDateFrom'="")) //Fix Bug:71  临床路径维护--基础字典维护-路径字典维护-不生效的路径在科室常用路径维护界面依旧显示.通过生效、废止日期 两个项目进行判定
			Continue:((+$h>objCPWDic.CPWDDateTo)&&(objCPWDic.CPWDDateTo'=""))
			Set CPWDicTypeID=objCPWDic.CPWDCPWTypeDR.%Id()
			Continue:CPWDicTypeID=""
			//管理员或者在常用临床路径列表中
			If argLocID=0 {
				Set ^TMP(ZIndex,JIndex,"QryLocPathVerTMP",CPWDicTypeID,CPWDicID)=""
			}Else{
				Set DepCPWDID=0
				For {
					Set DepCPWDID=$o(^DHCMRCi("DEPCPW",0,"IndexLoc"," "_argLocID,DepCPWDID))
					Quit:DepCPWDID=""
					Set objDepCPWD=##class(web.DHCCPW.MRC.DeptPahtWay).GetObjById(DepCPWDID)
					Continue:'$IsObject(objDepCPWD)
					Continue:'$IsObject(objDepCPWD.DCPWCPWDR)  //update by zf 20120328
					Set CPWDID=objDepCPWD.DCPWCPWDR.%Id()
					Continue:CPWDID'=CPWDicID
					Set ^TMP(ZIndex,JIndex,"QryLocPathVerTMP",CPWDicTypeID,CPWDicID)=""
				}
			}
		}
		Set TypeID=""
		For {
			Set TypeID=$o(^TMP(ZIndex,JIndex,"QryLocPathVerTMP",TypeID))
			Quit:TypeID=""
			Set objCPWDicType=##class(web.DHCCPW.MRC.PathWayType).GetObjById(TypeID)
			Continue:'$IsObject(objCPWDicType)
			Set Desc=objCPWDicType.CLPTDesc
			Set NodeID=TypeID_"-Type"
			Set ImageSrc="../images/websys/zreports.gif"
			Set:objCPWDicType.CLPTCode="SYNDROME" ImageSrc="../images/websys/reports2.gif"     //add by wuqk 2011-07-22 并发症图标
			Set Leaf="false"
			Set Data=$lb(NodeID,Desc,ImageSrc,Leaf)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		Kill ^TMP(ZIndex,JIndex,"QryLocPathVerTMP")
	}
	
	If QryType="Type" {   //查询科室路径
		Set LocID=argLocID
		Set TypeID=+argNodeID
		Set CPWID=""
		For {
			Set CPWID=$o(^DHCMRC("CPWD",CPWID))
			Quit:CPWID=""
			If LocID'="" {
				Set DCPWDID="",flg=0
				For {
					Set DCPWDID=$o(^DHCMRCi("DEPCPW",0,"IndexLoc"," "_LocID,DCPWDID))
					Quit:(DCPWDID="")||(flg=1)
					Set objDCPWD=##class(web.DHCCPW.MRC.DeptPahtWay).GetObjById(DCPWDID)
					Continue:'$IsObject(objDCPWD)
					Continue:'$IsObject(objDCPWD.DCPWCPWDR)  //update by zf 20120328
					Set xCPWDID=objDCPWD.DCPWCPWDR.%Id()
					Set:CPWID=xCPWDID flg=1
				}
				Continue:flg=0
			}
			Set objCPW=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWID)
			Continue:'$IsObject(objCPW)
			Continue:'$IsObject(objCPW.CPWDCPWTypeDR)
			Set CPWDTypeID=objCPW.CPWDCPWTypeDR.%Id()
			Continue:CPWDTypeID'=TypeID
			Set IsActive=objCPW.CPWDActive
			Set DateFrom=objCPW.CPWDDateFrom
			Set DateTo=objCPW.CPWDDateTo
			Continue:IsActive'["Y"
			Continue:(IsActive["Y")&&(DateFrom'="")&&(DateFrom>+$h)
			Continue:(IsActive["Y")&&(DateTo'="")&&(DateTo<+$h)
			Set NodeID=CPWID_"-Path"_"-"_LocID_"-Type"
			Set Desc=objCPW.CPWDDesc
			Continue:Desc=""
			Set ImageSrc="../images/websys/home.gif"
			Set Leaf="false"
			Set Data=$lb(NodeID,Desc,ImageSrc,Leaf)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	If QryType="Path" {    //查询临床路径版本
		Set CPWDicID=$p(argNodeID,"-",1)
		Set CPWDVersion=""
		Set objCPWDic=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWDicID)
		If $IsObject(objCPWDic) {
			Set CPWDVersion=objCPWDic.CPWDVersion
		}
		Set Ver=0
		For {
			Set Ver=$o(^DHCMRCi("CPW",0,"IndexClinPathWaysDicVer",CPWDicID,Ver))
			Quit:Ver=""
			
			Set CPWID=0
			For {
				Set CPWID=$o(^DHCMRCi("CPW",0,"IndexClinPathWaysDicVer",CPWDicID,Ver,CPWID))
				Quit:CPWID=""
				
				
				Set (NodeID,Desc,ImgPath,Leaf,Version)=""
				Set (IsActive,DateFrom,DateTo,PublicDate,PublicTime)=""
				Set objVersion=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
				If $IsObject(objVersion){
					Set Version=objVersion.CPWVersion
					Set Version=+Version
					Set IsActive=objVersion.CPWActive
					Set DateFrom=objVersion.CPWDateFrom
					Set DateTo=objVersion.CPWDateTo
					Set PublicDate=objVersion.CPWVerDate
					;Set:PublicDate'="" PublicDate=$zd(PublicDate,3)
					Set:PublicDate'="" PublicDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(PublicDate)
					Set PublicTime=objVersion.CPWVerTime
					Set PublicUser=objVersion.CPWVerUserDR
				}
				Continue:IsActive'["Y"
				Continue:(IsActive["Y")&&(DateFrom'="")&&(DateFrom>+$h)
				Continue:(IsActive["Y")&&(DateTo'="")&&(DateTo<+$h)
				
				Set NodeID=CPWID_"-Ver-"_(+PublicDate>0)_"-"_$p(argNodeID,"-",3)_"-Dep" //Add By LiYang 2011-02-26 防止多个科室同时有同一个临床路径引起的界面问题
				If PublicDate="" {
					Set Desc="V"_Version_".0 未发布"
					Set ImgPath="../images/websys/edit_orange.gif"
				} Else {
					Set Desc="V"_Version_".0 "_PublicDate
					Set ImgPath="../images/websys/edit_green.gif"
				}
				If CPWDVersion=CPWID {
					Set Desc=Desc_"(正使用)"
				}
				Set Leaf="true"
				Set Data=$lb(NodeID,Desc,ImgPath,Leaf)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryLocPathVerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocPathVerExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocPathVerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocPathVerExecute ]
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

/// 查询临床路径内容
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.PathWayQry","QryPathContent","10||1||1-Categ-1")
Query QryPathContent(argNodeID As %String, argOutFormat As %String) As %Query(ROWSPEC = "id:%String,text:%String,icon:%String,leaf:%String")
{
}

ClassMethod QryPathContentExecute(ByRef qHandle As %Binary, argNodeID As %String, argOutFormat As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set ZIndex=$zn,JIndex=$j
	Set Type=$p(argNodeID,"-",2)
	If Type="Ver" {
		Kill ^TMP(ZIndex,JIndex,"QryPathContent-Episode")
		Set CPWID=$p(argNodeID,"-",1)
		Set EpID=""
		For {
			Set EpID=$o(^DHCMRC("CPW",CPWID,"EP",EpID))
			Quit:EpID=""
			Set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(CPWID_"||"_EpID)
			If $IsObject(objEp){
				Set Episode=+objEp.EPEpisode
				Set NodeID=CPWID_"||"_EpID_"-Ep"
				Set Desc=objEp.EPDesc
				Set ImgPath="../images/websys/zreports.gif"
				Set Leaf="false"
				Set Data=$lb(NodeID,Desc,ImgPath,Leaf)
				Set ^TMP(ZIndex,JIndex,"QryPathContent-Episode",Episode,EpID)=Data
			}
		}
		Set Episode=0
		For {
			Set Episode=$o(^TMP(ZIndex,JIndex,"QryPathContent-Episode",Episode))
			Quit:Episode=""
			Set EpID=0
			For {
				Set EpID=$o(^TMP(ZIndex,JIndex,"QryPathContent-Episode",Episode,EpID))
				Quit:EpID=""
				Set Data=$g(^TMP(ZIndex,JIndex,"QryPathContent-Episode",Episode,EpID))
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		Kill ^TMP(ZIndex,JIndex,"QryPathContent-Episode")
		
		//modify by wuqk 2011-07-27 将已经维护好的阶段全部删除后，该节点依然存在，造成无法继续进入维护页面
		//将此处的逻辑修改为：只要未查询出阶段，即显示...信息
		//If (argOutFormat=1)&&'$d(^DHCMRC("CPW",CPWID,"EP")) {
		If (argOutFormat=1)&&(ind=1) {  
			Set NodeID=CPWID_"||"_0_"-Ep"
			Set Desc="请维护临床路径阶段..."
			Set ImgPath="../images/websys/zreports.gif"
			Set Leaf="true"
			Set Data=$lb(NodeID,Desc,ImgPath,Leaf)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	If Type="Ep" {
		Kill ^TMP(ZIndex,JIndex,"QryPathContent-Episode")
		Set EpRowID=$p(argNodeID,"-",1)
		Set CPWID=$p(EpRowID,"||",1)
		Set EpID=$p(EpRowID,"||",2)
		Set StepID=0
		For {
			Set StepID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID))
			Quit:StepID=""
			Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(CPWID_"||"_EpID_"||"_StepID)
			If $IsObject(objStep){
				Set Episode=objStep.CPWSDayNumber
				Set NodeID=CPWID_"||"_EpID_"||"_StepID_"-Step"
				Set Desc=objStep.CPWSDesc
				Set ImgPath="../images/websys/report.gif"
				Set Leaf="false"
				Set Data=$lb(NodeID,Desc,ImgPath,Leaf)
				Set ^TMP(ZIndex,JIndex,"QryPathContent-Episode",Episode,StepID)=Data
			}
		}
		Set Episode=0
		For {
			Set Episode=$o(^TMP(ZIndex,JIndex,"QryPathContent-Episode",Episode))
			Quit:Episode=""
			Set StepID=0
			For {
				Set StepID=$o(^TMP(ZIndex,JIndex,"QryPathContent-Episode",Episode,StepID))
				Quit:StepID=""
				Set Data=$g(^TMP(ZIndex,JIndex,"QryPathContent-Episode",Episode,StepID))
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		Kill ^TMP(ZIndex,JIndex,"QryPathContent-Episode")
		
		//modify by wuqk 2011-07-27 将已经维护好的步骤全部删除后，该节点依然存在，造成无法继续进入维护页面
		//将此处的逻辑修改为：只要未查询出步骤，即显示...信息
		//If (argOutFormat=1)&&(EpID>0)&&'$d(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP")) {
		If (argOutFormat=1)&&(EpID>0)&&(ind=1)  {
			Set NodeID=CPWID_"||"_EpID_"||"_0_"-Step"
			Set Desc="请维护临床路径步骤..."
			Set ImgPath="../images/websys/report.gif"
			Set Leaf="true"
			Set Data=$lb(NodeID,Desc,ImgPath,Leaf)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	If Type="Step" {
		Set StepRowID=$p(argNodeID,"-",1)
		Set CategID=0
		For {
			Set CategID=$o(^DHCMRC("SIC",CategID))
			Quit:CategID=""
			Set objCateg=##class(web.DHCCPW.MRC.StepItemCategory).GetObjById(CategID)
			If $IsObject(objCateg){
				//******* Add by zhaoyu 2013-04-26 基础信息维护--项目大类-项目大类的开始日期无效
				Set DateFrom=objCateg.SICDateFrom	//开始日期
				Continue:(DateFrom'="")&&(+DateFrom>+$p($h,",",1))	//过滤开始日期
				//******* Modified by zhaoyu 2012-12-07 基础信息维护--项目大类-项目大类的结束日期无效 188
				Set DateTo=objCateg.SICDateTo	//结束日期
				Continue:(DateTo'="")&&(+DateTo<+$p($h,",",1))	//过滤结束日期
				//*******
				Set NodeID=StepRowID_"-Categ-"_CategID
				Set Desc=objCateg.SICDesc
				Set ImgPath="../images/websys/edit.gif"
				Set Leaf="true"
				Set:argOutFormat=2 Leaf="false"
				Set Data=$lb(NodeID,Desc,ImgPath,Leaf)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	If Type="Categ" {
		Kill ^TMP(ZIndex,JIndex,"QryPathContent-Episode")
		Set StepRowID=$p(argNodeID,"-",1)
		Set CategRowID=$p(argNodeID,"-",3)
		Set CPWID=$p(StepRowID,"||",1)
		Set EpID=$p(StepRowID,"||",2)
		Set StepID=$p(StepRowID,"||",3)
		Set ItemID=0
		For {
			Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
			Quit:ItemID=""
			Set ItemRowID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
			Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemRowID)
			If $IsObject(objItem){
				Set Episode=objItem.CPWSIGroupNo
				Set NodeID=objItem.%Id()_"-Item"
				Set Desc=objItem.CPWSIDesc
				Set ImgPath="../images/websys/new.gif"
				Set Leaf="true"
				Set Data=$lb(NodeID,Desc,ImgPath,Leaf)
				Set ^TMP(ZIndex,JIndex,"QryPathContent-Episode",Episode,ItemID)=Data
			}
		}
		Set Episode=0
		For {
			Set Episode=$o(^TMP(ZIndex,JIndex,"QryPathContent-Episode",Episode))
			Quit:Episode=""
			Set ItemID=0
			For {
				Set ItemID=$o(^TMP(ZIndex,JIndex,"QryPathContent-Episode",Episode,ItemID))
				Quit:ItemID=""
				Set Data=$g(^TMP(ZIndex,JIndex,"QryPathContent-Episode",Episode,ItemID))
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		Kill ^TMP(ZIndex,JIndex,"QryPathContent-Episode")
	}
	
	Quit $$$OK
}

ClassMethod QryPathContentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathContentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathContentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathContentExecute ]
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

}
