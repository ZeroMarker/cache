// Creator: congyue
/// CreateDate: 2017-07-28
//  Descript: 不良事件升级 审核界面
var url = "dhcadv.repaction.csp";
var statShare = [{ "val": "未分享", "text": "未分享" },{ "val": "分享", "text": "分享" }];
var statReceive = [{ "val": "未接收", "text": "未接收" },{ "val": "1", "text": "接收" },{ "val": "2", "text": "驳回" },{ "val": "3", "text": "撤销" },{ "val": "4", "text": "审核" },{ "val": "5", "text": "归档" },{ "val": "6", "text": "撤销归档" }];
var statusstr = [{ "value": "全部", "text": "全部" },{ "value": "1", "text": "填报" },{ "value": "2", "text": "护士长审核" },{ "value": "3", "text": "科护士长审核" },{ "value": "4", "text": "护理部审核" }];
var statOverTime = [{ "val": "Y", "text": "超时" },{ "val": "N", "text": "未超时" }];
var Active = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];
var editRow="",TranFlag=0,errflag=0 ;///TranFlag:转抄标志   errflag:转抄回复人员与被转抄人员是否一致
var loceditRow=0;
var StrParam="";
var StDate="";  //formatDate(-7);  //一周前的日期   2018-01-26 修改，默认开始日期为上线使用日期，即2018-01-01
var EndDate=formatDate(0); //系统的当前日期
var audittitle="" ;
$(function(){ 
	if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY
		StDate="01"+"/"+"01"+"/"+2018;  //当年开始日期
	}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
		StDate=2018+"-"+"01"+"-"+"01";  //当年开始日期
	}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
		StDate="01"+"/"+"01"+"/"+2018;  //当年开始日期
	}
	//去弹窗背景层hxy 08-30
	$("#ConfirmAudit,#CancelAudit,#CancelReject,#CancelFile,#CancelCanFile").click(function(){
	 	$("#showalert").hide();
	});
	/*document.onkeydown = function(e){ 
    var ev = document.all ? window.event : e;
    	if(ev.keyCode==13) {
			commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
     	}
	}*/
	
	//接收
	$('#receive').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:statReceive
	});

/* 	//科室
	$('#dept').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		url:url+'?action=SelAllLoc'
		
	}); */
	
	var UserId="";
	if((LgGroupDesc=="护理部")||(LgGroupDesc=="Nursing Manager")){
		UserId="";
	}else{
		UserId=LgUserID;
	}
	$('#dept').combobox({ //  yangyongtao   2017-11-17
		mode:'remote',  //必须设置这个属性
		onShowPanel:function(){ //GetSecuGroupCombox(UserId)
			$('#dept').combobox('reload','dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetSecuGroupCombox&UserId='+UserId+'&GroupId='+LgGroupID+'&LocId='+LgCtLocID+'')
		}
	});
	if(LgGroupDesc=="住院护士"){
		$('#dept').combobox({disabled:true});;  //科室ID
		$('#dept').combobox("setValue",LgCtLocID);     //科室ID
		$("#dept").combobox('setText',LgCtLocDesc);
	}
	//报告的类型类型zhaowuqiang   2016-09-22
	$('#typeevent').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		url:url+'?action=SelEventbyNew'
		/* onSelect: function(rec){  
           var TypeStatus=rec.value; 
			ComboboxEvent(TypeStatus);        
	  } */	  
	}); 
	//报告的类型状态
    $('#status').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		//url:url+'?action=SelEvtStatusbyNew&params='+TypeStatus
		data:statusstr
	});
	//分享状态
	$('#Share').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:statShare
	});
	//超时状态
	$('#OverTime').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:statOverTime
	});
	//首页 报告管理联动
	StrParam=getParam("StrParam");
	audittitle=getParam("audittitle");
	if(StrParam!=""){
		var tmp=StrParam.split("^");
		$("#stdate").datebox("setValue", tmp[0]);  //Init起始日期
		$("#enddate").datebox("setValue", tmp[1]);  //Init结束日期
		if(tmp[2]!=""){
			$('#dept').combobox({disabled:true});;  //科室ID
			$('#dept').combobox("setValue",tmp[2]);     //科室ID
			$("#dept").combobox('setText',LgCtLocDesc);
		}else{
			$('#dept').combobox("setValue",tmp[2]);     //科室ID
			$("#dept").combobox('setText',"")
		}
		$('#status').combobox("setValue",tmp[7]);  //状态
		$('#typeevent').combobox("setValue",tmp[8]);  //报告类型
		$('#receive').combobox("setValue",tmp[9]); //接收状态
		$('#Share').combobox("setValue",tmp[10]);  //分享状态 
	
	}else{
		$("#stdate").datebox("setValue", StDate);  //Init起始日期
		$("#enddate").datebox("setValue", EndDate);  //Init结束日期
	}
	$('#audittitle').html("报告审核查询"+audittitle);
	if((LgGroupDesc=="护理部")||(LgGroupDesc=="Nursing Manager")){
		$('#Auditbttr').show();
	}else{
		$('#Auditbttr').hide();
	}
	
	$('#Refresh').bind("click",Query);  //刷新
	$('#Find').bind("click",Query);  //点击查询 
	$('#Export').bind("click",Export);  //点击导出(动态导出)
	$('#ExportWord').bind("click",ExportWord);  //点击导出(卫计委wprd数据)	
	$('#ExportExcel').bind("click",ExportExcel);  //点击导出(卫计委excel数据)
	$('#ExportExcelAll').bind("click",ExportExcelAll);  //点击导出(医管局excel数据)
	$('#ExportAll').bind("click",ExportAll);  //点击导出(全部类型固定数据)
	$('#ExportGather').bind("click",ExportGather);  //点击导出(汇总版)
	$('#Print').bind("click",Print); //打印
	$('#REceive').bind("click",REceive); //接收
	//$('#Back').bind("click",Back); //报告驳回
	
	$('#Reject').bind("click",BackBt); //报告驳回  
	$('#Back').bind("click",RejectWin); //驳回
	
	$('#SHare').bind("click",Share); //分享状态  RepShareStatus
	$('#RepImpFlag').bind("click",RepImpFlag); //重点关注
	$('#Audit').bind("click",Audit); //审批 Audit
	$('#ConfirmAudit').bind("click",ConfirmAudit); //确认审批 ConfirmAudit
	$('#Transcription').bind("click",Transcription); //转抄操作	
	$('#File').bind("click",File); //归档操作	
	$('#ConfirmFile').bind("click",ConfirmFile); //确认归档 
	$('#ConfirmCanFile').bind("click",ConfirmCanFile); //确认撤销归档 
	$('#RepCancel').bind("click",RepCancel); //作废 
	$('#CaseShare').bind("click",CaseShare); //案例共享 
	$('#RepDelete').bind("click",RepDelete); //删除 
	
	InitPatList();
	
	$("#reqList").height($(window).height()-245)//hxy 08-28 st
	$("#maindg").datagrid('resize', {           
		height : $(window).height()-245
    }); 
    window.onresize=resizeH;                    //hxy 08-28 ed
	$('#WardW').window('close');  //2018-01-12 cy 添加分管科室
});
//自适应 hxy 2017-08-28
function resizeH(){
	$("#reqList").height($(window).height()-245)
	$("#maindg").datagrid('resize', { 
            height : $(window).height()-245
    }); 
}
//根据报告类型查询  zhaowuqiang   2016-09-22
function ComboboxEvent(TypeStatus){
   //报告的类型状态
    $('#status').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		url:url+'?action=SelEvtStatusbyNew&params='+TypeStatus
	});    

}
//初始化报告列表
function InitPatList()
{
	//定义columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"RepID",title:'RepID',width:80,hidden:true},
		{field:"recordID",title:'recordID',width:80,hidden:true},
		{field:'RepShareStatus',title:'分享状态',width:80,align:'center',hidden:true},
		{field:'Edit',title:'查看',width:60,align:'center',formatter:setCellEditSymbol,hidden:false},
		{field:'AuditList',title:'审批明细',width:60,align:'center',formatter:setCellAuditList,hidden:false},
		{field:'StatusLast',title:'上一状态',width:100,hidden:true},
		{field:'StatusLastID',title:'上一状态ID',width:100,hidden:true},
		{field:"RepStaus",title:'报告状态',width:100,hidden:false},
		{field:"RepStausDr",title:'报告状态ID',width:90,hidden:true},
		{field:'StatusNext',title:'下一状态',width:100,hidden:true},
		{field:'StatusNextID',title:'下一状态ID',width:100,hidden:true},
		{field:'RepDate',title:'报告日期',width:100},
		{field:'Medadrreceive',title:'接收状态',width:100},
		{field:'Medadrreceivedr',title:'接收状态dr',width:80,hidden:true},
		{field:'PatID',title:'登记号',width:100,hidden:false},		
		{field:'AdmNo',title:'病案号',width:100},
		{field:'PatName',title:'姓名',width:100},
		{field:'RepType',title:'报告类型',width:260},
		{field:'OccurDate',title:'发生日期',width:100},
		{field:'OccurLoc',title:'发生科室',width:130},
		{field:'LocDep',title:'报告系统',width:150},
		{field:'RepLoc',title:'报告科室',width:130},	
		{field:'RepUser',title:'报告人',width:100},	
		{field:'RepTypeCode',title:'报告类型代码',width:120,hidden:true},
		{field:'RepImpFlag',title:'重点关注',width:100,hidden:false},
		{field:'RepSubType',title:'报告子类型',width:120,hidden:true},
		{field:'Subflag',title:'子表标志',width:120,hidden:true},
		{field:'SubUserflag',title:'子表用户标志',width:120,hidden:true},
		{field:'RepLevel',title:'不良事件级别',width:120,hidden:true},
		{field:'RepInjSev',title:'伤害严重度',width:120,hidden:true},
		{field:'RepTypeDr',title:'报告类型Dr',width:120,hidden:true},
		{field:'StsusGrant',title:'审核标识',width:120,hidden:true},
		{field:'MedadrRevStatus',title:'驳回指向',width:120,hidden:true},
		{field:'StaFistAuditUser',title:'被驳回人',width:120,hidden:true},
		{field:'BackAuditUser',title:'驳回操作人',width:120,hidden:true},
		{field:'RepOverTimeflag',title:'填报超时',width:120,hidden:false},
		{field:'AutOverTimeflag',title:'护士长审核超时',width:120,hidden:false},
		{field:'CaseShareLoclist',title:'共享科室',width:120,hidden:false},
		{field:'FileFlag',title:'归档状态',width:80}

	]];
	
	//定义datagrid
	$('#maindg').datagrid({
		toolbar: '#toolbar',//hxy add 08-28
		title:'', //hxy 报告列表
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryAuditRepList'+'&StrParam='+StrParam,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		nowrap:false,
		//height:300,
		rowStyler:function(index,row){  
	        if ((row.StaFistAuditUser==LgUserName)||(row.BackAuditUser==LgUserName)){  
	            return 'background-color:red;';  
	        }  
    	},
        onSelect:function(rowIndex, rowData){  
        	var StsusGrant=rowData.StsusGrant; //审核状态 2018-01-17
			var RepID=rowData.RepID;         //报表ID
			var RepTypeCode=rowData.RepTypeCode;         //报告类型
			var params=RepID+"^"+RepTypeCode+"^"+LgUserID;
			var Subflag=rowData.Subflag;
			var SubUserflag=rowData.SubUserflag;
			if(StsusGrant=="1"){ //2018-01-17
				$('#Audit').attr('class','toolbar-auditUndo');
				$('#Audit').text(" 撤销审核");
            }else{
				$('#Audit').attr('class','toolbar-audit');
				$('#Audit').text(" 审核");            
	        }
			if((Subflag==1)&&(SubUserflag==1)){
				$('#REceive').hide();
				$('#Back').hide();
				$('#RepImpFlag').hide();
				//$('#SHare').hide();
				$('#Audit').hide();
			}else{
				$('#REceive').show();
				$('#Back').show();
				$('#RepImpFlag').show();
				//$('#SHare').show();
				$('#Audit').show();
			}
			var RepImpFlag=rowData.RepImpFlag;    //重点关注
	        var RepShareStatus=rowData.RepShareStatus; //分享状态
        	
		    if ((RepImpFlag=="关注")){
				$('#RepImpFlag').attr('class','toolbar-focusUndo');
				$('#RepImpFlag').text(" 取消关注");
		    }else{
				$('#RepImpFlag').attr('class','toolbar-focus');
				$('#RepImpFlag').text(" 重点关注");
		    }
		    var FileFlag=rowData.FileFlag; //归档状态
		    if ((FileFlag=="已归档")){
				$('#File').attr('class','toolbar-fileUndo');
				$('#File').text(" 撤销归档");
		    }else{
				$('#File').attr('class','toolbar-file');
				$('#File').text(" 归档");
		    }
	    
		    /* if ((RepShareStatus=="分享")){
				$('#SHare').attr('class','adv_sel_71');
				$('#SHare').text(" 撤销分享");
			}else{
				$('#SHare').attr('class','adv_sel_7');
				$('#SHare').text(" 分享");
			} */
		}  
	});
	if(StrParam==""){
		Query();
	}
	//initScroll("#maindg");//初始化显示横向滚动条
}
function Query()
{
	//1、清空datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	if((audittitle!="")&&(LgGroupDesc=="住院护士")){
		$('#dept').combobox("setValue",LgCtLocID);     //科室ID
		$("#dept").combobox('setText',LgCtLocDesc);
	}
	//2、查询
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID=$('#dept').combobox('getValue');     //科室ID
	var status=$("#status").combobox('getValue');
	var typeevent=$('#typeevent').combobox('getValue');  //报告类型
	var receive=$('#receive').combobox('getValue');  //接收状态
	var statShare=$('#Share').combobox('getValue');  //分享状态 
	var OverTime=$('#OverTime').combobox('getValue');  //接收状态
	if (LocID==undefined){LocID="";}
	if (status==undefined){status="";}
	if (typeevent==undefined){typeevent="";}
	if (receive==undefined){receive="";}
	if (statShare==undefined){statShare="";}
	if (OverTime==undefined){OverTime="";}
	var PatNo=$.trim($("#patno").val());
	
	var StrParam=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+receive+"^"+statShare+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+OverTime;
	//var StrParam=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+134+"^"+6+"^"+359+"^"+status+"^"+typeevent+"^"+receive+"^"+statShare;
	$('#maindg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryAuditRepList',	
		queryParams:{
			StrParam:StrParam}
	});
	audittitle="";
	$('#audittitle').html("报告审核查询"+audittitle);
	//var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+"";
	//location.href=Rel;
}

///设置编辑连接
function setCellEditSymbol(value, rowData, rowIndex)
{
		var recordID=rowData.recordID;         //表单填写记录ID
		var RepID=rowData.RepID                //报告ID   yangyongtao 2017-11-28
		var RepStaus=rowData.RepStaus;         //表单状态
		var RepTypeDr=rowData.RepTypeDr;       //报告类型Dr
		var RepTypeCode=rowData.RepTypeCode;   //报告类型代码
		var RepType=rowData.RepType;           //报告类型
		var StatusLast=rowData.StatusLast;     //报告上一状态
		var Medadrreceivedr=rowData.Medadrreceivedr; //接收状态dr
		var RepUser=rowData.RepUser  //报告人
		var StaFistAuditUser=rowData.StaFistAuditUser  //被驳回人
		var BackAuditUser=rowData.BackAuditUser //驳回操作人
		var editFlag=1;  //修改标志  1可以修改 -1不可以修改   如果上一状态为空并且接收状态是驳回（接收状态dr为2）则可以修改
		/* if((StatusLast!="")&&(RepUser!=LgUserName)&&(StaFistAuditUser!=LgUserName)){///&&(Medadrreceivedr!=2)
			editFlag=-1;
		} */
		
		if(((StatusLast!="")&&(StaFistAuditUser!=LgUserName)&&(LgGroupDesc=="住院护士"))){///&&(Medadrreceivedr!=2)
			editFlag=-1;
		}
		if(((StatusLast=="")&&(RepUser!=LgUserName)&&(LgGroupDesc=="住院护士"))){///&&(Medadrreceivedr!=2)
			editFlag=-1;
		}
		if((Medadrreceivedr==2)&&(StaFistAuditUser!=LgUserName)&&(BackAuditUser!=LgUserName)){
			editFlag=-1;
		}
		return "<a href='#' onclick=\"showEditWin('"+recordID+"','"+RepStaus+"','"+RepTypeDr+"','"+RepTypeCode+"','"+RepType+"','"+RepID+"','"+editFlag+"','"+Medadrreceivedr+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_8.png' border=0/></a>";
}

//编辑窗体
function showEditWin(recordID,RepStaus,RepTypeDr,RepTypeCode,RepType,RepID,editFlag,Medadrreceivedr)
{
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'报告编辑',
		collapsible:true,
		border:false,
		closed:"true",
		width:1350,    ///2017-11-23  cy  修改弹出窗体大小 1250
		height:600
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+RepTypeDr+'&code='+RepTypeCode+'&desc='+RepType+'&RepID='+RepID+'&editFlag='+editFlag+'&adrReceive='+Medadrreceivedr+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
	//window.open("formrecorditmedit.csp?recordId="+rowsData.ID)
}

/*//打印
function Print(){
	var rowsData = $("#maindg").datagrid('getSelections')
	if (rowsData.length!="1") {
		$.messager.alert("提示","请只选择一条记录!");
		return;	
	}
	window.open("formprint.csp?recordId="+rowsData[0].recordID);
}*/
//打印
function Print(){
	var rowsData = $("#maindg").datagrid('getSelections')
	if (rowsData.length=="0") {
		$.messager.alert("提示","请选择一条记录!");
		return;	
	} 
	for(i=0;i<rowsData.length;i++){
		var recordId = rowsData[i].recordID;
		var RepID = rowsData[i].RepID;
		var RepTypeCode= rowsData[i].RepTypeCode;
		printRepForm(RepID,RepTypeCode);
		
	}	
	//window.open("formprint.csp?recordId="+rowsData[0].recordID);
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
	
	var RepFileFlag=""; //归档状态 2018-01-23
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //归档状态 2018-01-23
		if (FileFlag=="已归档"){
			RepFileFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert("提示:","所选报告存在已归档报告，不能接收！");
		return;
	}
	$.messager.confirm("提示", "是否进行接收操作", function (res) {//提示是否删除
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //关联主表ID
				var RepTypeCode=item.RepTypeCode;         //报告类型代码
				var Medadrreceivedr=item.Medadrreceivedr;//接收状态dr
				var RepStausDr=item.RepStausDr //当前状态id
				var params=RepID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+RepTypeCode+"^"+RepStausDr;   //参数串
				var num=$('#maindg').datagrid("getRowIndex",item); //2017-11-23  获取index值 
				var errnum=$('[datagrid-row-index="'+num+'"] .datagrid-cell-rownumber').text(); //2017-11-23 获取行号
				//alert(params);
				//保存数据
				$.post(url+'?action=REMataReport',{"params":params},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  获取行数 区分哪一行操作出错
					if(resobj.ErrCode < 0){
						$.messager.alert("提示:","接收错误,错误原因:"+"<font style='color:red;'>"+resobj.ErrMsg+"</font>");  //+"第"+errnum+"条数据"
					}
					
				});
			})
			$("#showalert").hide();
			$('#maindg').datagrid('reload'); //重新加载
			$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
		}
	})
}
//驳回 2018-01-17
function RejectWin()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("提示:","驳回操作,请只选择一行数据！");
		return;
	}
	var RepFileFlag="",RepBackFlag="" //归档状态 2018-01-23  是否可以驳回标识审核完毕的报告不能进行驳回操作） 2018-04-08
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //归档状态 2018-01-23
		var StatusNextID=item.StatusNextID; //报告下一状态ID 2018-04-08
		if (FileFlag=="已归档"){
			RepFileFlag="-1";
		}
		if(StatusNextID==""){
			RepBackFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert("提示:","所选报告存在已归档报告，不能驳回！");
		return;
	}
	if (RepBackFlag=="-1"){
		$.messager.alert("提示:","所选报告存在已审核完毕的报告，不能驳回！");
		return;
	}
	var RepStausDr=selItems[0].RepStausDr //当前状态id
	$("#showalert").show();//hxy 08-30 显示背影层
	$('#RetWin').window({
		title:'驳回',
		collapsible:false,
		border:false,
		closed:false,
		minimizable:false,
		maximizable:false,
		closable:false,
		width:400,
		height:280
	}); 
	//驳回指向 状态
	$('#RevStatus').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetRevStatusCombox&EvenCode='+"NursingRep"
	});
	if ((LgGroupDesc!="护理部")&&(LgGroupDesc!="Nursing Manager")){
		$('#RevStatus').combobox({disabled:true});;  //驳回指向
		$('#RevStatus').combobox('setValue',RepStausDr);  //驳回指向
	}
	$('#RetWin').window('open'); 
	$("#retreason").empty(); 
}

//确认驳回 2018-01-17
function BackBt()
{
	var NextLoc="";
	var LocAdvice="";
	var Retreason=$('#retreason').val();
	var RevStatus=$('#RevStatus').combobox('getValue');  //驳回指向
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("提示:","驳回操作,请只选择一行数据！");
		return;
	}
	if (RevStatus==""){
		$.messager.alert("提示:","请选择驳回指向！");
		return;
	}
	if ($('#RevStatus').combobox('getText')=="护理部审核"){
		$.messager.alert("提示:","护理部未审核，驳回指向不能为护理部审核！");
		return;
	}
	if (Retreason==""){
		$.messager.alert("提示:","请填写驳回意见！");
		return;
	}
	var RepID=selItems[0].RepID;         //报表ID
	var RepTypeCode=selItems[0].RepTypeCode;         //报告类型代码
	var Medadrreceivedr=selItems[0].Medadrreceivedr;//接收状态dr			
	var RepStausDr=selItems[0].RepStausDr //当前状态id
	var params=RepID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+RepTypeCode+"^"+RepStausDr+"^"+Retreason+"^"+RevStatus;   //参数串
	runClassMethod("web.DHCADVCOMMONPART","ReportBack",{'params':params},
			function(jsonString){ 
				//var resobj = jQuery.parseJSON(jsonString);
				//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  获取行数 区分哪一行操作出错
				if(jsonString.ErrCode < 0){
					$.messager.alert("提示:","驳回错误,错误原因:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"第"+errnum+"条数据"
				}
	},"json");
	
	$('#maindg').datagrid('reload'); //重新加载
	$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
	$('#RetWin').window('close');
	$("#showalert").hide();
}

//分享
function Share(){
var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("提示:","分享操作,请只选择一行数据！");
		return;
	}
	var RepID=selItems[0].RepID;         //报表ID
	var RepTypeCode=selItems[0].RepTypeCode;         //报告类型代码
	var RepShareStatus=selItems[0].RepShareStatus;//分享状态				
	var RepStausDr=selItems[0].RepStausDr //当前状态id
	var params=RepID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+RepTypeCode+"^"+RepStausDr+"^"+RepShareStatus   //参数串

  	var Sharemessage=""
     if(RepShareStatus=="未分享"){
	     Sharemessage="分享";
	} 
	if(RepShareStatus=="分享"){
	     Sharemessage="取消分享";
	}
	$.messager.confirm("提示", "是否进行"+Sharemessage+"操作", function (res) {//提示是否删除
		if (res) {
			//保存数据
			$.post(url+'?action=InsRepShare',{"params":params},function(jsonString){
				var resobj = jQuery.parseJSON(jsonString);
				if(resobj.ErrCode < 0){
					$.messager.alert("提示:","分享错误,错误原因:"+"<font style='color:red;'>"+resobj.ErrMsg+"</font>");
				}
			});
			$('#maindg').datagrid('reload'); //重新加载
			$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
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
   	if (selItems.length>1){
		$.messager.alert("提示:","关注操作,请只选择一行数据！");
		return;
	}
	var RepID=selItems[0].RepID;         //报表ID
	var RepTypeCode=selItems[0].RepTypeCode;         //报告类型代码
    var RepImpFlag=selItems[0].RepImpFlag;    //重点标记
  	var Impmessage=""
    if(RepImpFlag=="未关注"){
	     RepImpFlag="N";
	     Impmessage="关注";
	} 
	if(RepImpFlag=="关注"){
	     RepImpFlag="Y";
	     Impmessage="取消关注";
	}
	var Focusparams=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+RepTypeCode;
	//获取重点关注权限
	var FocusAuthority="";
	 $.ajax({  
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMON&MethodName=GetFocusAuthority'+'&params='+Focusparams, 	        
        async : false,	 // 注意此处需要同步，因为返回完数据后，下面才能让结果的第一条selected  
        type : "POST",  
        success : function(data) {       
        	FocusAuthority=data;
        }  
	});	
	if(FocusAuthority=="N"){
		$.messager.alert("提示:","无"+Impmessage+"操作权限！");
		return;
	}
	$.messager.confirm("提示", "是否进行"+Impmessage+"操作", function (res) {//提示是否删除
		if (res) {
			//保存数据
			runClassMethod("web.DHCADVCOMMONPART","InsRepImp",{'RepID':RepID,'RepImpFlag':RepImpFlag},
				function(data){ 
					if (data!="0") {
						$.messager.alert("提示:",Impmessage+"失败!");
					}
				},"text");
			$('#maindg').datagrid('reload'); //重新加载
			$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
		}
	})
}
//撤销审批 2018-01-17
function CancelAuditBt()
{	var NextLoc="" //$('#matadrNextLoc').combobox('getValue');
	var LocAdvice="" //$('#matadrLocAdvice').val();
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	var Medadrreceivedr=selItems[0].Medadrreceivedr;//接收状态
	if (Medadrreceivedr==1){
		$.messager.alert("提示:","报告已接收不能撤销审核！");
		return;
	}
	$.messager.confirm("提示", "是否进行撤销审核操作", function (res) {//提示是否删除
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //报表ID
				var RepTypeCode=item.RepTypeCode; //报告类型代码
				var StatusLastID=item.StatusLastID; //上一个状态
				var Medadrreceivedr=item.Medadrreceivedr;//接收状态
				var StatusNext=item.StatusNext; //下一个状态
				var StaFistAuditUser=item.StaFistAuditUser; //被驳回人
				
				if ((StaFistAuditUser!="")&(StaFistAuditUser!=LgUserName)){
					$.messager.alert("提示:","报告为驳回报告，且未驳回给当前登录人，无权限撤销审核！");
					return;
				}
				var params=RepID+"^"+StatusLastID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+RepTypeCode;   //参数串
				//保存数据
				runClassMethod("web.DHCADVCOMMONPART","CancelAuditReport",{'params':params},
				function(jsonString){ 
					//var resobj = jQuery.parseJSON(jsonString);
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  获取行数 区分哪一行操作出错
					if(jsonString.ErrCode < 0){
						$.messager.alert("提示:","审核错误,错误原因:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"第"+errnum+"条数据"
					}
				},"json");								
			})
			$('#maindg').datagrid('reload'); //重新加载
			$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
		}
	})
	
	
}
//审核
function Audit()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
   	if (selItems.length>1){
		$.messager.alert("提示:","审核操作,请只选择一行数据！");
		return;
	}
	var RepFileFlag=""; //归档状态 2018-01-23
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //归档状态 2018-01-23
		if (FileFlag=="已归档"){
			RepFileFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert("提示:","所选报告存在已归档报告，不能审核！");
		return;
	}
	
	var RepTypeCode=selItems[0].RepTypeCode;         //报告类型代码
    var RepStausDr=selItems[0].RepStausDr;    //当前状态ID
    var StsusGrant=selItems[0].StsusGrant; //审核状态 2018-01-17
    if(StsusGrant=="1"){
	    CancelAuditBt();
	}else{
		$.each(selItems, function(index, item){
			$("#showalert").show();//hxy 08-30 显示背影层
			$('#Process').window({
				title:'审核',
				collapsible:false,
				border:false,
				closed:false,
				minimizable:false,
				maximizable:false,
				closable:false,
				width:400,
				height:260
			});
			//指向科室
			$('#matadrNextLoc').combobox({
				url:url+'?action=QueryAuditLocList&RepTypeCode='+RepTypeCode+'&CurStatusDR='+RepStausDr
			}); 
			if (RepTypeCode=="med"){
				$('#NextLocList').show();
			}else{
				$('#NextLocList').hide();
			}
			$('#Process').window('open'); 
			$("#matadrLocAdvice").empty(); 
		});
	}
}

//确认审批
function ConfirmAudit()
{	
	var NextLoc=$('#matadrNextLoc').combobox('getValue');
	var LocAdvice=$('#matadrLocAdvice').val();
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	if(LocAdvice=="")     // wangxuejian 2016-10-26
	{
		$.messager.alert("提示:","处理意见不能为空！");	
		return;
	}
	$.each(selItems, function(index, item){
		
		var RepID=item.RepID;         //报表ID
		var RepTypeCode=item.RepTypeCode; //报告类型代码
		var StatusNextID=item.StatusNextID; //下一个状态
		var Medadrreceivedr=item.Medadrreceivedr;//接收状态
		var params=RepID+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+RepTypeCode;   //参数串
		//alert(params);
		var num=$('#maindg').datagrid("getRowIndex",item); //2017-11-23  获取index值 
		var errnum=$('[datagrid-row-index="'+num+'"] .datagrid-cell-rownumber').text(); //2017-11-23 获取行号
		runClassMethod("web.DHCADVCOMMONPART","AuditMataReport",{'params':params},
				function(jsonString){ 
					//var resobj = jQuery.parseJSON(jsonString);
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  获取行数 区分哪一行操作出错
					if(jsonString.ErrCode < 0){
						$.messager.alert("提示:","审核错误,错误原因:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"第"+errnum+"条数据"
					}
		},"json");
		
	})
	$('#maindg').datagrid('reload'); //重新加载
	$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
	$('#Process').window('close');
}


//转抄  2016-05-13 增加
function Transcription()
{	
	//TranFlag=0;
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
	//$("#showalert").show();//hxy 08-30 显示背影层
	$('#TranWin').window({
		title:'转抄',
		collapsible:false,
		border:false,
		closed:false,
		width:900,
		height:480
	});
	$('#TranWin').window('open');
	$.each(selItems, function(index, item){
		
		var RepID=item.RepID;         //报表ID
		var RepTypeCode=item.RepTypeCode;         //报告类型
		var params=RepID+"^"+RepTypeCode+"^"+LgUserID;
		var Subflag=item.Subflag;         //子表标志
		var SubUserflag=item.SubUserflag;//当前登录人员与科室是否匹配被指向人员与科室
		TranUserList(RepID,RepTypeCode,SubUserflag);//转抄指向人员
		TranLocUserList(RepID,RepTypeCode,SubUserflag);//转抄科室人员意见信息
		if(SubUserflag==0){
			//清空输入框
			//var time=
			getDateTime(); //2016-10-08 congyue
			$('#medadrUser').attr("disabled",false);
			$('#medadrDateTime').attr("disabled",false);
			$("#tranLocAdvic").attr("disabled",false);
			$("#medadrUser").val(LgUserName);//显示转抄人(当前登陆人)
			$("#medadrUser").attr("disabled",true);
			$("#medadrDateTime").attr("disabled",true);
			$("#tranLocAdvic").val("");
			$("#tranLocDr").combobox('setValue',"");
			$("#tranReplyMess").val("");
			$("#tranReply").hide();
			$("#tranReplyMess").hide();	
			$("#replyFlag").hide();//是否转抄回复

		}
		$.ajax({
			type: "POST",// 请求方式
	    	url: url,
	    	data: "action=SearchAuditMess&params="+params,
			success: function(data){
				var tmp=data.split("^");
				if(SubUserflag==1){
					$('#medadrUser').val(tmp[0]); //处理人员
					$('#medadrUser').attr("disabled","true");
					$('#medadrDateTime').val(tmp[1]+" "+tmp[2]);   //处理时间
					$('#medadrDateTime').attr("disabled","true");
					$('#tranLocAdvic').val(tmp[3]); //处理意见
					$('#tranLocAdvic').attr("disabled","true");
					$("#tranReply").show();
			        $("#tranReplyMess").show();
			        $("#replyFlag").show();//是否转抄回复
					//var UserID=rowData.UserID;
					if ((tmp[5]!=LgUserID)&(tmp[6]!=LgCtLocID)){
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
		if(SubUserflag==1){
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
function TranUserList(RepID,RepTypeCode,SubUserflag)
{
	//转抄科室
	$('#tranLocDr').combobox({
		url:url+'?action=GetQueryLoc&RepTypeCode='+RepTypeCode,
		onSelect:function(){
			var tranLocDr=$('#tranLocDr').combobox('getValue');
			$('#selectdg').datagrid({
				url:url+'?action=GetUserDr',	
				queryParams:{
					params:RepTypeCode+"^"+tranLocDr}
			});
		}
	}); 
	//定义columns
	var usercolumns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:"LocID",title:'LocID',width:90,hidden:true},
		{field:"Locname",title:'Locname',width:90,hidden:true},
		{field:"UserID",title:'UserID',width:90,hidden:true},
		{field:'Username',title:'科室人员',width:120}
	]];
	var titleNotes="";
	if(SubUserflag==1){
		titleNotes="";
	}else{
		titleNotes='<span style="font-size:10pt;font-family:华文楷体;color:red;">[双击行即可添加至转抄信息表]</span>';
	}
	var params=RepID+"^"+RepTypeCode;
	//定义datagrid
	$('#selectdg').datagrid({
		title:'指向人员'+titleNotes,
		url:url+'?action=QueryUserMess&paramsuser='+params,
		fit:true,
		rownumbers:true,
		columns:usercolumns,
		border:false,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){ 
			if((SubUserflag==1)){ //(SubUserflag==1)||(TranFlag==1)
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
				//2017-11-23 cy 判断转抄科室为空不能添加人员
				if(tranLocDesc==""){
					$.messager.alert("提示:","转抄科室不能为空！");	
					return;
				}
				//2017-11-23 cy 判断添加人员不能重复添加
				var  dataList=$('#tranmesdg').datagrid('getData'); 
				for(var i=0;i<dataList.rows.length;i++){
					if(UserID==dataList.rows[i].nameID){
						$.messager.alert("提示","该人员已添加！"); 
						return ;
					}
				}				

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
}
//转抄科室人员意见信息
function TranLocUserList(RepID,RepTypeCode,SubUserflag)
{
	//定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:"tranDateTime",title:'转抄时间',width:90,hidden:true},
		{field:'tranuser',title:'转抄人',width:120,hidden:true},
		{field:"tranuserID",title:'tranuserID',width:90,hidden:true},
		{field:'LocDesc',title:'科室',width:120},
		{field:"LocDr",title:'LocDr',width:90,hidden:true},
		{field:'name',title:'人员',width:80},
		{field:"nameID",title:'nameID',width:90,hidden:true},
		{field:'LocAdvice',title:'处理意见',width:100},
		{field:'advice',title:'回复内容',width:100},
		{field:'DutyFlag',title:'备注',width:200},
		{field:"tranreceive",title:'接收状态',width:90,hidden:true},
		{field:"tranrecedate",title:'接收日期',width:90,hidden:true},
		{field:"trancompdate",title:'完成日期',width:90,hidden:true}
	]];
	var titleOpNotes="";
	if(SubUserflag==1){
		titleOpNotes="";
	}else{
		titleOpNotes='<span style="font-size:10pt;font-family:华文楷体;color:red;">[双击行即可清除此条数据]</span>';
	}
	var params=RepID+"^"+RepTypeCode;
	//定义datagrid
	$('#tranmesdg').datagrid({
		title:'转抄信息表'+titleOpNotes,
		url:url+'?action=QueryTranLocUser&params='+params,
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
			if((SubUserflag==1)){ //(SubUserflag==1)||(TranFlag==1)
				return;
			}else{
				if((rowData.LocAdvice==undefined)||(rowData.LocAdvice=="")){
					$('#tranmesdg').datagrid('deleteRow',rowIndex);
				}else{
					alert("已转抄,不可删除");	
				}
			}
		}
	});	
	
}
//转抄提交
function TranSub()
{
	/* if(TranFlag==1){
		$.messager.alert("提示:","已提交成功，请勿重复点击");
		return;
	} */
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
		var RepID=item.RepID;         //报表ID
		var RepTypeCode=item.RepTypeCode; //报告类型代码
		var Medadrreceivedr=item.Medadrreceivedr;//接收状态
		var StatusNextID=item.StatusNextID; //下一个状态
		var RepStausDr=item.RepStausDr //当前状态
		medadrList=RepID+"^"+RepTypeCode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+Medadrreceivedr+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+RepStausDr;   //参数串
	})		
	var rows = $("#tranmesdg").datagrid('getChanges');
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

	//保存数据
	$.post(url+'?action=SaveTranMess',{"medadrList":medadrList,"medadriList":medadriList},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode==0){
			//TranFlag=1;
			$.messager.alert("提示:","提交成功");
			$('#maindg').datagrid('reload'); //重新加载
			$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选 $('#maindg').datagrid('clearSelections')  //2017-06-09 清除全选
			
		}
		if(resobj.ErrCode < 0){
			$.messager.alert("提示:","转抄提交错误,错误原因:"+"<font style='color:red;'>"+resobj.ErrMsg+"</font>");
			return ;
		}
		//$('#selectdg').datagrid('reload'); //重新加载
		//$('#tranmesdg').datagrid('reload'); //重新加载
		
	});
	closeDrgWindow();		
}
//转抄回复
function TranReply(Replyflag)
{   var tranDutyFlag="N"  //转抄之后未回复
	var tranLocDr=$('#tranLocDr').combobox('getValue');
	var tranLocAdvic=$('#tranLocAdvic').val();
	var tranReplyMess=$('#tranReplyMess').val();
	if($("#reply").is(':checked')){
		tranDutyFlag="Y";
	}
	var medadriList=LgUserID+"^"+tranReplyMess+"^"+Replyflag+"^"+tranDutyFlag;
	
	var rows = $("#tranmesdg").datagrid('getRows');
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((Replyflag==1)&&(rows[i].advice!="")&&(rows[i].nameID==LgUserID)){
			$.messager.alert("提示:","已提交成功，请勿重复点击");
			return false;
		}
		
		if((Replyflag==0)&&(rows[i].tranrecedate!="")&&(rows[i].nameID==LgUserID)){
			$.messager.alert("提示:","已接收成功，请勿重复点击");
			return false;
		}
		if((Replyflag==0)&&(rows[i].advice!="")&&(rows[i].nameID==LgUserID)){
			$.messager.alert("提示:","回复已提交，接收无效");
			return false;
		}
	} 
	/* if((TranFlag==1)&(Replyflag==1)){
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
	} */
	
	if((errflag==1)&(Replyflag==0)){
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
		var RepID=item.RepID;         //报表ID
		var RepTypeCode=item.RepTypeCode; //报告类型代码
		var Medadrreceivedr=item.Medadrreceivedr;//接收状态
		var StatusNextID=item.StatusNextID; //下一个状态
		medadrList=RepID+"^"+RepTypeCode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+Medadrreceivedr+"^"+StatusNextID;   //参数串
		//var params="medadrList="+medadrList+"&medadriList="+medadriList; 
	})
	//alert(params);
	//保存数据
	$.post(url+'?action=SaveReplyMess',{"medadrList":medadrList,"medadriList":medadriList},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode==0){
			if(Replyflag==1){
				//TranFlag=1;
				$('#maindg').datagrid('reload'); //重新加载
				$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选 $('#maindg').datagrid('clearSelections')  //2017-06-09 清除全选
			}
			$.messager.alert("提示:","操作成功");
			   closeDrgWindow();	
		}
		if(resobj.ErrCode < 0){
			$.messager.alert("提示:","操作错误,错误原因:"+"<font style='color:red;'>"+resobj.ErrMsg+"</font>");
		}
		//$('#selectdg').datagrid('reload'); //重新加载
		//$('#tranmesdg').datagrid('reload'); //重新加载
		
	});
}

//关闭转抄窗口
function closeDrgWindow()
{  
	$('#TranWin').window('close');
}

///设置审批明细连接  
function setCellAuditList(value, rowData, rowIndex)
{
		var RepID=rowData.RepID;         //报表ID
		var RepTypeCode=rowData.RepTypeCode; //报告类型代码
		return "<a href='#' onclick=\"showAuditListWin('"+RepID+"','"+RepTypeCode+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/></a>";
}
//编辑窗体
function showAuditListWin(RepID,RepTypeCode)
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
		{field:'AuditDateTime',title:'审批时间',width:150},
		{field:'NextLoc',title:'科室指向',width:150,hidden:true},
		{field:'NextLocDR',title:'科室指向ID',width:100,hidden:true},
		{field:'LocAdvice',title:'处理意见/驳回意见',width:280},
		{field:'Receive',title:'接收状态',width:60},
		{field:'RetStatus',title:'驳回指向',width:80},
		{field:'Subflag',title:'Subflag',width:60,hidden:true},
		{field:'ID',title:'ID',width:50,hidden:true} 
	]]; 
	
	// 定义columns
	var itmcolumns=[[
		{field:'MedIAuditDateTime',title:'审批时间',width:150,hidden:false}, // yangyongtao 2017-11-20 隐藏审批时间
		{field:'MedIAuditUser',title:'审批人',width:100,hidden:false}, // yangyongtao 2017-11-20  隐藏审批人
		{field:'MedIAuditUserDR',title:'审批人ID',width:100,hidden:true},
		{field:'MedINextLoc',title:'指向科室',width:150},
		{field:'MedINextLocDR',title:'科室指向ID',width:100,hidden:true},
		{field:'MedILocAdvice',title:'科室意见',width:200},
		{field:'MedINextUser',title:'指向人员',width:100},
		{field:'MedINextUserDR',title:'指向人员ID',width:100,hidden:true},
		{field:'MedIUserAdvice',title:'人员意见',width:200},
		{field:'MedIReceive',title:'接收状态',width:60},
		{field:'DutyFlag',title:'备注',width:200},
		{field:'MedIReceiveDateTime',title:'接收时间',width:150},
		{field:'MedICompleteDateTime',title:'完成时间',width:150}
	]];
	var params=RepID+"^"+RepTypeCode;
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
//获取处理时间 2016-10-08 congyue
function getDateTime(){
	var tmp="";
	var time="";
  		$.ajax({
	  	async: false,
		type: "POST",// 请求方式
    	url: url,
    	data: "action=GetDealDateTime",
		success: function(data){
		var tmp=data.split("^");
		$('#medadrDateTime').val(tmp[0]+" "+tmp[1]);   //处理时间
		}
  	}); 
}
///回首页
function Gologin(){
	location.href='dhcadv.homepage.csp';
}
//2016-10-10
function CloseWinUpdate(){
	$('#win').window('close');
}

function cleanInput(){
	var StDate=formatDate(-7);  //一周前的日期
	var EndDate=formatDate(0); //系统的当前日期
	$("#stdate").datebox("setValue", StDate);  //Init起始日期
	$("#enddate").datebox("setValue", EndDate);  //Init结束日期
	$('#dept').combobox('setValue',"");     //科室ID
	$("#status").combobox('setValue',"");
	$('#typeevent').combobox('setValue',"");;  //报告类型
	$('#receive').combobox('setValue',"");;  //接收状态
	$('#Share').combobox('setValue',"");;  //分享状态

   //报告的类型状态
   	var par="";
    $('#status').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		url:url+'?action=SelEvtStatusbyNew&params='+par
	});    
	$("#patno").val("");
}

// 导出word 卫计委
function ExportWord()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('提示',"<font style='color:red;font-weight:bold;font-size:20px;'>请先选择一行记录!</font>","error");
		return;
	}
	//$.messager.confirm("提示", "是否进行导出操作", function (res) {//提示是否删除
		//if (res) {
			var filePath=browseFolder();
			if (typeof filePath=="undefined"){
				$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>已取消操作！</font>","error");
				return;
			}
       var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	     if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		 	$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择有效路径后,重试！</font>","error");
		 	return;
	     }

	    for(i=0;i<selItems.length;i++){
				var recordId = selItems[i].recordID;
				var RepID = selItems[i].RepID;
				var RepTypeCode= selItems[i].RepTypeCode;
				var RepType= selItems[i].RepType;
				ExportWordData(RepID,RepTypeCode,RepType,filePath);
		
			}	
	    
			$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
		//}
	//})
}
// 导出Excel 卫计委
function ExportExcel()
{
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>已取消操作！</font>","error");
		return;
	}
  var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择有效路径后,重试！</font>","error");
		return;
	}
	var Staticflag=ExportExcelStatic(StDate,EndDate,filePath);
	if(Staticflag==true){
	$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
	}else{
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	}
}
// 导出Excel 医管局
function ExportExcelAll()
{

	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var typeevent=$('#typeevent').combobox('getText');  //报告类型
	if((typeevent=="")||(typeevent=="全部")){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择具体报告类型,重试！</font>","error");
		return;
	}
	if((typeevent.indexOf("医疗") >= 0)){
		$.messager.alert("提示:","该类型没有医管局需要数据，请选择其他类型","error");
		return;
	}
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>已取消操作！</font>","error");
		return;
	}
  var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择有效路径后,重试！</font>","error");
		return;
	}
	var Allflag=ExportExcelAllData(StDate,EndDate,typeevent,filePath);
	if(Allflag==true){
	$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
	}else{
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	}
}
// 导出(动态)
function Export()
{
	var typeevent=$('#typeevent').combobox('getValue');  //报告类型
	if((typeevent=="")||(typeevent=="全部")){
		$.messager.alert("提示:","请选择具体报告类型","error");
		return;
	}
	//formNameID==##class(web.DHCADVCOMMONPART).GetFormNameID
	runClassMethod("web.DHCADVCOMMONPART","GetFormNameID",{"AdrEvtDr":typeevent},
	function(ret){
		formNameID=ret
	},'text',false);
	//窗体处在打开状态,退出
	if(!$('#ExportWin').is(":visible")){
		$('#ExportWin').window('open');
		//initDatagrid();
		reloadAllItmTable(formNameID);
		$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 
		return;
	} 
	
	$('#ExportWin').window({
		title:'导出',
		collapsible:false,
		border:false,
		closed:false,
		width:800,
		height:480
	});
	$('#ExportWin').window('open');
	initDatagrid();
	$("a:contains('添加元素')").bind('click',addItm);
    $("a:contains('删除元素')").bind('click',delItm);
    $("a:contains('全部选中')").bind('click',selAllItm);
    $("a:contains('取消选中')").bind('click',unSelAllItm);
    $("a:contains('全部删除')").bind('click',delAllItm);

}

function initDatagrid(){
	var columns=[[
		{field:'FormDicID',title:'FormDicID',width:50,hidden:true},
		{field:'DicField',title:'DicField',width:100,hidden:true},
		{field:'DicDesc',title:'全部列',width:200}
	]];
	
	$("#allItmTable").datagrid({
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetSetFiel",
		queryParams:{
			ForNameID:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		loadMsg: '正在加载信息...',
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});	
	
	var setcolumns=[[
		{field:'FormDicID',title:'FormDicID',width:50,hidden:true},
		{field:'DicField',title:'DicField',width:100,hidden:true},
		{field:'DicDesc',title:'导出列',width:200}
	]];

	$("#setItmTable").datagrid({
		url:"",
		fit:true,
		rownumbers:true,
		columns:setcolumns,
		loadMsg: '正在加载信息...',
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});
	$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 
	reloadAllItmTable(formNameID);
	reloadSetFielTable(formNameID);
		
}
///添加元素
function addItm(){
	var datas = $("#allItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("提示","未选中左侧数据！");
		return;	    
	}
	for(var i=0;i<datas.length;i++)
	{
		$('#setItmTable').datagrid('insertRow',{
			index:0,
			row:{
				FormDicID:datas[i].FormDicID,
				DicField:datas[i].DicField,
				DicDesc:datas[i].DicDesc
			}
		
		})
		var aindex=$('#allItmTable').datagrid('getRowIndex',datas[i]);
		$('#allItmTable').datagrid('deleteRow',aindex);

	} 

}
function delItm(){
	var datas = $("#setItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("提示","未选中右侧数据！");
		return;	    
	}
	for(var i=0;i<datas.length;i++)
	{
		var aindex=$('#setItmTable').datagrid('getRowIndex',datas[i]);
		$('#setItmTable').datagrid('deleteRow',aindex);
		$('#allItmTable').datagrid('insertRow',{
			index:0,
			row:{
				FormDicID:datas[i].FormDicID,
				DicField:datas[i].DicField,
				DicDesc:datas[i].DicDesc
			}
		})
	}
}

function delAllItm(){
	$("#setItmTable").datagrid("checkAll");
	delItm();
}
function selAllItm(){
	$("#allItmTable").datagrid("checkAll");
}
function unSelAllItm(){
	$("#allItmTable").datagrid("uncheckAll");
}
//reload 左上表
function reloadAllItmTable(value){
	$("#allItmTable").datagrid('load',{
		ForNameID:value
	})
}

function reloadSetFielTable(value){
	$("#setItmTable").datagrid('load',{
		ForNameID:value
	})
}
///刷新 field和fieldVal
function reloadTopTable(){
	reloadSetFielTable(formNameID);
	reloadAllItmTable(formNameID);
}
function ExportOK(){
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var RepType=$('#typeevent').combobox('getText');  //报告类型
	var datas = $("#setItmTable").datagrid("getRows");
	if(datas.length<1){
		$.messager.alert("提示","导出列为空，请添加导出列！");
		return;	    
	}
	var fieldList = [],descList=[],tablefield=[],tabledesc=[];
	for(var i=0;i<datas.length;i++)
	{
		if (datas[i].DicField.indexOf("UlcerPart")>=0){
			tablefield.push(datas[i].DicField);
			tabledesc.push(datas[i].DicDesc);
		}else{
			fieldList.push(datas[i].DicField);
			descList.push(datas[i].DicDesc);
		}
	} 
	var TitleList=fieldList.join("#");
	var DescList=descList.join("#");
	var TabFieldList=tablefield.join("#");
	var TabDescList=tabledesc.join("#");
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>已取消操作！</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择有效路径后,重试！</font>","error");
		return;
	}
	var Allflag=ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList);
	if(Allflag==true){
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
		$('#ExportWin').window('close');
	}else{
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	} 
	
}
// 全部导出Excel 
function ExportAll()
{

	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var typeevent=$('#typeevent').combobox('getText');  //报告类型
	/* if((typeevent=="")||(typeevent=="全部")){
		$.messager.alert("提示:","类型条件为空，请选择类型","error");
		return;
	} */
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>已取消操作！</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择有效路径后,重试！</font>","error");
		return;
	}
	var Allflag=ExportAllData(StDate,EndDate,typeevent,filePath);
	if(Allflag==true){
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
	}else{
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	}
}
// 导出Excel 汇总版
function ExportGather()
{

	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var typeevent=$('#typeevent').combobox('getText');  //报告类型
	/* if((typeevent=="")||(typeevent=="全部")){
		$.messager.alert("提示:","类型条件为空，请选择类型","error");
		return;
	} */
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>已取消操作！</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择有效路径后,重试！</font>","error");
		return;
	}
	var Allflag=ExportGatherData(StDate,EndDate,typeevent,filePath);
	if(Allflag==true){
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
	}else{
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	}
}

//获取分享权限标志  2018-01-17
function GetShareAuthority(ReportID,params)
{
	var ShareFlag="";
	$.ajax({
		type: "POST",
		url: "dhcadv.repaction.csp",
		async: false, //同步
		data: "action=GetShareAuthority&ReportID="+ReportID+"&params="+params,
		success: function(val){
			ShareFlag=val.replace(/(^\s*)|(\s*$)/g,"");
		}
	});
	return ShareFlag ;
}
//撤销归档
function CancelFilewin()
{
	$("#showalert").show();//hxy 08-30 显示背影层
	$('#CanFileWin').window({
		title:'撤销归档',
		collapsible:false,
		border:false,
		closed:false,
		minimizable:false,
		maximizable:false,
		closable:false,
		width:400,
		height:270
	});
	$('#CanFileWin').window('open');
	//归档建议
	$('#canfilereason').empty();
	

}
//确认撤销归档 2018-01-17
function ConfirmCanFile()
{	
	var canfilereason=$('#canfilereason').val();
	if (canfilereason==""){
		$.messager.alert("提示:","撤销归档建议不能为空！");
		return;
	}
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	$.each(selItems, function(index, item){
		var RepID=item.RepID;         //报表ID
		var RepTypeCode=item.RepTypeCode; //报告类型代码
		var RepStausDr=item.RepStausDr; //当前状态
		var auditparams=RepID+"^"+RepStausDr+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+""+"^"+canfilereason+"^"+6+"^"+RepTypeCode;   //参数串
		var fileparams=RepID+"^"+RepTypeCode+"^"+"N"+"^"+LgUserID;   //参数串
		
		//alert(auditparams+"hhhhh"+fileparams);
		//保存数据
		runClassMethod("web.DHCADVCOMMONPART","FileMataReport",{'auditparams':auditparams,'fileparams':fileparams},
				function(jsonString){ 
					//var resobj = jQuery.parseJSON(jsonString);
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  获取行数 区分哪一行操作出错
					if(jsonString < 0){
						$.messager.alert("提示:","报告撤销归档失败!");   ///+"第"+errnum+"条数据"
					}
		},"",false);
		
		
	})
	$('#maindg').datagrid('reload'); //重新加载
	$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
	$('#CanFileWin').window('close');
	$("#showalert").hide();
}
//归档
function File()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
   	if (selItems.length>1){
		$.messager.alert("提示:","归档操作,请只选择一行数据！");
		return;
	}
	
    var FileFlag=selItems[0].FileFlag; //归档状态 2018-01-23
    
    var winshowflag="";
    $.each(selItems, function(index, item){
		var StatusNextID=item.StatusNextID; //下一个状态
		var FileFlag=item.FileFlag; //归档状态 2018-01-23
		if((StatusNextID!="")||(FileFlag=="已归档")){
			winshowflag=-1;
		}
	
	});
	
    if(FileFlag=="已归档"){
	    CancelFilewin();
	}else{
		if(winshowflag=="-1"){
		$.messager.alert("提示:","所勾选报告有未审核完成的报告，请仔细检查勾选数据！");
		return;
	}
		$("#showalert").show();//hxy 08-30 显示背影层
		$('#FileWin').window({
			title:'归档',
			collapsible:false,
			border:false,
			closed:false,
			minimizable:false,
			maximizable:false,
			closable:false,
			width:400,
			height:320
		});
		$('#FileWin').window('open');
		//归档建议
		$('#filereason').empty();
		$('#UserCodeFile').val(LgUserCode);
		$('#UserCodeFile').attr("disabled","true");
		$('#passWordFile').val("");
		$('#UserCodeAudit').val("");
		$('#passWordAudit').val(""); 
	}
}

//确认归档
function ConfirmFile()
{	
	var filereason=$('#filereason').val();
	if (filereason==""){
		$.messager.alert("提示:","归档建议不能为空！");
		return;
	}
	var UserCodeFile=$('#UserCodeFile').val();
	if (UserCodeFile==""){
		$.messager.alert("提示:","归档人员不能为空！");
		return;
	}
	var passWordFile=$('#passWordFile').val();
	if (passWordFile==""){
		$.messager.alert("提示:","归档人员密码不能为空！");
		return;
	}
	var UserCodeAudit=$('#UserCodeAudit').val();
	if (UserCodeAudit==""){
		$.messager.alert("提示:","复核人员不能为空！");
		return;
	}
	var passWordAudit=$('#passWordAudit').val();
	if (passWordAudit==""){
		$.messager.alert("提示:","复核人员密码不能为空！");
		return;
	}
	//判断归档人员与复核人员是否为同一人
	if(UserCodeFile==UserCodeAudit){
		$.messager.alert("提示:","归档人员与复核人员不能相同！");
		return;
	}
	var UserIDFile="",UserIDAudit="",ifFileflag="",ifAuditflag="";
	runClassMethod("web.DHCADVREPFILE","ConfirmPassWord",{ 'userCode':UserCodeFile,'passWord':passWordFile},
		function(data){ 
			if(data.split("^")[0] != 0){
				$.messager.alert("提示:","归档人员："+"<font style='color:red;'>"+data+"</font>");
				ifFileflag=-1;
			}else{
				UserIDFile = data.split("^")[1];   ///这个就是用户ID
			}
	},"",false);
	if (ifFileflag=="-1"){
		return;
	}
	
	runClassMethod("web.DHCADVREPFILE","ConfirmPassWord",{ 'userCode':UserCodeAudit,'passWord':passWordAudit},
		function(data){ 
			if(data.split("^")[0] != 0){
				$.messager.alert("提示:","复核人员："+"<font style='color:red;'>"+data+"</font>");  
				ifAuditflag=-1;
			}else{
				UserIDAudit = data.split("^")[1];   ///这个就是用户ID
			}
	},"",false);
	if (ifAuditflag=="-1"){
		return;
	}
		
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	$.each(selItems, function(index, item){
		
		var RepID=item.RepID;         //报表ID
		var RepTypeCode=item.RepTypeCode; //报告类型代码
		var RepStausDr=item.RepStausDr; //当前状态
		var Medadrreceivedr=item.Medadrreceivedr;//接收状态
		var auditparams=RepID+"^"+RepStausDr+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+""+"^"+filereason+"^"+5+"^"+RepTypeCode;   //参数串
		var fileparams=RepID+"^"+RepTypeCode+"^"+"Y"+"^"+UserIDFile+"^"+UserIDAudit;   //参数串
		
		//alert(auditparams+"hhhhh"+fileparams);
		var num=$('#maindg').datagrid("getRowIndex",item); //2017-11-23  获取index值 
		var errnum=$('[datagrid-row-index="'+num+'"] .datagrid-cell-rownumber').text(); //2017-11-23 获取行号
		runClassMethod("web.DHCADVCOMMONPART","FileMataReport",{'auditparams':auditparams,'fileparams':fileparams},
				function(jsonString){ 
					//var resobj = jQuery.parseJSON(jsonString);
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  获取行数 区分哪一行操作出错
					if(jsonString < 0){
						$.messager.alert("提示:","报告归档失败!");   ///+"第"+errnum+"条数据"
					}
		},"",false);
		
	})
	$('#maindg').datagrid('reload'); //重新加载
	$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
	$('#FileWin').window('close');
	$("#showalert").hide();
}
//作废
function RepCancel()
{
	var NextLoc="";
	var LocAdvice="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	var RepFileFlag=""; //归档状态 2018-01-23
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //归档状态 2018-01-23
		if (FileFlag=="已归档"){
			RepFileFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert("提示:","所选报告存在已归档报告，不能作废！");
		return;
	}
	$.messager.confirm("提示", "是否进行作废操作", function (res) {//提示是否删除
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //关联主表ID
				var RepTypeCode=item.RepTypeCode;         //报告类型代码
				var Medadrreceivedr=item.Medadrreceivedr;//接收状态dr
				var RepStausDr=item.RepStausDr //当前状态id
				var params=RepID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+RepTypeCode+"^"+RepStausDr+"^"+"Y";   //参数串
				var num=$('#maindg').datagrid("getRowIndex",item); //2017-11-23  获取index值 
				var errnum=$('[datagrid-row-index="'+num+'"] .datagrid-cell-rownumber').text(); //2017-11-23 获取行号
				
				runClassMethod("web.DHCADVCOMMONPART","MataRepCancel",{'params':params},
				function(jsonString){ 
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  获取行数 区分哪一行操作出错
					if(jsonString.ErrCode < 0){
						$.messager.alert("提示:","作废错误,错误原因:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");  //+"第"+errnum+"条数据"
					}
				},"json",false);
				
			})
			$("#showalert").hide();
			$('#maindg').datagrid('reload'); //重新加载
			$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
		}
	})
}

// 编辑格
var texteditor={
	type: 'validatebox'//设置编辑格式
	
}

///添加共享指向科室
function CaseShare(){
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("提示:","只能选中一行数据,请重试！");
		return;
	}
	var RepID=selItems[0].RepID;         //关联主表ID
	var RepTypeCode=selItems[0].RepTypeCode;         //报告类型代码
	var params=RepID+"^"+RepTypeCode;
	$('#WardW').window('open');	
	//是否可用标志
	var activeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				
				var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'Active'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	//科室
	var Eventeditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "val", 
			textField: "text",
			url:url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'',
			required:true,
			mode:'remote',  //,  //必须设置这个属性
			onSelect:function(option){
				///设置类型值
				
				var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareLoc'});
				$(ed.target).combobox('setValue', option.text); 
				var eds=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareLocDr'});
				$(eds.target).val( option.val); 
			} 
		}
	}
	// 定义columns
	var columns=[[
		{field:"RepDr",title:'报告指向',width:80,editor:texteditor,hidden:true},
		{field:'RepTypeCode',title:'状态代码',width:80,editor:texteditor,hidden:true},
		{field:"ShareLocDr",title:'科室Dr',width:80,editor:texteditor,hidden:true},
		{field:"ShareLoc",title:'科室',width:120,editor:Eventeditor},
		{field:'Active',title:'是否共享',width:80,editor:activeEditor},
		{field:"ID",title:'ID',width:70,align:'center'}
	]];
	
	// 定义datagrid
	$('#Warddg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCASESHARE&MethodName=QueryCaseShare'+'&params='+params+'&rows='+10+'&page='+1,
		//url:'',
		fit:true,
		rownumbers:true,
		columns:columns,  
	    singleSelect:true,
		loadMsg: '正在加载信息...',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((loceditRow != "")||(loceditRow == "0")) {
            	$("#Warddg").datagrid('endEdit', loceditRow);
			}
            $("#Warddg").datagrid('beginEdit', rowIndex); 
            var ed=$("#Warddg").datagrid('getEditor',{index:rowIndex,field:'ShareLoc'});
            if(rowData.ShareLoc!=""){
	            $(ed.target).combobox({disabled:true});
	            $(ed.target).combobox('setValue',rowData.ShareLoc);
	        }else{
		        $(ed.target).combobox({disabled:false});
		    }
            loceditRow = rowIndex; 
        } 
        
	});
	/* $('#Warddg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCASESHARE&MethodName=QueryCaseShare'+'&params='+params+'&rows='+10+'&page='+1
	});	 */
	
}
/* ///添加安全小组成员病区-增加
function addWardAdd(){
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("提示:","只能选中一行数据,请重试！");
		return;
	}
	var RepID=selItems[0].RepID;         //关联主表ID
	var RepTypeCode=selItems[0].RepTypeCode;         //报告类型代码
	commonAddRow({'datagrid':'#Warddg',value:{'RepDr':RepID,'RepTypeCode':RepTypeCode}})
	
}
 */
// 插入新行
function addWardAdd()
{	
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("提示:","只能选中一行数据,请重试！");
		return;
	}
	var RepID=selItems[0].RepID;         //关联主表ID
	var RepTypeCode=selItems[0].RepTypeCode;         //报告类型代码
	if(loceditRow>="0"){
		$("#Warddg").datagrid('endEdit', loceditRow);//结束编辑，传入之前编辑的行
	}
	var rows = $("#Warddg").datagrid('getChanges');
	var ShareLocDr=""
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ShareLoc=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}
	} 
	$("#Warddg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		
		index: 0, // 行数从0开始计算
		row: {ID: '',RepDr:RepID,RepTypeCode: RepTypeCode,EventType:'',ShareLocDr:'',ShareLoc:'',Active: 'Y'}
	});
	
	$("#Warddg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	loceditRow=0;
}
// 保存编辑行
function saveSecuGUW()
{
	if(loceditRow>="0"){
		$("#Warddg").datagrid('endEdit', loceditRow);
	}
	var rows = $("#Warddg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ShareLoc=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].RepDr+"^"+rows[i].RepTypeCode+"^"+rows[i].ShareLocDr+"^"+rows[i].Active+"^"+LgUserID;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	runClassMethod("web.DHCADVCASESHARE","SaveCaseShare",{'DataList':rowstr},
	function(data){ 
		if(data==0){
			$.messager.alert('提示','操作成功');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('提示','科室重复,请核实后再试','warning');
			return;	//2017-03-17 保存失败，刷新字典表
		}else {
			$.messager.alert('提示','操作失败','warning');
			return;	//2017-03-17 保存失败，刷新字典表
		}
	},"",false);
	
	$('#WardW').window('close');
	$("#showalert").hide();
	$('#maindg').datagrid('reload'); //重新加载
	$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选

}
//删除
function RepDelete()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	var RepFileFlag=""; //归档状态 2018-01-23
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //归档状态 2018-01-23
		if (FileFlag=="已归档"){
			RepFileFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert("提示:","所选报告存在已归档报告，不能删除！");
		return;
	}
	$.messager.confirm("提示", "是否进行删除操作", function (res) {//提示是否删除
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //关联主表ID
				runClassMethod("web.DHCADVCOMMONPART","DelRepData",{'RepID':RepID},
				function(data){ 
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  获取行数 区分哪一行操作出错
					if(data< 0){
						$.messager.alert("提示:","删除失败！");  //+"第"+errnum+"条数据"
					}
				},"",false);
				
			})
			$('#maindg').datagrid('reload'); //重新加载
			$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
		}
	})
}
