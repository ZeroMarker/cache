//��ʼ����������
var startDate=$("#inputCreateDateStart")
var endDate=$("#inputCreateDateEnd")
var EditingRowIndex=[]  //���ڱ༭����
var locUserList=[]  //�����ʿ�Ա����
var CurrentAssignDateInfo={startDate:"",endDate:""}	
var doAssignDates="" //�ַ����ڶ�
var selectAllFlag="N" //�Ƿ�ȫѡ���
var AssignedDate=""
var checkDateList=[]

var eprPatient= new Object();
eprPatient.startDate = "";
eprPatient.endDate = "";
eprPatient.extractionRatio = "";
eprPatient.ResidentDays=""
eprPatient.AdmStatus="";
eprPatient.AdmType="";
eprPatient.LocId="";

var checkType="CQC"

///���ó��������ʾ������
var tableColumns={
	baseColumns:[[   //��ĩ������ʾ��
				{field:'CK',checkbox:true},
				{field:'EpisodeID',hidden:true},
				{field:'LocName',title:'����',width:100,align:'left',cellattr: addCellAttr},
				{field:'ResidentDays',title:'סԺ����',width:100,align:'left'},
				{field:'LocNums',title:'��������',width:100,align:'left',cellattr: addCellAttr},
				{field:'nums',title:'��ȡ����',width:100,align:'left',cellattr: addCellAttr},
				{field:'PAPMIName',title:'��������',width:100,align:'left',cellattr: addCellAttr},
				{field:'RegNo',title:'�ǼǺ�',width:100,align:'left',cellattr: addCellAttr},
				{field:'MedicareNumber',title:'������',width:100,align:'left',cellattr: addCellAttr},
				{field:'DischDate',title:'��Ժ����',width:100,align:'left',cellattr: addCellAttr},
				{field:'Age',title:'����',width:100,align:'left'},
				{field:'PAPMISex',title:'�Ա�',width:100,align:'left'},
				{field:'MainDiagnos',title:'���',width:100,align:'left'},
				{field:'SpecialInfo',title:'�ص�����',width:100,align:'left'},
			]],
	getIAColumns:function(){  //���ڲ�����ʾ��
		var columns={}
		$.extend(true,columns,this)
		columns.baseColumns[0].splice(8,1)	  //ɾ����Ժ����
		return columns.baseColumns
	},
				
	getOColumns:function(){  //���ﲡ����ʾ��
		var columns={}
		$.extend(true,columns,this)
		columns.baseColumns[0].splice(8,1)	  //ɾ����Ժ����
		columns.baseColumns[0].splice(2,1)	  //ɾ��סԺ����
		return columns.baseColumns
		
	}
	
}


///������ʷ���ݽ������ʾ������

var HistoryColumns={
	LastAssignDate:null,
	baseColumns:[
		[
				{field:'CK',checkbox:true},
			    {field:'RegNo',title:'�ǼǺ�',width:100,align:'left'},
				{field:'PAPMIName',title:'����',width:100,align:'left'},
				{field:'PAPMISex',title:'�Ա�',width:100,align:'left'},
				{field:'MainDiagnos',title:'���',width:100,align:'left'},
				{field:'DischDate',title:'��Ժ����',width:100,align:'left'},
				{field:'ResidentDays',title:'סԺ����',width:100,align:'left'},
				{field:'DateGap',title:'�������ڶ�',width:100,align:'left',
					formatter: function(){
						return HistoryColumns.LastAssignDate
					}
				},
				{field:'MedName',title:'�ʿ�ҽ��',width:100,align:'left',cellattr: addCellAttr},
				{field:'changeAssignStatus',title:'����',width:100,align:'left',cellattr: addCellAttr,
					formatter:function(value,rowData,rowIndex)
					{
						if(rowData.crossCheckFlag==="Y")
						{
							return $g('���ʿ�')
						}
						if(rowData.IsActive==="Y"){
							return '<div title='+$g('����')+' onClick="doAssign('+rowData.PAADMRowID+'\,\''+HistoryColumns.LastAssignDate+'\',\'N\')"><span class="icon-arrow-left-top">&nbsp;&nbsp;&nbsp;&nbsp;</span></div>'
							//return "<button style='background:red;color:white;border:none;' onclick='doAssign("+rowData.PAADMRowID+"\,\""+HistoryColumns.LastAssignDate+"\",\"N\")'>����</button>"	
						}
						//return '<div title='+'�ַ�')+' onClick="doAssign('+rowData.PAADMRowID+'\,\''+HistoryColumns.LastAssignDate+'\',\'Y\')"><span class="icon-arrow-right-top">&nbsp;&nbsp;&nbsp;&nbsp;</span></div>'
						//return "<button style='background:green;color:white;border:none;' onclick='doAssign("+rowData.PAADMRowID+"\,\""+HistoryColumns.LastAssignDate+"\",\"Y\")'>�ַ�</button>"
					}
				}
			]
	],
	getIAColumns:function(){
		var columns={}
		$.extend(true,columns,this)
		columns.baseColumns[0].splice(5,2)	  //ɾ��סԺ����,��Ժ����
		columns.baseColumns[0].push({field:'CheckedFlag',title:'�����ʿ�Ա�Ƿ��ʿ�',width:100,align:'left',cellattr: addCellAttr})  //���ӿ����ʿ�Ա�Ƿ��ʿ�
		return columns.baseColumns
		
	},
	getOColumns:function(){
		var columns={}
		$.extend(true,columns,this)
		columns.baseColumns[0].splice(5,2)	  //ɾ��סԺ����,��Ժ����
		return columns.baseColumns
	}
}

			
$(function(){
	if (HISUIStyleCode=="lite"){
		$('#bgGray').css('background-color','#f5f5f5')	
	}
	initDialog()
	initAdmType()
	
	$("#checkHistory").menubutton({menu:'#historyList',iconCls:'icon-write-order'})
	InitCheckedHistory()
	
	endDate.datebox("setValue",moment().format('YYYY-MM-DD'))
	startDate.datebox("setValue",moment().subtract(1, 'months').format('YYYY-MM-DD'))
	initcombox()
	InitAuthorityDataList(eprPatient);
	extractSelectControl()  //���Ƴ�ȡ�����ͳ�ȡ����ֻ��ѡ��һ��
});

function initDialog()
{
	$("#docInfoDialog").dialog(
	{
		closed:true,
		//fit:true,
		iconCls:'icon-w-save',resizable:true,modal:true,toolbar:[{
		
		text:'����',
		iconCls:'icon-help',
		handler:function(){$.messager.popover({msg:"��ѡҽʦ��Ȼ����ȷ�������ɷ���",type:'info',showType:'fade'})}
	}],buttons:[{
		text:'����',
		handler:null
	},{
		text:'�ر�',
		handler:function(){$HUI.dialog("#docInfoDialog").close();}
	}]
	}
	)
}




///ָ�����䱣��ִ�еķ���
function doPointAssign()
{
	var doctorInfo=$("#doctorList").datagrid("getSelections")
	if(doctorInfo.length===0)
	{
		$.messager.alert("��ʾ","��ѡ��Ҫ�����ҽʦ","info")
		return
	}
	
	Assign("appointAssign",doctorInfo[0].UserId)
	
	
	
	$HUI.dialog("#docInfoDialog").close();
	
}

///ת���䱣��ִ�еķ���
function doReAssign()
{ 
	var doctorInfo=$("#doctorList").datagrid("getSelections")
	if(doctorInfo.length===0)
	{
		$.messager.alert("��ʾ","��ѡ��Ҫ�����ҽʦ","info")
		return
	}
	var admList=getSelectAdmList()
	
	changeMedDoc(admList,doctorInfo[0].UserId)
	
	
	$HUI.dialog("#docInfoDialog").close();
	
}

///��ʼ���ص㻼��������ѡ��
$(function(){
	var cbox = $HUI.combobox("#specialAdm",{
		valueField:'id',
		textField:'text',
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'OverAdm',text:$g("סԺ����31�컼��")},
			{id:'TerminallyIll',text:$g('��Σ����')},
			{id:'DiseaseSeve',text:$g('���ػ���')},
			{id:'SXHZ',text:$g('��Ѫ����')},
			{id:'SSHZ',text:$g('��������')},
			{id:'HZHZ',text:$g('���ﻼ��')}
		]
		
		
	})
});

var action="GetCTLocID"

function initAdmType(){
	$("#AdmType").combobox({
		textField:"text",
		valueField:"value",
		panelHeight:'auto',
		data:[
		{text:$g('���ڲ���'),value:'IA'},
		{text:$g('��ĩ����'),value:checkType,selected:true},
		//{text:'���ﲡ��',value:'O'}
		],
		onSelect:function(admType){
			InitCheckedHistory()
			refreshLocList(admType.value)
		}
	})
		
}

///���ݲ�������ˢ�¿����б�
function refreshLocList(admType){
	action="GetCTLocID"
	if(admType=="O"){
		action="GetMZCTLocID"
	}
	
	$('#ctLocID').combobox('options').url='../web.eprajax.usercopypastepower.cls?Action='+action+'&Type=E'+'&HospitalID='+HospitalID
	$('#ctLocID').combobox("reload")
}

///���Ƴ�ȡ�����ͳ�ȡ����ֻ����д����һ��
function extractSelectControl()
{
	$("#extractNums").on("focus",function(){
		$('#extractionRatio').numberspinner('setValue', "");
		//$("#extractionRatio").val("")
	})
	
	$("#extractionRatio").on("focus",function(){
		$('#extractNums').numberspinner('setValue', "");
		//$("#extractNums").val("")
	})

	$('#extractionRatio').numberspinner({
		onSpinUp:function(){
			$('#extractNums').numberspinner('setValue', "");
		},
		onSpinDown:function(){
			$('#extractionRatio').numberspinner('setValue', "");
		}
	})

	$('#extractNums').numberspinner({
		onSpinUp:function(){
			$('#extractionRatio').numberspinner('setValue', "");
		},
		onSpinDown:function(){
			$('#extractionRatio').numberspinner('setValue', "");
		}
	})
}


///��ʼ��������ʷ�б�
function InitCheckedHistory()
{
	var admType=$("#AdmType").combobox("getValue")
	
	$("#historyList").empty()
	
	if(admType===""){
		$.messager.alert("��ʾ:","����ѡ������Χ!","info")
		return 
	}
	
	checkDateList=GetAllDateGap()
	var hisAssign=$(".hisAssign")
	var listInfo="",selectInfo=[] //���selectInfo���������۽���Ĳ˵���ť����
	if(checkDateList==""||checkDateList==undefined)
	{
		//listInfo=listInfo+"<div data-options=\"iconCls:'icon-w-plus'\">����ʷ����</div>"
		listInfo=listInfo+"<div class='menu-item' onmouseout='this.style.background=\"white\"' onmouseover='this.style.background=\"#dbecf8\"' data-options=\"iconCls:'icon-w-find'\"><div class='menu-text'>����ʷ����</div><div class='menu-icon icon-w-find'></div></div>"
		selectInfo.push({id:0,text:'����ʷ����'})
	}else
	{
		if(checkDateList.indexOf("/")==-1)
		{
			//listInfo=listInfo+"<div onclick='getHistoryData(\""+checkDateList+"\")' data-options=\"iconCls:'icon-w-find'\">"+checkDateList+"</div>"
			listInfo=listInfo+"<div class='menu-item' onmouseout='this.style.background=\"white\"' onmouseover='this.style.background=\"#dbecf8\"' onclick='getHistoryData(\""+checkDateList+"\")' data-options=\"iconCls:'icon-w-find'\"><div class='menu-text'> "+checkDateList+"</div><div class='menu-icon icon-w-find'></div></div>"
			selectInfo.push({id:checkDateList,text:checkDateList,selected:true})
		}else
		{
			var dateArray=checkDateList.split("/")
		
			for(var i=0;i<dateArray.length;i++)
			{
				listInfo=listInfo+"<div class='menu-item' onmouseout='this.style.background=\"white\"' onmouseover='this.style.background=\"#dbecf8\"' onclick='getHistoryData(\""+dateArray[i]+"\")' data-options=\"iconCls:'icon-w-find'\"><div class='menu-text'> "+dateArray[i]+"</div><div class='menu-icon icon-w-find'></div></div>"
				//listInfo=listInfo+"<div onclick='getHistoryData(\""+dateArray[i]+"\")' data-options=\"iconCls:'icon-w-find'\">"+dateArray[i]+"</div>"
				
				if(i==0)
				{
					selectInfo.push({id:dateArray[i],text:dateArray[i],selected:true})
				}else
				{
					selectInfo.push({id:dateArray[i],text:dateArray[i]})
				}
			}	
		}
	}
	
	AssignedDate=selectInfo
	$("#historyList").append(listInfo)
	
	
}

/// ��ʷ���ݲ�ѯ
function getHistoryData(LastAssignDate){
	
	$("#patientListTable").datagrid("clearSelections")
	$("#btnDoAssign").linkbutton("enable")  //�����ַ���ť
	
	var findDate=LastAssignDate.split("---")[1]
	
	doAssignDates=LastAssignDate  //���÷ַ����ڶ�
	
	
	var admType=$("#AdmType").combobox("getValue")
	
	HistoryColumns.LastAssignDate=LastAssignDate
	
	var columns=""
	
	if(admType===checkType)
	{
		columns=HistoryColumns.baseColumns
	}
	
	if(admType==="IA")
	{
		columns=HistoryColumns.getIAColumns()
	}
	
	if(admType==="O")
	{
		columns=HistoryColumns.getOColumns()
	}
	
	$('#patientListTable').datagrid({ 
			url:'../EPRservice.Quality.Ajax.Assign.cls',  //*********
			columns:columns,
			singleSelect:false,
			queryParams:{LastAssignDate:findDate,method:"GetHistoryAssignInfo",AdmType:$("#AdmType").combobox('getValue')},
			onSelect:function(rowIndex, rowData){
				///�ѷ����������ѡ��
				if(rowData.crossCheckFlag=="Y")
				{
					$("#operate").menubutton("disable")
					$('#patientListTable').datagrid("unselectRow",rowIndex)
					
					$.messager.popover({msg:"���ʿز����޷����зַ������ء�ת����Ȳ���!",type:'info'})
					return 
				}
				
				$("#operate").menubutton("enable")	
			},
			onLoadSuccess:function(data){
				$("#btnDoAssign").linkbutton("enable")  //�����ַ���ť
				$("#btnAssign").linkbutton("disable")
				$("#appointAssign").linkbutton("disable") 
			}
			
			
	  });	  
}
//�����б��ʼ��
function InitAuthorityDataList(eprPatient)
{
	$('#patientListTable').datagrid({ 
			pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            //pageSize: 5,
            //pageList: [5, 10, 15],
			fitColumns: true,
			idField:'EpisodeID',  //����idField���ԣ����ⷭҳ��ǰҳѡ������ʧЧ
			method: 'post',
            loadMsg: '������......',
			autoRowHeight: true,
			url:'../EPRservice.Quality.Ajax.GetAdmList.cls',  //*********
			singleSelect:false,
			fit:true,
			columns:tableColumns.baseColumns,
			onDblClickRow: function(rowIndex, rowData) {
				var currentUrl=$('#patientListTable').datagrid("options").url
				if(currentUrl!="../EPRservice.Quality.Ajax.GetAdmList.cls") return 
				var episodeID = rowData.EpisodeID
				var patientName=rowData.PAPMIName
				var MedicareNo=rowData.MedicareNo
				var BedNo=rowData.BedNo
				var url = "dhc.emr.quality.discheckrule.csp?EpisodeID="+episodeID+ '&action=D'+'&patientName='+patientName+'&MedicareNo='+MedicareNo+'&BedNo='+BedNo;
				if('undefined' != typeof websys_getMWToken)
				{
					url += "&MWToken="+websys_getMWToken()
				}
				window.open (url,'newwindow','top=0,left=0,width='+window.screen.width+',height='+window.screen.height+',toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no,channelmode=yes ') 
			},
			onSelect:function(rowIndex, rowData){
				///�ѷ����������ѡ��
				if(rowData.AssignedFlag==1)
				{
					$('#patientListTable').datagrid("unselectRow",rowIndex)
					
					$.messager.popover({msg:"�ѷ��䲡���޷����з���Ȳ���!",type:'info'})
					return 
				}
				
				$("#operate").menubutton("enable")	
			},
			onSelectAll:function(rows){
				selectAllFlag="Y"  //ģ��ȫѡ����ҳ
			},
			onUnselectAll:function(rows){
				selectAllFlag="N"  //ģ��ȡ��ȫѡ����ҳ
			},
		    rowStyler:function(rowIndex, rowData){ 
      			if (rowData.AssignedFlag=="1"){ 
      				if (HISUIStyleCode=="lite"){
          				return 'background-color:#F0E3FF;'; 
      				}else{  
          				return 'background-color:#F2E8FF;'; 
      				}  
      			}
  			},
		    loadFilter:function(data)
		    {
			  if(typeof data.length == 'number' && typeof data.splice == 'function'){
				  data={total: data.length,rows: data}
			  }
   		  	  var dg=$(this);
   		  	  var opts=dg.datagrid('options');
              var pager=dg.datagrid('getPager');
              pager.pagination({
   	      	  onSelectPage:function(pageNum, pageSize){
	    	      	opts.pageNumber=pageNum;
       	 	  		opts.pageSize=pageSize;
       	     		pager.pagination('refresh',{pageNumber:pageNum,pageSize:pageSize});
       	     		dg.datagrid('loadData',data);
       	     		if(selectAllFlag=="Y"){
	       	     		$("#patientListTable").datagrid("selectAll")	  //ģ��ȫѡ����ҳ
	       	     	}
       	     		
       	     }
          });
   		  if(!data.originalRows){
	    		  data.originalRows = (data.rows);
             }
  		 	  var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
             var end = start + parseInt(opts.pageSize);
             data.rows = (data.originalRows.slice(start, end));
             return data;
         }
	  }); 
}
function addCellAttr(rowId, val, rawObject, cm, rdata) {
    if(rawObject.QualityFlag == "Y" ){
           return "style='color:red'";
    }
}

//���ҳ�ʼ��
function initcombox()
{
	
	$cm({
		ClassName:"web.eprajax.usercopypastepower",
		MethodName:"GetCTLocID",
		AType:"E",
		AFilter:"",
		AHospitalID:HospitalID,  
		dataType:'text'
	},function(res){
		//չʾ�û�����	
		res=JSON.parse(res)
		$('#ctLocID').combobox
		({
			valueField:"ID",  
		    textField:"Name",
		    panelHeight:"100",
			mode:'local',
			multiple:true,
			rowStyle:'checkbox',
			data:res,
			filter: function(q, row){
				var opts = $(this).combobox('options');
				return row[opts.textField].indexOf(q) == 0;
			}
	    });	
	});
}


function checkParams(options){
	return options.std&&options.etd&&(options.selectPro||options.extractNums)
}

///ҵ�����
//��鰴ť�¼�
function doSearch() {
	//alert(specialAdm);
    var queryParams ={}
    queryParams.StartDate = $("#inputCreateDateStart").datetimebox('getText');
    queryParams.EndDate = $("#inputCreateDateEnd").datetimebox('getText');
    queryParams.selectPro = $("#extractionRatio").numberbox('getValue')/100;
    queryParams.extractNums = $("#extractNums").numberbox('getValue');
    
    if(queryParams.selectPro!=""&&queryParams.extractNums!=""){
		$.messager.alert("��ʾ","����������ֻ�ܶ�ѡһ","info")
		return
	}
    
    queryParams.LocId = $("#ctLocID").combobox('getValues').toString();
    queryParams.AdmType = $("#AdmType").combobox('getValue');
    queryParams.specialAdm = $("#specialAdm").combobox('getValue');
    
    ///����ѯ����
    var rightParams=checkParams({std:queryParams.StartDate,etd:queryParams.EndDate,selectPro:queryParams.selectPro,extractNums:queryParams.extractNums})
    if(!rightParams){
		$.messager.alert("��ʾ","�������Ҫ��ѯ����,�翪ʼ������ʱ�䣬�������������")
		return 
	}
	
     //���ڲ���
     if(queryParams.AdmType==="IA"){
	    queryParams.AdmType="I"
	 	queryParams.AdmStatus = "A";
	 	columns=tableColumns.getIAColumns()	
	 }
	 //��ĩ����
	 if(queryParams.AdmType===checkType){
	    queryParams.AdmType="I"
	 	queryParams.AdmStatus = "D";
	 	columns=tableColumns.baseColumns	
	 }
	 //���ﲡ��
	 if(queryParams.AdmType==="O"){
	    queryParams.AdmType="O"
	 	queryParams.AdmStatus = "A";
	 	columns=tableColumns.getOColumns()
	 }
	
	CurrentAssignDateInfo.startDate=queryParams.StartDate
	 CurrentAssignDateInfo.endDate=queryParams.EndDate
    queryParams.HospitalID = HospitalID
	 $('#patientListTable').datagrid({
			columns:columns,
			queryParams:queryParams,  //��������datagrid��ѯ����
			url:'../EPRservice.Quality.Ajax.GetAdmList.cls',
			rowStyler:function(rowIndex, rowData){ 
      			if (rowData.AssignedFlag=="1"){   
          			if (HISUIStyleCode=="lite"){
          				return 'background-color:#F0E3FF;'; 
      				}else{  
          				return 'background-color:#F2E8FF;'; 
      				} 
      			}   
  			},
			onLoadSuccess:function(data){
				if (undefined == data.rows || null == data.rows || data.rows.length == 0) {
					
					$("#btnAssign").linkbutton("disable")
					
				}else
				{
					$("#btnAssign").linkbutton("enable")
					$("#appointAssign").linkbutton("enable") 
				}
			}
	})

	 $("#patientListTable").datagrid("clearSelections")  //���ѡ����
	 
	 //queryParamsReload(queryParams)  //����ͨ��reload�������ر�񣬱��������μ���

	
}

function queryParamsReload(queryParam)
{
	$('#patientListTable').datagrid('options').queryParams={};
	$('#patientListTable').datagrid('options').queryParams = queryParam;
	
   $('#patientListTable').datagrid('reload');
}

///����һ��ѡ�����ҽʦ�ı��

function getTable(){

        $HUI.datagrid('#doctorList',{
			
			autoSizeColumn:false,
			//fit:true,
			fitColumns:true,
			url:"../EPRservice.Quality.Ajax.SSUserInfo.cls",
			columns:[[
				{field:'ck',checkbox:true},
				{field:'Desc',title:'����',width:100},
				{field:'UserName',title:'����',width:100}
				
			]],
			toolbar:[],
			idField:checkType,
			headerCls:'panel-header-gray',
			
			rownumbers:true,
			singleSelect:true,
			
			title:'�ʿ�ҽʦ�б�',
			
			iconCls:'icon-paper',
			
			showPageList:false, showRefresh:false,
			afterPageText:'ҳ,��{pages}ҳ', beforePageText:'��', displayMsg:'��ʾ{from}��{to}������{total}��',
			pagination:true
			
		})
		
        
    }
///EPRservice.Quality.Ajax.MedDoctor
function getMedDocInfo(locInfo){

        $HUI.datagrid('#doctorList',{
			
			autoSizeColumn:false,
			//fit:true,
			fitColumns:true,
			url:"../EPRservice.Quality.Ajax.MedDoctor.cls",
			columns:[[
				{field:'ck',checkbox:true},
				{field:'LocDesc',title:'����',width:100},
				{field:'UserName',title:'����',width:100}
				
			]],
			toolbar:[],
			queryParams:{
				range:$("#AdmType").combobox('getValue'),
				locInfo:locInfo,
				filter:1
			},
			idField:checkType,
			headerCls:'panel-header-gray',
			
			rownumbers:true,
			singleSelect:true,
			
			title:'�ʿ�ҽʦ�б�',
			
			iconCls:'icon-paper',
			
			showPageList:false, showRefresh:false,
			afterPageText:'ҳ,��{pages}ҳ', beforePageText:'��', displayMsg:'��ʾ{from}��{to}������{total}��',
			pagination:true,
			loadFilter:function(data)
		    {
			  if(typeof data.length == 'number' && typeof data.splice == 'function'){
				  data={total: data.length,rows: data}
			  }
   		  	  var dg=$(this);
   		  	  var opts=dg.datagrid('options');
              var pager=dg.datagrid('getPager');
              pager.pagination({
   	      		onSelectPage:function(pageNum, pageSize){
	    	    	opts.pageNumber=pageNum;
       	 	  		opts.pageSize=pageSize;
       	     		pager.pagination('refresh',{pageNumber:pageNum,pageSize:pageSize});
       	     		dg.datagrid('loadData',data);
       	     	}
             });
   		  	 if(!data.originalRows){
	    		  data.originalRows = (data.rows);
             }
  		 	 var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
             var end = start + parseInt(opts.pageSize);
             data.rows = (data.originalRows.slice(start, end));
             return data;
         	}
			
		})
		
        
    }


///ҽʦ�б���Ҽ���
function filterLocDesc(value,name)
{
	var queryParams=
		{
			method:"GetDoctorByDFDeptId",
			
			filterLocDesc:value.toUpperCase(),
			filterUserName:"",
		}
	$("#doctorList").datagrid("options").queryParams=queryParams
	$("#doctorList").datagrid("reload")
	
	//getTable(value)
}

///ҽʦ�б�ҽʦ����
function filterUserName(value,name)
{
	var queryParams=
		{
			method:"GetDoctorByDFDeptId",
			
			filterLocDesc:"",
			filterUserName:value,
		}
	$("#doctorList").datagrid("options").queryParams=queryParams
	$("#doctorList").datagrid("reload")
}
///ָ������
function appointAssign(){
	
	 var AdmList= $('#patientListTable').datagrid("getData").originalRows
	 
	 if (AdmList.length===0)
	 {
		 $.messager.alert("��ʾ","���ȳ�ȡ������","info")
		 return
	 }
	 
	 ///ȡ���п����µ�ҽʦ,��̨
	 //var DoctorInfoList=getAllDoctor()
	 selectAdm=$('#patientListTable').datagrid("getSelections")	 
	 //���ȫѡ�����ȡ����ҳ���ݽ��з��䣬����ѡ��ѡ������з���
	 if(selectAllFlag=="Y")
	 {
		 selectAdm= AdmList
		 
	 }
	 
	 if (selectAdm.length===0)
	 {
		 //$.messager.alert("��ʾ","��ǰδ��ѡ�������Ƿ�ȷ��ȫ������","info")
		 //return
		 
		 $.messager.confirm("��ʾ","��ǰδ��ѡ�������Ƿ�ȷ��ȫ������?",function(r){
				if(r)
				{
					
					 var locs=[]
					 for(var i=0;i<selectAdm.length;i++)
					 {
						locs.push(selectAdm[i].LocName)
					 }
					 $("#docInfoDialog").dialog({
						 	buttons:[{
							text:'����',
							handler:doPointAssign
						},{
							text:'�ر�',
							handler:function(){$HUI.dialog("#docInfoDialog").close();}
						}]
					 })
					 
					 $("#docInfoDialog").dialog("open")
					 //getMedDocInfo(locs.toString()) 
					 getMedDocInfo("")   //ȡ�����ݿ��ҽ����ʿ�Ա����
				}
		})
		return
	 }
	 
	 
	 var locs=[]
	 for(var i=0;i<selectAdm.length;i++)
	 {
		locs.push(selectAdm[i].LocName)
	 }
	 $("#docInfoDialog").dialog({
		 	buttons:[{
			text:'����',
			handler:doPointAssign
		},{
			text:'�ر�',
			handler:function(){$HUI.dialog("#docInfoDialog").close();}
		}]
	 })
	 
	 $("#docInfoDialog").dialog("open")
	 //getMedDocInfo(locs.toString()) 
	 getMedDocInfo("")   //ȡ�����ݿ��ҽ����ʿ�Ա����
	 
	 
}

/// ���䰴ť
function Assign(method,userList){
	
	
	var DateGap=CurrentAssignDateInfo.startDate+"��"+CurrentAssignDateInfo.endDate
	
	if(CurrentAssignDateInfo=="")
	{
		$.messager.alert("��ʾ:", "���ȳ�黼�߲���!", "info");
		return
	}
	
	var admList=getSelectAdmList()
	
	
	//modify by wzl 2023��3��21�� �ڳ�ȡ���ڹ��˵����ѷ��䲡��,����ʱ����ִ�з���ʱ��μ��
	//var passFlag="Y"
	if(method==="appointAssign"||admList!=""){
		CheckAdmIsAssigned(admList,function(res){
			if(res==1){
				$.messager.alert("��ʾ:","ѡ��Ĳ����д����ѷ��䲡��!","info")
				return
			}
			
			AssignRequest(method,userList,admList,DateGap)
		})  //ʱ�����
	}else{
		
		/*passFlag=CheckQueryDates(CurrentAssignDateInfo)  //ʱ�����
		
		if(passFlag[0]=="N")
		{
			$.messager.alert("��ʾ:",passFlag.substring(1,passFlag.length),"info")
			
			return
		}*/
		AssignRequest(method,userList,admList,DateGap)
		
	}
	
	
	
	
	
}

function AssignRequest(method,userList,admList,DateGap){
	$.messager.defaults = { ok: "ȷ��", cancel: "�س�" };
	$.messager.confirm("�������","�������:"+DateGap+"�Ļ��߲������ݣ��Ƿ���䣿",function(r){
		if(r)
		{
			$.ajax({
				url:'../EPRservice.Quality.Ajax.Assign.cls',
				data:{
					AdmType:$("#AdmType").combobox('getValue'),
					//method:"CrossAssign"
					method:method,
					userList:userList,
					admList:admList
				},
				dataType:'text',
				success:function(res){
					$.messager.alert("������ʾ��",res,"success")
					InitCheckedHistory()
					$("#btnAssign").linkbutton("disable")
					DateGap=""
				}	
			})	
		}else
		{
			DateArray=[]
			return
		}
	})
}


///���ķ�����ʿ�ҽʦ����ת����
function changeMedDoc(admList,doc)
{
	$.messager.confirm("ת�������","ȷ��ת������",function(r){
			if(r)
			{
				$.ajax({
					url:'../EPRservice.Quality.Ajax.Assign.cls',
					data:{
						admList:admList,
						userList:doc,
						method:"reAssign"
					},
					dataType:'text',
					success:function(res){
						if(res.indexOf("���³ɹ�")!=-1){
							$.messager.alert("��ʾ��",res,"success")
							getHistoryData(doAssignDates)
						}else
						{
							$.messager.alert("��ʾ��",res,"error")
						}
						
						//$("#btnDoAssign").linkbutton("disable")
					}	
				})	
			}
		})
}




///�ַ����߳��ز�����status=Y �ַ���status=N ����   ҽ��ֻ�ܲ鵽�ַ�����Ĳ���
function doAssign(episodeId,date,status)
{
	var operate="�ַ�"
	
	if(status==="N")
	{
		operate="����"
	}
	
	if(episodeId!="")
	{
		$.messager.confirm(operate+"����","ȷ��"+operate+"��",function(r){
			if(r)
			{
				$.ajax({
					url:'../EPRservice.Quality.Ajax.Assign.cls',
					data:{
						admStr:episodeId,
						status:status,
						method:"DoAssignInfo"
					},
					dataType:'text',
					success:function(res){
						if(res.indexOf("�����ɹ�")!=-1){
							$.messager.alert("��ʾ��",res,"success")
							getHistoryData(date)
						}else
						{
							$.messager.alert("��ʾ��",res,"error")
						}
						
						//$("#btnDoAssign").linkbutton("disable")
					}	
				})	
			}
		})
		return
	}
	var selectAdmInfo=getSelectAdmList("Y")
	
	var admStr=selectAdmInfo.info.replace(",","/")
	
	
	var invalidFlag=selectAdmInfo.errFlag,errMessage=(status==="Y")?"�ѷַ�":"δ�ַ�",operateTip=""
	
	
	//δ�ҵ����Բ����Ĳ�������ʾ���˳�
	if(admStr=="")
	{
		var errorTip=(status==="N")?"�ѷַ�":"δ�ַ�"
		$.messager.alert("��ʾ",operate+"�����ٹ�ѡ1��"+errorTip+"����")
		return
	}
	
	//���ڹ�ѡ�˲�ͬ״̬���������������ʾ����
	if(invalidFlag)
	{
		operateTip="��ѡ�Ĳ����д���"+errMessage+"����,"  //ȷ�ϲ�����ʾ����Ϣ
	}
	//ajax
	//doAssignDates
	$.messager.confirm(operate+"����",operateTip+"ȷ��"+operate+"��",function(r){
		if(r)
		{
			$.ajax({
				url:'../EPRservice.Quality.Ajax.Assign.cls',
				data:{
					admStr:admStr,
					status:status,
					method:"DoAssignInfo"
				},
				dataType:'text',
				success:function(res){
					$.messager.alert("��ʾ��",res,"success")
					getHistoryData(doAssignDates)
					//$("#btnDoAssign").linkbutton("disable")
				}	
			})	
		}
	})
	return
}

///ת����
//���ѷ���δ�ʿصĲ���ת�ָ������ʿ�ҽʦ
function reAssign()
{	
	
	 $("#docInfoDialog").dialog({
		 	buttons:[{
			text:'����',
			handler:doReAssign
		},{
			text:'�ر�',
			handler:function(){$HUI.dialog("#docInfoDialog").close();}
		}]
	})
	
	//���ʿ�ҽʦ�����б�
	$("#docInfoDialog").dialog("open")
	getMedDocInfo()
	
	
	//
	
	//
}




/// �������
///������ʱ��

function CheckQueryDates(dates)
{
	var passFlag="Y"
	
	if(dates==""||dates.startDate==""||dates.endDate=="")
	{
		return passFlag
	}
	
	//var checkedDates=GetCheckedDate()
	var dateArray=checkDateList.split("/")
	
	var messages=""
	
	if(dateArray.length==0||checkDateList=="")
	{
		return passFlag
	}
	
	for(var i=0;i<dateArray.length;i++)
	{
		var startDate=dateArray[i].split("---")[0]
		var endDate=dateArray[i].split("---")[1]
		
		if(dates.startDate>=startDate&&dates.endDate<=endDate)
		{
			messages=messages+"ʱ��"+dates.startDate+"��"+dates.endDate+"�Ѿ����������ѡ������ʱ�Σ�"
			continue
		}
		
		
		if(dates.startDate>=startDate&&dates.startDate<=endDate)
		{
			messages=messages+"ʱ��"+dates.startDate+"��"+endDate+"�Ѿ����������ѡ������ʱ�Σ�"
			continue
		}
		
		if(dates.endDate>=startDate&&dates.endDate<=endDate)
		{
			messages=messages+"ʱ��"+startDate+"��"+dates.endDate+"�Ѿ����������ѡ������ʱ�Σ�"
			continue
		}
		
	}
	
	if(messages!="")
	{
		passFlag="N"+messages
	}
	
	return passFlag
}

///���ѡ��Ĳ����Ƿ�����
function CheckAdmIsAssigned(admList,cb){
	$cm({
		ClassName:"EPRservice.Quality.DataAccess.AssignInfo",
		MethodName:"CheckAdmIsAssigned",
		dataType:'text',
		admList:admList,
	},function(res){
		cb(res)
	})
}
///��̨���ݲ���

///ͬ��������ȡ�����Լ��ʿ�Ա��Ϣ
function GetLocUserInfo(){
	var res=$cm({
		ClassName:"EPRservice.Quality.Ajax.MedDoctor",
		MethodName:"GetEffectiveUserByRange",
		dataType:'text',
		date:"",
		Range:$("#AdmType").combobox('getValue')
	},false);
	
	return res
	
}
///GetAllDateGap
///ͬ��������ȡ����ʱ��
function GetAllDateGap(){
	var res=$cm({
		ClassName:"EPRservice.Quality.DataAccess.ExtractInfo",
		MethodName:"GetAllDateGap",
		AdmType:$("#AdmType").combobox('getValue'),
		dataType:'text'
	},false);
	return res
	
}

///�������ݵ���excel
function exportExcel(){
	/*
	1.specialCol��������Զ�����ʾ���в�����rows������,�˴�DateGap�ֶ�formatter��return��,������Ҫ�ֶ�����
	2.filtterCol��ĳЩ�в��ص���,���縴ѡ��field=='ck',����field=='changeAssignStatus',�ڴ����ü��ɹ���
	3.fileName���ļ���
	*/
	var specialCol={DateGap:doAssignDates}  
	var filtterCol=['changeAssignStatus','CK']
	var fileName=getUniqueFileName("��������",".xls")
	$('#patientListTable').datagrid('toExcel',{filename:fileName,specialCol:specialCol,filtterCol:filtterCol,rows:null})
}

///�ļ���,descΪ��������,suffix ����ĺ�׺��
function getUniqueFileName(desc,suffix){

	var timeStamp=Date.parse(new Date())
	
	return desc+timeStamp+suffix
}


///��ȡѡ�����еľ�����б�
function getSelectAdmList(state){
	
	var selectAdm= $('#patientListTable').datagrid("getSelections")
	
	if(selectAllFlag=="Y")
	 {
		 selectAdm= $('#patientListTable').datagrid("getData").originalRows  //�ĴӺ�̨��ȡ��ʱglobalȡ
		 //selectAdm=[]
	 }
	
	
	var admList=[],errFlag=0
	for(var i=0;i<selectAdm.length;i++)
	{
		var adm=selectAdm[i].EpisodeID!=undefined?selectAdm[i].EpisodeID:selectAdm[i].PAADMRowID
		if(state)
		{
			
			if(selectAdm[i].IsActive!=state)
			{
				errFlag=1
				continue
			}
		}
		admList.push(adm)
	}
	
	if(!state){
		return admList.toString()
	}else
	{
		return {info:admList.toString(),errFlag:errFlag}
	}
}

