Import SQLUser

/// 取HIS诊断和手术ICD字典查询
/// MRC_ICDDx
/// ORC_Operation
Class web.DHCWMRMedBaseICD Extends (%Library.RegisteredObject, websys.Abstract) [ Not ProcedureBlock ]
{

Parameter BUILD = 186;

/// ------add by wuqk 2008-05-07------
/// 设置当前医院病案编目所用诊断和手术字典的数据来源
/// 诊断字典的数据来源
/// ^DHCWMRICDSetting("D")
/// 0：取DHC_WMR_ICDDx
/// 1：取MRC_ICDDx
/// 
/// 手术字典的数据来源
/// ^DHCWMRICDSetting("O")
/// 0：取DHC_WMR_ICDDx
/// 1：取ORC_Operation
/// d ##Class(web.DHCWMRMedBaseICD).GetDHCWMRICDSettingD()
ClassMethod SetDHCWMRICDSetting()
{
	set ^DHCWMRICDSetting("D")=1
	set ^DHCWMRICDSetting("O")=1
	q
}

/// 取诊断字典设置
ClassMethod GetDHCWMRICDSettingD()
{
	s ret=1
	If ('$d(^DHCWMRICDSetting("D"))){
		s ^DHCWMRICDSetting("D")=##Class(web.DHCWMRDictionaryCtl).GetDataByTypeAndCode("ICDAndCM3Setting","ICDSetting")	
	}
	s ret=+$g(^DHCWMRICDSetting("D"))
	q ret
}

/// 取手术字典设置
ClassMethod GetDHCWMRICDSettingO()
{
	s ret=1
	If ('$d(^DHCWMRICDSetting("O"))){
		s ^DHCWMRICDSetting("O")=##Class(web.DHCWMRDictionaryCtl).GetDataByTypeAndCode("ICDAndCM3Setting","CM3Setting")	
	}
	s ret=+$g(^DHCWMRICDSetting("O"))
	q ret
}

/// 取HIS诊断字典串
ClassMethod GetMRCICDDX(RowId)
{
	n (RowId)
	s ret=""
	q:RowId="" ret
	q:'$d(^MRC("ID",RowId)) ret
	s tmp=$g(^MRC("ID",RowId))
	s Rowid=RowId
    s ICD=$p(tmp,"^",4)				//MRCID_ICD9CM_Code
    s ICD1=$p(tmp,"^",1)			//MRCID_Code
    s MRCIDICD9Map=$p(tmp,"^",35) 	//MRCID_ICD9_Map add by liuxuefeng 2010-08-13安徽省立医院南区存储诊断副码
    s HospCode=##class(web.DHCWMRMedBase01).GetDefaultHospCode()
    s:(HospCode="ChangChun_JDSY") ICD1=$p(tmp,"^",43)
    s:(HospCode="AnHui_SLYY_NQ")&&(MRCIDICD9Map'="") ICD=ICD_"/"_MRCIDICD9Map //add by liuxuefeng 2010-08-13安徽省立医院南区显示诊断副码
    s Name=$p(tmp,"^",2)
    s:ICD1'="" Name=Name_"["_ICD1_"]"
    s Verion=""
    s ResumeText=""
    s IsActive="Yes"
    s dFrom=+$p(tmp,"^",6)
    s dTo=+$p(tmp,"^",7)
    s dNow=+$h
    s:(dNow<dFrom)&(dFrom'=0) IsActive="No"
    s:(dNow>dTo)&(dTo'=0) IsActive="No"
    s ret=Rowid_"^"_ICD_"^"_ICD1_"^"_Name_"^"_Verion_"^"_ResumeText_"^"_IsActive_"^2" //Modified By LiYang 2009-07-30 SrcType 字典来源 
	q ret
}

/// 导入别名
/// w ##Class(web.DHCWMRMedBaseICD).ImportOperationAlias()
ClassMethod ImportOperationAlias()
{
 ;^ORC("OPER",{OPER_RowId})
 Set OpeRowID=0
 For {
	Set OpeRowID=$O(^ORC("OPER",OpeRowID))
	Quit:OpeRowID=""
	Set OpeObj=##Class(User.ORCOperation).%OpenId(OpeRowID)
	If ($IsObject(OpeObj)){
	  ;处理ICD编码
	  Set OpeCode=OpeObj.OPERCode          ;$P(^MRC("ID",MRCIDRowID),"^",4)
	  Set OpeName=OpeObj.OPERDesc          ;$P(^MRC("ID",MRCIDRowID),"^",2)
	  Set FromDate=OpeObj.OPERDateActiveFrom
	  Set ToDate=OpeObj.OPERActiveDateTo
	  Continue:(FromDate'="")&&(FromDate>+$h)
	  Continue:(ToDate'="")&&(ToDate<+$h)
	  ;^MRC("ID",0,"ALIAS",$$ALPHAUP({ALIAS_Text}),{MRC_ICDDx.MRCID_RowId},{ALIAS_Childsub}) 
	  Set OpeCode=$ZCVT("Z"_OpeCode,"U")
	  Do ..SaveOpeAlias(OpeObj,OpeCode)
	  ;b ;11
	  ;处理ICD名称
	  Set Len=$l(OpeName)
	  Set:OpeName["--" OpeName=$p(OpeName,"--",2)
	  For Ind=1:1:Len {
		  Set Text=$e(OpeName,Ind,Len)
		  Do ..SaveOpeAlias(OpeObj,Text)
		  ;b ;12
	  }
	  
	}
 }
}

ClassMethod SaveOpeAlias(MRCObj, Text)
{
	New (MRCObj,Text)
	Set MRCIDRowID=MRCObj.%Id(),ID=-1
	Set:Text["." Text=$tr(Text,".","")
	Set:Text[$c(11) Text=$tr(Text,$c(11),"")
	Set:Text[$c(13) Text=$tr(Text,$c(13),"")
	Set:Text[" " Text=$tr(Text," ","")
	Quit:(Text="")||(MRCIDRowID="") ID
	;If ($d(^ORC("OPER",0,"ALIAS",$ZCVT(Text,"U"),MRCIDRowID))){
		;Kill ^ORC("OPER",0,"ALIAS",$ZCVT(Text,"U"),MRCIDRowID)
		;Set Text="Z"_Text
	;}
	If ('$d(^ORC("OPER",0,"ALIAS",$ZCVT(Text,"U"),MRCIDRowID))){
	 Set ID=-1
	 ;^MRC("ID",{MRC_ICDDx.MRCID_RowId},"ALIAS",{ALIAS_Childsub})
	 Set ChildSub=$O(^ORC("OPER",MRCIDRowID,"ALIAS",""),-1)
	 Set ChildSub=+ChildSub+1
	 &SQL(insert into orc_operationalias (ALIAS_ParRef,ALIAS_Childsub,ALIAS_Text) values(:MRCIDRowID,:ChildSub,:Text))
	 
	Set ID=$p(%ROWID,$c(1))
	w MRCObj.OPERICD9Map_"  "_Text_" "_ID,!
	Quit ID
  }
}

/// 导入别名
/// w ##Class(web.DHCWMRMedBaseICD).ImportICDAlias()
ClassMethod ImportICDAlias()
{
 ;^MRC("ID",{MRCID_RowId})
 Set MRCIDRowID=0
 For {
	Set MRCIDRowID=$O(^MRC("ID",MRCIDRowID))
	Quit:MRCIDRowID=""
	Set MRCObj=##Class(User.MRCICDDx).%OpenId(MRCIDRowID)
	If ($IsObject(MRCObj)){
	  ;处理ICD编码
	  Set ICDCode=MRCObj.MRCIDICD9CMCode          ;$P(^MRC("ID",MRCIDRowID),"^",4)
	  Set ICDName=MRCObj.MRCIDDesc                ;$P(^MRC("ID",MRCIDRowID),"^",2)
	  Set FromDate=MRCObj.MRCIDDateActiveFrom
	  Set ToDate=MRCObj.MRCIDDateActiveTo
	  Continue:(FromDate'="")&&(FromDate>+$h)
	  Continue:(ToDate'="")&&(ToDate<+$h)
	  ;^MRC("ID",0,"ALIAS",$$ALPHAUP({ALIAS_Text}),{MRC_ICDDx.MRCID_RowId},{ALIAS_Childsub}) 
	  Do ..SaveAlias(MRCObj,ICDCode)
	  ;处理ICD名称
	  Set Len=$l(ICDName)
	  For Ind=1:1:Len {
		  Set Text=$e(ICDName,Ind,Len)
		  Do ..SaveAlias(MRCObj,Text)
	  }
	  
	}
 }
}

ClassMethod SaveAlias(MRCObj, Text)
{
	New (MRCObj,Text)
	Set MRCIDRowID=MRCObj.%Id(),ID=-1
	Set:Text["." Text=$tr(Text,".","")
	Set:Text[$c(11) Text=$tr(Text,$c(11),"")
	Set:Text[$c(13) Text=$tr(Text,$c(13),"")
	Set:Text[" " Text=$tr(Text," ","")
	Quit:(Text="")||(MRCIDRowID="") ID
	If ('$d(^MRC("ID",0,"ALIAS",$ZCVT(Text,"U"),MRCIDRowID))){
	 Set ID=-1
	 ;^MRC("ID",{MRC_ICDDx.MRCID_RowId},"ALIAS",{ALIAS_Childsub})
	 Set ChildSub=$O(^MRC("ID",MRCIDRowID,"ALIAS",""),-1)
	 Set ChildSub=+ChildSub+1
	 &SQL(insert into mrc_icdalias (ALIAS_ParRef,ALIAS_Childsub,ALIAS_Text) values(:MRCIDRowID,:ChildSub,:Text))
	 
	Set ID=$p(%ROWID,$c(1))
	w MRCObj.MRCIDICD9CMCode_"  "_Text_" "_ID,!
	Quit ID
  }
}

/// 取HIS手术字典串
ClassMethod GetORCOper(RowId)
{
	n (RowId)
	s ret=""
	q:RowId="" ret
	q:'$d(^ORC("OPER",RowId)) ret
	s tmp=$g(^ORC("OPER",RowId))
	s Rowid=RowId
    s ICD=$p(tmp,"^",21)          ;OPER_ICD9Map
    s ICD=..ReplaceStr(ICD)
    s ICD1=$p(tmp,"^",14)         ;OPER_ICD10
    s ICD1=..ReplaceStr(ICD1)
    s Name=$p(tmp,"^",2)
    s Name=..ReplaceStr(Name)
    s Verion=""
    s ResumeText=""
    s IsActive="Yes"
    s dFrom=+$p(tmp,"^",5)
    s dTo=+$p(tmp,"^",6)
    s dNow=+$h
    s:(dFrom'=0)&&(dNow<dFrom) IsActive="No"
    s:(dTo'=0)&&(dNow>dTo) IsActive="No"
    s ret=Rowid_"^"_ICD_"^"_ICD1_"^"_Name_"^"_Verion_"^"_ResumeText_"^"_IsActive_"^3" //Modified By LiYang 2009-07-30 SrcType 字典来源 
	q ret
}

ClassMethod ReplaceStr(OldStr) As %String
{
	new (OldStr)
	Set Ret=""
	;b:OldStr[$c(11,13,10,14,12,15,16,17)
	Set Ret=$tr(OldStr,$c(11),"")
	Set Ret=$tr(Ret,$c(13),"")
	Set Ret=$tr(Ret,$c(10),"")
	Set:Ret["'" Ret=$tr(Ret,"'","")
	Quit Ret
}

/// Add By LiYang 2009-07-30 查询中医字典
ClassMethod GetDSYM(ID)
{
	n (ID)
	q:ID="" ""
	s tmp=$g(^MRCEXP("DSYM",ID))
	s data=""
	s $p(data,"^",1)=ID
	s $p(data,"^",2)=$p(tmp,"^",1)
	s $p(data,"^",3)=""
	s $p(data,"^",4)=$p(tmp,"^",2)
	s $p(data,"^",5)=""
	s $p(data,"^",6)=""
	s $p(data,"^",7)=""
	s $p(data,"^",8)="4"  //Modified By LiYang 2009-07-30 SrcType 字典来源 
	q data
}

/// debug:w ##Class(web.DHCWMRMedBaseICD).SearchStr("股骨干骨折1","股骨干骨折")
ClassMethod SearchStr(str1 As %String, str2 As %String)
{
	New (str1,str2)
	Set Len=$l(str1)
	Set IndexPosition=0
	Set Ret=0,Ind=0
	For ii=1:1:Len {
		Set SubStr=$e(str1,ii,ii)
		Set Ind=$f(str2,SubStr,Ind)-1
		;b ;12
		Set:Ind=0 Ret=-1
		Set:Ind>IndexPosition IndexPosition=Ind
		Set:IndexPosition>Ind Ret=-1
		Quit:Ret'=0
	}
	Quit Ret
}

/// 根据别名和日期查询HIS诊断字典
/// debug:w ##Class(web.DHCWMRMedBaseICD).QueryMRCICD("性-离","")
ClassMethod QueryMRCICD(Alias, dDate)
{
	n (Alias,dDate)
	k ^CacheTemp($zn,$j)
	Set ^WanCS=Alias
	s ret="",SecodeAlias=""
	q:Alias="" ret
	s:Alias["-" SecodeAlias=$p(Alias,"-",2),Alias=$p(Alias,"-",1)
	;b ;2
	s Alias=$$ALPHAUP^SSUTIL4(Alias)
	s SecodeAlias=$$ALPHAUP^SSUTIL4(SecodeAlias)
	s:dDate["-" dDate=$zdh(dDate,3)
	s:dDate["/" dDate=$zdh(dDate,4)
	s:dDate="" dDate=+$h
	
	Set $ZT="MyICDError"
	
	i $d(^MRC("ID",0,"ALIAS",Alias))&&(SecodeAlias="") d
	.s tmp=$$GetMRCICDByAlias(Alias,dDate)
	.s:ret'="" ret=ret_$c(1)_tmp
	.s:ret="" ret=tmp
	.;s ret=ret_tmp_$c(1)
	;b ;11
	s tmpAilas=Alias
	f  s tmpAilas=$o(^MRC("ID",0,"ALIAS",tmpAilas)) q:(tmpAilas="")!(tmpAilas'[Alias)  d
	.q:(SecodeAlias'="")&&($e(tmpAilas,$l(Alias)+1,$l(tmpAilas))'[SecodeAlias)
	.;b ;11
	.s tmp=$$GetMRCICDByAlias(tmpAilas,dDate)
	.s:ret'="" ret=ret_$c(1)_tmp
	.s:ret="" ret=tmp
	k ^CacheTemp($zn,$j)
	q ret
GetMRCICDByRowId(MRCICDID,dDate)
    New (MRCICDID,dDate)
    Set Rtn=""
    
    Quit:$d(^CacheTemp($zn,$j,MRCICDID)) Rtn ;条件判断，不重复写入
    Set ^CacheTemp($zn,$j,MRCICDID)=""
    ;Set tmp=$g(^MRC("ID",MRCICDID))
    
    ;Set dFrom=+$p(tmp,"^",6)
    ;Set dTo=+$p(tmp,"^",7)
    ;Set dNow=dDate
    ;Quit:(dNow<dFrom)&(dFrom'=0) Rtn
    ;Quit:(dNow>dTo)&(dTo'=0) Rtn
    Set tmpICDStr=..GetMRCICDDX(MRCICDID)
    Set:Rtn'="" Rtn=Rtn_$c(1)_tmpICDStr
	Set:Rtn="" Rtn=tmpICDStr 
    
	Quit Rtn
  ;描述：增加按照诊断名称检索诊断
GetMRCICDByDesc(Desc,dDate)
    New (Desc,dDate)
    Set Rtn=""
    
    Set MRCICDID=0
    For {
	   Set MRCICDID=$O(^MRC("ID",0,"Desc",Desc,MRCICDID))
	   Quit:MRCICDID=""
	   Continue:$d(^CacheTemp($zn,$j,MRCICDID))   ;条件判断，不重复写入
       Set ^CacheTemp($zn,$j,MRCICDID)=""
       Set tmp=$g(^MRC("ID",MRCICDID))
        //q:(HospCode="ShenYang_YDYFY")&&($p(tmp,"^",27)'="Y")   //update by zf 20090713  MRCID_Valid 是否有效标记 “Y”作为编目手术的标记
       Set MRCIDCode=$p(tmp,"^",1)								//add by liuxuefeng 2010-08-13
       Set MRCIDCodeUp=$zcvt(MRCIDCode,"U")						//add by liuxuefeng 2010-08-13
       //.q:(HospCode="AnHui_SLYY_NQ")&&(MRCIDCodeUp["MZ")		//add by liuxuefeng 2010-08-13 安徽省立医院南区，过滤掉以MZ开头的门诊诊断
       Set dFrom=+$p(tmp,"^",6)
       Set dTo=+$p(tmp,"^",7)
       Set dNow=dDate
       Continue:(dNow<dFrom)&(dFrom'=0)
       Continue:(dNow>dTo)&(dTo'=0)
       Set tmpICDStr=..GetMRCICDDX(MRCICDID)
       Set:Rtn'="" Rtn=Rtn_$c(1)_tmpICDStr
	   Set:Rtn="" Rtn=tmpICDStr 
	}
	Quit Rtn
GetMRCICDByAlias(MyAlias,dDate)
    n (MyAlias,dDate)
    s MyRet=""
    s HospCode=##class(web.DHCWMRMedBase01).GetDefaultHospCode()
    s tmpRowid=0
    f  s tmpRowid=$o(^MRC("ID",0,"ALIAS",MyAlias,tmpRowid)) q:tmpRowid=""  d
    .q:$d(^CacheTemp($zn,$j,tmpRowid))   ;条件判断，不重复写入
    .s ^CacheTemp($zn,$j,tmpRowid)=""
    .s tmp=$g(^MRC("ID",tmpRowid))
    .//q:(HospCode="ShenYang_YDYFY")&&($p(tmp,"^",27)'="Y")   //update by zf 20090713  MRCID_Valid 是否有效标记 “Y”作为编目手术的标记
    .s MRCIDCode=$p(tmp,"^",1)								//add by liuxuefeng 2010-08-13
    .s MRCIDCodeUp=$zcvt(MRCIDCode,"U")						//add by liuxuefeng 2010-08-13
    .q:(HospCode="AnHui_SLYY_NQ")&&(MRCIDCodeUp["MZ")		//add by liuxuefeng 2010-08-13 安徽省立医院南区，过滤掉以MZ开头的门诊诊断
    .s dFrom=+$p(tmp,"^",6)
    .s dTo=+$p(tmp,"^",7)
    .s dNow=dDate
    .q:(dNow<dFrom)&(dFrom'=0)
    .q:(dNow>dTo)&(dTo'=0)
    .s tmpICDStr=..GetMRCICDDX(tmpRowid)
    .s:MyRet'="" MyRet=MyRet_$c(1)_tmpICDStr
	.s:MyRet="" MyRet=tmpICDStr
    q MyRet
MyICDError
   Quit ret
}

/// Add By LiYang 2009-07-30 查询中医字典
ClassMethod QueryDSYM(Code)
{
	n (Code)
	k ^CacheTemp($zn,$j)
	s ret=""
	q:Code="" ret
	s Code=$$ALPHAUP^SSUTIL4(Code)
	Set $ZT="MyICDError"
	i $d(^MRCEXP("DSYM",0,"Code",Code)) d
	.s id=$o(^MRCEXP("DSYM",0,"Code",Code,""))
	.s ret=..GetDSYM(id)
	.;s ret=ret_tmp_$c(1)
	s tmpCode=Code
	f  s tmpCode=$o(^MRCEXP("DSYM",0,"Code",tmpCode)) q:(tmpCode="")!(tmpCode'[Code)  d
	.s id="" f  s id=$o(^MRCEXP("DSYM",0,"Code",tmpCode,id)) q:id=""  d
	..s tmp=..GetDSYM(id)
	..s:ret'="" ret=ret_$c(1)_tmp
	..s:ret="" ret=tmp
	k ^CacheTemp($zn,$j)
	q ret
}

/// 根据别名和日期查询HIS手术字典
/// debug:w ##Class(web.DHCWMRMedBaseICD).QueryORCOper("5302","")
ClassMethod QueryORCOper(Alias, dDate)
{
	n (Alias,dDate)
	k ^CacheTemp($zn,$j)
	;Set ^Test=Alias
	s ret="",SecodeAlias=""
	q:Alias="" ret
	s:Alias["-" SecodeAlias=$p(Alias,"-",2),Alias=$P(Alias,"-",1)
	s Alias=$$ALPHAUP^SSUTIL4(Alias)
	s SecodeAlias=$$ALPHAUP^SSUTIL4(SecodeAlias)
	s:dDate["-" dDate=$zdh(dDate,3)
	s:dDate["/" dDate=$zdh(dDate,4)
	s:dDate="" dDate=+$h
	;Set ^Test=Alias_","_dDate
	Set:$ISVALIDNUM(Alias) Alias="Z"_Alias
	Set $ZT="MyOperError"
	;b ;Set
	
	i $d(^ORC("OPER",0,"ALIAS",Alias))&&(SecodeAlias="") d
	.;q:(SecodeAlias'="")&&(Alias'[SecodeAlias)
	.;b ;11
	.s tmp=$$GetORCOperByAlias(Alias,dDate)
	.s:ret'="" ret=ret_$c(1)_tmp
	.s:ret="" ret=tmp
	.;s ret=ret_tmp_$c(1)
	s tmpAilas=Alias
	f  s tmpAilas=$o(^ORC("OPER",0,"ALIAS",tmpAilas)) q:(tmpAilas="")!(tmpAilas'[Alias)  d
	.q:(SecodeAlias'="")&&($e(tmpAilas,$l(Alias)+1,$l(tmpAilas))'[SecodeAlias)
	.;b ;12
	.s tmp=$$GetORCOperByAlias(tmpAilas,dDate)
	.s:ret'="" ret=ret_$c(1)_tmp
	.s:ret="" ret=tmp
	
	k ^CacheTemp($zn,$j)
	q ret
GetORCOperByRowId(ORCICDID,dDate)
    New (ORCICDID,dDate)
    Set Rtn=""
   
	Quit:$d(^CacheTemp($zn,$j,ORCICDID)) Rtn ;条件判断，不重复写入
    Set ^CacheTemp($zn,$j,ORCICDID)=""
    Set tmpOperStr=..GetORCOper(ORCICDID)
    Set:Rtn'="" Rtn=Rtn_$c(1)_tmpOperStr
	Set:Rtn="" Rtn=tmpOperStr   
	;b ;12
	Quit Rtn
	;增加按照手术名称检索ICD9CM3码名称
GetORCOperByDesc(Desc,dDate)
    New (Desc,dDate)
    Set Rtn=""
    Set ORCICDID=0
    ;^ORC("OPER",0,"Desc",$$ALPHAUP({OPER_Desc}),{OPER_RowId})
    For {
	    Set ORCICDID=$o(^ORC("OPER",0,"Desc",Desc,ORCICDID))
	    
	    Quit:ORCICDID=""
		Continue:$d(^CacheTemp($zn,$j,ORCICDID))   ;条件判断，不重复写入
        Set ^CacheTemp($zn,$j,ORCICDID)=""
        Set tmp=$g(^ORC("OPER",ORCICDID))
        //.q:(HospCode="ShenYang_YDYFY")&&($p(tmp,"^",22)'="Y")   //update by zf 20090713  OPER_Valid 是否有效标记 “Y”作为编目手术的标记
        Set dFrom=+$p(tmp,"^",5)
        Set dTo=+$p(tmp,"^",6)
        Set dNow=dDate
        Continue:(dNow<dFrom)&(dFrom'=0)
        Continue:(dNow>dTo)&(dTo'=0)
        Set tmpOperStr=..GetORCOper(ORCICDID)
        Set:Rtn'="" Rtn=Rtn_$c(1)_tmpOperStr
	    Set:Rtn="" Rtn=tmpOperStr   
	}
	Quit Rtn
GetORCOperByAlias(MyAlias,dDate)
    n (MyAlias,dDate)
    s MyRet=""
    s HospCode=##class(web.DHCWMRMedBase01).GetDefaultHospCode()
    s tmpRowid=0
    ;b ;HospCode
    f  s tmpRowid=$o(^ORC("OPER",0,"ALIAS",MyAlias,tmpRowid)) q:tmpRowid=""  d
    .q:$d(^CacheTemp($zn,$j,tmpRowid))   ;条件判断，不重复写入
    .s ^CacheTemp($zn,$j,tmpRowid)=""
    .;s tmp=$g(^MRC("ID",tmpRowid))
    .s tmp=$g(^ORC("OPER",tmpRowid))
    .q:(HospCode="ShenYang_YDYFY")&&($p(tmp,"^",22)'="Y")   //update by zf 20090713  OPER_Valid 是否有效标记 “Y”作为编目手术的标记
    .s dFrom=+$p(tmp,"^",5)
    .;w "dFrom:"_dFrom,!
    .s dTo=+$p(tmp,"^",6)
    .;w "dTo:"_dTo,!
    .s dNow=dDate
    .;b ;10
    .q:(dNow<dFrom)&(dFrom'=0)
    .q:(dNow>dTo)&(dTo'=0)
    .;b ;11
    
    .s tmpOperStr=..GetORCOper(tmpRowid)
    
    .s:MyRet'="" MyRet=MyRet_$c(1)_tmpOperStr
	.s:MyRet="" MyRet=tmpOperStr
	.;w MyRet,!
    q MyRet
MyOperError
   Quit ret
}

/// 取本院编目所用的诊断数据
/// Modified by LiYang 2009-07-28 增加字典类型参数，如果没有传参，按照以前设置取数据
ClassMethod GetMyICDByRowId(RowId, SrcType = -1)
{
	n (RowId,SrcType)
	s ret=""
	i SrcType=-1 d //没有参数
	.s ICDSetting=..GetDHCWMRICDSettingD()
	.s:ICDSetting=0 ret=##class(web.DHCWMRICDCtl).GetICDDx(RowId)
	.s:ICDSetting=1 ret=..GetMRCICDDX(RowId)
	i SrcType=1 d //使用病案系统字典
	.s ret=##class(web.DHCWMRICDCtl).GetICDDx(RowId)
	i SrcType=2 d //使用HIS系统字典
	.s ret=..GetMRCICDDX(RowId)
	i SrcType=4 d //使用中医字典
	.s ret=..GetDSYM(RowId) 
	q ret
}

/// 取本院编目所用的手术数据
/// Modified by LiYang 2009-07-28 增加字典类型参数，如果没有传参，按照以前设置取数据
ClassMethod GetMyOperByRowId(RowId, SrcType = -1)
{
	n (RowId, SrcType)
	s ret=""
	i SrcType=-1 d //没有参数
	.s ICDSetting=..GetDHCWMRICDSettingO()
	.s:ICDSetting=0 ret=##class(web.DHCWMRICDCtl).GetICDDx(RowId)
	.s:ICDSetting=1 ret=..GetORCOper(RowId)
	i SrcType=1 d //使用病案系统字典
	.s ret=##class(web.DHCWMRICDCtl).GetICDDx(RowId)
	i SrcType=3 d //使用HIS系统字典
	.s ret=..GetORCOper(RowId)
	q ret
}

/// Add By LiYang 2009-07-29 按照编码、类别查询
/// Code：ICD编码
/// SrcType：2 查询HIS的MRC 3查 ORC表，4查询MRC_DiagnosSignSymptom表
ClassMethod QueryByCode(Code, SrcType)
{
	s ret=""
	i (SrcType=2)  d
	.s rowid=$o(^MRC("ID",0,"ICDCode",Code,""))
	.s:rowid'="" ret=##class(web.DHCWMRMedBaseICD).GetMRCICDDX(rowid)
	i (SrcType=3)  d
	.s rowid=$o(^MRC("ID",0,"ICDCode",Code,""))
	.s:rowid'="" ret=##class(web.DHCWMRMedBaseICD).GetORCOper(rowid)
	i (SrcType=4)  d
	.s rowid=$o(^MRCEXP("DSYM",Code,""))
	.i rowid'="" d
	..s tmp=$g(^MRCEXP("DSYM",rowid))
	..s $p(ret,"^",1)=rowid
	..s $p(ret,"^",2)=$p(tmp,"^",1)
	..s $p(ret,"^",4)=$p(tmp,"^",2)
	..s $p(ret,"^",7)="Yes"
	q ret
}

ClassMethod QryDiagByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiagByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDiagByAliasExecute(ByRef qHandle As %Binary, Alias As %String, SrcType As %String) As %Status
{
    s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s Alias=$$ALPHAUP^SSUTIL4(Alias)
	i SrcType<1 d //取系统设置字典
	.s ICDSetting=..GetDHCWMRICDSettingD()
	.s:ICDSetting=0 SrcType=1
	.s:ICDSetting=1 SrcType=2
	
	i SrcType=1 d    //取病案诊断字典
	.//^DHCWMRICDA(0,"Alias","Z"_$$ALPHAUP({Alias}),{ICDDxDr},{RowId})
	.s tmpAlias=$o(^DHCWMRICDA(0,"Alias","Z"_Alias),-1)
	.f  s tmpAlias=$o(^DHCWMRICDA(0,"Alias",tmpAlias)) q:(tmpAlias="")||(tmpAlias'[Alias)  d
	..s Rowid=0
	..f  s Rowid=$o(^DHCWMRICDA(0,"Alias",tmpAlias,Rowid)) q:Rowid=""  d
	...s tmp=##class(web.DHCWMRICDCtl).GetICDDx(Rowid)
	...q:$p(tmp,"^",7)'["Y"
	...q:($p(tmp,"^",5)'=1)&&($p(tmp,"^",5)'=3)  //1诊断 2手术 3肿瘤诊断
	...s ICDID=$p(tmp,"^",1)
	...s ICDCode=$p(tmp,"^",2)
	...s ICDDesc=$p(tmp,"^",4)
	...s ICDTypeID=1
	...s ICDTypeDesc="[MR]"
	...s Data=$lb(ICDID,ICDCode,ICDDesc,ICDTypeID,ICDTypeDesc)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	
	i SrcType=2 d    //取系统诊断字典
	.//^MRC("ID",0,"ALIAS",$$ALPHAUP({ALIAS_Text}),{MRC_ICDDx.MRCID_RowId},{ALIAS_Childsub})
	.s tmpAlias=$o(^MRC("ID",0,"ALIAS",Alias),-1)
	.f  s tmpAlias=$o(^MRC("ID",0,"ALIAS",tmpAlias)) q:(tmpAlias="")||(tmpAlias'[Alias)  d
	..s Rowid=0
	..f  s Rowid=$o(^MRC("ID",0,"ALIAS",tmpAlias,Rowid)) q:Rowid=""  d
	...s tmp=##class(web.DHCWMRMedBaseICD).GetMRCICDDX(Rowid)
	...q:$p(tmp,"^",7)'["Y"
	...s ICDID=$p(tmp,"^",1)
	...s ICDCode=$p(tmp,"^",2)
	...s ICDDesc=$p(tmp,"^",4)
	...s ICDTypeID=2
	...s ICDTypeDesc="[HIS]"
	...s Data=$lb(ICDID,ICDCode,ICDDesc,ICDTypeID,ICDTypeDesc)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	
	i SrcType=4 d    //取中医诊断字典
	.//^MRC("DSYM",0,"Code",$$ALPHAUP({DSYM_Code}),{DSYM_RowId})
	.s tmpAlias=$o(^MRC("DSYM",0,"Code",Alias),-1)
	.f  s tmpAlias=$o(^MRC("DSYM",0,"Code",tmpAlias)) q:(tmpAlias="")||(tmpAlias'[Alias)  d
	..s Rowid=0
	..f  s Rowid=$o(^MRC("DSYM",0,"Code",tmpAlias,Rowid)) q:Rowid=""  d
	...s tmp=##class(web.DHCWMRMedBaseICD).GetDSYM(Rowid)
	...s ICDID=$p(tmp,"^",1)
	...s ICDCode=$p(tmp,"^",2)
	...s ICDDesc=$p(tmp,"^",4)
	...s ICDTypeID=4
	...s ICDTypeDesc="[DS]"
	...s Data=$lb(ICDID,ICDCode,ICDDesc,ICDTypeID,ICDTypeDesc)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryDiagByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiagByAliasExecute ]
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

/// ***********************************************
/// 功能说明    ：取诊断字典
/// 入参        ：
/// Alias       ：诊断别名
/// Type        ：诊断类型
/// 调用        ：d ##Class(%ResultSet).RunQuery("web.DHCWMRMedBaseICD","QryDiagByAlias",Alias,SrcType)
/// ***********************************************
Query QryDiagByAlias(Alias As %String, SrcType As %String = -1) As %Query(ROWSPEC = "ICDID:%String,ICDCode:%String,ICDDesc:%String,ICDTypeID:%String,ICDTypeDesc:%String")
{
}

ClassMethod QryOperByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOperByAliasExecute(ByRef qHandle As %Binary, Alias As %String, SrcType As %String) As %Status
{
    s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s Alias=$$ALPHAUP^SSUTIL4(Alias)
	i SrcType<1 d //取系统设置字典
	.s ICDSetting=..GetDHCWMRICDSettingO()
	.s:ICDSetting=0 SrcType=1
	.s:ICDSetting=1 SrcType=3
	
	i SrcType=1 d    //取病案手术字典
	.//^DHCWMRICDA(0,"Alias","Z"_$$ALPHAUP({Alias}),{ICDDxDr},{RowId})
	.s tmpAlias=$o(^DHCWMRICDA(0,"Alias","Z"_Alias),-1)
	.f  s tmpAlias=$o(^DHCWMRICDA(0,"Alias",tmpAlias)) q:(tmpAlias="")||(tmpAlias'[Alias)  d
	..s Rowid=0
	..f  s Rowid=$o(^DHCWMRICDA(0,"Alias",tmpAlias,Rowid)) q:Rowid=""  d
	...s tmp=##class(web.DHCWMRICDCtl).GetICDDx(Rowid)
	...q:$p(tmp,"^",7)'["Y"
	...q:$p(tmp,"^",5)'=2     //1诊断 2手术 3肿瘤诊断
	...s ICDID=$p(tmp,"^",1)
	...s ICDCode=$p(tmp,"^",2)
	...s ICDDesc=$p(tmp,"^",4)
	...s ICDTypeID=1
	...s ICDTypeDesc="[MR]"
	...s Data=$lb(ICDID,ICDCode,ICDDesc,ICDTypeID,ICDTypeDesc)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	
	i SrcType=3 d    //取系统手术字典
	.//^ORC("OPER",0,"ALIAS",$$ALPHAUP({ALIAS_Text}),{ORC_Operation.OPER_RowId},{ALIAS_Childsub})
	.s tmpAlias=$o(^ORC("OPER",0,"ALIAS",Alias),-1)
	.f  s tmpAlias=$o(^ORC("OPER",0,"ALIAS",tmpAlias)) q:(tmpAlias="")||(tmpAlias'[Alias)  d
	..s Rowid=0
	..f  s Rowid=$o(^ORC("OPER",0,"ALIAS",tmpAlias,Rowid)) q:Rowid=""  d
	...s tmp=##class(web.DHCWMRMedBaseICD).GetORCOper(Rowid)
	...q:$p(tmp,"^",7)'["Y"
	...s ICDID=$p(tmp,"^",1)
	...s ICDCode=$p(tmp,"^",2)
	...s ICDDesc=$p(tmp,"^",4)
	...s ICDTypeID=2
	...s ICDTypeDesc="[HIS]"
	...s Data=$lb(ICDID,ICDCode,ICDDesc,ICDTypeID,ICDTypeDesc)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryOperByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperByAliasExecute ]
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

/// ***********************************************
/// 功能说明    ：取手术字典
/// 入参        ：
/// Alias       ：手术别名
/// Type        ：手术类型
/// 调用        ：d ##Class(%ResultSet).RunQuery("web.DHCWMRMedBaseICD","QryOperByAlias",Alias,SrcType)
/// ***********************************************
Query QryOperByAlias(Alias As %String, SrcType As %String = -1) As %Query(ROWSPEC = "ICDID:%String,ICDCode:%String,ICDDesc:%String,ICDTypeID:%String,ICDTypeDesc:%String")
{
}

}
