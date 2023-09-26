
var url="dhcadv.repaction.csp";
var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:华文楷体;color:red;">[双击行即可编辑]</span>';
var titleOpNotes='<span style="font-weight:bold;font-size:12pt;font-family:华文楷体;color:red;">[双击行添加/删除]</span>';
var patSexArr = [{ "val": "1", "text": "男" }, { "val": "2", "text": "女" },{ "val": "3", "text": "不详" }];
var adrEvtArr = [{"value":"S","text":'严重'}, {"value":"G","text":'一般'}];
var currEditRow="";currEditID="";advdrID="";editFlag="";patientID="";EpisodeID="";adrDataList="";
var AdvdrNextLoc="";AdvdrLocAdvice="";AdvdrReceive="";
var AdvdrInitStatDR="";AdvdrReportType="";advdrCurStatusDR=""; 
var LocDr="";UserDr="";ImpFlag="", patIDlog=""; 

var CurRepCode="drug";
document.write('<script type="text/javascript" src="../scripts/dhcadvEvt/cmcommon.js"></script>');
///星号标示
var AstSymbol='<span style="color:red;">*</span>';
 
$(function(){
	patientID=getParam("PatientID");
	EpisodeID=getParam("EpisodeID");
	advdrID=getParam("advdrID");
	editFlag=getParam("editFlag");
	adrDataList=getParam("adrDataList");
	satatusButton=getParam("satatusButton");
	if ((adrDataList=="")&&(advdrID=="")){
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
	        InitPatientInfo(papmi,adm);//获取病人信息
		}
	}
    //复选框分组
	InitUIStatus();
	
    //判断按钮是否隐藏
	var buttondiv=document.getElementById("buttondiv");
	if (satatusButton==1) {
	  buttondiv.style.display='none';
	}
	
 //定义columns
	var columns=[[
		{field:"dgID",title:'dgID',width:90,hidden:true},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
	    {field:'apprdocu',title:'批准文号',width:80,align:'left'},
	    {field:'incidesc',title:'商品名称',width:180,align:'left'},
		{field:'genenic',title:AstSymbol+'通用名称<br>(含剂型)',width:100,align:'center'},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'formdr',title:'formdr',width:80,hidden:true},
		{field:'manf',title:AstSymbol+'生产厂家',width:100,align:'left'},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'batno',title:AstSymbol+'生产批号',width:80,align:'center',editor:texteditor},
		{field:'usemethod',title:AstSymbol+'用法用量<br>(次剂量、途径、日次数)',width:140,align:'center'},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'dosqty',title:'dosqty',width:80,hidden:true},
		{field:'dosage',title:'dosage',width:80,hidden:true},
		{field:'starttime',title:AstSymbol+'开始时间',width:80,align:'left',editor:dateboxditor},
		{field:'endtime',title:AstSymbol+'结束时间',width:80,align:'left',editor:dateboxditor},
		{field:'reasondr',title:'reasondr',width:100,align:'left',editor:'text',hidden:true},
		{field:'usereason',title:AstSymbol+'用药原因',width:100,align:'left',editor:texteditor}, //medreason
		{field:'operation',title:'<a href="#" onclick="patOeInfoWindow()"><img style="margin-left:3px;" src="../scripts/dhcadvEvt/jQuery/themes/icons/edit_add.png" border=0/></a>',width:30,align:'center',
			formatter:SetCellUrl}
	]];
	
	//定义datagrid
	$('#susdrgdg').datagrid({
		title:'怀疑药品'+titleNotes,    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    remoteSort:false,
		loadMsg: '正在加载信息...',
	    onDblClickRow: rowhandleClick
	});

	//定义datagrid
	$('#blenddg').datagrid({
		title:'并用药品'+titleNotes,    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    remoteSort:false,
		loadMsg: '正在加载信息...',
	    onDblClickRow: rowhandleClick
	});
	
	
	//性别
	$('#PatSex').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:patSexArr
	});
		//民族
	$('#PatNation').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		url:url+'?action=selNation'
	});
	
	InitdatagridRow('susdrgdg'); //初始化显示横向滚动条
	InitdatagridRow('blenddg');  //初始化显示横向滚动条
    //严重  开始	 
   	$('#disfind').click(function(){
		createDisWindow();
	})
	$('#adrEvtFind').click(function(){
		createAdrEvtWindow();
	})
	
	$('#advdrEventHistDesc').click(function(){
		createAdrEvtEHWindow();
	})
	
	$('#advdrEventFamiDesc').click(function(){
		createAdrEvtEFWindow();
	})
	
	//报告类型为严重时,弹出框
	$('#RT11').click(function(){
		if($('#'+this.id).is(':checked')){
			createAdrEvtRetWindow();
			$('#serdesc').val("");
		}else{
			$('#modser').css("display","none");
			$('#serdesc').css("display","none");
			$('#serdesc').val("");
		}
	})
	$('#modser').bind('click',createAdrEvtRetWindow); //修改严重情形描述
	
	 //严重  结束	
	
	//病人登记号回车事件
	$('#advdrPatID').bind('keydown',function(event){
		 if(event.keyCode == "13")    
		 {
			 var advdrPatID=$('#advdrPatID').val();
			
			 if (advdrPatID=="")
			 {
				 	$.messager.alert("提示:","病人id不能为空！");
					return;
			 }
			 var advdrPatID=getRegNo(advdrPatID);
			if ((patIDlog!="")&(patIDlog!=advdrPatID)&(advdrID=="")){
				$.messager.confirm("提示", "信息未保存,是否继续操作", function (res) {//提示是否删除
					if (res) {
						location.reload();
					}else{
						$('#advdrPatID').val(patIDlog);
					$('#admdsgrid').datagrid({
						url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+patIDlog 
					})				
					}
				})
			}
			if ((patIDlog!="")&(patIDlog!=advdrPatID)&(advdrID!="")){
				location.reload();
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
				 url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+advdrPatID ,
				 columns: mycols,  //列信息
				 pagesize:10,  //一页显示记录数
				 table: '#admdsgrid', //grid ID
				 field:'Adm', //记录唯一标识
				 params:null,  // 请求字段,空为null
				 tbar:null //上工具栏,空为null
				}
				
			 var win=new CreatMyDiv(input,$("#advdrPatID"),"drugsfollower","650px","335px","admdsgrid",mycols,mydgs,"","",SetAdmTxtVal);	
			 win.init();
		}
	});
	
	//当事件结果为死亡时，显示隐藏的时间框
	$('#TR10').click(function(){
		var matadrEventResultDate=document.getElementById("deathdate");
		
		if ($(this).is(':checked')) {
			matadrEventResultDate.style.display='inline';
		} else {
			matadrEventResultDate.style.display='none';
		}   
	});
	
	InitAdvReport(advdrID);//获取报告信息
	InitRepInfo(advdrID,adrDataList);//获取页面默认信息
	InitPatientInfo(patientID,EpisodeID);//获取病人信息
	
	
	
	
   $('input').live('click',function(){
		$("#"+currEditID).datagrid('endEdit', currEditRow);
	});

	/* $('#DateOccu').datetimebox({
		onSelect:function(date){
			if(!compareSelTimeAndCurTime($('#DateOccu').datetimebox('getValue'))){
				$.messager.alert("提示:","【不良反应/事件发生时间】不能大于当前时间！");
				$('#DateOccu').datetimebox('setValue',"");
			}
		}
	}) */
	
	//editFlag状态为0,隐藏提交和暂存按钮
	if(editFlag=="0"){
		$("a:contains('提交')").css("display","none");
		$("a:contains('暂存')").css("display","none");
		
	}
    
    	//不良反应时间控制
	$('#DateOccu').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
    
    	//死亡时间控制
	$('#advdrEventRDRDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
})


var rowhandleClick=function (rowIndex, rowData) {//双击选择行编辑 
	if ((currEditRow != "")||(currEditRow == "0")) {
		$("#"+currEditID).datagrid('endEdit', currEditRow);
	} 
	$("#"+this.id).datagrid('beginEdit', rowIndex); 
	currEditID=this.id;
	var Sttime = $("#"+currEditID).datagrid('getEditor', {index:rowIndex, field:'starttime'});
	var Edtime = $("#"+currEditID).datagrid('getEditor', {index:rowIndex, field:'endtime'});
    
	if((rowData.starttime!="")&(rowData.starttime!=undefined)) {
		$(Sttime.target).datebox({disabled:true});
		$(Sttime.target).datebox("setValue",rowData.starttime);   //开始日期
	}
	if((rowData.endtime!="")&(rowData.endtime!=undefined)) {
		$(Edtime.target).datebox({disabled:true});
		$(Edtime.target).datebox("setValue",rowData.endtime);   //结束日期
	}
	currEditRow=rowIndex;
}
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
		editable:false
		//required: true //设置编辑规则属性
	}
}


// combox编辑格
var medreason={  //设置其为可编辑
	type: 'combobox', //设置编辑格式
	options: {
		//required: true, //设置编辑规则属性
		panelHeight:"auto",
		valueField: "value", 
		textField: "text",
		url: url+'?action=SelAdrReaForMed',
		onSelect:function(option){
			var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'reasondr'});
			$(ed.target).val(option.value);  //设置科室ID
			var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'usereason'});
			$(ed.target).combobox('setValue', option.text);  //设置科室Desc
		}
	}
}

// 插入新行
function insertRow()
{
	$('#susdrgdg').datagrid('appendRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		row: {
			orditm:'', phcdf:'', incidesc:'', genenic:'', 
	    	genenicdr:'', usemethod:'', dosuomID:'',
	    	instrudr:'', freqdr:'', durId:'', apprdocu:'', 
	    	manf:'', manfdr:'', formdr:''}
	});
}

// 删除行
function delRow(datagID,rowIndex)
{
	//行对象
    var rowobj={
		orditm:'', phcdf:'', incidesc:'', genenic:'', 
	    genenicdr:'', usemethod:'', dosuomID:'',
	    instrudr:'', freqdr:'', durId:'', apprdocu:'', 
	    manf:'', manfdr:'', formdr:'',starttime:'',endtime:'',
	    usereason:'',batno:''
	};
	
	//当前行数大于4,则删除，否则清空
	//var selItem=$('#'+datagID).datagrid('getSelected');
	//var rowIndex = $('#'+datagID).datagrid('getRowIndex',selItem);
	if(rowIndex=="-1"){
		$.messager.alert("提示:","请先选择行！");
		return;
	}
	var rows = $('#'+datagID).datagrid('getRows');
	if(rows.length>4){
		 $('#'+datagID).datagrid('deleteRow',rowIndex);
	}else{
		$('#'+datagID).datagrid('updateRow',{
			index: rowIndex, // 行索引
			row: rowobj
		});
	}
	
	// 删除后,重新排序
	$('#'+datagID).datagrid('sort', {	        
		sortName: 'incidesc',
		sortOrder: 'desc'
	});
}

/// 链接
function SetCellUrl(value, rowData, rowIndex)
{	
	var dgID='"'+rowData.dgID+'"';
	return "<a href='#' onclick='delRow("+dgID+","+rowIndex+")'><img src='../scripts/dhcadvEvt/jQuery/themes/icons/edit_remove.png' border=0/></a>";
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




/// 保存不良反应事件填写报告
function saveAdrEventReport(flag)
{    
	///保存前,对页面必填项进行检查
	 if((flag)&&(!saveBeforeCheck())){
		return;
	} 
	
		if(currEditRow>="0"){
		
		$("#"+currEditID).datagrid('endEdit', currEditRow);
	}
	
	
	
	
	
	//1、报告优先级
	var advdrPriority="";
    $("input[type=checkbox][name=advdrPriority]").each(function(){
	    if($('#'+this.id).is(':checked')){
			advdrPriority=this.value;
		  
		}
	})
	 //报告时间
	var advdrRepDateTime=$('#advdrRepDate').datetimebox('getValue');
	var advdrRepDate="",advdrRepTime="";
	if(advdrRepDateTime!=""){
		advdrRepDate=advdrRepDateTime.split(" ")[0];  //报告日期
		advdrRepTime=advdrRepDateTime.split(" ")[1];  //报告时间
	}
	  if(advdrRepDateTime==""){
	  $.messager.alert("提示:","报告《报告时间日期》不能为空！");
		return;
	}
                
	//2、报告编码
	var advdrRepCode=$('#advdrRepCode').val();
	
	advdrRepCode=advdrRepCode.replace(/[ ]/g,""); //去掉编码中的空格

	//3、报告类型   4、严重时损伤
	var advdrRepType="",advdrRepTSDesc="",advdrRepTypeNew="";//是否新的
		 if($("#new").is(':checked')){
		advdrRepTypeNew="Y";
	} 
	
    $("input[type=checkbox][name=advdrRepType]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrRepType=this.value;
			
		}
	})
    if(advdrRepType=="11"){
		advdrRepTSDesc=$("#serdesc").val();  //类型为严重时,获取损害情形
	}
	if((advdrRepTSDesc=="")&(advdrRepType=="11")){
		$.messager.alert("提示:","报告类型为严重时,请选择严重情形描述！");
		return;
	}
	                
	//5、报告单位类别
	var advdrRepDeptType="";
	//6、报告单位描述
	var advdrRepDeptTypeDesc="";
    $("input[type=checkbox][name=advdrRepDeptType]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrRepDeptType=this.value;
		}
	})
	advdrRepDeptTypeDesc=$('#RepDeptTypeOther').val();

           
	//、病人信息

	//var advdrAdm=$('#advdrAdm').val(); //就诊adm号  7
	      
	var advdrPatID=$('#advdrPatID').val(); //病人ID  8
	 if(advdrPatID==""){
	  $.messager.alert("提示:","【病人ID】不能为空！");
		return;
	}
	
	var advdrPatName=$('#PatName').val(); //患者姓名 9
	var advdrPatSex=$('#PatSex').combobox('getValue');;  //性别  10
	var advdrPatAge=$('#PatAge').val();  //年龄  11
	var advdrPatDOB=$('#PatDOB').datebox('getValue');  //出生日期  12
	var advdrPatNation=$('#PatNation').combobox('getValue');  //民族  13
	var advdrPatWeight=$('#PatWeight').val();  //体重   14
	var advdrPatContact=$('#PatContact').val(); //联系方式  15
	 
	if(advdrPatNation==""){
		$.messager.alert("提示:","【病人民族】不能为空！");
		return false;
	} 
	  
	//6、原患疾病
	var adrrPatOriginalDis=$('#adrrPatOriginalDis').val(); //病人ID
	 
	//16、医院名称
	var advdrHospital=$('#Hospital').val(); //医院名称
	
	//17、病历号/门诊号
	var advdrPatMedNo=$('#PatMedNo').val(); //病历号/门诊号
	
	
	
	var smokhis="",drinhis="",gestper="",hepahis="",nephhis="",allehis="",iiothers="",iiothersdesc="";
    if($("#II10").is(':checked')){smokhis="10";}; //吸烟史
    if($("#II11").is(':checked')){drinhis="11";}; //饮酒史
    if($("#II12").is(':checked')){gestper="12";}; //妊娠期
    if($("#II13").is(':checked')){hepahis="13";}; //肝病史
    if($("#II14").is(':checked')){nephhis="14";}; //肾病史
    if($("#II15").is(':checked')){allehis="15";}; //过敏史
    if($("#II99").is(':checked')){ 	//其他
	    iiothers="99";
	    iiothersdesc=$('#iiothersdesc').val();
	};
	//患者重要信息
	var advdrepImpInfodataList=smokhis+","+drinhis+","+gestper+","+hepahis+","+nephhis+","+allehis+","+iiothers;

	//19  20、既往药品不良反应事件
	var advdrEventHistory="";
	var advdrEventHistoryDesc="";
	$("input[type=checkbox][name=advdrEventHistory]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventHistory=this.value;
		}
	})
	
	// 有的话取其描述
	if(advdrEventHistory=="10"){
		advdrEventHistoryDesc=$('#advdrEventHistDesc').val();
		 if(advdrEventHistoryDesc==""){
			$.messager.alert("提示:","请填写既往药品不良反应事件描述！");
			return;
		} 
	}
	
	//21 22、家族药品不良反应事件
	var advdrEventFamily="";
	var advdrEventFamilyDesc=""; 
	$("input[type=checkbox][name=advdrEventFamily]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventFamily=this.value;
		}
	})
	
	// 有的话取其描述
	if(advdrEventFamily=="10"){
		advdrEventFamilyDesc=$('#advdrEventFamiDesc').val();
		 if(advdrEventFamilyDesc==""){
			$.messager.alert("提示:","请填写家族药品不良反应事件描述！");
			return;
		} 
	}
	
	//25、药品
	var tmpItmArr=[],phcItmStr="";
	//怀疑药品
	var suspItems = $('#susdrgdg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
			if(item.dosqty!=undefined){
			    var tmp="10"+"^"+item.orditm+"^"+item.phcdf+"^"+item.apprdocu+"^"+trSpecialSymbol(item.incidesc)+"^"+item.genenicdr+"^"+
			    item.formdr+"^"+item.manfdr+"^"+trsUndefinedToEmpty(item.batno)+"^"+item.dosqty+"^"+item.dosuomID+"^"+item.instrudr+"^"+
			  	item.freqdr+"^"+trsUndefinedToEmpty(item.starttime)+"^"+trsUndefinedToEmpty(item.endtime)+"^"+trsUndefinedToEmpty(item.reasondr)+"^"+trsUndefinedToEmpty(item.usereason);
			    tmpItmArr.push(tmp);
		    
		    }else{
				 var tmp="10"+"^"+item.orditm+"^"+item.phcdf+"^"+item.apprdocu+"^"+trSpecialSymbol(item.incidesc)+"^"+item.genenicdr+"^"+
			    item.formdr+"^"+item.manfdr+"^"+trsUndefinedToEmpty(item.batno)+"^"+item.dosage+"^"+item.dosuomID+"^"+item.instrudr+"^"+
			  	item.freqdr+"^"+trsUndefinedToEmpty(item.starttime)+"^"+trsUndefinedToEmpty(item.endtime)+"^"+trsUndefinedToEmpty(item.reasondr)+"^"+trsUndefinedToEmpty(item.usereason);
			    tmpItmArr.push(tmp);
			    }
		}
	})
	//并用药品
	var suspItems = $('#blenddg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
			if(item.dosqty!=undefined){
			    var tmp="11"+"^"+item.orditm+"^"+item.phcdf+"^"+item.apprdocu+"^"+trSpecialSymbol(item.incidesc)+"^"+item.genenicdr+"^"+
			    item.formdr+"^"+item.manfdr+"^"+trsUndefinedToEmpty(item.batno)+"^"+item.dosqty+"^"+item.dosuomID+"^"+item.instrudr+"^"+
			  	item.freqdr+"^"+trsUndefinedToEmpty(item.starttime)+"^"+trsUndefinedToEmpty(item.endtime)+"^"+trsUndefinedToEmpty(item.reasondr)+"^"+trsUndefinedToEmpty(item.usereason);
			    tmpItmArr.push(tmp);
		    
		    }else{
				 var tmp="11"+"^"+item.orditm+"^"+item.phcdf+"^"+item.apprdocu+"^"+trSpecialSymbol(item.incidesc)+"^"+item.genenicdr+"^"+
			    item.formdr+"^"+item.manfdr+"^"+trsUndefinedToEmpty(item.batno)+"^"+item.dosage+"^"+item.dosuomID+"^"+item.instrudr+"^"+
			  	item.freqdr+"^"+trsUndefinedToEmpty(item.starttime)+"^"+trsUndefinedToEmpty(item.endtime)+"^"+trsUndefinedToEmpty(item.reasondr)+"^"+trsUndefinedToEmpty(item.usereason);
			    tmpItmArr.push(tmp);
			    }
		 }
	})
	phcItmStr=tmpItmArr.join("!!");

   
	
     //26、原患疾病
	var MRCICItms=$('#MRCICItms').val();
	

	//23、事件名称  
	var advdrAdvEvent=$('#AdrEvent').val(); //DHC_PHAdrEvent DR

	//24、25事件发生日期
	var advdrTimeDateOccu=$('#DateOccu').datetimebox('getValue');
	var advdrDateOccu="",advdrTimeOccu="";
	if(advdrTimeDateOccu!=""){
		advdrDateOccu=advdrTimeDateOccu.split(" ")[0];  //事件发生日期
		advdrTimeOccu=advdrTimeDateOccu.split(" ")[1];  //事件发生时间
	}
	
	//26 27 、事件的结果
	var advdrEventResult="";
	var advdrEventResultDesc=""; //结果描述
	var advdrEventResultDate=""; //死亡日期
	var advdrEventDateResult="",advdrEventTimeResult="";
	$("input[type=checkbox][name=advdrEventResult]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventResult=this.value;
		}
	})          
	// 后疑症表现
	if(advdrEventResult=="13"){
		advdrEventResultDesc=$('#advdrEventRSeqDesc').val();
	}
     
    //22、怀疑药品
	var quitflag=0;semptyflag=0;bemptyflag=0;
	var suspItems = $('#susdrgdg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
			semptyflag = 1;
 			if(trsUndefinedToEmpty(item.batno)==""){
				$.messager.alert("提示:","怀疑药品列表【批号】不能为空！");
				quitflag=1;
				return false;
			} 
			
			if(trsUndefinedToEmpty(item.starttime)==""){
				$.messager.alert("提示:","怀疑药品列表【开始时间】不能为空！");
				quitflag=1;
				return false;
			}
			if(trsUndefinedToEmpty(item.endtime)==""){
				$.messager.alert("提示:","怀疑药品列表【结束时间】不能为空！");
				quitflag=1;
				return false;
			}
			//结束日期必须大于开始日期
			if(trsUndefinedToEmpty(item.starttime)>trsUndefinedToEmpty(item.endtime)){
			$.messager.alert("提示:","【开始时间】不能大于【结束时间】！");
				quitflag=1;
				return false;
				}
			
			if(trsUndefinedToEmpty(item.usereason)==""){
				$.messager.alert("提示:","怀疑药品列表【用药原因】不能为空！");
				quitflag=1;
				return false;
			}else if(trsUndefinedToEmpty(item.usereason).length>30){
				var beyond=trsUndefinedToEmpty(item.usereason).length-30;
				$.messager.alert("提示","怀疑药品列表【用药原因】超出"+beyond+"个字");
				quitflag=1;
				return false;
			}
			
		}
	})
	if(quitflag==1){return false;}
	//24、并用药品
	var suspItems = $('#blenddg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
			bemptyflag = 1;
 			if(trsUndefinedToEmpty(item.batno)==""){
				$.messager.alert("提示:","并用药品列表【批号】不能为空！");
				quitflag=1;
				return false;
			}  
			if(trsUndefinedToEmpty(item.starttime)==""){
				$.messager.alert("提示:","并用药品列表【开始时间】不能为空！");
				quitflag=1;
				return false;
			}
			if(trsUndefinedToEmpty(item.endtime)==""){
				$.messager.alert("提示:","并用药品列表【结束时间】不能为空！");
				quitflag=1;
				return false;
			}
			//结束日期必须大于开始日期 
			if(trsUndefinedToEmpty(item.starttime)>trsUndefinedToEmpty(item.endtime)){
			$.messager.alert("提示:","【开始时间】不能大于【结束时间】！");
				quitflag=1;
				return false;
				}
			if(trsUndefinedToEmpty(item.usereason)==""){
				$.messager.alert("提示:","并用药品列表【用药原因】不能为空！");
				quitflag=1;
				return false;

			}else if(trsUndefinedToEmpty(item.usereason).length>30){
				var beyond=trsUndefinedToEmpty(item.usereason).length-30;
				$.messager.alert("提示","并用药品列表【用药原因】超出"+beyond+"个字");
				quitflag=1;
				return false;
			}
		}
	})
	if(quitflag==1){return false;}
  	if((semptyflag==0)&(bemptyflag==0)){
		$.messager.alert("提示:","怀疑和并用药品列表不能同时为空！");
		return false;
		} 
		
	// 直接死因
	if(advdrEventResult=="14"){
		advdrEventResultDesc=$('#advdrEventRDRDesc').val();
		advdrEventResultDate=$('#advdrEventRDRDate').datetimebox('getValue'); //死亡/好转日期
		if(advdrEventResultDesc==""){
			$.messager.alert("提示:","【直接死因】不能为空！");
			return false;
		}
		if(advdrEventResultDate==""){
			$.messager.alert("提示:","【死亡日期】不能为空！");
			return false;
		}else{
			advdrEventDateResult=advdrEventResultDate.split(" ")[0];
			advdrEventTimeResult=advdrEventResultDate.split(" ")[1];
		}
	}
	
	//30、停药后是否减轻
	var advdrEventStopResultt="";
    $("input[type=checkbox][name=advdrEventStopResultt]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventStopResultt=this.value;
		}
	})

	//31、再次使用时是否再次出现同样反应
	var advdrEventTakingAgain="";
    $("input[type=checkbox][name=advdrEventTakingAgain]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventTakingAgain=this.value;
		}
	})

	//32、对原疾病的影响
	var advdrEventEffectOfTreatment="";
    $("input[type=checkbox][name=advdrEventEffectOfTreatment]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventEffectOfTreatment=this.value;
		}
	})

	//33、关联性评价之报告人评价
	var advdrEventCommentOfUser="";
    $("input[type=checkbox][name=advdrEventCommentOfUser]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventCommentOfUser=this.value;
		}
	})

	 // 34
	var advdrEventUserOfReport=$('#advdrEventUserOfReport').val(); //报告人签字

	//35、关联性评价之报告单位评价
	var advdrEventCommentOfDept="";
    $("input[type=checkbox][name=advdrEventCommentOfDept]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventCommentOfDept=this.value;
		}
	})

     //36
	var advdrEventDeptOfReport=$('#advdrEventDeptOfReport').val(); //报单位签字

	//、报告人信息 
	var advdrReportUserTel=$('#advdrReportUserTel').val();  //报告人联系电话  37
	var advdrCareerOfRepUser=""; //报告人职业  38
	
	var advdrCareerOfRepUserDesc=""; //报告人职业描述  39
	$("input[type=checkbox][name=advdrCareerOfRepUser]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrCareerOfRepUser=this.value;
			
		}
	})
	// 其他
	if(advdrCareerOfRepUser=="99"){
		advdrCareerOfRepUserDesc=$('#advdrCareerOfRepUserOthers').val();
	}
	var advdrEmailOfRepUser=$('#advdrEmailOfRepUser').val(); //报告人邮箱  40
	var advdrRepName=$('#advdrRepNameID').val();  //报告人签名  41
	 advdrRepName=UserDr;
	
	//var advdrSignOfRepUser=$('#advdrSignOfRepUser').val();   //报告人签名  41
	// 报告人科室
	var advdrRepLocDr=$('#advdrRepLocID').val(); //42
	 advdrRepLocDr=LocDr;
	//、报告人职称
	var advdrCarPrvTp=$('#advdrCarPrvTp').val();  //43

	//var advdrSignOfRepDept=$('#advdrSignOfRepDeptID').val(); //报告部门
	
	//22、报告单位信息
	var advdrRepDeptName=""//$('#advdrRepDeptName').val();       //报告单位  44
	var advdrRepDeptContacts=""//$('#advdrRepDeptContacts').val(); //报告单位联系人 45
	var advdrRepDeptTel=""//$('#advdrRepDeptTel').val();           //报告单位联系电话 46
	
	//23、备注
	var advdrRepRemark=$('#advdrRepRemark').val(); //备注  47
	
	//、不良反应/事件过程描述（包括症状、体征、临床检验等）及处理情况：54  $('#advdrProcessDesc').val();
	var advdrProcessDesc="";
	var advdrProcessDesc=$('#advdrProcessDesc').val();


	//27、不良反应事件
	var adrEvtItems=$('#AdrEventItms').val();
	
	//28、重点标记
	var  advdrRepImpFlag="N";
	     if(ImpFlag==""){  
		   advdrRepImpFlag=advdrRepImpFlag;
		  }else{  
	         advdrRepImpFlag=ImpFlag;
	      }
	   
	if(flag==1){
		advdrCurStatusDR=AdvdrInitStatDR;  //初始状态	
	}                   
	var advdrepDataList=advdrRepCode+"^"+advdrPriority+"^"+advdrRepType+"^"+advdrRepTSDesc+"^"+advdrRepDeptType+"^"+advdrRepDeptTypeDesc;
	advdrepDataList=advdrepDataList+"^"+EpisodeID+"^"+advdrPatID+"^"+advdrPatName+"^"+advdrPatSex+"^"+advdrPatAge+"^"+advdrPatDOB+"^"+advdrPatNation+"^"+advdrPatWeight+"^"+advdrPatContact;  //15
	advdrepDataList=advdrepDataList+"^"+advdrHospital+"^"+advdrPatMedNo+"^"+advdrepImpInfodataList+"^"+advdrEventHistory+"^"+advdrEventHistoryDesc+"^"+advdrEventFamily+"^"+advdrEventFamilyDesc; //22
	advdrepDataList=advdrepDataList+"^"+advdrAdvEvent+"^"+advdrDateOccu+"^"+advdrTimeOccu+"^"+advdrEventResult+"^"+advdrEventResultDesc;   //27
	advdrepDataList=advdrepDataList+"^"+advdrEventDateResult+"^"+advdrEventTimeResult+"^"+advdrEventStopResultt+"^"+advdrEventTakingAgain;  //31
	advdrepDataList=advdrepDataList+"^"+advdrEventEffectOfTreatment+"^"+advdrEventCommentOfUser+"^"+advdrEventUserOfReport+"^"+advdrEventCommentOfDept+"^"+advdrEventDeptOfReport; //36
	advdrepDataList=advdrepDataList+"^"+advdrReportUserTel+"^"+advdrCareerOfRepUser+"^"+advdrCareerOfRepUserDesc+"^"+advdrEmailOfRepUser; //40
	advdrepDataList=advdrepDataList+"^"+advdrRepName+"^"+advdrRepLocDr+"^"+advdrCarPrvTp+"^"+advdrRepDeptName+"^"+advdrRepDeptContacts+"^"+advdrRepDeptTel+"^"+advdrRepRemark  //47
	advdrepDataList=advdrepDataList+"^"+advdrCurStatusDR+"^"+AdvdrReportType //49
	advdrepDataList=advdrepDataList+"^"+iiothersdesc+"^"+advdrRepDate+"^"+advdrRepTime //52
	advdrepDataList=advdrepDataList+"^"+advdrProcessDesc+"^"+advdrRepTypeNew+"^"+advdrRepImpFlag //55
	

	var advdrRepAuditList="";
	if(flag==1){
		advdrRepAuditList=advdrCurStatusDR+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+AdvdrNextLoc+"^"+AdvdrLocAdvice+"^"+AdvdrReceive+"^"+AdvdrReportType;
	} 
	
	var param="advdrID="+advdrID+"&advdrepDataList="+advdrepDataList+"&ItmStr="+phcItmStr+"&AdrEvtItems="+adrEvtItems+"&advdrRepAuditList="+advdrRepAuditList; 
	//alert(param);
	$.messager.confirm("提示", "是否进行保存数据", function (res) {//提示是否删除
		if (res) {
			$.ajax({
   	   			type: "POST",
      			url: url,
       			data: "action=SaveMadrReport&"+param,
       			success: function(val){
	                   //alert(val)
	      			var advdrArr=val.replace(/(^\s*)|(\s*$)/g,"").split("^");
	      			if (advdrArr[0]=="0") {
	      	 			$.messager.alert("提示:","保存成功!");

			 			advdrID=advdrArr[1];
			 			InitAdvReport(advdrID);//获取报告信息(获取编码)	

			 			if(flag==1){
							//$("a:contains('提交')").attr("disabled",true);
							//$("a:contains('暂存')").attr("disabled",true);
							var buttondiv=document.getElementById("buttondiv");
							buttondiv.style.display='none';
						}
	      			}else
	      			{ 
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
/// 病人药品窗口
function patOeInfoWindow()
{
	$('#mwin').window({
		title:'病人用药列表',
		collapsible:true,
		border:false,
		closed:"true",
		width:1000,
		height:520
	}); 

	$('#mwin').window('open');
	InitPatMedGrid();
}

//初始化病人用药列表
function InitPatMedGrid()
{
	//定义columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'incidesc',title:'名称',width:240},
		{field:'genenic',title:'通用名',width:140},
	    {field:'batno',title:'批号',width:60,hidden:true},
	    {field:'staDate',title:'开始日期',width:60,hidden:true},
	    {field:'endDate',title:'结束日期',width:60,hidden:true},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:'剂量',width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'用法',width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:'频次',width:40},//priorty
		{field:'priorty',title:'优先级',width:60},//priorty
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:'疗程',width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:'批准文号',width:80},
		{field:'manf',title:'厂家',width:80},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:'剂型',width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true}
	]];
	
	//定义datagrid
	$('#medInfo').datagrid({
		url:'',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // 每页显示的记录条数
		pageList:[15,30,45],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID}
	});
}

//添加怀疑药品
function addSuspectDrg()
{  
	///判断药品是否重复添加
   if(!AppBeforeCheck("susdrgdg")){return false;}
    
	//用药列表
	var rows = $('#susdrgdg').datagrid('getRows');
	for(var i=0;i<rows.length;i++)
	{
		if(rows[i].orditm==""){
			break;
		}
	}
	
	var sucflag=0;
	var checkedItems = $('#medInfo').datagrid('getChecked');
	if(checkedItems.length==0){
		$.messager.alert("提示:","请选择待添加药品！");
		return;
	}
	
    $.each(checkedItems, function(index, item){
	    //alert(item.dosage)
	    var rowobj={
			orditm:item.orditm, phcdf:item.phcdf, incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		    batno:item.batno,starttime:item.staDate,endtime:item.endDate,genenicdr:item.genenicdr, usemethod:item.dosage+"/"+item.instru+"/"+item.freq, dosuomID:item.dosuomID,
		    instrudr:item.instrudr, freqdr:item.freqdr, durId:item.durId, apprdocu:item.apprdocu, 
		    manf:item.manf, manfdr:item.manfdr, formdr:item.formdr,dosqty:item.dosage,dgID:'susdrgdg'
		}

	    if((i>3)||(rows.length<=i)){
			$("#susdrgdg").datagrid('appendRow',rowobj);
		}else{
			$("#susdrgdg").datagrid('updateRow',{	//在指定行添加数据，appendRow是在最后一行添加数据
				index: i, // 行数从0开始计算
				row: rowobj
			});
		}
		i=i+1;
		sucflag=1;
    })
    if(sucflag=="1"){
    	$.messager.alert("提示:","添加成功！");
    }
}

//添加并用药品
function addMergeDrg()
{
   ///判断药品是否重复添加
   if(!AppBeforeCheck("blenddg")){return false;}
   
	//用药列表
	var rows = $('#blenddg').datagrid('getRows');
	for(var i=0;i<rows.length;i++)
	{
		if(rows[i].orditm==""){
			break;
		}
	}
	
	var sucflag=0;
	var checkedItems = $('#medInfo').datagrid('getChecked');
	if(checkedItems.length==0){
		$.messager.alert("提示:","请选择待添加药品！");
		return;
	}
	
    $.each(checkedItems, function(index, item){
	    var rowobj={
			orditm:item.orditm, phcdf:item.phcdf, incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		    batno:item.batno,starttime:item.staDate,endtime:item.endDate,genenicdr:item.genenicdr, usemethod:item.dosage+"/"+item.instru+"/"+item.freq, dosuomID:item.dosuomID,
		    instrudr:item.instrudr, freqdr:item.freqdr, durId:item.durId, apprdocu:item.apprdocu, 
		    manf:item.manf, manfdr:item.manfdr, formdr:item.formdr,dosqty:item.dosage,dgID:'blenddg'
		}
	    if((i>3)||(rows.length<=i)){
			$("#blenddg").datagrid('appendRow',rowobj);
		}else{
			$("#blenddg").datagrid('updateRow',{	//在指定行添加数据，appendRow是在最后一行添加数据
				index: i, // 行数从0开始计算
				row: rowobj
			});
		}
		i=i+1;
		sucflag=1;
    })
    if(sucflag=="1"){
    	$.messager.alert("提示:","添加成功！");
    }
}

//初始化列表使用
function InitdatagridRow(id)
{
	for(var k=0;k<4;k++)
	{
		$('#'+id).datagrid('insertRow',{
			index: k, // 行索引
			row: {
				orditm:'', phcdf:'', incidesc:'', genenic:'', 
			    genenicdr:'', usemethod:'', dosuomID:'',
			    instrudr:'', freqdr:'', durId:'', apprdocu:'', 
			    manf:'', manfdr:'', formdr:'',dgID:id
			}
		});
	}
}

//关闭病人用药窗口
function clsDrgWin()
{
	$('#mwin').window('close');
}
//疾病录入
function createDisWindow()
{
	$('#diswin').window({
		title:'疾病项目列表'+titleOpNotes,
		collapsible:true,
		border:false,
		closed:"true",
		width:800,
		height:520
	}); 

	$('#diswin').window('open');
	InitDisWinPanel();
}

///初始化疾病项目窗口
function InitDisWinPanel()
{
	var disEditRow="";
	var columns=[[
		 {field:'MRCID',title:'MRCID',width:40},   
		 {field:'MRCDesc',title:'描述',width:100,editor:texteditor}
	]];
  
	$('#dislist').datagrid({ 
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,
		idField:'rowid', 
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,//行号 
		pageSize:20,
		pageList:[20,40],
		columns:columns,
		onDblClickRow:function(rowIndex, rowData){ 
			if(disEditRow>="0"){
				$("#seldislist").datagrid('endEdit', disEditRow);//结束编辑，传入之前编辑的行
			}
			var tmpMRCID=rowData.MRCID;
			var tmpMRCDesc=rowData.MRCDesc;
			 $('#seldislist').datagrid('insertRow',{
				 index: 0,	// index start with 0
				 row: {
					MRCDesc: tmpMRCDesc,
					MRCID: tmpMRCID
				}
	         });
		}
	});


	$('#seldislist').datagrid({
		//title:'已选列表(双击清除)',
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,
		idField:'drgid', 
		nowrap: false,
		striped: true, 
		rownumbers:true,//行号
		columns:columns,
		toolbar: [{
			text:'确认',
			iconCls: 'icon-ok',
			handler: function(){
				var disItemArr=[],disItemDescArr=[],disItems="";
				var items = $('#seldislist').datagrid('getRows');
				$.each(items, function(index, item){
					var row = $('#seldislist').datagrid('getRowIndex',item); 
					$('#seldislist').datagrid('endEdit',row); 
					if(item.MRCDesc!=""){
						disItemArr.push(item.MRCID+"^"+item.MRCDesc);
						disItemDescArr.push(item.MRCDesc);
					}
				})
				disItems=disItemArr.join("||");
				$('#adrrPatOriginalDis').val(disItemDescArr.join(","));
				$('#MRCICItms').val(disItems);
				$('#diswin').window('close');
			}
		},{
			text:'添加空行',
			iconCls: 'icon-add',
			handler: function(){
				if(disEditRow>="0"){
					$("#seldislist").datagrid('endEdit', disEditRow);//结束编辑，传入之前编辑的行
				}
				$("#seldislist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
					index: 0, // 行数从0开始计算
					row: {MRCID: '',MRCDesc:''}
				});
				$("#seldislist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
				disEditRow=0;
			}
		}],
		onDblClickRow:function(rowIndex, rowData){
			 $('#seldislist').datagrid('deleteRow',rowIndex);
		}
	});

	//疾病名称回车事件
	$('#textAlise').bind('keypress',function(event){
		 if(event.keyCode == "13"){
			 var input=$.trim($("#textAlise").val());
			 if (input!=""){
				$('#dislist').datagrid({
					url:url+'?action=GetMRCICDDx',	
					queryParams:{
						params:input
					}
				});
			 }	
		 }
	});
}

//不良反应事件
function createAdrEvtWindow()
{
	$('#AdrEvtWin').window({
		title:'不良反应事件'+titleOpNotes,
		collapsible:true,
		border:false,
		closed:"true",
		width:800,
		height:520
	}); 

	$('#AdrEvtWin').window('open');
	InitAdreEvtwinWinPanel();
}

///初始化不良反应事件窗口
function InitAdreEvtwinWinPanel()
{
	var adrEvtEditRow=""; //当前编辑行
	var columns=[[
		{field:'AdrEvtID',title:'AdrEvtID',width:40},   
		{field:'AdrEvtDesc',title:'不良反应名称',width:100,editor:texteditor}
	]];
  
	$('#adrevtlist').datagrid({ 
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,//行号 
		pageSize:20,
		pageList:[20,40],
		columns:columns,
		onDblClickRow:function(rowIndex, rowData){ 
			if(adrEvtEditRow>="0"){
				$("#seladrevtlist").datagrid('endEdit', adrEvtEditRow);//结束编辑，传入之前编辑的行
			}
			var tmpAdrEvtID=rowData.AdrEvtID;
			var tmpAdrEvtDesc=rowData.AdrEvtDesc;
			
			//判断不良事件名称添加是否重复
			var  dataList=$('#seladrevtlist').datagrid('getData'); 
			for(var i=0;i<dataList.rows.length;i++){
				if(tmpAdrEvtID==dataList.rows[i].AdrEvtID){
					$.messager.alert("提示","数据不能重复!"); 
						return false;
				}
			}

			$('#seladrevtlist').datagrid('insertRow',{
				index: 0,	// index start with 0
				row: {
					AdrEvtDesc: tmpAdrEvtDesc,
					AdrEvtID: tmpAdrEvtID
				}
		    });
		}
		
	});
	//严重级别
	var serLvEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:adrEvtArr,
			valueField: "value", 
			textField: "text",
			required:true,
			editable:false, 
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#seladrevtlist").datagrid('getEditor',{index:adrEvtEditRow,field:'AdrEvtSerLvID'});
				$(ed.target).val(option.value);  //设置科室ID
				var ed=$("#seladrevtlist").datagrid('getEditor',{index:adrEvtEditRow,field:'AdrEvtSerLvDesc'});
				$(ed.target).combobox('setValue', option.text);  //设置科室Desc
			} 
		}
	}
	var columns=[[
		{field:'AdrEvtID',title:'AdrEvtID',width:40},   
		{field:'AdrEvtDesc',title:'不良反应名称',width:100,editor:texteditor},
		{field:'AdrEvtSerLvID',title:'AdrEvtSerLvID',width:60,editor:texteditor},
		{field:'AdrEvtSerLvDesc',title:'严重程度',width:60,editor:serLvEditor}
	]];
	
	$('#seladrevtlist').datagrid({
		//title:'已选列表(双击清除)',
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,
		nowrap: false,
		striped: true, 
		rownumbers:true,//行号
		columns:columns,
		toolbar: [{
			text:'确认',
			iconCls: 'icon-ok',
			handler: function(){
				var adrEvtItemArr=[],adrEvtItmDescArr=[],adrEvtItems="";
				var items = $('#seladrevtlist').datagrid('getRows');
				var quitflag=0;
				$.each(items, function(index, item){
					var row = $('#seladrevtlist').datagrid('getRowIndex',item); 
					$('#seladrevtlist').datagrid('endEdit',row);
					if(item.AdrEvtDesc==""){
						$.messager.alert("提示:","不良反应名称不能为空！");
						quitflag=1;
						return;
					}
                  /*if(typeof item.AdrEvtSerLvID=="undefined"){
						$.messager.alert("提示:","不良反应严重程度不能为空！");
						quitflag=1;
						return;
					} */
					
					if(item.AdrEvtDesc!=""){
		
						adrEvtItemArr.push(item.AdrEvtID+"^"+item.AdrEvtDesc+"["+item.AdrEvtSerLvDesc+"]");
						adrEvtItmDescArr.push(item.AdrEvtDesc+"["+item.AdrEvtSerLvDesc+"]");
					}
				})
				
				if(quitflag==1){return;}
				adrEvtItems=adrEvtItemArr.join("||");
				
				//判断不良反应严重程度是否为空！
				var advSerLv="undefined";
				AdrEvtSerLv=adrEvtItems.indexOf(advSerLv);
				if(AdrEvtSerLv>=0){
					$.messager.alert("提示:","不良反应严重程度不能为空！");
					quitflag=1;
					return;
				}
				  
				$('#AdrEvent').val(adrEvtItmDescArr.join(","));
				$('#AdrEventItms').val(adrEvtItems);
				$('#AdrEvtWin').window('close');
			}
		},{
			text:'添加空行',
			iconCls: 'icon-add',
			handler: function(){
				if(adrEvtEditRow>="0"){
					$("#seladrevtlist").datagrid('endEdit', adrEvtEditRow);//结束编辑，传入之前编辑的行
				}
				$("#seladrevtlist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
					index: 0, // 行数从0开始计算
					row: {AdrEvtID: '',AdrEvtDesc:''}
				});
				$("#seladrevtlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
				adrEvtEditRow=0;
			}
		}],
		onDblClickRow:function(rowIndex, rowData){
			 $('#seladrevtlist').datagrid('deleteRow',rowIndex);
		},
		onClickRow:function(rowIndex, rowData){
			 $("#seladrevtlist").datagrid('beginEdit',rowIndex);//开启编辑并传入要编辑的行
			 adrEvtEditRow=rowIndex;
		}
	});
    //加载维护字典表中的不良事件名称的信息
	$('#adrevtlist').datagrid({
		url:url+'?action=GetAdvEvent',	
		queryParams:{
			params:""
		}
	});

	//不良反应/事件名称回车事件
	$('#textAdrEvtAlise').bind('keypress',function(event){
		 if(event.keyCode == "13"){
			 var input=$.trim($("#textAdrEvtAlise").val());
			 if (input!=""){
				$('#adrevtlist').datagrid({
					url:url+'?action=GetAdvEvent',	
					queryParams:{
						params:input
					}
				});
			 }	
		 }
	});
	modAdrEvtList(); //加载已经选择的反应信息
}

/// 加载已经选择的反应信息
function modAdrEvtList()
{
	if($('#AdrEventItms').val()==""){return;}
	var adrEventItms=$('#AdrEventItms').val(); //获取已存在不良反应名称
	var adrEventItmArr=adrEventItms.split("||");
	var tempArr=[];
	for(var i=0;i<adrEventItmArr.length;i++){
		var adrEvtItmArr=adrEventItmArr[i].split("^");
		var adrEvtItmDesc=adrEvtItmArr[1].split("[")[0];
		var adrEvtItmSerLvDesc=adrEvtItmArr[1].split("[")[1].replace(/]$/gi,"");
        AdrEvtSerLvID="G"
		if (adrEvtItmSerLvDesc=="严重")
		{
			AdrEvtSerLvID="S";
		}
		tempArr.push("{\"AdrEvtID\":\""+adrEvtItmArr[0]+"\",\"AdrEvtDesc\":\""+adrEvtItmDesc+"\",\"AdrEvtSerLvID\":\""+AdrEvtSerLvID+"\",\"AdrEvtSerLvDesc\":\""+adrEvtItmSerLvDesc+"\"}");		
	}
	var jsdata = '{"total":'+adrEventItmArr.length+',"rows":['+tempArr.join(",")+']}';
	var data = $.parseJSON(jsdata);
	$('#seladrevtlist').datagrid("loadData",data);//将数据绑定到DataGrid中
}

/// 严重药品不良反应的损害情形窗口
function createAdrEvtRetWindow()
{
	$('#AdrEvtRetWin').window({
		title:'严重药品不良反应的损害情形',
		collapsible:false,
		border:false,
		closed:false,
		width:500,
		height:300,
		onClose:function(){
			$("input[type=checkbox]").each(function(){
				if($('#'+this.id).is(':checked')){
					$('#serdesc').val($('#'+this.id+"S").html());
					$('#modser').css("display","");
					$('#serdesc').css("display","");
				}
			});

			if($('#serdesc').val()==""){
				$.messager.alert("提示:","选择严重时,必须勾选严重情形!");
				return false;
			}
		}
	}); 

	$('#AdrEvtRetWin').window('open');
}
//替换特殊符号 
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
function InitAdvReport(advdrID)
{
	if(advdrID==""){return;}
   	var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
	var advdrepDataList="";
	//获取报表信息
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=GetMadrRepInfo&advdrID="+advdrID+"&params="+params,
       //dataType: "json",
       success: function(val){
	      	 advdrepDataList=val;
	      	 
	      	    var tmp=advdrepDataList.split("!");
	      	    
				$('#advdrID').val(tmp[0]);    //报表ID
				$('#advdrRepCode').attr("disabled",true);
				$('#advdrRepCode').val(tmp[1]); //编号
				if (tmp[2]=="10"){             //优先级
					$('#firrep').attr("checked",true);
				}else if(tmp[2]=="11"){
					$('#trarep').attr("checked",true);
				}
				//$('#PL'+tmp[23]).attr("checked",true);
			
				//报告类型
				$('#RT'+tmp[3]).attr("checked",true);
				if(tmp[3]=="11"){  //严重情形描述
					$('#modser').css("display","");
					$('#serdesc').css("display","");
					$('#serdesc').val(tmp[4]);  //严重时损伤
					
				}
				
				//报告单位类别
				$('#RD'+tmp[5]).attr("checked",true);
				$('#RepDeptTypeOther').val(tmp[6]);  //其他描述
				if(tmp[5]=="99"){
					$('#RepDeptTypeOther').attr("disabled",false);
				}
				 
				//病人信息
				$('#advdrPatID').val(tmp[8]); //病人ID
				$('#PatName').val(tmp[9]);   //患者姓名
				$('#PatSex').combobox('setValue',tmp[10]);     //性别
				$('#PatAge').val(tmp[11]);  //年龄
				$('#PatDOB').datebox("setValue",tmp[12]);      //出生日期
				$('#PatNation').combobox('setValue',tmp[13]);  //民族
				$('#PatWeight').val(tmp[14]);  //体重
				$('#PatContact').val(tmp[15]); //联系方式
				
				$('#Hospital').val(tmp[16]); //医院名称
				
				$('#PatMedNo').val(tmp[17]);   //病历号
				
				//既往药品不良事件
				$('#EH'+tmp[19]).attr("checked",true);
				$('#advdrEventHistDesc').val(tmp[20]); 
				if(tmp[19]=="10"){
					$('#advdrEventHistDesc').attr("disabled",false);
				}
				//家族药品不良事件
				$('#EF'+tmp[21]).attr("checked",true);
				$('#advdrEventFamiDesc').val(tmp[22]); 
				if(tmp[21]=="10"){
					$('#advdrEventFamiDesc').attr("disabled",false);
				}
				//事件名称
				$('#AdrEvent').val(tmp[23]);
				if(tmp[24]!=""||tmp[25]!=""){
					$('#DateOccu').datetimebox('setValue',tmp[24]+" "+tmp[25]);  //日期
				}
				//事件结果
				$('#RR'+tmp[26]).attr("checked",true);
				if(tmp[26]=="13"){
					$('#advdrEventRSeqDesc').val(tmp[27]);
					$('#advdrEventRSeqDesc').attr("disabled",false);
				}else if(tmp[26]=="14"){
					$('#advdrEventRDRDesc').val(tmp[27]);
					$('#advdrEventRDRDesc').attr("disabled",false);
					$('#advdrEventRDRDate').datebox({disabled:false});
					//死亡时间
					$('#advdrEventRDRDate').datetimebox('setValue',tmp[28]+" "+tmp[29]);
				};
				
				//停药或减量后，反应/事件是否消失或减轻
				$('#ES'+tmp[30]).attr("checked",true);
				
				//再次使用可疑药品后是否再次出现同样反应/事件
				$('#ET'+tmp[31]).attr("checked",true);
				
				//对原患疾病的影响
				$('#RE'+tmp[32]).attr("checked",true);
				
				//填报人评价
				$('#ECU'+tmp[33]).attr("checked",true);   
				
				$('#advdrEventUserOfReport').val(tmp[34]);
				
				//报告单位评价
				$('#ECD'+tmp[35]).attr("checked",true);
				$('#advdrEventDeptOfReport').val(tmp[36]);   //报单位签字
				
				//报告人信息
				$('#advdrReportUserTel').val(tmp[37]);  // 联系电话
				
				//报告人职业
				$('#RU'+tmp[38]).attr("checked",true);
				
		        $('#advdrCareerOfRepUserOthers').val(tmp[39]); //其他

			      if(tmp[38]=="99"){
					$('#advdrCareerOfRepUserOthers').attr("disabled",false);
				}
				
				$('#advdrEmailOfRepUser').val(tmp[40]); //报告人邮箱  40
	    
		        $('#advdrRepNameID').val(tmp[59]);	//报告人
		        $('#advdrRepName').val(tmp[41]); //报告人
		        $('#advdrRepName').attr("disabled",true);
		 		
		        $('#advdrRepLocID').val(tmp[60]);    //报告人科室
		        $('#advdrRepLocDr').val(tmp[42]);    //报告人科室
		        $('#advdrRepLocDr').attr("disabled",true);
		        
		        $('#advdrCarPrvTp').val(tmp[43]);    //报告人职称
		 
				$('#advdrRepDeptName').val(tmp[44]);//报告单位
				$('#advdrRepDeptName').attr("disabled","true");
				
				//$('#advdrRepDeptContacts').val(tmp[45]);  //报告单位联系人
				//$('#advdrRepDeptTel').val(tmp[46]);   //报告单位联系电话
				
				$('#advdrRepRemark').val(tmp[47]);//备注
				$('#advdrRepDate').datetimebox({disabled:true});
				$('#advdrRepDate').datetimebox('setValue',tmp[51]+" "+tmp[52]);	 //报告日期
				
				EpisodeID=tmp[7]; //病人ADM  就诊号	
				
               /*
            	
		        //原患疾病
				$('#adrrPatOriginalDis').val(tmp[48]);
				$('#MRCICItms').val(tmp[47]);
				
				//不良反应
				$('#AdrEvent').val(tmp[50]);
				$('#AdrEventItms').val(tmp[49]); */
				
				var adrRepImpInfo=tmp[18];
				adrRepImpInfoArr=adrRepImpInfo.split(",");
				for(var k=0;k<adrRepImpInfoArr.length;k++){
					var tmpstr=adrRepImpInfoArr[k].split("^");
					$('#II'+tmpstr[0]).attr("checked",true);
					if(tmpstr[0]=="99"){
						$('#iiothersdesc').val(tmpstr[1]);
						$('#iiothersdesc').attr("disabled",false);
					}
				}
		
                //不良反应
				$('#AdrEvent').val(tmp[62]);

				$('#AdrEventItms').val(tmp[61]);
                 
             	//、不良反应/事件过程描述（包括症状、体征、临床检验等）及处理情况：
             	$('#advdrProcessDesc').val(tmp[53]);
				//是否新的
				if(tmp[54]=="Y"){
					$('#new').attr("checked",true);
				}
				
			    advdrCurStatusDR=tmp[48];
			    AdvdrReportType=tmp[49];	
			    AdvdrInitStatDR=tmp[55];	
				
				AdvdrNextLoc=tmp[56]
				AdvdrLocAdvice=tmp[57]
				AdvdrReceive=tmp[58];
				
				UserDr=tmp[59];//报告人ID
				LocDr=tmp[63];//科室ID
		        ImpFlag=tmp[64];//重要标记
			    if (advdrCurStatusDR=="")
				{
					advdrCurStatusDR=advdrCurStatusDR;
					AdvdrReceive="";
				}
				else
				{
					//advdrCurStatusDR=AdvdrInitStatDR;
					AdvdrInitStatDR=tmp[48];
					AdvdrReceive="1";
				}
				
       },
       error: function(){
	       alert('链接出错');
	       return;
	   }
    });
    //怀疑和并用考虑合并在一起,暂时先分开取数据
	$('#susdrgdg').datagrid({
		url:url+'?action=getAdvRepDrgItm&advdrID='+advdrID,	
		queryParams:{
			params:10
		}
	});
	
	//并用
	$('#blenddg').datagrid({
		url:url+'?action=getAdvRepDrgItm&advdrID='+advdrID,	
		queryParams:{
			params:11
		}
	});

}

//加载报表默认信息
function InitRepInfo(advdrID,adrDataList)
{    
	if(advdrID!=""){return;}
   	if(adrDataList==""){
		adrDataList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode; 
	}
   //var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
   $.ajax({
   type: "POST",
   url: url,
   data:"action=getMadrInfo&params="+adrDataList,
   success: function(val){
		if(val==-1){
			alert('请先配置工作流,然后填报');
			return;
		}else{
			var tmp=val.split("^");
			$('#advdrRepDate').datetimebox({disabled:true});
			$('#advdrRepDate').datetimebox("setValue",tmp[1]);   //报告日期
		
			//$('#advdrRepCode').val(tmp[0]);                //报告编码
			$('#advdrRepCode').attr("disabled","true");    //
		
			$('#advdrEventDeptOfReport').val(LgUserName) //报告单位签字
			$('#advdrEventDeptOfReport').attr("disabled","true");
			$('#advdrEventUserOfReport').val(LgUserName)   //报告人签名
			$('#advdrEventUserOfReport').attr("disabled","true");
			
			$('#advdrRepName').val(LgUserName);    //报告人
			$('#advdrRepName').attr("disabled","true");
		    $('#advdrRepNameID').val(LgUserID);	//报告人id
			$('#advdrRepLocDr').val(tmp[4]);    //报告人科室
			$('#advdrRepLocDr').attr("disabled","true");
			$('#advdrRepLocID').val(LgCtLocID);    //报告人科室id
		
			$('#advdrCarPrvTp').val(tmp[5]);    //报告人职称
			//$('#advdrCarPrvTp').attr("disabled","true");
		
			UserDr=tmp[6]
			LocDr=tmp[7]     
			AdvdrInitStatDR=tmp[2];  //报表的初始化,状态 
			AdvdrReportType=tmp[3];  //报告类型
		}
   }})
}

//获取病人信息
function InitPatientInfo(patientID,EpisodeID){

	//var advdrPatID=$('#advdrPatID').val(); //病人ID 
	//var advdrPatID=getRegNo(advdrPatID);
    if(patientID==""||EpisodeID==""){return;}
	//获取报表信息
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getRepPatInfo&PatNo="+patientID+"&EpisodeID="+EpisodeID,
       success: function(val){
	  
	   	var advRepPatInfo=val;
	    var tmp=advRepPatInfo.split("^");

		$('#advdrPatID').val(tmp[0]); //病人ID  登记号
		$('#PatName').val(tmp[1]); //病人名字 
		$('#PatName').attr("disabled","true");
		$('#PatSex').combobox({disabled:true});
		$('#PatSex').combobox('setValue',tmp[2]);  //性别
		$('#PatMedNo').val(tmp[5]);  //病案号
		$('#PatMedNo').attr("disabled","true");
		$('#PatDOB').datebox({disabled:true}); //出生日期
		$('#PatDOB').datebox("setValue",tmp[6]);  
		$('#PatNation').combobox('setValue',tmp[13]);  //民族
		$('#PatContact').val(tmp[15]); //联系方式
		$('#PatWeight').val(tmp[17]);  //体重
		patIDlog=$('#advdrPatID').val();
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
///保存前,进行数据完成性检查
 function saveBeforeCheck()
{
	if(currEditRow>="0"){
		
	 $("#"+currEditID).datagrid('endEdit', currEditRow);
	}
	
	//2、报告编码
	var advdrRepCode=$('#advdrRepCode').val();
	/* if(advdrRepCode==""){
		$.messager.alert("提示:","【报告编码】不能为空！");
		return false;
	} */
	advdrRepCode=advdrRepCode.replace(/[ ]/g,""); //去掉编码中的空格

	//3、报告类型
	var advdrRepType="",advdrRepTSDesc="";
    $("input[type=checkbox][name=advdrRepType]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrRepType=this.value;
		}
	})
    if(advdrRepType=="11"){
		advdrRepTSDesc=$("#serdesc").val();  //类型为严重时,获取损害情形
	}
	if((advdrRepTSDesc=="")&(advdrRepType=="11")){
		$.messager.alert("提示:","【报告类型】为严重时,请选择严重情形描述！");
		return false;
	}
	
	//4、报告单位类别
	/* var advdrRepDeptType="";
	var advdrRepDeptTypeDesc="";
    $("input[type=checkbox][name=advdrRepDeptType]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrRepDeptType=this.value;
		}
	})
	advdrRepDeptTypeDesc=$('#RepDeptTypeOther').val();
	if(advdrRepDeptType==""){
		$.messager.alert("提示:","【报告单位类别】不能为空！");
		return false;
	} */
	
	
	//5、联系方式
	if($('#PatContact').val()==""){
		$.messager.alert("提示:","【联系方式】不能为空！");
		return false;
	}
	
	//6、原患疾病
	/* if($('#adrrPatOriginalDis').val()==""){
		$.messager.alert("提示:","【原患疾病】不能为空！");
		return false;
	} */
	 
	 
	//7、既往药品不良反应/事件if($('#'+this.id).is(':checked')){
	if($('#EH10').is(':checked')){
		if($('#advdrEventHistDesc').val()==""){
			$.messager.alert("提示:","请填写【既往药品不良反应/事件】！");
			return false;
		}
	}
	
	//8、家族药品不良反应/事件
	if($('#EF10').is(':checked')){
		if($('#advdrEventFamiDesc').val()==""){
			$.messager.alert("提示:","请填写【家族药品不良反应/事件】！");
			return false;
		}
	}
	
  /*   //23、事件名称  
	if($('#AdrEvent').val()==""){
		$.messager.alert("提示:","【报告事件名称】不能为空！");
		return false;
		};  */

	//24、25事件发生日期
	var advdrTimeDateOccu=$('#DateOccu').datetimebox('getValue');
	var advdrDateOccu="",advdrTimeOccu="";
	if(advdrTimeDateOccu!=""){
		advdrDateOccu=advdrTimeDateOccu.split(" ")[0];  //事件发生日期
		advdrTimeOccu=advdrTimeDateOccu.split(" ")[1];  //事件发生时间
	}
	 if(advdrTimeDateOccu==""){
	  $.messager.alert("提示:","报告【报告事件发生日期】不能为空！");
		return false;
	}
     //不良反应/事件过程描述（包括症状、体征、临床检验等）及处理情况：54
     if($('#advdrProcessDesc').val()==""){ //报告人签字
		$.messager.alert("提示:","【不良反应/事件过程描述】不能为空！");
		return false;
	}
	
	//26 27 、事件的结果
	var advdrEventResult="";
	var advdrEventResultDesc=""; //结果描述
	var advdrEventResultDate=""; //死亡日期
	var advdrEventDateResult="",advdrEventTimeResult="";
	$("input[type=checkbox][name=advdrEventResult]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrEventResult=this.value;
		}
	}) 
	 
	 if(advdrEventResult==""){
		$.messager.alert("提示:","【报告事件的结果】不能为空！");
		return false;
	}        
	// 直接死因
	if(advdrEventResult=="14"){
		advdrEventResultDesc=$('#advdrEventRDRDesc').val();
		advdrEventResultDate=$('#advdrEventRDRDate').datetimebox('getValue'); //死亡/好转日期
		if(advdrEventResultDesc==""){
			$.messager.alert("提示:","【直接死因】不能为空！");
			return false;
		}
		if(advdrEventResultDate==""){
			$.messager.alert("提示:","【死亡日期】不能为空！");
			return false;
		}else{
			advdrEventDateResult=advdrEventResultDate.split(" ")[0];
			advdrEventTimeResult=advdrEventResultDate.split(" ")[1];
		}
	}
	
/* 	if($('#advdrEventUserOfReport').val()==""){ //报告人签字
		$.messager.alert("提示:","【报告人签字】不能为空！");
		return false;
	} */
	
	//17、报告人联系电话
	if($('#advdrReportUserTel').val()==""){
		$.messager.alert("提示:","【报告人联系电话】不能为空！");
		return false;
	}
	
	//19、电子邮箱
	if($('#advdrEmailOfRepUser').val()==""){
		$.messager.alert("提示:","【报告人电子邮箱】不能为空！");
		return false;
	}
	
	//20、签名
 	if($('#advdrSignOfRepUser').val()==""){
		$.messager.alert("提示:","【报告人签名】不能为空！");
		return false;
	} 
	
	//21、报告部门
	if($('#advdrSignOfRepDept').val()==""){
		$.messager.alert("提示:","【报告部门】不能为空！");
		return false;
	}
	
	//22、报告人职业
	var advdrCareerOfRepUser="";
	$("input[type=checkbox][name=advdrCareerOfRepUser]").each(function(){
		if($('#'+this.id).is(':checked')){
			advdrCareerOfRepUser=this.value;
			
		}
	})
	
	if(advdrCareerOfRepUser==""){
		$.messager.alert("提示:","【报告人职业】不能为空！");
		return false;
	}
	// 其他
	if(advdrCareerOfRepUser=="99"){
		if($('#advdrCareerOfRepUserOthers').val()==""){
			$.messager.alert("提示:","请填写【报告人职业其他描述】！");
			return false;	
		} 
	}
	
	//21、报告部门
	if($('#advdrSignOfRepDept').val()==""){
		$.messager.alert("提示:","【报告部门】不能为空！");
		return false;
	}
		
	//22、怀疑药品
	var quitflag=0;semptyflag=0;bemptyflag=0;
	var suspItems = $('#susdrgdg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
			semptyflag = 1;
 			if(trsUndefinedToEmpty(item.batno)==""){
				$.messager.alert("提示:","怀疑药品列表【批号】不能为空！");
				quitflag=1;
				return false;
			} 
			
			if(trsUndefinedToEmpty(item.starttime)==""){
				$.messager.alert("提示:","怀疑药品列表【开始时间】不能为空！");
				quitflag=1;
				return false;
			}
			if(trsUndefinedToEmpty(item.endtime)==""){
				$.messager.alert("提示:","怀疑药品列表【结束时间】不能为空！");
				quitflag=1;
				return false;
			}
			//结束日期必须大于开始日期
			if(trsUndefinedToEmpty(item.starttime)>trsUndefinedToEmpty(item.endtime)){
			$.messager.alert("提示:","【开始时间】不能大于【结束时间】！");
				quitflag=1;
				return false;
				}
			
			if(trsUndefinedToEmpty(item.usereason)==""){
				$.messager.alert("提示:","怀疑药品列表【用药原因】不能为空！");
				quitflag=1;
				return false;
			}else if(trsUndefinedToEmpty(item.usereason).length>30){
				var beyond=trsUndefinedToEmpty(item.usereason).length-30;
				$.messager.alert("提示","怀疑药品列表【用药原因】超出"+beyond+"个字");
				quitflag=1;
				return false;
			}
			
		}
	})
	if(quitflag==1){return false;}
	//24、并用药品
	var suspItems = $('#blenddg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
			bemptyflag = 1;
 			if(trsUndefinedToEmpty(item.batno)==""){
				$.messager.alert("提示:","并用药品列表【批号】不能为空！");
				quitflag=1;
				return false;
			}  
			if(trsUndefinedToEmpty(item.starttime)==""){
				$.messager.alert("提示:","并用药品列表【开始时间】不能为空！");
				quitflag=1;
				return false;
			}
			if(trsUndefinedToEmpty(item.endtime)==""){
				$.messager.alert("提示:","并用药品列表【结束时间】不能为空！");
				quitflag=1;
				return false;
			}
			//结束日期必须大于开始日期 
			if(trsUndefinedToEmpty(item.starttime)>trsUndefinedToEmpty(item.endtime)){
			$.messager.alert("提示:","【开始时间】不能大于【结束时间】！");
				quitflag=1;
				return false;
				}
			if(trsUndefinedToEmpty(item.usereason)==""){
				$.messager.alert("提示:","并用药品列表【用药原因】不能为空！");
				quitflag=1;
				return false;

			}else if(trsUndefinedToEmpty(item.usereason).length>30){
				var beyond=trsUndefinedToEmpty(item.usereason).length-30;
				$.messager.alert("提示","并用药品列表【用药原因】超出"+beyond+"个字");
				quitflag=1;
				return false;
			}
		}
	})
	if(quitflag==1){return false;}
  	if((semptyflag==0)&(bemptyflag==0)){
		$.messager.alert("提示:","怀疑和并用药品列表不能同时为空！");
		return false;
		} 
		
	return true;
}

//页面关联设置
function setCheckBoxRelation(id){
	//if($('#'+id).hasClass('cb_active')){
		
		if($('#'+id).is(':checked')){
		///报告单位类别
		if(id=="RD99"){
			$('#RepDeptTypeOther').attr("disabled",false);
		}		
		///取消后遗症
		if(id=="RR13"){
			$('#advdrEventRSeqDesc').attr("disabled",false);
		}
		///取消直接死因
		if(id=="RR14"){
			$('#advdrEventRDRDesc').attr("disabled",false);
		    $('#advdrEventRDRDate').datetimebox({disabled:false});
		}
	    ///报告人职业
		if(id=="RU99"){
			$('#advdrCareerOfRepUserOthers').attr("disabled",false);
		}    
		///报告单位类别
		if(id=="RD99"){
			$('#RepDeptTypeOther').attr("disabled",false);
		}
		///既往药品不良反应/事件
		if(id=="EH10"){
			$('#advdrEventHistDesc').attr("disabled",false);
			createAdrEvtEHWindow();
		}
		///家族药品不良反应/事件
		if(id=="EF10"){
			$('#advdrEventFamiDesc').attr("disabled",false);
			createAdrEvtEFWindow();
		}
		///相关重要信息
		if(id=="II99"){
			$('#iiothersdesc').attr("disabled",false);
		}
		///报告类型
		if(id=="RT11"){
			$('#serdesc').attr("disabled",false);
		}
	}else{
		///取消后遗症
		if(id=="RR13"){
			$('#advdrEventRSeqDesc').val("");
			$('#advdrEventRSeqDesc').attr("disabled","true");
		}
		///取消直接死因
		if(id=="RR14"){
			
			$('#advdrEventRDRDesc').val("");
			$('#advdrEventRDRDesc').attr("disabled","true")
			$('#advdrEventRDRDate').datetimebox('setValue',"");
			$('#advdrEventRDRDate').datetimebox({disabled:true});
			
		}	
	    ///报告人职业
		if(id=="RU99"){
			$('#advdrCareerOfRepUserOthers').val("");
			$('#advdrCareerOfRepUserOthers').attr("disabled","true");
		}    
		///报告单位类别
		if(id=="RD99"){
			$('#RepDeptTypeOther').val("");
			$('#RepDeptTypeOther').attr("disabled","true");
		}
		///既往药品不良反应/事件
		if(id=="EH10"){
			$('#advdrEventHistDesc').val("");
			$('#advdrEventHistDesc').attr("disabled","true");
		}
		///家族药品不良反应/事件
		if(id=="EF10"){
			$('#advdrEventFamiDesc').val("");
			$('#advdrEventFamiDesc').attr("disabled","true");
		}
		///相关重要信息
		if(id=="II99"){
			$('#iiothersdesc').val("");
			$('#iiothersdesc').attr("disabled","true");
		}
		///报告类型
		if(id=="RT11"){
			$('#serdesc').val("");
			$('#serdesc').hide();
			$('#serdesc').attr("disabled",false);
			
		}
	}
}

//既往药品不良反应/事件窗口
function createAdrEvtEHWindow()
{
	$('#AdrEvtEHWin').window({
		title:'既往药品不良反应/事件',
		collapsible:true,
		border:false,
		closed:"true",
		width:700,
		height:400
	}); 

	$('#AdrEvtEHWin').window('open');
	InitAdrEvtEHWinPanel();
}
///初始化既往药品不良反应/事件窗口
function InitAdrEvtEHWinPanel()
{
	var adrEvtEHEditRow=""; //当前编辑行
	var columns=[[
		{field:'AdrEvtEHDrug',title:'药品名称',width:200,editor:texteditor},
		{field:'AdrEvtEHDesc',title:'不良反应名称',width:120,editor:texteditor}
	]];
  
	$('#adrEvtEHList').datagrid({ 
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,
		nowrap: false,
		striped: true, 
		rownumbers:true,//行号 
		columns:columns,
		toolbar: [{
			text:'确认',
			iconCls: 'icon-ok',
			handler: function(){
				var adrEvtEHItemArr=[];adrEvtEHItems="";
				if(adrEvtEHEditRow>="0"){
					$("#adrEvtEHList").datagrid('endEdit', adrEvtEHEditRow);//结束编辑，传入之前编辑的行
				}
				var items = $('#adrEvtEHList').datagrid('getRows');
				$.each(items, function(index, item){
					if(item.AdrEvtEHDrug!=""){
						adrEvtEHItemArr.push(item.AdrEvtEHDrug+"_"+item.AdrEvtEHDesc);
					}
				})
				adrEvtEHItems=adrEvtEHItemArr.join(",");
				$('#advdrEventHistDesc').val(adrEvtEHItems);
				$('#AdrEvtEHWin').window('close');
			}
		},{
			text:'添加空行',
			iconCls: 'icon-add',
			handler: function(){
				if(adrEvtEHEditRow>="0"){
					$("#adrEvtEHList").datagrid('endEdit', adrEvtEHEditRow);//结束编辑，传入之前编辑的行
				}
				$("#adrEvtEHList").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
					index: 0, // 行数从0开始计算
					row: {AdrEvtEHDrug:'',AdrEvtEHDesc:''}
				});
				$("#adrEvtEHList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
				adrEvtEHEditRow=0;
			}
		}],
		onDblClickRow:function(rowIndex, rowData){
			 $('#adrEvtEHList').datagrid('deleteRow',rowIndex);
		}
	});
	///加载页面数据到列表中
	if($('#advdrEventHistDesc').val()!=""){
		var advdrEventHistDesc=$('#advdrEventHistDesc').val();
		var advdrEventHistDescArr=advdrEventHistDesc.split(",");
		var tempArr=[];
		for(var k=0;k<advdrEventHistDescArr.length;k++){
			tempArr.push("{\"AdrEvtEHDrug\":\""+advdrEventHistDescArr[k].split("_")[0]+"\",\"AdrEvtEHDesc\":\""+advdrEventHistDescArr[k].split("_")[1]+"\"}");
		}
		var jsdata = '{"total":'+advdrEventHistDescArr.length+',"rows":['+tempArr.join(",")+']}';
		var data = $.parseJSON(jsdata);
		$('#adrEvtEHList').datagrid("loadData",data);//将数据绑定到DataGrid中
	}
}

//家族药品不良反应/事件窗口
function createAdrEvtEFWindow()
{
	$('#AdrEvtEFWin').window({
		title:'家族药品不良反应/事件',
		collapsible:true,
		border:false,
		closed:"true",
		width:700,
		height:400
	}); 

	$('#AdrEvtEFWin').window('open');
	InitAdrEvtEFWinPanel();
}

///初始化家族既往药品不良反应/事件窗口
function InitAdrEvtEFWinPanel()
{
	var adrEvtEFEditRow=""; //当前编辑行
	var columns=[[
		{field:'AdrEvtEFDrug',title:'药品名称',width:200,editor:texteditor},
		{field:'AdrEvtEFDesc',title:'不良反应名称',width:120,editor:texteditor}
	]];

	$('#adrEvtEFList').datagrid({ 
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,
		nowrap: false,
		striped: true, 
		rownumbers:true,//行号 
		columns:columns,
		toolbar: [{
			text:'确认',
			iconCls: 'icon-ok',
			handler: function(){
				var adrEvtEFItemArr=[];adrEvtEFItems="";
				if(adrEvtEFEditRow>="0"){
					$("#adrEvtEFList").datagrid('endEdit', adrEvtEFEditRow);//结束编辑，传入之前编辑的行
				}
				var items = $('#adrEvtEFList').datagrid('getRows');
				$.each(items, function(index, item){
					if(item.AdrEvtEFDrug!=""){
						adrEvtEFItemArr.push(item.AdrEvtEFDrug+"_"+item.AdrEvtEFDesc);
					}
				})
				adrEvtEFItems=adrEvtEFItemArr.join(",");
				$('#advdrEventFamiDesc').val(adrEvtEFItems);
				$('#AdrEvtEFWin').window('close');
			}
		},{
			text:'添加空行',
			iconCls: 'icon-add',
			handler: function(){
				if(adrEvtEFEditRow>="0"){
					$("#adrEvtEFList").datagrid('endEdit', adrEvtEFEditRow);//结束编辑，传入之前编辑的行
				}
				$("#adrEvtEFList").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
					index: 0, // 行数从0开始计算
					row: {AdrEvtEFDrug:'',AdrEvtEFDesc:''}
				});
				$("#adrEvtEFList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
				adrEvtEFEditRow=0;
			}
		}],
		onDblClickRow:function(rowIndex, rowData){
			 $('#adrEvtEFList').datagrid('deleteRow',rowIndex);
		}
	});
	///加载页面数据到列表中
	if($('#advdrEventFamiDesc').val()!=""){
		var advdrEventFamiDesc=$('#advdrEventFamiDesc').val();
		var advdrEventFamiDescArr=advdrEventFamiDesc.split(",");
		var tempArr=[];
		for(var k=0;k<advdrEventFamiDescArr.length;k++){
			tempArr.push("{\"AdrEvtEFDrug\":\""+advdrEventFamiDescArr[k].split("_")[0]+"\",\"AdrEvtEFDesc\":\""+advdrEventFamiDescArr[k].split("_")[1]+"\"}");
		}
		var jsdata = '{"total":'+advdrEventFamiDescArr.length+',"rows":['+tempArr.join(",")+']}';
		var data = $.parseJSON(jsdata);
		$('#adrEvtEFList').datagrid("loadData",data);//将数据绑定到DataGrid中
	}
}

//在.js中新增function
function SetAdmTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID=""
	}
	var advdrPatID=$('#advdrPatID').val();
	var advdrPatID=getRegNo(advdrPatID);
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID}
	});
	InitPatientInfo(advdrPatID,EpisodeID);
}
//判断报告编码是否存在
function RepNoRepet(){
	var IDflag=0;
	if (advdrID==""){
		IDflag=0; 
	}else{
		IDflag=1; 
	}
	$('#repnoflag',window.parent.document).val(IDflag); //给父界面元素赋值
	/* //报告编码
	var advRepNo=$('#advdrRepCode').val();
	advRepNo=advRepNo.replace(/[ ]/g,""); //去掉编码中的空格
	$.ajax({
		type: "POST",// 请求方式
    	url: url,
    	data: "action=SeaAdvRepNo&advRepNo="+advRepNo,
		async: false, //同步
		success: function(data){
			$('#repnoflag',window.parent.document).val(data); //给父界面元素赋值
		}
	}); */
}
/// 添加前检查
function AppBeforeCheck(drgdgid)
{
	var quitflag = 0;
	var checkedItems = $('#medInfo').datagrid('getChecked');
    $.each(checkedItems, function(index, item){
	    if(!checkSusAndBleIfRepApp(drgdgid,item.incidesc)){
		    quitflag = 1;
		    return false;
		}
    })
    if(quitflag==1){return false;}
    return true;
}
//编辑窗体
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
	
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.repmanage.csp?RepID='+advdrID+'&RepType='+AdvdrReportType+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
}

/// 判断怀疑和并用药品是否重复添加
function checkSusAndBleIfRepApp(drgdgid,phcdesc)
{
	var quitflag = 0; message = "";
	
	/// 1、怀疑
	var suspItems = $('#susdrgdg').datagrid('getRows');
	$.each(suspItems, function(index, item){

		if(item.incidesc!=""){
			if(item.incidesc == phcdesc){
				if(drgdgid == "susdrgdg"){
					message = "该药品已添加,不能重复添加！";
				}else{
					message = "该药品已为怀疑药品,不可同时为并用药品！";
				}
				$.messager.alert("提示:",message);
				quitflag=1;
				return false;
			}
		}
	})
	if(quitflag==1){return false;}
	
	/// 2、并用
	var suspItems = $('#blenddg').datagrid('getRows');
	$.each(suspItems, function(index, item){

		if(item.incidesc!=""){
			if(item.incidesc == phcdesc){
				if(drgdgid == "blenddg"){
					message = "该药品已添加,不能重复添加！";
				}else{
					message = "该药品已为并用药品,不可同时为怀疑药品！";
				}
				$.messager.alert("提示:",message);
				quitflag=1;
				return false;
			}
		}
	})
	if(quitflag==1){return false;}
	
	return true;
} 
