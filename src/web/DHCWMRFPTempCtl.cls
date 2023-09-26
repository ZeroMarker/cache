Import SQLUser

Class web.DHCWMRFPTempCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 20;

/// 5 病案首页项目字典 DHC_WMR_FPItemDic
ClassMethod UpdateItem(Instring)
{
	n (Instring)
    s RowId=$p(Instring,"^",1)             ;RowId    
    s PLIST(2)=$p(Instring,"^",2)          ;Description         
    s PLIST(3)=+$p(Instring,"^",3)         ;DataTypeDr 
    s PLIST(4)=$p(Instring,"^",4)          ;DefaultValue        
    s PLIST(5)=$p(Instring,"^",5)          ;DictionaryName
    s PLIST(6)=$p(Instring,"^",6)          ;ResumeText
    s PLIST(7)=$s($p(Instring,"^",7)["Y":"Y",1:"N")          ;IsActive
    i RowId="" d
    .&sql(Insert into DHC_WMR_FPItemDic values :PLIST())
    e  d
    .&sql(Update DHC_WMR_FPItemDic values :PLIST() where Rowid=:RowId)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetItem(Id)
{
	n (Id)
	s ret=""
	q:'$d(^DHCWMRFPIDIC(Id)) ret
	s ret=$g(^DHCWMRFPIDIC(Id))
	/*
	s DataTypeDr=+$p(ret,"^",2)
	s:DataTypeDr'=0 DataType=$tr($g(^DHCWMRRDIC(DataTypeDr)),"^","/")
	s:$g(DataType)'="" $p(ret,"^",2)=DataTypeDr_"/"_DataType
	*/
	s ret=Id_"^"_ret
	q ret
}

/// add 2010-05-31
/// 根据附加项目中默认值表达式，获取默认值
ClassMethod GetItemNew(Id, EpisodeID)
{
	n (Id,EpisodeID)
	s ret=""
	q:'$d(^DHCWMRFPIDIC(Id)) ret
	s ret=$g(^DHCWMRFPIDIC(Id))
	q:ret="" ret
	s DefaultValue=$p(ret,"^",3)
	s:DefaultValue'="" DefaultValue=..GetExplainVal(EpisodeID,DefaultValue)
	s $p(ret,"^",3)=DefaultValue
	s ret=Id_"^"_ret
	q ret
}

/// add 2010-05-31
/// 取表达式的值
/// w ##Class(web.DHCWMRFPTempCtl).GetExplainVal(EpisodeID,DefaultValue)
ClassMethod GetExplainVal(argEpisodeID As %String, argDefaultValue As %String) As %String
{
	New (argEpisodeID,argDefaultValue)
	Set ret=0
	Quit:(argEpisodeID="")||(argDefaultValue="") ret
	
	Set $ZT="GetExplainValErr"
	Set EpisodeID=argEpisodeID
	Set PatientID=$p($g(^PAADM(argEpisodeID)),"^",1)
	Set tmpExp=argDefaultValue
	//三种表达式类型 字符串，数字，类方法
	If ((tmpExp["##C")||(tmpExp["##c")){   //类方法
		Set newExp="ret="_tmpExp
		Set @newExp
	}ElseIf $ISVALIDNUM(tmpExp){           //数值类型
		Set ret=+tmpExp
	}Else{                                 //普通字符串
		Set ret=tmpExp
	}
	Quit ret
GetExplainValErr
   Set Val=$ZERROR
   Set ret=""
   Quit ret
}

/// 6 病案首页项目模板 DHC_WMR_FPTemplate
ClassMethod UpdateTemp(Instring)
{
	n (Instring)
    s RowId=$p(Instring,"^",1)             ;RowId
    s PLIST(2)=$p(Instring,"^",2)          ;Code           
    s PLIST(3)=$p(Instring,"^",3)          ;Description         
    s PLIST(4)=+$p(Instring,"^",4)         ;MRTypeDr     
    s PLIST(5)=$s($p(Instring,"^",5)["Y":"Y",1:"N")          ;IsActive   
    s PLIST(6)=$p(Instring,"^",6)          ;ResumeText
    i RowId="" d
    .&sql(Insert into DHC_WMR_FPTemplate values :PLIST())
    e  d
    .&sql(Update DHC_WMR_FPTemplate values :PLIST() where Rowid=:RowId)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetTemp(Id)
{
	n (Id)
	s ret=""
	q:'$d(^DHCWMRFPT(Id)) ret
	s ret=$g(^DHCWMRFPT(Id))
	/*
	s MrTypeDr=+$p(ret,"^",3)
	s:MrTypeDr'=0 MrType=$tr($g(^DHCWMRRDIC(MrTypeDr)),"^","/")
	s:$g(MrType)'="" $p(ret,"^",3)=MrTypeDr_"/"_MrType
	*/
	s ret=Id_"^"_ret
	q ret
}

/// 6.1 病案首页项目模板明细  DHC_WMR_TemplateDtl
ClassMethod UpdateTempDtl(Instring)
{
	n (Instring)
    s RowId=$p(Instring,"^",1)             ;RowId
    s PLIST(2)=+$p(Instring,"^",2)         ;TempId 
    q:PLIST(2)=0 -1         
    s PLIST(3)=+$p(Instring,"^",3)         ;ItemId         
    q:PLIST(3)=0 -1
    s PLIST(4)=+$p(Instring,"^",4)         ;MRTypeDr     
    q:PLIST(4)=0 -1
    s PLIST(5)=$p(Instring,"^",5)          ;IsActive     
    s PLIST(6)=$p(Instring,"^",6)          ;IsActive   
    s PLIST(7)=$p(Instring,"^",7)          ;ResumeText
    
    i RowId="" d
    .&sql(Insert into DHC_WMR_TemplateDtl values :PLIST())
    e  d
    .&sql(Update DHC_WMR_TemplateDtl values :PLIST() where Rowid=:RowId)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetTempDtl(Id)
{
	n (Id)
	s ret=""
	q:'$d(^DHCWMRFPTD(Id)) ret
	s ret=$g(^DHCWMRFPTD(Id))
	/*
	s TempId=+$p(ret,"^",1)
	s:TempId'=0 Temp=$tr($g(^DHCWMRFPIDIC(TempDr)),"^","/")
	s:$g(Temp)'="" $p(ret,"^",1)=TempDr_"/"_Temp
	s ItemId=+$p(ret,"^",2)
	s:ItemId'=0 Item=$tr($g(^DHCWMRFPT(ItemId)),"^","/")
	s:$g(Temp)'="" $p(ret,"^",2)=ItemId_"/"_Item
	*/
	s ret=Id_"^"_ret
	q ret
}

}
