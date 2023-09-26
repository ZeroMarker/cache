Import sqluser

Class web.INSUTarContrastListCom Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 101;

ClassMethod QueryContrastListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryContrastListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##Class(%ResultSet).RunQuery("web.INSUTarContrastListCom","QueryContrastList","8","ZZB")
ClassMethod QueryContrastListExecute(ByRef qHandle As %Binary, TarId As %String, Type As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ConId="",InsuId="",InsuCode="",InsuDesc="",ConQty="",InsuGG=""
	s InsuDW="",InsuSeltPer="",InsuCate="",InsuClass="",conActDate="",InsuType="",INTCTExpiryDate="",INTIMExpiryDate=""
	s ind=1	
	Set qHandle=$lb(0,repid,0)                      ///句柄
	s:Type="" Type="NBB"
	Quit:$g(TarId)="" $$$OK
	Quit:'$d(^DHCINTCT("0","DHCTID",TarId)) $$$OK	///组建返回值用$$$OK
	s rowid="0"
	f  s rowid=$o(^DHCINTCT("0","DHCTID",TarId,rowid))  q:rowid=""  d
	.s ConId=rowid
	.s ConString=$$GetContDetail^DHCINSUTarContrast(ConId)
	.s InsuId=$p(ConString,"^",4)
	.s ConQty=$p(ConString,"^",10)
	.;s conActDate=$zd($p(ConString,"^",13),3) 
	.s conActDate=##class(websys.Conversions).DateLogicalToHtml($p(ConString,"^",13)) ;Zhan 20170309
	.s INTCTExpiryDate=$p(ConString,"^",20)
	.;s:INTCTExpiryDate'="" INTCTExpiryDate=$zd(INTCTExpiryDate,3)
	.s:+INTCTExpiryDate>0 INTCTExpiryDate=##class(websys.Conversions).DateLogicalToHtml(INTCTExpiryDate)
	.;s:$p(ConString,"^",16)'="" INTCTDate=$zd($p(ConString,"^",16),3) 
	.s:+$p(ConString,"^",16)>0 INTCTDate=##class(websys.Conversions).DateLogicalToHtml($p(ConString,"^",16)) 
	.;s:$p(ConString,"^",17)'="" INTCTTime=$zt($p(ConString,"^",17),1) 
	.s:+$p(ConString,"^",17)>0 INTCTTime=##class(websys.Conversions).TimeLogicalToHtml($p(ConString,"^",17)) 
	.i InsuId'="" d
	..s InsuString=$$GetInsuDetail^DHCINSUTarItems(InsuId)
	..s InsuType=$p(InsuString,"^",2)
	..s InsuCode=$p(InsuString,"^",3)
	..s InsuDesc=$p(InsuString,"^",4)
	..s InsuGG=$p(InsuString,"^",9)
	..s InsuDW=$p(InsuString,"^",10)
	..s InsuSeltPer=$p(InsuString,"^",18)
	..s InsuCate=$p(InsuString,"^",38)
	..s InsuClass=$p(InsuString,"^",23)
	..b ;h
	..s INTIMExpiryDate=$p(InsuString,"^",44)
	..;s:INTIMExpiryDate'="" INTIMExpiryDate=$zd(INTIMExpiryDate,3)
	..s:+INTIMExpiryDate>0 INTIMExpiryDate=##class(websys.Conversions).DateLogicalToHtml(INTIMExpiryDate)
	.q:InsuType'=Type

	.d BuildList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildList      
	s:$p(InsuSeltPer,".",1)="" InsuSeltPer="0"_InsuSeltPer
	set Data=$lb(ConId,InsuId,InsuCode,InsuDesc,ConQty,InsuGG,InsuDW,InsuSeltPer,InsuCate,InsuClass,conActDate,INTCTExpiryDate,INTIMExpiryDate,INTCTDate,INTCTTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryContrastListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryContrastListExecute ]
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

Query QueryContrastList(TarId As %String, Type As %String) As %Query(ROWSPEC = "ConId:%String,InsuId:%String,InsuCode:%String,InsuDesc:%String,ConQty:%String,InsuGG:%String,InsuDW:%String,InsuSeltPer:%String,InsuCate:%String,InsuClass:%String,conActDate:%String,INTCTExpiryDate:%String,INTIMExpiryDate:%String,INTCTDate:%String,INTCTTime:%String")
{
}

/// 得到his信息
ClassMethod GetTarInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", Rowid As %Library.String = "")
{
	q:Rowid="" ""	
	s TarInfo=$$GetTarDetail^DHCINSUTarContrast(Rowid)
	q TarInfo
}

/// add by lilizhi 2013-03-27 
/// 更新医保目录对照表的失效日期
ClassMethod UpdateExpiryDate(INTCTRowid As %Library.String = "", ExpiryDate As %Library.String = "") As %Library.String
{
	q:INTCTRowid="" "-1"
	s flag=$$UpdateExpiryDate^DHCINSUTarContrast(INTCTRowid,ExpiryDate)
	q flag
}

/// add by lilizhi 2013-03-27 
/// 根据收费项取rowid取收费项信息
ClassMethod GetTariInfo(TariId As %Library.String = "") As %Library.String
{
	q:TariId="" "-1"
	s rtn=$$GetTarDetail^DHCINSUTarContrast(TariId)
	q rtn
}

ClassMethod QueryConListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryConListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryConListExecute(ByRef qHandle As %Binary, TarId As %String, Type As %String) As %Status
{
	;d ##Class(%ResultSet).RunQuery("web.INSUTarContrastListCom","QueryConList","613","BJA")
	Set repid=$I(^CacheTemp)
	s ConId="",InsuId="",InsuCode="",InsuDesc="",ConQty="",InsuGG=""
	s InsuDW="",InsuSeltPer="",InsuCate="",InsuClass="",conActDate="",InsuType="",PZWH=""
	s ind=1	
	Set qHandle=$lb(0,repid,0)                      ///句柄
	s:Type="" Type="NBB"
	Quit:$g(TarId)="" $$$OK
	Quit:'$d(^DHCINTCT("0","DHCTID",TarId)) $$$OK	///组建返回值用$$$OK
	s rowid="0"
	f  s rowid=$o(^DHCINTCT("0","DHCTID",TarId,rowid))  q:rowid=""  d
	.s ConId=rowid
	.;+2019-7-30 tangzf 医院授权判断 start
	.s dataHosp=$p(^DHCINTCT(rowid),"^",27)
	.s CheckHosipitalSession=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("INSU_TarContrast",rowid,"",dataHosp)
	.q:CheckHosipitalSession'="Y" ; 该院区无权查看该数据
	.;+2019-7-30 tangzf 医院授权判断 end
	.s (ExDate,InsuCode,InsuDesc,Insurj,InsuGG,InsuDW,InsuSeltPer,InsuCate,InsuClass,TblConUserDr,TblConUser,PZWH)=""
	.s ConString=$$GetContDetail^DHCINSUTarContrast(ConId)
	.s InsuId=$p(ConString,"^",4)
	.s ConQty=$p(ConString,"^",10)
	.;s conActDate=$zd($p(ConString,"^",13),3)
	.s conActDate=##class(websys.Conversions).DateLogicalToHtml($p(ConString,"^",13)) ;Zhan 20170309
	.s PatTypeDr=$p(ConString,"^",9)
	.s Amount=$p(ConString,"^",10)
	.s DrAddFlag=$p(ConString,"^",11) ;DingSH 20170221
	.s DrAddFlagDesc=$case(DrAddFlag,"1":"已上传","2":"审核通过","3":"审核未通过",:"未上传") ;DingSH 20170221
	.s DicType=$p(ConString,"^",12)
	.s ZText=$p(ConString,"^",14)
	.s Date=$p(ConString,"^",16)
	.;s:Date'="" Date=$zd(Date,3)
	.s:+Date>0 Date=##class(websys.Conversions).DateLogicalToHtml(Date) ;Zhan 20170309
	.s Time=$p(ConString,"^",17)
	.;s:Time'="" Time=$zt(Time,1)
	.s:+Time>0 Time=##class(websys.Conversions).TimeLogicalToHtml(Time) ;Zhan 20170309
	.s ADDIP=$p(ConString,"^",18)
	.s Unique=$p(ConString,"^",19)
	.s ExpiryDate=$p(ConString,"^",20)
	.;s:ExpiryDate'="" ExpiryDate=$zd(ExpiryDate,3)
	.s:+ExpiryDate>0 ExpiryDate=##class(websys.Conversions).DateLogicalToHtml(ExpiryDate)
	.s UpLoadDate=$p(ConString,"^",21)
	.s UpLoadTime=$p(ConString,"^",22)
	.s DownLoadDate=$p(ConString,"^",23)
	.s DownLoadTime=$p(ConString,"^",24)
	.s LastModDate=$p(ConString,"^",25)
	.s LastModTime=$p(ConString,"^",26)
	.i InsuId'="" d
	..s InsuString=$$GetInsuDetail^DHCINSUTarItems(InsuId)
	..s InsuType=$p(InsuString,"^",2)
	..s InsuCode=$p(InsuString,"^",3)
	..s InsuDesc=$p(InsuString,"^",4)
	..s Insurj=$p(InsuString,"^",5)
	..s InsuGG=$p(InsuString,"^",9)
	..s InsuDW=$p(InsuString,"^",10)
	..s InsuSeltPer=$p(InsuString,"^",18)
	..s InsuCate=$p(InsuString,"^",36) ;$p(InsuString,"^",38)
	..s InsuClass=$p(InsuString,"^",23)
	..s:InsuClass'="" InsuClass=##class(web.INSUDicDataCom).GetDicByCodeAndInd("chrgitm_lv"_InsuType,InsuClass,4)	// AKA065 Zhan 20150711
	..s TblConUserDr=$p(ConString,"^",15)
	..s ExDate=$p(InsuString,"^",44)
	..;s:ExDate'="" ExDate=$zd(ExDate,3)
	..s:+ExDate>0 ExDate=##class(websys.Conversions).DateLogicalToHtml(ExDate)	;Zhan 20170309
	..s:+TblConUserDr>0 TblConUser=$p(^SSU("SSUSR",TblConUserDr),"^",2)
	..s:PZWH="" PZWH=$p(InsuString,"^",14)
	..s:Unique="" Unique=$p(InsuString,"^",43)
	..s:ZText="" ZText=$p(InsuString,"^",22)
	.q:InsuType'=Type
	.d BuildConList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildConList    
	;ExpiryDate,UpLoadDate,UpLoadTime,DownLoadDate,DownLoadTime,LastModDate,LastModTime
	;s:$l(ExpiryDate)=5 ExpiryDate=$zd(ExpiryDate,3)
	;s:+ExpiryDate>0 ExpiryDate=##class(websys.Conversions).DateLogicalToHtml(ExpiryDate) ;Zhan 20170309
	;s:$l(UpLoadDate)=5 UpLoadDate=$zd(UpLoadDate,3)
	s:+UpLoadDate>0 UpLoadDate=##class(websys.Conversions).DateLogicalToHtml(UpLoadDate) ;Zhan 20170309
	;s:$l(UpLoadTime)=5 UpLoadTime=$zt(UpLoadTime,1)
	s:+UpLoadTime>0 UpLoadTime=##class(websys.Conversions).TimeLogicalToHtml(UpLoadTime) ;Zhan 20170309
	;s:$l(DownLoadDate)=5 DownLoadDate=$zd(DownLoadDate,3)
	s:+DownLoadDate>0 DownLoadDate=##class(websys.Conversions).DateLogicalToHtml(DownLoadDate) ;Zhan 20170309
	;s:$l(DownLoadTime)=5 DownLoadTime=$zt(DownLoadTime,1)
	s:+DownLoadTime>0 DownLoadTime=##class(websys.Conversions).DateLogicalToHtml(DownLoadTime)
	;s:$l(LastModDate)=5 LastModDate=$zd(LastModDate,3)
	s:+LastModDate>0 LastModDate=##class(websys.Conversions).DateLogicalToHtml(LastModDate) ;Zhan 20170309
	s:$l(LastModTime)=5 LastModTime=$zt(LastModTime,1)
	s:$p(InsuSeltPer,".",1)="" InsuSeltPer="0"_InsuSeltPer
	set Data=$lb(ConId,InsuId,Insurj,InsuCode,InsuDesc,ConQty,InsuGG,InsuDW,InsuSeltPer,InsuCate,InsuClass,conActDate,$g(TblConUser),ExDate,PatTypeDr,Amount,DrAddFlag,DicType,ZText,Date,Time,ADDIP,Unique,ExpiryDate,UpLoadDate,UpLoadTime,DownLoadDate,DownLoadTime,LastModDate,LastModTime,PZWH,DrAddFlagDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryConListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryConListExecute ]
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

Query QueryConList(TarId As %String, Type As %String) As %Query(ROWSPEC = "ConId:%String,InsuId:%String,Insurj:%String,InsuCode:%String,InsuDesc:%String,ConQty:%String,InsuGG:%String,InsuDW:%String,InsuSeltPer:%String,InsuCate:%String,InsuClass:%String,conActDate:%String,TblConUser:%String,ExDate:%String,PatTypeDr:%String,Amount:%String,DrAddFlag:%String,DicType:%String,ZText:%String,Date:%String,Time:%String,ADDIP:%String,Unique:%String,ExpiryDate:%String,UpLoadDate:%String,UpLoadTime:%String,DownLoadDate:%String,DownLoadTime:%String,LastModDate:%String,LastModTime:%String,PZWH:%String,DrAddFlagDesc:%String")
{
}

}
