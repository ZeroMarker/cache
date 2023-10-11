var PageLogicObj={
	m_StatisticsAppRegNumberGrid:"",
	m_deptRowId:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//表格数据初始化
	//LoadStatisticsAppRegNumber()
	//StatisticsAppRegNumberGridLoad();
});
function Init(){
	InitTimeRange();
	InitLoc();
	$HUI.datebox("#StartDate").setValue(ServerObj.CurrDate);
	$HUI.datebox("#EndDate").setValue(ServerObj.CurrDate);
	$HUI.checkbox("#Aviable").setValue(true);
	$HUI.checkbox("#Calforloc").setValue(true);
}
function InitLoc(){
	$("#Combo_Loc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'Hidden', 
        textField:'Desc',
        columns:[[  
            {field:'Hidden',title:'',hidden:true},
			{field:'Desc',title:'科室名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCRBResSession',QueryName: 'FindLoc'},
        onBeforeLoad:function(param){
	        var desc=param['q']; 
	        if ($("#Combo_Loc").lookup('getText')=="") {
		        PageLogicObj.m_deptRowId="";
		    }
		    param = $.extend(param,{Loc:desc, UserID:session['LOGON.USERID'],HospitalDr:""});
        },
        onChange:function(newValue,oldValue){
				if ($("#Combo_Loc").lookup('getText')=="") {
			        PageLogicObj.m_deptRowId="";
			    }
				},
	    onSelect:function(index, rec){
		    setTimeout(function(){
				PageLogicObj.m_deptRowId=rec["Hidden"];
			});
		}
    });
}
function InitTimeRange(){
	$.q({
		ClassName:"web.DHCApptScheduleNew",
		QueryName:"LookUpTimeRange",
		date:"",
		HospId:session['LOGON.HOSPID']
	},function(Data){
		var cbox = $HUI.combobox("#Combo_TimeRange", {
				valueField: 'RowId',
				textField: 'Desc', 
				editable:true,
				data: Data['rows'],
				filter: function(q, row){
					if (q=="") return true; 
					q=q.toUpperCase();
					if ((row["Code"].toUpperCase().indexOf(q)>=0)||(row["Alias"].toUpperCase().indexOf(q)>=0)||(row["Desc"].toUpperCase().indexOf(q)>=0)) return true;
				},onLoadSuccess: function () {
					LoadStatisticsAppRegNumber();
				}
		 });
	});
}

function InitEvent(){
	PageLogicObj.m_StatisticsAppRegNumberGrid=StatisticsAppRegNumberTreeGrid()
	$("#BFind").click(LoadStatisticsAppRegNumber)
}
function StatisticsAppRegNumberTreeGrid(){
	var ToolBar = [{
        text: '导出',
        iconCls: 'icon-stop-order',
        handler: function() {
            ExpStatistics();
        }
    }];
    var StatisticsAppRegNumber=[[
    	{field:'id',title:'id',width:100,hidden:true}, 
    	{field:'TDate',title:'出诊日期',width:100},
    	{field:'TTimeRange',title:'时段',width:100},
    	{field:'LocDesc',title:'科室',width:100},
    	{field:'DocDesc',title:'号别',width:100},
    	{field:'RBASStatusdesc',title:'状态',width:100},
    	{field:'TStatisticsReg',title:'挂号数',width:100,sortable:true, sorter:mySort},  
    	{field:'TStatisticsApp',title:'剩号数',width:100,sortable:true, sorter:mySort},
    	{field:'TStatisticsArrive',title:'已就诊数',width:100,sortable:true, sorter:mySort},
    	{field:'TStatisticsUnArrive',title:'未就诊数',width:100,sortable:true, sorter:mySort},
        //{field:'RBASStatusdesc',title:'所属父级',width:100,hidden:true},
    ]];
	var StatisticsAppRegNumberTreeGrid=$('#tabStatisticsAppRegNumber').datagrid({    
	    idField:'id',    
	    //treeField:'LocDesc',    
        fit:true,               //网格自动撑满
        fitColumns:true, 
        toolbar :ToolBar, 
        remoteSort:false,  
        pagination:true,
        pageSize: 15,
		pageList : [15,50,200],
	    columns:StatisticsAppRegNumber,
	    singleSelect:true,
	    onClickRow:function (row){
		    return false;
		    },
	    onSelect :function (rowIndex, rowData){

		    }
	    ,onLoadSuccess: function () {
            /*PageLogicObj.m_StatisticsAppRegNumberGrid.treegrid("collapseAll");//默认加载完成后 全部折叠
            $("span.tree-icon").removeClass("tree-folder");
            $("span.tree-icon").removeClass("tree-file");//去掉tree前面的图标*/
        }
	});
	return StatisticsAppRegNumberTreeGrid;  
	}
function LoadStatisticsAppRegNumber(){
	var startdate=$HUI.datebox("#StartDate").getValue();
	var enddate=$HUI.datebox("#EndDate").getValue();
	var timerange=$('#Combo_TimeRange').combobox('getValue');
	if (PageLogicObj.m_deptRowId!=""){
		if ($("#Combo_Loc").lookup('getText')==""){
			PageLogicObj.m_deptRowId=""
			}
	}
	var LocID=PageLogicObj.m_deptRowId
	var AviableFlag="",CalforlocFlag="";
	var Aviable=$("#Aviable").prop("checked");
	if(Aviable)AviableFlag="Y"
	var Calforloc=$("#Calforloc").prop("checked");
	if(Calforloc)CalforlocFlag="Y"
	$.q({
	    ClassName : "web.DHCStatisticsAppRegNumber",
	    QueryName : "StatisticsAppRegNumber",
	    StartDate:startdate,
	    EndDate:enddate, TimeRangeID:timerange, 
	    LocID:LocID,  ExaborID:"",Aviable:AviableFlag,Calforloc:CalforlocFlag,
	    Pagerows:PageLogicObj.m_StatisticsAppRegNumberGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_StatisticsAppRegNumberGrid.datagrid('unselectAll');
		PageLogicObj.m_StatisticsAppRegNumberGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
	}
function ExpStatistics(){
	var startdate=$HUI.datebox("#StartDate").getValue();
	var enddate=$HUI.datebox("#EndDate").getValue();
	var timerange=$('#Combo_TimeRange').combobox('getValue');
	var LocID=PageLogicObj.m_deptRowId
	var AviableFlag="",CalforlocFlag="";
	var Aviable=$("#Aviable").prop("checked");
	if(Aviable)AviableFlag="Y"
	var Calforloc=$("#Calforloc").prop("checked");
	if(Calforloc)CalforlocFlag="Y"
	$.cm({
		 localDir:"Self",
	     ExcelName:"出诊看诊数量实时汇总",
	     ResultSetType:"ExcelPlugin",
	     ClassName : "web.DHCStatisticsAppRegNumber",
	     QueryName : "StatisticsAppRegNumber",
	     StartDate:startdate,
		 EndDate:enddate, TimeRangeID:timerange, 
		 LocID:LocID,  ExaborID:"",Aviable:AviableFlag,Calforloc:CalforlocFlag,
		 rows:99999
	 },false);
	/*$.q({
	    ClassName : "web.DHCStatisticsAppRegNumber",
	    QueryName : "StatisticsAppRegNumber",
	    StartDate:startdate,
	    EndDate:enddate, TimeRangeID:timerange, 
	    LocID:LocID,  ExaborID:"",Aviable:AviableFlag,Calforloc:CalforlocFlag,
	    Pagerows:PageLogicObj.m_StatisticsAppRegNumberGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		try
		{
			var xlApp=new ActiveXObject("Excel.Application");
		}
		catch (e)
		{
			alert("必须安装excel，同时浏览器允许执行ActiveX控件");
			return "";
		}
		xlApp.Visible=false;
		xlApp.DisplayAlerts = false;
		var xlBook=xlApp.Workbooks.Add();
		var xlSheet=xlBook.Worksheets(1);	
		xlSheet.Cells(1, 1).value = "出诊日期 ";
		xlSheet.Cells(1, 2).value = "时段";
		xlSheet.Cells(1, 3).value = "科室";
		xlSheet.Cells(1, 4).value = "号别";
		xlSheet.Cells(1, 5).value = "状态";
		xlSheet.Cells(1, 6).value = "挂号数";
		xlSheet.Cells(1, 7).value = "剩号数";
		xlSheet.Cells(1, 8).value = "已就诊数";
		xlSheet.Cells(1, 9).value = "未就诊数";
		var rows=GridData.rows
		 for (var i = 0; i < rows.length; i++) {
			 var datet=rows[i].TDate
			 var Datestr=rows[i].TDate
			 if (Datestr.indexOf("/")>=0){
				 var DatestrAr=Datestr.split("/")
				 var datet=DatestrAr[2]+"/"+DatestrAr[1]+"/"+DatestrAr[0]
			 }
			 xlSheet.Cells(2+i, 1).value =datet
			 xlSheet.Cells(2+i, 2).value =rows[i].TTimeRange
			 xlSheet.Cells(2+i, 3).value =rows[i].LocDesc
			 xlSheet.Cells(2+i, 4).value =rows[i].DocDesc
			 xlSheet.Cells(2+i, 5).value =rows[i].RBASStatusdesc
			 xlSheet.Cells(2+i, 6).value =rows[i].TStatisticsReg
			 xlSheet.Cells(2+i, 7).value =rows[i].TStatisticsApp
			 xlSheet.Cells(2+i, 8).value =rows[i].TStatisticsArrive
			 xlSheet.Cells(2+i, 9).value =rows[i].TStatisticsUnArrive
		 		 }
		try
		{
			var fileName = xlApp.Application.GetSaveAsFilename("*.xls", "Excel Spreadsheets (*.xls), *.xls");
	 		var ss = xlBook.SaveAs(fileName);  
		 	if (ss==false)
			{
				Msg.info('error','另存失败！') ;
			}		
		}
		catch(e){
			 Msg.info('error','另存失败！') ;
		}


		xlSheet=null;
	    xlBook.Close (savechanges=false);
	    xlBook=null;
	    xlApp.Quit();
	    xlApp=null;
	});*/
}
function StatisticsAppRegNumberGridLoad(){}
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
//自定义排序,解决百分数的排序不准确问题
function mySort(a,b) {

		a = parseFloat(a);
		b = parseFloat(b);
		return (a>b?1:-1);
}
