/*计算器*/
var drugId = "";	//药品id
$(function(){ 
	
	initButton();			//初始化按钮

})
///初始化按钮
function initButton()
{
	$("#calculate").bind("click",calculate);			// 计算肌酐清除率
	
	$("#reset").bind("click",resetsrc);					// 重置
	
	$("#surcalcu").bind("click",calbodysur);			// 计算体表面积
	
	$("#surreset").bind("click",resetsur);			    // 重置
	
	$("#sodcalcu").bind("click",calsodcalcu);			// 计算体表面积
	
	$("#sodreset").bind("click",resetsod);			    // 重置
	
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
	
	///药品
	
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
///计算肌酐清除率
function calculate()
{
	
	var sex = $("input[name='sex']:checked").val();
	
	var age = $("#age").val();
	
	var weight = $("#weight").val();
	
	var scrval = $("#scrval").val();
	
	///计算公式
	///男：Ccr = [(140-年龄)*体重]/[0.818*scr]
	///女：Ccr = Ccr(男)*0.85
	var Ccr = ""
	if((sex!="")&&(age!="")&&(weight!="")&&(scrval!="")){
		var Ccr = [(140-age)*weight]/(72*scrval);
		if(sex == 2){
			Ccr = Ccr*0.85;
		}
	}
	$("#clerate").val(Ccr)
	 
}
///重置
function resetsrc()
{
	$HUI.radio('input[name="sex"]').setValue(false);
	$("#age").val("");
	$("#weight").val("");
	$("#scrval").val("");
	$("#clerate").val("");
}
/// 计算体表面积
function calbodysur()
{
	var crowd = $("input[name='crowd']:checked").val();
	
	var height = $("#height").val();
	
	var surweight = $("#surweight").val();
	
	///计算公式
	///男：Sur = 0.0057*height + 0.0121*surweight + 0.0882
	///女：Sur = 0.0073*height + 0.0127*surweight - 0.2106
	
	///儿童：surweight>30  Sur = 1.05 + (surweight-30)*0.02
	///儿童：surweight<30  Sur = surweight*0.035 + 0.1
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
///重置体表面积
function resetsur()
{
	$HUI.radio('input[name="crowd"]').setValue(false);
	$("#height").val("");
	$("#surweight").val("");
	$("#bodysur").val("");
}

///生理盐水
function calsodcalcu()
{
	var sex = $("input[name='sodsex']:checked").val();
	
	var tarbldsod = $("#tarbldsod").val();
	
	var meabldsod = $("#meabldsod").val();
	
	var sodweight = $("#sodweight").val();
	
	var sodconrat = $HUI.combobox("#sodconrat").getValue();
	
	///计算公式
	///男：应补生理盐水(ml) = [142-血钠(mmol/L)]*体重(kg)*3.888
	///女：应补生理盐水(ml) = [142-血钠(mmol/L)]*体重(kg)*3.311
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
///重置
function resetsod()
{
	$HUI.radio('input[name="sodsex"]').setValue(false);
	$("#tarbldsod").val("");
	$("#meabldsod").val("");
	$("#sodweight").val("");
	$("#sodconrat").combobox('setValue',"");
	$("#sodsatcont").val("");
}
///计算药品推荐剂量
function calrecdose()
{
	if(drugId == ""){
		$.messager.alert('提示',"请选择需要推荐的药品！");
		return false;
	}
	
}