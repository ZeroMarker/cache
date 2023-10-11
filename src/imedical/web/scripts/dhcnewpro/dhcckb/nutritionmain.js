///Author:    qiaoqingao
$(function(){
	
	initEpisode();      /// ��ʼ�����ز��˾���ID
	
	getPatBaseInfo();
	
	initNutInd();
	
	initArc();
	
	initNutForm();
});
/// ��ʼ�����ز��˾���ID
function initEpisode(){
	PatientID = getParam("PatientID");   /// ����ID
	EpisodeID = getParam("EpisodeID");   /// ����ID
	PRESCNO = getParam("PRESCNO");;	///������
	ARCCONTENT='';  ///ҽ����
	
}

/// ���˾�����Ϣ
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
		var html='<tr><th style="width:200px"></th><th style="width:200px">��Ŀ</th><th style="width:200px">ֵ</th><th style="width:200px">�Ƽ���Χ</th><th>��ע</th></tr>';
		
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
