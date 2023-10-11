//页面Event
function InitCheckQueryWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
		//查询
		$('#btnQuery').on('click', function(){
			obj.CheckQueryLoad();
		});
	}
	
  	// 重新查询事件
	obj.CheckQueryLoad = function(){
		$('#GridPubCheck').datagrid('loadData',{total:0,rows:[]});
		var strRoleID=$('#cboExamRole').combobox('getValue')
		if (strRoleID == ""){
			var arrDataRole=$('#cboExamRole').combobox('getData');
			$.each(arrDataRole, function(index, item){
				strRoleID=strRoleID + "," + item["xID"]
			})
			strRoleID = strRoleID.substr(1,strRoleID.length)	
		}
		
		$cm ({
			ClassName:"DHCMA.CPW.BTS.ApplyExamRecDtlSrv",
			QueryName:"QryPubExamRec",
			aRoleIDStr: strRoleID,
			aStatus: Common_GetValue('chkStatus'), 
			aDateFrom:Common_GetValue('DateFrom'), 
			aDateTo: Common_GetValue('DateTo'),
			aHospID:Common_GetValue('cboSSHosp'),
			aApplyLoc:Common_GetValue('cboLoc'),
			page:1,
			rows:9999
		},function(rs){
			if (rs.rows.length==0) $.messager.popover({msg: '没有符合条件的数据！',type:'info',timeout: 1000});
			else $('#GridPubCheck').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});	
    }
	
	//弹出表单审核页面
	ShowMsgExamForm = function(FormID,RecDtlID,RolePrior){
	    var FormUrl="./dhcma.cpw.bt.msgexamform.csp?PathFormID="+FormID+"&PriorNo="+RolePrior+"&RecDtlID="+RecDtlID+"&1=1";
		websys_showModal({
			url:FormUrl,
			title:'路径发布审核',
			iconCls:'icon-w-list',  
			closable:true,
			originWindow:window,
			width:"90%",
			height:"95%",
			onClose:function(){
				obj.CheckQueryLoad();
			}
		});	
	}
}