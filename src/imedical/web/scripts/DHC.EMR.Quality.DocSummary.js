$(function(){
	InitCheckedHistory()
	InitAssignedDates()
	GetSummaryInfoByDate(AssignedDate[0].text)
	
})

// 公共变量
var AssignedDate=""


//同步方法获取分配时间
function GetAllDateGap(){
	var res=$cm({
		ClassName:"EPRservice.Quality.GetSpotCheckOutPatInfo",
		MethodName:"GetAllDateGap",
		dataType:'text'
	},false);
	
	return res
	
}

//初始化分配历史列表
function InitCheckedHistory()
{
	var checkDateList=GetAllDateGap()
	var selectInfo=[] //这个selectInfo用于在讨论界面的菜单按钮数据
	if(checkDateList==""||checkDateList==undefined)
	{
		selectInfo.push({id:0,text:'无历史数据'})
		
	}else
	{
		
		if(checkDateList.indexOf("/")==-1)
		{
			selectInfo.push({id:checkDateList,text:checkDateList,selected:true})
		}else
		{
			var dateArray=checkDateList.split("/")
		
			for(var i=0;i<dateArray.length;i++)
			{
				if(i==0)
				{
					selectInfo.push({id:dateArray[i],text:dateArray[i],selected:true})
				}else
				{
					selectInfo.push({id:dateArray[i],text:dateArray[i]})
				}
			}	
		}
	}
	
	AssignedDate=selectInfo
	
}

function FreshSummaryHistory(date){
	if(noSummaryFlag===1){
		$("#SummaryList").empty()
	}
	
	var Item="<div class='menu-item' onmouseout='this.style.background=\"white\"' onmouseover='this.style.background=\"#dbecf8\"' onclick='showSummaryHistory(\""+date+"\")' data-options=\"iconCls:'icon-w-find'\"><div class='menu-text'>"+date+"</div><div class='menu-icon icon-w-find'></div></div>"

	$("#SummaryList").append(Item)
	noSummaryFlag=0 //设置有总结数据标志
}

function submit()
{
	if(AssignedDate[0].text==="无历史数据")
	{
		$.messager.alert("提示：","暂无分配数据，等待分配病历!","info")
		return
	}
	
	var summary=$("#summary").val()
	var Dates=$("#cbox").combobox("getValues")
	
	Dates=Dates.join("/")
	$.ajax({
		url:'../EPRservice.Quality.Ajax.OutPatSummaryInfo.cls',
		data:{
			summary:summary,
			Dates:Dates
		},
		dataType:'text',
		success:function(res){
			$.messager.alert("提示：",res,"info")
			if(res==="提交成功"){
				FreshSummaryHistory(Dates)
			}
		}	
	})
}

function InitAssignedDates()
{
	var cbox = $HUI.combobox("#cbox",{
		valueField:'id',
		textField:'text',
		multiple:false,
		//rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"300",
		editable:false,
		data:AssignedDate,
		onSelect:function(record){
			GetSummaryInfoByDate(record.text)
		}
	});
	
	
}

function GetSummaryInfoByDate(date){
	$cm({
		ClassName:"EPRservice.Quality.DataAccess.OutPatSummaryInfo",
		MethodName:"GetInfoBySummaryDate",
		dataType:'text',
		date:date
	},function(d){
		if(d!=""){
			$("#submit").linkbutton({text:'修改'})
			$("#summary").val(d)
		}
		
		if(d==""){
			$("#submit").linkbutton({text:'提交'})
			$("#summary").val("")
		}
	});
	
}