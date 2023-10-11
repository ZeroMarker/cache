var sessionWardId = session['LOGON.WARDID'];
var sessionCTLocId = session['LOGON.CTLOCID'];
var sessionGroupDesc = session['LOGON.GROUPDESC'];
var sessionGroupId = session['LOGON.GROUPID'];

$(function(){
	// 设置默认日期
	$("#StDate").datebox('setValue',getFirstDay());
	$("#EndDate").datebox('setValue',getLastDay());
	$("#StDate").datebox('options').stopFirstChangeEvent = false;
	$("#EndDate").datebox('options').stopFirstChangeEvent = false;
	
    InitDieaseId();
    InitLocId();
    InitCareType();
    //InitEpisodeID(); // 根据条件加载患者
	
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
		//rowStyle:'checkbox', //显示成勾选行形式
        //value:defaultWardId,
        url:$URL + myurl ,
		//data:[{"id":"1","text":"内分泌"},{"id":"2","text":"消化"}],
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
		//rowStyle:'checkbox', //显示成勾选行形式
        value:sessionCTLocId,
        url:$URL + myurl ,
		//data:[{"id":"1","text":"内分泌"},{"id":"2","text":"消化"}],
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
        data:[{"id":"","text":"全部"},{"id":"0","text":"在院"},{"id":"1","text":"出院"}],
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
		//rowStyle:'checkbox', //显示成勾选行形式
        //value:sessionCTLocId,
        url:$URL + myurl ,
		//data:[{"id":"1","text":"内分泌"},{"id":"2","text":"消化"}],
		onSelect:function(rec){
		}
	});
}

 // 查询
$("#BFind").click(function(){
	var LocId = $("#LocId").combobox("getValue");
	var StDate = $("#StDate").datebox('getValue')
	var EndDate = $("#EndDate").datebox('getValue')
	var CareType = $("#CareType").combobox("getValue");
	
	var DieaseId = $("#DieaseId").combobox("getValue");
	
	var EpisodeID = ""
	if (!DieaseId || DieaseId == "")
	{
	  $.messager.alert('必填提示','请选择病种！','error');
      return false;
	}else
	{
		var EpisodeID = $("#EpisodeID").combobox("getValue");	
	}
	if (!EpisodeID || EpisodeID == "")
	{
	  $.messager.alert('必填提示','请选择病人！','error');
      return false;
	}
	
 	//http://127.0.0.1/imedical/web/csp/dhccpmrunqianreport.csp?reportName=
 	var filename = "NurCentralizedprinting.rpx"
 	var url =  "dhccpmrunqianreport.csp" + "?reportName="+filename+"&DieaseId=" + DieaseId +"&EpisodeID=" + EpisodeID;
 	
 	// 解决两个滚动条，设置iframe的scrolling='no'
 	var html = "<iframe id='runqian' scrolling='no' frameborder='0' src='"+url+"' style='width:100%;height:100%;'></iframe>"
 	$("#tabQuestionListDiv").empty();
    $("#tabQuestionListDiv").append(html);
    
    // 解决两个滚动条
    //获取iframe的实际高度
	var scoHeight = $("#runqian").contents().find("body").height();
	$("#runqian").css({
	    height:scoHeight
	});
    
});

// easyui datebox 第一次也会触发onChange事件，需要根据标记特殊处理
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
			

/// 获取当前月第一天
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

/// 获取当前月最后一天
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