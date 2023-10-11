$(function(){
	InitData();
});

//初始化列表
function InitData()
{
	$('#waitSignData').datagrid({ 
			width:'100%',
			height:106, 
			headerCls:'panel-header-gray',
			pageSize:20,
			pageList:[10,20,30,50,80,100], 
			fitColumns: true,
			loadMsg:'数据装载中......',
			autoRowHeight: true,
			url:'../EMRservice.Ajax.PersonalWaitSign.cls?Action=GetRecordList&UserID=' + userID + '&AInterface=HISUI',
			singleSelect:true,
			idField:'InstanceID', 
			rownumbers:true,
			pagination:true,
			fit:true,
			remoteSort:false,
			sortName:"PapmiNO",
			columns:[[  
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'InstanceID',title:'InstanceID',width:80,hidden: true},
				{field:'DocID',title:'DocID',width:80,hidden: true},
				{field:'RecordURL',title:'病历链接',width:20,formatter:operateContent,hidden: true},
				{field:'PapmiNO',title:'登记号',width:65,sortable:true},
				{field:'PapmiName',title:'姓名',width:55,sortable:true},
				{field:'DoucumnetDesc',title:'病历名称',width:110,sortable:true},
				{field:'SignUserName',title:'病历创建者',width:50,sortable:true},
				{field:'EMRStatus',title:'病历状态',width:50,sortable:true},
				{field:'documentType',title:'documentType',width:80,hidden: true},
				{field:'chartItemType',title:'chartItemType',width:80,hidden: true},
				{field:'templateId',title:'templateId',width:80,hidden: true},
				{field:'isLeadframe',title:'isLeadframe',width:80,hidden: true},
				{field:'characteristic',title:'characteristic',width:80,hidden: true},
				{field:'isMutex',title:'isMutex',width:80,hidden: true},
				{field:'patientID',title:'patientID',width:80,hidden: true},
				{field:'categoryId',title:'categoryId',width:80,hidden: true}
			]],
		  	onSelect:function(rowIndex,rowData){
				if ($("#frameRecord").attr("src") == "")
				{
					$("#frameRecord").attr("src",rowData.RecordURL+"&MWToken="+getMWToken());
				}	
				else
				{
					changeDocument(rowData);
				}
			},
			onLoadSuccess:function(data){
				if (data.total > 0)
				{
					$('#waitSignData').datagrid('selectRow',0); 
				}
			}
		});
 }
 
function changeDocument(rowData)
{
	var editPage = document.getElementById("frameRecord").contentWindow;
	if (editPage && editPage.length >0)
    {
		editPage.changeRecord(rowData);
    }
}
 
function operateContent(val,row,index)
{
	var span = '<img title="打开病历" align="center" src="../scripts/emr/image/tool/reference.png" style="margin-left:13px;" onclick="openRecord('+"'"+val+"'"+')"/>'
	return span;	
} 

//关闭链接后刷新表格数据
function openRecordCallBack(returnValue,arr)
{
	$('#waitSignData').datagrid('reload');
}

function openRecord(url)
{
	var xpwidth=window.screen.width-60;
	var xpheight=window.screen.height-230;
	var tempFrame = "<iframe id='iframeRecord' scrolling='auto' frameborder='0' src="+url+" style='width:"+xpwidth+"; height:"+xpheight+"; display:block;'></iframe>";
	createModalDialog("dialogInterface","病历链接",xpwidth+5,xpheight+40,"iframeRecord",tempFrame,openRecordCallBack,"");	 
}

/// 创建HISUI-Dialog弹窗
function createModalDialog(dialogId, dialogTitle, width, height, iframeId, iframeContent,callback,arr,maximi,minimi){
    if ($("#modalIframe").length<1)
	{
        $("body").append('<iframe id="modalIframe" style="position: absolute; z-index: 1999; width: 100%; height: 100%; top: 0;left:0;scrolling:no;" frameborder="0"></iframe>');
    }
	else
	{
        $("#modalIframe").css("display","block");
    }
    $("body").append("<div id='"+dialogId+"'</div>");
	if (isNaN(width)) width = 800;
	if (isNaN(height)) height = 500;  
    if(document.getElementById("editor")&&(judgeIsIE()==false))
    	document.getElementById("editor").style.visibility="hidden"; //隐藏插件
	if (maximi == undefined) maximi = false;
    if (minimi == undefined) minimi = false;
    var returnValue = "";
    $HUI.dialog('#'+dialogId,{ 
        title: dialogTitle,
        width: width,
        height: height,
        cache: false,
        collapsible: false,
        minimizable:minimi,
        maximizable:maximi,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        isTopZindex: true,
        content: iframeContent,
        onBeforeClose:function(){
            var tempFrame = $('#'+iframeId)[0].contentWindow;
			if (tempFrame.dialogBeforeClose)
			{
				tempFrame.dialogBeforeClose();
			}
            if (tempFrame)
			{
			    if (typeof(callback) === "function")
				{
                    callback(returnValue,arr);
                }
			}
        },
        onClose:function(){
            $("#modalIframe").hide();
            if(document.getElementById("editor"))
    			document.getElementById("editor").style.visibility="visible"; //隐藏插件
			$("#"+dialogId).dialog('destroy');
        }
    });
}
//关闭dialog,子页面调用
function closeDialog(dialogId)
{
	$HUI.dialog('#'+dialogId).close();
}