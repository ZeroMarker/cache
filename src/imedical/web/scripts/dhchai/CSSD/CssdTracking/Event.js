//器械追溯查询
//页面Event
function InitAssRateWinEvent(obj)
{
    obj.LoadEvent = function (args)
    {
        $('#btnQuery').on('click', function ()
        {
            obj.btnQuery_click();
        });
    
        $HUI.combogrid('#AssessRate',
        {
            onSelect: function (index, row)
            {
				var ModelID = row.ID;
				var AdmStatus = row.AdmStatus;
				if (AdmStatus)
				{
					$HUI.radio('#radAdmStatus-'+AdmStatus).setValue(true);
				}
				objSttDate = row.SttDate;
				objEndDate = row.EndDate;
						
				$('#StartDate').datebox('setValue',objSttDate);
				$('#EndDate').datebox('setValue',objEndDate);
			
				obj.btnQuery_click();
			}
        });
    }
    //打印
    obj.btnPrint = function () {
        $('#AssessRate').datagrid('print', '器械追踪查询');
    }
    //导出
    obj.btnexport = function () {
        
        $('#AssessRate').datagrid('toExcel', '器械追踪查询.xls');
    }
    //登记号判断
    $('#txtPapmiNo').bind('keydown', function (e)
    {
        if (this.value.length > 10)
        {
   	        this.value = this.value.substring(0, 10);
   	    }
   	    this.value = this.value.replace(/[^\d]/g, '');
   	    var Reglength = this.value.length;
   	    if (e.keyCode == 13)
   	    {
   	        if (Reglength != 0)
   	        {
   	            for (var i = 0; i < (10 - Reglength) ; i++)   //登记号回车自动补零
   	            {
   	                this.value = "0" + this.value;
   	            }
   	        }
   	    }
    });
    //查询事件
    obj.btnQuery_click = function ()
    {
   	    var SendDate = $('#SendDate').val();   //时间类型
   	    var DateFrom = $('#StartDate').datebox('getValue');    //开始时间
   	    var DateTo = $('#EndDate').datebox('getValue');    //结束时间
   	    var TxtRegNo = $("#txtRegNo").val();   //器械条码
   	    var TextBatchNum = $("#textBatchNum").val();   //灭菌批次
   	    var txtPapmiNo = $("#txtPapmiNo").val();     //登记号
   	    //时间条件判断
   	    //获取当前时间
   	    var now = new Date();
   	    var year = now.getFullYear();       //年
   	    var month = now.getMonth() + 1;     //月
   	    var day = now.getDate();            //日
   	    if (day < 10) { day="0"+day}
		var NowDate = year + "-" + month + "-" + day;
		if((DateFrom=='')||(DateTo==''))
		{
		    $.messager.alert("提示", "开始日期或结束日期不能为空", 'info');
		    return;
		}
		else
		{
		    if (DateTo > NowDate)
		    {
		        $.messager.alert("提示", "开始日期或结束日期不能大于当前日期", 'info');
		        return;
		    }
		    if (DateFrom > DateTo)
		    {
		        $.messager.alert("提示", "开始日期不能晚于结束日期！", 'info');
		        return;
		    }
		}
	
		obj.gridAssRate.load(
        {
		    ClassName: 'DHCHAI.DI.DHS.SyncCSSDInfo',
		    QueryName: 'QryCssdList',
		    iDateType: SendDate,
		    iDateFrom: DateFrom,
		    iDateTo: DateTo,
		    iBarCode: TxtRegNo,
		    iBatchNumberS: TextBatchNum,
		    iPatNo:txtPapmiNo
	    });
	}	
}
