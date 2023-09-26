///qqa
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var CstTypeArr = [{"value":"A","text":$g('平会诊超时')}, {"value":"B","text":$g('急会诊超时')}];
$(function(){
	
	initParams();
	
	initCombobox();
	
	initTable();

	initMethod ();
	
})



function initParams(){
	episodeID = getParam("EpisodeID");
}
	
function initCombobox(){
   var LgLocID = session['LOGON.CTLOCID'];
	/// 开始日期
	$HUI.datebox("#stDate").setValue(GetCurSystemDate(-7));
	/// 结束日期
	$HUI.datebox("#endDate").setValue(GetCurSystemDate(0));
	
	$HUI.combobox("#consultStauts",{
		url: LINK_CSP+"?ClassName=web.DHCEMConsStatus&MethodName=jsonConsStat&HospID="+HospID,
		valueField: "value", 
		textField: "text",
		editable:true,
	})
	$HUI.combobox("#consultStauts").setValue(3);
	
	$HUI.combobox("#consultLoc",{
		url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+HospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote'
	})
	
	$HUI.combobox("#consRLoc",{
		url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+HospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote'
	})
	$HUI.combobox("#consRLoc").setValue(session['LOGON.CTLOCID']); /// 默认当前登录科室 bianshuai 2018-12-11
    
	if(LgLocID=="95"){
    $("#consRLoc").attr("readOnly",true); 
	}
    
   $HUI.combobox("#crsTime",{
		//url: LINK_CSP+"?ClassName=web.DHCEMConsStatus&MethodName=jsonConsStat&HospID="+HospID,
		data:CstTypeArr,
		valueField: "value", 
		textField: "text",
		editable:true
	})
}
	
function initTable(){
	
	var columns=[[
		{ field: 'CstID',align: 'center', title: 'CstID',hidden:true},
		{ field: 'CstItmID',align: 'center', title: 'CstItmID',hidden:true},
		{ field: 'Detail',align: 'center', title: '明细',width:40,formatter:formatDetail},
		{ field: 'CstRLoc',align: 'center', title: '申请科室',width:100},
		{ field: 'CstUser',align: 'center', title: '申请人',width:100},
		{ field: 'CstLoc',align: 'center', title: '会诊科室',width:200},
		{ field: 'CareProv',align: 'center', title: '会诊医生',width:120},
		{ field: 'PatName',align: 'center', title: '患者姓名',width:120},
		{ field: 'PatSex',align: 'center', title: '性别',width:60},
		{ field: 'PatWard',align: 'center', title: '病区',width:150},
		{ field: 'PatBed',align: 'center', title: '床号',width:80},
		{ field: 'PatDiagDesc',align: 'center', title: '诊断',width:180},
		{ field: 'CstTrePro',align: 'center', title: '简要病史',width:180,formatter:SetCellField},
		{ field: 'CstPurpose',align: 'center', title: '会诊理由及要求',width:180,formatter:SetCellField},
		{ field: 'CsOpinion',align: 'center', title: '会诊结论',width:250},
		{ field: 'CstDate',align: 'center', title: '申请日期',width:120},
		{ field: 'CstTime',align: 'center', title: '申请时间',width:120},
		{ field: 'CstNDate',align: 'center', title: '会诊日期',width:120},
		{ field: 'CstNTime',align: 'center', title: '会诊时间',width:120},
		{ field: 'CstStatus',align: 'center', title: '当前状态',width:120},
		{ field: 'CstType',align: 'center', title: '申请类型',width:120}
	]];
	$HUI.datagrid("#mainLisTable",{
		url:LINK_CSP+"?ClassName=web.DHCEMFindConsult&MethodName=GetConsultList",
		queryParams:{
			Params:getParams()
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		autoSizeColumn:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:true,
		nowrap:false,
		onClickRow:function(rowIndex, rowData){
			if(rowData.CstStatus=="完成"){
				$("#bt_off").linkbutton("disable");
			}else{
				$("#bt_off").linkbutton("enable");
			}
	    },
	    onDblClickRow: function (rowIndex, rowData) {

        }
	})

}

/// 处理特殊字符
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
}
	
function initMethod(){
	
}
function commonPrint(){
		
}

function commonExport(){
	runClassMethod("web.DHCEMFindConsult","GetExportDate",{"UserID":UserID},function(retData){
		exportExecl(retData);
	})		
}

function exportExecl(data){
	var stDate = $HUI.datebox("#stDate").getValue(); 				/// 开始日期
	var endDate = $HUI.datebox("#endDate").getValue();     			/// 结束日期
	if(!data.length){
		$.messager.alert("提示","无需导出数据！");
		return;	
	}
	var Str = "(function test(x){"+
	"var xlApp = new ActiveXObject('Excel.Application');"+
	"var xlBook = xlApp.Workbooks.Add();"+
	"var objSheet = xlBook.ActiveSheet;"+
	"xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,14)).MergeCells = true;"+ //合并单元格
	"objSheet.cells(1,1).Font.Bold = true;"+
	"objSheet.cells(1,1).Font.Size =24;"+
	"objSheet.cells(1,1).HorizontalAlignment = -4108;"+
	"objSheet.Cells(1,1).value='统计时间:"+stDate+"至"+endDate+"';";
	var beginRow=2;
	Str=Str+"objSheet.Cells(2,1).value='申请科室';"+ 
	"objSheet.Cells(2,2).value='申请人';"+    
	"objSheet.Cells(2,3).value='会诊科室';"+	 
	"objSheet.Cells(2,4).value='患者姓名';"+ 	
	"objSheet.Cells(2,5).value='性别';"+ 	 
	"objSheet.Cells(2,6).value='病区';"+ 
	"objSheet.Cells(2,7).value='床号';"+ 
	"objSheet.Cells(2,8).value='诊断';"+ 
	"objSheet.Cells(2,9).value='简要病史';"+ 
	"objSheet.Cells(2,10).value='会诊目的';"+ 
	"objSheet.Cells(2,11).value='申请日期';"+ 
	"objSheet.Cells(2,12).value='申请时间';"+ 	 
	"objSheet.Cells(2,13).value='当前状态';"+ 	 
	"objSheet.Cells(2,14).value='申请类型';";	 
	Str=Str+"objSheet.Columns(11).NumberFormatLocal='@';"; //hxy 2020-04-14
	for (var i=0;i<data.length;i++){
		Str=Str+"objSheet.Cells("+(i+beginRow+1)+","+1+").value='"+data[i].CstRLoc+"';"+       
		"objSheet.Cells("+(i+beginRow+1)+","+2+").value='"+data[i].CstUser+"';"+      
		"objSheet.Cells("+(i+beginRow+1)+","+3+").value='"+data[i].CstLoc+"';"+  
		"objSheet.Cells("+(i+beginRow+1)+","+4+").value='"+data[i].PatName+"';"+ 	 
		"objSheet.Cells("+(i+beginRow+1)+","+5+").value='"+data[i].PatSex+"';"+ 
		"objSheet.Cells("+(i+beginRow+1)+","+6+").value='"+data[i].PatWard+"';"+ 	 
		"objSheet.Cells("+(i+beginRow+1)+","+7+").value='"+data[i].PatBed+"';"+ 	
		"objSheet.Cells("+(i+beginRow+1)+","+8+").value='"+data[i].PatDiagDesc+"';"+ 
		"objSheet.Cells("+(i+beginRow+1)+","+9+").value='"+data[i].CstTrePro.replace(/\n/g,"\\n").replace(/\'/g,"\\'")+"';"+ 			
		"objSheet.Cells("+(i+beginRow+1)+","+10+").value='"+data[i].CstPurpose.replace(/\n/g,"\\n").replace(/\'/g,"\\'")+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+11+").value='"+data[i].CstDate+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+12+").value='"+data[i].CstTime+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+13+").value='"+data[i].CstStatus+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+14+").value='"+data[i].CstType+"';";			
	}
	var row1=beginRow,row2=data.length+beginRow,c1=1,c2=14;
	Str=Str+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;"+
	"xlApp.Range(xlApp.Cells(1,8),xlApp.Cells("+data.length+beginRow+",8)).WrapText = true;"+
	"xlApp.Range(xlApp.Cells(1,9),xlApp.Cells("+data.length+beginRow+",9)).WrapText = true;"+
	"xlApp.Range(xlApp.Cells(1,10),xlApp.Cells("+data.length+beginRow+",10)).WrapText = true;"+
	"xlApp.Visible=true;"+
	"objSheet.Columns.AutoFit;"+
	"xlApp=null;"+
	"xlBook=null;"+
	"objSheet=null;"+
	"return 1;}());";
	 //以上为拼接Excel打印代码为字符串
    CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
	return;	
}

/// 查询统计列表
function commonQuery(){
	$HUI.datagrid("#mainLisTable").load({"Params":getParams()});
}

function commonOff(){
	var rows = $HUI.datagrid("#mainLisTable").getSelections();
	if(!rows.length){
		$.messager.alert("提示","请选中一条数据！");
		return;
	}
	var CstID = rows[0].CstID;
	runClassMethod("web.DHCEMConsult","CanCstNo",{"CstID":CstID,"UserID":UserID},function(retString){
		if(retString==0){
			$.messager.alert("提示","作废成功!");
			commonQuery();    //刷新
		}
	},'text')	
}

function getParams(){
	var stDate = $HUI.datebox("#stDate").getValue(); 				/// 开始日期
	var endDate = $HUI.datebox("#endDate").getValue();     			/// 结束日期
	var cstRLocID = $HUI.combobox("#consRLoc").getValue()==undefined?"":$HUI.combobox("#consRLoc").getValue();   //申请科室
	var cstLocID = $HUI.combobox("#consultLoc").getValue()==undefined?"":$HUI.combobox("#consultLoc").getValue();      //接收科室
	var cstStauts = $HUI.combobox("#consultStauts").getValue()==undefined?"":$HUI.combobox("#consultStauts").getValue(); //状态
	var crsTime ="" ; 
	//$HUI.combobox("#crsTime").getValue()==undefined?"":$HUI.combobox("#crsTime").getValue(); //是否超时
    /// 重新加载会诊列表
	var params = stDate+"^"+endDate+"^"+cstRLocID+"^"+cstLocID+"^"+cstStauts+"^"+UserId+"^"+crsTime+"^"+LgHospID;
	return params;
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


function formatDetail(value, rowData, rowIndex){
	return '<a href="#" onclick="openCstDetail(\''+rowData.CstID+'\',\''+rowData.CstItmID+'\')"><img src="../scripts/dhcnewpro/images/adv_sel_8.png" border="0/"></a>';
}

function openCstDetail(CstID,CstItmID){
	var lnk = "dhcem.consultwrite.csp?CstID="+CstID+"&CstItmID="+CstItmID+"&seeCstType=1"
	websys_showModal({
		url: lnk,
		height:640,
		width:890,
		iconCls:"icon-w-paper",
		title: $g('会诊明细'),
		closed: true,
		onClose:function(){}
	});	
}