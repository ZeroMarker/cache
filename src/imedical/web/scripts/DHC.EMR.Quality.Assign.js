//初始化公共变量
var startDate=$("#inputCreateDateStart")
var endDate=$("#inputCreateDateEnd")
var EditingRowIndex=[]  //正在编辑的行
var locUserList=[]  //科室质控员数据
var CurrentAssignDateInfo={startDate:"",endDate:""}	
var doAssignDates="" //分发日期段
var selectAllFlag="N" //是否全选表格
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

///设置抽查界面的显示数据列
var tableColumns={
	baseColumns:[[   //终末病历显示列
				{field:'CK',checkbox:true},
				{field:'EpisodeID',hidden:true},
				{field:'LocName',title:'科室',width:100,align:'left',cellattr: addCellAttr},
				{field:'ResidentDays',title:'住院天数',width:100,align:'left'},
				{field:'LocNums',title:'患者总数',width:100,align:'left',cellattr: addCellAttr},
				{field:'nums',title:'抽取数量',width:100,align:'left',cellattr: addCellAttr},
				{field:'PAPMIName',title:'病人姓名',width:100,align:'left',cellattr: addCellAttr},
				{field:'RegNo',title:'登记号',width:100,align:'left',cellattr: addCellAttr},
				{field:'MedicareNumber',title:'病案号',width:100,align:'left',cellattr: addCellAttr},
				{field:'DischDate',title:'出院日期',width:100,align:'left',cellattr: addCellAttr},
				{field:'Age',title:'年龄',width:100,align:'left'},
				{field:'PAPMISex',title:'性别',width:100,align:'left'},
				{field:'MainDiagnos',title:'诊断',width:100,align:'left'},
				{field:'SpecialInfo',title:'重点类型',width:100,align:'left'},
			]],
	getIAColumns:function(){  //环节病历显示列
		var columns={}
		$.extend(true,columns,this)
		columns.baseColumns[0].splice(8,1)	  //删除出院日期
		return columns.baseColumns
	},
				
	getOColumns:function(){  //门诊病历显示列
		var columns={}
		$.extend(true,columns,this)
		columns.baseColumns[0].splice(8,1)	  //删除出院日期
		columns.baseColumns[0].splice(2,1)	  //删除住院天数
		return columns.baseColumns
		
	}
	
}


///设置历史数据界面的显示数据列

var HistoryColumns={
	LastAssignDate:null,
	baseColumns:[
		[
				{field:'CK',checkbox:true},
			    {field:'RegNo',title:'登记号',width:100,align:'left'},
				{field:'PAPMIName',title:'姓名',width:100,align:'left'},
				{field:'PAPMISex',title:'性别',width:100,align:'left'},
				{field:'MainDiagnos',title:'诊断',width:100,align:'left'},
				{field:'DischDate',title:'出院日期',width:100,align:'left'},
				{field:'ResidentDays',title:'住院天数',width:100,align:'left'},
				{field:'DateGap',title:'分配日期段',width:100,align:'left',
					formatter: function(){
						return HistoryColumns.LastAssignDate
					}
				},
				{field:'MedName',title:'质控医生',width:100,align:'left',cellattr: addCellAttr},
				{field:'changeAssignStatus',title:'操作',width:100,align:'left',cellattr: addCellAttr,
					formatter:function(value,rowData,rowIndex)
					{
						if(rowData.crossCheckFlag==="Y")
						{
							return $g('已质控')
						}
						if(rowData.IsActive==="Y"){
							return '<div title='+$g('撤回')+' onClick="doAssign('+rowData.PAADMRowID+'\,\''+HistoryColumns.LastAssignDate+'\',\'N\')"><span class="icon-arrow-left-top">&nbsp;&nbsp;&nbsp;&nbsp;</span></div>'
							//return "<button style='background:red;color:white;border:none;' onclick='doAssign("+rowData.PAADMRowID+"\,\""+HistoryColumns.LastAssignDate+"\",\"N\")'>撤回</button>"	
						}
						//return '<div title='+'分发')+' onClick="doAssign('+rowData.PAADMRowID+'\,\''+HistoryColumns.LastAssignDate+'\',\'Y\')"><span class="icon-arrow-right-top">&nbsp;&nbsp;&nbsp;&nbsp;</span></div>'
						//return "<button style='background:green;color:white;border:none;' onclick='doAssign("+rowData.PAADMRowID+"\,\""+HistoryColumns.LastAssignDate+"\",\"Y\")'>分发</button>"
					}
				}
			]
	],
	getIAColumns:function(){
		var columns={}
		$.extend(true,columns,this)
		columns.baseColumns[0].splice(5,2)	  //删除住院天数,出院日期
		columns.baseColumns[0].push({field:'CheckedFlag',title:'科室质控员是否质控',width:100,align:'left',cellattr: addCellAttr})  //增加科室质控员是否质控
		return columns.baseColumns
		
	},
	getOColumns:function(){
		var columns={}
		$.extend(true,columns,this)
		columns.baseColumns[0].splice(5,2)	  //删除住院天数,出院日期
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
	extractSelectControl()  //控制抽取比例和抽取数量只能选择一个
});

function initDialog()
{
	$("#docInfoDialog").dialog(
	{
		closed:true,
		//fit:true,
		iconCls:'icon-w-save',resizable:true,modal:true,toolbar:[{
		
		text:'帮助',
		iconCls:'icon-help',
		handler:function(){$.messager.popover({msg:"勾选医师，然后点击确定，即可分配",type:'info',showType:'fade'})}
	}],buttons:[{
		text:'保存',
		handler:null
	},{
		text:'关闭',
		handler:function(){$HUI.dialog("#docInfoDialog").close();}
	}]
	}
	)
}




///指定分配保存执行的方法
function doPointAssign()
{
	var doctorInfo=$("#doctorList").datagrid("getSelections")
	if(doctorInfo.length===0)
	{
		$.messager.alert("提示","请选择要分配的医师","info")
		return
	}
	
	Assign("appointAssign",doctorInfo[0].UserId)
	
	
	
	$HUI.dialog("#docInfoDialog").close();
	
}

///转分配保存执行的方法
function doReAssign()
{ 
	var doctorInfo=$("#doctorList").datagrid("getSelections")
	if(doctorInfo.length===0)
	{
		$.messager.alert("提示","请选择要分配的医师","info")
		return
	}
	var admList=getSelectAdmList()
	
	changeMedDoc(admList,doctorInfo[0].UserId)
	
	
	$HUI.dialog("#docInfoDialog").close();
	
}

///初始化重点患者下拉多选框
$(function(){
	var cbox = $HUI.combobox("#specialAdm",{
		valueField:'id',
		textField:'text',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'OverAdm',text:$g("住院超过31天患者")},
			{id:'TerminallyIll',text:$g('病危患者')},
			{id:'DiseaseSeve',text:$g('病重患者')},
			{id:'SXHZ',text:$g('输血患者')},
			{id:'SSHZ',text:$g('手术患者')},
			{id:'HZHZ',text:$g('会诊患者')}
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
		{text:$g('环节病历'),value:'IA'},
		{text:$g('终末病历'),value:checkType,selected:true},
		//{text:'门诊病历',value:'O'}
		],
		onSelect:function(admType){
			InitCheckedHistory()
			refreshLocList(admType.value)
		}
	})
		
}

///根据病历类型刷新科室列表
function refreshLocList(admType){
	action="GetCTLocID"
	if(admType=="O"){
		action="GetMZCTLocID"
	}
	
	$('#ctLocID').combobox('options').url='../web.eprajax.usercopypastepower.cls?Action='+action+'&Type=E'+'&HospitalID='+HospitalID
	$('#ctLocID').combobox("reload")
}

///控制抽取比例和抽取数量只能填写其中一个
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


///初始化分配历史列表
function InitCheckedHistory()
{
	var admType=$("#AdmType").combobox("getValue")
	
	$("#historyList").empty()
	
	if(admType===""){
		$.messager.alert("提示:","请先选择病历范围!","info")
		return 
	}
	
	checkDateList=GetAllDateGap()
	var hisAssign=$(".hisAssign")
	var listInfo="",selectInfo=[] //这个selectInfo用于在讨论界面的菜单按钮数据
	if(checkDateList==""||checkDateList==undefined)
	{
		//listInfo=listInfo+"<div data-options=\"iconCls:'icon-w-plus'\">无历史数据</div>"
		listInfo=listInfo+"<div class='menu-item' onmouseout='this.style.background=\"white\"' onmouseover='this.style.background=\"#dbecf8\"' data-options=\"iconCls:'icon-w-find'\"><div class='menu-text'>无历史数据</div><div class='menu-icon icon-w-find'></div></div>"
		selectInfo.push({id:0,text:'无历史数据'})
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

/// 历史数据查询
function getHistoryData(LastAssignDate){
	
	$("#patientListTable").datagrid("clearSelections")
	$("#btnDoAssign").linkbutton("enable")  //开启分发按钮
	
	var findDate=LastAssignDate.split("---")[1]
	
	doAssignDates=LastAssignDate  //设置分发日期段
	
	
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
				///已分配过，则不能选中
				if(rowData.crossCheckFlag=="Y")
				{
					$("#operate").menubutton("disable")
					$('#patientListTable').datagrid("unselectRow",rowIndex)
					
					$.messager.popover({msg:"已质控病历无法进行分发、撤回、转分配等操作!",type:'info'})
					return 
				}
				
				$("#operate").menubutton("enable")	
			},
			onLoadSuccess:function(data){
				$("#btnDoAssign").linkbutton("enable")  //开启分发按钮
				$("#btnAssign").linkbutton("disable")
				$("#appointAssign").linkbutton("disable") 
			}
			
			
	  });	  
}
//病人列表初始化
function InitAuthorityDataList(eprPatient)
{
	$('#patientListTable').datagrid({ 
			pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            //pageSize: 5,
            //pageList: [5, 10, 15],
			fitColumns: true,
			idField:'EpisodeID',  //增加idField属性，避免翻页后前页选中内容失效
			method: 'post',
            loadMsg: '加载中......',
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
				///已分配过，则不能选中
				if(rowData.AssignedFlag==1)
				{
					$('#patientListTable').datagrid("unselectRow",rowIndex)
					
					$.messager.popover({msg:"已分配病历无法进行分配等操作!",type:'info'})
					return 
				}
				
				$("#operate").menubutton("enable")	
			},
			onSelectAll:function(rows){
				selectAllFlag="Y"  //模拟全选所有页
			},
			onUnselectAll:function(rows){
				selectAllFlag="N"  //模拟取消全选所有页
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
	       	     		$("#patientListTable").datagrid("selectAll")	  //模拟全选所有页
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

//科室初始化
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
		//展示用户数据	
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

///业务代码
//抽查按钮事件
function doSearch() {
	//alert(specialAdm);
    var queryParams ={}
    queryParams.StartDate = $("#inputCreateDateStart").datetimebox('getText');
    queryParams.EndDate = $("#inputCreateDateEnd").datetimebox('getText');
    queryParams.selectPro = $("#extractionRatio").numberbox('getValue')/100;
    queryParams.extractNums = $("#extractNums").numberbox('getValue');
    
    if(queryParams.selectPro!=""&&queryParams.extractNums!=""){
		$.messager.alert("提示","比例和数量只能二选一","info")
		return
	}
    
    queryParams.LocId = $("#ctLocID").combobox('getValues').toString();
    queryParams.AdmType = $("#AdmType").combobox('getValue');
    queryParams.specialAdm = $("#specialAdm").combobox('getValue');
    
    ///检查查询条件
    var rightParams=checkParams({std:queryParams.StartDate,etd:queryParams.EndDate,selectPro:queryParams.selectPro,extractNums:queryParams.extractNums})
    if(!rightParams){
		$.messager.alert("提示","请输入必要查询参数,如开始、结束时间，抽查比例或抽查份数")
		return 
	}
	
     //环节病历
     if(queryParams.AdmType==="IA"){
	    queryParams.AdmType="I"
	 	queryParams.AdmStatus = "A";
	 	columns=tableColumns.getIAColumns()	
	 }
	 //终末病历
	 if(queryParams.AdmType===checkType){
	    queryParams.AdmType="I"
	 	queryParams.AdmStatus = "D";
	 	columns=tableColumns.baseColumns	
	 }
	 //门诊病历
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
			queryParams:queryParams,  //重新设置datagrid查询参数
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

	 $("#patientListTable").datagrid("clearSelections")  //清除选中行
	 
	 //queryParamsReload(queryParams)  //不再通过reload方法加载表格，避免产生多次加载

	
}

function queryParamsReload(queryParam)
{
	$('#patientListTable').datagrid('options').queryParams={};
	$('#patientListTable').datagrid('options').queryParams = queryParam;
	
   $('#patientListTable').datagrid('reload');
}

///创建一个选择分配医师的表格

function getTable(){

        $HUI.datagrid('#doctorList',{
			
			autoSizeColumn:false,
			//fit:true,
			fitColumns:true,
			url:"../EPRservice.Quality.Ajax.SSUserInfo.cls",
			columns:[[
				{field:'ck',checkbox:true},
				{field:'Desc',title:'科室',width:100},
				{field:'UserName',title:'姓名',width:100}
				
			]],
			toolbar:[],
			idField:checkType,
			headerCls:'panel-header-gray',
			
			rownumbers:true,
			singleSelect:true,
			
			title:'质控医师列表',
			
			iconCls:'icon-paper',
			
			showPageList:false, showRefresh:false,
			afterPageText:'页,共{pages}页', beforePageText:'第', displayMsg:'显示{from}到{to}条，共{total}条',
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
				{field:'LocDesc',title:'科室',width:100},
				{field:'UserName',title:'姓名',width:100}
				
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
			
			title:'质控医师列表',
			
			iconCls:'icon-paper',
			
			showPageList:false, showRefresh:false,
			afterPageText:'页,共{pages}页', beforePageText:'第', displayMsg:'显示{from}到{to}条，共{total}条',
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


///医师列表科室检索
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

///医师列表医师检索
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
///指定分配
function appointAssign(){
	
	 var AdmList= $('#patientListTable').datagrid("getData").originalRows
	 
	 if (AdmList.length===0)
	 {
		 $.messager.alert("提示","请先抽取病历！","info")
		 return
	 }
	 
	 ///取所有科室下的医师,后台
	 //var DoctorInfoList=getAllDoctor()
	 selectAdm=$('#patientListTable').datagrid("getSelections")	 
	 //如果全选，则获取所有页数据进行分配，否则选择选中项进行分配
	 if(selectAllFlag=="Y")
	 {
		 selectAdm= AdmList
		 
	 }
	 
	 if (selectAdm.length===0)
	 {
		 //$.messager.alert("提示","当前未勾选病历，是否确认全部分配","info")
		 //return
		 
		 $.messager.confirm("提示","当前未勾选病历，是否确认全部分配?",function(r){
				if(r)
				{
					
					 var locs=[]
					 for(var i=0;i<selectAdm.length;i++)
					 {
						locs.push(selectAdm[i].LocName)
					 }
					 $("#docInfoDialog").dialog({
						 	buttons:[{
							text:'保存',
							handler:doPointAssign
						},{
							text:'关闭',
							handler:function(){$HUI.dialog("#docInfoDialog").close();}
						}]
					 })
					 
					 $("#docInfoDialog").dialog("open")
					 //getMedDocInfo(locs.toString()) 
					 getMedDocInfo("")   //取消根据科室进行质控员过滤
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
			text:'保存',
			handler:doPointAssign
		},{
			text:'关闭',
			handler:function(){$HUI.dialog("#docInfoDialog").close();}
		}]
	 })
	 
	 $("#docInfoDialog").dialog("open")
	 //getMedDocInfo(locs.toString()) 
	 getMedDocInfo("")   //取消根据科室进行质控员过滤
	 
	 
}

/// 分配按钮
function Assign(method,userList){
	
	
	var DateGap=CurrentAssignDateInfo.startDate+"至"+CurrentAssignDateInfo.endDate
	
	if(CurrentAssignDateInfo=="")
	{
		$.messager.alert("提示:", "请先抽查患者病历!", "info");
		return
	}
	
	var admList=getSelectAdmList()
	
	
	//modify by wzl 2023年3月21日 在抽取环节过滤掉了已分配病历,分配时不再执行分配时间段检查
	//var passFlag="Y"
	if(method==="appointAssign"||admList!=""){
		CheckAdmIsAssigned(admList,function(res){
			if(res==1){
				$.messager.alert("提示:","选择的病历中存在已分配病历!","info")
				return
			}
			
			AssignRequest(method,userList,admList,DateGap)
		})  //时间检验
	}else{
		
		/*passFlag=CheckQueryDates(CurrentAssignDateInfo)  //时间检验
		
		if(passFlag[0]=="N")
		{
			$.messager.alert("提示:",passFlag.substring(1,passFlag.length),"info")
			
			return
		}*/
		AssignRequest(method,userList,admList,DateGap)
		
	}
	
	
	
	
	
}

function AssignRequest(method,userList,admList,DateGap){
	$.messager.defaults = { ok: "确定", cancel: "重抽" };
	$.messager.confirm("分配操作","您抽查了:"+DateGap+"的患者病历数据，是否分配？",function(r){
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
					$.messager.alert("分配提示：",res,"success")
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


///更改分配的质控医师，即转分配
function changeMedDoc(admList,doc)
{
	$.messager.confirm("转分配操作","确认转分配吗？",function(r){
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
						if(res.indexOf("更新成功")!=-1){
							$.messager.alert("提示：",res,"success")
							getHistoryData(doAssignDates)
						}else
						{
							$.messager.alert("提示：",res,"error")
						}
						
						//$("#btnDoAssign").linkbutton("disable")
					}	
				})	
			}
		})
}




///分发或者撤回操作，status=Y 分发，status=N 撤回   医生只能查到分发过后的操作
function doAssign(episodeId,date,status)
{
	var operate="分发"
	
	if(status==="N")
	{
		operate="撤回"
	}
	
	if(episodeId!="")
	{
		$.messager.confirm(operate+"操作","确认"+operate+"？",function(r){
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
						if(res.indexOf("操作成功")!=-1){
							$.messager.alert("提示：",res,"success")
							getHistoryData(date)
						}else
						{
							$.messager.alert("提示：",res,"error")
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
	
	
	var invalidFlag=selectAdmInfo.errFlag,errMessage=(status==="Y")?"已分发":"未分发",operateTip=""
	
	
	//未找到可以操作的病历，提示并退出
	if(admStr=="")
	{
		var errorTip=(status==="N")?"已分发":"未分发"
		$.messager.alert("提示",operate+"请至少勾选1份"+errorTip+"病历")
		return
	}
	
	//存在勾选了不同状态病历情况，设置提示文字
	if(invalidFlag)
	{
		operateTip="勾选的病历中存在"+errMessage+"病历,"  //确认操作提示的消息
	}
	//ajax
	//doAssignDates
	$.messager.confirm(operate+"操作",operateTip+"确认"+operate+"？",function(r){
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
					$.messager.alert("提示：",res,"success")
					getHistoryData(doAssignDates)
					//$("#btnDoAssign").linkbutton("disable")
				}	
			})	
		}
	})
	return
}

///转分配
//将已分配未质控的病历转分给其他质控医师
function reAssign()
{	
	
	 $("#docInfoDialog").dialog({
		 	buttons:[{
			text:'保存',
			handler:doReAssign
		},{
			text:'关闭',
			handler:function(){$HUI.dialog("#docInfoDialog").close();}
		}]
	})
	
	//打开质控医师搜索列表
	$("#docInfoDialog").dialog("open")
	getMedDocInfo()
	
	
	//
	
	//
}




/// 检验代码
///检验抽查时段

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
			messages=messages+"时段"+dates.startDate+"至"+dates.endDate+"已经分配过，请选择其他时段！"
			continue
		}
		
		
		if(dates.startDate>=startDate&&dates.startDate<=endDate)
		{
			messages=messages+"时段"+dates.startDate+"至"+endDate+"已经分配过，请选择其他时段！"
			continue
		}
		
		if(dates.endDate>=startDate&&dates.endDate<=endDate)
		{
			messages=messages+"时段"+startDate+"至"+dates.endDate+"已经分配过，请选择其他时段！"
			continue
		}
		
	}
	
	if(messages!="")
	{
		passFlag="N"+messages
	}
	
	return passFlag
}

///检查选择的病历是否分配过
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
///后台数据操作

///同步方法获取科室以及质控员信息
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
///同步方法获取分配时间
function GetAllDateGap(){
	var res=$cm({
		ClassName:"EPRservice.Quality.DataAccess.ExtractInfo",
		MethodName:"GetAllDateGap",
		AdmType:$("#AdmType").combobox('getValue'),
		dataType:'text'
	},false);
	return res
	
}

///分配数据导出excel
function exportExcel(){
	/*
	1.specialCol：表格里自定义显示的列并不在rows对象中,此处DateGap字段formatter中return的,所以需要手动设置
	2.filtterCol：某些列不必导出,例如复选框field=='ck',操作field=='changeAssignStatus',在此设置即可过滤
	3.fileName：文件名
	*/
	var specialCol={DateGap:doAssignDates}  
	var filtterCol=['changeAssignStatus','CK']
	var fileName=getUniqueFileName("分配数据",".xls")
	$('#patientListTable').datagrid('toExcel',{filename:fileName,specialCol:specialCol,filtterCol:filtterCol,rows:null})
}

///文件名,desc为数据描述,suffix 保存的后缀名
function getUniqueFileName(desc,suffix){

	var timeStamp=Date.parse(new Date())
	
	return desc+timeStamp+suffix
}


///获取选中行中的就诊号列表
function getSelectAdmList(state){
	
	var selectAdm= $('#patientListTable').datagrid("getSelections")
	
	if(selectAllFlag=="Y")
	 {
		 selectAdm= $('#patientListTable').datagrid("getData").originalRows  //改从后台抽取临时global取
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

