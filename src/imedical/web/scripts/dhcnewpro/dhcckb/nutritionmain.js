///Author:    qiaoqingao
$(function(){
	
	initEpisode();      /// 初始化加载病人就诊ID
	
	getPatBaseInfo();
	
	initNutInd();
	
	initArc();
	
	initNutForm();
});
/// 初始化加载病人就诊ID
function initEpisode(){
	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	PRESCNO = getParam("PRESCNO");;	///处方号
	ARCCONTENT='';  ///医嘱项
	
}

/// 病人就诊信息
function getPatBaseInfo(){
	
	$cm({
		ClassName:'web.DHCCKBNutritionMain',
		MethodName:'patEssInfo',
		"patId":"",
		"admId":EpisodeID
	},function(jsonData){
		$('.patMes').each(function(){
			var key=$(this).attr('data-name');
			$(this).html(jsonData[key]);
		})
	});
}

function initNutInd(){
	$cm({
		ClassName:'web.DHCCKBNutritionMain',
		MethodName:'listNurInd',
		admId:EpisodeID
	},function(jsonData){
		if(!jsonData.length) return;
		var htmlCont='';
		for (var i in jsonData){
			var thisData=jsonData[i];
			htmlCont+=
				'<div data-id="'+thisData.id+'">'+
					'<span class="i-b-80">'+thisData.desc+'</span><input class="textbox" value="'+thisData.thisValue+'"/>'+
				'</div>'
		}
		$('#indContent').html(htmlCont);
	});
}

function initArc(){
	$cm({
		ClassName:'web.DHCCKBNutritionMain',
		MethodName:'listArc',
		admId:EpisodeID,
		precNo:PRESCNO
	},function(jsonData){
		var html='';
		for(key in jsonData){
			var itmDatas=jsonData[key];
			html+=
				'<div class="cardOneContent">'+
					'<div class="cardTypeTitle">'+key+'</div>';
						for(i in itmDatas){
							html+=
							'<div class="cardItm" data-nutType="'+itmDatas[i].nutTypeId+'" data-uomId="'+itmDatas[i].uomId+'">'+
								'<span class="arcItmName">'+itmDatas[i].nutTypeDesc+'</span><input class="arcItmDose" value="'+itmDatas[i].dosc+itmDatas[i].uomDesc+'"/>'+
							'</div>'
						}
			html+=				
				'</div>'
		}
		$('#nutArcArea').html(html);
	});	
}

function initNutForm(){
	$cm({
		ClassName:'web.DHCCKBNutritionMain',
		MethodName:'listNutForm',
		admId:EpisodeID,
		precNo:PRESCNO,
		arcContent:''
	},function(jsonData){
		var html='<tr><th style="width:200px"></th><th style="width:200px">项目</th><th style="width:200px">值</th><th style="width:200px">推荐范围</th><th>备注</th></tr>';
		
		for(key in jsonData){
			var itmDatas=jsonData[key];

			for(i in itmDatas){
				html+=
					'<tr>'+
						(parseInt(i)?'':'<td rowspan='+itmDatas.length+'>'+key+'</td>')+'<td>'+itmDatas[i].desc+'</td><td>'+itmDatas[i].value+'</td><td>'+itmDatas[i].scope+'</td><td>'+itmDatas[i].note+'</td>'+
					'</tr>'
			}
			
		}
		//$('#nutFormArea').html(html);
		$('#nutFormTable').html(html);
	});	
}
