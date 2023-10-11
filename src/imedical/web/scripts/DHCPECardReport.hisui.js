//����	DHCPECardReport.hisui.js
//����	��쿨���ܱ���
//����	2019.10.08
//������  ln

$(function(){
			
	InitCombobox();
	
     
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    //����
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
	
	//Ĭ����쿨����Ϊ"Ԥ�ɽ�"
	$("#CardType").combobox('setValue',"R"); 
    ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPECardReport2.raq");
});

// ���iframe�� ��Ǭcsp ��������
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


//����
function BClear_click(){
	$("#RegNo,#Name").val("");
	$(".hisui-combobox").combobox('setValue',"");
	$("#BeginDate").datebox('setValue',"")
	$("#EndDate").datebox('setValue',"")
	
	//Ĭ����쿨����Ϊ"Ԥ�ɽ�"
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
		
        $("#RegNoL").text("���𿨺�");
	}
	if(CardType=="R")
	{
		 $("#RegNoL").text("�ǼǺ�");
		var regNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",$("#RegNo").val());
		 $("#RegNo").val(regNo);
	}
	BFind_click();	
}
//��ѯ
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
	
	
	//��쿨
	var CardTypeObj = $HUI.combobox("#CardType",{
		valueField:'id',
		textField:'text',
		panelHeight:'140',
		data:[
            {id:'R',text:$g('Ԥ�ɽ�')},
            {id:'C',text:$g('����')}
        ]

	});
	
	//״̬
	var StatusObj = $HUI.combobox("#Status",{
		valueField:'id',
		textField:'text',
		panelHeight:'140',
		data:[
            {id:'N',text:$g('����')},
            {id:'A',text:$g('����')},
            {id:'L',text:$g('��ʧ')},
            {id:'F',text:$g('����')},
  
        ]

	});	
	

}