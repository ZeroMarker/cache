
/*
* 用药教育
* pengzhikun
*/
var url="dhcpha.clinical.action.csp";
var titleNote='<span style="font-weight:bold;">医嘱用药列表</span>';
var titleNotes='<span style="font-weight:bold;">出院带药列表</span>';
var EpisodeID="";
var choseFlag=""; 				 /// 出院患者加载出院带药标志 qunianpeng 2018/3/12

$(document).ready(function(){
	
	InitGuiScopeTableEDU();		/// 初始化入院指导范围 add  by yuliping // 指导范围改为动态加载 需要先加载完成后，才能赋值  qunianpeng  2018/3/19
	InitGuiScopeTableEDUI();	/// 初始化住院指导范围 add  by yuliping
	
	EpisodeID=getParam("EpisodeID")		/// 默认打开新入院患者界面 qunianpeng 2018/3/12
 	choseMenu("新入院患者");
	$('.easyui-accordion ul li a:contains("新入院患者")').css({"background":"#87CEFA"});		

	//根据点击明细显示窗口panel
	$('.easyui-accordion ul li a').click(function(){
		$('.easyui-accordion ul li a').css({"background":"#FFFFFF"});
		$(this).css({"background":"#87CEFA"});
		 var panelTitle = $(this).text();
		 //点击侧菜单的显示相应界面
		 choseMenu(panelTitle);
	});	
	pageBasicControll();
	initDataDG();	
})

function choseMenu(item){
	switch(item){
		case "新入院患者":
			//防止重复点击，而此时Flag=1，导致不执行创建界面
			if(Flag1==0){
				//隐藏mainpanel的所有子节点
				$("#mainPanel").children().css("display","none")
				//动态创建一个"新入院患者"的panel
				createPanel();
				//设置mainPanel可见
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;'>[红色*号标注的为必填项]</span>"
				});
			}
			
			break;
			
		case "住院期间患者":
			if(Flag2==0){
				//隐藏mainpanel的所有子节点
				$("#mainPanel").children().css("display","none")
				//动态创建一个"住院期间患者"的panel
				createInHopPanel();
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;'>[红色*号标注的为必填项]</span>"
				});
				//加载数据
				//loadData();
			}
			break;
			
		case "出院患者":
			if(Flag3==0){
				//隐藏mainpanel的所有子节点
				$("#mainPanel").children().css("display","none")
				//动态创建一个"住院期间患者"的panel
				createOutHopPanel();
				$('#mainPanel').css("display","block");
				$('#mainPanel').panel({
					title:item+"<span style='color:red;'>[红色*号标注的为必填项]</span>"
				});
				//加载数据
				//loadData();
			}
			break;
			
		default:
			break;	
	}
				 	
} 

//--创建"新入院患者"主界面--//
var Flag1=0;//防止重复点击，多次创建面板
function createPanel() {
	if(Flag1==0){
		//仅显示咨询主界面
		$("#content1").css("display","block");
		Flag1=1;
		Flag2=0;
		Flag3=0;
		//初始加载的病人信息
		InitPatientInfo(EpisodeID);
		
	}
} 

//加载报表默认信息
function InitPatientInfo(EpisodeID)
{
   if(EpisodeID==""){return;}
   
    //清空整个页面上的checkbox的选中状态
    $("input[type='checkbox']").each(function(){
	    $(this).attr("checked",false);
	});
   
   var medEduRid="";
   var medEduInfo=tkMakeServerCall("web.DHCPHMEDEDUCATION","getMedEducation",EpisodeID,"New");
   if(medEduInfo==""){
       InitNewPagePatInfo(EpisodeID);
       return;
   }
   LoadNewPagePatInfo(EpisodeID,medEduInfo);
}

//获取新入院患者查房记录信息
function LoadNewPagePatInfo(EpisodeID,medEduInfo)
{
  	var tmps=medEduInfo.split("!");
  	var listMain=tmps[0].split("^"); 		/// 主信息
  	
  	$('#NewRowId').val(listMain[18]);         	/// 表ID
	$('#newPatName').val(listMain[1]);		/// 患者姓名
	$('#newPatSex').val(listMain[3]);    	/// 性别
	$('#newPatAge').val(listMain[4]);    	/// 年龄
	$('#newPatMedRec').val(listMain[0]); 	/// 病案号
	$('#newPatTel').val(listMain[7]);    	/// 联系方式
	$('#newPatAddr').val(listMain[19]); 	/// 家庭地址
	$('#newPatBed').val(listMain[2])     	/// 床号
  	$('#BadHabits').val(listMain[12]);      /// 不良嗜好
  	$('#NewPatAdmInf').val(listMain[17]);   /// 入院诊断
  	$('#ConDisAndTre').val(listMain[13]);   /// 伴发疾病与用药情况
  	$('#NewPatGuidCont').val(listMain[16]); /// 备注
    
  	var GrantFlag=listMain[14];				/// GrantFlag--发放临床药师联系卡
  	$("input[type='radio'][name='GrantFlag']").each(function(){
	  	if($(this).val()==GrantFlag){
			$(this).attr("checked",true);
		}
	});
	
  	var GuidObject=listMain[15];			/// GuidObject--指导对象
  	$("input[type='radio'][name='GuidObject']").each(function(){
	  	if($(this).val()==GuidObject){
			$(this).attr("checked",true);
		}
	});
  
  	//设置勾选框的选中状态
  	var checkList=tmps[1].substring(0,tmps[1].length-1).split("^");
  	$("input[type='checkbox'][name='GuiContent']").each(function(){
       for(var i=0;i<checkList.length;i++){
           if($(this).val()==checkList[i]){
	       		$(this).attr("checked",true);		
	       }
       }
  	});
}

//获取病人基本信息
function InitNewPagePatInfo(EpisodeID)
{   
   $.ajax({type: "POST", url: url, data: "action=GetPatInfo&AdmDr="+EpisodeID, 
	   success: function(val){
			tmp=val.split("^");
			//病人信息
			//$('#patID').val(tmp[9]);		/// 病人ID
			$('#newPatName').val(tmp[1]);	/// 患者姓名
			$('#newPatSex').val(tmp[2]); 	/// 性别
			$('#newPatAge').val(tmp[3]); 	/// 年龄
			$('#newPatMedRec').val(tmp[0]); /// 病案号
			$('#newPatTel').val(tmp[14]);   /// 联系方式
			$('#newPatBed').val(tmp[4])     /// 床号
			$('#NewPatAdmInf').val(tmp[8])  /// 入院诊断
			$('#newPatAddr').val(tmp[15])   /// 入院病人地址  2016/09/14
			
	   }
   })
}

//--创建"住院期间患者"主界面--//
var Flag2=0;//防止重复点击，多次创建面板
function createInHopPanel(){
	if(Flag2==0){
		//仅显示咨询主界面
		$("#content2").css("display","block");
		Flag2=1;
		Flag1=0;
		Flag3=0;
		InitInPatientInfo(EpisodeID)
	}
}

//加载默认信息
function InitInPatientInfo(EpisodeID)
{
    if(EpisodeID==""){return;}
   //获取病人基本信息
    $.ajax({
		type: "POST",
		url: url,
		data:{action:'GetPatEssInfo',EpisodeID:EpisodeID},	/// nisijia 2016-09-21
		//dataType: "json",
    	success: function(jsonString){ 
     		var adrRepObj = jQuery.parseJSON(jsonString);     		
     		 $('#InPatSex').val(adrRepObj.patsex);    		/// 性别
     		 $('#InPatName').val(adrRepObj.patname);    	/// 姓名
     		 $('#InPatBed').val(adrRepObj.admbed);    		/// 床号
     		 $('#InPatMedRec').val(adrRepObj.patno);    	/// 登记号
	   		 $('#InPatAdmInf').val(adrRepObj.patdiag);    	/// 诊断		
  			}       
   });
    //清空整个页面上的checkbox的选中状态
    $("input[type='checkbox']").each(function(){
	    $(this).attr("checked",false);
	});
   
}


//--创建"出院患者"主界面--//
var Flag3=0;//防止重复点击，多次创建面板
function createOutHopPanel(){
	if(Flag3==0){
		//仅显示咨询主界面
		$("#content3").css("display","block");
		Flag3=1;
		Flag1=0;
		Flag2=0;
		/* $('a:contains("提交数据")').unbind("click");  /// qunianpeng 2016/10/11 绑定事件前先清空，防止多次绑定
		$('a:contains("打印单据")').unbind("click");
		
		$('a:contains("提交数据")').click(function(){  	 /// qnp 2017/03/08 绑定到csp中
			saveOutPatEduInf();
		})
		$('a:contains("打印单据")').click(function(){
			printMedEducation();
		}) */
		InitOutPatientInfo(EpisodeID);		
		choseFlag = "OUT";								/// 选中tab设置标志(出院患者医嘱界面要默认加载出院带药) qunianpeng 2018/3/12
	}	
}

//加载默认信息
function InitOutPatientInfo(EpisodeID)
{
   if(EpisodeID==""){return;}
   //获取病人基本信息
   $.ajax({
   	   type: "POST",
       url: url,
       data: "action=GetPatInfo&AdmDr="+EpisodeID,
       //dataType: "json",
       success: function(val){
		  tmp=val.split("^");		 
		  //病人信息
		  //$('#patID').val(tmp[9]);        //病人ID
		  $('#OutPatNo').val(tmp[0]);       //住院号
		  $('#OutPatName').val(tmp[1]);     //患者姓名
		  $('#OutPatSex').val(tmp[2]);      //性别
		  $('#OutPatAge').val(tmp[3]);      //年龄
		  $('#OutPatBed').val(tmp[4]);      //床号
		  $('#OutPatAdmInf').val(tmp[9]);   //出院诊断   //sufan 2016/09/14
		  $('#OutWUser').text(session['LOGON.USERNAME']);
       }
   });
    //$('#OutPatLoc').val(window.status.split("科室:")[1].split("-")[1]);     //科室
    //清空整个页面上的checkbox的选中状态
    $("input[type='checkbox']").each(function(){
	    $(this).attr("checked",false);
	});
   
    var medEduRid="";
   
    //获取新入院患者查房记录信息
    $.ajax({
   	   type: "POST",
  	   url: url,
   	   data: "action=getMedEducation&AdmDr="+EpisodeID+"&Status="+"Out",
       //dataType: "json",
       success: function(val){
	      if(val!=-999){
		  	var tmps=val.split("!");
		  	var listMain=tmps[0].split("^");	/// 主信息
		  	$('#OutRowId').val(listMain[18]);	/// 表ID
		  	$('#OutWUser').text(listMain[9]);	/// 临床药师

 		  	var listdate=listMain[10].split("-")  //sufan 2016/09/21
		  	$("#year").text(listdate[0]);
		  	$("#month").text(listdate[1]);
		  	$("#day").text(listdate[2]);
	      	$('#OutPatGuidCont').val(listMain[16]);  //指导意见
              var maxlimit=800;
		       if ($('#OutPatGuidCont').val().length >maxlimit){  
                   $('#OutPatGuidCont').val(($('#OutPatGuidCont').val().substring(0, maxlimit))); 
		       }else{ 
                 $('input[name="remLen1"]').val(maxlimit-$('#OutPatGuidCont').val().length);
		       }
		  	//获取查房记录ID，如果id不存在，即无查房记录，则不加载药品信息列表
		  	medEduRid=$('#OutRowId').val();
			if(medEduRid!=""){
				$.ajax({
   	   				type: "POST",
  	   				url: url,
   	   				data: "action=getMEDrgItm&medEduRid="+medEduRid,
      			 	//dataType: "json",
       				success: function(val){
	       				var obj = eval( "(" + val + ")" );
	       				
	       				$('#outdrugdg').datagrid('loadData',obj);
       				}
				})
			 } 				
          }
       }       
    }); 
   
}

function pageBasicControll(){
	
	//药师信息
	//$('#newPatDocLoc').val(window.status.split("科室:")[1].split("-")[1]) //科室
	$('#newPatDocLoc').val(LocDesc) 				/// 科室
	$('#newPatDoc').val(session['LOGON.USERNAME']) 	/// 临床药师
	//时间
	$("#newPatDate").datebox("setValue", formatDate(-1));
	
	//药师信息
	//$('#InPatDocLoc').val(window.status.split("科室:")[1].split("-")[1]) //科室
	$('#InPatDocLoc').val(LocDesc) 					/// 科室
	$('#InPatDoc').val(session['LOGON.USERNAME']) 	/// 临床药师
	$("#InPatDate").datebox("setValue", formatDate(-1));
	
	$('#OutPatLoc').val(LocDesc);    				/// 科室
	$('#OutPatGuidCont').focus(function(){
		if($(this).text()=="编辑内容.."){
			$(this).text("");
		}
	})
	$('#OutPatGuidCont').blur(function(){
		if($(this).text().trim()==""){
			$(this).text("编辑内容..");
		}
	})
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

//初始化界面datagrid显示
function initDataDG(){
	//定义columns
	var columns=[[
		{field:"orditm",title:'orditm',width:100,hidden:true},
	    {field:'incidesc',title:'名称',width:330,align:'left'},
		//{field:'genenic',title:'通用名',width:240,align:'left'},
		//{field:'manf',title:'生产企业',width:240,align:'left'},
		{field:'dosage',title:'剂量',width:40,align:'left'},		/// 增加剂量-是否执行 qunianpeng 2018/3/12
		{field:'instru',title:'用法',width:40,align:'left'},
		{field:'freq',title:'频次',width:60,align:'left'},
		{field:'duration',title:'疗程',width:40,align:'left'},
		{field:'execStat',title:'是否执行',width:50,align:'left',hidden:true},
	    {field:'dgID',title:'dgID',width:100,hidden:true},
		{field:'operation',title:'<a href="#" onclick="patOeInfoWindow()"><img style="margin-left:3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>',
		    width:30,
		    align:'center',
			formatter:SetCellUrl
		}
	]];
	
	//定义datagrid
	$('#drugdg').datagrid({
		title:titleNote, 
		url:'',
		height:165, //大于四行生成滚动条 duwensheng 2016-09-12
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,						/// 行号 
	    remoteSort:false,						/// 界面排序
		fitColumns:true,    					/// duwensheng 2016-09-12 自适应大小，防止横向滑动		
		loadMsg: '正在加载信息...',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            $("#drugdg").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	
	//定义datagrid
	$('#outdrugdg').datagrid({
		title:titleNotes,    
		url:'',
		height:165, 					/// 大于四行生成滚动条 duwensheng 2016-09-12
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,				/// 行号 
	    remoteSort:false,				/// 界面排序
		fitColumns:true,    			/// duwensheng 2016-09-12 自适应大小，防止横向滑动
		loadMsg: '正在加载信息...',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            $("#outdrugdg").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	InitdatagridRow();

}
/// 链接
function SetCellUrl(value, rowData, rowIndex)
{	
	//var dgID='"'+rowData.dgID+'"';
	if(Flag2==1){//lbb  住院之前患者
    var dgID='"'+'drugdg'+'"';
   }
   if(Flag3==1){//lbb   出院患者
   var dgID='"'+'outdrugdg'+'"';
   }
	return "<a href='#' onclick='delRow("+dgID+","+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}
//初始化列表使用
function InitdatagridRow()
{
	for(var k=0;k<4;k++)
	{
		$("#drugdg").datagrid('insertRow',{
			index: 0, 
			//row: {dgID:'drugdg',orditm:'',incidesc:'',genenic:'',genenicdr:'',manf:'',manfdr:'',spec:''}
			/// 增加药品信息相关列 qunianpeng 2018/3/12
			row: {dgID:'drugdg',orditm:'',incidesc:'',dosage:'',instru:'',freq:'',duration:'',execStat:''}

		});
		
		$("#outdrugdg").datagrid('insertRow',{
			index: 0, 
			//row: {dgID:'outdrugdg',orditm:'',incidesc:'',genenic:'',genenicdr:'',manf:'',manfdr:'',spec:''}
			/// 增加药品信息相关列 qunianpeng 2018/3/12
			row: {dgID:'drugdg',orditm:'',incidesc:'',dosage:'',instru:'',freq:'',duration:'',execStat:''}			

		});
	}
}


function delRow(datagID,rowIndex)
{
	var selItem=$( '#'+datagID).datagrid('getSelected');
	//如果选择的行号和删除按钮所在的行号一致，才删除
	//duwensheng 2016-09-13
	if(($( '#'+datagID).datagrid("getRowIndex",selItem)+1)==(rowIndex+1)){
		//行对象
    	var rowobj={
			//orditm:'', incidesc:'', genenic:'', manf:''			/// 增加药品信息相关列 qunianpeng 2018/3/12
			orditm:'',incidesc:'',dosage:'',instru:'',freq:'',duration:'',execStat:''
		};
	
		//当前行数大于4,则删除，否则清空
		//var selItem=$('#'+datagID).datagrid('getSelected');
		var rowIndex = $( '#'+datagID).datagrid('getRowIndex',selItem);
		if(rowIndex=="-1"){
			$.messager.alert("提示:","请先选择行！");
			return;
		}
		var rows = $( '#'+datagID).datagrid('getRows');
		if(rows.length>4){
		 	$( '#'+datagID).datagrid('deleteRow',rowIndex);
		}else{
			$( '#'+datagID).datagrid('updateRow',{
				index: rowIndex, // 行索引
				row: rowobj
			});
		}
	
		// 删除后,重新排序    duwensheng 2016-09-12 
		$( '#'+datagID).datagrid('sort', {	        
			sortName: 'incidesc',
			sortOrder: 'desc'
		});
	}
	else{
		alert("请选择正确行进行删除!")
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
		maximized:true						/// 最大化(qunianpeng 2018/3/12)

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
		{field:"moeori",title:'moeori',width:90,hidden:true},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'priorty',title:'优先级',width:80},
		{field:'StartDate',title:'开始日期',width:80},
		{field:'EndDate',title:'结束日期',width:80},
		{field:'incidesc',title:'名称',width:280},
		{field:'genenic',title:'处方通用名',width:160},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:'剂量',width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'用法',width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:'频次',width:40},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:'疗程',width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'form',title:'剂型',width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true},
		{field:'doctor',title:'医生',width:80},
		{field:'execStat',title:'是否执行',width:80},		/// 增加执行和发药 qunianpeng 2018/3/12
		{field:'sendStat',title:'是否发药',width:80},
		{field:'apprdocu',title:'批准文号',width:80},
		{field:'manf',title:'厂家',width:80}, 
		{field:'manfdr',title:'manfdr',width:80,hidden:true}

	]];
	
	//定义datagrid
 	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  			/// 每页显示的记录条数
		pageList:[15,30,45],    /// 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		rowStyler:function(index,row){
			if ((row.OeFlag=="D")||(row.OeFlag=="C")){
				return 'background-color:pink;';
			}
		},onClickRow:function(rowIndex, rowData){
			var flag=0;
			///获取当前行是否选中
			if($('tr[datagrid-row-index='+rowIndex+']').hasClass('datagrid-row-checked')){
				var flag=1;
			}

			///一组医嘱同时选择
			var items = $('#medInfo').datagrid('getRows');
			$.each(items, function(index, item){
				if(item.moeori==rowData.orditm){
					if(flag==1){
						$('#medInfo').datagrid('selectRow',index);
					}else{
						$('#medInfo').datagrid('unselectRow',index);
					}
				}
			})
		},
		queryParams:{
			params:EpisodeID,
			PriCode:choseFlag}
	});		
	$('#medInfo').datagrid('loadData', {total:0,rows:[]});	
}

function addWatchDrg(){
	if(Flag2==1){
		var rows = $('#drugdg').datagrid('getRows');
		var k=0;
		for(var i=0;i<rows.length;i++)
		{
			if(rows[i].orditm!=""){
				//break;
				k=k+1;
			}
		}
		//不选提示 duwensheng 2016-09-12
		var checkedItems = $('#medInfo').datagrid('getChecked');
		if(checkedItems==""){
		 $.messager.alert("提示:","请先选择药品！");
		 return;
		}
    	$.each(checkedItems, function(index, item){
	    	var rowobj={
				//orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     	//manf:item.manf, dgID:'drugdg'
		     	/// 替换列的内容 qunianpeng 2018/3/12
		    	orditm:item.orditm, incidesc:item.incidesc, dosage:item.dosage,instru:item.instru,freq:item.freq,
		     	duration:item.duration,execStat:item.execStat,dgID:'drugdg'

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
				$("#drugdg").datagrid('appendRow',rowobj);
			}else{
				$("#drugdg").datagrid('updateRow',{	//在指定行添加数据，appendRow是在最后一行添加数据
					index: k, // 行数从0开始计算
					row: rowobj
				});
			}
			k=k+1;
    	})
   	
	}else if(Flag3==1)
	 {
		//查房界面
		//用药列表
		
		var rows = $('#outdrugdg').datagrid('getRows');
		var k=0;
		for(var i=0;i<rows.length;i++)
		{
			if(rows[i].orditm!=""){
				//break;
				k=k+1;
			}
		}
		//不选提示 duwensheng 2016-09-12
		var checkedItems = $('#medInfo').datagrid('getChecked');
		if(checkedItems==""){
		 $.messager.alert("提示:","请先选择药品！");
		 return;
		}
    	$.each(checkedItems, function(index, item){
	    	var rowobj={
				//orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     	//manf:item.manf, dgID:'outdrugdg'
		     	/// 替换列 qunianpeng 2018/3/12
		     	orditm:item.orditm, incidesc:item.incidesc, dosage:item.dosage,instru:item.instru,freq:item.freq,
		     	duration:item.duration,execStat:item.execStat,dgID:'drugdg'
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
				$("#outdrugdg").datagrid('appendRow',rowobj);
			}else{
				$("#outdrugdg").datagrid('updateRow',{	//在指定行添加数据，appendRow是在最后一行添加数据
					index: k, // 行数从0开始计算
					row: rowobj
				});
			}
			k=k+1;
    	})
    	
	}
	$.messager.alert("提示:","添加成功");
	setTimeout(function(){
    	$(".messager-body").window('close');    
	},1000);
	//$('#mwin').window('close');
}

// 关闭用药列表窗口
function cancelWin()
{
	 $('#mwin').window('close');
}

///加载病人用药列表
function LoadPatMedInfo(priCode)
{
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID,
			PriCode:priCode}
	});
}

//保存"新入院患者"用药教育信息
function saveNewPatEduInf(){
	var CurStatus="New";
	var BadHabits=$('#BadHabits').val(); 		/// 不良嗜好
	var Icd=$('#NewPatAdmInf').val();    		/// 诊断
	var ConDisAndTre=$('#ConDisAndTre').val();  /// 伴发疾病与用药情况
	var modPhone=$('#newPatTel').val();    		/// 联系方式
	var address=$('#newPatAddr').val();    		/// 家庭地址
	
	var GrantFlag="";  							/// 发放临床药师联系卡
	$('input[type=radio][name=GrantFlag]').each(function(){
		if ($(this).attr("checked")){
			GrantFlag=$(this).val();
		}
	})
	
	var GuidObject="";  						/// 指导对象
	$('input[type=radio][name=GuidObject]').each(function(){
		if ($(this).attr("checked")){
			GuidObject=$(this).val();
		}
	})
	var GuiContentList=""; 						/// 患者用药指导内容
	$('input[type=checkbox][name=GuiContent]').each(function(){
		if ($(this).attr("checked")){
			GuiContentList+=$(this).val()+"||";
		}
	})
	if(GuiContentList!=""){
		GuiContentList=GuiContentList.substring(0,GuiContentList.length-2);
	}
	

	var NewPatGuidCont=$('#NewPatGuidCont').val(); /// 备注(具体指导明细)
	//sufan 2016/09/13
	if ((BadHabits=="")||(ConDisAndTre=="")||(GrantFlag=="")||(GuidObject=="")||(GuiContentList=="")||(NewPatGuidCont=="")){
		$.messager.alert("提示","记录不完整，请重新输入！");
		return;
		}

	//记录人
	var UserDr=session['LOGON.USERID'];

	var medEduMasDataList=EpisodeID+"^"+CurStatus+"^"+BadHabits+"^"+ConDisAndTre+"^"+GrantFlag+"^"+GuidObject+"^"+NewPatGuidCont+"^"+UserDr+"^"+Icd+"^"+modPhone+"^"+address;
	
	var rowid=$('#NewRowId').val()
	var medEduDrgItmList="";				 /// 用药情况
	
	var input=medEduMasDataList+"!"+GuiContentList+"!"+medEduDrgItmList;

	$.ajax({  
		type: 'POST',						 /// 提交方式 post 或者get  
		url: url+'?action=SaveMedEduInf',	 /// 提交到那里    sufan 2016/09/18
		data: "rowid="+rowid+"&"+"input="+input,/// 提交的参数  
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


//保存"住院期间患者"用药教育信息
function saveInPatEduInf(){
	var CurStatus="In";
	var BadHabits=""; 					/// 不良嗜好
	var Icd=$('#InPatAdmInf').val();   	/// 诊断
	var ConDisAndTre="";  				/// 伴发疾病与用药情况
	var GrantFlag="";  					/// 发放临床药师联系卡
	var GuidObject="";  				/// 指导对象
	$('input[type=radio][name=InGuidObject]').each(function(){
		if ($(this).attr("checked")){
			GuidObject=$(this).val();
		}
	})
	var GuiContentList=""; 				/// 患者用药指导内容
	$('input[type=checkbox][name=InGuiContent]').each(function(){
		if ($(this).attr("checked")){
			GuiContentList+=$(this).val()+"||";
		}
	})
	if(GuiContentList!=""){
		GuiContentList=GuiContentList.substring(0,GuiContentList.length-2);
	}
	
	var InPatGuidCont=$('#InPatGuidCont').val(); /// 备注(具体指导明细) 
	
	if ((GuidObject=="")||(GuiContentList=="")||(InPatGuidCont=="")){   //sufan 2016/09/13
		$.messager.alert("提示","记录不完整，请重新输入！");
		return;
		}
	//记录人
	var UserDr=session['LOGON.USERID'];

	var medEduMasDataList=EpisodeID+"^"+CurStatus+"^"+BadHabits+"^"+ConDisAndTre+"^"+GrantFlag+"^"+GuidObject+"^"+InPatGuidCont+"^"+UserDr+"^"+Icd;
	
	var rowid=$('#InPatEduRid').val();
	
	//重点关注药物
	var medEduDrgItmList=[] ;		/// 用药情况
	var drugItems = $('#drugdg').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm;
		    medEduDrgItmList.push(tmp);
		}
	})
	if (medEduDrgItmList==""){		/// sufan 2016/09/13
		$.messager.alert("提示","记录不完整，请重新输入！");
		return;
		}
	var input=medEduMasDataList+"!"+GuiContentList+"!"+medEduDrgItmList;
	
	$.ajax({  
		type: 'POST',							/// 提交方式 post 或者get   
		url: url+'?action=SaveMedEduInf',		/// 提交到那里    sufan 2016/09/18 
		data: "rowid="+rowid+"&"+"input="+input,/// 提交的参数  
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


//保存"出院患者"用药教育信息
function saveOutPatEduInf(){
	var CurStatus="Out";
	var BadHabits="";					/// 不良嗜好
	var Icd=$('#OutPatAdmInf').val();   /// 诊断
	var ConDisAndTre="";				/// 伴发疾病与用药情况
	
	var GrantFlag="";					/// 发放临床药师联系卡

	var GuidObject="";					/// 指导对象
	
	var GuiContentList="";				/// 患者用药指导内容
	
	var InPatGuidCont=$('#OutPatGuidCont').val();			  /// 备注(具体指导明细)
	if ((InPatGuidCont=="")||(InPatGuidCont=="编辑内容..")){  /// sufan 2016/09/13
		$.messager.alert("提示","记录不完整，请重新输入！");
		return;
		}
	//记录人
	var UserDr=session['LOGON.USERID'];

	var medEduMasDataList=EpisodeID+"^"+CurStatus+"^"+BadHabits+"^"+ConDisAndTre+"^"+GrantFlag+"^"+GuidObject+"^"+InPatGuidCont+"^"+UserDr+"^"+Icd;
	
	var medEduOutID=$('#OutRowId').val();
	
	//重点关注药物
	var medEduDrgItmList=[] ;		/// 用药情况
	var drugItems = $('#outdrugdg').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm;
		    medEduDrgItmList.push(tmp);
		}
	})
	
	var input=medEduMasDataList+"!"+GuiContentList+"!"+medEduDrgItmList;
	
	$.ajax({  
		type: 'POST',						/// 提交方式 post 或者get  
		url: url+'?action=SaveMedEduInf',	/// 提交到那里    sufan 2016/09/18
		data: "rowid="+medEduOutID+"&"+"input="+input,//提交的参数  
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

function query(){
	 $('#recordWin').window({
		title:'用药教育记录',	/// by qunianpeng 2017/1/05
		collapsible:true,
		border:false,
		closed:"true",
		width:600,
		height:520,
		minimizable:false		/// 隐藏最小化按钮(qunianpeng 2018/3/15)
		//maximized:true		/// 最大化
	}); 

	$('#recordWin').window('open');
	//起止时间
	$("#startDate").datebox("setValue", formatDate(-1));
	$("#endDate").datebox("setValue", formatDate(0));
	
	var stDate=$('#startDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	
	find_medEduGrid(stDate,endDate);
}


//病人的住院期间查房记录列表
function find_medEduGrid(stDate,endDate)
{
	
	//定义columns
	var columns=[[
		{field:"medEduID",title:'RowID',width:100},
		{field:'EDDate',title:'记录日期',width:200},
		{field:'EDUser',title:'记录人',width:200}
	]];
	
	//定义datagrid
	$('#MedEduRecord').datagrid({
		url:'',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  			/// 每页显示的记录条数
		pageList:[15,30,45],    /// 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		onClickRow:function() { /// 双击事件改为点击事件 by qnp 2017/1/5
    		var selected = $('#MedEduRecord').datagrid('getSelected'); 
    		if (selected){ 
      			//alert(selected.incirowid); 
      			$('#recordWin').window('close');
 		     	/*获取记录ID*/
				$('#InPatEduRid').val(selected.medEduID)
				$('#InPatGuidCont').val(selected.MEGuidContent)
				
				
				var GuidObject=selected.MEGuidObject; //GuidObject--指导对象
		  		$("input[type='radio'][name='InGuidObject']").each(function(){
			  		if($(this).val()==GuidObject){
						$(this).attr("checked",true);
					}
			    });
				
				
				//获取查房记录ID，如果id不存在，即无查房记录，则不加载药品信息列表
		  		var EduRid=$('#InPatEduRid').val();
				if(EduRid!=""){
					/*加载指导列表*/
					$.ajax({
   	   					type: "POST",
  	   					url: url,
   	   					data: "action=getGuidContList&EduRid="+EduRid,
      			 		//dataType: "json",
       					success: function(val){
	       					//设置勾选框的选中状态
	      					var checkList=val.substring(0,val.length-1).split("^");
	      					
	      					//设置勾选框的选中状态	      				
	      					$("input[type='checkbox'][name='InGuiContent']").each(function(){
		       					
		       					for(var i=0;i<checkList.length;i++){
		           					if($(this).val()==(checkList[i].trim())){
			       						$(this).attr("checked",true);		
			       					}
		       					}
		  					});
		  		
       					}
					});
					
					/*加载用药信息*/
					$.ajax({
   	   					type: "POST",
  	   					url: url,
   	   					data:"action=getMEDrgItm&medEduRid="+EduRid,
      			 		//dataType: "json",
       					success: function(val){
	       					var obj = eval( "(" + val + ")" );
	       					$('#drugdg').datagrid('loadData',obj);
       					}
					});
			 } 	
					
      		}
		}
	});

	$('#MedEduRecord').datagrid({		
		url:url+'?action=getMedEduRecord',	
		queryParams:{
			AdmDr:EpisodeID,
			Status:"In",
			startDate:stDate,
			endDate:endDate	
		}
	});
}

function queryByDate(){
	var stDate=$('#startDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	
	find_medEduGrid(stDate,endDate);
}

/// 打印出院用药教育
function printMedEducation()
{
	var medEduOutID=$('#OutRowId').val();
	print_medEducation(medEduOutID);
}

/// 打印在院用药教育
function printMedEducationIN()
{
	var medEduInID=$('#InPatEduRid').val();
	print_medEducationIN(medEduInID);
}
/// 打印新入院用药教育
function printMedEducationNew()
{
	print_medEducationNew(EpisodeID);
}
/// 打印全部用药教育
function printMedEducationAll(){
	PRINTCOM.jsRunServer(
	{
		ClassName: 'web.DHCPHMEDEDUCATION',
		MethodName: 'GetMedEducationIdS',
		admId: EpisodeID
	},
	function(retJson){
		if($.isEmptyObject(retJson)){
			$.messager.alert("提示","没有用药教育记录！");
			return;	
		}else{
			$.each(retJson, function(k, v){
				if(!v.Id){
					return true;	
				}
				if(v.status == "N"){
					print_medEducationNew(EpisodeID);	
				}else if(v.status == "I"){
					print_medEducationIN(v.Id);
				}else if(v.status == "O"){
					print_medEducation(v.Id);
				}	
			})	
		}
	})
}
      /// 初始化入院指导范围 add  by yuliping
function InitGuiScopeTableEDU(){
	
	//获取父节点
	/* var rtn=serverCall('web.DHCSTPHCMGuiScope','getGuiScopePatCode',
		{
			'ModType':"EDU",
			'SubModType':"N",
			'PatCode':""
	     }); */
	var rtn=tkMakeServerCall("web.DHCSTPHCMGuiScope","getGuiScopePatCode","EDU","N","");
	var htmlStr=""
	if(rtn==""){
		//父节点为空，提示信息
		 htmlStr= htmlStr+"<tr style='padding:2px;height:30px;'><td style='margin-left:10px;color:red'>请维护字典!</td>"
		}else{
		htmlStr= htmlStr+"<tr style='margin:4px;height:30px;'>";
		var flag=0;
		var rtnArr=rtn.split("!");
		for(var i=0;i<rtnArr.length;i++){
			var rtnArrs=rtnArr[i].split("^");
			htmlStr= htmlStr+"<td style='width:210px;'><span style='margin-left:10px;'><input value="+rtnArrs[2]+" type='checkbox' name='GuiContent' class='GuiScope'></input><span>"+ rtnArrs[1]+"</span></span></td>";
			flag+=1;
			if((flag%3)==0)
			{
				htmlStr= htmlStr+"</tr><tr style='margin:4px;'>";
				}
			}
			htmlStr= htmlStr+"</tr>";
		}
		htmlStr= htmlStr+"</tr>";
		//alert(htmlStr)
		$("#EDUN").append(htmlStr);
	}
/// 初始化住院指导范围 add  by yuliping
function InitGuiScopeTableEDUI(){
	
	//获取父节点
	/*var rtn=serverCall('web.DHCSTPHCMGuiScope','getGuiScopePatCode',
		{
			'ModType':"EDU",
			'SubModType':"I",
			'PatCode':""
	     });*/
	var rtn=tkMakeServerCall("web.DHCSTPHCMGuiScope","getGuiScopePatCode","EDU","I","");
	var htmlStr=""
	if(rtn==""){
		//父节点为空，提示信息
		 htmlStr= htmlStr+"<tr style='padding:2px;height:30px;'><td style='margin-left:10px;color:red'>请维护字典!</td>"
		}else{
		htmlStr= htmlStr+"<tr style='margin:4px;height:30px;'>";
		var flag=0;
		var rtnArr=rtn.split("!");
		for(var i=0;i<rtnArr.length;i++){
			var rtnArrs=rtnArr[i].split("^");
			htmlStr= htmlStr+"<td style='width:170px;'><span style='margin-left:10px;'><input value="+rtnArrs[2]+" type='checkbox' name='InGuiContent' class='GuiScope'></input><span>"+ rtnArrs[1]+"</span></span></td>";
			flag+=1;
			if((flag%4)==0)
			{
				htmlStr= htmlStr+"</tr><tr style='margin:4px;'>";
				}
			}
			htmlStr= htmlStr+"</tr>";
		}
		htmlStr= htmlStr+"</tr>";
		$("#EDUI").append(htmlStr);
	}
