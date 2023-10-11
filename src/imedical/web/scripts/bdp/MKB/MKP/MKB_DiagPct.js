/*
 * @Author: 基础数据平台-范文凯
 * @Date:   2019-08-21
 * @Last Modified by:   admin
 * @Last Modified time: 2019-08-22
 * @描述:基于中心词的开立诊断频次占比图
 */
var init = function() {
    //获取div高度，使得图片居中显示
    var divHeight = $("#div-img").height()
    var imgHeight = $("#imgp").height()
    var marginHeight = (divHeight - imgHeight)/2*0.8;
    $("#imgp").css('margin-top',marginHeight);
    /************************************************左侧列表中心词开始********************************************************* */
    var orign = "knocount" //是否原始排序
    var seeAll = "All" //是否显示封闭数据
    var baseId = 5
    var centerid = ""
    var ds = ""
    var datatype = ""
    var sourcedata = tkMakeServerCall("web.DHCBL.MKB.MKBEChartsInterface", "GetDataType", "1");
    var text = "" //fwktest
    var columns = [
        [{
            field: 'MKBTRowId',
            title: 'MKBTRowId',
            width: 80,
            hidden: true
        }, {
            field: 'MKBTDesc',
            title: '中心词',
            width: 270,
            styler: function(value, row, index) {
                if (row.MKBTActiveFlag == "N") {
                    return 'background-color:#40a2de;color:#fff';
                }
            }
        }, {
            field: 'MKBTDetailCount',
            title: '知识数量',
            width: 80,
            hidden: true
        }, {
            field: 'MKBTActiveFlag',
            title: '是否封闭',
            width: 80,
            hidden: true
        }]
    ];
    var leftgrid = $HUI.datagrid("#leftgrid", {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCBL.MKB.MKBEChartsInterface",
            MethodName: "GetCenterWord",
            desc: "",
            page: 1,
            rows: 20
        },
        columns: columns, //列信息
        pagination: true, //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize: 20,
        pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100, 200, 300, 500, 1000],
        singleSelect: true,
        idField: 'MKBTRowId',
        rownumbers: false, //设置为 true，则显示带有行号的列。
        fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        //remoteSort:false,  //定义是否从服务器排序数据。true
        scrollbarSize: 0,
        onRowContextMenu: function(e, rowIndex, rowData) { //右键菜单
        },
        onDblClickRow: function(rowIndex, rowData) {},
        onClickRow: function(rowIndex, rowData) {
            $('#div-img').hide();
            $('#main').show();
            centerid = rowData.MKBTRowId;
            NewLoadEcharts()
        },
        onLoadSuccess: function(data) {},
        toolbar: '#leftbar'
    });
    //下拉框触发事件
    //术语维护查询框
    $('#TextSearch').searchcombobox({
        url: $URL + "?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename=" + "User.MKBTerm" + baseId,
        onSelect: function() {
            $(this).combobox('textbox').focus();
            TextSearchFun()
        }
    });
    //查询框键盘监听事件
    $('#TextSearch').combobox('textbox').bind('keyup', function(e) {
        if (e.keyCode == 13) {
            TextSearchFun()
        }
    });
    $('#TextSearch').combobox('textbox').bind('keyup', function(e) {
        if (e.keyCode == 27) {
            clearLeftData()
        }
    });
    //中心词查询按钮
    $("#btnSearch").click(function(e) {
        TextSearchFun()
    });
    //中心词清屏按钮
    $("#btnRel").click(function(e) {
        clearLeftData()
    });
    //清屏方法
    clearLeftData = function() {
        $("#TextSearch").combobox('setValue', '');
        $('#leftgrid').datagrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBEChartsInterface&pClassMethod=GetCenterWord" //&base="+base+"&sortway="+sortway, 
        $('#leftgrid').datagrid('load', {});
        $('#main').hide();
        $('#div-img').show();
    };
    //查询方法
    TextSearchFun = function() {
        var desc = $('#TextSearch').combobox('getText')
        $('#leftgrid').datagrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBEChartsInterface&pClassMethod=GetCenterWord&base=" + baseId + "&sortway=" + orign
        $('#leftgrid').datagrid('options').queryParams = {
            'desc': desc
        }
        $('#leftgrid').datagrid('load');
        $('#leftgrid').datagrid('unselectAll');
        $('#div-img').show();
        $('#main').hide();
    };
    //加载Echarts方法
    NewLoadEcharts = function() {
        $('#div-img').hide();
        $('#main').show();
        ds = $('#datasource').combobox('getValue');
        datatypeid = $('#datasource2').combobox('getValue');
        datatype = $('#datasource2').combobox('getData')
        datatype = datatype[datatypeid].text
        $cm({
            ClassName: "web.DHCBL.MKB.MKBEChartsInterface",
            MethodName: "NewDiagCenterWordPct",
            centerid: centerid,
            ds: ds,
            datatype: datatype
        }, function(jsonData) {
            var XData = [];
            var YData = [];
            var length = jsonData.rows.length;
            for (i = 0; i < length; i++) {
                XData.push(jsonData.rows[i].MKBSDDiag);
                YData.push(jsonData.rows[i].Freq)
            }
            loadechart(XData, YData, length)
        });
    }
    //**************************************数据来源下拉框*****************************************
    //数据来源下拉框.combobox
    $('#datasource').combobox({
        url: $URL + "?ClassName=web.DHCBL.MKB.MKBEChartsInterface&QueryName=DataSource&ResultSetType=array",
        valueField: 'ID',
        textField: 'MKBSTBDesc',
        //mode:'remote',
        panelWidth: 165,
        onLoadSuccess:function () 
        { //数据加载完毕事件
        	var data = $('#datasource').combobox('getData');
　　　　　	if (data.length > 0) 
			{
            	$("#datasource").combobox('select', data[0].MKBSTBDesc);
        　　}
        }
    });
    //下拉框内容改变时触发事件
    $('#datasource').combobox({
        onSelect: function() {
            GetSourcedata();
            NewLoadEcharts()
        }
    });
    //**************************************数据来源2下拉框****************************************
    //fwk修改
    //获得sourcedata
    $("#datasource2").combobox({
        valueField: 'id',
        textField: 'text',
        panelWidth: 150,
        data: [],
        panelWidth: 150,
        value: '0',
        onSelect: function(record) {
            NewLoadEcharts();
        },
        onLoadSuccess: function() {
            if (text != "") {
                //alert(text)
                var tmpfwk = sourcedata.split(",");
                /*var sourcearr = new Array();
                sourcearr.push('全部')
                if (sourcedata != "") {
                    for (var i = 0; i < sourcedata.split(",").length; i++) {
                        sourcearr.push(sourcedata.split(',')[i]);
                    }
                }*/
                tmpfwk.unshift("全部");
                //alert(tmpfwk)
                var index = $.inArray(text, tmpfwk);
                //alert(index)
                if (index == "-1")
                {
                    //alert("该医院不存在该类型")
                    $.messager.alert('警告','该医院不存在该类型！','warning');
                    $('#datasource2').combobox('setValue', null);         
                }
                else
                {
                    $('#datasource2').combobox('setValue', index);
                }
                
            }
        }
    });
    GetSourcedata = function() {
        var id = $('#datasource').combobox('getValue');
        text = $('#datasource2').combobox('getText'); //获得数据类型现在的text  当数据来源改变后，去判断改变后的数据类型中是否包含现在的text，包含则定位，不包含则定位为空
        //alert(text)
        sourcedata = tkMakeServerCall("web.DHCBL.MKB.MKBEChartsInterface", "GetDataType", id);
        var sourcearr = new Array();
        sourcearr.push({
            "id": '0',
            "text": '全部'
        })
        if (sourcedata != "") {
            for (var i = 0; i < sourcedata.split(",").length; i++) {
                sourcearr.push({
                    "id": i + 1,
                    "text": sourcedata.split(',')[i]
                });
            }
        }
        $("#datasource2").combobox('loadData', sourcearr);
    }
    //加载数据来源下拉框数据
    var sourcearr = new Array();
    sourcearr.push({
        "id": '0',
        "text": '全部'
    })
    if (sourcedata != "") {
        for (var i = 0; i < sourcedata.split(",").length; i++) {
            sourcearr.push({
                "id": i + 1,
                "text": sourcedata.split(',')[i]
            });
        }
    }
    $("#datasource2").combobox('loadData', sourcearr);
    /* //数据来源下拉框.combobox
     $('#datasource2').combobox({
         valueField: 'id',
         textField: 'text',
         panelWidth: 165,
         data: [{
             id: '1',
             text: '全部'
         }, {
             id: '2',
             text: '住院'
         }, {
             id: '3',
             text: '出院'
         }, {
             id: '4',
             text: '门急诊'
         }, {
             id: '5',
             text: '语料库'
         }, {
             id: '6',
             text: '临床用语'
         }, {
             id: '7',
             text: '临床习惯用语'
         }, {
             id: '8',
             text: 'HIS诊断'
         }, {
             id: '9',
             text: '深圳地区术语'
         }],
         value: '1',
         onSelect: function(e) {
             NewLoadEcharts();
         }
     });*/
    //**************************************右侧列表数据来源****************************************
    /*var columns = [
        [{
            field: 'ID',
            title: 'ID',
            width: 80,
            //sortable: true,
            hidden: true
        }, {
            field: 'MKBSTBDesc',
            title: '数据来源',
            width: 270,
        }]
    ];
    var rightgrid = $HUI.datagrid("#rightgrid", {
        url: $URL,
        queryParams: {
            //ClassName: "web.DHCBL.MKB.MKBStructuredSecondData",
            //MethodName: "GetMyList",
            ClassName: "web.DHCBL.MKB.MKBEChartsInterface",
            MethodName: "DataSource",
            //base: 5,
            //sortway: orign,
            //closeflag: seeAll,
            //desc: "",
            //page: 1,
            //rows: 20
        },
        columns: columns, //列信息
        pagination: true, //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        // pageSize: 20,
        //pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100, 200, 300, 500, 1000],
        singleSelect: true,
        idField: 'ID',
        rownumbers: false, //设置为 true，则显示带有行号的列。
        fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        //remoteSort:false,  //定义是否从服务器排序数据。true
        scrollbarSize: 0,
        onLoadSuccess: function(data) {},
    });*/
    //Echarts图
    var loadechart = function(XData, YData, length) {
        var myChart = echarts.init(document.getElementById('main'));
        var option = {
            color:['#40a2de','#f16e57','#8096ce','#30b947','#0fbac0','#72aaff','#2f7ffd','#de61ad','#e48fd0'],
            title: {
                text: '开立诊断占比图',
                subtext: '频次前八',
                x: 'center'
            },
            tooltip: {
                trigger: 'item',
                formatter: "{a} <br/>{b}: {c} ({d}%)"
            },
            legend: {
                orient: 'vertical',
                x: 'right',
                padding:[40,40,0,0],
                data: XData,
                formatter: function(name) {
                    var index = 0;
                    var clientlabels = XData;
                    var clientcounts = YData;
                    var total = 0;
                    var pct = 0;
                    for (var i = 0; i < length; i++) {
                        if (isNaN(clientcounts[i])) {
                            break;
                        } else {
                            total += parseFloat(clientcounts[i]);
                        }
                    }
                    clientlabels.forEach(function(value, i) {
                        if (value == name) {
                            index = i;
                            pct = parseFloat((parseFloat(clientcounts[index]) / total * 100)).toFixed(2)
                            if (isNaN(pct)) {
                                pct = 0
                            }
                        }
                    });
                    return name + "  " + pct + "%" + " " + "(" + clientcounts[index] + ")";
                }
            },
            toolbox: {
                show: true,
                padding:[0,40,0,0],
                feature: {
                    mark: {
                        show: true
                    },
                    dataView: {
                        show: true,
                        readOnly: true
                    },
                    magicType: {
                        show: true,
                        type: ['pie', 'line']
                    },
                    restore: {
                        show: true
                    },
                    saveAsImage: {
                        show: true
                    }
                }
            },
            series: [{
                name: '开立诊断',
                type: 'pie',
                radius: ['53%', '70%'],
                avoidLabelOverlap: false,
                label: {
                    normal: {
                        show: false,
                        position: 'center',
                        formatter: "{b}({d}%)"
                    },
                    emphasis: {
                        show: true,
                        textStyle: {
                            fontSize: '25',
                            fontWeight: 'bold'
                        }
                    }
                },
                labelLine: {
                    normal: {
                        show: false
                    }
                },
                data: [{
                    value: YData[0],
                    name: XData[0]
                }, {
                    value: YData[1],
                    name: XData[1]
                }, {
                    value: YData[2],
                    name: XData[2]
                }, {
                    value: YData[3],
                    name: XData[3]
                }, {
                    value: YData[4],
                    name: XData[4]
                }, {
                    value: YData[5],
                    name: XData[5]
                }, {
                    value: YData[6],
                    name: XData[6]
                }, {
                    value: YData[7],
                    name: XData[7]
                }, {
                    value: YData[8],
                    name: XData[8]
                }]
            }]
        };
        myChart.setOption(option, true);
    }
}
$(init);