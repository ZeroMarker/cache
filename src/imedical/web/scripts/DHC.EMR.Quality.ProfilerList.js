$(function() {
    setDataGrid();
});
function doneCheck()
{
	
//alert(userID);      
	//已处理按钮事件
    var gridRows = $('#QualityData').datagrid("getChecked");
    if (gridRows.length == 0){
        $.messager.alert('提示', '请至少选择一条记录！', 'error');
        return;           
    }
   
    var messageIDS = "";
    for (var i = 0; i < gridRows.length; i++) {
        var gridRow = gridRows[i];
        var messageID = gridRow["MessageID"];
        if (messageIDS == "") {
            messageIDS = messageID;
        }
        else {
            messageIDS = messageIDS + "^" + messageID;
        }
    }
    
    var ret = ""
    var obj = $.ajax({
        url: "../web.eprajax.AjaxEPRMessage.cls?Action=donemessage&MessageIDS=" + messageIDS + "&UserID=" + userID + "&EpisodeID=" + EpisodeID,
        type: 'post',
        async: false
    });
    var ret = obj.responseText;
    if ((ret != "" || (ret != null)) && (ret != "-1")) {
        $('#QualityData').datagrid('reload');
    }
    else {
        $.messager.alert('错误', '提交已处理失败，请再次尝试！', 'error');
    }	
}

//设置数据
function setDataGrid() {
    $('#QualityData').datagrid({
        pageSize: 30,
        pageList: [10, 20, 30],
        loadMsg: '数据装载中......',
        autoRowHeight: true,
        url: '../EMRservice.Ajax.Quality.cls?Action=GetProfilerList&EpisodeID='+EpisodeID+'&RuleID='+RuleID+'&CTLocatID='+CTLocatID+'&userID='+userID+'&action='+action,
        rownumbers: true,
        pagination: false,
        singleSelect: false,
        //nowrap: false,
        fitColumns: true,
        fit: true,
        scrollbarSize :0,
        columns: [[
        	{ field: 'ck', checkbox: true },
        	{
                field: 'CreateDateTime',
                title: '质控时间',
                halign: 'left',
                align: 'left',
                width: 160
            }, {
                field: 'StructName',
                title: '质控类型',
                halign: 'left',
                width: 80
            }, {
                field: 'MessageBody',
                title: '质控缺陷',
                halign: 'left',
                width: 250
            }, {
                field: 'EntryScore',
                title: '评分标准',
                halign: 'left',
                align: 'left',
                width: 80
            }, {
                field: 'ExamCount',
                title: '次数',
                halign: 'left',
                align: 'left',
                width: 50
            },/* {
                field: 'Score',
                title: '扣分',
                halign: 'left',
                align: 'left',
                width: 20
            },*/
			{
                field: 'CreateUserDesc',
                title: '质控医师',
                halign: 'left',
                align: 'left',
                width: 150
            }, {
                field: 'ExecuteStatus',
                title: '状态',
                halign: 'left',
                align: 'left',
                width: 130
            }
            , {
                field: 'ExecuteDateTime',
                title: '处理时间',
                halign: 'left',
                align: 'left',
                width: 150
            }]
        ],/*
        toolbar:['->',{
	        iconCls:'icon-edit',
	        text:'确认执行',
	        //iconAlign:'right',
	        handler:function(){
		       		doneCheck();
		        }
	        }],*/
        view: groupview,
        groupField: 'Name',
        groupFormatter: function(value, rows) {
            return value + ' － ' + rows.length;
        },
        onCheck: function(rowIndex, rowData) {

        },
        onUncheck: function(rowIndex, rowData) {

        },
        onCheckAll: function(rows) {

        },
        onUncheckAll: function(rows) {

        }
    });
}



