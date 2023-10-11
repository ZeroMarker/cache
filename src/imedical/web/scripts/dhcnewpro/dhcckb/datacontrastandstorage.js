/// Author:      guozizhu
/// CreateDate:  2019-09-30
/// Descript:    临床知识库与His的数据对照存储
/// CSP:         dhcckb.datacontrastandstorage.csp
/// JS:          datacontrastandstorage.js

var dicID="";									// 字典id
var dicCode="";							// 字典代码
var libCode="";
var hisCode="";
var libDesc="";							//知识库描述 sufan2020-07-10 由于早期数据code有重复情况，增加描述和code双重过滤
var stopFlag=""     		//停用标记-数据映射查询用
var redictext=""						//重定向text
var comparedata=""  		//对照数据id
var selHospId = "";			//院区  sufan 2020-07-16
var hisID="";
$(function(){
	//初始化界面默认信息
	initDefault();
	
	//事件初始化
	initEvent();
	
	//初始化界面样式
	initPageStyle();
})

/// 药品类型
function InitParams(){
	
	var drugType = getParam("DrugType");	
	return drugType;

}

/// 初始化界面默认信息
function initDefault(){
	//初始化LookUp
	initLookUp();
	
	//初始化DataGrid
	initDataGrid();
}

/// 事件初始化
function initEvent(){
	//点击事件绑定
	$('#genSearch').bind("click",QueryLibList);
    $('#genRefresh').bind("click",clearGen);
	$('#hisSearch').bind("click",QueryHisList);
    $('#hisRefresh').bind("click",clearHis);
    $('#resetCompare').bind("click",resetCompare);
    $('#openDataType').bind("click",openDataType);
    $('#condata').bind("click",condata);			//批量数据对照  sufan2020-12-24
	$('#deleteAllContrast').bind("click",deleteAllContrast);  		//xww 2021-07-06 删除所有选中的
	//回车事件绑定
	$('#genDesc').bind("keyup",function(event){
		if(event.keyCode == "13"){
			QueryLibList();
		}
	});
	$('#hisDesc').bind("keyup",function(event){
		if(event.keyCode == "13"){
			QueryHisList();
		}
	});
	
	///是否匹配
	$('.hisui-radio').radio({onCheckChange:function(){
			var matchval = $(this).attr("value");
			if (dicCode == ""){
				return;
			}	
			setTimeout("QueryHisList()",600);  //yuliping 给核对、未核对切换预留时间
			
	}})
	///控制核对、未核对只能选中一个
	$("input[name='hischeck']").bind('click', function() {
			var id = $("input[name='hischeck']").not(this).attr("id")
            $('#'+id).checkbox('uncheck')
      });
           	
	///是否匹配 xww 2021-08-26
	$('#genMatch').checkbox({onCheckChange:function(){
		if (dicID == ""){
			return;
		}
		QueryLibList()
	}})

}


//清屏临床知识库数据
function clearGen(){
	$('#genType').val("");
	$('#genDesc').val("");
	$('#genGrid').datagrid('loadData',{total:0,rows:[]});  // 用空数据填充datagrid
	$('#genGrid').datagrid('unselectAll');  // 清空列表选中数据 
	$('#HospId').combobox('clear');
	dicID="";
	dicCode="";
	$HUI.checkbox("#stopFlag").uncheck();
	$HUI.checkbox("#genMatch").uncheck();
}

//清屏His数据
function clearHis(){
	$('#hisDesc').val("");
	$('#hisGrid').datagrid('load',{total:0,rows:[]}); 
	$HUI.checkbox("#hismatch").uncheck();
	$HUI.checkbox("#hischeck").uncheck();
	$HUI.checkbox("#hischeckno").uncheck();
	//QueryHisList();
}

/// 初始化LookUp
function initLookUp(){
	// 初始化类型框
	var genType = $("#genType").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'CDRowID',
        textField:'CDDesc',
        columns:[[
        	{field:'CDRowID',title:'CDRowID',hidden:true},
            {field:'CDCode',title:'代码',width:190},
			{field:'CDDesc',title:'描述',width:190}
        ]], 
        pagination:true,
        panelWidth:420,
        isCombo:true,
        minQueryLen:2,
        delay:'200',
        queryOnSameQueryString:false,
        //queryParams:{ClassName: 'web.DHCCKBGenItem',QueryName: 'GetTypeList'},
        queryParams:{ClassName: 'web.DHCCKBComContrast',QueryName: 'QueryDictionList',drugType:InitParams()},	// 替换为方法 qunianpeng 2020/3/27
	    onSelect:function(index, rec){
		    if (rec["CDCode"] == "DiseaseData") {
			   var linkurl = "dhcckb.diagconstants.csp";
			   linkurl += ("undefined"!==typeof websys_getMWToken)?"?MWToken="+websys_getMWToken():""; 
			   window.open (linkurl, 'newwindow','width='+(window.screen.availWidth-10)+',height='+(window.screen.availHeight-30)+ ',top=0,left=0,resizable=yes,status=yes,menubar=no,scrollbars=no');
			}
			else{
				setTimeout(function(){
				    dicID = rec["CDRowID"];
			    	dicCode = rec["CDCode"];
				  	QueryLibList();
				  	QueryHisList();
				  	hisCode="";
				  	QueryContrastList();
				});
			}		   
		}
    });
    
    ///新增院区sufan 2020-07-15
    var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
    $HUI.combobox("#HospId",{
	     url:uniturl,
	     valueField:'value',
						textField:'text',
						panelHeight:"150",
						mode:'remote',
						onSelect:function(ret){
								QueryHisList();
								QueryContrastList();
						}
	   })
}

///初始化DataGrid
function initDataGrid(){
	//初始化知识库表
	
	// 重新知识库字典加载 start qunianpeng 2020/3/29
	// 定义columns
	var columns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'check',title:'sel',checkbox:true},  //xww 2021-08-13
			{field:'CDCode',title:'代码',width:100,sortable:true,align:'left'},
			{field:'CDDesc',title:'描述',width:100,align:'left'},
			{field:'Parref',title:'父节点id',width:100,align:'left',hidden:true},
			{field:'ParrefDesc',title:'父节点',width:100,align:'left',hidden:true},
			{field:'CDLinkDr',title:'关联',width:100,align:'left',hidden:true},
			{field:'CDLinkDesc',title:'关联描述',width:100,align:'left',hidden:true},
			{field:'KnowType',title:"数据类型",width:100,align:'left',hidden:true}					
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		//singleSelect:true,  //xww 2021-08-13	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		remoteSort:false,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(index,row) {    
 			libCode = row.CDCode;
 			libDesc = row.CDDesc;		//sufan 2020-07-10 增加取desc和code双重过滤，code存在重复情况
 			hisCode="";
    		QueryContrastList();
        },		
        onLoadSuccess:function(data){
           $(this).prev().find('div.datagrid-body').prop('scrollTop',0);              
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+dicID+"&parrefFlag=0&parDesc="+""+"&loginInfo="+LoginInfo+"&dataMirFlag="+stopFlag;
	new ListComponent('genGrid', columns, uniturl, option).Init();
	//end qunianpeng 2020/3/29
	
	//初始化HIS表
	/**
	 * 定义HIS表的columns
	 */
	var hiscolumns=[[
		{field:'check',title:'sel',checkbox:true},
		{field:'HisRowID',title:'RowID',width:150,hidden:true},
	  	{field:'HisCode',title:'代码',width:150},
	  	{field:'HisDesc',title:'描述',width:250},
	  	{field:'ConstrastFlag',title:'标记',width:100,
	  		formatter:function(value,row,index){
		  		return 	value=="1"?"对照":"未对照"
		  	}
		},	  	
	  	{field:'opt',title:'操作',width:50,align:'center',hidden:true,
			formatter:function(){
				var btn =  '<img class="contrast mytooltip" title="对照" onclick="conMethod()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png" style="border:0px;cursor:pointer">'   
				return btn;  
			}  
      	}
	]];
	
	/**
	 * 定义HIS表的datagrid
	 */
	var hisGrid = $HUI.datagrid("#hisGrid",{
        url:$URL,
        queryParams:{
	        ClassName:"web.DHCCKBComContrast", 	// qunianpeng 替换类 2020/3/29
            QueryName:"QueryHisDataList",
            hospital:LgHospDesc,
            type:dicCode,
            queryCode:""
	    },
        columns: hiscolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onClickRow:function(index,row) {    
 			hisCode = row.HisCode;
 			libCode="";
    		QueryContrastList();
        },	
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },
        onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
        }
    });
    $('#hisGrid').datagrid('loadData',{total:0,rows:[]});  // 用空数据填充datagrid
    
    //初始化对照关系表
	/**
	 * 定义对照关系表的columns
	 */
	var contrastcolumns=[[
		{field:'CCRowID',title:'id',width:100,hidden:true,sortable:true},
		{field:'check',title:'sel',checkbox:true},   //xww 2021-07-06
        {field:'CCLibCode',title:'知识库代码',width:100,sortable:true},
        {field:'CCLibDesc',title:'知识库描述',width:100,sortable:true,formatter:function(value,rowdata){ 
        	if(rowdata.confirmConsFlag==1)
        	{
				var res =  '<span style="color:red;">'+rowdata.CCLibDesc+'</span>'
				return res;  
			}else
			{
				return rowdata.CCLibDesc;
			}}
			},
        {field:'CCHisCode',title:'His代码',width:100,sortable:true},
        {field:'CCHisDesc',title:'His描述',width:100,sortable:true},
        {field:'hospDesc',title:'医院',width:100,sortable:true},
        {field:'CCDicTypeDesc',title:'实体类型',width:100,sortable:true,hidden:true},
        {field:'opt',title:'操作',width:50,align:'center',hidden:true,
			formatter:function(){ 
				var btn =  '<img class="contrast" onclick="delContrast()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;cursor:pointer">' 
				return btn;  
			}  
        }
	]];
	
	/**
	 * 定义对照关系表的datagrid
	 */
	var congrid = $HUI.datagrid("#contrastGrid",{
		toolbar:'#resetToolbar',
        url:$URL,
        queryParams:{
	        ClassName:"web.DHCCKBComContrast",
			QueryName:"QueryContrastList",
			type:dicID,
			queryLibCode:"",
			queryHisCode:"",
			loginInfo:LoginInfo
	    },
        columns: contrastcolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        //singleSelect:true,
        idField:'CCRowID',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        //toolbar:[],//表头和数据之间的缝隙
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动  
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },
        onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
        }
    });
     $('#contrastGrid').datagrid('loadData',{total:0,rows:[]});  // 用空数据填充datagrid
}

//对照，1对1
function conMethod()
{
	setTimeout(function(){
		var CDType = $("#genTypeID").val();
		var record=$('#genGrid').datagrid('getSelected');
		var hisRecord=$('#hisGrid').datagrid('getSelected');

		if(!record)
		{
			$.messager.alert('错误提示','请先选择一条临床知识库数据再进行对照！',"error");
			return;
		}
		var ids=record.CDCode+'^'+record.CDDesc+'^'+hisRecord.HisCode+'^'+hisRecord.HisDesc+'^'+dicID;
		var Hospt = $HUI.combobox("#HospId").getValue();
		runClassMethod("web.DHCCKBComContrast","SaveContrastData",{"listdata":ids,"loginInfo":LoginInfo,"clientIP":ClientIPAdd,"selHospId":Hospt},function(jsonString){
			//var jsonString=eval('('+jsonString+')'); 
			if (jsonString == '0') {
				$.messager.popover({msg: '对照成功！',type:'success',timeout: 1000});
			}
			else{
				var errorMsg ="对照失败！"
				/*if (jsonString.info) {
					errorMsg =errorMsg+ '<br/>' + jsonString.info;
				}*/
				$.messager.alert('操作提示',errorMsg+"错误代码:"+jsonString,"error");				
			}
			QueryHisList();
			QueryContrastList();
		},'text',false);
		
	},100);
}	

function delContrast(){
	setTimeout(function(){
		var contrastrecord=$('#contrastGrid').datagrid('getSelected');
		if(contrastrecord){
			var record=$('#genGrid').datagrid('getSelected');
			$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
				if (r){
					var rowid = contrastrecord.CCRowID;
					runClassMethod("web.DHCCKBComContrast","DeleteContrastData",{"rowid":rowid},function(jsonString){
						var jsonString=eval('('+jsonString+')'); 
						if (jsonString.success == 'true') {
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});												
						}
						else { 
							var errorMsg ="删除失败！"
							if (jsonString.info) {
								errorMsg =errorMsg+ '<br/>' + jsonString.info;
							}
							$.messager.alert('操作提示',errorMsg,"error");
						} 
						QueryHisList();
						QueryContrastList();
					},"text",false);
				}
			})
		}	
	},100)
}

/// qunianpeng 2020/3/29
/// 查询知识库字典数据
function QueryLibList()
{
	stopFlag = $HUI.checkbox("#stopFlag").getValue(); //选择停用标志 sunhuiyong 2020-04-09
	if(dicID==""){
		$.messager.alert('操作提示',"请选择一个类型","info");
		return;
	}
	var genDesc = $('#genDesc').val();  // 临床知识库描述
	var genMatch = $HUI.checkbox("#genMatch").getValue(); //xww 未匹配项 2021-08-26
	$('#genGrid').datagrid('load',{
		id:dicID,
		parrefFlag:0,
		parDesc:genDesc,
		loginInfo:LoginInfo,
		dataMirFlag:stopFlag,
		genMatchFlag:genMatch  //xww 2021-08-26 安全用药库未匹配标志
	}); 
	$('#genGrid').datagrid('unselectAll');  // 清空列表选中数据 	
}

/// qunianpeng 2020/3/29
/// 查询his字典数据
function QueryHisList()
{
	if(dicCode==""){
		$.messager.alert('操作提示',"请选择一个类型","info");
		return;
	}
	
	var hisDesc = $('#hisDesc').val();  // His描述
	var selHospId = $HUI.combobox("#HospId").getValue();			//取医院Id  sufan 2020-07-16
	if(selHospId == ""){
			selHospId = LgHospID;
	}
	var matchtype = $HUI.checkbox("#hismatch").getValue();
	var hischeck =""
	$("input[name='hischeck']:checked").each(function(i){
		hischeck=$(this).val()
	})
	$('#hisGrid').datagrid('reload',{
		ClassName:"web.DHCCKBComContrast",
		QueryName:"QueryHisDataList",
		hospital:selHospId,	//LgHospDesc
		type:dicCode,
		queryCode:hisDesc,
		matchtype:matchtype,
		hischeck:hischeck
	}); 

	$('#hisGrid').datagrid('unselectAll');  // 清空列表选中数据 	
}

/// qunianpeng 2020/3/29
/// 查询对照数据
function QueryContrastList()
{
	var selHospDesc = $HUI.combobox("#HospId").getText();			//取医院名称  wangxin 2020-10-23
	$('#contrastGrid').datagrid('load',  {
		ClassName:"web.DHCCKBComContrast",
		QueryName:"QueryContrastList",		
		 type:dicID, 
		 queryLibCode:libCode,
		 queryHisCode:hisCode,
		 loginInfo:LoginInfo,
		 selHospDesc:selHospDesc, //wangxin 2020-10-12 新增desc参数
		 queryLibDesc:libDesc			//sufan 2020-7-10 新增desc参数
    });
    
    $('#contrastGrid').datagrid('unselectAll');  // 清空列表选中数据 	
}
/// Sunhuiyong 2020-04-09
/// 对照数据重定向
function resetCompare()
{
	var rowsData = $("#contrastGrid").datagrid('getSelected'); //选中要修改的行
	if (rowsData != null) {	
		comparedata = rowsData.CCRowID;
		$HUI.dialog("#resetcompare").open();
	/// 初始化combobox
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'id',
		textField:'text',		
        onSelect:function(option){
        redictext = option.text;  //选择指向字典id
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+dicID+"&parrefFlag=0";
	new ListCombobox("newcomparedata",url,'',option).init(); 

	
	}else{
		 $.messager.alert('提示','请选择要修改的对照数据！','warning');
		 return;		
}	
}
///重置指向字典-保存
function SaveReCompareData()
{
	
	if(redictext==""){
		$.messager.alert("提示","请选择重定指向数据！",'info');
		return;
	}
	runClassMethod("web.DHCCKBDiction","ResetCompareData",{"CompareDataID":comparedata,"ResetData":redictext},
        	function(data){
            	if(data==0){
	            	$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
	            	$("#contrastGrid").datagrid('reload');
	            	$HUI.dialog("#resetcompare").close();
	            	return false;
	           	}else{
				       $.messager.popover({msg: '移动修改失败！',type:'success',timeout: 1000});
				       $HUI.dialog("#resetcompare").close();
	            	   return false;
		       		 }
	 })
		
}

/// Sunhuiyong 2020-04-09
/// 对照数据重定向
function openDataType()
{
	hisID="";
	var rowsData = $("#hisGrid").datagrid('getSelected'); //选中要修改的行
	if (rowsData != null) {	
		hisID = rowsData.HisRowID;
		$HUI.dialog("#DataTypeDialog").open();
	/// 初始化combobox
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
        redictext = option.text;  //选择指向字典id
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr=KnowType&extraAttrValue=DictionFlag";
	new ListCombobox("ExtDateType",url,'',option).init(); 

	
	}else{
		 $.messager.alert('提示','请选择HIS数据！','warning');
		 return;		
}	
}
///重置指向字典-保存
function updateDataType()
{
	
	var dataTypeID=$("#ExtDateType").combobox('getValue');
	if(dataTypeID==""){
		$.messager.alert("提示","请选择字典类型！","info");
		return;
	}
	//alert(dataTypeID+" "+hisID);
	//return;
	runClassMethod("web.DHCCKBComContrast","UpdateDataType",{"DataTypeID":dataTypeID,"HisID":hisID},
        	function(data){
            	if(data==0){
	            	$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
	            	$("#hisGrid").datagrid('reload');
	            	$HUI.dialog("#DataTypeDialog").close();
	            	return false;
	           	}else{
				       $.messager.popover({msg: '移动修改失败！',type:'success',timeout: 1000});
				       $HUI.dialog("#DataTypeDialog").close();
	            	   return false;
		       		 }
	 })
		
}

///数据批量对照
function condata()
{
	
/*	setTimeout(function(){
		var CDType = $("#genTypeID").val();
		var record=$('#genGrid').datagrid('getSelected');
		var hisRecord=$('#hisGrid').datagrid('getSelected');

		if(!record)
		{
			$.messager.alert('错误提示','请先选择一条临床知识库数据再进行对照！',"error");
			return;
		}
		var ids=record.CDCode+'^'+record.CDDesc+'^'+hisRecord.HisCode+'^'+hisRecord.HisDesc+'^'+dicID;
		
		runClassMethod("web.DHCCKBComContrast","SaveContrastData",{"listdata":ids,"loginInfo":LoginInfo,"clientIP":ClientIPAdd},function(jsonString){
			var jsonString=eval('('+jsonString+')'); 
			if (jsonString.success == 'true') {
				$.messager.popover({msg: '对照成功！',type:'success',timeout: 1000});
			}
			else{
				var errorMsg ="对照失败！"
				if (jsonString.info) {
					errorMsg =errorMsg+ '<br/>' + jsonString.info;
				}
				$.messager.alert('操作提示',errorMsg,"error");				
			}
			QueryHisList();
			QueryContrastList();
		},'text',false);
		
	},100);*/
	var selItems = $("#hisGrid").datagrid('getSelections');
	if(selItems.length==0)
	{
		$.messager.alert('提示',"请选择要对照的项目！","info");
		return false;
	}
	
	var type = $("#genTypeID").val();							//类型
	var libData = $('#genGrid').datagrid('getSelections');		//知识库项目  xww 2021-08-13 多选
	if(libData.length==0)
		{
			$.messager.alert('提示','请选择一条安全用药字典数据进行对照！',"info");
			return;
		}
	if((libData.length>1)&&((dicCode=="DrugData")||(dicCode=="ChineseDrugData")||(dicCode=="ChineseHerbalMedicineData"))){
		$.messager.alert('提示','安全用药库只能选择一条药品数据！',"info");
		return;
	}
	var dataList = []
	/*for(var i=0;i<selItems.length;i++)
	{
		var tmp = libData.CDCode +"^"+ libData.CDDesc +"^"+ selItems[i].HisCode +"^"+ selItems[i].HisDesc +"^"+ dicID;
		dataList.push(tmp);
	}*/
	for(var i=0;i<selItems.length;i++)
	{
		for(var j=0;j<libData.length;j++)
		{
			var tmp = libData[j].CDCode +"^"+ libData[j].CDDesc +"^"+ selItems[i].HisCode +"^"+ selItems[i].HisDesc +"^"+ dicID;
			dataList.push(tmp);
		}
	}
	var params=dataList.join("&&");
	var Hospt = $HUI.combobox("#HospId").getValue();
	runClassMethod("web.DHCCKBComContrast","saveConDataBat",{"params":params,"loginInfo":LoginInfo,"clientIP":ClientIPAdd,"selHospId":Hospt},function(jsonString){
			
			if (jsonString == '0') {
				$.messager.popover({msg: '对照成功！',type:'success',timeout: 1000});
			}else{
				var errorMsg ="对照失败！"
				$.messager.alert('操作提示',errorMsg+"错误代码："+jsonString,"error");				
			}
			QueryHisList();
			QueryContrastList();
	},'text',false);
}


//xww 2021-07-06 批量删除已对照项目
function deleteAllContrast(){	
	setTimeout(function(){
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			var contrastselItems = $("#contrastGrid").datagrid('getSelections');
			if(contrastselItems.length==0)
			{
				$.messager.alert('提示',"请选择已对照的项目！","info");
				return false;
			}
			var dataList = []
			for(var i=0;i<contrastselItems.length;i++)
			{
				var tmp = contrastselItems[i].CCRowID;
				dataList.push(tmp);
			}
			var params=dataList.join("&&");
			if (params === undefined){return} ;
			if (r){
				runClassMethod("web.DHCCKBComContrast","DeleteAllContrastData",{"params":params},function(jsonString){
					var jsonString=eval('('+jsonString+')'); 
					if (jsonString.success == 'true') {
						$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});												
					}
					else { 
						var errorMsg ="删除失败！"
						if (jsonString.info) {
							errorMsg =errorMsg+ '<br/>' + jsonString.info;
						}
						$.messager.alert('操作提示',errorMsg,"error");
					} 
					//QueryHisList();
					QueryContrastList();
				},"text",false);
			}
		})	
	},100)
}

function initPageStyle() {
	$('body .layout-panel-west .layout-panel-center').css("background-color", "#fff");
	if ((typeof HISUIStyleCode == "string") && (HISUIStyleCode == "lite")) {
  		$('body .layout-panel-west .layout-panel-center').css("background-color", "#F4F4F4");
	}
}
