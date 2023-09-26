//add hu 14.5.23
//dhcjfconfig.js
//取住院配置
function DHCJFConfig() {

	this.stDate = "";  //配置起效期
	this.refYjPrtFlag = "Y"; //退押金是否打印负票0
	this.refFpPrtFlag = "N";  //取消结算是否打印负票1
	this.refFpFlag = "N";  //收款员未交帐取消结算是否按作废方式处理2
	this.refYjFlag = "N";  //收款员未交帐退押金是否按作废方式处理3
	this.abortYjPrtFlag = "Y";  //作废押金是否自动打印新押金收据4
	this.abortFpPrtFlag = "Y"; //作废发票是否自动打印新发票5
	this.selYjPayFlag = "N";  //结算患者费用时是否可以选择押金6
	this.depositFlag = "N";  //住院登记界面是否能直接交押金7
	this.linkDepositFlag = "N";  //院登记界面是否调用交押金程序8
	this.patinFlag = "N"; //登记界面是否可以修改入院日期9
	this.patnoFlag = "N";  //是否必须录入登记号才能办理入院登记10
	this.medicareFlag = "Y";  //是否自动生成病案号11
	this.refYjPaymFlag = "N";  //退押金是否允许修改支付模式12
	this.patFeeConfirmFlag = "N";  //财务结算费用审核13
	this.prtFpMoreFlag = "N"; //打印多张发票14
	this.qfFpPrtFlag = "Y";  //欠费结算是否打印发票15
	this.outUseBCFlag = "";  //出院带药是否按计费点计费16
	this.insuPayFlag = "Y";  //医保病人是否允许中途结算17
	this.bankBackPayFlag = "Y";  //结算时未到账预交金支票是否参与运算18

	var rtn = tkMakeServerCall("web.UDHCJFCOMMON", "getzyjfconfig");
	if(rtn != "") {
		var str = rtn.split("##");
		var strConfig = str[0];
		if(str.length == 2) {
			var stdateStr = str[1];
			this.stDate = stdateStr;
		}
		
		if(strConfig != "") {
			var str1 = strConfig.split("^");
			var str2 = "";
			str2=str1[0].split("@");
			this.refYjPrtFlag = str2[1];
			str2=str1[1].split("@");
			this.refFpPrtFlag = str2[1];
			str2=str1[2].split("@");
			this.refFpFlag = str2[1];			
			str2=str1[3].split("@");
			this.refYjFlag = str2[1];			
			str2=str1[4].split("@");
			this.abortYjPrtFlag = str2[1];
			str2=str1[5].split("@");
			this.abortFpPrtFlag = str2[1];

			str2=str1[6].split("@");
			this.selYjPayFlag = str2[1];
			str2=str1[7].split("@");
			this.depositFlag = str2[1];
			str2=str1[8].split("@");
			this.linkDepositFlag = str2[1];
			str2=str1[9].split("@");
			this.patinFlag = str2[1];
			str2=str1[10].split("@");
			this.patnoFlag = str2[1];
			str2=str1[11].split("@");
			this.medicareFlag = str2[1];
			str2=str1[12].split("@");
			this.refYjPaymFlag = str2[1];
			str2=str1[13].split("@");
			this.patFeeConfirmFlag = str2[1];

			str2=str1[14].split("@");
			this.prtFpMoreFlag = str2[1];
			str2=str1[15].split("@");
			this.qfFpPrtFlag = str2[1];
			str2=str1[16].split("@");
			this.outUseBCFlag = str2[1];
			str2=str1[17].split("@");
			this.insuPayFlag = str2[1];
			str2=str1[18].split("@");
			this.bankBackPayFlag = str2[1];
		}
	}
}