///修改与查看
function EditFun(mainRow, isAudit){
	    //$("#addButton").unbind()
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
	  		$("#AddPaybox").combobox({"disabled":true});
	  		$("#AddNumberbox").attr("disabled",true);
	  		$("#AddBankbox").attr("disabled",true);
	  		$("#AddDescbox").attr("disabled",true);
	  		$('#AddSave').linkbutton('disable');
	  	}else{
		  	$.m({
	         ClassName: 'herp.budg.hisui.udata.uBudgFundApply',
	         MethodName: 'listIsCurStep',
	         billid: mainRow.rowid,
	         userid: userid,
	         billtype: 4
	         },
        	function (rtn) {
	        //console.log(rtn);
	        //是当前操作步骤
	           if(rtn == 1){
		           $("#AddPaybox").combobox({"disabled":false});
		           $("#AddNumberbox").attr("disabled",false);
	  			   $("#AddBankbox").attr("disabled",false);
	  			   $("#AddDescbox").attr("disabled",false);
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