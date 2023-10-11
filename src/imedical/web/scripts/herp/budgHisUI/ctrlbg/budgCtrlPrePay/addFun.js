function addFun(){
	  	$("#AddUserbox").combobox({"disabled":false});
	  	$("#AddDeptbox").combobox({"disabled":false});
	  	$("#AddYMbox").combobox({"disabled":false});
	  	$("#contMethodbox").combobox({"disabled":false});
	  	$("#itemCodebox").combobox({"disabled":false});
	  	$("#ecoCodebox").combobox({"disabled":false});
	  	$("#purCodebox").combobox({"disabled":false});
	  	$("#AddDescbox").attr("disabled",false);
	  	$('#DelBt').linkbutton('enable');
	  	$('#ClearBt').linkbutton('enable');
	  	$('#printBt').linkbutton('enable');
	  	addEditFun("","100");
}