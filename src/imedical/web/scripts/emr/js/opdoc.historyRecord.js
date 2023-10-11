//历次就诊信息
function showAdmHisDetail(flag) {
    if (flag) {
        $('#admHisDetail').panel('resize', {
            height: $('body').height()
        });
        $('#admHisLst').panel('resize', {
            height: 1
        });
        $('body').layout('resize');
    } else {
        $('#admHisLst').panel('resize', {
            height: $('body').height()
        });
        $('#admHisDetail').panel('resize', {
            height: 1
        });
        $('body').layout('resize');
    }
}

//刷新历史就诊列表
function refreshAdmHistoryList(){
    $('#admHistoryLst').empty();
    getAdmHistory(patientID, GetOPHistoryMethod == 'GetOPHistoryAll' ? '' : episodeID);
}
var getAdmHistory = "";
var currentAdmID = "";
$(function () {
    $HUI.dialog('#admHisDetail').close();
    //判断IE浏览器版本 add By Lina 2017-01-19
    if($.browser.version == '11.0')
    {
        document.documentElement.className ='ie11';
    }
    //加载历史就诊
    getAdmHistory = function (patID, admID, ctloc) {
        function appendDetail(data) {
            for (var i = 0, len = data.total; i < len; i++) {
                var row = data.rows[i];
                var div = $('<div class="admDetail"></div>');
                $(div).html(row.record);
                $('#admHistoryLst').append(div);
            }
            //隔行变色
            $('.admDetail:odd').css('background-color', '#E0EEEE');
        }

        if ($('#stdpnl').length > 0) {
            return function (patID, admID) {
	            var userInfoJson = JSON.stringify({
		            userID:userID,
		            userLocID:userLocID,
		            ssgroupID:ssgroupID
		        });
                var data = ajaxDATA('Stream', 'EMRservice.BL.opInterface',
                        GetOPHistoryMethod, patID,
                        $("input[name='flag']:checked").val(), admID,
                        $("input[name='flagAdmType']:checked").val(), "HISUI",userInfoJson);
                ajaxGETSync(data, function (ret) {
                    appendDetail($.parseJSON(ret));
                }, function (err) {
                    $.messager.alert('发生错误', GetOPHistoryMethod + ':' + err.message || err, 'info');
                    
                });
            }
        } else { //广西医大使用
            return function (patID, admID, ctloc) {
                ctloc = ctloc || $('#cbxLoc').combobox('getValue');
                var data = ajaxDATA('Stream', 'EMRservice.BL.opInterface',
                        'GetOPHistoryByDateLoc', patID,
                        '', admID, '',
                        $('#startDate').datebox('getText'),
                        $('#endDate').datebox('getText'),
                        ctloc);
                ajaxGETSync(data, function (ret) {
                    appendDetail($.parseJSON(ret));
                }, function (ret) {
                    $.messager.alert('发生错误', 'GetOPHistoryByDateLoc:' + ret, 'info');
                });
            }
        }
    }
    ();
    //查询条件栏
    if ($('#stdpnl').length > 0) {
        $HUI.radio('#Type' + admType).setValue(true);
        $HUI.radio('#Type'+admType).options().checked = true;
        if (admType == "E") {
            $HUI.radio('#CurDept').setValue(true);
            $HUI.radio('#CurDept').options().checked = true;
        }else {
            $HUI.radio('#CurDoc').setValue(true);
            $HUI.radio('#CurDoc').options().checked = true;
        }
        $HUI.radio("[name='flag']",{
            onChecked:function(e,value){
                $('#admHistoryLst').empty();
                getAdmHistory(patientID, GetOPHistoryMethod == 'GetOPHistoryAll' ? '' : episodeID);
            }
        });
        $HUI.radio("[name='flagAdmType']",{
            onChecked:function(e,value){
                $('#admHistoryLst').empty();
                getAdmHistory(patientID, GetOPHistoryMethod == 'GetOPHistoryAll' ? '' : episodeID);
            }
        });
        
    } else if ($('#ctlocpnl').length > 0) { //广西医大使用
        $('#startDate').datebox({
            //value : (new Date()).toLocaleDateString()
        });
        $('#endDate').datebox({
            //value : (new Date()).toLocaleDateString()
        });
        $("#PatientListQuery").click(function () {
            $('#admHistoryLst').empty();
            getAdmHistory(patientID, '');
        });
        //支持大小写字母查询科室
        $('#cbxLoc').combobox({
            url: '../EMRservice.Ajax.hisData.cls?Action=GetCTLocListNew',
            valueField: 'Id',
            textField: 'Text',
            filter: function (q, row) {
                var opts = $(this).combobox('options');
                return row[opts.textField].toLowerCase().indexOf(q.toLowerCase()) == 0;
            }
        });
    }
    
    //加载更多
    $('#btnLoadMore').bind('click', function (evt) {
        //alert("加载更多");
        var records = $('.diag');
        var lastEpisodeID = records.length === 0 ? episodeID : records.last().attr('admID');
        //alert(lastEpisodeID);
        getAdmHistory(patientID, lastEpisodeID);
        $('#msg').scrollTop($('#admHistoryLst')[0].scrollHeight);
    });
    //初始化获取数据
    getAdmHistory(patientID, GetOPHistoryMethod == 'GetOPHistoryAll'?'':episodeID);
});
