/// 名称: 科室用户配置	
/// 描述: 平台配置-开启临床决策支持系统-科室用户配置
/// 编写者： 基础数据平台-李可凡
/// 编写日期: 2021-07-14

var init=function()
{
	var windowHight = document.documentElement.clientHeight;        //可获取到高度
	var windowWidth = document.documentElement.clientWidth;
	
	//医院 查询下拉框
	$('#TextHospital').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'HOSPRowId',
		textField:'HOSPDesc',
		onSelect:function(record){
			SearchLocFun();
		}
	});
	
	//	2022-06-24
	//alert(CDSSCodeStr);	//CDSSCode^HospId
	var CDSSCode=CDSSCodeStr.split("^")[0];
	var HospId=CDSSCodeStr.split("^")[1];
	if (HospId==""||HospId==undefined)
	{
		HospId=(session&&session['LOGON.HOSPID'])||"";
	}
	else
	{
		$("#TextHospital").combobox("disable");
	}
	$('#TextHospital').combobox('setValue',HospId);
	//alert($('#TextHospital').combobox("getValue"));
	
	var loc_grid=$HUI.datagrid('#loc_grid',{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.BDP.BDPCDSSDeptUserAut",
			QueryName:"GetLocList",
			hospid:HospId,
			cdsscode:CDSSCode
		},
		columns:[[	
				{field:'ck',checkbox:true},
				{field:'DeptID',title:'ID',width:40,sortable:true,hidden:true},  //,hidden:true
				{field:'DeptCode',title:'科室代码',width:80},
				{field:'DeptName',title:'科室描述',width:150},
				{field:'EnableFlag',title:'是否有权限',width:80,align:'center',formatter:ReturnFlagIcon
				}
				]],	
		width: (windowWidth-50)*0.6, 	
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:1000,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		singleSelect:false,
		remoteSort:false,
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true,
		onClickRow:function(index, row)
		{
			if (row.EnableFlag=="0")
			{
				$('#btnUserAble').linkbutton('disable');
				$('#btnUserDisable').linkbutton('disable');
									
			}
			else
			{
				$('#btnUserAble').linkbutton('enable');
				$('#btnUserDisable').linkbutton('enable');
			}
			IsShowImg(row)
			DeptJoinUser_Check(row.DeptID)
			
			
		},
		onLoadSuccess:function(data){
			IsShowImg("")
		}

	});
	// 勾选
	DeptJoinUser_Check=function(LocID)
	{
		//var record=$('#loc_grid').datagrid('getSelected')        
		var OldUserStr=tkMakeServerCall("web.DHCBL.BDP.BDPCDSSDeptUserAut","GetUsersByLocid",LocID,CDSSCode);
		oldUser=[]
		if (OldUserStr!="")
		{
			var userid=OldUserStr.split("^")
			
			for (var m=0;m<userid.length;m++)
			{     
				if (userid[m]=="") 
				{
					continue
				}          	                
				oldUser.push(userid[m]);
				var tindex=$("#user_grid").datagrid("getRowIndex",userid[m])
				if (tindex<0){
					continue
				}
				$("#user_grid").datagrid("selectRow", tindex);
					
			}
		}

	}
	var user_grid=$HUI.datagrid('#user_grid',{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.BDP.BDPCDSSDeptUserAut",
			QueryName:"GetUserList",
			cdsscode:CDSSCode
		},
		columns:[[	
				{field:'ck',checkbox:true},
				{field:'UserID',title:'ID',width:40,sortable:true,hidden:true},  //,hidden:true
				{field:'UserCode',title:'用户代码',width:80},
				{field:'UserDesc',title:'用户描述',width:100},
				{field:'EnableFlag',title:'是否有权限',width:80,align:'center',formatter:ReturnFlagIcon
				}
				]],		
		width: (windowWidth-50)*0.4, 
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:1000,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		singleSelect:false,
		remoteSort:false,
		//idField:'ID',
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true

	});
	ClearUserList=function ()
	{
		var record=$('#loc_grid').datagrid('getSelected') 
		if (record)
		{
			var LocID=record.DeptID 
			$('#UserSearch').searchbox('setValue',"")
			$('#UserEnableSearch').combobox("setValue","")
			$('#user_grid').datagrid('load', {
					ClassName: "web.DHCBL.BDP.BDPCDSSDeptUserAut", ///调用Query时
					QueryName: "GetUserList",
					deptdr:LocID,
					cdsscode:CDSSCode
			})
			
			$('#user_grid').datagrid('clearSelections')
			$('#user_grid').datagrid('clearChecked')
			DeptJoinUser_Check(LocID) 
		}
			
		
	}

	//是否显示图片
	 IsShowImg=function(rowData){
		if (rowData=="")
		{
			
			//清空中间属性列表，变为图片，改变标题
			if (document.getElementById('user_grid').style.display=="")   //如果是mygrid加载的状态
			{	
				$('#UserSearch').searchbox('setValue',"")
				$('#UserEnableSearch').combobox("setValue","")
				$('#user_grid').datagrid('loadData', { total: 0, rows: [] }); 
				document.getElementById('user_grid').style.display='none';  //隐藏mygrid
				$("#div-img").show();  //展示初始图片			
			}
		}
		else
		{
			document.getElementById('user_grid').style.display='';  //显示user_grid
			$("#div-img").hide();
			ClearUserList();
														
		 }
	 
	 }

	var oldUser=[]
	var newUser=[]
	//两个数组的差集 // 差集 a - b
	function array_difference(a, b) {
		//clone = a
		var clone = a.slice(0);
		for(var i = 0; i < b.length; i ++) {
			var temp = b[i];
			for(var j = 0; j < clone.length; j ++) {
				if(temp === clone[j]) {
					//remove clone[j]
					clone.splice(j,1);
				}
			}
		}
		return array_remove_repeat(clone);
	}
	//去重
	function array_remove_repeat(a) {
		var r = [];
		for(var i = 0; i < a.length; i ++) {
			var flag = true;
			var temp = a[i];
			for(var j = 0; j < r.length; j ++) {
				if(temp === r[j]) {
					flag = false;
					break;
				}
			}
			if(flag) {
				r.push(temp);
			}
		}
		return r;
	}
	 //用户权限添加
	$("#btnUserAble").click(function(e) {
		DoDeptJoinUser_Save(0)
	})
	 //用户权限删除
	$("#btnUserDisable").click(function(e) {
		DoDeptJoinUser_Save(1)
	})
	
	DoDeptJoinUser_Save=function(backflag)
	{
		var  addUserStr=""
		var  delUserStr=""
		var selectLoc=$("#loc_grid").datagrid("getSelected")
		
		if (selectLoc)
		{
			var LocID=selectLoc.DeptID
			var NewUserStr=""
			var UserRecord=$("#user_grid").datagrid("getSelections")
			if (UserRecord.length>0)
			{
				console.log(UserRecord)
				if (UserRecord.length>0){
					for (var n=0;n<UserRecord.length;n++)
					{
						if (NewUserStr=="")
						{
							NewUserStr=UserRecord[n].UserID
						}
						else
						{
							NewUserStr=NewUserStr+"^"+UserRecord[n].UserID
						}
					}
				}
			}
			else
			{
				$.messager.alert('提示','请至少选择一个用户!',"info");
				return
			}
		}
		else
		{
			return
		}
		if (backflag==0)	//添加权限
		{
			var message="保存成功！"
			var errorMsg="保存失败！"
			var result=tkMakeServerCall("web.DHCBL.BDP.BDPCDSSDeptUserAut","SaveDatas",LocID,NewUserStr,"",CDSSCode);
		}
		else   		//收回权限
		{
			var message="权限已收回！"
			var errorMsg="权限收回失败！"
			var result=tkMakeServerCall("web.DHCBL.BDP.BDPCDSSDeptUserAut","SaveDatas",LocID,"",NewUserStr,CDSSCode);
		}
		
		var data = eval('('+result+')');

		if (data.success == 'true') {
			$.messager.popover({msg: message,type:'success',timeout: 1000});
			ClearUserList()	                                                       
		}
		else{
			if (data.errorinfo) {
				errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
			}
			$.messager.alert('操作提示',errorMsg,"error");
		}
	}
	 //科室权限添加
	$("#btnLocAble").click(function(e) {
		var selectLoc=$("#loc_grid").datagrid("getSelections")
		if (selectLoc.length>0)
		{
			var LocStr=""
			for (var m=0;m<selectLoc.length;m++)
			{
				if  (selectLoc[m].DeptID=="")
				{
					continue
				}
				if (LocStr=="")
				{
					LocStr=selectLoc[m].DeptID
				}
				else{
					LocStr=LocStr+"^"+selectLoc[m].DeptID
				}
			}
			if (LocStr!=""){
				var result=tkMakeServerCall("web.DHCBL.BDP.BDPCDSSDeptUserAut","SaveLocs",LocStr,CDSSCode);
				if (result == 'true') {
					var message="保存成功！"
					$.messager.popover({msg: message,type:'success',timeout: 1000});
					$("#loc_grid").datagrid("reload")
				}
				else{

					$.messager.alert('操作提示',"保存失败！","error");
				}
			}
		}
		else
		{
			$.messager.alert('提示','请至少选择一个科室!',"info");
		}
		
	})
	 //科室权限删除
	$("#btnLocDisable").click(function(e) {
		var selectLoc=$("#loc_grid").datagrid("getSelections")
		if (selectLoc.length>0)
		{
			var LocStr=""
			for (var m=0;m<selectLoc.length;m++)
			{
				if  (selectLoc[m].DeptID=="")
				{
					continue
				}
				if (LocStr=="")
				{
					LocStr=selectLoc[m].DeptID
				}
				else{
					LocStr=LocStr+"^"+selectLoc[m].DeptID
				}
			}
			if (LocStr!=""){
				var result=tkMakeServerCall("web.DHCBL.BDP.BDPCDSSDeptUserAut","SaveLocs",LocStr,CDSSCode,1);
				if (result == 'true') {
					var message="收回权限成功！"
					$.messager.popover({msg: message,type:'success',timeout: 1000});
					$("#loc_grid").datagrid("reload")
				}
				else{

					$.messager.alert('操作提示',"收回权限失败！","error");
				}
			}
		}
		else
		{
			$.messager.alert('提示','请至少选择一个科室!',"info");
		}
	})
	//科室查询框

	$('#LocSearch').searchbox({
		searcher:function(value,name){
			SearchLocFun(value)
		}
	});

	$('#LocEnableSearch').combobox({ 
		data:[{
				'value':'',
				'text':'全部'
				},{
				'value':'0',
				'text':'无权限'
				},{
				'value':'1',
				'text':'有权限'
				}],
		valueField:'value',
		textField:'text',
		panelHeight:'auto',
		onSelect:function(record){
			SearchLocFun()
		}
	});
	//用户查询框
	$('#UserSearch').searchbox({
		searcher:function(value,name){
			SearchUserFun(value)
		}
	});

	$('#UserEnableSearch').combobox({ 
		data:[{
				'value':'',
				'text':'全部'
				},{
				'value':'0',
				'text':'无权限'
				},{
				'value':'1',
				'text':'有权限'
				}],
		valueField:'value',
		textField:'text',
		panelHeight:'auto',
		onSelect:function(record){
			SearchUserFun()
		}
	});
	var SearchUserFun=function(){
		var deptrecord=$('#loc_grid').datagrid("getSelected")
		if (!deptrecord)
		{
			$.messager.alert('提示','请先选择一个科室!',"info");
			return;
		}
		else{
			var deptdr=deptrecord.DeptID
			var user=$('#UserSearch').searchbox('getValue')
			var flag=$('#UserEnableSearch').combobox("getValue")
			$('#user_grid').datagrid('load', {
				ClassName: "web.DHCBL.BDP.BDPCDSSDeptUserAut", ///调用Query时
				QueryName: "GetUserList",
				'query': user,
				'deptdr':deptdr,
				'enableflag':flag,
				'cdsscode':CDSSCode
			})
		}
			
	}
	var SearchLocFun=function(){
		
		var locdesc=$('#LocSearch').searchbox('getValue')
		var flag=$('#LocEnableSearch').combobox("getValue")
		var texthosp=$('#TextHospital').combobox("getValue")
		$('#loc_grid').datagrid('load', {
			ClassName: "web.DHCBL.BDP.BDPCDSSDeptUserAut", ///调用Query时
			QueryName: "GetLocList",
			'query': locdesc,
			'enableflag':flag,
			'hospid':texthosp,
			'cdsscode':CDSSCode
		})							
	}
}
$(init);