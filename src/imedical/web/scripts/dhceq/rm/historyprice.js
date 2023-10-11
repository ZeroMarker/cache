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
	$("#ResourceHistoryPriceView").empty(); //ÿ�μ���֮ǰ�Ƴ���ʽ
	//��ʱ�䵹��,�����ֵ����
	for (var i=0;i<jsonData.rows.length;i++)
	{
		var statusFlag=0
		var TFromDate="��Ч���ڣ�"+jsonData.rows[i].RHPFromDate
		var TRequestInfo="�Ƽ۷�ʽ��"+jsonData.rows[i].RHPModeDesc+"  �Ƽ۵�λ:"+jsonData.rows[i].RHPUomQuantity+"/"+jsonData.rows[i].RHPUOMDR_Desc+"  ����:"+jsonData.rows[i].RHPPrice+"Ԫ"
		//Modefied by zc0086 2020-11-11 ���ڸ�ʽת�� begin
		//var YearMonth=jsonData.rows[i].RHPFromDate.split("-")[0]+'-'+jsonData.rows[i].RHPFromDate.split("-")[1]; 
		var YearMonth=FormatDate(jsonData.rows[i].RHPFromDate,"","").split("-")[0]+'-'+FormatDate(jsonData.rows[i].RHPFromDate,"","").split("-")[1]; 
		//Modefied by zc0086 2020-11-11 ���ڸ�ʽת�� end
		var TToDate="ʧЧ���ڣ�"+jsonData.rows[i].RHPToDate
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