Import SQLUser

Class web.DHCWMRNoTypeCtl Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCWMRNoCtl","QueryMrNoType")
Query QueryMrNoType() As %Query(ROWSPEC = "MrType:%String,Len:%String,Head:%String,DefLoc:%String,MinNo:%String,Field:%String,MrNoCancelFlag:%String,DefaultType:%String,HospitalID:%String,AdmType:%String,ReceiptType:%String,AssignType:%String,UnReceiptType:%String,RecycleType:%String,Text1:%String,Text2:%String,Text3:%String,Text4:%String")
{
}

ClassMethod QueryMrNoTypeExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	s MrTypeId=0
	f  s MrTypeId=$o(^DHCWMRNOTYPE("NoFormat",MrTypeId)) q:MrTypeId=""  d
	.q:'$d(^DHCWMRNOTYPE("NoFormat",MrTypeId))
	.s tmp=$g(^DHCWMRDIC(MrTypeId))
	.s MrTypeCode=$p(tmp,"^",2)
	.s MrTypeDesc=$p(tmp,"^",3)
	.s MrType=MrTypeId_"/"_MrTypeCode_"/"_MrTypeDesc
	.s tmp=..GetMrNoType(MrTypeId)
	.q:tmp=""
	.s Len=$p(tmp,"^",1)
	.s Head=$p(tmp,"^",2)
	.s DefLoc=$p(tmp,"^",3)
	.s MinNo=$p(tmp,"^",4)
	.s Field=$p(tmp,"^",5)
	.s MrNoCancelFlag=$p(tmp,"^",6) ;add by liuxuefeng 2009-06-29 增加是否取消病案号字段
	.s DefaultType = $p(tmp,"^",7)
	.s HospitalID = $p(tmp,"^",8)
	.s AdmType = $p(tmp,"^",9)
	.s ReceiptType = $p(tmp,"^",10)
	.s AssignType = $p(tmp,"^",11)
	.s UnReceiptType = $p(tmp,"^",12)
	.s RecycleType = $p(tmp,"^",13)
	.s Text1 = $p(tmp,"^",14)
	.s Text2 = $p(tmp,"^",15)
	.s Text3 = $p(tmp,"^",16)
	.s Text4 = $p(tmp,"^",17)
	.s s=MrType_"^"_Len_"^"_Head_"^"_DefLoc_"^"_MinNo_"^"_Field_"^"_MrNoCancelFlag_"^"_DefaultType_"^"_HospitalID_"^"_AdmType_"^"_ReceiptType_"^"_AssignType_"^"_UnReceiptType_"^"_RecycleType_"^"_Text1_"^"_Text2_"^"_Text3_"^"_Text4
    .d BuildData
    q $$$OK
    
BuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryMrNoTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMrNoTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryMrNoTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMrNoTypeExecute ]
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

/// 通过病案类型查询病案号格式信息
/// 参数：MrType  病案类型Rowid
/// 输出：长度^首代码^科室取号(ID/Desc)^最小号^存储字段(ID/Code/Desc)^MrNoCancelFlag(add "MrNoCancelFlag" by liuxuefeng 2009-06-29)
/// w ##Class(web.DHCWMRNoTypeCtl).GetMrNoType(MrType)
ClassMethod GetMrNoType(MrType)
{
	n (MrType)
	s ret=""
	q:MrType="" ret
	q:'$d(^DHCWMRNOTYPE("NoFormat",MrType)) ret
	;^DHCWMRNOTYPE("NoFormat",MrType)=NumLen_"^"_NoHead_"^"_DefaultLocFlg_"^"_MinNo_"^"_MrNoField
	s TMP=$g(^DHCWMRNOTYPE("NoFormat",MrType))
	s tmpLoc=$p(TMP,"^",3)
	s tmpLoc=$s(tmpLoc=1:1,1:0)
	s:tmpLoc=0 tmpLocDesc="全院统一取号"
	s:tmpLoc=1 tmpLocDesc="按科室取号"
	s $p(TMP,"^",3)=tmpLoc_"/"_tmpLocDesc
	s tmpFieldId=$p(TMP,"^",5)
	i tmpFieldId'="" d
	.s tmp=$g(^DHCWMRDIC(+tmpFieldId))
	.s tmpCode=$p(tmp,"^",2)
	.s tmpDesc=$p(tmp,"^",3)
	.s tmpField=tmpFieldId_"/"_tmpCode_"/"_tmpDesc
	.s $p(TMP,"^",5)=tmpField
	s ret=TMP
	q ret
}

/// Debug:w ##class(web.DHCWMRNoTypeCtl).UpdateMrType(InStr)
ClassMethod UpdateMrType(InStr)
{
	n (InStr)
	s ^CacheTemp("UpdateMrType")=InStr
	s InStr=$tr(InStr," ","")
	s PLIST(1)=$p(InStr,"^",1)  ; Rowid
	s Rowid=$p(InStr,"^",1)  	; Rowid
	s PLIST(2)=$p(InStr,"^",2)  ; 号码长度
	s PLIST(3)=$p(InStr,"^",3)  ; 字母标记
	s PLIST(4)=$p(InStr,"^",4)  ; 放号方式
	s PLIST(5)=$p(InStr,"^",5)  ; 号码最小值
	s PLIST(6)=$p(InStr,"^",6)  ; 病人信息表存储字段
	s PLIST(7)=$p(InStr,"^",7)  ; 是否取消病案
	s PLIST(8)=$p(InStr,"^",8)  ; 默认号码类型
	s PLIST(9)=$p(InStr,"^",9)  ; 医院ID
	s PLIST(10)=$p(InStr,"^",10)  ; 就诊类型
	s PLIST(11)=$p(InStr,"^",11) ; 接诊方式
	s PLIST(12)=$p(InStr,"^",12) ; 号码发放方式
	s PLIST(13)=$p(InStr,"^",13) ; 取消接诊方式
	s PLIST(14)=$p(InStr,"^",14) ; 号码回收方式
	s PLIST(15)=$p(InStr,"^",15) ; 主导方式
	s PLIST(16)=$p(InStr,"^",16) ; 释放卷号
	s PLIST(17)=$p(InStr,"^",17) ; 备用字段
	s PLIST(18)=$p(InStr,"^",18) ; 备用字段
	                  
    ;s PLIST(6)=$s($p(InStr,"^",6)["Y":"Y",1:"N")             
         
    i Rowid="" d
    .&sql(Insert into DHC_WMR_NoType values :PLIST())
    e  d
    .&sql(Update DHC_WMR_NoType values :PLIST() where Rowid=:Rowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

/// 根据病案类型ID，获取自动分号当前号码
/// add by liuxuefeng 2010-08-31
ClassMethod GetCurrNoByMrType(MrTypeID)
{
	n (MrTypeID)
	s CurrNo=$g(^DHCWMRNOTYPE("CurrentNo",+MrTypeID))
	q CurrNo
}

/// 根据病案类型ID，设置新的自动分号当前号码
/// add by liuxuefeng 2010-08-31
ClassMethod SetCurrNoByMrType(MrTypeID, NewCurrNo)
{
	n (MrTypeID,NewCurrNo)
	s ret=-1
	q:+MrTypeID<=0 ret
	s ret=-2
	q:+NewCurrNo<0 ret
	s NewCurrNo=$tr(NewCurrNo," ","")
	s ^DHCWMRNOTYPE("CurrentNo",+MrTypeID)=NewCurrNo
	q NewCurrNo
}

}
