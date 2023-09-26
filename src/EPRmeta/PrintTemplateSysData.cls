/// 配置打印模板系统常用数据
/// 对外接口 ##Class(EPRservice.BOTemplate).GetPrtSysData()
Class EPRmeta.PrintTemplateSysData Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxCode On Code;

/// 数据项名称
Property Name As %String(TRUNCATE = 1);

/// 数据项类型
Property Type As %String(TRUNCATE = 1);

/// 数据项代码
Property Code As %String(TRUNCATE = 1);

/// 图片编号
Property Image As %Integer;

/// d ##Class(EPRmeta.PrintTemplateSysData).IniData()
ClassMethod IniData()
{
	//&sql(delete from EPRmeta.PrintTemplateSysData)
	// 唯一模板
	d ..NewSysData("病历作者", "SAUTHOR", 4)
    d ..NewSysData("审核医师", "SCHECKUSER", 4)
    d ..NewSysData("审核日期", "SCHECKDATE", 1)
    d ..NewSysData("审核医师级别", "SCHECKLEVEL", 4)
    d ..NewSysData("提交医师", "SCOMMITUSER", 4)
    d ..NewSysData("提交日期", "SCOMMITDATE", 1)
    d ..NewSysData("病历作者签名", "SAUTHORSIGN", 1)
    d ..NewSysData("病历作者签名图", "SAUTHORIMG", 4)
    d ..NewSysData("病历作者签名时间", "SAUTHORSIGNDATE", 1) 
    d ..NewSysData("审核医师签名", "SCHECKSIGN", 1)   
    d ..NewSysData("审核医师签名图", "SCHECKUSERIMG", 4)   
    d ..NewSysData("审核医师签名时间", "SCHECKSIGNDATE", 1)   
    d ..NewSysData("主治医师签名", "SATTENDINGSIGN", 4)   
    d ..NewSysData("主治医师签名图", "SATTENDINGSIGNIMG", 4) 
    d ..NewSysData("主任医师签名", "SCHIEFSIGN", 4) 
    d ..NewSysData("主任医师签名图", "SCHIEFSIGNIMG", 4)  
    d ..NewSysData("提交者签名图", "SCOMMITTERIMG", 4)   
    d ..NewSysData("提交者签名", "SCOMMITTER", 4)  
    d ..NewSysData("提交者签名时间", "SCOMMITTERDATE", 4)
    d ..NewSysData("提交者医师级别", "SCOMMITTERLEVEL", 4)          
  	d ..NewSysData("科主任签名", "SCHAIRMAN", 4)   
    d ..NewSysData("质控医师签名", "SQCDOC", 4)  
    d ..NewSysData("质控护士签名", "SQCNURSE", 4)  
    d ..NewSysData("责任护士签名", "SCHARGENURSE", 4)  
  	d ..NewSysData("科主任签名图", "SCHAIRMANIMG", 4)   
    d ..NewSysData("质控医师签名图", "SQCDOCIMG", 4)  
    d ..NewSysData("质控护士签名图", "SQCNURSEIMG", 4)  
    d ..NewSysData("责任护士签名图", "SCHARGENURSEIMG", 4)     
    d ..NewSysData("病历签名者图片", "SLASTSIGNIMG", 4)  
             
	// 可重复模板 
    d ..NewInstanceData("作者", "AUTHOR", 4) 
    d ..NewInstanceData("标题", "TITLE", 3) 
    d ..NewInstanceData("发生日期", "HAPPENDATE", 1)
    d ..NewInstanceData("发生时间", "HAPPENTIME", 2) 
    d ..NewInstanceData("顺序号", "LISTNO", 3)  
    d ..NewInstanceData("审核医师", "CHECKUSER", 3) 
    d ..NewInstanceData("审核日期", "CHECKDATE", 1)
    d ..NewInstanceData("审核医师级别", "CHECKLEVEL", 3) 
    d ..NewInstanceData("提交医师", "COMMITUSER", 4)
    d ..NewInstanceData("提交日期", "COMMITDATE", 1)   
    d ..NewInstanceData("作者签名", "AUTHORSIGN", 1) 
    d ..NewInstanceData("作者签名图", "AUTHORIMG", 4)
    d ..NewInstanceData("作者签名时间", "AUTHORSIGNDATE", 1) 
    d ..NewInstanceData("审核医师签名", "CHECKSIGN", 1) 
    d ..NewInstanceData("审核医师签名图", "CHECKUSERIMG", 4)
    d ..NewInstanceData("审核医师签名时间", "CHECKSIGNDATE", 1)
    d ..NewInstanceData("主治医师签名", "ATTENDINGSIGN", 4) 
    d ..NewInstanceData("主治医师签名图", "ATTENDINGSIGNIMG", 4)       
    d ..NewInstanceData("主任医师签名", "CHIEFSIGN", 4)
    d ..NewInstanceData("主任医师签名图", "CHIEFSIGNIMG", 4)  
    d ..NewInstanceData("提交者签名图", "COMMITTERIMG", 4) 
    d ..NewInstanceData("提交者签名时间", "COMMITTERDATE", 4)     
    d ..NewInstanceData("提交者签名", "COMMITTER", 4) 
    d ..NewInstanceData("提交者医师级别", "COMMITTERLEVEL", 4)
    d ..NewInstanceData("编辑者签名", "EDITORSIGN", 4)
    d ..NewInstanceData("病历签名者图片", "LASTSIGNIMG", 4)
    d ..NewInstanceData("是否打印标题", "ISTITLEPRINT", 3)
}

ClassMethod NewSysData(sName, sCode, sImage As %String)
{
	s id=$o(^DHCEPRM.PrintTemplateSysDataI("IdxCode"," "_$zcvt(sCode,"U"),""))
	q:(""'=id)
	    	
	s obj=##Class(EPRmeta.PrintTemplateSysData).%New()
	s obj.Name=sName,obj.Type="SystemData",obj.Code=sCode,obj.Image=sImage
    d obj.%Save()
}

ClassMethod NewInstanceData(sName, sCode, sImage As %String)
{
	s id=$o(^DHCEPRM.PrintTemplateSysDataI("IdxCode"," "_$zcvt(sCode,"U"),""))
	q:(""'=id)
		
	s obj=##Class(EPRmeta.PrintTemplateSysData).%New()
	s obj.Name=sName,obj.Type="InstanceData",obj.Code=sCode,obj.Image=sImage
    d obj.%Save()
}

Storage Default
{
<Data name="PrintTemplateSysDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>Image</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.PrintTemplateSysDataD</DataLocation>
<DefaultData>PrintTemplateSysDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.PrintTemplateSysDataD</IdLocation>
<IndexLocation>^DHCEPRM.PrintTemplateSysDataI</IndexLocation>
<StreamLocation>^DHCEPRM.PrintTemplateSysDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
