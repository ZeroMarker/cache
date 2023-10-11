$(function() {
    strXml = convertToXml(scheme);
    var interface = $(strXml).find("interface").text();
    var checkstyle = $(strXml).find("checkstyle").text();
    pageConfig = $(strXml).find("pageConfig").text();
    selectConfig=$(strXml).find("datagridConfig>selectConfig").text();
    if(selectConfig=="Y"){
	     selectOnCheckFlag=false
   	     checkOnSelectFlag=false
	}
    $("#comboxEpisode").hide();
    initEpisodeList("#EpisodeList");
    setDataGrid(interface, checkstyle);
	$HUI.radio("[name='episode']",{
        onChecked:function(e,value){
            var value = $(e.target).attr("value");
            if (value === "allEpisode")
            {
				$("#comboxEpisode").show(); 
	        } 
	        else
	        {
				$("#comboxEpisode").hide();
 				$("#EpisodeList").combogrid('hidePanel');
				queryData();
		    }
		   	if (pageConfig == "Y")
			{
				resourceConfig.Lis = this.id;
			} 
        }
    }); 
    
  	if (pageConfig == "Y")
	{
		//获取其它资源区的查询按钮配置项数据
		resourceConfig = getResourceConfig();
		var configItem = resourceConfig.Lis;
		if ((configItem != "")&&(configItem != undefined))
		{
			$HUI.radio("#"+configItem).setValue(true);
		}
		else
		{
			$HUI.radio("#currentEpisode").setValue(true);
		}
	}
	else
	{
		$HUI.radio("#currentEpisode").setValue(true);
	}     
    $('body').layout('resize');
});

//设置数据
function setDataGrid(interface, checkstyle) {
    var param = getParam();
    if ($('#allEpisode')[0].checked) {
        param.EpisodeID = getAllEpisodeIdByPatientId();
    }
    $('#radiationData').datagrid({
	    headerCls:'panel-header-gray',
        pageSize: 10,
        pageList: [10, 20, 30],
        loadMsg: '数据装载中......',
        autoRowHeight: true,
        url: '../EMRservice.Ajax.radiationData.cls?Action=GetRadiationData&InterFace=' + encodeURI(encodeURI(interface)),
        rownumbers: true,
        pagination: true,
		selectOnCheck: selectOnCheckFlag,
        checkOnSelect: checkOnSelectFlag,
        singleSelect: false,
        queryParams: param,
        idField: 'ID',
        fit: true,
        columns: getColumnScheme("show>item"),
        sortOrder: 'ID',
        remoteSort: false,
        onCheck: function(rowIndex, rowData) {
             clickFlag=true;
            onCheckPar(rowIndex, rowData,checkstyle);
        },
        onUncheck: function(rowIndex, rowData) {
            onUnCheckPar(rowData,checkstyle);
        },
		onSelect:function(rowIndex, rowData){
	         clickFlag=false;
	         if(selectConfig!="Y")return
	         onCheckPar(rowIndex, rowData,checkstyle);
	    },
        onUnselect:function(rowIndex, rowData) {
	        if(selectConfig=="")return
           	onUnCheckPar(rowData,checkstyle);
        },
        onCheckAll: function(rows) {
            quoteData = {};
            var length = rows.length;
            if (length == 0) return;
        },
        onUncheckAll: function(rows) {
        },
		rowStyler: function(index, row) {
            if (row.ResultStatus == "1") {
                return 'color:#FF0000;';
            }
        },
        /*liuzhongwan 在加载页面时和默认选择本次就诊时程序连续发送了两个异步ajax请求，当加载时的请求后接收时就显示空表。
        解决方案：给grid添加onBeforeLoad事件，只有在就诊参数不为空时才发送请求，否则不发。
        */
        onBeforeLoad: function(param) {
                if (param.EpisodeID == undefined) return false;
                return true;
            }
            //liuzhongwan end
    });
}
//父表选中
function onCheckPar(rowIndex, rowData,checkstyle){
    var ordItemId = rowData.ID;
    quoteData[ordItemId] = {};
}
//父表 取消选中
function onUnCheckPar(rowData,checkstyle){
	if (checkstyle == "Multiple") {
                quoteData = {};
            } else {
                delete quoteData[rowData.ID];
            }
}


// 查询
function queryData() {
    var param = getParam();
    $('#radiationData').datagrid('load', param);
}

//获取查询参数
function getParam() {
    var stDateTime = "",endDateTime = "";
    //authStDateTime、authEndDateTime是按审核日期查询的始末条件
    var authStDateTime = "",authEndDateTime = "";
    var epsodeIds = episodeID;
    if ($('#currentDay')[0].checked) {
        stDateTime = new Date().format("yyyy-MM-dd");
        endDateTime = new Date().format("yyyy-MM-dd");
    } else if ($('#ThreeDays')[0].checked) {
        var start = new Date();
        start.setDate(start.getDate() - 2);
        stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate()   
        endDateTime = new Date().format("yyyy-MM-dd");
    } else if ($('#sevenDays')[0].checked)
	{
		var start = new Date();
        start.setDate(start.getDate() - 6);
        stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate()   
        endDateTime = new Date().format("yyyy-MM-dd");
	} else if ($('#currentWeek')[0].checked) {
        var now = new Date();
        var start = new Date();
        var n = now.getDay();
        start.setDate(now.getDate() - n + 1);
        stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate();   
        endDateTime = new Date().format("yyyy-MM-dd");
    } else if ($('#allEpisode')[0].checked) {
        epsodeIds = "";
        var values = $('#EpisodeList').combogrid('getValues');
        for (var i = 0; i < values.length; i++) {
            epsodeIds = (i == 0) ? "" : epsodeIds + ",";
            epsodeIds = epsodeIds + values[i];
        }
    } 
    var param = {
        EpisodeID: epsodeIds,
        StartDateTime: stDateTime,
        EndDateTime: endDateTime,
        AuthStartDateTime: authStDateTime,
        AuthEndDateTime: authEndDateTime
    };
    return param;
}
//引用数据
function getData() {
    var resultItems = new Array();
    var result = "";
    var parentList = getRefScheme("reference>item");
    var childList = getRefScheme("reference>item");
    var separate = $(strXml).find("reference>separate").text();
    separate = (separate == "enter") ? "\n" : separate;
    var quality = $(strXml).find("quality").text();
    var checkedItems = $('#radiationData').datagrid('getChecked');
	var param = {"action":"GET_DOCUMENT_CONTEXT"};
	documentContext = parent.eventDispatch(param);
    $.each(checkedItems, function(index, item) {
        if (quality == "1")
		{
			var happenDatetime = documentContext.HappenDateTime;
			var tmpDatetime = item.AuthorisationDate + " "+ item.AuthorisationTime;
			if (compareDateTime(tmpDatetime,happenDatetime))
			{
				alert("审核时间大于病历时间,不能引用");
				return false;
			}
		}
        if (quoteData[item.ID]) {
            //收集父内容
            for (var i = 0; i < parentList.length; i++) {
                result = result + parentList[i].desc + item[parentList[i].code] + parentList[i].separate;
            }
            if (checkedItems.length - 1 > index) {
                result = result + separate;
            }
            
	    //inputReferenceDataLog(item.EpisodeID,item.ID,item.OEordItemDesc)  
        }
    });
    resultItems.push({ "TEXT": result });
    var param = { "action": "INSERT_STYLE_TEXT_BLOCK", "args": { "items": resultItems } };
    parent.eventDispatch(param);
    UnCheckAll();
}

//去掉选择
function UnCheckAll() {
    $("#radiationData").datagrid("uncheckAll");
}

//记录用户引用检验数据记录
function inputReferenceDataLog(episodeId,ID,OEordItemDesc)
{
	jQuery.ajax({
			type : "GET",
			dataType : "text",
			url : "../EMRservice.Ajax.radiationData.cls",
			async : true,
			data : {
						"Action":"InputReferenceDataLog",
						"EpisodeID":episodeId,
						"ID":ID,
						"OEordItemDesc":OEordItemDesc
					},
			success : function(d) {
					},
			error : function(d) { alert("input ReferenceDataLog error");}
		});	
}
