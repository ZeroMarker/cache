//页面Gui
function InitCheckQueryWin(){
	var obj = new Object();		
    $.parser.parse(); // 解析整个页面
    obj.LgnRole="";
    obj.LgnRoleID="";
    obj.LgnRoleDesc="";
    
    //根据登录用户检查是否具有审核权限
    obj.LgnRole = $m({
		ClassName:"DHCMA.CPW.BTS.PathExamRoleSrv",
		MethodName:"GetPubExamRole",
		aUserID:session['LOGON.USERID'],
		aLocID:session['LOGON.CTLOCID'],
		aHospID:session['LOGON.HOSPID']
	},false);
	
	if(tDHCMedMenuOper['admin']<1){					//非管理权限
		if (parseInt(obj.LgnRole.split("^")[0])>0){
			for(var i=0;i<obj.LgnRole.split(CHR_1).length;i++){
				obj.LgnRoleID=obj.LgnRoleID + "," + obj.LgnRole.split(CHR_1)[i].split("^")[0];
				obj.LgnRoleDesc=obj.LgnRoleDesc + "," + obj.LgnRole.split(CHR_1)[i].split("^")[1];
			}
			obj.LgnRoleID=obj.LgnRoleID.substr(1,obj.LgnRoleID.length);
			obj.LgnRoleDesc=obj.LgnRoleDesc.substr(1,obj.LgnRoleDesc.length);
		}else{
			$.messager.alert("提示","您当前登录用户没有审核权限，请检查您的登录账号！","info");	
			return;
		}
	}
	
	 /* //获取当前审核角色并进行显示
	$("#div_search").panel({
	    title:"表单发布审核<span style='float:right;color:#666666;padding-right:10px;'>当前登录角色：" + obj.LgnRoleDesc + "</span>"
	})  */
    
    //院区
	obj.cboSSHosp = Common_ComboToSSHosp2("cboSSHosp",session['DHCMA.HOSPID'],"",1);
	$('#cboSSHosp').combobox({
  		 onSelect: function(title,index){
	  		 $('#cboLoc').combobox('reload');
	  	} 
	 })

    //科室
	obj.cboLoc = $HUI.combobox("#cboLoc",{
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.Util.EPS.LocationSrv",
			param.QueryName="QryLocInfo",
			param.aHospID=$("#cboSSHosp").combobox('getValue'),
			param.aAdmType="",
			param.aType="E",
			param.ResultSetType='array'	
		},
		editable: true,
		valueField: 'OID',
		textField: 'Desc',
		defaultFilter:4
	});

	obj.DateFrom = Common_SetValue('DateFrom',""); // 日期初始赋值 Common_GetDate(new Date())
	obj.DateTo = Common_SetValue('DateTo',"");
	
   //审核状态
   obj.chkStatus = $HUI.combobox('#chkStatus', {
		valueField: 'id',
		textField: 'text',
		value:'-1',
		data:[
			{id:'-1',text:'待审核'},
			{id:'1',text:'通过'},
			{id:'0',text:'未通过'}
		]
	});
	
	//审核角色
	obj.cboExamRole = $HUI.combobox('#cboExamRole',{
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.CPW.BTS.PathExamRoleSrv",
			param.QueryName="QryPathExamRole",
			param.aHospID=$("#cboSSHosp").combobox('getValue'),
			param.aIsActive="1",
			param.ResultSetType='array'	
		},
		loadFilter:function(data){
			if(tDHCMedMenuOper['admin']<1){
				for (var i = 0; i < data.length; i++) {
					if (obj.LgnRoleID.split(",").indexOf(data[i]["xID"])==-1){
						data.splice(i,1)
						i=i-1
					}	
				}
				return data
			}else return data;
			
		},
		editable: true,
		valueField: 'xID',
		textField: 'Desc',
		defaultFilter:4
			
	})
	
	//申请列表
   obj.GridPubCheck = $HUI.datagrid("#GridPubCheck",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		showGroup: true,
		groupField:'xFormID',
		view: groupview,
		groupFormatter:function(value, rows){
			if(value==undefined) return;
			return "路径信息："+rows[0].PathDesc + '（' + rows[0].FormVerNo +'）';
		},
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		nowrap:false,
		/* url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.ApplyExamRecDtlSrv",
			QueryName:"QryPubExamRec",
			aRoleIDStr: obj.LgnRoleID,
			aStatus: Common_GetValue('chkStatus'), 
			aDateFrom:Common_GetValue('DateFrom'), 
			aDateTo: Common_GetValue('DateTo'),
			aHospID:Common_GetValue('cboSSHosp'),
			aApplyLoc:Common_GetValue('cboLoc')
	    }, */
		columns:[[
			{field:'PathDesc',title:'路径名称',width:'200'},
			{field:'xFormID',title:'申请版本ID',width:'80',hidden:true},
			{field:'FormVerNo',title:'申请版本',width:'80'},
			{field:'ApplyLoc',title:'申请科室',width:'100'},
			{field:'ApplyUser',title:'申请人',width:'100'},
			{field:'ApplyDateTime',title:'申请时间',width:'200'},
			{field:'RoleName',title:'审核角色',width:'100'}, 
			{field:'ExamResult',title:'审核结果',width:'100',formatter:function(v,r,i){
				if (v==-1) return "待审核";
				if (v==0) return "未通过";
				if (v==1) return "通过";	
			}},
			{field:'Operation',title:'操作',width:'100',formatter:function(v,r,i){
				if (r.ExamResult==-1){
					return '<a href="#" onclick=ShowMsgExamForm(\"'+ r.xFormID +'\",\"'+ r.xRecDtlID +'\",\"'+ r.RolePrior +'\")>审核</a>';	
				}else{
					return '<a href="#" onclick=ShowMsgExamForm(\"'+ r.xFormID +'\",\"'+ r.xRecDtlID +'\",\"'+ r.RolePrior +'\")>查看</a>';			
				}	
			}},
			{field:'ExamOpinion',title:'审核意见',width:'300'}, 
			{field:'ExamUser',title:'审核人',width:'100'},	
			{field:'ExamDateTime',title:'审核时间',width:'200'}
		]] ,
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
	
	InitCheckQueryWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


