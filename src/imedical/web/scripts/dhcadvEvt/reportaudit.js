// Creator: congyue
/// CreateDate: 2017-07-28
//  Descript: 不良事件升级 审核界面
var url = "dhcadv.repaction.csp";
var statShare = [{ "val": "未分享", "text": $g("未分享") },{ "val": "分享", "text": $g("分享") }];
var statReceive = [{ "val": "未接收", "text": $g("未接收") },{ "val": "1", "text": $g("接收") },{ "val": "2", "text": $g("驳回") },{ "val": "3", "text": $g("撤销") },{ "val": "4", "text": $g("审核") },{ "val": "7", "text": $g("归档(待复核)") },{ "val": "5", "text": $g("归档") },{ "val": "6", "text": $g("撤销归档") }];
var statOverTime = [{ "val": "Y", "text": $g("超时") },{ "val": "N", "text": $g("未超时") }];
var Active = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];
var condArray= [{ "val": "and", "text": $g("并且") },{ "val": "or", "text": $g("或者") }]; //逻辑关系
var stateBoxArray= [{ "val": "=", "text": $g("等于") },{ "val": ">", "text": $g("大于") },{ "val": ">=", "text": $g("大于等于") },{ "val": "<=", "text": $g("小于等于") },{ "val": "<", "text": $g("小于") }]; //条件
var editRow="",TranFlag=0,errflag=0 ;///TranFlag:转抄标志   errflag:转抄回复人员与被转抄人员是否一致
var loceditRow=0,StrParam="",audittitle="",curCondRow=1; // 共享科室行修改标志, 查询条件串, 审核查询标题, 高级查询条件 行数
var StDate="";  //一周前的日期   2018-01-26 修改，默认开始日期为上线使用日期，即2018-01-01
var EndDate=""; //系统的当前日期
var FileTimes=serverCall("web.DHCADVCOMMON","GetEmSysConfig",{"AdvCode":"FILETIMES","Params":LgParam})
var ColSort="",ColOrder=""; // 排序列 , 排序标志:desc 降序   asc 升序
var receiveflag="",impflag="",appauditflag="",backflag="";//首页-接收标识 重点关注 待审批标识 退回标识
var auditflag="",inpfileflag="",homeAutOverTime=""; //首页-已处理标识 归档标识 首页是否护士长审核超时
$(function(){ 
	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPageButton();         /// 界面按钮控制
	InitPageDataGrid();		  /// 初始化页面datagrid
	InitPageStyle();          /// 初始化页面样式
});
/// 初始化界面控件内容
function InitPageComponent(){
	$.messager.defaults = { ok: $g("确定"),cancel: $g("取消")};
	// 获取登录人 信息
	runClassMethod("web.DHCADVCOMMONPART","GetRepUserInfo",{'UserID':LgUserID,'LocID':LgCtLocID,'HospID':LgHospID,'GroupID':LgGroupID},
	function(Data){ 
		LgGroupDesc=Data.GroupDesc;
		
	},"json",false);
	runClassMethod("web.DHCADVCOMMON","GetStaEndDate",{'LgParam':LgParam},function(data){
		var tmp=data.split("^"); 
		StDate=tmp[0];
		EndDate=tmp[1];
	},'',false);
	
	//接收
	$('#receive').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:statReceive
	});
	// 科室
	$('#dept').combobox({ 
		mode:'remote',  //必须设置这个属性
		onShowPanel:function(){ 
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
		}
	});
	
	//报告的类型类型
	$('#typeevent').combobox({
		url:url+'?action=SelEventbyNew&param='+LgParam,
		onSelect: function(rec){  
			var TypeStatus=rec.value; 
			ComboboxEvent(TypeStatus);  
		} 	  
	}); 
	//分享状态
	$('#Share').combobox({
		panelHeight:"auto",  
		data:statShare
	});
	//超时状态
	$('#OverTime').combobox({
		panelHeight:"auto", 
		data:statOverTime
	});
	//逻辑关系
	$('#condCombox').combobox({
		panelHeight:"auto", 
		data:condArray
	});
	//首页 报告管理联动
	StrParam=getParam("StrParam");
	audittitle=getParam("audittitle");
	audittitle=decodeURI(decodeURI(audittitle));
	if(StrParam!=""){
		var tmp=StrParam.split("^");
		$('#stdate').combobox({disabled:true});
		$('#enddate').combobox({disabled:true});		
		$("#stdate").datebox("setValue", tmp[0]);  //Init起始日期
		$("#enddate").datebox("setValue", tmp[1]);  //Init结束日期
		if(tmp[2]!=""){
			$('#dept').combobox({disabled:true});  //科室ID
			$('#dept').combobox("setValue",tmp[2]);     //科室ID
			$("#dept").combobox('setText',LgCtLocDesc);
		}else{
			$('#dept').combobox("setValue",tmp[2]);     //科室ID
			$("#dept").combobox('setText',"")
		}
		if(tmp[7]!=""){
			$('#status').combobox({disabled:true});
			$('#status').combobox("setValue",tmp[7]);  //状态
		}
		if(tmp[8]!=""){
			$('#receive').combobox({disabled:true});
			$('#receive').combobox("setValue",tmp[9]); //接收状态
		}
		if(tmp[9]!=""){
			$('#typeevent').combobox({disabled:true});
			$('#typeevent').combobox("setValue",tmp[8]);  //报告类型
		}
		if(tmp[10]!=""){
			$('#Share').combobox({disabled:true});
			$('#Share').combobox("setValue",tmp[10]);  //分享状态 
		}
		if(tmp[18]!=""){
			$('#OverTime').combobox({disabled:true});
			$('#OverTime').combobox("setValue",tmp[18]);  //超时状态
		}
   		
   		receiveflag=tmp[11];
		impflag=tmp[12];
		appauditflag=tmp[13];
		backflag=tmp[14];
		auditflag=tmp[15];
		inpfileflag=tmp[16];
		homeAutOverTime=tmp[18];
	
	}else{
		$("#stdate").datebox("setValue", StDate);  //Init起始日期
		$("#enddate").datebox("setValue", EndDate);  //Init结束日期
		if((LgCtLocDesc!="护理部")&&(LgCtLocDesc!="医务部")){
			//$('#dept').combobox("setValue",LgCtLocID);     //科室ID  sufan 2020-12-09  产品部需求
			//$("#dept").combobox('setText',LgCtLocDesc);
		}
		
	}
}
/// 界面按钮控制
function InitPageButton(){
	$('#audittitle').html($g("报告审核查询")+audittitle);
	
	$('#Refresh').bind("click",Query);  //刷新
	$('#Find').bind("click",Query);  //点击查询 
	$('#Export').bind("click",Export);  //点击导出(动态导出)
	$('#ExportWord').bind("click",ExportWordFile);  //点击导出(word导出)	
	$('#ExportExcel').bind("click",ExportExcel);  //点击导出(卫计委excel数据)
	$('#ExportExcelAll').bind("click",ExportExcelAll);  //点击导出(医管局excel数据)
	$('#ExportAll').bind("click",ExportAll);  //点击导出(全部类型固定数据)
	$('#ExportGather').bind("click",ExportGather);  //点击导出(汇总版)
	$('#Printhtml').bind("click",htmlPrint);  //点击打印  Print 使用html打印
	$('#REceive').bind("click",REceive); //接收
	$('#SHare').bind("click",Share); //分享状态  RepShareStatus
	$('#RepImpFlag').bind("click",RepImpFlag); //重点关注
	$('#File').bind("click",File); //归档操作	
	$('#ConfirmFile').bind("click",ConfirmFile); //确认归档 
	$('#ConfirmCanFile').bind("click",ConfirmCanFile); //确认撤销归档 
	$('#RepCancel').bind("click",RepCancel); //作废 
	$('#CaseShare').bind("click",CaseShare); //案例共享 
	$('#RepDelete').bind("click",RepDelete); //删除 
	$('#Fish').bind("click",fish); //鱼骨图
	$('#FileAudit').bind("click",FileAudit);		 //复核归档
	$('#RevFile').bind("click",RevFile);		 //确认复核归档
	$("#addCondBTN").on('click',addCondition); // 高级查询条件增加
	$("#Print").bind("click",Print);		 //新作的打印
	$('#DeptConBtn').bind("click",DeptConBtn); // 持续追踪反馈按钮 2020-02-13
}
/// 初始化页面样式
function InitPageStyle(){
	//去弹窗背景层hxy 08-30
	$("#ConfirmAudit,#CancelAudit,#CancelReject,#CancelFile,#CancelCanFile,#CancelAudFile").click(function(){
	 	$("#showalert").hide();
	});
	addCondition(); // 高级查询条件增加
}
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
/// 初始化页面datagrid
function InitPageDataGrid()
{
	//定义columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"RepID",title:'RepID',width:80,hidden:true},
		{field:"recordID",title:'recordID',width:80,hidden:true},
		{field:'Edit',title:$g('查看'),width:60,align:'center',formatter:setCellEditSymbol,hidden:false},
		{field:'AuditList',title:$g('审批明细'),width:60,align:'center',formatter:setCellAuditList,hidden:false},
		{field:'PatOutFlag',title:$g('明细追踪'),width:280,align:'center',formatter:setLinkList,hidden:false},
		{field:'TranList',title:$g('转抄明细'),width:60,align:'center',formatter:setTranList,hidden:false},
		{field:'StatusLast',title:$g('上一状态'),width:100,hidden:true},
		{field:'StatusLastID',title:$g('上一状态ID'),width:100,hidden:true},
		{field:"RepStaus",title:$g('报告状态'),hidden:false},
		{field:"RepStausDr",title:$g('报告状态ID'),width:90,hidden:true},
		{field:'StatusNext',title:$g('下一状态'),width:100,hidden:true},
		{field:'StatusNextID',title:$g('下一状态ID'),width:100,hidden:true},
		{field:'RepDate',title:$g('报告日期'),width:100,sortable:true},
		{field:'Medadrreceive',title:$g('接收状态'),width:100},
		{field:'Medadrreceivedr',title:$g('接收状态dr'),width:80,hidden:true},
		{field:'PatID',title:$g('登记号'),width:100,hidden:false},		
		{field:'AdmNo',title:$g('病案号'),width:100,formatter:setPatientRecord},
		{field:'PatName',title:$g('姓名'),width:100},
		{field:'RepType',title:$g('报告类型'),width:260},
		{field:'OccurDate',title:$g('发生日期'),width:100},
		{field:'OccurLoc',title:$g('发生科室'),width:130},
		{field:'LocDep',title:$g('报告系统'),width:150,hidden:true},
		{field:'RepLocDr',title:'RepLocDr',width:150,hidden:true},
		{field:'RepLoc',title:$g('报告科室'),width:130},	
		{field:'RepUser',title:$g('报告人'),width:100},	
		{field:'RepUserDr',title:'RepUserDr',width:150,hidden:true},	
		{field:'RepTypeCode',title:$g('报告类型代码'),width:120,hidden:true},
		{field:'RepImpFlag',title:$g('重点关注'),width:100,hidden:false},
		{field:'RepSubType',title:$g('报告子类型'),width:120,hidden:true},
		{field:'Subflag',title:$g('子表标志'),width:120,hidden:true},
		{field:'SubUserflag',title:$g('子表用户标志'),width:120,hidden:true},
		{field:'RepLevel',title:$g('不良事件级别'),width:120,hidden:true},
		{field:'RepInjSev',title:$g('伤害严重度'),width:120,hidden:true},
		{field:'RepTypeDr',title:$g('报告类型Dr'),width:120,hidden:true},
		{field:'StsusGrant',title:$g('审核标识'),width:120,hidden:true},
		{field:'MedadrRevStatus',title:$g('驳回指向'),width:120,hidden:true},
		{field:'StaFistAuditUser',title:$g('被驳回人'),width:120,hidden:true},
		{field:'BackAuditUser',title:$g('驳回操作人'),width:120,hidden:true},
		{field:'RepOverTimeflag',title:$g('填报超时'),width:120,hidden:false},
		{field:'AutOverTimeflag',title:$g('受理超时'),width:120,hidden:false},
		{field:'CaseShareLoclist',title:$g('共享科室'),width:120,hidden:false},
		{field:'CaseShareUserlist',title:$g('共享用户'),width:120,hidden:false},
		{field:'CaseShareAdvicelist',title:$g('共享意见'),width:120,hidden:false},
		{field:'FileFlag',title:$g('归档状态'),width:80},
		{field:'RepShareStatus',title:$g('分享状态'),width:80,align:'center',hidden:false},
		{field:'UserLeadflag',title:$g('科护士长标识'),width:80,hidden:true},
		{field:'AdmID',title:$g('就诊ID'),width:80,hidden:true},
		{field:'RepAppAuditFlag',title:$g('待审批标识'),width:80,hidden:true}

	]];
	
	//定义datagrid
	$('#maindg').datagrid({
		toolbar: '#toolbar',//hxy add 08-28
		title:'', //hxy 报告列表
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryAuditRepList'+'&StrParam='+StrParam+'&LgParam='+LgParam+'&ParStr='+"",
		fit:true,
		rownumbers:true,
		columns:columns,
		remoteSort:false,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: $g('正在加载信息...'),
		pagination:true,
		nowrap:true,
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
			if((Subflag==1)&&(SubUserflag==1)){
				$('#REceive').hide();
				$('#RepImpFlag').hide();
			}else{
				$('#REceive').show(); //2018-03-28 cy 去掉接收按钮
				$('#RepImpFlag').show();
			}
			
		    var FileFlag=JudgeIsOutCome(); //归档状态
		    if(FileFlag==0){
			    $('#File').show();
			    $('#File').attr('class','toolbar-file');
				$('#File').text($g("归档"));
			}else if(FileFlag==1){ // 1个人 报告已归档 显示撤销归档按钮
				$('#File').show();
				$('#File').attr('class','toolbar-fileUndo');
				$('#File').text($g("撤销归档"));
			}else if(FileFlag==2){ // 1个人  报告已撤销归档 显示归档按钮
				$('#File').show();
				$('#File').attr('class','toolbar-file');
				$('#File').text($g("归档"));
			}else if(FileFlag==3){ // 2个人 报告已归档  显示撤销复核归档按钮
				$("#File").hide();
				$("#FileAudit").show();
				$('#FileAudit').attr('class','toolbar-fileUndo');
				$('#FileAudit').text($g(" 撤销复核"));
			}else if(FileFlag==4){ // 2个人 报告已归档待复核 显示复核归档按钮和撤销归档按钮
				$("#FileAudit").show();
				$('#FileAudit').attr('class','toolbar-fileUndo');
				$('#FileAudit').text($g("归档复核"));
				$("#File").show();
				$('#File').attr('class','toolbar-fileUndo');
				$('#File').text($g("撤销归档"));
			}else if(FileFlag==5){ // 2个人 报告已归撤销归档 显示归档按钮
				$("#File").show();
				$('#File').attr('class','toolbar-file');
				$('#File').text($g("归档"));
				$("#FileAudit").hide();

			}else{
				$("#FileAudit").hide();
			}
	        ButtonInfo();
	    },
        onUnselect:function(rowIndex, rowData){ 
        	ButtonInfo();
		},
		onSortColumn:function (sort,order){
			ColSort=sort;
			ColOrder=order;
			Query();
 		},onDblClickRow:function(rowIndex, rowData){ 
        	setCellEditSymbol("DblClick", rowData, rowIndex);
		}  
	});
	if(StrParam==""){
		Query();
	}
	//initScroll("#maindg");//初始化显示横向滚动条
}
function GetParamList(){
	
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
	//StrParam=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+statShare+"^"+receive+"^^^^^^^"+OverTime+"^^^^^^2";
	StrParam=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+statShare+"^"+receive+"^"+receiveflag+"^"+impflag+"^"+appauditflag+"^"+backflag+"^"+auditflag+"^"+inpfileflag+"^"+OverTime+"^"+homeAutOverTime+"^^^^^2";
	return StrParam;
}
function Query()
{
	//1、清空datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	StrParam=GetParamList();
	var ColParam=ColSort+"^"+ColOrder;
	$('#maindg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryAuditRepList',	
		queryParams:{
			StrParam:StrParam,
			LgParam:LgParam,
			ParStr:getParStr(),
			ColParam:ColParam}
	});
	//audittitle="";
	$('#audittitle').html($g("报告审核查询")+audittitle);
	//var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+"";
	//location.href=Rel;
}

///设置编辑连接
function setCellEditSymbol(value, rowData, rowIndex)
{
		var recordID=rowData.recordID;         //表单填写记录ID
		var RepID=rowData.RepID;               //报告ID   yangyongtao 2017-11-28
		var RepStaus=rowData.RepStaus;         //表单状态
		var RepStausDr=rowData.RepStausDr;     //表单状态Dr
		var RepTypeDr=rowData.RepTypeDr;       //报告类型Dr
		var RepTypeCode=rowData.RepTypeCode;   //报告类型代码
		var RepType=rowData.RepType;           //报告类型
		var StatusLast=rowData.StatusLast;     //报告上一状态
		var Medadrreceivedr=rowData.Medadrreceivedr; //接收状态dr
		var StatusNextID=rowData.StatusNextIDaudit // StatusNextIDaudit 为匹配权限的下一状态  替换 rowData.StatusNextID; //下一状态ID
		var StatusNext=rowData.StatusNext; 	   //下一状态
		var RepUser=rowData.RepUser ; 		   //报告人
		var RepUserDr=rowData.RepUserDr;   //报告人id
		var StaFistAuditUser=rowData.StaFistAuditUser;  //被驳回人
		var BackAuditUser=rowData.BackAuditUser; //驳回操作人
		var editFlag=rowData.IfRepEdit;  		//修改标志  1：允许修改(报告未做审核操作且报告未归档)，其他：不允许修改
		var StsusGrant=rowData.StsusGrant; 		//审核标识
		var StatusLastID=rowData.StatusLastID;  //上一个状态
		var StaFistAuditUser=rowData.StaFistAuditUser; //被驳回人
		var UserLeadflag=rowData.UserLeadflag;  //科护士长标识
		var FileFlag=rowData.FileFlag;  			//归档标识
		var RepAppAuditFlag=rowData.RepAppAuditFlag;  //待审批标识
		var Medadrreceive=rowData.Medadrreceive;     //接受状态
		var RepLocDr=rowData.RepLocDr;				 //上报科室		sufan 2019-06-24
		var SubUserflag=rowData.SubUserflag;     // 转抄人标志
		var AdmID=rowData.AdmID;     // 就诊id

		if((RepAppAuditFlag!=1)&&(Medadrreceivedr!=2)){
			editFlag=-1;
		}
		
		if((Medadrreceivedr==2)&&(StaFistAuditUser!=LgUserName)&&(BackAuditUser!=LgUserName)){
			editFlag=-1;
		}
		
		if((FileFlag.indexOf($g("归档")) > 0)&&(FileFlag!=$g("未归档"))&&(FileFlag!=$g("撤销归档"))){
			editFlag=-1;
		}
		if(editFlag!="1"){
			editFlag=-1;
		}
		FileFlag=escape(FileFlag);  		//归档标识
		RepStaus=escape(RepStaus);         //表单状态
		RepType=escape(RepType);           //报告类型
		StatusLast=escape(StatusLast);     //报告上一状态
		StatusNext=escape(StatusNext); 	   //下一状态
		RepUser=escape(RepUser) ; 		   //报告人
		StaFistAuditUser=escape(StaFistAuditUser);  //被驳回人
		BackAuditUser=escape(BackAuditUser); //驳回操作人
		Medadrreceivedr=escape(Medadrreceivedr); //接收状态dr
		Medadrreceive=escape(Medadrreceive);     //接收状态
		if(value!="DblClick"){  // 
			return "<a href='#' onclick=\"showEditWin('"+recordID+"','"+RepStaus+"','"+RepTypeDr+"','"+RepTypeCode+"','"+RepType+"','"+RepID+"','"+editFlag+"','"+RepStausDr+"','"+StatusNextID+"','"+Medadrreceivedr+"','"+FileFlag+"','"+StsusGrant+"','"+StatusLastID+"','"+StaFistAuditUser+"','"+UserLeadflag+"','"+RepAppAuditFlag+"','"+StatusNext+"','"+RepUser+"','"+Medadrreceive+"','"+RepLocDr+"','"+SubUserflag+"','"+AdmID+"')\"><img src='../scripts/dhcadvEvt/images/adv_sel_8.png' border=0/></a>";
		}else{
			showEditWin(recordID,RepStaus,RepTypeDr,RepTypeCode,RepType,RepID,editFlag,RepStausDr,StatusNextID,Medadrreceivedr,FileFlag,StsusGrant,StatusLastID,StaFistAuditUser,UserLeadflag,RepAppAuditFlag,StatusNext,RepUser,Medadrreceive,RepLocDr,SubUserflag,AdmID);
		}
}

//编辑窗体
function showEditWin(recordID,RepStaus,RepTypeDr,RepTypeCode,RepType,RepID,editFlag,RepStausDr,StatusNextID,Medadrreceivedr,FileFlag,StsusGrant,StatusLastID,StaFistAuditUser,UserLeadflag,RepAppAuditFlag,StatusNext,RepUser,Medadrreceive,RepLocDr,SubUserflag,AdmID)
{
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:$g('报告编辑'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		width:screen.availWidth-100,    ///2017-11-23  cy  修改弹出窗体大小 1250
		height:screen.availHeight-100
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+RepTypeDr+'&code='+RepTypeCode+'&desc='+RepType+'&RepID='+RepID+'&editFlag='+editFlag+'&adrReceive='+Medadrreceivedr+'&RepStausDr='+RepStausDr+'&StatusNextID='+StatusNextID+'&FileFlag='+FileFlag+'&StsusGrant='+StsusGrant+'&StatusLastID='+StatusLastID+'&StaFistAuditUser='+StaFistAuditUser+'&UserLeadflag='+UserLeadflag+'&RepAppAuditFlag='+RepAppAuditFlag+'&StatusNext='+StatusNext+'&winflag='+2+'&RepUser='+RepUser+'&Medadrreceive='+Medadrreceive+'&RepLocDr='+RepLocDr+'&SubUserflag='+SubUserflag+'&AdmID='+AdmID+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
	//window.open("formrecorditmedit.csp?recordId="+rowsData.ID)
}

//接收
function REceive()
{
	var NextLoc="";
	var LocAdvice="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	
	var RepFileFlag=""; //归档状态 2018-01-23
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //归档状态 2018-01-23
		if (FileFlag==$g("已归档")){
			RepFileFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert($g("提示:"),$g("所选报告存在已归档报告，不能接收！"));
		return;
	}
	$.messager.confirm($g("提示"), $g("是否进行接收操作"), function (res) {//提示是否删除
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //关联主表ID
				var RepTypeCode=item.RepTypeCode;         //报告类型代码
				var Medadrreceivedr=item.Medadrreceivedr;//接收状态dr
				var RepStausDr=item.RepStausDr //当前状态id
				var params=RepID+"^"+RepStausDr+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+RepTypeCode;   //参数串

				//var num=$('#maindg').datagrid("getRowIndex",item); //2017-11-23  获取index值 
				//var errnum=$('[datagrid-row-index="'+num+'"] .datagrid-cell-rownumber').text(); //2017-11-23 获取行号
				//alert(params);
				//保存数据
				runClassMethod("web.DHCADVCOMMONPART","REMataReport",{'params':params,'LgParam':LgParam},
				function(jsonString){ 
				//$.post(url+'?action=REMataReport',{"params":params},function(jsonString){
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  获取行数 区分哪一行操作出错
					if(jsonString.ErrCode < 0){
						$.messager.alert($g("提示:"),$g("接收错误,错误原因:")+"<font style='color:red;'>"+$g(jsonString.ErrMsg)+"</font>");  //+"第"+errnum+"条数据"
					}
					
				});
			})
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
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("提示:"),$g("驳回操作,请只选择一行数据！"));
		return;
	}
	var RepFileFlag="",RepBackFlag="" //归档状态 2018-01-23  是否可以驳回标识审核完毕的报告不能进行驳回操作） 2018-04-08
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //归档状态 2018-01-23
		var StatusNextID=item.StatusNextID; //报告下一状态ID 2018-04-08
		if (FileFlag==$g("已归档")){
			RepFileFlag="-1";
		}
		if(StatusNextID==""){
			RepBackFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert($g("提示:"),$g("所选报告存在已归档报告，不能驳回！"));
		return;
	}
	if (RepBackFlag=="-1"){
		$.messager.alert($g("提示:"),$g("所选报告存在已审核完毕的报告，不能驳回！"));
		return;
	}
	var RepStausDr=selItems[0].RepStausDr //当前状态id
	$("#showalert").show();//hxy 08-30 显示背影层
	$('#RetWin').window({
		title:$g('驳回'),
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
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("提示:"),$g("驳回操作,请只选择一行数据！"));
		return;
	}
	if (RevStatus==""){
		$.messager.alert($g("提示:"),$g("请选择驳回指向！"));
		return;
	}
	if ($('#RevStatus').combobox('getText')=="护理部审核"){
		$.messager.alert($g("提示:"),$g("护理部未审核，驳回指向不能为护理部审核！"));
		return;
	}
	if (Retreason==""){
		$.messager.alert($g("提示:"),$g("请填写驳回意见！"));
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
					$.messager.alert($g("提示:"),$g("驳回错误,错误原因:")+"<font style='color:red;'>"+$g(jsonString.ErrMsg)+"</font>");   ///+"第"+errnum+"条数据"
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
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("提示:"),$g("分享操作,请只选择一行数据！"));
		return;
	}
	var RepID=selItems[0].RepID;         //报表ID
	var RepTypeCode=selItems[0].RepTypeCode;         //报告类型代码
	var RepShareStatus=selItems[0].RepShareStatus;//分享状态				
	var RepStausDr=selItems[0].RepStausDr //当前状态id
	var params=RepID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+RepTypeCode+"^"+RepStausDr+"^"+RepShareStatus   //参数串

  	var Sharemessage=""
     if(RepShareStatus==$g("未分享")){
	     Sharemessage=$g("分享");
	} 
	if(RepShareStatus==$g("分享")){
	     Sharemessage=$g("取消分享");
	}
	$.messager.confirm($g("提示"), $g("是否进行")+$g(Sharemessage)+$g("操作"), function (res) {//提示是否删除
		if (res) {
			//保存数据
			$.post(url+'?action=InsRepShare',{"params":params},function(jsonString){
				var resobj = jQuery.parseJSON(jsonString);
				if(resobj.ErrCode < 0){
					$.messager.alert($g("提示:"),$g("分享错误,错误原因:")+"<font style='color:red;'>"+resobj.ErrMsg+"</font>");
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
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
   	if (selItems.length>1){
		$.messager.alert($g("提示:"),$g("关注操作,请只选择一行数据！"));
		return;
	}
	var RepID=selItems[0].RepID;         //报表ID
	var RepTypeCode=selItems[0].RepTypeCode;         //报告类型代码
    var RepImpFlag=selItems[0].RepImpFlag;    //重点标记
  	var Impmessage=""
    if(RepImpFlag==$g("未关注")){
	     RepImpFlag="N";
	     Impmessage=$g("关注");
	} 
	if(RepImpFlag==$g("关注")){
	     RepImpFlag="Y";
	     Impmessage=$g("取消关注");
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
		$.messager.alert($g("提示:"),$g("无")+$g(Impmessage)+$g("操作权限！"));
		return;
	}
	$.messager.confirm($g("提示"), $g("是否进行"+Impmessage+"操作"), function (res) {//提示是否删除
		if (res) {
			//保存数据
			runClassMethod("web.DHCADVCOMMONPART","InsRepImp",{'RepID':RepID,'RepImpFlag':RepImpFlag},
				function(data){ 
					if (data!="0") {
						$.messager.alert($g("提示:"),Impmessage+$g("失败!"));
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
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	var Medadrreceivedr=selItems[0].Medadrreceivedr;//接收状态
	if (Medadrreceivedr==1){
		$.messager.alert($g("提示:"),$g("报告已接收不能撤销审核！"));
		return;
	}
	$.messager.confirm($g("提示"), $g("是否进行撤销审核操作"), function (res) {//提示是否删除
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //报表ID
				var RepTypeCode=item.RepTypeCode; //报告类型代码
				var StatusLastID=item.StatusLastID; //上一个状态
				var Medadrreceivedr=item.Medadrreceivedr;//接收状态
				var StatusNext=item.StatusNext; //下一个状态
				var StaFistAuditUser=item.StaFistAuditUser; //被驳回人
				
				if ((StaFistAuditUser!="")&(StaFistAuditUser!=LgUserName)){
					$.messager.alert($g("提示:"),$g("报告为驳回报告，且未驳回给当前登录人，无权限撤销审核！"));
					return;
				}
				var params=RepID+"^"+StatusLastID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+RepTypeCode;   //参数串
				//保存数据
				runClassMethod("web.DHCADVCOMMONPART","CancelAuditReport",{'params':params},
				function(jsonString){ 
					//var resobj = jQuery.parseJSON(jsonString);
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  获取行数 区分哪一行操作出错
					if(jsonString.ErrCode < 0){
						$.messager.alert($g("提示:"),$g("审核错误,错误原因:")+"<font style='color:red;'>"+$g(jsonString.ErrMsg)+"</font>");   ///+"第"+errnum+"条数据"
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
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
   	if (selItems.length>1){
		$.messager.alert($g("提示:"),$g("审核操作,请只选择一行数据！"));
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
		$.messager.alert($g("提示:"),$g("所选报告存在已归档报告，不能审核！"));
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
				title:$g('审核'),
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
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	if(LocAdvice=="")     // wangxuejian 2016-10-26
	{
		$.messager.alert($g("提示:"),$g("处理意见不能为空！"));	
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
						$.messager.alert($g("提示:"),$g("审核错误,错误原因:")+"<font style='color:red;'>"+$g(jsonString.ErrMsg)+"</font>");   ///+"第"+errnum+"条数据"
					}
		},"json");
		
	})
	$('#maindg').datagrid('reload'); //重新加载
	$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
	$('#Process').window('close');
}

///设置审批明细连接  
function setCellAuditList(value, rowData, rowIndex)
{
		var RepID=escape(rowData.RepID);         //报表ID
		var RepTypeCode=escape(rowData.RepTypeCode); //报告类型代码
		var RepUser=rowData.RepUser; // 报告人
		var RepUserFlag=0;
		if(RepUser==$g("匿名")){
			RepUserFlag=-1;
		}
		return "<a href='#' onclick=\"showAuditListWin('"+RepID+"','"+RepTypeCode+"','"+RepUserFlag+"')\"><img src='../scripts/dhcadvEvt/images/adv_sel_11.png' border=0/></a>";
}
//编辑窗体
/*function showAuditListWin(RepID,RepTypeCode)
{
	$('#Auditwin').window({
		title:'审批明细',
		collapsible:true,
		collapsed:true, //hxy 2017-12-29
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
		{field:'LocAdvice',title:'处理意见/驳回意见',width:280,formatter:transAdvice},
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
		{field:'MedILocAdvice',title:'科室意见',width:200,formatter:transAdvice},
		{field:'MedINextUser',title:'指向人员',width:100},
		{field:'MedINextUserDR',title:'指向人员ID',width:100,hidden:true},
		{field:'MedIUserAdvice',title:'人员意见',width:200,formatter:transAdvice},
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
	$("#Auditwin").window('expand'); //hxy 2017-12-29
	$('#Auditwin').window('open');
	
}*/

function showAuditListWin(RepID,RepTypeCode,RepUserFlag)
{
	if($('#winonline').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="winonline"></div>');
	$('#winonline').window({
		title:$g('审批明细'),
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		resizable:false,
		closed:"true",
		width:1100,
		height:500
	});
	$('#winonline').window('open');
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.exaappdetail.csp?RepID='+ RepID +'&RepTypeCode='+ RepTypeCode+'&RepUserFlag='+ RepUserFlag +'"></iframe>';
	$('#winonline').html(iframe);
	
	
}
/// qunianpeng 2018/1/3 ￠转换成^    ∑转换成"
function transAdvice(value, rowData, rowIndex){
	if (value != undefined) {
		value = value.replace(/\￠/g,"^");
		return value.replace(/\∑/g,'"');
	}
	return "";
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

/*// 导出word 卫计委
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
}*/
// 导出Excel 卫计委
function ExportExcel()
{
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert($g("提示:"),"<font style='color:red;font-weight:bold;font-size:20px;'>"+$g("已取消操作！")+"</font>","error");
		return;
	}
  var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert($g("提示:"),"<font style='color:red;font-weight:bold;font-size:20px;'>"+$g("请选择有效路径后,重试！")+"</font>","error");
		return;
	}
	var Staticflag=ExportExcelStatic(StDate,EndDate,filePath);
	if(Staticflag==true){
	$.messager.alert($g("提示:"),"<font style='color:green;font-weight:bold;font-size:20px;'>"+$g("导出完成！导出目录为:")+filePath+"</font>","info");
	}/*else{
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	}*/
}
// 导出Excel 医管局
function ExportExcelAll()
{

	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var typeevent=$('#typeevent').combobox('getText');  //报告类型
	if((typeevent=="")||(typeevent=="全部")){
		$.messager.alert($g("提示:"),"<font style='color:red;font-weight:bold;font-size:20px;'>"+$g("请选择具体报告类型,重试！")+"</font>","error");
		return;
	}
	if((typeevent.indexOf("医疗") >= 0)){
		$.messager.alert($g("提示:"),$g("该类型没有医管局需要数据，请选择其他类型"),"error");
		return;
	}
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert($g("提示:"),"<font style='color:red;font-weight:bold;font-size:20px;'>"+$g("已取消操作！")+"</font>","error");
		return;
	}
  var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert($g("提示:"),"<font style='color:red;font-weight:bold;font-size:20px;'>"+$g("请选择有效路径后,重试！")+"</font>","error");
		return;
	}
	var Allflag=ExportExcelAllData(StDate,EndDate,typeevent,filePath);
	if(Allflag==true){
	$.messager.alert($g("提示:"),"<font style='color:green;font-weight:bold;font-size:20px;'>"+$g("导出完成！导出目录为:")+filePath+"</font>","info");
	}/*else{
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	}*/
}
// 导出(动态)
function Export()
{
	var typeevent=$('#typeevent').combobox('getValue');  //报告类型
	if((typeevent=="")||(typeevent=="全部")){
		$.messager.alert($g("提示:"),$g("请选择具体报告类型"),"error");
		return;
	}
	/// 2021-07-09 cy 导出明细改造
	var LinkID="",FormNameID="";
	runClassMethod("web.DHCADVCOMMONPART","GetFormNameID",{"AdrEvtDr":typeevent},
	function(ret){
		FormNameID=ret
	},'text',false);
	runClassMethod("web.DHCADVEXPFIELD","GetExpLinkID",{"FormNameDr":FormNameID,"HospDr":LgHospID},
	function(ret){
		LinkID=ret
	},'text',false);
	//窗体处在打开状态,退出
	if(!$('#ExportWin').is(":visible")){
		$('#ExportWin').window('open');
		reloadAllItmTable(LinkID);
		$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 
		return;
	} 
	
	$('#ExportWin').window({
		title:$g('导出'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:false,
		width:800,
		height:480
	});
	$('#ExportWin').window('open');
	initDatagrid(LinkID);
	$("#cuidAdd").bind('click',addItm); //a:contains('添加元素')
    $("#cuidDel").bind('click',delItm); //a:contains('删除元素')
    $("#cuidSelAll").bind('click',selAllItm); //a:contains('全部选中')
    $("#cuidCanSel").bind('click',unSelAllItm); //a:contains('取消选中')
    $("#cuidDelAll").bind('click',delAllItm); //a:contains('全部删除')

}

function initDatagrid(LinkID){
	var columns=[[
		{field:'FormDicID',title:'FormDicID',width:50,hidden:true},
		{field:'DicField',title:'DicField',width:100,hidden:true},
		{field:'DicDesc',title:$g('全部列'),width:200}
	]];
	
	$("#allItmTable").datagrid({
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetSetFiel",
		queryParams:{
			LinkID:LinkID
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		loadMsg: $g('正在加载信息...'),
		rownumbers : false,
		pagination:false
	});	
	
	var setcolumns=[[
		{field:'FormDicID',title:'FormDicID',width:50,hidden:true},
		{field:'DicField',title:'DicField',width:100,hidden:true},
		{field:'DicDesc',title:$g('导出列'),width:200}
	]];

	$("#setItmTable").datagrid({
		url:"",
		fit:true,
		rownumbers:true,
		columns:setcolumns,
		loadMsg: $g('正在加载信息...'),
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});
	$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 		
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
		LinkID:value
	})
}
function ExportOK(){
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var RepType=$('#typeevent').combobox('getText');  //报告类型
	var datas = $("#setItmTable").datagrid("getRows");
	if(datas.length<1){
		$.messager.alert($g("提示"),$g("导出列为空，请添加导出列！"));
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
	var filePath="";
	ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList,StrParam,LgParam,getParStr());
	//var filePath=browseFolder();
	//if (typeof filePath=="undefined"){
	//	$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>已取消操作！</font>","error");
	//	return;
	//}
  	//var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	//if ((filePath.match(re)=="")||(filePath.match(re)==null)){
	//	$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择有效路径后,重试！</font>","error");
	//	return;
	//}
	//var Allflag=ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList);
	//if(Allflag==true){
	//	$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
	//	$('#ExportWin').window('close');
	//}else{
	//	$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	//} 
	
}
// 全部导出Excel 
function ExportAll()
{

	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var typeevent=$('#typeevent').combobox('getText');  //报告类型
	ExportAllData(StDate,EndDate,typeevent,StrParam,LgParam,getParStr());
	
	/* if((typeevent=="")||(typeevent=="全部")){
		$.messager.alert("提示:","类型条件为空，请选择类型","error");
		return;
	} */
	/*var filePath=browseFolder();
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
	} */
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
		$.messager.alert($g("提示:"),"<font style='color:red;font-weight:bold;font-size:20px;'>"+$g("已取消操作！")+"</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert($g("提示:"),"<font style='color:red;font-weight:bold;font-size:20px;'>"+$g("请选择有效路径后,重试！")+"</font>","error");
		return;
	}
	var Allflag=ExportGatherData(StDate,EndDate,typeevent,filePath);
	if(Allflag==true){
		$.messager.alert($g("提示:"),"<font style='color:green;font-weight:bold;font-size:20px;'>"+$g("导出完成！导出目录为:")+filePath+"</font>","info");
	}/*else{
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	}*/
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
function CancelFilewin(flag)
{
	
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	var title=flag==1?$g("撤销归档"):$g("撤销复核");
	$("#showalert").show();//hxy 08-30 显示背影层
	$('#CanFileWin').window({
		title:title,
		collapsible:false,
		border:false,
		closed:false,
		minimizable:false,
		maximizable:false,
		closable:false,
		width:600,
		height:400
	});
	$('#CanFileWin').window('open');
	
	///初始化归档列表
	InitCancFileList(flag);
	
	//归档建议
	$('#canfilereason').empty();
	

}

//归档
function File()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
   	if (selItems.length>1){
		$.messager.alert($g("提示:"),$g("归档操作,请只选择一行数据！"));
		return;
	}
	
    var FileFlag=selItems[0].FileFlag; //归档状态 2018-01-23
    
    var winshowflag="";
    $.each(selItems, function(index, item){
		var StatusNextID=item.StatusNextID; //下一个状态
		var FileFlag=item.FileFlag; //归档状态 2018-01-23
		if((StatusNextID!="")||(FileFlag==$g("已归档"))){
			winshowflag=-1;
		}
	
	});
    if((JudgeIsOutCome()==1)||(JudgeIsOutCome()==4)){   //
	    CancelFilewin(1);
	    return;
	}else{
		if(winshowflag=="-1"){
		$.messager.alert($g("提示:"),$g("所勾选报告有未审核完成的报告，请仔细检查勾选数据！"));
		return;
	}
		$("#showalert").show();//hxy 08-30 显示背影层
		$('#FileWin').window({
			title:$g('归档'),
			collapsible:false,
			border:false,
			closed:false,
			minimizable:false,
			maximizable:false,
			closable:false,
			resizable:false,
			width:600,
			height:310
		});
		$('#FileWin').window('open');
		//归档建议
		$('#filereason').empty();
		$('#UserCodeFile').val(LgUserCode);
		$('#UserCodeFile').attr("disabled","true");
		$('#passWordFile').val("");
	}
}

//确认归档
function ConfirmFile()
{	
	var filereason=$.trim($('#filereason').val());
	if (filereason==""){
		$.messager.alert($g("提示:"),$g("归档建议不能为空！"));
		return;
	}
	filereason= $_TrsSymbolToTxt(filereason); /// 处理特殊符号	
	var UserCodeFile=$('#UserCodeFile').val();
	if (UserCodeFile==""){
		$.messager.alert($g("提示:"),$g("归档人员不能为空！"));
		return;
	}
	var passWordFile=$('#passWordFile').val();
	if (passWordFile==""){
		$.messager.alert($g("提示:"),$g("归档人员密码不能为空！"));
		return;
	}
	var selItems = $('#maindg').datagrid('getSelections');
    var RepTypeCode=selItems[0].RepTypeCode; //归档状态 2018-01-23
	var UserIDFile="",UserIDAudit="",ifFileflag="",ifAuditflag="";
	runClassMethod("web.DHCADVREPFILE","ConfirmPassWord",{ 'userCode':UserCodeFile,'passWord':passWordFile,'RepTypeCode':RepTypeCode,'LgParam':LgParam},
		function(data){ 
			if(data.split("^")[0] != 0){
				$.messager.alert($g("提示:"),$g("归档人员：")+"<font style='color:red;'>"+$g(data)+"</font>");
				ifFileflag=-1;
			}else{
				UserIDFile = data.split("^")[1];   ///这个就是用户ID
			}
	},"",false);
	if (ifFileflag=="-1"){
		return;
	}
	var UserIDAudit="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	var FileId=serverCall("web.DHCADVCOMMONPART","GetFileRecordId",{"RepID":selItems[0].RepID,"RepTypeDr":selItems[0].RepTypeDr,"flag":1})
	
	$.each(selItems, function(index, item){
		
		var RepID=item.RepID;         //报表ID
		var RepTypeCode=item.RepTypeCode; //报告类型代码
		var RepStausDr=item.RepStausDr; //当前状态
		
		var Medadrreceivedr=item.Medadrreceivedr;//接收状态
		var Auditnum=FileTimes>1?7:5;
		var auditparams=RepID+"^"+RepStausDr+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+""+"^"+filereason+"^"+Auditnum+"^"+RepTypeCode;   //参数串
		var fileparams=RepID+"^"+RepTypeCode+"^"+"01"+"^"+UserIDFile+"^"+UserIDAudit+"^"+FileId;   //参数串
		
		//alert(auditparams+"hhhhh"+fileparams);
		var num=$('#maindg').datagrid("getRowIndex",item); //2017-11-23  获取index值 
		var errnum=$('[datagrid-row-index="'+num+'"] .datagrid-cell-rownumber').text(); //2017-11-23 获取行号
		runClassMethod("web.DHCADVCOMMONPART","FileMataReport",{'auditparams':auditparams,'fileparams':fileparams},
				function(jsonString){ 
					if(jsonString < 0){
						$.messager.alert($g("提示:"),$g("报告归档失败!")+"ErrCode:"+jsonString);   ///+"第"+errnum+"条数据"
					}
		},"",false);
		
	})
	$('#maindg').datagrid('reload'); //重新加载
	$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
	$('#FileWin').window('close');
	$("#showalert").hide();
}
///归档复核
function FileAudit()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
   	if (selItems.length>1){
		$.messager.alert($g("提示:"),$g("归档操作,请只选择一行数据！"));
		return;
	}
	
    var FileFlag=selItems[0].FileFlag; //归档状态 2018-01-23
    
    var winshowflag="";
    $.each(selItems, function(index, item){
		var StatusNextID=item.StatusNextID; //下一个状态
		var FileFlag=item.FileFlag; //归档状态 2018-01-23
		if((StatusNextID!="")||(FileFlag==$g("已归档"))){
			winshowflag=-1;
		}
	
	});
    if(JudgeIsOutCome()==3){   
	    CancelFilewin(2);
	    return;
	}else{
		if(winshowflag=="-1"){
		$.messager.alert($g("提示:"),$g("所勾选报告有未审核完成的报告，请仔细检查勾选数据！"));
		return;
	}
		$("#showalert").show();//hxy 08-30 显示背影层
		$('#RevFileWin').window({
			title:$g('归档复核'),
			collapsible:false,
			border:false,
			closed:false,
			minimizable:false,
			maximizable:false,
			resizable:false,
			closable:false,
			width:600,
			height:310
		});
		$('#RevFileWin').window('open');
		//InitFileList();
		//归档建议
		$('#filereasonaud').empty();
		$('#UserCodeAudit').val(LgUserCode);
		$('#UserCodeAudit').attr("disabled","true");
		$('#passWordAudit').val("");
	}
}

///确认复核归档
function RevFile()
{
	var filereason=$.trim($('#filereasonaud').val());
	if (filereason==""){
		$.messager.alert($g("提示:"),$g("复核归档建议不能为空！"));
		return;
	}
	filereason = $_TrsSymbolToTxt(filereason); /// 处理特殊符号
	var UserCodeFile=$('#UserCodeAudit').val();
	if (UserCodeFile==""){
		$.messager.alert($g("提示:"),$g("复核归档人员不能为空！"));
		return;
	}
	var passWordFile=$('#passWordAudit').val();
	if (passWordFile==""){
		$.messager.alert($g("提示:"),$g("复核归档人员密码不能为空！"));
		return;
	}
	var selItems = $('#maindg').datagrid('getSelections');
    var RepTypeCode=selItems[0].RepTypeCode; //归档状态 2018-01-23
	var UserIDFile="",UserIDAudit="",ifFileflag="",ifAuditflag="";
	runClassMethod("web.DHCADVREPFILE","ConfirmPassWord",{ 'userCode':UserCodeFile,'passWord':passWordFile,'RepTypeCode':RepTypeCode,'LgParam':LgParam},
		function(data){ 
			if(data.split("^")[0] != 0){
				$.messager.alert($g("提示:"),$g("复核归档人员：")+"<font style='color:red;'>"+$g(data)+"</font>");
				ifFileflag=-1;
			}else{
				UserIDFile = data.split("^")[1];   ///这个就是用户ID
			}
	},"",false);
	if (ifFileflag=="-1"){
		return;
	}
	var UserIDAudit="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	
	var FileId=serverCall("web.DHCADVCOMMONPART","GetFileRecordId",{"RepID":selItems[0].RepID,"RepTypeDr":selItems[0].RepTypeDr,"UserId":LgUserID,"flag":2})
	
	$.each(selItems, function(index, item){
		
		var RepID=item.RepID;         //报表ID
		var RepTypeCode=item.RepTypeCode; //报告类型代码
		var RepStausDr=item.RepStausDr; //当前状态
		var Medadrreceivedr=item.Medadrreceivedr;//接收状态
		var auditparams=RepID+"^"+RepStausDr+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+""+"^"+filereason+"^"+5+"^"+RepTypeCode;   //参数串
		var fileparams=RepID+"^"+RepTypeCode+"^"+"02"+"^"+UserIDFile+"^"+UserIDAudit+"^"+FileId;   //参数串
		
		//alert(auditparams+"hhhhh"+fileparams);
		var num=$('#maindg').datagrid("getRowIndex",item); //2017-11-23  获取index值 
		var errnum=$('[datagrid-row-index="'+num+'"] .datagrid-cell-rownumber').text(); //2017-11-23 获取行号
		runClassMethod("web.DHCADVCOMMONPART","FileMataReport",{'auditparams':auditparams,'fileparams':fileparams},
				function(jsonString){ 
					//var resobj = jQuery.parseJSON(jsonString);
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  获取行数 区分哪一行操作出错
					if(jsonString < 0){
						$.messager.alert($g("提示:"),$g("报告复核归档失败!"));   ///+"第"+errnum+"条数据"
					}
		},"",false);
		
	})
	$('#maindg').datagrid('reload'); //重新加载
	$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
	$('#RevFileWin').window('close');
	$("#showalert").hide();
}
//作废
function RepCancel()
{
	var NextLoc="";
	var LocAdvice="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	var RepFileFlag=""; //归档状态 2018-01-23
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //归档状态 2018-01-23
		if (FileFlag==$g("已归档")){
			RepFileFlag="-1";
		}
	})
	
	if (RepFileFlag=="-1"){
		$.messager.alert($g("提示:"),$g("所选报告存在已归档报告，不能作废！"));
		return;
	}
	$.messager.confirm($g("提示"), $g("是否进行作废操作"), function (res) {//提示是否删除
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
						$.messager.alert($g("提示:"),$g("作废错误,错误原因:")+"<font style='color:red;'>"+$g(jsonString.ErrMsg)+"</font>");  //+"第"+errnum+"条数据"
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
// 文本编辑格
var texteditors={
	type: 'text',//设置编辑格式
}

var adviceditor={
	type: 'textarea'//设置编辑格式
	
}
///添加共享指向科室
function CaseShare(){
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("提示:"),$g("只能选中一行数据,请重试！"));
		return;
	}
	var RepID=selItems[0].RepID;         //关联主表ID
	var RepTypeCode=selItems[0].RepTypeCode;         //报告类型代码
	var params=RepID+"^"+RepTypeCode;
	CaseShareShow(params);
}
function CaseShareShow(params){
	$('#WardW').window({
			title:$g('案例共享'),
			collapsible:false,
			border:false,
			minimizable:false,
			maximizable:false,
			resizable:false,
			width:900,
			height:450
		});
	$('#WardW').window('open');	
	//是否可用标志
	var activeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			//required:true,
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
			//url:url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'',
			//required:true,
			mode:'remote',  //,  //必须设置这个属性
			onSelect:function(option){
				///设置类型值
				var eds=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareLocDr'});
				if($(eds.target).val()!=option.val){
					var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareUser'});
					$(ed.target).combobox('setValue',""); 
					var eds=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareUserDr'});
					$(eds.target).val("");
				}
				var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareLoc'});
				$(ed.target).combobox('setValue', option.text); 
				var eds=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareLocDr'});
				$(eds.target).val( option.val);
			},		
			onShowPanel:function(){
				var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareLoc'});
				var unitUrl=url+'?action=GetAllLocNewVersion&hospId='+LgHospID+''
				$(ed.target).combobox('reload',unitUrl);
			} 
		}
	}
	
   //用户
	var Usereditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "val", 
			textField: "text",
			//url:url+'?action=GetLocUserList&LocDr='+4+'',
			//required:true,
			mode:'remote',  //,  //必须设置这个属性
			onSelect:function(option){
			///设置类型值
				var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareUser'});
				$(ed.target).combobox('setValue', option.text); 
				var eds=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareUserDr'});
				$(eds.target).val( option.val); 				
			},
			onShowPanel:function(){
				var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareLocDr'});
				var LocID = $(ed.target).val();
				var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareUser'});
				var unitUrl=url+'?action=GetLocUserList&LocDr='+LocID+''
				$(ed.target).combobox('reload',unitUrl);
			} 
		}
	}
		
	// 定义columns
	var columns=[[
		{field:"RepDr",title:$g('报告指向'),width:80,editor:texteditor,hidden:true}, 
		{field:'RepTypeCode',title:$g('状态代码'),width:80,editor:texteditor,hidden:true},
		{field:"ShareLocDr",title:$g('科室Dr'),width:80,editor:texteditor,hidden:true},
		{field:"ShareLoc",title:$g('科室'),width:200,editor:Eventeditor},		
		{field:"ShareUserDr",title:$g('用户Dr'),width:80,editor:texteditors,hidden:true},
		{field:"ShareUser",title:$g('用户'),width:140,editor:Usereditor},
		{field:"ShareAdvice",title:$g('意见/目的'),width:350,editor:adviceditor},
		{field:'Active',title:$g('是否共享'),width:80,editor:activeEditor},
		{field:"ID",title:'ID',width:70,align:'center',hidden:true}
	]];
	
	// 定义datagrid
	$('#Warddg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCASESHARE&MethodName=QueryCaseShare'+'&params='+params,
		fit:true,
		rownumbers:true,
		columns:columns, 
		pageSize:10,  // 每页显示的记录条数
		pageList:[10,20,40],   // 可以设置每页记录条数的列表 
	    singleSelect:true,
	    nowrap:false,
	    pagination:true,
		loadMsg: $g('正在加载信息...'),
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((loceditRow != "")||(loceditRow == "0")) {
            	$("#Warddg").datagrid('endEdit', loceditRow);
			}
            $("#Warddg").datagrid('beginEdit', rowIndex); 
            var ed=$("#Warddg").datagrid('getEditor',{index:rowIndex,field:'ShareLoc'});
            if((rowData.ShareLoc!="")&&(rowData.ID!="")){
	            $(ed.target).combobox({disabled:true});
	            $(ed.target).combobox('setValue',rowData.ShareLoc);
	        }else{
		        $(ed.target).combobox({disabled:false});
		    }
		    
		    var ed=$("#Warddg").datagrid('getEditor',{index:rowIndex,field:'ShareUser'});
            if((rowData.ShareUser!="")&&(rowData.ID!="")){
	            $(ed.target).combobox({disabled:true});
	            $(ed.target).combobox('setValue',rowData.ShareUser);
	        }else{
		        $(ed.target).combobox({disabled:false});
		    }
		    var ed=$("#Warddg").datagrid('getEditor',{index:rowIndex,field:'ShareAdvice'});
		    $(ed.target).css("word-break","break-all");
            if((rowData.ShareAdvice!="")&&(rowData.ID!="")){
	            $(ed.target).val(rowData.ShareAdvice);
	            $(ed.target).attr("readonly","readonly");
	        }else{
		        $(ed.target).attr("readonly",false);
		    }
		    
            loceditRow = rowIndex; 
        }
        
	});
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
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("提示:"),$g("只能选中一行数据,请重试！"));
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
			$.messager.alert($g("提示"),$g("有必填项未填写，请核实!")); 
			return false;
		}
	} 
	$("#Warddg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		
		index: 0, // 行数从0开始计算
		row: {ID: '',RepDr:RepID,RepTypeCode: RepTypeCode,EventType:'',ShareLocDr:'',ShareLoc:'',ShareUserDr:'',ShareUser:'',ShareAdvice:'',Active: 'Y'}
	});
	
	$("#Warddg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	loceditRow=0;
	var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareAdvice'});
	$(ed.target).css("word-break","break-all");
	
}
// 保存编辑行
function saveSecuGUW()
{
	if(loceditRow>="0"){
		$("#Warddg").datagrid('endEdit', loceditRow);
	}
	var rows = $("#Warddg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert($g("提示"),$g("没有待保存数据!"));
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ShareLoc=="")){
			$.messager.alert($g("提示"),$g("有必填项未填写，请核实!")); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].RepDr+"^"+rows[i].RepTypeCode+"^"+rows[i].ShareLocDr+"^"+rows[i].Active+"^"+LgUserID+"^"+rows[i].ShareUserDr+"^"+rows[i].ShareAdvice;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	
	runClassMethod("web.DHCADVCASESHARE","SaveCaseShare",{'DataList':rowstr},
	function(data){ 
		if(data==0){
			$.messager.alert($g('提示'),$g('操作成功'));
		}else if ((data == -1)||((data == -2))){
			$.messager.alert($g('提示'),$g('科室重复,请核实后再试'),'warning');
			return;	//2017-03-17 保存失败，刷新字典表
		}else {
			$.messager.alert($g('提示'),$g('操作失败'),'warning');
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
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("提示:"),$g("请选中一条数据！"));
		return;
	}
	var RepFileFlag=""; //归档状态 2018-01-23
	var StatusLast=selItems[0].StatusLast; //报告上一状态
	var RepUserDr=selItems[0].RepUserDr; //报告人
	var Medadrreceivedr=selItems[0].Medadrreceivedr; //接收状态dr
	var FileFlag=selItems[0].FileFlag; //归档状态 2018-01-23
	
	if (FileFlag=="已归档"){
		RepFileFlag="-1";
	}
	
	if (RepFileFlag=="-1"){
		$.messager.alert($g("提示:"),$g("所选报告存在已归档报告，不能删除！"));
		return;
	}
	if (RepUserDr!=LgUserID){
		$.messager.alert($g("提示:"),$g("报告非本人上报，不能删除！"));
		return;
	}
	if (((StatusLast!="")||(Medadrreceivedr!="未接收"))&&(Medadrreceivedr!=2)){
		$.messager.alert($g("提示:"),$g("报告已被接收或审核，不能删除！"));
		return;
	}

	$.messager.confirm($g("提示"), $g("是否进行删除操作"), function (res) {//提示是否删除
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //关联主表ID
				runClassMethod("web.DHCADVCOMMONPART","DelRepData",{'RepID':RepID},
				function(data){ 
					if(data< 0){
						$.messager.alert($g("提示:"),$g("删除失败！"));  //+"第"+errnum+"条数据"
					}
				},"",false);
				
			})
			$('#maindg').datagrid('reload'); //重新加载
			$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
		}
	})
}
//鱼骨图 cy 2018-08-03
function fish(){
	var selItems = $('#maindg').datagrid('getSelections');
	var RepID="",RepTypeCode=""
	if(selItems.length==1){
		RepID=selItems[0].RepID;//报告ID
		RepTypeCode=selItems[0].RepTypeCode;//报告类型代码/表单名称Code
	}
	var RepType=$('#typeevent').combobox('getValue');  //报告类型
	if (((RepTypeCode=="")||(RepTypeCode==undefined))&&((RepType=="")||(RepType==undefined))){
		$.messager.alert($g("提示:"),$g("请选中一条数据或者选择具体类型重试！"));
		return;
	}
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	
	var StrParamList=StDate+"^"+EndDate+"^"+RepTypeCode+"^"+RepType;
	if($('#fishwin').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="fishwin"></div>');
	$('#fishwin').window({
		title:$g('鱼骨图'),
		collapsible:false,
		border:false,
		minimizable:false,
		maximizable:false,
		closed:"true",
		width:1200,
		height:620
	});
	
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.fishbone.csp?RepID='+RepID+'&StrParam='+StrParamList+'"></iframe>';
	$('#fishwin').html(iframe);
	$('#fishwin').window('open');
}
//操作  病历
function setPatientRecord(value, rowData, rowIndex)
{   
	var RepID=rowData.RepID;         //报表ID
	var RepTypeCode=rowData.RepTypeCode; //报告类型代码
	var Adm=rowData.AdmID
	var PatNo=rowData.AdmNo  //分享状态
	html = "<a href='#' onclick=\"LoadPatientRecord('"+rowData.PatID+"','"+Adm+"')\">"+PatNo+"</a>";
    return html;
   // return "<a href='#' mce_href='#' onclick='LoadPatientRecord("+rowData.PatID+","+Adm+");'>"+PatNo+"</a>";  
    
}
/// 病历查看
function LoadPatientRecord(PatID,Adm){
	//createPatInfoWin(Adm,PatID);
	
	if($('#winlode').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="winlode"></div>');
	$('#winlode').window({
		title:$g('病历浏览列表'),
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:"true",
		width:document.body.offsetWidth-100,
		height:document.body.offsetHeight-100
	});
	var frm=window.parent.document.forms["fEPRMENU"];
		if(frm.EpisodeID){
			frm.EpisodeID.value=Adm;
		} 
		
	//var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="websys.chartbook.hisui.csp?ChartBookName='+"DHC.inpatient.Doctor.DHCEMRbrowse"+"&PatientListPage="+ "inpatientlist.csp"+"&EpisodeID="+Adm+'"></iframe>';
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="websys.chartbook.hisui.csp?ChartBookName='+"DHC.Doctor.DHCEMRbrowse"+"&PatientListPage="+ "emr.browse.patientlist.csp"+"&SwitchSysPat=N"+"&EpisodeID="+Adm+'"></iframe>';
		$('#winlode').html(iframe);
		$('#winlode').window('open'); 
	
}


//操作  转归内容
function setPatOutForm(value, rowData, rowIndex)
{   
	var recordID=escape(rowData.recordID);         //报表 recordID
	var RepID=escape(rowData.RepID);         //报表ID	
	var PatOutFlag=escape(rowData.PatOutFlag);         // 转归标识
	
	if (PatOutFlag == "Y"){
		html = "<a href='#' onclick=\"LoadPatOutcomWin('"+RepID+"','"+recordID+"')\" >"+$g("是")+"</a>";
	}else{
		html = "<span>"+$g("否")+"</span>";
	}
    return html;
    
}

//编辑窗体  2018-05-07 cy 转归界面
function LoadPatOutcomWin(RepID,recordID)
{
	if($('#patoutwin').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="patoutwin"></div>');
	$('#patoutwin').window({
		title:$g('患者转归'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		width:800,    ///2017-11-23  cy  修改弹出窗体大小 1250
		height:400
	});
	var PatOutWinRecId="";
	 runClassMethod("web.DHCADVCOMMONPART","GetRecordId",
		{'LinkRecordId':recordID,
		 'FormCode':"PatOutcomform"},
		function(data){ 
			 PatOutWinRecId=data;
	},"text",false) 
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+PatOutWinRecId+'&code='+"PatOutcomform"+'&LinkRecordId='+recordID+'&RepID='+RepID+'"></iframe>'; 
	$('#patoutwin').html(iframe);
	$('#patoutwin').window('open');
}


window.onbeforeunload = onbeforeunload_handler;
/// 页面关闭之前调用
function onbeforeunload_handler() {
    var frm=window.parent.document.forms["fEPRMENU"];
	if(frm.EpisodeID){
		frm.EpisodeID.value="";
	}
}
//html打印
function htmlPrint(){

	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("提示:"),$g("请选中一条数据！"));
		return;
	}
	var RepID=selItems[0].RepID;//报告ID
	var RepTypeCode=selItems[0].RepTypeCode;//报告类型代码/表单名称Code
	var recordID=selItems[0].recordID;//表单记录IDrecordID
	var url="dhcadv.htmlprint.csp?RepID="+RepID+"&RepTypeCode="+RepTypeCode+"&recordID="+recordID+"&prtOrExp="+this.id

	//return;
	window.open(url,"_blank");
}
//判断登录人是否有操作按钮的权限来控制按钮显示与隐藏
function ButtonInfo(){
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$('#File').hide();
		$("#FileAudit").hide();
        $('#CaseShare').hide();
		$('#RepDelete').hide();
		$('#RepCancel').hide();
		$('#Fish').hide();
		$('#RepImpFlag').hide();
		$('#SHare').hide();
		return;
	}
	var FileOperSec="",CaseShareOperSec="",DeleteOperSec="",CancelOperSec="",FishOperSec="",RepImpFlagSec="",ShareFlagSec="";
	$.each(selItems, function(index, item){
		var RepTypeCode=item.RepTypeCode; //报告类型代码
		var RepImpFlag=item.RepImpFlag;    //重点关注
		    if ((RepImpFlag==$g("关注"))){
				$('#RepImpFlag').attr('class','toolbar-focusUndo');
				$('#RepImpFlag').text($g("取消关注"));
		    }else{
				$('#RepImpFlag').attr('class','toolbar-focus');
				$('#RepImpFlag').text($g("重点关注"));
		    }
		//if((RepTypeCode=="advPipeOff")||(RepTypeCode=="advDrugUseErr")||(RepTypeCode=="advFallDownFill")||(RepTypeCode=="advSkinUlcer")){
        	FishOperSec="Y";
       // }
       
       var RepShareStatus=item.RepShareStatus;    // 分享状态
       if ((RepShareStatus==$g("分享"))){
			$('#SHare').attr('class','adv_sel_71');
			$('#SHare').text($g("撤销分享"));
		}else{
			$('#SHare').attr('class','adv_sel_7');
			$('#SHare').text($g("分享"));
		}
       
		runClassMethod("web.DHCADVCOMMON","GetOperSecAll",{'RepTypeCode':RepTypeCode,'LgParam':LgParam},
		function(data){
			var tmp=data.split("^"); 
			// 分享权限
			if((tmp[0]=="Y")&&(ShareFlagSec!="N")){
				ShareFlagSec="Y";
	        }else{
		        ShareFlagSec="N";
		    }
			//重点关注权限
			if((tmp[1]=="Y")&&(RepImpFlagSec!="N")){
				RepImpFlagSec="Y";
	        }else{
		        RepImpFlagSec="N";
		    }
			//归档权限
			if((tmp[2]=="Y")&&(FileOperSec!="N")){
				FileOperSec="Y";
	        }else{
		        FileOperSec="N";
		    }
	        //案例共享权限
			if((tmp[3]=="Y")&&(CaseShareOperSec!="N")){
				CaseShareOperSec="Y";
	        }else{
		        CaseShareOperSec="N";
		    }
	        //删除权限
			if((tmp[4]=="Y")&&(DeleteOperSec!="N")){
				DeleteOperSec="Y";
	        }else{
		        DeleteOperSec="N";
		    }
	        //作废权限
			if((tmp[5]=="Y")&&(CancelOperSec!="N")){
				CancelOperSec="Y";
	        }else{
		        CancelOperSec="N";
		    }
		   	

		},"text",false);
		
	})
	// 分享权限
	if(ShareFlagSec=="N"){
		$('#SHare').hide();
    }else{
		$('#SHare').show();
    }
	//重点关注权限
	if(RepImpFlagSec=="N"){
		$('#RepImpFlag').hide();
    }else{
		$('#RepImpFlag').show();
    }
	//归档权限
	if(FileOperSec=="N"){
		$('#File').hide();
		$('#FileAudit').hide();
		
    }
    //案例共享权限
    if(CaseShareOperSec=="N"){
		$('#CaseShare').hide();
    }else{
		$('#CaseShare').show();
    }
    //删除权限
    if(DeleteOperSec=="N"){
		$('#RepDelete').hide();
    }else{
		$('#RepDelete').show();
    }
    //作废权限
    if(CancelOperSec=="N"){
		$('#RepCancel').hide();
    }else{
		$('#RepCancel').show();
    }
    //鱼骨图权限
	if(FishOperSec=="Y"){
		$('#Fish').show();
    }else{
		$('#Fish').hide();
    }
	
}
function InitFileList()
{
	var selItems = $('#maindg').datagrid('getSelections');
	
	var RepID=selItems[0].RepID;         	
	var RepTypeDr=selItems[0].RepTypeDr; 
	
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"FileId",title:'FileId',width:80,hidden:true},
		{field:"AuitUserId",title:'AuitUserId',width:80,hidden:true},
		{field:'AuitUser',title:$g('归档用户'),width:80,align:'center'},
		{field:'FileFlagCode',title:'FileFlagCode',width:60,align:'center',hidden:true},
		{field:'FileFlag',title:$g('归档标识'),width:60,align:'center'},
		{field:'FileDate',title:$g('归档日期'),width:160,align:'center'},
		{field:'FileTime',title:$g('归档时间'),width:100,align:'center'}
	]];
	//定义datagrid
	$('#filelist').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryFileList&RepID='+RepID+'&RepTypeID='+RepTypeDr,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:true,
		nowrap:false
	});
}
///初始化归档列表
function InitCancFileList(flag)
{
	var selItems = $('#maindg').datagrid('getSelections');
	
	var RepID=selItems[0].RepID;         	
	var RepTypeDr=selItems[0].RepTypeDr; 
	
	var columns=[[
		//{field:'ItemOpt',title:'操作',width:60,align:'center',formatter:SetCanFileOpUrl},
		{field:"FileId",title:'FileId',width:80,hidden:true},
		{field:"AuitUserId",title:'AuitUserId',width:80,hidden:true},
		{field:'AuitUser',title:$g('归档用户'),width:80,align:'center'},
		{field:'FileFlagCode',title:'FileFlagCode',width:60,align:'center',hidden:true},
		{field:'FileFlag',title:$g('归档标识'),width:60,align:'center'},
		{field:'FileDate',title:$g('归档日期'),width:160,align:'center'},
		{field:'FileTime',title:$g('归档时间'),width:100,align:'center'}
	]];
	//定义datagrid
	$('#cancelfilelist').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryFileList&RepID='+RepID+'&RepTypeID='+RepTypeDr+'&flag='+flag,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:true,
		nowrap:false
	});
}
/// 操作
function SetCanFileOpUrl(value, rowData, rowIndex){
	
	if ((rowData.FileFlagCode == "11")||(rowData.FileFlagCode == "12")){
		 return "";
	}
	if ((rowData.FileFlagCode == "01")||(rowData.FileFlagCode == "02")){
		var html = "<a href='#' onclick='ConfirmFileNew("+rowIndex+","+rowData.FileFlagCode+")'>"+$g("撤销")+"</a>";
	}
    return html;
}
//确认撤销归档 
function ConfirmCanFile()
{
	var canfilereason=$('#canfilereason').val();
	if (canfilereason==""){
		$.messager.alert($g("提示:"),$g("撤销归档建议不能为空！"));
		return;
	}
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	var canitem=$('#cancelfilelist').datagrid('getRows');
	var flag=canitem[0].FileFlagCode;
	var FileFlag=flag=="01"?11:12;
	var Auditnum=flag=="01"?6:7;
	var FileId=canitem[0].FileId;
	var RepID=selItems[0].RepID;         //报表ID
	var RepTypeCode=selItems[0].RepTypeCode; //报告类型代码
	var RepStausDr=selItems[0].RepStausDr; //当前状态
	var auditparams=RepID+"^"+RepStausDr+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+""+"^"+canfilereason+"^"+Auditnum+"^"+RepTypeCode;   //参数串
	var fileparams=RepID+"^"+RepTypeCode+"^"+FileFlag+"^"+LgUserID+"^"+""+"^"+ FileId;   //参数串
	runClassMethod("web.DHCADVCOMMONPART","FileMataReport",{'auditparams':auditparams,'fileparams':fileparams},
		function(jsonString){
			if(jsonString=="-1") {
				$.messager.alert($g("提示:"),$g("报告撤销操作失败! 失败原因:撤销操作人与操作人不一致"));
			}else if((jsonString !=0)){
				$.messager.alert($g("提示:"),$g("报告撤销操作失败!")+"ErrCode:"+jsonString);   ///+"第"+errnum+"条数据"
			}
	},"",false);
	$('#maindg').datagrid('reload'); //重新加载
	$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
	$('#CanFileWin').window('close');
	$("#showalert").hide();
}

///判断报告是归档状态
function JudgeIsOutCome()
{
	var selItems = $('#maindg').datagrid('getSelections');
	var RepID=selItems[0].RepID;         //报表ID
	var RepTypeDr=selItems[0].RepTypeDr;
	var FileFlag=""
	runClassMethod("web.DHCADVCOMMONPART","JudgeIsOutCome",{'RepID':RepID,'RepTypeDr':RepTypeDr,"LgParam":LgParam},
		function(jsonString){ 
			FileFlag=jsonString
			
	},"",false);
	return FileFlag;
}
/////////////////////////////////////高级查询条件////////////////////////////////////////
// 增加行
function addCondition(){
	
	curCondRow=curCondRow+1;
	var html=""
	html+='<tr id="'+curCondRow+'Tr"><td><b style="padding-left:30px">'+$g("查询条件")+'</b>';
	html+=getLookUpHtml(curCondRow,1);
	html+=getSelectHtml(curCondRow,1);
	html+='<span style="padding-left:20px;"><input class="dhcc-input" id="QueCond"'+curCondRow+"-"+1+' style="width:120"/></span>';
	html+='</td><td style="padding-left:60px"><b style="padding-left:30px">'+$g("查询条件")+'</b>';
	html+=getLookUpHtml(curCondRow,2);
	html+=getSelectHtml(curCondRow,2);
	html+='<span style="padding-left:20px;"><input class="dhcc-input" id="QueCond"'+curCondRow+"-"+2+' style="width:120"/></span>';
	html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="addCondition()"><span  class="icon icon-add" >&nbsp;&nbsp;&nbsp;&nbsp;</span>'+$g("增加行")+'</span></td>>';
	if(curCondRow>2){
		html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="removeCond('+curCondRow+')"><span  class="icon icon-remove" >&nbsp;&nbsp;&nbsp;&nbsp;</span>'+$g("删除行")+'</span></td></tr>';
	}
	$("#condTable").append(html);
	//条件
	$("input[id^=stateBox"+curCondRow+"-]").combobox({
		panelHeight:"auto", 
		data:stateBoxArray
	});
	// 查询条件列
	$("input[id^=LookUp"+curCondRow+"-]").combobox({
		data:GetFrozeData()
	});
	setHeight();
}
// 删除行
function removeCond(row){
	$("#"+row+"Tr").remove();
	setHeight();
}
function setHeight(){
    var tableHeight=$('#condTable')[0].offsetHeight
    var divHeight=tableHeight+150;
    var centertop=divHeight+50;
    var maindgHeight=$(window).height()-divHeight-120;
    if(maindgHeight<400){
	    maindgHeight='auto';
	}
    $('#northdiv').css({
        height:divHeight+'px'
    });
    $('#nourthlayot').panel('resize', {
        height:'auto'
    });
    $('#centerlayout').panel('resize', {
        top:centertop+'px',
        height:'auto'
    });
    $("#reqList").css({
	    height:maindgHeight
	})
	$("#maindg").datagrid('resize', {           
        height:maindgHeight
    }); 

}
// 条件语句
function getSelectHtml(row,column){
	var key=row+"-"+column;
	var html='<span style="padding-left:20px;">';
	html+='<input  id="stateBox'+key+'" style="width:80;" class="easyui-combobox" data-options="valueField:\'val\',textField:\'text\'"/>'
	html+='</span>'
	return html;
}
// 查询条件 输入框加载
function getLookUpHtml(row,column){
	var html="";
	var key=row+"-"+column;
	html+='<span class="lookup" style="padding-left:20px;">'
	//html+='		<input data-id="" class="textbox lookup-text validatebox-text"  style="width: 118px; height: 28px; line-height: 28px;" id="'+key+'" onkeypress="return onKeyPress(event,this)" data-key='+key+' type="text" >'
	//html+='		<span class="lookup-arrow" style="height: 28px;" onclick="showDic(this)" data-key='+key+'></span>'
	html+='<input id="LookUp'+key+'" style="width:120" class="easyui-combobox" data-options="valueField:\'val\',textField:\'text\'"/>'	
	html+='</span>'
	return html;
}
// 点击事件
function toggleExecInfo(obj){
	if($(obj).hasClass("expanded")){
		$(obj).removeClass("expanded");
		$(obj).html($g("高级查询"));
		$("#condTable").hide();
		$("#dashline").hide();
		$("#condTd").hide();
		
	}else{
		$(obj).addClass("expanded");
		$(obj).html($g("隐藏"));
		$("#condTable").show();
		$("#dashline").show();
		$("#condTd").show();
	}
	setHeight();
}
// 获取表格显示列（作为查询条件下拉数据）
function GetFrozeData(){
	//获取所有未冻结列数据
     var cols = $("#maindg").datagrid('getColumnFields');
     var array = [];
     for (var i=0;i<cols.length;i++) {     
         //获取每一列的列名对象
         var col = $("#maindg").datagrid("getColumnOption", cols[i]);
         //声明对象
         var obj = new Object();
         if((cols[i]!="ck")&&(cols[i]!="Edit")&&(cols[i]!="AuditList")&&(col.hidden!=true)){
         	obj["val"] = cols[i];
         	obj["text"] = col.title.trim();
         	//追加对象
         	array.push(obj);
         }
     }   
     return array;
}

// 获取查询条件字符串
function getParStr(){
	var retArr=[];
	var cond=$("#condCombox").combobox('getValue');
	$("#condTable").find("td").each(function(index,obj){
		if($(obj).children().length<3){
			return true;
		}
		// 条件下拉值（列名 代码）
		var column=$(obj).children().eq(1).find("input")[2];
		if(column!=undefined){
			column=column.value;
		}else{
			column="";
		}
		if(column==""){
			return true;	
		}
		// 判断条件 下拉值（大于，小于）
		var op=$(obj).children().eq(2).find("input")[2];
		if(op!=undefined){
			op=op.value;
		}else{
			op="";
		}
		// 输入判断值 （具体的数据）
		var columnValue=$(obj).children().eq(3).find("input")[0].value;
		if(columnValue==""){
			return true;
		}

		// 列_$c(1)_值_$c(1)_判断条件_$c(1)_逻辑关系
		var par=column;
		par+=String.fromCharCode(1)+columnValue;
		par+=String.fromCharCode(1)+op;
		par+=String.fromCharCode(1)+cond;
		retArr.push(par);
	})
	return retArr.join("^");
}
/////////////////////////////////////新作打印与导出////////////////////////////////////////
///新作的打印
function Print()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	$.each(selItems, function(index, item){
		var RepID=item.RepID;//报告ID
		var RepTypeCode=item.RepTypeCode;//报告类型代码/表单名称Code
		runClassMethod("web.DHCADVRepPrint","GetPrintData",{"AdvMasterDr":RepID,"PrintUserId":LgUserID,"LgHospID":LgHospID},function(ret){
			dhcprtPrint(RepTypeCode,ret,"print");
		},"json");
	})
}
///导出word格式
function ExportWordFile()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("提示:"),$g("请选中一条数据！"));
		return;
	}
	var RepID=selItems[0].RepID;//报告ID
	var RepTypeCode=selItems[0].RepTypeCode;//报告类型代码/表单名称Code
	runClassMethod("web.DHCADVRepPrint","GetPrintData",{"AdvMasterDr":RepID,"PrintUserId":LgUserID,"LgHospID":LgHospID},function(ret){
		exportword(RepTypeCode,ret);
	},"json");
}

// 持续追踪内容书写 2020-02-13
function DeptConBtn(){
	var AssWinRecId=""
	var AssWinCode="FunDeptConform"
    var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("提示:"),$g("请选中行,重试！"));
		return;
	}
   	if (selItems.length>1){
		$.messager.alert($g("提示:"),$g("持续追踪操作,请只选择一行数据！"));
		return;
	}
	var recordId=selItems[0].recordID
	if($('#deptconwin').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="deptconwin"></div>');
	$('#deptconwin').window({
		title:LgGroupDesc+$g('持续追踪内容'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		modal:true,
		width:900,    
		height:420
	});
	 runClassMethod("web.DHCADVCOMMONPART","GetRecordId",
		{'LinkRecordId':recordId,
		 'FormCode':AssWinCode},
		function(data){ 
			 AssWinRecId=data
	},"text",false) 
	
	//alert(AssWinRecId+","+AssWinCode+","+recordId)
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+AssWinRecId+'&code='+AssWinCode+'&LinkRecordId='+recordId+'"></iframe>'; 
	$('#deptconwin').html(iframe);
	$('#deptconwin').window('open');
	
}
// 关闭持续追踪窗口
function closeDeptConWindow()
{  
	$('#deptconwin').window('close');
	$('#linkwin').window('close');
}


//操作  转归内容
function setLinkList(value, rowData, rowIndex)
{   
	var recordID=rowData.recordID;         //报表 recordID
	var RepID=rowData.RepID;         //报表ID
	var RepType=rowData.RepType;         //报表ID	
	var PatOutFlag=rowData.PatOutFlag;         // 转归标识
	var CaseShareflag=rowData.CaseShareflag; // 案例共享标志
	var RepTypeCode=rowData.RepTypeCode;         //报告类型代码
	var params=RepID+"^"+RepTypeCode;
	var SubUserflag=rowData.SubUserflag;  // 被转抄用户标识
	
	var FunDeptFlag="",RepAssFalg="";
	var PatOutFormCode="PatOutcomform",FunDeptFormCode="FunDeptConform";
	if(RepType.indexOf("院外")>=0){
		PatOutFormCode="UlcPatOutcomform";
	}
	runClassMethod("web.DHCADVCOMMON","GetLinkFlagList",{'LinkRecordId':recordID},
	function(data){
		var tmp=data.split("^"); 
		// 转归标识
		PatOutFlag=tmp[0];
        // 追踪反馈标识
		FunDeptFlag=tmp[1];
        // 评估标识
		RepAssFalg=tmp[2];
	},"text",false);
			
	if (PatOutFlag == "Y"){
		html = "<a href='#' id='zg' class='dhcc-btn-tb'  onclick=\"LoadLinkWin('"+RepID+"','"+recordID+"','"+PatOutFormCode+"',$g('转归'))\" >"+$g("转归")+"</a>";
	}else{
		html ="<span class='dhcc-btn-tb disabled' style='cursor:default;'>"+$g("转归")+"</span>";
	}
	if (FunDeptFlag == "Y"){
		html =html+ "<a href='#' class='dhcc-btn-tb yellow' onclick=\"LoadLinkWin('"+RepID+"','"+recordID+"','"+FunDeptFormCode+"',$g('追踪反馈'))\" >"+$g("反馈")+"</a>";
	}else{
		html =html+ "<span class='dhcc-btn-tb disabled' style='cursor:default;'>"+$g("反馈")+"</span>";
	}
	if (RepAssFalg == "Y"){
		html =html+ "<span class='dhcc-btn-tb' style='cursor:default;'>"+$g("评估")+"</span>";
	}else{
		html =html+ "<span class='dhcc-btn-tb disabled' style='cursor:default;'>"+$g("评估")+"</span>";
	
	}
	if (CaseShareflag == "Y"){
		html = html+ "<a href='#' class='dhcc-btn-tb yellow' onclick=\"ShowWin('"+params+"')\" >"+$g("案例共享")+"</a>";
	}else{
		html =html+ "<span class='dhcc-btn-tb disabled' style='cursor:default;'>"+$g("案例共享")+"</span>";
	}
	if (SubUserflag == "1"){
		//html = html+ "<a href='#' id='zc' class='dhcc-btn-tb' onclick=\"TranList('"+params+"')\" >"+$g("转抄")+"</a>";
		html =html+ "<span class='dhcc-btn-tb' style='cursor:default;'>"+$g("转抄")+"</span>";
	}else{
		html =html+ "<span class='dhcc-btn-tb disabled' style='cursor:default;'>"+$g("转抄")+"</span>";
	}
	
    return html;
    
}

//编辑窗体  2018-05-07 cy 转归界面
function LoadLinkWin(RepID,recordID,FormCode,FormTitle)
{
	if($('#linkwin').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="linkwin"></div>');
	$('#linkwin').window({
		title:FormTitle,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		width:800,    ///2017-11-23  cy  修改弹出窗体大小 1250
		height:400
	});
	var WinRecId="";
	 runClassMethod("web.DHCADVCOMMONPART","GetRecordId",
		{'LinkRecordId':recordID,
		 'FormCode':FormCode},
		function(data){ 
			 WinRecId=data;
	},"text",false) 
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+WinRecId+'&code='+FormCode+'&LinkRecordId='+recordID+'&RepID='+RepID+'"></iframe>'; 
	$('#linkwin').html(iframe);
	$('#linkwin').window('open');
}

// 2021-03-18 cy 案例共享查看
function ShowWin(params){
	CaseShareShow(params);
	$('#WardWbar').hide();
}

/// 2021-03-18 cy 设置转抄明细连接  
function setTranList(value, rowData, rowIndex)
{
		var RepID=escape(rowData.RepID);         //报表ID
		var RepTypeCode=escape(rowData.RepTypeCode); //报告类型代码
		var params=RepID+"^"+RepTypeCode;
		return "<a href='#' onclick=\"TranList('"+params+"')\"><img src='../scripts/dhcadvEvt/images/adv_sel_11.png' border=0/></a>";
}
// 2021-03-18 cy 转抄明细查看
function TranList(params)
{
	$('#TranWin').window({
		title:$g('转抄明细'),
		collapsible:false,
		border:false,
		minimizable:false,
		maximizable:false,
		resizable:false,
		width:1100,
		height:500
	});
	$('#TranWin').window('open');	
	
	//定义columns
	var columns=[[
		{field:'MedItmID',title:$g('转抄ID'),width:150,hidden:true},
		{field:'MedIAuditDateTime',title:$g('转抄时间'),width:150,hidden:false},
		{field:'MedIAuditUser',title:$g('转抄人'),width:100,hidden:false},
		{field:'MedIAuditUserDR',title:$g('转抄人ID'),width:100,hidden:true},
		{field:'MedILocAdvice',title:$g('转抄处理意见'),width:200,formatter:setLocAdvice},
		{field:'MedINextLoc',title:$g('转抄指向科室'),width:150},
		{field:'MedINextLocDR',title:$g('转抄指向科室指向ID'),width:100,hidden:true},
		{field:'MedINextUser',title:$g('转抄指向人员'),width:100},
		{field:'MedINextUserDR',title:$g('转抄指向人员ID'),width:100,hidden:true},
		{field:'MedIUserAdvice',title:$g('人员回复意见'),width:200,formatter:setUserAdvice},
		{field:'MedIReceive',title:$g('接收状态'),width:60},
		{field:'DutyFlag',title:$g('备注'),width:200},
		{field:'MedIReceiveDateTime',title:$g('接收时间'),width:150},
		{field:'MedICompleteDateTime',title:$g('完成时间'),width:150}
	]];
	//定义datagrid
	$('#Trandg').datagrid({   
		title:'',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSEARCHREPORT&MethodName=QueryTranMess'+'&params='+params,
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: $g('正在加载信息...'),
		pagination:true,
        nowrap:false
	});	
	
}
//操作  病历
function setLocAdvice(value, rowData, rowIndex)
{   
    return $_TrsTxtToSymbol(rowData.MedILocAdvice);
   // return "<a href='#' mce_href='#' onclick='LoadPatientRecord("+rowData.PatID+","+Adm+");'>"+PatNo+"</a>";  
    
}
//操作  病历
function setUserAdvice(value, rowData, rowIndex)
{   
    return $_TrsTxtToSymbol(rowData.MedIUserAdvice);
   // return "<a href='#' mce_href='#' onclick='LoadPatientRecord("+rowData.PatID+","+Adm+");'>"+PatNo+"</a>";  
    
}

