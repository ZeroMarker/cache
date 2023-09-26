Import SQLUser

Class web.DHCWMRFrontPageCtl Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 52;

/// 7 病案首页 DHC_WMR_FrontPage
ClassMethod UpdateFrontPage(Instring)
{
    n (Instring)
    s RowId=$p(Instring,"^",1)             ;RowId    
    s PLIST(2)=+$p(Instring,"^",2)         ;VolumeDr       
    s PLIST(3)=$p(Instring,"^",3)          ;ResumeText
    s PLIST(4)=+$p(Instring,"^",4)         ;RepUserDr
    s RepDate=$p(Instring,"^",5)           ;RepDate
    s:(RepDate'="")&(RepDate["-") RepDate=$zdh(RepDate,3)
    s:(RepDate'="")&(RepDate["/") RepDate=$zdh(RepDate,4)
    s PLIST(5)=RepDate
    s:PLIST(5)="" PLIST(5)=+$h
    s RepTime=$p(Instring,"^",6)           ;RepTime
    s:(RepTime'="")&(RepTime[":") RepTime=$zth(RepTime,2)
    s PLIST(6)=RepTime
    s:PLIST(6)="" PLIST(6)=$p($h,",",2)
    i RowId="" d
    .&sql(Insert into DHC_WMR_FrontPage values :PLIST())
    e  d
    .&sql(Update DHC_WMR_FrontPage values :PLIST() where Rowid=:RowId)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

//根据编目信息取本次就诊的入院日期

ClassMethod InDate(FrontPageRowId)
{
    ;n (FrontPageRowId)
    s Indate=""
    q:FrontPageRowId="" Indate
    q:'$d(^DHCWMRFP(FrontPageRowId)) Indate     ;编目首页
    s VolumeRowId=$p($g(^DHCWMRFP(FrontPageRowId)),"^",1)
    q:VolumeRowId="" Indate  ;卷 
    //Modified By LiYang 2008-12-17 生成索引的时候可以处理历史卷
    set VolInfo = $g(^DHCWMRVOL(VolumeRowId))
    set HistoryAdmID = $p(VolInfo,"^",3)
    i HistoryAdmID'=""  d
    .s HistoryAdm=$g(^DHCWMRHISADM(+HistoryAdmID))
    .s:$p(HistoryAdm,"^",2)'="" Indate=$p(HistoryAdm,"^",2)
    quit:Indate'="" Indate
    
    q:'$d(^DHCWMRVOL(VolumeRowId,"ADM")) Indate ;DHC_WMR_VolAdm
    s FirstSub=$o(^DHCWMRVOL(VolumeRowId,"ADM",0))
    q:FirstSub="" Indate
    s FirstAdm=$g(^DHCWMRVOL(VolumeRowId,"ADM",FirstSub))
    q:FirstAdm="" Indate
    q:'$d(^PAADM(FirstAdm)) Indate
    s Indate=$p($g(^PAADM(FirstAdm)),"^",6)     ;AdmDate
    q Indate
}

//根据编目信息取本次就诊的出院日期

ClassMethod OutDate(FrontPageRowId)
{
    n (FrontPageRowId)
    s Outdate=""
    q:FrontPageRowId="" Outdate
    q:'$d(^DHCWMRFP(FrontPageRowId)) Outdate     ;编目首页
    s VolumeRowId=$p($g(^DHCWMRFP(FrontPageRowId)),"^",1)
    q:VolumeRowId="" Outdate                     ;卷
    //Modified By LiYang 2008-12-17 生成索引的时候可以处理历史卷
    set VolInfo = $g(^DHCWMRVOL(VolumeRowId))
    set HistoryAdmID = $p(VolInfo,"^",3)
    i HistoryAdmID'=""  d
    .s HistoryAdm=$g(^DHCWMRHISADM(+HistoryAdmID))
    .s:$p(HistoryAdm,"^",6)'="" Outdate=$p(HistoryAdm,"^",6)
    quit:Outdate'="" Outdate
        
    q:'$d(^DHCWMRVOL(VolumeRowId,"ADM")) Outdate ;DHC_WMR_VolAdm
    s NextSub=$o(^DHCWMRVOL(VolumeRowId,"ADM",""),-1)
    q:NextSub="" Outdate
    s NextAdm=$g(^DHCWMRVOL(VolumeRowId,"ADM",NextSub))
    q:NextAdm="" Outdate
    q:'$d(^PAADM(NextAdm)) Outdate
    s Outdate=$p($g(^PAADM(NextAdm)),"^",17)       ;DischgDate
    q Outdate
}

//根据编目信息取编目日期

ClassMethod CodeDate(FrontPageRowId)
{
    n (FrontPageRowId)
    s Repdate=""
    q:FrontPageRowId="" Repdate
    q:'$d(^DHCWMRFP(FrontPageRowId)) Repdate     ;编目首页
    s Repdate=$p($g(^DHCWMRFP(FrontPageRowId)),"^",4)     ;RepDate
    q Repdate
}

//Create By LiYang 2008-12-24 手工生成住院日期索引，可以指定生成索引的范围

//FromID： DHC_WMR_FPICD表的RowID，起始ID

//ToID: DHC_WMR_FPICD表的RowID，结束ID

//$$GenerateInDateIndex^DHCWMRFrontPage(504395,504408)

ClassMethod GenerateInDateIndex(FromID, ToID)
{
	n (FromID, ToID)    
	set intID = FromID
	set strData = ""
	while 1
	{
		set intID = $o(^DHCWMRFPICD(intID))
		quit:(intID="")!(intID>ToID)
		set strData = $g(^DHCWMRFPICD(intID))
		set FrontPageID = $p(strData, "^", 1)
		set ICDDr = $p(strData, "^", 2)
		set ItemType = $p(strData, "^", 10)
		set date = ..InDate(FrontPageID)
		continue:(FrontPageID="")!(ICDDr="")!(ItemType="")!(date="")
		set ^DHCWMRFPICD(0,"InDate",date,ItemType,ICDDr,intID)=""
		w !,FrontPageID_"   "_date_"   "_ItemType_"  "_ICDDr_"  "_intID
		
	}
	quit ""
}

//Create By LiYang 2008-12-24 手工生成出院日期索引，可以指定生成索引的范围

//FromID： DHC_WMR_FPICD表的RowID，起始ID

//ToID: DHC_WMR_FPICD表的RowID，结束ID

//$$GenerateInDateIndex^DHCWMRFrontPage(504395,504408)

ClassMethod GenerateOutDateIndex(FromID, ToID)
{
	n (FromID, ToID)    
	set intID = FromID
	set strData = ""
	while 1
	{
		set intID = $o(^DHCWMRFPICD(intID))
		quit:(intID="")!(intID>ToID)
		set strData = $g(^DHCWMRFPICD(intID))
		set FrontPageID = $p(strData, "^", 1)
		set ICDDr = $p(strData, "^", 2)
		set ItemType = $p(strData, "^", 10)
		set date = ..OutDate(FrontPageID)
		continue:(FrontPageID="")!(ICDDr="")!(ItemType="")!(date="")
		set ^DHCWMRFPICD(0,"OutDate",date,ItemType,ICDDr,intID)=""
		w !,FrontPageID_"   "_date_"   "_ItemType_"  "_ICDDr_"  "_intID
		
	}
	quit ""
}

ClassMethod GetFrontPage(Id)
{
	n (Id)
	s ret=""
	q:'$d(^DHCWMRFP(Id)) ret
	s ret=$g(^DHCWMRFP(Id))
	/*
	s RepUserDr=+$p(ret,"^",3)
	s:RepUserDr'=0 RepUser=##class(web.DHCWMRMedBaseCtl).GetUsrStr(RepUserDr)
	s:$g(RepUser)'="" $p(ret,"^",3)=$tr(RepUser,"^","/")
	*/
	s ret=Id_"^"_ret
	q ret
}

//通过卷ID取得首页信息(最后一卷)

//2008-5-9 by liyang

ClassMethod GetFrontPageByVolumeID(VolID)
{
	n (VolID)	
	s ret="", id=""
	s id=$o(^DHCWMRFP(0,"VolumeDr",VolID,""),-1)
	q:id="" ""
	q ..GetFrontPage(id)
}

/// 7.1 病案首页诊断与手术 DHC_WMR_FPICD
/// debug:w ##Class(web.DHCWMRFrontPageCtl).UpdateFPICD("^9^7713^81^^^^^^^47^1^238^^149")
ClassMethod UpdateFPICD(Instring)
{
	n (Instring)
	s ^CacheTemp("UpdateFPICD")=Instring
    s RowId=$p(Instring,"^",1)             ;RowId
    s PLIST(2)=+$p(Instring,"^",2)          ;FrontPageDr         
    s PLIST(3)=+$p(Instring,"^",3)          ;ICDDr       
    s PLIST(4)=+$p(Instring,"^",4)          ;Result     
    s PLIST(5)=+$p(Instring,"^",5)          ;Operator   
    s PLIST(6)=+$p(Instring,"^",6)          ;AssistantDr1
    s PLIST(7)=+$p(Instring,"^",7)          ;AssistantDr2      
    s PLIST(8)=+$p(Instring,"^",8)          ;NarcosisType      
    s PLIST(9)=+$p(Instring,"^",9)         ;NarcosisDoctorDr   
    s PLIST(10)=+$p(Instring,"^",10)          ;CloseUp  
    s PLIST(11)=+$p(Instring,"^",11)          ;ItemTypeDr
    s PLIST(12)=+$p(Instring,"^",12)          ;Pos  
    s PLIST(13)=$p(Instring,"^",13)          ;ResumeText
    s PLIST(14)=$p(Instring,"^",14)          ;OperDate
    s:PLIST(14)["-" PLIST(14)=+$zdh(PLIST(14),3)
    s:PLIST(14)["/" PLIST(14)=+$zdh(PLIST(14),4)
    s:PLIST(14)="" PLIST(14)=$p($h,",",1)  ;wangcs 2012-10-12 日期为空取当前日期
    s PLIST(15)=$p(Instring,"^",15)          ;FPICDTypeDr   add by wuqk 2008-05-07
    s PLIST(16)=$p(Instring,"^",16)          ;SrcType
    s PLIST(17)=$p(Instring,"^",17)          ;Text1
    s PLIST(18)=$p(Instring,"^",18)          ;Text2
    s PLIST(19)=$p(Instring,"^",19)          ;Text3
    s PLIST(20)=$p(Instring,"^",20)          ;Text4
    
    b ;tt
    i RowId="" d
    .&sql(Insert into SQLUser.DHC_WMR_FPICD values :PLIST())
    e  d
    .&sql(Update SQLUser.DHC_WMR_FPICD values :PLIST() where Rowid=:RowId)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetFPICD(Id)
{
	n (Id)
	s ret=""
	q:'$d(^DHCWMRFPICD(Id)) ret
	s ret=$g(^DHCWMRFPICD(Id))
	s ret=Id_"^"_ret
	q ret
}

/// 7.2 病案首页附加项目 DHC_WMR_FPExtra
ClassMethod UpdateFPExtra(Instring)
{
	n (Instring)
    s RowId=$p(Instring,"^",1)             ;RowId
    s PLIST(2)=+$p(Instring,"^",2)         ;FrontPageDr 
    s PLIST(3)=+$p(Instring,"^",3)         ;ItemId 
    s PLIST(4)=$p(Instring,"^",4)          ;ItemValue 
    s PLIST(5)=$p(Instring,"^",5)          ;Pos    
    
    i RowId="" d
    .&sql(Insert into DHC_WMR_FPExtra values :PLIST())
    e  d
    .&sql(Update DHC_WMR_FPExtra values :PLIST() where Rowid=:RowId)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

/// 7.1 病案首页诊断与手术 DHC_WMR_FPICD
ClassMethod DeleteFPICD(RowId)
{
	n (RowId)
    &sql(Delete from DHC_WMR_FPICD where Rowid=:RowId)
    q SQLCODE
}

ClassMethod GetFPExtra(Id)
{
	n (Id)
	s ret=""
	q:'$d(^DHCWMRFPE(Id)) ret
	s ret=$g(^DHCWMRFPE(Id))
	/*
	s FrontPageDr=+$p(ret,"^",1)
	s:FrontPageDr'=0 FrontPage=$tr($g(^DHCWMRFP(FrontPageDr)),"^","/")
	s:$g(FrontPage)'="" $p(ret,"^",1)=FrontPageDr_"/"_FrontPage
	s ItemDr=+$p(ret,"^",2)
	s:ItemDr'=0 Item=$tr($g(^DHCWMRFPIDIC(ItemDr)),"^","/")
	s:$g(Item)'="" $p(ret,"^",2)=ItemDr_"/"_Item
	*/
	s ret=Id_"^"_ret
	q ret
}

/// *****************************************************************
/// 事务           :  病案编目
/// by wuqk 2008-01
/// 入参           ：
/// DelICDStr      ： 需要删除的ICD信息,$c(1)分隔(DHC_WMR_FPICD.Rowid_$c(1)_DHC_WMR_FPICD.Rowid)
/// FrontPage      ： DHC_WMR_FrontPage
/// ICDList        ： DHC_WMR_FPICD,$c(1)分隔
/// ExtraList      ： DHC_WMR_FPExtra,$c(1)分隔
/// 返回值         ： ret=FrontPageRowid 成功    ret<0 失败
/// debug: w ##Class(web.DHCWMRFrontPageCtl).Coding("","9^47^^10^2011-01-18^15:46","^^7722^81^^^^^^^47^1^238^^149","^^7722^81^^^^^^^47^1^238^^149")
/// *****************************************************************
ClassMethod Coding(DelICDStr, FrontPage, ICDList, ExtraList)
{
	n (DelICDStr,FrontPage,ICDList,ExtraList)
	set ^CacheTemp("Coding")=DelICDStr_","_FrontPage_","_ICDList_","_ICDList
	s ret=-1
	q:(FrontPage="")!(ICDList="") ret
	
	Tstart
	
	s ret=-2
	s flag=0          ;Delete ICD List
	if DelICDStr'="" {
		s DelLen=$l(DelICDStr,$c(1))
	    f index=1:1:DelLen q:flag<0  d
	    .s ICDRowid=+$p(DelICDStr,$c(1),index)
	    .q:ICDRowid'>0
	    .s flag=..DeleteFPICD(ICDRowid)
		}
	i flag<0 TRollBack
	q:flag<0 ret
	 
	s ret=-3
	s flag=0          ;Update FrontPage
	s flag=..UpdateFrontPage(FrontPage)
	i flag<0 TRollBack
	q:flag<0 ret
	s FrontPageRowid=+flag
	 
	s ret=-4
	s flag=0          ;Update FPICD
	s ICDLen=$l(ICDList,$c(1))
	f index=1:1:ICDLen q:flag<0  d
	.s ICDStr=$p(ICDList,$c(1),index)
	.q:ICDStr=""
	.s $p(ICDStr,"^",2)=FrontPageRowid
	.b
	.s flag=..UpdateFPICD(ICDStr)
	i flag<0 TRollBack
	q:flag<0 ret
	 
	s ret=-5
	s flag=0          ;Update FPExtra
	if ExtraList'="" {
	   s ExtLen=$l(ExtraList,$c(1))
	   f index=1:1:ExtLen q:flag<0  d
	   .s ExtStr=$p(ExtraList,$c(1),index)
	   .q:ExtStr=""
	   .s $p(ExtStr,"^",2)=FrontPageRowid
	   .s flag=..UpdateFPExtra(ExtStr)
	   i flag<0 TRollBack
	   q:flag<0 ret
	}
	
	TCommit
	s ret=FrontPageRowid
	q ret
}

}
