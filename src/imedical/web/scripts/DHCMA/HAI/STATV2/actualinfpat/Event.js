function InitS030InfPrefWinEvent(obj){
	obj.numbers = "ALL";
   	obj.LoadEvent = function(args){
		$('#ReportFrame').css('display', 'block');
   	    setTimeout(function () {
   	        obj.LoadRep();
   	    }, 50);
 
		//图的点击事件
		$('#btnSearchChart').on('click',function(e,value){
			 $('#EchartDiv').css('display', 'block');
		    $('#EchartDiv').removeClass("no-result");
			$('#ReportFrame').css('display', 'none');
			obj.myChart = echarts.init(document.getElementById('EchartDiv'), 'theme');
			obj.ShowEChaert1();
			
		});
		
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display', 'block');
			$('#EchartDiv').css('display', 'none');
			obj.LoadRep();
		});
   	}

   	obj.LoadRep = function(){
		var aHospID = $('#cboHospital').combobox('getValues').join('|');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= DateFrom;
		var Statunit = Common_CheckboxValue('chkStatunit');
		var SubLocArr   = $('#cboLoc').combobox('getValues');
		var aLocIDs = SubLocArr.join();
        var aStatDimens = $('#cboShowType').combobox('getValue');
		ReportFrame = document.getElementById("ReportFrame");
		
		if(DateFrom > DateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((DateFrom=="")||(DateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
	
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S420SHPosInf.raq&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aHospIDs='+aHospID +'&aLocIDs='+aLocIDs +'&aLocType='+ Statunit +'&aQryCon=2'+'&aInfType=1'+'&aStatDimens='+aStatDimens+'&aPath='+cspPath;

		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}	
	}
	obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		var arrInfDiagDesc = new Array();	//感染部位
		var arrInfDiagCnt  = new Array();   //感染部位数
		var arrPosDesc		= new Array();	//部位分类(临时)
		var arrInfPosDesc	= new Array();	//部位分类
		var arrInfPosCnt  	= new Array();  //部位分类分类数量
        var nodeData = {}; //(感染部位 , node对象)
        if (!runQuery) return;
        arrRecord       = runQuery.rows;
        
         var aStatDimens = $('#cboShowType').combobox('getValue');
        var arrlength		= 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			//去掉全院、医院、科室组、科室合计
			if ((rd["DimensKey"].indexOf('-A-')>-1)||((aStatDimens!="H")&&(rd["DimensKey"].indexOf('-H-')>-1))||((aStatDimens!="G")&&(aStatDimens!="HG")&&(rd["DimensKey"].indexOf('-G-')>-1))||(!rd["DimensKey"])||(rd["DimensKey"].indexOf("------")>-1)){
				delete arrRecord[indRd];
				arrlength = arrlength + 1;
				continue;
			}
			rd["DimensDesc"] = $.trim(rd["DimensDesc"]); //去掉空格
		}
		
		arrRecord = arrRecord.sort(obj.up);
		arrRecord.length = arrRecord.length - arrlength;
   
        for (var indRd = 0; indRd < arrRecord.length; indRd++){
            var rd = arrRecord[indRd];
           
            var PosDesc =rd["PosTypeDesc"]
            var InfDiagDesc = rd["InfDiagDesc"]   
            var InfDiagCnt=parseInt(rd["InfDiagCnt"])
            if (typeof(nodeData[PosDesc])=="undefined"){
                nodeData[PosDesc]=new perNode(InfDiagDesc,InfDiagCnt);
            }else{
                nodeData[PosDesc].push(InfDiagDesc,InfDiagCnt);
            }
            
        } 
        
        for(var item in nodeData){
            arrInfPosDesc.push(item)
            arrInfPosCnt.push(nodeData[item].getValue())
            var subNode=nodeData[item].subNode
            for(var key in subNode){
                arrInfDiagDesc.push(key)
                arrInfDiagCnt.push(subNode[key])
            }
        }
       
        var arrLegend = arrInfPosDesc;
        arrLegend=arrInfPosDesc.concat(arrInfDiagDesc);
        option = {
            title : {
                    text: '医院感染科室部位分布图',
                    textStyle:{
                        fontSize:28
                    },
                    x:'center'
            },
            tooltip: {
                trigger: 'item',
                formatter: '{a} <br/>{b}: {c} ({d}%)'
            },
			toolbox: {
				feature: {
					dataView: {show: false, readOnly: false},
					magicType: {show: false, type: ['line', 'bar']},
					restore: {show: true},
					saveAsImage: {show: true}
				}
			},
            legend: {
                orient: 'vertical',
                left: 10,
                data: arrLegend
            },
            series: [
                {
                    name: '部位分类',
                    type: 'pie',
                    selectedMode: 'single',
                    radius: [0, '35%'],
                    center: ["50%", "50%"],
                    label: {
                        position: 'inner'
                    },
                    labelLine: {
                        show: false
                    },
                    data: (function(){
                        var arr=[];
                        for (var i = 0; i < arrInfPosDesc.length; i++) {    
                            arr.push({"value": arrInfPosCnt[i],"name":arrInfPosDesc[i]});
                       }
                        return arr;  
                     })(),
                },
                {
                    name: '感染部位',
                    type: 'pie',
                    radius: ['50%', '65%'],
                    center: ["50%", "50%"],
                    label: {
                        normal: {
                            formatter: '{hr|}\n  {b|{b}：}{c}  {per|{d}%}  ',
                            backgroundColor: '#eee',
                            borderColor: '#aaa',
                            borderWidth: 1,
                            borderRadius: 4,
                            rich: {
                                a: {
                                    color: '#999',
                                    lineHeight: 22,
                                    align: 'center'
                                },
                                hr: {
                                    borderColor: '#aaa',
                                    width: '100%',
                                    borderWidth: 0.5,
                                    height: 0
                                },
                                b: {
                                    fontSize: 16,
                                    lineHeight: 33
                                },
                                
                                per: {
                                    color: '#eee',
                                    backgroundColor: '#334455',
                                    padding: [2, 4],
                                    borderRadius: 2
                                }
                            }
                        }
                    },
                     data:(function(){
                        var arrNum1=[];
                       for (var i = 0; i < arrInfDiagDesc.length; i++) {    
                            arrNum1.push({"value": arrInfDiagCnt[i],"name":arrInfDiagDesc[i]});
                       }
                        return arrNum1;  
                    })(),
                }
            ]
        };
        // 使用刚指定的配置项和数据显示图表。
        obj.myChart.setOption(option,true);
    }
    obj.ShowEChaert1 = function(){
        obj.myChart.clear()
        var HospID = $('#cboHospital').combobox('getValue');
        var DateFrom = $('#dtDateFrom').datebox('getValue');
        var DateTo= DateFrom;
        var StaType = Common_CheckboxValue('chkStatunit');
        var SubLocArr   = $('#cboLoc').combobox('getValues');
        var aStatDimens = $('#cboShowType').combobox('getValue');
        var aLocIDs = SubLocArr.join();

        obj.myChart.showLoading();  
		var className="DHCHAI.STATV2.S420SHPosInf";
		var queryName="QryHCSSLocInfPos";
		$cm({
		    ClassName: className,
		    QueryName: queryName,
		    aHospIDs: HospID,
		    aDateFrom: DateFrom,
			aDateTo:DateTo,
			aLocType:StaType,
            aQryCon:2,
			aInfType:1,
			aStatDimens:aStatDimens,
			aLocIDs:aLocIDs,
			page:1,    //可选项，页码，默认1
			rows:999   //可选项，获取多少条数据，默认50
		},
		function(data){
			obj.myChart.hideLoading();    //隐藏加载动画
                if(data.total == "0"){
                    $('#EchartDiv').addClass('no-result');
                }
                obj.echartLocInfRatio(data);
		}
		,function(XMLHttpRequest, textStatus, errorThrown){
			alert("类" + className + ":" + queryName+ "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
			obj.myChart.hideLoading();    //隐藏加载动画
		});
    }
}

/*
*  按照一定顺序查询统计图
*/
function perNode(key,value){
   this._value = value;
   this.subNode={};
   this.subNode[key]=value;
}
perNode.prototype.push=function(key,value){
    if (this.subNode.hasOwnProperty(key)){
        this.subNode[key]+=value;
        this._value+=value;
    }else{
        this.subNode[key]=value;
        this._value+=value;
    }
}
perNode.prototype.getValue=function(){
    return this._value
}
