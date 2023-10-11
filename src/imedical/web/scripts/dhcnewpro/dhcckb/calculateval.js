/*������*/
var drugId = "";	//ҩƷid
$(function(){ 
	
	initButton();			//��ʼ����ť

})
///��ʼ����ť
function initButton()
{
	$("#calculate").bind("click",calculate);			// ���㼡�������
	
	$("#reset").bind("click",resetsrc);					// ����
	
	$("#surcalcu").bind("click",calbodysur);			// ����������
	
	$("#surreset").bind("click",resetsur);			    // ����
	
	$("#sodcalcu").bind("click",calsodcalcu);			// ����������
	
	$("#sodreset").bind("click",resetsod);			    // ����
	
	$HUI.combobox('#sodconrat',{
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'%3',text:'%3'},
			{id:'%5',text:'%5'}
		]
	});
	
	///ҩƷ
	
	var uniturl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryDrugList"  
	$HUI.combobox('#srcdrug',{
		url:uniturl,
		valueField:'value',
		textField:'text',
		panelHeight:"260",
		mode:'remote',
		onSelect:function(ret){
			if($("#clerate").val()==""){
				return;
			}
			calrecdose();
		}
	});
	
	
	
}
///���㼡�������
function calculate()
{
	
	var sex = $("input[name='sex']:checked").val();
	
	var age = $("#age").val();
	
	var weight = $("#weight").val();
	
	var scrval = $("#scrval").val();
	
	///���㹫ʽ
	///�У�Ccr = [(140-����)*����]/[0.818*scr]
	///Ů��Ccr = Ccr(��)*0.85
	var Ccr = ""
	if((sex!="")&&(age!="")&&(weight!="")&&(scrval!="")){
		var Ccr = [(140-age)*weight]/(72*scrval);
		if(sex == 2){
			Ccr = Ccr*0.85;
		}
	}
	$("#clerate").val(Ccr)
	 
}
///����
function resetsrc()
{
	$HUI.radio('input[name="sex"]').setValue(false);
	$("#age").val("");
	$("#weight").val("");
	$("#scrval").val("");
	$("#clerate").val("");
}
/// ����������
function calbodysur()
{
	var crowd = $("input[name='crowd']:checked").val();
	
	var height = $("#height").val();
	
	var surweight = $("#surweight").val();
	
	///���㹫ʽ
	///�У�Sur = 0.0057*height + 0.0121*surweight + 0.0882
	///Ů��Sur = 0.0073*height + 0.0127*surweight - 0.2106
	
	///��ͯ��surweight>30  Sur = 1.05 + (surweight-30)*0.02
	///��ͯ��surweight<30  Sur = surweight*0.035 + 0.1
	var Sur = ""
	if((crowd != "3")&&(height != "")&&(surweight != "")){
		if(crowd == 1){
			Sur = 0.0057*height + 0.0121*surweight + 0.0882;
		}else{
			Sur = 0.0073*height + 0.0127*surweight + 0.2106;
		}
	}else if((crowd == "3")&&(surweight != "")){
		if(surweight>30){
			Sur = 1.05 + (surweight-30)*0.02;
		}else{
			Sur = surweight*0.035 + 0.1;
		}
	}
	$("#bodysur").val(Sur);
}
///����������
function resetsur()
{
	$HUI.radio('input[name="crowd"]').setValue(false);
	$("#height").val("");
	$("#surweight").val("");
	$("#bodysur").val("");
}

///������ˮ
function calsodcalcu()
{
	var sex = $("input[name='sodsex']:checked").val();
	
	var tarbldsod = $("#tarbldsod").val();
	
	var meabldsod = $("#meabldsod").val();
	
	var sodweight = $("#sodweight").val();
	
	var sodconrat = $HUI.combobox("#sodconrat").getValue();
	
	///���㹫ʽ
	///�У�Ӧ��������ˮ(ml) = [142-Ѫ��(mmol/L)]*����(kg)*3.888
	///Ů��Ӧ��������ˮ(ml) = [142-Ѫ��(mmol/L)]*����(kg)*3.311
	var sodsat = ""
	if((sex!="")&&(tarbldsod!="")&&(meabldsod!="")&&(sodweight!="")&&(sodconrat!="")){
		
		if(sex == 1){
			sodsat = (142-meabldsod)*sodweight*3.888;
		}else{
			sodsat = (142-meabldsod)*sodweight*3.311;
		}
	}
	$("#sodsatcont").val(sodsat)
}
///����
function resetsod()
{
	$HUI.radio('input[name="sodsex"]').setValue(false);
	$("#tarbldsod").val("");
	$("#meabldsod").val("");
	$("#sodweight").val("");
	$("#sodconrat").combobox('setValue',"");
	$("#sodsatcont").val("");
}
///����ҩƷ�Ƽ�����
function calrecdose()
{
	if(drugId == ""){
		$.messager.alert('��ʾ',"��ѡ����Ҫ�Ƽ���ҩƷ��");
		return false;
	}
	
}