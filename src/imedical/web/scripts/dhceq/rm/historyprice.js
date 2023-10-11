$(document).ready(function () {
    initDocument();
});
function initDocument()
{
	var ResourcePriceDR=getElementValue("ResourcePriceDR");
	initResourceHistoryPrice(ResourcePriceDR)
}

function initResourceHistoryPrice(ResourcePriceDR)
{
	$.ajax({
		url :"dhceq.jquery.csp",
        type:"POST",
        data:{
            ClassName:"web.DHCEQ.RM.CTResourcePrice",
            QueryName:"GetResourceHistoryPrice",
            dataType: 'json',
            Arg1:ResourcePriceDR,
            ArgCnt:1
        },
        success:function (data, response, status) {
	        console.log(data)
	        $.messager.progress('close');
	        	if(data)
				{
					data=JSON.parse(data);
	        		createResourceHistoryPrice(data);
				}
	       }
    })
}

function createResourceHistoryPrice(jsonData)
{
	var curYearMonth=""
	$("#ResourceHistoryPriceView").empty(); //每次加载之前移除样式
	//按时间倒序,从最大值遍历
	for (var i=0;i<jsonData.rows.length;i++)
	{
		var statusFlag=0
		var TFromDate="生效日期："+jsonData.rows[i].RHPFromDate
		var TRequestInfo="计价方式："+jsonData.rows[i].RHPModeDesc+"  计价单位:"+jsonData.rows[i].RHPUomQuantity+"/"+jsonData.rows[i].RHPUOMDR_Desc+"  单价:"+jsonData.rows[i].RHPPrice+"元"
		//Modefied by zc0086 2020-11-11 日期格式转化 begin
		//var YearMonth=jsonData.rows[i].RHPFromDate.split("-")[0]+'-'+jsonData.rows[i].RHPFromDate.split("-")[1]; 
		var YearMonth=FormatDate(jsonData.rows[i].RHPFromDate,"","").split("-")[0]+'-'+FormatDate(jsonData.rows[i].RHPFromDate,"","").split("-")[1]; 
		//Modefied by zc0086 2020-11-11 日期格式转化 end
		var TToDate="失效日期："+jsonData.rows[i].RHPToDate
		var section="";
		var flag="";
		if(i==jsonData.rows.length-1) flag=1;
		if ((curYearMonth!=YearMonth)&&(YearMonth!=""))
		{
			curYearMonth=YearMonth;
			section="eq-lifeinfo-lock.png^"+YearMonth;
		}
		opt={
			id:'ResourceHistoryPriceView',
			section:section,
			item:'^^'+'%^^'+TFromDate+'%^^'+TRequestInfo+'%^^'+TToDate,	
			lastFlag:flag,
			onOrOff:statusFlag
		}
		
		createTimeLine(opt);
	}
}