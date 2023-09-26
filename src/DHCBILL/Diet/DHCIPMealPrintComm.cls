Class DHCBILL.Diet.DHCIPMealPrintComm Extends web.DHCOPPrintCommIF [ ClassType = "", ProcedureBlock ]
{

/// 报表1 按菜类型统计各病区数据
ClassMethod statByMealTypeWard(MealModality As %String, BookDate As %String, wardRowid As %String, job As %String, inputUpdateDate As %String, MealTypeDR As %String = "")
{
		k ^TMP("DHCIPMealPrintComm","statByMealTypeWard",job)
		k ^TMP("DHCIPMealPrintComm","statByMealTypeWardTitle",job)
		k ^TMP("DHCIPMealPrintComm","WardData",job)
		k ^TMP("DHCIPMealPrintComm","WardDataTitle",job)
		s BookDate=$zdh(BookDate,3)
		s MOrdRowID=0
		f  s MOrdRowID=$o(^DHCIPMEALORDER(0,"StartDate",BookDate,MOrdRowID)) q:MOrdRowID=""  d
	    .s ChildSub=0
	    .f  s ChildSub=$o(^DHCIPMEALORDER(0,"StartDate",BookDate,MOrdRowID,ChildSub)) q:ChildSub=""  d
	    ..s orderItemGlobalStr=^DHCIPMEALORDER(MOrdRowID,"I",ChildSub)
	    ..s admRowid=$p(^DHCIPMEALORDER(MOrdRowID),"^",1)
	    ..s dischgDate = $p(^PAADM(admRowid),"^",17)
		..s flag=0
		..s:dischgDate'="" flag=(BookDate>dischgDate)
		..q:flag  		; 小于当前时间且小于出院时间的帐单
	    ..s updateDate=$zd($p(orderItemGlobalStr,"^",12),3)
	    ..q:(inputUpdateDate'="")&&(inputUpdateDate'=updateDate)
   	    ..s BookWardID=$p(orderItemGlobalStr,"^",8)
   	    ..q:(+BookWardID=1329)!(+BookWardID=203) ;过滤测试病区
	    ..q:(wardRowid'="")&&(wardRowid'=BookWardID)
	    ..s MealItmRowID=$p(orderItemGlobalStr,"^",1)
	    ..;s MealItmDesc=$p(^DHCIPMEALITEM(MealItmRowID),"^",2) 
	    ..s BookMealTypeID=$p(orderItemGlobalStr,"^",21) ;医嘱中的餐类型
	    ..s BookMealModalityID=$p(orderItemGlobalStr,"^",22)
	    ..;s ItmMealModalityDesc=$p($g(^DHCIPMEALMODALITY(BookMealModalityID)),"^",2)
	    ..;s ItmMealTypeDesc=$p($g(^DHCIPMEALTYPE(BookMealTypeID)),"^",2) 
	    ..q:(MealModality'=BookMealModalityID)&&(MealModality'="")
	    ..q:((MealTypeDR'="")&&(MealTypeDR'=BookMealTypeID))
	    ..//s BookQty=$p(^DHCIPMEALORDER(MOrdRowID,"I",ChildSub),"^",5)
	    ..s BookQty=##class(DHCBILL.Diet.DHCIPMealFeeBill).GetOrdItemQty(MOrdRowID_"||"_ChildSub)  
		..s ^TMP("DHCIPMealPrintComm","statByMealTypeWard",job,BookDate,BookWardID,"M"_BookMealModalityID_"T"_BookMealTypeID_"I"_MealItmRowID)=+$g(^TMP("DHCIPMealPrintComm","statByMealTypeWard",job,BookDate,BookWardID,"M"_BookMealModalityID_"T"_BookMealTypeID_"I"_MealItmRowID))+BookQty
		..s ^TMP("DHCIPMealPrintComm","statByMealTypeWardTitle",job,BookDate,BookMealModalityID,BookMealTypeID,MealItmRowID)=+$g(^TMP("DHCIPMealPrintComm","statByMealTypeWardTitle",job,BookDate,BookMealModalityID,BookMealTypeID,MealItmRowID))+BookQty
		..s ^TMP("DHCIPMealPrintComm","WardData",job,BookDate,BookMealTypeID,MealItmRowID,BookWardID)=+$g(^TMP("DHCIPMealPrintComm","WardData",job,BookDate,BookMealTypeID,MealItmRowID,BookWardID))+BookQty
		..s ^TMP("DHCIPMealPrintComm","WardDataTitle",job,BookDate,BookWardID)=+$g(^TMP("DHCIPMealPrintComm","WardDataTitle",job,BookDate,BookWardID))+BookQty
		b ;222
		q
}

ClassMethod WirteGridByWard(inputDate As %String, inputWardRowid As %String, inputModRowid As %String, inputUpdateDate As %String, MealTypeDR As %String = "", ChkFlag As %String = "")
{
	if (ChkFlag="true"){
		d ..WirteGridByWardModGlobal(inputDate,inputWardRowid,inputModRowid,inputUpdateDate,MealTypeDR)
	}else{
		d ..WirteGridByWardModGlobal2(inputDate,inputWardRowid,inputModRowid,inputUpdateDate,MealTypeDR)	
	}
}

ClassMethod WirteGridByWardModGlobal(inputDate As %String, inputWardRowid As %String, inputModRowid As %String, inputUpdateDate As %String, MealTypeDR As %String = "")
{
	s job=$j
	d ..statByMealTypeWard(inputModRowid,inputDate,inputWardRowid,job,inputUpdateDate,MealTypeDR)
	//列名,	列串,		字段,		餐态,				餐形
	s cmStr="",fieldName="",modColumModleStr ="",typeColumModleStr="",totalStr=""
	s date=$zdh(inputDate,3)
    ;按菜谱顺序显示
    s index="" f  s index=$o(^DHCIPMEALMENU(0,"StartDateSort",date,"Index",index)) q:index=""  d
    .s menuDr="" f  s menuDr=$o(^DHCIPMEALMENU(0,"StartDateSort",date,"Index",index,menuDr)) q:menuDr=""  d
	..s subDr=$o(^DHCIPMEALMENU(0,"StartDateSort",date,"Index",index,menuDr,""))
    ..q:'$d(^DHCIPMEALMENU(menuDr,"M",subDr))
    ..s subStr=^DHCIPMEALMENU(menuDr,"M",subDr)
    ..s mealItmUseDate=$p(subStr,"^",8) ;菜使用日期
    ..q:(date'="")&&(mealItmUseDate'=date)   ;按菜使用日期过滤
    ..s mealItmDr=$p(subStr,"^",1)     ;菜指针
    ..s mealTypeDr=$p(subStr,"^",2)   ;菜类型
    ..s mealModDr=$p(subStr,"^",3)    ;菜形态
	..i +$g(^TMP("DHCIPMealPrintComm","statByMealTypeWardTitle",job,date,mealModDr,mealTypeDr,mealItmDr))>0 d
	...s modDesc=$p(^DHCIPMEALMODALITY(mealModDr),"^",2)  ;餐态
	...s TypeDesc=$p($g(^DHCIPMEALTYPE(mealTypeDr)),"^",2)  ;餐形
	...s MealItmDesc=$p(^DHCIPMEALITEM(mealItmDr),"^",2)
	...s colName="M"_mealModDr_"T"_mealTypeDr_"I"_mealItmDr
	...i fieldName="" s fieldName="{name:'colNameWard'},{name:'"_colName_"'}"
    ...e  s fieldName=fieldName_",{name:'"_colName_"'}"	   
    ...i cmStr="" s cmStr="new Ext.grid.RowNumberer(),{header:'病区',dataIndex:'colNameWard'},{"_"header:'"_MealItmDesc_"',dataIndex:"_"'"_colName_"'}"
    ...e  s cmStr=cmStr_",{header:'"_MealItmDesc_"',dataIndex:"_"'"_colName_"'}"
    ...i modColumModleStr="" s modColumModleStr="{"_"header:'"_modDesc_"',dataIndex:"_"'"_colName_"'}"
    ...e  s modColumModleStr=modColumModleStr_",{header:'"_modDesc_"',dataIndex:"_"'"_colName_"'}"
    ...i typeColumModleStr="" s typeColumModleStr="{"_"header:'"_TypeDesc_"',dataIndex:"_"'"_colName_"'}"
    ...e  s typeColumModleStr=typeColumModleStr_",{header:'"_TypeDesc_"',dataIndex:"_"'"_colName_"'}"
	...i totalStr="" s totalStr=colName_":"_^TMP("DHCIPMealPrintComm","statByMealTypeWardTitle",job,date,mealModDr,mealTypeDr,mealItmDr)
	...e  s totalStr=totalStr_","_colName_":"_^TMP("DHCIPMealPrintComm","statByMealTypeWardTitle",job,date,mealModDr,mealTypeDr,mealItmDr)
	w "{fieldsNames:["_fieldName_"],"
	w "columModle:["_cmStr_"],"
	w "modColumModle:["_modColumModleStr_"],"
	w "typeColumModle:["_typeColumModleStr_"],"
	
    w "data:["
	s totalCount=1
	s bookWardId=0 f  s bookWardId=$o(^TMP("DHCIPMealPrintComm","statByMealTypeWard",job,date,bookWardId)) q:bookWardId=""  d
	.q:(bookWardId'=inputWardRowid)&&(inputWardRowid'="")
	.s wardDesc=$p($p(^PAWARD(bookWardId),"^",2),"-",2)  ;病区
	.s lineStr="colNameWard:'"_wardDesc_"'"
	.s colName=""
	.f  s colName=$o(^TMP("DHCIPMealPrintComm","statByMealTypeWard",job,date,bookWardId,colName)) q:colName=""  d
  	..s lineStr=lineStr_","_colName_":'"_$g(^TMP("DHCIPMealPrintComm","statByMealTypeWard",job,date,bookWardId,colName))_"'"
	.i totalCount=1 w "{"_lineStr_"}"
	.e  w ",{"_lineStr_"}"
	.s totalCount=totalCount+1
	w ",{colNameWard:'合计',"_totalStr_"}"
	w "],totalCount:"_totalCount_"}"
	k ^TMP("DHCIPMealPrintComm","statByMealTypeWard",job)
	k ^TMP("DHCIPMealPrintComm","statByMealTypeWardTitle",job)
	k ^TMP("DHCIPMealPrintComm","WardData",job)
}

ClassMethod WirteGridByWardModGlobal2(inputDate As %String, inputWardRowid As %String, inputModRowid As %String, inputUpdateDate As %String, MealTypeDR As %String = "")
{
	;w ##class(DHCBILL.Diet.DHCIPMealPrintComm).WirteGridByWardModGlobal2("2012-03-10","","","","")
	s job=$j
	d ..statByMealTypeWard(inputModRowid,inputDate,inputWardRowid,job,inputUpdateDate,MealTypeDR)

	//列名,	列串,		字段,		餐态,				餐形
	s cmStr="",fieldName="",modColumModleStr ="",typeColumModleStr="",totalStr=""
	s date=$zdh(inputDate,3)
	s BWardDR=""
	f  s BWardDR=$o(^TMP("DHCIPMealPrintComm","WardDataTitle",job,date,BWardDR))  q:BWardDR=""  d
	.s BWardDesc=$p($p(^PAWARD(BWardDR),"^",2),"-",2) 	;病区
	.s colName=BWardDR
	.i fieldName="" s fieldName="{name:'colNameItm'},{name:'"_colName_"'}"
    .e  s fieldName=fieldName_",{name:'"_colName_"'}"	   
    .i cmStr="" s cmStr="new Ext.grid.RowNumberer(),{header:'菜名',dataIndex:'colNameItm'},{"_"header:'"_BWardDesc_"',dataIndex:"_"'"_colName_"'}"
    .e  s cmStr=cmStr_",{header:'"_BWardDesc_"',dataIndex:"_"'"_colName_"'}"
    .i totalStr="" s totalStr=colName_":"_^TMP("DHCIPMealPrintComm","WardDataTitle",job,date,BWardDR)
	.e  s totalStr=totalStr_","_colName_":"_^TMP("DHCIPMealPrintComm","WardDataTitle",job,date,BWardDR)
	i fieldName'="" d
	.s fieldName=fieldName_",{name:'ItmSum'}" 
	i cmStr'="" d
	.s cmStr=cmStr_",{header:'合计',dataIndex:'ItmSum'}"
	w "{fieldsNames:["_fieldName_"],"
	w "columModle:["_cmStr_"],"
	;
    w "data:["
	s totalCount=1
	s MealTypeDR=""
	f  s MealTypeDR=$o(^TMP("DHCIPMealPrintComm","WardData",job,date,MealTypeDR)) q:MealTypeDR=""  d
	.s Itm="" 
	.f  s Itm=$o(^TMP("DHCIPMealPrintComm","WardData",job,date,MealTypeDR,Itm)) q:Itm=""  d
	..;q:(bookWardId'=inputWardRowid)&&(inputWardRowid'="")
	..;b ;11
	..;s wardDesc=$p($p(^PAWARD(bookWardId),"^",2),"-",2)  ;病区
	..b ;11
	..s ItmCode=$p(^DHCIPMEALITEM(Itm),"^",1)
    ..s ItmDesc=$p(^DHCIPMEALITEM(Itm),"^",2)
	..s lineStr="colNameItm:'"_ItmDesc_"'"
	..s colName="",ItmCount=0
	..f  s colName=$o(^TMP("DHCIPMealPrintComm","WardData",job,date,MealTypeDR,Itm,colName)) q:colName=""  d
  	...s lineStr=lineStr_","_colName_":'"_$g(^TMP("DHCIPMealPrintComm","WardData",job,date,MealTypeDR,Itm,colName))_"'"
  	...s ItmCount=ItmCount+(+$g(^TMP("DHCIPMealPrintComm","WardData",job,date,MealTypeDR,Itm,colName)))
  	..s lineStr=lineStr_",ItmSum:'"_ItmCount_"'"
	..i totalCount=1 w "{"_lineStr_"}"
	..e  w ",{"_lineStr_"}"
	..s totalCount=totalCount+1
	;w ",{colNameItm:'合计',"_totalStr_"}"
	w "],totalCount:"_totalCount_"}"
	k ^TMP("DHCIPMealPrintComm","statByMealTypeWard",job)
	k ^TMP("DHCIPMealPrintComm","statByMealTypeWardTitle",job)
	k ^TMP("DHCIPMealPrintComm","WardData",job)
	k ^TMP("DHCIPMealPrintComm","WardDataTitle",job)
}

/// 按菜类型统计各病区明细数据
ClassMethod statDetailsByModWard(MealModality As %String, BookDate As %String, wardRowid As %String, job As %String, inputUpdateDate As %String)
{
		k ^TMP("DHCIPMealPrintComm","statDetailsByModWard",job)
		k ^TMP("DHCIPMealPrintComm","statDetailsByModWardTitle",job)
		s BookDate=$zdh(BookDate,3)
		s MOrdRowID=0
		f  s MOrdRowID=$o(^DHCIPMEALORDER(0,"StartDate",BookDate,MOrdRowID)) q:MOrdRowID=""  d
	    .s ChildSub=0
	    .f  s ChildSub=$o(^DHCIPMEALORDER(0,"StartDate",BookDate,MOrdRowID,ChildSub)) q:ChildSub=""  d
	    ..s orderItemGlobalStr=^DHCIPMEALORDER(MOrdRowID,"I",ChildSub)
	    ..s admRowid=$p(^DHCIPMEALORDER(MOrdRowID),"^",1)
	    ..s dischgDate = $p(^PAADM(admRowid),"^",17)
		..s flag=0
		..s:dischgDate'="" flag=(BookDate>dischgDate)
		..q:flag  		; 小于当前时间且小于出院时间的帐单
	    ..s updateDate=$zd($p(orderItemGlobalStr,"^",12),3)
	    ..q:(inputUpdateDate'="")&&(inputUpdateDate'=updateDate)
   	    ..s BookWardID=$p(orderItemGlobalStr,"^",8)
	    ..q:(wardRowid'="")&&(wardRowid'=BookWardID)
	    ..s MealItmRowID=$p(orderItemGlobalStr,"^",1)
	    ..;s MealItmDesc=$p(^DHCIPMEALITEM(MealItmRowID),"^",2) 
	    ..s BookMealTypeID=$p(orderItemGlobalStr,"^",21) ;医嘱中的餐类型
	    ..s BookMealModalityID=$p(orderItemGlobalStr,"^",22)
	    ..;s ItmMealModalityDesc=$p($g(^DHCIPMEALMODALITY(BookMealModalityID)),"^",2)
	    ..;s ItmMealTypeDesc=$p($g(^DHCIPMEALTYPE(BookMealTypeID)),"^",2) 
	    ..q:(MealModality'=BookMealModalityID)&&(MealModality'="")
	    ..//s BookQty=$p(^DHCIPMEALORDER(MOrdRowID,"I",ChildSub),"^",5)
	    ..s BookQty=##class(DHCBILL.Diet.DHCIPMealFeeBill).GetOrdItemQty(MOrdRowID_"||"_ChildSub)  
		..s ^TMP("DHCIPMealPrintComm","statDetailsByModWard",job,BookDate,BookWardID,admRowid,"M"_BookMealModalityID_"T"_BookMealTypeID_"I"_MealItmRowID)=+$g(^TMP("DHCIPMealPrintComm","statDetailsByModWard",job,BookDate,BookWardID,admRowid,"M"_BookMealModalityID_"T"_BookMealTypeID_"I"_MealItmRowID))+BookQty
		..s ^TMP("DHCIPMealPrintComm","statDetailsByModWardTitle",job,BookDate,BookMealModalityID,BookMealTypeID,MealItmRowID)=$g(^TMP("DHCIPMealPrintComm","statDetailsByModWardTitle",job,BookDate,BookMealModalityID,BookMealTypeID,MealItmRowID))+BookQty
		q
}

ClassMethod WirteWardDetailByWardModGlobal(inputDate As %String, inputWardRowid As %String, inputModRowid As %String, inputUpdateDate As %String)
{
	s job=$j
	d ..statDetailsByModWard(inputModRowid,inputDate,inputWardRowid,job,inputUpdateDate)
	//列名,	列串,		字段,		餐态,				餐形
	s cmStr="",fieldName="",modColumModleStr ="",typeColumModleStr="",totalStr=""
	s date=$zdh(inputDate,3)
	s index="" f  s index=$o(^DHCIPMEALMENU(0,"StartDateSort",date,"Index",index)) q:index=""  d
    .s menuDr="" f  s menuDr=$o(^DHCIPMEALMENU(0,"StartDateSort",date,"Index",index,menuDr)) q:menuDr=""  d
	..s subDr=$o(^DHCIPMEALMENU(0,"StartDateSort",date,"Index",index,menuDr,""))
    ..q:'$d(^DHCIPMEALMENU(menuDr,"M",subDr))
    ..s subStr=^DHCIPMEALMENU(menuDr,"M",subDr)
    ..s mealItmUseDate=$p(subStr,"^",8) ;菜使用日期
    ..q:(date'="")&&(mealItmUseDate'=date)   ;按菜使用日期过滤
    ..s mealItmDr=$p(subStr,"^",1)     ;菜指针
    ..s mealTypeDr=$p(subStr,"^",2)   ;菜类型
    ..s mealModDr=$p(subStr,"^",3)    ;菜形态
	..i +$g(^TMP("DHCIPMealPrintComm","statDetailsByModWardTitle",job,date,mealModDr,mealTypeDr,mealItmDr))>0 d
	...s modDesc=$p(^DHCIPMEALMODALITY(mealModDr),"^",2)  ;餐态
	...s TypeDesc=$p($g(^DHCIPMEALTYPE(mealTypeDr)),"^",2)  ;餐形
	...s MealItmDesc=$p(^DHCIPMEALITEM(mealItmDr),"^",2)
	...s colName="M"_mealModDr_"T"_mealTypeDr_"I"_mealItmDr
	...i fieldName="" s fieldName="{name:'colNameWard'},{name:'colNameAdm'},{name:'"_colName_"'}"
    ...e  s fieldName=fieldName_",{name:'"_colName_"'}"	   
    ...i cmStr="" s cmStr="new Ext.grid.RowNumberer(),new Ext.grid.CheckboxSelectionModel(),{header:'病区',dataIndex:'colNameWard'},{header:'病人姓名',dataIndex:'colNameAdm'},{"_"header:'"_MealItmDesc_"',dataIndex:"_"'"_colName_"'}"
    ...e  s cmStr=cmStr_",{header:'"_MealItmDesc_"',dataIndex:"_"'"_colName_"'}"
    ...i modColumModleStr="" s modColumModleStr="{"_"header:'"_modDesc_"',dataIndex:"_"'"_colName_"'}"
    ...e  s modColumModleStr=modColumModleStr_",{header:'"_modDesc_"',dataIndex:"_"'"_colName_"'}"
    ...i typeColumModleStr="" s typeColumModleStr="{"_"header:'"_TypeDesc_"',dataIndex:"_"'"_colName_"'}"
    ...e  s typeColumModleStr=typeColumModleStr_",{header:'"_TypeDesc_"',dataIndex:"_"'"_colName_"'}"
	...i totalStr="" s totalStr=colName_":"_^TMP("DHCIPMealPrintComm","statDetailsByModWardTitle",job,date,mealModDr,mealTypeDr,mealItmDr)
	...e  s totalStr=totalStr_","_colName_":"_^TMP("DHCIPMealPrintComm","statDetailsByModWardTitle",job,date,mealModDr,mealTypeDr,mealItmDr)
	w "{fieldsNames:["_fieldName_"],"
	w "columModle:["_cmStr_"],"
	w "modColumModle:["_modColumModleStr_"],"
	w "typeColumModle:["_typeColumModleStr_"],"
	
    w "data:["
	s totalCount=1
	s bookWardId=0 f  s bookWardId=$o(^TMP("DHCIPMealPrintComm","statDetailsByModWard",job,date,bookWardId)) q:bookWardId=""  d
	.q:(bookWardId'=inputWardRowid)&&(inputWardRowid'="")
	.s wardDesc=$p($p(^PAWARD(bookWardId),"^",2),"-",2)  ;病区
	.s admRowid=0 f  s admRowid=$o(^TMP("DHCIPMealPrintComm","statDetailsByModWard",job,date,bookWardId,admRowid)) q:admRowid=""  d
	..s PapmiRowID=$p(^PAADM(admRowid),"^",1)
    ..s patName=$p(^PAPER(PapmiRowID,"ALL"),"^",1)
	..s lineStr="colNameWard:'"_wardDesc_"',colNameAdm:'"_patName_"'"
	..s colName="" 
	..f  s colName=$o(^TMP("DHCIPMealPrintComm","statDetailsByModWard",job,date,bookWardId,admRowid,colName)) q:colName=""  d
  	...s lineStr=lineStr_","_colName_":'"_$g(^TMP("DHCIPMealPrintComm","statDetailsByModWard",job,date,bookWardId,admRowid,colName))_"'"
	..i totalCount=1 w "{"_lineStr_"}"
	..e  w ",{"_lineStr_"}"
	..s totalCount=totalCount+1
	w ",{colNameAdm:'合计',"_totalStr_"}"
	w "],totalCount:"_totalCount_"}"
	k ^TMP("DHCIPMealPrintComm","statDetailsByModWard",job)
	k ^TMP("DHCIPMealPrintComm","statDetailsByModWardTitle",job)
}

/// 没有调用
ClassMethod WirteGridJsonItemByWardMod(date As %String, wardRowid As %String, modRowid As %String)
{
	s job=$j
	d ..statByMealTypeWard(modRowid,date,wardRowid,job)
	s ItmMealModalityDescString=""
	s ItmMealItemRowidString=""
	s ItmMealItemDescString=""
	s date=$zdh(date,3)
	s i=1  //列名
	s cmStr="["  ;列头
    s fieldName="[" ;字段
    s modColumModleStr ="[" //形态字段
	s ItmMealModalityID=0
	f  s ItmMealModalityID=$o(^DHCIPMEALMENU(0,"DetailStartDateMDR",date,ItmMealModalityID)) q:ItmMealModalityID=""  d
	.s lineRowidStr=""
	.q:(modRowid'="")&&(modRowid'=ItmMealModalityID)
	.s ItmMealModalityDesc=$p($g(^DHCIPMEALMODALITY(ItmMealModalityID)),"^",2)
	.s menuRowid=0
	.f  s menuRowid=$o(^DHCIPMEALMENU(0,"DetailStartDateMDR",date,ItmMealModalityID,menuRowid)) q:menuRowid=""  d
	..s menuDetailRowid=0  
	..f  s menuDetailRowid=$o(^DHCIPMEALMENU(0,"DetailStartDateMDR",date,ItmMealModalityID,menuRowid,menuDetailRowid)) q:menuDetailRowid=""  d
	...s ItmMealID=$p(^DHCIPMEALMENU(menuRowid,"M",menuDetailRowid),"^",1)
	...s mealItemName =$p(^DHCIPMEALITEM(ItmMealID),"^",2) 
	...i ItmMealModalityDescString="" s ItmMealModalityDescString=ItmMealModalityDesc
	...e  s ItmMealModalityDescString=ItmMealModalityDescString_"^"_ItmMealModalityDesc
	
	...i ItmMealItemRowidString="" s ItmMealItemRowidString=ItmMealID
	...e  s ItmMealItemRowidString=ItmMealItemRowidString_"^"_ItmMealID
	
	...i ItmMealItemDescString="" s ItmMealItemDescString=mealItemName
	...e  d
	....i ("^"_ItmMealItemDescString_"^")'["^"_mealItemName_"^" d
	.....s ItmMealItemDescString=ItmMealItemDescString_"^"_mealItemName
	
	...s colName="colName"_i
	...s i=i+1
    ...i fieldName="[" s fieldName=fieldName_"{name:'colNameWard'},{name:'"_colName_"'}"
    ...e  s fieldName=fieldName_",{name:'"_colName_"'}"	      
    
    ...i cmStr="[" s cmStr=cmStr_"new Ext.grid.RowNumberer(),{header:'病区',dataIndex:'colNameWard'},{"_"header:'"_mealItemName_"',dataIndex:"_"'"_colName_"'}"
    ...e  s cmStr=cmStr_",{header:'"_mealItemName_"',dataIndex:"_"'"_colName_"'}"      
   	
   	...i modColumModleStr="[" s modColumModleStr=modColumModleStr_"new Ext.grid.RowNumberer(),{header:'病区',dataIndex:'colNameWard'},{"_"header:'"_ItmMealModalityDesc_"',dataIndex:"_"'"_colName_"'}"
    ...e  s modColumModleStr=modColumModleStr_",{header:'"_ItmMealModalityDesc_"',dataIndex:"_"'"_colName_"'}"
    
   	s fieldName="fieldsNames:"_fieldName_"]"
  	s columModle="columModle:"_cmStr_"]"
  	s modColumModle="modColumModle:"_modColumModleStr_"]"
  	w "{"_fieldName_","_columModle_","_modColumModle_",data:["
  	s totalCount=0
  	s len= $l(ItmMealItemRowidString,"^")
  	s wardRowid=0 
  	f  s wardRowid=$o(^TMP("DHCIPMealPrintComm",job,date,wardRowid)) q:wardRowid=""  d
  	.s lineStr=""
  	.s wardDesc=$p($p(^PAWARD(wardRowid),"^",2),"-",2) 
  	.f j=1:1:len d
  	..s mealItemRowid=$p(ItmMealItemRowidString,"^",j)
  	..s modDesc=$p(ItmMealModalityDescString,"^",j)
  	..i lineStr="" s lineStr="colName"_j_":'"_$g(^TMP("DHCIPMealPrintComm",job,date,wardRowid,modDesc,mealItemRowid))_"'"
  	..e  s lineStr=lineStr_",colName"_j_":'"_$g(^TMP("DHCIPMealPrintComm",job,date,wardRowid,modDesc,mealItemRowid))_"'"
  	.i totalCount=0 w "{colNameWard:'"_wardDesc_"',"_lineStr_"}"
  	.e  w ",{colNameWard:'"_wardDesc_"',"_lineStr_"}"
  	.s totalCount=totalCount+1
  	w "],totalCount:"_totalCount_"}"
  	//k ^TMP("DHCIPMealPrintComm",job)
  	q
}

ClassMethod FindFeeDetailByDateAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFeeDetailByDateAdmExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator :wanghc
/// CreateDate:2010-12-12
/// Function  :某病人的膳食明细
/// Table     :dhc_ipmealorder,dhc_ipmealorderitem,dhc_ipmealBillDetail
/// Input     :开始日期到结束日期 ,adm ,papMedicare
/// OutPut    :用餐时间，菜名，份数...
/// d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealPrintComm","FindFeeDetailByDateAdm","2010-12-10","2010-12-12",46)
ClassMethod FindFeeDetailByDateAdmExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, admRowid As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s ^TMP("wanghc","FindFeeDetailByDateAdmExecute")=startDate_","_endDate_","_admRowid
    k ^TMP("DHCIPMealPrintComm","FindMenuItmByDate",$j)
    i admRowid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s:startDate="" startDate=$zd(+$h,3)
    s:endDate="" endDate=$zd(+$h,3)
	s stDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	s totalQty=0,totalPrice=0,totalAmount=0
	s MenuDateStr="日期",ItmMealType="餐形",ItmMealModality="餐态" ,ItmDesc="描述",Qty="数量",ItmPrice="价格",ItmAmount="金额",updateUserCode="定餐员"
	d OutputRow1
    S MealOrdRowID =$o(^DHCIPMEALORDER(0,"Adm",admRowid,""))
    f MenuDate=stDate:1:endDate d
	.s ItmChildSub=0 f  s ItmChildSub=$o(^DHCIPMEALORDER(0,"StartDate",MenuDate,MealOrdRowID,ItmChildSub)) q:ItmChildSub=""  d
	..s mealOrdItemRowid=MealOrdRowID_"||"_ItmChildSub
	..s tmpOrdItemStr=^DHCIPMEALORDER(MealOrdRowID,"I",ItmChildSub) 
	..s BillFlag=$p(tmpOrdItemStr,"^",17)
	..q:BillFlag'="B" ;已经记帐的医嘱才输出
	..s ordItemItmMealTypeDR=$p(tmpOrdItemStr,"^",21) ;医嘱中的餐类型
	..s ordItemItmMealModalityDR=$p(tmpOrdItemStr,"^",22) ;医嘱中的餐态
    ..s billDetailRowid=$p(tmpOrdItemStr,"^",6)
    ..S billDetailSubRowid=$P(billDetailRowid,"||",2)
    ..s Qty=##class(DHCBILL.Diet.DHCIPMealFeeBill).GetOrdItemQty(MealOrdRowID_"||"_ItmChildSub)  //拿帐单中的数量
    ..q:Qty=0
    ..s ItmPrice=$p(^DHCIPMEALBILL(+billDetailRowid,"D",billDetailSubRowid),"^",2)
    ..;s patWardRowid=$p(^DHCIPMEALBILL(+billDetailRowid,"D",billDetailSubRowid),"^",6)
    ..;s patWard=$p($p(^PAWARD(patWardRowid),"^",2),"-",2)
    ..;s Qty=+$p(tmpOrdItemStr,"^",5)
    ..s MealItemRowID=$p(tmpOrdItemStr,"^",1) ;菜String
    ..s tmpMealItemStr=^DHCIPMEALITEM(MealItemRowID) 
    ..s ItmCode=$p(tmpMealItemStr,"^",1)
    ..s ItmDesc=$p(tmpMealItemStr,"^",2)
    ..s ItmMealType=$p($g(^DHCIPMEALTYPE(ordItemItmMealTypeDR)),"^",2)
    ..s ItmMealModality=$p($g(^DHCIPMEALMODALITY(ordItemItmMealModalityDR)),"^",2)
    ..s ItmUomID=$p(tmpMealItemStr,"^",5)
    ..i ItmUomID'="" s ItmUom=$p($g(^DHCIPMEALUOM(ItmUomID)),"^",2)
    ..s ItmRemark=$p(^DHCIPMEALITEM(MealItemRowID),"^",12)
	..S ItmAmount=ItmPrice*Qty
	..s totalQty=totalQty+Qty
	..s totalPrice=totalPrice+ItmPrice
	..s totalAmount=totalAmount+ItmAmount
	..s updateUserDr=$p(tmpOrdItemStr,"^",14)
	..s updateUserCode=$P(^SSU("SSUSR",updateUserDr),"^",1)
	..s MenuDateStr=$zd(MenuDate,3)
	..d OutputRow1
	s MenuDateStr="合计",ItmMealType="",ItmMealModality="",ItmDesc="",Qty=totalQty,ItmPrice=totalPrice,ItmAmount=totalAmount,updateUserCode=""
	d OutputRow1
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK   
OutputRow1
	//bookDate:%String:用餐日期,mealType:%String:餐类形,mealMod:%String:餐态,mealName:%String:餐名,mealNum:%String:数量,mealPrice:%String:单价,mealTotalAmount:%String:金额,userCode:%String:订餐员
	set Data=$lb(MenuDateStr,ItmMealType,ItmMealModality,ItmDesc,Qty,ItmPrice,ItmAmount,updateUserCode)
 	//s ^TMP("DHCIPMealPrintComm","FindFeeDetailByDateAdm",$j,ind)=MenuDateStr_"^"_ItmMealType_"^"_ItmMealModality_"^"_ItmDesc_"^"_Qty_"^"_ItmPrice_"^"_ItmAmount_"^"_updateUserCode
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindFeeDetailByDateAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFeeDetailByDateAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindFeeDetailByDateAdm(startDate As %String, endDate As %String, admRowid As %String, papMedicare As %String) As %Query(ROWSPEC = "bookDate:%String:用餐日期,mealType:%String:餐类形,mealMod:%String:餐态,mealName:%String:餐名,mealNum:%String:数量,mealPrice:%String:单价,mealTotalAmount:%String:金额,userCode:%String:订餐员")
{
}

ClassMethod FindOrdDetailByWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrdDetailByWardExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator :wanghc
/// CreateDate:2010-12-12
/// Function  :某病人的膳食医嘱
/// Table     :dhc_ipmealorder,dhc_ipmealorderitem,dhc_ipmealBillDetail
/// Input     :开始日期到结束日期 ,adm ,papMedicare
/// OutPut    :用餐时间，菜名，份数...
/// d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealPrintComm","FindOrdDetailByWard","","2010-12-13","") --42
ClassMethod FindOrdDetailByWardExecute(ByRef qHandle As %Binary, wardRowid As %String, date As %String, itemCat As %String, arcItmMastRowid As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s ^TMP("DHCIPMealPrintComm","FindOrdDetailByWard")=wardRowid_","_date_","_itemCat_","_arcItmMastRowid
    i date=""  Set qHandle=$lb(0,repid,0)  Quit $$$OK 
    s wardDesc="病区",admRoomDesc="床号",patName="患者姓名",mealOrderDesc="膳食医嘱",remark="备注"
	d OutputRow1
	s (wardDesc,admRoomDesc,patName,mealOrderDesc,remark)=""
	s:+wardRowid'=0 wardDesc=$p($p(^PAWARD(wardRowid),"^",2),"-",2)
	s date=$zdh(date,3) 
	//1是核实的医嘱
	s oeOrdRowid=0 f  s oeOrdRowid=$o(^OEORDi(0,"StDtStat",date,1,oeOrdRowid)) q:oeOrdRowid=""  d
	.s admRowid=$p(^OEORD(oeOrdRowid),"^",1)
	.s admWardDr=$p(^PAADM(admRowid),"^",70)
	.q:(wardRowid'="")&&(wardRowid'=admWardDr)
	.s:admWardDr'="" wardDesc=$p($p(^PAWARD(admWardDr),"^",2),"-",2)
	.s admRoomDr=$p(^PAADM(admRowid),"^",69)
	.s:admRoomDr'="" admRoomDesc=$p(^PAROOM(admRoomDr),"^",2)
	.s PapmiID=$p(^PAADM(admRowid),"^",1)
	.s:$d(^PAPER(PapmiID,"ALL")) patName=$p(^PAPER(PapmiID,"ALL"),"^",1)   
	.s oeOrdItemRowid=0 f  s oeOrdItemRowid=$o(^OEORDi(0,"StDtStat",date,1,oeOrdRowid,oeOrdItemRowid)) q:oeOrdItemRowid=""  d
    ..s arcItmMastDr=$p(^OEORD(oeOrdRowid,"I",oeOrdItemRowid,1),"^",2)
    ..q:(arcItmMastRowid'="")&&(arcItmMastDr'=arcItmMastRowid)
	..s arcItemSubRowid=$p(arcItmMastDr,"||",2)
	..s arcItemCatRowid =$p(^ARCIM(+arcItmMastDr,arcItemSubRowid,1),"^",10)
	..;ARC_ItemCat=147 为饮食
	..q:(arcItemCatRowid'=147)&&(arcItemCatRowid'=200)
	..q:(arcItemCatRowid'=itemCat)&&(itemCat'="")
	..s remark=""
	..s i=0 f  s i=$o(^OEORD(oeOrdRowid,"I",oeOrdItemRowid,"DEP",i)) q:i=""  d  
	...s remark=remark_" "_^OEORD(oeOrdRowid,"I",oeOrdItemRowid,"DEP",i)
	..s mealOrderDesc=$p(^ARCIM(+arcItmMastDr,arcItemSubRowid,1),"^",2)
 	..d OutputRow1
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK   
OutputRow1
	set Data=$lb(wardDesc,admRoomDesc,patName,mealOrderDesc,remark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOrdDetailByWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrdDetailByWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindOrdDetailByWard(wardRowid As %String, date As %String, itemCat As %String, arcItmMastRowid As %String) As %Query(ROWSPEC = "ward:%String:病区,bed:%String:床号,patName:%String:患者姓名,mealOrdDesc:%String:膳食医嘱,remark:%String:备注")
{
}

ClassMethod FindStrikeByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStrikeByDateExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator :wanghc
/// CreateDate:2010-12-12
/// Function  :红冲明细
/// Table     :dhc_ipmealorder,dhc_ipmealorderitem,dhc_ipmealBillDetail
/// Input     :开始日期到结束日期 ,收费员rowid,adm
/// OutPut    :
/// d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealPrintComm","FindStrikeByDate", "2010-12-18","2010-12-18","","") --42
ClassMethod FindStrikeByDateExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, userRowid As %String, admRowid As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s ^TMP("DHCIPMealPrintComm","FindStrikeByDate")=stDate_","_endDate_","_userRowid_","_admRowid
    i stDate=""  Set qHandle=$lb(0,repid,0)  Quit $$$OK 
    s wardDesc="病区",patName="病人姓名",strikeDate="退菜时间",strikeTime="",mealName="菜名",bookDate="发菜时间",mealTypeDesc="餐型",mealModDesc="餐态"
    s qty="退菜数量",price="单价",amount="金额",userName="收费员"
	d OutputRow1
	s (patName,strikeDate,mealName,mealTypeDesc,mealModDesc,qty,price,amount,userName,totalAmount,totalQty)=""
	
	s stDate=$zdh(stDate,3) 
	s endDate=$zdh(endDate,3)
	f date=stDate:1:endDate d
	.s billRowid=0 
	.f  s billRowid = $o(^DHCIPMEALBILL(0,"BillDate",date,billRowid)) q:billRowid=""  d
	..s billSubRowid=0
	..s admDr=$p(^DHCIPMEALBILL(billRowid),"^",1)
	..q:(admRowid'="")&&(admRowid'=admDr)
	..s papmiID=$p(^PAADM(admDr),"^",1)
	..s patName=$p(^PAPER(papmiID,"ALL"),"^",1)   ;姓名
	..s wardDesc=""
	..s admWardDr=$p(^PAADM(admDr),"^",70)
	..s:+admWardDr'=0 wardDesc=$p($p(^PAWARD(admWardDr),"^",2),"-",2) 
	..f  s billSubRowid= $o(^DHCIPMEALBILL(0,"BillDate",date,billRowid,billSubRowid)) q:billSubRowid=""  d
 	...s tmpGlobalStr=^DHCIPMEALBILL(billRowid,"D",billSubRowid)
 	...s oldQty=$p(tmpGlobalStr,"^",3),newQty=0
 	...q:oldQty>=0
 	...s price=$p(tmpGlobalStr,"^",2)
 	...s oldOrdItemRowid=$p(tmpGlobalStr,"^",1)   //I-->B----停的
 	...s oldOrdItemSubRowid=$p(oldOrdItemRowid,"||",2)
 	...s oldOrdItemStr=^DHCIPMEALORDER(+oldOrdItemRowid,"I",oldOrdItemSubRowid)
 	...s mealRowid=$p(oldOrdItemStr,"^",1)
 	...s mealName=$p(^DHCIPMEALITEM(mealRowid),"^",2)
 	...s mealTypeDR=$p(oldOrdItemStr,"^",21) ;医嘱中的餐类型
    ...s mealTypeDesc=$p(^DHCIPMEALTYPE(mealTypeDR),"^",2)
    ...s mealModalityDR=$p(oldOrdItemStr,"^",22) ;医嘱中的餐态
 	...s mealModDesc=$p($g(^DHCIPMEALMODALITY(mealModalityDR)),"^",2)
 	...s bookDate=$zd($p(oldOrdItemStr,"^",2),3) ;订餐时间
 	...s oldOrdUpdateDate=$p(oldOrdItemStr,"^",12)
 	...s oldOrdUpdateTime=$p(oldOrdItemStr,"^",13)
 	...s strikeDate=$zd(oldOrdUpdateDate,3)   //走医嘱时间
	...s strikeTime=$zt(oldOrdUpdateTime,1)
	...s userDr=$p(oldOrdItemStr,"^",14)
	...q:(userRowid'=userDr)&&(userRowid'="")
	...s userName=$p(^SSU("SSUSR",userDr),"^",1)
	...s newOrdItemRowid=$o(^DHCIPMEALORDER(0,"InitDr",oldOrdItemRowid,0))  
 	...;
 	...i +newOrdItemRowid=0 d
 	....s qty=oldQty   //全退
 	...e  d
 	....s newOrdItemSubRowid=$o(^DHCIPMEALORDER(0,"InitDr",oldOrdItemRowid,newOrdItemRowid,0))
 	....s newOMIRowid=newOrdItemRowid_"||"_newOrdItemSubRowid
 	....s newBillItemRowid=$o(^DHCIPMEALBILL(0,"MO",newOMIRowid,0))
 	....s newBillItemSubRowid=$o(^DHCIPMEALBILL(0,"MO",newOMIRowid,newBillItemRowid,0))
 	....s newMBIRowid=newBillItemRowid_"||"_newBillItemSubRowid
 	....s newQty=$p(^DHCIPMEALBILL(newBillItemRowid,"D",newBillItemSubRowid),"^",3)
 	....s qty=oldQty+$g(newQty)
	...s amount=qty*price
	...s totalQty=qty+totalQty
	...s totalAmount=totalAmount+amount
 	...d OutputRow1
 	s wardDesc="合计" 
 	s (patName,strikeDate,strikeTime,mealName,bookDate,mealTypeDesc,mealModDesc,price,userName)=""
 	s qty=totalQty
 	s amount=totalAmount
 	d OutputRow1
 	Set qHandle=$lb(0,repid,0)
    Quit $$$OK   
OutputRow1
	set Data=$lb(wardDesc,patName,strikeDate_" "_strikeTime,mealName,bookDate,mealTypeDesc,mealModDesc,qty,price,amount,userName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindStrikeByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStrikeByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindStrikeByDate(stDate As %String, endDate As %String, userRowid As %String, adm As %String) As %Query(ROWSPEC = "wardDesc:%String:病区,patName:%String:病人姓名,strikeDate:%String:退菜时间,mealName:%String:菜名,bookDate:%String:发菜日期,mealTypeDesc:%String:餐型,mealModDesc:%String:餐态,qty:%String:退菜数量,price:%String:单价,amount:%String:金额,userName:%String:收费员")
{
}

ClassMethod FindMealFeeByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMealFeeByDateExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator :wanghc
/// CreateDate:2010-12-12
/// Function  :某病人的膳食明细
/// Table     :dhc_ipmealorder,dhc_ipmealorderitem,dhc_ipmealBillDetail
/// Input     :开始日期到结束日期 ,adm ,papMedicare
/// OutPut    :用餐时间，菜名，份数...
/// d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealPrintComm","FindStrikeByDate", "2010-12-18","2010-12-18","","") --42
ClassMethod FindMealFeeByDateExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, userRowid As %String, admRowid As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    
    s deptName="科室名称",billedTotalAmount="已记帐金额",bookMealNum="订餐人数",inpatNum="住院人数",notEatNum="禁食人数"
    s ybookMealNum="应订餐人数",sjbookMealNum="实际就餐总人数",qty="退菜数量",ybookEatPrecent="就餐率"
	d OutputRow1
	s (patName,strikeDate,mealName,mealTypeDesc,mealModDesc,qty,price,amount,userName,totalAmount,totalQty)=""
	
	s stDate=$zdh(stDate,3) 
	s endDate=$zdh(endDate,3)
	f date=stDate:1:endDate d
	.s billRowid=0 
	.f  s billRowid = $o(^DHCIPMEALBILL(0,"BillDate",date,billRowid)) q:billRowid=""  d
	..s billSubRowid=0
	..s admDr=$p(^DHCIPMEALBILL(billRowid),"^",1)
	..q:(admRowid'="")&&(admRowid'=admDr)
	..s papmiID=$p(^PAADM(admDr),"^",1)
	..s patName=$p(^PAPER(papmiID,"ALL"),"^",1)   ;姓名
	..s wardDesc=""
	..s admWardDr=$p(^PAADM(admDr),"^",70)
	..s:+admWardDr'=0 wardDesc=$p($p(^PAWARD(admWardDr),"^",2),"-",2) 
	..f  s billSubRowid= $o(^DHCIPMEALBILL(0,"BillDate",date,billRowid,billSubRowid)) q:billSubRowid=""  d
 	...s tmpGlobalStr=^DHCIPMEALBILL(billRowid,"D",billSubRowid)
 	...s oldQty=$p(tmpGlobalStr,"^",3),newQty=0
 	...q:oldQty>=0
 	...s price=$p(tmpGlobalStr,"^",2)
 	...s oldOrdItemRowid=$p(tmpGlobalStr,"^",1)   //I-->B----停的
 	...s oldOrdItemSubRowid=$p(oldOrdItemRowid,"||",2)
 	...s oldOrdItemStr=^DHCIPMEALORDER(+oldOrdItemRowid,"I",oldOrdItemSubRowid)
 	...s mealRowid=$p(oldOrdItemStr,"^",1)
 	...s mealName=$p(^DHCIPMEALITEM(mealRowid),"^",2)
 	...s mealTypeDR=$p(oldOrdItemStr,"^",21) ;医嘱中的餐类型
    ...s mealTypeDesc=$p(^DHCIPMEALTYPE(mealTypeDR),"^",2)
    ...s mealModalityDR=$p(oldOrdItemStr,"^",22) ;医嘱中的餐态
 	...s mealModDesc=$p($g(^DHCIPMEALMODALITY(mealModalityDR)),"^",2)
 	...s bookDate=$zd($p(oldOrdItemStr,"^",2),3) ;订餐时间
 	...s strikeDate=$zd(date,3)
	...s time=$p(tmpGlobalStr,"^",8)
	...s strikeTime=$zt(time,1)
	...s userDr=$p(oldOrdItemStr,"^",14)
	...q:(userRowid'=userDr)&&(userRowid'="")
	...s userName=$p(^SSU("SSUSR",userDr),"^",2)
	...s newOrdItemRowid=$o(^DHCIPMEALORDER(0,"InitDr",oldOrdItemRowid,0))  
 	...;
 	...i +newOrdItemRowid=0 d
 	....s qty=oldQty   //全退
 	...e  d
 	....s newOrdItemSubRowid=$o(^DHCIPMEALORDER(0,"InitDr",oldOrdItemRowid,newOrdItemRowid,0))
 	....s newOMIRowid=newOrdItemRowid_"||"_newOrdItemSubRowid
 	....s newBillItemRowid=$o(^DHCIPMEALBILL(0,"MO",newOMIRowid,0))
 	....s newBillItemSubRowid=$o(^DHCIPMEALBILL(0,"MO",newOMIRowid,newBillItemRowid,0))
 	....s newMBIRowid=newBillItemRowid_"||"_newBillItemSubRowid
 	....s newQty=$p(^DHCIPMEALBILL(newBillItemRowid,"D",newBillItemSubRowid),"^",3)
 	....s qty=oldQty+$g(newQty)
	...s amount=qty*price
	...s totalQty=qty+totalQty
	...s totalAmount=totalAmount+amount
 	...d OutputRow1
 	s wardDesc="合计" 
 	s (patName,strikeDate,strikeTime,mealName,bookDate,mealTypeDesc,mealModDesc,price,userName)=""
 	s qty=totalQty
 	s amount=totalAmount
 	d OutputRow1
 	Set qHandle=$lb(0,repid,0)
    Quit $$$OK   
OutputRow1
	set Data=$lb(deptName,billedTotalAmount,bookMealNum,inpatNum,notEatNum,ybookMealNum,sjbookMealNum,qty,ybookEatPrecent)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMealFeeByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMealFeeByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindMealFeeByDate(stDate As %String, endDate As %String, userRowid As %String, adm As %String) As %Query(ROWSPEC = "deptName:%String:科室名称,billedTotalAmount:%String:已记帐金额,bookMealNum:%String:订餐人数,inpatNum:%String:住院人数,notEatNum:%String:禁食人数,ybookMealNum:%String:应订餐人数,sjbookMealNum:%String:实际就餐总人数,qty:%String:退菜数量,ybookEatPrecent:%String:就餐率")
{
}

ClassMethod FindMealPrecentByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMealPrecentByDateExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator :wanghc
/// CreateDate:2010-12-12
/// Function  :病区就餐率统计
/// Table     :dhc_ipmealorder,dhc_ipmealorderitem,dhc_ipmealBillDetail
/// Input     :开始日期到结束日期
/// OutPut    :病区名称,已记帐金额,订满三餐人数,住院人数,禁食人数,应订餐人数,实际就餐总人数,就餐率,治疗饮食应订餐人数,治疗饮食实际订餐人数,治疗饮食就餐率
/// d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealPrintComm","FindMealPrecentByDate", "2010-12-18","2010-12-18")
ClassMethod FindMealPrecentByDateExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s wardCode="病区",billedTotalAmount="已记帐金额",bookMealNum="订满三餐人数",inpatNum="住院人数",notEatNum="禁食人数"
    s ybookMealNum="应订餐人数",eatMealNum="实际就餐总人数",ybookEatPrecent="就餐率"
    s medYbookNum="治疗饮食应订餐人数",medEatMealNum="治疗饮食实际订餐人数",medBookEatPrecent="治疗饮食就餐率"
	d OutputRow1
	s (wardName,billedTotalAmount,bookMealNum,inpatNum,notEatNum,ybookMealNum,currentAdmNum,eatMealNum,ybookEatPrecent,medYbookNum,medEatMealNum,medBookEatPrecent)=""
	s stDate=$zdh(stDate,3) 
	s endDate=$zdh(endDate,3)
	i stDate>+$h Set qHandle=$lb(0,repid,0)    Quit $$$OK 
	i endDate>+$h s endDate=+$h
	s (billedSum,bookMealSum,inpatNumSum,notEatNumSum,ybookMealNumSum,eatMealNumSum,ybookEatPrecentSum,medYbookNumSum,medEatMealNumSum,medBookEatPrecentSum)=0
	s wardRowid=0 
	f  s wardRowid=$o(^PAWARD(wardRowid)) q:wardRowid=""  d
	.q:+wardRowid=0
	.k ^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardCode,+$h)
	.d ##class(DHCBILL.Diet.DHCIPMealPrintComm).writePrecent(+$h)
	.s wardCode=$p(^PAWARD(wardRowid),"^",1)
	.s (billedTotalAmount,bookMealNum,inpatNum,notEatNum,ybookMealNum,eatMealNum,ybookEatPrecent,medYbookNum,medEatMealNum,medBookEatPrecent,currentAdmNum)=0 
	.f date=stDate:1:endDate d
	..i '$d(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardCode,date)) d
	...d ##class(DHCBILL.Diet.DHCIPMealPrintComm).writePrecent(date)
	..;已记帐金额^订满三餐人数^住院人数^禁食人数^实际就餐总人数^治疗饮食应订餐人数^治疗饮食实际订餐人数
	..s billedTotalAmount=billedTotalAmount+$p($g(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardCode,date)),"^",1)
	..s bookMealNum=bookMealNum+$p($g(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardCode,date)),"^",2)
	..s inpatNum=inpatNum+$p($g(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardCode,date)),"^",3)
	..s notEatNum=notEatNum+$p($g(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardCode,date)),"^",4)
	..s eatMealNum=eatMealNum+$p($g(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardCode,date)),"^",5)
	..s medYbookNum=medYbookNum+$p($g(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardCode,date)),"^",6)
	..s medEatMealNum=medEatMealNum+$p($g(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardCode,date)),"^",7)
	..s currentAdmNum=currentAdmNum+$p($g(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardCode,date)),"^",8)
	.s ybookMealNum=inpatNum-notEatNum-currentAdmNum ;应就餐人次  除去当天入院的人
	.s:medYbookNum>0 medYbookNum=medYbookNum-currentAdmNum ;除去当天入院的人
	.s:ybookMealNum'=0 ybookEatPrecent=$j(eatMealNum/ybookMealNum,2,3)*100_"%" ;实际人次/应就餐人次 
	.s:medYbookNum'=0 medBookEatPrecent=$j(medEatMealNum/medYbookNum,2,3)*100_"%" ;治疗饮食实际订餐人数/治疗饮食应订餐人数
 	.;合计
 	.s billedSum=billedSum+billedTotalAmount,bookMealSum=bookMealSum+bookMealNum,inpatNumSum=inpatNumSum+inpatNum
 	.s notEatNumSum=notEatNumSum+notEatNum,ybookMealNumSum=ybookMealNumSum+ybookMealNum,eatMealNumSum=eatMealNumSum+eatMealNum
 	.s medYbookNumSum=medYbookNumSum+medYbookNum,medEatMealNumSum=medEatMealNumSum+medEatMealNum
 	.d OutputRow1
 	
 	s (wardCode,billedTotalAmount,bookMealNum,inpatNum,notEatNum,ybookMealNum,eatMealNum,ybookEatPrecent,medYbookNum,medEatMealNum,medBookEatPrecent)=0
 	s wardCode="合计",  billedTotalAmount=billedSum,bookMealNum=bookMealSum,inpatNum=inpatNumSum,notEatNum=notEatNumSum
 	s ybookMealNum=ybookMealNumSum,eatMealNum=eatMealNumSum,medYbookNum=medYbookNumSum,medEatMealNum=medEatMealNumSum
 	s:ybookMealNum'=0 ybookEatPrecent=$j(eatMealNum/ybookMealNum,2,3)*100_"%" ;实际人次/应就餐人次 
	s:medYbookNum'=0 medBookEatPrecent=$j(medEatMealNum/medYbookNum,2,3)*100_"%" ;治疗饮食实际订餐人数/治疗饮食应订餐人数
 	d OutputRow1
 	Set qHandle=$lb(0,repid,0)
    Quit $$$OK   
OutputRow1
	set Data=$lb(wardCode,billedTotalAmount,bookMealNum,inpatNum,notEatNum,ybookMealNum,eatMealNum,ybookEatPrecent,medYbookNum,medEatMealNum,medBookEatPrecent)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMealPrecentByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMealPrecentByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindMealPrecentByDate(stDate As %String, endDate As %String) As %Query(ROWSPEC = "wardName:%String:病区名称,billedTotalAmount:%String:已记帐金额,bookMealNum:%String:订满三餐人数,inpatNum:%String:住院人数,notEatNum:%String:禁食人数,ybookMealNum:%String:应订餐人数,eatMealNum:%String:实际就餐总人数,ybookEatPrecent:%String:就餐率,medYbookNum:%String:治疗饮食应订餐人数,medEatMealNum:%String:治疗饮食实际订餐人数,medBookEatPrecent:%String:治疗饮食就餐率")
{
}

/// date不能大于今天
/// ^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,date)=
/// 已记帐金额^订满三餐人数^住院人数^禁食人数^实际就餐总人数^治疗饮食应订餐人数^治疗饮食实际订餐人数
ClassMethod writePrecent(billDate)
{

	s:billDate="" billDate=+$h
	q:billDate>+$h
	s wardRowid=0 
	f  s wardRowid=$o(^PAWARD(wardRowid)) q:wardRowid=""  d
	.q:+wardRowid=0
	.s wardCode=$p(^PAWARD(wardRowid),"^",1)
	.k ^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardCode,billDate)
	s adm=0
	f  s adm=$o(^PAADMi("PAADM_Type","I",adm)) q:adm=""  d
	.s admGlobalStr=^PAADM(adm)
	.s visitStatus=$p(admGlobalStr,"^",20)
	.s dischgDate = $p(^PAADM(adm),"^",17)
	.q:(visitStatus'="A")&&(dischgDate<billDate)   //出院后不统计
	.s admDate=$p(admGlobalStr,"^",6)
	.s currentAdmNum=0
	.i admDate=billDate s currentAdmNum=1 ;当天入院的不算入当天
	.s wardDr=$p(^PAADM(adm),"^",70)
	.s wardDrCode=$p(^PAWARD(wardDr),"^",1)
	.s:'$d(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate)) ^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate)=""
	.s orderRowid=$o(^OEORD(0,"Adm",adm,""))
	.s notEatFlag=0
	.s medEatFlag=0
	.i +orderRowid'=0 d
	..s ordItemRowid=""
	..f  s ordItemRowid=$o(^OEORDi(0,"StDtStat",billDate,1,orderRowid,ordItemRowid)) q:(ordItemRowid="")||(medEatFlag&&notEatFlag)  d
	...s arcItmMastDr=$p(^OEORD(orderRowid,"I",ordItemRowid,1),"^",2)
    ...s:arcItmMastDr="15338||1" notEatFlag=1
	...s arcItemSubRowid=$p(arcItmMastDr,"||",2)
	...s arcItemCatRowid =$p(^ARCIM(+arcItmMastDr,arcItemSubRowid,1),"^",10)
	...;ARC_ItemCat=200 为治疗饮食
	...s:arcItemCatRowid=200 medEatFlag=1
	.;---记帐金额
	.s mealBillRowid=$o(^DHCIPMEALBILL(0,"Adm",adm,0))
	.s amount=0
	.i +mealBillRowid'=0 d
	..s mealBillDetailRowid=0
	..f  s mealBillDetailRowid=$o(^DHCIPMEALBILL(0,"BillDate",billDate,mealBillRowid,mealBillDetailRowid)) q:mealBillDetailRowid=""  d 
	...s amount=amount+$p(^DHCIPMEALBILL(mealBillRowid,"D",mealBillDetailRowid),"^",4)
	.;--订三餐人数
	.s morning=0,noon=0,night=0,allDayflag=0,eatMealflag=0
	.s mealOrderRowid=$o(^DHCIPMEALORDER(0,"Adm",adm,0))
	.i +mealOrderRowid'=0 d
	..s mealOrdItemRowid=0 
	..f  s mealOrdItemRowid=$o(^DHCIPMEALORDER(0,"StartDate",billDate,mealOrderRowid,mealOrdItemRowid)) q:(mealOrdItemRowid="")||(allDayflag=1)  d
	...s typeRowid=$p(^DHCIPMEALORDER(mealOrderRowid,"I",mealOrdItemRowid),"^",21)
	...s:typeRowid="106" morning=1
	...s:typeRowid="107" noon=1
	...s:typeRowid="108" night=1
	...s:typeRowid="109"||"110" allDayflag=1
	...s eatMealflag=1
	.s:morning&&noon&&night allDayflag=1
	.;--写global
	.;billedTotalAmount="已记帐金额"
	.s $p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",1)=amount+$p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",1)
	.;bookMealNum="订满三餐人数",
	.s $p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",2)=allDayflag+$p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",2)
	.;inpatNum="住院人数"  出院当天不算人头，金额要加上
	.i (visitStatus="A")&&(admDate<=billDate) s $p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",3)=1+$p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",3)
	.e  i (visitStatus'="A")&&(dischgDate>=billDate) s $p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",3)=1+$p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",3)
	.;notEatNum="禁食人数"
	.s $p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",4)=notEatFlag+$p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",4)
	.;eatMealNum="实际就餐总人数"
	.s $p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",5)=eatMealflag+$p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",5)
	.;medYbookNum"治疗饮食应订餐人数"
	.i (visitStatus="A")&&(admDate<=billDate) s $p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",6)=medEatFlag+$p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",6)
	.e  i (visitStatus'="A")&&(dischgDate>=billDate) s $p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",6)=medEatFlag+$p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",6)
	.;medEatMealNum="治疗饮食实际订餐人数"
	.i medEatFlag d
	..s $p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",7)=eatMealflag+$p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",7)
	.s eatMealflag=0
	.s $p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",8)=currentAdmNum+$p(^DHCIPMealPrecent("DHCIPMealPrintCommPrecent",wardDrCode,billDate),"^",8)
	q
}

ClassMethod FindMealCashierWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMealCashierWorkExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:	wanghc
/// CreateDate: 2010-12-27
/// Function  : 工作量统计
/// Table     : 
/// Input     : 开始日期到结束日期,点餐员rowid
/// OutPut    : 操作员工号,操作员姓名,点餐人数,点餐金额
/// Other	  : d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealPrintComm","FindMealCashierWork", "2010-12-18","2010-12-27")
ClassMethod FindMealCashierWorkExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s job=$j
    k ^TMP("DHCIPMealPrintComm","CashierWork",job)
    s cashierCode="操作员工号",cashierName="操作员姓名",bookNum="点餐人次",fee="点餐金额"
	d OutputRow1
	s (cashierCode,cashierName,bookNum,fee)=""
	s stDate=$zdh(stDate,3) 
	s endDate=$zdh(endDate,3)
	i stDate>+$h Set qHandle=$lb(0,repid,0)    Quit $$$OK 
	i endDate>+$h s endDate=+$h
	f date=stDate:1:endDate d
	.s mealOrderRowid=0 
	.f  s mealOrderRowid=$o(^DHCIPMEALORDER(0,"StartDate",date,mealOrderRowid)) q:mealOrderRowid=""  d
	..s mealOrdItemRowid=0 
	..k ^TMP("DHCIPMealPrintComm","BookCashierFlag")
	..f  s mealOrdItemRowid=$o(^DHCIPMEALORDER(0,"StartDate",date,mealOrderRowid,mealOrdItemRowid)) q:mealOrdItemRowid=""  d
	...s tmpOrdItemStr=^DHCIPMEALORDER(mealOrderRowid,"I",mealOrdItemRowid) 
	...s userDr=$p(tmpOrdItemStr,"^",14)
	...s ^TMP("DHCIPMealPrintComm","BookCashierFlag",userDr)=1
    ...s qty=$p(tmpOrdItemStr,"^",5)
    ...s mealItemRowid=$p(tmpOrdItemStr,"^",1)
    ...s startDate=$p(tmpOrdItemStr,"^",2)
    ...s price=##class(DHCBILL.Diet.DHCIPMealFeeBill).GetMenuItmPrice(mealItemRowid,startDate)	
    ...s amount=price*qty
	...s ^TMP("DHCIPMealPrintComm","CashierWork",job,userDr,"amount")=amount+$g(^TMP("DHCIPMealPrintComm","CashierWork",job,userDr,"amount"))
	..s userRowid=0
	..f  s userRowid=$o(^TMP("DHCIPMealPrintComm","BookCashierFlag",userRowid)) q:userRowid=""  d
	...s flag=^TMP("DHCIPMealPrintComm","BookCashierFlag",userRowid)
	...s ^TMP("DHCIPMealPrintComm","CashierWork",job,userRowid,"num")=flag+$g(^TMP("DHCIPMealPrintComm","CashierWork",job,userRowid,"num"))
	
	s userRowid=0
	f  s userRowid=$o(^TMP("DHCIPMealPrintComm","CashierWork",job,userRowid)) q:userRowid=""  d
 	.s cashierCode=$p(^SSU("SSUSR",userRowid),"^",1)
 	.s cashierName=$p(^SSU("SSUSR",userRowid),"^",2)
 	.s bookNum=^TMP("DHCIPMealPrintComm","CashierWork",job,userRowid,"num")
 	.s fee=^TMP("DHCIPMealPrintComm","CashierWork",job,userRowid,"amount")
 	.d OutputRow1
 
 	Set qHandle=$lb(0,repid,0)
    Quit $$$OK   
OutputRow1
	set Data=$lb(cashierCode,cashierName,bookNum,fee)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMealCashierWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMealCashierWorkExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindMealCashierWork(stDate As %String, endDate As %String) As %Query(ROWSPEC = "cashierCode:%String:操作员工号,cashierName:%String:操作员姓名,bookNum:%String:点餐人数,fee:%String:点餐金额")
{
}

/// Lid
/// 2012-03-08
/// 打印膳食医嘱明细，用于发餐
/// "2012-03-09^^^
/// w ##class(DHCBILL.Diet.DHCIPMealPrintComm).WirteDietOrderGlobal("2012-03-08","","","","","")
ClassMethod WirteDietOrderGlobal(StartDate As %String, EndDate As %String, ArcItmCatDR As %String, MealType As %String, GroupDR As %String = "", HospitalDR As %String, WardDR As %String)
{
	
	s job=$j
	s rtn=##class(DHCBILL.Diet.DHCIPMealSendOutDiet).GetDietOrder(job,StartDate,EndDate,ArcItmCatDR,MealType,GroupDR,HospitalDR,WardDR)
		//列名,	列串,		字段,		餐态,				餐形
	s cmStr="",fieldName="",modColumModleStr ="",typeColumModleStr="",totalStr=""
	s BWardDR=""
	f  s BWardDR=$o(^TMP("DHCBILL","DietOrderHeader",job,BWardDR))  q:BWardDR=""  d
	.;s BWardDesc=$p($p(^PAWARD(BWardDR),"^",2),"-",2) 	;病区
	.s BWardDesc=$p(^PAWARD(BWardDR),"^",2) 	;病区
	.s:BWardDesc["-" BWardDesc=$p(BWardDesc,"-",2)
	.s colName=BWardDR
	.i fieldName="" s fieldName="{name:'colNameItm'},{name:'"_colName_"'}"
    .e  s fieldName=fieldName_",{name:'"_colName_"'}"	   
    .i cmStr="" s cmStr="new Ext.grid.RowNumberer(),{header:'菜名',dataIndex:'colNameItm'},{"_"header:'"_BWardDesc_"',dataIndex:"_"'"_colName_"'}"
    .e  s cmStr=cmStr_",{header:'"_BWardDesc_"',dataIndex:"_"'"_colName_"'}"
	i fieldName'="" d
	.s fieldName=fieldName_",{name:'ItmSum'}" 
	i cmStr'="" d
	.s cmStr=cmStr_",{header:'合计',dataIndex:'ItmSum'}"
	w "{fieldsNames:["_fieldName_"],"
	w "columModle:["_cmStr_"],"
	;
    w "data:["
	s totalCount=1
	s Itm="" 
	f  s Itm=$o(^TMP("DHCBILL","DietOrder",job,Itm)) q:Itm=""  d
	.s ItmDesc=$p($g(^ARCIM(+Itm,$p(Itm,"||",2),1)),"^",2)
	.s lineStr="colNameItm:'"_ItmDesc_"'"
	.s colName="",ItmCount=0
	.f  s colName=$o(^TMP("DHCBILL","DietOrder",job,Itm,colName)) q:colName=""  d
  	..s lineStr=lineStr_","_colName_":'"_$g(^TMP("DHCBILL","DietOrder",job,Itm,colName))_"'"
  	..s ItmCount=ItmCount+(+$g(^TMP("DHCBILL","DietOrder",job,Itm,colName)))
  	.s lineStr=lineStr_",ItmSum:'"_ItmCount_"'"
	.i totalCount=1 w "{"_lineStr_"}"
	.e  w ",{"_lineStr_"}"
	.s totalCount=totalCount+1
	w "],totalCount:"_totalCount_"}"
	k ^TMP("DHCBILL","DietOrder",job)
	k ^TMP("DHCBILL","DietOrderHeader",job)
}

}
