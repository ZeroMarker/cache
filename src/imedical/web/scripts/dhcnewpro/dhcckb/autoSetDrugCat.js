//===========================================================================================
// Author��      qunianpeng
// Date:		 					2020-05-10
// Description:	 �°��ٴ�֪ʶ��-ͨ��ͨ�����Զ����ɷ���
//===========================================================================================


/// ҳ���ʼ������
function initPageDefault(){

}

function SetDrugCat(){

	var Result = "";
	runClassMethod("web.DHCCKBUtil","SetDrugCatByGenerName",{},function(retString){
							if (retString == 1){
									Result = "�����ɹ���";
							}else
							{
								Result = "����ʧ�ܣ�";	
							}
		},'text',false);
		$.messager.popover({msg: Result,type:'success',timeout: 1000});
		OutPutRecord();	
	
}

function OutPutRecord(){
				var rtn = $cm({
					dataType:'text',
					ResultSetType:"Excel",
					ExcelName:"ͨ�������ɷ�������", //Ĭ��DHCCExcel
					ClassName:"web.DHCCKBUtil",
					QueryName:"OutPutRecord"		
				},false);
				location.href = rtn;

}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
