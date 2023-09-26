var PageLogicObj={
	m_LocListTabDataGrid:"",
	m_selDocListTabDataGrid:"",
	m_DocListTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	$(".panel-center .panel:not(:last-child)").css('height',$(window).height()-110)
	$(".panel-center .panel").css('width',($(window).width()-40)/3);
	$(".panel-center .panel:not(:last-child) .panel-body").css('height',$(window).height()-145);
	$(".panel-center .panel .panel-body").css('width',($(window).width()-40)/3);
	$(".panel-center .panel .panel-header").css('width',($(window).width()-70)/3);
});
function InitEvent(){
	$("#BCreateSchedule").click(CreateScheduleClick);
}
function PageHandle(){
	defineStartDate();
}
function Init(){
	PageLogicObj.m_LocListTabDataGrid=InitLocListTabDataGrid();
}
function InitLocListTabDataGrid(){
	var toolbar=[{
		iconCls: 'icon-apply-check',
		text:'查询所有科室',
		handler: function(){AllDepClick();}
	},'-',{
		iconCls: 'icon-add',
		text:'增加科室',
		handler: function(){AddLocClick();}
	}]

	var Columns=[[ 
		{field:'LocDesc',title:'科室名称',width:400}
    ]]
	var LocListTabDataGrid=$("#LocListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : true,
		autoRowHeight : false,
		pagination : false,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'LocId',
		columns :Columns,
		toolbar:toolbar,
		onDblClickRow:function(index, row){
			$(this).datagrid('unselectAll').datagrid('selectRow',index);
			LocListDblClick(row);
		}
	});
	return LocListTabDataGrid;
}
function AllDepClick(){
	/*ClearTableData('LocListTab');
	$.cm({
		ClassName:"web.DHCCPSchedBatch",
		MethodName:"GetLocList",
		dataType:'text'
	},function(DeptStr){
		for (var i=0;i<DeptStr.split("^").length;i++){
			var LocId=DeptStr.split("^")[i].split(",")[0];
			var LocDesc=DeptStr.split("^")[i].split(",")[1];
			PageLogicObj.m_LocListTabDataGrid.datagrid('appendRow',{
				LocId: LocId,
				LocDesc: LocDesc
			});
		}
	})*/
	$.q({
	    ClassName : "web.DHCCPSchedBatch",
	    QueryName : "GetLocListNew",
	    Pagerows:PageLogicObj.m_LocListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_LocListTabDataGrid.datagrid('loadData',GridData);
	});
}
//双击科室
function LocListDblClick(row){
	if (PageLogicObj.m_DocListTabDataGrid==""){
		PageLogicObj.m_DocListTabDataGrid=InitDocListTabDataGrid();
	}else{
		ClearTableData("DocListTab");
	}
	if ($("#FindDoc").checkbox('getValue')){
		$.q({
		    ClassName : "web.DHCCPSchedBatch",
		    QueryName : "GetDocListNew",
		    LocRowid:row['LocId'],
		    Pagerows:PageLogicObj.m_DocListTabDataGrid.datagrid("options").pageSize,rows:99999
		},function(GridData){
			PageLogicObj.m_DocListTabDataGrid.datagrid('loadData',GridData);
		});
		/*$.cm({
			ClassName:"web.DHCCPSchedBatch",
			MethodName:"GetDocList",
			LocRowid:row['LocId'],
			dataType:'text'
		},function(DocStr){
			for (var i=0;i<DocStr.split("^").length;i++){
				var DocId=DocStr.split("^")[i].split(",")[0];
				var DocDesc=DocStr.split("^")[i].split(",")[1];
				PageLogicObj.m_DocListTabDataGrid.datagrid('appendRow',{
					DocId: DocId,
					DocDesc: DocDesc
				});
			}
		})*/
	}else{
		$.cm({
			ClassName:"web.DHCCPSchedBatch",
			MethodName:"SendBatchDocMsg",
			Loc:row['LocId'],
			dataType:'text'
		},function(DocStr){
			for (var i=0;i<DocStr.split("\001").length;i++){
				var DocId=DocStr.split("\001")[i].split("^")[0];
				var DocDesc=DocStr.split("\001")[i].split("^")[1];
				PageLogicObj.m_DocListTabDataGrid.datagrid('appendRow',{
					DocId: DocId,
					DocDesc: DocDesc
				});
			}
		})
	}
}
function AddLocClick(){
	if (PageLogicObj.m_selDocListTabDataGrid==""){
		PageLogicObj.m_selDocListTabDataGrid=InitelDocListTabDataGrid();
	}
	var rows=PageLogicObj.m_LocListTabDataGrid.datagrid('getSelections');
	for (var i=0;i<rows.length;i++){
		if (CheckRepeat(rows[i]['LocId'])){
			$.messager.alert("提示",rows[i]['LocDesc']+ "已添加!");
			return false
		}
		PageLogicObj.m_selDocListTabDataGrid.datagrid('appendRow',{
			Id: rows[i]['LocId'],
			Desc: rows[i]['LocDesc']
		});
	}
	PageLogicObj.m_LocListTabDataGrid.datagrid('uncheckAll');
}
function CheckRepeat(id){
	var rows=PageLogicObj.m_selDocListTabDataGrid.datagrid('getRows');
	for (var k=0;k<rows.length;k++){
		if (rows[k]['Id']==id){
			return true;
		}
	}
	return false;
}
function InitelDocListTabDataGrid(){
	var toolbar=[{
		iconCls: 'icon-clear-screen',
		text:'清空本次生成排班列表',
		handler: function(){ClearTableData('selDocListTab');}
	}]
	var Columns=[[ 
		{field:'Desc',title:'已选科室/医生',width:400}
    ]]
	var selDocListTabDataGrid=$("#selDocListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : true,
		autoRowHeight : false,
		pagination : false,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'Id',
		columns :Columns,
		toolbar:toolbar,
		onDblClickRow:function(index, row){
			$(this).datagrid('deleteRow',index);
		}
	});
	return selDocListTabDataGrid;
}
function InitDocListTabDataGrid(){
	var toolbar=[{
		iconCls: 'icon-add',
		text:'增加医生',
		handler: function(){AddDocClick();}
	}]

	var Columns=[[ 
		{field:'DocDesc',title:'医生',width:400}
    ]]
	var DocListTabDataGrid=$("#DocListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : true,
		autoRowHeight : false,
		pagination : false,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'DocId',
		columns :Columns,
		toolbar:toolbar,
		onDblClickRow:function(index, row){
		}
	});
	return DocListTabDataGrid;
}
function AddDocClick(){
	var row=PageLogicObj.m_LocListTabDataGrid.datagrid('getSelected');
	var LocDesc=row['LocDesc'];
	if (PageLogicObj.m_selDocListTabDataGrid==""){
		PageLogicObj.m_selDocListTabDataGrid=InitelDocListTabDataGrid();
	}
	var rows=PageLogicObj.m_DocListTabDataGrid.datagrid('getSelections');
	for (var i=0;i<rows.length;i++){
		var Id=rows[i]['DocId'];
		var Desc=LocDesc+"|"+rows[i]['DocDesc'];
		if (CheckRepeat(Id)){
			$.messager.alert("提示",rows[i]['DocDesc']+ "已添加!");
			return false
		}
		PageLogicObj.m_selDocListTabDataGrid.datagrid('appendRow',{
			Id: Id,
			Desc: Desc
		});
	}
	PageLogicObj.m_DocListTabDataGrid.datagrid('uncheckAll');
}
function ClearTableData(id){
	var Data=$("#"+id).datagrid("getData");
	for (var i=Data["rows"].length-1;i>=0;i--){
		$("#"+id).datagrid('deleteRow',i);
	} 
}
function CreateScheduleClick(){
	var StartDate=$("#StartDate").datebox('getValue');
	if (StartDate==""){
		$.messager.alert("提示","请输入开始日期!","info",function(){
			$("#StartDate").next('span').find('input').focus();
		});
		return false;
	}
	var EndDate=$("#EndDate").datebox('getValue');
	if (EndDate==""){
		$.messager.alert("提示","请输入结束日期!","info",function(){
			$("#EndDate").next('span').find('input').focus();
		});
		return false;
	}
	if (!CompareDate(StartDate,EndDate)){
		$.messager.alert("提示","请输入有效的时间");
		return false;
	}
	var DateFiffDays=DateDiff(StartDate,EndDate);
	if (parseInt(DateFiffDays)>180){
		$.messager.confirm('确认对话框', '生成的排班记录超过180天,是否继续?', function(r){
			if (r){
			    Create();
			}
		});
	}else{
		Create();
	}
	function Create(){
		var schstr="";
		if (PageLogicObj.m_selDocListTabDataGrid!=""){
			var rows=PageLogicObj.m_selDocListTabDataGrid.datagrid('getRows');
			for (var i=0;i<rows.length;i++){
				var id=rows[i]['Id'];
				if(schstr==""){
					schstr=id;
				}else{
					schstr=schstr+"^"+id;
				}
			}
		}
		$.messager.confirm('确认对话框', '是否要生成全部排班记录?', function(r){
			if (r){
			    $.cm({
					ClassName:"web.DHCCPSchedBatch",
					MethodName:"GeneSched",
					StartDate:StartDate,
					EndDate:EndDate, Mode:0, SchStr:schstr,
					weekflag:"", ASSESSRowIdStr:"",
					dataType:'text'
				},function(DocStr){
					if (DocStr==""){
						$.messager.alert("提示","没有需要生成的排班记录.(没有维护排班记录或该医生已生成排班)");
						return false;
					}else{
						if (DocStr.split("^")[0]=="-1"){
							$.messager.alert("提示",DocStr)
							return false;
						}
					}
					AddItemToLocList(DocStr);
					if (PageLogicObj.m_DocListTabDataGrid!=""){
						ClearTableData('DocListTab');
					}
					if (PageLogicObj.m_selDocListTabDataGrid!=""){
						ClearTableData('selDocListTab');
					}
				})
			}
		});
	}
}
function AddItemToLocList(DocStr){
	ClearTableData('LocListTab');
	for (var i=0;i<DocStr.split("\001").length;i++){
		var LocId=DocStr.split("\001")[i].split("^")[0];
		var LocDesc=DocStr.split("\001")[i].split("^")[1];
		PageLogicObj.m_LocListTabDataGrid.datagrid('appendRow',{
			LocId: LocId,
			LocDesc: LocDesc
		});
	}
}
function defineStartDate(){
	$.cm({
		ClassName:"web.DHCOPRegTime",
		MethodName:"GetdefineStartDate",
		UserID:"",
		dataType:'text'
	},function(defineStartDate){
		$("#StartDate").datebox('setValue',defineStartDate);
	})
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
//计算两个日期天数差的函数，通用
function DateDiff(sDate1, sDate2) {  //sDate1和sDate2是yyyy-MM-dd格式
    var aDate, oDate1, oDate2, iDays;
    if (ServerObj.sysDateFormat=="3"){
	    aDate = sDate1.split("-");
    	oDate1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);  //转换为yyyy-MM-dd格式
    	aDate = sDate2.split("-");
    	oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);
	}else{
		aDate = sDate1.split("/"); // 12/02/2018
    	oDate1 = new Date(aDate[2] + '-' + aDate[1] + '-' + aDate[0]);  //转换为yyyy-MM-dd格式
    	aDate = sDate2.split("/");
    	oDate2 = new Date(aDate[2] + '-' + aDate[1] + '-' + aDate[0]);
	}
    iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 / 24); //把相差的毫秒数转换为天数
    return iDays;  //返回相差天数
}