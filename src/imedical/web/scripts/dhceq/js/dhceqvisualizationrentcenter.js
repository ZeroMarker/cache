/*
** add by zx 2017-05-31
** ��������Ajaxͳһ����
** �ַ������ݴ���
*/
function getVisualization(ClassMethod,Type)
{
	jQuery.ajax({
    	async: false, //true,
    	cache: false,
        url :"dhceq.jquery.method.visualization.csp",
        timeout : 50000,
        type:"POST",
            data:{
            ClassName:"web.DHCEQ.Process.DHCEQVisualization",
            MethodName:ClassMethod,
	        ArgCnt:0
        },
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                    messageShow("","","",XMLHttpRequest.status);
                    messageShow("","","",XMLHttpRequest.readyState);
                    messageShow("","","",textStatus);
        },
        success:function (data, response, status) {
        	jQuery.messager.progress('close');
			data=data.replace(/\ +/g,"");	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"");	//ȥ���س�����
			switch(Type)
			{
				case 1:  //
					initRentStatistics(data);
					break;
				case 2:
					initMoveControl(data);
					break;
				default:
					break;
			}
       }
    })
}
/*
** add by zx 2017-06-01
** ��������Ajaxͳһ����
** Query���ݼ�����
*/
function getVisualizationList(ClassMethod,Type)
{
	jQuery.ajax({
    	async: false, //true,
    	cache: false,
        url :"dhceq.jquery.csp",
        timeout : 50000,
        type:"POST",
            data:{
            ClassName:"web.DHCEQ.Process.DHCEQVisualization",
            QueryName:ClassMethod,
	        ArgCnt:0
        },
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                    messageShow("","","",XMLHttpRequest.status);
                    messageShow("","","",XMLHttpRequest.readyState);
                    messageShow("","","",textStatus);
        },
        success:function (data, response, status) {
        	jQuery.messager.progress('close');
			data=data.replace(/\ +/g,"");	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"");	//ȥ���س�����
			var dataObject=eval('(' + data + ')');
			if(Type==3)
			{
				jQuery("#scrollRent").find("li").remove();
				for (var i=0;i<dataObject.rows.length;i++)
				{
					var TItem=dataObject.rows[i].TItem;
					var TRequestLoc=dataObject.rows[i].TRequestLoc;
					var TStartDate=dataObject.rows[i].TStartDate;
					var TRecieveUser=dataObject.rows[i].TRecieveUser;
					var TActionCode=dataObject.rows[i].TActionCode;
					var TActionDesc=dataObject.rows[i].TActionDesc;
					MakeSpan(TItem,TRequestLoc,TStartDate,TRecieveUser,TActionCode,TActionDesc,Type)
				}
			}
			else if(Type==4)
			{
				jQuery("#scrollMove").find("li").remove();
				for (var i=0;i<dataObject.rows.length;i++)
				{
					var TEquip=dataObject.rows[i].TEquip;
					var TToDept=dataObject.rows[i].TToDept;
					//var TSendUser=dataObject.rows[i].TSendUser;
					//var TStartDate=dataObject.rows[i].TStartDate;
					var TCreateUser=dataObject.rows[i].TCreateUser;
					var TCreateDate=dataObject.rows[i].TCreateDate;
					var TActionCode=dataObject.rows[i].TActionCode;
					var TActionDesc=dataObject.rows[i].TActionDesc;
					MakeSpan(TEquip,TToDept,TCreateDate,TCreateUser,TActionCode,TActionDesc,Type)
				}
			}
       }
    })
}
function initRentStatistics(data)
{
	var myChart = echarts.init(document.getElementById('Rent'));
	option = {
	    tooltip : {
	        trigger: 'axis',
	        axisPointer : {            // ������ָʾ���������ᴥ����Ч
	            type : 'shadow'        // Ĭ��Ϊֱ�ߣ���ѡΪ��'line' | 'shadow'
	        }
	    },
	    legend: {
	        data:['�������','��������','�ڿ�����'],
	        textStyle:{    //ͼ�����ֵ���ʽ
		        color:'#F3E3EE',
		        fontSize:12
	    	}
	    },
	    grid: {
	        left: '3%',
	        right: '4%',
	        bottom: '8%',
	        containLabel: true
	    },
	    xAxis : [
	        {
	            type : 'category',
	            axisLabel: {
		            textStyle:{    //ͼ�����ֵ���ʽ
				        color:'#F3E3EE'
			    	},
		            rotate: 30
		        },
	            axisLine:{
		        	lineStyle:{
		            	color:'#F3E3EE',
		            	width:2
		            }
		      	},
	            data :data.split("^")[0].split(",")
	        }
	    ],
	    yAxis : [
	        {
	            type : 'value',
	            axisLine:{
		        	lineStyle:{
		            	color:'#F3E3EE',
		            	width:2
		            }
		      	},
	            splitLine: {lineStyle:{color: ['#092756']}}
	        }
	    ],
    
	    series : [
	        {
	            name:'�������',
	            type:'bar',
	            stack: '�����豸',
	            itemStyle:{  
	            	normal:{color:'#2551BB'}  
	            },
	            barWidth: 15,
	            data:data.split("^")[1].split(",")
	        },
	        {
	            name:'��������',
	            type:'bar',
	            stack: '�����豸',
	            itemStyle:{  
	            	normal:{color:'#8B2323'}  
	            },
	            barWidth: 15,
	            data:data.split("^")[2].split(",")
	        },
	        {
	            name:'�ڿ�����',
	            type:'bar',
	            stack: '�����豸',
	            itemStyle:{  
	            	normal:{color:'#7828CE'}  
	            },
	            barWidth: 15,
	            data:data.split("^")[3].split(",")
	        }
	    ]
	};
	myChart.setOption(option);
}
function initMoveControl(data)
{
	var myChart = echarts.init(document.getElementById('Move'));
		option = {
	    tooltip: {
	        trigger: 'axis'
	    },
	    legend: {
	        data:['��������','�������'],
	        textStyle:{    //ͼ�����ֵ���ʽ
		        color:'#F3E3EE',
		        fontSize:12
	    	}
	    },
	    grid: {
	        left: '4%',
	        right: '4%',
	        bottom: '8%',
	        containLabel: true
	    },
	    xAxis: {
	        type: 'category',
	        boundaryGap: false,
	        axisLine:{
	        	lineStyle:{
	            	color:'#F3E3EE',
	            	width:2
	            }
	      	},
	      	axisLabel: {
	           show: true,
	           rotate: 30,
	           textStyle: {
	               color: '#F3E3EE'
	           }
	        },
	        data:data.split("^")[0].split(",")
	    },
	    yAxis: {
	        type: 'value',
	        axisLine:{
	        	lineStyle:{
	            	color:'#F3E3EE',
	            	width:2
	            }
	      	},
	       splitLine: {lineStyle:{color: ['#092756']}}
	    },
	    series: [
	        {
	            name:'��������',
	            type:'line',
	            smooth:true,
	            itemStyle:{
	            	normal:{color:'#2163CD'}  
	            },
	            data:data.split("^")[1].split(",")
	        },
	        {
	            name:'�������',
	            type:'line',
	            smooth:true,
	            itemStyle:{
	            	normal:{color:'#7828CE'}  
	            },
	            data:data.split("^")[2].split(",")
	        }
	    ]
	};
	
	myChart.setOption(option);
	myChart.on('click', function (param) {
	var Month=param.name;
		getMaintDetail(Month,"","");
    });
}
/*
** add by zx 2017-06-06
** �����б����ݼ���
*/
function MakeSpan(TItem,TRequestLoc,TStartDate,TRecieveUser,TActionCode,TActionDesc,Type)
{
	var actioncss=""
	switch(TActionCode)
	{
		case 'ZL_Loan':
			actioncss="divcss1";
		break;
		case 'ZL_Return':
			actioncss="divcss2";
		break;
		case 'ZL_LocReturn':
			actioncss="divcss3";
		break;
		case 'PS_Send':
			actioncss="divcss4";
		break;
		case 'PS_SendAudit':
			actioncss="divcss5";
		break;
		case 'PS_Audit':
			actioncss="divcss6";
		break;
		case 'PS_Arrive':
			actioncss="divcss7";
		break;
		default:
			actioncss="divcss6";
		break;
	}
	if (Type==3)
	{
		document.getElementById("scrollRent").innerHTML=
		document.getElementById("scrollRent").innerHTML+'<li><div class="'+actioncss+'">'+TActionDesc+'</div><div class="lidivcss1">'+TRequestLoc+'</div><div class="lidivcss1">'+TItem+'</div>'+
		'<div class="lidivcss2">'+TRecieveUser+'</div><div class="lidivcss2">'+TStartDate+'</div></li>';
	}
	else
	{
		document.getElementById("scrollMove").innerHTML=
		document.getElementById("scrollMove").innerHTML+'<li><div class="'+actioncss+'">'+TActionDesc+'</div><div class="lidivcss1">'+TRequestLoc+'</div><div class="lidivcss1">'+TItem+'</div>'+
		'<div class="lidivcss2">'+TRecieveUser+'</div><div class="lidivcss2">'+TStartDate+'</div></li>';
	}
}

/*
** add by zx 2017-06-06
** ��˳��ˢ�¸���������
*/
function IntervalNext()
{
	switch(IntervalFlag)
	{
		case 1:  //
			getVisualization("EmergencyControl",IntervalFlag);
			IntervalFlag++;
			break;
		case 2:
			getVisualization("MoveControl",IntervalFlag);
			IntervalFlag++;
			break;
		case 3:
			getVisualizationList("GetRentList",IntervalFlag);
			IntervalFlag++;
			break;
		case 4:
			getVisualizationList("GetMoveList",IntervalFlag);
			IntervalFlag=1;
			break;
		default:
			break;
	}
}