var PageLogicObj={
	CureItemScheduleDataGrid:"",
	m_DDCISRowid:"",
	m_ItemRowid:"",
	m_TalStartDate:"",
	m_ScheduleTabIndex:0,
	m_SchduleDataGridLoadTimer:""
}
$(document).ready(function(){ 
	Init();
	InitEvent();
	InitDate();
});

function InitEvent(){
	$('#btnSearchApp').click(LoadCureItemScheduleData);
}

function InitDate(){
    var CurDay=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Common",
		MethodName:"DateLogicalToHtml",
		'h':"",
		dataType:"text"   
	},false);
	
    $("#Apply_StartDate").datebox({
		onChange:function(newValue, oldValue){
			SearchAppClick();
		}
	}).datebox('setValue',CurDay);	
}

function Init(){
	//初始化左侧树 
	InitCureItemTree("");
	//InitScheduleTab("");
}

function InitCureItemTree(url){
	var para="^^^^"+session['LOGON.HOSPID']+"^^Y^N";
	if(url=="")url="doccure.config.data.csp?action=cure&para="+encodeURIComponent(para);
	var tbox=$HUI.tree("#CureItemTree",{
		url:url,
		checkbox:false,
		onlyLeafCheck:true,
		onDblClick:function(node){
			var value=node.eleid.replace(/\^/g,String.fromCharCode(4));
			if ((value=="")||(value==undefined)){
				PageLogicObj.m_DDCISRowid="";
				PageLogicObj.m_ItemRowid="";
				return false;
			}
			//CureItemTreeClick(value);//双击节点，加载医嘱信息及绑定医嘱列表
		},
		formatter:function(node){
			if (node.eleid=="") return node.text;
			else {
				if (+node.RealStock=="0"){
					//已配置且未激活为红色
					return '<span style="color:red">'+node.text+'</span>';
				}else if (+node.RealStock=="-1"){
					//未配置为灰色
					return '<span style="color:#808080">'+node.text+'</span>';
				}else{
					return node.text;
				}
			}
		},
		onClick: function(node){
			var isLeaf=$(this).tree('isLeaf',node.target)
			if (!isLeaf){
				$(this).tree('toggle',node.target)
			}else{
				var curId=$(this).tree('getNode',node.target).id;
				var isChecked=false;
				var value=node.eleid.replace(/\^/g,String.fromCharCode(4));
				if ((value=="")||(value==undefined)){
					PageLogicObj.m_DDCISRowid="";
					PageLogicObj.m_ItemRowid="";
					return false;
				}
				CureItemTreeClick(value);//双击节点，加载医嘱信息及绑定医嘱列表
			}
		}
	});
}

///搜索框QryArcDesc本身可触发该方法
function ReloadCureItemTree(value,name){
	if(ClearTree()){
		var para="^^^^"+session['LOGON.HOSPID']+"^"+value+"^Y^"+"N";
		var myurl="doccure.config.data.csp?action=cure&para="+encodeURIComponent(para);
		$('#CureItemTree').tree('options').url=myurl;
		$HUI.tree("#CureItemTree").reload();
	}
}

function ClearTree(){
    var tbox=$HUI.tree("#CureItemTree");
    var roots=tbox.getRoots();
    for (var i=roots.length-1;i>=0;i--){
	  var node = tbox.find(roots[i].id);
	  tbox.remove(node.target);
    }
    PageLogicObj.m_DDCISRowid="";
	PageLogicObj.m_ItemRowid="";
    return true
}
function CureItemTreeClick(value){
	if(value==""){
		$.messager.alert('提示',$g('获取节点信息错误'), "error");   
        return false;	
	}
	var arr=value.split(String.fromCharCode(4));
	var ItemRowid=arr[2];
	var Rowid=arr[17];
	PageLogicObj.m_DDCISRowid=Rowid;
	PageLogicObj.m_ItemRowid=ItemRowid;
	LoadCureItemScheduleData();	
}

function SearchAppClick(LoadFun){
	var StartDate=$("#Apply_StartDate").datebox("getValue"); 
	var tabs = $("#ScheduleTab").tabs("tabs");
    $('#ScheduleTab').tabs({
		onSelect:function (){
		}
	})
	var length = tabs.length;
	for(var i = 0; i < length; i++) {
	    var onetab = tabs[0];
	    var title = onetab.panel('options').tab.text();
	    $("#ScheduleTab").tabs("close", title);
	}
	InitScheduleTab(StartDate,LoadFun) ;	
}
function InitScheduleTab(StartDate,LoadFun){
	var AdmDateStr=tkMakeServerCall("DHCDoc.DHCDocCure.RBCResSchdule","GetAdmDateStr",StartDate)
	var AdmDateStrArr=AdmDateStr.split("^")
	for(var i=0;i<AdmDateStrArr.length;i++){
		var admDate=AdmDateStrArr[i].split(String.fromCharCode(1))[0]
		$("#ScheduleTab").tabs("add",{
			title:admDate,
			content:'Tab Body'
		})
	}
	$('#ScheduleTab').tabs({
		heigth:'auto',
		onSelect: function(title,index){
			SelectScheduleTab(title,index);
		}
	})
}
function SelectScheduleTab(title,index){
	if("undefined"==typeof index)index=PageLogicObj.m_ScheduleTabIndex;
	if("undefined"==typeof title){
		var StartDate=PageLogicObj.m_TalStartDate;
	}else{
		var StartDate=title.split("(")[0];
	}
	var CurrentTabPanel=$('#ScheduleTab').tabs("getSelected");
	var TemplateTable=$('<div class="c-p-bd-t schegrid-in-div"><table id="ScheduleGrid'+index+'"></table></div>');
	CurrentTabPanel.html(TemplateTable);
	PageLogicObj.m_TalStartDate=StartDate ;
	InitCureRBCResSchduleDataGrid("ScheduleGrid"+index,CurrentTabPanel.height()-3);
	clearTimeout(PageLogicObj.m_SchduleDataGridLoadTimer);
	PageLogicObj.m_SchduleDataGridLoadTimer=setTimeout("LoadCureItemScheduleData('ScheduleGrid"+index+"','"+StartDate+"')",500)
	PageLogicObj.m_ScheduleTabIndex=index;
}
function InitCureRBCResSchduleDataGrid(GridId,height)
{  
	var cureRBCResSchduleColumns=[[    
            { field: 'Rowid', title: 'ID', width: 1, align: 'left', sortable: true,hidden:true}, 
			{ field: 'DDCRSDate', title:'日期', width: 100, align: 'left', sortable: true, hidden: true},
			{ field: 'LocDesc', title:'科室', width: 180, align: 'left', sortable: true, resizable: true  
			},
			{ field: 'ResourceDesc', title: '资源', width: 120, align: 'left', sortable: true, resizable: true
			},
			{ field: 'TimeDesc', title: '时段', width: 120, align: 'left', sortable: true, resizable: true
			},
			{ field: 'StartTime', title: '开始时间', width: 100, align: 'left', sortable: true,resizable: true
			},
			{ field: 'EndTime', title: '结束时间', width: 100, align: 'left', sortable: true,resizable: true
			},
			{ field: 'EndAppointTime', title: '截止预约时间', width: 100, align: 'left', sortable: true
			},
			{ field: 'ServiceGroupDesc', title: '服务组', width: 120, align: 'left', sortable: true,resizable: true
			},
			{ field: 'DDCRSStatus', title: '状态', width: 80, align: 'left', sortable: true,resizable: true
			},
			{ field: 'AppedLeftNumber', title: '剩余可预约数', width: 120, align: 'left', sortable: true,resizable: true,
				formatter:function(value,row,index){
					value=parseFloat(value)
					var MaxNumber=parseFloat(row.MaxNumber)*0.5;
					if (value ==0){
						return "<span class='fillspan-nonenum'>"+value+"</span>";
					}else if((value >0)&&(value<MaxNumber)){
						return "<span class='fillspan-nofullnum'>"+value+"</span>";
					}else{
						return "<span class='fillspan-fullnum'>"+value+"</span>";
					}
				}
			},
			{ field: 'AppedNumber', title: '已预约数', width: 120, align: 'left', sortable: true,resizable: true
			},
			{ field: 'MaxNumber', title: '最大可预约数', width: 120, align: 'left', sortable: true,resizable: true
			},
			{ field: 'AutoNumber', title: '自动预约数', width: 120, align: 'left', sortable: true,resizable: true, hidden: true
			}
		 ]];
	$('#'+GridId).datagrid({  
		border:false,
		remoteSort:false,
		striped:true,
		autoRowHeight:true,
		fitColumns : false,
		url:'',
		height:height,
		loadMsg:'正在加载',
		rownumbers:true,
		idField:"Rowid",
		columns :cureRBCResSchduleColumns,
		rowStyler:function(rowIndex, rowData){
 			if (rowData.DDCRSStatus!=$g("正常")){
	 			return 'color:#788080;';
	 		}
		},
		onLoadSuccess:function(data){
			UpdateScheTabStyle(GridId);
		}
	});
}

function UpdateScheTabStyle(tabId){
	$(".tabItem_badge").remove();
	var opts=$("#"+tabId).datagrid("options");
	var queryParams=opts.queryParams;
	if ((queryParams.Arg6!="")||(queryParams.Arg7!="")){
		var ArgCnt=queryParams.ArgCnt;
		var obj={};
		for (var i=0;i<ArgCnt;i++) {
			var ArgN="Arg"+(i+1);
			obj[ArgN]=queryParams[ArgN];
		}
		var FirstTab = $('#ScheduleTab').tabs('getTab',0);
		var FirstTabTitle=FirstTab.panel("options").title;
		var FirstTabDate=FirstTabTitle.split("(")[0];
		var AdmDateStr=tkMakeServerCall("DHCDoc.DHCDocCure.RBCResSchdule","GetAdmDateStr",FirstTabDate,JSON.stringify(obj))
		var AdmDateStrArr=AdmDateStr.split("^")
		for(var i=0;i<AdmDateStrArr.length;i++){
			var admDate=AdmDateStrArr[i].split(String.fromCharCode(1))[0];
			var ExistScheduleFlag=AdmDateStrArr[i].split(String.fromCharCode(1))[1];
			if (ExistScheduleFlag==1){
				$($("#ScheduleTab .tabs li a")[i]).append('<sup class="tabItem_badge"></sup>');
			}
		}
	}
}

function LoadCureItemScheduleData(GridId,StartDate){
	
	if("undefined"==typeof GridId)GridId="ScheduleGrid"+PageLogicObj.m_ScheduleTabIndex;
	if("undefined"==typeof StartDate)StartDate=PageLogicObj.m_TalStartDate;
	var SessionStr=session['LOGON.HOSPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.USERID'];
	$("#"+GridId).datagrid("unselectAll");
	var queryParams = new Object();
		queryParams.ClassName ='DHCDoc.DHCDocCure.RBCResSchdule';
		queryParams.QueryName ='QueryAvailResApptSchdule';
		queryParams.Arg1 ="";
		queryParams.Arg2 ="";
		queryParams.Arg3 ="";
		queryParams.Arg4 =StartDate;
		queryParams.Arg5 =StartDate;
		queryParams.Arg6 =PageLogicObj.m_DDCISRowid;
		queryParams.Arg7 =PageLogicObj.m_ItemRowid;
		queryParams.Arg8 =SessionStr;
		queryParams.ArgCnt = 8;
			
	var opts = $("#"+GridId).datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	$("#"+GridId).datagrid('load', queryParams); 
}