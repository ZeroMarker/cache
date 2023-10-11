/**
 * ��������  dhcpe.todotasks.js
 * @Author   wangguoying
 * @DateTime 2021-02-04
 */



function initTask(){
	$.cm({
	    wantreturnval: 1,
	    ClassName: 'web.DHCPE.WorkDistribution',
	    MethodName: 'GetTasks',
	    UserID: session["LOGON.USERID"],
	    GroupID: session["LOGON.GROUPID"],
	    LocID: session["LOGON.CTLOCID"]
	}, function(data) {
		if(data.length == 0){
			$.messager.alert("��ʾ","��ǰ�޴�������","info");
			if (HISUIStyleCode == "lite") {
				$('#TaskDiv').html('<div class="no-data-lite"></div>');
				$('#TabPanel').html('<div class="no-data-lite-border"></div>');
			} else {
				$('#TaskDiv').html('<div class="no-data"></div>');
				$('#TabPanel').html('<div class="no-data-border"></div>');
			}
			return false;
		}
		
		var firstSelect = -1;  
		data.forEach( function(element, index) {
			if(firstSelect == -1 && element.total > 0){
				firstSelect = index;				
			}
			add_accordion(element);		
		});
		//ѡ�е�һ���д����¼���ַ������
		$('#TaskList').accordion("select",firstSelect);
	},function(err){
		$.messager.alert("����",err,"error");
	}
);
}

function accordion_select(title,index){
	var firstChild = $("#TaskList").accordion("getPanel",index)[0].firstChild;
	if ( firstChild != null){
		if(firstChild.nodeName == "TABLE"){
			var id = firstChild.id;
			$.cm({
				wantreturnval: 1,
				ClassName: 'web.DHCPE.WorkDistribution',
				MethodName: 'GetTasks',
				UserID: session["LOGON.USERID"],
				GroupID: session["LOGON.GROUPID"],
				LocID: session["LOGON.CTLOCID"],
				FlowCode: id.split("_")[1]
			}, function(data){
				initTasksDatagrid(id,data[0]);
			});
		}
	}
}

/**
 * [���ô����б�]
 * @param    {[Obejct]}     data [�������ݰ�]
 * @param 	 {[boolean]} 	select [�Ƿ�ѡ��]
 * @Author   wangguoying
 * @DateTime 2021-02-05
 */
function add_accordion(data){
	var title = data.desc + "<label id='NUM_"+data.code+"' class='num-tag' style='margin-left: 10px;'>"+data.total +"</label>";
	var content = "<table id='DG_"+data.code+"' border=false></table>";
	
	$('#TaskList').accordion('add', {
		title: title,
		iconCls: 'icon-paper',
		content: content ,
		selected: false,
		animate: true,
		border: false,
		bodyCls: 'addAaccordionStyle'
	});
	/** ѡ���ٳ���ѡ����Ϊ��content��Ⱦ��������ֹ��һ��ѡ��ʱ�޷��������ݱ�� */
	$('#TaskList').accordion("select",title);
	$('#TaskList').accordion("unselect",title);
		
}

/**
 * [���þ����б�]
 * @param    {[String]}    id   [�б�ID]
 * @param    {[Object]}    data [��������]
 * @Author   wangguoying
 * @DateTime 2021-02-05
 */
function initTasksDatagrid(id,data){
	var singleSelect=true;
	var toolbar="";
	if(data.code == "PR"){	//�����ӡ
		singleSelect=false,
		toolbar=[{
	        iconCls: 'icon-all-select',
	        text:'ȫѡ',
	        handler:function(){
	        	close_all_tabs();
	            $("#"+id).datagrid("selectAll");
	        }
	    },{
	        iconCls: 'icon-all-unselect',
	        text:'����ȫѡ',
	        handler:function(){
	            $("#"+id).datagrid("unselectAll");
	        }
	    },{
	        iconCls: 'icon-print',
	        text:'��ӡ',
	        handler:function(){
	        	print_report(id);
	        }
	    }];
	}	
	
	$HUI.datagrid("#"+id,{
		bodyCls:'panel-header-gray',
		border:false,
		showHeader:false,
		showRefresh:false,
		singleSelect:singleSelect,
		onSelect:function(rowIndex,rowData){
			close_all_tabs();
			$("#H_Paadm").val(rowData.paadm);
			$("#H_FlowCode").val(data.code);
			show_task_panel(data.desc,data.code,rowData.paadm);
		},
		onDblClickRow:function(index,row){
															
		},	
		idField:'paadm',
		columns:[[
			{field:'paadm',hidden:true},
			{field:'PatLabel',width:285,formatter:setCellLabel}
		]],
		data: data,
		toolbar: toolbar,
		fitColumns:true,
		pagination:true,
		pageSize:50,
		displayMsg:"",
		fit:true
	});
}


/**
 * [��ӡ����]
 * @param    {[String]}    gridId [�����ӡ�б�ID]
 * @Author   wangguoying
 * @DateTime 2021-02-07
 */
function print_report(gridId){
	var rows=$("#"+gridId).datagrid("getSelections");
	if(rows.length==0){
		$.messager.alert("��ʾ","��ѡ����Ҫ��ӡ�ļ�¼","info");
        return false;
	}
	rows.forEach( function(element, index) {
		var paadm=element.paadm;
		var flowCode=gridId.split("_")[1];
		//���ô�ӡ�߼�
		print(paadm);
		//�����
		var ret=tkMakeServerCall("web.DHCPE.WorkDistribution","FinishTask",paadm,flowCode,session["LOGON.USERID"]);
    	if(ret!=""){
		    $.messager.alert("����",ret,"error");
		    return false;
		}
		$("#"+gridId).datagrid("deleteRow",$("#DG_"+flowCode).datagrid("getRowIndex",paadm));
		var num = $("#NUM_"+flowCode).text();
		$("#NUM_"+flowCode).text(parseInt(num)-1);
	});
}

function print(jarPAADM){
	 var NewVerReportFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",session['LOGON.CTLOCID'],"NewVerReport");
	if(NewVerReportFlag=="Word"){	
		location.href="PEReport://"+jarPAADM+":2:word:1";
	}else {
		BPrintViewLodop(jarPAADM);	
	}
}
function BPrintViewLodop(jarPAADM){	
	var printerName=tkMakeServerCall("web.DHCPE.Report","GetVirtualPrinter");
	PEPrintReport("P",jarPAADM,printerName);
	return false

}




/**
 * [�ر��������]
 * @Author   wangguoying
 * @DateTime 2021-02-05
 */
function close_all_tabs(){
	var arrTitle = new Array();  
	var tabs = $('#TabPanel').tabs("tabs");//�������СTab  
	var tCount = tabs.length;  
	if(tCount>0){  
	             //�ռ�����Tab��title  
	    for(var i=0;i<tCount;i++){  
	        arrTitle.push(tabs[i].panel('options').title)  
	    }  
	             //�����ռ���titleһ��һ��ɾ��=====���Tab  
	    for(var i=0;i<arrTitle.length;i++){  
	        $('#TabPanel').tabs("close",arrTitle[i]);  
	    }  
	}
	$("#H_Paadm").val("");
	$("#H_FlowCode").val("");  
}


/**
 * [�������������]
 * @param    {[String]}    firstTitle [�׸�ҳǩ��ͼ���飩�ı���]
 * @param    {[String]}    code       [ҵ�����ʹ���]
 * @param    {[String]}    paadm      [����ID]
 * @Author   wangguoying
 * @DateTime 2021-02-07
 */
function show_task_panel(firstTitle,code,paadm){
	$('#TabPanel').tabs('add',{
		selected:false,
		id:"title",
		title:"<span style=\"font-weight:600;\">"+firstTitle+"</span>",
		content: ""
	});
	var char0=String.fromCharCode(0);
	var char1=String.fromCharCode(1);
	var char2=String.fromCharCode(2);
	var num=0,selectNum=-1;
	var UserID =session['LOGON.USERID'];
	var LocID =session['LOGON.CTLOCID'];
	var GroupID=session['LOGON.GROUPID'];
	var tabUrls=tkMakeServerCall("web.DHCPE.WorkDistribution","GetLinkUrl",code,paadm,UserID,LocID,GroupID);
	
	if(tabUrls == "") return false;
	tabUrls.split(char0).forEach( function(element, index) {
		num++;
		var title=element.split(char1)[0];
		var url=element.split(char1)[1];
		if(url.split(char2).length>1){
			if(url.split(char2)[1] == "Y"){
				selectNum=num;
			}
		}
		//alert(url)
		var contentstr = '<iframe scrolling="yes" frameborder="0"  src="'+PEURLAddToken(url)+'" style="width:100%;height:100%;"></iframe>';
		$('#TabPanel').tabs('add',{
			selected:false,
			id:num,
    		title:title,
    		content: contentstr
		});
	});
	
	if(selectNum>0){
		$('#TabPanel').tabs('select',selectNum);
	}else{
		$('#TabPanel').tabs('select',1);
	}	
}

/**
 * [����ҽ��¼���վ��Tab]
 * @param    {[int]}    PAADM [����ID]
 * @param    {[String]}    csp   [����csp]
 * @param    {[String]}    title [tabҳǩ����]
 * @Author   wangguoying
 * @DateTime 2021-02-05
 */
function ShowStationPanel(PAADM,csp,title)
{	

	var UserID =session['LOGON.USERID'];
	var LocID =session['LOGON.CTLOCID'];
	var GroupID=session['LOGON.GROUPID'];


	$('#TabPanel').tabs('add',{
		selected:false,
		id:"title",
		title:"<span style=\"font-weight:600;\">"+title+"</span>",
		content: ""
	});
   
	var StationInfo=tkMakeServerCall("web.DHCPE.DocPatientFind","GetStationList",PAADM,UserID,LocID,GroupID);
	var StationList=StationInfo.split(",");
	for(var i=0;i<StationList.length;i++)
	{
		var StationDetail=StationList[i].split("^");
		var url=csp+"?PAADM="+PAADM+"&StationID="+StationDetail[0];
		var tabframe="tabframe"+StationDetail[0];
		var contentstr = '<iframe id="'+tabframe+'" scrolling="yes" frameborder="0"  src="'+PEURLAddToken(url)+'" style="width:100%;height:100%;"></iframe>';
		//alert(contentstr)
		$('#TabPanel').tabs('add',{
			selected:false,
			id:StationDetail[0],
    		title:StationDetail[1],
    		content: contentstr
		});
	
	}	
	var DefaultStation=tkMakeServerCall("web.DHCPE.DocPatientFind","GetDefaultStation",UserID,LocID,GroupID);
	$('#TabPanel').tabs('select',DefaultStation);
}


function ShowDiagnosisPanel(PAADM,csp,title,MainDoctor,OnlyRead)
{	
	$('#TabPanel').tabs('add',{
		selected:false,
		id:"title",
		title:"<span style=\"font-weight:600;\">"+title+"</span>",
		content: ""
	});
	var url=csp+"?EpisodeID="+PAADM+"&MainDoctor="+MainDoctor+"&OnlyRead="+OnlyRead;
	var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+PEURLAddToken(url)+'" style="width:100%;height:100%;"></iframe>';
	
	$('#TabPanel').tabs('add', {
          selected:false,
    	  title:"�ܼ���Ϣ",
    	  content:content       
    });
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEContrastWithLast"+"&PAADM="+PAADM;
	var content = '<iframe id="tabframehistory" scrolling="auto" frameborder="0"  src="'+PEURLAddToken(url)+'" style="width:100%;height:100%;"></iframe>';
	$('#TabPanel').tabs('add', {
          selected:false,
    	  title:"��ʷ���",
    	  content:content
            
    });
	var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisInterface");
	if(flag=="1"){
		//�²�Ʒ�鷽��
		 url=tkMakeServerCall("web.DHCEMInterface","GetRepLinkUrl",PAADM,"","E");
		}else{
		//pacs���
  		lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCRisclinicQueryOEItem"+"&EpisodeID="+PAADM;
		}	
	var content = '<iframe id="tabframerisreport" scrolling="auto" frameborder="0"  src="'+PEURLAddToken(url)+'" style="width:100%;height:100%;"></iframe>';
	$('#TabPanel').tabs('add', {
          selected:false,
    	  title:"��鱨��",
    	  content:content
            
    });
	$('#TabPanel').tabs('select',"�ܼ���Ϣ");	
}


/**
 * [�����]
 * @Author   wangguoying
 * @DateTime 2021-02-05
 */
function finish_task(){
	var paadm=$("#H_Paadm").val();
	var flowCode=$("#H_FlowCode").val();
	if(paadm == "" || flowCode == ""){
		$.messager.alert("��ʾ","��ѡ������б��¼","info");
		return false;
	}
	var ret=tkMakeServerCall("web.DHCPE.WorkDistribution","FinishTask",paadm,flowCode,session["LOGON.USERID"]);
    if(ret!=""){
        $.messager.alert("����",ret,"error");
        return false;
    }
    $.messager.alert("��ʾ","�����","success",function(){
    	
    	$("#DG_"+flowCode).datagrid("deleteRow",$("#DG_"+flowCode).datagrid("getRowIndex",paadm));
	    var num = $("#NUM_"+flowCode).text();
	    $("#NUM_"+flowCode).text(parseInt(num)-1);
	    close_all_tabs();
    });
    
}


/// ������Ϣ�б�  ��Ƭ��ʽ
function setCellLabel(value, rowData, rowIndex){
	var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.patName
	 +'</h3><h3 style="float:right;background-color:transparent;"><span>'+ rowData.sex +'/'+ rowData.age 
	 +'</span></h3><br>'+'<h3 style="float:left;background-color:transparent;"><span>'+ rowData.checkDate
	 +'</span></h3>';
	
	htmlstr = htmlstr + '<br> <h4 style="float:left;background-color:transparent;">ID:'+ rowData.regNo +'</h4>';
	var classstyle="color: #18bc9c";
	if(rowData.vipLevel!=""){
		if(rowData.vipLevel==3) {classstyle="color: #f9bf3b"};
		if(rowData.vipLevel==1) {classstyle="color: #3c78d8"};
		if(rowData.vipLevel==2) {classstyle="color: #f22613"};
		htmlstr = htmlstr +'<h4 style="float:right;background-color:transparent;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+rowData.vipDesc+'</span></h4>';
	}
	htmlstr = htmlstr +'</div>';
	return htmlstr;
}

function init(){
	/** ������尴ť��ʽ */
	//$(".icon-task-finish").html("<span class='pe-panel-tool'>�����</span>");
	$(".tabs-tool").css("width","70px");
	$(".tabs-tool").find("table,a").css("width","100%");

	//$(".panel-tool").css("margin-top","-10px");
	initTask();
}

$(init);
