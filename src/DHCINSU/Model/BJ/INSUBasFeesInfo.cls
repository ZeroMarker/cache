Class DHCINSU.Model.BJ.INSUBasFeesInfo Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property strBillDr As %String;

//帐单号                          

Property ID As %String;

//进程号                          

Property PBPayedFlag As %String;

//帐单状态                        

Property PBDateFrom As %String;

//帐单开始日期                    

Property PBDateTo As %String;

//帐单开始时间                    

Property PBUpdateUserDr As %String;

//结算人Dr                        

Property PBUpdateUser As %String;

//结算人                          

Property PRTinv As %String;

//发票编号                        

Property BillQty As %String;

//数量                            

Property UnitPrice As %String;

//单价                            

Property TotalAmount As %String;

//发生金额                        

Property UpdateDate As %String;

//DHC_PatientBill.PB_UpdateDate   

Property UpdateTime As %String;

//DHC_PatientBill.PB_UpdateTime   

Property PBOOrderDate As %String;

//DHC_PatBillOrder.PBO_OrderDate  

Property PBOOrderTime As %String;

//DHC_PatBillOrder.PBO_OrderTime  

Property PBADMDR As %String;

//DHC_PatientBill.PB_ADMDR        

Property DHCTarItemInfo As User.DHCTarItem;

Property OEORDInfo As User.OEOrdItem;

Property PBDID As %String;

//Property DivideSubInfo As New Model.clsInsuDivideSub;                     

//Relationship INSUBasFeesInfoCollection As DHCINSU.Model.BJ.INSUBasFeesInfoCollection(XMLPROJECTION = "NONE") [ Cardinality = one, Inverse = INSUBasFeesInfo ];

}
