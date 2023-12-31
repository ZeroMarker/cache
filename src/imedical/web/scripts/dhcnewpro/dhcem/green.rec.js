///CreatDate:  2018-07-11
///Author:     zhouxin
/// green.rec.js
/// 
$(function(){
	initPage();
	initBtn();
	initDefault();
	search();
	InitPatInfoBanner($("#EpisodeID").val()); 
})

function initBtn(){
	$('#addBTN').on('click',function(){openAction()})
	$('#cancelBTN').on('click',function(){cancelAction()})
}

function initPage(){
	hosNoPatOpenUrl = getParam("hosNoPatOpenUrl"); //hxy 2011-10-24 st
	hosNoPatOpenUrl?hosOpenPatList(hosNoPatOpenUrl):''; //ed
	var adm =$("#EpisodeID").val();
	var chk =$("#EmPCLvID").val();
	
	///分诊界面
	if((chk!="")&&(adm=="")){
		var admListData=$.cm({ 
			ClassName:"web.DHCEMPatGreenRec",
			MethodName:"ListChkAdm",
			chk:chk,
			lgHospID:LgHospID
		}, false);
		
		if(admListData.length){
			var lastData=admListData[admListData.length-1];
			$("#EpisodeID").val(lastData.value);
			adm=lastData.value;
			if(admListData.length>1){
				$("#admArea").show();
				$('#admList').combobox({
					valueField: 'value',
					textField: 'text',
					data:admListData,
					editable: false,
					blurValidValue:true,
					onSelect:function(option){
						$("#EpisodeID").val(option.value);
						search();
				    }
				});
				$('#admList').combobox("setValue",lastData.value);
			}
		}
	}
	
	///判断下就诊是否离院
	if(adm!=""){
		$.cm({ 
			ClassName:"web.DHCEMPatGreenRec",
			MethodName:"admStateIsNormal",
			adm:adm,
			dataType:"text"
		},function(ret){
			if(ret!="A"){
				var admStateDesc=ret;
				if(ret=="D") admStateDesc=$g("离院");
				if(ret=="C") admStateDesc=$g("退号");
				$.messager.alert("提示",$g("当前就诊非正常状态")+","+$g("禁止开启绿通")+"!"+$g("当前就诊状态")+":"+admStateDesc);
				$HUI.linkbutton("#addBTN").disable();
			}
		});
	}
	
	//绿色通道申请原因 hxy 2022-07-14
	$('#GreRea').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMDicItem&MethodName=jsonConsItem&HospID='+LgHospID+'&mCode=GreenRea',
		valueField: 'value',
		textField: 'text',
		panelHeight:"auto",
		blurValidValue:true
	})
		
}

function cancelAction(){
	 
	var IsGreenPat=isGreenPat();
	
	if (IsGreenPat!="1"){ //是
		$.messager.alert('提示','绿色通道非开启状态不允许取消！', 'warning')
		return;
	}

	$.messager.confirm('提示', '确认要取消绿色通道吗',function(r){
		if (r){
			saveGreen("N");
		}
	});
}

function openAction(){
	var IsGreenPat=isGreenPat();
	if (IsGreenPat=="1"){ //是
		$.messager.alert('提示','已是绿色通道开启状态的病人,不允许再次开启!', 'warning')
		return;
	}
	var GreRea= $("#GreRea").combobox("getValue"); //绿色通道申请原因
	if(GreRea==undefined)GreRea="";
	if((GREENAUDIT==1)&&(GreRea=="")){
		$.messager.alert("提示:","申请原因不能为空！");
		return;	
	}
	$.messager.confirm('提示', '确认要开启绿色通道吗',function(r){
		if (r){
			saveGreen("Y",GreRea);
		}
	});	
}

function isGreenPatOld(){
	return $.cm({ 
		ClassName:"web.DHCEMDocMainOutPat",
		MethodName:"GetEmPatGreenFlag",
		EmPCLvID:$("#EmPCLvID").val(),
		EpisodeID:$("#EpisodeID").val(),
		dataType:"text"
	}, false);
}

function isGreenPat(){
	return $.cm({ 
		ClassName:"web.DHCEMPatGreenRec",
		MethodName:"checkGreenRec",
		chk:$("#EmPCLvID").val(),
		adm:$("#EpisodeID").val(),
		Flag:'Y',
		dataType:"text"
	}, false);
}

function saveGreen(state,GreRea){
	
	$.ajax({
     	url: LINK_CSP,
     	data: {
			'ClassName':'web.DHCEMPatGreenRec',
			'MethodName':'saveGreenRec',
			'adm':$("#EpisodeID").val(),
			'chk':$("#EmPCLvID").val(),
			'lgGrp':LgGroupID,
			'lgUser':LgUserID,
			'hours':$("#hours").val(),
			'state':state,
			'GreRea':GreRea
	 	},
     	dataType: "text",
    	success: function(data){
			if(data==0){
				search();
			}else{
				$.messager.alert('提示',$g('保存失败')+data)
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
    	'adm':$("#EpisodeID").val(),
    	'chk':$('#EmPCLvID').val(),
    	'hosp':LgHospID
	})
}	
