/**
* @Creator   : wk
* @CreatDate : 2018-05-02
* @Desc      : 指标配置主界面js文件
*/

	var kpiBodyHeight = getViewportOffset().y;   // 获取屏幕高度
	var kpiBodyWidth = getViewportOffset().x;   // 获取屏幕宽度
	var filePathLog = "";
	var FILE_PATH_GLOBAL = "";
	var KPI_INPUT_FLAG = "";

/*--定义数组用来记录选中指标--*/
	var selectedKPIIdList,selectedKPICodeList;
	selectedKPIIdList = new Array();
	selectedKPICodeList = new Array();

	
	
/*--用于刷新指标表格--*/
function freshKPITableFun(kpiInforList){
	var kpiCode,kpiName,kpiMea,kpiExeCode,dataNode,kpiCreator,kpiDimCodes,kpiDesc,kpiType,kpiSection,kpiValueType,kpiRemark
	kpiInforArr = kpiInforList.split("@");
	kpiCode = kpiInforArr[0];
	kpiName = kpiInforArr[1];
	kpiMea = kpiInforArr[2];
	kpiExeCode = kpiInforArr[3];
	dataNode = kpiInforArr[4];
	kpiCreator = kpiInforArr[5];
	kpiDesc = kpiInforArr[6];
	kpiDimCodes = kpiInforArr[7];
	kpiType = kpiInforArr[8];
	kpiSection = kpiInforArr[9];
	kpiValueType = kpiInforArr[10];
	kpiRemark = kpiInforArr[11];
	kpiConfigObj.load({ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPIListQuery",kpiCode:kpiCode, kpiName:kpiName, kpiDesc:kpiDesc, kpiExcode:kpiExeCode, createUser:kpiCreator, dataNode:dataNode, getValueType:kpiValueType, dimType:kpiDimCodes, category:kpiType, section:kpiSection,nodeMark:kpiRemark,filterMea:kpiMea});  //重新加载指标信息
}
function showKPInfor(obj) {
	var ID=obj.id;
	if (!selectedKPIIdList[0]) {
		myMsg("请先选择需要操作的指标");
		return;
	}
	if ((ID == "viewKPIDim")||(ID == "viewKPITask")||(ID == "viewKPIMea")||(ID == "viewKPILog")){
		var len = selectedKPIIdList.length;
		if (len > 1){
			myMsg("只能选择一条指标查看");
			return;
		}
	}
	if (ID == "viewKpiData") {
		title = "预览指标数据";
		url = "dhcwl/v1/kpi/kpi/configviewkpidata.csp&ids="+selectedKPIIdList+"&kpiCodes="+selectedKPICodeList;
	}else if(ID == "creatKpiData") {
		title = "生成指标数据";
		url = "dhcwl/v1/kpi/kpi/configkpicreatdata.csp&id="+selectedKPIIdList;
	}else if(ID == "viewKPIDim") {
		title = "指标维度" + "--" + selectedKPICodeList[0];
		url = "dhcwl/v1/kpi/kpi/configkpidim.csp&id="+selectedKPIIdList[0]+"&kpiCode="+selectedKPICodeList[0];
	}else if(ID == "viewKPITask") {
		title = "指标任务" + "--" + selectedKPICodeList[0];
		url = "dhcwl/v1/kpi/kpi/configkpitask.csp&id="+selectedKPIIdList[0]+"&kpiCode="+selectedKPICodeList[0];
	}else if (ID == "viewKPIMea") {
		title = "指标度量" + "--" + selectedKPICodeList[0];
		url = "dhcwl/v1/kpi/kpi/configkpimea.csp&id="+selectedKPIIdList[0]+"&kpiCode="+selectedKPICodeList[0];
	}else if (ID == "viewKPILog") {
		title = "指标日志" + "--" + selectedKPICodeList[0];
		url = "dhcwl/v1/kpi/kpi/configkpilog.csp&id="+selectedKPIIdList[0]+"&kpiCode="+selectedKPICodeList[0];
	}
	if ($('#kpiConfigTabs').tabs('exists', title)){
		$('#kpiConfigTabs').tabs('select', title);
	} else {
		if (ID == "viewKpiData"){
			var content = '<iframe scrolling="auto" frameborder="0" marginheight="0px" marginwidth="0px" id = "viewKPIData" seamless="seamless" src="dhcwlredirect.csp?url='+url+'" style="width:100%;height:100%;"></iframe>';
		}else{
			var content = '<iframe scrolling="auto" frameborder="0" marginheight="0px" marginwidth="0px" seamless="seamless" src="dhcwlredirect.csp?url='+url+'" style="width:100%;height:100%;"></iframe>';
		}
		$('#kpiConfigTabs').tabs('add',{
			title:title,
			content:content,
			closable:true
		});
	}
}

$("#clearAllSelected").click(function(){
	$("#kpiconfigwinGrid").datagrid("unselectAll");
	selectedKPIIdList = [];
	selectedKPICodeList = [];
});

function kpiSearchFun(obj) {
	var input=document.getElementById("kpiCode");//通过id获取文本框对象
	alert(input.value);//通过文本框对象获取value值
}
//导出指标
function outPutKPI(obj) {
	var ID=obj.id;
	if (ID == "outPutKPIWithDim") {
		methodName = "getFileContentWithDim";
	}else if(ID == "outPutKPIExcDim"){
		methodName = "getFileContentExcDim";
	}
	var kpiIDStr = selectedKPIIdList.join(",");
	if (kpiIDStr == ""){
		myMsg("请先选择需要导出的指标");
		return;
	}
	$.m({
		ClassName: "web.DHCWL.V1.KPI.KPIFunction",
		MethodName: methodName,
		kpiIds:kpiIDStr
	},function(responseText){
		writeFileUtil(nowDateTimeUtil()+'outputKpis.kpi',trimLeftUtil(responseText));
		myMsg("导出成功");
	})
}

//导出指标(Excel)
function outPutKPIExcel(obj){
	var kpiIDStr = selectedKPIIdList.join(",");
	if (kpiIDStr == ""){
		myMsg("请先选择需要导出的指标");
		return;
	}
	var excelObj=new Excel();
	excelObj.setTitle("指标导出");
	excelObj.setHead(['ID','编码','指标名称','指标描述','执行代码','是否使用global','创建者','创建/更新日期','备注','维度','类型','区间','数据节点','取值方式','关联维度(只用于显示)']);
	excelObj.setCode(['MKPIId','MKPICode','MKPIName','MKPIDesc','MKPIEXCode','MKPIGlobalFlag','MKPIUser','MKPIUpdateDate','MKPIRemark','MKPIDim','MKPICate','MKPISectionFlag','MKPIDataNod','MKPIGetValueType','MKPIKpiDim'])
	excelObj.setServerUrl(kpiIDStr);
	excelObj.exportExcel();
	myMsg("导出成功");
}


/*--指标配置表格--*/
var kpiConfigObj = $HUI.datagrid("#kpiconfigwinGrid",{
	url:$URL,   //URL固定写法
	queryParams:{
		ClassName:"web.DHCWL.V1.KPI.KPIFunction",  //调用方法或query的路径
		QueryName:"GetKPIListQuery"  //调用query名
	},
	toolbar:[],
	pagination:true,  //分页可用
	//striped:true,  //表格斑马线状态
	pageSize:15,  //当前页每页条数
    pageList:[5,10,15,20,50,100],  //每页可以选中的显示条数
    onSelect:function(rowIndex,rowData){  //当选中一条记录时，将选中的记录的id和code记录到数组中
	    selectedKPIIdList.unshift(rowData.ID);
	    selectedKPICodeList.unshift(rowData.kpiCode);
	    var infor = ""
	    for (x in selectedKPIIdList) {
		    infor = infor + "@" + selectedKPIIdList[x];
	    }
    },  
    onUnselect:function(rowIndex,rowData){ //当取消选中一条记录时，将数组中的记录去掉
	    for (x in selectedKPIIdList) {
		    if (selectedKPIIdList[x] == rowData.ID) {
			    selectedKPIIdList.splice(x,1);
		    }
	    }
	    for (x in selectedKPICodeList) {
		    if (selectedKPICodeList[x] == rowData.kpiCode){
			    selectedKPICodeList.splice(x,1);
		    }
	    }
    },
    onSelectAll:function(rows) {  //当选中当前页所有的指标时，记录所有指标的ID和code
	    for (var i = 0;i < rows.length;i++) {
		    if ($.inArray(rows[i].ID,selectedKPIIdList) == -1){
		    	selectedKPIIdList.unshift(rows[i].ID);
	    		selectedKPICodeList.unshift(rows[i].kpiCode);
		    }
	    }
    },
    onUnselectAll:function(rows) { //当取消选中当前所有指标的时候，取消数组中的ID和code
	    for (var i = 0;i < rows.length;i++) {
		    for (x in selectedKPIIdList) {
			    if (rows[i].ID == selectedKPIIdList[x]) {
				    selectedKPIIdList.splice(x,1);
			    }
		    }
		    
		    for (x in selectedKPICodeList) {
		    	if (selectedKPICodeList[x] == rows[i].kpiCode){
			    	selectedKPICodeList.splice(x,1);
		    	}
	   	 	}
	    }
    },
    onLoadSuccess:function(data){
	    var rows = data.rows;
	    for (var i = 0;i < rows.length;i++){
		    if ($.inArray(rows[i].ID,selectedKPIIdList) > -1 ){
			    $("#kpiconfigwinGrid").datagrid("selectRow",i);
		    }
	    }
    }
    
})

$('#searchKPIInfor').searchbox({
	searcher:function(value,name){
		kpiConfigObj.load({ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPIListQuery",filterValue:value});  //重新加载指标信息
	}
});


/*--响应用户选择文件事件--*/
function getFilePath(newVal,oldVal){
	if (newVal=="") return;
	if (newVal==oldVal) return;
	filePathLog=getFieldValue("importRegion","kpiInputFilebox");
}

/*--获取filebox文件路径--*/
function getFieldValue(formID,fieldName) {
	return $("div#"+formID+" [name='"+fieldName+"']").val();
};

/*$("#kpiInputFilebox").filebox({
	onChange:function(newVal,oldVal){
		if (newVal=="") return;
		if (newVal==oldVal) return;
		filePathLog=getFieldValue("importRegion","kpiInputFilebox");
	}
});*/

/*--点击导入按钮--*/
$("#kpiInputIcon").click(function(e){
	filePathLog = "";
	$HUI.datagrid("#kpiInputListGrid",{
		fitColumns:true,
		toolbar:[{
			text:'读入文件',
			iconCls:'icon-upload-cloud',
			handler:function(e){
				if ((!filePathLog)||(filePathLog == "")){
					myMsg("请先选择需要读入的文件");
					return;
				}
				$('#kpiInputListGrid').datagrid('loadData',{total:0,rows:[]});
				var xmlObj = new XML();
				var readStr="",theStep=1,sc;
				var inputCont=[];
				do{
					readStr=xmlObj.stepTraverXML(filePathLog,256);  
					inputCont.push(readStr);
					theStep++;
				}while(readStr&&readStr!="");
				KPI_INPUT_FLAG = "read";
				
				theStep = 3;
				
				loadInforShow("start","","正在读取数据");

				$m({
					_headers:{
						X_Accept_Tag:1
					},
					ClassName:'web.DHCWL.V1.MKPIIO.DefaultInService',
					MethodName:'UPFILE',
					theStep:theStep,
					inputCont:inputCont
				},function(txtData){
					//alert(txtData);
					//var str1 = '{ "name": "cxh", "sex": "man" }';	
					try{
						$('#kpiInputListGrid').datagrid('loadData',{total:0,rows:[]});
						var jsonObj = JSON.parse(txtData);
						var fileName = jsonObj.tips;
						//var filePath = tempFile.replace(/-/g,"\\");
						FILE_PATH_GLOBAL = fileName;
						//console.log(filePath);
						//return;
						var rootLen = jsonObj.root.length;
						for (var i = 0;i < rootLen;i++){
							$('#kpiInputListGrid').datagrid('insertRow',{
								row: {
									code: jsonObj.root[i].kpiCode,
									desc: jsonObj.root[i].kpiDesc
								}
							});
						}
						loadInforShow("end");
						return;
					}catch(e){
						myMsg("加载文件失败");
						loadInforShow("end");
					}
					
				})
			}
		},{
			text:'导入前检查',
			iconCls:'icon-check-reg',
			handler:function(e){
				if (KPI_INPUT_FLAG == ""){
					myMsg("请先读取指标文件后操作");
					return;
				}else if(KPI_INPUT_FLAG == "check"){
					myMsg("请勿重复操作");
					return;
				}else if (KPI_INPUT_FLAG == "input"){
					myMsg("请重新读取指标文件");
					return;
				}
				KPI_INPUT_FLAG = "check";
				
				loadInforShow("start","","正在进行指标检查");
				$m({
					ClassName:'web.DHCWL.V1.MKPIIO.DefaultInService',
					MethodName:'inputKpiFile',
					fileName:FILE_PATH_GLOBAL,
					checkedInput:1
				},function(txtData){
					$('#kpiInputListGrid').datagrid('loadData',{total:0,rows:[]})
					var jsonObj = JSON.parse(txtData);
					var jsonLen = jsonObj.length;
					for (var i = 0;i < jsonLen;i++){
						$('#kpiInputListGrid').datagrid('insertRow',{
							row: {
								code: jsonObj[i].kpiCode,
								desc: jsonObj[i].kpiDesc,
								flag: jsonObj[i].flag
							}
						});
					}
					var rows = $('#kpiInputListGrid').datagrid('getRows');
					var len = rows.length,flag="";
					for (var i = 0;i < len;i++){
						flag = rows[i].flag;
						if (flag != 1){
							$('#kpiInputListGrid').datagrid('checkRow',i);
						}
					}
					loadInforShow("end");
					//console.log(jsonObj);
				})
			}
		},{
			text:'导入指标',
			iconCls:'icon-ok',
			handler:function(e){
				if (KPI_INPUT_FLAG != "check"){
					myMsg("请先点击导入前检查后再操作");
					return;
				}
				var rows = $('#kpiInputListGrid').datagrid('getChecked'),kpiCodes = "",kpiCode = "";
				var len = rows.length,flag="";
				for (var i = 0;i < len;i++){
					kpiCode = rows[i].code;
					if (kpiCodes == ""){
						kpiCodes = kpiCode;
					}else{
						kpiCodes = kpiCodes + "," +kpiCode
					}
				}
				if (kpiCodes == ""){
					myMsg("请先选择需要导入的指标后操作");
					return;
				}
				KPI_INPUT_FLAG = "input";
				var realInputKpiList = kpiCodes;
				var fileName = FILE_PATH_GLOBAL;
				loadInforShow("start","","正在进行指标导入");
				$m({
					ClassName:'web.DHCWL.V1.MKPIIO.DefaultInService',
					MethodName:'inputKpiFile',
					fileName:fileName,
					realInputKpiList:realInputKpiList
				},function(e){
					myMsg(e);
					loadInforShow("end");
					$HUI.dialog("#kpiInputDialog").close();
				})
				//alert(kpiCodes);
			}
		}]
	})
	clearInputDialog();
	$("#kpiInputDialog").show();
	$HUI.dialog("#kpiInputDialog",{
		height:500,
		width:600,
		resizable:true,
		modal:true,
		iconCls:'icon-w-import',
		onClose:function(e){
			KPI_INPUT_FLAG = "";
		}
	})
})

/*--清空导入dialog内容--*/
function clearInputDialog(){
	$('#kpiInputFilebox').filebox('clear');
	$('#kpiInputListGrid').datagrid('loadData',{total:0,rows:[]});
}

/*--用于修改已经维护区间单元格的背景色--*/
 function cellStyler(value,row,index){
	 var flag = row.flag;
	 if (flag == 1) {
		  return 'color:#ee4f38;';
		 
	 } 
 }

/*--帮助文档--*/
$("#helpDoc").click(function(e){
	$("#helpDialog").show();
	$HUI.dialog("#helpDialog",{
		height:(kpiBodyHeight-20),
		width:800,
		//top:5,
		resizable:true,
		modal:true,
		iconCls:'icon-w-paper'
	})
})

$("#showImage").click(function(e){
	$('#searchKPIInfor').searchbox('setValue', '');
})

var init = function(){
	
	function initPopover(){
		var settings = {
			trigger:'click',
			title:'',
			content:'<p>This is webui popover demo.</p><p>just enjoy it and have fun !</p>',
			width:350,						
			multi:true,						
			closeable:false,
			style:'',
			padding:true
		};
		var tableContent = $('#kpiInforSearch').html(),
		tableSettings = {
			content:tableContent,
			width:1050
		};
		var iframeSettings = {
			width : 1002,
			height:163,
			placement:'bottom-left',
			closeable:false,
			padding:false,
			type:'iframe',
			url:'dhcwlredirect.csp?url=dhcwl/v1/kpi/kpi/configkpisearch.csp'
		}

		$('#showImage').webuiPopover('destroy').webuiPopover($.extend({},settings,iframeSettings));
		
		var kpiRuleSettings = {
			width : 800,
			height:110,
			placement:'bottom-right',
			closeable:false,
			padding:false,
			type:'iframe',
			url:'dhcwlredirect.csp?url=dhcwl/v1/kpi/kpi/configsimplekpisearch.csp'
		}
		$('#kpiRuleShowImage').webuiPopover('destroy').webuiPopover($.extend({},settings,kpiRuleSettings));
		
		
		var tableContent = $('#kpiInOutputDetail').html(),
		tableSettings = {
			width:260,
			trigger:'hover',
			content:tableContent
		};

		$('#kpiOutputIcon').webuiPopover('destroy').webuiPopover($.extend({},settings,tableSettings));
		
		var tableContent = $('#kpiInforDetail').html(),
	
		
		tableSettings = {
			trigger:'hover',
			content:tableContent
		};

		$('#kpiInforIcon').webuiPopover('destroy').webuiPopover($.extend({},settings,tableSettings));
	};
	initPopover();
	
	
};
$(init);﻿