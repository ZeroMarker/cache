/*
* 药学监护
* pengzhikun
*/
var url="dhcpha.clinical.action.csp";
var EpisodeID=""; //
var PatLoc="";  //病人科室
var PatWard="";  //病人病区
var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:华文楷体;">药学关注内容</span>';
$(document).ready(function(){
	//根据点击明细显示窗口panel
	$('.easyui-accordion ul li a').click(function(){
		 $('.easyui-accordion ul li a').css({"background":"#FFFFFF"});
		 $(this).css({"background":"#87CEFA"});
		 var panelTitle = $(this).text();
		 //点击侧菜单的显示相应界面
		 choseMenu(panelTitle);
	});
	EpisodeID=getParam("EpisodeID"); //病人adm
	pageBasicControll();
	InitPageData();
})

/**
* 1.界面上基本内容的显示控制
* 2.每个界面"编辑内容.."，获取焦点、失去焦点，内容控制
*/
function pageBasicControll(){
	
	/*一级监护界面*/
	$('#GuideContent1').focus(function(){
		if($(this).text()=="编辑内容.."){
			$(this).text("");
		}
	})
	$('#GuideContent1').blur(function(){
		if($(this).text().trim()==""){
			$(this).text("编辑内容..");
		}
	})
	
	/*二级监护界面*/
	$('#GuideContent2').focus(function(){
		if($(this).text()=="编辑内容.."){
			$(this).text("");
		}
	})
	$('#GuideContent2').blur(function(){
		if($(this).text().trim()==""){
			$(this).text("编辑内容..");
		}
	})
	
	/*三级监护界面*/
	$('#GuideContent3').focus(function(){
		if($(this).text()=="编辑内容.."){
			$(this).text("");
		}
	})
	$('#GuideContent3').blur(function(){
		if($(this).text().trim()==""){
			$(this).text("编辑内容..");
		}
	})
		
}

function choseMenu(item){
	switch(item){
		case "一级药学监护":
			//防止重复点击，而此时Flag=1，导致不执行创建界面
			if(Flag1==0){
				//隐藏mainpanel的所有子节点
				$("#mainPanel").children().css("display","none")
				//动态创建一个"新入院患者"的panel
				createLev1Panel();
				//设置mainPanel可见
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;font-size:12pt;font-family:华文楷体;'>[红色*号标注的为必填项]</span>"
				});
				InitPagePatObserver(EpisodeID);  //初始化病人生命体征
			}
			
			break;
			
		case "二级药学监护":
			if(Flag2==0){
				//隐藏mainpanel的所有子节点
				$("#mainPanel").children().css("display","none")
				//动态创建一个"住院期间患者"的panel
				createLev2Panel();
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;font-size:12pt;font-family:华文楷体;'>[红色*号标注的为必填项]</span>"
				});
				//加载数据
				//loadData();
				InitPagePatObserver(EpisodeID);  //初始化病人生命体征
			}
			break;
			
		case "三级药学监护":
			if(Flag3==0){
				//隐藏mainpanel的所有子节点
				$("#mainPanel").children().css("display","none")
				//动态创建一个"住院期间患者"的panel
				createLev3Panel();
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;font-size:12pt;font-family:华文楷体;'>[红色*号标注的为必填项]</span>"
				});
				//加载数据
				//loadData();
				InitPagePatObserver(EpisodeID);  //初始化病人生命体征
			}
			break;
			
		default:
			break;	
	}
				 	
} 

//--创建"一级药学监护"主界面--//
var Flag1=0;//防止重复点击，多次创建面板
function createLev1Panel() {
	if(Flag1==0){
		//仅显示咨询主界面
		$("#PedDep_Level1").css("display","block");		
		Flag1=1;
		Flag2=0;
		Flag3=0;
		
		var locId = session['LOGON.CTLOCID'];  //登陆科室 bianshuai 2014-12-17
		var levelId ="1";    //监护级别"一级"
		var titleScope = $('#mainTitle1');    //监护范围左标题
		var tableScope = $('#rangetable1');   //监护范围内容
		var titleMonItm= $('#monitmTitle1');  //监护项目左标题
		var tableMonItm= $('#monitmtable1');  //监护范围内容
		
		loadLevData(locId,levelId,titleScope,tableScope,titleMonItm,tableMonItm);
		
	}
} 


//--创建"二级药学监护"主界面--//
var Flag2=0;//防止重复点击，多次创建面板
function createLev2Panel() {
	if(Flag2==0){
		//仅显示咨询主界面
		$("#PedDep_Level2").css("display","block");
		Flag2=1;
		Flag1=0;
		Flag3=0;
		
		var locId = session['LOGON.CTLOCID'];  //登陆科室 bianshuai 2014-12-17
		var levelId="2";    //监护级别"二级"
		var titleScope = $('#mainTitle2');    //监护范围左标题
		var tableScope = $('#rangetable2');   //监护范围内容
		var titleMonItm= $('#monitmTitle2');  //监护项目左标题
		var tableMonItm= $('#monitmtable2');  //监护范围内容
		
		loadLevData(locId,levelId,titleScope,tableScope,titleMonItm,tableMonItm);
		
	}
} 

//--创建"三级药学监护"主界面--//
var Flag3=0; //防止重复点击，多次创建面板
function createLev3Panel() {
	if(Flag3==0){
		//仅显示咨询主界面
		$("#PedDep_Level3").css("display","block");
		Flag3=1;
		Flag1=0;
		Flag2=0;
		
		var locId= session['LOGON.CTLOCID'];  //登陆科室 bianshuai 2014-12-17
		var levelId="3";    //监护级别"三级"
		var titleScope = $('#mainTitle3');    //监护范围左标题
		var tableScope = $('#rangetable3');   //监护范围内容
		var titleMonItm= $('#monitmTitle3');  //监护项目左标题
		var tableMonItm= $('#monitmtable3');  //监护范围内容
		
		loadLevData(locId,levelId,titleScope,tableScope,titleMonItm,tableMonItm);
		
	}
} 

/**
* 根据科室ID和监护级别，动态查询监护范围数据
*/
function loadLevData(locId,levelId,titleScope,tableScope,titleMonItm,tableMonItm){
	//获取监护范围数据
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?actiontype=getRangeListInfo',//提交到那里 后他的服务  
		data: {ctloc:locId, level:levelId,rows:999,page:1}, //提交的参数  
		success:function(msg){ 
			createLevScope(msg,titleScope,tableScope);      
		},    
		error:function(){        
			alert("获取数据失败!");
		}
	}); 
	
	//获取监护项目数据
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?actiontype=GetMonItmInfo',//提交到那里 后他的服务  
		data: {ctloc:locId, level:levelId,rows:999,page:1}, //提交的参数  
		success:function(msg){ 
			createMonItm(msg,titleMonItm,tableMonItm);      
		},    
		error:function(){        
			alert("获取数据失败!");
		}
	}); 
}

/**
* 动态加载监护范围数据列表
*/
function createLevScope(msg,title,table){
	var obj = eval( "(" + msg + ")" ); //转换后的JSON对象
	var arrayJson=obj.rows;
	table.children().remove();  //先删除table内的子元素，避免重复加载
	for(var i=0;i<arrayJson.length;i++){
		var row = $("<tr></tr>"); 
		var td = $("<td></td>"); 
		$('<input />',{name:arrayJson[i].rowid,type:'checkbox'}).appendTo(td);
		$('<span />',{
			text:"  "+arrayJson[i].desc         //增加间隙
		}).appendTo(td);
		row.append(td); 
		table.append(row);
	}
	
	//title.css('height',table.height()+"px").css("line-height",table.height()+"px");
	 	 
}

/**
* 动态加载监护项目数据列表
*/
function createMonItm(msg,title,table){
	var obj = eval( "(" + msg + ")" ); //转换后的JSON对象
	var arrayJson=obj.rows;
	table.children().remove();  //先删除table内的子元素，避免重复加载
	/**
	*1.动态创建表格，列数：3
	*2.行数：对arrayJson.length/3取整，然后+1
	*3.对于前0到arrayJson.length/3行，每行动态添加3列
	*4.最后一行，根据arrayJson.length%3求模的结果动态创建td的个数
	*/
	for(var i=0;i<Math.floor(arrayJson.length/3)+1;i++){
		var row = $("<tr></tr>");
		if(i<Math.floor(arrayJson.length/3)){
			for(var j=0;j<3;j++){ 
				var td = $("<td></td>");
				/*
				$('<input />',{
					name:arrayJson[3*i+j].rowid,
					type:'checkbox'
				}).appendTo(td);
				
				$('<span />',{
					text:"  "+arrayJson[3*i+j].desc       //增加间隙
				}).appendTo(td);
				*/

				var tempdesc=arrayJson[3*i+j].desc.replace("[]","<input style='width:80px;' name='monItems' id="+arrayJson[3*i+j].rowid+"></input>");
				$('<span>'+tempdesc+'&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>').appendTo(td);
				row.append(td);
			} 
			table.append(row);
		}else{
			for(var j=0;j<arrayJson.length%3;j++){ 
				var td = $("<td></td>");
				/*
				$('<input />',{
					name:arrayJson[3*i+j].rowid,
					type:'checkbox'
				}).appendTo(td);
				$('<span />',{
					text:"  "+arrayJson[3*i+j].desc       //增加间隙
				}).appendTo(td);
				*/
				var tempdesc=arrayJson[3*i+j].desc.replace("[]","<input style='width:80px;' name='monItems' id="+arrayJson[3*i+j].rowid+"></input>");
				$('<span>'+tempdesc+'&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>').appendTo(td);

				row.append(td);
			} 
			table.append(row);
			
		}
	}
	
	//title.css('height',table.height()+"px").css("line-height",table.height()+"px");
	 	 
}


//加载界面初始datagrid显示
function InitPageData(){
	
    if(EpisodeID==""){
	    alert("未获取到病人的就诊号，请关闭窗口，重新操作，谢谢！！")
	    return;
    }
    
    ///获取病人基本信息 2015-03-06 bianshuai
    var patEssInfo=tkMakeServerCall("web.DHCSTPHCMCOMMON","GetPatEssInfo","",EpisodeID);
    if(patEssInfo==""){
	    alert("加载病人基本信息错误！");
    	return;
    }
    var patEssInfoArr=patEssInfo.split("^");
	PatLoc=patEssInfoArr[16];  //患者科室Id
	PatWard=patEssInfoArr[18]; //患者病区Id
    
    /*   注释 2015-03-06 bianshuai
    //获取病人基本信息
    $.ajax({
   		type: "POST",
   		url: url,
   		data: "action=getAdrRepPatInfo&AdmDr="+EpisodeID+"&LocID="+"",
   		//dataType: "json",
   		success: function(val){
			tmp=val.split("^");
			//病人信息
			//患者科室Id
			PatLoc=tmp[14];
			//患者病区Id
			PatWard=tmp[17];

   		}
    });
    */
	
	/*  注释 2015-03-16 bianshuai
	//定义columns
	var columns=[[
		{field:"orditm",title:'orditm',width:90,hidden:true},
	    {field:'incidesc',title:'商品名称',width:300,align:'left'},
	    {field:'genenic',title:'通用名',width:300,align:'left'},
	    {field:'manf',title:'生产企业',width:300,align:'left'},
		{field:'operation',title:'<a href="#" onclick="patOeInfoWindow()"><img style="margin-left:3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>',
		    width:30,
		    align:'center',
			formatter:SetCellUrl
		}
	]];
	
	//定义datagrid
	$('#drugdg1').datagrid({
		title:titleNotes,    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,//行号 
		loadMsg: '正在加载信息...',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            //$("#drugdg1").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	
	//定义datagrid
	$('#drugdg2').datagrid({
		title:titleNotes,    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,//行号 
		loadMsg: '正在加载信息...',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            //$("#drugdg2").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	//定义datagrid
	$('#drugdg3').datagrid({
		title:titleNotes,    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,//行号 
		loadMsg: '正在加载信息...',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            //$("#drugdg3").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	
	InitdatagridRow();
	*/
}

//初始化列表使用
function InitdatagridRow()
{
	for(var k=0;k<4;k++)
	{
		$("#drugdg1").datagrid('insertRow',{
			index: 0, 
			row: {orditm:'',phcdf:'',incidesc:'',genenic:'',manf:''}
		});
		$("#drugdg2").datagrid('insertRow',{
			index: 0, 
			row: {orditm:'',phcdf:'',incidesc:'',genenic:'',manf:''}
		});
		$("#drugdg3").datagrid('insertRow',{
			index: 0, 
			row: {orditm:'',phcdf:'',incidesc:'',genenic:'',manf:''}
		});
	}
}

// 删除行
function delRow(datagID,rowIndex)
{
	//行对象
    var rowobj={
		orditm:'', incidesc:'', genenic:'', manf:''
	};
	
	//当前行数大于4,则删除，否则清空
	var selItem=$('#'+datagID).datagrid('getSelected');
	var rowIndex = $('#'+datagID).datagrid('getRowIndex',selItem);
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
}

/// 链接
function SetCellUrl(value, rowData, rowIndex)
{	
	var dgID='"'+rowData.dgID+'"';
	return "<a href='#' onclick='delRow("+dgID+","+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
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

function addWatchDrg(){
	if(Flag1==1){
		//var phaWardRid=$('#RowId').val();
		var phaWardRid=""
		//新入院患者界面
		//用药列表
		var rows = $('#drugdg1').datagrid('getChanges');
		var k=0;
		for(var i=0;i<rows.length;i++)
		{
			if(rows[i].orditm!=""){
				//break;
				k=k+1;
			}
		}
		
		//获取医嘱列表被勾选的行
		var checkedItems = $('#medInfo').datagrid('getChecked');
		/**
		*1.如果初始查房记录rowid不存在，则药品列表，显示为初始条目
		*2.如果查房记录rowid存在，则根据关注药品，在datagrid显示，通过reload方式
		*/

		if(phaWardRid==""){
    		$.each(checkedItems, function(index, item){
	    		var rowobj={
					orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     		manf:item.manf, dgID:'drugdg1'
				}
	    		if(k>3){
					$("#drugdg1").datagrid('appendRow',rowobj);
				}else{
					$("#drugdg1").datagrid('updateRow',{	//在指定行添加数据，appendRow是在最后一行添加数据
						index: k, // 行数从0开始计算
						row: rowobj
					});
				}
				k=k+1;
    		})
    	}else{
    		$.each(checkedItems, function(index, item){
	    		var rowobj={
					orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     		manf:item.manf, dgID:'drugdg1'
				}
				$("#drugdg1").datagrid('appendRow',rowobj);
	   		});
	    }
    	$('#mwin').window('close');
    	//$('#medInfo').datagrid().clearSelections();
	}else if(Flag2==1){
		//查房界面
		//用药列表
		var rows = $('#drugdg2').datagrid('getChanges');
		var k=0;
		for(var i=0;i<rows.length;i++)
		{
			if(rows[i].orditm!=""){
				//break;
				k=k+1;
			}
		}
	
		var checkedItems = $('#medInfo').datagrid('getChecked');
    	$.each(checkedItems, function(index, item){
	    	var rowobj={
				orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     	manf:item.manf, dgID:'drugdg2'
			}
	    	if(k>3){
				$("#drugdg2").datagrid('appendRow',rowobj);
			}else{
				$("#drugdg2").datagrid('updateRow',{	//在指定行添加数据，appendRow是在最后一行添加数据
					index: k, // 行数从0开始计算
					row: rowobj
				});
			}
			k=k+1;
    	})
    	$('#mwin').window('close');
    	//$('#medInfo').datagrid().clearSelections();
	}else if(Flag3==1){
		//查房界面
		//用药列表
		var rows = $('#drugdg3').datagrid('getChanges');
		var k=0;
		for(var i=0;i<rows.length;i++)
		{
			if(rows[i].orditm!=""){
				//break;
				k=k+1;
			}
		}
	
		var checkedItems = $('#medInfo').datagrid('getChecked');
    	$.each(checkedItems, function(index, item){
	    	var rowobj={
				orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     	manf:item.manf, dgID:'drugdg3'
			}
	    	if(k>3){
				$("#drugdg3").datagrid('appendRow',rowobj);
			}else{
				$("#drugdg3").datagrid('updateRow',{	//在指定行添加数据，appendRow是在最后一行添加数据
					index: k, // 行数从0开始计算
					row: rowobj
				});
			}
			k=k+1;
    	})
    	$('#mwin').window('close');
    	//$('#medInfo').datagrid().clearSelections();
	}
  
}

//过滤掉输入文本信息中空格
String.prototype.trim=function(){
	return this.replace(/(^\s*)|(\s*$)/g,"");
}

/*控制检查文本框textarea的长度*/
function textCounter(field, countfield, maxlimit) {  
   // 函数，3个参数，表单名字，表单域元素名，限制字符； 
   if (field.value.length > maxlimit){  
       //如果元素区字符数大于最大字符数，按照最大字符数截断；  
   	   field.value = field.value.substring(0, maxlimit); 
   }else{
       //在记数区文本框内显示剩余的字符数；  
       countfield.value = maxlimit - field.value.length;  
   }
}

/**
* 提交保存一级药学监护内容
*/
function saveLevel1Info(){

	//监护范围列表
	var scopeArr=[];
	$("#rangetable1 input[type='checkbox']").each(function(){
		if ($(this).attr("checked")){
          	scopeArr.push(this.name);
		}	
	});
	scopeList=scopeArr.join("||");
	
	//监护项目列表	
	var monItmArr=[];
	$("#monitmtable1 input[name='monItems']").each(function(){
		monItmArr.push(this.id+"^"+$(this).val());
	});
	monItmList=monItmArr.join("||");

	//重点关注药物
	var tmpItmArr=[];
	/*
	var drugItems = $('#drugdg1').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm
		    tmpItmArr.push(tmp);
		}
	})
	*/
	//监护内容(填写的内容)
	var careContent=$("#GuideContent1").val();
	
	//重要化验结果
	var Imptres=$("#Imptres1").val();
	
	//记录人
	var UserDr=session['LOGON.USERID'];
	
	var levelDr="1";  //监护级别"一级"，对应Dr为1 
	
	//药学监护主信息
	var phaCareMasDataLis=levelDr+"^"+EpisodeID+"^"+PatWard+"^"+PatLoc+"^"+UserDr+"^"+careContent+"^"+Imptres;
	
	var rowid="";
	var input=phaCareMasDataLis+"!!"+scopeList+"!!"+monItmList+"!!"+tmpItmArr;
	
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?actiontype=SavePharCareInf',//提交到那里  
		data: "rowid="+rowid+"&"+"input="+input,//提交的参数  
		success:function(msg){ 
			if(msg!=0){
				alert("保存失败,失败状态码为"+msg);
			}else{           
				alert("保存成功");
				clearData();
			}       
		},    
		error:function(){        
			alert("保存失败");        
		}
	});
}


/**
* 提交保存二级药学监护内容
*/
function saveLevel2Info(){

	//监护范围列表
	var scopeArr=[];
	$("#rangetable2 input[type='checkbox']").each(function(){
		if ($(this).attr("checked")){
          	scopeArr.push(this.name);
		}	
	});
	scopeList=scopeArr.join("||");
	
	//监护项目列表	
	var monItmArr=[];
	$("#monitmtable2 input[name='monItems']").each(function(){
		monItmArr.push(this.id+"^"+$(this).val());
	});
	monItmList=monItmArr.join("||");

	//重点关注药物
	var tmpItmArr=[];
	/*
	var drugItems = $('#drugdg2').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm
		    tmpItmArr.push(tmp);
		}
	})
	*/
	//监护内容(填写的内容)
	var careContent=$("#GuideContent2").val();
	
	//重要化验结果
	var Imptres=$("#Imptres2").val();
	
	//记录人
	var UserDr=session['LOGON.USERID'];
	
	var levelDr="2";  //监护级别"二级"，对应Dr为2 
	
	//药学监护主信息
	var phaCareMasDataLis=levelDr+"^"+EpisodeID+"^"+PatWard+"^"+PatLoc+"^"+UserDr+"^"+careContent+"^"+Imptres;
	
	var rowid="";
	var input=phaCareMasDataLis+"!!"+scopeList+"!!"+monItmList+"!!"+tmpItmArr;
	
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?actiontype=SavePharCareInf',//提交到那里  
		data: "rowid="+rowid+"&"+"input="+input,//提交的参数  
		success:function(msg){ 
			if(msg!=0){
				alert("保存失败,失败状态码为"+msg);
			}else{           
				alert("保存成功");
				clearData();
			}       
		},    
		error:function(){        
			alert("保存失败");        
		}
	});
}

/**
* 提交保存三级药学监护内容
*/
function saveLevel3Info(){

	//监护范围列表
	var scopeArr=[];
	$("#rangetable3 input[type='checkbox']").each(function(){
		if ($(this).attr("checked")){
          	scopeArr.push(this.name);
		}	
	});
	scopeList=scopeArr.join("||");
	
	//监护项目列表	
	var monItmArr=[];
	$("#monitmtable3 input[name='monItems']").each(function(){
		monItmArr.push(this.id+"^"+$(this).val());	
	});
	monItmList=monItmArr.join("||");
	
	//重点关注药物
	var tmpItmArr=[];
	/*
	var drugItems = $('#drugdg3').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm
		    tmpItmArr.push(tmp);
		}
	})
	*/
	//监护内容(填写的内容)
	var careContent=$("#GuideContent3").val();
	
	//重要化验结果
	var Imptres=$("#Imptres3").val();
	
	//记录人
	var UserDr=session['LOGON.USERID'];
	
	var levelDr="3";  //监护级别"一级"，对应Dr为3 
	
	//药学监护主信息
	var phaCareMasDataLis=levelDr+"^"+EpisodeID+"^"+PatWard+"^"+PatLoc+"^"+UserDr+"^"+careContent+"^"+Imptres;
	
	var rowid="";
	var input=phaCareMasDataLis+"!!"+scopeList+"!!"+monItmList+"!!"+tmpItmArr;
	
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?actiontype=SavePharCareInf',//提交到那里  
		data: "rowid="+rowid+"&"+"input="+input,//提交的参数  
		success:function(msg){ 
			if(msg!=0){
				alert("保存失败,失败状态码为"+msg);
			}else{           
				alert("保存成功");
				clearData();
			}       
		},    
		error:function(){        
			alert("保存失败");        
		}
	});
}

function clearData(){
	window.location.reload();
}

/// 初始化病人的生命体征 bianshuai 2015-03-09
function InitPagePatObserver(EpisodeID)
{
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?action=GetPatVitalSigns',//提交到那里  
		data: "EpisodeID="+EpisodeID,//提交的参数  
		success:function(msg){
			var obj=eval('('+msg+')');
			if(obj){
				$("input[name=monItems]").each(function(){
					var tempstr=$(this).parent().html();
					var obserdesc=tempstr.substring(0,2).replace(/(^\s*)|(\s*$)/g,"");					
					if(typeof obj[obserdesc]!="undefined"){
						$(this).val(obj[obserdesc]); //填值
					}
				})
			}      
		},
		error:function(){        
			alert("取病人生命体征出错！");        
		}
	});
}