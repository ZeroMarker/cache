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
 * @description ��ʼ��
 */
function initStatistics() {
	var defaultPageSize = 25;
    var defaultPageList = [25, 50, 100, 200, 500];
    var regNo = $('#regNoInput').val();
    var name = $('#nameInput').val();
    $('#EmrSubGrid').datagrid({
        url: $URL,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
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
			{ field: 'EpisodeID', title: '�����', hidden: true}, 
			{ field: 'Warddesc', title: 'ͳ�Ʋ���', width: 150},
            { field: 'Name', title: '����', width: 150},
            { field: 'Regno', title: '�ǼǺ�', width: 110},            
            { field: 'InDate', title: '��Ժ����', width: 150 },
            { field: 'OutDate', title: '��Ժ����', width: 150 },
            { field: 'Notsolvenum', title: 'δ�����Ŀ��', width: 150, sortable:true, order:'asc' }, 
            { field: 'CurrentWardDesc', title: '�������ڲ���', width: 150},

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
			window.open(link,"����ϸ","width=" + iWidth + ", height=" + iHeight + ",top=" + iTop + ",left=" + iLeft + ",scrollbars=1")

		},
		singleSelect:true,
		onLoadSuccess:function(data){
        },
        onCheck:function(index, row){
		}
    });
}

// �ַ���ȫ��ת��Сд
function toLowerCase(str) {
    // �жϿ�
    if (str == null || str == "") {
        return "";
    }
    return str.toLowerCase();
}

/**
����showModalDialog�滻Ϊopen
url �򿪵������url��ַ
obj ����
sFeatures ���������Ի������۵���Ϣ
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
 * @description ҽ���б�ˢ��
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
