Import SQLUser

Class web.DHCWMRICDCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 118;

/// 1 ICD字典版本 DHC_WMR_ICDVersion
ClassMethod UpdateVersion(Instring)
{
	n (Instring)
    s VersionRowId=$p(Instring,"^",1)      ;RowId
    s PLIST(2)=$p(Instring,"^",2)          ;Code           
    s PLIST(3)=$p(Instring,"^",3)          ;Description         
    s PLIST(4)=$p(Instring,"^",4)          ;ItemTypeDr
    s PLIST(5)=$s($p(Instring,"^",5)["Y":"Y",1:"N")          ;IsActive   
    s PLIST(6)=$p(Instring,"^",6)          ;ResumeText
    i VersionRowId="" d
    .&sql(Insert into DHC_WMR_ICDVersion values :PLIST())
    e  d
    .&sql(Update DHC_WMR_ICDVersion values :PLIST() where Rowid=:VersionRowId)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetVersion(Id)
{
	n (Id)
	s ret=""
	q:'$d(^DHCWMRICDV(Id)) ret
	s ret=$g(^DHCWMRICDV(Id))
	/*
	s ItemTypeDr=+$p(ret,"^",3)
	s:ItemTypeDr'=0 ItemType=$tr($g(^DHCWMRRDIC(ItemTypeDr)),"^","/")
	s:$g(ItemType)'="" $p(ret,"^",3)=ItemTypeDr_"/"_ItemType
	*/
	s ret=Id_"^"_ret
	q ret
}

/// 2 ICD字典 DHC_WMR_ICDDx
/// 维护ICD字典并在别名表建两条索引（添加两条数据）
ClassMethod UpdateICDDxAlias(InStr, Alias)
{
	n (InStr,Alias)
	s ret=-1
	s tmpId=$p(InStr,"^",1)
	s tmpCode=$p(InStr,"^",2)
	s tmpAlias=Alias
	q:(tmpId="")&&(tmpCode="") ret
	q:(tmpId="")&&(tmpAlias="") ret
	
	Tstart
	s ret=-2
	s flg=..UpdateICDDx(InStr)
	i flg<0 TRollBack
	q:flg<0 ret
	s tmpDxId=flg
	
	s ret=-3
	i tmpId="" d                         //ICD编码建索引
	.s tmp="^"_tmpDxId_"^"_tmpCode
	.s flg=..UpdateICDAlias(tmp)
	i flg<0 TRollBack
	q:flg<0 ret
	
	s ret=-4
	i tmpId="" d                         //拼音码建索引
	.s tmp="^"_tmpDxId_"^"_tmpAlias
	.s flg=..UpdateICDAlias(tmp)
	i flg<0 TRollBack
	q:flg<0 ret
	
	TCommit
	s ret=1
	q ret
}

ClassMethod UpdateICDDx(Instring)
{
	n (Instring)
    s RowId=$p(Instring,"^",1)             ;RowId
    s PLIST(2)=$p(Instring,"^",2)          ;ICD           
    s PLIST(3)=$p(Instring,"^",3)          ;ICD1         
    s PLIST(4)=$p(Instring,"^",4)          ;Name     
    s PLIST(5)=$p(Instring,"^",5)          ;Version   
    s PLIST(6)=$p(Instring,"^",6)          ;ResumeText
    s PLIST(7)=$s($p(Instring,"^",7)["Y":"Y",1:"N")          ;IsActive
    i RowId="" d
    .&sql(Insert into DHC_WMR_ICDDx values :PLIST())
    e  d
    .&sql(Update DHC_WMR_ICDDx values :PLIST() where Rowid=:RowId)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetICDDx(Id)
{
	n (Id)
	s ret=""
	q:Id="" ret
	q:'$d(^DHCWMRICD(Id)) ret
	s ret=$g(^DHCWMRICD(Id))
	/*
	s VersionDr=+$p(ret,"^",4)
	s:VersionDr'=0 Version=$tr($g(^DHCWMRICD(VersionDr)),"^","/")
	s:$g(Version)'="" $p(ret,"^",4)=VersionDr_"/"_Version
	*/
	s ret=Id_"^"_ret_"^1" //Modified By LiYang 2009-07-30  增加类别字段
	q ret
}

/// 3 ICD别名 DHC_WMR_ICDAlias
ClassMethod UpdateICDAlias(Instring)
{
	n (Instring)
    s RowId=$p(Instring,"^",1)             ;RowId
    s PLIST(2)=+$p(Instring,"^",2)         ;ICDDxDr
    q:PLIST(2)=0 -1
    s PLIST(3)=$p(Instring,"^",3)          ;Alias
    i RowId="" d
    .&sql(Insert into DHC_WMR_ICDAlias values :PLIST())
    e  d
    .&sql(Update DHC_WMR_ICDAlias values :PLIST() where Rowid=:RowId)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetICDAlias(Id)
{
	n (Id)
	s ret=""
	q:'$d(^DHCWMRICDA(Id)) ret
	s ret=$g(^DHCWMRICDA(Id))
	/*
	s ICDDxDr=+$p(ret,"^",1)
	s:ICDDxDr'=0 ICDDx=$tr($g(^DHCWMRICDA(ICDDxDr)),"^","/")
	s:$g(ICDDx)'="" $p(ret,"^",1)=ICDDxDr_"/"_ICDDx
	*/
	s ret=Id_"^"_ret
	q ret
}

/// 4 ICD词典注释 DHC_WMR_ICDExplain
ClassMethod UpdateICDExplain(Instring)
{
	n (Instring)
    s RowId=$p(Instring,"^",1)             ;RowId
    s PLIST(2)=$p(Instring,"^",2)          ;Code           
    s PLIST(3)=$p(Instring,"^",3)          ;Description    
    s PLIST(4)=$s($p(Instring,"^",4)["Y":"Y",1:"N")          ;IsActive   
    s PLIST(5)=$p(Instring,"^",5)          ;ResumeText
    i RowId="" d
    .&sql(Insert into DHC_WMR_ICDExplain values :PLIST())
    e  d
    .&sql(Update DHC_WMR_ICDExplain values :PLIST() where Rowid=:RowId)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetICDExplain(Id)
{
	n (Id)
	s ret=""
	q:'$d(^DHCWMRICDE(Id)) ret
	s ret=$g(^DHCWMRICDE(Id))
	s ret=Id_"^"_ret
	q ret
}

/// 通过拼音码查询诊断信息
/// ret="{'total':'"_count_"','record':["_record_"]}"
/// record="{id:"_"'"_id_"',code:'"_code_"',desc:'"_desc_"',Alias:'"_Alias_"'}"
/// Alias  别名
/// ICDTy  ICD类型代码(D--诊断 O--手术)
/// w ##class(web.DHCWMRICDCtl).GetICDDxByAlias(Alias, ICDTy)
ClassMethod GetICDDxByAlias(Alias, ICDTy)
{
	n (Alias,ICDTy)
	s ret="",count=0,record=""
	s ret="{'total':'"_count_"','record':["_record_"]}"
	
	q:Alias="" ret
	s ICDSetting=""
	
	s:ICDTy="D" ICDSetting=##class(web.DHCWMRMedBaseICD).GetDHCWMRICDSettingD()
	s:ICDTy="O" ICDSetting=##class(web.DHCWMRMedBaseICD).GetDHCWMRICDSettingO()
	q:ICDSetting="" ret
	
	s tmpICDString=""
	s:ICDSetting=0 tmpICDString=..QueryICDDx(Alias, ICDTy)
	if ICDSetting=1 {
		i ICDTy="D" d
		.s tmpICDString=##class(web.DHCWMRMedBaseICD).QueryMRCICD(Alias,"")
		.s tmpDSYM=##class(web.DHCWMRMedBaseICD).QueryDSYM(Alias) //Modified By LiYang 2009-07-30 增加查询中医诊断
		.s:tmpICDString'="" tmpICDString=tmpICDString_$c(1)
		.s tmpICDString=tmpICDString_tmpDSYM
		s:ICDTy="O" tmpICDString=##class(web.DHCWMRMedBaseICD).QueryORCOper(Alias,"")
		}
	s tmpICDString=..ReplaceString(tmpICDString, "'", "\'") //Modified By LiYang 2009-3-26
	s Len=$l(tmpICDString,$c(1))
	f i=1:1:Len  d
	.s tmpICD=$p(tmpICDString,$c(1),i)
	.q:tmpICD=""
	.d xGetMyICDDx
	s record=$e(record,2,$l(record))
	s ret="{'total':'"_count_"','record':["_record_"]}"
	q ret

xGetMyICDDx
    s ICDRowid=$p(tmpICD,"^",1)
    s ICDCode=$p(tmpICD,"^",2)
    s ICDDesc=$p(tmpICD,"^",4)
    s ICD1=$p(tmpICD,"^",3)
    s SrcType=$p(tmpICD,"^",8) //Add By LiYang 2009-07-30 类别
    s ICDAlias=""
	s tmprecord="{id:"_"'"_ICDRowid_"',code:'"_ICDCode_"',desc:'"_ICDDesc_"',Alias:'"_ICDAlias_"',SrcType:'"_SrcType_"'}"
	s record=record_","_tmprecord
	s count=count+1
	q
}

ClassMethod GetICDDxByAliasold(Alias, ICDTy)
{
	n (Alias,ICDTy)
	s ret="",count=0,record=""
	s ret="{'total':'"_count_"','record':["_record_"]}"
	
	q:Alias="" ret
	s Alias="Z"_..ALPHAUP(Alias)
	;^DHCWMRICDA(0,"Alias",$$ALPHAUP({Alias}),{ICDDxDr},{RowId})
	s tmpAlias=Alias
	i $d(^DHCWMRICDA(0,"Alias",tmpAlias)) d xGetICDDx
	f  s tmpAlias=$o(^DHCWMRICDA(0,"Alias",tmpAlias)) q:(tmpAlias="")||($e(tmpAlias,1,$l(Alias))'=Alias)  d
	.d xGetICDDx
	s record=$e(record,2,$l(record))
	s ret="{'total':'"_count_"','record':["_record_"]}"
	q ret
	
xGetICDDx
	s ICDRowid=0
	f  s ICDRowid=$o(^DHCWMRICDA(0,"Alias",tmpAlias,ICDRowid)) q:ICDRowid=""  d
	.q:'$d(^DHCWMRICD(ICDRowid))
	.s tmpICD=$g(^DHCWMRICD(ICDRowid))
	.S tmpICDTy=$p($g(^DHCWMRICDV(+$p(tmpICD,"^",4))),"^",3)
	.q:(ICDTy'="")&&(ICDTy'=tmpICDTy)
	.s cId=$o(^DHCWMRICDA(0,"Alias",tmpAlias,ICDRowid,0))
	.s cAlias=$p($g(^DHCWMRICDA(+cId)),"^",2)
	.s tmprecord="{id:"_"'"_ICDRowid_"',code:'"_$p(tmpICD,"^",1)_"',desc:'"_$p(tmpICD,"^",3)_"',Alias:'"_cAlias_"'}"
	.s record=record_","_tmprecord
	.s count=count+1
	
	/*
	n (Alias,ICDTy)
	s ret="",count=0,record=""
	s ret="{'total':'"_count_"','record':["_record_"]}"
	
	q:Alias="" ret
	s Alias=..ALPHAUP(Alias)
	;^DHCWMRICDA(0,"Alias",$$ALPHAUP({Alias}),{ICDDxDr},{RowId})
	s tmpAlias=$o(^DHCWMRICDA(0,"Alias",Alias))
	f  s tmpAlias=$o(^DHCWMRICDA(0,"Alias",tmpAlias)) q:(tmpAlias="")||(tmpAlias'[Alias)  d
	.s ICDRowid=0
	.f  s ICDRowid=$o(^DHCWMRICDA(0,"Alias",tmpAlias,ICDRowid)) q:ICDRowid=""  d
	..q:'$d(^DHCWMRICD(ICDRowid))
	..s tmpICD=$g(^DHCWMRICD(ICDRowid))
	..S tmpICDTy=$p($g(^DHCWMRICDV(+$p(tmpICD,"^",4))),"^",3)
	..q:(ICDTy'="")&&(ICDTy'=tmpICDTy)
	..s cId=$o(^DHCWMRICDA(0,"Alias",tmpAlias,ICDRowid,0))
	..s cAlias=$p($g(^DHCWMRICDA(+cId)),"^",2)
	..s tmprecord="{id:"_"'"_ICDRowid_"',code:'"_$p(tmpICD,"^",1)_"',desc:'"_$p(tmpICD,"^",3)_"',Alias:'"_cAlias_"'}"
	..s record=record_","_tmprecord
	..s count=count+1
	..//w tmprecord_"----"_$p($g(^DHCWMRICDV(+$p(tmpICD,"^",4))),"^",3),!
	s record=$e(record,2,$l(record))
	s ret="{'total':'"_count_"','record':["_record_"]}"
	q ret
	*/
}

/// 把字符串转换为大写
ClassMethod ALPHAUP(Alias)
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$ALPHAUP^SSUTIL4(Alias)
	zn CurrentNS
	q ret
}

/// 根据别名和类型查询DHC_WMR_ICDDx
ClassMethod QueryICDDx(Alias, ICDTy)
{
	;n (Alias,ICDTy)
	k ^CacheTemp($zn,$j)
	s ret=""
	q:Alias="" ret
	set MaxRows = 500 //Add By LiYang 2008-08-17 解决字符串超长问题，没必要传出来那么多字典项目
	set Counter = 0
	s Alias="Z"_$$ALPHAUP^SSUTIL4(Alias)

	//Set $ZT="MyError"
	set ret=$$GetICDByAlias(Alias, ICDTy)
	set AliasCaption = Alias
	
	while (1)
	{
		set AliasCaption = $o(^DHCWMRICDA(0,"Alias", AliasCaption))
		quit:(AliasCaption="")!(Counter>=MaxRows)!(AliasCaption'[Alias)
		set DicInfo=$$GetICDByAlias(AliasCaption, ICDTy)
		if (DicInfo '= "")
		{
			set:ret'="" ret=ret_$c(1)
			set ret = ret _ DicInfo
			set Counter = Counter + 1
		}
	}
	quit ret
	
GetICDByAlias(MyAlias,ICDTy) //2008-09-11 Modified By Liyang  修改问题：取出的字典项不全
	n (MyAlias,ICDTy)
	set ret = ""
	set DicID = ""
	do
	{
		set DicID = $o(^DHCWMRICDA(0,"Alias", MyAlias, DicID))
		if (DicID '= "")
		{
			set ICDDic=..GetICDDx(DicID)
			//set ICDDic=..ReplaceString(ICDDic, "'", "\'")  //Modified BY LiYang 2008-09-16  解决JSON串中出现单引号问题 ,用转义符替换原有的单引号。避免错误
			set VersionInfo=$g(^DHCWMRICDV(+$p(ICDDic,"^",5)))   
			if ($p(VersionInfo,"^",3)=ICDTy)&&($p(VersionInfo,"^",4)="Y")&&($p(ICDDic,"^",7)="Y")
			{
				set:ret'="" ret=ret_$c(1)
				set ret = ret _ ICDDic
			}			
		}
	}while(DicID '= "")
	quit ret
	/*
	i $d(^DHCWMRICDA(0,"Alias",Alias)) d
	.s tmp=$$GetICDByAlias(Alias,ICDTy)
	.s:ret'="" ret=ret_$c(1)_tmp
	.s:ret="" ret=tmp
	.;s ret=ret_tmp_$c(1)
	s tmpAilas=Alias
	f  s tmpAilas=$o(^DHCWMRICDA(0,"Alias",tmpAilas)) q:(tmpAilas="")  d  ;!(tmpAilas'[Alias)
	.s tmp=$$GetICDByAlias(tmpAilas,ICDTy)
	.s:ret'="" ret=ret_$c(1)_tmp
	.s:ret="" ret=tmp
	.q:$l(ret,$c(1))>MaxRows
	k ^CacheTemp($zn,$j)
	q ret
GetICDByAlias(MyAlias,ICDTy)
    n (MyAlias,ICDTy)
    s MyRet=""
    s tmpRowid=0
    f  s tmpRowid=$o(^DHCWMRICDA(0,"Alias",MyAlias,tmpRowid)) q:tmpRowid=""  d
    .;w !,tmpRowid
    .q:$d(^CacheTemp($zn,$j,tmpRowid))
    .s ^CacheTemp($zn,$j,tmpRowid)=""
    .s tmp=$g(^DHCWMRICD(tmpRowid))
    .S tmpICDTy=$p($g(^DHCWMRICDV(+$p(tmp,"^",4))),"^",3)
    .q:(ICDTy'="")&&(ICDTy'=tmpICDTy)
    .s tmpStr=tmpRowid_"^"_tmp
    .s:MyRet'="" MyRet=MyRet_$c(1)_tmpStr
    .s:MyRet="" MyRet=tmpStr
    q MyRet*/
MyError
   Quit ret
}

/// 字符替换
ClassMethod ReplaceString(Str, OldStr, NewStr)
{
	n (Str, OldStr, NewStr)
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

}
