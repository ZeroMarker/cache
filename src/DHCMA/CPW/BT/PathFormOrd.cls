/// 名称: DHCMA.CPW.BT.PathFormOrd
/// 描述: 临床路径表单关联医嘱
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.BT.PathFormOrd Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.BT.PathFormItem [ Cardinality = parent, Inverse = ChildOrd ];

/// 医嘱类型（医嘱项、医嘱套、中药-协定方、中药-自定义方剂）
Property OrdTypeDr As DHCMA.Util.BT.Dictionary;

/// 医嘱项、医嘱套、中药-协定方、中药-自定义方剂 ID指针
Property OrdMastID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 通用名 指向PHC_Generic
Property OrdGeneID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 医嘱类型 指向OEC_Priority
Property OrdPriorityID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 数量
Property OrdQty As %Float;

/// 数量单位
Property OrdQtyUomID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 频次 指向PHCFreq
Property OrdFreqID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 疗程 指向PHCDuration
Property OrdDuratID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 用法 指向PHCInstruc
Property OrdInstrucID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 单次剂量
Property OrdDoseQty As %Float;

/// 单位 指向CTUOM
Property OrdUOMID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 医嘱备注
Property OrdNote As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检查部位
Property OrdChkPosID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 关联医嘱
Property OrdLnkOrdDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否首选项（默认选项）
Property OrdIsDefault As %Boolean;

/// 是否补液（主要针对氯化钠和葡萄糖，补液1、配液0）
/// 改为是否主要医嘱2019-01-09
Property OrdIsFluInfu As %Boolean;

/// 是否有效
Property OrdIsActive As %Boolean;

/// 处置日期
Property OrdActDate As %Date;

/// 处置时间
Property OrdActTime As %Time;

/// 处置人（指向DHCMA.CPW.EP.SSUser.OID）
Property OrdActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 关联医嘱OID（主要处理旧系统升级问题）
Property OrdOID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 排序码，Added by Wushuaijie 2020-01-17
Property SeqCode As %Integer [ InitialExpression = 999 ];

/// 组套方案 指向DHCMA.CPW.BT.PathOrdGroup
Property OrdGroupID As %String;

/// 长期医嘱用药天数
Property OrdUseDays As %Integer;

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.BT.PathFormOrd
/// Input：       aId : DHCMA.CPW.BT.PathFormOrd.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById("1||1")
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathFormOrd
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathFormOrd).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathFormOrd).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  更新实体对象
/// Table：       DHCMA.CPW.BT.PathFormOrd
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathFormOrd).Update("1||1||1^^10^13681||1^780^3^^5^63^2^1^19^^^^^^1^^^9!!1^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aUserID As %String = "") As %String
{
	New (aInputStr,aSeparete,aUserID,%session)
	Set return=0
	Quit:aInputStr="" return
	
	Set:(aUserID="")&&($d(%session)) aUserID=$g(%session.Data("DHCMA.USERID"))
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref		   = $p(aInputStr,aSeparete,1)
	Set ChildSub       = $p(aInputStr,aSeparete,2)
	Set OrdTypeDr      = $p(aInputStr,aSeparete,3)
	Set OrdMastID      = $p(aInputStr,aSeparete,4)
	Set OrdGeneID      = $p(aInputStr,aSeparete,5)
	Set OrdPriorityID  = $p(aInputStr,aSeparete,6)
	Set OrdQty         = $p(aInputStr,aSeparete,7)
	Set OrdFreqID      = $p(aInputStr,aSeparete,8)
	Set OrdDuratID     = $p(aInputStr,aSeparete,9)
	Set OrdInstrucID   = $p(aInputStr,aSeparete,10)
	Set OrdDoseQty     = $p(aInputStr,aSeparete,11)
	Set OrdUOMID       = $p(aInputStr,aSeparete,12)
	Set OrdNote        = $p(aInputStr,aSeparete,13)
	Set OrdChkPosID    = $p(aInputStr,aSeparete,14)
	Set OrdLnkOrdDr    = $p(aInputStr,aSeparete,15)
	Set OrdIsDefault   = +$p(aInputStr,aSeparete,16)
	Set OrdIsFluInfu   = +$p(aInputStr,aSeparete,17)
	Set OrdIsActive    = +$p(aInputStr,aSeparete,18)
	Set OrdActDate     = $p(aInputStr,aSeparete,19)
	Set OrdActTime     = $p(aInputStr,aSeparete,20)
	Set OrdActUserID   = $p(aInputStr,aSeparete,21)
	Set OrdOID         = $p(aInputStr,aSeparete,22)
	Set SeqCode		   = $p(aInputStr,aSeparete,23)
	Set OrdGroupID	   = $p(aInputStr,aSeparete,24)
	Set OrdUseDays 	   = $p(aInputStr,aSeparete,25)
	Set OrdQtyUomID    = $p(aInputStr,aSeparete,26)
	
	Set:OrdActDate'="" OrdActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(OrdActDate)
	Set:OrdActTime[":" OrdActTime = $zth(OrdActTime,1)
	Set:OrdActDate="" OrdActDate=+$h
	Set:OrdActTime="" OrdActTime=+$p($h,",",2)	
	
	Quit:(Parref="")||(OrdMastID="")||(OrdTypeDr="") -1
	Set objPathFormItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(Parref)
	Set objOrdType =##class(DHCMA.Util.BT.Dictionary).GetObjById(OrdTypeDr)
	Quit:('$Isobject(objPathFormItem))||('$Isobject(objOrdType)) -1
		
	If ChildSub="" {
		Set obj=##class(DHCMA.CPW.BT.PathFormOrd).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCMA.CPW.BT.PathFormOrd).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	If (obj.SeqCode="")||(obj.SeqCode=999) {
		Set curMaxSeqCode=..GetMaxSeqCode(Parref)
		Set SeqCode=+curMaxSeqCode+1
	}
		
	Set obj.Parref       = objPathFormItem  //对象
	Set obj.OrdTypeDr	 = objOrdType  
	Set obj.OrdMastID  	 = OrdMastID
	Set obj.OrdGeneID    = OrdGeneID
	Set obj.OrdPriorityID= OrdPriorityID
	Set obj.OrdQty       = OrdQty
	Set obj.OrdQtyUomID  = OrdQtyUomID
	Set obj.OrdFreqID    = OrdFreqID
	Set obj.OrdDuratID   = OrdDuratID	
	Set obj.OrdInstrucID = OrdInstrucID
	Set obj.OrdDoseQty   = OrdDoseQty
	Set obj.OrdUOMID     = OrdUOMID
	Set obj.OrdNote      = OrdNote
	Set obj.OrdChkPosID  = OrdChkPosID
	Set obj.OrdLnkOrdDr  = OrdLnkOrdDr
	Set obj.OrdIsDefault = OrdIsDefault
	Set obj.OrdIsFluInfu = OrdIsFluInfu
	Set obj.OrdIsActive  = OrdIsActive
	Set obj.OrdActDate   = OrdActDate
	Set obj.OrdActTime   = OrdActTime
	Set obj.OrdActUserID = OrdActUserID
	Set obj.OrdOID       = OrdOID
	Set obj.SeqCode		 = SeqCode
	Set obj.OrdGroupID	 = OrdGroupID
	Set obj.OrdUseDays   = OrdUseDays
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
		Set return = $p(return,"||",4)
	}
	Do obj.%Close()
	Do:+return>0 ##class(DHCMA.CPW.LOG.LogTable).UpdateActUser("DHCMA.CPW.BT.PathFormOrd",obj.%Id(),aUserID)
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  更新实体对象
/// Table：       DHCMA.CPW.BT.PathFormOrd
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathFormOrd).UpdateCVal(""1||1||1||1^1^^^9!!1"")
ClassMethod UpdateCVal(aInputStr As %String, aSeparete As %String = "^", aUserID As %String = "") As %String
{
	New (aInputStr,aSeparete,aUserID,%session)
	Set return=0
	Quit:aInputStr="" return
	
	Set:(aUserID="")&&($d(%session)) aUserID=$g(%session.Data("DHCMA.USERID"))
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID		   = $p(aInputStr,aSeparete,1)
	Set OrdIsDefault   = $p(aInputStr,aSeparete,2)
	Set OrdIsFluInfu   = $p(aInputStr,aSeparete,3)
	Set OrdIsActive    = $p(aInputStr,aSeparete,4)
	Set OrdActUserID   = $p(aInputStr,aSeparete,5)
	Set OrdActDate =""
	Set OrdActTime=""
	Set:OrdActDate="" OrdActDate=+$h
	Set:OrdActTime="" OrdActTime=+$p($h,",",2)	
	
	Quit:(ID="") -1	
	
	
	Set obj=##class(DHCMA.CPW.BT.PathFormOrd).%OpenId(ID)
	Quit:'$IsObject(obj) return
	Set:OrdIsDefault'="" obj.OrdIsDefault = +OrdIsDefault
	Set:OrdIsFluInfu'="" obj.OrdIsFluInfu = +OrdIsFluInfu
	Set:OrdIsActive'="" obj.OrdIsActive  = +OrdIsActive
	Set obj.OrdActDate   = OrdActDate
	Set obj.OrdActTime   = OrdActTime
	Set obj.OrdActUserID = OrdActUserID
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Do:+return>0 ##class(DHCMA.CPW.LOG.LogTable).UpdateActUser("DHCMA.CPW.BT.PathFormOrd",return,aUserID)
	Quit return
}

/// 获取当前项目下已关联医嘱的最大顺序号
/// w ##class(DHCMA.CPW.BT.PathFormOrd).GetMaxSeqCode("420||1||9")
ClassMethod GetMaxSeqCode(aPathFormEpItemDr As %String) As %String
{
	New (aPathFormEpItemDr)
	
	Set return=0
	Quit:aPathFormEpItemDr="" return
	
	Set iPathFormDr =$p(aPathFormEpItemDr,"||",1)
	Set iPathFormEpDr =$p(aPathFormEpItemDr,"||",2)
	Set iPathFormEpItemDr =$p(aPathFormEpItemDr,"||",3)
 	Set xChildID=""
 	
 	Set objItm = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aPathFormEpItemDr)
	Quit:'$IsObject(objItm) $$$OK
 	
	
 	For {
	 	Set xChildID = $o(^DHCMA.CPW.BT.PathFormD(iPathFormDr,"EP",iPathFormEpDr,"ITM",iPathFormEpItemDr,"ORD",xChildID))
	 	Quit:xChildID=""
	 	
		Set obj = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(aPathFormEpItemDr_"||"_xChildID)
		Continue:'$IsObject(obj)
		Set xID = obj.%Id()
		Set SeqCode = obj.SeqCode	
		
		Set:SeqCode>return return=SeqCode
 	}
 	
 	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  删除对象信息
/// Table：       DHCMA.CPW.BT.PathFormOrd
/// Input：       aId : DHCMA.CPW.BT.PathFormOrd.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathFormOrd).DeleteById("1||1")
ClassMethod DeleteById(aId As %String, aUserID As %String = "") As %String
{
	New (aId,aUserID,%session)
	
	Set:(aUserID="")&&($d(%session)) aUserID=$g(%session.Data("DHCMA.USERID"))
	Set sc = ##class(DHCMA.CPW.BT.PathFormOrd).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
		Do ##class(DHCMA.CPW.LOG.LogTable).UpdateActUser("DHCMA.CPW.BT.PathFormOrd",aId,aUserID)
	}
	Quit return
}

/// Creator：     WuShuaijie
/// CreatDate：   2020-01-17
/// Description:  更新排序码
/// Table：       DHCMA.CPW.BT.PathFormOrd
/// Input：       aInputStr: 1^17||1||7||3-2^17||1||7||5-3^17||1||7||6-
/// Return：      成功：返回更新条数，失败：返回0
/// w ##class(DHCMA.CPW.BT.PathFormOrd).UpdateSeqCode("1^17||1||7||3-2^17||1||7||5-3^17||1||7||6-")
ClassMethod UpdateSeqCode(aInputStr As %String, aUserID As %String = "") As %Numeric
{
	new (aInputStr,aUserID,%session)
	Set return = 0, subString = ""
	Quit:aInputStr="" return
	
	Set:(aUserID="")&&($d(%session)) aUserID=$g(%session.Data("DHCMA.USERID"))
	for i=1:1 {
		Set subString = $P(aInputStr, "-", i)
		Quit:subString=""
		
		Set seq = $P(subString, "^", 1)
		Set ID = $P(subString, "^", 2)
		Set objPathOrd = ##class(DHCMA.CPW.BT.PathFormOrd).%OpenId(ID)
		Continue:'$ISOBJECT(objPathOrd)
		
		Set objPathOrd.SeqCode = seq
		do objPathOrd.%Save()
		do objPathOrd.%Close()
		Do ##class(DHCMA.CPW.LOG.LogTable).UpdateActUser("DHCMA.CPW.BT.PathFormOrd",ID,aUserID)
		Set return = return + 1
	}
	
	Quit return
}

/// Creator：     WuShuaijie
/// CreatDate：   2020-01-19
/// Description:  第一次需要生成排序码时使用
/// Table：       DHCMA.CPW.BT.PathFormOrd
/// Input：       None
/// Return：      成功：返回更新条数，失败：返回""
/// w ##class(DHCMA.CPW.BT.PathFormOrd).GenerateSeqCode()
ClassMethod GenerateSeqCode() As %Numeric
{
	Set (formID, epID, itmID, ordID, return, seq) = ""
	for {
		Set formID = $O(^DHCMA.CPW.BT.PathFormD(formID))
		Quit:formID=""
		
		for {
			Set epID = $O(^DHCMA.CPW.BT.PathFormD(formID,"EP",epID))
			Quit:epID=""
			
			for {
				Set itmID = $O(^DHCMA.CPW.BT.PathFormD(formID,"EP",epID,"ITM",itmID))
				Quit:itmID=""
				
				Set seq = 1
				for {
					Set ordID = $O(^DHCMA.CPW.BT.PathFormD(formID,"EP",epID,"ITM",itmID,"ORD",ordID))
					Quit:ordID=""
					
					Set ID = formID_"||"_epID_"||"_itmID_"||"_ordID
					Set obj = ##class(DHCMA.CPW.BT.PathFormOrd).%OpenId(ID)
					Quit:'$ISOBJECT(obj)
					
					Set obj.SeqCode = seq
					do obj.%Save()
					do obj.%Close()
					Set seq = seq + 1
					Set return = return + 1
				}
			}
		}
	}
	return return
}

/// Creator：     yankai
/// CreatDate：   2021-01-07
/// Description:  更新医嘱分组
/// Table：       DHCMA.CPW.BT.PathFormOrd
/// Input：       aID:关联医嘱ID;aOrdGroupID:医嘱分组ID;isChecked:是否选中
/// Return：      成功：返回更新条数，失败：返回""
/// w ##class(DHCMA.CPW.BT.PathFormOrd).UpdateOrdGroup("17||1||7||3","3","0")
ClassMethod UpdateOrdGroup(aID As %String, aOrdGroupID As %String, isChecked As %String) As %String
{
	New (aID,aOrdGroupID,isChecked)
	Set return=""
	Quit:(aID="")||(aOrdGroupID="") return
	
	Set obj=##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(aID)
	Quit:'$IsObject(obj) return
	Set strOrdGroup=obj.OrdGroupID
	Set listOrdGroup=$lfs(strOrdGroup,",")
	If isChecked'=1{
		Set idx= $lf(listOrdGroup,aOrdGroupID)
		If (idx>0){
			Set $list(listOrdGroup,idx,idx)=""				//若存在则删除
		}
		Set obj.OrdGroupID=$lts(listOrdGroup,",") 
	}Else{
		If strOrdGroup=""{
			Set obj.OrdGroupID=aOrdGroupID	
		}Else{
			Set:$lf(listOrdGroup,aOrdGroupID)=0 obj.OrdGroupID=strOrdGroup_","_aOrdGroupID
		}
	}
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-07-13
/// Description:  使用触发器记录日志
Trigger LogTrigger [ Event = INSERT/UPDATE/DELETE, Foreach = row/object ]
{
	//get row id of inserted row
	New id,className,tableName,operType,OrdMastID,Date,Time,UserID
	
	Set id = {%%ID}
	Set className={%%CLASSNAMEQ}
	Set tableName={%%TABLENAME}
	Set operType={%%OPERATION}
	Set operType=$case(operType,"INSERT":"I","UPDATE":"U","DELETE":"D")
	Set Date=+$h
	Set Time=$p($h,",",2)
	Set UserID=""
	
	Set strUpdate="^"_className_"^"_tableName_"^"_operType_"^"_id_"^"_Date_"^"_Time_"^"_UserID
	Set LogID=##class(DHCMA.CPW.LOG.LogTable).Update(strUpdate,"^")
	
	If (+LogID>0)&&((operType="U")||(operType="D")) {		//增加不用记录
		If {OrdTypeDr*C}=1{			//关联分类
			Set oldVal={OrdTypeDr*O},newVal={OrdTypeDr*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdTypeDr",:oldVal,:newVal) )		
		}
		If {OrdMastID*C}=1{			//医嘱项ID
			Set oldVal={OrdMastID*O},newVal={OrdMastID*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdMastID",:oldVal,:newVal) )		
		}
		If {OrdPriorityID*C}=1{		//医嘱类型（优先级）
			Set oldVal={OrdPriorityID*O},newVal={OrdPriorityID*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdPriorityID",:oldVal,:newVal) )		
		}
		If {OrdQty*C}=1{			//数量
			Set oldVal={OrdQty*O},newVal={OrdQty*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdQty",:oldVal,:newVal) )		
		}
		If {OrdQtyUomID*C}=1{			//数量单位
			Set oldVal={OrdQtyUomID*O},newVal={OrdQtyUomID*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdQtyUomID",:oldVal,:newVal) )		
		}
		If {OrdFreqID*C}=1{				//频次
			Set oldVal={OrdFreqID*O},newVal={OrdFreqID*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdFreqID",:oldVal,:newVal) )		
		}
		If {OrdDuratID*C}=1{			//疗程
			Set oldVal={OrdDuratID*O},newVal={OrdDuratID*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdDuratID",:oldVal,:newVal) )		
		}
		If {OrdInstrucID*C}=1{			//用法
			Set oldVal={OrdInstrucID*O},newVal={OrdInstrucID*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdInstrucID",:oldVal,:newVal) )		
		}
		If {OrdDoseQty*C}=1{			//单次剂量
			Set oldVal={OrdDoseQty*O},newVal={OrdDoseQty*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdDoseQty",:oldVal,:newVal) )		
		}
		If {OrdUOMID*C}=1{				//剂量单位
			Set oldVal={OrdUOMID*O},newVal={OrdUOMID*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdUOMID",:oldVal,:newVal) )		
		}
		If {OrdNote*C}=1{				//医嘱备注
			Set oldVal={OrdNote*O},newVal={OrdNote*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdNote",:oldVal,:newVal) )		
		}
		If {OrdChkPosID*C}=1{			//检查部位
			Set oldVal={OrdChkPosID*O},newVal={OrdChkPosID*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdChkPosID",:oldVal,:newVal) )		
		}
		If {OrdLnkOrdDr*C}=1{			//关联序号
			Set oldVal={OrdLnkOrdDr*O},newVal={OrdLnkOrdDr*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdLnkOrdDr",:oldVal,:newVal) )		
		}
		If {OrdIsDefault*C}=1{			//是否首选项
			Set oldVal={OrdIsDefault*O},newVal={OrdIsDefault*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdIsDefault",:oldVal,:newVal) )		
		}
		If {OrdIsFluInfu*C}=1{			//是否主医嘱
			Set oldVal={OrdIsFluInfu*O},newVal={OrdIsFluInfu*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdIsFluInfu",:oldVal,:newVal) )		
		}
		If {OrdIsActive*C}=1{			//是否有效
			Set oldVal={OrdIsActive*O},newVal={OrdIsActive*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdIsActive",:oldVal,:newVal) )		
		}
		If {OrdOID*C}=1{				//关联医嘱OID
			Set oldVal={OrdOID*O},newVal={OrdOID*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdOID",:oldVal,:newVal) )		
		}
		If {SeqCode*C}=1{				//排序码
			Set oldVal={SeqCode*O},newVal={SeqCode*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"SeqCode",:oldVal,:newVal) )		
		}
		If {OrdGroupID*C}=1{			//组套方案
			Set oldVal={OrdGroupID*O},newVal={OrdGroupID*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdGroupID",:oldVal,:newVal) )		
		}
		If {OrdUseDays*C}=1{			//长期医嘱用药天数
			Set oldVal = {OrdUseDays*O},newVal ={OrdUseDays*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdUseDays",:oldVal,:newVal) )		
		}
	}
	
	Quit %ok
}

Storage Default
{
<Data name="PathFormOrdDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrdTypeDr</Value>
</Value>
<Value name="3">
<Value>OrdMastID</Value>
</Value>
<Value name="4">
<Value>OrdGeneID</Value>
</Value>
<Value name="5">
<Value>OrdPriorityID</Value>
</Value>
<Value name="6">
<Value>OrdQty</Value>
</Value>
<Value name="7">
<Value>OrdFreqID</Value>
</Value>
<Value name="8">
<Value>OrdDuratID</Value>
</Value>
<Value name="9">
<Value>OrdInstrucID</Value>
</Value>
<Value name="10">
<Value>OrdDoseQty</Value>
</Value>
<Value name="11">
<Value>OrdUOMID</Value>
</Value>
<Value name="12">
<Value>OrdNote</Value>
</Value>
<Value name="13">
<Value>OrdChkPosID</Value>
</Value>
<Value name="14">
<Value>OrdLnkOrdDr</Value>
</Value>
<Value name="15">
<Value>OrdIsDefault</Value>
</Value>
<Value name="16">
<Value>OrdIsFluInfu</Value>
</Value>
<Value name="17">
<Value>OrdIsActive</Value>
</Value>
<Value name="18">
<Value>OrdActDate</Value>
</Value>
<Value name="19">
<Value>OrdActTime</Value>
</Value>
<Value name="20">
<Value>OrdActUserID</Value>
</Value>
<Value name="21">
<Value>OrdOID</Value>
</Value>
<Value name="22">
<Value>SeqCode</Value>
</Value>
<Value name="23">
<Value>OrdGroupID</Value>
</Value>
<Value name="24">
<Value>OrdUseDays</Value>
</Value>
<Value name="25">
<Value>OrdQtyUomID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ORD")</DataLocation>
<DefaultData>PathFormOrdDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ORD")</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathFormI("ORD")</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathFormOrdS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
