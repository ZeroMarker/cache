///qqa

$(function(){
	///���ý��涯̬�߶�
	initPage();	
	
	initDateBox();
	
	initDatagrid();
	
	initMethod();
	
	initRunMethod();
	
	initCss();
	//showImg();
	
})

function initCss(){
	if(HISUIStyleCode==="lite"){
		$(".heading").css("background","none")
	}
}

///Ĭ����Ҫִ�еķ���
function initRunMethod(){
	search();
}

function initDateBox(){
	$HUI.datebox("#stDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}


function initDatagrid(){
	
	var columns=[[
          { field: 'field1', title: '����', width: 100, sortable: false, align: 'center' },
          { field: 'field2', title: '����', width: 100, sortable: false, align: 'center' },
        ]]

	$HUI.datagrid('#keptBedTable',{
		url:LINK_CSP+"?ClassName=web.DHCEMKeptPatAna&MethodName=JsonBedTable&HospID="+HospID,
		bodyCls:'panel-header-gray', //hxy 2022-11-18
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		singleSelect:true,
		pageSize:60,  
		pageList:[60],
		loadMsg: $g('���ڼ�����Ϣ...'),
		rownumbers : false,
		showHeader:false,
		pagination:false,
		
		onSelect:function (rowIndex, rowData){
			
		},
		onLoadSuccess:function(data){
			var imgData = data.imgData;
			showEchartBars("showImgBedInfo",imgData.DataCheck,$g("Ԥ��ּ�"));
			showEchartBars("showImgPatInfo",imgData.DataSex,$g("�Ա�"));
		}
	});
		
}

function initMethod(){
	$("#search").on("click",search)
}

function initPage(){

	var heightEchart = $("#getHeightDiv").height()-20;
	
	///ͼ��ĸ߶�
	$(".echartBody").each(function (){
		$(this).height(heightEchart);	
	})
	///ͼ��ĸ߶�
	$(".echartBodyPie").each(function (){
		$(this).height(heightEchart-40);	
	})
}

function showImg(){
	var data = [{name:$g("��һ"),group:$g("��λ"),value:4},{name:$g("�ܶ�"),group:$g("��λ"),value:6},{name:$g("����"),group:$g("��λ"),value:1},{name:$g("����"),group:$g("��λ"),value:3},{name:$g("����"),group:$g("��λ"),value:4},{name:$g("����"),group:$g("��λ"),value:4},{name:$g("��ĩ"),group:$g("��λ"),value:4}]
	showEchartBars("showImgBedInfo",data);		
}

function search(){
	var stDate = $HUI.datebox("#stDate").getValue();
	var endDate = $HUI.datebox("#endDate").getValue();
	var params = HospID+"^"+stDate+"^"+endDate;
	runClassMethod("web.DHCEMKeptPatAna","GetObsAreaAnaData",
		{
			Params:params	
		},
		function(data){
			showPageImg(data);
		}	
	)
	
	//showEchartBars(data); //����ͼ
	//showEchartPie(data); //ԭ��ͼ	
}

function showPageImg(data){
	var allNumData = data.ObsPatNum;
	if(allNumData!==""){
		for (i=0;i<allNumData.split(":").length;i++){
			var NumData = allNumData.split(":")[i];
			$("span[name='"+NumData.split("^")[0].escapeJquery()+"']").html(NumData.split("^")[1]);
		}
	}else{
		$(".tdDiv").find(".tdRightDivBottomSpan").html(0);	
	}
	
	var QsPatNum = data.QsPatNum;
	if(QsPatNum.length){
		showEchartPie("fjrsEcharts",QsPatNum,$g("�ּ�����ͳ��"));
	}else{
		showEchartPie("fjrsEcharts",['',''],$g("�ּ�����ͳ��"));	
	}
	
	var ParseInPatNum = data.ParseInPatNum;
	if(ParseInPatNum.length){
		showEchartBars("zryksEcharts",ParseInPatNum,$g("ת��Ժ����ͳ��"));
	}else{
		showEchartBars("zryksEcharts",[],$g("ת��Ժ����ͳ��"));	
	}
	
	var KeyDiseasePatNum = data.KeyDiseasePatNum;
	if(KeyDiseasePatNum.length){
		showEchartPie("zdbzEcharts",KeyDiseasePatNum,$g("�ص㲡�ֲַ�"));
	}else{
		showEchartPie("zdbzEcharts",['',''],$g("�ص㲡�ֲַ�"));	
	}
	
	var InLocPatNum = data.InLocPatNum;
	if(InLocPatNum.length){
		showEchartBars("zkztEcharts",InLocPatNum,$g("�ڿ�״̬ͳ��"));
	}else{
		showEchartBars("zkztEcharts",[],$g("�ڿ�״̬ͳ��"));
	}
	return;
	
	var GreenPatNum = data.GreenPatNum;
	showEchartPie("lstdEcharts",GreenPatNum);
	
	var PatGetSource= data.PatGetSource;
	showEchartPie("brlyEcharts",PatGetSource);

	var QsPatNum= data.QsPatNum;
	showEchartPie("qsryEcharts",QsPatNum);

	var ThreeNoPatNum= data.ThreeNoPatNum;
	showEchartPie("swryEcharts",ThreeNoPatNum);
	
	
	var PatAgeAnalysess= data.PatAgeAnalysess;
	//alert(PatAgeAnalysess.length);
	showEchartBars("fznlEcharts",PatAgeAnalysess);
	
	var PatCheckLocNum= data.PatCheckLocNum;
	showEchartBars("fzksEcharts",PatCheckLocNum);
	//var PatAgeAnalysess = [{"name":"<1","value":"0"},{"name":"1-10","value":"0"},{"name":"10-20","value":"0"},{"name":"20-30","value":"0"},{"name":"30-40","value":"0"},{"name":"40-50","value":"0"},{"name":"60-70","value":"0"},{"name":"70-80","value":"0"},{"name":"80-90","value":"0"},{"name":"90-100","value":"0"},{"name":">100","value":"0"}]
	//showEchartPie("fznlEcharts",PatAgeAnalysess);
}


function showEchartBars(idName,data,saveName){
	var obj={
		grid:{
			y:40	
		},
		toolbox: {
	   			showTitle:false,
                show: true, //�Ƿ���ʾ������
                feature: {
                	mark : { show: true }, //����
                    restore : { show: true }, //��ԭ
                    saveAsImage : { show: true,name:saveName}, //�Ƿ񱣴�ͼƬ
                    magicType : { show: true, type: ['line', 'bar']} //֧������ͼ������ͼ���л� 
                }
        }
	}
	var option = ECharts.ChartOptionTemplates.Bars(data,"","",obj); 
	option.title ={
		
	}
	
	var container = document.getElementById(idName);
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);	
}

function showEchartPie(idName,data,saveName){
	if(idName=="fjrsEcharts"){
		var obj={
		color: ['#BCBCBC','#f00', '#ff793e', '#f9bf3b','#13987e'],
		toolbox: {
	   			showTitle:false,
                show: true, //�Ƿ���ʾ������
                feature: {
                	mark : { show: true }, //����
                    restore : { show: true }, //��ԭ
                    saveAsImage : { show: true,name:saveName}, //�Ƿ񱣴�ͼƬ
                }
        }
		}
	}else{
		var obj={
			toolbox: {
		   			showTitle:false,
	                show: true, //�Ƿ���ʾ������
	                feature: {
	                	mark : { show: true }, //����
	                    restore : { show: true }, //��ԭ
	                    saveAsImage : { show: true,name:saveName}, //�Ƿ񱣴�ͼƬ
	                }
	        }
		}
	}
	var option = ECharts.ChartOptionTemplates.Pie(data,"",obj); 
	option.title ={
		
	}
	var container = document.getElementById(idName);
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);	
}


String.prototype.escapeJquery=function() {
    // ת��֮��Ľ��
    var escapseResult = this;
    // javascript������ʽ�е������ַ�
    var jsSpecialChars = ["\\", "^", "$", "*", "?", ".", "+", "(", ")", "[",
        "]", "|", "{", "}"
    ];

    // jquery�е������ַ�,����������ʽ�е������ַ�
    var jquerySpecialChars = ["~", "`", "@", "#", "%", "&", "=", "'", "\"",
        ":", ";", "<", ">", ",", "/"
    ];

    for (var i = 0; i < jsSpecialChars.length; i++) {
        escapseResult = escapseResult.replace(new RegExp("\\" +
                jsSpecialChars[i], "g"), "\\" +
            jsSpecialChars[i]);
    }

    for (var i = 0; i < jquerySpecialChars.length; i++) {
        escapseResult = escapseResult.replace(new RegExp(jquerySpecialChars[i],
            "g"), "\\" + jquerySpecialChars[i]);
    }

    return escapseResult;
}
