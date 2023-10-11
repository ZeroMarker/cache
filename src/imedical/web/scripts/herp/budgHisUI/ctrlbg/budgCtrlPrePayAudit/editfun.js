///修改与查看
function EditFun(mainRow, isAudit){
	///alert(111)
	  	$("#AddUserbox").combobox({"disabled":true});
	  	$("#AddDeptbox").combobox({"disabled":true});
	  	$("#AddYMbox").combobox({"disabled":true});
	  	$("#AddPaybox").combobox({"disabled":true});
	  	$("#contMethodbox").combobox({"disabled":true});
	  	$("#itemCodebox").combobox({"disabled":true});
	  	$("#ecoCodebox").combobox({"disabled":true});
	  	$("#purCodebox").combobox({"disabled":true});
	  	$("#AddNumberbox").attr("disabled",true);
	  	$("#AddBankbox").attr("disabled",true);
	  	$("#AddDescbox").attr("disabled",true);
	  	$('#DelBt').linkbutton('disable');
	  	$('#ClearBt').linkbutton('disable');
	  	$('#printBt').linkbutton('disable');
	  	$('#AddSave').linkbutton('disable');
	  	if(mainRow.BillState =="完成"){
		  	$("#contMethodbox").combobox({"disabled":true});
	  		$("#itemCodebox").combobox({"disabled":true});
	  		$("#ecoCodebox").combobox({"disabled":true});
	  		$("#purCodebox").combobox({"disabled":true});
	  		$('#AddSave').linkbutton('disable');
	  	}else{
		  	$.m({
	         ClassName: 'herp.budg.hisui.udata.uBudgFundApply',
	         MethodName: 'listIsCurStep',
	         billid: mainRow.rowid,
	         userid: userid,
	         billtype: 5
	         },
        function (rtn) {
	        ///如果不是当前步骤，那么取消编辑
	           if(rtn == 1){
		           $("#contMethodbox").combobox({"disabled":false});
	  			   $("#itemCodebox").combobox({"disabled":false});
	  			   $("#ecoCodebox").combobox({"disabled":false});
	  			   $("#purCodebox").combobox({"disabled":false});
	  			   $('#AddSave').linkbutton('enable');
	           }
           })
	  		}
	  		//$('#AddBankbox').textbox('textbox').attr('readonly',true);
	  		//$('#AddNumberbox').textbox('textbox').attr('readonly',true);
	  		//$('#AddDescbox').textbox('textbox').attr('readonly',true); 
	  	addEditFun(mainRow, isAudit);
	}