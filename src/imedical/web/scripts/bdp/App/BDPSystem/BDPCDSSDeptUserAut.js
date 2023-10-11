/// ����: �����û�����	
/// ����: ƽ̨����-�����ٴ�����֧��ϵͳ-�����û�����
/// ��д�ߣ� ��������ƽ̨-��ɷ�
/// ��д����: 2021-07-14

var init=function()
{
	var windowHight = document.documentElement.clientHeight;        //�ɻ�ȡ���߶�
	var windowWidth = document.documentElement.clientWidth;
	
	//ҽԺ ��ѯ������
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
				{field:'DeptCode',title:'���Ҵ���',width:80},
				{field:'DeptName',title:'��������',width:150},
				{field:'EnableFlag',title:'�Ƿ���Ȩ��',width:80,align:'center',formatter:ReturnFlagIcon
				}
				]],	
		width: (windowWidth-50)*0.6, 	
		pagination: true,   //pagination	boolean	����Ϊ true��������������datagrid���ײ���ʾ��ҳ��������
		pageSize:1000,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		singleSelect:false,
		remoteSort:false,
		rownumbers:true,    //����Ϊ true������ʾ�����кŵ��С�
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
	// ��ѡ
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
				{field:'UserCode',title:'�û�����',width:80},
				{field:'UserDesc',title:'�û�����',width:100},
				{field:'EnableFlag',title:'�Ƿ���Ȩ��',width:80,align:'center',formatter:ReturnFlagIcon
				}
				]],		
		width: (windowWidth-50)*0.4, 
		pagination: true,   //pagination	boolean	����Ϊ true��������������datagrid���ײ���ʾ��ҳ��������
		pageSize:1000,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		singleSelect:false,
		remoteSort:false,
		//idField:'ID',
		rownumbers:true,    //����Ϊ true������ʾ�����кŵ��С�
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
					ClassName: "web.DHCBL.BDP.BDPCDSSDeptUserAut", ///����Queryʱ
					QueryName: "GetUserList",
					deptdr:LocID,
					cdsscode:CDSSCode
			})
			
			$('#user_grid').datagrid('clearSelections')
			$('#user_grid').datagrid('clearChecked')
			DeptJoinUser_Check(LocID) 
		}
			
		
	}

	//�Ƿ���ʾͼƬ
	 IsShowImg=function(rowData){
		if (rowData=="")
		{
			
			//����м������б���ΪͼƬ���ı����
			if (document.getElementById('user_grid').style.display=="")   //�����mygrid���ص�״̬
			{	
				$('#UserSearch').searchbox('setValue',"")
				$('#UserEnableSearch').combobox("setValue","")
				$('#user_grid').datagrid('loadData', { total: 0, rows: [] }); 
				document.getElementById('user_grid').style.display='none';  //����mygrid
				$("#div-img").show();  //չʾ��ʼͼƬ			
			}
		}
		else
		{
			document.getElementById('user_grid').style.display='';  //��ʾuser_grid
			$("#div-img").hide();
			ClearUserList();
														
		 }
	 
	 }

	var oldUser=[]
	var newUser=[]
	//��������Ĳ // � a - b
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
	//ȥ��
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
	 //�û�Ȩ�����
	$("#btnUserAble").click(function(e) {
		DoDeptJoinUser_Save(0)
	})
	 //�û�Ȩ��ɾ��
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
				$.messager.alert('��ʾ','������ѡ��һ���û�!',"info");
				return
			}
		}
		else
		{
			return
		}
		if (backflag==0)	//���Ȩ��
		{
			var message="����ɹ���"
			var errorMsg="����ʧ�ܣ�"
			var result=tkMakeServerCall("web.DHCBL.BDP.BDPCDSSDeptUserAut","SaveDatas",LocID,NewUserStr,"",CDSSCode);
		}
		else   		//�ջ�Ȩ��
		{
			var message="Ȩ�����ջأ�"
			var errorMsg="Ȩ���ջ�ʧ�ܣ�"
			var result=tkMakeServerCall("web.DHCBL.BDP.BDPCDSSDeptUserAut","SaveDatas",LocID,"",NewUserStr,CDSSCode);
		}
		
		var data = eval('('+result+')');

		if (data.success == 'true') {
			$.messager.popover({msg: message,type:'success',timeout: 1000});
			ClearUserList()	                                                       
		}
		else{
			if (data.errorinfo) {
				errorMsg =errorMsg+ '<br/>������Ϣ:' + data.errorinfo
			}
			$.messager.alert('������ʾ',errorMsg,"error");
		}
	}
	 //����Ȩ�����
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
					var message="����ɹ���"
					$.messager.popover({msg: message,type:'success',timeout: 1000});
					$("#loc_grid").datagrid("reload")
				}
				else{

					$.messager.alert('������ʾ',"����ʧ�ܣ�","error");
				}
			}
		}
		else
		{
			$.messager.alert('��ʾ','������ѡ��һ������!',"info");
		}
		
	})
	 //����Ȩ��ɾ��
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
					var message="�ջ�Ȩ�޳ɹ���"
					$.messager.popover({msg: message,type:'success',timeout: 1000});
					$("#loc_grid").datagrid("reload")
				}
				else{

					$.messager.alert('������ʾ',"�ջ�Ȩ��ʧ�ܣ�","error");
				}
			}
		}
		else
		{
			$.messager.alert('��ʾ','������ѡ��һ������!',"info");
		}
	})
	//���Ҳ�ѯ��

	$('#LocSearch').searchbox({
		searcher:function(value,name){
			SearchLocFun(value)
		}
	});

	$('#LocEnableSearch').combobox({ 
		data:[{
				'value':'',
				'text':'ȫ��'
				},{
				'value':'0',
				'text':'��Ȩ��'
				},{
				'value':'1',
				'text':'��Ȩ��'
				}],
		valueField:'value',
		textField:'text',
		panelHeight:'auto',
		onSelect:function(record){
			SearchLocFun()
		}
	});
	//�û���ѯ��
	$('#UserSearch').searchbox({
		searcher:function(value,name){
			SearchUserFun(value)
		}
	});

	$('#UserEnableSearch').combobox({ 
		data:[{
				'value':'',
				'text':'ȫ��'
				},{
				'value':'0',
				'text':'��Ȩ��'
				},{
				'value':'1',
				'text':'��Ȩ��'
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
			$.messager.alert('��ʾ','����ѡ��һ������!',"info");
			return;
		}
		else{
			var deptdr=deptrecord.DeptID
			var user=$('#UserSearch').searchbox('getValue')
			var flag=$('#UserEnableSearch').combobox("getValue")
			$('#user_grid').datagrid('load', {
				ClassName: "web.DHCBL.BDP.BDPCDSSDeptUserAut", ///����Queryʱ
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
			ClassName: "web.DHCBL.BDP.BDPCDSSDeptUserAut", ///����Queryʱ
			QueryName: "GetLocList",
			'query': locdesc,
			'enableflag':flag,
			'hospid':texthosp,
			'cdsscode':CDSSCode
		})							
	}
}
$(init);