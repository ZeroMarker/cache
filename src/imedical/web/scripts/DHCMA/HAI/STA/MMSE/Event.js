//页面Event
function InitOROperCatWinEvent(obj){
	//按钮初始化
    obj.LoadEvent = function(args){
		var flag ="";		
		//obj.LoadgridOROper();
		
		//新增
		$('#btnAdd').on('click', function(){
			obj.OperCat('');
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridOperCat.getSelected();
			obj.OperCat(rd);
		});
		
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
	 	});
		$('#btnClose').on('click', function(){
		    $HUI.dialog('#OperCatEdit').close();
	    });				
	}

    obj.btnStatDesc_Click = function(param,code,desc)
	{	
		//alert(param);
		obj.reportName=param;
	    if(obj.reportName=='') return ;

		var url ="";
		if(obj.reportName.indexOf(".csp")>=0)
		{
			url = obj.reportName;
		}else{
			url = 'dhccpmrunqianreport.csp?report='+obj.reportName+'&reportName='+obj.reportName;
		}
	    //var url = IPAddress + 'dhccpmrunqianreport.jsp?report='+obj.reportName+'&reportName='+obj.reportName;		
		OpenMenu(code,desc,url);
	};
	
	// 菜单跳转
	function OpenMenu(menuCode,menuDesc,menuUrl) {
		var strUrl = '../csp/'+menuUrl+'?+&1=1';
		if ("undefined" !==typeof websys_getMWToken) {
			strUrl  += "&MWToken="+websys_getMWToken();
		}
		//主菜单
		var data = [{
			"menuId": "",
			"menuCode": menuCode,
			"menuDesc": menuDesc,
			"menuResource": strUrl,
			"menuOrder": "1",
			"menuIcon": "icon"
		}];
		if( typeof window.parent.showNavTab === 'function' ){   //bootstrap 版本
			window.parent.showNavTab(data[0]['menuCode'], data[0]['menuDesc'], data[0]['menuResource'], data[0]['menuCode'], data[0]['menuIcon'], false);
		}else{ //HISUI 版本
			window.parent.addTab({
				url:strUrl,
				title:menuDesc
			});
		}
	}
	
	//检索
	$('#searchcat').searchbox({ 
		searcher:function(value,name){
			obj.gridOperCat.load({
				ClassName:"DHCHAI.IRS.CRuleOperCatSrv",
				QueryName:"QryOperCat",
				aAlias:value
			});
		}	
	});
		
	
	//窗体初始化
	obj.OperCatEdit =function() {
		$('#OperCatEdit').dialog({
			title: '指标集导航维护',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true
		});
	}
	
	//编辑窗体-初始化
	obj.OperCat = function(rd){
		if (rd){
			obj.RecRowID=rd["ID"];
			//obj.RecKeyID=rd["KeyID"];
			//var OperCat = rd["OperCat"];
			$('#txtCode').val(rd["Code"]);
			$('#txtDesc').val(rd["Desc"]);
			$('#txtStatCode').val(rd["StatCode"]);
			$('#txtStatDesc').val(rd["StatDesc"]);
			$('#txtIndNo').val(rd["IndNo"]);
			$('#txtMethod').val(rd["Method"]);
		}else {
			$('#txtCode').val("");
			$('#txtDesc').val("");
			$('#txtStatCode').val("");
			$('#txtStatDesc').val("");
			$('#txtIndNo').val("");
			$('#txtMethod').val("");
		}
		$('#OperCatEdit').show();
		obj.OperCatEdit();
	}
	//双击编辑事件
	obj.gridOperCat_onDbselect = function(rd){
		obj.OperCat(rd);
	}
	
	//选择
	obj.gridOperCat_onSelect = function (){
		var rowData = obj.gridOperCat.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridOperCat.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	
	//保存
	obj.btnSave_click = function(){
		var ID          = obj.RecRowID;		
				
		var Code     = $('#txtCode').val();
		var Desc     = $('#txtDesc').val();
		var StatCode = $('#txtStatCode').val();
		var StatDesc = $('#txtStatDesc').val();
		var IndNo    = $('#txtIndNo').val();	
		var Method   = $('#txtMethod').val();
		
		if (Code == '') {
			$.messager.alert("错误提示", "统计指标代码不允许为空" , 'info');	
			return;
		}
		if (Desc == '') {
			$.messager.alert("错误提示", "统计指标名称不允许为空" , 'info');
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + StatCode;
		InputStr += "^" + StatDesc;
		InputStr += "^" + IndNo;
		InputStr += "^" + Method;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID;
				
		var flg = $m({
			ClassName:"DHCHAI.STA.Navigation",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-2') {
				$.messager.alert("错误提示", "统计指标代码重复!" , 'info');	
				return;	
			}else {
				$.messager.alert("错误提示", "保存失败！" , 'info');	
				return;	
			}
		}else {
			$HUI.dialog('#OperCatEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID="";
			obj.gridOperCat.reload();
		}
	}
	
	//删除
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.STA.Navigation",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert('删除失败!','info');					
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridOperCat.reload();
				}
			} 
		});
	}

	
}