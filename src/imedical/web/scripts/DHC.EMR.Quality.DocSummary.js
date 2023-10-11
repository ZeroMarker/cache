$(function(){
	InitCheckedHistory()
	InitAssignedDates()
	GetSummaryInfoByDate(AssignedDate[0].text)
	
})

// ��������
var AssignedDate=""


//ͬ��������ȡ����ʱ��
function GetAllDateGap(){
	var res=$cm({
		ClassName:"EPRservice.Quality.GetSpotCheckOutPatInfo",
		MethodName:"GetAllDateGap",
		dataType:'text'
	},false);
	
	return res
	
}

//��ʼ��������ʷ�б�
function InitCheckedHistory()
{
	var checkDateList=GetAllDateGap()
	var selectInfo=[] //���selectInfo���������۽���Ĳ˵���ť����
	if(checkDateList==""||checkDateList==undefined)
	{
		selectInfo.push({id:0,text:'����ʷ����'})
		
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
	noSummaryFlag=0 //�������ܽ����ݱ�־
}

function submit()
{
	if(AssignedDate[0].text==="����ʷ����")
	{
		$.messager.alert("��ʾ��","���޷������ݣ��ȴ����䲡��!","info")
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
			$.messager.alert("��ʾ��",res,"info")
			if(res==="�ύ�ɹ�"){
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
		//rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
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
			$("#submit").linkbutton({text:'�޸�'})
			$("#summary").val(d)
		}
		
		if(d==""){
			$("#submit").linkbutton({text:'�ύ'})
			$("#summary").val("")
		}
	});
	
}