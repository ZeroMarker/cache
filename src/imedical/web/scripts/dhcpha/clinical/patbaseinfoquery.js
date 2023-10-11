
var url="dhcpha.clinical.action.csp";
var statArray = [{ "value": "I", "text": $g("在院") },{ "value": "O", "text": $g("出院")}];
$(function(){
	/* 初始化界面控件 */
	InitComponent();
})

/* 初始化界面控件 */
function InitComponent(){
	//定义columns
	var columns=[[
		{field:"AdmDr",title:'AdmDr',width:90,hidden:true},
		{field:'Ward',title:$g('病区'),width:160},
		{field:'PatNo',title:$g('登记号'),width:80},
		{field:'InMedicare',title:$g('病案号'),width:80},
		{field:'PatName',title:$g('姓名'),width:80},
		{field:'Bed',title:$g('床号'),width:80},
		{field:'PatSex',title:$g('性别'),width:80},
		{field:'PatAge',title:$g('年龄'),width:80},
		{field:'PatHeight',title:$g('身高'),width:80},
		{field:'PatWeight',title:$g('体重'),width:80},
		{field:'AdmLoc',title:$g('科室'),width:150},
		{field:'AdmDoc',title:$g('医生'),width:80},
		{field:'PatDiag',title:$g('诊断'),width:180},
		{field:'PatInDate',title:$g('入院时间'),width:140},
		{field:'PatOutDate',title:$g('出院时间'),width:140},
		{field:'OPer',title:$g('操作'),width:100,align:'center',formatter:ShowPatMonInfo}
	]];
	
	/// 初始化 datagrid
	var option = {title:$g('病人列表'),singleSelect:true};
	var mListComponent = new ListComponent('PatCompList', columns, '', option);
	mListComponent.Init();
	
	initScroll("#PatCompList");//初始化显示横向滚动条
        $('#PatCompList').datagrid('loadData', {total:0,rows:[]});
	
	/// 初始化日期
	$("#StDate").datebox("setValue", formatDate(-31));  //起始日期
	$("#EndDate").datebox("setValue", formatDate(0));  //结束日期
	
	/// 病区
	$('#Ward').combobox({
		mode:'remote',	
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			$('#Ward').combobox('reload',url+'?action=GetAllWardNewVersion&hospId='+LgHospID+'  ')
			//$('#ward').combobox('reload',url+'?actiontype=SelAllLoc')			
		}
	});
	//var WardCombobox = new ListCombobox("Ward",url+'?action=SelAllWard&HospID='+LgHospID);
	//WardCombobox.init();

	/// 科室
	$('#Loc').combobox({
		mode:'remote',		
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			$('#Loc').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'  ')
			//$('#dept').combobox('reload',url+'?action=SelAllLoc&HospID='+HospID)
		}
	}); 
	//var LocCombobox = new ListCombobox("Loc",url+'?action=SelAllLoc&loctype=E&HospID='+LgHospID);
	//LocCombobox.init();
	
	/// 类型
	var TypeCombobox = new ListCombobox("Type",'',statArray);
	TypeCombobox.init();


      ///登记号                                 wangxuejian 2016-09-13
     $("#PatNo").bind('keypress',function(event){       
        if(event.keyCode == "13"){
	        SetPatNoLength();
                Patnoquery();
          }
         });
	
	/// 查询按钮
	$('a:contains('+$g("查询")+')').bind("click",Query);  //点击查询
}

//登记号查询  wangxuejian 2016-09-13

function Patnoquery()
{ 
	var StDate=$('#StDate').datebox('getValue');   //起始日期
	var EndDate=$('#EndDate').datebox('getValue'); //截止日期
	var PatNo=$.trim($("#PatNo").val());
	var params=StDate+"^"+EndDate+"^^^^"+PatNo+"^";
	$('#PatCompList').datagrid({url:url+'?action=QueryAllInHosPatList',	
		queryParams:{
			params:params}
			});
}

//查询
function Query(){

	var StDate=$('#StDate').datebox('getValue');   //起始日期
	var EndDate=$('#EndDate').datebox('getValue'); //截止日期
	var WardID=$('#Ward').combobox('getValue');    //病区ID
	var LocID=$('#Loc').combobox('getValue');  //科室ID
	var Type=$('#Type').combobox('getValue');  //类型
	var PatNo=$.trim($("#PatNo").val());
	//科室和病区清空搜索内容后查询全部 duwensheng 2016-09-06
	if($('#Ward').combobox('getText')=="")
	{
		var WardID="";
	}
	if($('#Loc').combobox('getText')=="")
	{
		var LocID="";
	}
	var params=StDate+"^"+EndDate+"^"+WardID+"^"+LocID+"^"+Type+"^"+PatNo+"^"+LgHospID;
	
	//信息查询都是从第一页开始 duwensheng 2016-09-06
	$('#PatCompList').datagrid({url:url+'?action=QueryAllInHosPatList',pageNumber:"1",
		queryParams:{
			params:params}
	});
}


//登记号位数不足时，补零    qunianpeng 2016-09-12 
function SetPatNoLength(){	
	var PatientNo=$('#PatNo').val();      //登记号
	if(PatientNo!=""){
	var PatLen=PatientNo.length;			
	if(PatLen<10)     //登记号长度为10位
	{
		for (i=1;i<=10-PatLen;i++)
		{
			PatientNo="0"+PatientNo; 
		}
	}
	$('#PatNo').val(PatientNo);
	}
}

/// 查看监护数据
function  ShowPatMonInfo(value, rowData, rowIndex){

   	return "<a href='#' mce_href='#' onclick='showPatMonWin("+rowData.AdmDr+");'>"+$g("查看明细")+"</a>";   //wangxuejian 2016-09-23   点击以后可以进行选取
    
}

///  查看明细界面                               wangxuejian 2016-09-23
function showPatMonWin(EpisodeID){ 
    
	var option = {
		collapsible:true,
		border:true,
		closed:"true",
		minimizable:false,					/// 隐藏最小化按钮
		maximized:true						/// 最大化(qunianpeng 2018/5/2)
	};
	new WindowUX($g('病人药学监测信息查询'), 'newItmWin', '950', '550', option).Init();
	
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.perpharservice.csp?EpisodeID='+EpisodeID+'&MWToken='+websys_getMWToken()+'"></iframe>';
	$("#newItmWin").html(iframe);  //csp 里面有
}