/*
 * @Author: piwenping
 * @Discription: 
 * @Date: 2021-12-28
 */
var GV={
	BaseFlag: true,
	ClassName: "Nur.HISUI.deliveryRegistrationSummary",
	MethodName:"GetDeliveryInfos",
	frozenColumns:[[
		{field:'OpenNurMp',title:'操作',width:100,align:'center','rowspan':2,
			formatter: function(value,row,index){
					var btn = '<a onclick="OpenWindows(\'' + row["Adm"] + '\')">录入模板</a>';
					return btn;
		}
	   },
	   {field:'CareDate',title:'日期',align:'left','rowspan':2,width:100,headalign:'center'},
	   {field:'Item3',title:'姓名',align:'left','rowspan':2,width:100,headalign:'center'},
	   {field:'Item6',title:'住院号',align:'center','rowspan':2,width:100},
	   {field:'Item5',title:'年龄',align:'center','rowspan':2,width:100},
	   {field:'Item72',title:'民族',align:'center','rowspan':2,width:100},
	   {field:'Item73',title:'身份证号',align:'center','rowspan':2,width:180},
	]],
	columns:[[
	   {field:'Adm',title:'就诊号',align:'center',hidden:true,'rowspan':2,width:100},
	   {field:'Item9',title:'职业',align:'left','rowspan':2,width:100,headalign:'center'},
	   {field:'Item10',title:'现在住址',align:'left','rowspan':2,width:200,headalign:'center'},
	   {field:'Item11',title:'户口类型<br />(常、暂、留)',align:'center','rowspan':2,width:100},
	   /*{title:'户口类型',align:'center','colspan':3},*/
	   {field:'Item12',title:'孕次',align:'center','rowspan':2,width:50},
	   {field:'Item13',title:'产次',align:'center','rowspan':2,width:50},
	   {field:'Item14',title:'孕周',align:'center','rowspan':2,width:50},
	   {field:'Item15',title:'破膜<br />(早期、自然、人工)',align:'center','rowspan':2,width:150},
	   /*{title:'破膜',align:'center','colspan':3},*/
	   {field:'Item16',title:'羊水情况',align:'center','rowspan':2,width:50},
	   {field:'Item54',title:'出生时间',align:'center','rowspan':2,width:100},
	   {title:'产程',align:'center','colspan':4},
	   {field:'Item25',title:'胎方位',align:'center','rowspan':2,width:100},
	   {field:'Item26',title:'分娩情况<br />(顺产、吸引产、钳产、剖宫产、其他)',align:'center','rowspan':2,width:250},
	   /*{title:'分娩情况',align:'center','colspan':5},*/
	   {field:'Item27',title:'主要手术指标',align:'left','rowspan':2,width:250},
	   {field:'Item28',title:'孕产期并发(合并)症',align:'left','rowspan':2,width:250},
	   {field:'Item30',title:'会阴情况<br />(切开、完整、裂伤I、裂伤II、裂伤III)',align:'center','rowspan':2,width:250},
	   /*{title:'会阴情况',align:'center','colspan':5},*/
	   {field:'Item31', title:'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;胎盘<br />(自然、人工、完整、残缺、粗糙、其他)',align:'center','rowspan':2,width:270,headalign:'center'},
	   /*{title:'胎盘',align:'center','colspan':6},*/
	   {field:'Item32',title:'产后出血量',align:'center','rowspan':2,width:100},
	   {title:'脐带',align:'center','colspan':3},
	   {title:'新生儿情况',align:'center','colspan':6},
	   {field:'Item42',title:'胎盘去向<br />(医疗废物、自行处理、病检)',align:'center','rowspan':2,width:200},
	    /*{title:'胎盘去向',align:'center','colspan':3},*/
	   {field:'Item43',title:'使用催产素',align:'center','rowspan':2,width:100},
	   {field:'Item44',title:'球囊引产',align:'center','rowspan':2,width:100},
	   {field:'Item45',title:'宫颈裂伤',align:'center','rowspan':2,width:100},
	   {field:'Item46',title:'阴道血肿',align:'center','rowspan':2,width:100},
	   {field:'Item47',title:'药物镇痛',align:'center','rowspan':2,width:100},
	   {field:'Item48',title:'丈夫陪产',align:'center','rowspan':2,width:100},
	   {title:'早接触时间',align:'center','colspan':2},
	   {field:'Item51',title:'保健号',align:'left','rowspan':2,width:170,headalign:'center'},
	   {field:'Item52',title:'接生者',align:'center','rowspan':2,width:100},
	   ],[
	   
	   
	   /*产程*/
	   {field:'Item20',title:'I',align:'center','rowspan':1,width:100},
	   {field:'Item21',title:'II',align:'center','rowspan':1,width:100},
	   {field:'Item22',title:'III',align:'center','rowspan':1,width:100},
	   {field:'Item23',title:'总',align:'center','rowspan':1,width:100},
	   
	   
	   /*脐带*/
	   {field:'Item33',title:'长度',align:'center','rowspan':1,width:50},
	   {field:'Item34',title:'绕颈周数',align:'center','rowspan':1,width:50},
	   {field:'Item69',title:'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;附注',align:'left','rowspan':1,width:250,headalign:'center'},
	   
	   /*新生儿情况*/
	   {field:'Item36',title:'性别',align:'center','rowspan':1,width:50},
	   {field:'Item37',title:'体重',align:'center','rowspan':1,width:50},
	   {field:'Item38',title:'身高',align:'center','rowspan':1,width:50},
	   {field:'Item39',title:'评分1',align:'center','rowspan':1,width:80},
	   {field:'Item40',title:'评分5',align:'center','rowspan':1,width:80},
	   {field:'Item41',title:'插管抢救、死胎、死产<br />新生儿死亡、畸形',align:'center','rowspan':1,width:160},
	   
	   /*早接触时间*/
	   {field:'Item56',title:'开始时间',align:'center','rowspan':1,width:100},
	   {field:'Item57',title:'结束时间',align:'center','rowspan':1,width:100},
	]]
}

$(function () {
	initUI();
});

function initUI() {
	initSearchForm();
	initGrid();
}
function search() {
	$('#tableGrid').datagrid('clearSelections');
	$HUI.datagrid('#tableGrid').load();
}
function initSearchForm() {
	$('#startDate').datebox('setValue', formatDate(new Date(addDays(new Date(), -6))));
	$('#endDate').datebox('setValue', formatDate(new Date()));
	$('#searchBtn').click(search);
	$('#exportBtn').click(exportBtnClick);
}
function initGrid() {
	let frozenColumns = GV.frozenColumns;
	let columns = GV.columns;
	$('#tableGrid').datagrid({
			pagination:true,		     //分页
			pageSize: 25,
			pageList : [25,50,100,200],
			// rownumbers : true,    //序列号
			// autoSizeColumn: false,
			rownumbers:true,
			fit: true,
			url: $NURURL + '?className='+GV.ClassName+'&methodName='+GV.MethodName,
			fitColumns: false,
			nowrap:false,
			singleSelect:true,
			headerCls: 'panel-header-gray',
			frozenColumns:frozenColumns,
			columns:columns,
			onBeforeLoad: function(param) {
				let page = param.page;
				let rows = param.rows;
				param.parameter1 = $('#startDate').datebox('getValue');
				param.parameter2 = $('#endDate').datebox('getValue');
				param.parameter3 = $('#medicareNo').searchbox('getValue');
				param.parameter4=page;
				param.parameter5=rows;
			},
			onDblClickRow:function(rowIndex, rowData){
				OpenWindows(rowData["Adm"]);
			},
			onLoadSuccess:function(data){       
                // $('span.datagrid-sort-icon').hide();//解决表格数据与表头标题居中不对齐
				var fields=$("#tableGrid").datagrid('getColumnFields',false);
				 //datagrid头部 table 的第一个tr 的td们，即columns的集合
				 var panel = $("#tableGrid").datagrid("getPanel");  
				 var headerTds =panel.find(".datagrid-view2 .datagrid-header .datagrid-header-inner table tr:first-child").children();
			 
				 //重新设置列表头的对齐方式
				 headerTds.each(function (i, obj) {
					 var col = $("#tableGrid").datagrid('getColumnOption',fields[i]);
					 if (!col.hidden && !col.checkbox)
					 {
						 var headalign=col.headalign||col.align||'left';
						 $("div:first-child", obj).css("text-align", headalign);
					 }
				 })
			}
		});
}
function exportBtnClick(){
	let dateStr = $('#startDate').datebox('getValue') + "_" + $('#endDate').datebox('getValue');
	let frozenColumns = GV.frozenColumns
	let columns = GV.columns
	let headStr = "<tbody>";
	headStr += "<tr>";
	frozenColumns[0].forEach(function(frozenColumn){
		if ((frozenColumn.title)&&(frozenColumn.title !== "操作")) {
			//{field:'CareDate',title:'日期',align:'left','rowspan':2,width:100,headalign: 'center'},
			headStr += "<th style='word-break: keep-all;word-wrap:break-word;'"
			if (frozenColumn.rowspan) headStr += " rowspan='" + frozenColumn.rowspan + "'";
			if (frozenColumn.headalign) headStr += " align='" + frozenColumn.headalign +"'";
			headStr += ">" + frozenColumn.title.replace("<br />","") + "</th>";
		}
	})
	columns[0].forEach(function(column){
		//{field:'Item4',title:'现在住址',align:'left','rowspan':2,width:200,headalign:'center'},
	    //{title:'户口类型',align:'center','colspan':3},
			if (!column.hidden){
				if (column.title) {
					headStr += "<th style='word-break: keep-all;word-wrap:break-word;'"
					if (column.rowspan) headStr += " rowspan='" + column.rowspan + "'";
					if (column.colspan) headStr += " colspan='" + column.colspan + "'";
					if (column.headalign) headStr += " align='" + column.headalign +"'";
						headStr += ">" + column.title.replace("<br />","") + "</th>";
				}
			}
	})
	headStr += "</tr>";
	headStr += "<tr>";
	let num = 0
	columns[0].forEach(function(column){
			if (!column.hidden){
				if (!column.field) {
					for (let i=0;i<column.colspan;i++){
						var twoColumn = columns[1][num + i]
						if (twoColumn.title) {
							headStr += "<th style='word-break: keep-all;word-wrap:break-word;'"
							if (twoColumn.headalign) headStr += " align='" + twoColumn.headalign +"'";
								headStr += ">" + twoColumn.title.replace("<br />","") + "</th>";
						}
					}
					num = num + column.colspan;
				}
			}
	})
	headStr += "</tr>";
	headStr += "</tbody>";
	
	let data = $('#tableGrid').datagrid('getData');
	let rows = data.rows;
	
	if(rows.length>0){
		let rowStr="<tbody>";
		rows.forEach(function(row){
			num = 0;
			rowStr += '<tr>';
			frozenColumns[0].forEach(function(frozenColumn){
				if ((frozenColumn.title)&&(frozenColumn.title !== "操作"))  {
					rowStr += "<th style='word-break: keep-all;word-wrap:break-word;'"
					if (frozenColumn.align) rowStr += " align='" + frozenColumn.align +"'";
					rowStr += ">" + row[frozenColumn.field] + "</th>";
				}
			})
			columns[0].forEach(function(column){
				if (!column.hidden){
					if (!column.field) {
						for (let i=0;i<column.colspan;i++){
							var twoColumn = columns[1][num + i]
							if (twoColumn.title) {
								rowStr += "<th style='word-break: keep-all;word-wrap:break-word;'"
								if (twoColumn.headalign) rowStr += " align='" + twoColumn.headalign +"'";
									rowStr += ">" + row[twoColumn.field] + "</th>";
							}
						}
						num = num + column.colspan;
					}else{
						rowStr += "<th style='word-break: keep-all;word-wrap:break-word;'"
						if (column.align) rowStr += " align='" + column.align +"'";
						rowStr += ">" + row[column.field] + "</th>";
					}
				}
			})
			rowStr += '</tr>';
		});
		rowStr=rowStr+"</tbody>";
		
		let strHTML = '<table style="border: 1px solid black; border-image: none; border-collapse: collapse;" border="1">';
		strHTML += headStr;
		strHTML += rowStr;
		strHTML += "</table>";
		var LODOP=getLodop();
		LODOP.PRINT_INITA("0", "0", "264mm", "460mm", "分娩登记大本汇总");
		LODOP.ADD_PRINT_TABLE("0","0","264mm","460mm",strHTML);
		LODOP.SET_PRINT_STYLEA(0,"TableHeightScope",1);
		//LODOP.PREVIEW();
		if (LODOP.CVERSION) {
			LODOP.On_Return=function(TaskID,Value){if(Value) alert("导出成功！");};
			LODOP.SAVE_TO_FILE(dateStr + "分娩登记大本汇总.xlsx");
		} else if (LODOP.SAVE_TO_FILE(dateStr + "分娩登记大本汇总.xlsx")) alert("导出成功！");		 
	}
}

function addDays(dateObj, numDays) { 
		dateObj.setDate(dateObj.getDate() + numDays); 
		return dateObj; 
}

function OpenWindows(Adm){
	let csp = 'nur.emr.DHCNURFMDE.csp';
	let URL="../csp/"+csp+"?EpisodeID="+Adm+"&AuthorityFlag="
	websys_createWindow(URL,"评估","width=65%,height=89%");
}

function GetLogAuxiliaryInfo() {
    let logAuxiliaryInfo = {};
    logAuxiliaryInfo["LOGON.CTLOCID"] = session['LOGON.CTLOCID'];
    logAuxiliaryInfo["LOGON.WARDID"] = session['LOGON.WARDID'];
    logAuxiliaryInfo["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
    logAuxiliaryInfo["LOGON.USERID"] = session['LOGON.USERID'];
    logAuxiliaryInfo["LOGON.SSUSERLOGINID"] = session['LOGON.SSUSERLOGINID'];
    logAuxiliaryInfo["SubjectionTemplateGuid"] = $HUI.combobox('#Template').getValue();

    return JSON.stringify(logAuxiliaryInfo);
}
