/**
 * @description 
 * @name nur.hisui.nurplancompletrate.js
 */
 var GV = {
    _CALSSNAME: "Nur.NIS.Service.ReportV2.EmrStatistics",
    episodeID: "",
    isNurDepartment:""
};
var init = function () {
	GV.isNurDepartment = isNurDepartment();
	//GV.isNurDepartment = 0;
    initPageDom();
    initBindEvent();
}
$(init)
function initPageDom() {
	initCondition();	
    initStatistics();	
	//initStatisticsGrid()
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
	$('#detail_patient').bind('click', openwindows); 
	
	// ���� Export
	$("#Export").click(function(){
        var pageOptions=$('#NursePlanGrid').datagrid('getPager').pagination('options');
        console.log(pageOptions);
        var Locs = $('#LoginLocs').combobox('getValues').join(",");
        if(GV.isNurDepartment) Locs=session['LOGON.CTLOCID'];
        var startDate = $('#startDate').datebox('getValue');
        var endDate = $('#endDate').datebox('getValue');
        var type = HideZero;
        var ifOuted = $('#ifOuted').checkbox('getValue');
        var printData=$cm({
            ClassName: "Nur.NIS.Service.ReportV2.NurPlanStatistic",
            QueryName: "nursePalnCompletionRate",
            rows: 999999999999999,
            StartDate: startDate,
            EndDate: endDate,
            LocId: Locs,
            type: type,
            ifOuted:ifOuted,
            sessionGrpId:session['LOGON.GROUPID'],
            sessionHosId:session['LOGON.HOSPID']
        }, false);
        $('#NursePlanGrid').datagrid({
            pagination: false,
            data: printData,
        });
		// �������-datagrid-export.js ʵ�ֵ���excel����
		$('#NursePlanGrid').datagrid('toExcel','����ƻ����������ͳ�Ʊ�.xls');
        var tableData=$cm({
            ClassName: "Nur.NIS.Service.ReportV2.NurPlanStatistic",
            QueryName: "nursePalnCompletionRate",
            StartDate: startDate,
            EndDate: endDate,
            LocId: Locs,
            type: type,
            ifOuted:ifOuted,
            sessionGrpId:session['LOGON.GROUPID'],
            sessionHosId:session['LOGON.HOSPID'],
            page: pageOptions.pageNumber,
            rows: pageOptions.pageSize,
        }, false);
        $('#NursePlanGrid').datagrid({
            pagination: true,
            data: tableData,
        });
	});
}
function initStatistics() {
	var Columns=[[
		{ field: 'currJob', title: 'JobID', hidden: true},
		{ field: 'QuelocID', title: '����ID', hidden: true},
		{ field: 'queLocDesc', title: '����',width:160},
		{ field: 'wardallNum', title: '��Ŀ����',width:160,sortable: true},
		{ field: 'wardsolveNum', title: '�����Ŀ��',width:160},
		{ field: 'wardsolveRate', title: '�����',width:160},
		{ field: 'wardnotSolveNum', title: 'δ�����Ŀ����',width:160,
			formatter: function(value,row,index){
				//var data = JSON.parse(value);
				//var wardnotSolveNum= data.WardnotSolveNum;
				var wardnotSolveNum= value;
				var btns=""
				btns =
					  '<a href="#" class="editcls" id ="detail_patient"  onclick="openwindows(\'' +
					  row["currJob"] +','+
					  row["quelocID"] +
					  "')\">" +
					  wardnotSolveNum +
					  "</a>";
				return btns;
			}
		},
		{ field: 'wardnotSolveRate', title: 'δ�����',width:160}
	]];
	var defaultPageSize = 25;
    var defaultPageList = [25, 50, 100, 200, 500];
    var Locs = $('#LoginLocs').combobox('getValues').join(",");
    if(GV.isNurDepartment) Locs=session['LOGON.CTLOCID'];
    var startDate = $('#startDate').datebox('getValue');
    var endDate = $('#endDate').datebox('getValue');
	var ifOuted = $('#ifOuted').checkbox('getValue');
	var type = HideZero;
    $('#NursePlanGrid').datagrid({
        url: $URL,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		pageSize: defaultPageSize,
		pageList: defaultPageList,
        queryParams: {
            ClassName: "Nur.NIS.Service.ReportV2.NurPlanStatistic",
            QueryName: "nursePalnCompletionRate",
            StartDate: startDate,
            EndDate: endDate,
            LocId: Locs,
            type: type,
			ifOuted:ifOuted,
			sessionGrpId:session['LOGON.GROUPID'],
			sessionHosId:session['LOGON.HOSPID']
        },
        columns:Columns,
		idField: 'QuelocID',
		singleSelect:true,
		remoteSort: false,
		onLoadSuccess:function(data){
			$("#NursePlanGrid").datagrid("getColumnOption", "wardallNum").sorter=function (a,b) {
				if (isNaN(a) || isNaN(b)) {
			        return 0;
			    }
	            return parseInt(a) - parseInt(b);
			};
		}
    });
}
function openwindows(ParaData)
{
	if(ParaData=="") return;
	var ParaArray = ParaData.split(",");
	//var ParaData = $.parseJSON(ParaData);
	//var paitentcompleteArr = $.parseJSON(ParaData.PaitentCompleteArr);
	//var link="nur.hisui.nurplancompletratesub.csp?&PaitentCompleteArr="+ParaData;
	//var link = "nur.hisui.nurplancompletratesub.csp?&PaitentCompleteArr=" + encodeURIComponent(JSON.stringify(paitentcompleteArr));	
	var link = "nur.hisui.nurplancompletratesub.csp?&JobId=" +ParaArray[0] +
	  "&QuelocID=" + ParaArray[1];
	if ("undefined" != typeof websys_getMWToken) {
	  link += "&MWToken=" + websys_getMWToken();
	}
	var iWidth = 1300;
	var iHeight = 800;
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2;
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;
	window.open(link,"������ϸ","width=" + iWidth + ", height=" + iHeight + ",top=" + iTop + ",left=" + iLeft)
}
//ָ�������
function compute(colName) {
    var rows = $('#NursePlanGrid').datagrid('getRows');
    var total = 0;
    for (var i = 0; i < rows.length; i++) {
        total += parseFloat(rows[i][colName]);
    }
    return total;
}
        
function initCondition() {
    //console.log(new Date().Format("yyyy-MM-dd"))
    var date1 = getDate(-7); // �������� ����ǰ����
	var date2 = getDate(0);
	
	var defaultValue = ""
    
    if(GV.isNurDepartment)
    //if(session['LOGON.GROUPDESC'].indexOf("����")==-1)
    {
       defaultValue = session['LOGON.CTLOCID']
       $('#LoginLocs').combobox({disabled:true});
    }
    $('#startDate').datebox('setValue', date1);
    $('#endDate').datebox('setValue', date2);
    $('#LoginLocs').combobox({
        url: $URL + '?1=1&ClassName=' + GV._CALSSNAME + '&QueryName=NurseCtloc&desc='+ '&ResultSetType=array&hosId='+session['LOGON.HOSPID'],
        valueField: 'locID',
        textField: 'locDesc',
        defaultFilter:4,
        multiple:true,
        rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
        value:defaultValue,
        onLoadSuccess: function () {
	       
	    }
    })
}
/*
function openwindows(ParaData)
{
	if(ParaData=="") return;
	var ParaArray=ParaData.split(",")
	if((ParaArray[2]=="0")||(ParaArray[2]==undefined)||(ParaArray[2]=="LocDesc")) return;
	var link="nur.hisui.nurplancompletratesub.csp?&JobId="+ParaArray[0]+"&NurseLoc="+ParaArray[1]+"&EmrCode="+ParaArray[2]+"&MaxCount="+ParaArray[3];
	var iWidth = 1300;
	var iHeight = 800;
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2;
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;
	window.open(link,"������ϸ","width=" + iWidth + ", height=" + iHeight + ",top=" + iTop + ",left=" + iLeft)
}
*/


/**
 * @description ˢ��
 */
function ordStatisticsReload() {
    var Locs = $('#LoginLocs').combobox('getValues').join(",");
    if(GV.isNurDepartment) Locs=session['LOGON.CTLOCID'];
    var startDate = $('#startDate').datebox('getValue');
    var endDate = $('#endDate').datebox('getValue');
	var type = HideZero;
    var ifOuted = $('#ifOuted').checkbox('getValue');
    $('#NursePlanGrid').datagrid('load', {
        ClassName: "Nur.NIS.Service.ReportV2.NurPlanStatistic",
        QueryName: "nursePalnCompletionRate",
        StartDate: startDate,
        EndDate: endDate,
        LocId: Locs,
        type: type,
        ifOuted:ifOuted,
        sessionGrpId:session['LOGON.GROUPID'],
        sessionHosId:session['LOGON.HOSPID']
    });
}

 /**
   * ��ȡָ��ʱ�������
   * @params ���ǽ���֮������ڡ����ǽ���ǰ������
   * @return 2020-05-10
   * */
function getDate(num) {
    var date1 = new Date();
    //����ʱ��
    var time1 = date1.getFullYear() + "-" + (date1.getMonth() + 1) + "-" + date1.getDate();
    var date2 = new Date(date1);
    date2.setDate(date1.getDate() + num);
    //num��������ʾ֮���ʱ�䣬num������ʾ֮ǰ��ʱ�䣬0��ʾ����
    var time2 = this.addZero(date2.getFullYear()) + "-" + this.addZero((date2.getMonth() + 1)) + "-" + this.addZero(date2.getDate());
    return time2;
  }
  
  //��0
function addZero(num){
    if(parseInt(num) < 10){
      num = '0'+num;
    }
    return num;
  }
  
//�Ƿ���Ȩ��
function isNurDepartment(){
	var flag=0
	if(session['LOGON.GROUPDESC'].indexOf("����") == -1) flag= 1
	return flag

  }