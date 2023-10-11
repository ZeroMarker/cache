///新增
function addFun(){
	  	$("#AddApplyCbox").val("");
         $("#AddUserbox").combobox("setValue","");
         $("#AddUserbox").combobox({"disabled":false});
         $("#AddDeptbox").combobox("setValue","");
         $("#AddDeptbox").combobox({"disabled":false});
         $("#AddYMbox").combobox("setValue","");
         $("#AddYMbox").combobox({"disabled":false});
         $("#AddPaybox").combobox({"disabled":false});
         $("#AddPaybox").combobox('setValue',1);
         $("#contMethodbox").combobox({"disabled":false});
         $("#contMethodbox").combobox("setValue","报销项目");
         $("#itemCodebox").combobox({"disabled":false});
	  	 $("#itemCodebox").combobox("setValue","");
	  	 $("#ecoCodebox").combobox("setValue","");
         $("#ecoCodebox").combobox({"disabled":true});
	  	 $("#purCodebox").combobox("setValue","");
         $("#purCodebox").combobox({"disabled":true});
	  	 $("#AddNumberbox").attr("disabled",true);
         $("#AddNumberbox").val("");
	  	 $("#AddBankbox").attr("disabled",true);
         $("#AddBankbox").val("");
         $("#AddDescbox").attr("disabled",false);
         $("#AddDescbox").val("");
         $("#FundApplybox").val("");  //借款单号赋值为空
         $("#FundApplybox").attr("disabled",true);  //借款单号 
         $("#PrePayBillbox").val("");  //借款单号赋值为空
         $("#PrePayBillbox").attr("disabled",true);  //借款单号
         $("#ChargeAgst").checkbox("uncheck");//冲抵借款 
         $("#ChargeAgst").checkbox("setDisable",false);//冲抵借款
         $("#PrePaybox").checkbox("uncheck");//预报销
         $("#PrePaybox").checkbox("setDisable",false);
	  	$('#DelBt').linkbutton('enable');
	  	$('#ClearBt').linkbutton('enable');
	  	$('#printBt').linkbutton('enable');
	  	addEditFun("");
			
	}