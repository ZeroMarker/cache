//名称 dhcpediagnosispatient.hisui.js
//功能 总检初审hisui
//创建日期 
//创建人 yupeng

var init = function(){
	
	$("#RegNo").focus();
	if(MainDoctor=="Y")
	{
		$HUI.radio("#NoGS").disable();
		
	}
	/// 病人信息列表  卡片样式
	function setCellLabel(value, rowData, rowIndex){
		var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.Name
		 +'</h3><h3 style="float:right;background-color:transparent;"><span>'+ rowData.Sex +'/'+ rowData.Age 
		 +'</span></h3><br>'+'<h3 style="float:left;background-color:transparent;"><span>'+ rowData.AdmDate
		 +'</span></h3>'
		 
		 
		var classstyle="color: #18bc9c";
		if(rowData.GSStatus!=""){
			if(rowData.GSStatus=="未初审") {classstyle="color: #f22613"};
			if(rowData.GSStatus=="未复审") {classstyle="color: #f22613"};
			if(rowData.GSStatus=="已初审") {classstyle="color: #3c78d8"};
			htmlstr = htmlstr +'<h4 style="float:right;background-color:transparent;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+rowData.GSStatus+'</span></h4>';
		}
		 
		htmlstr = htmlstr +'<br>';
		
		htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">ID:'+ rowData.PAPMINo +'</h4>';
		var classstyle="color: #18bc9c";
		if(rowData.VIPLevel!=""){
			if(rowData.VIPLevel==3) {classstyle="color: #f9bf3b"};
			if(rowData.VIPLevel==1) {classstyle="color: #3c78d8"};
			if(rowData.VIPLevel==2) {classstyle="color: #f22613"};
			htmlstr = htmlstr +'<h4 style="float:right;background-color:transparent;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+rowData.VIPDesc+'</span></h4>';
		}
		htmlstr = htmlstr +'</div>';
		return htmlstr;
	}
	
	var VIPObj = $HUI.combobox("#VIP",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc'
	})
		
	//团体
	var GroupObj = $HUI.combogrid("#Group",{
		panelWidth:490,
		url:$URL+"?ClassName=web.DHCPE.PreGADM&QueryName=SearchPreGADMShort",
		mode:'remote',
		delay:200,
		idField:'Hidden',
		textField:'Name',
		onBeforeLoad:function(param){
			param.Code = param.q;
		},
		
		columns:[[
			{field:'Hidden',hidden:true},
			{field:'Name',title:'团体名称',width:140},
			{field:'Code',title:'编码',width:100},
			{field:'Begin',title:'开始日期',width:100},
			{field:'End',title:'截止日期',width:100},
			{field:'DelayDate',title:'状态',width:50}
			
			
		]]
		}) 

		
	$("#Query").click(function(){
  			Query();
		});
	
	$("#RegNo").change(function(){
  			RegNoOnChange();
		});
		
	
	$("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				RegNoOnChange();
			}
			
        });
	
	var CanDiagnosisListObj = $HUI.datagrid("#CanDiagnosisList",{
		url:$URL,
		showHeader:false,
		pagination:true,
		singleSelect:true,
		pageSize:20,
		showRefresh:false,
		displayMsg:"",
		showPageList:false,
		fit:true,
		queryParams:{
			ClassName:"web.DHCPE.ResultNew",
			QueryName:"FindDiagnosisPatInfo",
			MainDoctor:MainDoctor,
			GenStatus:"",
			RegNo:"",
			OtherPAADM:OtherPAADM,
			HospID:session['LOGON.HOSPID']

		},
		columns:[[
			{field:'PatLabel',title:'',width:260,formatter:setCellLabel},
		    {field:'PaadmID',hidden:true},
		    {field:'PAPMINo',title:'登记号',width:50,hidden:true},
		    {field:'AdmDate',title:'体检日期',width:50,hidden:true},
		    {field:'Name',title:'姓名',width:50,hidden:true},
			{field:'Age',title:'年龄',width:50,hidden:true},
			{field:'Sex',title:'性别',width:50,hidden:true},
			{field:'VIPLevel',title:'VIP',width:50,hidden:true},
			{field:'VIPDesc',title:'VIP等级',width:50,hidden:true},
			{field:'GName',title:'团体名称',width:200,hidden:true},
			{field:'GSStatus',title:'总检状态',width:200,hidden:true}
		]],
		onClickRow:function(rowIndex, rowData){
			
	        $('#patName').text(rowData.Name);
	        $('#sexName').text(rowData.Sex);
		    $('#Age').text(rowData.Age);
		    $('#PatNo').text(rowData.PAPMINo);
		    $('#PEDate').text(rowData.AdmDate);
		    $('#VIPLevel').text(rowData.VIPDesc);
		    $('#PatNoName').text("登记号：");
			$('#Remark').text(rowData.ReMark);
		    if (rowData.Sex == '男') {
				$('#sex').removeClass('woman').addClass('man');
			} else {
				$('#sex').removeClass('man').addClass('woman');
			}
			
			$("#PAADM_Hidden").val(rowData.PaadmID);
			$("#GName").text(rowData.GName);
			ShowDiagnosisPanel(rowData.PaadmID);
		    
	    }
	});
	
	
	$("#PersonPanel").panel({
			tools:[{
			iconCls:'icon-w-update',
			handler:function(){
				
			}
			}]
		});
	
	
	
};

/**
 * [设置Iframe的size]
 * @param    {[int]}    flag [0 展开  1 折叠]
 * @Author   wangguoying
 * @DateTime 2019-09-04
 */
function setFramSize(flag){
	
			var tabframeId="tabframediagnosis";
			var tabframe=window.frames[tabframeId];
			if(tabframe){			
				if(tabframe.contentWindow){
					tabframe.contentWindow.setLayoutSize(flag);
				}else{
					tabframe.setLayoutSize(flag);	
				}
				
			}
	
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
 
function ShowDiagnosisPanel(PAADM)
{
	
	
	closeAllTabs('DiagnosisTab');
	
	var url="dhcpenewdiagnosis.diagnosis.hisui.csp?EpisodeID="+PAADM+"&MainDoctor="+MainDoctor+"&OnlyRead="+OnlyRead;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+url+'" style="width:99%;height:99%;"></iframe>';
	
	$('#DiagnosisTab').tabs('add', {
          selected:false,
    	  title:"总检信息",
    	  content:content
            
    });
	
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEContrastWithLast"+"&PAADM="+PAADM;
	
	var content = '<iframe id="tabframehistory" scrolling="auto" frameborder="0"  src="'+url+'" style="width:99%;height:99%;"></iframe>';

	
	
	$('#DiagnosisTab').tabs('add', {
		  fit:true,
          selected:false,
    	  title:"历史结果",
    	  content:content
            
    });
	
	
	var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisInterface");
	if(flag=="1"){
		//新产品组方法
		 //url=tkMakeServerCall("web.DHCEMInterface","GetRepLinkUrl",PAADM,"","E");
		   url=tkMakeServerCall("web.DHCAPPInterface","GetRepLinkUrl",PAADM,"","E");
		}else{
		//pacs组件
  		lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCRisclinicQueryOEItem"+"&EpisodeID="+PAADM;
		}
	
	var content = '<iframe id="tabframerisreport" scrolling="auto" frameborder="0"  src="'+url+'" style="width:98%;height:99%;"></iframe>';

	
	
	$('#DiagnosisTab').tabs('add', {
		  fit:true,
          selected:false,
    	  title:"检查报告",
    	  content:content
            
    });
	
	
	
	var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisInterface");
	if(flag=="1"){
		//新产品组方法
		 //url=tkMakeServerCall("web.DHCEMInterface","GetRepLinkUrl",PAADM,"","L");
		  url=tkMakeServerCall("web.DHCAPPInterface","GetRepLinkUrl",PAADM,"","L");
		}else{
		//pacs组件
  		lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCRisclinicQueryOEItem"+"&EpisodeID="+PAADM;
		}
	
	var content = '<iframe id="tabframelisreport" scrolling="auto" frameborder="0"  src="'+url+'" style="width:99%;height:99%;"></iframe>';

	
	
	$('#DiagnosisTab').tabs('add', {
		  fit:true,
          selected:false,
    	  title:"检验报告",
    	  content:content
            
    });
	
	
	$('#DiagnosisTab').tabs('select',"总检信息");
	
}	


function RegNoOnChange()
{
	var HospID=session['LOGON.HOSPID']
	var RegNo=getValueById("RegNo")
	if(RegNo!="") {
		var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
		$("#RegNo").val(RegNo)
	}

	$("#CanDiagnosisList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindDiagnosisPatInfo",RegNo:$("#RegNo").val(),MainDoctor:MainDoctor,GenStatus:"",HospID:HospID}); 
	
}


function Query()
{
	var HospID=session['LOGON.HOSPID']
	var Name=$("#Name").val();
	var Group=$("#Group").combogrid('getValue',"");
	if (($("#Group").combogrid('getValue')==undefined)||($("#Group").combogrid('getText')=="")){var Group="";}

	var BDate=getValueById("BDate")
	var EDate=getValueById("EDate")
	var VIP=getValueById("VIP")
	var RegNo=getValueById("RegNo")
	if(RegNo!="") {
		var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
		$("#RegNo").val(RegNo)
		}
	
	
	
	var GenStatus=$('input[name="GenStatus"]:checked').val();
	
	$("#CanDiagnosisList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindDiagnosisPatInfo",RegNo:RegNo,BDate:BDate,EDate:EDate,VIP:VIP,PatName:Name,Group:Group,MainDoctor:MainDoctor,GenStatus:GenStatus,HospID:HospID,OtherPAADM:OtherPAADM}); 
	
}

$(init);