
/// Creator: congyue
/// CreateDate: 2016-01-13
var titleOpNotes='<span style="font-weight:bold;font-size:10pt;font-family:华文楷体;color:red;">[双击行删除]</span>';

var url="dhcadv.repaction.csp";
var patSexArr = [{ "val": "1", "text": "男" }, { "val": "2", "text": "女" },{ "val": "3", "text": "不详" }];
var editRow="";CurRepCode="blood";
var bldrptID="";patientID="";EpisodeID="";editFlag="";adrDataList="",assessID="";
var BldrptInitStatDR="";bldrptCurStatusDR="";bldrptReportType="";
var medadrNextLoc="";medadrLocAdvice="";medadrReceive=""; 
var LocDr="";UserDr="";ImpFlag="", patIDlog=""; 
var typeArray= [{"value":"A","text":'患者体征'}, {"value":"B","text":'临床症状'}];
var typeBldBasA="A";typeBldBasB="B";
var patTypeArr= [{"val":"1","text":'红细胞悬液'}, {"val":"2","text":'冰冻血浆'}, {"val":"3","text":'机采血小板'}];
var frmflag=0; //是否获取病人列表标志 0 获取，1 不获取
var winflag=0; //窗口标志 0 填报窗口  1 修改窗口 2016-10-10
document.write('<script type="text/javascript" src="../scripts/dhcadvEvt/cmcommon.js"></script>');
$(function(){
	patientID=getParam("patientID");
	EpisodeID=getParam("EpisodeID");
	bldrptID=getParam("bldrptID");
	editFlag=getParam("editFlag");
	adrDataList=getParam("adrDataList");
	satatusButton=getParam("satatusButton");
    frmflag=getParam("frmflag"); //2016-09-28
    assessID=getParam("assessID"); //评估id
	if ((adrDataList=="")&&(bldrptID=="")&&(frmflag==0)){
	    var frm = dhcsys_getmenuform();
		if (frm) {
			var papmi = frm.PatientID.value;		
	        var adm = frm.EpisodeID.value;
	        $.ajax({
		   	   type: "POST",
		       url: url,
		       async: false, //同步
		       data: "action=getPatNo&patID="+papmi,
		       success: function(val){
			      	 papmi=val;
		       }
		    });
	        //var papmi=getRegNo(papmi);
	        EpisodeID=adm;
	        getBldrptPatInfo(papmi,adm);//获取病人信息
	        if((papmi!="")&(adm!="")){
				$('#PatID').attr("disabled","true");  ///2017-07-20 bianshuai 设置病人ID不可编辑
	        }
		}
	}
    //判断按钮是否隐藏
	if (satatusButton==1) {
	  $("#buttondiv").hide();
	}
	   // 文本编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
	    required: true //设置编辑规则属性
		}
	}
	
	//定义cols
	var cols=[[
		{field:'bldid',title:'输血类别id',width:90,hidden:true},
		{field:'bldtype',title:'血液类别',width:170},
		{field:'bldone',title:'输血编号1',width:170,editor:texteditor},
	    {field:'bldtwo',title:'输血编号2',width:170,editor:texteditor},
	    {field:'bldthree',title:'输血编号3',width:170,editor:texteditor},
		{field:'bldfour',title:'输血编号4',width:170,editor:texteditor},
		
	]];
	//定义datagrid
	$('#bldBldTypedg').datagrid({  
		title:'输血信息'+titleOpNotes,  
		url:'',
		border:false,
		fitColumns:true, //自动展开/收缩列的大小
		//pagination:true,
		columns:cols,
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		//pagination:true,
		height:200,
		onDblClickRow:function(rowIndex, rowData){
			 $('#bldBldTypedg').datagrid('deleteRow',rowIndex);
		},
		onClickRow:function(rowIndex, rowData){
			
		//if ((editRow != "")||(editRow == "0")) { 
		     //$("#bldBldTypedg").datagrid('endEdit', editRow);
	      //}
			 $('#bldBldTypedg').datagrid('beginEdit',rowIndex);//开启编辑并传入要编辑的行
			 editRow = rowIndex;
		}
		
		/**
		onClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) { 

                $("#bldBldTypedg").datagrid('endEdit', editRow); 
            } 
	            $("#bldBldTypedg").datagrid('beginEdit', rowIndex); 
	            editRow = rowIndex; 
        }*/


	});
	//if(bldrptID!=""){
	$('#bldBldTypedg').datagrid({
		url:url+'?action=getBldTypeInfo&params='+bldrptID
	});
	//}
	//Type类型
	var typeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:typeArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#BldB").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// 定义columns
	var columns=[[
		{field:'Select',title:'选择',width:70,formatter:
			 function SetCellUrl(value, rowData, rowIndex)
			{	
				return "<input type=\"checkbox\"  name=\"bldbox\"  value=\"" + rowData.ID + "\">";
			} 
		},
		{field:"ID",title:'ID',width:50,align:'center',hidden:true},
		{field:"Code",title:'代码',width:160,hidden:true},
		{field:'Desc',title:'描述',width:200},
		{field:'flag',title:'标志',width:160,hidden:true},
		{field:'Selectt',title:'选择',width:70,formatter:
		function SetCellUrl(value, rowData, rowIndex)
			{	
				return "<input type=\"checkbox\"  name=\"bldboxt\"  value=\"" + rowData.IDt + "\">";
			} 
		},
		{field:"IDt",title:'ID',width:50,align:'center',hidden:true},
		{field:"Codet",title:'代码',width:160,hidden:true},
		{field:'Desct',title:'描述',width:200},
		{field:'Typet',title:'类型',width:160,hidden:true},
		{field:'flagt',title:'标志',width:160,hidden:true}
	]];
	//定义datagrid
	$('#BldA').datagrid({
		title:'输血患者体征',
		url:url+'?action=QueryBldBasRpt&params='+typeBldBasA+"^"+bldrptID,
		fitColumns:true, //自动展开/收缩列的大小
		columns:columns,
		//pageSize: 40,//每页显示的记录条数，默认为10 
		//pageList: [40,80],//可以设置每页记录条数的列表
		loadMsg: '正在加载信息...',
		//pagination:true,
		checkOnSelect: false,
		selectOnCheck: false,
        onLoadSuccess:function(data){
			 if(data){
				$.each(data.rows, function(index, item){
					if(item.flag=="Y"){ 
						$("input[type=checkbox][name=bldbox]").each(function(){
							if($(this).val()==item.ID){
								//$("input[name='bldboxt']:checked")
								$(this).attr("checked",true);
							}
						})
					}
					if(item.flagt=="Y"){ 
						$("input[type=checkbox][name=bldboxt]").each(function(){
							if($(this).val()==item.IDt){
								$(this).attr("checked",true);
							}
						})
					}
				});
			}
			//sufan 2017-05-05  隐藏空行的checkbox
			if(data)
			{
				var len=$("input[type=checkbox][name=bldboxt]").length;
				for(k=0; k<len; k++)
				{
					if(data.rows[k].IDt=="")
					{
						$("input[type=checkbox][name=bldboxt]").eq(k).attr('style','display:none;');
					}
				}
			}
		}
	});
	//定义datagrid
	$('#BldB').datagrid({
		title:'输血临床症状',
		url:url+'?action=QueryBldBasRpt&params='+typeBldBasB+"^"+bldrptID,
		fitColumns:true, //自动展开/收缩列的大小
		columns:columns,
		//pageSize: 40,//每页显示的记录条数，默认为10 
        //pageList: [40,80],//可以设置每页记录条数的列表
		loadMsg: '正在加载信息...',
		//pagination:true,
		checkOnSelect: false,
		selectOnCheck: false,
        onLoadSuccess:function(data){
			 if(data){
				$.each(data.rows, function(index, item){
					if(item.flag=="Y"){ 
						$("input[type=checkbox][name=bldbox]").each(function(){
							if($(this).val()==item.ID){
								$(this).attr("checked",true);
							}
						})
					}
					if(item.flagt=="Y"){ 
						$("input[type=checkbox][name=bldboxt]").each(function(){
							if($(this).val()==item.IDt){
								$(this).attr("checked",true);
							}
						})
					}
				});
			}
			//sufan 2017-05-05  隐藏空行的checkbox
			if(data)
			{
				var len=$("input[type=checkbox][name=bldboxt]").length;
				for(k=0; k<data.rows.length; k++)
				{
					if(data.rows[k].IDt=="")
					{
						$("input[type=checkbox][name=bldboxt]").eq(len-1).attr('style','display:none;');
					}
				}
			}
		}
	});
	//判断输入的病人ID是否为数字 2016-10-10
	 $('#PatID').bind("blur",function(){
	   var	bldrptPatID=$('#PatID').val();
	   if(isNaN(bldrptPatID)){
		    $.messager.alert("提示:","请输入数字！");
	}
	})
	//病人登记号回车事件
	$('#PatID').bind('keydown',function(event){
		 if(event.keyCode == "13")    
		 {
			 var bldrptPatID=$('#PatID').val();
			 if (bldrptPatID=="")
			 {
				 	$.messager.alert("提示:","病人id不能为空！");
					return;
			 }
			 var bldrptPatID=getRegNo(bldrptPatID);
			if ((patIDlog!="")&(patIDlog!=bldrptPatID)&(bldrptID=="")){
				$.messager.confirm("提示", "信息未保存,是否继续操作", function (res) {//提示是否删除
					if (res) {
						//location.reload();
						//window.location.href="dhcadv.bloodreport.csp?adrDataList='+''"; //刷新传参adrDataList为空
						ReloadJs();//刷新传参adrDataList为空
					}else{
						$('#PatID').val(patIDlog);
					$('#admdsgrid').datagrid({
						url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+patIDlog 
					})				
					}
				})
			}
			if ((patIDlog!="")&(patIDlog!=bldrptPatID)&(bldrptID!="")){
				ReloadJs();//刷新传参adrDataList为空
			}
			 var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
			 var mycols = [[
			 	{field:'Adm',title:'Adm',width:60}, 
			 	{field:'AdmLoc',title:'就诊科室',width:220}, 
			 	{field:'AdmDate',title:'就诊日期',width:80},
			 	{field:'AdmTime',title:'就诊时间',width:80},
			 	{field:'RegNo',title:'病人id',width:80}
			 ]];
			 var mydgs = {
				 url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+bldrptPatID ,
				 columns: mycols,  //列信息
				 pagesize:10,  //一页显示记录数
				 table: '#admdsgrid', //grid ID
				 field:'Adm', //记录唯一标识
				 params:null,  // 请求字段,空为null
				 tbar:null //上工具栏,空为null
				}
			 //alert(bldrptPatID);
			 var win=new CreatMyDiv(input,$("#PatID"),"drugsfollower","650px","335px","admdsgrid",mycols,mydgs,"","",SetAdmTxtVal);	
			 win.init();
		}
	});
	
	
	//病区 2017-08-01 cy 修改 下拉框传递参数检索
	$('#bldrptWard').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		mode:'remote',  //必须设置这个属性
		onShowPanel:function(){ 
			$('#bldrptWard').combobox('reload',url+'?action=SelwardDesc')
		}
	});
	//性别
	$('#PatSex').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		editable:false,
		//data:patSexArr
		url:url+'?action=SelSex'
	});
	
	
	//输血类别
	$('#bldrptBldType').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:patTypeArr
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
	
	//当输血前预防用药为 有 时，显示隐藏的详细说明框
	 $("input[type=checkbox][name=bldrptDrugDesc]").click(function(){
		if($(this).is(':checked')){
			var bldrptDrugDesc=this.value;
			if (bldrptDrugDesc==10) {
				$("#DrugRemark").show();
				
			} else {
				$("#DrugRemark").hide();
			}  
		}
	})
	$('#BD1').click(function(){
		
		if ($(this).is(':checked')) {
			$("#DrugRemark").show();
		} else {
			$("#DrugRemark").hide();
		}   
	}); 

	//当患者转归为死亡时，显示隐藏的时间框
     $("input[type=checkbox][name=bldrptPatInfo]").click(function(){
		if($(this).is(':checked')){
			var bldrptPatInfo=this.value;
			if (bldrptPatInfo==1) {
				$("#deathdate").show();
			} else {
				$("#deathdate").hide();
			}  
		}
	})
	
 	$('#BP1').click(function(){
		if ($(this).is(':checked')) {
			$("#deathdate").show();
		} else {
			$("#deathdate").hide();
		}   
	}); 	
	
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
	
	InitBldrptReport(bldrptID);//获取报告信息
	InitPatientInfo(bldrptID,adrDataList);//获取页面默认信息
	getBldrptPatInfo(patientID,EpisodeID);//获取病人信息
	

	//editFlag状态为0,隐藏提交和暂存按钮
	if(editFlag=="0"){
		$("a:contains('提交')").css("display","none");
		$("a:contains('暂存')").css("display","none");
	}
})

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
 

//初始化列表使用
function InitdatagridRow()
{
    
	var bldrptBldType=$('#bldrptBldType').combobox('getText');//血液类别
	var bldone=$('#bldone').val();//输血编号1
	var bldtwo=$('#bldtwo').val();//输血编号2
	var bldthree=$('#bldthree').val();//输血编号3
	var bldfour=$('#bldfour').val();//输血编号4
	
		$('#bldBldTypedg').datagrid('insertRow',{
			index: 0, // 行索引
			row: {
				bldid:'', bldtype:bldrptBldType, bldone:bldone, bldtwo:bldtwo, 
			    bldthree:bldthree, bldfour:bldfour
			}
		});
}

/// 保存可疑医疗器械不良事件报告表
function saveBldrptReport(flag)
{
	 ///保存前,对页面必填项进行检查
	if((flag)&&(!saveBeforeCheck())){
		return;
	}
	if(editRow>="0"){
		
		$("#bldBldTypedg").datagrid('endEdit', editRow);
	}
	
	//1、科室
	var bldrptRepLocDr=$('#bldrptRepLocDr').val();
	bldrptRepLocDr=LocDr;
	//2、填报人（报告人签名）
	var bldrptCreator=$('#bldrptCreator').val();
	bldrptCreator=UserDr;
	//3、报告编码
	var bldrptRepNo=$('#bldrptRepNo').val();

	//4、报告日期
	var bldrptCreateDateTime=$('#bldrptCreateDateTime').datetimebox('getValue');   
	var bldrptCreateDate="",bldrptCreateTime="";
	if(bldrptCreateDateTime!=""){
		bldrptCreateDate=bldrptCreateDateTime.split(" ")[0];  //报告日期
		bldrptCreateTime=bldrptCreateDateTime.split(" ")[1];  //报告时间
	}
	//5、病人病区
	var bldrptWard=$('#bldrptWard').combobox('getValue');
	//alert(bldrptWard);
	//6、病人就诊ID
	var bldrptAdmNo=EpisodeID;  //$('#AdmNo').val();
	
	//7、病案号
	var bldrptPatNo=$('#PatNo').val();
	//8、病人ID
	var bldrptPatID=$('#PatID').val();
	if(bldrptPatID==""){
		$.messager.alert("提示:","【病人ID】不能为空！");
		return;
	}
	//9、病人姓名
	var bldrptName=$('#PatName').val();
	if(bldrptName==""){
	  $.messager.alert("提示:","请输入患者ID,选择相应就诊");
		return;
	}
	
    //10、病人性别
	var bldrptSex=$('#PatSex').combobox('getValue');
    //11、病人年龄
	var bldrptAge=$('#PatAge').val();  
	//12、病人出生日期
	var bldrptBrithDate=$('#BrithDate').datetimebox('getValue');   
	//13、身份证号
	var bldrptPatCardNo=$('#PatCardNo').val();  
	//14、孕产史
	var bldrptGestation="";
    $("input[type=checkbox][name=bldrptGestation]").each(function(){
		if($(this).is(':checked')){
			bldrptGestation=this.value;
		}
	})
	//15、继往输血史
	var bldrptBloodhis="";
    $("input[type=checkbox][name=bldrptBloodhis]").each(function(){
		if($(this).is(':checked')){
			bldrptBloodhis=this.value;
		}
	})
	//16、输血反应史
	var bldrptADVBloodhis="";
    $("input[type=checkbox][name=bldrptADVBloodhis]").each(function(){
		if($(this).is(':checked')){
			bldrptADVBloodhis=this.value;
		}
	})
	
	//17、输血前血型检查结果
	var bldrptBloodType=$('#bldrptBloodType').val();   
	var bldrptBloodAttr=$('#bldrptBloodAttr').val();  //阴阳性 
	//18、意外抗体筛查（阴阳性）	
	var bldrptAntibody=$('#bldrptAntibody').val();  //阴阳性 
	//19、本次输注的血液信息
	var bldrptCurrBloodType=$('#bldrptCurrBloodType').val();   
	var bldrptCurrBloodAttr=$('#bldrptCurrBloodAttr').val();  //阴阳性 
	//20、输注血量
	var bldrptDiscNum=$('#bldrptDiscNum').val();   
	//21、基本生命体征
	var bldrptTemp=$('#bldrptTemp').val();  //体温 
	var bldrptBloodPress=$('#bldrptBloodPress').val();  //血压 
	var bldrptSphygmus=$('#bldrptSphygmus').val();  //脉搏 
	var bldrptBreathes=$('#bldrptBreathes').val();  //呼吸频次 
	//22、输血前预防用药
	var bldrptDrugDesc="";
	var bldrptDrugRemark="";
    $("input[type=checkbox][name=bldrptDrugDesc]").each(function(){
		if($(this).is(':checked')){
			bldrptDrugDesc=this.value;
		}
	})
	bldrptDrugRemark=$('#bldrptDrugRemark').val();  // 详细说明
	
	//23、本次输血开始时间
	var bldrptStartDateTime=$('#bldrptStartDateTime').datetimebox('getValue');   
	var bldrptStartDate="",bldrptStartTime="";
	if(bldrptStartDateTime!=""){
		bldrptStartDate=bldrptStartDateTime.split(" ")[0];  //开始日期
		bldrptStartTime=bldrptStartDateTime.split(" ")[1];  //开始时间
	}
	var bldrptOperator=$('#bldrptOperator').val();   //操作者工号
	
	//24、输血反应发现时间
	var bldrptOccDateTime=$('#bldrptOccDateTime').datetimebox('getValue');   
	var bldrptOccDate="",bldrptOccTime="";
	if(bldrptOccDateTime!=""){
		bldrptOccDate=bldrptOccDateTime.split(" ")[0];  //发现日期
		bldrptOccTime=bldrptOccDateTime.split(" ")[1];  //发现时间
	}
	var bldrptDisUser=$('#bldrptDisUser').val();   //发现者工号
	//25、输血器厂家/批号
	var bldrptManf=$('#bldrptManf').val();   
	//26、剩余血量(ml)
	var bldrptRemain=$('#bldrptRemain').val();   
	//27、输血不良反应拟诊
	var bldrptAnalyze=$('#bldrptAnalyze').val();   
	//28、严重程度
	var bldrptSerLevel="";
    $("input[type=checkbox][name=bldrptSerLevel]").each(function(){
		if($(this).is(':checked')){
			bldrptSerLevel=this.value;
		}
	})
	//29、相关性
	var bldrptRelation="";
    $("input[type=checkbox][name=bldrptRelation]").each(function(){
		if($(this).is(':checked')){
			bldrptRelation=this.value;
		}
	})
	//30、临床处置
	var bldrptWardOp=$('#bldrptWardOp').val();
	//31、患者转归
	var bldrptPatInfo="";
	var bldrptDeathDateTime="";
	var bldrptDeathDate="";bldrptDeathTime="";

     $("input[type=checkbox][name=bldrptPatInfo]").each(function(){
		if($(this).is(':checked')){
			bldrptPatInfo=this.value;
		}
	})
	if(bldrptPatInfo=="1"){
		bldrptDeathDateTime=$('#bldrptDeathDateTime').datetimebox('getValue'); 
		if(bldrptDeathDateTime==""){
			$.messager.alert("提示:","患者转归为【死亡】,请填写死亡时间！");
			return;
		}else{
			bldrptDeathDate=bldrptDeathDateTime.split(" ")[0];  //死亡日期
			bldrptDeathTime=bldrptDeathDateTime.split(" ")[1];  //死亡时间
		}
	}	
	//32、与输血相关性
	var bldrptBloodRelat="";
    $("input[type=checkbox][name=bldrptBloodRelat]").each(function(){
		if($(this).is(':checked')){
			bldrptBloodRelat=this.value;
		}
	})
	
	//输血不良反应描述（患者体征）
	var bldAList="";
	var bldAdatalist=[];
	var bldAListt="";
	var bldAdatalistt=[];
	var selBldAItems = $('#BldA').datagrid('getRows');
	$.each(selBldAItems, function(index, item){
		var items = $("input[name='bldbox']:checked");
		$.each(items, function (index, items) {
			if (items.value==item.ID){
				var tmp=item.ID;   //参数串
				bldAdatalist.push(tmp);
				bldAList=bldAdatalist.join("$c(1)"); 
			}
		});
		var itemst = $("input[name='bldboxt']:checked");
		$.each(itemst, function (index, itemst) {
			if (itemst.value==item.IDt){
				var tmp=item.IDt;   //参数串
				bldAdatalistt.push(tmp);
				bldAListt=bldAdatalistt.join("$c(1)"); 
			}
         });          
     
	});
	var BloodAList=bldAList+"$c(1)"+bldAListt  ;
	//输血不良反应描述（临床症状）
	var bldBList="";
	var bldBdatalist=[];
	var bldBListt="";
	var bldBdatalistt=[];
	var selBldBItems = $('#BldB').datagrid('getRows');
	$.each(selBldBItems, function(index, item){
		var itemb = $("input[name='bldbox']:checked");
		$.each(itemb, function (index, itemb) {
			if (itemb.value==item.ID){
				var tmp=item.ID;   //参数串
				bldBdatalist.push(tmp);
				bldBList=bldBdatalist.join("$c(1)"); 
			}
		});
		
		var itembt = $("input[name='bldboxt']:checked");
		$.each(itembt, function (index, itembt) {
			if (itembt.value==item.IDt){
				var tmp=item.IDt;   //参数串
				bldBdatalistt.push(tmp);
				bldBListt=bldBdatalistt.join("$c(1)"); 
			}
         });  
         
                 
	});
	var BloodBList=bldBList+"$c(1)"+bldBListt  ;
	if((flag=="1")&&(bldAList=="")&&(bldAListt=="")&&(bldBList=="")&&(bldBListt=="")){
	  $.messager.alert("提示:","【输血不良反应描述】不能为空！");
		return;
	}

	var rows = $("#bldBldTypedg").datagrid('getRows');
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].bldtype+"^"+rows[i].bldone+","+rows[i].bldtwo+","+rows[i].bldthree+","+rows[i].bldfour;
		dataList.push(tmp);
	} 
	var BloodType=dataList.join("$c(1)");
    var bldrptRepImpFlag="N"; //重点关注
         if(ImpFlag==""){  
		   bldrptRepImpFlag=bldrptRepImpFlag;
		 }else{ 
             bldrptRepImpFlag=ImpFlag;
		 }
	if(flag==1){
		bldrptCurStatusDR=BldrptInitStatDR;  //初始状态
	}	
	var bldrptDataList=bldrptRepLocDr+"^"+bldrptRepNo+"^"+bldrptCreateDate+"^"+bldrptCreateTime+"^"+bldrptCreator;
	bldrptDataList=bldrptDataList+"^"+bldrptAdmNo+"^"+bldrptPatNo+"^"+bldrptPatID+"^"+bldrptName+"^"+bldrptSex+"^"+bldrptAge+"^"+bldrptBrithDate+"^"+bldrptPatCardNo;
	bldrptDataList=bldrptDataList+"^"+bldrptGestation+"^"+bldrptWard+"^"+bldrptBloodhis+"^"+bldrptADVBloodhis+"^"+bldrptBloodType+"^"+bldrptBloodAttr+"^"+bldrptAntibody+"^"+bldrptCurrBloodType;
	bldrptDataList=bldrptDataList+"^"+bldrptCurrBloodAttr+"^"+bldrptDiscNum+"^"+bldrptTemp+"^"+bldrptBloodPress+"^"+bldrptSphygmus+"^"+bldrptBreathes+"^"+bldrptDrugDesc;
	bldrptDataList=bldrptDataList+"^"+bldrptDrugRemark+"^"+bldrptStartDate+"^"+bldrptStartTime+"^"+bldrptOperator+"^"+bldrptOccDate+"^"+bldrptOccTime+"^"+bldrptDisUser;
	bldrptDataList=bldrptDataList+"^"+bldrptManf+"^"+bldrptRemain+"^"+bldrptAnalyze+"^"+bldrptSerLevel+"^"+bldrptRelation+"^"+bldrptWardOp+"^"+bldrptPatInfo+"^"+bldrptDeathDate;
	bldrptDataList=bldrptDataList+"^"+bldrptDeathTime+"^"+bldrptBloodRelat+"^"+bldrptCurStatusDR+"^"+bldrptReportType+"^"+bldrptRepImpFlag;
	bldrptDataList=bldrptDataList+"$c(2)"+""+"$c(2)"+BloodType+"$c(2)"+BloodAList+"$c(2)"+BloodBList;
	
	//var bldrptRepAuditList="";
	//if(flag==1){
	var bldrptRepAuditList=bldrptCurStatusDR+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+medadrNextLoc+"^"+medadrLocAdvice+"^"+medadrReceive+"^"+bldrptReportType;
	//}
	var param="bldrptID="+bldrptID+"&bldrptDataList="+bldrptDataList+"&bldrptRepAuditList="+bldrptRepAuditList+"&flag="+flag ; 
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
       			data: "action=saveBldrptReport&"+param,
       			success: function(val){
	      			var bldrptArr=val.replace(/(^\s*)|(\s*$)/g,"").split("^");
	      			if (bldrptArr[0]=="0") {
	      	 			$.messager.alert("提示:",mesageShow+"成功!");
			 			bldrptID=bldrptArr[1];
			 			if(winflag==0){
						 	 if (((adrDataList!="") ||((adrDataList=="")&&(frmflag==1)) )&&(flag==1)){
				  				window.parent.CloseWin();
				  			 }
				 	    }else if(winflag==1){
						      window.parent.CloseWinUpdate();
					 	    
					 	}
			 			if (adrDataList=="")
						{  //wangxuejian 2016/10/18
			 				InitBldrptReport(bldrptID);//获取报告信息(获取编码信息) qunianpeng 16/09/29 update
					 		winflag=0;
					 	}
			 			if(flag==1){
							$("#buttondiv").hide();
				 		}
						if(editFlag!=0){
							window.parent.Query();
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
//加载血液类别列表
function InitBldTypeInfo(bldrptID)
{
    if(bldrptID==""){return;}
    $('#bldBldTypedg').datagrid({
		url:url+'?action=getBldTypeInfo',	
		queryParams:{
			params:bldrptID}
	});
}
//加载报表信息
function InitBldrptReport(bldrptID)
{
	if(bldrptID==""){return;}
   	var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
	winflag=1; //2016-10-10
	//获取报表信息
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getBldrptRepInfo&bldrptID="+bldrptID+"&params="+params,
       success: function(val){
	      	 bldrptDataList=val;
	      	 //alert(bldrptDataList);
	      	    var tmp=bldrptDataList.split("!");
				$('#bldrptID').val(tmp[0]);    //报表ID
				$('#bldrptRepLocDr').val(tmp[1]); //科室	
				$('#bldrptRepLocDr').attr("disabled","true");
				$('#bldrptCreator').val(tmp[2]); //填报人（报告人签名）
				$('#bldrptCreator').attr("disabled","true");
				$('#bldrptRepNo').val(tmp[3]); //报告编码
				$('#bldrptRepNo').attr("disabled","true");
				$('#bldrptCreateDateTime').datetimebox({disabled:true});
				$('#bldrptCreateDateTime').datetimebox("setValue",tmp[4]+" "+tmp[5]);   //报告日期
				$('#bldrptWard').combobox('setValue',tmp[6]); //病人病区ID
				$('#bldrptWard').combobox('setText',tmp[56]); //病人病区描述
	
				$('#AdmNo').val(tmp[7]); //病人就诊ID
				EpisodeID=tmp[7];
				$('#PatNo').val(tmp[8]); //病案号
				$('#PatNo').attr("disabled","true");
				$('#PatID').val(tmp[9]); //病人ID
				$('#PatID').attr("disabled","true");  ///2017-07-20 bianshuai 设置病人ID不可编辑
				$('#PatName').val(tmp[10]);    //患者姓名
				$('#PatSex').combobox('setValue',tmp[11]);     //性别
				$('#PatAge').val(tmp[12]);    //年龄
				$('#BrithDate').datebox("setValue",tmp[13]);   //病人出生日期
				$('#PatCardNo').val(tmp[14]);    //身份证号
				
				$('#BG'+tmp[15]).attr("checked",true);	//孕产史
				var bldrptSex=$('#PatSex').combobox('getValue');
				if(bldrptSex==1){
					$("[name=bldrptGestation]:checkbox").attr("disabled",true);//报告类型不可勾选
				}
				$('#BB'+tmp[16]).attr("checked",true);	//继往输血史
				$('#BA'+tmp[17]).attr("checked",true);	//输血反应史
				
				$('#bldrptBloodType').val(tmp[18]);  //输血前血型检查结果
				$('#bldrptBloodAttr').val(tmp[19]);  //血型检查阴阳性
				$('#bldrptAntibody').val(tmp[20]);  //意外抗体筛查（阴阳性）
				$('#bldrptCurrBloodType').val(tmp[21]);  //本次输注的血液信息
				$('#bldrptCurrBloodAttr').val(tmp[22]);  //输注的血液阴阳性
				$('#bldrptDiscNum').val(tmp[23]);  //输注血量
				$('#bldrptTemp').val(tmp[24]);  //体温 
				$('#bldrptBloodPress').val(tmp[25]);  //血压 
				$('#bldrptSphygmus').val(tmp[26]);  //脉搏 
				$('#bldrptBreathes').val(tmp[27]);  //呼吸频次
				//输血前预防用药
				$('#BD'+tmp[28]).attr("checked",true);
				$('#bldrptDrugRemark').val(tmp[29]);
				if(tmp[28]==1){
					$("#DrugRemark").show();
				}
				
				if(tmp[28]=="1"){
					$('#bldrptDrugRemark').attr("disabled",false);
				}
				if(tmp[30]!=""||tmp[31]!=""){
					$('#bldrptStartDateTime').datetimebox("setValue",tmp[30]+" "+tmp[31]);   //本次输血开始时间
				}
				$('#bldrptOperator').val(tmp[32]);   //操作者工号
				if(tmp[33]!=""||tmp[34]!=""){
					$('#bldrptOccDateTime').datetimebox("setValue",tmp[33]+" "+tmp[34]);   //输血反应发现时间
				}
				$('#bldrptDisUser').val(tmp[35]);   //发现者工号
				$('#bldrptManf').val(tmp[36]);  //输血器厂家/批号
 				$('#bldrptRemain').val(tmp[37]);  //剩余血量(ml)
				$('#bldrptAnalyze').val(tmp[38]);  //输血不良反应拟诊
				$('#BS'+tmp[39]).attr("checked",true);	//严重程度
				$('#BR'+tmp[40]).attr("checked",true);	//相关性
				$('#bldrptWardOp').val(tmp[41]);	//临床处置
				
				//患者转归
				$('#BP'+tmp[42]).attr("checked",true);
				$('#bldrptDeathDateTime').datetimebox("setValue",tmp[43]+" "+tmp[44]);
				var deathdatetime=tmp[42];
				if(deathdatetime==1){
					$("#deathdate").show();
				}
				$('#BBR'+tmp[45]).attr("checked",true);	//与输血相关性
				
				
				bldrptCurStatusDR=tmp[46];
				bldrptReportType=tmp[47];
				BldrptInitStatDR=tmp[48];
				
				medadrNextLoc=tmp[49];
				medadrLocAdvice=tmp[50];
				medadrReceive=tmp[51];
				UserDr=tmp[52];//报告人ID
				LocDr=tmp[53];//科室ID
                ImpFlag=tmp[54];//重要标记
                
                $('#PatDiag').val(tmp[55]);  //病床诊断
                
				if (bldrptCurStatusDR=="")
				{
					bldrptCurStatusDR=bldrptCurStatusDR;
					medadrReceive="";
				}
				else
				{
					BldrptInitStatDR=tmp[46];
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
				if (tmp[46]!=""){  //如果有提交状态
					$('#submitdiv').hide();//隐藏提交按钮
					//获取评估权限标志 2016-10-19
					var Assessflag=GetAssessAuthority(bldrptID,params);
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
function InitPatientInfo(bldrptID,adrDataList)
{
   if(bldrptID!=""){return;}
   if(adrDataList==""){
   		adrDataList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
   }
   //var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
   $.ajax({
   type: "POST",
   url: url,
   data:"action=getBloodInfo&params="+adrDataList,
   success: function(val){
		if(val==-1){
			$.messager.alert("提示:","请先配置工作流与权限,然后填报！");
	       return;
		}else{
			var tmp=val.split("^");
			$('#bldrptCreateDateTime').datetimebox({disabled:true});
			$('#bldrptCreateDateTime').datetimebox("setValue",tmp[0]);   //报告日期
			BldrptInitStatDR=tmp[1];  //报表的初始化,状态 
			bldrptReportType=tmp[2];  // 报告类型
			//$('#bldrptRepNo').val(tmp[3]);    //报告编码
			$('#bldrptRepNo').attr("disabled","true");
			UserDr=tmp[4];
			$('#bldrptCreator').val(tmp[5]);    //报告人姓名
			$('#bldrptCreator').attr("disabled","true");
			LocDr=tmp[6];
			$('#bldrptRepLocDr').val(tmp[7]);    //科室描述
			$('#bldrptRepLocDr').attr("disabled","true");
		}
   }})
}
//获取病人信息
function getBldrptPatInfo(patientID,EpisodeID)
{
	if(patientID==""||EpisodeID==""){return;}
	//var patientID=getRegNo(patientID);
	//获取报表信息
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getRepPatInfo&PatNo="+patientID+"&EpisodeID="+EpisodeID,
       success: function(val){
	   	var bldrptPatInfo=val;
	    var tmp=bldrptPatInfo.split("^");
		//alert(bldrptPatInfo);
		$('#PatID').val(tmp[0]); //病人ID  登记号
		$('#PatName').val(tmp[1]); //病人名字 
		$('#PatName').attr("disabled","true");
		$('#PatSex').combobox({disabled:true});
		$('#PatSex').combobox('setValue',tmp[2]);  //性别
		var bldrptSex=$('#PatSex').combobox('getValue');
		if(bldrptSex==1){
			$('#BG0').attr("checked",true);
			$("[name=bldrptGestation]:checkbox").attr("disabled",true);//报告类型不可勾选	
		}
		$('#PatAge').val(tmp[4]);  //年龄
		$('#PatAge').attr("disabled","true");
		$('#PatNo').val(tmp[5]);  //病案号
		$('#PatNo').attr("disabled","true");
		$('#BrithDate').datebox({disabled:true}); //出生日期
		$('#BrithDate').datebox("setValue",tmp[6]);  
		$('#PatCardNo').val(tmp[7]);  //身份证号
		$('#PatCardNo').attr("disabled","true");
        $('#bldrptWard').combobox('setValue',tmp[12]);  //病区ID
        $('#bldrptWard').combobox('setText',tmp[11]);  //病区描述
        $('#PatDiag').val(tmp[10]);  //病床诊断
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
	var bldrptRepLocDr=$('#bldrptRepLocDr').val();
	if(bldrptRepLocDr==""){
		$.messager.alert("提示:","【科室】不能为空！");
		return false;
	}
	//2、填报人（报告人签名）
	var bldrptCreator=$('#bldrptCreator').val();
	if(bldrptCreator==""){
		$.messager.alert("提示:","【报告人签名】不能为空！");
		return false;
	}
	//3、报告编码
	var bldrptRepNo=$('#bldrptRepNo').val();
	/*if(bldrptRepNo==""){
		$.messager.alert("提示:","【报告编码】不能为空！");
		return false;
	}*/ 
 	
	//4、报告日期
	var bldrptCreateDateTime=$('#bldrptCreateDateTime').datetimebox('getValue');   
	if(bldrptCreateDateTime==""){
		$.messager.alert("提示:","【报告日期】不能为空！");
		return false;
	}
	
	//8、病人ID
	var bldrptPatID=$('#PatID').val();
	if(bldrptPatID==""){
		$.messager.alert("提示:","【病人ID】不能为空！");
		return false;
	}
	//9、病人姓名
	var bldrptName=$('#PatName').val();
	if(bldrptName==""){
		$.messager.alert("提示:","【病人姓名】不能为空！");
		return false;
	}
    //10、病人性别
	var bldrptSex=$('#PatSex').combobox('getValue');
	if(bldrptSex==""){
		$.messager.alert("提示:","【病人性别】不能为空！");
		return false;
	}
    //11、病人年龄
	var bldrptAge=$('#PatAge').val();  
	if(bldrptAge==""){
		$.messager.alert("提示:","【病人年龄】不能为空！");
		return false;
	}
	//14、孕产史
	var bldrptGestation="";
    $("input[type=checkbox][name=bldrptGestation]").each(function(){
		if($(this).is(':checked')){
			bldrptGestation=this.value;
		}
	})
	if(bldrptGestation==""){
		$.messager.alert("提示:","【孕产史】不能为空！");
		return false;
	}
	//15、继往输血史
	var bldrptBloodhis="";
    $("input[type=checkbox][name=bldrptBloodhis]").each(function(){
		if($(this).is(':checked')){
			bldrptBloodhis=this.value;
		}
	})
	if(bldrptBloodhis==""){
		$.messager.alert("提示:","【继往输血史】不能为空！");
		return false;
	}
	//16、输血反应史
	var bldrptADVBloodhis="";
    $("input[type=checkbox][name=bldrptADVBloodhis]").each(function(){
		if($(this).is(':checked')){
			bldrptADVBloodhis=this.value;
		}
	})
	if(bldrptADVBloodhis==""){
		$.messager.alert("提示:","【输血反应史】不能为空！");
		return false;
	}
	//23、本次输血开始时间
	var bldrptStartDateTime=$('#bldrptStartDateTime').datetimebox('getValue');   
	if(bldrptStartDateTime==""){
		$.messager.alert("提示:","【输血开始时间】不能为空！");
		return false;
	}
	var bldrptStartDateResult=bldrptStartDateTime.split(" ")[0];
	if(!compareSelTimeAndCurTime(bldrptStartDateResult)){
		$.messager.alert("提示:","【输血开始时间】不能大于当前时间！");
		return false;	
	} 
	//24、输血反应发现时间
	var bldrptOccDateTime=$('#bldrptOccDateTime').datetimebox('getValue');   
	if(bldrptOccDateTime==""){
		$.messager.alert("提示:","【输血反应发现时间】不能为空！");
		return false;
	}
	var bldrptOccDateResult=bldrptOccDateTime.split(" ")[0];
	if(!compareSelTimeAndCurTime(bldrptOccDateResult)){
		$.messager.alert("提示:","【输血反应发现时间】不能大于当前时间！");
		return false;	
	} 
	//25、输血器厂家/批号
	var bldrptManf=$('#bldrptManf').val();   
	if(bldrptManf==""){
		$.messager.alert("提示:","【输血器厂家/批号】不能为空！");
		return false;
	}
	//27、输血不良反应拟诊
	var bldrptAnalyze=$('#bldrptAnalyze').val();
	if(bldrptAnalyze==""){
		$.messager.alert("提示:","【输血不良反应拟诊】不能为空！");
		return false;
	}
	//28、严重程度
	var bldrptSerLevel="";
    $("input[type=checkbox][name=bldrptSerLevel]").each(function(){
		if($(this).is(':checked')){
			bldrptSerLevel=this.value;
		}
	})
	if(bldrptSerLevel==""){
		$.messager.alert("提示:","【严重程度】不能为空！");
		return false;
	}
	//29、相关性
	var bldrptRelation="";
    $("input[type=checkbox][name=bldrptRelation]").each(function(){
		if($(this).is(':checked')){
			bldrptRelation=this.value;
		}
	})
	if(bldrptRelation==""){
		$.messager.alert("提示:","【相关性】不能为空！");
		return false;
	}
	//30、临床处置
	var bldrptWardOp=$('#bldrptWardOp').val();
	if(bldrptWardOp==""){
		$.messager.alert("提示:","【临床处置】不能为空！");
		return false;
	}
	//31、患者转归
	var bldrptPatInfo="";
	var bldrptDeathDateTime="";
	var bldrptDeathDate="";bldrptDeathTime="";

     $("input[type=checkbox][name=bldrptPatInfo]").each(function(){
		if($(this).is(':checked')){
			bldrptPatInfo=this.value;
		}
	})
	if(bldrptPatInfo==""){
		$.messager.alert("提示:","【患者转归】不能为空！");
		return false;
	}
	if(bldrptPatInfo=="1"){
		bldrptDeathDateTime=$('#bldrptDeathDateTime').datetimebox('getValue'); 
		if(bldrptDeathDateTime==""){
			$.messager.alert("提示:","患者转归为【死亡】,请填写死亡时间！");
			return false;
		}else{
			bldrptDeathDate=bldrptDeathDateTime.split(" ")[0];  //死亡日期
			bldrptDeathTime=bldrptDeathDateTime.split(" ")[1];  //死亡时间
		}
		if(!compareSelTimeAndCurTime(bldrptDeathDate)){
			$.messager.alert("提示:","患者转归为【死亡】的【死亡时间】不能大于当前时间！");
			return false;	
		} 
	}	
	//32、与输血相关性
	var bldrptBloodRelat="";
    $("input[type=checkbox][name=bldrptBloodRelat]").each(function(){
		if($(this).is(':checked')){
			bldrptBloodRelat=this.value;
		}
	})
	if(bldrptBloodRelat==""){
		$.messager.alert("提示:","【与输血相关性】不能为空！");
		return false;
	}
	
	return true;
}
//页面关联设置
function setCheckBoxRelation(id){
	if($('#'+id).is(':checked')){
		///输血前预防用药
		if(id=="BD1"){
			$('#bldrptDrugRemark').attr("disabled",false);
		}
		///患者转归
		if(id=="BP1"){
			$('#bldrptDeathDateTime').datetimebox({disabled:false});
		}
	}else{
		///输血前预防用药
		if(id=="BD1"){
			$('#bldrptDrugRemark').val("");
			$('#bldrptDrugRemark').attr("disabled",true);
		}
		///患者转归
		if(id=="BP1"){
			$('#bldrptDeathDateTime').datetimebox('setValue',"");
		} 
	}
}
//选择时间与当前时间比较
function compareSelTimeAndCurTime(SelDate)
{
	var SelDateArr=SelDate.split("-");
	var SelYear=SelDateArr[0];
	var SelMonth=parseInt(SelDateArr[1]);
	var SelDate=parseInt(SelDateArr[2]);
	var myDate=new Date();
	var curYear=myDate.getFullYear();
	if(SelYear>curYear){
		return false;
	}
	var curMonth=myDate.getMonth()+1;
	if((SelYear==curYear)&(SelMonth>curMonth)){
		return false;
	}
	var curDate=myDate.getDate();
	if((SelYear==curYear)&(SelMonth==curMonth)&(SelDate>curDate)){
		return false;
	}
	return true;
}
//在.js中新增function
function SetAdmTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID=""
	}
	var bldrptPatID=$('#PatID').val();
	var bldrptPatID=getRegNo(bldrptPatID);
	$('#bldsgrid').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetPatBldRecordNew&EpisodeID='+EpisodeID  //2016-10-28
	});
	getBldrptPatInfo(bldrptPatID,EpisodeID);
}
//选择病人的输血记录
function GetPatBldRecord(EpisodeID)
{
			 
			 if (EpisodeID=="")
			 {
				 	$.messager.alert("提示:","请先选择病人就诊记录！");
					return;
			 }

			 var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
			 var mycols = [[
			 	{field:'issueId',title:'ID',width:60}, 
			 	{field:'issueDate',title:'发放日期',width:80}, 
			 	{field:'issueTime',title:'发放时间',width:80},
			 	{field:'IsTransBlood',title:'IsTransBlood',width:80},
			 	{field:'IsReaction',title:'IsReaction',width:80},
				{field:'Parity',title:'Parity',width:80},
			    {field:'Gravidity',title:'Gravidity',width:80}
			 ]];
			 var mydgs = {
				 url:'dhcadv.repaction.csp'+'?action=GetPatBldRecordNew&EpisodeID='+EpisodeID ,
				 columns: mycols,  //列信息
				 pagesize:10,  //一页显示记录数
				 table: '#bldsgrid', //grid ID
				 field:'issueId', //记录唯一标识
				 params:null,  // 请求字段,空为null
				 tbar:null //上工具栏,空为null
				}
			 var win=new CreatMyDiv(input,$("#BldRecBtn"),"bldsfollower","650px","335px","bldsgrid",mycols,mydgs,"","",SetBldTxtVal);	
			 win.init();
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
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.repmanage.csp?RepID='+bldrptID+'&RepType='+bldrptReportType+'"></iframe>';
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
//输血单 2016-10-25
function SetBldTxtVal(rowData)
{
	RecordId=rowData.issueId; //输血单id
	if((RecordId!="")&&(RecordId!=undefined)){
		$('#BB'+rowData.IsTransBlood).attr("checked",true); 	//继往输血史
		$('#BA'+rowData.IsReaction).attr("checked",true);  //输血反应史
		if((rowData.Parity!="0")&&(rowData.Parity!=undefined)){
			$('#BG1').attr("checked",true);//孕史
		}else if ((rowData.Gravidity!="0")&&(rowData.Gravidity!=undefined)){
			$('#BG2').attr("checked",true);//产史
		}else{
			$('#BG0').attr("checked",true);//无孕产史
		}
	
		GetbldBldTypedgInfo(RecordId);
	}
}
//判断报告编码是否存在
function RepNoRepet(){
	var IDflag=0;
	if (bldrptID==""){
		IDflag=0; 
	}else{
		IDflag=1; 
	}
	$('#repnoflag',window.parent.document).val(IDflag); //给父界面元素赋值
	/* //报告编码
	var bldRepNo=$('#bldrptRepNo').val();
	bldRepNo=bldRepNo.replace(/[ ]/g,""); //去掉编码中的空格
	$.ajax({
		type: "POST",// 请求方式
    	url: url,
    	data: "action=SeaBldRepNo&bldRepNo="+bldRepNo,
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
	window.location.href="dhcadv.bloodreport.csp?adrDataList="+""+"&frmflag="+frmflag;//刷新传参adrDataList为空
}			
//获取输血单信息初始化输血信息列表  2016-10-27
function GetbldBldTypedgInfo(RecordId)
{  
	$('#bldBldTypedg').datagrid({
		url:url+'?action=GetPatBldRecordPacksNew&params='+RecordId
	});
}
