//患者信息[Gui]

function InitIExARepWin(obj) {
    //科室ID
    obj.LocDr = LocDr;

    //加载患者信息
    obj.gridIExAReport = $HUI.datagrid("#gridIntuRep", {
        fit:true,
        title:'',
        headerCls:'panel-header-gray',
        iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
        singleSelect:false,
        loadMsg:'数据加载中...',
        //是否是服务器对数据排序
        sortOrder:'asc',
		remoteSort:false, 
		pageSize: 50,
		pageList : [50,100,200],
        //患者信息冻结列，采用 frozenColumns
        frozenColumns:[[{ field: 'BedNum', title: '床位号', width: 50, align: 'center' },
        { field: 'PaadmID', title: '就诊ID', width: 50, align: 'center',hidden:true },
        { field: 'Name', title: '姓名', width: 100, align: 'center' },
        { field: 'BH', title: '病案号', width: 100, align: 'center' },
        { field: 'Sex', title: '性别', width: 50, align: 'center' },
        { field: 'Age', title: '年龄', width: 70, align: 'center' },]],
        columns: [[
			{
                field: 'Date1', title: '第1天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return obj.GetCellRet(value, "Date1", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date2', title: '第2天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date2", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date3', title: '第3天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date3", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date4', title: '第4天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date4", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date5', title: '第5天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date5", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date6', title: '第6天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date6", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date7', title: '第7天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date7", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date8', title: '第8天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date8", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date9', title: '第9天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date9", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date10', title: '第10天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date10", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date11', title: '第11天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date11", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date12', title: '第12天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date12", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date13', title: '第13天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date13", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date14', title: '第14天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date14", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date15', title: '第15天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date15", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date16', title: '第16天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date16", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
			},
			{
                field: 'Date17', title: '第17天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date17", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date18', title: '第18天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date18", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date19', title: '第19天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date19", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date20', title: '第20天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date20", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date21', title: '第21天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date21", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date22', title: '第22天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date22", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date23', title: '第23天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date23", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date24', title: '第24天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date24", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date25', title: '第25天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date25", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date26', title: '第26天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date26", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date27', title: '第27天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date27", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date28', title: '第28天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date28", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date29', title: '第29天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date29", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date30', title: '第30天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date30", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },
            {
                field: 'Date31', title: '第31天', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return  obj.GetCellRet(value, "Date31", index);
                },
                styler: function(value) {
                    var IsInHospital=(String(value).split("|")[4])
                    if (IsInHospital=="1"){return 'background-color:#bbb'}
                }
            },

        ]],
        onClickCell: function (Index, field, value) {
        },
        onLoadSuccess: function (data) {         
	        	dispalyEasyUILoad(); 			//隐藏效果 
        }
    });

        
    InitIExARepWinEvent(obj);
    obj.LoadEvent();
    return obj;
}




