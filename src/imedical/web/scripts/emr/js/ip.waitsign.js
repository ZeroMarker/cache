var curEpisodeID = "";
$(function(){
	initAction();
	InitInPatientList();
	initRadioEvent();
	initNurseData();
	initNoSelectedPng();
});

function initRadioEvent()
{
	$HUI.radio("[name='SignAction']",{
        onCheckChange:function(e,value){
            if (value == true)
            {
	            var tmpvalue = $(e.target).attr("value");
	            if ((tmpvalue == "viceChiefCheck^chiefCheck")||(tmpvalue == "chairmanCheck"))
				{
					$HUI.radio("#currentLoc").setValue(true);
				}
            }
        }
    });
	
}

//Desc:病人列表信息
function InitInPatientList()
{
	$('#patientListData').datagrid({ 
			height:'100%', 
			pageSize:20,
			pageList:[10,20,30,50,80,100], 
			border:false,
			loadMsg:'数据装载中......',
			autoRowHeight: true,
			url:'../EMRservice.Ajax.TemplateSign.cls?Action=GetPatientList&PatListType=InPat&RadioValue=' + defaultRadio + '&SignAction=Check',
			singleSelect:true,
			idField:'EpisodeID', 
			rownumbers:true,
			pagination:true,
			fit:true,
			remoteSort:false,
			sortName:"PAAdmBedNO",
			toolbar:[],
			columns:[[  
				{field:'PatientID',title:'PatientID',width:80,hidden: true},
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'mradm',title:'mradm',width:80,hidden: true},
				{field:'PAPMINO',title:'登记号',width:100,sortable:true},
				{field:'PAPMIName',title:'姓名',width:80,sortable:true},
				{field:'waitsign',title:'待签病历',width:70,sortable:true},
				{field:'PAPMIAge',title:'年龄',width:45,sortable:true},	
				{field:'PAPMISex',title:'性别',width:45,sortable:true},
				{field:'PAAdmWard',title:'病区',width:80,sortable:true,hidden: true},
				{field:'PAAdmBedNO',title:'床号',width:60,sortable:true},	
				{field:'PAAdmDischgeDate',title:'出院日期',width:90,sortable:true},
				{field:'PAAdmDischgeTime',title:'出院时间',width:60,sortable:true,hidden: true},
				{field:'PAAdmDate',title:'就诊日期',width:90,sortable:true},
				{field:'PAAdmTime',title:'就诊时间',width:60,sortable:true,hidden: true}
			]],
			view: detailview,
			detailFormatter: function(rowIndex, rowData){
				return '<div style="padding:2px"><table id="Sub-' + rowIndex + '"></table></div>';
			},
			onClickRow:function(rowIndex,row){
				if (curindex != undefined)
				{
					$("#patientListData").datagrid("collapseRow",curindex);
				}
				$("#patientListData").datagrid("expandRow",rowIndex);
				curindex = rowIndex;
				emptyDocument();
			},
			onExpandRow: function(index,row){
				$('#Sub-'+index).datagrid({
					loadMsg:'数据装载中......',
					autoRowHeight:true,
					url:'../EMRservice.Ajax.TemplateSign.cls?Action=GetRecord&InstanceIDs='+row.WaitSignInstance+'&Interface=HISUI',
					rownumbers:true,
					singleSelect:true,
					idField:'instanceID',
					sortOrder:'desc',
					columns:[[  
						{field:'patientID',title:'PatientID',width:80,hidden: true},
						{field:'epsiodeId',title:'EpisodeID',width:80,hidden: true},
						{field:'instanceID',title:'instanceID',width:80,hidden: true},
						{field:'record',title:'电子病历',width:70,sortable:true,hidden: true},
						{field:'text',title:'病历名称',width:200,sortable:true},
						{field:'status',title:'病历状态',width:100,sortable:true,formatter: StatusOperate},	
						{field:'happendate',title:'病历日期',width:90,sortable:true},
						{field:'happentime',title:'病历时间',width:90,sortable:true}
						
					]],
					onDblClickRow:function(rowIndex,rowData){
						if (($("#frameRecord").attr("src") == "")||(rowData.epsiodeId!=curEpisodeID))
						{
							$("#frameRecord").css("display","block");
							$("#noRecordpngdiv").css("display","none");
							$("#frameRecord").attr("src",rowData.record+"&MWToken="+getMWToken());
							changeDocument(rowData);
						}	
						else
						{
							changeDocument(rowData);
						}
						curEpisodeID = rowData.epsiodeId
					},
					onResize:function(){
						$('#patientListData').datagrid('fixDetailRowHeight',index);
					},
					onLoadSuccess:function(data){
						setTimeout(function(){
							$('#patientListData').datagrid('fixDetailRowHeight',index);
						},0);
					}
				});
				$('#patientListData').datagrid('fixDetailRowHeight',index);
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

function emptyDocument()
{
	var editPage = document.getElementById("frameRecord").contentWindow;
	if (editPage && editPage.length >0)
    {
		editPage.emptyDocument();
    }
}

//查询按钮点击事件
$("#PatientListQuery").click(function () {
	GetData();
});

//查询数据
function GetData()
{
	var signAction =  $("input[name='SignAction']:checked").val();
	var searchType =  $("input[name='SearchType']:checked").val();
	var outStartDate = "";
	var outEndDate = "";
	var papmiNo = "";
	var PatListType = "InPat";
	var DateGap = "";
	if ($('#outthreedays').prop('checked') == true)
	{
		DateGap = $('#outthreedays').prop('value');
		PatListType = "OutPat";
	}
	else if ($('#outsevendays').prop('checked') == true)
	{
		DateGap = $('#outsevendays').prop('value');
		PatListType = "OutPat";
	}
	else if (searchType == "outdate")
	{
		var outStartDate = $('#startDate').datebox('getText');
		var outEndDate = $('#endDate').datebox('getText');
		PatListType = "OutPat";
	}
	else if(searchType == "papmiNo")
	{
		 papmiNo = $("#patientNo").val();
		 PatListType = "PapmiNo";
	}
	var radioValue = "";
	if (userType == "nurse")
    {
	    radioValue = "currentLoc";
    }
    else
    {
		if($('#currentUser').prop('checked') == true)
		{
			radioValue = "currentUser";
		}
		else if($('#currentGroup').prop('checked') == true)
		{
			radioValue = "currentGroup";
		}
		else if($('#currentLoc').prop('checked') == true)
		{
			radioValue = "currentLoc";
		}
    }
	$('#patientListData').datagrid('load', {
		SignAction: signAction,
		PatListType: PatListType,
   	 	OutStartDate: outStartDate,
   	 	OutEndDate: outEndDate,
   	 	PapmiNo: papmiNo,
    	RadioValue: radioValue,
    	DateGap:DateGap
	});
}

//签名状态设置
function StatusOperate(val,row,index)
{
	if((row.status == "完成")&&(row.isWaitsign != "1"))
	{
		var span = '<a>待签</a>';  
		return span;
	}else{
		var span = '<a>'+row.status+'</a>';  
		return span;
	}
}

document.getElementById("GroupSign").onclick = function(){
 	window.open("emr.ip.group.sign.csp?DocID="+docID+ "&ChineseDocID="+chineseDocID+ "&SignType=Doc"+"&MWToken="+getMWToken(), "GroupSign", "channelmode,scrollbars=yes,resizable=yes,status=no,center=yes,minimize=no,maximize=yes");	
};
$('#patientNo').bind('keypress', function(event) {
	if (event.keyCode == "13") {
		setPatientNoLength();
	}
});
///Desc:设置病案号长度 
function setPatientNoLength(){
	var patientNo = $("#patientNo").val();
	if (patientNo != '') 
	{
		if (patientNo.length < 10) 
		{
			for (var i=(10-patientNo.length-1); i>=0; i--)
			{
				patientNo ="0"+ patientNo;
			}
		}
	}
	$("#patientNo").val(patientNo);
}

//待签动作
function initAction()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLTemplateSign",
			"Method":"GetSignRole",
			"p1":userType
		},
		success: function(d) {
			if (d != "")
			{
				result = eval("("+d+")");
				setAction(result);
			}	
		},
		error: function(d) {alert("error");}
	});	
}

function setAction(dataset)
{
    var content = "";
    if (userType == "doctor")
    {
    	content = content + '<span class="item"><input class="hisui-radio" id="Check" data-options="checked:true" value="Check" type="radio" name="SignAction" onclick="changeType()" label="未签病历" /> </span>';
    }
    var nurseSel = "";
    for (var i=0;i<dataset.length;i++)
    {
        var desc = dataset[i].Desc;
        var tmpid = dataset[i].Name;
        var value = dataset[i].Action;
        
        if ((userType == "nurse")&&(i == 0))
        {
	        content = content + '<span class="item"><input class="hisui-radio" id='+tmpid+' data-options="checked:true" value='+value+' type="radio" name="SignAction" label='+desc+' /></span>';
        }
        else
        {
	        content = content + '<span class="item"><input class="hisui-radio" id='+tmpid+' value='+value+' type="radio" name="SignAction" label='+desc+' /></span>';
        }
    }
	$("#signAction").append(content);
    $.parser.parse('#signAction');
}

function initNurseData()
{
	if (userType == "nurse")
    {
	    $("#searchPatientType").hide();
	    GetData();
    }
}

function initNoSelectedPng()
{
	if ("undefined"==typeof HISUIStyleCode || HISUIStyleCode=="")
	{
	 // 炫彩版
	}
	else if (HISUIStyleCode=="lite")
	{
		 // 极简版
		 $("#noRecordpngdiv").append('<center style="margin-top: 10%"><img  src="../images/no_data_lite.png"  alt="请选择患者" /></center>');
		 $("#patlistdiv").css('background-color','#F1F1F1');
		 $("#recordDiv").css('background-color','#F1F1F1');
	}else
	{
		// 炫彩版
		$("#noRecordpngdiv").append('<center style="margin-top: 10%"><img  src="../images/no_data.png"  alt="请选择患者" /></center>');
	}
	$("#frameRecord").css("display","none");
}
