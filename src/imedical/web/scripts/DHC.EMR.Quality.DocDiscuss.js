$(function(){
	InitCheckedHistory()
	InitAssignedDates()
	GetDiscussInfoByDate(AssignedDate[0].text)

})

// 公共变量初始化
var AssignedDate=[]
var historyDataFlag=0 //是否存在分配数据标志

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
	var listInfo="",selectInfo=[] //这个selectInfo用于在讨论界面的菜单按钮数据
	if(checkDateList==""||checkDateList==undefined)
	{
		listInfo=listInfo+"<div data-options=\"iconCls:'icon-w-plus'\">无历史数据</div>"
		selectInfo.push({id:0,text:'无历史数据'})
	}else
	{
		historyDataFlag=1
		if(checkDateList.indexOf("/")==-1)
		{
			listInfo=listInfo+"<div onclick='getHistoryData(\""+checkDateList+"\")' data-options=\"iconCls:'icon-w-find'\">"+checkDateList+"</div>"
			selectInfo.push({id:checkDateList,text:checkDateList,selected:true})
		}else
		{
			var dateArray=checkDateList.split("/")
		
			for(var i=0;i<dateArray.length;i++)
			{
				listInfo=listInfo+"<div onclick='getHistoryData(\""+dateArray[i]+"\")' data-options=\"iconCls:'icon-w-find'\">"+dateArray[i]+"</div>"
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
	//$("#historyList").append(listInfo)
	//$(listInfo).appendTo("#historyList");
	
	//$("#checkHistory").menubutton({menu:'#historyList',iconCls:'icon-write-order'})
	
}

//讨论意见提交按钮
function submit(){
	
	if(AssignedDate[0].text==="无历史数据")
	{
		$.messager.alert("提示：","暂无分配数据，等待分配病历!","info")
		return
	}
	
	var Idea=$("#idea").val()
	var DiscussDates=$("#cbox").combobox("getValues")
	
	DiscussDates=DiscussDates.join("/")
	
	DiscussDates=DiscussDates.replace(" ","")
	
	if(DiscussDates==""||DiscussDates==undefined)
	{
		$.messager.alert("提示:","请选择本次讨论的所对应的抽查日期!")
		return
	}
	
	$.ajax({
		url:'../EPRservice.Quality.Ajax.OutPatDiscussInfo.cls',
		data:{
			idea:Idea,
			DiscussDates:DiscussDates
		},
		dataType:'text',
		success:function(res){
			$.messager.alert("提示：",res,"info")
			if(res=="提交成功"){
				window.parent.FreshDiscussHistory(DiscussDates)  //打开讨论窗口时刷新下讨论历史数据	
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
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"200",
		editable:false,
		data:AssignedDate,
		onSelect:function(record){
			GetDiscussInfoByDate(record.text)
			
		}
	});
	
	
}

function GetDiscussInfoByDate(date){
	$cm({
		ClassName:"EPRservice.Quality.DataAccess.OutPatDiscussInfo",
		MethodName:"GetDiscussInfo",
		dataType:'text',
		DiscussDates:date
	},function(data){
		if(data!=""){
			$(".hisui-linkbutton").linkbutton({text:'修改'})
			$("#idea").val(data.split("/")[0])
		}else
		{
			$(".hisui-linkbutton").linkbutton({text:'提交'})
			$("#idea").val("")
		}
	});
	
}

