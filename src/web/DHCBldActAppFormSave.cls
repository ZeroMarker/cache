/// 保存申请单信息
Class web.DHCBldActAppFormSave Extends web.IActionHandler
{

ClassMethod DoAction(ByRef request As %CSP.Request, ByRef response As %CSP.Response, ByRef session As %CSP.Session) As %Boolean [ Final ]
{
	S ret="{'success':"_"true"_",'info':'保存成功'}"
    
	S appFormID=$g(request.Data("appFormID",1))
	S formType=$g(request.Data("formType",1))
	S userCode=$g(request.Data("userCode",1))
	S checkUserCode=$g(request.Data("checkUserCode",1))
	S UserLocID=$g(request.Data("UserLocID",1))
	
	S dataDeli=$C(2),fieldDeli=$C(3)
	
	
	//只从客户端取如下数据进行保存，其他数据通过后台查询后再保存
	
	//既往史信息，其他血型
	//普通：用血日期，时间，输血类型，其他，输血目的，备血医嘱
	//氧和血，辐照血，滤白，同意书是否签订
	//自体血：生命体征，用血日期，时间，预订采集量，备注
	//申请单号，就诊号
	//操作者
	//anamnesisInfo
	S typeDeli=$C(3),fieldDeli=$C(2)
	S fieldsData=##Class(web.DHCBldAppFormLayout).GetFormFieldData(request,"")
	//PA,AN,OT,TR,SI,ST
	S fieldValues("PA")=$P(fieldsData,typeDeli,1)
	S fieldValues("AN")=$P(fieldsData,typeDeli,2)
	S fieldValues("OT")=$P(fieldsData,typeDeli,3)
	S fieldValues("TR")=$P(fieldsData,typeDeli,4)
	S fieldValues("SI")=$P(fieldsData,typeDeli,5)
	S fieldValues("ST")=$P(fieldsData,typeDeli,6)
	S fieldValues("OP")=$P(fieldsData,typeDeli,7)
    
    S $P(fieldsData,typeDeli,9)=checkUserCode 
	S retValStr=##class(web.DHCBldAppForm).SaveAppForm(fieldsData,UserLocID)
	S retVal=$P(retValStr,"^",1)
	S appFormID=$P(retValStr,"^",2)
	S success="false"
	S:retVal=0 success="true"
	S info=""
	I retVal'=0 D
	.S info="保存失败!"_appFormID

	
	S ret="{'success':"_success_",'info':'"_info_"','appFormID':'"_appFormID_"','formType':'"_formType_"'}"
	w ret
	Q ret
}

Parameter ActionID = "BLD.APPFORM.SAVE";

Parameter Version = "1.0.0.1";

}
