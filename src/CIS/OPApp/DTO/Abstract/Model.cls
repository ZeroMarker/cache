Class CIS.OPApp.DTO.Abstract.Model Extends %RegisteredObject [ Abstract ]
{

ClassMethod Create() As CIS.OPApp.DTO.Abstract.Model
{
	set className=##this
	set instance=$classmethod(className,"%New")
	set query=##class(%ResultSet).%New("CIS.OPApp.DTO.Abstract.Model:FindProperties")
    set sc=query.Execute(className)
    //write "Model Instance Creating: ",className,!
    while(query.%Next())
    {
        set propertyName=query.Get("Name")
        set propertyType=query.Get("Type")
        set collection=query.Get("Collection")
        
        set propertyClassName=$$$NormalizeClassname(propertyType)
        set propertyClass=##class(%ClassDefinition).%OpenId(propertyClassName)
        set superClassName=$$$NormalizeClassname(propertyClass.Super)
        
        if (superClassName["CIS.OPApp.DTO.Abstract.Model")&&(collection="")
        {
		        set propertyInstance=$classmethod(propertyClassName,"Create")
		        set $property(instance,propertyName)=propertyInstance
        }
    }
	
	quit instance
}

Method CloneInitJSON(model As %DynamicObject) As %Status
{
	set className=##this.%ClassName(1)
	set instance=##this
	set query=##class(%ResultSet).%New("CIS.OPApp.DTO.Abstract.Model:FindProperties")
    set sc=query.Execute(className)
    while(query.%Next())
    {
        set propertyName=query.Get("Name")
        set propertyType=query.Get("Type")
        set collection=query.Get("Collection")
        
        set propertyClassName=$$$NormalizeClassname(propertyType)
        set propertyClass=##class(%ClassDefinition).%OpenId(propertyClassName)
        set superClassName=$$$NormalizeClassname(propertyClass.Super)
        
        if (superClassName["CIS.OPApp.DTO.Abstract.Model")||(propertyClassName="CIS.OPApp.DTO.Abstract.Model")
        {
	        if (collection="list")
	        {
		        set list=$property(instance,propertyName)
		        set propertyModel=model.%Get(propertyName)
		        set iter=propertyModel.%GetIterator()
		        while(iter.%GetNext(.index,.row))
		        {
			        set propertyInstance=$classmethod(propertyClass,"%New")
			        do $method(propertyInstance,"CloneInitJSON",row)
			        do $method(list,"Insert",propertyInstance)
		        }
		        
	        }
	        else
	        {
		        set propertyInstance=$classmethod(propertyClass,"%New")
		        set propertyModel=model.%Get(propertyName)
		        do $method(propertyInstance,"CloneInitJSON",propertyModel)
		        set $property(instance,propertyName)=propertyInstance
	        }
        }
        else
        {
	        set $property(instance,propertyName)=model.%Get(propertyName)
        }
    }
    
    quit $$$OK
}

/// 查询类的属性
/// w ##class(%ResultSet).RunQuery("CIS.OPApp.DTO.Abstract.Model","FindProperties","CIS.OPApp.DTO.OP.Arrangement")
Query FindProperties(className As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,Name,Type,Collection From %Dictionary.PropertyDefinition where parent=:className
}

Method ToJSON() As %DynamicObject
{
	set result=##class(%DynamicObject).%New()
	
	set className=##this.%ClassName(1)
	set instance=##this
	set query=##class(%ResultSet).%New("CIS.OPApp.DTO.Abstract.Model:FindProperties")
    set sc=query.Execute(className)
    //write "Model ToJSON Class:",className,!
    while(query.%Next())
    {
        set propertyName=query.Get("Name")
        set propertyType=query.Get("Type")
        set collection=query.Get("Collection")
        
        set propertyClassName=$$$NormalizeClassname(propertyType)
        set propertyClass=##class(%ClassDefinition).%OpenId(propertyClassName)
        set superClassName=$$$NormalizeClassname(propertyClass.Super)
        
        //write "Model ToJSON Property:",propertyName," Class:",propertyClassName," Super Class:",superClassName," collection:",collection,!
        if (superClassName["CIS.OPApp.DTO.Abstract.Model")||(propertyClassName="CIS.OPApp.DTO.Abstract.Model")
        {
	        if (collection="list")
	        {
		        set array=##class(%DynamicArray).%New()
		        set object=$property(instance,propertyName)
	        	while ($method(object,"GetNext",.key))
	        	{
	        		set row=$method(object,"GetAt",key)
					do array.%Push($method(row,"ToJSON"))
	        	}
	        	do result.%Set(propertyName,array)
	        }
	        else
	        {
        		set object=$property(instance,propertyName)
        		set json=$method(object,"ToJSON")
        		do result.%Set(propertyName,json)
	        }
		}
		else
		{
			set value=$property(instance,propertyName)
			do result.%Set(propertyName,value)
		}
    }
    
    quit result
}

Method CloneInit(object As %RegisteredObject) As %Status
{
	set className=##this.%ClassName(1)
	write "clone init: classname:",className,!
	set instance=##this
	set query=##class(%ResultSet).%New("CIS.OPApp.DTO.Abstract.Model:FindProperties")
    set sc=query.Execute(className)
    while(query.%Next())
    {
        set propertyName=query.Get("Name")
        set propertyType=query.Get("Type")
        set collection=query.Get("Collection")
        
        set propertyClassName=$$$NormalizeClassname(propertyType)
        set propertyClass=##class(%ClassDefinition).%OpenId(propertyClassName)
        set superClassName=$$$NormalizeClassname(propertyClass.Super)
        
        if (superClassName["CIS.OPApp.DTO.Abstract.Model")||(propertyClassName="CIS.OPApp.DTO.Abstract.Model")
        {
	        if (collection="list")
	        {
		        set list=$property(instance,propertyName)
		        try
		        {
			        set propertyModel=$property(object,propertyName)
			        while(propertyModel.Next(.key))
			        {
				        set row=propertyModel.GetAt(key)
				        if $IsObject(row)
				        {
				        	set propertyInstance=$classmethod(propertyClassName,"%New")
				        	do $method(propertyInstance,"CloneInit",row)
				       		do $method(list,"Insert",propertyInstance)
				        }
			        }
		        }
		        catch(e){}
		        
	        }
	        else
	        {
		        set propertyInstance=$classmethod(propertyClassName,"%New")
		        try
		        {
			        set propertyModel=$property(object,propertyName)
			        if $IsObject(propertyModel)
			        {
			        	do $method(propertyInstance,"CloneInit",propertyModel)
			        }
			        set $property(instance,propertyName)=propertyInstance
		        }
		        catch(e){}
	        }
        }
        else
        {
	        try
		    {
		        set $property(instance,propertyName)=$property(object,propertyName)
	        }
		    catch(e){}
        }
    }
	
	quit $$$OK
}

Method Clone() As CIS.OPApp.DTO.Abstract.Model
{
	quit ##this.%ConstructClone()
}

/// 是否某个类的实例
Method InstanceOf(className As %String) As %Boolean
{
	set thisClassName=##this.%ClassName(1)
	quit thisClassName=className
}

}
