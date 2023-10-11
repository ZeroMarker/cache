/**
 * @author wujiang
 */
 var carelevelChart,
 patConditionChart,
 workloadChart,
 PDAScanRateChart,
 dateformat,
 staffTitleChart,
 staffEducateChart,
 staffQualifyChart,
 staffLevelChart,
 highRiskReportChart,
 suspectedUnderreportChart,
 infusionSheetChart,
 injectionSheetChart,
 oralMedicineChart;
var timeoutTimer;
$(function () {
	var obj = {
		type: 'postFromProd',
		messageList: [
		{key: 'EpisodeID', value: ''}
		]
	}
	window.parent.parent.postMessage(obj, "*");
	// 获取日期格式
	if (fakeFlag) {
		var res=fakeData.GetSystemConfig;
	} else {
		var res = $cm({
			ClassName: "Nur.NIS.Service.System.Config",
			MethodName: "GetSystemConfig",
		}, false);
	}
	dateformat = res.dateformat;
	curday=standardizeDate(curday);
	if ("workload" == type) {
	$("#attYearMonth").datebox({
		//显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层
		onShowPanel: function () {
		//触发click事件弹出月份层
		span.trigger("click");
		//延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔
		setTimeout(function () {
			tds = p.find("div.calendar-menu-month-inner td");
			console.log(tds);
			tds.off().click(function (e) {
			//禁止冒泡执行easyui给月份绑定的事件
			e.stopPropagation();
			//得到年份
			console.log(span.html());
			var year = /\d{4}/.exec(span.html())[0],
				//月份
				//之前是这样的month = parseInt($(this).attr('abbr'), 10) + 1;
				month = parseInt($(this).attr("abbr"), 10);
			//隐藏日期对象
			$("#attYearMonth")
				.datebox("hidePanel")
				//设置日期的值
				.datebox("setValue", year + dateformat.slice(4,5) + month);
			});
		}, 0);
		},
		//配置parser，返回选择的日期
		parser: function (s) {
		if (!s) return new Date();
		var arr = s.split(dateformat.slice(4,5));
		return new Date(parseInt(arr[0], 10), parseInt(arr[1], 10) - 1, 1);
		},
		//配置formatter，只返回年月 之前是这样的d.getFullYear() + '-' +(d.getMonth());
		formatter: function (d) {
		var currentMonth = d.getMonth() + 1;
		var currentMonthStr =
			currentMonth < 10 ? "0" + currentMonth : currentMonth + "";
		return d.getFullYear() + dateformat.slice(4,5) + currentMonthStr;
		},
	});
	//日期选择对象
	var p = $("#attYearMonth").datebox("panel"),
		//日期选择对象中月份
		tds = false,
		//显示月份层的触发控件
		span = $(".calendar-title>span");
	var curr_time = new Date();
	//设置前当月
	$("#attYearMonth").datebox("setValue", myformatter(curr_time));
	}
	init();
});
//格式化日期
function myformatter(date) {
	//获取年份
	var y = date.getFullYear();
	//获取月份
	var m = date.getMonth() + 1;
	return y + dateformat.slice(4,5) + m;
}
// 初始化
function init() {
	//  var pdom = window.parent;
	//  $(pdom.document).find("iframe").attr("allowtransparency", "true");
	if ("carelevel" == type) {
	getCareLevelNums();
	getWardPatsNums();
	}
	if ("workload" == type) {
	$('#hoschartStyle').append('body{overflow: hidden;}');
	getWardCareLevel();
	}
	if ("PDAScanRate" == type) {
		getPdaExeInfo();
	}
	if ("manpower" == type) {
	$("#title").css({
		lineHeight: $("#title").height() * 0.9 + "px",
		// fontSize:$('#title').height()/2+'px',
		fontSize: "16px",
	});
	getStaffInfo();
	}
	if ("highRiskReport" == type) {
	getGfxsbTwoPage();
	}
	if ("suspectedUnderreport" == type) {
	getYslbTwoPage();
	}
	if ("IIORate" == type) {
	getIIORateData();
	}
	if ("careIllLevel" == type) {
	getCareLevelNums();
	getWardPatsNums3(); // 第三屏
	}
	// updatePanelSize();
}
// 获取输注口执行率
function getIIORateData() {
 var titles = ["输液执行率(%)", "注射执行率(%)", "口服执行率(%)"];
 var keyVal = ["syPercent", "zsPercent", "kfyPercent"];
 if (fakeFlag) {
   var data=fakeData.GetPdaExeInfo[11];
   
 } else {
   debugger
   var data=$cm({
      ClassName: "Nur.Interface.OutSide.PortalUC.Ward",
      QueryName: "GetPdaExeInfo",
      wardId: session["LOGON.WARDID"],
      startDate: curday.slice(0, 8) + "01",
      endDate: curday,
    }, false);
 }
  data=data.rows[0];
  var canvas=document.createElement("canvas");
  var context=canvas.getContext("2d");
  // var width=parseInt(1132);
  // var height=parseInt(826);
  var width=parseInt(566);
  var height=parseInt(413);
  canvas.width=width;
  canvas.height=height;
  var linearGradient=context.createLinearGradient(0,0,width,0);
  linearGradient.addColorStop(0,'#00bdd3');
  linearGradient.addColorStop(1,'#3cd99e');
  context.fillStyle=linearGradient;
  context.fillRect(0,0,width,height/2);
  context.fillStyle='#00bdd3';
  context.fillRect(0,height/2,width/2,height/2);
  context.fillStyle='#3cd99e';
  context.fillRect(width/2,height/2,width/2,height/2);
  for (var i = 0; i < keyVal.length; i++) {
    var key = keyVal[i];
    switch (i) {
      case 0:
        if (!infusionSheetChart) {
          infusionSheetChart = echarts.init(
            document.getElementById("infusionSheetChart")
          );
        } else {
          infusionSheetChart.clear();
        }
        break;
      case 1:
        if (!injectionSheetChart) {
          injectionSheetChart = echarts.init(
            document.getElementById("injectionSheetChart")
          );
        } else {
          injectionSheetChart.clear();
        }
        break;
      case 2:
        if (!oralMedicineChart) {
          oralMedicineChart = echarts.init(
            document.getElementById("oralMedicineChart")
          );
        } else {
          oralMedicineChart.clear();
        }
        break;
      default:
        break;
    }
    var option = {
      series: [{
          type: 'gauge',
          radius:'65%',
          center: ['50%', '50%'],
          // startAngle: 225,
          // endAngle: -45,
          min: 0,
          max: 100,
          splitNumber: 4,
          z:1,
          // itemStyle: {
          //   // color: '#FF0000',
          //   color: new echarts.graphic.LinearGradient(0,0,1,0,[
          //     {
          //         offset: 0.1,
          //         color: "#00bdd3"
          //     },
          //     {
          //         offset: 1,
          //         color: "#3cd99e"
          //     }
          //   ]),
          // },
          pointer: {
            show: false
          },
          detail: {
            valueAnimation: true,
            width: '60%',
            lineHeight: 40,
            borderRadius: 8,
            offsetCenter: [0, '5%'],
            fontWeight: 'bolder',
            color: '#ffffff',
            textStyle: {
              lineHeight: 28,
              fontSize: 33,
              fontWeight: "bold",
              color: "#ffffff",
            },
          },
          title: {
            show: true,
            offsetCenter: ["0", "120%"],
            textStyle: {
              lineHeight: 16,
              fontSize: 16,
              // fontWeight: "bold",
              color: "#ffffff",
            },
          },
          axisLabel: {
            show: true,
            distance: -25,
            color: '#ffffff',
          },
          axisTick: {
            // 刻度(线)样式。
            show: true,
            distance: -25,
            length: 10,
            splitNumber: 12,
            lineStyle: {
                width: 2,
                color: 'auto',
                cap: 'round'
            },
          },
          // progress: {
          //   distance: 0,
          //   show: true,
          //   width: 10
          // },
          splitLine: {
            show: false,
            length: 8,
            // distance: -25,
            // lineStyle: {
            //   width: 3,
            //   color: '#cccccc'
            // }
          },
          axisLine: {
            show: false,
            lineStyle: {
              width: 0,
              color: [
                [data[key]/100, 
                  {
                    image:  canvas,
                    repeat: 'no-repeat'
                  }
                ],
                [1, 'rgba(255,255,255, .2)'],
              ],
            },
          },
          anchor: {
            show: false
          },
          data: [
            {
              name:titles[i],
              value: data[key],
            }
          ]
        }
      ]
    };
    switch (i) {
      case 0:
        infusionSheetChart.setOption(option);
        infusionSheetChart.on("click", function (p) {
          var list = {
            name: "关注患者",
            width: 900,
            height: 600,
            link:
              window.location.origin+"/imedical/web/csp/nur.hisui.hosstatisticaltable.csp?type=workload&MWToken=" +
              websys_getMWToken(),
          };
          window.parent.parent.postMessage({ embedWindow: list }, "*");
        });
        break;
      case 1:
        injectionSheetChart.setOption(option);
        injectionSheetChart.on("click", function (p) {
          var list = {
            name: "关注患者",
            width: 900,
            height: 600,
            link:
              window.location.origin+"/imedical/web/csp/nur.hisui.hosstatisticaltable.csp?type=workload&MWToken=" +
              websys_getMWToken(),
          };
          window.parent.parent.postMessage({ embedWindow: list }, "*");
        });
        break;
      case 2:
        oralMedicineChart.setOption(option);
        oralMedicineChart.on("click", function (p) {
          var list = {
            name: "关注患者",
            width: 900,
            height: 600,
            link:
              window.location.origin+"/imedical/web/csp/nur.hisui.hosstatisticaltable.csp?type=workload&MWToken=" +
              websys_getMWToken(),
          };
          window.parent.parent.postMessage({ embedWindow: list }, "*");
        });
        break;
      default:
        break;
    }
  }
}
// 月份变更
function monthChange() {
 console.log(arguments);
 var yearMonth=$("#attYearMonth").datebox("getValue");
 console.log(yearMonth);
 if (7!=yearMonth.length) return;
 if (yearMonth!=curday.slice(0,7)) {
   fakeFlag=false;
 }
 var year=parseInt(yearMonth),month=parseInt(yearMonth.slice(5));
 if (12 == month) {
   month = "01";
   year = year + 1;
 } else {
   month = "0" + ++month;
 }
 month = month.slice(-2);
 var endDate = year +dateformat.slice(4,5) + month + dateformat.slice(4,5) + "01";
 var newDay = Date.parse(endDate) - 24 * 3600 * 1000;
 curday = formatDate(new Date(newDay));
 clearTimeout(timeoutTimer)
 timeoutTimer=setTimeout(getWardCareLevel, 15);
}
// 获取高风险上报
function getGfxsbTwoPage() {
 var evalSheets = [
     ["压疮高风险", "e40cbc705daf418fa17db4c08854c96f", "Item15@<=14"],
     // ["跌倒高风险","5fe51beee60f40b68507d46a402a0691","Item29@>10"],
     ["跌倒高风险", "d7ced2438f044477a5c0fc09ed2bf68f", "Item16@>=45"],
     ["ADL<40", "804811d8e0614b8eabd0ffcb1b3611a1", "Item15@<40"],
     ["管路滑脱高风险", "6f86ed917b4547f98617e1297eb03450", "Item36@>12"],
     ["VTE高风险", "132ca563e85447cbbfa57b91afc95f77", "Item46@>=15"],
   ],
   count = 0,
   nums = [];
 for (var i = 0; i < evalSheets.length; i++) {
   (function () {
     var j = i;
     var evalSheet = evalSheets[j];
     if (fakeFlag) {
       var data=fakeData.GfxsbTwoPage[evalSheet[1]];
     } else {
      var data=$cm({
        ClassName: "Nur.Interface.OutSide.PortalUC.Ward",
        QueryName: "GfxsbTwoPage",
        EmrCodes: evalSheet[1],
        wardId: session["LOGON.WARDID"],
        startDate: curday.slice(0, 8) + "01",
        endDate: curday,
        condition: evalSheet[2],
      }, false);
    }
    nums[j] = data.rows.length;
    count++;
   })();
 }
 var timer = setInterval(function () {
   if (count >= evalSheets.length) {
     clearInterval(timer);
     var xAxisData = [
         "压疮高风险",
         "跌倒高风险",
         "ADL<40",
         "管路滑脱高风险",
         "VTE高风险",
       ],
       maxSize = 6;
     // 基于准备好的dom，初始化echarts实例
     if (!highRiskReportChart) {
       highRiskReportChart = echarts.init(
         document.getElementById("highRiskReportChart")
       );
     } else {
       highRiskReportChart.clear();
     }
     var fontSize =
       (((window.innerWidth - 20) * 0.9) / evalSheets.length / maxSize) * 0.6;
     fontSize = parseInt(fontSize);
     console.log(fontSize);
     // 指定图表的配置项和数据
     var option = {
       title: {
         text: "高风险上报",
         x: "center",
         y: "top",
         textAlign: "left",
         padding: [10, 0, 0, 0],
         textStyle: {
           lineHeight: 16,
           fontSize: 16,
           fontWeight: "bold",
           color: "#ffffff",
         },
       },
       color: [
         "rgba(44, 235, 201, .6)",
         "rgba(123, 221, 122, .6)",
         "rgba(216, 218, 117, .6)",
         "rgba(254, 176, 110, .6)",
         "rgba(59,162,114, .6)",
         "rgba(252,132,82, .6)",
         "rgba(154,96,180, .6)",
         "rgba(234,124,204, .6)",
       ],
       tooltip: {
         trigger: "item",
         formatter: function (v, i) {
           return "高风险上报：<br>" + v.name + "：" + v.value;
         },
       },
       grid: {
         left: "4%",
         right: "4%",
         bottom: "7%",
         containLabel: true,
       },
       xAxis: [
         {
           type: "category",
           data: xAxisData,
           axisLine: {
             show: true,
             lineStyle: {
               color: "rgba(255,255,255, .2)",
             },
           },
           axisLabel: {
             //x轴文字的配置
             show: true,
             textStyle: {
               color: "#ffffff",
               fontSize: 12,
             },
             // margin:20,
             interval: 0,
             // rotate: 30  //设置倾斜度
           },
         },
       ],
       yAxis: [
         {
           // name: "关注患者",
           type: "value",
           // nameTextStyle:{//y轴上方单位的颜色
           //   color:'#000',
           //   fontSize:fontSize
           // },
           minInterval: 1,
           axisLine: { show: false },
           axisTick: { show: false },
           splitLine: {
             lineStyle: {
               // type: "dashed",
               color: "rgba(255,255,255, .2)",
             },
           },
           axisLabel: {
             show: true,
             textStyle: {
               color: "#ffffff",
               fontSize: 12,
             },
           },
         },
       ],
       series: [
         {
           name: "Direct",
           type: "bar",
           barWidth: "29px",
           data: nums,
         },
       ],
     };
     // 使用刚指定的配置项和数据显示图表。
     highRiskReportChart.setOption(option);
     // 处理点击事件并且跳转到相应的页面
     highRiskReportChart.on("click", function (p) {
       console.log(p.dataIndex);
       var ind=p.dataIndex;
       var list = {
         name: evalSheets[ind][0],
         width: 900,
         height: 600,
         link:
           window.location.origin+"/imedical/web/csp/nur.hisui.hosstatisticaltable.csp?type=highRiskReport&MWToken=" +
           websys_getMWToken()+"&EmrCodes="+ evalSheets[ind][1]+"&startDate="+ curday.slice(0, 8) + "01"+"&endDate="+ curday+"&condition="+ evalSheets[ind][2],
       };
       console.log(list);
       window.parent.parent.postMessage({ embedWindow: list }, "*");
     });
   }
 }, 20);
 return;
}
// 获取人力资源信息
function getStaffInfo() {
 var types = ["聘任职称", "学历", "年资", "护士层级"];
 for (var i = 0; i < types.length; i++) {
   (function (p) {
     var j = i;
     var type = types[j];
     if (fakeFlag) {
       var data=fakeData.FindPersonnelList[type];
     } else {
       var data=$cm({
          ClassName: "web.INMPersonCountComm",
          QueryName: "FindPersonnelList",
          wardid: session["LOGON.WARDID"],
          type: type,
          role: "0",
          nurseid: "0",
          outputtype: "OWN",
        }, false);
     }
    var res = data.rows[0].aa;
    var chartData = [],
      legend = [
        "护士",
        "护师",
        "主管护师",
        "副主任护师",
        "主任护师",
        "教授",
        "副教授",
        "助理护士",
        "UnDef",
      ],
      seriesName = "职称";
    switch (j) {
      case 1:
        legend = [
          "中专",
          "大专",
          "本科",
          "硕士研究生（在职）",
          "硕研(专硕)",
          "硕研(学硕)",
          "博研",
          "UnDef",
        ];
        seriesName = "学历";
        break;
      case 2:
        legend = ["<1", "1≤x<2", "2≤x<5", "5≤x<10", "10≤x<20", "≥20"];
        var keys = ["A", "B", "C", "D", "E", "F"];
        seriesName = "资历";
        break;
      case 3:
        legend = [
          "N0",
          "N1",
          "N2",
          "N3",
          "N4",
          "不定级",
          "其他",
          "UnDef",
        ];
        seriesName = "级别";
        break;
      default:
        break;
    }
    for (var k = 0; k < legend.length; k++) {
      var key = legend[k];
      if (2 == j) key = keys[k];
      chartData.push({
        value: parseInt(res.split(key + "|")[1]) || 0,
        name: k == legend.length - 1 ? "未定义" : legend[k],
      });
    }
    switch (j) {
      case 0:
        if (!staffTitleChart) {
          staffTitleChart = echarts.init(
            document.getElementById("staffTitleChart")
          );
        } else {
          staffTitleChart.clear();
        }
        break;
      case 1:
        if (!staffEducateChart) {
          staffEducateChart = echarts.init(
            document.getElementById("staffEducateChart")
          );
        } else {
          staffEducateChart.clear();
        }
        break;
      case 2:
        if (!staffQualifyChart) {
          staffQualifyChart = echarts.init(
            document.getElementById("staffQualifyChart")
          );
        } else {
          staffQualifyChart.clear();
        }
        break;
      case 3:
        if (!staffLevelChart) {
          staffLevelChart = echarts.init(
            document.getElementById("staffLevelChart")
          );
        } else {
          staffLevelChart.clear();
        }
        break;
      default:
        break;
    }
    // var fontSize=Math.min((window.innerWidth-20)/3,window.innerHeight-20)*0.06667+6.66666;
    // var topVal=window.innerHeight/2-fontSize-5;
    // 指定图表的配置项和数据
    legend[legend.length - 1] = "未定义";
    var option = {
      tooltip: {
        trigger: "item",
      },
      legend: {
        data: legend,
        textStyle: {
          fontSize: 12,
          color: "#ffffff",
        },
        show: true,
        bottom: "1%",
        left: "center",
      },
      color: [
        "rgba(57, 194, 255, .6)",
        "rgba(44, 235, 201, .6)",
        "rgba(123, 221, 122, .6)",
        "rgba(216, 218, 117, .6)",
        "rgba(254, 176, 110, .6)",
        "rgba(242, 115, 48, .6)",
        "rgba(252,132,82, .6)",
        "rgba(154,96,180, .6)",
        "rgba(234,124,204, .6)",
      ],
      series: [
        {
          name: seriesName,
          type: "pie",
          avoidLabelOverlap: false,
          emphasis: {
            label: {
              show: false,
              // fontSize: fontSize,
              fontWeight: "bold",
            },
          },
          itemStyle: {
            normal: {
              label: {
                show: false,
              },
            },
          },
          labelLine: {
            show: false,
          },
          center: ["50%", "33%"],
          data: chartData,
        },
      ],
    };
    switch (j) {
      case 0:
        staffTitleChart.setOption(option);
        staffTitleChart.on("click", function (p) {
          console.log(p);
          var ind=p.dataIndex;
          var detail=ind == legend.length - 1 ? "UnDef" : legend[ind]
          var list = {
            name: type+'—'+p.name,
            width: 900,
            height: 600,
            link:
              window.location.origin+"/imedical/web/csp/nur.hisui.hosstatisticaltable.csp?type=manpower&MWToken=" +
              websys_getMWToken()+"&wardid="+ session["LOGON.WARDID"]+"&kind="+ type + "&role=0&nurseid=0&outputtype=OWN&detail="+ detail,
          };
          console.log(list);
          window.parent.parent.postMessage({ embedWindow: list }, "*");
        });
        break;
      case 1:
        staffEducateChart.setOption(option);
        staffEducateChart.on("click", function (p) {
          console.log(p);
          var ind=p.dataIndex;
          var detail=ind == legend.length - 1 ? "UnDef" : legend[ind]
          var list = {
            name: type+'—'+p.name,
            width: 900,
            height: 600,
            link:
              window.location.origin+"/imedical/web/csp/nur.hisui.hosstatisticaltable.csp?type=manpower&MWToken=" +
              websys_getMWToken()+"&wardid="+ session["LOGON.WARDID"]+"&kind="+ type + "&role=0&nurseid=0&outputtype=OWN&detail="+ detail,
          };
          console.log(list);
          window.parent.parent.postMessage({ embedWindow: list }, "*");
        });
        break;
      case 2:
        staffQualifyChart.setOption(option);
        staffQualifyChart.on("click", function (p) {
          console.log(p);
          var ind=p.dataIndex;
          var detail=ind == legend.length - 1 ? "UnDef" : legend[ind]
          var list = {
            name: type+'—'+p.name,
            width: 900,
            height: 600,
            link:
              window.location.origin+"/imedical/web/csp/nur.hisui.hosstatisticaltable.csp?type=manpower&MWToken=" +
              websys_getMWToken()+"&wardid="+ session["LOGON.WARDID"]+"&kind="+ type + "&role=0&nurseid=0&outputtype=OWN&detail="+ keys[ind],
          };
          console.log(list);
          window.parent.parent.postMessage({ embedWindow: list }, "*");
        });
        break;
      case 3:
        staffLevelChart.setOption(option);
        staffLevelChart.on("click", function (p) {
          console.log(p);
          var ind=p.dataIndex;
          var detail=ind == legend.length - 1 ? "UnDef" : legend[ind]
          var list = {
            name: type+'—'+p.name,
            width: 900,
            height: 600,
            link:
              window.location.origin+"/imedical/web/csp/nur.hisui.hosstatisticaltable.csp?type=manpower&MWToken=" +
              websys_getMWToken()+"&wardid="+ session["LOGON.WARDID"]+"&kind="+ type + "&role=0&nurseid=0&outputtype=OWN&detail="+ detail,
          };
          console.log(list);
          window.parent.parent.postMessage({ embedWindow: list }, "*");
        });
        break;
      default:
        break;
    }
   })();
 }
}
// 获取疑似漏报
function getYslbTwoPage() {
 // var events=["ylxss","ddzc","fjhxbg","glht","ywws"],count=0,nums = [];
 var events = ["ylxss", "ddzc", "glht", "ywws"],
   nums = [];
   if (fakeFlag) {
     var data=fakeData.GetYslbFirstPage;
   } else {
     var data=$cm({
        ClassName: "Nur.Interface.OutSide.PortalUC.Ward",
        MethodName: "GetYslbFirstPage",
        startTime: curday.slice(0, 8) + "01",
        endTime: curday,
        // wardId: session['LOGON.WARDID'],
        // startTime: curday.slice(0, 8) + "01 00:00",
        // endTime: curday + " 23:59",
        wardId: 3,
      }, false);
   }
  for (var i = 0; i < events.length; i++) {
    var event = events[i];
    nums.push(data[event]);
  }
  // var xAxisData=["压力性损伤","跌倒","非计划性拔管","管路滑脱","药物外渗"],maxSize=6;
  var xAxisData = ["压力性损伤", "跌倒", "管路滑脱", "药物外渗"],
    maxSize = 6;
  // 基于准备好的dom，初始化echarts实例
  if (!suspectedUnderreportChart) {
    suspectedUnderreportChart = echarts.init(
      document.getElementById("suspectedUnderreportChart")
    );
  } else {
    suspectedUnderreportChart.clear();
  }
  var fontSize =
    (((window.innerWidth - 20) * 0.9) / events.length / maxSize) * 0.6;
  fontSize = parseInt(fontSize);
  console.log(fontSize);
  // 指定图表的配置项和数据
  var option = {
    title: {
      text: "疑似漏报",
      x: "center",
      y: "top",
      textAlign: "left",
      padding: [10, 0, 0, 0],
      textStyle: {
        lineHeight: 16,
        fontSize: 16,
        fontWeight: "bold",
        color: "#ffffff",
      },
    },
    color: [
      "rgba(105,209,255, .6)",
      "rgba(44, 235, 201, .6)",
      "rgba(123, 221, 122, .6)",
      "rgba(216, 218, 117, .6)",
      "rgba(254, 176, 110, .6)",
      "rgba(59,162,114, .6)",
      "rgba(252,132,82, .6)",
      "rgba(154,96,180, .6)",
      "rgba(234,124,204, .6)",
    ],
    tooltip: {
      trigger: "item",
      formatter: function (v, i) {
        return "疑似漏报：<br>" + v.name + "：" + v.value;
      },
    },
    grid: {
      left: "4%",
      right: "4%",
      bottom: "7%",
      containLabel: true,
    },
    xAxis: [
      {
        type: "category",
        data: xAxisData,
        axisLine: {
          show: true,
          lineStyle: {
            color: "rgba(255,255,255, .2)",
          },
        },
        axisLabel: {
          //x轴文字的配置
          show: true,
          textStyle: {
            color: "#ffffff",
            fontSize: 12,
          },
          // margin:20,
          interval: 0,
          // rotate: 30  //设置倾斜度
        },
      },
    ],
    yAxis: [
      {
        // name: "关注患者",
        type: "value",
        // nameTextStyle:{//y轴上方单位的颜色
        //   color:'#000',
        //   fontSize:fontSize
        // },
        minInterval: 1,
        axisLine: { show: false },
        axisTick: { show: false },
        splitLine: {
          lineStyle: {
            // type: "dashed",
            color: "rgba(255,255,255, .2)",
          },
        },
        axisLabel: {
          show: true,
          textStyle: {
            color: "#ffffff",
            fontSize: 12,
          },
        },
      },
    ],
    series: [
      {
        name: "Direct",
        type: "bar",
        barWidth: "29px",
        data: nums,
      },
    ],
  };
  // 使用刚指定的配置项和数据显示图表。
  suspectedUnderreportChart.setOption(option);
  // 处理点击事件并且跳转到相应的页面
  suspectedUnderreportChart.on("click", function (p) {
    // window.open('nur.hisui.hosstatisticaltable.csp?type=workload&MWToken=' + websys_getMWToken(),'_blank');
    console.log(p);
    var list = {
      name: "疑似漏报"+"—"+p.name,
      width: 900,
      height: 600,
      link:
        window.location.origin+"/imedical/web/csp/nur.hisui.hosstatisticaltable.csp?type=suspectedUnderreport&MWToken=" +
        websys_getMWToken()+'&Event='+events[p.dataIndex]+'&wardId=3&startTime='+(curday.slice(0,8)+'01')+'&endTime='+curday+'&hospitalId='+session['LOGON.HOSPID'],
    };
    console.log(list);
    window.parent.parent.postMessage({ embedWindow: list }, "*");
  });
}
// 获取PDA扫码率
function getPdaExeInfo() {
 var dates = [];
 var preYearMonth = curday.slice(0, 8),
   preMonth = parseInt(preYearMonth.slice(5, 7));
 if (12 == preMonth) {
   preMonth = "01";
 } else {
   preMonth = "0" + ++preMonth;
   preYearMonth = parseInt(preYearMonth) - 1 + preYearMonth.slice(4);
 }
 preMonth = preMonth.slice(-2);
 preYearMonth = preYearMonth.slice(0, 5) + preMonth + preYearMonth.slice(7);
 var xAxisData = [],
   series = [
     { name: "总执行率", type: "line", data: [] },
     { name: "输液单", type: "line", data: [] },
     { name: "注射单", type: "line", data: [] },
     { name: "口服药", type: "line", data: [] },
   ],
   count = 0;
 var legend = ["总执行率", "输液单", "注射单", "口服药"];
 var keyVal = ["allPercent", "syPercent", "zsPercent", "kfyPercent"];
 var minNum = 1,
   maxNum = 0;
 for (var i = 0; i < 12; i++) {
   (function () {
     var j = i;
     var startDate = preYearMonth + "01";
     xAxisData[j] =
       parseInt(startDate) + "年" + parseInt(startDate.slice(5)) + "月";
     var preMonth = parseInt(preYearMonth.slice(5, 7));
     if (12 == preMonth) {
       preMonth = "01";
       preYearMonth = parseInt(preYearMonth) + 1 + preYearMonth.slice(4);
     } else {
       preMonth = "0" + ++preMonth;
     }
     preMonth = preMonth.slice(-2);
     preYearMonth =
       preYearMonth.slice(0, 5) + preMonth + preYearMonth.slice(7);
     var endDate = preYearMonth + "01";
     var newDay = Date.parse(endDate) - 24 * 3600 * 1000;
     endDate = formatDate(new Date(newDay)).replace(/-/g,"/");
     if (fakeFlag) {
       var data=fakeData.GetPdaExeInfo[j];
     } else {
       var data=$cm({
          ClassName: "Nur.Interface.OutSide.PortalUC.Ward",
          QueryName: "GetPdaExeInfo",
          wardId: session["LOGON.WARDID"],
          startDate: startDate,
          endDate: endDate,
        }, false);
     }
      data = data.rows[0];
      for (var k = 0; k < 4; k++) {
        if (!j) {
          series[k].itemStyle = {
            normal: {
              label: {
                show: true,
                position: "top",
              },
            },
          };
        }
        var rate = (parseFloat(data[keyVal[k]]) || 0) / 100;
        rate = parseFloat(rate.toFixed(5));
        minNum = Math.min(minNum, rate);
        maxNum = Math.max(maxNum, rate);
        series[k].data[j] = rate;
      }
      count++;
   })();
 }
 var timer = setInterval(function () {
   if (count > 11) {
     clearInterval(timer);
     minNum = Math.max(minNum - 0.02, 0);
     maxNum = Math.min(maxNum + 0.02, 1);
     minNum = parseFloat(minNum.toFixed(2));
     maxNum = parseFloat(maxNum.toFixed(2));
     // 基于准备好的dom，初始化echarts实例
     if (!PDAScanRateChart) {
       PDAScanRateChart = echarts.init(
         document.getElementById("PDAScanRateChart")
       );
     } else {
       PDAScanRateChart.clear();
     }
     var option = {
       title: {
         text: "PDA扫码率",
         x: "center",
         y: "top",
         padding: [10, 0, 10, 0],
         textStyle: {
           lineHeight: 16,
           fontSize: 16,
           fontWeight: "bold",
           color: "#ffffff",
         },
       },
       color: [
         "#2cebc9",
         "#feb06e",
         "#8098ff",
         "#39c2ff",
         "#FEB06E",
         "#3ba272",
         "#fc8452",
         "#9a60b4",
         "#ea7ccc",
       ],
       tooltip: {
         trigger: "axis",
       },
       legend: {
         bottom: "1%",
         textStyle: {
           fontSize: 12,
           color: "#ffffff",
         },
         data: legend,
       },
       grid: {
         left: "3%",
         right: "4%",
         bottom: "10%",
         containLabel: true,
       },
       xAxis: {
         type: "category",
         axisLine: {
           show: true,
           lineStyle: {
             color: "rgba(255,255,255, .2)",
           },
         },
         axisLabel: {
           //x轴文字的配置
           show: true,
           interval: 0,
           textStyle: {
             color: "#ffffff",
             fontSize: 12,
           },
         },
         data: xAxisData,
       },
       yAxis: {
         max: maxNum,
         min: minNum,
         splitLine: {
           lineStyle: {
             // type: "dashed",
             color: "rgba(255,255,255, .2)",
           },
         },
         axisLine: { show: false },
         axisTick: { show: false },
         axisLabel: {
           //x轴文字的配置
           show: true,
           textStyle: {
             color: "#ffffff",
             fontSize: 12,
           },
         },
         type: "value",
       },
       series: series,
     };
     // 使用刚指定的配置项和数据显示图表。
     PDAScanRateChart.setOption(option);
     // 处理点击事件并且跳转到相应的页面
     PDAScanRateChart.on("click", function (p) {
       console.log(p);
       var list = {
         name: "关注患者",
         width: 900,
         height: 600,
         link:
           window.location.origin+"/imedical/web/csp/nur.hisui.hosstatisticaltable.csp?type=workload&MWToken=" +
           websys_getMWToken(),
       };
       console.log(list);
       window.parent.parent.postMessage({ embedWindow: list }, "*");
     });
   }
 }, 20);
 // var topVal=window.innerHeight/2-fontSize-5;
}
// 获取工作量
function getWardCareLevel() {
  if (fakeFlag) {
    var data=fakeData.GetWardCareLevel;
  } else {
    var data=$cm({
      ClassName: "Nur.Interface.OutSide.PortalUC.Ward",
      QueryName: "GetWardCareLevel",
      wardId: session["LOGON.WARDID"],
      startDate: curday.slice(0, 8) + "01",
      endDate: curday,
    }, false);
  }
  var row = data.rows[0];
  var nurses = [
      "特级护理",
      "一级护理",
      "二级护理",
      "三级护理",
      "注射",
      "皮试",
      "穿刺",
      "换液",
      "拔针",
      "配液",
      "输血",
    ],
    keys = [
      "tjNursingLevel",
      "oneNursingLevel",
      "twoNursingLevel",
      "threeNursingLevel",
      "zsdExeNum",
      "psExeNum",
      "syccNum",
      "syhyNum",
      "sybzNum",
      "pyNum",
      "sxNum",
    ],
    nums = [],
    maxSize = 0;
  for (var i = 0; i < keys.length; i++) {
    var key = keys[i];
    nums.push(row?row[key]:0);
    maxSize = Math.max(maxSize, nurses[i].length);
  }
  // 基于准备好的dom，初始化echarts实例
  if (!workloadChart) {
    workloadChart = echarts.init(document.getElementById("workloadChart"));
  } else {
    workloadChart.clear();
  }
  var fontSize =
    ((((window.innerWidth - 20) / 3) * 2 * 0.9) / nurses.length / maxSize) *
    0.6;
  fontSize = parseInt(fontSize) * 2;
  console.log(fontSize);
  // 指定图表的配置项和数据
  var option = {
    title: [
      {
        text: "工作量",
        x: "center",
        y: "top",
        textAlign: "left",
        padding: [10, 0, 0, 0],
        textStyle: {
          lineHeight: 16,
          fontSize: 16,
          fontWeight: "bold",
          color: "#ffffff",
        },
      },
      // {
      //   text: curday.slice(0, 7),
      //   x: "right",
      //   y: "top",
      //   textAlign: "left",
      //   padding: [10, 40, 0, 0],
      //   textStyle: {
      //     lineHeight: 16,
      //     fontSize: 12,
      //     color: "#ffffff",
      //   },
      // },
    ],
    color: [
      "rgba(105,209,255, .6)",
      "rgba(44, 235, 201, .6)",
      "rgba(123, 221, 122, .6)",
      "rgba(216, 218, 117, .6)",
      "rgba(254, 176, 110, .6)",
      "rgba(59,162,114, .6)",
      "rgba(252,132,82, .6)",
      "rgba(154,96,180, .6)",
      "rgba(234,124,204, .6)",
    ],
    tooltip: {
      trigger: "item",
      formatter: function (v, i) {
        return "工作量：<br>" + v.name + "：" + v.value + "人日";
      },
    },
    grid: {
      left: "4%",
      right: "4%",
      bottom: "10%",
      containLabel: true,
    },
    xAxis: [
      {
        type: "category",
        data: nurses,
        axisLine: {
          show: true,
          lineStyle: {
            color: "rgba(255,255,255, .2)",
          },
        },
        axisLabel: {
          //x轴文字的配置
          show: true,
          textStyle: {
            color: "#ffffff",
            fontSize: 12,
            margin: [10, 0, 0, 0],
          },
          margin: 20,
          interval: 0,
          rotate: 30, //设置倾斜度
        },
      },
    ],
    yAxis: [
      {
        // name: "关注患者",
        type: "value",
        // nameTextStyle:{//y轴上方单位的颜色
        //   color:'#000',
        //   fontSize:fontSize
        // },
        minInterval: 1,
        axisLine: { show: false },
        axisTick: { show: false },
        splitLine: {
          lineStyle: {
            // type: "dashed",
            color: "rgba(255,255,255, .2)",
          },
        },
        axisLabel: {
          show: true,
          textStyle: {
            color: "#ffffff",
            fontSize: 12,
          },
          formatter: function (value, index) {
            return value + "人日";
          },
        },
      },
    ],
    series: [
      {
        name: "Direct",
        type: "bar",
        barWidth: "23px",
        data: nums,
        itemStyle: {
          normal: {
            label: {
              show: true,
              position: "top",
              formatter: "{c}人日",
              textStyle: {
                color: "#ffffff",
              },
            },
          },
        },
      },
    ],
  };
  // 使用刚指定的配置项和数据显示图表。
  workloadChart.setOption(option);
}
// 获取患者相关事件
function getWardPatsNums() {
  if (fakeFlag) {
    var data=fakeData.getWardPatsNums;
  } else {
    var data=$cm({
      ClassName: "Nur.Interface.OutSide.PortalUC.Patient",
      MethodName: "getWardPatsNums",
      WardID: session["LOGON.WARDID"],
      HospID: session["LOGON.HOSPID"],
    }, false);
  }
  var types = [],
    nums = [],
    maxSize = 0;
  for (var i = 0; i < data.length; i++) {
    var v = data[i];
    types.push(v.type);
    nums.push(v.num);
    maxSize = Math.max(maxSize, v.type.length);
  }
  // 基于准备好的dom，初始化echarts实例
  if (!patConditionChart) {
    patConditionChart = echarts.init(
      document.getElementById("patConditionChart")
    );
  } else {
    patConditionChart.clear();
  }
  var fontSize =
    ((((window.innerWidth - 20) / 3) * 2 * 0.9) / types.length / maxSize) *
    0.6;
  fontSize = parseInt(fontSize);
  console.log(fontSize);
  // 指定图表的配置项和数据
  var option = {
    title: {
      text: "关注患者",
      x: "center",
      y: "top",
      textAlign: "left",
      padding: [10, 0, 0, 0],
      textStyle: {
        lineHeight: 16,
        fontSize: 16,
        fontWeight: "bold",
        color: "#ffffff",
      },
    },
    color: [
      "rgba(105,209,255, .6)",
      "rgba(44, 235, 201, .6)",
      "rgba(123, 221, 122, .6)",
      "rgba(216, 218, 117, .6)",
      "rgba(254, 176, 110, .6)",
      "rgba(59,162,114, .6)",
      "rgba(252,132,82, .6)",
      "rgba(154,96,180, .6)",
      "rgba(234,124,204, .6)",
    ],
    tooltip: {
      trigger: "item",
      formatter: function (v, i) {
        return "关注患者：" + v.name + "<br>人数：" + v.value;
      },
    },
    grid: {
      left: "4%",
      right: "4%",
      bottom: "4%",
      containLabel: true,
    },
    xAxis: [
      {
        type: "category",
        data: types,
        axisLine: {
          show: true,
          lineStyle: {
            color: "rgba(255,255,255, .2)",
          },
        },
        axisLabel: {
          //x轴文字的配置
          show: true,
          textStyle: {
            color: "#ffffff",
            fontSize: 12,
          },
        },
      },
    ],
    yAxis: [
      {
        // name: "关注患者",
        type: "value",
        // nameTextStyle:{//y轴上方单位的颜色
        //   color:'#000',
        //   fontSize:fontSize
        // },
        minInterval: 1,
        axisLine: { show: false },
        axisTick: { show: false },
        axisLabel: {
          //x轴文字的配置
          show: true,
          textStyle: {
            color: "#ffffff",
            fontSize: 12,
          },
        },
        splitLine: {
          lineStyle: {
            // type: "dashed",
            color: "rgba(255,255,255, .2)",
          },
        },
      },
    ],
    series: [
      {
        name: "Direct",
        type: "bar",
        barWidth: "29px",
        data: nums,
        // itemStyle : { normal: {label : {show: true,position: 'top'}}},
      },
    ],
  };
  // 使用刚指定的配置项和数据显示图表。
  patConditionChart.setOption(option);
  // 处理点击事件并且跳转到相应的页面
  patConditionChart.on("click", function (p) {
    var list = {
      name: "关注患者"+"—"+p.name,
      width: 900,
      height: 600,
      link:
        window.location.origin+"/imedical/web/csp/nur.hisui.hosstatisticaltable.csp?type=patCondition&MWToken=" +
        websys_getMWToken()+'&filterCode='+p.name,
    };
    window.parent.parent.postMessage({ embedWindow: list }, "*");
  });
}
function getWardPatsNums3() {
  if (fakeFlag) {
    var data=fakeData.getWardPatsNums;
  } else {
    var data=$cm({
      ClassName: "Nur.Interface.OutSide.PortalUC.Patient",
      MethodName: "getWardPatsNums",
      WardID: session["LOGON.WARDID"],
      HospID: session["LOGON.HOSPID"],
    }, false);
  }
  var chartData = [],
    legend = ["病危", "病重", "其他"];
  for (var i = 0; i < legend.length; i++) {
    var species = legend[i];
    data.map(function (l) {
      if (species==l.type) {
        chartData[i]={
          value: l.num,
          name: l.type,
        };
      }
    });
  }
  chartData[2]={
    value: EpisodeIDs.split('^').length-chartData[0].value-chartData[1].value,
    name: "其他",
  };

  // 基于准备好的dom，初始化echarts实例
  if (!patConditionChart) {
    patConditionChart = echarts.init(
      document.getElementById("patConditionChart")
    );
  } else {
    patConditionChart.clear();
  }
  var fontSize =
    Math.min((window.innerWidth - 20) / 3, window.innerHeight - 20) *
      0.06667 +
    6.66666;
  var topVal = window.innerHeight * 0.45 - fontSize - 5;
  
  if ("careIllLevel" == type) {
    var title=[
      {
        text: "病情级别",
        x: "center",
        y: "top",
        textAlign: "left",
        padding: [15, 0, 10, 0],
        textStyle: {
          lineHeight: 16,
          fontSize: 16,
          fontWeight: "bold",
          color: "#ffffff",
        },
      },
    ]
  }
  // 指定图表的配置项和数据
  var option = {
    tooltip: {
      trigger: "item",
    },
    legend: {
      data: legend,
      textStyle: {
        fontSize: 12,
        color: "#ffffff",
      },
      show: true,
      bottom: "1%",
      left: "center",
    },
    color: [
      "rgba(57, 194, 255, .6)",
      "rgba(44, 235, 201, .6)",
      "rgba(123, 221, 122, .6)",
      "rgba(216, 218, 117, .6)",
      "rgba(254, 176, 110, .6)",
      "rgba(59,162,114, .6)",
      "rgba(252,132,82, .6)",
      "rgba(154,96,180, .6)",
      "rgba(234,124,204, .6)",
    ],
    title: title,
    series: [
      {
        name: "病情级别",
        type: "pie",
        radius: ["40%", "70%"],
        avoidLabelOverlap: false,
        emphasis: {
          label: {
            show: false,
            fontSize: fontSize,
            fontWeight: "bold",
          },
        },
        itemStyle: {
          normal: {
            label: {
              show: false,
            },
          },
        },
        labelLine: {
          show: false,
        },
        center: ["50%", "45%"],
        data: chartData,
      },
    ],
  };
  // 使用刚指定的配置项和数据显示图表。
  patConditionChart.setOption(option);
  // 处理点击事件并且跳转到相应的页面
  patConditionChart.on("click", function (p) {
    console.log(p);
    var list = {
      name: "病情级别"+"—"+p.name,
      width: 900,
      height: 600,
      link:
        window.location.origin+"/imedical/web/csp/nur.hisui.hosstatisticaltable.csp?type=patCondition&MWToken=" +
        websys_getMWToken()+'&filterCode='+p.name,
    };
    window.parent.parent.postMessage({ embedWindow: list }, "*");
  });
}
// 获取护理级别
function getCareLevelNums() {
  if (fakeFlag) {
    var data=fakeData.getWardCareLevelNums;
  } else {
    var data=$cm({
        ClassName: "Nur.Interface.OutSide.PortalUC.Patient",
        MethodName: "getWardCareLevelNums",
        WardID: session["LOGON.WARDID"],
        HospID: session["LOGON.HOSPID"],
      }, false);
  }
  var chartData = [],
    legend = ["特级护理", "一级护理", "二级护理", "三级护理", "其他"];
  data.levelList.sort(function (a, b) {
    return legend.indexOf(a.levelDesc) - legend.indexOf(b.levelDesc);
  });
  data.levelList.map(function (l) {
    chartData.push({
      value: l.levelNums,
      name: l.levelDesc,
    });
  });
  // 基于准备好的dom，初始化echarts实例
  if (!carelevelChart) {
    carelevelChart = echarts.init(
      document.getElementById("carelevelChart")
    );
  } else {
    carelevelChart.clear();
  }
  var fontSize =
    Math.min((window.innerWidth - 20) / 3, window.innerHeight - 20) *
      0.06667 +
    6.66666;
  var topVal = window.innerHeight * 0.45 - fontSize - 5;
  
  if ("careIllLevel" == type) {
    var title=[
      {
        text: "护理级别",
        x: "center",
        y: "top",
        textAlign: "left",
        padding: [15, 0, 10, 0],
        textStyle: {
          lineHeight: 16,
          fontSize: 16,
          fontWeight: "bold",
          color: "#ffffff",
        },
      },
    ]
  } else {
    var title=[
      {
        text: "护理级别人数",
        x: "center",
        y: "top",
        textAlign: "left",
        padding: [15, 0, 10, 0],
        textStyle: {
          lineHeight: 16,
          fontSize: 16,
          fontWeight: "bold",
          color: "#ffffff",
        },
      },
      {
        text: "总人数",
        subtext: data.sums,
        x: "center",
        y: "top",
        padding: [topVal, 0, 0, 0],
        textStyle: {
          lineHeight: 16,
          fontSize: 16,
          fontWeight: "bold",
          color: "#ffffff",
        },
        subtextStyle: {
          fontSize: 16,
          fontWeight: "bold",
          color: "#ffffff",
        },
      },
    ]
  }
  // 指定图表的配置项和数据
  var option = {
    tooltip: {
      trigger: "item",
    },
    legend: {
      data: legend,
      textStyle: {
        fontSize: 12,
        color: "#ffffff",
      },
      show: true,
      bottom: "1%",
      left: "center",
    },
    color: [
      "rgba(57, 194, 255, .6)",
      "rgba(44, 235, 201, .6)",
      "rgba(123, 221, 122, .6)",
      "rgba(216, 218, 117, .6)",
      "rgba(254, 176, 110, .6)",
      "rgba(59,162,114, .6)",
      "rgba(252,132,82, .6)",
      "rgba(154,96,180, .6)",
      "rgba(234,124,204, .6)",
    ],
    title: title,
    series: [
      {
        name: "护理级别",
        type: "pie",
        radius: ["40%", "70%"],
        avoidLabelOverlap: false,
        emphasis: {
          label: {
            show: false,
            fontSize: fontSize,
            fontWeight: "bold",
          },
        },
        itemStyle: {
          normal: {
            label: {
              show: false,
            },
          },
        },
        labelLine: {
          show: false,
        },
        center: ["50%", "45%"],
        data: chartData,
      },
    ],
  };
  // 使用刚指定的配置项和数据显示图表。
  carelevelChart.setOption(option);
  // 处理点击事件并且跳转到相应的页面
  carelevelChart.on("click", function (p) {
    console.log(p);
    var list = {
      name: ("careIllLevel" == type?"护理级别":"护理级别人数")+"—"+p.name,
      width: 900,
      height: 600,
      link:
        window.location.origin+"/imedical/web/csp/nur.hisui.hosstatisticaltable.csp?type=carelevel&MWToken=" +
        websys_getMWToken()+'&filterLevelCode='+p.name+'&hospID='+session['LOGON.HOSPID'],
    };
    window.parent.parent.postMessage({ embedWindow: list }, "*");
  });
}
// 标准化日期
function standardizeDate(day) {
 var y = dateformat.indexOf("YYYY");
 var m = dateformat.indexOf("MM");
 var d = dateformat.indexOf("DD");
 var str =
   day.slice(y, y + 4) + "/" + day.slice(m, m + 2) + "/" + day.slice(d, d + 2);
 return str;
}

function updatePanelSize() {
 var innerHeight = window.innerHeight;
 $("#bgStatistics").panel("resize", {
   height: innerHeight - 8,
 });
}
window.addEventListener("resize", updatePanelSize);
