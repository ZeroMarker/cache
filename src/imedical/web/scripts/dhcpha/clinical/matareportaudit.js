// Creator: congyue
/// CreateDate: 2015-11-09
//  Descript: 不良反应查询

var url = "dhcadv.repaction.csp";
var statArray = [{ "val": "填报", "text": "填报" },{ "val": "确认", "text": "确认" },{ "val": "审核", "text": "审核" }, { "val": "完成", "text": "完成" }];
var statReceive = [{ "val": "未接收", "text": "未接收" },{ "val": "1", "text": "接收" },{ "val": "2", "text": "驳回" }];
var statShare = [{ "val": "未分享", "text": "未分享" },{ "val": "分享", "text": "分享" }];
var editRow="",TranFlag=0,errflag=0 ;///TranFlag:转抄标志   errflag:转抄回复人员与被转抄人员是否一致
document.write('<script type="text/javascript" src="../scripts/dhcadvEvt/dhcadvExpPri.js"></script>');
$(function(){

	$("#stdate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#enddate").datebox("setValue", formatDate(0));  //Init结束日期
	
 	/* 科室 */
	var DeptCombobox = new ListCombobox("dept",url+'?action=SelAllLoc','',{});
	DeptCombobox.init();

	/* 状态 */
	var StatusCombobox = new ListCombobox("status",'',statArray,{panelHeight:"auto"});
	StatusCombobox.init();

	/* 报告类型 */
	var TypeeventCombobox = new ListCombobox("typeevent",url+'?action=selEvent','',{});
	TypeeventCombobox.init();
	
	/* 接收状态 */  
	var ReceiveCombobox = new ListCombobox("receive",'',statReceive,{panelHeight:"auto"});
	ReceiveCombobox.init();
	
	/* 分享状态 */  
	var ShareCombobox = new ListCombobox("Share",'',statShare,{panelHeight:"auto"});
	ShareCombobox.init();
	
	$('#Find').bind("click",Query);  //点击查询
	$('#audit').bind("click",Process); //审批
	$('#Audit').bind("click",Audit); //确认审批
	$('#REceive').bind("click",REceive); //接收
	$('#back').bind("click",Back); //报告驳回
	$('#RepImpFlag').bind("click",RepImpFlag); //重点关注
	$('#SHare').bind("click",Share); //分享状态  RepShareFlag
	$('#export').bind("click",Export); 	  //导出
	$('a:contains("打印")').bind("click",Print);     //打印
	$('#Transcription').bind("click",Transcription); //转抄操作
	$('#exportAudit').bind("click",ExportAudit); 	  //审核导出
	
	InitRepList(); //初始化报告列表
	
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
	var receive=$('#receive').combobox('getValue');  //接收状态
	var statShare=$('#Share').combobox('getValue');  //分享状态 
	if (LocID==undefined){LocID="";}
	if (status==undefined){status="";}
	if (typeevent==undefined){typeevent="";}
	if (receive==undefined){receive="";}
	if (statShare==undefined){statShare="";}
	var PatNo=$.trim($("#patno").val());
	var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+receive+"^"+statShare;
	$('#maindg').datagrid({
		url:url+'?action=QueryMataReport',	
		queryParams:{
			params:params}

	});
}

//确认审批
function Audit()
{	var NextLoc=$('#matadrNextLoc').combobox('getValue');
	var LocAdvice=$('#matadrLocAdvice').val();
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	$.each(selItems, function(index, item){
		var ID=item.ID;         //报表ID
		var typecode=item.typecode; //报告类型代码
		var StatusNextID=item.StatusNextID; //下一个状态
		var Medadrreceivedr=item.Medadrreceivedr;//接收状态
		var params=ID+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+typecode;   //参数串
		//alert(params);
		//保存数据
		$.post(url+'?action=AuditMataReport',{"params":params},function(jsonString){
			var resobj = jQuery.parseJSON(jsonString);
			if(resobj.ErrCode < 0){
				$.messager.alert("提示:","<font style='font-size:20px;'>审核错误,错误原因:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
			}
		});
	})

	$('#maindg').datagrid('reload'); //重新加载
	$('#Process').window('close');
}


//审核
function Process()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	$.messager.confirm("提示", "是否进行审核操作", function (res) {//提示是否删除
		if (res) {
			$.each(selItems, function(index, item){
				$('#Process').window({
					title:'审核',
					collapsible:false,
					border:false,
					closed:false,
					width:400,
					height:280
				});
				//指向科室
				$('#matadrNextLoc').combobox({
					//panelHeight:"auto",  //设置容器高度自动增长
					url:url+'?action=SelAllLoc'
				});  
				$('#Process').window('open'); 
				$("#matadrLocAdvice").empty(); 
			});
		}
	})
}

//接收
function REceive()
{
	var NextLoc="";
	var LocAdvice="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	$.messager.confirm("提示", "是否进行接收操作", function (res) {//提示是否删除
		if (res) {
			$.each(selItems, function(index, item){
				var ID=item.ID;         //报表ID
				var typecode=item.typecode;         //报告类型代码
				var Medadrreceivedr=item.Medadrreceivedr;//接收状态
				var StatusID=item.StatusID //当前状态id
				var params=ID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+typecode+"^"+StatusID;   //参数串
				//alert(params);
				//保存数据
				$.post(url+'?action=REMataReport',{"params":params},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
					if(resobj.ErrCode < 0){
						$.messager.alert("提示:","<font style='font-size:20px;'>接收错误,错误原因:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
					}
				});
			})
			$('#maindg').datagrid('reload'); //重新加载
		}
	})
}
//报告驳回
function Back()
{
	var NextLoc="";
	var LocAdvice="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	$.messager.confirm("提示", "是否进行驳回操作", function (res) {//提示是否删除
		if (res) {
			$.each(selItems, function(index, item){
				var ID=item.ID;         //报表ID
				var typecode=item.typecode;         //报告类型代码
				var Medadrreceivedr=item.Medadrreceivedr;//接收状态
				var StatusID=item.StatusID //当前状态id
				var params=ID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+typecode+"^"+StatusID;   //参数串
				//alert(params);
				//保存数据
				$.post(url+'?action=ReportBack',{"params":params},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
					if(resobj.ErrCode < 0){
						$.messager.alert("提示:","<font style='font-size:20px;'>驳回错误,错误原因:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
					}
				});
		
			})
			$('#maindg').datagrid('reload'); //重新加载
		}
	})
}


//分享
function Share(){
var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	$.messager.confirm("提示", "是否进行分享操作", function (res) {//提示是否删除
		if (res) {
			$.each(selItems, function(index, item){
				var ID=item.ID;         //报表ID
				var typecode=item.typecode;         //报告类型代码
				var RepShareFlag=item.RepShareFlag;//分享状态
				 if(RepShareFlag=="分享"){
					$.messager.alert("提示:","已经分享！");
					return;
				}
		
				var StatusID=item.StatusID //当前状态id
				var params=ID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+typecode+"^"+StatusID+"^"+RepShareFlag   //参数串
				//alert(params);
				//保存数据
				$.post(url+'?action=InsRepShare',{"params":params},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
					if(resobj.ErrCode < 0){
						$.messager.alert("提示:","<font style='font-size:20px;'>接收错误,错误原因:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
					}
				});
			})
			$('#maindg').datagrid('reload'); //重新加载
		}
	})
	
	
}

//重点关注
function RepImpFlag()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	$.messager.confirm("提示", "是否进行重点关注操作", function (res) {//提示是否删除
		if (res) {
			$.each(selItems, function(index, item){
				var ID=item.ID;         //报表ID
				var typecode=item.typecode;         //报告类型代码
			    var RepImpFlag=item.RepImpFlag;    //重点标记
			     if(RepImpFlag=="关注"){
				     RepImpFlag="Y"
					$.messager.alert("提示:","已经重点关注！");
					return;
				}
			     if(RepImpFlag=="未关注"){
				     RepImpFlag="N"
			
				} 
				if(typecode=="drug"){ //药品
				//保存数据
				$.post(url+'?action=REPImpReport',{"ID":ID,"RepImpFlag":RepImpFlag},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
				 });
				}
				if(typecode=="blood"){//输血
				//保存数据
				$.post(url+'?action=BloodImpReport',{"ID":ID,"RepImpFlag":RepImpFlag},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
				 });
				}
				if(typecode=="med"||typecode=="bldevent"){ //医疗
				//保存数据
				$.post(url+'?action=MedImpReport',{"ID":ID,"RepImpFlag":RepImpFlag},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
				 });
				}
				if(typecode=="material"){//器械
				//保存数据
				$.post(url+'?action=MaterImpReport',{"ID":ID,"RepImpFlag":RepImpFlag},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
				 });
				}
				if(typecode=="drugerr"){//用药错误
				//保存数据
				$.post(url+'?action=DrugerImpReport',{"ID":ID,"RepImpFlag":RepImpFlag},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
				 });
				}
		
			})
			$('#maindg').datagrid('reload'); //重新加载
		}
	})
}


//初始化报告列表
function InitRepList()
{
	//定义columns   
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:'Medadrreceive',title:'接收状态',width:80},
		{field:'Medadrreceivedr',title:'接收状态dr',width:80,hidden:true},
		{field:'RepShareFlag',title:'分享状态',width:100,align:'center'},
		{field:'Edit',title:'修改',width:80,align:'center',formatter:setCellEditSymbol,hidden:false},
		{field:'AuditList',title:'审批明细',width:80,align:'center',formatter:setCellAuditList,hidden:false},
		{field:'RepImpFlag',title:'重点关注',width:100,align:'center',formatter:setCellColorOne,hidden:false},
		{field:'CreateDate',title:'报告日期',width:100},
		{field:'RepNo',title:'报告编号',width:160},
		{field:'PatNo',title:'登记号',width:120},
		{field:'PatName',title:'姓名',width:120},
		{field:'Status',title:'当前状态',width:100,hidden:false},
		{field:'StatusID',title:'当前状态ID',width:100,hidden:true},
		{field:'StatusNext',title:'下一状态',width:100,hidden:false},
		{field:'StatusNextID',title:'下一状态ID',width:100,hidden:true},
		{field:'LocDesc',title:'报告科室',width:220},
		{field:'Typeevent',title:'报告类型',width:220},
		{field:'Creator',title:'报告人',width:120},
		{field:'typecode',title:'报告类型代码',width:120},
		{field:'Subflag',title:'子表标志',width:120,hidden:true},
		{field:'catDesc',title:'一级分类',width:100,hidden:false},
		{field:'armaCatDesc',title:'二级分类',width:100,hidden:false},
		{field:'armaLevelDesc',title:'事件等级',width:100,hidden:false},
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
	        if (row.Medadrreceivedr==2){  
	            return 'background-color:red;';  
	        }  
    	},
        onSelect:function(rowIndex, rowData){  
			var reportID=rowData.ID;         //报表ID
			var typecode=rowData.typecode;         //报告类型
			var params=reportID+"^"+typecode+"^"+LgUserID;
			var Subflag=rowData.Subflag;
			var SubUserflag=""
	        $.ajax({
				type: "POST",// 请求方式
		    	url: url,
				async: false, //同步
		    	data: "action=SearchAuditIUser&params="+params,
				success: function(data){
					SubUserflag=data;
				}
			});
			if((Subflag==1)&&(SubUserflag==1)){
				$('#REceive').hide();
				$('#back').hide();
				$('#RepImpFlag').hide();
				$('#SHare').hide();
				$('#audit').hide();
			}else{
				$('#REceive').show();
				$('#back').show();
				$('#RepImpFlag').show();
				$('#SHare').show();
				$('#audit').show();
			}
		}  
	});
	
	initScroll("#maindg");//初始化显示横向滚动条
}

///设置编辑连接
function setCellEditSymbol(value, rowData, rowIndex)
{
		var ID=rowData.ID;         //报表ID
		var typecode=rowData.typecode; //报告类型代码
		return "<a href='#' onclick=\"showEditWin('"+ID+"','"+typecode+"')\"><img src='../scripts/dhcadvEvt/images/editb.png' border=0/></a>";
}

///设置列前景色（重点关注）
function setCellColorOne(value, rowData, rowIndex)
{     
     var RepImpFlag=rowData.RepImpFlag
     if(RepImpFlag=="关注"){
     
	   return '<span style="color:yellow;">'+value+'</span>';
     }else{
	     
	   return  value;
	 }
}

///设置列前景色
function setCellColor(value, rowData, rowIndex)
{
	return '<span style="color:red;">'+value+'</span>';;
}

//编辑窗体
function showEditWin(ID,typecode)
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
	if(typecode=="material"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.matareport.csp?matadrID='+ID+'&editFlag='+1+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	if(typecode=="drugerr"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medsafetyreport.csp?medsrID='+ID+'&editFlag='+1+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	if(typecode=="blood"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.bloodreport.csp?bldrptID='+ID+'&editFlag='+1+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	
	if(typecode=="med"||typecode=="bldevent"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medicalreport.csp?adrRepID='+ID+'&editFlag='+1+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	if(typecode=="drug"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.advreport.csp?advdrID='+ID+'&editFlag='+1+'"></iframe>';
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
			alert(filePath)
			if (typeof filePath=="undefined"){
				$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择路径后,重试！</font>","error");
				return;
			}
			$.each(selItems, function(index, item){
		
				var ID=item.ID;         //报表ID
				var typecode=item.typecode; //报告类型代码
				ExportExcel(ID,typecode,filePath);
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
				var typecode=item.typecode; //报告类型代码
				printRep(ID,typecode);
			})
		}
	})
}
//转抄  2016-05-13 增加
function Transcription()
{	
	TranFlag=0;
	//清空输入框
	$('#medadrUser').attr("disabled",false);
	$('#medadrDateTime').attr("disabled",false);
	$("#tranLocAdvic").attr("disabled",false);
	$("#medadrUser").val("");
	$("#medadrDateTime").val("");
	$("#tranLocAdvic").val("");
	$("#tranLocDr").combobox('setValue',"");
	$("#tranReplyMess").val("");

	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("提示:","转抄操作,请只选择一行数据！");
		return;
	}
	$.messager.confirm("提示", "是否进行转抄操作", function (res) {//提示是否删除
		if (res) {

			$('#TranWin').window({
				title:'转抄',
				collapsible:false,
				border:false,
				closed:false,
				width:900,
				height:580
			});
			$('#TranWin').window('open');
		}
	})
	$.each(selItems, function(index, item){
		var reportID=item.ID;         //报表ID
		var typecode=item.typecode;         //报告类型
		var params=reportID+"^"+typecode;
		var Subflag=item.Subflag;         //子表标志
		
		TranUserList(reportID,typecode,Subflag);//转抄指向人员
		TranLocUserList(reportID,typecode,Subflag);//转抄科室人员意见信息
		
		if(Subflag==0){
			//清空输入框
			$('#medadrUser').attr("disabled",false);
			$('#medadrDateTime').attr("disabled",false);
			$("#tranLocAdvic").attr("disabled",false);
			$("#medadrUser").val("");
			$("#medadrUser").attr("disabled",true);
			$("#medadrDateTime").val("");
			$("#medadrDateTime").attr("disabled",true);
			$("#tranLocAdvic").val("");
			$("#tranLocDr").combobox('setValue',"");
			$("#tranReplyMess").val("");
			$("#tranReplyMess").attr("disabled",true);
		}
		$.ajax({
			type: "POST",// 请求方式
	    	url: url,
	    	data: "action=SearchAuditMess&params="+params,
			success: function(data){
				var tmp=data.split("^");
				if(Subflag==1){
					$('#medadrUser').val(tmp[0]); //处理人员
					$('#medadrUser').attr("disabled","true");
					$('#medadrDateTime').val(tmp[1]+" "+tmp[2]);   //处理时间
					$('#medadrDateTime').attr("disabled","true");
					$('#tranLocAdvic').val(tmp[3]); //处理意见
					$('#tranLocAdvic').attr("disabled","true");
					//var UserID=rowData.UserID;
					if (tmp[5]!=LgUserID){
						errflag=1;
						$("#tranLocDr").combobox('setValue',"");
					}else{
						errflag=0;
					}
		
				}
				else{
					errflag=0;
				}
			}
		});
		if(Subflag==1){
			$('#transub').hide();
			$('#tranreply').show();
			$('#tranrec').show();
	
		}else{
			$('#transub').show();
			$('#tranreply').hide();
			$('#tranrec').hide();
	    }
   });
	
}
//转抄指向人员
function TranUserList(reportID,typecode,Subflag)
{
	//转抄科室
	$('#tranLocDr').combobox({
		url:url+'?action=SelAllLoc',
		onSelect:function(){
			var tranLocDr=$('#tranLocDr').combobox('getValue');
			var params=typecode+"^"+tranLocDr;
			$('#selectdg').datagrid({
				url:url+'?action=GetUserDr',	
				queryParams:{
					params:params}
			});
		}
	}); 
	//定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:"LocID",title:'LocID',width:90,hidden:true},
		{field:"Locname",title:'Locname',width:90,hidden:true},
		{field:"UserID",title:'UserID',width:90,hidden:true},
		{field:'Username',title:'科室人员',width:120}
	]];
	var titleNotes="";
	if(Subflag==1){
		titleNotes="";
	}else{
		titleNotes='<span style="font-size:10pt;font-family:华文楷体;color:red;">[双击行即可添加至转抄数据表]</span>';
	}
	//定义datagrid
	$('#selectdg').datagrid({
		title:'指向人员'+titleNotes,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		border:false,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){ 
			if((Subflag==1)||(TranFlag==1)){
				$('#selectdg').datagrid({title:'指向人员'});
				return;
			}else{
				$('#selectdg').datagrid({title:'指向人员'+titleNotes});
				if ((editRow != "")||(editRow == "0")) {
	            	$("#selectdg").datagrid('endEdit', editRow);
				}
				var LocID=rowData.LocID;
				var UserID=rowData.UserID;
				var Username=rowData.Username;
			
				var tranLocDr=$('#tranLocDr').combobox('getValue');
				var tranLocDesc=$('#tranLocDr').combobox('getText');
				$('#tranmesdg').datagrid('insertRow',{
					 index: 0,	// index start with 0
					 row: {
						ID:"",
						name: Username,
						nameID: UserID,
						LocDesc: tranLocDesc,
						LocDr: tranLocDr
					}
		        });
		    }
		}
     
	});
	var params=reportID+"^"+typecode;
	$('#selectdg').datagrid({
		url:url+'?action=QueryUserMess',
		queryParams:{
			params:params}
	});
}
//转抄科室人员意见信息
function TranLocUserList(reportID,typecode,Subflag)
{
	//定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:"tranDateTime",title:'转抄时间',width:90,hidden:true},
		{field:'tranuser',title:'转抄人',width:120,hidden:true},
		{field:"tranuserID",title:'tranuserID',width:90,hidden:true},
		{field:'LocDesc',title:'科室',width:120},
		{field:"LocDr",title:'LocDr',width:90,hidden:true},
		{field:'name',title:'人员',width:120},
		{field:"nameID",title:'nameID',width:90,hidden:true},
		{field:'advice',title:'人员意见',width:300},
		{field:"tranreceive",title:'接收状态',width:90,hidden:true},
		{field:"tranrecedate",title:'接收日期',width:90,hidden:true},
		{field:"trancompdate",title:'完成日期',width:90,hidden:true}
	]];
	var titleOpNotes="";
	if(Subflag==1){
		titleOpNotes="";
	}else{
		titleOpNotes='<span style="font-size:10pt;font-family:华文楷体;color:red;">[双击行即可清除此条数据]</span>';
	}
	//定义datagrid
	$('#tranmesdg').datagrid({
		title:'转抄信息表'+titleOpNotes,
		url:'',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
        nowrap:false,
		onDblClickRow:function(rowIndex, rowData){  //双击清除选中行
			if((Subflag==1)||(TranFlag==1)){
				return;
			}else{
				$('#tranmesdg').datagrid('deleteRow',rowIndex);
			}
		}
	});
	var params=reportID+"^"+typecode;
	$('#tranmesdg').datagrid({
		url:url+'?action=QueryTranLocUser',	
		queryParams:{
			params:params}
	});
}
//转抄提交
function TranSub()
{
	if(TranFlag==1){
		$.messager.alert("提示:","已提交成功，请勿重复点击");
		return;
	}
	if(errflag==1){
		$.messager.alert("提示:","非转抄被指向人员，无权限操作");
		return;
	}
	var tranLocDr=$('#tranLocDr').combobox('getValue');
	var tranLocAdvic=$('#tranLocAdvic').val();
	var tranReplyMess=$('#tranReplyMess').val();
	var mediReceive="",mediRecDate="",mediRecTime="",mediCompleteDate="",mediCompleteTime="",medadrList="";	
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	$.each(selItems, function(index, item){
		var reportID=item.ID;         //报表ID
		var typecode=item.typecode; //报告类型代码
		var Medadrreceivedr=item.Medadrreceivedr;//接收状态
		var StatusNextID=item.StatusNextID; //下一个状态
		var StatusID=item.StatusID //当前状态
		medadrList=reportID+"^"+typecode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+Medadrreceivedr+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+StatusID;   //参数串
	})		
	var rows = $("#tranmesdg").datagrid('getRows');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].LocDr=="")||(rows[i].nameID=="")){
			$.messager.alert("提示","科室指向或人员不能为空!"); 
			return false;
		}
		if(tranLocAdvic==""){
			$.messager.alert("提示","处理意见不能为空!"); 
			return false;
		}
		var List=rows[i].ID+"^"+LgUserID+"^"+rows[i].LocDr+"^"+rows[i].nameID+"^"+tranReplyMess+"^"+mediReceive+"^"+mediRecDate+"^"+mediRecTime+"^"+mediCompleteDate+"^"+mediCompleteTime+"^"+tranLocAdvic;
		dataList.push(List);
	} 
	var medadriList=dataList.join("&&");
	var params="medadrList="+medadrList+"&medadriList="+medadriList; 
	//alert(params);
	//保存数据
	$.post(url+'?action=SaveTranMess',{"medadrList":medadrList,"medadriList":medadriList},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode==0){
			TranFlag=1;
			$.messager.alert("提示:","提交成功");
			$('#maindg').datagrid('reload'); //重新加载
		}
		if(resobj.ErrCode < 0){
			$.messager.alert("提示:","<font style='font-size:20px;'>转抄提交错误,错误原因:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
			return ;
		}
		$('#selectdg').datagrid('reload'); //重新加载
		$('#tranmesdg').datagrid('reload'); //重新加载
		
	});
			
}
//转抄回复
function TranReply(Replyflag)
{
	var tranLocDr=$('#tranLocDr').combobox('getValue');
	var tranLocAdvic=$('#tranLocAdvic').val();
	var tranReplyMess=$('#tranReplyMess').val();
	var medadriList=LgUserID+"^"+tranReplyMess+"^"+Replyflag;
	if((TranFlag==1)&(Replyflag==1)){
		$.messager.alert("提示:","已提交成功，请勿重复点击");
		return;
	}
	if((TranFlag==2)&(Replyflag==0)){
		$.messager.alert("提示:","已接收成功，请勿重复点击");
		return;
	}
	if((TranFlag==1)&(Replyflag==0)){
		$.messager.alert("提示:","回复已提交，接收无效");
		return;
	}
	if(errflag==1){
		$.messager.alert("提示:","非转抄被指向人员，无权限操作");
		return;
	}
	if((Replyflag==1)&(tranReplyMess=="")){
		$.messager.alert("提示:","回复提交操作，回复内容不能为空");
		return;
	}
	if((Replyflag==0)&(tranReplyMess!="")){
		$.messager.alert("提示:","接收操作，回复内容不填");
		return;
	}
	var selItems = $('#maindg').datagrid('getSelections');
	var medadrList="";
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	$.each(selItems, function(index, item){
		var reportID=item.ID;         //报表ID
		var typecode=item.typecode; //报告类型代码
		var Medadrreceivedr=item.Medadrreceivedr;//接收状态
		var StatusNextID=item.StatusNextID; //下一个状态
		medadrList=reportID+"^"+typecode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+Medadrreceivedr+"^"+StatusNextID;   //参数串
		//var params="medadrList="+medadrList+"&medadriList="+medadriList; 
	})
	//alert(params);
	//保存数据
	$.post(url+'?action=SaveReplyMess',{"medadrList":medadrList,"medadriList":medadriList},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode==0){
			if(Replyflag==0){
				TranFlag=2;
			}
			if(Replyflag==1){
				TranFlag=1;
				$('#maindg').datagrid('reload'); //重新加载
			}
			$.messager.alert("提示:","操作成功");
		}
		if(resobj.ErrCode < 0){
			$.messager.alert("提示:","<font style='font-size:20px;'>操作错误,错误原因:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
		}
		$('#selectdg').datagrid('reload'); //重新加载
		$('#tranmesdg').datagrid('reload'); //重新加载
		
	});
		
}
/* //转抄接收
function TranRec()
{
	var tranLocDr=$('#tranLocDr').combobox('getValue');
	var tranLocAdvic=$('#tranLocAdvic').val();
	var tranReplyMess="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	$.each(selItems, function(index, item){
		var reportID=item.ID;         //报表ID
		var typecode=item.typecode; //报告类型代码
		var Medadrreceivedr=item.Medadrreceivedr;//接收状态
		var StatusNextID=item.StatusNextID; //下一个状态
		var medadrList=reportID+"^"+typecode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+Medadrreceivedr+"^"+StatusNextID;   //参数串
		var medadriList=LgUserID+"^"+tranReplyMess;
		var params="medadrList="+medadrList+"&medadriList="+medadriList; 
		//保存数据
		$.post(url+'?action=SaveTranMess',{"medadrList":medadrList,"medadriList":medadriList},function(jsonString){
			var resobj = jQuery.parseJSON(jsonString);
			if(resobj.ErrCode==0){
				$.messager.alert("提示:","接收成功");
			}
			if(resobj.ErrCode < 0){
				$.messager.alert("提示:","<font style='font-size:20px;'>接收错误,错误原因:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
			}
		});
	})	
} */

///设置审批明细连接  2016-05-31
function setCellAuditList(value, rowData, rowIndex)
{
		var ID=rowData.ID;         //报表ID
		var typecode=rowData.typecode; //报告类型代码
		return "<a href='#' onclick=\"showAuditListWin('"+ID+"','"+typecode+"')\"><img src='../scripts/dhcadvEvt/images/viewlist.png' border=0/></a>";
}
//编辑窗体
function showAuditListWin(ID,typecode)
{
	$('#Auditwin').window({
		title:'审批明细',
		collapsible:true,
		border:false,
		closed:"true",
		width:900,
		height:500
	});
	var columns=[[
		{field:'Status',title:'报告状态',width:80},
		{field:'StatusDR',title:'报告状态ID',width:100,hidden:true},
		{field:'AuditUser',title:'审批人',width:100},
		{field:'AuditUserDR',title:'审批人ID',width:100,hidden:true},
		{field:'AuditDateTime',title:'审批日期',width:150},
		{field:'NextLoc',title:'科室指向',width:150},
		{field:'NextLocDR',title:'科室指向ID',width:100,hidden:true},
		{field:'LocAdvice',title:'科室意见',width:200},
		{field:'Receive',title:'接收状态',width:60},
		{field:'Subflag',title:'Subflag',width:60,hidden:true},
		{field:'ID',title:'ID',width:50,hidden:true} 
	]]; 
	
	// 定义columns
	var itmcolumns=[[
		{field:'MedIAuditDateTime',title:'审批日期',width:150},
		{field:'MedIAuditUser',title:'审批人',width:100},
		{field:'MedIAuditUserDR',title:'审批人ID',width:100,hidden:true},
		{field:'MedINextLoc',title:'指向科室',width:150},
		{field:'MedINextLocDR',title:'科室指向ID',width:100,hidden:true},
		{field:'MedILocAdvice',title:'科室意见',width:200},
		{field:'MedINextUser',title:'指向人员',width:100},
		{field:'MedINextUserDR',title:'指向人员ID',width:100,hidden:true},
		{field:'MedIUserAdvice',title:'人员意见',width:200},
		{field:'MedIReceive',title:'接收状态',width:60},
		{field:'MedIReceiveDateTime',title:'接收日期',width:150},
		{field:'MedICompleteDateTime',title:'完成日期',width:150}
	]];
	var params=ID+"^"+typecode;
	//定义datagrid
	$('#AuditListdg').datagrid({
		url:url+'?action=QueryAuditMess&params='+params,
		fit:true,
		rownumbers:true,
		columns:columns,
		//fitColumns:true,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
        view: detailview,
        subGrid: true,
        nowrap:false,
        detailFormatter:function(index,rowData){
	         if(rowData.Subflag==0) return "";
             return '<div style="padding:0px"><table class="AuditItmListdg"></table></div>';
        },
        onExpandRow:function(index,rowData){
          	var AuditID=rowData.ID;
            var Subflag=rowData.Subflag;
            if(Subflag==0){
	         	return;   
	         }
            if (Subflag==1){
            var AuditItmListdg = $(this).datagrid('getRowDetail',index).find('table.AuditItmListdg');
            AuditItmListdg.datagrid({
				url:url+'?action=QueryAudItmMess&params='+AuditID,
				columns:itmcolumns,
                singleSelect:false,
                rownumbers:true,
				loadMsg: '正在加载信息...',
                height:'auto',
                nowrap:false,
		        onResize:function(){
                    $('#AuditListdg').datagrid('fixDetailRowHeight',index);
                },
                onLoadSuccess:function(){
					setTimeout(function(){
						$('#AuditListdg').datagrid('fixDetailRowHeight',index);
                    },0);
                }
            });
            $('#AuditListdg').datagrid('fixDetailRowHeight',index);
	      } 
        },
        onLoadSuccess:function(data){
			var me = this;
			$(me).parent().find('span.datagrid-row-expander').trigger('click'); //没效果注意修改这里的选择器
		}
	});
	$('#Auditwin').window('open');
	
}

// 审核导出
function ExportAudit()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('提示',"<font style='color:red;font-weight:bold;font-size:20px;'>请先选择一行记录!</font>","error");
		return;
	}
	
	$.messager.confirm("提示", "是否进行审核导出操作", function (res) {//提示是否删除
		if (res) {
			var filePath=browseFolder();
			if (typeof filePath=="undefined"){
				$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择路径后,重试！</font>","error");
				return;
			}
			//$.each(selItems, function(index, item){
		
				//var ID=item.ID;         //报表ID
				//var typecode=item.typecode; //报告类型代码
				ExportExcelAudit(filePath);
			//})
	
			$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
		}
	})
}

// 审核导出Excel
function ExportExcelAudit(filePath)
{
	alert(filePath)
/* 	if(ID==""){
		$.messager.alert("提示:","报表ID为空！");
		return;
	}
	
 */  
       //获取系统的日期
    var now = new Date();
    var year = now.getFullYear();       //年
    var month = now.getMonth() + 1;     //月
    if(month<=9){
	    month="0"+month
	} 
    var day = now.getDate();            //日
    if(day<=9){
     day="0"+day
    } 
    var  yearDate=year+""+month+""+day
   	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID=$('#dept').combobox('getValue');     //科室ID
	var status=$('#status').combobox('getValue');  //状态
	var typeevent=$('#typeevent').combobox('getValue');  //报告类型
	var receive=$('#receive').combobox('getValue');  //接收状态
	var statShare=$('#Share').combobox('getValue');  //分享状态 
	if (LocID==undefined){LocID="";}
	if (status==undefined){status="";}
	if (typeevent==undefined){typeevent="";}
	if (receive==undefined){receive="";}
	if (statShare==undefined){statShare="";}
	var PatNo=$.trim($("#patno").val());
	
	var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+receive+"^"+statShare;
	  alert(params)
		var retval=tkMakeServerCall("web.DHCADVSEARCHREPORT","QueryMataRepExport",params);
		if(retval==""){
			$.messager.alert("提示:","取数据错误！");
			return;
		 }
		 
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_AuditReport.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		//xlApp.Range(objSheet.Cells(2,1),objSheet.Cells(2,16)).Interior.Pattern = 2; //列表标题背景颜色  
	    var auditRepItmArr=retval.split("&&");
	    for(var k=0;k<auditRepItmArr.length;k++){
			var auditArr=auditRepItmArr[k].split("^");
			var auditArr=auditRepItmArr[k].split("^");
			objSheet.Cells(3+k,1).value=auditArr[1]; //上报科室
			objSheet.Cells(3+k,2).value=auditArr[2]; //上报日期
			objSheet.Cells(3+k,3).value=auditArr[3]; //病案号
			objSheet.Cells(3+k,4).value=auditArr[4]; //患者姓名
			objSheet.Cells(3+k,5).value=auditArr[17]; //患者性别
			objSheet.Cells(3+k,6).value=auditArr[18]; //患者年龄
			objSheet.Cells(3+k,7).value=auditArr[5]; //改进建议
			objSheet.Cells(3+k,8).value=auditArr[6]; //联系电话
			objSheet.Cells(3+k,9).value=auditArr[7]; //上报人
			objSheet.Cells(3+k,10).value=auditArr[19]; //上报人职业类别
			objSheet.Cells(3+k,11).value=auditArr[20]; //上报人职称
			objSheet.Cells(3+k,12).value=auditArr[8]; //事件发生地点
			objSheet.Cells(3+k,13).value=auditArr[9]; //事件过程描述
			objSheet.Cells(3+k,14).value=auditArr[10]; //存在隐患
			objSheet.Cells(3+k,15).value=auditArr[11]; //事件类型
			objSheet.Cells(3+k,16).value=auditArr[12]; //事件等级
			objSheet.Cells(3+k,17).value=auditArr[13]; //一级分类
			objSheet.Cells(3+k,18).value=auditArr[14]; //二级分类
			objSheet.Cells(3+k,19).value=auditArr[15]; //主管部门意见陈述
			objSheet.Cells(3+k,20).value=auditArr[16]; //持续改进措施 
	 
	    }
		
		xlBook.SaveAs(filePath+"不良事件与病人安全隐患上报及处理情况"+yearDate+".xls");
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;

}
