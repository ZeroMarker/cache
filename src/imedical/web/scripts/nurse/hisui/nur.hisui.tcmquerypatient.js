var sessionWardId = session['LOGON.WARDID'];
var sessionCTLocId = session['LOGON.CTLOCID'];
var sessionGroupDesc = session['LOGON.GROUPDESC'];
var sessionGroupId = session['LOGON.GROUPID'];

$(function(){
	// ����Ĭ������
	$("#StDate").datebox('setValue',getFirstDay());
	$("#EndDate").datebox('setValue',getLastDay());
	$("#StDate").datebox('options').stopFirstChangeEvent = false;
	$("#EndDate").datebox('options').stopFirstChangeEvent = false;
	
    InitDieaseId();
    InitLocId();
    InitCareType();
    //InitEpisodeID(); // �����������ػ���
	
	var nodatahtml = '<div title="" data-options="iconCls:icon-add-note" class="ReportImage" style="width:1150px;height:650px;"></div>'
    $("#tabQuestionListDiv").append(nodatahtml);
});

function InitDieaseId(){
	var myurl = "?ClassName=Nur.TCM.Service.NursingPlan.Common&QueryName=GetWardDiseaseList&ResultSetType=array&CTLOCID="+sessionCTLocId+"&GROUPID="+sessionGroupId
	$("#DieaseId").combobox({
		valueField:'id',
		textField:'desc',
		mode:'remote',
		editable:false,
		multiple:false,
		//rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
        //value:defaultWardId,
        url:$URL + myurl ,
		//data:[{"id":"1","text":"�ڷ���"},{"id":"2","text":"����"}],
		onSelect:function(rec){
		},
		onChange: function (newValue, oldValue) {
            InitEpisodeID();
        }
	});
}

function InitLocId(){
	var myurl = "?ClassName=Nur.TCM.Service.NursingPlan.Common&QueryName=GetWardLocList&ResultSetType=array&CTLOCID="+sessionCTLocId+"&GROUPID="+sessionGroupId;
	$("#LocId").combobox({
		valueField:'ctLocDr',
		textField:'ctlocDesc',
		mode:'remote',
		editable:false,
		multiple:false,
		//rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
        value:sessionCTLocId,
        url:$URL + myurl ,
		//data:[{"id":"1","text":"�ڷ���"},{"id":"2","text":"����"}],
		onSelect:function(rec){
		},
		onChange: function (newValue, oldValue) {
            InitEpisodeID();
        }
	});
}

function InitCareType()
{
	$("#CareType").combobox({
		valueField:'id',
		textField:'text',
		mode:'local',
		editable:false,
		multiple:false,
		value:"",
        data:[{"id":"","text":"ȫ��"},{"id":"0","text":"��Ժ"},{"id":"1","text":"��Ժ"}],
		onSelect:function(rec){
		},
		onChange: function (newValue, oldValue) {
            InitEpisodeID();
        }
	});
}

function InitEpisodeID()
{
	var DieaseId = $("#DieaseId").combobox("getValue");
	var LocId = $("#LocId").combobox("getValue");
	var StDate = $("#StDate").datebox('getValue')
	var EndDate = $("#EndDate").datebox('getValue')
	var CareType = $("#CareType").combobox("getValue");
	// var EpisodeID = $("#EpisodeID").combobox("getValue");
	
	var myurl = "?ClassName=Nur.TCM.Service.NursingPlan.Report&QueryName=FindPatListData&ResultSetType=array&DieaseId="+DieaseId
	+"&LocId="+LocId+"&StDate="+StDate+"&EndDate="+EndDate+"&GROUPID="+sessionGroupId+"&ptype="+CareType
	$("#EpisodeID").combobox({
		valueField:'EpisodeID',
		textField:'PatName',
		mode:'remote',
		editable:false,
		multiple:false,
		//rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
        //value:sessionCTLocId,
        url:$URL + myurl ,
		//data:[{"id":"1","text":"�ڷ���"},{"id":"2","text":"����"}],
		onSelect:function(rec){
		}
	});
}

 // ��ѯ
$("#BFind").click(function(){
	var LocId = $("#LocId").combobox("getValue");
	var StDate = $("#StDate").datebox('getValue')
	var EndDate = $("#EndDate").datebox('getValue')
	var CareType = $("#CareType").combobox("getValue");
	
	var DieaseId = $("#DieaseId").combobox("getValue");
	
	var EpisodeID = ""
	if (!DieaseId || DieaseId == "")
	{
	  $.messager.alert('������ʾ','��ѡ���֣�','error');
      return false;
	}else
	{
		var EpisodeID = $("#EpisodeID").combobox("getValue");	
	}
	if (!EpisodeID || EpisodeID == "")
	{
	  $.messager.alert('������ʾ','��ѡ���ˣ�','error');
      return false;
	}
	
 	//http://127.0.0.1/imedical/web/csp/dhccpmrunqianreport.csp?reportName=
 	var filename = "NurCentralizedprinting.rpx"
 	var url =  "dhccpmrunqianreport.csp" + "?reportName="+filename+"&DieaseId=" + DieaseId +"&EpisodeID=" + EpisodeID;
 	
 	// �������������������iframe��scrolling='no'
 	var html = "<iframe id='runqian' scrolling='no' frameborder='0' src='"+url+"' style='width:100%;height:100%;'></iframe>"
 	$("#tabQuestionListDiv").empty();
    $("#tabQuestionListDiv").append(html);
    
    // �������������
    //��ȡiframe��ʵ�ʸ߶�
	var scoHeight = $("#runqian").contents().find("body").height();
	$("#runqian").css({
	    height:scoHeight
	});
    
});

// easyui datebox ��һ��Ҳ�ᴥ��onChange�¼�����Ҫ���ݱ�����⴦��
$("#StDate").datebox({
	stopFirstChangeEvent: true,
    onChange: function() {
	    var options = $(this).datebox('options');
        if(options.stopFirstChangeEvent) {
            options.stopFirstChangeEvent = false;
            return;
        }
	   InitEpisodeID();
    }
});
$("#EndDate").datebox({
    stopFirstChangeEvent: true,
    onChange: function() {
	    var options = $(this).datebox('options');
        if(options.stopFirstChangeEvent) {
            options.stopFirstChangeEvent = false;
            return;
        }
	   InitEpisodeID();
    }
});
			

/// ��ȡ��ǰ�µ�һ��
function getFirstDay()
{
	var date = new Date();
    date.setDate(1);
    var month = parseInt(date.getMonth()+1);
    var day = date.getDate();
    if (month < 10) {
        month = '0' + month
    }
    if (day < 10) {
        day = '0' + day
    }
     return date.getFullYear() + '-' + month + '-' + day;	
}

/// ��ȡ��ǰ�����һ��
function getLastDay()
{
	var endDate=new Date();
    var currentMonth=endDate.getMonth();
    var nextMonth=++currentMonth;
    var nextMonthFirstDay=new Date(endDate.getFullYear(),nextMonth,1);
    var oneDay=1000*60*60*24;
    var lastTime = new Date(nextMonthFirstDay-oneDay);
    var endMonth = parseInt(lastTime.getMonth()+1);
    var endDay = lastTime.getDate();
    if (endMonth < 10) {
        endMonth = '0' + endMonth
    }
    if (endDay < 10) {
        endDay = '0' + endDay
    }
	return endDate.getFullYear() + '-' + endMonth + '-' + endDay;
}