//���� dhcpe.healthguide.hisui.js
//���� ��������ָ��
//���� 
//������ jinlei

var init=function(){
	
	
	$("#RegNo").focus();	
	$("#RegNo").change(function(){
  			RegNoOnChange();
		});
		
	
	$("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				RegNoOnChange();
				
			}
			
        });
	$("#Query").click(function(){
  			Query();
  			
		});
	$("#ViewQuery").click(function(){
  			ViewQuery();
		});
	$HUI.checkbox(("#HGTemplate"),{
        onChecked:function(e,value)
        {
	        $("#RegNo").val("");
	        $("#PatientID").val("");
	        Query();
	        ViewQuery();
	        $("#PatientID").val("Template");
			$('#patName').text("ģ��...");
			$('#sexName').text("ģ��...");
			$('#Age').text("ģ��...");
			$('#PatNo').text("ģ��...");
	        var 
	        TPAADM="Template"
	        TPatientID="Template";
	        
            ShowDiagnosisPanel(TPAADM,TPatientID)
            
            
        },
        onUnchecked:function(e,value)
        {
            closeAllTabs('DiagnosisTab');
        } 
    });
	//ȫ�������¼ Type All ѡ�м�¼֮ǰ BSel
	var CanDiagnosisListObj = $HUI.datagrid("#CanDiagnosisList",{
		fit: true,
		border: false,
		striped: true, //�Ƿ���ʾ������Ч��
		singleSelect: true,
		selectOnCheck: false,
		autoRowHeight: false,
		showFooter: true,
		url: $URL,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		pageSize: 15,
		pageList: [15, 20, 25, 30],
		
		queryParams:{
			ClassName:"web.DHCPE.HealthGuide",
			QueryName:"FindNeedHMPatInfo",
			PatientID:"",
			CurPAADM:"",
			BDate:"",
			EDate:""
		},
		columns:[[
		    {field:'PaadmID',hidden:true},
		    {field:'AdmDate',title:'�������',width:100},
			{field:'VIPLevel',title:'VIP',hidden:true},
			{field:'VIPDesc',title:'VIP�ȼ�',width:100}
		]],
		onClickRow:function(rowIndex, rowData){
			var PatientID=getValueById("PatientID")
			$("#CurPAADM").val(rowData.PaadmID)
			$("#ViewEDate").val(rowData.AdmDate)
			ShowDiagnosisPanel(rowData.PaadmID,PatientID);	
			ViewQuery();    
	    }   
	});
	//ѡ�еľ����¼֮ǰ�ľ����¼
	var ViewDiagnosisListObj = $HUI.datagrid("#ViewDiagnosisList",{
		fit: true,
		border: false,
		striped: true, //�Ƿ���ʾ������Ч��
		singleSelect: true,
		selectOnCheck: false,
		autoRowHeight: false,
		showFooter: true,
		url: $URL,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		pageSize: 15,
		pageList: [15, 20, 25, 30],
		
		queryParams:{
			ClassName:"web.DHCPE.HealthGuide",
			QueryName:"FindNeedHMPatInfo",
			PatientID:"",
			CurPAADM:"",
			BDate:"",
			EDate:""
		},
		columns:[[
		    {field:'PaadmID',hidden:true},
		    {field:'AdmDate',title:'�������',width:100},
			{field:'VIPLevel',title:'VIP',hidden:true},
			{field:'VIPDesc',title:'VIP�ȼ�',width:100}
		]],
		onClickRow:function(rowIndex, rowData){
			var PatientID=getValueById("PatientID")
			ShowHistoryHGPage(rowData.PaadmID,PatientID);
	    } 
	});
	
	
};
function RegNoOnChange()
{
	var RegNo=getValueById("RegNo")
	if(RegNo!="") {
		var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
		$("#RegNo").val(RegNo)
	}
	if (RegNo=="") return ;
	var PatInfo=tkMakeServerCall("web.DHCPE.HealthGuide","GetPatBaseIfo",RegNo);
	if (PatInfo=="") return ;
	var PatArr=PatInfo.split("^");
	
	$("#PatientID").val(PatArr[0]);
	$('#patName').text(PatArr[1]);
	$('#sexName').text(PatArr[2]);
	if (PatArr[2] == '��') {
		$('#sex').removeClass('woman').addClass('man');
	} else {
		$('#sex').removeClass('man').addClass('woman');
	}
	$('#Age').text(PatArr[3]);
	$('#PatNo').text(PatArr[4]);
	Clear();
	Query();
	//ViewQuery();
	ShowDiagnosisPanel("",PatArr[0]);
	
}

function Clear()
{
	$("#BDate").datebox('setValue',"");
	$("#EDate").datebox('setValue',"")
	$("#ViewBDate").datebox('setValue',"");
	$("#ViewEDate").datebox('setValue',"");

}

function Query()
{
	var BDate=$("#BDate").datebox('getValue');
	var EDate=$("#EDate").datebox('getValue');
	var PatientID=getValueById("PatientID")
	var CurPAADM=""
	$("#CanDiagnosisList").datagrid('load',{ClassName:"web.DHCPE.HealthGuide",QueryName:"FindNeedHMPatInfo",PatientID:PatientID,CurPAADM:CurPAADM,BDate:BDate,EDate:EDate}); 
}
function ViewQuery()
{
	var BDate=$("#ViewBDate").datebox('getValue');
	var EDate=$("#ViewEDate").datebox('getValue');
	var PatientID=getValueById("PatientID")
	var CurPAADM=$("#CurPAADM").val()
	$("#ViewDiagnosisList").datagrid('load',{ClassName:"web.DHCPE.HealthGuide",QueryName:"FindNeedHMPatInfo",PatientID:PatientID,CurPAADM:CurPAADM,BDate:BDate,EDate:EDate}); 
}
function ShowDiagnosisPanel(PAADM,PatientID)
{
	closeAllTabs('DiagnosisTab');
	var Type;
	Type="HP"
	var url="dhcpe.healthguide.edit.csp?PatientID="+PatientID+"&Type="+Type ;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
	
	$('#DiagnosisTab').tabs('add', {
          selected:true,
    	  title:"����ָ����ҳ",
    	  content:content       
    });
	if (PAADM=="") return ;
	
	//var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewDiagnosis&MainDoctor="+"N"+"&OnlyRead="+"Y"+"&EpisodeID="+PAADM;
	if (PAADM!=="Template")
	{
		var RegNo=$("#RegNo").val();
		var url="dhcpenewdiagnosis.diagnosis.hisui.csp?MainDoctor="+"&OnlyRead="+"Y"+"&EpisodeID="+PAADM+"&HMRegNo="+RegNo;
		var content = '<iframe id="tabframehistory" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

		$('#DiagnosisTab').tabs('add', {
	          selected:false,
	    	  title:"�����",
	    	  content:content
	            
	    });
	}
	
	//data analysis ���ݷ���
	Type="DAS"
	var url="dhcpe.healthguide.edit.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#DiagnosisTab').tabs('add', {
          selected:false,
    	  title:"���ݷ���",
    	  content:content
            
    });
	//risk assessment ��������
	Type="Risk"
	var url="dhcpe.healthguide.edit.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#DiagnosisTab').tabs('add', {
          selected:false,
    	  title:"��������",
    	  content:content
            
    });
	//Plan Making ����ָ��
	Type="Plan"
	var url="dhcpe.healthguide.edit.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#DiagnosisTab').tabs('add', {
          selected:false,
    	  title:"�����ƶ�",
    	  content:content
            
    });
	//CRM Records ��ü�¼
	Type="CRM"
	var url="dhcpe.healthguide.edit.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#DiagnosisTab').tabs('add', {
          selected:false,
    	  title:"��ü�¼",
    	  content:content
            
    });
	//effect evaluation  ��Ч����
	Type="Effect"
	var url="dhcpe.healthguide.edit.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#DiagnosisTab').tabs('add', {
          selected:false,
    	  title:"��Ч����",
    	  content:content
            
    });
	//Remark ����ע
	Type="Remark "
	var url="dhcpe.healthguide.edit.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
	$('#DiagnosisTab').tabs('add', {
          selected:false,
    	  title:"����ע",
    	  content:content
            
    });
	
	$('#DiagnosisTab').tabs('select',"����ָ����ҳ");
	
}	
function closeAllTabs(id){  
         var arrTitle = new Array();  
         var id = "#"+id;//Tab���ڵĲ��ID  
         var tabs = $(id).tabs("tabs");//�������СTab  
         var tCount = tabs.length;  
         if(tCount>0){  
                     //�ռ�����Tab��title  
             for(var i=0;i<tCount;i++){  
                 arrTitle.push(tabs[i].panel('options').title)  
             }  
                     //�����ռ���titleһ��һ��ɾ��=====���Tab  
             for(var i=0;i<arrTitle.length;i++){  
                 $(id).tabs("close",arrTitle[i]);  
             }  
         }  
 };
 
function ShowHistoryHGPage(PAADM,PatientID)
{	
	openHistoryWin(PAADM,PatientID);
	ShowHistoryTabs(PAADM,PatientID);
	
	
}
function ShowHistoryTabs(PAADM,PatientID)
{
	closeAllTabs('ViewDiagnosisTab');
	var Type;
	//data analysis ���ݷ���

	Type="DAS"
	var url="dhcpe.healthguide.print.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:"550px";"></iframe>';

	$('#ViewDiagnosisTab').tabs('add', {
          selected:false,
    	  title:"���ݷ���",
    	  content:content
            
    });
    
    /*
    
	//risk assessment ��������
	Type="Risk"
	var url="dhcpe.healthguide.print.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#ViewDiagnosisTab').tabs('add', {
          selected:false,
    	  title:"��������",
    	  content:content
            
    });
	//Plan Making ����ָ��
	Type="Plan"
	var url="dhcpe.healthguide.print.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:;"></iframe>';

	$('#ViewDiagnosisTab').tabs('add', {
          selected:false,
    	  title:"�����ƶ�",
    	  content:content
            
    });
	//CRM Records ��ü�¼
	Type="CRM"
	var url="dhcpe.healthguide.print.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#ViewDiagnosisTab').tabs('add', {
          selected:false,
    	  title:"��ü�¼",
    	  content:content
            
    });
	//effect evaluation  ��Ч����
	Type="Effect"
	var url="dhcpe.healthguide.print.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#ViewDiagnosisTab').tabs('add', {
          selected:false,
    	  title:"��Ч����",
    	  content:content
            
    });
	//Remark ����ע
	Type="Remark "
	var url="dhcpe.healthguide.print.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
	$('#ViewDiagnosisTab').tabs('add', {
          selected:false,
    	  title:"����ע",
    	  content:content
            
    });
    */
    $('#ViewDiagnosisTab').tabs('select',"���ݷ���");
	
}
function openHistoryWin(PAADM,PatientID)
{
	
	var o=$("#HGMain").offset();
	var top=o.top-35
	var left=o.left+200
	//var DT=$("#HGMain",window.document)
	//var width=DT.width()*7/10
	//southPanel
	//var height=document.body.clientHeight-200   ;DT.height()*7/10
	var width=800
	var height=600
	var lnkpara=
		'top='+top+',left='+left+',width='+width+',height='+height+','
			resizable=true,
			title='��������ָ����ʷ��¼',
			modal=false,
			collapsible=true,
			isTopZindex=true,
			minimizable=false,
			maximizable=false,
			closable=true,
			hisui=true
	var url="dhcpe.healthguide.edit.history.csp?PAADM="+PAADM+"&PatientID="+PatientID;
	websys_lu(url,false,lnkpara);
	
	/*
	var myWin = $HUI.window("#HGHistory",{
			//iconCls:'icon-w-list',
			resizable:true,
			title:'��������ָ����ʷ��¼',
			modal:false,
			collapsible:true,
			isTopZindex:true,
			minimizable:false,
			maximizable:false,
			closable:true,
			//top:top,
			//left:left,
			width:"800", //width,
			height:"600", //height+"px",
			//content:'<iframe src="dhcpe.healthguide.edit.history.csp?PAADM='+PAADM+'&PatientID='+PatientID+'" width="100%" height="100%" frameborder="0"></iframe>'
			//content:'<div id="ViewDiagnosisTab" class="hisui-tabs" data-options="region:\"center\",border:false" style="position:relative"></div>'
			content:'<div id="ViewDiagnosisTab" class="hisui-tabs" data-options="border:false" style="position:relative,width:"800px",height:"550px"></div>',
			
			
		});
	*/
}
function clearAll()
{
	$('#patName').text("");
	$('#sexName').text("");
	$('#Age').text("");
	$('#PatNo').text("");
}
$(init);