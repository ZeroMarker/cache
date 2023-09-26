//名称 dhcpe.healthguide.hisui.js
//功能 健康分析指导
//创建 
//创建人 jinlei

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
			$('#patName').text("模板...");
			$('#sexName').text("模板...");
			$('#Age').text("模板...");
			$('#PatNo').text("模板...");
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
	//全部就诊记录 Type All 选中记录之前 BSel
	var CanDiagnosisListObj = $HUI.datagrid("#CanDiagnosisList",{
		fit: true,
		border: false,
		striped: true, //是否显示斑马线效果
		singleSelect: true,
		selectOnCheck: false,
		autoRowHeight: false,
		showFooter: true,
		url: $URL,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
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
		    {field:'AdmDate',title:'体检日期',width:100},
			{field:'VIPLevel',title:'VIP',hidden:true},
			{field:'VIPDesc',title:'VIP等级',width:100}
		]],
		onClickRow:function(rowIndex, rowData){
			var PatientID=getValueById("PatientID")
			$("#CurPAADM").val(rowData.PaadmID)
			$("#ViewEDate").val(rowData.AdmDate)
			ShowDiagnosisPanel(rowData.PaadmID,PatientID);	
			ViewQuery();    
	    }   
	});
	//选中的就诊记录之前的就诊记录
	var ViewDiagnosisListObj = $HUI.datagrid("#ViewDiagnosisList",{
		fit: true,
		border: false,
		striped: true, //是否显示斑马线效果
		singleSelect: true,
		selectOnCheck: false,
		autoRowHeight: false,
		showFooter: true,
		url: $URL,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
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
		    {field:'AdmDate',title:'体检日期',width:100},
			{field:'VIPLevel',title:'VIP',hidden:true},
			{field:'VIPDesc',title:'VIP等级',width:100}
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
	if (PatArr[2] == '男') {
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
    	  title:"分析指导首页",
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
	    	  title:"体检结果",
	    	  content:content
	            
	    });
	}
	
	//data analysis 数据分析
	Type="DAS"
	var url="dhcpe.healthguide.edit.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#DiagnosisTab').tabs('add', {
          selected:false,
    	  title:"数据分析",
    	  content:content
            
    });
	//risk assessment 风险评估
	Type="Risk"
	var url="dhcpe.healthguide.edit.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#DiagnosisTab').tabs('add', {
          selected:false,
    	  title:"风险评估",
    	  content:content
            
    });
	//Plan Making 方案指定
	Type="Plan"
	var url="dhcpe.healthguide.edit.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#DiagnosisTab').tabs('add', {
          selected:false,
    	  title:"方案制定",
    	  content:content
            
    });
	//CRM Records 随访记录
	Type="CRM"
	var url="dhcpe.healthguide.edit.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#DiagnosisTab').tabs('add', {
          selected:false,
    	  title:"随访记录",
    	  content:content
            
    });
	//effect evaluation  疗效评估
	Type="Effect"
	var url="dhcpe.healthguide.edit.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

	$('#DiagnosisTab').tabs('add', {
          selected:false,
    	  title:"疗效评估",
    	  content:content
            
    });
	//Remark 需求备注
	Type="Remark "
	var url="dhcpe.healthguide.edit.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
	$('#DiagnosisTab').tabs('add', {
          selected:false,
    	  title:"需求备注",
    	  content:content
            
    });
	
	$('#DiagnosisTab').tabs('select',"分析指导首页");
	
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
	openHistoryWin(PAADM,PatientID);
	ShowHistoryTabs(PAADM,PatientID);
	
	
}
function ShowHistoryTabs(PAADM,PatientID)
{
	closeAllTabs('ViewDiagnosisTab');
	var Type;
	//data analysis 数据分析

	Type="DAS"
	var url="dhcpe.healthguide.print.csp?PatientID="+PatientID+"&PAADM="+PAADM+"&Type="+Type;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:"550px";"></iframe>';

	$('#ViewDiagnosisTab').tabs('add', {
          selected:false,
    	  title:"数据分析",
    	  content:content
            
    });
    
    /*
    
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
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:;"></iframe>';

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
    */
    $('#ViewDiagnosisTab').tabs('select',"数据分析");
	
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
			title='健康分析指导历史记录',
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
			title:'健康分析指导历史记录',
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