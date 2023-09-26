/*
Creator:pengzhikun
CreatDate:2014-08-20
Description:用药咨询->添加咨询记录界面
*/
var url='dhcpha.clinical.action.csp' ;
var ageArray = [{ "val": "Y", "text": "年" }, { "val": "M", "text": "月" }];
var phrid="";
var choseFlag=0;  //选择咨询方式Flag  choseFlag=1 医生/护士   choseFlag=2 患者/家属
function BodyLoadHandler()
{
	/*
	$('#tabPanel').tabs({
		border:false,
		fit:true
	});
	
	$('#doctorUl').click(function(){
			
			if($('#tabPanel').tabs('exists',"医生/护士咨询")){
				 $('#tabPanel').tabs('select',"医生/护士咨询");
			}else{
				$('#tabPanel').tabs('add',{
		 	   	  title:'医生/护士咨询',
		 	  	  closable:true,
		 	   	  href:'dhcpha.clinical.doctoraskpage.csp'
		    });
		  }
			
	});
	
	$('#patientUl').click(function(){
			if($('#tabPanel').tabs('exists',"患者/家属咨询")){
				 $('#tabPanel').tabs('select',"患者/家属咨询");
			}else{
				$('#tabPanel').tabs('add',{
		 	   	  title:'患者/家属咨询',
		 	  	  closable:true
		 	   
		    });
		  }
	});
	*/

	
	
	
	//定义columns
	var columns=[[
		{field:"rowid",title:'ID',width:60},
	    {field:'incidesc',title:'药品名称',width:300,align:'left'},
	    {field:'genenic',title:'通用名',width:200,align:'left'},
		{field:'operation',title:'<a href="#" onclick="patOeInfoWindow()"><img style="margin-left:3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>',
		    width:30,
		    align:'center',
			formatter:SetCellUrl
		}
	]];
	
	//定义datagrid
	$('#drugdg').datagrid({
		title:"",    
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
            $("#drugdg").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	
	//定义datagrid
	$('#patdrugdg').datagrid({
		title:"",    
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
            $("#patdrugdg").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	//InitdatagridRow();
	
}

/*
//初始化列表使用
function InitdatagridRow()
{
	for(var k=0;k<4;k++)
	{
		$("#drugdg").datagrid('insertRow',{
			index: 0, 
			row: {rowid:'',incidesc:'',genenic:''}
		});
	}
}
*/
/// 链接
function SetCellUrl(value, rowData, rowIndex)
{	
	var dgID='"'+rowData.dgID+'"';
	return "<a href='#' onclick='delRow("+dgID+","+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}

// 删除行
function delRow(datagID,rowIndex)
{
	//行对象
    var rowobj={
		rowid:'', incidesc:'', genenic:''
	};
	
	var selItem=$('#'+datagID).datagrid('getSelected');
	var rowIndex = $('#'+datagID).datagrid('getRowIndex',selItem);
	if(rowIndex=="-1"){
		$.messager.alert("提示:","请先选择行！");
		return;
	}
	
	$('#'+datagID).datagrid('deleteRow',rowIndex);
	
}


//选择医生/护士咨询按钮
function doctorAskPage(){
	choseFlag=1;
	//隐藏所有子节点
	//$("#mainPanel").children().css("display","none");
	//动态创建一个"添加医生咨询记录"的panel
	createDoctorPanel();
	//加载数据
	loadDoctorPageData();
	
}

//--医生/护士咨询界面--//
function createDoctorPanel(){
	//仅显示医生/护士咨询界面
	//$("#docAskPanel").css("display","block");
	$('#docAskPanel').css("display","block");
	$('#docAskPanel').window({
		title:'医生/护士咨询界面',
		width:1200,
		height:620,
		modal:true
	});
		
}

function loadDoctorPageData(){
	$('#drugdg').datagrid('loadData',{total:0,rows:[]});
	//咨询人姓名
	$('#docName').combobox({
		url:url+'?actiontype=GetComboUser',
		//onShowPanel:function(){
			//$('#docName').combobox('reload',url+'?actiontype=GetComboUser')
		//},
		onLoadSuccess:function(){
		 	$('#docName').combobox('setValue',session['LOGON.USERID']);
		}
		//panelHeight:"auto",  //设置容器高度自动增长
		//url:url+'?actiontype=SelAllLoc' 
	});
	
	//$('#docName').combobox('setValue',session['LOGON.USERID']);
	
	//科室
	$('#dept').combobox({
		url:url+'?actiontype=SelAllLoc&loctype=E',
		onLoadSuccess:function(){
		 	$('#dept').combobox('setValue',session['LOGON.CTLOCID']); //设置combobox默认值
		}
		//onShowPanel:function(){
			//$('#dept').combobox('reload',url+'?actiontype=SelAllLoc&loctype=E')
		//}
		//panelHeight:"auto",  //设置容器高度自动增长
		//url:url+'?actiontype=SelAllLoc' 
	});
	
	
	//咨询类别
	$("#docContype").combobox({
		onShowPanel:function(){
			$('#docContype').combobox('reload',url+'?actiontype=GetComboPhConType')
		}
	});
	
	//问题类别
	$("#docContQuetype").combobox({
		onShowPanel:function(){
			$('#docContQuetype').combobox('reload',url+'?actiontype=GetComboPhConQueType')
		}
	})
	
	//录入时间
	$("#docAskDate").datebox("setValue", formatDate(-1));
	
	
	//咨询类别
	$("#drugdesc").combobox({
		
		onShowPanel:function(){
			alert($("#drugdesc").combobox('getText'));
			//$('#drugdesc').combobox('reload',url+'?actiontype=GetDrugByAlias')
		}
	});	
	
	//$('#drugNotice').bind('click',function(){
		//alert('hello');
	//})
}

/// 格式化日期
function formatDate(t)
{
	var curr_time = new Date();  
	var Year = curr_time.getFullYear();
	var Month = curr_time.getMonth()+1;
	var Day = curr_time.getDate()+parseInt(t);
	return Month+"/"+Day+"/"+Year;
}

//选择患者/家属咨询按钮
function patientAskPage(){
	choseFlag=2;
	//隐藏主面板的所有子节点
	//$("#mainPanel").children().css("display","none");
	//动态创建一个"添加患者/家属咨询记录"的panel
	createPatientPanel();
	//加载数据
	loadPatientPageData();	
}


//--患者/家属咨询界面--//
function createPatientPanel(){
	//仅显示患者/家属咨询界面
	//$("#patAskPanel").css("display","block");
	$('#patAskPanel').css("display","block");
	$('#patAskPanel').window({
		title:'患者/家属咨询界面',
		width:1200,
		height:620,
		modal:true
	});
	
	
	//输入登记号，回车获取病人基本信息	
	$('#patNo').bind('keypress',function(event){
		var keynum=event.keyCode||event.which;
		if(keynum==13){
			var input=$('#patNo').val();
			if(input.trim()==""||input.trim().length<8){
				alert('请输入完整病人登记号进行查询(8位数字)');
			}else{
				//$('#patNo').val("");
				getPatInfo(input);
			}
		}
	});	
		
}

//获取病人基本信息
function getPatInfo(input){
	$.ajax({  
			type: 'POST',//提交方式 post 或者get  
			url: url+'?actiontype=GetPatInf',//提交到那里 后他的服务  
			data: "input="+input,//提交的参数  
			success:function(msg){            
				//alert("保存成功");//弹出窗口，这里的msg 参数 就是访问aaaa.action 后 后台给的参数
				//showSpeCrdList(msg);
				showPatInfo(msg)      
			},    
			error:function(){        
				alert("获取数据失败!");
			}
		});
}

function showPatInfo(msg){
	/**
	* 清空页面上的保存的记录
	*/
	$('#patId').val("");
	$('#patName').val("");
	$('#patContact').val("");
	$('#sex input').each(function(){
		$(this).attr("checked",false);	
	});
	$('#age').val("")
	var obj = eval( "(" + msg + ")" ); //转换后的JSON对象
	var arrayJson=obj.rows;
	if(obj.rows.length==0){
		alert("改登记号不存在,或者改登记号下病人信息为空");
	}else{
		for(var i=0;i<arrayJson.length;i++){
			$('#patId').val(arrayJson[i].patId);
			$('#patName').val(arrayJson[i].patName);
			if(arrayJson[i].sex=="男"){
				$('#male').attr("checked",true);
			}else if(arrayJson[i].sex=="女"){
				$('#female').attr("checked",true);
			}else{
				$('#unknown').attr("checked",true);	
			}
			$('#patContact').val(arrayJson[i].tel);
			var ages=calAges(arrayJson[i].dob)
			if(ages!=""){
				var year=ages.split("-")[0];
				var month=ages.split("-")[1];
				if(year!=""){
					$('#age').val(year);
				}else{
					$('#ageUom').combobox('setValue',"M");
					if(month=0){
						//不足一个月的按一个月显示
						$('#age').val(1);
					}else{
						$('#age').val(month);
					}
				}
			}
		}
	}
}

//通过出生日期计算年龄 str="1989-08-08"
function calAges(str)   
  {   
        var r = str.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);     
        if(r==null)return   false;     
        var d = new Date(r[1],r[3]-1,r[4]);     
        if(d.getFullYear()==r[1]&&(d.getMonth()+1)==r[3]&&d.getDate()==r[4])   
        {   
             var Y =new Date().getFullYear();
	      	 var M =new Date().getMonth();  
	      	 //(Y-r[1])年   (M-r[3]+1)月
             return((Y-r[1])+"-"+(M-r[3]+1));   
        }   
        return "";   
  }

//获取特殊人群列表,并动态显示
function GetSpCrdList(){
	$.ajax({  
			type: 'POST',//提交方式 post 或者get  
			url: url+'?actiontype=GetSpCrdList',//提交到那里 后他的服务  
			//data: "input="+input,//提交的参数  
			success:function(msg){            
				//alert("保存成功");//弹出窗口，这里的msg 参数 就是访问aaaa.action 后 后台给的参数
				showSpeCrdList(msg);       
			},    
			error:function(){        
				alert("获取数据失败!");
			}
		}); 
}


function loadPatientPageData(){
	$('#patdrugdg').datagrid('loadData',{total:0,rows:[]});
	//加载特殊人群列表
	GetSpCrdList();
	//年龄单位
	$('#ageUom').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:ageArray 
	});
	$('#ageUom').combobox('setValue',"Y"); //设置combobox默认值
	
	//咨询类别
	$("#patContype").combobox({
		onShowPanel:function(){
			$('#patContype').combobox('reload',url+'?actiontype=GetComboPhConType')
		}
	})
	//问题类别
	$("#patConQuetype").combobox({
		onShowPanel:function(){
			$('#patConQuetype').combobox('reload',url+'?actiontype=GetComboPhConQueType')
		}
	})
	//录入时间
	$("#patAskDate").datebox("setValue", formatDate(-1));
}

function showSpeCrdList(msg){
	var id=$('#speCrowd');
	removeAllAnswer(id);
	var obj = eval( "(" + msg + ")" ); //转换后的JSON对象
	var arrayJson=obj.rows;
	for(var i=0;i<arrayJson.length;i++){
		$('<input />',{
			type:"checkbox",
			value:arrayJson[i].rowid
		}).insertBefore($('<label />',{text:arrayJson[i].desc}).appendTo('#speCrowd'));
	}

}

function removeAllAnswer(id){
	id.children().remove();
}


//提交保存 --医生/护士咨询明显
function saveDocQuetion(){
	var docNameDr=$('#docName').combobox('getValue');
	var deptDr=$('#dept').combobox('getValue');
	var docContypeDr=$('#docContype').combobox('getValue');
	var askDate=$('#docAskDate').datebox('getValue');
	var docContQuetypeDr=$('#docContQuetype').combobox('getValue');
	var questionDesp=$('#DocquestionDesp').val();
	var userType="1" //--医生/护士
	
	var stuData=$('#drugdg').datagrid("getData"); 
	var length=stuData.rows.length;
	var drugIds="";
	for(var i=0;i<length;i++){
		drugIds=drugIds+stuData.rows[i].rowid+"^"
		
	}
	//var drugs=$('#drugs').val().split("^");
	//var drugIds="";
	//if(drugs.length>0){
		//for(var i=1;i<drugs.length;i++){
		
			//drugIds=drugIds+drugs[i].split("-")[0]+"^"
		//}
	//}
	
	//医生/护士咨询时,"特殊人群，慢性病，备注"这属于病人的均插入空
	var input=docNameDr+"^"+deptDr+"^"+docContypeDr+"^"+docContQuetypeDr+"^"+askDate+"^"+questionDesp+"^"+userType+"^"+""+"^"+""+"^"+""+"||"+drugIds
	//alert(input);
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?actiontype=SaveQuestion',//提交到那里 后他的服务  
		data: "input="+input,//提交的参数  
		success:function(){            
			alert("保存成功");//弹出窗口，这里的msg 参数 就是访问aaaa.action 后 后台给的参数         
		},    
		error:function(){        
			alert("保存失败");        
		}
	});
	       
	
}


//提交保存 --患者/家属咨询明显
function savePatQuetion(){
	//病人id
	var patId=$('#patId').val();
	//特殊类型
	var inputs=$("#speCrowd input");
	var ckValueList="";
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].checked==true){
			//alert(inputs[i].value)
			ckValueList+=inputs[i].value+"||"
		}		
	}
	
	//ckValueList="1||2||",如果不为空，将其转化为"1,2"
	if(ckValueList!=""){
		var length=ckValueList.split("||").length;
		ckValueList=ckValueList.split("||",length-1);
	}
	
	var chrDis=$('#ChrDise').val();   //慢性病
	var remarks=$('#remark').val();   //备注
	var patContypeDr=$('#patContype').combobox('getValue');
	var askDate=$('#patAskDate').datebox('getValue');
	var patContQuetypeDr=$('#patConQuetype').combobox('getValue');
	var questionDesp=$('#questionDespPat').val();
	var userType="2" //--患者/家属
	
	var stuData=$('#patdrugdg').datagrid("getData"); 
	var length=stuData.rows.length;
	var drugIds="";
	for(var i=0;i<length;i++){
		drugIds=drugIds+stuData.rows[i].rowid+"^"
		
	}
	/*
	var drugs=$('#patientDrugs').val().split("^");
	var drugIds="";
	if(drugs.length>0){
		for(var i=1;i<drugs.length;i++){
		
			drugIds=drugIds+drugs[i].split("-")[0]+"^"
		}
	}*/
	
	var input=patId+"^"+""+"^"+patContypeDr+"^"+patContQuetypeDr+"^"+askDate+"^"+questionDesp+"^"+userType+"^"+ckValueList+"^"+chrDis+"^"+remarks+"||"+drugIds;
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?actiontype=SaveQuestion',//提交到那里 后他的服务  
		data: "input="+input,//提交的参数  
		success:function(){            
			alert("保存成功");//弹出窗口，这里的msg 参数 就是访问aaaa.action 后 后台给的参数         
		},    
		error:function(){        
			alert("保存失败");        
		}
	}); 
	  
	
}

//弹出查询药品框
function popDrugInfoWin(){
	$('#popDrugWindow').css("display","block");
	$('#popDrugWindow').window({
		width:600,
		height:500,
		modal:true
	});
	$('#drugalias').bind('keypress',function(event){
			var keynum=event.keyCode||event.which;
			if(keynum==13){
				var input=$('#drugalias').val();
				if(input.trim()==""||input.trim().length<3){
					alert('输入别名进行查询(请输入超过3个字符)');
				}else{
					$('#drugalias').val("");
					showDrug(input);
				}
			}
	})
	
}


//点击查询药品按钮
function searchDrugByAlias(){
	var input=$('#drugalias').val();
	if(input.trim()==""||input.trim().length<3){
		alert('输入别名进行查询(请输入超过3个字符)');
	}else{
		showDrug(input);
		//$('#drugalias').val()="";
	}
	
}

//显示药品列表
function showDrug(input){
	$('#druggrid').datagrid({  
		border:false,
		url:url+'?actiontype=FindDrugs&input='+input,
		rownumbers:true,
		striped: true,
		//pageList : [10, 20, 30],   // 可以设置每页记录条数的列表
		//pageSize : 10 ,  // 每页显示的记录条数
		fitColumns:true,
		//sortName: "rowid", //初始化表格时依据的排序 字段 必须和数据库中的字段名称相同
		//sortOrder: "asc",
		fit: true,
		loadMsg: '正在加载信息...',
		singleSelect:true,
		columns:[[     			  
			{field:'incirowid',title:'Rowid',width:50},
			{field:'incidesc',title:'药品描述',width:160},
			{field:'genericdesc',title:'药品通用名',width:120}
	
		]],
		onDblClickRow:function() { 
    		var selected = $('#druggrid').datagrid('getSelected'); 
    		if (selected){ 
      			//alert(selected.incirowid); 
      			$('#popDrugWindow').window('close');
      			
      			if(choseFlag==1){
      				//$('#drugs').val($('#drugs').val()+"^"+selected.incirowid+"-"+selected.incidesc)
      				var rowobj={
						rowid:selected.incirowid, incidesc:selected.incidesc, genenic:selected.genericdesc, 
		    			dgID:'drugdg'
					}
					$("#drugdg").datagrid('appendRow',rowobj);
					
      			}else if(choseFlag==2){
	      			var rowobj={
						rowid:selected.incirowid, incidesc:selected.incidesc, genenic:selected.genericdesc, 
		    			dgID:'patdrugdg'
					}
					$("#patdrugdg").datagrid('appendRow',rowobj);
	      			//$('#patientDrugs').val($('#patientDrugs').val()+"^"+selected.incirowid+"-"+selected.incidesc)
	      		}
			} 
		} 
		//pagination: true
		
		//queryParams: {
			//action:'FindResults'
			//input:""
		//}

	});
	
	//设置分页控件   
	//$('#druggrid').datagrid('getPager').pagination({
		//showPageList:false,
		//beforePageText: '第',//页数文本框前显示的汉字 
		//afterPageText: '页    共 {pages} 页',   
		//displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录'
	//});
}

//过滤掉输入文本信息中空格
String.prototype.trim=function(){
	return this.replace(/(^\s*)|(\s*$)/g,"");
}
