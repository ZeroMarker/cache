$(function(){
	InitComboDischargeCondition("Combo_DischargeConditionSel");
	//CreateWindow("Dialog_DischargeCondition");
	$("#BSave").click(BSaveClickHandle);
	$("#BCancel").click(BCancelClickHandle);
})
function BSaveClickHandle(){
	var DischargeConditionRowId=$("#Combo_DischargeConditionSel").combobox('getValue');
	if (websys_showModal('options').CallBackFunc) {
		websys_showModal('options').CallBackFunc(DischargeConditionRowId);
	}else{
		window.returnValue=DischargeConditionRowId;
		window.close();
	}
}
function BCancelClickHandle(){
	if (websys_showModal('options').CallBackFunc) {
		websys_showModal('options').CallBackFunc(null);
	}else{
		window.returnValue=null;
		window.close();
	}
}
function InitComboDischargeCondition(param1)
{
	$("#"+param1+"").combobox({      
    	valueField:'RowId',    
		textField:'Description',
		required:true,
		editable:false,
		url:"./dhcdoc.cure.query.combo.easyui.csp",
		onBeforeLoad:function(param){
			param.ClassName = 'web.DHCDocOrderEntry';
			param.QueryName = 'LookUpByLocationType';
			param.Arg1 ="";
			param.Arg2 ="I";
			param.ArgCnt =2;
		}  
	});
}
function CreateWindow(param1) {
	//Ĭ�Ͽ��
	var winWidth=300;
	var winHeight=150;
	//��ȡ���ڿ��
	if (window.innerWidth) winWidth = window.innerWidth;
	else if ((document.body) && (document.body.clientWidth)) winWidth = document.body.clientWidth;
	//��ȡ���ڸ߶�
	if (window.innerHeight) winHeight = window.innerHeight;
	else if ((document.body) && (document.body.clientHeight)) winHeight = document.body.clientHeight;
	$("#"+param1+"").dialog({
		width:winWidth,    
		height:winHeight,
		//title:"ѡ���Ժ����",
		closed:false,
		cache: false,
		modal:true,
		inline:true,
		buttons:[{
			text:'����',
			iconCls:'icon-save',
			handler:function(){
				var DischargeConditionRowId=$("#Combo_DischargeConditionSel").combobox('getValue');
				if (websys_showModal('options').CallBackFunc) {
					websys_showModal('options').CallBackFunc(DischargeConditionRowId);
				}else{
					window.returnValue=DischargeConditionRowId;
					window.close();
				}
			}
		},{
			text:'ȡ��',
			iconCls:'icon-cancel',
			handler:function(){
				if (websys_showModal('options').CallBackFunc) {
					websys_showModal('options').CallBackFunc(null);
				}else{
					window.returnValue=null;
					window.close();
				}
			}
		}]
	});
}
