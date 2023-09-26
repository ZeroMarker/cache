/// 名称: EPRservice.BLL.BLGlossaryClassProperty
/// 描述: 术语扩展BLL层
/// 编写者：叶剑
/// 编写日期: 2016-11-24
Class EPRservice.BLL.BLGlossaryClassProperty Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEMRNavigationSchemeItem","SelectAllClassProperty","12||1")
Query SelectAllClassProperty() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,ClassName:%String,PropertyName:%String,Propertys:%String,Type:%String,ValueType:%String,ParentID:%String,Sequence:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_EMRITEMS_SelectALLClassProperty, SqlProc ]
{
	SELECT p.ID,p.ClassName,p.PropertyName,p.Propertys,p.Type,p.ValueType,p.ParentID,p.Sequence
	FROM EPRmeta.GlossaryClassProperty p
}

ClassMethod SelectClassPropertyID(AID As %String) As EPRservice.entity.EGlossaryClassProperty
{
	set objClassPropery = ##class(EPRmeta.GlossaryClassProperty).%OpenId(AID)
	q:(objClassPropery="") ""
	s objEClassPropery = ##Class(EPRservice.entity.EGlossaryClassProperty).%New()
	q:(objEClassPropery = "") ""
        
	s objEClassPropery.ID = objClassPropery.%Id()
	s objEClassPropery.ClassName = objClassPropery.ClassName
	s objEClassPropery.PropertyName = objClassPropery.PropertyName
	s objEClassPropery.Propertys = objClassPropery.Propertys
	s objEClassPropery.Type = objClassPropery.Type
	s objEClassPropery.ValueType = objClassPropery.ValueType
	s objEClassPropery.ParentID = objClassPropery.ParentID
	s objEClassPropery.Sequence = objClassPropery.Sequence

	q objEClassPropery
}

/// 得到最大code编号
ClassMethod GetMaxSeq(aType As %String) As %String
{
	&sql(select max(Sequence) into :ISeq from EPRmeta.GlossaryClassProperty where Type =:aType)
	s:(ISeq="") ISeq=0
	q ISeq
}

/// 创建一个项目
ClassMethod CreateClassProperty(aOrganClassProperty As EPRservice.entity.EGlossaryClassProperty) As %String
{
	/// b "s"
	s strReslt = "-1"	
	
	s objClassProperty = ##Class(EPRmeta.GlossaryClassProperty).%New()
	S objClassProperty.ClassName = $case(aOrganClassProperty.ClassName,$c(0):"",:aOrganClassProperty.ClassName)
	s objClassProperty.PropertyName = $case(aOrganClassProperty.PropertyName,$c(0):"",:aOrganClassProperty.PropertyName)
	s objClassProperty.Propertys = $case(aOrganClassProperty.Propertys,$c(0):"",:aOrganClassProperty.Propertys)
	s objClassProperty.Type = $case(aOrganClassProperty.Type,$c(0):"",:aOrganClassProperty.Type)
	s objClassProperty.ValueType = $case(aOrganClassProperty.ValueType,$c(0):"",:aOrganClassProperty.ValueType)
	s ^globCreateClassP = aOrganClassProperty.Sequence
	s objClassProperty.ParentID = aOrganClassProperty.ParentID
	s objClassProperty.Sequence = $case(aOrganClassProperty.Sequence,$c(0):0,:aOrganClassProperty.Sequence)
	s sc = objClassProperty.%Save()
	if ($$$ISOK(sc))
	{
	   s strReslt = objClassProperty.%Id()
	}
	else
	{
		s strReslt = "-1"	
	}
	q strReslt
}

/// 更新一个项目
ClassMethod UpdateClassProperty(aOrganClassProperty As EPRservice.entity.EGlossaryClassProperty) As %String
{
	/// b "s"	
	s strReslt = "-1"
	set objClassProperty=##class(EPRmeta.GlossaryClassProperty).%OpenId(aOrganClassProperty.ID)
	q:(objClassProperty="") ""	

	S objClassProperty.ClassName = $case(aOrganClassProperty.ClassName,$c(0):"",:aOrganClassProperty.ClassName)
	s objClassProperty.PropertyName = $case(aOrganClassProperty.PropertyName,$c(0):"",:aOrganClassProperty.PropertyName)
	s objClassProperty.Propertys = $case(aOrganClassProperty.Propertys,$c(0):"",:aOrganClassProperty.Propertys)
	s objClassProperty.Type = $case(aOrganClassProperty.Type,$c(0):"",:aOrganClassProperty.Type)
	s objClassProperty.ValueType = $case(aOrganClassProperty.ValueType,$c(0):"",:aOrganClassProperty.ValueType)
		
	s sc = objClassProperty.%Save()
	if ($$$ISOK(sc))
	{
	   s strReslt = objClassProperty.%Id()
	}
	else
	{
		s strReslt = "-1"	
	}
	q strReslt
}

/// 更新一个数据元范畴
/// w ##Class(EPRservice.BLL.BLGlossaryClassProperty).UpdateSequences("9^3,8^4")
ClassMethod UpdateSequences(argStr As %String) As %String
{
	 S IDCount =$L(argStr,",")
	 S strMrk= 1
	 TSTART 
	 For I=1:1:IDCount
	 {
		S argstrItem= $P(argStr,",",I)
		S argID = $P(argstrItem,"^",1)
		S argSeq = $P(argstrItem,"^",2)
		if ($d(argID)=0)||($d(argSeq)=0)||(argID="")||(argSeq="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}
		s objEntity="",result=""
		s objEntity=##class(EPRmeta.GlossaryClassProperty).%OpenId(argID)
		if (objEntity ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s objEntity.Sequence=argSeq
		s result=""
		if '(objEntity.%Save())
		{
			TROLLBACK
			s strMrk = 0
		    quit
		}
	 }
	 if (strMrk = 0)
	 {
		 TROLLBACK
		 quit 0
	 }
	TCOMMIT
	Quit 1
}

/// 删除一个项目
ClassMethod DeletClassPropertyByID(aClassPropertyId As %String) As %String
{
    q:(aClassPropertyId ="") "-1"
    b
    s objClassProperty = ##Class(EPRmeta.GlossaryClassProperty).%OpenId(aClassPropertyId)
	q:(objClassProperty="") "-1"
	s sc = ##class(EPRmeta.GlossaryClassProperty).%DeleteId(aClassPropertyId)
	if ($$$ISOK(sc))
	{	
	   q "0"
    }
    else
    {
		q "-1"
	}
}

/// 删除一个数据元范畴
/// d ##Class(EPRservice.BLL.BLGlossaryClassProperty).initData()
ClassMethod initData() As %String
{
	//初始化数据前，先清理
	k ^DHCEPRM.GlyClassPropertyI
	k ^DHCEPRM.GlyClassPropertyD
	d ..AddData("EMRinstance.InstanceData","创建者","CreateUser","EMRINSTANCE","V","0","1")
	d ..AddData("EMRinstance.InstanceData","修改者","ModifyUser","EMRINSTANCE","V","0","2")
	d ..AddData("EMRinstance.InstanceData","创建时间","CreateDate|CreateTime","EMRINSTANCE","V","0","3")
	d ..AddData("EMRinstance.InstanceData","发生时间","HappenDate|HappenTime","EMRINSTANCE","V","0","4")
	d ..AddData("EMRinstance.InstanceData","修改时间","ModifyDate|ModifyTime","EMRINSTANCE","V","0","5")
	//牙位数据
	s AParentID = ..AddData("Tooth","牙位数据","ToothPCode|ALL","EMRINSTANCE","V","0","6")
	s strTooth ="AUR.1^上颌右侧中切牙#AUR.2^上颌右侧侧切牙#AUR.3^上颌右侧尖牙#AUR.4^上颌右侧第一前磨牙#AUR.5^上颌右侧第二前磨牙#AUR.6^上颌右侧第一磨牙#AUR.7^上颌右侧第二磨牙#AUR.8^上颌右侧第三磨牙#ALR.1^下颌右侧中切牙#ALR.2^下颌右侧侧切牙#ALR.3^下颌右侧尖牙#ALR.4^下颌右侧第一前磨牙#ALR.5^下颌右侧第二前磨牙#ALR.6^下颌右侧第一磨牙#ALR.7^下颌右侧第二磨牙#ALR.8^下颌右侧第三磨牙#AUL.1^上颌左侧中切牙#AUL.2^上颌左侧侧切牙#AUL.3^上颌左侧尖牙#AUL.4^上颌左侧第一前磨牙#AUL.5^上颌左侧第二前磨牙#AUL.6^上颌左侧第一磨牙#AUL.7^上颌左侧第二磨牙#AUL.8^上颌左侧第三磨牙#ALL.1^下颌左侧中切牙#ALL.2^下颌左侧侧切牙#ALL.3^下颌左侧尖牙#ALL.4^下颌左侧第一前磨牙#ALL.5^下颌左侧第二前磨牙#ALL.6^下颌左侧第一磨牙#ALL.7^下颌左侧第二磨牙#ALL.8^下颌左侧第三磨牙#CUR.1^上颌右侧乳中切牙#CUR.2^上颌右侧乳侧切牙#CUR.3^上颌右侧乳尖牙#CUR.4^上颌右侧第一前乳磨牙#CUR.5^上颌右侧第二前乳磨牙#CLR.1^下颌右侧乳中切牙#CLR.2^下颌右侧乳侧切牙#CLR.3^下颌右侧乳尖牙#CLR.4^下颌右侧第一前乳磨牙#CLR.5^下颌右侧第二前乳磨牙#CUL.1^上颌左侧乳中切牙#CUL.2^上颌左侧乳侧切牙#CUL.3^上颌左侧乳尖牙#CUL.4^上颌左侧第一前乳磨牙#CUL.5^上颌左侧第二前乳磨牙#CLL.1^下颌左侧乳中切牙#CLL.2^下颌左侧乳侧切牙#CLL.3^下颌左侧乳尖牙#CLL.4^下颌左侧第一前乳磨牙#CLL.5^下颌左侧第二前乳磨牙"
	s strCount = $l(strTooth,"#")
	for i=1:1:strCount
	{
		s strItem = $p(strTooth,"#",i)
		s APropertys = "ToothPCode|"_$p(strItem,"^",1)
		s APropertyName= $p(strItem,"^",2)
		s ASeq = AParentID+i
		d ..AddData("Tooth",APropertyName,APropertys,"EMRINSTANCE","V",AParentID,ASeq)
	}
}

/// Desc:添加数据
/// Creator:yejian
/// CreateDate:2018-2-28
/// Input: AName 名称
///       AType 类型
///       AParentID 父节点
ClassMethod AddData(AClassName As %String, APropertyName As %String, APropertys As %String, AType As %String, AValueType As %String, AParentID As %String, ASequence As %String) As %String
{
		s result = ""
		q:(AClassName = "")||(APropertyName = "")||(APropertys = "")||(AType = "")||(AValueType = "")||(AParentID = "")||(ASequence = "") result
		/*s rowId = $o(^DHCEMRM.TextKBCategoryI("IdxKBCCode"," "_$zcvt(AName,"u"),""))
		if (rowId = "")
		{
			s obj = ##Class(EPRmeta.GlossaryClassProperty).%New()
			s obj.Sequence = $case($d(^DHCEMRM.TextKBCategoryD)>0,0:1,:^DHCEMRM.TextKBCategoryD+1)
		}
		else
		{
			s obj = ##Class(EPRmeta.GlossaryClassProperty).%OpenId(rowId)
		}
		*/
		s obj = ##Class(EPRmeta.GlossaryClassProperty).%New()
		s obj.ClassName= AClassName
		s obj.PropertyName=APropertyName
		S obj.Propertys = APropertys
		s obj.Type=AType
		s obj.ValueType=AValueType
		s obj.ParentID=AParentID
		s obj.Sequence=ASequence
		s sc = obj.%Save()
		s:($$$ISOK(sc)) result = obj.%Id()
		q result
}

/// 删除一个数据元范畴
/// d ##Class(EMRservice.BL.BLEMROrganClassProperty).test()
ClassMethod test() As %String
{
	
	s OrganScheme = ##Class(EPRservice.entity.EGlossaryClassProperty).%New()
	s OrganScheme.ItemDr= 32
	s OrganScheme.ItemCode="32"
	S OrganScheme.ItemName = "检验报告"
	s OrganScheme.ItemSeq=32
	;d ..CreateClassProperty("12||1",OrganScheme)
}

}
