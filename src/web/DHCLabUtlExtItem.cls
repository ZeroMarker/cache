Include webimport

IncludeGenerator webimport

/// Ext 相关元素
Class web.DHCLabUtlExtItem Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：      wwh
/// CreatDate：    2011-5-24
/// Description:： 构建Checkbox
/// Table：        无
/// Input：        name:代码,lable:描述
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它属性可以通过容器的默认值来控制
ClassMethod BuildCheckbox(name As %String, lable As %String, checked As %String) As %String
{
	N (name,lable,checked)
	S name=$g(name),lable=$g(lable),checked=$g(checked)
	S ret="{"
	S ret=ret_"xtype:'checkbox',"
	S ret=ret_"boxLabel:'"_lable_"',"
	S ret=ret_"name:'"_name_"',"
	S ret=ret_"checked:"_$S(checked'="Y":"false",1:"true")_","
	S ret=ret_"anchor:'95%'"
	S ret=ret_"}"
    Q ret
}

/// Creator：      wwh
/// CreatDate：    2011-5-24
/// Description:： 构建Checkbox
/// Table：        无
/// Input：        name:代码,lable:描述
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它属性可以通过容器的默认值来控制
ClassMethod BuildRadio(name As %String, lable As %String, inputValue As %String) As %String
{
	N (name,lable,inputValue)
	S name=$g(name),lable=$g(lable),inputValue=$g(inputValue)
	S ret="{"
	S ret=ret_"xtype:'radio',"
	S ret=ret_"boxLabel:'"_lable_"',"
	S ret=ret_"name:'"_name_"',"
	S ret=ret_"inputValue:'"_inputValue_"',"
	S ret=ret_"anchor:'95%'"
	S ret=ret_"}"
    Q ret
}

/// Creator：      wwh
/// CreatDate：    2011-5-24
/// Description:： 构建textfield
/// Table：        无
/// Input：        name:代码,lable:描述
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它属性可以通过容器的默认值来控制
ClassMethod BuildTextfield(name As %String, lable As %String, value As %String, allowBlank As %String, readOnly As %String, hidden As %String, dataType As %String) As %String
{
	N (name,lable,value,allowBlank,readOnly, hidden,conLayout,dataType)
	S name=$g(name),lable=$g(lable),value=$g(value),allowBlank=$g(allowBlank),readOnly=$g(readOnly)
	S hidden=$g(hidden),dataType=$g(dataType)
	
	S ret=""
	S ret=ret_"{"
	S ret=ret_"xtype:'textfield',"
	S:$l(dataType) ret=ret_"vtype:'"_dataType_"',"
	S ret=ret_"fieldLabel:'"_lable_"',"
	S ret=ret_"name:'"_name_"',"
	//S ret=ret_"lableWidth:'"_10_"',"
	S ret=ret_"value:'"_value_"',"
	S ret=ret_"allowBlank:"_$S(allowBlank'="N":"false",1:"true")_","
	S ret=ret_"readOnly:"_$S(readOnly'="Y":"false",1:"true")_","
	S ret=ret_"hidden:"_$S(hidden'="Y":"false",1:"true")_","
	S ret=ret_"hideLabel:"_$S(hidden'="Y":"false",1:"true")_","
	S ret=ret_"anchor:'95%'"
	S ret=ret_"}"
    Q ret
}

/// Creator：      wwh
/// CreatDate：    2011-5-24
/// Description:： 构建textfield
/// Table：        无
/// Input：        name:代码,lable:描述
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它属性可以通过容器的默认值来控制
ClassMethod BuildComboBox(name As %String, lable As %String, value As %String, allowBlank As %String, readOnly As %String, hidden As %String, itmData As %String, modifiable As %String) As %String
{
	N (name,lable,value,allowBlank,readOnly, hidden,modifiable,itmData)
	S name=$g(name),lable=$g(lable),value=$g(value),allowBlank=$g(allowBlank),readOnly=$g(readOnly)
	S hidden=$g(hidden),itmData=$g(itmData),modifiable=$g(modifiable)
	
	S stData="["
	F i=1:1:$l(itmData,$C(3)) {
		S data=$P(itmData,$C(3),i)
		S dictCode=$P(data,"^",1)
		Continue:'$l(dictCode)
		S dictDesc=$P(data,"^",2)
		S stData=stData_"['"_dictCode_"','"_dictDesc_"'],"
    }
	I $l(stData,",")>0 {
	  S stData=$E(stData,1,$l(stData)-1)	 
    }
    S stData=stData_"]"
	
	S ret="{"
	S ret=ret_"xtype:'combo',"
	S ret=ret_"fieldLabel:'"_lable_"',"
	S ret=ret_"mode:'local',"
	S ret=ret_"hiddenName:'"_name_"',"
	S ret=ret_"name:'"_name_"',"
	S ret=ret_"store:new Ext.data.SimpleStore({"
	S ret=ret_"fields:['value','text'],"
	S ret=ret_"data:"_stData
	S ret=ret_"}),"
	S ret=ret_"valueField:'value',"
	S ret=ret_"displayField:'text',"
	S ret=ret_"triggerAction:'all',"
	S ret=ret_"forceSelection:true,"
	S ret=ret_"editable:"_$S(modifiable'="N":"false",1:"true")_","
	S ret=ret_"blankText:'请选择"_lable_"',"
	S ret=ret_"emptyText:'选择"_lable_"',"
	S ret=ret_"allowBlank:"_$S(allowBlank'="N":"false",1:"true")_","
	//S ret=ret_"readOnly:"_$S(readOnly'="Y":"false",1:"true")_","
	//S ret=ret_"hidden:"_$S(hidden'="Y":"false",1:"true")_","
	//S ret=ret_"hideLabel:"_$S(hidden'="Y":"false",1:"true")_","
	S ret=ret_"anchor:'95%'"
	S ret=ret_"}"
    Q ret
}

/// Creator：      wwh
/// CreatDate：    2011-5-24
/// Description:： 获取布局Ext数据
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetLayoutExtData(dictCode As %String, dictDesc As %String, layoutRowID As %String, defaultType As %String, otherPar As %String = "") As %String
{
	N (dictCode,dictDesc,layoutRowID,defaultType,conLayout,otherPar)
	S layoutRowID=$g(layoutRowID),deli=$C(2),defaultType=$g(defaultType),dictCode=$g(dictCode),dictDesc=$g(dictDesc),otherPar=$g(otherPar)
	
	S ret=""
	//Q:('$l(layoutRowID))||('$l(dictCode)) ret
	Q:('$l(dictCode)) ret
	S layoutData=##class(web.DHCLabUtlCore).GetLayout(layoutRowID)
	Q:('$l(layoutData))&($l(layoutRowID)) ret
	Q:('$l(layoutRowID))&('$l(defaultType)) ret
	
	S layoutType=$ZCVT($P(layoutData,deli,1),"L")
	S defaultType=$ZCVT(defaultType,"L")
    S defaultValue=$P(layoutData,deli,2)
   	S required=$P(layoutData,deli,3)
    S readonly=$P(layoutData,deli,4)
    S modifiable=$P(layoutData,deli,5)
    S dataType=$P(layoutData,deli,6)
    S clientValidate=$P(layoutData,deli,7)
    S serverValidate=$P(layoutData,deli,8)
    S displaySeq=$P(layoutData,deli,9)
    S layoutDesc=$P(layoutData,deli,10)
    S hidden=$P(layoutData,deli,11)
    S type=$P(layoutData,deli,12)
    S itmData=$P(layoutData,deli,13)
    
    S:('$l(layoutRowID))&($l(defaultType)) layoutType=defaultType
    I layoutType="checkbox" {
		S ret=..BuildCheckbox(dictCode,dictDesc,defaultValue)
	}
    Q:$l(ret) ret
    
    I layoutType="textfield" {
	    S:$L(otherPar) defaultValue=otherPar
		S ret=..BuildTextfield(dictCode,dictDesc,defaultValue,required,readonly,hidden,dataType)
	}
    Q:$l(ret) ret
    
    I layoutType="combobox" {
		S ret=..BuildComboBox(dictCode,dictDesc,defaultValue,required,readonly,hidden,itmData,modifiable)
	}
    Q:$l(ret) ret
    
    I layoutType="radio" {
		S ret=..BuildRadio(otherPar,dictDesc,dictCode)
	}
    Q:$l(ret) ret
    
    
    
    I '$l(ret),$l(defaultType) {
		I defaultType="checkbox" {
			S ret=..BuildCheckbox(dictCode,dictDesc,defaultValue)
		}
    
    	I defaultType="textfield" {
			S ret=..BuildTextfield(dictCode,dictDesc,defaultValue,required,readonly,hidden,dataType)
		} 
	}
    Q ret
}

}
