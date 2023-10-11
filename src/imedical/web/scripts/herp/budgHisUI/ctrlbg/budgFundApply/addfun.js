///新增
function addFun(){
	  	$("#AddUserbox").combobox({"disabled":false});
	  	$("#AddDeptbox").combobox({"disabled":false});
	  	$("#AddYMbox").combobox({"disabled":false});
	  	$("#AddPaybox").combobox({"disabled":false});
	  	$("#contMethodbox").combobox({"disabled":false});
	  	$("#itemCodebox").combobox({"disabled":false});
	  	$("#ecoCodebox").combobox({"disabled":false});
	  	$("#purCodebox").combobox({"disabled":false});
	  	$("#AddNumberbox").attr("disabled",false);
	  	$("#AddBankbox").attr("disabled",false);
	  	$("#AddDescbox").attr("disabled",false);
	  	$('#DelBt').linkbutton('enable');
	  	$('#ClearBt').linkbutton('enable');
	  	$('#printBt').linkbutton('enable');
	  	$('#AddSave').linkbutton('enable');
	  	//$('#AddBankbox').textbox('textbox').attr('readonly',true);
	  	//$('#AddNumberbox').textbox('textbox').attr('readonly',true);
	  	//$('#AddDescbox').textbox('textbox').attr('readonly',true); 
	  	addEditFun("","100");
			
	}