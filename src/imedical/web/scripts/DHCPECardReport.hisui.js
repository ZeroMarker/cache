//名称	DHCPECardReport.hisui.js
//功能	体检卡汇总报表
//创建	2019.10.08
//创建人  ln

$(function(){
			
	InitCombobox();
	
     
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
            
    $("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        });
     
         
    $("#CardType").combobox({
		onSelect:function(){
		    CardType_change();	
		}
	});
	
	//默认体检卡类型为"预缴金"
	$("#CardType").combobox('setValue',"R"); 
    ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPECardReport2.raq");
});

// 解决iframe中 润乾csp 跳动问题
function ShowRunQianUrl(iframeId, url) {
    var iframeObj = document.getElementById(iframeId)
    if (iframeObj) {
	    iframeObj.src=url;
	    //debugger;
	    $(iframeObj).hide();
	    if (iframeObj.attachEvent) {
		    iframeObj.attachEvent("onload", function(){
		        $(this).show();
		    });
	    } else {
		    iframeObj.onload = function(){
		        $(this).show();
		    };
	    }
    }
}


//清屏
function BClear_click(){
	$("#RegNo,#Name").val("");
	$(".hisui-combobox").combobox('setValue',"");
	$("#BeginDate").datebox('setValue',"")
	$("#EndDate").datebox('setValue',"")
	
	//默认体检卡类型为"预缴金"
	$("#CardType").combobox('setValue',"R");
	ElementEnble();
	//InitCombobox();
}

function CardType_change()
{
	ElementEnble();
}

function ElementEnble()
{
	 var CardType=$("#CardType").combobox('getValue')
	if (CardType=="C")
	{
		
        $("#RegNoL").text("代金卡号");
	}
	if(CardType=="R")
	{
		 $("#RegNoL").text("登记号");
		var regNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",$("#RegNo").val());
		 $("#RegNo").val(regNo);
	}
	BFind_click();	
}
//查询
function BFind_click(){
	var RegNo="",Name="",Status="",BeginDate="",EndDate="",reportName="";
	var CardType=$("#CardType").combobox('getValue');	
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	iRegNo=$("#RegNo").val();

	if (CardType=="R"){
		if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo);
			$("#RegNo").val(iRegNo)
		};
	}	
	var RegNo=$("#RegNo").val();
	var Name=$("#Name").val();
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');
	var Status=$("#Status").combobox('getValue');
	var CTLOCID=session['LOGON.CTLOCID'];
	
	if (CardType == "R") reportName = "DHCPEYJJReport.raq";
	else  reportName = "DHCPECardReport.raq";
	
	var lnk = "&RegNo=" + RegNo
	        + "&Name=" + Name
			+ "&Status=" + Status
	        + "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&CardType=" + CardType
			+ "&CTLOCID=" + CTLOCID
			;
	
    ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=" + reportName + lnk);
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;

}

function InitCombobox(){
	
	
	//体检卡
	var CardTypeObj = $HUI.combobox("#CardType",{
		valueField:'id',
		textField:'text',
		panelHeight:'140',
		data:[
            {id:'R',text:$g('预缴金')},
            {id:'C',text:$g('代金卡')}
        ]

	});
	
	//状态
	var StatusObj = $HUI.combobox("#Status",{
		valueField:'id',
		textField:'text',
		panelHeight:'140',
		data:[
            {id:'N',text:$g('正常')},
            {id:'A',text:$g('作废')},
            {id:'L',text:$g('挂失')},
            {id:'F',text:$g('冻结')},
  
        ]

	});	
	

}