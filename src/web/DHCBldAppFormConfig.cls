Class web.DHCBldAppFormConfig Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 获取备血医嘱的Json数据
/// 备注:此
ClassMethod InitFieldKeys() As %Boolean
{
	S index=1,deli="^"
	S type="string",^FieldKeys("APPFORM",index)="regNo"_deli_type,index=index+1				//1登记号
	S type="string", ^FieldKeys("APPFORM",index)="patAdmID"_deli_type,index=index+1			//2就诊号
	S type="string", ^FieldKeys("APPFORM",index)="patLocal"_deli_type,index=index+1			//3科室
	S type="string", ^FieldKeys("APPFORM",index)="patSex"_deli_type,index=index+1			//4性别
	S type="string", ^FieldKeys("APPFORM",index)="patName"_deli_type,index=index+1			//5姓名
	S type="string", ^FieldKeys("APPFORM",index)="patBed"_deli_type,index=index+1			//6床号
	S type="string", ^FieldKeys("APPFORM",index)="patBOD"_deli_type,index=index+1			//7生日
	S type="string", ^FieldKeys("APPFORM",index)="patAge"_deli_type,index=index+1			//8年龄
	S type="string", ^FieldKeys("APPFORM",index)="patAddress"_deli_type,index=index+1		//9地址
	S type="string", ^FieldKeys("APPFORM",index)="patTel"_deli_type,index=index+1			//10电话
	S type="string", ^FieldKeys("APPFORM",index)="patPepole"_deli_type,index=index+1		//11民族
	S type="string", ^FieldKeys("APPFORM",index)="patDiag"_deli_type,index=index+1			//12诊断
	S type="string", ^FieldKeys("APPFORM",index)="patBldTypeABO"_deli_type,index=index+1	//13ABO血型
	S type="string", ^FieldKeys("APPFORM",index)="patBldTypeRH"_deli_type,index=index+1		//14RH血型
	S type="string", ^FieldKeys("APPFORM",index)="patBldTypeOther"_deli_type,index=index+1	//15其他血型
	S type="string", ^FieldKeys("APPFORM",index)="appFormID"_deli_type,index=index+1		//16申请单编号
	S type="string", ^FieldKeys("APPFORM",index)="orders"_deli_type,index=index+1			//17输血医嘱
	S type="string", ^FieldKeys("APPFORM",index)="anamnesisData"_deli_type,index=index+1	//18既往史
	S type="string", ^FieldKeys("APPFORM",index)="transTargets"_deli_type,index=index+1		//19输血目的
	S type="string", ^FieldKeys("APPFORM",index)="transTypes"_deli_type,index=index+1		//20输血类型
	S type="string", ^FieldKeys("APPFORM",index)="testItems"_deli_type,index=index+1		//21化验项目
	S type="float", ^FieldKeys("APPFORM",index)="patBodyWeight"_deli_type,index=index+1		//22体重
	S type="float", ^FieldKeys("APPFORM",index)="patHeight"_deli_type,index=index+1			//23身高
	S type="string", ^FieldKeys("APPFORM",index)="patBldPressure"_deli_type,index=index+1	//24血压
	S type="int", ^FieldKeys("APPFORM",index)="patPulse"_deli_type,index=index+1			//25脉搏
	S type="float", ^FieldKeys("APPFORM",index)="patBodyTemperature"_deli_type,index=index+1	//26体温
	S type="date", ^FieldKeys("APPFORM",index)="selfUseBldDate"_deli_type,index=index+1		//27自体血预定用血日期
	S type="time", ^FieldKeys("APPFORM",index)="selfUseBldTime"_deli_type,index=index+1		//28自体血预定用血时间
	S type="int", ^FieldKeys("APPFORM",index)="selfCollectBldVolume"_deli_type,index=index+1	//29自体血预定采血量
	S type="string", ^FieldKeys("APPFORM",index)="transType"_deli_type,index=index+1		//30输血类型
    S type="date", ^FieldKeys("APPFORM",index)="transBldDate"_deli_type,index=index+1		//31输血日期
    S type="time", ^FieldKeys("APPFORM",index)="transBldTime"_deli_type,index=index+1		//32输血时间
    S type="string", ^FieldKeys("APPFORM",index)="isConsent"_deli_type,index=index+1		//33是否签订同意书
    S type="string", ^FieldKeys("APPFORM",index)="transOther"_deli_type,index=index+1		//34其他输血目的
	S type="string", ^FieldKeys("APPFORM",index)="formStatus"_deli_type,index=index+1		//35申请单状态
	S type="string", ^FieldKeys("APPFORM",index)="patLocDr"_deli_type,index=index+1			//36就诊科室代码
}

ClassMethod GetFormJsonReaderFields() As %Boolean
{
 D ..InitFieldKeys()
 //申请单字段信息
 S ret="["
 S index="",deli="^"
 F {
	 S index=$O(^FieldKeys("APPFORM",index)) 
	 Q:index=""
	 S field=$P($g(^FieldKeys("APPFORM",index)),deli,1)
	 S type=$P($g(^FieldKeys("APPFORM",index)),deli,2)
	 S ret=ret_"{name:'"_field_"',mapping:'"_field_"',type:'"_type_"'},"
	}  
 I $E(ret,$l(ret))="," {
 	S ret=$E(ret,1,$l(ret)-1)	 
 }
 S ret=ret_"]"
 S:ret="[]" ret="[{}]" 
 Q ret
}

//获取病人信息字段

ClassMethod GetPatInfoFields() As %Boolean
{
	//字段代码,字段描述,数据类型,只读,可为空,默认值,
}

//获取既往历字段

ClassMethod GetAnamnesisFields() As %Boolean
{
}

//获取输血目的字段

ClassMethod GetTransPurposesFields() As %Boolean
{
}

//获取输血类型字段

ClassMethod GetTransTypesFields() As %Boolean
{
}

//获取生命体征字段

ClassMethod GetPatSignInfoFields() As %Boolean
{
}

/// Creator：      wwh
/// CreatDate：    20110325
/// Description:： 获取布局字段
/// Table：        ^DHCBLDAPPFORMc
/// Input：        layoutType:布局模块类型
/// Output：       字段代码,字段描述,数据类型,布局元素类型,只读,可为空,
///                默认值,隐藏,验证类型,样式,激活,序号,值引用列
///                fieldCode,fieldDesc,dataType,xtype,isReadOnly,isAllowBlank,
///                defaultVal,hidden,vtype,style,activity,seqNumber,valRef
/// Return：       函数返回值的说明
/// Others：       layoutType:PA-病人信息,AN-既往史,TP-输血目的,TT-输血类型,SI-生命体征
Query SelectLayoutFields(layoutType As %String) As %Query(ROWSPEC = "fieldCode:%String,fieldDesc:%String,dataType:%String,xtype:%String,isReadOnly:%String,isAllowBlank:%String,defaultVal:%String,hidden:%String,vtype:%String,style:%String,activity:%String,valRef:%String,seqNumber:%String")
{
}

ClassMethod SelectLayoutFieldsExecute(ByRef qHandle As %Binary, layoutType As %String) As %Status
{
	S repid=$I(^CacheTemp)
	I $g(ind)="" S ind=1
	
	K ^TMP($zn,$J)
	S curType="",isFind=0,tDeli=$C(2)
	S:$l(layoutType) curType=$O(^DHCBLDAPPFORMc("LAYOUT",layoutType),-1)
	F {
		S curType=$O(^DHCBLDAPPFORMc("LAYOUT",curType))
		Q:(curType="")!(isFind=1)
		S:$l(layoutType)&(curType=layoutType) isFind=1
		Continue:$l(layoutType)&(isFind=0)
		S fieldCode=""
		F {
			S fieldCode=$O(^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode))
			Q:fieldCode=""
			S data=$g(^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode))
			Q:'$l(data)
			S seqNumber=+$P(data,tDeli,12)
			S:'$l(seqNumber) seqNumber=0
			S ^TMP($zn,$J,seqNumber,fieldCode)=data
		}
	}
	 
	S seqNumber=""
	F {
		S seqNumber=$O(^TMP($zn,$J,seqNumber))
		Q:seqNumber=""
		S fieldCode=""
		F {
			S fieldCode=$O(^TMP($zn,$J,seqNumber,fieldCode))
			Q:'$l(fieldCode)	
			S data=$g(^TMP($zn,$J,seqNumber,fieldCode))
			Continue:'$l(data)
			S index=1
			S fieldDesc=$P(data,tDeli,index),index=index+1	//1
			S dataType=$P(data,tDeli,index),index=index+1		//2
			S xtype=$P(data,tDeli,index),index=index+1		//3
			S isReadOnly=$P(data,tDeli,index),index=index+1	//4
			S isAllowBlank=$P(data,tDeli,index),index=index+1	//5
			S defaultVal=$P(data,tDeli,index),index=index+1	//6
			S hidden=$P(data,tDeli,index),index=index+1		//7
			S vtype=$P(data,tDeli,index),index=index+1		//8
			S style=$P(data,tDeli,index),index=index+1		//9
			S activity=$P(data,tDeli,index),index=index+1		//10
			S valRef=$P(data,tDeli,index),index=index+1		//11
			D OutputRow
		}
	}
	K ^TMP($zn,$J)
	S qHandle=$lb(0,repid,0)
	Q $$$OK
	
OutputRow
 	S ^CacheTemp(repid,ind)=$LB(fieldCode,fieldDesc,dataType,xtype,isReadOnly,isAllowBlank,defaultVal,hidden,vtype,style,activity,valRef,seqNumber)
 	S ind=ind+1
	Q
}

ClassMethod SelectLayoutFieldsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectLayoutFieldsExecute ]
{
	S repid=$LI(qHandle,2)
 	K ^CacheTemp(repid)
	Q $$$OK
}

ClassMethod SelectLayoutFieldsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectLayoutFieldsExecute ]
{
	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
	//
 	S ind=$O(^CacheTemp(repid,ind))
 	I ind="" {				// if there are no more rows, finish fetching
 		S AtEnd=1
 		S Row=""
 	}
 	Else      {				// fetch row
 		S Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

ClassMethod InitLayoutFields() As %Boolean
{
	S tDeli=$C(2)
	K ^DHCBLDAPPFORMc("LAYOUT")
	//------------------------------------------------------------------------------------------------>
	//病人基本信息
	S curType="PA",seqNumber=0,cols=5
	S ^DHCBLDAPPFORMc("LAYOUT",curType)=cols
	//----------------1,登记号
	S fieldCode="regNo",fieldDesc="病人ID",dataType="string",xtype="textfield",isReadOnly="Y",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="1",seqNumber=seqNumber+1,posIndex=1,setPos=0
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------2,姓名
	S fieldCode="patName",fieldDesc="姓名",dataType="string",xtype="textfield",isReadOnly="Y",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="6",seqNumber=seqNumber+1,posIndex=6,setPos=0
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------3,性 别
	S fieldCode="patSex",fieldDesc="性 别",dataType="string",xtype="textfield",isReadOnly="Y",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="5",seqNumber=seqNumber+1,posIndex=5,setPos=0
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------4,出生日期
	S fieldCode="patBOD",fieldDesc="出生日期",dataType="string",xtype="textfield",isReadOnly="Y",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="9",seqNumber=seqNumber+1,posIndex=9,setPos=0
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------5,年龄
	S fieldCode="patAge",fieldDesc="年龄",dataType="string",xtype="textfield",isReadOnly="Y",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="10",seqNumber=seqNumber+1,posIndex=10,setPos=0
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------6,科 室
	S fieldCode="patLocal",fieldDesc="科 室",dataType="string",xtype="textfield",isReadOnly="Y",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="3",seqNumber=seqNumber+1,posIndex=3,setPos=0
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------7,床号
	S fieldCode="patBed",fieldDesc="床号",dataType="string",xtype="textfield",isReadOnly="Y",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="8",seqNumber=seqNumber+1,posIndex=8,setPos=0
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------8,住 址
	S fieldCode="patAddress",fieldDesc="住 址",dataType="string",xtype="textfield",isReadOnly="Y",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="12",seqNumber=seqNumber+1,posIndex=12,setPos=0
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------9,联系电话
	S fieldCode="patTel",fieldDesc="联系电话",dataType="string",xtype="textfield",isReadOnly="Y",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="13",seqNumber=seqNumber+1,posIndex=15,setPos=0
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------10,民族
	S fieldCode="patPepole",fieldDesc="民族",dataType="string",xtype="textfield",isReadOnly="Y",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="20",seqNumber=seqNumber+1,posIndex=20,setPos=0
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------11,诊 断
	S fieldCode="patDiag",fieldDesc="诊 断",dataType="string",xtype="textfield",isReadOnly="Y",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="21",seqNumber=seqNumber+1,posIndex=21,setPos=0
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------12,ABO
	S fieldCode="patBldTypeABO",fieldDesc="ABO",dataType="string",xtype="textfield",isReadOnly="Y",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="32",seqNumber=seqNumber+1,posIndex=32,setPos=2
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------13,Rh(D)
	S fieldCode="patBldTypeRH",fieldDesc="Rh(D)",dataType="string",xtype="textfield",isReadOnly="Y",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="33",seqNumber=seqNumber+1,posIndex=33,setPos=3
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------14,其他血型
	S fieldCode="patBldTypeOther",fieldDesc="其他血型",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="34",seqNumber=seqNumber+1,posIndex=34,setPos=1
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//------------------------------------------------------------------------------------------------>
	//既往史信息
	S curType="AN",seqNumber=0,cols=3
	S ^DHCBLDAPPFORMc("LAYOUT",curType)=cols
	//----------------1,既往输血史
	S fieldCode="A001",fieldDesc="既往输血史",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="无",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=1,setPos=1
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------2,输血反应
	S fieldCode="A002",fieldDesc="输血反应",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="无",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=2,setPos=2
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------3,药物过敏史
	S fieldCode="A003",fieldDesc="药物过敏史",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="无",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=3,setPos=3
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------4,孕(次)
	S fieldCode="A004",fieldDesc="孕(次)",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="posInteger",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=4,setPos=4
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------5,产(次)
	S fieldCode="A005",fieldDesc="产(次)",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="posInteger",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=5,setPos=5
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//------------------------------------------------------------------------------------------------>
	//生命体征信息
	S curType="SI",seqNumber=0,cols=5
	S ^DHCBLDAPPFORMc("LAYOUT",curType)=cols
	//----------------1,体重(Kg)
	S fieldCode="patBodyWeight",fieldDesc="体重(Kg)",dataType="float",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="posFloat",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=27,setPos=1
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------2,身高(cm)
	S fieldCode="patHeight",fieldDesc="身高(cm)",dataType="float",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="posFloat",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=28,setPos=2
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------3,血压(mmHg)
	S fieldCode="patBldPressure",fieldDesc="血压(mmHg)",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="bloodPressure",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=29,setPos=3
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------4,脉搏(次/分)
	S fieldCode="patPulse",fieldDesc="脉搏(次/分)",dataType="integer",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="posInteger",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=30,setPos=4
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------5,体温(℃)
	S fieldCode="patBodyTemperature",fieldDesc="体温(℃)",dataType="float",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="posFloat",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=31,setPos=5
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//------------------------------------------------------------------------------------------------>
	//输血信息
	S curType="TR",seqNumber=0,cols=5
	S ^DHCBLDAPPFORMc("LAYOUT",curType)=cols
	//----------------1,预定用血日期
	S fieldCode="transBldDate",fieldDesc="预定用血日期",dataType="date",xtype="datefield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=5,setPos=1
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------2,时间
	S fieldCode="transBldTime",fieldDesc="时间",dataType="time",xtype="timefield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=6,setPos=2
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------3,输血类型
	S fieldCode="transType",fieldDesc="输血类型",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=4,setPos=3
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------4,其他
	S fieldCode="transOther",fieldDesc="其他",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=11,setPos=4
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------5,就诊号
	S fieldCode="patAdmID",fieldDesc="就诊号",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="true",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=0,setPos=5
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------6,申请单编号
	S fieldCode="appFormID",fieldDesc="申请单编号",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="true",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=1,setPos=6
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------7,申请单状态
	S fieldCode="formStatus",fieldDesc="申请单状态",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="true",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=3,setPos=7
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	
	//----------------8,备血医嘱
	S fieldCode="orders",fieldDesc="备血医嘱",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="true",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=0,setPos=8
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	
	//----------------9,输血目的
	S fieldCode="transPorpuses",fieldDesc="输血目的",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="true",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=0,setPos=9
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//------------------------------------------------------------------------------------------------>
	//其他信息
	S curType="OT",seqNumber=0,cols=3
	S ^DHCBLDAPPFORMc("LAYOUT",curType)=cols
	//----------------1,氧和血
	S fieldCode="otherOxygen",fieldDesc="氧和血",dataType="string",xtype="checkbox",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=32,setPos=1
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------2,辐照
	S fieldCode="otherIrradiation",fieldDesc="辐照",dataType="string",xtype="checkbox",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=13,setPos=2
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------3,滤白
	S fieldCode="otherFilterWBC",fieldDesc="滤白",dataType="string",xtype="checkbox",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=14,setPos=3
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------4,是否签订同意书
	S fieldCode="consentLetter",fieldDesc="是否签订同意书",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=10,setPos=4
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------5,备注
	S fieldCode="remark",fieldDesc="备注",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=15,setPos=5
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	
	//------------------------------------------------------------------------------------------------>
	//自体输血信息
	S curType="ST",seqNumber=0,cols=5
	S ^DHCBLDAPPFORMc("LAYOUT",curType)=cols
	//----------------1,预定用血日期
	S fieldCode="selfUseBldDate",fieldDesc="预定用血日期",dataType="date",xtype="datefield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=5,setPos=1
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------2,时间
	S fieldCode="selfUseBldTime",fieldDesc="时间",dataType="time",xtype="timefield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=6,setPos=2
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------3,预定采血量(ml)
	S fieldCode="selfCollectBldVolume",fieldDesc="预定采血量(ml)",dataType="integer",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="posInteger",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=9,setPos=3
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------4,其他
	S fieldCode="selfTransTargetOther",fieldDesc="备注",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=11,setPos=4
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------5,就诊号
	S fieldCode="patAdmID",fieldDesc="就诊号",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="true",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=0,setPos=5
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------6,申请单编号
	S fieldCode="appFormID",fieldDesc="申请单编号",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="true",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=1,setPos=6
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------7,申请单状态
	S fieldCode="formStatus",fieldDesc="申请单状态",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="true",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=3,setPos=7
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//------------------------------------------------------------------------------------------------>
	//操作信息
	S curType="OP",seqNumber=0,cols=2
	S ^DHCBLDAPPFORMc("LAYOUT",curType)=cols
	//----------------1,操作类型
	S fieldCode="opType",fieldDesc="操作类型",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="true",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=1,setPos=1
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------2,操作者代码
	S fieldCode="userCode",fieldDesc="操作者代码",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=2,setPos=2
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	//----------------3,申请单类型
	S fieldCode="formType",fieldDesc="申请单类型",dataType="string",xtype="textfield",isReadOnly="",isAllowBlank="Y"
	S defaultVal="",hidden="false",vtype="",style="",activity="Y",valRef="",seqNumber=seqNumber+1,posIndex=3,setPos=3
	S data=fieldDesc_tDeli_dataType_tDeli_xtype_tDeli_isReadOnly_tDeli_isAllowBlank_tDeli_defaultVal_tDeli
	S data=data_hidden_tDeli_vtype_tDeli_style_tDeli_activity_tDeli_valRef_tDeli_seqNumber_tDeli_posIndex_tDeli_setPos_tDeli
	S ^DHCBLDAPPFORMc("LAYOUT",curType,"FIELD",fieldCode)=data
	
	Q 0
}

// d ##class(web.DHCBldAppFormConfig).InitStoreFields()

ClassMethod InitStoreFields() As %Boolean
{
	K ^DHCBLDAPPFORMc("STORE")
	S storeCode="TESTITEMS"  //化验项目结果
	S fieldCode="seq",fieldDesc="序号",type="string",width=70,hidden="false",renderer="",posIndex=4
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="itemCode",fieldDesc="代码",type="string",width=70,hidden="false",renderer="",posIndex=1
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="itemDesc",fieldDesc="描述",type="string",width=120,hidden="false",renderer="",posIndex=2
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="itemValue",fieldDesc="结果",type="string",width=160,hidden="false",renderer="",posIndex=3
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	
	S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","abmormal") = "异常标记\string\70\false\6\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","emptyText") = "无结果提示\string\70\false\13\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","isRequired") = "结果必填\string\70\false\15\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","isSaveEmptyText") = "是否保存提示\string\70\false\14\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","itemCode") = "代码\string\70\false\1\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","itemDesc") = "描述\string\120\false\2\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","itemValue") = "结果\string\160\false\3\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","preResult") = "最近结果\string\70\false\18\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","range") = "参考范围\string\70\false\7\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","resDateTime") = "结果时间\string\70\false\10\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","resEnterType") = "结果编辑类型\string\70\false\16\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","resSource") = "结果来源\string\70\false\8\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","resUserCode") = "结果审核者代码\string\70\false\11\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","resUserDesc") = "结果审核者\string\70\false\12\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","resultRowID") = "报告ID\string\70\false\9\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","seq") = "序号\string\70\false\4\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","testItemData") = "待选数据\string\70\false\17\" 
    S ^DHCBLDAPPFORMc("STORE","TESTITEMS","FIELD","unit") = "单位\string\70\false\5\" 
 
	
	S storeCode="ORDERS"  //备血医嘱
	S fieldCode="seq",fieldDesc="序号",type="string",width=30,hidden="false",renderer="",posIndex=12
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="oeOrdID",fieldDesc="医嘱RowID",type="string",width=80,hidden="false",renderer="",posIndex=1
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="labNo",fieldDesc="检验号",type="string",width=80,hidden="false",renderer="",posIndex=4
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="oeOrdDesc",fieldDesc="医嘱名称",type="string",width=200,hidden="false",renderer="",posIndex=2
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="volume",fieldDesc="拟用量",type="string",width=80,hidden="false",renderer="",posIndex=6
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="unit",fieldDesc="单位",type="string",width=80,hidden="false",renderer="",posIndex=7
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="bldTypeABO",fieldDesc="ABO血型",type="string",width=60,hidden="false",renderer="",posIndex=9
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="bldTypeRH",fieldDesc="Rh(D)血型",type="string",width=80,hidden="false",renderer="",posIndex=10
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="remark",fieldDesc="备注",type="string",width=50,hidden="false",renderer="",posIndex=11
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="select",fieldDesc="选择",type="string",width=50,hidden="false",renderer="",posIndex=13
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	
	
	S storeCode="HISTORY"  //历史申请单
	S fieldCode="rowid",fieldDesc="编号",type="string",width=70,hidden="true",renderer="",posIndex=1
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="statusCode",fieldDesc="状态代码",type="string",width=40,hidden="true",renderer="",posIndex=2
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="statusDesc",fieldDesc="状态",type="string",width=50,hidden="false",renderer="",posIndex=3
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="lastUpdateTime",fieldDesc="最后更新时间",type="string",width=100,hidden="false",renderer="",posIndex=4
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="orders",fieldDesc="申请单内容",type="string",width=150,hidden="false",renderer="",posIndex=5
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="lastUpdateUserCode",fieldDesc="更新者代码",type="string",width=50,hidden="true",renderer="",posIndex=6
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="lastUpdateUserDesc",fieldDesc="更新者",type="string",width=60,hidden="false",renderer="",posIndex=7
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="remark",fieldDesc="备注",type="string",width=30,hidden="false",renderer="",posIndex=8
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="appFormType",fieldDesc="类型",type="string",width=70,hidden="true",renderer="",posIndex=9
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="details",fieldDesc="详细",type="string",width=70,hidden="true",renderer="",posIndex=10
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	
	S storeCode="OTHERREPORT"  //其他打印报告
	S fieldCode="seq",fieldDesc="序号",type="string",width=40,hidden="false",renderer="",posIndex=1
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="reportCode",fieldDesc="代码",type="string",width=60,hidden="false",renderer="",posIndex=2
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="reportDesc",fieldDesc="描述",type="string",width=150,hidden="false",renderer="",posIndex=3
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	
	S storeCode="TRANSORDERS"  //待选择的备血医嘱
	S fieldCode="bldGrpType",fieldDesc="血型",type="string",width=40,hidden="true",renderer="",posIndex=1
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="rowID",fieldDesc="rowID",type="string",width=60,hidden="true",renderer="",posIndex=2
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="code",fieldDesc="代码",type="string",width=150,hidden="true",renderer="",posIndex=3
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="desc",fieldDesc="医嘱描述",type="string",width=150,hidden="false",renderer="",posIndex=4
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="extCode",fieldDesc="外部代码",type="string",width=150,hidden="true",renderer="",posIndex=5
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="unit",fieldDesc="单位",type="string",width=150,hidden="false",renderer="",posIndex=6
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="activity",fieldDesc="激活",type="string",width=150,hidden="true",renderer="",posIndex=7
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="volume",fieldDesc="拟用量",type="string",width=150,hidden="false",renderer="",posIndex=8
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="select",fieldDesc="选择",type="string",width=150,hidden="true",renderer="",posIndex=9
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="message",fieldDesc="提示",type="string",width=150,hidden="true",renderer="",posIndex=10
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	
	
	S storeCode="GROUPGRANT"  //用户组权限 GROUPGRANT
	S fieldCode="itemCode",fieldDesc="权限代码",type="string",width=40,hidden="true",renderer="",posIndex=1
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="itemDesc",fieldDesc="权限描述",type="string",width=60,hidden="true",renderer="",posIndex=2
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="itemPri",fieldDesc="优先级",type="string",width=150,hidden="true",renderer="",posIndex=3
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="isPer",fieldDesc="是否授权",type="string",width=150,hidden="false",renderer="",posIndex=4
	S ^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	
	Q 0
}

ClassMethod GetStoreFields(storeCode As %String) As %String
{
	S storeCode=$g(storeCode)
	S ret=""
	Q:'$l(storeCode) ret
	Q:'$D(^DHCBLDAPPFORMc("STORE",storeCode)) ret
	S tRecDeli=$C(3),tFieldDeli=$C(2)
	S fieldCode=""
	F{
		S fieldCode=$O(^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode))
		Q:'$l(fieldCode)
		S data=$g(^DHCBLDAPPFORMc("STORE",storeCode,"FIELD",fieldCode))
		CONTINUE:'$l(data)
		S data=$TR(data,"\",tFieldDeli)
		S ret=ret_fieldCode_tFieldDeli_data_tRecDeli
	}
	Q ret
}

}
