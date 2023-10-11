var init = function () {
    initPageDom();
    initBindEvent();
}
$(init)
function initPageDom() {
		
    initStatistics();
}
function initBindEvent() {
	
    $('#regNoInput').bind('keydown', function (e) {
        var regNO = $('#regNoInput').val();
        if (e.keyCode == 13 && regNO != "") {
            var regNoComplete = completeRegNo(regNO);
            $('#regNoInput').val(regNoComplete);
            ordStatisticsReload();
        }
    });
    $('#nameInput').bind('keydown', function (e) {
        var name = $('#nameInput').val();
        if (e.keyCode == 13 && name != "") {            
            ordStatisticsReload();
        }
    });
	$('#findBtn').bind('click', ordStatisticsReload); 
}
/*----------------------------------------------------------------------------------*/
/**
 * @description 初始化
 */
function initStatistics() {
	var defaultPageSize = 25;
    var defaultPageList = [25, 50, 100, 200, 500];
    var regNo = $('#regNoInput').val();
    var name = $('#nameInput').val();
    $('#EmrSubGrid').datagrid({
        url: $URL,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		pageSize: defaultPageSize,
		pageList: defaultPageList,
        queryParams: {
            ClassName: "Nur.NIS.Service.ReportV2.NurPlanStatistic",
            QueryName: "findStatisticsSub",
            RegNo: regNo,
            PaitentName: name,
			JobId: JobId,
			locID: QuelocID,
        },
        columns:[[
			{ field: 'EpisodeID', title: '就诊号', hidden: true}, 
			{ field: 'Warddesc', title: '统计病区', width: 150},
            { field: 'Name', title: '姓名', width: 150},
            { field: 'Regno', title: '登记号', width: 110},            
            { field: 'InDate', title: '入院日期', width: 150 },
            { field: 'OutDate', title: '出院日期', width: 150 },
            { field: 'Notsolvenum', title: '未完成条目数', width: 150, sortable:true, order:'asc' }, 
            { field: 'CurrentWardDesc', title: '患者所在病区', width: 150},

        ]],
		frozenColumns: [[]],
		idField: 'EpisodeID',
		onDblClickRow:function(index,row){
			var TransDataTimeStr=row.TransDataTimeStr
			var link = "nur.hisui.nurseplanmake.csp?a=a&IsShowPatList=N&IsShowPatInfoBannner=N&EpisodeID="+row.EpisodeID+TransDataTimeStr;
			if ("undefined" != typeof websys_getMWToken) {
			  link += "&MWToken=" + websys_getMWToken();
			}
			var iWidth = 1300;
			var iHeight = window.screen.height - 20;
			var iTop = (window.screen.availHeight - 30 - iHeight) / 2;
			var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;
			window.open(link,"表单明细","width=" + iWidth + ", height=" + iHeight + ",top=" + iTop + ",left=" + iLeft + ",scrollbars=1")

		},
		singleSelect:true,
		onLoadSuccess:function(data){
        },
        onCheck:function(index, row){
		}
    });
}

// 字符串全部转成小写
function toLowerCase(str) {
    // 判断空
    if (str == null || str == "") {
        return "";
    }
    return str.toLowerCase();
}

/**
所有showModalDialog替换为open
url 打开弹出框的url地址
obj 参数
sFeatures 用来描述对话框的外观等信息
*/
window.showModalDialog = function(url,obj,sFeatures){
	sFeatures = sFeatures.replace(/dialogHeight/gi,"height");
	sFeatures = sFeatures.replace(/dialogWidth/gi,"width");
	sFeatures = sFeatures.replace(/dialogTop/gi,"top");
	sFeatures = sFeatures.replace(/dialogLeft/gi,"left");
	sFeatures = sFeatures.replace(/:/gi, "=");
	sFeatures = sFeatures.replace(/;/gi, ",");
	var newWindow = window.open(url,'', sFeatures);
	return newWindow;
}

/**
 * @description 医嘱列表刷新
 */
function ordStatisticsReload() {
    var regNo = $('#regNoInput').val();
    var name = $('#nameInput').val();
   
    $('#EmrSubGrid').datagrid('load',
        {
            ClassName: "Nur.NIS.Service.ReportV2.NurPlanStatistic",
            QueryName: "findStatisticsSub",
            RegNo: regNo,
            PaitentName: name,
			JobId: JobId,
			locID: QuelocID,
        });
}
