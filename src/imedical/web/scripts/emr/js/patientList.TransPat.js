$(function(){
	var startText="";
	var endText="";
	var flag = "0";
	InitTransPatientList();
	config();
});
//Desc:病人列表信息
function InitTransPatientList()
{
	if (HasPatEncryptLevel == "Y")
	{
		$('#patientListData').datagrid({ 
			width:'100%',
			height:106, 
			pageSize:10,
			pageList:[10,20,30], 
			fitColumns: true,
			loadMsg:'数据装载中......',
			autoRowHeight: true,
			url:'../EMRservice.Ajax.patientInfo.cls?action=GetPatientList&PatListType=TransDept&RadioValue=currentUser&DateGap=2', 
			singleSelect:true,
			idField:'EpisodeID', 
			rownumbers:true,
			pagination:true,
			fit:true,
			remoteSort:false,
			columns:[[  
				{field:'PatientID',title:'PatientID',width:80,hidden: true},
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'mradm',title:'mradm',width:80,hidden: true},
				{field:'SecAlias',title:'病人密级',width:80,sortable:true},
				{field:'EmployeeFunction',title:'病人级别',width:80,sortable:true},
				{field:'TransStartDate',title:'转出日期',width:80,sortable:true},
				{field:'TransStartTime',title:'转出时间',width:80,sortable:true},
				{field:'TransBedNO',title:'转出床号',width:80,sortable:true},
				{field:'PAPMINO',title:'登记号',width:80,sortable:true},
				{field:'PAPMIName',title:'姓名',width:50,sortable:true},
				{field:'PAPMISex',title:'性别',width:40,sortable:true},
				{field:'PAPMIAge',title:'年龄',width:40,sortable:true},
				{field:'PAPMIDOB',title:'出生日期',width:40,sortable:true},
				{field:'PAAdmDepCodeDR',title:'当前科室',width:180,sortable:true},
				{field:'PAAdmBedNO',title:'当前床号',width:80,sortable:true},
				{field:'PAAdmDocCodeDR',title:'主管医生',width:80,sortable:true},
				{field:'TransURL',title:'转出记录',width:80}
			]],
			onDblClickRow: function() {
				var seleRow = $('#patientListData').datagrid('getSelected');
				if (seleRow){
					doSwitch(seleRow.PatientID,seleRow.EpisodeID,seleRow.mradm); 
				}
			}
	  }); 
	}
	else
	{
		$('#patientListData').datagrid({ 
			width:'100%',
			height:106, 
			pageSize:10,
			pageList:[10,20,30], 
			fitColumns: true,
			loadMsg:'数据装载中......',
			autoRowHeight: true,
			url:'../EMRservice.Ajax.patientInfo.cls?action=GetPatientList&PatListType=TransDept&RadioValue=currentUser&DateGap=2', 
			singleSelect:true,
			idField:'EpisodeID', 
			rownumbers:true,
			pagination:true,
			fit:true,
			remoteSort:false,
			columns:[[  
				{field:'PatientID',title:'PatientID',width:80,hidden: true},
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'mradm',title:'mradm',width:80,hidden: true},
				{field:'TransStartDate',title:'转出日期',width:80,sortable:true},
				{field:'TransStartTime',title:'转出时间',width:80,sortable:true},
				{field:'TransBedNO',title:'转出床号',width:80,sortable:true},
				{field:'PAPMINO',title:'登记号',width:80,sortable:true},
				{field:'PAPMIName',title:'姓名',width:50,sortable:true},
				{field:'PAPMISex',title:'性别',width:40,sortable:true},
				{field:'PAPMIAge',title:'年龄',width:40,sortable:true},
				{field:'PAPMIDOB',title:'出生日期',width:40,sortable:true},
				{field:'PAAdmDepCodeDR',title:'当前科室',width:180,sortable:true},
				{field:'PAAdmBedNO',title:'当前床号',width:80,sortable:true},
				{field:'PAAdmDocCodeDR',title:'主管医生',width:80,sortable:true},
				{field:'TransURL',title:'转出记录',width:80}
			]],
			onDblClickRow: function() {
				var seleRow = $('#patientListData').datagrid('getSelected');
				if (seleRow){
					doSwitch(seleRow.PatientID,seleRow.EpisodeID,seleRow.mradm); 
				}
			} 
	  }); 
	}
 }
//按钮查询事件
$("#PatientListQuery").click(check);
function check(){
	startText = $("#startDate").datebox("getValue");
	endText = $("#endDate").datebox("getValue");
	if((startText !=="")&&(endText !==""))
	{
		flag = "1";
		GetData();
	}
	else
	{
		flag = "0";
		GetData();
	}
};
function chooseID(i)
{
	switch (i){
	case 0:
		return $("#DateGap1Radio");
		break;
	case 1:
		return $("#DateGap3Radio");
		break;
	case 2:
		return $("#DateGap7Radio");
		break;
	case 3:
		return $("#DateGap30Radio");
		break;
	case 4:
		return $("#DateGap60Radio");
		break;
	case 5:	
		return $("#DateGap90Radio");
		break;
	default:
		return; 
	}
	$("#id").target.id 
}
function chooseIDName(i)
{
	switch (i){
	case 0:
		return "DateGap1Radio";
		break;
	case 1:
		return "DateGap3Radio";
		break;
	case 2:
		return "DateGap7Radio";
		break;
	case 3:
		return "DateGap30Radio";
		break;
	case 4:
		return "DateGap60Radio";
		break;
	case 5:	
		return "DateGap90Radio";
		break;
	default:
		return; 
	}
}
function chooseText(i){
	switch (i){
	case 0:
		return "当天";
		break;
	case 1:
		return "3天内";
		break;
	case 2:
		return "7天内";
		break;
	case 3:
		return "30天内";
		break;
	case 4:
		return "60天内";
		break;
	case 5:	
		return "90天内";
		break;
	default:
		return; 
	}
}
function chooseValue(i){
	switch (i){
	case 0:
		return "0";
		break;
	case 1:
		return "32";
		break;
	case 2:
		return "6";
		break;
	case 3:
		return "29";
		break;
	case 4:
		return "59";
		break;
	case 5:	
		return "89";
		break;
	default:
		return; 
	}
}
function config()
{
	$("#startDate").datebox({
		required:false
	});
	$("#endDate").datebox({
		required:false
	});
	$("#startDate").datebox("textbox").focus(function(){
   	 	var ali = $(".DateGapRadio");
  		for(var i=0;i<ali.length;i++){
	    	if(ali[i].checked == true){
		    	var id = chooseID(i);
		    	var idName = chooseIDName(i);
		   		var text = chooseText(i);
		   		var value = chooseValue(i);
		    	var curPar = id.parent();
		    	curPar.html('<input type="radio" name="Radio" class="DateGapRadio" id='+idName+'  value='+value+' onclick="radioCheck()">'+text+'</input>');
			}else{
				continue;	
			}
    	}
	})
	$("#endDate").datebox("textbox").focus(function(){
    	var ali = $(".DateGapRadio");
    	for(var i=0;i<ali.length;i++){
	    	if(ali[i].checked == true){
		    	var id = chooseID(i);
		    	var idName = chooseIDName(i);
		   		var text = chooseText(i);
		   		var value = chooseValue(i);
		    	var curPar = id.parent();
		    	curPar.html('<input type="radio" name="Radio" class="DateGapRadio" id='+idName+' value='+value+' onclick="radioCheck()">'+text+'</input>');
			}else{
				continue;
			}		
	 	}
	})	
};
//切换按钮
function radioCheck()
{
	$("#startDate").datebox("setValue","");
	$("#endDate").datebox("setValue","");
	var ali = $(".DateGapRadio");
  	for(var i=0;i<ali.length;i++){
	    if(ali[i].checked == true){
		    var id = chooseID(i);
		    var idName = chooseIDName(i);
		   	var text = chooseText(i);
		   	var value = chooseValue(i);
		    var curPar = id.parent();
		    curPar.html('<input type="radio" name="DateGapRadio" class="DateGapRadio" id='+idName+' value='+value+' checked=true onclick="radioCheck()">'+text+'</input>');
		}else{
			continue;	
		}
    }
    flag = "0";
    GetData();
}

//查询数据
function GetData()
{
	//获取日期范围
	/*
	if ($('#DateGap1Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap1Radio').attr('value');
	}
	else if ($('#DateGap3Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap3Radio').attr('value');
	}
	else if ($('#DateGap7Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap7Radio').attr('value');
	}
	else if ($('#DateGap30Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap30Radio').attr('value');
	}
	else if ($('#DateGap60Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap60Radio').attr('value');
	}
	else if ($('#DateGap90Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap90Radio').attr('value');
	}
	*/
	if(flag == "0"){
	    //正常取时间值
		//获取日期间隔
		if ($('#DateGap1Radio').attr('checked') == "checked")
		{
			var DateGap = $('#DateGap1Radio').attr('value');
		}
		else if ($('#DateGap3Radio').attr('checked') == "checked")
		{
			var DateGap = $('#DateGap3Radio').attr('value');
		}
		else if ($('#DateGap7Radio').attr('checked') == "checked")
		{
			var DateGap = $('#DateGap7Radio').attr('value');
		}
		else if ($('#DateGap30Radio').attr('checked') == "checked")
		{
			var DateGap = $('#DateGap30Radio').attr('value');
		}
		else if ($('#DateGap60Radio').attr('checked') == "checked")
		{
			
			var DateGap = $('#DateGap60Radio').attr('value');
		}
		else if ($('#DateGap90Radio').attr('checked') == "checked")
		{
			var DateGap = $('#DateGap90Radio').attr('value');
		}
	}else{
		//日期框时间值
		DateGap = startText+"^"+endText;
	}
	//获取病人范围
	if ($('#currentUserRadio').attr('checked') == "checked")
	{
		var RadioValue = $('#currentUserRadio').attr('value');
	}
	else if ($('#currentGroupRadio').attr('checked') == "checked")
	{
		var RadioValue = $('#currentGroupRadio').attr('value');
	}
	else if ($('#currentLocRadio').attr('checked') == "checked")
	{
		var RadioValue = $('#currentLocRadio').attr('value');
	}
	$('#patientListData').datagrid('load', {
		action: "GetPatientList",
		PatListType: "TransDept",
   	 	RadioValue: RadioValue,
		DateGap: DateGap
	});
}

//浏览相应的病历
function BrowserRecord(id,pluginType,chartItemType,emrDocId)
{
	//alert(id);
	//alert(pluginType);
	//alert(chartItemType);
	//alert(emrDocId);
	window.open("emr.record.browse.browsform.editor.csp?id="+id+"&pluginType="+pluginType+"&chartItemType="+chartItemType+"&emrDocId="+emrDocId,"");
}

//Desc:切换患者
function doSwitch(PatientID,EpisodeID,mradm) {
	parent.doSwitch(PatientID,EpisodeID,mradm);
}