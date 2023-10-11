//ICU调查登记表查询
var objScreen = new Object();
function InitRepqryWin() {
    var obj = objScreen;
    $HUI.combobox("#cboDateType",{
		data:[
			{value:'1',text:'在院日期',selected:true},
			{value:'2',text:'调查日期'}
		],
		valueField:'value',
		textField:'text',
		onSelect: function () {
            obj.refreshgridICULogs();  //刷新ICU登记表表格
        }
	});
    //ICU调查登记表
    obj.gridICULogs = $HUI.datagrid("#gridICULogs", {
        fit: true,
        title: 'ICU调查登记表',
        headerCls: 'panel-header-gray',
        iconCls: 'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        singleSelect: true,
        nowrap: false,  //自动换行
        loadMsg: '数据加载中...',
        loading:true,
        //是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false,
		
        pageSize: 20,
        pageList: [20, 50, 100, 200],
        columns: [[
       	 	{
                field: 'RepStatus', title: '调查状态', width: 100,sortable:true,sorter:Sort_int,
                formatter: function (value, row, index) {
                    if (value=="保存") {
			            return "<a href='#' style='white-space:normal;color:#229A06' onclick='objScreen.OpenICUReport(\"" + row.Paadm + "\",\"" + row.RepID + "\");'>" + value + "</a>";
			        }else if (value=="提交"){
			            return " <a href='#' style='white-space:normal; color:#58cf00' onclick='objScreen.OpenICUReport(\"" + row.Paadm + "\",\"" + row.RepID + "\");'>" + value + "</a>";
                    }else if (value=="审核"){
			            return " <a href='#' style='white-space:normal; color:#ffa200' onclick='objScreen.OpenICUReport(\"" + row.Paadm + "\",\"" + row.RepID + "\");'>" + value + "</a>";
                    }else if (value=="删除"){
			            return " <a href='#' style='white-space:normal; color:#bb0000' onclick='objScreen.OpenICUReport(\"" + row.Paadm + "\",\"" + row.RepID + "\");'>" + value + "</a>";
                    }else{
	                	return "<a href='#' style='white-space:normal; color:#00d5ee' onclick='objScreen.OpenICUReport(\"" + row.Paadm + "\",\"" + row.RepID + "\");'>" + value + "</a>";
	                }
			    },
			    styler:function(value, row, index) {
	                if (value=="保存") {
	                    return 'background-color:#f8fff3';
	                }else if (value=="提交"){
			            return 'background-color:#E9ffe3';
                    }else if (value=="审核"){
			            return 'background-color:#ffeddf';
                    }else if (value=="删除"){
			            return 'background-color:#ffe2e2';
                    }else{
	                	return 'background-color:#dffcff';
	                }
			    }
            },
			{ field: 'PapmiNo', title: '病案号', width: 100,sortable:true,sorter:Sort_int},
			{ field: 'PatientName', title: '姓名', width: 100,sortable:true,sorter:Sort_int},
			{ field: 'Sex', title: '性别', width: 50,sortable:true,sorter:Sort_int},
			{ field: 'Age', title: '年龄', width: 80,sortable:true,sorter:Sort_int},
			{ field: 'PAAdmDate', title: '入院日期', width: 120,sortable:true,sorter:Sort_int},
			{ field: 'PADischDate', title: '出院日期', width: 120, sortable: true,sortable:true,sorter:Sort_int},
            { field: 'AdmWardDesc', title: '就诊科别', width: 120,sortable:true,sorter:Sort_int},
            {
                field: 'InfInfo', title: '感染信息', width: 250,sortable:true,sorter:Sort_int,
                formatter: function (value, row, index) {
                    if (!value) {
                        return "";
                    } else {
                        var strList = value.split("^");
                        var len = strList.length;
                        var strRet = "";
                        for (var indx = 0; indx < len; indx++) {
                            var ReportID = strList[indx].split(" ")[0];
                            var InfDate = strList[indx].split(" ")[1];
                            var InfPos = strList[indx].split(" ")[2];
                            var InfSub = strList[indx].split(" ")[3];
                            if (InfSub) {
                                InfPos = InfPos + "(" + InfSub + ")"
                            }
                            var RepStatus = strList[indx].split(" ")[4];
                            strRet += "<span>" + " " + InfPos + "&nbsp;&nbsp;" + RepStatus + "</span></br>";
                        }
                        return strRet;
                    }
                }
            },
			{ field: 'PAAdmBed', title: '床号', width: 100,sortable:true,sorter:Sort_int},
			{
			    field: 'IsVAP', title: '呼吸机', width: 80,sortable:true,sorter:Sort_int,
			    formatter: function (value, row, index) {
			        var rst = "";
			        if (value == "1") {
			            rst = '<span style="color:green">' + '新开' + '</span>';
			        }
			        else if (value == "2") {
			            rst = '<span style="color:red">' + '新停' + '</span>';
			        }
			        return rst
			    }
			},
			{
			    field: 'IsUC', title: '导尿管', width: 80,sortable:true,sorter:Sort_int,
			    formatter: function (value, row, index) {
			        var rst = "";
			        if (value == "1") {
			            rst = '<span style="color:green">' + '新开' + '</span>';
			        }
			        else if (value == "2") {
			            rst = '<span style="color:red">' + '新停' + '</span>';
			        }
			        return rst
			    }
			},
            {
                field: 'IsPICC', title: '中央血管导管', width: 80,sortable:true,sorter:Sort_int,
                formatter: function (value, row, index) {
                    var rst = "";
                    if (value == "1") {
                        rst = '<span style="color:green">' + '新开' + '</span>';
                    }
                    else if (value == "2") {
                        rst = '<span style="color:red">' + '新停' + '</span>';
                    }
                    return rst
                }
            },
            { field: 'RepUserName', title: '填报人', width: 100,sortable:true,sorter:Sort_int},
            { field: 'RepDate', title: '填报日期', width: 120,sortable:true,sorter:Sort_int}
            
        ]],
        onSelect:function(rowIndex,rowData){
			obj.rowIndex=rowIndex;
        },
        onLoadSuccess: function (data) {
            dispalyEasyUILoad(); //隐藏效果
        }
    });
    
    InitRepqryWinEvent(obj);
    obj.LoadEvent(arguments);
    return obj;
}

