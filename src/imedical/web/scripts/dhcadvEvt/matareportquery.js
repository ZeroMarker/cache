// Creator: congyue
/// CreateDate: 2016-01-08
//  Descript: 不良反应查询
var url = "dhcadv.repaction.csp";
var statShare = [{ "val": "未分享", "text": "未分享" },{ "val": "分享", "text": "分享" }];
var statArray = [{ "val": "Y", "text": "已提交" },{ "val": "N", "text": "未提交" }];
document.write('<script type="text/javascript" src="../scripts/dhcadvEvt/dhcadvExpPri.js"></script>');
var StDate=formatDate(-7);  //一周前的日期
var EndDate=formatDate(0); //系统的当前日期
$(function(){
	$("#stdate").datebox("setValue", StDate);  //Init起始日期
	$("#enddate").datebox("setValue", EndDate);  //Init结束日期
	
	/* 科室 */
	//var DeptCombobox = new ListCombobox("dept",url+'?action=SelAllLoc','',{});
	//DeptCombobox.init();
	//科室  2017-08-01 cy 修改 下拉框传递参数检索
	$('#dept').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		mode:'remote',  //必须设置这个属性
		url:url+'?action=SelAllLoc',
		onLoadSuccess:function(){  
		    var data =  $('#dept').combobox('getData'); 
		    $('#dept').combobox({disabled:true}); 
		    $("#dept").combobox('setValue',LgCtLocID);
		}   
	});
	//$('#dept').combobox({disabled:true});
	//$("#dept").combobox('setValue',LgCtLocID);
	/* 状态 */
	var StatusCombobox = new ListCombobox("status",'',statArray,{panelHeight:"auto"});
	StatusCombobox.init();

	/* 报告类型 */
	var TypeeventCombobox = new ListCombobox("typeevent",url+'?action=selEvent','',{});
	TypeeventCombobox.init();
	
	/* 分享状态 */  
	var ShareCombobox = new ListCombobox("Share",'',statShare,{panelHeight:"auto"});
	ShareCombobox.init();
	
	$('#Find').bind("click",Query);  //点击查询 
	$('#SHare').bind("click",Share);  //点击分享
	$('#Delete').bind("click",Delete);  //点击删除
	$('a:contains("导出")').bind("click",Export); 	  //导出
	$('a:contains("打印")').bind("click",Print);     //打印

	InitPatList(); //初始化报告列表
	
	//登记号回车事件
	$('#patno').bind('keypress',function(event){
	 if(event.keyCode == "13"){
		 var patno=$.trim($("#patno").val());
		 if (patno!=""){
			GetWholePatID(patno);
			Query();
		 }	
	 }
	});
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
})

//分享
function Share(){
var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	$.each(selItems, function(index, item){
		var ID=item.ID;         //报表ID
		var TypeCode=item.TypeCode;         //报告类型代码
		var RepShareFlag=item.RepShareFlag;//分享状态
/* 		 if(RepShareFlag=="分享"){
			$.messager.alert("提示:","已经分享！");
			return;
		} */
		
				var status=item.status //当前状态id
				var params=ID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+TypeCode+"^"+status+"^"+RepShareFlag   //参数串
		
				//保存数据
				$.post(url+'?action=InsRepShare',{"params":params},function(jsonString){
					 if(jsonString==-1){
					  $.messager.alert("提示:","已经分享！");
			   
				   }
			/* 		var resobj = jQuery.parseJSON(jsonString);
					if(resobj.ErrCode < 0){
						$.messager.alert("提示:","<font style='font-size:20px;'>接收错误,错误原因:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
					} */
			
		});
	})
	$('#maindg').datagrid('reload'); //重新加载
	
	
}
//查询
function Query()
{
	//1、清空datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2、查询
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID=$('#dept').combobox('getValue');     //科室ID
	var status=$('#status').combobox('getValue');  //状态
	var typeevent=$('#typeevent').combobox('getValue');  //报告类型
	var statShare=$('#Share').combobox('getValue');  //分享状态 
	if (status==undefined){status="";} 
	if (typeevent==undefined){typeevent="";}
	if (statShare==undefined){statShare="";}
	var PatNo=$.trim($("#patno").val());
	var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+statShare;
	//alert(params);
	$('#maindg').datagrid({
		url:url+'?action=GetMataReport',	
		queryParams:{
			params:params}
	});
}

//初始化报告列表
function InitPatList()
{
	//定义columns
	var columns=[[
	    {field:'consultID',title:'consultID',width:80,hidden:true},
		{field:"ck",checkbox:true,width:20},
		{field:'LkDetial',title:'操作',width:100,align:'center',formatter:SetCellOpUrl},
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:'RepShareFlag',title:'分享状态',width:100,align:'center'},
		{field:'Edit',title:'修改',width:80,align:'center',formatter:setCellEditSymbol,hidden:false},
		{field:"status",title:'报告状态',width:90,hidden:false},
		{field:'Medadrreceive',title:'接收状态',width:100,hidden:true},
		{field:'Medadrreceivedr',title:'接收状态dr',width:80,hidden:true},
		{field:'CreateDate',title:'报告日期',width:100},
		{field:'RepNo',title:'报告编号',width:160},
		{field:'PatNo',title:'登记号',width:120},
		{field:'PatName',title:'姓名',width:120},
		{field:'LocDesc',title:'报告科室',width:220},
		{field:'Typeevent',title:'报告类型',width:220},
		{field:'Creator',title:'报告人',width:120},
		{field:'TypeCode',title:'报告类型代码',width:120},
		{field:'Assess',title:'评估id',width:120,hidden:true},
		{field:'StaFistAuditUser',title:'被驳回人',width:120,hidden:true},
		{field:'BackAuditUser',title:'驳回操作人',width:120,hidden:true}
	]];
	
	//定义datagrid
	$('#maindg').datagrid({
		title:'报告列表',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		rowStyler:function(index,row){  
	        /* if (row.status.indexOf("驳回")>=0){  
	            return 'background-color:red;';  
	        } */
	        if ((row.StaFistAuditUser==LgUserName)||(row.BackAuditUser==LgUserName)){  
	            return 'background-color:red;';  
	        }  
    	}
	});
	
	initScroll("#maindg");//初始化显示横向滚动条
}
//删除
function Delete()
{
	var selItems = $('#maindg').datagrid('getSelections');
	var delflag=0;
	if (selItems.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.each(selItems, function(index, item){
					var ID=item.ID;         //报表ID
					var TypeCode=item.TypeCode; //报告类型代码
					var delparams=ID+"^"+LgUserID;
					if(TypeCode=="material"){
						$.ajax({
							type: "POST",// 请求方式
					    	url: url,
					    	data: "action=DelMataReport&params="+delparams,
							async: false, //同步
							success: function(data){
								if(data!=0){
									delflag=data;
								}
							}
						});
					}
					if(TypeCode=="drugerr"){
						$.ajax({
							type: "POST",// 请求方式
					    	url: url,
					    	data: "action=DelMedsReport&params="+delparams,
							async: false, //同步
							success: function(data){
								if(data!=0){
									delflag=data;
								}
							}
						});
					}
					if(TypeCode=="blood"){
						$.ajax({
							type: "POST",// 请求方式
					    	url: url,
					    	data: "action=DelBldrptReport&params="+delparams,
							async: false, //同步
							success: function(data){
								if(data!=0){
									delflag=data;
								}
							}
						});
					}
					if(TypeCode=="med"||TypeCode=="bldevent"){
						$.ajax({
							type: "POST",// 请求方式
					    	url: url,
					    	data: "action=DelMedReport&params="+delparams,
							async: false, //同步
							success: function(data){
								if(data!=0){
									delflag=data;
								}
							}
						});
					}
					if(TypeCode=="drug"){
						$.ajax({
							type: "POST",// 请求方式
					    	url: url,
					    	data: "action=DelMadrReport&params="+delparams,
							async: false, //同步
							success: function(data){
								if(data!=0){
									delflag=data;
								}
							}
						});
					}
				});	
			}
                        else    //wangxuejian 2016-09-28
			{
				
				delflag=1
			}
			if(delflag==0){
				$.messager.alert('提示','删除成功');
				$('#maindg').datagrid('reload'); //重新加载
			}else if(delflag==-1){
				$.messager.alert('提示','非本人操作，删除失败','warning');
				$('#maindg').datagrid('reload'); //重新加载
			}else if(delflag==-2){
				$.messager.alert('提示','报告已提交，不可删除','warning');
				$('#maindg').datagrid('reload'); //重新加载
			}else if(delflag==-10){
				$.messager.alert('提示','删除子表出错','warning');
				$('#maindg').datagrid('reload'); //重新加载
			}else if(delflag==1){             //wangxuejian 2016-09-28
		
			}
                        else {
				$.messager.alert('提示','删除失败','warning');
				$('#maindg').datagrid('reload'); //重新加载
			}
			$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
		})

	}else{
		$.messager.alert('提示','请选择要删除的项','warning');
		return;
	}	
			
}		

//操作
function SetCellOpUrl(value, rowData, rowIndex)
{   var ID=rowData.ID;         //报表ID
	var TypeCode=rowData.TypeCode; //报告类型代码
	var RepShareFlag=rowData.RepShareFlag  //分享状态
	var statusflag=rowData.status.indexOf("驳回")
	var html = "";
	if ((RepShareFlag == "分享")&&(statusflag<0)){
		html = "<a href='#' onclick=\"newCreateConsultWin('"+ID+"','"+TypeCode+"')\" style='margin:0px 5px;font-weight:bold;color:red;text-decoration:none;'>查看回复列表</a>";
	}else if ((RepShareFlag == "分享")&&(statusflag>=0)){
		html = "<a href='#' onclick=\"newCreateConsultWin('"+ID+"','"+TypeCode+"')\" style='margin:0px 5px;font-weight:bold;color:yellow;text-decoration:none;'>查看回复列表</a>";
	}
	else{
		  html = "<a href='#' onclick=\"newCreateConsultWin('"+ID+"','"+TypeCode+"')\">查看回复列表</a>";
		}
    return html;
}

/**
  * 新建评论窗口
  */
function newCreateConsultWin(ID,TypeCode){
/* 	alert(ID)
	var option = {
		minimizable : true,
		maximizable : true
		};
	var newConWindowUX = new WindowUX('列表', 'newConWin', '1110', '620', option);
	newConWindowUX.Init();
	                                             
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.onlinereview.csp?ID='+ID+'"></iframe>';
	$('#newConWin').html(iframe); */
	
	
	if($('#winonline').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="winonline"></div>');
	$('#winonline').window({
		title:'列表',
		collapsible:true,
		border:false,
		closed:"true",
		width:1110,
		height:620
	});
	
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.onlinereview.csp?ID='+ID+'&TypeCode='+TypeCode+'"></iframe>';
		$('#winonline').html(iframe);
		$('#winonline').window('open');
	
}




///设置编辑连接
function setCellEditSymbol(value, rowData, rowIndex)
{
		var ID=rowData.ID;         //报表ID
		var TypeCode=rowData.TypeCode; //报告类型代码
		var assessID=rowData.Assess; //报告评估id 2017-06-12
		var status=rowData.status; //报告状态描述 2017-06-13
		var Medadrreceivedr=rowData.Medadrreceivedr //接收状态dr
		var StaFistAuditUser=rowData.StaFistAuditUser  //被驳回人
		var BackAuditUser=rowData.BackAuditUser //驳回操作人
		var satatusButton=0;  //修改标志  0可以修改 1不可以修改
		if ((assessID=="")||(status.indexOf("驳回") > 0)){
			assessID="";
		}
		if((Medadrreceivedr==2)&&(StaFistAuditUser!=LgUserName)&&(BackAuditUser!=LgUserName)){
			satatusButton=1;
		}
		return "<a href='#' onclick=\"showEditWin('"+ID+"','"+TypeCode+"','"+assessID+"','"+satatusButton+"')\"><img src='../scripts/dhcadvEvt/images/editb.png' border=0/></a>";
}
///设置列前景色
function setCellColor(value, rowData, rowIndex)
{
	return '<span style="color:red;">'+value+'</span>';;
}

//编辑窗体
function showEditWin(ID,TypeCode,assessID,satatusButton)
{
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'报告编辑',
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600
	});
	if(TypeCode=="material"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.matareport.csp?matadrID='+ID+'&editFlag='+1+'&assessID='+assessID+'&satatusButton='+satatusButton+'""></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	if(TypeCode=="drugerr"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medsafetyreport.csp?medsrID='+ID+'&editFlag='+1+'&assessID='+assessID+'&satatusButton='+satatusButton+'""></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
		
	}
	if(TypeCode=="blood"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.bloodreport.csp?bldrptID='+ID+'&editFlag='+1+'&assessID='+assessID+'&satatusButton='+satatusButton+'""></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
		
	}	
	if(TypeCode=="med"||TypeCode=="bldevent"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medicalreport.csp?adrRepID='+ID+'&editFlag='+1+'&assessID='+assessID+'&satatusButton='+satatusButton+'""></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
		
	}	
	if(TypeCode=="drug"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.advreport.csp?advdrID='+ID+'&editFlag='+1+'&assessID='+assessID+'&satatusButton='+satatusButton+'""></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
		
	}
}



///补0病人登记号
function GetWholePatID(RegNo)
{
	var len=RegNo.length;
	var  reglen=10
	var zerolen=reglen-len
	var zero=""
	for (var i=1;i<=zerolen;i++)
	{zero=zero+"0" ;
		}
	var RegNo=zero+RegNo ;
	$("#patno").val(RegNo);
}

 
// 导出Excel
function Export()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('提示',"<font style='color:red;font-weight:bold;font-size:20px;'>请先选择一行记录!</font>","error");
		return;
	}
	$.messager.confirm("提示", "是否进行导出操作", function (res) {//提示是否删除
		if (res) {
			var filePath=browseFolder();
			if (typeof filePath=="undefined"){
				$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择路径后,重试！</font>","error");
				return;
			}
       var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	     if ((filePath==undefined)||(filePath.match(re)=="")||(filePath.match(re)==null)){
		 	$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择有效路径后,重试！</font>","error");
		 	return;
	     }
			$.each(selItems, function(index, item){
		
				var ID=item.ID;         //报表ID
				var TypeCode=item.TypeCode; //报告类型代码
				ExportExcel(ID,TypeCode,filePath);
			})
			$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
		}
	})
}
/// 打印
function Print(){
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('提示',"<font style='color:red;font-weight:bold;font-size:20px;'>请先选择一行记录!</font>","error");
		return;
	}
	$.messager.confirm("提示", "是否进行打印操作", function (res) {//提示是否删除
		if (res) {
			$.each(selItems, function(index, item){
				var ID=item.ID;         //报表ID
				var TypeCode=item.TypeCode; //报告类型代码
				printRep(ID,TypeCode);
			})
		}
	})
}
//2016-10-10
function CloseWinUpdate(){
		$('#win').window('close');
}
