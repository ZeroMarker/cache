/// Creator: bianshuai
/// CreateDate: 2014-10-31
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;">药品列表<span style="color:red;">[双击行即可编辑]</span></span>';
//var patSexArr = [{ "val": "1", "text": "男" }, { "val": "2", "text": "女" },{ "val": "3", "text": "不详" }]
var patientID="",EpisodeID="",dqEvtRepID="";
var editRow="";
$(function(){
	patientID=getParam("PatientID");
	EpisodeID=getParam("EpisodeID");
	dqEvtRepID=getParam("dqEvtRepID");
	curStatus=getParam("curstatus"); //liyarong 2016-09-26
	if ((EpisodeID == "")&&(dqEvtRepID == "")){//lbb 2018-09-13
    var frm = dhcsys_getmenuform();
    if (frm) {
        var adm = frm.EpisodeID.value;
        EpisodeID = adm;
       InitPatientInfo(EpisodeID);
       }
    }

	//设置界面复选框
/*	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).toggleClass('cb_active');
			setCheckBoxRelation(this.id);
		});
	});
*/	
	//设置界面复选框分组
/*	var tmpid="";  //qunianpeng  2016-07-26
	$("input[type=checkbox]").click(function(){
		tmpid=this.id;
		if($('#'+tmpid).hasClass('cb_active')){
			$("input[type=checkbox][name="+this.name+"]").each(function(){
				if((this.id!=tmpid)&($(this).hasClass('cb_active'))){
					$(this).toggleClass('cb_active');
					$('#'+this.id).removeAttr("checked");	// qunianpeng 2016-07-25
					setCheckBoxRelation(this.id);
				}
			})
		}
	});
*/
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
				setCheckBoxRelation(this.id);	
			}			
			setCheckBoxRelation(this.id);
		});	
		
	//定义columns
	var columns=[[
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
	    {field:'incidesc',title:'商品名称',width:200,align:'left'},
	    {field:'genenic',title:'通用名',width:160,align:'left'},
	    {field:'genenicdr',title:'genenicdr',width:80,hidden:true},
	    {field:'vendor',title:'供应商',width:200,align:'left',editor:texteditor},
	    {field:'manf',title:'生产企业',width:100,align:'left'},
	    {field:'batexp',title:'批号~效期',width:100,align:'left',editor:texteditor},
	    {field:'manfdr',title:'manfdr',width:80,hidden:true},
	    {field:'qty',title:'数量',width:60,align:'left',editor:texteditor},
	    {field:'form',title:'剂型',width:80,align:'left'},
	    {field:'formdr',title:'formdr',width:80,hidden:true},
	    {field:'spec',title:'规格',width:80,align:'left'},
	    {field:'packtype',title:'包装类型',width:80,align:'left',editor:texteditor},
		{field:'operation',title:'<a href="#" onclick="patOeInfoWindow()"><img style="margin-left:3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>',width:30,align:'center',
			formatter:SetCellUrl}
	]];
	
	//定义datagrid
	$('#susdrgdg').datagrid({
		title:titleNotes,    
		url:'',
		fit:true, //药品数量大于4,生成滚动条  duwensheng  2016-09-05
		border:false,
		columns:columns,
		singleSelect:true,
		rownumbers:true,//行号 
 		remoteSort:false,			//界面排序
		fitColumns:true,    //quninapeng 2016-09-10 自适应大小，防止横向滑动
		loadMsg: '正在加载信息...',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow.toString() != "") {
               $("#susdrgdg").datagrid('endEdit', editRow); 
            } 
            $("#susdrgdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	InitdatagridRow();
	
	$('#adddrg').bind('click',addSuspectDrg); //添加药品
	$('#cancel').bind('click',closeWin);  //取消
	
	//性别
	/*$('#PatSex').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:patSexArr
	});*/
	//hezg 2018-7-2
	var LINK_CSP="dhcapp.broker.csp"
	var uniturl = LINK_CSP+"?ClassName=web.DHCSTPHCMCOMMON&MethodName=";
	var url = uniturl+"jsonCTSex";
	new ListCombobox("PatSex",url,'',{panelHeight:"auto"}).init();

	InitPatientInfo(EpisodeID); //获取病人信息
	
	//报表ID不为空的情况下,加载已存在报表信息
	if(dqEvtRepID!=""){
		LoadDrgQuaEvtReport(dqEvtRepID);
		if(curStatus=="提交"){           //liyarong 2016-0923
		 $("a:contains('提交')").linkbutton('disable');
	     $("a:contains('保存')").linkbutton('disable');
		 	}
	}
	
	$('input').live('click',function(){
		$("#susdrgdg").datagrid('endEdit', editRow);
	});
})

// 文本编辑格
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

// 插入新行
function insertRow()
{
	$('#susdrgdg').datagrid('appendRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		row: {orditm:'',phcdf:'',incidesc:'',genenic:'',genenicdr:'',manf:'',manfdr:'',form:'',formdr:'',spec:'',packtype:''}
	});
}

// 删除行
function deleteRow(rowIndex)
{
	//行对象
    var rowobj={orditm:'',phcdf:'',incidesc:'',genenic:'',genenicdr:'',manf:'',manfdr:'',form:'',formdr:'',spec:'',packtype:'',vendor:'',batexp:'',qty:''};
	//当前行数大于4,则删除，否则清空
	var rows = $('#susdrgdg').datagrid('getRows');

	if(rows.length>4){
		 $('#susdrgdg').datagrid('deleteRow',rowIndex);
	}else{
		$('#susdrgdg').datagrid('updateRow',{
			index: rowIndex, // 行索引
			row: rowobj
		});
	}

	// 删除后,重新排序    quninapeng 2016-09-10 
	$('#susdrgdg').datagrid('sort', {	        
		sortName: 'incidesc',
		sortOrder: 'desc'
	});
}

/// 链接
function SetCellUrl(value, rowData, rowIndex)
{	
	return "<a href='#' onclick='deleteRow("+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}
//初始化列表使用
function InitdatagridRow()
{
	for(var k=0;k<4;k++)
	{
		$("#susdrgdg").datagrid('insertRow',{
			index: 0, 
			row: {orditm:'',phcdf:'',incidesc:'',genenic:'',genenicdr:'',manf:'',manfdr:'',form:'',formdr:'',spec:'',packtype:''}
		});
	}
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
		height:520,
		minimizable:false,					/// 隐藏最小化按钮
		maximized:true						/// 最大化(qunianpeng 2018/5/2)
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
		{field:'priorty',title:'优先级',width:80},
		{field:'StartDate',title:'开始日期',width:80},
		{field:'EndDate',title:'结束日期',width:80},
		{field:'incidesc',title:'名称',width:280},
		{field:'genenic',title:'通用名',width:160},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:'剂量',width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'用法',width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:'频次',width:40},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:'疗程',width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:'批准文号',width:80},
		{field:'manf',title:'厂家',width:80},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:'剂型',width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true},
		{field:'spec',title:'规格',width:80},
		{field:'Vendor',title:'Vendor',width:80,hidden:true},
		{field:'BatExpStr',title:'BatExpStr',width:80,hidden:true},
		{field:'qty',title:'qty',width:80,hidden:true}

	]];
	
	//定义datagrid
	$('#medInfo').datagrid({
		url:'',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
                pageNumber:1,  //页面打开显示第一页  duwensheng  2016-09-05
		pageSize:15,  // 每页显示的记录条数
		pageList:[15,30,45],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		rowStyler:function(index,row){
			if (row.EndDate!=""){
				return 'background-color:pink;';
			}
		}
	});
	
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID}
	});
var thisrows=$('#medInfo').datagrid("getRows").length;    //wangxuejian 2016-08-31
			if (thisrows<=0){
				$('#medInfo').datagrid('loadData',{total:0,rows:[]});
			}
}

//添加怀疑药品
function addSuspectDrg()
{
	//用药列表
	var rows = $('#susdrgdg').datagrid('getRows');
	var k=0;
	for(var i=0;i<rows.length;i++)
	{
	if(rows[i].orditm!=""){
	k=k+1;}
	}
	//不选提示 duwensheng 2016-09-12
	var checkedItems = $('#medInfo').datagrid('getChecked');
	if(checkedItems==""){
	 $.messager.alert("提示:","请先选择药品！");
	 return;
	}
		 $.each(checkedItems, function(index, item){
		 var rowobj={
	orditm:item.orditm, phcdf:item.phcdf, incidesc:item.incidesc, genenic:item.genenic,
		genenicdr:item.genenicdr, form:item.form,
		manf:item.manf, manfdr:item.manfdr, formdr:item.formdr,spec:item.spec,vendor:item.Vendor,
		batexp:item.BatExpStr,qty:item.qty
	}
	//列表已存在数据的话,提示并退出
	//duwensheng 2016-09-12
	for(var j=0;j<rows.length;j++){
	if(item.incidesc==rows[j].incidesc){
	//alert("药品列表已存在'"+rows[j].incidesc+"',添加失败!");
	return;
	}
	}
	if(k>3){
	$("#susdrgdg").datagrid('appendRow',rowobj);
	}else{
	$("#susdrgdg").datagrid('updateRow',{ //在指定行添加数据，appendRow是在最后一行添加数据
	index: k, // 行数从0开始计算
	row: rowobj
	});
	}
	k=k+1;
		 })
		$('#mwin').window('close');
    }
    
 //关闭窗口
function closeWin()
{
	$('#mwin').window('close');
}

///加载病人用药列表
///再点击按钮的时候为参数赋值，这个值为优先级代码，如'S',长期医嘱
function LoadPatMedInfo(priCode)
{
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID, 
			PriCode:priCode} //优先级筛选 duwensheng 2016-09-05
	});
}

//保存药品质量事件报告
function saveDrgQEvtRep(flag)
{
	if ((editRow != "")||(editRow == 0)){
		$("#susdrgdg").datagrid('endEdit', editRow); 
	}
	if((flag)&&(!saveBeforeCheck())){   //liyarong 2016-09-29
		return;
	}
	//1、报告科室/部门
	var RepLoc=$('#RepLocID').val();
	//2、报告时间
	var RepDate=$('#RepDate').datebox('getValue');
	var RepCode=$('#RepCode').val();  //编码
	
	//3、患者信息
	var PatID=$('#PatID').val(); //病人ID
	var PatName=$('#PatName').val(); //患者姓名
	var PatSex=$('#PatSex').combobox('getValue');;  //性别
	var PatAge=$('#PatAge').val();  //年龄
	var PatDOB=$('#PatDOB').datebox('getValue');  //出生日期
	var PatMedNo=$('#PatMedNo').val(); //病历号/门诊号
	
	//就诊科室
	var AdmLocDr=$('#AdmLocID').val();
	
	//事件发生时间
	var EvtOccDate=$('#EvtOccDate').datebox('getValue');
	
	//事件发现时间
	var DisEvtDate=$('#DisEvtDate').datebox('getValue');
	
	
		///1、事件分级
	var ErrLevel="";
    	$("input[type=checkbox][name=ErrorLevel]").each(function(){ //qunianpeng 2016-07-26
	    if($(this).is(':checked')){
			ErrLevel=this.id;
		}
	})
	
	
		///2、事件发生地点
	var EvtOccLoc="",EvtOccLocDesc="",EvtOccLocId="";
    $("input[type=checkbox][name=EvtOccLoc]").each(function(){
	     if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
		  EvtOccLocId=this.id;
		  EvtOccLoc=$("#"+this.id).val();   
		}
	})
	
	//其他-取其描述
	if(EvtOccLocId=="EOL99"){
		var EvtOccLocDesc=$('#EvtOccLocDesc').val();
	}
		///4、是否能够提供药品标签、处方复印件等资料
	var RelateInfo="",RelateInfoDesc="";
    $("input[type=checkbox][name=RelateInfo]").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
		  RelateInfo=$("#"+this.id).val();
		}
	})
	
	RelateInfoDesc=$('#EvtRelaDesc').val();
		///5、事件发生经过
	var GeneProc=$('#dqEvtProc').val();
	
	
	//7、事件处理情况
	var HandleInfo=$('#dqEvtHandleInfo').val();
	
	//是否死亡[直接死因]、时间
	var Death="N",ImCauseOfDeath="",DeathTime="";
	var dgEvtDDate="",dgEvtDTime="";
	if($('#death').is(':checked')){
		Death="Y"; //死亡标志
		ImCauseOfDeath=$('#facOfdeath').val(); //直接死因
		//$("#deathdate").datetimebox({disabled:false});  //zhaowuqiang
		dgEvtDeathDate=$('#deathdate').datetimebox('getValue'); //死亡日期
		//死亡日期 时间
		if(dgEvtDeathDate!=""){
			dgEvtDDate=dgEvtDeathDate.split(" ")[0];
			dgEvtDTime=dgEvtDeathDate.split(" ")[1];
		}
		else{
			window.alert("死亡时间不能为空，请选择死亡时间!!!");
			return ;
		}
	}
	
	//恢复过程
	var RecProc="";
    $("input[type=checkbox][name=RecProc]").each(function(){
	    if($(this).is(':checked')){
	    //if($(this).hasClass('cb_active')){
			RecProc=$("#"+this.id).val();
		}
	})
	
	//伤害程度
	var HarmLevel="";HarmDesc="";
    $("input[type=checkbox][name=HarmLevel]").each(function(){
	    if($(this).is(':checked')){ 
		//if($(this).hasClass('cb_active')){
		HarmLevel=$("#"+this.id).val();
		}
	})
	if (HarmLevel>10){
		var HarmDesc=$('#HarmDesc'+HarmLevel).val();
	}

	//住院时间是否延长
	var ExtHospTime="N";
	if($('#dgExtHospTime').is(':checked')){
	//if($('#dgExtHospTime').hasClass('cb_active')){
		ExtHospTime="Y";
	}
	
	//是否生命垂危
	var CriticallyIll="N";
	if($('#CriticallyIll').is(':checked')){
	//if($('#CriticallyIll').hasClass('cb_active')){
		CriticallyIll="Y";
	}
	var CriIllReport=$('#CriIllReport').val();;
	
	
	//9、改进措施
	var ImproMeasure=$('#dqEvtImproMeasure').val();
	
	//10、报告人信息
	var RepUser=$('#RepUserID').val();
	
	//11、科室部门负责人
	var PriOfDept=$('#PriOfDept').val();
	
	var dqEvtRepList=RepLoc+"^"+RepDate+"^"+PatID+"^"+PatName+"^"+PatSex+"^"+PatAge+"^"+PatDOB+"^"+PatMedNo+"^"+AdmLocDr+"^"+EvtOccDate;
		dqEvtRepList=dqEvtRepList+"^"+DisEvtDate+"^"+ErrLevel+"^"+EvtOccLoc+"^"+EvtOccLocDesc+"^"+RelateInfo+"^"+RelateInfoDesc+"^"+Death;
		dqEvtRepList=dqEvtRepList+"^"+ImCauseOfDeath+"^"+dgEvtDDate+"^"+dgEvtDTime+"^"+RecProc+"^"+HarmLevel+"^"+HarmDesc+"^"+ExtHospTime+"^"+CriticallyIll;
		dqEvtRepList=dqEvtRepList+"^"+CriIllReport+"^"+GeneProc+"^"+HandleInfo+"^"+ImproMeasure+"^"+RepUser+"^"+PriOfDept+"^"+RepCode;
	
	//12、药品
	var tmpItmArr=[],phcItmStr="";
	//怀疑药品

	var suspItems = $('#susdrgdg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm+"^"+item.phcdf+"^"+trSpecialSymbol(item.incidesc)+"^"+item.genenicdr+"^"+
		    item.formdr+"^"+item.manfdr+"^"+trSpecialSymbol(item.spec)+"^"+trsUndefinedToEmpty(item.packtype)+"^"+
		    trsUndefinedToEmpty(item.vendor)+"^"+trsUndefinedToEmpty(item.batexp)+"^"+trsUndefinedToEmpty(item.qty);
		    tmpItmArr.push(tmp);
		}
	})
	
	dqEvtRepDrgItmList=tmpItmArr.join("!!");

	//13、诱发因素
	var dqEvtRepTriFacList=[];
	//自身缺陷
	if($("#DR10").is(':checked')){
    //if($("#DR10").hasClass('cb_active')){
		dqEvtRepTriFacList.push("10");
	}; 
	//贮存不当
	if($("#DR11").is(':checked')){
    //if($("#DR11").hasClass('cb_active')){
	    dqEvtRepTriFacList.push("11");
	};
	//配伍禁忌 
	if($("#DR12").is(':checked')){
   // if($("#DR12").hasClass('cb_active')){
		dqEvtRepTriFacList.push("12");
	};
	//使用方法不当
	if($("#DR13").is(':checked')){
   // if($("#DR13").hasClass('cb_active')){
		dqEvtRepTriFacList.push("13");
	};
	//其他
	if($("#DR99").is(':checked')){
   // if($("#DR99").hasClass('cb_active')){
	    dqEvtRepTriFacList.push("99"+"^"+$('#DRdesc').val());
	};
	dqEvtRepTriFacList=dqEvtRepTriFacList.join("||");
	
	var dqEvtRepID=$('#dqEvtRepID').val(); //报表ID
      if(flag==0){
	   var CurStatusDr="N";
	   var dqEvtRepList=dqEvtRepList+"^"+CurStatusDr;
	   }else if(flag==1){
	    var CurStatusDr="Y";
	     var dqEvtRepList=dqEvtRepList+"^"+CurStatusDr;
	   } 
	//保存
    $.ajax({
   	   type: "POST",
       url: url,
       data: "action=saveDrgQEvtReport&dqEvtRepID="+dqEvtRepID+"&dqEvtRepList="+dqEvtRepList+"&dqEvtRepDrgItmList="+dqEvtRepDrgItmList+"&dqEvtRepTriFacList="+dqEvtRepTriFacList,
        success: function(jsonString){
		   var dqEvtObj = jQuery.parseJSON(jsonString);   //liyarong 2016-09-28	
	      if(dqEvtObj.ErrCode==0){	//liyarong 2016-09-28
	         if(flag==1){
				   $.messager.alert("提示:","提交成功！");	 //liyarong 2016-10-09	
				   $("a:contains('提交')").linkbutton('disable');
				   $("a:contains('保存')").linkbutton('disable');
	
		     }else if(flag==0){
			      $.messager.alert("提示:","保存成功！");
			   }
	      }else{
		      if(flag==1){
			         $.messager.alert("提示:","提交失败！");
			      }else if(flag==0){
				     $.messager.alert("提示:","保存失败！");
			      }
		     
		  }
	      LoadDrgQuaEvtReport(dqEvtObj.dqEvtRepID);   //重新加载  liyarong 2016-09-28
	        parent.Query();                 //liyarong 2016-09-28
       },
       error: function(){
	       alert('链接出错');
	       return;
	   }
    });
}

//替换特殊符号 2014-07-25 bianshuai
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

//加载报表默认信息
function InitPatientInfo(EpisodeID)
{
   if(EpisodeID==""){return;}
   
   $.ajax({
   type: "POST",
   url: url,
   data: "action=getRepPatInfo&AdmDr="+EpisodeID+"&LocID="+LgCtLocID,
   //dataType: "json",
   success: function(val){
		var tmp=val.split("^");
		//病人信息
		$('#PatID').val(tmp[0]); //病人ID
		$('#PatName').val(tmp[2]); //患者姓名
		//$('#PatName').attr("disabled","true");
		//$('#PatSex').combobox({disabled:true});
		$('#PatSex').combobox('setValue',tmp[3]);  //性别
		$('#PatAge').val(tmp[5]);  //年龄
		//$('#PatAge').attr("disabled","true");
		//$('#PatDOB').datebox({disabled:'true'});
		$('#PatDOB').datebox("setValue",tmp[6]);  //出生日期
		$('#PatMedNo').val(tmp[8]); //病历号
		//$('#PatMedNo').attr("disabled","true");
		$('#PatContact').val(tmp[10]); //联系方式
		$('#Hospital').val(tmp[11]);
		$('#AdmLoc').val(tmp[13]); //就诊科室
		//$('#AdmLoc').attr("disabled","true");
		$('#AdmLocID').val(tmp[14]);
		//$('#RepDate').datebox({disabled:'true'});
		$('#RepDate').datebox("setValue",tmp[15]); //报告日期
		$('#EvtOccDate').datebox("setValue",tmp[15]);  //事件发生日期,默认当天
		$('#DisEvtDate').datebox("setValue",tmp[15]);  //事件发现日期,默认当天
		//$('#RepLoc').combobox('setValue',session['LOGON.CTLOCID']);  //报告科室,默认当前登录科室
		
		$('#RepUserID').val(LgUserID);
		$('#RepUser').val(LgUserName);  //报告人,默认当前登录人
		//$('#RepUser').attr("disabled","true");
		
		$('#RepLocID').val(LgCtLocID);
		$('#RepLoc').val(tmp[19]);   //报告科室,默认当前登录科室
		//$('#RepLoc').attr("disabled","true");
		
		//$('#RepCode').val(tmp[20]);    //编码  qunianpeng 2016-09-23
   }})
}

//加载报表信息
function LoadDrgQuaEvtReport(dqEvtRepID)
{	
	if(dqEvtRepID==""){return;}
	var dqEvtRepDataList="";
	//获取报表信息
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getDQEvtRepInfo&dgEvtRepID="+dqEvtRepID,
       //dataType: "json",
       success: function(val){
			dqEvtRepDataList=val;
			var tmp=dqEvtRepDataList.split("!");

			$('#dqEvtRepID').val(tmp[0]); //报表ID
			//$('#RepLoc').attr("disabled","true");
			$('#RepLocID').val(tmp[1]);    //报告科室/部门
			$('#RepLoc').val(tmp[2]);      //报告科室/部门
			//$('#RepDate').datebox({disabled:'true'});
			$('#RepDate').datebox("setValue",tmp[3]); //报告日期

			//病人信息
			$('#PatID').val(tmp[4]);   //病人ID
			EpisodeID=tmp[5];
			$('#PatName').val(tmp[6]); //患者姓名
			//$('#PatName').attr("disabled","true");
			//$('#PatSex').combobox({disabled:true});
			$('#PatSex').combobox('setValue',tmp[7]);  //性别
			$('#PatAge').val(tmp[8]);                  //年龄
			//$('#PatAge').attr("disabled","true");
			//$('#PatDOB').datebox({disabled:'true'});
			$('#PatDOB').datebox("setValue",tmp[9]);  //出生日期
			$('#PatMedNo').val(tmp[10]);              //病历号
			//$('#PatMedNo').attr("disabled","true");
			$('#AdmLocID').val(tmp[11]);
			$('#AdmLoc').val(tmp[12]);                //就诊科室
			//$('#AdmLoc').attr("disabled","true");
			
			$('#EvtOccDate').datebox("setValue",tmp[13]);  //事件发生日期
			$('#DisEvtDate').datebox("setValue",tmp[14]);  //事件发现日期

			//事件分级
			$('#'+tmp[15]).toggleClass('cb_active').attr("checked",'checked');

			//事件发生地
			$('#EOL'+tmp[16]).toggleClass('cb_active').attr("checked",'checked');
			$('#EvtOccLocDesc').val(tmp[17]);
			if(tmp[16]=="99"){
				$('#EvtOccLocDesc').attr("disabled",false);
			}

			//是否可提供相关资料
			$('#ER'+tmp[18]).toggleClass('cb_active').attr("checked",'checked');
			$('#EvtRelaDesc').val(tmp[19]);
			if(+tmp[18]=="99"){
				$('#EvtRelaDesc').attr("disabled",false);
			} 

			//是否死亡
			if(tmp[20]=="Y"){
				$('#death').toggleClass('cb_active').attr("checked",'checked');
				$('#facOfdeath').val(tmp[21]);
				$('#facOfdeath').attr("disabled",false);
				$('#deathdate').datetimebox("setValue",tmp[22]);
			}
			
			//恢复过程
				$('#RP'+tmp[23]).toggleClass('cb_active').attr("checked",'checked');
			
			//伤害级别
				$('#HL'+tmp[24]).toggleClass('cb_active').attr("checked",'checked');
			$('#HarmDesc'+tmp[24]).val(tmp[25]);
			///永久性伤害(部位、程度)
			if(tmp[24]=="12"){
				$('#HarmDesc12').attr("disabled",false);
			}
			///暂时伤害(部位、程度)
			if(tmp[24]=="11"){
				$('#HarmDesc11').attr("disabled",false);
			}
			
			//住院时间延长
			if(tmp[26]=="Y"){
					$('#dgExtHospTime').toggleClass('cb_active').attr("checked",'checked');
			}
			
			//生命垂危，需抢救
			if(tmp[27]=="Y"){
				$('#CriticallyIll').toggleClass('cb_active').attr("checked",'checked');
				$('#CriIllReport').val(tmp[28]);
				$('#CriIllReport').attr("disabled",false);
			}

			//事件发生经过
			$('#dqEvtProc').val(tmp[29]);

			//事件处理情况
			$('#dqEvtHandleInfo').val(tmp[30]);

			//改进措施
			$('#dqEvtImproMeasure').val(tmp[31]);

			$('#RepUser').val(tmp[33]);  //报告人
			$('#RepUserID').val(tmp[32]);
			$('#PriOfDept').val(tmp[34]);  //科室(部门)负责人
			$('#RepCode').val(tmp[35]);    //编码
			
			//诱发因素
			var dqEvtTriFacStr=tmp[36];
			dqEvtTriFacArr=dqEvtTriFacStr.split("||");
			for(var k=0;k<dqEvtTriFacArr.length;k++){
				var tmpstr=dqEvtTriFacArr[k].split("^");
				$('#DR'+tmpstr[0]).toggleClass('cb_active').attr("checked",'checked');
				if(tmpstr[0]=="99"){
					$('#DRdesc').val(tmpstr[1]);
					$('#DRdesc').attr("disabled",false);
				}
			}
       },
       error: function(){
	       alert('链接出错');
	       return;
	   }
    });
    
    //加载药品列表
	$('#susdrgdg').datagrid({
		url:url+'?action=getDQEvtRepDrgItm&dgEvtRepID='+dqEvtRepID,	
		queryParams:{
			params:10
		}
	});
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
function saveBeforeCheck()   //liyarong 2016-09-29
{
		///1、事件分级
	var ErrorLevel=""; 
	$("input[type=checkbox][name=ErrorLevel]").each(function(){ //qunianpeng 2016-07-26
		if($(this).is(':checked')){
	//	if($(this).hasClass('cb_active')){ //qunianpeng 2016-07-26
			ErrorLevel=this.val;
		}
	})
	if(ErrorLevel==""){
		$.messager.alert("提示:","【事件分级】不能为空！");
		return false;
	}
	
	///2、事件发生地点
	var EvtOccLoc="",EvtOccLocDesc="",EvtOccLocId="";
    $("input[type=checkbox][name=EvtOccLoc]").each(function(){
	     if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
		  EvtOccLocId=this.id;
		  EvtOccLoc=$("#"+this.id).val();   
		}
	})
	if(EvtOccLoc==""){
		$.messager.alert("提示:","事件发生地不能为空！");
		return false;
	}
	
	///3、药品列表
	///药品列表结束编辑状态
	$("#susdrgdg").datagrid('endEdit', editRow);
	var tmpItmArr = [];
	var suspItems = $('#susdrgdg').datagrid('getRows');
		$.each(suspItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm+"^"+item.phcdf+"^"+trSpecialSymbol(item.incidesc)+"^"+item.genenicdr+"^"+
		    item.formdr+"^"+item.manfdr+"^"+trSpecialSymbol(item.spec)+"^"+trsUndefinedToEmpty(item.packtype)+"^"+
		    trsUndefinedToEmpty(item.vendor)+"^"+trsUndefinedToEmpty(item.batexp)+"^"+trsUndefinedToEmpty(item.qty);
		    tmpItmArr.push(tmp);
		}
	})
	if(tmpItmArr==""){
		$.messager.alert("提示:","【药品列表】不能为空！");
		return false;
		}

   ///4、是否能够提供药品标签、处方复印件等资料
	var RelateInfo="",RelateInfoDesc="";
	 $("input[type=checkbox][name=RelateInfo]").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
		  RelateInfo=$("#"+this.id).val();
		}
	})
		if(RelateInfo==""){
		$.messager.alert("提示:","能否提供相关资料不能为空！");
		return false;
	    
	}
	 RelateInfoDesc=$('#EvtRelaDesc').val();
	///5、事件发生经过
	var GeneProc=$('#dqEvtProc').val();
	if($('#dqEvtProc').val()==""){
		$.messager.alert("提示:","【事件发生经过】不能为空！");
		return false;
	}

	 ///6、引发事件的因素
	var dqEvtRepTriFacList=[];
	//自身缺陷
	if($("#DR10").is(':checked')){
    //if($("#DR10").hasClass('cb_active')){
		dqEvtRepTriFacList.push("10");
	}; 
	//贮存不当
	if($("#DR11").is(':checked')){
    //if($("#DR11").hasClass('cb_active')){
	    dqEvtRepTriFacList.push("11");
	};
	//配伍禁忌 
	if($("#DR12").is(':checked')){
    //if($("#DR12").hasClass('cb_active')){
		dqEvtRepTriFacList.push("12");
	};
	//使用方法不当
	if($("#DR13").is(':checked')){
    //if($("#DR13").hasClass('cb_active')){
		dqEvtRepTriFacList.push("13");
	};
	//其他
	if($("#DR99").is(':checked')){
    //if($("#DR99").hasClass('cb_active')){
	    dqEvtRepTriFacList.push("99"+"^"+$('#DRdesc').val());
	};
	dqEvtRepTriFacList=dqEvtRepTriFacList.join("||");
	if(dqEvtRepTriFacList==""){
		$.messager.alert("提示:","【引发事件因素】不能为空！");
		return false;
	};
		//7、事件处理情况
	var HandleInfo=$('#dqEvtHandleInfo').val();
	if($('#dqEvtHandleInfo').val()==""){
		$.messager.alert("提示:","【事件处理情况】不能为空！");
		return false;
	}
		//8、科室部门负责人
	var PriOfDept=$('#PriOfDept').val();
	if(PriOfDept==""){
		$.messager.alert("提示:","科室(部门)负责人不能为空！");
		return false;
		}
      return true ;
}

//页面关联设置
function setCheckBoxRelation(id){
//	if($('#'+id).hasClass('cb_active')){
	if($('#'+id).is(':checked')){  // qunianpeng 2016-07-26
		///引发事件因素
		if(id=="DR99"){
			$('#DRdesc').attr("disabled",false);
		}		
		///永久性伤害(部位、程度)
		if(id=="HL12"){
			$('#HarmDesc12').attr("disabled",false);
		}
		///暂时伤害(部位、程度)
		if(id=="HL11"){
			$('#HarmDesc11').attr("disabled",false);
			//$('#adrrEventRDRDate').datebox({disabled:false});
		}
	    ///生命垂危，需抢救(报告)
		if(id=="CriticallyIll"){
			$('#CriIllReport').attr("disabled",false);
		}    
		///死亡(直接死因)
		if(id=="death"){
			$('#facOfdeath').attr("disabled",false);
			$("#deathdate").datetimebox({disabled:false});  //zhaowuqiang
		}
		///是否能够提供药品标签、</br>处方复印件等资料
		if(id=="ER99"){
			$('#EvtRelaDesc').attr("disabled",false);
		}
		///事件发生地点
		if(id=="EOL99"){
			$('#EvtOccLocDesc').attr("disabled",false);
		}
	}else{
		///引发事件因素
		if(id=="DR99"){
			$('#DRdesc').val("");
			$('#DRdesc').attr("disabled","true");
		}
		///永久性伤害(部位、程度)
		if(id=="HL12"){
			$('#HarmDesc12').val("");
			$('#HarmDesc12').attr("disabled","true");
		}	
		///暂时伤害(部位、程度)
		if(id=="HL11"){
			$('#HarmDesc11').val("");
			$('#HarmDesc11').attr("disabled","true");
		}    
	    ///生命垂危，需抢救(报告)
		if(id=="CriticallyIll"){
			$('#CriIllReport').val("");
			$('#CriIllReport').attr("disabled","true");
		}
		///死亡(直接死因)
		if(id=="death"){
			$('#facOfdeath').val("");
			$('#facOfdeath').attr("disabled","true");
			$("#deathdate").datetimebox({disabled:true});  //zhaowuqiang
		}
		///是否能够提供药品标签、</br>处方复印件等资料
		if(id=="ER99"){
			$('#EvtRelaDesc').val("");
			$('#EvtRelaDesc').attr("disabled","true");
		}
		///事件发生地点
		if(id=="EOL99"){
			$('#EvtOccLocDesc').val("");
			$('#EvtOccLocDesc').attr("disabled","false");
		}
	}
}
