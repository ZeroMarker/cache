//����	DHCPEArcItemStatistic.hisui.js
//����	���ҽ������ͳ��
//����	2019.09.09
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
    
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEItemDetailStatistic.raq");
})


//����
function BClear_click(){
	
	$("#BeginDate,#EndDate").datebox('setValue')
	$(".hisui-combobox").combobox('setValue',"");
	//$(".hisui-combogrid").combogrid('setValue',"");
	$("#ARCIMDesc").combogrid('setValue',"");
	
	$("#ShowFlag").combobox('setValue',"Item");
    InitCombobox();
	BFind_click();
}


//��ѯ
function BFind_click(){
	var BeginDate = "", EndDate = "", ARCIMDR = "", ShowFlag = "", reportName = "";
	var BeginDate=$("#BeginDate").datebox('getValue');
    var EndDate = $("#EndDate").datebox('getValue');
	
	var ARCIMDR=$("#ARCIMDesc").combogrid("getValue");
	if (ARCIMDR == undefined || ARCIMDR == "undefined") { var ARCIMDR = ""; }
	
	var ShowFlag = $("#ShowFlag").combogrid("getValue");
	if (ShowFlag == "Item") 
	{
		reportName = "DHCPEItemDetailStatistic.raq";
		var lnk = "&BeginDate=" + BeginDate + "&EndDate=" + EndDate + "&ARCIM=" + ARCIMDR;
	}
	else if (ShowFlag == "Set") 
	{
	    reportName = "DHCPESetDetatilStatistic.raq";
	    var lnk = "&BeginDate=" + BeginDate + "&EndDate=" + EndDate;
	}
	else { alert("��ѡ���ѯ���ͣ�"); return false;}	
	var CurLoc = session["LOGON.CTLOCID"];	
	
	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&ARCIM=" + ARCIMDR
			+ "&CurLoc=" + CurLoc
			;
	
    ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=" + reportName + lnk);	
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;
}
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
function InitCombobox(){
	
	//�����Ŀ
	var ARCIMDescObj = $HUI.combogrid("#ARCIMDesc",{
		panelWidth:450,
		panelHeight:243,
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationOrder",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//���   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'id',
		textField:'desc',	
        onBeforeLoad:function(param){
			param.Desc = param.q;
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId=session['LOGON.HOSPID']

		},		
		columns:[[
			{field:'Code',title:'����',width:80},
			{field:'desc',title:'����',width:180},
			{field:'id',title:'ID',width:80}			
		]]
	})
		
	//VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
		
	// ��ѯ����
	$HUI.combobox("#ShowFlag", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'Item',text:$g('��ҽ����ѯ'),selected:true},
			{id:'Set',text:$g('���ײͲ�ѯ')}
		]
	});

}