PageLogicObj={
	CureReportListDataGrid:""	
}
$(function(){
	Init();
	InitEvent();
	PageHandle();
});

function Init()
{
	var HospIdTdWidth=$("#HospIdTd").width()
	var opt={width:HospIdTdWidth}
	var hospComp = GenUserHospComp(opt);
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		PageHandle();
		SearchAppClick();
	}
}

function InitEvent(){
	$('#btnFind').click(function(){
		SearchAppClick();
	});
	$('#btnClear').click(function(){
		clear_click();
	});
	$("#StartDate").datebox({
		onChange:function(newValue, oldValue){
			//SearchAppClick();
			PageLogicObj.CureReportListDataGrid=InitScheduleList();	
		}
	}).datebox('setValue',ServerObj.CurrentDate);	

	
	$('#btnExport').click(function(){
		if(typeof appoint_ResListObj != "undefined"){
			appoint_ResListObj.ExportAppointListData();
			return true;
		}else{
				
		}	
	})
	$HUI.checkbox("#QryAllFlag",{
		onCheckChange:function(e,value){
			if(typeof appoint_ResListObj != "undefined"){
				appoint_ResListObj.CureAppointListDataGridLoad();
			}else{
			}
		}
	})
}
function PageHandle(){
	workReport_InitItem.InitCureLoc(session['LOGON.CTLOCID'],SearchAppClick);
	workReport_InitItem.InitCureDoc();
	clear_click();
}

function clear_click(){
	$('.search-table input[class*="hisui-validatebox"]').val("");
	$("#StartDate").datebox("setValue",ServerObj.CurrentDate);
	$('#Combo_CureLoc,#Combo_CureDoc').combobox('setValue',"");
    $HUI.radio('#Chk_ShowByTR').setValue(false);
    $HUI.radio('#Chk_ShowPatInList').setValue(false);
    setTimeout(function(){
	    SetLogLocID();
    },100);
    function SetLogLocID(){
		var m_LogLocID=session['LOGON.CTLOCID'];
		var data=$("#Combo_CureLoc").combobox("getData");
		for(var i=0;i<data.length;i++){
	    	if(data[i].LocRowID==m_LogLocID){
		    	$("#Combo_CureLoc").combobox("select",m_LogLocID);
		    }
	    }
	    $("#Combo_CureDoc").combobox("select","");
	}
}

function SearchAppClick(){
	if(PageLogicObj.CureReportListDataGrid==""){
		PageLogicObj.CureReportListDataGrid=InitScheduleList();	
	}else{
		RefreshDataGrid();
	}
}

function InitScheduleList(StartDate){
	var StartDate=$("#StartDate").datebox("getValue"); 
	if(StartDate=="")return;
	var weekObj={field:'',title:'',align:'center',width:100,resizable:true,
		styler: function(value,row,index){
			var style='cursor:pointer;';
			if(value) {
				var ASStatusCode=value.split('^')[5];
				var Number=value.split('^')[0];
				if(ASStatusCode=="S"){
					style='background-color:#CCC;';
				}
				else if(Number!='') {
					var AppedLeftNumber=Number.split("/")[0];
					if(AppedLeftNumber=="0"){style +='background-color:#f64c60;'}
				}
				return style;
			}
		},
		formatter:function(value,row,index){
			if(value) {
				var mValue=value.split('^')[0];
				var AppedNumber=value.split('^')[1];
				var ASRowid=value.split('^')[2];
				var PatAppInfo=value.split('^')[6];
				var TimeRangeInfo="";
				var AppedNumber=Number(AppedNumber);
				if ((AppedNumber == 0 ||typeof AppedNumber != 'number' || isNaN(AppedNumber))) {
					var formatValuel="<span>"+mValue+"</span>";
				}else {
					var RowId=row.RowId;
					var TRFlag=RowId.split("^")[5];
					if(TRFlag=="Y") {
						TimeRangeInfo=row.TimeRangeDesc;
					}
					var formatValuel="<span>"+mValue+"</span>"+"&nbsp;&nbsp;&nbsp;"+"<a href='#' title='预约列表'  onclick='appoint_ResListObj.ShowAppointList(\""+ASRowid+"\"\,\""+TimeRangeInfo+"\")'>"+"<span class='fillspan-nosave'>"+AppedNumber+"</span>"+"</a>"
					
				}
				if(PatAppInfo!=""){
					formatValuel=formatValuel+PatAppInfo;
				}
				return formatValuel;
			}
		}
	};
	var ListColumnsArray=[];
    
	var AdmDateStr=tkMakeServerCall("DHCDoc.DHCDocCure.RBCResSchdule","GetAdmDateStr",StartDate,"","Y","doccure.cureapplist.hui.csp")
	var AdmDateStrArr=AdmDateStr.split("^")
	for(var i=0;i<AdmDateStrArr.length;i++){
		var admDate=AdmDateStrArr[i].split(String.fromCharCode(1))[0];
		var m_i=i+1;
		ListColumnsArray.push($.extend({},weekObj,{field:'admDate'+m_i,title:admDate}))
	}
	ListColumnsArray.push({field:'ServiceGroupDesc',title:'服务组',align:'center',width:90})
	var ListColumns=[ListColumnsArray];
    var ScheduleTemplateListDataGrid=$("#tabCureReportList").datagrid({
		fit : true,
		border:false,
		width : 'auto',
		autoRowHeight : true,
		striped : false,
		singleSelect : true,
		fitColumns : true, 
		nowrap:true,
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.WordReport&QueryName=FindScheduleApp",
		loadMsg : '加载中..',
		pagination : true, 
		rownumbers : false, 
		idField:"RowId",
		pageSize:20,
		pageList : [20,50,100],
		frozenColumns : [[
			{field:'ResourceDesc',title:'资源',align:'left',width:180},
			//{field:'ServiceGroupDesc',title:'服务组',align:'center',width:90},
			{field:'TimeDesc',title:'时段',align:'left',width:80},
			{field:'TimeRangeDesc',title:'时间',align:'left',width:90,
				styler: function(value,row,index){
					var RowId=row.RowId;
					var TRFlag=RowId.split("^")[5];
					if(TRFlag=="Y") {
						var style = 'background-color:#66CDAA;'
						return style;
					}
				}
			},
			{field:'RowId',hidden:true},
			{field:'LocRowid',hidden:true},
			{field:'DocRowid',hidden:true},
			{field:'ServiceGroupID',hidden:true},
			{field:'TimeRangeID',hidden:true}
		]],
		columns :ListColumns,
		onBeforeLoad:function(param){
			var AppStartDate=StartDate;
			var AppEndDate=StartDate;
			var CureLocID=$('#Combo_CureLoc').combobox('getValue');
			var CureDocID=$('#Combo_CureDoc').combobox('getValue');
			var SessionStr=session['LOGON.HOSPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.USERID']+"^"+session['LOGON.LANGID'];
			var SearchExpStr=CureLocID+"^"+CureDocID+"^^Y";
			var Chk_ShowByTR=$HUI.checkbox('#Chk_ShowByTR').getValue()?"Y":"N";
    		var Chk_ShowPatInList=$HUI.checkbox('#Chk_ShowPatInList').getValue()?"Y":"N";
    		$.extend(param,{StartDate:AppStartDate,EndDate:AppEndDate,
    		ShowByTR:Chk_ShowByTR,ShowPatInList:Chk_ShowPatInList,
			SessionStr:SessionStr,SearchExpStr:SearchExpStr});
			$HUI.datagrid(this).unselectAll();
		},
		onLoadSuccess:function(data){
			MergeCell(data,0,data.rows.length-1,"ResourceDesc");
		},
		onClickCell:function(rowIndex, field, value){
		}
	});
	return ScheduleTemplateListDataGrid;	
}

function MergeCell(Data,StartIndex,EndIndex,Field){
	if(StartIndex==EndIndex) return;
	var InfoObj={Index:StartIndex,Rows:1,Value:""};
	for(var i=StartIndex;i<=EndIndex;i++){
		var cmd="var value=Data.rows[i]."+Field;
		eval(cmd);
		if(i==StartIndex){
			InfoObj.Value=value;
			continue;
		}
		if((InfoObj.Value==value)&&(EndIndex!=i)){
			InfoObj.Rows+=1;
		}else{
			if((EndIndex==i)&&(InfoObj.Value==value)) InfoObj.Rows+=1;
			if(InfoObj.Rows>1){
				$('#tabCureReportList').datagrid('mergeCells',{
					index:InfoObj.Index,
					field:Field,
					rowspan:InfoObj.Rows
				});
				if(Field=="ResourceDesc"){
					MergeCell(Data,InfoObj.Index,InfoObj.Index+InfoObj.Rows-1,'ServiceGroupDesc');
					MergeCell(Data,InfoObj.Index,InfoObj.Index+InfoObj.Rows-1,'TimeDesc');
				}
			}	
			InfoObj={Index:i,Rows:1,Value:value};
		}
	}
}

function RefreshDataGrid(){
	PageLogicObj.CureReportListDataGrid.datagrid("reload");
}