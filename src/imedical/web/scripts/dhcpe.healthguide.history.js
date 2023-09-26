var init=function(){
	var PAADM=$("#PAADM").val();
	var PatientID=$("#PatientID").val();
	ShowHistoryHGPage(PAADM,PatientID);
};
function ViewQuery()
{
	var BDate=getValueById("ViewBDate")
	var EDate=getValueById("ViewEDate")
	var PatientID=getValueById("PatientID")
	var CurPAADM=$("#CurPAADM").val()
	$("#ViewDiagnosisList").datagrid('load',{ClassName:"web.DHCPE.HealthGuide",QueryName:"FindNeedHMPatInfo",PatientID:PatientID,CurPAADM:CurPAADM,BDate:BDate,EDate:EDate}); 
}
function closeAllTabs(id){  
         var arrTitle = new Array();  
         var id = "#"+id;//Tab所在的层的ID  
         var tabs = $(id).tabs("tabs");//获得所有小Tab  
         var tCount = tabs.length;  
         if(tCount>0){  
                     //收集所有Tab的title  
             for(var i=0;i<tCount;i++){  
                 arrTitle.push(tabs[i].panel('options').title)  
             }  
                     //根据收集的title一个一个删除=====清空Tab  
             for(var i=0;i<arrTitle.length;i++){  
                 $(id).tabs("close",arrTitle[i]);  
             }  
         }  
 };
 
function ShowHistoryHGPage(PAADM,PatientID)
{	

	closeAllTabs('ViewDiagnosisTab');
	var Type;
	//data analysis 数据分析

	Type="DAS"
	var url="dhcpe.healthguide.print.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#ViewDiagnosisTab').tabs('add', {
          selected:false,
    	  title:"数据分析",
    	  content:content
            
    });
	//risk assessment 风险评估
	Type="Risk"
	var url="dhcpe.healthguide.print.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#ViewDiagnosisTab').tabs('add', {
          selected:false,
    	  title:"风险评估",
    	  content:content
            
    });
	//Plan Making 方案指定
	Type="Plan"
	var url="dhcpe.healthguide.print.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#ViewDiagnosisTab').tabs('add', {
          selected:false,
    	  title:"方案制定",
    	  content:content
            
    });
	//CRM Records 随访记录
	Type="CRM"
	var url="dhcpe.healthguide.print.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#ViewDiagnosisTab').tabs('add', {
          selected:false,
    	  title:"随访记录",
    	  content:content
            
    });
	//effect evaluation  疗效评估
	Type="Effect"
	var url="dhcpe.healthguide.print.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#ViewDiagnosisTab').tabs('add', {
          selected:false,
    	  title:"疗效评估",
    	  content:content
            
    });
	//Remark 需求备注
	Type="Remark "
	var url="dhcpe.healthguide.print.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
	$('#ViewDiagnosisTab').tabs('add', {
          selected:false,
    	  title:"需求备注",
    	  content:content
            
    });
    $('#ViewDiagnosisTab').tabs('select',"数据分析");

}
$(init);