////udhcOPHandin.DTSYMZRepRP.js


function BodyLoadHandler(){
	var obj=document.getElementById("RepEncmeth");
	if (obj){
		var encmeth=obj.value;
	}
	var obj=document.getElementById("RepID");
	if (obj){
		var RepID=obj.value;
	}
	var prtobj=document.getElementById("BPrint");
	if (prtobj){
		prtobj.onclick=BPrint_Click;
	}
	
	if (encmeth!=""){
		var rtnvalue=(cspRunServerMethod(encmeth,RepID)) 
	}
	var rtnary=rtnvalue.split("^");
	if (rtnary.length<23){
		DHCWeb_DisBtn(prtobj);
	}else{
		WrtDoc(rtnary);
	}
	
}

function BPrint_Click()
{
	///PrintClickHandler();
	PrintClickHandlerSDDTSYRep();
}

function GetINVNum(){
	var myNum=0;

	var myNum=DHCWebD_GetObjValue("CashNUM");
	if (isNaN(myNum)){
		myNum=0;
	}
	
	if (isNaN(DHCWebD_GetObjValue("CheckNUM"))){
	}else{
		var mysnum=parseInt(DHCWebD_GetObjValue("CheckNUM"));
		var myNum=+myNum+mysnum;
	}
	
	if (isNaN(DHCWebD_GetObjValue("XRYBNum"))){
	}else{
		var mysnum=parseInt(DHCWebD_GetObjValue("XRYBNum"));
		var myNum=+myNum+mysnum;
	}
	
	if (isNaN(DHCWebD_GetObjValue("CPPNum"))){
	}else{
		var mysnum=parseInt(DHCWebD_GetObjValue("CPPNum"));
		var myNum=+myNum+mysnum;
	}

	if (isNaN(DHCWebD_GetObjValue("GFJZNum"))){
	}else{
		var mysnum=parseInt(DHCWebD_GetObjValue("GFJZNum"));
		var myNum=+myNum+mysnum;
	}
	if (isNaN(DHCWebD_GetObjValue("HTDWNum"))){
	}else{
		var mysnum=parseInt(DHCWebD_GetObjValue("HTDWNum"));
		var myNum=+myNum+mysnum;
	}
	if (isNaN(DHCWebD_GetObjValue("TJNum"))){
	}else{
		var mysnum=parseInt(DHCWebD_GetObjValue("TJNum"));
		var myNum=+myNum+mysnum;
	}
	if (isNaN(DHCWebD_GetObjValue("YBINVNum"))){
	}else{
		var mysnum=parseInt(DHCWebD_GetObjValue("YBINVNum"));
		var myNum=+myNum+mysnum;
	}
	
	return myNum;
}

function WrtDoc(rtnary){

	///Build by Array Mode
	///OK   To PB
	////x HIS_Rowid                              DHC_INVPRTReports Row ID      1      xx
	
	////x HIS_Date                               His_date                      2      xx

	var obj=document.getElementById("sUser");
	if (obj){
		obj.value=rtnary[0];
	}
	
	////x HIS_Time                               His_time                      3      xx
	////x HIS_StartDate                          His_startdate                 4      xx
	DHCWebD_SetObjValueB("StartDate",rtnary[4]);
	////x HIS_StartTime                          His_starttime                 5      xx
	DHCWebD_SetObjValueB("StartTime", rtnary[5]);
	////x HIS_EndDate                            His_enddate                   6      xx
	DHCWebD_SetObjValueB("EndDate", rtnary[6]);
	////x HIS_EndTime                            His_endtime                   7      xx
	DHCWebD_SetObjValueB("EndTime", rtnary[7]);
	////HIS_Amount                             His_amount                    8 
	DHCWebD_SetObjValueB("TotalFee", rtnary[8]);
	////x HIS_User                               His_user                      9      xx
	///rtnary[9]=session['LOGON.USERID'];		//////DHCWebD_SetObjValueB("");
	
	///var myNum=GetINVNum();
	////x His_Num                                His_Num                       10     xx
	///rtnary[10]=myNum;				///DHCWebD_SetObjValueB("");
	////x HIS_RcptNO                             HIS_RcptNO                    11     xx
	DHCWebD_SetObjValueB("INVNOinfo", rtnary[11]);
	////x HIS_Confirm                            HIS_Confirm                   12     xx
	////x HIS_Collect                            HIS_Collect                   13     xx
	////x HIS_INSFootDate                        HIS_INSFootDate               14     xx
	////x HIS_INSFootTime                        HIS_INSFootTime               15     xx
	////x HIS_INSFootUser                        HIS_INSFootUser               16     xx
	
	////Êµ¼ÊÉÏ½É¶î
	////x HIS_PatSum                             HIS_PatSum                    17     xx
	DHCWebD_SetObjValueB("HandSum", rtnary[17]);
	////HIS_CashNum                            HIS_CashNum                   18   
	DHCWebD_SetObjValueB("CashNUM", rtnary[18]);
	////HIS_CashSum                            HIS_CashSum                   19     x
	DHCWebD_SetObjValueB("CashSUM", rtnary[19]);
	////x HIS_CheckNum                           HIS_CheckNum                  20     x
	DHCWebD_SetObjValueB("CheckNUM", rtnary[20]);
	////x HIS_CheckSum                           HIS_CheckSum                  21     xk
	DHCWebD_SetObjValueB("CheckSUM", rtnary[21]);
	////x HIS_RefundNum                          HIS_RefundNum                 22     xx
	DHCWebD_SetObjValueB("RefundNUM", rtnary[22]);
	////x HIS_RefundSum                          HIS_RefundSum                 23     xx
	DHCWebD_SetObjValueB("RefundSUM", rtnary[23]);
	////x HIS_ParkNum                            HIS_ParkNum                   24     xx
	DHCWebD_SetObjValueB("CancelNUM", rtnary[24]);
	////x HIS_ParkSum                            HIS_ParkSum                   25     xx
	DHCWebD_SetObjValueB("CancelSUM", rtnary[25]);
	////x HIS_ParkINVInfo                        HIS_ParkINVInfo               26     xx
	DHCWebD_SetObjValueB("ParkINV", rtnary[26]);
	////x HIS_RefundINVInfo                      HIS_RefundINVInfo             27     xx
	DHCWebD_SetObjValueB("RefundINV", rtnary[27]);
	
	///HIS_StartDate
	
	////;Add more
	////>27   Write
	////x HIS_OterPayNum                         HIS_OterPayNum                28     xx
	////----->XRYBNum
	DHCWebD_SetObjValueB("XRYBNum", rtnary[28]);
	////x HIS_OterPaySum                         HIS_OterPaySum                29     xx
	////----->XRYBSum
	DHCWebD_SetObjValueB("XRYBSum", rtnary[29]);
	////x HIS_INVPrtNote                         HIS_Note3                     30     xx
	///rtnary[30]=""		////DHCWebD_SetObjValueB("");
	////x HIS_YBSum                               HIS_YBSum  for DHC_INVPRT t  31    
	////----->YBCardPay
	DHCWebD_SetObjValueB("YBCardPay", rtnary[31]);
	///alert(rtnary[31]);
	////x HIS_CardNum                            HIS_CardNum                   32     xx
	////----->CPPNum
	DHCWebD_SetObjValueB("CPPNum", rtnary[32]);
	////x HIS_CardSum                            HIS_CardSum                   33     xx
	////----->CPPSum
	DHCWebD_SetObjValueB("CPPSum", rtnary[33]);
	////x HIS_CardYBSum                          HIS_CardYBSum                 34 	
	////---->YBSelfPay
	DHCWebD_SetObjValueB("YBSelfPay", rtnary[34]);
	////x HIS_CardRefNum                         HIS_CardRefNum                35     xx
	////----->GFJZNum
	DHCWebD_SetObjValueB("GFJZNum", rtnary[35]);
	////x HIS_CardRefSum                         HIS_CardRefSum                36     xx
	////----->GFJZSum
	DHCWebD_SetObjValueB("GFJZSum", rtnary[36]);
	////x HIS_CardYBRefSum                       HIS_CardYBRefSum              37     xx
	////---->HTDWNum
	DHCWebD_SetObjValueB("HTDWNum", rtnary[37]);
	////x HIS_CardCashRefSum                     HIS_CardCashRefSum            38     xk
	////----->HTDWSum
	DHCWebD_SetObjValueB("HTDWSum", rtnary[38]);
	////x HIS_CardParkNum                        HIS_CardParkNum               39     xx
	////----->TJNum
	DHCWebD_SetObjValueB("TJNum", rtnary[39]);
	////x HIS_CardParkSum                        HIS_CardParkSum               40     xx
	////----->TJSum
	DHCWebD_SetObjValueB("TJSum", rtnary[40]);
	
	////x HIS_CardYBParkSum                      HIS_CardYBParkSum             41     xx
	////---->YBINVNum
	DHCWebD_SetObjValueB("YBINVNum", rtnary[41]);
	////HIS_CardCashParkSum 					 HIS_CardCashParkSum           42     x
	////rtnary[42]=DHCWebD_SetObjValueB("CardCashParkSum");
	////x HIS_CardParkINVInfo                    HIS_CardParkINVInfo           43     xx
	////rtnary[43]=DHCWebD_SetObjValueB("CardParkINVInfo");
	////x HIS_CardRefundINVInfo                  HIS_CardRefundINVInfo         44     xx
	////rtnary[44]=DHCWebD_SetObjValueB("CardRefundINVInfo");
	////x HIS_PosNum --> HIS_CPPNum              HIS_PosNum                    45     
	////rtnary[45]=DHCWebD_SetObjValueB("CPPNum");
	////HIS_PosSum   HIS_PosSum -->HIS_CPPSum        HIS_PosSum                    46     xx
	////rtnary[46]=DHCWebD_SetObjValueB("CPPSum");
	////HIS_Note3     HIS_GetTotal                   HIS_Note3                     47     x
	////rtnary[47]=DHCWebD_SetObjValueB("GetTotal");
	////x HIS_Note4   HIS_GiveTotal                  HIS_Note4                     48     x
	////rtnary[48]=DHCWebD_SetObjValueB("GiveTotal");
	////x HIS_Note5   HIS_CashTotal                  HIS_Note5                     49     xk
	////rtnary[49]=DHCWebD_SetObjValueB("CashTotal");
	////x HIS_Note6   HIS_CheckTotal                 HIS_Note6                     50     xx
	////rtnary[50]=DHCWebD_SetObjValueB("CheckTotal");
	////x HIS_Note7   HIS_OtherTotal                 HIS_Note7                     51     xx
	////rtnary[51]=DHCWebD_SetObjValueB("OtherTotal");
	
	////x HIS_Note8     HIS_PRDGetNum                HIS_Note8                     52     xx
	////rtnary[52]=DHCWebD_SetObjValueB("PRDGetNum");
	////x HIS_Note9     HIS_PRDGetSum                HIS_Note9                     53     xx
	////rtnary[53]=DHCWebD_SetObjValueB("PRDGetSum");
	////x HIS_Note10    HIS_PRDParkNum               HIS_Note10                    54     xx
	////rtnary[54]=DHCWebD_SetObjValueB("PRDParkNum");
	////x HIS_Note11    HIS_PRDParkSum               HIS_Note11                    55     xx
	////rtnary[55]=DHCWebD_SetObjValueB("PRDParkSum");
	////x HIS_Note12    HIS_PRDCashSum               HIS_Note12                    56    	
	////rtnary[56]=DHCWebD_SetObjValueB("PRDCashSum");
	////x HIS_PRDCheckSum 							 HIS_PRDCheckSum	           57    	
	////rtnary[57]=DHCWebD_SetObjValueB("PRDCheckSum");
	////  HIS_PRDOtherPaySum						 HIS_PRDOtherPaySum					58
	////rtnary[58]=DHCWebD_SetObjValueB("PRDOtherPaySum");
	
	////HIS_AccPFoot_DR                              HIS_Note1                     59     x
	////x HIS_AccPaySum                              HIS_AccPaySum                     60     x
	////rtnary[60]=DHCWebD_SetObjValueB("CPPPRTINVSum");
	////x HIS_FootFlag  User   System                    HIS_Note3                     61     xk
	///rtnary[61]="U";
	////x HIS_Note4                              HIS_Note4                     62     xx
	
	////x HIS_Note5                              HIS_Note5                     63     xx
	////x HIS_Note6                              HIS_Note6                     64     xx
	////x HIS_Note7                              HIS_Note7                     65    	
	////x HIS_Note8                              HIS_Note8                     66    	
	
}

document.body.onload=BodyLoadHandler;

