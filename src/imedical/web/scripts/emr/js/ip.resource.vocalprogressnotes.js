var NotesSubItems= "";
$(function(){
	strXml = convertToXml(scheme);
	var interface = $(strXml).find("interface").text();
	pageConfig = $(strXml).find("pageConfig").text();
	$("#comboxEpisode").hide();
	initEpisodeList("#EpisodeList");
	setDataGrid(interface);
	
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
				resourceConfig.Notes = this.id;
			} 
        }
    });
    
	if (pageConfig == "Y")
	{
		//获取其它资源区的查询按钮配置项数据
		resourceConfig = getResourceConfig();
		var configItem = resourceConfig.Notes;
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
		
		
	
	$('#notesDataPnl').panel('resize', {
		height: $('#dataPnl').height() * 0.50
	});
 
	$('body').layout('resize');	
});

//设置数据
function setDataGrid(interface)
{
	if ($('#allEpisode')[0].checked)
	{
		var param = {
			EpisodeIDS: getAllEpisodeIdByPatientId(),
			StartDateTime: "",
			EndDateTime: ""
		};
	}else{
		var param = getParam();
	}
	
	
	$('#notesData').datagrid({
	    pageSize:10,
	    pageList:[10,20,30], 
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    url:'../EMRservice.Ajax.VocalProgressNotes.cls?Action=GetPostResult&InterFace='+encodeURI(encodeURI(interface)), 
	    rownumbers:true,
	    pagination:true,
	    singleSelect:true,
	    queryParams:param,
	    fit:true,
	    columns:getColumnScheme("show>parent>item"),
	    onSelect:function(rowIndex,rowData){
		    var subId = rowData.SourceID;
		    quoteData[subId]={};
			getNotesSubData(interface,subId);
		},
		onUnselect:function(rowIndex,rowData){
			 $('#notesSubData').datagrid('loadData', { total: 0, rows: [] });
            quoteData = {};
		},
		onCheckAll:function(rows)
		{
			$('#notesSubData').datagrid('loadData', { total: 0, rows: [] });
            quoteData = {};
            
		},
		onUncheckAll:function(rows)
		{
            $('#notesSubData').datagrid('loadData', { total: 0, rows: [] });
            quoteData = {};
		}
	});
	
	$('#notesSubData').datagrid({
	    headerCls:'panel-header-gray',
        loadMsg: '数据装载中......',
        autoRowHeight: true,
        url: '../EMRservice.Ajax.VocalProgressNotes.cls?Action=GetVocalProgressNoteDetail&InterFace=' + encodeURI(encodeURI(interface)),
        singleSelect: true,
        rownumbers: true,
        singleSelect: false,
        fit: true,
        columns: getColumnScheme("show>child>item"),
        onCheck: function(rowIndex, rowData) {
            quoteData[rowData.SourceID]["child" + rowIndex] = { "NoteDetail": rowData.NoteDetail};
            //HOS（医呼通）IE 可播放mp3 、医为浏览器仅支持wav格式音频
            //测试播放代码：$("#soundPlayer")[0].src="../audio/1000.wav"
	    $("#soundPlayer")[0].src=rowData.SourceAddr;
        },
        onUncheck: function(rowIndex, rowData) {
            delete quoteData[rowData.SourceID]["child" + rowIndex];
        },
        rowStyler: function(index, rowData) {
            if (rowData.SoundAddress != "")
            {
             	rowData.Operations='<a class="hisui-linkbutton" data-options="iconCls:\'icon-run\',plain:true" onClick="playAudio()"></a>';
             	rowData.Operations=rowData.Operations + '<a class="hisui-linkbutton" data-options="iconCls:\'icon-pause\',plain:true" onClick="pauseAudio()"></a>';
             	$.parser.parse()
             	return;
            }
            
        },
    });

}

// 取备忘录内容
function getNotesSubData(Interface,SourceID)
{
	 $('#notesSubData').datagrid('load', {
        "Action":"GetPostResultDetailed",
		"SourceID":SourceID
    });
    
}

// 查询
function queryData()
{
	var param = getParam();
	$('#notesData').datagrid('load',param);
}
//获取查询参数
function getParam()
{
	quoteData = {};
	var stDateTime = "",endDateTime = "";
	var epsodeIds = episodeID;
	if ($('#currentDay')[0].checked)
	{
		stDateTime = new Date().format("yyyy-MM-dd");
		endDateTime = new Date().format("yyyy-MM-dd"); 

	}
	else if ($('#ThreeDays')[0].checked)
	{
		var start = new Date();
		start.setDate(start.getDate() - 2);
		stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate()   
		endDateTime = new Date().format("yyyy-MM-dd");
		
	}
	else if ($('#sevenDays')[0].checked)
	{
		var start = new Date();
		start.setDate(start.getDate() - 6);
		stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate()   
		endDateTime = new Date().format("yyyy-MM-dd");
	}
	else if ($('#currentWeek')[0].checked)
	{
		var now = new Date();  
		var start = new Date();  
		var n = now.getDay();  
		start.setDate(now.getDate()-n+1);  
		stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate();   
		endDateTime = new Date().format("yyyy-MM-dd");
		
	}
	else if ($('#allEpisode')[0].checked)
	{
		epsodeIds = "";
		var values = $('#EpisodeList').combogrid('getValues');
		for (var i=0;i< values.length;i++)
		{
			epsodeIds = (i==0)?"":epsodeIds + ",";
			epsodeIds = epsodeIds + values[i];
		}	
		rrtedFlag = "";	
	}
	
	else if ($('#currentEpisode')[0].checked)
	{
		//本次就诊
		rrtedFlag = 1;
	}
	
	var param = {
		EpisodeIDS: epsodeIds,
		StartDateTime: stDateTime,
		EndDateTime: endDateTime
	};
	return param;	
}
//引用数据
function getData()
{
	var resultItems = new Array();
    var result = "";
    var parentList = getRefScheme("reference>parent>item");
    var childList = getRefScheme("reference>child>item");
    var separate = $(strXml).find("reference>separate").text();
    separate = (separate == "enter") ? "\n" : separate;
    var quality = $(strXml).find("quality").text();
    var checkedItems = $('#notesData').datagrid('getChecked');
	var param = {"action":"GET_DOCUMENT_CONTEXT"};
	documentContext = parent.eventDispatch(param);
	
    $.each(checkedItems, function(index, item) {
        
        if (quoteData[item.SourceID]) {
            //收集父内容
            for (var i = 0; i < parentList.length; i++) {
                result = result + parentList[i].desc + item[parentList[i].code] + parentList[i].separate;
            }
            //收集子表内容
            $.each(quoteData[item.SourceID], function(index, item) {
                for (j = 0; j < childList.length; j++) {
                    
                    result = result + childList[j].desc + item[childList[j].code];
                    
                    result = result + childList[j].separate;
                }
                
            });
            if (checkedItems.length - 1 > index) {
                result = result + separate;
            }
            
        }
    });
    resultItems.push({ "TEXT": result });
    var param = { "action": "INSERT_STYLE_TEXT_BLOCK", "args": { "items": resultItems } };
    parent.eventDispatch(param);
    UnCheckAll();
}

//去掉选择
function UnCheckAll()
{
	$("#notesData").datagrid("uncheckAll");
}

$("#playAudio").on("click",function(){
		playAudio();
		
})
function playAudio()
{
	var obj=document.getElementById("soundPlayer")
    obj.play();
}

$("#pauseAudio").on("click",function(){
	
	pauseAudio();
		
})
function pauseAudio(){
	var obj=document.getElementById("soundPlayer")
    obj.pause();	
}