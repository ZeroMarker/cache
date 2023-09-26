///CreatDate:  2018-07-11
///Author:     zhouxin
/// green.rec.js
/// 
$(function(){
	initBtn();
	initDefault();
})
function initBtn(){
	$('#addBTN').on('click',function(){saveGreen("Y")})
	$('#cancelBTN').on('click',function(){cancelAction()})
}

function cancelAction(){
	
	 var rowData = $('#datagrid').datagrid('getRows');  /// 绿色通道非开启状态不允许进行取消 2019-08-16 bianshuai
	 if ((rowData.length == 0)||(rowData[rowData.length-1].aliveHours == "")){
		 $.messager.alert('提示','绿色通道非开启状态不允许取消！', 'warning')
	 	return;
	 }
	 $.messager.confirm('提示', '确认要取消绿色通道吗',function(r){
		if (r){
			saveGreen("N");
		}
	 });		
}
function saveGreen(state){
	$.ajax({
     	url: LINK_CSP,
     	data: {
			'ClassName':'web.DHCEMPatGreenRec',
			'MethodName':'saveGreenRec',
			'adm':$("#EpisodeID").val(),
			'lgGrp':LgGroupID,
			'lgUser':LgUserID,
			'hours':$("#hours").val(),
			'state':state,
	 	},
     	dataType: "json",
    	success: function(data){
			if(data.code==0){
				search();
			}else{
				$.messager.alert('提示','保存失败'+data.msg)
			}	
	    }
	 });	
}

function initDefault(){
	//绿色通道时效启用
	if(GreenEffectSwitch>0){
		$("#hours").val(GreenEffectSwitch)
		//是否可以修改时长
		if(GreenModifyTime==1){
			$("#hours").attr("disabled",false)
		}else{
			$("#hours").attr("disabled",true)
		}	
	}else{
		$("#hoursSpan").hide()	
	}
	search();
}

function search(){
	
	$('#datagrid').datagrid('load', {
    	'adm':$("#EpisodeID").val()
	})
}	