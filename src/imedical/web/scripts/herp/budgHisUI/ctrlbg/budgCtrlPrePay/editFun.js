///�޸���鿴
///isAudit=0 Ϊ�����ʱ���ã�Ϊ1ʱΪ���ʱ����
function EditFun(mainRow, isAudit){
	if(mainRow.BillState!="�½�"&&(mainRow.BillState!="����")){
	  	$("#AddUserbox").combobox({"disabled":true});
	  	$("#AddDeptbox").combobox({"disabled":true});
	  	$("#AddYMbox").combobox({"disabled":true});
	  	$("#contMethodbox").combobox({"disabled":true});
	  	$("#itemCodebox").combobox({"disabled":true});
	  	$("#ecoCodebox").combobox({"disabled":true});
	  	$("#purCodebox").combobox({"disabled":true});
	  	$("#AddDescbox").attr("disabled",true);
	  	$('#DelBt').linkbutton('disable');
	  	$('#ClearBt').linkbutton('disable');
	  	$('#printBt').linkbutton('disable');
	  	$('#AddSave').linkbutton('disable');
	  	addEditFun(mainRow, isAudit);
	}else{
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
	  	$('#AddSave').linkbutton('enable');
		addEditFun(mainRow, isAudit);
			}
	}