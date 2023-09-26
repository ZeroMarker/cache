Class DHCDoc.DHCDocConfig.Group Extends Common
{

/// w ##class(DHCDoc.DHCDocConfig.Group).SaveMulDocConfig1($LG(^Wqy("SaveMulDocConfig1"),1),$LG(^Wqy("SaveMulDocConfig1"),2),$LG(^Wqy("SaveMulDocConfig1"),3))
ClassMethod SaveMulDocConfig1(InputStr, GroupID, HospID = "")
{
	s ^Wqy("SaveMulDocConfig1")=$LB(InputStr, GroupID, HospID)
	TS
    s InputObj={}.%FromJSON(InputStr)
	;医嘱右键菜单授权单独处理
    if InputObj.%IsDefined("tabOrdListMenu"){
        s OrdListMenu=InputObj.tabOrdListMenu
        d InputObj.%Remove("tabOrdListMenu")
		s ret=..SaveOrdListMenu(OrdListMenu, GroupID)
		if ret'=0{
			TRO
			Q ret
		}
    }
	;诊疗默认跳转页签
    if InputObj.%IsDefined("NewDocGotoWhere"){
        s NewDocGotoWhere=InputObj.NewDocGotoWhere
        d InputObj.%Remove("NewDocGotoWhere")
		s ret=..SaveNewDocGotoWhere(NewDocGotoWhere, GroupID,HospID)
		if ret'=0{
			TRO
			Q ret
		}
    }
	;《预住院审批权限》存储兼容以前 
	if InputObj.%IsDefined("BookPreLocDocLimit"){
		s BookPreLocDocLimit=InputObj.BookPreLocDocLimit
		s BookPreLocNurseLimit=InputObj.BookPreLocNurseLimit
		s BookPreLocCashLimit=InputObj.BookPreLocCashLimit
		s NoteStr="BookPreLocDocLimit!"_BookPreLocDocLimit_"^BookPreLocNurseLimit!"_BookPreLocNurseLimit_"^BookPreLocCashLimit!"_BookPreLocCashLimit
		d ##class(web.DHCOPRegConfig).SaveRegSetConfig(HospID,GroupID,NoteStr)
	}
    s ret=##super(InputObj, GroupID, HospID)
    if ret'=0{
		TRO
		Q ret
	}
	TC
    Q 0
}

/***
  **Description      :保存诊疗默认菜单
  **Author           :tanjishan
  **Time             :2022/12/05
  **debugger         :##class(DHCDoc.DHCDocConfig.Group).SaveNewDocGotoWhere(,,)
  **Parameter        :input
  **Returns          :%String
***/
ClassMethod SaveNewDocGotoWhere(rows, GroupID, HospID) As %String
{
	if $ClassName(rows)'="%Library.DynamicArray"{
		s rows=[].%FromJSON(rows)
	}
	s HospCodeNode="HospDr_"_HospID
    for i=1:1:rows.%Size(){
		s row=rows.%Get(i-1)
		if (row.CatID=""){
			continue
		}
		s NewDocGotoWhere=row.NewDocGotoWhere
		if (+row.LocID=0){
			s ^DHCDocConfig(HospCodeNode,"NewDocGotoWhere",row.CatID,GroupID)=NewDocGotoWhere
		}else{
			s ^DHCDocConfig(HospCodeNode,"NewDocGotoWhere",row.CatID,GroupID,row.LocID)=NewDocGotoWhere
		}
    }
	q 0
}

ClassMethod SaveOrdListMenu(rows, GroupID)
{
	TS
    s gobj = ##class(User.SSExtMeunGroup).%OpenId(GroupID)
	if '$IsObject(gobj){
		TRO
		Q "-1^安全组非法"
	}
    if $ClassName(rows)'="%Library.DynamicArray"{
		s rows=[].%FromJSON(rows)
	}
	s ret=0
	s error=0,EMParentId=""
	s menubit=gobj.DHCEMGExtMenu
    for i=1:1:rows.%Size(){
		s row=rows.%Get(i-1)
		if (row.EMCode="")&&(row.EMText=""){
			continue
		}
		if row.EMCode=""{
			s ret="-2^代码不能为空"
			Q
		}
        if row.ID="" s row.ID=$O(^websys.ExtMenuI("EMCodeMenu"," "_$$ALPHAUP^SSUTIL4(row.ID),""))
        if row.ID'=""{
            s menuOBJ=##class(websys.ExtMenu).%OpenId(row.ID)
        }else{
            s menuOBJ=##class(websys.ExtMenu).%New()
        }
		s menuOBJ.EMCode=row.EMCode
        s menuOBJ.EMText=row.EMText
		s menuOBJ.EMHandler=row.EMHandler
		s menuOBJ.EMDisplayHandler=row.EMDisplayHandler
		s menuOBJ.EMParentCode=row.EMParentCode
		s sc=menuOBJ.%Save()
		if $$$ISERR(sc){
			s ret="-2^"_row.EMCode_"保存失败"
			Q
		}
		s ID=menuOBJ.%Id()
		d menuOBJ.%Close()   
		s $bit(menubit,ID)=row.CheckFlag
		;自动授权父菜单
		if (EMParentId="")&&(row.CheckFlag=1){
			s parentcode = " "_$$ALPHAUP^SSUTIL4(row.EMParentCode)
			s EMParentId=$o(^websys.ExtMenuI("EMCodeMenu",parentcode,""))
			if EMParentId'="" s $bit(menubit,EMParentId)=1
		}
    }
	if ret=0{
		s gobj.DHCEMGExtMenu = menubit
		d gobj.%Save()
		d gobj.%Close()
		TC
	}else{
		TRO
	}
	Q ret
}

Query QueryOrdRightMenu(ParNode, GroupID) As %Query(ROWSPEC = "ID,EMCode,EMText,EMHandler,EMDisplayHandler,EMParentCode,CheckFlag:%Boolean")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Group","QueryOrdRightMenu","NURPRNOrder",1)
ClassMethod QueryOrdRightMenuExecute(ByRef qHandle As %Binary, ParNode, GroupID) As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s ParNode = " "_$$ALPHAUP^SSUTIL4(ParNode)	
	s index=0 f  s index = $o(^websys.ExtMenuI("EMChildrenMenu",ParNode,index)) q:index=""  d
	.s ID = 0 f  s ID = $o(^websys.ExtMenuI("EMChildrenMenu",ParNode,index,ID)) q:ID=""  d
	..s obj = ##class(websys.ExtMenu).%OpenId(ID,0)
	..s CheckFlag=0
	..i (GroupID'="")&&$d(^SSU("SSGRP",GroupID,"Menu")) d
	...s CheckFlag=$bit($P(^SSU("SSGRP",GroupID,"Menu"),"^",1),ID) 
	..d rows.%Push($LB(ID,obj.EMCode,obj.EMText,obj.EMHandler,obj.EMDisplayHandler,obj.EMParentCode,CheckFlag))
	..d obj.%Close()
	Quit $$$OK
}

ClassMethod QueryOrdRightMenuFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrdRightMenuExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

}
