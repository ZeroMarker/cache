(function($){
    $.fn.echarts = function(opts){
        if(typeof opts == 'string'){
            var method = $.fn.echarts.methods[opts];
            if (method){
                arguments[0]=this;
                return method.apply(this,arguments);
            }else if(this[0]){
                var chartObj=elementData(this[0],'chartObj');
                if(chartObj&&(typeof chartObj[opts]=='function')){
	                var newArguments=new Array();
	                for(var i=1;i<arguments.length;i++){
	                    newArguments.push(arguments[i]);
	                }
	                return chartObj[opts].apply(chartObj,newArguments);
                }
                return this;
            }
        }else{
            opts = opts || {};
            opts=$.extend({}, $.fn.echarts.defaults,opts);
            return this.each(function(){
                elementData(this,'options',opts);
                $(this).echarts('init');
            });
        }
    }
    $.fn.echarts.methods={
        options: function(jq){
            return elementData(jq[0],'options');
        },
        init:function(jq){
            return jq.each(function(){
                var target=this;
                var opts=$(target).echarts('options');
                var myChart= elementData(target,'chartObj');
                if(!myChart) myChart = echarts.init(target,opts.theme);
                elementData(target,'chartObj',myChart);
                myChart.setOption(opts.echarts);
                $(target).echarts('load');
                myChart.on('click', function(params) {
                    opts.onClick.call(target,params);
                }).on('dblclick', function(params) {
                    opts.onDblClick.call(target,params);
                }).on('contextmenu', function(params) {
                    opts.onContextMenu.call(target,params);
                });
            });
        },
        load:function(jq,param){
            return jq.each(function(index,element){
                var opts=$(this).echarts('options');
                if(!opts.url||!opts.ClassName||(!opts.QueryName&&!opts.MethodName)) return true;
                param=param||{};
                var newParam=$.extend({},{
                    ClassName:opts.ClassName,
                    QueryName:opts.QueryName,
                    MethodName:opts.MethodName
                },opts.queryParams);
                $.extend(newParam,param);
                if(opts.onBeforeLoad.call(this,newParam)==false) return true;
                $.extend(newParam,param);
                var chartObj= elementData(element,'chartObj');
                chartObj.showLoading();
                $.post(opts.url,newParam,function(data){
                    $(element).echarts('loadData',data);
                    chartObj.hideLoading();
                }, "json");
            });
        },
        loadData:function(jq,data){
            return jq.each(function(){
                var opts=$(this).echarts('options');
                var sourceData=data
                if(sourceData){
                    var filterData=opts.loadFilter.call(this,sourceData);
                    if(filterData!=undefined) sourceData=filterData;
                }
                var chartObj= elementData(this,'chartObj');
                var cfgData={};
                if(opts.type=='pie'){
	                cfgData=GetPieData(data,opts);
                }else{
	                cfgData=GeCfgByData(sourceData,opts);
	            }
                $.extend(opts.echarts,cfgData);
                chartObj.clear();
                chartObj.setOption(opts.echarts);
            });
            function GeCfgByData(data,opts){
                var yAxisField =opts.yAxisField;
                var xAxisField =opts.xAxisField;
                var dimensionField =opts.dimensionField;
                var xAxis=new Array();
                var legend=new Array();
                var dimensionObj=new Object();
                $.each(data,function(){
                    var yAxisValue=this[yAxisField];
                    var xAxisValue=this[xAxisField];
                    var dimensionValue=this[dimensionField];
                    if(xAxis.indexOf(xAxisValue)==-1){
                        xAxis.push(xAxisValue);
                    }
                    var index=xAxis.indexOf(xAxisValue);
                    if(!dimensionObj[dimensionValue]){
                        dimensionObj[dimensionValue]=new Array();
                        legend.push(dimensionValue);
                    }
                    dimensionObj[dimensionValue].splice(index,0,yAxisValue);
                });
                var series=new Array();
                $.each(dimensionObj,function(key,value){
                    series.push({
                        type: opts.type,
                        name: key,
                        smooth:opts.smooth,
                        data:value
                    });
                });
                return {
                    legend:opts.showLegend?{data:legend}:undefined,
                    xAxis: {data:xAxis},
                    series:series
                };
            }
            function GetPieData(data,opts){
	            var dimensionField =opts.dimensionField;
	            var legend=new Array();
				$.each(data,function(){
					var dimensionValue=this[dimensionField];
					if(legend.indexOf(dimensionValue)==-1){
						legend.push(dimensionValue);
					}
				});
				return {
	                xAxis:{show:false},
	                yAxis:{show:false},
                    legend:opts.showLegend?{data:legend}:undefined,
                    series:[{
      					type: opts.type,
      					radius: ['30%', '70%'],
      					data:data
	                }]
                };
	        }
        },
        reload:function(jq){
            return jq.echarts('load');
        }
    }
    function elementData(target,field,value){
        var data=$.data(target,'echarts');
        if(typeof field=='undefined'){
            return data;
        }
        if(typeof value=='undefined'){
            return data?data[field]:undefined;
        }
        if(!data) data={};
        data[field]=value;
        return $.data(target,'echarts',data);
    }
    $.fn.echarts.defaults = {
        echarts:{},
        theme:'',
        type:'bar',
        showLegend:false,
        yAxisField:'',
        xAxisField:'',
        dimensionField:'',
        smooth:0,
        url:'DHCDoc.Util.Broker.cls',
        ClassName:'',
        QueryName:'',
        MethodName:'',
        queryParams:{},
        onBeforeLoad:function(param){},
        loadFilter:function(data){},
        onLoadSuccess:function(data){},
        onClick:function(params){},
        onDblClick:function(params){},
        onContextMenu:function(params){}
    };
    $.parser.plugins.push("echarts");
})(jQuery);