$(function(){
	InitCheckedHistory()
	InitAssignedDates()
	GetDiscussInfoByDate(AssignedDate[0].text)

})

// ����������ʼ��
var AssignedDate=[]
var historyDataFlag=0 //�Ƿ���ڷ������ݱ�־

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
	var listInfo="",selectInfo=[] //���selectInfo���������۽���Ĳ˵���ť����
	if(checkDateList==""||checkDateList==undefined)
	{
		listInfo=listInfo+"<div data-options=\"iconCls:'icon-w-plus'\">����ʷ����</div>"
		selectInfo.push({id:0,text:'����ʷ����'})
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

//��������ύ��ť
function submit(){
	
	if(AssignedDate[0].text==="����ʷ����")
	{
		$.messager.alert("��ʾ��","���޷������ݣ��ȴ����䲡��!","info")
		return
	}
	
	var Idea=$("#idea").val()
	var DiscussDates=$("#cbox").combobox("getValues")
	
	DiscussDates=DiscussDates.join("/")
	
	DiscussDates=DiscussDates.replace(" ","")
	
	if(DiscussDates==""||DiscussDates==undefined)
	{
		$.messager.alert("��ʾ:","��ѡ�񱾴����۵�����Ӧ�ĳ������!")
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
			$.messager.alert("��ʾ��",res,"info")
			if(res=="�ύ�ɹ�"){
				window.parent.FreshDiscussHistory(DiscussDates)  //�����۴���ʱˢ����������ʷ����	
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
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
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
			$(".hisui-linkbutton").linkbutton({text:'�޸�'})
			$("#idea").val(data.split("/")[0])
		}else
		{
			$(".hisui-linkbutton").linkbutton({text:'�ύ'})
			$("#idea").val("")
		}
	});
	
}

