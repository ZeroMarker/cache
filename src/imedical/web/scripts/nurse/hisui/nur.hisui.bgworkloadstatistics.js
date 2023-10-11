/**
 * @author wujiang
 */
var locTrendChart,locMonthChart,locNurseChart,hlByTimeChart,hlByLocChart,bgCaseObj={},saveFlag=true,page=1, pageSize=20,tableObj,columns;
var conditions=[
  ["",2.2,"��2.2"],
  [2.3,3.9,"2.3~3.9"],
  [7.8,10,"7.8~10"],
  [10.1,13.9,"10.1~13.9"],
  [14,16.6,"14~16.6"],
  [16.7,22.1,"16.7~22.1"],
  [22.2,"","��22.2"],
];
$(function() {
  init();
});
// ��ʼ��
function init() {
  // ��ȡ�¼�����
  var locs=$cm({
    ClassName: 'Nur.NIS.Service.Base.Loc',
    QueryName: 'FindLocItem',
    rows: 9999,
    HospID: session['LOGON.HOSPID'],
    LocType: "",
  }, false);
  if (locTrend) {
    $('#bgStatistics').panel({
      title:'����Ѫ�ǲ�������������ͳ��'
    }); 
    $("#locTrend").combobox({  
      defaultFilter:6,
      valueField:'rowid',
      textField:'desc',
      data:locs.rows
    }); 
    var years=[];
    var year=new Date().getFullYear(),n=10;
    while (n) {
      years.push({
        id:year,
        desc:year+$g('��'),
      })
      year--;
      n--;
    }
    $("#yearTrend").combobox({  
      defaultFilter:6,
      valueField:'id',
      textField:'desc',
      data:years
    }); 
    setLocValue('locTrend');
    $('#yearTrend').combobox('setValue',new Date().getFullYear());
    getBGStatisticsByLocYear();
  }
  if (locMonth) {
    $('#bgStatistics').panel({
      title:'����Ѫ�ǹ�����'
    }); 
    var years=[];
    var year=new Date().getFullYear(),n=10;
    while (n) {
      years.push({
        id:year,
        desc:year+$g('��'),
      })
      year--;
      n--;
    }
    $("#locYear").combobox({  
      defaultFilter:6,
      valueField:'id',
      textField:'desc',
      data:years
    }); 
    $('#locYear').combobox('setValue',new Date().getFullYear());
    var monthes=[];
    var month=1;
    while (month<13) {
      monthes.push({
        id:month,
        desc:month+$g('��'),
      })
      month++;
    }
    $("#locMonth").combobox({  
      defaultFilter:6,
      valueField:'id',
      textField:'desc',
      data:monthes
    }); 
    $('#locMonth').combobox('setValue',new Date().getMonth()+1);
    getLocBGWorkloadByMonth();
  }
  if (locNurse) {
    $('#bgStatistics').panel({
      title:'��ʿѪ�ǹ�����'
    }); 
    $("#locNurse").combobox({  
      defaultFilter:6,
      valueField:'rowid',
      textField:'desc',
      data:locs.rows
    }); 
    setLocValue('locNurse');
    var years=[];
    var year=new Date().getFullYear(),n=10;
    while (n) {
      years.push({
        id:year,
        desc:year+$g('��'),
      })
      year--;
      n--;
    }
    $("#locNurseYear").combobox({  
      defaultFilter:6,
      valueField:'id',
      textField:'desc',
      data:years
    }); 
    $('#locNurseYear').combobox('setValue',new Date().getFullYear());
    var monthes=[];
    var month=1;
    while (month<13) {
      monthes.push({
        id:month,
        desc:month+$g('��'),
      })
      month++;
    }
    $("#locNurseMonth").combobox({  
      defaultFilter:6,
      valueField:'id',
      textField:'desc',
      data:monthes
    }); 
    $('#locNurseMonth').combobox('setValue',new Date().getMonth()+1);
    getNurseBGWorkloadByLocMonth();
  }
  if (hlByTime) {
    $('#bgStatistics').panel({
      title:'�ߵ�Ѫ������ͳ�ƣ���Ѫ�ǲɼ�ʱ��ͳ�ƣ�'
    }); 
    $("#hlByTime").combobox({  
      defaultFilter:6,
      valueField:'rowid',
      textField:'desc',
      data:locs.rows
    }); 
    setLocValue('hlByTime');
    var years=[];
    var year=new Date().getFullYear(),n=10;
    while (n) {
      years.push({
        id:year,
        desc:year+$g('��'),
      })
      year--;
      n--;
    }
    $("#hlByTimeYear").combobox({  
      defaultFilter:6,
      valueField:'id',
      textField:'desc',
      data:years
    }); 
    $('#hlByTimeYear').combobox('setValue',new Date().getFullYear());
    var monthes=[];
    var month=1;
    while (month<13) {
      monthes.push({
        id:month,
        desc:month+$g('��'),
      })
      month++;
    }
    $("#hlByTimeMonth").combobox({  
      defaultFilter:6,
      valueField:'id',
      textField:'desc',
      data:monthes
    }); 
    $('#hlByTimeMonth').combobox('setValue',new Date().getMonth()+1);
    getHLBGWorkloadByLocMonth();
  }
  if (hlByLoc) {
    $('#bgStatistics').panel({
      title:'�ߵ�Ѫ������ͳ�ƣ�������ͳ�ƣ�'
    });
    var years=[];
    var year=new Date().getFullYear(),n=10;
    while (n) {
      years.push({
        id:year,
        desc:year+$g('��'),
      })
      year--;
      n--;
    }
    $("#hlByLocYear").combobox({  
      defaultFilter:6,
      valueField:'id',
      textField:'desc',
      data:years
    }); 
    $('#hlByLocYear').combobox('setValue',new Date().getFullYear());
    var monthes=[];
    var month=1;
    while (month<13) {
      monthes.push({
        id:month,
        desc:month+$g('��'),
      })
      month++;
    }
    $("#hlByLocMonth").combobox({  
      defaultFilter:6,
      valueField:'id',
      textField:'desc',
      data:monthes
    }); 
    $('#hlByLocMonth').combobox('setValue',new Date().getMonth()+1);
    getLocHLBGWorkloadByMonth();
  }
  updatePanelSize();
  // ���ÿ��ҵ�ֵ
  function setLocValue(domId) {
    var locDesc=session['LOGON.CTLOCDESC']||'';
    var assignFlag=true,locIds=[];
    var linkLocs=$cm({
      ClassName: 'Nur.NIS.Service.Base.Loc',
      MethodName: 'getLinkLocsByWardTypeLoc',
      locID: session['LOGON.CTLOCID'],
    }, false);
    locs.rows.map(function (l) {
      locIds.push(l.rowid);
    });
    locDesc=locDesc.replace($g("����Ԫ"),"");
    linkLocs.map(function (l) {
      if (!assignFlag) return;
      if (locIds.indexOf(l.id)>-1) {
        $('#'+domId).combobox('setValue',l.id);
        assignFlag=false;
      }
    });
    if (assignFlag) {
      locs.rows.map(function (l) {
        if (!assignFlag) return;
        if (locDesc==l.desc) {
          $('#'+domId).combobox('setValue',l.rowid);
          assignFlag=false;
        }
      });
    }
    if (assignFlag) $('#'+domId).combobox('setValue',session['LOGON.CTLOCID']);
  }
}
// �������»�ȡ���Ҹߵ�Ѫ�ǹ�����
function getLocHLBGWorkloadByMonth() {
	var year=$('#hlByLocYear').combobox('getValue');
	var month=$('#hlByLocMonth').combobox('getValue');
  if (!year||!month) return;
  $cm({
    ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseV2",
    MethodName: "GetLocHLBGWorkloadByMonth",
    year: year,
    month: month,
    conditions: JSON.stringify(conditions)
  }, function(data) {
    var innerWidth = window.innerWidth - 30;
    var innerHeight = window.innerHeight - 92;
    $("#hlByLocChart").css({
      width: innerWidth + "px",
      height: innerHeight + 'px'
    })
    var xAxis = [], series = [];
    for (var i = 0; i < data.length; i++) {
      xAxis.push(data[i].name);
    }
    var legend = [];
    conditions.map(function (c,cIndex) {
      legend.push(c[2]);
      var cldData=[];
      for (var i = 0; i < data.length; i++) {
        var v = data[i];
        cldData.push(v.children[cIndex].num);
      }
      series.push({
        name: c[2],
        type: 'bar',
        itemStyle:{
            normal:{
                label: {
                    show : true,
                    position : 'top',
                    formatter : "{c}",
                    textStyle : {
                        // color: '#eab62a'
                    }
                }
            },
        },
        emphasis: {
          focus: 'series',
        },
        data: cldData
      });
      if (!cIndex) series[0].barGap=0;
    })

    // ����׼���õ�dom����ʼ��echartsʵ��
    if (!hlByLocChart) {
        hlByLocChart = echarts.init(document.getElementById('hlByLocChart'));
    } else {
        hlByLocChart.clear();
    }
    var option = {
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          type: 'shadow'
        },
        formatter: function(v, i) {
          var str=v[0].name+"��<br>";
          var sum=0,condSum=0,flag=0;
          v.map(function (val) {
            str+=val.seriesName+"��"+val.value+"<br>";
            sum+=parseInt(val.value);
            if (flag==1) condSum+=parseInt(val.value);
            if (val.seriesName.indexOf("13.9")>-1) flag=1;
          })
          if (sum&&(v.length==7)) {
            str+=">13.9"+$g("ռ��")+"��"+(condSum/sum*100).toFixed(2)+"%";
          }
          return str;
        },
      },
      legend: {
        data: legend,
        top:"10"
      },
      xAxis: [
        {
          type: 'category',
          axisTick: {
            alignWithLabel: true
          },
          axisLabel: {
              interval: 0,
              rotate: 30  //������б��
          },
          data: xAxis
        }
      ],
      yAxis: [
        {
          name: $g("��λ������"),
          type: 'value',
          splitLine: {
            lineStyle: {
              type: "dashed"
            }
          }
        }
      ],
      series: series
    };
    // ʹ�ø�ָ�����������������ʾͼ��
    console.log(JSON.stringify(option));
    hlByLocChart.setOption(option);
    hlByLocChart.off();
    hlByLocChart.on("click", function (p) {
      console.log(p);
      page=1;
      if ('GetLocHLBGWorkloadDetailByMonth'!=bgCaseObj.QueryName) {
        bgCaseObj={
          
          ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseV2",
          QueryName: 'GetLocHLBGWorkloadDetailByMonth',
        }
        var colsData=$cm({
          ClassName: "Nur.Interface.OutSide.PortalUC.Ward",
          MethodName: "GetQueryRowspec",
          dataType: "text",
          className: "Nur.NIS.Service.VitalSign.BloodGlucoseV2",
          queryName: 'GetLocHLBGWorkloadDetailByMonth',
        }, false);
        console.log(colsData);
        colsData=colsData.split(",");
        columns=[];
        colsData.map(function (d) {
          d=d.split(":%String:");
          if (('hidden'!=d[1])&&d[1]) {
            columns.push({
              field:d[0],
              title:d[1],
              // width:120
            })
          }
        })
      }
      bgCaseObj.year=year;
      bgCaseObj.month=month;
      bgCaseObj.condition=JSON.stringify(conditions[p.seriesIndex]);
      bgCaseObj.locId=data[p.dataIndex].locId;
      getTableData();
    });
  });
}
function getTableData() {
	updateModalPos("bgCasesModal");
  // ��ȡ��Ϣ
  bgCaseObj.page=page;
  bgCaseObj.rows=pageSize;
	saveFlag=false;
  $cm(bgCaseObj, function (data) {
    console.log(data);
    if (!tableObj) {
      tableObj=$HUI.datagrid("#bgCases",{
        autoSizeColumn:true,
        // checkbox:true,
        columns:[columns],
        // idField:'id',
        // treeField:'oeCatDesc',
        // headerCls:'panel-header-gray',
        pagination:true,
        pageList:[10,20,50,100,200],
        pageSize: 20,
        singleSelect:true,
        onClickRow:function(id,row){
        },
      })
    }
		tableObj.loadData({
			total:data.total,
			rows:data.rows
		});
		$('#bgCases').datagrid("getPager").pagination({
	    onSelectPage:function(p,size){
				page=p;
				pageSize=size;
				if (saveFlag) {
					getTableData();
				} else {
					saveFlag=true;
				}
	    },
	    onRefresh:function(p,size){
				page=p;
				pageSize=size;
				getTableData();
	    },
	    onChangePageSize:function(size){
				page=1;
				pageSize=size;
				getTableData();
	    }
		}).pagination('select', page);
    // updateDomSize();
    updateModalPos("bgCasesModal");
  })
}
// ����ģ̬��λ��
function updateModalPos(id) {
  var offsetLeft=(window.innerWidth-$('#'+id).parent().width())/2;
  var offsetTop=(window.innerHeight-$('#'+id).parent().height())/2;
  $('#'+id).dialog({
    left: offsetLeft,
    top: offsetTop
  }).dialog("open");
}
// ���ݿ������»�ȡ��ʱ�θߵ�Ѫ�ǹ�����
function getHLBGWorkloadByLocMonth() {
	var locId=$('#hlByTime').combobox('getValue');
	var year=$('#hlByTimeYear').combobox('getValue');
	var month=$('#hlByTimeMonth').combobox('getValue');
  if (!locId||!year||!month) return;
  $cm({
    ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseV2",
    MethodName: "GetHLBGWorkloadByLocMonth",
    locId: locId,
    year: year,
    month: month,
    conditions: JSON.stringify(conditions)
  }, function(data) {
    var innerWidth = window.innerWidth - 30;
    var innerHeight = window.innerHeight - 92;
    $("#hlByTimeChart").css({
      width: innerWidth + "px",
      height: innerHeight + 'px'
    })
    var xAxis = [], series = [];
    for (var i = 0; i < data.length; i++) {
      xAxis.push(data[i].name);
    }
    var legend = [];
    conditions.map(function (c,cIndex) {
      legend.push(c[2]);
      var cldData=[];
      for (var i = 0; i < data.length; i++) {
        var v = data[i];
        cldData.push(v.children[cIndex].num);
      }
      series.push({
        name: c[2],
        type: 'bar',
        itemStyle:{
            normal:{
                label: {
                    show : true,
                    position : 'top',
                    formatter : "{c}",
                    textStyle : {
                        // color: '#eab62a'
                    }
                }
            },
        },
        emphasis: {
          focus: 'series',
        },
        data: cldData
      });
      if (!cIndex) series[0].barGap=0;
    })

    // ����׼���õ�dom����ʼ��echartsʵ��
    if (!hlByTimeChart) {
        hlByTimeChart = echarts.init(document.getElementById('hlByTimeChart'));
    } else {
        hlByTimeChart.clear();
    }
    var option = {
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          type: 'shadow'
        },
        formatter: function(v, i) {
          var str=v[0].name+"��<br>";
          var sum=0,condSum=0,flag=0;
          v.map(function (val) {
            str+=val.seriesName+"��"+val.value+"<br>";
            sum+=parseInt(val.value);
            if (flag==1) condSum+=parseInt(val.value);
            if (val.seriesName.indexOf("13.9")>-1) flag=1;
          })
          if (sum&&(v.length==7)) {
            str+=">13.9"+$g("ռ��")+"��"+(condSum/sum*100).toFixed(2)+"%";
          }
          return str;
        },
      },
      legend: {
        data: legend,
        bottom:"10"
      },
      xAxis: [
        {
          type: 'category',
          axisTick: {
            alignWithLabel: true
          },
          data: xAxis
        }
      ],
      yAxis: [
        {
          name: $g("��λ������"),
          type: 'value',
          splitLine: {
            lineStyle: {
              type: "dashed"
            }
          }
        }
      ],
      series: series
    };
    // ʹ�ø�ָ�����������������ʾͼ��
    console.log(JSON.stringify(option));
    hlByTimeChart.setOption(option);
  });
}
// ���ݿ������»�ȡ����ʿѪ�ǹ�����
function getNurseBGWorkloadByLocMonth() {
	var locId=$('#locNurse').combobox('getValue');
	var year=$('#locNurseYear').combobox('getValue');
	var month=$('#locNurseMonth').combobox('getValue');
  if (!locId||!year||!month) return;
  $cm({
    ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseV2",
    MethodName: "GetNurseBGWorkloadByLocMonth",
    locId: locId,
    year: year,
    month: month
  }, function(data) {
    var innerWidth = window.innerWidth - 30;
    var innerHeight = window.innerHeight - 92;
    console.log(innerWidth);
    console.log(innerHeight);
    $("#locNurseChart").css({
      width: innerWidth + "px",
      height: innerHeight + 'px'
    })
    var nurses = [],
        nums = [];
    for (var i = 0; i < data.length; i++) {
      var v = data[i];
      nurses.push(v.name);
      nums.push(v.num);
    }
    // ����׼���õ�dom����ʼ��echartsʵ��
    if (!locNurseChart) {
        locNurseChart = echarts.init(document.getElementById('locNurseChart'));
    } else {
        locNurseChart.clear();
    }
    // ָ��ͼ��������������
    var option = {
      title: {
        text: $g('��ʿѪ�ǹ�����'),
        x:'center',
        y:'bottom',
        textAlign:'left',
        padding:[0,0,0,0]
      },
      tooltip: {
        trigger: 'axis',
        formatter: function(v, i) {
          return $g('��ʿ')+"��"+v[0].name+"<br>"+$g('��������')+"��"+v[0].value;
        },
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '12%',
        containLabel: true
      },
      xAxis: [
        {
          type: 'category',
          data: nurses,
          axisTick: {
            alignWithLabel: true
          },
          axisLabel: {
              interval: 0,
              rotate: 30  //������б��
          }
        }
      ],
      yAxis: [
        {
          name: $g("��λ����"),
          type: 'value',
          splitLine: {
            lineStyle: {
              type: "dashed"
            }
          }
        }
      ],
      series: [
        {
          name: 'Direct',
          type: 'bar',
          barWidth: '60%',
          data: nums,
          itemStyle : { normal: {label : {show: true,position: 'top'}}},
        }
      ]
    };
    // ʹ�ø�ָ�����������������ʾͼ��
    console.log(JSON.stringify(option));
    locNurseChart.setOption(option);
  });
}
// �������»�ȡ������Ѫ�ǹ�����
function getLocBGWorkloadByMonth() {
	var year=$('#locYear').combobox('getValue');
	var month=$('#locMonth').combobox('getValue');
  if (!year||!month) return;
  $cm({
    ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseV2",
    MethodName: "GetLocBGWorkloadByMonth",
    year: year,
    month: month
  }, function(data) {
    var innerWidth = window.innerWidth - 30;
    var innerHeight = window.innerHeight - 92;
    console.log(innerWidth);
    console.log(innerHeight);
    $("#locMonthChart").css({
      width: innerWidth + "px",
      height: innerHeight + 'px'
    })
    var locs = [],
        nums = [];
    for (var i = 0; i < data.length; i++) {
      var v = data[i];
      locs.push(v.desc);
      nums.push(v.num);
    }
    // ����׼���õ�dom����ʼ��echartsʵ��
    if (!locMonthChart) {
        locMonthChart = echarts.init(document.getElementById('locMonthChart'));
    } else {
        locMonthChart.clear();
    }
    // ָ��ͼ��������������
    var option = {
      title: {
        text: $g('����Ѫ�ǹ�����'),
        x:'center',
        y:'bottom',
        textAlign:'left',
        padding:[0,0,0,0]
      },
      tooltip: {
        trigger: 'axis',
        formatter: function(v, i) {
          return $g('����')+"��"+v[0].name+"<br>"+$g('��������')+"��"+v[0].value;
        },
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '12%',
        containLabel: true
      },
      xAxis: [
        {
          type: 'category',
          data: locs,
          axisTick: {
            alignWithLabel: true
          },
          axisLabel: {
              interval: 0,
              rotate: 30  //������б��
          }
        }
      ],
      yAxis: [
        {
          name: $g("��λ����"),
          type: 'value',
          splitLine: {
            lineStyle: {
              type: "dashed"
            }
          }
        }
      ],
      series: [
        {
          name: 'Direct',
          type: 'bar',
          barWidth: '60%',
          data: nums,
          itemStyle : { normal: {label : {show: true,position: 'top'}}},
        }
      ]
    };
    // ʹ�ø�ָ�����������������ʾͼ��
    console.log(JSON.stringify(option));
    locMonthChart.setOption(option);
  });
}
// ��������һ�ȡѪ�ǹ�����
function getBGStatisticsByLocYear() {
	var locId=$('#locTrend').combobox('getValue');
	var year=$('#yearTrend').combobox('getValue');
  if (!locId||!year) return;
  $cm({
    ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseV2",
    MethodName: "GetBGStatisticsByLocYear",
    locId: locId,
    year: year
  }, function(data) {
    var innerWidth = window.innerWidth - 30;
    var innerHeight = window.innerHeight - 92;
    console.log(innerWidth);
    console.log(innerHeight);
    $("#locTrendChart").css({
      width: innerWidth + "px",
      height: innerHeight + 'px'
    })
    var monthes = [],
        nums = [];
    for (var i = 0; i < data.length; i++) {
      var v = data[i];
      monthes.push(v.month);
      nums.push(v.num);
    }
    // ����׼���õ�dom����ʼ��echartsʵ��
    if (!locTrendChart) {
        locTrendChart = echarts.init(document.getElementById('locTrendChart'));
    } else {
        locTrendChart.clear();
    }
    // ָ��ͼ��������������
    var option = {
      title: {
        text: $g('����Ѫ�ǹ�����'),
        x:'center',
        y:'bottom',
        textAlign:'left',
        padding:[0,0,10,0]
      },
      tooltip: {
        trigger: 'item',
        formatter: function(v, i) {
          return $g('�·�')+"��"+v.name+"<br>"+$g('��������')+"��"+v.value;
        }
      },
      xAxis: {
        type: 'category',
        data: monthes,
        boundaryGap: true,
        axisLabel: {
          formatter: function(value, index) {
            return value;
          }
        },
        axisTick: {
          alignWithLabel: true
        }
      },
      yAxis: {
        type: 'value',
        splitLine: {
          lineStyle: {
            type: "dashed"
          }
        }
      },
      series: [
        {
          itemStyle : { normal: {label : {show: true}}},
          data: nums,
          type: 'line'
        }
      ]
    };
    // ʹ�ø�ָ�����������������ʾͼ��
    console.log(JSON.stringify(option));
    locTrendChart.setOption(option);
    
  });
}
function updatePanelSize() {
  var innerHeight = window.innerHeight;
  $('#bgStatistics').panel('resize', {
      height: innerHeight - 8
  });
}
window.addEventListener("resize", updatePanelSize)
