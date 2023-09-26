///qqa
var exportShowDatail="";
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID //hxy 2020-05-29
$(function(){
	
	initParams();
	
	initCombobox();
	
	initTable();
	
	initMethod ();
		
})



function initParams(){
	Model = getParam("Model");   //模式：1：查看自己，2：查看所有；默认查看自己
}
	
function initCombobox(){
	$HUI.combobox("#statisType",{
		valueField: "value", 
		textField: "text",
		editable:true,
		data:[
			{
				"value":1,
				"text":$g("按照申请科室")
			},{
				"value":2,
				"text":$g("按照接收科室")
			},
		]
	})
	
	$HUI.combobox("#consultType",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonAllCstType&HospID="+session['LOGON.HOSPID'],
		valueField: "value", 
		textField: "text",
		editable:true,
		onLoadSuccess:function(data){
	        var data = $HUI.combobox("#consultType").getData();
	        var CstType = $HUI.combobox("#consultType").getValue();
	        if(data.length>0){
			    $HUI.combobox("#consultType").select(data[0].value);
			    $HUI.datagrid("#consultStatisTable").load({"Params":getParams()});
		    }
	    }
		
	})
	
	$HUI.combobox("#statisType").setValue(1);      //默认为本人发送
	
	$HUI.combobox("#consNature",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstProp&LgHospID="+LgHospID, //hxy 2020-05-29 add LgHospID
		valueField: "itmID", 
		textField: "itmDesc",
		editable:true
		
	})
	
	/// 开始日期
	$HUI.datebox("#stDate").setValue(GetCurSystemDate(-7));
	/// 结束日期
	$HUI.datebox("#endDate").setValue(GetCurSystemDate(0));
}
	
function initTable(){
	var columns=[[
		{ field: 'CstRLoc',align: 'center', title: '申请科室',width:50},
		{ field: 'CsLocDesc',align: 'center', title: '会诊科室',width:250,hidden:true},
		{ field: 'CareProvTpDesc',align: 'center', title: '会诊职称',width:50},
		{ field: 'CsUserDesc',align: 'center', title: '会诊医师',width:50},
		{ field: 'Number',align: 'center', title: '会诊次数',width:50,formatter:formNumber},
		{ field: 'OverTimeNumber',align: 'center', title: '超时次数',width:50,formatter:formOverTimeNumber},
		{ field: 'OrdAllPress',align: 'center', title: '会诊金额',width:50},
		{ field: 'ConsItms',align: 'center', title: 'Itms',width:50,hidden:true}
	]];
	$HUI.datagrid("#consultStatisTable",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsultStatisQuery&MethodName=GetConsultList",
		queryParams:{
			Params:getParams()
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:false,
		onClickRow:function(rowIndex, rowData){

	    },
	    onDblClickRow: function (rowIndex, rowData) {

        }
	})
	
	var columns=[[
		{ field: 'CstRLoc',align: 'center', title: '申请科室',width:50},
		{ field: 'CstRUser',align: 'center', title: '申请人',width:250,hidden:true},
		{ field: 'CstLoc',align: 'center', title: '会诊科室',width:50},
		{ field: 'CstRDate',align: 'center', title: '申请日期',width:50},
		{ field: 'CstRTime',align: 'center', title: '申请时间',width:50},
		{ field: 'CmpDate',align: 'center', title: '完成日期',width:50},
		{ field: 'CmpTime',align: 'center', title: '完成时间',width:50},
		{ field: 'PatName',align: 'center', title: '病人姓名',width:50},
		{ field: 'CstType',align: 'center', title: '会诊类型',width:50},
		{ field: 'EpisodeID',align: 'center', title: '病人就诊',width:50},
		{ field: 'Detail',align: 'center', title: '明细',width:20,formatter:formatDetail}
	]];
	
	///会诊明细
	$HUI.datagrid("#consDetailTable",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsultStatisQuery&MethodName=GetConsultDetailList",
		queryParams:{
			Params:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:true
	})
	
}
	
function initMethod(){
	
}

/// 查询统计列表
function commonQuery(){
	$HUI.datagrid("#consultStatisTable").load({"Params":getParams()});
	var statisType = $HUI.combobox("#statisType").getValue()==undefined?"":$HUI.combobox("#statisType").getValue();
	if(statisType==1){
		$('#consultStatisTable').datagrid('showColumn','CstRLoc'); 
		$('#consultStatisTable').datagrid('hideColumn','CsLocDesc');
	}else if(statisType==2){
		$('#consultStatisTable').datagrid('showColumn','CsLocDesc'); 	
		$('#consultStatisTable').datagrid('hideColumn','CstRLoc');
	}
	if(!$HUI.checkbox("#showDetail").getValue()){
		$('#consultStatisTable').datagrid('hideColumn','CsUserDesc'); 	
	}
	if($HUI.checkbox("#showDetail").getValue()){
		$('#consultStatisTable').datagrid('showColumn','CsUserDesc'); 	
	}
}

function getParams(){
	var stDate = $HUI.datebox("#stDate").getValue(); /// 开始日期
	var endDate = $HUI.datebox("#endDate").getValue();     /// 结束日期
	var statisType = $HUI.combobox("#statisType").getValue()==undefined?"":$HUI.combobox("#statisType").getValue();    	 /// 状态
	var consultType = $HUI.combobox("#consultType").getValue()==undefined?"":$HUI.combobox("#consultType").getValue();
	var showDetail = $HUI.checkbox("#showDetail").getValue()?"Y":"N"; 
	var consNature = $HUI.combobox("#consNature").getValue()==undefined?"":$HUI.combobox("#consNature").getValue();
	exportShowDatail = showDetail;
	if(Model=="2") LocID=""
    /// 重新加载会诊列表
	var params = stDate+"^"+endDate+"^"+statisType+"^"+showDetail+"^"+LocID+"^"+consultType+"^"+consNature;
	return params;
}

function commonExport(){
	var datas = $('#consultStatisTable').datagrid("getData");
	exportData(datas.rows);
}

function formNumber(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowConsultDetail(\''+rowData.ConsItms+'\')">&nbsp;'+value+'&nbsp;</a>';
}

function formOverTimeNumber(value, rowData, rowIndex){	
	return '<a style="text-decoration:underline" href="#" onclick="ShowConsultDetail(\''+rowData.OverTimeItmIDs+'\')">&nbsp;'+value+'&nbsp;</a>';

}

function formatDetail(value, rowData, rowIndex){
	return '<a href="#" onclick="openCstDetail(\''+rowData.CstID+'\',\''+rowData.CstItmID+'\')"><img src="../scripts/dhcnewpro/images/adv_sel_8.png" border="0/"></a>';
}

function openCstDetail(cstID,cstItmID){
	OpenConsWin();
	$("#newWinFrame").attr("src","dhcem.consultwrite.csp?CstID="+cstID+"&CstItmID="+cstItmID+"&seeCstType=1");
	return;
}

///查询会诊明细
function ShowConsultDetail(value){
	$HUI.datagrid("#consDetailTable").load({"Params":value});	
	$HUI.window("#consDetailWin").open();
}

function exportData(datas){
	var stDate = $HUI.datebox("#stDate").getValue(); /// 开始日期
	var endDate = $HUI.datebox("#endDate").getValue();     /// 结束日期
	if(datas.length==0){
		$.messager.alert("提示","无需导出数据！");
		return;	
	}
	
	var Str = "(function test(x){"+
	"var xlApp = new ActiveXObject('Excel.Application');"+
	"var xlBook = xlApp.Workbooks.Add();"+
	"var objSheet = xlBook.ActiveSheet;";
	var beginRow=2;
	var colNuber=0;;
	for (var i=0;i<datas.length;i++){
		colNuber=0;
		Str=Str+"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+((datas[i].CstRLoc)||(datas[i].CsLocDesc))+"';"+ //申请科室
		"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].CareProvTpDesc+"';";			  //会诊职称
		if(exportShowDatail=="Y"){
			Str=Str+"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].CsUserDesc+"';"	 //会诊医师
		}
		Str=Str+"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].Number+"';"+	//会诊次数
		"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].OverTimeNumber+"';"+	//超时次数
		"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].OrdAllPress+"';";	 	//会诊金额		
	}
	
	colNuber=0;
	Str=Str+"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='"+(typeof datas[0].CstRLoc != "undefined"?"申请科室":"会诊科室")+"';"+    //申请科室
	"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='会诊职称';"; 	 //会诊职称
	if(exportShowDatail=="Y"){
		Str=Str+"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='会诊医师';";	 //会诊医师
	}
	Str=Str+"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='会诊次数';"+	//会诊次数
	"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='超时次数';"+			//超时次数	
	"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='会诊金额';"	 		//会诊金额	
	
	Str=Str+"xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,"+colNuber+")).MergeCells = true;"+ //合并单元格
	"objSheet.Cells(1,1).value= '统计时间:"+stDate+"至"+endDate+"';";
	
	var row1=beginRow,row2=datas.length+beginRow,c1=1,c2=colNuber;
	Str=Str+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;"+
	"xlApp.Visible=true;"+
	"xlApp=null;"+
	"xlBook=null;"+
	"objSheet=null;"+
    "return 1;}());";
    //以上为拼接Excel打印代码为字符串
    CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
	return;
}


function exportDataOld(datas){
	var stDate = $HUI.datebox("#stDate").getValue(); /// 开始日期
	var endDate = $HUI.datebox("#endDate").getValue();     /// 结束日期
	if(datas.length==0){
		$.messager.alert("提示","无需导出数据！");
		return;	
	}
	//var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	//var Template = path+"DHCEM_Consult_Statis.xls";
	
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add();
	var objSheet = xlBook.ActiveSheet;
	var beginRow=2;	
	var colNuber=0;
	for (var i=0;i<datas.length;i++){
		colNuber=0;
		objSheet.Cells(i+beginRow+1,colNuber+=1).value=(datas[i].CstRLoc)||(datas[i].CsLocDesc); //申请科室
		objSheet.Cells(i+beginRow+1,colNuber+=1).value=datas[i].CareProvTpDesc; //会诊职称
		if(exportShowDatail=="Y"){
			objSheet.Cells(i+beginRow+1,colNuber+=1).value=datas[i].CsUserDesc;	 //会诊医师
		}
		objSheet.Cells(i+beginRow+1,colNuber+=1).value=datas[i].Number;		     //会诊次数
		objSheet.Cells(i+beginRow+1,colNuber+=1).value=datas[i].OverTimeNumber;	 //超时次数
		objSheet.Cells(i+beginRow+1,colNuber+=1).value=datas[i].OrdAllPress;	 //会诊金额		
	}
	
	colNuber=0;
	objSheet.Cells(beginRow,colNuber+=1).value=(typeof datas[0].CstRLoc != "undefined"?"申请科室":"会诊科室");    //申请科室
	objSheet.Cells(beginRow,colNuber+=1).value="会诊职称"; 	 //会诊职称
	if(exportShowDatail=="Y"){
		objSheet.Cells(beginRow,colNuber+=1).value="会诊医师";	 //会诊医师
	}
	objSheet.Cells(beginRow,colNuber+=1).value="会诊次数";	 //会诊次数
	objSheet.Cells(beginRow,colNuber+=1).value="超时次数";	 //超时次数	
	objSheet.Cells(beginRow,colNuber+=1).value="会诊金额";	 //会诊金额	
	
	xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,colNuber)).MergeCells = true; //合并单元格
	objSheet.Cells(1,1).value= "统计时间:"+stDate+"至"+endDate
	gridlist(objSheet,beginRow,datas.length+beginRow,1,colNuber);
	
	xlApp.Visible=true;
	xlApp=null;
	xlBook=null;
	objSheet=null;	
}

function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).Weight=2
}

/// 打卡MDT填写页面
function OpenConsWin(){
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true",
		iconCls:'icon-w-card'
	};
	new WindowUX($g('会诊明细查询'), 'ConsWin', '930', '560', option).Init();
}


/// 获取系统当前日期
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}