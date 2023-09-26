Class web.DHCBldSymptomConfig Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：      wwh
/// CreatDate：    20110325
/// Description:： 获取布局字段
/// Table：        ^DHCBLDSYMPTOM
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
	S:$l(layoutType) curType=$O(^DHCBLDSYMPTOM("LAYOUT",layoutType),-1)
	F {
		S curType=$O(^DHCBLDSYMPTOM("LAYOUT",curType))
		Q:(curType="")!(isFind=1)
		S:$l(layoutType)&(curType=layoutType) isFind=1
		Continue:$l(layoutType)&(isFind=0)
		S fieldCode=""
		F {
			S fieldCode=$O(^DHCBLDSYMPTOM("LAYOUT",curType,"FIELD",fieldCode))
			Q:fieldCode=""
			S data=$g(^DHCBLDSYMPTOM("LAYOUT",curType,"FIELD",fieldCode))
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
	//K ^DHCBLDSYMPTOM("LAYOUT")

	Q 0
}

ClassMethod InitStoreFields() As %Boolean
{
	K ^DHCBLDSYMPTOM("STORE")
	
	S storeCode="PACK"  //血袋信息
	S fieldCode="seq",fieldDesc="序号",type="string",width=70,hidden="false",renderer="",posIndex=1
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="packRowID",fieldDesc="血袋RowID",type="string",width=70,hidden="false",renderer="",posIndex=2
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="packDonorID",fieldDesc="献血码",type="string",width=120,hidden="false",renderer="",posIndex=3
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="productID",fieldDesc="产品码",type="string",width=160,hidden="false",renderer="",posIndex=4
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="packDesc",fieldDesc="描述",type="string",width=160,hidden="false",renderer="",posIndex=5
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="bldGroup",fieldDesc="血型",type="string",width=160,hidden="false",renderer="",posIndex=6
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="volume",fieldDesc="血量",type="string",width=160,hidden="false",renderer="",posIndex=7
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="unit",fieldDesc="单位",type="string",width=160,hidden="false",renderer="",posIndex=8
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="select",fieldDesc="是否选择",type="string",width=160,hidden="false",renderer="",posIndex=9
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	
	
	S storeCode="SYMPTOM"  //不良反应症状
	S fieldCode="itemCode",fieldDesc="项目代码",type="string",width=30,hidden="false",renderer="",posIndex=1
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="itemDesc",fieldDesc="描述",type="string",width=80,hidden="false",renderer="",posIndex=2
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	//S fieldCode="itemType",fieldDesc="类型",type="string",width=80,hidden="false",renderer="",posIndex=3
	//S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="selected",fieldDesc="选择",type="string",width=80,hidden="false",renderer="",posIndex=3
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	
	
	S storeCode="REACTIONTYPE"  //不良反应类型
	S fieldCode="itemCode",fieldDesc="项目代码",type="string",width=30,hidden="false",renderer="",posIndex=1
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="itemDesc",fieldDesc="描述",type="string",width=80,hidden="false",renderer="",posIndex=2
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="selected",fieldDesc="选择",type="string",width=80,hidden="false",renderer="",posIndex=3
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="itemType",fieldDesc="类型",type="string",width=80,hidden="true",renderer="",posIndex=4
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	
	S storeCode="HISTORY"  //历史记录单
	S fieldCode="seq",fieldDesc="序号",type="string",width=30,hidden="false",renderer="",posIndex=1
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="recordRowID",fieldDesc="记录单编号",type="string",width=80,hidden="false",renderer="",posIndex=2
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="statusCode",fieldDesc="状态代码",type="string",width=80,hidden="true",renderer="",posIndex=3
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="statusDesc",fieldDesc="状态描述",type="string",width=80,hidden="false",renderer="",posIndex=4
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="createDateTime",fieldDesc="创建时间",type="string",width=30,hidden="false",renderer="",posIndex=5
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="createUserCode",fieldDesc="创建人代码",type="string",width=80,hidden="true",renderer="",posIndex=6
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="createUserDesc",fieldDesc="创建人描述",type="string",width=80,hidden="false",renderer="",posIndex=7
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="checkDateTime",fieldDesc="复审时间",type="string",width=80,hidden="false",renderer="",posIndex=8
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="checkUserCode",fieldDesc="复审者代码",type="string",width=80,hidden="true",renderer="",posIndex=9
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="checkUserDesc",fieldDesc="复审者描述",type="string",width=80,hidden="false",renderer="",posIndex=10
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="bldBankProc",fieldDesc="输血科处理情况",type="string",width=80,hidden="false",renderer="",posIndex=11
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	S fieldCode="remark",fieldDesc="备注",type="string",width=80,hidden="false",renderer="",posIndex=12
	S ^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode)=fieldDesc_"\"_type_"\"_width_"\"_hidden_"\"_posIndex_"\"
	
	Q 0
}

ClassMethod GetStoreFields(storeCode As %String) As %String
{
	S storeCode=$g(storeCode)
	S ret=""
	Q:'$l(storeCode) ret
	Q:'$D(^DHCBLDSYMPTOM("STORE",storeCode)) ret
	S tRecDeli=$C(3),tFieldDeli=$C(2)
	S fieldCode=""
	F{
		S fieldCode=$O(^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode))
		Q:'$l(fieldCode)
		S data=$g(^DHCBLDSYMPTOM("STORE",storeCode,"FIELD",fieldCode))
		CONTINUE:'$l(data)
		S data=$TR(data,"\",tFieldDeli)
		S ret=ret_fieldCode_tFieldDeli_data_tRecDeli
	}
	Q ret
}

/// Creator：      wwh
/// CreatDate：    2012-2-1
/// Description:： 获取数据域的字典组映射代码
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetDataFiledsGroupCode(fieldCode As %String) As %String
{
	N (fieldCode)
    S fieldCode=$g(fieldCode)
    S ret=""
    Q:'$l(fieldCode) ret
    S ret=$g(^DHCBLDREACTIONCFG("DF",fieldCode,"G"))
	
    Q ret
}

ClassMethod InitSystem() As %String
{
	D ..InitStoreFields()
	Q 0
}

}
