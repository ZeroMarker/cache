
//页面初始化函数
function initPageDefault(){
	
	initDateBox();				//初始化查询条件
	initPresctList();			//初始化处方列表
	initProblemType();			//初始化问题下拉框
	initDrugList();				//初始化药品列表下拉框
	initButton();				//初始化按钮
	
	
}

//初始化处方列表
function initPresctList(){
	
	var columns=[[
		
		{title:'处方ID',field:"auditID",width:160,align:"left",hidden:'true'},
		{title:'患者ID',field:"patientID",width:160,align:"left",hidden:'true'},
		{title:'就诊ID',field:"admID",width:160,align:"left",hidden:'true'},
		{title:'就诊号',field:"admNo",width:160,align:"left",formatter:linkPrescDetail},
		{title:'病人姓名',field:"patName",width:160,align:"left"},
		{title:'性别',field:"patSex",width:80,align:"left"},
		{title:'年龄',field:"patAge",width:160,align:"left"},
		{title:'诊断',field:"diagnos",width:160,align:"left"},
		{title:'标识',field:"manLevel",width:80,align:"left",
			styler:function(value,row,index){
				return switchWarn(value,row,index)
				}
			},
		{title:'处方号',field:"prescNo",width:160,align:"left"},
		{title:'处方科室',field:"locDesc",width:160,align:"left"},
		{title:'处方医生',field:"docDesc",width:160,align:"left"},
		{title:'审核药师',field:"pharDesc",width:160,align:"left"},
		{title:'审核状态',field:"status",width:160,align:"left"},
		{title:'审核原因',field:"reason",width:160,align:"left"},
		{title:'药师备注',field:"remark",width:160,align:"left"},
		{title:'医生申诉',field:"appealtext",width:160,align:"left"}
	]];
	
	var option={
		rownumbers : false,
		singleSelect : true,
		onDblClickRow:function(rowIndex,rowData){
			var auditID = rowData.auditID;
			var patientID = rowData.patientID
			var admID = rowData.admID;
			
		}
	}
	var stDate = $HUI.datebox("#stDate").getValue();
	var endDate = $HUI.datebox("#endDate").getValue();	
	var params = stDate +"^"+ endDate;
	var uniturl = $URL+"?ClassName=web.DHCPRESCList&MethodName=GetPrescList&params="+params;
	new ListComponent('prescList', columns, uniturl, option).Init();
}

//判断处方最终状态
function switchStatus(value,row,index){
	
	switch(value){
		
		case "0":
			value = "新任务";
			break;
		case "1":
			value = "待确认";
			break;
		case "2":
			value = "必须修改";
			break;	
	}
	
	return value;
		
}

//判断标识
function switchWarn(value,row,index){
	
	
	switch(value){
		
		case "禁止":;
			var css = "color:#000000;"
			css = css + "background-color:#ECECEC"
			break;
		case "警示":
			var css = "color:white;"
			css = css + "background-color:red"
			break;
		case "提醒":
			var css = "color:white;"
			css = css + "background-color:orange"
			break;	
		case "提示":
			var css = "color:white;"
			css = css + "background-color:green"
			break;
		default:
			var css = "color:black;"
	}
	
	return css;
		
}

//初始化问题下拉框
function initProblemType(){
	
	var uniturl = $URL+"?ClassName=web.DHCPRESCCommonUtil&MethodName="  

	$HUI.combobox("#problemtype",{
		url:uniturl+"QueryDicItem&code=RIT&hospId="+LgHospID,
		valueField:'value',
		textField:'text',
		panelHeight:"200",
		mode: 'local',
		filter: function(q, row){
	 		var opts = $(this).combobox('options');
	 		return row[opts.textField].indexOf(q)>-1;
		},
		onSelect:function(ret){
			
		 }
	})	
}

//初始化药品列表下拉框
function initDrugList(){
	
	var uniturl = $URL+"?ClassName=web.DHCPRESCCommonUtil&MethodName="  

	$HUI.combobox("#druglist",{
		url:uniturl+"QueryDrugList&hospId="+LgHospID,
		valueField:'value',
		textField:'text',
		panelHeight:"200",
		mode: 'remote',
		filter: function(q, row){
	 		var opts = $(this).combobox('options');
	 		return row[opts.textField].indexOf(q)>-1;
		},
		onSelect:function(ret){	
		 }
	})
	
}

//初始化问题类型下拉框
function initProblemType(){
	
	var uniturl = $URL+"?ClassName=web.DHCPRESCList&MethodName="  

	$HUI.combobox("#problemtype",{
		url:uniturl+"GetProblemType",
		valueField:'value',
		textField:'text',
		panelHeight:"200",
		mode: 'local',
		filter: function(q, row){
	 		var opts = $(this).combobox('options');
	 		return row[opts.textField].indexOf(q)>-1;
		},
		onSelect:function(ret){	
		 }
	})
	
}


//初始化按钮
function initButton(){
	
	/*/清空病号输入框
	$("#resetPatno").bind("click",function(){
		$("#patno").val("");	
	});*/
	
	//清空门诊号输入框
	$('#patno').keydown(function(e){
		if(e.keyCode==13){
			var inPatNo = $('#patno').val();
			var patNo = GetWholePatNo(inPatNo);
			$('#patno').val(patNo);
		}
	})
	//查询按钮
	$("#query").bind("click",queryPresc);
	
}

//查询处方
function queryPresc(){
	
	var stDate = $HUI.datebox("#stDate").getValue();
	var endDate = $HUI.datebox("#endDate").getValue();	
	
	
	
	var inPatNo = $('#patno').val();
	var patNo = GetWholePatNo(inPatNo);
	$('#patno').val(patNo);
	var patno =  $('#patno').val();
			
	var admno = $("#admno").val();
	var problemtype = $HUI.combobox("#problemtype").getText();
	var drug = $HUI.combobox("#druglist").getText();
	var manlevel = $("input[name='manlevel']:checked").val();
	
	manlevel =  (manlevel == undefined) ? "" : manlevel
	
	var params = stDate + "^" + endDate + "^" +patno + "^" + admno + "^" + manlevel + "^" + problemtype + "^" + drug+"^"+LgUserID;
	console.log(params)
	
	$("#prescList").datagrid("load",{"params":params})
}
//导出
function commonExport(){
	runClassMethod("web.DHCPRESCList","GetPrescPrtList",{"UserID":LgUserID},function(retData){
		exportExecl(retData);
	})		
}

function exportExecl(data){
	debugger;
	var stDate = $HUI.datebox("#stDate").getValue(); 				/// 开始日期
	var endDate = $HUI.datebox("#endDate").getValue();     			/// 结束日期
	if(!data.length){
		$.messager.alert("提示","无导出数据！","warning");
		return;	
	}
	var Str = "(function test(x){"+
	"var xlApp = new ActiveXObject('Excel.Application');"+
	"var xlBook = xlApp.Workbooks.Add();"+
	"var objSheet = xlBook.ActiveSheet;"+
	"xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,32)).MergeCells = true;"+ //合并单元格
	"objSheet.cells(1,1).Font.Bold = true;"+
	"objSheet.cells(1,1).Font.Size =24;"+
	"objSheet.cells(1,1).HorizontalAlignment = -4108;"+
	"objSheet.Cells(1,1).value='统计时间:"+stDate+"至"+endDate+"';";
	var beginRow=2;
	Str=Str+"objSheet.Cells(2,1).value='姓名';"+ 
	"objSheet.Cells(2,2).value='性别';"+
	"objSheet.Cells(2,3).value='年龄';"+
	"objSheet.Cells(2,4).value='诊断';"+
	"objSheet.Cells(2,5).value='开单科室';"+
	"objSheet.Cells(2,6).value='处方信息';"+	 
	"objSheet.Cells(2,7).value='合理用药提示内容';"
	for (var i=0;i<data.length;i++){
		Str=Str+"objSheet.Cells("+(i+beginRow+1)+","+1+").value='"+data[i].PatName+"';"+       
		"objSheet.Cells("+(i+beginRow+1)+","+2+").value='"+data[i].PatSex+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+3+").value='"+data[i].PatAge+"';"+      
		"objSheet.Cells("+(i+beginRow+1)+","+4+").value='"+data[i].Diadata+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+5+").value='"+data[i].Loc+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+6+").value='"+data[i].PrescData+"';"+  
		"objSheet.Cells("+(i+beginRow+1)+","+7+").value='"+data[i].CkbData+"';"
	}
	var row1=beginRow,row2=data.length+beginRow,c1=1,c2=7;
	Str=Str+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;"+
	"xlApp.Range(xlApp.Cells(1,13),xlApp.Cells("+data.length+beginRow+",13)).WrapText = true;"+
	"xlApp.Range(xlApp.Cells(1,14),xlApp.Cells("+data.length+beginRow+",14)).WrapText = true;"+
	"xlApp.Range(xlApp.Cells(1,15),xlApp.Cells("+data.length+beginRow+",15)).WrapText = true;"+
	"xlApp.Range(xlApp.Cells(1,16),xlApp.Cells("+data.length+beginRow+",16)).WrapText = true;"+
	"xlApp.Visible=true;"+
	"objSheet.Columns.AutoFit;"+
	"xlApp=null;"+
	"xlBook=null;"+
	"objSheet=null;"+
	"return 1;}());";
	 //以上为拼接Excel打印代码为字符串
	 debugger;
    CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
	return;	
}

//初始化日期框
function initDateBox(){
	$HUI.datebox("#stDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}

function linkPrescDetail(value, rowData, rowIndex)
{
	var html = "<a href='#' onclick=\"OpenEditWin('"+rowData.auditID+"','"+rowData.patientID+"','"+rowData.admID+"','"+rowData.mradm+"')\">"+rowData.admNo+"</a>";

 	return html; 
}
function OpenEditWin(auditId,patientId,admId,mradm)
{  
		var width = (document.documentElement.clientWidth-100);
		var height = (document.documentElement.clientHeight-100);
		var url="dhcpresc.auditdetail.csp?&auditID="+auditId+"&patientID="+patientId+"&admID="+admId+"&mradm="+mradm;
		websys_showModal({
			url: url,
			width:width,
			height:height,
			top:(document.documentElement.clientWidth-width)/2,
			left:(document.documentElement.clientHeight-height)/2,
			iconCls:"icon-w-paper",
			title: '审核详情',
			closed: true,
			onClose:function(){
				
			}
		});
}
///补0病人登记号
function GetWholePatNo(EmPatNo){

	///  判断登记号是否为空
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  登记号长度值
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('错误提示',"登记号输入错误！");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
