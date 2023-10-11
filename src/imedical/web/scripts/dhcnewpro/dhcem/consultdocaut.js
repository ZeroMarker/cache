/// author:    bianshuai
/// date:      2018-06-20
/// descript:  请会诊医生权限维护

var userID = "";   /// 用户ID
/// 页面初始化函数
function initPageDefault(){
	
	init(); //hxy 2020-05-27 初始化医院
	
	//初始化咨询信息列表
	InitMain();
	
	//初始化界面按钮事件
	InitWidListener();
	
}

function init(){
	hospComp = GenHospComp("DHC_EmConsDocAut");  //hxy 2020-05-27 st
	hospComp.options().onSelect = function(){///选中事件
		clearPanel();
		runClassMethod("web.DHCEMConsDicItem","GetConsItem",{mCode:"CYT",HospID:hospComp.getValue()},
		function(jsonString){
			$("#ConType").html("");
			var html="";
			var Str=jsonString.split("||");
			for (i=0; i<Str.length; i++) {
				if(Str[i]==""){continue;}
				var TID=Str[i].split("^")[0];
				var TCode=Str[i].split("^")[1];
				var TDesc=Str[i].split("^")[2];
				html=html+"<input id='"+TID+"' class='hisui-checkbox' name='CstType' type='checkbox' data-index='"+TCode+"' label='"+TDesc+"'>";
			}
			$("#ConType").html(html);
			$HUI.checkbox("#ConType input.hisui-checkbox",{});
		},'text',false)

		query();
		InitMain();
	}//ed
}

/// 界面元素监听事件
function InitWidListener(){
	
	$('#userCode').bind('keypress',function(event){
        if(event.keyCode == "13"){
	        findUserInfo();
	    }
    });
    
    // 点击事件  无权限控制
    $('#ConType').on('click','[name="CstType"]',function(){
		 if ($(this).attr("data-index") == "DOCNUR01"){
	     	$HUI.checkbox('input:not([data-index^="DOCNUR01"])').setValue(false);
	     }else{
		 	$HUI.checkbox('input[data-index="DOCNUR01"]').setValue(false);
		 	 //$HUI.checkbox("#"+this.id).disable();
		 }
	})
}

///初始化病人列表
function InitMainList(columns){
	
	/**
	 * 定义columns
	 */

	var fcolumns=[[
		{field:'userID',title:'userID',width:100,hidden:true,align:'center'},
		{field:'userCode',title:'工号',width:100,align:'center'},
		{field:'userName',title:'姓名',width:150,align:'center'}
	]];

	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		frozenColumns:fcolumns,
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
	    onClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
			userID = rowData.userID;
			$("#userCode").val(rowData.userCode);    //工号
			$("#userName").val(rowData.userName);    //姓名
			
			$('input[name="CstType"]').each(function(){
				$HUI.checkbox("#"+this.id).setValue(rowData["T"+this.id]=="是"?true:false);
				if ($("#"+this.id).attr("data-index").indexOf(rowData["ProvType"]) == "-1"){
					$HUI.checkbox("#"+this.id).disable();
				}else{
					$HUI.checkbox("#"+this.id).enable();
				}
			})
        },
		onLoadSuccess:function(data){
			if (data.rows.length == 1){
				$('input[name="CstType"]').each(function(){
					$HUI.checkbox("#"+this.id).setValue(data.rows[0]["T"+this.id]=="是"?true:false);
					if ($("#"+this.id).attr("data-index").indexOf(data.rows[0]["ProvType"]) == "-1"){
						$HUI.checkbox("#"+this.id).disable();
					}else{
						$HUI.checkbox("#"+this.id).enable();
					}
				})
			}
		}
	};
	
	var uniturl = $URL+"?ClassName=web.DHCEMConsDocAut&MethodName=QryConsDocAut&HospID="+hospComp.getValue(); //hxy 2020-05-28 原：session['LOGON.HOSPID']
	new ListComponent('main', columns, uniturl, option).Init();

}

/// 保存
function saveRow(){
	
	var usercode = $('#userCode').val();
	if (usercode == ""){
		$.messager.alert('提示','用户工号不能为空！','warning');
		return;
	}
	
	/// 会诊类型
	var CstTypeArr = [];
	$('input[name="CstType"]').each(function(){
		var TypeFlag = $("#"+this.id).is(':checked')?"Y":"N";
		CstTypeArr.push(this.id +":"+ TypeFlag);
	})
	var mParam = CstTypeArr.join("^");

	//保存数据
	runClassMethod("web.DHCEMConsDocAut","save",{"userID":userID, "mParam":mParam,"HospID":hospComp.getValue()},function(jsonString){ //hxy 2020-05-28

		if (jsonString < 0){
			$.messager.alert('提示','保存失败！','warning');
			return;	
		}else{
			clearPanel(); /// 清空面板
		}
		$('#main').datagrid('reload'); //重新加载
	})
}

/// 清空面板
function clearPanel(){
	
	userID = "";
	$("#userCode").val("");    //工号
	$("#userName").val("");    //姓名
	$('input[name="CstType"]').each(function(){
		$HUI.checkbox("#"+this.id).setValue(false);
	})
}

/// 插入新行
function insertRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#main").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#main').datagrid('selectRow',0);
			$("#main").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#main").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'是', HospID:'', HospDesc:''}
	});
	$("#main").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 删除选中行
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCEMConsDocAut","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#main').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 提取会诊类型列
function InitMain(){
	
	// 获取显示数据
	runClassMethod("web.DHCEMConsDocAut","jsonConsItem",{"mCode":"CYT", "HospID":hospComp.getValue()},function(jsonString){ //hxy 2020-05-28 session['LOGON.HOSPID']

		if (jsonString != null){
			InitMainList(jsonString)
		}
	},'json',false)
}

/// 根据用户工号查询用户信息
function findUserInfo(){
	
	var usercode = $('#userCode').val();
	if (usercode == ""){
		$.messager.alert('提示','请输入工号后,回车查询！','warning');
		return;
	}
	
	// 获取显示数据
	runClassMethod("web.DHCEMConsDocAut","JsonUserInfo",{"userCode":usercode,"HospID":hospComp.getValue()},function(jsonObject){ //hxy 2020-05-28 add HospID

		if (jsonObject != null){
			userID = jsonObject.UserID;
			$("#userCode").val(jsonObject.UserCode);    //工号
			$("#userName").val(jsonObject.UserName);    //姓名
			
			$('input[name="CstType"]').each(function(){
				$HUI.checkbox("#"+this.id).setValue(false);
				if ($("#"+this.id).attr("data-index").indexOf(jsonObject["ProvType"]) == "-1"){
					$HUI.checkbox("#"+this.id).disable();
				}else{
					$HUI.checkbox("#"+this.id).enable();
				}
			})
			$("#main").datagrid("load",{"mUserID":userID,"HospID":hospComp.getValue()}); //hxy 2020-05-28 原：session['LOGON.HOSPID']
		}
	},'json',false)
}

/// 查询
function query(){
	$("#main").datagrid('loadData',{total:0,rows:[]}); //hxy 2020-05-28
	$("#main").datagrid("load",{"mUserID":"","HospID":hospComp.getValue()}); //hxy 2020-05-28 原：session['LOGON.HOSPID']
}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })