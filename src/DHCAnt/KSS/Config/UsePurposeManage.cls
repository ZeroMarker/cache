/// CTOR: QP
/// DATE: 2019-07-26
/// DESC: 抗菌药物-抗菌药物使用目的管控
Class DHCAnt.KSS.Config.UsePurposeManage Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2019-07-26
/// DESC: 保存
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Config.UsePurposeManage).SaveUPM("^ZL^USE^12^920||1^A^1^1")
ClassMethod SaveUPM(mList As %String) As %String
{
	n (mList)
	s ^TEMP("QP","SaveUPM",1)=mList
	s id = $p(mList,"^",1)
	s objCode = $p(mList,"^",2)
	s level  = $p(mList,"^",3)
	s item  = $p(mList,"^",4)
	s arcimDr = $p(mList,"^",5)
	s controlType = $p(mList,"^",6)
	s active = $p(mList,"^",7)
	s excuteUser= $p(mList,"^",8)
	s inHosp= $p(mList,"^",9)
	Q:inHosp="" "-500"	//院区为空
	s objDr = ""
	s itemDr = ""
	s purposeDr = ""
	i level="USE" d
	.s purposeDr=item
	.s objDr=$p(^DHCAntBasePurposeDataConfigD(purposeDr),"^",6)
	.s itemDr=$p(^DHCAntBasePurposeDataConfigD(purposeDr),"^",7)
	i level="ITEM" s itemDr=item
	i level="OBJ" s objDr=item
	i objDr="" s objDr=..GetOBJDrByCode(objCode)
	
	s cDate=+$h,cTime=$p($h,",",2)
	if (id="") {
		s hasFlag=..HasConfig(mList,"","add")
		Q:hasFlag'=0 "-110"	//记录已存在
		s saveObj = ##class(DHCAnt.Base.Config.UsePurposeManage).%New()
		s saveObj.UPMAddDate=cDate
		s saveObj.UPMAddTime=cTime
		d saveObj.UPMAddUserSetObjectId(excuteUser)
	} else {
		s saveObj = ##class(DHCAnt.Base.Config.UsePurposeManage).%OpenId(id)
		s saveObj.UPMUpdateDate=cDate
		s saveObj.UPMUpdateTime=cTime
		d saveObj.UPMUpdateUserSetObjectId(excuteUser)
		s oldArcim  = saveObj.UPMArcimDrGetObjectId()
		s oldObjDr  = saveObj.UPMUseOBJDrGetObjectId()
		s oldItemDr = saveObj.UPMUseItemDrGetObjectId()
		s oldUseDr  = saveObj.UPMUsePurposeDrGetObjectId()
		s oldLevel  = saveObj.UPMLevel
		s oldHosp   = saveObj.UPMHosp
		s oldUseInfo = oldObjDr_"^"_oldItemDr_"^"_oldUseDr_"^"_oldArcim_"^"_oldLevel_"^"_oldHosp
		s hasFlag=..HasConfig(mList,oldUseInfo,"edit")
		Q:hasFlag'=0 "-110"	//记录已存在
	}
	
	d saveObj.UPMUseOBJDrSetObjectId(objDr)
	d saveObj.UPMUseItemDrSetObjectId(itemDr)
	d saveObj.UPMUsePurposeDrSetObjectId(purposeDr)
	d saveObj.UPMArcimDrSetObjectId(arcimDr)
	s saveObj.UPMControlType=controlType
	s saveObj.UPMActive=active
	s saveObj.UPMLevel=level
	s saveObj.UPMHosp=inHosp
	
	s sc=saveObj.%Save()
	If $$$ISERR(sc) {
		d $system.OBJ.DisplayError(sc) 
		Quit "-100"
	}
	s mRtn=saveObj.%Id()
	d saveObj.%Close()
	
    q mRtn
}

/// CTOR: QP
/// DATE: 2019-07-26
/// DESC: 查询抗菌药物使用目的管控配置
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Config.UsePurposeManage","QryUPM","","","","","","","1","^^2")
Query QryUPM(InLevel = "", InOBJDr = "", InItemDr = "", InUsePurposeDr = "", InArcim = "", InControlType = "", InActive = "", InExtendPara = "") As %Query(ROWSPEC = "id,objDr,objDesc,itemDr,itemDesc,purposeDr,purposeDesc,arcimDr,arcimDesc,controlTypeCode,controlType,active,levelCode,levelDesc,controlItem,controlItemDr,objCode")
{
}

ClassMethod QryUPMExecute(ByRef qHandle As %Binary, InLevel = "", InOBJDr = "", InItemDr = "", InUsePurposeDr = "", InArcim = "", InControlType = "", InActive = "", InExtendPara = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ^TEMP("QP","QryUPM",1)=$LB(InOBJDr,InItemDr,InUsePurposeDr,InArcim,InControlType,InActive,InExtendPara)
	s InObjCode=$p(InExtendPara,"^",1)
	s InItem=$p(InExtendPara,"^",2)
	s InHosp=$p(InExtendPara,"^",3)
	i InHosp="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	i InLevel="USE" d
	.s InUsePurposeDr=InItem
	.q:InItem=""
	.s InOBJDr=$p(^DHCAntBasePurposeDataConfigD(InUsePurposeDr),"^",6)
	.s InItemDr=$p(^DHCAntBasePurposeDataConfigD(InUsePurposeDr),"^",7)
	i InLevel="ITEM" s InItemDr=InItem
	i InLevel="OBJ" s InOBJDr=InItem
	i InOBJDr="" s InOBJDr=..GetOBJDrByCode(InObjCode)
	s ^TEMP("QP","QryUPM",2)=$LB(InOBJDr,InItemDr,InUsePurposeDr,InArcim,InControlType,InActive,InExtendPara)
	b ;00
	s YF=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMYF",InHosp)
	s YFLEVEL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMYFLEVEL",InHosp)
	s YFVAL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMYFVAL",InHosp)
	i YFVAL'="" s YFVAL=","_YFVAL_","
	
	s ZL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMZL",InHosp)
	s ZLLEVEL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMZLLEVEL",InHosp)
	s ZLVAL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMZLVAL",InHosp)
	i ZLVAL'="" s ZLVAL=","_ZLVAL_","
	if (YF=0)&&(ZL=0) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	
	i (InUsePurposeDr'="") {
		s id=0
		f  s id=$o(^CF.ANT("UsePurposeManage",0,"UPMUsePurposeDr",InUsePurposeDr,id)) q:id=""  d
		.d GetUPMList

	} elseif (InItemDr'="") {
		s id=0
		f  s id=$o(^CF.ANT("UsePurposeManage",0,"UPMItemDr",InItemDr,id)) q:id=""  d
		.d GetUPMList
	} elseif (InOBJDr'="") {
		s id=0
		f  s id=$o(^CF.ANT("UsePurposeManage",0,"UPMOBJDr",InOBJDr,id)) q:id=""  d
		.d GetUPMList
	} else {
		s id=0
		f  s id=$o(^CF.ANT("UsePurposeManage",id)) q:id=""  d
		.d GetUPMList
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetUPMList
	s objDr=$p(^CF.ANT("UsePurposeManage",id),"^",1)
	s objDesc="",objCode=""
	i objDr'="" d 
	.s objDesc=$p(^DHCAntBasePurposeDataConfigD(objDr),"^",3)
	.s objCode=$p(^DHCAntBasePurposeDataConfigD(objDr),"^",4)
	q:(YF=0)&&(objCode="YF")
	q:(ZL=0)&&(objCode="ZL")
	q:(objCode="YF")&&(YFVAL="")
	q:(objCode="ZL")&&(ZLVAL="")
	s itemDr=$p(^CF.ANT("UsePurposeManage",id),"^",2)
	s itemDesc=""
	i itemDr'="" s itemDesc=$p(^DHCAntBasePurposeDataConfigD(itemDr),"^",3)
	s purposeDr=$p(^CF.ANT("UsePurposeManage",id),"^",3)
	s purposeDesc=""
	i purposeDr'="" s purposeDesc=$p(^DHCAntBasePurposeDataConfigD(purposeDr),"^",3)
	
	s arcimDr=$p(^CF.ANT("UsePurposeManage",id),"^",4)
	s arcimDesc=""
	i arcimDr'="" s arcimDesc=$p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1),"^",2)
	s controlTypeCode=$p(^CF.ANT("UsePurposeManage",id),"^",5)
	q:(InControlType'="")&&(InControlType'=controlTypeCode)
	s controlType=..GetControlTypeDesc(controlTypeCode)
	s active=$p(^CF.ANT("UsePurposeManage",id),"^",6)
	q:(InArcim'="")&&(arcimDr'=InArcim)
	q:(InActive'="")&&(InActive'=active)
	s levelCode=$p(^CF.ANT("UsePurposeManage",id),"^",13)
	s hospID=$p(^CF.ANT("UsePurposeManage",id),"^",14)
	Q:InHosp'=hospID
	q:(InLevel'="")&&(InLevel'=levelCode)
	s levelDesc=..GetLevelDesc(levelCode)
	s controlItem="",controlItemDr=""
	i levelCode="USE" s controlItem=purposeDesc,controlItemDr=purposeDr
	i levelCode="ITEM" s controlItem=itemDesc,controlItemDr=itemDr
	i levelCode="OBJ" s controlItem=objDesc,controlItemDr=objDr
	;
	s isYFExit=0,isZLExit=0
	i (YF'=0)&&(objCode="YF") {
		i YFVAL'="" {
			i YFVAL'[(","_controlItemDr_",") s isYFExit=1
		}
	}
	i (ZL'=0)&&(objCode="ZL") {
		i ZLVAL'="" {
			i ZLVAL'[(","_controlItemDr_",") s isZLExit=1
		}
	}
	q:(isZLExit=1)||(isYFExit=1)
	;
	
	d DHCAntOut1
	
	Q

DHCAntOut1
	set Data=$lb(id,objDr,objDesc,itemDr,itemDesc,purposeDr,purposeDesc,arcimDr,arcimDesc,controlTypeCode,controlType,active,levelCode,levelDesc,controlItem,controlItemDr,objCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QryUPMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUPMExecute ]
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

ClassMethod QryUPMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUPMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-07-26
/// DESC: 获取控制类型描述
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Config.UsePurposeManage).GetControlTypeDesc("A")
ClassMethod GetControlTypeDesc(mCode As %String) As %String
{
	n (mCode)
	s mRtn=""
	i mCode="A" s mRtn="提示"
	i mCode="F" s mRtn="禁止"
	i mCode="N" s mRtn="不控制"
	
    q mRtn
}

/// CTOR: QP
/// DATE: 2019-07-26
/// DESC: 获取所属层级描述
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Config.UsePurposeManage).GetControlTypeDesc("A")
ClassMethod GetLevelDesc(mCode As %String) As %String
{
	n (mCode)
	s mRtn=""
	i mCode="OBJ" s mRtn="使用目的大类"
	i mCode="ITEM" s mRtn="使用目的子类"
	i mCode="USE" s mRtn="使用目的"
	
    q mRtn
}

/// CTOR: QP
/// DATE: 2019-07-26
/// DESC: 根据Code得到ID
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Config.UsePurposeManage).GetOBJDrByCode("ZL")
ClassMethod GetOBJDrByCode(mCode As %String) As %String
{
	n (mCode)
	s mRtn=""
	q:mCode="" mRtn
	s id=""
	f  s id=$o(^DHCAntBasePurposeDataConfigI("PDCType","OBJ",id)) q:(id="")||(mRtn'="")  d
	.s code=$p(^DHCAntBasePurposeDataConfigD(id),"^",4)
	.i code=mCode s mRtn=id
	
    q mRtn
}

/// CTOR: QP
/// DATE: 2019-07-26
/// DESC: 是否已经存在
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Config.UsePurposeManage).HasConfig(^TEMP("qp",1),^TEMP("qp",2),^TEMP("qp",3))
ClassMethod HasConfig(mList As %String, oldUseInfo As %String, ac As %String) As %String
{
	n (mList,oldUseInfo,ac)
	s ^TEMP("qp",1)=mList
	s ^TEMP("qp",2)=oldUseInfo
	s ^TEMP("qp",3)=ac
	s newObjDr = ""
	s newItemDr = ""
	s newUseDr = ""
	s newArcim = $p(mList,"^",5)
	s newLevel = $p(mList,"^",3)
	s objCode  = $p(mList,"^",2)
	s item     = $p(mList,"^",4)
	s newHosp= $p(mList,"^",9)
	i newLevel="USE" d
	.s newUseDr=item
	.s newObjDr=$p(^DHCAntBasePurposeDataConfigD(newUseDr),"^",6)
	.s newItemDr=$p(^DHCAntBasePurposeDataConfigD(newUseDr),"^",7)
	i newLevel="ITEM" s newItemDr=item
	i newLevel="OBJ" s newObjDr=item
	i newObjDr="" s newObjDr=..GetOBJDrByCode(objCode)
	
	s oldObjDr = $p(oldUseInfo,"^",1)
	s oldItemDr = $p(oldUseInfo,"^",2)
	s oldUseDr = $p(oldUseInfo,"^",3)
	s oldArcim = $p(oldUseInfo,"^",4)
	s oldLevel = $p(oldUseInfo,"^",5)
	s oldHosp = $p(oldUseInfo,"^",6)
	Q:(newArcim="")||(newLevel="")||(newHosp="") "-102"
	i ac="add" {
		i newLevel="USE" {
			q:$d(^CF.ANT("UsePurposeManage",0,"UseLevel",newHosp,newLevel,newUseDr,newArcim)) 1	
		} elseif newLevel="ITEM"{
			q:$d(^CF.ANT("UsePurposeManage",0,"ItemLevel",newHosp,newLevel,newItemDr,newArcim)) 1
		} else {
			q:$d(^CF.ANT("UsePurposeManage",0,"OBJLevel",newHosp,newLevel,newObjDr,newArcim)) 1
		}
	} else {
		Q:(oldArcim="")||(oldLevel="")||(oldHosp="") "-101"	//医嘱项不能为空
		
		i newLevel=oldLevel	{	//层级相同
			i newLevel="USE" {
				i (newArcim=oldArcim)&&(newUseDr=oldUseDr)&&(newHosp=oldHosp) {	//改变自身
					q 0
				} else {
					q:$d(^CF.ANT("UsePurposeManage",0,"UseLevel",newHosp,newLevel,newUseDr,newArcim)) 1		
				}
			}elseif newLevel="ITEM" {
				i (newArcim=oldArcim)&&(newItemDr=oldItemDr)&&(newHosp=oldHosp) {	//改变自身
					q 0
				} else {
					q:$d(^CF.ANT("UsePurposeManage",0,"ItemLevel",newHosp,newLevel,newItemDr,newArcim)) 1	
				}
			} else {
				i (newArcim=oldArcim)&&(newObjDr=oldObjDr)&&(newHosp=oldHosp) {	//改变自身
					q 0
				} else {
					q:$d(^CF.ANT("UsePurposeManage",0,"OBJLevel",newHosp,newLevel,newObjDr,newArcim)) 1
				}	
			}
		}else {
			i newLevel="USE" {
				q:$d(^CF.ANT("UsePurposeManage",0,"UseLevel",newHosp,newLevel,newUseDr,newArcim)) 1	
			} elseif newLevel="ITEM"{
				q:$d(^CF.ANT("UsePurposeManage",0,"ItemLevel",newHosp,newLevel,newItemDr,newArcim)) 1
			} else {
				q:$d(^CF.ANT("UsePurposeManage",0,"OBJLevel",newHosp,newLevel,newObjDr,newArcim)) 1
			}
		}
	}
	
    q 0
}

/// CTOR: QP
/// DATE: 2019-07-26
/// DESC: 使用目的管控判断，前台调用
/// IN  : 0:不做控制、1:提示、2:禁止
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Config.UsePurposeManage).UPMControl($lg(^TEMP("UPMControl",1),1),$lg(^TEMP("UPMControl",1),2),$lg(^TEMP("UPMControl",1),3))
ClassMethod UPMControl(mUseAimDr As %String, mArcim As %String, inHosp As %String) As %String
{
	n (mUseAimDr,mArcim,inHosp)
	s ^TEMP("UPMControl",1)=$LB(mUseAimDr,mArcim,inHosp)
	s NMsg="0^"
	Q:(mUseAimDr="")||(mArcim="") NMsg
	s UPMYF=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMYF",inHosp)
	s UPMZL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMZL",inHosp)
	s UPMYFLEVEL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMYFLEVEL",inHosp)
	s UPMZLLEVEL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMZLLEVEL",inHosp)
	s UPMYFVAL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMYFVAL",inHosp)
	s UPMZLVAL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMZLVAL",inHosp)
	s OBJAimDr=$p(^DHCAntBasePurposeDataConfigD(mUseAimDr),"^",6)
	s ITEMAimDr=$p(^DHCAntBasePurposeDataConfigD(mUseAimDr),"^",7)
	s OBJCode=$p(^DHCAntBasePurposeDataConfigD(OBJAimDr),"^",4)
	s CLevel="",CVal="",COrder=""
	i OBJCode="YF" {
		q:(UPMYF'=1)&&(UPMYF'=2) NMsg
		q:UPMYFVAL="" NMsg
		s CLevel=UPMYFLEVEL
		s CVal=UPMYFVAL
		s COrder=UPMYF
	}
	i OBJCode="ZL" {
		q:(UPMZL'=1)&&(UPMZL'=2) NMsg
		q:UPMZLVAL="" NMsg
		s CLevel=UPMZLLEVEL
		s CVal=UPMZLVAL
		s COrder=UPMZL
	}
	
	s upmid="",upmtype=""
	s FMsg="2^该使用目的下，不能开具此医嘱！"
	s AMsg="1^该使用目的下，该药品请慎用！"
	b ;001
	i CLevel="USE"	{
		Q:(","_CVal_",")'[(","_mUseAimDr_",") NMsg
		//s hasFlag=$d(^CF.ANT("UsePurposeManage",0,"UseLevel",CLevel,mUseAimDr,mArcim))
		s hasFlag=$d(^CF.ANT("UsePurposeManage",0,"UseLevel",inHosp,CLevel,mUseAimDr,mArcim))

		i hasFlag>0 s upmid=$o(^CF.ANT("UsePurposeManage",0,"UseLevel",inHosp,CLevel,mUseAimDr,mArcim,upmid))
		i upmid'="" {
			s upmactive=$p(^CF.ANT("UsePurposeManage",upmid),"^",6)
			i upmactive=1 s upmtype=$p(^CF.ANT("UsePurposeManage",upmid),"^",5)
		}	
	} elseif CLevel="ITEM" {
		Q:(","_CVal_",")'[(","_ITEMAimDr_",") NMsg
		s hasFlag=$d(^CF.ANT("UsePurposeManage",0,"ItemLevel",inHosp,CLevel,ITEMAimDr,mArcim))
		i hasFlag>0 s upmid=$o(^CF.ANT("UsePurposeManage",0,"ItemLevel",inHosp,CLevel,ITEMAimDr,mArcim,upmid))
		i upmid'="" {
			s upmactive=$p(^CF.ANT("UsePurposeManage",upmid),"^",6)
			i upmactive=1 s upmtype=$p(^CF.ANT("UsePurposeManage",upmid),"^",5)
		}			
	} else {
		Q:(","_CVal_",")'[(","_OBJAimDr_",") NMsg
		s hasFlag=$d(^CF.ANT("UsePurposeManage",0,"OBJLevel",inHosp,CLevel,OBJAimDr,mArcim))
		i hasFlag>0 s upmid=$o(^CF.ANT("UsePurposeManage",0,"OBJLevel",inHosp,CLevel,OBJAimDr,mArcim,upmid))
		i upmid'="" {
			s upmactive=$p(^CF.ANT("UsePurposeManage",upmid),"^",6)
			i upmactive=1 s upmtype=$p(^CF.ANT("UsePurposeManage",upmid),"^",5)
		}		
	}
	b ;002
	//类型为不控制时，走正向和反向
	i COrder=1 {	//正向控制，不在里面不能开具
		Q:(upmid="")||(upmtype="F") FMsg
		Q:(upmtype="A") AMsg
		Q:(upmtype="N") NMsg
	} else {
		//反向控制，在里面的不能开具
		Q:(upmid="") NMsg
		Q:(upmtype="F")||(upmtype="N") FMsg
		Q:(upmtype="A") AMsg
	}
		
	
    q NMsg
}

/// CTOR: QP
/// DATE: 2019-08-16
/// DESC: 查询抗菌药物基础数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Config.UsePurposeManage","QryAllbasedata","OBJ","","",2)
Query QryAllbasedata(type As %String = "", parDr As %String = "", itemDr As %String = "", InHosp = "") As %Query(ROWSPEC = "id,code,desc")
{
}

ClassMethod QryAllbasedataExecute(ByRef qHandle As %Binary, type As %String = "", parDr As %String = "", itemDr As %String = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i InHosp="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s YF=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMYF",InHosp)
	s YFLEVEL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMYFLEVEL",InHosp)
	s YFVAL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMYFVAL",InHosp)
	i YFVAL'="" s YFVAL=","_YFVAL_","
	
	s ZL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMZL",InHosp)
	s ZLLEVEL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMZLLEVEL",InHosp)
	s ZLVAL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMZLVAL",InHosp)
	i ZLVAL'="" s ZLVAL=","_ZLVAL_","
	
	s pdcId=""
    f  s pdcId=$o(^DHCAntBasePurposeDataConfigD(pdcId)) q:pdcId=""  d
    .s tableType=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",1)
    .q:(tableType'=type)&&(tableType'="")	//过滤表类型
    .s tableName=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",2)	//表类型描述
    .s code=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",4) 	//代码
    .s desc=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",3)	//描述
    .s parCode=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",6)	//父级值
    .q:(parDr'="")&&(parCode'=parDr)
    .s active=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",5)	//是否激活
    .s aimItem=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",7)	//使用目的子类
    .Q:(itemDr'="")&&(aimItem'=itemDr) 
    .s specialFlag=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",8)	//特殊标志
    .s infectDepFlag=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",9)	//感染性疾病科标志
    .s isExit=$$IsExit()
    .q:isExit=1
    .d DHCAntOut2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

	
	Q
IsExit()
	s isExit=0
	i type="OBJ" {
		s filtCode=""
		i ZL'=0 s filtCode=",ZL,"
		i YF'=0 {
			i filtCode="" s filtCode=",YF,"	
			e  s filtCode=filtCode_"YF,"
		}
		i filtCode'[code s isExit=1
	}
	
	q isExit
	
DHCAntOut2
	set Data=$lb(pdcId,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QryAllbasedataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAllbasedataExecute ]
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

ClassMethod QryAllbasedataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAllbasedataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-08-16
/// DESC: 查询控制层级
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Config.UsePurposeManage","QryCLevel","YF")
Query QryCLevel(objCode As %String = "", InHosp = "") As %Query(ROWSPEC = "id,desc")
{
}

ClassMethod QryCLevelExecute(ByRef qHandle As %Binary, objCode As %String = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i InHosp="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s YF=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMYF",InHosp)
	s YFLEVEL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMYFLEVEL",InHosp)
	s YFVAL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMYFVAL",InHosp)
	
	s ZL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMZL",InHosp)
	s ZLLEVEL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMZLLEVEL",InHosp)
	s ZLVAL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMZLVAL",InHosp)
	i objCode="ZL" {
		s id=ZLLEVEL
		s desc=..GetLevelDesc(id)
		d DHCAntOut3
	}
	i objCode="YF" {
		s id=YFLEVEL
		s desc=..GetLevelDesc(id)
		d DHCAntOut3
	}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
DHCAntOut3
	set Data=$lb(id,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QryCLevelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCLevelExecute ]
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

ClassMethod QryCLevelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCLevelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-08-16
/// DESC: 查询控制项目
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Config.UsePurposeManage","QryCItem","ZL",2)
Query QryCItem(objCode As %String = "", InHosp = "") As %Query(ROWSPEC = "id,desc")
{
}

ClassMethod QryCItemExecute(ByRef qHandle As %Binary, objCode As %String = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i InHosp="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s YF=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMYF",InHosp)
	s YFLEVEL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMYFLEVEL",InHosp)
	s YFVAL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMYFVAL",InHosp)
	
	s ZL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMZL",InHosp)
	s ZLLEVEL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMZLLEVEL",InHosp)
	s ZLVAL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("UPMZLVAL",InHosp)
	s ^temp("QP")=objCode
	i objCode="ZL" {
		i ZLVAL'="" s Len=$l(ZLVAL,",")
		e  s Len=0
		f i=1:1:Len {
			s id=$p(ZLVAL,",",i)
			s text=$P(^DHCAntBasePurposeDataConfigD(id),"^",3)
			d DHCAntOut4
		}
	}
	i objCode="YF" {
		i YFVAL'="" s Len=$l(YFVAL,",")
		e  s Len=0
		f i=1:1:Len {
			s id=$p(YFVAL,",",i)
			s text=$P(^DHCAntBasePurposeDataConfigD(id),"^",3)
			d DHCAntOut4
		}
	}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
DHCAntOut4
	set Data=$lb(id,text)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QryCItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCItemExecute ]
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

ClassMethod QryCItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

}
