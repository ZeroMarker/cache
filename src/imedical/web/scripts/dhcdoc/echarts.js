$(function(){
	var ColCnt=ServerObj.ColCnt;
	var trStr="";
	for(var i=0;i<ServerObj.IndicateRows.length;i++){
		var IndicateObj=ServerObj.IndicateRows[i];
		if(ColCnt==ServerObj.ColCnt){
			trStr='<div class="container">';
		}
		trStr+='<div id="'+IndicateObj.Code+'"></div>';
		if(!--ColCnt){
			trStr+="</div>";
			ColCnt=ServerObj.ColCnt;
			$('#main').append(trStr);
			trStr="";
		}
	}
	if(trStr!=''){
		trStr+="</div>";
		$('#main').append(trStr);
	}
	LoadIndicate();
    $('#pMain').panel({
		onResize:function(){
			$('.container').children().each(function(){
				$(this).echarts('resize');
			});
		}
	});
    $('.last-month').click(function(){RefreshMonth(-1);});
    $('.next-month').click(function(){RefreshMonth(1);});
});
function RefreshMonth(Flag)
{
    var Y=ServerObj.CurMonth.split('-')[0];
    var M=ServerObj.CurMonth.split('-')[1];
    M=Number(M)+Flag;
    if(M>12) M=1,Y=Number(Y)+1;
    if(M<1) M=12,Y=Number(Y)-1;
    if(M<10) M='0'+M;
    ServerObj.CurMonth=Y+'-'+M;
    LoadIndicate();
}
function LoadIndicate()
{
	$.each(ServerObj.IndicateRows,function(index,IndicateObj){
		switch(IndicateObj.ChartType){
			case 'bar':InitBase(IndicateObj);break;
			case 'line':InitBase(IndicateObj);break;
			case 'pie':InitBase(IndicateObj);break;
			case 'gauge':InitGauge(IndicateObj);break;
			case 'icon':InitIcon(IndicateObj);break;
			default:break;
		}
	});
}
function InitBase(IndicateObj)
{
	var LoadTimer;
	var chartObj={
	        backgroundColor:IndicateObj.backgroundColor,
            title: { text:IndicateObj.Text},
            tooltip:{trigger: IndicateObj.tooltipTrigger},
            xAxis: {type: 'category' },
            yAxis: {}
        };
    if(IndicateObj.dimensionColor!=""){
		$.extend(chartObj,{color:IndicateObj.dimensionColor.split(",")});
	}
	$('#'+IndicateObj.Code).echarts({
        echarts:chartObj,
        theme:IndicateObj.Theme,
        showLegend:true,
        type: IndicateObj.ChartType,
        yAxisField:IndicateObj.yAxisField,
        xAxisField:IndicateObj.xAxisField,
        dimensionField:IndicateObj.dimensionField,
        smooth:IndicateObj.smooth,
        ClassName:IndicateObj.ClassName,
        QueryName:IndicateObj.QueryName,
        onBeforeLoad:function(param){
	        clearTimeout(LoadTimer);
            $.extend(param,IndicateObj.ArgsObj,GetSearchDate());
        },
        onLoadSuccess:function(data){
	    	if(parseFloat(IndicateObj.refreshSecond)>0){
		    	LoadTimer=setTimeout(function(){
			    	$('#'+IndicateObj.Code).echarts('reload');
			    },parseFloat(IndicateObj.refreshSecond)*1000);
		    }
	    }
    });
}
function InitGauge(IndicateObj){
	var myChart = echarts.init($('#'+IndicateObj.Code)[0],'dark');
    myChart.setOption({
	    backgroundColor:IndicateObj.backgroundColor,
        series: [{
            type: 'gauge',
            min: 0,
            max: 100,
            splitNumber: 10,
            itemStyle: {
                color: '#58D9F9'
            },
            progress: {
                show: true,
                width: 10
            },
            pointer: {
                show: false
            },
            axisLine: {
                lineStyle: {
                    width: 10
                }
            },
            axisTick: {
                distance: -15,
                splitNumber: 5,
                lineStyle: {
                    width: 2,
                    color: 'auto'
                }
            },
            splitLine: {
                distance: -10,
                length: 10,
                lineStyle: {
                    width: 1,
                    color: 'auto'
                }
            },
            axisLabel: {
	            show: false,
                distance: -20,
                color: '#fff',
                fontSize: 10
            },
            anchor: {
                show: false
            },
            title: {
                fontSize: 14,
            	offsetCenter: [0, '100%'],
            	textStyle:{
	            	color:'#fff'
            	}
            },
            detail: {
                valueAnimation: true,
                width: '60%',
                lineHeight: 40,
                borderRadius: 8,
                offsetCenter: [0, '-10%'],
                fontSize: 16,
                fontWeight: 'bolder',
               	formatter: IndicateObj.valueFormat,
                color: 'auto'
            },
            data: [{
                value: IndicateObj.MethodValue,
                name: IndicateObj.Text
            }]
        }]
    });
    //兼容echarts/jquery.js 插件写法 使得支持hisui方法调用方式
    $.data($('#'+IndicateObj.Code)[0],'echarts',{chartObj:myChart});
	if(IndicateObj.linkUrl){
   		myChart.getZr().on('click',function(params){
			OpenWindow(IndicateObj.linkUrl,IndicateObj.Text,1600,700);
    	});
		$('#'+IndicateObj.Code).find('canvas').css('cursor','pointer');
	}
	if(parseFloat(IndicateObj.refreshSecond)>0){
		setInterval(function(){
			$.cm($.extend({
				ClassName:IndicateObj.ClassName,
				MethodName:IndicateObj.MethodName,
				dataType:'text'
			},IndicateObj.ArgsObj,GetSearchDate()),function(val){
				myChart.setOption({
					series: [{
						data: [{
							value:val,
							name: IndicateObj.Text
						}]
					}]
				});
			})
		},parseFloat(IndicateObj.refreshSecond)*1000);
	}
}
function InitIcon(IndicateObj)
{
	$('#'+IndicateObj.Code).empty();
	$('#'+IndicateObj.Code).addClass('single-main');
	$('#'+IndicateObj.Code).append('<div class="single-img"><img src="'+IndicateObj.imgSrc+'"/></div>');
	$('#'+IndicateObj.Code).append('<div class="single-data"><div class="single-val">'+IndicateObj.MethodValue+'</div><div class="single-title">'+IndicateObj.Text+'</div></div>');
	if(IndicateObj.linkUrl){
		$('#'+IndicateObj.Code).children().css('cursor','pointer').click(function(){
			OpenWindow(IndicateObj.linkUrl,IndicateObj.Text,1600,700);
		});
	}
	if(parseFloat(IndicateObj.refreshSecond)>0){
		setInterval(function(){
			$.cm($.extend({
				ClassName:IndicateObj.ClassName,
				MethodName:IndicateObj.MethodName,
				dataType:'text'
			},IndicateObj.ArgsObj,GetSearchDate()),function(val){
				$('#'+IndicateObj.Code).find('.single-val').text(val);
			});
		},parseFloat(IndicateObj.refreshSecond)*1000);
	}
}
function OpenWindow(url,name,iWidth,iHeight)
{
	url+="&AlonePage=1&userCode="+session['LOGON.USERCODE']+"&SSUSERGROUPID="+session['LOGON.GROUPID']+"&DEPARTMENTID="+session['LOGON.CTLOCID'];
	var mtop=websys_getTop();
	if(mtop&&mtop.parent&&mtop.parent.postMessage){
		if((url.indexOf('http:')!=0)&&(url.indexOf('https:')!=0)){
			url=window.location.origin+"/imedical/web/form.htm?CASTypeCode=MWHOSAuth2&"+url;
		}
		var list = {name:name,link:url,width:iWidth,height:iHeight};
		mtop.parent.postMessage( {embedWindow: list}, "*");
	}else{
		/*websys_showModal({
			iconCls:'icon-w-find',
			url:IndicateObj.linkUrl,
			title:IndicateObj.Text,
			width:'90%',height:'90%'
		});*/
		var iTop = (window.screen.height-30-iHeight)/2;       //获得窗口的垂直位置;
		var iLeft = (window.screen.width-10-iWidth)/2;        //获得窗口的水平位置;
		window.open(url,name,'height='+iHeight+',innerHeight='+iHeight+',width='+iWidth+',innerWidth='+iWidth+',top='+iTop+',left='+iLeft+',toolbar=no,menubar=no,scrollbars=auto,resizeable=no,location=no,status=no');
	}
}
function GetSearchDate()
{
	var Y=ServerObj.CurMonth.split('-')[0];
    var M=ServerObj.CurMonth.split('-')[1];
    var MonthFirstDate=Y+'-'+M+'-'+'01';
    var NextM=Number(M)+1;
    if(NextM>12) Y=Number(Y)+1,NextM=1;
    if(NextM<10) NextM='0'+NextM;
    var NextMonthFirstDate=Y+'-'+NextM+'-'+'01';
    var MonthLastDate=GetDateAddDays(NextMonthFirstDate,-1);
    return {SttDate:MonthFirstDate,EndDate:MonthLastDate};
}