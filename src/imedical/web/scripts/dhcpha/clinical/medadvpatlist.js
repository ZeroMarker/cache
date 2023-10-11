/// Creator:    bianshuai
/// CreateDate: 2014-09-09
/// Descript:   用药建议[药师界面]

//定义Url
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;color:red;">'+$g("[双击行添加]")+'</span>';
var statusArr = [{ "val": "10", "text": $g("建议") }, { "val": "20", "text": $g("申诉") },{ "val": "30", "text": $g("接受") },{ "val": "40", "text": $g("药师同意") }];
var appType="P";
//var medAdvID="";
//var Status="";  // qunianpeng 2016/10/17
$(function(){
	$("#StartDate").datebox("setValue", formatDate(-3));  //Init起始日期
	$("#EndDate").datebox("setValue", formatDate(0));     //Init结束日期
	
	$('#textarea').bind("focus",function(){
		if(this.value==$g("请输入...")){
			$('#textarea').val("");
		}
	});
	
	$('#textarea').bind("blur",function(){
		if(this.value==""){
			$('#textarea').val($g("请输入..."));
		}
	});
	
	$('div[name=list]').live("click",function(){    //E8F1FF
		$('#'+this.id).css('background','FFE48D').css('border','1px solid #CCC')
			.siblings().css("background","").css('border','');
		$('#medAdvDetID').html(this.id);
	})
	
	///鼠标移动、离开事件,设置颜色变化 ttt 为当前选择对象
	$('div[name=list]').live('mouseover',function(){
		if(this.id!=$('#medAdvDetID').html()){
			$(this).css('background','E8F1FF');
		}
	}).live('mouseleave',function(){
		if(this.id!=$('#medAdvDetID').html()){
			$(this).css('background','');
		}
	})
	
	//状态
	$('#status').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:statusArr
	});
	
	//登记号绑定回车事件
    $('#patno').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
	        var patno=$('#patno').val();  //sufan  2016/09/13
			if(patno!=""){        //lbb  2020/1/13
	        getRegNo(patno);
            queryMedAdv(); //调用查询
			}
        }
    });
	
	InitPatList();     //初始化病人列表
	InitMedAdvList();  //初始化建议模板列表
	
	$('#Find').bind("click",queryMedAdv);    //点击查询
//	$('a:contains("删除")').bind("click",delMedAdv);    //删除建议
	$('#DelMed').bind("click",delMedAdv);    //删除建议   //qunianpeng 2016-08-17
	$('#Agr').bind("click",agrMedAdv);       //同意
	$('#Quo').bind("click",createMedAdvWin); //引用
	$('#App').bind("click",appMedAdvDetail); //申诉  //提交意见
	$('#Del').bind("click",delMedAdvDetail); //删除
	$('#Main').bind("click",medAdvTemp); //模板维护
	
	queryMedAdv(); //页面加载完后自动查找
	var p=$('#patList').datagrid('getPager');
	if(p){
		 $(p).pagination({ //设置分页功能栏
		 			

	           //分页功能可以通过Pagination的事件调用后台分页功能来实现
				//showRefresh:false,
	        	onRefresh:function(){
		        	$('#medAdvCon').html("");
	        	}
	        });
	}
	
	
});

//初始化病人列表
function InitPatList()
{
	//定义columns
	var columns=[[
		{field:'medAdvTime',title:$g('时间'),width:120},
		{field:'PatBed',title:$g('床号'),width:60},
		{field:'PatNo',title:$g('登记号'),width:80},
		{field:'PatName',title:$g('姓名'),width:80},
		{field:'CurStatus',title:$g('当前状态'),width:70},
		{field:'PatientID',title:'PatientID',width:80},
		{field:'AdmDr',title:'AdmDr',width:80},
		{field:'medAdvID',title:'medAdvID',width:80}
	]];
	
	//定义datagrid
	$('#patList').datagrid({
		//title:'病人列表',    
		url:'',
		fit:true,
		//fitColumns:true,
		rownumbers:true,
		columns:columns,
		pageSize:30, 	    // 每页显示的记录条数
		pageList:[30,45],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:true,
		onClickRow:function(rowIndex, rowData){ 
			$('#medAdvDetID').html('');
			var EpisodeID=rowData.AdmDr;
			var PatientID=rowData.PatientID;
			Status=rowData.CurStatus;
			medAdvID=rowData.medAdvID;
			//LoadPatInfo(EpisodeID);  ///加载病人相关重要信息
			LoadMedAdvList(medAdvID);  ///加载明细
		}
	});
	
	initScroll("#patList");//初始化显示横向滚动条

}

/// 查询
function queryMedAdv()
{
	var StDate=$('#StartDate').datebox('getValue'); //起始日期
	var EndDate=$('#EndDate').datebox('getValue');  //截止日期
	var patno=$('#patno').val();; 					//登记号
	var status=$('#status').combobox('getValue');   //状态
	if(typeof status=="undefined"){status="";}
	var params=StDate+"^"+EndDate+"^"+session['LOGON.USERID']+"^"+appType+"^"+status+"^^"+patno+"^"+session['LOGON.HOSPID'];
	$('#patList').datagrid({
		url:url+'?action=QueryMedAdvPatList',	
		queryParams:{
			params:params}
	});	
}
///自动补全登记号位数   sufan 2016/09/13
function getRegNo(regno)
{
	var len=regno.length;
	var  reglen=10
	var zerolen=reglen-len
	for (var i=1;i<=zerolen;i++)
	{regno="0"+regno
		}
	var patno=$('#patno').val(regno);
}
/// 删除建议
function delMedAdv()
{
	var row=$('#patList').datagrid('getSelected');
	if (row){
		var medAdvID=row.medAdvID;	//qunianpeng 2016/10/18
		var medAdvStatus=row.CurStatus; //hezhigang  2018-7-12
		 $.messager.confirm("提示", "您确定要删除这些数据吗？",function(res){ //提示是否删除
			 if (res) {
				$.post(url,{action:"delPatMedAdv",AdvID:medAdvID},function(data,status){
			       var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
			       if(retVal!="0"){
					if(medAdvStatus==$g("接受")){
					  		$.messager.alert("提示","医生已接受,不能删除！");
				       	}else  if(medAdvStatus==$g("申诉")){
					  		$.messager.alert("提示","医生已申诉,不能删除！");
				      	 }else  if(medAdvStatus==$g("药师同意")){
					  		$.messager.alert("提示","药师已同意用药,不能删除！");
				       }
			       }else{
				   //   medAdvID="";				//qunianpeng 2016/10/18
				   	  queryMedAdv();
					  $('#medAdvCon').html("");   //qunianpeng 2016-08-17
				   }
		       });
			 }
        });
	}
else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
function LoadMedAdvList(medAdvID)
{
	//获取建议信息
 	 $.post(url,{action:"getPatMedAdvIn",AdvID:medAdvID},function(data,status){
	     var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
	     if(retVal!=""){
			InitMedAdivPanel(retVal);
	     }
     });
}

///加载建议信息
function InitMedAdivPanel(retVal)
{
	var htmlstr="";
	var medAdvDataArr=retVal.split("!");
	var AdvID=medAdvDataArr[0];             //RwoID
	var medAdvMasDateStr=medAdvDataArr[1];  //用药建议主信息
	var medAdvDrgItmStr=medAdvDataArr[2];   //医嘱信息
	var medAdvContentStr=medAdvDataArr[3];  //建议信息
	
	//主信息
	var medAdvMasArr=medAdvMasDateStr.split("^");
	htmlstr=htmlstr+"<div style='font-size:13pt;border-bottom: 2px solid #95B8E7;background: none repeat scroll 0% 0% #FFFFFF;padding: 10px 10px 15px 15px;position: relative;border-radius: 5px;box-shadow: 0px 3px 3px 0px #CCC inset;' id="+AdvID+" >";
	htmlstr=htmlstr+"<span style='font-weight:bold;'>"+$g('有效期：')+"</span><span>"+medAdvMasArr[0]+"</span><span style='font-weight:bold;margin-left:15px;margin-right:15px;'>"+$g('至')+"</span><span>"+medAdvMasArr[1]+"</span><span style='font-weight:bold;margin-left:30px;color:red;'>"+medAdvMasArr[2]+"</span>";
	htmlstr=htmlstr+"<br>";
	//医嘱
	htmlstr=htmlstr+"<span style='font-weight:bold;'>"+$g('原医嘱:')+"</span>";
	htmlstr=htmlstr+"<br>";
	var medAdvDrgItmArr=medAdvDrgItmStr.split("||");
	for(var k=0;k<medAdvDrgItmArr.length;k++)
	{
		htmlstr=htmlstr+"<span style='margin-left:30px;'>"+medAdvDrgItmArr[k]+"</span>";
		htmlstr=htmlstr+"<br>";
	}
	//建议
	var medAdvContentArr=medAdvContentStr.split("||");
	htmlstr=htmlstr+"<span style='font-weight:bold;'>"+$g('用药建议:')+"</span>";
	htmlstr=htmlstr+"<br>";
	for(var k=0;k<medAdvContentArr.length;k++)
	{
		var medAdvConArr=medAdvContentArr[k].split("^");
		htmlstr=htmlstr+"<div style='padding:5px;' name=list id="+medAdvConArr[4]+">";
		if(medAdvContentArr[k]!=""){
			htmlstr=htmlstr+"<span style='margin-left:30px;font-weight:bold;font-size:12pt;'>"+medAdvConArr[0]+":</span>";  //<span style='font-size:8pt;'>"+medAdvConArr[1]+" "+medAdvConArr[2]+"</span>
			htmlstr=htmlstr+"<br>";
			htmlstr=htmlstr+"<span style='margin-left:70px;font-size:12pt;'>"+medAdvConArr[3]+"</span>";
			htmlstr=htmlstr+"<br>";
		}
		htmlstr=htmlstr+"</div>";
	}
	//htmlstr=htmlstr+"<span style='margin-left:300px;font-weight:bold;'>药师："+medAdvMasArr[3]+"</span><span style='margin-left:20px;font-weight:bold;'>"+medAdvMasArr[0]+"</span>"
	htmlstr=htmlstr+"</div>";
	
	$('#medAdvCon').html(htmlstr);
}

///保存用药建议
function appMedAdvDetail()
{
	var UserID=session['LOGON.USERID'];        ///用户ID
	var medAdvDetailList=$('#textarea').val(); ///用药建议
	var row=$('#patList').datagrid('getSelected');	//qunianpeng 2016/10/18	
	if(!row){
		$.messager.alert("提示","请先选择病人信息！");
		return;
	}
	if((medAdvDetailList==$g("请输入..."))||(medAdvDetailList=="")){   //sufan 2016/09/09
		$.messager.alert("提示","请先输入意见,再进行提交！");
		return;
	}
	var medAdvID=row.medAdvID;
	//var curStatus="40";  //提意状态   赵武强  2016-09-12  //cancel annotate by qnp
	var curStatus="10";
	medAdvMasList=UserID+"^"+curStatus+"^"+medAdvDetailList.replace(/(^\s*)|(\s*$)/g,""); //去掉标示字符

	var data=jQuery.param({"action":"SaveMedAdvDetail","AdvID":medAdvID,"dataList":medAdvMasList});
	$.ajax({
        type:"POST",
        url:url,
        data:data,
        dataType:"json",
        success: function (val) {
	    	LoadMedAdvList(medAdvID);  ///加载明细
	    	$('#textarea').val("");    ///清空textarea内容
	    }
    });
}

///加载病人用药建议列表
function LoadPatAdviceList()
{
	if (AdmDr==""){return;}
	$.post(url,{action:"getPatAdviceList",AdmDr:AdmDr},function(data,status){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal!=""){
			var medAdvPatAdvArr=retVal.split("#");
			for(var m=0;m<medAdvPatAdvArr.length;m++){
				InitAdivisesPanel(medAdvPatAdvArr[m]); //逐条加载
			}
		}
	});
}
/*  //qunianpeng 2016-08-17
/// 删除用药建议
function delMedAdvDetail()
{
	var AdvID=$('#AdvID').html();  //获取当前选择建议AdvID
	if (AdvID==""){
		$.messager.alert("提示","请选择要删除的记录！");
		return;
	}
	$.post(url,{action:"delPatMedAdvDetail",AdvID:AdvID},function(data,status){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal=="0"){
			$('#'+AdvID).remove();
			$.messager.alert("提示","删除成功！");
		}else if(retVal=="-1"){
			$.messager.alert("提示","建议不存在！");
		}else if(retVal=="-2"){
			$.messager.alert("提示","医生已回复,不能删除！");
		}else if(retVal=="-3"){
			$.messager.alert("提示","非药师建议，不可删除");
			}
	});
}
*/
///初始化建议模板列表
function InitMedAdvList()
{
		//定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:'Code',title:$g('代码'),width:100},
		{field:'Desc',title:$g('描述'),width:600},
	]];
	
	//定义datagrid
	$('#medAdvdg').datagrid({
		//title:'',    
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,        // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){
			var tmpDesc=rowData.Desc;
			if(($('#textarea').val()==$g("请输入..."))||($('#textarea').val()=="")){
				$('#textarea').val("").val(tmpDesc);
			}else{
				$('#textarea').val($('#textarea').val()+","+tmpDesc);
			}
			$('#medAdvWin').window('close');
		}
	});
	
	//initScroll();//初始化显示横向滚动条
}

// 建议引用窗口
function createMedAdvWin()
{	

	$('#medAdvWin').window({
		title:$g('建议列表')+titleNotes,    
		collapsible:true,
		border:true,
		closed:"true",
		width:800,
		height:350,
		minimizable:false
	});

	$('#medAdvWin').window('open');
	
	///自动加载建议字典
	$('#medAdvdg').datagrid({
		url:url+'?action=QueryMedAdvTemp',	
		queryParams:{
			params:session['LOGON.CTLOCID']+"^"+session['LOGON.USERID']
		}
	});
}

/// 删除用药建议明细
function delMedAdvDetail()
{
	var medAdvDetID=$('#medAdvDetID').html();  //获取当前选择建议AdvID
	if (medAdvDetID==""){
		$.messager.alert("提示","请选择要删除的记录！");
		return;
	}
    if(Status==$g("申诉")){	//lbb   医生申诉、同意、接受不可删除	 
		$.messager.alert("提示","医生已申诉，不可删除");
		return;
	    } 
	else if(Status==$g("接受")){		 
	    $.messager.alert("提示","医生已接受，不可删除");
		return;
	    } 
	else if(Status==$g("药师同意")){		 
		$.messager.alert("提示","药师已同意用药，不可删除");
		return;
		}
	$.post(url,{action:"delPatMedAdvDetail",medAdvDetID:medAdvDetID},function(data,status){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal=="0"&&(Status==$g("建议"))){ //lbb  建议状态允许被删除 
			$('#'+medAdvDetID).remove();
			$.messager.alert("提示","删除成功！");
			return;
		}else if(retVal=="-1"){
			$.messager.alert("提示","建议不存在！");
			return;
		}else if(retVal=="-3"){
			$.messager.alert("提示","非药师建议，不可删除");
			return;
			}
	});
}

/// 同意
function agrMedAdv()
{
	var row=$('#patList').datagrid('getSelected');	
	if(!row){
		$.messager.alert("提示","请选择待处理建议列表数据！");
		return;
	}
	var medAdvID=row.medAdvID;
	if(Status!=$g("申诉")){		//当状态为申诉时，药师方可操作同意按钮 qunianpeng 2016/10/17 
		$.messager.alert("提示","医生未申诉，不可操作！");
		return;
	} 
	var curStatus="40";  //药师同意为40
	$.post(url,{action:"agrPatMedAdv",medAdvID:medAdvID,curStatus:curStatus},function(data,status){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal=="0"){
			$.messager.alert("提示","操作成功！");
			queryMedAdv();      //sufan 2016/09/12
			LoadMedAdvList(medAdvID);
		}else{
			$.messager.alert("提示","操作失败！");
		}
	});
}

/// 用药建议模板维护
function medAdvTemp()
{
	$('#medAdvTempWin').window({
		title:$g('用药建议模板维护'),    
		collapsible:true,
		border:true,
		closed:"true",
		width:1000,
		height:500,
		minimizable:false
	});

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.medadvtemp.csp"></iframe>';
	$('#medAdvTempWin').html(iframe);
	$('#medAdvTempWin').window('open');
}
