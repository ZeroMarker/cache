
/// Creator: congyue
/// CreateDate: 2015-12-16
/// Description:用药差错报告
var url="dhcadv.repaction.csp";
var patSexArr = [{ "val": "1", "text": "男" }, { "val": "2", "text": "女" },{ "val": "3", "text": "不详" }];
var OccBatNo= [{ "val": "白班", "text": "白班" }, { "val": "夜班", "text": "夜班" },{ "val": "交接班", "text": "交接班" }];
var WeekNo= [{ "val": "星期一", "text": "星期一" },{ "val": "星期二", "text": "星期二" },{ "val": "星期三", "text": "星期三" }, 
			{ "val": "星期四", "text": "星期四" },{ "val": "星期五", "text": "星期五" },{ "val": "星期六", "text": "星期六" },{ "val": "星期日", "text": "星期日" }];
var Active = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];
var editDoRow="";editApRow="";editDiRow="";editNuRow="";editPaRow="";
var CurRepCode="drugerr";
var medsrID="";patientID="";EpisodeID="";editFlag="";adrDataList="",assessID="";
var MedsrInitStatDR="";medsrReportType="";medsrCurStatusDR="";medsrAdmNo="";medsrOrdItm="";
var medadrNextLoc="";medadrLocAdvice="";medadrReceive="";
var LocDr="";UserDr="";ImpFlag="", patIDlog="";
var inci="";//药品id
var DocL="DocL";ApoL="ApoL";DispL="DispL";NurL="NurL";PatL="PatL";MedUseCode="";Codedata="";OrdInfo="";
var frmflag=0; //是否获取病人列表标志 0 获取，1 不获取
var winflag=0; //窗口标志 0 填报窗口  1 修改窗口 2016-10-10
document.write('<script type="text/javascript" src="../scripts/dhcadvEvt/cmcommon.js"></script>');

$(function(){
	patientID=getParam("patientID");
	EpisodeID=getParam("EpisodeID");
	medsrID=getParam("medsrID");
	editFlag=getParam("editFlag");
	adrDataList=getParam("adrDataList");
	satatusButton=getParam("satatusButton");
    frmflag=getParam("frmflag"); //2016-09-28
    assessID=getParam("assessID"); //评估id
	if ((adrDataList=="")&&(medsrID=="")&&(frmflag==0)){
	    var frm = dhcsys_getmenuform();
		if (frm) {
			var papmi = frm.PatientID.value;		
	        var adm = frm.EpisodeID.value;
	        //var papmi=getRegNo(papmi);
	        $.ajax({
		   	   type: "POST",
		       url: url,
		       async: false, //同步
		       data: "action=getPatNo&patID="+papmi,
		       success: function(val){
			      	 papmi=val;
		       }
		    });	        
	        EpisodeID=adm;
	        getMedsrRepPatInfo(papmi,adm);//获取病人信息
	        
			if((papmi!="")&(adm!="")){
				$('#PatID').attr("disabled","true");  ///2017-07-20 bianshuai 设置病人ID不可编辑
	        }

		}
	}
    //判断按钮是否隐藏
	var buttondiv=document.getElementById("buttondiv");
	if (satatusButton==1) {
	  buttondiv.style.display='none';
	}
	
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
				
				var ed=$("#DocL").datagrid('getEditor',{index:editDoRow,field:'Active'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// 定义columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true},
		{field:"Code",title:'代码',width:35},
		{field:"Desc",title:'描述',width:150},
		{field:"Active",title:'是否可用',width:100,editor:activeEditor,hidden:true},
		{field:"Correct",title:'应当是',width:300,editor:texteditor},
		{field:"Error",title:'错误是',width:300,editor:texteditor},
		{field:"OtherDesc",title:'其他',width:150,editor:texteditor},
		{field:"flag",title:'是否选择',width:150,hidden:true}
	]];
	
	//定义datagrid
	$('#DocL').datagrid({
		title:'医生环节',
		url:'',
		columns:columns,
		//pageSize:50,  // 每页显示的记录条数
		loadMsg: '正在加载信息...',
		//pagination:true,
		height:300,
		onSelect: function (rowIndex, rowData) {//单击选择行编辑
			MedUseCode=DocL;
			Codedata=rowData.Code;
			if (medsrOrdItm!=""){
	           	GetTxtByOrdItm(MedUseCode,rowIndex,Codedata,OrdInfo);
           	}           
           	
           	if ((editDoRow != "")||(editDoRow == "0")) {
            	$("#DocL").datagrid('endEdit', editDoRow );
			}
            $("#DocL").datagrid('beginEdit', rowIndex); 
			editDoRow = rowIndex;
           
            var ed = $('#DocL').datagrid('getEditors', rowIndex);
	        var e = ed[1];
	        $(e.target).bind('keydown', function(event)
	            {
		            if(event.keyCode == "13")
		            {
			            var eds=$("#DocL").datagrid('getEditor',{index:rowIndex,field:'Correct'});
			            var inputCorrect=$(eds.target).val();
			            if(rowData.Code=="1-2")
			            {
				            var QueryDrug=$(e.target);
				            QueryDrugDesc(inputCorrect,QueryDrug,MedUseCode);
						}
						if(rowData.Code=="1-4")//给药途径
			            {
				            var PhcIn=$(e.target);
				            QueryPhcInDesc(inputCorrect,PhcIn,MedUseCode);
						}
						if(rowData.Code=="1-5")//给药频率
			            {
				            var PhcFreq=$(e.target);
				            QueryPhcFreqDesc(inputCorrect,PhcFreq,MedUseCode);
						}
					}
				});

        },
        onUnselect:function (rowIndex, rowData) {//单击选择行编辑
			$('#DocL').datagrid('updateRow',{	
				index: rowIndex,	
				row: {
					Correct:"",	
					Error:"",  //药物错误    药品名称
					OtherDesc:""
				}
			});	    
		},
        onLoadSuccess:function(data){
			if(data){
				$.each(data.rows, function(index, item){
					if(item.flag=="Y"){    
						$('#DocL').datagrid('checkRow', index);  //根据是否选择字段来判断复选框是否勾选
					}
				});
			}
           if (medsrOrdItm!=""){
				$.post(url+'?action=getRepOrdInfo',{"params":medsrOrdItm}, function(data){
					OrdInfo=data;
				});
           }
		}
	});
	$('#DocL').datagrid({
		url:url+'?action=QueryMULinkItm',	//查询医生环节选项
		queryParams:{
			params:DocL+"^"+medsrID}
	});
	//定义datagrid
	$('#ApoL').datagrid({
		title:'药师环节',
		url:'',
		columns:columns,
		//pageSize:50,  // 每页显示的记录条数
		loadMsg: '正在加载信息...',
		//pagination:true,
		height:200,
		onSelect: function (rowIndex, rowData) {//单击选择行编辑
            MedUseCode=ApoL;
            Codedata=rowData.Code;
            if (medsrOrdItm!=""){
	           	GetTxtByOrdItm(MedUseCode,rowIndex,Codedata,OrdInfo);
           	} 
            
            if ((editApRow != "")||(editApRow == "0")) {
            	$("#ApoL").datagrid('endEdit', editApRow);
			}
            $("#ApoL").datagrid('beginEdit', rowIndex); 
            editApRow = rowIndex; 
            
            var ed = $('#ApoL').datagrid('getEditors', rowIndex);
	        var e = ed[1];//固定 field:'Error' 列存在回车事件
	        $(e.target).bind('keydown', function(event)
	            {
		            if(event.keyCode == "13")
		            {
			            var eds=$("#ApoL").datagrid('getEditor',{index:rowIndex,field:'Correct'});
			            var inputCorrect=$(eds.target).val();
			            if(rowData.Code=="2-1")
			            {
				            var QueryDrug=$(e.target);
				            QueryDrugDesc(inputCorrect,QueryDrug,MedUseCode);
						}
					}
				});
        },
        onUnselect:function (rowIndex, rowData) {//单击选择行编辑
			$('#ApoL').datagrid('updateRow',{	
				index: rowIndex,	
				row: {
					Correct:"",	
					Error:"",  //药物错误    药品名称
					OtherDesc:""
				}
			});	    
		},
        onLoadSuccess:function(data){
			if(data){
				$.each(data.rows, function(index, item){
					if(item.flag=="Y"){
						$('#ApoL').datagrid('checkRow', index);
					}
				});
			}
		}
	});

	$('#ApoL').datagrid({
		url:url+'?action=QueryMULinkItm',	//查询药师环节选项
		queryParams:{
			params:ApoL+"^"+medsrID}
	});
	//定义datagrid
	$('#DispL').datagrid({
		title:'配送环节',
		url:'',
		columns:columns,
		//pageSize:50,  // 每页显示的记录条数
		loadMsg: '正在加载信息...',
		//pagination:true,
		height:200,
		onSelect: function (rowIndex, rowData) {//单击选择行编辑
            MedUseCode=DispL;
            Codedata=rowData.Code;
            if (medsrOrdItm!=""){
	           	GetTxtByOrdItm(MedUseCode,rowIndex,Codedata,OrdInfo);
           	}
           	
            if ((editDiRow != "")||(editDiRow == "0")) {
            	$("#DispL").datagrid('endEdit', editDiRow);
			}
            $("#DispL").datagrid('beginEdit', rowIndex);             
            editDiRow = rowIndex;
            
            var ed = $('#DispL').datagrid('getEditors', rowIndex);
	        var e = ed[1];
	        $(e.target).bind('keydown', function(event)
	            {
		            if(event.keyCode == "13")
		            {
			            var eds=$("#DispL").datagrid('getEditor',{index:rowIndex,field:'Correct'});
			            var inputCorrect=$(eds.target).val();
			            if(rowData.Code=="3-1")
			            {
				            var QueryDrug=$(e.target);
				            QueryDrugDesc(inputCorrect,QueryDrug,MedUseCode);
						}
					}
				});
        },
        onUnselect:function (rowIndex, rowData) {//单击选择行编辑
			$('#DispL').datagrid('updateRow',{	
				index: rowIndex,	
				row: {
					Correct:"",	
					Error:"",  //药物错误    药品名称
					OtherDesc:""
				}
			});	    
		},
        onLoadSuccess:function(data){
			if(data){
				$.each(data.rows, function(index, item){
					if(item.flag=="Y"){
						$('#DispL').datagrid('checkRow', index);
					}
				});
			}

		}
	});

	$('#DispL').datagrid({
		url:url+'?action=QueryMULinkItm',	//查询配送环节选项
		queryParams:{
			params:DispL+"^"+medsrID}
	});
	//定义datagrid
	$('#NurL').datagrid({
		title:'护士环节',
		url:'',
		columns:columns,
		//pageSize:50,  // 每页显示的记录条数
		loadMsg: '正在加载信息...',
		//pagination:true,
		height:300,
		onSelect: function (rowIndex, rowData) {//单击选择行编辑
			MedUseCode=NurL;
            Codedata=rowData.Code;
            if (medsrOrdItm!=""){
	           	GetTxtByOrdItm(MedUseCode,rowIndex,Codedata,OrdInfo);
           	}
           	
			if ((editNuRow != "")||(editNuRow == "0")) {
            	$("#NurL").datagrid('endEdit', editNuRow);
			}
            $("#NurL").datagrid('beginEdit', rowIndex);            
            editNuRow = rowIndex;
            
            var ed = $('#NurL').datagrid('getEditors', rowIndex);
	        var e = ed[1];
	        $(e.target).bind('keydown', function(event)
	            {
		            if(event.keyCode == "13")
		            {
			            var eds=$("#NurL").datagrid('getEditor',{index:rowIndex,field:'Correct'});
			            var inputCorrect=$(eds.target).val();
			            if(rowData.Code=="4-2")//药物
			            {
				            var QueryDrug=$(e.target);
				            QueryDrugDesc(inputCorrect,QueryDrug,MedUseCode);
						}
						if(rowData.Code=="4-4")//给药途径
			            {
				            var PhcIn=$(e.target);
				            QueryPhcInDesc(inputCorrect,PhcIn,MedUseCode);
						}
						if(rowData.Code=="4-5")//给药频率
			            {
				            var PhcFreq=$(e.target);
				            QueryPhcFreqDesc(inputCorrect,PhcFreq,MedUseCode);
						}
					}
				});
        },
        onUnselect:function (rowIndex, rowData) {//单击选择行编辑
			$('#NurL').datagrid('updateRow',{	
				index: rowIndex,	
				row: {
					Correct:"",	
					Error:"",  //药物错误    药品名称
					OtherDesc:""
				}
			});	    
		},
        onLoadSuccess:function(data){
			if(data){
				$.each(data.rows, function(index, item){
					if(item.flag=="Y"){
						$('#NurL').datagrid('checkRow', index);
					}
				});
			}
		}
	});

	$('#NurL').datagrid({
		url:url+'?action=QueryMULinkItm',	//查询护士环节选项
		queryParams:{
			params:NurL+"^"+medsrID}
	});
	//定义datagrid
	$('#PatL').datagrid({
		title:'患者环节',
		url:'',
		columns:columns,
		//pageSize:50,  // 每页显示的记录条数
		loadMsg: '正在加载信息...',
		//pagination:true,
		height:300,
		onSelect: function (rowIndex, rowData) {//单击选择行编辑
			MedUseCode=PatL;
			Codedata=rowData.Code;
            if (medsrOrdItm!=""){
	           	GetTxtByOrdItm(MedUseCode,rowIndex,Codedata,OrdInfo);
           	}
			
			if ((editNuRow != "")||(editNuRow == "0")) {
            	$("#PatL").datagrid('endEdit', editPaRow);
			}
            $("#PatL").datagrid('beginEdit', rowIndex); 
            editPaRow = rowIndex;
			
            var ed = $('#PatL').datagrid('getEditors', rowIndex);
	        var e = ed[1];
	        $(e.target).bind('keydown', function(event)
	            {
		            if(event.keyCode == "13")
		            {
			            var eds=$("#PatL").datagrid('getEditor',{index:rowIndex,field:'Correct'});
			            var inputCorrect=$(eds.target).val();
			           
						if(rowData.Code=="5-2")//给药途径
			            {
				            var PhcIn=$(e.target);
				            QueryPhcInDesc(inputCorrect,PhcIn,MedUseCode);
						}
						if(rowData.Code=="5-3")//给药频率
			            {
				            var PhcFreq=$(e.target);
				            QueryPhcFreqDesc(inputCorrect,PhcFreq,MedUseCode);
						}
					}
				});
        },
        onUnselect:function (rowIndex, rowData) {//单击选择行编辑
			$('#PatL').datagrid('updateRow',{	
				index: rowIndex,	
				row: {
					Correct:"",	
					Error:"",  //药物错误    药品名称
					OtherDesc:""
				}
			});	    
		},
        onLoadSuccess:function(data){
			if(data){
				$.each(data.rows, function(index, item){
					if(item.flag=="Y"){
						$('#PatL').datagrid('checkRow', index);
					}
				});
			}
		}
	});
	$('#PatL').datagrid({
		url:url+'?action=QueryMULinkItm',	//查询患者环节选项
		queryParams:{
			params:PatL+"^"+medsrID}
	});
	
	//判断输入的病人ID是否为数字
	 $('#PatID').bind("blur",function(){
	   var	medsrPatID=$('#PatID').val();
	   if(isNaN(medsrPatID)){
		    $.messager.alert("提示:","请输入数字！");
	    }
	})
	//病人登记号回车事件
	$('#PatID').bind('keydown',function(event){
		if(event.keyCode == "13")    
		{
			var medsrPatID=$('#PatID').val();
			if (medsrPatID=="")
			{
				$.messager.alert("提示:","病人id不能为空！");
				return;
			}
			var medsrPatID=getRegNo(medsrPatID);
			if ((patIDlog!="")&(patIDlog!=medsrPatID)&(medsrID=="")){
				$.messager.confirm("提示", "信息未保存,是否继续操作", function (res) {//提示是否删除
					if (res) {
						//location.reload();
						//window.location.href="dhcadv.medsafetyreport.csp?adrDataList='+''";//刷新传参adrDataList为空
						ReloadJs();//刷新传参adrDataList为空
					}else{
						$('#PatID').val(patIDlog);
					$('#admdsgrid').datagrid({
						url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+patIDlog 
					})				
					}
				})
			}
			if ((patIDlog!="")&(patIDlog!=medsrPatID)&(medsrID!="")){
				ReloadJs();//刷新传参adrDataList为空
			}
			var input='' ;
			var mycols = [[
				{field:'Adm',title:'Adm',width:60}, 
				{field:'AdmLoc',title:'就诊科室',width:220}, 
				{field:'AdmDate',title:'就诊日期',width:80},
				{field:'AdmTime',title:'就诊时间',width:80},
				{field:'RegNo',title:'病人id',width:80}
			]];
			var mydgs = {
				url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+medsrPatID ,
				columns: mycols,  //列信息
				pagesize:10,  //一页显示记录数
				table: '#admdsgrid', //grid ID
				field:'Adm', //记录唯一标识
				params:null,  // 请求字段,空为null
				tbar:null //上工具栏,空为null
			}
			var win=new CreatMyDiv(input,$("#PatID"),"drugsfollower","650px","335px","admdsgrid",mycols,mydgs,"","",SetAdmTxtVal);	
			win.init();
		}
	});
	
	//星期
	$('#medsrOccDateTime').datetimebox({
  		onChange:function(){
	  		var medsrOccDateTime=$('#medsrOccDateTime').datetimebox('getValue');   
			if(medsrOccDateTime!="")
			{
				var medsrOccDate=medsrOccDateTime.split(" ")[0];  //发生日期
				var medsrOccTime=medsrOccDateTime.split(" ")[1];  //发生时间
			}
			getWeek(medsrOccDate);
   		}
	});
	
	//科室 2017-08-01 cy 修改 下拉框传递参数检索
	$('#medsrRepLocDr').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		mode:'remote',  //必须设置这个属性
		onShowPanel:function(){ 
			$('#medsrRepLocDr').combobox('reload',url+'?action=SelLocDesc')
		}
	});
	//性别
	$('#PatSex').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		editable:false,
		//data:patSexArr
		url:url+'?action=SelSex'
	});
	//星期
	$('#medsrWeek').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:WeekNo
	});
	//班次
	$('#medsrOccBatNo').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:OccBatNo
	}); 
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			setCheckBoxRelation(this.id);
		});
	});
	
	//复选框分组
	InitUIStatus();
	
	//当  当事医生勾选正式医生时，显示隐藏框
	$('#DM10').click(function(){
		var dm1=document.getElementById("dm1"); //职称
		if ($(this).is(':checked')) {
			dm1.style.display='inline';
		} else {
			dm1.style.display='none';
		}   
	});
	//当  当事药师勾选正式药师时，显示隐藏框
	$('#AM20').click(function(){
		var am1=document.getElementById("am1");
		if ($(this).is(':checked')) {
			am1.style.display='inline';
		} else {
			am1.style.display='none';
		}   
	});
	//当  当事护士勾选正式护士时，显示隐藏框
	$('#NM30').click(function(){
		var nm1=document.getElementById("nm1");
		if ($(this).is(':checked')) {
			nm1.style.display='inline';
		} else {
			nm1.style.display='none';
		}   
	});
	
	//当后果 勾选差错到达患者，并且：时，显示隐藏框
	$('#RD2').click(function(){
		var rd=document.getElementById("rd");
		if ($(this).is(':checked')) {
			rd.style.display='inline';
		} else {
			rd.style.display='none';
		}   
	});
	
	InitMedsReport(medsrID);
	InitPatientInfo(medsrID,adrDataList);//获取页面默认信息
	getMedsrRepPatInfo(patientID,EpisodeID);//获取病人信息
	//editFlag状态为0,隐藏提交和暂存按钮
	if(editFlag=="0"){
		$("a:contains('提交')").css("display","none");
		$("a:contains('暂存')").css("display","none");
	}
	
})

// 文本编辑格
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

// 日期编辑格
var dateboxditor={
	type: 'datebox',//设置编辑格式
	options: {
		//required: true //设置编辑规则属性
	}
}
///初始化界面复选框事件
function InitUIStatus()
{
	var tmpid="";
	$("input[type=checkbox]").click(function(){
		tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			$("input[type=checkbox][name="+this.name+"]").each(function(){
				if((this.id!=tmpid)&($('#'+this.id).is(':checked'))){
					$('#'+this.id).removeAttr("checked");
					setCheckBoxRelation(this.id);
				}
			})
		}
		setCheckBoxRelation(this.id);
	});
}

/// 保存用药差错报告表
function saveMedsReport(flag)
{
	 ///保存前,对页面必填项进行检查
	if((flag)&&(!saveBeforeCheck())){
		return;
	}
	if(editDoRow>="0"){
		$("#DocL").datagrid('endEdit', editDoRow);
	}
	if(editApRow>="0"){
		$("#ApoL").datagrid('endEdit', editApRow);
	}
	if(editDiRow>="0"){
		$("#DispL").datagrid('endEdit', editDiRow);
	}
	if(editNuRow>="0"){
		$("#NurL").datagrid('endEdit', editNuRow);
	}
	if(editPaRow>="0"){
		$("#PatL").datagrid('endEdit', editPaRow);
	}	
	//1、科室
	var medsrRepLocDr=$('#medsrRepLocDr').combobox('getValue');
	medsrRepLocDr=LocDr;
	//2、报告日期
	var medsrCreateDateTime=$('#medsrCreateDateTime').datetimebox('getValue');   
	var medsrCreateDate="",medsrCreateTime="";
	if(medsrCreateDateTime!=""){
		medsrCreateDate=medsrCreateDateTime.split(" ")[0];  //报告日期
		medsrCreateTime=medsrCreateDateTime.split(" ")[1];  //报告时间
	}
	//3、发生日期
	var medsrOccDateTime=$('#medsrOccDateTime').datetimebox('getValue');   
	var medsrOccDate="",medsrOccTime="";
	if(medsrOccDateTime!=""){
		medsrOccDate=medsrOccDateTime.split(" ")[0];  //发生日期
		medsrOccTime=medsrOccDateTime.split(" ")[1];  //发生时间
	}
	
	//4、星期
	var medsrWeek=$('#medsrWeek').combobox('getValue');

	//5、班次
	var medsrOccBatNo=$('#medsrOccBatNo').combobox('getValue');
	
	//6、病人ID
	var medsrPatID=$('#PatID').val();
	if(medsrPatID==""){
		$.messager.alert("提示:","【病人ID】不能为空！");
		return;
	}
	//7、病案号
	var medsrPatNo=$('#PatNo').val();
	
	//8、病人姓名
	var medsrName=$('#PatName').val();
	if(medsrName==""){
	  $.messager.alert("提示:","请输入患者ID,选择相应就诊");
		return;
	}
    //9、病人性别
	var medsrSex=$('#PatSex').combobox('getValue');
    //10、病人年龄
	var medsrAge=$('#PatAge').val();  
	//11、应给药物
	var medsrDrugName=$('#medsrDrugName').val(); 
	medsrDrugName=inci;
	//12、应给剂量
	var medsrDosage=$('#medsrDosage').val();  
	//13、累计错误给药次数
	var medsrErrNum=$('#medsrErrNum').val();   

	//14、医生环节
	var DocLitmList="";
	var docLitmdatalist=[];
	var Doselflag="";
	var selDLItems = $('#DocL').datagrid('getSelections');
	$.each(selDLItems, function(index, item){
		var tmp=item.Code+"^"+item.Correct+"^"+item.Error+"^"+item.OtherDesc;   //参数串
		docLitmdatalist.push(tmp);
		DocLitmList=docLitmdatalist.join("$c(1)");
		Doselflag=item.ID;
	})
	//15、当事医生信息
	var medsrDoctorMes="";
	var medsrDOtherDesc="";
	var medsrDCProv="";
	var Doflag="";
	$.each(selDLItems, function(index, item){
		if(item.ID!=""){
    		$("input[type=checkbox][name=medsrDoctorMes]").each(function(){
				if($(this).is(':checked')){
					medsrDoctorMes=this.value;				
				}
			})
			medsrDOtherDesc=$('#medsrDOtherDesc').val();
		}
		Doflag=(item.ID!="")&(medsrDoctorMes=="");
	})
	if(Doflag){
		$.messager.alert("提示:","医生不能为空！");
		return;	
	}
	// 为正式医生	
	if(medsrDoctorMes=="10"){
		medsrDCProv=$('#medsrDCProv').val(); 
		if(medsrDCProv==""){
			$.messager.alert("提示:","为正式医生时,请填写职称！");
			return;
		}
	}	

	var DoctorMesList=medsrDoctorMes+"^"+medsrDCProv+"^"+medsrDOtherDesc;
	//16、药师环节
	
	var ApoLitmList="";
	var apoLitmdatalist=[];
	var Apselflag="";
	var selALItems = $('#ApoL').datagrid('getSelections');
	$.each(selALItems, function(index, item){
		var tmp=item.Code+"^"+item.Correct+"^"+item.Error+"^"+item.OtherDesc;   //参数串
		apoLitmdatalist.push(tmp);
		ApoLitmList=apoLitmdatalist.join("$c(1)");
		Apselflag=item.ID;
	})
	
	//17、当事药师信息
	var medsrApothecaryMes="";
	var medsrAOtherDesc="";
	var medsrACProv="";
	var Apflag="";
	$.each(selALItems, function(index, item){
		if(item.ID!=""){
    		$("input[type=checkbox][name=medsrApothecaryMes]").each(function(){
				if($(this).is(':checked')){
					medsrApothecaryMes=this.value;
				}
			})
			medsrAOtherDesc=$('#medsrAOtherDesc').val();
		}
		Apflag=(item.ID!="")&(medsrApothecaryMes=="");
	})
	if(Apflag){
		$.messager.alert("提示:","药师不能为空！");
		return;
	}
	// 为正式药师
	if(medsrApothecaryMes=="20"){
		medsrACProv=$('#medsrACProv').val(); 
		if(medsrACProv==""){
			$.messager.alert("提示:","为正式药师时,请填写职称！");
			return;
		}
	}	
	var ApothecaryMesList=medsrApothecaryMes+"^"+medsrACProv+"^"+medsrAOtherDesc;
	//18、配送环节
	
	var DispLitmList="";
	var dispLitmdatalist=[];
	var Diselflag="";
	var selDiLItems = $('#DispL').datagrid('getSelections');
	$.each(selDiLItems, function(index, item){
		var tmp=item.Code+"^"+item.Correct+"^"+item.Error+"^"+item.OtherDesc;   //参数串
		dispLitmdatalist.push(tmp);
		DispLitmList=dispLitmdatalist.join("$c(1)");
		Diselflag=item.ID;
	})
	
	//19、护士环节
	var NurLitmList="";
	var nurLitmmdatalist=[];
	var Nuselflag="";
	var selNLItems = $('#NurL').datagrid('getSelections');
	$.each(selNLItems, function(index, item){
		var tmp=item.Code+"^"+item.Correct+"^"+item.Error+"^"+item.OtherDesc;   //参数串
		nurLitmmdatalist.push(tmp);
		NurLitmList=nurLitmmdatalist.join("$c(1)");
		Nuselflag=item.ID;
	})
	
	//20、当事护士信息
	var medsrNurseMes="";
	var medsrNOtherDesc="";
	var medsrNCProv="";
	var Nuflag="";
	$.each(selNLItems, function(index,item){
		if(item.ID!=""){
    		$("input[type=checkbox][name=medsrNurseMes]").each(function(){
				if($(this).is(':checked')){
					medsrNurseMes=this.value;
				}
			})
			medsrNOtherDesc=$('#medsrNOtherDesc').val();
		}
		Nuflag=(item.ID!="")&(medsrNurseMes=="");
	})
	if(Nuflag){
		$.messager.alert("提示:","护士不能为空！");
		return;
	}
	// 为正式护士
	if(medsrNurseMes=="30"){
		medsrNCProv=$('#medsrNCProv').val(); 
		if(medsrNCProv==""){
			$.messager.alert("提示:","为正式护士时,请填写职称！");
			return;
		}
	}
	var NurseMesList=medsrNurseMes+"^"+medsrNCProv+"^"+medsrNOtherDesc;
	//21、患者环节
	var PatLitmList="";
	var patlitmdatalist=[];
	var Paselflag="";
	var selPLItems = $('#PatL').datagrid('getSelections');
	$.each(selPLItems, function(index, item){
		var tmp=item.Code+"^"+item.Correct+"^"+item.Error+"^"+item.OtherDesc;   //参数串
		patlitmdatalist.push(tmp);
		PatLitmList=patlitmdatalist.join("$c(1)");
		Paselflag=item.ID;

	})
	
	var Itmflag=((Doselflag=="")&&(Apselflag=="")&&(Diselflag=="")&&(Nuselflag=="")&&(Paselflag==""))
	if(Itmflag){
		$.messager.alert("提示:","环节项目至少勾选一种！");
		return ;
	}
	
	//22、后果
	var medsrReslutDr="";
	var medsrReslutDra="";
    $("input[type=checkbox][name=medsrReslutDr]").each(function(){
		if($(this).is(':checked')){
			medsrReslutDr=this.value;
			if(medsrReslutDr=="2"){
				$("input[type=checkbox][name=medsrReslutDra]").each(function(){
					if($(this).is(':checked')){
						medsrReslutDra=this.value;
					}
				})
			}
		}
	})
	// 事件结果为  差错到达患者，并且
 	var medsrReslutList=medsrReslutDr+","+medsrReslutDra;
  	
  	//23、即时行动/干预
	var medsrNurAction=$('#medsrNurAction').val();  //即时行动/干预
 	//24、报告人工号
	var medsrCreator=$('#medsrCreator').val();  //报告人工号
	medsrCreator=UserDr;
 	//25、报告人职称
	var medsrCreatorCareProv=$('#medsrCreatorCareProv').val();  //报告人职称

	var medsrReportNo=$('#medsrReportNo').val(); //报告编码
	medsrAdmNo=EpisodeID;  //就诊id
    var medsrRepImpFlag="N"; //重点关注  
         if(ImpFlag==""){  
		   medsrRepImpFlag=medsrRepImpFlag;
		 }else{
           medsrRepImpFlag=ImpFlag;
		 }
	if(flag==1){
		medsrCurStatusDR=MedsrInitStatDR;  //初始状态
	}	
	var medsrDataList=medsrRepLocDr+"^"+medsrCreateDate+"^"+medsrCreateTime+"^"+medsrOccDate+"^"+medsrOccTime+"^"+medsrOccBatNo+"^"+medsrPatNo+"^"+medsrPatID;
	medsrDataList=medsrDataList+"^"+medsrName+"^"+medsrSex+"^"+medsrAge+"^"+medsrDrugName+"^"+medsrDosage+"^"+medsrErrNum;
	medsrDataList=medsrDataList+"^"+medsrCreator+"^"+medsrCreatorCareProv+"^"+medsrCurStatusDR+"^"+medsrReportNo+"^"+medsrReportType+"^"+medsrAdmNo+"^"+medsrOrdItm+"^"+medsrRepImpFlag;
	medsrDataList=medsrDataList+"$c(2)"+DoctorMesList+"$c(2)"+DocLitmList+"$c(2)"+ApothecaryMesList+"$c(2)"+ApoLitmList+"$c(2)"+DispLitmList+"$c(2)"+NurLitmList;
	medsrDataList=medsrDataList+"$c(2)"+NurseMesList+"$c(2)"+PatLitmList+"$c(2)"+medsrReslutList+"$c(2)"+medsrNurAction;
	
	//var medsrRepAuditList="";
	//if(flag==1){
	var medsrRepAuditList=medsrCurStatusDR+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+medadrNextLoc+"^"+medadrLocAdvice+"^"+medadrReceive+"^"+medsrReportType;
	//}
	var param="medsrID="+medsrID+"&medsrDataList="+medsrDataList+"&medsrRepAuditList="+medsrRepAuditList+"&flag="+flag ; 
	//alert(param);
	//数据保存/提交
	var  mesageShow=""
	if(flag==0){
		mesageShow="保存"
	}
	if(flag==1){		
		mesageShow="提交"		
	}
	$.messager.confirm("提示", "是否进行"+mesageShow+"数据", function (res) {//提示是否删除
		if (res) {
			$.ajax({
   	   			type: "POST",
      			url: url,
       			data: "action=saveMedsafetyReport&"+param,
       			success: function(val){
	      			var medsrArr=val.replace(/(^\s*)|(\s*$)/g,"").split("^");
	      			if (medsrArr[0]=="0") {
	      	 			$.messager.alert("提示:",mesageShow+"成功!");
			 			medsrID=medsrArr[1];
						if(winflag==0){
						 	if (((adrDataList!="") ||((adrDataList=="")&&(frmflag==1)) )&&(flag==1)){
				  				window.parent.CloseWin();
				  			}
				 	    }else if(winflag==1){
						    window.parent.CloseWinUpdate();
						}			 			
			 			if (adrDataList==""){    //wangxuejian 2016/10/18
			 				InitMedsReport(medsrID);//获取报告信息(获取编码信息) qunianpeng 16/09/29 update
					 		winflag=0;
					 	}	
			 			if(flag==1){
							//$("a:contains('提交')").attr("disabled",true);
							//$("a:contains('暂存')").attr("disabled",true);
							var buttondiv=document.getElementById("buttondiv");
							buttondiv.style.display='none';
						}
						if(editFlag!=0){
							window.parent.Query();
						}
	      			}else{
		  	 			if(val==-1){
							$.messager.alert("提示:","无权限");	
						}else if(val==-2){
							$.messager.alert("提示:","已是最后一个权限");	
						}else if(val==-3){
							$.messager.alert("提示:","无授权工作流");	
						}else if(val==-4){
							$.messager.alert("提示:","无配置子项");	
						}else{
							$.messager.alert("提示:","出错");
						}
		  			}
       			},
       			error: function(){
	       			alert('链接出错');
	       			return;
	   			}
    		});
		}
	});
}

//替换特殊符号 2015-12-25 congyue
function trSpecialSymbol(str)
{
	if(str.indexOf("%")){
		var str=str.replace("%","%25");
	}
	if(str.indexOf("&")){
		var str=str.replace("&","%26");
	}
	if(str.indexOf("+")){
		var str=str.replace("+","%2B");
	}
	return str;
}

//加载报表信息
function InitMedsReport(medsrID)
{
	if(medsrID==""){return;}
   	var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
	var medsrDataList="";
	winflag=1; //2016-10-10
	//获取报表信息
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getMedsRepInfo&medsrID="+medsrID+"&params="+params,
       //dataType: "json",
       success: function(val){
	      	medsrDataList=val;
	      	var tmp=medsrDataList.split("!");
			$('#medsrRepLocDr').combobox('setValue',tmp[1]);    //科室
			$('#medsrCreateDateTime').datetimebox({disabled:true});
			$('#medsrCreateDateTime').datetimebox("setValue",tmp[2]+" "+tmp[3]);   //报告日期
			if(tmp[4]!=""||tmp[5]!=""){
				$('#medsrOccDateTime').datetimebox("setValue",tmp[4]+" "+tmp[5]);   //发生日期
			}	 
			$('#medsrOccBatNo').combobox('setValue',tmp[6]);     //班次
			//病人信息
			$('#PatNo').val(tmp[7]);    //病案号
			$('#PatNo').attr("disabled","true");
			$('#PatID').val(tmp[8]);    //病人登记号（ID）
			$('#PatID').attr("disabled","true");  ///2017-07-20 bianshuai 设置病人ID不可编辑
			$('#PatName').val(tmp[9]);    //患者姓名
			$('#PatSex').combobox('setValue',tmp[10]);     //性别
			$('#PatAge').val(tmp[11]);    //年龄
			$('#medsrDrugName').val(tmp[12]);    //药品名称
			$('#medsrDosage').val(tmp[13]);    //应给剂量
			$('#medsrNurAction').val(tmp[14]);    //即时行动
			$('#medsrCreator').val(tmp[15]);    //操作人
			$('#medsrCreator').attr("disabled","true");
			$('#medsrCreatorCareProv').val(tmp[16]);    //操作人职称
			
			$('#medsrErrNum').val(tmp[17]);    //错误次数
			$('#medsrReportNo').val(tmp[19]);    //报告编号
			$('#medsrReportNo').attr("disabled","true");
				
			var repLinkList=tmp[22] //当事医生、药师、护士信息串
			var List=repLinkList.split("&");
			for (i=0;i<List.length;i++){
				var messList=List[i].split("^");
				if (messList[4]==DocL){
					//当事医生信息
					$('#DM'+messList[1]).attr("checked",true);
					if(messList[1]=="10")
					{	
						var dm1=document.getElementById("dm1");
						dm1.style.display='inline';

					}
					$('#medsrDCProv').val(messList[2]);
					$('#medsrDOtherDesc').val(messList[3]);
					if(messList[1]=="13"){
						$('#medsrDOtherDesc').attr("disabled",false);
					}
				}else if (messList[4]==ApoL){
					//当事药师信息
					$('#AM'+messList[1]).attr("checked",true);
					if(messList[1]=="20")
					{	
						var am1=document.getElementById("am1");
						am1.style.display='inline';
					}
					$('#medsrACProv').val(messList[2]);
					$('#medsrAOtherDesc').val(messList[2]);
					if(messList[1]=="23"){
						$('#medsrAOtherDesc').attr("disabled",false);
					}
				}else if (messList[4]==NurL){
					//当事护士信息
					$('#NM'+messList[1]).attr("checked",true);
					if(messList[1]=="30")
					{	
						var nm1=document.getElementById("nm1");
						nm1.style.display='inline';
					}
					$('#medsrNCProv').val(messList[2]);
					$('#medsrNOtherDesc').val(messList[3]);
					if(messList[1]=="33"){
						$('#medsrNOtherDesc').attr("disabled",false);
					}
				}	
				
			}
				
				
			
			//事件后果
			var MedsRepResult=tmp[23];
			var tmpstr=MedsRepResult.split(",");
			$('#RD'+tmpstr[0]).attr("checked",true);
			if(tmpstr[0]=="2"){
				var rd=document.getElementById("rd");
				rd.style.display='inline';
				$('#RD'+tmpstr[1]).attr("checked",true);
			}
			
	//S medsrDataList=medsrDataList_"!"_medadrNextLoc_"!"_medadrLocAdvice_"!"_medadrReceive_"!"_medsrAdmNo_"!"_medsrOrdItm
	//S medsrDataList=medsrDataList_"!"_medsrRepLocDr_"!"_medsrCreator_"!"_medsrDrugDr_"!"_medsrRepImpFlag

			
			medsrCurStatusDR=tmp[18];
			medsrReportType=tmp[20]
			MedsrInitStatDR=tmp[21];
			
			medadrNextLoc=tmp[24]
			medadrLocAdvice=tmp[25]
			medadrReceive=tmp[26];
			
			medsrAdmNo=tmp[27]
			medsrOrdItm=tmp[28];
			EpisodeID=medsrAdmNo;
			
			UserDr=tmp[30];//报告人ID
			LocDr=tmp[29];//科室ID
			inci=tmp[31]; //药品id
			ImpFlag=tmp[32]; //重要标记
			//editFlag状态为0,提交和暂存按钮不可用
			if (medsrCurStatusDR==""){
				medsrCurStatusDR=medsrCurStatusDR;
				medadrReceive="";
			}else{
				MedsrInitStatDR=tmp[18];
				//medadrReceive="1";
				if(((UserDr==LgUserID)&&(medadrReceive=="2"))||(UserDr!=LgUserID)){
					medadrReceive="1";
				}
			}
			//2017-06-12 报告已评估，不可修改
			if(assessID!=""){
				$("#savebt").hide();
				$("#submitdiv").hide();
			}
			if (tmp[18]!=""){  //如果有提交状态
				$('#submitdiv').hide();//隐藏提交按钮
				//获取评估权限标志 2016-10-19
				var Assessflag=GetAssessAuthority(medsrID,params);
				if (Assessflag=="Y"){
					$('#assessment').show(); //显示评估按钮 
				}
			}
			$('#clearbt').hide();//隐藏清空按钮			
     },
       error: function(){
	       alert('链接出错');
	       return;
	   }
    });    
}

//加载报表默认信息
function InitPatientInfo(medsrID,adrDataList)
{
   if(medsrID!=""){return;}
   if(adrDataList==""){
		adrDataList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
	}
   $.ajax({
   type: "POST",
   url: url,
   data:"action=getMedsrInfo&params="+adrDataList,
   success: function(val){
		if(val==-1){
			$.messager.alert("提示:","请先配置工作流与权限,然后填报！");
			return;
		}else{
			var tmp=val.split("^");
			$('#medsrCreateDateTime').datetimebox({disabled:true});
			$('#medsrCreateDateTime').datetimebox("setValue",tmp[0]);   //报告日期
			MedsrInitStatDR=tmp[1];  //报表的初始化,状态 
			medsrReportType=tmp[2];  // 报告填报类型
			//$('#medsrReportNo').val(tmp[3]);    //报告编码
			$('#medsrReportNo').attr("disabled","true");
			UserDr=tmp[4];
			$('#medsrCreator').val(tmp[5]);    //报告人工号
			//$('#medsrCreator').attr("disabled","true");
			LocDr=tmp[6];
			$('#medsrRepLocDr').combobox('setValue',tmp[6]);    //科室ID
			$('#medsrRepLocDr').combobox('setText',tmp[7]);    //科室描述
			//$('#bldrptRepLocDr').attr("disabled","true");

			$('#medsrCreatorCareProv').val(tmp[8]);    //报告人职称
			//$('#medsrCreatorCareProv').attr("disabled","true");
		}
   }})
}
//获取病人信息
function getMedsrRepPatInfo(patientID,EpisodeID){
	
	//var medsrPatID=$('#PatID').val();
	//var medsrPatID=getRegNo(medsrPatID);
	if(patientID==""||EpisodeID==""){return;}
	//获取报表信息
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getRepPatInfo&PatNo="+patientID+"&EpisodeID="+EpisodeID,
       success: function(val){
	       
	   	var medsrRepPatInfo=val;
	    var tmp=medsrRepPatInfo.split("^");

		$('#PatID').val(tmp[0]); //病人ID  登记号
		$('#PatName').val(tmp[1]); //病人名字 
		$('#PatName').attr("disabled","true");
		$('#PatSex').combobox({disabled:true});
		$('#PatSex').combobox('setValue',tmp[2]);  //性别
		$('#PatAge').val(tmp[4]);  //年龄
		$('#PatAge').attr("disabled","true");
		$('#PatNo').val(tmp[5]);  //病案号
		$('#PatNo').attr("disabled","true");
		patIDlog=$('#PatID').val();
       }
    })
}
//未填项默认为空
function trsUndefinedToEmpty(str)
{
	if(typeof str=="undefined"){
		str="";
	}
	return str;
}
//保存前,进行数据完成性检查
function saveBeforeCheck()
{
	//1、科室
	var medsrRepLocDr=$('#medsrRepLocDr').combobox('getValue');
	if(medsrRepLocDr==""){
		$.messager.alert("提示:","【科室】不能为空！");
		return false;
	}
	//2、报告日期
	var medsrCreateDateTime=$('#medsrCreateDateTime').datetimebox('getValue');   
	if(medsrCreateDateTime==""){
		$.messager.alert("提示:","【报告日期】不能为空！");
		return false;
	}
	var medsrCreateDate=medsrCreateDateTime.split(" ")[0];  //报告日期
	if(!compareSelTimeAndCurTime(medsrCreateDate)){
		$.messager.alert("提示:","【报告时间】不能大于当前时间！");
		return false;	
	}

	//3、发生日期
	var medsrOccDateTime=$('#medsrOccDateTime').datetimebox('getValue');   
	if(medsrOccDateTime==""){
		$.messager.alert("提示:","【发生日期】不能为空！");
		return false;
	}
	var medsrOccDate=medsrOccDateTime.split(" ")[0];  //发生日期
	if(!compareSelTimeAndCurTime(medsrOccDate)){
		$.messager.alert("提示:","【发生时间】不能大于当前时间！");
		return false;	
	}

	//6、病人ID
	var medsrPatID=$('#PatID').val();
	if(medsrPatID==""){
		$.messager.alert("提示:","【病人ID】不能为空！");
		return false;
	}
	//7、病案号
	var medsrPatNo=$('#PatNo').val();
	if(medsrPatNo==""){
		$.messager.alert("提示:","【病案号】不能为空！");
		return false;
	} 
	
	//8、病人姓名
	var medsrName=$('#PatName').val();
	if(medsrName==""){
		$.messager.alert("提示:","【病人姓名】不能为空！");
		return false;
	}
    //9、病人性别
	var medsrSex=$('#PatSex').combobox('getValue');
	if(medsrSex==""){
		$.messager.alert("提示:","【病人性别】不能为空！");
		return false;
	}
    //10、病人年龄
	var medsrAge=$('#PatAge').val();  
	if(medsrAge==""){
		$.messager.alert("提示:","【病人年龄】不能为空！");
		return false;
	}
 	//15、当事医生信息
	var medsrDoctorMes="";
	var medsrDOtherDesc="";
	var medsrDCProv="";
	var Doflag="";
	var selDLItems = $('#DocL').datagrid('getSelections');
	$.each(selDLItems, function(index, item){
		if(item.ID!=""){
    		$("input[type=checkbox][name=medsrDoctorMes]").each(function(){
				if($(this).is(':checked')){
					medsrDoctorMes=this.value;
				}
			})
			medsrDOtherDesc=$('#medsrDOtherDesc').val();
		}
		Doflag=(item.ID!="")&(medsrDoctorMes=="");
		
	})
	if(Doflag){
		$.messager.alert("提示:","医生不能为空！");
		return false;	
	}
	// 为正式医生
	if(medsrDoctorMes=="10"){
		medsrDCProv=$('#medsrDCProv').val(); 
		if(medsrDCProv==""){
			$.messager.alert("提示:","【为正式医生时,请填写职称！】");
			return false;
		}
	}
	//17、当事药师信息
	var medsrApothecaryMes="";
	var medsrAOtherDesc="";
	var medsrACProv="";
	var Apflag="";
	var selALItems = $('#ApoL').datagrid('getSelections');
	$.each(selALItems, function(index, item){
		if(item.ID!=""){
    		$("input[type=checkbox][name=medsrApothecaryMes]").each(function(){
				if($(this).is(':checked')){
					medsrApothecaryMes=this.value;
				}
			})
			medsrAOtherDesc=$('#medsrAOtherDesc').val();
		}
		Apflag=(item.ID!="")&(medsrApothecaryMes=="");
	})
	if(Apflag){
		$.messager.alert("提示:","【药师】不能为空！");
		return false;
	}
	// 为正式药师
	if(medsrApothecaryMes=="20"){
		medsrACProv=$('#medsrACProv').val(); 
		if(medsrACProv==""){
			$.messager.alert("提示:","【为正式药师时,请填写职称！】");
			return false;
		}
	}
	//20、当事护士信息
	var medsrNurseMes="";
	var medsrNOtherDesc="";
	var medsrNCProv="";
	var Nuflag="";
	var selNLItems = $('#NurL').datagrid('getSelections');
	$.each(selNLItems, function(index,item){
		if(item.ID!=""){
    		$("input[type=checkbox][name=medsrNurseMes]").each(function(){
				if($(this).is(':checked')){
					medsrNurseMes=this.value;
				}
			})
			medsrNOtherDesc=$('#medsrNOtherDesc').val();
		}
		Nuflag=(item.ID!="")&(medsrNurseMes=="");
	})
	if(Nuflag){
		$.messager.alert("提示:","【护士】不能为空！");
		return false;
	}
	// 为正式护士
	if(medsrNurseMes=="30"){
		medsrNCProv=$('#medsrNCProv').val(); 
		if(medsrNCProv==""){
			$.messager.alert("提示:","【为正式护士时,请填写职称！】");
			return false;
		}
	}
	//22、后果
	var medsrReslutDr="";
	var medsrReslutDra="";
    $("input[type=checkbox][name=medsrReslutDr]").each(function(){
		if($(this).is(':checked')){
			medsrReslutDr=this.value;
		}
	})
	if(medsrReslutDr==""){
		$.messager.alert("提示:","【事件后果】不能为空！");
		return false;
	}
	
	// 事件结果为  差错到达患者，并且
	if(medsrReslutDr=="2"){
		$("input[type=checkbox][name=medsrReslutDra]").each(function(){
			if($(this).is(':checked')){
				medsrReslutDra=this.value;
			}
		})
		if(medsrReslutDra==""){
			$.messager.alert("提示:","【对患者达到的伤害选项】不能为空！");
			return false;
		}
	}
	
 	//23、即时行动/干预
	var medsrNurAction=$('#medsrNurAction').val();  //即时行动/干预
	if(medsrNurAction==""){
		$.messager.alert("提示:","【即时行动/干预】不能为空！");
		return false;
	}
 	//24、报告人工号
	var medsrCreator=$('#medsrCreator').val();  //报告人工号
	if(medsrCreator==""){
		$.messager.alert("提示:","【报告人工号】不能为空！");
		return false;
	}
 	//25、报告人职称
	var medsrCreatorCareProv=$('#medsrCreatorCareProv').val();  //报告人职称
	/* if(medsrCreatorCareProv==""){
		$.messager.alert("提示:","【报告人职称】不能为空！");
		return false;
	} */	
	
	return true;
}
//页面关联设置
function setCheckBoxRelation(id){
	if($('#'+id).is(':checked')){
		///医生
		if(id=="DM13"){
			$('#medsrDOtherDesc').attr("disabled",false);
		}
		if(id=="DM10"){
			$('#dm1').show();
			$('#medsrDCProv').attr("disabled",false);
			$('#medsrDWage').attr("disabled",false);
		}		
		///药师
		if(id=="AM23"){
			$('#medsrAOtherDesc').attr("disabled",false);
		}
		if(id=="AM20"){
			$('#am1').show();
			$('#medsrACProv').attr("disabled",false);
			$('#medsrAWage').attr("disabled",false);
		}
	    ///护士
		if(id=="NM33"){
			$('#medsrNOtherDesc').attr("disabled",false);
		}
		if(id=="NM30"){
			$('#nm1').show();
			$('#medsrNCProv').attr("disabled",false);
			$('#medsrNWage').attr("disabled",false);
		}
		///后果
		if(id=="RD2"){
			$("input[type=checkbox][name=medsrReslutDra]").each(function(){
				if($(this).is(':checked')){
					var medsrReslutDra=this.value;
				}
			})
			$("[name=medsrReslutDra]:checkbox").prop("checked",false);
		}  
		if(id=="RD1"){
			$("#rd").hide(); //差错未到达患者隐藏后果信息
			$("[name=medsrReslutDra]:checkbox").prop("checked",false);
		}    
	}else{
		///医生
		if(id=="DM13"){
			$('#medsrDOtherDesc').val("");
			$('#medsrDOtherDesc').attr("disabled","true");
		}
		if(id=="DM10"){
			$('#medsrDCProv').val("");
			$('#dm1').hide();
			$('#medsrDCProv').attr("disabled",true);
			$('#medsrDWage').val("");
			$('#medsrDWage').attr("disabled",true);
		}
		///药师
		if(id=="AM23"){
			$('#medsrAOtherDesc').val("");
			$('#medsrAOtherDesc').attr("disabled","true")

		}
		if(id=="AM20"){
			$('#medsrACProv').val("");
			$('#am1').hide();
			$('#medsrACProv').attr("disabled",true);
			$('#medsrAWage').val("");
			$('#medsrAWage').attr("disabled",true);
		}	
	    ///护士
		if(id=="NM33"){
			$('#medsrNOtherDesc').val("");
			$('#medsrNOtherDesc').attr("disabled","true");
		}
		if(id=="NM30"){
			$('#medsrNCProv').val("");
			$('#nm1').hide();
			$('#medsrNCProv').attr("disabled",true);
			$('#medsrNWage').val("");
			$('#medsrNWage').attr("disabled",true);
		}  
		///结果
		if(id=="RD2"){
			$("input[type=checkbox][name=medsrReslutDra]").each(function(){
				if($(this).is(':checked')){
					var medsrReslutDra=this.value;
					medsrReslutDra="";
					$("[name=medsrReslutDra]:checkbox").val("");
					$("[name=medsrReslutDra]:checkbox").prop("checked","");
					$("[name=medsrReslutDra]:checkbox").prop("checked",true);

				}
			})
		}   
	}
}

function getWeek(data)
{
	var SelDateArr="",SelYear="",SelMonth="",SelDate="";
	if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY
		SelDateArr=data.split("/");
		SelYear=SelDateArr[2];
		SelMonth=parseInt(SelDateArr[1])-1;
		SelDate=parseInt(SelDateArr[0]);
	}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
		SelDateArr=data.split("-");
		SelYear=SelDateArr[0];
		SelMonth=parseInt(SelDateArr[1])-1;
		SelDate=parseInt(SelDateArr[2]);
	}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
		SelDateArr=data.split("/");
		SelYear=SelDateArr[2];
		SelMonth=parseInt(SelDateArr[0])-1;
		SelDate=parseInt(SelDateArr[1]);
	}
	var dt = new Date(SelYear,SelMonth,SelDate), dt2 = new Date();
	var weekDay = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
	a=weekDay[dt.getDay()];
	$('#medsrWeek').combobox('setValue',a);
}

//在.js中新增function
function SetAdmTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	medsrAdmNo=rowData.Adm;
	if(EpisodeID==undefined)
	{
		EpisodeID=""
	}
	var medsrPatID=$('#PatID').val();
	var medsrPatID=getRegNo(medsrPatID);
	$('#admordgrid').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetAdmOrdList&EpisodeID='+EpisodeID 
	})
	getMedsrRepPatInfo(medsrPatID,EpisodeID);
}
//选择病人的药物医嘱
function GetAdmOrdList(EpisodeID)
{
			 
	if (EpisodeID=="")
	{
		$.messager.alert("提示:","请先选择病人就诊记录！");
		return;
	}
	var input='';
	var mycols=[[
		{field:"ck",checkbox:true,width:20,hidden:true},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'priorty',title:'优先级',width:80},
		{field:'startdate',title:'开始日期',width:80},
		{field:'enddate',title:'结束日期',width:80},
		{field:'incidesc',title:'名称',width:280},
		{field:'inci',title:'incidr',width:80,hidden:true},
		{field:'spec',title:'规格',width:100},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'qty',title:'数目',width:80},
		{field:'dosage',title:'剂量',width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'用法',width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:'频次',width:40},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:'疗程',width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:'批准文号',width:80,hidden:true},
		{field:'genenic',title:'通用名',width:160},
		{field:'manf',title:'厂家',width:80},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:'剂型',width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true}
	]];

	var mydgs = {
		url:'dhcadv.repaction.csp'+'?action=GetAdmOrdList&EpisodeID='+EpisodeID ,
		columns: mycols,  //列信息
		pagesize:10,  //一页显示记录数
		table: '#admordgrid', //grid ID
		field:'orditm', //记录唯一标识
		params:null,  // 请求字段,空为null
		tbar:null //上工具栏,空为null
	}
	var win=new CreatMyDiv(input,$("#medsrDrugName"),"bldsfollower","850px","335px","admordgrid",mycols,mydgs,"","",SetAdmOrdTxtVal);	
	win.init();
}

function SetAdmOrdTxtVal(rowData)
{
	if(rowData!=""){
		medsrOrdItm=rowData.orditm;
		var DrugName="";
		var dosage="";
		if(medsrOrdItm==undefined)
		{
			medsrOrdItm=""
		}
		if(medsrOrdItm!=""){
			DrugName=rowData.incidesc;
			dosage=rowData.dosage;
			inci=rowData.inci;
			$('#medsrDrugName').val(DrugName);
			$('#medsrDosage').val(dosage);
			$("#DocL").datagrid('reload');
			$("#ApoL").datagrid('reload');
			$("#DispL").datagrid('reload');
			$("#NurL").datagrid('reload');
			$("#PatL").datagrid('reload');
			//获取医嘱信息
			$.post(url+'?action=getRepOrdInfo',{"params":medsrOrdItm}, function(data){
				OrdInfo=data;
			});	
		}
	}

}
function SetDrugTxtVal(rowData)
{
	MedUseCode=rowData.MedUseCode;
	if (MedUseCode==DocL){
		///医生环节
		var Docrows = $("#DocL").datagrid("getRows"); 
		for(var i=0;i<Docrows.length;i++){
			var code=Docrows[i].Code;
			if (code=="1-2")
			{

				$('#DocL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.DrugDesc  //药物错误    药品名称
					}
				});
			}
		 	if (code=="1-4")
			{

				$('#DocL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.PhcInDesc  //给药途径错误  用法
					}
				});
			}
			if (code=="1-5")
			{

				$('#DocL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.PhcFreqDesc  //给药频率错误    频次
					}
				});
			}
		
		}
	}
	
	if (MedUseCode==ApoL){
		///药师环节
		var Aporows = $("#ApoL").datagrid("getRows"); 
		for(var i=0;i<Aporows.length;i++){
			var code=Aporows[i].Code;
			if (code=="2-1")
			{

				$('#ApoL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.DrugDesc  //品种错误   药品名称
					}
				});
			}
		}
	}
	if (MedUseCode==DispL){
		///配送环节
		var Disprows = $("#DispL").datagrid("getRows"); 
		for(var i=0;i<Disprows.length;i++){
			var code=Disprows[i].Code;
			if (code=="3-1")
			{

				$('#DispL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.DrugDesc  //配送错误  药品名称
					}
				});
			}
		
		}
	}
	if (MedUseCode==NurL){
		///护士环节
		var Nurrows = $("#NurL").datagrid("getRows"); 
		for(var i=0;i<Nurrows.length;i++){
			var code=Nurrows[i].Code;
			if (code=="4-2")
			{

				$('#NurL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.DrugDesc  //药物错误    药品名称
					}
				});
			}
			if (code=="4-4")
			{

				$('#NurL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.PhcInDesc  //给药途径错误  用法
					}
				});
			}
			if (code=="4-5")
			{

				$('#NurL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.PhcFreqDesc  //给药频率错误    频次
					}
				});
			}
		}
	}
	if (MedUseCode==PatL){
		///患者环节
		var Patrows = $("#PatL").datagrid("getRows"); 
		for(var i=0;i<Patrows.length;i++){
			var code=Patrows[i].Code;
			if (code=="5-2")
			{

				$('#PatL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.PhcInDesc  //给药途径错误  用法
					}
				});
			}
			if (code=="5-3")
			{

				$('#PatL').datagrid('updateRow',{	
					index: i,	
					row: {	
					Correct: rowData.PhcFreqDesc  //给药频率错误    频次
					}
				});
			}
		}
	}	
}

//药品名称
function QueryDrugDesc(inputCorrect,QueryDrug,MedUseCode)
{
	var input='';
	// 定义columns	
	var mycols=[[
		{field:'MedUseCode',title:'环节代码',width:100,hidden:true},
		{field:'DrugID',title:'ID',width:100},
		{field:'DrugCode',title:'药品代码',width:120},
		{field:'DrugDesc',title:'药品描述',width:300}
		]];
	var mydgs = {
		url:'dhcadv.repaction.csp'+'?action=QueryDrugDesc&Input='+inputCorrect+'&MedUseCode='+MedUseCode ,
		columns: mycols,  //列信息
		pagesize:10,  //一页显示记录数
		table: '#druggrid', //grid ID
		field:'DrugID', //记录唯一标识
		params:null,  // 请求字段,空为null
		tbar:null //上工具栏,空为null
		}
	var win=new CreatMyDiv(input,QueryDrug,"drugfollower","600","335","druggrid",mycols,mydgs,"","",SetDrugTxtVal);	
	win.init();	
}
//用药途径  
function QueryPhcInDesc(inputCorrect,PhcIn,MedUseCode)
{  
      inputCorrect=encodeURI(inputCorrect)  //处理参数为中文乱码
	var input='';
	// 定义columns	
	var mycols=[[
		{field:'MedUseCode',title:'环节代码',width:100,hidden:true},
		{field:'PhcInID',title:'ID',width:100},
		{field:'PhcInCode',title:'用药途径代码',width:120},
		{field:'PhcInDesc',title:'用药途径描述',width:300}
		]];
	var mydgs = {
		url:'dhcadv.repaction.csp'+'?action=QueryPhcInDesc&Input='+inputCorrect+'&MedUseCode='+MedUseCode ,
		columns: mycols,  //列信息
		pagesize:10,  //一页显示记录数
		table: '#phcIngrid', //grid ID
		field:'PhcInID', //记录唯一标识
		params:null,  // 请求字段,空为null
		tbar:null //上工具栏,空为null
		}
	var win=new CreatMyDiv(input,PhcIn,"phcInfollower","600","335","phcIngrid",mycols,mydgs,"","",SetDrugTxtVal);		
	win.init();	
}
//用药频率
function QueryPhcFreqDesc(inputCorrect,PhcFreq,MedUseCode)
{
        inputCorrect=encodeURI(inputCorrect)  //处理参数为中文乱码
	var input='';
	// 定义columns	
	var mycols=[[
		{field:'MedUseCode',title:'环节代码',width:100,hidden:true},
		{field:'PhcFreqID',title:'ID',width:100},
		{field:'PhcFreqCode',title:'用药途径代码',width:120},
		{field:'PhcFreqDesc',title:'用药途径描述',width:150},
		{field:'PhcFreqDescs',title:'用药途径描述',width:200}
		]];
	var mydgs = {
		url:'dhcadv.repaction.csp'+'?action=QueryPhcFreqDesc&Input='+inputCorrect+'&MedUseCode='+MedUseCode ,
		columns: mycols,  //列信息
		pagesize:10,  //一页显示记录数
		table: '#phcFreqgrid', //grid ID
		field:'PhcFreqID', //记录唯一标识
		params:null,  // 请求字段,空为null
		tbar:null //上工具栏,空为null
		
		}
	var win=new CreatMyDiv(input,PhcFreq,"phcFreqfollower","650","335","phcFreqgrid",mycols,mydgs,"","",SetDrugTxtVal);	

	win.init();	
}

function GetTxtByOrdItm(MedUseCode,rowIndex,Codedata,OrdInfo)

{	
		var tmp=OrdInfo.split("^");
		var a=rowIndex;
		//医生环节
		if(MedUseCode==DocL){
			if (Codedata=="1-1")
			{
				$('#DocL').datagrid('updateRow',{	
					index: a,	
					row: {	
						Error: $('#PatName').val()  //患者错误    患者姓名
					}
				});
			}
			            
			if (Codedata=="1-2")
			{
				$('#DocL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[2]  //药物错误    药品名称
					}
				});
			}
			if (Codedata=="1-3")
			{

				$('#DocL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[3]  //剂量错误      剂量
					}
				});
			}
			if (Codedata=="1-4")
			{

				$('#DocL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[8]  //给药途径错误  用法
					}
				});
			}
			if (Codedata=="1-5")
			{

				$('#DocL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[6]  //给药频率错误    频次
					}
				});
			}
			if (Codedata=="1-6")
			{

				$('#DocL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[19]  //给药时间错误  开始日期
					}
				});
			}
		}
		//药师环节
		if(MedUseCode==ApoL){
			if (Codedata=="2-1")
			{

				$('#ApoL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[2]  //品种错误   药品名称
					}
				});
			}
			if (Codedata=="2-2")
			{

				$('#ApoL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[18]   //规格错误  规格
					}
				});
			}
			if (Codedata=="2-3")
			{

				$('#ApoL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[23]  //数目错误
					}
				});
			}
		}
		//配送环节
		if(MedUseCode==DispL){
			if (Codedata=="3-1")
			{

				$('#DispL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[2]  //配送错误  药品名称
					}
				});
			}
		}
		//护士环节
		if(MedUseCode==NurL){
			if (Codedata=="4-1")
			{
				$('#NurL').datagrid('updateRow',{	
					index: a,	
					row: {	
						Error: $('#PatName').val()  //患者错误    患者姓名
					}
				});
			}
			if (Codedata=="4-2")
			{

				$('#NurL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[2]  //药物错误    药品名称
					}
				});
			}
			if (Codedata=="4-3")
			{

				$('#NurL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[3]  //剂量错误      剂量
					}
				});
			}
			if (Codedata=="4-4")
			{

				$('#NurL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[8]  //给药途径错误  用法
					}
				});
			}
			if (Codedata=="4-5")
			{

				$('#NurL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[6]  //给药频率错误    频次
					}
				});
			}
			if (Codedata=="4-6")
			{

				$('#NurL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[19]  //给药时间错误  开始日期
					}
				});
			}
		}
		//患者环节
		if(MedUseCode==PatL){
			if (Codedata=="5-1")
			{

				$('#PatL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[3]  //剂量错误      剂量
					}
				});
			}
			if (Codedata=="5-2")
			{

				$('#PatL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[8]  //给药途径错误  用法
					}
				});
			}
			if (Codedata=="5-3")
			{

				$('#PatL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[6]  //给药频率错误    频次
					}
				});
			}
			if (Codedata=="5-4")
			{

				$('#PatL').datagrid('updateRow',{	
					index: a,	
					row: {	
					Error: tmp[19]  //给药时间错误  开始日期
					}
				});
			}
		}
}
//编辑窗体  zhaowuqiang  2016-09-22
function assessmentRep()
{
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'报告评估',
		collapsible:true,
		border:false,
		closed:"true",
		width:900,
		height:500
	});
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.repmanage.csp?RepID='+medsrID+'&RepType='+medsrReportType+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
}
function closeRepWindow(assessID)   //wangxuejian 2016-10-09      关闭评估窗口
{   
	//2017-06-12 报告已评估，不可修改
	if(assessID!=""){
		$("#savebt").hide();
		$("#submitdiv").hide();
	}
	$('#win').window('close');
}
//判断报告编码是否存在
function RepNoRepet(){
	var IDflag=0;
	if (medsrID==""){
		IDflag=0; 
	}else{
		IDflag=1; 
	}
	$('#repnoflag',window.parent.document).val(IDflag); //给父界面元素赋值
	/* //报告编码
	var medsrRepNo=$('#medsrReportNo').val(); 
	medsrRepNo=medsrRepNo.replace(/[ ]/g,""); //去掉编码中的空格
	$.ajax({
		type: "POST",// 请求方式
    	url: url,
    	data: "action=SeaMedsrRepNo&medsrRepNo="+medsrRepNo,
		async: false, //同步
		success: function(data){
			$('#repnoflag',window.parent.document).val(data); //给父界面元素赋值
		}
	}); */
}
//刷新界面 2016-09-26
function ReloadJs(){
	if ((adrDataList!="")||(frmflag==1)){
		frmflag=1;
	}else{
		frmflag=2;
	}
	window.location.href="dhcadv.medsafetyreport.csp?adrDataList="+""+"&frmflag="+frmflag;//刷新传参adrDataList为空
}			
