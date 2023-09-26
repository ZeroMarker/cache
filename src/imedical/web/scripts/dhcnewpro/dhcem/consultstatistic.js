//===========================================================================================
// 作者：      huaxiaoying
// 编写日期:   2018-04-27
// 描述:	   会诊明细统计
//===========================================================================================
/// 页面初始化函数


var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
function initPageDefault(){

	InitPageDataGrid();		  /// 初始化页面datagrid
	InitPageComponent(); 	  /// 初始化界面控件内容

}

/// 初始化界面控件内容
function InitPageComponent(){
	
	/// 开始日期
	$HUI.datebox("#CstStartDate").setValue(GetCurSysDate(-2));
	
	/// 结束日期
	$HUI.datebox("#CstEndDate").setValue(GetCurSysDate(0));
	
	/*var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsStatus&MethodName=";
	/// 状态类型
	var option = {
		panelHeight:"auto",
		onSelect:function(option){
		}
	}
	var url = uniturl+"jsonConsStat&HospID="+session['LOGON.HOSPID'];
	new ListCombobox("CstType",url,'',option).init();*/
}

/// 页面DataGrid初始定义已选列表
function InitPageDataGrid(){
	
	///  定义columns
	var columns=[[
		{field:'CstType',title:'会诊类型',width:100,align:'left'},
		{field:'CstRLoc',title:'申请科室',width:140},
		{field:'CstRUser',title:'申请医生',width:100},
		{field:'CstRDate',title:'申请日期',width:100,align:'left'},
		{field:'CstRTime',title:'申请时间',width:100,align:'left'},
		{field:'CstNDate',title:'会诊日期',width:100,align:'left'},
		{field:'CstNTime',title:'会诊时间',width:100,align:'left'},
		{field:'PatName',title:'病人姓名',width:100,align:'left'},
		{field:'PatRegNo',title:'登记号',width:100,align:'left'},
		{field:'CstTrePro',title:'病例摘要',width:100,align:'left',formatter:SetCellField},//
		{field:'CstPurpose',title:'会诊理由及要求',width:120,align:'left',formatter:SetCellField},//
		{field:'CstStat',title:'状态',width:100,align:'left'},
		{field:'CsLocDesc',title:'会诊科室',width:140,align:'left'},
		//{field:'CstECLArriTime',title:'报到时间',width:150,align:'center'},
		{field:'CstLogOverTime',title:'完成时间',width:150,align:'left'},
		{field:'CstECLUser',title:'确认医生',width:100,align:'left'},
		{field:'CstECLTime',title:'确认时间',width:150,align:'left'}
	]];
	
	///  定义datagrid
	var option = {
		title:$g('会诊明细统计'), //hxy 2020-04-30 st
		headerCls:'panel-header-gray', 
		border:true,
		iconCls:'icon-paper',//ed
		//fitColumns:true,
		//showHeader:false,
		pageSize:10000,
	    pageList:[10000,50000],
		fitColumn:true,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onClickRow:function(rowIndex, rowData){
	    },
		onLoadSuccess:function(data){
			BindTips(); /// 绑定提示消息
		}
	};
	
	/// init
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsultStatistic&MethodName=JsonGetConsultNo";
	new ListComponent('dgCstDetList', columns, uniturl, option).Init();
}

/// 处理特殊字符
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
}

/// 查询
function QryConsList(){
	
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue();  /// 开始日期
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();      /// 结束日期
	var CstStatus = $("input[name='CstStatus']:checked").val();   /// 状态
	if(CstStatus==undefined){CstStatus="";}
	//var CstTypeID = $HUI.combobox("#CstType").getValue();    /// 状态
	
    /// 重新加载会诊列表
	var params = CstStartDate +"^"+ CstEndDate +"^"+ CstStatus +"^"+ LgHospID;
	$("#dgCstDetList").datagrid("load",{"Params":params});
}

/// 获取系统日期
function GetCurSysDate(offset){

	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate;
}

///打印
function PrtConsList(){
    
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue();  /// 开始日期
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();      /// 结束日期
	
	var xlsExcel = new ActiveXObject("Excel.Application");
	var xlsBook = xlsExcel.Workbooks.Add();
	var objSheet = xlsBook.ActiveSheet;
	xlsExcel.Range(objSheet.Cells(1,1),objSheet.Cells(1,17)).MergeCells = true;
	objSheet.cells(1,1).Font.Bold = true;
	//objSheet.cells(1,1).Font.Size =24;
	//objSheet.cells(1,1).HorizontalAlignment = -4108;
	objSheet.cells(1,1)="会诊明细统计("+CstStartDate+"至"+CstEndDate+")";
	var strjLen=$HUI.datagrid("#dgCstDetList").getData().rows.length;
	for (i=1;i<=strjLen;i++)
     { 	
	    objSheet.cells(i+2,1)=i;
	    objSheet.cells(i+2,2)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstType;
	    objSheet.cells(i+2,3)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstRLoc;
	    objSheet.cells(i+2,4)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstRUser;
	    objSheet.cells(i+2,5)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstRDate;
	    objSheet.cells(i+2,6)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstRTime;
	    objSheet.cells(i+2,7)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstNDate;
	    
	    objSheet.cells(i+2,8)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstNTime;
	    objSheet.cells(i+2,9)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].PatName;
	    objSheet.cells(i+2,10)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].PatRegNo;
	    objSheet.cells(i+2,11)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstTrePro;
	    objSheet.cells(i+2,12)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstPurpose;
	    objSheet.cells(i+2,13)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstStat;
	    objSheet.cells(i+2,14)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CsLocDesc;
		//objSheet.cells(i+2,15)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstECLArriTime;
		objSheet.cells(i+2,15)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstLogOverTime;
		objSheet.cells(i+2,16)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstECLUser;
		objSheet.cells(i+2,17)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstECLTime;
		objSheet.Rows(i+2).RowHeight = 30; 
		for (j=1;j<=18;j++)
     	{ 	
			xlsExcel.Range(xlsExcel.Cells(i+2,j),xlsExcel.Cells(i+2,j)).Borders(1).LineStyle=1;  //设置上边框
			xlsExcel.Range(xlsExcel.Cells(i+2,j),xlsExcel.Cells(i+2,j)).Borders(2).LineStyle=1;  //设置上边框
			xlsExcel.Range(xlsExcel.Cells(i+2,j),xlsExcel.Cells(i+1,j)).Borders(4).LineStyle=1;  //设置上边框
 	 	}

 	 }
     
    //objSheet.Columns.AutoFit;
	objSheet.printout();
	
	xlsExcel=null;
	xlsBook.Close(savechanges=false);
	objSheet=null;

}

///导出：兼容谷歌
function ExpConsList(){	
	var CstStartDate = $HUI.datebox('#CstStartDate').getValue();  /// 开始日期
	var CstEndDate = $HUI.datebox('#CstEndDate').getValue();      /// 结束日期
	
	var Str = "(function test(x){"+
	"var xlsExcel = new ActiveXObject('Excel.Application');"+
	"var xlsBook = xlsExcel.Workbooks.Add();"+
	"var objSheet = xlsBook.ActiveSheet;"+ 
	"xlsExcel.Visible = true;"+ 
	"xlsExcel.Range(objSheet.Cells(1,1),objSheet.Cells(1,16)).MergeCells = true;"+
	"objSheet.Columns(5).NumberFormatLocal='@';"+
	"objSheet.Columns(7).NumberFormatLocal='@';"+
	"objSheet.Columns(13).NumberFormatLocal='@';"+
	"objSheet.Columns(14).NumberFormatLocal='@';"+
	"objSheet.Columns(16).NumberFormatLocal='@';"+
	"objSheet.cells(1,1).Font.Bold = true;"+
	"objSheet.cells(1,1).Font.Size =24;"+
	"objSheet.cells(1,1).HorizontalAlignment = -4108;"+
	"objSheet.cells(1,1)='会诊明细统计("+CstStartDate+"至"+CstEndDate+")';"+
	"objSheet.cells(2,1)='序号';"+
	"objSheet.cells(2,2)='会诊类型';"+
	"objSheet.cells(2,3)='申请科室';"+
	"objSheet.cells(2,4)='申请医生';"+
	"objSheet.cells(2,5)='申请日期';"+
	"objSheet.cells(2,6)='申请时间';"+
	"objSheet.cells(2,7)='会诊日期';"+
	"objSheet.cells(2,8)='会诊时间';"+
	"objSheet.cells(2,9)='病例摘要';"+
	"objSheet.cells(2,10)='会诊理由及要求';"+
	"objSheet.cells(2,11)='状态';"+
	"objSheet.cells(2,12)='会诊科室';"+
	"objSheet.cells(2,13)='报到时间';"+
	"objSheet.cells(2,14)='完成时间';"+
	"objSheet.cells(2,15)='确认医生';"+
	"objSheet.cells(2,16)='确认时间';";
	
	var strjLen=$HUI.datagrid('#dgCstDetList').getData().rows.length;
	
	for (i=1;i<=strjLen;i++){
		Str=Str+"objSheet.cells("+(i+2)+",1)='"+i+"';"+
		"objSheet.cells("+(i+2)+",2)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstType+"';"+
		"objSheet.cells("+(i+2)+",3)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstRLoc+"';"+
		"objSheet.cells("+(i+2)+",4)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstRUser+"';"+
		"objSheet.cells("+(i+2)+",5)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstRDate+"';"+
		"objSheet.cells("+(i+2)+",6)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstNTime+"';"+
		"objSheet.cells("+(i+2)+",7)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstNDate+"';"+
		"objSheet.cells("+(i+2)+",8)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstNTime+"';"+
		"objSheet.cells("+(i+2)+",9)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstTrePro.replace(/\n/g,"\\n").replace(/\'/g,"\\'")+"';"+
		"objSheet.cells("+(i+2)+",10)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstPurpose+"';"+
		"objSheet.cells("+(i+2)+",11)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstStat+"';"+
		"objSheet.cells("+(i+2)+",12)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CsLocDesc+"';"+
		"objSheet.cells("+(i+2)+",13)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstECLArriTime+"';"+
		"objSheet.cells("+(i+2)+",14)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstLogOverTime+"';"+
		"objSheet.cells("+(i+2)+",15)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstECLUser+"';"+
		"objSheet.cells("+(i+2)+",16)='"+$HUI.datagrid('#dgCstDetList').getData().rows[i-1].CstECLTime+"';"
	}
	var row1=2,row2=strjLen+2,c1=1,c2=16;
	Str=Str+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;"+
	"objSheet.Columns.AutoFit;"+ 
	"xlsExcel.ActiveWindow.Zoom = 75 ;"+
	"xlsExcel.UserControl = true;"+  	//很重要,不能省略,不然会出问题 意思是excel交由用户控制 
	"xlsExcel=null;"+ 
	"xlsBook=null;"+ 
	"objSheet=null;"+ 
    "return 1;}());";
	//以上为拼接Excel打印代码为字符串
    CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
	return;

}

///导出
function ExpConsListOld(){	
	var xlsExcel = new ActiveXObject("Excel.Application");
 	var xlsBook = xlsExcel.Workbooks.Add() 
	var objSheet = xlsBook.ActiveSheet; 
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue();  /// 开始日期
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();      /// 结束日期
	xlsExcel.Visible = true; 
	xlsExcel.Range(objSheet.Cells(1,1),objSheet.Cells(1,16)).MergeCells = true;
	objSheet.cells(1,1).Font.Bold = true;
	objSheet.cells(1,1).Font.Size =24;
	objSheet.cells(1,1).HorizontalAlignment = -4108;
	objSheet.cells(1,1)="会诊明细统计("+CstStartDate+"至"+CstEndDate+")";
	var strjLen=$HUI.datagrid("#dgCstDetList").getData().rows.length;
	objSheet.cells(2,1)="序号";
	objSheet.cells(2,2)="会诊类型";
	objSheet.cells(2,3)="申请科室";
	objSheet.cells(2,4)="申请医生";
   	objSheet.cells(2,5)="申请日期";
    objSheet.cells(2,6)="申请时间";
    objSheet.cells(2,7)="会诊日期";
    objSheet.cells(2,8)="会诊时间";
    objSheet.cells(2,9)="病例摘要";
	objSheet.cells(2,10)="会诊理由及要求";
    objSheet.cells(2,11)="状态";
    objSheet.cells(2,12)="会诊科室";
    objSheet.cells(2,13)="报到时间";
    objSheet.cells(2,14)="完成时间";
	objSheet.cells(2,15)="确认医生";
	objSheet.cells(2,16)="确认时间";
	for (i=1;i<=strjLen;i++)
     { 	
	    objSheet.cells(i+2,1)=i;
	    objSheet.cells(i+2,2)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstType;
	    objSheet.cells(i+2,3)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstRLoc;
	    objSheet.cells(i+2,4)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstRUser;
	    objSheet.cells(i+2,5)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstRDate;
	    objSheet.cells(i+2,6)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstNTime;
	    objSheet.cells(i+2,7)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstNDate;
	    objSheet.cells(i+2,8)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstNTime;
	    objSheet.cells(i+2,9)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstTrePro;
	    objSheet.cells(i+2,10)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstPurpose;
	    objSheet.cells(i+2,11)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstStat;
	    objSheet.cells(i+2,12)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CsLocDesc;
		objSheet.cells(i+2,13)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstECLArriTime;
		objSheet.cells(i+2,14)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstLogOverTime;
		objSheet.cells(i+2,15)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstECLUser;
		objSheet.cells(i+2,16)=$HUI.datagrid("#dgCstDetList").getData().rows[i-1].CstECLTime;
 	 }
	
	 gridlist(objSheet,2,strjLen+2,1,16)
 	 objSheet.Columns.AutoFit; 
	 xlsExcel.ActiveWindow.Zoom = 75 
	 xlsExcel.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 

	 xlsExcel=null; 
     xlsBook=null; 
     objSheet=null; 

}

function gridlist(objSheet,row1,row2,c1,c2)
{
	var ret="";
	ret=ret+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;";
	ret=ret+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;";
	ret=ret+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;";
	ret=ret+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"
	ret=ret+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;";
	ret=ret+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;";
	ret=ret+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"; 
	ret=ret+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;";
	return ret;
}

function gridlistOld(objSheet,row1,row2,c1,c2)
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

/// 检查项目绑定提示栏
function BindTips(){
	
	var html='<div id="tip" style="border-radius:3px; display:none; border:1px solid #000; padding:10px; margin:5px; position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);
	
	/// 鼠标离开
	$('td[field="CstTrePro"],td[field="CstPurpose"]').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// 鼠标移动
	$('td[field="CstTrePro"],td[field="CstPurpose"]').on({
		'mousemove':function(){
			
			var tleft=(event.clientX + 10);
			if ($(this).text().length <= 20){
				return;
			}
			if ( window.screen.availWidth - tleft < 600){ tleft = tleft - 600;}
			/// tip 提示框位置和内容设定
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				//right:10+'px',
				//bottom:5+'px',
				'z-index' : 9999,
				opacity: 0.8
			}).text($(this).text());
		}
	})
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })