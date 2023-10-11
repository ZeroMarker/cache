
/*
Creator:LiangQiang
CreatDate:2016-01-15
Description:知识库监测查询
*/
var url='dhcpha.clinical.ckbaction.csp' ;
var levelArray=[{ "value":"", "text": "全部" },{ "value": "C", "text": "管制" },{ "value": "W", "text": "警示" },{ "value": "S", "text": "提示" }]; 
var queryDate="";
var params=""

function BodyLoadHandler()
{
	//$('#export').bind('click',Export);	 //导出
	$("#stdate").datebox("setValue", formatDate(-1));  
	$("#enddate").datebox("setValue", formatDate(0));  
	
	// 科室
	$('#admLoc').combobox({
		mode:"remote",
		onShowPanel:function(){
			//$('#admLoc').combobox('reload',url+'?action=SelAllLoc')
			$('#admLoc').combobox('reload',url+'?action=GetAllLocNewVersion')
		}
	}); 	
	$('#admLoc').combobox('setValue',""); 	// 设置病区默认值
	
	// 管理级别
	$('#levelMan').combobox({
		panelHeight:"auto", 
		data:levelArray
	});  
	$('#levelMan').combobox('setValue',""); // 设置combobox默认值
	
	//目录
	$('#label').combobox({
		onShowPanel:function(){
			$('#label').combobox('reload',url+'?action=GetLabel');
		}
 	});  
	$('#label').combobox('setText',"全部"); //	设置combobox默认值
	
	$('#Find').bind("click",Query);			// 点击查询
	$('#reset').bind("click",Reset);  		// 重置	
		
	var columns =[[  	
			  {field:'adm',title:'就诊id',width:50,hidden:true}, 
		      {field:'patNo',title:'登记号',width:80,align:'center',hidden:true},
              {field:'patName',title:'病人姓名',width:80,align:'center'},
			  {field:'medicalNo',title:'病案号',width:80,hidden:true}, 
			  {field:'admLoc',title:'就诊科室',width:120},
			  {field:'admDocDesc',title:'医生',width:120},
			  {field:'patDiag',title:'诊断',width:200,hidden:false},	//QuNiapeng  2017/5/26
			  {field:'arcDesc',title:'医嘱名称',width:200},
              {field:'doseQty',title:'剂量',width:40,align:'center'},
			  {field:'unitDesc',title:'单位',width:40,align:'center'},
			  {field:'instrDesc',title:'用法',width:50,align:'center'},
			  {field:'phFreqDesc',title:'频率',width:80,align:'center'},
			  {field:'course',title:'疗程',width:50,align:'center'},
			  {field:'rmanf',title:'生产厂家',width:160},
			  {field:'speciFaction',title:'规格',width:80},
			  {field:'labelDesc',title:'目录',width:60,align:'center'},
			  {field:'levelDesc',title:'管理级别',width:80,align:'center'},
			  {field:'trueMsg',title:'提示信息',width:300,showTip:true,tipWidth:450},
			  {field:'rowId',title:'rowId',hidden:true}			  		 
		]];

    $('#libdatagrid').datagrid({
		title:'',
		url:url+'?action=QueryLibOrditemNew',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  
		pageList:[40,80,120],  
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		singleSelect:true,
		idField:'rowid',
		striped: true, 
		pagination:true,
		showFooter:true
		//nowrap:false
	});
	//$('#libdatagrid').datagrid('loadData', {total:0,rows:[]}); 
	//initScroll("#libdatagrid");//初始化显示横向滚动条
	$('#Find').bind("click",Query);  //点击查询
}


//查询
function Query()
{
    var stDate=$('#stdate').datebox('getValue');
	var endDate=$('#enddate').datebox('getValue');		// 截止日期
	var levelMan=$('#levelMan').combobox('getValue')	// 管理级别
	var label=$('#label').combobox('getValue'); 		// 目录
	var labelDesc=$('#label').combobox('getText'); 
	//var errReason=$('#errReason').datebox('getValue'); 
	var admLoc=$('#admLoc').combobox('getValue'); 		// 就诊科室
	if (admLoc === undefined){
		admLoc = "";
	}	
	queryDate=stDate +"  "+endDate;

 	params=stDate+"^"+endDate+"^"+levelMan+"^"+label+"^"+labelDesc+"^"+admLoc;  //+"^"+LocID+"^"+PatNo;

	$('#libdatagrid').datagrid({
		url:url+'?action=QueryLibOrditemNew',	
		queryParams:{
			params:params}
	});
	$('#libdatagrid').datagrid('loadData', {total:0,rows:[]});  
}

// 导出Excel
function ExportOld()
{
	var selItems = $('#libdatagrid').datagrid('getRows');
	if (!selItems.length){
		$.messager.alert('提示',"<font style='color:red;font-weight:bold;font-size:20px;'>请先查询记录!</font>","error");
		return;
	}
	$.messager.confirm("提示", "是否进行导出操作", function (res) {//提示是否导出
		if (res) {
			var filePath=browseFolder();
			if (typeof filePath=="undefined"){
				$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择路径后,重试！</font>","error");
				return;
			}
			ExportExcel(filePath);
			$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
		}
	})
}

function ExportExcel(filePath)
{
	
    var stDate=$('#stdate').datebox('getValue');
	var endDate=$('#enddate').datebox('getValue'); //截止日期
	var levelMan=$('#levelMan').datebox('getValue') //管理级别
	var label=$('#label').datebox('getValue'); 
	var errReason=$('#errReason').datebox('getValue'); 
	
	var params=stDate+"^"+endDate+"^"+levelMan+"^"+label+"^"+errReason;  //+"^"+LocID+"^"+PatNo;
	
	var Datalist="";
	$.ajax({
   	   type: "POST",
       url: url,
       async: false, //同步
       data: "action=GetLibOidItemExp&params="+params,
       success: function(val){
	      	 Datalist=eval(val);
       }
	});	
	if(Datalist==null){
		$.messager.alert("提示:","取数据错误！");
		return;
	} 
	//1、获取XLS打印路径 
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCPH_MR_OrdItmInfo.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet; 

	objSheet.Cells(2,2).value="'"+stDate+"至"+endDate; //查询日期  
	objSheet.Cells(2,7).value=session['LOGON.USERNAME']; //制表人
	objSheet.Cells(2,14).value=formatDate(0); //制表日期
	xlApp.Range(xlApp.Cells(5,1),xlApp.Cells(5+Datalist.length-1,17)).Borders.Weight = 1;//设置单元格边框*()
	xlApp.Range(xlApp.Cells(5,1),xlApp.Cells(5+Datalist.length-1,17)).WrapText=true; //设置为自动换行*
	xlApp.Range(xlApp.Cells(5,1),xlApp.Cells(5+Datalist.length-1,17)).HorizontalAlignment=2; //水平对齐方式枚举* (1-常规，2-靠左，3-居中，4-靠右，5-填充 6-两端对齐，7-跨列居中，8-分散对齐)
	xlApp.Range(xlApp.Cells(5,1),xlApp.Cells(5+Datalist.length-1,17)).VerticalAlignment=2; //垂直对齐方式枚举*(1-靠上，2-居中，3-靠下，4-两端对齐，5-分散对齐) 行，列有相应操作:

	for(var k=0;k<Datalist.length;k++){
		objSheet.Cells(5+k,1).value=Datalist[k].patNo;   //登记号
		objSheet.Cells(5+k,2).value=Datalist[k].patName; //姓名
		objSheet.Cells(5+k,3).value=Datalist[k].medicalNo //病案号		
		objSheet.Cells(5+k,4).value=Datalist[k].admLoc   //就诊科室
		objSheet.Cells(5+k,5).value=Datalist[k].admDate; //就诊日期
		objSheet.Cells(5+k,6).value=Datalist[k].groupFlag; //成组符号
		objSheet.Cells(5+k,7).value=Datalist[k].arcDesc;  //医嘱名称(商品名)		
		objSheet.Cells(5+k,8).value=Datalist[k].doseQty;  //剂量
		objSheet.Cells(5+k,9).value=Datalist[k].unitDesc; //剂量单位
		objSheet.Cells(5+k,10).value=Datalist[k].phFreqDesc; //频率
		objSheet.Cells(5+k,11).value=Datalist[k].instrDesc; //用法
		objSheet.Cells(5+k,12).value=Datalist[k].courseDesc; //疗程
		objSheet.Cells(5+k,13).value=Datalist[k].rmanf;     //生产厂家
		objSheet.Cells(5+k,14).value=Datalist[k].speciFaction; //生产规格
		objSheet.Cells(5+k,15).value=Datalist[k].levelDesc; //管理级别
		objSheet.Cells(5+k,16).value=Datalist[k].labelDesc; //目录
		objSheet.Cells(5+k,17).value=Datalist[k].errMsg; //提示信息	
    }
    var array=formatDate(0).split("-");
	var exportName="合理用药监测记录表"+array[0]+""+array[1]+""+array[2];
	xlBook.SaveAs(filePath+exportName+".xls");
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;

}

/// Description:	使用润乾报表导出
/// Creator:		QuNianpeng
/// CreateDate:		2017-05-26
function Export()
{
	user=session['LOGON.USERNAME']; //制表人
	markDate=formatDate(0); //制表日期
	
	var selItems = $('#libdatagrid').datagrid('getRows');
	if (!selItems.length){
		$.messager.alert('提示',"<font style='color:red;font-weight:bold;font-size:20px;'>请先查询记录!</font>","error");
		return;
	}	
	$.messager.confirm("提示", "是否进行导出操作", function (res) {//提示是否导出
		if(res){
			var parameter="DHCPH_MR_OrdItmInfo.raq"+"&params="+params+"&queryDate="+queryDate+"&user="+user+"&markDate="+markDate;
				DHCCPM_RQPrint(parameter);		
		}
		else{
			return;
		}
	})
}

/// Description:	查询条件重置
/// Creator:		QuNianpeng
/// CreateDate:		2017-09-18
function Reset()
{
	$("#stdate").datebox("setValue", formatDate(-1));  
	$("#enddate").datebox("setValue", formatDate(0));  	
	$('#levelMan').combobox('setValue',"");
	$('#label').combobox('setValue',"");
	$('#admLoc').combobox('setValue',"");
	$('#label').combobox('setText',"全部"); //	设置combobox默认值	
	Query();
}

